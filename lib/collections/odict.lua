local class = require('middleclass') or require('minclass')

local ODict = class("ODict")

function ODict:init()
    self.first = nil
    self.last = nil
    self.hash = {}
    self.count = 0
end

function ODict:clear()
    self:init()
end

function ODict:size() return self.count end

function ODict:is_empty() return self.count == 0 end

function ODict:get_at_index(index)
    for k, v, i in self:sorted() do
        if i == index then
            return k, v
        end
    end
end

function ODict:insert(k, v)
    v = v or true
    local hash = self.hash

    self.first = self.first == nil and k or self.first
    local item = hash[k]
    if item == nil then
        hash[k] = {value = v, left = self.last}
        local last_item = hash[self.last]
        if last_item then last_item.right = k end
        self.last = k
        self.count = self.count + 1
    else
        item.value = v
        self.last  = self.last  == nil and k or self.last
    end
end

function ODict:insert_at(i, k, v)
    local hash = self.hash


    if i == 0 or i > self.count + 1 then
        error(string.format("ODict:insert_at(%d) InvalidIndex", i))
    end


    local item = hash[k]
    if item ~= nil then
        print("ODict:insert_at (already exists)", i, k, v)
        self:remove(k)
        self:insert_at(i, k, v)
    else
        -- print("ODict:insert_at", i, k, v)
        local node = {value = v}
        local old_node_k, old_node_v = self:get_at_index(i)
        local old_node = hash[old_node_k]
        if old_node.left then hash[old_node.left].right = k end
        old_node.left, node.left  = k, old_node.left
        node.right = old_node_k
        if i == 1 then
            self.first = k
        elseif i == self.count + 1 then
            self.last = k
        end
        self.count = self.count + 1
        hash[k] = node
        -- print(inspect(self))
    end
end

function ODict:remove(k)
    local hash = self.hash

    local item = hash[k]
    if item then
        if self.first == k then self.first = item.right end
        if self.last == k then self.last = item.left end

        local right_i = hash[item.right]
        if right_i ~= nil then right_i.left = item.left end

        local left_i = hash[item.left]
        if left_i ~= nil then left_i.right = item.right end

        hash[k] = nil
        self.count = self.count - 1
        if self.count == 0 then
            if self.first ~= nil then
                error("ODict first key should nil for a zero length table")
            end
            if self.last ~= nil then
                error("ODict last key should nil for a zero length table")
            end
        end
        return item.value
    end
end

function ODict:remove_at(i)
    local k, _ = self:get_at_index(i)
    if k ~= nil then
        return self:remove(k)
    else
        error(string.format("ODict:remove_at(%d) InvalidIndex", i))
    end
end

function ODict:sorted()
    local hash = self.hash
    local first = self.first

    if first == nil then return function() end end

    local k, node
    local i = 0

    return function()
        k = k == nil and first or node.right
        i = i + 1
        if k then
            node = hash[k]
            if node then return k, node.value, i end
        end
    end
end

function ODict:reversed()
    local hash = self.hash
    local last = self.last

    local k, node
    local i = 0

    return function()
        k = k == nil and last or node.left
        i = i + 1
        if k then node = hash[k]; return k, node.value, i end
    end
end

function ODict:unsorted()
    local hash = self.hash

    local k, v
    local i = 0

    return function()
        i = i + 1
        k, v = next(hash, k)
        if v then return k, v.value, i end
    end
end

function ODict:next(k)
    log:warn("ODict:next k = ", k)
    local _k, v = next(self.hash, k)
    if v then return _k ,v.value end
end


function ODict:__tostring()
    local start = ODict.super.__tostring(self) .. "{"
    local _end = "}"
    local t = {start}
    for k, v, i in self:sorted() do
        t[#t + 1] = "    " .. tostring(k) .. ": " .. tostring(v) .. ","
    end
    t[#t + 1] = _end
    return table.concat(t, "\n")
end

return ODict
