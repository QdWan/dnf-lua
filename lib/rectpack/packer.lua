local collections = require("lib.collections")

local maxrects = require("lib.rectpack.maxrects")
local MaxRectsBssf = maxrects.MaxRectsBssf

-- # Sorting algos for rectangle lists

local function sorted_copy(old, fn)
    local new = {}
    for _, v in ipairs(old) do
        new[#new + 1] = v
    end
    if fn ~= nil then
        table.sort(new, fn)
    end
    return new
end

local function SORT_AREA(t)
    -- Sort by area
    return sorted_copy(
        t,
        function(a, b)
            return (a[1] * a[2]) > (b[1] * b[2])
        end)
end

local function SORT_PERI(t)
    -- Sort by perimeter
    return sorted_copy(
        t,
        function(a, b)
            return (a[1] + a[2]) > (b[1] + b[2])
        end
    )
end

local function SORT_DIFF(t)
    -- Sort by Diff
    return sorted_copy(
        t,
        function(a, b)
            return (math.abs(a[1] - a[2])) > (math.abs(b[1] - b[2]))
        end
    )
end

local function SORT_SSIDE(t)
    -- Sort by short side
    return sorted_copy(
        t,
        function(a, b)
            local min_a = math.min(a[1], a[2])
            local min_b = math.min(b[1], b[2])
            if min_a == min_b then
                local max_a = math.max(a[1], a[2])
                local max_b = math.max(b[1], b[2])
                return max_a > max_b
            else
                return min_a > min_b
            end
        end
    )
end

local function SORT_LSIDE(t)
    -- Sort by long side
    return sorted_copy(
        t,
        function(a, b)
            local max_a = math.max(a[1], a[2])
            local max_b = math.max(b[1], b[2])
            if max_a == max_b then
                local min_a = math.min(a[1], a[2])
                local min_b = math.min(b[1], b[2])
                return min_a > min_b
            else
                return max_a > max_b
            end
        end
    )
end

local function SORT_RATIO(t)
    -- Sort by side ratio
    return sorted_copy(
        t,
        function(a, b)
            return (a[1] / a[2]) > (b[1] / b[2])
        end
    )
end

local function SORT_NONE(t)
    -- Unsorted
    return sorted_copy(t)
end


local BinFactory = class("BinFactory")

function BinFactory:initialize(t)
    --[[]
    Args:
        t (table): table containing the below keyword arguments.
        ...
    ]]--

    self._width = t.width
    self._height = t.height
    self._count = t.count

    self._pack_algo = t.pack_algo
    self.kwargs = t
    -- self._ref_bin = nil  -- Reference bin used to calculate fitness
end

function BinFactory:_create_bin()
    return self._pack_algo(self._width, self._height, self._algo_kwargs)
end
--[[

    def is_empty(self):
        return self._count<1

    def fitness(self, width, height):
        if not self._ref_bin:
            self._ref_bin = self._create_bin()

        return self._ref_bin.fitness(width, height)

    def fits_inside(self, width, height):
        # Determine if rectangle widthxheight will fit into empty bin
        if not self._ref_bin:
            self._ref_bin = self._create_bin()

        return self._ref_bin._fits_surface(width, height)

    def new_bin(self):
        if self._count > 0:
            self._count -= 1
            return self._create_bin()
        else:
            return None

    def __eq__(self, other):
        return self._width*self._height == other._width*other._height

    def __lt__(self, other):
        return self._width*self._height < other._width*other._height

    def __str__(self):
        return "Bin: {} {} {}".format(self._width, self._height, self._count)



class PackerBNFMixin(object):
    """
    BNF (Bin Next Fit): Only one open bin at a time.  If the rectangle
    doesn't fit, close the current bin and go to the next.
    """

    def add_rect(self, width, height, rid=None):
        while True:
            # if there are no open bins, try to open a new one
            if len(self._open_bins)==0:
                # can we find an unopened bin that will hold this rect?
                new_bin = self._new_open_bin(width, height, rid=rid)
                if new_bin is None:
                    return None

            # we have at least one open bin, so check if it can hold this rect
            rect = self._open_bins[0].add_rect(width, height, rid=rid)
            if rect is not None:
                return rect

            # since the rect doesn't fit, close this bin and try again
            closed_bin = self._open_bins.popleft()
            self._closed_bins.append(closed_bin)


class PackerBFFMixin(object):
    """
    BFF (Bin First Fit): Pack rectangle in first bin it fits
    """

    def add_rect(self, width, height, rid=None):
        # see if this rect will fit in any of the open bins
        for b in self._open_bins:
            rect = b.add_rect(width, height, rid=rid)
            if rect is not None:
                return rect

        while True:
            # can we find an unopened bin that will hold this rect?
            new_bin = self._new_open_bin(width, height, rid=rid)
            if new_bin is None:
                return None

            # _new_open_bin may return a bin that's too small,
            # so we have to double-check
            rect = new_bin.add_rect(width, height, rid=rid)
            if rect is not None:
                return rect


]]--


local PackerBBFMixin = class("PackerBBFMixin")
--[[BBF (Bin Best Fit): Pack rectangle in bin that gives best fitness
]]--

function PackerBBFMixin:first_item()
    error("NotImplementedError")
    -- only create this getter once
    -- first_item = operator.itemgetter(0)
end

function PackerBBFMixin:add_rect(width, height, rid)
    -- Try packing into open bins
    local v = math.huge
    local best_bin = true
    for _, b in ipairs(self._open_bins) do
        local fit = b:fitness(width, height)
        if fit < v then
            best_bin = b
            v = fit
        end
    end

    if best_bin.add_rect(width, height, rid) then
        return true
    end

    -- Try packing into one of the empty bins
    while true do
        -- can we find an unopened bin that will hold this rect?
        new_bin = self:_new_open_bin(width, height, rid)
        if new_bin == nil then
            return false
        end

        -- _new_open_bin may return a bin that's too small,
        -- so we have to double-check
        if new_bin:add_rect(width, height, rid) then
            return true
        end
    end
end


local PackerOnline = class("PackerOnline")

function PackerOnline:initialize(pack_algo, rotation)
    --[[Rectangles are packed as soon are they are added

    Arguments:
        pack_algo (PackingAlgorithm): What packing algo to use
        rotation (bool): Enable/Disable rectangle rotation
    ]]--
    pack_algo = pack_algo or MaxRectsBssf
    rotation = rotation or true
    self._rotation = rotation
    self._pack_algo = pack_algo
    self:reset()
end
    --[[
    def __iter__(self):
        return itertools.chain(self._closed_bins, self._open_bins)

    def __len__(self):
        return len(self._closed_bins)+len(self._open_bins)

    def __getitem__(self, key):
        """
        Return bin in selected position. (excluding empty bins)
        """
        if not isinstance(key, int):
            raise TypeError("Indices must be integers")

        size = len(self)  # avoid recalulations

        if key < 0:
            key += size

        if not 0 <= key < size:
            raise IndexError("Index out of range")

        if key < len(self._closed_bins):
            return self._closed_bins[key]
        else:
            return self._open_bins[key-len(self._closed_bins)]
    ]]--

function PackerOnline:_new_open_bin(width, height, rid)
    --[[Extract the next empty bin and append it to open bins

    Returns:
        PackingAlgorithm: Initialized empty packing bin.
        None: No bin big enough for the rectangle was found
    ]]--
    factories_to_delete = {}
    new_bin = None

    for key, binfac, i in self._empty_bins:items() do
        -- Only return the new bin if the rect fits.
        -- (If width or height is None, caller doesn't know the size.)
        if binfac:fits_inside(width, height) then
            -- Create bin and add to open_bins
            new_bin = binfac:new_bin()
            if new_bin ~= nil then
                self._open_bins:push_right(new_bin)

                -- If the factory was depleted mark for deletion
                if binfac:is_empty() then
                    factories_to_delete[key] = true
                end

            break
    end

    -- Delete marked factories
    for f, _ in pairs(factories_to_delete) do
        self._empty_bins:remove(f)
    end

    return new_bin
end

function PackerOnline:add_bin(t)
    local width = t.width
    local height = t.height
    t.count = t.count or 1

    -- accept the same parameters as PackingAlgorithm objects
    t.rot = self._rotation
    bin_factory = BinFactory(width, height, count, self._pack_algo, **kwargs)
    self._empty_bins:add(bin_factory, bin_factory)

def rect_list(self):
    rectangles = []
    bin_count = 0

    for abin in self:
        for rect in abin:
            rectangles.append((bin_count, rect.x, rect.y, rect.width, rect.height, rect.rid))
        bin_count += 1

    return rectangles

def bin_list(self):
    """
    Return a list of the dimmensions of the bins in use, that is closed
    or open containing at least one rectangle
    """
    return [(b.width, b.height) for b in self]

def validate_packing(self):
    for b in self:
        b.validate_packing()

def reset(self):
    -- Bins fully packed and closed.
    self._closed_bins = collections.Deque()

    -- Bins ready to pack rectangles
    self._open_bins = collections.Deque()

    -- User provided bins not in current use
    self._empty_bins = collections.OrderedDict()
end

class Packer(PackerOnline):
    """
    Rectangles aren't packed untils pack() is called
    """

    def __init__(self, pack_algo=MaxRectsBssf, sort_algo=SORT_NONE,
            rotation=True):
        """
        """
        super(Packer, self).__init__(pack_algo=pack_algo, rotation=rotation)

        self._sort_algo = sort_algo

        # User provided bins and Rectangles
        self._avail_bins = collections.deque()
        self._avail_rect = collections.deque()

        # Aux vars used during packing
        self._sorted_rect = []

    def add_bin(self, width, height, count=1, **kwargs):
        self._avail_bins.append((width, height, count, kwargs))

    def add_rect(self, width, height, rid=None):
        self._avail_rect.append((width, height, rid))

    def _is_everything_ready(self):
        return self._avail_rect and self._avail_bins

    def pack(self):

        self.reset()

        if not self._is_everything_ready():
            # maybe we should throw an error here?
            return

        # Add available bins to packer
        for b in self._avail_bins:
            width, height, count, extra_kwargs = b
            super(Packer, self).add_bin(width, height, count, **extra_kwargs)

        # If enabled sort rectangles
        self._sorted_rect = self._sort_algo(self._avail_rect)

        # Start packing
        for r in self._sorted_rect:
            super(Packer, self).add_rect(*r)


class PackerBBF(Packer, PackerBBFMixin):
    """
    BBF (Bin Best Fit): Pack rectangle in bin that gives best fitness
    """
    pass
--[[

class PackerBNF(Packer, PackerBNFMixin):
    """
    BNF (Bin Next Fit): Only one open bin, if rectangle doesn't fit
    go to next bin and close current one.
    """
    pass

class PackerBFF(Packer, PackerBFFMixin):
    """
    BFF (Bin First Fit): Pack rectangle in first bin it fits
    """
    pass

class PackerOnlineBNF(PackerOnline, PackerBNFMixin):
    """
    BNF Bin Next Fit Online variant
    """
    pass

class PackerOnlineBFF(PackerOnline, PackerBFFMixin):
    """
    BFF Bin First Fit Online variant
    """
    pass

class PackerOnlineBBF(PackerOnline, PackerBBFMixin):
    """
    BBF Bin Best Fit Online variant
    """
    pass


class PackerGlobal(Packer, PackerBNFMixin):
    """
    GLOBAL: For each bin pack the rectangle with the best fitness.
    """
    first_item = operator.itemgetter(0)

    def __init__(self, pack_algo=MaxRectsBssf, rotation=True):
        """
        """
        super(PackerGlobal, self).__init__(pack_algo=pack_algo,
            sort_algo=SORT_NONE, rotation=rotation)

    def _find_best_fit(self, pbin):
        """
        Return best fitness rectangle from rectangles packing _sorted_rect list

        Arguments:
            pbin (PackingAlgorithm): Packing bin

        Returns:
            key of the rectangle with best fitness
        """
        fit = ((pbin.fitness(r[0], r[1]), k) for k, r in self._sorted_rect.items())
        fit = (f for f in fit if f[0] is not None)
        try:
            _, rect = min(fit, key=self.first_item)
            return rect
        except ValueError:
            return None


    def _new_open_bin(self, remaining_rect):
        """
        Extract the next bin where at least one of the rectangles in
        rem

        Arguments:
            remaining_rect (dict): rectangles not placed yet

        Returns:
            PackingAlgorithm: Initialized empty packing bin.
            None: No bin big enough for the rectangle was found
        """
        factories_to_delete = set() #
        new_bin = None

        for key, binfac in self._empty_bins.items():

            # Only return the new bin if at least one of the remaining
            # rectangles fit inside.
            a_rectangle_fits = False
            for _, rect in remaining_rect.items():
                if binfac.fits_inside(rect[0], rect[1]):
                    a_rectangle_fits = True
                    break

            if not a_rectangle_fits:
                factories_to_delete.add(key)
                continue

            # Create bin and add to open_bins
            new_bin = binfac.new_bin()
            if new_bin is None:
                continue
            self._open_bins.append(new_bin)

            # If the factory was depleted mark for deletion
            if binfac.is_empty():
                factories_to_delete.add(key)

            break

        # Delete marked factories
        for f in factories_to_delete:
            del self._empty_bins[f]

        return new_bin

    def pack(self):

        self.reset()

        if not self._is_everything_ready():
            return

        # Add available bins to packer
        for b in self._avail_bins:
            width, height, count, extra_kwargs = b
            super(Packer, self).add_bin(width, height, count, **extra_kwargs)

        # Store rectangles into dict for fast deletion
        self._sorted_rect = collections.OrderedDict(
                enumerate(self._sort_algo(self._avail_rect)))

        # For each bin pack the rectangles with lowest fitness until it is filled or
        # the rectangles exhausted, then open the next bin where at least one rectangle
        # will fit and repeat the process until there aren't more rectangles or bins
        # available.
        while len(self._sorted_rect) > 0:

            # Find one bin where at least one of the remaining rectangles fit
            pbin = self._new_open_bin(self._sorted_rect)
            if pbin is None:
                break

            # Pack as many rectangles as possible into the open bin
            while True:

                # Find 'fittest' rectangle
                best_rect_key = self._find_best_fit(pbin)
                if best_rect_key is None:
                    closed_bin = self._open_bins.popleft()
                    self._closed_bins.append(closed_bin)
                    break # None of the remaining rectangles can be packed in this bin

                best_rect = self._sorted_rect[best_rect_key]
                del self._sorted_rect[best_rect_key]

                PackerBNFMixin.add_rect(self, *best_rect)

]]--




# Packer factory
class Enum(tuple):
    __getattr__ = tuple.index

PackingMode = {Offline = Offline}  -- Online = Online
PackingBin = {BBF = BBF}  -- BNF = BNF, BFF = BFF, Global = Global


def newPacker(mode=PackingMode.Offline,
         bin_algo=PackingBin.BBF,
        pack_algo=MaxRectsBssf,
        sort_algo=SORT_AREA,
        rotation=True):
    --[[

    Packer factory helper function

    Arguments:
        mode (PackingMode): Packing mode
            Online: Rectangles are packed as soon are they are added
            Offline: Rectangles aren't packed untils pack() is called
        bin_algo (PackingBin): Bin selection heuristic
        pack_algo (PackingAlgorithm): Algorithm used
        rotation (boolean): Enable or disable rectangle rotation.

    Returns:
        Packer: Initialized packer instance.
    ]]--
    local packer_class, mode, bin_algo, pack_algo, rotation, sort_algo

    mode = type(t.mode) == "string" and PackingMode[mode] or Offline
    bin_algo = type(t.bin_algo) == "string" and PackingBin[bin_algo] or BBF
    pack_algo = pack_algo or MaxRectsBssf
    sort_algo = ((type(t.sort_algo) == "string" and SortAlgo[sort_algo]) or
                 SORT_AREA)
    rotation = rotation or false

    -- Online Mode
    if mode == PackingMode.Online then
        error("NotImplementedError")
        --[[
        sort_algo=None
        if bin_algo == PackingBin.BNF:
            packer_class = PackerOnlineBNF
        elif bin_algo == PackingBin.BFF:
            packer_class = PackerOnlineBFF
        elif bin_algo == PackingBin.BBF:
            packer_class = PackerOnlineBBF
        else:
            raise AttributeError("Unsupported bin selection heuristic")
        ]]--

    -- Offline Mode
    elseif mode == PackingMode.Offline then
        if bin_algo == PackingBin.BBF:
            packer_class = PackerBBF
        --[[

        elseif bin_algo == PackingBin.BNF:
            packer_class = PackerBNF
        elif bin_algo == PackingBin.BFF:
            packer_class = PackerBFF
        elif bin_algo == PackingBin.Global:
            packer_class = PackerGlobal
            sort_algo=None
        ]]--
        else:
            error("Unsupported bin selection heuristic")

    else:
        error("Unknown packing mode.")

    return packer_class({
        pack_algo=pack_algo,
        sort_algo=sort_algo,
        rotation=rotation})
