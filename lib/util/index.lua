local function index(t, v)
    for i = 1, #t do
        if t[i] == v then return i end
    end
end

return index
