local class = require("minclass")

local SceneMap = class("SceneMap")
local DefaultState = {}
local PausedState = setmetatable({}, {__index = DefaultState})
local UnimplementedState = setmetatable({}, {__index = DefaultState})
SceneMap:set_class_defaults({__state = DefaultState, __states = {}})

function SceneMap:say_hello(...)
    return self.__state:say_hello(...)
end

function DefaultState:say_hello(...)
    print("Default:say_hello")
end

function PausedState:say_hello(...)
    print("Paused:say_hello")
end


local scene = SceneMap()
scene:say_hello()
scene.__state = PausedState
scene:say_hello()
scene.__state = UnimplementedState
scene:say_hello()
