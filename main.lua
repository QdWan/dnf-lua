local manager_paths = "../?.lua;../?/init.lua;../lib/?.lua;../lib/?/init.lua;../lib/?/?.lua;?.lua;?/init.lua;lib/?.lua;lib/?/init.lua;lib/?/?.lua;"
package.path = manager_paths .. package.path

require("rs_strict")
declare("events")
local EveM = require("evem")
events = EveM()

declare("socket") -- used by lovebird

declare("class")
class = require('minclass')

declare("Rect")
Rect = require("rect")

declare("inspect")
inspect = require("inspect")

declare("log")
local Log = require("lib.log")
log = Log()

declare("manager")
local Manager = require("manager")
manager = Manager() -- instantiate it
