local _, A = ...
-- Journal: what you lived through with the people in your list. Each person
-- keeps a short list of entries (grouping, dungeons, bosses, quests, crossing
-- paths, campfires, levels, and lines you write yourself). The journal window
-- (JournalUI.lua) tells them as a chronicle. Groupmates not in your list yet
-- are followed too: kept aside until you add them (usually when the group
-- ends), then written into their journal; forgotten if you don't.
-- Automatic entries are off by default. When off, no events are registered
-- and nothing is recorded; the window still opens with what exists.
local function Public(value) return not issecretvalue or not issecretvalue(value) end
local function Text(value)
    return Public(value) and type(value) == "string" and value ~= "" and value or nil
end

-- On from the first login: the journal is the heart of the addon (2026-11-06).
A.defaults.peopleJournal = true
-- Sub-option: "crossed paths" lines from plates (only while the journal is on).
A.defaults.journalSeen = true

local SEEN_MERGE = 6 * 3600   -- one "crossed paths" line per zone per six hours
local SEEN_THROTTLE = 300     -- plate renders re-check at most every five minutes
local RESUME_GROUP = 600      -- a /reload inside a group continues the same outing
local ASIDE_KEEP = 3600       -- after you part: an hour to add them with their memories
local QUEST_KEEP = 7 * 86400  -- a quest done together waits a week for its turn-in

local function Now() return time and time() or 0 end
local function Zone() return Text(GetRealZoneText and GetRealZoneText()) end
local function Ask(fn, ...)
    if not fn then return nil end
    local ok, value = pcall(fn, ...)
    if ok and Public(value) then return value end
    return nil
end

function A.JournalOn()
    local db = A.db
    return db and db.enabled and db.peopleJournal and true or false
end

-- Adds an entry. Journals are kept whole (no limit on days or lines).
-- Each automatic entry also keeps your level and theirs at that moment (pl,
-- ol): the storyteller tells a level-50 walk through Elwynn differently from
-- a level-8 one.
-- Someone another character of yours knows (recognized, or their journal
-- opened to read) is never written to from here.
-- (campfire people keep no journal, since 1.22.0: they leave the list two hours after the fire)
local function Writable(person)
    return person and not person.npc and not person.recognizedBy and not person.readOnly and person.circle ~= "campfire"
end
function A.JournalAdd(person, entry)
    if not Writable(person) then return nil end
    local journal = person.journal
    if type(journal) ~= "table" then journal = {}; person.journal = journal end
    entry.t = entry.t or Now()
    entry.z = entry.z or Zone()
    if entry.k ~= "custom" then
        entry.pl = entry.pl or tonumber(Ask(UnitLevel, "player"))
        entry.ol = entry.ol or tonumber(person.level)
    end
    journal[#journal + 1] = entry
    if A.RefreshJournal then A.RefreshJournal(person) end
    return entry
end
function A.JournalCanWriteNotes(person)
    local me = A.Me and A.Me()
    return Writable(person) and (not person.self or me and person.charKey == me) and true or false
end
-- Notes dated to an earlier journal day use noon, safely away from midnight
-- and the book's before-five-in-the-morning evening boundary.
function A.JournalNoteTimestamp(dayKey)
    if type(dayKey) ~= "string" or not date or not time then return nil end
    local year, month, day = dayKey:match("^(%d%d%d%d)%-(%d%d)%-(%d%d)$")
    if not year then return nil end
    year, month, day = tonumber(year), tonumber(month), tonumber(day)
    if month < 1 or month > 12 or day < 1 or day > 31 then return nil end
    local now = Now()
    local today = date("%Y-%m-%d", A.JournalEvening and A.JournalEvening(now) or now)
    if dayKey > today then return nil end
    if dayKey == today then return now end
    local ok, stamp = pcall(time, {year = year, month = month, day = day, hour = 12, min = 0, sec = 0})
    if not ok or type(stamp) ~= "number" or date("%Y-%m-%d", stamp) ~= dayKey then return nil end
    return stamp
end
function A.JournalWrite(person, text, dayKey)
    if not A.JournalCanWriteNotes(person) then return nil end
    text = type(text) == "string" and text:gsub("^%s+", ""):gsub("%s+$", "") or ""
    if text == "" then return nil end
    local stamp = dayKey and A.JournalNoteTimestamp(dayKey)
    if dayKey ~= nil and not stamp then return nil end
    local now = Now()
    local today = date and date("%Y-%m-%d", A.JournalEvening and A.JournalEvening(now) or now)
    return A.JournalAdd(person, {k = "custom", d = text:sub(1, 300), t = stamp,
        z = dayKey and dayKey ~= today and "" or nil})
end
-- Only an authored note in this exact journal can be removed through the
-- book's note action. Matching text is never used as identity.
function A.JournalRemoveNote(person, entry)
    if not A.JournalCanWriteNotes(person) or type(entry) ~= "table" or entry.k ~= "custom" or entry.synthetic then return false end
    local journal = person.journal
    if type(journal) ~= "table" then return false end
    for i = #journal, 1, -1 do
        if journal[i] == entry then
            table.remove(journal, i)
            if A.RefreshJournal then A.RefreshJournal(person) end
            return true
        end
    end
    return false
end
-- New text for an authored note: the same note, edited where it stands. Empty text is
-- not an edit (removing is its own, confirmed step).
function A.JournalEditNote(person, entry, text)
    if not A.JournalCanWriteNotes(person) or type(entry) ~= "table" or entry.k ~= "custom" or entry.synthetic then return false end
    text = type(text) == "string" and text:gsub("^%s+", ""):gsub("%s+$", "") or ""
    if text == "" then return false end
    for _, saved in ipairs(person.journal or {}) do
        if saved == entry then
            entry.d = text:sub(1, 300)
            if A.RefreshJournal then A.RefreshJournal(person) end
            return true
        end
    end
    return false
end
function A.JournalRemove(person, entry)
    local journal = Writable(person) and person.journal
    if type(journal) ~= "table" then return end
    for i = #journal, 1, -1 do
        if journal[i] == entry then table.remove(journal, i); break end
    end
    if A.RefreshJournal then A.RefreshJournal(person) end
end
-- Several at once (a whole scene of the book), with one refresh.
function A.JournalRemoveEntries(person, entries)
    local journal = Writable(person) and person.journal
    if type(journal) ~= "table" or type(entries) ~= "table" then return end
    local drop = {}
    for _, entry in ipairs(entries) do drop[entry] = true end
    for i = #journal, 1, -1 do
        if drop[journal[i]] then table.remove(journal, i) end
    end
    if A.RefreshJournal then A.RefreshJournal(person) end
end

-- Open outings: key -> the "group" entry being written. Seen lines are
-- skipped while you travel together.
local sessions = {}
local seenMemo = setmetatable({}, {__mode = "k"})
local QueueQuestScan, ResetQuestWatch -- quests done together, below

function A.JournalSeen(person)
    if not A.JournalOn() or not A.db.journalSeen or not Writable(person) then return end
    local zone = Zone()
    if not zone then return end
    local now = Now()
    local memo = seenMemo[person]
    if memo and memo.zone == zone and now - memo.t < SEEN_THROTTLE then return end
    seenMemo[person] = {zone = zone, t = now}
    local key = A.PersonKey(person.name)
    if key and sessions[key] then return end
    local journal = person.journal
    -- Merge into the latest line for this zone if it is recent.
    if type(journal) == "table" then
        for i = #journal, math.max(1, #journal - 5), -1 do
            local entry = journal[i]
            if entry.z == zone and now - (entry.e or entry.t or 0) < SEEN_MERGE then
                if entry.k == "seen" then entry.e, entry.c = now, (entry.c or 1) + 1 end
                return
            end
        end
    end
    A.JournalAdd(person, {k = "seen"})
end

function A.JournalLevel(person, level)
    if not A.JournalOn() then return end
    A.JournalAdd(person, {k = "level", d = level})
end

function A.JournalCampfire(person)
    if not A.JournalOn() or not person then return end
    local journal, now = person.journal, Now()
    local last = type(journal) == "table" and journal[#journal]
    if last and last.k == "campfire" and now - last.t < 3600 then return end
    A.JournalAdd(person, {k = "campfire"})
end

-- Groupmates who are not in your list: what you do together is kept aside
-- (saved, keyed like People), then written into their journal if you add
-- them, or forgotten.
local function Aside(create)
    local store = A.db.journalAside
    if type(store) ~= "table" then
        if not create then return nil end
        store = {}
        A.db.journalAside = store
    end
    return store
end
-- Where someone's lines go: their People entry, or what is kept aside.
local function Holder(key)
    local person = A.People[key]
    if person then return not person.npc and person or nil end
    local store = Aside()
    return store and store[key] or nil
end

-- Everyone you travel with right now: people from your list, and groupmates
-- whose lines are kept aside.
local function EachSession(fn)
    for key, entry in pairs(sessions) do
        local holder = Holder(key)
        if holder then fn(holder, entry, key) else sessions[key] = nil end
    end
end
-- Your own level-up while you travel with people of your list: theirs to keep
-- too ("mylevel", so it is never taken for their level).
function A.JournalMyLevel(level)
    if not A.JournalOn() or not level then return end
    EachSession(function(holder) A.JournalAdd(holder, {k = "mylevel", d = level}) end)
end
local function CloseSession(key, entry, now)
    if A.SelfWith then A.SelfWith(key, nil, false, now) end
    entry.e = now
    sessions[key] = nil
    local store = Aside()
    if store and type(store[key]) == "table" then store[key].left = now end
end
-- The outing a /reload (or a quick regroup) continues: the latest "group"
-- line, if it ended only minutes ago. Lines written during it may follow it.
local function Resumable(journal, now)
    if type(journal) ~= "table" then return nil end
    for i = #journal, math.max(1, #journal - 30), -1 do
        local entry = journal[i]
        if entry.k == "group" then
            if (not entry.e or now - entry.e < RESUME_GROUP) and now - (entry.t or 0) < 12 * 3600 then return entry end
            return nil
        end
    end
    return nil
end

-- Someone joins your list: what was kept aside becomes the start of their
-- journal, and you met them when you first grouped.
function A.JournalAdopt(person, key)
    local store = Aside()
    local memory = store and key and store[key]
    if not memory or not person or person.npc then return end
    store[key] = nil
    if next(store) == nil then A.db.journalAside = nil end
    local entries = type(memory) == "table" and type(memory.journal) == "table" and memory.journal or {}
    local first = entries[1]
    if not first then return end
    if not person.met or (first.t or 0) < person.met then
        person.met, person.metZone, person.metHow = first.t, first.z or person.metZone, nil
    end
    local journal = type(person.journal) == "table" and person.journal or {}
    person.journal = journal
    for _, entry in ipairs(entries) do journal[#journal + 1] = entry end
    if A.RefreshJournal then A.RefreshJournal(person) end
end
-- "Don't add": what was kept aside for them is forgotten.
function A.JournalForget(key)
    local store = Aside()
    if not store or not key or sessions[key] then return end
    store[key] = nil
    if next(store) == nil then A.db.journalAside = nil end
end
-- Kept aside until you add them; forgotten an hour after you part (kept
-- while the group prompt still asks about them).
local function PruneAside(now)
    local store = Aside()
    if not store then return end
    for key, memory in pairs(store) do
        local person = A.People[key]
        if person then
            A.JournalAdopt(person, key) -- added some other way
        elseif not sessions[key] and not (A.GroupPromptQueued and A.GroupPromptQueued(key)) then
            local journal = type(memory) == "table" and memory.journal
            local last = type(journal) == "table" and journal[#journal]
            local parted = type(memory) == "table" and memory.left or (last and (last.e or last.t)) or 0
            if now - parted > ASIDE_KEEP then store[key] = nil end
        end
    end
    if next(store) == nil then A.db.journalAside = nil end
end

function A.JournalGroupChanged()
    if not A.JournalOn() or not A.ReadGroupRoster then return end
    local db, now = A.db, Now()
    local members, complete, inGroup = A.ReadGroupRoster()
    for key, member in pairs(members) do
        local person, holder = A.People[key], nil
        if person then
            if not person.npc then
                if A.UpdatePersonFromEntry then A.UpdatePersonFromEntry(person, member) end
                A.JournalAdopt(person, key)
                holder = person
            end
        elseif not (db.peopleBlocked and db.peopleBlocked[key]) then
            local store = Aside(true)
            holder = store[key]
            if type(holder) ~= "table" then
                holder = {name = member.name}
                store[key] = holder
                -- An outing still open for someone just removed from your list.
                sessions[key] = nil
            end
            holder.left = nil
        end
        if holder and not sessions[key] then
            local last = Resumable(holder.journal, now)
            if last then
                last.e = nil
                sessions[key] = last
            else
                sessions[key] = A.JournalAdd(holder, {k = "group"})
            end
            if sessions[key] then sessions[key].dungeons = nil end
            if person and not person.npc and A.SelfWith then A.SelfWith(key, person, true) end
        end
    end
    for key, entry in pairs(sessions) do
        if not inGroup or (complete and not members[key]) then CloseSession(key, entry, now) end
    end
    -- (your own journal: how many you travel with, strangers counted; JournalSelf.lua)
    if A.SelfParty then A.SelfParty(members, complete, inGroup) end
    if not next(sessions) then ResetQuestWatch() end
    if A.JournalWatchParty then A.JournalWatchParty(next(sessions) ~= nil) end
    if A.JournalRestCheck then A.JournalRestCheck() end
    PruneAside(now)
    A.JournalInstanceCheck()
    QueueQuestScan()
end

-- Entering a dungeon or raid while travelling with someone.
local sessionDungeons = setmetatable({}, {__mode = "k"})
-- Already written for this outing (a /reload inside keeps the outing going).
local function WroteDungeon(holder, outing, name)
    local journal = holder.journal
    if type(journal) ~= "table" then return false end
    for i = #journal, math.max(1, #journal - 30), -1 do
        local entry = journal[i]
        if entry == outing then return false end
        if entry.k == "dungeon" and entry.d == name then return true end
    end
    return false
end
function A.JournalInstanceCheck()
    if not next(sessions) or not IsInInstance then return end
    local ok, inside, kind = pcall(IsInInstance)
    if not ok or not inside or (kind ~= "party" and kind ~= "raid") then return end
    local name = GetInstanceInfo and Text((GetInstanceInfo()))
    if not name then return end
    EachSession(function(holder, entry)
        local seen = sessionDungeons[entry] or {}
        sessionDungeons[entry] = seen
        if not seen[name] then
            seen[name] = true
            if not WroteDungeon(holder, entry, name) then
                local theirRole
                for _, unit in ipairs({"party1", "party2", "party3", "party4"}) do
                    local okKey, key = pcall(A.UnitPersonKey or function() return nil end, unit)
                    if okKey and key and holder == Holder(key) then theirRole = A.UnitRole(unit) end
                end
                A.JournalAdd(holder, {k = "dungeon", d = name, z = name, r = A.UnitRole("player"), tr = theirRole})
            end
        end
    end)
end

local function Instance()
    if not IsInInstance then return nil end
    local ok, inside = pcall(IsInInstance)
    return ok and inside and GetInstanceInfo and Text((GetInstanceInfo())) or nil
end

-- The game's damage meter, for the fight just won (the "Current" session),
-- when it is there and readable: each player's rank in damage done, healing
-- done and damage taken, and their share. {players, me = {d, h, t, ds, hs},
-- byName = {[short name] = {d, h, t, ds, hs}}}. Nil when it cannot be read.
local function ShortName(name) return name and tostring(name):gsub("%-.*$", "") or nil end
function A.MeterSnapshot()
    local meter, enum = C_DamageMeter, Enum
    if not (meter and meter.GetCombatSessionFromType and enum and enum.DamageMeterSessionType and enum.DamageMeterType) then return nil end
    local ok, available = pcall(meter.IsDamageMeterAvailable or function() return true end)
    if ok and available == false then return nil end
    local function Read(kind)
        if not kind then return nil end
        local okRead, session = pcall(meter.GetCombatSessionFromType, enum.DamageMeterSessionType.Current, kind)
        if not okRead or type(session) ~= "table" or type(session.combatSources) ~= "table" then return nil end
        local list, total = {}, 0
        for _, source in ipairs(session.combatSources) do
            local amount, creature = source.totalAmount, source.sourceCreatureID
            if not Public(amount) or type(amount) ~= "number" then return nil end
            if creature == nil or (Public(source.classFilename) and source.classFilename ~= "") then
                list[#list + 1] = {name = Public(source.name) and ShortName(source.name) or nil,
                    me = Public(source.isLocalPlayer) and source.isLocalPlayer == true, amount = amount}
                total = total + amount
            end
        end
        table.sort(list, function(a, b) return a.amount > b.amount end)
        return list, total
    end
    local out = {byName = {}, me = {}}
    for key, kind in pairs({d = enum.DamageMeterType.DamageDone, h = enum.DamageMeterType.HealingDone, t = enum.DamageMeterType.DamageTaken}) do
        local list, total = Read(kind)
        if list then
            out.players = math.max(out.players or 0, #list)
            for rank, x in ipairs(list) do
                local share = total > 0 and math.floor(x.amount * 100 / total + 0.5) or 0
                local into = x.me and out.me or (x.name and out.byName[x.name]) or nil
                if not into and x.name then into = {}; out.byName[x.name] = into end
                if into then into[key], into[key .. "s"] = rank, share end
            end
        end
    end
    if not out.players or out.players < 2 then return nil end
    return out
end
-- Your role (and a groupmate's) as the game assigns it: "tank", "healer",
-- "damage", or nil.
local ROLES = {TANK = "tank", HEALER = "healer", DAMAGER = "damage"}
function A.UnitRole(unit)
    local ok, role = pcall(UnitGroupRolesAssigned or function() return nil end, unit)
    return ok and Public(role) and ROLES[role] or nil
end
-- A boss entry gets the meter a moment after the fight (you, and the one
-- whose journal it is: "them").
function A.JournalMeterInto(entry, theirName)
    if type(entry) ~= "table" then return end
    C_Timer.After(1.5, function()
        local snap = A.MeterSnapshot()
        if not snap then return end
        entry.n = snap.players
        if next(snap.me) then entry.me = snap.me end
        local theirs = theirName and snap.byName[ShortName(theirName)]
        if theirs then entry.them = theirs end
    end)
end

-- costly: someone fell during the fight (you won anyway).
function A.JournalBoss(name, costly)
    name = Text(name)
    if not name or not next(sessions) then return end
    local where = Instance() or Zone()
    EachSession(function(holder)
        local entry = A.JournalAdd(holder, {k = "boss", d = name, z = where, cost = costly or nil})
        A.JournalMeterInto(entry, holder.name)
    end)
end

-- Deaths and resurrections ----------------------------------------------------
-- While you travel together: your deaths, with the cause from the death recap
-- (a foe's name, or a fall, drowning, lava...); theirs, from your party; a
-- boss fight lost after someone fell; and who brought you back.
local encounter, encounterFallen = nil, false
local function DeathCause()
    local recap = C_DeathRecap
    if not recap or not recap.GetRecapEvents then return nil, nil end
    local events = Ask(recap.GetRecapEvents)
    local blow = type(events) == "table" and events[1] -- the killing blow comes first
    if type(blow) ~= "table" then return nil, nil end
    local env = Text(blow.environmentalType)
    if env then return nil, env:upper() end
    return Text(blow.sourceName), nil
end
function A.JournalPlayerDied()
    if not A.JournalOn() or not next(sessions) then return end
    if encounter then encounterFallen = true end
    local boss, where = encounter, Instance() or Zone()
    -- The recap is filled a moment after the death.
    C_Timer.After(1, function()
        local killer, env = DeathCause()
        -- "a Dire Mottled Boar": an ordinary foe you had targeted gets its article.
        local article, race, class
        if killer and Text(Ask(UnitName, "target")) == killer and Ask(UnitIsPlayer, "target") ~= true then
            local rank = Text(Ask(UnitClassification, "target"))
            article = (not rank or rank == "normal" or rank == "minus" or rank == "trivial") or nil
        elseif killer and Text(Ask(UnitName, "target")) == killer and Ask(UnitIsPlayer, "target") == true then
            -- one of the other side: what they were, not their name
            race, class = Text(Ask(UnitRace, "target")), Text(Ask(UnitClass, "target"))
        end
        EachSession(function(holder)
            A.JournalAdd(holder, {k = "death", w = "you", d = (race or class) and nil or killer, a = article, env = env, boss = boss, z = where,
                pr = race, pc = class})
        end)
    end)
end
-- Their deaths: your party's units (people in your list and groupmates kept
-- aside), watched only while you travel with someone.
local partyKeys, partyDead = {}, {}
local function PartyDeath(unit)
    local key = partyKeys[unit]
    if not key or not sessions[key] then return end
    local dead = Ask(UnitIsDeadOrGhost, unit) == true and Ask(UnitIsFeignDeath, unit) ~= true
    if dead and not partyDead[key] then
        if encounter then encounterFallen = true end
        local holder = Holder(key)
        if holder then A.JournalAdd(holder, {k = "death", w = "them", boss = encounter, z = Instance() or Zone()}) end
        if holder and A.SelfPartyDeath then A.SelfPartyDeath(holder.name, encounter) end
    end
    partyDead[key] = dead or nil
end
local partyFrames = {}
for i, units in ipairs({{"party1", "party2"}, {"party3", "party4"}}) do
    local frame = CreateFrame("Frame")
    frame:SetScript("OnEvent", function(_, _, unit) PartyDeath(unit) end)
    partyFrames[i] = {frame = frame, units = units}
end
local function WatchParty(on)
    partyKeys = {}
    for _, watch in ipairs(partyFrames) do
        pcall(watch.frame.UnregisterEvent, watch.frame, "UNIT_HEALTH")
        if on then
            pcall(watch.frame.RegisterUnitEvent, watch.frame, "UNIT_HEALTH", watch.units[1], watch.units[2])
            for _, unit in ipairs(watch.units) do
                local key = A.UnitPersonKey and A.UnitPersonKey(unit)
                if key then
                    partyKeys[unit] = key
                    -- Already dead when watching starts: not a new death.
                    partyDead[key] = Ask(UnitIsDeadOrGhost, unit) == true or nil
                end
            end
        end
    end
    if not on then partyDead = {} end
end
A.JournalWatchParty = WatchParty
-- Resting together: an inn or a city, with them close by (in range). Once
-- per place and outing.
local restedAt = setmetatable({}, {__mode = "k"})
function A.JournalRestCheck()
    if not A.JournalOn() or not next(sessions) or Ask(IsResting) ~= true then return end
    local place = Text(Ask(GetSubZoneText)) or Zone()
    for unit, key in pairs(partyKeys) do
        local outing = sessions[key]
        local near, checked = Ask(UnitInRange, unit)
        if outing and near == true and checked ~= false then
            local seen = restedAt[outing] or {}
            restedAt[outing] = seen
            local holder = Holder(key)
            if holder and place and not seen[place] then
                seen[place] = true
                A.JournalAdd(holder, {k = "rest", d = place})
            end
        end
    end
end
-- Brought back by a companion: the offer, then you are alive again.
local rezOffer
function A.JournalResurrectOffer(name)
    local key = A.PersonKey and A.PersonKey(Text(name))
    rezOffer = key and sessions[key] and {key = key, t = Now()} or nil
end
function A.JournalAlive()
    local offer = rezOffer
    if not offer or Now() - offer.t > 120 or Ask(UnitIsDeadOrGhost, "player") == true then return end
    rezOffer = nil
    local holder = sessions[offer.key] and Holder(offer.key)
    if holder then A.JournalAdd(holder, {k = "rez", w = "them"}) end
end
-- Bringing a companion back from death (only with "Record more moments" on):
-- your resurrection spell landing on someone you travel with. Their journal
-- keeps it as a rez by you ("rez", w = "you"); theirs of you stay as before.
local REZ_SPELLS = {["Resurrection"] = true, ["Redemption"] = true, ["Ancestral Spirit"] = true, ["Rebirth"] = true}
function A.JournalRaised(spellID)
    if not A.JournalOn() or not next(sessions) or not (A.MoreMomentsOn and A.MoreMomentsOn()) then return end
    local spellName = (C_Spell and C_Spell.GetSpellName and Text(Ask(C_Spell.GetSpellName, spellID)))
        or (GetSpellInfo and Text(Ask(GetSpellInfo, spellID)))
    if not spellName or not REZ_SPELLS[spellName] then return end
    -- (the target must be the dead one: a rez cast from a party frame or by
    -- mouseover leaves some living companion targeted, who was not raised)
    if Ask(UnitIsDeadOrGhost, "target") ~= true then return end
    local key = A.PersonKey and A.PersonKey(Text(Ask(UnitName, "target")))
    local holder = key and sessions[key] and Holder(key)
    if holder then A.JournalAdd(holder, {k = "rez", w = "you"}) end
end
function A.JournalEncounterStart(name)
    encounter, encounterFallen = Text(name), false
end
function A.JournalEncounterEnd(name, success)
    if success == 1 then
        A.JournalBoss(name, encounterFallen)
    elseif encounterFallen and next(sessions) then
        -- A fight lost after someone fell.
        local fight, where = Text(name) or encounter, Instance() or Zone()
        if fight then EachSession(function(holder) A.JournalAdd(holder, {k = "wipe", d = fight, z = where}) end) end
    end
    encounter, encounterFallen = nil, false
end

-- Quests done together ------------------------------------------------------
-- Only quests your companions had too: seen on it while you travelled
-- together, and still with you when its objectives were done (it counts even
-- if they leave before you turn it in). A quest you finished alone stays
-- yours. Checked only while you travel with someone, at most once a second.
local JUST_DONE = 120   -- a companion who takes it moments later still counts
local questWith = {}    -- questID -> {key = true}: companions seen on it
local questWatched = {} -- questID -> true: seen in progress while together
local scanQueued = false

-- Saved per character (quest IDs are each character's own): a /reload or a
-- night between the last objective and the turn-in keeps it.
local function QuestRecords(create)
    local guid = Text(Ask(UnitGUID, "player"))
    if not guid then return nil end
    local all = A.db.journalQuests
    if type(all) ~= "table" then
        if not create then return nil end
        all = {}
        A.db.journalQuests = all
    end
    local mine = all[guid]
    if type(mine) ~= "table" then
        if not create then return nil end
        mine = {}
        all[guid] = mine
    end
    return mine
end
local function PruneQuestRecords(now)
    local all = A.db.journalQuests
    if type(all) ~= "table" then return end
    for guid, records in pairs(all) do
        if type(records) == "table" then
            for questID, record in pairs(records) do
                if type(record) ~= "table" or now - (tonumber(record.t) or 0) > QUEST_KEEP then records[questID] = nil end
            end
        end
        if type(records) ~= "table" or next(records) == nil then all[guid] = nil end
    end
    if next(all) == nil then A.db.journalQuests = nil end
end
local function ForgetQuest(questID)
    local records = QuestRecords()
    if records then records[questID] = nil end
    questWith[questID], questWatched[questID] = nil, nil
end
-- Your party (your own subgroup in a raid): unit and People key.
local function EachPartyUnit(fn)
    local count = tonumber(Ask(GetNumSubgroupMembers)) or 0
    for i = 1, math.min(4, count) do
        local unit = "party" .. i
        local key = A.UnitPersonKey and A.UnitPersonKey(unit)
        if key then fn(unit, key) end
    end
end
local function OnQuest(unit, questID)
    return C_QuestLog ~= nil and Ask(C_QuestLog.IsUnitOnQuest, unit, questID) == true
end
local function EachLogQuest(fn)
    local log = C_QuestLog
    if not log or not log.GetInfo or not log.GetNumQuestLogEntries then return end
    for i = 1, tonumber(Ask(log.GetNumQuestLogEntries)) or 0 do
        local info = Ask(log.GetInfo, i)
        local questID = type(info) == "table" and not info.isHeader and not info.isHidden and info.questID
        if Public(questID) and type(questID) == "number" and questID > 0 then fn(questID, info) end
    end
end
-- A quest's level and kind (elite, dungeon, raid...), for the storyteller:
-- the same quest reads differently at level 12 and at level 40.
local questLevels = {}
local function QuestTag(questID)
    local log = C_QuestLog
    local info = log and log.GetQuestTagInfo and Ask(log.GetQuestTagInfo, questID)
    local tag = type(info) == "table" and info.tagID
    return Public(tag) and tonumber(tag) or nil
end

local function ScanQuests()
    scanQueued = false
    if not A.JournalOn() or not next(sessions) or not C_QuestLog then return end
    local records = QuestRecords(true)
    if not records then return end
    local party = {}
    EachPartyUnit(function(unit, key) if sessions[key] then party[key] = unit end end)
    local now = Now()
    EachLogQuest(function(questID, info)
        local level = Public(info.level) and tonumber(info.level)
        if level and level > 0 then questLevels[questID] = level end
        local with = questWith[questID]
        for key, unit in pairs(party) do
            if OnQuest(unit, questID) then
                if not with then with = {}; questWith[questID] = with end
                with[key] = true
            end
        end
        if Ask(C_QuestLog.IsComplete, questID) ~= true then
            questWatched[questID] = true
            records[questID] = nil
            return
        end
        local record = records[questID]
        if type(record) ~= "table" then
            -- Done before you could see it (alone, or before this session):
            -- yours alone.
            record = {t = now, with = {}, alone = not questWatched[questID] or nil}
            records[questID] = record
        end
        record.ql = record.ql or questLevels[questID]
        -- Done now: the companions with you who have it (and, for a moment
        -- after, one who takes it too, like a letter you both carry).
        if not record.alone and with and now - (tonumber(record.t) or 0) <= JUST_DONE then
            if type(record.with) ~= "table" then record.with = {} end
            for key in pairs(with) do if sessions[key] then record.with[key] = true end end
        end
    end)
end
function QueueQuestScan()
    if scanQueued or not next(sessions) then return end
    scanQueued = true
    C_Timer.After(1, ScanQuests)
end
function ResetQuestWatch()
    questWith, questWatched = {}, {}
end

function A.JournalQuest(questID)
    if not A.JournalOn() then return end
    local records = QuestRecords()
    local record = records and records[questID]
    if records then records[questID] = nil end
    local together = {}
    if type(record) == "table" then
        if not record.alone and type(record.with) == "table" then
            for key in pairs(record.with) do together[key] = true end
        end
    elseif questWatched[questID] then
        -- Turned in before a check saw it done: the companions on it with you.
        local with = questWith[questID]
        EachPartyUnit(function(unit, key)
            if sessions[key] and ((with and with[key]) or OnQuest(unit, questID)) then together[key] = true end
        end)
    end
    questWith[questID], questWatched[questID] = nil, nil
    if not next(together) then return end
    local title
    if C_QuestLog and C_QuestLog.GetTitleForQuestID and questID then
        local ok, value = pcall(C_QuestLog.GetTitleForQuestID, questID)
        title = ok and Text(value)
    end
    if not title and GetTitleText then
        local ok, value = pcall(GetTitleText)
        title = ok and Text(value)
    end
    if not title then return end
    local level = type(record) == "table" and tonumber(record.ql) or questLevels[questID]
    local tag = QuestTag(questID)
    questLevels[questID] = nil
    for key in pairs(together) do
        local holder = Holder(key)
        if holder then A.JournalAdd(holder, {k = "quest", d = title, qid = type(questID) == "number" and questID or nil, ql = level, qt = tag}) end
    end
end

-- Events: registered only while the journal is on.
local events = CreateFrame("Frame")
local pending = false
local EVENTS = {"GROUP_ROSTER_UPDATE", "PLAYER_ENTERING_WORLD", "ZONE_CHANGED_NEW_AREA", "ENCOUNTER_START", "ENCOUNTER_END",
    "QUEST_ACCEPTED", "UNIT_QUEST_LOG_CHANGED", "QUEST_TURNED_IN", "QUEST_REMOVED", "PLAYER_LOGOUT",
    "PLAYER_DEAD", "RESURRECT_REQUEST", "PLAYER_ALIVE", "PLAYER_UNGHOST", "PLAYER_UPDATE_RESTING", "PLAYER_LEVEL_UP"}
events:SetScript("OnEvent", function(_, event, ...)
    if event == "GROUP_ROSTER_UPDATE" or event == "PLAYER_ENTERING_WORLD" then
        if pending then return end
        pending = true
        C_Timer.After(1, function() pending = false; A.JournalGroupChanged() end)
    elseif event == "ZONE_CHANGED_NEW_AREA" then
        A.JournalInstanceCheck()
    elseif event == "ENCOUNTER_START" then
        local _, name = ...
        A.JournalEncounterStart(name)
    elseif event == "ENCOUNTER_END" then
        local _, name, _, _, success = ...
        if Public(success) then A.JournalEncounterEnd(name, success) end
    elseif event == "PLAYER_DEAD" then
        A.JournalPlayerDied()
    elseif event == "PLAYER_LEVEL_UP" then
        local level = ...
        if Public(level) and type(level) == "number" then A.JournalMyLevel(level) end
    elseif event == "RESURRECT_REQUEST" then
        A.JournalResurrectOffer((...))
    elseif event == "UNIT_SPELLCAST_SUCCEEDED" then
        local unit, _, spellID = ...
        if Public(unit) and unit == "player" and Public(spellID) then A.JournalRaised(spellID) end
    elseif event == "PLAYER_ALIVE" or event == "PLAYER_UNGHOST" then
        A.JournalAlive()
    elseif event == "PLAYER_UPDATE_RESTING" then
        -- A moment later: party ranges settle after a hearthstone or a portal.
        C_Timer.After(3, A.JournalRestCheck)
    elseif event == "QUEST_ACCEPTED" then
        local questID = ...
        -- Taken while travelling together: in progress, even if already done.
        if next(sessions) and Public(questID) and type(questID) == "number" then questWatched[questID] = true end
        QueueQuestScan()
    elseif event == "UNIT_QUEST_LOG_CHANGED" then
        QueueQuestScan()
    elseif event == "QUEST_TURNED_IN" then
        local questID = ...
        if Public(questID) then A.JournalQuest(questID) end
    elseif event == "QUEST_REMOVED" then
        local questID = ...
        -- Abandoned (or turned in): forgotten once the turn-in had its turn.
        if Public(questID) and type(questID) == "number" then
            C_Timer.After(5, function() ForgetQuest(questID) end)
        end
    elseif event == "PLAYER_LOGOUT" then
        -- Close outings; a /reload in the same group reopens them.
        local now = Now()
        for key, entry in pairs(sessions) do CloseSession(key, entry, now) end
    end
end)
function A.UpdateJournalEvents()
    if A.JournalOn() then
        for _, event in ipairs(EVENTS) do pcall(events.RegisterEvent, events, event) end
        -- (your own casts only, and only with "Record more moments" on; the handler asks again)
        if A.db.moreMoments ~= true then pcall(events.UnregisterEvent, events, "UNIT_SPELLCAST_SUCCEEDED")
        elseif events.RegisterUnitEvent then pcall(events.RegisterUnitEvent, events, "UNIT_SPELLCAST_SUCCEEDED", "player")
        else pcall(events.RegisterEvent, events, "UNIT_SPELLCAST_SUCCEEDED") end
        PruneQuestRecords(Now())
        A.JournalGroupChanged()
    else
        for _, event in ipairs(EVENTS) do pcall(events.UnregisterEvent, events, event) end
        pcall(events.UnregisterEvent, events, "UNIT_SPELLCAST_SUCCEEDED")
        local now = Now()
        for key, entry in pairs(sessions) do CloseSession(key, entry, now) end
        sessions = {}
        -- Nothing is kept aside or watched while the journal is off.
        A.db.journalAside, A.db.journalQuests = nil, nil
        ResetQuestWatch()
        WatchParty(false)
    end
end

-- Journal text -------------------------------------------------------------
local function Duration(seconds)
    seconds = math.floor(tonumber(seconds) or 0)
    if seconds < 120 then return nil end
    local hours, minutes = math.floor(seconds / 3600), math.floor(seconds % 3600 / 60)
    if hours > 0 then
        return hours .. (hours == 1 and " hour" or " hours") .. (minutes > 0 and (" " .. minutes .. (minutes == 1 and " minute" or " minutes")) or "")
    end
    return minutes .. " minutes"
end
local function List(items)
    if #items <= 1 then return items[1] or "" end
    return table.concat(items, ", ", 1, #items - 1) .. " and " .. items[#items]
end
local function Quote(text) return "\226\128\156" .. text .. "\226\128\157" end

-- Sentences for one entry (first name only, like a diary would).
function A.JournalSentence(person, entry, group)
    local name = person.display or (person.name or ""):match("^[^%-]+") or "They"
    local zone = entry.z
    local k = entry.k
    if k == "group" then
        local length = entry.e and Duration(entry.e - entry.t)
        return "You travelled together" .. (zone and (" in " .. zone) or "") .. (length and (" for " .. length) or "") .. "."
    elseif k == "dungeon" then
        return "You ventured into " .. (entry.d or zone or "a dungeon") .. " side by side."
    elseif k == "boss" then
        local names = {}
        for _, item in ipairs(group or {entry}) do names[#names + 1] = item.d end
        return "Together you defeated " .. List(names) .. (zone and (" in " .. zone) or "") .. "."
    elseif k == "quest" then
        local titles = {}
        for _, item in ipairs(group or {entry}) do titles[#titles + 1] = Quote(item.d) end
        return "You completed " .. List(titles) .. " together."
    elseif k == "seen" then
        local times = (entry.c or 1) > 1 and (" (" .. entry.c .. " times)") or ""
        return "You crossed paths with " .. name .. (zone and (" in " .. zone) or "") .. times .. "."
    elseif k == "level" then
        return name .. " had grown to level " .. tostring(entry.d) .. "."
    elseif k == "mylevel" then
        return "You reached level " .. tostring(entry.d) .. "."
    elseif k == "campfire" then
        return "You shared a campfire with " .. name .. (zone and (" in " .. zone) or "") .. "."
    elseif k == "custom" then
        return Quote(entry.d or "")
    elseif k == "met" then
        local how = entry.how == "campfire" and " by a campfire" or entry.how == "group" and " while grouped" or ""
        return "You first met " .. name .. (zone and (" in " .. zone) or "") .. how .. "."
    elseif k == "added" then
        return "You wrote " .. name .. " into this journal."
    end
    return nil
end

-- Days, oldest first, each a list of {text, entry, custom} lines. Consecutive
-- quests (and bosses in the same place) read as one sentence.
function A.JournalChapters(person)
    local entries = {}
    if person.met then
        entries[#entries + 1] = {k = "met", t = person.met, z = person.metZone,
            how = person.metHow == "campfire" and "campfire" or "group", synthetic = true}
    elseif person.added then
        entries[#entries + 1] = {k = "added", t = person.added, synthetic = true}
    end
    for _, entry in ipairs(type(person.journal) == "table" and person.journal or {}) do entries[#entries + 1] = entry end
    -- Stable: entries from the same second keep the order they happened in.
    local order = {}
    for index, entry in ipairs(entries) do order[entry] = index end
    table.sort(entries, function(a, b)
        if (a.t or 0) ~= (b.t or 0) then return (a.t or 0) < (b.t or 0) end
        return order[a] < order[b]
    end)
    local days, current, day = {}, nil, nil
    local i = 1
    while i <= #entries do
        local entry = entries[i]
        local eve = A.JournalEvening and A.JournalEvening(entry.t or 0) or entry.t or 0
        local key = date and date("%Y-%m-%d", eve) or "?"
        if key ~= day then
            day = key
            current = {key = key, title = date and date("%A, %d %B %Y", eve) or key, lines = {}}
            days[#days + 1] = current
        end
        local group = {entry}
        if entry.k == "quest" or entry.k == "boss" then
            -- (the same evening-day as the chapter: play past midnight stays on its day)
            while entries[i + 1] and entries[i + 1].k == entry.k and entries[i + 1].z == entry.z
                and (date and date("%Y-%m-%d", A.JournalEvening and A.JournalEvening(entries[i + 1].t or 0) or entries[i + 1].t or 0) or "?") == day do
                i = i + 1
                group[#group + 1] = entries[i]
            end
        end
        local text = A.JournalSentence(person, entry, group)
        if text then current.lines[#current.lines + 1] = {text = text, entry = (not entry.synthetic) and entry or nil, custom = entry.k == "custom"} end
        i = i + 1
    end
    return days
end
