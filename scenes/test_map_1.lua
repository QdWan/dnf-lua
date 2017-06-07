local SEED = 7

love.math.setRandomSeed(SEED)

local SceneBase = require("scenes.base")

local SceneMap = class("SceneMap", SceneBase)

local map_gen = require("lib.map_gen")
local map_containers = require("dnf.map_containers")

local lg = love.graphics
local lk = love.keyboard

local ceil = math.ceil
local floor = math.floor
local max = math.max
local min = math.min


function SceneMap:init()
    SceneBase.init(self) -- super

    self:setup_map()
    self:setupMapView()
    self:setupTileset()
end

function SceneMap:setup_map()
    local header = map_containers.MapHeader{
        global_pos = map_containers.Position(0, 0),
        depth = 0,
        branch = 0,
        cr = 1,
        creator = "RndMap2"
    }
    local creator = map_gen.get_creator(header)
    self.map = creator:create(header)
    self.tileSize = 32
end

function SceneMap:setupMapView()

    self.zoomX = self.zoomX or 1
    self.zoomY = self.zoomY or 1

    self.tilesDisplayWidth = min(ceil(
        (manager.width / (self.tileSize * self.zoomX))), self.map.w)
    self.tilesDisplayHeight = min(ceil(
        (manager.height / (self.tileSize * self.zoomY))), self.map.h)

    self.mapX = max(
        min(self.mapX or 1, self.map.w - self.tilesDisplayWidth),
        1)
    self.mapY = max(
        min(self.mapY or 1, self.map.h - self.tilesDisplayHeight),
        1
    )
end

function SceneMap:setupTileset()
    self.tileQuads = {}
    self.tilesetImage = manager.resources:image("tileset.png")
    self.tilesetImage:setFilter("nearest", "linear")

    local tileSize = self.tileSize
    local tilesetImage = self.tilesetImage

    -- grass
    self.tileQuads["wall"] = lg.newQuad(
        0 * tileSize, 20 * tileSize, tileSize, tileSize,
        tilesetImage:getWidth(), tilesetImage:getHeight())

    -- kitchen floor tile
    self.tileQuads["floor"] = lg.newQuad(
        2 * tileSize, 0 * tileSize, tileSize, tileSize,
        tilesetImage:getWidth(), tilesetImage:getHeight())

    self:updateTilesetBatch()
end

function SceneMap:updateTilesetBatch()
    local floor = floor
    local mapX = self.mapX
    local mapY = self.mapY
    local map = self.map
    local mapWidth = map.w
    local mapHeight = map.h
    local tileQuads = self.tileQuads
    local tileSize = self.tileSize
    local max_x = self.tilesDisplayWidth-1
    local max_y = self.tilesDisplayHeight-1
    local min = min

    self.tilesetBatch = lg.newSpriteBatch(
        self.tilesetImage, self.tilesDisplayWidth * self.tilesDisplayHeight)

    for x=0, max_x do
        for y=0, max_y do
            if self.debug then
                print("x(", x, ") mapX(", mapX, ") x + mapX(", x + mapX,
                      ") map.w(", map.w,
                      ")\n",
                      "y(", y, ") mapY(", mapY, ") y + mapY(", y + mapY,
                      ") map.h(", map.h
                      )
            end
            --[[
            local tile = tileQuads[map:get(x + mapX, y + mapY).template]
            self.tilesetBatch:add(tile, x*tileSize, y*tileSize)
            ]]--
            local template = map:get(x + mapX, y + mapY).tile.template
            local sprite = tileQuads[template]
            self.tilesetBatch:add(sprite, x*tileSize, y*tileSize)
        end
    end
    self.tilesetBatch:flush()
end

-- central function for moving the map
function SceneMap:moveMap(dx, dy)
    local oldMapX = self.mapX
    local oldMapY = self.mapY
    self.mapX = max(
            min(floor(self.mapX + dx), self.map.w - self.tilesDisplayWidth),
            1)
    self.mapY = max(
            min(floor(self.mapY + dy), self.map.h - self.tilesDisplayHeight),
            1)
    print(self.mapX, self.mapY,
        self.tilesDisplayWidth, self.tilesDisplayHeight)
    if self.mapX ~= oldMapX or self.mapY ~= oldMapY then
        self:setupMapView()
        self:updateTilesetBatch()
    end
end

function SceneMap:wheelmoved(x, y)
    if lk.isDown("lctrl") or lk.isDown("rctrl") then
        x, y = y, x
    end
    self:moveMap(-x, -y)
end

function SceneMap:draw()
    lg.draw(
        self.tilesetBatch,
        floor(-self.zoomX*(self.mapX%1)*self.tileSize),
        floor(-self.zoomY*(self.mapY%1)*self.tileSize),
        0,
        self.zoomX,
        self.zoomY)
end

function SceneMap:set_zoom(v)
    local old_zoom_x = self.zoomX
    local old_zoom_y = self.zoomY

    if v > 0 then
        self.zoomX = min(self.zoomX * 2, 4)
        self.zoomY = min(self.zoomY * 2, 4)
    elseif v < 0 then
        self.zoomX = max(self.zoomX * 0.5, 0.25)
        self.zoomY = max(self.zoomY * 0.5, 0.25)
    end

    if self.zoomX == old_zoom_x and
       self.zoomY == old_zoom_y
    then
        return
    end

    self.mapX = self.mapX / old_zoom_x * self.zoomX
    self.mapY = self.mapY / old_zoom_y * self.zoomY
end

function SceneMap:keypressed(key)
    if key == "kp-" then
        print("zooming out")
        self:set_zoom(-1)
    elseif key == "kp+" then
        print("zooming in")
        self:set_zoom(1)
    elseif key == "d" then
        self.debug = not (self.debug or false)
    else
        return
    end
    self:moveMap(0, 0)
end

return SceneMap


