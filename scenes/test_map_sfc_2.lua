local map_containers = require("dnf.map_containers")
local World = require("dnf.world")
local SceneMap = require("scenes.map")


local single_test = not auto and true or false
local SceneTestBase = require("scenes.test_base")
auto.single_test = single_test


local SceneMapSurface02 = class("SceneMapSurface02", SceneMap)

function SceneMapSurface02:init()
    world = world or World({
        header= map_containers.MapHeader{
        global_pos = map_containers.Position(0, 0),
        depth = 0,
        branch = 0,
        cr = 1,
        creator = "MapSurface02"
    }})
    SceneMap.init(self) -- super
end

function SceneMapSurface02:update(dt)
    SceneMap.update(self, dt) -- super
    SceneTestBase.update(self, dt) -- super/test
end

return SceneMapSurface02


