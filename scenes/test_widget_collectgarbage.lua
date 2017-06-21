local widgets = require("widgets")

single_test = not auto and true or false
local SceneTestBase = require("scenes.test_base")
auto.functions = {
    function(scene)
        collectgarbage()
        log:warn("collectgarbage('count')", collectgarbage('count'))
        log:warn("SceneWidgetCollectgarbageTest creating widgets")
        scene:set_msg()
    end,
    function(scene)
        return events:trigger({"SET_SCENE"}, "test_widget_collectgarbage")
    end
}


local SceneWidgetCollectgarbageTest = class("SceneWidgetCollectgarbageTest", SceneTestBase)

function SceneWidgetCollectgarbageTest:init()
    SceneTestBase.init(self)
end

function SceneWidgetCollectgarbageTest:set_msg()
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


return SceneWidgetCollectgarbageTest
