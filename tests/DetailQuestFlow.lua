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
-- Where a stage is told in its own words, by any of them (2026-11-07, DESIGN §3.0).
local function toldAt(text, id) local _, at = A.QuestDeeds.ShowsAt(text, id); return at end
-- The told stages of a list keep their recorded order; returns how many were told.
local function ordered(text, ids, why)
    local previous, n = 0, 0
    for _, id in ipairs(ids) do
        local at = toldAt(text, id)
        if at then check(at >= previous, why .. ": " .. text); previous, n = at, n + 1 end
    end
    return n
end
local function noSeams(text)
    check(not text:find("{%a+}"), "no unresolved tokens: " .. text)
    check(not text:find("and %.") and not text:find(",%s*,") and not text:find("  ", 1, true), "no removed-predicate seam: " .. text)
end
for _, companion in ipairs({false, true}) do for _, voice in ipairs({"we", "you"}) do for retell = 0, 9 do
    local p = person(companion)
    outing(p, 0, "Mulgore", {1519, 1520, 1521})
    local full, highlights = tell(p, false, retell, voice), tell(p, true, retell, voice)
    -- (2026-11-07: the storyteller tells the rite's stages worth telling, in order, not each
    -- stage's setup and outcome; the own book needs no title where a stage's own line tells it)
    check(ordered(full, {1519, 1520, 1521}, "told rite stages keep their order") >= 1, "the rite is told: " .. full)
    if not companion then check(not full:find("Call of Earth", 1, true), "detail omits redundant quest title: " .. full) end
    check(ordered(highlights, {1519, 1520, 1521}, "Highlights keep the order") >= 1 or highlights:find("Call of Earth", 1, true), "Highlights tell the rite: " .. highlights)
    check(full == tell(p, false, retell, voice), "detail is deterministic")
    check(#p.journal == 4 and p.journal[2].qid == 1519 and p.journal[4].qid == 1521, "raw evidence remains intact")
    noSeams(full)

    -- Neighboring authored work keeps its specific discoveries/provisions even
    -- though its game title is no longer announced between setup and outcome.
    p = person(companion); p.race, p.class, p.faction = "Human", "WARRIOR", "Alliance"
    outing(p, 0, "Elwynn Forest", {783, 3904, 3905})
    full = tell(p, false, retell, voice)
    check(ordered(full, {783, 3904, 3905}, "parallel work keeps its order") >= 1, "parallel authored work is told: " .. full)
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
    check((toldAt(full, 1519) or full:find("Call of Earth", 1, true)) and not outcomeAt(full, 1520) and not outcomeAt(full, 1521), "one recorded stage cannot finish the rite")
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
    -- (2026-11-07: each outing of the own book tells its work; the companion book its best)
    local first, nextStep, lastStep = toldAt(full, 1519), toldAt(full, 1093), toldAt(full, 5149)
    local death = full:lower():find("bristleback quilboar", 1, true)
    -- (the companion book's day line names the work done together before its scenes; order is the own book's to keep)
    check(death and companion or death and (not first or first < (nextStep or math.huge)) and (not nextStep or (death < nextStep and nextStep < (lastStep or math.huge))),
        "chronological outings keep their order and the intervening death: " .. full)
    if not companion then check(first and nextStep and lastStep, "every outing tells its work: " .. full) end

    for _, zone in ipairs({"Mulgore", "Barrens", "Plaguelands"}) do check(full:find(zone, 1, true), "recorded place retained: " .. full) end
    noSeams(full)
end end
print("DetailQuestFlow: " .. checks .. " checks passed")
