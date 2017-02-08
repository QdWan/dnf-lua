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
    self.frame:row_configure(1, 2)  -- row=1, weight=1
    self.frame:col_configure(1, 2)  -- col=1, weight=1
    self.frame:row_configure(2, 1)  -- row=2, weight=1
    self.frame:row_configure(3, 4)  -- row=2, weight=1


    self.title = widgets.Image({
        parent=self.frame,
        path = 'resources/love-logo.png'})
    self.title:grid_config{col=1, row=1, sticky="S"}

    self.body = widgets.Label({
        parent=self.frame,
        text="Options",
        font_size=32
    })
    self.body:grid_config{col=1, row=3, sticky="N"}

    self.frame:grid()
end

return SceneMainMenu
