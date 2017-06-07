local SceneBase = require("scenes.base")
-- local layer_text = require("layers.text")
local widgets = require("widgets")
local SceneGridTest = class("SceneGridTest", SceneBase)

function SceneGridTest:init()
    self.class.super.init(self)
    self.frame = widgets.Frame({
        parent=self,
        rect=self.rect,
        bg_color = {255, 255, 255, 127},
        expand=true
    })

    -- self.frame:row_config(1, 1)  -- row=1, weight=1
    -- self.frame:col_config(1, 1)  -- col=1, weight=1

    widgets.RectWidget({
        parent=self.frame,
        bg_color = {255, 0, 0, 223},
        w=64,
        h=64,
        col=1,
        row=1,
        sticky="NS"
    })

    widgets.RectWidget({
        parent=self.frame,
        bg_color = {0, 0, 255, 223},
        w=64,
        h=64,
        col=2,
        row=1,
        sticky="WE"
    })

    self.frame:grid()
end

return SceneGridTest
