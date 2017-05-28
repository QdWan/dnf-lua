local function f(t)
    return t * t * t * (t * (6 * t - 15) + 10)
end

local function l(t, a, b)
    return a + t * (b - a)
end

local function g(h, x, y, z)
    local h, u, v, r = h % 16
    if h < 8 then u = x else u = y end
    if h < 4 then v = y elseif h == (12 or 14) then v = x else v = z end
    if h % 2 == 0 then r = u else r = -u end
    if h % 4 == 0 then r = r + v else r = r - v end
    return r
end

local m = math.modf
local function noise(o, x, y, z)
    y, z = y or 1 / 3, z or 2 / 3
    local f, l, g, m = f, l, g, m
    local X, x = m(x % 256)
    local Y, y = m(y % 256)
    local Z, z = m(z % 256)
    local u, v, w = f(x), f(y), f(z)
    local A = o[X] + Y
    local AA = o[A] + Z
    local AB = o[A + 1] + Z
    local B = o[X + 1] + Y
    local BA = o[B] + Z
    local BB = o[B + 1] + Z
    return l(
        w, l(v, l(u, g(o[AA], x, y, z),
                  g(o[BA], x - 1, y, z)),
             l(u, g(o[AB], x, y - 1, z),
               g(o[BB], x - 1, y - 1, z))),
        l(v, l(u, g(o[AA + 1], x, y, z - 1),
               g(o[BA + 1], x - 1, y, z - 1)),
          l(u, g(o[AB + 1], x, y - 1, z - 1),
            g(o[BB + 1], x - 1, y - 1, z - 1))))
end

local m = {
    __index = function(t, i)
        return type(i) == "number" and t[i % 256] or noise
    end}

return function(s)
    local o = {}
    local rand = math.random
    local _ = s and math.randomseed(tonumber(s) or os.time())
    for n = 0, 255 do
        local t = rand(0, 255)
        while o[t] do
            t = rand(0, 255)
        end
        o[t] = n
    end
    return setmetatable(o, m)
end
