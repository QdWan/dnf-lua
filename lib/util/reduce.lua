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

return reduce
