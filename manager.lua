local AudioManager = require("audio_manager")
local LuaJukeBox = require("luajukebox")
local Resources = require("resources")

manager = {}
local text_input = ""
local quit
local Manager = class("Manager")

function Manager:init()
    self.session_start = time()
    manager = self
    self:set_event_triggers()
    self:set_event_observers()
    self.scene = "splash_love"
    self.time = time
    self.audio = AudioManager()
    self.jukebox = LuaJukeBox()
    self.resources = Resources()
    self:set_default_font()
end

function Manager:set_event_observers()
    events:observe({'SET_SCENE'},
                   function(scene, args) self:set_scene(scene, args) end)
    events:observe({'QUIT'},
                   function() self:quit() end)
end

function Manager:set_event_triggers()
    -- input/keyboard callbacks
    love.keypressed = function(key)
        events:trigger({'KEYPRESSED', self}, key)
    end
    love.keyreleased = function(key)
        events:trigger({'KEYRELEASED', self}, key)
    end
    love.textinput = function(t)
        events:trigger({'TEXTINPUT', self}, t)
    end

    -- input/mouse callbacks
    love.mousepressed = function(x, y, button, istouch)
        events:trigger({'MOUSEPRESSED', self}, x, y, button, istouch)
    end
    love.mousereleased = function(x, y, button, istouch)
        events:trigger({'MOUSERELEASED', self}, x, y, button, istouch)
    end
    love.mousemoved = function(x, y, dx, dy, istouch)
        events:trigger({'MOUSEMOVED', self}, x, y, dx, dy, istouch)
    end
    love.wheelmoved = function(dx, dy)
     -- get the position of the mouse
        local x, y = love.mouse.getPosition()
        events:trigger({'WHEELMOVED', self}, x, y, dx, dy)
    end

    love.quit = quit
    self.love_getTime = love.timer.getTime
    love.timer.getTime = time
end

function Manager:set_default_font()
    self.default_font = self.resources:font(
        "caladea-regular.ttf", 16)
end

function Manager:load()
    --  one-time setup
    self:parse_initial_args(arg)

    self.next_time = lt.getTime()
    self:set_scene(self.scene)
end

function Manager:parse_initial_args(args)
    require("conf")
    local t = {modules = {}, window = {}}
    love.conf(t)
    self.conf = t
    local custom = t.custom

    self:get_initial_scene(args)

    self._vsync = t.window.vsync
    self.width = t.window.width
    self.height = t.window.height
    self.min_dt = 1 / custom.framerate
    self.lovebird = custom.lovebird and require("lovebird")
    if custom.profile then
        self._profile = require("jit.p")
        self._profile.start("aF2")
    end
    log.verbosity_level = custom.log_verbosity_level or log.verbosity_level

end

function Manager:get_initial_scene(args)
    local scene
    for i, arg in ipairs(args) do
        scene = string.match(arg, "%-%-scene=(.+)")
        if scene then break end
    end
    self.scene = scene
end


function Manager:set_scene(scene, args)
    self.session_start = time()
    -- lg.clear({0, 0, 0, 255})
    lg.setColor({255, 255, 255, 255})
    lg.setFont(self.default_font)
    scene = require("scenes." .. scene)
    if self.scene and self.scene.unload then
        local previous_scene = self.scene.class.name
        local g0 = collectgarbage('count')
        self.scene:unload()
        local g1 = collectgarbage('count')
        log:warn(string.format(
            "Manager:set_scene unload %s (scene time %.4fs, %.4fkb freed)",
            previous_scene, time() - self.scene_start, g1 - g0))
    end
    if scene then
        log:warn("Manager:set_scene start",
                 type(scene) ~= "function" and scene.name or scene)
    end
    self.scene_start = time()
    self.scene = scene(args)
end

function Manager:update(dt)
    -- manage state frame-to-frame
    self.next_time = self.next_time + self.min_dt
    if self.lovebird then
        self.lovebird.update()
    end
end

function Manager:draw()
    lg.setFont(self.default_font)

    -- render the state onto the screen
    if text_input then
        lg.print(text_input, 120, 120)
    end
    lg.print("FPS: "..lt.getFPS(), 10, 20)

    lg.present()
end

function Manager:sleep()
    -- sleep if necessary to keep the framerate regular
    local cur_time = time()
    if self.next_time <= cur_time then
        self.next_time = cur_time
        return 0
    end

    return self.next_time - cur_time
end

function Manager:quit()
    love.event.quit()
end

function quit(...)
    log:warn("Manager:quit (session time "
              .. time() - manager.session_start .. "s)")
    love.audio.stop()
    if manager._profile then
        manager._profile.stop()
    end
    if log then log:write() end
    -- love.event.quit()
    return false
end

function Manager:run()
    local step = lt.step

    if lm then
        lm.setRandomSeed(os.time())
    end

    -- one-time function, no need to set a dispatcher here
    -- if love.load then love.load(arg) end  -- love default
    self:load(arg)

    -- We don't want the first frame's dt to include time taken by love.load.
    if lt then step() end

    local dt = 0

    -- Main loop time.
    local le_pump, le_poll, handlers = le.pump, le.poll, love.handlers
    local lt_getDelta = lt.getDelta
    local lg_isActive, lg_clear = lg.isActive, lg.clear
    local lg_getBgColor, lg_origin = lg.getBackgroundColor, lg.origin
    while true do
        -- Process events.
        if le then
            le_pump()
            for name, a,b,c,d,e,f in le_poll() do
                if name == "quit" then
                    if not love.quit or not love.quit() then
                        return a
                    end
                end
                handlers[name](a,b,c,d,e,f)
            end
        end

        -- Update dt, as we'll be passing it to update
        if lt then
            step()
            dt = lt_getDelta()
        end

        -- Call update and draw
        -- will pass 0 if love.timer is disabled
        -- if love.update then love.update(dt) end  -- love default
        events:trigger({'UPDATE', self}, dt)  -- update scene
        self:update(dt)

        if lg and lg_isActive() then
            lg_clear(lg_getBgColor())
            lg_origin()
            -- if love.draw then love.draw() end  -- love default
            events:trigger({'DRAW', self, 1})  -- draw scene
            self:draw() -- manager stuff
        end

        -- if lt then lt.sleep(0.001) end  -- love default
        local nap = 0.001
        if not self._vsync then
            nap = math.max(self:sleep(), nap)
        end

        lt.sleep(nap)

    end

end

return Manager
