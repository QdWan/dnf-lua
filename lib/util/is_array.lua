--[[
from lua-cjson (Mark Pulford)
Determine whether a table can be treated as an array.
Explicitly returns "not an array" for very sparse arrays.
Returns:
-1   Not an array
0    Empty table
>0   Highest index in the array
]]--
local function is_array(t)
    local max = 0
    local count = 0
    for k, v in pairs(t) do
        if type(k) == "number" then
            if k > max then max = k end
            count = count + 1
        else
            return false
        end
    end
    if max > count * 2 then
        return false
    end

    return max
end

return is_array
