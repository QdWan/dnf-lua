--[[
TEST
package.path = ";c:/luapower/?.lua;" .. package.path

love = require("loveless")

require("main")
]]--
--[[
TEST
]]--
local map_gen_base = require("map_gen.base")
local Graph = map_gen_base.Graph
local map_sfc = require("map_gen.mapsurface")
local creator = require("map_gen.creator")

local function create(header)
    local graph = Graph(129, 129)
    map_sfc.init_grid(graph, {v=0.09})
    map_sfc.deposition(graph)
    map_sfc.apply_on_graph(graph, map_sfc.erupt, {k=0.2, name="erupt"})
    map_sfc.smoothe(graph, {k=0.60})
    map_sfc.set_base_feature(graph)
    map_sfc.compose_biomes(graph)

    local map = map_sfc.standard_map(graph, header)
    creator.apply_tiling(map)

    return map
end

--create()
return create
