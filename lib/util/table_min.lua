local reduce = require("util.reduce")

local function table_min(t)
    require("util.deprecation")("math.min(unpack(t)>table_min(t)", 1)
    return reduce(t,
        function (a, b)
            return math.min(a, b)
        end
    )
end

return table_min
