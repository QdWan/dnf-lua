local PriorityQueue = require("collections.priority_queue")
local shuffle = require("shuffle")
local Rect = require("rect")
local TileEntity = require("dnf.entities.tile")
local templates = require("templates")
local tile_constants = templates.constants.EnumTileEntity
local WALL = tile_constants.WALL
local FLOOR = tile_constants.FLOOR
local HALL = tile_constants.HALL

local COST = {
    [HALL] = 6,
    [FLOOR] = 64,
    [WALL] = 12
}

local map_gen = {}


local function heapsort(t, cmp)
    local pq = PriorityQueue({mode="highest_table"})
    for i = 1, #t do
        local tile = t[i]
        local priority = cmp(tile)
        pq:put({v=tile, p=priority})
    end
    local sorted = {}
    repeat
        local v = pq:pop_safe()
        if v then
            sorted[#sorted + 1] = v.v
        end
    until v == nil
    return sorted
end

map_gen.heapsort = heapsort

local function heuristic(a, b, w, h)
    local abs = math.abs
    local floor = math.floor
    return (abs((a % w) - (b % w)) + abs(floor(a / h) - floor(b / h)))
end

local function heuristic2d(a, b)
    local abs = math.abs
    return abs(a[1] - b[1]) + abs(a[2] - b[2])
end

map_gen.heuristic2d = heuristic2d

local function item_in_array(item, group)
    for _, cmp in ipairs(group) do
        if item == cmp then
            return true
        end
    end
    return false
end

local function to_1d(x, y, w, h)
    return ((y - 1) * w) + x
end

map_gen.to_1d = to_1d


local function to_2d(i, w, h)
    if i == 0 or i > w * h then
        error(string.format("to_2d error: i = %d", i))
    end
    return ((i - 1) % w) + 1, math.floor((i - 1) / w) + 1
end

local function print_graph(graph)
    local w = graph.w
    local h = graph.h
    local tiles = graph.tiles
    local to_1d = to_1d
    local to_2d = to_2d

    for y = 1, h do
        for x = 1, w do
            local i = (y -1) * graph.w + x
            local tile = tiles[i]
            local c
            if tile.template == WALL then
                c = "#"
            elseif tile.template == FLOOR then
                c = "."
            else
                c = "?"
            end
            io.write(c)
        end
        io.write("\n")
    end
end

local function north_neighbor(i, w, h, r)     error("deprecated") end
local function east_neighbor(i, w, h, r)      error("deprecated") end
local function south_neighbor(i, w, h, r)     error("deprecated") end
local function west_neighbor(i, w, h, r)      error("deprecated") end
local function northeast_neighbor(i, w, h, r) error("deprecated") end
local function southeast_neighbor(i, w, h, r) error("deprecated") end
local function southwest_neighbor(i, w, h, r) error("deprecated") end
local function northwest_neighbor(i, w, h, r) error("deprecated") end

local function neighbors(i, w, h, r, tile)
    r = r or 1

    tile.neighbors = tile.neighbors or {}

    local t = tile.neighbors

    -- north_neighbor
    local v = i - (w * r)
    local x, y = (((i - 1) % w) + 1), math.floor((i - 1) / w) + 1
    local nx, ny = (((v - 1) % w) + 1), math.floor((v - 1) / w) + 1
    t.north = (
        v > 0 and
        x == nx and
        v)

    -- east_neighbor
    local v = i + r
    local size = w * h
    local x, y = (((i - 1) % w) + 1), math.floor((i - 1) / w) + 1
    local nx, ny = (((v - 1) % w) + 1), math.floor((v - 1) / w) + 1
    t.east = (
        v <= size and
        y == ny and
        v)

    -- south_neighbor
    local v = i + (w * r)
    local size = w * h
    local x, y = (((i - 1) % w) + 1), math.floor((i - 1) / w) + 1
    local nx, ny = (((v - 1) % w) + 1), math.floor((v - 1) / w) + 1
    t.south = (
        v <= size and
        x == nx and
        v)

    -- west_neighbor
    local v = i - r
    local x, y = (((i - 1) % w) + 1), math.floor((i - 1) / w) + 1
    local nx, ny = (((v - 1) % w) + 1), math.floor((v - 1) / w) + 1
    t.west = (
        v > 0 and
        y == ny and
        v)

    -- northeast_neighbor
    local v = (i - w * r + r)
    local size = w * h
    local x, y = (((i - 1) % w) + 1), math.floor((i - 1) / w) + 1
    local nx, ny = (((v - 1) % w) + 1), math.floor((v - 1) / w) + 1
    t.northeast = (
        v > 0 and
        v <= size and
        x + r == nx and
        y - r == ny and
        v)

    -- southeast_neighbor
    local v = (i + w * r + r)
    local size = w * h
    local x, y = (((i - 1) % w) + 1), math.floor((i - 1) / w) + 1
    local nx, ny = (((v - 1) % w) + 1), math.floor((v - 1) / w) + 1
    t.southeast = (
        v <= size and
        x + r == nx and
        y + r == ny and
        v)

    -- southwest_neighbor
    local v = (i + w * r - r)
    local size = w * h
    local x, y = (((i - 1) % w) + 1), math.floor((i - 1) / w) + 1
    local nx, ny = (((v - 1) % w) + 1), math.floor((v - 1) / w) + 1
    t.southwest = (
        v > 0 and
        v <= size and
        x - r == nx and
        y + r == ny and
        v)

    -- northwest_neighbor
    local v = (i - w * r - r)
    local x, y = (((i - 1) % w) + 1), math.floor((i - 1) / w) + 1
    local nx, ny = (((v - 1) % w) + 1), math.floor((v - 1) / w) + 1
    t.northwest = (
        v > 0 and
        x - r == nx and
        y - r == ny and
        v)

end


-- ##########
-- Room class
local Room = class("Room", Rect)
map_gen.Room = Room

function Room:random_pos(_map, templates, ignore)
    local templates = templates or {FLOOR}
    local ignore = ignore or {}
    local tiles = shuffle(self:tiles(), true)
    for i = 1, #tiles do
        local tile = tiles[i]
        if not item_in_array(tile, ignore) and
           item_in_array(tile.template, templates)
        then
            return tile
        end
    end
end

function Room:tiles()
    local tiles = self._tiles
    if tiles == nil then
        tiles = {}
        for x = self.x, self:get_right() do
            for y = self.y, self:get_bottom() do
                tiles[#tiles + 1] = {x, y}
            end
        end
        self._tiles = tiles
    end
    return tiles
end
-- end of Room class
-- ##########


-- ##########
-- Graph class
local Graph = class("Graph")
map_gen.Graph = Graph

function Graph:set_neighbors()               error("deprecated") end
function Graph:get_neighbors(i, mode, check) error("deprecated") end
function Graph:neighbors_at_radius(r)        error("deprecated") end
function Graph:neighbor_functions()          error("deprecated") end

function Graph:init(w, h, map_file)
    self.tiles = ffi.new("TileEntity[?]", (w * h) + 1)
    self.features = {}
    self.creatures = {}
    self.items = {}

    local txt, block
    self.w = w
    self.h = h

    self:fill()
end

function Graph:fill()
    local t0 = time()
    local w, h = self.w, self.h
    log:warn("Graph:fill: start w " .. w .. ", h " .. h)
    local tiles = self.tiles
    local floor = math.floor
    local WALL, COST_WALL = WALL, COST[WALL]
    local neighbors = neighbors

    for i  = 1, w * h do
        local tile = tiles[i]
        tile.x, tile.y = (((i - 1) % w) + 1), floor((i - 1) / w) + 1
        tile.template, tile.cost = WALL, COST_WALL
        neighbors(i, w, h, 1, tile)
    end
    log:warn("Graph:fill: done", time() - t0)
end

function Graph:get(x, y)
    -- If both x and y are passed the coordinates are considered to be 2d
    -- If only x is passed it's considered to be a sequential, 1d coordinate.
    local i = y and to_1d(x, y, self.w, self.h) or x
    -- print(string.format("x %d, y %d --> i %d", x, y, i))
    return self.tiles[i]
end

function Graph:random_passables(n)
    local n = n or 1
    local random = love.math.random or math.random
    local tiles = self.tiles
    local tiles_lenght = #tiles
    local count = 0
    local rnd_n = {}
    local result = {}
    while count < n do
        local r = random(1, tiles_lenght)
        if rnd_n[r] == nil and not tiles[r].block then
            rnd_n[r] = r
            result[#result + 1] = r
            count = count + 1
        end
    end
    return result
end

function Graph:cost(current, _next)
    return 1
end

local function reconstruct_path(came_from, start, goal)
    local current = goal
    local path = {current}

    while current ~= start do
        current = came_from[current]
        path[#path + 1] = current
    end
    return path
end

local function a_star_search(graph, start, goal, cost, neighbors)
    local tiles = graph.tiles
    local w = graph.w
    local h = graph.h
    local heuristic = heuristic  -- heuristic(a, b, w, h)
    local frontier = PriorityQueue({mode="lowest_table"})
    local came_from = {}
    local cost_so_far = {}

    frontier:put({v=start, p=0})
    cost_so_far[start] = 0

    while not frontier:empty() do
        local current = frontier:pop().v

        if current == goal then
            break
        end

        local tile_neighbors = neighbors and neighbors(current) or
                               tiles[current].neighbors[1]
        for i, nxt in ipairs(tile_neighbors) do
            local new_cost = cost_so_far[current] + cost(graph, current, nxt)
            if cost_so_far[nxt] == nil or new_cost < cost_so_far[nxt] then
                cost_so_far[nxt] = new_cost
                local priority = new_cost + heuristic(goal, nxt, w, h)
                frontier:put({v=nxt, p=priority})
                came_from[nxt] = current
            end
        end
    end
    return reconstruct_path(came_from, start, goal)
end
map_gen.a_star_search = a_star_search
-- ##########

return map_gen
