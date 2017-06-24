local widgets = require("widgets")
local rect_packer = require("rect_packer")


single_test = not auto and true or false
local SceneTestBase = require("scenes.test_base")


local ScenePackingTest1 = class("ScenePackingTest1", SceneTestBase)

function ScenePackingTest1:init()
    SceneTestBase.init(self) -- super
    self:set_rects()
end

function ScenePackingTest1:set_rects()
    local max_w = lg.getSystemLimits().texturesize

    local tileset = manager.resources:tileset("TileEntity")

    local max_h = rect_packer.img_packer(max_w, nil, tileset.sources)
    log:info("max_h: " .. max_h)
    log:info(inspect(tileset.sources))

    local canvas = love.graphics.newCanvas(max_w, max_h)
    love.graphics.setCanvas(canvas)
    for i, src in ipairs(tileset.sources) do
        love.graphics.draw(src.img, src.x, src.y)
    end
    love.graphics.setCanvas()
    self.canvas = canvas
end

function ScenePackingTest1:update(...)
    SceneTestBase.update(self, ...) -- super
end

function ScenePackingTest1:draw(...)
    love.graphics.draw(self.canvas)
end

return ScenePackingTest1
