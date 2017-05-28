local SceneBase = require("scenes.base")
local widgets = require("widgets")
local Rect = require('rect')

local SceneSplash = class("SceneSplash", SceneBase)

function SceneSplash:initialize()
    SceneBase.initialize(self) -- super
    self.canvas = manager.resources:tileset("TileEntity")
    --[[
    local data = self.canvas:newImageData( )
    data:encode("tga","tile_test.tga")
    ]]--
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


