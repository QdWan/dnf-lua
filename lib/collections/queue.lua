local Queue = {}

setmetatable(Queue, {
    __index = Queue,
    __call = function()
        return setmetatable(
            {first = 0, last = -1, size=0},
            {__index = Queue})
        end,
    }
)


function Queue.pushleft(Queue, value)
    local first = Queue.first - 1
    Queue.first = first
    Queue[first] = value
    Queue.size = Queue.size + 1
end

function Queue.pushright(Queue, value)
    local last = Queue.last + 1
    Queue.last = last
    Queue[last] = value
    Queue.size = Queue.size + 1
end
Queue.insert = Queue.pushright
Queue.add = Queue.pushright

function Queue.popleft(Queue, safe, default)
    local first = Queue.first
    if first > Queue.last then
        if not safe then
            error("Queue is empty")
        else
            return default
        end
    end
    local value = Queue[first]
    Queue[first] = nil        -- to allow garbage collection
    Queue.first = first + 1
    Queue.size = Queue.size - 1
    return value
end
Queue.pop = Queue.popleft
Queue.get = Queue.popleft

function Queue.popright(Queue, safe, default)
    local last = Queue.last
    if Queue.first > last then
        if not safe then
            error("Queue is empty")
        else
            return default
        end
    end
    local value = Queue[last]
    Queue[last] = nil         -- to allow garbage collection
    Queue.last = last - 1
    Queue.size = Queue.size - 1
    return value
end

return Queue
--[[
queue = Queue()
for i = string.byte("a"), string.byte("z") do
    queue:add(string.char(i))
end
while true do
    local v = queue:popright(true, nil)
    if v then
        print(v, #queue)
    else
        break
    end
end
]]--
