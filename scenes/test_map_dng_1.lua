local map_containers = require("dnf.map_containers")
local World = require("dnf.world")
local SceneMap = require("scenes.map")

single_test = not auto and true or false
local SceneTestBase = require("scenes.test_base")


local SceneMapDungeonTest1 = class("SceneMapDungeonTest1", SceneMap)

function SceneMapDungeonTest1:init()
    world = world or World({
        header= map_containers.MapHeader{
        global_pos = map_containers.Position(0, 0),
        depth = 0,
        branch = 0,
        cr = 1,
        creator = "MapDungeon01"
    }})
    SceneMap.init(self) -- super
end

function SceneMapDungeonTest1:update(dt)
    SceneMap.update(self, dt) -- super
    SceneTestBase.update(self, dt) -- super/test
end

return SceneMapDungeonTest1


