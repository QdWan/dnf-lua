package.path = ";c:/luapower/?.lua;" .. package.path

love = require("loveless")

require("main")

local map_gen_base = require("map_gen.base")
local Graph = map_gen_base.Graph
local map_sfc = require("map_gen.mapsurface")


for i = 1, 1 do
    local w, h = map_sfc.diamond_square_adjust_size(64)
    local g1 = Graph(w, h)
    map_sfc.diamond_square(g1)
    map_sfc.set_base_feature(g1)
    local g2 = map_sfc.scale(g1, 4)
    map_sfc.compose_biomes(g2)
    local map1 = map_sfc.standard_map(g2)
end

os.exit()
