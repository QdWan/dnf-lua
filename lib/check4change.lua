local paths = "?.lua;?/init.lua;?/?.lua;../?.lua;../?/init.lua;../?/?.lua;"
package.path = paths .. package.path

local lfs = require("lfs")
local inspect = require("inspect")
local tiles_path = "../resources/images/tilesets/tiles/"
local time = require("time").time



local files = {}
local function load_tileset_files()
    local png_pattern = "^(.+)#p_(%d+)#v_(%d+)%.png$"

    local max = math.max
    local attributes = lfs.attributes
    local tiles_path = tiles_path
    local open, read = io.open, io.read


    local hex_pattern = '%02x'
    local format, byte, gsub, match = string.format, string.byte, string.gsub,
          string.match
    for item in lfs.dir(tiles_path) do
        local name, pos, var = match(item, png_pattern)
        local abs = tiles_path .. item
        if name then
            local att = attributes(abs)
            if att.mode == "file" then
                files[#files + 1] = att.size .. item .. att.access
            end
        end
    end
end

load_tileset_files()

local N = 2^3
local output = "%08x"

local function test(fn, times, name)
    name = name or "?"
    local t0 = time()
    for i = 1, times do
        fn()
    end
    local t1 = time()
    print(string.format(
        "Test(%s): %d times took %fs",
        name, times, t1 - t0))
end

local v

local crc = require "LAPHLibs.crc32"
local crc32 = crc.CRC32
test(function()
        v = crc32(table.concat(files, "\0"))
    end,
    N,
    "crc32")
print(string.format(output, v))
--[[
Test(crc32): 8 times took 0.010000s
32c4e656
]]--

local md5 = require "LAPHLibs.md5"
test(function()
        v = md5(table.concat(files, "\0"))
    end,
    N,
    "md5")
print(string.format(output, v))
--[[
Test(md5): 8 times took 0.563032s
8000000000000000
]]--

local sha2 = require "LAPHLibs.sha2"
local sha256 = sha2.sha256
test(function()
        v = sha256(table.concat(files, "\0"))
    end,
    N,
    "sha256")
print(v)
--[[
Test(sha256): 8 times took 0.885050s
c41dd1024b617e261b73406ee6db02b7b779b346fdbf412fadd6b28185056060
]]--

local sha2 = require "LAPHLibs.sha2"
local sha224 = sha2.sha224
test(function()
        v = sha224(table.concat(files, "\0"))
    end,
    N,
    "sha224")
print(v)
--[[
Test(sha224): 8 times took 0.898052s
470e050a9f71f7cc9eb19e37a05a8cbc9beb2286b8fddf35526780a6
]]--


local KazHash = require("LAPHLibs.hashes").KazHash
test(function()
        v = KazHash(table.concat(files, "\0"))
    end,
    N,
    "KazHash")
print(v)
--[[

]]--
