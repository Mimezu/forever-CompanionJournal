-- Run from the client root: lua5.1 Interface/AddOns/CompanionJournal/tests/PartyElites.lua
-- Your own journal, lane REC8 (2026-11-12): everyone in your group, in your list or not
-- (one "member" line per member per stay, written once they have been with you a minute;
-- gone and back within five minutes, or a /reload, goes on with the same line; guild,
-- friend and Battle.net flags; never a secret name) and the elite foes fought in the open
-- (one "elites" line per stretch: how many, the seconds fighting them, the named ones;
-- never inside a dungeon). The book's stays and the day's episodes carry members,
-- partySize, partyMax, elites, eliteSeconds, eliteNames, dangerous; a journal without
-- such lines is read as before; the day generator writes both kinds.
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
local zone, subzone = "Silverpine Forest", ""
local instance
function GetRealZoneText() return zone end
function GetSubZoneText() return subzone end
function IsResting() return false end
function IsInInstance() return instance ~= nil, instance and "party" or "none" end
function GetInstanceInfo() return instance end
function GetNormalizedRealmName() return "Forever" end
function GetRealmName() return "Forever" end
C_QuestLog = {GetTitleForQuestID = function(id) return "Quest " .. tostring(id) end}
-- Secret values: a sentinel the guards must refuse.
local SECRET = {}
function issecretvalue(value) return value == SECRET end
-- The group: a list of {name, class, level, race, guild = , friend = , bnet = , guid = }.
local members, inGroup, groupCount = {}, false, nil
local function M(name, class, lvl, race, extra)
    local m = {name, class, lvl, race}
    for k, v in pairs(extra or {}) do m[k] = v end
    return m
end
function IsInGroup() return inGroup end
function IsInRaid() return false end
function GetNumGroupMembers() if groupCount ~= nil then return groupCount end return inGroup and (#members + 1) or 0 end
function GetNumSubgroupMembers() return inGroup and #members or 0 end
function UnitIsUnit() return false end
local function Member(unit) return members[tonumber(unit:match("^party(%d+)$") or 0)] end
function UnitFullName(unit) local m = Member(unit); if m then return m[1], "Forever" end end
-- The target: {name, rank, dead, player, guid, level}; combat on or off.
local target, inCombat, hp, dead = nil, false, 100, false
function UnitGUID(unit)
    if unit == "player" then return "Player-1-00000001" end
    if unit == "target" then return target and target.guid or nil end
    local m = Member(unit)
    if m then return m.guid or ("Player-1-" .. tostring(m[1])) end
end
local level = 22
function UnitLevel(unit)
    if unit == "player" then return level end
    if unit == "target" then return target and target.level or 25 end
    local m = Member(unit); return m and m[3] or 0
end
function UnitFactionGroup(unit) if unit == "player" then return "Horde" end return "Horde" end
function UnitClass(unit)
    if unit == "player" then return "Mage", "MAGE" end
    local m = Member(unit); if m then return m[2], m[2] end
end
function UnitRace(unit)
    if unit == "player" then return "Undead", "Scourge" end
    local m = Member(unit); if m then return m[4], m[4] end
end
function UnitIsInMyGuild(unit) local m = Member(unit); return m and m.guild or false end
local function ByGuid(guid) for _, m in ipairs(members) do if guid == (m.guid or ("Player-1-" .. tostring(m[1]))) then return m end end end
C_FriendList = {IsFriend = function(guid) local m = ByGuid(guid); return m and m.friend or false end}
C_BattleNet = {GetGameAccountInfoByGUID = function(guid) local m = ByGuid(guid); if m and m.bnet then return {characterName = m[1]} end end}
function UnitName(unit) if unit == "player" then return "Alberich" end if unit == "target" and target then return target.name end end
function UnitClassification(unit) if unit == "target" and target then return target.rank end return nil end
function UnitCanAttack(_, unit) return unit == "target" and target ~= nil end
function UnitIsDeadOrGhost(unit) if unit == "player" then return dead end return unit == "target" and target ~= nil and target.dead == true end
function UnitIsPlayer(unit) if unit == "target" then return target ~= nil and target.player == true end return true end
function UnitAffectingCombat() return inCombat end
function UnitHealth() return hp end
function UnitHealthMax() return 100 end
function IsSwimming() return false end
local timers = {}
C_Timer = {After = function(delay, fn) if delay >= 10 then timers[#timers + 1] = fn else fn() end end}
local function RunTimers() local list = timers; timers = {}; for _, fn in ipairs(list) do fn() end end
print = function() end

local A = {defaults = {colors = {}}}
for _, file in ipairs({"People.lua", "Characters.lua", "GroupPrompt.lua", "Journal.lua", "JournalSelf.lua", "JournalBook.lua", "JournalEpisodes.lua"}) do
    assert(loadfile(root .. file))("CompanionJournal", A)
end
A.Refresh = function() end
local db = {enabled = true, peopleJournal = true, peopleAutoGroup = false, colors = {people = {1, 1, 1}}, people = {},
    characters = {["alberich-forever"] = {name = "Alberich", faction = "Horde", class = "MAGE", race = "Scourge", people = {}}}}
for key, value in pairs(A.defaults) do if db[key] == nil then db[key] = value end end
A.db = db
A.InitPeople()
A.InitCharacters()
-- Marrow is in my list; the rest of tonight's group are not.
local marrowKey = A.PersonKey("Marrow", "Forever")
db.people[marrowKey] = {name = "Marrow-Forever", faction = "Horde", class = "PALADIN", race = "Scourge", circle = "companion"}
A.People = db.people
A.UpdateJournalEvents()
A.UpdateSelfJournalEvents()
local selfFrame, groupFrame
for _, f in ipairs(frames) do
    if f.events.QUEST_TURNED_IN and f.events.ZONE_CHANGED_NEW_AREA and f.events.PLAYER_REGEN_DISABLED then selfFrame = f end
    if f.events.GROUP_ROSTER_UPDATE and f.events.ENCOUNTER_END then groupFrame = f end
end
check(selfFrame and groupFrame, "both recorders listen")
check(selfFrame.events.PLAYER_REGEN_ENABLED, "the end of a fight is heard")
local function Fire(event, ...) selfFrame.scripts.OnEvent(selfFrame, event, ...) end
local function Roster() groupFrame.scripts.OnEvent(groupFrame, "GROUP_ROSTER_UPDATE") end
local journal = db.characters["alberich-forever"].journal
local function Lines(kind)
    local out = {}
    for _, entry in ipairs(journal) do if entry.k == kind then out[#out + 1] = entry end end
    return out
end
local function Of(name)
    local out = {}
    for _, entry in ipairs(journal) do if entry.k == "member" and entry.n == name then out[#out + 1] = entry end end
    return out
end
local BOROX = M("Borox", "HUNTER", 21, "Troll", {guild = true})
local GORNA = M("Gorna", "WARRIOR", 23, "Orc", {bnet = true})
local MORTIS = M("Mortis", "PRIEST", 20, "Scourge", {friend = true})

-- 1. Alone: nothing. A group of four forms (three not in my list); nothing is written until a
-- member has been with me a minute; one who drops and comes back inside that minute is
-- written once, from when they came back.
check(journal[1].k == "play" and journal[1].z == "Silverpine Forest" and not journal[1].e, "a stretch in Silverpine is open")
equal(#Lines("member"), 0, "alone: no member line")
members, inGroup = {BOROX, GORNA, MORTIS}, true
local formed = clock
Roster()
equal(#Lines("member"), 0, "a group just formed: nothing yet")
clock = clock + 10; members = {BOROX, GORNA}; Roster()
clock = clock + 15; members = {BOROX, GORNA, MORTIS}; Roster()
local mortisBack = clock
clock = clock + 60; RunTimers()
equal(#Lines("member"), 3, "three member lines once they held a minute")
local borox, gorna, mortis = Of("Borox-Forever")[1], Of("Gorna-Forever")[1], Of("Mortis-Forever")[1]
check(borox and gorna and mortis, "each by Name-Realm")
equal(borox.t, formed, "Borox joined when the group formed")
equal(mortis.t, mortisBack, "Mortis's minute began again when he came back")
equal(borox.c, "HUNTER", "class token"); equal(borox.r, "Troll", "race token"); equal(borox.lv, 21, "level")
check(borox.g == true and not borox.f, "Borox: my guild")
check(gorna.f == true and gorna.b == true and not gorna.g, "Gorna: a Battle.net friend")
check(mortis.f == true and not mortis.b, "Mortis: a character friend")
check(borox.e == nil and borox.l == nil, "open, not in my list")
-- A member there under a minute is not kept.
members = {BOROX, GORNA, MORTIS, M("Saint", "ROGUE", 24, "Scourge")}; Roster()
clock = clock + 30; members = {BOROX, GORNA, MORTIS}; Roster()
clock = clock + 60; RunTimers()
equal(#Of("Saint-Forever"), 0, "Saint, gone within the minute, is not kept")

-- 2. Half an hour on, Mortis leaves: his line closes. He comes back four minutes later: the
-- same line goes on (merged). Marrow (in my list) joins: his line says so.
clock = clock + 1800; members = {BOROX, GORNA}; Roster()
equal(mortis.e, clock, "Mortis's line closed when he left")
clock = clock + 240; members = {BOROX, GORNA, MORTIS}; Roster()
check(mortis.e == nil, "back within five minutes: the same line, open again")
equal(#Of("Mortis-Forever"), 1, "still one line for Mortis")
clock = clock + 600; members = {BOROX, GORNA, MORTIS, M("Marrow", "PALADIN", 22, "Scourge")}; Roster()
clock = clock + 60; RunTimers()
local marrow = Of("Marrow-Forever")[1]
check(marrow and marrow.l == "companion", "Marrow's line: a companion")
equal(#Lines("with"), 1, "Marrow's own with line is written as before")
-- Borox added to my list mid-stay: his line now says so.
db.people[A.PersonKey("Borox", "Forever")] = {name = "Borox-Forever", faction = "Horde", class = "HUNTER", race = "Troll", circle = "acquaintance"}
clock = clock + 120; Roster()
equal(borox.l, "acquaintance", "added to my list during the stay: the line knows")
equal(#Lines("member"), 4, "a roster event without a change writes nothing")
-- A level gained is kept.
BOROX[3] = 22; Roster(); equal(borox.lv, 22, "the level follows")

-- 3. A /reload: the lines close at logout and go on after the login.
clock = clock + 300
Fire("PLAYER_LOGOUT"); groupFrame.scripts.OnEvent(groupFrame, "PLAYER_LOGOUT")
equal(borox.e, clock, "closed at logout")
clock = clock + 30
Fire("PLAYER_ENTERING_WORLD"); groupFrame.scripts.OnEvent(groupFrame, "PLAYER_ENTERING_WORLD")
Roster()
clock = clock + 60; RunTimers()
equal(#Lines("member"), 4, "a /reload adds no line")
check(borox.e == nil and gorna.e == nil and marrow.e == nil, "the same lines go on")

-- 4. Leaving the group closes every line; a group of under a minute is nothing.
clock = clock + 900; members, inGroup = {}, false; Roster()
local parted = clock
equal(borox.e, parted, "closed when I left")
equal(gorna.e, parted, "all of them")
clock = clock + 400; members, inGroup = {M("Saint", "ROGUE", 24, "Scourge")}, true; Roster()
clock = clock + 20; members, inGroup = {}, false; Roster()
clock = clock + 60; RunTimers()
equal(#Lines("member"), 4, "a group of under a minute is nothing")
-- Gone longer than five minutes: a new line when they come back.
clock = clock + 600; members, inGroup = {BOROX}, true; Roster(); clock = clock + 60; RunTimers()
equal(#Of("Borox-Forever"), 2, "back after a long while: a new stay, a new line")
clock = clock + 600; members, inGroup = {}, false; Roster()

-- 5. Secret values: a secret name is never written; a secret class, race, level, GUID or
-- guild answer is left out; a hidden member is not taken for someone who left.
members, inGroup = {BOROX, M(SECRET, "ROGUE", 24, "Orc"), M("Gorna", SECRET, SECRET, SECRET, {guid = SECRET})}, true
clock = clock + 400; Roster(); clock = clock + 60; RunTimers()
local secretGorna = Of("Gorna-Forever")[2]
check(secretGorna, "Gorna is recorded by name")
check(secretGorna.c == nil and secretGorna.r == nil and secretGorna.lv == nil and secretGorna.f == nil and secretGorna.b == nil,
    "her secret class, race, level and GUID are left out")
for _, entry in ipairs(Lines("member")) do
    check(type(entry.n) == "string", "a member line always has a public name")
    for _, v in pairs(entry) do check(v ~= SECRET, "nothing secret is written") end
end
-- A roster with a hidden member (incomplete): those who seem gone are not closed.
members = {M(SECRET, "ROGUE", 24, "Orc")}
local incomplete = UnitIsUnit
UnitIsUnit = function(unit) if unit == "party1" then return SECRET end return false end
clock = clock + 60; Roster()
check(secretGorna.e == nil, "an unreadable roster does not close anyone")
UnitIsUnit = incomplete
clock = clock + 600; members, inGroup = {}, false; Roster()
check(secretGorna.e ~= nil, "closed when I leave")

-- 6. Elite foes: counted on the stretch while in combat, the same foe once (by GUID, or by
-- name within two minutes), never a player, never the dead, never inside a dungeon or out
-- of combat; the time fighting them; the named ones.
equal(#Lines("elites"), 0, "no elite fought yet")
local fightStart = clock
inCombat = true
target = {name = "Son of Arugal", rank = "elite", guid = "Creature-0-1-1-1-1-A"}; Fire("PLAYER_REGEN_DISABLED")
local elites = Lines("elites")
equal(#elites, 1, "an elite fought: one line")
equal(elites[1].c, 1, "one so far")
clock = clock + 20; Fire("PLAYER_TARGET_CHANGED")
equal(elites[1].c, 1, "the same foe again is the same foe")
clock = clock + 30; target = {name = "Son of Arugal", rank = "elite", guid = "Creature-0-1-1-1-1-B"}; Fire("PLAYER_TARGET_CHANGED")
equal(elites[1].c, 2, "another Son of Arugal (another GUID) is another foe")
clock = clock + 30; Fire("PLAYER_REGEN_ENABLED")
equal(elites[1].s, 80, "eighty seconds fighting them")
equal(elites[1].e, clock, "e is the end of the last fight")
inCombat = true
target = {name = "Moonrage Darkrunner", rank = "normal"}; Fire("PLAYER_REGEN_DISABLED")
equal(elites[1].c, 2, "an ordinary foe is not counted")
clock = clock + 40; Fire("PLAYER_REGEN_ENABLED")
equal(elites[1].s, 80, "nor its fight")
inCombat = true
target = {name = "Nightlash", rank = "rareelite"}; Fire("PLAYER_TARGET_CHANGED")
equal(elites[1].c, 3, "a rare elite counts")
equal(elites[1].x and elites[1].x[1], "Nightlash", "and keeps its name")
target = {name = "Dead Rot Hide", rank = "elite", dead = true}; Fire("PLAYER_TARGET_CHANGED")
equal(elites[1].c, 3, "a dead one does not")
target = {name = "Tobias", rank = "elite", player = true}; Fire("PLAYER_TARGET_CHANGED")
equal(elites[1].c, 3, "a player does not")
clock = clock + 2000; Fire("PLAYER_REGEN_ENABLED")
equal(elites[1].s, 80 + 600, "a fight counts ten minutes at most")
inCombat = false; target = {name = "Rot Hide Gnoll", rank = "elite"}; Fire("PLAYER_TARGET_CHANGED")
equal(elites[1].c, 3, "out of combat does not")
inCombat = true
-- No GUID: the same name within two minutes is the same foe; after that another.
target = {name = "Rot Hide Brute", rank = "elite"}; Fire("PLAYER_TARGET_CHANGED")
clock = clock + 60; Fire("PLAYER_TARGET_CHANGED")
equal(elites[1].c, 4, "by name: once within two minutes")
clock = clock + 200; Fire("PLAYER_TARGET_CHANGED")
equal(elites[1].c, 5, "by name: another after two minutes")
-- A skull-level elite is named; a plain elite is not.
target = {name = "Old Grizzlegut", rank = "elite", level = -1}; Fire("PLAYER_TARGET_CHANGED")
equal(#elites[1].x, 2, "a skull-level elite is named")
for _, n in ipairs(elites[1].x) do check(n ~= "Rot Hide Brute" and n ~= "Son of Arugal", "plain elites are not named") end
-- A secret name still counts (once); a secret rank never does; nothing secret is written.
clock = clock + 200; target = {name = SECRET, rank = "elite", guid = SECRET}; Fire("PLAYER_TARGET_CHANGED")
equal(elites[1].c, 7, "a secret name counts")
clock = clock + 5; target = {name = "Whoever", rank = SECRET}; Fire("PLAYER_TARGET_CHANGED")
equal(elites[1].c, 7, "a secret rank is not read as elite")
clock = clock + 60; Fire("PLAYER_REGEN_ENABLED")
for _, v in pairs(elites[1]) do check(v ~= SECRET, "nothing secret in the elites line") end
for _, v in ipairs(elites[1].x) do check(v ~= SECRET, "nor in its names") end
-- A /reload goes on with the same line.
clock = clock + 100; Fire("PLAYER_LOGOUT"); clock = clock + 30; Fire("PLAYER_ENTERING_WORLD")
clock = clock + 200; target = {name = "Rot Hide Mystic", rank = "elite"}; Fire("PLAYER_REGEN_DISABLED")
equal(#Lines("elites"), 1, "a /reload adds no line")
equal(elites[1].c, 8, "counted on")
clock = clock + 90; Fire("PLAYER_REGEN_ENABLED"); inCombat = false
check(elites[1].s >= 600, "ten minutes and more among elites (" .. tostring(elites[1].s) .. ")")
-- Inside a dungeon nothing is counted (everything is elite there).
clock = clock + 300; instance, zone = "Shadowfang Keep", "Shadowfang Keep"; Fire("ZONE_CHANGED_NEW_AREA")
inCombat = true; target = {name = "Shadowfang Moonwalker", rank = "elite"}; Fire("PLAYER_REGEN_DISABLED")
equal(#Lines("elites"), 1, "nothing in a dungeon")
clock = clock + 60; Fire("PLAYER_REGEN_ENABLED")
clock = clock + 3600; instance, zone = nil, "Silverpine Forest"; Fire("ZONE_CHANGED_NEW_AREA")
clock = clock + 100; target = {name = "Son of Arugal", rank = "elite", guid = "Creature-0-1-1-1-1-C"}; Fire("PLAYER_REGEN_DISABLED")
equal(#Lines("elites"), 2, "a new stretch: a new line")
clock = clock + 45; Fire("PLAYER_REGEN_ENABLED")
inCombat, target = false, nil
equal(Lines("elites")[2].s, 45, "the second stretch's own time")

-- 7. The book: the stays carry the members, the size, the elites; the episodes too.
local me = A.SelfPerson()
local days = A.JournalBook(me)
local tonight = days[#days]
local first
for _, scene in ipairs(tonight.scenes) do if scene.kind == "outing" and scene.zone == "Silverpine Forest" then first = first or scene end end
check(first, "the first Silverpine stay")
check(first.members and #first.members >= 4, "the stay knows its members (" .. tostring(first.members and #first.members) .. ")")
local byName = {}
for _, m in ipairs(first.members) do byName[m.name] = m end
local b = byName.Borox
check(b and b.full == "Borox-Forever" and b.class == "HUNTER" and b.race == "Troll" and b.guild == true and b.circle == "acquaintance", "Borox on the stay, with his flags")
check(b.significant == true and b.seconds >= 600, "Borox was with me long enough to matter")
check(byName.Gorna.friend == true and byName.Gorna.bnet == true, "Gorna: a Battle.net friend")
check(byName.Marrow.circle == "companion", "Marrow: a companion")
for _, m in ipairs(first.members) do
    for _, sp in ipairs(m.spans) do check(sp[2] - sp[1] >= 60 and sp[1] >= first.t and sp[2] <= first.e, "spans are clipped to the stay") end
    check(m.significant == (m.seconds >= 600), "significant is ten minutes together")
end
check(first.members[1].t <= first.members[#first.members].t, "first come first")
equal(first.partyMax, 5, "the most at once: five, me among them")
check(first.partySize == 1, "the size that held longest: alone (the solo elite fights ran longer) (" .. tostring(first.partySize) .. ")")
equal(first.elites, 8, "eight elites on the first stay")
check(first.eliteSeconds >= 600, "ten minutes and more fighting them")
equal(first.dangerous, true, "a dangerous stay")
check(first.eliteNames and first.eliteNames[1] == "Nightlash" and first.eliteNames[2] == "Old Grizzlegut", "the named elites")
local keep = A.JournalEpisodes.Day(tonight.scenes)
check(#keep.episodes >= 1, "episodes")
local ep = keep.episodes[1]
check(ep.members and #ep.members >= 4, "the episode's members")
equal(ep.partyMax, 5, "the episode's largest party")
check(ep.partySize ~= nil, "the episode's typical party (" .. tostring(ep.partySize) .. ")")
equal(ep.elites, 8, "the episode's elites")
check(ep.eliteSeconds >= 600 and ep.dangerous == true, "the episode was dangerous")
check(ep.eliteNames and #ep.eliteNames == 2, "the episode's named elites")
local epB
for _, m in ipairs(ep.members) do if m.name == "Borox" then epB = m end end
check(epB and epB.significant and epB.guild, "Borox in the episode, significant, my guild")
check(type(ep.party) == "table" and ep.party[1] == "Marrow", "ep.party keeps the list's names, as before")
-- A small elite count: not dangerous.
local later
for _, scene in ipairs(tonight.scenes) do if scene.kind == "outing" and scene.zone == "Silverpine Forest" and scene ~= first then later = scene end end
check(later and later.elites == 1 and later.dangerous == false and later.eliteNames == nil, "one plain elite: counted, not dangerous, unnamed")
local lone
for _, scene in ipairs(tonight.scenes) do if scene.kind == "outing" and scene.zone == "Shadowfang Keep" then lone = scene end end
check(lone and lone.partySize == nil and lone.elites == nil and lone.members == nil, "a stay without group or elites: nil, as before")

-- 8. An old journal (no such lines) is read as before: nil everywhere.
local old = {self = true, name = "Vesk", charKey = "vesk-forever", journal = {
    {k = "play", t = clock - 86400 * 3, e = clock - 86400 * 3 + 5400, z = "The Barrens", pl = 20},
    {k = "with", d = marrowKey, n = "Marrow-Forever", t = clock - 86400 * 3 + 60, e = clock - 86400 * 3 + 5400, z = "The Barrens"},
    {k = "quest", d = "Supplies for the Crossroads", t = clock - 86400 * 3 + 900, z = "The Barrens", pl = 20},
    {k = "hk", c = 2, t = clock - 86400 * 3 + 1200, z = "The Barrens"},
}}
local oldDays = A.JournalBook(old)
local oldScene = oldDays[1].scenes[1]
check(oldScene.kind == "outing" and oldScene.members == nil and oldScene.partySize == nil and oldScene.partyMax == nil and oldScene.elites == nil
    and oldScene.eliteSeconds == nil and oldScene.dangerous == nil, "an old journal: no members, no elites")
check(oldScene.with and oldScene.with[1].name == "Marrow", "and Marrow still with me")
local oldDay = A.JournalEpisodes.Day(oldDays[1].scenes)
local oe = oldDay.episodes[1]
check(oe.partySize == nil and oe.partyMax == nil and oe.elites == nil and oe.members == nil and oe.dangerous == nil and oe.eliteSeconds == nil,
    "an old journal's episodes: nil too")
check(oe.party[1] == "Marrow", "the names present are as before")

-- 9. Hand-made spans: the typical size counts the alone time, the largest is kept.
local function Outing() return {kind = "outing", t = 1000, e = 1000 + 7200, entries = {}, events = {}, quests = {}, questCount = 0, dungeons = {}, bosses = {}, levels = {}} end
local outing = Outing()
A.JournalMemberSpans({outing}, {
    {k = "member", n = "A-Forever", t = 1000, e = 1000 + 600}, {k = "member", n = "B-Forever", t = 1000, e = 1000 + 600},
    {k = "member", n = "C-Forever", t = 1000, e = 1000 + 600}, {k = "member", n = "D-Forever", t = 1000, e = 1000 + 4800},
    {k = "member", n = "E-Forever", t = 1000 + 4800, e = 1000 + 4830}, {k = "member", n = "F-Forever", t = 1000 + 7000}}, 1000 + 7200)
equal(#outing.members, 5, "a span under a minute is dropped")
equal(outing.partyMax, 5, "the largest: four members and me")
equal(outing.partySize, 2, "the size that held longest")
local alone = Outing()
A.JournalMemberSpans({alone}, {{k = "member", n = "A-Forever", t = 1000, e = 1000 + 1200}, {k = "member", n = "B-Forever", t = 1000, e = 1000 + 300}}, 1000 + 7200)
equal(alone.partySize, 1, "mostly alone: one")
equal(alone.partyMax, 3, "but three for a while")
check(alone.members[1].significant == true and alone.members[2].significant == false, "twenty minutes matter, five do not")
check(A.JournalDangerous(6, 0) and A.JournalDangerous(1, 600) and not A.JournalDangerous(5, 599), "dangerous: six elites or ten minutes")

-- 10. The self journal off: nothing recorded, nothing breaks.
db.selfJournal = false
A.UpdateSelfJournalEvents()
local count = #journal
members, inGroup = {BOROX}, true; Roster(); clock = clock + 60; RunTimers()
inCombat = true; target = {name = "Son of Arugal", rank = "elite"}; Fire("PLAYER_REGEN_DISABLED"); inCombat = false
equal(#journal, count, "off: nothing written")
db.selfJournal = true
members, inGroup = {}, false

-- 11. The day generator writes both kinds, and the book reads them.
C_Timer = {After = function() end}
LOCALIZED_CLASS_NAMES_MALE = {WARRIOR = "Warrior", MAGE = "Mage", PRIEST = "Priest", ROGUE = "Rogue", WARLOCK = "Warlock",
    HUNTER = "Hunter", DRUID = "Druid", SHAMAN = "Shaman", PALADIN = "Paladin"}
local L = {defaults = {colors = {}}}
for _, file in ipairs({"LoreData.lua", "Lore.lua", "LoreHordeStories.lua", "LoreAllianceStories.lua", "LoreWorldStories.lua",
    "LoreClassStories.lua", "LoreForeverStories.lua", "People.lua", "Characters.lua", "Journal.lua", "JournalBook.lua", "JournalEpisodes.lua"}) do
    assert(loadfile(root .. file))("CompanionJournal", L)
end
L.db = {people = {}}
local gen = loadfile("StorageInvestigation/cj-story-breakthrough-20261109/pass3/gen_days.lua")
check(gen, "the generator loads")
local G = gen()
local lives = G.Generate(L, 20261111, 40)
local memberLines, strangers, flagged, elitesLines, named, booked, dangerous, significant = 0, 0, 0, 0, 0, 0, 0, 0
for _, life in ipairs(lives) do
    for _, e in ipairs(life.journal) do
        if e.k == "member" then
            memberLines = memberLines + 1
            check(type(e.n) == "string" and e.n:find("%-") and e.e and e.e >= e.t and e.c and e.r, "a generated member line is well formed")
            if not e.l then strangers = strangers + 1 end
            if e.g or e.f then flagged = flagged + 1 end
        elseif e.k == "elites" then
            elitesLines = elitesLines + 1
            check(type(e.c) == "number" and e.c >= 1 and type(e.s) == "number" and e.e and e.e >= e.t and e.z, "a generated elites line is well formed")
            if e.x then named = named + 1 end
        end
    end
    L.SelfPerson = function() return life end
    local lifeDays = L.JournalBook(life)
    for _, day in ipairs(lifeDays) do
        for _, scene in ipairs(day.scenes) do
            if scene.members or scene.elites then booked = booked + 1 end
            if scene.dangerous then dangerous = dangerous + 1 end
        end
        local d = L.JournalEpisodes.Day(day.scenes)
        for _, e in ipairs(d.episodes) do
            for _, m in ipairs(e.members or {}) do if m.significant then significant = significant + 1 end end
        end
    end
end
check(memberLines >= 10, "the generator writes member lines (" .. memberLines .. ")")
check(strangers >= 3, "some of them not in the list (" .. strangers .. ")")
check(flagged >= 1, "a guildmate or a friend among them (" .. flagged .. ")")
check(elitesLines >= 3, "the generator writes elites lines (" .. elitesLines .. ")")
check(named >= 1, "a named elite now and then (" .. named .. ")")
check(booked >= 5, "and the book reads them onto stays (" .. booked .. ")")
check(dangerous >= 1, "some stays are dangerous (" .. dangerous .. ")")
check(significant >= 5, "and the episodes know who mattered (" .. significant .. ")")

print(assertions .. " checks passed")
io.write(assertions .. " checks passed\n")
