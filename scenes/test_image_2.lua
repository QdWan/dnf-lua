local widgets = require("widgets")
local time = require("time")
local math_min = math.min


local single_test = not auto and true or false
local SceneBase = require("scenes.test_base")
auto.single_test = single_test


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
    self.img = widgets.Image({
        parent=self.frame,
        path_hover="roll_button3_a.png",
        path=      "roll_button3_b.png",
        path_press="roll_button3_c.png",
        col=1,
        row=1
        })
    self.img:bind(
        "MOUSERELEASED.1",
        function()
            self.img.previous_state = self.img.state;
            self.img.state = "press";
            self.img.press_time = time.time()
        end)

    self.frame:grid()
end

return SceneSplash


