package.path = ("lib/?.lua;../lib/?.lua;?/init.lua;../?;../?.lua" ..
                package.path)

class = require('middleclass')
beholder = require('beholder')
inspect = require('inspect')
require("rs_strict")
