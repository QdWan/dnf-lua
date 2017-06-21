local log_base = require("util.log_base")
local creator = require("map_gen.creator")
local Graph = require("map_gen.base").Graph

local templates = require("templates")
local tile_templates = templates.enum.TileEntity
local TileConstants = templates.constants.EnumTileEntity
local MOUNTAIN = TileConstants.mountain
local HILL = TileConstants.hill
local LAND = TileConstants.land
local COAST = TileConstants.coast
local HEAT_VIEW = TileConstants.heat_view
local RAINFALL_VIEW = TileConstants.rainfall_view
local ARCTIC_COAST = TileConstants.arctic_coast
local ARCTIC_MOUNTAIN = TileConstants.arctic_mountain
local ARCTIC_HILL = TileConstants.arctic_hill
local ARCTIC_LAND = TileConstants.arctic_land
local BOREAL_GRASSLAND = TileConstants.boreal_grassland
local TEMPERATE_DESERT = TileConstants.temperate_desert
local GRASSLAND = TileConstants.grassland
local SUBTROPICAL_DESERT = TileConstants.subtropical_desert
local SAVANA = TileConstants.savana
local TROPICAL_DESERT = TileConstants.tropical_desert
local WATER = TileConstants.water
local SHALLOW_WATER = TileConstants.shallow_water
local DEEP_WATER = TileConstants.deep_water
local ARCTIC_SHALLOW_WATER = TileConstants.arctic_shallow_water
local ARCTIC_DEEP_WATER = TileConstants.arctic_deep_water
local BOREAL_FOREST = TileConstants.boreal_forest
local WOODLAND = TileConstants.woodland
local TEMPERATE_DECIDUOUS_FOREST = TileConstants.temperate_deciduous_forest
local TEMPERATE_RAIN_FOREST = TileConstants.temperate_rain_forest
local TROPICAL_RAIN_FOREST = TileConstants.tropical_rain_forest
local tile_groups  = templates.constants.groups
local WATER_GROUP  = tile_groups.WATER_GROUP
local FOREST_GROUP = tile_groups.FOREST_GROUP

local MapCreator = creator.MapCreator
local time = time
local lm = love.math


local W = 64
local H = 64


local MODULE = {}


local function get_pos(map, pos)
    return map:get(pos[1], pos[2])
end

local function random_k(k)
    local v = ((love.math.random() * 2) - 1) * k
    -- print("random_k", k, "->", v)
    return v
end

local _neighbors_cache = {}
local function neighbors(graph, i, r)
    local r = r or 1

    local w = graph.w
    local h = graph.h

    local key = w ..";".. h ..";".. i ..";".. r
    local result = _neighbors_cache[key]

    -- try to get a cached copy
    if result then
        -- TODO: remove this debug for performance
        -- log:info("returning cached neighbors: " .. key)
        return result
    else
        result = {}
        -- keep a copy for later
        _neighbors_cache[key] = result
    end

    local size = w * h
    local x = ((i - 1) % w) + 1
    local y = math.floor((i - 1) / w) + 1
    local min_x = math.max(x - r, 1)
    local max_x = math.min(x + r, w)
    local min_y = math.max(y - r, 1)
    local max_y = math.min(y + r, h)

    local count = 0
    for nx = min_x, max_x do
        for ny = min_y, max_y do
            if nx ~= x or ny ~= y then -- not self
                local k = ((ny - 1) * w) + nx
                count = count + 1
                result[count] = k
            end
        end
    end

    return result
end

local function get_node_values(graph, list)
    local nodes = graph.nodes
    local values = {}
    for j, i in ipairs(list) do
        local node = nodes[i]
        values[j] = node.value
    end
    return values
end


local function midpoint(a, b)
    return math.ceil((b - a) / 2) + a
end

local function get_ratio(graph, list, table)
    local nodes = graph.nodes
    local count = 0
    for _, i in ipairs(list) do
        local node = nodes[i]
        if table[node.template] then
            count = count + 1
        end
    end
    return count / #list
end

local function precipitation(height, heat, water_ratio)
    return ((1 - height) * 0.25 +
            heat * 0.4 +
            water_ratio * 0.35)
end

local function undeepify_water(graph, i)
    -- undeepify_water(graph, node)
    local nodes = graph.nodes
    local node = nodes[i]
    local template = node.template
    local find = string.find
    for k, address in pairs(node.neighbors) do
        if address > 0 and not find(grid[address].template, WATER) then
            return template == DEEP_WATER and SHALLOW_WATER or
                                              ARCTIC_SHALLOW_WATER
        end
    end
    run_once = true
    return template
end

local function get_biome_template(node, i)
    local meta = node.meta
    local n = meta.noise_value
    local _height = meta.height_value
    local _heat = meta.heat_value
    local rain = meta.rainfall_value
    local water_r1 = meta.water_ratio_r1
    local water_r2 = meta.water_ratio_r2


    if i == 37445 then
        log:warn("COMPOSE_BIOME DEBUG")
        log:warn(tostring(node))
        log:warn(string.format(
            "n %d, _height %d, _heat %d, rain %d, water_r1 %d, water_r2 %d, i %d",
            n, _height, _heat, rain, water_r1, water_r2, i))
    end
    local height = _height * 0.95 + n * 0.05
    local height2 = _height * 0.90 + n * 0.1
    local heat = _heat * 0.70 + (1 - rain) * 0.20 + n * 0.1
    local heat2 = _heat * 0.70 + (1 - rain) * 0.15 + n * 0.15
    local wr1l = 0 -- water ratio at radius 2 lower limit
    local wr2l = 0.5 -- water ratio at radius 2 lower limit

    if heat2 < 0.33 then
        if height <= 0.2 then
            return ARCTIC_DEEP_WATER
        elseif height <= 0.27 then
            return ARCTIC_SHALLOW_WATER
        elseif water_r1 > 0 and (water_r2 > wr2l or height <= 0.32) then
            return ARCTIC_COAST
        elseif 0.78 < height2 and height2 < 0.82 then
            return ARCTIC_MOUNTAIN
        elseif 0.70 < height2 and height2 < 0.72 then
            return ARCTIC_HILL
        else  -- arctic
            return ARCTIC_LAND
        end
    end

    if height <= 0.22 then
        return DEEP_WATER
    elseif height <= 0.27 then
        return SHALLOW_WATER

    -- temperate
    elseif heat2 < 0.52 then
        if water_r2 > 0 and (water_r1 > wr1l or water_r2 > wr2l or height <= 0.31) then
            return COAST
        elseif water_r2 > 0 then
            return BOREAL_GRASSLAND
        elseif (0.79 < height2 and height2 < 0.82) or 0.95 < height then
            return MOUNTAIN
        elseif 0.70 < height2 and height2 < 0.72 then
            return HILL
        elseif rain < 0.25 and (0.44 < height2 and height2 < 0.5) then
            return TEMPERATE_DESERT
        elseif rain < 0.29 then
            return BOREAL_GRASSLAND
        else
            return BOREAL_FOREST  -- conifer
        end

    -- subtropical/temperate
    elseif heat2 < 0.77 then
        if water_r2 > 0 and (water_r1 > wr1l or water_r2 > wr2l or height <= 0.31) then
            return COAST
        elseif water_r2 > 0 then
            return GRASSLAND
        elseif (0.79 < height2 and height2 < 0.82) or 0.95 < height then
            return MOUNTAIN
        elseif 0.70 < height2 and height2 < 0.72 then
            return HILL
        elseif rain < 0.32 and (0.44 < height2 and height2 < 0.5) then
            return SUBTROPICAL_DESERT
        elseif rain < 0.38 and (height2 < 0.39) then
            return WOODLAND
        elseif rain < 0.45 and (height2 < 0.45) then
            return TEMPERATE_DECIDUOUS_FOREST
        elseif rain >= 0.45 or (0.55 < height2 and height2 < 0.6) then
            return TEMPERATE_RAIN_FOREST
        else
            return GRASSLAND
        end

    -- tropical
    else
        if water_r2 > 0 and (water_r1 > wr1l or water_r2 > wr2l or height <= 0.32) then
            return COAST
        elseif water_r2 > 0 then
            return SAVANA
        elseif (0.79 < height2 and height2 < 0.82) or 0.90 < height then
            return MOUNTAIN
        elseif 0.70 < height2 and height2 < 0.72 then
            return HILL
        elseif rain >= 0.49 and ((0.35 < height2 and height2 < 0.44) or
                               height >= 0.55) then
            return TROPICAL_RAIN_FOREST
        elseif heat > 0.80 and (height2 > 0.76 or rain < 0.30) then
            return TROPICAL_DESERT
        else
            return SAVANA
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

local function print_stats(graph)
    local max = -math.huge
    local min = math.huge
    local sum = 0
    local size = graph.w * graph.h
    local nodes = graph.nodes

    for i = 1, size do
        local v = nodes[i].value
        max = v > max and v or max
        min = v < min and v or min
        sum = sum + v
    end
    local avg = sum / size

    log:info("print_stats",
             string.format("max %.3f, min:%.3f, avg:%.3f.", max, min, avg))

    return max, min, avg
end

local function scale(src_graph, s)
    local floor = math.floor
    local ceil = math.ceil

    s = math.floor(s)
    local src_w, src_h = src_graph.w, src_graph.h
    local src = src_graph.nodes
    local dst_w, dst_h = src_w * s, src_h * s
    local dst_graph = Graph(dst_w, dst_h)
    local dst = dst_graph.nodes
    for i = 1, dst_w * dst_h do
        local j = (floor((dst[i].y - 1) / s) * src_w) +
                   ceil(dst[i].x / s)
        dst[i].value = src[j].value
        dst[i].template = src[j].template
    end
    return dst_graph
end
MODULE.scale = scale

--[[
    local function _scale(src, src_w, src_h, scale, creator)
        local floor = math.floor
        local ceil = math.ceil

        scale = math.floor(scale)
        local dst_w, dst_h = src_w * scale, src_h * scale
        local map = Graph(dst_w, dst_h)
        local dst = map.nodes
        for i = 1, dst_w * dst_h do
            local j = (floor((dst[i].y - 1) / scale) * src_w) +
                       ceil(dst[i].x / scale)
            dst[i].value = src[j].value
            dst[i].template = src[j].template
        end
        creator.w, creator.h = dst_w, dst_h
        creator.map = map
    end

    function HeightmapBase:scale(k)
        local old_nodes = self.map.nodes
        local old_w = self.map.w
        local old_h = self.map.h
        self.map.nodes = nil
        self.map = nil
        return _scale(old_nodes, old_w, old_h, k, self)
    end
]]--

local function init_grid(graph, args)
    --[[
    Fill grid.
    ]]--
    local args = args or {}
    local v = args.v or 0
    local noise = args.noise or false
    local rnd = args.rnd or false
    local nodes = graph.nodes
    local w, h = graph.w, graph.h

    local floor = math.floor

    local get_noise = function(i)
        local x, y = (((i - 1) % w) + 1), floor((i - 1) / w) + 1
        return lm.noise(x + lm.random(), y + lm.random())
    end
    local get_random = function()
        return lm.random()
    end

    local fill
    if noise then
        fill = get_noise
    elseif rnd then
        fill = get_random
    elseif v == 0 then
        return -- ffi array is already initialized with zeros
    else
        fill = false
    end

    local t0 = time()
    log:warn("init_grid - start")

    for i = 1, w * h do
        nodes[i].value = fill and fill(i) or v
    end
    local t1 = time()

    print_stats(graph)
    log:warn("HeightmapBase:init_grid - done", t1 - t0)
end
MODULE.init_grid = init_grid

local function apply_on_graph(graph, fn, args)
    --[[Call `fn` for each node of `graph` for `n` times.]]--
    local k = args.k or 0.50
    local r = args.r or 1
    local n = args.n or 1

    local w, h = graph.w, graph.h

    print_stats(graph)
    local t0 = time()
    log:warn("apply_on_grid(" .. args.name or fn .. ") => start")

    for step = 1, n do
        for x = 1, w do
            for y = 1, h do
                local i = ((y - 1) * w) + x
                fn(graph, i, args)
            end
        end
    end

    print_stats(graph)
    log:warn("erupt_grid => done", time() - t0)
end
MODULE.apply_on_graph = apply_on_graph

local function erupt(graph, i, args)
    --[[Raise a value by k times its highest neighbor value(hnv).

    Higher k values result in a greater changes.
    No changes are made unless hnv is higher then the current value.
    ]]--
    local args = args or {}
    local k = args.k or 0.50
    local r = args.r or 1
    -- highest neighbor value
    local n_list = neighbors(graph, i, r)

    local hnv = math.max(unpack(get_node_values(graph, list)))

    local node = graph.nodes[i]
    local value = node.value

    local new = hnv * k + value * (1 - k)

    node.value = new > value and new or value
end
MODULE.erupt = erupt

local function erode(graph, i, args)
    --[[Lower a value by k times its lowest neighbor value(lnv).

    Higher k values result in a greater changes.
    No changes are made unless hnv is lower then the current value.
    ]]--
    local args = args or {}
    local k = args.k or 0.50
    local r = args.r or 1

    local n_list = neighbors(graph, i, r)
    -- get_node_values(graph, list)

    local lnv = math.min(unpack(get_node_values(graph, list)))

    local node = graph.nodes[i]
    local value = node.value

    local new = lnv * k + value * (1 - k)
    node.value = new < value and new or value
end
MODULE.erode = erode

local function smoothe(graph, args)
    local args = args or {}
    local times = args.times or 1
    local k = args.k or 0.80

    local w, h = graph.w, graph.h
    local t0 = time()
    log:warn("smoothe(times=" .. times .. ") => start")

    local directions = {
        {dx = -1, dy = 0},  -- Rows, left to right
        {dx = 1, dy = 0},  -- Rows, right to left
        {dx = 0, dy = -1},  -- Columns, top to bottom
        {dx = 0, dy = 1},  -- Columns, bottom to top
    }

    for i = 1, times do
        for i = 1, times do
            for _, dir in ipairs(directions) do
                local dx = dir.dx
                local dy = dir.dy
                for x = 1, w do
                    for y = 1, h do
                        local wx = ((x - 1) % w) + 1
                        local wy = ((y - 1) % h) + 1
                        local node = graph:get(wx, wy)
                        local v = node.value

                        local owx = ((x + dx - 1) % w) + 1
                        local owy = ((y + dy - 1) % h) + 1
                        local other_v = graph:get(owx, owy).value

                        node.value = other_v * (1 - k) + v * k
                    end
                end
            end
        end
    end
    print_stats(graph)
    log:warn("smoothe(times=" .. times .. ") => done! " .. time() - t0 .. "s")
end
MODULE.smoothe = smoothe

function MODULE.set_base_feature(graph)
    local t0 = time()
    log:warn("set_base_feature => start")
    local nodes = graph.nodes
    for i = 1, graph.w * graph.h do
        local tile = nodes[i]
        local v = tile.value

        if     v > 0.7  then tile.template = MOUNTAIN
        elseif v > 0.6  then tile.template = HILL
        elseif v > 0.4  then tile.template = LAND
        elseif v > 0.28 then tile.template = COAST
        elseif v > 0.2  then tile.template = SHALLOW_WATER
        else                 tile.template = DEEP_WATER
        end

    end

    log:warn("set_base_feature => done!", time() - t0)
end

local function deposition(graph, k)
    local k = k or 0.75

    local random = lm.random
    local nodes = graph.nodes
    local w, h = graph.w, graph.h

    local t0 = time()
    log:warn("deposition => start")

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
            print_stats(graph)
        else
            -- Walk in a direction
            local choice = random(4)
            if     choice == 4 then x = x + 1
            elseif choice == 3 then x = x - 1
            elseif choice == 2 then y = y + 1
            else                    y = y - 1
            end
        end

        -- wrap?
        x = ((x - 1) % w) + 1
        y = ((y - 1) % h) + 1

        if random(2) == 2 then
            local node = graph:get(x, y)
            local v = node.value
            node.value = v * (1 - k) + n * k
        else
            local node = graph:get(x, y)
            local v = node.value
            if v > 0.8 then
                if random(2) == 2 then
                    erode(graph, x, y)
                end
            elseif v < 0.5 then
                erupt(graph, x, y)
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
    print_stats(graph)
    log:warn("deposition => done! " .. t1 - t0 .. "s")
end
MODULE.deposition = deposition

local function initialize_pos(graph, v, t)
    print("HeightmapBase:initialize_pos", #t)
    for i, pos in ipairs(t) do
        graph:get(pos[1], pos[2]).value = v
    end
end

local function normalize(graph)
    print("normalize")
    local nodes = graph.nodes
    local w, h = graph.w, graph.h
    local min, max = math.min, math.max

    local min_v, max_v = math.huge, -math.huge

    for i = 1, w * h do
        local node = nodes[i]
        min_v = math.min(min_v, node.value)
        max_v = math.max(max_v, node.value)
    end

    local range = max_v -min_v

    print_stats(graph)

    for i = 1, w * h do
        local node = nodes[i]
        local old_v = node.value
        local new_v = (old_v - min_v) / range
        node.value = new_v
    end
    print_stats(graph)
end

local function diamond_square_adjust_size(_w, _h)
    --[[Diamond-square algorithm requires a square grid of 2^n + 1 size.
    ]]--
    _h = _h or _w
    local max = -math.huge
    local log_base = log_base

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
    local k = log_base(new_v, 2) - 4
    log:warn("adjusted size =>" ..
             string.format("%d x %d = %d", new_v, new_v, new_v * new_v))
    return new_v, new_v, k
end
MODULE.diamond_square_adjust_size = diamond_square_adjust_size

local function diamond_step(graph, rect, k)
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
    local topleft = get_pos(graph, rect:get_topleft())
    local topright = get_pos(graph, rect:get_topright())
    local bottomleft = get_pos(graph, rect:get_bottomleft())
    local bottomright = get_pos(graph, rect:get_bottomright())
    local center = get_pos(graph, rect:get_center())
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

local function square_step(graph, rect, k)
    --[[Perform the square step.

    Set the four mid points between the corners, i.e. North, South, East and
    West, by averaging the two values on either side of the point in question
    and adding or subtracting a slightly smaller random amount of noise. This
    is the 'square' step.
    ]]--
    local low = k / 2
    local v, noise
    local noise = random_k(low)
    --[[
    print("square_step",
          rect.x, rect.y, rect:get_right(), rect:get_bottom(),
          rect.w, rect.h, noise)
    ]]--

    local midtop = get_pos(graph, rect:get_midtop())
    local topleft = get_pos(graph, rect:get_topleft())
    local topright = get_pos(graph, rect:get_topright())
    v = (topleft.value + topright.value) / 2
    midtop.value = noise + v
    --[[
    midtop.value = (1 - low) * v + (low * noise)
    print(string.format(
        "diamond_step:square_step midtop(avg %.4f, noise %.4f, final %.4f",
        v, noise, midtop.value))
    ]]--

    local midright = get_pos(graph, rect:get_midright())
    local bottomright = get_pos(graph, rect:get_bottomright())
    v = (topright.value + bottomright.value) / 2
    midright.value = noise + v
    --[[
    midright.value = (1 - low) * v + (low * noise)
    print(string.format(
        "diamond_step:square_step midright(avg %.4f, noise %.4f, final %.4f",
        v, noise, midright.value))
    ]]--

    local midbottom = get_pos(graph, rect:get_midbottom())
    local bottomleft = get_pos(graph, rect:get_bottomleft())
    v = (bottomright.value + bottomleft.value) / 2
    midbottom.value = noise + v
    --[[
    midbottom.value = (1 - low) * v + (low * noise)
    print(string.format(
        "diamond_step:square_step midbottom(avg %.4f, noise %.4f, final %.4f",
        v, noise, midbottom.value))
    ]]--

    local ml = get_pos(graph, rect:get_midleft())
    v = (topleft.value + bottomleft.value) / 2
    ml.value = noise + v
    --[[
    ml.value = (1 - low) * v + (low * noise)
    print(string.format(
        "diamond_step:square_step ml(avg %.4f, noise %.4f, final %.4f",
        v, noise, ml.value))
    ]]--
end

local function apply_diamond_square(graph, k, start)
    local t0 = time()
    log:warn("apply_diamond_square: start")

    local rects = {[start] = true}
    local used
    local k = k
    while true do
        local check = false
        for rect, _ in pairs(rects) do
            diamond_step(graph, rect, k)
            check = rect
        end
        for rect, _ in pairs(rects) do
            square_step(graph, rect, k)
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

local function diamond_square(graph)
    local w, h = graph.w, graph.h
    local exp = log_base((w - 1), 2)
    assert(w == h and (2 ^ exp) + 1 == w)
    local k = exp - 4
    local start = Rect(1, 1, w - 1, h - 1)
    print("HeightmapBase:diamond_square", start.w, start.h)
    initialize_pos(graph, 1,
        {start:get_topleft(), start:get_topright(),
         start:get_bottomleft(), start:get_bottomright()})
    apply_diamond_square(graph, k, start)
    normalize(graph)
end
MODULE.diamond_square = diamond_square

function MODULE.compose_biomes(graph)
    local floor = math.floor
    local sin = math.sin
    local PI = math.pi
    local tile_templates = tile_templates
    local neighbors = neighbors

    local w, h = graph.w, graph.h
    local nodes = graph.nodes

    local ta = time()
    log:warn("compose_biomes => start")

    local t0 = time()
    log:warn("compose_biomes step 1 => start")
    for i = 1, w * h do
        local node = nodes[i]
        local x, y = node.x, node.y
        local template = node.template
        local meta = node.meta

        meta.height_value = node.value
        meta.height_template = template
        local tile_templates_color = tile_templates[template].color
        meta.height_color.r = tile_templates_color[1]
        meta.height_color.g = tile_templates_color[2]
        meta.height_color.b = tile_templates_color[3]

        meta.noise_value = lm.noise(x + lm.random(), y + lm.random())

        local heat_value = sin((y / h) * PI)
        meta.heat_value = heat_value
        meta.heat_template = HEAT_VIEW
        meta.heat_color.r = floor(heat_value * 255)
        meta.heat_color.g = 0
        meta.heat_color.b = floor((1 - heat_value) * 255)
    end
    log:warn("compose_biomes step 1 => done!", time() - t0)

    local t0 = time()
    log:warn("compose_biomes step 2 => start")
    local debug = false
    for i = 1, w * h do
        local node = nodes[i]
        local meta = node.meta

        meta.rainfall_template = RAINFALL_VIEW
        local neighbors_r1 = neighbors(graph, i, 1)
        local neighbors_r2 = neighbors(graph, i, 2)
        local neighbors_r4 = neighbors(graph, i, 4)

        local water_ratio_r1 = get_ratio(graph, neighbors_r1, WATER_GROUP)
        meta.water_ratio_r1 = water_ratio_r1

        local water_ratio_r2 = get_ratio(graph, neighbors_r2, WATER_GROUP)
        meta.water_ratio_r2 = water_ratio_r2

        local water_ratio_r4 = get_ratio(graph, neighbors_r4, WATER_GROUP)
        meta.water_ratio_r4 = water_ratio_r4

        local forest_ratio_r4 = get_ratio(graph, neighbors_r4, WATER_GROUP)
        meta.forest_ratio_r4 = forest_ratio_r4

        local v = precipitation(
            meta.height_value, meta.heat_value, water_ratio_r4)
        meta.rainfall_value = v
        meta.rainfall_color.r = floor((1 - v) * 255)
        meta.rainfall_color.g = 0
        meta.rainfall_color.b = floor(v * 255)

        node.template = get_biome_template(node, i)
    end
    log:warn("compose_biomes step 2 => done!", time() - t0)

    local t0 = time()
    log:warn("compose_biomes step 3 => start")
    for i = 1, w * h do
        local node = nodes[i]
        local meta = node.meta
        local template = node.template
        if template == DEEP_WATER or template == ARCTIC_DEEP_WATER then
            local neighbors_r1 = neighbors(graph, i, 1)
            local water_ratio_r1 = get_ratio(graph, neighbors_r1,
                                             WATER_GROUP)
            if water_ratio_r1 < 1 then
                node.template = template == DEEP_WATER and SHALLOW_WATER or
                                            ARCTIC_SHALLOW_WATER
            end
        --[[ no need to check for forests in water tiles as they are unfit for
        cities
        ]]--
        elseif not WATER_GROUP[template] then
            local neighbors_r4 = neighbors(graph, i, 4)
            local forest_ratio_r4 = get_ratio(graph, neighbors_r4,
                                              FOREST_GROUP)
            meta.forest_ratio_r4 = forest_ratio_r4
        end


    end
    log:warn("compose_biomes step 3 => done!", time() - t0)
    log:warn("compose_biomes => done!", time() - ta)
end

function MODULE.standard_map(graph, header)
    local map = creator.standard_map(graph, header)  -- super
    map.views = {false, "height_", "heat_", "rainfall_"}
    return map
end


return MODULE
