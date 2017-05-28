local inspect = require("inspect")


local function deepcopy(orig)
    local copy = {}
    for k, v in pairs(orig) do
        if type(v) == 'table' then
            copy[k] = deepcopy(v)
        else
            copy[k] = v
        end
    end
    return copy
end


local GrowingPacker = {}
GrowingPacker.__index = GrowingPacker

setmetatable(
    GrowingPacker,
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

function GrowingPacker:sort(t)
    local sorted = deepcopy(t)
    table.sort(
        sorted,
        function(a, b)
            local max_a = math.max(a.w, a.h)
            local min_a = math.min(a.w, a.h)
            local max_b = math.max(b.w, b.h)
            local min_b = math.min(b.w, b.h)
            return ((math.pow(max_a, 3) + math.pow(min_a, 1/3)) >
                    (math.pow(max_b, 3) + math.pow(min_b, 1/3)))
            --[[
            return (max_a > max_b)
            ]]--
        end
    )
    return sorted
end

function GrowingPacker:clean(t)
    for i = 1, #t do
        local block = t[i]
        block.x = block.fit.x
        block.y = block.fit.y
        block.fit = nil
    end
    collectgarbage()
    return t
end

function GrowingPacker:fit(blocks)
    local blocks = self:sort(blocks)
    local len = #blocks
    local w = len > 0 and blocks[1].w or 0
    local h = len > 0 and blocks[1].h or 0
    self.root = { x = 0, y = 0, w = w, h = h }
    for n = 1, len do
        local block = blocks[n]
        local node = self:findNode(self.root, block.w, block.h)
        if node then
            block.fit = self:splitNode(node, block.w, block.h)
        else
            block.fit = self:growNode(block.w, block.h)
        end
    end
    local blocks = self:clean(blocks)
    return blocks
end

function GrowingPacker:findNode(root, w, h)
    if root.used then
        return self:findNode(root.right, w, h) or
               self:findNode(root.down, w, h)
    elseif w <= root.w and h <= root.h then
        return root
    else
        return nil
    end
end

function GrowingPacker:splitNode(node, w, h)
    node.used = true
    node.down = {x = node.x, y = node.y + h, w = node.w, h = node.h - h }
    node.right = {x = node.x + w, y = node.y, w = node.w - w, h = h}
    return node
end

function GrowingPacker:growNode(w, h)
    local canGrowDown = w <= self.root.w
    local canGrowRight = h <= self.root.h

    --[[attempt to keep square-ish by growing right when height is much
    greater than width]]--
    local shouldGrowRight = canGrowRight and
                            (self.root.h >= (self.root.w + w))

    --[[attempt to keep square-ish by growing down when width is much
    greater than height]]--
    local shouldGrowDown = canGrowDown and
                           (self.root.w >= (self.root.h + h))

    if shouldGrowRight then
        return self:growRight(w, h)
    elseif shouldGrowDown then
        return self:growDown(w, h)
    elseif canGrowRight then
     return self:growRight(w, h)
    elseif canGrowDown then
        return self:growDown(w, h)
    else
        -- need to ensure sensible root starting size to avoid self.happening
        return nil
    end
end

function GrowingPacker:growRight(w, h)
    self.root = {
        used = true,
        x = 0,
        y = 0,
        w = self.root.w + w,
        h = self.root.h,
        down = self.root,
        right = {x = self.root.w, y = 0, w = w, h = self.root.h}
    }
    local node = self:findNode(self.root, w, h)
    if node then
        return self:splitNode(node, w, h)
    else
        return nil
    end
end

function GrowingPacker:growDown(w, h)
    self.root = {
        used = true,
        x = 0,
        y = 0,
        w = self.root.w,
        h = self.root.h + h,
        down = {x = 0, y = self.root.h, w = self.root.w, h = h },
        right = self.root
    }
    local node = self:findNode(self.root, w, h)
    if node then
        return self:splitNode(node, w, h)
    else
        return nil
    end
end

local function package_rectangles(blocks)
    local packer = GrowingPacker()
    return packer:fit(blocks)
end

local function example()
    local blocks = {
        {w = 2, h = 2},
        {w = 4, h = 4},
        {w = 8, h = 8},
        {w = 2, h = 2},
        {w = 4, h = 8},
        {w = 4, h = 4},
        {w = 2, h = 2},
        {w = 8, h = 4},
        {w = 2, h = 2},
    }

    local new_blocks = package_rectangles(blocks)

    for i = 1, #new_blocks do
        print(inspect(new_blocks[i]))
    end
end

return package_rectangles
