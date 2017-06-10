local LuaJukeBox = require("luajukebox")


local SceneBase = require("scenes.base")

local AudioTestScene = class("AudioTestScene", SceneBase)

function AudioTestScene:init()
    self.bgm_name = {
        "resources/sounds/music_win.ogg",
        "resources/sounds/Steps_of_Destiny(Alexandr_Zhelanov).ogg"
    }
    SceneBase.init(self) -- super
end

function AudioTestScene:keypressed(key, scancode, isrepeat)
    if key == 's' then
        self.audio:stop(self.bgm)
    elseif key == 'p' then
        manager.audio:play_m(self.bgm) -- still streaming and looping
    elseif key == 'space' then
        if self.bgm:isPaused() then
            self.audio:resume(self.bgm)
        else
            self.audio:pause(self.bgm) -- still streaming and looping
        end
    elseif key == 'tab' then
        manager.jukebox:next_track()
    elseif key == 'down' then
        if self.multiple then
            for i = 1, #self.tracks do
                self.audio:stop(self.tracks[i])
            end
        else
            self.audio:fade_out(self.bgm)
        end
    elseif key == "2" then
        self.multiple = not (self.multiple or false)
        if self.multiple then
            self:next_track()
        end
    else
        self.audio:play_s("resources/sounds/sound.wav") -- play explosion sound once
    end
end

return AudioTestScene
