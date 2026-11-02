-- Separate outings retain their work, including city hand-ins on a travel day.
local A, root = {defaults = {colors = {}}}, "Interface/AddOns/CompanionJournal/"
function time(t) return t and os.time(t) or 1790000000 end
function date(fmt, t) return os.date(fmt, t) end
for _, file in ipairs({"LoreData.lua", "Lore.lua", "LoreHordeStories.lua", "LoreAllianceStories.lua", "LoreWorldStories.lua", "LoreClassStories.lua",
    "JournalBook.lua", "JournalTellers.lua", "JournalTale.lua", "JournalWords.lua", "JournalSelfWords.lua", "JournalSelfTale.lua"}) do
    assert(loadfile(root .. file))("CompanionJournal", A)
end
local checks = 0
local function check(ok, why) checks = checks + 1; assert(ok, why) end
local BASE = os.time({year = 2026, month = 10, day = 3, hour = 6})
local function make(ids, race, class)
    local p = {name = "Listener", charKey = "outings", race = race or "Orc", class = class or "WARRIOR",
        faction = "Horde", startLevel = 12, pronouns = "they", bond = "friend", journal = {}}
    for i, id in ipairs(ids) do
        local s, t = A.Lore.questStoryIDs[id], BASE + (i - 1) * 7200
        p.journal[#p.journal + 1] = {k = "group", t = t, e = t + 1800, z = s.zone, pl = s.level, ol = s.level}
        p.journal[#p.journal + 1] = {k = "quest", qid = id, d = s.title, t = t + 600, z = s.zone, pl = s.level, ol = s.level}
    end
    return p
end
local function tell(p, brief, voice, retell)
    p.retell = retell
    local days = A.JournalBook(p)
    local stories = A.JournalTale.Tell(p, days, voice, {name = "Writer", race = p.race, class = p.class, faction = "Horde"}, brief)
    local out = {}
    for _, d in ipairs(days) do out[#out + 1] = A.JournalPlain(stories[d.key].text) end
    return table.concat(out, "\n\n")
end
local function outcome(text, id)
    local found, count
    count = 0
    for _, line in ipairs(A.Lore.questStoryIDs[id].after) do
        local start = 1
        while true do
            local at, last = text:find(A.JournalPlain(line), start, true)
            if not at then break end
            found, count, start = found or at, count + 1, last + 1
        end
    end
    return found, count
end
local fixtures = {
    {name = "Durotar / Orgrimmar / Barrens", ids = {830, 831, 924}},
    {name = "Tauren earth rite", ids = {1519, 1520, 1521}, race = "Tauren", class = "SHAMAN"},
    {name = "Troll earth rite", ids = {1516, 1517, 1518}, race = "Troll", class = "SHAMAN"},
    {name = "City trade", ids = {6361, 6362, 6363, 6364}, race = "Tauren", class = "HUNTER"},
}
for _, fixture in ipairs(fixtures) do
    for _, brief in ipairs({false, true}) do for _, voice in ipairs({"we", "you"}) do for retell = 0, 5 do
        local p = make(fixture.ids, fixture.race, fixture.class)
        local text, previous = tell(p, brief, voice, retell), 0
        for _, id in ipairs(fixture.ids) do
            local at, n = outcome(text, id)
            check(at and at > previous, "outings remain chronological: " .. id .. "\n" .. text)
            check(n == 1, "outcome occurs exactly once: " .. id)
            previous = at
        end
        check(tell(p, brief, voice, retell) == text, "deterministic multi-outing narrative")
        check(#p.journal == #fixture.ids * 2, "raw journal unchanged")
        check(not text:find("{%a+:"), "resolved prose")
        if arg and arg[1] == "print" and retell == 0 then print(fixture.name .. " / " .. voice .. (brief and " HIGHLIGHTS" or " FULL") .. "\n" .. text .. "\n") end
    end end end
end
-- A death between outings must remain between their consequences.
for _, brief in ipairs({false, true}) do for _, voice in ipairs({"we", "you"}) do for retell = 0, 3 do
    local p = make({1519, 1520, 1521}, "Tauren", "SHAMAN")
    p.journal[#p.journal + 1] = {k = "death", t = BASE + 1000, z = "Mulgore", d = "Bristleback Quilboar", w = "you", pl = 4}
    local text = tell(p, brief, voice, retell)
    local death = text:find("Bristleback Quilboar", 1, true)
    check(death and outcome(text, 1519) < death and outcome(text, 1520) > death, "death stays between rite stages: " .. text)
    local missing = make({1519, 1521}, "Tauren", "SHAMAN")
    check(not outcome(tell(missing, brief, voice, retell), 1520), "separate outings cannot invent missing stages")
end end end
-- An intervening dungeon and a later recorded rest bound the city hand-in.
for _, brief in ipairs({false, true}) do for _, voice in ipairs({"we", "you"}) do for retell = 0, 3 do
    local p = make({830, 831, 924})
    p.journal[#p.journal + 1] = {k = "group", t = BASE + 2200, e = BASE + 5800, z = "Ragefire Chasm", pl = 16}
    p.journal[#p.journal + 1] = {k = "dungeon", d = "Ragefire Chasm", z = "Ragefire Chasm", t = BASE + 2400, pl = 16}
    p.journal[#p.journal + 1] = {k = "boss", d = "Taragaman the Hungerer", z = "Ragefire Chasm", t = BASE + 4000, pl = 16}
    p.journal[#p.journal + 1] = {k = "rest", d = "Orgrimmar", z = "Orgrimmar", t = BASE + 8400}
    local text = tell(p, brief, voice, retell)
    local boss = text:find("Taragaman", 1, true)
    check(boss and outcome(text, 830) < boss and outcome(text, 831) > boss, "dungeon stays between reports: " .. text)
    check(outcome(text, 924) > outcome(text, 831), "later outing follows the capital")
    local rest = text:find("rested", 1, true) or text:find("took a rest", 1, true)
    check(rest and rest > outcome(text, 831) and rest < outcome(text, 924), "rest stays between capital and later outing: " .. text)
    if arg and arg[1] == "print" and retell == 0 then print("Dungeon / capital / rest / later work / " .. voice .. (brief and " HIGHLIGHTS" or " FULL") .. "\n" .. text .. "\n") end
end end end
print("CompanionOutings: " .. checks .. " checks")
