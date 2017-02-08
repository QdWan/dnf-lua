local util = {}

local function deepcopy(orig)
    local orig_type = type(orig)
    local copy
    if orig_type == 'table' then
        copy = {}
        for orig_key, orig_value in next, orig, nil do
            copy[deepcopy(orig_key)] = deepcopy(orig_value)
        end
        setmetatable(copy, deepcopy(getmetatable(orig)))
    else -- number, string, boolean, etc
        copy = orig
    end
    return copy
end
util.deepcopy = deepcopy

local function copy_depth(orig, depth)
    local depth = depth or 0
    local copy = {}
    for k, v in pairs(orig) do
        if depth > 0 and type(v) == 'table' then
            copy[k] = copy_depth(v, depth - 1)
        else
            copy[k] = v
        end
    end
    return copy
end
util.copy_depth = copy_depth

local function shallowcopy(orig)
    local orig_type = type(orig)
    local copy
    if orig_type == 'table' then
        copy = {}
        for orig_key, orig_value in pairs(orig) do
            copy[orig_key] = orig_value
        end
    else -- number, string, boolean, etc
        copy = orig
    end
    return copy
end
util.shallowcopy = shallowcopy

local function merge_tables(t1, t2)
    local copy = {}
    for _, t in ipairs{t1, t2} do
        for k, v in pairs(t) do
            copy[k] = v
        end
    end
    return copy
end
util.merge_tables = merge_tables


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
util.list_unify = list_unify


local function list_insert_new(t, v)
    t[#t + 1] = v
    return list_unify(t)
end
util.list_insert_new = list_insert_new

return util
