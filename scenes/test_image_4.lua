local SceneBase = require("scenes.base")
local widgets = require("widgets")
local Rect = require('rect')
local time = require("time")
local fudge = require("lib.fudge")

local folder = "resources/images/tilesets/tiles"
local lg = love.graphics

local SceneSplash = class("SceneSplash", SceneBase)

function SceneSplash:initialize()
    SceneBase.initialize(self) -- super
    self.alpha = 0
    local count = 0
    local tiles = {}
    local tileset = {}
    for _, item in ipairs(love.filesystem.getDirectoryItems(folder)) do
        local pattern = "^(.+)%$p_(%d+)%$v_(%d+)%.png$"
        local name, pos, var = string.match(item, pattern)
        if name then count = count + 1
            print(item, name, pos, var)
            local tile = {
                file= "tilesets/tiles/" .. item,
                name=name,
                pos=tonumber(pos),
                var=tonumber(var)
            }
            tileset[name] = tileset[name] or {}
            tileset[name].pos = math.max(tileset[name].pos or 1, tile.pos)
            tileset[name].var = math.max(tileset[name].var or 1, tile.var)
            tile.img = manager.resources:image(
                {filename=tile.file, verbose=false}
            )
            tiles[#tiles + 1] = tile
        end
    end
    print(count)
    local max_tiles_wide = math.floor(lg.getSystemLimits().texturesize / 32)
    local width = math.min(max_tiles_wide, count)
    local height = math.ceil(count / width)
    print(width, height)
    self.canvas = love.graphics.newCanvas(width * 32, height * 32)
    local col, row = 0, 0
    love.graphics.setCanvas(self.canvas)
    love.graphics.clear()
    love.graphics.setBlendMode("alpha")
    for _, tile in ipairs(tiles) do
        local x, y = col * 32, row * 32
        love.graphics.draw(tile.img, x, y)
        col = col + 1
        if col > width then
            col = 0
            row = row + 1
        end
        print(tile.name, x, y)
    end
    --[[
    local data = self.canvas:newImageData( )
    data:encode("tga","tile_test.tga")
    ]]--
    love.graphics.setCanvas()
    love.graphics.setBlendMode("alpha", "premultiplied")
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


