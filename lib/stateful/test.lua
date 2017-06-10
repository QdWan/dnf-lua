local paths = "?.lua;?/init.lua;../?.lua;../?/init.lua;../?/?.lua;"
package.path = paths .. package.path

local class    = require 'middleclass'
local Stateful = require 'stateful'

local Enemy = class('Enemy')
Enemy:include(Stateful)

function Enemy:init(health)
  self.health = health
end

function Enemy:speak()
  return 'My health is ' .. tostring(self.health)
end

local Immortal = Enemy:addState('Immortal')

-- overriden function
function Immortal:speak()
  return 'I am UNBREAKABLE!!'
end

-- added function
function Immortal:die()
  return 'I can not die now!'
end

local peter = Enemy:new(10)

print(peter:speak()) -- My health is 10
peter:gotoState('Immortal')
print(peter:speak()) -- I am UNBREAKABLE!!
print(peter:die()) -- I can not die now!
peter:gotoState(nil)
print(peter:speak()) -- My health is 10
