local inspect = require("inspect")

local RangedTable = require("rangedtable")

rt = RangedTable({
    {{1, 5},  "a1-5 value"},
    {{6, 10}, "a6-9 value"}
})

print(rt:get(1), rt:get(2), rt:get(3), rt:get(3), rt:get(4), rt:get(5))

rt = RangedTable({
    {{1, 5},  "b1-5 value"},
    {{6, 10}, "b6-9 value"}
})

print(rt[6], rt[7], rt[8], rt[9], rt[10])
print(rt:get(6), rt:get(7), rt:get(8), rt:get(9), rt:get(10))

rt = RangedTable({
    {{"aba", "dada"}, "1-5 value"},
    {{"fafa", "gaga", "kakaka"}, "6-9 value"}
})

print(rt:get("aba"))
print(rt:get("kakaka"))

rt = RangedTable({
    {10, "first"},
    {5, "second"},
    {15, "third"}
})

print(rt:size())

classes = {"alchemist", "brawler", "cleric", "druid", "hunter",
           "inquisitor", "magus", "monk", "warpriest", "wizard"}
print(classes["barbarian"])
