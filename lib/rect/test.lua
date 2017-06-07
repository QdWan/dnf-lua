local paths = "?.lua;?/init.lua;../?.lua;../?/init.lua;../?/?.lua;"
package.path = paths .. package.path
local Rect = require("rect")
inspect = require("inspect")

local assert = assert

for i = 1, 10000 do
    local r1 = assert(Rect(4, 5, 6, 7))
    local r2 = assert(Rect(15, 20, 6, 7))
    local r3 = r1:clamp(r2)
    assert(r3.x == r2.x and r3.y == r2.y and r3.w == r2.w and r3.h == r2.h)
    r1:clamp_ip(r2)
    assert(r1.x == r2.x and r1.y == r2.y and r1.w == r2.w and r1.h == r2.h)

    local r1 = Rect(4, 5, 6, 7)
    local c0 = r1:get_center()
    local r2 = r1:inflate(5, 5)
    assert(r1.x == 4 and r1.y == 5 and r1.w == 6 and r1.h == 7)
    r1:inflate_ip(5, 5)
    local c1 = r1:get_center()
    assert(r1.w == 11 and r1.h == 12 and c0[1] == c1[1] and c0[2] == c1[2])
    assert(r1.x == r2.x and r1.y == r2.y and r1.w == r2.w and r1.h == r2.h)

    local r1 = Rect(1, 2, 4, 6)
    local r2 = r1:move(2, 3)
    assert(r1.x == 1 and r1.y == 2)
    assert(r2.x == 3 and r2.y == 5)
    r1:move_ip(2, 3)
    assert(r1.x == 3 and r1.y == 5)

    local r1 = Rect(1, 2, 4, 6)
    local r2 = r1:copy()
    assert(r1.x == r2.x and r1.y == r2.y and r1.w == r2.w and r1.h == r2.h)
    r2.x = r2.x + 1
    r2.y = r2.y + 2
    r2.w = r2.w  + 3
    r2.h = r2.h + 4
    assert(r1.x + 1 == r2.x and r1.y  + 2 == r2.y)
    assert(r1.w + 3 == r2.w and r1.h  + 4 == r2.h)

    local r = Rect(1, 2, 4, 6)
    assert(r:get_right() == r:get_midright()[1] and r:get_centery() == r:get_midright()[2])
    local right0 = r:get_right()
    local centery0 = r:get_centery()
    r:set_midright(right0 + 1, centery0 + 2)
    assert(r:get_right() == r:get_midright()[1] and r:get_centery() == r:get_midright()[2])
    assert(r:get_midright()[1] == right0 + 1 and r:get_midright()[2] == centery0 + 2)

    local r = Rect(1, 2, 4, 6)
    assert(r:get_left() == r:get_midleft()[1] and r:get_centery() == r:get_midleft()[2])
    local left0 = r:get_left()
    local centery0 = r:get_centery()
    r:set_midleft(left0 + 1, centery0 + 2)
    assert(r:get_left() == r:get_midleft()[1] and r:get_centery() == r:get_midleft()[2])
    assert(r:get_midleft()[1] == left0 + 1 and r:get_midleft()[2] == centery0 + 2)

    local r = Rect(1, 1, 4, 4)
    assert(r:get_centerx() == r:get_midbottom()[1] and r:get_bottom() == r:get_midbottom()[2])
    local centerx0 = r:get_centerx()
    local bottom0 = r:get_bottom()
    r:set_midbottom(centerx0 + 1, bottom0 + 2)
    assert(r:get_centerx() == r:get_midbottom()[1] and r:get_bottom() == r:get_midbottom()[2])
    assert(r:get_midbottom()[1] == centerx0 + 1 and r:get_midbottom()[2] == bottom0 + 2)

    local r = Rect(1, 1, 4, 4)
    assert(r:get_centerx() == r:get_midtop()[1] and r:get_top() == r:get_midtop()[2])
    local centerx0 = r:get_centerx()
    local top0 = r:get_top()
    r:set_midtop(centerx0 + 1, top0 + 2)
    assert(r:get_centerx() == r:get_midtop()[1] and r:get_top() == r:get_midtop()[2])
    assert(r:get_midtop()[1] == centerx0 + 1 and r:get_midtop()[2] == top0 + 2)

    local r = Rect(1, 1, 4, 4)
    assert(r:get_centerx() == r:get_center()[1] and r:get_centery() == r:get_center()[2])
    local rc0 = {r:get_center()[1], r:get_center()[2]}
    r:set_center(r:get_center()[1] + 1, r:get_center()[2] + 2)
    assert(r:get_centerx() == r:get_center()[1] and r:get_centery() == r:get_center()[2])
    assert(r:get_center()[1] == rc0[1] + 1 and r:get_center()[2] == rc0[2] + 2)

    local r = Rect(1, 2, 5, 6)
    assert(r:get_centery() == r.y + math.floor(r.h/2))
    local y0 = r.y
    local cy0 = r:get_centery()
    r:set_centery(cy0 + 1)
    assert(r:get_centery() == r.y + math.floor(r.h/2) and r.y == y0 + 1)

    local r = Rect(1, 2, 5, 6)
    assert(r:get_centerx() == r.x + math.floor(r.w/2))
    local x0 = r.x
    local cx0 = r:get_centerx()
    r:set_centerx(cx0 + 1)
    assert(r:get_centerx() == r.x + math.floor(r.w/2) and r.x == x0 + 1)

    local r = Rect(1, 2, 5, 6)
    assert(r:get_left() == r:get_bottomleft()[1])
    assert(r:get_bottom() == r:get_bottomleft()[2])
    r:set_bottomleft(3, 11)
    assert(r:get_left() == r:get_bottomleft()[1] and r:get_left() == 3)
    assert(r:get_bottom() == r:get_bottomleft()[2] and r:get_bottom() == 11)

    local r = Rect(1, 2, 5, 6)
    assert(r:get_right() == r:get_bottomright()[1])
    assert(r:get_bottom() == r:get_bottomright()[2])
    r:set_bottomright(10, 11)
    assert(r:get_right() == r:get_bottomright()[1] and r:get_right() == 10)
    assert(r:get_bottom() == r:get_bottomright()[2] and r:get_bottom() == 11)

    local r = Rect(1, 2, 5, 6)
    assert(r:get_right() == r:get_topright()[1])
    assert(r:get_top() == r:get_topright()[2])
    r:set_topright(10, 11)
    assert(r:get_right() == r:get_topright()[1] and r:get_right() == 10)
    assert(r:get_top() == r:get_topright()[2] and r:get_top() == 11)

    local r = Rect(1, 2, 5, 6)
    assert(r.x == r:get_topleft()[1])
    assert(r.y == r:get_topleft()[2])
    r:set_topleft(2, 3)
    assert(r.x == r:get_topleft()[1] and r.x == 2)
    assert(r.y == r:get_topleft()[2] and r.y == 3)

    local r = Rect(1, 2, 5, 6)
    assert(r:get_size()[1] == 5)
    assert(r:get_size()[2] == 6)
    r:set_size(7, 8)
    assert(r:get_size()[1] == 7)
    assert(r:get_size()[2] == 8)

    local r = Rect(1, 2, 5, 6)
    assert(r:get_right() == r.x + r:get_width())
    local x0 = r.x
    local w0 = r.w
    local r0 = r:get_right()
    r:set_right(7)
    local d_rx = r:get_right() - r0
    assert(r:get_right() == r.x + r:get_width())
    assert(r.x == x0 + d_rx)
    assert(r.w == w0)

    assert(r:get_bottom() == r.y + r.h)
    local y0 = r.y
    local h0 = r.h
    local r0 = r:get_bottom()
    r:set_bottom(9)
    local d_ry = r:get_bottom() - r0
    assert(r:get_bottom() == r.y + r.h)
    assert(r.y == y0 + d_ry)
    assert(r.h == h0)

    assert(r.x == r:get_left())
    r.x = 2
    assert(r.x == r:get_left())

    assert(r.y == r:get_top())
    r.y = 3
    assert(r.y == r:get_top())

    assert(r:get_width() == r.w)
    r.w = 7
    assert(r:get_width() == r.w)

    assert(r:get_height() == r.h)
    r.h = 8
    assert(r:get_height() == r.h)
end
