local addonName, A = ...
-- The addon's page in the game's settings (Esc > Options > AddOns): Open the
-- book, the slash command, the minimap button, and the keys.

local function Build()
    local panel = CreateFrame("Frame")
    local heading = panel:CreateFontString(nil, "ARTWORK", "GameFontNormalLarge")
    heading:SetPoint("TOPLEFT", 16, -16)
    heading:SetText("Companion Journal")

    local open = CreateFrame("Button", nil, panel, "UIPanelButtonTemplate")
    open:SetSize(140, 26)
    open:SetPoint("TOPLEFT", heading, "BOTTOMLEFT", 0, -14)
    open:SetText("Open")
    open:SetScript("OnClick", function()
        if SettingsPanel and SettingsPanel:IsShown() then HideUIPanel(SettingsPanel) end
        if A.OpenBook then A.OpenBook() end
    end)
    local slash = panel:CreateFontString(nil, "ARTWORK", "GameFontDisableSmall")
    slash:SetPoint("LEFT", open, "RIGHT", 12, 0)
    slash:SetText("/cj")

    local minimap = CreateFrame("CheckButton", nil, panel, "UICheckButtonTemplate")
    minimap:SetPoint("TOPLEFT", open, "BOTTOMLEFT", -4, -14)
    local minimapLabel = minimap.Text or minimap:CreateFontString(nil, "ARTWORK", "GameFontHighlight")
    if not minimap.Text then minimapLabel:SetPoint("LEFT", minimap, "RIGHT", 2, 0) end
    minimapLabel:SetText("Minimap icon")
    minimap:SetScript("OnClick", function(self)
        if not A.db then return end
        A.db.bookMinimap = self:GetChecked() and true or false
        if A.UpdateBookMinimap then A.UpdateBookMinimap() end
    end)

    local keysHead = panel:CreateFontString(nil, "ARTWORK", "GameFontNormal")
    keysHead:SetPoint("TOPLEFT", minimap, "BOTTOMLEFT", 4, -18)
    keysHead:SetText("Keys")
    local setters, anchor = {}, keysHead
    for _, item in ipairs(A.Keys.ACTIONS) do
        local label = panel:CreateFontString(nil, "ARTWORK", "GameFontHighlight")
        label:SetPoint("TOPLEFT", anchor, "BOTTOMLEFT", 0, anchor == keysHead and -12 or -18)
        label:SetWidth(140); label:SetJustifyH("LEFT")
        label:SetText(item.label)
        local button = CreateFrame("Button", nil, panel, "UIPanelButtonTemplate")
        button:SetSize(140, 22)
        button:SetPoint("LEFT", label, "RIGHT", 8, 0)
        local status = panel:CreateFontString(nil, "ARTWORK", "GameFontDisableSmall")
        status:SetPoint("LEFT", button, "RIGHT", 10, 0)
        setters[#setters + 1] = A.Keys.Setter(button, item.action, status)
        anchor = label
    end

    panel:SetScript("OnShow", function()
        minimap:SetChecked(not A.db or A.db.bookMinimap ~= false)
        for _, setter in ipairs(setters) do setter:Refresh() end
    end)

    local category = Settings.RegisterCanvasLayoutCategory(panel, "Companion Journal")
    Settings.RegisterAddOnCategory(category)
    A.settingsCategory = category
end

local loader = CreateFrame("Frame")
loader:RegisterEvent("PLAYER_LOGIN")
loader:SetScript("OnEvent", function(self)
    self:UnregisterAllEvents()
    if not (Settings and Settings.RegisterCanvasLayoutCategory and Settings.RegisterAddOnCategory) then return end
    local ok, err = pcall(Build)
    if not ok and geterrorhandler then geterrorhandler()(err) end
end)
