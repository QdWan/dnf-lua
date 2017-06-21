local function gsplit(s, sep)
    local start = 1
    local done = false
    local function pass(i, j, ...)
        if i then
            local seg = s:sub(start, i - 1)
            start = j + 1
            return seg, ...
        else
            done = true
            return s:sub(start)
        end
    end
    return function()
        if done then return end
        local sep = sep or " "
        return pass(s:find(sep, start))
    end
end

local function split(str, sep, ignore)
    require("util.deprecation")("split", 1)
    local ignored
    if not ignore then
        ignored = function(c) return false end
    else
        --  type(ignore) == "table"
        ignored = function(c)
            for i = 1, #ignore do
                if c == ignore[i] then
                    return true
                end
            end
        return false
        end
    end

    if str == "" or sep == "" then
        return {str}
    end
    local t={}
    for c in gsplit(str, sep) do
        local skip = false
        if not ignored(c) then
            t[#t + 1] = c
        end
    end
    return t
end

return split
