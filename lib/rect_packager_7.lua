--[[Lua port of GuillotineBinPack.cpp by Jukka Jylänki.

Original available at:
https://github.com/juj/RectangleBinPack/blob/master/GuillotineBinPack.cpp
]]--

local Rect = require("Rect")

local GuillotineBinPack = {}
GuillotineBinPack.__index = GuillotineBinPack

setmetatable(
    GuillotineBinPack,
    {
        __call = function (class, ...)
            local self = setmetatable({}, class)
            if self.initialize then
                self:initialize(...)
            end
            return self
        end
    }
)

function GuillotineBinPack:initialize(width, height)
    binWidth = width
    binHeight = height

    -- Clear any memory of previously packed rectangles.
    usedRectangles:clear()

    -- We start with a single big free rectangle that spans the whole bin.
    local n = Rect(0, 0, width, height)

    freeRectangles:clear()
    freeRectangles:push_back(n)
end

function GuillotineBinPack:insert(rects, merge, rectChoice, splitMethod)
    -- Remember variables about the best packing choice we have made so far during the iteration process.
    local bestFreeRect = 0
    local bestRect = 0

    -- Pack rectangles one at a time until we have cleared the rects array of all rectangles.
    -- rects will get destroyed in the process.
    while rects:size() > 0 do
        -- Stores the penalty score of the best rectangle placement - bigger=worse, smaller=better.
        local bestScore = math.huge
        for i = 1, freeRectangles:size() do
            for j = 1, rects:size() do

                -- If this rectangle is a perfect match, we pick it instantly.
                if (rects[j].width == freeRectangles[i].width and
                    rects[j].height == freeRectangles[i].height) then
                    bestFreeRect = i
                    bestRect = j
                    bestScore = -math.huge
                    -- Force a jump out of the outer loop as well - we got an instant fit.
                    i = freeRectangles:size()
                    break;
                -- Try if we can fit the rectangle upright.
                elseif (rects[j].width <= freeRectangles[i].width and
                        rects[j].height <= freeRectangles[i].height) then
                    local score = ScoreByHeuristic(
                        rects[j].width, rects[j].height,
                        freeRectangles[i], rectChoice)
                    if score < bestScore then
                        bestFreeRect = i
                        bestRect = j
                        bestScore = score
                    end
                end
            end
        end

        -- If we didn't manage to find any rectangle to pack, abort.
        if bestScore == math.huge then
            return
        end

        -- Otherwise, we're good to go and do the actual packing.
        local newNode = Rect(
            freeRectangles[bestFreeRect].x,
            freeRectangles[bestFreeRect].y,
            rects[bestRect].width,
            rects[bestRect].height
        )

        -- Remove the free space we lost in the bin.
        SplitFreeRectByHeuristic(
            freeRectangles[bestFreeRect], newNode, splitMethod)
        freeRectangles:erase(freeRectangles.begin() + bestFreeRect)

        -- Remove the rectangle we just packed from the input list.
        rects.erase(rects.begin() + bestRect)

        -- Perform a Rectangle Merge step if desired.
        if merge then
            MergeFreeList()
        end

        -- Remember the new used rectangle.
        usedRectangles.push_back(newNode);

        -- Check that we're really producing correct packings here.
        debug_assert(disjointRects:add(newNode) == true)
    end
end

-- @return True if r fits inside freeRect (possibly rotated).
function Fits(r, freeRect)
    return ((r.width <= freeRect.width and r.height <= freeRect.height) or
            (r.height <= freeRect.width and r.width <= freeRect.height))
end

-- @return True if r fits perfectly inside freeRect, i.e. the leftover area is 0.
function FitsPerfectly(r, freeRect)
    return ((r.width == freeRect.width and r.height == freeRect.height) or
            (r.height == freeRect.width and r.width == freeRect.height))
end

function GuillotineBinPack:insert(
    width, height, merge, rectChoice, splitMethod
)
    -- Find where to put the new rectangle.
     -- TODO
    local newRect, freeNodeIndex = FindPositionForNewNode(
        width, height, rectChoice, freeNodeIndex)

    -- Abort if we didn't have enough space in the bin.
    if newRect.height == 0 then
        return newRect
    end

    -- Remove the space that was just consumed by the new rectangle.
    SplitFreeRectByHeuristic(
        freeRectangles[freeNodeIndex], newRect, splitMethod)
    freeRectangles.erase(freeRectangles.begin() + freeNodeIndex) -- TODO

    -- Perform a Rectangle Merge step if desired.
    if merge then
        MergeFreeList()
    end

    -- Remember the new used rectangle.
    usedRectangles.push_back(newRect)

    -- Check that we're really producing correct packings here.
    debug_assert(disjointRects.Add(newRect) == true)

    return newRect
end

-- Computes the ratio of used surface area to the total bin area.
function GuillotineBinPack:Occupancy()
    --[[
    TODO/Improve: todo The occupancy rate could be cached/tracked
    incrementally instead of looping through the list of packed rectangles
    here.
    ]]--
    local usedSurfaceArea = 0
    for i = 1, usedRectangles:size() do
        usedSurfaceArea = (usedSurfaceArea +
                           usedRectangles[i].width * usedRectangles[i].height)
    end

    return usedSurfaceArea / (binWidth * binHeight)
end

-- Returns the heuristic score value for placing a rectangle of size width*height into freeRect. Does not try to rotate.
function GuillotineBinPack::ScoreByHeuristic(width, height, freeRect, FreeRectChoiceHeuristic rectChoice)
{
    switch(rectChoice)
    {
    case RectBestAreaFit: return ScoreBestAreaFit(width, height, freeRect);
    case RectBestShortSideFit: return ScoreBestShortSideFit(width, height, freeRect);
    case RectBestLongSideFit: return ScoreBestLongSideFit(width, height, freeRect);
    case RectWorstAreaFit: return ScoreWorstAreaFit(width, height, freeRect);
    case RectWorstShortSideFit: return ScoreWorstShortSideFit(width, height, freeRect);
    case RectWorstLongSideFit: return ScoreWorstLongSideFit(width, height, freeRect);
    default: assert(false); return std::numeric_limits<int>::max();
    }
}
