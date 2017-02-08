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

local class = require('middleclass')
local Properties = require('properties')

local math_floor = math.floor
local math_max = math.max
local math_min = math.min
local stringf = string.format
local rawset = rawset

local Rect = class('Rect'):include(Properties)

function Rect:initialize(x, y, w, h)
    --[[Initialization.

    Rect objects are used to store and manipulate rectangular areas. A
    Rect can be created from a combination of left, top, width, and
    height values.

    The Rect functions that change the position or size of a Rect return
    a new copy of the Rect with the affected changes. The original Rect
    is not modified. Some methods have an alternate `in-place` version
    that returns None but effects the original Rect. These `in-place`
    methods are denoted with the `ip` suffix.

    The Rect object has several virtual attributes which can be used to
    move and align the Rect:
    >>> x,y
    >>> top, left, bottom, right
    >>> topleft, bottomleft, topright, bottomright
    >>> midtop, midleft, midbottom, midright
    >>> center, centerx, centery
    >>> size, width, height
    >>> w,h

    All of these attributes can be assigned to:
    >>> rect1.right = 10
    >>> rect2.center = {20, 30}

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
    top border (i.e., rect1.bottom=rect2.top), the two meet exactly on
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
--[[

function Rect:__tostring()
    return stringf(
        "Rect(x=%d, y=%d, w=%d, h=%d)",
        self.x, self.y, self.w, self.h)
end
]]--

function Rect:getter_left()
    return self.x
end

function Rect:getter_top()
    return self.y
end

function Rect:getter_width()
    return self.w
end

function Rect:getter_height()
    return self.h
end

function Rect:getter_right()
    return self.x + self.w
end

function Rect:getter_bottom()
    return self.y + self.h
end

function Rect:getter_size()
    return {self.w, self.h}
end

function Rect:getter_topleft()
    return {self.x, self.y}
end

function Rect:getter_topright()
    return {self.right, self.top}
end

function Rect:getter_bottomright()
    return {self.right, self.bottom}
end

function Rect:getter_bottomleft()
    return {self.left, self.bottom}
end

function Rect:getter_centerx()
    return self.x + math_floor(self.w * 0.5)
end

function Rect:getter_centery()
    return self.y + math_floor(self.h * 0.5)
end

function Rect:getter_center()
    return {self.centerx, self.centery}
end

function Rect:getter_midtop()
    return {self.centerx, self.top}
end

function Rect:getter_midbottom()
    return {self.centerx, self.bottom}
end

function Rect:getter_midleft()
    return {self.left, self.centery}
end

function Rect:getter_midright()
    return {self.right, self.centery}
end

function Rect:setter_left(v)
    self.x = v
end

function Rect:setter_top(v)
    self.y = v
end

function Rect:setter_width(v)
    self.w = v
end

function Rect:setter_height(v)
    self.h = v
end

function Rect:setter_right(v)
    self.x = self.x + v - self.right
end

function Rect:setter_bottom(v)
    self.y = self.y + v - self.bottom
end

function Rect:setter_size(v)
     self.w, self.h = v[1], v[2]
end

function Rect:setter_topleft(v)
    self.x, self.y = v[1], v[2]
end

function Rect:setter_topright(v)
    self.right, self.top = v[1], v[2]
end

function Rect:setter_bottomright(v)
    self.right, self.bottom = v[1], v[2]
end

function Rect:setter_bottomleft(v)
    self.left, self.bottom = v[1], v[2]
end

function Rect:setter_centerx(v)
    self.x = self.x + v - self.centerx
end

function Rect:setter_centery(v)
    self.y = self.y + v - self.centery
end

function Rect:setter_center(v)
    self.centerx, self.centery = v[1], v[2]
end

function Rect:setter_midtop(v)
    self.centerx, self.top = v[1], v[2]
end

function Rect:setter_midbottom(v)
    self.centerx, self.bottom = v[1], v[2]
end

function Rect:setter_midleft(v)
    self.left, self.centery = v[1], v[2]
end

function Rect:setter_midright(v)
    self.right, self.centery = v[1], v[2]
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
    local c = self.center
    self.w  = self.w + x
    self.h = self.h + y
    self.center = c
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
        self.center = other.center
    else
        if self.left < other.left then
            self.left = other.left
        elseif self.right > other.right then
            self.right = other.right
        end

        if self.top < other.top then
            self.top = other.top
        elseif self.bottom > other.bottom then
            self.bottom = other.bottom
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
    if r.left < other.left then
        d = other.left - r.left
        r.left = r.left + d
        r.width = r.width - d
    end
    if r.right > other.right then
        d = r.right - other.right
        r.width = r.width - d
    end
    if r.top < other.top then
        d = other.top - r.top
        r.top = r.top + d
        r.height = r.height - d
    end
    if r.bottom > other.bottom then
        d = r.bottom - other.bottom
        r.height = r.height - d
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
    self.w = math_max(self.right, other.right) - x
    self.h = math_max(self.bottom, other.bottom) - y
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

    local r = self.copy()
    r.topleft = other.topleft
    local w_ratio = other.w / r.w
    local h_ratio = other.h / r.h
    local factor = math_min(w_ratio, h_ratio)
    r.w = r.w * factor
    r.h = r.h * factor
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
    return (other.x >= self.x and other.right <= self.right and
            other.y >= self.y and other.bottom <= self.bottom and
            other.left < self.right and other.top < self.bottom)
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

    return x < self.right and y < self.bottom and x >= self.x and y >= self.y
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
    return (self.left < other.right and self.top < other.bottom and
            self.right > other.left and self.bottom > other.top)
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
    local x = math_min(self.right, other.right)
    local y = math_min(self.bottom, other.bottom)
    local w = math_max(self.left, other.left) - x
    local h = math_max(self.top, other.top) - y
    return Rect(x, y, w, h)
end

return Rect
