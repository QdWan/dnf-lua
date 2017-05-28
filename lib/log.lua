local OUTFILE = "log.log"

local Log = {old_print = print}
Log.__index = Log

setmetatable(
    Log,
    {
        __call = function (class, ...)
        local self = setmetatable({}, class)
            if self.initialize then
                self:initialize(...)
            end
            return self
        end
    }
)

local function extend(table1, table2)
    for _, v in ipairs(table2) do
        table.insert(table1, v)
    end
end

function Log:initialize(param)
    param = param or {}
    self.outfile = param.outfile or OUTFILE
    self.outfile_mode = param.outfile_mode or "w"
    self.replace_print = param.replace_print or false

    self.history = {string.format("LOG START: %s", os.date())}
    if self.replace_print then
        print = function(...) self:print(...) end
    end
    self.terminal = param.terminal
    self.terminal_at_end =param.terminal_at_end
end

function Log:add(...)
    extend(self.history, {...})
end

function Log:write()
    table.insert(self.history, "\n")
    local output = table.concat(self.history, "\n")
    love.filesystem.write(self.outfile, output)
    if self.terminal_at_end then
        self.old_print(output)
    end
    self.old_print(string.format("Done writing log to %s", self.outfile))
end

function Log:print(...)
    self:info(...)
end

function Log:log(feedback, msg, ...)
    local t = {...}
    for i, v in ipairs(t) do
        t[i] = type(v) == 'string' and v or tostring(v)
    end
    local input = table.concat(t, ", ")
    self:add(msg .. input)
    if feedback or self.terminal then
        self.old_print(input)
    end
end

function Log:info(...)
    self:log(false, "INFO: ", ...)
end


function Log:warn(...)
    self:log(true, "WARNING: ", ...)
end

--[[
log = Log{replace_print = true}
print("entry 1")
print("entry 2", 3, 4)
log:write()
]]--

return Log
