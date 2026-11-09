local addonName, A = ...
-- Companion Journal: the players and NPCs you want to remember, and a journal
-- of what you lived through together. It came out of Forever Names (1.10).
-- Alone it works with Blizzard's nameplates (a small icon beside the name);
-- with Forever Names installed, your people's display names and icons are
-- drawn on its labels instead. Settings are account-wide.
A.version = "1.12.5"
A.defaults = {enabled = true, colors = {}}
local function Public(value) return not issecretvalue or not issecretvalue(value) end
local function Text(value)
    return Public(value) and type(value) == "string" and value ~= "" and value or nil
end
local function Copy(value)
    if type(value) ~= "table" then return value end
    local out = {}
    for key, item in pairs(value) do out[key] = Copy(item) end
    return out
end

-- Forever Names, when installed and loaded (its API), or nil.
function A.Names()
    local api = ForeverNamesAPI
    if type(api) == "table" and type(api.version) == "number" and api.version >= 1 then return api end
    return nil
end

-- NPC ID from the unit's GUID ("Creature-0-1-2-3-<id>-<spawn>"). Nil when the
-- GUID is hidden from addons, or for players.
function A.NPCID(unit)
    local ok, guid = pcall(UnitGUID, unit)
    guid = ok and Text(guid)
    if not guid then return nil end
    local kind, id = guid:match("^(%a+)%-%d+%-%d+%-%d+%-%d+%-(%d+)")
    if kind == "Creature" or kind == "Vehicle" then return id end
    return nil
end

-- Another player of the other faction (not you, not neutral).
function A.IsEnemyPlayer(unit)
    local names = A.Names()
    if names and names.IsEnemyPlayer then return names.IsEnemyPlayer(unit) == true end
    local okPlayer, player = pcall(UnitIsPlayer, unit)
    if not okPlayer or not Public(player) or player ~= true then return false end
    local okMine, mine = pcall(UnitFactionGroup, "player")
    local okTheirs, theirs = pcall(UnitFactionGroup, unit)
    mine, theirs = okMine and Text(mine), okTheirs and Text(theirs)
    return mine ~= nil and theirs ~= nil and theirs ~= "Neutral" and theirs ~= mine
end

-- Every nameplate unit in view (the campfire scan looks at these).
function A.EachTrackedUnit(fn)
    if not C_NamePlate or not C_NamePlate.GetNamePlates then return end
    for _, plate in pairs(C_NamePlate.GetNamePlates()) do
        if not (plate.IsForbidden and plate:IsForbidden()) then
            local unit = plate.namePlateUnitToken or plate.unitToken or (plate.UnitFrame and plate.UnitFrame.unit)
            if type(unit) == "string" then fn(unit) end
        end
    end
end

-- Something about your people changed: our icons on Blizzard's plates, the
-- book, and Forever Names (when installed) draw again.
local listeners = {}
function A.Subscribe(fn)
    if type(fn) == "function" then listeners[#listeners + 1] = fn end
end
function A.Refresh()
    if A.RefreshPlateIcons then A.RefreshPlateIcons() end
    -- A companion's settings also affect your own story and other characters'
    -- displayed journals. Rebuild the visible prose without advancing Retell.
    if A.RefreshJournal then A.RefreshJournal() end
    for _, fn in ipairs(listeners) do pcall(fn) end
end
function A.SetOption(key, value)
    A.db[key] = value
    if A.UpdatePeopleHooks then A.UpdatePeopleHooks() end
    if A.UpdatePlateEvents then A.UpdatePlateEvents() end
    A.Refresh()
end

-- One-time copy from Forever Names (1.9 and earlier kept your people there).
-- Nothing is removed from Forever Names' saved settings. People you already
-- have here are kept; only the ones missing are copied.
local MOVED = {"peopleRename", "peopleIcons", "peopleIconPosition", "peopleNewGlyph", "peopleTooltip", "peopleLastSeen",
    "peopleMenu", "peopleAutoGroup", "peopleGroupIcon", "peopleGroupPrompt", "groupPromptStyle", "groupPromptPoint",
    "peopleAutoCampfire", "peopleCampfireIcon", "peopleJournal", "journalSeen", "journalQuests", "journalAside"}
local MOVED_COLORS = {"people", "groupmate", "acquaintance", "campfire"}
function A.AdoptForeverNames(db)
    if db.adoptedForeverNames then return false end
    local old = ForeverNamesDB
    if type(old) ~= "table" then return false end -- not loaded (yet): try again at login
    local fresh = not (type(db.people) == "table" and next(db.people))
    local copied = false
    for _, key in ipairs({"people", "peopleBlocked"}) do
        if type(old[key]) == "table" then
            db[key] = type(db[key]) == "table" and db[key] or {}
            for id, entry in pairs(old[key]) do
                if db[key][id] == nil then db[key][id] = Copy(entry); copied = true end
            end
        end
    end
    -- Options only onto a fresh list: yours win once you have your own.
    if fresh and copied then
        for _, key in ipairs(MOVED) do
            if old[key] ~= nil then db[key] = Copy(old[key]) end
        end
        db.colors = type(db.colors) == "table" and db.colors or {}
        if type(old.colors) == "table" then
            for _, key in ipairs(MOVED_COLORS) do
                if old.colors[key] then db.colors[key] = Copy(old.colors[key]) end
            end
        end
    end
    db.adoptedForeverNames = time and time() or true
    return copied
end

local events = CreateFrame("Frame")
events:RegisterEvent("ADDON_LOADED")
events:RegisterEvent("PLAYER_LOGIN")
local adopted = false
local function Setup()
    local db = A.db
    for key, value in pairs(A.defaults) do
        if key ~= "colors" and db[key] == nil then db[key] = Copy(value) end
    end
    db.colors = type(db.colors) == "table" and db.colors or {}
    for key, value in pairs(A.defaults.colors) do
        if not db.colors[key] then db.colors[key] = Copy(value) end
    end
    A.InitPeople()
    -- Lists are per character: the list from before moves to the first one.
    if A.InitCharacters then A.InitCharacters() end
end
events:SetScript("OnEvent", function(_, event, arg)
    if event == "ADDON_LOADED" then
        if arg ~= addonName then return end
        CompanionJournalDB = type(CompanionJournalDB) == "table" and CompanionJournalDB or {}
        A.db = CompanionJournalDB
        adopted = A.AdoptForeverNames(A.db)
        Setup()
        A.UpdatePeopleHooks()
        if A.UpdatePlateEvents then A.UpdatePlateEvents() end
    elseif event == "PLAYER_LOGIN" then
        -- Forever Names may load after us: its saved settings exist by now.
        if not A.db.adoptedForeverNames and A.AdoptForeverNames(A.db) then
            adopted = true
            Setup()
            A.UpdatePeopleHooks()
            if A.UpdatePlateEvents then A.UpdatePlateEvents() end
        end
        -- The name and faction are sure by now (and people copied just above move in).
        if A.InitCharacters then A.InitCharacters() end
        -- Your own journal needs your name: it starts here.
        if A.UpdateSelfJournalEvents then A.UpdateSelfJournalEvents() end
        if adopted then
            print("Companion Journal: your People list and journals were copied from Forever Names (nothing was removed there).")
        end
        if A.claimedWaiting then
            print("Companion Journal: " .. A.claimedWaiting .. (A.claimedWaiting == 1 and " person" or " people")
                .. " waiting for your first " .. (A.PlayerFaction() or "") .. " character joined " .. (A.CharacterName(A.Me()) or "this character")
                .. "'s list, with their journals.")
        end
        if A.movedToCharacter then
            print("Companion Journal: each character now has their own list. Your list and journals are now "
                .. (A.CharacterName(A.Me()) or "this character's") .. "'s. Your other characters can add people from it (People > My characters)."
                .. " Wrong character? Log in with the right one and type /cj movelist.")
        end
        A.db.cjLayout = nil -- (the list window, layout A, is gone since 1.16.0)
        if A.db.bookVariants then A.db.bookVariants.skin = nil end -- (one skin since 1.17.0)
        A.Refresh()
    end
end)

SLASH_COMPANIONJOURNAL1 = "/cj"
SLASH_COMPANIONJOURNAL2 = "/companionjournal"
SlashCmdList.COMPANIONJOURNAL = function(message)
    if not A.db then return end
    message = message or ""
    local command = message:lower():match("^%s*(%S+)") or ""
    if command == "journal" then
        -- /cj journal [name]: that person, or your target.
        local name = message:match("^%s*%S+%s+(.-)%s*$")
        local key
        if name and name ~= "" then key = A.PersonKey(name) else local _, found = A.FindPerson("target"); key = found end
        if key and (A.People[key] or #A.OtherJournals(key) > 0) then A.OpenJournal(key)
        else print("Companion Journal: no one by that name in your list.") end
    elseif command == "me" then
        -- /cj me: your own journal.
        if A.OpenSelfJournal then A.OpenSelfJournal() end
    elseif command == "movelist" then
        -- The list from before went to the first character who logged in:
        -- move it to this one (only while this one has nobody yet).
        local from = A.db.charactersFirst
        local hasPlayers = false
        for _, person in A.EachPerson() do if not person.npc then hasPlayers = true; break end end
        if not from or from == A.Me() then
            print("Companion Journal: the list from before is already this character's.")
        elseif hasPlayers then
            print("Companion Journal: " .. A.CharacterName(A.Me()) .. " already has people of their own. Add people from "
                .. A.CharacterName(from) .. " under People > My characters instead.")
        else
            local moved = A.MoveListHere(from)
            print("Companion Journal: moved " .. moved .. (moved == 1 and " person" or " people") .. " and their journals from "
                .. A.CharacterName(from) .. " to " .. A.CharacterName(A.Me()) .. ".")
        end
    elseif command == "book" then
        if A.OpenBook then A.OpenBook() end
    elseif command == "artboard" then
        -- /cj artboard: the game's candidate art for the book, with names (for choosing).
        if A.BookArtboard then A.BookArtboard() end
    elseif command == "tag" then
        A.AddTargetPerson(message:match("^%s*%S+%s+(.-)%s*$"))
    elseif command == "testleave" then
        -- Test the group popup: /cj testleave [count] or /cj testleave me
        local count = message:lower():match("^%s*testleave%s+(%S+)")
        if count == "me" then A.SimulateGroupLeave(5, true) else A.SimulateGroupLeave(tonumber(count) or 1) end
    elseif A.OpenBook then
        -- (a targeted player from your list opens straight to their journal)
        A.OpenBook()
    end
end
