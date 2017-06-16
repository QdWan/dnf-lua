local AudioManager = require("audio_manager")

single_test = not auto and true or false
local SceneTestBase = require("scenes.test_base")
auto.functions = {
    function() auto.sleep = 0.15 end,
    function() manager.audio:play_s("resources/sounds/sound.wav") end,
    function() manager.jukebox:next_track() end,
    function() manager.audio:play_s("resources/sounds/sound.wav") end,
    function() manager.jukebox:next_track() end,
    function() auto.sleep = nil end,
}

local AudioTestScene = class("AudioTestScene", SceneTestBase)

function AudioTestScene:init()
    self.bgm_name = {
        "resources/sounds/music_win.ogg",
        "resources/sounds/Steps_of_Destiny(Alexandr_Zhelanov).ogg",
    }
    SceneTestBase.init(self) -- super
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
