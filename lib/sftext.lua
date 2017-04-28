require('ext.ext')
local class = require('middleclass')  -- https://github.com/kikito/middleclass
local Style = require("style.style")
local inspect = require("inspect")  -- https://github.com/kikito/inspect.lua
local Rect = require("rect.rect")
require("split.split")

local SFText = class('SFText')
local margin = 20

function SFText:initialize(text, x, y, w, h, style, fonts)
    self.text = text
    if not love then
        print("no love found :( ; using debug ('fake') love")
        love = dofile("debug.lua")
        love = love()
    end

    local love_x, love_y, display = love.window.getPosition()
    local love_w, love_h = love.graphics.getDimensions()
    local w = w or love_w
    local h = h or love_h
    self.rect = Rect(x or love_x, y or love_y, w, h)

    self.style = Style()
    if style ~= nil then
        self.style.set_default(style)
    end

    self.parsed = {}

    self.canvas = love.graphics.newCanvas(w, h)

    self.system_font = love.graphics.getFont( )

    self:load_fonts()

    self:parse_text()

    self:draw_canvas()

end

function SFText:load_fonts(data)
    local style = data or self.style.default_style
    local alias = style["font_alias"]
    local size  = style["size"]
    local regular  = style["font"]["font_regular"]
    local bold  = style["font"]["font_bold"]
    local italic  = style["font"]["font_italic"]
    local bolditalic  = style["font"]["font_bolditalic"]

    newFont = love.graphics.newFont

    self.fonts = self.fonts or {}

    local fonts = self.fonts

    fonts[alias] = fonts[alias] or {}
    fonts[alias][size] = fonts[alias][size] or {}

    font = fonts[alias][size]

    font["regular"] = newFont('fonts/' .. regular, size)
    local types = {bold = bold, italic = italic, bolditalic = bolditalic}
    for k, v in pairs(types) do
        if v then
            font[k] = newFont('fonts/' .. v, size)
        end
    end
    return font
end

function SFText:set_font(data)
    local default_style = self.style.default_style
    local alias = data['font_alias'] or default_style['font_alias']
    local size = data['size'] or default_style['size']
    local bold = data['bold'] or default_style['bold']
    local italic = data['italic'] or default_style['italic']
    local fonts = self.fonts
    local font = fonts[alias][size] or self:load_fonts(data)

    if not bold and not italic then do end
    elseif bold and italic then
        font_obj = font["bolditalic"] or font["regular"]
        -- love.graphics.setFont(font_obj)
        return font_obj
    elseif bold then
        font_obj = font["bold"] or font["regular"]
        -- love.graphics.setFont(font_obj)
        return font_obj
    elseif italic then
        font_obj = font["italic"] or font["regular"]
        -- love.graphics.setFont(font_obj)
        return font_obj
    end

    font_obj = font["regular"]
    -- love.graphics.setFont(font_obj)
    return font_obj
end

function SFText:parse_text()
    local margin = margin
    local parsed = self.parsed
    local Style = self.style
    local Font
    local scr_w = self.rect.w
    local line, line_n, styles, style

    default_style = Style.default_style

    lines = self.text:split("\n")
    local y = 0
    for line_n = 1, #lines do
        line = lines[line_n]
        styles = line:split("{style}")
        local x = 0
        for style_n = 1, #styles do
            style = styles[style_n]
            -- print('splitting style...')
            text, styled_txt = Style:split(style)
            self.clean_text = text

            Font = self:set_font(styled_txt)

            -- determine the amount of space needed to render text
            wraps = self:wrap_text(text, x, styled_txt, Font)
            -- print('wrapping...')
            for i = 1, #wraps do
                wrap = wraps[i]
                rect_w = Font:getWidth(wrap['text'])
                rect_h = Font:getHeight(wrap['text'])
                rect = Rect(0, 0, rect_w, rect_h)
                w = Font:getWidth(" ")

                --[[
                # ################
                # Calculate remaining space on the row, escaping to the
                # next one if necessary.
                # (x, scr_w, size_func, alias, font_size)
                ]]--
                if wrap['w1'] > (scr_w - x - margin) then
                    x = 0
                    y  = y  + wrap['h']
                -- # ################
                end

                if #wraps == 1 and wrap['align'] == 'center' then
                    rect.midtop = {math.floor(self.rect.w / 2),
                                   self.rect.bottom + y}
                else
                    rect.topleft = {x + w * 3,
                                    self.rect.bottom + y}
                end
                wrap['rect'] = rect
                wrap['x'] = x
                wrap['y'] = y
                --[[
                print("\n{}: {},".format('x', wrap['x']), end='')
                print("{}: {},".format('y', wrap['y']), end='')
                print("{}: {},".format('w', wrap['w']), end='')
                print("{}: {}".format('h', wrap['h']))
                print(wrap['text'])
                ]]--
                parsed[#parsed + 1] = wrap

                x = x + wrap['w1']
            -- print('done!')
            end
        end
        y = y + wrap['h']
    end
    -- os.exit()
    -- print('done parsing')
    local alias = self.style.default_style["font_alias"]
    local size = self.style.default_style["size"]
    local default_Font = self.fonts[alias][size]["regular"]
    self.default_h = default_Font:getHeight(' ')

    self.start_y = 0
    self.y = self.start_y

    local end_y = self:sum_height() - self.rect.h
    self.end_y = -end_y
    print("SFText.end_y = ", self.end_y)
    print("SFText.default_h = ", self.default_h)
end

function SFText:wrap_text(text, x, styled_txt, Font)
    local margin = margin
    local break_chars = "[ ,%.%-\n]"
    local style = {}
    local scr_w = self.rect.w
    local _end, _string, forced
    for k, v in pairs (styled_txt) do
        style[k] = v
    end

    local txt_w = Font:getWidth(text)
    if txt_w < (scr_w - x - margin) or #text == 0 then
        style['text'] = text
        style['w1'] = txt_w
        style["h"] = Font:getHeight(text)
        return {style}
    end

    local wrapped = {text}

    local iterations = 1
    while true do
        local wrap = wrapped[#wrapped]

        -- First case: it fits entirely
        txt_w = Font:getWidth(wrap)
        if txt_w < (scr_w - x - margin) then
            -- It fits, let's pack it and break.
            style['text'] = wrap
            style['w1'] = txt_w
            style["h"] = Font:getHeight(wrap)
            local wrapped_len = #wrapped
            local last_wrap = wrapped[#wrapped]
            wrapped[wrapped_len] = {}
            for k, v in pairs(style) do
                wrapped[wrapped_len][k] = v
            end
            break
        end

        --[[
        Second case
        We see how many chars can fit in the space
        end + 1 will not exceed the string length or the first case
        would have to be valid
        ]]
        for _end = 1, #wrap - 1 do
            _string = string.sub(wrap, 1, _end + 1)
            txt_w = Font:getWidth(_string)
            if txt_w >= (scr_w - x - margin) then
                break
            end
        end

        if string.find(_string, break_chars) then
            forced = false
        else
            forced = true
        end

        if forced and x ~= 0 then
            x = 0
        else
        -- We now look for break_chars in the end of the fragment
            local i = #_string
            while i > 0 do
                c = string.sub(wrap, i, i)
                if string.find(c, break_chars) or forced then
                    -- fit = wrap[:i]
                    fit = string.sub(wrap, 1, i)
                    -- remains = wrap[i:]
                    remains = string.sub(wrap, i + 1)
                    style['text'] = fit
                    style['w1'] = Font:getWidth(fit)
                    style["h"] = Font:getHeight(fit)
                    wrapped_len = #wrapped
                    wrapped[wrapped_len] = {}
                    for k, v in pairs(style) do
                        wrapped[wrapped_len][k] = v
                    end
                    wrapped[wrapped_len + 1] = remains
                    x = 0
                    break
                elseif iterations > 80 then
                    printf("wrap = '%s'(#%d), i = %d", wrap, #wrap, i)
                end
                i =  i - 1
            end
            if iterations > 100 then
                print("#######")
                printf("text = '%s'", text)
                print("scr_w =", scr_w)
                printf("txt_w = '%d'", txt_w)
                printf("(scr_w - x - margin) = '%d'", (scr_w - x - margin))
                print("x =", x)
                print("space_left =", (scr_w - x))
                print("'w1' =", Font:getWidth(text))
                printf("forced = %s", tostring(forced))
                print("styled_txt =", styled_txt)
                print("#######")
                error("stuck in while loop")
            end
            iterations = iterations + 1
        end
    end
    return wrapped
end

function SFText:sum_height()
    local max = 0
    local parsed = self.parsed
    for i = 1, #parsed do
        item = parsed[i]
        max = math.max(max, item['y'] + item['h'])
    end
    print("SFText:sum_height = ", max)
    return max
end

function SFText:scroll(dy)
    self.y = self.y + 4 * dy

    if self.y < self.end_y then
        self.y = self.end_y
    elseif self.y > 0 then
        self.y = 0
    end
    if self.y ~= old_y then
        self:draw_canvas()
    end
end

function SFText:draw_canvas()
    self.canvas:renderTo(function()
        local parsed = self.parsed;
        local lg = love.graphics;
        local print_txt = lg.print;
        local setColor = lg.setColor;
        local setFont = lg.setFont;
        local scr_h = self.rect.h;
        local i, item, text, font_obj, y, h, rect;

        lg.clear();
        --
        for i = 1, #parsed do
            item = parsed[i];
            text = item["text"];
            if text then
                rect = item["rect"];
                y = rect.y + self.y - self.rect.h;
                if y < scr_h then
                    font_obj = self:set_font(item);
                    setColor(item["color"]);
                    setFont(font_obj);
                    print_txt(text, rect.x, y);
                end;
            end;
        end;
      setFont(self.system_font);
      setColor(255, 255, 255, 255);
    end)
end

function SFText:draw()
    love.graphics.setBlendMode("alpha")
    love.graphics.draw(self.canvas)
end

return SFText
