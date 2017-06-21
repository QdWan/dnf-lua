local is_array = require("util.is_array")

local function array_has_key(t, key)
    for i = 1, #t do
        if t[i] == key then
            return true
        end
    end
    return false
end

local function hashtable_has_key(t, key)
    for k, _ in pairs(t) do
        if k == key then
            return true
        end
    end
    return false
end

local function has_key(t, key)
    require("util.deprecation")("has_key", 1)
    return is_array(t) and array_has_key(t, key) or hashtable_has_key(t, key)
end

return has_key
