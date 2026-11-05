-- Run from the client root: lua5.1 Interface/AddOns/CompanionJournal/tests/CodeReviewMoments.lua
-- Code review of "Record more moments" (2026-11-05): the fixes made before it
-- ran in the game.
--   1. A message string with numbered placeholders ("%1$s ... %2$d") makes a
--      usable pattern; before, "%2" stayed a back-reference and every info
--      message raised an error.
--   2. A standing or a trade rank reached while the setting was off is not told
--      as reached today when it is turned on again; the first look only seeds.
--   3. Turning it on seeds at once, so the first change after that is told.
--   4. The rare watch (UNIT_HEALTH on the target) is let go as soon as you
--      target something that is not a living rare.
--   5. A trainer window open when the setting was turned off does not make
--      later spells count as bought.
local root = "Interface/AddOns/CompanionJournal/"
local assertions = 0
local function check(value, message) assertions = assertions + 1; assert(value, message) end
local function equal(a, b, message) check(a == b, message .. " (got " .. tostring(a) .. ", expected " .. tostring(b) .. ")") end

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
local clock = 1790000000
function time(t) if type(t) == "table" then return os.time(t) end return clock end
function GetTime() return clock end
function date(fmt, t) return os.date(fmt, t or clock) end
local zone, subzone = "Durotar", "Razor Hill"
function GetRealZoneText() return zone end
function GetSubZoneText() return subzone end
function IsResting() return false end
function IsInInstance() return false, "none" end
function GetInstanceInfo() return nil end
function GetNormalizedRealmName() return "Forever" end
function GetRealmName() return "Forever" end
C_QuestLog = {GetTitleForQuestID = function() return nil end}
function UnitFactionGroup(unit) if unit == "player" then return "Horde" end end
function UnitClass(unit) if unit == "player" then return "Paladin", "PALADIN" end end
function UnitRace(unit) if unit == "player" then return "Undead", "Scourge" end end
function UnitLevel(unit) if unit == "player" then return 23 end return 0 end
local target, inCombat = nil, false
function UnitIsDeadOrGhost(unit) if unit == "target" then return target and target.dead or false end return false end
function UnitHealth() return 100 end
function UnitHealthMax() return 100 end
function UnitCanAttack(_, unit) return unit == "target" and target ~= nil and not target.friendly end
function UnitName(unit) if unit == "player" then return "Alberich" end if unit == "target" and target then return target.name end end
function UnitClassification() return target and target.rank or "normal" end
function UnitIsPlayer() return false end
function UnitAffectingCombat() return inCombat end
function IsSwimming() return false end
local timers = {}
C_Timer = {After = function(delay, fn) if delay >= 10 then timers[#timers + 1] = fn else fn() end end}
local function RunTimers() local list = timers; timers = {}; for _, fn in ipairs(list) do fn() end end
print = function() end

-- A client whose strings number their placeholders (as some locales do).
ERR_ZONE_EXPLORED = "Entdeckt: %s"
ERR_ZONE_EXPLORED_XP = "Entdeckt %1$s: %2$d Erfahrung erhalten"
DUEL_WINNER_KNOCKOUT = "%1$s has defeated %2$s in a duel"
DUEL_WINNER_RETREAT = "%2$s has fled from %1$s in a duel"
local messageNames = {[1] = "ERR_ZONE_EXPLORED_XP", [2] = "ERR_ZONE_EXPLORED", [3] = "ERR_NEWTAXIPATH"}
function GetGameMessageInfo(index) return messageNames[index] end
function ItemTextGetItem() return nil end
function ItemTextGetMaterial() return nil end
local spells = {[20271] = "Judgement"}
function GetSpellInfo(id) return spells[id] end
local factions = {{name = "Orgrimmar", reaction = 4}, {name = "Ratchet", reaction = 4}}
local factionsReady = true
C_Reputation = {GetNumFactions = function() return factionsReady and #factions or 0 end, GetFactionDataByIndex = function(i) return factions[i] end}
local skills = {{name = "Cooking", rank = 60, maxRank = 75}}
C_SkillInfo = {GetNumSkillLines = function() return #skills end, GetSkillLineInfo = function(i) return skills[i] end}
function GetPVPSessionStats() return 0, 0 end

local db = {enabled = true, peopleJournal = true, colors = {people = {1, 1, 1}}, people = {},
    characters = {["alberich-forever"] = {name = "Alberich", faction = "Horde", class = "PALADIN", race = "Scourge", people = {}}}}
local A = {defaults = {colors = {}}}
for _, file in ipairs({"People.lua", "Characters.lua", "Journal.lua", "JournalSelf.lua", "JournalBook.lua"}) do
    assert(loadfile(root .. file))("CompanionJournal", A)
end
A.Refresh = function() end
for key, value in pairs(A.defaults) do if db[key] == nil then db[key] = value end end
A.db = db
A.InitPeople()
A.InitCharacters()
db.moreMoments = true
A.UpdateSelfJournalEvents()
local selfFrame, rareFrame
for _, f in ipairs(frames) do
    if f.events.QUEST_TURNED_IN and f.events.PLAYER_LEVEL_UP and f.events.ZONE_CHANGED_NEW_AREA then selfFrame = f end
    if f.scripts.OnEvent == A.SelfRareHealth then rareFrame = f end
end
check(selfFrame and rareFrame, "the journal frame and the rare watch frame")
local function Fire(event, ...) selfFrame.scripts.OnEvent(selfFrame, event, ...) end
local journal = db.characters["alberich-forever"].journal
local function Last(kind)
    for i = #journal, 1, -1 do if journal[i].k == kind then return journal[i] end end
end
local function Count(kind)
    local n = 0
    for _, entry in ipairs(journal) do if entry.k == kind then n = n + 1 end end
    return n
end
Fire("PLAYER_ENTERING_WORLD"); RunTimers()

-- 1. Numbered placeholders: the area is still read from the message, and no error.
local ok, err = pcall(Fire, "UI_INFO_MESSAGE", 1, "Entdeckt Klingenhügel: 55 Erfahrung erhalten")
check(ok, "a numbered-placeholder string makes a usable pattern: " .. tostring(err))
check(Last("explore") and Last("explore").d == "Klingenhügel", "the area named from the numbered message")
clock = clock + 60
Fire("UI_INFO_MESSAGE", 2, "Entdeckt: Tiragardefeste")
check(Last("explore").d == "Tiragardefeste", "the plain message still reads")

-- 2. A standing and a rank reached while the setting was off.
local mine = db.characters["alberich-forever"]
equal(mine.rep.Orgrimmar, 4, "seeded at the start")
db.moreMoments = false
A.UpdateSelfJournalEvents()
factions[1].reaction = 6
skills[1].rank = 160
Fire("UPDATE_FACTION"); Fire("SKILL_LINES_CHANGED")
equal(Count("rep") + Count("skill"), 0, "nothing while off")
clock = clock + 3600
db.moreMoments = true
A.UpdateSelfJournalEvents()
Fire("UPDATE_FACTION"); Fire("SKILL_LINES_CHANGED")
equal(Count("rep"), 0, "honored, reached while it was off, is not told as reached now")
equal(Count("skill"), 0, "Cooking 75 and 150, reached while it was off, are not told as reached now")
equal(mine.rep.Orgrimmar, 6, "but the standing is brought up to date")
equal(mine.skills.Cooking, 160, "and the rank too")

-- 3. Seeded at once on turning it on: the first change after that is told.
clock = clock + 60
factions[2].reaction = 5
Fire("UPDATE_FACTION")
check(Last("rep") and Last("rep").d == "Ratchet" and Last("rep").s == 5, "the first standing reached after turning it on is told")
clock = clock + 60
skills[1].rank = 226
Fire("SKILL_LINES_CHANGED")
check(Last("skill") and Last("skill").c == 225, "the first rank mark after turning it on is told")

-- 3b. A login whose first look finds no factions yet seeds nothing: a later look still only seeds.
-- (a fresh session is a fresh load of the file: simulated by turning the setting off and on)
db.moreMoments = false; A.UpdateSelfJournalEvents()
factions[1].reaction = 7
factionsReady = false
db.moreMoments = true; A.UpdateSelfJournalEvents()
factionsReady = true
local repsBefore = Count("rep")
Fire("UPDATE_FACTION")
equal(Count("rep"), repsBefore, "a standing first read this session is seeded, not told")

-- 4. The rare watch lets go when the target changes to something else.
target = {name = "Gravis Slipknot", rank = "rare"}
Fire("PLAYER_TARGET_CHANGED")
check(rareFrame.events.UNIT_HEALTH, "a living rare targeted: its health is watched")
target = {name = "Durotar Tiger", rank = "normal"}
Fire("PLAYER_TARGET_CHANGED")
check(not rareFrame.events.UNIT_HEALTH, "another target: the watch is let go")
target = {name = "Gravis Slipknot", rank = "rare"}
Fire("PLAYER_TARGET_CHANGED")
check(rareFrame.events.UNIT_HEALTH, "the rare again: watched again")
target = nil
Fire("PLAYER_TARGET_CHANGED")
check(not rareFrame.events.UNIT_HEALTH, "no target: the watch is let go")
target = {name = "Gravis Slipknot", rank = "rare"}
Fire("PLAYER_TARGET_CHANGED")
target.dead, inCombat = true, true
A.SelfRareHealth()
check(Last("rarekill") and Last("rarekill").d == "Gravis Slipknot", "a rare killed while watched is still kept")
check(not rareFrame.events.UNIT_HEALTH, "and the watch is let go after the kill")
inCombat = false

-- 5. A trainer window open when the setting goes off.
clock = clock + 60
Fire("TRAINER_SHOW")
db.moreMoments = false; A.UpdateSelfJournalEvents()
db.moreMoments = true; A.UpdateSelfJournalEvents()
Fire("LEARNED_SPELL_IN_SKILL_LINE", 20271, 1, false)
check(not Last("learn"), "a spell learned after the window went unseen is not a purchase")
Fire("TRAINER_SHOW"); Fire("LEARNED_SPELL_IN_SKILL_LINE", 20271, 1, false); Fire("TRAINER_CLOSED")
check(Last("learn") and Last("learn").c == 1, "the trainer still counts when its window is seen")

io.write("PASS: " .. assertions .. " code review assertions\n")
