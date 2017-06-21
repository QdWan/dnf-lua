local function list_unify(t)
    local set = {}
    for i = 1, #t do
        set[t[i]] = true
    end
    local list = {}
    for k, _ in pairs(set) do
        list[#list + 1] = k
    end
    return list
end

return list_unify
