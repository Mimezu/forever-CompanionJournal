-- Scene continuity, sparse early history, and read-only deterministic rendering.
-- Run from client root: lua5.1 Interface/AddOns/CompanionJournal/tests/SelfScenes.lua [print|before]
local root = "Interface/AddOns/CompanionJournal/"
local before = arg and arg[1] == "before"
function time(t) return type(t) == "table" and os.time(t) or 1790000000 end
function date(fmt, t) return os.date(fmt, t) end
local A = {defaults = {colors = {}}}
for _, file in ipairs({"LoreData.lua", "Lore.lua", "JournalBook.lua", "JournalSelfWords.lua", "JournalSelfTale.lua"}) do
    local path = before and file:find("JournalSelf", 1, true) and "StorageInvestigation/cj-story-ui-before-20261011/" or root
    assert(loadfile(path .. file))("CompanionJournal", A)
end
local checks = 0
local function check(ok, why) checks = checks + 1; assert(ok, why) end
local function snapshot(value)
    if type(value) ~= "table" then return type(value) .. ":" .. tostring(value) end
    local keys, out = {}, {}
    for k in pairs(value) do keys[#keys + 1] = k end
    table.sort(keys, function(a, b) return tostring(a) < tostring(b) end)
    for _, k in ipairs(keys) do out[#out + 1] = snapshot(k) .. "=" .. snapshot(value[k]) end
    return "{" .. table.concat(out, ",") .. "}"
end
local base = os.time({year = 2026, month = 9, day = 1, hour = 18})
local p = {self = true, charKey = "alberich-scenes", name = "Alberich", race = "Scourge", faction = "Horde", class = "WARLOCK", startLevel = 11, journal = {}}
local function stretch(day, hour, zone, events)
    local t = base + day * 86400 + hour * 3600
    p.journal[#p.journal + 1] = {k = "play", t = t, e = t + 1800, z = zone, pl = 11}
    for i, e in ipairs(events or {}) do
        e.t, e.z, e.pl = t + i * 60, e.z or zone, 11
        p.journal[#p.journal + 1] = e
    end
end
stretch(0, 0, "Silverpine Forest", {{k = "town", d = "The Sepulcher"}, {k = "quest", d = "Arugal's Folly"},
    {k = "quest", d = "Prove Your Worth"}, {k = "quest", d = "Border Crossings"}, {k = "quest", d = "The Decrepit Ferry"}})
stretch(0, 1, "Hillsbrad Foothills", {{k = "town", d = "Tarren Mill"}, {k = "quest", d = "Elixir of Suffering"}, {k = "rest", d = "Tarren Mill"}})
stretch(1, 0, "Hillsbrad Foothills", {{k = "gather", d = "herbs", c = 7}})
stretch(2, 0, "Orgrimmar", {{k = "quest", d = "Hidden Enemies"}})
stretch(2, 1, "Ragefire Chasm", {{k = "dungeon", d = "Ragefire Chasm"}, {k = "boss", d = "Oggleflint", n = 5}, {k = "boss", d = "Taragaman the Hungerer", n = 5}})
stretch(3, 0, "Orgrimmar", {{k = "town", d = "Orgrimmar"}, {k = "first", d = "zone"}})
local journalBefore = snapshot(p.journal)
local days = A.JournalBook(p)
local bookBefore = snapshot(days)
local full = A.SelfTale.Tell(p, days, false, 0)
local short = A.SelfTale.Tell(p, days, true, 0)
if arg and (arg[1] == "print" or before) then
    for _, d in ipairs(days) do print(d.key .. "\n" .. A.JournalPlain(short[d.key].text) .. "\n") end
end
if before then return end
check(snapshot(days) == bookBefore, "rendering must not mutate cached book events")
check(snapshot(p.journal) == journalBefore, "rendering must not mutate journal records")
check(snapshot(full) == snapshot(A.SelfTale.Tell(p, days, false, 0)), "same cached book retells deterministically")
check(snapshot(short) == snapshot(A.SelfTale.Tell(p, days, true, 0)), "Highlights are stable after full rendering")
local first = short[days[1].key].text
check(first:find("\n\n", 1, true), "a change of place creates a scene paragraph")
check(first:find("Silverpine", 1, true) < first:find("Hillsbrad", 1, true), "recorded region order survives Highlights")
-- (2026-11-07, DESIGN §3.0: Highlights tells the stretch's work worth telling, whichever stage that is)
local toldOne = false
for _, title in ipairs({"Arugal's Folly", "Prove Your Worth", "Border Crossings", "The Decrepit Ferry"}) do
    if A.QuestDeeds.Shows(first, nil, title) then toldOne = true end
end
check(toldOne, "formative work tells one of its stages")
check(first:find("Tarren Mill", 1, true), "first ally town survives Highlights")
check(not first:find("other quests", 1, true), "a singular remaining quest is grammatical")
check(not first:find("Deathknell", 1, true), "missing levels do not fabricate an origin visit")
for _, d in ipairs(days) do check(short[d.key].text ~= "", "a quiet recorded day is still a chapter") end
local dungeon = short[days[3].key].text
check(dungeon:find("Ragefire", 1, true) and dungeon:find("Taragaman", 1, true), "dungeon setting and named outcome survive")
check(not dungeon:find("never been inside", 1, true) and not dungeon:find("first time", 1, true), "late start cannot establish a first-ever dungeon")
local capital = short[days[4].key].text:lower()
check(not capital:find("first time", 1, true), "late first marker cannot override an earlier capital visit")
local versions = {}
for retell = 0, 7 do
    local s = A.SelfTale.Tell(p, days, true, retell)
    versions[s[days[1].key].text] = true
    for _, d in ipairs(days) do
        check(not s[d.key].text:find("{%a+}"), "all narrative tokens are resolved")
        check(s[d.key].text ~= "", "every retelling preserves each scene day")
    end
end
local count = 0; for _ in pairs(versions) do count = count + 1 end
check(count >= 6, "retellings provide varied scene prose")
do
    local sparse = {self = true, name = "Sparse", race = "Scourge", faction = "Horde", startLevel = 1, journal = {
        {k = "play", t = base, e = base + 1800, z = "Silverpine Forest", s = true},
        {k = "quest", d = "The Decrepit Ferry", t = base + 60, z = "Silverpine Forest", s = true},
        {k = "play", t = base + 3600, e = base + 5400, z = "Ragefire Chasm", s = true},
        {k = "dungeon", d = "Ragefire Chasm", t = base + 3660, z = "Ragefire Chasm", s = true},
        {k = "boss", d = "Oggleflint", t = base + 3720, z = "Ragefire Chasm", s = true},
    }}
    local ds = A.JournalBook(sparse)
    local text = A.SelfTale.Tell(sparse, ds, true, 0)[ds[1].key].text
    check(text:find("Deathknell", 1, true) and text:find("\n\n", 1, true), "origin remains a separate prologue")
    check(text:find("Silverpine", 1, true) < (text:find("Rot Hide", 1, true) or text:find("ferry", 1, true) or math.huge), "captured region is established before its quests")
    check(not text:find("level 1", 1, true), "synthetic origin level does not become a recorded travel level")
    check(not text:find("never been inside", 1, true) and not text:find("first time", 1, true), "seeded origin cannot establish dungeon first-ever")
end
do
    local town = {self = true, name = "Town", race = "Scourge", faction = "Horde", startLevel = 30, journal = {
        {k = "play", t = base, e = base + 1800, z = "Orgrimmar", pl = 30},
        {k = "town", d = "Orgrimmar", t = base + 60, z = "Orgrimmar", pl = 30},
    }}
    local ds = A.JournalBook(town)
    local text = A.SelfTale.Tell(town, ds, false, 0)[ds[1].key].text
    check(text:find("} was "), "town backdrop fragments receive a subject and verb")
end
do
    local routine = {self = true, name = "Routine", race = "Scourge", faction = "Horde", startLevel = 30, journal = {
        {k = "play", t = base, e = base + 3600, z = "Silverpine Forest", pl = 30},
    }}
    for i = 1, 8 do routine.journal[#routine.journal + 1] = {k = "rest", d = "Quiet Inn", t = base + i * 120, z = "Silverpine Forest", pl = 30} end
    local ds = A.JournalBook(routine)
    local fullText = A.SelfTale.Tell(routine, ds, false, 0)[ds[1].key].text
    local briefText = A.SelfTale.Tell(routine, ds, true, 0)[ds[1].key].text
    -- (2026-11-07: Everything itself now tells a rest at one inn once a chapter)
    local _, inns = fullText:gsub("Quiet Inn", "")
    check(#briefText <= #fullText and inns <= 1, "repeated quiet chatter is bounded within a scene: " .. fullText .. " / " .. briefText)
    check(briefText:find("Quiet Inn", 1, true), "condensing repeats preserves the actual quiet activity")
end
for _, interaction in ipairs({false, true}) do
    local visitor = {self = true, name = "Visitor", race = "Scourge", faction = "Horde", startLevel = 15, journal = {
        {k = "play", t = base, e = base + 1800, z = "Undercity", pl = 15},
        {k = "first", d = "notable", n = "Lady Sylvanas Windrunner", z = "Undercity", interaction = interaction, t = base + 60, pl = 15},
    }}
    local vd = A.JournalBook(visitor)
    local story = A.SelfTale.Tell(visitor, vd, true, 0)[vd[1].key].text
    check(story:find("Sylvanas", 1, true), "recorded leader is named in Highlights")
    check(story:find("Forsaken", 1, true), "recorded leader receives grounded context")
    check((story:find("spoke with", 1, true) ~= nil) == interaction, "target observation alone never invents speech")
end
print("PASS: " .. checks .. " personal scene assertions")
