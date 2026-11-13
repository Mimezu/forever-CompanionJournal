-- Run from the client root: lua5.1 Interface/AddOns/CompanionJournal/tests/CompanionOrder.lua [print]
-- (lane C9, round 26) The record-order verifier of a companion's book: every told line carries
-- its record minute, and a chapter never tells a line before one it came after, unless the line is
-- marked a set-up (the opening, the land, the closing lines, the level said "by the end" and S.Pre).
-- Runs JournalTale.OrderFaults on the final lines of every chapter of every companion of the
-- generated lives (pass3/gen_days.lua, a fixed seed), both voices, and also the real books of
-- Dahlia and Marrow when SV names a COPY of the saved variables (never the WTF file itself).
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
local T = A.JournalTale
check(T.OrderFaults and T.SortByRecord, "the verifier exists")

-- 1. The verifier itself: an inverted line is found, and moved back to its minute
do
    local S = {R = {}, Pre = {}, Z = {}, Carry = function(_, new) return new end}
    local out = {"Open.", "Then we did b.", "We did a.", "We did c.", "Close."}
    local beats = {"open", "questKey", "questKey", "questKey", "close"}
    local times = {["Open."] = 100, ["Then we did b."] = 3000, ["We did a."] = 1000, ["We did c."] = 4000}
    check(#T.OrderFaults(out, beats, times, S) == 1, "one inversion found")
    times["We did b."] = 3000
    T.SortByRecord(out, beats, times, S)
    check(out[2] == "We did a." and #T.OrderFaults(out, beats, times, S) == 0, "moved back: " .. table.concat(out, " "))
    check(out[5] == "Close.", "the close stays last")
    -- (a set-up may stand before its time)
    local out2 = {"Open.", "Raleigh wanted revenge.", "We did a."}
    local times2 = {["Raleigh wanted revenge."] = 5000, ["We did a."] = 1000}
    S.Pre["Raleigh wanted revenge."] = true
    check(#T.OrderFaults(out2, {"open", "questKey", "questKey"}, times2, S) == 0, "a marked set-up is no fault")
end

-- 2. Every chapter of every generated companion, both voices
local chapters, faults = 0, {}
T.DebugLines = function(day, out, beats, times, S)
    chapters = chapters + 1
    for _, f in ipairs(T.OrderFaults(out, beats, times, S)) do
        faults[#faults + 1] = ("%s: %s (%s) told after %s (%s)"):format(tostring(day.key), A.JournalPlain(f.line), os.date("%H:%M", f.t),
            A.JournalPlain(f.after or ""), os.date("%H:%M", f.afterT or 0))
    end
end
local gen = loadfile("StorageInvestigation/cj-story-breakthrough-20261109/pass3/gen_days.lua")
if gen then
    local G = gen()
    local lives = G.Generate(A, 20261111, 12)
    for _, life in ipairs(lives) do
        A.db.people = {}
        for key, p in pairs(life.people) do A.db.people[key] = p end
        A.SelfPerson = function() return life end
        local player = {name = life.name, race = life.race, faction = life.faction, class = life.class, charKey = life.key}
        for _, p in pairs(life.people) do
            for _, voice in ipairs({"we", "you"}) do
                p.retell = 0
                T.Tell(p, A.JournalBook(p), voice, player, false)
            end
        end
    end
    -- (1.43.1: a two-pass book with nothing to require is told once, not twice: half the count)
    check(chapters >= 12, "the generated companions told chapters: " .. chapters)
end

-- 3. The real books, from a COPY of the saved variables
local sv = os.getenv("SV")
if sv and loadfile(sv) then
    assert(loadfile(sv))()
    A.db = CompanionJournalDB
    for k, v in pairs(A.defaults) do if A.db[k] == nil then A.db[k] = v end end
    local charKey = "alberich-camwowus2realm11rp"
    A.Me = function() return charKey end
    for _, key in ipairs({"dahlia-noir", "marrow-rotmoor"}) do
        local person = A.PersonAs and A.PersonAs(key, charKey)
        if person then
            for _, voice in ipairs({"we", "you"}) do T.Tell(person, A.JournalBook(person), voice, A.CharacterPlayer(charKey), false) end
        end
    end
end
T.DebugLines = nil
if show then for _, f in ipairs(faults) do print(f) end end
check(#faults == 0, #faults .. " lines told before a line they came after; first: " .. tostring(faults[1]))
print(assertions .. " checks passed (" .. chapters .. " chapters)")
