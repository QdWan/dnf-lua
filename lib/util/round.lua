local function round(n, d)
    local n = (n * (10 ^ d)) + 0.5
    return math.floor(n) * (10 ^ -d)
end

--[[
3.1415926535898
assert(round(math.pi, 0) ==  3)
assert(round(math.pi, 1) ==  3.1)
assert(round(math.pi, 2) ==  3.14)
assert(round(math.pi, 3) ==  3.142)
assert(round(math.pi, 4) ==  3.1416)
assert(tostring(round(math.pi, 5)) ==  "3.14159")
assert(round(math.pi, 6) ==  3.141593)
assert(round(math.pi, 7) ==  3.1415927)
assert(round(math.pi, 8) ==  3.14159265)
]]--

return round
