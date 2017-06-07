local Widget = require("widgets.base")
local util = require("util")


local lg = love.graphics

local style = {
    font_size = 16,
    disabled_color = {127, 127, 127, 255},
    color = {223, 223, 223, 255},
    font_name = "caladea-regular.ttf",
    cursor_char = "_"
}


local Label = class("Label", Widget):set_class_defaults{default_style = style}

function Label:get_default_style()
    return style
end

function Label:preload()
    local direction, fits
    repeat
        self.font_size = self.font_size - (direction or 0)
        self.font_obj = ((not self.fits) and self.font_obj) or
                        manager.resources:font(self.font_name, self.font_size)
        self.w = self.font_obj:getWidth(self.text)
        self.h = self.font_obj:getHeight(self.text)
        -- print(self, self.font_size, self.w, self.h)
        direction = direction or (self.fits and self.fits(self))
    until self.fits == nil or self.fits(self) == 0
end

function Label:draw()
    lg.setBlendMode("alpha")

    local function draw_bg(c, x, y, w, h)
        love.graphics.setColor(self.bg_color)
        love.graphics.rectangle("fill", self.x, self.y, self.w, self.h)
    end

    lg.setFont(self.font_obj)
    self.blink_status = ((self.blink_status  or 0) + 1) % 80
    local coloredtext, text
    if self.coloredtext then
        if self.cursor_blink and self.blink_status < 40 and self.state == "hover" then
            coloredtext = util.copy_depth(self.coloredtext, 2)
            coloredtext[#coloredtext +1] = self.color
            coloredtext[#coloredtext +1] = self.cursor_char
        else
            coloredtext = self.coloredtext
        end
    else
        if self.cursor_blink and self.blink_status < 40 and self.state == "hover" then
            text = self.text .. self.cursor_char
        else
            text = self.text
        end
    end

    if not self.disabled and self.hover ~= false and self.state == "hover"
    then
        local time = manager.time()
        local loop = math.sin(time * 1.2 * math.pi)
        local color = self.color
        local r, g, b, a

        local s = 1 + (loop / 25 + 0.05)
        local ox = ((self.w * s) - self.w) / 3
        local oy = ((self.h * s) - self.h) / 3
        local step = 1 + loop * 3

        local k = loop / 2 + 1
        if self.hover_color ~= false then
            r = color[1] * (1 - loop) + 255 * loop
            g = color[2] * (1 - loop) + 255 * loop
            b = color[3] * (1 - loop) + ((1 - k) * 0.3 + 0.7) * 255 * loop
            a = 255
        else
            r = color[1]
            g = color[2]
            b = color[3]
            a = color[4]
        end

        if self.bg_color ~= nil then
            draw_bg(self.bg_color, self.x - ox,
                    self.y - oy, self.w * s, self.h * s)
        end

        lg.setColor({r, g, b, a})
        lg.print(
            coloredtext or text,
            self.x - ox, self.y - oy, 0,
            s, s
        )
    elseif self.normal ~= false then
        if self.bg_color ~= nil then
            draw_bg(self.bg_color, self.x,
                    self.y, self.w, self.h)
        end
        if self.disabled == true then
            lg.setColor(self.disabled_color)
        else
            lg.setColor(self.color)
        end
        lg.print(
            coloredtext or text,
            self.x,
            self.y
        )
    end
end

return Label
