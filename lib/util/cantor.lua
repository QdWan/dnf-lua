local function cantor(x, y, z)
    --[[Get a unique index for a 2d or 3d coordinate using Cantor pairing.

    Args:
        x (number): first coordinate, X axis
        y (number): second coordinate, Y axis
        z (number): second coordinate, Z axis (optional)
    ]]--
    return z and cantor(cantor(x, y), z) or 0.5 * (x + y) * ((x + y) + 1) + y
end

return cantor
