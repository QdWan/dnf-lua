local widgets = require("widgets")

local single_test = not auto and true or false
local SceneBase = require("scenes.test_base")
auto.functions = {
    function(scene)
        log.history = {}
        collectgarbage()
        log:warn("collectgarbage('count')", collectgarbage('count'))
        log:warn("WidgetCollectgarbageTest creating widgets")
        scene:set_msg()
    end,
    function(scene)
        return events:trigger({"SET_SCENE"}, "test_widget_collectgarbage")
    end
}
auto.single_test = single_test


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


return WidgetCollectgarbageTest
