local templates = {constants = {}}

local COLORS = require("data.colors")
local effects = {} -- TODO


templates.TileEntity = {
    ["_default"] = {
        ["_folder"] = "tile_feature",
        ["block_mov"] = false,
        ["block_sight"] = false,
        ["image"] = "ascii",
        ["label_color"] = {255, 255, 255, 255},
    },
    ["shadow"] = {
        ["image"] = "shadow",
    },
    ["floor"] = {
        ["id"] = string.byte(".") + 1,
        ["color"] = {129, 106, 86},
        ["_rnd_gen_cost"] = 64,
        ["image"] = "floor_cobble_blood",
        ["receive_shadow"] = "shadow"
    },
    ["wall"] = {
        ["id"] = string.byte("#") + 1,
        ["color"] = {161, 161, 161},
        ["_rnd_gen_cost"] = 8,
        ["block_mov"] = true,
        ["block_sight"] = true,
        ["image"] = "wall_brick_dark_1",
    },
    ["hall"] = {
        ["id"] = string.byte("/") + 1,
        ["color"] = {129, 106, 86},
        ["_rnd_gen_cost"] = 1,
    },
    ["water"] = {
        ["id"] = string.byte("=") + 1,
        ["color"] = COLORS["blue"],
    },
    ["land"] = {
        ["id"] = string.byte(".") + 1,
        ["color"] = COLORS["darker_green"]
    },


    ["arctic_deep_water"] = {
        ["id"] = string.byte("¬") + 1,
        ["color"] = COLORS["dark_sky"],
        ["image"] = "deep_water",
        ["tiling"] = "4bit",
        ["group0"] = "DEEP_WATER",
        ["compare_function"] = "same_group0",
    },
    ["arctic_shallow_water"] = {
        ["id"] = string.byte("~") + 1,
        ["color"] = COLORS["sky"],
        ["image"] = "arctic_shallow_water",
        ["tiling"] = "4bit",
        ["compare_function"] = "is_water",
    },
    ["deep_water"] = {
        ["id"] = string.byte("¬") + 1,
        ["color"] = COLORS["darkest_blue"],
        ["image"] = "deep_water",
        ["tiling"] = "4bit",
        ["group0"] = "DEEP_WATER",
        ["compare_function"] = "same_group0",
    },
    ["shallow_water"] = {
        ["id"] = string.byte("~") + 1,
        ["color"] = COLORS["dark_blue"],
        ["image"] = "shallow_water",
        ["tiling"] = "4bit",
        ["compare_function"] = "is_water",
    },
    ["arctic_mountain"] = {
        ["id"] = string.byte("O") + 1,
        ["color"] = {245, 245, 245},
        ["image"] = "arctic_mountain",
        ["tiling"] = "4bit",
        ["group0"] = "MOUNTAIN_GROUP",
        ["compare_function"] = "same_group0",
    },
    ["arctic_hill"] = {
        ["id"] = string.byte("^") + 1,
        ["color"] = {245, 245, 245},
        ["image"] = "arctic_hill",
        ["tiling"] = "4bit",
        ["group0"] = "HILL_GROUP",
        ["compare_function"] = "same_group0",
    },
    ["temperate_mountain"] = {
        ["id"] = string.byte("O") + 1,
        ["color"] = COLORS["light_chartreuse"],
        ["image"] = "mountain",
        ["tiling"] = "4bit",
        ["group0"] = "MOUNTAIN_GROUP",
        ["compare_function"] = "same_group0",
    },
    ["temperate_hill"] = {
        ["id"] = string.byte("^") + 1,
        ["color"] = COLORS["dark_chartreuse"],
        ["image"] = "temperate_hill",
        ["tiling"] = "4bit",
        ["group0"] = "HILL_GROUP",
        ["compare_function"] = "same_group0",
    },
    ["mountain"] = {
        ["id"] = string.byte("O") + 1,
        ["color"] = COLORS["light_chartreuse"],
        ["image"] = "mountain",
        ["tiling"] = "4bit",
        ["group0"] = "MOUNTAIN_GROUP",
        ["compare_function"] = "same_group0",
    },
    ["hill"] = {
        ["id"] = string.byte("^") + 1,
        ["color"] = COLORS["dark_chartreuse"],
        ["image"] = "temperate_hill",
        ["tiling"] = "4bit",
        ["group0"] = "HILL_GROUP",
        ["compare_function"] = "same_group0",
    },
    ["tropical_hill"] = {
        ["id"] = string.byte("^") + 1,
        ["color"] = COLORS["dark_chartreuse"],
        ["image"] = "tropical_hill",
        ["tiling"] = "4bit",
        ["group0"] = "HILL_GROUP",
        ["compare_function"] = "same_group0",
    },
    ["tropical_mountain"] = {
        ["id"] = string.byte("O") + 1,
        ["color"] = COLORS["light_chartreuse"],
        ["image"] = "mountain",
        ["tiling"] = "4bit",
        ["group0"] = "MOUNTAIN_GROUP",
        ["compare_function"] = "same_group0",
    },

    ["temperate_desert"] = {
        ["id"] = string.byte(",") + 1,
        ["color"] = {240, 220, 7},
        ["image"] = "temperate_desert",
        ["tiling"] = "4bit",
        ["group0"] = "BARELAND_GROUP",
        ["compare_function"] = "same_group0",
    },
    ["subtropical_desert"] = {
        ["id"] = string.byte(",") + 1,
        ["color"] = {250, 150, 24},
        ["image"] = "subtropical_desert",
        ["tiling"] = "4bit",
        ["group0"] = "BARELAND_GROUP",
        ["compare_function"] = "same_group0",
    },
    ["tropical_desert"] = {
        ["id"] = string.byte(",") + 1,
        ["color"] = {255, 65, 12},
        ["image"] = "tropical_desert",
        ["tiling"] = "4bit",
        ["group0"] = "BARELAND_GROUP",
        ["compare_function"] = "same_group0",
    },

    ["arctic_coast"] = {
        ["id"] = string.byte("c") + 1,
        ["color"] = {248, 243, 223},
        ["image"] = "arctic_land",
        ["tiling"] = "4bit",
        ["group0"] = "ARCTIC_LAND",
        ["compare_function"] = "same_group0",
    },
    ["arctic_land"] = {
        ["id"] = string.byte(",") + 1,
        ["color"] = {248, 248, 255},  -- (255, 255, 255)
        ["label_color"] = {60, 30, 200, 255},
        ["image"] = "arctic_land",
        ["tiling"] = "4bit",
        ["group0"] = "ARCTIC_LAND",
        ["compare_function"] = "same_group0",
    },
    ["temperate_coast"] = {
        ["id"] = string.byte(".") + 1,
        ["color"] = COLORS["darker_amber"],
        ["image"] = "boreal_grassland",
        ["tiling"] = "4bit",
        ["group0"] = "GRASSLAND_GROUP",
        ["compare_function"] = "same_group0",
    },
    ["boreal_grassland"] = {
        ["id"] = string.byte(".") + 1,
        ["color"] = COLORS["dark_sea"],
        ["image"] = "boreal_grassland",
        ["tiling"] = "4bit",
        ["group0"] = "GRASSLAND_GROUP",
        ["compare_function"] = "same_group0",
    },
    ["coast"] = {
        ["id"] = string.byte(".") + 1,
        ["color"] = COLORS["darker_amber"],
        ["image"] = "grassland",
        ["tiling"] = "4bit",
        ["group0"] = "GRASSLAND_GROUP",
        ["compare_function"] = "same_group0",
    },
    ["grassland"] = {
        ["id"] = string.byte(".") + 1,
        ["color"] = COLORS["darker_green"],
        ["image"] = "grassland",
        ["tiling"] = "4bit",
        ["group0"] = "GRASSLAND_GROUP",
        ["compare_function"] = "same_group0",
    },
    ["tropical_coast"] = {
        ["id"] = string.byte(".") + 1,
        ["color"] = COLORS["darker_amber"],
        ["image"] = "savana",
        ["tiling"] = "4bit",
        ["group0"] = "BARELAND_GROUP",
        ["compare_function"] = "same_group0",
    },
    ["savana"] = {
        ["id"] = string.byte(",") + 1,
        ["color"] = COLORS["darker_yellow"],  -- (153, 219, 33)
        ["image"] = "savana",
        ["tiling"] = "4bit",
        ["group0"] = "BARELAND_GROUP",
        ["compare_function"] = "same_group0",
    },

    ["boreal_forest"] = {
        ["id"] = string.byte("T") + 1,
        ["color"] = COLORS["dark_orange"],  -- (5, 100, 33)
        ["image"] = "boreal_forest",
        ["tiling"] = "4bit",
        ["compare_function"] = "same_template"
    },
    ["woodland"] = {
        ["id"] = string.byte("T") + 1,
        ["color"] = COLORS["dark_turquoise"],
        ["image"] = "woodland",
        ["tiling"] = "4bit",
        ["compare_function"] = "same_template",
    },
    ["temperate_deciduous_forest"] = {
        ["id"] = string.byte("T") + 1,
        ["color"] = COLORS["dark_chartreuse"],
        ["image"] = "temperate_deciduous_forest",
        ["tiling"] = "4bit",
        ["compare_function"] = "same_template",
    },
    ["temperate_rain_forest"] = {
        ["id"] = string.byte("T") + 1,
        ["color"] = COLORS["dark_green"],
        ["image"] = "temperate_rain_forest",
        ["tiling"] = "4bit",
        ["compare_function"] = "same_template",
    },
    ["tropical_rain_forest"] = {
        ["id"] = string.byte("T") + 1,
        ["color"] = COLORS["darker_green"],
        ["image"] = "tropical_rain_forest",
        ["tiling"] = "4bit",
        ["compare_function"] = "same_template",
    },


    ["heat_view"] = {
        ["id"] = string.byte("$") + 1
    },
    ["rainfall_view"] = {
        ["id"] = string.byte("~") + 1
    },
}

templates.FeatureEntity = {
    ["_default"] = {
        ["_folder"] = "tile_feature",
        ["color"] = COLORS["gray"],
        ["block_mov"] = false,
        ["block_sight"] = false
    },
    ["city"] = {
        ["id"] = 179,
        ["image"] = "city",
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
