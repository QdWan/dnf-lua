package.path = ";c:/luapower/?.lua;" .. package.path

--local SCENE = "mapdungeon01"

love = require("loveless")

require("main")

local creator = require("map_gen.mapdungeon01")()
--[[

manager.load = function(self)
    self:parse_initial_args(arg)

    self.next_time = lt.getTime()
    self:set_scene(SCENE)
end

love.run()
]]--
