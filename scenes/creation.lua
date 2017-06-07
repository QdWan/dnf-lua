local SceneBase = require("scenes.base")
local widgets = require("widgets")
local SceneCreation = class("SceneCreation", SceneBase)
local creature = require("dnf.creature")
local dnf_data = require("data.core")
local util = require("util")
local time = require("time")
local descriptions = require("lib.descriptions")()

local player, values, update_values, selected_row, description, rows,
    labels_table

local details = false
local grey = {127, 127, 127, 255}
local bonus = 1

local callbacks = {mt = {}}

local function change_att(event)
    local v = type(event) == "table" and -event.dy or event
    local a = selected_row - 8
    local b = ((a + v - 1) % 6) + 1
        player._base_att[a], player._base_att[b] =
        player._base_att[b], player._base_att[a]
    update_values()
end

local function change_name(event)
    if type(event) ~= "table" then
        creature.change_name(player)
    elseif event.t then
            player.name = player.name .. event.t
    elseif event.key == "backspace" then
            player.name = util.trim_last(player.name)
    elseif event.dy then
        creature.change_name(player)
    end
    update_values()
end
callbacks[1] = change_name

local function change_gender(event)
    local v = type(event) == "table" and event.dy or event
    creature.change_gender(player, v)
    update_values()
end
callbacks[2] = change_gender

local function change_race(event)
    local v = type(event) == "table" and event.dy or event
    creature.change_race(player, v)
    update_values()
end
callbacks[3] = change_race

local function change_class(event)
    local v = type(event) == "table" and event.dy or event
    creature.change_class(player, v)
    update_values()
end
callbacks[4] = change_class

local function change_alignment(event)
    local v = type(event) == "table" and event.dy or event
    creature.change_alignment(player, v)
    update_values()
end
callbacks[5] = change_alignment

local function change_bonus(event)
    local v = type(event) == "table" and event.dy or event
    bonus = ((bonus + v - 1) % 6) + 1
    update_values()
end
callbacks[15] = change_bonus

function callbacks.mt:__index(k)
    return change_att
end

setmetatable(callbacks, callbacks.mt)

local function get_description()
    local text
    if selected_row == 3 then
        text = (not details) and descriptions["races"]["*"] or
            descriptions["races"][player.race]
    elseif selected_row == 4 then
        text = (not details) and descriptions["classes"]["*"] or
            descriptions["classes"][player._current_class]
    elseif selected_row == 5 then
        text = (not details) and descriptions["alignment"]["*"] or
            descriptions["alignment"][player.alignment:lower()]
    elseif selected_row >= 9 and selected_row <= 14 then
        local key = dnf_data.att_names[selected_row - 8]
        text = descriptions["stats"][key]
    elseif selected_row == 15 then
        text = descriptions["Racial bonus"]
    else
        text = descriptions["character creation"]
    end
    return text
end

local function update_description()
    description.text = get_description()
    description:prepare()
end

local function select_row(i)
    local previous_row = selected_row
    selected_row = ((selected_row + i - 1) % #values) + 1
    for _, w in ipairs(rows[previous_row]) do
        w:on_unhover()
    end
    for _, w in ipairs(rows[selected_row]) do
        w:on_hover()
    end
    update_description()
end

local function common_callback(v)
    callbacks[selected_row](v)
    update_description()
end

local function get_att_color_text(i)
    local base = player._base_att[i]
    local race_mod = player.race_modifiers[i]
    local total = base + race_mod
    local mod = creature.get_modifier(total)
    local text, coloredtext, color
    local text = tostring(base)

    if mod > 0 then
        color = {0, 255, 0, 255}
    elseif mod < 0 then
        color = {255, 0, 0, 255}
    end

    if race_mod ~= 0 then
        local op = race_mod > 0 and "+" or ""
        text = string.format("%d%s%d=%d", base, op, race_mod, total)
    end

    if color ~= nil then
        coloredtext = {color, text}
    end

    return {coloredtext = coloredtext, text=text}
end

local function title_case(str)
    return (string.gsub(str, "^.", string.upper))
end

function update_values()
    values.name.text = player.name
    values.gender.text = title_case(player.gender)
    values.race.text = title_case(player.race)
    values.class.text = title_case(player._current_class)
    values.alignment.text = player.alignment
    values.age.text = player.age .. " years"
    values.height.text = player.height .. " m."
    values.weight.text = player.weight .. " kg."

    if player.race == "human" or player.race == "half-elf" then
        player.race_modifiers = {0, 0, 0, 0, 0, 0}
        player.race_modifiers[bonus] = 2
        labels_table[15].color = labels_table[1].color
        values.bonus.color = labels_table[1].color
        labels_table[15].hover = true
        values.bonus.hover = true
        values.bonus.text = title_case(dnf_data.att_names[bonus])
    else
        labels_table[15].color = grey
        labels_table[15].hover = false
        values.bonus.color = grey
        values.bonus.hover = false
        values.bonus.text = "—"
    end

    for i, att in ipairs(dnf_data.att_names_short) do
        local label = get_att_color_text(i)
        values[att].text = label.text
        values[att].coloredtext = label.coloredtext
    end

end

function SceneCreation:init()
    SceneBase.init(self)

    self:create_character()

    self:set_music()
    self:set_background()
    self:set_menu()
end

function SceneCreation:set_music()
    self.bgm = manager.audio:load(
        "resources/sounds/legends_of_the_north.ogg",
        "stream", false)
    manager.audio:play_m(self.bgm)
end

function SceneCreation:set_background()
    self.bg_frame = widgets.Frame({
        parent=self,
        rect=self.rect,
        z=1,
        disabled=true
        })
    self.bg = widgets.Image({
        parent=self.bg_frame,
        path='Legend_of_grimrock_key_art_large.jpg',
        fit_mode="scale",
        col=1,
        row=1,
        color={255, 255, 255, 140}
        })
    self.bg_frame:grid()
end

function SceneCreation:create_frame()
    self.frame = widgets.Frame({
        parent=self,
        rect=self.rect,
        z = 2,
        expand=true
    })
    self.frame:row_config(1, 1)
    self.frame:row_config(2, 0)
    self.frame:row_config(3, 12)
    self.frame:row_config(4, 0.5)
    self.frame:col_config(1, 0.55)
    self.frame:col_config(2, 1.5)
    self.frame:col_config(3, 9)
end

function SceneCreation:create_title()
    self.title = widgets.Label({
        parent=self.frame,
        text="Character Creation",
        font_name = "caladea-bold.ttf",
        font_size = 32,
        row=1,
        col=1,
        colspan=3,
        hover=false
    })
end

function SceneCreation:create_buttons()
    local rows = self.rows

    local function unhover_list()
            local widgets = rows[selected_row]
            selected_row = 0
            if widgets == nil then return end
            for _, widget in ipairs(widgets) do
                widget:on_unhover()
            end
    end

    self.roll_button = widgets.Button({
        parent=self.frame,
        path_hover="roll_button3_a.png",
        path=      "roll_button3_b.png",
        path_press="roll_button3_c.png",
        text="Roll",
        col=1,
        row=2,
        padx=4,
        pady=0,
        })
    self.roll_button:bind("MOUSERELEASED.1",
        function()
            self:create_character()
            update_values(self.values_labels)
        end)

    self.roll_button:bind("HOVERED", unhover_list)
    self.roll_button.sticky="W"

    self.create_button = widgets.Button({
        parent=self.frame,
        path_hover="create_button3_a.png",
        path=      "create_button3_b.png",
        path_press="create_button3_c.png",
        text="Done",
        col=2,
        row=2,
        padx=6,
        pady=0
        })
    self.create_button:bind(
        "MOUSERELEASED.1",
        function()
            self:create_character()
            update_values(self.values_labels)
        end)
    self.create_button:bind("HOVERED", unhover_list)
    self.create_button.sticky="W"
end

function SceneCreation:set_menu()
    selected_row = 1

    local rows = {}
    self.rows = rows

    self:create_frame()
    self:create_title()
    self:create_buttons()


    local function share_state(i, a, b)
        local i = i
        local function hover()
            selected_row = i
            update_description()
        end
        local function unhover(evt)
            if selected_row == i then evt.widget.state = "hover" end
        end
        rows[i] = {a, b}
        print(a, b)
        a.commands["HOVERED"] = {hover}
        b.commands["HOVERED"] = {hover}
        a.commands["UNHOVERED"] = {unhover}
        b.commands["UNHOVERED"] = {unhover}
    end


    --[[  LABELS  ]]--
    self.labels = widgets.List({
        parent=self.frame,
        sticky="NWS",
        align="L",
        padx=12,
        pady=12,
        col=1,
        row=3,
        expand=true
    })
    self.labels_table = self.labels:insert_list({
        "Name:", "Gender:", "Race:", "Class:", "Alignment:", "Age:",
        "Height:", "Weight:",
        "Strenght:", "Dexterity:", "Constitution:",
        "Intelligence:", "Wisdom:", "Charisma:", "Bonus:"
    })
    labels_table = self.labels_table


    --[[  VALUES  ]]--
    self.values = widgets.List({
        parent=self.frame,
        -- hover=false,
        sticky="NWS",
        align="L",
        padx=16,
        pady=12,
        col=2,
        row=3,
        expand=true
    })
    self.values_labels = {
        name = self.values:insert({text=player.name,
                                   cursor_blink=true}),
        gender = self.values:insert(player.gender),
        race = self.values:insert(player.race),
        class = self.values:insert(player._current_class),
        alignment = self.values:insert(player.alignment),
        age = self.values:insert({text=player.age .. " years",
                                  hover=false, color=grey}),
        height = self.values:insert({text=player.height .. " m.",
                                     hover=false, color=grey}),
        weight = self.values:insert({text=player.weight .. " kg.",
                                     hover=false, color=grey}),
        str = self.values:insert(get_att_color_text(1)),
        dex = self.values:insert(get_att_color_text(2)),
        con = self.values:insert(get_att_color_text(3)),
        int = self.values:insert(get_att_color_text(4)),
        wis = self.values:insert(get_att_color_text(5)),
        cha = self.values:insert(get_att_color_text(6)),
        bonus = self.values:insert({text="—", hover=false, color=grey})
    }
    -- bonus = self.values:insert(title_case(dnf_data.att_names[bonus]))

    values = self.values_labels

    for i, k in ipairs{"name", "gender", "race", "class", "alignment", "age",
        "height", "weight", "str", "dex", "con", "int", "wis", "cha", "bonus"
    } do
        share_state(i, self.labels_table[i], self.values_labels[k])
    end

    self.frame:bind("KEYPRESSED.up",
        function() select_row(-1) end)
    self.frame:bind("KEYPRESSED.down",
        function() select_row(1) end)
    self.frame:bind("KEYPRESSED.right",
        function() return common_callback(1) end)
    self.frame:bind("KEYPRESSED.left",
        function() return common_callback(-1) end)
    self.frame:bind("KEYPRESSED.tab",
        function() details = not details; update_description() end)
    self.frame:bind("KEYPRESSED.f11",
        function() description.visible = not description.visible end)
    self.frame:bind({"MOUSEMOVED"}, update_description)

    update_values(self.values_labels)

    for _, t in ipairs({self.labels_table, self.values_labels}) do
        for _, field in pairs(t) do
            field:bind(
                {"MOUSERELEASED.1", "MOUSERELEASED.2", "WHEELMOVED"},
                common_callback)
        end
    end

    self.values_labels["name"]:bind(
        {"TEXTINPUT", "KEYPRESSED.backspace"}, common_callback)

    self.description = widgets.Text({
        parent=self.frame,
        text=get_description(),
        col=3,
        row=2,
        rowspan=3,
        sticky="NSWE",
        bg_color = {16, 12, 12, 155},
    })
    description = self.description

    self.description:bind({"WHEELMOVED"},
        function(event) self.description:scroll(event.dy or 1) end)

    self.frame:grid()

    self.description:prepare()
end

function SceneCreation:create_character()
    player = creature.create_as_character()
end

return SceneCreation
