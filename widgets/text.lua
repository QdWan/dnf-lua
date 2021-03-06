local Style = require("style")
local split = require("util.split")

local Widget = require("widgets.base")


local Text = class('Text', Widget)
local margin = 18

function Text:init(args)
    Widget.init(self, args)

    local style = Style()
    if self.style ~= nil then
        style.set_default(style)
    end
    self.style = style
    self.canvases = {}
end

function Text:prepare()
    local cache = self.canvases[self.text]
    if cache then
        local previous = self.canvas
        self.canvas = cache.canvas
        self.start_y = cache.start_y
        self.end_y = cache.end_y
        self.parsed = cache.parsed
        self.dy = self.start_y
        if self.canvas ~= previous then
            self:draw_canvas()
        end
        return
    end
    self.parsed = {}

    self.canvas = love.graphics.newCanvas(self.w, self.h)

    self:load_fonts()

    self:parse_text()

    self:draw_canvas()

    self.canvases[self.text] = {
        canvas = self.canvas,
        start_y = self.start_y,
        end_y = self.end_y,
        parsed = self.parsed
    }
end

function Text:load_fonts(data)
    local style = data or self.style.default_style
    local alias = style["font_alias"]
    local size  = style["size"]
    local regular  = style["font"]["font_regular"]
    local bold  = style["font"]["font_bold"]
    local italic  = style["font"]["font_italic"]
    local bolditalic  = style["font"]["font_bolditalic"]

    local function newFont(name, size)
        return manager.resources:font(name, size)
    end

    self.fonts = self.fonts or {}

    local fonts = self.fonts

    fonts[alias] = fonts[alias] or {}
    fonts[alias][size] = fonts[alias][size] or {}

    local font = fonts[alias][size]

    font["regular"] = newFont(regular, size)
    local types = {bold = bold, italic = italic, bolditalic = bolditalic}
    for k, v in pairs(types) do
        if v then
            font[k] = newFont(v, size)
        end
    end
    return font
end

function Text:set_font(data)
    local default_style = self.style.default_style
    local alias = data['font_alias'] or default_style['font_alias']
    local size = data['size'] or default_style['size']
    local bold = data['bold'] or default_style['bold']
    local italic = data['italic'] or default_style['italic']
    local fonts = self.fonts
    local font = fonts[alias][size] or self:load_fonts(data)

    local font_obj
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

    local font_obj = font["regular"]
    -- love.graphics.setFont(font_obj)
    return font_obj
end

function Text:parse_text()
    local margin = margin
    local parsed = self.parsed
    local Style = self.style
    local Font
    local scr_w = self.w
    local line, line_n, styles, style

    local default_style = Style.default_style

    local lines = split(self.text, "\n")
    local y = 0
    local wrap
    for line_n = 1, #lines do
        line = lines[line_n]
        styles = split(line, "{style}")
        local x = 0
        local text, styled_txt
        for style_n = 1, #styles do
            style = styles[style_n]
            -- print('splitting style...')
            text, styled_txt = Style:split(style)

            Font = self:set_font(styled_txt)

            -- determine the amount of space needed to render text
            local wraps = self:wrap_text(text, x, styled_txt, Font)
            -- print('wrapping...')
            for i = 1, #wraps do
                wrap = wraps[i]
                local rect = Rect(
                    0, 0,
                    Font:getWidth(wrap['text']), Font:getHeight(wrap['text'])
                )
                local w = Font:getWidth(" ")

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
                    rect:set_midtop(math.floor(self.w / 2),
                                    self:get_bottom() + y)
                else
                    rect:set_topleft(x + w * 3,
                                     self:get_bottom() + y)
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

    -- TODO fix this hack
    self.start_y = -parsed[1]["h"] * 2
    self.dy = self.start_y

    self.end_y = -(self:sum_height() - self.h + parsed[1]["h"] * 3)
    print("Text.end_y = ", self.end_y)
    print("Text.default_h = ", self.default_h)
end

function Text:wrap_text(text, x, styled_txt, Font)
    -- TODO fix this hack
    local margin = margin + 4
    local break_chars = "[ ,%.%-\n]"
    local style = {}
    local scr_w = self.w
    local _end, _string, forced
    for k, v in pairs (styled_txt) do
        style[k] = v
    end

    local txt_w = Font:getWidth(text)
    if txt_w <= (scr_w - x - margin) or #text == 0 then
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
        if txt_w <= (scr_w - x - margin) then
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
            local _, txt_w = xpcall(function()
                return Font:getWidth(_string)
            end,
            print)
            if txt_w ~= nil and txt_w > (scr_w - x - margin) then
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
                local c = string.sub(wrap, i, i)
                if string.find(c, break_chars) or forced then
                    -- fit = wrap[:i]
                    local fit = string.sub(wrap, 1, i)
                    -- remains = wrap[i:]
                    local remains = string.sub(wrap, i + 1)
                    style['text'] = fit
                    style['w1'] = Font:getWidth(fit)
                    style["h"] = Font:getHeight(fit)
                    local wrapped_len = #wrapped
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
                print(string.format("text = '%s'", text))
                print("scr_w =", scr_w)
                print(string.format("txt_w = '%d'", txt_w))
                print(string.format(
                    "(scr_w - x - margin) = '%d'", (scr_w - x - margin)))
                print("x =", x)
                print("space_left =", (scr_w - x))
                print("'w1' =", Font:getWidth(text))
                print(string.format("forced = %s", tostring(forced)))
                print("styled_txt =", styled_txt)
                print("#######")
                error("stuck in while loop")
            end
            iterations = iterations + 1
        end
    end
    return wrapped
end

function Text:sum_height()
    local max = 0
    local parsed = self.parsed
    for i = 1, #parsed do
        local item = parsed[i]
        max = math.max(max, item['y'] + item['h'])
    end
    print("Text:sum_height = ", max)
    return max
end

function Text:scroll(dy)
    local old_y = self.dy

    self.dy = self.dy + 12 * dy

    if self.dy < self.end_y then
        self.dy = self.end_y
    elseif self.dy > self.start_y then
        self.dy = self.start_y
    end
    if self.dy ~= old_y then
        self:draw_canvas()
    end
end

function Text:draw_canvas()
    self.canvas:renderTo(function()
        local parsed = self.parsed;
        local lg = love.graphics;
        local print_txt = lg.print;
        local setColor = lg.setColor;
        local setFont = lg.setFont;
        local scr_h = self.h;
        local i, item, text, font_obj, y, h, rect;

        lg.clear();
        --
        for i = 1, #parsed do
            item = parsed[i];
            text = item["text"];
            if text ~= nil and text ~= "" then
                rect = item["rect"];
                y = rect.y + self.dy - scr_h;
                if y < scr_h and y > -40 then
                    font_obj = self:set_font(item);
                    setColor(item["color"]);
                    setFont(font_obj);
                    print_txt(text, rect.x, y);
                end;
            end;
        end;
    end)
end

function Text:draw()
    love.graphics.setBlendMode("alpha", "premultiplied")

    if self.bg_color ~= nil then
        love.graphics.setColor(self.bg_color)
        love.graphics.rectangle(
            "fill",
            self.x, self.y,
            self.w, self.h)
    end

    love.graphics.setColor({255, 255, 255, 255})

    love.graphics.draw(self.canvas, self.x, self.y)
    love.graphics.setBlendMode("alpha")
end

return Text
