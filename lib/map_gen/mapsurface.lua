local creator = require("map_gen.creator")
local tile_templates = require("templates")
local MapCreator = creator.MapCreator
local time = time
local lm = love.math


local W = 60
local H = 60


local MODULE = {}


local function get_pos(map, pos)
    return map:get(pos[1], pos[2])
end

local function random_k(k)
    local v = ((love.math.random() * 2) - 1) * k
    -- print("random_k", k, "->", v)
    return v
end

local function neighbors(map, t)
    local r = t.r or 1
    local nodes = map.nodes
    local index = t.i
    local get_pos = t.get_pos or false

    local w = map.w
    local h = map.h
    local size = w * h
    local x = t.x or ((index - 1) % w) + 1
    local y = t.y or math.floor((index - 1) / w) + 1
    local res = {}

    for i = x-r, x+r do
        for j = y-r, y+r do
            local k = ((j - 1) * w) + i
            if (i > 0 and i <= size and
                j > 0 and j <= size and
                not (i == x and j == y) -- self
                ) then
                res[#res + 1] = get_pos and k or nodes[k]
            end
        end
    end
    return res
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

local function midpoint(a, b)
    return math.ceil((b - a) / 2) + a
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

local run_once = false
local function undeepify_water(node, grid)
    local template = node.template
    for k, address in pairs(node.neighbors[1]) do
        if address and not string.find(grid[address].template, "water") then
            return template == "deep_water" and "shallow_water" or
                                                "arctic_shallow_water"
        end
    end
    run_once = true
    return template
end


local function compose_biome(n, _height, _heat, rain, water_r1, water_r2)
    local height = _height * 0.95 + n * 0.05
    local height2 = _height * 0.90 + n * 0.1
    local heat = _heat * 0.70 + (1 - rain) * 0.20 + n * 0.1
    local heat2 = _heat * 0.70 + (1 - rain) * 0.15 + n * 0.15
    local wr1l = 0 -- water ratio at radius 2 lower limit
    local wr2l = 0.5 -- water ratio at radius 2 lower limit

    if heat2 < 0.33 then
        if height <= 0.2 then
            return "arctic_deep_water"
        elseif height <= 0.27 then
            return "arctic_shallow_water"
        elseif water_r1 > 0 and (water_r2 > wr2l or height <= 0.32) then
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
        if water_r2 > 0 and (water_r1 > wr1l or water_r2 > wr2l or height <= 0.31) then
            return "coast"
        elseif water_r2 > 0 then
            return "boreal grassland"
        elseif (0.79 < height2 and height2 < 0.82) or 0.95 < height then
            return "mountain"
        elseif 0.70 < height2 and height2 < 0.72 then
            return "hill"
        elseif rain < 0.25 and (0.44 < height2 and height2 < 0.5) then
            return "temperate desert"
        elseif rain < 0.29 then
            return "boreal grassland"
        else
            return "boreal forest"  -- conifer
        end
    -- subtropical/temperate
    elseif heat2 < 0.77 then
        if water_r2 > 0 and (water_r1 > wr1l or water_r2 > wr2l or height <= 0.31) then
            return "coast"
        elseif water_r2 > 0 then
            return "grassland"
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
        if water_r2 > 0 and (water_r1 > wr1l or water_r2 > wr2l or height <= 0.32) then
            return "coast"
        elseif water_r2 > 0 then
            return "savana"
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


local HeightmapBase = class("HeightmapBase", MapCreator)
MODULE.HeightmapBase = HeightmapBase

function HeightmapBase:create(header)
    self.header = header
    local w, h = self:adjust_size(W, H)
    log:warn("HeightmapBase:create", w, h)
    MapCreator.create(self, w, h)  -- super
end

function HeightmapBase:adjust_size(_w, _h)
    return _w, _h
end

function HeightmapBase:print_stats()
    local map = self.map
    local max = math.max
    local min = math.min
    local _max = -math.huge
    local _min = math.huge
    local sum = 0
    local w, h = map.w, map.h

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

    log:info(self.class.name, "print_stats",
             string.format("max %.4f, min:%.4f, avg:%.4f.", _max, _min, avg))

    return _max, _min, avg
end

function HeightmapBase:scale(k)
    k = math.floor(k)

    log:warn(string.format("%s scale(%d) - start", self.class.name, k))
    local t0 = time()

    local old_map = self.map
    local old_nodes = self.map.nodes

    MapCreator.create(self, old_map.w * k, old_map.h * k)
    for i, node in ipairs(self.map.nodes) do
        local x, y = math.ceil(node.x / k), math.ceil(node.y / k)
        local old_index = ((y - 1) * old_map.w) + x
        local old_node = assert(old_nodes[old_index], "invalid node")
        node.value = old_node.value
        node.template = old_node.template
    end
    log:warn("HeightmapBase:done", k)

    log:warn(string.format("%s scale(%d) - done!", self.class.name, k),
             time() - t0)
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
    local w, h = map.w, map.h
    log:warn("HeightmapBase:init_grid - start")
    local t0 = time()

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
    local t1 = time()

    self:print_stats()
    log:warn("HeightmapBase:init_grid - done", t1 - t0)
end

function HeightmapBase:deposition(k)
    local k = k or 0.75

    local random = lm.random
    local map = self.map
    local nodes = self.map.nodes
    -- randint = self.random.randint
    -- randrange = self.random.randrange
    local w, h = map.w, map.h

    self:print_stats()
    log:warn("HeightmapBase:deposition - start")
    local t0 = time()

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

    local t1 = time()
    self:print_stats()
    log:warn("HeightmapBase:deposition - done", t1 - t0)
end

function HeightmapBase:initialize_pos(v, t)
    print("HeightmapBase:initialize_pos", #t)
    local map = self.map
    for i, pos in ipairs(t) do
        self.map:get(pos[1], pos[2]).value = v
    end
end

function HeightmapBase:diamond_step(rect, k)
    --[[Perform the diamond step.

    Taking a square of four points, generate a random value at the square
    midpoint, where the two diagonals meet. The midpoint value is calculated
    by averaging the four corner values, plus a random amount.
    ]]--
    --[[

    print(
        "diamond_step",
        rect.x, rect.y, rect:get_right(), rect:get_bottom(), rect.w, rect.h)
    ]]--
    local map = self.map

    local topleft = get_pos(map, rect:get_topleft())
    local topright = get_pos(map, rect:get_topright())
    local bottomleft = get_pos(map, rect:get_bottomleft())
    local bottomright = get_pos(map, rect:get_bottomright())
    local center = get_pos(map, rect:get_center())
    local avg = (topleft.value + topright.value +
                 bottomleft.value + bottomright.value) / 4
    local noise = random_k(k)
    center.value = avg + noise
    --[[

    print(string.format(
        "diamond_step (avg %.4f, noise %.4f, final %.4f",
        avg, noise, center.value))
    ]]--
end

function HeightmapBase:square_step(rect, k)
    --[[Perform the square step.

    Set the four mid points between the corners, i.e. North, South, East and
    West, by averaging the two values on either side of the point in question
    and adding or subtracting a slightly smaller random amount of noise. This
    is the 'square' step.
    ]]--
    local map = self.map
    local low = k / 2
    local v, noise
    local noise = random_k(low)
    --[[
    print("square_step",
          rect.x, rect.y, rect:get_right(), rect:get_bottom(),
          rect.w, rect.h, noise)
    ]]--

    local midtop = get_pos(map, rect:get_midtop())
    local topleft = get_pos(map, rect:get_topleft())
    local topright = get_pos(map, rect:get_topright())
    v = (topleft.value + topright.value) / 2
    midtop.value = noise + v
    --[[
    midtop.value = (1 - low) * v + (low * noise)
    print(string.format(
        "diamond_step:square_step midtop(avg %.4f, noise %.4f, final %.4f",
        v, noise, midtop.value))
    ]]--

    local midright = get_pos(map, rect:get_midright())
    local bottomright = get_pos(map, rect:get_bottomright())
    v = (topright.value + bottomright.value) / 2
    midright.value = noise + v
    --[[
    midright.value = (1 - low) * v + (low * noise)
    print(string.format(
        "diamond_step:square_step midright(avg %.4f, noise %.4f, final %.4f",
        v, noise, midright.value))
    ]]--

    local midbottom = get_pos(map, rect:get_midbottom())
    local bottomleft = get_pos(map, rect:get_bottomleft())
    v = (bottomright.value + bottomleft.value) / 2
    midbottom.value = noise + v
    --[[
    midbottom.value = (1 - low) * v + (low * noise)
    print(string.format(
        "diamond_step:square_step midbottom(avg %.4f, noise %.4f, final %.4f",
        v, noise, midbottom.value))
    ]]--

    local ml = get_pos(map, rect:get_midleft())
    v = (topleft.value + bottomleft.value) / 2
    ml.value = noise + v
    --[[
    ml.value = (1 - low) * v + (low * noise)
    print(string.format(
        "diamond_step:square_step ml(avg %.4f, noise %.4f, final %.4f",
        v, noise, ml.value))
    ]]--
end

function HeightmapBase:apply_diamond_square(k, start)
    local t0 = time()
    log:warn("apply_diamond_square: start")


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
                "apply_diamond_square -> divide)",
                check.x, check.y, check:get_right(), check:get_bottom(),
                check.w, check.h)
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
    log:warn("apply_diamond_square: done", time() - t0)
end

function HeightmapBase:diamond_square(left, top, right, bottom)
    local map = self.map
    local w, h = map.w, map.h
    local start = Rect(1, 1, w - 1, h - 1)
    print("HeightmapBase:diamond_square", start.w, start.h)
    self:initialize_pos(
        1,
        {start:get_topleft(), start:get_topright(),
         start:get_bottomleft(), start:get_bottomright()})
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
    local map = self.map
    local k = param.k or 0.50
    local r = param.r or 1
    local n = param.n or 1
    local param = {k=k, r=r}

    local w, h = map.w, map.h

    self:print_stats()
    log:warn(self.class.name, "erupt_grid - start")
    local t0 = time()

    for i = 1, n do
        for x = 1, w do
            for y = 1, h do
                self:erupt(x, y, param)
            end
        end
    end


    local t1 = time()
    self:print_stats()
    log:warn(self.class.name, "erupt_grid - done", t1 - t0)
end

function HeightmapBase:erode_grid(param)
    --[[Apply erode effect on the grid n times.]]--
    local map = self.map
    local k = param.k or 0.50
    local r = param.r or 1
    local n = param.n or 1
    local param = {k=k, r=r}

    local w, h = map.w, map.h

    self:print_stats()
    log:warn(self.class.name, "erode_grid - start")
    local t0 = time()

    for i = 1, n do
        for x = 1, w do
            for y = 1, h do
                self:erode(x, y, param)
            end
        end
    end

    local t1 = time()
    self:print_stats()
    log:warn(self.class.name, "erode_grid - done", t1 - t0)
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
    local nodes = neighbors(self.map, {x=x, y=y, r=r})

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

    local nodes = neighbors(self.map, {x=x, y=y, r=r})
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

    local w, h = map.w, map.h

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
            log:warn(self.class.name, "smoothe - step", i, "start")
            local t0 = time()
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
            local t1 = time()
            self:print_stats()
            log:warn(self.class.name, "smoothe - step", i, "done", t1 - t0)
        end
    end
end

function HeightmapBase:set_base_feature()
    local t0 = time()
    log:warn(self.class.name, "set_base_feature: done")
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
    local map = self.map
    local w, h = map.w, map.h
    for x = 1, w do
        for y = 1, h do
            local node = self.map:get(x, y)
            node.template = get_feature(node.value)
        end
    end
    log:warn(self.class.name, "set_base_feature: done", time() - t0)
end

function HeightmapBase:standard_map(_)
    local map = self.map
    local w, h = map.w, map.h

    self._heightmap = self.map
    local nodes = self.map.nodes
    local floor = math.floor
    local sin = math.sin
    local pi = math.pi
    local tile_templates = tile_templates["TileEntity"]

    for i, node in ipairs(nodes) do
        local x, y = node.x, node.y
        node.meta = {
            height_value = node.value,
            height_template = node.template,
            height_id = tile_templates[node.template]["id"],
            height_color = tile_templates[node.template]["color"],
            noise_value = lm.noise(x + lm.random(), y + lm.random()),
        }
        local meta = node.meta
        local heat_value = sin((y / h) * pi)
        meta.heat_value = heat_value
        meta.heat_template = "heat_view"
        meta.heat_id = tile_templates[meta.heat_template]["id"]
        meta.heat_color = {
            floor(heat_value * 255), 0, floor((1 - heat_value) * 255)}
    end
    for i, node in ipairs(nodes) do
        local meta = node.meta
        meta.rainfall_template = "rainfall_view"
        meta.rainfall_id = tile_templates[meta.rainfall_template]["id"]
        local height_nodes_r1 = neighbors(self.map, {i=i, r=1})
        local water_ratio_r1 = get_water_ratio(height_nodes_r1)
        meta.water_ratio_r1 = water_ratio_r1
        local height_nodes_r2 = neighbors(self.map, {i=i, r=2})
        local water_ratio_r2 = get_water_ratio(height_nodes_r2)
        meta.water_ratio_r2 = water_ratio_r2
        local height_nodes_r4 = neighbors(self.map, {i=i, r=4})
        local water_ratio_r4 = get_water_ratio(height_nodes_r4)
        meta.water_ratio_r4 = water_ratio_r4
        local v = precipitation(
            meta.height_value, meta.heat_value, water_ratio_r4)
        meta.rainfall_value = v
        meta.rainfall_color = {floor((1 - v) * 255), 0, floor(v * 255)}

        node.template = compose_biome(
            meta.noise_value, meta.height_value, meta.heat_value,
            meta.rainfall_value, water_ratio_r1, water_ratio_r2)
    end
    for i, node in ipairs(nodes) do
        if (node.template == "deep_water" or
                node.template == "arctic_deep_water") then
            node.template = undeepify_water(node, nodes)
        end
    end
    self.views = {false, "height_", "heat_", "rainfall_"}

    return MapCreator.standard_map(self)  -- super
end


return MODULE
