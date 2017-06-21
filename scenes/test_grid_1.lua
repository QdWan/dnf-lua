local widgets = require("widgets")


single_test = not auto and true or false
local SceneTestBase = require("scenes.test_base")


local SceneGridTest1 = class("SceneGridTest1", SceneTestBase)

function SceneGridTest1:init()
    SceneTestBase.init(self) -- super

    self.frame = widgets.Frame({
        parent=self,
        rect=self.rect,
        bg_color = {255, 255, 255, 31},
    })
    self.frame.w = self.rect.w / 2
    self.frame.h = self.rect.h / 2
    self.frame:set_center(self.rect:get_center())

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

return SceneGridTest1
