local SceneBase = require("scenes.base")
-- local layer_text = require("layers.text")
local widgets = require("widgets")
local SceneGridTest = class("SceneGridTest", SceneBase)

function SceneGridTest:initialize()
    self.class.super.initialize(self) -- super

    self.frame = widgets.Frame({
        parent=self,
        rect=self.rect,
        z = 1
    })
    self.frame:row_configure(1, 1)  -- row=1, weight=1
    self.frame:col_configure(1, 1)  -- col=1, weight=1
    self.frame:row_configure(2, 2)  -- row=2, weight=1

    self.r0 = widgets.RectWidget({
        parent=self.frame,
        w=1,
        h=1,
        bg_color = {0, 255, 0, 255}
    })
    self.r0:grid_config{col=1, row=1, sticky="NSWE"}

    self.r1 = widgets.RectWidget({
        parent=self.frame,
        w=1,
        h=1,
        bg_color = {0, 0, 255, 255}
    })
    self.r1:grid_config{col=1, row=2, sticky="NSWE"}

    self.frame:grid()
end

return SceneGridTest
