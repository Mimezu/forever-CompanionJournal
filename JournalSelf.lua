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
local POSSIBLE = {mount = 40, epicmount = 60, epic = 20, legendary = 60, famous = 60, tier = 58, setfull = 45, raid = 50,
    worldboss = 60, landmark = 30, pvp = 10, tram = 1, flight = 1, zeppelin = 1, boat = 1, continent = 1,
    foeseen = 1, battleground = 10, rezother = 10, rare = 1, snow = 1, rarebeast = 1, aucsale = 1}
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
    local possible, start = entry.gate or POSSIBLE[entry.d], StartLevel()
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
local function Crafted(spellID)
    if not stretch or not profession then return end
    local made
    if C_Spell and C_Spell.GetSpellName then made = Text(Ask(C_Spell.GetSpellName, spellID))
    elseif GetSpellInfo then made = Text(Ask(GetSpellInfo, spellID)) end
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
