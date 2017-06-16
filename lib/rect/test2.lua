local Rect = require("rect")

for i = 1, 1000000 do
  r = assert(Rect(1, 2, 3, 4))
  r.x = 4
end
