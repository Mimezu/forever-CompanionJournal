local _, A = ...
-- The Road's model of a day (docs/HERO-PATH.md): the road (Road.lua), the journal's
-- lines placed on it by their time, the stays (for the Story view's ink washes), the
-- stretches walked with a companion, and the zones in the order you saw them. No
-- frames here; RoadMap.lua draws it. A day from before the recorder still has a model:
-- its zones and their times, so the Story view and the Atlas can show it.

local Road = A.Road
local M = {}
A.RoadModel = M

local function Public(value) return not issecretvalue or not issecretvalue(value) end
local function Ask(fn, ...)
    if type(fn) ~= "function" then return nil end
    local ok, a, b, c, d = pcall(fn, ...)
    if not ok or not Public(a) then return nil end
    return a, b, c, d
end

-- Geometry -----------------------------------------------------------------------------
-- Zone names to map ids (the journal keeps names), from the world's map tree, once.
local zoneIds
function M.ZoneId(name)
    if not name then return nil end
    if not zoneIds then
        zoneIds = {}
        local children = C_Map and Ask(C_Map.GetMapChildrenInfo, 947, nil, true)
        for _, info in ipairs(type(children) == "table" and children or {}) do
            if info.name and info.mapID and (info.mapType == 3 or info.mapType == 2) and not zoneIds[info.name] then
                zoneIds[info.name] = info.mapID
            end
        end
    end
    return zoneIds[name]
end
function M.MapName(map)
    local info = map and C_Map and Ask(C_Map.GetMapInfo, map)
    return type(info) == "table" and info.name or nil
end
function M.MapType(map)
    local info = map and C_Map and Ask(C_Map.GetMapInfo, map)
    return type(info) == "table" and info.mapType or nil
end
-- The continent a zone lies on (Kalimdor, the Eastern Kingdoms).
function M.Continent(map)
    for _ = 1, 8 do
        local info = map and C_Map and Ask(C_Map.GetMapInfo, map)
        if type(info) ~= "table" then return nil end
        if info.mapType == 2 then return map end
        map = info.parentMapID
    end
    return nil
end
-- A zone's places on another map (its continent, the world): a straight scale and shift
-- found from two corners through world positions, kept once a pair.
local transforms = {}
function M.Transform(from, to)
    if from == to then return function(x, y) return x, y end end
    local key = from .. ">" .. to
    if transforms[key] ~= nil then return transforms[key] or nil end
    local function Corner(x, y)
        local cont, world = Ask(C_Map.GetWorldPosFromMapPos, from, CreateVector2D and CreateVector2D(x, y))
        if not cont or not world then return nil end
        local _, pos = Ask(C_Map.GetMapPosFromWorldPos, cont, world, to)
        if not pos then return nil end
        return pos.x, pos.y
    end
    local ax, ay = Corner(0, 0)
    local bx, by = Corner(1, 1)
    local fn = false
    if ax and bx and ax ~= bx and ay ~= by then
        fn = function(x, y) return ax + (bx - ax) * x, ay + (by - ay) * y end
    elseif C_Map and C_Map.GetMapRectOnMap then
        local left, right, top, bottom = Ask(C_Map.GetMapRectOnMap, from, to)
        if left and right and top and bottom and right ~= left then
            fn = function(x, y) return left + (right - left) * x, top + (bottom - top) * y end
        end
    end
    transforms[key] = fn
    return fn or nil
end
-- Yards across and down a zone (for stay radii), from the game or from two corners.
local sizes = {}
function M.Yards(map)
    if sizes[map] then return sizes[map][1], sizes[map][2] end
    local w, h = C_Map and Ask(C_Map.GetMapWorldSize, map)
    if not (w and h and w > 0) then
        local _, a = Ask(C_Map.GetWorldPosFromMapPos, map, CreateVector2D and CreateVector2D(0, 0))
        local _, b = Ask(C_Map.GetWorldPosFromMapPos, map, CreateVector2D and CreateVector2D(1, 1))
        if a and b then w, h = math.abs(b.x - a.x), math.abs(b.y - a.y) end
    end
    if not (w and h and w > 300 and w < 30000) then w, h = 4000, 2700 end
    sizes[map] = {w, h}
    return w, h
end

-- Stays: where the road lingered. A run of points within 70 yards of their middle for
-- two minutes or more; a single long pause (a campfire, a talk) is one too.
local STAY_RADIUS, STAY_TIME = 70, 120
function M.Stays(piece)
    local out, pts = {}, piece.points
    local w, h = M.Yards(piece.map)
    local function Yd(a, b) return math.sqrt(((a.x - b.x) * w) ^ 2 + ((a.y - b.y) * h) ^ 2) end
    local i = 1
    while i <= #pts do
        local sx, sy, n, j = pts[i].x, pts[i].y, 1, i
        while j < #pts do
            local mid = {x = sx / n, y = sy / n}
            if Yd(pts[j + 1], mid) > STAY_RADIUS then break end
            j = j + 1; sx, sy, n = sx + pts[j].x, sy + pts[j].y, n + 1
        end
        -- (the time spent: from the run's first point to the step after its last)
        local stop = pts[j + 1] and pts[j + 1].t or pts[j].t
        local spent = stop - pts[i].t
        if spent >= STAY_TIME then
            -- (its middle weighted by the time at each point: the long pause, not the walk to it)
            local wx, wy, weight = 0, 0, 0
            for k = i, j do
                local dt = math.max(1, (pts[k + 1] and pts[k + 1].t or pts[k].t + 2) - pts[k].t)
                wx, wy, weight = wx + pts[k].x * dt, wy + pts[k].y * dt, weight + dt
            end
            local mid = {x = wx / weight, y = wy / weight}
            local spread = 0
            for k = i, j do spread = math.max(spread, Yd(pts[k], mid)) end
            out[#out + 1] = {map = piece.map, x = mid.x, y = mid.y, t = pts[i].t, e = stop, secs = spent, yards = math.max(20, spread)}
            i = j + 1
        else
            i = i + 1
        end
    end
    return out
end

-- Where you were at a time: on the road when it was recorded then (between two points),
-- else nil.
function M.PlaceAt(model, t)
    if not t then return nil end
    local best, bestGap
    for _, piece in ipairs(model.pieces) do
        local pts = piece.points
        if pts and #pts > 0 and t >= pts[1].t - 90 and t <= pts[#pts].t + 90 then
            for k = 1, #pts do
                local gap = math.abs(pts[k].t - t)
                if not bestGap or gap < bestGap then best, bestGap = {map = piece.map, x = pts[k].x, y = pts[k].y}, gap end
                if pts[k].t > t then break end
            end
        elseif piece.kind == "flight" and t >= piece.from.t and t <= piece.to.t then
            return {map = piece.from.map, x = piece.from.x, y = piece.from.y, air = true}
        end
    end
    return best
end

-- The journal lines a map shows, and how (the book's few words for the hover).
local MARKS = {
    death = function(e) return "death", "Fell" .. (e.d and (" to " .. e.d) or "") end,
    mylevel = function(e) return "level", "Level " .. tostring(e.d) end,
    campfire = function() return "campfire", "A campfire" end,
    sleep = function(e) return "inn", "Slept" .. (e.d and (" at " .. e.d) or "") end,
    rest = function(e) return "inn", "Rested" .. (e.d and (" at " .. e.d) or "") end,
    dungeon = function(e) return "dungeon", e.d or "A dungeon" end,
    hearth = function(e) return "hearth", "Hearthstone" .. (e.d and (" to " .. e.d) or "") end,
    voyage = function(e) return "voyage", "By " .. (e.d or "ship") .. (e.to and (" to " .. e.to) or "") end,
    first = function(e) return "first", "A first" end,
    rez = function(e) return "rez", "Raised" .. (e.by and (" by " .. e.by) or "") end,
}
M.MARKS = MARKS

-- The day's model for a person's book (yours, or a companion's: then only the road walked
-- with them). journal: the entries of that book; day: "YYYY-MM-DD"; character: whose road.
function M.Build(journal, day, character, companionKey)
    local pieces = Road and Road.Day(character, day) or {}
    local model = {day = day, pieces = {}, marks = {}, stays = {}, together = {}, zones = {}, plays = {}}
    local DayOf = Road and Road.DayOf or function() return day end
    -- (a companion's book: their outings with you are the time that counts)
    local windows
    for _, e in ipairs(journal or {}) do
        if e.t and DayOf(e.t) == day then
            if e.k == "with" and e.d then
                model.together[#model.together + 1] = {t = e.t, e = e.e or e.t, key = e.d, name = e.n}
            elseif (e.k == "group" or e.k == "outing") and companionKey then
                windows = windows or {}
                windows[#windows + 1] = {t = e.t, e = e.e or e.t}
            elseif e.k == "play" then
                model.plays[#model.plays + 1] = {t = e.t, e = e.e or e.t, zone = e.z}
            end
        end
    end
    local function Inside(t)
        if not windows then return true end
        for _, w in ipairs(windows) do if t >= w.t - 60 and t <= w.e + 60 then return true end end
        return false
    end
    for _, piece in ipairs(pieces) do
        if piece.kind == "flight" then
            if Inside(piece.from.t) then model.pieces[#model.pieces + 1] = piece end
        else
            local kept = {}
            for _, p in ipairs(piece.points) do if Inside(p.t) then kept[#kept + 1] = p end end
            if #kept > 1 then model.pieces[#model.pieces + 1] = {kind = piece.kind, map = piece.map, points = kept} end
        end
    end
    -- Times: the day's first and last moment.
    for _, piece in ipairs(model.pieces) do
        local a = piece.points and piece.points[1].t or piece.from.t
        local b = piece.points and piece.points[#piece.points].t or piece.to.t
        model.t0 = math.min(model.t0 or a, a); model.t1 = math.max(model.t1 or b, b)
    end
    for _, play in ipairs(model.plays) do
        model.t0 = math.min(model.t0 or play.t, play.t); model.t1 = math.max(model.t1 or play.e, play.e)
    end
    -- Zones in the order you saw them: the road's maps, then zones known only by name.
    local seen = {}
    local function Zone(map, t, name)
        if not map or seen[map] then return end
        seen[map] = true
        model.zones[#model.zones + 1] = {map = map, t = t, name = name or M.MapName(map)}
    end
    local order = {}
    for _, piece in ipairs(model.pieces) do
        if piece.points then order[#order + 1] = {t = piece.points[1].t, map = piece.map} end
    end
    for _, play in ipairs(model.plays) do order[#order + 1] = {t = play.t, map = M.ZoneId(play.zone), name = play.zone} end
    table.sort(order, function(a, b) return a.t < b.t end)
    for _, o in ipairs(order) do Zone(o.map, o.t, o.name) end
    -- Stays for the Story view.
    for _, piece in ipairs(model.pieces) do
        if piece.kind == "road" then for _, stay in ipairs(M.Stays(piece)) do model.stays[#model.stays + 1] = stay end end
    end
    -- With no road that day: one wash a zone, as long as you stayed (centred: a guess).
    model.recorded = #model.pieces > 0
    if not model.recorded then
        for _, play in ipairs(model.plays) do
            local map = M.ZoneId(play.zone)
            if map then model.stays[#model.stays + 1] = {map = map, x = 0.5, y = 0.5, t = play.t, e = play.e, secs = play.e - play.t, yards = 400, guess = true} end
        end
    end
    -- Marks: the journal's moments, on the road by their time (or the zone's middle).
    for _, e in ipairs(journal or {}) do
        local how = e.t and DayOf(e.t) == day and MARKS[e.k]
        if how and (e.k ~= "death" or e.w == nil or e.w == "you") and Inside(e.t) then
            local kind, text = how(e)
            local at = M.PlaceAt(model, e.t)
            if not at then
                local map = M.ZoneId(e.z)
                if map then at = {map = map, x = 0.5, y = 0.5, guess = true} end
            end
            if at then
                model.marks[#model.marks + 1] = {kind = kind, text = text, t = e.t, map = at.map, x = at.x, y = at.y, guess = at.guess}
            end
        end
    end
    table.sort(model.marks, function(a, b) return a.t < b.t end)
    return model
end

-- Who walked with you at a time (the doubled line), or nil.
function M.WithAt(model, t)
    for _, w in ipairs(model.together) do if t >= w.t and t <= w.e then return w end end
    return nil
end
-- The whole adventure: every day with a road or a zone, oldest first.
function M.Days(journal, character)
    local set, out = {}, {}
    for _, key in ipairs(Road and Road.Days(character) or {}) do set[key] = true end
    local DayOf = Road and Road.DayOf
    for _, e in ipairs(journal or {}) do if e.k == "play" and e.t and DayOf then set[DayOf(e.t)] = true end end
    for key in pairs(set) do out[#out + 1] = key end
    table.sort(out)
    return out
end
