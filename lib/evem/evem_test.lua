local Event = require("evem")
local events = Event()

local time = require("time").time
local class = require('middleclass') or require('minclass')
local Manager = class("Manager")
local manager = Manager()

local huge = 2^8
local obs
local old_print, print  = print, function(...) end
local t0 = time()
for a = 1, huge do
    local v = huge - a
    obs = events:observe({"STRING", manager.class.name, a, v},
                        function(a, v) print("triggered", a, v, 1) end)
    if a % 3 == 0 then obs:remove() end

    events:observe({"STRING", manager.class.name, a, v},
                  function(a, v) print("triggered", a, v, 2) end)
    if a % 3 == 0 then obs:stop_propagation() end

    events:observe({"STRING", manager.class.name, a, v},
                  function(a, v) print("triggered", a, v, 3) end)

    events:trigger({"STRING", manager.class.name, a, v}, a, v)
    a = a + 1
end
local print, old_print = old_print, print
print("time", time() - t0)  -- time    0.004000186920166
