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

return copy_depth
