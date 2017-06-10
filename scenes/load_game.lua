local SceneBase = require("scenes.base")
local widgets = require("widgets")
local World = require("dnf.world")
local creature = require("dnf.creature")

local LoadGame = class("LoadGame", SceneBase)

function LoadGame:init()
    SceneBase.init(self)
    self.string = "Loading your game"
    self.anim = 3
    self:set_msg()
end

function LoadGame:set_msg()
    self.frame = widgets.Frame({
        parent=self,
        -- bg_color={0, 0, 255, 255},
        rect=self.rect,
        z = 1
    })
    self.frame:row_config(1, 1)
    self.frame:col_config(1, 1)

    self.msg = widgets.Label({
        hover=false,
        parent=self.frame,
        text=self.string .. string.rep(".", self.anim),
        sticky="C",
        col=1,
        row=1,
        expand=true,
        font_size = 54,
        color = {200, 26, 15, 255},
    })

    self.frame:grid()
end

function LoadGame:update(dt)
    self.anim = (self.anim + dt) % 4
    self.msg.text = self.string .. string.rep(".", self.anim)
    if self.loaded then
        return events:trigger({'SET_SCENE'}, 'creation')
    else
        self.loaded = World.load()
        world = self.loaded
    end
end

return LoadGame
