local key_concat = require("util.key_concat")
local templates_data = require("data.templates_data")
local rect_packer = require("rect_packer")
local crc32 = require("crc32").CRC32
local lg = love.graphics
local lg_newImage = lg.newImage

local Resources = class("Resources")

function Resources:init()
    self.fonts = {_mode = "v"}
    self.images = {_mode = "v"}
    -- self.sounds = {_mode = "v"}
    self.tiles = {_mode = "v"}
    self.tilesets = {}
end

function Resources:font(filename, size)
    local key = key_concat(filename, size)
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

function Resources:image(filename, abs)
    --[[
    local caller = debug.getinfo(2)
    log:warn(caller.source, caller.linedefined)
    ]]--
    filename = assert(filename,
                      self.class.name .. ":image a file name is required")
    abs = abs or "resources/images/"
    local image = self.images[filename]
    if image == nil then
        log:info("caching image: " .. filename)
        image = lg_newImage(
            abs .. "/" .. filename
        )
        self._image = image
        self.images[filename] = image
    end
    return image
end

function Resources:image_data(filename, abs)
    filename = assert(filename)
    abs = abs or "resources/images/"
    return love.image.newImageData(abs .. "/" .. filename)
end

local function load_tileset_files(sub, path, group)
    local tiles = {}
    local positions = {}
    local variations = {}
    local pos_zero_start_t = {} -- adjustment for when 'pos' starts at zero
    local var_zero_start_t = {} -- adjustment for when 'var' starts at zero
    local zero_pos, zero_var
    local path_pattern = string.format("tilesets/%s", sub) .. "/%s"
    local png_pattern = "^(.+)#p_(%d+)#v_(%d+)%.png$"

    local max = math.max

    print(string.format("load_tileset_files(sub=%s, path=%s)", sub, path))

    local id = {}
    local Modified = love.filesystem.getLastModified
    local Size = love.filesystem.getSize

    for _, item in ipairs(love.filesystem.getDirectoryItems(path)) do
        local name, pos, var = item:match(png_pattern)
        if name then

            pos, var = tonumber(pos), tonumber(var)

            local pos_zero_start = pos_zero_start_t[name]
            if pos_zero_start == nil then
                pos_zero_start = pos == 0 and 1 or 0
                pos_zero_start_t[name] = pos_zero_start
            end
            pos = pos + pos_zero_start
            assert(pos > 0)
            positions[name] = max(positions[name] or 1, pos)

            local var_key = name .. "\0" .. pos
            local var_zero_start = var_zero_start_t[var_key]
            if var_zero_start == nil then
                var_zero_start = var == 0 and 1 or 0
                var_zero_start_t[var_key] = var_zero_start
            end
            var = var + var_zero_start
            assert(var > 0)
            local var_k = name .. "\0" .. pos
            variations[var_k] = max(positions[var_k] or 1, var)

            local info_map_k = name .. "\0" .. pos .. "\0" .. var
            local tile = {
                file=path_pattern:format(item),
                name=name,
                pos=pos,
                var=var,
                key=info_map_k,
            }
            local abs = path .. "/" .. item
            id[#id + 1] = Size(abs) .. abs .. Modified(abs)

            local info_map_k = name .. "\0" .. pos .. "\0" .. var
            tiles[#tiles + 1] = tile
        end
    end

    local crc = assert(string.format("%08x", crc32(table.concat(id, "\0"))))

    return {sources=tiles, positions=positions, variations=variations,
            group=group, crc=crc}
end

local function create_atlas_and_quads(tileset)
    local group, crc = tileset.group, tileset.crc
    assert(group and crc)
    local info_map = {}
    tileset.info_map = info_map
    local Quad = love.graphics.newQuad

    local w, h
    local draw = love.graphics.draw

    local cache = tileset.atlas
    local should_draw = not cache
    if not cache then
        w = lg.getSystemLimits().texturesize
        h = rect_packer.img_packer(w, nil, tileset.sources)
        assert(h <= w)
        cache = love.graphics.newCanvas(w, h)
        tileset.atlas = cache
        love.graphics.setCanvas(cache)
        log:warn("creating canvas width: " .. w, ", height: " .. h)
    else
        w = cache:getWidth()
        h = cache:getHeight()
        log:warn("using cached canvas width: " .. w, ", height: " .. h)
    end

    for _, tile in ipairs(tileset.sources) do
        local tile_k = tile.key
        local x, y = tile.x, tile.y
        assert(tile.w and tile.h, "invalid tile", 1,
               function() return inspect(tile) end)
        info_map[tile_k] = {x=x, y=y, quad=Quad(x, y, tile.w, tile.h, w, h)}
        if should_draw then
            draw(tile.img, tile.x, tile.y)
            tile.img = nil
        end
    end
    return not should_draw
end

local function load_tileset_atlas(tileset)
    local group, crc = tileset.group, tileset.crc
    local filename = group .. "_" .. crc .. ".png"
    local cache_path = "cache/" .. filename
    local cache = love.filesystem.exists(cache_path) and
                  manager.resources:image(filename, "cache/")

    local png_pattern = "^(" .. group .. ")_[a-z0-9]+%.png$"

    for _, item in ipairs(love.filesystem.getDirectoryItems("cache/")) do
        local other_group = string.match(item, png_pattern)
        if item ~= filename and other_group and other_group == group then
            love.filesystem.remove(item)
            log:warn("removing outdated tileset: " .. item)
        end
    end

    if not cache then
        log:warn("couldn't find cache for " .. cache_path)
    else
        log:warn("recovering tileset cache: " .. cache_path)
        tileset.atlas = cache
        return true
    end
end

local function load_tileset_data(group)
    local cache_path = "cache/"
    local dat_pattern = "^(" .. group .. ")_[a-z0-9]+%.dat$"
    for _, item in ipairs(love.filesystem.getDirectoryItems(cache_path)) do
        if string.find(item, dat_pattern) then
            log:warn("recovering tileset data:  cache/" .. item)
            return bitser.loadLoveFile("cache/" .. item)
        end
    end
    log:warn("couldn't find data for tileset: " .. group)
end

local function load_tileset(group)
    assert(templates_data[group])

    local sub = templates_data[group]._default._folder
    local base_path = "resources/images/tilesets/" .. sub
    local tileset

    local cache_data = load_tileset_data(group)
    if cache_data then
        tileset = cache_data
    else
        tileset = load_tileset_files(sub, base_path, group)
    end
    local crc = tileset.crc

    local had_cache_image = load_tileset_atlas(tileset)
    create_atlas_and_quads(tileset)

    if not cache_data then
        bitser.dumpLoveFile(
            "cache/" .. group .. "_" .. tileset.crc .. ".dat",
            {sources=tileset.sources, positions=tileset.positions,
             variations=tileset.variations, group=group,
             crc=crc}
         )
    end
    if not had_cache_image then
        assert(love.filesystem.createDirectory("cache"))
        -- EXPORT THE TILESET TO SAVE TIME IN THE FUTURE
        local atlas = tileset.atlas
        local atlas_data = atlas:newImageData()
        atlas_data:encode("png", "cache/" .. group .. "_" .. crc .. ".png")
        love.graphics.setCanvas()
        tileset.atlas = atlas
    end

    return tileset
end

function Resources:tileset(group)
    local tileset = self.tilesets[group]
    if tileset == nil then
        tileset = assert(load_tileset(group))
        self._tileset = tileset
        self.tilesets[group] = tileset
    end

    return tileset
end

function Resources:get_position_variations(group, name, pos)
    local image_name = assert(
        templates_data[group][name].image,
        string.format("invalid template: %s, %s, %d", group, name, pos))

    local tileset = self:tileset(group)
    local var_k = image_name .. "\0" .. pos
    return assert(tileset.variations[var_k], "something is wrong with this tile ".. var_k .. " pos " .. pos, 1, function() log:info(inspect(tileset.variations, {depth=1})); return "" end)
end

function Resources:get_tile_variations(group, name)
    error(string.format("%s:get_tile_variations is deprecated",
                           self.class.name))

end

function Resources:tile(group, name, pos, var)
    pos = tonumber(pos or 1)
    var = tonumber(var or 1)
    local key =  group .. "\0" .. name .. "\0" .. pos .. "\0" .. var
    local tile = self.tiles[key]
    if tile == nil then
        local tileset = self:tileset(group)
        local template = templates_data[group][name]
        local info_map_k = template.image .. "\0" .. pos .. "\0" .. var
        local atlas, info_map = tileset.atlas, tileset.info_map
        tile = assert(info_map[info_map_k], "invalid tile " .. info_map_k,
                      1)
        self._tile = tile
        self.tiles[key] = tile
    end
    return tile
end


return Resources
