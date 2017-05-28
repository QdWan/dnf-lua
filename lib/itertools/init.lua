local itertools = {}


local index = function(t, v)
    for i = 1, #t do
        if t[i] == v then
            return i
        end
    end
end

itertools.index = index


local split_around = function(t, v)
    local _index = index(t, v)
    local size = #t
    local l_size = math.floor(size / 2)
    local r_size = size - l_size - 1
    local left = {}
    local right = {}
    -- left
    for i = l_size, 1, -1 do
        local wrap_i = ((_index - i - 1) % size) + 1
        left[#left + 1] = t[wrap_i]
    end
    -- right
    for i = 1, r_size do
        local wrap_i = ((_index + i - 1) % size) + 1
        right[#right + 1] = t[wrap_i]
    end
    return left, right
end

itertools.split_around = split_around


local reversed = function(t)
    local res = {}
    for i = #t, 1, -1 do
        res[#res + 1] = t[i]
    end
    return res
end

itertools.reversed = reversed


local ichain = function(...)
    local arrays = {...}
    local res = {}
    local max
    for i = 1, #arrays do
        local t = arrays[i]
        max = math.max(max or #t, #t)
    end
    for j = 1, max do
        for i = 1, #arrays do
            local t = arrays[i]
            local v = t[j]
            if v ~= nil then
                res[#res + 1] = t[j]
            end
        end
    end
    local i = 0
    local n = #res
    return function ()
        i = i + 1
        if i <= n then
            return i, res[i]
        end
    end
end

itertools.ichain = ichain


return itertools
