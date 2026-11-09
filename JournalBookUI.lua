local _, A = ...
-- The book: Companion Journal's window. /cj opens it.
-- Left page: the contents (your journal, then your people by circle). Right
-- page: the open journal, one chapter at a time; or, as a two-page spread,
-- two chapters side by side. The page styles A to E draw each chapter
-- (JournalStyles.lua), from the same book and storytellers.
-- Stage 1 of the book (StorageInvestigation\cj-book-layout-b\DESIGN.md).

A.defaults.bookSize = "a"      -- a, b, c (fixed sizes) or "custom" (dragged)
A.defaults.bookSpread = "one"  -- "one" chapter at a time, or "two" (a spread)
A.defaults.bookNotice = false  -- a notice when today's chapter is new and you rest
A.defaults.bookMinimap = true  -- the minimap button (with the book as /cj)

local SIZES = {a = {860, 580}, b = {1000, 660}, c = {1140, 740}}
local INK = {0.20, 0.11, 0.04}
local INK_SOFT = {0.36, 0.22, 0.08}
local CHAPTER = {0.42, 0.10, 0.04}
local CIRCLE_ORDER = {
    {"companion", "Companions", true},
    {"acquaintance", "Acquaintances"},
    {"campfire", "Campfire"},
    {"rival", "Rivals"},
}

local book
local BuildCard, BuildNotes, BuildAddBar, BuildWizard -- (below; Build uses them)
local Portrait, LookFor -- (portraits, below; the contents page uses them)
-- view: "journal" (contents + chapters), "settings" or "npcs".
local state = {key = nil, index = nil, view = "journal", settings = "reading", npc = nil, cardOpen = false, tab = "journal",
    collapsed = {acquaintance = true, campfire = true, rival = true}}

-- The variants to try in game, chosen on the Settings > Testing page. The first
-- choice of each is the default. stage: the build stage that brings it.
local BUILT = 8
local VARIANTS = {
    {key = "loreNote", label = "Lore notes", stage = 2,
        choices = {{"letter", "Letter over the book"}, {"tucked", "Tucked at the edge"}, {"slip", "Slip (before)"}}},
    {key = "marks", label = "Bookmarks", stage = 2,
        choices = {{"c", "Tools | journals"}, {"a", "Sections + pins"}, {"b", "Pins only"}}},
    {key = "toolsSide", label = "Bookmarks C: the tools' side", stage = 2,
        choices = {{"left", "Tools left"}, {"right", "Tools right"}}},
    {key = "card", label = "Companion card", stage = 3,
        choices = {{"a", "Header + quill"}, {"b", "Tabs"}, {"c", "Flip"}}},
    {key = "add", label = "Adding someone", stage = 4,
        choices = {{"a", "Smart button"}, {"b", "Three steps"}, {"c", "Today's flow"}}},
    {key = "ribbon", label = "Unread ribbons", stage = 5,
        choices = {{"a", "Every unread"}, {"b", "Newest + marks"}, {"c", "First unread"}}},
    {key = "portraitWhen", label = "Portraits: when", stage = 8,
        choices = {{"off", "Off"}, {"start", "Book start"}, {"ten", "Every 10 levels"}, {"level", "Each level"}}},
    {key = "portraitWhere", label = "Portraits: where", stage = 8,
        choices = {{"a", "Plate"}, {"b", "Facing page"}, {"c", "Cameo"}, {"d", "Contents"}, {"e", "Margin"}}},
    {key = "portraitFrame", label = "Portraits: frame", stage = 8,
        choices = {{"a", "Painted"}, {"b", "Cameo"}, {"c", "Scrapbook"}, {"d", "Plain"}}},
}
function A.BookVariant(key)
    local chosen = A.db and A.db.bookVariants and A.db.bookVariants[key]
    if chosen then return chosen end
    for _, variant in ipairs(VARIANTS) do if variant.key == key then return variant.choices[1][1] end end
    return nil
end
local function SetVariant(key, value)
    A.db.bookVariants = A.db.bookVariants or {}
    local changed = A.db.bookVariants[key] ~= value
    A.db.bookVariants[key] = value
    if changed and (key == "portraitWhen" or key == "portraitWhere" or key == "portraitFrame") then
        state.pageCache = nil
        if A.RefreshBook then A.RefreshBook() end
    end
end
A.SetBookVariant = SetVariant
-- Pinned companions (bookmarks), up to six.
local MAX_PINS = 6
local function Pins()
    local db = A.db
    db.bookPins = type(db.bookPins) == "table" and db.bookPins or {}
    -- (people no longer in the list lose their pin)
    for i = #db.bookPins, 1, -1 do if not A.People[db.bookPins[i]] then table.remove(db.bookPins, i) end end
    return db.bookPins
end
local function IsPinned(key) for _, pinned in ipairs(Pins()) do if pinned == key then return true end end return false end
local function TogglePin(key)
    local pins = Pins()
    for i, pinned in ipairs(pins) do if pinned == key then table.remove(pins, i); return end end
    if #pins < MAX_PINS then pins[#pins + 1] = key end
end

local function SelfOf(key) return type(key) == "string" and key:match("^self:(.+)$") or nil end
local function Shown()
    local key = state.key
    if not key then return nil end
    local charKey = SelfOf(key)
    if charKey then return A.SelfPerson and A.SelfPerson(charKey) end
    if state.owner then return A.PersonAs(key, state.owner) end
    return A.People[key]
end
local function ShortName(name) return (tostring(name or ""):gsub("%-.*$", "")) end
local function ClassColor(class)
    local color = class and ((C_ClassColor and C_ClassColor.GetClassColor and C_ClassColor.GetClassColor(class))
        or (RAID_CLASS_COLORS and RAID_CLASS_COLORS[class]))
    if color then return color.r, color.g, color.b end
    return 1, 0.82, 0
end

-- The book's look: the spellbook's pages, cloth ribbons, ink on paper.
local function HasAtlas(name) return C_Texture and C_Texture.GetAtlasInfo and C_Texture.GetAtlasInfo(name) ~= nil end
local function Font(name, fallback) return _G[name] and name or fallback end
-- The pages: the spellbook's pair (burnt outer edges; they meet at the fold,
-- and the spellbook's top bar finishes their top edge).
local PAGES_B = {left = "spellbook-background-evergreen-left", right = "spellbook-background-evergreen-right"}
local function SetBookPage(texture, side)
    texture:SetTexCoord(0, 1, 0, 1)
    texture:SetAtlas(PAGES_B[side] or PAGES_B.right, false)
end
-- One frame of the spellbook's page-corner flipbook (4 x 2 frames; 1 lies flat, 8 curls most).
local function SetCornerFrame(texture, n)
    local info = C_Texture and C_Texture.GetAtlasInfo and C_Texture.GetAtlasInfo("spellbook-corner-flipbook-evergreen")
    local file = info and (info.file or info.filename)
    if not file then return false end
    local du, dv = (info.rightTexCoord - info.leftTexCoord) / 4, (info.bottomTexCoord - info.topTexCoord) / 2
    local col, row = (n - 1) % 4, math.floor((n - 1) / 4)
    texture:SetTexture(file)
    texture:SetTexCoord(info.leftTexCoord + du * col, info.leftTexCoord + du * (col + 1), info.topTexCoord + dv * row, info.topTexCoord + dv * (row + 1))
    return true
end
-- A cloth ribbon (the activities ribbon, turned on its side): the body stretches, the
-- swallowtail keeps its shape at the outer end.
local function RibbonArt(mark, left, tint, desaturate)
    local info = C_Texture and C_Texture.GetAtlasInfo and C_Texture.GetAtlasInfo("activities-ribbon")
    local file = info and (info.file or info.filename)
    if not file then return false end
    local l, r, t, b = info.leftTexCoord, info.rightTexCoord, info.topTexCoord, info.bottomTexCoord
    local function V(f) return t + (b - t) * f end
    local v0, v1, v2 = V(0.12), V(0.55), V(1)
    local tail = math.max(8, math.floor(0.45 * info.height * mark:GetHeight() / info.width + 0.5))
    for _, texture in ipairs({mark.body, mark.tail}) do
        texture:SetTexture(file)
        if texture.SetDesaturated then texture:SetDesaturated(desaturate and true or false) end
        texture:SetVertexColor(tint[1], tint[2], tint[3], 1)
        texture:ClearAllPoints(); texture:Show()
    end
    -- (SetTexCoord's corners: top-left, bottom-left, top-right, bottom-right)
    if left then
        mark.tail:SetPoint("TOPLEFT"); mark.tail:SetPoint("BOTTOMLEFT"); mark.tail:SetWidth(tail)
        mark.body:SetPoint("TOPLEFT", mark.tail, "TOPRIGHT"); mark.body:SetPoint("BOTTOMRIGHT")
        mark.body:SetTexCoord(l, v1, r, v1, l, v0, r, v0)
        mark.tail:SetTexCoord(l, v2, r, v2, l, v1, r, v1)
    else
        mark.tail:SetPoint("TOPRIGHT"); mark.tail:SetPoint("BOTTOMRIGHT"); mark.tail:SetWidth(tail)
        mark.body:SetPoint("TOPLEFT"); mark.body:SetPoint("BOTTOMRIGHT", mark.tail, "BOTTOMLEFT")
        mark.body:SetTexCoord(l, v0, r, v0, l, v1, r, v1)
        mark.tail:SetTexCoord(l, v1, r, v1, l, v2, r, v2)
    end
    return true
end
-- The page-turn arrows of the game's books, in place of a switch's leather.
local function PageArrow(button, which)
    button.fill:Hide(); button.label:Hide()
    for _, edge in ipairs(button.edges) do edge:Hide() end
    button:SetSize(28, 28)
    button:SetNormalTexture("Interface\\Buttons\\UI-SpellbookIcon-" .. which .. "Page-Up")
    button:SetPushedTexture("Interface\\Buttons\\UI-SpellbookIcon-" .. which .. "Page-Down")
    button:SetDisabledTexture("Interface\\Buttons\\UI-SpellbookIcon-" .. which .. "Page-Disabled")
    button:SetHighlightTexture("Interface\\Buttons\\UI-Common-MouseHilight", "ADD")
end
-- A choice written on the paper: ink, and the quest log's bar when chosen.
local function PaperChoice(parent, label, onClick)
    local button = CreateFrame("Button", nil, parent)
    button.paper = true
    button.bar = button:CreateTexture(nil, "BACKGROUND")
    button.bar:SetAllPoints(); button.bar:SetTexture("Interface\\QuestFrame\\UI-QuestLogTitleHighlight")
    button.bar:SetBlendMode("ADD"); button.bar:SetVertexColor(0.85, 0.6, 0.25, 0.7); button.bar:Hide()
    local hover = button:CreateTexture(nil, "HIGHLIGHT")
    hover:SetAllPoints(); hover:SetTexture("Interface\\QuestFrame\\UI-QuestTitleHighlight")
    hover:SetBlendMode("ADD"); hover:SetVertexColor(0.85, 0.6, 0.25, 0.45)
    button.label = button:CreateFontString(nil, "ARTWORK", Font("QuestFontNormalSmall", "GameFontNormalSmall"))
    button.label:SetPoint("CENTER", 0, 0); button.label:SetText(label)
    if button.label.SetShadowOffset then button.label:SetShadowOffset(0, 0) end
    button.label:SetTextColor(INK_SOFT[1], INK_SOFT[2], INK_SOFT[3])
    button.width = math.floor(math.max(button.label:GetStringWidth() or 0, #label * 5) + 20)
    button:SetSize(button.width, 20)
    button:SetScript("OnClick", onClick)
    if A.StyleBookControl then
        button.paper = false
        button.bar:Hide(); hover:Hide()
        A.StyleBookControl(button, false)
    end
    return button
end
-- The page scroll bar, slim and brown, with no arrows.
local function SlimScrollBar(scroll)
    local bar = scroll.ScrollBar
    if type(bar) ~= "table" then return end
    for _, key in ipairs({"ScrollUpButton", "ScrollDownButton"}) do
        if type(bar[key]) == "table" then bar[key]:SetAlpha(0); bar[key]:EnableMouse(false) end
    end
    bar:ClearAllPoints()
    bar:SetPoint("TOPLEFT", scroll, "TOPRIGHT", 10, 0); bar:SetPoint("BOTTOMLEFT", scroll, "BOTTOMRIGHT", 10, 0)
    bar:SetWidth(8)
    local thumb = bar.ThumbTexture or (bar.GetThumbTexture and bar:GetThumbTexture())
    if thumb then
        if HasAtlas("minimal-scrollbar-small-thumb-middle") then thumb:SetAtlas("minimal-scrollbar-small-thumb-middle")
        else thumb:SetColorTexture(0.45, 0.32, 0.18, 0.75) end
        thumb:SetSize(5, 34)
        thumb:SetVertexColor(0.55, 0.40, 0.24, 0.8)
    end
    local track = bar:CreateTexture(nil, "BACKGROUND")
    track:SetPoint("TOP"); track:SetPoint("BOTTOM"); track:SetWidth(1)
    track:SetColorTexture(0.30, 0.18, 0.07, 0.25)
end

-- A small switch button: dark leather, a thin rim, gold when chosen.
local function Toggle(parent, label, width, title, tip, onClick)
    local button = CreateFrame("Button", nil, parent)
    button:SetSize(width, 19)
    button.fill = button:CreateTexture(nil, "BACKGROUND")
    button.fill:SetAllPoints()
    button.edges = {}
    for _, side in ipairs({"TOP", "BOTTOM", "LEFT", "RIGHT"}) do
        local edge = button:CreateTexture(nil, "BORDER")
        if side == "TOP" or side == "BOTTOM" then
            edge:SetPoint(side .. "LEFT"); edge:SetPoint(side .. "RIGHT"); edge:SetHeight(1)
        else
            edge:SetPoint("TOP" .. side); edge:SetPoint("BOTTOM" .. side); edge:SetWidth(1)
        end
        button.edges[#button.edges + 1] = edge
    end
    local hover = button:CreateTexture(nil, "HIGHLIGHT")
    hover:SetAllPoints(); hover:SetColorTexture(1, 0.7, 0.2, 0.12)
    button.label = button:CreateFontString(nil, "ARTWORK", "GameFontHighlightSmall")
    button.label:SetPoint("CENTER", 0, 0)
    button.label:SetText(label)
    button:SetScript("OnClick", onClick)
    button:SetScript("OnEnter", function(self)
        if not title then return end
        GameTooltip:SetOwner(self, "ANCHOR_TOP")
        GameTooltip:SetText(title, 1, 0.82, 0)
        if tip then GameTooltip:AddLine(tip, 0.9, 0.9, 0.9, true) end
        GameTooltip:Show()
    end)
    button:SetScript("OnLeave", function() GameTooltip:Hide() end)
    -- (unchosen until told otherwise: the leather and the dim rim)
    button.fill:SetColorTexture(0.18, 0.13, 0.07, 1)
    for _, edge in ipairs(button.edges) do edge:SetColorTexture(0.42, 0.32, 0.19, 1) end
    button.label:SetTextColor(0.91, 0.85, 0.69)
    return button
end
local function SetChosen(button, chosen)
    if button.paper then
        button.bar:SetShown(chosen and true or false)
        local color = chosen and CHAPTER or INK_SOFT
        button.label:SetTextColor(color[1], color[2], color[3])
        return
    end
    if chosen then button.fill:SetColorTexture(0.29, 0.20, 0.06, 1) else button.fill:SetColorTexture(0.18, 0.13, 0.07, 1) end
    for _, edge in ipairs(button.edges) do
        if chosen then edge:SetColorTexture(1, 0.82, 0, 1) else edge:SetColorTexture(0.42, 0.32, 0.19, 1) end
    end
    if chosen then button.label:SetTextColor(1, 0.82, 0) else button.label:SetTextColor(0.91, 0.85, 0.69) end
end

-- Small, scrollable popovers keep note actions out of the reading page and
-- avoid Blizzard's context-menu focus problems in the gamepad interface.
local function BookPopup(anchor, owner, title, subtitle, items)
    if not book then return end
    local popup = book.notePopup
    if not popup then
        popup = CreateFrame("Frame", nil, owner or book)
        popup:SetWidth(270); popup:SetFrameStrata("FULLSCREEN_DIALOG"); popup:EnableMouse(true); popup:SetClampedToScreen(true)
        local paper = popup:CreateTexture(nil, "BACKGROUND"); paper:SetAllPoints(); paper:SetAtlas("QuestBG-Parchment")
        popup.title = popup:CreateFontString(nil, "ARTWORK", "GameFontNormal")
        popup.title:SetPoint("TOPLEFT", 12, -12); popup.title:SetTextColor(unpack(CHAPTER)); popup.title:SetWidth(222); popup.title:SetWordWrap(false)
        popup.subtitle = popup:CreateFontString(nil, "ARTWORK", "GameFontHighlightSmall")
        popup.subtitle:SetPoint("TOPLEFT", 12, -32); popup.subtitle:SetWidth(244); popup.subtitle:SetHeight(30); popup.subtitle:SetTextColor(unpack(INK_SOFT))
        popup.close = Toggle(popup, "x", 20, nil, nil, function() popup:Hide() end)
        popup.close:SetPoint("TOPRIGHT", -8, -9)
        popup.scroll = CreateFrame("ScrollFrame", nil, popup, "UIPanelScrollFrameTemplate")
        popup.scroll:SetPoint("TOPLEFT", 12, -66); popup.scroll:SetPoint("BOTTOMRIGHT", -28, 12)
        popup.child = CreateFrame("Frame", nil, popup.scroll); popup.child:SetWidth(230)
        popup.scroll:SetScrollChild(popup.child); SlimScrollBar(popup.scroll)
        popup.rows = {}
        book.notePopup = popup
    end
    popup:SetParent(owner or book); popup:SetFrameLevel((owner or book):GetFrameLevel() + 20)
    popup:ClearAllPoints(); popup:SetPoint("BOTTOMLEFT", anchor, "TOPLEFT", 0, 8)
    popup:SetHeight(78 + math.min(8, math.max(1, #items)) * 26)
    popup.title:SetText(title); popup.subtitle:SetText(subtitle or "")
    for i, item in ipairs(items) do
        local row = popup.rows[i]
        if not row then
            row = CreateFrame("Button", nil, popup.child); row:SetSize(230, 24)
            row.label = row:CreateFontString(nil, "ARTWORK", "GameFontHighlightSmall")
            row.label:SetPoint("LEFT", 4, 0); row.label:SetWidth(222); row.label:SetJustifyH("LEFT"); row.label:SetWordWrap(false); row.label:SetTextColor(unpack(INK))
            local hover = row:CreateTexture(nil, "HIGHLIGHT"); hover:SetAllPoints(); hover:SetColorTexture(0.6, 0.3, 0, 0.15)
            popup.rows[i] = row
        end
        row:ClearAllPoints(); row:SetPoint("TOPLEFT", 0, -(i - 1) * 26); row.label:SetText(item.label)
        row:SetScript("OnClick", function() popup:Hide(); if item.action then item.action() end end)
        row:Show()
    end
    for i = #items + 1, #popup.rows do popup.rows[i]:Hide() end
    popup.child:SetHeight(math.max(26, #items * 26)); popup.scroll:SetVerticalScroll(0)
    popup:Show()
end
local function NoteContextMatches(person, key, owner)
    local current = Shown()
    return state.key == key and state.owner == owner and current and person
        and current.journal == person.journal and A.JournalCanWriteNotes and A.JournalCanWriteNotes(current)
end
local function ManualEntries(page, entries)
    local person, notes = page.notePerson, {}
    if not NoteContextMatches(person, state.key, state.owner) then return notes end
    for _, entry in ipairs(entries or {}) do
        if entry.k == "custom" and not entry.synthetic then
            for _, saved in ipairs(person.journal or {}) do
                if saved == entry then notes[#notes + 1] = entry; break end
            end
        end
    end
    return notes
end
-- Your notes are edited where they are written: a click turns the note into a text
-- field on the page. Enter (or clicking elsewhere) keeps the change, Escape drops it,
-- and clearing the text asks before the note is removed.
local function NoteEditor(page)
    if page.noteEditor then return page.noteEditor end
    local edit = CreateFrame("EditBox", nil, page.child)
    edit:SetMultiLine(true); edit:SetAutoFocus(false); edit:SetMaxLetters(300)
    edit:SetFontObject("QuestFont"); edit:SetTextColor(INK[1], INK[2], INK[3])
    edit:SetTextInsets(6, 6, 4, 4)
    edit:SetFrameLevel(page.child:GetFrameLevel() + 20)
    -- (a clean patch of paper over the old text, and a rule under it)
    local paper = edit:CreateTexture(nil, "BACKGROUND")
    paper:SetAllPoints(); paper:SetColorTexture(0.93, 0.85, 0.66, 0.98)
    local rule = edit:CreateTexture(nil, "BORDER")
    rule:SetPoint("BOTTOMLEFT"); rule:SetPoint("BOTTOMRIGHT"); rule:SetHeight(1)
    rule:SetColorTexture(INK_SOFT[1], INK_SOFT[2], INK_SOFT[3], 0.8)
    edit.help = edit:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
    edit.help:SetPoint("TOPRIGHT", edit, "BOTTOMRIGHT", 0, -3)
    edit.help:SetTextColor(INK_SOFT[1], INK_SOFT[2], INK_SOFT[3])
    if edit.help.SetShadowOffset then edit.help:SetShadowOffset(0, 0) end
    edit.help:SetText("Enter to keep, Esc to cancel. Clear it to remove the note.")
    edit.measure = edit:CreateFontString(nil, "ARTWORK", "QuestFont")
    edit.measure:SetPoint("TOPLEFT"); edit.measure:SetAlpha(0); edit.measure:SetWordWrap(true)
    local function Fit(self)
        self.measure:SetWidth(math.max(40, (self:GetWidth() or 200) - 12))
        self.measure:SetText((self:GetText() or "") ~= "" and self:GetText() or "M")
        self:SetHeight(math.max(24, math.ceil(self.measure:GetStringHeight() or 14) + 10))
    end
    edit:SetScript("OnTextChanged", Fit)
    edit:SetScript("OnEscapePressed", function(self) self.cancel = true; self:ClearFocus() end)
    edit:SetScript("OnEnterPressed", function(self) self:ClearFocus() end)
    edit:SetScript("OnEditFocusLost", function(self)
        local cancel, text, commit = self.cancel, self:GetText(), self.commit
        self.cancel, self.commit = nil, nil
        self:Hide()
        -- (after the current redraw, never inside it)
        if not cancel and commit then
            if C_Timer and C_Timer.After then C_Timer.After(0, function() commit(text) end) else commit(text) end
        end
    end)
    edit:Hide()
    page.noteEditor = edit
    return edit
end
local function EditNote(anchor, page, entry)
    local person, key, owner = page.notePerson, state.key, state.owner
    if not NoteContextMatches(person, key, owner) then return end
    -- (the note's first line on the page: the field covers the whole note from there)
    local top = anchor
    for _, line in ipairs(page.lines) do
        local hit = line.noteHit
        if hit and hit:IsShown() and hit.entries and hit:GetTop() and top:GetTop() and hit:GetTop() > top:GetTop() then
            for _, other in ipairs(hit.entries) do if other == entry then top = hit end end
        end
    end
    local edit = NoteEditor(page)
    edit:ClearAllPoints()
    edit:SetPoint("TOPLEFT", top, "TOPLEFT", -6, 4)
    edit:SetWidth(math.max(160, math.min((top:GetWidth() or 200) + 12, (page.child:GetWidth() or 300) + 6)))
    edit.commit = function(text)
        if not NoteContextMatches(person, key, owner) then return end
        text = (text or ""):gsub("^%s+", ""):gsub("%s+$", "")
        if text == "" then
            BookPopup(anchor, page.owner or book, "Remove this note?", entry.d or "", {
                {label = "Remove note", action = function()
                    if NoteContextMatches(person, key, owner) then A.JournalRemoveNote(Shown(), entry) end
                end},
                {label = "Keep note"},
            })
        elseif text ~= entry.d then
            A.JournalEditNote(Shown(), entry, text)
        end
    end
    GameTooltip:Hide()
    edit:Show()
    edit:SetText(entry.d or "")
    edit:SetFocus()
    edit:SetCursorPosition(#(entry.d or ""))
end
local function BindNoteActions(target, page)
    target:RegisterForClicks("LeftButtonUp", "RightButtonUp")
    target:SetScript("OnClick", function(self)
        local notes = ManualEntries(page, self.entries)
        if #notes == 1 then EditNote(self, page, notes[1]); return end
        if #notes == 0 then return end
        -- (several of your notes on one line: choose which to edit)
        local person, items = page.notePerson, {}
        for _, entry in ipairs(notes) do
            local note = entry
            items[#items + 1] = {label = note.d or "", action = function() EditNote(self, page, note) end}
        end
        BookPopup(self, page.owner or book, "Edit which note?", person.self and "My journal" or (person.display or person.name or "Journal"), items)
    end)
    target:SetScript("OnEnter", function(self)
        if #ManualEntries(page, self.entries) == 0 then return end
        GameTooltip:SetOwner(self, "ANCHOR_CURSOR"); GameTooltip:SetText("Click to edit your note.", 0.8, 0.8, 0.8); GameTooltip:Show()
    end)
    target:SetScript("OnLeave", function() GameTooltip:Hide() end)
end

-- A parchment page with its own scroll, and the drawing kit the styles use.
local function Page(parent, side, paged)
    local page = CreateFrame("Frame", nil, parent)
    page.paper = page:CreateTexture(nil, "BACKGROUND")
    page.paper:SetAllPoints()
    page.paper:SetAtlas("QuestBG-Parchment")
    local rim = page:CreateTexture(nil, "BACKGROUND", nil, -1)
    rim:SetPoint("TOPLEFT", -1, 1); rim:SetPoint("BOTTOMRIGHT", 1, -1)
    rim:SetColorTexture(0, 0, 0, 0.45)
    -- (the text's box on the page: left, top, right, bottom)
    page.box = {14, 12, 30, 12}
    -- (a "single" page, as the reading view's, keeps the quest parchment: its torn edges finish it)
    local spellbook = side ~= "single"
    if spellbook then
        SetBookPage(page.paper, side)
        rim:Hide()
        -- (the top bar covers the pages' top: the text starts below it)
        page.box = {30, 34, 40, 36}
    end
    page.pad = page.box[1] + page.box[3]
    local template
    if not paged then template = "UIPanelScrollFrameTemplate" end
    local scroll = CreateFrame("ScrollFrame", nil, page, template)
    scroll:SetPoint("TOPLEFT", page.box[1], -page.box[2]); scroll:SetPoint("BOTTOMRIGHT", -page.box[3], page.box[4])
    -- (no scroll bar when the page has nothing to scroll)
    scroll.scrollBarHideable = true
    if not paged and ScrollFrame_OnScrollRangeChanged then pcall(ScrollFrame_OnScrollRangeChanged, scroll) end
    if spellbook then SlimScrollBar(scroll) end
    local child = CreateFrame("Frame", nil, scroll)
    child:SetSize(400, 10)
    scroll:SetScrollChild(child)
    page.scroll, page.child = scroll, child
    child.cjPage = page
    if paged then
        local function Wheel(_, delta) if page.turn then page.turn(delta < 0 and 1 or -1) end end
        page.wheel = Wheel
        for _, target in ipairs({page, scroll, child}) do target:EnableMouseWheel(true); target:SetScript("OnMouseWheel", Wheel) end
    end
    page.blocks, page.used, page.lines = {}, 0, {}
    page.measure = child:CreateFontString(nil, "ARTWORK")
    page.measure:SetPoint("TOPLEFT"); page.measure:SetAlpha(0)
    page.measure:SetFontObject("QuestFont"); page.measure:SetWordWrap(true)
    page.empty = child:CreateFontString(nil, "ARTWORK", "QuestFont")
    page.empty:SetPoint("TOP", 0, -40); page.empty:SetWidth(320)
    page.empty:SetTextColor(unpack(INK_SOFT))

    local ctx = {}
    function ctx.Block(entries)
        page.used = page.used + 1
        local block = page.blocks[page.used]
        if not block then
            block = CreateFrame("Button", nil, child)
            block.texts, block.textures = {}, {}
            block.cjPage = page
            page.blocks[page.used] = block
            if A.BookLinkable then A.BookLinkable(block) end
            BindNoteActions(block, page)
            if page.wheel then block:EnableMouseWheel(true); block:SetScript("OnMouseWheel", page.wheel) end
        end
        for _, part in pairs(block.texts) do part:Hide() end
        for _, part in pairs(block.textures) do part:Hide() end
        block:ClearAllPoints()
        block.entries = type(entries) == "table" and #entries > 0 and entries or nil
        block:Show()
        return block
    end
    function ctx.Text(block, key, font, color, justify)
        local text = block.texts[key]
        if not text then text = block:CreateFontString(nil, "ARTWORK"); block.texts[key] = text end
        text:ClearAllPoints()
        text:SetFontObject(font)
        text.cjFont = font
        text:SetTextColor(color[1], color[2], color[3], color[4] or 1)
        text:SetJustifyH(justify or "LEFT"); text:SetJustifyV("TOP")
        text:SetSpacing(0); text:SetWordWrap(true)
        text:Show()
        return text
    end
    function ctx.Texture(block, key, layer)
        local texture = block.textures[key]
        if not texture then texture = block:CreateTexture(nil, layer or "ARTWORK"); block.textures[key] = texture end
        texture:ClearAllPoints()
        texture:SetDrawLayer(layer or "ARTWORK")
        texture:SetVertexColor(1, 1, 1, 1)
        texture:Show()
        return texture
    end
    function ctx.Place(block, x, y, width, height)
        block.layout = {x = x, y = y, width = width, height = height}
        block:SetPoint("TOPLEFT", child, "TOPLEFT", x, y)
        block:SetSize(width, math.max(1, height))
    end
    function ctx.Lines(font, spacing, width, text)
        local measure = page.measure
        measure:SetFontObject(font); measure:SetSpacing(spacing or 0); measure:SetWidth(width); measure:SetText(text)
        local count = measure.GetNumLines and measure:GetNumLines()
        if not (count and count > 0) then
            local height = measure:GetStringHeight()
            measure:SetText("M")
            local one = measure:GetStringHeight()
            count = math.floor((height + (spacing or 0)) / math.max(1, one + (spacing or 0)) + 0.5)
        end
        measure:SetText(""); measure:SetAlpha(0)
        return count
    end
    function ctx.Width(font, text)
        local measure = page.measure
        measure:SetFontObject(font); measure:SetSpacing(0); measure:SetWordWrap(false); measure:SetWidth(4000); measure:SetText(text)
        local width = measure.GetUnboundedStringWidth and measure:GetUnboundedStringWidth() or measure:GetStringWidth()
        measure:SetText(""); measure:SetWordWrap(true); measure:SetAlpha(0)
        return width or 0
    end
    page.ctx = ctx
    if A.BookLinkable then A.BookLinkable(child) end
    -- "Today, so far" (your own journal, today's chapter).
    page.today = page:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
    page.today:SetPoint("TOPLEFT", spellbook and page.box[1] or 12, spellbook and -12 or -6); page.today:SetTextColor(CHAPTER[1], CHAPTER[2], CHAPTER[3])
    if spellbook and page.today.SetShadowOffset then page.today:SetShadowOffset(0, 0) end
    page.today:SetText("Today, so far"); page.today:Hide()
    return page
end
-- A frame whose texts may carry name links (cjperson:<key>): a click opens their
-- journal at the same day.
function A.BookLinkable(frame)
    if not frame.SetHyperlinksEnabled then return end
    frame:SetHyperlinksEnabled(true)
    frame:SetScript("OnHyperlinkClick", function(self, link)
        local key = type(link) == "string" and link:match("^cjperson:(.+)$")
        if key and A.BookJump then A.BookJump(key) end
        local id = type(link) == "string" and link:match("^cjlore:(.+)$")
        if id and A.OpenLoreNote then
            local page = self.cjPage
            A.OpenLoreNote(id, page or self, {owner = page and page.owner, person = Shown(), page = page})
        end
    end)
    frame:SetScript("OnHyperlinkEnter", function(self, link)
        local key = type(link) == "string" and link:match("^cjperson:(.+)$")
        local person = key and A.People[key]
        if not person then
            local id = type(link) == "string" and link:match("^cjlore:(.+)$")
            local note = id and A.GetKnownLoreNote and A.GetKnownLoreNote(id)
            if note then
                GameTooltip:SetOwner(self, "ANCHOR_CURSOR")
                GameTooltip:SetText(note.title, 1, 0.82, 0)
                GameTooltip:AddLine("Click to read a lore note.", 0.9, 0.9, 0.9, true)
                GameTooltip:Show()
            end
            return
        end
        GameTooltip:SetOwner(self, "ANCHOR_CURSOR")
        GameTooltip:SetText(person.display or ShortName(person.name), 1, 0.82, 0)
        local circle = A.PersonCircle and A.PersonCircle(person) or "companion"
        GameTooltip:AddLine(circle == "companion" and "Companion" or circle == "rival" and "Rival" or "Someone you know", 0.7, 0.65, 0.85)
        GameTooltip:AddLine("Click to open their journal at this day.", 0.9, 0.9, 0.9, true)
        GameTooltip:Show()
    end)
    frame:SetScript("OnHyperlinkLeave", function() GameTooltip:Hide() end)
end
local function ClearPage(page)
    page.used = 0
    for _, block in ipairs(page.blocks) do block:Hide() end
    for _, line in ipairs(page.lines) do line:Hide(); if line.noteHit then line.noteHit:Hide(); line.noteHit.entries = nil end end
end
local function PageLine(page, index)
    local line = page.lines[index]
    if line then return line end
    line = page.child:CreateFontString(nil, "ARTWORK", "QuestFont")
    line:SetJustifyH("LEFT"); line:SetWordWrap(true)
    line.noteHit = CreateFrame("Button", nil, page.child)
    BindNoteActions(line.noteHit, page)
    line.noteHit:Hide()
    page.lines[index] = line
    return line
end

-- The chapters of a journal, as the chosen style, mode and voice show them.
-- Each is {day = ..., classic = ...}: a day of the book, or (the original
-- page, style A Everything Simple) a day of the plain record.
local function Chapters(person)
    local style, mode, voice = A.JournalStyle(), A.JournalMode(), A.JournalVoice()
    local styleMode = voice == "story" and (mode == "all" and "story" or "storyBrief") or mode
    local list = {}
    if style == "a" and mode == "all" and voice == "simple" and not person.self then
        for _, day in ipairs(A.JournalChapters(person)) do list[#list + 1] = {classic = day} end
        return list, style, styleMode, nil
    end
    local days = A.JournalBook(person)
    local stories = {}
    local function Story(day, teller)
        teller = teller or "you"
        if not stories[teller] then
            if person.self then
                stories[teller] = A.SelfTale and A.SelfTale.Tell(person, days, styleMode == "storyBrief") or {}
            else
                stories[teller] = A.JournalTale and A.JournalTale.Tell(person, days, teller, state.owner and A.CharacterPlayer(state.owner), styleMode == "storyBrief") or {}
            end
        end
        return stories[teller][day.key]
    end
    for _, day in ipairs(days) do
        if styleMode == "story" or styleMode == "storyBrief" then
            local story = Story(day, style == "d" and "we" or "you")
            if story and (story.text ~= "" or #story.quotes > 0) then list[#list + 1] = {day = day} end
        else
            list[#list + 1] = {day = day}
        end
    end
    return list, style, styleMode, Story
end

-- Unread chapters: for each journal, the last day you read ("2026-10-01", the
-- evening rule). A journal the book has never shown starts read.
local function DayKeyOf(t)
    local eve = A.JournalEvening and A.JournalEvening(t or 0) or t or 0
    return date and date("%Y-%m-%d", eve) or "?"
end
local function JournalPerson(key)
    local charKey = SelfOf(key)
    if charKey then return A.SelfPerson and A.SelfPerson(charKey) end
    return A.People[key]
end
local function ReadTable()
    A.db.bookRead = type(A.db.bookRead) == "table" and A.db.bookRead or {}
    return A.db.bookRead
end
-- What you read of a journal: {from = the day it was first shown (all before
-- counts as read), days = {[day] = true} read since}.
local function ReadRecord(key)
    local read = ReadTable()
    local record = read[key]
    if type(record) ~= "table" then return nil end
    record.days = record.days or {}
    return record
end
-- The days written that you have not read (newest first).
local function UnreadDays(key)
    local person = JournalPerson(key)
    if not person or type(person.journal) ~= "table" then return {} end
    local seen, latest = {}, nil
    for _, entry in ipairs(person.journal) do
        if entry.t then
            local day = DayKeyOf(entry.t)
            seen[day] = true
            if not latest or day > latest then latest = day end
        end
    end
    local record = ReadRecord(key)
    if not record then ReadTable()[key] = {from = latest or "0", days = {}}; return {} end
    local days = {}
    for day in pairs(seen) do if day > record.from and not record.days[day] then days[#days + 1] = day end end
    table.sort(days, function(x, y) return x > y end)
    -- (all read: start again from the newest, and forget the list)
    if #days == 0 and latest and latest > record.from then record.from, record.days = latest, {} end
    return days
end
local function MarkRead(key, day)
    if not key or not day then return end
    local record = ReadRecord(key)
    if record and day > record.from then record.days[day] = true end
end
-- The chapter shown counts as read when you turn away from it (or close the book).
local function CommitRead()
    local pending = state.pendingRead
    state.pendingRead = nil
    if pending then MarkRead(pending.key, pending.day); MarkRead(pending.key, pending.also) end
end
-- The chapter now shown: the one before counts as read only once it changes
-- (a redraw of the same page keeps its ribbon).
local function ShowingRead(key, day, also)
    if state.owner then return end
    if not day then day, also = also, nil end
    local pending = state.pendingRead
    if pending and (pending.key ~= key or pending.day ~= day) then CommitRead() end
    state.pendingRead = day and {key = key, day = day, also = also} or nil
end
local function ChapterDay(chapter)
    if not chapter then return nil end
    if chapter.day then return chapter.day.key end
    return chapter.classic and chapter.classic.key
end
local function FinishedDay(chapter)
    if chapter and chapter.part and chapter.part < chapter.parts then return nil end
    return ChapterDay(chapter)
end
local function NoteDateLabel(day, short)
    local stamp = A.JournalNoteTimestamp and A.JournalNoteTimestamp(day)
    if stamp and A.JournalEvening then stamp = A.JournalEvening(stamp) end
    return stamp and date and date(short and "%d %b" or "%A, %d %B %Y", stamp) or day or "Today"
end
local function UpdateWriteDate(person, chapter)
    if not book or not book.noteDate then return end
    local writable = state.view == "journal" and A.JournalCanWriteNotes and A.JournalCanWriteNotes(person)
    book.input:SetShown(writable); book.write:SetShown(writable); book.noteDate:SetShown(writable)
    if not writable then return end
    local context = tostring(state.key) .. ":" .. (state.owner or "")
    if book.writeContext ~= context then
        if book.writeContext then book.input:SetText(""); book.input:ClearFocus() end
        book.writeContext, state.noteDay, book.writeReadingDay = context, nil, nil
    end
    local day = ChapterDay(chapter) or DayKeyOf(time and time() or 0)
    if book.writeReadingDay ~= day then state.noteDay = nil; book.writeReadingDay = day end
    local target = state.noteDay or day
    book.writeDay = target
    local today = DayKeyOf(time and time() or 0)
    book.noteDate.label:SetText(target == today and "Today" or NoteDateLabel(target, true))
    if book.writeHint then book.writeHint:SetText("Write a note for " .. NoteDateLabel(target, true) .. "...") end
end
local function ChooseWriteDate()
    local person = Shown()
    if not A.JournalCanWriteNotes or not A.JournalCanWriteNotes(person) then return end
    local key, owner, days, seen = state.key, state.owner, {}, {}
    local function Add(day)
        if day and not seen[day] and A.JournalNoteTimestamp(day) then seen[day] = true; days[#days + 1] = day end
    end
    local today = DayKeyOf(time and time() or 0)
    Add(today)
    for _, day in ipairs(A.JournalBook and A.JournalBook(person) or {}) do Add(day.key) end
    table.sort(days, function(a, b) return a > b end)
    local items = {}
    for _, day in ipairs(days) do
        local chosen = day
        items[#items + 1] = {label = (day == book.writeDay and "\226\128\162  " or "") .. (day == today and "Today" or NoteDateLabel(day)), action = function()
            if NoteContextMatches(person, key, owner) then state.noteDay = chosen; A.RefreshBook(nil, true); book.input:SetFocus() end
        end}
    end
    BookPopup(book.noteDate, book, "Add a note on...", person.self and "My journal" or (person.display or person.name or "Journal"), items)
end
local function WriteNote()
    local person = Shown()
    if not book or book.writeContext ~= tostring(state.key) .. ":" .. (state.owner or "")
        or not NoteContextMatches(person, state.key, state.owner) then return nil end
    local target = book.writeDay or DayKeyOf(time and time() or 0)
    local entry = A.JournalWrite(person, book.input:GetText(), target)
    if entry then
        book.input:SetText(""); book.input:ClearFocus()
        state.jumpDay = target
        A.RefreshBook()
    end
    return entry
end
-- Every journal with something unread: {key, days, newest}, newest first.
local function AllUnread()
    local list = {}
    local me = A.Me and A.Me()
    if me and A.SelfPerson and A.SelfPerson(me) then
        local days = UnreadDays("self:" .. me)
        if #days > 0 then list[#list + 1] = {key = "self:" .. me, days = days, newest = days[1]} end
    end
    for key, person in A.EachPerson() do
        if not person.npc then
            local days = UnreadDays(key)
            if #days > 0 then list[#list + 1] = {key = key, days = days, newest = days[1]} end
        end
    end
    table.sort(list, function(x, y) return x.newest > y.newest end)
    return list
end
A.BookUnread = AllUnread
-- A ribbon (or a small mark) on a contents row or a page.
local RIBBON = {0.62, 0.08, 0.06}
local function Ribbon(frame, kind, x, y)
    if not frame.ribbon then
        frame.ribbon = frame:CreateTexture(nil, "OVERLAY")
        frame.ribbon:SetColorTexture(RIBBON[1], RIBBON[2], RIBBON[3], 1)
        frame.ribbonTip = frame:CreateTexture(nil, "OVERLAY")
        frame.ribbonTip:SetColorTexture(0.40, 0.04, 0.03, 1)
        frame.mark = frame:CreateTexture(nil, "OVERLAY")
        frame.mark:SetColorTexture(RIBBON[1], RIBBON[2], RIBBON[3], 1)
    end
    frame.ribbon:ClearAllPoints(); frame.ribbonTip:ClearAllPoints(); frame.mark:ClearAllPoints()
    frame.ribbon:SetPoint("TOPRIGHT", x or -10, y or 0)
    frame.ribbon:SetSize(10, kind == "page" and 34 or 22)
    frame.ribbonTip:SetPoint("TOP", frame.ribbon, "BOTTOM", 0, 0); frame.ribbonTip:SetSize(10, 3)
    frame.mark:SetPoint("TOPRIGHT", (x or -10) - 1, (y or 0) - 6); frame.mark:SetSize(7, 7)
end
local function ShowRibbon(frame, how)
    if not frame.ribbon then return end
    frame.ribbon:SetShown(how == "ribbon"); frame.ribbonTip:SetShown(how == "ribbon")
    frame.mark:SetShown(how == "mark")
end

-- One chapter on a page.
local function FullViewport(page)
    page.scroll:ClearAllPoints()
    page.scroll:SetPoint("TOPLEFT", page.box[1] + (page.inset or 0), -page.box[2] - (page.topInset or 0))
    page.scroll:SetPoint("BOTTOMRIGHT", -page.box[3], page.box[4])
end
local function DrawChapter(page, person, chapter, style, styleMode, Story)
    FullViewport(page)
    ClearPage(page)
    page.notePerson = person
    local ids = {}
    for _, scene in ipairs(chapter and chapter.day and chapter.day.scenes or {}) do
        for _, quest in ipairs(scene.quests or {}) do
            local old = ids[quest.title]
            local id = quest.qid or false
            if old == nil then ids[quest.title] = id
            elseif old ~= id then ids[quest.title] = false end
        end
    end
    A.bookLoreQuests = ids
    if A.db.bookLinks ~= false then
        local links = {}
        local function AddLink(key, other)
            if other and not other.npc and key ~= state.key then
                if other.name then links[ShortName(other.name):lower()] = key end
                if other.display then links[other.display:lower()] = key end
            end
        end
        local owner = state.owner or SelfOf(state.key)
        if owner and owner ~= A.Me() then
            local character = A.db.characters and A.db.characters[owner]
            for key in pairs(character and character.people or {}) do AddLink(key, A.PersonAs(key, owner)) end
        else
            for key, other in A.EachPerson() do AddLink(key, other) end
        end
        A.bookLinks = links
    end
    local width = page.child:GetWidth()
    if not width or width < 50 then width = 360 end
    local height
    if not chapter then
        page.empty:Show()
        height = 80
    elseif chapter.classic then
        page.empty:Hide()
        local day, y, index = chapter.classic, -4, 1
        local title = PageLine(page, index)
        title:SetText("~  " .. day.title .. "  ~"); title:SetJustifyH("CENTER"); title:SetTextColor(unpack(CHAPTER))
        title:ClearAllPoints(); title:SetPoint("TOPLEFT", 0, y); title:SetWidth(width); title:Show()
        y = y - title:GetStringHeight() - 8
        for _, entry in ipairs(day.lines) do
            index = index + 1
            local line = PageLine(page, index)
            line:SetText(entry.text); line:SetJustifyH("LEFT"); line:SetTextColor(unpack(entry.custom and INK_SOFT or INK))
            local indent = entry.custom and 22 or 8
            line:ClearAllPoints(); line:SetPoint("TOPLEFT", indent, y); line:SetWidth(width - indent - 4); line:Show()
            local hit = line.noteHit
            hit.entries = entry.custom and entry.entry and {entry.entry} or nil
            hit:ClearAllPoints(); hit:SetPoint("TOPLEFT", line, "TOPLEFT", 0, 0); hit:SetSize(line:GetWidth(), line:GetStringHeight())
            hit:SetShown(#ManualEntries(page, hit.entries) > 0)
            y = y - line:GetStringHeight() - 5
        end
        height = -y
    else
        page.empty:Hide()
        local ctx = page.ctx
        ctx.width, ctx.Story = width, Story
        height = A.JournalStyles[style](ctx, {chapter.day}, person, styleMode)
    end
    A.bookLinks = nil
    A.bookLoreQuests = nil
    for i = page.used + 1, #page.blocks do page.blocks[i]:Hide() end
    page.contentHeight = math.max(40, height or 40)
    page.child:SetHeight(page.contentHeight)
    -- (today's chapter of your own journal: still being written)
    local day = chapter and (chapter.day and chapter.day.key or chapter.classic and chapter.classic.key)
    page.today:SetShown(A.db.bookToday ~= false and person.self and day ~= nil and day == DayKeyOf(time and time() or 0))
    if chapter and chapter.offset then
        -- A fixed viewport shows a physical page of the laid-out chapter.
        -- It has no scrollbar or free scrolling; boundaries fall between lines.
        page.scroll:ClearAllPoints()
        page.scroll:SetPoint("TOPLEFT", page.box[1] + (page.inset or 0), -page.box[2] - (page.topInset or 0))
        page.scroll:SetPoint("TOPRIGHT", -page.box[3], -page.box[2] - (page.topInset or 0))
        page.scroll:SetHeight(chapter.extent)
        page.child:SetHeight(page.contentHeight + chapter.extent)
        page.scroll:SetVerticalScroll(chapter.offset)
    elseif page.scroll.SetVerticalScroll then page.scroll:SetVerticalScroll(0) end
    page.leaf = chapter
end

local function PageChapters(page, person, chapters, style, mode, Story, prepare)
    local leaves = {}
    for ci, chapter in ipairs(chapters) do
        if prepare then prepare(page, chapter, ci) end
        DrawChapter(page, person, chapter, style, mode, Story)
        local lines, boundaries = {}, {}
        local childTop = page.child:GetTop() or 0
        local function TextLines(fs)
            if not fs:IsShown() or not fs:GetText() or fs:GetText() == "" then return end
            local top = childTop - (fs:GetTop() or childTop)
            local height = fs:GetStringHeight() or 0
            local spacing = fs.GetSpacing and fs:GetSpacing() or fs.spacing or 0
            local n = fs.GetNumLines and fs:GetNumLines()
            if not n or n < 1 then n = page.ctx.Lines(fs.cjFont or "QuestFont", spacing, fs:GetWidth(), fs:GetText()) end
            n = math.max(1, n or 1)
            local step = (height + spacing) / n
            for i = 0, n - 1 do lines[#lines + 1] = {top + i * step, top + (i + 1) * step - spacing} end
        end
        for i = 1, page.used do
            local block = page.blocks[i]
            if block.layout then boundaries[#boundaries + 1] = math.max(0, -block.layout.y - 1) end
            for _, fs in pairs(block.texts) do TextLines(fs) end
            if not next(block.texts) and block.layout then
                lines[#lines + 1] = {-block.layout.y, -block.layout.y + block.layout.height}
            end
        end
        for _, fs in ipairs(page.lines) do TextLines(fs) end
        local fullCapacity = math.max(80, (page:GetHeight() or 500) - page.box[2] - page.box[4] - 3)
        local capacity = math.max(80, fullCapacity - (page.topInset or 0))
        local slices = A.JournalPageSlices(page.contentHeight, capacity, lines, boundaries, fullCapacity)
        for part, slice in ipairs(slices) do
            leaves[#leaves + 1] = {day = chapter.day, classic = chapter.classic, offset = slice.offset,
                extent = slice.extent, part = part, parts = #slices, chapterIndex = ci, inset = page.inset or 0}
        end
    end
    return leaves
end

-- The contents: your journal, then your people by circle (NPCs have no journal).
local function ContentsRow(index)
    local rows = book.rows
    local row = rows[index]
    if row then return row end
    row = CreateFrame("Button", nil, book.contentsChild)
    row:SetHeight(30)
    row.select = row:CreateTexture(nil, "BACKGROUND")
    row.select:SetAllPoints(); row.select:SetColorTexture(1, 0.82, 0, 0.16)
    -- (the class as a thin bar, the name in ink; the quest log's bars)
    row.classBar = row:CreateTexture(nil, "ARTWORK")
    row.classBar:SetPoint("TOPLEFT", 0, -3); row.classBar:SetPoint("BOTTOMLEFT", 0, 3); row.classBar:SetWidth(3); row.classBar:Hide()
    row.select:SetTexture("Interface\\QuestFrame\\UI-QuestLogTitleHighlight")
    row.select:SetBlendMode("ADD"); row.select:SetVertexColor(0.85, 0.6, 0.25, 0.6)
    -- (the gamepad's place in the list: a gold edge on the left)
    row.focus = row:CreateTexture(nil, "OVERLAY")
    row.focus:SetPoint("TOPLEFT", 0, 0); row.focus:SetPoint("BOTTOMLEFT", 0, 0); row.focus:SetWidth(3)
    row.focus:SetColorTexture(1, 0.82, 0, 1); row.focus:Hide()
    local hover = row:CreateTexture(nil, "HIGHLIGHT")
    hover:SetAllPoints(); hover:SetColorTexture(1, 0.7, 0.2, 0.10)
    hover:SetTexture("Interface\\QuestFrame\\UI-QuestTitleHighlight"); hover:SetBlendMode("ADD"); hover:SetVertexColor(0.85, 0.6, 0.25, 0.4)
    row.icon = row:CreateTexture(nil, "ARTWORK")
    row.icon:SetSize(20, 20); row.icon:SetPoint("LEFT", 6, 0)
    row.name = row:CreateFontString(nil, "ARTWORK", "GameFontNormal")
    row.name:SetPoint("TOPLEFT", 32, -2); row.name:SetJustifyH("LEFT"); row.name:SetWordWrap(false)
    row.sub = row:CreateFontString(nil, "ARTWORK", "GameFontHighlightSmall")
    row.sub:SetPoint("TOPLEFT", row.name, "BOTTOMLEFT", 0, -1); row.sub:SetJustifyH("LEFT"); row.sub:SetWordWrap(false)
    row.sub:SetTextColor(INK_SOFT[1], INK_SOFT[2], INK_SOFT[3])
    row:SetScript("OnClick", function(self)
        if self.action then self.action()
        elseif self.section then
            state.collapsed[self.section] = not state.collapsed[self.section]
            A.RefreshBook()
        elseif self.key then
            A.OpenBook(self.key)
        end
    end)
    rows[index] = row
    return row
end
-- Draw a list on the left page: {kind = "section", label, count, open, circle, fixed}
-- or {kind = "row", label, sub, class, icon, key, selected, action}.
local function FillList(items)
    local width = book.contentsChild:GetWidth()
    if not width or width < 50 then width = 300 end
    local y = -4
    for index, data in ipairs(items) do
        local row = ContentsRow(index)
        row:ClearAllPoints(); row:SetPoint("TOPLEFT", 0, y); row:SetWidth(width)
        row.key, row.section, row.action = nil, nil, data.action
        if row.ribbon then ShowRibbon(row, nil) end
        if data.kind == "gap" then
            row:Hide()
            y = y - (data.size or 6)
        elseif data.kind == "section" then
            row:SetHeight(24)
            row.icon:Hide(); row.sub:SetText("")
            row.name:ClearAllPoints(); row.name:SetPoint("LEFT", 8, 0); row.name:SetWidth(width - 16)
            row.name:SetFontObject(Font("QuestFont_Shadow_Small", "GameFontNormal"))
            row.name:SetTextColor(CHAPTER[1], CHAPTER[2], CHAPTER[3])
            if row.name.SetShadowOffset then row.name:SetShadowOffset(0, 0) end
            row.classBar:Hide()
            local arrow = data.open and "-  " or "+  "
            row.name:SetText(data.fixed and data.label or (arrow .. data.label .. "  (" .. data.count .. ")"))
            row.section = not data.fixed and data.circle or nil
            row.select:Hide()
            row:Show()
            y = y - 26
        else
            row:SetHeight(32)
            row.name:ClearAllPoints(); row.name:SetPoint("TOPLEFT", 32, -2); row.name:SetWidth(width - 40)
            row.name:SetText(data.label)
            row.name:SetFontObject(Font("GameFontBlack", "GameFontNormal")); row.name:SetTextColor(INK[1], INK[2], INK[3])
            row.sub:SetFontObject(Font("GameFontBlackSmall", "GameFontHighlightSmall")); row.sub:SetTextColor(INK_SOFT[1], INK_SOFT[2], INK_SOFT[3])
            if data.class then row.classBar:SetColorTexture(ClassColor(data.class)); row.classBar:Show() else row.classBar:Hide() end
            row.sub:SetWidth(width - 40); row.sub:SetText(data.sub or "")
            if data.class and A.SetPersonClassIcon then A.SetPersonClassIcon(row.icon, data.class)
            elseif data.icon then row.icon:SetTexture(data.icon); row.icon:Show()
            else row.icon:Hide() end
            row.key = data.key
            row.select:SetShown(data.selected and true or false)
            Ribbon(row, "row", -6, -4)
            ShowRibbon(row, data.unread)
            row:Show()
            y = y - 34
        end
    end
    for index = #items + 1, #book.rows do book.rows[index]:Hide() end
    book.contentsChild:SetHeight(math.max(40, -y))
end
-- The journal view's contents: your journal, then your people by circle.
local function ContentsPortrait(info)
    -- The contents placement follows the same selected-leaf schedule as the
    -- chapter placements, including the saved look for that chapter's level.
    local front = info ~= nil
    local contents = book.contents
    if front then contents.portrait = contents.portrait or Portrait(contents) end
    contents.scroll:ClearAllPoints()
    local box = contents.box
    contents.scroll:SetPoint("TOPLEFT", box[1], front and -(box[2] + 178) or -box[2]); contents.scroll:SetPoint("BOTTOMRIGHT", -box[3], box[4] + 32)
    if front then
        contents.portrait:ClearAllPoints(); contents.portrait:SetPoint("TOP", 0, -(box[2] + 2)); contents.portrait:SetSize(130, 150)
        contents.portrait:Style(A.BookVariant("portraitFrame"))
        contents.portrait:Fill(info, 0.6)
    elseif contents.portrait then
        contents.portrait:Hide()
    end
end
local function FillContents(info)
    ContentsPortrait(info)
    local items = {}
    -- (unread, by variant: A, a ribbon on each; B, the newest a ribbon and the rest a mark; C, a mark)
    local variant, unread, newest = A.BookVariant("ribbon"), {}, nil
    for i, item in ipairs(AllUnread()) do unread[item.key] = true; if i == 1 then newest = item.key end end
    local function How(key)
        if not unread[key] then return nil end
        if variant == "a" then return "ribbon" end
        if variant == "b" then return key == newest and "ribbon" or "mark" end
        return "mark"
    end
    local me = A.Me and A.Me()
    local mine = me and A.SelfPerson and A.SelfPerson(me)
    if mine then
        items[#items + 1] = {kind = "section", label = "My journal", fixed = true}
        items[#items + 1] = {kind = "row", key = "self:" .. me, label = mine.name or "My journal", class = mine.class,
            sub = A.PersonSummary(mine), selected = state.key == "self:" .. me, unread = How("self:" .. me)}
        items[#items + 1] = {kind = "gap"}
    end
    local byCircle = {}
    for key, person in A.EachPerson() do
        if not person.npc then
            local circle = A.PersonCircle(person)
            byCircle[circle] = byCircle[circle] or {}
            table.insert(byCircle[circle], {key = key, person = person})
        end
    end
    for _, circle in ipairs(CIRCLE_ORDER) do
        local list = byCircle[circle[1]] or {}
        table.sort(list, function(x, y2)
            return (x.person.display or ShortName(x.person.name)):lower() < (y2.person.display or ShortName(y2.person.name)):lower()
        end)
        if #list > 0 then
            local open = not state.collapsed[circle[1]]
            items[#items + 1] = {kind = "section", label = circle[2], count = #list, open = open, circle = circle[1]}
            if open then
                for _, item in ipairs(list) do
                    local person = item.person
                    items[#items + 1] = {kind = "row", key = item.key, label = person.display or ShortName(person.name or item.key),
                        class = person.class, sub = A.PersonSummary(person), selected = item.key == state.key, unread = How(item.key)}
                end
            end
            items[#items + 1] = {kind = "gap", size = 4}
        end
    end
    FillList(items)
end

local CARD_W = 320 -- (the card and notes width; Build uses it)
local function ApplySize()
    local db = A.db
    local size = SIZES[db.bookSize]
    if size then book:SetSize(size[1], size[2])
    elseif db.bookSize == "custom" and db.bookWidth and db.bookHeight then book:SetSize(db.bookWidth, db.bookHeight)
    else book:SetSize(SIZES.a[1], SIZES.a[2]) end
end

-- Narrative margins grow with the available paper. A keeps a compact text
-- area; B and C add more room on all four edges, including the binding.
-- Lists and settings use their own unchanged page boxes.
local function SetNarrativeMargins(page, width, height, side)
    local smallWidth = (SIZES.a[1] - 20) / 2
    local smallHeight = SIZES.a[2] - 88 - 48
    local across = math.min(3.5, math.max(0, width - smallWidth) / 70)
    local down = math.min(3.5, math.max(0, height - smallHeight) / 80)
    local outer = math.floor((42 + across * 18) * 0.90 + 0.5)
    local inner = math.floor((44 + across * 20) * 0.90 + 0.5)
    local top = math.floor((38 + down * 20) * 0.90 + 0.5)
    local bottom = math.floor((40 + down * 20) * 0.70 + 0.5)
    local box = {side == "left" and outer or inner, top, side == "left" and inner or outer, bottom}
    local changed = page.layoutWidth ~= width or page.layoutHeight ~= height
    for i = 1, 4 do if page.box[i] ~= box[i] then changed = true end end
    page.layoutWidth, page.layoutHeight = width, height
    page.box, page.pad = box, box[1] + box[3]
    page.empty:SetWidth(math.max(120, width - page.pad))
    page.today:ClearAllPoints(); page.today:SetPoint("TOPLEFT", box[1], -math.max(8, top - 20))
    return changed
end

-- Lay out the pages: contents + one chapter, or a two-page spread.
local function LayoutPages()
    local spread = A.db.bookSpread == "two" and state.view == "journal"
    local w = book:GetWidth()
    -- (the spellbook's pages meet at the fold, inside the metal)
    local left, right, gap = 13, 7, 0
    local half = math.floor((w - left - right - gap) / 2)
    book.left:ClearAllPoints(); book.right:ClearAllPoints()
    local shownPerson = Shown()
    local timeline = A.db.bookTimeline ~= false and state.view == "journal" and shownPerson ~= nil and not shownPerson.self
    local bottom = timeline and 66 or 48
    local managing = state.view == "people" or state.view == "npcs"
    if managing then bottom = 18 end
    -- (the journal: no header over the pages, only a narrow band for the pin ribbon)
    local top = managing and -40 or (state.view == "journal" and -76 or -88)
    book.left:SetPoint("TOPLEFT", left, top); book.left:SetPoint("BOTTOMLEFT", left, bottom); book.left:SetWidth(half)
    book.right:SetPoint("TOPRIGHT", -right, top); book.right:SetPoint("BOTTOMRIGHT", -right, bottom); book.right:SetWidth(half)
    local pageHeight = math.max(1, (book:GetHeight() or SIZES.a[2]) - 88 - bottom)
    local leftChanged = SetNarrativeMargins(book.leftPage, half, pageHeight, "left")
    local rightChanged = SetNarrativeMargins(book.rightPage, half, pageHeight, "right")
    if leftChanged or rightChanged then state.pageCache = nil end
    book.contents:SetShown(not spread)
    book.leftPage:SetShown(spread)
    book.contentsChild:SetWidth(half - book.contents.pad)
    book.leftPage.child:SetWidth(half - book.leftPage.pad)
    book.rightPage.child:SetWidth(half - book.rightPage.pad)
    book.panel.child:SetWidth(half - book.panel.pad)
    if book.corner then
        local scale = (half * 2) / 1614
        book.corner:SetSize(math.floor(150 * scale + 0.5), math.floor(155 * scale + 0.5))
        book.corner:ClearAllPoints(); book.corner:SetPoint("BOTTOMRIGHT", -8, 21 - bottom)
    end
    if book.topBar then book.topBar:SetHeight(22) end
    -- The paper belongs to the book, not the content viewport. Header and
    -- footer controls stay on the same uninterrupted leaves as the text.
    if book.paperLeft then
        book.paperLeft:ClearAllPoints(); book.paperLeft:SetPoint("TOPLEFT", left, -40)
        book.paperLeft:SetPoint("BOTTOMLEFT", left, 18); book.paperLeft:SetWidth(half)
        book.paperRight:ClearAllPoints(); book.paperRight:SetPoint("TOPRIGHT", -right, -40)
        book.paperRight:SetPoint("BOTTOMRIGHT", -right, 18); book.paperRight:SetWidth(half)
        local rival = state.view == "journal" and shownPerson and not shownPerson.self
            and A.PersonCircle and A.PersonCircle(shownPerson) == "rival"
        local atlas = rival and (shownPerson.faction == "Horde" and "QuestBG-Horde" or shownPerson.faction == "Alliance" and "QuestBG-Alliance" or "QuestBG-Parchment")
        if atlas then
            for _, paper in ipairs({book.paperLeft, book.paperRight}) do paper:SetTexCoord(0, 1, 0, 1); paper:SetAtlas(atlas) end
        else SetBookPage(book.paperLeft, "left"); SetBookPage(book.paperRight, "right") end
        for _, page in ipairs({book.contents, book.leftPage, book.rightPage, book.panel, book.cardHost}) do
            if page and page.paper then page.paper:Hide() end
        end
        book.classIcon:ClearAllPoints(); book.classIcon:SetPoint("TOPLEFT", left + 22, -54)
        book.summary:SetTextColor(unpack(INK_SOFT))
        book.chapterLabel:SetTextColor(unpack(INK_SOFT))
        book.footer:ClearAllPoints(); book.footer:SetPoint("BOTTOMLEFT", left + 22, 31)
        book.footer:SetPoint("BOTTOMRIGHT", -right - 22, 31)
        book.input:ClearAllPoints(); book.input:SetPoint("BOTTOMLEFT", left + 28, 33)
        book.timeline:ClearAllPoints(); book.timeline:SetPoint("BOTTOMLEFT", book, "BOTTOMLEFT", left + half + 30, 70)
        book.timeline:SetPoint("BOTTOMRIGHT", book, "BOTTOMRIGHT", -right - 30, 70)
        book.tabs.journal:ClearAllPoints(); book.tabs.journal:SetPoint("TOPLEFT", book.right, "TOPLEFT", 34, 28)
        -- A quiet rule separates actions from prose without creating another bar.
        for _, item in ipairs({{book.leftRule, left + 24}, {book.rightRule, left + half + 24}}) do
            local rule = item[1]
            rule:ClearAllPoints(); rule:SetPoint("BOTTOMLEFT", item[2], 62)
            rule:SetWidth(half - 48); rule:SetShown(state.view == "journal")
        end
    end
    -- Keep the writing controls clear of navigation, including the Reading view
    -- button used by the older bookmark variants, at the minimum window size.
    local readingButton = A.BookVariant("marks") ~= "c"
    if book.input then book.input:SetWidth(math.max(140, math.min(240, half - 230))) end
    -- (the chapter arrows: under the right page)
    if book.chapterLabel then
        book.chapterLabel:SetWidth(readingButton and 100 or 110)
        book.chapterLabel:ClearAllPoints()
        book.chapterLabel:SetPoint("CENTER", book.right, "BOTTOM", readingButton and -38 or 0, 44 - bottom)
    end
end

-- In a companion's journal, the pin is a cloth bookmark hanging from the top of
-- the left page (full length when pinned, a faded stub when not), and a small inked cog
-- beside it (a quill on paper) opens their card on the Companions page.
local function DrawPinRibbon(show)
    local mark, cog = book and book.pinRibbon, book and book.cardCog
    if cog then cog:SetShown(show and true or false) end
    if not mark then return end
    local info = show and C_Texture and C_Texture.GetAtlasInfo and C_Texture.GetAtlasInfo("activities-ribbon")
    local file = info and (info.file or info.filename)
    if not file then mark:Hide(); return end
    local pinned = IsPinned(state.key)
    local l, r, t, b = info.leftTexCoord, info.rightTexCoord, info.topTexCoord, info.bottomTexCoord
    local function V(f) return t + (b - t) * f end
    local width = mark:GetWidth()
    local tail = math.max(6, math.floor(0.45 * info.height * width / info.width + 0.5))
    mark:SetHeight((pinned and 58 or 26) + (mark.hover and 6 or 0))
    mark:ClearAllPoints(); mark:SetPoint("TOP", book.left, "TOPRIGHT", -46, 36)
    mark.body:SetTexture(file); mark.body:SetTexCoord(l, r, V(0.05), V(0.55))
    mark.body:ClearAllPoints(); mark.body:SetPoint("TOPLEFT"); mark.body:SetPoint("TOPRIGHT"); mark.body:SetPoint("BOTTOM", 0, tail)
    mark.tail:SetTexture(file); mark.tail:SetTexCoord(l, r, V(0.55), V(1))
    mark.tail:ClearAllPoints(); mark.tail:SetPoint("BOTTOMLEFT"); mark.tail:SetPoint("BOTTOMRIGHT"); mark.tail:SetHeight(tail)
    local shade = pinned and 1 or (mark.hover and 0.85 or 0.7)
    for _, texture in ipairs({mark.body, mark.tail}) do
        if texture.SetDesaturated then texture:SetDesaturated(not pinned) end
        texture:SetVertexColor(shade, shade, shade, pinned and 1 or 0.75)
    end
    mark:Show()
end
local function Build()
    book = CreateFrame("Frame", "CompanionJournalBookB", UIParent)
    book:SetPoint("CENTER", 0, 20)
    book:SetFrameStrata("DIALOG")
    book:EnableMouse(true); book:SetMovable(true); book:SetToplevel(true)
    book:RegisterForDrag("LeftButton")
    book:SetScript("OnDragStart", book.StartMoving)
    book:SetScript("OnDragStop", book.StopMovingOrSizing)
    book:SetClampedToScreen(true)
    local heading = book:CreateFontString(nil, "OVERLAY", "GameFontNormal")
    heading:SetText("Companion Journal")
    book.heading = heading
    if A.OptionsSkin then A.OptionsSkin.Frame(book, heading) end
    if UISpecialFrames then table.insert(UISpecialFrames, "CompanionJournalBookB") end
    ApplySize()
    book.paperLeft = book:CreateTexture(nil, "BACKGROUND", nil, 1)
    book.paperRight = book:CreateTexture(nil, "BACKGROUND", nil, 1)
    for _, key in ipairs({"leftRule", "rightRule"}) do
        book[key] = book:CreateTexture(nil, "ARTWORK")
        book[key]:SetHeight(1); book[key]:SetColorTexture(0.36, 0.22, 0.08, 0.22)
    end

    -- Resizing: drag the corner (the size becomes "custom").
    book:SetResizable(true)
    if book.SetResizeBounds then book:SetResizeBounds(760, 520, 1500, 960)
    elseif book.SetMinResize then book:SetMinResize(760, 520); book:SetMaxResize(1500, 960) end
    local grip = CreateFrame("Button", nil, book)
    grip:SetSize(16, 16); grip:SetPoint("BOTTOMRIGHT", -6, 6)
    grip:SetNormalTexture("Interface\\ChatFrame\\UI-ChatIM-SizeGrabber-Up")
    grip:SetHighlightTexture("Interface\\ChatFrame\\UI-ChatIM-SizeGrabber-Highlight")
    grip:SetPushedTexture("Interface\\ChatFrame\\UI-ChatIM-SizeGrabber-Down")
    grip:SetScript("OnMouseDown", function() book:StartSizing("BOTTOMRIGHT") end)
    grip:SetScript("OnMouseUp", function()
        book:StopMovingOrSizing()
        A.db.bookSize, A.db.bookWidth, A.db.bookHeight = "custom", math.floor(book:GetWidth()), math.floor(book:GetHeight())
        A.RefreshBook()
    end)

    -- The header: who is on the page.
    book.classIcon = book:CreateTexture(nil, "ARTWORK")
    book.classIcon:SetSize(30, 30); book.classIcon:SetPoint("TOPLEFT", 24, -46)
    book.name = book:CreateFontString(nil, "ARTWORK", "GameFontNormalLarge")
    book.name:SetPoint("TOPLEFT", 62, -44); book.name:SetHeight(22)
    book.name:SetJustifyH("LEFT"); book.name:SetJustifyV("MIDDLE"); book.name:SetWordWrap(false)
    book.summary = book:CreateFontString(nil, "ARTWORK", "GameFontHighlightSmall")
    book.summary:SetPoint("TOPLEFT", book.name, "BOTTOMLEFT", 0, -1); book.summary:SetHeight(16)
    book.summary:SetJustifyH("LEFT"); book.summary:SetWordWrap(false)
    book.summary:SetTextColor(0.75, 0.75, 0.75)
    book.summary:SetHeight(28); book.summary:SetWordWrap(true)
    for _, text in ipairs({book.name, book.summary}) do if text.SetShadowOffset then text:SetShadowOffset(0, 0) end end
    -- (the journal's title: name, who they are, and the quest log's flourish under them)
    book.headRule = book:CreateTexture(nil, "ARTWORK")
    book.headRule:SetTexture("Interface\\QuestFrame\\UI-HorizontalBreak")
    book.headRule:SetSize(150, 18); book.headRule:SetVertexColor(0.62, 0.42, 0.22, 0.9); book.headRule:Hide()
    book.sectionHeading = book:CreateFontString(nil, "ARTWORK", "GameFontNormalLarge")
    book.sectionHeading:SetTextColor(unpack(INK)); book.sectionHeading:SetJustifyH("LEFT")
    if book.sectionHeading.SetShadowOffset then book.sectionHeading:SetShadowOffset(0, 0) end
    book.sizeButtons = {} -- (sizes: Settings > Reading)

    -- The two pages: left (the contents, or a chapter in a spread) and right.
    book.left = CreateFrame("Frame", nil, book)
    book.right = CreateFrame("Frame", nil, book)
    -- The contents: a parchment list.
    local contents = Page(book.left, "left")
    contents:SetAllPoints()
    book.contents, book.contentsChild = contents, contents.child
    contents.empty:Hide()
    book.rows = {}
    book.leftPage = Page(book.left, "left", true)
    book.leftPage:SetAllPoints()
    book.rightPage = Page(book.right, "right", true)
    book.leftPage.owner, book.rightPage.owner = book, book
    book.leftPage.turn = function(delta) A.BookTurn(delta) end
    book.rightPage.turn = book.leftPage.turn
    book.rightPage:SetAllPoints()
    -- Settings and NPCs: a page of their own on the right.
    book.panel = Page(book.right, "right")
    book.panel:SetAllPoints()
    book.panel.empty:Hide()
    book.panel:Hide()
    book.sections = {}
    -- (the spellbook's top bar across both pages: it finishes their top edge)
    local deco = CreateFrame("Frame", nil, book)
    deco:SetAllPoints(); deco:SetFrameLevel(book.right:GetFrameLevel() + 40)
    -- Parchment meets the heading directly; no wooden strip across the pages.
    -- (the bookmark that pins a companion, and the cog to their card)
    local mark = CreateFrame("Button", nil, book)
    mark:SetWidth(22); mark:SetFrameLevel(book.right:GetFrameLevel() + 35)
    mark.body = mark:CreateTexture(nil, "ARTWORK"); mark.tail = mark:CreateTexture(nil, "ARTWORK")
    mark:SetScript("OnClick", function()
        if state.key and A.People[state.key] then TogglePin(state.key); A.RefreshBook() end
    end)
    mark:SetScript("OnEnter", function(self)
        self.hover = true; DrawPinRibbon(true)
        local person = state.key and A.People[state.key]
        local who = person and (person.display or ShortName(person.name or state.key)) or ""
        GameTooltip:SetOwner(self, "ANCHOR_RIGHT")
        GameTooltip:SetText(IsPinned(state.key) and "Unpin" or "Pin", 1, 0.82, 0)
        GameTooltip:AddLine(IsPinned(state.key) and ("Remove " .. who .. "'s ribbon from the edge of the book.")
            or ("Keep " .. who .. "'s journal on a ribbon at the edge of the book."), 0.9, 0.9, 0.9, true)
        GameTooltip:Show()
    end)
    mark:SetScript("OnLeave", function(self) self.hover = false; DrawPinRibbon(true); GameTooltip:Hide() end)
    mark:Hide()
    book.pinRibbon = mark
    local cog = CreateFrame("Button", nil, book)
    -- (left of the ribbon, in the narrow band above the page)
    cog:SetSize(20, 20); cog:SetFrameLevel(book.right:GetFrameLevel() + 35)
    cog:SetPoint("TOPRIGHT", book.left, "TOPRIGHT", -67, 29)
    cog.art = cog:CreateTexture(nil, "ARTWORK"); cog.art:SetAllPoints()
    -- (a quill on paper, the game's own note mark: their card is written, not configured)
    cog.art:SetTexture("Interface\\Buttons\\UI-GuildButton-PublicNote-Up")
    cog.art:SetVertexColor(0.85, 0.85, 0.85, 1)
    cog:SetScript("OnClick", function() if state.key and A.People[state.key] then A.OpenBookPeople(state.key) end end)
    cog:SetScript("OnEnter", function(self)
        self.art:SetVertexColor(1, 1, 1, 1)
        GameTooltip:SetOwner(self, "ANCHOR_RIGHT")
        GameTooltip:SetText("Their card", 1, 0.82, 0)
        GameTooltip:AddLine("Name, icon, note, and what they are to you.", 0.9, 0.9, 0.9, true)
        GameTooltip:Show()
    end)
    cog:SetScript("OnLeave", function(self) self.art:SetVertexColor(0.85, 0.85, 0.85, 1); GameTooltip:Hide() end)
    cog:Hide()
    book.cardCog = cog
    -- (the page corner: it lifts under the pointer and turns to the later chapter)
    local corner = CreateFrame("Button", nil, book.rightPage)
    corner:SetFrameLevel(book.rightPage:GetFrameLevel() + 30)
    -- (the curl is drawn on the paper, under the text, as Blizzard draws it)
    corner.art = book.rightPage:CreateTexture(nil, "BACKGROUND", nil, 2)
    corner.art:SetAllPoints(corner)
    if SetCornerFrame(corner.art, 1) then
        corner:SetPoint("BOTTOMRIGHT", -8, 3)
        corner:SetScript("OnEnter", function(self)
            SetCornerFrame(self.art, 5)
            GameTooltip:SetOwner(self, "ANCHOR_TOP"); GameTooltip:SetText("Next page", 1, 0.82, 0); GameTooltip:Show()
        end)
        corner:SetScript("OnLeave", function(self) SetCornerFrame(self.art, 1); GameTooltip:Hide() end)
        corner:SetScript("OnClick", function() if book.next:IsEnabled() then A.BookTurn(1) end end)
        book.corner = corner
    else
        corner:Hide(); corner.art:Hide()
    end

    -- Pin this companion (a bookmark on the edge).
    book.pin = Toggle(book, "Pin", 48, "Bookmark", "Pin this companion to the edge of the book (up to six).", function()
        if state.key and A.People[state.key] then TogglePin(state.key); A.RefreshBook() end
    end)

    -- The timeline strip, under the right page.
    book.timeline = CreateFrame("Frame", nil, book)
    book.timeline:SetPoint("BOTTOMLEFT", book.right, "BOTTOMLEFT", 0, -16)
    book.timeline:SetPoint("BOTTOMRIGHT", book.right, "BOTTOMRIGHT", 0, -16)
    book.timeline:SetHeight(14)
    local line = book.timeline:CreateTexture(nil, "BACKGROUND")
    line:SetPoint("LEFT", 8, 0); line:SetPoint("RIGHT", -8, 0); line:SetHeight(1)
    line:SetColorTexture(0.6, 0.5, 0.35, 0.7)
    book.timeline:Hide()

    -- The card, three ways (Settings > Testing).
    book.quill = Toggle(book, "Edit", 44, "Their card", "Name, icon, note, and what they are to you.", function()
        state.cardOpen = not state.cardOpen; A.RefreshBook()
    end)
    book.flip = Toggle(book, "Card", 54, "Their card", "Turn the page to their card, and back.", function()
        state.cardOpen = not state.cardOpen; A.RefreshBook()
    end)
    book.tabs = {}
    for i, item in ipairs({{"journal", "Journal", 64}, {"about", "About", 56}, {"notes", "Notes", 56}}) do
        local tab = Toggle(book, item[2], item[3], nil, nil, function() state.tab = item[1]; A.RefreshBook() end)
        if i == 1 then tab:SetPoint("BOTTOMLEFT", book.right, "TOPLEFT", 0, 4)
        else tab:SetPoint("LEFT", book.tabs.last, "RIGHT", 4, 0) end
        book.tabs[item[1]] = tab
        book.tabs.last = tab
    end
    book.cardHost = Page(book, "right")
    book.cardHost.empty:Hide()
    book.cardHost:SetFrameLevel(book.right:GetFrameLevel() + 5)
    book.card = BuildCard()
    book.card:SetParent(book.cardHost.child); book.card:SetPoint("TOPLEFT", 6, -2)
    book.notes = BuildNotes()
    book.notes:SetParent(book.cardHost.child); book.notes:SetPoint("TOPLEFT", 6, -2); book.notes:SetSize(CARD_W, 300)
    book.cardHost.child:SetHeight(440)
    book.wizard = BuildWizard()
    book.addBar = BuildAddBar()
    book.contents.scroll:SetPoint("BOTTOMRIGHT", -book.contents.box[3], book.contents.box[4] + 32)

    -- Bookmarks down the right edge: your journal, pinned companions; NPCs and Settings at the bottom.
    book.marks = {}

    -- The footer of the pages: the chapter arrows, under the page they turn.
    -- (Show, Told and Pages are in Settings > Reading; Reading view is a tools' ribbon)
    local footer = CreateFrame("Frame", nil, book)
    footer:SetPoint("BOTTOMLEFT", 22, 16); footer:SetPoint("BOTTOMRIGHT", -22, 16); footer:SetHeight(26)
    book.footer = footer
    book.chapterLabel = footer:CreateFontString(nil, "ARTWORK", "GameFontHighlightSmall")
    book.chapterLabel:SetPoint("CENTER"); book.chapterLabel:SetWidth(110)
    book.chapterLabel:SetJustifyH("CENTER")
    book.prev = Toggle(footer, "<", 26, "Previous page", nil, function() A.BookTurn(-1) end)
    book.prev:SetPoint("RIGHT", book.chapterLabel, "LEFT", -4, 0)
    book.next = Toggle(footer, ">", 26, "Next page", nil, function() A.BookTurn(1) end)
    book.next:SetPoint("LEFT", book.chapterLabel, "RIGHT", 4, 0)
    PageArrow(book.prev, "Prev"); PageArrow(book.next, "Next")
    -- (bookmarks A and B have no tools' ribbons, so they keep this button)
    book.readView = Toggle(footer, "Reading view", 84, "Reading view", "Compare Original, Your tale, Our story and By the fire.", function() A.BookReader(true) end)
    book.readView:SetPoint("RIGHT", 0, 0)

    -- Writing a line, Retell, and Close, at the bottom.
    local input = CreateFrame("EditBox", nil, book, "InputBoxTemplate")
    input:SetPoint("BOTTOMLEFT", 30, 18); input:SetSize(320, 22)
    input:SetAutoFocus(false); input:SetMaxLetters(300)
    local hint = input:CreateFontString(nil, "ARTWORK", "GameFontDisableSmall")
    hint:SetPoint("LEFT", 4, 0); hint:SetText("Write a line in the journal...")
    input:SetScript("OnTextChanged", function(self) hint:SetShown((self:GetText() or "") == "") end)
    input:SetScript("OnEscapePressed", function(self) self:ClearFocus() end)
    input:SetScript("OnEnterPressed", WriteNote)
    local write = CreateFrame("Button", nil, book)
    write.label = write:CreateFontString(nil, "ARTWORK", "GameFontHighlightSmall"); write.label:SetPoint("CENTER"); write:SetFontString(write.label); A.StyleBookControl(write, false)
    local noteDate = Toggle(book, "Today", 58, nil, nil, ChooseWriteDate)
    noteDate:SetPoint("LEFT", input, "RIGHT", 8, 0); noteDate:SetHeight(22)
    noteDate:SetScript("OnEnter", function(self)
        GameTooltip:SetOwner(self, "ANCHOR_TOP"); GameTooltip:SetText("Note date", 1, 0.82, 0)
        GameTooltip:AddLine("Add to " .. NoteDateLabel(book.writeDay) .. ". Choose today or an earlier recorded day.", 0.9, 0.9, 0.9, true); GameTooltip:Show()
    end)
    write:SetPoint("LEFT", noteDate, "RIGHT", 6, 0); write:SetSize(84, 24); write:SetText("Write")
    write:SetScript("OnClick", WriteNote)
    local retell = CreateFrame("Button", nil, book)
    retell.label = retell:CreateFontString(nil, "ARTWORK", "GameFontHighlightSmall"); retell.label:SetPoint("CENTER"); retell:SetFontString(retell.label); A.StyleBookControl(retell, false)
    retell:SetPoint("LEFT", write, "RIGHT", 6, 0); retell:SetSize(76, 24); retell:SetText("Retell")
    retell:SetScript("OnClick", function()
        local person = Shown()
        if not person then return end
        person.retell = (tonumber(person.retell) or 0) + 1
        if person.self and A.CharacterRecord then
            local record = person.charKey == (A.Me and A.Me()) and A.MyCharacter and A.MyCharacter(true) or A.CharacterRecord(person.charKey)
            if record then record.retell = person.retell end
        end
        A.RefreshBook()
    end)
    local close = CreateFrame("Button", nil, book, "UIPanelButtonTemplate")
    close:SetPoint("BOTTOMRIGHT", -26, 16); close:SetSize(100, 24); close:SetText("Close")
    close:SetScript("OnClick", function() book:Hide() end)
    if A.OptionsSkin then
        A.OptionsSkin.Button(close)
    end
    -- (one row, one height; the X closes the book)
    input:ClearAllPoints(); input:SetPoint("BOTTOMLEFT", 24, 18); input:SetSize(240, 22)
    write:SetSize(50, 22); retell:SetSize(56, 22)
    close:Hide(); close.Show = close.Hide
    book.input, book.write, book.retell, book.close, book.noteDate, book.writeHint = input, write, retell, close, noteDate, hint
    book:SetScript("OnSizeChanged", function() if book:IsShown() then A.RefreshBook() end end)
    book:SetScript("OnHide", function()
        CommitRead()
        if book.manager then book.manager:Hide() end
        if book.npcManager then book.npcManager:Hide() end
        if A.UpdateBookMinimap then A.UpdateBookMinimap() end
    end)
    book:Hide()
end

-- The companion card: who they are to you. One card, shown three ways (Settings >
-- Testing): A, a slim panel opened with the quill; B, the About and Notes tabs;
-- C, the page flipped with the Card button. It saves as the classic window does.
local function CardEdit(parent, x, y, width, letters, field)
    local box = CreateFrame("EditBox", nil, parent, "InputBoxTemplate")
    box:SetPoint("TOPLEFT", x + 6, y); box:SetSize(width - 6, 22)
    box:SetAutoFocus(false); box:SetMaxLetters(letters)
    local function Save(self)
        local person = state.key and A.People[state.key]
        if not person then return end
        local text = (self:GetText() or ""):gsub("^%s+", ""):gsub("%s+$", "")
        person[field] = text ~= "" and text or nil
        A.Refresh()
    end
    box:SetScript("OnEnterPressed", function(self) Save(self); self:ClearFocus() end)
    box:SetScript("OnEditFocusLost", Save)
    box:SetScript("OnEscapePressed", function(self) self:ClearFocus(); A.RefreshBook() end)
    return box
end
function BuildCard()
    local card = CreateFrame("Frame", nil, book)
    card:SetSize(CARD_W, 420)
    card.updates = {}
    local function Label(text, y)
        local label = card:CreateFontString(nil, "ARTWORK", "GameFontNormal")
        label:SetPoint("TOPLEFT", 4, y); label:SetText(text); label:SetTextColor(unpack(CHAPTER))
        return label
    end
    local function Choice(y, choices, get, set)
        local x, buttons = 4, {}
        for _, choice in ipairs(choices) do
            local width = math.max(30, #choice[2] * 7 + 14)
            local button = Toggle(card, choice[2], width, nil, nil, function()
                local person = state.key and A.People[state.key]
                if person then set(person, choice[1]); A.RefreshBook() end
            end)
            button:SetPoint("TOPLEFT", x, y)
            x = x + width + 3
            buttons[#buttons + 1] = {button = button, value = choice[1]}
        end
        card.updates[#card.updates + 1] = function(person)
            local current = get(person)
            for _, item in ipairs(buttons) do SetChosen(item.button, item.value == current) end
        end
    end
    card.title = card:CreateFontString(nil, "ARTWORK", "GameFontNormalLarge")
    card.title:SetPoint("TOPLEFT", 4, -2); card.title:SetWidth(CARD_W - 8); card.title:SetJustifyH("LEFT")
    card.met = card:CreateFontString(nil, "ARTWORK", "GameFontHighlightSmall")
    card.met:SetPoint("TOPLEFT", 4, -24); card.met:SetWidth(CARD_W - 8); card.met:SetJustifyH("LEFT")
    card.met:SetTextColor(unpack(INK_SOFT))
    Label("Display name", -52)
    card.display = CardEdit(card, 112, -48, CARD_W - 116, 60, "display")
    Label("Icon", -82)
    card.glyph = Toggle(card, "", 40, "Their icon", "Shown beside their name in the world.", function(self)
        local person = state.key and A.People[state.key]
        if person and A.PickGlyph then
            A.PickGlyph(self, A.IconGlyph("people", person), A.IconColor("people", person), function(name) person.glyph = name; A.Refresh(); A.RefreshBook() end, true)
        end
    end)
    card.glyph:SetPoint("TOPLEFT", 112, -80)
    card.glyph.icon = card.glyph:CreateTexture(nil, "ARTWORK")
    card.glyph.icon:SetPoint("CENTER"); card.glyph.icon:SetSize(14, 14)
    card.color = Toggle(card, "", 40, "Icon color", nil, function(self)
        local person = state.key and A.People[state.key]
        if person and A.PickIconColor then A.PickIconColor("people", self, person) end
    end)
    card.color:SetPoint("LEFT", card.glyph, "RIGHT", 4, 0)
    card.color.swatch = card.color:CreateTexture(nil, "ARTWORK")
    card.color.swatch:SetPoint("TOPLEFT", 6, -5); card.color.swatch:SetPoint("BOTTOMRIGHT", -6, 5)
    Label("Note", -112)
    card.note = CardEdit(card, 112, -108, CARD_W - 116, 200, "note")
    Label("List", -146)
    Choice(-164, {{"companion", "Companion"}, {"acquaintance", "Acquaintance"}, {"campfire", "Campfire"}, {"rival", "Rival"}},
        function(person) return A.PersonCircle(person) end,
        function(person, value) if A.PersonCircle(person) ~= value and A.MovePerson then A.MovePerson(state.key, value) end end)
    Label("They are", -194)
    Choice(-212, {{"none", "-"}, {"spouse", "Spouse"}, {"partner", "Partner"}, {"friend", "Friend"}, {"family", "Family"}},
        function(person) return person.bond or "none" end, function(person, value) A.SetPersonStory(person, "bond", value) end)
    Label("How it began", -242)
    Choice(-260, {{"road", "On the road"}, {"together", "Together"}},
        function(person) return person.origin or "road" end, function(person, value) A.SetPersonStory(person, "origin", value) end)
    Label("Pronouns", -290)
    Choice(-308, {{"they", "They"}, {"he", "He"}, {"she", "She"}},
        function(person) return person.pronouns or "they" end, function(person, value) A.SetPersonPronouns(person, value) end)
    card.world = card:CreateFontString(nil, "ARTWORK", "GameFontHighlightSmall")
    card.world:SetPoint("TOPLEFT", 4, -340); card.world:SetWidth(CARD_W - 8); card.world:SetJustifyH("LEFT")
    card.world:SetTextColor(unpack(INK_SOFT))
    function card:Load(key)
        local person = A.People[key]
        if not person then return end
        self.title:SetText(person.display and (person.display .. "  |cff6b5a44" .. ShortName(person.name) .. "|r") or ShortName(person.name or key))
        self.title:SetTextColor(ClassColor(person.class))
        local met = A.DescribeMet and A.DescribeMet(person)
        local seen = A.DescribeSeen and A.DescribeSeen(person)
        self.met:SetText(table.concat({met or "", seen and ("Last seen " .. seen) or ""}, met and seen and "   " or ""))
        if not self.display:HasFocus() then self.display:SetText(person.display or "") end
        if not self.note:HasFocus() then self.note:SetText(person.note or "") end
        local glyph = A.IconGlyph and A.IconGlyph("people", person)
        local tint = A.IconColor and A.IconColor("people", person) or {1, 1, 1}
        self.glyph.icon:SetShown(glyph ~= nil and glyph ~= "none")
        if glyph and glyph ~= "none" then self.glyph.icon:SetTexture(A.GlyphPath(glyph)); self.glyph.icon:SetVertexColor(tint[1], tint[2], tint[3]) end
        self.glyph.label:SetText(glyph == "none" and "None" or "")
        self.color.swatch:SetColorTexture(tint[1], tint[2], tint[3])
        for _, update in ipairs(self.updates) do update(person) end
        self.world:SetText("Their name and icon on nameplates follow your settings (Settings > People and the world).")
    end
    return card
end
-- The notes page (variant B's Notes tab): the note, larger.
function BuildNotes()
    local notes = CreateFrame("Frame", nil, book)
    notes.title = notes:CreateFontString(nil, "ARTWORK", "GameFontNormal")
    notes.title:SetPoint("TOPLEFT", 4, -2); notes.title:SetTextColor(unpack(CHAPTER)); notes.title:SetText("Note")
    local box = CreateFrame("EditBox", nil, notes)
    box:SetMultiLine(true); box:SetAutoFocus(false); box:SetMaxLetters(200)
    box:SetFontObject("QuestFont"); box:SetTextColor(unpack(INK))
    box:SetPoint("TOPLEFT", 4, -24); box:SetPoint("BOTTOMRIGHT", -4, 4)
    local function Save(self)
        local person = state.key and A.People[state.key]
        if not person then return end
        local text = (self:GetText() or ""):gsub("^%s+", ""):gsub("%s+$", "")
        person.note = text ~= "" and text or nil
        A.Refresh()
    end
    box:SetScript("OnEditFocusLost", Save)
    box:SetScript("OnEscapePressed", function(self) self:ClearFocus() end)
    notes.box = box
    return notes
end
-- Where the card shows, for the variant chosen.
local function PlaceCard(person)
    local variant = A.BookVariant("card")
    -- (the header's card buttons are never shown: a companion's card opens from the cog
    -- beside their pin ribbon, on the Companions page)
    local people = false
    book.quill:SetShown(people and variant == "a")
    book.flip:SetShown(people and variant == "c")
    for key, tab in pairs(book.tabs) do if key ~= "last" then tab:SetShown(people and variant == "b") end end
    local cardShown, notesShown = false, false
    if people then
        if variant == "a" then cardShown = state.cardOpen
        elseif variant == "b" then cardShown, notesShown = state.tab == "about", state.tab == "notes"
        else cardShown = state.cardOpen end
    end
    -- A: the card on the left page, beside the chapter. B and C: the right page.
    local slim = variant == "a"
    book.cardHost:ClearAllPoints()
    book.cardHost:SetAllPoints(slim and book.left or book.right)
    local adding = state.wizard ~= nil and A.BookVariant("add") == "b"
    if adding then cardShown, notesShown = false, false; slim = false; book.cardHost:ClearAllPoints(); book.cardHost:SetAllPoints(book.right) end
    book.cardHost:SetShown(cardShown or notesShown or adding)
    book.card:SetShown(cardShown); book.notes:SetShown(notesShown)
    book.wizard:SetShown(adding); book.wizard:Update()
    if cardShown then book.card:Load(state.key) end
    if notesShown then
        if not book.notes.box:HasFocus() then book.notes.box:SetText(person.note or "") end
    end
    -- (B and C cover the chapter; A covers the contents, beside it)
    book.rightPage:SetShown(not ((cardShown or notesShown or adding) and not slim))
    if slim and cardShown then book.contents:Hide() elseif A.db.bookSpread ~= "two" then book.contents:Show() end
    for key, tab in pairs(book.tabs) do if key ~= "last" then SetChosen(tab, key == (state.tab or "journal")) end end
    book.flip.label:SetText(cardShown and "Journal" or "Card")
    SetChosen(book.flip, cardShown)
    SetChosen(book.quill, cardShown)
end

-- Adding someone (Settings > Testing): A, one smart button that names your
-- target; B, three steps (who, list and bond, look) on the right page;
-- C, today's flow (Add my target, or type a name).
local function TargetInfo()
    local okPlayer, player = pcall(UnitExists, "target")
    if not okPlayer or player ~= true then return nil end
    local okName, name = pcall(UnitName, "target")
    if not okName or type(name) ~= "string" or (issecretvalue and issecretvalue(name)) then name = nil end
    local person, key = nil, nil
    if A.FindPerson then person, key = A.FindPerson("target") end
    return {name = name, key = person and key or nil}
end
-- Open someone just added (or found), on their card.
local function OpenAdded(key)
    if not key or not A.People[key] then return end
    A.OpenBook(key)
    if A.BookVariant("card") == "b" then state.tab = "about" else state.cardOpen = true end
    A.RefreshBook()
end
local function AddTyped(text)
    text = (text or ""):gsub("^%s+", ""):gsub("%s+$", "")
    if text == "" or not A.AddPerson then return nil end
    local name, realm = text:match("^([^%-]+)%-(.+)$")
    local person, key = A.AddPerson(name or text, realm)
    if person then print("Companion Journal: added " .. (person.name or text) .. " to your list.") end
    return key
end
function BuildAddBar()
    local bar = CreateFrame("Frame", nil, book.contents)
    local function ActionButton()
        local button = CreateFrame("Button", nil, bar)
        button.label = button:CreateFontString(nil, "ARTWORK", "GameFontHighlightSmall")
        button.label:SetPoint("CENTER"); button:SetFontString(button.label)
        A.StyleBookControl(button, false)
        return button
    end
    -- (inside the page's margins, clear of the burnt edge)
    local box = book.contents.box
    bar:SetPoint("BOTTOMLEFT", box[1] - 4, box[4] - 4); bar:SetPoint("BOTTOMRIGHT", -(box[3] - 20), box[4] - 4); bar:SetHeight(28)
    local rule = bar:CreateTexture(nil, "ARTWORK")
    rule:SetPoint("TOPLEFT", 0, 4); rule:SetPoint("TOPRIGHT", 0, 4); rule:SetHeight(1)
    rule:SetColorTexture(INK_SOFT[1], INK_SOFT[2], INK_SOFT[3], 0.5)
    -- A and B: one button.
    bar.main = ActionButton()
    bar.main:SetPoint("LEFT", 0, 0); bar.main:SetSize(200, 24)
    bar.main:SetScript("OnClick", function()
        local variant = A.BookVariant("add")
        if variant == "b" then
            state.wizard = {step = 1, circle = "companion", bond = "none"}
            A.RefreshBook()
            return
        end
        local target = TargetInfo()
        if target and target.key then OpenAdded(target.key); return end
        local _, key = A.AddTargetPerson()
        OpenAdded(key)
    end)
    -- C: Add my target, or a typed name.
    bar.target = ActionButton()
    bar.target:SetPoint("LEFT", 0, 0); bar.target:SetSize(118, 24); bar.target:SetText("Add my target")
    bar.target:SetScript("OnClick", function() local _, key = A.AddTargetPerson(); OpenAdded(key) end)
    bar.name = CreateFrame("EditBox", nil, bar, "InputBoxTemplate")
    bar.name:SetPoint("LEFT", bar.target, "RIGHT", 10, 0); bar.name:SetSize(110, 22)
    bar.name:SetAutoFocus(false); bar.name:SetMaxLetters(60)
    bar.hint = bar.name:CreateFontString(nil, "ARTWORK", "GameFontDisableSmall")
    bar.hint:SetPoint("LEFT", 4, 0); bar.hint:SetText("Name")
    bar.name:SetScript("OnTextChanged", function(self) bar.hint:SetShown((self:GetText() or "") == "") end)
    bar.name:SetScript("OnEscapePressed", function(self) self:ClearFocus() end)
    local function Typed() local key = AddTyped(bar.name:GetText()); bar.name:SetText(""); bar.name:ClearFocus(); OpenAdded(key) end
    bar.name:SetScript("OnEnterPressed", Typed)
    bar.add = ActionButton()
    bar.add:SetPoint("LEFT", bar.name, "RIGHT", 4, 0); bar.add:SetSize(50, 24); bar.add:SetText("Add")
    bar.add:SetScript("OnClick", Typed)
    function bar:Update()
        local variant = A.BookVariant("add")
        self.main:SetShown(variant ~= "c")
        for _, part in ipairs({self.target, self.name, self.add}) do part:SetShown(variant == "c") end
        if variant == "b" then
            self.main:SetText("+ Add someone"); self.main:SetEnabled(true)
        elseif variant == "a" then
            local target = TargetInfo()
            if target and target.key then
                local person = A.People[target.key]
                self.main:SetText("Open " .. (person and (person.display or ShortName(person.name)) or (target.name or "them")))
                self.main:SetEnabled(not (person and person.npc))
            elseif target then
                self.main:SetText(target.name and ("Add " .. ShortName(target.name)) or "Add my target"); self.main:SetEnabled(true)
            else
                self.main:SetText("Add my target"); self.main:SetEnabled(false)
            end
        end
    end
    -- (the smart button follows your target)
    bar:RegisterEvent("PLAYER_TARGET_CHANGED")
    bar:SetScript("OnEvent", function(self) if book:IsShown() then self:Update() end end)
    return bar
end
-- The three steps (variant B), on the right page.
local RECENT = 6
local function Recent()
    local list = {}
    for key, memory in pairs(A.db.journalAside or {}) do
        if type(memory) == "table" and memory.name and not A.People[key] then
            local last = memory.left or 0
            for _, entry in ipairs(memory.journal or {}) do last = math.max(last, entry.t or 0) end
            list[#list + 1] = {key = key, name = memory.name, last = last}
        end
    end
    table.sort(list, function(x, y) return x.last > y.last end)
    while #list > RECENT do table.remove(list) end
    return list
end
function BuildWizard()
    local wizard = CreateFrame("Frame", nil, book.cardHost.child)
    wizard:SetPoint("TOPLEFT", 6, -2); wizard:SetSize(CARD_W, 420)
    wizard.steps = {}
    local function Title(step, text)
        local title = step:CreateFontString(nil, "ARTWORK", "GameFontNormalLarge")
        title:SetPoint("TOPLEFT", 4, -2); title:SetText(text); title:SetTextColor(unpack(CHAPTER))
    end
    local function Label(step, text, y)
        local label = step:CreateFontString(nil, "ARTWORK", "GameFontNormal")
        label:SetPoint("TOPLEFT", 4, y); label:SetText(text); label:SetTextColor(unpack(CHAPTER))
    end
    local function Nav(step, back, nextText, onNext)
        if back then
            local b = Toggle(step, "Back", 60, nil, nil, function() state.wizard.step = state.wizard.step - 1; A.RefreshBook() end)
            b:SetPoint("TOPLEFT", 4, -330)
        end
        local n = Toggle(step, nextText, 90, nil, nil, onNext)
        n:SetPoint("TOPLEFT", 160, -330)
        local cancel = Toggle(step, "Cancel", 60, nil, nil, function() state.wizard = nil; A.RefreshBook() end)
        cancel:SetPoint("TOPLEFT", 254, -330)
        step.next = n
    end
    -- 1. Who.
    local who = CreateFrame("Frame", nil, wizard); who:SetAllPoints()
    Title(who, "1 \194\183 Who")
    who.target = Toggle(who, "My target", 120, nil, nil, function()
        local target = TargetInfo()
        if target then state.wizard.who = {kind = "target", label = target.name or "your target"}; A.RefreshBook() end
    end)
    who.target:SetPoint("TOPLEFT", 4, -36)
    Label(who, "Recent groupmates", -70)
    who.recent = {}
    for i = 1, RECENT do
        local b = Toggle(who, "", 150, nil, nil, function(self)
            if self.key then state.wizard.who = {kind = "aside", key = self.key, name = self.name, label = ShortName(self.name)}; A.RefreshBook() end
        end)
        b:SetPoint("TOPLEFT", 4 + ((i - 1) % 2) * 156, -90 - math.floor((i - 1) / 2) * 24)
        who.recent[i] = b
    end
    Label(who, "Or a name", -170)
    who.name = CreateFrame("EditBox", nil, who, "InputBoxTemplate")
    who.name:SetPoint("TOPLEFT", 10, -190); who.name:SetSize(180, 22); who.name:SetAutoFocus(false); who.name:SetMaxLetters(60)
    who.name:SetScript("OnEnterPressed", function(self)
        local text = (self:GetText() or ""):gsub("^%s+", ""):gsub("%s+$", "")
        if text ~= "" then state.wizard.who = {kind = "name", name = text, label = text}; self:ClearFocus(); A.RefreshBook() end
    end)
    who.name:SetScript("OnEscapePressed", function(self) self:ClearFocus() end)
    who.chosen = who:CreateFontString(nil, "ARTWORK", "GameFontHighlight")
    who.chosen:SetPoint("TOPLEFT", 4, -230); who.chosen:SetWidth(CARD_W - 8); who.chosen:SetJustifyH("LEFT"); who.chosen:SetTextColor(unpack(INK))
    Nav(who, false, "Next", function()
        if not state.wizard.who then
            local text = (who.name:GetText() or ""):gsub("^%s+", ""):gsub("%s+$", "")
            if text ~= "" then state.wizard.who = {kind = "name", name = text, label = text} end
        end
        if state.wizard.who then state.wizard.step = 2; A.RefreshBook() end
    end)
    wizard.steps[1] = who
    -- 2. Their list, and what they are to you.
    local bond = CreateFrame("Frame", nil, wizard); bond:SetAllPoints()
    Title(bond, "2 \194\183 Who they are to you")
    bond.choices = {}
    local function Row(step, y, field, choices)
        local x = 4
        for _, choice in ipairs(choices) do
            local width = math.max(30, #choice[2] * 7 + 14)
            local b = Toggle(step, choice[2], width, nil, nil, function() state.wizard[field] = choice[1]; A.RefreshBook() end)
            b:SetPoint("TOPLEFT", x, y); x = x + width + 3
            bond.choices[#bond.choices + 1] = {button = b, field = field, value = choice[1]}
        end
    end
    Label(bond, "List", -36)
    Row(bond, -56, "circle", {{"companion", "Companion"}, {"acquaintance", "Acquaintance"}, {"campfire", "Campfire"}, {"rival", "Rival"}})
    Label(bond, "They are", -90)
    Row(bond, -110, "bond", {{"none", "-"}, {"spouse", "Spouse"}, {"partner", "Partner"}, {"friend", "Friend"}, {"family", "Family"}})
    Nav(bond, true, "Next", function() state.wizard.step = 3; A.RefreshBook() end)
    wizard.steps[2] = bond
    -- 3. How they show: a name of your own for them.
    local look = CreateFrame("Frame", nil, wizard); look:SetAllPoints()
    Title(look, "3 \194\183 Their name in your book")
    Label(look, "Display name (optional)", -36)
    look.display = CreateFrame("EditBox", nil, look, "InputBoxTemplate")
    look.display:SetPoint("TOPLEFT", 10, -56); look.display:SetSize(180, 22); look.display:SetAutoFocus(false); look.display:SetMaxLetters(60)
    look.display:SetScript("OnEscapePressed", function(self) self:ClearFocus() end)
    look.note = look:CreateFontString(nil, "ARTWORK", "GameFontHighlightSmall")
    look.note:SetPoint("TOPLEFT", 4, -90); look.note:SetWidth(CARD_W - 8); look.note:SetJustifyH("LEFT"); look.note:SetTextColor(unpack(INK_SOFT))
    look.note:SetText("Their icon and note can be set on their card afterwards.")
    Nav(look, true, "Add", function()
        local w = state.wizard
        local key
        if w.who.kind == "target" then
            local _, found = A.AddTargetPerson(); key = found
        elseif w.who.kind == "aside" then
            key = AddTyped(w.who.name)
        else
            key = AddTyped(w.who.name)
        end
        local person = key and A.People[key]
        if person then
            if w.circle ~= "companion" and A.MovePerson then A.MovePerson(key, w.circle) end
            if w.bond ~= "none" then A.SetPersonStory(person, "bond", w.bond) end
            local display = (look.display:GetText() or ""):gsub("^%s+", ""):gsub("%s+$", "")
            if display ~= "" then person.display = display end
            if A.Refresh then A.Refresh() end
        end
        state.wizard = nil
        look.display:SetText("")
        OpenAdded(key)
    end)
    wizard.steps[3] = look
    function wizard:Update()
        local w = state.wizard
        for i, step in ipairs(self.steps) do step:SetShown(w and w.step == i) end
        if not w then return end
        local target = TargetInfo()
        who.target:SetEnabled(target ~= nil)
        who.target.label:SetText(target and target.name and ("Target: " .. ShortName(target.name)) or "My target")
        local recent = Recent()
        for i, b in ipairs(who.recent) do
            local item = recent[i]
            b:SetShown(item ~= nil)
            if item then b.key, b.name = item.key, item.name; b.label:SetText(ShortName(item.name)); SetChosen(b, w.who and w.who.key == item.key) end
        end
        who.chosen:SetText(w.who and ("Adding: " .. w.who.label) or "Choose someone.")
        SetChosen(who.target, w.who and w.who.kind == "target")
        for _, item in ipairs(bond.choices) do SetChosen(item.button, w[item.field] == item.value) end
    end
    return wizard
end

-- Portraits (Settings > Testing): you as you were, in your own journal, from the
-- looks Wardrobe Time Capsule saves at each level (your gear and transmog then),
-- or as you are now. When: off, the book's start, every ten levels, each level.
-- Where: a plate above the chapter, the facing page (two pages), a cameo, the
-- contents page, the margin. Frame: painted, cameo, scrapbook, plain.
local PORTRAIT_SLOTS = {1, 3, 4, 5, 6, 7, 8, 9, 10, 15, 19, 16, 17, 18}
local function Looks()
    local wtc = WardrobeTimeCapsuleDB and WardrobeTimeCapsuleDB.forever
    local ok, guid = pcall(UnitGUID, "player")
    if not (wtc and wtc.characters and ok and type(guid) == "string") then return {} end
    local album = wtc.characters[guid]
    return album and type(album.entries) == "table" and album.entries or {}
end
-- The look for a level: that level's, else the nearest before it; nil: as you are now.
function LookFor(level)
    local best
    for _, look in ipairs(Looks()) do
        if look.level and (not level or look.level <= level) and (not best or look.level > best.level) then best = look end
    end
    return best
end
local function ChapterLevels(chapter)
    local levels = {}
    local day = chapter and chapter.day
    for _, scene in ipairs(day and day.scenes or {}) do
        for _, e in ipairs(scene.events or {}) do
            if (e.k == "mylevel" or e.k == "level") and tonumber(e.d) then levels[#levels + 1] = tonumber(e.d) end
        end
    end
    table.sort(levels)
    return levels
end
-- Does this chapter of your own journal carry a portrait? {level, look} or nil.
local function PortraitFor(person, chapter, index)
    local when = A.BookVariant("portraitWhen")
    if when == "off" or not person or not person.self or not chapter or (chapter.part or 1) > 1
        or person.charKey ~= (A.Me and A.Me()) then return nil end
    local levels = ChapterLevels(chapter)
    local level
    if when == "start" then
        if index ~= 1 then return nil end
        level = levels[1] or person.startLevel
    elseif when == "ten" then
        for _, l in ipairs(levels) do if l % 10 == 0 then level = l end end
        if not level then return nil end
    else
        level = levels[#levels]
        if not level then return nil end
    end
    return {level = level, look = LookFor(level), zone = chapter.day and chapter.day.zone}
end
-- Dress a model as a saved look (as Wardrobe Time Capsule does), or as you are.
local function Dress(model, look)
    if not model.SetUnit then return end
    model:SetUnit("player")
    if not look or type(look.items) ~= "table" then return end
    local function Apply(self)
        if self.applying then return end
        self.applying = true
        if self.Undress then self:Undress() end
        for _, slot in ipairs(PORTRAIT_SLOTS) do
            local item = look.items[slot]
            local shown = item and item.look or look.extra and look.extra[slot]
            local hidden = (slot == 1 and look.showHelm == false) or (slot == 15 and look.showCloak == false)
            -- (a slot the transmog hid stays bare)
            if (item or shown) and (look.drawn or not hidden) and not (shown and shown.hidden) then
                local hand = slot == 17 and "SECONDARYHANDSLOT" or slot == 16 and "MAINHANDSLOT" or nil
                if shown and self.SetItemTransmogInfo and ItemUtil and ItemUtil.CreateItemTransmogInfo then
                    pcall(self.SetItemTransmogInfo, self, ItemUtil.CreateItemTransmogInfo(shown.appearance, shown.secondary, shown.illusion), slot)
                elseif shown and self.TryOn then
                    pcall(self.TryOn, self, shown.appearance, hand, shown.illusion ~= 0 and shown.illusion or nil)
                elseif item and item.link and self.TryOn then
                    pcall(self.TryOn, self, item.link, hand)
                end
            end
        end
        self.applying = false
    end
    model:SetScript("OnModelLoaded", Apply)
    Apply(model)
end
-- A portrait in its frame: built once per page, styled by the variant.
local INK_RULE = {0.30, 0.18, 0.07}
local function Edges(frame, layer, inset, thickness, color)
    local edges = {}
    for _, side in ipairs({"TOP", "BOTTOM", "LEFT", "RIGHT"}) do
        local edge = frame:CreateTexture(nil, layer)
        if side == "TOP" or side == "BOTTOM" then
            edge:SetPoint(side .. "LEFT", inset, side == "TOP" and -inset or inset)
            edge:SetPoint(side .. "RIGHT", -inset, side == "TOP" and -inset or inset)
            edge:SetHeight(thickness)
        else
            edge:SetPoint("TOP" .. side, side == "LEFT" and inset or -inset, -inset)
            edge:SetPoint("BOTTOM" .. side, side == "LEFT" and inset or -inset, inset)
            edge:SetWidth(thickness)
        end
        edge:SetColorTexture(color[1], color[2], color[3], color[4] or 1)
        edges[#edges + 1] = edge
    end
    return edges
end
function Portrait(parent)
    local frame = CreateFrame("Frame", nil, parent)
    frame:SetFrameLevel(parent:GetFrameLevel() + 3)
    frame.ground = frame:CreateTexture(nil, "BACKGROUND")
    frame.ground:SetAllPoints()
    frame.model = CreateFrame("DressUpModel", nil, frame)
    frame.model:SetPoint("TOPLEFT", 6, -6); frame.model:SetPoint("BOTTOMRIGHT", -6, 6)
    frame.wash = frame:CreateTexture(nil, "OVERLAY")
    frame.wash:SetPoint("TOPLEFT", frame.model); frame.wash:SetPoint("BOTTOMRIGHT", frame.model)
    frame.outer = Edges(frame, "OVERLAY", 0, 2, INK_RULE)
    frame.inner = Edges(frame, "OVERLAY", 5, 1, INK_RULE)
    frame.tabs = {}
    for _, corner in ipairs({"TOPLEFT", "TOPRIGHT", "BOTTOMLEFT", "BOTTOMRIGHT"}) do
        local tab = frame:CreateTexture(nil, "OVERLAY", nil, 2)
        tab:SetSize(16, 16); tab:SetPoint(corner, corner:find("LEFT") and -4 or 4, corner:find("TOP") and 4 or -4)
        tab:SetColorTexture(0.22, 0.15, 0.08, 0.9)
        frame.tabs[#frame.tabs + 1] = tab
    end
    frame.caption = frame:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
    frame.caption:SetPoint("TOP", frame, "BOTTOM", 0, -4); frame.caption:SetTextColor(INK_SOFT[1], INK_SOFT[2], INK_SOFT[3])
    frame:Hide()
    function frame:Style(style)
        local function Show(list, on) for _, t in ipairs(list) do t:SetShown(on) end end
        self.wash:Hide()
        if style == "b" then -- cameo: a dark ground and a gold rule
            self.ground:SetColorTexture(0.12, 0.09, 0.06, 1)
            for _, t in ipairs(self.outer) do t:SetColorTexture(0.85, 0.66, 0.20, 1) end
            Show(self.outer, true); Show(self.inner, false); Show(self.tabs, false)
        elseif style == "c" then -- scrapbook: a sepia photo, a white edge, corner tabs
            self.ground:SetColorTexture(0.52, 0.42, 0.30, 1)
            for _, t in ipairs(self.outer) do t:SetColorTexture(0.92, 0.88, 0.80, 1) end
            Show(self.outer, true); Show(self.inner, false); Show(self.tabs, true)
            self.wash:SetColorTexture(0.55, 0.40, 0.20, 0.18); self.wash:Show()
        elseif style == "d" then -- plain: the figure on the page
            self.ground:SetColorTexture(0, 0, 0, 0)
            Show(self.outer, false); Show(self.inner, false); Show(self.tabs, false)
        else -- painted: a darker parchment, a double rule, a wash of paper over the figure
            self.ground:SetColorTexture(0.55, 0.45, 0.32, 1)
            for _, t in ipairs(self.outer) do t:SetColorTexture(INK_RULE[1], INK_RULE[2], INK_RULE[3], 1) end
            Show(self.outer, true); Show(self.inner, true); Show(self.tabs, false)
            self.wash:SetAtlas("QuestBG-Parchment"); self.wash:SetAlpha(0.22); self.wash:Show()
        end
    end
    function frame:Fill(info, zoom)
        Dress(self.model, info.look)
        if self.model.SetPortraitZoom then self.model:SetPortraitZoom(zoom or 0) end
        if self.model.SetFacing then self.model:SetFacing(-0.35) end
        local me = A.Me and A.Me()
        local mine = me and A.SelfPerson and A.SelfPerson(me)
        local zone = info.look and info.look.zone ~= "" and info.look.zone or info.zone
        self.caption:SetText(((mine and mine.name) or "") .. (info.level and (", level " .. info.level) or "")
            .. (zone and (", " .. zone) or "") .. ((info.look or info.now) and "" or ""))
        self:Show()
    end
    return frame
end
-- Make room on a page for its portrait, or give the room back.
-- The journal's title page: the journal's first page opens with the name, who
-- they are, and the quest log's flourish, above the portrait and the first chapter.
-- A click on the name gives them a last name.
local function TitleFont()
    if A.bookTitleFont then return A.bookTitleFont end
    local font = CreateFont("CompanionJournalTitleFont")
    local path = QuestFont_Super_Huge and QuestFont_Super_Huge.GetFont and QuestFont_Super_Huge:GetFont()
    font:SetFont(path or "Fonts\\MORPHEUS.TTF", 30, "")
    A.bookTitleFont = font
    return font
end
local function TitleBlock(page)
    if page.titleBlock then return page.titleBlock end
    local t = CreateFrame("Frame", nil, page)
    t:SetFrameLevel(page:GetFrameLevel() + 6)
    t.name = t:CreateFontString(nil, "ARTWORK")
    t.name:SetFontObject(TitleFont()); t.name:SetTextColor(CHAPTER[1], CHAPTER[2], CHAPTER[3])
    if t.name.SetShadowOffset then t.name:SetShadowOffset(0, 0) end
    t.name:SetJustifyH("CENTER"); t.name:SetWordWrap(false); t.name:SetPoint("TOP")
    t.sub = t:CreateFontString(nil, "ARTWORK", Font("QuestFontNormalSmall", "GameFontNormalSmall"))
    t.sub:SetTextColor(INK_SOFT[1], INK_SOFT[2], INK_SOFT[3])
    if t.sub.SetShadowOffset then t.sub:SetShadowOffset(0, 0) end
    t.sub:SetJustifyH("CENTER"); t.sub:SetWordWrap(true); t.sub:SetPoint("TOP", t.name, "BOTTOM", 0, -6)
    t.rule = t:CreateTexture(nil, "ARTWORK")
    t.rule:SetTexture("Interface\\QuestFrame\\UI-HorizontalBreak")
    t.rule:SetSize(180, 22); t.rule:SetVertexColor(0.62, 0.42, 0.22, 0.9)
    t.rule:SetPoint("TOP", t.sub, "BOTTOM", 0, -2)
    -- (the name is the place to write their last name)
    t.hit = CreateFrame("Button", nil, t)
    t.hit:SetPoint("TOPLEFT", t.name, "TOPLEFT"); t.hit:SetPoint("BOTTOMRIGHT", t.name, "BOTTOMRIGHT")
    t.edit = CreateFrame("EditBox", nil, t, "InputBoxTemplate")
    t.edit:SetSize(160, 22); t.edit:SetPoint("TOP", t.name, "BOTTOM", 0, -2); t.edit:SetAutoFocus(false); t.edit:SetMaxLetters(40)
    t.edit:SetFrameLevel(t:GetFrameLevel() + 4)
    t.edit.hint = t.edit:CreateFontString(nil, "ARTWORK", "GameFontDisableSmall")
    t.edit.hint:SetPoint("LEFT", 4, 0); t.edit.hint:SetText("Last name")
    t.edit:SetScript("OnTextChanged", function(self) self.hint:SetShown((self:GetText() or "") == "") end)
    t.edit:SetScript("OnEscapePressed", function(self) self.cancel = true; self:ClearFocus() end)
    t.edit:SetScript("OnEnterPressed", function(self) self:ClearFocus() end)
    t.edit:SetScript("OnEditFocusLost", function(self)
        local cancel, save = self.cancel, self.save
        self.cancel, self.save = nil, nil
        self:Hide()
        if not cancel and save then save(((self:GetText() or ""):gsub("^%s+", ""):gsub("%s+$", ""))) end
    end)
    t.edit:Hide()
    page.titleBlock = t
    return t
end
-- The name a journal goes by: first name (no realm), and the last name if one was given.
local function JournalTitle(person)
    if not person then return "" end
    local first = person.self and (person.name or "My journal") or (person.display or ShortName(person.name or state.key or ""))
    local card = not person.self and state.key and A.People[state.key] or nil
    local last = person.self and person.lastName or (card and card.lastName) or person.lastName
    return (last and last ~= "") and (first .. " " .. last) or first, last
end
local function TitleInfo(person)
    if not (book and person) then return nil end
    local name, last = JournalTitle(person)
    local sub = (A.PersonSummary(person) or ""):gsub("%s+%-%s+", "  \194\183  ")
    local second = {}
    local met = not person.self and A.DescribeMet and A.DescribeMet(person)
    if met then second[#second + 1] = "Met " .. tostring(met):gsub("^[Mm]et%s+", "") end
    if state.owner then second[#second + 1] = "Kept by " .. A.CharacterName(state.owner) end
    if #second > 0 then sub = sub .. "\n" .. table.concat(second, "  \194\183  ") end
    -- (your own character's record, or the companion's card, keeps the last name)
    local save
    if not person.readOnly and not state.owner then
        local record = person.self and A.MyCharacter and A.MyCharacter(true) or (not person.self and state.key and A.People[state.key]) or nil
        if record then
            save = function(text)
                record.lastName = text ~= "" and text:sub(1, 40) or nil
                state.pageCache = nil
                A.RefreshBook()
            end
        end
    end
    return {name = name, last = last, sub = sub, save = save}
end
local function PreparePage(page, info, where, chapter, title)
    page.portrait = page.portrait or Portrait(page)
    local frame = page.portrait
    local inset, top = 0, 0
    -- (the title page: its block first, the portrait or the first chapter below it)
    local titleHeight = 0
    if title then
        local t = TitleBlock(page)
        local width = math.max(140, (page:GetWidth() or 300) - page.pad)
        t:ClearAllPoints(); t:SetPoint("TOP", page, "TOP", (page.box[1] - page.box[3]) / 2, -(page.box[2] + 10)); t:SetSize(width, 10)
        t.name:SetWidth(width); t.name:SetText(title.name)
        t.sub:SetWidth(width); t.sub:SetText(title.sub)
        local subLines = select(2, title.sub:gsub("\n", "\n")) + 1
        t.hit:SetShown(title.save ~= nil)
        t.hit:SetScript("OnClick", function()
            if not title.save then return end
            t.edit.save = title.save; t.edit:SetText(title.last or ""); t.edit:Show(); t.edit:SetFocus()
        end)
        t.hit:SetScript("OnEnter", function(self)
            if not title.save then return end
            GameTooltip:SetOwner(self, "ANCHOR_BOTTOM")
            GameTooltip:SetText(title.last and "Click to change the last name." or "Click to add a last name.", 0.8, 0.8, 0.8)
            GameTooltip:Show()
        end)
        t.hit:SetScript("OnLeave", function() GameTooltip:Hide() end)
        t:Show()
        -- (10 of air above, the name, the line(s) under it, the flourish, then 20 of air)
        titleHeight = 10 + 34 + 6 + subLines * 14 + 2 + 22 + 20
    elseif page.titleBlock then
        page.titleBlock:Hide()
    end
    frame:ClearAllPoints()
    if info and (where == "a" or where == "b") then
        frame:SetPoint("TOP", (page.box[1] - page.box[3]) / 2, -page.box[2] - titleHeight); frame:SetSize(math.min(260, (page:GetWidth() or 300) - page.pad), 200)
        top = 236
    elseif info and where == "c" then
        frame:SetPoint("TOP", (page.box[1] - page.box[3]) / 2, -page.box[2] - titleHeight); frame:SetSize(120, 140)
        top = 176
    elseif info and where == "e" then
        frame:SetPoint("TOPLEFT", page.box[1], -page.box[2] - titleHeight); frame:SetSize(104, 136)
        inset = 118
    else
        frame:Hide()
    end
    -- Margin text was measured at a narrower width. Retain that width on
    -- continuation leaves so the stored line offsets still point to the same
    -- text, while hiding the portrait after the opening leaf.
    if chapter and chapter.inset then inset = chapter.inset end
    -- Keep enough room for readable text even in the smallest portrait layout.
    local maximumTop = math.max(0, (page:GetHeight() or 500) - page.box[2] - page.box[4] - 143 - titleHeight)
    if top > maximumTop then
        top = maximumTop
        if top >= 60 then frame:SetHeight(math.max(24, top - 36))
        else top = 0; frame:Hide(); info = nil end
    end
    top = top + titleHeight
    page.inset, page.topInset = inset, top
    page.scroll:ClearAllPoints()
    page.scroll:SetPoint("TOPLEFT", page.box[1] + inset, -page.box[2] - top)
    page.scroll:SetPoint("BOTTOMRIGHT", -page.box[3], page.box[4])
    page.child:SetWidth(math.max(120, (page:GetWidth() or 360) - page.pad - inset))
    return info and where ~= "d" and frame or nil
end

-- The timeline: a companion's chapters as marks under the page (a death, a dungeon,
-- the meeting, a level), the one shown ringed; a click turns to it.
local function Moments(chapter)
    local day = chapter and chapter.day
    if not day then return nil, nil end
    local kind, parts = nil, {}
    local rank = {death = 4, boss = 3, met = 2, level = 1}
    local function Take(k, text)
        if not kind or rank[k] > rank[kind] then kind = k end
        if text then parts[#parts + 1] = text end
    end
    for _, scene in ipairs(day.scenes or {}) do
        for _, e in ipairs(scene.events or {}) do
            if e.k == "death" then Take("death", "A death")
            elseif e.k == "boss" and e.d then Take("boss", tostring(e.d))
            elseif (e.k == "mylevel" or e.k == "level") and e.d then Take("level", "Level " .. tostring(e.d)) end
        end
        for _, level in ipairs(scene.levels or {}) do Take("level", "Level " .. tostring(level)) end
    end
    return kind, table.concat(parts, ", ")
end
local MOMENT_COLORS = {death = {0.62, 0.08, 0.06}, boss = {0.85, 0.65, 0.15}, met = {0.25, 0.55, 0.20}, level = {0.55, 0.50, 0.42}}
local function FillTimeline(chapters, person)
    local unique = {}
    for index, chapter in ipairs(chapters) do
        if not chapter.part or chapter.part == 1 then
            unique[#unique + 1] = {day = chapter.day, classic = chapter.classic, leafIndex = index, parts = chapter.parts or 1}
        end
    end
    chapters = unique
    local strip = book.timeline
    local show = A.db.bookTimeline ~= false and person and not person.self and #chapters > 1 and chapters[1].day ~= nil
        and not book.cardHost:IsShown()
    strip:SetShown(show and true or false)
    if not show then return end
    local width = strip:GetWidth()
    if not width or width < 50 then width = 360 end
    strip.marks = strip.marks or {}
    for i, chapter in ipairs(chapters) do
        local mark = strip.marks[i]
        if not mark then
            mark = CreateFrame("Button", nil, strip)
            mark.dot = mark:CreateTexture(nil, "ARTWORK"); mark.dot:SetPoint("CENTER")
            mark.ring = mark:CreateTexture(nil, "BACKGROUND"); mark.ring:SetPoint("CENTER"); mark.ring:SetSize(14, 14)
            mark.ring:SetColorTexture(1, 0.82, 0, 1)
            mark:SetScript("OnClick", function(self) state.index = self.index; A.RefreshBook() end)
            mark:SetScript("OnEnter", function(self)
                GameTooltip:SetOwner(self, "ANCHOR_TOP")
                GameTooltip:SetText(self.title or "", 1, 0.82, 0)
                if self.what and self.what ~= "" then GameTooltip:AddLine(self.what, 0.9, 0.9, 0.9, true) end
                GameTooltip:Show()
            end)
            mark:SetScript("OnLeave", function() GameTooltip:Hide() end)
            strip.marks[i] = mark
        end
        local kind, what = Moments(chapter)
        if i == 1 then kind = kind or "met"; what = (what ~= "" and (what .. ". ") or "") .. "How it began." end
        local size = (kind == "death" or kind == "boss" or kind == "met") and 9 or kind == "level" and 6 or 4
        mark:SetSize(14, 14)
        mark.dot:SetSize(size, size)
        local color = MOMENT_COLORS[kind] or {INK_SOFT[1], INK_SOFT[2], INK_SOFT[3]}
        mark.dot:SetColorTexture(color[1], color[2], color[3], 1)
        mark.ring:SetShown(state.index >= chapter.leafIndex and state.index < chapter.leafIndex + chapter.parts)
        mark.index, mark.title, mark.what = chapter.leafIndex, chapter.day.title or chapter.day.key, what
        mark:ClearAllPoints()
        mark:SetPoint("CENTER", strip, "LEFT", 8 + (width - 16) * (i - 1) / math.max(1, #chapters - 1), 0)
        mark:Show()
    end
    for i = #chapters + 1, #strip.marks do strip.marks[i]:Hide() end
end

-- A focused reader with comparable editions and independent page positions.
local reader
local function ReaderEdition() return A.JournalReader and A.JournalReader.Valid(A.db.readerEdition) or "original" end
local function SaveReaderPlace()
    if reader and reader.placeKey then
        reader.places = reader.places or {}
        reader.places[reader.placeKey] = reader.index or 1
    end
end
local function DrawReader(reusePages)
    local person = Shown()
    if not reader or not person then return end
    local edition = ReaderEdition()
    local choices = A.JournalReader and A.JournalReader.Companions(person) or {}
    local player = A.CharacterPlayer and ((person.self and A.CharacterPlayer(person.charKey)) or (state.owner and A.CharacterPlayer(state.owner))) or nil
    if edition == "ours" then
        local choice = choices[1]
        for _, candidate in ipairs(choices) do if candidate.key == reader.companionKey then choice = candidate end end
        reader.companionKey = choice and choice.key or nil
        person = choice and choice.person or person
    end
    reader.companions = choices
    reader.subject = person
    reader.placeKey = tostring(state.key) .. ":" .. (state.owner or "") .. ":" .. edition .. ":" .. (edition == "ours" and (reader.companionKey or "") or "")
    for key, button in pairs(reader.editions) do SetChosen(button, key == edition) end
    local chapters, styleKey, styleMode, Story
    local width = math.min(660, math.max(440, (UIParent:GetWidth() or 1024) - 80))
    local limit = math.min(740, math.max(360, (UIParent:GetHeight() or 900) - 80))
    -- A folio has a fixed page size. Only a change to the available screen
    -- dimensions can reflow it; short pages leave quiet space on the paper.
    if reader.layoutWidth ~= width or reader.layoutHeight ~= limit then reusePages = false end
    reader.layoutWidth, reader.layoutHeight = width, limit
    reader:SetWidth(width)
    reader.heading:SetWidth(width - 110)
    reader.status:SetShown(width >= 600)
    reader.mode:SetShown(width >= 640)
    reader.page.child:SetWidth(width - 38 - reader.page.pad)
    reader:SetHeight(limit)
    if GameTooltip then GameTooltip:Hide() end
    if reusePages and reader.pageCache then
        local cache = reader.pageCache
        chapters, styleKey, styleMode, Story = cache.leaves, cache.style, cache.mode, cache.story
    else
        if edition == "original" then
            chapters, styleKey, styleMode, Story = Chapters(person)
        elseif edition == "ours" and #choices == 0 then
            chapters, styleKey, styleMode, Story = {}, "b", "story", function() end
        else
            chapters, Story = A.JournalReader.Build(person, edition, player)
            styleKey, styleMode = "b", "story"
        end
        chapters = PageChapters(reader.page, person, chapters, styleKey, styleMode, Story)
        reader.pageCache = {leaves = chapters, style = styleKey, mode = styleMode, story = Story}
    end
    if reader.jumpDay then
        local found
        for i, leaf in ipairs(chapters) do
            local day = leaf.day and leaf.day.sourceDay or ChapterDay(leaf)
            if day == reader.jumpDay then
                if not found or leaf.offset <= (reader.jumpOffset or 0) then reader.index, found = i, true end
            elseif not found and day and day > reader.jumpDay then reader.index = i; break end
        end
        reader.jumpDay = nil
        reader.jumpOffset = nil
    end
    reader.index = math.max(1, math.min(reader.index or (reader.places and reader.places[reader.placeKey]) or 1, #chapters))
    local leaf = chapters[reader.index]
    DrawChapter(reader.page, person, leaf, styleKey, styleMode, Story)
    reader.page.empty:SetText(edition == "ours" and #choices == 0 and "No shared adventures recorded yet.\nChoose Original or Your tale to read your own history." or "No recorded adventures to tell yet.")
    reader.leaves = chapters
    local name = person.self and (person.name or "My") or (person.display or ShortName(person.name or "Companion"))
    reader.heading:SetText(edition == "ours" and ("Our story with " .. name) or (name .. "'s journal"))
    local running = {tale = "A LIFE IN CHAPTERS", ours = "ADVENTURES TOGETHER", fire = "BY THE FIRE"}
    reader.runningTitle:SetText(running[edition] or (person.self and "A PERSONAL CHRONICLE" or "ADVENTURES TOGETHER"))
    reader.status:SetText(reader.page.today:IsShown() and "Today \194\183 In progress" or "")
    reader.page.today:Hide()
    reader.mode:SetText(edition == "original" and ((A.JournalVoice() == "story" and "Story" or "Simple") .. " \194\183 "
        .. (A.JournalMode() == "all" and "Everything" or "Highlights")) or edition == "fire" and "Short telling" or "Full telling")
    local chapterCount = chapters[#chapters] and chapters[#chapters].chapterIndex or 0
    reader.chapterPrev:SetEnabled(leaf and leaf.chapterIndex > 1 or false)
    reader.chapterNext:SetEnabled(leaf and leaf.chapterIndex < chapterCount or false)
    reader.subjectButton.label:SetText(edition == "ours" and (reader.companionKey and ("With " .. name .. (#choices > 1 and "  >" or "")) or "No companion history")
        or ((edition == "fire" and "Episode " or "Chapter ") .. (leaf and leaf.chapterIndex or 0) .. " of " .. chapterCount))
    reader.subjectButton:SetEnabled(edition == "ours" and #choices > 1)
    reader.label:SetText(#chapters == 0 and "" or ("Page " .. reader.index .. " of " .. #chapters))
    reader.prev:SetEnabled(reader.index > 1); reader.next:SetEnabled(reader.index < #chapters)
    SaveReaderPlace()
end
function A.SetReaderEdition(edition)
    if not A.JournalReader then return end
    edition = A.JournalReader.Valid(edition)
    if A.db.readerEdition == edition then return end
    SaveReaderPlace()
    if A.CloseLoreNote then A.CloseLoreNote() end
    A.db.readerEdition = edition
    if reader then
        reader.index, reader.jumpDay, reader.jumpOffset, reader.pageCache = nil, nil, nil, nil
        if reader:IsShown() then DrawReader() end
    end
end
local function ReaderChapter(delta)
    if A.CloseLoreNote then A.CloseLoreNote() end
    local leaf = reader.leaves and reader.leaves[reader.index]
    if not leaf then return end
    local target = leaf.chapterIndex + delta
    for i, candidate in ipairs(reader.leaves) do
        if candidate.chapterIndex == target then reader.index = i; DrawReader(true); return end
    end
end
-- The art board (/cj artboard): candidate art for the book, as the game draws it,
-- each with its name and size, to choose from a screenshot.
local ARTBOARD = {
    {"Pages", {
        "spellbook-Page-Left-C60", "spellbook-Page-Right-C60", "spellbook-background-evergreen-left",
        "spellbook-background-evergreen-right", "spellbook-background-evergreen-header", "QuestBG-Parchment",
        "Book-bg", "parchmentpopup-background", "Interface\\QuestFrame\\QuestBookBG", "Interface\\Spellbook\\Spellbook-Page-1",
        "Interface\\Store\\receipt-parchment-middle",
    }},
    {"Ribbons and tabs", {
        "spellbook-background-evergreen-ribbon", "activities-ribbon", "Legacy-Challenge-Cards-Ribbon-Brown",
        "Legacy-Challenge-Left-Sub-Tab", "Legacy-Challenge-Left-Sub-Tab-selected", "common-sidetab", "common-sidetab-selected",
        "questlog-tab", "UI-Character-Info-StatTab", "UI-Character-Info-StatTab-Selected", "uiframe-activetab-left",
        "Interface\\SpellBook\\SpellBook-SkillLineTab", "Interface\\PaperDollInfoFrame\\UI-Character-ActiveTab",
    }},
    {"Ornaments", {
        "spellbook-corner-flipbook-evergreen", "spellbook-divider", "UI-Character-Info-ScrollLine", "Talents-small-divider-c60",
        "Interface\\QuestFrame\\UI-HorizontalBreak", "parchmentpopup-filigree", "UI-Character-Info-Title", "Legacy-Challenge-Cards",
        "spellbook-list-backplate", "Legacy-Tree-Frame-divider-Vertical",
    }},
}
local artboard
function A.BookArtboard()
    if artboard then artboard:SetShown(not artboard:IsShown()); return end
    local COLS, CELL_W, CELL_H = 9, 170, 128
    artboard = CreateFrame("Frame", "CompanionJournalArtboard", UIParent)
    artboard:SetFrameStrata("FULLSCREEN_DIALOG"); artboard:SetPoint("CENTER")
    artboard:EnableMouse(true); artboard:SetMovable(true); artboard:RegisterForDrag("LeftButton")
    artboard:SetScript("OnDragStart", artboard.StartMoving); artboard:SetScript("OnDragStop", artboard.StopMovingOrSizing)
    if UISpecialFrames then table.insert(UISpecialFrames, "CompanionJournalArtboard") end
    local back = artboard:CreateTexture(nil, "BACKGROUND")
    back:SetAllPoints(); back:SetColorTexture(0.42, 0.42, 0.42, 0.97)
    local close = CreateFrame("Button", nil, artboard, "UIPanelCloseButton")
    close:SetPoint("TOPRIGHT", -2, -2)
    local y = -8
    for _, group in ipairs(ARTBOARD) do
        local head = artboard:CreateFontString(nil, "ARTWORK", "GameFontNormalLarge")
        head:SetPoint("TOPLEFT", 10, y); head:SetText(group[1])
        y = y - 24
        for i, name in ipairs(group[2]) do
            local col, rowY = (i - 1) % COLS, y - math.floor((i - 1) / COLS) * CELL_H
            local cell = CreateFrame("Frame", nil, artboard)
            cell:SetSize(CELL_W - 8, CELL_H - 8); cell:SetPoint("TOPLEFT", 8 + col * CELL_W, rowY)
            local frame = cell:CreateTexture(nil, "BORDER")
            frame:SetPoint("TOPLEFT"); frame:SetPoint("BOTTOMRIGHT", 0, 30); frame:SetColorTexture(0.3, 0.3, 0.3, 1)
            local tex = cell:CreateTexture(nil, "ARTWORK")
            local info = not name:find("\\", 1, true) and C_Texture and C_Texture.GetAtlasInfo and C_Texture.GetAtlasInfo(name)
            local boxW, boxH = CELL_W - 12, CELL_H - 42
            local size
            if info then
                local scale = math.min(boxW / info.width, boxH / info.height, 2)
                tex:SetSize(math.max(1, info.width * scale), math.max(1, info.height * scale))
                tex:SetAtlas(name, false)
                size = info.width .. " x " .. info.height
            elseif name:find("\\", 1, true) then
                tex:SetSize(boxW, boxH); tex:SetTexture(name)
                size = "file"
            else
                size = "MISSING"
            end
            tex:SetPoint("CENTER", cell, "TOP", 0, -(CELL_H - 38) / 2)
            local label = cell:CreateFontString(nil, "ARTWORK", "GameFontHighlightSmall")
            label:SetPoint("BOTTOMLEFT", 0, 14); label:SetPoint("BOTTOMRIGHT", 0, 14); label:SetWordWrap(false)
            label:SetText(name:gsub("^Interface\\", ""))
            local sub = cell:CreateFontString(nil, "ARTWORK", "GameFontNormalSmall")
            sub:SetPoint("BOTTOMLEFT", 0, 2); sub:SetText(size)
            if size == "MISSING" then sub:SetTextColor(1, 0.3, 0.3) end
        end
        y = y - math.ceil(#group[2] / COLS) * CELL_H - 6
    end
    artboard:SetSize(COLS * CELL_W + 16, -y + 8)
    artboard:Show()
end

function A.BookReader(open)
    if not reader then
        reader = CreateFrame("Frame", "CompanionJournalReader", UIParent)
        reader:SetSize(660, 620); reader:SetPoint("CENTER")
        reader:SetFrameStrata("FULLSCREEN_DIALOG"); reader:EnableMouse(true); reader:SetToplevel(true)
        reader:SetClampedToScreen(true)
        if UISpecialFrames then table.insert(UISpecialFrames, "CompanionJournalReader") end
        -- The folio's header, chapter and footer share one sheet of paper.
        -- Their existing rows still reserve the same space for pagination.
        local ground = reader:CreateTexture(nil, "BACKGROUND")
        ground:SetAllPoints(); ground:SetAtlas("QuestBG-Parchment")
        reader.paper = ground
        reader.borderLines = {}
        for _, side in ipairs({"TOP", "BOTTOM", "LEFT", "RIGHT"}) do
            local edge = reader:CreateTexture(nil, "BORDER")
            if side == "TOP" or side == "BOTTOM" then
                edge:SetPoint(side .. "LEFT"); edge:SetPoint(side .. "RIGHT"); edge:SetHeight(1)
            else
                edge:SetPoint("TOP" .. side); edge:SetPoint("BOTTOM" .. side); edge:SetWidth(1)
            end
            edge:SetColorTexture(0.48, 0.36, 0.20, 0.85)
            reader.borderLines[#reader.borderLines + 1] = edge
        end
        local heading = reader:CreateFontString(nil, "OVERLAY", "GameFontNormal")
        heading:SetText("Reading view")
        heading:SetWordWrap(false); heading:SetWidth(480)
        heading:SetPoint("TOP", 0, -16); heading:SetHeight(18)
        heading:SetJustifyH("CENTER")
        heading:SetTextColor(unpack(INK)); heading:SetShadowOffset(0, 0)
        reader.heading = heading
        reader:SetMovable(true)
        local drag = CreateFrame("Frame", nil, reader)
        drag:SetPoint("TOPLEFT", 5, -3); drag:SetPoint("TOPRIGHT", -36, -3); drag:SetHeight(34)
        drag:EnableMouse(true); drag:RegisterForDrag("LeftButton")
        drag:SetScript("OnDragStart", function() reader:StartMoving() end)
        drag:SetScript("OnDragStop", function() reader:StopMovingOrSizing() end)
        reader.close = Toggle(reader, "x", 22, "Close reading view", "Return to the journal.", function() reader:Hide() end)
        reader.close:SetPoint("TOPRIGHT", -9, -12)
        reader.editions = {}
        for i, choice in ipairs(A.JournalReader and A.JournalReader.choices or {{"original", "Original"}}) do
            local key = choice[1]
            local button = Toggle(reader, choice[2], 96, choice[2], choice[3], function() A.SetReaderEdition(key) end)
            button:SetPoint("TOP", (i - 2.5) * 100, -46)
            reader.editions[key] = button
        end
        reader.subjectButton = Toggle(reader, "", 260, "Shared history", "In Our story, click to choose another companion with recorded adventures.", function()
            SaveReaderPlace()
            local at = 1
            for i, choice in ipairs(reader.companions or {}) do if choice.key == reader.companionKey then at = i end end
            local choice = reader.companions[at % #reader.companions + 1]
            reader.companionKey, reader.index, reader.pageCache = choice.key, nil, nil
            DrawReader()
        end)
        reader.subjectButton:SetPoint("TOP", 0, -74)
        reader.subjectButton.label:SetWidth(244); reader.subjectButton.label:SetWordWrap(false)
        reader.chapterPrev = Toggle(reader, "<", 26, "Previous chapter", nil, function() ReaderChapter(-1) end)
        reader.chapterPrev:SetPoint("RIGHT", reader.subjectButton, "LEFT", -6, 0)
        reader.chapterNext = Toggle(reader, ">", 26, "Next chapter", nil, function() ReaderChapter(1) end)
        reader.chapterNext:SetPoint("LEFT", reader.subjectButton, "RIGHT", 6, 0)
        reader:SetScript("OnHide", function()
            SaveReaderPlace()
            if A.CloseLoreNote then A.CloseLoreNote() end
            if reader.restoreBook and book then
                reader.restoreBook = nil
                book:Show(); A.RefreshBook()
            end
        end)
        -- Keep the measured chapter box, using the folio's full sheet behind it.
        reader.page = Page(reader, "single", true)
        reader.page.paper:Hide()
        if reader.page.GetRegions then
            for _, region in ipairs({reader.page:GetRegions()}) do
                if region.GetDrawLayer and region:GetDrawLayer() == "BACKGROUND" then region:Hide() end
            end
        end
        reader.page.owner = reader
        reader.page:SetPoint("TOPLEFT", 22, -104); reader.page:SetPoint("BOTTOMRIGHT", -16, 46)
        reader.page.box = {46, 54, 52, 34}; reader.page.pad = 98
        reader.page.ctx.reading = true
        reader.page.turn = function(delta) reader.index = (reader.index or 1) + delta; DrawReader(true) end
        reader.page.scroll:ClearAllPoints()
        reader.page.scroll:SetPoint("TOPLEFT", 46, -54); reader.page.scroll:SetPoint("BOTTOMRIGHT", -52, 34)
        reader.page.child:SetWidth(660 - 38 - 98)
        SlimScrollBar(reader.page.scroll)
        local runningTitle = reader.page:CreateFontString(nil, "ARTWORK", "GameFontNormalSmall")
        runningTitle:SetPoint("TOP", 0, -23); runningTitle:SetTextColor(unpack(INK_SOFT))
        runningTitle:SetShadowOffset(0, 0)
        reader.runningTitle = runningTitle
        -- Fine inset rules give the folio a finished edge without covering its
        -- parchment or competing with the chapter's own red ornaments.
        for _, side in ipairs({"LEFT", "RIGHT"}) do
            local rule = reader.page:CreateTexture(nil, "BORDER")
            local x = side == "LEFT" and 20 or -20
            rule:SetPoint("TOP" .. side, x, -20); rule:SetPoint("BOTTOM" .. side, x, 20)
            rule:SetWidth(1); rule:SetColorTexture(0.42, 0.24, 0.10, 0.22)
        end
        reader.status = reader:CreateFontString(nil, "ARTWORK", "GameFontHighlightSmall")
        reader.status:SetPoint("BOTTOMLEFT", 28, 23); reader.status:SetWidth(170); reader.status:SetJustifyH("LEFT")
        reader.status:SetTextColor(unpack(INK_SOFT)); reader.status:SetShadowOffset(0, 0)
        reader.mode = reader:CreateFontString(nil, "ARTWORK", "GameFontHighlightSmall")
        reader.mode:SetPoint("BOTTOMRIGHT", -24, 23); reader.mode:SetWidth(150); reader.mode:SetJustifyH("RIGHT")
        reader.mode:SetTextColor(unpack(INK_SOFT)); reader.mode:SetShadowOffset(0, 0)
        -- (the chapter arrows in the window's footer, as in the book)
        reader.label = reader:CreateFontString(nil, "ARTWORK", "GameFontHighlightSmall")
        reader.label:SetPoint("BOTTOM", 0, 22); reader.label:SetWidth(120); reader.label:SetJustifyH("CENTER")
        reader.label:SetTextColor(unpack(INK_SOFT)); reader.label:SetShadowOffset(0, 0)
        reader.prev = Toggle(reader, "<", 26, "Previous page", nil, function() reader.index = reader.index - 1; DrawReader(true) end)
        reader.prev:SetPoint("RIGHT", reader.label, "LEFT", -4, 0)
        reader.next = Toggle(reader, ">", 26, "Next page", nil, function() reader.index = reader.index + 1; DrawReader(true) end)
        reader.next:SetPoint("LEFT", reader.label, "RIGHT", 4, 0)
    end
    if open == false then reader:Hide(); return end
    reader.jumpDay = state.leaves and ChapterDay(state.leaves[state.index or 1])
    reader.jumpOffset = state.leaves and state.leaves[state.index or 1] and state.leaves[state.index or 1].offset
    reader.index = nil
    if ReaderEdition() ~= "original" then reader.jumpDay, reader.jumpOffset = nil, nil end
    reader.restoreBook = book and book:IsShown() or reader.restoreBook
    if A.CloseLoreNote then A.CloseLoreNote() end
    if book then book:Hide() end
    reader:Show(); reader:Raise()
    DrawReader()
end

-- A bookmark on the right edge of the book.
local function Bookmark(index)
    local mark = book.marks[index]
    if mark then return mark end
    mark = CreateFrame("Button", nil, book)
    mark:SetSize(34, 34)
    mark.base = mark:CreateTexture(nil, "BACKGROUND", nil, -2)
    mark.base:SetPoint("TOPLEFT", -1, 1); mark.base:SetPoint("BOTTOMRIGHT", 5, -1)
    mark.base:SetColorTexture(0.24, 0.16, 0.07, 1)
    mark.bg = mark:CreateTexture(nil, "BACKGROUND")
    mark.bg:SetPoint("TOPLEFT", -3, 3); mark.bg:SetPoint("BOTTOMRIGHT", 7, -3)
    mark.bg:SetTexture("Interface\\SpellBook\\SpellBook-SkillLineTab")
    mark.icon = mark:CreateTexture(nil, "ARTWORK")
    mark.icon:SetPoint("TOPLEFT", 3, -3); mark.icon:SetPoint("BOTTOMRIGHT", -3, 3)
    mark.chosen = mark:CreateTexture(nil, "OVERLAY")
    mark.chosen:SetAllPoints(); mark.chosen:SetColorTexture(1, 0.82, 0, 0.25)
    local hover = mark:CreateTexture(nil, "HIGHLIGHT")
    hover:SetAllPoints(); hover:SetColorTexture(1, 1, 1, 0.15)
    mark:SetScript("OnClick", function(self) if self.action then self.action() end end)
    mark:SetScript("OnEnter", function(self)
        GameTooltip:SetOwner(self, "ANCHOR_RIGHT")
        GameTooltip:SetText(self.title or "", 1, 0.82, 0)
        if self.tip then GameTooltip:AddLine(self.tip, 0.9, 0.9, 0.9, true) end
        GameTooltip:Show()
    end)
    mark:SetScript("OnLeave", function() GameTooltip:Hide() end)
    book.marks[index] = mark
    return mark
end
-- Variant C: labelled ribbons on both sides, the book's tools on one, the
-- journals (yours, then your companions) on the other (Dredge's book, kind of).
local function LabelMark(index)
    book.labels = book.labels or {}
    local mark = book.labels[index]
    if mark then return mark end
    mark = CreateFrame("Button", nil, book)
    mark:SetSize(118, 24)
    mark.fill = mark:CreateTexture(nil, "BACKGROUND")
    mark.fill:SetAllPoints()
    mark.edge = mark:CreateTexture(nil, "BORDER")
    mark.edge:SetPoint("TOPLEFT"); mark.edge:SetPoint("BOTTOMLEFT"); mark.edge:SetWidth(3)
    local hover = mark:CreateTexture(nil, "HIGHLIGHT")
    hover:SetAllPoints(); hover:SetColorTexture(1, 1, 1, 0.12)
    mark.text = mark:CreateFontString(nil, "ARTWORK", "GameFontHighlight")
    mark.text:SetPoint("LEFT", 10, 0); mark.text:SetPoint("RIGHT", -8, 0); mark.text:SetWordWrap(false)
    -- (cloth for the journals, the window's leather plate for the tools, an icon at the tip)
    mark.cloth = mark:CreateTexture(nil, "BACKGROUND", nil, 1)
    mark.cloth:SetAllPoints(); mark.cloth:Hide()
    mark.body = mark:CreateTexture(nil, "BACKGROUND", nil, 1); mark.body:Hide()
    mark.tail = mark:CreateTexture(nil, "BACKGROUND", nil, 1); mark.tail:Hide()
    mark.icon = mark:CreateTexture(nil, "ARTWORK")
    mark.icon:SetSize(16, 16); mark.icon:Hide()
    mark:SetScript("OnClick", function(self) if self.action then self.action() end end)
    mark:SetScript("OnEnter", function(self)
        if not self.tip then return end
        GameTooltip:SetOwner(self, "ANCHOR_TOP")
        GameTooltip:SetText(self.title or "", 1, 0.82, 0)
        GameTooltip:AddLine(self.tip, 0.9, 0.9, 0.9, true)
        GameTooltip:Show()
    end)
    mark:SetScript("OnLeave", function() GameTooltip:Hide() end)
    book.labels[index] = mark
    return mark
end
local function FillLabelledMarks()
    for _, mark in ipairs(book.marks) do mark:Hide() end
    local toolsLeft = A.BookVariant("toolsSide") == "left"
    local me = A.Me and A.Me()
    local mine = me and A.SelfPerson and A.SelfPerson(me)
    local journals = {}
    if mine then
        journals[#journals + 1] = {title = "My journal", color = {0.20, 0.32, 0.16}, cloth = true,
            icon = "Interface\\Icons\\INV_Misc_Book_09",
            chosen = state.view == "journal" and state.key == "self:" .. me, action = function() state.view = "journal"; A.OpenBook("self:" .. me) end}
    end
    local listed = {}
    local function AddPerson(key)
        local person = A.People[key]
        if not person or person.npc or listed[key] then return end
        listed[key] = true
        local r, g, b = ClassColor(person.class)
        journals[#journals + 1] = {title = person.display or ShortName(person.name or key), color = {r * 0.55, g * 0.55, b * 0.55},
            cloth = true, class = person.class,
            chosen = state.view == "journal" and state.key == key, action = function() state.view = "journal"; A.OpenBook(key) end}
    end
    for _, key in ipairs(Pins()) do AddPerson(key) end
    -- Side bookmarks reflect explicit pins, just like the icon variants.
    -- All other companions remain accessible through the Companions page.
    local tools = {
        {title = "Companions", tip = "Your people, their stories and settings.", color = {0.24, 0.16, 0.07}, chosen = state.view == "people",
            action = function() A.OpenBookPeople(state.view == "journal" and state.key and A.People[state.key] and not A.People[state.key].npc and state.key or nil) end},
        {title = "Add someone", tip = "Your target, a groupmate, or a name.", color = {0.24, 0.16, 0.07},
            action = function()
                -- (the same as the contents page's add button: a smart add, or the three steps)
                local click = book.addBar.main:GetScript("OnClick")
                if click then click(book.addBar.main) end
            end},
        {title = "Reading view", tip = "Compare four ways to read your adventures.", color = {0.24, 0.16, 0.07}, action = function() A.BookReader(true) end},
        {title = "NPCs", tip = "The NPCs you noted.", color = {0.18, 0.15, 0.12}, chosen = state.view == "npcs", gapBefore = true,
            action = function() state.view = "npcs"; A.RefreshBook() end},
        {title = "Settings", tip = "Reading, testing variants, and all settings.", color = {0.18, 0.15, 0.12}, chosen = state.view == "settings",
            action = function() state.view = "settings"; A.RefreshBook() end},
    }
    local count = 0
    local height = book:GetHeight()
    -- (tucked 4 px under the window's metal border, which sits inside the frame's edge)
    local rim = book.legacyBorder or book
    local function Column(list, left)
        local y = -88
        for _, item in ipairs(list) do
            if item.gapBefore then y = y - 10 end
            if y - 24 < -(height - 30) then break end
            count = count + 1
            local mark = LabelMark(count)
            mark.title, mark.tip, mark.action = item.title, item.tip, item.action
            mark.text:SetText(item.title)
            mark.fill:SetColorTexture(item.color[1], item.color[2], item.color[3], 1)
            mark.edge:SetColorTexture(1, 0.82, 0, item.chosen and 1 or 0)
            mark.text:SetTextColor(item.chosen and 1 or 0.92, item.chosen and 0.82 or 0.88, item.chosen and 0 or 0.78)
            -- (the open one is longer: it sticks out further but stays tucked in the book)
            mark:SetWidth(item.chosen and 128 or 118)
            mark:SetHeight(24)
            mark.cloth:Hide(); mark.icon:Hide(); mark.fill:Show(); mark.body:Hide(); mark.tail:Hide()
            if mark.plate then mark.plate:SetShown(false) end
            mark.text:ClearAllPoints(); mark.text:SetPoint("LEFT", 10, 0); mark.text:SetPoint("RIGHT", -8, 0)
            mark:SetHeight(28)
            mark:SetWidth(item.chosen and 140 or 124)
            mark.edge:SetColorTexture(0, 0, 0, 0)
            -- (journals: red cloth; tools: the same cloth, undyed; the open one at full colour)
            local shade = item.chosen and 1 or 0.82
            local tint = item.cloth and {shade, shade, shade} or {shade * 0.95, shade * 0.85, shade * 0.7}
            if RibbonArt(mark, left, tint, not item.cloth) then mark.fill:Hide() end
            -- (the icon at the outer tip: the class, or the book)
            local iconShown = false
            if item.class and A.SetPersonClassIcon then A.SetPersonClassIcon(mark.icon, item.class); iconShown = mark.icon:IsShown()
            elseif item.icon then mark.icon:SetTexture(item.icon); iconShown = true end
            mark.icon:SetShown(iconShown)
            mark.icon:ClearAllPoints(); mark.text:ClearAllPoints()
            if left then
                mark.icon:SetPoint("LEFT", 10, 0)
                mark.text:SetPoint("LEFT", iconShown and 30 or 10, 0); mark.text:SetPoint("RIGHT", -14, 0)
            else
                mark.icon:SetPoint("RIGHT", -10, 0)
                mark.text:SetPoint("LEFT", 14, 0); mark.text:SetPoint("RIGHT", iconShown and -30 or -10, 0)
            end
            mark:ClearAllPoints()
            mark.edge:ClearAllPoints()
            if left then
                mark:SetPoint("TOPRIGHT", rim, "TOPLEFT", 4, y + (rim ~= book and 16 or 0))
                -- (the gold mark at the outer tip, so nothing seems to part it from the book)
                mark.edge:SetPoint("TOPLEFT"); mark.edge:SetPoint("BOTTOMLEFT"); mark.edge:SetWidth(3)
                mark.text:SetJustifyH("RIGHT")
            else
                mark:SetPoint("TOPLEFT", rim, "TOPRIGHT", -4, y + (rim ~= book and 16 or 0))
                mark.edge:SetPoint("TOPRIGHT"); mark.edge:SetPoint("BOTTOMRIGHT"); mark.edge:SetWidth(3)
                mark.text:SetJustifyH("LEFT")
            end
            -- (below the border's level, so the metal covers the tucked end)
            mark:SetFrameLevel(book:GetFrameLevel())
            mark:Show()
            y = y - 32
        end
    end
    Column(tools, toolsLeft)
    Column(journals, not toolsLeft)
    for n = count + 1, #book.labels do book.labels[n]:Hide() end
end
local function FillBookmarks()
    if A.BookVariant("marks") == "c" then FillLabelledMarks(); return end
    for _, mark in ipairs(book.labels or {}) do mark:Hide() end
    local items = {}
    local me = A.Me and A.Me()
    local mine = me and A.SelfPerson and A.SelfPerson(me)
    if mine then
        items[#items + 1] = {title = "My journal", class = mine.class, icon = "Interface\\Icons\\INV_Misc_Book_09",
            chosen = state.view == "journal" and state.key == "self:" .. me, action = function() state.view = "journal"; A.OpenBook("self:" .. me) end}
    end
    -- (variant A: the list's sections too; a ribbon opens the contents there)
    if A.BookVariant("marks") == "a" then
        local SECTION_ICONS = {companion = "Interface\\Icons\\Spell_Holy_PrayerOfSpirit", acquaintance = "Interface\\Icons\\INV_Letter_15",
            campfire = "Interface\\Icons\\Spell_Fire_Fire", rival = "Interface\\Icons\\INV_Sword_04"}
        for _, circle in ipairs(CIRCLE_ORDER) do
            local which = circle[1]
            items[#items + 1] = {title = circle[2], tip = "Open the contents at " .. circle[2] .. ".", icon = SECTION_ICONS[which],
                chosen = false, gapBefore = which == "companion",
                action = function()
                    state.view = "journal"
                    for _, other in ipairs(CIRCLE_ORDER) do state.collapsed[other[1]] = other[1] ~= which end
                    if A.db.bookSpread == "two" then A.db.bookSpread = "one" end
                    A.RefreshBook()
                end}
        end
    end
    local firstPin = true
    for _, key in ipairs(Pins()) do
        local person = A.People[key]
        items[#items + 1] = {title = person.display or ShortName(person.name or key), class = person.class, gapBefore = firstPin,
            chosen = state.view == "journal" and state.key == key, action = function() state.view = "journal"; A.OpenBook(key) end}
        firstPin = false
    end
    local bottom = {
        {title = "Companions", tip = "Your people, their stories and settings.", icon = "Interface\\Icons\\Spell_Holy_PrayerOfSpirit", chosen = state.view == "people", utility = true,
            action = function() A.OpenBookPeople(state.view == "journal" and state.key and A.People[state.key] and not A.People[state.key].npc and state.key or nil) end},
        {title = "NPCs", tip = "The NPCs you noted.", icon = "Interface\\Icons\\INV_Misc_Note_02", chosen = state.view == "npcs", utility = true,
            action = function() state.view = "npcs"; A.RefreshBook() end},
        {title = "Settings", tip = "Reading, testing variants, and all settings.", icon = "Interface\\Icons\\Trade_Engineering",
            chosen = state.view == "settings", utility = true, action = function() state.view = "settings"; A.RefreshBook() end},
    }
    local count = 0
    local function Place(item, y)
        count = count + 1
        local mark = Bookmark(count)
        mark:ClearAllPoints(); mark:SetPoint("TOPLEFT", book, "TOPRIGHT", -2, y)
        mark.title, mark.tip, mark.action = item.title, item.tip, item.action
        if item.class and A.SetPersonClassIcon and item.title ~= "My journal" then
            A.SetPersonClassIcon(mark.icon, item.class)
            if not mark.icon:IsShown() then mark.icon:SetTexture(item.icon or "Interface\\Icons\\INV_Misc_QuestionMark"); mark.icon:Show() end
        else
            mark.icon:SetTexture(item.icon); mark.icon:Show()
        end
        mark.chosen:SetShown(item.chosen and true or false)
        -- (NPCs and Settings: smaller and darker than the journals' ribbons)
        mark:SetSize(item.utility and 28 or 34, item.utility and 28 or 34)
        mark.base:SetColorTexture(item.utility and 0.14 or 0.24, item.utility and 0.12 or 0.16, item.utility and 0.10 or 0.07, 1)
        mark:Show()
    end
    -- (from the top, with a little gap between groups; what does not fit above the bottom ones waits)
    local height = book:GetHeight()
    local y, lowest = -60, -(height - 70) + 42 * #bottom
    for _, item in ipairs(items) do
        if item.gapBefore then y = y - 8 end
        if y - 36 < lowest then break end
        Place(item, y)
        y = y - 40
    end
    for n, item in ipairs(bottom) do Place(item, -(height - 70) + (#bottom - n) * 42) end
    for n = count + 1, #book.marks do book.marks[n]:Hide() end
end

-- The Settings view: the menu on the left, a section on the right.
local function Section(name, build)
    local section = book.sections[name]
    local width = math.floor(book.panel.child:GetWidth() or 340)
    if section and section.layoutWidth == width then return section end
    if section then section:Hide() end
    section = CreateFrame("Frame", nil, book.panel.child)
    section:SetPoint("TOPLEFT"); section:SetSize(10, 10)
    section.updates = {}
    section.layoutWidth = width
    -- (build returns where it ended: the page scrolls to that height)
    section.height = -(build(section) or -400) + 20
    book.sections[name] = section
    return section
end
-- The height of wrapped text. GetStringHeight can answer one line for a string on a
-- page that has not been laid out yet, so count the lines from its full width too.
local function TextHeight(fontString, width)
    local measured = fontString:GetStringHeight() or 0
    local _, size = fontString:GetFont()
    local line = (size or 12) + 2
    local full = fontString.GetUnboundedStringWidth and fontString:GetUnboundedStringWidth() or fontString:GetStringWidth() or 0
    local lines = math.max(1, math.ceil(full / math.max(1, (width or fontString:GetWidth() or 300) - 4)))
    return math.ceil(math.max(measured, lines * line))
end
A.BookTextHeight = TextHeight
local function SectionText(section, text, y, font, color, width)
    local label = section:CreateFontString(nil, "ARTWORK", font or "GameFontNormal")
    label:SetPoint("TOPLEFT", 4, y); label:SetJustifyH("LEFT")
    label:SetTextColor(unpack(color or INK))
    if width then label:SetWidth(width); label:SetWordWrap(true) end
    label:SetText(text)
    return label
end
-- A label and a row of switches: choices {{value, label}, ...}.
local function SectionChoice(section, y, label, choices, get, set, note)
    local width = math.max(200, (book.panel.child:GetWidth() or 340) - 8)
    local onOff = #choices == 2 and choices[1][1] == true and choices[2][1] == false
    if onOff then
        -- (an On/Off pair is one checkbox)
        local check = CreateFrame("CheckButton", nil, section, "UICheckButtonTemplate")
        check:SetSize(24, 24); check:SetPoint("TOPLEFT", 0, y + 3)
        check:SetScript("OnClick", function(self) set(self:GetChecked() and true or false); A.RefreshBook() end)
        local text = SectionText(section, label, y - 2, Font("QuestFontNormalSmall", "GameFontNormal"), INK)
        text:ClearAllPoints(); text:SetPoint("LEFT", check, "RIGHT", 4, 0)
        text:SetWidth(width - 36); text:SetWordWrap(true)
        if text.SetShadowOffset then text:SetShadowOffset(0, 0) end
        section.updates[#section.updates + 1] = function() check:SetChecked(get() == true) end
        y = y - math.max(26, TextHeight(text, width - 36) + 8)
        if note then
            local noteText = SectionText(section, note, y, "GameFontHighlightSmall", INK_SOFT, width - 28)
            noteText:ClearAllPoints(); noteText:SetPoint("TOPLEFT", 28, y)
            y = y - TextHeight(noteText, width - 28)
        end
        return y - 12
    end
    local head = SectionText(section, label, y, Font("QuestFont_Shadow_Small", "GameFontNormal"), CHAPTER)
    if head.SetShadowOffset then head:SetShadowOffset(0, 0) end
    local x, buttons = 4, {}
    for _, choice in ipairs(choices) do
        local button, w
        button = PaperChoice(section, choice[2], function() set(choice[1]); A.RefreshBook() end)
        w = button.width
        -- (a row that would run off the page wraps)
        if x + w > width and x > 4 then x = 4; y = y - 24 end
        button:SetPoint("TOPLEFT", x, y - 20)
        x = x + w + 4
        buttons[#buttons + 1] = {button = button, value = choice[1]}
    end
    section.updates[#section.updates + 1] = function()
        local current = get()
        for _, item in ipairs(buttons) do SetChosen(item.button, item.value == current) end
    end
    y = y - 44
    if note then
        local noteText = SectionText(section, note, y, "GameFontHighlightSmall", INK_SOFT, width)
        y = y - TextHeight(noteText, width) - 2
    end
    return y - 10
end
local function FillSettings()
    local db = A.db
    local sections = {
        {kind = "row", label = "Reading", sub = "What the pages show", icon = "Interface\\Icons\\INV_Misc_Book_11",
            selected = state.settings == "reading", action = function() state.settings = "reading"; A.RefreshBook() end},
        {kind = "row", label = "Testing", sub = "Choose the variants to try", icon = "Interface\\Icons\\INV_Misc_Gear_01",
            selected = state.settings == "testing", action = function() state.settings = "testing"; A.RefreshBook() end},
        {kind = "row", label = "People in the world", sub = "Nameplates, icons and recognition", icon = "Interface\\Icons\\INV_Misc_GroupNeedMore",
            selected = state.settings == "world", action = function() state.settings = "world"; A.RefreshBook() end},
        {kind = "row", label = "Adding people", sub = "Groups, campfires and blocked names", icon = "Interface\\Icons\\INV_Misc_GroupNeedMore",
            selected = state.settings == "adding", action = function() state.settings = "adding"; A.RefreshBook() end},
        {kind = "row", label = "Recording", sub = "Adventures and crossing paths", icon = "Interface\\Icons\\INV_Misc_Book_11",
            selected = state.settings == "recording", action = function() state.settings = "recording"; A.RefreshBook() end},
    }
    FillList(sections)
    for name, section in pairs(book.sections) do section:SetShown(name == state.settings) end
    -- (a new section starts at its top)
    if book.panel.lastSection ~= state.settings then
        book.panel.lastSection = state.settings
        if book.panel.scroll.SetVerticalScroll then book.panel.scroll:SetVerticalScroll(0) end
    end
    local section
    if state.settings == "reading" then
        section = Section("reading", function(sec)
            local y = -4
            y = SectionChoice(sec, y, "Show", {{"all", "Everything"}, {"highlights", "Highlights"}},
                function() return A.JournalMode() end, function(v) db.journalMode = v end)
            y = SectionChoice(sec, y, "Told", {{"simple", "Simple"}, {"story", "Story"}},
                function() return A.JournalVoice() end, function(v) db.journalVoice = v end)
            y = SectionChoice(sec, y, "Page style", {{"a", "A"}, {"b", "B"}, {"c", "C"}, {"d", "D"}, {"e", "E"}},
                function() return A.JournalStyle() end, function(v) db.journalStyle = v end,
                "A: today, B: chronicle, C: margins, D: diary, E: ledger.")
            y = SectionChoice(sec, y, "Pages", {{"one", "Single page"}, {"two", "Two-page spread"}},
                function() return db.bookSpread or "one" end, function(v) db.bookSpread = v end)
            y = SectionChoice(sec, y, "Book size", {{"a", "A"}, {"b", "B"}, {"c", "C"}},
                function() return db.bookSize end, function(v) db.bookSize = v; book:SetSize(SIZES[v][1], SIZES[v][2]) end,
                "Or drag the bottom-right corner for your own size.")
            y = SectionChoice(sec, y, "Today, so far", {{true, "On"}, {false, "Off"}},
                function() return db.bookToday ~= false end, function(v) db.bookToday = v end,
                "Today's chapter of your own journal, told as it stands, marked as still being written.")
            y = SectionChoice(sec, y, "Names open their journal", {{true, "On"}, {false, "Off"}},
                function() return db.bookLinks ~= false end, function(v) db.bookLinks = v end)
            y = SectionChoice(sec, y, "Timeline", {{true, "On"}, {false, "Off"}},
                function() return db.bookTimeline ~= false end, function(v) db.bookTimeline = v end,
                "Under a companion's page: their chapters, with the deaths, dungeons and levels marked.")
            y = SectionChoice(sec, y, "New chapter notice", {{true, "On"}, {false, "Off"}},
                function() return db.bookNotice == true end, function(v) db.bookNotice = v end,
                "When you rest at an inn or in a city and today's chapter is new.")
            return SectionChoice(sec, y, "Minimap button", {{true, "On"}, {false, "Off"}},
                function() return db.bookMinimap ~= false end, function(v) db.bookMinimap = v; if A.UpdateBookMinimap then A.UpdateBookMinimap() end end,
                "Opens the book. A red dot when something is unread.")
        end)
    elseif state.settings == "testing" then
        section = Section("testing", function(sec)
            local y = -4
            SectionText(sec, "Variants to try in game. Each stays until you choose another.", y, "GameFontHighlightSmall", INK_SOFT, book.panel.child:GetWidth() - 8)
            y = y - 26
            for _, variant in ipairs(VARIANTS) do
                local note = variant.stage > BUILT and ("Coming with stage " .. variant.stage .. ".") or nil
                y = SectionChoice(sec, y, variant.label, variant.choices,
                    function() return A.BookVariant(variant.key) end, function(v) SetVariant(variant.key, v) end, note)
            end
            return y
        end)
    else
        section = Section(state.settings, function(sec)
            return A.BuildBookWorldSettings(sec, state.settings, {Choice = SectionChoice, Button = PaperChoice})
        end)
    end
    section:Show()
    for _, update in ipairs(section.updates) do update() end
    book.panel.child:SetHeight(section.height or 500)
end
-- The NPCs view: your noted NPCs on the left, the chosen one's card on the right.
local function FillNPCs()
    for _, section in pairs(book.sections) do section:Hide() end
    if not book.npcManager then
        book.npcManager = A.CreateBookManager(book, {npcOnly = true})
        if state.npc then book.npcManager:Select(state.npc) end
    end
    book.npcManager:Refresh()
    state.npc = book.npcManager.selected
end

-- Draw the book.
function A.RefreshBook(toEnd, reusePages)
    if book and book.notePopup then book.notePopup:Hide() end
    if not book or not book:IsShown() then
        if not reusePages and reader and reader:IsShown() then DrawReader() end
        return
    end
    if not reusePages and reader and reader:IsShown() then DrawReader() end
    local db = A.db
    LayoutPages()
    if book.heading then book.heading:SetText("Companion Journal") end
    if book.manager and state.view ~= "people" then book.manager:Hide() end
    if book.npcManager and state.view ~= "npcs" then book.npcManager:Hide() end
    book.contents.scroll:Show()
    book.panel.scroll:Show()
    book.name:SetShown(state.view ~= "people" and state.view ~= "npcs"); book.summary:SetShown(state.view ~= "people" and state.view ~= "npcs")
    if book.sectionHeading then
        book.sectionHeading:SetShown(state.view == "settings")
        book.sectionHeading:ClearAllPoints(); book.sectionHeading:SetPoint("TOPLEFT", book.right, "TOPLEFT", 34, 34)
        book.sectionHeading:SetWidth(book.right:GetWidth() - 68)
        local titles = {reading = "Reading", testing = "Try different styles", world = "People in the world", adding = "Adding people", recording = "Recording"}
        book.sectionHeading:SetText(titles[state.settings] or "Settings")
    end
    for key, button in pairs(book.sizeButtons) do SetChosen(button, db.bookSize == key) end
    book.readView:SetShown(A.BookVariant("marks") ~= "c")
    FillBookmarks()
    local other = state.view ~= "journal"
    book.panel:SetShown(other)
    book.rightPage:SetShown(not other)
    book.footer:SetShown(not other)
    book.input:SetShown(not other); book.write:SetShown(not other); book.retell:SetShown(not other)
    if book.noteDate then book.noteDate:SetShown(not other) end
    if other then
        ContentsPortrait(nil)
        if A.CloseLoreNote then A.CloseLoreNote() end
        book.cardHost:Hide(); book.quill:Hide(); book.flip:Hide(); book.addBar:Hide(); book.timeline:Hide()
        for key, tab in pairs(book.tabs) do if key ~= "last" then tab:Hide() end end
        -- (Settings and NPCs: the contents page lists their sections)
        book.contents:Show(); book.leftPage:Hide()
        book.classIcon:Hide(); book.pin:Hide(); DrawPinRibbon(false)
        -- (the journal's title look stays with the journal)
        if book.headRule then book.headRule:Hide() end
        book.name:SetFontObject("GameFontNormalLarge"); book.name:SetJustifyH("LEFT"); book.name:SetHeight(22)
        book.summary:SetFontObject("GameFontHighlightSmall"); book.summary:SetJustifyH("LEFT")
        book.name:ClearAllPoints(); book.name:SetPoint("TOPLEFT", 43, -54)
        book.name:SetWidth(book:GetWidth() - 52)
        book.name:SetText(state.view == "settings" and "Settings" or state.view == "people" and "Companions" or "NPCs"); book.name:SetTextColor(unpack(INK))
        book.summary:SetText("")
        if state.view == "people" then
            for _, section in pairs(book.sections) do section:Hide() end
            if not book.manager then book.manager = A.CreateBookManager(book, {IsPinned = IsPinned, TogglePin = TogglePin}) end
            book.manager:Refresh()
        elseif state.view == "settings" then FillSettings() else FillNPCs() end
        return
    end
    book.addBar:Show(); book.addBar:Update()

    local person = Shown()
    if not person then
        UpdateWriteDate(nil)
        if book.contents:IsShown() then FillContents() end
        book.name:SetText(""); book.summary:SetText(""); book.classIcon:Hide()
        if book.headRule then book.headRule:Hide() end
        DrawPinRibbon(false)
        ClearPage(book.rightPage); book.rightPage.empty:SetText("Choose a journal from the contents."); book.rightPage.empty:Show()
        book.chapterLabel:SetText("")
        PlaceCard(nil)
        return
    end
    book.name:SetText(person.self and (person.name or "My journal") or (person.display or ShortName(person.name or state.key)))
    book.name:SetTextColor(unpack(CHAPTER))
    A.SetPersonClassIcon(book.classIcon, person.class)
    local nameLeft = book.classIcon:IsShown() and 73 or 43
    book.name:ClearAllPoints(); book.name:SetPoint("TOPLEFT", nameLeft, -52)
    -- Reserve room for Pin and Edit even with a long custom display name.
    book.name:SetWidth(math.max(100, book.left:GetWidth() + 13 - nameLeft - 130))
    book.name:SetWidth(math.min(book.name:GetWidth(), math.ceil(book.name:GetStringWidth() or 100) + 6))
    book.summary:SetWidth(book.left:GetWidth() + 13 - nameLeft - 28)
    book.summary:SetText(A.PersonSummary(person))
    if state.owner then book.summary:SetText(A.PersonSummary(person) .. "   |cffbbaa88Kept by " .. A.CharacterName(state.owner) .. " (read only)|r") end
    -- (a companion can be pinned to the edge)
    local pinnable = not person.self and not person.readOnly and A.People[state.key] ~= nil
    book.pin:SetShown(pinnable)
    if pinnable then
        book.pin:ClearAllPoints(); book.pin:SetPoint("LEFT", book.name, "RIGHT", 10, 0)
        book.pin.label:SetText(IsPinned(state.key) and "Unpin" or "Pin")
        SetChosen(book.pin, IsPinned(state.key))
        book.quill:ClearAllPoints(); book.quill:SetPoint("LEFT", book.pin, "RIGHT", 4, 0)
        book.flip:ClearAllPoints(); book.flip:SetPoint("LEFT", book.pin, "RIGHT", 4, 0)
        -- (how long you have known them: under the name)
        local met = A.DescribeMet and A.DescribeMet(person)
        if met then book.summary:SetText(A.PersonSummary(person) .. "   |cff8a7a62\194\183|r   " .. met) end
    end
    if book.headRule then book.headRule:Hide() end
    -- (no header over the pages. The title bar names the journal, and the
    -- journal's first page carries its title; a narrow band keeps Pin and the tabs.)
    book.classIcon:Hide(); book.name:Hide(); book.summary:Hide()
    if book.heading then book.heading:SetText(JournalTitle(person) .. "'s journal") end
    book.pin:Hide()
    DrawPinRibbon(pinnable)
    PlaceCard(person)
    local rival = A.PersonCircle and not person.self and A.PersonCircle(person) == "rival"
    local atlas = rival and (person.faction == "Horde" and "QuestBG-Horde" or person.faction == "Alliance" and "QuestBG-Alliance") or "QuestBG-Parchment"
    if book.corner then book.corner:SetShown(not rival); book.corner.art:SetShown(not rival) end
    if not rival then
        -- (the spellbook's pages; a rival keeps their faction's paper)
        SetBookPage(book.rightPage.paper, "right"); SetBookPage(book.leftPage.paper, "left")
    else
        book.rightPage.paper:SetTexCoord(0, 1, 0, 1); book.leftPage.paper:SetTexCoord(0, 1, 0, 1)
        book.rightPage.paper:SetAtlas(atlas); book.leftPage.paper:SetAtlas(atlas)
    end
    book.retell:SetShown(A.JournalVoice() == "story" and not person.readOnly)
    book.input:SetShown(not person.readOnly); book.write:SetShown(not person.readOnly)

    local chapters, styleKey, styleMode, Story
    if reusePages and state.pageCache then
        local cache = state.pageCache
        chapters, styleKey, styleMode, Story = cache.leaves, cache.style, cache.mode, cache.story
    else
        chapters, styleKey, styleMode, Story = Chapters(person)
        local portraitWhere = A.BookVariant("portraitWhere")
        local titleInfo = TitleInfo(person)
        chapters = PageChapters(book.rightPage, person, chapters, styleKey, styleMode, Story, function(page, chapter, index)
            local facing = portraitWhere == "b" and db.bookSpread == "two"
            local info = not facing and PortraitFor(person, chapter, index) or nil
            PreparePage(page, info, portraitWhere, nil, index == 1 and titleInfo or nil)
        end)
        state.pageCache = {leaves = chapters, style = styleKey, mode = styleMode, story = Story}
    end
    state.leaves = chapters
    book.leaves = chapters
    local count = #chapters
    local spread = db.bookSpread == "two"
    if toEnd or not state.index or state.index > count then state.index = count end
    if spread and state.index > 1 and A.BookVariant("portraitWhere") ~= "b" then
        -- (a spread shows an odd chapter on the left, the next on the right)
        if state.index % 2 == 0 then state.index = state.index - 1 end
    end
    if count == 0 then state.index = 0 end
    for _, page in ipairs({book.leftPage, book.rightPage}) do
        page.empty:SetText("No adventures recorded yet.\n\nWrite the first line below.")
    end
    -- (a name clicked in another journal: the same day here, or the next)
    if state.jumpDay then
        for i, chapter in ipairs(chapters) do
            local day = ChapterDay(chapter)
            if day and day >= state.jumpDay then state.index = i; break end
        end
        state.jumpDay = nil
        if spread and A.BookVariant("portraitWhere") ~= "b" and state.index % 2 == 0 then state.index = state.index - 1 end
    end
    -- (the first unread chapter, when the book opened on it)
    if state.jumpUnread then
        state.jumpUnread = nil
        local unread = {}
        for _, day in ipairs(UnreadDays(state.key)) do unread[day] = true end
        for i, chapter in ipairs(chapters) do
            local day = ChapterDay(chapter)
            if day and unread[day] then state.index = i; break end
        end
        if spread and A.BookVariant("portraitWhere") ~= "b" and state.index % 2 == 0 then state.index = state.index - 1 end
    end
    local unreadDays = not state.owner and UnreadDays(state.key) or {}
    local unreadSet = {}
    for _, day in ipairs(unreadDays) do unreadSet[day] = true end
    local function PageRibbon(page, chapter)
        Ribbon(page, "page", -26, 0)
        local day = ChapterDay(chapter)
        local how
        if day and unreadSet[day] then
            local variant = A.BookVariant("ribbon")
            if variant == "a" then how = "ribbon"
            elseif variant == "b" then how = day == unreadDays[1] and "ribbon" or "mark"
            else how = day == unreadDays[#unreadDays] and "ribbon" or nil end
        end
        ShowRibbon(page, how)
    end
    local where, frameStyle = A.BookVariant("portraitWhere"), A.BookVariant("portraitFrame")
    -- Some spreads reserve a whole facing leaf for a portrait. Keep their
    -- actual start positions so turning back visits exactly the previous view.
    local starts, nextStart = {}, 1
    while nextStart <= count do
        starts[#starts + 1] = nextStart
        local leaf = chapters[nextStart]
        local portrait = spread and where == "b" and PortraitFor(person, leaf, leaf.chapterIndex or nextStart)
        local nextLeaf = chapters[nextStart + 1]
        -- Leave an upcoming portrait chapter for its own facing spread;
        -- its text was measured without room for an inline plate.
        local nextPortrait = spread and where == "b" and PortraitFor(person, nextLeaf, nextLeaf and nextLeaf.chapterIndex or nextStart + 1)
        nextStart = nextStart + (spread and not portrait and not nextPortrait and 2 or 1)
    end
    state.displayStarts = starts
    for i = #starts, 1, -1 do if starts[i] <= state.index then state.index = starts[i]; break end end
    if book.contents:IsShown() then
        local leaf = chapters[state.index]
        FillContents(where == "d" and PortraitFor(person, leaf, leaf and leaf.chapterIndex or state.index) or nil)
    end
    local titleInfo = TitleInfo(person)
    -- (the title goes on the journal's very first leaf)
    local function TitleOf(leaf) return leaf and leaf.chapterIndex == 1 and (leaf.part or 1) == 1 and titleInfo or nil end
    local function Portraited(page, chapter, index)
        local info = PortraitFor(person, chapter, chapter and chapter.chapterIndex or index)
        local frame = PreparePage(page, info, where, chapter, TitleOf(chapter))
        return frame, info
    end
    local current = chapters[state.index]
    local facing = spread and where == "b" and PortraitFor(person, current, current and current.chapterIndex or state.index)
    local nextLeaf = chapters[state.index + 1]
    local single = spread and where == "b" and not facing
        and PortraitFor(person, nextLeaf, nextLeaf and nextLeaf.chapterIndex or state.index + 1)
    state.spreadStep = (facing or single) and 1 or 2
    if facing then
        -- (the facing page: the portrait alone on the left, its chapter on the right)
        PreparePage(book.leftPage, nil, where)
        ClearPage(book.leftPage); book.leftPage.empty:Hide(); book.leftPage.today:Hide()
        local plate = book.leftPage.portrait
        local box = book.leftPage.box
        plate:ClearAllPoints(); plate:SetPoint("CENTER", (box[1] - box[3]) / 2, (box[4] - box[2]) / 2)
        plate:SetSize(math.min(300, (book.leftPage:GetWidth() or 300) - book.leftPage.pad),
            math.min(380, (book.leftPage:GetHeight() or 400) - box[2] - box[4]))
        plate:Style(frameStyle); plate:Fill(facing, 0)
        PreparePage(book.rightPage, nil, where, chapters[state.index], TitleOf(chapters[state.index]))
        DrawChapter(book.rightPage, person, chapters[state.index], styleKey, styleMode, Story)
        book.chapterLabel:SetText("Page " .. state.index .. " of " .. count)
        PageRibbon(book.leftPage, nil); PageRibbon(book.rightPage, chapters[state.index])
        FillTimeline(chapters, person)
        ShowingRead(state.key, FinishedDay(chapters[state.index]))
    elseif spread then
        for i, page in ipairs({book.leftPage, book.rightPage}) do
            local leaf = not (single and i == 2) and chapters[state.index + i - 1] or nil
            local frame, info = Portraited(page, leaf, state.index + i - 1)
            if frame then frame:Style(frameStyle); frame:Fill(info, where == "c" and 0.75 or where == "e" and 0.6 or 0) end
        end
        DrawChapter(book.leftPage, person, chapters[state.index], styleKey, styleMode, Story)
        local rightLeaf = not single and chapters[state.index + 1] or nil
        DrawChapter(book.rightPage, person, rightLeaf, styleKey, styleMode, Story)
        if count > 0 and not rightLeaf then book.rightPage.empty:SetText(""); book.rightPage.empty:Hide() end
        local last = math.min(count, state.index + state.spreadStep - 1)
        book.chapterLabel:SetText(count == 0 and "" or (state.index == last and ("Page " .. state.index .. " of " .. count)
            or ("Pages " .. state.index .. "-" .. last .. " of " .. count)))
        PageRibbon(book.leftPage, chapters[state.index]); PageRibbon(book.rightPage, rightLeaf)
        FillTimeline(chapters, person)
        -- (both pages of the spread)
        ShowingRead(state.key, FinishedDay(chapters[state.index]), FinishedDay(chapters[last]))
    else
        local frame, info = Portraited(book.rightPage, chapters[state.index], state.index)
        if frame then frame:Style(frameStyle); frame:Fill(info, where == "c" and 0.75 or where == "e" and 0.6 or 0) end
        DrawChapter(book.rightPage, person, chapters[state.index], styleKey, styleMode, Story)
        book.chapterLabel:SetText(count == 0 and "" or ("Page " .. state.index .. " of " .. count))
        PageRibbon(book.rightPage, chapters[state.index])
        ShowingRead(state.key, FinishedDay(chapters[state.index]))
        FillTimeline(chapters, person)
    end
    book.prev:SetEnabled(state.index > 1)
    book.next:SetEnabled(state.index + (spread and state.spreadStep - 1 or 0) < count)
    UpdateWriteDate(person, chapters[state.index])
end

-- A name in a chapter: their journal, at the same day (or the next they have).
function A.BookJump(key)
    local day
    local person = Shown()
    if person then
        local chapters = reader and reader:IsShown() and reader.leaves or state.leaves or Chapters(person)
        local index = reader and reader:IsShown() and reader.index or state.index
        local chapter = chapters[index or #chapters]
        day = chapter and (chapter.day and (chapter.day.sourceDay or chapter.day.key) or chapter.classic and chapter.classic.key)
    end
    if reader and reader:IsShown() then reader.jumpDay, reader.jumpOffset = day, 0 end
    local owner = state.owner or SelfOf(state.key)
    A.OpenBook(key, owner and owner ~= A.Me() and A.PersonAs(key, owner) and owner or nil)
    state.jumpDay = day
    A.RefreshBook()
end

-- Turn physical pages; a long chapter can occupy several consecutive leaves.
function A.BookTurn(delta)
    if A.CloseLoreNote then A.CloseLoreNote() end
    if state.view == "people" and book.manager then book.manager.page = book.manager.page + delta; A.RefreshBook(); return end
    if state.view == "npcs" and book.npcManager then book.npcManager.page = book.npcManager.page + delta; A.RefreshBook(); return end
    if state.view ~= "journal" then return end
    local starts = state.displayStarts or {1}
    local at = 1
    for i, first in ipairs(starts) do if first <= (state.index or 1) then at = i end end
    at = math.max(1, math.min(#starts, at + delta))
    state.index = starts[at] or 1
    A.RefreshBook(nil, true)
end

-- Open the book: on a journal (a person's key, or "self:<character>"), or by the
-- opening rule: your target when they are in your list, else your own journal.
function A.OpenBook(key, charKey)
    if not A.db then return end
    charKey = charKey ~= A.Me() and charKey or nil
    if key and not SelfOf(key) then
        local person = A.People[key]
        if person and person.npc then return end
        if not person and not charKey then
            local others = A.OtherJournals(key)
            charKey = others[1] and others[1].key
        end
        if charKey then
            if not A.PersonAs(key, charKey) then return end
        elseif not person then return end
    end
    if reader and reader:IsShown() then reader.restoreBook = nil; reader:Hide() end
    if not book then Build() end
    if not key and A.FindPerson then
        local person, found = A.FindPerson("target")
        if person and found and not person.npc then key = found end
    end
    if not key then
        local unread = AllUnread()
        -- (your own journal first, when it has something new)
        local me = A.Me and A.Me()
        for _, item in ipairs(unread) do if item.key == "self:" .. (me or "") then key = item.key end end
        key = key or (unread[1] and unread[1].key)
        if key then state.jumpUnread = true end
    end
    if not key then
        local me = A.Me and A.Me()
        key = me and A.SelfPerson and A.SelfPerson(me) and ("self:" .. me) or state.key
    end
    if key ~= state.key or charKey ~= state.owner then CommitRead(); state.index, state.cardOpen, state.tab = nil, false, "journal" end
    state.key, state.owner = key, charKey
    state.view = "journal"
    book:Show(); book:Raise()
    A.RefreshBook(state.index == nil)
end
function A.OpenBookPeople(key, circle, mode)
    if not A.db then return end
    if not book then Build() end
    if reader and reader:IsShown() then reader.restoreBook = nil; reader:Hide() end
    if not book.manager then book.manager = A.CreateBookManager(book, {IsPinned = IsPinned, TogglePin = TogglePin}) end
    if key or circle or mode then book.manager:Select(key, circle, mode) end
    CommitRead(); state.view = "people"
    book:Show(); book:Raise(); A.RefreshBook()
end
-- The book's people pages at someone: your list, or My characters for someone
-- only your other characters know. No key: the people pages as they were.
function A.OpenPersonCard(key)
    if key and not A.People[key] and A.OtherKnowers and #A.OtherKnowers(key) > 0 then
        A.OpenBookPeople(key, nil, "others")
    else
        A.OpenBookPeople(key)
    end
end
function A.OpenBookSettings(section)
    if not A.db then return end
    if not book then Build() end
    if reader and reader:IsShown() then reader.restoreBook = nil; reader:Hide() end
    CommitRead(); state.view, state.settings = "settings", section or state.settings
    book:Show(); book:Raise(); A.RefreshBook()
end
function A.BookIsOpen() return book ~= nil and book:IsShown() end
-- (the journal changed: redraw if it is the one open)
-- A line written into someone else's journal (a crossed path, a gather count) is
-- not a reason to lay the open book out again; the pages are the shown journal's.
-- No person means a setting changed: everything is drawn again.
local function ShowsJournalOf(person, shown)
    if not person then return true end
    if not shown then return false end
    if person.self or shown.self then return person.self and shown.self and person.charKey == shown.charKey or false end
    return shown == person or (shown.journal ~= nil and shown.journal == person.journal)
end
local baseRefresh = A.RefreshJournal
function A.RefreshJournal(person, scrollToEnd)
    if baseRefresh then baseRefresh(person, scrollToEnd) end
    if book and book:IsShown() then
        if ShowsJournalOf(person, Shown()) then A.RefreshBook() end
    elseif reader and reader:IsShown() then
        if ShowsJournalOf(person, Shown()) or ShowsJournalOf(person, reader.subject) then DrawReader() end
    end
end

-- The new-chapter notice, when you rest (an inn, a city) and today's chapter is new.
local notice
local function ShowNotice(day)
    if not notice then
        notice = CreateFrame("Frame", "CompanionJournalBookNotice", UIParent)
        notice:SetSize(300, 64); notice:SetPoint("TOP", 0, -140)
        notice:SetFrameStrata("DIALOG")
        local bg = notice:CreateTexture(nil, "BACKGROUND")
        bg:SetAllPoints(); bg:SetAtlas("QuestBG-Parchment")
        local rim = notice:CreateTexture(nil, "BACKGROUND", nil, -1)
        rim:SetPoint("TOPLEFT", -2, 2); rim:SetPoint("BOTTOMRIGHT", 2, -2); rim:SetColorTexture(0.24, 0.16, 0.07, 1)
        notice.title = notice:CreateFontString(nil, "ARTWORK", "GameFontNormal")
        notice.title:SetPoint("TOPLEFT", 12, -10); notice.title:SetTextColor(CHAPTER[1], CHAPTER[2], CHAPTER[3]); notice.title:SetText("New chapter")
        notice.text = notice:CreateFontString(nil, "ARTWORK", "QuestFont")
        notice.text:SetPoint("TOPLEFT", 12, -30); notice.text:SetWidth(200); notice.text:SetJustifyH("LEFT"); notice.text:SetTextColor(INK[1], INK[2], INK[3])
        local read = CreateFrame("Button", nil, notice, "UIPanelButtonTemplate")
        read:SetSize(70, 22); read:SetPoint("RIGHT", -10, -6); read:SetText("Read")
        read:SetScript("OnClick", function()
            notice:Hide()
            local me = A.Me and A.Me()
            if me then A.OpenBook("self:" .. me); state.jumpUnread = true; A.RefreshBook() end
        end)
        if A.OptionsSkin then A.OptionsSkin.Button(read) end
    end
    local weekday = date and date("%A", (A.JournalEvening and A.JournalEvening(time()) or time())) or "Today"
    local zone = GetRealZoneText and GetRealZoneText() or ""
    notice.text:SetText(weekday .. (zone ~= "" and (", " .. zone) or ""))
    notice:Show()
    A.db.bookNoticed = day
    if C_Timer and C_Timer.After then C_Timer.After(15, function() if notice then notice:Hide() end end) end
end
local watcher = CreateFrame("Frame")
watcher:RegisterEvent("PLAYER_UPDATE_RESTING")
watcher:SetScript("OnEvent", function()
    local db = A.db
    if not db or not db.bookNotice then return end
    if not (IsResting and IsResting()) then return end
    local me = A.Me and A.Me()
    if not me then return end
    local today = DayKeyOf(time and time() or 0)
    if db.bookNoticed == today then return end
    for _, day in ipairs(UnreadDays("self:" .. me)) do if day == today then ShowNotice(today); return end end
end)

-- The minimap button: opens the book; a red dot when something is unread.
local minimap
function A.UpdateBookMinimap()
    local db = A.db
    if not db or not Minimap then return end
    local wanted = db.bookMinimap ~= false
    if not wanted then if minimap then minimap:Hide() end return end
    if not minimap then
        minimap = CreateFrame("Button", "CompanionJournalMinimapButton", Minimap)
        minimap:SetSize(31, 31); minimap:SetFrameStrata("MEDIUM"); minimap:SetFrameLevel(8)
        local icon = minimap:CreateTexture(nil, "BACKGROUND")
        icon:SetSize(20, 20); icon:SetPoint("TOPLEFT", 6, -5); icon:SetTexture("Interface\\Icons\\INV_Misc_Book_09")
        local border = minimap:CreateTexture(nil, "OVERLAY")
        border:SetSize(53, 53); border:SetPoint("TOPLEFT"); border:SetTexture("Interface\\Minimap\\MiniMap-TrackingBorder")
        minimap:SetHighlightTexture("Interface\\Minimap\\UI-Minimap-ZoomButton-Highlight")
        minimap.dot = minimap:CreateTexture(nil, "OVERLAY", nil, 2)
        minimap.dot:SetSize(9, 9); minimap.dot:SetPoint("TOPRIGHT", -3, -3); minimap.dot:SetColorTexture(RIBBON[1], RIBBON[2], RIBBON[3], 1)
        local function Place()
            local angle = math.rad(tonumber(A.db.bookMinimapAngle) or 200)
            -- Follow the actual rim, including enlarged minimaps. A fixed
            -- 80-pixel orbit puts the icon inside a larger map's terrain.
            local width, height = Minimap:GetWidth(), Minimap:GetHeight()
            local rx = (width and width > 0 and width or 140) / 2 + 5
            local ry = (height and height > 0 and height or 140) / 2 + 5
            minimap:ClearAllPoints()
            minimap:SetPoint("CENTER", Minimap, "CENTER", math.cos(angle) * rx, math.sin(angle) * ry)
        end
        minimap.Place = Place
        minimap:RegisterForDrag("LeftButton")
        minimap:SetScript("OnDragStart", function(self)
            self:SetScript("OnUpdate", function()
                local mx, my = Minimap:GetCenter()
                local cx, cy = GetCursorPosition()
                local scale = Minimap:GetEffectiveScale()
                A.db.bookMinimapAngle = math.deg(math.atan2(cy / scale - my, cx / scale - mx))
                Place()
            end)
        end)
        minimap:SetScript("OnDragStop", function(self) self:SetScript("OnUpdate", nil) end)
        minimap:SetScript("OnClick", function() if A.BookIsOpen() then book:Hide() else A.OpenBook() end end)
        minimap:SetScript("OnEnter", function(self)
            GameTooltip:SetOwner(self, "ANCHOR_LEFT")
            GameTooltip:SetText("Companion Journal", 1, 0.82, 0)
            local count = #AllUnread()
            GameTooltip:AddLine(count > 0 and (count .. (count == 1 and " journal has" or " journals have") .. " a new chapter.") or "Open the book.", 0.9, 0.9, 0.9, true)
            GameTooltip:AddLine("Drag to move around the minimap.", 0.7, 0.7, 0.7)
            GameTooltip:Show()
        end)
        minimap:SetScript("OnLeave", function() GameTooltip:Hide() end)
        Minimap:HookScript("OnSizeChanged", Place)
    end
    minimap.Place()
    minimap:Show()
    minimap.dot:SetShown(#AllUnread() > 0)
end
-- (new lines in a journal: the dot, at most once a few seconds)
local pendingDot = false
local journalRefresh = A.RefreshJournal
function A.RefreshJournal(person, scrollToEnd)
    if journalRefresh then journalRefresh(person, scrollToEnd) end
    if pendingDot or not (C_Timer and C_Timer.After) then return end
    pendingDot = true
    C_Timer.After(3, function() pendingDot = false; A.UpdateBookMinimap() end)
end
watcher:RegisterEvent("PLAYER_ENTERING_WORLD")
local baseWatch = watcher:GetScript("OnEvent")
watcher:SetScript("OnEvent", function(self, event, ...)
    if event == "PLAYER_ENTERING_WORLD" then A.UpdateBookMinimap(); return end
    return baseWatch(self, event, ...)
end)

-- The gamepad (scheme B), while the book is open in the gamepad interface:
-- D-pad left/right, the contents or the page; up/down, move in the list or
-- scroll the page. A opens, B goes back (then closes), LB/RB turn chapters,
-- LT/RT the card and the journal, Y adds someone, X Settings. Only the book's
-- own frames take the buttons; nothing of Blizzard's is touched.
local function PadOn()
    if C_GamePad and C_GamePad.IsEnabled then
        local ok, enabled = pcall(C_GamePad.IsEnabled)
        if ok and enabled then return true end
    end
    return false
end
local function FocusRows()
    local list = {}
    local manager = state.view == "people" and book.manager or state.view == "npcs" and book.npcManager
    if manager then
        for _, row in ipairs(manager.listUI.pools.button or {}) do
            if row:IsShown() and row:IsEnabled() then list[#list + 1] = row end
        end
        return list
    end
    for _, row in ipairs(book.rows) do
        if row:IsShown() and (row.key or row.action or row.section) then list[#list + 1] = row end
    end
    return list
end
local function ShowFocus()
    local rows = FocusRows()
    for _, row in ipairs(book.rows) do row.focus:Hide() end
    if book.manager then for _, row in ipairs(book.manager.listUI.pools.button or {}) do row.focus:Hide() end end
    if book.npcManager then for _, row in ipairs(book.npcManager.listUI.pools.button or {}) do row.focus:Hide() end end
    if state.focus ~= "page" then
        state.focusRow = math.max(1, math.min(state.focusRow or 1, #rows))
        local row = rows[state.focusRow]
        if row then row.focus:Show() end
    end
    if book.pageFocus then book.pageFocus:SetShown(state.focus == "page") end
end
local function Scroll(page, delta)
    if page and page.turn then page.turn(delta > 0 and 1 or -1); return end
    local scroll = page and page.scroll
    if not scroll then return end
    local range = scroll:GetVerticalScrollRange() or 0
    scroll:SetVerticalScroll(math.max(0, math.min(range, (scroll:GetVerticalScroll() or 0) + delta)))
end
function A.BookPad(button)
    if button == "PAD2" and A.LoreNoteIsOpen and A.LoreNoteIsOpen() then A.CloseLoreNote(); return end
    if not book or not book:IsShown() then return end
    if reader and reader:IsShown() then
        if button == "PADLSHOULDER" and reader.index > 1 then reader.index = reader.index - 1; DrawReader()
        elseif button == "PADRSHOULDER" then reader.index = reader.index + 1; DrawReader()
        elseif button == "PAD2" then reader:Hide()
        elseif button == "PADDUP" then Scroll(reader.page, -40)
        elseif button == "PADDDOWN" then Scroll(reader.page, 40) end
        return
    end
    if button == "PADDLEFT" then state.focus = "contents"
    elseif button == "PADDRIGHT" then state.focus = "page"
    elseif button == "PADDUP" or button == "PADDDOWN" then
        local step = button == "PADDUP" and -1 or 1
        if state.focus == "page" then
            Scroll(book.rightPage:IsShown() and book.rightPage or book.panel:IsShown() and book.panel or book.cardHost, step * 40)
        else
            state.focusRow = (state.focusRow or 1) + step
        end
    elseif button == "PAD1" then
        if state.focus ~= "page" then
            local row = FocusRows()[state.focusRow or 1]
            local click = row and row:GetScript("OnClick")
            if click then click(row) end
        end
    elseif button == "PAD2" then
        if state.wizard then state.wizard = nil
        elseif state.cardOpen then state.cardOpen = false
        elseif state.tab and state.tab ~= "journal" then state.tab = "journal"
        elseif state.view ~= "journal" then state.view = "journal"
        else book:Hide(); return end
        A.RefreshBook()
    elseif button == "PADLSHOULDER" then A.BookTurn(-1)
    elseif button == "PADRSHOULDER" then A.BookTurn(1)
    elseif button == "PADLTRIGGER" or button == "PADRTRIGGER" then
        if A.BookVariant("card") == "b" then
            local order = {"journal", "about", "notes"}
            local at = 1
            for i, tab in ipairs(order) do if tab == (state.tab or "journal") then at = i end end
            at = ((at - 1 + (button == "PADRTRIGGER" and 1 or -1)) % #order) + 1
            state.tab = order[at]
        else
            state.cardOpen = not state.cardOpen
        end
        A.RefreshBook()
    elseif button == "PAD4" then
        if state.view == "npcs" and book.npcManager then book.npcManager:AddTarget()
        else
            local click = book.addBar.main:IsShown() and book.addBar.main:GetScript("OnClick")
            if click then click(book.addBar.main) else local _, key = A.AddTargetPerson(); OpenAdded(key) end
        end
    elseif button == "PAD3" then
        state.view = state.view == "settings" and "journal" or "settings"
        A.RefreshBook()
    end
    ShowFocus()
end
do
    local function Hook()
        if not book or book.padHooked or not book.EnableGamePadButton then return end
        book.padHooked = true
        -- (a gold rim on the page when the gamepad is on it)
        book.pageFocus = book:CreateTexture(nil, "BACKGROUND", nil, -3)
        book.pageFocus:SetPoint("TOPLEFT", book.right, "TOPLEFT", -3, 3); book.pageFocus:SetPoint("BOTTOMRIGHT", book.right, "BOTTOMRIGHT", 3, -3)
        book.pageFocus:SetColorTexture(1, 0.82, 0, 0.8); book.pageFocus:Hide()
        book:SetScript("OnGamePadButtonDown", function(_, button) A.BookPad(button) end)
        book:HookScript("OnShow", function()
            local on = PadOn()
            book:EnableGamePadButton(on)
            if on then state.focus = state.focus or "contents"; ShowFocus() end
        end)
        book:HookScript("OnHide", function() book:EnableGamePadButton(false) end)
        if book:IsShown() then book:EnableGamePadButton(PadOn()) end
    end
    for _, name in ipairs({"OpenBook", "OpenBookPeople", "OpenBookSettings"}) do
        local open = A[name]
        A[name] = function(...)
            open(...)
            Hook()
            if PadOn() then ShowFocus() end
        end
    end
end
