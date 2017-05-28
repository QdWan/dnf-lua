local templates = require("data.templates")

for _, group in pairs(templates) do
    local default = group["_default"]
    if default then
        for __, template in pairs(group) do
            for k, v in pairs(default) do
                template[k] = template[k] or v
            end
        end
    end
end

return templates
