local Rect = require("lib.rect")
local util = require("lib.util")


local GRID_DEFAULTS = {
    col = 1,
    --[[ The col number where you want the widget gridded, counting from
    one. The default value is one.
    ]]--

    colspan = 1,
    --[[ Normally a widget occupies only one cell in the grid. However, you can grab multiple cells of a row and merge them into one larger cell by setting the colspan option to the number of cells. For example, w.grid(row=1, col=2, colspan=3) would place widget w in a cell that spans cols 2, 3, and 4 of row 1.
    ]]--

    padx = 0,
    --[[ Internal x padding. This dimension is added both to the widget's
    left and right.
    ]]--

    pady = 0,
    --[[ Internal y padding. This dimension is added both to the widget's top
    and bottom.
    ]]--

    row = nil,
    --[[ The row number into which you want to insert the widget, counting
    from 1. The default is the next higher-numbered unoccupied row.
    ]]--

    rowspan = 1,
    --[[ Normally a widget occupies only one cell in the grid. You can grab
    multiple adjacent cells of a col, however, by setting the rowspan
    option to the number of cells to grab. This option can be used in
    combination with the colspan option to grab a block of cells. For example, w.grid(row=3, col=2, rowspan=4, colspan=5) would place widget w in an area formed by merging 20 cells, with row numbers 3–6 and col numbers 2–6.
    ]]--

    sticky = nil
    --[[ This option determines how to distribute any extra space within the
    cell that is not taken up by the widget at its natural size. The default value is nil.

    nil: not sticky, center the widget in the cell.
    'N', 'T': position the widget in the north (top) of the cell.
    'S', 'B': position the widget in the south (bottom) of the cell.
    'W', 'L': position the widget in the west (left) of the cell.
    'E', 'R': position the widget in the east (right) of the cell.

    Those options can be mixed, like:
    'NW', 'TL': position the widget in the northwest (top left) of the cell

    And used for stretching, like:
    'WE': stretch the widget from west (left) to east (right) of the cell

    Order is irrelevant and the field is not case sensitive ('W' == 'w')
    ]]--
}


local Widget = class("Widget", Rect)

function Widget:initialize(args)
    -- print("Widget:initialize", self)
    self.states = self.states or {}
    self._commands = self._commands or {}
    self.state = "normal"
    self:get_args(args)
    self:_cache()
    self:_set_rect()
    self._children = {}
    if self.parent and self.parent._register_widget then
        self.parent:_register_widget(self)
    end
    self:_set_observers()
end

function Widget:get_args(t)
    local default_style = self.default_style

    local style, new_style
    if default_style ~= nil then
        style = util.copy_depth(default_style, 2)
        new_style = util.merge_tables(style, t)
    else
        new_style = t
    end

    for k, v in pairs(new_style) do
        self[k] = v
    end
end

function Widget:getter_default_style() end

function Widget:_cache() end

function Widget:_set_rect()
    if self.rect ~= nil then
        Rect.initialize(self,
            self.rect.x or self.rect[1],
            self.rect.y or self.rect[2],
            self.rect.w or self.rect[3],
            self.rect.h or self.rect[4])
    else
        Rect.initialize(self, self.x or 0, self.y or 0,
                        self.w or 1, self.h or 1)
    end
    self._start_size = {w=self.w, h=self.h}
    self.default_rect = self:copy()
end

function Widget:_register_widget(child)
    util.list_insert_new(self._children, child)
    child.z = self.z
end

function Widget:_set_observers()
    local parent = self.parent

    self.observers = {}

    self.observers["UPDATE"] = beholder.observe(
        'UPDATE', parent,
        function(dt)
            return self:update(dt)
        end)

    self.observers["DRAW"] = beholder.observe(
        'DRAW', parent, self.z, function()
            return self:draw(self.z)
        end)

    self.observers["KEYPRESSED"] = beholder.observe(
        'KEYPRESSED', parent,
        function(key, scancode, isrepeat)
            return self:keypressed(key, scancode, isrepeat)
        end)

    self.observers["KEYRELEASED"] = beholder.observe(
        'KEYRELEASED', parent,
        function(key, scancode)
            return self:keyreleased(key, scancode)
        end)

    self.observers["MOUSEMOVED"] = beholder.observe(
        'MOUSEMOVED', parent,
        function(x, y, dx, dy, istouch)
            return self:mousemoved(x, y, dx, dy, istouch)
        end)

    self.observers["WHEELMOVED"] = beholder.observe(
        'WHEELMOVED', parent,
        function(x, y)
            return self:wheelmoved(x, y)
        end)

    self.observers["MOUSEPRESSED"] = beholder.observe(
        'MOUSEPRESSED', parent,
        function(x, y, button, istouch)
            return self:mousepressed(x, y, button, istouch)
        end)

    self.observers["MOUSERELEASED"] = beholder.observe(
        'MOUSERELEASED', parent,
        function(x, y, button, istouch)
            return self:mousereleased(x, y, button, istouch)
        end)
end

function Widget:grid_config(args)
    self._grid_args = util.merge_tables(GRID_DEFAULTS, args or {})
end

function Widget:bind(tag, cmd)
    self._commands[tag] = cmd
end

function Widget:update(dt) end

function Widget:draw() end

function Widget:textinput(t) end

function Widget:keypressed(key, scancode, isrepeat) end

function Widget:keyreleased(key, scancode) end

function Widget:mousemoved(x, y, dx, dy, istouch)
    if self:collidepoint(x, y) then
        self.state = "hover"
    else
        self.state = "normal"
    end
end

function Widget:mousepressed(x, y, button, istouch) end

function Widget:mousereleased(x, y, button, istouch)
    if self:collidepoint(x, y) then
        local cmd = self._commands["MOUSERELEASED." .. button]
        if cmd ~= nil then
            cmd()
        else
            print("no cmd", manager.time())
        end
    end
end

function Widget:wheelmoved(x,y) end

function Widget:quit() end

function Widget:_ungrid()
    self.w = self._start_size.w
    self.h = self._start_size.h
    self.size = self.default_rect.size
end



return Widget
