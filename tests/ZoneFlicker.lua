-- Run from the client root: lua5.1 Interface/AddOns/CompanionJournal/tests/ZoneFlicker.lua [print]
-- A step over a border and back is not a journey (JournalBook.lua, FoldFlickers). A short
-- stay in another zone between two stays in one zone, where nothing happened that the book
-- would tell, is folded away: no "came into", no "went on to", no cave line, and the stays
-- around it read as one. A short stay with a quest in it, a real first visit, and a crossing
-- to a third zone are still told. A first visit seen only in a flicker moves to the next real
-- stay there. A ghost run out of an instance and back keeps the party's deaths on the merged
-- stay. Both own tellers and the companion book go through the same fold.
local root = "Interface/AddOns/CompanionJournal/"
local assertions = 0
local function check(value, message) assertions = assertions + 1; assert(value, message) end
local show = arg and arg[1] == "print"

function time(t) if type(t) == "table" then return os.time(t) end return 1790000000 + 40 * 86400 end
function date(fmt, t) return os.date(fmt, t) end
function CreateFrame() return setmetatable({}, {__index = function() return function() end end}) end
C_Timer = {After = function() end}
LOCALIZED_CLASS_NAMES_MALE = {WARRIOR = "Warrior", MAGE = "Mage", PRIEST = "Priest", ROGUE = "Rogue", WARLOCK = "Warlock",
    HUNTER = "Hunter", DRUID = "Druid", SHAMAN = "Shaman", PALADIN = "Paladin"}
local A = {defaults = {colors = {}}}
for _, file in ipairs({"LoreData.lua", "Lore.lua", "LoreHordeStories.lua", "LoreAllianceStories.lua", "LoreWorldStories.lua",
    "LoreClassStories.lua", "LoreForeverStories.lua", "LoreNotes.lua", "LorePlaces.lua", "LorePeopleHistory.lua", "LoreWorldConnections.lua",
    "People.lua", "Characters.lua", "Journal.lua", "JournalSelf.lua", "JournalBook.lua", "JournalTellers.lua",
    "JournalFeel.lua", "JournalTale.lua", "JournalWords.lua", "JournalSelfWords.lua", "JournalSelfStyle.lua", "JournalSelfPlan.lua", "JournalSelfTale.lua"}) do
    assert(loadfile(root .. file))("CompanionJournal", A)
end
A.db = {people = {}}
A.SelfUnderground = function() return false end

local BASE = os.time({year = 2026, month = 9, day = 1, hour = 0})
local function At(day, hour, minute, second) return BASE + day * 86400 + (hour or 20) * 3600 + (minute or 0) * 60 + (second or 0) end

-- A character's own journal (k = "play"), or a companion's (k = "group").
local function Journal(kind)
    local j = {}
    local function Add(e) e.pl, e.ol = e.pl or 20, e.ol or 20; j[#j + 1] = e end
    local function Stay(zone, t, e) Add({k = kind or "play", t = t, e = e, z = zone}) end
    return j, Add, Stay
end
local function Self(name, race, class, faction, journal)
    return {name = name, charKey = "flicker-" .. name:lower(), self = true, race = race, class = class, faction = faction,
        startLevel = 1, journal = journal}
end
local PLANNED = function(k) if k == "teller" then return "planned" end end
local function Tell(p, planned)
    local before = #p.journal
    A.BookVariant = planned and PLANNED or nil
    local days = A.JournalBook(p)
    local tales = A.SelfTale.Tell(p, days, false)
    A.BookVariant = nil
    check(#p.journal == before, "telling changed the record")
    local texts = {}
    for i, day in ipairs(days) do texts[i] = tales[day.key] and A.JournalPlain(tales[day.key].text) or "" end
    return days, texts
end
local function Outings(day)
    local out = {}
    for _, scene in ipairs(day.scenes) do if scene.kind == "outing" then out[#out + 1] = scene end end
    return out
end
local function Has(events, kind, d)
    for _, e in ipairs(events) do if e.k == kind and (d == nil or e.d == d) then return true end end
    return false
end

-- 1. A cave mouth that is its own zone, looked into twice: one stay in Darkshore, no cave line.
do
    local j, Add, Stay = Journal()
    Stay("Darkshore", At(1, 20, 0), At(1, 20, 30))
    Add({k = "town", d = "Auberdine", t = At(1, 20, 5), z = "Darkshore"})
    Add({k = "quest", d = "The Red Crystal", t = At(1, 20, 20), z = "Darkshore"})
    Stay("Blackfathom Deeps", At(1, 20, 30), At(1, 20, 31))
    Add({k = "cave", d = "Blackfathom Deeps", t = At(1, 20, 30, 10), z = "Blackfathom Deeps"})
    Stay("Darkshore", At(1, 20, 31), At(1, 20, 31, 20))
    Stay("Blackfathom Deeps", At(1, 20, 31, 20), At(1, 20, 31, 50))
    Add({k = "cave", d = "Blackfathom Deeps", t = At(1, 20, 31, 25), z = "Blackfathom Deeps"})
    Stay("Darkshore", At(1, 20, 31, 50), At(1, 21, 0))
    Add({k = "quest", d = "Buzzbox 827", t = At(1, 20, 45), z = "Darkshore"})
    local p = Self("Elyndra", "NightElf", "DRUID", "Alliance", j)
    for _, planned in ipairs({false, true}) do
        local days, texts = Tell(p, planned)
        local tag = planned and " (planned)" or " (current)"
        check(#days == 1, "one day" .. tag)
        local outings = Outings(days[1])
        check(#outings == 1 and outings[1].zone == "Darkshore", "the two cave looks fold into one stay in Darkshore" .. tag)
        check(outings[1].e - outings[1].t == 3600, "the merged stay runs the whole hour" .. tag)
        check(#outings[1].flicker == 2, "both looks are on record as flickers" .. tag)
        check(not Has(outings[1].events, "cave"), "the cave line goes with the flicker" .. tag)
        check(#outings[1].quests == 2, "both quests stay on the stay" .. tag)
        check(not texts[1]:find("Blackfathom"), "the cave mouth is not told" .. tag .. ": " .. texts[1])
        check(not texts[1]:find("underground") and not texts[1]:find("in the dark"), "no underground line" .. tag)
        if show then print("1" .. tag .. ": " .. texts[1]) end
    end
end

-- 2. A road that wobbles along the Loch Modan line: one stay, the Wetlands never named.
do
    local j, Add, Stay = Journal()
    Stay("Loch Modan", At(1, 20, 0), At(1, 20, 20))
    Add({k = "quest", d = "The Lost Pilot", t = At(1, 20, 10), z = "Loch Modan"})
    Stay("Wetlands", At(1, 20, 20), At(1, 20, 20, 10))
    Stay("Loch Modan", At(1, 20, 20, 10), At(1, 20, 20, 20))
    Stay("Wetlands", At(1, 20, 20, 20), At(1, 20, 22))
    Stay("Loch Modan", At(1, 20, 22), At(1, 20, 40))
    Add({k = "quest", d = "Mountaineer Stormpike's Task", t = At(1, 20, 30), z = "Loch Modan"})
    local p = Self("Brunhild", "Dwarf", "HUNTER", "Alliance", j)
    local days, texts = Tell(p)
    local outings = Outings(days[1])
    check(#outings == 1 and outings[1].zone == "Loch Modan", "the border wobble folds into one stay")
    check(not texts[1]:find("Wetlands"), "the Wetlands are not told: " .. texts[1])
    if show then print("2: " .. texts[1]) end
end

-- 3. A short visit with a quest handed in there is a real visit, still told.
do
    local j, Add, Stay = Journal()
    Stay("Mulgore", At(1, 20, 0), At(1, 20, 30))
    Add({k = "quest", d = "Sharing the Land", t = At(1, 20, 10), z = "Mulgore"})
    Stay("The Barrens", At(1, 20, 30), At(1, 20, 32))
    Add({k = "quest", d = "Supplies for the Crossroads", t = At(1, 20, 31), z = "The Barrens"})
    Stay("Mulgore", At(1, 20, 32), At(1, 21, 0))
    Add({k = "quest", d = "Poison Water", t = At(1, 20, 50), z = "Mulgore"})
    local p = Self("Tahomi", "Tauren", "SHAMAN", "Horde", j)
    local days, texts = Tell(p)
    local outings = Outings(days[1])
    check(#outings == 3 and outings[2].zone == "The Barrens", "a quest keeps the short stay")
    check(texts[1]:find("Barrens"), "the Barrens are told: " .. texts[1])
    if show then print("3: " .. texts[1]) end
end

-- 4. A real first visit of ten minutes is told as one.
do
    local j, Add, Stay = Journal()
    Stay("Mulgore", At(1, 20, 0), At(1, 20, 30))
    Add({k = "quest", d = "Sharing the Land", t = At(1, 20, 10), z = "Mulgore"})
    Stay("Stonetalon Mountains", At(1, 20, 30), At(1, 20, 40))
    Add({k = "first", d = "zone", t = At(1, 20, 30), z = "Stonetalon Mountains"})
    Stay("Mulgore", At(1, 20, 40), At(1, 21, 0))
    Add({k = "quest", d = "Poison Water", t = At(1, 20, 50), z = "Mulgore"})
    local p = Self("Tahomi", "Tauren", "SHAMAN", "Horde", j)
    local days, texts = Tell(p)
    local outings = Outings(days[1])
    check(#outings == 3 and outings[2].zone == "Stonetalon Mountains", "ten minutes is a visit")
    check(Has(outings[2].events, "first", "zone"), "its first visit stays with it")
    check(texts[1]:find("Stonetalon"), "Stonetalon is told: " .. texts[1])
    if show then print("4: " .. texts[1]) end
end

-- 5. A first visit seen only in a flicker is told at the next real stay there, not before.
do
    local j, Add, Stay = Journal()
    Stay("Elwynn Forest", At(1, 20, 0), At(1, 20, 30))
    Add({k = "quest", d = "Wolves Across the Border", t = At(1, 20, 10), z = "Elwynn Forest"})
    Stay("Redridge Mountains", At(1, 20, 30), At(1, 20, 31))
    Add({k = "first", d = "zone", t = At(1, 20, 30, 5), z = "Redridge Mountains"})
    Stay("Elwynn Forest", At(1, 20, 31), At(1, 21, 0))
    Add({k = "quest", d = "Bounty on Murlocs", t = At(1, 20, 50), z = "Elwynn Forest"})
    Stay("Redridge Mountains", At(2, 20, 0), At(2, 21, 0))
    Add({k = "quest", d = "Encroaching Gnolls", t = At(2, 20, 30), z = "Redridge Mountains"})
    local p = Self("Aldric", "Human", "WARRIOR", "Alliance", j)
    local days, texts = Tell(p)
    check(#days == 2, "two days")
    local first = Outings(days[1])
    check(#first == 1 and first[1].zone == "Elwynn Forest", "the step into Redridge folds away")
    check(not Has(first[1].events, "first", "zone"), "no first visit on the first day")
    check(not texts[1]:find("Redridge"), "Redridge is not told on the first day: " .. texts[1])
    local second = Outings(days[2])
    check(#second == 1 and Has(second[1].events, "first", "zone"), "the first visit moves to the real stay")
    check(texts[2]:find("Redridge"), "Redridge is told on the second day: " .. texts[2])
    check(texts[2]:find("first time") or texts[2]:find("never been") or texts[2]:find("new to me") or texts[2]:find("never set foot"),
        "the second day says it was the first time there: " .. texts[2])
    if show then print("5a: " .. texts[1]); print("5b: " .. texts[2]) end
end

-- 6. An instance walked into and straight out of folds; two and a half minutes inside does not.
do
    for _, minutes in ipairs({1, 2.5}) do
        local j, Add, Stay = Journal()
        Stay("Dun Morogh", At(1, 20, 0), At(1, 20, 30))
        Add({k = "quest", d = "Frostmane Hold", t = At(1, 20, 10), z = "Dun Morogh"})
        Stay("Gnomeregan", At(1, 20, 30), At(1, 20, 30) + minutes * 60)
        Add({k = "dungeon", d = "Gnomeregan", t = At(1, 20, 30, 5), z = "Gnomeregan"})
        Stay("Dun Morogh", At(1, 20, 30) + minutes * 60, At(1, 21, 0))
        Add({k = "quest", d = "The Perfect Stout", t = At(1, 20, 50), z = "Dun Morogh"})
        local p = Self("Fizzwick", "Gnome", "MAGE", "Alliance", j)
        local days, texts = Tell(p)
        local outings = Outings(days[1])
        if minutes == 1 then
            check(#outings == 1, "a minute inside an instance is a look through the door")
            check(not Has(outings[1].events, "dungeon"), "the dungeon entry goes with it")
            check(not texts[1]:find("Gnomeregan"), "Gnomeregan is not told: " .. texts[1])
        else
            check(#outings == 3 and outings[2].zone == "Gnomeregan", "two and a half minutes inside is a run")
            check(texts[1]:find("Gnomeregan"), "Gnomeregan is told: " .. texts[1])
        end
        if show then print("6 (" .. minutes .. "): " .. texts[1]) end
    end
end

-- 7. A ghost run out of an instance through two zones and back: one run, the party's
-- deaths kept on it in time order, the zones outside never told as travel.
do
    local j, Add, Stay = Journal()
    Stay("Orgrimmar", At(1, 20, 0), At(1, 20, 10))
    Add({k = "town", d = "Orgrimmar", t = At(1, 20, 1), z = "Orgrimmar"})
    Stay("Ragefire Chasm", At(1, 20, 10), At(1, 20, 20))
    Add({k = "dungeon", d = "Ragefire Chasm", t = At(1, 20, 10, 5), z = "Ragefire Chasm", r = "tank"})
    Add({k = "death", d = "Ragefire Trogg", w = "you", t = At(1, 20, 18), z = "Ragefire Chasm"})
    Add({k = "pdeath", n = "Zarok-Forever", t = At(1, 20, 19), z = "Ragefire Chasm"})
    Stay("Durotar", At(1, 20, 20), At(1, 20, 20, 20))
    Add({k = "pdeath", n = "Mogra-Forever", t = At(1, 20, 20, 10), z = "Durotar"})
    Stay("Orgrimmar", At(1, 20, 20, 20), At(1, 20, 22))
    Add({k = "town", d = "Orgrimmar", t = At(1, 20, 20, 30), z = "Orgrimmar"})
    Add({k = "rest", d = "Orgrimmar", t = At(1, 20, 20, 40), z = "Orgrimmar"})
    Add({k = "pdeath", n = "Tesh-Forever", t = At(1, 20, 21), z = "Orgrimmar"})
    Stay("Ragefire Chasm", At(1, 20, 22), At(1, 20, 50))
    Add({k = "dungeon", d = "Ragefire Chasm", t = At(1, 20, 22, 5), z = "Ragefire Chasm", r = "tank"})
    Add({k = "boss", d = "Taragaman the Hungerer", t = At(1, 20, 40), z = "Ragefire Chasm"})
    Stay("Orgrimmar", At(1, 20, 50), At(1, 21, 0))
    local p = Self("Grakthar", "Orc", "WARRIOR", "Horde", j)
    local days, texts = Tell(p)
    local outings = Outings(days[1])
    check(#outings == 3 and outings[2].zone == "Ragefire Chasm", "the ghost run folds into the dungeon run")
    check(outings[2].e - outings[2].t == 40 * 60, "the run covers the wipe and the way back")
    local deaths = {}
    for _, e in ipairs(outings[2].events) do if e.k == "pdeath" then deaths[#deaths + 1] = e.n end end
    check(#deaths == 3 and deaths[1] == "Zarok-Forever" and deaths[2] == "Mogra-Forever" and deaths[3] == "Tesh-Forever",
        "the party's deaths are kept in time order")
    check(Has(outings[2].events, "death"), "the character's own death is kept")
    check(#outings[2].bosses == 1, "the boss is on the run")
    check(not texts[1]:find("Durotar"), "Durotar is not told as travel: " .. texts[1])
    check(not texts[1]:find("back out into") and not texts[1]:find("went on to"), "no travel line for the ghost run: " .. texts[1])
    if show then print("7: " .. texts[1]) end
end

-- 8. A zone crossed on the way to a third one is not a stop: the journey is one sentence,
-- naming where it ended.
do
    local j, Add, Stay = Journal()
    Stay("Elwynn Forest", At(1, 20, 0), At(1, 20, 30))
    Add({k = "quest", d = "Wolves Across the Border", t = At(1, 20, 10), z = "Elwynn Forest"})
    Stay("Westfall", At(1, 20, 30), At(1, 20, 36))
    Add({k = "town", d = "Sentinel Hill", t = At(1, 20, 33), z = "Westfall"})
    Stay("Duskwood", At(1, 20, 36), At(1, 21, 0))
    Add({k = "quest", d = "The Hermit", t = At(1, 20, 50), z = "Duskwood"})
    local p = Self("Aldric", "Human", "WARRIOR", "Alliance", j)
    local days, texts = Tell(p)
    local outings = Outings(days[1])
    check(#outings == 2 and outings[2].zone == "Duskwood", "the crossing folds into the stay before")
    check(outings[1].crossed and outings[1].crossed[1] == "Westfall", "the crossing is on record")
    check(not texts[1]:find("Westfall") and not texts[1]:find("Sentinel Hill"), "the zone crossed is not told: " .. texts[1])
    check(texts[1]:find("Duskwood"), "where the journey ended is told: " .. texts[1])
    if show then print("8: " .. texts[1]) end
end

-- 11. A zeppelin crossing: the tower zone and the landing zone are crossings; the ride is
-- told at the end of the stay it left from, and the stop it reached opens on its own lines.
do
    local j, Add, Stay = Journal()
    Stay("Undercity", At(1, 20, 0), At(1, 20, 30))
    Add({k = "town", d = "Undercity", t = At(1, 20, 1), z = "Undercity"})
    Add({k = "quest", d = "A Letter for the Apothecary", t = At(1, 20, 10), z = "Undercity"})
    Stay("Tirisfal Glades", At(1, 20, 30), At(1, 20, 33))
    Add({k = "town", d = "Brill", t = At(1, 20, 31), z = "Tirisfal Glades"})
    Add({k = "voyage", d = "zeppelin", from = "Eastern Kingdoms", to = "Kalimdor", t = At(1, 20, 33), z = "Tirisfal Glades"})
    Add({k = "first", d = "continent", t = At(1, 20, 33), z = "Kalimdor"})
    Stay("Durotar", At(1, 20, 33), At(1, 20, 34))
    Stay("Orgrimmar", At(1, 20, 34), At(1, 21, 0))
    Add({k = "first", d = "zone", t = At(1, 20, 34), z = "Orgrimmar"})
    Add({k = "town", d = "Orgrimmar", t = At(1, 20, 34, 10), z = "Orgrimmar"})
    Add({k = "quest", d = "Meal Appeal", t = At(1, 20, 50), z = "Orgrimmar"})
    local p = Self("Morwenna", "Scourge", "PRIEST", "Horde", j)
    for _, planned in ipairs({false, true}) do
        local days, texts = Tell(p, planned)
        local tag = planned and " (planned)" or " (current)"
        local outings = Outings(days[1])
        check(#outings == 2 and outings[2].zone == "Orgrimmar", "the tower and the landing fold away" .. tag)
        check(#outings[1].crossed == 2, "both crossings are on record" .. tag)
        local voyage
        for _, e in ipairs(outings[1].events) do if e.k == "voyage" then voyage = e end end
        check(voyage and voyage.carried, "the ride is carried to the stay it left from" .. tag)
        local text = texts[1]
        check(not text:find("Brill") and not text:find("Durotar"), "the stops that did not matter are not told" .. tag .. ": " .. text)
        local ride = text:find("zeppelin") or text:find("Kalimdor")
        local org = text:find("Orgrimmar")
        check(ride and org and ride < org, "the ride is told before the city it reached" .. tag .. ": " .. text)
        local letter = text:find("Letter for the Apothecary")
        check(letter and letter < ride, "the ride is told after the stay's own work" .. tag .. ": " .. text)
        if show then print("11" .. tag .. ": " .. text) end
    end
end

-- 12. The hearthstone from a zone crossed on the way: the crossing is not told, the
-- hearthstone still carries the reader to the next stop.
do
    local j, Add, Stay = Journal()
    Stay("Duskwood", At(1, 20, 0), At(1, 20, 30))
    Add({k = "quest", d = "The Hermit", t = At(1, 20, 10), z = "Duskwood"})
    Stay("Stranglethorn Vale", At(1, 20, 30), At(1, 20, 36))
    Add({k = "hearth", d = "The Sepulcher", t = At(1, 20, 36), z = "Stranglethorn Vale"})
    Stay("Silverpine Forest", At(1, 20, 36), At(1, 21, 0))
    Add({k = "town", d = "The Sepulcher", t = At(1, 20, 36, 10), z = "Silverpine Forest"})
    Add({k = "quest", d = "Report to Hadrec", t = At(1, 20, 50), z = "Silverpine Forest"})
    local p = Self("Morwenna", "Scourge", "PRIEST", "Horde", j)
    local days, texts = Tell(p)
    local outings = Outings(days[1])
    check(#outings == 2 and outings[2].zone == "Silverpine Forest", "the crossing folds into the stay before")
    check(not texts[1]:find("Stranglethorn"), "the crossing is not told: " .. texts[1])
    check(texts[1]:find("hearthstone"), "the hearthstone is told: " .. texts[1])
    if show then print("12: " .. texts[1]) end
end

-- 13. A day that opens on a crossing (the lift, two minutes in the city) opens on its first
-- stop instead.
do
    local j, Add, Stay = Journal()
    Stay("Ironforge", At(1, 20, 0), At(1, 20, 2))
    Add({k = "town", d = "Ironforge", t = At(1, 20, 0, 30), z = "Ironforge"})
    Add({k = "rest", d = "Ironforge", t = At(1, 20, 0, 40), z = "Ironforge"})
    Stay("Dun Morogh", At(1, 20, 2), At(1, 20, 40))
    Add({k = "quest", d = "Frostmane Hold", t = At(1, 20, 20), z = "Dun Morogh"})
    local p = Self("Brunhild", "Dwarf", "HUNTER", "Alliance", j)
    local days, texts = Tell(p)
    local outings = Outings(days[1])
    check(#outings == 1 and outings[1].zone == "Dun Morogh", "the day opens on its first stop")
    check(outings[1].t == At(1, 20, 0), "the crossing's time goes with it")
    check(not texts[1]:find("Ironforge"), "the city passed through is not told: " .. texts[1])
    if show then print("13: " .. texts[1]) end
end

-- 14. A stay of ten minutes with nothing recorded is still a stop (someone was fighting
-- there), told as before.
do
    local j, Add, Stay = Journal()
    Stay("Ashenvale", At(1, 20, 0), At(1, 20, 30))
    Add({k = "quest", d = "Raene's Cleansing", t = At(1, 20, 10), z = "Ashenvale"})
    Stay("The Barrens", At(1, 20, 30), At(1, 20, 40))
    Stay("Ashenvale", At(1, 20, 40), At(1, 21, 0))
    Add({k = "quest", d = "Bathran's Hair", t = At(1, 20, 50), z = "Ashenvale"})
    local p = Self("Elyndra", "NightElf", "DRUID", "Alliance", j)
    local days = Tell(p)
    check(#Outings(days[1]) == 3, "ten minutes away is a stay of its own")
end

-- 9. A short stay with a cave in it that is a stop (a quest was handed in there) tells the
-- cave, but never claims "a while in the dark".
do
    local j, Add, Stay = Journal()
    Stay("Durotar", At(1, 20, 0), At(1, 20, 30))
    Add({k = "quest", d = "Lazy Peons", t = At(1, 20, 10), z = "Durotar"})
    Stay("The Barrens", At(1, 20, 30), At(1, 20, 35))
    Add({k = "cave", d = "Wailing Caverns", t = At(1, 20, 31), z = "The Barrens"})
    Add({k = "quest", d = "Deepmoss Spider Eggs", t = At(1, 20, 34), z = "The Barrens"})
    Stay("Mulgore", At(1, 20, 35), At(1, 21, 0))
    Add({k = "quest", d = "Sharing the Land", t = At(1, 20, 50), z = "Mulgore"})
    local p = Self("Grakthar", "Orc", "WARRIOR", "Horde", j)
    local _, texts = Tell(p)
    check(texts[1]:find("Wailing Caverns"), "the cave is told: " .. texts[1])
    check(not texts[1]:find("a while"), "two minutes is not a while underground: " .. texts[1])
    if show then print("9: " .. texts[1]) end
end

-- 10. The companion book goes through the same fold: a group stay that steps over the
-- Durotar line and back reads as one stay.
do
    local j, Add, Stay = Journal("group")
    Stay("Durotar", At(1, 20, 0), At(1, 20, 30))
    Add({k = "quest", d = "Lazy Peons", t = At(1, 20, 10), z = "Durotar"})
    Stay("The Barrens", At(1, 20, 30), At(1, 20, 31))
    Stay("Durotar", At(1, 20, 31), At(1, 21, 0))
    Add({k = "quest", d = "Thazz'ril's Pick", t = At(1, 20, 50), z = "Durotar"})
    local kael = {name = "Kael-Forever", class = "WARRIOR", race = "Orc", pronouns = "he", journal = j, met = At(0, 19), metZone = "Durotar"}
    local days = A.JournalBook(kael)
    local tales = A.JournalTale.Tell(kael, days, "you", {race = "Troll", faction = "Horde"})
    local outings = Outings(days[#days])
    check(#outings == 1 and outings[1].zone == "Durotar", "the companion book folds the step too")
    local text = A.JournalPlain(tales[days[#days].key].text)
    check(not text:find("Barrens"), "the Barrens are not told in the companion book: " .. text)
    if show then print("10: " .. text) end
end

print(assertions .. " zone flicker checks passed")
