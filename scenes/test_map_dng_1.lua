-- singleview
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

local tile_pos_shadow_info = false


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
        creator = "MapDungeon01"
    }
    local creator = map_gen.creator.get(header)
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
    local tileset = manager.resources:tileset("TileEntity")
    self.image = tileset.atlas
    self.info_map = tileset.info_map
    local data = self.image:newImageData( )
    data:encode("tga","tile_test.tga")

    self:updateTilesetBatch()
end

function SceneMap:updateTilesetBatch()
    local mapX = self.mapX
    local mapY = self.mapY
    local map = self.map
    local tileSize = self.tileSize
    local max_x = self.tilesDisplayWidth-1
    local max_y = self.tilesDisplayHeight-1
    local min = min
    self.text = {}

    self.tilesetBatch = lg.newSpriteBatch(
        self.image, self.tilesDisplayWidth * self.tilesDisplayHeight * 2)

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
            local tile = map:get(x + mapX, y + mapY).tile
            local template = tile.template

            tile.tile_pos = 1
            if tile.tile_var == nil then
                local max_pos, max_var = manager.resources:get_tile_variations(
                    "TileEntity", template)
                tile.tile_var = tile.tile_var or math.random(max_var)
            end


            local sprite = manager.resources:tile(
                "TileEntity", template, tile.tile_pos, tile.tile_var)
            self.tilesetBatch:add(sprite.quad, x*tileSize, y*tileSize)
            local shadow = tile.receive_shadow
            if shadow then
                local shadow_sprite = manager.resources:tile(
                "TileEntity", shadow, tile.tile_pos_shadow + 1)
                self.tilesetBatch:add(
                    shadow_sprite.quad, x*tileSize, y*tileSize)
                self.text[#self.text + 1] = {
                    text=tostring(tile.tile_pos_shadow),
                    x=x*tileSize, y=y*tileSize
                }
            end

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

    if tile_pos_shadow_info then
        for _, text in ipairs(self.text) do
            love.graphics.print(
                text.text,
                text.x, text.y
            )
        end
    end
    --[[
    ]]--

    log:warn("SceneMap:draw is calling quit")
    love.event.quit()
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
    elseif key == "f1" then
        tile_pos_shadow_info = not tile_pos_shadow_info
    else
        return
    end
    self:moveMap(0, 0)
end

return SceneMap


