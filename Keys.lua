local addonName, A = ...
-- Choosing a key for one of the addon's bindings (Bindings.xml) from its own
-- settings: a button showing the key; click it and the next key pressed is
-- bound (modifiers combine, Escape or a left/right click cancels). A key
-- that already did something else is asked about first. Never in a fight.
-- Used by the book's Settings > Keys and by the AddOns page (AddOnSettings.lua).

local Keys = {}
A.Keys = Keys

BINDING_NAME_COMPANIONJOURNAL_TOGGLE = "Open Companion Journal"
function CompanionJournal_ToggleBook()
    if A.ToggleBook then A.ToggleBook() end
end

-- The addon's bindings, as the settings list them.
Keys.ACTIONS = {
    {action = "COMPANIONJOURNAL_TOGGLE", label = "Open the book"},
    {action = "FOREVERNAMES_TAG_TARGET", label = "Add target"},
}

Keys.COMBAT = "Not in combat."
Keys.REFUSED = "That key stays with the game."
Keys.LISTENING = "Press a key"
Keys.NONE = "None"

local MODIFIERS = {LSHIFT = true, RSHIFT = true, LCTRL = true, RCTRL = true,
    LALT = true, RALT = true, LMETA = true, RMETA = true}
local NEVER = {ENTER = true, BACKSPACE = true, BUTTON1 = true, BUTTON2 = true}
local BUTTONS = {LeftButton = "BUTTON1", RightButton = "BUTTON2", MiddleButton = "BUTTON3"}

local function Fighting() return InCombatLockdown and InCombatLockdown() and true or false end

-- The key `action` is on, as the game shows it, or nil.
function Keys.Bound(action)
    local key = GetBindingKey and GetBindingKey(action)
    if not key then return nil end
    return GetBindingText and GetBindingText(key) or key
end

function Keys.Refused(key) return NEVER[key] == true end
function Keys.Button(button) return BUTTONS[button] or tostring(button):upper() end

-- The key pressed, with the modifiers held, as the bindings write it.
function Keys.Combo(key)
    local mods = ""
    if IsAltKeyDown and IsAltKeyDown() then mods = mods .. "ALT-" end
    if IsControlKeyDown and IsControlKeyDown() then mods = mods .. "CTRL-" end
    if IsShiftKeyDown and IsShiftKeyDown() then mods = mods .. "SHIFT-" end
    if IsMetaKeyDown and IsMetaKeyDown() then mods = mods .. "META-" end
    return mods .. key
end

local function ActionName(name, action)
    if not name or name == "" or name == action then return nil end
    return _G["BINDING_NAME_" .. name] or name
end

-- What to ask before taking `key` from what has it; nil when it is free.
function Keys.Question(action, key)
    local taken = ActionName(GetBindingAction and GetBindingAction(key), action)
    if not taken then return nil end
    local shown = GetBindingText and GetBindingText(key) or key
    return shown .. " is set to " .. taken .. ".\n\nUse it for " .. (ActionName(action) or action) .. "?"
end

-- Binds `key` to `action`, freeing the key(s) `action` had; saved with the
-- binding set in use. Answers ok, and what the key did before (or an error).
function Keys.Bind(action, key)
    if Fighting() then return false, Keys.COMBAT end
    local before = ActionName(GetBindingAction(key), action)
    for _, old in ipairs({GetBindingKey(action)}) do SetBinding(old) end
    SetBinding(key, action)
    SaveBindings(GetCurrentBindingSet())
    return true, before and ("Was " .. before .. ".") or ""
end

-- The one setter listening, if any: starting another stops it.
local listening
local catcher

local function Catcher()
    if catcher then return catcher end
    catcher = CreateFrame("Frame", nil, UIParent)
    catcher:SetAllPoints(UIParent)
    catcher:SetFrameStrata("FULLSCREEN_DIALOG")
    catcher:Hide()
    catcher:RegisterEvent("PLAYER_REGEN_DISABLED")
    catcher:SetScript("OnEvent", function() if listening then listening:Stop() end end)
    return catcher
end

if StaticPopupDialogs then
    StaticPopupDialogs.COMPANIONJOURNAL_TAKE_KEY = {
        text = "%s", button1 = "Use it", button2 = CANCEL or "Cancel",
        OnAccept = function(_, data) if data then data.setter:Take(data.key) end end,
        timeout = 0, whileDead = true, hideOnEscape = true, preferredIndex = 3,
    }
end

-- Turns `button` (any button with SetText) into the setter for `action`.
-- `status` is a font string for refusals and what the key did before;
-- `layout(button)` runs after the text changes (to resize or redraw).
function Keys.Setter(button, action, status, layout)
    local s = {button = button, action = action, status = status}
    local function Say(text) if s.status then s.status:SetText(text or "") end end
    function s:Refresh()
        local text = self.listening and Keys.LISTENING or Keys.Bound(self.action) or Keys.NONE
        -- (the book's buttons write on their own label; the AddOns page's on the button)
        if self.button.label then self.button.label:SetText(text) else self.button:SetText(text) end
        if layout then layout(self.button) end
    end
    function s:Stop()
        if not self.listening then return end
        self.listening = false
        if listening == self then listening = nil end
        local c = Catcher()
        c:EnableKeyboard(false); c:EnableMouse(false); c:EnableMouseWheel(false)
        c:SetScript("OnKeyDown", nil); c:SetScript("OnMouseDown", nil); c:SetScript("OnMouseWheel", nil)
        c:Hide()
        self:Refresh()
    end
    function s:Take(key)
        local ok, message = Keys.Bind(self.action, key)
        Say(message)
        self:Refresh()
        return ok
    end
    local function Pressed(key)
        if Keys.Refused(key) then Say(Keys.REFUSED); return end
        local combo = Keys.Combo(key)
        s:Stop()
        local question = Keys.Question(s.action, combo)
        if question and StaticPopup_Show then
            Say("")
            StaticPopup_Show("COMPANIONJOURNAL_TAKE_KEY", question, nil, {setter = s, key = combo})
        else
            s:Take(combo)
        end
    end
    function s:Listen()
        if Fighting() then Say(Keys.COMBAT); return end
        if listening and listening ~= self then listening:Stop() end
        listening, self.listening = self, true
        Say("")
        local c = Catcher()
        c:Show()
        c:EnableKeyboard(true)
        if c.SetPropagateKeyboardInput then c:SetPropagateKeyboardInput(false) end
        c:EnableMouse(true); c:EnableMouseWheel(true)
        c:SetScript("OnKeyDown", function(_, key)
            if MODIFIERS[key] then return end
            if key == "ESCAPE" then s:Stop(); return end
            Pressed(key)
        end)
        c:SetScript("OnMouseDown", function(_, mouse)
            local key = Keys.Button(mouse)
            if key == "BUTTON1" or key == "BUTTON2" then s:Stop(); return end
            Pressed(key)
        end)
        c:SetScript("OnMouseWheel", function(_, delta) Pressed(delta > 0 and "MOUSEWHEELUP" or "MOUSEWHEELDOWN") end)
        self:Refresh()
    end
    button:SetScript("OnClick", function() if s.listening then s:Stop() else s:Listen() end end)
    button:HookScript("OnHide", function() s:Stop() end)
    s:Refresh()
    return s
end
