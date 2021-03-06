local creature = require("dnf.entities.creature")
local populator = require("dnf.populator")
local map_containers = require("dnf.map_containers")
local map_gen_creator = require("map_gen.creator")


local DATA_FILE = "save.zip"


local World = class("World")

function World:init(t)
    --[[The data of the game world in a given session.

    Args:
        t (table): table containing the below parameters.

        t.player (Creature): in case of a new game, the character created
            that will be controlled by the player should be passed.
]]--
    self:create(t)
end

function World:create(t)
    --[[Create a new World (game session)

    Args:
        t (table): table containing the below parameters.

        t.player (Creature): the character created that will be controlled by
            the player.
    ]]--
    t = t or {}
    self.player = t.player or creature.create_as_character()
    self.maps = map_containers.MapsContainer()
    local surface_header = t.header or map_containers.MapHeader{
        global_pos = map_containers.Position(0, 0),
        depth = 0,
        branch = 0,
        cr = 1,
        creator = "mapsurface01"
    }
    local creator = map_gen_creator.get(surface_header)
    local surface_map = creator(surface_header)

    populator.populate_surface(surface_map, surface_header)

    self.maps:add(surface_map)
    self.current_map = surface_map
end

function World.load(_, data_file)
    return bitser.loadLoveFile(data_file or DATA_FILE)
end

function World:save(data_file)
    data_file = data_file or DATA_FILE
    bitser.dumpLoveFile(data_file, self)
    return true
end

return World
