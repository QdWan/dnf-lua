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
        TileEntity    = {},
        FeatureEntity = {},
    },
    constants = {
        TileEntity = {},
    },
}

templates.constants.groups = {}

local TileEntity_group = templates.enum.TileEntity
local tile_default = templates.data.TileEntity._default

local index = 0
for k, v in pairs(templates.data.FeatureEntity) do
    v._key = k
end

local index = 0
for k, v in pairs(templates.data.TileEntity) do
    local groups = templates.constants.groups
    index = index + 1
    cdef_t[#cdef_t + 1] = format(cdef_body, string.upper(k), index)
    if v == tile_default then
        TileEntity_group[index] = v
    else
        if v.group0 then
            local group_k = string.upper(v.group0)
            groups[group_k] = groups[group_k] or {}
            groups[group_k][index] = true
        end
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


local groups = templates.constants.groups
local enums = templates.constants.EnumTileEntity

groups.WATER_GROUP = {
    [enums.WATER] =                true,
    [enums.SHALLOW_WATER] =        true,
    [enums.DEEP_WATER] =           true,
    [enums.ARCTIC_SHALLOW_WATER] = true,
    [enums.ARCTIC_DEEP_WATER] =    true,
}

groups.FOREST_GROUP = {
    [enums.BOREAL_FOREST] =              true,
    [enums.WOODLAND] =                   true,
    [enums.TEMPERATE_DECIDUOUS_FOREST] = true,
    [enums.TEMPERATE_RAIN_FOREST] =      true,
    [enums.TROPICAL_RAIN_FOREST] =       true,
}

groups.HILL_MOUNTAIN_GROUP = {
    [enums.ARCTIC_HILL] =          true,
    [enums.ARCTIC_MOUNTAIN] =      true,
    [enums.TEMPERATE_HILL] =       true,
    [enums.TEMPERATE_MOUNTAIN] =   true,
    [enums.HILL] =                 true,
    [enums.MOUNTAIN] =             true,
    [enums.TROPICAL_HILL] =        true,
    [enums.TROPICAL_MOUNTAIN] =    true,
}

groups.MOUNTAIN_GROUP = {
    [enums.ARCTIC_MOUNTAIN] =      true,
    [enums.TEMPERATE_MOUNTAIN] =   true,
    [enums.MOUNTAIN] =             true,
    [enums.TROPICAL_MOUNTAIN] =    true,
}

return templates
