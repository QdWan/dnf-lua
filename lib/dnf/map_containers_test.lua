local ffi = require("ffi")

ffi.cdef[[
typedef struct {
    uint8_t   x;
    uint8_t   y;
    char  name[1];
    char  surname[1];
} position;
]]
local pos = ffi.metatype("position", {
    __tostring = function(self)
        return "position(x=" .. self.x .. ", y=" .. self.y .. ")"
    end
})

collectgarbage()
print(collectgarbage('count'))
print(ffi.new('position', 15, 32, "bobby", "bob"))
collectgarbage()
print(collectgarbage('count'))
