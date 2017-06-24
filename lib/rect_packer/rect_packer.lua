local PQHT = require("collections.priority_queue").PQHT

local function new(class, args)
    local self = setmetatable(args or {}, class)
    if self.init then self:init(args) end
    return self
end

local rect = {x=0, y=0}
rect.__index = rect
setmetatable(rect, {
    __call = new
})
--[[

function rect:__tostring()
    return string.format("rect(x=%d, y=%d, w=%d, h=%d)",
                         self.x, self.y, self.w, self.h)
end
]]--

function rect:area()
    return self.w * self.h
end

function rect:copy()
    return rect({w=self.w, h=self.h, x=self.x, y=self.y})
end

function rect:vertices()
    return {self.x, self.y, -- topleft
            self.x+self.w, self.y, -- topright
            self.x+self.w, self.y+self.h, -- bottomright
            self.x, self.y+self.h, -- bottomleft
}
end

function rect:origin_distance()
    return self.x + self.y * self.y
end

function rect:negative_origin_distance()
    return -(self.x + self.y * self.y)
end

--[[
local function print_queue(t)
    local str = {}
    for i, item in ipairs(t) do
        str[#str + 1] = ("{p= " .. item.p ..
                         ", v= " .. tostring(item.v) .. "}")
    end
    return table.concat(str, "; ")
end
]]--

local function populate_queue(queue, items, fn)
    for _, item in ipairs(items) do
        queue:put({v=item, p=item[fn](item)})
    end
end
local function populate_img_queue(queue, sources, fn)
    local resources = manager.resources
    for _, source in ipairs(sources) do
        local img = assert(resources:image(source.file), source.file)
        source.img = img
        source.w, source.h = img:getWidth(), img:getHeight()
        source.x, source.y = 0, 0
        queue:put({v=source, p=rect[fn](source)})
    end
end

local function insert_and_divide(r, areas)
    local checked = {}
    while true do
        -- log:info("areas(" .. areas.size() .. "): " .. print_queue(areas))
        local area = areas:pop().v
        if area.w >= r.w and area.h >= r.h then
            r.x = area.x
            r.y = area.y
            -- log:info(tostring(r) .. " FITS AT " .. tostring(area))
            local right, down
            if area.w > r.w then -- right
                right = rect({
                    x=area.x + r.w,
                    y=area.y,
                    w=area.w - r.w,
                    h=r.h,
                })
                checked[#checked + 1] = right
            end
            if area.h > r.h then -- down
                down = rect({
                    x=area.x,
                    y=area.y + r.h,
                    w=r.w,
                    h=area.h - r.h
                })
                checked[#checked + 1] = down
            end
            if right and down then
                local downright = rect({
                    x=area.x + r.w,
                    y=area.y + r.h,
                    w=area.w - r.w,
                    h=area.h - r.h
                })
                checked[#checked + 1] = downright
            end
            break
        else
            checked[#checked + 1] = area
        end
    end
    populate_queue(areas, checked, "negative_origin_distance") -- repopulate
    return -- something
end

local function _pack(bin, rects)
    local areas = PQHT()
    areas:put({v=bin:copy(), p=bin:area()})
    while true do
        if rects:empty() then
            -- log:info("no rects remaining")
            break
        elseif areas:empty() then
            error("couldn't pack all rects")
        end
        local r = rects:pop().v
        insert_and_divide(r, areas)
    end
end
local function get_huge_h()
    return 2^16
end

local function img_packer(w, h, sources)
    assert(w and sources)
    local dyn_h -- dynamic_h
    if not h then
        dyn_h = -math.huge
        h = get_huge_h()
    end
    local bin = rect({w=w, h=h})
    local queue = PQHT()
    populate_img_queue(queue, sources, "area")
    local res = _pack(bin, queue)
    for _, r in ipairs(sources) do
        local max_y = r.y + r.h
        dyn_h = dyn_h ~= nil and math.max(dyn_h, max_y) or dyn_h
        -- log:info(r)
    end
    if dyn_h then
        -- log:info("h size of the bin: " .. dyn_h)
    end
    return dyn_h
end

local function packer(w, h, rects)
    local dyn_h -- dynamic_h
    if not h then
        dyn_h = -math.huge
        h = get_huge_h()
    end
    local bin = rect({w=w, h=h})
    local queue = PQHT()
    populate_queue(queue, rects, "area")
    local res = _pack(bin, queue)
    for _, r in ipairs(rects) do
        local max_y = r.y + r.h
        dyn_h = dyn_h ~= nil and math.max(dyn_h, max_y) or dyn_h
        -- log:info(r)
    end
    if dyn_h then
        -- log:info("h size of the bin: " .. dyn_h)
    end
end

return {packer = packer, PackerRect=rect, img_packer=img_packer}
