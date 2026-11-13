-- Run from the client root: lua5.1 Interface/AddOns/CompanionJournal/tests/TimeOrder.lua [print]
-- Lane O8 round 26 (2026-11-12): the composer's clock verifier. Every told line of a chapter is in
-- non-decreasing record time, except what the composer marks as told out of time (the opening, the
-- close, dungeon runs, folds, a road's summary sentences, a deed told where it happened). The
-- composer moves a line that is out of place inside its paragraph; C.TimeFaults[day] counts what is
-- left. Twenty generated lives (pass3/gen_days.lua, seeds 4242 and 9001) must have none. Alberich's
-- real book is checked by pass3/print_current.lua runs, never by a suite: suites never read
-- SavedVariables.
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
check(C and C.Apply, "the composer is loaded")
local gen = loadfile("StorageInvestigation/cj-story-breakthrough-20261109/pass3/gen_days.lua")
check(gen, "the day generator is there")
local G = gen()
local chapters, faulty = 0, 0
for _, seed in ipairs({4242, 9001}) do
    local lives = G.Generate(A, seed, 20)
    for li, life in ipairs(lives) do
        if li <= 10 then
            A.db.people = {}
            for key, p in pairs(life.people) do A.db.people[key] = p end
            A.SelfPerson = function() return life end
            life.retell = 0
            C.TimeFaults = {}
            local book = A.JournalBook(life)
            local stories = A.SelfTale.Tell(life, book, false, 0)
            for _, d in ipairs(book) do
                local st = stories[d.key]
                if st and st.text ~= "" and C.TimeFaults[d.key] then
                    chapters = chapters + 1
                    if C.TimeFaults[d.key] > 0 then
                        faulty = faulty + 1
                        if show then print(("%s %s: %d lines out of clock order"):format(life.key, d.key, C.TimeFaults[d.key])) end
                    end
                end
            end
        end
    end
end
check(chapters >= 20, "at least twenty composed chapters checked, got " .. chapters)
check(faulty == 0, ("no unmarked clock inversion in the composed chapters, got %d of %d"):format(faulty, chapters))
print(("PASS: %d time-order assertions over %d chapters"):format(assertions, chapters))
