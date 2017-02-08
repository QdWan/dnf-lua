local Widget = require("widgets.base")

local RectWidget = class("RectWidget", Widget)

function RectWidget:draw()
    love.graphics.setColor(self.bg_color)
    love.graphics.rectangle("fill", self.x, self.y, self.w, self.h)
end

return RectWidget
