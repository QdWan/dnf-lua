local Creation = require("scenes.creation")
local World = require("dnf.world")

single_test = not auto and true or false
local SceneTestBase = require("scenes.test_base")

local SceneCreationTest = class("SceneCreationTest", Creation)

function SceneCreationTest:init()
    world = world or World()
    Creation.init(self)
end

function SceneCreationTest:update(dt)
    Creation.update(self, dt) -- super
    SceneTestBase.update(self, dt) -- super/test
end

return SceneCreationTest
