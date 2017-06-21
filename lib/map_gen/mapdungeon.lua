local itertools = require("itertools")
local split_around = itertools.split_around
local ichain = itertools.ichain
local reversed = itertools.reversed
local shuffle = require("shuffle")
local templates = require("templates")
local TileConstants = templates.constants.EnumTileEntity
local WALL = TileConstants.wall
local FLOOR = TileConstants.floor
local HALL = TileConstants.hall

local creator = require("map_gen.creator")
local apply_tiling = creator.apply_tiling
local MapCreator = creator.MapCreator
local map_gen_base = require("map_gen.base")
local Room = map_gen_base.Room
local heapsort = map_gen_base.heapsort
local a_star_search = map_gen_base.a_star_search
local heuristic2d = map_gen_base.heuristic2d
local to_1d = map_gen_base.to_1d

local time = time
local random = math.random

local MODULE = {}

local ROOM_MAX_SIZE = 10
local ROOM_MIN_SIZE = 5
local MAP_COLS = 40 * 3
local MAP_ROWS = 24 * 3
local SECTOR_SIZE = 16
local SECTORS_WIDE_MIN = 4
local SECTORS_WIDE_MAX = 7
local SECTORS_HIGH_MIN = 4
local SECTORS_HIGH_MAX = 6


-- ##########
-- MapDungeon02 class
local MapDungeon02 = class("MapDungeon02", MapCreator)

function MapDungeon02:init()
    self.rooms = {}
    self.sectors = {}
    self.halls = {}
end

function MapDungeon02:create(header)
    self.header = header
    local cols, rows = self:create_sectors()
    MapCreator.create(self, cols, rows) -- super

    self.start_pos, self.end_pos = self:create_rooms()

    self:create_halls()

    local map = self:standard_map()

    apply_tiling(map)

    return map
end

-- neighborhood_cost
local function cost(graph, a, b)
    local nodes = graph.nodes

    local sum = 0
    local n = nodes[b].neighbors
    sum = sum + n.north     == 0 and 0 or nodes[n.north].cost
    sum = sum + n.east      == 0 and 0 or nodes[n.east].cost
    sum = sum + n.south     == 0 and 0 or nodes[n.south].cost
    sum = sum + n.west      == 0 and 0 or nodes[n.west].cost
    sum = sum + n.northeast == 0 and 0 or nodes[n.northeast].cost
    sum = sum + n.southeast == 0 and 0 or nodes[n.southeast].cost
    sum = sum + n.southwest == 0 and 0 or nodes[n.southwest].cost
    sum = sum + n.northwest == 0 and 0 or nodes[n.northwest].cost

    local main = nodes[b].cost

    return main * 8 + sum
end
MODULE.cost = cost


local function create_sectors(sectors)
    --[[
    Create n SECTOR_SIZExSECTOR_SIZE sectors.

    Return the width and height of the map now defined.
    ]]--
    local random = random

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
                sector.w, sector:get_right(), sector.h, sector:get_bottom()))
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
MODULE.create_sectors = create_sectors

local function create_rooms(graph, rooms, sectors)
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
    local random = random
    local irregulars = 0
    local map_w, map_h = graph.w, graph.h
    local w, h, irregular
    local Room = Room
    local heuristic2d = heuristic2d


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

        local x = random(sector.x + 1, sector:get_right() - w - 3)
        local y = random(sector.y + 1, sector:get_bottom() - h - 3)

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
        local dist = heuristic2d(start_room:get_center(), room:get_center())
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
            -- # x, y = room:get_center() - [r, r]

            room._tiles = [(r_pos[0] + x, r_pos[1] + y)
                           for r_pos, tile in room_tiles.items()
                           if tile == "."]

        ]]--
        local tiles = room:tiles()
        for i = 1, #tiles do
            local pos = tiles[i]
            local tile = assert(graph:get(pos[1], pos[2]))
            tile:set_template(FLOOR)
        end
    end
    return start_room, end_room
end
MODULE.create_rooms = create_rooms

local function sorted_rooms(rooms)
    return heapsort(rooms,
        function(room)
            return heuristic2d({1, 1}, room:get_center())
        end)
end

local function create_halls(graph, rooms, halls)
    local nodes = graph.nodes
    local map_w, map_h = graph.w, graph.h
    local a_star = a_star_search
    local sorted_rooms = sorted_rooms(rooms)

    local floor = math.floor
    local random = random

    local cost_func = cost

    local not_on_border = function(i)

        local x = ((i - 1) % map_w) + 1
        if x == 1 or x == map_w then
            return false
        end

        local y = floor((i - 1) / map_w) + 1
        if y == 1 or y == map_h then
            return false
        end
        return true
    end

    local neighbor_func = function(i, blocked)
        local res = {}
        local n = nodes[i].neighbors

        local north = n.north == 0 and false or not_on_border(n.north)
        if north then res[#res + 1] = n.north end

        local east = n.east == 0 and false or not_on_border(n.east)
        if east then res[#res + 1] = n.east end

        local south = n.south == 0 and false or not_on_border(n.south)
        if south then res[#res + 1] = n.south end

        local west = n.west == 0 and false or not_on_border(n.west)
        if west then res[#res + 1] = n.west end

        return res
    end

    local tiles = function (gen)
        local r = {}
        for i = 1, #gen do
            r[#r + 1] = graph:get(gen[i])
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
        return(to_1d(pos[1], pos[2], map_w, map_h))
    end

    local dig_hall = function(start, goal)
        -- local function a_star_search(graph, start, goal)
        local path = a_star(
            graph,
            to_1d(start:get_center()),
            to_1d(goal:get_center()),
            cost_func,
            neighbor_func
        )

        for i, tile in tiles(path) do
            if tile.template == WALL then
                tile:set_template(HALL)
            end
        end
        return path
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

    log:warn("MapDungeon02:create_halls:start")
    local t0 = time()

    local previous
    for i = 1, #sorted_rooms do
        local room = sorted_rooms[i]
        if i == 1 then
            previous = room
        else
            local current = #halls + 1
            log:info("MapDungeon02:create_halls:", current)
            halls[#halls + 1] = dig_hall(previous, room)
            log:info("MapDungeon02:create_halls:done", current)
            if random(5) == 1 then
                -- dig an extra hall
                local current = #halls + 1
                log:info("MapDungeon02:create_halls(extra):", current)
                local other_room = pick_a_room(sorted_rooms, room)
                -- print("other_room", other_room)
                halls[#halls + 1] = dig_hall(other_room, room)
                log:info("MapDungeon02:create_halls(extra):done", current)
            end
            previous = room
        end
    end

    for i = 1, #halls do
        local hall = halls[i]
        for _, tile in tiles(hall) do
            tile:set_template(FLOOR)
        end
    end

    local t1 = time()
    log:warn("MapDungeon02:create_halls:done", t1-t0)
end
MODULE.create_halls = create_halls


-- ##########

return MODULE
