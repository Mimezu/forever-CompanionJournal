-- Run from client root: lua5.1 Interface/AddOns/CompanionJournal/tests/VoiceEditorial.lua
-- Exercise the assembled day predicate: a plural "were" must never follow
-- singular diary "I", even when the companion is named by the sentence frame.
local root = "Interface/AddOns/CompanionJournal/"
function time(t) return t and os.time(t) or 1790000000 end
function date(fmt, t) return os.date(fmt, t) end
function CreateFrame() return setmetatable({}, {__index = function() return function() end end}) end
C_Timer = {After = function() end}
local A = {defaults = {colors = {}}, db = {people = {}}}
for _, file in ipairs({"LoreData.lua", "Lore.lua", "LoreAllianceStories.lua", "People.lua", "Characters.lua", "Journal.lua", "JournalBook.lua", "JournalTellers.lua", "JournalTale.lua", "JournalWords.lua", "JournalSelfWords.lua", "JournalSelfTale.lua"}) do
    assert(loadfile(root .. file))("CompanionJournal", A)
end
local checks = 0
local function check(ok, why) checks = checks + 1; assert(ok, why) end
local p = {name = "Aster", race = "Dwarf", class = "HUNTER", faction = "Alliance", pronouns = "they", bond = "friend", journal = {}}
local BASE = os.time({year = 2026, month = 9, day = 3, hour = 18})
for day, id in ipairs({218, 319, 320, 315, 418, 455, 279}) do
    local q = A.Lore.storyPacks["alliance-starters"].questIDs[id]
    local t = BASE + day * 86400
    p.journal[#p.journal + 1] = {k = "group", t = t, e = t + 3600, z = q.zone, pl = q.level, ol = q.level}
    p.journal[#p.journal + 1] = {k = "quest", t = t + 600, d = q.title, qid = id, z = q.zone, pl = q.level, ol = q.level}
end
for _, brief in ipairs({false, true}) do for _, voice in ipairs({"we", "you"}) do for retell = 0, 15 do
    p.retell = retell
    local days = A.JournalBook(p)
    local stories = A.JournalTale.Tell(p, days, voice, {name = "Rowan", race = "Dwarf", class = "HUNTER", faction = "Alliance"}, brief)
    for _, day in ipairs(days) do
        local s = stories[day.key]
        local text = s and A.JournalPlain(s.text) or ""
        check(not text:find("With Aster, I were", 1, true), "named companion frame must agree with assembled predicate")
        check(not text:find("{%a+}"), "editorial changes require no missing tokens")
    end
end end end
check(#p.journal == 14 and p.journal[2].qid == 218, "retells preserve source history")
print("VoiceEditorial: " .. checks .. " checks")
