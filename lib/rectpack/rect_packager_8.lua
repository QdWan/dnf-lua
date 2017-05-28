local inspect = require("inspect")
local Rect = require("Rect")
local class = require("middleclass")

local PackingAlgorithm = class("PackingAlgorithm")

function PackingAlgorithm:initialize(kwargs)
    --[[PackingAlgorithm base class.

    Args:
        t (table): table containing the below keyword arguments.
        t.width (number): Packing surface width
        t.height (number): Packing surface height
        t.rot (boolean): Rectangle rotation enabled or disabled
    ]]--
    self.width = t.width
    self.height = t.height
    self.rot = t.rot or false
    self.rectangles = {}
    self._surface = Rect(0, 0, t.width, t.height)
    self:reset()
end

function PackingAlgorithm:_fits_surface(width, height)
    --[[Test surface is big enough to place a rectangle

    Arguments:
        width (int, float): Rectangle width
        height (int, float): Rectangle height

    Returns:
        boolean: True if it could be placed, False otherwise
    ]]--
        assert(width > 0 and height > 0)
        if self.rot and (width > self.width or height > self.height) then
            width, height = height, width
        end

        if width > self.width or height > self.height then
            return false
        else
            return true
        end
end

function PackingAlgorithm:reset()
    self.rectangles = {}  -- List of placed Rectangles.
end

local Guillotine = class("Guillotine", PackingAlgorithm)

function Guillotine:initialize(kwargs)
    --[[Implementation of several variants of Guillotine packing algorithm

    For a more detailed explanation of the algorithm used, see:
    Jukka Jylanki - A Thousand Ways to Pack the Bin (February 27, 2010)
    ]]--
    self._merge = kwargs["merge"]
    PackingAlgorithm.initialize(self, kwargs)
end

function Guillotine:_add_section(section)
    --[[
    Adds a new section to the free section list, but before that and if
    section merge is enabled, tries to join the rectangle with all existing
    sections, if successful the resulting section is again merged with the
    remaining sections until the operation fails. The result is then
    appended to the list.

    Arguments:
        section (Rectangle): New free section.
    ]]--
    section.rid = 0
    plen = 0

    while (self._merge and not self._sections:empty() and
           plen ~= #self._sections
    ) do
        plen = #self._sections
        local t = {}
        for _, s in ipairs(self._sections) do
            if section:join(s):empty() then
                t[#t + 1] = s
            end
        end
    end
    self._sections:append(section)
end

function Guillotine:_split_horizontal(section, width, height)
    --[[
    For an horizontal split the rectangle is placed in the lower
    left corner of the section (section's xy coordinates), the top
    most side of the rectangle and its horizontal continuation,
    marks the line of division for the split.
    +-----------------+
    |                 |
    |                 |
    |                 |
    |                 |
    +-------+---------+
    |#######|         |
    |#######|         |
    |#######|         |
    +-------+---------+
    If the rectangle width is equal to the the section width, only one
    section is created over the rectangle. If the rectangle height is
    equal to the section height, only one section to the right of the
    rectangle is created. If both width and height are equal, no sections
    are created.
    ]]--

    -- Creates two new empty sections, and returns the new rectangle.
    if height < section.height then
        self:_add_section(Rect(section.x, section.y+height,
            section.width, section.height-height))
    end

    if width < section.width then
        self:_add_section(Rect(section.x+width, section.y,
            section.width-width, height))
    end
end

function Guillotine:_split_vertical(section, width, height)
    --[[For a vertical split the rectangle is placed in the lower
    left corner of the section (section's xy coordinates), the
    right most side of the rectangle and its vertical continuation,
    marks the line of division for the split.
    +-------+---------+
    |       |         |
    |       |         |
    |       |         |
    |       |         |
    +-------+         |
    |#######|         |
    |#######|         |
    |#######|         |
    +-------+---------+
    If the rectangle width is equal to the the section width, only one
    section is created over the rectangle. If the rectangle height is
    equal to the section height, only one section to the right of the
    rectangle is created. If both width and height are equal, no sections
    are created.
    ]]--
    -- When a section is split, depending on the rectangle size
    -- two, one, or no new sections will be created.
    if height < section.height then
        self:_add_section(Rect(section.x, section.y+height,
            width, section.height-height))
    end

    if width < section.width then
        self:_add_section(Rect(section.x+width, section.y,
            section.width-width, section.height))
    end
end

function Guillotine:_split(section, width, height)
    --[[Selects the best split for a section, given a rectangle of dimmensions
    width and height, then calls _split_vertical or _split_horizontal,
    to do the dirty work.

    Arguments:
        section (Rectangle): Section to split
        width (int, float): Rectangle width
        height (int, float): Rectangle height
    ]]--
    error("NotImplementedError")
end


function Guillotine:_section_fitness(section, width, height)
    --[[The subclass for each one of the Guillotine selection methods,
    BAF, BLSF.... will override this method, this is here only
    to asure a valid value return if the worst happens.
    ]]--
    error("NotImplementedError")
end

function Guillotine:_select_fittest_section(w, h)
    --[[Calls _section_fitness for each of the sections in free section
    list. Returns the section with the minimal fitness value, all the rest
    is boilerplate to make the fitness comparison, to rotatate the rectangles,
    and to take into account when _section_fitness returns None because
    the rectangle couldn't be placed.

    Arguments:
        w (int, float): Rectangle width
        h (int, float): Rectangle height

    Returns:
        (section, was_rotated): Returns the tuple
            section (Rectangle): Section with best fitness
            was_rotated (bool): The rectangle was rotated
    ]]--
    fitn = {}
    for _, s in ipairs(self._sections) do
        if self:_section_fitness(s, w, h) ~= nil then
            fitn[#fitn + 1] = {self:_section_fitness(s, w, h), s, false}
        end
    end

    fitr = {}
    if self.rot then
        for _, s in ipairs(self._sections) do
            if self:_section_fitness(s, h, w) ~= nil then
                fitr[#fitr + 1] = {self._section_fitness(s, h, w), s, true}
            end
        end
    end

    local sec_rot = true
    local v = math.huge
    for _, t in ipairs({fitn, fitr}) do
        for fit in ipairs(t) do
            if fit[1] < v then
                sec_rot = {fit[2], fit[3]}
                v = fit[1]
            end
        end
    end
    local sec, rot = sec_rot[1], sec_rot[2]

    return sec, rot
end

function Guillotine:add_rect(width, height, rid)
    --[[Add rectangle of widthxheight dimensions.

    Arguments:
        width (int, float): Rectangle width
        height (int, float): Rectangle height
        rid: Optional rectangle user id

    Returns:
        Rectangle: Rectangle with placemente coordinates
        None: If the rectangle couldn be placed.
    ]]--
    assert(width > 0 and height >0)

    -- Obtain the best section to place the rectangle.
    section, rotated = self:_select_fittest_section(width, height)
    if not section then
        return nil
    end

    if rotated then
        width, height = height, width
    end

    -- Remove section, split and store results
    self._sections:remove(section)
    self:_split(section, width, height)

    -- Store rectangle in the selected position
    rect = Rect(section.x, section.y, width, height, rid)
    self.rectangles:append(rect)
    return rect
end

function Guillotine:fitness(width, height)
    --[[In guillotine algorithm case, returns the min of the fitness of all
    free sections, for the given dimension, both normal and rotated
    (if rotation enabled.)
    ]]--
    assert(width > 0 and height > 0)

    -- Get best fitness section.
    section, rotated = self:_select_fittest_section(width, height)
    if not section then
        return nil
    end

    -- Return fitness of returned section, with correct dimmensions if the
    -- the rectangle was rotated.
    if rotated then
        return self:_section_fitness(section, height, width)
    else
        return self:_section_fitness(section, width, height)
    end
end


local GuillotineBaf = class("GuillotineBaf", Guillotine)

function GuillotineBaf:initialize(kwargs)
    --[[Implements Best Area Fit (BAF) section selection criteria for
    Guillotine algorithm.
    ]]--
    Guillotine.initialize(self, kwargs)
end

function GuillotineBaf:_section_fitness(section, width, height)
    if width > section.width or height > section.height then
        return nil
    end
    return section:area() - width * height
end
