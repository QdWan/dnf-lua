inspect = require("inspect")
local OrderedDict = require("odict")

local function print_both_ways(d)
    for k, v, i in d:sorted() do
        print(string.format("k:%s, v:%s, i:%d", k, v, i))
    end

    for k, v, i in d:reversed() do
        print(string.format("k:%s, v:%s, i:%d", k, v, i))
    end
end

local letters = {}
for c = 65, 122 do
    letters[#letters + 1] = string.char(c)
end

for i = 1, 2^8 do

    d = OrderedDict()

    for i, v in ipairs(letters) do
        d:insert(v, v)
        assert(d:size() == i)
        assert(d:get_at_index(i) == v)
    end

    for i, v in ipairs(letters) do
        if i ~= #letters then
            d:remove(v)
            assert(d:size() == #letters - i)
        end
    end

    for i, v in ipairs(letters) do
        if i ~= #letters then
            d:insert_at(i, v, v)
            assert(d:size() == i + 1)
            assert(d:get_at_index(i) == v)
        end
    end

    for k, v, i in d:sorted() do
        assert(k == v and v == letters[i])
    end

    for _, v in ipairs(letters) do
        assert(d:remove_at(1) == v)
    end
end

for i, v in ipairs(letters) do d:insert(v, v) end
for k, v, i in d:unsorted() do
    assert(k, v, i)
end
