local SceneBase = require("scenes.base")
local widgets = require("widgets")
local Stateful = require("stateful")

local SceneMap = class("SceneMap", SceneBase)
SceneMap:include(Stateful)



function SceneMap:init(param)
    self.class.super.init(self)
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

function SceneMap:draw()
    self.class.super.draw(self)
    --[[

    log:warn("SceneMapSurfaceTest02:draw is calling quit")
    love.event.quit()
    ]]--
end

function SceneMap:keypressed(key)
    if key == "kp-" then
        print("zooming out")
        self.map_view:set_zoom(-1)
    elseif key == "kp+" then
        print("zooming in")
        self.map_view:set_zoom(1)
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
