local SceneBase = require("scenes.base")
-- local layer_text = require("layers.text")
local widgets = require("widgets")
local rect_packager = require("lib.rect_packager")
local SceneRectPackagerTest = class("SceneRectPackagerTest", SceneBase)

local SEED = 7

love.math.setRandomSeed(SEED)

function SceneRectPackagerTest:init()
    SceneBase.init(self) -- super
    self:create_rects()
end

function SceneRectPackagerTest:create_rects()
    self.unsorted = {
        {w = love.math.random(10) * 2, h = love.math.random(10) * 2},
        {w = love.math.random(10) * 2, h = love.math.random(20)},
        {w = love.math.random(10) * 2, h = love.math.random(10) * 2},
        {w = love.math.random(10) * 2, h = love.math.random(20)},
        {w = love.math.random(10) * 2, h = love.math.random(10) * 2},
        {w = love.math.random(10) * 2, h = love.math.random(20)},
        {w = love.math.random(10) * 2, h = love.math.random(10) * 2},
        {w = love.math.random(10) * 2, h = love.math.random(20)},
        {w = love.math.random(10) * 2, h = love.math.random(10) * 2},
        {w = love.math.random(10) * 2, h = love.math.random(20)},
        {w = love.math.random(10) * 2, h = love.math.random(10) * 2},
        {w = love.math.random(10) * 2, h = love.math.random(20)},
    }
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
    local s = 4
    for i = 1, #unsorted do
        local rect = unsorted[i]
        local c = 256 / len * i
        love.graphics.setColor(c, c, c)
        love.graphics.rectangle("fill",
                                x * s, 0 * s,
                                rect.w * s, rect.h * s)
        x = x + rect.w
    end

    local sorted = self.sorted
    local len = #sorted
    for i = 1, #sorted do
        local rect = sorted[i]
        local c = 256 / len * i
        love.graphics.setColor(c, c, c)
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
