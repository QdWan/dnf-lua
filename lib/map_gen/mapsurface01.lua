--[[Diamong-square algorithm-based map]]--

local map_gen_base = require("map_gen.base")
local Graph = map_gen_base.Graph
local map_sfc = require("map_gen.mapsurface")
local creator = require("map_gen.creator")

local function create(header)
    local w, h = map_sfc.diamond_square_adjust_size(120)
    local g1 = Graph(w, h)
    map_sfc.diamond_square(g1)
    map_sfc.set_base_feature(g1)
    map_sfc.compose_biomes(g1)

    local map = map_sfc.standard_map(g1, header)
    creator.apply_tiling(map)

    return map
end

return create
