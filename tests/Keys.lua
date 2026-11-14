-- Run from the client root: lua5.1 Interface/AddOns/CompanionJournal/tests/Keys.lua
-- The key setters (Keys.lua): the key shown, the combo with modifiers, the
-- question when a key is taken, binding (old key freed, saved), combat and
-- refused keys, and listening (Escape cancels, a key binds).
local root = "Interface/AddOns/CompanionJournal/"
local checks = 0
local function check(v, m) checks = checks + 1; assert(v, m) end

local bindings, saved, fighting, mods = {}, 0, false, {}
function GetBindingKey(action) local keys = {} for k, a in pairs(bindings) do if a == action then keys[#keys + 1] = k end end table.sort(keys) return unpack(keys) end
function GetBindingAction(key) return bindings[key] or "" end
function GetBindingText(key) return (key:gsub("%-", "-")) end
function SetBinding(key, action) bindings[key] = action end
function SaveBindings() saved = saved + 1 end
function GetCurrentBindingSet() return 1 end
function InCombatLockdown() return fighting end
function IsShiftKeyDown() return mods.shift end
function IsControlKeyDown() return mods.ctrl end
function IsAltKeyDown() return mods.alt end
local function Frame()
    local f = {scripts = {}, shown = false, label = false}
    function f:SetScript(n, fn) self.scripts[n] = fn end
    function f:HookScript(n, fn) self.scripts[n] = fn end
    function f:Show() self.shown = true end
    function f:Hide() self.shown = false end
    function f:SetText(t) self.text = t end
    return setmetatable(f, {__index = function() return function() end end})
end
local frames = {}
function CreateFrame() local f = Frame(); frames[#frames + 1] = f; return f end
UIParent = Frame()
StaticPopupDialogs = {}
local popup
function StaticPopup_Show(name, text, _, data) popup = {name = name, text = text, data = data} end
BINDING_NAME_TOGGLEBACKPACK = "Open Backpack"

local A = {}
assert(loadfile(root .. "Keys.lua"))("CompanionJournal", A)
local Keys = A.Keys
check(BINDING_NAME_COMPANIONJOURNAL_TOGGLE ~= nil and type(CompanionJournal_ToggleBook) == "function", "toggle binding defined")
local toggled = 0
A.ToggleBook = function() toggled = toggled + 1 end
CompanionJournal_ToggleBook()
check(toggled == 1, "toggle binding opens the book")

-- the bindings file and the TOC list what the code defines
local xml = io.open(root .. "Bindings.xml"):read("*a")
check(xml:find('name="COMPANIONJOURNAL_TOGGLE"', 1, true) and xml:find("CompanionJournal_ToggleBook()", 1, true), "Bindings.xml has the toggle")
local toc = io.open(root .. "CompanionJournal.toc"):read("*a")
check(toc:find("\nKeys.lua", 1, true) and toc:find("\nAddOnSettings.lua", 1, true), "TOC loads both files")
for _, item in ipairs(Keys.ACTIONS) do check(xml:find('name="' .. item.action .. '"', 1, true), item.action .. " is in Bindings.xml") end

check(Keys.Bound("COMPANIONJOURNAL_TOGGLE") == nil, "no key at first")
mods = {ctrl = true, shift = true}
check(Keys.Combo("J") == "CTRL-SHIFT-J", "modifiers combine")
mods = {}
check(Keys.Refused("ENTER") and Keys.Refused("BUTTON1") and not Keys.Refused("J"), "refused keys")
check(Keys.Button("LeftButton") == "BUTTON1" and Keys.Button("Button4") == "BUTTON4", "mouse buttons")

-- a free key binds at once; the old key is freed
check(Keys.Question("COMPANIONJOURNAL_TOGGLE", "J") == nil, "free key: no question")
local ok = Keys.Bind("COMPANIONJOURNAL_TOGGLE", "J")
check(ok and bindings.J == "COMPANIONJOURNAL_TOGGLE" and saved == 1, "bound and saved")
Keys.Bind("COMPANIONJOURNAL_TOGGLE", "K")
check(bindings.J == nil and bindings.K == "COMPANIONJOURNAL_TOGGLE", "old key freed")
check(Keys.Bound("COMPANIONJOURNAL_TOGGLE") == "K", "bound key shown")

-- a taken key is asked about, naming what it did
bindings.B = "TOGGLEBACKPACK"
local q = Keys.Question("COMPANIONJOURNAL_TOGGLE", "B")
check(q and q:find("Open Backpack", 1, true) and q:find("Open Companion Journal", 1, true), "question names both: " .. tostring(q))
local _, was = Keys.Bind("COMPANIONJOURNAL_TOGGLE", "B")
check(was == "Was Open Backpack.", "says what it was")

-- never in combat
fighting = true
local okc, why = Keys.Bind("COMPANIONJOURNAL_TOGGLE", "L")
check(not okc and why == Keys.COMBAT and bindings.L == nil, "refused in combat")

-- the setter: shows the key, listens, Escape cancels, a key binds
local button, status = Frame(), Frame()
local setter = Keys.Setter(button, "FOREVERNAMES_TAG_TARGET", status)
check(button.text == Keys.NONE, "setter shows None")
button.scripts.OnClick()
check(status.text == Keys.COMBAT and not setter.listening, "setter refuses in combat")
fighting = false
button.scripts.OnClick()
check(setter.listening and button.text == Keys.LISTENING, "listening")
local catcher
for _, f in ipairs(frames) do if f.scripts.OnKeyDown then catcher = f end end
check(catcher and catcher.shown, "the catcher takes the keyboard")
catcher.scripts.OnKeyDown(catcher, "LSHIFT")
check(setter.listening, "a modifier alone waits")
catcher.scripts.OnKeyDown(catcher, "ESCAPE")
check(not setter.listening and not catcher.shown and button.text == Keys.NONE, "Escape cancels")
button.scripts.OnClick()
catcher.scripts.OnKeyDown(catcher, "ENTER")
check(setter.listening and status.text == Keys.REFUSED, "Enter refused, still listening")
mods = {alt = true}
catcher.scripts.OnKeyDown(catcher, "T")
mods = {}
check(bindings["ALT-T"] == "FOREVERNAMES_TAG_TARGET" and button.text == "ALT-T" and not setter.listening, "a key binds and shows")
-- a taken key asks first; yes binds it
button.scripts.OnClick()
catcher.scripts.OnMouseDown(catcher, "Button4")
check(bindings.BUTTON4 == "FOREVERNAMES_TAG_TARGET", "mouse button binds")
bindings.M = "TOGGLEBACKPACK"
button.scripts.OnClick()
catcher.scripts.OnKeyDown(catcher, "M")
check(popup and popup.name == "COMPANIONJOURNAL_TAKE_KEY" and bindings.M == "TOGGLEBACKPACK", "taken key: asked, not yet bound")
StaticPopupDialogs.COMPANIONJOURNAL_TAKE_KEY.OnAccept(nil, popup.data)
check(bindings.M == "FOREVERNAMES_TAG_TARGET" and button.text == "M", "yes takes it")
button.scripts.OnClick()
catcher.scripts.OnMouseDown(catcher, "RightButton")
check(not setter.listening and bindings.M == "FOREVERNAMES_TAG_TARGET", "right click cancels")
-- a book button writes on its label
local paper = Frame(); paper.label = Frame()
Keys.Setter(paper, "FOREVERNAMES_TAG_TARGET", nil)
check(paper.label.text == Keys.Bound("FOREVERNAMES_TAG_TARGET") and rawget(paper, "text") == nil, "label written on book buttons")
print(checks .. " checks passed")
