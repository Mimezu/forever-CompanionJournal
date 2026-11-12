-- Run from the client root: lua5.1 Interface/AddOns/CompanionJournal/tests/CompanionDeaths.lua [print]
-- The companion's book, deaths at their moments (2026-11-11): a wipe in a dungeon is one
-- sentence at its moment and the retry is "went back down"; the run is one paragraph with its
-- bosses in true order, the level that came with it and the hand-in about it (which never
-- retells the descent); deaths in later zones are told in time order with the raise the
-- companion gave; a generic foe takes "a", a named one none; with three in the party the
-- chapter never says "the pair of you". Every retell 0-7 in both voices, and the planned path.
-- Reader G (2026-11-11): several deaths of yours to one killer, or between the first and the
-- last of a bad moment, are one sentence with the killer named once, the companion's falls by
-- count and the raises as a clause; the companion is never a stranger in its own book.
local root = "Interface/AddOns/CompanionJournal/"
local assertions = 0
local function check(value, message) assertions = assertions + 1; assert(value, message) end
local show = arg and arg[1] == "print"

function time(t) if type(t) == "table" then return os.time(t) end return 1790000000 + 40 * 86400 end
function date(fmt, t) return os.date(fmt, t) end
function CreateFrame() return setmetatable({}, {__index = function() return function() end end}) end
C_Timer = {After = function() end}
LOCALIZED_CLASS_NAMES_MALE = {WARRIOR = "Warrior", MAGE = "Mage", PRIEST = "Priest", ROGUE = "Rogue", WARLOCK = "Warlock",
    HUNTER = "Hunter", DRUID = "Druid", SHAMAN = "Shaman", PALADIN = "Paladin"}
local A = {defaults = {colors = {}}}
for _, file in ipairs({"LoreData.lua", "Lore.lua", "LoreHordeStories.lua", "LoreAllianceStories.lua", "LoreWorldStories.lua",
    "LoreClassStories.lua", "LoreForeverStories.lua", "LoreNotes.lua", "LorePlaces.lua", "LorePeopleHistory.lua", "LoreWorldConnections.lua",
    "People.lua", "Characters.lua", "Journal.lua", "JournalSelf.lua", "JournalBook.lua", "JournalEpisodes.lua", "JournalTellers.lua",
    "JournalFeel.lua", "JournalTale.lua", "JournalWords.lua", "JournalSelfWords.lua", "JournalSelfTale.lua"}) do
    assert(loadfile(root .. file))("CompanionJournal", A)
end
A.db = {people = {}}
A.SelfUnderground = function() return false end
check(A.JournalEpisodes and A.JournalEpisodes.DungeonRuns, "the run unit comes from JournalEpisodes")

local BASE = os.time({year = 2026, month = 10, day = 5, hour = 0})
local function At(day, hour, minute) return BASE + day * 86400 + math.floor((hour or 20) * 3600) + (minute or 0) * 60 end
local function Plain(text) return (A.JournalPlain and A.JournalPlain(text) or text) end

-- The foe's name: the shared rule (A.FoeName) for both books.
check(A.FoeName("Ragefire Trogg") == "a Ragefire trogg", "a generic creature takes an article, its kind in small letters")
check(A.FoeName("Venture Co. Geologist") == "a Venture Co. geologist", "a job noun is a kind")
check(A.FoeName("Bishop Jericho", true) == "Bishop Jericho", "a title makes a name, whatever the record's flag")
check(A.FoeName("Veni Lace") == "Veni Lace", "two capitalised words with no kind noun are a name")
check(A.FoeName("Hogger") == "Hogger" and A.FoeName("Mor'Ladim") == "Mor'Ladim", "one word or an apostrophe is a name")
check(A.FoeName("Taragaman the Hungerer") == "Taragaman the Hungerer", "a boss is a name")
check(A.FoeName("Kobold Tunneler") == "a kobold tunneler", "an agent noun at the end is a kind")
check(A.FoeName("Son of Arugal") == "a son of Arugal", "a kind in front of 'of' is one of many")
check(A.FoeName("Nightbane Vile Fang", true) == "a Nightbane Vile Fang", "the record's flag decides an unknown ending")
check(A.FoeName("Old Murk-Eye") == "Old Murk-Eye", "a hyphenated name is a name")

---------------------------------------------------------------------------------------------
-- 1. Three in the party, a wipe and a clear in the Deadmines, deaths in Duskwood with a raise.
---------------------------------------------------------------------------------------------
local me = {self = true, charKey = "thr", name = "Thrynn", race = "Dwarf", faction = "Alliance", class = "PALADIN", startLevel = 1, journal = {}}
local bramble = {name = "Bramble-Oak", class = "PRIEST", race = "NightElf", pronouns = "she", journal = {}, key = "bramble-oak"}
local hollis = {name = "Hollis-Gray", class = "ROGUE", race = "Human", pronouns = "he", journal = {}, key = "hollis-gray"}
A.db.people["bramble-oak"] = bramble
A.db.people["hollis-gray"] = hollis
do
    local t0, stop = At(2, 20), At(2, 23, 30)
    local M = me.journal
    M[#M + 1] = {k = "play", t = t0, e = stop, z = "Westfall", pl = 18}
    M[#M + 1] = {k = "with", d = "bramble-oak", n = "Bramble-Oak", t = t0, e = stop}
    M[#M + 1] = {k = "with", d = "hollis-gray", n = "Hollis-Gray", t = t0, e = stop}
    -- (the first time you raised her, from your own book; the raise she gave you in Duskwood)
    M[#M + 1] = {k = "first", d = "rezother", n = "Bramble", z = "Duskwood", t = At(2, 22, 26), pl = 19}
    M[#M + 1] = {k = "rez", w = "them", by = "Bramble Oak", z = "Duskwood", t = At(2, 22, 43), pl = 19}
    -- (a stranger's raise after the last death: told in her book too, round 4)
    M[#M + 1] = {k = "rez", w = "them", by = "Wendell Bray", z = "Duskwood", t = At(2, 22, 53), pl = 19}
    local J = bramble.journal
    J[#J + 1] = {k = "group", t = t0, e = stop, z = "Westfall", pl = 18, ol = 18}
    J[#J + 1] = {k = "dungeon", d = "The Deadmines", r = "tank", tr = "healer", t = At(2, 20, 30), z = "The Deadmines", pl = 18, ol = 18}
    J[#J + 1] = {k = "death", d = "Defias Pillager", a = true, w = "you", t = At(2, 20, 40), z = "The Deadmines", pl = 18, ol = 18}
    J[#J + 1] = {k = "death", w = "them", t = At(2, 20, 41), z = "Westfall", pl = 18, ol = 18} -- (logged on the ghost run)
    J[#J + 1] = {k = "dungeon", d = "The Deadmines", r = "tank", tr = "healer", t = At(2, 20, 44), z = "The Deadmines", pl = 18, ol = 18}
    for i, boss in ipairs({"Rhahk'Zor", "Sneed", "Gilnid", "Mr. Smite", "Captain Greenskin", "Edwin VanCleef"}) do
        J[#J + 1] = {k = "boss", d = boss, n = 3, t = At(2, 20, 50 + i * 10), z = "The Deadmines", pl = 18, ol = 18}
    end
    J[#J + 1] = {k = "mylevel", d = 19, t = At(2, 21, 55), z = "Westfall", pl = 18, ol = 18}
    J[#J + 1] = {k = "level", d = "19", t = At(2, 21, 56), z = "Westfall", pl = 19, ol = 19}
    J[#J + 1] = {k = "quest", d = "The Defias Brotherhood", qid = 166, t = At(2, 22, 0), z = "Westfall", pl = 19, ol = 19}
    J[#J + 1] = {k = "death", w = "them", t = At(2, 22, 25), z = "Duskwood", pl = 19, ol = 19}
    J[#J + 1] = {k = "death", w = "them", t = At(2, 22, 27), z = "Duskwood", pl = 19, ol = 19}
    J[#J + 1] = {k = "death", d = "Mor'Ladim", w = "you", t = At(2, 22, 28), z = "Duskwood", pl = 19, ol = 19}
    J[#J + 1] = {k = "death", d = "Nightbane Vile Fang", a = true, w = "you", t = At(2, 22, 40), z = "Duskwood", pl = 19, ol = 19}
    J[#J + 1] = {k = "death", d = "Splinter Fist Ogre", w = "you", t = At(2, 22, 50), z = "Duskwood", pl = 19, ol = 19}
    J[#J + 1] = {k = "death", w = "them", t = At(2, 22, 51), z = "Duskwood", pl = 19, ol = 19}
end
A.SelfPerson = function() return me end
local player = {name = "Thrynn", race = "Dwarf", faction = "Alliance", class = "PALADIN", charKey = "thr"}

local PLANNED = function(k) if k == "teller" then return "planned" end end
local function Tell(person, voice, retell, variant, brief)
    A.BookVariant = variant
    person.retell = retell
    local days = A.JournalBook(person)
    local stories = A.JournalTale.Tell(person, days, voice, player, brief or false)
    A.BookVariant = nil
    local key
    for _, d in ipairs(days) do if stories[d.key] and stories[d.key].text ~= "" then key = d.key end end
    return stories[key].text
end

local function Order(text, names)
    local last = 0
    for _, n in ipairs(names) do
        local at = text:find(n, 1, true)
        if not at or at < last then return false, n end
        last = at
    end
    return true
end
local function Paragraph(text, needle)
    for para in (text .. "\n\n"):gmatch("(.-)\n\n") do if para:find(needle, 1, true) then return para end end
    return nil
end
-- "a kobold tunneler" or "A kobold tunneler" (at a sentence's start), as the shared rule writes it, never bare.
local function Article(text, name)
    local shown = A.FoeName(name, true)
    local a, rest = shown:match("^(%a+) (.*)$")
    if not a then return false end
    return (text:find(a .. " " .. rest, 1, true) or text:find(a:gsub("^%l", string.upper) .. " " .. rest, 1, true)) ~= nil
end
local function Count(text, needle)
    local n, at = 0, 1
    while true do
        local s, e = text:find(needle, at, true)
        if not s then return n end
        n, at = n + 1, e + 1
    end
end

local seen = {}
for _, voice in ipairs({"you", "we"}) do
    for retell = 0, 7 do
        local tag = " (" .. voice .. " " .. retell .. ")"
        local text = Plain(Tell(bramble, voice, retell, nil))
        if show then print("== Bramble" .. tag .. "\n" .. text .. "\n") end
        check(text == Plain(Tell(bramble, voice, retell, nil)), "deterministic per retell" .. tag)
        -- 1. deaths at their moments, never a ledger
        check(not text:find("times that day", 1, true) and not text:find("that day, Bramble", 1, true)
            and not text:find("Bramble was killed four", 1, true) and not text:find("four times", 1, true), "no count of deaths against the day" .. tag)
        -- 2. the run: one paragraph, a wipe and the retry, bosses in true order, no second descent
        local run = Paragraph(text, "Rhahk'Zor")
        check(run, "the run is told" .. tag)
        check(run:find("first try", 1, true) or run:find("first run", 1, true), "the wipe is told at its moment" .. tag)
        check(run:find("went back down", 1, true), "the retry is 'went back down'" .. tag)
        check(Article(run, "Defias Pillager") and run:find("Bramble fell", 1, true), "the wipe names the foe and her fall" .. tag)
        check(select(1, Order(run, {"Rhahk'Zor", "Sneed", "Gilnid", "Mr. Smite", "Captain Greenskin", "Edwin VanCleef"})), "bosses in true order" .. tag)
        check(not run:find("last of all Rhahk", 1, true) and not run:find("last of all Sneed", 1, true), "'last of all' only for the last" .. tag)
        check(run:find("level 19", 1, true), "the level that came with the run is in its paragraph" .. tag)
        check(Count(text, "went down into") + Count(text, "went into") + Count(text, "fought down") <= 1, "one descent only" .. tag)
        check(run:find("Stoutmantle", 1, true), "the hand-in about the run gives what came of it, in the run's paragraph" .. tag)
        check(not run:find("brought his head back", 1, true) and not run:find("faced Edwin VanCleef", 1, true), "the hand-in never retells the descent" .. tag)
        check(Count(text, "Edwin VanCleef") <= 2, "VanCleef named at most twice" .. tag)
        -- 3. the field deaths: time order, the raise she gave between, articles
        local field = Paragraph(text, "Duskwood")
        check(field and field ~= run, "the field deaths stand apart from the run" .. tag)
        check(text:find("Mor'Ladim", 1, true) and not text:find("a Mor'Ladim", 1, true), "a named foe takes no article" .. tag)
        check(Article(text, "Nightbane Vile Fang"), "a generic foe takes 'a'" .. tag)
        check(Article(text, "Splinter Fist Ogre"), "a kind noun takes 'a'" .. tag)
        local raise
        for _, needle in ipairs({"brought you back", "raised you", "brought me back", "raised me", "on your feet", "on my feet", "prayers", "prayed", "bring you back", "bring me back"}) do
            local at = text:find(needle, 1, true)
            if at and (not raise or at < raise) then raise = at end
        end
        check(raise, "the raise she gave is told" .. tag)
        local fang, ogre = text:find("Nightbane Vile Fang", 1, true), text:find("Splinter Fist ogre", 1, true)
        check(raise and fang and ogre and raise > fang and raise < ogre, "the raise follows the death it answered, before the next" .. tag)
        check(text:find("again", 1, true), "her second fall after your raise is 'again'" .. tag)
        local stranger = text:find("Wendell Bray, a stranger", 1, true)
        check(stranger and ogre and stranger > ogre, "a stranger's raise is told in her book, after the death it answered" .. tag)
        check(select(1, Order(text, {"Mor'Ladim", "Nightbane Vile Fang", "Splinter Fist ogre"})), "your deaths in time order" .. tag)
        -- 4. three in the party
        check(not text:lower():find("the pair of ", 1, true) and not text:lower():find("the two of ", 1, true), "no 'the pair of you' with three" .. tag)
        check(text:find("Hollis", 1, true), "the third is named" .. tag)
        -- 5. the writing
        check(not text:find(":", 1, true) and not text:find("?", 1, true), "no colon or question" .. tag)
        seen[text] = true
    end
end
check(next(seen) ~= nil, "chapters were told")

-- The planned path tells the same facts without error.
for _, voice in ipairs({"you", "we"}) do
    local text = Plain(Tell(bramble, voice, 0, PLANNED))
    if show then print("== Bramble planned (" .. voice .. ")\n" .. text .. "\n") end
    check(text:find("Rhahk'Zor", 1, true) and text:find("Edwin VanCleef", 1, true), "planned: the run is told (" .. voice .. ")")
    check(text:find("went back down", 1, true), "planned: the retry is told (" .. voice .. ")")
    check(not text:find("times that day", 1, true), "planned: no ledger (" .. voice .. ")")
    check(not text:lower():find("the pair of ", 1, true), "planned: no 'the pair of you' with three (" .. voice .. ")")
end
-- Highlights keeps the run and the deaths.
do
    local text = Plain(Tell(bramble, "you", 0, nil, true))
    check(text:find("went back down", 1, true) and text:find("Edwin VanCleef", 1, true), "Highlights keeps the wipe and the run")
end

---------------------------------------------------------------------------------------------
-- 2. A pair (no third), a run that ended on the wipe, their deaths at one moment with no
--    death of yours, and a companion death between two of yours (a different race and class).
---------------------------------------------------------------------------------------------
local me2 = {self = true, charKey = "zul", name = "Zul'kar", race = "Troll", faction = "Horde", class = "SHAMAN", startLevel = 1, journal = {}}
local tessa = {name = "Tessa-Moor", class = "HUNTER", race = "Orc", pronouns = "she", journal = {}, key = "tessa-moor"}
A.db.people["tessa-moor"] = tessa
do
    local t0, stop = At(4, 19), At(4, 23)
    local M = me2.journal
    M[#M + 1] = {k = "play", t = t0, e = stop, z = "The Barrens", pl = 16}
    M[#M + 1] = {k = "with", d = "tessa-moor", n = "Tessa-Moor", t = t0, e = stop}
    local J = tessa.journal
    J[#J + 1] = {k = "group", t = t0, e = stop, z = "The Barrens", pl = 16, ol = 16}
    J[#J + 1] = {k = "dungeon", d = "Wailing Caverns", r = "healer", tr = "damage", t = At(4, 19, 30), z = "Wailing Caverns", pl = 16, ol = 16}
    J[#J + 1] = {k = "boss", d = "Lady Anacondra", n = 2, t = At(4, 19, 50), z = "Wailing Caverns", pl = 16, ol = 16}
    J[#J + 1] = {k = "death", d = "Deviate Viper", a = true, w = "you", t = At(4, 20, 5), z = "Wailing Caverns", pl = 16, ol = 16}
    J[#J + 1] = {k = "death", w = "them", t = At(4, 20, 6), z = "The Barrens", pl = 16, ol = 16}
    J[#J + 1] = {k = "death", w = "them", t = At(4, 21, 10), z = "The Barrens", pl = 16, ol = 16}
    J[#J + 1] = {k = "death", w = "them", t = At(4, 21, 14), z = "The Barrens", pl = 16, ol = 16}
    J[#J + 1] = {k = "death", d = "Owatanka", w = "you", t = At(4, 22, 0), z = "The Barrens", pl = 16, ol = 16}
    J[#J + 1] = {k = "death", w = "them", t = At(4, 22, 4), z = "The Barrens", pl = 16, ol = 16}
    J[#J + 1] = {k = "death", d = "Kolkar Marauder", a = true, w = "you", t = At(4, 22, 9), z = "The Barrens", pl = 16, ol = 16}
end
A.SelfPerson = function() return me2 end
player = {name = "Zul'kar", race = "Troll", faction = "Horde", class = "SHAMAN", charKey = "zul"}
for _, voice in ipairs({"you", "we"}) do
    for retell = 0, 7 do
        local tag = " (pair " .. voice .. " " .. retell .. ")"
        local text = Plain(Tell(tessa, voice, retell, nil))
        if show then print("== Tessa" .. tag .. "\n" .. text .. "\n") end
        check(not text:find("times that day", 1, true) and not text:find("four times", 1, true), "no ledger" .. tag)
        check(text:find("Lady Anacondra", 1, true), "the kill before the wipe is told" .. tag)
        local wipe
        local viper = A.FoeName("Deviate Viper", true):gsub("^%a+ ", "")
        for sentence in (text .. " "):gmatch("(.-[%.!%?])%s") do if sentence:find(viper, 1, true) then wipe = sentence end end
        check(wipe and Article(wipe, "Deviate Viper") and wipe:find("Tessa fell", 1, true), "the wipe with no retry names the foe and her fall in one sentence" .. tag)
        check(not text:find("went back down", 1, true), "no retry: no 'went back down'" .. tag)
        check(text:find("twice", 1, true), "her two deaths at one moment are 'twice'" .. tag)
        check(text:find("Owatanka", 1, true) and not text:find("a Owatanka", 1, true) and not text:find("an Owatanka", 1, true), "a named beast takes no article" .. tag)
        check(Article(text, "Kolkar Marauder"), "a generic foe takes 'a'" .. tag)
        check(select(1, Order(text, {"Lady Anacondra", viper, "twice", "Owatanka", "Kolkar marauder"})), "everything in time order" .. tag)
        check(not text:find(":", 1, true) and not text:find("?", 1, true), "no colon or question" .. tag)
    end
end

---------------------------------------------------------------------------------------------
-- 3. Random lives (seeded): other races, classes, companions, dungeons and party sizes. The
--    rules hold for all of them: no ledger, bosses in true order, one descent, "went back down"
--    only after a wipe with a retry, articles by the shared rule, no "the pair of you" with
--    three or more, a raise after the death it answered, deterministic per retell.
---------------------------------------------------------------------------------------------
local DUNGEONS = {
    {"Ragefire Chasm", "Orgrimmar", "Durotar", {"Oggleflint", "Taragaman the Hungerer", "Jergosh the Invoker", "Bazzalan"}, 14, "Horde"},
    {"Wailing Caverns", "The Barrens", "The Barrens", {"Lady Anacondra", "Lord Cobrahn", "Kresh", "Lord Pythas", "Skum", "Lord Serpentis", "Verdan the Everliving", "Mutanus the Devourer"}, 18, "Horde"},
    {"The Deadmines", "Westfall", "Westfall", {"Rhahk'Zor", "Sneed", "Gilnid", "Mr. Smite", "Captain Greenskin", "Edwin VanCleef"}, 19, "Alliance"},
    {"Shadowfang Keep", "Silverpine Forest", "Silverpine Forest", {"Rethilgore", "Razorclaw the Butcher", "Baron Silverlaine", "Commander Springvale", "Odo the Blindwatcher", "Fenrus the Devourer", "Wolf Master Nandos", "Archmage Arugal"}, 23, "Horde"},
    {"Blackfathom Deeps", "Ashenvale", "Ashenvale", {"Ghamoo-ra", "Lady Sarevess", "Gelihast", "Lorgus Jett", "Baron Aquanis", "Twilight Lord Kelris", "Old Serra'kis", "Aku'mai"}, 25, "Alliance"},
    {"Razorfen Kraul", "The Barrens", "The Barrens", {"Roogug", "Aggem Thorncurse", "Death Speaker Jargba", "Overlord Ramtusk", "Agathelos the Raging", "Charlga Razorflank"}, 30, "Horde"},
}
local GENERIC = {"Searing Blade Cultist", "Defias Pillager", "Deviate Crocolisk", "Kolkar Marauder", "Son of Arugal", "Twilight Acolyte", "Razorfen Quilboar"}
local NAMED = {"Hogger", "Mor'Ladim", "Riptear", "Bishop Jericho", "Captain Flat Tusk", "Owatanka", "Veni Lace"}
local RACES = {Horde = {{"Orc", "WARRIOR"}, {"Scourge", "WARLOCK"}, {"Tauren", "SHAMAN"}, {"Troll", "HUNTER"}, {"Scourge", "PRIEST"}},
    Alliance = {{"Human", "PALADIN"}, {"Dwarf", "HUNTER"}, {"NightElf", "DRUID"}, {"Gnome", "MAGE"}, {"Human", "PRIEST"}}}
local NAMES = {"Keth", "Mira", "Tarok", "Bryn", "Grak", "Sable", "Orla", "Dunwick", "Vessa", "Harl"}
local function Lcg(seed) local s = seed; return function(n) s = (s * 1103515245 + 12345) % 2147483648; return (s % n) + 1 end end
local function Fuzz(seed)
    local R = Lcg(seed)
    local dg = DUNGEONS[R(#DUNGEONS)]
    local dungeon, hub, field, bosses, lvl, faction = dg[1], dg[2], dg[3], dg[4], dg[5], dg[6]
    local hero = RACES[faction][R(#RACES[faction])]
    local comp = RACES[faction][R(#RACES[faction])]
    local others = R(3) - 1 -- (0, 1 or 2 more in the party)
    local wipe, retry = R(2) == 1, R(2) == 1
    local killed = R(#bosses)
    local levelAfter = R(2) == 1
    local theirsField, mineField, raise = R(3) - 1, R(3) - 1, R(2) == 1
    local foes = {}
    for i = 1, mineField do foes[i] = (R(2) == 1) and {GENERIC[R(#GENERIC)], true} or {NAMED[R(#NAMED)], false} end
    local hname, cname = NAMES[R(#NAMES)], NAMES[R(#NAMES)] .. "-Fuzz"
    local key = "fuzz-" .. seed
    A.db.people = {}
    local who = {self = true, charKey = "fz" .. seed, name = hname, race = hero[1], faction = faction, class = hero[2], startLevel = 1, journal = {}}
    local them = {name = cname, class = comp[2], race = comp[1], pronouns = (R(2) == 1) and "she" or "he", journal = {}, key = key}
    A.db.people[key] = them
    local day = 10 + (seed % 5)
    local t0, stop = At(day, 19), At(day, 23, 30)
    local M = who.journal
    M[#M + 1] = {k = "play", t = t0, e = stop, z = hub, pl = lvl}
    M[#M + 1] = {k = "with", d = key, n = cname, t = t0, e = stop}
    for i = 1, others do
        local okey = "other-" .. seed .. "-" .. i
        local pick = RACES[faction][R(5)]
        A.db.people[okey] = {name = NAMES[R(#NAMES)] .. "-Oth", class = pick[2], race = pick[1], journal = {}, key = okey}
        M[#M + 1] = {k = "with", d = okey, n = A.db.people[okey].name, t = t0, e = stop}
    end
    local J = them.journal
    J[#J + 1] = {k = "group", t = t0, e = stop, z = hub, pl = lvl, ol = lvl}
    local t = At(day, 19, 30)
    J[#J + 1] = {k = "dungeon", d = dungeon, r = "tank", tr = "damage", t = t, z = dungeon, pl = lvl, ol = lvl}
    local wipeFoe = GENERIC[R(#GENERIC)]
    if wipe then
        J[#J + 1] = {k = "death", d = wipeFoe, a = true, w = "you", t = t + 600, z = dungeon, pl = lvl, ol = lvl}
        J[#J + 1] = {k = "death", w = "them", t = t + 660, z = hub, pl = lvl, ol = lvl}
        t = t + 900
    end
    if not wipe or retry then
        for i = 1, killed do J[#J + 1] = {k = "boss", d = bosses[i], n = 2 + others, t = t + i * 420, z = dungeon, pl = lvl, ol = lvl} end
        t = t + killed * 420
    end
    if levelAfter then
        J[#J + 1] = {k = "mylevel", d = lvl + 1, t = t + 240, z = hub, pl = lvl, ol = lvl}
        J[#J + 1] = {k = "level", d = tostring(lvl + 1), t = t + 300, z = hub, pl = lvl + 1, ol = lvl + 1}
    end
    t = t + 3600
    for i = 1, theirsField do J[#J + 1] = {k = "death", w = "them", t = t + i * 200, z = field, pl = lvl, ol = lvl} end
    t = t + theirsField * 200 + 120
    local raiseAt
    for i = 1, mineField do
        J[#J + 1] = {k = "death", d = foes[i][1], a = foes[i][2] or nil, w = "you", t = t + i * 400, z = field, pl = lvl, ol = lvl}
        if raise and i == 1 then raiseAt = t + 400 + 90; M[#M + 1] = {k = "rez", w = "them", by = (cname:gsub("%-.*$", "")) .. " Fuzz", z = field, t = raiseAt, pl = lvl} end
    end
    A.SelfPerson = function() return who end
    local hero2 = {name = hname, race = hero[1], faction = faction, class = hero[2], charKey = "fz" .. seed}
    local function Say(voice, retell, variant)
        A.BookVariant = variant
        them.retell = retell
        local days = A.JournalBook(them)
        local stories = A.JournalTale.Tell(them, days, voice, hero2, false)
        A.BookVariant = nil
        local k
        for _, d in ipairs(days) do if stories[d.key] and stories[d.key].text ~= "" then k = d.key end end
        return k and Plain(stories[k].text) or ""
    end
    local first = (cname:gsub("%-.*$", ""))
    for _, voice in ipairs({"you", "we"}) do
        for retell = 0, 1 do
            local tag = (" (seed %d %s %s party %d wipe %s retry %s killed %d retell %d)"):format(seed, dungeon, voice, 2 + others, tostring(wipe), tostring(retry), killed, retell)
            local text = Say(voice, retell, nil)
            if show then print("== Fuzz" .. tag .. "\n" .. text .. "\n") end
            check(text ~= "", "told" .. tag)
            check(text == Say(voice, retell, nil), "deterministic" .. tag)
            check(not text:find("times that day", 1, true), "no ledger" .. tag)
            check(not text:find(":", 1, true) and not text:find("?", 1, true), "no colon or question" .. tag)
            local toldBosses = {}
            for i = 1, killed do if not wipe or retry then toldBosses[#toldBosses + 1] = bosses[i] end end
            -- (a long roll is cut to its first names and a count: the names that appear keep their order,
            -- and the last of them is always there)
            local present = {}
            for _, b in ipairs(toldBosses) do if text:find(b, 1, true) then present[#present + 1] = b end end
            if #toldBosses >= 2 then
                check(select(1, Order(text, present)), "bosses in true order" .. tag)
                check(#present >= math.min(#toldBosses, 3), "the kills are told" .. tag)
            end
            check(Count(text, "went down into") + Count(text, "went into") + Count(text, "headed down into") <= 1, "one descent" .. tag)
            if wipe and retry then check(text:find("went back down", 1, true), "the retry is told" .. tag)
            else check(not text:find("went back down", 1, true), "no retry told" .. tag) end
            if wipe then check(Article(text, wipeFoe) and text:find(first .. " fell", 1, true), "the wipe names the foe with its article and their fall" .. tag) end
            for _, foe in ipairs(foes) do
                -- (the same killer twice or more is named once, as one: "the Deviate crocolisks killed you twice")
                local fam = A.FoeFamily({foe[1], foe[1]}, {foe[2], foe[2]})
                local asOne = fam and (text:find(fam, 1, true) or text:find(fam:gsub("^%l", string.upper), 1, true))
                if foe[2] then check(Article(text, foe[1]) or asOne, "your death to " .. foe[1] .. " is told, with 'a' or as one of many" .. tag)
                else check(text:find(foe[1], 1, true) and not Article(text, foe[1]), "your death to " .. foe[1] .. " is told, no article" .. tag) end
            end
            if others >= 1 then check(not text:lower():find("the pair of ", 1, true) and not text:lower():find("the two of ", 1, true), "no 'the pair of you' with three or more" .. tag) end
            if raise and mineField >= 1 then
                local shown1 = foes[1][2] and A.FoeName(foes[1][1], true):gsub("^%a+ ", "") or foes[1][1]
                local at = text:find(shown1, 1, true)
                local r = at and (text:find("back", at, true) or text:find("raised", at, true) or text:find("rose", at, true) or text:find("feet", at, true) or text:find("pray", at, true))
                check(at and r and r > at, "the raise follows the death it answered" .. tag)
                if mineField == 2 then
                    local shown2 = foes[2][2] and A.FoeName(foes[2][1], true):gsub("^%a+ ", "") or foes[2][1]
                    local second = at and text:find(shown2, at + #shown1, true)
                    check(not second or r < second, "the raise comes before your next death" .. tag)
                end
            end
            if levelAfter and (not wipe or retry) and killed >= 1 then
                local run = Paragraph(text, present[#present] or toldBosses[#toldBosses])
                check(run and run:find("level " .. (lvl + 1), 1, true), "the level that came with the run is in its paragraph" .. tag)
            end
        end
    end
    local planned = Say("you", 0, PLANNED)
    check(planned ~= "" and not planned:find("times that day", 1, true), "planned path told without a ledger (seed " .. seed .. ")")
end
for seed = 1, 24 do Fuzz(seed) end

print("PASS: " .. assertions .. " companion death assertions")
