-- Scene continuity: preserve distinctive work beyond four scenes; compress repeated framing.
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
        local plain = A.JournalPlain(line)
        local at = text:find(plain, 1, true) or text:find(plain:gsub("^%u", string.lower), 1, true)
        if at then return at, A.JournalPlain(line) end
    end
end
local function outcomeAt(text, id, brief)
    local q = A.Lore.questStoryIDs[id]
    return lineAt(text, brief and q.highlight or q.after)
end
local function noSeams(text)
    check(not text:find("{%a+}"), "no unresolved tokens: " .. text)
    check(not text:find("and %.") and not text:find(",%s*,") and not text:find("  ", 1, true), "no removed-predicate seam: " .. text)
end
local Study = dofile("StorageInvestigation/storytelling-thirty-20261013/v2/study-lib.lua")
local rows = Study.materialize(dofile("StorageInvestigation/storytelling-thirty-20261013/v2/fixtures.lua"),
    Study.questCatalog("StorageInvestigation/journal-voice/review/corpus_vanilla_quests.txt"))
local function chapters(row, companion, brief, retell)
    local p = Study.clone(companion and row.sharedPerson or row.person)
    local player = Study.clone(row.person)
    if companion then
        local c = row.spec.companion
        p.name, p.race, p.class, p.faction, p.pronouns, p.bond = c.name, c.race, c.class, c.faction, c.pronouns, c.bond
        p.self, p.origin, p.retell = nil, nil, retell
        p.journal = Study.clone(row.sharedJournal)
    end
    A.SelfPerson = function() return player end
    local saved = Study.json({p, player})
    local days = A.JournalBook(p)
    local stories = companion and A.JournalTale.Tell(p, days, "we", player, brief) or A.SelfTale.Tell(p, days, brief, retell)
    check(saved == Study.json({p, player}), "render preserves raw evidence and identity")
    local out = {}
    for _, day in ipairs(days) do if stories[day.key] then out[day.key] = A.JournalPlain(stories[day.key].text) end end
    return out
end
for retell = 0, 15 do for _, brief in ipairs({false, true}) do for _, companion in ipairs({false, true}) do
    local row = rows[3]
    local out = chapters(row, companion, brief, retell)
    local stonetalon = assert(out["2024-04-09"])
    local ziz = A.Lore.questStoryIDs[1483]
    check(lineAt(stonetalon, brief and ziz.highlight or ziz.why), "fifth scene introduces Ziz and the engineer rivalry")
    check(stonetalon:find("Ziz",1,true) and stonetalon:find("Gerenzo",1,true)
        and stonetalon:find("Sputtervalve",1,true), "both editions retain the distinctive rivalry")
    check(outcomeAt(stonetalon, 1483, brief), "fifth scene retains Ziz's response")
    check(not stonetalon:find("turned in Ziz Fizziks", 1, true), "authored scene is not reduced to its title")
    local previous = 0
    for _, event in ipairs(row.person.journal) do
        if event.k == "quest" and date("%Y-%m-%d", event.t) == "2024-04-09" then
            local at = outcomeAt(stonetalon, event.qid, brief)
            check(at and at > previous, "all five authored outcomes stay in recorded order")
            previous = at
        end
    end
    check(stonetalon:find("Venture Co. Logger", 1, true), "expanding local work retains recorded death")
    if not companion then
        local mixed = out["2024-06-30"]
        local dungeon = mixed:find("Uldaman", 1, true)
        local q = A.Lore.questStoryIDs[584]
        local setup = lineAt(mixed, brief and q.highlight or q.why)
        check(mixed:find("Yenniku",1,true) and (mixed:find("cauldron",1,true) or mixed:find("broth",1,true)),
            "the shorter scene keeps the missing person and concrete investigation: " .. mixed)
        -- The place prefix can lower an initial generic article.
        if not setup then
            for _, why in ipairs(A.Lore.questStoryIDs[584].why) do
                local plain = A.JournalPlain(why):gsub("^The ", "the "):gsub("^A ", "a "):gsub("^An ", "an ")
                setup = setup or mixed:find(plain, 1, true)
            end
        end
        local place = dungeon and mixed:find("Stranglethorn", dungeon + 1, true)
        check(dungeon and setup and place and dungeon < place and place < setup,
            "personal field work has its recorded place after the earlier dungeon entry: " .. mixed)
        check(not mixed:sub(dungeon, setup):find("returned", 1, true), "field anchor does not invent return travel")
        local ashenvale = out["2024-05-05"]
        local entry = ashenvale:find("Razorfen Kraul", 1, true)
        local anchor = entry and ashenvale:find("Ashenvale", entry + 1, true)
        local result = outcomeAt(ashenvale, 23, brief)
        check(entry and anchor and result and entry < anchor and anchor < result, "Ashenvale hunt retains field location after incidental dungeon")
        check(not out["2024-07-30"]:find("Camp Mojache stood amid", 1, true), "scheduled town arrival replaces duplicate town scenery")
    end
    check(out["2024-12-21"]:find("Gehennas", 1, true) and out["2025-01-08"]:find("Shazzrah", 1, true), "raid losses remain")
    check(out["2025-02-02"]:find("Broodlord", 1, true) and out["2025-02-26"]:find("Ebonroc", 1, true), "BWL losses remain")
    if companion then
        -- Field work and an incidental dungeon need the original field anchor.
        check(out["2024-06-30"]:find("Stranglethorn", 1, true), "brief remote dungeon does not replace the field setting: " .. out["2024-06-30"])
        check(not out["2024-12-21"]:find("hours", 1, true), "routine raid timer no longer competes with the fights")
    end
    check(Study.json(out) == Study.json(chapters(row, companion, brief, retell)), "both editions and narrators remain deterministic")
end end end

-- A denser outing than the thirty saved journeys: eight distinct authored
-- stages, two unknown tasks, and a recorded death between the authored work.
for _, companion in ipairs({false, true}) do for _, brief in ipairs({false, true}) do
    local p = person(companion); p.race, p.faction, p.origin = "Human", "Alliance", nil
    local ids = {783, 7, 15, 18, 3904, 3905, 6, 47}
    local t = BASE
    p.journal = {{k = companion and "group" or "play", t = t, e = t + 7200, z = "Elwynn Forest", pl = 10, ol = 10}}
    for i, id in ipairs(ids) do
        local q = assert(A.Lore.questStoryIDs[id], "dense fixture ID")
        p.journal[#p.journal + 1] = {k = "quest", qid = id, d = q.title, t = t + i * 300, z = "Elwynn Forest", pl = 10, ol = 10}
    end
    p.journal[#p.journal + 1] = {k = "death", w = "you", d = "Recorded Stonecutter", t = t + 1350, z = "Elwynn Forest", pl = 10, ol = 10}
    p.journal[#p.journal + 1] = {k = "quest", qid = 999991, d = "Uncatalogued Supplies", t = t + 2600, z = "Elwynn Forest", pl = 10, ol = 10}
    p.journal[#p.journal + 1] = {k = "quest", qid = 999992, d = "Uncatalogued Delivery", t = t + 2700, z = "Elwynn Forest", pl = 10, ol = 10}
    local text = tell(p, brief, 0, "we")
    for _, id in ipairs(ids) do check(outcomeAt(text, id, brief), "dense authored work remains a scene: " .. id .. " " .. text) end
    local death = text:find("Recorded Stonecutter", 1, true)
    check(death and outcomeAt(text, ids[4], brief) < death and outcomeAt(text, ids[5], brief) > death,
        "dense work stays on the correct side of the recorded death")
    check(text:find("Uncatalogued", 1, true) or text:find("ten quests", 1, true), "unknown work remains named or counted")
end end
-- Durations still describe an unusually long recorded visit; the shorter
-- edition may omit hours as before. Repeated exact work is not re-authored.
local card = person(true); card.origin, card.startLevel = nil, 60
for n = 0, 1 do
    local t = BASE + n * 30 * 86400
    card.journal[#card.journal + 1] = {k = "group", t = t, e = t + (n == 0 and 4 or 7) * 3600, z = "Molten Core", pl = 60, ol = 60}
    card.journal[#card.journal + 1] = {k = "dungeon", d = "Molten Core", t = t + 10, z = "Molten Core", pl = 60, ol = 60}
    card.journal[#card.journal + 1] = {k = "wipe", d = "Gehennas", t = t + 600, z = "Molten Core", pl = 60, ol = 60}
end
local days = A.JournalBook(card)
local stories = A.JournalTale.Tell(card, days, "we", player, false)
local last = A.JournalPlain(stories[days[#days].key].text)
check(last:find("seven hours", 1, true), "exceptional recorded duration remains available: " .. last)
check(last:find("Gehennas", 1, true), "duration never replaces a recorded failure")
for _, companion in ipairs({false, true}) do
    local p = person(companion)
    outing(p, 0, "Mulgore", {1519})
    outing(p, 86400, "Mulgore", {1519})
    local text = tell(p, false, 0, "we")
    local count = 0
    for _, line in ipairs(A.Lore.questStoryIDs[1519].after) do
        local plain, at = A.JournalPlain(line), 1
        while true do
            local found = text:find(plain, at, true)
            if not found then break end
            count, at = count + 1, found + #plain
        end
    end
    check(count == 1, "repeated exact work is not expanded into the same authored scene twice")
    check(text:find("Call of Earth", 1, true), "the repeated completion remains honestly accounted")
end
-- A lone low-importance authored errand must use the same scene completion
-- path as a high-importance quest, including both voices and retells.
for retell = 0, 15 do for _, brief in ipairs({false, true}) do
    local out = chapters(rows[20], true, brief, retell)
    local text = assert(out["2024-07-30"])
    check(outcomeAt(text, 2973, brief), "Ruk's quiet cloak scene survives")
    check(not text:find("finished A New Cloak's Sheen", 1, true)
        and not text:find("completed A New Cloak's Sheen", 1, true), "quiet authored scene has no duration-branch completion receipt: " .. text)
end end
for retell = 0, 7 do for _, brief in ipairs({false, true}) do
    local p = person(false); p.startLevel, p.race, p.faction = 40, "Human", "Alliance"
    p.journal = {
        {k = "play", t = BASE, e = BASE + 7200, z = "Stranglethorn Vale", pl = 40},
        {k = "dungeon", d = "Uldaman", t = BASE + 30, z = "Uldaman", pl = 40},
        {k = "quest", d = "Uncatalogued Field Errand", qid = 999993, t = BASE + 180, z = "Stranglethorn Vale", pl = 40},
    }
    local text = tell(p, brief, retell)
    local dungeon = text:find("Uldaman", 1, true)
    local place = dungeon and text:find("Stranglethorn", dungeon + 1, true)
    local task = text:find("Uncatalogued Field Errand", 1, true)
    check(dungeon and place and task and dungeon < place and place < task, "unknown field work keeps its title and recorded place: " .. text)
    check(not text:find(", We ", 1, true), "field anchor respects sentence casing")
end end
-- Actual mixed dungeon/field chapters: common sentence leads become lowercase
-- after an explicit place prefix, while named people and factions keep capitals.
local casingRows = {}
for _, row in ipairs(rows) do casingRows[row.spec.name] = row end
local reportsSeen, fourSeen = 0, 0
for retell = 0, 15 do for _, brief in ipairs({false, true}) do
    local kessa = assert(chapters(assert(casingRows.Kessa), false, brief, retell)["2024-08-30"])
    local cera = assert(chapters(assert(casingRows.Cera), false, brief, retell)["2024-05-05"])
    check(not kessa:find("In Tanaris, Reports ", 1, true), "Reports is lowercase after a field prefix")
    check(not cera:find("In the Alterac Mountains, Four ", 1, true), "Four is lowercase after a field prefix")
    if kessa:find("In Tanaris, reports ", 1, true) then reportsSeen = reportsSeen + 1 end
    if cera:find("In the Alterac Mountains, four ", 1, true) then fourSeen = fourSeen + 1 end
end end
-- Source edits can remove a particular lead from these saved outings. Keep
-- their negative checks above, then exercise each repaired lead deliberately
-- through the real mixed dungeon/field renderer using an existing full scene.
-- Only the choice among its reviewed setup alternatives is fixed; the quest,
-- source wording, outcome and recorded location are unchanged.
for _, sample in ipairs({
    {id=62, lead="Reports", prefix="In Elwynn Forest, reports ", zone="Elwynn Forest", faction="Alliance"},
    {id=544, lead="Four", prefix="In the Alterac Mountains, four ", zone="Alterac Mountains", faction="Horde"},
}) do
    local q=assert(A.Lore.questStoryIDs[sample.id])
    local savedWhy, chosen=q.why
    for _, line in ipairs(q.why) do if line:find("^"..sample.lead.." ") then chosen=line;break end end
    check(chosen, "reviewed setup has the grammatical lead under test: "..sample.lead)
    q.why={chosen}
    for retell=0,7 do
        local p=person(false);p.startLevel,p.race,p.faction,p.origin=40,sample.faction=="Horde" and "Scourge" or "Human",sample.faction,nil
        p.journal={
            {k="play",t=BASE,e=BASE+7200,z=sample.zone,pl=40},
            {k="dungeon",d="Uldaman",t=BASE+30,z="Uldaman",pl=40},
            {k="quest",d=q.title,qid=sample.id,t=BASE+180,z=sample.zone,pl=40},
        }
        local text=tell(p,false,retell)
        check(text:find(sample.prefix,1,true), "forced reviewed lead receives lowercase field anchor: "..text)
        check(outcomeAt(text,sample.id,false), "forcing a grammatical setup preserves its authored outcome")
        check(not text:find(", "..sample.lead.." ",1,true), "forced lead must not retain sentence capitalization: "..text)
        if sample.lead=="Reports" then reportsSeen=reportsSeen+1 else fourSeen=fourSeen+1 end
    end
    q.why=savedWhy
end
check(reportsSeen > 0 and fourSeen > 0, "actual and forced retells exercise both repaired sentence leads")
local properSeen = {}
for _, row in ipairs(rows) do
    for _, text in pairs(chapters(row, false, false, 0)) do
        for _, name in ipairs({"Captain Fairmount", "Northwatch", "Blacksmith Verringtan"}) do
            local lower = name:sub(1, 1):lower() .. name:sub(2)
            check(not text:find(", " .. lower, 1, true), "proper lead retains capitalization: " .. name)
            if text:find(", " .. name, 1, true) then properSeen[name] = true end
        end
    end
end
for _, name in ipairs({"Captain Fairmount", "Northwatch", "Blacksmith Verringtan"}) do
    check(properSeen[name], "actual field prefixes exercise proper lead " .. name)
end
print("StorySceneContinuity: " .. checks .. " checks passed")
