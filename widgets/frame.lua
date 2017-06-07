local Widget = require("widgets.base")

local Frame = class("Frame", Widget)

local inspect = require("inspect")

function Frame:init(args)
    --[[ Basic unit of organization for complex layouts.

    A frame is a rectangular area that can contain other widgets.
     ]]--
    self.z = 1
    self._rows = 0
    self._cols = 0

    assert(args.parent)

    Widget.init(self, args)  --  super
    self._row_size = {}
    self._col_size = {}
    self.row_weight = {}
    self.col_weight = {}
end

function Frame:grid(mode)
    if mode ~= "soft" then
        self:_ungrid()
    end
    if #self._children == 0 then
        return
    end
    self:_update_grid_size()
    self:_adjust_weight()
    self:_update_children()
end

function Frame:_update_grid_size()
    local children = self._children
    self._rows = 0
    self._cols = 0
    self._row_size = {}
    self._col_size = {}
    local max = math.max
    for i = 1, #children do
        local child = children[i]
        child:_ungrid()
        child.row = child.row or self._rows + 1
        local row = child.row
        local rowspan = child.rowspan
        local col = child.col
        local colspan = child.colspan
        self._rows = max(self._rows, row + rowspan - 1)
        self:_row_adjust(row, rowspan, child)
        self._cols = max(self._cols, col + colspan - 1)
        self:_col_adjust(col, colspan, child)
    end
    for i = 1, self._rows do
        self._row_size[i] = self._row_size[i] or 0
    end
    for i = 1, self._cols do
        self._col_size[i] = self._col_size[i] or 0
    end
end

function Frame:_expand_weights(weights, dim_size)
    for i = 1, dim_size do
        weights[i] = weights[i] or 1
    end
end

function Frame:_adjust_weight()
    local floor = math.floor

    local dimension_key
    local coord

    for _, param in pairs({{"w", "col"}, {"h", "row"}}) do
        dimension_key = param[1]
        coord = param[2]

        local frame_size = self[dimension_key]  --  self.w, self.h
        local weights = self[coord .. "_weight"]  --  col_weight, row_weight
        local dim_size = self["_" .. coord .. "s"]  --  _cols, _rows
        local cell_sizes = self[
            "_".. coord .. "_size"]--  _col_size, _row_size
        if self.expand then
            self:_expand_weights(weights, dim_size)
        end

        -- check total weight
        local total_weight = 0
        for _, v in pairs(weights) do
            total_weight = total_weight + v
        end

        local size = 0
        for i = 1, dim_size do
            size = size + cell_sizes[i]
        end

        -- percentual weight
        local space = math.max((frame_size - size) / total_weight, 0)
        local new_size_sum = 0

        if space == 0 or total_weight == 0 then
            new_size_sum = size
        else
            for i = 1, dim_size do
                local new_size = floor(cell_sizes[i] +
                                    (weights[i] or 0) * space)
                cell_sizes[i] = new_size
                new_size_sum = new_size_sum + new_size
            end
        end
        self[dimension_key] = new_size_sum
    end
end


function Frame:_row_adjust(row, span, widget)
    local widget_size = math.floor((widget.h + widget.pady * 2) / span)
    for i = row, row + span - 1 do
        self._row_size[i] = math.max(self._row_size[i] or 1, widget_size)
    end
end

function Frame:_col_adjust(col, span, widget)
    local size = math.floor((widget.w + widget.padx * 2) / span)
    for i = col, col + span - 1 do
        self._col_size[i] = math.max(self._col_size[i] or 1, size)
    end
end

function Frame:_update_children()
    local children = self._children
    for i = 1, #children do
        self:_update_child(children[i])
    end
end

function Frame:_update_child(child)
    local col = child.col
    local colspan = child.colspan
    local row = child.row
    local rowspan = child.rowspan
    local sticky = child.sticky
    local string = string

    local N, S, W, E
    if sticky ~= nil then
        sticky = string.upper(sticky)
        N = string.find(sticky, "[NT]")
        S = string.find(sticky, "[SB]")
        W = string.find(sticky, "[WL]")
        E = string.find(sticky, "[ER]")
    end

    local horizontal, vertical
    if W == nil and E == nil then
        horizontal = "C"
    end
    if N == nil and S == nil then
        vertical = "C"
    end

    if child.grid then child:grid("soft") end

    local resized = false
    if horizontal == "C" then
        child:set_centerx(self.x + (self:get_cell_width(1, col - 1) +
                          self:get_cell_width(col, colspan) / 2))
    else
        resized = true
        if W == nil and E ~= nil then
            child:set_right(self:get_cell_width(1, col) -
                            child.padx +
                            self.x)
        else
            if E ~= nil and W ~= nil then
                -- stretch horizontally
                child.w = self:get_cell_width(col, colspan)
            end
            child.x = (self:get_cell_width(1, col - 1) +
                       child.padx +
                       self.x)
        end
    end

    if vertical == "C" then
        child:set_centery(self.y + (self:get_cell_height(1, row - 1) +
                                    self:get_cell_height(row, rowspan) / 2))
    else
        resized = true
        if N == nil and S ~= nil then
            child:set_bottom(self:get_cell_height(1, row) -
                       child.pady +
                       self.y)
        else
            if S ~= nil and N ~= nil then
                -- stretch vertically
                child.h = self:get_cell_height(row, rowspan)
            end
            child.y = (self:get_cell_height(1, row - 1) +
                       child.pady +
                       self.y)
        end
    end

    if child.grid then
        child:grid("soft")
    end

end

function Frame:get_cell_width(col, colspan)
    local size = 0
    for i = col, col + colspan - 1 do
        size = size + (self._col_size[i] or 2)
    end
    return size
end

function Frame:get_cell_height(row, rowspan)
    local size = 0
    for i = row, row + rowspan - 1 do
        size = size + (self._row_size[i] or 2)
    end
    return size
end

function Frame:row_config(row, weight)
    self.row_weight[row] = weight
end

function Frame:col_config(col, weight)
    self.col_weight[col] = weight
end

function Frame:stop_propagation(str)
    local evt = self.observers[str]
    if evt ~= nil then
        evt:stop_propagation()
    end
    local parent_evt = self.parent.observers[str]
    if parent_evt ~= nil then
        parent_evt:stop_propagation()
    end
end

function Frame:update(dt)
    events:trigger({'UPDATE', self}, dt)
end

function Frame:draw(z)
    if self.bg_color ~= nil then
        love.graphics.setColor(self.bg_color)
        love.graphics.rectangle("fill", self.x, self.y, self.w, self.h)
    end
    -- print("'DRAW' trigger", self, self.z)
    events:trigger({'DRAW', self, self.z})
end

function Frame:keypressed(key, scancode, isrepeat)
    Widget.keypressed(self, key, scancode, isrepeat)
    events:trigger({'KEYPRESSED', self}, key, scancode, isrepeat)
end

function Frame:keyreleased(key, scancode)
    Widget.keyreleased(self, key, scancode)
    events:trigger({'KEYRELEASED', self}, key, scancode)
end

function Frame:mousemoved(x, y, dx, dy, istouch)
    Widget.mousemoved(self, x, y, dx, dy, istouch)
    events:trigger({'MOUSEMOVED', self}, x, y, dx, dy, istouch)
end

function Frame:wheelmoved(x, y, dx, dy)
    Widget.wheelmoved(self, x, y, dx, dy)
    events:trigger({'WHEELMOVED', self}, x, y, dx, dy)
end

function Frame:mousepressed(x, y, button, istouch)
    Widget.mousepressed(self, x, y, button, istouch)
    events:trigger({'MOUSEPRESSED', self}, x, y, button, istouch)
end

function Frame:mousereleased(x, y, button, istouch)
    Widget.mousereleased(self, x, y, button, istouch)
    events:trigger({'MOUSERELEASED', self}, x, y, button, istouch)
end

function Frame:textinput(t)
    Widget.textinput(self, t)
    events:trigger({'TEXTINPUT', self}, t)
end

return Frame
