local inspect = require("inspect")
local Set = require("set")

local a = Set({1, 2, 3, 4, 5, 5})
print(string.format("set a: %s", a))

local b = Set({3, 3, 4, 5})
print(string.format("set b: %s", b))

local c = a:union(b)
print(string.format("set c(union): %s", c))

local d = a:intersection(b)
print(string.format("set d(intersection): %s", d))
