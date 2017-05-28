local PriorityQueue = require("lib.collections.priority_queue")
local shuffle = require("lib.shuffle")
local Rect = require("lib.rect")

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

function Graph:create_node(x, y)
    return GraphNode{x = x, y = y}
end

function Graph:fill()
    local w, h = self.w, self.h
    local nodes = self.nodes
    for i  = 1, w * h do
        local x, y  = to_2d(i, w, h)
        nodes[i] = self:create_node(x, y)
    end
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

function Graph:set_neighbors()
    local h = self.h
    local w = self.w
    local size = w * h

    local neighbors_4d = {}
    local neighbors_8d = {}
    local north = {}
    local east = {}
    local south = {}
    local west = {}
    for i = 1, size do
        neighbors_4d[i] = {}
        neighbors_8d[i] = {}
        local neighbor_index
        local n4 = neighbors_4d[i]
        local n8 = neighbors_8d[i]
        if i % w ~= 0 then
            neighbor_index = i + 1 -- east
            n4[#n4 + 1] = neighbor_index
            n8[#n8 + 1] = neighbor_index
            east[i] = neighbor_index
        end
        if (i - 1) % w ~= 0 then
            neighbor_index = i - 1 -- west
            n4[#n4 + 1] = neighbor_index
            n8[#n8 + 1] = neighbor_index
            west[i] = neighbor_index
        end
        if i - w > 0 then
            neighbor_index = i - w -- north
            n4[#n4 + 1] = neighbor_index
            n8[#n8 + 1] = neighbor_index
            north[i] = neighbor_index
        end
        if i + w <= size then
            neighbor_index = i + w -- south
            n4[#n4 + 1] = neighbor_index
            n8[#n8 + 1] = neighbor_index
            south[i] = neighbor_index
        end
        if ((i - w + 1) > 0) and (i % w ~= 0) then
            n8[#n8 + 1] = i - w + 1  -- northeast
        end
        if ((i - w - 1) > 0) and ((i - 1) % w ~= 0) then
            n8[#n8 + 1] = i - w - 1  -- northwest
        end
        if ((i + w + 1) <= size) and (i % w ~= 0) then
            n8[#n8 + 1] = i + w + 1  -- southeast
        end
        if ((i + w - 1) <= size) and ((i - 1) % w ~= 0) then
            n8[#n8 + 1] = i + w - 1  -- southwest
        end
        neighbors_4d[i] = shuffle(neighbors_4d[i])
        neighbors_8d[i] = shuffle(neighbors_8d[i])
    end

    self.neighbors_4d = neighbors_4d
    self.neighbors_8d = neighbors_8d
    self.north = north
    self.east = east
    self.south = south
    self.west = west
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
