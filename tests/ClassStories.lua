-- Run from the client root: lua5.1 Interface/AddOns/CompanionJournal/tests/ClassStories.lua [print]
local root = "Interface/AddOns/CompanionJournal/"
function time(t) return t and os.time(t) or 1790000000 end
function date(fmt, t) return os.date(fmt, t) end
function CreateFrame() return setmetatable({}, {__index = function() return function() end end}) end
C_Timer = {After = function() end}
local A = {defaults = {colors = {}}, db = {people = {}}}
for _, file in ipairs({"LoreData.lua", "Lore.lua", "LoreClassStories.lua", "People.lua", "Characters.lua", "Journal.lua", "JournalBook.lua", "JournalTellers.lua", "JournalTale.lua", "JournalWords.lua", "JournalSelfWords.lua", "JournalSelfTale.lua"}) do
    assert(loadfile(root .. file))("CompanionJournal", A)
end
local checks = 0
local function check(ok, why) checks = checks + 1; assert(ok, why) end
local P = A.Lore.storyPacks["class-stories"]
local file = assert(io.open("StorageInvestigation/journal-voice/review/corpus_vanilla_quests.txt", "r"))
local corpus = file:read("*a"); file:close()
local titles, repeats = {}, {}
for title, id in corpus:gmatch("### ([^\r\n]+)  %(id (%d+), level %d+%)") do
    titles[tonumber(id)] = title; repeats[title] = (repeats[title] or 0) + 1
end
local byClass, count = {}, 0
for id, entry in pairs(P.questIDs) do
    count = count + 1; byClass[entry.class] = (byClass[entry.class] or 0) + 1
    check(titles[id] == entry.title, "exact source title for " .. id)
    check(entry.source[1]:find(tostring(id), 1, true), "source ID citation")
    check(A.Lore.QuestStory(entry.title, id).after == entry.after, "precise ID outcome")
    check(A.Lore.QuestStory(entry.title, id).covers == false, "no suppression of separately recorded class milestone")
    for _, kind in ipairs({"why", "after"}) do
        check(#entry[kind] >= 2 and entry[kind][1] ~= entry[kind][2], "multiple variants " .. id .. " " .. kind)
        for _, line in ipairs(entry[kind]) do
            check(not line:find("%f[%a][Yy]ou%f[%A]") and not line:find("%f[%a][Ww]e%f[%A]"), "no narrator/player pronouns " .. id)
            check(not line:find("<") and not line:find("The summoned a ", 1, true) and not line:find("The summoned an ", 1, true), "clean authored sentence " .. id)
        end
    end
    -- A shared title's audited fallback may live in another pack (Vile Familiars: horde
    -- pack, which this suite does not load; tests/WorldOvernight2.lua checks it loaded).
    if repeats[entry.title] > 1 then
        local foreign = ({["Vile Familiars"] = "LoreHordeStories.lua", ["Encrypted Letter"] = "LoreWorldStories.lua"})[entry.title]
        if foreign then
            local f = assert(io.open(root .. foreign, "rb")); local s = f:read("*a"); f:close()
            check(s:find('Fallback("' .. entry.title .. '"', 1, true) or s:find('P.quests["' .. entry.title .. '"] = {', 1, true), "foreign fallback for " .. entry.title)
        else
            check(P.quests[entry.title].after ~= entry.after, "shared title has an audited fallback: " .. entry.title)
        end
    end
end
for _, class in ipairs({"WARRIOR", "PALADIN", "HUNTER", "ROGUE", "PRIEST", "MAGE", "WARLOCK", "DRUID"}) do
    check((byClass[class] or 0) >= 5, "representative exact stages for " .. class)
end
local function text(title, id) return table.concat(A.Lore.QuestStory(title, id).after, " "):lower() end
local function absent(title, id, phrase) check(not text(title, id):find(phrase, 1, true), "unsupported outcome " .. title .. " " .. tostring(id) .. ": " .. phrase) end
local function present(title, id, phrase) check(text(title, id):find(phrase, 1, true), "supported outcome " .. title .. " " .. tostring(id) .. ": " .. phrase) end
absent("Taming the Beast", nil, "three beasts")
absent("Taming the Beast", nil, "taught taming")
absent("Taming the Beast", 94007, "taught taming")
absent("Taming the Beast", 6061, "permanent")
present("Taming the Beast", 6088, "taught taming")
check(A.Lore.QuestStory("Taming the Beast").covers == false, "old global covers=tame is cleared")
absent("The Tome of Divinity", 1644, "resurrect")
absent("The Tome of Divinity", nil, "resurrect")
absent("The Tome of Divinity", 1781, "brought back")
present("The Tome of Divinity", 1786, "brought back")
present("The Tome of Divinity", 1788, "resurrect")
absent("A Lesson in Divinity", 94434, "redemption")
absent("A Lesson in Divinity", 94436, "restored falgan")
present("A Lesson in Divinity", 94438, "restored falgan")
present("A Lesson in Divinity", 94441, "redemption")
absent("A Lesson in Divinity", nil, "redemption")
absent("The Tome of Nobility", nil, "warhorse")
absent("Creature of the Void", nil, "taught")
absent("Gan'rul's Summons", 1506, "bound")
absent("Gakin's Summons", nil, "summoned")
present("The Binding", 65597, "incubus")
absent("The Binding", 65597, "succubus")
absent("The Binding", nil, "incubus")
absent("The Touch of Zanzil", 2608, "prepared the remedy")
present("The Touch of Zanzil", 2609, "prepared the remedy")
absent("The Touch of Zanzil", nil, "cured")
absent("Gathering the Cure", 6123, "were treated")
present("Curing the Sick", 6124, "were treated")
absent("Trial of the Sea Lion", 30, "taught the aquatic")
present("Aquatic Form", 31, "taught the aquatic")
absent("The Great Ursera Spirit", 94006, "learned the ursera")
absent("Cyclonian", 1712, "cyclonian fell")
present("The Summoning", 1713, "cyclonian fell")
check(A.Lore.QuestStory("Taming the Beast", 1788).after == A.Lore.QuestStory("Taming the Beast").after, "mismatched ID cannot confer resurrection")
for _, id in ipairs({5921, 5929, 94913, 94914}) do check(P.questIDs[id] == nil, "regional pack owns Moonglade " .. id) end
check(byClass.SHAMAN == 5, "four source-checked advanced shaman stages and the Zephras referral 92484 (2026-11-05)")
for _, id in ipairs({1516,1517,1518,1519,1520,1521,1522,1523,1524,1525,1526,1527,
    1528,1529,1530,1531,1532,1534,1535,1536,2984,2986,63,96,100,220,1103}) do
    check(P.questIDs[id] == nil, "regional pack retains early shaman trial " .. id)
end
for _, id in ipairs({8410,8411,8412,8413}) do
    check(P.questIDs[id].class == "SHAMAN" and P.questIDs[id].level == 52,
        "advanced shaman trial belongs to class pack " .. id)
end

local function snapshot(t)
    if type(t) ~= "table" then return tostring(t) end
    local keys, out = {}, {}
    for k in pairs(t) do keys[#keys + 1] = k end
    table.sort(keys, function(a, b) return tostring(a) < tostring(b) end)
    for _, k in ipairs(keys) do out[#out + 1] = tostring(k) .. "=" .. snapshot(t[k]) end
    return "{" .. table.concat(out, ",") .. "}"
end
local BASE = os.time({year = 2026, month = 9, day = 3, hour = 18})
local samples = {
    {"Human", "WARRIOR", "Alliance", "Elwynn Forest", 1638, 1713},
    {"Human", "PALADIN", "Alliance", "Elwynn Forest", 1644, 1788},
    {"Dwarf", "HUNTER", "Alliance", "Dun Morogh", 6064, 6085},
    {"Scourge", "PALADIN", "Horde", "Tirisfal Glades", 94434, 94441},
    {"Tauren", "HUNTER", "Horde", "Mulgore", 6061, 6088},
    {"SkyElf", "HUNTER", "Alliance", "Zephras Isle", 94007, 94013},
    {"Human", "ROGUE", "Alliance", "Elwynn Forest", 2205, 2359},
    {"Gnome", "MAGE", "Alliance", "Dun Morogh", 1880, 8253},
    {"NightElf", "PRIEST", "Alliance", "Teldrassil", 5622, 5621},
    {"Troll", "MAGE", "Horde", "Durotar", 1884, 8253},
    {"Orc", "WARLOCK", "Horde", "Durotar", 1506, 1504},
    {"Tauren", "DRUID", "Horde", "Mulgore", 6128, 6130},
}
for _, sample in ipairs(samples) do
    for _, companion in ipairs({false, true}) do
        for _, historical in ipairs({false, true}) do
            local p = {name = "Aster", race = sample[1], class = sample[2], faction = sample[3], pronouns = "they", bond = "friend", startLevel = 1, journal = {}}
            if not companion then p.self = true; p.charKey = sample[1] .. sample[2] end
            p.journal[1] = {k = companion and "group" or "play", t = BASE, e = BASE + 1800, z = sample[4], pl = 1, ol = 1}
            for day = 1, 2 do
                local id = sample[day + 4]; local q = P.questIDs[id]; local t = BASE + day * 86400
                p.journal[#p.journal + 1] = {k = companion and "group" or "play", t = t, e = t + 3600, z = q.zone, pl = q.level, ol = q.level}
                p.journal[#p.journal + 1] = {k = "quest", t = t + 600, d = q.title, qid = not historical and id or nil, z = q.zone, pl = q.level, ol = q.level}
            end
            local before = snapshot(p.journal)
            for _, brief in ipairs({false, true}) do
                for retell = 0, 7 do
                    p.retell = retell
                    local days = A.JournalBook(p)
                    local function tell()
                        if companion then return A.JournalTale.Tell(p, days, "we", {name = "Rowan", race = sample[1], class = sample[2], faction = sample[3]}, brief) end
                        return A.SelfTale.Tell(p, days, brief, retell)
                    end
                    local stories = tell()
                    check(snapshot(stories) == snapshot(tell()), "deterministic class telling")
                    local first = stories[days[1].key]
                    local plain = first and A.JournalPlain(first.text) or ""
                    for _, invented in ipairs({"my first foes", "my first task was", "my first hunt was", "taught me to", "learned to tame", "learned to summon", "taught the aquatic", "learned to resurrect"}) do
                        check(not plain:lower():find(invented, 1, true), "empty level-one history cannot claim " .. invented .. ": " .. plain)
                    end
                    local out = {}
                    for _, day in ipairs(days) do
                        local story = stories[day.key]
                        if story then
                            local line = A.JournalPlain(story.text)
                            check(not line:find("{p:", 1, true), "clean class prose")
                            out[#out + 1] = line
                        end
                    end
                    if arg and arg[1] == "print" and not historical and not brief and retell == 0 then
                        print(sample[1] .. " " .. sample[2] .. (companion and " companion" or " personal") .. "\n" .. table.concat(out, "\n") .. "\n")
                    end
                end
            end
            check(snapshot(p.journal) == before, "history remains unchanged")
        end
    end
end
print("ClassStories: " .. checks .. " checks; " .. count .. " exact quest IDs")
for _, class in ipairs({"WARRIOR", "PALADIN", "HUNTER", "ROGUE", "PRIEST", "MAGE", "WARLOCK", "DRUID", "SHAMAN"}) do print(class .. ": " .. byClass[class]) end
