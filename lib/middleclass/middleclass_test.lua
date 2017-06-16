local class = require("middleclass")

local A = class("A")

local B = class("B", A)

function A:init(...) print("A") end
function B:init(...) B.super.init(...) end

local a = A()
local b = B()
