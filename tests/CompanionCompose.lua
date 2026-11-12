-- Run from the client root: lua5.1 Interface/AddOns/CompanionJournal/tests/CompanionCompose.lua [print]
-- The companion's chapter composed (lane C8, 2026-11-12): a first meeting with next to nothing
-- shared is still a short real paragraph from the record (the hour, your level, where your own
-- book says the night ended); the opener keeps the place the record began in, and the close
-- answers it; the lines of a day stand in time order, one paragraph an episode, eight at most;
-- a companion's death with nothing around it or inside a city is not told; a flight that led to
-- nothing told, a cave nothing happened in and a tally of the day's quests are not told; a
-- level is a clause of the deed it came with or stands once before the close; a third of the
-- party whom the chapter shows doing nothing is not named. Both voices, four retells.
local root = "Interface/AddOns/CompanionJournal/"
local assertions = 0
local function check(value, message) assertions = assertions + 1; assert(value, message) end
local show = arg and (arg[1] == "print" or arg[1] == "lines")

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
check(A.JournalEpisodes and A.JournalEpisodes.Day, "the episodes come from JournalEpisodes")
check(A.JournalTale.Compose and A.JournalTale.ComposeParagraphs, "the companion composer is there")

local BASE = os.time({year = 2026, month = 10, day = 5, hour = 0})
local function At(day, hour, minute) return BASE + day * 86400 + math.floor((hour or 20) * 3600) + (minute or 0) * 60 end
local function Plain(text) return (A.JournalPlain and A.JournalPlain(text) or text) end

local me = {self = true, charKey = "thr", name = "Thrynn", race = "Dwarf", faction = "Alliance", class = "PALADIN", startLevel = 1, journal = {}}
local bramble = {name = "Bramble-Oak", class = "PRIEST", race = "NightElf", pronouns = "she", journal = {}, key = "bramble-oak"}
local hollis = {name = "Hollis-Gray", class = "ROGUE", race = "Human", pronouns = "he", journal = {}, key = "hollis-gray"}
A.db.people["bramble-oak"] = bramble
A.db.people["hollis-gray"] = hollis
local M, J = me.journal, bramble.journal

---------------------------------------------------------------------------------------------
-- Day 1: a first meeting past midnight, one minute shared, at the end of your own night.
---------------------------------------------------------------------------------------------
do
    M[#M + 1] = {k = "play", t = At(1, 22, 0), e = At(2, 1, 20), z = "Elwynn Forest", pl = 13}
    M[#M + 1] = {k = "town", d = "Goldshire", t = At(2, 1, 10), z = "Elwynn Forest", pl = 13}
    M[#M + 1] = {k = "with", d = "bramble-oak", n = "Bramble-Oak", t = At(2, 1, 5), e = At(2, 1, 6)}
    J[#J + 1] = {k = "group", t = At(2, 1, 5), e = At(2, 1, 6), z = "Elwynn Forest", pl = 13, ol = 12}
end
---------------------------------------------------------------------------------------------
-- Day 3: ten minutes in Stormwind, then Westfall (new to you), a hand-in, a death with hers, her
-- level with no deed near it, a cave nothing happened in, a flight back that led to nothing told,
-- her death alone in the city, and a third in the party who did nothing the record kept.
---------------------------------------------------------------------------------------------
do
    local t0, stop = At(4, 20, 0), At(4, 22, 40)
    M[#M + 1] = {k = "play", t = t0, e = At(4, 20, 10), z = "Stormwind City", pl = 18}
    M[#M + 1] = {k = "town", d = "Stormwind City", t = t0, z = "Stormwind City", pl = 18}
    M[#M + 1] = {k = "play", t = At(4, 20, 10), e = At(4, 22, 20), z = "Westfall", pl = 18}
    M[#M + 1] = {k = "first", d = "zone", t = At(4, 20, 12), z = "Westfall", pl = 18}
    M[#M + 1] = {k = "cave", d = "Jangolode Mine", t = At(4, 21, 40), z = "Westfall", pl = 19}
    M[#M + 1] = {k = "nightflight", t = At(4, 22, 20), z = "Westfall", pl = 19}
    M[#M + 1] = {k = "play", t = At(4, 22, 22), e = At(4, 23, 0), z = "Stormwind City", pl = 19}
    M[#M + 1] = {k = "town", d = "Stormwind City", t = At(4, 22, 22), z = "Stormwind City", pl = 19}
    M[#M + 1] = {k = "with", d = "bramble-oak", n = "Bramble-Oak", t = t0, e = stop}
    M[#M + 1] = {k = "with", d = "hollis-gray", n = "Hollis-Gray", t = t0, e = stop}
    J[#J + 1] = {k = "group", t = t0, e = stop, z = "Stormwind City", pl = 18, ol = 19}
    J[#J + 1] = {k = "quest", d = "The Defias Brotherhood", qid = 166, t = At(4, 20, 32), z = "Westfall", pl = 18, ol = 19}
    J[#J + 1] = {k = "death", d = "Defias Pillager", a = true, w = "you", t = At(4, 20, 50), z = "Westfall", pl = 18, ol = 19}
    J[#J + 1] = {k = "death", w = "them", t = At(4, 20, 51), z = "Westfall", pl = 18, ol = 19}
    J[#J + 1] = {k = "level", d = "20", t = At(4, 21, 30), z = "Westfall", pl = 18, ol = 20}
    J[#J + 1] = {k = "death", w = "them", t = At(4, 22, 30), z = "Stormwind City", pl = 18, ol = 20}
end
---------------------------------------------------------------------------------------------
-- Day 5: two strangers grouped with you for the Blackrock work, among elites a long while, then
-- gone; a third stranger along a few minutes only.
---------------------------------------------------------------------------------------------
do
    local t0, stop = At(6, 20, 0), At(6, 22, 0)
    M[#M + 1] = {k = "play", t = t0, e = stop, z = "Redridge Mountains", pl = 21}
    M[#M + 1] = {k = "town", d = "Lakeshire", t = At(6, 21, 50), z = "Redridge Mountains", pl = 21}
    M[#M + 1] = {k = "with", d = "bramble-oak", n = "Bramble-Oak", t = t0, e = stop}
    M[#M + 1] = {k = "member", n = "Bramble-Oak", c = "PRIEST", r = "NightElf", l = "companion", t = t0, e = stop}
    M[#M + 1] = {k = "member", n = "Tobias-Forever", c = "PALADIN", r = "Human", t = At(6, 20, 10), e = At(6, 20, 52)}
    M[#M + 1] = {k = "member", n = "Tamsin-Forever", c = "DRUID", r = "NightElf", t = At(6, 20, 12), e = At(6, 20, 52)}
    M[#M + 1] = {k = "member", n = "Wick-Forever", c = "MAGE", r = "Gnome", t = At(6, 21, 20), e = At(6, 21, 24)}
    M[#M + 1] = {k = "elites", c = 8, s = 700, x = {"Gath'Ilzogg"}, z = "Redridge Mountains", t = At(6, 20, 20), e = At(6, 20, 45)}
    J[#J + 1] = {k = "group", t = t0, e = stop, z = "Redridge Mountains", pl = 21, ol = 21}
    J[#J + 1] = {k = "quest", d = "Blackrock Menace", qid = 20, t = At(6, 20, 48), z = "Redridge Mountains", pl = 21, ol = 21}
end
---------------------------------------------------------------------------------------------
-- Day 7: a long walk, Elwynn to Westfall and on through Duskwood and Deadwind Pass into the
-- Swamp of Sorrows (new, far above you), deaths on the way, back to Deadwind Pass, the hearth.
---------------------------------------------------------------------------------------------
do
    local t0, stop = At(8, 20, 0), At(8, 21, 40)
    local legs = {{"Elwynn Forest", 0, 15}, {"Westfall", 15, 30}, {"Duskwood", 30, 50, true}, {"Deadwind Pass", 50, 65, true},
        {"Swamp of Sorrows", 65, 85, true}, {"Deadwind Pass", 85, 95}}
    for _, leg in ipairs(legs) do
        M[#M + 1] = {k = "play", t = t0 + leg[2] * 60, e = t0 + leg[3] * 60, z = leg[1], pl = 22}
        if leg[4] then M[#M + 1] = {k = "first", d = "zone", t = t0 + leg[2] * 60 + 5, z = leg[1], pl = 22} end
    end
    M[#M + 1] = {k = "hearth", d = "Goldshire", t = t0 + 96 * 60, z = "Deadwind Pass", pl = 22}
    M[#M + 1] = {k = "play", t = t0 + 96 * 60, e = t0 + 110 * 60, z = "Elwynn Forest", pl = 22}
    M[#M + 1] = {k = "with", d = "bramble-oak", n = "Bramble-Oak", t = t0, e = stop}
    J[#J + 1] = {k = "group", t = t0, e = stop, z = "Elwynn Forest", pl = 22, ol = 22}
    J[#J + 1] = {k = "death", d = "Deadwind Ogre Mage", a = true, w = "you", t = t0 + 55 * 60, z = "Deadwind Pass", pl = 22, ol = 22}
    J[#J + 1] = {k = "death", w = "them", t = t0 + 56 * 60, z = "Deadwind Pass", pl = 22, ol = 22}
    J[#J + 1] = {k = "death", d = "Mire Lord", a = true, w = "you", t = t0 + 75 * 60, z = "Swamp of Sorrows", pl = 22, ol = 22}
end
A.SelfPerson = function() return me end
if arg and arg[1] == "lines" then
    A.JournalTale.DebugLines = function(day, out, beats, times, S, groups)
        print("## lines " .. tostring(day.key) .. " [" .. tostring(S.composeWhy) .. "]")
        for n, l in ipairs(out) do print(string.format("  %2d %-12s %s %-18s %s %s", n, tostring(beats[n]), times[l] and os.date("%H:%M", times[l]) or "--:--", tostring(S.Z[l] or ""):sub(1, 18), tostring(groups and groups[n] or "-"):sub(1, 8), Plain(l):sub(1, 100))) end
    end
end
local player = {name = "Thrynn", race = "Dwarf", faction = "Alliance", class = "PALADIN", charKey = "thr"}

local function Tell(person, voice, retell, brief)
    person.retell = retell
    local days = A.JournalBook(person)
    local stories = A.JournalTale.Tell(person, days, voice, player, brief or false)
    local out = {}
    for _, d in ipairs(days) do if stories[d.key] and stories[d.key].text ~= "" then out[#out + 1] = stories[d.key].text end end
    return out
end
local function Paragraphs(text)
    local n = 0
    for _ in (text .. "\n\n"):gmatch("(.-)\n\n") do n = n + 1 end
    return n
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
local function Sentences(text)
    local out = {}
    for s in (text .. " "):gmatch("(.-[%.!?])%s") do out[#out + 1] = s end
    return out
end

local seen = {}
for _, voice in ipairs({"you", "we"}) do
    for retell = 0, 3 do
        local tag = " (" .. voice .. " " .. retell .. ")"
        local chapters = Tell(bramble, voice, retell)
        check(#chapters == 4, "four chapters" .. tag)
        local first, day = Plain(chapters[1]), Plain(chapters[2])
        if show then print("== Bramble I" .. tag .. "\n" .. first .. "\n\n== Bramble II" .. tag .. "\n" .. day .. "\n") end
        local again = Tell(bramble, voice, retell)
        check(Plain(again[1]) == first and Plain(again[2]) == day, "deterministic per retell" .. tag)
        -- 1. the first meeting: a short real paragraph from the record
        check(not first:find("short while", 1, true), "no 'a short while together'" .. tag)
        check(first:find("level 13", 1, true), "your level at the meeting, from the record" .. tag)
        check(first:find("past midnight", 1, true), "the hour of the meeting" .. tag)
        check(first:find("Goldshire", 1, true) and first:find("ended", 1, true), "closed where your own book says the night ended" .. tag)
        check(first:find("Bramble", 1, true), "the companion named" .. tag)
        -- 2. the opener keeps the place the record began in, and the close answers it
        check(day:find("began in Stormwind City", 1, true), "the opener names where the evening began" .. tag)
        check(day:find("Westfall", 1, true), "the first the evening opened on is kept" .. tag)
        local closing = Sentences(day)
        closing = closing[#closing] or ""
        check(closing:find("Stormwind City", 1, true), "the close names the place the chapter opened on" .. tag)
        check(not closing:find("died", 1, true) and not closing:find("killed", 1, true), "never a death as the last line" .. tag)
        -- 3. time order, one paragraph an episode
        check(select(1, Order(day, {"Westfall", "Brotherhood", "Defias pillager"})) or select(1, Order(day, {"Westfall", "VanCleef", "Defias pillager"})),
            "the first, the hand-in and the death in time order" .. tag)
        check(Paragraphs(day) <= 8, "eight paragraphs at most" .. tag)
        -- 4. the furniture
        check(not day:find("Hollis", 1, true), "a third who did nothing the record kept is not named" .. tag)
        check(not day:find("Jangolode", 1, true), "a cave nothing happened in is not told" .. tag)
        check(not day:lower():find("flew", 1, true) and not day:lower():find("flight", 1, true), "a flight that led to nothing told is not told" .. tag)
        check(not day:find("Bramble died in Stormwind", 1, true) and not day:find("Bramble was killed in Stormwind", 1, true)
            and not day:find("killed in Stormwind", 1, true), "her death alone in the city is not told" .. tag)
        check(not day:lower():find("quests", 1, true), "no tally of the day's quests" .. tag)
        -- 5. her level, with no deed near it, once before the close
        check(day:find("level 20 by the end of it", 1, true) or day:find("By the end of it, Bramble was level 20", 1, true), "a level with no deed near it stands once before the close" .. tag)
        check(not day:find("Bramble reached level 20.", 1, true) and not day:find("Bramble climbed to level 20.", 1, true), "never a bare level line" .. tag)
        -- 6. the writing
        check(not day:find(":", 1, true) and not first:find(":", 1, true), "no colon" .. tag)
        seen[day] = true
        -- 7. strangers for the Blackrock work: a small adventure, joined, the fight, the parting
        local band = Plain(chapters[3])
        if show then print("== Bramble III" .. tag .. "\n" .. band .. "\n") end
        check(band:find("Tobias", 1, true) or band:find("stranger", 1, true), "the strangers who came for the work are told" .. tag)
        check(not band:find("Wick", 1, true) and not band:find("gnome mage", 1, true), "one along four minutes, for nothing told, is not" .. tag)
        check(band:find("no common ones", 1, true) or band:find("hard fighting", 1, true), "a long fight among elites, said once, subtly" .. tag)
        check(not band:find("elite", 1, true) and not band:find("eight", 1, true), "never a count of elites, never the word" .. tag)
        check(band:find("their own way", 1, true) or band:find("company parted", 1, true), "the company parts" .. tag)
        local joinAt = band:find("joined", 1, true) or band:find("fell in with", 1, true) or band:find("went with", 1, true) or band:find("travelled with", 1, true)
        local partAt = band:find("their own way", 1, true) or band:find("company parted", 1, true)
        check(joinAt and partAt and joinAt < partAt, "joined before the parting" .. tag)
        -- 8. the long walk: one paragraph, the lands in order, the firsts folded, the way back
        local road = Plain(chapters[4])
        if show then print("== Bramble IV" .. tag .. "\n" .. road .. "\n") end
        check(road:lower():find("on foot", 1, true), "the walk is told as a walk" .. tag)
        check(select(1, Order(road, {"Duskwood", "Deadwind Pass", "Swamp of Sorrows"})), "the lands in order" .. tag)
        check(road:find("well above", 1, true), "how far above you, once" .. tag)
        check(road:find("back to Deadwind Pass", 1, true), "where it turned back" .. tag)
        check(not road:find("first time in", 1, true) and not road:find("never seen", 1, true) and not road:find("never set foot", 1, true), "the firsts folded" .. tag)
        local walkPara
        for p in (road .. "\n\n"):gmatch("(.-)\n\n") do if p:lower():find("on foot", 1, true) then walkPara = p end end
        check(walkPara and walkPara:find("Mire Lord", 1, true) or walkPara and walkPara:find("mire lord", 1, true), "the dangers are the road's own lines, in its paragraph" .. tag)
        check(not road:find(":", 1, true) and not band:find(":", 1, true), "no colon (III, IV)" .. tag)
    end
end
-- Highlights: the same rules hold, shorter
for _, voice in ipairs({"you", "we"}) do
    local chapters = Tell(bramble, voice, 0, true)
    local day = Plain(chapters[2] or "")
    check(not day:find("Hollis", 1, true) and not day:find("Jangolode", 1, true), "Highlights: the furniture stays out" .. " (" .. voice .. ")")
end
-- Off: T.COMPOSE = false leaves the teller's own order
A.JournalTale.COMPOSE = false
do
    local chapters = Tell(bramble, "you", 0)
    check(#chapters == 4, "the switch off still tells every day")
end
A.JournalTale.COMPOSE = true

print("PASS: " .. assertions .. " companion composer assertions")
