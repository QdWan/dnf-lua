local Properties = require('properties')
local Shaders = class("Shaders"):include(Properties)

local OUTLINE_GLOW = "lib/shaders/outline_glow.glsl"

function Shaders:getter_outline_glow()
    if self._outline_glow == nil then
        print("caching 'outline_glow.glsl'")
        self._outline_glow = love.graphics.newShader(OUTLINE_GLOW)
    end
    return self._outline_glow
end

return Shaders
