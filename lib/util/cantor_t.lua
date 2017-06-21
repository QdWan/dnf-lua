local cantor = require("util.cantor")

local function cantor_t(t)
    --[[Get a unique index for a 2d or 3d coordinate using Cantor pairing.

    Args:
        x (number): first coordinate, X axis
        y (number): second coordinate, Y axis
        z (number): second coordinate, Z axis (optional)
    ]]--
    local v
    local i = 1
    for i = 1, #t - 1 do
        v = cantor(v or t[1], t[i + 1])

    end
    return v or t[1]
end

return cantor_t
