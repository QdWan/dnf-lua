local ODict = require("collections.odict")
local util = require("util")
local split = util.split
local LuaJukeBox = class("LuaJukeBox")

local K = 2

function LuaJukeBox:init()
    -- will hold the currently playing sources
    self.sources = ODict()
end

function LuaJukeBox:update(dt)
    local remove = false
    local track = self.track

    local source = track.source
    if source:isStopped() then
        -- log:warn("case 1 source:isStopped()", track.filename)
        remove = true

    elseif track.fading_out then
        -- log:warn("case 2 track.fading_out")
        local vol = source:getVolume()
        if vol <= 0 then
            track.fading_out = false
            track.fading_in=true
            remove = true
            track.fade_vol = nil
        else
            vol = math.max(vol - track.step * dt, 0)
            source:setVolume(vol)
        end

    elseif track.fading_in then
        -- log:warn("case 3 track.fading_in")
        if track.fade_vol == nil then
            track.fade_vol = 0
            track.step = 1 / K
        elseif track.fade_vol >= track.vol then
            source:setVolume(track.vol)
            track.fading_in = false
        else
            track.fade_vol = math.min(track.fade_vol + track.step * dt, 1)
            source:setVolume(track.fade_vol)
        end

    elseif (track.fading_out == false and
            source:getDuration() - source:tell("seconds") < K
    ) then
        -- log:warn("case 4 source:getDuration() - source:tell('seconds') < K")
        track.fading_out = true
        track.step = 1 / K
    end

    if remove then
        self:stop(track.source)
        self:next_track()
    end
end

function LuaJukeBox:load(...)
    local files = {...}
    for _, src in ipairs(files) do
        local path = split(src, "[/\\]")
        local filename = path[#path]
        log:warn(self, "load filename = ", filename)
        local new_src = assert(love.audio.newSource(src, "stream"))
        new_src:setLooping(false)
        new_src:setVolume(0)
        self.sources:insert(filename,
                            {source = new_src, vol = 1, fading_in=true,
                             fading_out=false, filename = filename})
    end
end

function LuaJukeBox:next_track()
    if self.sources:is_empty() then
        return
    elseif self.track == nil or self.track.source:isStopped() then
        if not self.observers then
            self:_set_observers()
        end
        if self.cleared == true then
            self.track = nil
            self.cleared = false
        end
        local _, track = self.sources:next(
            self.track and self.track["filename"] or nil)
        self.track = track
        if track == nil then return self:next_track() end

        log:warn("LuaJukeBox:next_track", self.track.filename)
        self:play(self.track.source)
    else
        self.track.fading_out = true
    end
end

function LuaJukeBox:clear(src)
    self.sources:clear()
    if self.track then
        self.track.fading_out = true
    end
    self.cleared = true
end

function LuaJukeBox:_set_observers()
    -- check for sources that finished playing and remove them
    -- add to love.update
    self.observers = {}
    self.observers["UPDATE"] = events:observe(
        {'UPDATE', manager}, function(dt) return self:update(dt) end)
    self.observers["MUSICSTOPPED"] = events:observe(
        {'MUSICSTOPPED', self}, function() return self:next_track() end)
end

function LuaJukeBox:play(src)
    love.audio.play(src)
end

function LuaJukeBox:stop(src)
    if not src then
        for i, _src in ipairs(self.sources) do
            return self:stop(_src)
        end
    end
    love.audio.stop(src)
    self.sources[src] = nil
    events:trigger({"MUSICSTOPPED", src})
end

function LuaJukeBox:pause(src)
    if not src then return end
    love.audio.pause(src)
end

function LuaJukeBox:resume(src)
    if not src then return end
    love.audio.resume(src)
end

function LuaJukeBox:fade_out(src)
    if not src then return end
    self.sources[src].fading_out = true
end

return LuaJukeBox
