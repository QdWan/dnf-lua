local class = require('middleclass')

local FONTS = {
    caladea = {
        font_regular = 'caladea-regular.ttf',
        font_italic = 'caladea-italic.ttf',
        font_bold = 'caladea-bold.ttf',
        font_bolditalic = 'caladea-bolditalic.ttf'
    }
}

local DEFAULT = {
    font_alias = 'caladea',
    size = 20,
    indent = 0,
    bold = false,
    italic = false,
    color = {128, 144, 160, 255},  -- RGB values
    align = 'left'
}

local Style = class('Style')

function Style:initialize(style)
    self.default_style = self:new_style(style)
end

function Style:new_style(style)
    --[[Create a new style, based on the passed parameters.

    Missing fields are filled with default values.

    Args:
        args(table): table with the new parameters.

    Returns:
        table
    --]]
    local style = style or {}
    for k, v in pairs(DEFAULT) do
        if style[k] == nil then
            style[k] = v
        end
    end
    local f = FONTS[style['font_alias']]
    if not f then
        error("invalid font: load_font is required before using a font.")
    else
        style["font"] = f
    end
    return style
end

function Style:load_font(alias, regular, bold, italic, bolditalic)
    local FONTS = FONTS
    FONTS[alias] = {
        regular = regular,
        bold = bold,
        italic = italic,
        bolditalic
    }
end

function Style:set_default(source)
    local default_style = self.default_style
    if type(source) == "table" then
        local key, value
        for key, value in pairs(source) do
            default_style[key] = value
        end
    elseif type(source) == "string" then
        local string, style = self:split(source)
        self:set_default(style)
    end
end

function Style:split(string)
    self.string = string or self.string
    self:_get_style()
    return self.string, self.style
end

function Style:_get_style()
    local default_style = self.default_style
    local style = {}
    style['font_alias'] = self:_get_font()
    style['size'] = self:_get_size()
    style['bold'] = self:_get_bold()
    style['italic'] = self:_get_italic()
    style['color'] = self:_get_color()
    style['align'] = self:_get_align()
    style['indent'] = self:_get_indent()
    self.style = self:new_style(style)
    return self.style
end

function Style:_get_font()
    --Get a font name if specified.
    local pattern = "{font_alias +'*([%a%d_%-]+)(%.*[tf]*)'*}"
    local _, font, ext = string.match(self.string, pattern)
    self.string = string.gsub(self.string, pattern, "")
    return font
end

function Style:_get_size()
    local pattern = "{(f*o*n*t*_*)size +'*(%d+)'*}"
    local _, size = string.match(self.string, pattern)
    size = tonumber(size)
    self.string = string.gsub(self.string, pattern, "")
    return size
end

function Style:_get_bold()
    local patterns = {
    "{bold +'*([fF]alse)'*}",
    "{bold +'*([tT]rue)'*}"
    }
    local bold = nil
    for _, pattern in ipairs(patterns) do
        bold = string.match(self.string, pattern)
        if bold ~= nil then
            bold = string.lower(bold)
            if bold == "false" then
                bold = false
            elseif bold == "true" then
                bold = true
            end
            self.string = string.gsub(self.string, pattern, "")
            break
        end
    end
    return bold
end

function Style:_get_italic()
    local patterns = {
    "{italic +'*([fF]alse)'*}",
    "{italic +'*([tT]rue)'*}"
    }
    local italic = nil
    for _, pattern in ipairs(patterns) do
        italic = string.match(self.string, pattern)
        if italic ~= nil then
            italic = string.lower(italic)
            if italic == "false" then
                italic = false
            elseif italic == "true" then
                italic = true
            end
            self.string = string.gsub(self.string, pattern, "")
            break
        end
    end
    return italic
end

function Style:_get_color()
    local pattern = [[{(f*o*n*t*_*)color +["']*%(*([%d]+), *([%d]+), *([%d]+),* *([%d]*)%)*["']*}]]
    local _, r, g, b, a = string.match(self.string, pattern)
    local color = self.default_style["color"]
    local t = {r, g, b, a}
    for i = 1, #color do
        t[i] = tonumber(t[i] or color[i])
    end
    self.string = string.gsub(self.string, pattern, "")
    return t
end

function Style:_get_align()
    local patterns = {
        [[{(f*o*n*t*_*)align +["']*([Ll]eft)["']*}]],
        [[{(f*o*n*t*_*)align +["']*([Rr]ight)["']*}]],
        [[{(f*o*n*t*_*)align +["']*([Cc]enter)["']*}]]
    }
    local pattern = nil
    local align = nil
    local _, align
    for i = 1,#patterns do
        pattern = patterns[i]
        _, align = string.match(self.string, pattern)
        if align ~= nil then
            align = string.lower(align)
            self.string = string.gsub(self.string, pattern, "")
            break
        end
    end
    return align
end

function Style:_get_indent()
    local pattern = "{(f*o*n*t*_*)indent +'*(%d+)'*}"
    local _, indent = string.match(self.string, pattern)
    indent = tonumber(indent)
    self.string = string.gsub(self.string, pattern, "")
    return indent
end

return Style
