--[[
References:
    sparknotes.com/math/trigonometry/graphs/section3.rhtml
]]--


local PI = math.pi
local sin = math.sin
local abs = math.abs
local max = math.max
local min = math.min

local MODULE = {}

local function LGHB(v)
    --[[LGHB - Low Good, High Bad

    Parameters:
        v (number): a number between 0 and 1

    Notes:
        '+ PI / 2' == horizontal shift
        + 1 / 2 == normalization

    Example:
        {
            [0]   = 1,
            [0.1] = 0.97552825814758,
            [0.2] = 0.90450849718747,
            [0.3] = 0.79389262614624,
            [0.4] = 0.65450849718747,
            [0.5] = 0.5,
            [0.6] = 0.34549150281253,
            [0.7] = 0.20610737385376,
            [0.8] = 0.095491502812526,
            [0.9] = 0.024471741852423,
            [1]   = 0,
        }
    ]]--
    return (sin(v * PI + PI / 2) + 1) / 2
end
MODULE.LGHB = LGHB

local function MGEB(v)
    --[[MGEB - Mid Good, Extremes Bad

    Parameters:
        v (number): a number between 0 and 1

    Notes:
        'j * PI * 2' halves the cycle
        '- PI / 2' == horizontal shift
        + 1 / 2 == normalization

    Example:
        {
            [0]   = 0,
            [0.1] = 0.095491502812526,
            [0.2] = 0.34549150281253,
            [0.3] = 0.65450849718747,
            [0.4] = 0.90450849718747,
            [0.5] = 1,
            [0.6] = 0.90450849718747,
            [0.7] = 0.65450849718747,
            [0.8] = 0.34549150281253,
            [0.9] = 0.095491502812526,
            [1]   = 0,
        }
    ]]--
    return (sin((v * PI * 2 - PI / 2)) + 1) / 2
end
MODULE.MGEB = MGEB

local function HGLB(v)
    --[[HGLB - High Good, Low Bad

    Parameters:
        v (number): a number between 0 and 1

    Notes:
        '- PI / 2' == horizontal shift
        + 1 / 2 == normalization

    Example:
        {
            [0]   = 0,
            [0.1] = 0.024471741852423,
            [0.2] = 0.095491502812526,
            [0.3] = 0.20610737385376,
            [0.4] = 0.34549150281253,
            [0.5] = 0.5,
            [0.6] = 0.65450849718747,
            [0.7] = 0.79389262614624,
            [0.8] = 0.90450849718747,
            [0.9] = 0.97552825814758,
            [1]   = 1,
        }
    ]]--
    return (sin((v * PI - PI / 2)) + 1) / 2
end
MODULE.HGLB = HGLB


local function SGAB(v, c, min_v, max_d)
    --[[SGAB - Specific Good, Away Bad

    Parameters:
        v (number): any number
        c (number): the desired center
        min_v (number): if 0 behaves like other similar functions; if -1 it
            allows the value to go further below 0, down to -1, reflecting
            greater distances from the center.

    Notes:
        'j * PI * 2' halves the cycle
        '- PI / 2' == horizontal shift
        + 1 / 2 == normalization

    Example:
        for i = 0, 20 do
            SGAB(i, 4, -1, 10)
        end
        {
             [0] =  0.309016994375,
             [1] =  0.587785252292,
             [2] =  0.809016994375,
             [3] =  0.951056516295,
             [4] =  1.000000000000,  -- maximum at specified center
             [5] =  0.951056516295,
             [6] =  0.809016994375,
             [7] =  0.587785252292,
             [8] =  0.309016994375,
             [9] =  0.000000000000,
            [10] = -0.309016994375,
            [11] = -0.587785252292,
            [12] = -0.809016994375,
            [13] = -0.951056516295,
            [14] = -1.000000000000,  -- after distance 10 it goes minimal
            [15] = -1.000000000000,
            [16] = -1.000000000000,
            [17] = -1.000000000000,
            [18] = -1.000000000000,
            [19] = -1.000000000000,
            [20] = -1.000000000000
        }
    ]]--
    min_v = min_v or -1
    local f = min(max(abs(v - c), -max_d), max_d) / max_d
    local v = (sin((f * PI + PI / 2)))
    if min_v == -1 then
        return v
    else
        return (v + 1) / 2
    end
end
MODULE.SGAB = SGAB

local function decide(args)
    --[[

    Parameters:
        args(table): even size table containing pais of value and weight
            arguments (e.g. {v1, w1, v2, w2 ... vn, wn}).

    Example:
        -- node.meta.height_value = 0.2
        local height_contrib = LGHB(node.meta.height_value)
        local height_weight = 0.8

        -- node.meta.heat_value = 0.5
        local heat_contrib = MGEB(node.meta.heat_value)
        local heat_weight = 1

        -- node.meta.rainfall_value = 0.7
        local rainfall_contrib = HGLB(node.meta.rainfall_value)
        local rainfall_weight = 1

        -- distance_to_nearest_city = 6
        local distance_contrib = SGAB(distance_to_nearest_city,
                                      6, -1, 10)
        local distance_weight = 1

        -- forest_ratio_r4 = 0.5
        local forest_contrib = MGEB(forest_ratio_r4)
        local forest_weight = 0.8

        -- water_ratio_r1 = 0.3
        local water_r1_contrib = MGEB(water_ratio_r1)
        local water_r1_weight = 1.2

        -- water_ratio_r2 = 0.4
        local water_r2_contrib = MGEB(water_ratio_r2)
        local water_r2_weight = water_r1_weight / 2

        -- water_ratio_r4 = 0.5
        local water_r4_contrib = MGEB(water_ratio_r4)
        local water_r4_weight = water_r1_weight / 4

        decide(height_contrib, height_weight,
               heat_contrib, heat_weight,
               rainfall_contrib, rainfall_weight,
               distance_contrib, distance_weight,
               forest_contrib, forest_weight,
               water_r1_contrib, water_r1_weight,
               water_r2_contrib, water_r2_weight,
               water_r4_contrib, water_r4_weight
        )  -- 0.88740518191547
    ]]--
    local sum_v = 0
    local sum_w = 0
    for i = 1, #args, 2 do
        local value = args[i]
        local weight = args[i + 1]
        sum_v = sum_v + (value * weight)
        sum_w = sum_w + weight
    end
    return sum_v / sum_w
end
MODULE.decide = decide
MODULE.weight = decide

return MODULE
