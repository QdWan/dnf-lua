local class = require("minclass")

local Odict = require("collections.odict")

local Observer


local EveM = class("EveM")

function EveM:init()
    self.callbacks = {}
    self.hash_values = {_mode = "v"}
    self.i = 0
    self.stop_propagation = false
    self.propagate = {_mode = "k"}
end

function EveM:hash_value(key)
    local v = self.hash_values[key]
    if v == nil then
        self.i = self.i + 1
        v = self.i
        self.hash_values[key] = v
    end
    return v
end

function EveM:hash_table(keys)
    for i, key in ipairs(keys) do
        keys[i] = tostring(self:hash_value(key))
    end
    return table.concat(keys, ";")
end

function EveM:call(callbacks, ...)
    self.propagate[callbacks] = true
    for k, callback, i in callbacks:sorted() do
        callback(...)
        if self.propagate[callbacks] == false then
            return
        end
    end
end

function EveM:observe(keys, callback)
    local key = self:hash_table(keys)
    local group_callbacks = self.callbacks[key]
    if group_callbacks == nil then
        self.callbacks[key] = self.callbacks[key] or Odict()
        group_callbacks = self.callbacks[key]
    end
    group_callbacks:insert(callback, callback)
    -- print("EveM.observe:", key, self.callbacks[key])
    return Observer(self, callback, key)
end

function EveM:trigger(keys, ...)
    local key = self:hash_table(keys)
    self.callbacks[key] = self.callbacks[key] or Odict()
    local callbacks = self.callbacks[key]
    self:call(callbacks, ...)
end



Observer = class("Observer")

function Observer:init(event, callback, key)
    self.event = event
    self.callback = callback
    self.key = key
end

function Observer:remove()
    self.event.callbacks[self.key]:remove(self.callback)
end

function Observer:stop_propagation()
    local callbacks = self.event.callbacks[self.key]
    self.event.propagate[callbacks] = false
end

return EveM
