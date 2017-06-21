local ffi = require("ffi")
local ffi_struct_keys = require("util.ffi_struct_keys")

local function ffi_struct(name, def, set_mt)
    if set_mt == nil then set_mt = true end
    ffi.cdef(def)
    local keys = ffi_struct_keys(def)
    local mt = {
        __tostring = function(self)
            local tostring = tostring

            local t = {}

            for i, v in ipairs(keys) do
                t[#t + 1] = v .. "=" .. tostring(self[v])
            end
            return name .. "(" .. table.concat(t, ", ") .. ")"
        end,
        __pairs = function(self)
            local i, n = 0, #keys
            return function()
                i = i + 1
                if i > n then
                    return nil
                else
                    local k = keys[i]
                    local v = self[k]
                    return k, v, i
                end

            end
        end,
    }

    local debug = (def .."\n" .. name .. "keys:{" .. table.concat(keys, ", ") .. "}")
    if log then
        log:info(debug)
    else
        print(debug)
    end

    if set_mt == true then
        ffi.metatype(name, mt)
    else
        return mt, keys
    end
end

return ffi_struct
