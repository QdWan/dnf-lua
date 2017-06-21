local widgets = require("widgets")


single_test = not auto and true or false
local SceneTestBase = require("scenes.test_base")


local SceneImageTest3 = class("SceneImageTest3", SceneTestBase)

function SceneImageTest3:init()
    SceneTestBase.init(self) -- super
    self.canvas = manager.resources:tileset("TileEntity").atlas
    self:set_img()
end

function SceneImageTest3:set_img()
    self.frame = widgets.Frame({
        parent=self,
        rect=self.rect,
        z=1
        })
    self.frame:row_config(1, 1)
    self.frame:col_config(1, 1)
    self.img = widgets.Image({
        parent=self.frame,
        path=self.canvas,
        col=1,
        row=1
        })
    self.frame:grid()
end

return SceneImageTest3


