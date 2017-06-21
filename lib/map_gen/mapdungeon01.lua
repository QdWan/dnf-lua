--[[Diamong-square algorithm-based map]]--


local __main__ = not ...
if __main__ then
    package.path = ";c:/luapower/?.lua;" .. package.path
    love = require("loveless")
    require("main")
end


local map_gen_base = require("map_gen.base")
local Graph = map_gen_base.Graph
local creator = require("map_gen.creator")
local map_dng = require("map_gen.mapdungeon")

local function create(header)
    local info = {rooms={}, sectors={}, halls={}}
    local w, h = map_dng.create_sectors(info.sectors)
    local graph = Graph(w, h)
    info.start_pos, info.end_pos = map_dng.create_rooms(graph, info.rooms, info.sectors)
    map_dng.create_halls(graph, info.rooms, info.halls)

    local map = creator.standard_map(graph, header, info)
    creator.apply_tiling(map)

    return map
end

if __main__ then
    create()
else
    return create
end
