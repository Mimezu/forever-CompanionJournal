local _, A = ...
-- Your own journal: what this character lives through, always (alone or with
-- others), in the same lines as the journals kept with people, so the book and
-- its styles tell it too. Kept per character (db.characters[you].journal),
-- never trimmed: every quest keeps its name.
--   play     time in one zone (t .. e), like an outing
--   with     someone from your list in your group (d = their key, n = name)
--   quest, dungeon, boss, wipe, death, rez (by = who), rest, campfire, mylevel
-- Seeded once from what your journals with people already know.

local function Public(value) return not issecretvalue or not issecretvalue(value) end
local function Text(value)
    return Public(value) and type(value) == "string" and value ~= "" and value or nil
end
local function Now() return time and time() or 0 end
local function Zone() return Text(GetRealZoneText and GetRealZoneText()) end
local function Ask(fn, ...)
    if type(fn) ~= "function" then return nil end
    local ok, a, b = pcall(fn, ...)
    if not ok or not Public(a) then return nil end
    return a, b
end
-- The kind of beast you ride, read from the mount's aura name ("Swift Raptor": raptor); nil when unsure.
local MOUNT_KINDS = {{"raptor", "raptor"}, {"wolf", "wolf"}, {"kodo", "kodo"}, {"mechanostrider", "mechanostrider"}, {"%f[%a]ram%f[%A]", "ram"},
    {"saber", "saber"}, {"skeletal", "skeletal"}, {"stallion", "horse"}, {"%f[%a]mare%f[%A]", "horse"}, {"pinto", "horse"}, {"palomino", "horse"},
    {"horse", "horse"}, {"steed", "horse"}}
local function MountKind()
    local byIndex = C_UnitAuras and C_UnitAuras.GetAuraDataByIndex
    if type(byIndex) ~= "function" then return nil end
    for index = 1, 40 do
        local ok, aura = pcall(byIndex, "player", index, "HELPFUL")
        if not ok or type(aura) ~= "table" then break end
        local name = Text(aura.name)
        if name then
            local low = name:lower()
            for _, k in ipairs(MOUNT_KINDS) do if low:find(k[1]) then return k[2] end end
        end
    end
    return nil
end
local RESUME = 600 -- back in the same zone within ten minutes (a /reload, a loading screen): the same stretch

A.defaults.selfJournal = true
function A.SelfJournalOn()
    local db = A.db
    return A.JournalOn() and db.selfJournal ~= false and A.Me and A.Me() ~= nil
end
-- "Record more moments" (off until you turn it on): books and plaques read,
-- areas discovered, flight paths learned, spells bought from a trainer, a
-- standing reached with a faction, duels, trade-skill milestones, honorable
-- kills in the open world, a rare creature killed. Small factual lines, like
-- the rest; nothing here is recorded while it is off.
A.defaults.moreMoments = false
function A.MoreMomentsOn()
    return A.SelfJournalOn() and A.db.moreMoments == true
end

-- Your own journal as a person the book and the journal window can show:
-- this character's (writable), or another character's (read only).
function A.SelfPerson(charKey)
    local me = A.Me and A.Me()
    charKey = charKey or me
    if not charKey then return nil end
    local character = charKey == me and A.MyCharacter and A.MyCharacter(true) or (A.CharacterRecord and A.CharacterRecord(charKey))
    if type(character) ~= "table" then return nil end
    character.journal = type(character.journal) == "table" and character.journal or {}
    local level = charKey == me and tonumber(Ask(UnitLevel, "player")) or character.level
    return {self = true, charKey = charKey, name = character.name or A.CharacterName(charKey), class = character.class,
        race = character.race, faction = character.faction, level = level, journal = character.journal, retell = character.retell,
        startLevel = character.selfStartLevel, lastName = character.lastName,
        readOnly = charKey ~= me or nil}
end
local function Add(entry)
    if not A.SelfJournalOn() then return nil end
    local person = A.SelfPerson()
    return person and A.JournalAdd(person, entry)
end
A.SelfAdd = Add
local function Journal()
    local person = A.SelfJournalOn() and A.SelfPerson()
    return person and person.journal
end

-- Firsts: things done once, ever, per character (the tram, a first flight, a
-- first visit to a zone at a level that fits it). {k = "first", d = what}.
local function Firsts()
    local mine = A.MyCharacter and A.MyCharacter(true)
    if type(mine) ~= "table" then return nil end
    mine.firsts = type(mine.firsts) == "table" and mine.firsts or {}
    return mine.firsts
end
-- "For the first time" is only claimed when the journal has been kept since
-- before the thing was possible: the tram, a boat or another continent are
-- open from the first levels (a dwarf can ride the tram at level 1); a mount
-- waits for 40, an epic mount for 60, raid gear for the raids. Otherwise the
-- moment is still kept, marked unsure (u), and told without the claim. The
-- level from which each is possible:
local POSSIBLE = {mount = 40, epicmount = 60, epic = 20, legendary = 60, famous = 60, tier = 58, setfull = 45, raid = 14,
    worldboss = 60, landmark = 30, pvp = 10, tram = 1, flight = 1, zeppelin = 1, boat = 1, continent = 1,
    foeseen = 1, battleground = 10, rezother = 10, rare = 1, snow = 1, rarebeast = 1, aucsale = 1, talent = 10, craftepic = 40}
-- (raid 14: the Hall of Thanes is a raid for levels 14 to 18 on Forever)
-- A set piece's gate by tier: the dungeon set (0) from 45, the Molten Core set from 58, the rest from 60.
local TIER_GATE = {[0] = 45, [1] = 58, [2] = 60, [2.5] = 60, [3] = 60}
-- Class milestones: a spell learned (most from a class quest), by id, with the
-- level it comes at (the gate for "the first time").
local CLASS_SPELLS = {
    [5784] = {"felsteed", 40}, [23161] = {"dreadsteed", 60}, [13819] = {"warhorse", 40}, [23214] = {"charger", 60},
    [1515] = {"tame", 10}, [5487] = {"bear", 10}, [1066] = {"aquatic", 16}, [783] = {"travel", 30}, [768] = {"cat", 20},
    [2645] = {"ghostwolf", 20}, [71] = {"defensive", 10}, [2458] = {"berserker", 30}, [2842] = {"poisons", 20},
    [697] = {"voidwalker", 10}, [712] = {"succubus", 20}, [691] = {"felhunter", 30}, [698] = {"summon", 20},
    [11417] = {"portal", 40}, [11418] = {"portal", 40}, [11420] = {"portal", 40}, [10059] = {"portal", 40}, [11416] = {"portal", 40},
    [11419] = {"portal", 40}, [3567] = {"teleport", 20}, [3563] = {"teleport", 20}, [3566] = {"teleport", 20}, [3561] = {"teleport", 20},
    [3562] = {"teleport", 20}, [3565] = {"teleport", 20},
}
CLASS_SPELLS[18960] = {"moonglade", 10}
CLASS_SPELLS[688] = {"imp", 1} -- (a warlock's first demon)
A.SelfClassSpells = CLASS_SPELLS
-- Someone of your party died (Journal.lua sees it): kept in your own journal too.
function A.SelfPartyDeath(name, boss)
    if not A.SelfJournalOn() or not name then return end
    Add({k = "pdeath", n = name, boss = boss})
end
-- Bringing someone back from death, by spell name.
local REZ_SPELLS = {["Resurrection"] = true, ["Redemption"] = true, ["Ancestral Spirit"] = true, ["Rebirth"] = true}
local function StartLevel()
    local mine = A.MyCharacter and A.MyCharacter(true)
    if type(mine) ~= "table" then return nil end
    if not mine.selfStartLevel then mine.selfStartLevel = tonumber(Ask(UnitLevel, "player")) end
    return mine.selfStartLevel
end
local function First(key, entry)
    local firsts = Firsts()
    if not firsts or firsts[key] then return end
    firsts[key] = Now()
    local possible, start = entry.gate or (entry.d == "tier" and TIER_GATE[entry.c]) or POSSIBLE[entry.d], StartLevel()
    entry.gate = nil
    -- A journal begun before level 10 saw it all: every first is sure. Begun
    -- later, a first is sure only above its level gate (a mount at 40...).
    if possible and start and start >= 10 and start > possible then entry.u = true end
    entry.k = "first"
    Add(entry)
end
A.SelfStartLevel = StartLevel
-- Places that are a moment the first time you stand in them.
local LANDMARKS = {["Blackrock Mountain"] = true, ["The Dark Portal"] = true, ["Darkmoon Faire"] = true, ["Gurubashi Arena"] = true,
    ["The Great Lift"] = true, ["Mirage Raceway"] = true, ["Nesingwary's Expedition"] = true}
-- (the level from which each is a real first; Blackrock and the Portal wait for 30)
local LANDMARK_GATE = {["Darkmoon Faire"] = 1, ["The Great Lift"] = 20, ["Nesingwary's Expedition"] = 30, ["Gurubashi Arena"] = 30,
    ["Mirage Raceway"] = 30}
local SNOW = {["Dun Morogh"] = true, ["Alterac Mountains"] = true, ["Winterspring"] = true}
local function ZoneFirsts(zone, current)
    if zone == "Deeprun Tram" then First("tram", {d = "tram"}) end
    -- the first snow (the dwarves and gnomes are born to it)
    if SNOW[zone] then
        local _, race = Ask(UnitRace, "player")
        if race ~= "Dwarf" and race ~= "Gnome" then First("snow", {d = "snow", z = zone}) end
    end
    if LANDMARKS[zone] then First("landmark:" .. zone, {d = "landmark", z = zone, gate = LANDMARK_GATE[zone]}) end
    -- A first visit, when your level fits the zone (an old hand in Westfall is not new there).
    local range = A.LoreZoneLevels and A.LoreZoneLevels[zone]
    local level = tonumber(Ask(UnitLevel, "player"))
    local been = false
    for _, entry in ipairs(Journal() or {}) do if entry.k == "play" and entry.z == zone and entry ~= current then been = true; break end end
    if range and level and level <= range[2] + 3 and not been then First("zone:" .. zone, {d = "zone", z = zone}) end
end

-- Voyages: crossing to another continent ------------------------------------------
-- The continent you are on (Kalimdor, the Eastern Kingdoms...), from the map.
local function Continent()
    if not (C_Map and C_Map.GetBestMapForUnit and C_Map.GetMapInfo) then return nil end
    local id = Ask(C_Map.GetBestMapForUnit, "player")
    for _ = 1, 12 do
        if not id then return nil end
        local info = Ask(C_Map.GetMapInfo, id)
        if type(info) ~= "table" then return nil end
        if info.mapType == 2 then return Text(info.name) end
        id = info.parentMapID
    end
    return nil
end
local travelSpell -- {how = "hearth" or "portal", t}: cast just before a crossing
local lastZone -- where you were before the crossing
-- How you crossed: a hearthstone or a portal cast a moment before; the goblin
-- boat between Booty Bay and Ratchet; otherwise your side's transport (Horde
-- zeppelins, Alliance boats).
local function HowCrossed(from, to)
    if travelSpell and Now() - travelSpell.t <= 90 then return travelSpell.how end
    local boatZones = {["Stranglethorn Vale"] = true, ["The Barrens"] = true}
    if boatZones[from or ""] and boatZones[to or ""] then return "boat" end
    return A.PlayerFaction and A.PlayerFaction() == "Horde" and "zeppelin" or "boat"
end
local function CheckVoyage(zone)
    local mine = A.MyCharacter and A.MyCharacter(true)
    local here = Continent()
    if not mine or not here then return end
    local before = mine.continent
    mine.continent = here
    if before and before ~= here then
        local how = HowCrossed(lastZone, zone)
        travelSpell = nil
        Add({k = "voyage", d = how, from = before, to = here})
        if how == "zeppelin" or how == "boat" then First("voyage:" .. how, {d = how}) end
        First("continent:" .. here, {d = "continent", z = here})
    end
    lastZone = zone
end
A.SelfContinent = Continent

-- Milestones of a life -------------------------------------------------------------
-- Famous items: the first time they are yours.
local FAMOUS = {[18608] = "Benediction", [18609] = "Anathema", [19019] = "Thunderfury, Blessed Blade of the Windseeker",
    [17182] = "Sulfuras, Hand of Ragnaros", [22589] = "Atiesh, Greatstaff of the Guardian", [22630] = "Atiesh, Greatstaff of the Guardian",
    [22631] = "Atiesh, Greatstaff of the Guardian", [22632] = "Atiesh, Greatstaff of the Guardian", [18713] = "Rhok'delar, Longbow of the Ancient Keepers",
    [18715] = "Lok'delar, Stave of the Ancient Keepers", [18348] = "Quel'Serrar"}
-- Tier sets by set id: 1 (Molten Core) and 2 (Blackwing Lair).
local TIERS = {[164] = 1, [201] = 1, [202] = 1, [203] = 1, [204] = 1, [206] = 1, [207] = 1, [208] = 1, [209] = 1,
    [210] = 2, [211] = 2, [212] = 2, [213] = 2, [214] = 2, [215] = 2, [216] = 2, [217] = 2, [218] = 2}
-- The dungeon set (0), the Ahn'Qiraj set (2.5) and the Naxxramas set (3), by the
-- set ids of the 1.12 client; a wrong id only misses a line. The level from
-- which a first piece is a sure first, by tier.
for id = 181, 189 do TIERS[id] = 0 end
for id = 493, 501 do TIERS[id] = 2.5 end
for id = 521, 529 do TIERS[id] = 3 end
local WORLD_BOSSES = {["Azuregos"] = true, ["Lord Kazzak"] = true, ["Emeriss"] = true, ["Lethon"] = true, ["Taerar"] = true,
    ["Ysondre"] = true}
-- An item's name, quality and set id (GetItemInfo's 1st, 3rd and 16th values).
local function ItemInfo(item)
    local info = C_Item and C_Item.GetItemInfo or GetItemInfo
    if not info or not item then return nil end
    local ok, name, _, quality, _, _, _, _, _, _, _, _, _, _, _, _, setID = pcall(info, item)
    if not ok or not Public(name) then return nil end
    return Text(name), tonumber(quality), tonumber(setID)
end
local function SetName(setID)
    local info = (C_Item and C_Item.GetItemSetInfo) or GetItemSetInfo
    local name = info and Text(Ask(info, setID))
    return name
end
A.SelfItemInfo = ItemInfo

-- Stretches of play, zone by zone ------------------------------------------------
local stretch -- the open "play" entry
local function Close(now)
    if stretch then stretch.e, stretch.u = now or Now(), nil end
    stretch = nil
end
local function Open()
    local journal = Journal()
    local zone = Zone()
    if not journal or not zone then return end
    -- (every zone event: the continent may have changed, even back in a zone you know)
    CheckVoyage(zone)
    if stretch and stretch.z == zone then return end
    local now = Now()
    Close(now)
    -- The last stretch in this zone, a moment ago: go on with it.
    for i = #journal, math.max(1, #journal - 40), -1 do
        local entry = journal[i]
        if entry.k == "play" then
            local stop = entry.e or entry.u or entry.t or 0
            if entry.z == zone and now - stop <= RESUME then
                entry.e = nil
                stretch = entry
                return
            end
            break
        end
    end
    stretch = Add({k = "play", z = zone})
    ZoneFirsts(zone, stretch)
end
-- A stretch left open by a crash or a disconnect ends where it was last seen.
local function Settle()
    local journal = Journal()
    if not journal then return end
    for i = #journal, math.max(1, #journal - 40), -1 do
        local entry = journal[i]
        if entry.k == "play" and not entry.e and entry ~= stretch then entry.e, entry.u = entry.u or entry.t, nil end
    end
end

-- Who of your list travels with you ------------------------------------------------
local withOpen = {} -- key -> the open "with" entry
function A.SelfWith(key, person, together, now)
    if not A.SelfJournalOn() or not key then return end
    now = now or Now()
    if together then
        if withOpen[key] then return end
        local journal = Journal()
        -- Back together a moment after a /reload: the same entry.
        for i = #(journal or {}), math.max(1, #(journal or {}) - 40), -1 do
            local entry = journal[i]
            if entry.k == "with" and entry.d == key and now - (entry.e or entry.t or 0) <= RESUME then
                entry.e = nil
                withOpen[key] = entry
                return
            end
        end
        withOpen[key] = Add({k = "with", d = key, n = person and person.name or nil})
    elseif withOpen[key] then
        withOpen[key].e = now
        withOpen[key] = nil
    end
end

-- Dungeons, bosses, deaths ------------------------------------------------------------
local inside -- the instance you are in (written once per visit)
local function InstanceName()
    if not IsInInstance then return nil end
    local ok, isInside, kind = pcall(IsInInstance)
    if not ok or not isInside or (kind ~= "party" and kind ~= "raid") then return nil end
    return GetInstanceInfo and Text((GetInstanceInfo())) or nil, kind
end
local function CheckInstance()
    local name, kind = InstanceName()
    -- (a battleground is an instance too, but not a dungeon)
    if not name and IsInInstance then
        local ok, isInside, pvpKind = pcall(IsInInstance)
        if ok and isInside and pvpKind == "pvp" and GetInstanceInfo then name, kind = Text((GetInstanceInfo())), "pvp" end
    end
    if name == inside then return end
    inside = name
    if not name then return end
    if kind == "pvp" then
        First("battleground", {d = "battleground", z = name})
        Add({k = "bg", d = name, z = name})
        return
    end
    if kind == "raid" then First("raid", {d = "raid", z = name}) end
    -- Already written for this visit (a /reload inside).
    local journal = Journal()
    for i = #(journal or {}), math.max(1, #(journal or {}) - 30), -1 do
        local entry = journal[i]
        if entry.k == "dungeon" and entry.d == name and Now() - (entry.t or 0) < 3 * 3600 then return end
        if entry.k == "play" and entry.z ~= name then break end
    end
    Add({k = "dungeon", d = name, z = name, r = A.UnitRole and A.UnitRole("player") or nil})
end
local encounter, fallen = nil, false
local diedAt -- when you last died (the walk back as a ghost)
local function DeathCause()
    local recap = C_DeathRecap
    if not recap or not recap.GetRecapEvents then return nil, nil end
    local events = Ask(recap.GetRecapEvents)
    local blow = type(events) == "table" and events[1]
    if type(blow) ~= "table" then return nil, nil end
    local env = Text(blow.environmentalType)
    if env then return nil, env:upper() end
    return Text(blow.sourceName), nil
end

-- Quests: every one you turn in, by name.
local function QuestTitle(questID)
    if C_QuestLog and C_QuestLog.GetTitleForQuestID and questID then
        local title = Text(Ask(C_QuestLog.GetTitleForQuestID, questID))
        if title then return title end
    end
    return Text(Ask(GetTitleText))
end
local function QuestLevel(questID)
    if not (C_QuestLog and C_QuestLog.GetLogIndexForQuestID and C_QuestLog.GetInfo) then return nil end
    local index = Ask(C_QuestLog.GetLogIndexForQuestID, questID)
    local info = index and Ask(C_QuestLog.GetInfo, index)
    return type(info) == "table" and tonumber(info.level) or nil
end

-- Brought back: the offer, then alive again.
local offer

-- Caves and mines: going underground (a sub-zone with such a name), once per
-- stretch. Deaths and close calls also keep the sub-zone (sz).
local UNDERGROUND = {"Mine", "Mines", "Cave", "Caves", "Cavern", "Caverns", "Grotto", "Burrow", "Burrows", "Den", "Lair", "Tunnel",
    "Tunnels", "Hollow", "Pit", "Excavation", "Dig Site", "Crypt", "Crypts", "Catacombs", "Barrow", "Barrows", "Hive", "Warren"}
local function Underground(name)
    if not name then return false end
    for _, word in ipairs(UNDERGROUND) do
        if name:find("%f[%a]" .. word .. "%f[%A]") then return true end
    end
    return false
end
local function SubZone() return Text(Ask(GetSubZoneText)) end
-- A line of this kind already in the open stretch (the journal's own entries after
-- the stretch's play line): what a /reload forgets, the journal still knows, so a
-- town, a plaque or a trainer visit is not written a second time after one.
local function InStretch(kind, field, value)
    local journal = stretch and Journal()
    if not journal then return nil end
    for i = #journal, 1, -1 do
        local entry = journal[i]
        if entry == stretch then return nil end
        if entry.k == kind and (field == nil or entry[field] == value) then return entry end
    end
    return nil
end
local underAt = setmetatable({}, {__mode = "k"})
local townAt = setmetatable({}, {__mode = "k"})
local function CheckTown()
    if not stretch then return end
    local words = A.SelfWords and A.SelfWords.towns
    if not words then return end
    local sub, zone = SubZone(), Zone()
    local name = (sub and words[sub] and sub) or (zone and words[zone] and zone) or nil
    if not name then return end
    local seen = townAt[stretch] or {}
    townAt[stretch] = seen
    if seen[name] then return end
    seen[name] = true
    if InStretch("town", "d", name) then return end
    Add({k = "town", d = name})
end
local function CheckUnderground()
    local sub = SubZone()
    if sub and LANDMARKS[sub] then First("landmark:" .. sub, {d = "landmark", z = sub, gate = LANDMARK_GATE[sub]}) end
    if not stretch or not Underground(sub) then return end
    local seen = underAt[stretch] or {}
    underAt[stretch] = seen
    if seen[sub] then return end
    seen[sub] = true
    if InStretch("cave", "d", sub) then return end
    Add({k = "cave", d = sub})
end
A.SelfUnderground = Underground

-- Gathering: mining, herbs and skinning, counted per stretch (one line per
-- kind: {k = "gather", d = "mining", c = count}), from your successful casts.
local GATHER_NAMES = {["Mining"] = "mining", ["Herb Gathering"] = "herbs", ["Herbalism"] = "herbs", ["Skinning"] = "skinning",
    ["Fishing"] = "fishing"}
local GATHER_IDS = {[2575] = "mining", [2576] = "mining", [3564] = "mining", [10248] = "mining",
    [2366] = "herbs", [2368] = "herbs", [3570] = "herbs", [11993] = "herbs",
    [8613] = "skinning", [8617] = "skinning", [8618] = "skinning", [10768] = "skinning",
    [7620] = "fishing", [7731] = "fishing", [7732] = "fishing", [18248] = "fishing"}
local function GatherKind(spellID)
    if type(spellID) ~= "number" then return nil end
    if GATHER_IDS[spellID] then return GATHER_IDS[spellID] end
    local name
    if C_Spell and C_Spell.GetSpellName then name = Text(Ask(C_Spell.GetSpellName, spellID))
    elseif GetSpellInfo then name = Text(Ask(GetSpellInfo, spellID)) end
    return name and GATHER_NAMES[name] or nil
end
local gathered = setmetatable({}, {__mode = "k"}) -- stretch -> kind -> entry
local lastGather -- {entry, t}: the loot that follows names what was gathered
local tally = setmetatable({}, {__mode = "k"}) -- entry -> name -> count
local function Gathered(kind)
    if not stretch then return end
    local lines = gathered[stretch] or {}
    gathered[stretch] = lines
    local entry = lines[kind]
    if entry then
        entry.c, entry.e = (entry.c or 1) + 1, Now()
    else
        entry = Add({k = "gather", d = kind, c = 1, sz = kind == "fishing" and SubZone() or nil})
        lines[kind] = entry
    end
    if entry then lastGather = {entry = entry, t = Now()} end
end
-- Names what was gathered: {k = "gather", ..., m = {"Kingsblood", "Liferoot"}} (most first, up to three).
local function GatheredName(name)
    local window = lastGather and lastGather.entry.d == "fishing" and 30 or 6 -- (a fish bites some time after the cast)
    if not lastGather or Now() - lastGather.t > window or type(name) ~= "string" or name == "" then return end
    local entry = lastGather.entry
    local counts = tally[entry] or {}
    tally[entry] = counts
    for _, n in ipairs(type(entry.m) == "table" and entry.m or {}) do counts[n] = counts[n] or 1 end
    counts[name] = (counts[name] or 0) + 1
    local names = {}
    for n in pairs(counts) do names[#names + 1] = n end
    table.sort(names, function(a, b) if counts[a] ~= counts[b] then return counts[a] > counts[b] end return a < b end)
    entry.m = {names[1], names[2], names[3]}
end
A.SelfGatheredName = GatheredName
A.SelfGatherKind = GatherKind

-- Crafting: while a profession window is open, each successful cast is
-- something you made. One line per profession and stretch:
-- {k = "craft", d = "Tailoring", c = count, m = {"Linen Cloak", ...}} (up to three names).
local profession -- the open window's profession, or false when none is open
local function ProfessionName()
    if C_TradeSkillUI and C_TradeSkillUI.GetBaseProfessionInfo then
        local info = Ask(C_TradeSkillUI.GetBaseProfessionInfo)
        if type(info) == "table" and Text(info.professionName) then return info.professionName end
    end
    if GetTradeSkillLine then
        local name = Text(Ask(GetTradeSkillLine))
        if name and name ~= "UNKNOWN" then return name end
    end
    if GetCraftDisplaySkillLine then
        local name = Text(Ask(GetCraftDisplaySkillLine))
        if name then return name end
    end
    return nil
end
local crafted = setmetatable({}, {__mode = "k"}) -- stretch -> profession -> entry
-- Casts made while a profession window is open that are not things made: opening the
-- window itself ("Smelting" opens Mining's) and the tracking spells (2026-11-07: "I
-- smelted two bars of smelting and find minerals" after opening Smelting and turning
-- on Find Minerals).
local NOT_MADE = {["Smelting"] = true, ["Find Minerals"] = true, ["Find Herbs"] = true, ["Find Treasure"] = true,
    ["Find Fish"] = true, ["Disenchant"] = true, ["Prospecting"] = true}
local function Crafted(spellID)
    if not stretch or not profession then return end
    local made
    if C_Spell and C_Spell.GetSpellName then made = Text(Ask(C_Spell.GetSpellName, spellID))
    elseif GetSpellInfo then made = Text(Ask(GetSpellInfo, spellID)) end
    if made and (made == profession or NOT_MADE[made]) then return end
    -- Where the client can say so, only a recipe of the open window counts.
    if C_TradeSkillUI and C_TradeSkillUI.GetRecipeInfo then
        local info = Ask(C_TradeSkillUI.GetRecipeInfo, spellID)
        if type(info) ~= "table" then return end
    end
    local lines = crafted[stretch] or {}
    crafted[stretch] = lines
    local entry = lines[profession]
    if not entry then
        entry = Add({k = "craft", d = profession, c = 0, m = {}})
        lines[profession] = entry
        if not entry then return end
    end
    entry.c, entry.e = (entry.c or 0) + 1, Now()
    entry.m = type(entry.m) == "table" and entry.m or {}
    if made and #entry.m < 3 then
        local known = false
        for _, name in ipairs(entry.m) do if name == made then known = true end end
        if not known then entry.m[#entry.m + 1] = made end
    end
    -- The first epic made by your own hands ("Record more moments"): the recipe's
    -- output item and its quality.
    if A.MoreMomentsOn() and C_TradeSkillUI and C_TradeSkillUI.GetRecipeOutputItemData then
        local output = Ask(C_TradeSkillUI.GetRecipeOutputItemData, spellID)
        local link = type(output) == "table" and (Text(output.hyperlink) or (Public(output.itemID) and tonumber(output.itemID))) or nil
        local name, quality = link and ItemInfo(link)
        if name and quality and quality >= 4 then First("craftepic", {d = "craftepic", z = name, n = profession}) end
    end
end

-- Close calls: your health under an eighth, and still alive twenty seconds
-- later. What you were fighting (your hostile target), else a fall or the
-- water. At most one every five minutes. (Silent where the game hides health.)
local CLOSE_SHARE, CLOSE_WAIT, CLOSE_GAP = 0.125, 20, 300
local lastClose, pendingClose = 0, nil
local closeFrame = CreateFrame("Frame")
local function CloseCall()
    local hp, max = Ask(UnitHealth, "player"), Ask(UnitHealthMax, "player")
    if type(hp) ~= "number" or type(max) ~= "number" or max <= 0 or hp <= 0 then return end
    if hp / max > CLOSE_SHARE or pendingClose or Now() - lastClose < CLOSE_GAP then return end
    local call = {t = Now(), z = InstanceName() or Zone(), boss = encounter, sz = SubZone()}
    if Ask(UnitCanAttack, "player", "target") == true and Ask(UnitIsDeadOrGhost, "target") ~= true then
        call.d = Text(Ask(UnitName, "target"))
        local rank = Text(Ask(UnitClassification, "target"))
        -- "a Kobold Tunneler"; a named foe, an elite or a player without "a"
        if call.d and Ask(UnitIsPlayer, "target") ~= true and (not rank or rank == "normal" or rank == "minus" or rank == "trivial") then call.a = true end
        -- one of the other side: kept as what they were, not their name
        if call.d and Ask(UnitIsPlayer, "target") == true then
            -- (a player of your own side you can attack is your duel partner: a duel
            -- ends at the last hit point, and nobody nearly died)
            local theirs, mine = Text(Ask(UnitFactionGroup, "target")), Text(Ask(UnitFactionGroup, "player"))
            if theirs and mine and theirs == mine then return end
            call.pr, call.pc = Text(Ask(UnitRace, "target")), Text(Ask(UnitClass, "target"))
            call.d = nil
        end
    elseif Ask(UnitAffectingCombat, "player") ~= true then
        call.env = Ask(IsSwimming) == true and "DROWNING" or "FALLING"
    end
    pendingClose = call
    C_Timer.After(CLOSE_WAIT, function()
        local done = pendingClose
        pendingClose = nil
        if not done or done.died or Ask(UnitIsDeadOrGhost, "player") == true then return end
        lastClose = Now()
        Add({k = "close", t = done.t, z = done.z, d = done.d, a = done.a, env = done.env, boss = done.boss, sz = done.sz, pr = done.pr, pc = done.pc})
    end)
end
closeFrame:SetScript("OnEvent", function() if A.SelfJournalOn() then CloseCall() end end)
A.SelfHealthCheck = function() if A.SelfJournalOn() then CloseCall() end end -- (the tests)

-- More moments (A.MoreMomentsOn) -------------------------------------------------------
local function Num(value) return Public(value) and tonumber(value) or nil end
-- A pattern from one of the game's own message strings ("Discovered: %s"), the
-- magic characters escaped, %s and %d caught; nil when the string is missing.
local function Pattern(key, capture)
    local s = _G[key]
    if type(s) ~= "string" then return nil end
    local escaped = s:gsub("([%(%)%.%+%-%*%?%[%]%^%$])", "%%%1")
    -- ("%1$s" becomes "%1%$s" once escaped: ordered placeholders, in message order)
    local order = {}
    for n in escaped:gmatch("%%(%d)%%%$s") do order[#order + 1] = tonumber(n) end
    -- (an ordered number, "%1$d", becomes a plain "%d" first: left as "%1" it is a
    -- back-reference, and match errors on every message)
    local body = escaped:gsub("%%%d%%%$s", capture or "(.-)"):gsub("%%%d%%%$d", "%%d"):gsub("%%s", capture or "(.-)"):gsub("%%d", "%%d+")
    return "^" .. body .. "$", order
end
-- Books, letters and plaques: the title of the text you open, once per
-- stretch ({k = "read", d = title, m = "parchment" | "stone" | "bronze" ...}).
local readAt = setmetatable({}, {__mode = "k"})
local function ReadText()
    if not stretch then return end
    local title = Text(Ask(ItemTextGetItem))
    if not title then return end
    local seen = readAt[stretch] or {}
    readAt[stretch] = seen
    if seen[title] then return end
    seen[title] = true
    if InStretch("read", "d", title) then return end
    local material = Text(Ask(ItemTextGetMaterial))
    Add({k = "read", d = title, m = material and material:lower() or nil})
end
-- A message as the game printed it, without colour codes ("|cffffff00...|r")
-- and with a link ("|Hplayer:Mira|h[Mira]|h") reduced to its text.
local function Plain(message)
    if type(message) ~= "string" or not Public(message) then return nil end
    return (message:gsub("|c%x%x%x%x%x%x%x%x", ""):gsub("|r", ""):gsub("|H[^|]*|h%[?(.-)%]?|h", "%1"))
end
-- Spells bought from a trainer, one line per stretch ({k = "learn", c = count, m = {up to three names}}).
-- A purchase comes as LEARNED_SPELL_IN_SKILL_LINE and as the game's "You have
-- learned a new spell" message (the yellow one, and its echo in chat): the same
-- name within a breath is one purchase, whichever of them arrives, or all three.
local trainerOpen = false
local learned = setmetatable({}, {__mode = "k"})
local recentLearn = {}
local function Learned(spellID, spellName)
    if not stretch or not trainerOpen then return end
    local name = spellName
    if not name then
        if not Public(spellID) then return end
        name = (C_Spell and C_Spell.GetSpellName and Text(Ask(C_Spell.GetSpellName, spellID))) or (GetSpellInfo and Text(Ask(GetSpellInfo, spellID)))
    end
    if name then
        -- (the event comes first and always counts; a message within a breath of
        -- it, or of another message with the same name, is the same purchase)
        if spellName and recentLearn[name] and Now() - recentLearn[name] <= 3 then return end
        recentLearn[name] = Now()
    end
    local entry = learned[stretch] or InStretch("learn")
    if not entry then
        entry = Add({k = "learn", c = 0, m = {}})
        if not entry then return end
    end
    learned[stretch] = entry
    entry.c, entry.e = (entry.c or 0) + 1, Now()
    entry.m = type(entry.m) == "table" and entry.m or {}
    if name and #entry.m < 3 then
        local known = false
        for _, n in ipairs(entry.m) do if n == name then known = true end end
        if not known then entry.m[#entry.m + 1] = name end
    end
end
-- Areas discovered and flight paths learned come through the game's own info
-- messages; the type is named by GetGameMessageInfo, the area by the message.
-- Without a type name (the function missing, or failing on the value, or the
-- message arriving through chat) the message itself is held against the game's
-- strings, and anything else is let be. An echo of a message already kept in
-- this stretch writes nothing.
local explorePatterns, learnPatterns
local function InfoMessage(errorType, message)
    local name = Public(errorType) and GetGameMessageInfo and Text(Ask(GetGameMessageInfo, errorType)) or nil
    local text = Plain(message) or (name == nil and Plain(errorType)) or nil
    if explorePatterns == nil then
        explorePatterns, learnPatterns = {}, {}
        for _, key in ipairs({"ERR_ZONE_EXPLORED_XP", "ERR_ZONE_EXPLORED"}) do
            local pattern = Pattern(key)
            if pattern then explorePatterns[#explorePatterns + 1] = pattern end
        end
        for _, key in ipairs({"ERR_LEARN_SPELL_S", "ERR_LEARN_ABILITY_S"}) do
            local pattern = Pattern(key)
            if pattern then learnPatterns[#learnPatterns + 1] = pattern end
        end
    end
    local area, spell
    if text then
        for _, pattern in ipairs(explorePatterns) do area = area or text:match(pattern) end
        for _, pattern in ipairs(learnPatterns) do spell = spell or text:match(pattern) end
    end
    if name == "ERR_NEWTAXIPATH" or (name == nil and text and type(ERR_NEWTAXIPATH) == "string" and text == ERR_NEWTAXIPATH) then
        local place = SubZone() or Zone()
        if place and not InStretch("taxi", "d", place) then Add({k = "taxi", d = place}) end
    elseif name == "ERR_ZONE_EXPLORED" or name == "ERR_ZONE_EXPLORED_XP" or (name == nil and area) then
        area = Text(area) or SubZone() or Zone()
        if area and not InStretch("explore", "d", area) then Add({k = "explore", d = area}) end
    elseif Text(spell) and (name == nil or name == "ERR_LEARN_SPELL_S" or name == "ERR_LEARN_ABILITY_S") then
        Learned(nil, spell)
    end
end
A.SelfInfoMessage = InfoMessage
-- A standing reached with a faction (friendly 5, honored 6, revered 7, exalted 8):
-- the standings are kept on the character; the first look only seeds them.
local STANDINGS = {[5] = "friendly", [6] = "honored", [7] = "revered", [8] = "exalted"}
A.SelfStandings = STANDINGS
local repQueued = false
-- (only a standing already read this session counts as "before": the first look after
-- a login, a /reload or turning the setting on only seeds, so a standing reached while
-- the setting was off is never told as reached today)
local repRead, skillRead = {}, {}
local function ScanReputation()
    repQueued = false
    if not A.MoreMomentsOn() then return end
    local mine = A.MyCharacter and A.MyCharacter(true)
    local rep = C_Reputation
    if type(mine) ~= "table" or not rep or not rep.GetNumFactions or not rep.GetFactionDataByIndex then return end
    mine.rep = type(mine.rep) == "table" and mine.rep or {}
    for i = 1, Num(Ask(rep.GetNumFactions)) or 0 do
        local data = Ask(rep.GetFactionDataByIndex, i)
        if type(data) == "table" and (not data.isHeader or data.isHeaderWithRep) then
            local name, reaction = Text(data.name), Num(data.reaction)
            if name and reaction then
                local before = repRead[name] and mine.rep[name]
                if before and reaction > before and STANDINGS[reaction] then Add({k = "rep", d = name, s = reaction}) end
                mine.rep[name], repRead[name] = reaction, true
            end
        end
    end
end
A.SelfScanReputation = ScanReputation
-- A duel's end comes as a system message naming both duellists; yours are kept
-- ({k = "duel", d = the other, w = "won" | "lost", fled = they or you left the ring}).
local duelPatterns
local function DuelMessage(message)
    if duelPatterns == nil then
        duelPatterns = {}
        for _, key in ipairs({"DUEL_WINNER_KNOCKOUT", "DUEL_WINNER_RETREAT"}) do
            local pattern, order = Pattern(key)
            if pattern then duelPatterns[#duelPatterns + 1] = {pattern = pattern, order = order, fled = key == "DUEL_WINNER_RETREAT"} end
        end
    end
    local me = Text(Ask(UnitName, "player"))
    message = Plain(message)
    if not me or not message then return false end
    for _, dp in ipairs(duelPatterns) do
        local a, b = message:match(dp.pattern)
        if a and b then
            local args = {}
            if #dp.order == 2 then args[dp.order[1]], args[dp.order[2]] = a, b else args[1], args[2] = a, b end
            local winner, loser = (args[1] or ""):gsub("%-.*$", ""), (args[2] or ""):gsub("%-.*$", "")
            if winner == me and loser ~= "" then Add({k = "duel", d = loser, w = "won", fled = dp.fled or nil})
            elseif loser == me and winner ~= "" then Add({k = "duel", d = winner, w = "lost", fled = dp.fled or nil}) end
            return true
        end
    end
    return false
end
-- Trade skills crossing 75, 150, 225 and 300 (the ranks a trainer teaches past).
local TRADES = {Alchemy = true, Blacksmithing = true, Enchanting = true, Engineering = true, Herbalism = true, Leatherworking = true,
    Mining = true, Skinning = true, Tailoring = true, Cooking = true, ["First Aid"] = true, Fishing = true}
local SKILL_MARKS = {75, 150, 225, 300}
local skillQueued = false
local function ScanSkills()
    skillQueued = false
    if not A.MoreMomentsOn() then return end
    local mine = A.MyCharacter and A.MyCharacter(true)
    local info = C_SkillInfo
    if type(mine) ~= "table" or not info or not info.GetNumSkillLines or not info.GetSkillLineInfo then return end
    mine.skills = type(mine.skills) == "table" and mine.skills or {}
    for i = 1, Num(Ask(info.GetNumSkillLines)) or 0 do
        local line = Ask(info.GetSkillLineInfo, i)
        if type(line) == "table" and not line.isHeader then
            local name, rank = Text(line.name), Num(line.rank)
            if name and rank and TRADES[name] then
                local before = skillRead[name] and mine.skills[name]
                if before and rank > before then
                    for _, mark in ipairs(SKILL_MARKS) do
                        if before < mark and rank >= mark then Add({k = "skill", d = name, c = mark}) end
                    end
                end
                mine.skills[name], skillRead[name] = rank, true
            end
        end
    end
end
A.SelfScanSkills = ScanSkills
-- Honorable kills in the open world, counted per stretch ({k = "hk", c = n}).
local lastHK
local hkAt = setmetatable({}, {__mode = "k"})
local function SeedHonor()
    if GetPVPSessionStats then lastHK = Num((Ask(GetPVPSessionStats))) end
end
local function HonorChanged()
    if not GetPVPSessionStats then return end
    local hk = Num((Ask(GetPVPSessionStats)))
    if not hk then return end
    local gained = lastHK and (hk >= lastHK and hk - lastHK or hk) or 0
    lastHK = hk
    if gained <= 0 or not stretch then return end
    local okInst, _, kind = pcall(IsInInstance or function() return false end)
    if okInst and kind == "pvp" then return end
    local entry = hkAt[stretch] or InStretch("hk")
    if entry then entry.c, entry.e = (entry.c or 0) + gained, Now()
    else entry = Add({k = "hk", c = gained}) end
    hkAt[stretch] = entry
end
-- A rare creature you targeted and fought, dead ({k = "rarekill", d = name, sz = zone}):
-- watched only while one is targeted (UNIT_HEALTH for "target" alone), and let go after ten minutes.
local rareWatch
local rareFrame = CreateFrame("Frame")
local lastCombatEnd = 0
local function RareUnwatch()
    rareWatch = nil
    pcall(rareFrame.UnregisterEvent, rareFrame, "UNIT_HEALTH")
end
local function RareTargeted()
    -- (a new target that is not a living rare lets the watch go: otherwise UNIT_HEALTH
    -- stays registered for whatever is targeted next, for up to ten minutes)
    local rank = Text(Ask(UnitClassification, "target"))
    if rank ~= "rare" and rank ~= "rareelite" then if rareWatch then RareUnwatch() end return end
    local name = Text(Ask(UnitName, "target"))
    if not name or Ask(UnitCanAttack, "player", "target") ~= true or Ask(UnitIsDeadOrGhost, "target") == true then
        if rareWatch then RareUnwatch() end
        return
    end
    rareWatch = {name = name, t = Now(), zone = Zone()}
    if rareFrame.RegisterUnitEvent then pcall(rareFrame.RegisterUnitEvent, rareFrame, "UNIT_HEALTH", "target") end
end
local function RareHealth()
    local watch = rareWatch
    if not watch or not A.MoreMomentsOn() then return RareUnwatch() end
    if Now() - watch.t > 600 then return RareUnwatch() end
    if Text(Ask(UnitName, "target")) ~= watch.name or Ask(UnitIsDeadOrGhost, "target") ~= true then return end
    RareUnwatch()
    if Ask(UnitAffectingCombat, "player") == true or Now() - lastCombatEnd <= 5 then
        -- (each rare once a life; no "first" claim, a kill is a kill)
        local firsts = Firsts()
        if firsts and not firsts["rarekill:" .. watch.name] then
            firsts["rarekill:" .. watch.name] = Now()
            Add({k = "rarekill", d = watch.name, sz = watch.zone})
        end
    end
end
rareFrame:SetScript("OnEvent", RareHealth)
A.SelfRareHealth = RareHealth -- (the tests)
-- Gold: the first gold piece, the first hundred, the first thousand ({k = "first",
-- d = "gold", c = 1 | 100 | 1000}). The purse is compared only with a value seen
-- this session: the first look after a login, a /reload or turning the setting
-- on only seeds, so a purse already past a mark never "reaches" it. Each mark
-- is a first once a life (spending below it and earning it back is nothing).
local GOLD_MARKS = {{1, 5}, {100, 20}, {1000, 40}} -- gold, and the level from which the first is sure
local moneySeen
local function MoneyChanged()
    local now = Num(Ask(GetMoney))
    if not now then return end
    local before = moneySeen
    moneySeen = now
    if not before or now <= before then return end
    for _, mark in ipairs(GOLD_MARKS) do
        local copper = mark[1] * 10000
        if before < copper and now >= copper then First("gold:" .. mark[1], {d = "gold", c = mark[1], gate = mark[2]}) end
    end
end
A.SelfMoneyChanged = MoneyChanged -- (the tests)
-- The first talent point to spend, at level ten: the game's own event, confirmed
-- by its own reader (a point already earned before the journal began is not told).
local function TalentEarned()
    local info = C_SpecializationInfo
    if not info or type(info.HasPlayerEarnedATalentPoint) ~= "function" then return end
    if Ask(info.HasPlayerEarnedATalentPoint) == true and (tonumber(Ask(UnitLevel, "player")) or 0) >= 10 then First("talent", {d = "talent"}) end
end
-- A PvP rank reached ({k = "rank", d = title, c = rank, n = lifetime honorable kills}):
-- the rank frame's own reader (C_MajorFactions, faction 2800), the title from
-- UnitPVPName (read through Public), else the game's PVP_RANK_<n>_<side> string.
-- Only a rank above one seen this session counts; the first look seeds.
local PVP_RANK_FACTION = 2800
local rankSeen
local function RankTitle(rank)
    local full, me = Text(Ask(UnitPVPName, "player")), Text(Ask(UnitName, "player"))
    if full and me and full ~= me then
        local title = full:gsub("%s*" .. me:gsub("%p", "%%%0") .. "%s*$", "")
        if title ~= "" and title ~= full then return title end
    end
    local base = Enum and type(Enum.PvPRanks) == "table" and tonumber(Enum.PvPRanks.Rank_1)
    local side = A.PlayerFaction and A.PlayerFaction() == "Horde" and 1 or 0
    local key = base and ("PVP_RANK_" .. (base + rank - 1) .. "_" .. side)
    if not key then return nil end
    if type(GetText) == "function" then
        local s = Text(Ask(GetText, key))
        if s then return s end
    end
    return Text(_G[key])
end
local function RankChanged()
    local mf = C_MajorFactions
    if not mf or type(mf.GetMajorFactionProgressionInfo) ~= "function" then return end
    local info = Ask(mf.GetMajorFactionProgressionInfo, PVP_RANK_FACTION)
    local rank = type(info) == "table" and Num(info.renownLevel) or nil
    if not rank then return end
    local before = rankSeen
    rankSeen = rank
    if before == nil or rank <= before then return end
    local title = RankTitle(rank)
    if not title then return end
    Add({k = "rank", d = title, c = rank, n = GetPVPLifetimeStats and Num((Ask(GetPVPLifetimeStats))) or nil})
end
A.SelfRankChanged = RankChanged -- (the tests)
-- A battleground match at its end screen (PVP_MATCH_COMPLETE): the result, the
-- length, my own score line, the battleground's own marks (flags, bases, towers,
-- graveyards) and listed people on my side, written onto the `bg` entry that
-- entering the match began ({r = "won"|"lost"|"draw", dur = seconds, kb, hk, dt,
-- hon, m = {fc, fr, ba, bd, ga, gd, ta, td, mc}, top = true, c = {names}}).
-- Score lines are secret while a match runs (SecretInActivePvPMatch); they are
-- read only after the end, through Num, and a field is kept only when it came
-- back public. A match left early keeps the plain entry.
local FACTION_INDEX = {Horde = 0, Alliance = 1}
local function MySide()
    local mine = Num((Ask(GetBattlefieldArenaFaction)))
    if mine == nil then
        local group = Text((Ask(UnitFactionGroup, "player")))
        mine = group and FACTION_INDEX[group] or nil
    end
    return mine
end
local function OpenMatch()
    local journal = Journal()
    if not journal or not inside then return nil end
    for i = #journal, math.max(1, #journal - 40), -1 do
        local entry = journal[i]
        if entry.k == "bg" and entry.d == inside and not entry.r and Now() - (entry.t or 0) < 3 * 3600 then return entry end
    end
    return nil
end
local function ShortName(name)
    name = Text(name)
    return name and (name:gsub("%-.*$", "")) or nil
end
local function ScoreLine(index)
    local fn = C_PvP and C_PvP.GetScoreInfo
    if type(fn) ~= "function" then return nil end
    local ok, info = pcall(fn, index)
    return ok and type(info) == "table" and info or nil
end
local function ScoreCount() return math.min(Num((Ask(GetNumBattlefieldScores))) or 0, 80) end
local function MyScoreLine()
    local guid = Ask(GetPlayerGuid) or Ask(UnitGUID, "player")
    local byGuid = C_PvP and C_PvP.GetScoreInfoByPlayerGuid
    if guid and type(byGuid) == "function" then
        local ok, info = pcall(byGuid, guid)
        if ok and type(info) == "table" then return info end
    end
    local me = ShortName(Ask(UnitName, "player"))
    for i = 1, ScoreCount() do
        local info = ScoreLine(i)
        if info and me and ShortName(info.name) == me then return info end
    end
    return nil
end
-- The battleground's own columns, by the words in their names (the ids are not documented).
local STAT_KEYS = {{"flag", "captur", "fc"}, {"flag", "return", "fr"}, {"base", "assault", "ba"}, {"base", "defend", "bd"},
    {"graveyard", "assault", "ga"}, {"graveyard", "defend", "gd"}, {"tower", "assault", "ta"}, {"tower", "destroy", "ta"},
    {"tower", "defend", "td"}, {"mine", "captur", "mc"}}
local matchScanned = setmetatable({}, {__mode = "k"})
local function ReadMatch(entry)
    if not entry then return end
    local info = MyScoreLine()
    if info then
        for field, key in pairs({killingBlows = "kb", honorableKills = "hk", deaths = "dt", honorGained = "hon"}) do
            if entry[key] == nil then entry[key] = Num(info[field]) end
        end
        if entry.m == nil and type(info.stats) == "table" then
            local marks, any = {}, false
            for _, stat in ipairs(info.stats) do
                local name = type(stat) == "table" and Text(stat.name)
                local value = name and Num(stat.pvpStatValue)
                if value and value > 0 then
                    local low = name:lower()
                    for _, k in ipairs(STAT_KEYS) do
                        if low:find(k[1], 1, true) and low:find(k[2], 1, true) then marks[k[3]] = (marks[k[3]] or 0) + value; any = true; break end
                    end
                end
            end
            if any then entry.m = marks end
        end
    end
    -- The other lines on my side: the most killing blows, and listed people in the match.
    if matchScanned[entry] then return end
    local mine, me = MySide(), ShortName(Ask(UnitName, "player"))
    if mine == nil then return end
    local best, allPublic, mates = 0, true, {}
    for i = 1, ScoreCount() do
        local line = ScoreLine(i)
        local name = line and ShortName(line.name)
        if name and Num(line.faction) == mine and name ~= me then
            local kb = Num(line.killingBlows)
            if kb == nil then allPublic = false elseif kb > best then best = kb end
            local key = A.PersonKey and A.PersonKey(Text(line.name))
            local person = key and A.People and A.People[key]
            if person and not person.npc and not withOpen[key] and #mates < 4 then mates[#mates + 1] = Text(person.name) or name end
        end
    end
    if #mates > 0 then entry.c = mates end
    if allPublic and entry.kb and entry.kb > best then entry.top = true end
    matchScanned[entry] = allPublic or nil
end
local function MatchComplete(winner, duration)
    local entry = OpenMatch()
    if not entry then return end
    local mine = MySide()
    winner = Num(winner)
    if winner == nil then winner = Num((Ask(C_PvP and C_PvP.GetActiveMatchWinner))) end
    if mine ~= nil and winner ~= nil then
        entry.r = (winner == mine and "won") or (winner == (mine + 1) % 2 and "lost") or "draw"
    end
    local seconds = Num(duration) or Num((Ask(C_PvP and C_PvP.GetActiveMatchDuration)))
    if seconds and seconds > 0 then entry.dur = math.floor(seconds) end
    pcall(RequestBattlefieldScoreData or function() end)
    if C_Timer and C_Timer.After then
        C_Timer.After(1.5, function() ReadMatch(entry) end)
        C_Timer.After(6, function() ReadMatch(entry) end)
    else
        ReadMatch(entry)
    end
end
A.SelfMatchComplete = MatchComplete -- (the tests)
local MORE_EVENTS = {"ITEM_TEXT_BEGIN", "UI_INFO_MESSAGE", "LEARNED_SPELL_IN_SKILL_LINE", "TRAINER_SHOW", "TRAINER_CLOSED", "UPDATE_FACTION",
    "SKILL_LINES_CHANGED", "PLAYER_REGEN_ENABLED", "PLAYER_MONEY", "CHARACTER_POINTS_CHANGED", "PLAYER_PVP_RANK_CHANGED",
    "MAJOR_FACTION_RENOWN_LEVEL_CHANGED", "PVP_MATCH_COMPLETE"}
-- What the more-moments recorder does with an event (its own function: the main
-- handler below is at Lua 5.1's limit of upvalues).
local function MoreEvent(event, ...)
    if event == "PLAYER_ENTERING_WORLD" then
        SeedHonor()
        -- (a /reload at a battleground's end screen: the match is still complete)
        if Ask(C_PvP and C_PvP.IsMatchComplete) == true then C_Timer.After(3, function() MatchComplete() end) end
        moneySeen, rankSeen = nil, nil
        -- (the standings, skills, purse and rank are seeded once the game has filled them in)
        C_Timer.After(20, function() ScanReputation(); ScanSkills(); MoneyChanged(); RankChanged() end)
    elseif event == "PLAYER_MONEY" then
        MoneyChanged()
    elseif event == "CHARACTER_POINTS_CHANGED" then
        TalentEarned()
    elseif event == "PLAYER_PVP_RANK_CHANGED" or event == "MAJOR_FACTION_RENOWN_LEVEL_CHANGED" then
        local arg = ...
        if (event == "PLAYER_PVP_RANK_CHANGED" and (arg == "player" or arg == nil)) or (event == "MAJOR_FACTION_RENOWN_LEVEL_CHANGED" and Num(arg) == PVP_RANK_FACTION) then
            C_Timer.After(1, RankChanged)
        end
    elseif event == "CHAT_MSG_SYSTEM" then
        -- (a duel's end; or a discovery, a flight path or a trainer's spell that
        -- reached chat alone, in the game's own words)
        local message = ...
        if type(message) == "string" and Public(message) and not DuelMessage(message) then InfoMessage(nil, message) end
    elseif event == "PLAYER_TARGET_CHANGED" then
        RareTargeted()
    elseif event == "PLAYER_PVP_KILLS_CHANGED" then
        HonorChanged()
    elseif event == "ITEM_TEXT_BEGIN" then
        ReadText()
    elseif event == "UI_INFO_MESSAGE" then
        InfoMessage(...)
    elseif event == "LEARNED_SPELL_IN_SKILL_LINE" then
        Learned((...))
    elseif event == "TRAINER_SHOW" or event == "TRAINER_CLOSED" then
        trainerOpen = event == "TRAINER_SHOW"
    elseif event == "UPDATE_FACTION" then
        if not repQueued then repQueued = true; C_Timer.After(2, ScanReputation) end
    elseif event == "SKILL_LINES_CHANGED" then
        if not skillQueued then skillQueued = true; C_Timer.After(2, ScanSkills) end
    elseif event == "PVP_MATCH_COMPLETE" then
        MatchComplete(...)
    elseif event == "PLAYER_REGEN_ENABLED" then
        lastCombatEnd = Now()
    end
end

local events = CreateFrame("Frame")
local EVENTS = {"PLAYER_ENTERING_WORLD", "ZONE_CHANGED_NEW_AREA", "ZONE_CHANGED", "ZONE_CHANGED_INDOORS", "PLAYER_LOGOUT", "QUEST_TURNED_IN", "ENCOUNTER_START",
    "ENCOUNTER_END", "PLAYER_CONTROL_LOST", "PLAYER_PVP_KILLS_CHANGED", "CHAT_MSG_LOOT", "PLAYER_EQUIPMENT_CHANGED",
    "PLAYER_MOUNT_DISPLAY_CHANGED", "UNIT_SPELLCAST_SUCCEEDED", "TRADE_SKILL_SHOW", "TRADE_SKILL_CLOSE", "CRAFT_SHOW", "CRAFT_CLOSE", "PLAYER_DEAD", "PLAYER_LEVEL_UP", "PLAYER_UPDATE_RESTING", "RESURRECT_REQUEST", "PLAYER_ALIVE", "PLAYER_UNGHOST",
    "PLAYER_TARGET_CHANGED", "UPDATE_MOUSEOVER_UNIT", "PLAYER_GUILD_UPDATE", "HEARTHSTONE_BOUND", "SPELLS_CHANGED", "UNIT_PET",
    "CHAT_MSG_SYSTEM", "GOSSIP_SHOW", "QUEST_DETAIL"}
-- A named figure must actually be seen or spoken to. Visiting their city is
-- not evidence of meeting them. Keep a sighting and, at most, one conversation.
local function NotableNPC(unit, interaction)
    if Ask(UnitIsPlayer, unit) == true or Ask(UnitIsDeadOrGhost, unit) == true then return end
    local name = Text(Ask(UnitName, unit))
    local known = A.SelfWords and A.SelfWords.notableNPCs
    if not name or not known or not known[name] then return end
    local firsts = Firsts()
    if not firsts then return end
    local seenKey, talkKey = "notable:" .. name, "notableTalk:" .. name
    if interaction and firsts[talkKey] then return end
    if interaction and firsts[seenKey] then
        -- Targeting someone normally precedes opening their dialogue. Upgrade
        -- that recent sighting; an older encounter keeps its original facts.
        local journal = Journal() or {}
        for i = #journal, 1, -1 do
            local entry = journal[i]
            if (entry.t or 0) < Now() - 120 then break end
            if entry.k == "first" and entry.d == "notable" and entry.n == name and entry.z == Zone() then
                entry.interaction, entry.t = true, Now()
                firsts[talkKey] = Now()
                if A.RefreshJournal then A.RefreshJournal() end
                return
            end
        end
        First(talkKey, {d = "notable", n = name, z = Zone(), interaction = true, gate = 1})
    elseif not firsts[seenKey] then
        First(seenKey, {d = "notable", n = name, z = Zone(), interaction = interaction or nil, gate = 1})
        if interaction then firsts[talkKey] = Now() end
    end
end
-- The other side, the first time you see one of them (a player of the enemy faction).
local function RareSeen(unit)
    local rank = Text(Ask(UnitClassification, unit))
    if rank ~= "rare" and rank ~= "rareelite" then return end
    local name = Text(Ask(UnitName, unit))
    if name and Ask(UnitIsDeadOrGhost, unit) ~= true then First("rarebeast:" .. name, {d = "rarebeast", z = name, sz = Zone()}) end
end
local function FoeSeen(unit)
    RareSeen(unit)
    if Ask(UnitIsPlayer, unit) ~= true then return end
    local theirs, mine = Text(Ask(UnitFactionGroup, unit)), Text(Ask(UnitFactionGroup, "player"))
    if not theirs or not mine or theirs == mine or (theirs ~= "Horde" and theirs ~= "Alliance") then return end
    local firsts = Firsts()
    if not firsts or firsts.foeseen then return end
    First("foeseen", {d = "foeseen", z = Zone(), n = Text(Ask(UnitRace, unit)), c = Text(Ask(UnitClass, unit))})
end
-- Your guild and your hearthstone: kept on the character, told when they change
-- (not at login, when the game is still filling them in).
local settledAt = 0
local function CheckGuild()
    local mine = A.MyCharacter and A.MyCharacter(true)
    if type(mine) ~= "table" or not GetGuildInfo then return end
    local name = Text(Ask(GetGuildInfo, "player"))
    if Now() - settledAt < 30 or mine.guild == nil then
        if name then mine.guild = name elseif Now() - settledAt >= 30 then mine.guild = false end
        return
    end
    if name and name ~= mine.guild then Add({k = "guild", d = name}) end
    mine.guild = name or false
end
local function CheckHome()
    local mine = A.MyCharacter and A.MyCharacter(true)
    if type(mine) ~= "table" or not GetBindLocation then return end
    local home = Text(Ask(GetBindLocation))
    if not home then return end
    if mine.home and mine.home ~= home then Add({k = "home", d = home}) end
    mine.home = home
end
A.SelfCheckGuild, A.SelfCheckHome = CheckGuild, CheckHome
-- Class milestones from the spells you know.
local function CheckSpells()
    local known = IsPlayerSpell or IsSpellKnown
    if not known then return end
    for id, info in pairs(CLASS_SPELLS) do
        if Ask(known, id) == true then First("class:" .. info[1], {d = "class", z = info[1], gate = info[2]}) end
    end
end
A.SelfCheckSpells = CheckSpells
local restedAt = setmetatable({}, {__mode = "k"})
local auctionPattern -- (the auction-sold message as a pattern, built on first use)
events:SetScript("OnEvent", function(_, event, ...)
    if not A.SelfJournalOn() then return end
    if A.MoreMomentsOn() then MoreEvent(event, ...) end
    if event == "PLAYER_ENTERING_WORLD" or event == "ZONE_CHANGED_NEW_AREA" then
        if event == "PLAYER_ENTERING_WORLD" then
            Settle()
            settledAt = Now()
            C_Timer.After(35, function() if A.SelfJournalOn() then CheckGuild(); CheckHome() end end)
        end
        Open()
        CheckInstance()
        CheckUnderground()
        CheckTown()
    elseif event == "ZONE_CHANGED" or event == "ZONE_CHANGED_INDOORS" then
        CheckUnderground()
        CheckTown()
    elseif event == "PLAYER_LOGOUT" then
        if Ask(IsResting) == true and stretch then Add({k = "sleep", d = SubZone() or Zone()}) end
        -- (a /reload too: the stretch goes on when you are back in the same zone)
        if stretch then stretch.u = Now(); stretch.e = stretch.u end
        stretch = nil
        for key, entry in pairs(withOpen) do entry.e = Now(); withOpen[key] = nil end
    elseif event == "QUEST_TURNED_IN" then
        local questID = ...
        if not Public(questID) then return end
        local title = QuestTitle(questID)
        if title then Add({k = "quest", d = title, qid = type(questID) == "number" and questID or nil, ql = QuestLevel(questID)}) end
    elseif event == "CHAT_MSG_SYSTEM" then
        local message = ...
        if type(message) ~= "string" or not Public(message) then return end
        -- ("A buyer has been found for your auction of %s.": the magic characters escaped, then %s caught; built once)
        if auctionPattern == nil then
            auctionPattern = type(ERR_AUCTION_SOLD_S) == "string"
                and ("^" .. ERR_AUCTION_SOLD_S:gsub("([%(%)%.%+%-%*%?%[%]%^%$])", "%%%1"):gsub("%%s", "(.+)") .. "$") or false
        end
        local item = auctionPattern and message:match(auctionPattern)
        if item then First("aucsale", {d = "aucsale", z = item}) end
    elseif event == "PLAYER_TARGET_CHANGED" then
        FoeSeen("target")
        NotableNPC("target")
    elseif event == "GOSSIP_SHOW" or event == "QUEST_DETAIL" then
        NotableNPC("npc", true)
    elseif event == "UPDATE_MOUSEOVER_UNIT" then
        FoeSeen("mouseover")
    elseif event == "PLAYER_GUILD_UPDATE" then
        CheckGuild()
    elseif event == "HEARTHSTONE_BOUND" then
        CheckHome()
    elseif event == "SPELLS_CHANGED" then
        CheckSpells()
    elseif event == "UNIT_PET" then
        -- a hunter's first pet
        local unit = ...
        local _, class = Ask(UnitClass, "player")
        if unit == "player" and class == "HUNTER" and Ask(UnitExists, "pet") == true then
            First("class:pet", {d = "class", z = "pet", gate = 10, n = Text(Ask(UnitCreatureFamily, "pet"))})
        end
    elseif event == "PLAYER_CONTROL_LOST" then
        -- A flight path takes over: your first flight.
        C_Timer.After(1, function()
            if Ask(UnitOnTaxi, "player") ~= true then return end
            First("flight", {d = "flight"})
            local hour = Ask(GetGameTime)
            if type(hour) == "number" and (hour >= 21 or hour < 5) then Add({k = "nightflight"}) end
        end)
    elseif event == "UNIT_SPELLCAST_SUCCEEDED" then
        local unit, _, spellID = ...
        if unit ~= "player" or not Public(spellID) then return end
        local kind = GatherKind(spellID)
        if kind then Gathered(kind) elseif profession then Crafted(spellID) end
        -- A hearthstone or a portal: a crossing right after it is not a voyage by sea.
        local spellName = (C_Spell and C_Spell.GetSpellName and Text(Ask(C_Spell.GetSpellName, spellID))) or (GetSpellInfo and Text(Ask(GetSpellInfo, spellID)))
        if spellName and REZ_SPELLS[spellName] then First("rezother", {d = "rezother", n = Text(Ask(UnitName, "target"))}) end
        if spellID == 8690 or spellName == "Hearthstone" then
            travelSpell = {how = "hearth", t = Now()}
            Add({k = "hearth", d = Text(Ask(GetBindLocation))})
        elseif spellName and (spellName:find("^Portal:") or spellName:find("^Teleport:")) then travelSpell = {how = "portal", t = Now()} end
    elseif event == "TRADE_SKILL_SHOW" or event == "CRAFT_SHOW" then
        profession = ProfessionName() or "crafting"
    elseif event == "TRADE_SKILL_CLOSE" or event == "CRAFT_CLOSE" then
        profession = nil
    elseif event == "ENCOUNTER_START" then
        local _, name = ...
        encounter, fallen = Text(name), false
    elseif event == "ENCOUNTER_END" then
        local _, name, _, _, success = ...
        if not Public(success) then return end
        local fight, where = Text(name) or encounter, InstanceName() or Zone()
        if success == 1 and fight and WORLD_BOSSES[fight] then First("worldboss", {d = "worldboss", z = fight}) end
        if success == 1 and fight then
            local entry = Add({k = "boss", d = fight, z = where, cost = fallen or nil})
            if A.JournalMeterInto then A.JournalMeterInto(entry) end
        elseif fallen and fight then
            Add({k = "wipe", d = fight, z = where})
        end
        encounter, fallen = nil, false
    elseif event == "PLAYER_DEAD" then
        diedAt = Now()
        if pendingClose then pendingClose.died = true end
        if encounter then fallen = true end
        local boss, where = encounter, InstanceName() or Zone()
        C_Timer.After(1, function()
            local killer, env = DeathCause()
            -- "a Kobold Tunneler": an ordinary foe you had targeted gets its article.
            local article, race, class
            if killer and Text(Ask(UnitName, "target")) == killer and Ask(UnitIsPlayer, "target") ~= true then
                local rank = Text(Ask(UnitClassification, "target"))
                article = (not rank or rank == "normal" or rank == "minus" or rank == "trivial") or nil
            elseif killer and Text(Ask(UnitName, "target")) == killer and Ask(UnitIsPlayer, "target") == true then
                -- one of the other side: kept as what they were, not their name
                race, class = Text(Ask(UnitRace, "target")), Text(Ask(UnitClass, "target"))
            end
            Add({k = "death", w = "you", d = (race or class) and nil or killer, a = article, env = env, boss = boss, z = where, sz = SubZone(),
                pr = race, pc = class})
        end)
    elseif event == "PLAYER_LEVEL_UP" then
        local level = ...
        if Public(level) and type(level) == "number" then Add({k = "mylevel", d = level}) end
    elseif event == "PLAYER_UPDATE_RESTING" then
        C_Timer.After(3, function()
            if Ask(IsResting) ~= true or not stretch then return end
            local place = Text(Ask(GetSubZoneText)) or Zone()
            local seen = restedAt[stretch] or {}
            restedAt[stretch] = seen
            if place and not seen[place] then
                seen[place] = true
                Add({k = "rest", d = place})
            end
        end)
    elseif event == "PLAYER_PVP_KILLS_CHANGED" then
        -- An honorable kill: the first one in the open world (not a battleground).
        local okInst, _, kind = pcall(IsInInstance or function() return false end)
        if not (okInst and kind == "pvp") then First("pvp", {d = "pvp", z = Zone()}) end
    elseif event == "CHAT_MSG_LOOT" then
        local message, looter = ...
        if not Public(message) or type(message) ~= "string" then return end
        local me = Text(Ask(UnitName, "player"))
        if looter and Public(looter) and me and tostring(looter):gsub("%-.*$", "") ~= me then return end
        local id = tonumber(message:match("|Hitem:(%d+)"))
        if not id then return end
        local name, quality = ItemInfo(message:match("|H(item:[^|]+)|h") or id)
        if name and quality and quality <= 1 then GatheredName(name) end
        if FAMOUS[id] then First("item:" .. id, {d = "famous", z = FAMOUS[id]}) end
        if quality == 5 then First("legendary", {d = "legendary", z = name})
        elseif quality == 4 then First("epic", {d = "epic", z = name})
        elseif quality == 3 and name then First("rare", {d = "rare", z = name}) end
    elseif event == "PLAYER_EQUIPMENT_CHANGED" then
        -- Tier pieces, and a whole set worn.
        local count, names = {}, {}
        for slot = 1, 19 do
            local item = Ask(GetInventoryItemID, "player", slot)
            local _, _, setID = ItemInfo(item)
            if setID then count[setID] = (count[setID] or 0) + 1 end
        end
        for setID, n in pairs(count) do
            names[setID] = SetName(setID)
            if TIERS[setID] then First("tier" .. TIERS[setID], {d = "tier", z = names[setID], c = TIERS[setID]}) end
            if n >= 8 then First("setfull:" .. setID, {d = "setfull", z = names[setID]}) end
        end
    elseif event == "PLAYER_MOUNT_DISPLAY_CHANGED" then
        if Ask(IsMounted) == true and Ask(UnitOnTaxi, "player") ~= true and (tonumber(Ask(UnitLevel, "player")) or 0) >= 40 then
            First("mount", {d = "mount", n = MountKind()})
        end
    elseif event == "RESURRECT_REQUEST" then
        local name = Text((...))
        offer = name and {by = name, t = Now()} or nil
    elseif event == "PLAYER_ALIVE" or event == "PLAYER_UNGHOST" then
        local rezzed = offer and Now() - offer.t <= 120 and Ask(UnitIsDeadOrGhost, "player") ~= true
        if rezzed then
            Add({k = "rez", w = "them", by = offer.by:gsub("%-.*$", "")})
        elseif diedAt and Ask(UnitIsDeadOrGhost, "player") ~= true and Now() - diedAt >= 180 then
            -- the walk back as a spirit: kept on the death it followed
            local journal = Journal()
            for i = #(journal or {}), math.max(1, #(journal or {}) - 10), -1 do
                local e = journal[i]
                if e.k == "death" and (e.t or 0) >= diedAt - 5 then e.walk = Now() - diedAt; break end
            end
        end
        if Ask(UnitIsDeadOrGhost, "player") ~= true then diedAt = nil end
        offer = nil
    end
end)
-- The campfire timer (People.lua sees it): once per stretch.
local fireAt = setmetatable({}, {__mode = "k"})
function A.SelfCampfire()
    if not A.SelfJournalOn() or not stretch or fireAt[stretch] then return end
    fireAt[stretch] = true
    Add({k = "campfire"})
end

-- Seeding: your journal starts with what your journals with people know --------
-- (their outings are your time in those places; quests, dungeons, bosses, your
-- deaths and levels are yours). Once per character.
local SEED_KINDS = {quest = true, dungeon = true, boss = true, wipe = true, rest = true, campfire = true, mylevel = true}
function A.SelfSeed()
    local mine = A.MyCharacter and A.MyCharacter(true)
    if type(mine) ~= "table" or mine.selfSeeded then return 0 end
    mine.selfSeeded = Now()
    StartLevel()
    mine.journal = type(mine.journal) == "table" and mine.journal or {}
    local out, seen = {}, {}
    local function Keep(entry)
        local key = entry.k .. "|" .. tostring(entry.d) .. "|" .. tostring(entry.z) .. "|" .. math.floor((entry.t or 0) / 60)
        if seen[key] then return end
        seen[key] = true
        entry.s = true -- seeded
        out[#out + 1] = entry
    end
    for key, rel in pairs(type(mine.people) == "table" and mine.people or {}) do
        local card = A.db.people and A.db.people[key]
        -- (older lines kept only their level: yours was near it, you travelled together)
        local lastTheirs
        for _, e in ipairs(type(rel) == "table" and type(rel.journal) == "table" and rel.journal or {}) do
            if e.k == "level" then lastTheirs = tonumber(e.d) end
            local pl = e.pl or e.ol or lastTheirs
            if e.k == "group" then
                Keep({k = "play", t = e.t, e = e.e or e.t, z = e.z, pl = pl})
                Keep({k = "with", d = key, n = card and card.name or nil, t = e.t, e = e.e or e.t, z = e.z})
            elseif e.k == "death" and e.w == "you" then
                Keep({k = "death", w = "you", d = e.d, env = e.env, boss = e.boss, t = e.t, z = e.z, pl = pl})
            elseif e.k == "rez" then
                Keep({k = "rez", w = "them", by = card and card.name and card.name:gsub("%-.*$", "") or nil, t = e.t, z = e.z})
            elseif SEED_KINDS[e.k] then
                Keep({k = e.k, d = e.d, t = e.t, z = e.z, pl = pl, ql = e.ql, cost = e.cost})
            end
        end
    end
    -- Two companions, one outing: one stretch of play.
    table.sort(out, function(a, b) return (a.t or 0) < (b.t or 0) end)
    local merged, lastPlay = {}, nil
    for _, entry in ipairs(out) do
        if entry.k == "play" and lastPlay and lastPlay.z == entry.z and (entry.t or 0) <= (lastPlay.e or lastPlay.t) + 60 then
            lastPlay.e = math.max(lastPlay.e or 0, entry.e or 0)
        else
            merged[#merged + 1] = entry
            if entry.k == "play" then lastPlay = entry end
        end
    end
    for i = #merged, 1, -1 do table.insert(mine.journal, 1, merged[i]) end
    -- The journal goes back as far as what it was seeded from: the oldest line's
    -- level, or level 1 if you and a companion began together.
    local earliest
    for _, entry in ipairs(merged) do
        local level = tonumber(entry.pl)
        if level and (not earliest or level < earliest) then earliest = level end
    end
    for _, rel in pairs(type(mine.people) == "table" and mine.people or {}) do
        if type(rel) == "table" and rel.origin == "together" then earliest = 1 end
    end
    if earliest and (not mine.selfStartLevel or earliest < mine.selfStartLevel) then mine.selfStartLevel = earliest end
    local firsts = Firsts()
    for _, entry in ipairs(merged) do
        if entry.k == "play" and entry.z and firsts then firsts["zone:" .. entry.z] = firsts["zone:" .. entry.z] or entry.t end
    end
    return #merged
end

-- Every thirty seconds while the journal is on: an epic mount (your speed on
-- it), and a sunset watched at the sea (a coast at dusk, twice in a row).
local BEACHES = {["Longshore"] = true, ["Jaguero Isle"] = true, ["The Savage Coast"] = true, ["Lost Rigger Cove"] = true,
    ["The Merchant Coast"] = true, ["Echo Isles"] = true, ["Sen'jin Village"] = true, ["Bay of Storms"] = true,
    ["The Forgotten Coast"] = true, ["Steamwheedle Port"] = true, ["Booty Bay"] = true, ["Ratchet"] = true}
local function Beach(sub)
    if not sub then return false end
    if BEACHES[sub] then return true end
    for _, word in ipairs({"Coast", "Shore", "Beach", "Cove", "Bay"}) do
        if sub:find("%f[%a]" .. word .. "%f[%A]") then return true end
    end
    return false
end
local watching -- {sub, since}
local swimSince -- {t, sub}
local function Tick()
    if not A.SelfJournalOn() then return end
    -- a long swim: two minutes and more in the water, once a stretch
    if Ask(IsSwimming) == true then
        swimSince = swimSince or {t = Now(), sub = SubZone() or Zone()}
        if Now() - swimSince.t >= 110 and stretch and not swimSince.told then
            swimSince.told = true
            Add({k = "swim", d = swimSince.sub})
        end
    else
        swimSince = nil
    end
    if Ask(IsMounted) == true and Ask(UnitOnTaxi, "player") ~= true and Ask(IsFalling) ~= true and Ask(IsSwimming) ~= true
        and (tonumber(Ask(UnitLevel, "player")) or 0) >= 60 then
        local speed = tonumber(Ask(GetUnitSpeed, "player")) or 0
        if speed >= 13.5 then First("epicmount", {d = "epicmount", n = MountKind()}) end
    end
    local sub = SubZone()
    local hour, minute = Ask(GetGameTime)
    local dusk = hour and ((hour == 19 and (minute or 0) >= 0) or (hour == 20 and (minute or 0) <= 30))
    if Beach(sub) and dusk and Ask(UnitAffectingCombat, "player") ~= true then
        if watching and watching.sub == sub and Now() - watching.since >= 55 then
            First("sunset:" .. sub, {d = "sunset", z = sub})
        elseif not watching or watching.sub ~= sub then
            watching = {sub = sub, since = Now()}
        end
    else
        watching = nil
    end
end
A.SelfTick = Tick
local ticker
-- Unit events fire for every unit in sight; only your own matter here.
local PLAYER_ONLY = {UNIT_SPELLCAST_SUCCEEDED = true, UNIT_PET = true}
function A.UpdateSelfJournalEvents()
    for _, event in ipairs(EVENTS) do
        if not A.SelfJournalOn() then pcall(events.UnregisterEvent, events, event)
        elseif PLAYER_ONLY[event] and events.RegisterUnitEvent then pcall(events.RegisterUnitEvent, events, event, "player")
        else pcall(events.RegisterEvent, events, event) end
    end
    pcall(closeFrame.UnregisterEvent, closeFrame, "UNIT_HEALTH")
    for _, event in ipairs(MORE_EVENTS) do
        if A.MoreMomentsOn() then pcall(events.RegisterEvent, events, event) else pcall(events.UnregisterEvent, events, event) end
    end
    if not A.MoreMomentsOn() then
        -- (off: the next time it is turned on starts afresh)
        RareUnwatch()
        trainerOpen, repRead, skillRead = false, {}, {}
        moneySeen, rankSeen = nil, nil
    else
        SeedHonor()
        -- (standings, skills, purse and rank seeded now, so the first change after turning it on is told)
        moneySeen, rankSeen = nil, nil
        MoneyChanged()
        RankChanged()
        if C_Timer and C_Timer.After then
            if not repQueued then repQueued = true; C_Timer.After(2, ScanReputation) end
            if not skillQueued then skillQueued = true; C_Timer.After(2, ScanSkills) end
        end
    end
    if ticker and ticker.Cancel then ticker:Cancel() end
    ticker = nil
    if A.SelfJournalOn() and C_Timer and C_Timer.NewTicker then ticker = C_Timer.NewTicker(30, Tick) end
    if A.SelfJournalOn() then
        if closeFrame.RegisterUnitEvent then pcall(closeFrame.RegisterUnitEvent, closeFrame, "UNIT_HEALTH", "player") end
        A.SelfSeed()
        Settle()
        Open()
        CheckInstance()
    else
        Close()
    end
end
