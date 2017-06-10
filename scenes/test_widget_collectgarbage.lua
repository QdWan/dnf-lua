local SceneBase = require("scenes.base")
local widgets = require("widgets")

local WidgetCollectgarbageTest = class("WidgetCollectgarbageTest", SceneBase)

function WidgetCollectgarbageTest:init()
    SceneBase.init(self)
end

function WidgetCollectgarbageTest:set_msg()
    self.frame = widgets.Frame({
        parent=self,
        -- bg_color={0, 0, 255, 255},
        rect=self.rect,
        z = 1
    })

    self.frame:row_config(1, 1)
    self.frame:col_config(1, 1)
    self.msg = widgets.Label({
        hover=false,
        parent=self.frame,
        text="Widget collectgarbage test",
        sticky="C",
        col=1,
        row=1,
        expand=true,
        font_size = 50,
        color = {200, 26, 15, 255},
    })

    self.frame:grid()

end

function WidgetCollectgarbageTest:update(dt)
    log.history = {}
    collectgarbage()
    log:warn("collectgarbage('count')", collectgarbage('count'))
    if not self.frame then
        log:warn("WidgetCollectgarbageTest creating widgets")
        self:set_msg()
    else
        return events:trigger({"SET_SCENE"}, "test_widget_collectgarbage")
    end
end

return WidgetCollectgarbageTest
