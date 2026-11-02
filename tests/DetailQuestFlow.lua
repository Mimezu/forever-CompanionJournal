-- Full stories tell supported events through context and consequence. Quest-log
-- labels remain honest fallbacks; both editions use the supported outcome.
local root, A = "Interface/AddOns/CompanionJournal/", {defaults = {colors = {}}}
function time(t) return t and os.time(t) or 1790000000 end
function date(fmt, t) return os.date(fmt, t) end
for _, file in ipairs({"LoreData.lua", "Lore.lua", "LoreHordeStories.lua", "LoreAllianceStories.lua", "LoreWorldStories.lua", "LoreClassStories.lua",
    "JournalBook.lua", "JournalTellers.lua", "JournalTale.lua", "JournalWords.lua", "JournalSelfWords.lua", "JournalSelfTale.lua"}) do
    assert(loadfile(root .. file))("CompanionJournal", A)
end
local checks = 0
local function check(ok, why) checks = checks + 1; assert(ok, why) end
local BASE = os.time({year = 2026, month = 10, day = 3, hour = 18})
local function person(companion)
    return {self = not companion, name = companion and "Dahlia" or "Writer", charKey = "detail", race = "Tauren", class = "SHAMAN",
        faction = "Horde", startLevel = 1, pronouns = "they", bond = "spouse", origin = "together", journal = {}}
end
local function outing(p, offset, zone, ids, extra)
    local t = BASE + offset
    p.journal[#p.journal + 1] = {k = p.self and "play" or "group", t = t, e = t + 3600, z = zone, pl = 4, ol = 4}
    for i, id in ipairs(ids) do
        local q = A.Lore.questStoryIDs[id]
        p.journal[#p.journal + 1] = {k = "quest", d = q.title, qid = id, t = t + i * 300, z = zone, pl = 4, ol = 4}
    end
    if extra then
        p.journal[#p.journal + 1] = {k = "quest", d = extra, qid = 999999, t = t + 1500, z = zone, pl = 4, ol = 4}
    end
end
local player = person(false)
local function tell(p, brief, retell, voice)
    p.retell = retell
    local days = A.JournalBook(p)
    local stories = p.self and A.SelfTale.Tell(p, days, brief, retell)
        or A.JournalTale.Tell(p, days, voice or "we", player, brief)
    local out = {}
    for _, day in ipairs(days) do if stories[day.key] then out[#out + 1] = A.JournalPlain(stories[day.key].text) end end
    return table.concat(out, "\n\n")
end
local function lineAt(text, lines)
    for _, line in ipairs(lines or {}) do
        local at = text:find(A.JournalPlain(line), 1, true)
        if at then return at end
    end
end
local function outcomeAt(text, id) return lineAt(text, A.Lore.questStoryIDs[id].after) end
local function noSeams(text)
    check(not text:find("{%a+}"), "no unresolved tokens: " .. text)
    check(not text:find("and %.") and not text:find(",%s*,") and not text:find("  ", 1, true), "no removed-predicate seam: " .. text)
end
for _, companion in ipairs({false, true}) do for _, voice in ipairs({"we", "you"}) do for retell = 0, 9 do
    local p = person(companion)
    outing(p, 0, "Mulgore", {1519, 1520, 1521})
    local full, highlights = tell(p, false, retell, voice), tell(p, true, retell, voice)
    local first, second, third = outcomeAt(full, 1519), outcomeAt(full, 1520), outcomeAt(full, 1521)
    check(first and second and third and first < second and second < third, "all recorded rite stages retain chronological outcomes: " .. full)
    local setup = lineAt(full, A.Lore.questStoryIDs[1519].why)
    check(setup and setup < first, "lore establishes the purpose before quest-specific consequences: " .. full)
    check(not full:find("Call of Earth", 1, true), "detail omits redundant quest title: " .. full)
    check(not highlights:find("Call of Earth", 1, true), "Highlights omit redundant title anchors when all rite outcomes are narrated")
    for _, id in ipairs({1519, 1520, 1521}) do check(outcomeAt(highlights, id), "Highlights retain rite outcomes") end
    check(full == tell(p, false, retell, voice), "detail is deterministic")
    check(#p.journal == 4 and p.journal[2].qid == 1519 and p.journal[4].qid == 1521, "raw evidence remains intact")
    noSeams(full)

    -- Neighboring authored work keeps its specific discoveries/provisions even
    -- though its game title is no longer announced between setup and outcome.
    p = person(companion); p.race, p.class, p.faction = "Human", "WARRIOR", "Alliance"
    outing(p, 0, "Elwynn Forest", {783, 3904, 3905})
    full = tell(p, false, retell, voice)
    for _, id in ipairs({783, 3904, 3905}) do check(outcomeAt(full, id), "parallel authored work survives: " .. full) end
    noSeams(full)

    -- Nothing in the recorder identifies this errand's purpose or reward.
    p = person(companion)
    outing(p, 0, "Mulgore", {}, "An Uncatalogued Errand")
    full = tell(p, false, retell, voice)
    check(full:find("An Uncatalogued Errand", 1, true), "unknown quest retains honest title fallback: " .. full)
    check(not outcomeAt(full, 1521), "unknown quest cannot grant the earth totem")
    noSeams(full)

    p = person(companion); outing(p, 0, "Mulgore", {1519})
    full = tell(p, false, retell, voice)
    check(outcomeAt(full, 1519) and not outcomeAt(full, 1520) and not outcomeAt(full, 1521), "one recorded stage cannot finish the rite")
    p.journal[2].qid = nil
    full = tell(p, false, retell, voice)
    check(not outcomeAt(full, 1521), "historical shared title cannot supply a missing reward")
end end end

-- Changing place must retain the visit and every authored step. A later stage
-- must not appear on the earlier side of a recorded death.
for _, companion in ipairs({false, true}) do for retell = 0, 9 do
    local p = person(companion)
    outing(p, 0, "Mulgore", {1519})
    p.journal[#p.journal + 1] = {k = "death", w = "you", d = "Bristleback Quilboar", t = BASE + 900, z = "Mulgore", pl = 4, ol = 4}
    outing(p, 7200, "The Barrens", {1093})
    outing(p, 14400, "Eastern Plaguelands", {5149})
    local full = tell(p, false, retell)
    local first, nextStep, lastStep = outcomeAt(full, 1519), outcomeAt(full, 1093), outcomeAt(full, 5149)
    local death = full:find("Bristleback Quilboar", 1, true)
    check(first and nextStep and lastStep and death and first < nextStep and death < nextStep and nextStep < lastStep,
        "chronological outings retain outcomes and the intervening death: " .. full)
    if companion then check(first < death, "companion rite retains its stage before death: " .. full) end
    for _, zone in ipairs({"Mulgore", "Barrens", "Plaguelands"}) do check(full:find(zone, 1, true), "recorded place retained: " .. full) end
    noSeams(full)
end end
print("DetailQuestFlow: " .. checks .. " checks passed")
