-- Run from the client root: lua5.1 Interface/AddOns/CompanionJournal/tests/MomentsRecord.lua
-- "Record more moments" (off by default): books and plaques read, areas
-- discovered, flight paths learned, spells from a trainer, a standing reached,
-- duels, trade-skill marks, honorable kills, a rare creature killed. Nothing
-- is recorded while the setting is off; every read is guarded; the book and
-- the plain record show each of them.
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
local zone, subzone, resting = "Durotar", "Razor Hill", false
local instance
function GetRealZoneText() return zone end
function GetSubZoneText() return subzone end
function IsResting() return resting end
function IsInInstance() return instance ~= nil, instance and "party" or "none" end
function GetInstanceInfo() return instance end
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
function UnitCanAttack(_, unit) return unit == "target" and target ~= nil end
function UnitName(unit) if unit == "player" then return "Alberich" end if unit == "target" and target then return target.name end end
function UnitClassification() return target and target.rank or "normal" end
function UnitIsPlayer() return false end
function UnitAffectingCombat() return inCombat end
function IsSwimming() return false end
local timers = {}
C_Timer = {After = function(delay, fn) if delay >= 10 then timers[#timers + 1] = fn else fn() end end}
local function RunTimers() local list = timers; timers = {}; for _, fn in ipairs(list) do fn() end end
print = function() end

-- The game's own strings and readers, as the client exposes them.
ERR_ZONE_EXPLORED = "Discovered: %s"
ERR_ZONE_EXPLORED_XP = "Discovered %s: %d experience gained"
DUEL_WINNER_KNOCKOUT = "%1$s has defeated %2$s in a duel"
DUEL_WINNER_RETREAT = "%2$s has fled from %1$s in a duel"
local messageNames = {[1] = "ERR_ZONE_EXPLORED_XP", [2] = "ERR_ZONE_EXPLORED", [3] = "ERR_NEWTAXIPATH", [4] = "ERR_SYSTEM"}
function GetGameMessageInfo(index) return messageNames[index] end
local itemText = {title = "The Story of Morgan Ladimore", material = "Parchment"}
function ItemTextGetItem() return itemText.title end
function ItemTextGetMaterial() return itemText.material end
local spells = {[20271] = "Judgement", [10290] = "Blessing of Might", [1038] = "Blessing of Salvation"}
function GetSpellInfo(id) return spells[id] end
local factions = {{name = "Orgrimmar", reaction = 4}, {name = "Steamwheedle Cartel", reaction = 3, isHeader = true}, {name = "Ratchet", reaction = 4}}
C_Reputation = {GetNumFactions = function() return #factions end, GetFactionDataByIndex = function(i) return factions[i] end}
local skills = {{name = "Weapon Skills", isHeader = true, rank = 0}, {name = "Cooking", rank = 60, maxRank = 75}, {name = "Swords", rank = 110, maxRank = 115}}
C_SkillInfo = {GetNumSkillLines = function() return #skills end, GetSkillLineInfo = function(i) return skills[i] end}
local honor = 2
function GetPVPSessionStats() return honor, 0 end

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
equal(db.moreMoments, false, "the setting starts off")
A.UpdateSelfJournalEvents()
local selfFrame
for _, f in ipairs(frames) do if f.events.QUEST_TURNED_IN and f.events.PLAYER_LEVEL_UP and f.events.ZONE_CHANGED_NEW_AREA then selfFrame = f end end
check(selfFrame, "your journal listens while the journal is on")
local function Fire(event, ...) selfFrame.scripts.OnEvent(selfFrame, event, ...) end
local journal = db.characters["alberich-forever"].journal
local function Kinds(from)
    local out = {}
    for i = from or 1, #journal do out[#out + 1] = journal[i].k end
    return table.concat(out, ",")
end
local function Last(kind)
    for i = #journal, 1, -1 do if journal[i].k == kind then return journal[i] end end
end

-- 1. Off: the events are not registered, and nothing is recorded.
check(not selfFrame.events.ITEM_TEXT_BEGIN and not selfFrame.events.UI_INFO_MESSAGE and not selfFrame.events.UPDATE_FACTION,
    "more-moment events stay unregistered while the setting is off")
Fire("PLAYER_ENTERING_WORLD")
local before = #journal
Fire("ITEM_TEXT_BEGIN"); Fire("UI_INFO_MESSAGE", 1, "Discovered Razor Hill: 55 experience gained")
Fire("CHAT_MSG_SYSTEM", "Alberich has defeated Dahlia in a duel")
honor = 3; Fire("PLAYER_PVP_KILLS_CHANGED")
equal(#journal, before + 1, "off: only the old first-pvp line (" .. Kinds(before + 1) .. ")")
equal(journal[#journal].k, "first", "the first honorable kill is still a first")

-- 2. On: every event is registered, and the readers seed without writing.
db.moreMoments = true
A.UpdateSelfJournalEvents()
for _, event in ipairs({"ITEM_TEXT_BEGIN", "UI_INFO_MESSAGE", "LEARNED_SPELL_IN_SKILL_LINE", "TRAINER_SHOW", "TRAINER_CLOSED", "UPDATE_FACTION",
    "SKILL_LINES_CHANGED", "PLAYER_REGEN_ENABLED"}) do
    check(selfFrame.events[event], "registered when on: " .. event)
end
before = #journal
Fire("PLAYER_ENTERING_WORLD"); RunTimers()
equal(#journal, before, "the first look at standings and skills only seeds them")
local mine = db.characters["alberich-forever"]
equal(mine.rep and mine.rep["Orgrimmar"], 4, "standings kept on the character")
equal(mine.skills and mine.skills["Cooking"], 60, "trade skills kept on the character")
check(mine.skills["Swords"] == nil, "weapon skills are not trades")

-- 3. A book, read once per stretch; a plaque keeps its material.
clock = clock + 60; Fire("ITEM_TEXT_BEGIN"); Fire("ITEM_TEXT_BEGIN")
local read = Last("read")
check(read and read.d == "The Story of Morgan Ladimore" and read.m == "parchment", "a book read, with its material")
equal(select(2, Kinds():gsub("read", "")), 1, "the same title once a stretch")
itemText = {title = "Grave of Tirion's Son", material = "Stone"}
clock = clock + 60; Fire("ITEM_TEXT_BEGIN")
check(Last("read").d == "Grave of Tirion's Son" and Last("read").m == "stone", "a stone read, with its material")

-- 4. Areas discovered (from the game's own message), a flight path learned.
clock = clock + 60; Fire("UI_INFO_MESSAGE", 1, "Discovered Razor Hill: 55 experience gained")
check(Last("explore") and Last("explore").d == "Razor Hill", "an area discovered, named from the message")
clock = clock + 60; Fire("UI_INFO_MESSAGE", 2, "Discovered: Tiragarde Keep")
check(Last("explore").d == "Tiragarde Keep", "the plain discovery message too")
Fire("UI_INFO_MESSAGE", 4, "Some other message")
check(Last("explore").d == "Tiragarde Keep", "other info messages are ignored")
subzone = "Razor Hill"
clock = clock + 60; Fire("UI_INFO_MESSAGE", 3, "New flight path discovered!")
check(Last("taxi") and Last("taxi").d == "Razor Hill", "a flight path learned, at the flight master's town")

-- 5. Spells from a trainer, one line per stretch; nothing outside the window.
Fire("LEARNED_SPELL_IN_SKILL_LINE", 20271, 1, false)
check(not Last("learn"), "a spell learned outside the trainer window is not a purchase")
clock = clock + 60; Fire("TRAINER_SHOW")
Fire("LEARNED_SPELL_IN_SKILL_LINE", 20271, 1, false); Fire("LEARNED_SPELL_IN_SKILL_LINE", 10290, 1, false); Fire("LEARNED_SPELL_IN_SKILL_LINE", 10290, 1, false)
Fire("TRAINER_CLOSED")
local learn = Last("learn")
check(learn and learn.c == 3 and #learn.m == 2 and learn.m[1] == "Judgement", "three spells bought, two names (a higher rank repeats a name)")
equal(select(2, Kinds():gsub("learn", "")), 1, "one learn line a stretch")

-- 6. A standing reached; a dip and a header are not.
clock = clock + 60; factions[1].reaction = 5
Fire("UPDATE_FACTION")
local rep = Last("rep")
check(rep and rep.d == "Orgrimmar" and rep.s == 5, "friendly with Orgrimmar")
factions[2].reaction = 5; factions[3].reaction = 3
Fire("UPDATE_FACTION")
check(Last("rep") == rep, "a header without standing and a drop write nothing")
clock = clock + 60; factions[1].reaction = 7
Fire("UPDATE_FACTION")
check(Last("rep").s == 7, "revered, straight from friendly: one line, the standing reached")

-- 7. Duels, both ways, from the system message.
clock = clock + 60; Fire("CHAT_MSG_SYSTEM", "Alberich has defeated Dahlia-Noir in a duel")
local duel = Last("duel")
check(duel and duel.d == "Dahlia" and duel.w == "won" and not duel.fled, "a duel won, the realm dropped from the name")
clock = clock + 60; Fire("CHAT_MSG_SYSTEM", "Alberich has fled from Grak in a duel")
check(Last("duel").d == "Grak" and Last("duel").w == "lost" and Last("duel").fled, "a duel lost by leaving the ring")
Fire("CHAT_MSG_SYSTEM", "Thrall has defeated Varok in a duel")
check(Last("duel").d == "Grak", "other people's duels are not yours")

-- 8. Trade skills crossing their marks (75, 150, 225, 300), once each.
skills[2].rank = 74; Fire("SKILL_LINES_CHANGED")
check(not Last("skill"), "74 is below the mark")
clock = clock + 60; skills[2].rank = 76; Fire("SKILL_LINES_CHANGED")
check(Last("skill") and Last("skill").d == "Cooking" and Last("skill").c == 75, "cooking past 75")
clock = clock + 60; skills[2].rank = 151; Fire("SKILL_LINES_CHANGED")
check(Last("skill").c == 150 and select(2, Kinds():gsub("skill", "")) == 2, "150 next, 75 not again")
skills[3].rank = 115; Fire("SKILL_LINES_CHANGED")
equal(select(2, Kinds():gsub("skill", "")), 2, "weapon skills are not trades")

-- 9. Honorable kills in the open world, counted per stretch; not in a battleground.
clock = clock + 60; honor = 4; Fire("PLAYER_PVP_KILLS_CHANGED")
local hk = Last("hk")
check(hk and hk.c == 1, "one honorable kill")
honor = 6; Fire("PLAYER_PVP_KILLS_CHANGED")
check(Last("hk") == hk and hk.c == 3, "counted on the same line")
local realInstance = IsInInstance
IsInInstance = function() return true, "pvp" end
honor = 7; Fire("PLAYER_PVP_KILLS_CHANGED")
IsInInstance = realInstance
check(hk.c == 3, "a battleground's kills are the battleground's")

-- 10. A rare creature killed while you fought it; one you only looked at is not.
clock = clock + 60; target = {name = "Gravis Slipknot", rank = "rare"}
Fire("PLAYER_TARGET_CHANGED")
check(Last("first") and Last("first").d == "rarebeast" and Last("first").z == "Gravis Slipknot", "the rare seen, as before")
local firstsBefore = #journal
A.SelfRareHealth()
equal(#journal, firstsBefore, "alive: nothing yet")
target.dead, inCombat = true, true
A.SelfRareHealth()
local kill = Last("rarekill")
check(kill and kill.d == "Gravis Slipknot" and kill.sz == "Durotar", "the rare killed, with the zone")
target = {name = "Gravis Slipknot", rank = "rare"}
Fire("PLAYER_TARGET_CHANGED"); target.dead = true; A.SelfRareHealth()
check(Last("rarekill") == kill, "a rare killed is kept once a life")
target, inCombat = {name = "Rathorian", rank = "rare"}, false
Fire("PLAYER_TARGET_CHANGED")
clock = clock + 30; target.dead = true
A.SelfRareHealth()
check(Last("rarekill") == kill, "a rare that died with no fight of yours is not your kill")

-- 11. The book carries them, in the plain record and the short day.
local me = A.SelfPerson()
local days = A.JournalBook(me)
local today = days[#days]
local scene
for _, s in ipairs(today.scenes) do if s.kind == "outing" and s.zone == "Durotar" then scene = s end end
check(scene and scene.explored and #scene.explored == 2 and scene.hk == 3, "the stretch holds its discoveries and its kills")
local kinds = {}
for _, e in ipairs(scene.events) do kinds[e.k] = (kinds[e.k] or 0) + 1 end
check(kinds.read == 2 and kinds.explore == 2 and kinds.taxi == 1 and kinds.learn == 1 and kinds.rep == 2 and kinds.duel == 2 and kinds.skill == 2 and kinds.hk == 1 and kinds.rarekill == 1,
    "every kind reaches the scene's events")
local plain = A.JournalPlain(A.JournalSceneText(me, scene, "you"))
check(plain:find("read The Story of Morgan Ladimore", 1, true) and plain:find("read the words on Grave of Tirion's Son", 1, true), "Simple: the book and the stone: " .. plain)
check(plain:find("Razor Hill and Tiragarde Keep", 1, true), "Simple: the areas, in one clause: " .. plain)
check(plain:find("learned the flight path at Razor Hill", 1, true), "Simple: the flight path: " .. plain)
check(plain:find("learned three spells from the trainer, among them Judgement and Blessing of Might", 1, true), "Simple: the trainer: " .. plain)
check(plain:find("I became friendly with Orgrimmar.", 1, true) and plain:find("I became revered with Orgrimmar.", 1, true), "Simple: the standings: " .. plain)
check(plain:find("I won a duel against Dahlia.", 1, true) and plain:find("I lost a duel to Grak.", 1, true), "Simple: the duels: " .. plain)
check(plain:find("My Cooking reached 75.", 1, true) and plain:find("My Cooking reached 150.", 1, true), "Simple: the trade marks: " .. plain)
check(plain:find("killed three of the other side", 1, true), "Simple: the honorable kills: " .. plain)
check(plain:find("I killed Gravis Slipknot, a rare creature, in Durotar.", 1, true), "Simple: the rare killed: " .. plain)
local highlights = A.JournalPlain((A.JournalDayHighlights(me, today, "you")))
check(highlights:find("duel", 1, true) and highlights:find("revered with Orgrimmar", 1, true), "the short day keeps the duel and the standing: " .. highlights)
check(not highlights:find("friendly", 1, true), "but not every standing: " .. highlights)

-- 12. Off again: unregistered, and silent.
db.moreMoments = false
A.UpdateSelfJournalEvents()
check(not selfFrame.events.ITEM_TEXT_BEGIN and not selfFrame.events.UPDATE_FACTION, "events let go when the setting is turned off")
before = #journal
Fire("CHAT_MSG_SYSTEM", "Alberich has defeated Dahlia in a duel"); Fire("UI_INFO_MESSAGE", 2, "Discovered: Somewhere")
equal(#journal, before, "silent when off")

io.write("PASS: " .. assertions .. " more-moment recording assertions\n")
