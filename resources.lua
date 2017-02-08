local class = require("middleclass")
local Properties = require('lib.properties')

local Resources = class("Resources"):include(Properties)

function Resources:initialize()
    self.fonts = {}-- {_mode = "v"}
    self.images = {}-- {_mode = "v"}
    -- self.sounds = {_mode = "v"}
end

function Resources:font(filename, size)
    local key = filename .. ";" .. tostring(size)
    local font = self.fonts[key]
    if font == nil then
        print("caching font:", key)
        font = love.graphics.newFont(
            "resources/fonts/" .. filename, size)
        self.fonts[key] = font
    end
    return font
end

function Resources:image(filename)
    local image = self.images[filename]
    if image == nil then
        print("caching image:", filename)
        image = love.graphics.newImage(
            "resources/images/" .. filename
        )
        self.images[filename] = image
    end
    return image
end

return Resources
