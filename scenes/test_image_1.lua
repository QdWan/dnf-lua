local base_scenes = require("scenes.base")
-- local layer_text = require("layers.text")
local widgets = require("widgets")
local SceneMainMenu = class("SceneMainMenu", base_scenes.SceneMultiLayer)

function SceneMainMenu:initialize()
    base_scenes.SceneMultiLayer.initialize(self) -- super
    self.frame = widgets.Frame({
        parent=self,
        -- bg_color={0, 0, 255, 255},
        rect=self.rect
    })
    self.frame:row_config(1, 2)  -- row=1, weight=1
    self.frame:col_config(1, 2)  -- col=1, weight=1
    self.frame:row_config(2, 1)  -- row=2, weight=1
    self.frame:row_config(3, 4)  -- row=2, weight=1


    self.title = widgets.Image({
        parent=self.frame,
        path = 'resources/love-logo.png',
        col=1, row=1, sticky="S"
    })

    self.body = widgets.Label({
        parent=self.frame,
        text="Options",
        font_size=32,
        col=1, row=3, sticky="N"
    })

    self.frame:grid()
end

return SceneMainMenu
