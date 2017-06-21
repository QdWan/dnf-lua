local templates_data = require("data.templates_data")

local format = string.format
local upper = string.upper

local cdef_t = {}
local cdef_head = "typedef struct {\n"  -- CDEF
local cdef_body = "    static const uint8_t %s = %d;"  -- CDEF
local cdef_tail = "\n  } EnumTileEntity;"

local templates = {
    data = templates_data,
    enum = {
        TileEntity = {},
    },
    constants = {
        TileEntity = {},
    },
}

local TileEntity_group = templates.enum.TileEntity
local tile_default = templates.data.TileEntity._default

for k, v in pairs(templates.data.TileEntity) do
    cdef_t[#cdef_t + 1] = format(cdef_body, k, v._index)
    local index = v._index
    assert(not TileEntity_group[index])
    if v == tile_default then
        TileEntity_group[index] = v
    else
        local defaulted = setmetatable(v, {__index = tile_default})
        assert(defaulted.image,
               "assertion failed",
               1,
               function()
                    local str = inspect(v)
                    log:warn(str)
                    return ""
               end)
        TileEntity_group[index] = defaulted
    end
    v._key = k
end
local cdef_str = cdef_head .. table.concat(cdef_t, "\n") .. cdef_tail
ffi.cdef(cdef_str)
templates.constants.EnumTileEntity = ffi.new("EnumTileEntity")
log:info(cdef_str)

templates.constants.groups = {}

local groups = templates.constants.groups
local enums = templates.constants.EnumTileEntity

groups.WATER_GROUP = {
    [enums.water] =                true,
    [enums.shallow_water] =        true,
    [enums.deep_water] =           true,
    [enums.arctic_shallow_water] = true,
    [enums.arctic_deep_water] =    true,
}

groups.FOREST_GROUP = {
    [enums.boreal_forest] =              true,
    [enums.woodland] =                   true,
    [enums.temperate_deciduous_forest] = true,
    [enums.temperate_rain_forest] =      true,
    [enums.tropical_rain_forest] =       true,
}

groups.HILL_MOUNTAIN_GROUP = {
    [enums.hill] =                 true,
    [enums.mountain] =             true,
    [enums.arctic_hill] =          true,
    [enums.arctic_mountain] =      true,
}

groups.MOUNTAIN_GROUP = {
    [enums.mountain] =             true,
    [enums.arctic_mountain] =      true,
}

return templates
