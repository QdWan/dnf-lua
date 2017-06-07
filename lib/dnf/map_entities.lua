local map_containers = require("dnf.map_containers")
local tile_templates = require("templates")

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

local MapEntity = class('MapEntity')

function MapEntity:init(t)
    --[[Generic map entity, supposed to be inherited by specific ones.

        Args:
            t (table): table containing the below keyword arguments.
    ]]--
    for k, v in pairs(t) do
        if v and v.owner and v.owner == false then v.owner = self end
    end
end

map_entities.MapEntity = MapEntity


-- ############
--   TileEntity class
-- ############

local TileEntity = class('TileEntity', MapEntity)
local first_run = {}

function TileEntity:init(t)
    --[[Generic map entity, supposed to be inherited by specific ones.

        Args:
            t (table): table containing the below keyword arguments.
    ]]--
    MapEntity.init(self, t) -- super

    for k, v in next, t, nil do
        if not first_run[k] then
            first_run[k] = v
            log:warn("TileEntity:init", k, v)
        end
        self[k] = v
    end

    self.template = self.name
    apply_template(self)
end

map_entities.TileEntity = TileEntity


return map_entities
