local SceneBase = require("scenes.base")
local widgets = require("widgets")
local Rect = require('rect')
local time = require("time")
local fudge = require("lib.fudge")

local math_min = math.min

local SceneSplash = class("SceneSplash", SceneBase)

function SceneSplash:initialize()
    SceneBase.initialize(self) -- super
    self:pack()
    self:set_img()
    self.alpha = 0
    self.alpha_factor = 0.5
end

function SceneSplash:pack()
    local pack = fudge.new("resources/images/tile")
    self.img = pack.image
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
        path=self.img,
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


