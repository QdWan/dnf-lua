local SceneBase = require("scenes.base")
local widgets = require("widgets")
-- local Stateful = require("stateful")

local SceneMap = class("SceneMap", SceneBase)
-- SceneMap:include(Stateful)



function SceneMap:init(param)
    SceneBase.init(self)
    self:create_widgets(param)
end

function SceneMap:create_widgets(param)
    self.frame = widgets.Frame({
        parent=self,
        rect=self.rect,
        z=1,
        disabled=true
        })
    self.map_view = widgets.MapView({
        parent=self.frame,
        col=1,
        row=1,
    })
    self.frame:row_config(1, 1)
    self.frame:col_config(1, 1)
    self.frame:grid()
end

function SceneMap:update()
    SceneMap.super.update(self)
end

function SceneMap:draw()
    SceneBase.draw(self)
end

function SceneMap:keypressed(key)
    local isDown = love.keyboard.isDown
    if key == "kp-" then
        self.map_view:set_zoom(-1)
    elseif key == "kp+" then
        self.map_view:set_zoom(1)
    elseif key == "tab" then
        self.map_view:switch_view(isDown("lshift") or isDown("rshift"))
    elseif key == "f1" then
        self.map_view.debug_tile_info = not self.map_view.debug_tile_info
    else
        return
    end
end

function SceneMap:wheelmoved(x, y, dx, dy)
    if love.keyboard.isDown("lctrl") or love.keyboard.isDown("rctrl") then
        dx, dy = dy, dx
    end
    self.map_view:scroll(-dx, -dy)
end

return SceneMap
