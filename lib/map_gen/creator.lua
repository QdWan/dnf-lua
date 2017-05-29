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
local Properties = require('lib.properties')
local inspect = require("lib.inspect")
local map_containers = require("dnf.map_containers")
local map_entities = require("lib.dnf.map_entities")

local map_gen_base = require("lib.map_gen.base")

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
local MapCreator = class("MapCreator"):include(Properties)

function MapCreator:getter_cols()
    self._cols = self._cols or self.map.w
    return self._cols
end

function MapCreator:getter_rows()
    self._rows = self._rows or self.map.h
    return self._rows
end

function MapCreator:create(cols, rows)
    self.map = Graph(cols, rows)
end

function MapCreator:standard_map(graph)
    local graph = graph or self.map
    local map = {
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
        get = graph.get,
        neighbors_4d = graph.neighbors_4d,
        neighbors_8d = graph.neighbors_8d,
        north = graph.north,
        east = graph.east,
        south = graph.south,
        west = graph.west,
        views = self.views,
    }
    local TileEntity = map_entities.TileEntity
    local NodeGroup = map_containers.NodeGroup
    local nodes = map.nodes
    for i, node in ipairs(nodes) do
        nodes[i] = NodeGroup{
            tile = TileEntity({
                name = node.template,
                color = node.color,
                meta = node.meta,
            })
        }
    end
    return map
end

creator.MapCreator = MapCreator
-- ##########

local function calculate_tiling(map, tile, i, fn)
    --[[Calculate the tile index of a node based on its neighbors.]]--
    local s = 0

    local north_index = map.north[i]
    local north_tile = map:get(north_index).tile
    if north_tile and tile.id ~= north_tile and fn(tile, north_tile) then
        s = s + 1
    end

    local west_index = map.west[i]
    local west_tile = map:get(west_index).tile
    if west_tile and tile.id ~= west_tile and fn(tile, west_tile) then
        s = s + 2
    end

    local east_index = map.east[i]
    local east_tile = map:get(east_index).tile
    if east_tile and tile.id ~= east_tile and fn(tile, east_tile) then
        s = s + 4
    end

    local south_index = map.south[i]
    local south_tile = map:get(south_index).tile
    if south_tile and tile.id ~= south_tile and fn(tile, south_tile) then
        s = s + 8
    end

    return s
end

local function calculate_shadow(node, neighbor)
    return not neighbor.block_sight
end

local function apply_tiling(map)
    local nodes = map.nodes
    for i = 1, #nodes do
        local node = nodes[i]
        local tile = node.tile
        if tile.receive_shadow then
            tile.tile_pos_shadow = calculate_tiling(
                map, tile, i, calculate_shadow)
        end
    end
    return map
end
creator.apply_tiling = apply_tiling

return creator
