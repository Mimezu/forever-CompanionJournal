-- Run from the client root with Lua 5.1. In-memory fixtures only.
local root = "Interface/AddOns/CompanionJournal/"
function time(t) return type(t) == "table" and os.time(t) or 1792000000 end
function date(f, t) return os.date(f, t) end
local A = {defaults = {colors = {}}}
for _, f in ipairs({"LoreData.lua", "Lore.lua", "LoreAllianceStories.lua", "LoreHordeStories.lua",
    "LoreWorldStories.lua", "LoreClassStories.lua", "JournalBook.lua", "JournalTellers.lua",
    "JournalTale.lua", "JournalWords.lua", "JournalSelfWords.lua", "JournalSelfTale.lua"}) do
    assert(loadfile(root .. f))("CompanionJournal", A)
end
local checks = 0
local function check(ok, message) checks = checks + 1; assert(ok, message) end
local ids = {
    alliance = {224,237,263,217,250,199,161,274,278,280,283,255,256,302,273,454,309,297,307,
        305,306,294,295,296,299,303,304,473,464,465,474,276,277,275,470,
        1010,1020,1033,1034,1035,1008,1007,1009,1056,1057,1059,1070,1085,1071,4761,4762,4763,4740},
    horde = {421,422,423,424,99,98298,428,429,430,425,435,437,438,439,443,444,446,448,442,
        440,441,530,264,460,461,491,452,516,493,527,528,529,532,539,541,550,
        1060,1061,1062,1063,1064,1065,1066,1067,1086,4542,4841,4881,4966,4770,4904,5064,5062,5088},
}
local source = assert(io.open("StorageInvestigation/journal-voice/review/corpus_vanilla_quests.txt", "rb"))
local corpus = source:read("*a"); source:close()
local captured = {}
for title, id, level in corpus:gmatch("### ([^\r\n]+)  %(id (%d+), level (%d+)%)") do
    captured[tonumber(id)] = {title = title, level = tonumber(level)}
end
local function entry(id) return assert(A.Lore.questStoryIDs[id], "missing quest " .. id) end
local function words(id, field) return table.concat(entry(id)[field or "after"], " "):lower() end
local function excludes(id, forbidden)
    for _, term in ipairs(forbidden) do
        check(not words(id):find(term, 1, true), id .. " borrowed a later consequence: " .. term)
    end
end
for _, list in pairs(ids) do
    for _, id in ipairs(list) do
        local q, c = entry(id), assert(captured[id])
        check(q.title == c.title and q.level == c.level, "exact source title and level: " .. id)
        check(q.source and q.source[1]:find(tostring(id), 1, true), "exact source ID: " .. id)
        check(A.Lore.QuestStory(q.title, id).after == q.after, "exact completion lookup: " .. id)
        check(A.Lore.QuestStory(q.title, 999999) == A.Lore.QuestStory(q.title), "unknown stage remains conservative: " .. id)
    end
end
-- Sampling early quest IDs must not finish the chain, even when its later
-- outcome is known in this same loaded catalog.
for _, id in ipairs({250,199,161,274,278}) do excludes(id, {"saved", "safe for", "disarmed", "fizzled"}) end
check(words(280):find("fizz", 1, true), "only treating the keg describes its reaction")
check(words(283):find("safe for the time being", 1, true), "final dam report retains limited safety")
for _, id in ipairs({224,237,263}) do excludes(id, {"grawmug", "gnasher", "brawler"}) end
check(words(237):find("had not arrived", 1, true), "reinforcements remain absent")
check(words(217):find("remaining troggs", 1, true), "leader kill does not clear the loch")
excludes(302, {"received the powder", "shipment reached"})
excludes(454, {"received the powder", "shipment reached"})
check(words(309):find("ironband received", 1, true), "escort supports powder arrival")
excludes(305, {"note reached", "tarrel learned"})
for _, id in ipairs({294,295}) do excludes(id, {"sarltooth", "final bounty"}) end
check(words(303):find("not arrived", 1, true), "Dun Modr pressure does not summon reserves")
excludes(465, {"nek'rosh's death", "chieftain was dead"})
check(words(465):find("still remained", 1, true), "catapult stage leaves leader ahead")
excludes(428, {"drank", "ivar's death", "potion reached"})
excludes(429, {"drank", "felt it working"})
check(words(430):find("drank", 1, true), "potion delivery supports Quinn's treatment")
for _, id in ipairs({422,423,424,99,98298}) do excludes(id, {"arugal was killed", "curse was cured", "curse was lifted"}) end
check(words(98298):find("search for a remedy unfinished", 1, true), "Forever study has no cure")
excludes(443, {"thule", "bethor"})
excludes(444, {"thule"})
excludes(446, {"thule's death", "thule was dead"})
excludes(448, {"thule's death", "thule was dead"})
check(words(442):find("thule's death", 1, true), "assault supports necromancer death")
excludes(440, {"raleigh recognized", "val dred", "valdred"})
excludes(441, {"valdred's death", "hands reached"})
excludes(491, {"thule's death", "thule was dead"})
check(words(452):find("ambition", 1, true), "council ambush does not claim control of Pyrewood")
for _, id in ipairs({527,528,529,532,539,541}) do excludes(id, {"varimathras received", "commendation reached"}) end
check(words(550):find("varimathras received", 1, true), "capital delivery permits recognition")
for _, id in ipairs({1010,1020,1033,1034}) do excludes(id, {"saving relara", "restored her strength", "daughter was cured"}) end
check(words(1035):find("credited", 1, true), "moonstone outcome attributed to parent")
excludes(1007, {"ring was recovered", "ruuzel"})
check(words(1057):find("still to come", 1, true), "harpy losses do not regrow forest")
check(words(1059):find("still ahead", 1, true), "druid referral does not summon forest aid")
excludes(1070, {"gaxim received", "inventions"})
check(words(4762):find("still needed confirmation", 1, true), "sample does not confirm Thundris's Felwood hypothesis")
check(words(4763):find("hope for the future", 1, true), "Blackwood battle does not permanently cleanse forest")
for _, id in ipairs({1065,1066,1067}) do excludes(id, {"poison reached the flying", "headquarters"}) end
check(words(1086):find("remained uncertain", 1, true), "toxin delivery does not prove headquarters poisoned")
excludes(4881, {"survived the attack", "defense held"})
check(words(4966):find("survived", 1, true), "actual defense protects Kanati")
excludes(5062, {"serpent was slain", "arikara's death"})
check(words(5088):find("questioned", 1, true), "Arikara outcome preserves Motega's doubt")
for _, title in ipairs({"A Dark Threat Looms", "In Defense of the King's Lands", "Ormer's Revenge", "Arugal's Folly", "Battle of Hillsbrad", "Reclaiming the Charred Vale", "On Guard in Stonetalon"}) do
    local generic = A.Lore.QuestStory(title)
    check(generic ~= nil and not generic.covers, "safe historical title: " .. title)
    local text = table.concat(generic.after, " "):lower()
    for _, term in ipairs({"safe for", "grawmug", "sarltooth", "remedy unfinished", "varimathras"}) do
        check(not text:find(term, 1, true), "historical title cannot choose final stage: " .. title)
    end
    check(A.Lore.QuestStory(title, 430).after == generic.after, "mismatched ID stays with title: " .. title)
end

local function encode(v)
    if type(v) ~= "table" then return type(v) .. ":" .. tostring(v) end
    local keys, parts = {}, {}
    for key in pairs(v) do keys[#keys + 1] = key end
    table.sort(keys, function(a,b) return tostring(a) < tostring(b) end)
    for _, key in ipairs(keys) do parts[#parts + 1] = encode(key) .. "=" .. encode(v[key]) end
    return "{" .. table.concat(parts, ";") .. "}"
end
local BASE = os.time({year = 2026, month = 10, day = 1, hour = 18})
local journeys = {
    {"Dwarf", "SHAMAN", "Alliance", {250,199,161,274,278,280,283}},
    {"Gnome", "MAGE", "Alliance", {302,273,454,309}},
    {"Human", "PALADIN", "Alliance", {305,306,294,295,296,299}},
    {"NightElf", "HUNTER", "Alliance", {473,464,465,474}},
    {"Scourge", "MAGE", "Horde", {428,429,430,425,435}},
    {"Scourge", "PRIEST", "Horde", {422,423,424,99,98298}},
    {"Orc", "WARRIOR", "Horde", {438,439,443,444,446,448,442}},
    {"Troll", "ROGUE", "Horde", {440,441,530}},
    {"Tauren", "DRUID", "Horde", {527,528,529,532,539,541,550}},
    {"NightElf", "PRIEST", "Alliance", {1010,1020,1033,1034,1035}},
    {"Gnome", "MAGE", "Alliance", {1070,1085,1071,1056,1057,1059}},
    {"Tauren", "SHAMAN", "Horde", {1061,1062,1063,1064,1065,1066,1067,1086}},
    {"Orc", "HUNTER", "Horde", {4542,4841,4881,4966,5062,5088}},
}
local function render(person, brief, retell, companion)
    local days = A.JournalBook(person)
    local tales
    if companion then
        person.retell = retell
        tales = A.JournalTale.Tell(person, days, "we", {name="Witness",race=person.race,class=person.class,faction=person.faction}, brief)
    else tales = A.SelfTale.Tell(person, days, brief, retell) end
    local out = {}
    for _, day in ipairs(days) do
        if tales[day.key] and tales[day.key].text ~= "" then out[#out + 1] = A.JournalPlain(tales[day.key].text) end
    end
    return table.concat(out, "\n\n")
end
for _, journey in ipairs(journeys) do
    for _, historical in ipairs({false,true}) do
        for _, companion in ipairs({false,true}) do
            local person = {self=not companion or nil,charKey="stage-depth",name="Listener",race=journey[1],
                class=journey[2],faction=journey[3],pronouns="they",bond="friend",startLevel=10,journal={}}
            for i, id in ipairs(journey[4]) do
                local q, t = entry(id), BASE + i * 86400
                person.journal[#person.journal+1] = {k=companion and "group" or "play",t=t,e=t+3600,z=q.zone,pl=q.level,ol=q.level}
                person.journal[#person.journal+1] = {k="quest",t=t+120,d=q.title,qid=not historical and id or nil,z=q.zone,pl=q.level,ol=q.level}
            end
            local original = encode(person.journal)
            for _, brief in ipairs({false,true}) do
                for retell=0,7 do
                    local text = render(person,brief,retell,companion)
                    check(#text > 100, "new connected journey renders")
                    check(text == render(person,brief,retell,companion), "new journey remains deterministic")
                    check(not text:find("{%a+:"), "new journey resolves markup")
                    check(encode(person.journal) == original, "new journey preserves evidence and chronology")
                    if arg and arg[1] == "print" and not historical and not companion and not brief and retell == 0 then
                        print(journey[1] .. " / " .. table.concat(journey[4], ",") .. "\n" .. text .. "\n")
                    end
                end
            end
        end
    end
end
print(("LevelingStageDepth: %d checks; %d Alliance + %d Horde new stages; %d journeys in both voices and lengths"):format(checks,#ids.alliance,#ids.horde,#journeys))
