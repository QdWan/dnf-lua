-- properties.lua
-- based on a recipe from:
-- https://love2d.org/forums/viewtopic.php?f=5&t=81513&p=208797#p208777

local Properties = {}

function Properties:__index(k)
    local getter = self.class.__instanceDict["getter_" .. k]
    if getter ~= nil then
        return getter(self)
    end
end

function Properties:__newindex(k, v)
    local setter = self["setter_" .. k]
    if setter ~= nil then
        setter(self, v)
    else
        rawset(self, k, v)
    end
end

return Properties
