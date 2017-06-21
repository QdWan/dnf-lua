local templates = {constants = {}}

local COLORS = require("data.colors")
local effects = {} -- TODO


templates.TileEntity = {
    ["_default"] = {
        ["_index"] = 1,
        ["_folder"] = "tiles",
        ["block_mov"] = false,
        ["block_sight"] = false,
        ["image"] = "ascii",
        ["label_color"] = {255, 255, 255, 255},
    },
    ["shadow"] = {
        ["_index"] = 2,
        ["image"] = "shadow",
    },
    ["floor"] = {
        ["_index"] = 3,
        ["id"] = string.byte(".") + 1,
        ["color"] = {129, 106, 86},
        ["_rnd_gen_cost"] = 64,
        ["image"] = "floor_cobble_blood",
        ["receive_shadow"] = "shadow"
    },
    ["wall"] = {
        ["_index"] = 4,
        ["id"] = string.byte("#") + 1,
        ["color"] = {161, 161, 161},
        ["_rnd_gen_cost"] = 8,
        ["block_mov"] = true,
        ["block_sight"] = true,
        ["image"] = "wall_brick_dark_1",
    },
    ["hall"] = {
        ["_index"] = 5,
        ["id"] = string.byte("/") + 1,
        ["color"] = {129, 106, 86},
        ["_rnd_gen_cost"] = 1,
    },
    ["water"] = {
        ["_index"] = 6,
        ["id"] = string.byte("=") + 1,
        ["color"] = COLORS["blue"],
        ["is_water"] = true,
    },
    ["land"] = {
        ["_index"] = 7,
        ["id"] = string.byte(".") + 1,
        ["color"] = COLORS["darker_green"]
    },


    ["arctic_deep_water"] = {
        ["_index"] = 8,
        ["id"] = string.byte("¬") + 1,
        ["color"] = COLORS["dark_sky"],
        ["image"] = "deep_water",
        ["tiling"] = "8bit",
        ["compare_function"] = "same_template",
        ["is_water"] = true,
    },
    ["arctic_shallow_water"] = {
        ["_index"] = 9,
        ["id"] = string.byte("~") + 1,
        ["color"] = COLORS["sky"],
        ["image"] = "arctic_shallow_water",
        ["tiling"] = "8bit",
        ["compare_function"] = "is_water",
        ["is_water"] = true,
    },
    ["arctic_coast"] = {
        ["_index"] = 10,
        ["id"] = string.byte("c") + 1,
        ["color"] = {248, 243, 223}
        -- COLORS["lightest_amber"]  -- (255, 255, 255)
    },
    ["arctic_mountain"] = {
        ["_index"] = 11,
        ["id"] = string.byte("O") + 1,
        ["color"] = {245, 245, 245}  -- (255, 255, 255)
    },
    ["arctic_hill"] = {
        ["_index"] = 12,
        ["id"] = string.byte("^") + 1,
        ["color"] = {245, 245, 245}  -- (255, 255, 255)
    },
    ["arctic_land"] = {
        ["_index"] = 13,
        ["id"] = string.byte(",") + 1,
        ["color"] = {248, 248, 255},  -- (255, 255, 255)
        ["label_color"] = {60, 30, 200, 255},
        ["image"] = "arctic_land",
        ["tiling"] = "8bit",
        ["compare_function"] = "same_template",
    },

    ["deep_water"] = {
        ["_index"] = 14,
        ["id"] = string.byte("¬") + 1,
        ["color"] = COLORS["darkest_blue"],
        ["image"] = "deep_water",
        ["tiling"] = "8bit",
        ["compare_function"] = "same_template",
        ["is_water"] = true,
    },
    ["shallow_water"] = {
        ["_index"] = 15,
        ["id"] = string.byte("~") + 1,
        ["color"] = COLORS["dark_blue"],
        ["image"] = "shallow_water",
        ["tiling"] = "8bit",
        ["compare_function"] = "is_water",
        ["is_water"] = true,
    },
    ["coast"] = {
        ["_index"] = 16,
        ["id"] = string.byte("c") + 1,
        ["color"] = COLORS["darker_amber"],
    },
    ["mountain"] = {
        ["_index"] = 17,
        ["id"] = string.byte("O") + 1,
        ["color"] = COLORS["light_chartreuse"],
        ["image"] = "mountain",
        ["tiling"] = "8bit",
        ["compare_function"] = "same_template",
    },
    ["hill"] = {
        ["_index"] = 18,
        ["id"] = string.byte("^") + 1,
        ["color"] = COLORS["dark_chartreuse"],
    },

    ["temperate_desert"] = {
        ["_index"] = 19,
        ["id"] = string.byte(",") + 1,
        ["color"] = {240, 220, 7},
        ["image"] = "temperate_desert",
        ["tiling"] = "8bit",
        ["compare_function"] = "same_id",
    },
    ["subtropical_desert"] = {
        ["_index"] = 20,
        ["id"] = string.byte(",") + 1,
        ["color"] = {250, 150, 24},
        ["image"] = "subtropical_desert",
        ["tiling"] = "8bit",
        ["compare_function"] = "same_id",
    },
    ["tropical_desert"] = {
        ["_index"] = 21,
        ["id"] = string.byte(",") + 1,
        ["color"] = {255, 65, 12},
        ["image"] = "tropical_desert",
        ["tiling"] = "8bit",
        ["compare_function"] = "same_id",
    },
    ["boreal_grassland"] = {
        ["_index"] = 22,
        ["id"] = string.byte(".") + 1,
        ["color"] = COLORS["dark_sea"],
        ["image"] = "boreal_grassland",
        ["tiling"] = "8bit",
        ["compare_function"] = "same_id",
    },
    ["grassland"] = {
        ["_index"] = 23,
        ["id"] = string.byte(".") + 1,
        ["color"] = COLORS["darker_green"],
        ["image"] = "grassland",
        ["tiling"] = "8bit",
        ["compare_function"] = "same_id",
    },
    ["savana"] = {
        ["_index"] = 24,
        ["id"] = string.byte(",") + 1,
        ["color"] = COLORS["darker_yellow"],  -- (153, 219, 33)
        ["image"] = "savana",
        ["tiling"] = "8bit",
        ["compare_function"] = "same_id",
    },

    ["boreal_forest"] = {
        ["_index"] = 25,
        ["id"] = string.byte("T") + 1,
        ["color"] = COLORS["dark_orange"],  -- (5, 100, 33)
        ["image"] = "boreal_forest",
        ["tiling"] = "8bit",
        ["compare_function"] = "same_template"
    },
    ["woodland"] = {
        ["_index"] = 26,
        ["id"] = string.byte("T") + 1,
        ["color"] = COLORS["dark_turquoise"]  -- (0, 255, 255)
    },
    ["temperate_deciduous_forest"] = {
        ["_index"] = 27,
        ["id"] = string.byte("T") + 1,
        ["color"] = COLORS["dark_chartreuse"]  -- (47, 186, 74)
    },
    ["temperate_rain_forest"] = {
        ["_index"] = 28,
        ["id"] = string.byte("T") + 1,
        ["color"] = COLORS["dark_green"]  -- (7, 250, 160)
    },
    ["tropical_rain_forest"] = {
        ["_index"] = 29,
        ["id"] = string.byte("T") + 1,
        ["color"] = COLORS["darker_green"]  -- (8, 250, 50)
    },


    ["heat_view"] = {
        ["_index"] = 30,
        ["id"] = string.byte("$") + 1
    },
    ["rainfall_view"] = {
        ["_index"] = 31,
        ["id"] = string.byte("~") + 1
    },
    ["city"] = {
        ["_index"] = 32,
        ["id"] = 179,
        ["image"] = "city",
    },
}

templates.FeatureEntity = {
    ["_default"] = {
        ["color"] = COLORS["gray"],
        ["block_mov"] = false,
        ["block_sight"] = false
    },
    ["stair_up"] = {
        ["id"] = string.byte("<") + 1
    },
    ["stair_down"] = {
        ["id"] = string.byte(">") + 1
    },
    ["door_closed"] = {
        ["id"] = string.byte("=") + 1,
        ["color"] = {161, 161, 161},
        ["block_mov"] = true,
        ["block_sight"] = true
    },
    ["door_locked"] = {
        ["id"] = string.byte("¬") + 1,
        ["color"] = {161, 161, 161},
        ["block_mov"] = true,
        ["block_sight"] = true
    },
    ["door_open"] = {
        ["id"] = string.byte("\\") + 1,  -- 92
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
        ["id"] = string.byte('!') + 1,
        ["color"] = COLORS["blood_red"]
    },
    ["scroll of lightning bolt"] = {
        ["use_function"] = effects.cast_lightning,
        ["id"] = string.byte('?') + 1
    },
    ["scroll of confusion"] = {
        ["use_function"] = effects.cast_confuse,
        ["id"] = string.byte('?') + 1
    },
    ["scroll of fireball"] = {
        ["use_function"] = effects.cast_fireball,
        ["id"] = string.byte('?') + 1
    },
    ["remains"] = {
        ["use_function"] = effects.cast_heal,
        ["id"] = string.byte('?') + 1,
        ["color"] = COLORS["corpse"]
    }
}

templates.WeaponComponent = {
    ["_default"] = {
        ["id"] = string.byte("|") + 1,
        ["color"] = COLORS["grey"]
    },
    -- **get_all_weapons()
}

templates.ArmorComponent = {
    ["_default"] = {
        ["id"] = string.byte("[") + 1,
        ["color"] = COLORS["grey"],
        ["on_equip"]= {},
        ["on_unequip"]= {}
    },
    -- **get_all_armors()
}

return templates
