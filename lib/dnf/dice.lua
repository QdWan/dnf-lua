local table_sum = require("util.table_sum")

local dice = {}

local function parse_roll_string(str, verbose)
    local verbose = verbose or false
    -- rolls, faces, modifier
    local pattern = "(%d*)d(%d+)%+?(%-?%d*)"
    local rolls, faces, modifier = string.match(str:lower(), pattern)
    return tonumber(rolls) or 1, tonumber(faces), tonumber(modifier) or 0
end

local DEFAULTS = {
    rolls = 1,
    faces=20,
    modifier=0,
    verbose=false
}

local function roll(t, verbose)
    local rolls, faces, modifier, mode
    if type(t) == "string" then
        rolls, faces, modifier = parse_roll_string(t, verbose)
    elseif t then
        rolls = t.rolls
        faces = t.faces
        modifier = t.modifier
        mode =  t.mode
    end
    rolls = rolls or DEFAULTS.rolls
    faces = faces or DEFAULTS.faces
    modifier = modifier or DEFAULTS.modifier
    mode = mode or DEFAULTS.mode
    local verbose = verbose or DEFAULTS.verbose

    local random = math.random

    local roll_list = {}
    for i = 1, rolls do
        local roll = random(1, faces) + modifier

        roll_list[#roll_list + 1] = roll
        if verbose then
            io.write('Rolling d' .. faces)
            if modifier ~= 0 then
                io.write('+' .. modifier)
            end
            io.write(': ' .. roll)
            print()
        end
    end
    if verbose then
        io.write(rolls)
        io.write('d' .. faces)
        if modifier ~= 0 then
            io.write('+' .. modifier)
        end
        io.write(' = ')
    end

    local result, min_roll
    if mode == nil then
        -- standard mode
        result = table_sum(roll_list)
        if verbose then
            io.write(result)
            print()
        end
    elseif mode == 'discard_lowest' then
        min_roll = math.min(unpack(roll_list))
        result = table_sum(roll_list) - min_roll
        if verbose then
            io.write(string.format("%d (discarding %d)", result, min_roll))
            print()
        end
    end
    return result
end

dice.roll = roll
dice.parse_roll_string = parse_roll_string

return dice
