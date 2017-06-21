local function shuffle_range(a, b)
    --[[
    Example:
        local t = shuffle_range(1, 16641)
        print(table.concat(t, ", "))
        >> 13217, 11630, 9821, 12536, 1352, 11004, 5651, 12246, 7106, 9466...
    ]]--
    local random = math.random
    local n = b

    local t = {}
    for i = a, b do
       t[i] = i
    end

    for i = a, b do
       local j = random(i, n)
       t[i], t[j] = t[j], t[i]
    end
    return t
end

return shuffle_range
