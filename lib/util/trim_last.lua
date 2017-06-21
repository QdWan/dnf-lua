local utf8 = require("utf8")

local function trim_last(str)
    local byteoffset = utf8.offset(str, -1)

    -- remove the last UTF-8 character.
    -- string.sub operates on bytes rather than UTF-8 characters, so we couldn't do string.sub(text, 1, -2).
    return byteoffset and str:sub(1, byteoffset - 1) or str
end

return trim_last
