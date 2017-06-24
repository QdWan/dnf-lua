local map_containers = require("dnf.map_containers")
local World = require("dnf.world")
local SceneMap = require("scenes.map")

single_test = not auto and true or false
local SceneTestBase = require("scenes.test_base")


local SceneMapSurfaceTest1 = class("SceneMapSurfaceTest1", SceneMap)

function SceneMapSurfaceTest1:init()
    world = world or World({
        header= map_containers.MapHeader{
        global_pos = map_containers.Position(0, 0),
        depth = 0,
        branch = 0,
        cr = 1,
        creator = "MapSurface01"
    }})
    SceneMap.init(self) -- super
end

function SceneMapSurfaceTest1:update(dt)
    SceneMap.update(self, dt) -- super
    -- SceneTestBase.update(self, dt) -- super/test
end

return SceneMapSurfaceTest1


