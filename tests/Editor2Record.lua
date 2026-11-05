-- Run from the client root: lua5.1 Interface/AddOns/CompanionJournal/tests/Editor2Record.lua
-- Companion recording (editor2, 2026-11-05): your resurrection spell landing on
-- someone you travel with is kept in their journal as a rez by you, only while
-- "Record more moments" is on; the book reads it as yours.
local root = "Interface/AddOns/CompanionJournal/"
local assertions = 0
local function check(value, message) assertions = assertions + 1; assert(value, message) end

local methods = {}
local function Object()
    local object = {scripts = {}, events = {}}
    return setmetatable(object, {__index = function(_, key)
        if methods[key] then return methods[key] end
        if type(key) == "string" and key:match("^[A-Z]") then return function(self) return self end end
    end})
end
function methods:SetScript(key, fn) self.scripts[key] = fn end
function methods:RegisterEvent(event) self.events[event] = true end
function methods:RegisterUnitEvent(event) self.events[event] = true end
function methods:UnregisterEvent(event) self.events[event] = nil end
local frames = {}
function CreateFrame() local f = Object(); frames[#frames + 1] = f; return f end
UIParent = Object()
local clock = 1000000
function time() return clock end
function GetTime() return clock end
function date(fmt, t) return os.date(fmt, t or clock) end
function GetRealZoneText() return "Elwynn Forest" end
function GetNormalizedRealmName() return "Forever" end
function GetRealmName() return "Forever" end
C_Timer = {After = function(_, fn) fn() end}
function IsInInstance() return false, "none" end
function GetInstanceInfo() return nil end
print = function() end
local members, inGroup = {}, false
function IsInGroup() return inGroup end
function IsInRaid() return false end
function GetNumGroupMembers() return inGroup and (#members + 1) or 0 end
function GetNumSubgroupMembers() return inGroup and #members or 0 end
function UnitIsUnit() return false end
function UnitIsPlayer() return true end
function UnitGUID(unit) return unit == "player" and "Player-1-00000001" or nil end
local function Member(unit) return members[tonumber(unit:match("%d+") or 0)] end
function UnitFullName(unit) local m = Member(unit); if m then return m[1], "Forever" end end
function UnitClass(unit) local m = Member(unit); if m then return m[2], m[2] end end
function UnitLevel(unit) local m = Member(unit); return m and m[3] or 0 end
function UnitFactionGroup(unit) if unit == "player" then return "Horde" end local m = Member(unit); return m and m[4] or nil end
local target = "Aeryn"
function UnitName(unit) if unit == "target" then return target end return "Writer" end
C_Spell = {GetSpellName = function(id) return ({[2006] = "Resurrection", [1234] = "Smite"})[id] end}
C_QuestLog = {GetTitleForQuestID = function() return nil end, GetNumQuestLogEntries = function() return 0, 0 end,
    GetInfo = function() return nil end, IsComplete = function() return false end, IsUnitOnQuest = function() return false end}

local A = {defaults = {colors = {}}}
for _, file in ipairs({"People.lua", "Characters.lua", "GroupPrompt.lua", "Journal.lua"}) do
    assert(loadfile(root .. file))("ForeverNames", A)
end
A.Refresh = function() end
local db = {enabled = true, colors = {people = {1, 1, 1}, groupmate = {0.5, 0.8, 1}}}
for key, value in pairs(A.defaults) do if db[key] == nil then db[key] = value end end
A.db = db
A.InitPeople()
local moreMoments = false
A.MoreMomentsOn = function() return moreMoments end
local function Events()
    for i = #frames, 1, -1 do if frames[i].events.ENCOUNTER_END then return frames[i] end end
end
local function Kinds(journal)
    local kinds = {}
    for _, entry in ipairs(journal or {}) do kinds[#kinds + 1] = entry.k .. (entry.w and (":" .. entry.w) or "") end
    return table.concat(kinds, ",")
end

local aeryn = A.AddPerson("Aeryn")
members = {{"Aeryn", "MAGE", 20, "Horde"}}
inGroup = true
db.peopleJournal = true
A.UpdatePeopleHooks()
local frame = Events()
check(frame and frame.events.UNIT_SPELLCAST_SUCCEEDED, "your own casts are watched while the journal is on")
local function Fire(event, ...) frame.scripts.OnEvent(frame, event, ...) end
check(Kinds(aeryn.journal) == "group", "the outing opened: " .. Kinds(aeryn.journal))

-- 1. Off: a resurrection you cast records nothing.
Fire("UNIT_SPELLCAST_SUCCEEDED", "player", "cast-1", 2006)
check(Kinds(aeryn.journal) == "group", "nothing recorded while more moments is off: " .. Kinds(aeryn.journal))

-- 2. On: your resurrection of a companion is theirs to keep, as a rez by you.
moreMoments = true
Fire("UNIT_SPELLCAST_SUCCEEDED", "player", "cast-2", 1234)
check(Kinds(aeryn.journal) == "group", "another spell records nothing: " .. Kinds(aeryn.journal))
Fire("UNIT_SPELLCAST_SUCCEEDED", "party1", "cast-3", 2006)
check(Kinds(aeryn.journal) == "group", "a companion's cast is not yours: " .. Kinds(aeryn.journal))
Fire("UNIT_SPELLCAST_SUCCEEDED", "player", "cast-4", 2006)
check(Kinds(aeryn.journal) == "group,rez:you", "your resurrection of Aeryn is recorded: " .. Kinds(aeryn.journal))
target = "Stranger"
Fire("UNIT_SPELLCAST_SUCCEEDED", "player", "cast-5", 2006)
check(Kinds(aeryn.journal) == "group,rez:you", "a raise of someone else is not Aeryn's: " .. Kinds(aeryn.journal))

-- 3. Off again: the event is gone with the journal.
db.peopleJournal = false
A.UpdatePeopleHooks()
check(not frame.events.UNIT_SPELLCAST_SUCCEEDED, "the cast watch goes with the journal")

-- 4. The book reads it as yours.
local B = {defaults = {colors = {}}}
for _, file in ipairs({"LoreData.lua", "Lore.lua", "JournalBook.lua"}) do assert(loadfile(root .. file))("CompanionJournal", B) end
local text = B.JournalPlain(B.JournalEventText("Aeryn", {k = "rez", w = "you"}))
check(text == "You brought Aeryn back from death.", "the plain record says who raised whom: " .. tostring(text))
local theirs = B.JournalPlain(B.JournalEventText("Aeryn", {k = "rez"}))
check(theirs == "Aeryn brought you back from death.", "their raise of you reads as before: " .. tostring(theirs))

io.write("PASS: " .. assertions .. " editor2 recording assertions\n")
