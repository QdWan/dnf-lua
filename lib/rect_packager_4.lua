local inspect = require("inspect")
local Rect = require("Rect")

local GrowingRectPacker = {}
GrowingRectPacker.__index = GrowingRectPacker

setmetatable(
    GrowingRectPacker,
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

local function copy(orig)
    local copy = {}
    for k, v in pairs(orig) do
        copy[k] = v:copy()
        if v.c and not copy[k].c then
            copy[k].c = v.c
        end
    end
    return copy
end

local function sort(t)
    local sorted = copy(t)
    table.sort(
        sorted,
        function(a, b)
            local max_a = math.max(a.w, a.h)
            local min_a = math.min(a.w, a.h)
            local max_b = math.max(b.w, b.h)
            local min_b = math.min(b.w, b.h)
            return ((math.pow(max_a, 2) + min_a) >
                    (math.pow(max_b, 2) + min_b))
        end
    )
    return sorted
end

local function print_result(rects)
    for i = 1, #rects do
        local collide = false
        for j = 1, #rects do
            if j ~= i then
                if rects[i]:colliderect(rects[j]) then
                    collide = true
                    break
                end
            end
        end
        local status = collide and "*" or ""
        print(rects[i], status)
    end
end

function Rect:initialize(x, y, w, h)
    self.x = x or 0
    self.y = y or 0
    self.w = w
    self.h = h
end

function Rect:__tostring()
    return string.format(
        "Rect(x=%d, y=%d, w=%d, h=%d)",
        self.x, self.y, self.w, self.h)
end

function GrowingRectPacker:initialize(rects)
    self.sorted = sort(rects)
    self.inserted = {count = 0}
    self.free = {}
    self.w = 0
    self.h = 0
    self:grow_by(self.sorted[1].w, self.sorted[1].h, 0, 0)
    return self
end

function GrowingRectPacker:pack()
    print("starting to pack")
    local sorted = self.sorted
    local inserted = self.inserted
    while inserted.count ~= #sorted do
        print("rects inserted:", inserted.count)
        local no_fit = true
        for i, rect in ipairs(sorted) do
            if #self.free == 0 then
                break
            elseif not inserted[rect] then
                print(string.format("testing rect #%d %s, free areas = %d",
                                    i, rect, #self.free))
                local insertion = self:insert(rect)
                if insertion then
                    inserted[rect] = true
                    inserted.count = inserted.count + 1
                    no_fit = false
                end
            end
        end
        if no_fit then
            for _, rect in ipairs(sorted) do
                if not inserted[rect] then
                    self:grow_for(rect)
                    break
                end
            end
        end
    end
    print_result(sorted)
    return sorted
end

function GrowingRectPacker:insert(rect)
    local removals = {}

    local free = self.free
    local area

    for i, area in ipairs(free) do
        if rect.w <= area.w and rect.h <= area.h then
            print(string.format("rect %s fits in area %s", rect, area))
            free[i] = free[#free]
            free[#free] = nil
            rect.x = area.x
            rect.y = area.y
            print(string.format("packed rect %s", rect))
            local dw = area.w - rect.w
            local dh = area.h - rect.h

            local new_r_area_w, new_r_area_h, new_d_area_w, new_d_area_h
            if dw * rect.h > rect.w * dh then
                new_r_area_w = dw
                -- new right rect has priority to grow/fill down
                new_r_area_h = area.h
                new_d_area_w = rect.w
                new_d_area_h = dh
            else
                new_r_area_w = dw
                new_r_area_h = rect.h
                -- new down rect has priority to grow/fill right
                new_d_area_w = area.w
                new_d_area_h = dh
            end
            -- new free area to the right
            if dw > 0 then
                free[#free + 1] = Rect(
                    rect.x + rect.w, rect.y,  -- x, y
                    new_r_area_w, new_r_area_h  -- w, h
                )
            end
            -- new free area below
            if dh > 0 then
                free[#free + 1] = Rect(
                    rect.x, rect.y + rect.h,  -- x, y
                    new_d_area_w, new_d_area_h  -- w, h
                )
            end
            area.w = rect.w
            area.h = rect.h
            return true
        end
    end
    print("no fit")
    return nil
end

function GrowingRectPacker:should_grow_right()
    return self.w < self.h * 1.25
end

function GrowingRectPacker:grow_for(rect)
    print("grow_for ", rect)
    local free = self.free
    local w, h = rect.w, rect.h

    -- first case: expand a free rect at a border, if possible
    for i, area in ipairs(free) do
        -- should go right
        -- can expand horizontally an existing border area with proper height
        if (self:should_grow_right() and
            (area.x + area.w == self.w and area.h >= h)
        ) then
            local dw = w - area.w
            if dw > 0 then
                print(string.format(
                    "should_grow_right, can expand area %s by w%d", area, dw))
                return self:grow_by(dw, 0)
            end
        -- should grow down
        -- can expand vertically an existing border area with proper width
        elseif (area.y + area.h) == self.h and area.w >= w then
            local dh = h - area.h
            if dh > 0 then
                print(string.format(
                    "should_grow_down, can expand area %s by h%d", area, dh))
                return self:grow_by(0, dh)
            end
        end
    end

    -- should go right
    -- expand by a width that fully fits the rect
    if self:should_grow_right() then
        return self:grow_by(w, 0)
    -- should grow down
    -- expand by a height that fully fits the rect
    else
        return self:grow_by(0, h)
    end
end

function GrowingRectPacker:grow_by(w, h)
    local free = self.free
    local inserted = self.inserted
    local old_w = self.w
    local old_h = self.h
    self.w = self.w + w
    self.h = self.h + h
    if inserted.count == 0 then
        print("#free == 0")
        free[#free + 1] = Rect(0, 0, w, h)
    elseif w == 0 and h == 0 then
        error("grow_by nil values")
    else
        print(string.format("new dimensions: w%d, h%d", self.w, self.h))
        for i, area in ipairs(free) do
            -- expand existing border area horizontally
            if (area.x + area.w == old_w) and w > 0 then
                area.w = area.w + w
            end
            -- expand existing border area vertically
            if (area.y + area.h == old_h) and h > 0 then
                area.h = area.h + h
            end
            print("updated free area", area)
        end
        for _, packed in ipairs(self.sorted) do
            if inserted[packed] then
                -- create new free area besides packed rect
                if packed.x + packed.w == old_w and w > 0 then
                    free[#free + 1] = Rect(
                        packed.x + packed.w, packed.y, -- x, y
                        w, packed.h  -- w, h
                    )
                    print("new free area", free[#free])
                end
                -- create new free area below packed rect
                if packed.y + packed.h == old_h and h > 0 then
                    free[#free + 1] = Rect(
                        packed.x, packed.y + packed.h,  -- x, y
                        packed.w, h  -- w, h
                    )
                    print("new free area", free[#free])
                end
            end
        end
    end
end


local function package_rectangles(rects)
    local growing_rect_packer = GrowingRectPacker(rects)
    return growing_rect_packer:pack()
end

local function example()
    local rects = {
        Rect(0, 0, 2, 2),
        Rect(0, 0, 4, 4),
        Rect(0, 0, 8, 8),
        Rect(0, 0, 2, 2),
        Rect(0, 0, 4, 8),
        Rect(0, 0, 4, 4),
        Rect(0, 0, 2, 2),
        Rect(0, 0, 8, 4),
        Rect(0, 0, 2, 2),
    }

    local new_blocks = package_rectangles(rects)
end

return package_rectangles
