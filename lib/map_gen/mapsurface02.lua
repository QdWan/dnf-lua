local lm = love.math

local util = require("lib.util")
local Rect = require("lib.rect")

local map_gen_base = require("lib.map_gen.base")
local creator = require("lib.map_gen.creator")

local Graph = map_gen_base.Graph
local MapCreator = creator.MapCreator


local W = 31
local H = 31

-- neighbors cache for various radius
local neighborhood = {}

local function neighbors(map, x, y, r)
    local index = util.cantor(x, y, r)
    local nodes = neighborhood[index]

    if nodes ~= nil then
        return nodes
    else
        nodes = {}
        neighborhood[index] = nodes
    end

    r = r or 1
    for _i = -r, r do
        local i = _i + r
        for _j = -r, r do
            local j = _j + r
            local node = map:get(i, j)
            if node then
                nodes[#nodes + 1] = node
            end
        end
    end
    return nodes
end

local function get_hnv(nodes)
    local max_val = -math.huge
    for _, node in ipairs(nodes) do
        local v = node.value
        if v > max_val then
            max_val = v
        end
    end
    return max_val
end

local function get_lnv(nodes)
    local min_val = math.huge
    for _, node in ipairs(nodes) do
        local v = node.value
        if v < min_val then
            min_val = v
        end
    end
    return min_val
end


local HeightmapBase = class("HeightmapBase", MapCreator)

function HeightmapBase:create(header)
    self.header = header
    local w, h = self:adjust_size(W, H)
    print("HeightmapBase:create", w, h)
    MapCreator.create(self, w, h)  -- super
end

function HeightmapBase:print_stats()
    local w, h = self.cols, self.rows

    local map = self.map
    local max = math.max
    local min = math.min
    local _max = -math.huge
    local _min = math.huge
    local sum = 0
    local w, h = self.cols, self.rows

    for x = 1, w do
        for y = 1, h do
            local v = map:get(x, y).value
            if v == nil then
                print(string.format(
                    "x(%d) <> w(%d) y(%d) <> h(%d)",
                    x, w, y, h))
            end
            _max = max(_max, v)
            _min = min(_min, v)
            sum = sum + v
        end
    end
    local avg = sum / #self.map.nodes

    print(string.format(
        "max %.4f, min:%.4f, avg:%.4f.",
        _max, _min, avg))

    return _max, _min, avg
end

function HeightmapBase:init_grid(t)
    --[[
    Fill grid.
    ]]--
    local t = t or {}
    local v = t.v or 0
    local noise = t.noise or false
    local rnd = t.rnd or false
    local map = self.map
    local nodes = self.map.nodes
    local w, h = self.cols, self.rows
    print("Initializing grid... ")
    local t0 = manager.time()

    local get_noise = function(x, y)
        return lm.noise(x + lm.random(), y + lm.random())
    end
    local get_random = function(x, y)
        return lm.random()
    end

    local fill
    if noise then
        fill = get_noise
    elseif rnd then
        fill = get_random
    else
        fill = false
    end

    local i = 0
    for x = 1, w do
        for y = 1, h do
            i  = i + 1
            local node = map:get(x, y)
            local nv = fill and fill(x, y) or v
            -- print(assert(nv >= 0 and nv < 1 and nv), x, y, w, h, i)
            node.value = nv
        end
    end
    local t1 = manager.time()

    self:print_stats()
    print(string.format("Done! (Time: %.2f's)", t1 - t0))
end

function HeightmapBase:deposition(k)
    local k = k or 0.75

    local random = lm.random
    local map = self.map
    local nodes = self.map.nodes
    -- randint = self.random.randint
    -- randrange = self.random.randrange
    local w, h = self.cols, self.rows

    self:print_stats()
    print("Starting Particle Deposition...")
    local t0 = manager.time()

    local n = 1.0
    local area = (w * h)
    local step = n / area * 0.70
    local i = 0
    local x, y
    local sector_size = area / 40
    local stuck_count = 0

    while n > 0 do
        stuck_count = stuck_count + 1
        if stuck_count > w * h * ((w + h) / 2) then
            break
            -- Stuck at deposition
        end
        local continue = false
        if not x or not y or (i > sector_size * 1.1) then
            -- Pick a new spot
            x = random(w)
            y = random(h)
            i = 0
            self:print_stats()
        else
            -- Walk in a direction
            local choice = random(4)
            if choice == 4 then
                 x = x + 1
            elseif choice == 3 then
                 x = x - 1
            elseif choice == 2 then
                 y = y + 1
            else
                 y = y - 1
            end
        end

        x = ((x - 1) % w) + 1
        y = ((y - 1) % h) + 1

        if random(2) == 2 then
            local node = map:get(x, y)
            local v = node.value
            node.value = v * (1 - k) + n * k
        else
            local node = map:get(x, y)
            local v = node.value
            if v > 0.8 then
                if random(2) == 2 then
                    self:erode(x, y)
                end
            elseif v < 0.5 then
                self:erupt(x, y)
            else
                continue = true
            end
        end
        if continue == true then
            n = n - step
            i = i + 1
        end
    end

    local t1 = manager.time()
    self:print_stats()
    print(string.format("Done! (Time: %.2f's)", t1 - t0))
end

local function midpoint(a, b)
    return math.ceil((b - a) / 2) + a
end

local function get_pos(map, pos)
    return map:get(pos[1], pos[2])
end

function HeightmapBase:initialize_pos(v, t)
    print("HeightmapBase:initialize_pos", #t)
    local map = self.map
    for i, pos in ipairs(t) do
        get_pos(map, pos).value = v
    end
end

local function random_k(k)
    local v = ((love.math.random() * 2) - 1) * k
    print("random_k", k, "->", v)
    return v
end

function HeightmapBase:diamond_step(rect, k)
    --[[Perform the diamond step.

    Taking a square of four points, generate a random value at the square midpoint, where the two diagonals meet. The midpoint value is calculated by averaging the four corner values, plus a random amount.
    ]]--
    --[[
    ]]--

    print("HeightmapBase:diamond_step",
          rect.x, rect.y, rect.right, rect.bottom, rect.w, rect.h)
    local map = self.map

    local tl = get_pos(map, rect.topleft)
    local tr = get_pos(map, rect.topright)
    local bl = get_pos(map, rect.bottomleft)
    local br = get_pos(map, rect.bottomright)
    local center = get_pos(map, rect.center)
    local avg = (tl.value + tr.value + bl.value + br.value) / 4
    local noise = random_k(k)
    center.value = avg + noise
    print(string.format(
        "HeightmapBase:diamond_step:done (avg %.4f, noise %.4f, final %.4f",
        avg, noise, center.value))
end

function HeightmapBase:square_step(rect, k)
    --[[Perform the square step.

    Set the four mid points between the corners, i.e. North, South, East and West, by averaging the two values on either side of the point in question and adding or subtracting a slightly smaller random amount of noise. This is the 'square' step.
    ]]--
    local map = self.map
    local low = k / 2
    local v, noise
    local noise = random_k(low)
    --[[
    ]]--

    print("HeightmapBase:square_step",
          rect.x, rect.y, rect.right, rect.bottom, rect.w, rect.h, noise)

    local mt = get_pos(map, rect.midtop)
    local tl = get_pos(map, rect.topleft)
    local tr = get_pos(map, rect.topright)
    v = (tl.value + tr.value) / 2
    --[[
    mt.value = (1 - low) * v + (low * noise)
    ]]--
    mt.value = noise + v
    print(string.format(
        "diamond_step:square_step mt(avg %.4f, noise %.4f, final %.4f",
        v, noise, mt.value))

    local mr = get_pos(map, rect.midright)
    local br = get_pos(map, rect.bottomright)
    v = (tr.value + br.value) / 2
    --[[

    mr.value = (1 - low) * v + (low * noise)
    ]]--
    mr.value = noise + v
    print(string.format(
        "diamond_step:square_step mr(avg %.4f, noise %.4f, final %.4f",
        v, noise, mr.value))

    local mb = get_pos(map, rect.midbottom)
    local bl = get_pos(map, rect.bottomleft)
    v = (br.value + bl.value) / 2
    --[[
    mb.value = (1 - low) * v + (low * noise)
    ]]--
    mb.value = noise + v
    print(string.format(
        "diamond_step:square_step mb(avg %.4f, noise %.4f, final %.4f",
        v, noise, mb.value))

    local ml = get_pos(map, rect.midleft)
    v = (tl.value + bl.value) / 2
    --[[
    ml.value = (1 - low) * v + (low * noise)
    ]]--
    ml.value = noise + v
    print(string.format(
        "diamond_step:square_step ml(avg %.4f, noise %.4f, final %.4f",
        v, noise, ml.value))
    print("HeightmapBase:square_step: done")
end

function HeightmapBase:apply_diamond_square(k, start)
    log:warn("HeightmapBase:apply_diamond_square: start")
    local rects = {[start] = true}
    local used
    local k = k
    while true do
        local check = false
        for rect, _ in pairs(rects) do
            self:diamond_step(rect, k)
            check = rect
        end
        for rect, _ in pairs(rects) do
            self:square_step(rect, k)
        end
        used, rects = rects, {}
        if check.w >= 4 then -- can divide
            print(
                "HeightmapBase:apply_diamond_square (divide)",
                check.x, check.y, check.right, check.bottom, check.w, check.h)
            for rect, _ in pairs(used) do
                local divided = rect:divide()
                for _, new in ipairs(divided) do
                    rects[new] = true
                end
            end
            k = k / 2
        else  -- done
            break
        end
    end
    log:warn("HeightmapBase:apply_diamond_square: done")
end

function HeightmapBase:diamond_square(left, top, right, bottom)
    local start = Rect(1, 1, self.cols - 1, self.rows - 1)
    print("HeightmapBase:diamond_square", start.w, start.h)
    self:initialize_pos(
        1,
        {start.topleft, start.topright, start.bottomleft, start.bottomright})
    self:apply_diamond_square(self.k, start)
    self:normalize()
end
function HeightmapBase:normalize()
    print("HeightmapBase:normalize")

    local nodes = self.map.nodes

    local min_v, max_v = math.huge, -math.huge

    for _, node in ipairs(nodes) do
        min_v = math.min(min_v, node.value)
        max_v = math.max(max_v, node.value)
    end

    local range = max_v -min_v

    self:print_stats()

    for _, node in ipairs(nodes) do
        local old_v = node.value
        local new_v = (old_v - min_v) / range
        node.value = new_v
    end
    self:print_stats()

end
function HeightmapBase:erupt_grid(param)
    --[[Apply erupt effect on the grid n times.
    ]]--
    local k = param.k or 0.50
    local r = param.r or 1
    local n = param.n or 1
    local param = {k=k, r=r}

    local w, h = self.cols, self.rows

    self:print_stats()
    print("Starting Global Erupt...")
    local t0 = manager.time()

    for i = 1, n do
        for x = 1, w do
            for y = 1, h do
                self:erupt(x, y, param)
            end
        end
    end


    local t1 = manager.time()
    self:print_stats()
    print(string.format("Done! (Time: %.2f's)", t1 - t0))
end

function HeightmapBase:erode_grid(param)
    --[[Apply erode effect on the grid n times.]]--
    local k = param.k or 0.50
    local r = param.r or 1
    local n = param.n or 1
    local param = {k=k, r=r}

    local w, h = self.cols, self.rows

    self:print_stats()
    print("Starting Global Erupt...")
    local t0 = manager.time()

    for i = 1, n do
        for x = 1, w do
            for y = 1, h do
                self:erode(x, y, param)
            end
        end
    end

    local t1 = manager.time()
    self:print_stats()
    print(string.format("Done! (Time: %.2f's)", t1 - t0))
end

function HeightmapBase:erupt(x, y, param)
    --[[Raise a value by k times its highest neighbor value(hnv).

    Higher k values result in a greater changes.
    No changes are made unless hnv is higher then the current value.
    ]]--
    local param = param or {}
    local k = param.k or 0.50
    local r = param.r or 1
    -- highest neighbor value
    local nodes = neighbors(self.map, x, y, r)
    local hnv = get_hnv(nodes)

    local node = self.map:get(x, y)
    local value = node.value

    local new = hnv * k + value * (1 - k)

    node.value = new > value and new or value
end

function HeightmapBase:erode(x, y, param)
    --[[Lower a value by k times its lowest neighbor value(lnv).

    Higher k values result in a greater changes.
    No changes are made unless hnv is lower then the current value.
    ]]--
    local param = param or {}
    local k = param.k or 0.50
    local r = param.r or 1

    local nodes = neighbors(self.map, x, y, r)
    local lnv = get_lnv(nodes)

    local node = self.map:get(x, y)
    local value = node.value

    local new = lnv * k + value * (1 - k)
    node.value = new < value and new or value
end

function HeightmapBase:smoothe(param)
    local param = param or {}
    local times = param.times or 1
    local k = param.k or 0.80
    local mode = param.mode or 0
    local map = self.map

    local w, h = self.cols, self.rows

    local function get(_x, _y)
        local x = ((_x - 1) % w) + 1
        local y = ((_y - 1) % h) + 1
        return map:get(x, y)
    end

    local directions = {
        {dx = -1, dy = 0},  -- Rows, left to right
        {dx = 1, dy = 0},  -- Rows, right to left
        {dx = 0, dy = -1},  -- Columns, top to bottom
        {dx = 0, dy = 1},  -- Columns, bottom to top
    }

    if mode == 0 then
        for i = 1, times do
            print(string.format("Smoothing step %d...", i))
            local t0 = manager.time()
            for _, dir in ipairs(directions) do
                local dx = dir.dx
                local dy = dir.dy
                for x = 1, w do
                    for y = 1, h do
                        local node = get(x, y)
                        local other_v = get(x +dx, y + dy).value
                        node.value = other_v * (1 - k) + node.value * k
                    end
                end
            end
            local t1 = manager.time()
            self:print_stats()
            print(string.format("Done! (Time: %.2f's)", t1 - t0))
        end
    end
end

function HeightmapBase:set_base_feature()
    local function get_feature(v)
        if v > 0.7 then
            return "mountain"
        elseif v > 0.6 then
            return "hill"
        elseif v > 0.4 then
            return "land"
        elseif v > 0.28 then
            return "coast"
        elseif v > 0.2 then
            return "shallow_water"
        else
            return "deep_water"
        end
    end

    local w, h = self.cols, self.rows
    for x = 1, w do
        for y = 1, h do
            local node = self.map:get(x, y)
            node.template = get_feature(node.value)
        end
    end
end


local NoiseMap = class("NoiseMap", Graph)

function NoiseMap:create_node(x, y)
    local node = Graph.create_node(self, x, y)  -- super
    node.value = lm.noise(x + lm.random(), y + lm.random())
    return node
end

local LatitudinalHeatMap = class("LatitudinalHeatMap", Graph)

function LatitudinalHeatMap:create_node(x, y)
    local floor = math.floor
    local node = Graph.create_node(self, x, y)  -- super
    local v = math.sin((y / self.h) * math.pi)
    node.value = v
    node.template = "heat_view"
    node.color = {floor(v * 255), 0, floor((1 - v) * 255)}
    return node
end


local PrecipitationMap = class("PrecipitationMap", Graph)

function PrecipitationMap:initialize(w, h, parent)
    self.parent = parent
    Graph.initialize(self, w, h)  -- super
end

local function get_lnv(nodes)
    local min_val = math.huge
    for _, node in ipairs(nodes) do
        local v = node.value
        if v < min_val then
            min_val = v
        end
    end
    return min_val
end

local function get_water_ratio(nodes)
    local count = 0
    for _, node in ipairs(nodes) do
        local template = node.template
        if template == "shallow_water" or template == "deep_water" then
            count = count + 1
        end
    end
    return count / #nodes
end

local function precipitation(height, heat, water_ratio)
    return ((1 - height) * 0.25 +
            heat * 0.4 +
            water_ratio * 0.35)
end

function PrecipitationMap:create_node(x, y)
    local floor = math.floor
    local node = Graph.create_node(self, x, y)  -- super
    local height = self.parent._heightmap:get(x, y).value
    local heat = self.parent._heat_map:get(x, y).value

    local height_neighbors = neighbors(self.parent._heightmap, x, y, 5)
    local water_ratio = get_water_ratio(height_neighbors)
    local v = precipitation(height, heat, water_ratio)
    node.value = v
    node.template = "rainfall_view"
    node.color = {floor((1 - v) * 255), 0, floor(v * 255)}
    return node
end


local function compose_biome(n, _height, _heat, rain)
    local height = _height * 0.95 + n * 0.05
    local height2 = _height * 0.90 + n * 0.1
    local heat = _heat * 0.70 + (1 - rain) * 0.20 + n * 0.1
    local heat2 = _heat * 0.70 + (1 - rain) * 0.15 + n * 0.15

    if heat2 < 0.33 then
        if height <= 0.2 then
            return "arctic_deep_water"
        elseif height <= 0.27 then
            return "arctic_shallow_water"
        elseif height <= 0.32 then
            return "arctic coast"
        elseif 0.78 < height2 and height2 < 0.82 then
            return "arctic mountain"
        elseif 0.70 < height2 and height2 < 0.72 then
            return "arctic hill"
        else  -- arctic
            return "arctic land"
        end
    end

    if height <= 0.22 then
        return "deep_water"
    elseif height <= 0.27 then
        return "shallow_water"
    -- temperate
    elseif heat2 < 0.52 then
        if height <= 0.31 then
            return "coast"
        elseif (0.79 < height2 and height2 < 0.82) or 0.95 < height then
            return "mountain"
        elseif 0.70 < height2 and height2 < 0.72 then
            return "hill"
        elseif rain < 0.25 and (0.44 < height2 and height2 < 0.5) then
            return "temperate desert"
        elseif rain < 0.29 then
            return "boreal grassland"
        else
            return "boreal forest"
        end
    -- subtropical/temperate
    elseif heat2 < 0.77 then
        if height <= 0.31 then
            return "coast"
        elseif (0.79 < height2 and height2 < 0.82) or 0.95 < height then
            return "mountain"
        elseif 0.70 < height2 and height2 < 0.72 then
            return "hill"
        elseif rain < 0.32 and (0.44 < height2 and height2 < 0.5) then
            return "subtropical desert"
        elseif rain < 0.38 and (height2 < 0.39) then
            return "woodland"
        elseif rain < 0.45 and (height2 < 0.45) then
            return "temperate deciduous forest"
        elseif rain >= 0.45 or (0.55 < height2 and height2 < 0.6) then
            return "temperate rain forest"
        else
            return "grassland"
        end
    -- tropical
    else
        if height <= 0.32 and rain > 0.34 then
            return "coast"
        elseif (0.79 < height2 and height2 < 0.82) or 0.90 < height then
            return "mountain"
        elseif 0.70 < height2 and height2 < 0.72 then
            return "hill"
        elseif rain >= 0.49 and ((0.35 < height2 and height2 < 0.44) or
                               height >= 0.55) then
            return "tropical rain forest"
        elseif heat > 0.80 and (height2 > 0.76 or rain < 0.30) then
            return "tropical desert"
        else
            return "savana"
        end
    end
end

local CompositeBiomeMap = class("CompositeBiomeMap", Graph)

function CompositeBiomeMap:initialize(w, h, parent)
    self.parent = parent
    Graph.initialize(self, w, h)  -- super
end

function CompositeBiomeMap:create_node(x, y)
    local node = Graph.create_node(self, x, y)  -- super

    local n = self.parent._noise:get(x, y).value
    local height = self.parent._heightmap:get(x, y).value
    local heat = self.parent._heat_map:get(x, y).value
    local rain = self.parent._rainfall_map:get(x, y).value

    node.template = compose_biome(n, height, heat, rain)
    return node
end


local function apply_tiling(map)
    print("apply_tiling")
    local nodes = map.nodes
    for i, node in pairs(nodes) do
        local node = nodes[i]
        local tile = node.tile
        -- print(node, tile.template, tile.id)
        if tile.image == "ascii" then
            tile.tile_pos = tile.id
        end
    end
end


local MapSurface02 = class("MapSurface02", HeightmapBase)

function MapSurface02:create(header)
    HeightmapBase.create(self, header)  -- super
    self:init_grid{v=0.09}
    self:deposition()

    self:erupt_grid{k=0.2}

    self:smoothe{times=1, k=0.60, mode=0}
    self:set_base_feature()

    local w, h = self.cols, self.rows
    self._noise = NoiseMap(w, h)
    self._heightmap = self.map
    self._heat_map = LatitudinalHeatMap(w, h)
    self._rainfall_map = PrecipitationMap(w, h, self)
    self.map = CompositeBiomeMap(w, h, self)

    local function prepare_map(graph, type)
        local _ = graph.prepare and graph:prepare(self)
        graph = self:standard_map(graph)
        apply_tiling(graph)
        return graph
    end

    local height = prepare_map(self._heightmap)
    local heat = prepare_map(self._heat_map)
    local rainfall = prepare_map(self._rainfall_map)
    local biomes = prepare_map(self.map)
    biomes.views = {height, heat, rainfall}

    return biomes
end

local MapSurface03 = class("MapSurface03", HeightmapBase)

function MapSurface03:adjust_size(_w, _h)
    --[[Diamong-square algorithm requires a square grid of 2^n + 1 size.
    ]]--
    local max = -math.huge
    local function log_base(v, b)
        return math.log(v) / math.log(b)
    end

    local function pow2plus1(...)
        local old  = {...}
        local new = {}
        for i, v in ipairs(old) do
            local exp = log_base((v - 1), 2)
            local next_exp = math.ceil(exp)
            print("exp", v, exp, next_exp)
            local next_v = math.pow(2, next_exp) + 1
            new[#new + 1] = next_v
        end
        return unpack(new)
    end
    local w, h = pow2plus1(_w, _h)
    local new_v = math.max(-math.huge, w, h)
    self.k = log_base(new_v, 2) - 4
    log:warn("map size", new_v, new_v)
    return new_v, new_v
end

function MapSurface03:create(header)
    HeightmapBase.create(self, header)  -- super
    self:diamond_square()
    self:set_base_feature()

    local w, h = self.cols, self.rows
    self._noise = NoiseMap(w, h)
    self._heightmap = self.map
    self._heat_map = LatitudinalHeatMap(w, h)
    self._rainfall_map = PrecipitationMap(w, h, self)
    self.map = CompositeBiomeMap(w, h, self)

    local function prepare_map(graph, type)
        local _ = graph.prepare and graph:prepare(self)
        graph = self:standard_map(graph)
        apply_tiling(graph)
        return graph
    end

    local height = prepare_map(self._heightmap)
    local heat = prepare_map(self._heat_map)
    local rainfall = prepare_map(self._rainfall_map)
    local biomes = prepare_map(self.map)
    biomes.views = {height, heat, rainfall}

    return biomes
end

return MapSurface03
