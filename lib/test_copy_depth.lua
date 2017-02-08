local function copy_depth(orig, depth)
    local depth = depth or 0
    local copy = {}
    for k, v in pairs(orig) do
        if depth > 0 and type(v) == 'table' then
            print("recursion for key", k)
            copy[k] = copy_depth(v, depth - 1)
        else
            copy[k] = v
        end
    end
    return copy
end

local style = {
    font_size = 16,
    states = {
        normal = {
            color = {255, 255, 255, 255}
        },
        hover = {
            color = {255, 255, 0, 255}
        }
    }
}

local style2 = {
    font_size = 16,
    states = {
        normal = {
            color = {255, 255, 255, 255}
        }
}

local copy = copy_depth(style, 2)
local inspect = require("inspect")
print(inspect(copy))

