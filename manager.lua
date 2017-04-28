package.path = "lib/?.lua;../lib/?.lua;?/init.lua;" .. package.path

class = require('middleclass')
local AudioManager = require("audio_manager")
beholder = require('beholder')
local inspect = require("inspect")
-- local Shaders = require("shaders")
local Resources = require("resources")
local time = require("time")

manager = {}
local text_input = ""

local Manager = class("Manager")

function Manager:initialize()
    manager = self
    self:set_triggers()
    self:set_manager_watchers()
    self.scene = "splash_love"
    -- self.shaders = Shaders()
    self.time = time.time
    self.audio = AudioManager()
    self.resources = Resources()
end

function Manager:set_manager_watchers()
    beholder.observe('SET_SCENE',
        function(scene, args)
            self:set_scene(scene, args)
        end)
    beholder.observe('UPDATE', self, function(dt) return self:update(dt) end)
    beholder.observe('SCENE_DRAWN', function() return self:draw() end)
    beholder.observe('QUIT', function() self:quit() end)
end

function Manager:set_triggers()
    -- one-time function, no need to set a dispatcher here
    love.load = function(...) self:load(...) end

    -- graphics callbacks
    love.update = function(dt)
        beholder.trigger('UPDATE', self, dt)
    end
    love.draw = function()
        beholder.trigger('DRAW', self, 1)
        beholder.trigger('DRAW', self, -1) -- manager stuff
    end

    -- input/keyboard callbacks
    love.keypressed = function(key)
        beholder.trigger('KEYPRESSED', self, key)
    end
    love.keyreleased = function(key)
        beholder.trigger('KEYRELEASED', self, key)
    end
    love.textinput = function(t)
        beholder.trigger('TEXTINPUT', self, t)
    end

    -- input/mouse callbacks
    love.mousepressed = function(x, y, button, istouch)
        beholder.trigger('MOUSEPRESSED', self, x, y, button, istouch)
    end
    love.mousereleased = function(x, y, button, istouch)
        beholder.trigger('MOUSERELEASED', self, x, y, button, istouch)
    end
    love.mousemoved = function(x, y, dx, dy, istouch)
        beholder.trigger('MOUSEMOVED', self, x, y, dx, dy, istouch)
    end
    love.wheelmoved = function(dx, dy)
     -- get the position of the mouse
        local x, y = love.mouse.getPosition()
        beholder.trigger('WHEELMOVED', self, x, y, dx, dy)
    end
end

function Manager:load()
    --  one-time setup
    self:parse_initial_args(arg)

    self.next_time = love.timer.getTime()
    self:set_scene(self.scene)
end

function Manager:parse_initial_args(args)
    for i = 1, #args do
        local _arg = args[i]
        self:parse_scene_arg(_arg)
    end

    require("conf")
    local t = {modules = {}, window = {}}
    love.conf(t)
    local custom = t.custom
    self.min_dt = 1 / custom.framerate
    self.lovebird = custom.lovebird
    self.width = t.window.width
    self.height = t.window.height
end

function Manager:parse_scene_arg(text)
    local scene = string.match(text, "%-%-scene=(.+)")
    self.scene = scene or self.scene
end


function Manager:set_scene(scene, args)
    scene = require("scenes." .. scene)
    if self.scene and self.scene.unload then
        self.scene:unload()
    end
    self.scene = scene(args)
end

function Manager:update(dt)
    -- manage state frame-to-frame
    self.next_time = self.next_time + self.min_dt
    if self.lovebird then
        require("lovebird").update()
    end
end

function Manager:draw()
    -- render the state onto the screen
    if text_input then
        love.graphics.print(text_input, 120, 120)
    end
    love.graphics.print("FPS: "..love.timer.getFPS(), 10, 20)

    -- sleep if necessary to keep the framerate regular
    local cur_time = love.timer.getTime()
    if self.next_time <= cur_time then
        self.next_time = cur_time
        return
    end
    love.timer.sleep(self.next_time - cur_time)
end

function Manager:quit()
    print("Manager:quit")
    love.event.quit()
end

return Manager
