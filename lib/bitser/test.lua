local bitser = require("bitser")
local class = require('middleclass') or require('minclass')
local time = require("time").time

local Thingy = class("Thingy")

function Thingy:init(a, b, c)
    self.a = a
    self.b = b
    self.c = c
end

function Thingy:__tostring()
    return string.format(
        "%s(a=%s, b=%s, c=%s)",
        self.class, tostring(self.a),tostring(self.b), tostring(self.c))
end

local thingy = Thingy(1, "a", "z")
print(thingy)
bitser.registerClass(Thingy)
local data = bitser.dumps(thingy)
local instance = bitser.loads(data)
print(instance)
