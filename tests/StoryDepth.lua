-- Connected stages are scenes, not a list beneath one randomly chosen quest.
local root, A = "Interface/AddOns/CompanionJournal/", {defaults = {colors = {}}}
function time(t) return t and os.time(t) or 1790000000 end
function date(fmt, t) return os.date(fmt, t) end
for _, file in ipairs({"LoreData.lua", "Lore.lua", "LoreHordeStories.lua", "LoreAllianceStories.lua", "LoreWorldStories.lua", "LoreClassStories.lua",
    "JournalBook.lua", "JournalTellers.lua", "JournalTale.lua", "JournalWords.lua", "JournalSelfWords.lua", "JournalSelfTale.lua"}) do
    assert(loadfile(root .. file))("CompanionJournal", A)
end
local checks, samples = 0, {"CONNECTED STORY DEPTH - GENERATED EXAMPLES"}
local function check(ok, why) checks = checks + 1; assert(ok, why) end
local BASE = os.time({year = 2026, month = 10, day = 3, hour = 18})
local function make(ids, companion)
    local p = {self = not companion, name = companion and "Dahlia" or "Nara", charKey = "depth", race = "Tauren", class = "SHAMAN",
        faction = "Horde", startLevel = 1, pronouns = "they", bond = "spouse", origin = "together", journal = {}}
    p.journal[1] = {k = companion and "group" or "play", t = BASE, e = BASE + 3600, z = "Mulgore", pl = 4, ol = 4}
    for i, id in ipairs(ids) do
        p.journal[#p.journal + 1] = {k = "quest", d = A.Lore.questStoryIDs[id].title, qid = id, t = BASE + i * 300, z = "Mulgore", pl = 4, ol = 4}
    end
    return p
end
local player = make({}, false)
local function tell(p, brief, retell, voice)
    local days = A.JournalBook(p)
    p.retell = retell
    local stories = p.self and A.SelfTale.Tell(p, days, brief, retell) or A.JournalTale.Tell(p, days, voice or "we", player, brief)
    local out = {}
    for _, day in ipairs(days) do if stories[day.key] then out[#out + 1] = A.JournalPlain(stories[day.key].text) end end
    return table.concat(out, "\n\n")
end
local function outcomeAt(text, id)
    -- (the full outcome, or the compact scene Highlights may use for an exact stage)
    local story = A.Lore.questStoryIDs[id]
    for _, list in ipairs({story.after, story.highlight or {}}) do
        for _, line in ipairs(list) do
            local at = text:find(A.JournalPlain(line), 1, true)
            if at then return at end
        end
    end
end
-- A single outing can contain several quests with exactly the same name.
for _, companion in ipairs({false, true}) do
    for _, brief in ipairs({false, true}) do
        for _, voice in ipairs({"we", "you"}) do
            for retell = 0, 9 do
                local p = make({1519, 1520, 1521}, companion)
                local text = tell(p, brief, retell, voice)
                local first, second, third = outcomeAt(text, 1519), outcomeAt(text, 1520), outcomeAt(text, 1521)
                check(first and second and third, "three recorded earth-rite stages survive: " .. text)
                check(first < second and second < third, "rite remains chronological: " .. text)
                check(text == tell(p, brief, retell, voice), "deterministic connected narrative")
                check(#p.journal == 4 and p.journal[2].qid == 1519 and p.journal[4].qid == 1521, "raw evidence unchanged")
                check(not text:find("{%a+}"), "no unresolved tokens")
                if companion then check(not text:find("wife", 1, true) and not text:find("husband", 1, true), "neutral spouse respected") end
                if retell == 0 and voice == "we" then samples[#samples + 1] = "\n" .. (companion and "COMPANION" or "PERSONAL") .. (brief and " HIGHLIGHTS" or " FULL") .. "\n" .. text end
            end
        end
    end
end
-- Selected and missing evidence remain distinct, including old title-only records.
for _, companion in ipairs({false, true}) do for _, brief in ipairs({false, true}) do
    for _, ids in ipairs({{1519}, {1519, 1520}}) do for retell = 0, 7 do
        local p = make(ids, companion)
        local text = tell(p, brief, retell)
        check(not outcomeAt(text, 1521), "missing final stage cannot award a totem")
        if #ids == 1 then check(not outcomeAt(text, 1520), "missing meeting cannot be supplied") end
        for _, entry in ipairs(p.journal) do entry.qid = nil end
        text = tell(p, brief, retell)
        check(not outcomeAt(text, 1521), "ambiguous historical title cannot award totem")
    end end
end end
-- Selection preserves caller order/data, ranks meaning, deduplicates repeated
-- stages, and returns the selected events in timestamp order.
local quests = {{title = "Call of Earth", qid = 1521, t = 300}, {title = "Call of Earth", qid = 1519, t = 100},
    {title = "Call of Earth", qid = 1520, t = 200}, {title = "Call of Earth", qid = 1519, t = 400}}
local plan = A.Lore.QuestBeats(quests, {}, 3)
check(#plan == 3 and plan[1].quest.qid == 1519 and plan[3].quest.qid == 1521, "chronological exact stages and duplicate suppression")
check(quests[1].qid == 1521 and #quests == 4, "selection never sorts or removes source events")
check(#A.Lore.QuestBeats(quests, {[1519] = true, [1520] = true}, 3) == 1, "already narrated stages omitted")
plan = A.Lore.QuestBeats(quests, {}, 3, function(q) return q.qid == 1521 end)
check(#plan == 2 and plan[2].quest.qid == 1520, "scene/revenge exclusions respected")
local deliveries = {}
for i, id in ipairs({6361, 6362, 6363, 6364}) do
    deliveries[#deliveries + 1] = {qid = id, title = A.Lore.questStoryIDs[id].title, t = i * 100}
end
plan = A.Lore.QuestBeats(deliveries, {}, 3)
check(#plan == 3 and plan[1].quest.qid == 6361 and plan[3].quest.qid == 6364, "delivery resolution survives intermediate referral")
for _, brief in ipairs({false, true}) do for retell = 0, 7 do
    local p = make({1519, 1520, 1521}, true)
    p.journal[3].t, p.journal[4].t = BASE + 1200, BASE + 1800
    p.journal[#p.journal + 1] = {k = "death", w = "you", d = "Bristleback Quilboar", t = BASE + 900, z = "Mulgore", pl = 4}
    local text = tell(p, brief, retell)
    local a, b, c = outcomeAt(text, 1519), outcomeAt(text, 1520), outcomeAt(text, 1521)
    local death = text:find("Bristleback Quilboar", 1, true)
    check(a and b and c and death, "interrupted rite retains every recorded stage and death: " .. text)
    check(a < death and death < b and b < c, "rite stages remain on their recorded side of death: " .. text)
end end
-- Three separate places in one day used to hit the personal two-scene cap.
local p = make({1519}, false)
for i, id in ipairs({1093, 5149}) do
    local q, t = A.Lore.questStoryIDs[id], BASE + i * 7200
    p.journal[#p.journal + 1] = {k = "play", t = t, e = t + 1800, z = q.zone, pl = q.level}
    p.journal[#p.journal + 1] = {k = "quest", d = q.title, qid = id, t = t + 600, z = q.zone, pl = q.level}
end
for _, brief in ipairs({false, true}) do
    local text = tell(p, brief, 0)
    for _, id in ipairs({1519, 1093, 5149}) do check(outcomeAt(text, id), "third source-backed scene survives daily cap") end
end
local file = assert(io.open("StorageInvestigation/cj-story-ui-checks/connected-story-depth.txt", "w"))
file:write(table.concat(samples, "\n")); file:close()
print("StoryDepth: " .. checks .. " checks; generated examples in connected-story-depth.txt")
