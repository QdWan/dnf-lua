local function key_decat(str)
   local sep, fields = "%z", {}
   local pattern = string.format("([^%s]+)", sep)
   str:gsub(pattern, function(c) fields[#fields+1] = c end)
   return fields
end

return key_decat
