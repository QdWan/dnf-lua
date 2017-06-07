local minclass = {}


local function class_tostring(self)
    return "class " .. self.name
end

local function new(class)
    return setmetatable({class = class}, class)
end

local function call(class, ...)
    local self = setmetatable({class = class}, class)
    if self.init then self:init(...) end
    return self
    -- self.__address = tostring(self)  -- for debug, slow down class creation
end

local Object

local function class(name, super)
    -- Create a blank metatable unless there's a super.
    -- If ther's a super class, use it as metatable
    local mt
    if super == false then
        mt = {__tostring = class_tostring}
    elseif super == nil then
        super = Object
    end

    local class = super and new(super) or setmetatable({}, mt)
    mt = mt or getmetatable(class)
    mt.__call = call
    class.__tostring = class_tostring
    class.name = name
    class.super = super
    class.__index = class
    class.__metatable = class
    return class
end
minclass.class = class

Object = class("Object", false)

function Object:set_class_defaults(table)
    for k, v in pairs(table) do
        self[k] = v
    end
    return self
end

return class
