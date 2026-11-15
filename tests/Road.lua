-- The Road recorder (Road.lua): what it keeps of a walk, and when it ends a line.
local root = "Interface/AddOns/CompanionJournal/"
local checks = 0
local function check(ok, label) checks = checks + 1; assert(ok, label) end

-- A small world: zone 1412 (Mulgore) and 1411 (Durotar) on Kalimdor (1414), a cave
-- (2000, mapType 4) inside Mulgore. One map unit is 4000 yards; the world is yards.
local clock = 1794600000 -- an evening, 19:00 or so
local player = {map = 1412, x = 0.5, y = 0.5, taxi = false, instance = false, combat = false, ghost = false, hidden = false}
local MAPS = {
    [1412] = {mapID = 1412, mapType = 3, parentMapID = 1414, name = "Mulgore", ox = 0, oy = 0},
    [1411] = {mapID = 1411, mapType = 3, parentMapID = 1414, name = "Durotar", ox = 4000, oy = 0},
    [2000] = {mapID = 2000, mapType = 4, parentMapID = 1412, name = "Cave", ox = 1000, oy = 1000, size = 400},
    [1414] = {mapID = 1414, mapType = 2, parentMapID = 947, name = "Kalimdor", ox = 0, oy = 0, size = 8000},
    [1420] = {mapID = 1420, mapType = 3, parentMapID = 1415, name = "Tirisfal Glades", ox = 20000, oy = 0},
    [1415] = {mapID = 1415, mapType = 2, parentMapID = 947, name = "Eastern Kingdoms", ox = 20000, oy = 0, size = 8000},
}
local function Size(map) return MAPS[map].size or 4000 end
function CreateVector2D(x, y) return {x = x, y = y} end
C_Map = {
    GetBestMapForUnit = function() return player.map end,
    GetPlayerMapPosition = function(map) if player.hidden then return nil end; return {x = player.x, y = player.y} end,
    GetMapInfo = function(map) return MAPS[map] end,
    GetMapChildrenInfo = function() return {MAPS[1412], MAPS[1411], MAPS[2000]} end,
    GetMapWorldSize = function(map) return Size(map), Size(map) end,
    GetMapInfoAtPosition = function(map, x, y) return x * Size(map) >= 4000 and MAPS[1411] or MAPS[1412] end,
    GetWorldPosFromMapPos = function(map, v)
        local m = MAPS[map]
        return 1, {x = m.ox + v.x * Size(map), y = m.oy + v.y * Size(map)}
    end,
    GetMapPosFromWorldPos = function(_, w, map)
        local m = MAPS[map]
        return map, {x = (w.x - m.ox) / Size(map), y = (w.y - m.oy) / Size(map)}
    end,
}
function UnitPosition()
    local m = MAPS[player.map]
    local wx, wy = m.ox + player.x * Size(player.map), m.oy + player.y * Size(player.map)
    return wy, wx -- (y first, as the game answers)
end
function UnitOnTaxi() return player.taxi end
function IsInInstance() return player.instance end
function UnitAffectingCombat() return player.combat end
function UnitIsGhost() return player.ghost end
function time() return clock end
date = os.date
CreateFrame = function() return {RegisterEvent = function() end, SetScript = function() end} end

local A = {defaults = {}, db = {roadRecord = true}}
A.Me = function() return "alberich-realm" end
A.SelfJournalOn = function() return true end
A.JournalEvening = function(t) local h = tonumber(os.date("%H", t)); if h < 5 then return t - 5 * 3600 end; return t end
assert(loadfile(root .. "Road.lua"))("CompanionJournal", A)
assert(loadfile(root .. "RoadModel.lua"))("CompanionJournal", A)
local Road = A.Road
local function Look(seconds) clock = clock + (seconds or 2); Road.Look(clock) end
local function Pieces() local day = Road.Day("alberich-realm", Road.DayOf(clock)); return day end
-- Walk a number of yards east, in 2 s steps at 7 yards a second (on foot).
local function Walk(yards, speed)
    speed = speed or 7
    local steps = math.ceil(yards / (speed * 2))
    for _ = 1, steps do player.x = player.x + (speed * 2) / Size(player.map); Look(2) end
end

-- 1. A walk: one road, a point every 12 yards or more, places and times read back.
clock = os.time({year = 2026, month = 11, day = 13, hour = 19, min = 0})
Look(0)
Walk(140)
local day = Pieces()
check(#day == 1 and day[1].kind == "road" and day[1].map == 1412, "a walk is one road on the zone's map")
local pts = day[1].points
check(#pts >= 9 and #pts <= 13, "a point every 12 yards or more: " .. #pts)
check(math.abs(pts[#pts].x - player.x) < 0.001 and math.abs(pts[1].y - 0.5) < 0.001, "places read back within a thousandth")
check(pts[#pts].t <= clock and pts[2].t > pts[1].t, "times read back in order")

-- 2. Standing still keeps nothing.
local before = #Pieces()[1].points
for _ = 1, 30 do Look(2) end
check(#Pieces()[1].points == before, "standing still adds no points")

-- 3. Into another zone: a new road there.
player.map, player.x = 1411, 0.02
Look(2); Walk(30)
day = Pieces()
check(#day == 2 and day[2].map == 1411, "a new zone starts a new road")

-- 4. A hearthstone (a jump of a thousand yards): the line ends, a new one starts.
player.x = player.x + 0.3
Look(2)
day = Pieces()
check(#day == 3, "a teleport ends the line")

-- 5. A flight: kept on landing, from where the road ended to where it lands.
local takeoffX = player.x
player.taxi = true
for _ = 1, 20 do Look(2) end
player.taxi = false; player.map, player.x, player.y = 1412, 0.2, 0.3
Look(2)
day = Pieces()
local flight
for _, piece in ipairs(day) do if piece.kind == "flight" then flight = piece end end
check(flight and flight.from.map == 1411 and math.abs(flight.from.x - takeoffX) < 0.001 and flight.to.map == 1412
    and math.abs(flight.to.y - 0.3) < 0.001 and flight.to.t - flight.from.t >= 40, "a flight is kept from take-off to landing")

-- 6. An instance ends the line; nothing is kept inside.
local count = #Pieces()
player.instance = true
for _ = 1, 10 do player.x = player.x + 0.01; Look(2) end
player.instance = false
Look(2)
check(#Pieces() == count + 1, "an instance ends the line and keeps nothing inside")

-- 7. A ghost's run back is its own line.
player.ghost = true
Look(2); Walk(60)
day = Pieces()
check(day[#day].kind == "ghost", "a ghost walks its own line")
player.ghost = false
Look(2)
check(Pieces()[#Pieces()].kind == "road", "alive again: a road")

-- 8. A fight keeps the place; hidden positions pause; a long silence ends the line.
local n = #Pieces()
player.combat = true; for _ = 1, 5 do player.x = player.x + 0.002; Look(2) end; player.combat = false
check(#Pieces() == n, "a fight does not end the line")
player.hidden = true; Look(2); Look(2); player.hidden = false; Look(2)
check(#Pieces() == n, "a moment hidden does not end the line")
player.hidden = true; Look(200); player.hidden = false; Look(2)
check(#Pieces() == n + 1, "a long silence ends the line")

-- 9. A cave is lifted to its zone.
player.map, player.x, player.y = 2000, 0.5, 0.5
Look(2)
day = Pieces()
local last = day[#day]
check(last.map == 1412 and math.abs(last.points[#last.points].x - (1000 + 200) / 4000) < 0.001, "a cave's point lands on its zone's map")

-- 10. Past midnight belongs to the evening; five in the morning is a new day.
player.map, player.x, player.y = 1412, 0.4, 0.4
clock = os.time({year = 2026, month = 11, day = 14, hour = 1, min = 30})
Look(0); Walk(30)
check(Road.DayOf(clock) == "2026-11-13", "half past one belongs to the evening before")
clock = os.time({year = 2026, month = 11, day = 14, hour = 5, min = 1})
Look(0); Walk(30)
check(#Road.Day("alberich-realm", "2026-11-14") == 1, "after five a new day begins")

-- 11. Off: nothing is kept.
A.db.roadRecord = false
local all = 0; for _, key in ipairs(Road.Days("alberich-realm")) do all = all + #A.db.road["alberich-realm"][key] end
Walk(100)
local after = 0; for _, key in ipairs(Road.Days("alberich-realm")) do after = after + #A.db.road["alberich-realm"][key] end
check(all == after, "off: nothing is kept")

-- 12. Size: an hour's walk at riding speed stays small.
A.db.roadRecord = true; A.db.road = {}
Road.Reset()
clock = os.time({year = 2026, month = 11, day = 20, hour = 20, min = 0})
player.map, player.x, player.y = 1412, 0.05, 0.05
Look(0)
for i = 1, 1800 do
    player.x = 0.05 + 0.9 * math.abs(math.sin(i / 300)); player.y = 0.05 + 0.9 * math.abs(math.cos(i / 210))
    Look(2)
end
local bytes = 0
for _, text in ipairs(A.db.road["alberich-realm"]["2026-11-20"]) do bytes = bytes + #text end
check(bytes < 16000, "an hour's riding is small: " .. bytes .. " bytes")
-- 13. The day's model: the road, marks placed by their time, stays, zones, companions.
A.db.road = {}; Road.Reset()
clock = os.time({year = 2026, month = 11, day = 21, hour = 20, min = 0})
player.map, player.x, player.y = 1412, 0.1, 0.5
Look(0)
local t0 = clock
Walk(200)                               -- walk 200 yards
local deathAt = clock
local deathX = player.x
for _ = 1, 150 do Look(2) end           -- five minutes in one place (a campfire)
Walk(200)
player.map, player.x = 1411, 0.05
Look(2); Walk(100)
local key = Road.DayOf(clock)
local journal = {
    {k = "with", d = "dahlia-noir", n = "Dahlia-Noir", t = t0, e = deathAt},
    {k = "death", d = "a duskbat", t = deathAt, z = "Mulgore"},
    {k = "mylevel", d = 12, t = clock, z = "Durotar"},
    {k = "play", t = t0, e = clock, z = "Mulgore"},
}
local model = A.RoadModel.Build(journal, key, "alberich-realm")
check(model.recorded and #model.pieces == 2, "the day has its two roads")
check(model.zones[1].map == 1412 and model.zones[2].map == 1411 and model.zones[1].name == "Mulgore", "zones in the order you saw them")
local death
for _, mark in ipairs(model.marks) do if mark.kind == "death" then death = mark end end
check(death and death.map == 1412 and math.abs(death.x - deathX) < 0.003 and not death.guess, "the death sits on the road where it happened")
check(#model.stays == 1 and model.stays[1].secs >= 280 and math.abs(model.stays[1].x - deathX) < 0.01, "a five-minute pause is a stay")
check(A.RoadModel.WithAt(model, t0 + 30).key == "dahlia-noir" and A.RoadModel.WithAt(model, clock) == nil, "the stretch walked with Dahlia")
-- In Dahlia's book: only the road walked with her (her outing with you).
local hers = A.RoadModel.Build({{k = "group", t = t0, e = deathAt}}, key, "alberich-realm", "dahlia-noir")
local last = hers.pieces[#hers.pieces].points
check(#hers.pieces == 1 and last[#last].t <= deathAt + 60, "a companion's map keeps only the road you shared")
-- In Dahlia's book, built from your own journal: only the stretch she was with you.
local fromMine = A.RoadModel.Build(journal, key, "alberich-realm", "dahlia-noir")
local lastMine = fromMine.pieces[#fromMine.pieces].points
check(#fromMine.pieces == 1 and lastMine[#lastMine].t <= deathAt + 60, "her map from your journal: only the stretch she was with you")
-- A day before the recorder: its zones, one wash each.
local old = A.RoadModel.Build({{k = "play", t = 100, e = 4000, z = "Durotar"}, {k = "death", t = 200, z = "Durotar"}}, Road.DayOf(100), "alberich-realm")
check(not old.recorded and #old.stays == 1 and old.stays[1].map == 1411 and old.stays[1].guess, "a day before the recorder: a wash for its zone")
check(#old.marks == 1 and old.marks[1].guess, "its marks sit in the zone, marked as a guess")
check(#A.RoadModel.Days({{k = "play", t = 100, e = 200, z = "Durotar"}}, "alberich-realm") >= 2, "the adventure's days: roads and zones")

-- 14. Travel the road cannot walk: a zeppelin from Tirisfal to Durotar (its journal line
-- written on arrival) is a voyage between the two coasts; a hearthstone, a trip from the
-- cast to where you land.
A.db.road = {}; Road.Reset()
clock = os.time({year = 2026, month = 11, day = 22, hour = 20, min = 0})
player.map, player.x, player.y = 1420, 0.6, 0.6
Look(0); Walk(60)
local boarded = clock
player.hidden = true; clock = clock + 200; Look(2); player.hidden = false   -- (at sea: no place)
player.map, player.x, player.y = 1411, 0.5, 0.3
Look(2)
local arrived = clock
Walk(60)
local hearthAt = clock
player.x, player.y = 0.1, 0.9
clock = clock + 20; Look(2)                                                  -- (home: a long jump)
Walk(30)
local tday = Road.DayOf(clock)
local trip = A.RoadModel.Build({
    {k = "voyage", d = "zeppelin", from = "Eastern Kingdoms", to = "Kalimdor", t = arrived, z = "Durotar"},
    {k = "hearth", d = "Razor Hill", t = hearthAt, z = "Durotar"},
}, tday, "alberich-realm")
local voyage, hearth
for _, piece in ipairs(trip.pieces) do
    if piece.kind == "voyage" then voyage = piece end
    if piece.kind == "hearth" then hearth = piece end
end
check(voyage and voyage.from.map == 1420 and voyage.to.map == 1411 and voyage.from.t <= boarded + 2, "the zeppelin: from Tirisfal's tower to Durotar")
check(hearth and hearth.from.map == 1411 and math.abs(hearth.to.x - 0.1) < 0.01, "the hearthstone: from the cast to where you landed")

print("Road: " .. checks .. " checks passed (an hour of riding: " .. bytes .. " bytes)")
