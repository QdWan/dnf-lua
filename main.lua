require("rs_strict")

declare("ffi")
ffi = require("ffi")

declare("time")
time = require("time").time

declare("events")
local EveM = require("evem")
events = EveM()

declare("bitser")
bitser = require("bitser")

declare("socket") -- used by lovebird

declare("class")
local middleclass = require('middleclass')
class = function(...)
    local new_class = middleclass(...)
    bitser.registerClass(new_class)
    return new_class
end

declare("Rect")
Rect = require("rect")

declare("inspect")
inspect = require("inspect")

declare("log")
local Log = require("log")
log = Log()

local old_error = error
error = function(msg, level, debug_info)
    msg = string.gsub(msg, "%z", "\\0")
    level = (level or 1) + 1
    log:warn("ERROR MSG: " .. msg)
    if debug_info then log:info("DEBUG INFO: " .. debug_info()) end
    log:write()
    old_error(msg, level)
end

local old_assert = assert
assert = function(check, msg, level, debug_info)
    msg = msg or "assertion failed!"
    return check or error(
        msg,
        (level or 1) + 1,
        debug_info)
end

declare("manager")
local Manager = require("manager")
manager = Manager() -- instantiate it

love.run = function() manager:run() end

declare("world")

declare("lg")
lg = love.graphics
declare("lm")
lm = love.math
declare("lfs")
lfs = love.filesystem
declare("lsnd")
lsnd = love.sound
declare("laud")
laud = love.audio
declare("lphys")
lphys = love.physics
declare("lthread")
lthread = love.thread
declare("limg")
limg = love.image
declare("lt")
lt = love.timer
declare("le")
le = love.event

declare("auto")
declare("single_test")

declare("brutal_destroyer")
function brutal_destroyer(object)
    for k, w in pairs(object) do
        if k then object[k] = nil end
        setmetatable(object, nil)
    end
end
