-- Run from the client root: lua5.1 Interface/AddOns/CompanionJournal/tests/BattlegroundRecord.lua
-- A battleground match at its end screen ("Record more moments" on): the result
-- from the winner and my side, the length, my score line, the battleground's
-- own marks by column name, the most killing blows on my side, listed people in
-- the match; secret numbers dropped field by field; a match left early keeps
-- the plain entry; off, nothing beyond the old entry is written.
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
local zone, subzone = "Orgrimmar", "Valley of Strength"
local instance, instanceKind
function GetRealZoneText() return zone end
function GetSubZoneText() return subzone end
function IsResting() return false end
function IsInInstance() return instance ~= nil, instance and instanceKind or "none" end
function GetInstanceInfo() return instance end
function GetNormalizedRealmName() return "Forever" end
function GetRealmName() return "Forever" end
C_QuestLog = {GetTitleForQuestID = function() return nil end}
function UnitFactionGroup(unit) if unit == "player" then return "Horde" end end
function UnitClass(unit) if unit == "player" then return "Paladin", "PALADIN" end end
function UnitRace(unit) if unit == "player" then return "Undead", "Scourge" end end
function UnitLevel(unit) if unit == "player" then return 29 end return 0 end
function UnitName(unit) if unit == "player" then return "Alberich" end end
function UnitGUID(unit) if unit == "player" then return "Player-1-000001" end end
function GetPlayerGuid() return "Player-1-000001" end
function UnitIsDeadOrGhost() return false end
function UnitHealth() return 100 end
function UnitHealthMax() return 100 end
function UnitIsPlayer() return false end
function UnitAffectingCombat() return false end
function IsSwimming() return false end
function GetPVPSessionStats() return 5, 0 end
local timers = {}
C_Timer = {After = function(delay, fn) if delay >= 10 then timers[#timers + 1] = fn else fn() end end}
print = function() end
-- A secret value: the game's issecretvalue says so, and nothing else about it is readable.
local SECRET = setmetatable({}, {__tostring = function() return "<secret>" end})
function issecretvalue(value) return value == SECRET end

-- The match as the client reports it at the end screen.
local myFaction = 0
function GetBattlefieldArenaFaction() return myFaction end
local scores = {}
function GetNumBattlefieldScores() return #scores end
local requested = 0
function RequestBattlefieldScoreData() requested = requested + 1 end
local matchComplete = false
C_PvP = {
    GetScoreInfo = function(i) return scores[i] end,
    GetScoreInfoByPlayerGuid = function(guid) for _, s in ipairs(scores) do if s.guid == guid then return s end end end,
    GetActiveMatchWinner = function() return 0 end,
    GetActiveMatchDuration = function() return 900 end,
    IsMatchComplete = function() return matchComplete end,
}
local function Line(name, guid, faction, kb, hk, dt, hon, stats)
    return {name = name, guid = guid, faction = faction, killingBlows = kb, honorableKills = hk, deaths = dt, honorGained = hon, stats = stats or {}}
end
local function Stat(name, value) return {pvpStatID = 0, name = name, pvpStatValue = value, orderIndex = 1} end

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
A.UpdateSelfJournalEvents()
local selfFrame
for _, f in ipairs(frames) do if f.events.QUEST_TURNED_IN and f.events.PLAYER_LEVEL_UP and f.events.ZONE_CHANGED_NEW_AREA then selfFrame = f end end
check(selfFrame, "your journal listens while the journal is on")
local function Fire(event, ...) selfFrame.scripts.OnEvent(selfFrame, event, ...) end
local journal = db.characters["alberich-forever"].journal
local function Last(kind)
    for i = #journal, 1, -1 do if journal[i].k == kind then return journal[i] end end
end
local function Enter(name)
    clock = clock + 300
    zone, instance, instanceKind = name, name, "pvp"
    Fire("ZONE_CHANGED_NEW_AREA")
end
local function Leave()
    clock = clock + 120
    zone, instance, instanceKind = "Orgrimmar", nil, nil
    Fire("ZONE_CHANGED_NEW_AREA")
end
-- Dahlia is on the list; Grak and the others are not.
local dahliaKey = A.PersonKey("Dahlia")
A.People[dahliaKey] = {name = "Dahlia"}
check(A.People[dahliaKey] and A.People[dahliaKey].name == "Dahlia", "Dahlia on the list")

Fire("PLAYER_ENTERING_WORLD")

-- 1. Off: entering a battleground writes the old entry; the end of the match adds nothing.
Enter("Warsong Gulch")
local plain = Last("bg")
check(plain and plain.d == "Warsong Gulch" and Last("first") and Last("first").d == "battleground", "the old entries on entering")
check(not selfFrame.events.PVP_MATCH_COMPLETE, "the match end is not listened for while the setting is off")
Fire("PVP_MATCH_COMPLETE", 0, 1140)
check(plain.r == nil and plain.dur == nil, "off: no result on the entry")
Leave()

-- 2. On: a win, with the score line, two flags, the most killing blows, and Dahlia in it.
db.moreMoments = true
A.UpdateSelfJournalEvents()
check(selfFrame.events.PVP_MATCH_COMPLETE, "the match end is listened for when on")
scores = {
    Line("Alberich", "Player-1-000001", 0, 4, 12, 2, 210, {Stat("Flags Captured", 2), Stat("Flags Returned", 0)}),
    Line("Dahlia", "Player-1-000002", 0, 3, 10, 1, 180, {Stat("Flags Captured", 0), Stat("Flags Returned", 1)}),
    Line("Grak", "Player-1-000003", 0, 1, 4, 5, 60),
    Line("Lirael-Forever", "Player-1-000004", 1, 9, 14, 0, 240, {Stat("Flags Captured", 1), Stat("Flags Returned", 2)}),
}
Enter("Warsong Gulch")
local won = Last("bg")
check(won ~= plain and won.d == "Warsong Gulch", "a new entry for the new match")
Fire("PVP_MATCH_COMPLETE", 0, 1140)
equal(won.r, "won", "the Horde won, and I am Horde")
equal(won.dur, 1140, "the length from the event")
equal(won.kb, 4, "killing blows"); equal(won.hk, 12, "honorable kills"); equal(won.dt, 2, "deaths"); equal(won.hon, 210, "honor")
check(won.m and won.m.fc == 2 and won.m.fr == nil, "two flags captured by name, no zero column kept")
equal(won.top, true, "the most killing blows on my side (the enemy's nine do not count)")
check(won.c and #won.c == 1 and won.c[1] == "Dahlia", "Dahlia, listed and on my side, found in the match; Grak is not listed")
check(requested >= 1, "the score data was requested")
Leave()

-- 3. A loss and a draw, by the winner against my side; Alliance side too.
Enter("Warsong Gulch")
Fire("PVP_MATCH_COMPLETE", 1, 700)
equal(Last("bg").r, "lost", "the Alliance won: a loss")
Leave()
Enter("Arathi Basin")
Fire("PVP_MATCH_COMPLETE", 2, 1500)
equal(Last("bg").r, "draw", "neither side: a draw")
Leave()
myFaction = 1
Enter("Arathi Basin")
Fire("PVP_MATCH_COMPLETE", 1, 1300)
equal(Last("bg").r, "won", "on the Alliance side (a mercenary), the Alliance winning is a win")
Leave()
myFaction = 0

-- 4. Secret numbers are dropped field by field; the names and the result still land.
scores = {
    Line("Alberich", "Player-1-000001", 0, SECRET, 12, SECRET, 210, {Stat("Bases Assaulted", SECRET), Stat("Bases Defended", 1)}),
    Line("Dahlia", "Player-1-000002", 0, SECRET, 10, 1, 180),
    Line("Grak", "Player-1-000003", 0, 1, 4, 5, 60),
}
Enter("Arathi Basin")
local secretMatch = Last("bg")
Fire("PVP_MATCH_COMPLETE", 0, 1000)
equal(secretMatch.r, "won", "the result does not depend on the score line")
check(secretMatch.kb == nil and secretMatch.dt == nil, "secret killing blows and deaths are not kept")
equal(secretMatch.hk, 12, "the public fields are")
check(secretMatch.m and secretMatch.m.bd == 1 and secretMatch.m.ba == nil, "a secret column is dropped, a public one kept")
check(secretMatch.top == nil, "no 'most killing blows' when a line on my side was secret")
check(secretMatch.c and secretMatch.c[1] == "Dahlia", "names are never secret: Dahlia still found")
Leave()

-- 5. Dahlia in my party: she is a `with` entry already, not a match companion.
scores = {
    Line("Alberich", "Player-1-000001", 0, 2, 8, 1, 150, {Stat("Towers Assaulted", 1), Stat("Graveyards Assaulted", 2)}),
    Line("Dahlia", "Player-1-000002", 0, 5, 10, 1, 180),
}
A.SelfWith(dahliaKey, A.People[dahliaKey], true)
Enter("Alterac Valley")
local av = Last("bg")
Fire("PVP_MATCH_COMPLETE", 0, 3600)
check(av.c == nil, "Dahlia grouped with me is not repeated in c")
check(av.m and av.m.ta == 1 and av.m.ga == 2, "towers and graveyards by name")
check(av.top == nil, "Dahlia had more killing blows: no mark")
A.SelfWith(dahliaKey, nil, false)
Leave()

-- 6. A match left early keeps the plain entry, and the next match is its own.
Enter("Warsong Gulch")
local left = Last("bg")
Leave()
Fire("PVP_MATCH_COMPLETE", 0, 400)
check(left.r == nil, "left early: no result")
Enter("Warsong Gulch")
local again = Last("bg")
check(again ~= left, "a new match, a new entry")
Fire("PVP_MATCH_COMPLETE", 0, 500)
equal(again.r, "won", "the new match has its result")
check(left.r == nil, "and the one left early still has none")
Leave()

-- 7. A /reload at the end screen: the match is still complete, and the entry is filled.
Enter("Arathi Basin")
local reloaded = Last("bg")
matchComplete = true
Fire("PLAYER_ENTERING_WORLD")
equal(reloaded.r, "won", "filled after a reload at the end screen (the winner from C_PvP)")
equal(reloaded.dur, 900, "the length from C_PvP when the event did not bring it")
matchComplete = false
Leave()

-- 8. The book carries the fields, and the plain lines say the result.
local me = A.SelfPerson()
local days = A.JournalBook(me)
local wonEvent, items
for _, day in ipairs(days) do
    for _, scene in ipairs(day.scenes) do
        for _, e in ipairs(scene.events or {}) do if e.k == "bg" and e.r == "won" and e.dur == 1140 then wonEvent = e end end
        for _, item in ipairs(A.JournalSceneItems(me, scene) or {}) do
            if (item.text or ""):find("Won in", 1, true) then items = true end
        end
    end
end
check(wonEvent and wonEvent.dur == 1140 and wonEvent.top == true and wonEvent.c[1] == "Dahlia", "the scene event carries result, length, marks, top and company")
check(items, "the Highlights item says Won in ...")

io.write("PASS: " .. assertions .. " battleground recording assertions\n")
