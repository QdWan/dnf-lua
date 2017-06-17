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

local max = math.max
local min = math.min

local Graph = map_gen_base.Graph


local creator = {}

local function get_creator(header)
    -- Utility method to create by mode/name.
    return creator[header.creator]()
end

creator.get = get_creator

-- ##########
-- MapCreator class
local MapCreator = class("MapCreator")

function MapCreator:create(cols, rows)
    self.map = Graph(cols, rows)
end

function MapCreator:standard_map(graph)
    local graph = graph or self.map
    local map = map_containers.Map{
        header = self.header,
        rooms = self.rooms,
        halls = self.halls,
        doors = self.doors,
        w = graph.w,
        h = graph.h,
        tile_fx = {},
        links = {},
        _start = self.start_pos,
        _end = self.end_pos,
        nodes = graph.nodes,
        views = self.views,
    }
    local TileEntity = entities.TileEntity
    local NodeGroup = map_containers.NodeGroup
    local nodes = map.nodes
    for i, node in ipairs(nodes) do
        local new_node = NodeGroup{
            tile = TileEntity({
                name = node.template,
                color = node.color,
                meta = node.meta,
            })
        }
        new_node.neighbors = node.neighbors
        nodes[i] = new_node
    end
    return map
end

creator.MapCreator = MapCreator
-- ##########

local function calculate_tiling(map, tile, i, fn)
    --[[Calculate the tile index of a node based on its neighbors.]]--
    local s = 0
    local nodes = map.nodes
    local neighbors = nodes[i].neighbors[1]

    local north_index = neighbors.north
    local north_tile = north_index and nodes[north_index].tile
    if north_tile and tile.id ~= north_tile and fn(tile, north_tile) then
        s = s + 1
    end

    local west_index = neighbors.west
    local west_tile = west_index and nodes[west_index].tile
    if west_tile and tile.id ~= west_tile and fn(tile, west_tile) then
        s = s + 2
    end

    local east_index = neighbors.east
    local east_tile = east_index and nodes[east_index].tile
    if east_tile and tile.id ~= east_tile and fn(tile, east_tile) then
        s = s + 4
    end

    local south_index = neighbors.south
    local south_tile = south_index and nodes[south_index].tile
    if south_tile and tile.id ~= south_tile and fn(tile, south_tile) then
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


local function calculate_tiling_8bit(map, tile, i, same)
    --[[Calculate the tile index of a node based on its neighbors.

    Cardinal directions and diagonals are considered.]]--
    local nodes = map.nodes
    local neighbors = nodes[i].neighbors[1]

    local directions = {
        northwest = {v = 2^0, condition = {"north", "west"}}, --   1-
        north     = {v = 2^1},                                --   2
        northeast = {v = 2^2, condition = {"north", "east"}}, --   4-
        west      = {v = 2^3},                                --   8
        east      = {v = 2^4},                                --  16
        southwest = {v = 2^5, condition = {"south", "west"}}, --  32-
        south     = {v = 2^6},                                --  64
        southeast = {v = 2^7, condition = {"south", "east"}}, -- 128-
     }

    local function should_count(direction)
        local index = neighbors[direction]
        local neighbor_tile = index and nodes[index].tile
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
    return not neighbor.block_sight
end

local tiling_compare = {}

function tiling_compare.same_template(node, neighbor)
    return node.template == neighbor.template
end

function tiling_compare.same_id(node, neighbor)
    return node.id == neighbor.id
end

function tiling_compare.is_water(node, neighbor)
    return string.find(neighbor.template, "water") and true or false
end

local function apply_tiling(map)
    local tiling_compare = tiling_compare
    for i, node in ipairs(map.nodes) do
        local tile = node.tile
        if tile.receive_shadow then
            tile.tile_pos_shadow = calculate_tiling(
                map, tile, i, calculate_shadow)
        end
        if tile.tiling == "8bit" then
            tile.tile_pos = calculate_tiling_8bit(
                map, tile, i,
                assert(tiling_compare[tile.compare_function], string.format(
                    "invalid compare_function ('%s') on template '%s'", tile.compare_function, node.template)
                ))

        end
    end
    return map
end
creator.apply_tiling = apply_tiling

return creator
