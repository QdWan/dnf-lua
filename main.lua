package.path = "lib/?.lua;?/init.lua;lib/?/init.lua;../lib/?.lua;" .. package.path

require("rs_strict")
declare("beholder")
beholder = require('beholder')

declare("socket") -- used by lovebird

declare("class")
class = require('middleclass')

declare("Rect")
Rect = require("lib.rect")

declare("inspect")
inspect = require("inspect")

declare("log")
local Log = require("lib.log")
log = Log{replace_print = true}

declare("manager")
local Manager = require("manager")
manager = Manager() -- instantiate it
