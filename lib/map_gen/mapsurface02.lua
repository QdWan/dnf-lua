local map_gen_surface = require("map_gen.mapsurface")
local HeightmapBase = map_gen_surface.HeightmapBase


local MapSurface02 = class("MapSurface02", HeightmapBase)

function MapSurface02:create(header)
    HeightmapBase.create(self, header)  -- super
    self:init_grid{v=0.09}
    self:deposition()

    self:erupt_grid{k=0.2}

    self:smoothe{times=1, k=0.60, mode=0}
    self:set_base_feature()

    return self:standard_map()
end

return MapSurface02
