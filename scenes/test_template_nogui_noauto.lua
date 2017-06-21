local templates = require("data.templates")
local k = -math.huge

local index = {}
local TILE_TEMPLATE_NAMES = templates.constants.TILE_TEMPLATE_NAMES
log:warn(TILE_TEMPLATE_NAMES.hill)

local i = 0
for tile_k, tile_v in pairs(templates["TileEntity"]) do
    log:warn(tile_k, #tile_k, tile_v.id, tile_v._index, i + 1)
    k = math.max(k, #tile_k)
    i = i + 1
    assert(not index[tile_v._index])
    assert(TILE_TEMPLATE_NAMES[tile_k] == tile_v._index)
    assert(not string.find(tile_k, "%s"), tile_k)
    index[tile_v._index] = true
end
log:warn("maximum template name length", k, i)

ffi.cdef[[
typedef struct {
    uint8_t   r;
    uint8_t   g;
    uint8_t   b;
} rgb_color;
]]

local Rgb_color = ffi.typeof('rgb_color')

local rgb = Rgb_color(1, 2, 3)
print(rgb.r, rgb.g, rgb.b)
love.graphics.setColor(rgb.r, rgb.g, rgb.b)
return love.event.quit
