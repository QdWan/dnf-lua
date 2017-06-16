local widgets = require("widgets")
local Rect = require('rect')


single_test = not auto and true or false
local SceneBase = require("scenes.test_base")


local SceneSplash = class("SceneSplash", SceneBase)

function SceneSplash:init()
    SceneBase.init(self) -- super
    self:set_img()
    self.alpha = 0
    self.alpha_factor = 0.5
end

function SceneSplash:set_img()
    self.frame = widgets.Frame({
        parent=self,
        rect=self.rect,
        z=1
        })
    self.frame:row_config(1, 1)
    self.frame:col_config(1, 1)
    self.img = widgets.Button({
        parent=self.frame,
        path_hover="roll_button3_a.png",
        path=      "roll_button3_b.png",
        path_press="roll_button3_c.png",
        text="Roll",
        col=1,
        row=1
        })

    self.frame:grid()
end

return SceneSplash


