local SceneBase = require("scenes.base")
local widgets = require("widgets")
local SceneMainMenu = class("SceneMainMenu", SceneBase)

function SceneMainMenu:init()
    SceneBase.init(self)
    self.time = 0

    self:set_music()
    self:set_background()
    self:set_menu()
end

function SceneMainMenu:set_music()
    self.bgm = manager.audio:load(
        "resources/sounds/Steps_of_Destiny(Alexandr_Zhelanov).ogg",
        "stream", false)
    manager.audio:play_m(self.bgm)
end

function SceneMainMenu:set_background()
    self.bg_frame = widgets.Frame({
        parent=self,
        rect=self.rect,
        z=1
        })
    self.bg = widgets.Image({
        parent=self.bg_frame,
        path='Environments-21-cave.jpg'
        })
end

function SceneMainMenu:set_menu()
    self.menu_label_names = {"New", "Options", "Gallery", "Quit", }

    self.frame = widgets.Frame({
        parent=self,
        -- bg_color={0, 0, 255, 255},
        rect=self.rect,
        z = 2
    })
    self.frame:row_config(1, 1)
    self.frame:col_config(1, 2)
    self.frame:row_config(2, 1)
    self.frame:row_config(3, 1.5 * #self.menu_label_names)

    self.title = widgets.Label({
        hover=false,
        parent=self.frame,
        coloredtext={
            {200, 26, 15, 255}, "D",
            {7, 12, 10, 255}, "ungeons & ", -- {223, 223, 223, 255}
            {200, 26, 15, 255}, "F",
            {7, 12, 10, 255}, "iends"
        },
        text="Dungeons & Fiends",
        -- text="Dungeons & Fiends",
        font_obj=manager.resources:font("EG_Dragon_Caps.ttf", 44),
        col=1,
        row=1,
        sticky="S"
    })

    self.menu = widgets.List({
        parent=self.frame,
        sticky="NWSE",
        align="C",
        col=1,
        row=3,
        expand=true,
        font_size = 54,
        pady = 0

    })

    self.menu_labels = self.menu:insert_list_get_dict(self.menu_label_names)
    self.menu_labels["Quit"]:bind(
        {"MOUSERELEASED.1", "MOUSERELEASED.2"},
        love.event.quit
    )
    self.menu_labels["New"]:bind(
        {"MOUSERELEASED.1", "MOUSERELEASED.2"},
        function() events:trigger({'SET_SCENE'}, 'creation') end
    )
    self.frame:grid()
end

function SceneMainMenu:unload()
    log:warn("collectgarbage('count')", collectgarbage('count'))
    log:warn("SceneMainMenu:unload")
    self.bgm:stop()
    self.bgm = nil
    SceneBase.unload(self)
    self.frame:destroy()
    self.bg_frame:destroy()
    collectgarbage()
    log:warn("collectgarbage('count')", collectgarbage('count'))

end

function SceneMainMenu:scroll_bg(dt)
    local rect = self.rect
    local bg = self.bg

    if self.bg_direction == nil then
        if self.time > 5 then
            self.bg_direction = "DOWN"
        else
            self.time = self.time + dt / 2
        end
    elseif self.bg_direction == "DOWN" then
        local k = dt * 40
        if bg.h > rect.h and bg:get_bottom() > rect:get_bottom() then
            bg.y = bg.y - k
            bg:set_bottom(math.max(bg:get_bottom(), rect:get_bottom()))
        else
            self.bg_direction = "RIGHT"
            self.time = 0
        end
    elseif self.bg_direction == "RIGHT" then
        local k = dt * 80
        if bg.w > rect.w and bg:get_right() > rect:get_right() then
            bg.x = bg.x - k
            bg:set_right(math.max(bg:get_right(), rect:get_right()))
        else
            if self.time > 10 then
                self.bg_direction = "LEFT"
            else
                self.time = self.time + dt / 2
            end
        end
    elseif self.bg_direction == "LEFT" then
        local k = dt * 80
        if bg.w > rect.w and bg.x < 0 then
            bg.x = bg.x + k
            bg.x = math.min(bg.x, 0)
        else
            self.bg_direction = "TOP"
        end
    elseif self.bg_direction == "TOP" then
        local k = dt * 40
        if bg.h > rect.h and bg.y < 0 then
            bg.y = bg.y + k
            bg.y = math.min(bg.y, 0)
        else
            self.bg_direction = nil
            self.time = 0
        end
    end
end

function SceneMainMenu:update(dt)
    self:scroll_bg(dt)
end

return SceneMainMenu
