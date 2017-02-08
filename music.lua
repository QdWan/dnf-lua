allSongs = {}
allSongs.volume = 1

function allSongs:setVolume(vol)
    -- volume must be [0:1]
    if vol > 1 then vol = 1 end
    if vol < 0 then vol = 0 end

    self.volume = vol
    for _, v in ipairs(allSongs) do
        local min, max = v.song:getVolumeLimits()
        v.song:setVolumeLimits(min, v.max*self.volume)
        v.song:setVolume(v.max*self.volume)
    end
end

function allSongs:pause()
    for _, v in ipairs(allSongs) do
        if v.song:isPlaying() then v.song:pause() end
    end
end

function allSongs:unPause()
    for _, v in ipairs(allSongs) do
        if v.song:isPaused() then v.song:play() end
    end
end

function newSong(path, min, max)
    local song = love.audio.newSource(path)
    song:setVolumeLimits(min, max)
    song:setLooping(true)
    table.insert(allSongs, {song = song, max = max})    -- max stored as reference for allSongs:setVolume(vol) function
    return song
end

music = {}      -- note: music is streamed, not static, because the files are larger
music.title = newSong(
    "resources/sounds/Steps_of_Destiny(Alexandr_Zhelanov).mp3", 0, .4)
    music.intro:play()
    music.current = music.intro
-- music.ingameAmbience = newSong("sounds/ingame-ambience.wav", 0, .6)
-- music.gameEnd = newSong("sounds/game-end.wav", 0, 1)
-- music.gameEnd:setLooping(false)

musicQueue = {}     -- to control fade in/out effects

function music.fadeOut(song, time)
    local volume = song:getVolume()
    local factor = volume/time

    table.insert(musicQueue, function(dt)
        volume = volume - factor * dt
        if volume <= 0 then
            song:stop()
            return false
        else
            song:setVolume(volume)
        end
    end)
end

function music.fadeIn(song, time)
    local volume = 0
    local _, maxVolume = song:getVolumeLimits()
    local factor = maxVolume/time
    song:setVolume(0)
    song:play()

    table.insert(musicQueue, function(dt)
        volume = volume + factor * dt
        if volume >= maxVolume then
            song:setVolume(maxVolume)
            return false
        else
            song:setVolume(volume)
        end
    end)
end
