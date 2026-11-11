-- Recorded dungeon work and mixed curated/fallback chains retain their scenes.
-- Run from the client root with Lua 5.1; no saved study fixtures are modified.
local root, A = "Interface/AddOns/CompanionJournal/", {defaults = {colors = {}}}
function time(t) return type(t) == "table" and os.time(t) or 1792000000 end
function date(f, t) return os.date(f, t) end
for _, file in ipairs({"LoreData", "Lore", "LoreHordeStories", "LoreAllianceStories", "LoreWorldStories", "LoreClassStories",
    "JournalBook", "JournalTellers", "JournalTale", "JournalWords", "JournalSelfWords", "JournalSelfTale"}) do
    assert(loadfile(root .. file .. ".lua"))("CompanionJournal", A)
end
local checks, samples = 0, {}
local function check(ok, why) checks = checks + 1; assert(ok, why) end
local function snapshot(x)
    if type(x) ~= "table" then return type(x) .. ":" .. tostring(x) end
    local keys, out = {}, {}
    for k in pairs(x) do keys[#keys + 1] = k end
    table.sort(keys, function(a, b) return tostring(a) < tostring(b) end)
    for _, k in ipairs(keys) do out[#out + 1] = snapshot(k) .. "=" .. snapshot(x[k]) end
    return "{" .. table.concat(out, ";") .. "}"
end
local BASE = os.time({year = 2026, month = 1, day = 2, hour = 18})
local function input(zone, faction, ids, conflict)
    local player = {self = true, name = "Writer", charKey = "quest-scenes", race = faction == "Horde" and "Tauren" or "Human",
        class = "WARRIOR", faction = faction, startLevel = 1, journal = {}}
    local card = {name = "Companion", charKey = "quest-scenes-companion", race = player.race, class = "WARRIOR",
        faction = faction, pronouns = "they", bond = "friend", journal = {}}
    local function add(k, data, offset, personalOnly)
        local e = {k = k, z = zone, t = BASE + offset, pl = 60, ol = 60}
        for key, value in pairs(data or {}) do e[key] = value end
        player.journal[#player.journal + 1] = e
        if not personalOnly then
            local copy = {}; for key, value in pairs(e) do copy[key] = value end
            card.journal[#card.journal + 1] = copy
        end
    end
    add("play", {e = BASE + 7200}, 0, true)
    card.journal[1] = {k = "group", z = zone, t = BASE, e = BASE + 7200, pl = 60, ol = 60}
    add("with", {d = card.charKey, n = card.name, e = BASE + 7200}, 0, true)
    if zone ~= "Stranglethorn Vale" then add("dungeon", {d = zone}, 30) end
    for i, id in ipairs(ids) do
        local title = id == 900007 and "Uncatalogued Errand 900007" or (id >= 900000 and ("Uncatalogued Errand " .. id)) or assert(A.Lore.questStoryIDs[id]).title
        add("quest", {qid = id, d = title}, i * 600)
        if i == 1 and conflict then add(conflict, {d = "Recorded Cave Stalker", w = conflict == "death" and "you" or nil}, 900) end
    end
    return player, card
end
local function render(player, card, companion, brief, retell, voice)
    card.retell = retell
    A.SelfPerson = function(key) if key == player.charKey then return player end end
    local before = snapshot({player = player, card = card})
    local p = companion and card or player
    local days = A.JournalBook(p)
    local stories = companion and A.JournalTale.Tell(card, days, voice, player, brief)
        or A.SelfTale.Tell(player, days, brief, retell)
    local out = {}
    for _, day in ipairs(days) do if stories[day.key] then out[#out + 1] = A.JournalPlain(stories[day.key].text) end end
    check(before == snapshot({player = player, card = card}), "render mutated recorded journals or identities")
    return table.concat(out, "\n\n")
end
local function outcome(text, id, brief)
    local q = A.Lore.questStoryIDs[id]
    for _, line in ipairs(brief and q.highlight or q.after) do
        local at = text:find(A.JournalPlain(line), 1, true)
        if at then return at end
    end
end
-- (2026-11-07, DESIGN §3.0, rule 3: the storyteller tells the quests worth telling, so "every
-- quest present" is retired; the told ones keep their recorded order and at least one is told)
local function ordered(text, ids, brief)
    local previous, told = 0, 0
    for _, id in ipairs(ids) do
        local at
        if id >= 900000 then at = text:find("Uncatalogued Errand " .. id, 1, true)
        else local _, pos = A.QuestDeeds.ShowsAt(text, id); at = pos end
        if at then check(at >= previous, "out-of-order quest " .. id .. ": " .. text); previous, told = at, told + 1 end
    end
    check(told >= 1, "no quest told: " .. text)
end
local function toldAt(text, id) local _, at = A.QuestDeeds.ShowsAt(text, id); return at end
for _, companion in ipairs({false, true}) do for _, brief in ipairs({false, true}) do
for _, voice in ipairs({"we", "you"}) do for retell = 0, 7 do
    for _, route in ipairs({{"Alliance", "Blackrock Depths", {7848, 3802, 4123}},
        {"Horde", "Blackrock Depths", {7487, 3802, 4123}}, {"Alliance", "Dire Maul", {7441, 7488}}}) do
        local player, card = input(route[2], route[1], route[3])
        local text = render(player, card, companion, brief, retell, voice)
        ordered(text, route[3], brief)
        check(text == render(player, card, companion, brief, retell, voice), "nondeterministic dungeon work")
        check(not text:find("Ragnaros", 1, true) and not text:find("Emperor", 1, true), "entry/quests invented unrelated boss outcome: " .. text)
        check(not text:find("{%a+}") and not text:find("and %.") and not text:find(",%s*,"), "broken composition seam: " .. text)
        if not brief then
            for _, id in ipairs(route[3]) do
                for _, verb in ipairs({"completed ", "finished ", "turned in "}) do
                    check(not text:find(verb .. A.Lore.questStoryIDs[id].title, 1, true), "redundant completion title remains: " .. text)
                end
            end
        end
        if companion and not brief and voice == "we" and retell == 0 then samples[route[1] .. " " .. route[2]] = text end
    end
    -- Each conflict splits the supported quest outcomes at the recorded point.
    for _, conflict in ipairs({"death", "boss", "wipe"}) do
        local player, card = input("Blackrock Depths", "Alliance", {7848, 3802, 4123}, conflict)
        local text = render(player, card, companion, brief, retell, voice)
        ordered(text, {7848, 3802, 4123}, brief)
        local clash = text:lower():find("recorded cave stalker", 1, true) -- (a kind of foe, lowered since 2026-11-11)
        local before, after = outcome(text, 7848, brief), outcome(text, 3802, brief)
        check(clash and (not before or before < clash) and (not after or clash < after), "quest crossed a recorded " .. conflict .. ": " .. text)
    end
    -- An unknown fallback must precede its exact-ID successor, even when
    -- another conflict separates the two completions in one outing.
    if not companion then
        for _, conflict in ipairs({false, "death", "wipe"}) do
            local player, card = input("Stranglethorn Vale", "Alliance", {207, 900007, 206})
            if conflict then
                player.journal[#player.journal + 1] = {k = conflict, w = "you", d = "Recorded Jungle Stalker",
                    t = BASE + 1500, z = "Stranglethorn Vale", pl = 60, ol = 60}
            end
            local text = render(player, card, false, brief, retell, voice)
            if not brief then
                ordered(text, {207, 900007, 206}, brief)
                local clash = text:lower():find("recorded jungle stalker", 1, true)
                local fallback, last = text:find("Uncatalogued Errand 900007", 1, true), outcome(text, 206)
                if conflict then check(clash and (not fallback or fallback < clash) and (not last or clash < last), "fallback crossed conflict: " .. text) end
                samples.fallback = samples.fallback or text
            else ordered(text, {207, 900007, 206}, brief) end
        end
        local player, card = input("Stranglethorn Vale", "Alliance", {207, 900007})
        local sparse = render(player, card, false, brief, retell, voice)
        check(not outcome(sparse, 206, brief) and not sparse:find("Mai'Zoth", 1, true), "missing final quest granted later discovery")
        if not brief then
            for _, conflict in ipairs({false, true}) do
                local player, card = input("Stranglethorn Vale", "Alliance", {900001, 900002, 207, 900003, 900007, 900004, 206, 900005, 900006})
                if conflict then player.journal[#player.journal + 1] = {k = "death", w = "you", d = "Recorded Jungle Stalker",
                    t = BASE + 3300, z = "Stranglethorn Vale", pl = 60, ol = 60} end
                local text = render(player, card, false, false, retell, voice)
                -- (uncatalogued errands with nothing to say for themselves are left out now, so the
                -- fallback-group checks are retired; what is told keeps its order and its side of a death)
                ordered(text, {900001, 900002, 207, 900003, 900007, 900004, 206, 900005, 900006}, false)
                if conflict then
                    local death = text:lower():find("recorded jungle stalker", 1, true)
                    local early, late = toldAt(text, 207), toldAt(text, 206)
                    check(death and (not early or early < death) and (not late or death < late), "told work crossed a conflict: " .. text)
                end
                if not conflict then samples.fallbackGroups = samples.fallbackGroups or text end
            end
        end
    end
end end end end
print("StoryStudyQuestScenes: " .. checks .. " checks passed")
for _, key in ipairs({"Alliance Blackrock Depths", "Horde Blackrock Depths", "Alliance Dire Maul", "fallback", "fallbackGroups"}) do
    print("SAMPLE " .. key .. "\n" .. (samples[key] or ""))
end
