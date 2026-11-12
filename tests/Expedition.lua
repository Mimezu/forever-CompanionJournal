-- Run from the client root: lua5.1 Interface/AddOns/CompanionJournal/tests/Expedition.lua [print]
-- Lane O8 (2026-11-12), the own book's composer: a JOURNEY told as one road, the DANGER register,
-- and an adventure's company and foes.
-- 1. A road like the player's of 11 November (the Sepulcher, through Hillsbrad, Arathi and the
--    Wetlands to Loch Modan and back, deaths on the way, work far above the level): one
--    paragraph that sets out, names the far point, folds the new lands, tells the deaths by
--    place in time order (the fall, Dun Algaz, the plains creeper and the raise), says the danger
--    outright once, and ends on how far and how long. The same road walked safely (no deaths,
--    lands of our level) is told in the plain register, without the dangers.
-- 2. The register: the same sentence at register 0 and 2 differs in its verbs, not in a sentence.
-- 3. The adventure's facts: members who stayed ten minutes (not in the list) are the company, by
--    who they were or as strangers; a few unnamed elites say nothing; a dangerous stretch does.
-- Never reads SavedVariables.
local root = "Interface/AddOns/CompanionJournal/"
local assertions = 0
local function check(value, message) assertions = assertions + 1; assert(value, message) end
local show = arg and arg[1] == "print"

function time(t) if type(t) == "table" then return os.time(t) end return 1790000000 + 100 * 86400 end
function date(fmt, t) return os.date(fmt, t) end
function CreateFrame() return setmetatable({}, {__index = function() return function() end end}) end
C_Timer = {After = function() end}
LOCALIZED_CLASS_NAMES_MALE = {WARRIOR = "Warrior", PRIEST = "Priest", SHAMAN = "Shaman", MAGE = "Mage", WARLOCK = "Warlock", HUNTER = "Hunter", ROGUE = "Rogue", PALADIN = "Paladin", DRUID = "Druid"}
local A = {defaults = {colors = {}}}
for _, file in ipairs({"LoreData.lua", "Lore.lua", "LoreHordeStories.lua", "LoreAllianceStories.lua", "LoreWorldStories.lua", "LoreClassStories.lua",
    "LoreForeverStories.lua", "People.lua", "Characters.lua", "Journal.lua", "JournalBook.lua", "JournalEpisodes.lua", "JournalTellers.lua", "JournalFeel.lua",
    "JournalTale.lua", "JournalWords.lua", "JournalSelfWords.lua", "JournalSelfCompose.lua", "JournalSelfStyle.lua", "JournalSelfPlan.lua", "JournalSelfTale.lua"}) do
    assert(loadfile(root .. file))("CompanionJournal", A)
end
A.db = {people = {}}
A.SelfUnderground = function(name)
    for _, word in ipairs({"Mine", "Mines", "Cave", "Caverns", "Den", "Chasm", "Kraul"}) do if name:find("%f[%a]" .. word .. "%f[%A]") then return true end end
    return false
end
local C = A.SelfCompose
check(C and C.FindExpeditions and C.TellExpedition and C.Register and C.DangerOf and C.AdventureFacts, "the lane's functions exist")
local function Find(text, needle) return text:find(needle, 1, true) ~= nil end
local function Index(text, needle) return (text:find(needle, 1, true)) or math.huge end
local function Paragraphs(text)
    local out = {}
    for para in (text .. "\n\n"):gmatch("(.-)\n\n") do if para:match("%S") then out[#out + 1] = para end end
    return out
end
local function Count(text, needle) local n, at = 0, 1 while true do local i = text:find(needle, at, true) if not i then return n end n, at = n + 1, i + 1 end end

-- 1. The road ---------------------------------------------------------------------------------
local BASE = os.time({year = 2026, month = 5, day = 6, hour = 0})
local function At(h, m) return BASE + h * 3600 + m * 60 end
local A_people = {
    dahlia = {name = "Dahlia-Noir", class = "MAGE", race = "Scourge", pronouns = "she"},
    marrow = {name = "Marrow-Rotmoor", class = "PRIEST", race = "Scourge", pronouns = "he"},
}
local function Road(hard)
    local journal = {}
    local lv = hard and 18 or 40
    local function Add(e) e.pl = e.pl or lv; e.ol = e.ol or lv; journal[#journal + 1] = e; return e end
    -- the work before it, so the day has a chapter of its own
    Add({k = "play", t = At(21, 0), e = At(22, 0), z = "Silverpine Forest"})
    Add({k = "with", d = "dahlia", n = "Dahlia-Noir", t = At(21, 0), e = At(23, 59), z = "Silverpine Forest"})
    Add({k = "with", d = "marrow", n = "Marrow-Rotmoor", t = At(21, 0), e = At(23, 59), z = "Silverpine Forest"})
    Add({k = "town", d = "The Sepulcher", t = At(21, 1), z = "Silverpine Forest"})
    Add({k = "quest", d = "Border Crossings", qid = 477, ql = 14, t = At(21, 14), z = "Silverpine Forest"})
    Add({k = "quest", d = "Maps and Runes", qid = 478, ql = 14, t = At(21, 40), z = "Silverpine Forest"})
    Add({k = "quest", d = "Dalar's Analysis", qid = 481, ql = 14, t = At(21, 50), z = "Silverpine Forest"})
    Add({k = "quest", d = "Dalaran's Intentions", qid = 482, ql = 14, t = At(21, 58), z = "Silverpine Forest"})
    -- the road: Hillsbrad, Arathi, the Wetlands, Loch Modan, and back by the Wetlands and Arathi
    Add({k = "play", t = At(22, 0), e = At(22, 10), z = "Hillsbrad Foothills"})
    Add({k = "first", d = "zone", t = At(22, 0), z = "Hillsbrad Foothills"})
    Add({k = "play", t = At(22, 10), e = At(22, 16), z = "Arathi Highlands"})
    Add({k = "first", d = "zone", t = At(22, 10), z = "Arathi Highlands"})
    Add({k = "play", t = At(22, 16), e = At(22, 26), z = "Wetlands"})
    Add({k = "first", d = "zone", t = At(22, 16), z = "Wetlands"})
    Add({k = "play", t = At(22, 26), e = At(22, 41), z = "Loch Modan"})
    Add({k = "first", d = "zone", t = At(22, 26), z = "Loch Modan"})
    if hard then
        Add({k = "pdeath", n = "Dahlia-Noir", t = At(22, 27), z = "Loch Modan"})
        Add({k = "death", d = "Mountaineer Rharen", sz = "Dun Algaz", w = "you", t = At(22, 27), z = "Loch Modan"})
        Add({k = "pdeath", n = "Marrow-Rotmoor", t = At(22, 29), z = "Loch Modan"})
        Add({k = "quest", d = "Wet Job", qid = 79974, ql = 32, t = At(22, 38), z = "Loch Modan"})
    end
    Add({k = "play", t = At(22, 41), e = At(22, 55), z = "Wetlands"})
    if hard then
        Add({k = "death", env = "FALLING", w = "you", t = At(22, 43), z = "Wetlands"})
        Add({k = "pdeath", n = "Dahlia-Noir", t = At(22, 43), z = "Wetlands"})
        Add({k = "pdeath", n = "Marrow-Rotmoor", t = At(22, 44), z = "Wetlands"})
    end
    Add({k = "play", t = At(22, 55), e = At(23, 20), z = "Arathi Highlands"})
    if hard then
        Add({k = "death", d = "Plains Creeper", w = "you", t = At(22, 57), z = "Arathi Highlands"})
        Add({k = "pdeath", n = "Dahlia-Noir", t = At(22, 57), z = "Arathi Highlands"})
        Add({k = "rez", by = "Marrow Rotmoor", w = "them", t = At(22, 58), z = "Arathi Highlands"})
    end
    Add({k = "hearth", d = "The Sepulcher", t = At(23, 12), z = "Arathi Highlands"})
    Add({k = "play", t = At(23, 13), e = At(23, 59), z = "Silverpine Forest"})
    Add({k = "town", d = "The Sepulcher", t = At(23, 13), z = "Silverpine Forest"})
    Add({k = "sleep", d = "The Sepulcher", t = At(23, 58), z = "Silverpine Forest"})
    local me = {key = "alberich", name = "Alberich", race = "Scourge", faction = "Horde", class = "PALADIN", startLevel = lv, pronouns = "he", retell = 0, journal = journal}
    A.db.people = A_people
    A.SelfPerson = function() return me end
    local book = A.JournalBook(me)
    local stories = A.SelfTale.Tell(me, book, false, 0)
    local st = stories[book[#book].key]
    return A.JournalPlain(st and st.text or ""), book[#book]
end

local hard, day = Road(true)
if show then print("---- the hard road\n" .. hard) end
local eps = A.JournalEpisodes.Day(day.scenes).episodes
local runs = C.FindExpeditions(eps)
check(#runs == 1, "one road found in the day, got " .. #runs)
check(runs[1] and runs[1].far == "Loch Modan" and not runs[1].back, "the road's far point is Loch Modan; it did not walk back (the hearthstone did)")
local para
for _, p in ipairs(Paragraphs(hard)) do if Find(p, "Loch Modan") and Find(p, "Rharen") then para = p end end
check(para, "the road is one paragraph with its far point and its dangers: " .. hard)
check(Find(para, "Hillsbrad Foothills") and Find(para, "Arathi Highlands") and Find(para, "Wetlands"), "the lands crossed are named")
check(Count(para, "new to") + Count(para, "known to") + Count(para, "strange to") == 1, "the firsts fold into one clause")
check(Find(para, "Dun Algaz"), "the death is told where it fell, at Dun Algaz")
check(Index(para:lower(), "rharen") < Index(para:lower(), "a fall") and Index(para:lower(), "a fall") < Index(para:lower(), "plains creeper"), "the dangers in the order they came")
check(Find(para, "Marrow brought me back"), "the raise on the road")
check(Count(para:lower(), "killed me") + Count(para:lower(), "cut me down") + Count(para:lower(), "i died") <= 2, "the deaths in two sentences at most, the way out and the way back (round 10)")
check(not Find(para, "between them") and not Find(para, "more often") and not para:lower():find("%a+ times"), "the deaths never counted or compared (round 10)")
check(Index(para, "Rharen") < Index(para, "saw it through") and Index(para, "saw it through") < Index(para, "On the way back"), "deaths and the goal's deed in time order (round 10)")
check(Find(para, "back into the Arathi Highlands, and the hearthstone brought us home"), "the hearthstone from where it was cast (round 10)")
check(Index(para, "Wet Job") < Index(para, "Rharen"), "the road opens with its goal, named (round 9)")
check(Find(para, "little more than an hour") or Find(para, "under two hours") or Find(para, "less than an hour"), "and how long, in words")
check(Find(para, "far stronger than"), "work far above the level says the road was dangerous")
check(Count(hard:lower(), "hard road") + Count(hard:lower(), "took a lot of killing") + Count(hard:lower(), "died easily") <= 1, "the danger said outright at most once")
check(not Find(hard, "my body") and not Find(hard, "walk back"), "no walk to the body on the road")
check(not hard:find("%d+ times"), "numbers in words")

local easy = Road(false)
if show then print("---- the easy road\n" .. easy) end
local easyPara
for _, p in ipairs(Paragraphs(easy)) do if Find(p, "Loch Modan") then easyPara = p end end
check(easyPara, "the easy road is told: " .. easy)
check(not Find(easyPara, "killed me") and not Find(easyPara, "cut me down") and not Find(easyPara, "hard road"), "no dangers on an easy road")
check(not Find(easyPara, "fought our way") and not Find(easyPara, "as best we could"), "the plain register on an easy road")
check(Find(easyPara, "as far as Loch Modan"), "the easy road ends on how far too")

-- 2. The register --------------------------------------------------------------------------
local line = "We killed Captain Perrine and went home. We went on to Brill."
local plain0, plain2 = C.Register(line, 0), C.Register(line, 2)
check(plain0 == line, "register 0 leaves the words")
check(plain2 ~= line, "register 2 changes the words: " .. plain2)
local function Sentences(text) local n = 0 for _ in text:gmatch("[%.!%?]") do n = n + 1 end return n end
check(Sentences(plain2) == Sentences(line), "the same number of sentences: a word choice, not an added line")
check(C.Register("We killed him there.", 3) == "We killed him there.", "a pronoun after the kill keeps the plain verb")
check(Find(C.Register("A guard waited. We fought beside her.", 1), "We fought hard beside her"), "the register reaches a sentence inside a line")
check(C.DangerOf({}) == 0, "nothing recorded: safe")
check(C.DangerOf({mine = 1}) == 1, "one death: tense")
check(C.DangerOf({gap = 9}) == 2, "a land far above the level: dangerous")
check(C.DangerOf({gap = 9, mine = 3}) == 3, "a land far above and three deaths: deadly")
check(C.DangerOf({dangerous = true}) == 2, "a long stretch of elites: dangerous")
check(C.LevelGap("Arathi Highlands", 18) >= 8, "the Arathi Highlands are far above level 18")

-- 3. The adventure's company and foes -------------------------------------------------------
local ep = {t = 0, e = 3600, party = {"Dahlia"}, scenes = {}, quests = {}, members = {
    {name = "Dahlia", full = "Dahlia-Noir", circle = "companion", significant = true, t = 0, e = 3600},
    {name = "Zan", full = "Zan-X", race = "Troll", class = "HUNTER", significant = true, t = 100, e = 1900},
    {name = "Kel", full = "Kel-X", race = "Orc", class = "WARRIOR", significant = true, t = 100, e = 1900},
    {name = "Brief", full = "Brief-X", race = "Tauren", class = "DRUID", significant = false, t = 100, e = 200},
}, elites = 2}
local f = C.AdventureFacts(ep)
check(f and f.strangers == 2, "two significant members outside the list are the company")
check(f and not f.dangerous and #f.named == 0, "two unnamed elites say nothing")
check(f and f.to == 1900, "the company's time ends with the last of them")
local w1 = C.CompanyWords(f, 0)
local w2 = C.CompanyWords(f, 1)
check(w1 == "a troll hunter and an orc warrior", "told by who they were: " .. tostring(w1))
check(w2 == "two strangers", "or as strangers: " .. tostring(w2))
ep.members[2].guild = true
check(Find(C.CompanyWords(C.AdventureFacts(ep), 0), "a guildmate"), "a guildmate as a guildmate")
check(C.AdventureFacts({t = 0, e = 60, party = {}, scenes = {}, quests = {}, elites = 3}) == nil, "a few unnamed elites alone are nothing")
local g = C.AdventureFacts({t = 0, e = 60, party = {}, scenes = {}, quests = {}, elites = 8, eliteSeconds = 900, dangerous = true, eliteNames = {"Son of Arugal", "Rot Hide Brute"}})
check(g and g.dangerous and #g.named == 2, "a dangerous stretch with named elites")
check(C.AdventureFacts({t = 0, e = 60, party = {}, scenes = {}, quests = {}}) == nil, "an old journal without the fields: nothing")

-- 4. Never a count of quests (round 10, reader J: tell the quests that move a story, never count them)
check(not hard:find("smaller tasks") and not hard:find("saw to %a+ tasks?"), "no task count in the chapter")
print(("PASS: %d expedition, register and adventure assertions"):format(assertions))
