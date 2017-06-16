local Rect = require("rect")
local class = require('middleclass') or require('minclass')

Quad = class("Quad", Rect)
q = Quad(1, 2, 3, 4)
print(q:get_left(), q:get_top(), q:get_width(), q:get_height())
