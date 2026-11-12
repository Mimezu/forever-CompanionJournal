-- Run from the client root: lua5.1 Interface/AddOns/CompanionJournal/tests/CompanionTogether.lua [print]
-- The companion's book as a shared story (lane C9, 2026-11-12; the player: "more focus on we,
-- more focus on the kind of relationship, more about the companionship and shared adventure").
-- Two Forsaken who rose together (both at level one on the first day): the race's own beginning
-- with the bond inside the sentence, never a label line; levels gained side by side said once;
-- the close about the two of them and where the night left them (a close bond ends the night
-- together or parts for the night, a friend calls it a night), never "the work for X was done";
-- no "in the party again", no "during our time together", no list of places; the first raise its
-- own sentence; the first dungeon together; five days in a row for a close bond only; a fire kept
-- for a close bond. The same record told for a spouse, a friend and no bond, both voices.
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
check(A.JournalTale.ComposeTogether and A.JournalTale.BondKind, "the shared-story pass is there")

local BASE = os.time({year = 2026, month = 10, day = 5, hour = 0})
local function At(day, hour, minute) return BASE + day * 86400 + math.floor((hour or 20) * 3600) + (minute or 0) * 60 end
local function Plain(text) return (A.JournalPlain and A.JournalPlain(text) or text) end

local me = {self = true, charKey = "alb", name = "Alberich", race = "Scourge", faction = "Horde", class = "PALADIN", startLevel = 1, journal = {}}
local dahlia = {name = "Dahlia-Noir", class = "MAGE", race = "Scourge", pronouns = "she", journal = {}, key = "dahlia-noir"}
A.db.people["dahlia-noir"] = dahlia
local M, J = me.journal, dahlia.journal

-- Day 1: both rise at level one in Tirisfal; four levels side by side; quests; a death of yours;
-- a fire after it; the night ends where it began.
do
    local t0, stop = At(1, 20, 0), At(1, 23, 0)
    M[#M + 1] = {k = "play", t = t0, e = stop, z = "Tirisfal Glades", pl = 1}
    M[#M + 1] = {k = "with", d = "dahlia-noir", n = "Dahlia-Noir", t = t0, e = stop}
    J[#J + 1] = {k = "group", t = t0, e = stop, z = "Tirisfal Glades", pl = 1, ol = 1}
    for i, lv in ipairs({2, 3, 4, 5}) do
        J[#J + 1] = {k = "mylevel", d = tostring(lv), t = t0 + i * 30 * 60, z = "Tirisfal Glades", pl = lv - 1, ol = lv - 1}
        J[#J + 1] = {k = "level", d = tostring(lv), t = t0 + i * 30 * 60 + 120, z = "Tirisfal Glades", pl = lv, ol = lv}
    end
    J[#J + 1] = {k = "quest", d = "The Mindless Ones", qid = 364, ql = 2, t = t0 + 20 * 60, z = "Tirisfal Glades", pl = 1, ol = 1}
    J[#J + 1] = {k = "quest", d = "Marla's Last Wish", qid = 6395, ql = 5, t = t0 + 100 * 60, z = "Tirisfal Glades", pl = 4, ol = 4}
    J[#J + 1] = {k = "death", d = "Vampiric Duskbat", w = "you", t = t0 + 130 * 60, z = "Tirisfal Glades", pl = 5, ol = 5}
    J[#J + 1] = {k = "quest", d = "The Red Messenger", qid = 382, ql = 5, t = t0 + 135 * 60, z = "Tirisfal Glades", pl = 5, ol = 5}
    J[#J + 1] = {k = "campfire", t = t0 + 140 * 60, z = "Tirisfal Glades", pl = 5, ol = 5}
end
-- Days 2 to 5, every day: quests in Tirisfal and Silverpine; day 4 a dungeon, her death and the
-- first raise of your life; day 5 the fifth day in a row.
for d = 2, 5 do
    local t0, stop = At(d, 20, 0), At(d, 22, 30)
    local zone = (d % 2 == 0) and "Tirisfal Glades" or "Silverpine Forest"
    M[#M + 1] = {k = "play", t = t0, e = stop + 30 * 60, z = zone, pl = 5 + d}
    M[#M + 1] = {k = "with", d = "dahlia-noir", n = "Dahlia-Noir", t = t0, e = stop}
    J[#J + 1] = {k = "group", t = t0, e = stop, z = zone, pl = 5 + d, ol = 5 + d}
    if zone == "Tirisfal Glades" then
        J[#J + 1] = {k = "quest", d = "Fields of Grief", qid = 365, ql = 7, t = t0 + 40 * 60, z = zone, pl = 5 + d, ol = 5 + d}
        J[#J + 1] = {k = "quest", d = "Gordo's Task", qid = 5481, ql = 5, t = t0 + 70 * 60, z = zone, pl = 5 + d, ol = 5 + d}
    else
        J[#J + 1] = {k = "quest", d = "The Dead Fields", qid = 437, ql = 12, t = t0 + 40 * 60, z = zone, pl = 5 + d, ol = 5 + d}
        J[#J + 1] = {k = "quest", d = "Lost Deathstalkers", qid = 428, ql = 12, t = t0 + 70 * 60, z = zone, pl = 5 + d, ol = 5 + d}
    end
    if d == 4 then
        J[#J + 1] = {k = "death", w = "them", t = t0 + 90 * 60, z = zone, pl = 9, ol = 9}
        M[#M + 1] = {k = "first", d = "rezother", n = "Dahlia", t = t0 + 92 * 60, z = zone, pl = 9}
        J[#J + 1] = {k = "rez", w = "you", t = t0 + 92 * 60, z = zone, pl = 9, ol = 9}
    end
end

-- Marrow, a friend on his card, in the same party on days 2 to 5 (round 10)
local marrow = {name = "Marrow-Rotmoor", class = "PRIEST", race = "Scourge", pronouns = "he", journal = {}, key = "marrow-rotmoor", bond = "friend"}
A.db.people["marrow-rotmoor"] = marrow
for _, e in ipairs(J) do
    if e.t and e.t >= At(2, 0, 0) then
        local copy = {}
        for k, v in pairs(e) do copy[k] = v end
        if copy.k == "death" and copy.w == "them" then copy = nil end
        if copy then marrow.journal[#marrow.journal + 1] = copy end
    end
end
for d = 2, 5 do M[#M + 1] = {k = "with", d = "marrow-rotmoor", n = "Marrow-Rotmoor", t = At(d, 20, 0), e = At(d, 22, 30)} end
A.SelfPerson = function() return me end
local player = {name = "Alberich", race = "Scourge", faction = "Horde", class = "PALADIN", charKey = "alb"}
local function Tell(bond, voice, retell)
    dahlia.bond, dahlia.retell = bond, retell or 0
    local days = A.JournalBook(dahlia)
    local stories = A.JournalTale.Tell(dahlia, days, voice, player, false)
    local out = {}
    for _, d in ipairs(days) do if stories[d.key] and stories[d.key].text ~= "" then out[#out + 1] = Plain(stories[d.key].text) end end
    return out
end

for _, voice in ipairs({"we", "you"}) do
    for _, bond in ipairs({"spouse", "friend", false}) do
        for retell = 0, 2 do
            local book = Tell(bond or nil, voice, retell)
            local all = table.concat(book, "\n\n")
            if show and retell == 0 then print(("#### bond %s, %s voice\n%s\n"):format(tostring(bond), voice, all)) end
            local where = (" (%s, %s, retell %d)"):format(tostring(bond), voice, retell)
            check(#book >= 4, "a chapter a day" .. where)
            local one = book[1]
            -- the race's own beginning, from the record (both at level one in Tirisfal)
            check(one:find("Deathknell", 1, true) and (one:find("together", 1, true) or one:find("side by side", 1, true)), "the two rose together" .. where .. ": " .. one)
            if bond == "spouse" then
                check(one:find(voice == "we" and "Dahlia, my wife, and I" or "you and Dahlia, your wife,", 1, true) or one:find(voice == "we" and "Dahlia, my wife, and I" or "You and Dahlia, your wife,", 1, true),
                    "the bond inside the sentence" .. where .. ": " .. one)
            end
            check(not all:find(" is my wife", 1, true) and not all:find(" is your wife", 1, true), "never a label line" .. where)
            check(one:find("kept pace", 1, true), "levels side by side, said once" .. where .. ": " .. one)
            local _, paces = all:gsub("kept pace", "")
            check(paces == 1, "levels side by side once in the book" .. where)
            check(not all:find("work for", 1, true), "no close about the work" .. where)
            check(not all:find("in the party again", 1, true) and not all:find("time together.", 1, true), "no party words, no 'during our time together'" .. where)
            check(not all:find("Deathknell, Night", 1, true) and not all:find("Deathknell and %u"), "no list of places" .. where .. ": " .. one)
            if bond == "spouse" then
                check(all:find("ended the night together", 1, true) or all:find("ended the evening together", 1, true) or all:find("parted for the night", 1, true),
                    "a close bond's close is about the two of them" .. where)
                check(book[#book]:find("evenings since", 1, true) and not book[#book]:find("in a row", 1, true), "the latest chapter looks back, no streak counter" .. where .. ": " .. book[#book])
                check(one:find("fire", 1, true) or one:find("camp", 1, true), "the fire kept for a close bond" .. where .. ": " .. one)
            else
                check(not all:find("parted for the night", 1, true) and not all:find("ended the night together", 1, true), "no close-bond words for " .. tostring(bond) .. where)
                check(not all:find("days in a row together", 1, true) and not all:find("in a row that", 1, true), "days in a row only for a close bond" .. where)
            end
            check(not bond or (not all:find("crossing", 1, true) and not all:find("hours after", 1, true)), "no counters in a bonded close" .. where)
            if bond == "friend" then
                check(book[#book]:find("evenings with Dahlia", 1, true), "a friend's look-back" .. where .. ": " .. book[#book])
                check(all:find("called it a night", 1, true) or all:find("own way", 1, true) or all:find(voice == "we" and "Dahlia and I ended" or "You and Dahlia ended", 1, true), "a friend's close" .. where)
            end
            local raise = book[4] or ""
            if raise:find("ever raised", 1, true) then
                check(raise:find("on the Light, and she rose", 1, true), "the first raise its own sentence" .. where .. ": " .. raise)
                if bond == "spouse" then check(raise:find("She was the first", 1, true), "its weight for a close bond" .. where) end
            end
        end
    end
end
-- The two books of one evening share no sentence (a spouse's and a friend's, both voices)
local SKIP = {i = true, me = true, my = true, we = true, us = true, our = true, you = true, your = true}
local function Words(sentence)
    local out = {}
    for at, w in sentence:gmatch("()([%a']+)") do
        local before = at > 1 and sentence:sub(at - 1, at - 1) or " "
        if w:match("^%l") and not SKIP[w] and not before:match("[%a']") then out[w] = true end
    end
    return out
end
local function Sentences(text)
    local out = {}
    for s in (Plain(text) .. " "):gmatch("(.-[%.!?])%s+") do out[s:gsub("^%s+", "")] = true end
    return out
end
for _, voice in ipairs({"we", "you"}) do
    for retell = 0, 2 do
        dahlia.bond, dahlia.retell, marrow.retell = "spouse", retell, retell
        local dd, md = A.JournalBook(dahlia), A.JournalBook(marrow)
        local ds = A.JournalTale.Tell(dahlia, dd, voice, player, false)
        local ms = A.JournalTale.Tell(marrow, md, voice, player, false)
        local compared = 0
        for key, st in pairs(ms) do
            if st.text ~= "" and ds[key] and ds[key].text ~= "" then
                compared = compared + 1
                local mine = Sentences(ds[key].text)
                for sentence in pairs(Sentences(st.text)) do
                    check(not mine[sentence], ("the two books of %s share no sentence (%s, retell %d): %s"):format(key, voice, retell, sentence))
                    -- (round 11: nor a near copy, 70% of the phrasing words of the longer one the same; names and pronouns
                    -- left out, they are the same people and places)
                    local a = Words(sentence)
                    for other in pairs(mine) do
                        local b = Words(other)
                        local na, nb, both = 0, 0, 0
                        for w in pairs(a) do na = na + 1; if b[w] then both = both + 1 end end
                        for _ in pairs(b) do nb = nb + 1 end
                        local least, most = math.min(na, nb), math.max(na, nb)
                        check(least < 6 or both / most < 0.7, ("no near copy on %s (%s, retell %d): %s || %s"):format(key, voice, retell, sentence, other))
                    end
                end
            end
        end
        check(compared >= 3, "the same evenings in both books")
    end
end
print(assertions .. " checks passed")
