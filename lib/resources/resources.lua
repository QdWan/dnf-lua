local util = require("util")
local key_concat = util.key_concat
local tileset_templates = require("templates")
local crc32 = require("LAPHLibs.crc32").CRC32
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
    filename = assert(filename)
    abs = abs or "resources/images/"
    local image = self.images[filename]
    if image == nil then
        log:info("caching image:", filename)
        image = love.graphics.newImage(
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
    local count = 0
    local tiles = {}
    local sources = {}
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
        if name then count = count + 1
            -- log:warn(item)

            pos, var = tonumber(pos), tonumber(var)

            local pos_zero_start = pos_zero_start_t[name]
            if pos_zero_start == nil then
                pos_zero_start = pos == 0 and 1 or 0
                pos_zero_start_t[name] = pos_zero_start
            end
            pos = pos + pos_zero_start
            assert(pos > 0)
            positions[name] = max(positions[name] or 0, pos)

            local var_key = name .. "\0" .. pos
            local var_zero_start = var_zero_start_t[var_key]
            if var_zero_start == nil then
                var_zero_start = var == 0 and 1 or 0
                var_zero_start_t[var_key] = var_zero_start
            end
            var = var + var_zero_start
            assert(var > 0)
            local var_k = name .. "\0" .. pos
            variations[var_k] = max(positions[var_k] or 0, var)

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
            sources[#sources + 1] = tile
        end

    end
    return {sources=sources, count=count, positions=positions,
            variations=variations, group=group,
            crc=string.format("%08x", crc32(table.concat(id, "\0")))}
end

local function create_atlas_and_quads(tileset)
    local group, count, crc = tileset.group, tileset.count, tileset.crc
    local info_map = {}
    tileset.info_map = info_map
    local newQuad = love.graphics.newQuad
    local col, row = 0, 0
    local w, h, max_tiles_wide, atlas, atlas_data
    local resources = manager.resources
    local draw = love.graphics.draw

    local cache = tileset.atlas
    if not cache then
        max_tiles_wide = math.floor(
            lg.getSystemLimits().texturesize / 32)
        w = math.min(max_tiles_wide, count)
        h = math.ceil(count / w)
        assert(h * 32 < lg.getSystemLimits().texturesize)
        print("create_atlas width: %d, height: %d", w, h)
        atlas_data = love.image.newImageData(w * 32, h * 32)
        log:warn("creating canvas w, h, max_tiles_wide", w, h, max_tiles_wide)
    else
        w = cache:getWidth() / 32
        h = cache:getHeight() / 32
        max_tiles_wide = w
        log:warn("using cached canvas w, h, max_tiles_wide", w, h, max_tiles_wide)
    end

    for _, tile in ipairs(tileset.sources) do
        local tile_k = tile.key
        local x, y = col * 32, row * 32

        if not cache then
            local tile_img_data = resources:image_data(tile.file)
            atlas_data:paste(tile_img_data, x, y, 0, 0, 32, 32)
        end

        info_map[tile_k] = {
            x=x, y=y, quad = newQuad(x, y, 32, 32, w * 32, h * 32)}
        col = col + 1
        if col >= max_tiles_wide then
            col = 0
            row = row + 1
        end
    end
    if not cache then
        -- EXPORT THE TILESET TO SAVE TIME IN THE FUTURE
        atlas_data:encode("png", group .. "_" .. crc .. ".png")

        atlas = love.graphics.newImage(atlas_data)
        tileset.atlas = atlas
    end
end

local function load_cached_tileset(tileset)
    local group, crc = tileset.group, tileset.crc
    local filename = group .. "_" .. crc .. ".png"
    local abs = love.filesystem.getSaveDirectory()
    local path = abs .. "/" .. filename
    local cache = love.filesystem.exists(filename) and
                  manager.resources:image(filename, "")

    local png_pattern = "^(" .. group .. ")_[a-z0-9]+%.png$"

    for _, item in ipairs(love.filesystem.getDirectoryItems("/")) do
        local other_group = string.match(item, png_pattern)
        if item ~= filename and other_group and other_group == group then
            love.filesystem.remove(item)
            log:warn("removing outdated tileset: " .. item)
        end
    end

    if not cache then
        log:warn("couldn't find cache for " .. filename)
    else
        log:warn("recovering tileset cache " .. filename)
        tileset.atlas = cache
        return true
    end
end
local function load_tileset(group)
    local sub = tileset_templates[group]._default._folder
    local base_path = "resources/images/tilesets/" .. sub
    local tileset = load_tileset_files(sub, base_path, group)
    load_cached_tileset(tileset)
    create_atlas_and_quads(tileset)
    tileset.atlas:setFilter("nearest", "linear")
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
    local template = tileset_templates[group][name]
    local image_name = template.image
    local tileset = self:tileset(group)
    local var_k = image_name .. "\0" .. pos
    return tileset.variations[var_k]
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
        local template = tileset_templates[group][name]
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
