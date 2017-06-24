local w = lg.getSystemLimits().texturesize
love.graphics.newCanvas(w, w)

return setmetatable({}, {__call = love.event.quit})
