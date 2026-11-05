-- Run from the client root: lua5.1 Interface/AddOns/CompanionJournal/tests/Starters3.lua [print [filter]]
-- Starters3 lane (overnight 2026-11-05): the remaining Forever starter-zone
-- stages, uncovered classic Horde and Alliance stages, and the rewritten first
-- Horde outcomes. Checks evidence identity, prose rules, stage boundaries and
-- renders connected days for both factions in both voices, Everything and
-- Highlights, several retells. In-memory fixtures only; never touches
-- SavedVariables. "print" writes the retell-0 chapters for reading in context.
local root = "Interface/AddOns/CompanionJournal/"
function time(t) return type(t) == "table" and os.time(t) or 1792000000 end
function date(f, t) return os.date(f, t) end
local A = {defaults = {colors = {}}}
for _, f in ipairs({"LoreData.lua", "Lore.lua", "LoreHordeStories.lua", "LoreAllianceStories.lua",
    "LoreWorldStories.lua", "LoreClassStories.lua", "LoreForeverStories.lua", "JournalBook.lua",
    "JournalTellers.lua", "JournalTale.lua", "JournalWords.lua", "JournalSelfWords.lua", "JournalSelfTale.lua"}) do
    assert(loadfile(root .. f))("CompanionJournal", A)
end
local L, checks = A.Lore, 0
local function check(ok, message) checks = checks + 1; assert(ok, message) end
local function has(s, part) return s:find(part, 1, true) ~= nil end

local stages = {
    forever_content = {97242, 97246, 97249, 97326, 95621, 95774, 97250, 97253, 98093,
        95041, 95212, 95214, 98423, 76156, 76160, 76240},
    ["horde-and-zephras"] = {4921, 857, 1153, 3301, 3513, 3514, 4737, 4739, 1130, 3369, 1359, 768, 769, 7783, 7784,
        -- rewritten first-batch outcomes (facts unchanged)
        812, 813, 870, 880, 887, 888, 891, 1492, 437, 438, 439, 443, 444, 446, 448, 442, 460, 461, 491, 440, 441, 530},
    ["alliance-starters"] = {1274, 1241, 1242, 1243, 1244, 1245, 1246, 1247, 1248, 1249, 1250, 543, 3765, 7781, 7782,
        2948, 4512, 4513, 1578, 1038, 1039, 3370, 1442, 4722, 4723, 4725, 4727, 4728, 4730, 4731, 4732, 4733},
}

-- Evidence: corpus title and level; the part1 capture for Forever giver detail.
local file = assert(io.open("StorageInvestigation/journal-voice/review/corpus_vanilla_quests.txt", "rb"))
local corpus = file:read("*a"); file:close()
local captured = {}
for title, id, level in corpus:gmatch("### ([^\r\n]+)  %(id (%d+), level (%d+)%)") do
    captured[tonumber(id)] = {title = title, level = tonumber(level)}
end
local META = {"journal", "tale", "story", "stories", "song", "songs", "verse", "record", "chronicle", "legend",
    "bard", "page", "book", "chapter", "thread"}
local PRONOUN = {i = true, me = true, my = true, mine = true, we = true, us = true, our = true, ours = true,
    you = true, your = true, yours = true}
local function prose(line, label)
    local plain = line:gsub("{%a:([^}]*)}", "%1")
    check(plain:match("[%.!]$") ~= nil, label .. " incomplete sentence: " .. line)
    check(not plain:find(":", 1, true), label .. " colon: " .. line)
    check(not plain:find("?", 1, true), label .. " question: " .. line)
    check(not plain:find(";", 1, true), label .. " semicolon: " .. line)
    check(not line:find("<", 1, true) and not line:find("$", 1, true), label .. " raw markup: " .. line)
    check(not plain:find("Not .-, but "), label .. " banned shape: " .. line)
    check(not plain:find("  ", 1, true), label .. " double space: " .. line)
    for word in line:gsub("{p:[^}]*}", ""):gsub("{%a:([^}]*)}", "%1"):lower():gmatch("%a+") do
        check(not PRONOUN[word], label .. " player pronoun '" .. word .. "': " .. line)
    end
    for _, word in ipairs(META) do
        check(not plain:lower():find("%f[%a]" .. word .. "%f[%A]"), label .. " meta word '" .. word .. "': " .. line)
    end
end
local total, words, sentences = 0, 0, 0
for packID, ids in pairs(stages) do
    for _, id in ipairs(ids) do
        total = total + 1
        local q = assert(L.questStoryIDs[id], "missing stage " .. id)
        check(q.pack == packID, "stage " .. id .. " registered by " .. tostring(q.pack) .. ", expected " .. packID)
        local c = assert(captured[id], "not in corpus " .. id)
        check(q.title == c.title and q.level == c.level, "corpus title and level " .. id)
        check(q.source and q.source[1]:find(tostring(id), 1, true), "source names the ID " .. id)
        check(L.QuestStory(q.title, id) == q, "exact lookup " .. id)
        check(q.threadLabel and q.threadLabel == L.storyThreads[q.thread], "thread label " .. id)
        check(#q.why >= 2 and q.why[1] ~= q.why[2] and #q.after >= 2 and q.after[1] ~= q.after[2], "two variants " .. id)
        if q.highlight then check(#q.highlight >= 2 and q.highlight[1] ~= q.highlight[2], "two compact variants " .. id) end
        for _, field in ipairs({"why", "after", "highlight"}) do
            for _, line in ipairs(q[field] or {}) do
                prose(line, id .. " " .. field)
                local plain = line:gsub("{%a:([^}]*)}", "%1")
                for sentence in plain:gmatch("[^%.!]+[%.!]") do
                    local n = select(2, sentence:gsub("%S+", ""))
                    if n > 0 then sentences = sentences + 1; words = words + n end
                end
            end
        end
    end
end
for _, id in ipairs(stages.forever_content) do
    check(L.questStoryIDs[id].setting == "Forever", "Forever stage labelled " .. id)
end

-- Stage boundaries: a stage tells only what its own text supports.
local function field(title, id, name) return table.concat(assert(L.QuestStory(title, id))[name or "after"], " ") end
local function all(id)
    local q = L.questStoryIDs[id]
    return table.concat(q.why, " ") .. " " .. table.concat(q.after, " ") .. " " .. table.concat(q.highlight or {}, " ")
end
for _, id in ipairs({1274, 1241, 1242, 1243, 1244, 1245, 1246, 1247, 1248, 1249}) do
    for _, leak in ipairs({"king himself", "taken the king", "king of Stormwind", "Hendel"}) do
        check(not has(all(id), leak), "diplomat stage " .. id .. " knows the later reveal: " .. leak)
    end
end
check(has(field("The Missing Diplomat", 1250), "king"), "Slim's confession keeps the king")
check(not has(field("The Missing Diplomat", nil), "king"), "title-only diplomat reveals the king")
check(not has(field("The Missing Diplomat", 999999), "king"), "unknown diplomat stage reveals the king")
check(not has(field("The Missing Diplomat", 1244), "Fist") and not has(field("The Missing Diplomat", 1244), "Dashel"),
    "Backus's papers are read by Trias, not Backus")
check(not has(all(4921), "Olgra"), "Olgra is named only in Her Name Is Olgra")
check(has(field("Her Name Is Olgra", 95774), "Olgra"), "Olgra's memorial stage keeps her name")
check(not has(table.concat(L.questStoryIDs[95621].why, " "), "deserter"), "the deserter is learned at the turn-in")
check(not has(field("The Tear of the Moons", 857):lower(), "trogg") and not has(field("The Tear of the Moons", 857):lower(), "died"),
    "Feegly's fate is not told")
check(not has(field("Mura Runetotem", 3301):lower(), "healed"), "the shell does not heal Silverpine")
check(not has(field("The Runed Scroll", 3513), "Rynthariel"), "the scroll is read in the next stage")
check(not has(field("In Search of Menara Voidrender", 4737), "Kaal"), "Zevrost's referral names no other trainer")
check(not has(field("In Search of Menara Voidrender", 4739), "Zevrost"), "Kaal's referral names no other trainer")
for _, name in ipairs({"Zevrost", "Kaal", "Briarthorn", "Demisette"}) do
    check(not has(field("In Search of Menara Voidrender", nil), name), "title-only referral chooses a trainer: " .. name)
end
for _, name in ipairs({"Hamuul", "Mathrengyl", "Thunder Bluff", "Darnassus"}) do
    check(not has(field("In Nightmares", nil), name), "title-only shard chooses a faction: " .. name)
end
for _, name in ipairs({"Thrall", "Bolvar", "Saurfang", "Afrasiabi", "Orgrimmar", "Stormwind"}) do
    check(not has(field("The Lord of Blackrock", nil), name), "title-only head chooses a capital: " .. name)
end
for _, name in ipairs({"Thundris", "Auberdine", "Forsaken"}) do
    check(not has(field("Seeking the Kor Gem", nil), name), "title-only Kor gem chooses a giver: " .. name)
end
check(has(field("Seeking the Kor Gem", 1442), "Thundris"), "Alliance Kor gem keeps Thundris")
check(not has(field("Beached Sea Turtle", nil), "naga"), "title-only turtle names the naga")
check(not has(field("Beached Sea Creature", nil), "Teldrassil"), "title-only creature takes the last finding")
check(not has(field("Stalk With The Earthmother", 76156), "pine nut"), "first test is not the salve")
check(not has(field("Stalk With The Earthmother", nil), "ambidexterity"), "title-only test chooses the last result")
check(not has(field("Meal Appeal", 97246), "sweetglaze"), "the first lunch is not Borstan's topping")
check(not has(field("A Little Slime Goes a Long Way", 4512):lower(), "pure"), "Felwood samples are not the pure ones")
check(not has(field("Velinde's Effects", 1038), "Ratchet"), "the chest does not yet point to Ratchet")
check(not has(field("Finding the Antidote", 813), "saved"), "the antidote is not yet given")
check(has(field("Need for a Cure", 812), "Rhinag"), "Rhinag's cure stage keeps him")
check(has(field("Assault on Fenris Isle", 442):lower(), "thule's death"), "assault keeps Thule's death")
check(not has(field("Rot Hide Ichor", 443), "Thule") and not has(field("Rot Hide Ichor", 443), "Bethor"), "ichor knows no maker")
check(not has(field("The Engraved Ring", 440), "Raleigh") and not has(field("The Engraved Ring", 440), "Valdred"), "Sevren names no husband")
check(not has(field("Raleigh and the Undercity", 441), "Valdred"), "Raleigh has not yet named the murderer")

-- Connected days: {race, class, faction, {zone, {ids...}}, ...}
local BASE = os.time({year = 2026, month = 9, day = 9, hour = 18})
local journeys = {
    {"Orgrimmar and the Barrens", "Orc", "WARRIOR", "Horde", {"Durotar", {812, 813}}, {"Orgrimmar", {97242, 97246, 97249, 97326}},
        {"The Barrens", {870, 880, 1492, 887, 888}}, {"The Barrens", {4921, 95774, 95621, 97253}},
        {"The Barrens", {891, 3513, 3514, 98093, 97250}}, {"The Barrens", {1153, 857, 4737}}},
    {"Thunder Bluff and the shard", "Tauren", "DRUID", "Horde", {"Mulgore", {76156, 76160, 76240}},
        {"Thunder Bluff", {768, 769}}, {"Silverpine Forest", {3301}}, {"Thunder Bluff", {1130, 3369}}},
    {"Fenris Isle and Deliah", "Scourge", "MAGE", "Horde", {"Silverpine Forest", {437, 438, 439, 443}},
        {"Undercity", {444, 1359}}, {"Silverpine Forest", {446, 448}}, {"Tirisfal Glades", {440}},
        {"Undercity", {441}}, {"Silverpine Forest", {460, 461, 442}}, {"Undercity", {491}}, {"Silverpine Forest", {530}},
        {"The Barrens", {4739}}, {"Orgrimmar", {7783, 7784}}},
    {"The missing diplomat", "Human", "ROGUE", "Alliance", {"Stormwind City", {1274, 1241, 1242}},
        {"Duskwood", {1243, 1244}}, {"Stormwind City", {1245, 1246, 1247}}, {"Wetlands", {1248, 1249, 1250}},
        {"Stormwind City", {543, 7781, 7782}}},
    {"Darkshore's beached creatures", "NightElf", "PRIEST", "Alliance", {"Darkshore", {4722, 4723, 4728}},
        {"Darkshore", {4725, 4727, 4730}}, {"Darkshore", {4731, 4732, 4733, 3765}}, {"Darnassus", {3370, 1038}},
        {"The Barrens", {1039}}},
    {"Dun Morogh and Ironforge", "Dwarf", "PALADIN", "Alliance", {"Dun Morogh", {95041, 95212, 95214}},
        {"Ironforge", {98423, 2948}}, {"Loch Modan", {1578}}, {"Darkshore", {1442}}, {"Ironforge", {4512, 4513}}},
}
local printing = arg and arg[1] == "print"
local only = arg and arg[2]
for _, j in ipairs(journeys) do
    for _, companion in ipairs({false, true}) do
        local p = {name = "Listener", race = j[2], class = j[3], faction = j[4], pronouns = "they", bond = "friend",
            startLevel = 1, charKey = "starters3-" .. j[2], journal = {}}
        if not companion then p.self = true end
        for d = 5, #j do
            local t = BASE + (d - 5) * 86400
            local first = L.questStoryIDs[j[d][2][1]]
            p.journal[#p.journal + 1] = {k = companion and "group" or "play", t = t, e = t + 7200, z = j[d][1],
                pl = first.level, ol = first.level}
            for i, id in ipairs(j[d][2]) do
                local q = L.questStoryIDs[id]
                p.journal[#p.journal + 1] = {k = "quest", t = t + i * 600, d = q.title, qid = id, z = j[d][1], pl = q.level, ol = q.level}
            end
        end
        local count = #p.journal
        for _, brief in ipairs({false, true}) do
            for retell = 0, 3 do
                p.retell = retell
                local function tell()
                    local days = A.JournalBook(p)
                    local stories = companion
                        and A.JournalTale.Tell(p, days, "we", {name = "Rowan", race = j[2], class = j[3], faction = j[4]}, brief)
                        or A.SelfTale.Tell(p, days, brief, retell)
                    local out = {}
                    for _, day in ipairs(days) do
                        if stories[day.key] and stories[day.key].text ~= "" then out[#out + 1] = A.JournalPlain(stories[day.key].text) end
                    end
                    return table.concat(out, "\n\n")
                end
                local text = tell()
                check(text == tell(), "deterministic " .. j[1])
                check(#p.journal == count, "rendering leaves history intact")
                check(not text:find("{%a+:") and not has(text, "<name>") and not has(text, "  "), "markup or spacing " .. j[1])
                for d = 5, #j do
                    for _, id in ipairs(j[d][2]) do
                        local q, found = L.questStoryIDs[id], false
                        for _, line in ipairs(q.after) do if has(text, A.JournalPlain(line)) then found = true end end
                        for _, line in ipairs(q.highlight or {}) do if has(text, A.JournalPlain(line)) then found = true end end
                        check(found, "stage " .. id .. " lost its outcome in " .. j[1] .. (brief and " Highlights" or "") .. "\n" .. text)
                    end
                end
                if printing and retell == 0 and (not only or j[1]:find(only, 1, true)) then
                    print("=== " .. j[1] .. (companion and " / COMPANION" or " / PERSONAL") .. (brief and " HIGHLIGHTS" or " EVERYTHING") .. "\n" .. text .. "\n")
                end
            end
        end
    end
end
print(("Starters3: %d checks passed; %d stages, %.1f words per sentence in their lines"):format(checks, total, words / sentences))
