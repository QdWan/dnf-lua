local Properties = require('properties')

local map_containers = {}

-- ############
--   MapLink class
-- ############

local MapLink = {}
MapLink.__index = MapLink

setmetatable(
    MapLink,
    {
        __call = function (class, ...)
            local self = setmetatable({}, class)
            if self.initialize then
                self:initialize(...)
            end
            return self
        end
    }
)

function MapLink:initialize(t)
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

map_containers.MapLink = MapLink


-- ############
--   MapHeader class
-- ############

local MapHeader = {}
MapHeader.__index = MapHeader

setmetatable(
    MapHeader,
    {
        __call = function (class, ...)
            local self = setmetatable({}, class)
            if self.initialize then
                self:initialize(...)
            end
            return self
        end
    }
)

function MapHeader:initialize(t)
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

map_containers.MapHeader = MapHeader


-- ############
--   MapContainer class
-- ############

local MapContainer = {}
MapContainer.__index = MapContainer

setmetatable(
    MapContainer,
    {
        __call = function (class, ...)
            local self = setmetatable({}, class)
            if self.initialize then
                self:initialize(...)
            end
            return self
        end
    }
)

function MapContainer:initialize()
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

map_containers.MapContainer = MapContainer


-- ############
--   NodeGroup class
-- ############

local NodeGroup = class("NodeGroup"):include(Properties)

function NodeGroup:initialize(t)
    --[[Contain all the entities in a map position/node.

        Args:
            t (table): table containing the below keyword arguments.
            t.tile (TileEntity):
            t.feature ():
            t.objects ():
            t.creatures ():
        ]]--
        assert(t.tile)
        self._tile = t.tile
        self._feature = t.feature
        self._objects = t.objects or {}
        self._creatures = t.creatures or {}
end

function NodeGroup:getter_tile()
    return self._tile
end

function NodeGroup:setter_tile(v)
    self._tile = v
end

map_containers.NodeGroup = NodeGroup


-- ############
--   Position class
-- ############

local Position = {}
Position.__index = Position

setmetatable(
    Position,
    {
        __call = function (class, ...)
            local self = setmetatable({}, class)
            if self.initialize then
                self:initialize(...)
            end
            return self
        end
    }
)

function Position:initialize(x, y)
    --[[Contain x and y coordinates.

        Args:
            x (number): position relative to the horizontal axis.
            y (number): position relative to the vertical axis.
        ]]--
        self.x = x
        self.y = y
    return self
end

map_containers.Position = Position


return map_containers
