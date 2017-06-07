local Widget = require("widgets.base")
local util = require("util")
local time = require("time")


local lg = love.graphics

local style = {
    color = {255, 255, 255, 255}
}


local Image = class("Image", Widget):set_class_defaults{default_style = style}

local function load_img(widget, from, err)
    if err then error("deprecated parameter 'err'") end
    local img = (type(from) == "string" and manager.resources:image(from)
                 or from)
    if widget.fit_mode == "scale" then
        local size = {img:getWidth(), img:getHeight()}
        widget.scale = math.max(widget.parent.w / size[1],
                              widget.parent.h / size[2])
        widget:set_size(widget.parent.w, widget.parent.h)
        -- widget.dx = ((size[1] * widget.scale) - widget.parent.w) / 2
        -- widget.dy = ((size[2] * widget.scale) - widget.parent.h) / 2
    else
        widget:set_size(img:getWidth(), img:getHeight())
    end
    widget.dx = 0
    widget.dy = 0
    -- print("load_img", widget, to, from, widget[to])
    return img
end

function Image:preload()
    self:get_image_normal()
end

function Image:get_image_normal()
    self.image_normal = self.image_normal or load_img(
        self, self.path)
    return self.image_normal
end

function Image:get_image_hover()
    self.image_hover = self.image_hover or self.path_hover and load_img(
        self, self.path_hover)
    return self.image_hover
end

function Image:get_image_press()
    self.image_press = self.image_press or self.path_press and load_img(
        self, self.path_press)
    return self.image_press
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
    local key = "image_".. self.state
    local loader = self["get_" .. key]
    local img =  self[key] or loader(self) or self.image_normal

    lg.setColor(self.color)
    lg.draw(
        img,
        self.x - self.dx, self.y - self.dy,
        0,
        s, s
    )
end

return Image
