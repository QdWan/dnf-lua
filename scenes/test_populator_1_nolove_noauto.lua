package.path = ";c:/luapower/?.lua;" .. package.path

love = require("loveless")

require("main")

local map_gen_base = require("map_gen.base")
local map_sfc = require("map_gen.mapsurface")
local populator = require("dnf.populator")
local map_containers = require("dnf.map_containers")
local map_gen_creator = require("map_gen.creator")


local surface_header = map_containers.MapHeader{
    global_pos = map_containers.Position(0, 0),
    depth = 0,
    branch = 0,
    cr = 1,
    creator = "mapsurface01"
}
local creator = map_gen_creator.get(surface_header)
local surface_map = creator(surface_header)
log.verbosity_level = 0
for i = 1, 3 do
    populator.populate_surface(surface_map, surface_header)
end
log.verbosity_level = 1
collectgarbage()
log:warn(collectgarbage('count') .. "kb")
