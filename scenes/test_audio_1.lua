local AudioManager = require("audio_manager")


local SceneBase = require("scenes.base")

local AudioTestScene = class("AudioTestScene", SceneBase)

function AudioTestScene:initialize()
    self:set_bgm()
    SceneBase.initialize(self) -- super
end

function AudioTestScene:set_bgm()
    self.audio = AudioManager()
    self.tracks = {
        self.audio:load(
            "resources/sounds/music_win.ogg",
            "stream", false),
        self.audio:load(
            "resources/sounds/Steps_of_Destiny(Alexandr_Zhelanov).ogg",
            "stream", false)
    }
    self:next_track()
end

function AudioTestScene:_set_observers()
    SceneBase._set_observers(self) -- super
    self.observers["MUSICSTOPPED"] = beholder.observe(
        'MUSICSTOPPED', self.bgm, function() self:next_track() end)
end

function AudioTestScene:update(dt)
    self.audio:update(dt)
end

function AudioTestScene:next_track()
    if self.track == nil or #self.tracks == 1 then
        self.track = 0
        self.bgm = self.tracks[self.track + 1]
    else
        self.track = (self.track + 1) % #self.tracks
        self.bgm = self.tracks[self.track + 1]
    end
    self.audio:play_m(self.bgm)
end

function AudioTestScene:keypressed(key, scancode, isrepeat)
    if key == 's' then
        self.audio:stop(self.bgm)
    elseif key == 'p' then
        self.audio:play_m(self.bgm) -- still streaming and looping
    elseif key == 'space' then
        if self.bgm:isPaused() then
            self.audio:resume(self.bgm)
        else
            self.audio:pause(self.bgm) -- still streaming and looping
        end
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
