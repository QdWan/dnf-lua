local Frame = require("widgets.frame")
local Label = require("widgets.label")
local inspect = require("inspect")
local merge_tables = require("util.merge_tables")


local style = {
    font_size = 20,
    color = {223, 223, 223, 255},
    font_name = "caladea-regular.ttf"
}


local List = class("List", Frame)

function List:init(t)
    Frame.init(self, t)  --  super
end

function List:preload()
    self.font_obj = self.font_obj or manager.resources:font(
        self.font_name, self.font_size)
end

function List:get_default_style()
    return style
end

function List:insert(t)
    local style
    if type(t) == "string" then
        style = self:copy_style()
        style.text = t
        style.parent = self
    else
        style = merge_tables(self:copy_style(), t)
        style.parent = self
    end
    style.sticky = self.align

    local item = Label(style)
    self:grid()
    return item
end

function List:insert_list(l)
    local t = {}
    for i = 1, #l do
        local v = l[i]
        t[#t + 1] = self:insert(type(v) == "number" and tostring(v) or v)
    end
    return t
end

function List:insert_list_get_dict(l)
    local dict = {}
    for _, v in ipairs(l) do
        dict[v] = self:insert(type(v) == "number" and tostring(v) or v)
    end
    return dict
end

function List:__adjust_weight()
    for i = 1, self._cols do
        self.col_weight[i] = 1
    end
    for i = 1, self._rows do
        self.row_weight[i] = 1
    end
    Frame._adjust_weight(self)
end

return List
