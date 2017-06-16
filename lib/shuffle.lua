local inspect = require("inspect")

local function shuffle(source, copy)
    local dest

    if copy == true then
        dest = {}
        for i = 1, #source do
            dest[i] = source[i]
        end
    else
        dest = source
    end

    local size = #dest
    local random = math.random

    for i = 1, size do
        local r = random(size)
        dest[i], dest[r] = dest[r], dest[i]
    end

    return dest
end

--[[
--Example:
math.randomseed(os.time() * 1000)
local shuffle = shuffle or require("shuffle")

local t1 = {1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18 }
local t2 = shuffle(t1, true)
local t2 = shuffle(t1, true)
local t2 = shuffle(t1, true)

for i = 1, #t1 do
    print(t1[i], "<-->", t2[i], "var:", math.abs(t1[i] - t2[i]))
end
]]--

return shuffle
