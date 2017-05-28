local Widget = require("widgets.base")
local util = require("util")
local time = require("time")

local Image = class("Image", Widget)

local lg = love.graphics

local style = {
    color = {255, 255, 255, 255}
}

local function load_img(widget, to, from)
    local img = (type(from) == "string" and manager.resources:image(from)
                 or from)
    if widget.fit_mode == "scale" then
        local size = {img:getWidth(), img:getHeight()}
        widget.scale = math.max(widget.parent.w / size[1],
                              widget.parent.h / size[2])
        widget.size  = {widget.parent.w, widget.parent.h}
        -- widget.dx = ((size[1] * widget.scale) - widget.parent.w) / 2
        -- widget.dy = ((size[2] * widget.scale) - widget.parent.h) / 2
    else
        widget.size  = {img:getWidth(), img:getHeight()}
    end
    widget.dx = 0
    widget.dy = 0
    widget[to] = img
    print("load_img", widget, to, from, widget[to])
    return img
end

function Image:getter_default_style()
    return style
end

function Image:_cache()
    --[[
    Chain load the image/canvas caching.
    This is currently required so that we have a proper size setting.
    ]]--
    assert(self.image_normal)
end

function Image:getter_image_normal()
    return self._image_normal or load_img(
        self,  "_image_normal", self.path)
end

function Image:getter_image_hover()
    return self._image_hover or self.path_hover and load_img(
        self,  "_image_hover", self.path_hover)
end

function Image:getter_image_press()
    return self._image_press or self.path_press and load_img(
        self,  "_image_press", self.path_press)
end

function Image:update(dt)
    local str = self.state .. "_time"
    local timer = self[str]
    if timer and time.time() - timer > 0.20 then
        self[str] = nil
        self.state = self.previous_state or "normal"
    end
end

function Image:draw()
    local lg = lg

    local s
    if self.fit_mode == "scale" then
        s = self.scale
    else
        s = 1
    end
    local img = self["image_".. self.state] or self.image_normal

    lg.setColor(self.color)
    lg.draw(
        img,
        self.x - self.dx, self.y - self.dy,
        0,
        s, s
    )
end

return Image
