local widgets = require("widgets")
local Stateful = require("stateful")


single_test = not auto and true or false
local SceneTestBase = require("scenes.test_base")
auto.functions = {
    function(scene) scene:keypressed("tab") end,
    function(scene) scene:keypressed("tab") end
}



local SceneStatefulTest = class("SceneStatefulTest", SceneTestBase)
SceneStatefulTest:include(Stateful)

function SceneStatefulTest:init(param)
    SceneStatefulTest.super.init(self)
    self.string = "Default state"
    self.anim = 3
    self:set_msg()
end

function SceneStatefulTest:get_msg()
    return self.string .. string.rep(".", self.anim)
end

function SceneStatefulTest:set_msg()
    self.frame = widgets.Frame({
        parent=self,
        -- bg_color={0, 0, 255, 255},
        rect=self.rect,
        z = 1
    })
    self.frame:row_config(1, 1)
    self.frame:col_config(1, 1)

    self.msg = widgets.Label({
        hover=false,
        parent=self.frame,
        text=self:get_msg(),
        sticky="C",
        col=1,
        row=1,
        expand=true,
        font_size = 54,
        color = {200, 26, 15, 255},
    })

    self.frame:grid()
end

function SceneStatefulTest:update(dt)
    self.anim = (self.anim + dt * 2) % 4
    self.msg.text = self:get_msg()
    SceneStatefulTest.super.update(self, dt)
end

function SceneStatefulTest:keypressed(key, scancode, isrepeat)
    if key == 'tab' then
        self:gotoState('Abnormal')
    end
end


local Abnormal = SceneStatefulTest:addState('Abnormal')

function Abnormal:get_msg()
    return 'Abnormal state' .. string.rep(".", self.anim)
end

function Abnormal:keypressed(key, scancode, isrepeat)
    if key == 'tab' then
        self:gotoState(nil)
    end
end




return SceneStatefulTest
