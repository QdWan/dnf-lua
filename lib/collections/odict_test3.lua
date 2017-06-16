local time = require("time").time



local Odict = require("odict")

d = Odict()

local i = 0
for a = 65, 122 do
    a_char = string.char(a)
    d:insert(a_char, a_char)
    i = i + 1
end

for a = 65, 122 do
    a_char = string.char(a)
    d:remove(a_char)
end

for k, v, i in d:sorted() do
    print(k, v, i)
end


local a = function() end
local b = function() end
local c = function() end

d:insert(a)
d:insert(b)
d:insert(c)

print("count:", d.count)
d:remove(a)
d:remove(b)
d:remove(c)

for k, v, i in d:sorted() do
    print(k, v, i)
end
