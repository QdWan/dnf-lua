local Widget = require("widgets.base")
local Stateful = require("stateful")
local templates = require("templates")


local MapView = class("MapView", Widget)
MapView:include(Stateful)
local MetaView = MapView:addState('MetaView')


function MapView:init(args)
    args = args or {}
    args.sticky = args.sticky or "NSWE"
    args.expand = args.expand or true
    Widget.init(self, args)
    self:setupTileset()
end

function MapView:grid()
    self:setupMapView()
    self:updateTilesetBatch()
end

function MapView:updateMapSize()
    self.horizontal_tiles = math.min(math.ceil(
        (self.w / (self.tileSize * self.zoomX))), self.map.w)
    self.vertical_tiles = math.min(math.ceil(
        (self.h / (self.tileSize * self.zoomY))), self.map.h)
    log:info(self.class.name, "updateMapSize",
             "horizontal_tiles", self.horizontal_tiles,
             "vertical_tiles",   self.vertical_tiles)
end

function MapView:setupMapView()
    self.map = assert(world.current_map)
    self.tileSize = 32

    self.view = self.view or 0
    self.zoomX = self.zoomX or 0.5
    self.zoomY = self.zoomY or 0.5

    self:updateMapSize()

    self.mapX = math.max(
        math.min(self.mapX or 1, self.map.w - self.horizontal_tiles),
        1)
    self.mapY = math.max(
        math.min(self.mapY or 1, self.map.h - self.vertical_tiles),
        1)
end

function MapView:setupTileset()
    local tileset = manager.resources:tileset("TileEntity")
    self.tiles_atlas = tileset.atlas
    self.tiles_info = tileset.info_map
end

function MapView:updateTilesetBatch()
    local mapX = self.mapX
    local mapY = self.mapY
    local map = self.map
    local map_w, map_h = map.w, map.h
    local tiles = map.tiles
    local tileSize = self.tileSize
    local max_x = self.horizontal_tiles-1
    local max_y = self.vertical_tiles-1
    local lg = love.graphics
    local resources = manager.resources
    self.tile_debug = {}
    self.shadow_debug = {}
    local floor = math.floor
    self.tiles_batch = lg.newSpriteBatch(
        self.tiles_atlas, self.horizontal_tiles * self.vertical_tiles)
    local tiles_batch = self.tiles_batch

    local meta = self.view ~= 0
    -- log:warn("meta", self.view, meta, template_k, id_k, color_k)

    for x = 0, max_x do
        for y = 0, max_y do
            local i = (((y + mapY) - 1) * map_w) + (x + mapX)
            assert(i > 0 and i <= map_w * map_h, "invalid node")
            local tile = tiles[i]

            local quad, color, tile_debug = self:get_tile_quad(tile, meta)
            tiles_batch:setColor(color)

            tiles_batch:add(quad, floor(x*tileSize), floor(y*tileSize))

            if tile_debug then
                tile_debug.x, tile_debug.y = x*tileSize, y*tileSize
                self.tile_debug[#self.tile_debug + 1] = tile_debug
            end

            local shadow = false and tile.receive_shadow
            if shadow then
                local shadow_sprite = resources:tile(
                "TileEntity", shadow, tile.tile_pos_shadow + 1)
                tiles_batch:add(
                    shadow_sprite.quad, x*tileSize, y*tileSize)
                self.shadow_debug[#self.shadow_debug + 1] = {
                    text=tile.tile_pos_shadow,
                    x=x*tileSize, y=y*tileSize
                }
            end

        end
    end
    self.tiles_batch:flush()
end

-- central function for moving the map
function MapView:moveMap(dx, dy, force_update)
    local oldMapX = self.mapX
    local oldMapY = self.mapY
    self.mapX = math.floor(math.max(math.min(self.mapX + dx,
                                  self.map.w - self.horizontal_tiles),
                         1))
    self.mapY = math.floor(math.max(math.min(self.mapY + dy,
                                  self.map.h - self.vertical_tiles),
                         1))
    print(self.mapX, self.mapY, self.horizontal_tiles, self.vertical_tiles)
    if force_update or self.mapX ~= oldMapX or self.mapY ~= oldMapY then
        self:setupMapView()
        self:updateTilesetBatch()
    end
    self.changed = true
end

function MapView:draw_debug_info(scale)
    for _, text in ipairs(self.tile_debug) do
        lg.setColor(text.color)
        lg.print(text.text,
                 not scale and text.x or
                 math.floor(self.zoomX*text.x),
                 not scale and text.y or
                 math.floor(self.zoomY*text.y),
                 0,
                 scale and self.zoomX or 1,
                 scale and self.zoomY or 1)
    end
end

function MapView:draw()
    local lg = love.graphics

    lg.setColor({255, 255, 255, 255})
    if self.zoomX < 1 then
        lg.draw(
            self.tiles_batch,
            math.floor(-self.zoomX*(self.mapX%1)*self.tileSize),
            math.floor(-self.zoomY*(self.mapY%1)*self.tileSize),
            0,
            self.zoomX,
            self.zoomY)
        if self.debug_tile_info then self:draw_debug_info(true) end
    else
        if not self.canvas or self.changed then
            self.canvas = self.canvas or lg.newCanvas(self.w, self.h)
            -- drawing to the canvas
            lg.setCanvas(self.canvas)
            lg.clear()

            lg.draw(
                self.tiles_batch,
                math.floor(-self.zoomX*(self.mapX%1)*self.tileSize),
                math.floor(-self.zoomY*(self.mapY%1)*self.tileSize),
                0)

            if self.debug_tile_info then self:draw_debug_info(false) end
            -- re-enable drawing to the main screen
            lg.setCanvas()
        end
        self.canvas:setFilter("nearest", "linear")
        lg.setColor({255, 255, 255, 255})
        lg.draw(self.canvas, 0, 0, 0, self.zoomX, self.zoomY)
    end

end

function MapView:switch_view(reversed)
    log:warn("MapView:switch_view reversed", reversed)
    local v = reversed and -1 or 1
    self.view = (self.view + v) % #self.map.views
    local meta = self.view ~= 0 and 'MetaView' or nil
    self:gotoState(meta)

    self:setupMapView()
    self:updateTilesetBatch()
end

function MapView:scroll(dx, dy)
    dx = (1 / self.zoomX) * dx
    dy = (1 / self.zoomY) * dy
    log:info(self.class.name, "scroll dx, dy", dx, dy)
    self:moveMap(dx, dy)
end

function MapView:set_zoom(v)
    local old_zoom_x = self.zoomX
    local old_zoom_y = self.zoomY

    if v > 0 then
        self.zoomX = math.min(self.zoomX * 2,   2)
        self.zoomY = math.min(self.zoomY * 2,   2)
    elseif v < 0 then
        self.zoomX = math.max(self.zoomX * 0.5, 1/4)
        self.zoomY = math.max(self.zoomY * 0.5, 1/4)
    end

    if self.zoomX == old_zoom_x and self.zoomY == old_zoom_y then
        return
    end
    log:warn("new zoom is " .. self.zoomX)

    local old_center_x = (self.mapX + (self.horizontal_tiles / 2))
    local old_center_y = (self.mapY + (self.vertical_tiles   / 2))
    self:setupMapView()
    self.mapX = old_center_x - (self.horizontal_tiles / 2)
    self.mapY = old_center_y - (self.vertical_tiles / 2)
    self:moveMap(0, 0)
end

function MapView:get_tile_quad(tile)
    local resources = manager.resources
    local template_enum = tile.template
    local template = templates.enum.TileEntity[template_enum]
    local template_name = template._key
    local color, tile_debug

    local tile_pos = tile.tile_pos
    if tile_pos == 0 then
        if template.image == "ascii" then
            tile_pos = template.id
        else
            tile_pos = 1
        end
        tile.tile_pos = tile_pos
    end

    local tile_var =  tile.tile_var
    if tile_var == 0 then
        tile_var = math.random(
            resources:get_position_variations(
                "TileEntity", template_name, tile_pos))
        tile.tile_var = tile_var
    end

    if template.image == "ascii" then
        color = template.color
    else
        color = {255, 255, 255}
        tile_debug = {
            text=tile_pos,
            color=template.label_color
        }
    end

    -- cache or load cached quad
    template.cache = template.cache or {}
    local quad_key = tile_pos .. "\0" .. tile_var
    local quad = template[quad_key]
    if quad == nil then
        local sprite = resources:tile(
            "TileEntity", template_name, tile_pos, tile_var)
        quad = sprite.quad
        template[quad_key] = quad
    end

    return quad, color, tile_debug, template, quad_key
end

function MetaView:get_tile_quad(tile)
    local resources = manager.resources
    local map = self.map
    local color, tile_debug
    local meta = tile.meta

    local view = map.views[self.view + 1]
    local template_k = view .. "template"
    local color_k = view .. "color"

    local template_enum = meta[template_k]
    local template = templates.enum.TileEntity[template_enum]
    local tile_pos = template.id
    local tile_var = 1

    local color = meta[color_k]
    color = {color.r, color.g, color.b}

    -- cache or load cached quad
    template.cache = template.cache or {}
    local quad_key = tile_pos .. "\0" .. tile_var
    local quad = template[quad_key]
    if quad == nil then
        local sprite = resources:tile(
            "TileEntity", "_default", tile_pos, tile_var)
        quad = sprite.quad
        template[quad_key] = quad
    end


    return quad, color, tile_debug, template, quad_key
end

return MapView
