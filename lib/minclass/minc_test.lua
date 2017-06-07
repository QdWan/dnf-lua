local class = require("minclass")


local Father = class("Father")

function Father:init(param)
    self.v = param and param.v or self.v
end


local Son = class("Son", Father):set_class_defaults({
    v = 2
})

function Son:init(param)
    self.class.super.init(self, param)
end

local function all(...)
    local param = {...}
    for _, eval in ipairs(param) do
        if not eval then return false end
    end
    return true
end

local time = require("time").time
local t0 = time()
for i = 1, 500000 do
    local a = Father({v = 1})
    local b = Son()
    local c = Father({v = 3})
    local d = Son({v = 4})
    assert(a.v == 1)  -- param value
    assert(b.v == 2)  -- param value
    assert(c.v == 3)  -- default value
    assert(d.v == 4)  -- default value
    --[[
    assert(all(
        a ~= b, a ~= c, a ~= d,
        b ~= c, c ~= d,
        c ~= d
        ))
    ]]--

    a.v = 5
    b.v = 6
    c.v = 7
    d.v = 8
    assert(a.v == 5)  -- param value
    assert(b.v == 6)  -- param value
    assert(c.v == 7)  -- default value
    assert(d.v == 8)  -- default value
end
print("done", time() - t0)  -- done    0.0010001659393311
