-- Full stories tell supported events through context and consequence. Quest-log
-- labels remain honest fallbacks; Highlights retain supported scenes.
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
        if at then return at, A.JournalPlain(line) end
    end
end
local function outcomeAt(text, id) return lineAt(text, A.Lore.questStoryIDs[id].after) end
-- Where a stage is told in its own words (2026-11-07, DESIGN §3.0), and the order of the told ones.
-- (by the stage's own words: a day line that only names a quest is a summary, not its moment)
local function toldAt(text, id) local _, at = A.QuestDeeds.ToldAt(text, id); return at end
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
-- Both editions keep the action in the authored consequence, without a title receipt.
for _, companion in ipairs({false, true}) do for _, voice in ipairs({"we", "you"}) do for retell = 0, 15 do
    for _, brief in ipairs({false, true}) do
        local p = person(companion)
        outing(p, 0, "Mulgore", {1519, 1520, 1521}, "An Uncatalogued Errand")
        local text = tell(p, brief, retell, voice)
        -- (the told rite stages keep their order; the own book needs no title receipt; work with no
        -- story of its own may be left out now that the storyteller chooses, DESIGN §3.0 rule 3)
        check(ordered(text, {1519, 1520, 1521}, "recorded rite stages remain ordered") >= 1 or text:find("Call of Earth", 1, true), "the rite is told: " .. text)
        if not companion then check(not text:find("Call of Earth", 1, true), "authored stages need no completion receipt: " .. text) end
        check(text == tell(p, brief, retell, voice), "both editions remain deterministic")
        noSeams(text)
        p = person(companion)
        outing(p, 0, "Mulgore", {1519})
        text = tell(p, brief, retell, voice)
        check((toldAt(text, 1519) or text:find("Call of Earth", 1, true)) and not outcomeAt(text, 1520) and not outcomeAt(text, 1521), "one stage cannot resolve the rite")
        p.journal[2].qid = nil
        text = tell(p, brief, retell, voice)
        check(not outcomeAt(text, 1521), "shared historical title cannot grant a totem")
        -- The fourth local scene used to be displaced by the three-slot limit.
        p = person(companion); p.race, p.class = "Tauren", "HUNTER"
        outing(p, 0, "The Barrens", {845, 901, 899, 870})
        text = tell(p, brief, retell, voice)
        check(ordered(text, {845, 901, 899, 870}, "local work keeps its order") >= 1, "local work is told: " .. text)
        noSeams(text)
        -- Food and a neighbor's recipe remain complete scenes.
        p = person(companion); p.race, p.faction = "Human", "Alliance"
        outing(p, 0, "Westfall", {22, 36})
        text = tell(p, brief, retell, voice)
        -- (a told scene keeps setup and consequence together when it has both; setups are rarely told now)
        for _, id in ipairs({22, 36}) do
            local setup, setupLine = lineAt(text, A.Lore.questStoryIDs[id].why)
            local result = outcomeAt(text, id)
            if setup and result then check(not text:sub(setup + #setupLine, result - 1):find("%S"), "duration/count cannot split setup from consequence: " .. text) end
        end
        check(ordered(text, {22, 36}, "quiet scenes keep their order") >= 1, "a quiet local scene is told: " .. text)
        -- (the companion book's day line names the work done together, 2026-11-07)
        if not companion then check(not text:find("Goretusk Liver Pie", 1, true) and not text:find("Westfall Stew", 1, true), "quiet scenes need no title receipt") end
    end
end end end
-- Exercise the original reported seams against the immutable saved journeys.
local studyRoot = "StorageInvestigation/storytelling-thirty-20261013/v2/"
local Study = dofile(studyRoot .. "study-lib.lua")
local fixtures = dofile(studyRoot .. "fixtures.lua")
local rows = Study.materialize(fixtures, Study.questCatalog("StorageInvestigation/journal-voice/review/corpus_vanilla_quests.txt"))
local function personalChapters(row, brief, retell)
    local p = Study.clone(row.person)
    local days = A.JournalBook(p)
    check(#days > 0, "saved journey has chapters")
    return A.SelfTale.Tell(p, days, brief, retell), days
end
for retell = 0, 15 do for _, brief in ipairs({false, true}) do
    local stories, days = personalChapters(rows[1], brief, retell)
    for _, day in ipairs(days) do
        local story = stories[day.key]
        if story then
            local text = A.JournalPlain(story.text)
            check(not (story.title or ""):find("Once More", 1, true), "reused titles prefer the recorded setting")
            check(not text:find("in Duskwood again", 1, true), "familiar company does not imply prior Duskwood visit")
            if day.key == "2024-01-30" then
                check(not text:find("Mira was with me", 1, true), "joint opener needs no duplicate companion announcement")
                check(not text:find("Mira kept me company", 1, true), "joint opener needs no duplicate company")
            end
        end
    end
    stories, days = personalChapters(rows[2], brief, retell)
    for _, day in ipairs(days) do
        local story = stories[day.key]
        if story and day.key == "2024-12-01" then
            local text = A.JournalPlain(story.text)
            check(not text:find("We made for Dire Maul", 1, true) and not text:find("We set out for Dire Maul", 1, true),
                "reunion in dungeon already establishes the visit: " .. text)
        end
    end
end end
for retell = 0, 15 do for _, brief in ipairs({false, true}) do
    local p = person(true); p.race, p.faction = "Human", "Alliance"
    outing(p, 0, "Westfall", {22}, "An Uncatalogued Errand")
    outing(p, 7200, "Elwynn Forest", {783, 3904, 3905})
    local text = tell(p, brief, retell, "we")
    -- (2026-11-07: the companion book no longer splits the day into authored scenes per place, so
    -- the Westfall scene's own count is retired; the day's work is still told, by name, count or deed;
    -- 2026-11-07: a day told by its deeds counts no quests)
    check(text:find("Goretusk Liver Pie", 1, true) or text:find(" quests", 1, true) or A.QuestDeeds.Shows(text, 22) or A.QuestDeeds.Shows(text, 783)
        or A.QuestDeeds.Shows(text, 3904) or A.QuestDeeds.Shows(text, 3905), "the day's work is told: " .. text)
end end
-- A first selected setup is required narrative, even when a town's name
-- already appeared twice in the opener and arrival.
for retell = 0, 15 do for _, brief in ipairs({false, true}) do
    local stories, days = personalChapters(rows[3], brief, retell)
    local found = false
    for _, day in ipairs(days) do
        if day.key == "2024-07-30" and stories[day.key] then
            found = true
            local text = A.JournalPlain(stories[day.key].text)
            local setup, setupLine = lineAt(text, A.Lore.questStoryIDs[2973].why)
            local result = outcomeAt(text, 2973)
            -- (2026-11-07, DESIGN §3.0: setups are no longer required; the chapter tells its chosen
            -- stages, and a setup that is told still sits right before its consequence)
            if setup and result then
                check(setup < result and not text:sub(setup + #setupLine, result - 1):find("%S"), "crowded town names cannot separate cloak setup and outcome")
            end
            check(#text > 0, "the Feralas chapter is told: " .. text)
        end
    end
    check(found, "the reported Gromm chapter is exercised")
end end
-- A point-of-view line led by a place has its first word lowercased ("In Teldrassil, a hard
-- lesson..."); QD.Shows still knows the stage by that line (2026-11-07).
do
    local QD = A.QuestDeeds
    local line = QD.Story({qid = 456, title = A.Lore.questStoryIDs[456].title}).pov[2]
    check(line and line:find("^A hard lesson"), "fixture pov line: " .. tostring(line))
    local led = "In Teldrassil, " .. QD.Fill(line, {We = "I", we = "I", us = "me", our = "my", Our = "My"}):gsub("^%u", string.lower)
    check(QD.Shows(led, 456) == "pov", "a place-led pov line is still that stage's: " .. led)
    check(QD.Shows("We saw The Balance of Nature through.", 456) == "title", "a title still shows as written")
    check(not QD.Shows("We saw the balance of nature through.", 456), "a title is matched only as written")
end
-- Milestone wording distinguishes accumulated shared days from elapsed gaps.
local card = person(true); card.origin = nil
for day = 0, 9 do outing(card, day * 30 * 86400, "Westfall", {}) end
local days = A.JournalBook(card)
local stories = A.JournalTale.Tell(card, days, "we", player, false)
local tenth = stories[days[10].key]
check(tenth and tenth.title and tenth.title:find("Ten Days Together", 1, true), "tenth shared-day title explains its count despite monthly intervals")
print("StoryCraftEngine: " .. checks .. " checks passed")
