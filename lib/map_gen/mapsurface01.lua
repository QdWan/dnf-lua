local map_gen_surface = require("map_gen.mapsurface")
local HeightmapBase = map_gen_surface.HeightmapBase
local creator = require("map_gen.creator")
local apply_tiling = creator.apply_tiling


local MapSurface01 = class("MapSurface01", HeightmapBase)

function MapSurface01:adjust_size(_w, _h)
    --[[Diamong-square algorithm requires a square grid of 2^n + 1 size.
    ]]--
    local max = -math.huge
    local function log_base(v, b)
        return math.log(v) / math.log(b)
    end

    local function pow2plus1(...)
        local old  = {...}
        local new = {}
        for i, v in ipairs(old) do
            local exp = log_base((v - 1), 2)
            local next_exp = math.ceil(exp)
            print("exp", v, exp, next_exp)
            local next_v = math.pow(2, next_exp) + 1
            new[#new + 1] = next_v
        end
        return unpack(new)
    end
    local w, h = pow2plus1(_w, _h)
    local new_v = math.max(-math.huge, w, h)
    self.k = log_base(new_v, 2) - 4
    log:warn("map size", new_v, new_v)
    return new_v, new_v
end

function MapSurface01:create(header)
    HeightmapBase.create(self, header)  -- super
    self:diamond_square()
    self:scale(2)
    self:set_base_feature()

    local map = self:standard_map()

    apply_tiling(map)

    return map
end

return MapSurface01
