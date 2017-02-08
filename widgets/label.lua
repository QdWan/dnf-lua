local Rect = require("lib.rect")
local Widget = require("widgets.base")
local util = require("util")

local Label = class("Label", Widget)

local lg = love.graphics

local style = {
    font_size = 16,
    color = {255, 255, 255, 255}
}

function Label:getter_default_style()
    return style
end

function Label:_cache()
    self.font_obj = self.font_obj or lg.newFont(self.font_size)
    --[[
    Chain load the image/canvas caching.
    This is currently required so that we have a proper size setting.
    ]]--
    assert(self.image)
end

function Label:getter_image()
    if self._image == nil then
        self._image = self:_render_text()
    end
    return self._image
end

function Label:_create_canvas()
    local w = self.font_obj:getWidth(self.text)
    local h = self.font_obj:getHeight(self.text)
    self.w = w
    self.h = h
    return lg.newCanvas(w, h)
end

function Label:_render_text()
    local lg = lg
    local canvas = self:_create_canvas()
    canvas:renderTo(function()
        lg.clear();
        lg.setBlendMode("alpha")
        if self.bg_color ~= nil then
            lg.setColor(self.bg_color);
            lg.rectangle("fill", 0, 0, self.w, self.h);
        end
        lg.setColor(self.color);
        lg.setFont(self.font_obj);
        if self.coloredtext then
            lg.print(self.coloredtext, 0, 0);
        else
            lg.print(self.text, 0, 0);
        end
    end)
    return canvas
end

function Label:draw()
    if self.hover ~= false and self.state == "hover" then
        local time = manager.time()
        local loop = math.sin(time * 1.1 * math.pi)

        local s = 1 + loop / 20
        local ox = ((self.w * s) - self.w) / 3
        local oy = ((self.h * s) - self.h) / 3
        local step = 1 + loop * 3

        local k = loop / 2 + 1
        lg.setColor(
            255,
            255,
            ((1 - k) * 0.3 + 0.7) * 255,
            255
            )
        lg.draw(
            self.image,
            self.x - ox, self.y - oy, 0,
            s, s
        )
        lg.setColor(255, 255, 255, 255)
    else
        lg.setBlendMode("alpha", "premultiplied")
        lg.setColor(255, 255, 255, 255)
        lg.draw(
            self.image,
            self.x,
            self.y
        )
    end
end

return Label
