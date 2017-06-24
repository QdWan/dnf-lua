local core = require("data.core")
local round = require("util.round")
local split = require("util.split")
local has_key = require("util.has_key")
local copy_depth = require("util.copy_depth")
local table_sum = require("util.table_sum")
local choice = require("util.choice")
local index = require("util.index")
local dice = require("dnf.dice")
local namegen = require("namegen")


local creature = {}

-- available/implemented races
local races = core.races

-- available/implemented classes
local classes = core.classes

local DEFAULTS = {
    verbose=true
}

local function starting_wealth(class, verbose)
    local verbose = verbose or DEFAULTS.verbose
    local wealth_table = core["starting_wealth"]
    local fix = tonumber(wealth_table:get(class)[2])
    local var_str = wealth_table:get(class)[1]

    if verbose then
        print(string.format("Class %s, var %s, fix %d",
                            class,
                            var_str,
                            fix
        ))
    end
    local var = dice.roll(var_str, verbose)
    local wealth = var * fix
    if verbose then
        print(string.format("var %d * fix %d = wealth %d",
                            var, fix, wealth))
    end
    return wealth
end

local function aging_modifiers(age, race)
    local age_dict = core.age_dict
    local age_mod = core.age_mod

    local no_mod = {0, 0, 0, 0, 0, 0}  --  #attributes = 6

    if age_dict[race] == nil or age < age_dict[race]['mid'] then
        return no_mod
    elseif age >= age_dict[race]['ven'] then
        return age_mod['ven']
    elseif age >= age_dict[race]['old'] then
        return age_mod['old']
    else  --  age >= age_dict[race]['mid']
        return age_mod['mid']
    end
end

local function get_age(race, class)
    local age_dict = core.age_dict
    local class = class or "fighter"  --  (self_taught, avg age)

    local var = age_dict[race]['var']:get(class) or error(
        string.format([[no age data for class "%s"]], class))
    local max =  age_dict[race]['max']

    local adulthood = age_dict[race]['ini']
    local current_age_t = {rolls=var[1], faces=var[2]}
    local current_age = adulthood + dice.roll(current_age_t)

    local max_age_t = {rolls=max[1], faces=max[2]}
    local rolled_max_var = dice.roll(max_age_t)
    local max_age = age_dict[race]['ven'] + rolled_max_var

    return current_age, max_age
end

local function race_modifiers(race)
    local race_mod = core.race_mod

    local no_mod = {0, 0, 0, 0, 0, 0}  --  #attributes = 6
    return race_mod[race] or no_mod
end

local function unit_conversion(value, from, to, d)
    -- lenght in meters
    local lenght = {
        ['m']  =    1,
        ['cm'] =    0.01,
        ['mm'] =    0.001,
        ['km'] = 1000,
        ['in'] =    0.0254,
        ['ft'] =    0.3048,
        ['yd'] =    0.9144,
        ['mi'] = 1609.34
    }
    if lenght[from] ~= nil then
        to = to or 'm'
        d = d or 2
        return round(value * lenght[from] / lenght[to], 2)
    end

    -- lenght in kilograms
    local weight = {
        ['g']  =  0.001,
        ['kg'] = 1,
        ['mg'] = 1e-6,
        ['oz'] = 0.0283495,
        ['lb'] = 0.453592
    }
    if weight[from] ~= nil then
        to = to or 'kg'
        return round(value * weight[from] / weight[to], 2)
    end

    error("invalid unit:", from)
end


local function height_weight(race, gender, modifiers)
    local modifiers = modifiers or {0, 0, 0, 0, 0, 0}

    local hw_dict = core.hw_dict[race][gender]

    local splitted = split(hw_dict[1], "'")
    local h_feets, h_inches = splitted[1], splitted[2]
    print("rolls", hw_dict[3][1], "faces", hw_dict[3][2])
    local roll_result = dice.roll({
        rolls=hw_dict[3][1],
        faces=hw_dict[3][2]}) +
        (modifiers[1] + modifiers[3]) / 2  -- str, con modifiers
    local height_inches = tonumber(h_feets) * 12 + tonumber(h_inches) + roll_result
    local weight = (hw_dict[2] +
              (roll_result * hw_dict[4]))
    local height_feet = round(height_inches / 12, 2)
    return height_feet, weight
end

local function get_modifier(v)
    return math.floor(v / 2) - 5
end

local function roll_attributes(verbose)
    --[[
    If the  scores are too low they are rerolled.
    They are considered too low if the sum of their modifiers (before
    racial adjustments) is 1 or lower, or if the highest score is 14 or
    lower.
    ]]--
    local max, min, unpack = math.max, math.min, unpack
    local verbose = verbose or DEFAULTS.verbose
    local table_sum = table_sum

    local rolls = 0
    local attributes = {0, 0, 0, 0, 0, 0}
    local attribute_modifiers = {0, 0, 0, 0, 0, 0}

    local v

    repeat
        rolls = rolls + 1

        if verbose then
            print(string.rep("=", 23), "\n# Roll number", rolls)
        end

        --[[
        Each of the character's six ability scores is determined by rolling
        four six-sided dice, ignoring the lowest die roll, and totaling the
        other three.
        ]]--
        for i = 1, 6 do
            v = dice.roll{rolls=4, faces=6, mode='discard_lowest'}
            attributes[i] = v
            attribute_modifiers[i] = get_modifier(v)
        end

        if verbose then
            print(inspect(attributes), string.format(
                "min %d, max %d, avg %d",
                min(unpack(attributes)),
                max(unpack(attributes)),
                table_sum(attributes) / #attributes
            ))
            print(inspect(attribute_modifiers), string.format(
                "min %d, max %d, avg %d, sum %d",
                min(unpack(attribute_modifiers)),
                max(unpack(attribute_modifiers)),
                table_sum(attribute_modifiers) / #attribute_modifiers,
                table_sum(attribute_modifiers)
            ))
        end
    until table_sum(attribute_modifiers) > 0 and
          max(unpack(attributes)) > 13


    return attributes
end

local Creature

local function has_character_race(t)
    local race = t["race"]
    return race and has_key(races, race) or false
end

local change_race, change_class, change_gender, change_height_weight,
      change_alignment, change_name, change_age, set_hit_dice, set_hp_total,
      set_unarmed_atk

local function class_alignments(class)
    return core.alignments:get(class)
end

local function create_as_character(t)
    t = t or {}
    local creature = Creature(t)

    creature.creation_mode = "character"
    creature.level = 1
    creature.size = "medium"
    creature.size_modifier = core.size_modifier[creature.size]
    creature.melee = {}
    creature._base_att = roll_attributes()

    change_race(creature, t.race)
    change_class(creature, t.class)

    -- creature.feats =
    -- creature.skills =

    -- below functions are called either by change_race or change_class
    local _
    -- set_hit_dice(creature)
    _ = t.gender and change_gender(creature, t.gender)
    -- change_height_weight(creature) --  called by change_race
    _ = t.alignment and change_alignment(creature, t.alignment)
    _ = t.name and change_name(creature, t.name)
    -- change_age(creature) --  called by change_race

    -- set_hp_total(creature)
    -- set_unarmed_atk(creature)

    -- creature.death_func =
    return creature
end

function change_race(creature, race)
    if race == nil then
        creature.race = choice(races)
    elseif type(race) == "number" then
        local index = index(races, creature.race)
        index = ((index + race - 1) % #races) + 1
        creature.race = races[index]
    else
        creature.race = race
    end
    creature.race_modifiers = race_modifiers(creature.race)
    -- required updates
    change_gender(creature)
    change_age(creature)
    change_name(creature)
    change_height_weight(creature)
end

function change_class(creature, class)
    --[[Change the class of the creature.

    Args:
        creature(Creature): instance of a creature;
        class(string): name of the class. If none is passed, a random
            class is chosen.
    ]]--

    -- creature._current_class stores latest class, used for specific hit dice
    local current_class

    if class == nil then
        current_class = choice(classes)
        creature.classes = {[current_class] = 1}
    elseif type(class) == "number" then
        current_class = choice(creature.classes)
        local index = index(classes, current_class)
        index = ((index + class - 1) % #classes) + 1
        current_class = classes[index]
        creature.classes = {[current_class] = 1}
    else
        creature.classes = {[class] = 1}
        current_class = class
    end
    creature._current_class = current_class
    -- required updates
    change_alignment(creature, creature.alignment and 0 or nil)
    set_hit_dice(creature)
    set_hp_total(creature)
    set_unarmed_atk(creature)
end

function change_gender(creature, gender)
    --[[Change the gender of the creature.

    Args:
        creature(Creature): instance of a creature;
        gender(string): name of the gender. If none is passed, a random
            gender is chosen.
    ]]--
    local previous_gender = creature.gender
    if creature.race == "changeling" then
        creature.race = "female"
    elseif gender == nil then
        creature.gender = choice(core.genders)
    elseif type(gender) == "number" then
        local index = index(core.genders, creature.gender)
        index = ((index + gender - 1) % #core.genders) + 1
        creature.gender = core.genders[index]
    else
        creature.gender = gender
    end
    if previous_gender ~= gender then
        change_name(creature)
        change_height_weight(creature)
    end
end

function change_height_weight(creature)
    local race_mod = race_modifiers(creature.race)
    local h, w = height_weight(creature.race, creature.gender, race_mod)
    creature.height = unit_conversion(h, 'ft')
    creature.weight = unit_conversion(w, 'lb')
end

function change_alignment(creature, alignment)
    local alignments = class_alignments(choice(creature.classes))
    -- print("alignments", inspect(alignments))
    if alignment == nil then
        local class = choice(creature.classes)
        creature.alignment = choice(alignments)
    elseif type(alignment) == "number" then
        local index = index(alignments, creature.alignment) or 1
        index = ((index + alignment - 1) % #alignments) + 1
        creature.alignment = alignments[index]
    else
        creature.alignment = alignment
    end
    return creature.alignment
end

function change_name(creature)
    local race = creature.race
    if race:find("half%-") then
        if math.random(100) > 50 then
            race = "human"
        else
            race = string.gsub(race, "half%-", "")
            print("change_name race", creature.race, race)
        end
    end
    local generator = race .. " " .. creature.gender
    creature.name = namegen.generate(generator)
end

function change_age(creature, age)
    local race = creature.race
    if age == nil then
        local class = (creature.classes and choice(creature.classes)
                       or nil)
        creature.age, creature.max_age = get_age(race, class)
    else
        -- unnatural aging, etc.
        error("not implemented")
    end
    creature.age_modifiers = aging_modifiers(creature.age, race)
end

function set_hit_dice(creature)
    creature.hit_dice = core.hit_dice:get(creature._current_class)
end

local function roll_hp(creature)
    local hp_history = creature.hp_history

    local function new_roll(level)
        local faces = creature.hit_dice
        local att_mod = get_modifier(creature._base_att[3])-- constitution
        local tough_mod = 0   -- toughness
        local result
        if creature.level == 1 then
            result = faces + att_mod + tough_mod
        else
            result = dice.roll({
                faces=faces,
                modifier=att_mod + tough_mod
            }, true)
        end
        return {
            faces = faces,
            att_mod = att_mod,
            tough_mod = tough_mod,
            result = result
        }
    end
    for i = 1, creature.level do
        hp_history[i] = hp_history[i] or new_roll(i)
    end

end

function set_hp_total(creature)
    creature.hp_history = creature.hp_history or {}
    roll_hp(creature)

    local hp_history = creature.hp_history
    local hp_total = 0

    for i = 1, creature.level do
        hp_total = hp_total + hp_history[i].result
    end
    creature.hp_total = hp_total
end

local function get_bab(creature)
    -- Base Attack Bonus (BAB).
    local bab = {}
    for class, class_level in pairs(creature.classes) do
        local bab_table = core.bab:get(class)
        local class_bab = bab_table[class_level]
        -- print("class", class, "class_bab", inspect(class_bab))
        for i = 1, #class_bab do
            bab[i] = (bab[i] or 0) + class_bab[i]
        end
    end
    return bab
end

local function set_atk(creature, atk)
    local attacks = {
        ['melee_desc'] =  {},
        ['melee'] =  {},
        ['melee_dmg'] =  {},
        ['melee_crit'] =  {},
        ['melee_crit_dmg'] =  {},
        ['melee_esp'] =  {}
    }

    local base_atk = copy_depth(atk, 2)
    print("base_atk", inspect(base_atk))
    base_atk.melee = base_atk.melee or 0

    local bab = get_bab(creature)
    local melee_desc = attacks['melee_desc']
    local melee = attacks['melee']
    local melee_dmg = attacks['melee_dmg']
    local melee_crit = attacks['melee_crit']
    local melee_crit_dmg = attacks['melee_crit_dmg']
    local melee_esp = attacks['melee_esp']
    for i = 1, #bab do
        print()
        assert(base_atk['melee_dmg'])
        local rolls, faces, modifier = dice.parse_roll_string(
            base_atk['melee_dmg'])

        modifier = modifier + get_modifier(creature._base_att[1])

        melee_dmg[#melee_dmg + 1] = {faces=faces, modifier=modifier,
                                     rolls=rolls}
        melee[#melee + 1] = (base_atk['melee'] +
                             get_modifier(creature._base_att[1] +
                                          creature.size_modifier)
                             )
        melee_desc[#melee_desc + 1] = base_atk['melee_desc']
        melee_crit[#melee_crit + 1] = base_atk['melee_crit']
        melee_crit_dmg[#melee_crit_dmg + 1] = base_atk['melee_crit_dmg']
        melee_esp[#melee_esp + 1] = base_atk['melee_esp']
    end

    creature.melee['main'] = attacks
end

function set_unarmed_atk(creature)
    local atk
    if not creature.classes["monk"] then
        atk = {
            ['melee_dmg']      = "1d3",
            ['melee_desc']     = "Unarmed strike",
            ['melee_crit_dmg'] = 2,
            ["melee_esp"]      = "nonlethal",
        }
    else
        atk = {
            ['melee_dmg']      = core.monk_unarmed[creature.level][2],
            ['melee_desc']     = "Imp. Unarmed strike",
            ['melee_crit_dmg'] = 2,
        }
    end
    assert(atk.melee_dmg)
    set_atk(creature, atk)

end


local function create_from_beastiary(t)
    local creature = Creature(t)
    creature.creation_mode = "beastiary"
    return creature
end

local function create(t)
    return has_character_race(t) and create_as_character(t)
           or create_from_beastiary(t)
end

Creature = class("Creature")

function Creature:init(t) end

function Creature:__tostring()
    return inspect({
        creation_mode = self.creation_mode,
        _base_att = self._base_att,
        race = self.race,
        classes = self.classes,
        gender = self.gender,
        height = self.height,
        weight = self.weight,
        alignment = self.alignment,
        name = self.name,
        age_modifiers = self.age_modifiers,
        age = self.age,
        max_age = self.max_age,
        hp_total = self.hp_total,
        hp_history = self.hp_history,
        melee = self.melee
    })
end


creature.create = create
creature.create_as_character = create_as_character
creature.create_from_beastiary = create_from_beastiary
creature.height_weight = height_weight
creature.roll_attributes = roll_attributes
creature.races = races
creature.classes = classes
creature.change_name = change_name
creature.change_gender = change_gender
creature.change_race = change_race
creature.change_class = change_class
creature.change_alignment = change_alignment
creature.get_modifier = get_modifier

return creature
