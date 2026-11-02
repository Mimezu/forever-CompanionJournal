local _, A = ...
-- One tucked-in reference slip, shared by the book and the enlarged reader.
-- Opening a slip only changes this transient UI, never a character's history.
local slip, dismiss, current, owner, trail
-- Whole-word measured leaves. No scrolling, skipped endings or reduced font.
function A.LoreNotePages(text, measure, capacity)
    local pages, page = {}, ""
    text = tostring(text or ""):gsub("\r\n", "\n"):gsub("\r", "\n")
    for gap, word in text:gmatch("(%s*)(%S+)") do
        -- Keep authored paragraph/line breaks in the measured text. A break
        -- that lands on a page boundary needs no blank rows on the next leaf.
        local separator = gap:find("\n", 1, true) and gap:gsub("[^\n]", "") or " "
        local candidate = page == "" and word or (page .. separator .. word)
        if page ~= "" and measure(candidate) > capacity then pages[#pages + 1] = page; page = "" end
        if page == "" and measure(word) > capacity then
            -- Very long tokens are rare in authored prose; preserve UTF-8 even
            -- for a future imported token that cannot fit on one leaf.
            local part = ""
            for char in word:gmatch("[%z\1-\127\194-\244][\128-\191]*") do
                if part ~= "" and measure(part .. char) > capacity then pages[#pages + 1] = part; part = "" end
                part = part .. char
            end
            page = part
        else page = page == "" and word or (page .. separator .. word) end
    end
    if page ~= "" or #pages == 0 then pages[#pages + 1] = page end
    return pages
end
local function Turn(delta)
    if not slip or not slip.leaves then return end
    slip.leaf = math.max(1, math.min(#slip.leaves, (slip.leaf or 1) + delta))
    slip.body:SetText(slip.leaves[slip.leaf])
    slip.previous:SetShown(slip.leaf > 1)
    slip.next:SetShown(slip.leaf < #slip.leaves)
    slip.pageNumber:SetText(#slip.leaves > 1 and (slip.leaf .. " / " .. #slip.leaves) or "")
end
local function Button(parent, text, width)
    local button = CreateFrame("Button", nil, parent)
    button:SetSize(width, 22)
    local label = button:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
    label:SetAllPoints(); label:SetText(text); label:SetTextColor(0.35, 0.13, 0.07)
    label:SetShadowOffset(0, 0)
    button.label = label
    button:RegisterForClicks("LeftButtonUp", "RightButtonUp")
    button:SetScript("OnClick", function(self, mouseButton)
        if mouseButton == "RightButton" then A.CloseLoreNote()
        elseif self.leftClick then self.leftClick(self) end
    end)
    button:SetScript("OnEnter", function() label:SetTextColor(0.68, 0.20, 0.09) end)
    button:SetScript("OnLeave", function() label:SetTextColor(0.35, 0.13, 0.07) end)
    return button
end
function A.LoreNoteIsOpen() return slip and slip:IsShown() and owner and owner:IsShown() or false end
function A.CloseLoreNote()
    if dismiss then dismiss:Hide() end
    if not slip or not slip:IsShown() then return false end
    slip:Hide()
    return true
end
function A.HandleLoreNoteKey(key)
    if key == "ESCAPE" and A.LoreNoteIsOpen() then return A.CloseLoreNote() end
    return false
end
local function Make()
    if slip then return end
    -- A book-sized input layer consumes the first outside click, including clicks
    -- over links, page turns and other child controls. It exists only while the
    -- slip is open; no world clicks or global mouse handlers are involved.
    dismiss = CreateFrame("Button", "CompanionJournalLoreDismiss", UIParent)
    dismiss:Hide(); dismiss:EnableMouse(true)
    dismiss:RegisterForClicks("LeftButtonUp", "RightButtonUp")
    dismiss:SetScript("OnClick", function(_, mouseButton)
        if mouseButton == "LeftButton" or mouseButton == "RightButton" then A.CloseLoreNote() end
    end)
    -- (Letter: the book dims behind the document, which also says "click outside")
    dismiss.dim = dismiss:CreateTexture(nil, "BACKGROUND")
    dismiss.dim:SetAllPoints(); dismiss.dim:SetColorTexture(0, 0, 0, 0.45); dismiss.dim:Hide()
    slip = CreateFrame("Frame", "CompanionJournalLoreNote", UIParent, BackdropTemplateMixin and "BackdropTemplate" or nil)
    slip:Hide()
    slip:EnableMouse(true)
    slip:SetScript("OnMouseUp", function(_, mouseButton)
        if mouseButton == "RightButton" then A.CloseLoreNote() end
    end)
    if slip.SetClampedToScreen then slip:SetClampedToScreen(true) end
    -- QuestBG is a legacy sheet with transparent/unused space, not a scalable
    -- popup background. Paint the entire slip, then stretch the same parchment
    -- atlas used by the journal over an opaque backing. Text cannot show through.
    local backing = slip:CreateTexture(nil, "BACKGROUND", nil, -2)
    backing:SetAllPoints(); backing:SetColorTexture(0.82, 0.69, 0.46, 1)
    local paper = slip:CreateTexture(nil, "BACKGROUND", nil, -1)
    paper:SetPoint("TOPLEFT", 3, -3); paper:SetPoint("BOTTOMRIGHT", -3, 3)
    paper:SetAtlas("QuestBG-Parchment")
    slip.backing, slip.paper = backing, paper
    -- Letter and Tucked: a document of its own paper, laid on the book. The game's
    -- parchment popup, assembled as Blizzard does (corners, edges, background inset,
    -- the gold filigree on the top corners), at a scale set when it opens.
    slip.kit = {}
    local function Piece(key, atlas, layer, sub)
        local texture = slip:CreateTexture(nil, layer, nil, sub)
        texture:SetAtlas(atlas); texture:Hide()
        slip.kit[key] = texture
        return texture
    end
    Piece("background", "parchmentpopup-background", "BACKGROUND", 0)
    for _, corner in ipairs({"topleft", "topright", "bottomleft", "bottomright"}) do Piece(corner, "parchmentpopup-" .. corner, "ARTWORK", 2) end
    for _, side in ipairs({"top", "bottom", "left", "right"}) do Piece(side, "parchmentpopup-" .. side, "ARTWORK", 3) end
    for _, key in ipairs({"filigreeLeft", "filigreeRight"}) do
        local texture = Piece(key, "parchmentpopup-filigree", "ARTWORK", 5)
        texture:SetBlendMode("ADD"); texture:SetAlpha(0.45)
    end
    slip.rule = slip:CreateTexture(nil, "ARTWORK", nil, 6)
    slip.rule:SetTexture("Interface\\QuestFrame\\UI-HorizontalBreak")
    slip.rule:SetVertexColor(0.62, 0.42, 0.22, 0.9); slip.rule:Hide()
    if slip.SetBackdrop then
        slip:SetBackdrop({edgeFile = "Interface\\Tooltips\\UI-Tooltip-Border",
            tile = false, edgeSize = 14, insets = {left = 3, right = 3, top = 3, bottom = 3}})
        slip:SetBackdropBorderColor(0.45, 0.29, 0.13, 1)
    end
    local heading = slip:CreateFontString(nil, "OVERLAY", "GameFontNormalLarge")
    heading:SetPoint("TOPLEFT", 18, -16); heading:SetPoint("TOPRIGHT", -45, -16)
    heading:SetJustifyH("LEFT"); heading:SetTextColor(0.37, 0.10, 0.06)
    heading:SetShadowOffset(0, 0)
    slip.heading = heading
    local caption = slip:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
    caption:SetPoint("TOPLEFT", 18, -58); caption:SetPoint("TOPRIGHT", -18, -58)
    caption:SetJustifyH("LEFT"); caption:SetTextColor(0.43, 0.34, 0.23)
    caption:SetShadowOffset(0, 0)
    slip.caption = caption
    local body = slip:CreateFontString(nil, "OVERLAY", "QuestFont")
    body:SetJustifyH("LEFT"); body:SetJustifyV("TOP")
    body:SetTextColor(0.17, 0.12, 0.07); body:SetSpacing(3)
    body:SetFont(STANDARD_TEXT_FONT or "Fonts\\FRIZQT__.TTF", 14)
    body:SetShadowOffset(0, 0)
    slip:EnableMouseWheel(true)
    slip:SetScript("OnMouseWheel", function(_, delta) if delta ~= 0 then Turn(delta < 0 and 1 or -1) end end)
    slip.body = body
    local close = Button(slip, "X", 25)
    close:SetPoint("TOPRIGHT", -9, -9); close.leftClick = A.CloseLoreNote
    slip.close = close
    local back = Button(slip, "Back", 55)
    back:SetPoint("BOTTOMLEFT", 12, 10)
    back.leftClick = function()
        local prior = trail and table.remove(trail)
        if prior and A.OpenLoreNote(prior.id, owner, {owner = owner, loreBack = true}) then Turn(prior.leaf - 1) end
    end
    slip.back = back
    local previous = Button(slip, "<", 22)
    previous:SetPoint("BOTTOM", -40, 10); previous.leftClick = function() Turn(-1) end
    local nextPage = Button(slip, ">", 22)
    nextPage:SetPoint("BOTTOM", 40, 10); nextPage.leftClick = function() Turn(1) end
    local number = slip:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
    number:SetPoint("BOTTOM", 0, 16); number:SetTextColor(0.43, 0.34, 0.23)
    number:SetShadowOffset(0, 0)
    slip.previous, slip.next, slip.pageNumber = previous, nextPage, number
    local sources = Button(slip, "Sources", 66)
    sources:SetPoint("BOTTOMRIGHT", -12, 10)
    slip.sources = sources
    sources:SetScript("OnEnter", function(self)
        local entry = current and A.GetKnownLoreNote(current)
        if not entry or not GameTooltip then return end
        GameTooltip:SetOwner(self, "ANCHOR_LEFT")
        GameTooltip:SetText("Sources", 1, 0.82, 0)
        for _, source in ipairs(entry.sources or {}) do
            local label = source:gsub("StorageInvestigation/journal%-voice/review/corpus_vanilla_quests%.txt", "Captured quest dialogue")
                :gsub("StorageInvestigation/journal%-voice/quests_corpus%.txt", "Captured quest dialogue")
                :gsub("StorageInvestigation/journal%-voice/part1_corpus%.txt", "Captured Forever quest dialogue")
                :gsub("StorageInvestigation/journal%-voice/npc_corpus%.txt", "Captured NPC dialogue")
                :gsub("corpus_vanilla_quests%.txt", "Captured quest dialogue")
            GameTooltip:AddLine(label, 0.9, 0.9, 0.9, true)
        end
        GameTooltip:AddLine("Setting context, not a record of an encounter.", 0.75, 0.75, 0.75, true)
        GameTooltip:Show()
    end)
    sources:SetScript("OnLeave", function() if GameTooltip then GameTooltip:Hide() end end)
    slip.related = {}
    for i = 1, 3 do
        local button = Button(slip, "", 310)
        button:SetPoint("BOTTOMLEFT", 15, 32 + (3 - i) * 18)
        button:SetHeight(18); button.label:SetJustifyH("LEFT")
        button.leftClick = function(self)
            if self.noteID then A.OpenLoreNote(self.noteID, owner, {owner = owner, loreRelated = true}) end
        end
        slip.related[i] = button
    end
    slip:SetScript("OnHide", function(self)
        dismiss:Hide()
        current, owner, trail = nil, nil, nil
        if GameTooltip then GameTooltip:Hide() end
        -- A hidden parent must not resurrect a stale slip when reopened.
        if self:IsShown() then self:Hide() end
    end)
    -- Prevent the default Escape handler from closing both slip and book.
    -- Older clients without propagation use the public HandleLoreNoteKey hook.
    -- SetPropagateKeyboardInput is protected in combat: left alone there, every
    -- key propagates (Escape then closes the book as well, which is harmless).
    if slip.EnableKeyboard and slip.SetPropagateKeyboardInput then
        slip:EnableKeyboard(true); slip:SetPropagateKeyboardInput(true)
        slip:SetScript("OnKeyDown", function(self, key)
            local handled = key == "ESCAPE"
            if not (InCombatLockdown and InCombatLockdown()) then self:SetPropagateKeyboardInput(not handled) end
            if handled then A.CloseLoreNote() end
        end)
    end
end
local function Owner(anchor, context)
    if type(context) == "table" and context.owner then return context.owner end
    local candidate, frame = nil, anchor
    for _ = 1, 16 do
        if not frame or frame == UIParent then break end
        if frame.GetWidth and frame.GetHeight and frame:GetWidth() >= 180 and frame:GetHeight() >= 220 then candidate = frame end
        frame = frame.GetParent and frame:GetParent()
    end
    return candidate
end
local function ContentLevel(frame)
    local level = frame.GetFrameLevel and frame:GetFrameLevel() or 0
    if frame.GetChildren then
        for _, child in ipairs({frame:GetChildren()}) do
            if child ~= slip and child ~= dismiss then level = math.max(level, ContentLevel(child)) end
        end
    end
    return level
end
function A.OpenLoreNote(id, anchor, context)
    local knowledge = A.LoreKnowledge()
    local entry = A.GetKnownLoreNote(id, knowledge)
    if not entry then return false end
    local parent = Owner(anchor, context)
    if not parent or not parent.GetWidth or not parent.GetHeight or not parent.IsShown or not parent:IsShown() then return false end
    local style = A.BookVariant and A.BookVariant("loreNote") or "slip"
    if style ~= "letter" and style ~= "tucked" then style = "slip" end
    local top = parent.rightPage and 94 or parent.page and 48 or 12
    local bottom = parent.rightPage and 60 or 24
    local width, height = math.min(400, parent:GetWidth() - 24), math.min(405, parent:GetHeight() - top - bottom)
    if style == "letter" then
        width, height = math.min(460, parent:GetWidth() - 120), math.min(480, parent:GetHeight() - (parent.rightPage and 110 or 60))
    elseif style == "tucked" then
        width, height = 310, math.min(440, parent:GetHeight() - (parent.rightPage and 150 or 80))
    end
    if width < 280 or height < 270 then return false end
    Make()
    if owner ~= parent or not slip:IsShown() or not (context and (context.loreRelated or context.loreBack)) then trail = {} end
    if context and context.loreRelated and current and current ~= id then trail[#trail + 1] = {id = current, leaf = slip.leaf or 1} end
    owner, current = parent, id
    if GameTooltip then GameTooltip:Hide() end
    local level = ContentLevel(parent)
    dismiss:SetParent(parent); dismiss:ClearAllPoints(); dismiss:SetAllPoints(parent)
    dismiss:SetFrameStrata(parent.GetFrameStrata and parent:GetFrameStrata() or "DIALOG")
    dismiss:SetFrameLevel(level + 1)
    slip:SetParent(parent); slip:ClearAllPoints()
    if style == "letter" then
        -- (centred over the book, across the fold)
        slip:SetPoint("CENTER", parent, "CENTER", 0, parent.rightPage and -12 or 0)
    elseif style == "tucked" then
        -- (slipped into the book's outer edge, beside the page that was being read)
        local page = type(context) == "table" and context.page
        local left = page and (page == parent.leftPage or page == parent.contents)
        if left then slip:SetPoint("TOPRIGHT", parent, "TOPLEFT", 150, -(parent.rightPage and 110 or 40))
        else slip:SetPoint("TOPLEFT", parent, "TOPRIGHT", -150, -(parent.rightPage and 110 or 40)) end
    else
        slip:SetPoint("TOPRIGHT", parent, "TOPRIGHT", -12, -top)
    end
    slip:SetSize(width, height)
    -- (the paper: the old slip, or the document's own parchment)
    local kit = style ~= "slip"
    slip.backing:SetShown(not kit); slip.paper:SetShown(not kit)
    if slip.SetBackdropBorderColor then slip:SetBackdropBorderColor(0.45, 0.29, 0.13, kit and 0 or 1) end
    local scale = math.min(width, height) / 820
    for key, texture in pairs(slip.kit) do texture:SetShown(kit); texture:ClearAllPoints() end
    if kit then
        local k, c = slip.kit, math.floor(167 * scale + 0.5)
        k.topleft:SetSize(c, c); k.topleft:SetPoint("TOPLEFT")
        k.topright:SetSize(c, c); k.topright:SetPoint("TOPRIGHT")
        k.bottomleft:SetSize(c, c); k.bottomleft:SetPoint("BOTTOMLEFT")
        k.bottomright:SetSize(c, c); k.bottomright:SetPoint("BOTTOMRIGHT")
        k.top:SetPoint("TOPLEFT", k.topleft, "TOPRIGHT"); k.top:SetPoint("TOPRIGHT", k.topright, "TOPLEFT"); k.top:SetHeight(c)
        k.bottom:SetPoint("BOTTOMLEFT", k.bottomleft, "BOTTOMRIGHT"); k.bottom:SetPoint("BOTTOMRIGHT", k.bottomright, "BOTTOMLEFT"); k.bottom:SetHeight(c)
        k.left:SetPoint("TOPLEFT", k.topleft, "BOTTOMLEFT"); k.left:SetPoint("BOTTOMLEFT", k.bottomleft, "TOPLEFT"); k.left:SetWidth(c)
        k.right:SetPoint("TOPRIGHT", k.topright, "BOTTOMRIGHT"); k.right:SetPoint("BOTTOMRIGHT", k.bottomright, "TOPRIGHT"); k.right:SetWidth(c)
        local inset = math.floor(20 * scale + 0.5)
        k.background:SetPoint("TOPLEFT", inset, -inset); k.background:SetPoint("BOTTOMRIGHT", -inset, inset)
        local fw, fh = math.floor(185 * scale + 0.5), math.floor(152 * scale + 0.5)
        k.filigreeLeft:SetSize(fw, fh); k.filigreeLeft:SetPoint("TOPLEFT", 5 * scale, 2 * scale)
        k.filigreeRight:SetSize(fw, fh); k.filigreeRight:SetPoint("TOPRIGHT", -5 * scale, 2 * scale)
        local info = C_Texture and C_Texture.GetAtlasInfo and C_Texture.GetAtlasInfo("parchmentpopup-filigree")
        if info and (info.file or info.filename) then
            k.filigreeRight:SetTexture(info.file or info.filename)
            k.filigreeRight:SetTexCoord(info.rightTexCoord, info.leftTexCoord, info.topTexCoord, info.bottomTexCoord)
        end
    end
    -- (the text's room inside the paper)
    local padX, padTop, padBottom = 18, 16, 0
    if kit then padX, padTop, padBottom = 36, 34, 18 end
    slip.heading:ClearAllPoints(); slip.heading:SetPoint("TOPLEFT", padX, -padTop); slip.heading:SetPoint("TOPRIGHT", -(kit and padX or 45), -padTop)
    slip.heading:SetJustifyH(kit and "CENTER" or "LEFT")
    if kit and QuestFont_Huge then slip.heading:SetFontObject(QuestFont_Huge) elseif not kit then slip.heading:SetFontObject(GameFontNormalLarge) end
    slip.heading:SetTextColor(0.37, 0.10, 0.06); slip.heading:SetShadowOffset(0, 0)
    slip.caption:SetJustifyH(kit and "CENTER" or "LEFT")
    slip.close:ClearAllPoints(); slip.close:SetPoint("TOPRIGHT", kit and -(padX - 14) or -9, kit and -(padTop - 10) or -9)
    slip.close.label:SetText(kit and "\195\151" or "X")
    slip.back:ClearAllPoints(); slip.back:SetPoint("BOTTOMLEFT", 12 + (kit and padX - 18 or 0), 10 + padBottom)
    slip.previous:ClearAllPoints(); slip.previous:SetPoint("BOTTOM", -40, 10 + padBottom)
    slip.next:ClearAllPoints(); slip.next:SetPoint("BOTTOM", 40, 10 + padBottom)
    slip.pageNumber:ClearAllPoints(); slip.pageNumber:SetPoint("BOTTOM", 0, 16 + padBottom)
    slip.sources:ClearAllPoints(); slip.sources:SetPoint("BOTTOMRIGHT", -12 - (kit and padX - 18 or 0), 10 + padBottom)
    for i, button in ipairs(slip.related) do
        button:ClearAllPoints(); button:SetPoint("BOTTOMLEFT", 15 + (kit and padX - 18 or 0), 32 + (3 - i) * 18 + padBottom)
    end
    dismiss.dim:SetShown(style == "letter")
    slip:SetFrameStrata(parent.GetFrameStrata and parent:GetFrameStrata() or "DIALOG")
    if slip.SetFrameLevel then slip:SetFrameLevel(level + 2) end
    slip.heading:SetText(entry.title)
    slip.heading:SetWidth(width - (kit and padX * 2 or 63))
    local headingHeight = math.max(20, slip.heading:GetStringHeight())
    local captionY = padTop + headingHeight + 7
    slip.caption:ClearAllPoints(); slip.caption:SetPoint("TOPLEFT", padX, -captionY)
    slip.caption:SetWidth(width - padX * 2)
    slip.caption:SetText(entry.kind .. "  |  " .. (entry.setting or "Classic / Forever") ..
        (entry.contextLabel and ("\n" .. entry.contextLabel) or ""))
    local bodyY = captionY + math.max(14, slip.caption:GetStringHeight()) + 12
    slip.rule:SetShown(kit)
    if kit then
        -- (the quest log's flourish under the title, as in the journal)
        slip.rule:ClearAllPoints(); slip.rule:SetSize(math.min(170, width - padX * 2), 20)
        slip.rule:SetPoint("TOP", slip, "TOP", 0, -(bodyY - 6))
        bodyY = bodyY + 20
    end
    local capacity = height - bodyY - 94 - padBottom
    if capacity < 24 then A.CloseLoreNote(); return false end
    slip.body:ClearAllPoints(); slip.body:SetPoint("TOPLEFT", padX, -bodyY)
    slip.body:SetWidth(width - padX * 2)
    slip.leaves = A.LoreNotePages(entry.body, function(text)
        slip.body:SetText(text); return slip.body:GetStringHeight()
    end, capacity)
    slip.capacity, slip.leaf = capacity, 1
    Turn(0)
    local related = {}
    for _, target in ipairs(entry.related or {}) do
        if target ~= id and A.GetKnownLoreNote(target, knowledge) then related[#related + 1] = target end
    end
    -- Only already-curated geography, never a chain successor or unseen ending.
    if #related == 0 and entry.zone then
        local target = A.LoreNoteResolve("p", entry.zone)
        local note = target and A.GetKnownLoreNote(target, knowledge)
        if note and (note.kind == "Place" or note.kind == "Region" or note.kind == "City") then related[1] = target end
    end
    for i, button in ipairs(slip.related) do
        local target = related[i]; button.noteID = target
        button:SetWidth(width - (kit and padX * 2 or 30))
        if target then button.label:SetText((kit and "See also: " or "Read: ") .. A.GetKnownLoreNote(target, knowledge).title); button:Show() else button:Hide() end
    end
    slip.back:SetShown(#trail > 0)
    if slip.SetPropagateKeyboardInput and not (InCombatLockdown and InCombatLockdown()) then slip:SetPropagateKeyboardInput(true) end
    dismiss:Show(); slip:Show()
    return true
end

function A.RefreshOpenLoreNote()
    if not A.LoreNoteIsOpen() or not current then return end
    local id, parent, leaf = current, owner, slip.leaf or 1
    if A.OpenLoreNote(id, parent, {owner = parent, loreBack = true}) then Turn(leaf - 1)
    else A.CloseLoreNote() end
end
