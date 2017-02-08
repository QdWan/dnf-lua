local AudioManager = class("AudioManager")

local beholder = require("beholder")

local K = 2

function AudioManager:initialize()
    -- will hold the currently playing sources
    self.sources = {}
    -- check for sources that finished playing and remove them
    -- add to love.update
    self.observers = {}
    self.observers["UPDATE"] = beholder.observe(
        'UPDATE', manager, function(dt) return self:update(dt) end)
end

function AudioManager:update(dt)
    local remove = {}
    for _,t in pairs(self.sources) do
        local s = t.source
        if s:isStopped() then
            remove[#remove + 1] = s

        elseif t.fading_out then
            local vol = s:getVolume()
            if vol <= 0 then
                t.fading_out = false
                remove[#remove + 1] = s
            else
                vol = math.max(vol - t.step * dt, 0)
                s:setVolume(vol)
            end

        elseif t.fading_in then
            if t.fade_vol == nil then
                t.fade_vol = 0
                t.step = 1 / K
            elseif t.fade_vol >= t.vol then
                s:setVolume(t.vol)
                t.fading_in = false
            else
                t.fade_vol = math.min(t.fade_vol + t.step * dt, 1)
                s:setVolume(t.fade_vol)
            end

        elseif (t.fading_out == false and
                s:getDuration() - s:tell("seconds") < K
        ) then
            t.fading_out = true
            t.step = 1 / K
        end
    end

    for i,s in ipairs(remove) do
        self:stop(s)
    end
end

function AudioManager:load(what, how, loop, mode)
    mode = mode or "sound"
    local src = what
    if type(what) ~= "userdata" or not what:typeOf("Source") then
        src = love.audio.newSource(what, how)
        src:setLooping(loop or false)
    end

    if not loop and mode == "music" then
        self.sources[src] = {
            source = src, vol = 1, fading_in=true, fading_out=false}
        src:setVolume(0)
    else
        self.sources[src] = {source = src, vol = 1}
    end
    return src
end

function AudioManager:play(what, how, loop)
    local src = self:load(what, how, loop)
    love.audio.play(src)
    return src
end

function AudioManager:play_s(what, how, loop)
    -- an alias to default mode
    return self:play(what, how, loop)
end

function AudioManager:play_m(what, how, loop)
    local src = self:load(what, how, loop, "music")
    love.audio.play(src)
    return src
end


function AudioManager:stop(src)
    if not src then return end
    love.audio.stop(src)
    self.sources[src] = nil
    beholder.trigger("MUSICSTOPPED", src)
end

function AudioManager:pause(src)
    if not src then return end
    love.audio.pause(src)
end

function AudioManager:resume(src)
    if not src then return end
    love.audio.resume(src)
end

function AudioManager:fade_out(src)
    if not src then return end
    self.sources[src].fading_out = true
end

return AudioManager
