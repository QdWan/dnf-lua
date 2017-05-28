local map_containers = require("dnf.map_containers")
local Properties = require('properties')
local tile_templates = require("lib.templates")

local map_entities = {}


local function apply_template(entity)
    local keys = {}
    local default_table = tile_templates[entity.class.name]._default
    local template_table = tile_templates[entity.class.name][entity.template]
    for _, t in ipairs({template_table, default_table}) do
        for k, _ in pairs(t) do
            keys[k] = true
        end
    end
    for k, _ in pairs(keys) do
        entity[k] = template_table[k] or default_table[k]
    end
end


-- ##################
--   MapEntity class
-- ##################

local MapEntity = class('MapEntity'):include(Properties)

function MapEntity:initialize(t)
    --[[Generic map entity, supposed to be inherited by specific ones.

        Args:
            t (table): table containing the below keyword arguments.
    ]]--
    for k, v in pairs(t) do
        if v.owner ~= nil and v.owner == false then
            v.owner = self
        end
    end
end

function MapEntity:getter_x()
    return self.rect.x
end

function MapEntity:setter_x(v)
    self.rect.x = v
end

function MapEntity:getter_y()
    return self.rect.y
end

function MapEntity:setter_y(v)
    self.rect.y = v
end

function MapEntity:getter_pos()
    return map_containers.Position(self.x, self.y)
end

function MapEntity:setter_pos(v)
    self.rect.topleft = v
end

function MapEntity:getter_size()
    return self.rect.size
end

function MapEntity:getter_left()
    return self.rect.left
end

function MapEntity:getter_right()
    return self.rect.right
end

function MapEntity:getter_top()
    return self.rect.top
end

function MapEntity:getter_bottom()
    return self.rect.bottom
end

function MapEntity:getter_topleft()
    return self.rect.topleft
end

function MapEntity:getter_current_level()
    return self.scene.current_level
end

function MapEntity:getter_visible()
    local node = self.current_level:get(self.x, self.y)
    return node.tile.visible
end

map_entities.MapEntity = MapEntity


-- ############
--   TileEntity class
-- ############

local TileEntity = class('TileEntity', MapEntity)

function TileEntity:initialize(t)
    --[[Generic map entity, supposed to be inherited by specific ones.

        Args:
            t (table): table containing the below keyword arguments.
    ]]--
    MapEntity.initialize(self, t) -- super

    self.name = t.name
    self.color = t.color
    self.template = self.name
    apply_template(self)
end

map_entities.TileEntity = TileEntity


return map_entities
