-- Real world-settings builders, Names option bridge and picker callbacks.
local root = "Interface/AddOns/CompanionJournal/"
local checks, named = 0, {}
local function check(ok, why) checks = checks + 1; assert(ok, why) end
local M = {}; M.__index = M
local function object(parent) return setmetatable({parent = parent, scripts = {}, shown = true, enabled = true, children = {}}, M) end
function M:GetParent() return self.parent end
function M:SetParent(v) self.parent = v end
function M:GetFrameLevel() return 5 end
function M:SetScript(k, v) self.scripts[k] = v end
function M:Hide() local was = self.shown; self.shown = false; if was and self.scripts.OnHide then self.scripts.OnHide(self) end end
function M:Show() self.shown = true end
function M:IsShown() return self.shown end
function M:SetShown(v) if v then self:Show() else self:Hide() end end
function M:SetEnabled(v) self.enabled = v end
function M:IsEnabled() return self.enabled end
function M:SetPoint(...) self.point = {...} end
function M:ClearAllPoints() self.point = nil end
function M:SetSize(w, h) self.width, self.height = w, h end
function M:SetWidth(w) self.width = w end
function M:SetHeight(h) self.height = h end
function M:SetText(v) self.text = v end
function M:SetTextColor(...) self.textColor = {...} end
function M:SetColorTexture(...) self.color = {...} end
function M:SetVertexColor(...) self.tint = {...} end
function M:SetTexture(v) self.texture = v end
function M:GetFontString() return self.label end
function M:CreateTexture() local v = object(self); self.children[#self.children + 1] = v; return v end
function M:CreateFontString() local v = object(self); self.children[#self.children + 1] = v; return v end
for _, name in ipairs({"SetFontObject", "SetJustifyH", "SetWordWrap", "SetShadowOffset", "SetFrameStrata", "SetFrameLevel", "EnableMouse",
    "SetBackdrop", "SetBackdropColor", "SetAllPoints", "SetAlpha", "SetClampedToScreen"}) do M[name] = function() end end
function CreateFrame(_, name, parent)
    local v = object(parent); v.label = object(v)
    if name then named[name], _G[name] = v, v end
    return v
end
UIParent = object(); UISpecialFrames = {}
local bookB = object(UIParent)
local panel, child = object(bookB), nil
child = object(panel)
local section = object(child); section.layoutWidth, section.updates = 340, {}
local A = {defaults = {colors = {}}, db = {enabled = true, peopleIcons = true, peopleIconPosition = "left", peopleNewGlyph = "diamond",
    colors = {people = {.8, .2, .1}, recognizedCompanion = {.9, .7, .2}, recognizedAcquaintance = {.6, .6, .6}, recognizedRival = {.8, .1, .2}}}}
CompanionJournalDB = A.db
local refreshes, namesRefreshes = 0, 0
local function update() for _, callback in ipairs(section.updates) do callback() end end
A.Refresh = function() refreshes = refreshes + 1; update() end
A.SetOption = function(k, v) A.db[k] = v; A.Refresh() end
local N = {db = {optionsLayout = "b", peopleIconSide = "right"}, Refresh = function() namesRefreshes = namesRefreshes + 1 end}
assert(loadfile("Interface/AddOns/ForeverNames/PeopleBridge.lua"))("ForeverNames", N)
assert(loadfile("Interface/AddOns/ForeverNames/Options.lua"))("ForeverNames", N)
A.Names = function() return ForeverNamesAPI end
for _, file in ipairs({"Glyphs.lua", "ColorPicker.lua", "BookManagement.lua"}) do assert(loadfile(root .. file))("CompanionJournal", A) end
local choices, buttons = {}, {}
local ui = {}
function ui.Choice(_, y, label, items, get, set)
    choices[label] = {get = get, set = set, items = items}
    return y - (#items == 2 and type(items[1][1]) == "boolean" and 38 or 44)
end
function ui.Button(parent, label, action)
    local b = object(parent); b.label = object(b); b.label:SetText(label); b:SetScript("OnClick", action); buttons[label] = b; return b
end
local bottom = A.BuildBookWorldSettings(section, "world", ui); update()
check(bottom >= -370, "world settings fit a small parchment page: " .. bottom)
local position = choices["Nameplate icon position"]
check(position and #position.items == 3 and position.get() == "right", "inline choices read the owning Names setting")
position.set("left")
check(N.db.peopleIconSide == "left" and namesRefreshes == 1, "position action updates Names and refreshes labels")
check(A.db.peopleIconPosition == "left", "position action does not overwrite Journal standalone settings")
position.set("same")
check(N.db.peopleIconSide == "same" and position.get() == "same" and namesRefreshes == 2, "same follows other icons")
check(A.db.peopleIconPosition == "left", "Names same placement leaves standalone Journal preference intact")
check(ForeverNamesAPI.SetPeopleIconPosition("above") == false and N.db.peopleIconSide == "same", "bridge rejects unsupported side")
N.db.peopleIconSide = nil
check(ForeverNamesAPI.PeopleIconPosition() == "left", "getter honors unmigrated legacy placement")
check(N.db.peopleIconSide == nil, "reading a setting does not migrate it")

local icon = buttons["Default icon for new people"]
check(icon.preview.texture == A.GlyphPath("diamond") and icon.preview.tint[1] == .8, "default icon visibly previews the selected glyph and color")
icon.scripts.OnClick(icon)
local glyphPicker = named.CompanionJournalGlyphPopover
check(glyphPicker:IsShown() and glyphPicker:GetParent() == bookB, "glyph picker belongs to the visible Book B")
local heart; for _, b in ipairs(glyphPicker.buttons) do if b.glyph == "heart" then heart = b end end
heart.scripts.OnClick(heart)
check(A.db.peopleNewGlyph == "heart" and icon.preview.texture == A.GlyphPath("heart"), "glyph choice updates setting and preview")
icon.scripts.OnClick(icon); glyphPicker.none.scripts.OnClick(glyphPicker.none)
check(A.db.peopleNewGlyph == "none" and icon.preview.texture == "Interface\\Buttons\\UI-GroupLoot-Pass-Up", "none has a visible preview")

for _, entry in ipairs({{"Companion", "recognizedCompanion"}, {"Acquaintance", "recognizedAcquaintance"}, {"Rival", "recognizedRival"}}) do
    local button, key = buttons[entry[1]], entry[2]
    local original = A.db.colors[key]
    check(button.preview.color[1] == original[1] and button.preview.color[2] == original[2], "recognition swatch shows current color")
    button.scripts.OnClick(button)
    local picker = named.CompanionJournalColorPopover
    check(picker:IsShown() and picker:GetParent() == bookB and picker.point[2] == button, "color picker opens from the Book B swatch")
    picker.swatches[7].scripts.OnClick(picker.swatches[7])
    check(A.db.colors[key][1] == .35 and button.preview.color[1] == .35, "palette previews immediately in the setting and swatch")
    picker.cancelButton.scripts.OnClick(picker.cancelButton)
    check(A.db.colors[key][1] == original[1] and button.preview.color[2] == original[2], "Cancel restores the original recognition color")
    button.scripts.OnClick(button); picker:Set(.2, .3, .4); picker.done.scripts.OnClick(picker.done)
    check(A.db.colors[key][1] == .2 and button.preview.color[3] == .4 and not picker:IsShown(), "Done commits the chosen recognition color")
    button.scripts.OnClick(button); picker:Set(.9, .9, .9); picker:Hide()
    check(A.db.colors[key][1] == .2, "Escape/hide cancels an unfinished color preview")
end
check(refreshes >= 14, "world edits refresh rendered previews")
A.db.colors.recognizedRival = nil; update()
buttons.Rival.scripts.OnClick(buttons.Rival)
named.CompanionJournalColorPopover:Set(.4, .5, .6)
named.CompanionJournalColorPopover:Cancel()
check(A.db.colors.recognizedRival == nil and buttons.Rival.preview.color[1] == 1, "cancel restores an inherited color without creating an override")

-- Standalone Journal placement continues to own its original two choices.
A.Names = function() return nil end
section.updates, choices, buttons = {}, {}, {}
A.BuildBookWorldSettings(section, "world", ui); update()
check(choices["Icon position"] and #choices["Icon position"].items == 2, "standalone has before/after choices")
choices["Icon position"].set("right")
check(A.db.peopleIconPosition == "right", "standalone action updates Journal placement")
print("BookWorldSettings: " .. checks .. " checks passed")
