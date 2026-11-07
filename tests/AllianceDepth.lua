-- Alliance stages added in the 2026-11-05 overnight pass, rendered as whole
-- synthetic journeys. Run from the client root:
--   lua5.1 Interface/AddOns/CompanionJournal/tests/AllianceDepth.lua [print [brief] [we]]
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

-- Journeys: race, class, then days of exact quest IDs in recorded order.
local journeys = {
    {"Human", "PALADIN", {5261, 33}, {54, 2158, 40}, {35, 37, 45, 71}, {39, 46, 52, 59}, {83, 5545, 239, 11}, {123, 147}},
    {"Human", "WARRIOR", {109, 102, 153}, {6181, 6281, 6261, 6285}, {184, 117, 103, 152}, {136, 138, 139, 140, 104},
        {120, 121}, {143, 144}, {145, 146}},
    {"Human", "PRIEST", {244, 246, 129, 130}, {116, 118, 119, 122, 124}, {125, 127, 150, 92}, {20, 19, 115, 219},
        {91, 178, 94, 248}, {180, 128, 169}, {126, 249}},
    {"Human", "ROGUE", {163, 5, 93, 240}, {245, 226, 164, 90}, {101, 95, 230, 262, 265}, {266, 453, 268, 323},
        {174, 175, 177, 181}, {173, 221, 222, 223}, {160, 251, 401, 252, 253}},
    {"Dwarf", "HUNTER", {170, 179, 183}, {182, 233, 234, 218, 3364, 3365}, {282, 420, 2160, 400, 317}, {313, 318, 319, 320, 5541},
        {287, 315, 415, 413, 414}, {419, 417, 312, 314}},
    {"Gnome", "WARLOCK", {170, 3361}, {182, 218, 282}, {412, 433}},
    {"NightElf", "HUNTER", {456, 916, 4495, 3519}, {3521, 3522, 917, 920, 921}, {2159, 997, 918, 919, 475, 476},
        {489, 2438, 2459, 487, 922, 923}, {2498, 2499, 930, 931}, {927, 941, 937, 938, 940}, {483, 486}},
    {"NightElf", "PRIEST", {6344, 6341, 6342, 6343}, {2178, 954, 953, 984, 985}, {5713, 963, 3524, 1138, 982},
        {947, 948, 944, 949, 950}, {4762, 2138, 2139, 951}, {2098, 2078}},
    {"Dwarf", "PALADIN", {323, 269, 270, 321, 324}, {322, 325, 55}, {469, 471, 288, 289, 290, 292}, {293},
        {472, 631, 632, 633, 637}, {683, 686, 689, 700}},
    {"Human", "MAGE", {373, 389}, {392, 393, 350, 2745}, {2746, 434, 394, 395, 396}},
    {"Gnome", "ROGUE", {287, 291}, {6387, 6391, 6388, 6392}, {1339, 1338, 353, 257, 258}, {2039, 2038, 2041}},
    {"NightElf", "DRUID", {730, 729, 731, 1579, 1580}, {741, 952, 942}, {965, 966, 986, 993, 994}, {995, 943}, {1167, 1143}},
    {"Human", "PRIEST", {332, 333, 334}, {337, 343, 344, 345, 347, 346}, {399, 1097, 353}, {335, 336, 397}},
    {"Dwarf", "WARRIOR", {385, 467, 466}, {468, 455}},
    {"NightElf", "WARRIOR", {2519, 2518, 2520}},
}
local pack = A.Lore.storyPacks["alliance-starters"]
local source = assert(io.open("StorageInvestigation/journal-voice/review/corpus_vanilla_quests.txt", "rb"))
local corpus = source:read("*a"); source:close()
local captured = {}
for title, id, level in corpus:gmatch("### ([^\r\n]+)  %(id (%d+), level (%d+)%)") do
    captured[tonumber(id)] = {title = title, level = tonumber(level)}
end
local BANNED = {"journal", "chronicle", "legend", " tale", " song", " verse", " bard", "chapter", " story", " stories",
    "the assignment", "proof of work", "the official's approval", "pressure had been taken off"}
for _, journey in ipairs(journeys) do
    for d = 3, #journey do
        for _, id in ipairs(journey[d]) do
            local q = assert(A.Lore.questStoryIDs[id], "missing stage " .. id)
            local c = assert(captured[id], "not in corpus " .. id)
            check(q.title == c.title and q.level == c.level, "corpus title and level " .. id)
            check(q.source and q.source[1]:find(tostring(id), 1, true), "provenance " .. id)
            check(A.Lore.QuestStory(q.title, id) == q, "exact lookup " .. id)
            for _, kind in ipairs({"why", "after", "highlight"}) do
                for _, line in ipairs(q[kind] or {}) do
                    local low = " " .. line:lower()
                    for _, word in ipairs(BANNED) do check(not has(low, word), id .. " uses '" .. word .. "': " .. line) end
                    -- (markup such as {p:Stormwind} or {n:Bishop Farthing} is not a colon in the prose)
                    local plain = line:gsub("{%a:([^}]*)}", "%1")
                    check(not plain:find(":", 1, true) or plain:find("SI:7", 1, true), "colon in " .. id)
                    check(not line:find("?", 1, true), "question in " .. id)
                    check(not line:find("%f[%a][Yy]ou%f[%A]") and not line:find("%f[%a][Ww]e%f[%A]")
                        and not line:find("%f[%a]I%f[%A]") and not line:find("%f[%a][Oo]ur%f[%A]"), "player pronoun in " .. id .. ": " .. line)
                end
            end
            check(#q.why >= 2 and q.why[1] ~= q.why[2] and #q.after >= 2 and q.after[1] ~= q.after[2], "two variants " .. id)
        end
    end
end

local BASE = os.time({year = 2026, month = 9, day = 7, hour = 18})
local printing = arg and arg[1] == "print"
local onlyBrief = arg and arg[2] == "brief"
local onlyVoice = arg and (arg[2] == "we" or arg[3] == "we") and "we" or nil
for _, journey in ipairs(journeys) do
    for _, companion in ipairs({false, true}) do
        local person = {name = "Aster", race = journey[1], class = journey[2], faction = "Alliance", pronouns = "they",
            bond = "friend", startLevel = 1, journal = {}}
        if not companion then person.self = true; person.charKey = "alliance-depth-" .. journey[1] end
        for d = 3, #journey do
            local t = BASE + (d - 3) * 86400
            local first = A.Lore.questStoryIDs[journey[d][1]]
            person.journal[#person.journal + 1] = {k = companion and "group" or "play", t = t, e = t + 7200,
                z = first.zone, pl = first.level, ol = first.level}
            for i, id in ipairs(journey[d]) do
                local q = A.Lore.questStoryIDs[id]
                person.journal[#person.journal + 1] = {k = "quest", t = t + i * 900, d = q.title, qid = id,
                    z = q.zone, pl = q.level, ol = q.level}
            end
        end
        for _, brief in ipairs({false, true}) do
            for retell = 0, 7 do
                person.retell = retell
                local days = A.JournalBook(person)
                local stories = companion
                    and A.JournalTale.Tell(person, days, "we", {name = "Rowan", race = journey[1], class = journey[2], faction = "Alliance"}, brief)
                    or A.SelfTale.Tell(person, days, brief, retell)
                local texts = {}
                for _, day in ipairs(days) do
                    local s = stories[day.key]
                    if s and s.text ~= "" then texts[#texts + 1] = A.JournalPlain(s.text) end
                end
                local joined = table.concat(texts, "\n")
                check(not has(joined, "{p:") and not has(joined, "{q:") and not has(joined, "{name}"), "unresolved markup")
                -- Every day tells at least one of its stages in that stage's own words (DESIGN
                -- §3.0, 2026-11-07: the storyteller chooses the few worth telling; it no longer
                -- retells every stage's setup and outcome).
                -- (Highlights may leave a day of ordinary work out; the book still tells some)
                local daysTold = 0
                for d = 3, #journey do
                    local found = false
                    for _, id in ipairs(journey[d]) do if A.QuestDeeds.Shows(joined, id) then found = true end end
                    if found then daysTold = daysTold + 1 end
                    check(found or brief or companion, "day " .. d .. " told none of its stages (full, retell " .. retell .. ")\n" .. joined)
                end
                check(daysTold >= 1 or companion, "no stage told at all (" .. (brief and "brief" or "full") .. ")\n" .. joined)
                if printing and retell == 0 and (not onlyBrief or brief) and (not onlyVoice or companion) then
                    print("== " .. journey[1] .. " " .. journey[2] .. (companion and " companion" or " personal")
                        .. (brief and " Highlights" or " Everything") .. "\n" .. table.concat(texts, "\n\n") .. "\n")
                end
            end
        end
    end
end
print("AllianceDepth: " .. checks .. " checks passed")
