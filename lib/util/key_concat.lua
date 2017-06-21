local function key_concat(...)
    local args = {...}
    args = type(args[1]) == "table" and args[1] or args
    return table.concat(args, "\0")  -- "\0"
end
return key_concat
