local OrderedDict = require("ordered_dict")
local function print_both_ways(d)
    for k, v, i in d:items() do
        print(string.format("k:%s, v:%s, i:%d", k, v, i))
    end

    for k, v, i in d:items(true) do
        print(string.format("k:%s, v:%s, i:%d", k, v, i))
    end
end

d = OrderedDict()
d:add("a", "a")
d:add("b", "b")
d:add("c", "c")
print("count", d:size())
print_both_ways(d)

d:remove("b")
print("count", d:size())
print_both_ways(d)

d:add("b", "b")
print("count", d:size())
print_both_ways(d)

d:remove_at(2)
print("count", d:size())
d:add("c", "c")
print("count", d:size())
print_both_ways(d)

d:insert_at(1, "A", "A")
print("count", d:size())
print_both_ways(d)

d:insert_at(3, "B", "B")
print("count", d:size())
print_both_ways(d)

d:insert_at(6, "C", "C")
print("count", d:size())
print_both_ways(d)
