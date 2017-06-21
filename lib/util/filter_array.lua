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

return filter_array
