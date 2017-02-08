local Frame = require("widgets.frame")
local Label = require("widgets.label")
local inspect = require("inspect")

local Menu = class("Menu", Frame)


function Menu:initialize(t)
    Frame.initialize(self, t)  --  super
end

function Menu:insert(t)
    local item_args
    print(type(t))
    if type(t) == "string" then
        item_args = {
            text=t,
            parent=self,
            font_obj=manager.resources:font("caladea-regular.ttf", 54)
        }
    else
        item_args = t
        item_args.parent = item_args.parent or self
    end

    local item = Label(item_args)
    item:grid_config()
    self:grid()
    return item
end

function Menu:__adjust_weight()
    for i = 1, self._cols do
        self.col_weight[i] = 1
    end
    for i = 1, self._rows do
        self.row_weight[i] = 1
    end
    Frame._adjust_weight(self)
end

return Menu
