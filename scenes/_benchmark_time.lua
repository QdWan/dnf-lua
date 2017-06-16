local test = require("util").test
local jit_time = time
local love_time = love.timer.getTime

local N = 2^20
log:warn("jit_time", jit_time())
log:warn("love_time", love_time())

-- Test(jit_time): 1048576 times took 0.013001s
log:warn(test(jit_time, N, "jit_time"))

-- Test(love_time): 1048576 times took 1.619093s
log:warn(test(love_time, N, "love_time"))

return love.event.quit
