local SceneBase = require("scenes.base")
local widgets = require("widgets")
local SceneMainMenu = class("SceneMainMenu", SceneBase)

function SceneMainMenu:initialize()
    self.class.super.initialize(self)
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
    self.frame = widgets.Frame({
        parent=self,
        -- bg_color={0, 0, 255, 255},
        rect=self.rect,
        z = 2
    })
    self.frame:row_configure(1, 2)  -- row=1, weight=1
    self.frame:col_configure(1, 2)  -- col=1, weight=1
    self.frame:row_configure(2, 1)  -- row=2, weight=1
    self.frame:row_configure(3, 4)  -- row=2, weight=1

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
    })
    self.title:grid_config{col=1, row=1, sticky="S"}
    print("title", self.title)

    self.body = widgets.Label({
        parent=self.frame,
        text="Options",
        font_obj=manager.resources:font("caladea-regular.ttf", 54),
        color={223, 223, 223, 255}
    })
    self.body:grid_config{col=1, row=3, sticky="N"}

    self.frame:grid()
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
        if bg.h > rect.h and bg.bottom > rect.bottom then
            bg.y = bg.y - k
            bg.bottom = math.max(bg.bottom, rect.bottom)
        else
            self.bg_direction = "RIGHT"
            self.time = 0
        end
    elseif self.bg_direction == "RIGHT" then
        local k = dt * 80
        if bg.w > rect.w and bg.right > rect.right then
            bg.x = bg.x - k
            bg.right = math.max(bg.right, rect.right)
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
