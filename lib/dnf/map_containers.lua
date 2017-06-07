local map_containers = {}

-- ############
--   MapLink class
-- ############

local MapLink = class("MapLink")
map_containers.MapLink = MapLink

function MapLink:init(t)
    --[[Used by map transition entities and effects (e.g.: stairs)..

        Args:
            t (table): table containing the below keyword arguments.
            t.h (MapHeader): which map this link is located.
            t.pos (number): where this link is located.
            t.to_header (MapHeader): which map this link connects to.
            t.to_pos (number): where this link connects to.
    ]]--
    self.header = t.header
    self.pos = t.pos
    self.to_header = t.to_header
    self.to_pos = t.to_pos
    return self
end

function MapLink:get_mirrored()
    --[[Return a new MapLink instance for the other side of this link.
    ]]--
    return MapLink({
        header=self.to_header, pos=self.to_pos,
        to_header=self.header, to_pos=self.pos
    })
end

function MapLink:__tostring()
    return string.format("MapLink(from_h=%s, from_pos=%s)",
                         self.from_h, self.from_pos)
end



-- ############
--   MapHeader class
-- ############

local MapHeader = class("MapHeader")
map_containers.MapHeader = MapHeader

function MapHeader:init(t)
    --[[Hold essential information to identify each unique map.

    It is used as a key for each map in MapContainer and by any MapLink.
    Contain additional meta-map information used by the map creators..

        Args:
            t (table): table containing the below keyword arguments.
            t.global_pos (table): table containing the X and Y coordinates
                relative to surface map. The surface map itself have a nil value instead of the table.
            t.depth (number): Depth of the map. Surface areas have depth 0,
                dungeons maps depth (i.e. level) increase the further away they are from the surface.
            t.branch (number): Sequential number identifying multiple
                branches of a map at a given depth. Starts at 0.
            t.cr (number): Challenge rating of the map. Used to populate the
                map.
            t.creator (string): The name of the generator used to
                create the map.
            t.theme (string): Used to create certain types of themed
                maps (e.g. a flooded level, a forest, a crypt). Also used to
                populate the map. *TODO*: implement.
            t.links (table): Table of MapLink(s) for connected map(s).
        ]]--
    self.global_pos = t.global_pos
    self.depth = t.depth
    self.branch = t.branch
    self.cr = t.cr
    self.creator = t.creator
    self.theme = t.theme
    self.links = t.links or {}

    -- *TODO* use hash
    self.key = {self.global_pos.x, self.global_pos.y, self.depth, self.branch}
    return self
end

function MapHeader:__tostring()
    return string.format(
        "MapHeader(global_pos=(%d, %d), depth=%d, branch=%d, creator=%s)",
        self.global_pos.x, self.global_pos.y, self.depth, self.branch,
        self.creator)
end


-- ############
--   MapContainer class
-- ############

local MapContainer = class("MapContainer")
map_containers.MapContainer = MapContainer

function MapContainer:init()
    --[[Hold the game maps of the game session.

    Acts as a interface to load/add a map and provides methods to work with
    them..

        Attributes:
            _maps (table): table of MapHeader keywords with Map values.
            current (Map): access to the currently loaded map.
        ]]--
    self._maps = {}
    self.current = nil
    return self
end

function MapContainer:add(map)
    --[[Add a new map.
    ]]--
    self._maps[map.header.key] = map
end

function MapContainer:set(map)
    --[[Set the current map.
    ]]--
    self.current = self._maps[map.header.key]
end


-- ############
--   NodeGroup class
-- ############

local NodeGroup = class("NodeGroup")
map_containers.NodeGroup = NodeGroup

function NodeGroup:init(t)
    --[[Contain all the entities in a map position/node.

        Args:
            t (table): table containing the below keyword arguments.
            t.tile (TileEntity):
            t.feature ():
            t.objects ():
            t.creatures ():
        ]]--
        self.tile = t.tile
        self.feature = t.feature
        self.objects = t.objects or {}
        self.creatures = t.creatures or {}
end


-- ############
--   Position class
-- ############

local Position = class("Position")
map_containers.Position = Position

function Position:init(x, y)
    --[[Contain x and y coordinates.

        Args:
            x (number): position relative to the horizontal axis.
            y (number): position relative to the vertical axis.
        ]]--
        self.x = x
        self.y = y
end


return map_containers
