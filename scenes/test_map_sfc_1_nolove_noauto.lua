package.path = ";c:/luapower/?.lua;" .. package.path

love = require("loveless")

require("main")

manager.scene = "test_map_sfc_1"

love.run()
