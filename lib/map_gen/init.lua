local map_gen = require("lib.map_gen.base")
map_gen.creator = require("lib.map_gen.creator")
map_gen.creator["MapDungeon02"] = require("lib.map_gen.mapdungeon02")
map_gen.creator["MapSurface02"] = require("lib.map_gen.mapsurface02")

return map_gen
