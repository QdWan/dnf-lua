--[[A rectangular object for storing and manipulating coordinates.

.. note::

  This is a **MODIFIED**, Lua implementation of `PyGameSDL2's rect`_.
  Both the original and modified versions are under zlib license.

.. code-block:: none

  PygameSDL2 Notice / zlib License:

  --------------------------------------------------------------------------
  Original work:
    Copyright 2014 Tom Rothamel <tom@rothamel.us>
    Copyright 2014 Patrick Dawson <pat@dw.is>
  Modified work:
    Copyright 2017 Lucas Siqueira <lucas.morais.siqueira@gmail.com>

  This software is provided 'as-is', without any express or implied
  warranty.  In no event will the authors be held liable for any damages
  arising from the use of this software.

  Permission is granted to anyone to use this software for any purpose,
  including commercial applications, and to alter it and redistribute it
  freely, subject to the following restrictions:

  1. The origin of this software must not be misrepresented; you must not
     claim that you wrote the original software. If you use this software
     in a product, an acknowledgment in the product documentation would be
     appreciated but is not required.
  2. Altered source versions must be plainly marked as such, and must not
     be misrepresented as being the original software.
  3. This notice may not be removed or altered from any source
     distribution.
  --------------------------------------------------------------------------

.. _`PyGameSDL2's rect`: https://www.github.com/renpy/pygame_sdl2/blob/\
master/src/pygame_sdl2/rect.pyx
--]]

local class = require('middleclass') or require('minclass')
local math_floor = math.floor
local math_max = math.max
local math_min = math.min
local stringf = string.format
local rawset = rawset

local Rect = class('Rect')

function Rect:init(x, y, w, h)
    --[[Initialization.

    Rect objects are used to store and manipulate rectangular areas. A
    Rect can be created from a combination of left, top, width, and
    height values.

    The Rect functions that change the position or size of a Rect return
    a new copy of the Rect with the affected changes. The original Rect
    is not modified. Some methods have an alternate `in-place` version
    that returns None but effects the original Rect. These `in-place`
    methods are denoted with the `ip` suffix.

    The Rect object has several functions which can be used to
    move and align the Rect:
    >>> x, y, w, h
    >>> get_*
    >>>     top, left, bottom, right
    >>>     topleft, bottomleft, topright, bottomright
    >>>     midtop, midleft, midbottom, midright
    >>>     center, centerx, centery
    >>>     size, width, height

    All of these attributes can be assigned to:
    >>> rect1:set_right = 10
    >>> rect2:set_center = {20, 30}

    Assigning to size, width or height changes the dimensions of the
    rectangle; all other assignments move the rectangle without resizing
    it. Notice that some attributes are integers and others are pairs of
    integers (tables).

    The coordinates for Rect objects are all integers. The size values
    can be programmed to have negative values, but these are considered
    illegal Rects for most operations.

    There are several collision tests between other rectangles.

    The area covered by a Rect does not include the right- and bottom-
    most edge of pixels. If one Rect's bottom border is another Rect's
    top border (i.e., rect1:get_bottom()==rect2.y), the two meet exactly on
    the screen but do not overlap, and rect1.colliderect(rect2) returns
    false.

    Args.:
        x, y, w, h: x coordinate, y coordinate, width and height
    Usage:
        Rect(left, top, width, height) -> Rect
    ]]--
    self.x = x
    self.y = y
    self.w = w
    self.h = h
end

function Rect:__tostring()
    return stringf(
        "Rect(x=%d, y=%d, w=%d, h=%d)",
        self.x, self.y, self.w, self.h)
end

function Rect:get_left()
    return self.x
end

function Rect:get_top()
    return self.y
end

function Rect:get_width()
    return self.w
end

function Rect:get_height()
    return self.h
end

function Rect:get_right()
    return self.x + self.w
end

function Rect:get_bottom()
    return self.y + self.h
end

function Rect:get_size()
    return {self.w, self.h}
end

function Rect:get_topleft()
    return {self.x, self.y}
end

function Rect:get_topright()
    return {self:get_right(), self.y}
end

function Rect:get_bottomright()
    return {self:get_right(), self:get_bottom()}
end

function Rect:get_bottomleft()
    return {self.x, self:get_bottom()}
end

function Rect:get_centerx()
    return self.x + math_floor(self.w * 0.5)
end

function Rect:get_centery()
    return self.y + math_floor(self.h * 0.5)
end

function Rect:get_center()
    return {self:get_centerx(), self:get_centery()}
end

function Rect:get_midtop()
    return {self:get_centerx(), self.y}
end

function Rect:get_midbottom()
    return {self:get_centerx(), self:get_bottom()}
end

function Rect:get_midleft()
    return {self.x, self:get_centery()}
end

function Rect:get_midright()
    return {self:get_right(), self:get_centery()}
end

function Rect:set_left(x)
    self.x = x
end

function Rect:set_top(y)
    self.y = y
end

function Rect:set_width(w)
    self.w = w
end

function Rect:set_height(h)
    self.h = h
end

function Rect:set_right(v)
    self.x = self.x + v - self:get_right()
end

function Rect:set_bottom(v)
    self.y = self.y + v - self:get_bottom()
end

function Rect:set_size(w, h)
    local _w = (h == nil and w[1]) or w
    local _h = (h == nil and w[2]) or h
    self.w = _w
    self.h = _h
end

function Rect:set_topleft(x, y)
    local _x = (y == nil and x[1]) or x
    local _y = (y == nil and x[2]) or y
    self.x = _x
    self.y = _y
end

function Rect:set_topright(x, y)
    local _x = (y == nil and x[1]) or x
    local _y = (y == nil and x[2]) or y
    self:set_right(_x)
    self.y = _y
end

function Rect:set_bottomright(x, y)
    local _x = (y == nil and x[1]) or x
    local _y = (y == nil and x[2]) or y
    self:set_right(_x)
    self:set_bottom(_y)
end

function Rect:set_bottomleft(x, y)
    local _x = (y == nil and x[1]) or x
    local _y = (y == nil and x[2]) or y
    self.x = _x
    self:set_bottom(_y)
end

function Rect:set_centerx(x)
    self.x = self.x + x - self:get_centerx()
end

function Rect:set_centery(x)
    self.y = self.y + x - self:get_centery()
end

function Rect:set_center(x, y)
    local _x = (y == nil and x[1]) or x
    local _y = (y == nil and x[2]) or y
    self:set_centerx(_x)
    self:set_centery(_y)
end

function Rect:set_midtop(x, y)
    local _x = (y == nil and x[1]) or x
    local _y = (y == nil and x[2]) or y
    self:set_centerx(_x)
    self.y = _y
end

function Rect:set_midbottom(x, y)
    local _x = (y == nil and x[1]) or x
    local _y = (y == nil and x[2]) or y
    self:set_centerx(_x)
    self:set_bottom(_y)
end

function Rect:set_midleft(x, y)
    local _x = (y == nil and x[1]) or x
    local _y = (y == nil and x[2]) or y
    self.x = _x
    self:set_centery(_y)
end

function Rect:set_midright(x, y)
    local _x = (y == nil and x[1]) or x
    local _y = (y == nil and x[2]) or y
    self:set_right(_x)
    self:set_centery(_y)
end

function Rect:copy()
    --[[Copy the rectangle.

    Returns a new rectangle having the same position and size as the
    original.

    Usage:
        source_rect.copy()

    Returns:
        Rect (a new Rect instance)
    ]]--
    return Rect(self.x, self.y, self.w, self.h)
end

function Rect:move(x, y)
    --[[Move the rectangle.

    Returns a new rectangle that is moved by the given offset. The x and
    y arguments can be any integer value, positive or negative.

    Usage:
        source_rect.move(x, y)

    Returns:
        Rect (a new Rect instance)
    ]]--
    local r = self:copy()
    r:move_ip(x, y)
    return r
end

function Rect:move_ip(x, y)
    --[[Move the rectangle, in place.

    The rectangle is moved by the given offset, operating in place. The x
    and y arguments can be any integer value, positive or negative.

    Usage:
        rect.move(x, y)

    Returns:
        None
    ]]--
    self.x = self.x + x
    self.y = self.y + y
end

function Rect:inflate(x, y)
    --[[Grow or Shrink the rectangle size.

    Usage:
        source_rect.inflate(x, y)

    Returns:
        Rect (a new Rect instance)

    Returns a new rectangle with the size changed by the given offset.
    The rectangle remains centered around its current center. Negative
    values will shrink the rectangle.
    ]]--
    local r = self:copy()
    r:inflate_ip(x, y)
    return r
end

function Rect:inflate_ip(x, y)
    --[[Grow or shrink the rectangle size, in place.

    The rectangle's size is changed by the given offset, operating in
    place. Negative values will shrink the rectangle.

    Usage:
        rect.inflate(x, y)

    Returns:
        None
    ]]--
    local center = self:get_center()
    self.w = self.w + x
    self.h = self.h + y
    self:set_center(center)
end

function Rect:clamp(other)
    --[[Move the rectangle inside another.

    Returns a new rectangle that is moved to be completely inside the
    argument Rect. If the rectangle is too large to fit inside, it is
    centered inside the argument Rect, but its size is not changed.

    Usage:
        source_rect.clamp(Rect)

    Returns:
        Rect (a new Rect instance)

    ]]--
    local r = self:copy()
    r:clamp_ip(other)
    return r
end

function Rect:clamp_ip(other)
    --[[Move the rectangle inside another.

    The rectangle is moved to be completely inside the argument Rect,
    operating in place. If the rectangle is too large to fit inside, it
    is centered inside the argument Rect, but its size is not changed.

    Usage:
        rect.clamp(Rect)

    Returns:
        None

    ]]--
    if self.w > other.w or self.h > other.h then
        self:set_center(other:get_center())
    else
        if self.x < other.x then
            self.x = other.x
        else
            local right, other_right = self:get_right(), other:get_right()
            if right > other_right then
                self:set_right(other_right)
            end
        end

        if self.y < other.y then
            self.y = other.y
        else
            local bottom, other_bottom = self:get_bottom(), other:get_bottom()
            if bottom > other_bottom then
                self:set_bottom(other_bottom)
            end
        end
    end
end

function Rect:clip(other)
    --[[Crop a rectangle inside another.

    Returns a new rectangle that is cropped to be completely inside the
    argument Rect. If the two rectangles do not overlap to begin with, a
    Rect with 0 size is returned.

    Usage:
        clip(Rect)

    Returns:
        Rect (a new Rect instance)
    ]]--

    if not self:colliderect(other) then
        return Rect(0, 0, 0, 0)
    end

    local d
    local r = self:copy()

    -- # Remember that (0,0) is the top left.
    if r.x < other.x then
        d = other.x - r.x
        r.x = r.x + d
        r.w = r.w - d
    end
    local right, other_right = r:get_right(), other:get_right()
    if right > other_right then
        d = right - other_right
        r.w = r.w - d
    end
    if r.y < other.y then
        d = other.y - r.y
        r.y = r.y + d
        r.h = r.h - d
    end
    local bottom, other_bottom = self:get_bottom(), other:get_bottom()
    if bottom > other_bottom then
        d = bottom - other_bottom
        r.h = r.h - d
    end

    return r
end

function Rect:union(other)
    --[[Join two rectangles into one.

    Returns a new rectangle that completely covers the area of the two
    provided rectangles. There may be area inside the new Rect that is
    not covered by the originals.

    Usage:
        source_rect.union(Rect)

    Returns:
        Rect (a new Rect instance)
    ]]--
    local r = self:copy()
    r.union_ip(other)
    return r
end

function Rect:union_ip(other)
    --[[Join two rectangles into one.

    The rectangle is resized to completely cover its original area and
    that of the argument Rect, operating in place. The resized Rect may
    contain areas that were not covered by either the original Rect or
    the argument Rect.

    Usage:
        source_rect.union(Rect)

    Returns:
        None
    ]]--

    local x = math_min(self.x, other.x)
    local y = math_min(self.y, other.y)
    self.w = math_max(self:get_right(), other:get_right()) - x
    self.h = math_max(self:get_bottom(), other:get_bottom()) - y
    self.x = x
    self.y = y
end

function Rect:unionall(other_seq)
    --[[Join many rectangles into a new one.

    Returns the union of one rectangle with a sequence of many rectangles.

    Usage:
        source_rect.unionall(Rect_sequence)

    Returns:
        Rect (a new Rect instance)
    ]]--
    local r = self:copy()
    r.unionall_ip(other_seq)
    return r
end

function Rect:unionall_ip(other_seq)
    --[[Join many rectangles into one.

    The rectangle is resized to cover its original area and that of the
    passed as argument, operating in place.

    Usage:
        rect.unionall(Rect_sequence)

    Returns:
        None
    ]]--
    for i=1, #other_seq do
        self:union_ip(other_seq[i])
    end
end

function Rect:fit(other)
    --[[Resize and move a rectangle with aspect ratio.

    Returns a new rectangle that is moved and resized to fit another. The
    aspect ratio of the original Rect is preserved, so the new rectangle
    may be smaller than the target in either width or height.

    Usage:
        source_rect.fit(Rect)

    Returns:
        Rect (a new Rect instance)

    ]]--

    local r = self:copy()
    r:set_topleft(other:get_topleft())
    local w_ratio = other.w / r.w
    local h_ratio = other.h / r.h
    local factor = math_min(w_ratio, h_ratio)
    r.w = math_floor(r.w * factor + 0.5)
    r.h = math_floor(r.h * factor + 0.5)
    return r
end

function Rect:normalize()
    --[[Correct negative sizes of the rectangle.

    This will flip the width or height of a rectangle if it has a
    negative size. The rectangle will remain in the same place, with only
    the sides swapped.

    Usage:
        rect.normalize()

    Returns:
        None
    ]]--
    if self.w < 0 then
        self.x = self.x + self.w
        self.w = -self.w
    end
    if self.h < 0 then
        self.y = self.y + self.h
        self.h = -self.h
    end
    return self
end

function Rect:contains(other)
    --[[Test if an argument rectangle is inside the rectangle.

    Returns true when the argument is completely inside the Rect.

    Usage:
        rect.contains(Rect)

    Returns:
        bool
    ]]--
    local right, bottom = self:get_right(), self:get_bottom()
    return (other.x >= self.x and other:get_right() <= right and
            other.y >= self.y and other:get_bottom() <= bottom and
            other.x < right and other.y < bottom)
end

function Rect:collidepoint(x, y)
    --[[Test if a point is inside a rectangle.

    Returns True if the given point is inside the rectangle. A point
    along the right or bottom edge is not considered to be inside the
    rectangle.

    Args:
        x (int): X (horizontal) coordinate of the point
        y (int): Y (vertical) coordinate of the point

    Usage:
        rect.collidepoint(0, 3)
        rect.collidepoint(x=0, y=3)

    Returns:
        bool
    ]]--

    return x < self:get_right() and y < self:get_bottom() and
           x >= self.x          and y >= self.y
end

function Rect:colliderect(other)
    --[[Test if two rectangles overlap.

    Returns true if any portion of either rectangle overlap (except the
    top+bottom or left+right edges).

    Usage:
        rect.colliderect(Rect)

    Returns:
        bool
    ]]--
    return (self.x < other:get_right() and self.y < other:get_bottom() and
            self:get_right() > other.x and self:get_bottom() > other.y)
end

function Rect:collidelist(other_list)
    --[[Test if the rectangle collide with any rectangle in the list.

    Test whether the rectangle collides with any in a sequence of
    rectangles. The index of the first collision found is returned. If no
    collisions are found an index of -1 is returned.

    Usage:
        rect.collidelist(list)

    Return:
        int (index of first rectangle that collides or -1 none collides)
    ]]--
    for i = 1, #other_list do
        if self:colliderect(other_list[i]) then
            return i
        end
    end
    return -1
end

function Rect:collidelistall(other_list)
    --[[Test if all rectangles in a list intersect.

    Returns a list of all the indices that contain rectangles that
    collide with the Rect. If no intersecting rectangles are found, an
    empty list is returned.

    Usage:
        rect.collidelistall(list)

    Return:
        list (i.e. indices of rectangles that collide)
    ]]--
    local ret = {}
    for i = 1, #other_list do
        if self:colliderect(other) then
            ret[#ret+1] = i
        end
    end
    return ret
end

function Rect:collidedict(other_dict)
    --[[Test if one rectangle in a dictionary intersects.

    Returns the key and value of the first dictionary value that collides
    with the Rect. If no collisions are found, None is returned.

    Rect objects are not hashable and cannot be used as keys in a
    dictionary, only as values.

    Usage:
        collidedict(dict)

    Return:
         tuple (key and value of first rect in the dictionary that
        collides)
         None (if no collision is detected)
    --]]
    for key, val in pairs(other_dict) do
        if self:colliderect(val) then
            return key, val
        end
    end
    return nil
end

function Rect:collidedictall(other_dict, rects_values)
    --[[Test if one rectangle instersect with others in a dictionary.

    Returns a list of tuples with the key and value of the rectangles in
    the argument dictionary that intersect with the Rect. If no
    collisions are found an empty list is returned.

    Rect objects are not hashable and cannot be used as keys in a
    dictionary, only as values.

    Usage:
        collidedictall(dict)

    Returns:
        list of tuples ([(key, value), ...] with the rectangles that
        collide)
        empty list (if none collide)
    ]]--
    local rects_values = rects_values or 0
    local ret = {}
    for key, val in pairs(other_dict) do
        if self:colliderect(val) then
            ret[key] = val
        end
    end
    return ret
end

function Rect:gap(other)
    --[[Return a new rectangle representing the gap between two rectangles.

    If the two rectangles overlap a Rect with size 0 is returned.
    ]]--

    if self:colliderect(other) then
        return Rect(0, 0, 0, 0)
    end
    local x = math_min(self:get_right(), other:get_right())
    local y = math_min(self:get_bottom(), other:get_bottom())
    local w = math_max(self.x, other.x) - x
    local h = math_max(self.y, other.y) - y
    return Rect(x, y, w, h)
end

function Rect:fill(x1, y1, x2, y2)
    return Rect(x1, y1, x2 - x1, y2 - y1)
end

function Rect:divide()
    --[[Create 4 rectangles with half the width and the height of the rect.

    Returns 4 new rectangles that fills the original rect's area.

    Usage:
        source_rect:divide()

    Returns:
        table containing 4 Rect
    ]]--
    local fill = self.fill
    local x = self.x
    local y = self.y
    local centerx = self:get_centerx()
    local centery = self:get_centery()
    local bottom =  self:get_bottom()
    local right =   self:get_right()

    local tl = fill(self, x,       y,       centerx, centery)
    local tr = fill(self, centerx, y,       right,   centery)
    local bl = fill(self, x,       centery, centerx, bottom)
    local br = fill(self, centerx, centery, right,   bottom)
    return {tl, tr, bl, br}
end

return Rect
