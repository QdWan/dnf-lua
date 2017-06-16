local SceneBase = require("scenes.base")
local widgets = require("widgets")

local math_min = math.min

local SceneSplash = class("SceneSplash", SceneBase)

function SceneSplash:init()
    SceneSplash.super.init(self) -- super
    self:set_img()
    self.alpha = 0
    self.alpha_factor = 1
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
        path='love-logo.png',
        col=1,
        row=1
        })
    self.frame:grid()
end

function SceneSplash:update(dt)
    self:set_alpha(dt)
end

function SceneSplash:set_alpha(dt)
    self.alpha = self.alpha + self.alpha_factor * dt * 120
    if self.alpha >= 255 * 1.6 then
        self.alpha = 255
        self.alpha_factor = -1
    elseif self.alpha < 0 then
        events:trigger({'SET_SCENE'}, 'main_menu')
    end
end

function SceneSplash:draw()
    self.img.color = {255, 255, 255, math.min(self.alpha, 255)}
    SceneSplash.super.draw(self)
end

function SceneSplash:keypressed(key)
    events:trigger({'SET_SCENE'}, 'main_menu')
end

return SceneSplash


