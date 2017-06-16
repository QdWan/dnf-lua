local time = require("time").time



local Odict = require("odict")

d = Odict()

local i = 0
for a = 65, 70 do
    a_char = string.char(a)
    d:insert(a_char, a_char)
    i = i + 1
end

local i = 0
local k, v
repeat
    i = i + 1
    k, v = d:next(k)
    print(k, v)
until i == 10
