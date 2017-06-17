local Stateful = require 'stateful'

local Populator = class("Populator")
Populator:include(Stateful)

function Populator:init(map)
    --[[
    log:warn("map.isInstanceOf(Populator)", map.isInstanceOf(Populator),
             inspect(map.header))
    ]]--
end

function Populator:populate()
end

return Populator
