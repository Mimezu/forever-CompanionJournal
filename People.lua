local _, A = ...
-- People: the players (and NPCs) you want to remember. Each character has
-- its own list (Characters.lua); a person's card (display name, icon and
-- color, note, when and where you last saw them) is shared by all of them.
-- Every display feature is its own toggle (all off by default). Lookups are a
-- few table reads per plate, and only while one of them is on.
local function Public(value) return not issecretvalue or not issecretvalue(value) end
local function Text(value)
    return Public(value) and type(value) == "string" and value ~= "" and value or nil
end

A.defaults.peopleRename, A.defaults.peopleIcons = false, false
A.defaults.peopleTooltip, A.defaults.peopleLastSeen, A.defaults.peopleMenu = false, false, false
A.defaults.colors.people = {1, 0.55, 0.85}
-- Categories: companions (added by you), acquaintances (auto-added from your
-- groups, or moved there), and NPCs (always their own category).
A.defaults.peopleAutoGroup = false
-- Groupmates added automatically get the group icon (theirs to change after).
A.defaults.peopleGroupIcon = true
A.defaults.colors.groupmate = {0.55, 0.8, 1}
-- Icon given to entries you add ("none" = no icon); per person after.
A.defaults.peopleNewGlyph = "diamond"
local function NewGlyph()
    local glyph = A.db.peopleNewGlyph
    return type(glyph) == "string" and glyph or "diamond"
end
A.defaults.colors.acquaintance = {0.72, 0.72, 0.72}
-- "none" = tracked without an icon. Acquaintances start without one.
local DEFAULT_GLYPH, ACQUAINTANCE_GLYPH = "heart", "none"
-- Player categories besides companions (the default): acquaintances (from
-- groups) and campfire (sat at a campfire with you; experimental).
local circles = {acquaintance = true, campfire = true, rival = true}
function A.PersonCircle(person)
    if person.npc then return "npc" end
    return circles[person.circle] and person.circle or "companion"
end
local function Tracked(person)
    local circle = A.PersonCircle(person)
    return circle == "acquaintance" or circle == "campfire"
end
function A.PersonDefaultGlyph(person)
    return Tracked(person) and ACQUAINTANCE_GLYPH or DEFAULT_GLYPH
end
function A.PersonDefaultColor(person)
    return Tracked(person) and A.db.colors.acquaintance or A.db.colors.people
end
function A.MovePerson(key, circle)
    local person = A.People[key]
    if not person or person.npc then return end
    person.circle = circles[circle] and circle or nil
    if A.Refresh then A.Refresh() end
end

function A.InitPeople()
    local db = A.db
    db.people = type(db.people) == "table" and db.people or {}
    -- Never added automatically again (group or campfire). Adding by hand clears it.
    db.peopleBlocked = type(db.peopleBlocked) == "table" and db.peopleBlocked or {}
    -- 1.8.4-1.8.13 stored an on/off; "off" meant no icon.
    if db.peopleNewIcon == false then db.peopleNewGlyph = "none" end
    db.peopleNewIcon = nil
end
function A.PeopleActive()
    local db = A.db
    return db.peopleRename or db.peopleIcons or db.peopleTooltip or db.peopleLastSeen
end

local function HomeRealm()
    return Text(GetNormalizedRealmName and GetNormalizedRealmName()) or Text(GetRealmName and GetRealmName()) or ""
end
-- "Name-Realm", realm without spaces; the key is the lower-cased form.
function A.PersonKey(name, realm)
    name = Text(name)
    if not name then return nil end
    local base, suffix = name:match("^([^%-]+)%-(.+)$")
    if base then name, realm = base, suffix end
    realm = (Text(realm) or HomeRealm()):gsub("%s", "")
    local full = name .. (realm ~= "" and ("-" .. realm) or "")
    return full:lower(), full
end
function A.UnitPersonKey(unit)
    if not UnitFullName then return nil end
    local ok, name, realm = pcall(UnitFullName, unit)
    if not ok or not Public(name) or not Public(realm) then return nil end
    return A.PersonKey(name, realm)
end
-- NPCs are keyed by NPC ID: many NPCs share a name.
function A.NPCKey(id) return id and ("npc:" .. id) or nil end
function A.UnitKey(unit)
    local ok, player = pcall(UnitIsPlayer, unit)
    if ok and Public(player) and player == true then return A.UnitPersonKey(unit) end
    return A.NPCKey(A.NPCID and A.NPCID(unit))
end
-- The person for a unit: from this character's list, or (recognized) from
-- another character's while that is on.
function A.FindPerson(unit)
    local people = A.db.people
    if not people or next(people) == nil then return nil end
    local key = A.UnitKey(unit)
    if not key then return nil end
    return A.People[key] or (A.Recognize and A.Recognize(key)), key
end
-- The People list's right-click menu is the addon's own. Blizzard's context
-- menus opened from addon code run the gamepad window manager under addon
-- taint (gamepad A and B dead until /reload, seen 2026-09-27). This one is a
-- leather panel with the Legacy rim: rows the mouse or the gamepad cursor
-- clicks; Escape, or a click anywhere else, closes it.
local personMenu = {open = false}
A.PersonMenu = personMenu -- (tests)
local MENU_ROW, MENU_PAD, MENU_MIN_W = 20, 8, 170

local function ClosePersonMenu()
    if personMenu.panel then personMenu.panel:Hide() end
    if personMenu.catcher then personMenu.catcher:Hide() end
    personMenu.open, personMenu.owner, personMenu.key = false, nil, nil
end
personMenu.Close = ClosePersonMenu

local function PersonMenuPanel()
    if personMenu.panel then return personMenu.panel end
    -- Covers the screen under the menu: a click anywhere else closes it. Escape
    -- too, when the keyboard can be taken (not in combat); other keys pass through.
    local catcher = CreateFrame("Frame", nil, UIParent)
    catcher:SetFrameStrata("FULLSCREEN_DIALOG"); catcher:SetFrameLevel(90)
    catcher:SetAllPoints(UIParent); catcher:EnableMouse(true)
    catcher:SetScript("OnMouseDown", ClosePersonMenu)
    catcher:SetScript("OnKeyDown", function(self, key)
        if key == "ESCAPE" then
            pcall(self.SetPropagateKeyboardInput, self, false)
            ClosePersonMenu()
        else
            pcall(self.SetPropagateKeyboardInput, self, true)
        end
    end)
    catcher:Hide()
    local panel = CreateFrame("Frame", nil, UIParent, "BackdropTemplate")
    panel:SetFrameStrata("FULLSCREEN_DIALOG"); panel:SetFrameLevel(100)
    panel:EnableMouse(true); panel:SetClampedToScreen(true)
    if A.OptionsSkin and A.OptionsSkin.Panel then A.OptionsSkin.Panel(panel) end
    panel.rows = {}
    panel:Hide()
    personMenu.panel, personMenu.catcher = panel, catcher
    return panel
end

local function PersonMenuRow(panel, i)
    local row = panel.rows[i]
    if row then return row end
    row = CreateFrame("Button", nil, panel)
    row:SetHeight(MENU_ROW)
    row.text = row:CreateFontString(nil, "ARTWORK", "GameFontHighlight")
    row.text:SetPoint("LEFT", 12, 0); row.text:SetPoint("RIGHT", -12, 0)
    row.text:SetJustifyH("LEFT"); row.text:SetWordWrap(false)
    row.hover = row:CreateTexture(nil, "HIGHLIGHT")
    row.hover:SetPoint("TOPLEFT", 4, 0); row.hover:SetPoint("BOTTOMRIGHT", -4, 0)
    row.hover:SetColorTexture(1, 0.8, 0.4, 0.12)
    row.line = row:CreateTexture(nil, "ARTWORK")
    row.line:SetPoint("LEFT", 8, 0); row.line:SetPoint("RIGHT", -8, 0)
    row.line:SetHeight(1); row.line:SetColorTexture(0.68, 0.50, 0.26, 0.45)
    row:SetScript("OnClick", function(self)
        local entry = self.entry
        if not entry or entry.disabled or entry.title or entry.divider then return end
        ClosePersonMenu()
        if entry.func then entry.func() end
    end)
    panel.rows[i] = row
    return row
end

-- entries: {title = text}, {divider = true}, {text, func, disabled}
local function ShowPersonMenu(owner, key, entries)
    local panel = PersonMenuPanel()
    local width, top = MENU_MIN_W, MENU_PAD
    for i, entry in ipairs(entries) do
        local row = PersonMenuRow(panel, i)
        row.entry = entry
        local kind = entry.divider and "divider" or entry.title and "title" or "item"
        local height = kind == "divider" and 9 or MENU_ROW
        row:ClearAllPoints()
        row:SetPoint("TOPLEFT", 0, -top); row:SetPoint("TOPRIGHT", 0, -top)
        row:SetHeight(height)
        row:EnableMouse(kind == "item")
        row.line:SetShown(kind == "divider")
        row.text:SetShown(kind ~= "divider")
        row.text:SetText(entry.text or entry.title or "")
        row.text:SetFontObject(kind == "title" and "GameFontNormal" or "GameFontHighlight")
        if kind == "title" then row.text:SetTextColor(1, 0.82, 0)
        elseif entry.disabled then row.text:SetTextColor(0.5, 0.5, 0.5)
        else row.text:SetTextColor(1, 1, 1) end
        row.hover:SetShown(kind == "item" and not entry.disabled)
        width = math.max(width, (tonumber(row.text:GetStringWidth()) or 0) + 24)
        top = top + height
        row:Show()
    end
    for i = #entries + 1, #panel.rows do panel.rows[i]:Hide() end
    panel:SetSize(width, top + MENU_PAD)
    personMenu.open, personMenu.owner, personMenu.key = true, owner, key
    if not owner.companionJournalMenuHook then
        owner.companionJournalMenuHook = true
        owner:HookScript("OnHide", function() if personMenu.owner == owner then ClosePersonMenu() end end)
    end
    if not InCombatLockdown() then
        pcall(personMenu.catcher.EnableKeyboard, personMenu.catcher, true)
        pcall(personMenu.catcher.SetPropagateKeyboardInput, personMenu.catcher, true)
    end
    personMenu.catcher:Show()
    panel:ClearAllPoints()
    panel:SetPoint("TOPLEFT", owner, "BOTTOMLEFT", 0, -2)
    panel:Show()
end

-- Capture the character name when opening: list rows can be reused by search,
-- paging, or selection changes while the menu is still open.
function A.OpenPersonMenu(owner, key)
    local person = key and (A.People[key] or A.Recognize(key))
    local name = person and not person.npc and Text(person.name)
    if not name then ClosePersonMenu(); return end
    -- The same row closes the menu it opened.
    if personMenu.open and personMenu.owner == owner and personMenu.key == key then ClosePersonMenu(); return end
    ClosePersonMenu()
    local addFriend = C_FriendList and C_FriendList.AddFriend
    local whisper = (ChatFrameUtil and ChatFrameUtil.SendTell) or ChatFrame_SendTell
    local invite = C_PartyInfo and C_PartyInfo.InviteUnit
    -- Whisper focuses the chat box from addon code; in the gamepad interface
    -- that makes Blizzard's gamepad focus code run tainted (seen 2026-09-27),
    -- so it stays off there.
    local gamepad = A.GamepadUI and A.GamepadUI() or false
    local entries = {
        {title = name},
        {text = ADD_FRIEND or "Add Friend", func = function() addFriend(name) end, disabled = addFriend == nil},
        {text = WHISPER or "Whisper", func = function() whisper(name) end, disabled = whisper == nil or gamepad},
        {text = "Invite to Group", func = function() invite(name) end, disabled = invite == nil},
    }
    if A.OpenJournal and (A.People[key] or #A.OtherJournals(key) > 0) then
        entries[#entries + 1] = {divider = true}
        entries[#entries + 1] = {text = "Open journal", func = function() A.OpenJournal(key) end}
    end
    ShowPersonMenu(owner, key, entries)
end
function A.AddNPCPerson(id, name, fields)
    local key = A.NPCKey(id)
    if not key then return nil end
    local person = A.People[key]
    if not person then
        -- Marked "this character only" by another character: everyone's again.
        local card = A.db.people[key]
        if type(card) == "table" then card.only = nil end
        person = A.People[key] or A.NewPerson(key, {name = Text(name) or ("NPC " .. id), npc = true, added = time and time() or nil, glyph = NewGlyph()})
    end
    for field, value in pairs(fields or {}) do person[field] = value end
    if A.Refresh then A.Refresh() end
    return person, key
end

function A.AddPerson(name, realm, fields)
    local key, full = A.PersonKey(name, realm)
    if not key then return nil end
    local person = A.People[key]
    if not person then
        person = A.NewPerson(key, {name = full, added = time and time() or nil, glyph = NewGlyph(), faction = A.PlayerFaction()})
    end
    -- Adding someone yourself makes them a companion, and allows them again.
    person.circle = nil
    A.db.peopleBlocked[key] = nil
    for field, value in pairs(fields or {}) do person[field] = value end
    -- A groupmate you add: what the journal kept aside starts their journal.
    if A.JournalAdopt then A.JournalAdopt(person, key) end
    if A.Refresh then A.Refresh() end
    return person, key
end
-- From this character's list (your other characters keep them).
function A.RemovePerson(key)
    A.People[key] = nil
    if A.Refresh then A.Refresh() end
end
-- Remove a player and never add them automatically again.
function A.BlockPerson(key)
    local db = A.db
    local person = A.People[key]
    if not person or person.npc then return end
    db.peopleBlocked[key] = {name = person.name, blocked = time and time() or nil}
    A.People[key] = nil
    if A.Refresh then A.Refresh() end
end
function A.UnblockPerson(key)
    A.db.peopleBlocked[key] = nil
    if A.Refresh then A.Refresh() end
end
function A.DescribeBlocked(entry)
    local when = entry.blocked and date and date("%Y-%m-%d", entry.blocked)
    return when and ("Never added automatically since " .. when) or "Never added automatically"
end
function A.RemoveCircle(circle)
    for key, person in A.EachPerson() do
        if A.PersonCircle(person) == circle then A.People[key] = nil end
    end
    if A.Refresh then A.Refresh() end
end
function A.RemoveAcquaintances() A.RemoveCircle("acquaintance") end

-- Campfire (experimental): while your campfire timer aura runs, friendly
-- players near you who have the same aura are sitting with you. A few scans
-- during your one-minute sit, over plates already tracked; nothing otherwise.
A.defaults.peopleAutoCampfire = false
-- People added at a campfire get the fire icon (theirs to change after). On by
-- default: it only matters once the experimental campfire option is on.
A.defaults.peopleCampfireIcon = true
A.defaults.colors.campfire = {1, 0.55, 0.15}
local CAMPFIRE_AURAS = {[1229739] = true} -- Welcoming Campfire (build 70009)
local function CampfireAuraIDs()
    local ids = {}
    for id in pairs(CAMPFIRE_AURAS) do ids[#ids + 1] = id end
    -- Frame Gambit can learn other campfire variants (/fg campfire).
    local learned = type(FrameGambitDB) == "table" and FrameGambitDB.campfireAuras
    if type(learned) == "table" then
        for id in pairs(learned) do if type(id) == "number" and not CAMPFIRE_AURAS[id] then ids[#ids + 1] = id end end
    end
    return ids
end
local function AtCampfire(unit, ids)
    if not C_UnitAuras or not C_UnitAuras.GetUnitAuraBySpellID then return false end
    for _, id in ipairs(ids) do
        local ok, aura = pcall(C_UnitAuras.GetUnitAuraBySpellID, unit, id)
        if ok and aura ~= nil and Public(aura) then return true end
    end
    return false
end
function A.ScanCampfire()
    local db = A.db
    if not db.peopleAutoCampfire or not db.enabled or not A.EachTrackedUnit then return 0 end
    local ids = CampfireAuraIDs()
    if not AtCampfire("player", ids) then return 0 end
    if A.SelfCampfire then A.SelfCampfire() end -- your own journal: you sat by a fire
    local now, zone, added = time and time() or nil, Text(GetRealZoneText and GetRealZoneText()), 0
    A.EachTrackedUnit(function(unit)
        local okPlayer, isPlayer = pcall(UnitIsPlayer, unit)
        local okFriend, friend = pcall(UnitIsFriend, "player", unit)
        if not okPlayer or not okFriend or not Public(isPlayer) or not Public(friend) or isPlayer ~= true or friend ~= true then return end
        if not AtCampfire(unit, ids) then return end
        -- About 28 yards: the same fire, not the next camp over. Unknown = accept.
        if CheckInteractDistance then
            local okNear, near = pcall(CheckInteractDistance, unit, 4)
            if okNear and Public(near) and near == false then return end
        end
        local ok, name, realm = pcall(UnitFullName, unit)
        if not ok or not Public(name) or not Public(realm) then return end
        local key, full = A.PersonKey(name, realm)
        local known = key and A.People[key]
        if known and A.JournalCampfire then A.JournalCampfire(known) end
        if key and not known and not db.peopleBlocked[key] then
            local fields = {name = full, circle = "campfire", added = now, met = now, metZone = zone, metHow = "campfire"}
            if db.peopleCampfireIcon then
                local fire = db.colors.campfire
                fields.glyph, fields.color = "fire", {fire[1], fire[2], fire[3]}
            end
            local person = A.NewPerson(key, fields)
            A.UpdatePersonFromUnit(person, unit)
            if A.JournalAdopt then A.JournalAdopt(person, key) end
            added = added + 1
        end
    end)
    if added > 0 and A.Refresh then A.Refresh() end
    return added
end
local campfireEvents = CreateFrame("Frame")
local sitting = false
local SCAN_TIMES = {3, 15, 30, 45, 57}
campfireEvents:SetScript("OnEvent", function()
    local now = AtCampfire("player", CampfireAuraIDs())
    if now and not sitting then
        sitting = true
        for _, delay in ipairs(SCAN_TIMES) do
            C_Timer.After(delay, function() if sitting then A.ScanCampfire() end end)
        end
    elseif not now then
        sitting = false
    end
end)
function A.UpdateCampfireEvents()
    if A.db.peopleAutoCampfire and A.db.enabled then
        campfireEvents:RegisterUnitEvent("UNIT_AURA", "player")
    else
        campfireEvents:UnregisterEvent("UNIT_AURA")
        sitting = false
    end
end

-- Acquaintances: everyone you group with, recorded when the group changes.
local groupEvents = CreateFrame("Frame")
local groupPending = false
-- An acquaintance entry for someone you grouped with (automatic, or chosen in
-- the group prompt).
function A.AddGroupAcquaintance(entry)
    local db = A.db
    local key, full = A.PersonKey(entry.name, nil)
    if not key or A.People[key] then return nil end
    local fields = {name = full, circle = "acquaintance", added = time and time() or nil,
        met = entry.met or (time and time()), metZone = entry.zone}
    if db.peopleGroupIcon then
        local tint = db.colors.groupmate
        fields.glyph, fields.color = "party", {tint[1], tint[2], tint[3]}
    end
    local person = A.NewPerson(key, fields)
    A.UpdatePersonFromEntry(person, entry)
    if A.JournalAdopt then A.JournalAdopt(person, key) end
    if A.Refresh then A.Refresh() end
    return person, key
end
function A.RecordGroup()
    local db = A.db
    if not db or not db.peopleAutoGroup or not db.enabled or not GetNumGroupMembers then return 0 end
    -- "Ask when they leave" replaces adding right away.
    if db.peopleGroupPrompt then return 0 end
    local raid = IsInRaid and IsInRaid() == true
    local members = tonumber(GetNumGroupMembers()) or 0
    local now = time and time() or nil
    local zone = Text(GetRealZoneText and GetRealZoneText())
    local added = 0
    for i = 1, raid and members or math.max(0, members - 1) do
        local unit = (raid and "raid" or "party") .. i
        local okSelf, isSelf = pcall(UnitIsUnit, unit, "player")
        local okPlayer, isPlayer = pcall(UnitIsPlayer, unit)
        if okSelf and okPlayer and Public(isSelf) and Public(isPlayer) and not isSelf and isPlayer == true and UnitFullName then
            local ok, name, realm = pcall(UnitFullName, unit)
            local key, full = nil, nil
            if ok and Public(name) and Public(realm) then key, full = A.PersonKey(name, realm) end
            if key and not A.People[key] and not db.peopleBlocked[key] then
                local fields = {name = full, circle = "acquaintance", added = now, met = now, metZone = zone}
                if db.peopleGroupIcon then
                    local tint = db.colors.groupmate
                    fields.glyph, fields.color = "party", {tint[1], tint[2], tint[3]}
                end
                local person = A.NewPerson(key, fields)
                A.UpdatePersonFromUnit(person, unit)
                if A.JournalAdopt then A.JournalAdopt(person, key) end
                added = added + 1
            end
        end
    end
    if added > 0 and A.Refresh then A.Refresh() end
    return added
end
groupEvents:SetScript("OnEvent", function()
    if groupPending then return end
    groupPending = true
    C_Timer.After(1, function()
        groupPending = false
        if A.db.peopleGroupPrompt then A.TrackGroupRoster() else A.RecordGroup() end
    end)
end)
function A.AddTargetPerson(note)
    local fields = note and note ~= "" and {note = note} or nil
    local ok, player = pcall(UnitIsPlayer, "target")
    if ok and Public(player) and player ~= true then
        local id = A.NPCID and A.NPCID("target")
        if not id then
            print("Companion Journal: target a player or an NPC first.")
            return nil
        end
        local okName, name = pcall(UnitName, "target")
        local person, key = A.AddNPCPerson(id, okName and name or nil, fields)
        if person then print("Companion Journal: added " .. person.name .. " (NPC) to your list.") end
        return person, key
    end
    if not ok or not Public(player) then
        print("Companion Journal: target a player or an NPC first.")
        return nil
    end
    local key = A.UnitPersonKey("target")
    if not key then
        print("Companion Journal: the game hides this player's identity here.")
        return nil
    end
    local _, name, realm = pcall(UnitFullName, "target")
    local person
    person, key = A.AddPerson(name, realm, fields)
    if person then A.UpdatePersonFromUnit(person, "target", true) end
    -- Opposite-faction players go to Rivals.
    if person and A.IsEnemyPlayer and A.IsEnemyPlayer("target") then person.circle = "rival"; if A.Refresh then A.Refresh() end end
    if person then print("Companion Journal: added " .. person.name .. (person.circle == "rival" and " to Rivals." or " to your list.")) end
    return person, key
end

-- Faction, class and last known level: read whenever a known player is seen
-- (plate, group, target). Forever is Horde vs Alliance; the list hides the
-- other faction. Cheap reads, only for people already in the list.
function A.PlayerFaction()
    local ok, faction = pcall(UnitFactionGroup, "player")
    return ok and Text(faction) or nil
end
local unitInfoAt = setmetatable({}, {__mode = "k"})
function A.UpdatePersonFromUnit(person, unit, force)
    if not person or person.npc or not unit then return end
    -- Plates re-render often; a known person's details are read every 5 minutes at most.
    local now = GetTime and GetTime() or 0
    if not force and unitInfoAt[person] and now - unitInfoAt[person] < 300 then return end
    unitInfoAt[person] = now
    local okFaction, faction = pcall(UnitFactionGroup, unit)
    faction = okFaction and Text(faction)
    if faction == "Horde" or faction == "Alliance" then person.faction = faction end
    local okClass, _, class = pcall(UnitClass, unit)
    class = okClass and Text(class)
    if class then person.class = class end
    -- Their people (the storyteller knows their homeland).
    local okRace, _, race = pcall(UnitRace, unit)
    race = okRace and Text(race)
    if race then person.race = race end
    local okLevel, level = pcall(UnitLevel, unit)
    level = okLevel and Public(level) and tonumber(level)
    if level and level > 0 then A.NotePersonLevel(person, level) end
end
-- Level only grows; the journal notes the levels you witnessed.
function A.NotePersonLevel(person, level)
    level = tonumber(level)
    if not level or level <= 0 then return end
    local old = tonumber(person.level)
    if old and level > old and A.JournalLevel then A.JournalLevel(person, level) end
    if not old or level >= old then person.level = level end
end
-- Pronouns for the journal's storyteller: "they" unless you choose "he" or
-- "she" for them (People > their card).
local PRONOUNS = {
    they = {they = "they", them = "them", their = "their", theirs = "theirs", self = "themselves", was = "were", is = "are", has = "have"},
    he = {they = "he", them = "him", their = "his", theirs = "his", self = "himself", was = "was", is = "is", has = "has"},
    she = {they = "she", them = "her", their = "her", theirs = "hers", self = "herself", was = "was", is = "is", has = "has"},
}
function A.PersonPronouns(person)
    return PRONOUNS[person and person.pronouns or "they"] or PRONOUNS.they
end
-- For the storyteller: how it began ("together": you started your characters
-- together) and what they are to you (spouse, partner, friend, family).
function A.SetPersonStory(person, field, value)
    if not person or person.npc then return end
    if field == "origin" then person.origin = value == "together" and "together" or nil
    elseif field == "bond" then
        person.bond = (value == "spouse" or value == "partner" or value == "friend" or value == "family") and value or nil
    end
    A.Refresh()
end
function A.SetPersonPronouns(person, value)
    if not person then return end
    person.pronouns = (value == "he" or value == "she") and value or nil
    A.Refresh()
end
-- Group entries (roster reads) carry class/level; groupmates share your faction.
function A.UpdatePersonFromEntry(person, entry)
    if not person or person.npc or not entry then return end
    if entry.class then person.class = entry.class end
    if entry.race then person.race = entry.race end
    if entry.level then A.NotePersonLevel(person, entry.level) end
    person.faction = entry.faction or person.faction or A.PlayerFaction()
end

-- Called while a known player's plate renders: remember when and where.
local SEEN_INTERVAL = 300
function A.NotePersonSeen(person, unit)
    if unit then A.UpdatePersonFromUnit(person, unit) end
    if A.JournalSeen then A.JournalSeen(person) end
    if not A.db.peopleLastSeen or not time then return end
    local now = time()
    if person.seen and now - person.seen < SEEN_INTERVAL then return end
    person.seen = now
    person.zone = Text(GetRealZoneText and GetRealZoneText()) or person.zone
end
function A.DescribeMet(person)
    if not person.met then return nil end
    local when = date and date("%Y-%m-%d", person.met) or tostring(person.met)
    local how = person.metHow == "campfire" and " (by the campfire)" or " (grouped)"
    return "Met " .. when .. (person.metZone and (", " .. person.metZone) or "") .. how
end
-- "Alberich's companion": someone another character of yours knows.
local CIRCLE_WORDS = {acquaintance = "acquaintance", campfire = "campfire acquaintance", rival = "rival"}
function A.RecognizedLabel(person)
    local by = person.recognizedBy
    if not by then return nil end
    return by .. "'s " .. (CIRCLE_WORDS[person.circle] or "companion")
end
function A.DescribeSeen(person)
    if not person.seen then return nil end
    local when = date and date("%Y-%m-%d", person.seen) or tostring(person.seen)
    return person.zone and (when .. ", " .. person.zone) or when
end

-- Tooltip note: one post-call, installed the first time the option is on.
local tooltipHooked = false
function A.UpdatePeopleHooks()
    local db = A.db
    A.UpdateCampfireEvents()
    if db.peopleTooltip and not tooltipHooked and TooltipDataProcessor and Enum and Enum.TooltipDataType then
        tooltipHooked = true
        TooltipDataProcessor.AddTooltipPostCall(Enum.TooltipDataType.Unit, function(tooltip)
            if not A.db.peopleTooltip or not A.db.enabled or not tooltip.GetUnit then return end
            local ok, _, unit = pcall(tooltip.GetUnit, tooltip)
            if not ok or not Public(unit) or type(unit) ~= "string" then return end
            local person = A.FindPerson(unit)
            -- Tooltip lines for anyone with a note or a "last seen" record.
            if not person then return end
            local hasNote = person.note and person.note ~= ""
            local seen = A.db.peopleLastSeen and A.DescribeSeen(person)
            if not hasNote and not seen and not person.recognizedBy then return end
            local glyph = A.IconGlyph("people", person)
            local icon = glyph ~= "none" and ("|T" .. A.GlyphPath(glyph) .. ":0|t ") or ""
            tooltip:AddLine(icon .. (person.display or person.name), 1, 0.82, 0)
            if person.recognizedBy then tooltip:AddLine(A.RecognizedLabel(person), 0.6, 0.6, 0.6) end
            if hasNote then tooltip:AddLine(person.note, 1, 1, 1, true) end
            if seen then tooltip:AddLine("Last seen " .. seen, 0.6, 0.6, 0.6) end
        end)
    end
    if db.peopleMenu then A.InstallPeopleMenu() end
    if A.UpdateJournalEvents then A.UpdateJournalEvents() end
    if A.UpdateSelfJournalEvents then A.UpdateSelfJournalEvents() end
    if db.peopleAutoGroup and db.enabled then
        groupEvents:RegisterEvent("GROUP_ROSTER_UPDATE")
        -- Ask mode remembers the current group without asking; nobody left yet.
        if db.peopleGroupPrompt then A.TrackGroupRoster(true) else A.RecordGroup() end
    else
        groupEvents:UnregisterEvent("GROUP_ROSTER_UPDATE")
        if A.ClearGroupPrompt then A.ClearGroupPrompt(true) end
    end
end

function A.GamepadUI()
    return InputUtil and InputUtil.IsGamepadUIEnabled and InputUtil.IsGamepadUIEnabled() == true or false
end

-- Key binding (Bindings.xml): works with keyboard and gamepad alike, in its
-- own section of Key Bindings (the settings look the category up in _G). It
-- keeps the name it had in Forever Names, so a key you bound still works.
BINDING_CATEGORY_COMPANIONJOURNAL = "Companion Journal"
BINDING_NAME_FOREVERNAMES_TAG_TARGET = "Add target to Companion Journal"
function CompanionJournal_TagTarget()
    if A.db and A.AddTargetPerson then A.AddTargetPerson() end
end

-- Right-click entry on player menus: installed the first time it is enabled.
local menuInstalled = false
local menuTags = {"MENU_UNIT_PLAYER", "MENU_UNIT_PARTY", "MENU_UNIT_RAID_PLAYER", "MENU_UNIT_FRIEND", "MENU_UNIT_TARGET",
    "MENU_UNIT_ENEMY_PLAYER"}
-- This runs inside Blizzard's menu generator (the only way to add to the unit
-- menu): a few table reads and unit lookups, nothing more, and never an error.
local function AddUnitMenuEntries(root, context)
    if not A.db or not A.db.peopleMenu or not A.db.enabled or type(context) ~= "table" then return end
    -- In the gamepad interface, closing a menu after an addon entry ran
    -- makes Blizzard's gamepad focus code call a protected function
    -- (SetPreferredGamepadInteractTarget) and the game blocks it. Use the
    -- "Add target to Companion Journal" key binding there instead.
    if A.GamepadUI() then return end
    local name, realm = context.name, context.server
    local npcID
    if context.unit then
        local okPlayer, player = pcall(UnitIsPlayer, context.unit)
        if okPlayer and Public(player) and player == false then
            npcID = A.NPCID and A.NPCID(context.unit)
            if not npcID then return end
            local okName, unitName = pcall(UnitName, context.unit)
            name = okName and unitName or nil
        elseif UnitFullName then
            local ok, unitName, unitRealm = pcall(UnitFullName, context.unit)
            if ok then name, realm = unitName, unitRealm end
        end
    end
    local key = npcID and A.NPCKey(npcID) or A.PersonKey(name, realm)
    if not key then return end
    root:CreateDivider()
    if A.People[key] or A.Recognize(key) then
        root:CreateButton("Edit in Companion Journal", function()
            A.OpenOptions(); A.SelectPerson(key)
        end)
    else
        root:CreateButton("Add to Companion Journal", function()
            if npcID then A.AddNPCPerson(npcID, name)
            else
                local person = A.AddPerson(name, realm)
                if person and context.unit and A.IsEnemyPlayer(context.unit) then person.circle = "rival"; A.Refresh() end
            end
            A.OpenOptions(); A.SelectPerson(key)
        end)
    end
end
function A.InstallPeopleMenu()
    if menuInstalled or not Menu or not Menu.ModifyMenu then return end
    menuInstalled = true
    for _, tag in ipairs(menuTags) do
        Menu.ModifyMenu(tag, function(_, root, context) pcall(AddUnitMenuEntries, root, context) end)
    end
end
