local function next(array, v)
    local index = type(v) == "number" and v or index(array, v)
    return (index % #array) + 1
end

local function previous(array, v)
    local index = type(v) == "number" and v or index(array, v)
    return ((index - 1) % #array) + 1
end

local function xpcall_args(fn, err, ...)
    local args = {...}
    local function f()
        return fn(unpack(args))
    end
    local status, err, ret = xpcall(f, err)
    return status, err, ret
end
