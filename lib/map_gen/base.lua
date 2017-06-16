local PriorityQueue = require("collections.priority_queue")
local shuffle = require("shuffle")
local Rect = require("rect")
local util = require("util")

local COST = {
    hall = 6,
    floor = 64,
    wall = 12
}

local map_gen = {}


local function heapsort(t, cmp)
    local pq = PriorityQueue()
    for i = 1, #t do
        local node = t[i]
        local priority = cmp(node)
        pq:put(node, priority)
    end
    local sorted = {}
    while not pq:empty() do
        sorted[#sorted + 1] = pq:pop()
    end
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
    for i = 1, #group do
        if item == group[i] then
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
    return (((i - 1) % w) + 1), math.floor((i - 1) / w) + 1
end

local function print_graph(graph)
    local w = graph.w
    local h = graph.h
    local to_1d = to_1d
    local to_2d = to_2d
    local nodes = graph.nodes

    for y = 1, h do
        for x = 1, w do
            local node = graph:get(x, y)
            local c
            if node.template == "wall" then
                c = "#"
            elseif node.template == "floor" then
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

local function neighbors(i, w, h, r, node)
    r = r or 1

    node.neighbors = node.neighbors or {}

    local t = node.neighbors[r]
    if t then
        return t
    else
        t = {}
        node.neighbors[r] = t
    end

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
    local templates = templates or {"floor"}
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
-- GraphNode class
local GraphNode = class("GraphNode")

function GraphNode:init(t)
    t = t or {}
    self.x = t.x or false
    self.y = t.y or false
    self.block = t.block or false
    self.explored = t.explored or false
    self.template = t.template or "wall"
    self.cost = t.cost or COST[self.template]
end

function GraphNode:set_template(name)
    self.template = name
    self.cost = COST[name]
end
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
    local random = love.math.random or math.random
    local to_2d = to_2d

    self.nodes = {}
    local nodes = self.nodes

    local txt, block
    local map = {}
    self.w = w
    self.h = h

    self:fill()
end

function Graph:create_node(x, y, i)
    local w = self.w
    local h = self.h
    local r = 1
    local node = GraphNode{
        x = x, y = y,
    }
    neighbors(i, w, h, r, node)
    return node
end

function Graph:fill()
    local t0 = time()
    log:warn("Graph:fill: start")
    local w, h = self.w, self.h
    local nodes = self.nodes
    for i  = 1, w * h do
        -- WARNING: Graph:fill: done, 2.6598110933094
        local x, y  = to_2d(i, w, h)
        nodes[i] = self:create_node(x, y, i)
    end
    log:warn("Graph:fill: done", time() - t0)
end

function Graph:get(x, y)
    -- If both x and y are passed the coordinates are considered to be 2d
    -- If only x is passed it's considered to be a sequential, 1d coordinate.
    local i = y and to_1d(x, y, self.w, self.h) or x
    -- print(string.format("x %d, y %d --> i %d", x, y, i))
    return self.nodes[i]
end

function Graph:random_passables(n)
    local n = n or 1
    local random = love.math.random or math.random
    local nodes = self.nodes
    local nodes_lenght = #nodes
    local count = 0
    local rnd_n = {}
    local result = {}
    while count < n do
        local r = random(1, nodes_lenght)
        if rnd_n[r] == nil and not nodes[r].block then
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
    local nodes = graph.nodes
    local w = graph.w
    local h = graph.h
    local heuristic = heuristic  -- heuristic(a, b, w, h)
    local frontier = PriorityQueue()
    local came_from = {}
    local cost_so_far = {}

    frontier:put(start, 0)
    cost_so_far[start] = 0

    while not frontier:empty() do
        local current = frontier:pop()

        if current == goal then
            break
        end

        local node_neighbors = neighbors and neighbors(current) or
                               nodes[current].neighbors[1]
        for i, _next in ipairs(node_neighbors) do
            local new_cost = cost_so_far[current] + cost(current, _next)
            if cost_so_far[_next] == nil or new_cost < cost_so_far[_next] then
                cost_so_far[_next] = new_cost
                local priority = new_cost + heuristic(goal, _next, w, h)
                frontier:put(_next, priority)
                came_from[_next] = current
            end
        end
    end
    return reconstruct_path(came_from, start, goal)
end
map_gen.a_star_search = a_star_search
-- ##########

return map_gen
