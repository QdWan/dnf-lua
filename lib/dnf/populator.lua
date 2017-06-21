local shuffle_range = require("util.shuffle_range")
local decide = require("decide")
local PriorityQueue = require("collections.priority_queue").PQHT
local templates = require("templates")
local tile_groups = templates.constants.groups
local WATER_GROUP  = tile_groups.WATER_GROUP
local MOUNTAIN_GROUP  = tile_groups.MOUNTAIN_GROUP

local floor = math.floor
local HUGE = math.huge
local min = math.min
local max = math.max
local abs = math.abs

--[[
TEST
]]--
local templates = require("templates")
local TileConstants = templates.constants.EnumTileEntity
local CITY = TileConstants.city
--[[
TEST
]]--

local MODULE = {}

local function nearest_element(graph, i, list, default)
    --[[Return the shortest distance between i and `list` elements.

    Each element (if any) on `list` is verified and the minimum distance between position `i` and those is returned.

    Parameters:
        graph(map_gen.base.Graph): the graph on which the points exist
        i(number): the index of the node on the `graph`
        list(table): array of elements (numbers), each one representing a
            valid index to a `graph` node
        default: the value to be returned if there are no other elements to
            compare to.

    Returns:
        (number): the distance; or
        (default): the passed default return value, if no other city exists
            (#list == 0), or nil if no default value is passed.
    ]]--

    if #list == 0 then return default end
    local w = graph.w
    local x1 = (((i - 1) % w) + 1)
    local y1 = floor((i - 1) / w) + 1

    local distance = HUGE

    for _, other_I in ipairs(list) do
        local x2 = (((other_I - 1) % w) + 1)
        local y2 = floor((other_i - 1) / w) + 1
        local dx = x2 - x1
        local dy = y2 - y1
        local v = ((dx*dx) + (dy*dy))^(0.5)
        -- shortest possible distance is 1, no need to keep going in that case
        if v == 1 then return v end
        distance = v < distance and v or distance
    end
    return distance
end

function MODULE.populate_surface(graph, header)
    local graph = graph
    local nodes = graph.tiles
    local cities = {}
    local citiness = PriorityQueue({mode = "highest_table"})
    local city_limit = floor(((graph.w * graph.h)^(1/2))/5)
    local max_distance = city_limit

    -- #######################################################
    local function get_citiness_factor(i, previous_info)
        local extra = {}

        -- the closer we get to filling the table, the more important it
        -- becomes to avoid clusters
        local len = #cities
        local dist_k = 4
        local fullness = min(max(min(len * len, len * 3), 5) /
                             city_limit, dist_k)
        local distance_weight = dist_k * 0.5 + dist_k * fullness
        local nearest_city = nearest_element(graph, i, cities)
        extra.nearest_city = nearest_city
        nearest_city = nearest_city or max_distance
        local distance_ratio = (max(nearest_city / max_distance,
                                    max_distance) / max_distance)
        local distance_contrib = decide.HGLB(distance_ratio)

        if not previous_info then
            local node = nodes[i]
            local meta = node.meta

            local height_contrib = decide.LGHB(meta.height_value)
            local height_weight = 0.2

            local heat_contrib = decide.MGEB(meta.heat_value)
            local heat_weight = 0.2

            local rainfall_contrib = decide.HGLB(meta.rainfall_value)
            local rainfall_weight = 0.2

            local water_r1_contrib = decide.MGEB(meta.water_ratio_r1)
            local water_r1_weight = 0.15

            local water_r2_contrib = decide.MGEB(meta.water_ratio_r2)
            local water_r2_weight = 0.15

            local water_r4_contrib = decide.MGEB(meta.water_ratio_r4)
            local water_r4_weight = 0.15

            local forest_contrib = decide.MGEB(meta.forest_ratio_r4)
            local forest_weight = 1

            local random_factor = meta.noise_value
            local random_weight = 1

            local info = {
                distance_contrib, distance_weight,
                height_contrib, height_weight,
                heat_contrib, heat_weight,
                rainfall_contrib, rainfall_weight,
                forest_contrib, forest_weight,
                water_r1_contrib, water_r1_weight,
                water_r2_contrib, water_r2_weight,
                water_r4_contrib, water_r4_weight,
                random_factor, random_weight
               }
            return decide.decide(info), info, extra
        else
            if distance_contrib ~= previous_info.distance_contrib then
                previous_info[1] = distance_contrib
                previous_info[2] = distance_weight
            end
            return decide.decide(previous_info), previous_info, extra
        end
    end
    -- #######################################################
    local function update_citiness_queue()
        local citiness = citiness
        local buff = {}
        for i = 1, floor(citiness:size() / 2) do
            buff[#buff + 1] = citiness:pop()
        end
        for _, queue_data in ipairs(buff) do
            local i = queue_data.v
            local info = queue_data.info
            local priority, info, extra = get_citiness_factor(i, info)
             -- when distance is the same the returned value is nil
            priority = priority or queue_data.p
            citiness:put({v=i, p=priority, info=info, extra=extra})
        end
    end
    -- #######################################################

    local t0 = time()
    log:warn("populate_surface(city_limit=".. city_limit .. ") => start...")

    -- INITIALIZE THE QUEUE
    local rnd = shuffle_range(1, graph.w * graph.h)
    for _, i in ipairs(rnd) do
        local node = nodes[i]
        local template = node.template
        if WATER_GROUP[template] or MOUNTAIN_GROUP[template] then
            do end;
        else
            local priority, info, extra = get_citiness_factor(i)
            citiness:put({v=i, p=priority, info=info, extra=extra})
        end
    end

    -- UPDATE THE QUEUE CONSIDERING OTHER CITIES
    while true do
        local queue_data = citiness:pop()
        local i = queue_data.v
        local quality = queue_data.p

        local nearest_city = queue_data.extra.nearest_city
        if not nearest_city or nearest_city > 5 then
            cities[#cities + 1] = i

            log:info(string.format(
                "city n. %d, max_dist(formal) %d, *index* %d, " ..
                    "x %d, y %d, citiness %.3f\n    " ..
                    "distance(contrib %.3f, weight %.3f),  " ..
                    "height(contrib %.3f, weight %.3f),  " ..
                    "heat(contrib %.3f, weight %.3f),  " ..
                    "rainfall(contrib %.3f, weight %.3f),  " ..
                    "forest(contrib %.3f, weight %.3f),  " ..
                    "water_r1(contrib %.3f, weight %.3f),  " ..
                    "water_r2(contrib %.3f, weight %.3f),  " ..
                    "water_r4(contrib %.3f, weight %.3f),  " ..
                    "random(contrib %.3f, weight %.3f),  " ..
                    "nearest_city %d",
                #cities, max_distance, i,
                    (((i - 1) % graph.w) + 1), floor((i - 1) / graph.w) + 1,
                        quality,
                    queue_data.info[1], queue_data.info[2],
                    queue_data.info[3], queue_data.info[4],
                    queue_data.info[5], queue_data.info[6],
                    queue_data.info[7], queue_data.info[8],
                    queue_data.info[9], queue_data.info[10],
                    queue_data.info[11], queue_data.info[12],
                    queue_data.info[13], queue_data.info[14],
                    queue_data.info[15], queue_data.info[16],
                    queue_data.info[17], queue_data.info[18],
                    nearest_city or -1

            ) .. "\n    <<" .. table.concat(queue_data.info, "; ") .. ">>")
            nodes[i].template = CITY
            nodes[i].tile_pos = 7
            update_citiness_queue()
        else
            log:info("queue update (no city round")
        end
        if #cities == city_limit or citiness:size() == 0 then break end
    end
    log:info("rnd table: " .. table.concat(rnd, ", "))
    log:warn("populate_surface => done!", time() - t0)

    --[[
    log:warn("populate_surface => MANUAL HALT")
    love.event.quit()
    ]]--
end

return MODULE
