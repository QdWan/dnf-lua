local utf8 = require("utf8")

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

local function extend_array(table1, table2)
    --[[Extend table1 with table2, in place
    ]]--
    for _, v in ipairs(table2) do
        table1[#table1 + 1] = v
    end
end
util.extend_array = extend_array

local function filter_array(table, fn, ip)
    --[[Return a new table as result of a funcion on each value of the table.
    ]]--
    ip = ip or false
    local res = ip and table or {}
    for i, v in ipairs(table) do
        res[i] = fn(v, i)
    end
    return res
end
util.filter_array = filter_array

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
util.is_array = is_array

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
util.choice = choice

local function index(t, v)
    for i = 1, #t do
        if t[i] == v then return i end
    end
end
util.index = index

local function next(array, v)
    local index = type(v) == "number" and v or index(array, v)
    return (index % #array) + 1
end
util.next = next

local function previous(array, v)
    local index = type(v) == "number" and v or index(array, v)
    return ((index - 1) % #array) + 1
end
util.previous = previous

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
    return is_array(t) and array_has_key(t, key) or hashtable_has_key(t, key)
end
util.has_key = has_key

local function reduce(array, fn)
    local acc
    for k, v in ipairs(array) do
        if 1 == k then
            acc = v
        else
            acc = fn(acc, v)
        end
    end
    return acc
end
util.reduce = reduce

local function table_sum(t)
    return reduce(t,
        function (a, b)
            return a + b
        end
    )
end
util.table_sum = table_sum

local function table_max(t)
    return reduce(t,
        function (a, b)
            return math.max(a, b)
        end
    )
end
util.table_max = table_max

local function table_min(t)
    return reduce(t,
        function (a, b)
            return math.min(a, b)
        end
    )
end
util.table_min = table_min

local function gsplit(s, sep)
    local start = 1
    local done = false
    local function pass(i, j, ...)
        if i then
            local seg = s:sub(start, i - 1)
            start = j + 1
            return seg, ...
        else
            done = true
            return s:sub(start)
        end
    end
    return function()
        if done then return end
        local sep = sep or " "
        return pass(s:find(sep, start))
    end
end

local function split(str, sep, ignore)
    local ignored
    if not ignore then
        ignored = function(c) return false end
    else
        --  type(ignore) == "table"
        ignored = function(c)
            for i = 1, #ignore do
                if c == ignore[i] then
                    return true
                end
            end
        return false
        end
    end

    if str == "" or sep == "" then
        return {str}
    end
    local t={}
    for c in gsplit(str, sep) do
        local skip = false
        if not ignored(c) then
            t[#t + 1] = c
        end
    end
    return t
end
util.split = split

local function trim_last(str)
    local byteoffset = utf8.offset(str, -1)

    -- remove the last UTF-8 character.
    -- string.sub operates on bytes rather than UTF-8 characters, so we couldn't do string.sub(text, 1, -2).
    return byteoffset and str:sub(1, byteoffset - 1) or str
end
util.trim_last = trim_last


--[[
3.1415926535898
assert(round(math.pi, 0) ==  3)
assert(round(math.pi, 1) ==  3.1)
assert(round(math.pi, 2) ==  3.14)
assert(round(math.pi, 3) ==  3.142)
assert(round(math.pi, 4) ==  3.1416)
assert(tostring(round(math.pi, 5)) ==  "3.14159")
assert(round(math.pi, 6) ==  3.141593)
assert(round(math.pi, 7) ==  3.1415927)
assert(round(math.pi, 8) ==  3.14159265)
]]--
local function round(n, d)
    local n = (n * (10 ^ d)) + 0.5
    return math.floor(n) * (10 ^ -d)
end
util.round = round


local function xpcall_args(fn, err, ...)
    local args = {...}
    local function f()
        return fn(unpack(args))
    end
    local status, err, ret = xpcall(f, err)
    return status, err, ret
end

local function cantor(x, y, z)
    --[[Get a unique index for a 2d or 3d coordinate using Cantor pairing.

    Args:
        x (number): first coordinate, X axis
        y (number): second coordinate, Y axis
        z (number): second coordinate, Z axis (optional)
    ]]--
    return z and cantor(cantor(x, y), z) or 0.5 * (x + y) * ((x + y) + 1) + y
end
util.cantor = cantor

return util


