local fudge_mt = {}
local piece_mt = {}
local anim_mt = {}
local fudge = { max_size = 4096 }

fudge.anim_prefix = "ani_"
--  -- format support by Love2d
local supportedImageFormats = { "png", "bmp", "jpg", "jpeg", "tga" }

local old_draw = love.graphics.draw
local anim_draw, monkey_draw


function anim_draw(anim, frame, ...)
    monkey_draw(anim:getPiece(frame), ...)
end

function monkey_draw(im, ...)
    if fudge.current and type(im)=="string" then
        --Get associate and draw it
        if im:sub(1,fudge.anim_prefix:len())==fudge.anim_prefix then
            monkey_draw(fudge.current:getAnimation(im), ...)
        else
            local fud = fudge.current:getPiece(im)
            old_draw(fud.img, fud.quad, ...)
        end
    elseif type(im)=="table" and im.img and im.quad then
        old_draw(im.img, im.quad, ...)
    elseif type(im)=="table" and im.batch then
        old_draw(im.batch, ...)
    elseif type(im)=="table" and im.framerate then
        anim_draw(im, math.floor(love.timer.getTime()*im.framerate), ...)
    else
        old_draw(im, ...)
    end
end

local function sortAreas(a, b)
    return (a.tex:getHeight()*a.tex:getWidth()) > (b.tex:getHeight()*b.tex:getWidth())
end

local function sortMaxLengths(a, b)
    return math.max(a.tex:getHeight(),a.tex:getWidth()) > math.max(b.tex:getHeight(),b.tex:getWidth())
end

local function sortWidths(a, b)
    return a.tex:getWidth() > b.tex:getWidth()
end

local function sortHeights(a, b)
    return a.tex:getHeight() > b.tex:getHeight()
end

local function sortWidthThenHeight( a, b )
    if a.tex:getWidth() == b.tex:getWidth() then
        return a.tex:getHeight()>b.tex:getHeight()
    else
        return a.tex:getWidth() > b.tex:getWidth()
    end
end

local function split(str, sep)
  local sep, fields = sep or ":", {}
  local pattern = string.format("([^%s]+)", sep)
  str:gsub(pattern, function(c) fields[#fields+1] = c end)
  return fields
end


local function AABB(l1, t1, r1, b1, l2, t2, r2, b2)
    if (
        t2>=b1 or
        l2>=r1 or
        t1>=b2 or
        l1>=r2
    ) then
        return false
    else
        return true
    end
end

local function imAABB(i1, ox1, oy1, i2, ox2, oy2)
    return AABB(
        ox1,
        oy1,
        ox1+i1:getWidth(),
        oy1+i1:getHeight(),
        ox2,
        oy2,
        ox2+i2:getWidth(),
        oy2+i2:getHeight()
    )
end

local function isSupportedImageFormat(ext)
    for _, supportedExt in ipairs(supportedImageFormats) do
        if ext == supportedExt then
            return true
        end
    end
    return false
end

local function getAllImages(folder, images)
    if love.filesystem.getIdentity():len()<1 then
        error("This project does not have an identity set. Please set \"t.identity\" in \"love.conf\" or use \"love.filesystem.setIdentity()\"")
    end
    if not images then
        images = {}
    end
    for i,item in ipairs(love.filesystem.getDirectoryItems(folder)) do
        local itemPath = folder .. "/" .. item
        if love.filesystem.isDirectory(itemPath) then
            images = getAllImages(itemPath, images)
        else
            local split = split(item, ".")
            if isSupportedImageFormat(split[2]) then
                table.insert(images, {
                    name = split[1],
                    tex = love.graphics.newImage(itemPath)
                })
            else
            end
        end
    end
    return images
end

local function putrows(t, mx)
    local rows = {}
    local currentRow = 1
    local x = 0
    local y = 0
    for i,v in ipairs(t) do
        if x+v.tex:getWidth()>mx then
            x=0
            y=y+rows[currentRow][1].tex:getHeight()
            currentRow = currentRow+1
        end
        if not rows[currentRow] then
            rows[currentRow] = {}
        end
        table.insert(rows[currentRow],{
            tex = v,
            x=x,
            y=y
        })
        x = x+v.tex:getWidth()
    end
    return rows
end

local function nsert(node, img)
    --print("nsert")
    if #node.child>0 then
        --print("children")
        --print(node.tagged)
        local cand = nsert(node.child[1], img)
        if cand then
            --print("We good")
            return cand
        end

        --print("Could be a problem...")

        return nsert(node.child[2], img)
    else
        if node.tagged then
            --print("nope, tagged")
            return
        end
        if img.tex:getWidth()>node.rect.w or img.tex:getHeight()>node.rect.h then
            --print("nope, too small",img.tex:getWidth(),img.tex:getHeight(),node.rect.w,node.rect.h)
            return
        end
        if img.tex:getWidth()==node.rect.w and img.tex:getHeight()==node.rect.h then
            --print("perfect, tag it 'n' bag it")
            node.tagged = true
            return node
        end

        --print("splitty splitty")

        node.child[1] = {child = {}}
        node.child[2] = {child = {}}

        local dw = node.rect.w - img.tex:getWidth()
        local dh = node.rect.h - img.tex:getHeight()

        if dw>dh then
            node.child[1].rect = {
                parent = node,
                x = node.rect.x,
                y = node.rect.y,
                w = img.tex:getWidth(),
                h = node.rect.h
            }
            node.child[2].rect = {
                parent = node,
                x = node.rect.x+img.tex:getWidth(),
                y = node.rect.y,
                w = node.rect.w-img.tex:getWidth(),
                h = node.rect.h
            }
        else
            node.child[1].rect = {
                parent = node,
                x = node.rect.x,
                y = node.rect.y,
                w = node.rect.w,
                h = img.tex:getHeight()
            }
            node.child[2].rect = {
                parent = node,
                x = node.rect.x,
                y = node.rect.y+img.tex:getHeight(),
                w = node.rect.w,
                h = node.rect.h-img.tex:getHeight()
            }
        end
        return nsert(node.child[1], img)
    end
end

local function npack(t, mx, my)
    local root = {
        child = {},
        rect = {x = 0, y = 0, w = mx, h = my}
    }
    local id = 0
    local packed = {}
    -- tcop is a copy of t
    local tcop = {}
    for i,v in ipairs(t) do
        tcop[i] = v
    end
    while #tcop>0 do
        local img = tcop[1]
        table.remove(tcop, 1)
        local pnode = nsert(root, img)
        if pnode then
            table.insert(packed,
            {
                tex = img.tex,
                name = img.name,
                x = pnode.rect.x,
                y = pnode.rect.y,
                w = pnode.rect.w,
                h = pnode.rect.h
            })
        else
            error("Fudge texture packing failed: probably the atlas size you specified is too small")
        end
    end
    return packed
end

function fudge.import(name)
    if love.filesystem.getIdentity():len()<1 then
        error("This project does not have an identity set. Please set \"t.identity\" in \"love.conf\" or use \"love.filesystem.setIdentity()\"")
    end

    -- the 'name' may contain a path
    local filepath = ""
    local index = string.find(name, "/[^/]*$")
    if index then
        filepath = string.sub(name, 1, index)
    end

    local do_load_batch = require(name)
    local self = do_load_batch(filepath)

    setmetatable(self, {__index=fudge_mt})
    for k,v in pairs(self.pieces) do
        setmetatable(v, {__index=piece_mt})
    end
    return self
end

local logfn = function() end

--[[TODO: This code is cancerous]]
function fudge.new(folder, options)
    local timeAtStart = love.timer.getTime()
    local options = options or {}
    local self = setmetatable({},{__index=fudge_mt})
    local log = options.log or logfn
    self.images = getAllImages(folder)
    if #self.images == 0 then
        log("[fudge] failed to create sprite atlas: folder '" .. folder .. "'' doesn't contain any images")
        return nil
    end
    if options.preprocess_images then
        for _, preprocess in ipairs(options.preprocess_images) do
            self.images = preprocess(self.images) or self.images
        end
    end
    ---[[
    local maxWidth = 0
    local area = 0
    for i,v in ipairs(self.images) do
        maxWidth = math.max(maxWidth, v.tex:getWidth())
        area = area + v.tex:getWidth()*v.tex:getHeight()
    end
    --]]
    local width = options.npot and maxWidth or 16
    while width<maxWidth do
        width = width * 2
    end

    table.sort(self.images, sortMaxLengths)
    local size = math.min(fudge.max_size, options.size or
                          love.graphics.getSystemLimits().texturesize)
    width = size
    local height = size
    local maxHeight
    self.pack, maxHeight = npack(self.images, width, height)
    self.width = width
    self.height = height
    log("Atlas will be size", width, height)
    self.canv = love.graphics.newCanvas(width, height)
    local old_cv = love.graphics.getCanvas()
    love.graphics.setCanvas(self.canv)
    love.graphics.push()
        love.graphics.origin()
        love.graphics.setColor(255,255,255,255)
        for i,v in ipairs(self.pack) do
            log("Adding image", i, "/", #self.pack, "to atlas")

            love.graphics.draw(v.tex,v.x,v.y)
        end
    love.graphics.pop()

    love.graphics.setCanvas(old_cv)
    self.image = love.graphics.newImage(self.canv:newImageData())
    self.pieces = {}
    log("Saving piece quads in table")
    for i,v in ipairs(self.pack) do
        log("Saving quad for", v.name)
        self.pieces[v.name] = {
            img = self.image,
            quad = love.graphics.newQuad(v.x, v.y, v.w, v.h, width, height),
            w = v.w,
            h = v.h,
            x = v.x,
            y = v.y
        }
        setmetatable(self.pieces[v.name], {__index=piece_mt})
    end
    self.batch = love.graphics.newSpriteBatch(self.image, (options and options.batchSize or nil))
    self.canv = nil
    self.images = nil
    self.pack = nil
    self.area = area
    self.time = math.floor((love.timer.getTime()-timeAtStart)*100)/100
    self.anim = {}
    return self
end

function fudge.set(option, value)
    if type(option)=="table" then
        for k,v in pairs(option) do
            fudge.set(k, v)
        end
        return
    end
    ;({
        max_size = function(v)
            fudge.max_size = v
        end,
        current = function(v)
            fudge.current = v
        end,
        monkey = function(v)
            if (v) then
                love.graphics.draw = monkey_draw
            else
                love.graphics.draw = old_draw
            end
        end,
        anim_prefix = function(v)
            local old_prefix = fudge.anim_prefix
            fudge.anim_prefix = v
            --[[
                Do prefix fixing here
            ]]
        end
    })[option](value)
end

fudge.draw = monkey_draw

function fudge.addq(...)
    fudge.current:addq(...)
end

function fudge.addb(...)
    fudge.current:addb(...)
end

function fudge.setColorb(...)
    fudge.current:setColorb(...)
end

function fudge.setWhiteb()
    fudge.current:setWhiteb()
end

function fudge_mt:getPiece(name)
    if not self.pieces[name] then
        error("There is no piece named \""..name.."\"")
        return
    end
    return self.pieces[name]
end

function fudge_mt:getAnimation(name, frame)
    if frame then
        return self:getAnimation(name):getPiece(frame)
    else
        if not self.anim[name] then
            error("There is no animation named \""..name.."\"")
        end
        return self.anim[name]
    end
end

function fudge_mt:chopToAnimation(piecename, number, options)
    local options = options or {}
    local numlen = (""..number):len()
    local piece = self:getPiece(piecename)
    local stepsize = piece:getWidth()/number
    local animation = {}
    for i=1,number do
        self.pieces[piecename.."_"..string.format("%0"..numlen.."d", i)] = {
            img = self.image,
            quad = love.graphics.newQuad(
                piece.x+(i-1)*stepsize,
                piece.y,
                stepsize,
                piece.h,
                self.width,
                self.height)
        }
        table.insert(animation, piecename.."_"..string.format("%0"..numlen.."d", i))
    end
    self:animate((options.name or piecename), animation, options)
end

function fudge_mt:animate(name, frames, options)
    local options = options or {}
    local prefix = options.prefix or fudge.anim_prefix
    self.anim[prefix..name] = setmetatable({
        framerate = options.framerate or 10
    }, {__index = anim_mt})
    for i,v in ipairs(frames) do
        table.insert(self.anim[prefix..name], self:getPiece(v))
    end
end

function fudge_mt:addq(quad, ...)
    self.batch:add(quad, ...)
end

function fudge_mt:addb(piece, ...)
    piece = type(piece)=="string" and self:getPiece(piece) or piece
    self.batch:add(piece.quad, ...)
end

function fudge_mt:addb_centered(piece, x, y, r)
    piece = type(piece)=="string" and self:getPiece(piece) or piece

    local q = piece.quad
    local _, __, w, h = q:getViewport()

    self.batch:add(q, x, y, r, 1, 1, w*0.5, h*0.5)

end

function fudge_mt:clearb()
    self.batch:clear()
end

function fudge_mt:draw(piece, ...)
    piece = type(piece)=="string" and self:getPiece(piece) or piece
    old_draw(piece.img, piece.quad, ...)
end

function fudge_mt:setColorb(r, g, b, a)
    self.batch:setColor(r, g, b, a)
end

function fudge_mt:setWhiteb(a)
    self.batch:setColor(255, 255, 255, a or 255)
end

function fudge_mt:setBlackb(a)
    self.batch:setColor(0, 0, 0, a or 255)
end

function fudge_mt:setImageFilter(...)
    self.image:setFilter(...)
end

function fudge_mt:export(name, options)
    if love.filesystem.getIdentity():len()<1 then
        error("This project does not have an identity set. Please set \"t.identity\" in \"love.conf\" or use \"love.filesystem.setIdentity()\"")
    end
    local options = options or {}
    local image_extension = options.image_extension or "png"
    self.image:getData():encode(image_extension, name.."."..image_extension)
    string = "return function(path)\n"
    string = string.. "local file = (path or \"\").. \""..name.."."..image_extension.."\"\n"
    string = string.."local f = {"
    string = string.."width="..self.width..","
    string = string.."height="..self.height..","
    string = string.."image=love.graphics.newImage(file)}\n"
    string = string.."f.batch=love.graphics.newSpriteBatch(f.image, "..self.batch:getBufferSize()..")\n"
    string = string.."f.pieces = {}\n"
    for k,v in pairs(self.pieces) do
        string = string.."f.pieces['"..k.."']={"
        string = string.."img=f.image,"
        string = string.."quad=love.graphics.newQuad("..v.x..","..v.y..","..v.w..","..v.h..","..self.width..","..self.height.."),"
        string = string.."x="..v.x..","
        string = string.."y="..v.y..","
        string = string.."w="..v.w..","
        string = string.."h="..v.h.."}\n"
    end
    string = string.."f.anim = {}\n"
    string = string.."return f\n"
    string = string.."end"
    love.filesystem.write(name..".lua", string)
end

function fudge_mt:rename(old, new)
    if self.pieces[new] then
        error("There is already a piece with name: \""..new.."\".")
        return
    end
    if not self.pieces[old] then
        error("There is no piece named \""..old.."\" to rename")
        return
    end
    self.pieces[new], self.pieces[old] = self.pieces[old], nil
end

function piece_mt:getWidth()
    return self.w
end

function piece_mt:getHeight()
    return self.h
end

function anim_mt:getPiece(frame)
    return self[((frame-1)%#self)+1]
end

return fudge
