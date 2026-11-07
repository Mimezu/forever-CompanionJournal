-- Run from the client root: lua5.1 Interface/AddOns/CompanionJournal/tests/PlaceLead.lua [print]
-- "In <place>, " in front of an outcome when the work moved (both storytellers): the first word
-- goes to lower case unless it is a name ("In the Barrens, Whatever Sputtervalve..." kept its
-- capital), and an outcome that opens on speech ("Finally, said Lydon, ...") takes no prefix;
-- the place is said on its own in front instead (2026-11-06, finish-engine lane).
-- Synthetic offline test; it never loads or writes SavedVariables.
local root = "Interface/AddOns/CompanionJournal/"
local assertions = 0
local function check(value, message) assertions = assertions + 1; assert(value, message) end
local show = arg and arg[1] == "print"

function time(t) if type(t) == "table" then return os.time(t) end return 1790000000 + 40 * 86400 end
function date(fmt, t) return os.date(fmt, t) end
function CreateFrame() return setmetatable({}, {__index = function() return function() end end}) end
C_Timer = {After = function() end}
LOCALIZED_CLASS_NAMES_MALE = {WARRIOR = "Warrior", PRIEST = "Priest", SHAMAN = "Shaman", MAGE = "Mage", WARLOCK = "Warlock", HUNTER = "Hunter", ROGUE = "Rogue", PALADIN = "Paladin"}
local A = {defaults = {colors = {}}}
for _, file in ipairs({"LoreData.lua", "Lore.lua", "LoreHordeStories.lua", "LoreAllianceStories.lua", "LoreWorldStories.lua", "LoreClassStories.lua",
    "People.lua", "Characters.lua", "Journal.lua", "JournalBook.lua", "JournalTellers.lua", "JournalTale.lua", "JournalWords.lua",
    "JournalSelfWords.lua", "JournalSelfTale.lua"}) do
    assert(loadfile(root .. file))("CompanionJournal", A)
end
A.db = {people = {}}
A.SelfPerson = function() return nil end
local T = A.JournalTale

-- 1. The rule itself ----------------------------------------------------------------------
do
    local Lead = A.JournalPlaceLead
    check(Lead("the Barrens", "Whatever Sputtervalve wanted, he had.") == "In the Barrens, whatever Sputtervalve wanted, he had.", "a common word goes to lower case")
    check(Lead("the Barrens", "The ring was Deliah's.") == "In the Barrens, the ring was Deliah's.", "an article goes to lower case")
    check(Lead("the Barrens", "Sputtervalve had his samophlange.") == "In the Barrens, Sputtervalve had his samophlange.", "a name keeps its capital")
    check(Lead("the Barrens", "Mebok Mizzyrix had his essence.") == "In the Barrens, Mebok Mizzyrix had his essence.", "a full name keeps its capitals")
    check(Lead("the Barrens", "I had the essence.") == "In the Barrens, I had the essence.", "'I' keeps its capital")
    check(Lead("the Barrens", "You turned in the essence.") == "In the Barrens, you turned in the essence.", "'You' goes to lower case")
    check(Lead("the Barrens", "Maps lay in the crate.", "The crate held maps and a pendant.") == "In the Barrens, maps lay in the crate.",
        "a word the scene also uses in lower case is a common word")
    check(Lead("the Barrens", "Finally, said Lydon, the work was done.") == nil, "speech after the first word takes no prefix")
    check(Lead("the Barrens", "Well done, said Kryten.") == nil, "'Well done, said' takes no prefix")
    check(Lead("the Barrens", "Incredible, Kryten said, and he could see why.") == nil, "'X, Name said' takes no prefix")
    check(Lead("the Barrens", "\"Well done,\" Kryten said.") == nil, "a quoted line takes no prefix")
    check(Lead("the Barrens", "Sevren confirmed the name.") ~= nil, "an ordinary line is prefixed")
    check(Lead("the Barrens", "Captain Fairmount and her cannoneers shot at anything in sight, Thalo'thas Brightsun said.")
        == "In the Barrens, Captain Fairmount and her cannoneers shot at anything in sight, Thalo'thas Brightsun said.",
        "a report with its speaker at the end is a sentence, and its name keeps the capital")
end

-- 2. Through the companion teller: a day in two zones, the second outcome replaced ---------
local BASE = os.time({year = 2026, month = 9, day = 1, hour = 0})
local function At(day, hour) return BASE + day * 86400 + math.floor((hour or 20) * 3600) end
local PLAYER = {name = "Alberich", race = "Scourge", faction = "Horde", class = "PALADIN", charKey = "alb"}
local ids = {}
for id in pairs(A.Lore.questStoryIDs) do ids[#ids + 1] = id end
table.sort(ids)
local first, second
for _, id in ipairs(ids) do
    local s = A.Lore.questStoryIDs[id]
    if s.zone and s.why and s.after and not T.PlaceLed(s.after[1]) then
        if not first then first = id
        elseif not second and s.zone ~= A.Lore.questStoryIDs[first].zone then second = id end
    end
end
check(first and second, "two exact stages in different zones exist")
local o, s = A.Lore.questStoryIDs[first], A.Lore.questStoryIDs[second]
local savedAfter, savedMore, savedHighlight = s.after, s.afterMore, s.highlight
local function Companion(after)
    s.after, s.afterMore, s.highlight = {after}, nil, nil
    local p = {name = "Dahlia-Forever", race = "Scourge", class = "PRIEST", pronouns = "she", journal = {}, key = "dahlia"}
    local t = At(0)
    p.journal[#p.journal + 1] = {k = "group", t = t, e = t + 5400, z = o.zone, pl = 20, ol = 20}
    p.journal[#p.journal + 1] = {k = "quest", d = o.title, qid = first, t = t + 1200, z = o.zone, pl = 20, ol = 20}
    p.journal[#p.journal + 1] = {k = "group", t = t + 6000, e = t + 7800, z = s.zone, pl = 20, ol = 20}
    p.journal[#p.journal + 1] = {k = "quest", d = s.title, qid = second, t = t + 6600, z = s.zone, pl = 20, ol = 20}
    local texts = {}
    for _, voice in ipairs({"we", "you"}) do
        for retell = 0, 3 do
            p.retell = retell
            local days = A.JournalBook(p)
            local stories = A.JournalTale.Tell(p, days, voice, PLAYER, false)
            local text = A.JournalPlain(stories[days[1].key].text)
            if show and retell == 0 then print("[" .. voice .. "] " .. text .. "\n") end
            texts[#texts + 1] = text
        end
    end
    return texts
end
for _, text in ipairs(Companion("Whatever Sputtervalve had wanted, he had it now.")) do
    check(not text:find(", Whatever Sputtervalve", 1, true), "no capital after the place prefix: " .. text)
    -- (2026-11-07, DESIGN §3.0: the companion book tells the second outing's stage by its name,
    -- act or point of view, not by its authored outcome, and says where it was)
    check(A.QuestDeeds.Shows(text, second), "the second outing is told: " .. text)
end
for _, text in ipairs(Companion("Finally, said Lydon, the work was done.")) do
    check(not text:find("[Ii]n [^%.]-, Finally, said") and not text:find("[Ii]n [^%.]-, finally, said"), "no place in front of speech: " .. text)
    check(A.QuestDeeds.Shows(text, second), "the second outing is told: " .. text)
end
s.after, s.afterMore, s.highlight = savedAfter, savedMore, savedHighlight

-- 3. Through your own teller: a dungeon, then work in another zone -------------------------
do
    local dungeonZone = "Shadowfang Keep"
    local function Own(after)
        s.after, s.afterMore, s.highlight = {after}, nil, nil
        local me = {self = true, charKey = "alb", name = "Alberich", race = "Scourge", faction = "Horde", class = "PALADIN", startLevel = 1, journal = {}}
        local t = At(3)
        me.journal = {
            {k = "play", t = t, e = t + 3600, z = dungeonZone, pl = 20},
            {k = "dungeon", d = dungeonZone, z = dungeonZone, t = t + 60, pl = 20},
            {k = "boss", d = "Archmage Arugal", z = dungeonZone, t = t + 1800, pl = 20},
            {k = "play", t = t + 3700, e = t + 7200, z = s.zone, pl = 20},
            {k = "quest", d = s.title, qid = second, t = t + 5000, z = s.zone, pl = 20},
        }
        local texts = {}
        for retell = 0, 3 do
            local days = A.JournalBook(me)
            local stories = A.SelfTale.Tell(me, days, false, retell)
            local text = A.JournalPlain(stories[days[1].key].text)
            if show and retell == 0 then print("[own] " .. text .. "\n") end
            texts[#texts + 1] = text
        end
        return texts
    end
    for _, text in ipairs(Own("Whatever Sputtervalve had wanted, he had it now.")) do
        check(not text:find(", Whatever Sputtervalve", 1, true), "your own book: no capital after the place prefix: " .. text)
    end
    for _, text in ipairs(Own("Finally, said Lydon, the work was done.")) do
        check(not text:find("[Ii]n [^%.]-, [Ff]inally, said"), "your own book: no place in front of speech: " .. text)
    end
    s.after, s.afterMore, s.highlight = savedAfter, savedMore, savedHighlight
end

print("PlaceLead: " .. assertions .. " checks passed")
