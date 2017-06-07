local Frame = require("widgets.frame")
local Image = require("widgets.image")
local Label = require("widgets.label")
local util = require("lib.util")
local time = require("time")

local Button = class("Button", Frame)

local function fits(a, b)
    print(a, b, a.w, a.h, b.w, b.h)
    if (a.w > b.w * 0.85) or
       (a.h > b.h * 0.85)
    then
        return 1
    elseif (a.w < b.w * 0.6) and
       (a.h < b.h * 0.6)
    then
        return -1
    else
        return 0
    end
end


function Button:init(args)
    Frame.init(self, args)
    args.parent=self

    args.z = 1
    self.img = Image(args)
    -- args.normal = false
    self.img:bind(
        "MOUSERELEASED.1",
        function()
            print("Button.img.MOUSERELEASED.1")
            self.img.previous_state = self.img.state;
            self.img.state = "press";
            self.img.press_time = time.time()
        end
    )

    args.z = 2
    args.text = args.text:upper()
    args.font_size = 24
    args.font_name = "caladea-bold.ttf"
    args.color = {7, 13, 7, 255}
    args.bg_color = {255, 255, 255, 23}
    args.fits = function(widget) return fits(widget, self.img) end
    args.hover_color = false
    self.label_obj = Label(args)

    self:grid()
end

function Button:_register_widget(child)
    util.list_insert_new(self._children, child)
    -- child.z = self.z
end

function Button:draw(z)
    events:trigger({'DRAW', self, 1})
    self.label_obj.state = self.img.state
    events:trigger({'DRAW', self, 2})
end

function Button:_ungrid()
end

return Button
