local _, A = ...
-- Group prompt: instead of adding groupmates automatically, ask when they leave
-- the group (or when you leave it). One small popup lists everyone who left,
-- each with three choices: companion, acquaintance, or don't add.
-- Off by default. Work only happens on GROUP_ROSTER_UPDATE (already debounced
-- by People.lua) while both "Everyone I group with" and "Ask" are on.
local function Public(value) return not issecretvalue or not issecretvalue(value) end
local function Text(value)
    return Public(value) and type(value) == "string" and value ~= "" and value or nil
end

A.defaults.peopleGroupPrompt = false
-- Popup look, chosen in the options: "cards", "legacy", "minimal".
A.defaults.groupPromptStyle = "cards"
A.groupPromptStyles = {
    {"cards", "Cards"}, {"legacy", "Legacy panel"}, {"minimal", "Minimal"},
}
local MAX_ROWS = 6

local queue, queued = {}, {}
local roster = {}
local reason = "left"
local waitingForCombat = false
local combatWatcher
-- Settings previews are separate from real pending groupmates and journal data.
local preview
local function PreviewChanged()
    if A.RefreshBook then A.RefreshBook() end
end
function A.IsGroupPromptPreview() return preview ~= nil end

function A.GroupPromptActive()
    local db = A.db
    return db and db.enabled and db.peopleAutoGroup and db.peopleGroupPrompt and true or false
end

-- Roster ------------------------------------------------------------------
-- complete = every member was readable. Where the game hides identities (some
-- instances), unreadable members must not look like people who left.
local function ReadRoster()
    local members, complete = {}, true
    if not (IsInGroup and IsInGroup()) then return members, true, false end
    local raid = IsInRaid and IsInRaid() == true
    local count = tonumber(GetNumGroupMembers and GetNumGroupMembers()) or 0
    local zone = Text(GetRealZoneText and GetRealZoneText())
    local now = time and time() or nil
    for i = 1, raid and count or math.max(0, count - 1) do
        local unit = (raid and "raid" or "party") .. i
        local okSelf, isSelf = pcall(UnitIsUnit, unit, "player")
        if not okSelf or not Public(isSelf) then
            complete = false
        elseif not isSelf then
            local okPlayer, isPlayer = pcall(UnitIsPlayer, unit)
            local okName, name, realm = pcall(UnitFullName, unit)
            if okPlayer and okName and Public(isPlayer) and Public(name) and Public(realm) and Text(name) then
                if isPlayer == true then
                    local key, full = A.PersonKey(name, realm)
                    if key then
                        local okClass, _, class = pcall(UnitClass, unit)
                        local okLevel, level = pcall(UnitLevel, unit)
                        local okRace, _, race = pcall(UnitRace, unit)
                        members[key] = {key = key, name = full,
                            class = okClass and Public(class) and Text(class) or nil,
                            level = okLevel and Public(level) and tonumber(level) or nil,
                            race = okRace and Public(race) and Text(race) or nil,
                            zone = zone, met = now}
                    end
                end
            else
                complete = false
            end
        end
    end
    return members, complete, true
end
A.ReadGroupRoster = ReadRoster

-- baseline = remember the current group without asking (login, /reload,
-- enabling the option while already grouped).
function A.TrackGroupRoster(baseline)
    local db = A.db
    local members, complete, inGroup = ReadRoster()
    if not baseline and A.GroupPromptActive() then
        local why = inGroup and "left" or "self"
        for key, entry in pairs(roster) do
            local gone = not inGroup or (complete and not members[key])
            if gone and not A.People[key] and not db.peopleBlocked[key] then A.QueueGroupPrompt(entry, why) end
        end
    end
    local nextRoster = {}
    for key, entry in pairs(members) do
        local known = roster[key]
        if known then
            -- Keep where and when you first grouped; refresh class and level.
            known.class, known.level = entry.class or known.class, entry.level or known.level
            nextRoster[key] = known
        else
            nextRoster[key] = entry
        end
    end
    if inGroup and not complete then
        for key, entry in pairs(roster) do if not nextRoster[key] then nextRoster[key] = entry end end
    end
    roster = nextRoster
end

-- Queue and choices ---------------------------------------------------------
function A.QueueGroupPrompt(entry, why)
    if not entry or not entry.key or queued[entry.key] then return end
    local wasPreview = preview ~= nil
    if not entry.test then preview = nil end
    queued[entry.key] = true
    queue[#queue + 1] = entry
    reason = why or reason
    A.ShowGroupPrompt()
    if wasPreview and not preview then PreviewChanged() end
end

-- keepTests: turning group adding off must not wipe a simulation in progress.
function A.ClearGroupPrompt(keepTests)
    local kept, keptKeys = {}, {}
    if keepTests then
        for _, entry in ipairs(queue) do
            if entry.test then kept[#kept + 1] = entry; keptKeys[entry.key] = true end
        end
    end
    queue, queued = kept, keptKeys
    if A.RefreshGroupPrompt then A.RefreshGroupPrompt() end
end
-- The close button: nobody is added, and what the journal kept aside for
-- them is forgotten.
function A.DismissGroupPrompt()
    if preview then
        preview = nil
        A.ShowGroupPrompt()
        PreviewChanged()
        return
    end
    if A.JournalForget then
        for _, entry in ipairs(queue) do if not entry.test then A.JournalForget(entry.key) end end
    end
    A.ClearGroupPrompt()
end
-- Still asking about them (the journal keeps their memories meanwhile).
function A.GroupPromptQueued(key) return key ~= nil and queued[key] == true end

local CHOICES = {
    companion = "Add to Companions",
    acquaintance = "Add to Acquaintances",
    pass = "Don't add",
}
function A.ResolveGroupPrompt(index, choice)
    if preview then
        if not preview[index] then return end
        table.remove(preview, index)
        if #preview == 0 then preview = nil end
        A.ShowGroupPrompt()
        PreviewChanged()
        return
    end
    local entry = queue[index]
    if not entry then return end
    table.remove(queue, index)
    queued[entry.key] = nil
    if entry.test then
        print(("Companion Journal (test): %s - %s."):format(entry.name, CHOICES[choice] or choice))
    elseif choice == "companion" then
        local person = A.AddPerson(entry.name, nil, {met = entry.met, metZone = entry.zone})
        if person and A.UpdatePersonFromEntry then A.UpdatePersonFromEntry(person, entry) end
    elseif choice == "acquaintance" and A.AddGroupAcquaintance then
        A.AddGroupAcquaintance(entry)
    elseif choice == "pass" and A.JournalForget then
        A.JournalForget(entry.key)
    end
    A.RefreshGroupPrompt()
end

-- Simulation (temporary, for choosing a style) ------------------------------
local TEST_PEOPLE = {
    {"Aerynwen", "PRIEST", 24}, {"Thorgrim", "WARRIOR", 26}, {"Lysandre", "MAGE", 23},
    {"Kaelith", "HUNTER", 27}, {"Mirabelle", "DRUID", 25}, {"Ostrik", "ROGUE", 22},
    {"Velanna", "PALADIN", 28}, {"Brombeard", "SHAMAN", 24}, {"Ysolde", "WARLOCK", 26},
}
local testCounter = 0
function A.ToggleGroupPromptPreview()
    if preview then preview = nil
    else
        preview = {}
        for i = 1, 2 do
            local person = TEST_PEOPLE[i]
            preview[i] = {name = person[1], class = person[2], level = person[3],
                zone = "Silverpine Forest", preview = true}
        end
    end
    A.ShowGroupPrompt()
    PreviewChanged()
    return preview ~= nil
end
function A.SimulateGroupLeave(count, self)
    count = math.max(1, math.min(#TEST_PEOPLE, tonumber(count) or 1))
    local zone = Text(GetRealZoneText and GetRealZoneText()) or "Elwynn Forest"
    for _ = 1, count do
        testCounter = testCounter + 1
        local pick = TEST_PEOPLE[(testCounter - 1) % #TEST_PEOPLE + 1]
        local key, full = A.PersonKey(pick[1], nil)
        A.QueueGroupPrompt({key = "test:" .. testCounter .. ":" .. (key or pick[1]), name = full or pick[1],
            class = pick[2], level = pick[3], zone = zone, test = true}, self and "self" or "left")
    end
end

-- View ----------------------------------------------------------------------
local function ClassColor(class)
    local color = class and ((C_ClassColor and C_ClassColor.GetClassColor and C_ClassColor.GetClassColor(class))
        or (RAID_CLASS_COLORS and RAID_CLASS_COLORS[class]))
    if color then return color.r, color.g, color.b end
    return 1, 0.82, 0
end
local function SetClassIcon(texture, class)
    local atlas = class and GetClassAtlas and GetClassAtlas(class:lower())
    if atlas and C_Texture and C_Texture.GetAtlasInfo and C_Texture.GetAtlasInfo(atlas) then
        texture:SetAtlas(atlas)
    else
        texture:SetTexture("Interface\\Icons\\INV_Misc_QuestionMark")
        texture:SetTexCoord(0.08, 0.92, 0.08, 0.92)
    end
end
local function ShortName(full)
    local name, realm = full:match("^([^%-]+)%-(.+)$")
    if not name then return full end
    local home = Text(GetNormalizedRealmName and GetNormalizedRealmName())
    return (home and realm == home) and name or (name .. " (" .. realm .. ")")
end
local function Detail(entry)
    local parts = {}
    if entry.level then parts[#parts + 1] = (LEVEL or "Level") .. " " .. entry.level end
    if entry.zone then parts[#parts + 1] = entry.zone end
    -- Someone another character of yours knows: say whose.
    local known = entry.key and A.Recognize and A.Recognize(entry.key)
    if known then parts[#parts + 1] = A.RecognizedLabel(known) end
    return table.concat(parts, "  -  ")
end
local function Headline()
    return reason == "self" and "You left the group" or "Left your group"
end

local function Tooltip(owner, text)
    owner:SetScript("OnEnter", function(self)
        GameTooltip:SetOwner(self, "ANCHOR_TOP")
        GameTooltip:SetText(text, 1, 1, 1)
        GameTooltip:Show()
        if self.hoverRow then self.hoverRow(true) end
    end)
    owner:SetScript("OnLeave", function(self)
        GameTooltip:Hide()
        if self.hoverRow then self.hoverRow(false) end
    end)
end

-- A choice button. The glyphs are our font-like icons, tinted like the lists.
local function ChoiceButton(parent, size, choice)
    local button = CreateFrame("Button", nil, parent)
    button:SetSize(size, size)
    button:RegisterForClicks("LeftButtonUp")
    if choice == "pass" then
        button:SetNormalTexture("Interface\\Buttons\\UI-GroupLoot-Pass-Up")
        button:SetHighlightTexture("Interface\\Buttons\\UI-GroupLoot-Pass-Highlight", "ADD")
        button:SetPushedTexture("Interface\\Buttons\\UI-GroupLoot-Pass-Down")
    else
        local glyph = choice == "companion" and "heart" or "party"
        local color = choice == "companion" and A.db.colors.people or A.db.colors.groupmate or {0.55, 0.8, 1}
        local icon = button:CreateTexture(nil, "ARTWORK")
        icon:SetPoint("TOPLEFT", 3, -3); icon:SetPoint("BOTTOMRIGHT", -3, 3)
        icon:SetTexture(A.GlyphPath(glyph))
        icon:SetVertexColor(color[1], color[2], color[3])
        local glow = button:CreateTexture(nil, "HIGHLIGHT")
        glow:SetAllPoints(icon)
        glow:SetTexture(A.GlyphPath(glyph))
        glow:SetBlendMode("ADD")
        glow:SetVertexColor(color[1], color[2], color[3], 0.8)
        button:SetScript("OnMouseDown", function() icon:SetPoint("TOPLEFT", 4, -4); icon:SetPoint("BOTTOMRIGHT", -2, 2) end)
        button:SetScript("OnMouseUp", function() icon:SetPoint("TOPLEFT", 3, -3); icon:SetPoint("BOTTOMRIGHT", -3, 3) end)
        button.icon = icon
    end
    Tooltip(button, CHOICES[choice])
    button:SetScript("OnClick", function(self) A.ResolveGroupPrompt(self:GetParent().index, choice) end)
    return button
end

local function AddChoices(row, size, gap, rightInset)
    row.pass = ChoiceButton(row, size, "pass")
    row.pass:SetPoint("RIGHT", -rightInset, 0)
    row.acquaintance = ChoiceButton(row, size, "acquaintance")
    row.acquaintance:SetPoint("RIGHT", row.pass, "LEFT", -gap, 0)
    row.companion = ChoiceButton(row, size, "companion")
    row.companion:SetPoint("RIGHT", row.acquaintance, "LEFT", -gap, 0)
end

local function SmallClose(parent)
    local close = CreateFrame("Button", nil, parent, "UIPanelCloseButtonNoScripts")
    close:SetSize(22, 22)
    close:SetScript("OnClick", function() A.DismissGroupPrompt() end)
    Tooltip(close, "Don't add anyone")
    return close
end

local styles = {}

-- Cards: a small leather title plate, then one dark card per person (the same
-- plate art as the settings buttons) with a round class portrait.
styles.cards = {
    width = 290, rowHeight = 46, gap = 4, top = 32, bottom = 0,
    Decorate = function(frame)
        local header = CreateFrame("Frame", nil, frame)
        header:SetPoint("TOPLEFT"); header:SetPoint("TOPRIGHT"); header:SetHeight(28)
        if A.OptionsSkin then A.OptionsSkin.Panel(header) end
        local title = header:CreateFontString(nil, "OVERLAY", "GameFontNormal")
        title:SetPoint("LEFT", 12, 0)
        local close = SmallClose(header)
        close:SetPoint("RIGHT", -4, 0)
        return title, close
    end,
    Row = function(frame)
        local row = CreateFrame("Frame", nil, frame)
        if A.OptionsSkin and A.OptionsSkin.Plate then
            local plate = A.OptionsSkin.Plate(row, "common-button-list-collapseExpand")
            row:SetScript("OnSizeChanged", function() plate:Update() end)
        end
        -- Round portrait in a thin ring (the minimap-button recipe).
        local portrait = CreateFrame("Frame", nil, row)
        portrait:SetSize(32, 32); portrait:SetPoint("LEFT", 8, 0)
        row.icon = portrait:CreateTexture(nil, "ARTWORK")
        row.icon:SetSize(22, 22); row.icon:SetPoint("CENTER")
        local mask = portrait:CreateMaskTexture()
        mask:SetTexture("Interface\\CharacterFrame\\TempPortraitAlphaMask", "CLAMPTOBLACKADDITIVE", "CLAMPTOBLACKADDITIVE")
        mask:SetAllPoints(row.icon)
        row.icon:AddMaskTexture(mask)
        local ring = portrait:CreateTexture(nil, "OVERLAY")
        ring:SetTexture("Interface\\Minimap\\MiniMap-TrackingBorder")
        ring:SetSize(54, 54); ring:SetPoint("TOPLEFT", 0, 0)
        row.name = row:CreateFontString(nil, "ARTWORK", "GameFontNormal")
        row.name:SetPoint("TOPLEFT", portrait, "TOPRIGHT", 6, -1)
        row.name:SetPoint("RIGHT", -104, 0); row.name:SetJustifyH("LEFT"); row.name:SetWordWrap(false)
        row.detail = row:CreateFontString(nil, "ARTWORK", "GameFontHighlightSmall")
        row.detail:SetPoint("TOPLEFT", row.name, "BOTTOMLEFT", 0, -3)
        row.detail:SetPoint("RIGHT", -104, 0); row.detail:SetJustifyH("LEFT"); row.detail:SetWordWrap(false)
        row.detail:SetTextColor(0.72, 0.72, 0.72)
        AddChoices(row, 26, 4, 10)
        return row
    end,
}

-- Legacy panel: one leather panel with compact rows, like the settings window.
styles.legacy = {
    width = 300, rowHeight = 30, gap = 2, top = 34, bottom = 12,
    Decorate = function(frame)
        if A.OptionsSkin then A.OptionsSkin.Panel(frame) end
        local title = frame:CreateFontString(nil, "OVERLAY", "GameFontNormal")
        title:SetPoint("TOP", 0, -12)
        local close = SmallClose(frame)
        close:SetPoint("TOPRIGHT", -5, -5)
        local line = frame:CreateTexture(nil, "ARTWORK")
        line:SetPoint("TOPLEFT", 14, -30); line:SetPoint("TOPRIGHT", -14, -30); line:SetHeight(1)
        line:SetColorTexture(1, 0.82, 0, 0.25)
        return title, close
    end,
    Row = function(frame)
        local row = CreateFrame("Frame", nil, frame)
        local hover = row:CreateTexture(nil, "BACKGROUND")
        hover:SetAllPoints(); hover:SetColorTexture(1, 0.72, 0.2, 0.08); hover:Hide()
        row.hover = hover
        row.icon = row:CreateTexture(nil, "ARTWORK")
        row.icon:SetSize(20, 20); row.icon:SetPoint("LEFT", 14, 0)
        row.name = row:CreateFontString(nil, "ARTWORK", "GameFontNormal")
        row.name:SetPoint("LEFT", row.icon, "RIGHT", 8, 5)
        row.name:SetPoint("RIGHT", -96, 0); row.name:SetJustifyH("LEFT"); row.name:SetWordWrap(false)
        row.detail = row:CreateFontString(nil, "ARTWORK", "GameFontDisableSmall")
        row.detail:SetPoint("TOPLEFT", row.name, "BOTTOMLEFT", 0, -1)
        row.detail:SetPoint("RIGHT", -96, 0); row.detail:SetJustifyH("LEFT"); row.detail:SetWordWrap(false)
        AddChoices(row, 24, 4, 14)
        return row
    end,
}

-- Minimal: no frame. Soft dark strips fading to the right, glyph buttons.
styles.minimal = {
    width = 260, rowHeight = 24, gap = 3, top = 18, bottom = 0,
    Decorate = function(frame)
        local title = frame:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
        title:SetPoint("TOPLEFT", 6, -2)
        title:SetShadowOffset(1, -1)
        local close = SmallClose(frame)
        close:SetSize(18, 18)
        close:SetPoint("TOPRIGHT", 0, 2)
        return title, close
    end,
    Row = function(frame)
        local row = CreateFrame("Frame", nil, frame)
        local strip = row:CreateTexture(nil, "BACKGROUND")
        strip:SetAllPoints()
        strip:SetColorTexture(0, 0, 0, 0.5)
        pcall(strip.SetGradient, strip, "HORIZONTAL", CreateColor(0, 0, 0, 0.72), CreateColor(0, 0, 0, 0.18))
        row.bar = row:CreateTexture(nil, "ARTWORK")
        row.bar:SetPoint("TOPLEFT"); row.bar:SetPoint("BOTTOMLEFT"); row.bar:SetWidth(2)
        row.icon = row:CreateTexture(nil, "ARTWORK")
        row.icon:SetSize(16, 16); row.icon:SetPoint("LEFT", 8, 0)
        row.name = row:CreateFontString(nil, "ARTWORK", "GameFontHighlight")
        row.name:SetPoint("LEFT", row.icon, "RIGHT", 6, 0)
        row.name:SetPoint("RIGHT", -70, 0); row.name:SetJustifyH("LEFT"); row.name:SetWordWrap(false)
        AddChoices(row, 18, 4, 6)
        -- Quiet until you point at it.
        row.fade = function(on)
            local alpha = on and 1 or 0.6
            row.companion:SetAlpha(alpha); row.acquaintance:SetAlpha(alpha); row.pass:SetAlpha(alpha)
        end
        row.fade(false)
        return row
    end,
}

local frames = {}
local function Build(styleKey)
    local style = styles[styleKey] or styles.cards
    local frame = frames[styleKey]
    if frame then return frame, style end
    frame = CreateFrame("Frame", "CompanionJournalGroupPrompt_" .. styleKey, UIParent)
    frame:SetFrameStrata("DIALOG")
    frame:SetClampedToScreen(true)
    frame:SetMovable(true)
    frame:EnableMouse(true)
    frame:RegisterForDrag("LeftButton")
    frame:SetScript("OnDragStart", frame.StartMoving)
    frame:SetScript("OnDragStop", function(self)
        self:StopMovingOrSizing()
        local point, _, relativePoint, x, y = self:GetPoint(1)
        A.db.groupPromptPoint = {point = point, relativePoint = relativePoint, x = x, y = y}
    end)
    frame:SetWidth(style.width)
    frame.title, frame.close = style.Decorate(frame)
    -- "and 3 more..." under the rows when more people left than fit.
    frame.more = frame:CreateFontString(nil, "OVERLAY", "GameFontDisableSmall")
    frame.more:SetJustifyH("CENTER")
    frame.rows = {}
    frame:Hide()
    frames[styleKey] = frame
    return frame, style
end

local function Place(frame)
    local saved = A.db.groupPromptPoint
    frame:ClearAllPoints()
    if type(saved) == "table" and type(saved.point) == "string" and type(saved.x) == "number" and type(saved.y) == "number" then
        frame:SetPoint(saved.point, UIParent, saved.relativePoint or saved.point, saved.x, saved.y)
    else
        frame:SetPoint("TOP", UIParent, "TOP", 0, -150)
    end
end

function A.RefreshGroupPrompt()
    -- "loot" was the first test style; Cards replaced it.
    if A.db.groupPromptStyle == "loot" then A.db.groupPromptStyle = "cards" end
    local styleKey = styles[A.db.groupPromptStyle] and A.db.groupPromptStyle or "cards"
    for key, other in pairs(frames) do if key ~= styleKey then other:Hide() end end
    local displayed = preview or queue
    if #displayed == 0 or (InCombatLockdown and InCombatLockdown()) then
        if frames[styleKey] then frames[styleKey]:Hide() end
        if #displayed > 0 and combatWatcher and not waitingForCombat then
            waitingForCombat = true
            combatWatcher:RegisterEvent("PLAYER_REGEN_ENABLED")
        end
        return
    end
    local frame, style = Build(styleKey)
    local shown = math.min(#displayed, MAX_ROWS)
    for i = 1, shown do
        local row = frame.rows[i]
        if not row then
            row = style.Row(frame)
            row:SetSize(style.width - (styleKey == "legacy" and 16 or 0), style.rowHeight)
            row:SetPoint("TOPLEFT", styleKey == "legacy" and 8 or 0, -(style.top + (i - 1) * (style.rowHeight + style.gap)))
            local hover = function(on)
                if row.hover then row.hover:SetShown(on) end
                if row.fade then row.fade(on) end
            end
            row.companion.hoverRow, row.acquaintance.hoverRow, row.pass.hoverRow = hover, hover, hover
            frame.rows[i] = row
        end
        local entry = displayed[i]
        row.index = i
        row.name:SetText(ShortName(entry.name) .. ((entry.test or entry.preview) and " |cff888888(test)|r" or ""))
        row.name:SetTextColor(ClassColor(entry.class))
        if row.detail then row.detail:SetText(Detail(entry)) end
        if row.bar then row.bar:SetColorTexture(ClassColor(entry.class)) end
        SetClassIcon(row.icon, entry.class)
        row:Show()
    end
    for i = shown + 1, #frame.rows do frame.rows[i]:Hide() end
    frame.title:SetText(preview and "Group prompt preview" or Headline())
    local rowsBottom = style.top + shown * (style.rowHeight + style.gap) - style.gap
    local extra = #displayed - shown
    frame.more:SetShown(extra > 0)
    frame.more:SetText(extra > 0 and ("and " .. extra .. " more after these") or "")
    frame.more:ClearAllPoints()
    frame.more:SetPoint("TOP", frame, "TOP", 0, -(rowsBottom + 5))
    frame:SetHeight(rowsBottom + (extra > 0 and 20 or 0) + style.bottom)
    if not frame:IsShown() then Place(frame); frame:Show() end
end

-- Popups wait until combat ends; nobody wants a dialog mid-fight.
combatWatcher = CreateFrame("Frame")
combatWatcher:SetScript("OnEvent", function(self)
    self:UnregisterEvent("PLAYER_REGEN_ENABLED")
    waitingForCombat = false
    A.RefreshGroupPrompt()
end)
function A.ShowGroupPrompt()
    if InCombatLockdown and InCombatLockdown() then
        A.RefreshGroupPrompt()
        if not waitingForCombat then
            waitingForCombat = true
            combatWatcher:RegisterEvent("PLAYER_REGEN_ENABLED")
        end
        return
    end
    A.RefreshGroupPrompt()
end
