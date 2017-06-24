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

local map_containers = require("dnf.map_containers")
local entities = require("dnf.entities")
local map_gen_base = require("map_gen.base")
local Graph = map_gen_base.Graph
local templates = require("templates")
local tile_templates = templates.enum.TileEntity
local tile_groups  = templates.constants.groups
local WATER_GROUP  = tile_groups.WATER_GROUP

local max = math.max
local min = math.min



local creator = {}

local function get_creator(header)
    -- Utility method to create by mode/name.
    return require("map_gen." .. header.creator)
end

creator.get = get_creator

-- ##########
-- MapCreator class
local MapCreator = class("MapCreator")

function MapCreator:create(cols, rows)
    self.map = Graph(cols, rows)
end

creator.MapCreator = MapCreator
-- ##########


local function calculate_tiling(map, tile, i, fn)
    --[[Calculate the tile index of a node based on its neighbors.]]--
    local s = 0
    local tiles = map.tiles
    local neighbors = assert(tile.neighbors)

    local north_index = neighbors.north
    local north_tile = north_index > 0 and tiles[north_index]
    if north_tile and north_tile ~= tile and fn(tile, north_tile) then
        s = s + 1
    end

    local west_index = neighbors.west
    local west_tile = west_index > 0 and tiles[west_index]
    if west_tile and west_tile ~= tile and fn(tile, west_tile) then
        s = s + 2
    end

    local east_index = neighbors.east
    local east_tile = east_index > 0 and tiles[east_index]
    if east_tile and east_tile ~= tile and fn(tile, east_tile) then
        s = s + 4
    end

    local south_index = neighbors.south
    local south_tile = south_index > 0 and tiles[south_index]
    if south_tile and south_tile ~= tile and fn(tile, south_tile) then
        s = s + 8
    end

    return s
end

local conversion_8bit = {
       [0] = 46,   [2] = 1,    [8] = 2,   [10] = 3,   [11] = 4,   [16] = 5,
      [18] = 6,   [22] = 7,   [24] = 8,   [26] = 9,   [27] = 10,  [30] = 11,
      [31] = 12,  [64] = 13,  [66] = 14,  [72] = 15,  [74] = 16,  [75] = 17,
      [80] = 18,  [82] = 19,  [86] = 20,  [88] = 21,  [90] = 22,  [91] = 23,
      [94] = 24,  [95] = 25, [104] = 26, [106] = 27, [107] = 28, [120] = 29,
     [122] = 30, [123] = 31, [126] = 32, [127] = 33, [208] = 34, [210] = 35,
     [214] = 36, [216] = 37, [218] = 38, [219] = 39, [222] = 40, [223] = 41,
     [248] = 42, [250] = 43, [251] = 44, [254] = 45, [255] = 0,
}


local c0_lookup = {[0] =  0, [1] = 1, [2] = 2, [3] =  3, [7] = 12}
local c1_lookup = {[0] =  4, [1] = 5, [2] = 2, [3] =  6, [7] = 12}
local c2_lookup = {[0] =  7, [1] = 8, [2] = 1, [3] =  9, [7] = 12}
local c3_lookup = {[0] = 10, [1] = 8, [2] = 5, [3] = 11, [7] = 12}

local function calculate_tiling_4bit(map, t, i, same)
    local tiles = map.tiles
    local n = t.neighbors

    local north_check = n.north     == 0 or same(t, tiles[n.north])
    local east_check  = n.east      == 0 or same(t, tiles[n.east])
    local south_check = n.south     == 0 or same(t, tiles[n.south])
    local west_check  = n.west      == 0 or same(t, tiles[n.west])
    local northwest_check = (north_check and west_check) and
                        (n.northwest == 0 or same(t, tiles[n.northwest]))
    local northeast_check = (north_check and east_check) and
                        (n.northeast == 0 or same(t, tiles[n.northeast]))
    local southwest_check = (south_check and west_check) and
                        (n.southwest == 0 or same(t, tiles[n.southwest]))
    local southeast_check = (south_check and east_check) and
                        (n.southeast == 0 or same(t, tiles[n.southeast]))

    do -- C0 topleft
        local north     = north_check     and 1 or 0
        local west      = west_check      and 2 or 0
        local northwest = northwest_check and 4 or 0
        t.c0.pos   = assert(c0_lookup[north + west + northwest]) + 1
    end
    do -- C1 topright
        local north     = north_check     and 1 or 0
        local east      = east_check      and 2 or 0
        local northeast = northeast_check and 4 or 0
        t.c1.pos   = assert(c1_lookup[north + east + northeast]) + 1
    end
    do -- C2 bottomleft
        local west      = west_check      and 1 or 0
        local south     = south_check     and 2 or 0
        local southwest = southwest_check and 4 or 0
        t.c2.pos   = assert(c2_lookup[west + south + southwest]) + 1
    end
    do -- C3 bottomright
        local east      = east_check      and 1 or 0
        local south     = south_check     and 2 or 0
        local southeast = southeast_check and 4 or 0
        t.c3.pos   = assert(c3_lookup[east + south + southeast]) + 1
    end
end

local function calculate_tiling_8bit(map, tile, i, same)
    --[[Calculate the tile index of a node based on its neighbors.

    Cardinal directions and diagonals are considered.]]--
    local tiles = map.tiles
    local neighbors = tiles[i].neighbors

    local directions = {
        northwest = {v = 2^0, condition = {"north", "west"}}, --   1
        north     = {v = 2^1},                                --   2
        northeast = {v = 2^2, condition = {"north", "east"}}, --   4
        west      = {v = 2^3},                                --   8
        east      = {v = 2^4},                                --  16
        southwest = {v = 2^5, condition = {"south", "west"}}, --  32
        south     = {v = 2^6},                                --  64
        southeast = {v = 2^7, condition = {"south", "east"}}, -- 128
     }

    local function should_count(direction)
        local index = neighbors[direction]
        local neighbor_tile = index ~= 0 and tiles[index]
        return not neighbor_tile or same(tile, neighbor_tile)
    end

    local sum = 0
    for direction, table in pairs(directions) do
        local count
        local extras = table.condition
        if extras then
            count = should_count(extras[1]) and should_count(extras[2]) and
                    should_count(direction)
        else
            count = should_count(direction)
        end

        if count then
            sum = sum + table.v
        end
    end
    return conversion_8bit[sum] + 1
end

local function calculate_shadow(node, neighbor)
    local tile_templates = tile_templates
    local template = tile_templates[neighbor.template]
    return not template.block_sight
end

local tiling_compare = {}

function tiling_compare.same_template(node, neighbor)
    return node.template == neighbor.template
end

function tiling_compare.same_group0(node, neighbor)
    local tile_templates = tile_templates
    local tile_groups  = tile_groups
    local template_data = tile_templates[node.template]
    local group0_k = template_data.group0
    local group0 = tile_groups[group0_k]
    return group0[neighbor.template]
end

function tiling_compare.same_id(node, neighbor)
    local tile_templates = tile_templates
    local template = tile_templates[node.template]
    local n_template = tile_templates[neighbor.template]
    return template.id == n_template.id
end

function tiling_compare.is_water(node, neighbor)
    return WATER_GROUP[neighbor.template]
end

local function apply_tiling(map)
    local tiling_compare = tiling_compare
    local tiles = map.tiles
    local tile_templates = tile_templates
    for i = 1, map.w * map.h do
        local tile = map.tiles[i]
        local template = tile_templates[tile.template]
        if template.receive_shadow then
            tile.tile_pos_shadow = calculate_tiling(
                map, tile, i, calculate_shadow)
        end
        if template.tiling == "8bit" then
            tile.tile_pos = calculate_tiling_8bit(
                map, tile, i,
                assert(tiling_compare[template.compare_function],
                    string.format(
                        "invalid compare_function ('%s') on template '%s'",
                        template.compare_function, tile.template
                    )
                )
            )
        elseif template.tiling == "4bit" then
            if template.image == "temperate_desert" then
                tile.c0.pos = 13
                tile.c1.pos = 13
                tile.c2.pos = 13
                tile.c3.pos = 13
            else
                calculate_tiling_4bit(
                    map, tile, i,
                    assert(tiling_compare[template.compare_function],
                        string.format(
                            "invalid compare_function('%s') on template '%s'",
                            template.compare_function, tile.template
                        )
                    ))
            end
        end
    end
    return map
end
creator.apply_tiling = apply_tiling

function creator.standard_map(graph, header, info)
    info = info or {}
    local map = map_containers.Map{
        w = graph.w,
        h = graph.h,
        tiles = graph.nodes,
        header = header,
        rooms = info.rooms,
        halls = info.halls,
        doors = info.doors,
        tile_fx = {},
        links = {},
        _start = info.start_pos,
        _end = info.end_pos,
    }
    return map
end

return creator
