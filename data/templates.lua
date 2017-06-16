local templates = {}

local COLORS = require("data.colors")
local effects = {} -- TODO

templates.TileEntity = {
    ["_default"] = {
        ["_folder"] = "tiles",
        ["block_mov"] = false,
        ["block_sight"] = false,
        ["image"] = "ascii"
    },
    ["shadow"] = {
        ["image"] = "shadow",
    },
    ["floor"] = {
        ["id"] = string.byte("."),
        ["color"] = {129, 106, 86},
        ["_rnd_gen_cost"] = 64,
        ["image"] = "floor_cobble_blood",
        ["receive_shadow"] = "shadow"
    },
    ["wall"] = {
        ["id"] = string.byte("#"),
        ["color"] = {161, 161, 161},
        ["_rnd_gen_cost"] = 8,
        ["block_mov"] = true,
        ["block_sight"] = true,
        ["image"] = "wall_brick_dark_1",
    },
    ["hall"] = {
        ["id"] = string.byte("/"),
        ["color"] = {129, 106, 86},
        ["_rnd_gen_cost"] = 1,
    },
    ["water"] = {
        ["id"] = string.byte("="),
        ["color"] = COLORS["blue"]
    },
    ["land"] = {
        ["id"] = string.byte("."),
        ["color"] = COLORS["darker_green"]
    },


    ["arctic_deep_water"] = {
        ["id"] = string.byte("¬"),
        ["color"] = COLORS["dark_sky"],
        ["image"] = "deep_water",
        ["tiling"] = "8bit",
        ["compare_function"] = "same_template",
    },
    ["arctic_shallow_water"] = {
        ["id"] = string.byte("~"),
        ["color"] = COLORS["sky"],
        ["image"] = "arctic_shallow_water",
        ["tiling"] = "8bit",
        ["compare_function"] = "is_water",
    },
    ["arctic coast"] = {
        ["id"] = string.byte("c"),
        ["color"] = {248, 243, 223}
        -- COLORS["lightest_amber"]  -- (255, 255, 255)
    },
    ["arctic mountain"] = {
        ["id"] = string.byte("M"),
        ["color"] = {245, 245, 245}  -- (255, 255, 255)
    },
    ["arctic hill"] = {
        ["id"] = string.byte("h"),
        ["color"] = {245, 245, 245}  -- (255, 255, 255)
    },
    ["arctic land"] = {
        ["id"] = string.byte("."),
        ["color"] = {248, 248, 255},  -- (255, 255, 255)
        ["image"] = "arctic_land",
        ["tiling"] = "8bit",
        ["compare_function"] = "same_template",
    },

    ["deep_water"] = {
        ["id"] = string.byte("¬"),
        ["color"] = COLORS["darkest_blue"],
        ["image"] = "deep_water",
        ["tiling"] = "8bit",
        ["compare_function"] = "same_template",
    },
    ["shallow_water"] = {
        ["id"] = string.byte("~"),
        ["color"] = COLORS["dark_blue"],
        ["image"] = "shallow_water",
        ["tiling"] = "8bit",
        ["compare_function"] = "is_water",
    },
    ["coast"] = {
        ["id"] = string.byte("c"),
        ["color"] = COLORS["darker_amber"],
    },
    ["mountain"] = {
        ["id"] = string.byte("M"),
        ["color"] = COLORS["light_chartreuse"],
        ["image"] = "mountain",
        ["tiling"] = "8bit",
        ["compare_function"] = "same_template",
    },
    ["hill"] = {
        ["id"] = string.byte("h"),
        ["color"] = COLORS["dark_chartreuse"],
    },

    ["temperate desert"] = {
        ["id"] = string.byte("d"),
        ["color"] = {240, 220, 7},
        ["image"] = "temperate_desert",
        ["tiling"] = "8bit",
        ["compare_function"] = "same_template",
    },
    ["subtropical desert"] = {
        ["id"] = string.byte("d"),
        ["color"] = {250, 150, 24},
        ["image"] = "subtropical_desert",
        ["tiling"] = "8bit",
        ["compare_function"] = "same_template",
    },
    ["tropical desert"] = {
        ["id"] = string.byte("d"),
        ["color"] = {255, 65, 12},
        ["image"] = "tropical_desert",
        ["tiling"] = "8bit",
        ["compare_function"] = "same_template",
    },

    ["boreal grassland"] = {
        ["id"] = string.byte("."),
        ["color"] = COLORS["dark_sea"],
        ["image"] = "boreal_grassland",
        ["tiling"] = "8bit",
        ["compare_function"] = "same_template",
    },
    ["grassland"] = {
        ["id"] = string.byte("."),
        ["color"] = COLORS["darker_green"],
        ["image"] = "grassland",
        ["tiling"] = "8bit",
        ["compare_function"] = "same_template",
    },
    ["savana"] = {
        ["id"] = string.byte("."),
        ["color"] = COLORS["darker_yellow"],  -- (153, 219, 33)
        ["image"] = "savana",
        ["tiling"] = "8bit",
        ["compare_function"] = "same_template",
    },

    ["boreal forest"] = {
        ["id"] = string.byte("Z"),  -- string.byte("B"),
        ["color"] = COLORS["dark_orange"],  -- (5, 100, 33)
        ["image"] = "boreal_forest",
        ["tiling"] = "8bit",
        ["compare_function"] = "same_template"
    },
    ["woodland"] = {
        ["id"] = string.byte("2"),  -- string.byte("w"),
        ["color"] = COLORS["dark_turquoise"]  -- (0, 255, 255)
    },
    ["temperate deciduous forest"] = {
        ["id"] = string.byte("3"),  -- string.byte("D"),
        ["color"] = COLORS["dark_chartreuse"]  -- (47, 186, 74)
    },
    ["temperate rain forest"] = {
        ["id"] = string.byte("4"),  -- string.byte("T"),
        ["color"] = COLORS["dark_green"]  -- (7, 250, 160)
    },
    ["tropical rain forest"] = {
        ["id"] = string.byte("5"),  -- string.byte("R"),
        ["color"] = COLORS["darker_green"]  -- (8, 250, 50)
    },


    ["heat_view"] = {
        ["id"] = string.byte("$")
    },
    ["rainfall_view"] = {
        ["id"] = string.byte("~")
    },
}

templates.FeatureEntity = {
    ["_default"] = {
        ["color"] = COLORS["gray"],
        ["block_mov"] = false,
        ["block_sight"] = false
    },
    ["stair_up"] = {
        ["id"] = string.byte("<")
    },
    ["stair_down"] = {
        ["id"] = string.byte(">")
    },
    ["door_closed"] = {
        ["id"] = string.byte("="),
        ["color"] = {161, 161, 161},
        ["block_mov"] = true,
        ["block_sight"] = true
    },
    ["door_locked"] = {
        ["id"] = string.byte("¬"),
        ["color"] = {161, 161, 161},
        ["block_mov"] = true,
        ["block_sight"] = true
    },
    ["door_open"] = {
        ["id"] = string.byte("\\"),  -- 92
        ["color"] = {161, 161, 161}
    }
}

templates.ItemEntity = {}

templates.FeatureComponent = {
    ["_default"] = {
        ["use_function"] = nil,
    },
    ["stair_up"] = {
        ["use_function"] = "effects.change_dng_level",
        ["on_step"] = {'msg', 'There are stairs going up here.'}
    },
    ["stair_down"] = {
        ["use_function"] = "effects.change_dng_level",
        ["on_step"] = {'msg', 'There are stairs going down here.'},
        ["on_use"] = {'msg',
                      "You descend deeper into the heart of the dungeon..."}
    }
}

templates.ItemComponent = {
    ["_default"] = {
        ["use_function"] = nil,
        ["color"] = COLORS["papyrus"]
    },
    ["healing potion"] = {
        ["use_function"] = effects.cast_heal,
        ["id"] = string.byte('!'),
        ["color"] = COLORS["blood_red"]
    },
    ["scroll of lightning bolt"] = {
        ["use_function"] = effects.cast_lightning,
        ["id"] = string.byte('?')
    },
    ["scroll of confusion"] = {
        ["use_function"] = effects.cast_confuse,
        ["id"] = string.byte('?')
    },
    ["scroll of fireball"] = {
        ["use_function"] = effects.cast_fireball,
        ["id"] = string.byte('?')
    },
    ["remains"] = {
        ["use_function"] = effects.cast_heal,
        ["id"] = string.byte('?'),
        ["color"] = COLORS["corpse"]
    }
}

templates.WeaponComponent = {
    ["_default"] = {
        ["id"] = string.byte("|"),
        ["color"] = COLORS["grey"]
    },
    -- **get_all_weapons()
}

templates.ArmorComponent = {
    ["_default"] = {
        ["id"] = string.byte("["),
        ["color"] = COLORS["grey"],
        ["on_equip"]= {},
        ["on_unequip"]= {}
    },
    -- **get_all_armors()
}



return templates
