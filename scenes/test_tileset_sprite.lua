local lg = love.graphics

local SceneBase = require("scenes.base")
local SceneSprite = class("SceneMap", SceneBase)

function SceneSprite:initialize()
    SceneBase.initialize(self) -- super
    self.tile_w = 32
    self.tile_h = 32
    self.tileQuads = {}
    self:updateTilesetBatch()
end

function SceneSprite:updateTilesetBatch()
    self.tilesetImage = manager.resources:image("tileset.png")
    self.tilesetImage:setFilter("nearest", "linear")
    self.tilesetBatch = lg.newSpriteBatch(
        self.tilesetImage,
        (manager.width / self.tile_w + 1) *
        (manager.height / self.tile_h + 1)
    )
    -- grass
    self.tileQuads["wall"] = lg.newQuad(
        0 * self.tile_w, 20 * self.tile_h, self.tile_w, self.tile_h,
        self.tilesetImage:getWidth(), self.tilesetImage:getHeight())
    local sprite = self.tileQuads["wall"]
    self.tilesetBatch:add(sprite, 0 * self.tile_w, 0 * self.tile_h)
    self.tilesetBatch:flush()
end

function SceneSprite:draw()
    lg.draw(
        self.tilesetBatch,
        manager.width / 2,
        manager.height / 2,
        0,
        1,
        1)
end

return SceneSprite
