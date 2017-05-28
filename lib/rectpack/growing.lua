local Rect = require("rect")
local newPacker = require("rectpack.packer")

local function package_rectangles(rectangles)
    local bins = {Rect(0, 0, math.huge, math.huge)}
    local packer = newPacker()

    -- # Add the rectangles to packing queue
    for _, r in ipairs(rectangles) do
        packer:add_rect(r)
    end
    local growing_rect_packer = GrowingRectPacker(rects)
    return growing_rect_packer:pack()
end
