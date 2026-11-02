-- Run from the client root: lua Interface/AddOns/CompanionJournal/tests/Self.lua
-- Your own journal: recorded always (zone by zone, every quest by name,
-- dungeons, bosses, deaths, levels, who of your list was with you), seeded
-- from your journals with people, and told in your own words.
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
function methods:UnregisterEvent(event) self.events[event] = nil end
local frames = {}
function CreateFrame() local f = Object(); frames[#frames + 1] = f; return f end
UIParent = Object()
local clock = 1790000000
function time(t) if type(t) == "table" then return os.time(t) end return clock end
function GetTime() return clock end
function date(fmt, t) return os.date(fmt, t or clock) end
local zone, subzone, resting = "Durotar", "", false
local instance
function GetRealZoneText() return zone end
function GetSubZoneText() return subzone end
function IsResting() return resting end
function IsInInstance() return instance ~= nil, instance and "party" or "none" end
function GetInstanceInfo() return instance end
function GetNormalizedRealmName() return "Forever" end
function GetRealmName() return "Forever" end
local quests = {[101] = "Sarkoth", [102] = "Vile Familiars", [103] = "Burning Blade Medallion"}
C_QuestLog = {GetTitleForQuestID = function(id) return quests[id] end}
local level = 5
function UnitFactionGroup(unit) if unit == "player" then return "Horde" end end
function UnitClass(unit) if unit == "player" then return "Paladin", "PALADIN" end end
function UnitRace(unit) if unit == "player" then return "Undead", "Scourge" end end
function UnitLevel(unit) if unit == "player" then return level end return 0 end
local dead = false
function UnitIsDeadOrGhost(unit) return unit == "player" and dead end
local hp, target, inCombat, swimming = 100, nil, false, false
function UnitHealth() return hp end
function UnitHealthMax() return 100 end
function UnitCanAttack(_, unit) return unit == "target" and target ~= nil end
function UnitName(unit) if unit == "player" then return "Alberich" end if unit == "target" and target then return target.name end end
function UnitClassification() return target and target.rank or "normal" end
function UnitIsPlayer() return false end
function UnitAffectingCombat() return inCombat end
function IsSwimming() return swimming end
local timers = {}
C_Timer = {After = function(delay, fn) if delay >= 10 then timers[#timers + 1] = fn else fn() end end}
local function RunTimers() local list = timers; timers = {}; for _, fn in ipairs(list) do fn() end end
print = function() end

-- The saved list: Dahlia, with a journal of two outings from before.
local db = {enabled = true, peopleJournal = true, colors = {people = {1, 1, 1}},
    people = {["dahlia-noir"] = {name = "Dahlia-Noir", faction = "Horde", class = "WARLOCK"}},
    characters = {["alberich-forever"] = {name = "Alberich", faction = "Horde", class = "PALADIN", race = "Scourge", people = {
        ["dahlia-noir"] = {circle = "companion", journal = {
            {k = "group", t = clock - 86400 * 2, e = clock - 86400 * 2 + 5400, z = "Silverpine Forest"},
            {k = "quest", d = "Arugal's Folly", t = clock - 86400 * 2 + 600, z = "Silverpine Forest"},
            {k = "dungeon", d = "Shadowfang Keep", t = clock - 86400 * 2 + 1200, z = "Shadowfang Keep"},
            {k = "death", w = "you", env = "FALLING", t = clock - 86400 * 2 + 1800, z = "Silverpine Forest"},
            {k = "level", d = 16, t = clock - 86400 * 2 + 2000, z = "Silverpine Forest"}, -- hers: not yours
        }}}}}}

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
local function Kinds(from)
    local out = {}
    for i = from or 1, #journal do out[#out + 1] = journal[i].k end
    return table.concat(out, ",")
end

-- 1. Seeded once from the journal with Dahlia: your time there, your quest,
-- dungeon and fall; her level stays hers.
check(db.characters["alberich-forever"].selfSeeded, "seeded once")
check(Kinds():find("^play,with,quest,dungeon,death,play") ~= nil, "seeded from the journal with Dahlia, then today begins: " .. Kinds())
for _, entry in ipairs(journal) do check(entry.k ~= "level", "her level is not yours") end
local seeded = #journal - 1
A.SelfSeed()
equal(#journal, seeded + 1, "seeding happens once")

-- 2. Today, alone in Durotar: three quests by name, a level, a death, the inn.
local start = #journal
check(journal[start].k == "play" and journal[start].z == "Durotar" and not journal[start].e, "a stretch in Durotar is open")
clock = clock + 600; Fire("QUEST_TURNED_IN", 101)
clock = clock + 300; Fire("QUEST_TURNED_IN", 102)
clock = clock + 60; level = 6; Fire("PLAYER_LEVEL_UP", 6)
clock = clock + 400; Fire("PLAYER_DEAD")
clock = clock + 200; resting, subzone = true, "Razor Hill"; Fire("PLAYER_UPDATE_RESTING"); Fire("PLAYER_UPDATE_RESTING")
equal(Kinds(start), "play,quest,quest,mylevel,death,rest", "Durotar, alone")
equal(journal[start + 1].d, "Sarkoth", "every quest by name")
equal(journal[start + 1].qid, 101, "new personal records retain the exact quest ID")
equal(journal[start + 3].d, 6, "your level")
-- 3. On to the Barrens; a /reload in the same zone goes on with the same stretch.
clock = clock + 100; zone, resting = "The Barrens", false; Fire("ZONE_CHANGED_NEW_AREA")
check(journal[start].e == clock, "Durotar ends when you leave it")
local barrens = #journal
Fire("PLAYER_LOGOUT"); clock = clock + 30; Fire("PLAYER_ENTERING_WORLD")
equal(#journal, barrens, "a /reload in the same zone: the same stretch")
check(journal[barrens].e == nil, "and it goes on")
-- 4. Dahlia joins (Journal.lua opens an outing with her: your journal notes it).
clock = clock + 60; A.SelfWith("dahlia-noir", db.people["dahlia-noir"], true)
clock = clock + 1800; Fire("QUEST_TURNED_IN", 103)
instance = "Wailing Caverns"; zone = "Wailing Caverns"; Fire("ZONE_CHANGED_NEW_AREA")
Fire("ENCOUNTER_START", 1, "Mutanus the Devourer"); Fire("ENCOUNTER_END", 1, "Mutanus the Devourer", 0, 5, 1)
clock = clock + 1200; A.SelfWith("dahlia-noir", nil, false)
check(Kinds(barrens):find("with,quest,play,dungeon,boss") ~= nil, "with Dahlia, a quest, the Caverns and their boss: " .. Kinds(barrens))

-- 5. Told in your own words.
local me = A.SelfPerson()
check(me.self and me.name == "Alberich" and not me.readOnly, "your journal as a person the book can show")
local days = A.JournalBook(me)
local today = days[#days]
local text = {}
for _, scene in ipairs(today.scenes) do
    local t = A.JournalSceneText(me, scene, "you")
    if t then text[#text + 1] = A.JournalPlain(t) end
end
local all = table.concat(text, " | ")
check(all:find("Durotar", 1, true) and all:find("Sarkoth", 1, true) and all:find("Vile Familiars", 1, true), "the quests by name: " .. all)
check(all:find("I [%a ]+ level 6%.") ~= nil, "your level, as yours: " .. all)
check(all:find("Dahlia", 1, true) and (all:find("with me", 1, true) or all:find("travelled with", 1, true) or all:find("joined me", 1, true)
    or all:find("at my side", 1, true)), "Dahlia is there, not the subject: " .. all)
check(not all:find("together", 1, true) and not all:find(" you ", 1, true) and not all:find("^You", 1), "first person only: " .. all)
check(all:find("Razor Hill", 1, true), "the inn: " .. all)
local highlights = A.JournalPlain((A.JournalDayHighlights(me, today, "you")))
check(highlights:find("I spent", 1, true) or highlights:find("hour", 1, true), "Highlights, in your words: " .. highlights)
check(highlights:find("Dahlia", 1, true) and highlights:find("level 6", 1, true), "Highlights: Dahlia and your level: " .. highlights)
-- Seeded days read the same way.
local old = {}
for _, scene in ipairs(days[1].scenes) do
    local t = A.JournalSceneText(me, scene, "we")
    if t then old[#old + 1] = A.JournalPlain(t) end
end
local first = table.concat(old, " | ")
check(first:find("Silverpine Forest", 1, true) and first:find("Arugal's Folly", 1, true) and first:find("fell to my death", 1, true)
    and first:find("Dahlia", 1, true), "a seeded day: " .. first)
-- Your written lines are kept, and nothing is ever trimmed.
check(A.JournalWrite(me, "A good first day in Durotar."), "you can write in your journal")
for i = 1, 400 do Fire("QUEST_TURNED_IN", 101) end
check(#journal > 400, "no limit: every quest is kept (" .. #journal .. " lines)")
-- Another character's own journal is read only.
db.characters["mime-forever"] = {name = "Mime", faction = "Horde", people = {}, journal = {{k = "play", t = clock, e = clock + 600, z = "Mulgore"}}}
local theirs = A.SelfPerson("mime-forever")
check(theirs.readOnly and not A.JournalWrite(theirs, "no"), "another character's journal is read only")

-- Close calls: under an eighth of your health, alive twenty seconds later.
local before = #journal
target, inCombat, hp = {name = "Kobold Tunneler", rank = "normal"}, true, 8
A.SelfHealthCheck(); A.SelfHealthCheck()
RunTimers()
local call = journal[#journal]
check(#journal == before + 1 and call.k == "close" and call.d == "Kobold Tunneler" and call.a, "a kobold nearly got me: recorded once")
equal(A.JournalPlain(A.JournalEventText("Alberich", {k = "close", d = "Kobold Tunneler", a = true, t = 1}, nil)):match("Kobold Tunneler") ~= nil, true,
    "told with its name")
local told = A.JournalPlain(A.JournalEventText("Alberich", {k = "close", d = "Kobold Tunneler", a = true, t = 2}, nil))
check(told:find("^A Kobold Tunneler") or told:find("from a Kobold Tunneler"), "a kobold, with its article: " .. told)
-- Five minutes later, a fall out of combat.
clock = clock + 400; target, inCombat, hp = nil, false, 5
A.SelfHealthCheck(); RunTimers()
check(journal[#journal].k == "close" and journal[#journal].env == "FALLING", "I almost fell to my death")
check(A.JournalEventText("Alberich", journal[#journal], nil):find("f[ae]ll") ~= nil, "told as a fall")
-- Low, then dead: that is a death, not a close call.
clock = clock + 400; hp = 3
local count = #journal
A.SelfHealthCheck(); dead = true; Fire("PLAYER_DEAD"); RunTimers(); dead = false
check(journal[#journal].k == "death" and #journal == count + 1, "a death is not a close call")

-- Caves and mines: once per stretch; towns and look-alike names are not.
clock = clock + 600; hp, instance, dead = 100, nil, false
zone, subzone = "Elwynn Forest", "Goldshire"; Fire("ZONE_CHANGED_NEW_AREA")
local elwynn = #journal
subzone = "Fargodeep Mine"; Fire("ZONE_CHANGED"); Fire("ZONE_CHANGED_INDOORS")
clock = clock + 300; subzone = "Goldshire"; Fire("ZONE_CHANGED")
clock = clock + 300; subzone = "Fargodeep Mine"; Fire("ZONE_CHANGED")
local caves = 0
for i = elwynn, #journal do if journal[i].k == "cave" then caves = caves + 1 end end
equal(caves, 1, "Fargodeep Mine, once per stretch")
check(A.SelfUnderground("The Jasperlode Mine") and A.SelfUnderground("Echo Ridge Mine") and A.SelfUnderground("The Den")
    and not A.SelfUnderground("Denhaven") and not A.SelfUnderground("Goldshire"), "what counts as underground")
clock = clock + 1200; subzone = "Goldshire"; Fire("QUEST_TURNED_IN", 101)
local days = A.JournalBook(A.SelfPerson())
local lastDay, found = days[#days], false
for _, scene in ipairs(lastDay.scenes) do
    local t = A.JournalSceneText(A.SelfPerson(), scene, "you")
    if t and A.JournalPlain(t):find("into Fargodeep Mine", 1, true) then found = true end
end
check(found, "the mine is told")

-- Gathering and crafting: counted, one line per kind and stretch.
C_Spell = {GetSpellName = function(id) return ({[3915] = "Brown Linen Shirt", [2385] = "Linen Cloak"})[id] end}
C_TradeSkillUI = {GetBaseProfessionInfo = function() return {professionName = "Tailoring"} end}
local before = #journal
for _ = 1, 12 do Fire("UNIT_SPELLCAST_SUCCEEDED", "player", "cast", 2575) end
for _ = 1, 5 do Fire("UNIT_SPELLCAST_SUCCEEDED", "player", "cast", 8613) end
Fire("UNIT_SPELLCAST_SUCCEEDED", "party1", "cast", 2575) -- not yours
Fire("TRADE_SKILL_SHOW")
for _ = 1, 7 do Fire("UNIT_SPELLCAST_SUCCEEDED", "player", "cast", 3915) end
Fire("UNIT_SPELLCAST_SUCCEEDED", "player", "cast", 2385); Fire("UNIT_SPELLCAST_SUCCEEDED", "player", "cast", 2385)
Fire("TRADE_SKILL_CLOSE")
Fire("UNIT_SPELLCAST_SUCCEEDED", "player", "cast", 3915) -- window closed: not a craft
local mining, skinning, tailoring
for i = before + 1, #journal do
    local e = journal[i]
    if e.k == "gather" and e.d == "mining" then mining = e end
    if e.k == "gather" and e.d == "skinning" then skinning = e end
    if e.k == "craft" then tailoring = e end
end
check(#journal == before + 3, "one line each: mining, skinning, tailoring (" .. (#journal - before) .. ")")
check(mining and mining.c == 12 and skinning and skinning.c == 5, "counted")
check(tailoring and tailoring.d == "Tailoring" and tailoring.c == 9 and #tailoring.m == 2, "nine things made, two kinds")
clock = clock + 60
local lastDay = A.JournalBook(A.SelfPerson())
lastDay = lastDay[#lastDay]
local said = {}
for _, scene in ipairs(lastDay.scenes) do
    local t = A.JournalSceneText(A.SelfPerson(), scene, "you")
    if t then said[#said + 1] = A.JournalPlain(t) end
end
local page = table.concat(said, " ")
check(page:find("mined twelve veins", 1, true) and page:find("skinned five beasts", 1, true), "honest work, told: " .. page)
check(page:find("I made nine things at Tailoring, among them Brown Linen Shirt and Linen Cloak.", 1, true), "crafting, told: " .. page)

-- Firsts: once ever; a zone only at a level that fits it; seeded places are not new.
A.LoreZoneLevels = {["Durotar"] = {1, 10}, ["Westfall"] = {10, 20}, ["Stranglethorn Vale"] = {30, 45}, ["Silverpine Forest"] = {10, 20}}
local function FirstsOf(what)
    local n = 0
    for _, e in ipairs(journal) do if e.k == "first" and (e.d == what or e.z == what) then n = n + 1 end end
    return n
end
db.characters["alberich-forever"].selfStartLevel = 1 -- (a journal kept from level 1: its firsts are sure)
clock = clock + 600; level = 12; zone = "Westfall"; Fire("ZONE_CHANGED_NEW_AREA")
clock = clock + 600; zone = "Deeprun Tram"; Fire("ZONE_CHANGED_NEW_AREA")
clock = clock + 600; zone = "Westfall"; Fire("ZONE_CHANGED_NEW_AREA")
clock = clock + 600; zone = "Deeprun Tram"; Fire("ZONE_CHANGED_NEW_AREA")
clock = clock + 600; zone = "Stranglethorn Vale"; Fire("ZONE_CHANGED_NEW_AREA")
clock = clock + 600; zone = "Silverpine Forest"; Fire("ZONE_CHANGED_NEW_AREA")
equal(FirstsOf("Westfall"), 1, "a first visit to Westfall, once")
equal(FirstsOf("tram"), 1, "the tram, once")
equal(FirstsOf("Stranglethorn Vale"), 1, "a zone above your level is still new")
equal(FirstsOf("Silverpine Forest"), 0, "a place from the seeded journal is not new")
level = 60; zone = "Durotar"; Fire("ZONE_CHANGED_NEW_AREA")
equal(FirstsOf("Durotar"), 0, "an old hand in Durotar is not new there")
UnitOnTaxi = function() return true end
Fire("PLAYER_CONTROL_LOST"); Fire("PLAYER_CONTROL_LOST")
equal(FirstsOf("flight"), 1, "a first flight, once")
local tramText = A.JournalPlain(A.JournalEventText("Alberich", {k = "close"}, nil))
check(tramText ~= "", "(close text)")
local told = {}
for _, day in ipairs(A.JournalBook(A.SelfPerson())) do
    for _, scene in ipairs(day.scenes) do
        local t = A.JournalSceneText(A.SelfPerson(), scene, "you")
        if t then told[#told + 1] = A.JournalPlain(t) end
    end
end
local book = table.concat(told, " ")
check(book:find("Deeprun Tram", 1, true) and (book:find("first time in Westfall", 1, true) or book:find("never been to Westfall", 1, true))
    and (book:find("first flight", 1, true) or book:find("I flew", 1, true)), "firsts, told: " .. book:sub(-600))

-- Voyages: crossing to the other continent; the very first time is a first.
local MAPS = {[1] = {name = "Kalimdor", mapType = 2}, [2] = {name = "Eastern Kingdoms", mapType = 2},
    [10] = {name = "Durotar", mapType = 3, parentMapID = 1}, [11] = {name = "The Barrens", mapType = 3, parentMapID = 1},
    [20] = {name = "Tirisfal Glades", mapType = 3, parentMapID = 2}, [21] = {name = "Stranglethorn Vale", mapType = 3, parentMapID = 2}}
local MAP_OF = {["Durotar"] = 10, ["The Barrens"] = 11, ["Tirisfal Glades"] = 20, ["Stranglethorn Vale"] = 21}
C_Map = {GetBestMapForUnit = function() return MAP_OF[zone] end, GetMapInfo = function(id) return MAPS[id] end}
local function Voyages()
    local out = {}
    for _, e in ipairs(journal) do if e.k == "voyage" then out[#out + 1] = e end end
    return out
end
level = 20
clock = clock + 600; zone = "Durotar"; Fire("ZONE_CHANGED_NEW_AREA")        -- the continent is known now
check(#Voyages() == 0, "no voyage the first time the continent is known")
clock = clock + 900; zone = "Tirisfal Glades"; Fire("PLAYER_ENTERING_WORLD")  -- the zeppelin
local v = Voyages()
check(#v == 1 and v[1].d == "zeppelin" and v[1].from == "Kalimdor" and v[1].to == "Eastern Kingdoms", "Horde, across the sea: the zeppelin")
check(FirstsOf("zeppelin") == 1 and FirstsOf("Eastern Kingdoms") == 1, "the first zeppelin and a new continent")
clock = clock + 900; zone = "Durotar"; Fire("PLAYER_ENTERING_WORLD")
check(#Voyages() == 2 and FirstsOf("zeppelin") == 1, "the second crossing is not a first")
clock = clock + 900; Fire("UNIT_SPELLCAST_SUCCEEDED", "player", "cast", 8690); zone = "Tirisfal Glades"; Fire("PLAYER_ENTERING_WORLD")
check(Voyages()[3].d == "hearth", "a hearthstone home is not a sea crossing")
clock = clock + 900; zone = "Stranglethorn Vale"; Fire("ZONE_CHANGED_NEW_AREA")
clock = clock + 900; zone = "The Barrens"; Fire("PLAYER_ENTERING_WORLD")
check(Voyages()[4].d == "boat" and FirstsOf("boat") == 1, "Booty Bay to Ratchet: the boat, a first")
local voyageText = A.JournalPlain(A.JournalVoyageText(Voyages()[1]))
check(voyageText:find("zeppelin", 1, true) and voyageText:find("Eastern Kingdoms", 1, true), "told plainly: " .. voyageText)

-- Milestones of a life: mounts, a raid, a world boss, famous items, tier sets,
-- the first world PvP, Blackrock Mountain, a sunset at the sea. Each once.
local mounted, speed, gameHour, gameMinute = false, 0, 12, 0
function IsMounted() return mounted end
function GetUnitSpeed() return speed end
function UnitOnTaxi() return false end
function GetGameTime() return gameHour, gameMinute end
local ITEMS = {[18608] = {"Benediction", 5}, [16811] = {"Boots of Prophecy", 4, 202}, [16812] = {"Gloves of Prophecy", 4, 202},
    [12345] = {"Sword of Something", 4}}
function GetItemInfo(item)
    local id = tonumber(tostring(item):match("item:(%d+)") or item)
    local x = ITEMS[id]
    if not x then return nil end
    return x[1], nil, x[2], nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, x[3]
end
function GetItemSetInfo(id) return id == 202 and "Vestments of Prophecy" or nil end
local equipped = {}
function GetInventoryItemID(_, slot) return equipped[slot] end
local function Milestone(what) return FirstsOf(what) end
local function Link(id) return "|cffa335ee|Hitem:" .. id .. "::::::::60:::::|h[x]|h|r" end
level = 30; mounted = true; Fire("PLAYER_MOUNT_DISPLAY_CHANGED")
check(Milestone("mount") == 0, "no mount of your own before 40 (a quest or event mount)")
level = 60; Fire("PLAYER_MOUNT_DISPLAY_CHANGED"); Fire("PLAYER_MOUNT_DISPLAY_CHANGED")
check(Milestone("mount") == 1, "the first mount, once")
speed = 11.2; A.SelfTick()
check(Milestone("epicmount") == 0, "a normal mount is not an epic one")
speed = 14; A.SelfTick(); A.SelfTick()
check(Milestone("epicmount") == 1, "the epic mount, once")
mounted, speed = false, 0
clock = clock + 600; zone, subzone = "Searing Gorge", "Blackrock Mountain"; Fire("ZONE_CHANGED_NEW_AREA"); Fire("ZONE_CHANGED")
check(Milestone("Blackrock Mountain") == 1, "Blackrock Mountain, the first time")
instance = "Molten Core"; zone = "Molten Core"
IsInInstance = function() return true, "raid" end
Fire("ZONE_CHANGED_NEW_AREA")
check(Milestone("Molten Core") == 1, "the first raid")
Fire("ENCOUNTER_START", 1, "Lord Kazzak"); Fire("ENCOUNTER_END", 1, "Lord Kazzak", 0, 40, 1)
check(Milestone("Lord Kazzak") == 1, "the first world boss")
IsInInstance = function() return instance ~= nil, instance and "party" or "none" end
instance = nil; zone, subzone = "The Barrens", "The Crossroads"; Fire("ZONE_CHANGED_NEW_AREA")
Fire("CHAT_MSG_LOOT", "You receive loot: " .. Link(12345) .. ".", "Alberich")
Fire("CHAT_MSG_LOOT", "Dahlia receives loot: " .. Link(18608) .. ".", "Dahlia")
check(Milestone("Sword of Something") == 1 and Milestone("Benediction") == 0, "your first epic; another's loot is not yours")
Fire("CHAT_MSG_LOOT", "You receive loot: " .. Link(18608) .. ".", "Alberich")
check(Milestone("Benediction") >= 1, "Benediction, at last")
equipped = {[8] = 16811}; Fire("PLAYER_EQUIPMENT_CHANGED")
check(Milestone("Vestments of Prophecy") == 1, "the first tier piece")
equipped = {}
for slot = 1, 8 do equipped[slot] = slot % 2 == 0 and 16811 or 16812 end
Fire("PLAYER_EQUIPMENT_CHANGED")
check(Milestone("Vestments of Prophecy") == 2, "the whole set, once")
Fire("PLAYER_PVP_KILLS_CHANGED"); Fire("PLAYER_PVP_KILLS_CHANGED")
check(Milestone("pvp") == 1, "the first world PvP, once")
zone, subzone = "Stranglethorn Vale", "The Savage Coast"; Fire("ZONE_CHANGED_NEW_AREA")
gameHour, gameMinute = 19, 40
A.SelfTick(); clock = clock + 30; A.SelfTick(); clock = clock + 30; A.SelfTick()
check(Milestone("The Savage Coast") == 1, "a sunset at the sea")
gameHour = 13; clock = clock + 600; subzone = "Jaguero Isle"; A.SelfTick(); clock = clock + 60; A.SelfTick()
check(Milestone("Jaguero Isle") == 0, "not at noon")
local said = A.JournalPlain(A.JournalEventText and "" or "")
for _, e in ipairs(journal) do
    if e.k == "first" and e.d == "famous" then said = e.z end
end
check(said == "Benediction", "told by name")
-- A journal begun at 50: the moment is kept, marked unsure, and told without "first".
local mine = db.characters["alberich-forever"]
mine.firsts.pvp, mine.firsts.tram = nil, nil
mine.selfStartLevel = 50
Fire("PLAYER_PVP_KILLS_CHANGED")
local unsure = journal[#journal]
check(unsure.k == "first" and unsure.d == "pvp" and unsure.u, "kept, and marked unsure")
local plain = A.JournalPlain(A.JournalUnsureFirst(unsure))
check((plain:find("won", 1, true) or plain:find("fell", 1, true)) and not plain:find("first", 1, true), "told without claiming a first: " .. plain)
local count = #journal
Fire("PLAYER_PVP_KILLS_CHANGED")
check(#journal == count, "and only once")
-- Begun before level 10: every first is sure (the tram at 9 too); from 10, the gates.
mine.selfStartLevel = 9
zone = "Deeprun Tram"; Fire("ZONE_CHANGED_NEW_AREA")
check(journal[#journal].d == "tram" and not journal[#journal].u, "a journal begun at 9: the tram, a real first")
mine.firsts.tram = nil; mine.selfStartLevel = 12
zone = "Ironforge"; Fire("ZONE_CHANGED_NEW_AREA"); zone = "Deeprun Tram"; Fire("ZONE_CHANGED_NEW_AREA")
check(journal[#journal].d == "tram" and journal[#journal].u, "a journal begun at 12: the tram, unsure")
mine.selfStartLevel = 5

-- The research list: the other side seen, a guild, a home, class milestones,
-- the first you raised, the first blue, a battleground.
local function Last(kind, d)
    for i = #journal, 1, -1 do
        local e = journal[i]
        if e.k == kind and (not d or e.d == d) then return e end
    end
end
do
    local unitPlayer, unitFaction, unitRace, unitClass = {}, {}, {}, {}
    local oldIsPlayer, oldFaction, oldRace, oldClass = UnitIsPlayer, UnitFactionGroup, UnitRace, UnitClass
    function UnitIsPlayer(unit) return unitPlayer[unit] or false end
    function UnitFactionGroup(unit) if unit == "player" then return "Horde" end return unitFaction[unit] end
    function UnitRace(unit) if unit == "player" then return "Undead", "Scourge" end return unitRace[unit] end
    function UnitClass(unit) if unit == "player" then return "Paladin", "PALADIN" end return unitClass[unit] end
    zone = "Ashenvale"; Fire("ZONE_CHANGED_NEW_AREA")
    unitPlayer.mouseover, unitFaction.mouseover, unitRace.mouseover, unitClass.mouseover = true, "Horde", "Orc", "Warrior"
    Fire("UPDATE_MOUSEOVER_UNIT")
    check(FirstsOf("foeseen") == 0, "one of your own side is not the enemy")
    unitFaction.mouseover, unitRace.mouseover, unitClass.mouseover = "Alliance", "Night Elf", "Hunter"
    Fire("UPDATE_MOUSEOVER_UNIT"); Fire("UPDATE_MOUSEOVER_UNIT")
    local seen = Last("first", "foeseen")
    check(FirstsOf("foeseen") == 1 and seen.n == "Night Elf" and seen.c == "Hunter" and seen.z == "Ashenvale", "the first of the other side, once, with what they were")
    -- A guild: not at login (the game fills it in late), then when you join one.
    local guild
    function GetGuildInfo() return guild end
    Fire("PLAYER_ENTERING_WORLD"); guild = "Old Guild"; Fire("PLAYER_GUILD_UPDATE")
    RunTimers()
    check(not Last("guild"), "the guild you had at login is not news")
    clock = clock + 60; guild = "Knights of Ember"; Fire("PLAYER_GUILD_UPDATE")
    check(Last("guild") and Last("guild").d == "Knights of Ember", "joining a guild")
    -- A home: the hearthstone bound somewhere new.
    local bind = "Crossroads"
    function GetBindLocation() return bind end
    A.SelfCheckHome()
    check(not Last("home"), "where your hearthstone was is not news")
    bind = "Splintertree Post"; Fire("HEARTHSTONE_BOUND")
    check(Last("home") and Last("home").d == "Splintertree Post", "a new home")
    -- Class milestones from the spells you know, each once, gated by level.
    local known = {}
    function IsPlayerSpell(id) return known[id] or false end
    known[13819] = true; Fire("SPELLS_CHANGED"); Fire("SPELLS_CHANGED")
    local horse = Last("first", "class")
    check(horse and horse.z == "warhorse" and FirstsOf("warhorse") == 1 and not horse.u, "the warhorse, once (a journal from level 1: sure)")
    -- The first you raised, the first blue item.
    C_Spell.GetSpellName = function(id) return ({[3915] = "Brown Linen Shirt", [2385] = "Linen Cloak", [7328] = "Redemption"})[id] end
    target = {name = "Dahlia"}
    Fire("UNIT_SPELLCAST_SUCCEEDED", "player", "cast", 7328)
    target = nil
    check(Last("first", "rezother") and Last("first", "rezother").n == "Dahlia", "the first you brought back, by name")
    ITEMS[4444] = {"Soft Fur-lined Shoes", 3}
    Fire("CHAT_MSG_LOOT", "You receive loot: " .. Link(4444), "Alberich")
    check(Last("first", "rare") and Last("first", "rare").z == "Soft Fur-lined Shoes", "the first blue")
    -- A battleground: a first, and not a dungeon.
    local oldInInstance, oldInfo = IsInInstance, GetInstanceInfo
    function IsInInstance() return true, "pvp" end
    function GetInstanceInfo() return "Warsong Gulch", "pvp" end
    zone = "Warsong Gulch"; Fire("ZONE_CHANGED_NEW_AREA")
    check(Last("first", "battleground") and Last("bg") and not (Last("dungeon") and Last("dungeon").d == "Warsong Gulch"), "a battleground, not a dungeon")
    IsInInstance, GetInstanceInfo = oldInInstance, oldInfo
    zone = "The Barrens"; Fire("ZONE_CHANGED_NEW_AREA")
    UnitIsPlayer, UnitFactionGroup, UnitRace, UnitClass = oldIsPlayer, oldFaction, oldRace, oldClass
end

-- Small wonders: the first snow, a rare creature, a long swim, a flight by
-- night, a night at the inn, the long walk back as a ghost, the first sale.
do
    local oldRace = UnitRace
    function UnitRace(unit) if unit == "player" then return "Undead", "Scourge" end end
    zone = "Alterac Mountains"; Fire("ZONE_CHANGED_NEW_AREA")
    check(Last("first", "snow") and Last("first", "snow").z == "Alterac Mountains", "the first snow")
    UnitRace = oldRace
    local oldClass = UnitClassification
    local rareTarget = true
    function UnitClassification() return rareTarget and "rare" or "normal" end
    target = {name = "Gravis Slipknot"}; Fire("PLAYER_TARGET_CHANGED")
    check(Last("first", "rarebeast") and Last("first", "rarebeast").z == "Gravis Slipknot", "a rare creature seen")
    target = nil; UnitClassification = oldClass
    -- a long swim on the ticker
    swimming = true
    A.SelfTick(); clock = clock + 60; A.SelfTick(); clock = clock + 60; A.SelfTick()
    swimming = false
    check(Last("swim"), "a long swim")
    -- a flight by night
    function UnitOnTaxi() return true end
    gameHour = 22
    Fire("PLAYER_CONTROL_LOST")
    check(Last("nightflight"), "a flight by night")
    function UnitOnTaxi() return false end
    gameHour = 12
    -- the first auction sale
    ERR_AUCTION_SOLD_S = "A buyer has been found for your auction of %s."
    Fire("CHAT_MSG_SYSTEM", "A buyer has been found for your auction of Heavy Silk Bandage.")
    check(Last("first", "aucsale") and Last("first", "aucsale").z == "Heavy Silk Bandage", "the first sale")
    -- the long walk back as a ghost (no one brought you back)
    Fire("PLAYER_DEAD")
    local death = Last("death")
    dead = true; clock = clock + 240; dead = false
    Fire("PLAYER_UNGHOST")
    check(death and death.walk and death.walk >= 180, "the walk back is kept on the death")
    -- a night at the inn: logging out while resting
    resting, subzone = true, "Tarren Mill"
    Fire("PLAYER_LOGOUT")
    check(Last("sleep") and Last("sleep").d == "Tarren Mill", "a night at the inn")
    resting = false
    Fire("PLAYER_ENTERING_WORLD")
end

-- Notable people: real observations, then real dialogue; never inferred from
-- entering their city, a player sharing a name, or an unrelated target.
do
    local oldName, oldPlayer, oldWords = UnitName, UnitIsPlayer, A.SelfWords
    local sight, npc, player = nil, nil, false
    A.SelfWords = {notableNPCs = {["Lady Sylvanas Windrunner"] = {}, Thrall = {}, ["Cairne Bloodhoof"] = {}}}
    function UnitName(unit)
        if unit == "target" then return sight end
        if unit == "npc" then return npc end
        return oldName(unit)
    end
    function UnitIsPlayer(unit) return unit == "target" and player end
    zone = "Undercity"; Fire("ZONE_CHANGED_NEW_AREA")
    local before = #journal
    check(not Last("first", "notable"), "entering Undercity does not invent an audience with Sylvanas")
    sight, player = "Lady Sylvanas Windrunner", true
    Fire("PLAYER_TARGET_CHANGED")
    equal(#journal, before, "a player with a notable name is not an NPC encounter")
    player = false
    Fire("PLAYER_TARGET_CHANGED")
    local seen = Last("first", "notable")
    check(seen and seen.n == sight and not seen.interaction, "target records seeing the named figure")
    Fire("PLAYER_TARGET_CHANGED"); Fire("GOSSIP_SHOW")
    equal(#journal, before + 1, "repeated targeting and missing npc unit do not duplicate or invent dialogue")
    clock = clock + 5; npc = sight
    Fire("GOSSIP_SHOW")
    check(seen.interaction and seen.t == clock, "actual dialogue upgrades the recent sighting")
    Fire("QUEST_DETAIL")
    equal(#journal, before + 1, "gossip and quest detail keep one conversation")
    local days = A.JournalBook(A.SelfPerson())
    local found, prose = false, false
    for _, day in ipairs(days) do for _, scene in ipairs(day.scenes) do
        for _, e in ipairs(scene.events or {}) do
            if e.d == "notable" and e.n == sight then found = e.interaction end
        end
        local text = A.JournalSceneText(A.SelfPerson(), scene, "you") or ""
        if text:find("I spoke with", 1, true) and text:find(sight, 1, true) then prose = true end
    end end
    check(found and prose, "book and plain reading retain the interaction evidence")
    sight, npc = "Thrall", nil
    Fire("PLAYER_TARGET_CHANGED")
    local earlier = Last("first", "notable")
    clock = clock + 180; npc = sight
    Fire("QUEST_DETAIL")
    check(not earlier.interaction and Last("first", "notable") ~= earlier and Last("first", "notable").interaction,
        "a later conversation preserves the earlier sighting")
    before = #journal
    sight, npc = "Cairne Bloodhoof", "Cairne Bloodhoof"
    db.selfJournal = false
    Fire("PLAYER_TARGET_CHANGED"); Fire("GOSSIP_SHOW")
    equal(#journal, before, "disabled recording ignores notable encounters")
    db.selfJournal = true
    UnitName, UnitIsPlayer, A.SelfWords = oldName, oldPlayer, oldWords
end

io.write("PASS: " .. assertions .. " own-journal assertions\n")
