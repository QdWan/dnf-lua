local time = love.timer.getTime
local BaseWidget = require("widgets.base")

local SceneBase = class("SceneBase")

function SceneBase:init()
    log:warn(self.class.name .. ":init")
    self.rect = Rect(0, 0, manager.width, manager.height)
    self.z = 1
    self:_set_observers()
    self:set_music()
end


function SceneBase:set_music()
    if self.bgm_name then
        if type(self.bgm_name) == "string" then
            manager.jukebox:load(self.bgm_name)
        else
            manager.jukebox:load(unpack(self.bgm_name))
        end
        manager.jukebox:next_track()
    end
end

function SceneBase:_set_observers()
    self.observers = {}

    self.observers["UPDATE"] = events:observe(
        {'UPDATE', manager},
        function(dt)
            return self:update(dt)
        end)

    self.observers["DRAW"] = events:observe(
        {'DRAW', manager, 1},
        function()
            return self:draw(1)
        end)

    self.observers["KEYPRESSED"] = events:observe(
        {'KEYPRESSED', manager},
        function(key, scancode, isrepeat)
            return self:keypressed(key, scancode, isrepeat)
        end)

    self.observers["KEYRELEASED"] = events:observe(
        {'KEYRELEASED', manager},
        function(key, scancode)
            return self:keyreleased(key, scancode)
        end)

    self.observers["MOUSEMOVED"] = events:observe(
        {'MOUSEMOVED', manager},
        function(x, y, dx, dy, istouch)
            return self:mousemoved(x, y, dx, dy, istouch)
        end)

    self.observers["WHEELMOVED"] = events:observe(
        {'WHEELMOVED', manager},
        function(x, y, dx, dy)
            return self:wheelmoved(x, y, dx, dy)
        end)

    self.observers["MOUSEPRESSED"] = events:observe(
        {'MOUSEPRESSED', manager},
        function(x, y, button, istouch)
            return self:mousepressed(x, y, button, istouch)
        end)

    self.observers["MOUSERELEASED"] = events:observe(
        {'MOUSERELEASED', manager},
        function(x, y, button, istouch)
            return self:mousereleased(x, y, button, istouch)
        end)

    self.observers["TEXTINPUT"] = events:observe(
        {'TEXTINPUT', manager},
        function(t)
            return self:textinput(t)
        end)
end

function SceneBase:update(dt)
    events:trigger({'UPDATE', self}, dt)
end

function SceneBase:draw(z)
    for i = 1, self.z do
        -- print("'DRAW' trigger", self, i)
        events:trigger({'DRAW', self, i})
    end
end

function SceneBase:_register_widget(frame)
    -- print("self.z", self.z, "frame.z", frame.z, frame)
    self.z = math.max(self.z, frame.z)
end

function SceneBase:textinput(t)
    events:trigger({'TEXTINPUT', self}, t)
end

function SceneBase:keypressed(key, scancode, isrepeat)
    events:trigger({'KEYPRESSED', self}, key, scancode, isrepeat)
end

function SceneBase:keyreleased(key, scancode)
    --[[  Triggered when a keyboard key is released.

    Args:
        key(KeyConstant): Character of the released key.
        scancode(Scancode): The scancode representing the released key.
    ]]--
   if key == "escape" then
      self:quit()
   end
   events:trigger({'KEYRELEASED', self}, key, scancode)
end

function SceneBase:mousemoved(x, y, dx, dy, istouch)
    events:trigger({'MOUSEMOVED', self}, x, y, dx, dy, istouch)
end

function SceneBase:wheelmoved(x, y, dx, dy)
    --[[ Triggered when the mouse wheel is moved.

    Args:
        x(number): Mouse x position, in pixels.
        y(number): Mouse y position, in pixels.
        dx(number): Amount of horizontal mouse wheel movement. Positive
            values indicate movement to the right.
        dy(number): Amount of vertical mouse wheel movement. Positive values
            indicate upward movement.
    ]]--
    events:trigger({'WHEELMOVED', self}, x, y, dx, dy)
end

function SceneBase:mousepressed(x, y, button, istouch)
    --[[  Triggered when a mouse button is pressed.

    Args:
        x(number): Mouse x position, in pixels.
        y(number): Mouse y position, in pixels.
        button(number): Pressed mouse button index. 1 is the primary mouse
            button, 2 is the secondary mouse button and 3 is the middle
            button. Further buttons are mouse dependent.

    ]]
    events:trigger({'MOUSEPRESSED', self}, x, y, button, istouch)
end

function SceneBase:mousereleased(x, y, button, istouch)
    events:trigger({'MOUSERELEASED', self}, x, y, button, istouch)
end

function SceneBase:quit()
    self:unload()
    manager:quit()
end

function SceneBase:unload()
    local name = self.class.name

    log:warn(string.format("%s unload - start...", name))
    local t0 = time()


    log:warn("collectgarbage('count')", collectgarbage('count'))
    manager.jukebox:clear()
    for k, observer in pairs(self.observers) do
        observer:remove()
        self.observers[k] = nil
    end
    for k, w in pairs(self) do
        log:info("destroy", k, w)
        if w and type(w) == "table" and
                w.class and w.destroy and
                w.isInstanceOf and w:isInstanceOf(BaseWidget) then
            w:destroy()
        end
    end
    brutal_destroyer(self)

    log:warn(string.format("%s unload - done!", name),
             time() - t0)
    return manager:collectgarbage()
end


return SceneBase
