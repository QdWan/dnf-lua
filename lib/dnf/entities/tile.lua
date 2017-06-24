local ffi_struct = require("util.ffi_struct")

-- ##########
-- NodeNeighbors struct
local _NodeNeighbors = [[typedef struct {
    uint16_t  north;
    uint16_t  east;
    uint16_t  south;
    uint16_t  west;
    uint16_t  northeast;
    uint16_t  southeast;
    uint16_t  southwest;
    uint16_t  northwest;
} NodeNeighbors;]]
ffi_struct("NodeNeighbors", _NodeNeighbors)
-- end of NodeNeighbors struct
-- ##########


-- ##########
-- RGBColor struct
local _RGBColor = [[typedef struct {
    uint8_t   r;
    uint8_t   g;
    uint8_t   b;
} RGBColor;]]
ffi_struct("RGBColor", _RGBColor)
-- end of RGBColor struct
-- ##########


-- ##########
-- TileEntityMeta struct
local _TileEntityMeta = [[typedef struct {
    RGBColor heat_color;
    uint8_t heat_template;
    double heat_value;

    RGBColor height_color;
    uint8_t height_template;
    double height_value;

    RGBColor rainfall_color;
    uint8_t rainfall_template;
    double rainfall_value;

    double noise_value;
    double water_ratio_r1;
    double water_ratio_r2;
    double water_ratio_r4;
    double forest_ratio_r4;
} TileEntityMeta;]]
ffi_struct("TileEntityMeta", _TileEntityMeta)
-- end of TileEntityMeta struct
-- ##########


-- ##########
-- NodeCorner struct
local _NodeCorner = [[typedef struct {
    uint8_t   pos;
    uint8_t   var;
} NodeCorner;]]
ffi_struct("NodeCorner", _NodeCorner)
-- end of NodeCorner struct
-- ##########

-- ##########
-- TileEntity struct
local _TileEntity = [[typedef struct {
    uint16_t  x;
    uint16_t  y;
    uint16_t  cost;
    bool  block;
    bool  explored;
    double value;
    uint8_t template;
    uint8_t tile_pos;
    uint8_t tile_pos_shadow;
    uint8_t tile_var;
    NodeNeighbors neighbors;
    TileEntityMeta meta;
    NodeCorner c0;  // topleft
    NodeCorner c1;  // topright
    NodeCorner c2;  // bottomleft
    NodeCorner c3;  // bottomright
} TileEntity;]]
local TileEntity_mt, TileEntity_keys = ffi_struct(
    "TileEntity", _TileEntity, false)
TileEntity_mt.__index = {}
local TileEntity_functions = TileEntity_mt.__index
function TileEntity_functions.set_template(self, template)
    self.template = template
    self.cost = COST[template]
end
ffi.metatype("TileEntity", TileEntity_mt)
local TileEntity = ffi.typeof('TileEntity')
-- end of TileEntity struct
-- ##########

return TileEntity
