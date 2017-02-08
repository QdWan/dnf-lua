local Widget = require("widgets.base")
local util = require("util")

local Image = class("Image", Widget)

local lg = love.graphics

local style = {
    color = {255, 255, 255, 255}
}

function Image:getter_default_style()
    return style
end

function Image:_cache()
    --[[
    Chain load the image/canvas caching.
    This is currently required so that we have a proper size setting.
    ]]--
    assert(self.image)
end

function Image:getter_image()
    local function load_img()
        local img = manager.resources:image(self.path)
        self.size  = {img:getWidth(), img:getHeight()}
        self._image = img
        return img
    end

    return self._image or load_img()
end

function Image:draw()
    local lg = lg
    lg.setColor(self.color)
    lg.draw(
        self.image,
        self.x,
        self.y
    )
    lg.setColor(255, 255, 255, 255)
end

return Image
