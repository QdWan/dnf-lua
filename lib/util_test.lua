local util = require("util")
local res = {}

for i = 1, math.huge, 3 do
    local v = util.cantor_t(i, i + 1, i + 2)
    local repeated =  res[v]
    print(repeated, v)
    res[v] = true
    if repeated then
        error("repeated", i, i + 1, i + 2, v)
    end
end

