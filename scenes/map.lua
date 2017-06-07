local SceneBase = require("scenes.base")

local SceneMap = class("SceneMap", SceneBase)
local DefaultState = {__index = SceneMap.super}
local PausedState = setmetatable({}, {__index = DefaultState})
SceneMap:set_class_defaults({__state = DefaultState, __states = {}})

function SceneMap:init(param)
    self.class.super.init(self)
    self:create_widgets(param)
end

function SceneMap:create_widgets(param)
    self.game_world = GameWorld{
        new_game = param.new_game,
        player   = param.player,
    }
    self.game_view = MapView(self.game_world)
end

