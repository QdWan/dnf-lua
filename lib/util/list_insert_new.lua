local list_unify = require("list_unify")

local function list_insert_new(t, v)
    t[#t + 1] = v
    return list_unify(t)
end

return list_insert_new
