local manager_paths = "../?.lua;../?/init.lua;../lib/?.lua;../lib/?/init.lua;../lib/?/?.lua;?.lua;?/init.lua;lib/?.lua;lib/?/init.lua;lib/?/?.lua;"
package.path = manager_paths .. package.path

require("rs_strict")
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
local Log = require("lib.log")
log = Log()

local old_error = error
error = function(msg, level)
    level = (level or 1) + 1
    log:warn(msg)
    log:write()
    old_error(msg, level)
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

declare("brutal_destroyer")
function brutal_destroyer(object)
    for k, w in pairs(object) do
        if k then object[k] = nil end
        setmetatable(object, nil)
    end
end
