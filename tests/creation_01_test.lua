local pp = require("pp")
require("test_base")

local seed = os.time()
print("seed:", seed)
math.randomseed(seed)
math.random()

local creature = require("dnf.creature")

for i = 1, #creature.races * 20 do
    print(creature.create_as_character())
end
