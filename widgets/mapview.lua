local Widget = require("widgets.base")

local MapView = class("MapView", Widget)

local pos_var = {}

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
    log:warn(self.class.name, "updateMapSize",
             "horizontal_tiles", self.horizontal_tiles,
             "vertical_tiles",   self.vertical_tiles)
end

function MapView:setupMapView()
    self.map = assert(world.current_map)
    self.tileSize = 32

    self.view = self.view or 1
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
    local tileSize = self.tileSize
    local max_x = self.horizontal_tiles-1
    local max_y = self.vertical_tiles-1
    local lg = love.graphics
    local resources = manager.resources
    self.text = {}

    self.tiles_batch = lg.newSpriteBatch(
        self.tiles_atlas, self.horizontal_tiles * self.vertical_tiles)
    local tiles_batch = self.tiles_batch

    local meta = self.view ~= 1
    local view = meta and map.views[self.view] or ""
    local template_k = view .. "template"
    local id_k = view .. "id"
    local color_k = view .. "color"
    log:warn("meta", self.view, meta, template_k, id_k, color_k)

    for x = 0, max_x do
        for y = 0, max_y do
            local node = assert(map:get(x + mapX, y + mapY), string.format(
                "invalid node index x %d, y %d", x + mapX, y + mapY))
            local tile = meta and node.tile.meta or node.tile

            local sprite = tile.sprite
            if sprite == nil then
                local template = tile[template_k]

                local tile_pos
                if meta or tile.image == "ascii" then
                    tile_pos = tile[id_k]
                else
                    tile_pos = tile.tile_pos or 1
                end
                tile.tile_pos = tile.tile_pos or tile_pos

                local tile_var = meta and 1 or tile.tile_var or math.random(
                    resources:get_position_variations("TileEntity", template,
                                                      tile_pos))
                tile.tile_var = tile.tile_var or tile_var


                sprite = resources:tile(
                    "TileEntity", template, tile_pos, tile_var)
                tile.sprite = sprite
            end

            if meta or tile.image == "ascii" then
                local c = tile[color_k]
                tiles_batch:setColor(c[1], c[2], c[3], 255)
            else
                tiles_batch:setColor(255, 255, 255, 255)
            end

            tiles_batch:add(sprite.quad,
                            math.floor(x*tileSize),
                            math.floor(y*tileSize))
            local shadow = tile.receive_shadow
            if shadow then
                local shadow_sprite = resources:tile(
                "TileEntity", shadow, tile.tile_pos_shadow + 1)
                tiles_batch:add(
                    shadow_sprite.quad, x*tileSize, y*tileSize)
                self.text[#self.text + 1] = {
                    text=tostring(tile.tile_pos_shadow),
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

function MapView:draw()
    local lg = love.graphics

    if true or self.zoomX < 1 then
        lg.setColor({255, 255, 255, 255})
        lg.draw(
            self.tiles_batch,
            math.floor(-self.zoomX*(self.mapX%1)*self.tileSize),
            math.floor(-self.zoomY*(self.mapY%1)*self.tileSize),
            0,
            self.zoomX,
            self.zoomY)
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

            if self.tile_pos_shadow_info then
                for _, text in ipairs(self.text) do
                    lg.print(text.text, text.x, text.y)
                end
            end
            -- re-enable drawing to the main screen
            lg.setCanvas()
        end
        lg.draw(self.canvas, 0, 0, 0, self.zoomX, self.zoomY)
    end

end

function MapView:scroll(dx, dy)
    dx = (1 / self.zoomX) * dx
    dy = (1 / self.zoomY) * dy
    log:warn(self.class.name, "scroll dx, dy", dx, dy)
    self:moveMap(dx, dy)
end

function MapView:set_zoom(v)
    local old_zoom_x = self.zoomX
    local old_zoom_y = self.zoomY

    if v > 0 then
        self.zoomX = math.min(self.zoomX * 2,   1)
        self.zoomY = math.min(self.zoomY * 2,   1)
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


return MapView
