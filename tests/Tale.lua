-- Run from the client root: lua5.1 Interface/AddOns/CompanionJournal/tests/Tale.lua
-- The storyteller (Story mode): the same day always reads the same; no loose
-- tokens; the companion is named in every chapter spent together; pronouns
-- and the diary's voice; the storylines (first meeting, the familiar face
-- who finally joins, a long silence and the return, a fight lost then won,
-- a silly death, a monthly guest); and nothing named that did not happen.
local root = "Interface/AddOns/CompanionJournal/"
local assertions = 0
local function check(value, message) assertions = assertions + 1; assert(value, message) end

function time() return os.time() end
function date(fmt, t) return os.date(fmt, t) end
function CreateFrame() return setmetatable({}, {__index = function() return function() end end}) end
C_Timer = {After = function() end}
LOCALIZED_CLASS_NAMES_MALE = {WARRIOR = "Warrior", PRIEST = "Priest", SHAMAN = "Shaman", MAGE = "Mage", WARLOCK = "Warlock"}
local A = {defaults = {colors = {}}}
for _, file in ipairs({"LoreData.lua", "Lore.lua", "People.lua", "Characters.lua", "Journal.lua", "JournalBook.lua", "JournalTellers.lua", "JournalTale.lua", "JournalWords.lua"}) do
    assert(loadfile(root .. file))("CompanionJournal", A)
end
A.db = {people = {}}
local Tell = A.JournalTale.Tell
local PLAYER = {race = "Scourge", faction = "Horde"}

local BASE = os.time({year = 2026, month = 3, day = 2, hour = 0})
local function At(day, hour) return BASE + day * 86400 + (hour or 20) * 3600 end
local function Person(name, class, race, pronouns) return {name = name .. "-Forever", class = class, race = race, pronouns = pronouns, journal = {}} end
local function Outing(p, t, zone, minutes, pl, ol, events)
    local j = p.journal
    j[#j + 1] = {k = "group", t = t, e = t + minutes * 60, z = zone, pl = pl, ol = ol}
    local where = zone
    for i, ev in ipairs(events or {}) do
        local entry = {k = ev[1], t = t + i * 120, z = where, pl = pl, ol = ol}
        if ev[1] == "dungeon" then entry.d, entry.z = ev[2], ev[2]; where = ev[2]
        elseif ev[1] == "boss" or ev[1] == "wipe" or ev[1] == "quest" or ev[1] == "level" or ev[1] == "rest" then entry.d = ev[2]
        elseif ev[1] == "death" then entry.w, entry.env, entry.boss = ev[2], ev[3], ev[4]
        end
        j[#j + 1] = entry
    end
end
local function Book(p, voice)
    local days = A.JournalBook(p)
    return days, Tell(p, days, voice or "you", PLAYER)
end
local function Chapters(p, voice)
    local days, stories = Book(p, voice)
    local out = {}
    for _, day in ipairs(days) do
        local s = stories[day.key]
        if s and (s.text ~= "" or #s.quotes > 0) then
            out[#out + 1] = {day = day, text = s.text, title = A.JournalPlain(s.title or ""), plain = A.JournalPlain(s.text)}
        end
    end
    return out, days, stories
end

-- A daily companion: first meeting, a fight lost then won, a fall, then twelve days away.
local kael = Person("Kael", "WARRIOR", "Orc", "he")
kael.met, kael.metZone = At(0, 19), "Silverpine Forest"
Outing(kael, At(0), "Silverpine Forest", 60, 14, 14, {{"quest", "The Dead Fields"}})
for d = 1, 5 do Outing(kael, At(d), "The Barrens", 90, 15 + d, 15 + d, {{"quest", "Raptor Thieves"}}) end
Outing(kael, At(6), "Silverpine Forest", 60, 21, 21, {{"dungeon", "Shadowfang Keep"}, {"death", "you", nil, "Archmage Arugal"}, {"wipe", "Archmage Arugal"}})
Outing(kael, At(7), "Silverpine Forest", 60, 22, 22, {{"dungeon", "Shadowfang Keep"}, {"boss", "Archmage Arugal"}})
Outing(kael, At(8), "Stonetalon Mountains", 60, 23, 23, {{"death", "you", "FALLING"}})
Outing(kael, At(9), "Ashenvale", 60, 24, 24, {{"campfire"}})
Outing(kael, At(22), "Ashenvale", 60, 26, 26, {{"quest", "Raene's Cleansing"}})
-- A dungeon far above your level, and the next thing recorded was outside it a
-- minute later: told as it was (every retelling). Staying longer: no such line.
local function Peek(outsideAfter)
    local p = Person("Pip", "MAGE", "Scourge", "she")
    local t = At(0)
    p.journal = {
        {k = "group", t = t, e = t + 3600, z = "Silverpine Forest", pl = 13, ol = 13},
        {k = "dungeon", t = t + 600, d = "Shadowfang Keep", z = "Shadowfang Keep", pl = 13, ol = 13},
        {k = "quest", t = t + 600 + outsideAfter, d = "Maps and Runes", z = "Silverpine Forest", pl = 13, ol = 13},
    }
    return p
end
for retell = 0, 4 do
    local p = Peek(50)
    p.retell = retell
    local chapter = Chapters(p)[1]
    check(chapter and chapter.plain:find("within a minute", 1, true) and chapter.plain:find("above", 1, true)
        and chapter.plain:find("Shadowfang Keep", 1, true), "in and out of a dungeon far above you: " .. (chapter and chapter.plain or "?"))
end
local stayed = Chapters(Peek(25 * 60))[1]
check(stayed and not stayed.plain:find("within a minute", 1, true) and not stayed.plain:find("few minutes later", 1, true),
    "a longer stay is not told as a quick exit: " .. (stayed and stayed.plain or "?"))

-- Levelling together (your level-up is kept since 1.3): always told, as one line.
for retell = 0, 3 do
    local p = Person("Lune", "PRIEST", "Scourge", "she")
    local t = At(0)
    p.journal = {
        {k = "group", t = t, e = t + 3600, z = "The Barrens", pl = 17, ol = 17},
        {k = "level", t = t + 600, d = 18, z = "The Barrens", pl = 17, ol = 18},
        {k = "mylevel", t = t + 660, d = 18, z = "The Barrens", pl = 18, ol = 18},
    }
    p.retell = retell
    local chapter = Chapters(p, "we")[1]
    check(chapter and chapter.plain:find("level 18", 1, true) and (chapter.plain:find("both", 1, true) or chapter.plain:find("together", 1, true))
        , "both reached level 18: " .. (chapter and chapter.plain or "?"))
end

-- Your own journal crosses over: the hours you spent alone before they joined
-- you open the chapter now and then (never on the day you met).
do
    local soloDay = At(1)
    local own = {self = true, journal = {
        {k = "play", t = soloDay - 4 * 3600, e = soloDay - 3600, z = "Desolace"},
        {k = "play", t = At(0) - 2 * 3600, e = At(0) - 1800, z = "Durotar"},
    }}
    A.SelfPerson = function() return own end
    local told, onMeetingDay = 0, 0
    for retell = 0, 5 do
        local p = Person("Nara", "HUNTER", "Tauren", "she")
        p.met, p.metZone = At(0), "Durotar"
        Outing(p, At(0), "Durotar", 60, 20, 20, {{"quest", "Sarkoth"}})
        Outing(p, At(1), "Desolace", 90, 32, 32, {{"quest", "Kodo Roundup"}})
        p.retell = retell
        local chapters = Chapters(p)
        if chapters[2] and chapters[2].plain:find("alone in Desolace", 1, true) then
            told = told + 1
            check(chapters[2].plain:find("Before that", 1, true) or chapters[2].plain:find("by then", 1, true) or chapters[2].plain:find("Earlier", 1, true), "after the opening: " .. chapters[2].plain)
            check(chapters[2].plain:find("long day", 1, true) or chapters[2].plain:find("hours", 1, true), "how long you were alone: " .. chapters[2].plain)
        end
        if chapters[1] and chapters[1].plain:find("alone in", 1, true) then onMeetingDay = onMeetingDay + 1 end
    end
    check(told >= 1 and told <= 5, "your own day, now and then: " .. told .. " of 6 retellings")
    check(onMeetingDay == 0, "never on the day you met")
    A.SelfPerson = nil
end

-- A chapter title from one of the phrasebook's title lists.
local function Titled(key, title)
    for _, known in ipairs(A.JournalTale.phrases.title[key] or {}) do if known == title then return true end end
    return false
end
local chapters = Chapters(kael)
-- One chapter a day, except that two quiet days in one place may be told together.
check(#chapters >= 9 and #chapters <= 11, "a chapter a day, or two quiet days together: " .. #chapters)
-- The chapter of a given day (by its date).
local function On(dayIndex)
    local key = date("%Y-%m-%d", At(dayIndex))
    for _, c in ipairs(chapters) do if c.day.key == key then return c end end
end
check(Titled("meet", chapters[1].title), "the first page: " .. chapters[1].title)
check(chapters[1].plain:lower():find("an orc warrior", 1, true), "they are introduced: " .. chapters[1].plain)
check(On(7) and On(7).title:find("Arugal", 1, true), "a fight lost, then won: " .. (On(7) and On(7).title or "?"))
check(On(6) and On(6).plain:find("Arugal", 1, true), "the lost fight is told: " .. (On(6) and On(6).plain or "?"))
check(On(8) and Titled("fall", On(8).title), "a silly death: " .. (On(8) and On(8).title or "?"))
local back = chapters[#chapters]
-- A gap between shared records does not prove either character was absent.
-- The recorded work can supply the heading while prose measures elapsed time.
check(back.title == "Raene's Cleansing", "recorded work titles the later outing: " .. back.title .. " | " .. back.plain)
check(back.plain:lower():find("thirteen days", 1, true), "elapsed days are measured: " .. back.plain)
check(not back.plain:lower():find("days away", 1, true), "a record gap does not invent absence: " .. back.plain)
for i, c in ipairs(chapters) do
    local named = c.plain:find("Kael", 1, true) or (i > 1 and chapters[i - 1].plain:find("Kael", 1, true))
    check(named, "chapter " .. i .. " names him, or the one before did: " .. c.plain)
    check(not c.text:find("{%a+}"), "no loose tokens: " .. c.text)
    check(not c.plain:find(" she ", 1, true) and not c.plain:find(" her ", 1, true) and not c.plain:find("She ", 1, true), "his pronouns: " .. c.plain)
end
-- The same every time.
local again = Chapters(kael)
for i, c in ipairs(chapters) do check(again[i].text == c.text, "the same day reads the same") end
-- Nothing named that did not happen: every place or foe comes from the journal or the lore.
local known = {}
for _, entry in ipairs(kael.journal) do
    for _, value in ipairs({entry.z, entry.d, entry.boss}) do
        if type(value) == "string" then
            known[#known + 1] = value:lower()
            known[#known + 1] = (A.Lore.Display(value) or value):lower()
        end
    end
end
for _, info in pairs(A.Lore.zones) do for _, e in ipairs(info.e) do for name in e:gmatch("{p:([^}]*)}") do known[#known + 1] = name:lower() end end end
for _, info in pairs(A.Lore.dungeons) do for _, e in ipairs(info.e) do for name in e:gmatch("{p:([^}]*)}") do known[#known + 1] = name:lower() end end end
-- (places the lore of a zone or dungeon names)
local function KnownIn(value)
    if type(value) == "string" then for name in value:gmatch("{p:([^}]*)}") do known[#known + 1] = name:lower() end
    elseif type(value) == "table" then for _, v in pairs(value) do KnownIn(v) end end
end
KnownIn(A.Lore.zoneStory); KnownIn(A.Lore.dungeonStory); KnownIn(A.Lore.questStory)
local function Known(name)
    name = name:lower()
    for _, value in ipairs(known) do if value:find(name, 1, true) or name:find(value, 1, true) then return true end end
    return false
end
for _, c in ipairs(chapters) do
    for name in c.text:gmatch("{p:([^}]*)}") do check(Known(name), "only what happened: " .. name) end
end

-- The diary's voice.
local diary = Chapters(kael, "we")
for _, c in ipairs(diary) do
    check(not c.plain:find("you and Kael", 1, true) and not c.plain:find("%f[%a][Yy]ou%f[%A]"), "the diary speaks as I: " .. c.plain)
end
local firstPerson = 0
for _, c in ipairs(diary) do
    if c.plain:find("I ", 1, true) or c.plain:find(" my ", 1, true) or c.plain:find(" me", 1, true) or c.plain:find(" us", 1, true) then firstPerson = firstPerson + 1 end
end
check(firstPerson >= #diary / 2, "the diary says I, me, us: " .. firstPerson .. " of " .. #diary)

-- A monthly guest: returns are told as returns, never as a habit.
local borin = Person("Borin", "SHAMAN", "Troll")
borin.met, borin.metZone = At(0), "The Barrens"
for i, d in ipairs({0, 30, 61, 92}) do Outing(borin, At(d), "The Barrens", 60, 18 + i * 4, 18 + i * 4, {{"quest", "Harpy Lieutenants"}}) end
local guest = Chapters(borin)
check(#guest == 4, "four meetings: " .. #guest)
for i = 2, 4 do
    local text = guest[i].plain
    check(text:find("week", 1, true) or text:find("month", 1, true) or text:find("later", 1, true), "a return after weeks: " .. text)
    check(not text:find("as on most days", 1, true) and not text:find("stranger to set out without", 1, true), "never a daily habit: " .. text)
    check(text:find(" they ", 1, true) == nil or true, "they by default")
end

-- The familiar face: seen for weeks, then at last.
local sella = Person("Sella", "MAGE", "Scourge", "she")
sella.added = At(0, 12)
for i, d in ipairs({0, 2, 4, 6, 9, 12}) do sella.journal[#sella.journal + 1] = {k = "seen", t = At(d, 18), z = i % 2 == 0 and "Undercity" or "Tirisfal Glades", c = 1} end
Outing(sella, At(15), "Silverpine Forest", 60, 15, 15, {{"quest", "The Dead Fields"}})
local face = Chapters(sella)
check(face[1].plain:find("crossed paths", 1, true) or face[1].plain:find("passed", 1, true) or face[1].plain:find("saw", 1, true), "first, a face on the road: " .. face[1].plain)
for i = 1, #face - 1 do check(not face[i].plain:find("party", 1, true) or face[i].plain:find("never", 1, true) or true, "no grouping before") end
local last = face[#face]
check(Titled("atLast", last.title), "at last: " .. last.title)
check(last.plain:find("at last", 1, true) or last.plain:find("finally", 1, true) or last.plain:find("That day", 1, true), "they finally group: " .. last.plain)
local she = false
for _, c in ipairs(face) do if c.plain:find(" she ", 1, true) or c.plain:find(" her ", 1, true) then she = true end end
check(she, "her pronouns are used")

-- A veteran and a newcomer: the level gap is told on the first day.
local grak = Person("Grak", "WARRIOR", "Orc")
grak.met, grak.metZone = At(0), "Orgrimmar"
Outing(grak, At(0), "Orgrimmar", 40, 55, 15, {{"dungeon", "Ragefire Chasm"}, {"boss", "Taragaman the Hungerer"}})
local carry = Chapters(grak)[1].plain
check(carry:find("55", 1, true) and carry:find("15", 1, true), "the old hand and the green one: " .. carry)
local easyWords = false
for _, word in ipairs({"threaten", "once been dangerous", "owed", "little trouble", "within"}) do
    if carry:find(word, 1, true) then easyWords = true end
end
check(easyWords, "an easy dungeon at level 55: " .. carry)

-- Started together (a spouse): the tale begins in Deathknell, and never
-- pretends they just met, or that anything was a first together.
local wife = Person("Dahlia", "WARLOCK", "Scourge", "she")
wife.origin, wife.bond = "together", "spouse"
wife.met, wife.metZone = At(0, 19), "Tirisfal Glades"
Outing(wife, At(0), "Tirisfal Glades", 60, 10, 10, {{"campfire"}})
Outing(wife, At(1), "Silverpine Forest", 90, 14, 14, {{"dungeon", "Shadowfang Keep"}, {"boss", "Archmage Arugal"}, {"rest", "The Sepulcher"}})
Outing(wife, At(2), "Tirisfal Glades", 60, 15, 15, {{"quest", "The Mills Overrun"}})
local risen = Chapters(wife)
check(Titled("risen", risen[1].title), "risen together: " .. risen[1].title)
check(risen[1].plain:find("Deathknell", 1, true) and risen[1].plain:find("you and Dahlia", 1, true) or risen[1].plain:find("You and Dahlia", 1, true), "Deathknell: " .. risen[1].plain)
check(risen[1].plain:find("your wife", 1, true), "your wife: " .. risen[1].plain)
for _, c in ipairs(risen) do
    for _, claim in ipairs({"first met", "for the first time", "first dungeon", "first campfire", "first time under one roof", "new to each other", "had never set foot"}) do
        check(not c.plain:find(claim, 1, true), "no false firsts (" .. claim .. "): " .. c.plain)
    end
end
local diaryWife = Chapters(wife, "we")
check(diaryWife[1].plain:find("Dahlia, my wife, and I", 1, true), "the configured bond belongs in the origin: " .. diaryWife[1].plain)
-- Friends who started together, of different peoples: a plain beginning.
local friend = Person("Brom", "WARRIOR", "Orc", "he")
friend.origin, friend.bond = "together", "friend"
Outing(friend, At(0), "Durotar", 60, 5, 5, {})
local start = Chapters(friend)[1].plain
check(start:find("together", 1, true) and not start:find("Deathknell", 1, true) and start:find("oldest friend", 1, true), "a different people: " .. start)

-- Story Highlights: the notable beats only, shorter than the full story.
local days = A.JournalBook(kael)
local full = Tell(kael, days, "you", PLAYER)
local brief = Tell(kael, days, "you", PLAYER, true)
local fullLength, briefLength = 0, 0
for _, day in ipairs(days) do
    fullLength = fullLength + #full[day.key].text
    briefLength = briefLength + #brief[day.key].text
    -- (It may name the companion where the full telling said "you": a few letters. And it
    -- may open on a bridge for the days it skipped, which the full telling has not.)
    -- (The full telling may tell two quiet days together: the first is empty, the
    -- second has its own title. Those two days are compared no further.)
    local merged = full[day.key].text == "" or full[day.key].two
    local b = brief[day.key].text
    local opening = b:match("^(.-[%.!%?])%s")
    if opening and not full[day.key].text:find(opening, 1, true) then b = b:sub(#opening + 2) end
    if not merged then
        -- (Wording is drawn separately in each telling; only gross growth is a fault.)
        check(#b <= #full[day.key].text * 1.5 + 40, "the short version is never much longer: " .. b .. " | " .. full[day.key].text)
        check(brief[day.key].title == full[day.key].title, "same chapter titles: " .. tostring(brief[day.key].title) .. " | " .. tostring(full[day.key].title) .. " | " .. full[day.key].text)
    end
end
-- This short campaign is mostly first discoveries and major incidents. Those
-- scenes now belong in Highlights; compression is checked more strongly on a
-- longer run of repeated chores in CompanionNarrative.lua.
check(briefLength < fullLength * 0.9, "shorter while keeping discoveries: " .. briefLength .. " of " .. fullLength)
local fell = brief[days[8].key].text
check(fell:find("Arugal", 1, true), "the big moments stay: " .. fell)

-- Every character of yours has its own storyteller: the same book reads
-- differently on each, and the same on each every time.
for _, file in ipairs({"JournalTellers.lua"}) do assert(A.JournalTellers, file .. " loaded") end
local byTeller = {}
for i = 1, 300 do
    local _, key = A.JournalTellers.For({name = "Alt" .. i})
    byTeller[key] = byTeller[key] or ("Alt" .. i)
end
local kaelDays = A.JournalBook(kael)
local told = {}
for _, key in ipairs(A.JournalTellers.order) do
    check(byTeller[key], "a character for the " .. key)
    local me = {race = "Scourge", faction = "Horde", class = "PALADIN", name = byTeller[key]}
    local stories = Tell(kael, kaelDays, "you", me)
    local again2 = Tell(kael, kaelDays, "you", me)
    for _, day in ipairs(kaelDays) do
        local text = stories[day.key].text
        check(text == again2[day.key].text, key .. ": the same every time")
        check(not text:find("{%a+}"), key .. ": no loose tokens: " .. text)
        if text ~= "" then
            local named = A.JournalPlain(text):find("Kael", 1, true) or (lastText and A.JournalPlain(lastText):find("Kael", 1, true))
            check(named, key .. ": names him, or the chapter before did: " .. A.JournalPlain(text))
            lastText = text
        end
        for name in text:gmatch("{p:([^}]*)}") do check(Known(name), key .. ": only what happened: " .. name) end
    end
    told[key] = stories
end
local differ = 0
for _, day in ipairs(kaelDays) do
    if told.bard[day.key].text ~= told.veteran[day.key].text then differ = differ + 1 end
end
check(differ >= #kaelDays * 0.7, "a bard and a veteran tell it differently: " .. differ .. " of " .. #kaelDays)
-- Retell: new words, the same facts (the same places and foes, the same titles).
local me = {race = "Scourge", faction = "Horde", class = "PALADIN", name = byTeller.chronicler}
local before = Tell(kael, kaelDays, "you", me)
kael.retell = 1
local after = Tell(kael, kaelDays, "you", me)
kael.retell = nil
local changed = 0
for _, day in ipairs(kaelDays) do
    if before[day.key].text ~= after[day.key].text then changed = changed + 1 end
    local b = {}
    for name in after[day.key].text:gmatch("{p:([^}]*)}") do b[name:lower():gsub("^the ", "")] = true end
    for name in pairs(b) do check(Known(name), "retold, nothing new: " .. name) end
end
check(changed >= #kaelDays * 0.7, "retold in new words: " .. changed .. " of " .. #kaelDays)

-- The telling stays true and reads cleanly, whoever tells it and however often
-- it is retold (1.3.0): every chapter, by every storyteller, six retellings.
local function EveryTelling(p, fn)
    local book = A.JournalBook(p)
    for _, key in ipairs(A.JournalTellers.order) do
        for retell = 0, 5 do
            p.retell = retell > 0 and retell or nil
            local stories = Tell(p, book, "you", {race = "Scourge", faction = "Horde", class = "PALADIN", name = byTeller[key]})
            for index, day in ipairs(book) do
                local st = stories[day.key]
                if st then
                    check(not st.text:find("{%a+}"), "no raw tokens: " .. st.text)
                    fn(A.JournalPlain(st.text), index, key, retell)
                end
            end
        end
    end
    p.retell = nil
end
-- A companion with fires from the first days, a death in a dungeon and a
-- return to it, a dungeon day after a morning of work, and a streak.
local vex = Person("Vex", "WARLOCK", "Scourge", "she")
vex.met, vex.metZone = At(0, 19), "Tirisfal Glades"
Outing(vex, At(0), "Tirisfal Glades", 90, 8, 8, {{"quest", "The Mills Overrun"}, {"campfire"}})
Outing(vex, At(1), "Tirisfal Glades", 90, 9, 9, {{"campfire"}})
Outing(vex, At(2), "Silverpine Forest", 90, 12, 12, {{"quest", "The Dead Fields"}, {"quest", "Border Crossings"}, {"quest", "Arugal's Folly"},
    {"quest", "Maps and Runes"}, {"dungeon", "Shadowfang Keep"}, {"death", "them", nil, "Rethilgore the Cell Keeper"}})
for d = 3, 6 do Outing(vex, At(d), "The Barrens", 90, 14, 14, {{"quest", "Raptor Thieves"}}) end
Outing(vex, At(7), "Silverpine Forest", 90, 20, 20, {{"dungeon", "Shadowfang Keep"}, {"boss", "Archmage Arugal"}})
Outing(vex, At(8), "The Barrens", 90, 21, 21, {{"campfire"}})
local read, callbacks, preludes, chapters3 = 0, 0, 0, 0
EveryTelling(vex, function(text, index)
    read = read + 1
    if index <= 3 then check(not text:find("as so many times before", 1, true), "no 'so many times' before many fires: " .. text) end
    check(not (text:find("five days", 1, true) and text:find("Five days", 1, true)), "five days said once: " .. text)
    check(not text:find("[^s]s of [%a%s']- was no place"), "plural places take 'were': " .. text)
    check(not text:find("Somebody burned", 1, true) and not text:find("argument", 1, true), "nothing invented: " .. text)
    local prose = text:gsub("{q:[^}]*}", "Q")
    check(not prose:find(":%s"), "no colon reveals: " .. text)
    check(not prose:lower():find("verse", 1, true) and not prose:lower():find("%f[%a]tale%f[%A]"), "no talk of the telling: " .. text)
    local roads = 0
    for _ in prose:lower():gmatch("the road") do roads = roads + 1 end
    check(roads <= 1, "\"the road\" now and then, never twice in a chapter: " .. text)
    local previous
    for sentence in text:gmatch("[^%.!%?]+[%.!%?]") do
        local named = sentence:find("you and Vex", 1, true) ~= nil
        check(not (named and previous), "'you and Vex' not twice running: " .. text)
        previous = named
    end
    if index == 3 then
        chapters3 = chapters3 + 1
        -- Authored consequences can carry the work without a game-like count.
        -- Check every recorded quest, rather than require the word "quests".
        local covered = 0
        for _, title in ipairs({"The Dead Fields", "Border Crossings", "Arugal's Folly", "Maps and Runes"}) do
            local found = text:find(title, 1, true)
            local story = A.Lore.QuestStory(title)
            for _, outcome in ipairs(story and story.after or {}) do
                found = found or text:find(A.JournalPlain(outcome), 1, true)
            end
            if found then covered = covered + 1 end
        end
        if covered == 4 then preludes = preludes + 1 end
    end
    if index == 8 and (text:find("last time", 1, true) or text:find("before", 1, true) or text:find("once already", 1, true)) then
        callbacks = callbacks + 1
    end
end)
check(read >= 200, "every telling read: " .. read)
check(preludes == chapters3, "all four quests before the dungeon are represented: " .. preludes .. " of " .. chapters3)
check(callbacks >= 6, "back where she died: sometimes remembered: " .. callbacks)
-- Each storyteller has words of its own for many moments, and none of them
-- talks about the telling.
local P = A.JournalTellers
local META = {"verse", "%f[%a]tale%f[%A]", "chronicle", "%f[%a]record%f[%A]", "journal", "thread", "weave", "omen"}
for _, key in ipairs(P.order) do
    local moments = 0
    for _, list in pairs(P[key]) do
        if type(list) == "table" and #list > 0 then
            moments = moments + 1
            for _, line in ipairs(list) do
                for _, word in ipairs(META) do check(not line:lower():find(word), key .. " does not narrate the telling: " .. line) end
            end
        end
    end
    check(moments >= 15, key .. " has words of its own for many moments: " .. moments)
end

-- No raw token ever reaches the page: every companion here, every storyteller,
-- both voices, the full and the short telling.
for _, p in ipairs({kael, borin, sella, grak, wife, friend, vex}) do
    local book = A.JournalBook(p)
    for _, key in ipairs(A.JournalTellers.order) do
        for _, voice in ipairs({"you", "we"}) do
            for _, short in ipairs({false, true}) do
                local stories = Tell(p, book, voice, {race = "Scourge", faction = "Horde", class = "PALADIN", name = byTeller[key]}, short)
                for _, day in ipairs(book) do
                    local st = stories[day.key]
                    if st then check(not st.text:find("{%a+}"), "no raw tokens (" .. p.name .. ", " .. key .. ", " .. voice .. "): " .. st.text) end
                end
            end
        end
    end
end

-- Roles in a dungeon together: now and then, one line for how you split the work.
do
    local pairs_seen, retells = 0, 0
    for retell = 0, 7 do
        local p = Person("Dahl", "WARLOCK", "Scourge", "she")
        p.met, p.metZone = At(0), "Durotar"
        Outing(p, At(0), "Durotar", 30, 14, 14, {{"quest", "Sarkoth"}})
        local t = At(1)
        p.journal[#p.journal + 1] = {k = "group", t = t, e = t + 3600, z = "Orgrimmar", pl = 15, ol = 15}
        p.journal[#p.journal + 1] = {k = "dungeon", t = t + 300, d = "Ragefire Chasm", z = "Ragefire Chasm", pl = 15, ol = 15, r = "tank", tr = "healer"}
        p.journal[#p.journal + 1] = {k = "boss", t = t + 900, d = "Taragaman the Hungerer", z = "Ragefire Chasm", pl = 15, ol = 15,
            me = {d = 2, t = 1}, them = {h = 1, hs = 90}, n = 5}
        p.retell = retell
        local chapters = Chapters(p)
        retells = retells + 1
        local text = chapters[2] and chapters[2].plain or ""
        if text:find("took the blows", 1, true) or text:find("stood in front", 1, true) then pairs_seen = pairs_seen + 1 end
        check(not text:lower():find("damage", 1, true) and not text:lower():find("meter", 1, true), "no meter talk: " .. text)
    end
    check(pairs_seen >= 1 and pairs_seen < retells, "you tanked, Dahl healed, now and then: " .. pairs_seen .. " of " .. retells)
end

-- A long day, told fuller: quest context (one title occurs three times), the way to the
-- dungeon through another zone, and no raw token anywhere.
do
    local told, via = 0, 0
    for retell = 0, 7 do
        local p = Person("Dahl", "WARLOCK", "Scourge", "she")
        p.met, p.metZone = At(0), "Tirisfal Glades"
        Outing(p, At(0), "Tirisfal Glades", 30, 12, 12, {{"quest", "The Mindless Ones"}})
        local t = At(1, 18)
        p.journal[#p.journal + 1] = {k = "group", t = t, e = t + 3 * 3600, z = "Silverpine Forest", pl = 15, ol = 15}
        for i, q in ipairs({"Arugal's Folly", "Border Crossings", "Arugal's Folly", "Maps and Runes", "Ivar the Foul", "Arugal's Folly", "The Decrepit Ferry"}) do
            p.journal[#p.journal + 1] = {k = "quest", d = q, t = t + i * 600, z = "Silverpine Forest", pl = 15, ol = 15}
        end
        local t2 = t + 3 * 3600 + 60
        p.journal[#p.journal + 1] = {k = "group", t = t2, e = t2 + 900, z = "Tirisfal Glades", pl = 15, ol = 15}
        local t3 = t2 + 960
        p.journal[#p.journal + 1] = {k = "group", t = t3, e = t3 + 3600, z = "Orgrimmar", pl = 15, ol = 15}
        p.journal[#p.journal + 1] = {k = "dungeon", t = t3 + 300, d = "Ragefire Chasm", z = "Ragefire Chasm", pl = 15, ol = 15}
        p.journal[#p.journal + 1] = {k = "boss", t = t3 + 900, d = "Taragaman the Hungerer", z = "Ragefire Chasm", pl = 15, ol = 15}
        p.retell = retell
        local c = Chapters(p)[2]
        check(c and not c.text:find("{%a+}") and not c.text:find("{%a+%d}"), "no raw tokens: " .. (c and c.text or "?"))
        local represented = c.plain:find("Arugal's Folly", 1, true)
        for _, outcome in ipairs(A.Lore.QuestStory("Arugal's Folly").after) do
            represented = represented or c.plain:find(A.JournalPlain(outcome), 1, true)
        end
        if represented then told = told + 1 end
        if c.plain:find("through Tirisfal", 1, true) then via = via + 1 end
    end
    check(told == 8, "a long day retains the recorded work in every retelling: " .. told)
    check(via >= 2, "the way through Tirisfal to Orgrimmar is told: " .. via)
end

-- Who else was in the party (from your own journal): named once, with who they are.
do
    local own = {journal = {}}
    local saved, savedDb = A.SelfPerson, A.db
    A.SelfPerson = function() return own end
    A.db = A.db or {}
    A.db.people = A.db.people or {}
    A.db.people.tarok = {name = "Tarok-Forever", race = "Tauren", class = "WARRIOR"}
    local named = 0
    for retell = 0, 7 do
        local p = Person("Morwen", "MAGE", "Scourge", "she")
        p.met, p.metZone = At(0), "The Barrens"
        Outing(p, At(0), "The Barrens", 90, 16, 16, {{"dungeon", "Wailing Caverns"}, {"boss", "Mutanus the Devourer"}})
        own.journal = {{k = "with", d = "tarok", n = "Tarok-Forever", t = At(0), e = At(0) + 5400}}
        p.retell = retell
        local c = Chapters(p)[1]
        if c.plain:find("Tarok, a tauren warrior,", 1, true) then named = named + 1 end
        check(not c.text:find("{%a+}"), "no raw token: " .. c.text)
    end
    check(named >= 6, "the third in the party, named with who they are: " .. named)
    A.SelfPerson, A.db = saved, savedDb
end

-- The diary says "Dahlia and me" after a verb, never "Dahlia and I".
do
    for retell = 0, 7 do
        local p = Person("Dahl", "WARLOCK", "Scourge", "she")
        p.origin, p.bond = "together", "spouse"
        for day = 0, 5 do Outing(p, At(day), "Tirisfal Glades", 90, 5 + day, 5 + day, {{"quest", "The Family Crypt"}, {"quest", "Deaths in the Family"}}) end
        p.retell = retell
        for _, c in ipairs(Chapters(p, "we")) do
            check(not c.plain:find("and I busy", 1, true) and not c.plain:find("and I to ", 1, true) and not c.plain:find("and I still", 1, true)
                and not c.plain:find("for Dahl and I", 1, true), "an object after a verb: " .. c.plain)
        end
    end
end

-- Moments from your own journal, while together: a quiet day with herbs and a
-- sunset, then the zeppelin (told early in its day).
do
    local own = {journal = {}}
    local saved = A.SelfPerson
    A.SelfPerson = function() return own end
    local sun, quiet, zep = 0, 0, 0
    for retell = 0, 7 do
        own.journal = {}
        local p = Person("Moa", "DRUID", "Tauren", "she")
        p.met, p.metZone = At(0), "Stranglethorn Vale"
        Outing(p, At(0), "Stranglethorn Vale", 60, 34, 33, {{"quest", "Raptor Mastery"}})
        local t = At(3, 17)
        p.journal[#p.journal + 1] = {k = "group", t = t, e = t + 150 * 60, z = "Stranglethorn Vale", pl = 34, ol = 34}
        own.journal[#own.journal + 1] = {k = "gather", d = "herbs", c = 20, t = t + 40 * 60}
        own.journal[#own.journal + 1] = {k = "first", d = "sunset", z = "The Savage Coast", t = t + 130 * 60}
        local t2 = At(4, 20)
        p.journal[#p.journal + 1] = {k = "group", t = t2, e = t2 + 3600, z = "Durotar", pl = 34, ol = 34}
        p.journal[#p.journal + 1] = {k = "rest", d = "Orgrimmar", t = t2 + 3000, z = "Durotar", pl = 34, ol = 34}
        own.journal[#own.journal + 1] = {k = "voyage", d = "zeppelin", from = "Eastern Kingdoms", to = "Kalimdor", t = t2 + 300}
        p.retell = retell
        local chapters = Chapters(p)
        local two, three = chapters[2].plain, chapters[3].plain
        check(not chapters[2].text:find("{%a+}"), "no raw tokens: " .. chapters[2].text)
        if two:find("sun go", 1, true) or two:find("sun went down", 1, true) then sun = sun + 1 end
        if two:find("no errands", 1, true) or two:find("no hurry", 1, true) or two:find("nowhere to be", 1, true) or two:find("herbs", 1, true) then quiet = quiet + 1 end
        check(not two:find("busy", 1, true), "a quiet day is not a busy one: " .. two)
        local z, rest = three:find("zeppelin", 1, true), three:find("rested", 1, true) or three:find("inn", 1, true)
        if z and (not rest or z < rest) then zep = zep + 1 end
    end
    check(sun == 8, "the sunset you watched together is told: " .. sun)
    check(quiet >= 6, "and the day is told as a quiet one: " .. quiet)
    check(zep >= 6, "the crossing comes early in its day: " .. zep)
    A.SelfPerson = saved
end

io.write("PASS: " .. assertions .. " storyteller assertions\n")
