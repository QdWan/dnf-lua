local newperlin = require("perlin")
local Rect = require('rect')

local SceneBase = require("scenes.base")
local ScenePerlinTest = class("ScenePerlinTest", SceneBase)

local size = 4

function ScenePerlinTest:init()
    SceneBase.init(self) -- super

    --Assuming you called the module perlin.lua

    --newperlin is a function that generates Perlin noise objects:

    local myperlin = newperlin()
    --when provided no arguments, newperlin seeds the Perlin object with the current time to create an always different result, but you can provide a seed which will create always the same result:
    myperlin = newperlin(1)

    self.myperlin = myperlin

    self.grid = {}
    local grid = self.grid
    local w, h = self.rect.w / size, self.rect.h / size
    local lm = love.math
    for x = 1, w do
        grid[x] = grid[x] or {}
        for y = 1, h do
            local perlin_v = (myperlin:noise(x, y) + 1) / 2
            local noise1 = lm.noise(x, y)
            local noise2 = lm.noise(x + lm.random(), y + lm.random())
            -- print(perlin_v, noise1, noise2)
            if x < w / 2 then
                grid[x][y] = perlin_v * 256
            elseif y < h / 2 then
                grid[x][y] =  noise1 * 256
            else
                grid[x][y] =  noise2 * 256
            end
        end
    end
end

function ScenePerlinTest:draw(z)
    local grid = self.grid
    local w, h = self.rect.w / size, self.rect.h / size
    for x = 1, w do
        for y = 1, h do
            local v = grid[x][y]
            if x < w / 2 then
                love.graphics.setColor(v, 0, 0)
            elseif y < h / 2 then
                love.graphics.setColor(0, v, 0)
            else
                love.graphics.setColor(0, 0, v)
            end
            love.graphics.rectangle("fill", x * size, y * size, size, size)
        end
    end
end

return ScenePerlinTest
