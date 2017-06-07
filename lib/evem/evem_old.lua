local util = require("util")
---
local event = {
    callbacks = {},
    hash_values = {_mode = "v"},
    i = 0,
    stop_propagation = false,
    propagate = {_mode = "k"},
}

local function hash_value(self, key)
    local v = self.hash_values[key]
    if v == nil then
        self.i = self.i + 1
        v = self.i
        self.hash_values[key] = v
    end
    return v
end

local function hash_table(keys)
    for i, key in ipairs(keys) do
        keys[i] = hash_value(event, key)
    end
    return util.cantor_t(keys)
end

local function call(self, callbacks, ...)
    event.propagate[callbacks] = true
    for _, callback in pairs(callbacks) do
        callback(...)
        if event.propagate[callbacks] == false then
            return
        end
    end
end

local Observer = {}

function Observer:remove()
    table.remove(event.callbacks[self.key], index)
end

function Observer:stop_propagation()
    local callbacks = event.callbacks[self.key]
    event.propagate[callbacks] = false
end

local observer_mt = {__index = Observer}

function event.observe(keys, callback)
    local key = hash_table(keys)
    event.callbacks[key] = event.callbacks[key] or {}
    local callbacks = event.callbacks[key]
    local index = table.maxn(callbacks) + 1
    callbacks[index] = callback
    -- print("event.observe:", key, event.callbacks[key])
    return setmetatable({index = index, key = key}, observer_mt)
end

function event.trigger(keys, ...)
    local key = hash_table(keys)
    event.callbacks[key] = event.callbacks[key] or {}
    local callbacks = event.callbacks[key]
    if table.maxn(callbacks)  > 0 then call(event, callbacks, ...) end
    -- print("event.trigger:", key, event.callbacks[key])
end

return event
