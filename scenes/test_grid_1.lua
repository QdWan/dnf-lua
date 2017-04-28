local SceneBase = require("scenes.base")
-- local layer_text = require("layers.text")
local widgets = require("widgets")
local SceneGridTest = class("SceneGridTest", SceneBase)

function SceneGridTest:initialize()
    SceneBase.initialize(self) -- super

    self.frame = widgets.Frame({
        parent=self,
        rect=self.rect,
        bg_color = {255, 255, 255, 31},
    })
    self.frame.w = self.rect.w / 2
    self.frame.h = self.rect.h / 2
    self.frame.center = self.rect.center

    self.r0 = widgets.RectWidget({
        parent=self.frame,
        bg_color = {255, 0, 0, 127},
        w=64,
        h=64,
        col=1,
        row=1,
        colspan=2,
        rowspan=2
    })

    self.r1 = widgets.RectWidget({
        parent=self.frame,
        bg_color = {0, 255, 0, 127},
        w=64,
        h=64,
        col=3,
        row=1,
        sticky="NS"
    })

    self.r2 = widgets.RectWidget({
        parent=self.frame,
        bg_color = {0, 0, 255, 127},
        w=64,
        h=64,
        col=1,
        row=3,
        sticky="NSWE"
    })

    self.r3 = widgets.RectWidget({
        parent=self.frame,
        bg_color = {255, 0, 255, 127},
        w=64,
        h=64,
        col=2,
        row=3,
        sticky="NSWE"
    })

    self.frame:grid()
end

return SceneGridTest
