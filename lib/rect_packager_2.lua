local RectangleBinPack = {}
RectangleBinPack.__index = RectangleBinPack

setmetatable(
    RectangleBinPack,
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

function RectangleBinPack:initialize(width, height)
    --[[Restart the packing process.

    Clears all previously packed rectangles and sets up a new bin of a given initial size. These bin dimensions stay fixed during the whole packing
    process, i.e. to change the bin size, the packing must be restarted again
    with a new call to initialize().
    ]]--
    self.binWidth = width
    self.binHeight = height
    root.left = 0
    root.right = 0
    root.x = 0
    root.y = 0
    root.width = width
    root.height = height
end

--[[
@return A value [0, 1] denoting the ratio of total surface area that is in
use.
0.0f - the bin is totally empty, 1.0f - the bin is full.
]]--
function RectangleBinPack:Occupancy()
    totalSurfaceArea = self.binWidth * self.binHeight
    usedSurfaceArea = UsedSurfaceArea(root)

    return usedSurfaceArea/totalSurfaceArea
end

-- Recursively calls itself.
function RectangleBinPack:UsedSurfaceArea(node)
    if node.left or node.right then
        usedSurfaceArea = node.width * node.height
        if node.left then
            usedSurfaceArea = usedSurfaceArea + UsedSurfaceArea(node.left)
        end
        if node.right then
            usedSurfaceArea = usedSurfaceArea + UsedSurfaceArea(node.right)
        end
        return usedSurfaceArea
    end

    -- This is a leaf node, it doesn't constitute to the total surface area.
    return 0
end

--[[
Running time is linear to the number of rectangles already packed. Recursively calls itself.

@return 0 If the insertion didn't succeed.
]]--
function RectangleBinPack:Insert(node, width, height)
--[[
If this node is an internal node, try both leaves for possible space.
(The rectangle in an internal node stores used space, the leaves store free space)
]]--
    if node.left or node.right then
        if node.left then
            newNode = Insert(node.left, width, height)
            if newNode then
                return newNode
            end
        end
        if node.right then
            newNode = Insert(node.right, width, height)
            if newNode then
                return newNode
            end
        end
        return 0  --- Didn't fit into either subtree!
    end

    -- This node is a leaf, but can we fit the new rectangle here?
    if width > node.width or height > node.height then
        return 0  -- Too bad, no space.
    end

    --[[
    The new cell will fit, split the remaining space along the shorter axis,
    that is probably more optimal.
    ]]--
    w = node.width - width
    h = node.height - height
    node.left = Node
    node.right = Node
    if w <= h then -- Split the remaining space in horizontal direction.
        node.left.x = node.x + width
        node.left.y = node.y
        node.left.width = w
        node.left.height = height

        node.right.x = node.x
        node.right.y = node.y + height
        node.right.width = node.width
        node.right.height = h
    else  -- Split the remaining space in vertical direction.
        node.left.x = node.x
        node.left.y = node.y + height
        node.left.width = width
        node.left.height = h

        node.right.x = node.x + width
        node.right.y = node.y
        node.right.width = w
        node.right.height = node.height
    end

    --[[
    Note that as a result of the above, it can happen that node->left or
    node->right is now a degenerate (zero area) rectangle. No need to do anything about it, like remove the nodes as "unnecessary" since they need to exist as children of this node (this node can't be a leaf anymore).

    This node is now a non-leaf, so shrink its area - it now denotes
    *occupied* space instead of free space. Its children spawn the resulting
    area of free space.
    ]]--
    node.width = width
    node.height = height
    return node
end
