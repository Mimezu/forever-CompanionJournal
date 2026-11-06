-- Level 20-30 zones (band2030 lane, 2026-11-06): connected journeys through
-- Ashenvale, Stonetalon, Duskwood, Wetlands, Redridge, Hillsbrad, Thousand
-- Needles, the upper Barrens and the band's dungeons, rendered as whole books in
-- both companion voices and the own voice, Everything and Highlights. Also checks
-- the writing rules on every stage the lane added or rewrote.
-- Run from the client root:
--   lua5.1 Interface/AddOns/CompanionJournal/tests/Band2030.lua [print [brief] [we|you|me]]
-- In-memory fixtures only; never reads or writes SavedVariables.
local root = "Interface/AddOns/CompanionJournal/"
function time(t) return type(t) == "table" and os.time(t) or 1792000000 end
function date(f, t) return os.date(f, t) end
local A = {defaults = {colors = {}}}
for _, f in ipairs({"LoreData.lua", "Lore.lua", "LoreHordeStories.lua", "LoreAllianceStories.lua",
    "LoreWorldStories.lua", "LoreClassStories.lua", "JournalBook.lua", "JournalTellers.lua",
    "JournalTale.lua", "JournalWords.lua", "JournalSelfWords.lua", "JournalSelfTale.lua"}) do
    assert(loadfile(root .. f))("CompanionJournal", A)
end
local checks = 0
local function check(ok, message) checks = checks + 1; assert(ok, message) end
local function has(s, part) return s:find(part, 1, true) ~= nil end

-- Journeys: faction, race, class, then days of exact quest IDs in recorded order.
local journeys = {
    -- Night elf druid: Darkshore into Ashenvale, Relara, the Zoram Strand, Stonetalon with Gaxim, Velinde's trail.
    {"Alliance", "NightElf", "DRUID", {945, 990, 1133}, {1010, 1020, 1033, 1034}, {1008, 1007, 1009}, {1025, 1054, 1016, 1017},
        {1056, 1070, 1085, 1071}, {1072, 1073, 1074, 1075, 1077}, {1079, 1080, 1091, 1082, 1081}, {1083, 1084, 1057, 1059},
        {4581, 1011, 1012, 1035}, {1022, 1037, 1038, 1039}, {1040, 1041, 1042, 1043, 1044}, {1021, 1031, 1032}},
    -- Human paladin: Duskwood's Night Watch and hermit, the Wetlands' fleet and Dun Modr, Gnomeregan.
    {"Alliance", "Human", "PALADIN", {5, 93, 240, 56}, {165, 148, 149, 154, 157}, {158, 156, 159, 133, 134}, {57, 58, 34},
        {250, 161, 274, 468, 455}, {484, 305, 306, 299, 470}, {288, 289, 290, 292, 293}, {473, 464, 465, 474},
        {303, 631, 632, 633}, {281, 284, 285, 286, 1132}, {2923, 2922, 2927, 2926, 2962}, {2931, 2930, 2925, 2924, 2928, 2904, 2951}},
    -- Orc hunter: the upper Barrens, Stonetalon from Malaka'jin to Sun Rock, Ashenvale's outposts, Thousand Needles.
    {"Horde", "Orc", "HUNTER", {907, 913, 3261, 876, 851, 852}, {858, 863, 865, 896, 898, 899}, {862, 868, 1069, 1221, 1144, 6382},
        {1061, 1062, 1063, 1064, 1065, 1066, 1067, 1086}, {6548, 6629, 6523, 6401, 6461, 6284}, {6421, 6481, 6301, 6381, 6393},
        {6282, 6283, 5881, 1087, 1088, 1089}, {6442, 6641, 216, 6462, 6621}, {6482, 6503, 6544, 6441, 6571, 6504},
        {4542, 4841, 4881, 4966, 4770, 4904, 5151}, {5062, 5088, 1361}},
    -- Undead rogue: the apothecaries' road to Tarren Mill, the Battle of Hillsbrad, the Book of Ur.
    {"Horde", "Scourge", "ROGUE", {493, 527, 528}, {529, 532, 539}, {541, 550, 1013}},
}
local source = assert(io.open("StorageInvestigation/journal-voice/review/corpus_vanilla_quests.txt", "rb"))
local corpus = source:read("*a"); source:close()
local captured = {}
for title, id, level in corpus:gmatch("### ([^\r\n]+)  %(id (%d+), level (%d+)%)") do
    captured[tonumber(id)] = {title = title, level = tonumber(level)}
end
-- Meta words as whole words (so Talen, Tarren Mill and the Ashenvale Hunt's bards' absence pass).
local META = {"journal", "journals", "chronicle", "chronicles", "legend", "legends", "tale", "tales", "song", "songs", "verse", "verses",
    "bard", "bards", "chapter", "chapters", "story", "stories", "book", "books", "page", "pages", "record", "records"}
local PHRASES = {"the assignment", "proof of work", "the official's approval", "pressure had been taken off", "the kind of day", "and that was that"}
-- Words the quest text itself uses for an object (Gurda's manual pages, Mor'rogal's legend of the Earthen).
local ALLOWED_META = {[6504] = {pages = true}, [6421] = {legend = true}}
-- Place names that happen to contain a meta word are not narration about the telling.
local PROPER = {["forest song"] = "forest shrine", ["nightsong woods"] = "nightsong wood"}
local function CheckLine(id, line)
    local low = " " .. line:lower() .. " "
    for name, plain in pairs(PROPER) do low = low:gsub(name, plain) end
    for _, word in ipairs(META) do
        if not (ALLOWED_META[id] and ALLOWED_META[id][word]) then
            check(not low:find("%f[%a]" .. word .. "%f[%A]"), id .. " uses '" .. word .. "': " .. line)
        end
    end
    for _, phrase in ipairs(PHRASES) do check(not has(low, phrase), id .. " uses '" .. phrase .. "': " .. line) end
    local plain = line:gsub("{%a:([^}]*)}", "%1")
    check(not plain:find(":", 1, true), "colon in " .. id .. ": " .. line)
    check(not line:find("?", 1, true), "question in " .. id .. ": " .. line)
    check(not line:find("%f[%a][Yy]ou%f[%A]") and not line:find("%f[%a][Ww]e%f[%A]")
        and not line:find("%f[%a]I%f[%A]") and not line:find("%f[%a][Oo]ur%f[%A]"), "player pronoun in " .. id .. ": " .. line)
end
local words, sentences, long = 0, 0, 0
local seen = {}
for _, journey in ipairs(journeys) do
    for d = 4, #journey do
        for _, id in ipairs(journey[d]) do
            local q = assert(A.Lore.questStoryIDs[id], "missing stage " .. id)
            local c = assert(captured[id], "not in corpus " .. id)
            check(q.title == c.title and q.level == c.level, "corpus title and level " .. id)
            check(q.source and q.source[1]:find(tostring(id), 1, true), "provenance " .. id)
            check(A.Lore.QuestStory(q.title, id) == q, "exact lookup " .. id)
            check(#q.why >= 2 and q.why[1] ~= q.why[2] and #q.after >= 2 and q.after[1] ~= q.after[2], "two variants " .. id)
            if not seen[id] then
                seen[id] = true
                for _, kind in ipairs({"why", "after", "highlight"}) do
                    for _, line in ipairs(q[kind] or {}) do
                        CheckLine(id, line)
                        for sentence in (line:gsub("{%a:([^}]*)}", "%1") .. " "):gmatch("[^%.]+%.%s") do
                            local n = 0
                            for _ in sentence:gmatch("%S+") do n = n + 1 end
                            if n > 0 then sentences = sentences + 1; words = words + n; if n >= 18 then long = long + 1 end end
                        end
                    end
                end
            end
        end
    end
end
local mean = words / math.max(sentences, 1)
check(mean >= 10.5 and mean <= 15, "mean sentence length in band stages: " .. mean)
check(long / math.max(sentences, 1) >= 0.12, "too few long sentences: " .. (long / math.max(sentences, 1)))

local BASE = os.time({year = 2026, month = 9, day = 7, hour = 18})
local printing = arg and arg[1] == "print"
local onlyBrief = arg and arg[2] == "brief"
local onlyVoice = arg and (arg[2] == "we" or arg[2] == "you" or arg[2] == "me") and arg[2]
    or arg and (arg[3] == "we" or arg[3] == "you" or arg[3] == "me") and arg[3] or nil
for _, journey in ipairs(journeys) do
    for _, mode in ipairs({"me", "we", "you"}) do
        local person = {name = "Aster", race = journey[2], class = journey[3], faction = journey[1], pronouns = "they",
            bond = "friend", startLevel = 1, journal = {}}
        if mode == "me" then person.self = true; person.charKey = "band2030-" .. journey[2] .. journey[3] end
        for d = 4, #journey do
            local t = BASE + (d - 4) * 86400
            local first = A.Lore.questStoryIDs[journey[d][1]]
            person.journal[#person.journal + 1] = {k = mode == "me" and "play" or "group", t = t, e = t + 7200,
                z = first.zone, pl = first.level, ol = first.level}
            for i, id in ipairs(journey[d]) do
                local q = A.Lore.questStoryIDs[id]
                person.journal[#person.journal + 1] = {k = "quest", t = t + i * 900, d = q.title, qid = id,
                    z = q.zone, pl = q.level, ol = q.level}
            end
        end
        for _, brief in ipairs({false, true}) do
            for retell = 0, 5 do
                person.retell = retell
                local days = A.JournalBook(person)
                local stories = mode == "me" and A.SelfTale.Tell(person, days, brief, retell)
                    or A.JournalTale.Tell(person, days, mode, {name = "Rowan", race = journey[2], class = journey[3], faction = journey[1]}, brief)
                local texts = {}
                for _, day in ipairs(days) do
                    local s = stories[day.key]
                    if s and s.text ~= "" then texts[#texts + 1] = A.JournalPlain(s.text) end
                end
                local joined = table.concat(texts, "\n")
                check(not has(joined, "{p:") and not has(joined, "{q:") and not has(joined, "{name}"), "unresolved markup")
                check(not joined:find(":", 1, true) or joined:find("%d:%d"), "colon in rendered chapter")
                for d = 4, #journey do
                    for _, id in ipairs(journey[d]) do
                        local q = A.Lore.questStoryIDs[id]
                        local lines = (brief and q.highlight) or q.after
                        local found = false
                        for _, line in ipairs(lines) do if has(joined, A.JournalPlain(line)) then found = true end end
                        check(found, "stage " .. id .. " lost its outcome (" .. mode .. ", " .. (brief and "brief" or "full") .. ", retell " .. retell .. ")\n" .. joined)
                    end
                end
                if printing and retell == 0 and (not onlyBrief or brief) and (not onlyVoice or mode == onlyVoice) then
                    print("== " .. journey[1] .. " " .. journey[2] .. " " .. journey[3] .. " " .. mode
                        .. (brief and " Highlights" or " Everything") .. "\n" .. table.concat(texts, "\n\n") .. "\n")
                end
            end
        end
    end
end
local count = 0
for _ in pairs(seen) do count = count + 1 end
print(string.format("Band2030: %d checks passed; %d stages, %.1f words per sentence, %d%% at 18+", checks, count, mean, math.floor(long / math.max(sentences, 1) * 100 + 0.5)))
