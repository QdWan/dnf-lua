local decide = require("decide")

node_meta_height_value = 0.2
local height_contrib = decide.LGHB(node_meta_height_value)
local height_weight = 0.8

node_meta_heat_value = 0.5
local heat_contrib = decide.MGEB(node_meta_heat_value)
local heat_weight = 1

node_meta_rainfall_value = 0.7
local rainfall_contrib = decide.HGLB(node_meta_rainfall_value)
local rainfall_weight = 1

distance_to_nearest_city = 6
local distance_contrib = decide.SGAB(distance_to_nearest_city,
                              6, -1, 10)
local distance_weight = 1

forest_ratio_r4 = 0.5
local forest_contrib = decide.MGEB(forest_ratio_r4)
local forest_weight = 0.8

water_ratio_r1 = 0.3
local water_r1_contrib = decide.MGEB(water_ratio_r1)
local water_r1_weight = 1.2

water_ratio_r2 = 0.4
local water_r2_contrib = decide.MGEB(water_ratio_r2)
local water_r2_weight = water_r1_weight / 2

water_ratio_r4 = 0.5
local water_r4_contrib = decide.MGEB(water_ratio_r4)
local water_r4_weight = water_r1_weight / 4

print(decide.decide(height_contrib, height_weight,
       heat_contrib, heat_weight,
       rainfall_contrib, rainfall_weight,
       distance_contrib, distance_weight,
       forest_contrib, forest_weight,
       water_r1_contrib, water_r1_weight,
       water_r2_contrib, water_r2_weight,
       water_r4_contrib, water_r4_weight
       ))
