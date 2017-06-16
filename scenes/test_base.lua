local SceneBase = require("scenes.base")
local Auto = require("auto_test_scenes")

auto = auto or Auto({
    ignore = "test_base.lua",
    sleep = 0.1
})

local SceneTestBase = class("SceneTestBase", SceneBase)

function SceneTestBase:update(dt)
    auto:call(self)
end


return SceneTestBase
