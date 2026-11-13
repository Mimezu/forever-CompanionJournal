-- Run from the client root: lua5.1 Interface/AddOns/CompanionJournal/tests/TellCache.lua
-- The told books kept for the session (JournalTellCache.lua, 1.43.1): a kept book is word for
-- word the book a fresh telling gives; a new entry, an edited note, Retell, another voice, mode
-- or storyteller, a renamed companion tell it again; the book's own page state does not; an open
-- outing tells again when the clock moves a step. Generated lives (pass3/gen_days.lua).
local root = "Interface/AddOns/CompanionJournal/"
local assertions = 0
local function check(value, message) assertions = assertions + 1; assert(value, message) end

local NOW = os.time({year = 2026, month = 12, day = 1, hour = 0})
function time(t) if type(t) == "table" then return os.time(t) end return NOW end
function date(fmt, t) return os.date(fmt, t) end
function CreateFrame() return setmetatable({}, {__index = function() return function() end end}) end
C_Timer = {After = function() end}
LOCALIZED_CLASS_NAMES_MALE = {WARRIOR = "Warrior", MAGE = "Mage", PRIEST = "Priest", ROGUE = "Rogue", WARLOCK = "Warlock",
    HUNTER = "Hunter", DRUID = "Druid", SHAMAN = "Shaman", PALADIN = "Paladin"}
local A = {defaults = {colors = {}}}
for _, file in ipairs({"LoreData.lua", "Lore.lua", "LoreHordeStories.lua", "LoreAllianceStories.lua", "LoreWorldStories.lua",
    "LoreClassStories.lua", "LoreForeverStories.lua", "People.lua", "Characters.lua", "Journal.lua", "JournalBook.lua",
    "JournalTellers.lua", "JournalFeel.lua", "JournalTale.lua", "JournalWords.lua", "JournalSelfWords.lua", "JournalSelfStyle.lua",
    "JournalSelfPlan.lua", "JournalSelfTale.lua", "JournalEpisodes.lua", "JournalSelfCompose.lua", "JournalTellCache.lua"}) do
    assert(loadfile(root .. file))("CompanionJournal", A)
end
A.SelfUnderground = function(name) return name:find("Mine") ~= nil or name:find("Cave") ~= nil end
local G = dofile("StorageInvestigation/cj-story-breakthrough-20261109/pass3/gen_days.lua")
local C = A.TellCache
check(C and C.Self and C.Tale and C.Told, "the cache is loaded")

local life
for _, l in ipairs(G.Generate(A, 4242, 12)) do
    if not life and next(l.people) then life = l end
end
check(life, "a generated life with a companion")
A.db = {people = {}, bookVariants = {}}
for key, p in pairs(life.people) do A.db.people[key] = p end
A.db.life = life -- (the own record lives in the saved variables, as a character's does)
A.SelfPerson = function() return life end
A.Me = function() return life.key end
A.BookVariant = function(k) return A.db.bookVariants[k] end
life.retell = 0
local companion
for _, p in pairs(life.people) do companion = companion or p end
companion.retell = 0
local player = {name = life.name, race = life.race, faction = life.faction, class = life.class, charKey = life.key}

-- (the book as text, to compare a kept book with a fresh telling)
local function Text(stories, days)
    local out = {}
    for _, d in ipairs(days) do
        local s = stories[d.key]
        if s then
            out[#out + 1] = d.key .. "|" .. tostring(s.chapter) .. "|" .. tostring(s.title) .. "|" .. tostring(s.text)
            for _, q in ipairs(s.quotes or {}) do out[#out + 1] = "q|" .. tostring(q.text) end
        end
    end
    return table.concat(out, "\n")
end
local function Fresh(brief, retell)
    local days = A.JournalBook(life)
    return Text(A.SelfTale.Tell(life, days, brief, retell), days)
end
local function Kept(brief, retell)
    local days = A.JournalBook(life)
    return C.Self(life, days, brief, retell), days
end

-- 1. A hit gives the same book, and the book is the fresh telling's word for word.
C.Clear(); C.hits, C.misses = 0, 0
local a, days = Kept(false)
local b = Kept(false)
check(a == b and C.hits == 1 and C.misses == 1, "the second open is a hit")
check(Text(a, days) == Fresh(false), "the kept own book is the fresh telling")
check(Text(a, days) ~= "", "the own book tells something")

-- 2. The book's page state (what you read, pins, size) does not tell again.
A.db.bookRead = {x = {from = "2026-01-01", days = {}}}; A.db.bookPins = {"x"}; A.db.bookSize = "b"
check(Kept(false) == a and C.misses == 1, "reading and moving the book keep the told book")

-- 3. Another mode, Retell, the storyteller setting: told again, and each is the fresh telling.
local brief, bdays = Kept(true)
check(brief ~= a and C.misses == 2, "Highlights is told on its own")
check(Text(brief, bdays) == Fresh(true), "the kept brief book is the fresh telling")
life.retell = 1
local re, rdays = Kept(false)
check(re ~= a and C.misses == 3, "Retell tells again")
check(Text(re, rdays) == Fresh(false), "the retold book is the fresh retelling")
life.retell = 0
check(Kept(false) == a, "back to the first telling: still kept")
A.db.bookVariants.teller = "planned"
local planned, pdays = Kept(false)
check(planned ~= a, "another storyteller tells again")
check(Text(planned, pdays) == Fresh(false), "the planned book is the fresh telling")
A.db.bookVariants.teller = nil

-- 4. A new entry tells again; the days before it read as before.
local before = Text(a, days)
local last = life.journal[#life.journal]
local t = (last.e or last.t) + 3 * 86400
life.journal[#life.journal + 1] = {k = "play", t = t, e = t + 3600, z = last.z, pl = last.pl}
life.journal[#life.journal + 1] = {k = "level", t = t + 1800, z = last.z, d = (last.pl or 10) + 1, pl = (last.pl or 10) + 1}
local misses = C.misses
local c, cdays = Kept(false)
check(C.misses == misses + 1 and c ~= a, "a new entry tells again")
check(Text(c, cdays) == Fresh(false), "the book with the new day is the fresh telling")
local kept = 0
for _, d in ipairs(days) do
    if a[d.key] and c[d.key] then
        kept = kept + 1
        check(a[d.key].text == c[d.key].text, "a past day reads as before: " .. d.key)
    end
end
check(kept > 0 and before ~= Text(c, cdays), "past days compared, and the book grew")

-- 5. An edited entry (a note) tells again.
local noteDay = life.journal[1]
noteDay.note = "edited"
check(Kept(false) ~= c, "an edited entry tells again")
noteDay.note = nil

-- 6. An open outing: kept within a clock step, told again after it.
life.journal[#life.journal].e = nil
life.journal[#life.journal - 1].e = nil
C.Clear(); C.misses = 0
local o1 = Kept(false)
NOW = NOW + 10
check(Kept(false) == o1 and C.misses == 1, "an open outing is kept within the step")
NOW = NOW + C.OPEN_STEP
local o2, odays = Kept(false)
check(o2 ~= o1 and C.misses == 2, "an open outing is told again when the clock moves a step")
check(Text(o2, odays) == Fresh(false), "the open book is the fresh telling")

-- 7. A companion's book: both voices kept apart, a rename tells again, the text is the fresh one.
local function FreshTale(voice) local d = A.JournalBook(companion); return Text(A.JournalTale.Tell(companion, d, voice, player, false), d) end
C.Clear(); C.misses = 0
local cd = A.JournalBook(companion)
local we = C.Tale(companion, cd, "we", player, false)
local you = C.Tale(companion, cd, "you", player, false)
check(we ~= you and C.misses == 2, "the two voices are told apart")
check(C.Tale(companion, A.JournalBook(companion), "we", player, false) == we and C.misses == 2, "the companion's book is kept")
check(Text(we, cd) == FreshTale("we") and Text(you, cd) == FreshTale("you"), "the kept companion books are the fresh tellings")
companion.display = "Renamed"
check(C.Tale(companion, A.JournalBook(companion), "we", player, false) ~= we, "a renamed companion tells again")
companion.display = nil
-- (the companion's teller tells the own book once a telling, not once a chapter: still the same)
check(Text(we, cd) == FreshTale("we"), "the companion's book does not hang on how often the own book was read")

-- 8. Switched off, it tells every time.
C.ON = false
local off1, off2 = Kept(false), Kept(false)
check(off1 ~= off2, "off: told on every open")
C.ON = true

print(assertions .. " checks passed")
