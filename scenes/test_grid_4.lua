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
        bg_color = {255, 255, 255, 255},
        expand=true -- set all col/row weights to 1

    })

    self.f_11 = widgets.List({
        parent=self.frame,
        bg_color = {255, 0, 0, 255},
        z=2,
        col=1, row=1, sticky="NW", align="W"
    })
    self.f_11:insert("New Game")
    self.f_11:insert("Options")
    self.f_11:insert("Quit")


    self.f_21 = widgets.List({
        parent=self.frame,
        bg_color = {0, 0, 255, 255},
        z=2,
        col=2, row=1, sticky="N", align="W"
    })
    self.f_21:insert("New Game")
    self.f_21:insert("Options")
    self.f_21:insert("Quit")


    self.f_31 = widgets.List({
        parent=self.frame,
        bg_color = {0, 255, 0, 255},
        z=2,
        col=3, row=1, sticky="NE", align="L"
    })
    self.f_31:insert("New Game")
    self.f_31:insert("Options")
    self.f_31:insert("Quit")


    self.f_12 = widgets.List({
        parent=self.frame,
        bg_color = {255, 0, 0, 255},
        z=2,
        col=1, row=2, sticky="W"
    })
    self.f_12:insert("New Game")
    self.f_12:insert("Options")
    self.f_12:insert("Quit")


    self.f_22 = widgets.List({
        parent=self.frame,
        bg_color = {0, 0, 255, 255},
        z=2,
        col=2, row=2
    })
    self.f_22:insert("New Game")
    self.f_22:insert("Options")
    self.f_22:insert("Quit")


    self.f_32 = widgets.List({
        parent=self.frame,
        bg_color = {0, 255, 0, 255},
        z=2,
        col=3, row=2, sticky="R"
    })
    self.f_32:insert("New Game")
    self.f_32:insert("Options")
    self.f_32:insert("Quit")


    self.f_13 = widgets.List({
        parent=self.frame,
        bg_color = {255, 0, 0, 255},
        z=2,
        col=1, row=3, align="E", sticky="SW"
    })
    self.f_13:insert("New Game")
    self.f_13:insert("Options")
    self.f_13:insert("Quit")


    self.f_23 = widgets.List({
        parent=self.frame,
        bg_color = {0, 0, 255, 255},
        z=2,
        col=2, row=3, sticky="S", align="R"
    })
    self.f_23:insert("New Game")
    self.f_23:insert("Options")
    self.f_23:insert("Quit")


    self.f_33 = widgets.List({
        parent=self.frame,
        bg_color = {0, 255, 0, 255},
        z=2,
        col=3, row=3, sticky="SR", align="R"
    })
    self.f_33:insert("New Game")
    self.f_33:insert("Options")
    self.f_33:insert("Quit")


    self.frame:grid()

end

return SceneGridTest
