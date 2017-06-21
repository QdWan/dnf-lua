local is_array = require("util.is_array")

local function choice(t)
    if is_array(t) then
        return t[math.random(1, #t)]
    else
        local keys = {}
        for k, v in pairs(t) do
            keys[#keys + 1] = k
        end
        return choice(keys)
    end
end

return choice
