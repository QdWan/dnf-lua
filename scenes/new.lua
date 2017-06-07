local SceneBase = require("scenes.base")

local SceneBlank = class("SceneBlank", SceneBase)

function SceneBlank:init()
    SceneBase.init(self) -- super
end

function SceneBlank:update(dt)
end

function SceneBlank:draw()
    print("I'm a blank scene. Copy me and do something :)")
end

return SceneBlank


