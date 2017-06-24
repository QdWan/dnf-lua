local templates = require("templates")
local feature_templates = templates.data.FeatureEntity

local function new(class, template)
    local self = setmetatable({}, class)
    self.data = setmetatable({}, assert(feature_templates[template]))
    return self
end

local FeatureEntity = {pos = 0, var = 0}
FeatureEntity.__index = FeatureEntity
setmetatable(FeatureEntity, {
    __call = new
})

return FeatureEntity
