local widgets = require("widgets")


local single_test = not auto and true or false
local SceneBase = require("scenes.test_base")
auto.single_test = single_test


local SceneSplash = class("SceneSplash", SceneBase)

function SceneSplash:init()
    SceneBase.init(self) -- super
    self.canvas = manager.resources:tileset("TileEntity").atlas
    self:set_img()
end

function SceneSplash:set_img()
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

return SceneSplash


