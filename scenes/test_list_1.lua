local widgets = require("widgets")


single_test = not auto and true or false
local SceneTestBase = require("scenes.test_base")
auto.functions = {
    function(scene) scene:keypressed("tab") end,
    function(scene) scene:keypressed("tab") end
}


local SceneListTest1 = class("SceneListTest1", SceneTestBase)

function SceneListTest1:init()
    SceneTestBase.init(self) -- super
    self.frame = widgets.Frame({
        parent=self,
        -- bg_color={0, 0, 255, 255},
        rect=self.rect
    })
    self.frame:row_config(1, 1)  -- row=1, weight=1
    self.frame:col_config(1, 2)  -- col=1, weight=1
    self.frame:row_config(2, 1)  -- row=2, weight=1
    self.frame:row_config(3, 4)  -- row=2, weight=1


    self.title = widgets.Label({
        parent=self.frame,
        text="Dungeons & Fiends",
        font_size=32,
        bg_color={255, 0, 0, 255},
        col=1, row=1, sticky="S"
    })

    self.labels = widgets.List({
        parent=self.frame,
        padx=12,
        pady=10,
        col=1, row=3, sticky="NS",
        expand=true
    })
    self.labels:insert_list({
        "Name:",
        "Gender:",
        "Race:",
        "Class:",
        "Alignment:",
        "Age:",
        "Height:",
        "Weight:",
        "Strenght:",
        "Dexterity:",
        "Constitution:",
        "Intelligence:",
        "Wisdom:",
        "Charisma:"
    })
    --[[

    self.body:bind("MOUSERELEASED.1", function()
        print("pressed")
    end)
    ]]--

    self.frame:grid()
end

return SceneListTest1
