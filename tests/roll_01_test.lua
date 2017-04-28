require("test_base")

math.randomseed(os.time())
math.random()

local dice = require("dnf.dice")
for i = 1, 20 do
    dice.roll({rolls=5, faces=20})
end
