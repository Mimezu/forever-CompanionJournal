-- Run from the client root: lua5.1 Interface/AddOns/CompanionJournal/tests/PersonMenu.lua
-- The People list's right-click menu is the addon's own (no Blizzard menu code, which taints
-- the gamepad interface when opened from an addon): its entries, what they do, Escape and a
-- click outside closing it, the same row closing it again, NPCs having none, and Whisper
-- staying off in the gamepad interface. Also: the unit-menu addition never raises an error.
local root = "Interface/AddOns/CompanionJournal/"
local assertions = 0
local function check(value, message) assertions = assertions + 1; assert(value, message) end

-- Frames that remember their scripts, text, shown state and children.
local methods = {}
local function Object()
    local object = {scripts = {}, events = {}, shown = true}
    return setmetatable(object, {__index = function(_, key)
        if methods[key] then return methods[key] end
        if type(key) == "string" and key:match("^[A-Z]") then return function(self) return self end end
    end})
end
function methods:SetScript(key, fn) self.scripts[key] = fn end
function methods:HookScript(key, fn)
    local old = self.scripts[key]
    self.scripts[key] = function(...) if old then old(...) end fn(...) end
end
function methods:RegisterEvent(event) self.events[event] = true end
function methods:UnregisterEvent(event) self.events[event] = nil end
function methods:Show() self.shown = true end
function methods:Hide()
    if self.shown and self.scripts.OnHide then self.shown = false; self.scripts.OnHide(self) end
    self.shown = false
end
function methods:SetShown(v) if v then self:Show() else self:Hide() end end
function methods:IsShown() return self.shown end
function methods:SetText(t) self.text = t end
function methods:GetText() return self.text or "" end
function methods:SetTextColor(r, g, b) self.color = {r, g, b} end
function methods:CreateFontString() return Object() end
function methods:CreateTexture() return Object() end
function methods:EnableKeyboard(v) self.keyboard = v end
function methods:SetPropagateKeyboardInput(v) self.propagate = v end
function CreateFrame() return Object() end
UIParent = Object()
C_Texture = {GetAtlasInfo = function() return nil end}
function InCombatLockdown() return false end
local clock = 1790000000
function time() return clock end
function GetTime() return clock end
function date(fmt, t) return os.date(fmt, t or clock) end
function GetRealZoneText() return "Tirisfal Glades" end
function GetNormalizedRealmName() return "Forever" end
function GetRealmName() return "Forever" end
C_Timer = {After = function(_, fn) fn() end}
function IsInInstance() return false, "none" end
print = function() end
local player = {name = "Alberich", faction = "Horde", class = "PALADIN", race = "Scourge"}
function UnitName(unit) if unit == "player" then return player.name end end
function UnitFullName() end
function UnitFactionGroup(unit) if unit == "player" then return player.faction end end
function UnitClass(unit) if unit == "player" then return player.class, player.class end end
function UnitRace(unit) if unit == "player" then return player.race, player.race end end
function UnitLevel() return 20 end
function UnitIsPlayer(unit) return unit == "player" end
function UnitGUID() return nil end

-- The game's actions the menu calls.
local called = {}
C_FriendList = {AddFriend = function(name) called[#called + 1] = "friend:" .. name end}
ChatFrameUtil = {SendTell = function(name) called[#called + 1] = "whisper:" .. name end}
C_PartyInfo = {InviteUnit = function(name) called[#called + 1] = "invite:" .. name end}

local db = {enabled = true, peopleJournal = true, peopleMenu = true, colors = {people = {1, 1, 1}, groupmate = {0.5, 0.8, 1}},
    people = {
        ["dahlia-noir"] = {name = "Dahlia-Noir", faction = "Horde", class = "WARLOCK", race = "Scourge", glyph = "heart",
            journal = {{k = "quest", d = "The Mills Overrun", t = 1789001000, z = "Tirisfal Glades"}}},
        ["pox-plagueheart"] = {name = "Pox-Plagueheart", circle = "acquaintance", faction = "Horde", glyph = "party"},
        ["npc:246152"] = {name = "Shari Stilwell", npc = true, note = "Cool trainer", glyph = "diamond"},
    }}
local A = {defaults = {colors = {}}}
for _, file in ipairs({"OptionsSkin.lua", "People.lua", "Characters.lua", "Journal.lua"}) do
    assert(loadfile(root .. file))("CompanionJournal", A)
end
A.Refresh = function() end
for key, value in pairs(A.defaults) do if db[key] == nil then db[key] = value end end
A.db = db
A.InitPeople()
A.InitCharacters()
local opened
A.OpenJournal = function(key) opened = key end

local menu = A.PersonMenu
local function Rows()
    local out = {}
    for _, row in ipairs(menu.panel.rows) do if row.shown then out[#out + 1] = row end end
    return out
end
local function Texts()
    local out = {}
    for _, row in ipairs(Rows()) do local t = row.text.text; out[#out + 1] = (t ~= nil and t ~= "") and t or "-" end
    return table.concat(out, "|")
end
local function Row(text)
    for _, row in ipairs(Rows()) do if row.text.text == text then return row end end
end

-- 1. A companion with a journal: title, the three actions, Open journal.
local row1 = CreateFrame()
A.OpenPersonMenu(row1, "dahlia-noir")
check(menu.open and menu.panel:IsShown() and menu.catcher:IsShown(), "right-click opens the menu")
check(Texts() == "Dahlia-Noir|Add Friend|Whisper|Invite to Group|-|Open journal", "its entries: " .. Texts())
check(menu.catcher.keyboard == true and menu.catcher.propagate == true, "the cover takes Escape and passes other keys on")
for _, text in ipairs({"Add Friend", "Whisper", "Invite to Group", "Open journal"}) do
    check(not Row(text).entry.disabled and Row(text).hover.shown, text .. " is enabled")
end

-- 2. Escape and a click outside close it; the same row closes it again.
menu.catcher.scripts.OnKeyDown(menu.catcher, "ESCAPE")
check(not menu.open and not menu.panel:IsShown() and not menu.catcher:IsShown(), "Escape closes the menu")
A.OpenPersonMenu(row1, "dahlia-noir")
check(menu.open, "it opens again")
menu.catcher.scripts.OnKeyDown(menu.catcher, "W")
check(menu.open and menu.catcher.propagate == true, "another key leaves it open and passes through")
menu.catcher.scripts.OnMouseDown(menu.catcher)
check(not menu.open and not menu.catcher:IsShown(), "a click outside closes it")
A.OpenPersonMenu(row1, "dahlia-noir")
A.OpenPersonMenu(row1, "dahlia-noir")
check(not menu.open, "the row that opened it closes it again")
A.OpenPersonMenu(row1, "dahlia-noir")
row1:Hide()
check(not menu.open, "hiding the row (list redrawn, window closed) closes it")
row1.shown = true

-- 3. The entries act on the captured name and close the menu.
A.OpenPersonMenu(row1, "dahlia-noir")
Row("Add Friend").scripts.OnClick(Row("Add Friend"))
check(not menu.open and called[#called] == "friend:Dahlia-Noir", "Add Friend adds by name and closes")
A.OpenPersonMenu(row1, "dahlia-noir")
Row("Whisper").scripts.OnClick(Row("Whisper"))
check(called[#called] == "whisper:Dahlia-Noir", "Whisper opens a tell")
A.OpenPersonMenu(row1, "dahlia-noir")
Row("Invite to Group").scripts.OnClick(Row("Invite to Group"))
check(called[#called] == "invite:Dahlia-Noir", "Invite to Group invites by name")
A.OpenPersonMenu(row1, "dahlia-noir")
Row("Open journal").scripts.OnClick(Row("Open journal"))
check(opened == "dahlia-noir" and not menu.open, "Open journal opens theirs")
A.OpenPersonMenu(row1, "dahlia-noir")
local title = Row("Dahlia-Noir")
check(title.entry.title == "Dahlia-Noir" and not title.hover.shown, "the title is not clickable")
title.scripts.OnClick(title)
check(menu.open, "clicking the title does nothing")
A.PersonMenu.Close()

-- 4. Another row, another person: the menu moves; an acquaintance without a journal still gets Open journal (they are on the list).
local row2 = CreateFrame()
A.OpenPersonMenu(row2, "pox-plagueheart")
check(menu.open and menu.owner == row2 and Texts():find("^Pox%-Plagueheart|"), "the menu follows the row")
A.OpenPersonMenu(row1, "dahlia-noir")
check(menu.owner == row1 and Texts():find("^Dahlia%-Noir|"), "opening from another row replaces it")
A.PersonMenu.Close()

-- 5. NPCs and unknown keys get no menu.
A.OpenPersonMenu(row1, "npc:246152")
check(not menu.open, "an NPC has no menu")
A.OpenPersonMenu(row1, "nobody-here")
check(not menu.open, "an unknown key has no menu")

-- 6. Missing game functions grey their entries out; a greyed entry does nothing.
local keepFriend = C_FriendList.AddFriend
C_FriendList.AddFriend = nil
A.OpenPersonMenu(row1, "dahlia-noir")
check(Row("Add Friend").entry.disabled and not Row("Add Friend").hover.shown, "Add Friend greyed out without the API")
local before = #called
Row("Add Friend").scripts.OnClick(Row("Add Friend"))
check(menu.open and #called == before, "a greyed entry does nothing and keeps the menu open")
A.PersonMenu.Close()
C_FriendList.AddFriend = keepFriend

-- 7. In the gamepad interface the menu still opens (it is the addon's own); Whisper stays off.
InputUtil = {IsGamepadUIEnabled = function() return true end}
A.OpenPersonMenu(row1, "dahlia-noir")
check(menu.open, "the menu opens in the gamepad interface")
check(Row("Whisper").entry.disabled and not Row("Add Friend").entry.disabled and not Row("Invite to Group").entry.disabled,
    "Whisper is off there, the rest is on")
A.PersonMenu.Close()
InputUtil = nil

-- 8. The unit-menu addition (Blizzard's Menu.ModifyMenu, the only way in) is guarded.
local generators = {}
Menu = {ModifyMenu = function(tag, fn) generators[tag] = fn end}
A.InstallPeopleMenu()
check(generators.MENU_UNIT_PLAYER and generators.MENU_UNIT_TARGET, "entries registered on the unit menus")
local rootMenu = {buttons = {}}
function rootMenu:CreateDivider() end
function rootMenu:CreateButton(text, fn) self.buttons[#self.buttons + 1] = {text = text, fn = fn} end
generators.MENU_UNIT_PLAYER(nil, rootMenu, {name = "Dahlia", server = "Noir"})
check(#rootMenu.buttons == 1 and rootMenu.buttons[1].text == "Edit in Companion Journal", "a listed player gets Edit")
generators.MENU_UNIT_PLAYER(nil, rootMenu, {name = "Stranger", server = "Forever"})
check(#rootMenu.buttons == 2 and rootMenu.buttons[2].text == "Add to Companion Journal", "an unknown player gets Add")
local broken = setmetatable({}, {__index = function() error("boom") end})
local ok = pcall(generators.MENU_UNIT_PLAYER, nil, broken, {name = "Dahlia", server = "Noir"})
check(ok, "an error inside never reaches Blizzard's menu code")
generators.MENU_UNIT_PLAYER(nil, rootMenu, "not a table")
check(#rootMenu.buttons == 2, "a bad context adds nothing")

-- 9. No Blizzard menu or popup code in People.lua (Menu.ModifyMenu is the one allowed call).
local fh = assert(io.open(root .. "People.lua", "r"))
local source = fh:read("*a")
fh:close()
for _, banned in ipairs({"MenuUtil", "StaticPopup", "UIDropDownMenu", "EasyMenu"}) do
    check(not source:find(banned, 1, true), "People.lua must not use " .. banned)
end

print = io.write
print(("PersonMenu: %d checks passed\n"):format(assertions))
