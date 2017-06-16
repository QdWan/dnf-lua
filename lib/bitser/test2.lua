local paths = "?.lua;?/init.lua;../?.lua;../?/init.lua;../?/?.lua;"
package.path = paths .. package.path
require("rs_strict")
local ffi = require("ffi")
local util = require("util")
local key_concat = util.key_concat
local key_decat = util.key_decat

local floor = math.floor
local pairs = pairs
local type = type

local M = {
    buf_pos = 0,
    buf_size = -1,
    buf = nil,
    writable_buf = nil,
    writable_buf_size = nil,
}

function M.Buffer_makeBuffer(size)
    local M = M
    if M.writable_buf then
        M.buf = M.writable_buf
        M.buf_size = M.writable_buf_size
        M.writable_buf = nil
        M.writable_buf_size = nil
    end
    M.buf_pos = 0
    M.Buffer_prereserve(size)
end

function M.Buffer_prereserve(min_size)
    local M = M
    if M.buf_size < min_size then
        M.buf_size = min_size
        M.buf = ffi.new("uint8_t[?]", M.buf_size)
    end
end

function M.Buffer_reserve(additional_size)
    local M = M
    local ffi_new = ffi.new
    local ffi_copy = ffi.copy
    while M.buf_pos + additional_size > M.buf_size do
        M.buf_size = M.buf_size * 2
        local oldbuf = M.buf
        M.buf = ffi_new("uint8_t[?]", M.buf_size)
        ffi_copy(M.buf, oldbuf, M.buf_pos)
    end
end

function M.Buffer_write_byte(x)
    local M = M
    M.Buffer_reserve(1)
    M.buf[M.buf_pos] = x
    M.buf_pos = M.buf_pos + 1
end

function M.Buffer_write_data(ct, len, ...)
    local M = M
    M.Buffer_reserve(len)
    ffi.copy(M.buf + M.buf_pos, ffi.new(ct, ...), len)
    M.buf_pos = M.buf_pos + len
end

M["number"] = function(value, _)
    local M = M
    if floor(value) == value and value >= -2147483648 and value <= 2147483647 then
        if value >= -27 and value <= 100 then
            --small int
            M.Buffer_write_byte(value + 27)
        elseif value >= -32768 and value <= 32767 then
            --short int
            M.Buffer_write_byte(250)
            M.Buffer_write_data("int16_t[1]", 2, value)
        else
            --long int
            M.Buffer_write_byte(245)
            M.Buffer_write_data("int32_t[1]", 4, value)
        end
    else
        --double
        M.Buffer_write_byte(246)
        M.Buffer_write_data("double[1]", 8, value)
    end
end

M["string"] = function(value, _)
    local M = M
    if #value < 32 then
        --short string
        M.Buffer_write_byte(192 + #value)
    else
        --long string
        M.Buffer_write_byte(244)
        M.number(#value)
    end
    M.Buffer_reserve(#value)
    ffi.copy(M.buf + M.buf_pos, value, #value)
    M.buf_pos = M.buf_pos + #value
end

M["nil"] = function(_, _)
    M.Buffer_write_byte(247)
end

M["boolean"] = function(value, _)
    M.Buffer_write_byte(value and 249 or 248)
end

M["table"] = function(value, seen)
    local M = M
    local serialize_value = M.serialize_value

    M.Buffer_write_byte(240)
    local len = #value
    M.number(len, seen)
    for i = 1, len do
        serialize_value(value[i], seen)
    end
    local klen = 0
    for k in pairs(value) do
        if (type(k) ~= 'number' or floor(k) ~= k or k > len or k < 1) then
            klen = klen + 1
        end
    end
    M.number(klen, seen)
    for k, v in pairs(value) do
        if (type(k) ~= 'number' or floor(k) ~= k or k > len or k < 1) then
            serialize_value(k, seen)
            serialize_value(v, seen)
        end
    end
end

function M.dumps(value)
    local M = M
    M.Buffer_makeBuffer(4096)
    local seen = {len = 0}
    M.serialize_value(value, seen)
    return ffi.string(M.buf, M.buf_pos)
end

function M.serialize_value(value, seen)
    local M = M
    if seen[value] then
        local ref = seen[value]
        if ref < 64 then
            --small reference
            M.Buffer_write_byte(128 + ref)
        else
            --long reference
            M.Buffer_write_byte(243)
            M.number(ref, seen)
        end
        return
    end
    local t = type(value)
    if t ~= 'number' and t ~= 'boolean' and t ~= 'nil' then
        seen[value] = seen.len
        seen.len = seen.len + 1
    end

    (M[t] or
        error("cannot serialize type " .. t)
        )(value, seen)
end

--[[
function M.Buffer_write_string(s)
    M.Buffer_reserve(#s)
    ffi.copy(M.buf + M.buf_pos, s, #s)
    M.buf_pos = M.buf_pos + #s
end
]]--


--[[
TEST
]]--

local time = require("time").time

local N = 2^8

local test_data = {
    {0, "blablablabla", "blablablable", "blablablabli", 2^11, 2^12, 0},
    {2^2, 2^3, 2^4, 2^5, 2^6, 2^7, 2^8, 2^9, 2^10},
    {"a", "b"},
    {a=1, b=2},
}

function M.hash(...)
    local args = {...}
    args = #args == 1 and type(args[1]) == "table" and args[1] or args

    local res = {}
    for i, v in ipairs(args) do
        res[i] = M.dumps(v)
    end
    return table.concat(res, ";")
end


do
    local t0 = time()
    for j = 1, N do
        for i, v in ipairs(test_data) do
            assert(M.dumps(v) == M.dumps(v))
        end
    end
    local t1 = time()
    print("\ntime spent(step 1):", t1 - t0)
    -- time spent(step 1): 0.69704008102417
end


local t0 = time()
for j = 1, N do
    for i, v in ipairs(test_data) do
        assert(M.dumps(v) == M.dumps(v))
    end
end
local t1 = time()
print("\ntime spent(step 2a 'dumps'):", t1 - t0)
-- time spent(step 2a 'dumps'):    0.84604835510254

do
    local t0 = time()
    for j = 1, N do
        for i, v in ipairs(test_data) do
            assert(key_concat(v) == key_concat(v))
        end
    end
    local t1 = time()
    print("\ntime spent(step 2b 'key_concat'):", t1 - t0)
    -- time spent(step 2b '..'):   0.00099992752075195
end

do
    local t0 = time()
    for j = 1, N do
        for i, v in ipairs(test_data) do
            assert(table.concat(v, "§") ==
                   table.concat(v, "§"))
        end
    end
    local t1 = time()
    print("\ntime spent(step 2c 'table.concat'):", t1 - t0)
    -- time spent(step 2c 'table.concat'): 0.051002979278564
end

local types = {
    ["number"] = function(v) return v end,
    ["string"] = function(v) return v end,
    ["nil"] = function(v) return "" end,
    ["boolean"] = function(v) return v end,
    ["table"] = function(v) error("invalid type", type(v)) end
}

local inspect = require("inspect")
local data = {0, "blablabla", "blablable", 2048, 4096 , 0, "0"}
local res = key_concat(data)
print(res)  -- "blablabla\0blablable\02048\04096"
print(inspect(key_decat(res)))  -- { "blablabla", "blablable", "2048", "4096" }
local t = {}
t[res] = true
print(t[res], t, "Couldn't find tile: " .. res)
print(string.byte(res, 1, #res))
print(string.char(string.byte(res, 1, #res)))
