--- Deque implementation by Pierre 'catwell' Chapuis
--- MIT licensed
--- original available at:
---     https://github.com/catwell/cw-lua/tree/master/deque
--- Modified by Lucas Siqueira

local Deque = class("Deque")

function Deque:init()
        self.head = 0
        self.tail = 0
end

function Deque:push_right(x)
    assert(x ~= nil)
    self.tail = self.tail + 1
    self[self.tail] = x
end

function Deque:push_left(x)
    assert(x ~= nil)
    self[self.head] = x
    self.head = self.head - 1
end

function Deque:peek_right()
    return self[self.tail]
end

function Deque:peek_left()
    return self[self.head+1]
end

function Deque:pop_right()
    if self:is_empty() then return nil end
    local r = self[self.tail]
    self[self.tail] = nil
    self.tail = self.tail - 1
    return r
end

function Deque:pop_left()
    if self:is_empty() then return nil end
    local r = self[self.head+1]
    self.head = self.head + 1
    local r = self[self.head]
    self[self.head] = nil
    return r
end

function Deque:rotate_right(n)
    n = n or 1
    if self:is_empty() then return nil end
    for i=1,n do self:push_left(self:pop_right()) end
end

function Deque:rotate_left(n)
    n = n or 1
    if self:is_empty() then return nil end
    for i=1,n do self:push_right(self:pop_left()) end
end

function Deque:_remove_at_internal(idx)
    for i=idx, self.tail do self[i] = self[i+1] end
    self.tail = self.tail - 1
end

function Deque:remove_right(x)
    for i=self.tail,self.head+1,-1 do
        if self[i] == x then
            _remove_at_internal(self, i)
            return true
        end
    end
    return false
end

function Deque:remove_left(x)
    for i=self.head+1,self.tail do
        if self[i] == x then
            _remove_at_internal(self, i)
            return true
        end
    end
    return false
end

function Deque:length()
    return self.tail - self.head
end

function Deque:is_empty()
    return self:length() == 0
end

function Deque:contents()
    local r = {}
    for i=self.head+1,self.tail do
        r[i-self.head] = self[i]
    end
    return r
end

function Deque:iter_right()
    local i = self.tail+1
    return function()
        if i > self.head+1 then
            i = i-1
            return self[i]
        end
    end
end

function Deque:iter_left()
    local i = self.head
    return function()
        if i < self.tail then
            i = i+1
            return self[i]
        end
    end
end

return Deque
