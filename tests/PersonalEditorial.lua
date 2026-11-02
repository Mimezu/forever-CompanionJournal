-- Source-backed scenes retain their consequences and neighboring work.
-- Run from client root: lua5.1 Interface/AddOns/CompanionJournal/tests/PersonalEditorial.lua
local root = "Interface/AddOns/CompanionJournal/"
function time(t) return t and os.time(t) or 1790000000 end
function date(fmt, t) return os.date(fmt, t) end
local A = {defaults = {colors = {}}}
for _, file in ipairs({"LoreData.lua", "Lore.lua", "LoreHordeStories.lua", "LoreAllianceStories.lua", "LoreWorldStories.lua", "LoreClassStories.lua", "JournalBook.lua", "JournalSelfWords.lua", "JournalSelfTale.lua"}) do
    assert(loadfile(root .. file))("CompanionJournal", A)
end
local checks = 0
local function check(ok, why) checks = checks + 1; assert(ok, why) end
local BASE = os.time({year = 2026, month = 9, day = 3, hour = 18})
local function person(race, class, faction, zone, ids)
    local p = {self = true, charKey = race, name = "Writer", race = race, class = class, faction = faction, startLevel = 1,
        journal = {{k = "play", t = BASE, e = BASE + 3600, z = zone, pl = 1}}}
    for n, id in ipairs(ids) do
        local q = A.Lore.questStoryIDs[id]
        p.journal[#p.journal + 1] = {k = "quest", d = q.title, qid = id, t = BASE + n * 300, z = zone, pl = q.level or 1}
    end
    return p
end
local function tell(p, brief, retell)
    local days = A.JournalBook(p)
    local stories = A.SelfTale.Tell(p, days, brief, retell)
    local texts = {}
    for _, day in ipairs(days) do if stories[day.key] then texts[#texts + 1] = A.JournalPlain(stories[day.key].text) end end
    return table.concat(texts, "\n")
end
local examples = {
    {"Tauren", "SHAMAN", "Horde", "Mulgore", 747},
    {"Human", "WARRIOR", "Alliance", "Elwynn Forest", 783},
    {"Gnome", "MAGE", "Alliance", "Dun Morogh", 233},
    {"NightElf", "DRUID", "Alliance", "Teldrassil", 456},
    {"Scourge", "WARLOCK", "Horde", "Tirisfal Glades", 363},
}
for _, sample in ipairs(examples) do
    for _, brief in ipairs({false, true}) do
        for retell = 0, 7 do
            local p = person(sample[1], sample[2], sample[3], sample[4], {sample[5]})
            local text = tell(p, brief, retell)
            local q = A.Lore.questStoryIDs[sample[5]]
            local hasOutcome = false
            for _, line in ipairs(q.after) do if text:find(A.JournalPlain(line), 1, true) then hasOutcome = true end end
            check(hasOutcome, "source outcome survives place-name repetition: " .. text)
            -- (an authored outcome carries the completed work in both editions: no quest-log title)
            check(not text:find(q.title, 1, true), "supported detail does not repeat quest-log title")
            for _, filler in ipairs({"had a part in", "work concerned", "took on work tied to"}) do check(not text:find(filler, 1, true), "no vague filler: " .. text) end
            check(text == tell(p, brief, retell), "editorial selection stays deterministic")
            local sparse = person(sample[1], sample[2], sample[3], sample[4], {})
            local sparseText = tell(sparse, brief, retell)
            check(not sparseText:find("completed", 1, true) and not sparseText:find("first foes", 1, true), "sparse opening adds no completed assignment")
        end
    end
end
-- Previously the highest-importance lore selection bypassed every other quest
-- in the stretch. Both formative work and a quieter errand must remain visible.
for _, brief in ipairs({false, true}) do
    for retell = 0, 7 do
        local p = person("Human", "WARRIOR", "Alliance", "Elwynn Forest", {783, 3904, 3905})
        local text = tell(p, brief, retell)
        for _, id in ipairs({783, 3904, 3905}) do
            local q, found = A.Lore.questStoryIDs[id], false
            for _, line in ipairs(q.after) do if text:find(A.JournalPlain(line), 1, true) then found = true end end
            check(found, "parallel early outcome retained: " .. q.title .. " in " .. text)
            -- (titles are carried by the authored outcomes in both editions; the outcome check above covers them)
        end
        check(#p.journal == 4 and p.journal[2].qid == 783 and p.journal[3].qid == 3904, "rendering does not remove or change events")
    end
end
-- Consecutive earth-rite stages must remain distinct without an extra generic
-- thread label in the completion sentence, and cannot grant a later totem.
for retell = 0, 7 do
    local p = person("Tauren", "SHAMAN", "Horde", "Mulgore", {1519})
    p.journal[#p.journal + 1] = {k = "play", t = BASE + 86400, e = BASE + 90000, z = "Mulgore", pl = 4}
    p.journal[#p.journal + 1] = {k = "quest", d = "Call of Earth", qid = 1520, t = BASE + 87000, z = "Mulgore", pl = 4}
    local text = tell(p, true, retell)
    check(not text:find("granted the earth totem", 1, true), "early stages cannot finish the totem")
    check(not text:find("{Our}", 1, true), "continuity callback resolves narrator agreement")
end
print("PersonalEditorial: " .. checks .. " checks")
