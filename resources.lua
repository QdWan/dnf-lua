local util = require("lib.util")
local tileset_templates = require("lib.templates")

local lg = love.graphics

local Resources = class("Resources")

function Resources:init()
    self.fonts = {_mode = "v"}
    self.images = {_mode = "v"}
    -- self.sounds = {_mode = "v"}
    self.tiles = {_mode = "v"}
    self.tilesets = {}
end

function Resources:font(filename, size)
    local key = filename .. ";" .. tostring(size)
    local font = self.fonts[key]
    if font == nil then
        print("caching font:", key)
        font = love.graphics.newFont(
            "resources/fonts/" .. filename, size)
        self._font = font
        self.fonts[key] = font
    end
    return font
end

function Resources:image(t)
    local filename
    if type(t) == "string" then
        filename = t
    else
        filename = t.filename
    end
    local print = t.verbose and print or function() end
    local image = self.images[filename]
    if image == nil then
        print("caching image:", filename)
        image = love.graphics.newImage(
            "resources/images/" .. filename
        )
        self._image = image
        self.images[filename] = image
    end
    return image
end

local function load_tileset_files(sub, path)
    local count = 0
    local tiles = {}
    local info_map = {}
    local zero_pos, zero_var
    print(string.format("load_tileset_files(sub=%s, path=%s)", sub, path))
    for _, item in ipairs(love.filesystem.getDirectoryItems(path)) do
        local pattern = "^(.+)#p_(%d+)#v_(%d+)%.png$"
        local name, pos, var = string.match(item, pattern)
        if name then count = count + 1
            pos = tonumber(pos)
            var = tonumber(var)
            -- first item of the group
            if info_map[name] == nil then
                zero_pos = pos == 0 and 1 or 0
                zero_var = var == 0 and 1 or 0
            end
            local proper_pos = pos + zero_pos
            local proper_var = var + zero_var
            local tile = {
                file=string.format("tilesets/%s/%s", sub, item),
                name=name,
                pos=proper_pos,
                var=proper_var
            }

            info_map[name] = info_map[name] or {}
            info_map[name].pos = math.max(info_map[name].pos or 1, proper_pos)
            info_map[name].var = math.max(info_map[name].var or 1, proper_var)
            tile.img = manager.resources:image(
                {filename=tile.file, verbose=false}
            )
            tiles[#tiles + 1] = tile
        end
    end
    return info_map, tiles, count
end

local function create_atlas(info_map, tiles, count)
    local max_tiles_wide = math.floor(lg.getSystemLimits().texturesize / 32)
    local width = math.min(max_tiles_wide, count)
    local height = math.ceil(count / width)
    print("width: %d, height: %d", width, height)
    local atlas = love.graphics.newCanvas(width * 32, height * 32)
    local col, row = 0, 0
    love.graphics.setCanvas(atlas)
    love.graphics.clear()
    love.graphics.setBlendMode("alpha")
    for _, tile in ipairs(tiles) do
        local key =  util.cantor(tile.pos, tile.var)
        local x, y = col * 32, row * 32
        info_map[tile.name][key] = {x=x, y=y}
        love.graphics.draw(tile.img, x, y)
        col = col + 1
        if col >= max_tiles_wide then
            col = 0
            row = row + 1
        end
        -- print(tile.name, x, y)
    end
    --[[
    local data = atlas:newImageData( )
    data:encode("tga","tile_test.tga")
    ]]--
    love.graphics.setCanvas()
    return atlas
end

local function create_quads(atlas, info_map)
    -- print(inspect(info_map))
    for tile_name, tile_value in pairs(info_map) do
        for key, tile in pairs(tile_value) do
            if key ~= "pos" and key ~= "var" then
                -- print(key, "tile:", inspect(tile))
                tile.quad = love.graphics.newQuad(
                    tile.x, tile.y, 32, 32,
                    atlas:getWidth(), atlas:getHeight())
            end
        end
    end
end

local function load_tileset(group)
    local sub = tileset_templates[group]._default._folder
    local base_path = "resources/images/tilesets/" .. sub
    local info_map, tiles, count = load_tileset_files(sub, base_path)
    local atlas = create_atlas(info_map, tiles, count)
    create_quads(atlas, info_map)
    return atlas, info_map
end

function Resources:tileset(group)
    local tileset = self.tilesets[group]
    if tileset == nil then
        local atlas, info_map = load_tileset(group)
        tileset = {atlas=atlas, info_map=info_map}
        self._tileset = tileset
        self.tilesets[group] = tileset
    end
    return tileset
end

function Resources:get_tile_variations(group, name)
    local template = tileset_templates[group][name]
    local image_name = template.image
    local tileset = self:tileset(group)
    local atlas, info_map = tileset.atlas, tileset.info_map
    local tile = info_map[image_name]
    if tile == nil then
        error(string.format("invalid tile %s", image_name))
    end
    local pos, var = tile.pos, tile.var
    return pos, var
end

function Resources:tile(group, name, pos, var)
    pos = pos or 1
    var = var or 1
    local key =  string.format("%s;%s;%03d;%03d", group, name, pos, var)
    local tile = self.tiles[key]
    if tile == nil then
        local tileset = self:tileset(group)
        local template = tileset_templates[group][name]
        local sub_key =  util.cantor(pos, var)
        local atlas, info_map = tileset.atlas, tileset.info_map
        --[[
        print("info_map:")
        print(inspect(info_map))
        ]]--
        tile = info_map[template.image][sub_key]
        assert(tile, string.format(
            "group: %s, name: %s, pos: %d, var: %d, key: %s, sub_key: %s",
            group, name, pos, var, key, sub_key))
        self._tile = tile
        self.tiles[key] = tile
    end
    return tile
end


return Resources
