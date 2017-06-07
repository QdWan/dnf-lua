local SceneBase = require("scenes.base")
-- local layer_text = require("layers.text")
local widgets = require("widgets")
local SceneGridTest = class("SceneGridTest", SceneBase)

function SceneGridTest:init()
    self.class.super.init(self) -- super

    self.frame = widgets.Frame({
        parent=self,
        rect=self.rect,
        z = 1
    })
    self.frame:row_config(1, 1)  -- row=1, weight=1
    self.frame:col_config(1, 1)  -- col=1, weight=1
    self.frame:row_config(2, 2)  -- row=2, weight=1

    self.r0 = widgets.RectWidget({
        parent=self.frame,
        w=1,
        h=1,
        bg_color = {0, 255, 0, 255},
        col=1, row=1, sticky="NSWE"
    })

    self.r1 = widgets.RectWidget({
        parent=self.frame,
        w=1,
        h=1,
        bg_color = {0, 0, 255, 255},
        col=1, row=2, sticky="NSWE"
    })

    self.frame:grid()
end

return SceneGridTest
