local test = require("util").test
local jit_time = require("time").time
local jit_clock = require("time").clock
local love_time = manager.love_getTime

local N = 2^19
log:warn("jit_time", jit_time())
log:warn("jit_clock", jit_clock())
log:warn("love_time", love_time())

-- Test(jit_time): 524288 times took 0.007000s
log:warn(test(jit_time, N, "jit_time"))

-- Test(jit_clock): 524288 times took 0.760043s
log:warn(test(jit_clock, N, "jit_clock"))

-- Test(love_time): 524288 times took 0.807046s
log:warn(test(love_time, N, "love_time"))

return love.event.quit
