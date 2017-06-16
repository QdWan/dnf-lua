local widgets = require("widgets")
local Stateful = require("stateful")


local single_test = not auto and true or false
local SceneBase = require("scenes.test_base")
auto.functions = {
    function(scene) scene:keypressed("tab") end,
    function(scene) scene:keypressed("tab") end
}
auto.single_test = single_test


local SceneMap = class("SceneMap", SceneBase)
SceneMap:include(Stateful)

function SceneMap:init(param)
    SceneMap.super.init(self)
    self.string = "Default state"
    self.anim = 3
    self:set_msg()
end

function SceneMap:get_msg()
    return self.string .. string.rep(".", self.anim)
end

function SceneMap:set_msg()
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

function SceneMap:update(dt)
    self.anim = (self.anim + dt * 2) % 4
    self.msg.text = self:get_msg()
    SceneMap.super.update(self, dt)
end

function SceneMap:keypressed(key, scancode, isrepeat)
    if key == 'tab' then
        self:gotoState('Abnormal')
    end
end


local Abnormal = SceneMap:addState('Abnormal')

function Abnormal:get_msg()
    return 'Abnormal state' .. string.rep(".", self.anim)
end

function Abnormal:keypressed(key, scancode, isrepeat)
    if key == 'tab' then
        self:gotoState(nil)
    end
end




return SceneMap
