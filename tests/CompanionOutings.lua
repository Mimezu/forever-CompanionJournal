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
-- Where a stage is told (2026-11-07, DESIGN §3.0): the companion book tells the pair's day,
-- by the stage's own point of view, act or name, no longer by its authored outcome prose.
local function outcome(text, id)
    local found, count
    count = 0
    local s = A.Lore.questStoryIDs[id]
    -- (a title several stages share does not say which stage was told)
    local shared = 0
    for _, other in pairs(A.Lore.questStoryIDs) do if other.title == s.title then shared = shared + 1 end end
    local marks = shared == 1 and {s.title} or {}
    for _, line in ipairs(s.after) do marks[#marks + 1] = A.JournalPlain(line) end
    for _, line in ipairs(marks) do
        local start = 1
        while true do
            local at, last = text:find(A.JournalPlain(line), start, true)
            if not at then break end
            found, count, start = found or at, count + 1, last + 1
        end
    end
    return found, count
end
-- A stage's own authored outcome prose, where it appears.
local function prose(text, id)
    local found
    for _, line in ipairs(A.Lore.questStoryIDs[id].after) do
        local at = text:find(A.JournalPlain(line), 1, true)
        if at and (not found or at < found) then found = at end
    end
    return found
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
        -- (the stages told keep the recorded order; the outings tell at least one of them)
        local toldAny = false
        for _, id in ipairs(fixture.ids) do
            local at = outcome(text, id)
            if at then
                check(at >= previous, "outings remain chronological: " .. id .. "\n" .. text)
                previous, toldAny = at, true
            end
        end
        for _, id in ipairs(fixture.ids) do if text:find(A.Lore.questStoryIDs[id].title, 1, true) then toldAny = true end end
        check(toldAny, "the outings tell some of their work\n" .. text)
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
    -- (2026-11-07: a stage's authored outcome, when a book tells one, stays on its own side of
    -- the death; the companion book tells the rite by name or point of view, not by that prose)
    check(death, "the death is told: " .. text)
    local before, after = prose(text, 1519), prose(text, 1520)
    check((not before or before < death) and (not after or after > death), "death stays between rite stages: " .. text)
    local missing = make({1519, 1521}, "Tauren", "SHAMAN")
    check(not prose(tell(missing, brief, voice, retell), 1520), "separate outings cannot invent missing stages")
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
    -- (2026-11-07: the stages the book tells stay on their recorded side of the dungeon and the rest)
    local a, b, c = outcome(text, 830), outcome(text, 831), outcome(text, 924)
    check(boss and (not a or a < boss) and (not b or b > boss) and (not c or c > boss), "dungeon stays between reports: " .. text)
    check(not (b and c) or c > b, "later outing follows the capital")
    local rest = text:find("rested", 1, true) or text:find("took a rest", 1, true)
    check(rest and (not b or rest > b) and (not c or rest < c or rest > boss), "rest stays after the dungeon: " .. text)
    if arg and arg[1] == "print" and retell == 0 then print("Dungeon / capital / rest / later work / " .. voice .. (brief and " HIGHLIGHTS" or " FULL") .. "\n" .. text .. "\n") end
end end end
print("CompanionOutings: " .. checks .. " checks")
