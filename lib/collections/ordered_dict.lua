local OrderedDict = {}
OrderedDict.__index = OrderedDict

setmetatable(
    OrderedDict,
    {
        __call = function (class, ...)
            local self = setmetatable({}, class)
            if self.initialize then
                self:initialize(...)
            end
            return self
        end
    }
)

function OrderedDict:initialize()
    self.dict = {}
    self.count = 0
end

function OrderedDict:add(k, v)
    self.start = self.start or k
    self.count = self.count + 1
    local node = {v = v}
    self.dict[k] = node
    if self.last then
        local last_node = self.dict[self.last]
        last_node.next = k
        node.previous = self.last
    end
    self.last = k
end

function OrderedDict:insert_at(i, k, v)
    print("OrderedDict:insert_at", i, k, v)
    if i == 0 or i > self.count + 1 then
        error(string.format("OrderedDict:insert_at(%d) InvalidIndex", i))
    end
    local node = {v = v}

    if i == 1 then
        local old_start_k = self.start
        local old_start_node = self.dict[old_start_k]
        old_start_node.previous = k
        self.start = k
        node.next = old_start_k
    elseif i == self.count + 1 then
        local old_last_k = self.last
        local old_last_node = self.dict[old_last_k]
        old_last_node.next = k
        self.last = k
        node.previous = old_last_k
    else
        local old_node_k
        for _k, _, _i in self:items() do
            if i == _i then
                old_node_k = _k
                break
            end
        end
        local old_node = self.dict[old_node_k]
        self.dict[old_node.previous].next = k
        node.previous = old_node.previous

        old_node.previous = k
        node.next = old_node.next
    end

    self.count = self.count + 1
    self.dict[k] = node
end

function OrderedDict:remove(k)
    local dict = self.dict
    local node = dict[k]
    if not node then
        return
    end
    self.count = self.count - 1
    dict[node.previous].next = node.next
    dict[node.next].previous = node.previous
end

function OrderedDict:remove_at(i)
    local k
    for _k, v, _i in self:items() do
        if i == _i then
            k = _k
            break
        end
    end
    if k ~= nil then
        self:remove(k)
    else
        error(string.format("OrderedDict:remove_at(%d) InvalidIndex", i))
    end
end

function OrderedDict:size()
    return self.count
end

function OrderedDict:is_empty()
    return self.count == 0
end

function OrderedDict:items(reversed)
    local dict = self.dict
    local k
    if not reversed then
        local last = self.last
        local i = 0
        return function ()
            if k == last then
                return
            end
            k = (k and dict[k].next) or self.start
            i = i + 1
            if k then
                return k, dict[k].v, i
            end
        end
    else
        local start = self.start
        local i = self.count + 1
        return function ()
            if k == start then
                return
            end
            k = (k and dict[k].previous) or self.last
            i = i - 1
            if k then
                return k, dict[k].v, i
            end
        end
    end
end

return OrderedDict
