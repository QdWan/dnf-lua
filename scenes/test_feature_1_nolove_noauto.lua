package.path = ";c:/luapower/?.lua;" .. package.path

love = require("loveless")

require("main")

local FeatureEntity = require("dnf.entities.feature")
local f = FeatureEntity('city')
log:warn(inspect(f.data))

