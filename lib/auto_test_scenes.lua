local AutoTestScenes = class("AutoTestScenes")

local scenes = {}

function AutoTestScenes:init(args)
    self.index = 0
    self.functions = {}
    self.ignored = {}
    self:set_ignored(args.ignore)
    self.sleep = args.sleep or 0.001
    self.scenes = {}
    if not single_test then self:get_scenes() end
    self.scene = 0
end

function AutoTestScenes:set_ignored(list)
    list = type(list) == "string" and {list} or list
    for i, scene in ipairs(list) do
        self.ignored[scene] = true
    end
end

function AutoTestScenes:get_scenes()
    local get_items = love.filesystem.getDirectoryItems

    local find = string.find
    for i, scene in ipairs(get_items("scenes")) do
        if not self.ignored[scene] and not find(scene, "_noauto") then
            local scene_name = string.match(scene, "(test_.+)%.lua")
            if scene_name then
                log:warn("loading test scene: " .. scene_name)
                table.insert(self.scenes, scene_name)
            end
        end
    end
end

local function iter(array, i)
    i = i + 1
    local v = array[i]
    if v then
        return i, v
    end
end

function AutoTestScenes:next_scene(scene)
    local scene_to_call
    self.scene, scene_to_call = iter(self.scenes, self.scene)
    if self.loop then
        self.index = 0
        scene_to_call = self.scenes[self.scene or 1]
    elseif single_test or not scene_to_call then
        return love.event.quit()
    else
        self.index = 0
        self.functions = {}
    end
    return events:trigger({'SET_SCENE'}, scene_to_call)
end

function AutoTestScenes:enter(scene)
    -- log:warn(self.class.name .. ":enter")
end

function AutoTestScenes:leave(scene)
    -- log:warn(self.class.name .. ":leave " .. scene.class.name)
    return self:next_scene() -- love.event.quit()
end

function AutoTestScenes:call(scene)
    if self.index == 0 then
        self.index = self.index + 1
        self:enter(scene)
    elseif self.index == -1 then
        self:leave(scene)
    else
        local fn = self.functions[self.index]
        if fn then
            self.index = self.index + 1
            fn(scene)
        else
            self.index = -1
        end
    end
    self.sleep = self.sleep or 0.001
    lt.sleep(self.sleep)
end

return AutoTestScenes
