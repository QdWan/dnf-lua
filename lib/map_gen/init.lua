local map_gen = require("map_gen.base")
map_gen.creator = require("map_gen.creator")
map_gen.creator["MapDungeon01"] = require("map_gen.mapdungeon01")
map_gen.creator["MapSurface"] = require("map_gen.mapsurface")
map_gen.creator["MapSurface01"] = require("map_gen.mapsurface01")
map_gen.creator["MapSurface02"] = require("map_gen.mapsurface02")

return map_gen
