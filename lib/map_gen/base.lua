local PriorityQueue = require("lib.collections.priority_queue")
local shuffle = require("lib.shuffle")
local Rect = require("lib.rect")
local util = require("lib.util")
local time = love.timer.getTime

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

local function east_neighbor(i, w, h, r)
    r = r or 1
    local v = i + r
    local size = w * h
    local x, y = (((i - 1) % w) + 1), math.floor((i - 1) / w) + 1
    local nx, ny = (((v - 1) % w) + 1), math.floor((v - 1) / w) + 1
    return (
        v <= size and
        y == ny and
        v)

end
map_gen.east_neighbor = east_neighbor

local function west_neighbor(i, w, h, r)
    r = r or 1
    local v = i - r
    local x, y = (((i - 1) % w) + 1), math.floor((i - 1) / w) + 1
    local nx, ny = (((v - 1) % w) + 1), math.floor((v - 1) / w) + 1
    return (
        v > 0 and
        y == ny and
        v)
end
map_gen.west_neighbor = west_neighbor

local function north_neighbor(i, w, h, r)
    r = r or 1
    local v = i - (w * r)
    local x, y = (((i - 1) % w) + 1), math.floor((i - 1) / w) + 1
    local nx, ny = (((v - 1) % w) + 1), math.floor((v - 1) / w) + 1
    return (
        v > 0 and
        x == nx and
        v)
end
map_gen.north_neighbor = north_neighbor

local function south_neighbor(i, w, h, r)
    r = r or 1
    local v = i + (w * r)
    local size = w * h
    local x, y = (((i - 1) % w) + 1), math.floor((i - 1) / w) + 1
    local nx, ny = (((v - 1) % w) + 1), math.floor((v - 1) / w) + 1
    return (
        v <= size and
        x == nx and
        v)
end
map_gen.south_neighbor = south_neighbor

local function northeast_neighbor(i, w, h, r)
    r = r or 1
    local v = (i - w * r + r)
    local size = w * h
    local x, y = (((i - 1) % w) + 1), math.floor((i - 1) / w) + 1
    local nx, ny = (((v - 1) % w) + 1), math.floor((v - 1) / w) + 1
    return (
        v > 0 and
        v <= size and
        x + r == nx and
        y - r == ny and
        v)
end
map_gen.northeast_neighbor = northeast_neighbor

local function northwest_neighbor(i, w, h, r)
    r = r or 1
    local v = (i - w * r - r)
    local x, y = (((i - 1) % w) + 1), math.floor((i - 1) / w) + 1
    local nx, ny = (((v - 1) % w) + 1), math.floor((v - 1) / w) + 1
    return (
        v > 0 and
        x - r == nx and
        y - r == ny and
        v)
end
map_gen.northwest_neighbor = northwest_neighbor

local function southeast_neighbor(i, w, h, r)
    r = r or 1
    local v = (i + w * r + r)
    local size = w * h
    local x, y = (((i - 1) % w) + 1), math.floor((i - 1) / w) + 1
    local nx, ny = (((v - 1) % w) + 1), math.floor((v - 1) / w) + 1
    return (
        v <= size and
        x + r == nx and
        y + r == ny and
        v)
end
map_gen.southeast_neighbor = southeast_neighbor

local function southwest_neighbor(i, w, h, r)
    r = r or 1
    local v = (i + w * r - r)
    local size = w * h
    local x, y = (((i - 1) % w) + 1), math.floor((i - 1) / w) + 1
    local nx, ny = (((v - 1) % w) + 1), math.floor((v - 1) / w) + 1
    return (
        v > 0 and
        v <= size and
        x - r == nx and
        y + r == ny and
        v)
end
map_gen.southwest_neighbor = southwest_neighbor

-- ##########
-- Room class
local Room = class("Room", Rect)

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

function Room:__newindex(k, v)
    Rect.__newindex(self, "_tiles", nil)
    Rect.__newindex(self, k, v)
end

function Room:tiles()
    local tiles = self._tiles
    if tiles == nil then
        tiles = {}
        for x = self.x, self.right do
            for y = self.y, self.bottom do
                tiles[#tiles + 1] = {x, y}
            end
        end
        self._tiles = tiles
    end
    return tiles
end

map_gen.Room = Room

-- ##########
-- GraphNode class
local GraphNode = {
    x=false,
    y=false,
    block=false,
    explored=false,
    template="wall",
    cost = COST["wall"],
}

GraphNode.__index = GraphNode

setmetatable(
    GraphNode,
    {
        __call = function (class, ...)
            local self = setmetatable({}, class)
            if self.initialize then
                self:initialize(...)
            end
            return self
        end
    }
)
function GraphNode:initialize(t)
    t = t or {}
    self.x = self.x or t.x
    self.y = self.y or t.y
end

function GraphNode:set_template(name)
    self.template = name
    self.cost = COST[name]
end
-- ##########


-- ##########
-- Graph class
local Graph = class("Graph")

function Graph:initialize(w, h, map_file)
    local random = love.math.random or math.random
    local to_2d = to_2d

    self.nodes = {}
    local nodes = self.nodes

    local txt, block
    local map = {}
    self.w = w
    self.h = h

    self:fill()

    self:set_neighbors()
end

function Graph:create_node(x, y, i)
    return GraphNode{x = x, y = y}
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


function Graph:neighbor_functions()
    return {
        north_neighbor,
        east_neighbor,
        south_neighbor,
        west_neighbor,
        northeast_neighbor,
        southeast_neighbor,
        southwest_neighbor,
        northwest_neighbor,
    }
end

function Graph:neighbors_at_radius(r)
    local r = r or 1

    local h = self.h
    local w = self.w
    local size = w * h

    local t = {
        ["4d"] = {},
        ["8d"] = {},
        north = {},
        east = {},
        south = {},
        west = {}
    }
    local neighbors_4d = t["4d"]
    local neighbors_8d = t["8d"]
    local north = t["north"]
    local east = t["east"]
    local south = t["south"]
    local west = t["west"]
    local east_neighbor = east_neighbor
    local west_neighbor = west_neighbor
    local north_neighbor = north_neighbor
    local south_neighbor = south_neighbor
    local northeast_neighbor = northeast_neighbor
    local northwest_neighbor = northwest_neighbor
    local southeast_neighbor = southeast_neighbor
    local southwest_neighbor = southwest_neighbor

    for i = 1, size do
        neighbors_4d[i] = {}
        neighbors_8d[i] = {}
        local n4 = neighbors_4d[i]
        local n8 = neighbors_8d[i]

        local e_v = east_neighbor(i, w, h, r)
        if e_v then
            n4[#n4 + 1] = e_v
            n8[#n8 + 1] = e_v
            east[i] = e_v
        end

        local w_v = west_neighbor(i, w, h, r)
        if w_v then
            n4[#n4 + 1] = w_v
            n8[#n8 + 1] = w_v
            west[i] = w_v
        end

        local n_v = north_neighbor(i, w, h, r)
        if n_v then
            n4[#n4 + 1] = n_v
            n8[#n8 + 1] = n_v
            north[i] = n_v
        end

        local s_v = south_neighbor(i, w, h, r)
        if s_v then
            n4[#n4 + 1] = s_v
            n8[#n8 + 1] = s_v
            south[i] = s_v
        end

        local ne_v = northeast_neighbor(i, w, h, r)
        if ne_v then
            n8[#n8 + 1] = ne_v
        end

        local nw_v = northwest_neighbor(i, w, h, r)
        if nw_v then
            n8[#n8 + 1] = nw_v
        end

        local se_v = southeast_neighbor(i, w, h, r)
        if se_v then
            n8[#n8 + 1] = se_v
        end

        local sw_v = southwest_neighbor(i, w, h, r)
        if sw_v then
            n8[#n8 + 1] = sw_v
        end
        neighbors_4d[i] = shuffle(neighbors_4d[i])
        neighbors_8d[i] = shuffle(neighbors_8d[i])
    end
    return t
end

function Graph:set_neighbors()
    local res = self:neighbors_at_radius(1)
    self.neighbors_4d = res["4d"]
    self.neighbors_8d = res["8d"]
    self.north = res["north"]
    self.east = res["east"]
    self.south = res["south"]
    self.west = res["west"]
end

function Graph:get_neighbors(i, mode, check)
    local h = self.h
    local w = self.w
    local nodes = self.nodes
    local size = w * h
    local mode = mode or 8
    local neighbors
    if mode == 8 then
        neighbors = self.neighbors_8d[i]
    else
        neighbors = self.neighbors_4d[i]
    end

    if not check then
        return neighbors
    else
        local valid_nodes = {}
        for i = 1, #neighbors do
            local pos = neighbors[i]
            if check(pos) == true then
                valid_nodes[#valid_nodes + 1] = pos
            end
        end
        return valid_nodes
    end
end

map_gen.Graph = Graph

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

        local _neighbors = neighbors(current, false)
        for i = 1, #_neighbors do
            local _next = _neighbors[i]
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
