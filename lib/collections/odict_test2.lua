local time = require("time").time



local function cantor(x, y, z)
    return z and cantor(cantor(x, y), z) or 0.5 * (x + y) * ((x + y) + 1) + y
end



local Odict = require("odict")



local tt0 = time()
local i, r, a, sum_i, sum_a = 0, 0, 0, 0, 0
d = Odict()

local t0 = time()
for a = 65, 122 do
    a_char = string.char(a)
    for b = 65, 122 do
        b_char = string.char(b)
        for c = 65, 122 do
            c_char = string.char(c)
            local v = cantor(a, b, c)
            d:insert(a_char .. b_char .. c_char, v)
            i = i + 1
            sum_i = sum_i + v
        end
    end
end
local t1 = time()
print(string.format("total time: %.12fs (insertions: %d)", t1 - t0, i))

local t0 = time()
for k, v in d:sorted() do
    assert(k and v)
    a = a  + 1
    sum_a = sum_a + v
end
local t1 = time()
print(string.format("total time: %.12fs (assertions: %d)", t1 - t0, a))

local tt1 = time()
print(string.format("total time (step 1): %.12fs", tt1 - tt0))
print(string.format(
    "validation: sum_i(%d) == sum_a(%d): %s",
    sum_i, sum_a, sum_i == sum_a))



local tt0 = time()
local i, r, a, sum_i, sum_a = 0, 0, 0, 0, 0
d = Odict()

local t0 = time()
for a = 65, 122 do
    a_char = string.char(a)
    for b = 65, 122 do
        b_char = string.char(b)
        for c = 65, 122 do
            c_char = string.char(c)
            local k = a_char .. b_char .. c_char
            local v = cantor(a, b, c)
            d:insert(k, v)
            i = i + 1
            sum_i = sum_i + v
        end
    end
end
local t1 = time()
print(string.format("total time: %.12fs (insertions: %d)", t1 - t0, i))

local t0 = time()
for a = 65, 122 do
    a_char = string.char(a)
    for b = 65, 122 do
        b_char = string.char(b)
        for c = 65, 122 do
            c_char = string.char(c)
            local k = a_char .. b_char .. c_char
            if (a + b + c) % 16 == 0 then
                local v = d:remove(k)
                r = r + 1
                sum_i = sum_i - v
            end
        end
    end
end
local t1 = time()
print(string.format("total time: %.12fs (removals: %d)", t1 - t0, r))

local a = 0
local t0 = time()
for k, v in d:sorted() do
    assert(k and v)
    a = a  + 1
    sum_a = sum_a + v
end
local t1 = time()
print(string.format("total time: %.12fs (assertions: %d)", t1 - t0, a))

local tt1 = time()
print(string.format("total time (step 2): %.12fs", tt1 - tt0))
print(string.format(
    "validation: sum_i(%d) == sum_a(%d): %s",
    sum_i, sum_a, sum_i == sum_a))

--[[
total time: 0.603034734726s (insertions: 195112)
total time: 0.051002979279s (assertions: 195112)
total time (step 1): 0.654037714005s
validation: sum_i(33712421091029) == sum_a(33712421091029): true
total time: 0.397022485733s (insertions: 195112)
total time: 0.082004785538s (removals: 12207)
total time: 0.057003259659s (assertions: 182905)
total time (step 2): 0.536030530930s
validation: sum_i(31603329537049) == sum_a(31603329537049): true
]]--
