local AudioManager = require("audio_manager")


local SceneBase = require("scenes.base")

local AudioTestScene = class("AudioTestScene", SceneBase)

function AudioTestScene:init()
    self.bgm_name = {
        "resources/sounds/music_win.ogg",
        "resources/sounds/Steps_of_Destiny(Alexandr_Zhelanov).ogg",
    }
    SceneBase.init(self) -- super
end

function AudioTestScene:keypressed(key, scancode, isrepeat)
    if key == 'down' or key == 'tab' then
        manager.jukebox:next_track()
    --[[

    elseif key == 's' then
        manager.jukebox:stop()
    elseif key == 'p' then
        manager.jukebox:play() -- still streaming and looping
    elseif key == 'space' then
        manager.jukebox:toggle_pause()
    ]]--
    else
         -- play explosion sound once
        manager.audio:play_s("resources/sounds/sound.wav")
    end
end

return AudioTestScene
