require('lfs')
class = require("middleclass")
inspect = require("inspect")
local tileset_templates = require("templates")


local BASE_PATH = "/Users/Lucas/Documents/Lucas/love2d/manager/master/"

love = {
    graphics = {},
    filesystem = {},
}
manager = {}
log = {warn = function() end}

function love.filesystem.getDirectoryItems(path)
    local fullpath = BASE_PATH .. path
    local res = {}
    for file in lfs.dir(fullpath) do
        local filepath = fullpath .. "/" .. file
        if lfs.attributes(filepath,"mode") == "file" then
            table.insert(res, file)
        end
    end
    return res
end

function love.graphics.newImage() return true end
function love.graphics.setCanvas() end
function love.graphics.clear() end
function love.graphics.setBlendMode() end
function love.graphics.draw() end
function love.graphics.newQuad() return true end
function love.graphics.getSystemLimits() return {texturesize = 2048} end
function love.graphics.newCanvas(...)
    return {
        setFilter = function() end,
        getWidth = function() end,
        getHeight = function() end,
    }
end

local resources = require("resources")()
manager.resources = resources
local tiles_set = resources:tileset("TileEntity")
for name, template in pairs(tileset_templates["TileEntity"]) do
    local sprite = resources:tile("TileEntity", name, 1, 1)
    print(tiles_set.info_map[template.image].pos .. "\n" .. inspect(sprite))
end


