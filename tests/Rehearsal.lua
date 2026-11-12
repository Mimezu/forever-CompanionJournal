-- Run from the client root: lua5.1 Interface/AddOns/CompanionJournal/tests/Rehearsal.lua [print|save <tag>]
-- A rehearsal of the in-game checklist for "Record more moments" (1.13.0),
-- as close to the live client as a stub can be: the enUS global strings, the
-- real event order and payloads (UI_INFO_MESSAGE with GetGameMessageInfo, the
-- trainer window, UPDATE_FACTION bursts, the duel's system message, a plaque's
-- ITEM_TEXT_BEGIN, a rare's UNIT_HEALTH, your resurrection of a companion), a
-- login, a /reload in the middle (every file loaded again, the saved settings
-- kept), the setting off, on, off, on. Every event goes to every frame that
-- registered it, as the client does. Then the day is read: your own book in
-- Everything and Highlights over every retell, and Dahlia's book in both voices.
-- The last section prints what the client would have to do differently for a
-- moment to go unrecorded, and checks that nothing errors and nothing wrong is
-- written when it does.
--   print       prints the chapters (retell 0)
--   save <tag>  writes them to StorageInvestigation/cj-overnight-20261105/rehearsal/chapters-<tag>.txt
local root = "Interface/AddOns/CompanionJournal/"
local assertions = 0
local function check(value, message) assertions = assertions + 1; assert(value, message) end
local function equal(a, b, message) check(a == b, message .. " (got " .. tostring(a) .. ", expected " .. tostring(b) .. ")") end
local mode, tag = arg and arg[1], arg and arg[2]

-- The frames: every event reaches every frame that registered it; a unit
-- event registered for units reaches it only for those units.
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
function methods:RegisterUnitEvent(event, ...) self.events[event] = {...} end
function methods:UnregisterEvent(event) self.events[event] = nil end
function methods:Cancel() end
local frames = {}
function CreateFrame() local f = Object(); frames[#frames + 1] = f; return f end
UIParent = Object()
local function Fire(event, ...)
    local first = ...
    for _, f in ipairs(frames) do
        local reg = f.events[event]
        if reg and f.scripts.OnEvent then
            local wanted = true
            if type(reg) == "table" and #reg > 0 then
                wanted = false
                for _, unit in ipairs(reg) do if unit == first then wanted = true end end
            end
            if wanted then f.scripts.OnEvent(f, event, ...) end
        end
    end
end

-- The clock and the timers (C_Timer.After runs when its time comes, in order).
local clock = os.time({year = 2026, month = 11, day = 6, hour = 19, min = 0, sec = 0})
function time(t) if type(t) == "table" then return os.time(t) end return clock end
function GetTime() return clock end
function date(fmt, t) return os.date(fmt, t or clock) end
local timers, timerSeq = {}, 0
C_Timer = {
    After = function(delay, fn) timerSeq = timerSeq + 1; timers[#timers + 1] = {at = clock + delay, fn = fn, seq = timerSeq} end,
    NewTicker = function() return {Cancel = function() end} end,
}
local function Advance(seconds)
    local until_ = clock + seconds
    while true do
        local best, at
        for i, t in ipairs(timers) do
            if t.at <= until_ and (not best or t.at < best.at or (t.at == best.at and t.seq < best.seq)) then best, at = t, i end
        end
        if not best then break end
        table.remove(timers, at)
        if best.at > clock then clock = best.at end
        best.fn()
    end
    clock = until_
end
print = function() end

-- The world.
local zone, subzone, instance = "Hillsbrad Foothills", "Tarren Mill", nil
local target, inCombat, honor = nil, false, 2
local player = {name = "Alberich", class = "PALADIN", race = "Scourge", level = 23, faction = "Horde", player = true, hp = 100, max = 100}
local members, inGroup = {}, false
local itemText
local secret = {}
function issecretvalue(value) return secret[value] == true end
LOCALIZED_CLASS_NAMES_MALE = {WARRIOR = "Warrior", MAGE = "Mage", PRIEST = "Priest", ROGUE = "Rogue", WARLOCK = "Warlock",
    HUNTER = "Hunter", DRUID = "Druid", SHAMAN = "Shaman", PALADIN = "Paladin"}
local function Unit(unit)
    if unit == "player" then return player end
    if unit == "target" then return target end
    local i = type(unit) == "string" and unit:match("^party(%d)$")
    if i then return members[tonumber(i)] end
end
function UnitName(unit) local u = Unit(unit); return u and u.name end
function UnitFullName(unit) local u = Unit(unit); if u then return u.name, "Forever" end end
function UnitClass(unit) local u = Unit(unit); if u then return LOCALIZED_CLASS_NAMES_MALE[u.class], u.class end end
function UnitRace(unit) local u = Unit(unit); if u then return u.race == "Scourge" and "Undead" or u.race, u.race end end
function UnitLevel(unit) local u = Unit(unit); return u and u.level or 0 end
function UnitFactionGroup(unit) local u = Unit(unit); return u and u.faction end
function UnitIsPlayer(unit) local u = Unit(unit); return u ~= nil and u.player == true end
function UnitIsDeadOrGhost(unit) local u = Unit(unit); return u ~= nil and u.dead == true end
function UnitIsFeignDeath() return false end
function UnitIsUnit(a, b) return a == b end
function UnitExists(unit) return Unit(unit) ~= nil end
function UnitGUID(unit) local u = Unit(unit); return u and (u.player and ("Player-1-" .. u.name) or ("Creature-0-1-2-3-4-" .. u.name)) end
function UnitHealth(unit) local u = Unit(unit); return u and (u.hp or 100) or 0 end
function UnitHealthMax(unit) local u = Unit(unit); return u and (u.max or 100) or 0 end
function UnitCanAttack(_, unit) local u = Unit(unit); return u ~= nil and u.hostile == true end
function UnitClassification(unit) local u = Unit(unit); return u and u.rank or "normal" end
function UnitAffectingCombat(unit) return unit == "player" and inCombat end
function UnitInRange() return true, true end
function UnitOnTaxi() return false end
function UnitCreatureFamily() return nil end
function IsSwimming() return false end
function IsMounted() return false end
function IsFalling() return false end
function IsResting() return false end
function IsInGroup() return inGroup end
function IsInRaid() return false end
function GetNumGroupMembers() return inGroup and (#members + 1) or 0 end
function GetNumSubgroupMembers() return inGroup and #members or 0 end
function GetRealZoneText() return zone end
function GetSubZoneText() return subzone end
function IsInInstance() return instance ~= nil, instance and "party" or "none" end
function GetInstanceInfo() return instance end
function GetNormalizedRealmName() return "Forever" end
function GetRealmName() return "Forever" end
function GetGameTime() return 20, 15 end
function GetBindLocation() return "Undercity" end
function GetPVPSessionStats() return honor, 0 end
function GetUnitSpeed() return 7 end
local spells = {[7328] = "Redemption", [26573] = "Consecration", [5589] = "Hammer of Justice", [20271] = "Judgement", [8690] = "Hearthstone", [635] = "Holy Light"}
function GetSpellInfo(id) return spells[id] end
C_Spell = {GetSpellName = function(id) return spells[id] end}
C_QuestLog = {GetTitleForQuestID = function() return nil end, GetNumQuestLogEntries = function() return 0, 0 end,
    GetInfo = function() return nil end, IsComplete = function() return false end, IsUnitOnQuest = function() return false end}
local factions = {{name = "Horde", isHeader = true, reaction = 4}, {name = "Undercity", reaction = 5}, {name = "Orgrimmar", reaction = 4},
    {name = "Darkspear Trolls", reaction = 4}, {name = "Thunder Bluff", reaction = 4}, {name = "Steamwheedle Cartel", isHeader = true, reaction = 4}, {name = "Ratchet", reaction = 4}}
C_Reputation = {GetNumFactions = function() return #factions end, GetFactionDataByIndex = function(i) return factions[i] end}
local skills = {{name = "Class Skills", isHeader = true, rank = 0}, {name = "Holy", rank = 1, maxRank = 1}, {name = "Professions", isHeader = true, rank = 0},
    {name = "Mining", rank = 118, maxRank = 150}, {name = "Blacksmithing", rank = 96, maxRank = 150}, {name = "Secondary Skills", isHeader = true, rank = 0},
    {name = "First Aid", rank = 74, maxRank = 75}, {name = "Weapon Skills", isHeader = true, rank = 0}, {name = "Two-Handed Maces", rank = 110, maxRank = 115}}
C_SkillInfo = {GetNumSkillLines = function() return #skills end, GetSkillLineInfo = function(i) return skills[i] end}
function ItemTextGetItem() return itemText and itemText.title end
function ItemTextGetMaterial() return itemText and itemText.material end

-- The game's own strings (enUS). The texts are the known enUS values; the
-- local Forever UI source has no GlobalStrings.lua, so they are unverified here.
ERR_ZONE_EXPLORED = "Discovered: %s"
ERR_ZONE_EXPLORED_XP = "Discovered %s: %d experience gained"
ERR_NEWTAXIPATH = "New flight path discovered!"
DUEL_WINNER_KNOCKOUT = "%1$s has defeated %2$s in a duel"
DUEL_WINNER_RETREAT = "%2$s has fled from %1$s in a duel"
ERR_LEARN_SPELL_S = "You have learned a new spell: %s."
ERR_AUCTION_SOLD_S = "A buyer has been found for your auction of %s."
FACTION_STANDING_CHANGED = "You are now %s with %s."
FACTION_STANDING_INCREASED = "Reputation with %s increased by %d."
-- (the game error indexes: the UI maps them to the string names with GetGameMessageInfo)
local ZONE_XP, ZONE, TAXI, LEARN, OTHER = 32, 33, 41, 90, 7
local MESSAGE_NAMES = {[ZONE_XP] = "ERR_ZONE_EXPLORED_XP", [ZONE] = "ERR_ZONE_EXPLORED", [TAXI] = "ERR_NEWTAXIPATH", [LEARN] = "ERR_LEARN_SPELL_S", [OTHER] = "ERR_SYSTEM"}
function GetGameMessageInfo(index) return MESSAGE_NAMES[index] end
local function System(text) Fire("CHAT_MSG_SYSTEM", text, "", "", "", "", "", 0, 0, "", 0, 11, nil) end

-- The saved settings: kept across a /reload, as the client keeps them.
local db = {enabled = true, peopleJournal = true, selfJournal = true, colors = {people = {1, 1, 1}, groupmate = {0.5, 0.8, 1}}, people = {},
    characters = {["alberich-forever"] = {name = "Alberich", faction = "Horde", class = "PALADIN", race = "Scourge", people = {}, selfStartLevel = 10}}}
local FILES = {"LoreData.lua", "Lore.lua", "People.lua", "Characters.lua", "GroupPrompt.lua", "Journal.lua", "JournalSelf.lua", "JournalBook.lua",
    "JournalTellers.lua", "JournalTale.lua", "JournalWords.lua", "JournalSelfWords.lua", "JournalSelfTale.lua"}
local A
-- A login or a /reload: every frame gone, every file run again, the settings kept
-- (Core.lua: ADDON_LOADED runs InitPeople and the hooks, PLAYER_LOGIN InitCharacters
-- and the own-journal events).
local function Boot()
    frames = {}
    A = {defaults = {colors = {}}}
    for _, file in ipairs(FILES) do assert(loadfile(root .. file))("CompanionJournal", A) end
    A.Refresh = function() end
    A.SetOption = function(key, value) A.db[key] = value; A.UpdatePeopleHooks() end -- (Core.lua's, without the window refresh)
    for key, value in pairs(A.defaults) do if key ~= "colors" and db[key] == nil then db[key] = value end end
    A.db = db
    A.InitPeople()
    A.UpdatePeopleHooks()
    A.InitCharacters()
    A.UpdateSelfJournalEvents()
    return A
end
local function Login(reload)
    Fire("PLAYER_ENTERING_WORLD", not reload, reload)
    -- (the client's own burst after the loading screen)
    Fire("ZONE_CHANGED_NEW_AREA")
    for _ = 1, 6 do Fire("UPDATE_FACTION") end
    Fire("SKILL_LINES_CHANGED"); Fire("SKILL_LINES_CHANGED")
    Fire("SPELLS_CHANGED")
    Fire("PLAYER_ALIVE")
    Fire("UNIT_HEALTH", "player")
    Advance(40)
end
local function Journal() return db.characters["alberich-forever"].journal or {} end
local function Kinds(journal, from)
    local out = {}
    for i = from or 1, #journal do out[#out + 1] = journal[i].k .. (journal[i].w and (":" .. journal[i].w) or "") end
    return table.concat(out, ",")
end
local function Count(journal, kind, field, value)
    local n = 0
    for _, e in ipairs(journal) do if e.k == kind and (field == nil or e[field] == value) then n = n + 1 end end
    return n
end
local function Last(journal, kind)
    for i = #journal, 1, -1 do if journal[i].k == kind then return journal[i] end end
end
local MORE = {read = true, explore = true, taxi = true, learn = true, rep = true, duel = true, skill = true, hk = true, rarekill = true}
local function MoreKinds(journal)
    local out = {}
    for _, e in ipairs(journal) do if MORE[e.k] then out[#out + 1] = e.k end end
    return table.concat(out, ",")
end
local function SelfFrame()
    for _, f in ipairs(frames) do if f.events.PLAYER_MOUNT_DISPLAY_CHANGED and f.events.QUEST_TURNED_IN then return f end end
end

-- 0. Login with the setting off: the old record only ------------------------------
Boot()
equal(db.moreMoments, false, "the setting starts off")
Login(false)
local me = Journal()
equal(MoreKinds(me), "", "a login opens the day's stretch (and the old firsts), no new kind: " .. Kinds(me))
-- Dahlia joins (the group roster settles a second later)
members = {{name = "Dahlia", class = "WARLOCK", race = "Scourge", level = 24, faction = "Horde", player = true, hp = 100, max = 100}}
inGroup = true
local dahlia, dkey = A.AddPerson("Dahlia", "Forever", {class = "WARLOCK", race = "Scourge", pronouns = "she"})
dahlia.bond = "spouse"
Fire("GROUP_ROSTER_UPDATE"); Advance(2)
equal(Count(me, "with"), 1, "travelling with Dahlia: " .. Kinds(me))
equal(Kinds(dahlia.journal), "group", "her outing opened: " .. Kinds(dahlia.journal))
-- off: a discovery, a plaque, a trainer purchase, a duel, a standing, a raise: none of it is kept
Advance(60); subzone = "Durnholde Keep"; Fire("ZONE_CHANGED"); Fire("UI_INFO_MESSAGE", ZONE_XP, "Discovered Durnholde Keep: 310 experience gained")
itemText = {title = "Uther's Tomb", material = "Stone"}; Fire("ITEM_TEXT_BEGIN"); Fire("ITEM_TEXT_READY"); Fire("ITEM_TEXT_CLOSED"); itemText = nil
Fire("TRAINER_SHOW"); Fire("LEARNED_SPELL_IN_SKILL_LINE", 26573, 1, false); Fire("TRAINER_CLOSED")
System("Alberich has defeated Dahlia in a duel")
factions[2].reaction = 6; Fire("UPDATE_FACTION"); Advance(3)
members[1].dead = true; Fire("UNIT_HEALTH", "party1")
target = members[1]; Fire("PLAYER_TARGET_CHANGED"); Fire("UNIT_SPELLCAST_SUCCEEDED", "player", "Cast-3-1-1-1-7328-000", 7328)
members[1].dead = false; Fire("UNIT_HEALTH", "party1"); target = nil; Fire("PLAYER_TARGET_CHANGED")
equal(MoreKinds(me), "", "off: no new kind: " .. Kinds(me))
check(Count(me, "pdeath") == 1 and Count(me, "first", "d", "rezother") == 1, "off: the old lines still come (her death, your first raise): " .. Kinds(me))
equal(Kinds(dahlia.journal), "group,death:them", "off: her journal keeps her death, not the raise: " .. Kinds(dahlia.journal))
-- (the standing reached while it was off is seeded when it comes on, never told as today's)
factions[2].reaction = 5 -- (back down for the rehearsal: the real reached standing comes later)

-- 1. Settings > Recording > Record more moments: On ----------------------------------
Advance(30)
A.SetOption("moreMoments", true)
Advance(3)
local selfFrame = SelfFrame()
for _, event in ipairs({"ITEM_TEXT_BEGIN", "UI_INFO_MESSAGE", "LEARNED_SPELL_IN_SKILL_LINE", "TRAINER_SHOW", "TRAINER_CLOSED", "UPDATE_FACTION", "SKILL_LINES_CHANGED"}) do
    check(selfFrame.events[event], "on: listening for " .. event)
end
local start = #me
equal(#me, start, "turning it on writes nothing")
local mine = db.characters["alberich-forever"]
equal(mine.rep and mine.rep["Undercity"], 5, "standings seeded on the character")
equal(mine.skills and mine.skills["First Aid"], 74, "trade skills seeded on the character")

-- 2. Discover a subzone: ZONE_CHANGED, the yellow message, its echo in chat ----------
Advance(120); subzone = "Durnholde Keep"; Fire("ZONE_CHANGED")
Fire("UI_INFO_MESSAGE", ZONE_XP, "Discovered Durnholde Keep: 310 experience gained")
System("Discovered Durnholde Keep: 310 experience gained")
equal(Count(me, "explore"), 1, "one area discovered")
equal(Last(me, "explore").d, "Durnholde Keep", "named from the message")
-- (a second area, at level 60 the message has no experience in it)
Advance(300); subzone = "Nethander Stead"; Fire("ZONE_CHANGED"); Fire("UI_INFO_MESSAGE", ZONE, "Discovered: Nethander Stead")
equal(Count(me, "explore"), 2, "two areas discovered")
equal(Last(me, "explore").d, "Nethander Stead", "the plain message names it too")

-- 3. Learn a flight path: the flight master's gossip, the message, the map ------------
Advance(400); subzone = "Tarren Mill"; Fire("ZONE_CHANGED")
Fire("GOSSIP_SHOW"); Fire("UI_INFO_MESSAGE", TAXI, "New flight path discovered!"); Fire("TAXIMAP_OPENED"); Fire("TAXIMAP_CLOSED")
equal(Count(me, "taxi"), 1, "one flight path learned")
equal(Last(me, "taxi").d, "Tarren Mill", "at the flight master's town")

-- 4. Buy two trainer spells -------------------------------------------------------------
Advance(90)
Fire("GOSSIP_SHOW"); Fire("TRAINER_SHOW"); Fire("TRAINER_UPDATE")
Fire("LEARNED_SPELL_IN_SKILL_LINE", 26573, 1, false); Fire("SPELLS_CHANGED"); Fire("UI_INFO_MESSAGE", LEARN, "You have learned a new spell: Consecration.")
System("You have learned a new spell: Consecration."); Fire("TRAINER_UPDATE")
Fire("LEARNED_SPELL_IN_SKILL_LINE", 5589, 1, false); Fire("SPELLS_CHANGED"); Fire("UI_INFO_MESSAGE", LEARN, "You have learned a new spell: Hammer of Justice.")
System("You have learned a new spell: Hammer of Justice."); Fire("TRAINER_UPDATE")
Fire("TRAINER_CLOSED")
equal(Count(me, "learn"), 1, "one trainer line")
local learn = Last(me, "learn")
check(learn.c == 2 and learn.m[1] == "Consecration" and learn.m[2] == "Hammer of Justice", "two spells, both named")
equal(Count(me, "explore"), 2, "the learn messages are not discoveries")

-- 5. /reload in the middle of the evening ---------------------------------------------
Advance(60)
local beforeReload = Kinds(me)
Fire("PLAYER_LOGOUT")
local stretchBefore = me[1]
Boot()
Login(true)
me = Journal()
equal(Kinds(me), beforeReload, "a /reload writes nothing (seeds only): " .. Kinds(me))
check(me[1] == stretchBefore and me[1].e == nil, "the same stretch goes on after the /reload")
dahlia = A.People[dkey]
Fire("GROUP_ROSTER_UPDATE"); Advance(2)
equal(Kinds(dahlia.journal), "group,death:them", "her outing goes on too: " .. Kinds(dahlia.journal))
equal(Count(me, "with"), 1, "the with-line resumes, not a second")
-- (a third spell bought after the /reload joins the evening's trainer line)
Fire("TRAINER_SHOW"); Fire("LEARNED_SPELL_IN_SKILL_LINE", 20271, 1, false); Fire("SPELLS_CHANGED"); Fire("TRAINER_CLOSED")
equal(Count(me, "learn"), 1, "still one trainer line after the /reload")
equal(Last(me, "learn").c, 3, "three spells on it now")

-- 6. Reach a reputation standing: the burst, the chat lines ------------------------------
Advance(600)
factions[2].reaction = 6
System("Reputation with Undercity increased by 250.")
for _ = 1, 4 do Fire("UPDATE_FACTION") end
System("You are now Honored with Undercity.")
Advance(3)
equal(Count(me, "rep"), 1, "one standing reached")
check(Last(me, "rep").d == "Undercity" and Last(me, "rep").s == 6, "honored with Undercity")
for _ = 1, 3 do Fire("UPDATE_FACTION") end; Advance(3)
equal(Count(me, "rep"), 1, "later bursts at the same standing write nothing")

-- 7. Read a plaque (stone): once, and once only after the /reload too ------------------
Advance(200)
itemText = {title = "Uther's Tomb", material = "Stone"}
Fire("ITEM_TEXT_BEGIN"); Fire("ITEM_TEXT_READY"); Fire("ITEM_TEXT_CLOSED")
equal(Count(me, "read"), 1, "one plaque read")
check(Last(me, "read").d == "Uther's Tomb" and Last(me, "read").m == "stone", "its title and its stone")
Fire("ITEM_TEXT_BEGIN"); Fire("ITEM_TEXT_READY"); Fire("ITEM_TEXT_CLOSED")
equal(Count(me, "read"), 1, "opened twice, kept once")
Advance(30); Fire("PLAYER_LOGOUT"); Boot(); Login(true); me = Journal(); dahlia = A.People[dkey]; Fire("GROUP_ROSTER_UPDATE"); Advance(2)
Fire("ITEM_TEXT_BEGIN"); Fire("ITEM_TEXT_READY"); Fire("ITEM_TEXT_CLOSED")
equal(Count(me, "read"), 1, "opened again after a /reload, still once")
itemText = nil

-- 8. Duel Dahlia, and lose (one hit point left: no close call from a duel) -------------
Advance(300)
Fire("DUEL_REQUESTED", "Dahlia")
target = members[1]; target.hostile = true
Fire("PLAYER_TARGET_CHANGED")
inCombat = true; Fire("PLAYER_REGEN_DISABLED")
player.hp = 1; Fire("UNIT_HEALTH", "player")
Fire("DUEL_FINISHED")
System("Dahlia has defeated Alberich in a duel")
target.hostile = nil; inCombat = false; Fire("PLAYER_REGEN_ENABLED")
Advance(5); player.hp = 100; Fire("UNIT_HEALTH", "player")
Advance(30)
equal(Count(me, "duel"), 1, "one duel")
check(Last(me, "duel").d == "Dahlia" and Last(me, "duel").w == "lost" and not Last(me, "duel").fled, "lost to Dahlia, on points")
equal(Count(me, "close"), 0, "a duel's last hit point is not a close call")
target = nil; Fire("PLAYER_TARGET_CHANGED")

-- 9. Kill a rare you have targeted ---------------------------------------------------------
Advance(400)
target = {name = "Ro'Bark", rank = "rare", hostile = true, hp = 2000, max = 2000}
Fire("PLAYER_TARGET_CHANGED")
equal(Count(me, "first", "d", "rarebeast"), 1, "the rare seen, as before")
inCombat = true; Fire("PLAYER_REGEN_DISABLED")
target.hp = 1400; Fire("UNIT_HEALTH", "target"); target.hp = 600; Fire("UNIT_HEALTH", "target")
target.hp, target.dead = 0, true; Fire("UNIT_HEALTH", "target")
inCombat = false; Fire("PLAYER_REGEN_ENABLED")
Fire("CHAT_MSG_COMBAT_XP_GAIN", "Ro'Bark dies, you gain 420 experience.")
equal(Count(me, "rarekill"), 1, "the rare killed")
check(Last(me, "rarekill").d == "Ro'Bark" and Last(me, "rarekill").sz == "Hillsbrad Foothills", "named, with the zone")
Fire("UNIT_HEALTH", "target")
equal(Count(me, "rarekill"), 1, "its corpse's health is not a second kill")
target = nil; Fire("PLAYER_TARGET_CHANGED")

-- 10. Raise Dahlia -------------------------------------------------------------------------
Advance(500)
members[1].dead, members[1].hp = true, 0
Fire("UNIT_HEALTH", "party1")
equal(Count(dahlia.journal, "death", "w", "them"), 2, "her second death of the evening")
target = members[1]; Fire("PLAYER_TARGET_CHANGED")
Fire("UNIT_SPELLCAST_SENT", "player", "Dahlia", "Cast-3-1-1-1-7328-001", 7328)
Fire("UNIT_SPELLCAST_SUCCEEDED", "player", "Cast-3-1-1-1-7328-001", 7328)
equal(Count(dahlia.journal, "rez", "w", "you"), 1, "her journal: raised by you")
equal(Count(me, "first", "d", "rezother"), 1, "your own first raise stays the old one, not a second")
Advance(10); members[1].dead, members[1].hp = false, 60; Fire("UNIT_HEALTH", "party1")
target = nil; Fire("PLAYER_TARGET_CHANGED")
Fire("UNIT_SPELLCAST_SUCCEEDED", "player", "Cast-3-1-1-1-635-002", 635)
equal(Count(dahlia.journal, "rez", "w", "you"), 1, "a heal is not a raise")

-- 11. Off again: silent; on again: seeds only ----------------------------------------------
Advance(120)
local before = MoreKinds(me)
A.SetOption("moreMoments", false)
check(not SelfFrame().events.UI_INFO_MESSAGE and not SelfFrame().events.ITEM_TEXT_BEGIN, "off: not listening")
subzone = "Eastern Strand"; Fire("ZONE_CHANGED"); Fire("UI_INFO_MESSAGE", ZONE_XP, "Discovered Eastern Strand: 310 experience gained")
System("Alberich has defeated Dahlia in a duel")
factions[3].reaction = 5; Fire("UPDATE_FACTION"); Advance(3)
equal(MoreKinds(me), before, "off: nothing recorded")
A.SetOption("moreMoments", true); Advance(3)
equal(MoreKinds(me), before, "on again: the standing reached while off is seeded, not told")
factions[3].reaction = 6; Fire("UPDATE_FACTION"); Advance(3)
equal(Count(me, "rep", "d", "Orgrimmar"), 1, "the next standing after that is told")
me[#me] = nil -- (kept out of the day read below: the checklist has one standing)
mine.rep["Orgrimmar"] = nil

-- The whole evening, as recorded.
-- (member: Dahlia's line as a group member, once she had been with me a minute; lane REC8)
equal(Kinds(me), "play,first,town,with,member,pdeath,first,explore,explore,taxi,learn,rep,read,duel:lost,first,rarekill,pdeath", "the evening's record: " .. Kinds(me))
equal(Kinds(dahlia.journal), "group,death:them,death:them,rez:you", "her record: " .. Kinds(dahlia.journal))

-- 12. Reading the day: your own book, Everything and Highlights, retells 0-7; her book, both voices.
local META = {"journal", "tale", "story", "song", "verse", "record", "chronicle", "legend", "bard"}
local out = {}
local function Emit(line) out[#out + 1] = line end
local function CleanText(text, where)
    local plain = A.JournalPlain(text)
    check(not text:find("{%a+}"), "no raw token (" .. where .. "): " .. text)
    check(not plain:find(":", 1, true), "no colon (" .. where .. "): " .. plain)
    check(not plain:find("%?"), "no question (" .. where .. "): " .. plain)
    for _, word in ipairs(META) do check(not plain:lower():find("%f[%a]" .. word .. "%f[%A]"), "no meta word '" .. word .. "' (" .. where .. "): " .. plain) end
    check(not plain:find("  ", 1, true) and not plain:find(" %."), "clean spacing (" .. where .. "): " .. plain)
    return plain
end
local self = A.SelfPerson()
local own = {}
for _, brief in ipairs({false, true}) do
    for retell = 0, 7 do
        local days = A.JournalBook(self)
        local stories = A.SelfTale.Tell(self, days, brief, retell)
        local day = days[#days]
        local s = stories[day.key]
        check(s and s.text ~= "", "the day is told (" .. tostring(brief) .. " " .. retell .. ")")
        local plain = CleanText(s.text, "own " .. (brief and "Highlights" or "Everything") .. " " .. retell)
        own[#own + 1] = {brief = brief, retell = retell, plain = plain, title = s.title}
        Emit(("-- Own %s, retell %d, title %s\n%s\n"):format(brief and "Highlights" or "Everything", retell, tostring(s.title), plain))
        if not brief then
            check(plain:find("Durnholde Keep", 1, true) and plain:find("Nethander Stead", 1, true), "both areas (" .. retell .. "): " .. plain)
            check(plain:find("flight", 1, true), "the flight path: " .. plain)
            check(plain:find("Consecration", 1, true) and plain:find("Hammer of Justice", 1, true) and plain:find("Judgement", 1, true), "the three spells: " .. plain)
            check(plain:find("Undercity", 1, true) and plain:find("honor", 1, true), "honored with Undercity: " .. plain)
            check(plain:find("Uther's Tomb", 1, true), "the plaque: " .. plain)
            check(plain:find("Dahlia", 1, true) and plain:find("duel", 1, true), "the duel with Dahlia: " .. plain)
            check(not plain:find("nearly", 1, true), "no close call from the duel: " .. plain)
            check(plain:find("Ro'Bark", 1, true), "the rare: " .. plain)
            local _, n = plain:gsub("Ro'Bark", "")
            equal(n, 1, "the rare once (the sighting goes without saying): " .. plain)
            check(not plain:find("trainer taught me.*trainer taught me"), "one trainer line: " .. plain)
        else
            check(plain:find("Dahlia", 1, true) and plain:find("duel", 1, true), "Highlights keep the duel: " .. plain)
            check(plain:find("Ro'Bark", 1, true), "Highlights keep the rare: " .. plain)
            check(not plain:find("trainer", 1, true), "Highlights leave the trainer out: " .. plain)
        end
    end
end
local hero = A.CharacterPlayer("alberich-forever")
local hers = {}
for _, voice in ipairs({"you", "we"}) do
    for retell = 0, 7 do
        dahlia.retell = retell
        local days = A.JournalBook(dahlia)
        local stories = A.JournalTale.Tell(dahlia, days, voice, hero, false)
        local day = days[#days]
        local s = stories[day.key]
        check(s and s.text ~= "", "her day is told (" .. voice .. " " .. retell .. ")")
        local plain = CleanText(s.text, "Dahlia " .. voice .. " " .. retell)
        hers[#hers + 1] = {voice = voice, retell = retell, plain = plain, title = s.title}
        Emit(("-- Dahlia (%s), retell %d, title %s\n%s\n"):format(voice, retell, tostring(s.title), plain))
        check(plain:find("duel", 1, true) and plain:find("Dahlia won", 1, true), "the duel, as her win (" .. voice .. " " .. retell .. "): " .. plain)
        -- (her chapter keeps two shared moments a scene: the raise and the duel come first in time; the rare waits for the engine, see the report)
        check(plain:lower():find("twice", 1, true), "her two deaths in one line: " .. plain)
        check(plain:find("back", 1, true) or plain:find("raised", 1, true) or plain:find("rose", 1, true), "the raise: " .. plain)
        if voice == "we" then check(not plain:find("%f[%a][Yy]ou%f[%A]"), "the diary never says you: " .. plain) end
    end
    local brief = A.JournalTale.Tell(dahlia, A.JournalBook(dahlia), voice, hero, true)
    local day = A.JournalBook(dahlia)
    local s = brief[day[#day].key]
    if s and s.text ~= "" then Emit(("-- Dahlia Highlights (%s)\n%s\n"):format(voice, CleanText(s.text, "Dahlia Highlights " .. voice))) end
end
dahlia.retell = nil
-- the plain record (Simple) of the evening
local days = A.JournalBook(self)
local simple = {}
for _, scene in ipairs(days[#days].scenes) do
    local text = A.JournalSceneText(self, scene, "you")
    if text and text ~= "" then simple[#simple + 1] = A.JournalPlain(text) end
end
Emit("-- Own Simple\n" .. table.concat(simple, "\n") .. "\n")
if mode == "print" then
    for _, line in ipairs(out) do if line:find("retell 0,") or line:find("Simple") or line:find("Highlights %(") then io.write(line, "\n") end end
elseif mode == "save" and tag then
    local path = "StorageInvestigation/cj-overnight-20261105/rehearsal/chapters-" .. tag .. ".txt"
    local f = assert(io.open(path, "w"))
    f:write("Rehearsal of the 1.13.0 checklist, rendered offline (" .. os.date("%Y-%m-%d %H:%M") .. ")\n\n", table.concat(out, "\n"))
    f:close()
    io.write("saved " .. path .. "\n")
end

-- 13. What if the client prints it differently? Nothing errors; the fallback is silent, never wrong.
-- Each case is a fresh login on a fresh character so one case cannot feed another.
local function Fresh(setup)
    db = {enabled = true, peopleJournal = true, selfJournal = true, moreMoments = true, colors = {people = {1, 1, 1}, groupmate = {0.5, 0.8, 1}}, people = {},
        characters = {["alberich-forever"] = {name = "Alberich", faction = "Horde", class = "PALADIN", race = "Scourge", people = {}, selfStartLevel = 10}}}
    members, inGroup, target, inCombat, itemText, secret = {}, false, nil, false, nil, {}
    zone, subzone = "Hillsbrad Foothills", "Tarren Mill"
    if setup then setup() end
    Boot(); Login(false)
    return Journal()
end
local function Restore()
    ERR_ZONE_EXPLORED, ERR_ZONE_EXPLORED_XP, ERR_NEWTAXIPATH = "Discovered: %s", "Discovered %s: %d experience gained", "New flight path discovered!"
    DUEL_WINNER_KNOCKOUT, DUEL_WINNER_RETREAT = "%1$s has defeated %2$s in a duel", "%2$s has fled from %1$s in a duel"
    GetGameMessageInfo = function(index) return MESSAGE_NAMES[index] end
end

-- a. The discovery, the flight path and the trainer's spell reaching chat alone (no UI_INFO_MESSAGE): the
-- game's own wording is enough; any other wording in chat is silent (the user sends the chat line).
local j = Fresh()
System("Discovered Durnholde Keep: 310 experience gained")
equal(Count(j, "explore"), 1, "a chat-only discovery in the game's words counts")
System("Discovered Durnholde Keep: 310 experience gained")
equal(Count(j, "explore"), 1, "its echo does not")
System("New flight path discovered!")
equal(Count(j, "taxi"), 1, "a chat-only flight path counts")
System("New flight path discovered!")
equal(Count(j, "taxi"), 1, "once")
Fire("TRAINER_SHOW"); System("You have learned a new spell: Consecration."); Fire("TRAINER_CLOSED")
check(Count(j, "learn") == 1 and Last(j, "learn").c == 1 and Last(j, "learn").m[1] == "Consecration", "a chat-only purchase counts while the window is open")
System("You have learned a new spell: Holy Light.")
equal(Last(j, "learn").c, 1, "not after the window closed")
System("You discovered Durnholde Keep.")
System("Alberich learned Holy Light.")
equal(Count(j, "explore") + Count(j, "learn"), 2, "other wordings are silent, not guessed")
-- (the event and both messages for one purchase: one count)
Advance(10); Fire("TRAINER_SHOW")
Fire("LEARNED_SPELL_IN_SKILL_LINE", 5589, 1, false); Fire("UI_INFO_MESSAGE", LEARN, "You have learned a new spell: Hammer of Justice."); System("You have learned a new spell: Hammer of Justice.")
Fire("TRAINER_CLOSED")
check(Last(j, "learn").c == 2 and Last(j, "learn").m[2] == "Hammer of Justice", "one purchase, three announcements, counted once")

-- b. Colour codes around the message: still the area from the message.
j = Fresh()
subzone = "Durnholde Keep"
Fire("UI_INFO_MESSAGE", ZONE_XP, "|cffffff00Discovered Durnholde Keep: 310 experience gained|r")
equal(Count(j, "explore"), 1, "a coloured message still counts")
equal(Last(j, "explore").d, "Durnholde Keep", "and names the area, not the colour code")

-- c. The brief's other spelling of the plain string ("Discovered %s", no colon).
j = Fresh(function() ERR_ZONE_EXPLORED = "Discovered %s" end)
Fire("UI_INFO_MESSAGE", ZONE, "Discovered Nethander Stead")
equal(Last(j, "explore") and Last(j, "explore").d, "Nethander Stead", "the colon-less string works too")
Restore()

-- d. A numbered-slot locale string.
j = Fresh(function() ERR_ZONE_EXPLORED_XP = "%1$s entdeckt: %2$d Erfahrung erhalten" end)
Fire("UI_INFO_MESSAGE", ZONE_XP, "Durnholde entdeckt: 310 Erfahrung erhalten")
equal(Last(j, "explore") and Last(j, "explore").d, "Durnholde", "numbered placeholders: the area is still the first capture")
Restore()

-- e. The message does not match the string at all (a Forever rewording): the sub-zone stands in.
j = Fresh()
subzone = "Durnholde Keep"
Fire("UI_INFO_MESSAGE", ZONE_XP, "You have discovered Durnholde Keep (310 XP)")
equal(Last(j, "explore") and Last(j, "explore").d, "Durnholde Keep", "an unknown wording falls back to the sub-zone")

-- f. GetGameMessageInfo missing or failing, and the payload in the old order (message first).
j = Fresh(function() GetGameMessageInfo = nil end)
Fire("UI_INFO_MESSAGE", ZONE_XP, "Discovered Durnholde Keep: 310 experience gained")
Fire("UI_INFO_MESSAGE", "New flight path discovered!")
equal(Count(j, "explore") + Count(j, "taxi"), 2, "without a type name the message itself is matched against the strings")
Restore()
j = Fresh(function() GetGameMessageInfo = function() error("secret") end end)
Fire("UI_INFO_MESSAGE", ZONE_XP, "Discovered Durnholde Keep: 310 experience gained")
Fire("UI_INFO_MESSAGE", OTHER, "You are too far away.")
equal(Count(j, "explore"), 1, "a failing type lookup still reads a known message")
equal(Count(j, "taxi"), 0, "and an unknown message writes nothing")
Restore()

-- g. Secret values: the message, the type, the target's name, the item text. Nothing written, nothing raised.
j = Fresh()
local secretText = "Discovered Durnholde Keep: 310 experience gained"
secret[secretText] = true
Fire("UI_INFO_MESSAGE", ZONE_XP, secretText)
System(secretText)
secret[ZONE_XP] = true; Fire("UI_INFO_MESSAGE", ZONE_XP, "Discovered: Nethander Stead"); secret[ZONE_XP] = nil
local secretDuel = "Alberich has defeated Dahlia in a duel"
secret[secretDuel] = true; System(secretDuel)
target = {name = "Ro'Bark", rank = "rare", hostile = true}
secret["Ro'Bark"] = true
Fire("PLAYER_TARGET_CHANGED"); inCombat = true; target.dead = true; Fire("UNIT_HEALTH", "target"); inCombat = false
secret["Ro'Bark"] = nil
itemText = {title = "Uther's Tomb", material = "Stone"}; secret["Uther's Tomb"] = true
Fire("ITEM_TEXT_BEGIN"); secret["Uther's Tomb"] = nil; itemText = nil
equal(MoreKinds(j), "explore,explore", "secret values: only the two discoveries the game still named: " .. Kinds(j))
check(j[#j - 1].d == "Tarren Mill" and j[#j].d == "Nethander Stead", "a secret message falls back to the sub-zone; a secret type still reads the game's own wording")

-- h. Duels: the realm on the name, both directions, a flight either way, a stranger's duel, a period at the end.
j = Fresh()
System("Alberich has defeated Dahlia-Forever in a duel")
check(Last(j, "duel") and Last(j, "duel").d == "Dahlia" and Last(j, "duel").w == "won", "won, the realm dropped")
System("Dahlia has fled from Alberich in a duel")
check(Last(j, "duel").w == "won" and Last(j, "duel").fled, "she left the ring: won by her flight")
System("Alberich has fled from Dahlia in a duel")
check(Last(j, "duel").w == "lost" and Last(j, "duel").fled, "you left the ring: lost by your flight")
System("|cffffff00Thrall has defeated Varok in a duel|r")
equal(Count(j, "duel"), 3, "a stranger's duel is not yours")
System("Alberich has defeated Dahlia in a duel.")
equal(Count(j, "duel"), 3, "a reworded message (a period) is silent, not guessed")
System("|Hplayer:Dahlia|h[Dahlia]|h has defeated Alberich in a duel")
check(Count(j, "duel") == 4 and Last(j, "duel").d == "Dahlia" and Last(j, "duel").w == "lost", "a player link in the name is read as the name")

-- i. The trainer closed by a /reload while open: a spell learned after it is not a purchase.
j = Fresh()
Fire("TRAINER_SHOW"); Fire("PLAYER_LOGOUT"); Boot(); Login(true); j = Journal()
Fire("LEARNED_SPELL_IN_SKILL_LINE", 26573, 1, false)
equal(Count(j, "learn"), 0, "no trainer line without the window")

-- j. A rare that dies when you were not fighting it; a rare targeted dead; the watch let go on another target.
j = Fresh()
target = {name = "Ro'Bark", rank = "rare", hostile = true}
Fire("PLAYER_TARGET_CHANGED")
target = {name = "Hillsbrad Farmer", rank = "normal", hostile = true}
Fire("PLAYER_TARGET_CHANGED")
target.dead = true; inCombat = true; Fire("UNIT_HEALTH", "target"); inCombat = false
equal(Count(j, "rarekill"), 0, "a farmer is not the rare")
target = {name = "Ro'Bark", rank = "rare", hostile = true, dead = true}
Fire("PLAYER_TARGET_CHANGED"); Fire("UNIT_HEALTH", "target")
equal(Count(j, "rarekill"), 0, "a rare found dead is nobody's kill")

-- k. A plaque with no material (parchment by the UI's rule), and a book.
j = Fresh()
itemText = {title = "Plaque"}; Fire("ITEM_TEXT_BEGIN")
check(Last(j, "read") and Last(j, "read").d == "Plaque" and Last(j, "read").m == nil, "no material: kept without one")
itemText = {title = "The Story of Morgan Ladimore", material = "Parchment"}; Advance(60); Fire("ITEM_TEXT_BEGIN")
check(Last(j, "read").m == "parchment", "a book on parchment")

io.write("PASS: " .. assertions .. " rehearsal assertions\n")
