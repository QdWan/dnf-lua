local PackingAlgorithm = class("PackingAlgorithm")

function PackingAlgorithm:initialize(kwargs)
    --[[PackingAlgorithm base class.

    Args:
        t (table): table containing the below keyword arguments.
        t.width (number): Packing surface width
        t.height (number): Packing surface height
        t.rot (boolean): Rectangle rotation enabled or disabled
    ]]--
    self.width = t.width
    self.height = t.height
    self.rot = t.rot or false
    self.rectangles = {}
    self._surface = Rect(0, 0, t.width, t.height)
    self:reset()
end

function PackingAlgorithm:_fits_surface(width, height)
    --[[Test surface is big enough to place a rectangle

    Arguments:
        width (int, float): Rectangle width
        height (int, float): Rectangle height

    Returns:
        boolean: True if it could be placed, False otherwise
    ]]--
        assert(width > 0 and height > 0)
        if self.rot and (width > self.width or height > self.height) then
            width, height = height, width
        end

        if width > self.width or height > self.height then
            return false
        else
            return true
        end
end

function PackingAlgorithm:reset()
    self.rectangles = {}  -- List of placed Rectangles.
end

return PackingAlgorithm
