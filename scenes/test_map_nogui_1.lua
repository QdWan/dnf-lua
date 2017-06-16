local map_containers = require("dnf.map_containers")
local World = require("dnf.world")


world = world or World({
    header= map_containers.MapHeader{
    global_pos = map_containers.Position(0, 0),
    depth = 0,
    branch = 0,
    cr = 1,
    creator = "MapSurface01"
}})
return love.event.quit
