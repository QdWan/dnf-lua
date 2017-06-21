local time = time or require("time").time

local function test(fn, times, name)
    name = name or "?"
    local t0 = time()
    for i = 1, times do
        fn()
    end
    local t1 = time()
    return string.format("Test(%s): %d times took %fs", name, times, t1 - t0)
end
return test
