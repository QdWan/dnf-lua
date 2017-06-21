local function extend_array(table1, table2)
    --[[Extend table1 with table2, in place
    ]]--
    for _, v in ipairs(table2) do
        table1[#table1 + 1] = v
    end
end

return extend_array
