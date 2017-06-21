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

local ffi = require("ffi")
local NodeNeighbors = ffi.typeof("NodeNeighbors")
local t = NodeNeighbors()
print(t)
