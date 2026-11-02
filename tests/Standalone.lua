-- Run from the client root: lua Interface/AddOns/CompanionJournal/tests/Standalone.lua
-- Companion Journal on its own (no Forever Names): the one-time copy of your
-- people from Forever Names' saved settings, the small icon beside Blizzard's
-- names, and the API Forever Names uses when both are installed.
local root = "Interface/AddOns/CompanionJournal/"
local assertions = 0
local function check(value, message) assertions = assertions + 1; assert(value, message) end
local function equal(a, b, message) check(a == b, message .. " (got " .. tostring(a) .. ", expected " .. tostring(b) .. ")") end

-- Minimal frame and texture mocks.
local frames = {}
local function Region()
    local r = {shown = true, points = {}}
    function r:SetPoint(...) self.points[#self.points + 1] = {...} end
    function r:ClearAllPoints() self.points = {} end
    function r:SetSize(w, h) self.width, self.height = w, h end
    function r:SetTexture(path) self.texturePath = path end
    function r:SetVertexColor(red, g, b) self.tint = {red, g, b} end
    function r:Show() self.shown = true end
    function r:Hide() self.shown = false end
    function r:IsShown() return self.shown end
    function r:SetAllPoints() end
    function r:EnableMouse() end
    function r:GetTextColor() return 1, 0.2, 0.2 end
    return r
end
function CreateFrame(_, _, parent)
    local f = Region()
    f.parent, f.scripts, f.events = parent, {}, {}
    function f:SetScript(key, fn) self.scripts[key] = fn end
    function f:RegisterEvent(event) self.events[event] = true end
    function f:UnregisterEvent(event) self.events[event] = nil end
    function f:RegisterUnitEvent(event) self.events[event] = true end
    function f:CreateTexture() local t = Region(); f.textures = f.textures or {}; f.textures[#f.textures + 1] = t; return t end
    frames[#frames + 1] = f
    return f
end
UIParent = CreateFrame("Frame")
local clock = 1000000
function time() return clock end
function GetTime() return clock end
function date(fmt, t) return os.date(fmt, t or clock) end
function GetRealZoneText() return "Durotar" end
function GetNormalizedRealmName() return "Forever" end
C_Timer = {After = function(_, fn) fn() end}
SlashCmdList = {}
local printed = {}
print = function(...) printed[#printed + 1] = table.concat({...}, " ") end

-- Units and nameplates.
local units = {}
local plates = {}
function UnitIsPlayer(unit) local u = units[unit]; return u ~= nil and u.player == true end
function UnitFullName(unit) local u = units[unit]; if u then return u.name, "Forever" end end
function UnitName(unit) local u = units[unit]; return u and u.name end
function UnitGUID(unit) local u = units[unit]; return u and (u.player and ("Player-1-" .. u.name) or ("Creature-0-1-2-3-" .. u.id .. "-99")) end
function UnitFactionGroup(unit) if unit == "player" then return "Horde" end local u = units[unit]; return u and u.faction end
function UnitClass(unit) local u = units[unit]; if u then return u.class, u.class end end
function UnitLevel(unit) local u = units[unit]; return u and u.level or 0 end
RAID_CLASS_COLORS = {MAGE = {r = 0.25, g = 0.78, b = 0.92}}
local function Spawn(unit, data)
    units[unit] = data
    local plate = CreateFrame("Frame")
    plate.UnitFrame = CreateFrame("Frame", nil, plate)
    plate.UnitFrame.unit = unit
    plate.UnitFrame.name = Region()
    plates[unit] = plate
    return plate
end
C_NamePlate = {
    GetNamePlateForUnit = function(unit) return plates[unit] end,
    GetNamePlates = function() local list = {} for _, plate in pairs(plates) do list[#list + 1] = plate end return list end,
}
local nameHooks = {}
function CompactUnitFrame_UpdateName() end
function hooksecurefunc(name, fn) assert(name == "CompactUnitFrame_UpdateName"); nameHooks[#nameHooks + 1] = fn end

-- Forever Names 1.9 saved settings, with your people inside.
ForeverNamesDB = {
    people = {["aeryn-forever"] = {name = "Aeryn-Forever", glyph = "moon", display = "Lady Evening",
        journal = {{k = "group", t = 999000}}}},
    peopleBlocked = {["pest-forever"] = {name = "Pest-Forever"}},
    peopleRename = true, peopleIcons = true, peopleIconPosition = "same", peopleJournal = true,
    colors = {people = {0.9, 0.3, 0.6}},
    showFriendlyPlayers = true, -- a Forever Names setting: not copied
}

local A = {}
for _, file in ipairs({"Core.lua", "Glyphs.lua", "People.lua", "Characters.lua", "GroupPrompt.lua", "Journal.lua", "Plates.lua", "API.lua"}) do
    assert(loadfile(root .. file))("CompanionJournal", A)
end
local events = frames[2] -- Core's event frame (after UIParent)
check(events.events.ADDON_LOADED and events.events.PLAYER_LOGIN, "listens for loading and login")
A.CreateOptions, A.OpenOptions, A.RefreshOptions = function() end, function() A.opened = true end, nil
A.SelectPerson = function(key) A.selected = key end

-- 1. The one-time copy: your people and their options, nothing else, and
-- Forever Names' saved settings untouched.
events.scripts.OnEvent(events, "ADDON_LOADED", "CompanionJournal")
local db = CompanionJournalDB
check(db and db.people["aeryn-forever"], "people copied from Forever Names")
equal(db.people["aeryn-forever"].display, "Lady Evening", "with their display name")
equal(#db.people["aeryn-forever"].journal, 1, "and their journal")
check(db.people["aeryn-forever"] ~= ForeverNamesDB.people["aeryn-forever"], "a copy, not the same table")
check(db.peopleBlocked["pest-forever"], "the never-add list copied")
check(db.peopleRename and db.peopleIcons and db.peopleJournal, "the People options copied")
equal(db.colors.people[1], 0.9, "the People color copied")
equal(db.showFriendlyPlayers, nil, "Forever Names' own settings are not copied")
check(ForeverNamesDB.people["aeryn-forever"] and ForeverNamesDB.peopleRename, "nothing removed from Forever Names")
events.scripts.OnEvent(events, "PLAYER_LOGIN")
check(printed[#printed]:find("copied from Forever Names", 1, true), "you are told once, at login")
-- Adding someone new in Forever Names later is not copied again.
ForeverNamesDB.people["late-forever"] = {name = "Late-Forever"}
check(A.AdoptForeverNames(db) == false and not db.people["late-forever"], "the copy happens once")

-- A fresh copy onto a list you already started keeps yours and adds the rest.
do
    local mine = {people = {["aeryn-forever"] = {name = "Aeryn-Forever", note = "mine"}}, peopleIcons = false}
    check(A.AdoptForeverNames(mine), "missing people are copied")
    equal(mine.people["aeryn-forever"].note, "mine", "your own entry wins")
    check(mine.people["late-forever"], "the missing entry is added")
    equal(mine.peopleIcons, false, "your options win once you have your own list")
end

-- 2. The API that Forever Names asks.
local api = CompanionJournalAPI
local aeryn = db.people["aeryn-forever"]
local plate = Spawn("nameplate1", {name = "Aeryn", player = true, class = "MAGE", faction = "Horde", level = 20})
check(api.Active(), "active while a display option is on")
equal(api.Find("nameplate1"), aeryn, "finds the person for a unit")
equal(api.DisplayName(aeryn), "Lady Evening", "their display name")
local path, color, mode, size, side = api.Icon(aeryn)
check(path:find("CompanionJournal\\Media\\Glyphs\\moon", 1, true), "their glyph, from our own folder")
check(color == aeryn.color or color[1] == 0.9, "their color")
equal(mode, "custom", "own color by default")
equal(size, nil, "automatic size")
equal(side, nil, "with the other icons (Like other icons)")
api.Seen(aeryn, "nameplate1")
equal(aeryn.class, "MAGE", "seen: their class is noted")
db.peopleRename = false
equal(api.DisplayName(aeryn), nil, "no display name while renaming is off")
db.peopleRename = true
equal(A.IsEnemyPlayer("nameplate1"), false, "same faction: not an enemy")
units.nameplate1.faction = "Alliance"
equal(A.IsEnemyPlayer("nameplate1"), true, "other faction: an enemy (without Forever Names)")
units.nameplate1.faction = "Horde"

-- 3. The icon beside Blizzard's names.
local plateEvents = frames[#frames] -- Plates.lua's frame is the last one made at load
for _, f in ipairs(frames) do if f.scripts.OnEvent and f ~= events and f.events.NAME_PLATE_UNIT_ADDED then plateEvents = f end end
check(plateEvents.events.NAME_PLATE_UNIT_ADDED, "icons on: follows plates as they come")
check(#nameHooks == 1, "follows Blizzard's name showing or hiding (one hook)")
local function Mark()
    for _, child in ipairs(frames) do
        if child.parent == plate and child ~= plate.UnitFrame and child.textures then return child.textures[1] end
    end
end
plateEvents.scripts.OnEvent(plateEvents, "NAME_PLATE_UNIT_ADDED", "nameplate1")
local mark = Mark()
check(mark and mark.shown, "an icon beside Blizzard's name")
check(mark.texturePath:find("moon", 1, true), "their glyph")
equal(mark.points[1][1], "RIGHT", "before the name")
equal(mark.points[1][2], plate.UnitFrame.name, "anchored to Blizzard's name")
equal(mark.width, 14, "about the height of Blizzard's names")
equal(mark.tint[1], 0.9, "in their color")
aeryn.colorMode = "class"; A.RefreshPlateIcons()
equal(mark.tint[1], 0.25, "or their class color")
aeryn.colorMode = "name"; A.RefreshPlateIcons()
equal(mark.tint[2], 0.2, "or the color of Blizzard's name")
aeryn.colorMode = nil
db.peopleIconPosition = "right"; A.RefreshPlateIcons()
equal(mark.points[1][1], "LEFT", "or after the name")
db.peopleIconPosition = "same"
aeryn.iconSize = 20; A.RefreshPlateIcons()
equal(mark.width, 20, "their own size")
aeryn.iconSize = nil
plate.UnitFrame.name.shown = false
nameHooks[1](plate.UnitFrame)
equal(mark.shown, false, "Blizzard hides the name: the icon goes too")
plate.UnitFrame.name.shown = true
nameHooks[1](plate.UnitFrame)
check(mark.shown, "and comes back with it")
aeryn.glyph = "none"; A.RefreshPlateIcons()
equal(mark.shown, false, "someone with no icon gets none")
aeryn.glyph = "moon"; A.RefreshPlateIcons()
-- Forever Names draws its own label here: the icon goes on its label instead.
ForeverNamesAPI = {version = 1, OwnsUnit = function(unit) return unit == "nameplate1" end}
A.RefreshPlateIcons()
equal(mark.shown, false, "no double icon where Forever Names labels the plate")
ForeverNamesAPI = nil
A.RefreshPlateIcons()
check(mark.shown, "back beside Blizzard's name without it")
local stranger = Spawn("nameplate2", {name = "Nobody", player = true, faction = "Horde"})
plateEvents.scripts.OnEvent(plateEvents, "NAME_PLATE_UNIT_ADDED", "nameplate2")
local strangerMark
for _, child in ipairs(frames) do if child.parent == stranger and child ~= stranger.UnitFrame then strangerMark = child end end
equal(strangerMark, nil, "people not in your list: nothing is made")
-- Blizzard updates names constantly: for people not in your list that costs one table read.
do
    local reads, real = 0, UnitFullName
    UnitFullName = function(...) reads = reads + 1; return real(...) end
    for _ = 1, 50 do nameHooks[1](stranger.UnitFrame) end
    UnitFullName = real
    equal(reads, 0, "50 name updates on a stranger's plate: no lookups")
end
plateEvents.scripts.OnEvent(plateEvents, "NAME_PLATE_UNIT_REMOVED", "nameplate1")
equal(mark.shown, false, "the plate leaves: the icon goes")
plateEvents.scripts.OnEvent(plateEvents, "NAME_PLATE_UNIT_ADDED", "nameplate1")
check(mark.shown, "and the same small frame is used again")
A.SetOption("peopleIcons", false)
check(not plateEvents.events.NAME_PLATE_UNIT_ADDED, "icons off: plates are not followed")
equal(mark.shown, false, "icons off: hidden")

-- 4. Slash command: /cj opens the window at your target when they are in the list.
units.target = units.nameplate1
SlashCmdList.COMPANIONJOURNAL("")
check(A.opened and A.selected == "aeryn-forever", "/cj opens at your target")
units.target = nil

-- The game has no os or io library (the tests do): an addon file must not use them
-- ("os and os.time or time" is allowed: it falls back to the game's time()).
for _, addonName in ipairs({"CompanionJournal", "ForeverNames"}) do
    local toc = io.open("Interface/AddOns/" .. addonName .. "/" .. addonName .. ".toc")
    if toc then
        for file in toc:read("*a"):gmatch("[^\r\n]+") do
            if file:match("%.lua$") and not file:match("^#") then
                local f = io.open("Interface/AddOns/" .. addonName .. "/" .. file)
                if f then
                    local code = f:read("*a"):gsub("%-%-[^\n]*", ""):gsub("os and os%.", "")
                    f:close()
                    check(not code:find("%f[%w_]os%.") and not code:find("%f[%w_]io%."),
                        addonName .. "/" .. file .. " uses os or io, which the game does not have")
                end
            end
        end
        toc:close()
    end
end

io.write("PASS: " .. assertions .. " companion journal standalone assertions\n")
