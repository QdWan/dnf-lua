--[[ Priority queue implemented as a binary heap.

    heap.lua: Written by Cosmin Apreutesei. Public Domain.
        https://github.com/luapower/heap

    * Modified by Lucas Siqueira
]]--

local assert, error, floor = assert, error, math.floor

local MODULE = {}

local cmp = {
    highest =       function(a, b) return a > b end,
    highest_table = function(a, b) return a.p > b.p end,
    lowest =        function(a, b) return a < b end,
    lowest_table =  function(a, b) return a.p < b.p end
}

local function PriorityQueue(h)
    h = h or {}
    local t, n = h, #h

    h.cmp = h.cmp or cmp[h.mode or "highest"]

    local function add(v)
        n=n+1
        t[n]=v
    end

    local function rem()
        t[n]=nil
        n=n-1
    end

    local function moveup(child)
        local parent = floor(child / 2)
        while child > 1 and h.cmp(t[child], t[parent]) do
            t[child], t[parent] = t[parent], t[child] -- swap
            child = parent
            parent = floor(child / 2)
        end
        return child
    end

    local function movedown(parent)
        local last = n
        local child = parent * 2
        while child <= last do
            if child + 1 <= last and h.cmp(t[child + 1], t[child]) then
                child = child + 1 --sibling is smaller
            end
            if not h.cmp(t[child], t[parent]) then break end
            t[child], t[parent] = t[parent], t[child] -- swap
            parent = child
            child = parent * 2
        end
        return parent
    end

    local function push(val)
        add(val)
        return moveup(n)
    end

    local function pop(i)
        t[i], t[n] = t[n], t[i] -- swap
        rem()
        movedown(i)
    end

    local function rebalance(i)
        if moveup(i) == i then
            movedown(i)
        end
    end

    local function get(i)
        assert(i >= 1 and i <= n, 'invalid index')
        return t[i]
    end

    function h:push(v)
        assert(v ~= nil, 'invalid value')
        push(v)
    end
    h.put = h.push

    function h:pop(i)
        assert(n > 0, 'buffer underflow')
        local v = get(i or 1)
        pop(i or 1)
        return v
    end

    function h:pop_safe(i)
        if n <1 then
            return nil
        else
            local v = get(i or 1)
            pop(i or 1)
            return v
        end
    end

    function h:peek(i)
        return get(i or 1)
    end

    function h:replace(i, v)
        assert(i >= 1 and i <= n, 'invalid index')
        t[i] = v
        rebalance(i)
    end

    function h:size()
        return n
    end

    function h:empty()
        return n == 0
    end

    return h
end
MODULE.PriorityQueue = PriorityQueue

local function highest_table(h)
    h = h or {}
    local t, n = h, #h

    local function add(v)
        n=n+1
        t[n]=v
    end

    local function rem()
        t[n]=nil
        n=n-1
    end

    local function moveup(child)
        local parent = floor(child / 2)
        while child > 1 and (t[child].p > t[parent].p) do
            t[child], t[parent] = t[parent], t[child] -- swap
            child = parent
            parent = floor(child / 2)
        end
        return child
    end

    local function movedown(parent)
        local last = n
        local child = parent * 2
        while child <= last do
            if child + 1 <= last and (t[child + 1].p > t[child].p) then
                child = child + 1 --sibling is smaller
            end
            if not (t[child].p > t[parent].p) then break end
            t[child], t[parent] = t[parent], t[child] -- swap
            parent = child
            child = parent * 2
        end
        return parent
    end

    local function push(val)
        add(val)
        return moveup(n)
    end

    local function pop(i)
        t[i], t[n] = t[n], t[i] -- swap
        rem()
        movedown(i)
    end

    local function rebalance(i)
        if moveup(i) == i then
            movedown(i)
        end
    end

    local function get(i)
        assert(i >= 1 and i <= n, 'invalid index')
        return t[i]
    end

    function h:push(v)
        assert(v ~= nil, 'invalid value')
        push(v)
    end
    h.put = h.push

    function h:pop(i)
        assert(n > 0, 'buffer underflow')
        local v = get(i or 1)
        pop(i or 1)
        return v
    end

    function h:pop_safe(i)
        if n <1 then
            return nil
        else
            local v = get(i or 1)
            pop(i or 1)
            return v
        end
    end

    function h:peek(i)
        return get(i or 1)
    end

    function h:replace(i, v)
        assert(i >= 1 and i <= n, 'invalid index')
        t[i] = v
        rebalance(i)
    end

    function h:size()
        return n
    end

    function h:empty()
        return n == 0
    end

    return h
end
MODULE.PQHT = highest_table

return MODULE
