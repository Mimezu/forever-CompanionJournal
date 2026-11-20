-- Run from the client root: lua5.1 Interface/AddOns/CompanionJournal/tests/TellBackground.lua
-- The book's tellings in the background (JournalTellCache.lua C.Book, 1.54.0): the book gets
-- the last telling at once and a fresh one a few milliseconds a frame; the fresh one is word for
-- word what the tellers give when called directly (own book, a companion's in both voices, with
-- the own book told inside it); a new entry is told again; asking again while it runs never
-- leaves a teller half done. Generated lives (pass3/gen_days.lua).
local root = "Interface/AddOns/CompanionJournal/"
local assertions = 0
local function check(value, message) assertions = assertions + 1; assert(value, message) end

local NOW = os.time({year = 2026, month = 12, day = 1, hour = 0})
function time(t) if type(t) == "table" then return os.time(t) end return NOW end
function date(fmt, t) return os.date(fmt, t) end
function debugprofilestop() return os.clock() * 1000 end
-- (frames: the job's OnUpdate is kept and called by Frame() below)
local onUpdate
function CreateFrame()
    return setmetatable({SetScript = function(_, what, f) if what == "OnUpdate" then onUpdate = f end end},
        {__index = function() return function() end end})
end
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

local life
for _, l in ipairs(G.Generate(A, 4242, 12)) do
    if not life and next(l.people) then life = l end
end
check(life, "a generated life with a companion")
A.db = {people = {}, bookVariants = {}}
for key, p in pairs(life.people) do A.db.people[key] = p end
A.db.life = life
A.SelfPerson = function() return life end
A.Me = function() return life.key end
A.BookVariant = function(k) return A.db.bookVariants[k] end
life.retell = 0
local companion
for _, p in pairs(life.people) do companion = companion or p end
companion.retell = 0
local player = {name = life.name, race = life.race, faction = life.faction, class = life.class, charKey = life.key}

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
-- Frames until the job is done; the longest frame's work, in ms.
local function Frames()
    local n, longest = 0, 0
    while C.Busy() and n < 100000 do
        local t0 = os.clock()
        onUpdate()
        longest = math.max(longest, (os.clock() - t0) * 1000)
        n = n + 1
    end
    return n, longest
end
local function Gather(person) return function() return A.JournalBook(person) end end

-- 1. The own book: nothing at first, the told book after some frames, the direct telling's words.
C.Clear()
local readies = 0
local function Ready() readies = readies + 1 end
local args = {brief = false, retell = false}
local stories, days = C.Book("self", life, args, Gather(life), Ready)
check(stories == nil and days == nil, "never told: nothing yet")
local frames, longest = Frames()
check(frames >= 1 and readies == 1, "told in the background, then ready once")
io.stderr:write(("own book: %d frames, longest %.1f ms\n"):format(frames, longest))
stories, days = C.Book("self", life, args, Gather(life), Ready)
check(stories and days, "the told book and its days at once")
local direct = Text(A.SelfTale.Tell(life, A.JournalBook(life), false), A.JournalBook(life))
check(Text(stories, days) == direct and direct ~= "", "the background book is the direct telling, word for word")
-- (the check that follows finds nothing new: no second ready)
local before = readies
Frames()
check(readies == before, "nothing changed: no new page")
-- (a direct telling marks lines told in the saved journal; the next check tells once more, then stays)
for _ = 1, 3 do C.Book("self", life, args, Gather(life), Ready); Frames() end
local kept = C.Book("self", life, args, Gather(life), Ready); Frames()
check(C.Book("self", life, args, Gather(life), Ready) == kept, "settled: the same book")
check(Text(kept, A.JournalBook(life)) == Text(A.SelfTale.Tell(life, A.JournalBook(life), false), A.JournalBook(life)), "still the direct telling")

-- 2. A new entry: the old book at once, the new one after the frames.
local last = life.journal[#life.journal]
local t = (last.e or last.t) + 3 * 86400
life.journal[#life.journal + 1] = {k = "play", t = t, e = t + 3600, z = last.z, pl = last.pl}
life.journal[#life.journal + 1] = {k = "level", t = t + 1800, z = last.z, d = (last.pl or 10) + 1, pl = (last.pl or 10) + 1}
local old = C.Book("self", life, args, Gather(life), Ready)
check(old == kept, "the last telling at once")
before = readies
for _ = 1, 4 do Frames(); C.Book("self", life, args, Gather(life), Ready) end
Frames()
local grown, gdays = C.Book("self", life, args, Gather(life), Ready); Frames()
check(readies > before and grown ~= kept and #gdays == #A.JournalBook(life), "the new day told")
check(Text(grown, gdays) == Text(A.SelfTale.Tell(life, A.JournalBook(life), false), A.JournalBook(life)), "the grown book is the direct telling")

-- 3. A companion's book, both voices, with the own book told inside it (paused through its
-- protected calls): the direct telling's words.
for _, voice in ipairs({"we", "you"}) do
    C.Clear()
    local targs = {voice = voice, player = player, brief = false}
    check(C.Book("tale", companion, targs, Gather(companion), Ready) == nil, voice .. ": nothing yet")
    frames, longest = Frames()
    io.stderr:write(("companion book (%s): %d frames, longest %.1f ms\n"):format(voice, frames, longest))
    for _ = 1, 3 do C.Book("tale", companion, targs, Gather(companion), Ready); Frames() end
    local told, tdays = C.Book("tale", companion, targs, Gather(companion), Ready); Frames()
    check(told ~= nil and frames >= 1, voice .. ": told in the background")
    local d = A.JournalBook(companion)
    check(Text(told, tdays) == Text(A.JournalTale.Tell(companion, d, voice, player, false), d), voice .. ": the background book is the direct telling")
    check(A.JournalTale.ownKeys == nil and not A.JournalTale.ownBusy, voice .. ": no teller left half done")
end

-- 4. Asked for again and again while it runs (a redraw a frame): it still finishes, once.
C.Clear(); readies = 0
local targs = {voice = "we", player = player, brief = false}
C.Book("tale", companion, targs, Gather(companion), Ready)
local n = 0
while C.Busy() and n < 100000 do
    onUpdate(); n = n + 1
    if n % 3 == 0 then C.Book("tale", companion, targs, Gather(companion), Ready) end
end
check(C.Book("tale", companion, targs, Gather(companion), Ready) ~= nil, "asked every few frames: told all the same")
Frames()

-- 5. Two books asked for: the book's own request first, both told.
C.Clear()
C.WarmSelf(life, Gather(life), false)
C.Book("tale", companion, {voice = "you", player = player, brief = false}, Gather(companion), Ready)
Frames()
check(C.Book("self", life, args, Gather(life), Ready) ~= nil, "the warmed own book is kept")
check(C.Book("tale", companion, {voice = "you", player = player, brief = false}, Gather(companion), Ready) ~= nil, "the companion's too")
Frames()

-- 6. A telling that fails: the error is reported, the book is not stuck asking every frame.
C.Clear()
local errors = 0
geterrorhandler = function() return function() errors = errors + 1 end end
local Tell = A.SelfTale.Tell
A.SelfTale.Tell = function() error("broken") end
check(C.Book("self", life, args, Gather(life), Ready) == nil, "failing: nothing yet")
Frames()
check(errors == 1, "the error reported once")
local empty = C.Book("self", life, args, Gather(life), Ready)
check(type(empty) == "table" and not C.Busy(), "after a failure: an empty book, no new job at once")
A.SelfTale.Tell = Tell
geterrorhandler = nil

-- 7. A.TellPcall outside the job is pcall.
local ok, a, b = A.TellPcall(function(x) return x, 2 end, 1)
check(ok and a == 1 and b == 2, "TellPcall outside: results")
local bad, err = A.TellPcall(function() error("x", 0) end)
check(not bad and err == "x", "TellPcall outside: errors")

print(assertions .. " checks passed")
