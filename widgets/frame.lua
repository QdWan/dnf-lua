local Widget = require("widgets.base")

local Frame = class("Frame", Widget)


function Frame:initialize(args)
    --[[ Basic unit of organization for complex layouts.

    A frame is a rectangular area that can contain other widgets.
     ]]--
    self.z = 1
    self._rows = 0
    self._cols = 0

    Widget.initialize(self, args)  --  super
    self._rows_h = {}
    self._cols_w = {}
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
    self._rows_h = {}
    self._cols_w = {}
    local max = math.max
    for i = 1, #children do
        local child = children[i]
        child:_ungrid()
        local _grid_args = child._grid_args
        _grid_args.row = _grid_args.row or self._rows + 1
        local row = _grid_args.row
        local rowspan = _grid_args.rowspan
        local col = _grid_args.col
        local colspan = _grid_args.colspan
        self._rows = max(self._rows, row + rowspan - 1)
        self:_row_adjust(row, rowspan, child)
        self._cols = max(self._cols, col + colspan - 1)
        self:_col_adjust(col, colspan, child)
    end
end

function Frame:_adjust_weight()
    self:_adjust_width_weight()
    self:_adjust_height_weight()
end

function Frame:_adjust_width_weight()
    local frame_w = self.w
    local floor = math.floor

    -- check total weight
    local total_weight = 0
    for _, v in pairs(self.col_weight) do
        total_weight = total_weight + v
    end

    local width = 0
    for i = 1, self._cols do
        width = width + self._cols_w[i]
    end

    -- percentual weight
    local space = math.max((frame_w - width) / total_weight, 0)
    local new_w_sum = 0

    if space == 0 or total_weight == 0 then
        print("Frame:_adjust_width_weight() space == 0 or total_weight == 0")
        new_w_sum = width
    else
        for i = 1, self._cols do
            local new_w = floor(self._cols_w[i] +
                                (self.col_weight[i] or 0) * space)
            self._cols_w[i] = new_w
            new_w_sum = new_w_sum + new_w
        end
    end
    self.w = new_w_sum
end

function Frame:_adjust_height_weight()
    local frame_h = self.h
    local floor = math.floor

    -- check total weight
    local total_weight = 0
    for _, v in pairs(self.row_weight) do
        total_weight = total_weight + v
    end

    -- check current size
    local height = 0
    for i = 1, self._rows do
        self._rows_h[i] = (self._rows_h[i] or 0)
        height = height + self._rows_h[i]
    end

    -- percentual weight
    local space = math.max((frame_h - height) / total_weight, 0)
    local new_h_sum
    if space == 0 or total_weight == 0 then
        new_h_sum = height
    else
        new_h_sum = 0
        for i = 1, self._rows do
            local new_h = math.floor(self._rows_h[i] +
                                     (self.row_weight[i] or 0) * space)
            self._rows_h[i] = new_h
            new_h_sum = new_h_sum + new_h
        end
    end
    self.h = new_h_sum
end

function Frame:_row_adjust(row, span, widget)
    local size = math.floor((widget.h + widget._grid_args.padx * 2) / span)
    for i = row, row + span - 1 do
        self._rows_h[i] = math.max(self._rows_h[i] or 1, size)
    end
end

function Frame:_col_adjust(col, span, widget)
    local size = math.floor((widget.w + widget._grid_args.pady * 2) / span)
    for i = col, col + span - 1 do
        self._cols_w[i] = math.max(self._cols_w[i] or 1, size)
    end
end

function Frame:_update_children()
    local children = self._children
    for i = 1, #children do
        self:_update_child(children[i])
    end
end

function Frame:_update_child(child)
    local _grid_args = child._grid_args
    local col = _grid_args.col
    local colspan = _grid_args.colspan
    local row = _grid_args.row
    local rowspan = _grid_args.rowspan
    local sticky = _grid_args.sticky
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

    local resized = false
    if horizontal == "C" then
        if child.grid then child:grid("soft") end
        child.centerx = self.x + (self:get_cell_width(1, col - 1) +
                                  self:get_cell_width(col, colspan) / 2)
    else
        resized = true
        if W == nil and E ~= nil then
            child.right = (self:get_cell_width(1, col) -
                           _grid_args.padx +
                           self.x)
        else
            if E ~= nil and W ~= nil then
                -- stretch horizontally
                child.w = self:get_cell_width(col, colspan)
            end
            child.x = (self:get_cell_width(1, col - 1) +
                       _grid_args.padx +
                       self.x)
        end
    end

    if vertical == "C" then
        if child.grid then child:grid("soft") end
        child.centery = self.y + (self:get_cell_height(1, row - 1) +
                                  self:get_cell_height(row, rowspan) / 2)
    else
        resized = true
        if N == nil and S ~= nil then
            child.bottom = (self:get_cell_height(1, row) -
                       _grid_args.pady +
                       self.y)
        else
            if S ~= nil and N ~= nil then
                -- stretch vertically
                child.h = self:get_cell_height(row, rowspan)
            end
            child.y = (self:get_cell_height(1, row - 1) +
                       _grid_args.pady +
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
        size = size + (self._cols_w[i] or 2)
    end
    return size
end

function Frame:get_cell_height(row, rowspan)
    local size = 0
    for i = row, row + rowspan - 1 do
        size = size + (self._rows_h[i] or 2)
    end
    return size
end

function Frame:row_configure(row, weight)
    self.row_weight[row] = weight
end

function Frame:col_configure(col, weight)
    self.col_weight[col] = weight
end

function Frame:update(dt)
    beholder.trigger('UPDATE', self, dt)
end

function Frame:draw(z)
    if self.bg_color ~= nil then
        love.graphics.setColor(self.bg_color)
        love.graphics.rectangle("fill", self.x, self.y, self.w, self.h)
    end
    -- print("'DRAW' trigger", self, self.z)
    beholder.trigger('DRAW', self, self.z)
end

function Frame:keypressed(key, scancode, isrepeat)
    beholder.trigger('KEYPRESSED', self, key, scancode, isrepeat)
end

function Frame:keyreleased(key, scancode, isrepeat)
    beholder.trigger('KEYRELEASED', self, key, scancode, isrepeat)
end

function Frame:mousemoved(x, y, dx, dy, istouch)
    beholder.trigger('MOUSEMOVED', self, x, y, dx, dy, istouch)
end

function Frame:wheelmoved(x, y)
    beholder.trigger('WHEELMOVED', self, x, y)
end

function Frame:mousepressed(x, y, button, istouch)
    beholder.trigger('MOUSEPRESSED', self, x, y, button, istouch)
end

function Frame:mousereleased(x, y, button, istouch)
    beholder.trigger('MOUSERELEASED', self, x, y, button, istouch)
end

return Frame
