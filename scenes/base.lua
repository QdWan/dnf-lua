local Rect = require('rect')


local SceneBase = class("SceneBase")

function SceneBase:initialize()
    self.manager = manager
    self.rect = Rect(0, 0, self.manager.width, self.manager.height)
    self.z = 1
    self:_set_observers()
end

function SceneBase:_set_observers()
    self.observers = {}

    self.observers["UPDATE"] = beholder.observe(
        'UPDATE', manager,
        function(dt)
            return self:update(dt)
        end)

    self.observers["DRAW"] = beholder.observe(
        'DRAW', manager, 1, function()
            return self:draw(1)
        end)

    self.observers["KEYPRESSED"] = beholder.observe(
        'KEYPRESSED', manager,
        function(key, scancode, isrepeat)
            return self:keypressed(key, scancode, isrepeat)
        end)

    self.observers["KEYRELEASED"] = beholder.observe(
        'KEYRELEASED', manager,
        function(key, scancode)
            return self:keyreleased(key, scancode)
        end)

    self.observers["MOUSEMOVED"] = beholder.observe(
        'MOUSEMOVED', manager,
        function(x, y, dx, dy, istouch)
            return self:mousemoved(x, y, dx, dy, istouch)
        end)

    self.observers["WHEELMOVED"] = beholder.observe(
        'WHEELMOVED', manager,
        function(x, y, dx, dy)
            return self:wheelmoved(x, y, dx, dy)
        end)

    self.observers["MOUSEPRESSED"] = beholder.observe(
        'MOUSEPRESSED', manager,
        function(x, y, button, istouch)
            return self:mousepressed(x, y, button, istouch)
        end)

    self.observers["MOUSERELEASED"] = beholder.observe(
        'MOUSERELEASED', manager,
        function(x, y, button, istouch)
            return self:mousereleased(x, y, button, istouch)
        end)

    self.observers["TEXTINPUT"] = beholder.observe(
        'TEXTINPUT', manager,
        function(t)
            return self:textinput(t)
        end)


end

function SceneBase:update(dt)
    beholder.trigger('UPDATE', self, dt)
end

function SceneBase:draw(z)
    for i = 1, self.z do
        -- print("'DRAW' trigger", self, i)
        beholder.trigger('DRAW', self, i)
    end
end

function SceneBase:_register_widget(frame)
    -- print("self.z", self.z, "frame.z", frame.z, frame)
    self.z = math.max(self.z, frame.z)
end

function SceneBase:textinput(t)
    beholder.trigger('TEXTINPUT', self, t)
end

function SceneBase:keypressed(key, scancode, isrepeat)
    beholder.trigger('KEYPRESSED', self, key, scancode, isrepeat)
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
   beholder.trigger('KEYRELEASED', self, key, scancode)
end

function SceneBase:mousemoved(x, y, dx, dy, istouch)
    beholder.trigger('MOUSEMOVED', self, x, y, dx, dy, istouch)
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
    beholder.trigger('WHEELMOVED', self, x, y, dx, dy)
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
    beholder.trigger('MOUSEPRESSED', self, x, y, button, istouch)
end

function SceneBase:mousereleased(x, y, button, istouch)
    beholder.trigger('MOUSERELEASED', self, x, y, button, istouch)
end

function SceneBase:quit()
    manager:quit()
end

--[[
local SceneMultiLayer = class("SceneMultiLayer", SceneBase)

function SceneMultiLayer:initialize()
    SceneBase.initialize(self)
    self.layers = {}
end

function SceneMultiLayer:insert(layer)
    self.layers[#self.layers + 1] = layer
end

function SceneMultiLayer:remove(layer)
    for i = 1, #self.layers do
        local inserted = self.layers[i]
        if inserted == layer then
            self.layers[i] = nil
            return true
        end
    end
end

function SceneMultiLayer:update(dt)
    for i = 1, #self.layers do
        local layer = self.layers[i]
        if layer.visible then
            if layer:update(dt) == "stop" then
                break
            end
        end
    end
end

function SceneMultiLayer:draw()
    for i = 1, #self.layers do
        local layer = self.layers[i]
        if layer.visible then
            if layer:draw() == "stop" then
                break
            end
        end
    end
end

function SceneMultiLayer:textinput(t)
    for i = 1, #self.layers do
        local layer = self.layers[i]
        if layer.active then
            if layer:textinput(t) == "stop" then
                break
            end
        end
    end
end

function SceneMultiLayer:keypressed(key, scancode, isrepeat)
    for i = 1, #self.layers do
        local layer = self.layers[i]
        if layer.active then
            if layer:keypressed(key, scancode, isrepeat) == "stop" then
                break
            end
        end
    end
end

function SceneMultiLayer:keyreleased(key, scancode)
    for i = 1, #self.layers do
        local layer = self.layers[i]
        if layer.active then
            if layer:keyreleased(key, scancode) == "stop" then
                break
            end
        end
    end
end

function SceneMultiLayer:mousepressed(x, y, button)
    for i = 1, #self.layers do
        local layer = self.layers[i]
        if layer.active then
            if layer:mousepressed(x, y, button) == "stop" then
                break
            end
        end
    end
end

function SceneMultiLayer:wheelmoved(x,y)
    for i = 1, #self.layers do
        local layer = self.layers[i]
        if layer.active then
            if layer:mousepressed(x, y, button) == "stop" then
                break
            end
        end
    end
end

function SceneMultiLayer:quit()
end

local base_scenes = {
    SceneBase = SceneBase,
    SceneMultiLayer = SceneMultiLayer
}
]]--
return SceneBase
