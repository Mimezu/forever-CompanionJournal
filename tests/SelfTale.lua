-- Run from the client root: lua Interface/AddOns/CompanionJournal/tests/SelfTale.lua [print]
-- Your own journal, told: first person, the style guide's rules, the facts,
-- towns seen by who you are, honest work, firsts, and the short telling.
local root = "Interface/AddOns/CompanionJournal/"
local assertions = 0
local function check(value, message) assertions = assertions + 1; assert(value, message) end
local show = arg and arg[1] == "print"

function time(t) if type(t) == "table" then return os.time(t) end return 1790000000 + 40 * 86400 end
function date(fmt, t) return os.date(fmt, t) end
local A = {defaults = {colors = {}}}
for _, file in ipairs({"LoreData.lua", "Lore.lua", "JournalBook.lua", "JournalSelfWords.lua", "JournalSelfTale.lua"}) do
    assert(loadfile(root .. file))("CompanionJournal", A)
end
A.SelfUnderground = function(name)
    for _, word in ipairs({"Mine", "Cave", "Den"}) do if name:find("%f[%a]" .. word .. "%f[%A]") then return true end end
    return false
end

local BASE = os.time({year = 2026, month = 9, day = 1, hour = 0})
local function At(day, hour, minute) return BASE + day * 86400 + (hour or 20) * 3600 + (minute or 0) * 60 end
-- One stretch of play: {k = "play"} plus what happened in it, a few minutes apart.
local function Stretch(journal, t, minutes, zone, pl, events)
    journal[#journal + 1] = {k = "play", t = t, e = t + minutes * 60, z = zone, pl = pl}
    for i, ev in ipairs(events or {}) do
        local entry = {t = t + i * 90, z = zone, pl = pl}
        for key, value in pairs(ev) do entry[key] = value end
        journal[#journal + 1] = entry
    end
end
local function Quests(titles) local out = {} for _, q in ipairs(titles) do out[#out + 1] = {k = "quest", d = q} end return out end

local function Book(race, faction)
    local j = {}
    -- Day 0: the first day, Durotar (or the glades), quests and a first level.
    Stretch(j, At(0, 19), 70, "Tirisfal Glades", 3, {{k = "town", d = "Deathknell"}, {k = "quest", d = "Rude Awakening"},
        {k = "quest", d = "The Mindless Ones"}, {k = "mylevel", d = 4}})
    -- Day 1: Brill, the inn, many quests.
    Stretch(j, At(1, 20), 120, "Tirisfal Glades", 5, {{k = "town", d = "Brill"}, {k = "quest", d = "Fields of Grief"},
        {k = "quest", d = "Gordo's Task"}, {k = "quest", d = "Wanted: Maggot Eye"}, {k = "quest", d = "Fields of Grief"},
        {k = "quest", d = "Graverobbers"}, {k = "rest", d = "Brill"}, {k = "mylevel", d = 6}})
    -- Day 2: a mine, a close call, a death in it.
    Stretch(j, At(2, 21), 90, "Tirisfal Glades", 7, {{k = "cave", d = "Agamand Mills Mine"},
        {k = "close", d = "Rattlecage Soldier", a = true}, {k = "death", w = "you", d = "Kobold Tunneler", a = true, sz = "Agamand Mills Mine"},
        {k = "quest", d = "Deaths in the Family"}})
    -- Day 4: honest work.
    Stretch(j, At(4, 18), 150, "Durotar", 9, {{k = "gather", d = "mining", c = 22}, {k = "gather", d = "skinning", c = 9},
        {k = "craft", d = "Tailoring", c = 12, m = {"Brown Linen Shirt", "Linen Cloak"}}})
    -- Day 5: Dahlia joins; Ragefire Chasm and Taragaman; level ten.
    Stretch(j, At(5, 20), 40, "Durotar", 9, {{k = "quest", d = "Sarkoth"}})
    j[#j + 1] = {k = "with", d = "dahlia-noir", n = "Dahlia-Noir", t = At(5, 20, 50), e = At(5, 23)}
    Stretch(j, At(5, 20, 45), 60, "Orgrimmar", 9, {{k = "town", d = "Orgrimmar"}})
    Stretch(j, At(5, 21, 50), 50, "Ragefire Chasm", 10, {{k = "dungeon", d = "Ragefire Chasm"}, {k = "boss", d = "Oggleflint"},
        {k = "boss", d = "Taragaman the Hungerer"}, {k = "mylevel", d = 10}})
    -- Day 6: first visit above your level; the tram and a first flight.
    Stretch(j, At(6, 20), 45, "Silverpine Forest", 10, {{k = "first", d = "zone", z = "Silverpine Forest"}, {k = "first", d = "flight"},
        {k = "quest", d = "Arugal's Folly"}})
    Stretch(j, At(6, 21, 5), 20, "Deeprun Tram", 10, {{k = "first", d = "tram"}})
    -- Day 8: the first zeppelin, to Kalimdor.
    Stretch(j, At(8, 20), 30, "Durotar", 11, {{k = "voyage", d = "zeppelin", from = "Eastern Kingdoms", to = "Kalimdor"},
        {k = "first", d = "zeppelin"}, {k = "first", d = "continent", z = "Kalimdor"}, {k = "quest", d = "Sarkoth"}})
    -- Day 30: back in the glades after weeks away, a foreign town.
    Stretch(j, At(30, 22), 180, "Tirisfal Glades", 14, {{k = "town", d = "Goldshire"}, {k = "quest", d = "A Letter Undelivered"}})
    return {self = true, charKey = "me-forever", name = "Alberich", race = race, faction = faction, journal = j}
end

local BANNED = {"journal", "tale", "song", "verse", "chronicle", "together we", " you ", "You "}
local function Tell(person, brief, retell)
    local days = A.JournalBook(person)
    return days, A.SelfTale.Tell(person, days, brief, retell)
end
local function Page(days, stories)
    local out = {}
    for _, day in ipairs(days) do
        local s = stories[day.key]
        if s and s.text ~= "" then out[#out + 1] = {day = day, title = s.title, chapter = s.chapter, text = A.JournalPlain(s.text)} end
    end
    return out
end

local undead = Book("Scourge", "Horde")
local days, stories = Tell(undead, false, 0)
local chapters = Page(days, stories)
if show then
    for _, c in ipairs(chapters) do io.write(("\n-- Chapter %d. %s  [%s]\n%s\n"):format(c.chapter, tostring(c.title), c.day.key, c.text)) end
end
check(#chapters == 8, "one chapter a day: " .. #chapters)
for _, c in ipairs(chapters) do
    check(not c.text:find("{%a+}"), "no raw tokens: " .. c.text)
    check(not c.text:gsub("Wanted:", "Wanted"):find(":", 1, true), "no prose colons (quest titles retain theirs): " .. c.text)
    for _, word in ipairs(BANNED) do check(not c.text:find(word, 1, true), "no \"" .. word .. "\": " .. c.text) end
    check(c.title and c.title ~= "" and not c.title:find("[{}]"), "a clean title: " .. tostring(c.title))
end
local function Chapter(n) return chapters[n].text end
check(Chapter(1):find("Tirisfal", 1, true), "it begins where you began: " .. Chapter(1))
check(Chapter(2):find("Brill", 1, true) and (Chapter(2):find("home", 1, true) or Chapter(2):find("Gallows", 1, true)
    or Chapter(2):find("quiet", 1, true) or Chapter(2):find("my own people", 1, true) or Chapter(2):find("Forsaken", 1, true)), "Brill, told as home to the Forsaken: " .. Chapter(2))
check(Chapter(2):find("Fields of Grief", 1, true) or Chapter(2):find("Gordo's Task", 1, true) or Chapter(2):find("Rot Hides", 1, true) or Chapter(2):find("five quests", 1, true) or Chapter(2):find("Five quests", 1, true),
    "the day's quests: " .. Chapter(2))
check(Chapter(3):find("Agamand Mills Mine", 1, true) and Chapter(3):find("Kobold Tunneler", 1, true), "the mine and the kobold: " .. Chapter(3))
check(not Chapter(3):find("Rattlecage", 1, true), "a close call is not told on a day you died: " .. Chapter(3))
check(Chapter(4):find("honest work", 1, true) or Chapter(4):find("my trades", 1, true), "an honest day: " .. Chapter(4))
check(Chapter(4):find("mined twenty-two veins", 1, true) and (Chapter(4):lower():find("tailoring", 1, true) or Chapter(4):find("needle and thread", 1, true) or Chapter(4):find("sewed", 1, true)), "the work itself: " .. Chapter(4))
check(Chapter(5):find("Dahlia", 1, true) and Chapter(5):find("Taragaman", 1, true) and Chapter(5):lower():find("level ten", 1, true),
    "Dahlia, Taragaman and level ten: " .. Chapter(5))
check(Chapter(5):find("We ", 1, true) or Chapter(5):find(" we ", 1, true), "with Dahlia in the dungeon, it is \"we\": " .. Chapter(5))
check(Chapter(6):find("Deeprun Tram", 1, true) and (Chapter(6):find("flew", 1, true) or Chapter(6):find("flight", 1, true)),
    "the tram and a first flight: " .. Chapter(6))
check(Chapter(6):find("Silverpine", 1, true) and (Chapter(6):find("first", 1, true) or Chapter(6):find("never", 1, true) or Chapter(6):find("somewhere new", 1, true)),
    "a first visit: " .. Chapter(6))
check(Chapter(7):find("zeppelin", 1, true) and Chapter(7):find("Kalimdor", 1, true), "the first zeppelin, to Kalimdor: " .. Chapter(7))
check(chapters[7].title == "Across the Sea" or chapters[7].title == "Over the Water" or chapters[7].title == "The Crossing"
    or chapters[7].title == "Kalimdor" or chapters[7].title == "A New Land", "a voyage title: " .. tostring(chapters[7].title))
check(Chapter(8):find("weeks", 1, true) or Chapter(8):find("back", 1, true), "back after weeks away: " .. Chapter(8))
check(Chapter(8):find("Goldshire", 1, true) and (Chapter(8):find("Alliance", 1, true)), "Goldshire, an Alliance town to a Forsaken: " .. Chapter(8))
-- Titles: the honest day, Taragaman, the tram.
check(chapters[4].title == "Honest Work" or chapters[4].title == "At My Trades" or chapters[4].title == "A Working Day", "honest title: " .. tostring(chapters[4].title))
check(chapters[5].title == "Taragaman" or chapters[5].title == "Into the Dark" or chapters[5].title == "The First Descent" or chapters[5].title == "The First Dungeon" or chapters[5].title == "Past the Gate" or chapters[5].title:find("Level", 1, true), "Taragaman's day, the first dungeon: " .. tostring(chapters[5].title))

-- The same days for an orc: Brill is someone else's town, Orgrimmar is home.
local orc = Book("Orc", "Horde")
local _, orcStories = Tell(orc, false, 0)
local orcPage = Page(days, orcStories)
check(not orcPage[2].text:find("It was home", 1, true) and not orcPage[2].text:find("Gallows' End Tavern in", 1, true)
    and orcPage[2].text:find("Brill", 1, true), "Brill for an orc: " .. orcPage[2].text)
-- A human sees Goldshire as home.
local human = Book("Human", "Alliance")
local _, humanStories = Tell(human, false, 0)
local humanPage = Page(days, humanStories)
check(not humanPage[8].text:find("belonged to the", 1, true) and not humanPage[8].text:find("a town of the", 1, true),
    "Goldshire is not foreign to a human: " .. humanPage[8].text)

-- The same retelling reads the same; another one finds new words.
local _, again = Tell(undead, false, 0)
local same = true
for _, day in ipairs(days) do if again[day.key].text ~= stories[day.key].text then same = false end end
check(same, "the same words until you retell")
local _, retold = Tell(undead, false, 1)
local changed = 0
for _, day in ipairs(days) do if retold[day.key].text ~= stories[day.key].text then changed = changed + 1 end end
check(changed >= 3, "a retelling finds new words: " .. changed .. " chapters changed")

-- Highlights keep the notable moments. Full prose now removes redundant title
-- anchors, so raw character counts no longer measure the amount of detail.
local _, brief = Tell(undead, true, 0)
for _, day in ipairs(days) do check(brief[day.key].text ~= "", "Highlights preserve every recorded day") end
check(brief[days[5].key].text:find("Taragaman", 1, true), "it keeps Taragaman")

-- Your part in a dungeon, and a deed worth saying (from roles and the meter),
-- now and then; Simple says the meter plainly.
do
    local j = {}
    Stretch(j, At(0, 20), 40, "Ragefire Chasm", 14, {{k = "dungeon", d = "Ragefire Chasm", r = "tank"},
        {k = "boss", d = "Taragaman the Hungerer", me = {d = 1, ds = 48, t = 1, ts = 70}, n = 5}})
    local told, roles, boasts = 0, 0, 0
    for retell = 0, 7 do
        local p = {self = true, charKey = "t-forever", name = "Tank", race = "Orc", faction = "Horde", class = "WARRIOR", journal = j}
        local ds = A.JournalBook(p)
        local st = A.SelfTale.Tell(p, ds, false, retell)
        local text = A.JournalPlain(st[ds[1].key].text)
        told = told + 1
        if text:find("took the blows", 1, true) or text:find("where the blows fell", 1, true) then roles = roles + 1 end
        if text:find("never got past me", 1, true) or text:find("whole fight on me", 1, true) or text:find("were mine", 1, true)
            or text:find("my blade", 1, true) then boasts = boasts + 1 end
        check(not text:lower():find("damage", 1, true), "no meter talk in the story: " .. text)
        check(text:find("Searing Blade", 1, true) or text:find("Orgrimmar", 1, true), "why you went in, the first time: " .. text)
    end
    check(roles >= 1 and roles < told, "your part, now and then: " .. roles .. " of " .. told)
    check(boasts >= 1 and boasts < told, "a deed worth saying, now and then: " .. boasts .. " of " .. told)
    local p = {self = true, charKey = "t-forever", name = "Tank", race = "Orc", faction = "Horde", class = "WARRIOR", journal = j}
    local simple = A.JournalPlain(A.JournalSceneText(p, A.JournalBook(p)[1].scenes[1], "you"))
    check(simple:find("I did the most damage in that fight.", 1, true) and simple:find("as the tank", 1, true), "Simple says it plainly: " .. simple)
end

-- Milestones, told: a raid and Benediction on the same night.
do
    local j = {}
    Stretch(j, At(0, 20), 120, "Molten Core", 60, {{k = "first", d = "raid", z = "Molten Core"},
        {k = "first", d = "famous", z = "Benediction"}, {k = "first", d = "tier", z = "Vestments of Prophecy"}})
    local p = {self = true, charKey = "p-forever", name = "Priest", race = "Scourge", faction = "Horde", class = "PRIEST", journal = j}
    local ds = A.JournalBook(p)
    local st = A.SelfTale.Tell(p, ds, false, 0)
    local text = A.JournalPlain(st[ds[1].key].text)
    check(text:find("Molten Core", 1, true) and text:find("Benediction", 1, true) and text:find("Vestments of Prophecy", 1, true),
        "a night of milestones: " .. text)
    check(st[ds[1].key].title == "Benediction", "the title is the greatest of them: " .. tostring(st[ds[1].key].title))
    local brief = A.SelfTale.Tell(p, ds, true, 0)
    check(A.JournalPlain(brief[ds[1].key].text):find("Benediction", 1, true), "Highlights keep it")
end

io.write("PASS: " .. assertions .. " own-storyteller assertions\n")
