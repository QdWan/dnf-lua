local PriorityQueue = require("collections.priority_queue")
local shuffle = require("shuffle")
local Rect = require("rect")
local ffi_struct = require("util.ffi_struct")
local templates = require("templates")
local TileConstants = templates.constants.EnumTileEntity
local WALL = TileConstants.wall
local FLOOR = TileConstants.floor
local HALL = TileConstants.hall

local COST = {
    [HALL] = 6,
    [FLOOR] = 64,
    [WALL] = 12
}

local map_gen = {}


local function heapsort(t, cmp)
    local pq = PriorityQueue({mode="highest_table"})
    for i = 1, #t do
        local node = t[i]
        local priority = cmp(node)
        pq:put({v=node, p=priority})
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
    local to_1d = to_1d
    local to_2d = to_2d
    local nodes = graph.nodes

    for y = 1, h do
        for x = 1, w do
            local node = graph:get(x, y)
            local c
            if node.template == WALL then
                c = "#"
            elseif node.template == FLOOR then
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

    local t = node.neighbors

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
-- NodeNeighbors struct
local _NodeNeighbors = [[typedef struct {
    uint16_t  north;
    uint16_t  east;
    uint16_t  south;
    uint16_t  west;
    uint16_t  northeast;
    uint16_t  southeast;
    uint16_t  southwest;
    uint16_t  northwest;
} NodeNeighbors;]]
ffi_struct("NodeNeighbors", _NodeNeighbors)
-- end of NodeNeighbors struct
-- ##########


-- ##########
-- RGBColor struct
local _RGBColor = [[typedef struct {
    uint8_t   r;
    uint8_t   g;
    uint8_t   b;
} RGBColor;]]
ffi_struct("RGBColor", _RGBColor)
-- end of RGBColor struct
-- ##########


-- ##########
-- GraphNodeMeta struct
local _GraphNodeMeta = [[typedef struct {
    RGBColor heat_color;
    uint8_t heat_template;
    double heat_value;

    RGBColor height_color;
    uint8_t height_template;
    double height_value;

    RGBColor rainfall_color;
    uint8_t rainfall_template;
    double rainfall_value;

    double noise_value;
    double water_ratio_r1;
    double water_ratio_r2;
    double water_ratio_r4;
    double forest_ratio_r4;
} GraphNodeMeta;]]
ffi_struct("GraphNodeMeta", _GraphNodeMeta)
-- end of GraphNodeMeta struct
-- ##########


-- ##########
-- GraphNode struct
local _GraphNode = [[typedef struct {
    uint16_t  x;
    uint16_t  y;
    uint16_t  cost;
    bool  block;
    bool  explored;
    double value;
    uint8_t template;
    uint8_t tile_pos;
    uint8_t tile_pos_shadow;
    uint8_t tile_var;
    NodeNeighbors neighbors;
    GraphNodeMeta meta;
} GraphNode;]]
local GraphNode_mt, GraphNode_keys = ffi_struct(
    "GraphNode", _GraphNode, false)
GraphNode_mt.__index = {}
local GraphNode_functions = GraphNode_mt.__index
function GraphNode_functions.set_template(self, template)
    self.template = template
    self.cost = COST[template]
end
ffi.metatype("GraphNode", GraphNode_mt)
local GraphNode = ffi.typeof('GraphNode')
-- end of GraphNode struct
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

    self.nodes = ffi.new("GraphNode[?]", (w * h) + 1)

    local txt, block
    self.w = w
    self.h = h

    self:fill()
end

function Graph:fill()
    local t0 = time()
    local w, h = self.w, self.h
    log:warn("Graph:fill: start w " .. w .. ", h " .. h)
    local nodes = self.nodes
    local floor = math.floor
    local WALL, COST_WALL = WALL, COST[WALL]
    local neighbors = neighbors

    for i  = 1, w * h do
        local node = nodes[i]
        node.x, node.y = (((i - 1) % w) + 1), floor((i - 1) / w) + 1
        node.template, node.cost = WALL, COST_WALL
        neighbors(i, w, h, 1, node)
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

        local node_neighbors = neighbors and neighbors(current) or
                               nodes[current].neighbors[1]
        for i, nxt in ipairs(node_neighbors) do
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
