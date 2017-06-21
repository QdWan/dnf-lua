local reduce = require("util.reduce")

local function table_max(t)
    require("util.deprecation")("math.max(unpack(t)>table_max(t)", 1)
    return reduce(t,
        function (a, b)
            return math.max(a, b)
        end
    )
end

return  table_max
