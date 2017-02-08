local SceneBase = require("scenes.base")
-- local layer_text = require("layers.text")
local widgets = require("widgets")
local SceneGridTest = class("SceneGridTest", SceneBase)

function SceneGridTest:initialize()
    self.class.super.initialize(self)
    self.frame = widgets.Frame({
        parent=self,
        rect=self.rect,
        bg_color = {255, 255, 255, 31},
    })
    self.frame.w = self.rect.w / 2
    self.frame.h = self.rect.h / 2
    self.frame.center = self.rect.center

    self.frame:row_configure(1, 1)  -- row=1, weight=1
    self.frame:col_configure(1, 1)  -- col=1, weight=1

    self.r0 = widgets.RectWidget({
        parent=self.frame,
        bg_color = {255, 0, 0, 127},
        w=64,
        h=64
    })
    self.r0:grid_config{col=1, row=1, sticky="E"}
    self.frame:grid()
end

return SceneGridTest
