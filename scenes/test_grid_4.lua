local SceneBase = require("scenes.base")
-- local layer_text = require("layers.text")
local widgets = require("widgets")
local SceneGridTest = class("SceneGridTest", SceneBase)

function SceneGridTest:initialize()
    SceneBase.initialize(self)  -- super

    self.frame = widgets.Frame({
        parent=self,
        rect=self.rect,
        z = 1,
        bg_color = {255, 255, 255, 255}

    })
    self.frame:row_configure(1, 1)  -- row=1, weight=1
    self.frame:col_configure(1, 1)  -- col=1, weight=1
    self.frame:row_configure(2, 1)  -- row=2, weight=1
    self.frame:col_configure(2, 1)  -- col=2, weight=1

    self.f_nw = widgets.Menu({
        parent=self.frame,
        bg_color = {0, 255, 0, 127},
        z=2
    })
    self.f_nw:grid_config{col=1, row=1}
    self.f_nw:insert("New Game")
    self.f_nw:insert("Options")
    self.f_nw:insert("Quit")

    self.f_ne = widgets.Frame({
        parent=self.frame,
        bg_color = {0, 0, 255, 127},
        z=2
    })
    self.f_ne:grid_config{col=2, row=1, sticky="NSWE"}

    self.f_sw = widgets.Frame({
        parent=self.frame,
        bg_color = {255, 0, 0, 127},
        z=2
    })
    self.f_sw:grid_config{col=1, row=2, sticky="NSWE"}

    self.f_se = widgets.Frame({
        parent=self.frame,
        bg_color = {255, 255, 0, 127},
        z=2
    })
    self.f_se:grid_config{col=2, row=2, sticky="NSWE"}

    self.frame:grid()


end

return SceneGridTest
