--[[Dungeon generator.

    - split the grid of in 5-9 rows and 5-9 cols of
    SECTOR_SIZExSECTOR_SIZE sectors;
    - for each sector:
        > define room size:
            w= rnd(min_size, max_size)
            h= rnd(min_size, max_size)
        > define position in sector;
    - pick a random room, define it as start and place up stairs;
    - choose an unconnected random room and try to connect to it by digging a
    hall that do not overlaps or touches other rooms (a* pathfinding). Use
    reduced movement cost for hall tiles (to avoid redundant halls);
    - consider a random chance to put an extra connection starting on the
    current room;
    - repeat previous step until rooms all are connected;
    - make the last room used as end and place down stairs.
--]]


-- package.path = "lib/?.lua;../lib/?.lua;?/init.lua;" .. package.path
-- require("rs_strict")
-- local class = require("middleclass")
local Properties = require('properties')
local inspect = require("inspect")
local PriorityQueue = require("priority_queue")
local map_entities = require("dnf.map_entities")

local Rect = require("rect")
local shuffle = require("shuffle")
local abs = math.abs
local random = love.math.random or math.random
local floor = math.floor
local max = math.max
local min = math.min

local ROOM_MAX_SIZE = 10
local ROOM_MIN_SIZE = 5
local MAP_COLS = 40 * 3
local MAP_ROWS = 24 * 3
local SECTOR_SIZE = 16
local SECTORS_WIDE_MIN = 4
local SECTORS_WIDE_MAX = 7
local SECTORS_HIGH_MIN = 4
local SECTORS_HIGH_MAX = 6
local COST = {
    hall = 6,
    floor = 64,
    wall = 12
}

local map_gen = {creators = {}}

local function get_creator(header)
    -- Utility method to create by mode/name.
    return map_gen.creators[header.creator]()
end

map_gen.get_creator = get_creator


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

local function heuristic(a, b, w, h)
    return (abs((a % w) - (b % w)) + abs(floor(a / h) - floor(b / h)))
end

local function heuristic2d(a, b)
    return abs(a[1] - b[1]) + abs(a[2] - b[2])
end

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

local function to_2d(i, w, h)
    if i == 0 or i > w * h then
        error(string.format("to_2d error: i = %d", i))
    end
    return (((i - 1) % w) + 1), floor((i - 1) / w) + 1
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

-- ##########
-- Node class
local Node = {
    x=false,
    y=false,
    block=false,
    explored=false,
    template="wall",
    cost = COST["wall"],
}

Node.__index = Node

setmetatable(
    Node,
    {
        __call = function(self, t)
            local node = setmetatable(t, self)
            node:set_template(node.template)
            return node
        end
    }
)

function Node:set_template(name)
    self.template = name
    self.cost = COST[name]
end
-- ##########


-- ##########
-- Graph class
local Graph = class("Graph")

function Graph:initialize(w, h, map_file)
    local random = random
    local to_2d = to_2d

    self.nodes = {}
    local nodes = self.nodes

    local txt, block
    local map = {}
    self.w = w
    self.h = h

    for i  = 1, w * h do
        local x, y  = to_2d(i, w, h)
        nodes[i] = Node{x = x, y = y}
    end

    self:set_neighbors()
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
    local random = random
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
    for i = 1, size do
        neighbors_4d[i] = {}
        neighbors_8d[i] = {}
        local n4 = neighbors_4d[i]
        local n8 = neighbors_8d[i]
        if i % w ~= 0 then
            n4[#n4 + 1] = i + 1 -- east
            n8[#n8 + 1] = i + 1 -- east
        end
        if (i - 1) % w ~= 0 then
            n4[#n4 + 1] =  i - 1 -- west
            n8[#n8 + 1] =  i - 1 -- west
        end
        if i - w > 0 then
            n4[#n4 + 1] =  i - w -- north
            n8[#n8 + 1] =  i - w -- north
        end
        if i + w <= size then
            n4[#n4 + 1] = i + w -- south
            n8[#n8 + 1] = i + w -- south
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
-- ##########


-- ##########
-- MapCreator class
local MapCreator = class("MapCreator"):include(Properties)

function MapCreator:getter_cols()
    local cols = self._cols
    if cols == nil then
        local cols = self.map.w
        self._cols = cols
    end
    return cols
end

function MapCreator:getter_rows()
    local rows = self._rows
    if rows == nil then
        local rows = self.map.h
        self._rows = rows
    end
    return rows
end

function MapCreator:create(cols, rows)
    self.map = Graph(cols, rows)
end
-- ##########


-- ##########
-- MapCreator class
local RndMap2 = class("RndMap2", MapCreator)

function RndMap2:initialize()
    self.rooms = {}
    self.sectors = {}
    self.halls = {}
end

function RndMap2:create(header)
    self.header = header
    local cols, rows = self:create_sectors()
    MapCreator.create(self, cols, rows) -- super

    self.start_pos, self.end_pos = self:create_rooms()

    self:create_halls()

    return self:standard_map()
end

function RndMap2:create_sectors()
    --[[
    Create n SECTOR_SIZExSECTOR_SIZE sectors.

    Return the width and height of the map now defined.
    ]]--
    local sectors = self.sectors

    local sectors_wide = random(SECTORS_WIDE_MIN, SECTORS_WIDE_MAX)
    local sectors_high = random(SECTORS_HIGH_MIN, SECTORS_HIGH_MAX)

    for x = 0, sectors_wide - 1 do
        for y = 0, sectors_high - 1 do
            local sector = Rect(x * SECTOR_SIZE + 1, y * SECTOR_SIZE + 1,
                SECTOR_SIZE, SECTOR_SIZE)
            --[[
            print(string.format(
                "new sector %d, %d, %d(%d), %d(%d)",
                sector.x, sector.y,
                sector.w, sector.right, sector.h, sector.bottom))
            ]]--
            sectors[#sectors + 1] = sector
        end
    end

    local map_width = sectors_wide * SECTOR_SIZE
    local map_height = sectors_high * SECTOR_SIZE
    print(string.format(
        "map_width %d(%d), map_height %d(%d)",
        map_width, sectors_wide, map_height, sectors_high))

    return map_width, map_height
end

function RndMap2:create_rooms()
    --[[
    Create a room in each sector.

    Go through its tiles and make them passable.
    Return a random room and the width and height of the map now defined.
    ]]--

    --[[

    def get_tile(pos):
        return grid[pos]._tile

    def tiles(gen):
        for pos in gen:
            yield get_tile(pos)
    ]]--
    local grid = self.map
    local irregulars = 0
    local rooms = self.rooms
    local sectors = self.sectors
    local map_w, map_h = self.cols, self.rows
    local w, h, irregular


    for i = 1, #sectors do
        local sector = sectors[i]
        if random(50) == 51 and #irregulars == 0 then
            w = ROOM_MAX_SIZE
            h = ROOM_MAX_SIZE

            irregular = true
            irregulars = irregulars + 1
        else
            irregular = false
            w = random(ROOM_MIN_SIZE, ROOM_MAX_SIZE)
            h = random(ROOM_MIN_SIZE, ROOM_MAX_SIZE)
        end

        local x = random(sector.x + 1, sector.right - w - 3)
        local y = random(sector.y + 1, sector.bottom - h - 3)

        local new_room = Room(x, y, w, h)
        new_room.irregular = irregular

        new_room.sector = sector
        sector.room = new_room

        rooms[#rooms + 1] = new_room
    end
    -- print(irregulars)

    shuffle(rooms)
    local start_room = rooms[1]
    local end_room
    local end_dist = 0

    for i = 2, #rooms do
        local room = rooms[i]
        local dist = heuristic2d(start_room.center, room.center)
        if dist > end_dist then
            end_room = room
            end_dist = dist
        end
    end

    for i = 1, #rooms do
        local room = rooms[i]
        if room.irregular and room ~= start_room and room ~= end_room then
        end
        --[[

            r = floor(room.w / 2)
            --sides = random.choice([6, 8])
            sides = 8
            room_tiles = reg_convex_poly_room(sides, r, 360)
            x, y = room.x, room.y
            room.__class__ = RoomIrregular
            -- # x, y = room.center - [r, r]

            room._tiles = [(r_pos[0] + x, r_pos[1] + y)
                           for r_pos, tile in room_tiles.items()
                           if tile == "."]

        ]]--
        local tiles = room:tiles()
        for i = 1, #tiles do
            local pos = tiles[i]
            local tile = grid:get(pos[1], pos[2])
            tile:set_template('floor')
        end
    end
    return start_room, end_room
end

function RndMap2:create_halls()
    local grid = self.map
    local halls = self.halls
    local a_star = a_star_search
    local sorted_rooms = self:sorted_rooms()

    local cost_func = function(a, b)
        return self:cost(a, b)
    end

    local not_on_border = function(i)

        local x = ((i - 1) % self.cols) + 1
        if x == 1 or x == self.cols then
            --[[

            print(string.format(
                "was border: i=%d(x=%d, y=%d), rows=%d, cols=%d (mod=%d)",
                i, x, y, self.rows, self.cols, mod))
            ]]--
            return false
        end

        local y = floor((i - 1) / self.cols) + 1
        if y == 1 or y == self.rows then
            --[[

            print(string.format(
                "was border: i=%d(x=%d, y=%d), rows=%d, cols=%d",
                i, x, y, self.rows, self.cols))
            ]]--
            return false
        end
        return true
    end

    local neighbor_func = function(i, blocked)
        return grid:get_neighbors(i, 4, not_on_border)
    end

    local get_tile = function(pos)
        return grid:get(pos)
    end

    local tiles = function (gen)
        local r = {}
        for i = 1, #gen do
            r[#r + 1] = get_tile(gen[i])
        end
        local i = 0
        local n = #r
        return function()
            i = i + 1
            if i <= n then
                return i, r[i]
            end
        end
    end

    local _to_1d = to_1d
    local to_1d = function(pos)
        return(to_1d(pos[1], pos[2], self.cols, self.rows))
    end

    local dig_hall = function(start, goal)
        -- local function a_star_search(graph, start, goal)
        local path = a_star(
            grid,
            to_1d(start.center),
            to_1d(goal.center),
            cost_func,
            neighbor_func
        )

        for i, tile in tiles(path) do
            if tile.template == "wall" then
                tile:set_template("hall")
            end
        end
        return path
    end

    local index = function(t, v)
        for i = 1, #t do
            if t[i] == v then
                return i
            end
        end
    end

    local split_around = function(t, v)
        local _index = index(t, v)
        local size = #t
        local l_size = floor(size / 2)
        local r_size = size - l_size - 1
        local left = {}
        local right = {}
        -- left
        for i = l_size, 1, -1 do
            local wrap_i = ((_index - i - 1) % size) + 1
            left[#left + 1] = t[wrap_i]
        end
        -- right
        for i = 1, r_size do
            local wrap_i = ((_index + i - 1) % size) + 1
            right[#right + 1] = t[wrap_i]
        end
        return left, right
    end

    local reversed = function(t)
        local res = {}
        for i = #t, 1, -1 do
            res[#res + 1] = t[i]
        end
        return res
    end

    local ichain = function(...)
        local arrays = {...}
        local res = {}
        local max
        for i = 1, #arrays do
            local t = arrays[i]
            max = math.max(max or #t, #t)
        end
        for j = 1, max do
            for i = 1, #arrays do
                local t = arrays[i]
                local v = t[j]
                if v ~= nil then
                    res[#res + 1] = t[j]
                end
            end
        end
        local i = 0
        local n = #res
        return function ()
            i = i + 1
            if i <= n then
                return i, res[i]
            end
        end
    end

    local pick_a_room = function(t, v)
        local left, right = split_around(t, v)
        local size = #left + #right
        for i, room in ichain(reversed(left), right) do
            local chance = random(floor((size - i) / 2) + 1, size)
            if chance == size or i == size then
                return room
            end
        end
        error("no room returned")
    end

    local previous
    for i = 1, #sorted_rooms do
        local room = sorted_rooms[i]
        if i == 1 then
            previous = room
        else
            halls[#halls + 1] = dig_hall(previous, room)
            if random(5) == 1 then
                -- dig an extra hall
                print("extra hall")
                local other_room = pick_a_room(sorted_rooms, room)
                -- print("other_room", other_room)
                halls[#halls + 1] = dig_hall(other_room, room)
            end
            previous = room
        end
    end

    for i = 1, #halls do
        local hall = halls[i]
        for _, tile in tiles(hall) do
            tile:set_template("floor")
        end
    end
end

function RndMap2:sorted_rooms()
    return heapsort(self.rooms,
        function(room)
            return heuristic2d({1, 1}, room.center)
        end)
end

function RndMap2:cost(a, b)
    local map = self.map

    local neighbors = function(i)
        return map:get_neighbors(i, 8)
    end

    local sum_cost = function(t)
        local sum = 0
        local nodes = map.nodes
        for i = 1, #t do
            sum = sum + nodes[t[i]].cost
        end
        return sum
    end

    local neighborhood_cost = function(i)
        return sum_cost(neighbors(i))
    end

    local main = map.nodes[b].cost

    local nc = neighborhood_cost(b)

    return main * 8 + nc
end

function RndMap2:standard_map()
    local map = {
        header = self.header,
        rooms = self.rooms,
        halls = self.halls,
        doors = self.doors,
        w = self.map.w,
        h = self.map.h,
        tile_fx = {},
        links = {},
        _start = self.start_pos,
        _end = self.end_pos,
        nodes = self.map.nodes,
        get = self.map.get,
    }
    for i = 1, #map.nodes do
        local tile = map_entities.TileEntity({
            name = map.nodes[i].template
        })
        map.nodes[i] = {
            tile = tile,
            features = {},
            items = {},
            creatures = {}
        }
    end
    return map
end
-- ##########

--[[
local w, h = 96, 64
local x, y = 20, 64
local i = to_1d(x, y, w, h)
print(i)
x, y = to_2d(i, w, h)
print(x, y)
math.randomseed(7)
local rnd_map = RndMap2()
local map = rnd_map:create()
print_graph(map)
]]--

map_gen.creators["RndMap2"] = RndMap2

return map_gen
