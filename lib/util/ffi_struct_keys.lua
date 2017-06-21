local function ffi_struct_keys(str)
    local t = {}
    for v in str:gmatch("[^\n]+") do
        local key = v:match(" +%S+ +(%S+);")
        if key then t[#t + 1] = key end
    end
    return t
end

return ffi_struct_keys
