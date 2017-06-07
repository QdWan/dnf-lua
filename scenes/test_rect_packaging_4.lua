local SceneBase = require("scenes.base")
local Rect = require("Rect")
-- local layer_text = require("layers.text")
local widgets = require("widgets")
local rect_packager = require("lib.rect_packager_4")
local SceneRectPackagerTest = class("SceneRectPackagerTest", SceneBase)

local random = love.math.random

local SEED = 2

love.math.setRandomSeed(SEED)

function SceneRectPackagerTest:init()
    SceneBase.init(self) -- super
    self:create_rects()
end

function SceneRectPackagerTest:create_rects()
    self.unsorted = {
        Rect(0, 0, random(10) * 2, random(10) * 2),
        Rect(0, 0, random(10) * 2, random(20)),
        Rect(0, 0, random(10) * 2, random(10) * 2),
        Rect(0, 0, random(10) * 2, random(20)),
        Rect(0, 0, random(10) * 2, random(10) * 2),
        Rect(0, 0, random(10) * 2, random(20)),
        Rect(0, 0, random(10) * 2, random(10) * 2),
        Rect(0, 0, random(10) * 2, random(20)),
        Rect(0, 0, random(10) * 2, random(10) * 2),
        Rect(0, 0, random(10) * 2, random(20)),
        Rect(0, 0, random(10) * 2, random(10) * 2),
        Rect(0, 0, random(10) * 2, random(20)),
        Rect(0, 0, random(10) * 2, random(10) * 2),
        Rect(0, 0, random(10) * 2, random(20)),
    }
    for i, rect in ipairs(self.unsorted) do
        local c = i / #self.unsorted * 256
        rect.c = {c, c, c}
    end
    self.sorted = rect_packager(self.unsorted)
end

function SceneRectPackagerTest:draw()
    love.graphics.setColor(255, 0, 0)
    love.graphics.rectangle("fill",
                            0, 0,
                            self.rect.w, self.rect.h / 2)
    love.graphics.setColor(0, 255, 0)
    love.graphics.rectangle("fill",
                            0, self.rect.h / 2,
                            self.rect.w, self.rect.h / 2)

    local unsorted = self.unsorted
    local len = #unsorted
    local x = 0
    local h = 0
    local s = 6
    for i = 1, #unsorted do
        local rect = unsorted[i]
        love.graphics.setColor(rect.c)
        love.graphics.rectangle("fill",
                                x * s, 0 * s + h,
                                rect.w * s, rect.h * s)
        x = x + rect.w
    end

    local sorted = self.sorted
    local len = #sorted
    for i = 1, #sorted do
        local rect = sorted[i]
        love.graphics.setColor(rect.c)
        love.graphics.rectangle("fill",
                                rect.x * s, rect.y * s + self.rect.h / 2,
                                rect.w * s, rect.h * s)
    end
end

function SceneRectPackagerTest:keypressed(key)
    if key == "space" then
        self:create_rects()
    end
end

return SceneRectPackagerTest
