local Set = {}
Set.__index = Set

setmetatable(
    Set,
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

function Set:initialize(t)
    if t ~= nil then
        for _, l in ipairs(t) do
            self[l] = true
        end
    end
    return self
end

function Set:union(other)
    local res = Set()
    for k in pairs(self) do
        res[k] = true
    end
    for k in pairs(other) do
        res[k] = true
    end
    return res
end

function Set:intersection(other)
    local res = Set()
    for k in pairs(self) do
        res[k] = other[k]
    end
    return res
end

function Set:__tostring()
    local s = "{"
    local sep = ""
    for e in pairs(self) do
        s = s .. sep .. e
        sep = ", "
    end
    return s .. "}"
end

return Set
