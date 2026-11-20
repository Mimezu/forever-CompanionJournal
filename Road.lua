local _, A = ...
-- The Road: where you went, for the book's maps (docs/HERO-PATH.md). On unless
-- "Record the road" is turned off (Settings > Recording).
--
-- Every 2 s while you move, a point every 12 yards on the zone's own map. Kept per
-- character and per day (the book's day: play past midnight belongs to the evening):
--   db.road[character][day] = { "R:map:t0:<points>", "G:...", "F:...", ... }
--   R  a road: points of 6 characters (x, y on the zone map in 1/4095; seconds since the
--      point before), from t0
--   G  the same, walked as a ghost (back to your body)
--   F  a flight: "F:map1:x1:y1:map2:x2:y2:t0:t1", from the last step to the first after
-- Nothing is guessed: a hidden position, an instance, a loading screen, a teleport or a
-- new day ends the line, and the next one starts where you are. Events need no positions:
-- the maps find each journal line on the road by its time.

local Road = {}
A.Road = Road
A.defaults.roadRecord = true

local SAMPLE = 2        -- seconds between looks
local STEP = 12         -- yards between kept points
local GAP = 90          -- seconds without a look: the line ends
local JUMP_SPEED = 45   -- yards a second faster than any mount: a teleport
local MAX_DT = 4095     -- a point's time step fits two characters

local function Public(value) return not issecretvalue or not issecretvalue(value) end
local function Ask(fn, ...)
    if type(fn) ~= "function" then return nil end
    local ok, a, b, c, d = pcall(fn, ...)
    if not ok or not Public(a) or not Public(b) then return nil end
    return a, b, c, d
end
local function Now() return time and time() or 0 end

-- Packing: 64 symbols, two for a 12-bit number.
local DIGITS = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/"
local VALUE = {}
for i = 1, 64 do VALUE[DIGITS:sub(i, i)] = i - 1 end
local function Two(n)
    n = math.max(0, math.min(4095, math.floor(n + 0.5)))
    local hi, lo = math.floor(n / 64), n % 64
    return DIGITS:sub(hi + 1, hi + 1) .. DIGITS:sub(lo + 1, lo + 1)
end
local function Point(x, y, dt) return Two(x * 4095) .. Two(y * 4095) .. Two(dt) end
Road.Point = Point
local function Read(text, i)
    return VALUE[text:sub(i, i)] * 64 + VALUE[text:sub(i + 1, i + 1)]
end

-- The book's day for a time (play past midnight belongs to the evening before).
local function DayOf(t)
    if A.JournalDayKey and t then return A.JournalDayKey(t) end
    local evening = A.JournalEvening and A.JournalEvening(t) or t
    return date and date("%Y-%m-%d", evening) or "?"
end
Road.DayOf = DayOf

-- Where you are: the zone's map id and your place on it (0..1), and your place in the
-- world in yards for distances. A cave, a building or a district is lifted to its zone;
-- a continent (the game sometimes answers Kalimdor in the Barrens) is narrowed to the
-- zone at that spot. Nil when any of it is hidden or unknown.
local function ZoneAt(map, x, y)
    for _ = 1, 6 do
        local info = Ask(C_Map.GetMapInfo, map)
        if type(info) ~= "table" then return nil end
        if info.mapType == 3 then return map, x, y end
        if info.mapType and info.mapType < 3 then
            -- (a continent or the world: the zone under this spot)
            local below = Ask(C_Map.GetMapInfoAtPosition, map, x, y)
            if type(below) ~= "table" or not below.mapID or below.mapID == map then return nil end
            local cont, world = Ask(C_Map.GetWorldPosFromMapPos, map, CreateVector2D and CreateVector2D(x, y))
            if not cont or not world then return nil end
            local _, pos = Ask(C_Map.GetMapPosFromWorldPos, cont, world, below.mapID)
            if not pos then return nil end
            map, x, y = below.mapID, pos.x, pos.y
        else
            -- (a cave, building or district: up to its parent, through the world)
            local parent = info.parentMapID
            if not parent or parent == 0 then return nil end
            local cont, world = Ask(C_Map.GetWorldPosFromMapPos, map, CreateVector2D and CreateVector2D(x, y))
            if not cont or not world then return nil end
            local _, pos = Ask(C_Map.GetMapPosFromWorldPos, cont, world, parent)
            if not pos then return nil end
            map, x, y = parent, pos.x, pos.y
        end
    end
    return nil
end
local function Where()
    if not (C_Map and C_Map.GetBestMapForUnit and C_Map.GetPlayerMapPosition) then return nil end
    local map = Ask(C_Map.GetBestMapForUnit, "player")
    if not map then return nil end
    local pos = Ask(C_Map.GetPlayerMapPosition, map, "player")
    if type(pos) ~= "table" and type(pos) ~= "userdata" then return nil end
    local x, y = pos.x, pos.y
    if pos.GetXY then x, y = pos:GetXY() end
    if not Public(x) or not Public(y) or type(x) ~= "number" or type(y) ~= "number" then return nil end
    if (x == 0 and y == 0) or x < 0 or x > 1 or y < 0 or y > 1 then return nil end
    map, x, y = ZoneAt(map, x, y)
    if not map or x < 0 or x > 1 or y < 0 or y > 1 then return nil end
    -- (UnitPosition answers y first)
    local wy, wx = Ask(UnitPosition, "player")
    return map, x, y, wx, wy
end
Road.Where = Where

function Road.On()
    return A.db and A.db.roadRecord == true and A.SelfJournalOn and A.SelfJournalOn()
end
local function Days(create)
    local me = A.Me and A.Me()
    if not me or not A.db then return nil end
    A.db.road = A.db.road or {}
    if create and not A.db.road[me] then A.db.road[me] = {} end
    return A.db.road[me]
end
Road.Mine = Days

-- The line being drawn: its day's list, its index there, and the last point kept.
local line, flight, lastLook
local function Close() line = nil end
local function Open(map, kind, now, x, y, wx, wy)
    local days = Days(true)
    if not days then return end
    local key = DayOf(now)
    days[key] = days[key] or {}
    local list = days[key]
    list[#list + 1] = kind .. ":" .. map .. ":" .. now .. ":" .. Point(x, y, 0)
    line = {list = list, index = #list, map = map, kind = kind, day = key, t = now, wx = wx, wy = wy}
end
local function Keep(now, x, y, wx, wy)
    local dt = now - line.t
    if dt > MAX_DT then return false end
    line.list[line.index] = line.list[line.index] .. Point(x, y, dt)
    line.t, line.wx, line.wy = now, wx, wy
    return true
end
local function Distance(ax, ay, bx, by)
    if not (ax and ay and bx and by) then return nil end
    return math.sqrt((ax - bx) ^ 2 + (ay - by) ^ 2)
end

-- One look: called every SAMPLE seconds (and by the tests with their own clock).
function Road.Look(now)
    now = now or Now()
    if not Road.On() then Close(); flight = nil; return end
    local previous = lastLook
    lastLook = now
    -- On a flight: the line ends where it took off; the flight is kept on landing.
    if Ask(UnitOnTaxi, "player") == true then
        if not flight then
            local map, x, y = Where()
            flight = {map = line and line.map or map, x = line and line.x or x, y = line and line.y or y, t = now}
            Close()
        end
        return
    end
    if flight then
        local map, x, y = Where()
        local days = Days(true)
        if map and flight.map and days then
            local key = DayOf(flight.t)
            days[key] = days[key] or {}
            days[key][#days[key] + 1] = string.format("F:%d:%.4f:%.4f:%d:%.4f:%.4f:%d:%d", flight.map, flight.x, flight.y, map, x, y, flight.t, now)
        end
        flight = nil
    end
    if Ask(IsInInstance) == true then Close(); return end
    -- (in a fight the place is kept as it was; the fight's time joins the next step)
    if Ask(UnitAffectingCombat, "player") == true then return end
    local map, x, y, wx, wy = Where()
    if not map then
        if line and previous and now - line.t > GAP then Close() end
        return
    end
    local kind = Ask(UnitIsGhost, "player") == true and "G" or "R"
    if line then
        local moved = Distance(wx, wy, line.wx, line.wy)
        local since = now - (previous or line.t)
        local jump = moved and moved > math.max(150, JUMP_SPEED * math.max(since, SAMPLE))
        if line.map ~= map or line.kind ~= kind or line.day ~= DayOf(now) or now - line.t > MAX_DT
            or (previous and now - previous > GAP) or jump then
            Close()
        end
    end
    if not line then
        Open(map, kind, now, x, y, wx, wy)
        if line then line.x, line.y = x, y end
        return
    end
    local moved = Distance(wx, wy, line.wx, line.wy)
    -- (without yards, a step is a thousandth of the zone, about the same on most maps)
    if (moved and moved >= STEP) or (not moved and Distance(x, y, line.x, line.y) >= 0.004) then
        if Keep(now, x, y, wx, wy) then line.x, line.y = x, y else Close() end
    end
end

-- Reading a day back: the lines with their points as {x, y, t}, and the flights.
function Road.Decode(text)
    local kind, map, t0, points = text:match("^([RG]):(%d+):(%d+):(.*)$")
    if kind then
        local out, t = {kind = kind == "G" and "ghost" or "road", map = tonumber(map), points = {}}, tonumber(t0)
        for i = 1, #points - 5, 6 do
            t = t + Read(points, i + 4)
            out.points[#out.points + 1] = {x = Read(points, i) / 4095, y = Read(points, i + 2) / 4095, t = t}
        end
        return out
    end
    local m1, x1, y1, m2, x2, y2, a, b = text:match("^F:(%d+):([%d.]+):([%d.]+):(%d+):([%d.]+):([%d.]+):(%d+):(%d+)$")
    if m1 then
        return {kind = "flight", from = {map = tonumber(m1), x = tonumber(x1), y = tonumber(y1), t = tonumber(a)},
            to = {map = tonumber(m2), x = tonumber(x2), y = tonumber(y2), t = tonumber(b)}}
    end
    return nil
end
function Road.Day(character, day)
    local all = A.db and A.db.road and A.db.road[character or (A.Me and A.Me())]
    local list = all and all[day]
    local out = {}
    for _, text in ipairs(list or {}) do
        local piece = Road.Decode(text)
        if piece and (piece.kind == "flight" or #piece.points > 0) then out[#out + 1] = piece end
    end
    return out
end
-- The days that have a road, oldest first.
function Road.Days(character)
    local all = A.db and A.db.road and A.db.road[character or (A.Me and A.Me())]
    local keys = {}
    for key in pairs(all or {}) do keys[#keys + 1] = key end
    table.sort(keys)
    return keys
end

-- The clock: a ticker while the road is recorded (started at login and when the setting
-- changes); it stops itself when the setting is off.
local ticker
function Road.Start()
    if ticker or not (C_Timer and C_Timer.NewTicker) then return end
    if not Road.On() then return end
    ticker = C_Timer.NewTicker(SAMPLE, function()
        local ok = pcall(Road.Look)
        if not ok or not Road.On() then
            Close()
            if not Road.On() and ticker then ticker:Cancel(); ticker = nil end
        end
    end)
end
function Road.Reset() Close(); flight = nil; lastLook = nil end
local events = CreateFrame and CreateFrame("Frame")
if events then
    events:RegisterEvent("PLAYER_ENTERING_WORLD")
    events:SetScript("OnEvent", function()
        -- (1.49.3: on by default; a book saved with the old "off" default, never chosen, is
        -- switched on once; a later "off" stays off)
        if A.db and not A.db.roadDefaultOn then A.db.roadDefaultOn = true; A.db.roadRecord = true end
        Close(); Road.Start()
    end)
end
