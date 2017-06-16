local util = require("util")
local ODict = require("collections.odict")


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

local COMMANDS = {
    "KEYPRESSED", "KEYRELEASED", "MOUSERELEASED", "MOUSEPRESSED",
    "WHEELMOVED", "HOVERED", "UNHOVERED", "TEXTINPUT"
}

local style = {}

local function call_bound_commands(args, ...)
    local iterables = {...}
    if #iterables == 0 then
        return
    end
    for _, it in ipairs(iterables) do
        if #it ~= 0 then
            for _, cmd in ipairs(it) do
                cmd(args)
            end
            break
        end
    end
end


local Widget = class("Widget", Rect)

function Widget:init(args)
    self.default_style = {}
    self.active = true
    self.visible = true
    self.states = self.states or {}
    self:get_args(args)
    self.commands = self.commands or {}
    self.state = "normal" or self.state
    self:preload()
    self:_set_rect()
    self._children = ODict()
    if self.parent and self.parent._register_widget then
        self.parent:_register_widget(self)
    end
    self:_set_observers()
end

function Widget:copy_style()
    return {
        font_size = self.font_size,
        color = util.copy_depth(self.color, 1),
        font_name = self.font_name,
        hover = self.hover,
        font_obj = self.font_obj
    }
end

function Widget:get_default_style()
    return style
end

function Widget:get_args(t)
    local default_style = self:get_default_style()

    local args

    local style, new_style
    if default_style ~= nil then
        style = util.copy_depth(default_style, 2)
        args = util.merge_tables(style, t)
    else
        args = t
    end
    local commands = {}
    args.commands = args.commands or {}
    for _, cmd in ipairs(COMMANDS) do
        commands[cmd] = args.commands[cmd] or {}
    end
    args.commands = commands
    args = util.merge_tables(GRID_DEFAULTS, args)

    for k, v in pairs(args) do
        self[k] = v
    end
end

function Widget:preload()
    --[[
    This might be required to provide a 'size' parameter.
    ]]--
end


function Widget:_set_rect()
    if self.rect == nil then
        Rect.init(self, self.x or 0, self.y or 0,
                        self.w or 1, self.h or 1)
    else
        Rect.init(self,
            self.rect.x or self.rect[1],
            self.rect.y or self.rect[2],
            self.rect.w or self.rect[3],
            self.rect.h or self.rect[4])
    end
    self._start_size = {w=self.w, h=self.h}
    self.default_rect = self:copy()
end

function Widget:_register_widget(child)
    self._children:insert(child)
    child.z = self.z
end

function Widget:_unregister_widget(child)
    self._children:remove(child)
end

function Widget:remove_children()
    local children = self._children
    for widget, _, i in children:sorted() do
        assert(widget.destroy,
               "no destroy method on widget: " .. widget.class.name)
        widget:destroy()
        children:remove(widget)
    end
end

function Widget:destroy()
    self:remove_observers()
    self:remove_children()
    if self.parent and self.parent._unregister_widget then
        self.parent:_unregister_widget(self)
    end
    brutal_destroyer(self)
end

function Widget:remove_observers()
    if self.observers then
        for i, observer in pairs(self.observers) do
            observer:destroy()
            self.observers[i] = nil
        end
    end
end

function Widget:_set_observers()
    local parent = self.parent

    self.observers = {}

    self.observers["UPDATE"] = events:observe(
        {'UPDATE', parent},
        function(dt)
            if self.visible then
                return self:update(dt)
            end
        end)

    self.observers["DRAW"] = events:observe(
        {'DRAW', parent, self.z},
        function()
            if self.visible then
                return self:draw(self.z)
            end
        end)

    self.observers["KEYPRESSED"] = events:observe(
        {'KEYPRESSED', parent},
        function(key, scancode, isrepeat)
            if not self.disabled then
                return self:keypressed(key, scancode, isrepeat)
            end
        end)

    self.observers["KEYRELEASED"] = events:observe(
        {'KEYRELEASED', parent},
        function(key, scancode)
            if not self.disabled then
                return self:keyreleased(key, scancode)
            end
        end)

    self.observers["MOUSEMOVED"] = events:observe(
        {'MOUSEMOVED', parent},
        function(x, y, dx, dy, istouch)
            if not self.disabled then
                return self:mousemoved(x, y, dx, dy, istouch)
            end
        end)

    self.observers["WHEELMOVED"] = events:observe(
        {'WHEELMOVED', parent},
        function(x, y, dx, dy)
            if not self.disabled and self:collidepoint(x, y) then
                return self:wheelmoved(x, y, dx, dy)
            end
        end)

    self.observers["MOUSEPRESSED"] = events:observe(
        {'MOUSEPRESSED', parent},
        function(x, y, button, istouch)
            if not self.disabled and self:collidepoint(x, y) then
                return self:mousepressed(x, y, button, istouch)
            end
        end)

    self.observers["MOUSERELEASED"] = events:observe(
        {'MOUSERELEASED', parent},
        function(x, y, button, istouch)
            if not self.disabled and self:collidepoint(x, y) then
                return self:mousereleased(x, y, button, istouch)
            end
        end)

    self.observers["TEXTINPUT"] = events:observe(
        {'TEXTINPUT', parent},
        function(t)
            return self:textinput(t)
        end)

    self.observers["UPDATE"] = events:observe(
        {"UPDATE", parent},
        function(dt)
            return self:update(dt)
        end
    )
end

function Widget:bind(tag, cmd)
    local commands = self.commands
    if type(tag) == "table" and type(cmd) == "function" then
        for _, str in ipairs(tag) do
            commands[str] = commands[str] or {}
            local new_cmds
            if type(cmd) ~= "table" then
                new_cmds = {cmd}
            else
                new_cmds = cmd
            end
            for _, new_cmd in ipairs(new_cmds) do
                table.insert(commands[str], new_cmd)
            end
        end
    else
        commands[tag] = commands[tag] or {}
        table.insert(commands[tag], cmd)
    end
end

function Widget:update(dt) end

function Widget:draw() end

function Widget:textinput(t)
    local std = "TEXTINPUT"
    local args = {widget=self, t=t}
    local commands = self.commands

    call_bound_commands(args, commands[std])
end

function Widget:keypressed(key, scancode, isrepeat)
    local std = "KEYPRESSED"
    local str = std .. "." .. key
    local args = {widget=self, key=key, scancode=scancode, isrepeat=isrepeat}
    local commands = self.commands

    call_bound_commands(args, commands[str], commands[std])
end

function Widget:keyreleased(key, scancode)
    local std = "KEYRELEASED"
    local str = std .. "." .. key
    local args = {widget=self, key=key, scancode=scancode}
    local commands = self.commands

    call_bound_commands(args, commands[str], commands[std])
end

function Widget:mousemoved(x, y, dx, dy, istouch)
    local previous_state = self.state
    if self:collidepoint(x, y) then
        self:on_hover()
    else
        self:on_unhover()
    end
end

function Widget:on_hover()
    self.state = "hover"

    local std = "HOVERED"
    local commands = self.commands
    local args = {widget=self}

    call_bound_commands(args, commands[std])
end

function Widget:on_unhover()
    self.state = "normal"

    local std = "UNHOVERED"
    local commands = self.commands
    local args = {widget=self}

    call_bound_commands(args, commands[std])
end

function Widget:mousepressed(x, y, button, istouch) end

function Widget:mousereleased(x, y, button, istouch)
    local std = "MOUSERELEASED"
    local str = std .. "." .. button
    local args = {widget=self, x=x, y=y, button=button, istouch=istouch}
    local commands = self.commands

    call_bound_commands(args, commands[str], commands[std])
end

function Widget:wheelmoved(x, y, dx, dy)
    local str = "WHEELMOVED"
    local args = {widget=self, x=x, y=y, dx=dx, dy=dy}
    local commands = self.commands

    call_bound_commands(args, commands[str])
end

function Widget:quit() end

function Widget:_ungrid()
    self.w = self._start_size.w
    self.h = self._start_size.h
    self.size = self.default_rect.size
end

return Widget
