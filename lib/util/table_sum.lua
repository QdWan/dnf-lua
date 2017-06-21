local reduce = require("util.reduce")

local function table_sum(t)

    return reduce(t,
        function (a, b)
            return a + b
        end
    )
end
return  table_sum
