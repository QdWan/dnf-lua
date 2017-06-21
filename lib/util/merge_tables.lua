local function merge_tables(t1, t2)
    local copy = {}
    for _, t in ipairs{t1, t2} do
        for k, v in pairs(t) do
            copy[k] = v
        end
    end
    return copy
end

return merge_tables
