local util = require("util")
local extend = util.extend_array

local OUTFILE = "log.log"
local VERBOSITY_LEVEL = 1
local TERMINAL_AT_END = false
local REPLACE_PRINT = true

local Log = class("Log")

function Log:init(param)
    --[[

        Args:
            t (table): table containing the optional parameters below.

            t.outfile (string): name of the log file to be written.
            t.verbosity_level (number): if 0 nothing will printed to the
                terminal; if 1 then only warnings will printed; if 2 then both
                informations (log:info) and warnings (log:warn) will be
                printed.
            t.terminal_at_end (boolean): if true then before the program ends
                the whole log of the session will be printed to the terminal
                as well as saved the log file.
            t.replace_print (boolean): if true then the default print
                function will be replaced by log:info
    ]]--
    param = param or {}
    self.outfile = param.outfile or OUTFILE
    self.outfile_mode = param.outfile_mode or "w"
    self.verbosity_level = param.verbosity_level or VERBOSITY_LEVEL
    self.terminal_at_end = param.terminal_at_end or TERMINAL_AT_END
    self.history = string.format("LOG START: %s", os.date())
    self.old_print = print
    self:replace_print(param.replace_print or REPLACE_PRINT)
end

function Log:replace_print(replace_print)
    self._replace_print = replace_print == nil and self._replace_print or
                          replace_print
    if self._replace_print then
        print = function(...) self:info(...) end
    else
        print = self.old_print
    end
end

function Log:write()
    love.filesystem.write(self.outfile, self.history .. "\n")
    --[[

    if self.terminal_at_end then
        self.old_print(output)
    end
    ]]--
    self.old_print("LOG: Done writing log to ", self.outfile)
end

function Log:log(feedback, msg, t)
    local type, tostring = type, tostring
    for i, v in ipairs(t) do
        t[i] = type(v) == 'string' and v or tostring(v)
    end
    local input = table.concat(t, ", ")
    local final = msg .. input
    self.history = self.history .. "\n" .. final

    if feedback then self.old_print(final) end
end

function Log:info(...)
    local args = {...}
    self:log(self.verbosity_level >= 2 , "INFO: ", args)
end


function Log:warn(...)
    local args = {...}
    self:log(self.verbosity_level >= 1, "WARNING: ", args)
end

--[[
log = Log{replace_print = true}
print("entry 1")
print("entry 2", 3, 4)
log:write()
]]--

return Log
