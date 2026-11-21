-- Run from the client root: lua5.1 Interface/AddOns/CompanionJournal/tests/SelfFreeze.lua
-- Finished chapters kept (JournalSelfFreeze.lua, 2026-11-20): a telling that goes on from the
-- kept memory gives the whole telling word for word (on days built afresh); a new day keeps
-- the kept chapters; a changed setting or a changed kept day tells everything again.
-- Generated lives (pass3/gen_days.lua).
local root = "Interface/AddOns/CompanionJournal/"
local assertions = 0
local function check(value, message) assertions = assertions + 1; assert(value, message) end

local NOW = os.time({year = 2026, month = 12, day = 1, hour = 0})
function time(t) if type(t) == "table" then return os.time(t) end return NOW end
function date(fmt, t) return os.date(fmt, t) end
function debugprofilestop() return os.clock() * 1000 end
function CreateFrame()
    return setmetatable({SetScript = function() end}, {__index = function() return function() end end})
end
C_Timer = {After = function() end}
LOCALIZED_CLASS_NAMES_MALE = {WARRIOR = "Warrior", MAGE = "Mage", PRIEST = "Priest", ROGUE = "Rogue", WARLOCK = "Warlock",
    HUNTER = "Hunter", DRUID = "Druid", SHAMAN = "Shaman", PALADIN = "Paladin"}
local A = {defaults = {colors = {}}}
for _, file in ipairs({"LoreData.lua", "Lore.lua", "LoreHordeStories.lua", "LoreAllianceStories.lua", "LoreWorldStories.lua",
    "LoreClassStories.lua", "LoreForeverStories.lua", "People.lua", "Characters.lua", "Journal.lua", "JournalBook.lua",
    "JournalTellers.lua", "JournalFeel.lua", "JournalTale.lua", "JournalWords.lua", "JournalSelfWords.lua", "JournalSelfStyle.lua",
    "JournalSelfPlan.lua", "JournalSelfTale.lua", "JournalEpisodes.lua", "JournalSelfCompose.lua", "JournalTellCache.lua",
    "JournalSelfFreeze.lua"}) do
    assert(loadfile(root .. file))("CompanionJournal", A)
end
A.SelfUnderground = function(name) return name:find("Mine") ~= nil or name:find("Cave") ~= nil end
local G = dofile("StorageInvestigation/cj-story-breakthrough-20261109/pass3/gen_days.lua")
local F, ST = A.SelfFreeze, A.SelfTale
F.ALWAYS = true
-- (generated lives are a few days long: every day before the last is kept)
F.SETTLE = 0

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
local function Tell(life, brief, on)
    F.ON = on
    local days = A.JournalBook(life)
    return Text(ST.Tell(life, days, brief), days), days
end

local lives = 0
for _, seed in ipairs({4242, 77, 1913, 20261111}) do
    for _, life in ipairs(G.Generate(A, seed, 24)) do
        A.db = {people = {}, bookVariants = {}}
        for key, p in pairs(life.people) do A.db.people[key] = p end
        A.SelfPerson = function() return life end
        A.Me = function() return life.key end
        A.BookVariant = function(k) return A.db.bookVariants[k] end
        life.retell = 0
        for _, brief in ipairs({false, true}) do
            F.Clear()
            local plain, days = Tell(life, brief, false)
            if #days >= 3 then
                lives = lives + 1
                local label = life.name .. (brief and " brief" or "")
                local r0 = F.resumed
                check(Tell(life, brief, true) == plain, label .. ": the telling that keeps days is the whole telling")
                check(Tell(life, brief, true) == plain, label .. ": going on from the kept days gives the whole telling, word for word")
                check(F.resumed == r0 + 1, label .. ": the second telling went on from the kept days")
                -- A setting the words may depend on: everything told again.
                A.db.bookVariants.someSetting = "x"
                local r1 = F.resumed
                Tell(life, brief, true)
                check(F.resumed == r1, label .. ": a changed setting tells everything again")
                A.db.bookVariants.someSetting = nil
                Tell(life, brief, true)
                -- What changes as you play (a companion seen, their journal, your level): the kept
                -- days stay kept.
                A.db.people.zz = {name = "Zz", seen = 1, zone = "Here", level = 10}
                Tell(life, brief, true)
                A.db.people.zz.seen, A.db.people.zz.zone, A.db.people.zz.level = 2, "There", 11
                A.db.characters = {me = {name = "Me", continent = "Kalimdor", people = {zz = {bond = "friend", journal = {}}}}}
                local withZz = Tell(life, brief, true)
                local rs = F.resumed
                A.db.characters.me.continent = "Eastern Kingdoms"
                A.db.characters.me.people.zz.journal[1] = {k = "with", t = 1}
                A.db.people.zz.seen = 3
                check(Tell(life, brief, true) == withZz and F.resumed == rs + 1, label .. ": a companion seen, a continent: the kept days stay")
                life.level = (life.level or 1) + 1
                Tell(life, brief, true)
                check(F.resumed == rs + 2, label .. ": a new level: the kept days stay")
                life.level = life.level - 1
                A.db.people.zz, A.db.characters = nil, nil
                Tell(life, brief, true)
                -- A kept day changed (a line edited): everything told again, as the whole telling.
                local first = life.journal[1]
                local saved = first.z
                first.z = (first.z or "") .. " Edited"
                local r2 = F.resumed
                local plainEdited = Tell(life, brief, false)
                check(Tell(life, brief, true) == plainEdited and F.resumed == r2, label .. ": a changed kept day tells everything again")
                first.z = saved
                Tell(life, brief, true)
                -- A new day long after: the kept chapters stay word for word, the rest is told.
                local before, bdays = Tell(life, brief, true)
                local keptUpTo = F.kept[next(F.kept)] and F.kept[next(F.kept)].upto or 0
                local last = life.journal[#life.journal]
                local t = (last.e or last.t) + 4 * 86400
                life.journal[#life.journal + 1] = {k = "play", t = t, e = t + 3600, z = last.z, pl = last.pl}
                local r3 = F.resumed
                local grown, gdays = Tell(life, brief, true)
                check(F.resumed == r3 + 1, label .. ": a new day goes on from the kept days")
                local a, b = {}, {}
                for i = 1, keptUpTo do a[#a + 1] = bdays[i].key end
                for i = 1, keptUpTo do b[#b + 1] = gdays[i].key end
                check(table.concat(a, ",") == table.concat(b, ","), label .. ": the same kept days")
                -- (the kept chapters: the same lines at the head of both tellings)
                local head1, head2 = {}, {}
                for line in (before .. "\n"):gmatch("(.-)\n") do
                    local key = line:match("^(%d+%-%d+%-%d+)|")
                    if key and key <= (bdays[keptUpTo] and bdays[keptUpTo].key or "") then head1[#head1 + 1] = line end
                end
                for line in (grown .. "\n"):gmatch("(.-)\n") do
                    local key = line:match("^(%d+%-%d+%-%d+)|")
                    if key and key <= (bdays[keptUpTo] and bdays[keptUpTo].key or "") then head2[#head2 + 1] = line end
                end
                check(keptUpTo > 0 and table.concat(head1, "\n") == table.concat(head2, "\n"), label .. ": the kept chapters word for word")
                table.remove(life.journal)
            end
        end
    end
end
check(lives >= 4, "enough lives with days to keep (" .. lives .. ")")
print(assertions .. " checks passed (" .. lives .. " tellings)")
