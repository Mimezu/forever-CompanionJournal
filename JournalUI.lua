local _, A = ...
-- The journal window: one person's chronicle on a parchment page, days as
-- chapters. Built on first open. Open it from the list (double-click, the
-- Journal button or right-click), or /cj journal [name].
-- Two switches in the header: Everything / Highlights (every adventure, or
-- one short entry a day with its notable moments) and the page style, A to E.
-- A is the original page (JournalChapters); the others are drawn by
-- JournalStyles.lua from the book (JournalBook.lua).
-- Each character keeps their own journal. When your other characters keep
-- one with the same person, "Kept by" switches to theirs (read only).
local frame, current, whose
-- The person on the page: yours, or another character's (read only).
-- Your own journal is shown as "self:<character>".
local function SelfOf(key) return type(key) == "string" and key:match("^self:(.+)$") or nil end
local function Shown()
    if not current then return nil end
    local charKey = SelfOf(current)
    if charKey then return A.SelfPerson and A.SelfPerson(charKey) end
    if whose then return A.PersonAs(current, whose) end
    return A.People[current]
end
local Render -- defined below; the page lays itself out again on resize
local INK = {0.20, 0.11, 0.04}
local INK_SOFT = {0.36, 0.22, 0.08}
local CHAPTER = {0.42, 0.10, 0.04}

A.defaults.journalStyle = "a"
A.defaults.journalMode = "all"
A.defaults.journalVoice = "simple"
local STYLES = {"a", "b", "c", "d", "e"}
function A.JournalStyle()
    local style = A.db and A.db.journalStyle
    for _, known in ipairs(STYLES) do if style == known then return style end end
    return "a"
end
-- Everything or Highlights; and, separately, Simple (the plain prose) or Story.
function A.JournalMode()
    local db = A.db
    if db and db.journalMode == "story" then db.journalMode, db.journalVoice = "all", "story" end -- 1.2.0 test builds
    return db and db.journalMode == "highlights" and "highlights" or "all"
end
function A.JournalVoice()
    return A.db and A.db.journalVoice == "story" and "story" or "simple"
end

local function ClassColor(class)
    local color = class and ((C_ClassColor and C_ClassColor.GetClassColor and C_ClassColor.GetClassColor(class))
        or (RAID_CLASS_COLORS and RAID_CLASS_COLORS[class]))
    if color then return color.r, color.g, color.b end
    return 1, 0.82, 0
end
local function ClassName(class)
    return class and ((LOCALIZED_CLASS_NAMES_MALE and LOCALIZED_CLASS_NAMES_MALE[class])
        or (class:sub(1, 1) .. class:sub(2):lower())) or nil
end
function A.PersonSummary(person)
    local parts = {}
    if person.level then parts[#parts + 1] = (LEVEL or "Level") .. " " .. person.level end
    local class = ClassName(person.class)
    if class then
        if #parts > 0 then parts[#parts] = parts[#parts] .. " " .. class else parts[1] = class end
    end
    if person.faction then parts[#parts + 1] = person.faction end
    return table.concat(parts, "  -  ")
end
function A.SetPersonClassIcon(texture, class)
    local atlas = class and GetClassAtlas and GetClassAtlas(class:lower())
    if atlas and C_Texture and C_Texture.GetAtlasInfo and C_Texture.GetAtlasInfo(atlas) then
        texture:SetAtlas(atlas); texture:Show()
    else
        texture:Hide()
    end
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
        GameTooltip:SetOwner(self, "ANCHOR_BOTTOM")
        GameTooltip:SetText(title, 1, 0.82, 0)
        if tip then GameTooltip:AddLine(tip, 0.9, 0.9, 0.9, true) end
        GameTooltip:Show()
    end)
    button:SetScript("OnLeave", function() GameTooltip:Hide() end)
    return button
end
local function SetChosen(button, chosen)
    if chosen then button.fill:SetColorTexture(0.29, 0.20, 0.06, 1) else button.fill:SetColorTexture(0.18, 0.13, 0.07, 1) end
    for _, edge in ipairs(button.edges) do
        if chosen then edge:SetColorTexture(1, 0.82, 0, 1) else edge:SetColorTexture(0.42, 0.32, 0.19, 1) end
    end
    if chosen then button.label:SetTextColor(1, 0.82, 0) else button.label:SetTextColor(0.91, 0.85, 0.69) end
end

local function Build()
    frame = CreateFrame("Frame", "CompanionJournalBook", UIParent)
    frame:SetSize(520, 560)
    frame:SetPoint("CENTER", 180, 20)
    -- Above the settings window (DIALOG), which usually sits next to it.
    frame:SetFrameStrata("FULLSCREEN_DIALOG")
    frame:EnableMouse(true)
    frame:SetToplevel(true)
    local heading = frame:CreateFontString(nil, "OVERLAY", "GameFontNormal")
    heading:SetText("Journal")
    if A.OptionsSkin then A.OptionsSkin.Frame(frame, heading) end
    if UISpecialFrames then table.insert(UISpecialFrames, "CompanionJournalBook") end

    -- The switches: Everything | Highlights, and the style letters under them.
    local controls = CreateFrame("Frame", nil, frame)
    controls:SetSize(226, 42); controls:SetPoint("TOPRIGHT", -24, -37)
    frame.modeButtons, frame.styleButtons, frame.voiceButtons = {}, {}, {}
    local modes = {
        {"all", "Everything", 70, "Every adventure, scene by scene."},
        {"highlights", "Highlights", 68, "One short entry a day with the notable moments."},
    }
    local x = 226
    for i = #modes, 1, -1 do
        local mode = modes[i]
        x = x - mode[3]
        local button = Toggle(controls, mode[2], mode[3], mode[2], mode[4], function()
            A.db.journalMode = mode[1]; Render(true)
        end)
        button:SetPoint("TOPLEFT", x, 0)
        x = x - 3
        frame.modeButtons[mode[1]] = button
    end
    -- Simple (the plain prose) or Story (told as a tale), beside the styles.
    local voices = {
        {"simple", "Simple", 46, "The plain record: what happened, as it happened."},
        {"story", "Story", 44, "Your days together told as a tale, chapter by chapter. It changes as you grow closer. With Highlights: the short version."},
    }
    local vx = 0
    for _, voice in ipairs(voices) do
        local button = Toggle(controls, voice[2], voice[3], voice[2], voice[4], function()
            A.db.journalVoice = voice[1]; Render(true)
        end)
        button:SetPoint("TOPLEFT", vx, -23)
        vx = vx + voice[3] + 3
        frame.voiceButtons[voice[1]] = button
    end
    for i, style in ipairs(STYLES) do
        local names = A.JournalStyleNames or {}
        local button = Toggle(controls, style:upper(), 22, "Style " .. style:upper(), names[style], function()
            A.db.journalStyle = style; Render(true)
        end)
        button:SetPoint("TOPLEFT", 226 - (#STYLES - i + 1) * 25 + 3, -23)
        frame.styleButtons[style] = button
    end
    frame.controls = controls

    frame.classIcon = frame:CreateTexture(nil, "ARTWORK")
    frame.classIcon:SetSize(34, 34); frame.classIcon:SetPoint("TOPLEFT", 24, -40)
    frame.name = frame:CreateFontString(nil, "ARTWORK", "GameFontNormalLarge")
    frame.name:SetPoint("TOPLEFT", 66, -42); frame.name:SetWidth(198) -- up to the switches
    frame.name:SetJustifyH("LEFT"); frame.name:SetWordWrap(false)
    frame.summary = frame:CreateFontString(nil, "ARTWORK", "GameFontHighlightSmall")
    frame.summary:SetPoint("TOPLEFT", frame.name, "BOTTOMLEFT", 0, -4); frame.summary:SetWidth(198)
    frame.summary:SetJustifyH("LEFT"); frame.summary:SetTextColor(0.75, 0.75, 0.75)

    -- The page: clean parchment (rivals: their faction's paper).
    local page = CreateFrame("Frame", nil, frame)
    page:SetPoint("TOPLEFT", 20, -84); page:SetPoint("BOTTOMRIGHT", -16, 52)
    frame.page = page
    frame.paper = page:CreateTexture(nil, "BACKGROUND")
    frame.paper:SetAllPoints()
    local rim = page:CreateTexture(nil, "BORDER")
    rim:SetPoint("TOPLEFT", -1, 1); rim:SetPoint("BOTTOMRIGHT", 1, -1)
    rim:SetColorTexture(0, 0, 0, 0.45)
    rim:SetDrawLayer("BACKGROUND", -1)

    local scroll = CreateFrame("ScrollFrame", nil, page, "UIPanelScrollFrameTemplate")
    scroll:SetPoint("TOPLEFT", 14, -12); scroll:SetPoint("BOTTOMRIGHT", -30, 12)
    local child = CreateFrame("Frame", nil, scroll)
    child:SetSize(page:GetWidth() > 0 and page:GetWidth() - 44 or 400, 10)
    scroll:SetScrollChild(child)
    scroll:SetScript("OnSizeChanged", function(_, width)
        if not width or width <= 0 or math.abs((child:GetWidth() or 0) - width) < 0.5 then return end
        child:SetWidth(width)
        if frame:IsShown() and current then Render() end
    end)
    frame.scroll, frame.child = scroll, child
    frame.lines = {}
    -- Measures text for the styles (never seen).
    frame.measure = child:CreateFontString(nil, "ARTWORK")
    frame.measure:SetPoint("TOPLEFT"); frame.measure:SetAlpha(0)
    frame.measure:SetFontObject("QuestFont"); frame.measure:SetWordWrap(true)

    frame.empty = child:CreateFontString(nil, "ARTWORK", "QuestFont")
    frame.empty:SetPoint("TOP", 0, -40); frame.empty:SetWidth(360)
    frame.empty:SetTextColor(unpack(INK_SOFT))

    -- Writing a line yourself.
    local input = CreateFrame("EditBox", nil, frame, "InputBoxTemplate")
    input:SetPoint("BOTTOMLEFT", 30, 20); input:SetSize(296, 22)
    input:SetAutoFocus(false); input:SetMaxLetters(300)
    local hint = input:CreateFontString(nil, "ARTWORK", "GameFontDisableSmall")
    hint:SetPoint("LEFT", 4, 0); hint:SetText("Write a line in the journal...")
    input:SetScript("OnTextChanged", function(self) hint:SetShown((self:GetText() or "") == "") end)
    input:SetScript("OnEscapePressed", function(self) self:ClearFocus() end)
    local function Write()
        local person = not whose and Shown()
        if person and A.JournalWrite(person, input:GetText()) then
            input:SetText(""); input:ClearFocus()
            A.RefreshJournal(person, true)
        end
    end
    input:SetScript("OnEnterPressed", Write)
    local write = CreateFrame("Button", nil, frame, "UIPanelButtonTemplate")
    write:SetPoint("LEFT", input, "RIGHT", 8, 0); write:SetSize(84, 24)
    write:SetText("Write")
    write:SetScript("OnClick", Write)
    if A.OptionsSkin then A.OptionsSkin.Button(write) end
    frame.input, frame.write = input, write
    -- Story mode: tell it again in new words (same days, same facts).
    local retell = CreateFrame("Button", nil, frame, "UIPanelButtonTemplate")
    retell:SetPoint("LEFT", write, "RIGHT", 6, 0); retell:SetSize(76, 24)
    retell:SetText("Retell")
    retell:SetScript("OnClick", function()
        local person = not whose and Shown()
        if not person then return end
        person.retell = (tonumber(person.retell) or 0) + 1
        -- (your own journal: kept on the character)
        if person.self and A.CharacterRecord then
            local record = person.charKey == (A.Me and A.Me()) and A.MyCharacter and A.MyCharacter(true) or A.CharacterRecord(person.charKey)
            if record then record.retell = person.retell end
        end
        Render()
    end)
    retell:SetScript("OnEnter", function(self)
        GameTooltip:SetOwner(self, "ANCHOR_TOP")
        GameTooltip:SetText("Retell", 1, 0.82, 0)
        GameTooltip:AddLine("Tell the story again in new words. Same days, same facts.", 0.9, 0.9, 0.9, true)
        GameTooltip:Show()
    end)
    retell:SetScript("OnLeave", function() GameTooltip:Hide() end)
    if A.OptionsSkin then A.OptionsSkin.Button(retell) end
    frame.retell = retell
    -- Another character's journal: read only, in place of the writing line.
    frame.readOnly = frame:CreateFontString(nil, "ARTWORK", "GameFontHighlightSmall")
    frame.readOnly:SetPoint("BOTTOMLEFT", 30, 18); frame.readOnly:SetPoint("RIGHT", -30, 0)
    frame.readOnly:SetJustifyH("LEFT"); frame.readOnly:SetTextColor(0.75, 0.75, 0.75)

    -- Kept by: this character's journal, or another character's.
    local keepers = CreateFrame("Frame", nil, frame)
    keepers:SetPoint("TOPLEFT", 24, -86); keepers:SetSize(472, 19)
    keepers.label = keepers:CreateFontString(nil, "ARTWORK", "GameFontNormalSmall")
    keepers.label:SetPoint("LEFT", 0, 0); keepers.label:SetText("Kept by")
    keepers.buttons = {}
    frame.keepers = keepers
end
-- The "Kept by" switches: this character (when they know the person) and
-- every other character keeping a journal with them.
local function KeeperButton(index)
    local keepers = frame.keepers
    local button = keepers.buttons[index]
    if button then return button end
    button = Toggle(keepers, "", 60, "Kept by", nil, function(self)
        whose = self.charKey
        Render(true)
    end)
    button:SetScript("OnEnter", function(self)
        GameTooltip:SetOwner(self, "ANCHOR_BOTTOM")
        GameTooltip:SetText(self.title or "", 1, 0.82, 0)
        GameTooltip:AddLine(self.tip or "", 0.9, 0.9, 0.9, true)
        GameTooltip:Show()
    end)
    keepers.buttons[index] = button
    return button
end
local function LayoutKeepers()
    local keepers = frame.keepers
    if SelfOf(current) then
        keepers:Hide(); frame.page:SetPoint("TOPLEFT", 20, -84)
        return
    end
    local others = A.OtherJournals and A.OtherJournals(current) or {}
    local mine = A.People[current]
    local list = {}
    if mine then list[#list + 1] = {key = nil, name = A.CharacterName and A.Me() and A.CharacterName(A.Me()) or "You", mine = true} end
    for _, knower in ipairs(others) do list[#list + 1] = knower end
    local shown = #others > 0
    keepers:SetShown(shown)
    frame.page:SetPoint("TOPLEFT", 20, shown and -110 or -84)
    if not shown then return end
    local x = (keepers.label:GetStringWidth() or 44) + 8
    for i = 1, math.max(#list, #keepers.buttons) do
        local item = list[i]
        if item then
            local button = KeeperButton(i)
            button.charKey = item.key
            button.label:SetText(item.name)
            button:SetWidth(math.max(44, math.floor((button.label:GetStringWidth() or 40) + 18)))
            button:ClearAllPoints(); button:SetPoint("LEFT", x, 0)
            x = x + button:GetWidth() + 3
            button.title = item.mine and ("Your journal (" .. item.name .. ")") or (item.name .. "'s journal")
            button.tip = item.mine and "What you write and live on this character." or
                ("Kept by your character " .. item.name .. ". Read only, told by " .. item.name .. "'s storyteller.")
            -- Past the window's edge: the rest waits for a wider window.
            button:SetShown(x <= 472)
            SetChosen(button, item.key == whose)
        elseif keepers.buttons[i] then
            keepers.buttons[i]:Hide()
        end
    end
end

-- A line of the page: a button so lines can be removed with a right-click.
local function Line(index)
    local line = frame.lines[index]
    if line then return line end
    line = CreateFrame("Button", nil, frame.child)
    line:RegisterForClicks("RightButtonUp")
    line.text = line:CreateFontString(nil, "ARTWORK", "QuestFont")
    line.text:SetPoint("TOPLEFT")
    line.text:SetJustifyH("LEFT")
    line.text:SetWordWrap(true)
    line:SetScript("OnClick", function(self)
        local person = not whose and Shown()
        if not person or not self.entry then return end
        if self.armed then
            A.JournalRemove(person, self.entry)
        else
            self.armed = true
            GameTooltip:SetOwner(self, "ANCHOR_CURSOR")
            GameTooltip:SetText("Right-click again to remove this line.", 1, 0.3, 0.3)
            GameTooltip:Show()
        end
    end)
    line:SetScript("OnEnter", function(self)
        if not self.entry or whose then return end
        GameTooltip:SetOwner(self, "ANCHOR_CURSOR")
        GameTooltip:SetText("Right-click to remove this line.", 0.8, 0.8, 0.8)
        GameTooltip:Show()
    end)
    line:SetScript("OnLeave", function(self) self.armed = false; GameTooltip:Hide() end)
    frame.lines[index] = line
    return line
end

-- Blocks for styles B to E (and every style's Highlights): buttons lent to
-- JournalStyles.lua, each with its own texts and textures, so a scene or a
-- line of yours can be removed with a right-click.
local REMOVE_HINT = {outing = "this outing", line = "this line", entry = "this entry"}
local blocks, usedBlocks = {}, 0
local function BlockClick(self)
    local person = not whose and Shown()
    if not person or not self.entries then return end
    if self.armed then
        A.JournalRemoveEntries(person, self.entries)
    else
        self.armed = true
        GameTooltip:SetOwner(self, "ANCHOR_CURSOR")
        GameTooltip:SetText("Right-click again to remove " .. (REMOVE_HINT[self.what] or "this entry") .. ".", 1, 0.3, 0.3)
        GameTooltip:Show()
    end
end
local function BlockEnter(self)
    if not self.entries or whose then return end
    GameTooltip:SetOwner(self, "ANCHOR_CURSOR")
    GameTooltip:SetText("Right-click to remove " .. (REMOVE_HINT[self.what] or "this entry") .. ".", 0.8, 0.8, 0.8)
    GameTooltip:Show()
end
local function BlockLeave(self) self.armed = false; GameTooltip:Hide() end
local function Block(entries, what)
    usedBlocks = usedBlocks + 1
    local block = blocks[usedBlocks]
    if not block then
        block = CreateFrame("Button", nil, frame.child)
        block:RegisterForClicks("RightButtonUp")
        block.texts, block.textures = {}, {}
        block:SetScript("OnClick", BlockClick)
        block:SetScript("OnEnter", BlockEnter)
        block:SetScript("OnLeave", BlockLeave)
        blocks[usedBlocks] = block
    end
    for _, part in pairs(block.texts) do part:Hide() end
    for _, part in pairs(block.textures) do part:Hide() end
    block:ClearAllPoints()
    block.entries = type(entries) == "table" and #entries > 0 and entries or nil
    block.what, block.armed = what, false
    block:Show()
    return block
end
local function BlockText(block, key, font, color, justify)
    local text = block.texts[key]
    if not text then text = block:CreateFontString(nil, "ARTWORK"); block.texts[key] = text end
    text:ClearAllPoints()
    text:SetFontObject(font)
    text:SetTextColor(color[1], color[2], color[3], color[4] or 1)
    text:SetJustifyH(justify or "LEFT"); text:SetJustifyV("TOP")
    text:SetSpacing(0); text:SetWordWrap(true)
    text:Show()
    return text
end
local function BlockTexture(block, key, layer)
    local texture = block.textures[key]
    if not texture then texture = block:CreateTexture(nil, layer or "ARTWORK"); block.textures[key] = texture end
    texture:ClearAllPoints()
    texture:SetDrawLayer(layer or "ARTWORK")
    texture:SetVertexColor(1, 1, 1, 1)
    texture:Show()
    return texture
end
local function Place(block, x, y, width, height)
    block:SetPoint("TOPLEFT", frame.child, "TOPLEFT", x, y)
    block:SetSize(width, math.max(1, height))
end
-- How many lines a text wraps to at a width (for the diary's drop cap).
local function Lines(font, spacing, width, text)
    local measure = frame.measure
    measure:SetFontObject(font)
    measure:SetSpacing(spacing or 0)
    measure:SetWidth(width)
    measure:SetText(text)
    local count = measure.GetNumLines and measure:GetNumLines()
    if not (count and count > 0) then
        local height = measure:GetStringHeight()
        measure:SetText("M")
        local one = measure:GetStringHeight()
        count = math.floor((height + (spacing or 0)) / math.max(1, one + (spacing or 0)) + 0.5)
    end
    -- Nothing measured stays on the page (a font object can bring its alpha back).
    measure:SetText(""); measure:SetAlpha(0)
    return count
end

-- A text's width on one line (the diary sets its lines itself).
local function Width(font, text)
    local measure = frame.measure
    measure:SetFontObject(font)
    measure:SetSpacing(0)
    measure:SetWordWrap(false)
    measure:SetWidth(4000)
    measure:SetText(text)
    local width = measure.GetUnboundedStringWidth and measure:GetUnboundedStringWidth() or measure:GetStringWidth()
    measure:SetText(""); measure:SetWordWrap(true); measure:SetAlpha(0)
    return width or 0
end

-- The original page (style A, Everything): one sentence per recorded line.
local function RenderClassic(person, width)
    local y, index = -4, 0
    local days = A.JournalChapters(person)
    for _, day in ipairs(days) do
        index = index + 1
        local title = Line(index)
        title.entry = nil
        title.text:SetFontObject("QuestFont")
        title.text:SetText("~  " .. day.title .. "  ~")
        title.text:SetJustifyH("CENTER")
        title.text:SetTextColor(unpack(CHAPTER))
        title:SetPoint("TOPLEFT", 0, y); title:SetWidth(width)
        -- Measure at the real width: an anchor-derived width is not resolved
        -- yet, so a wrapped line would be measured as one line and overlap.
        title.text:SetWidth(width)
        title:SetHeight(title.text:GetStringHeight() + 2)
        title:Show()
        y = y - title:GetHeight() - 6
        for _, entry in ipairs(day.lines) do
            index = index + 1
            local line = Line(index)
            line.entry, line.armed = entry.entry, false
            line.text:SetFontObject("QuestFont")
            line.text:SetJustifyH("LEFT")
            line.text:SetText(entry.text)
            line.text:SetTextColor(unpack(entry.custom and INK_SOFT or INK))
            local indent = entry.custom and 22 or 8
            line:SetPoint("TOPLEFT", indent, y); line:SetWidth(width - indent - 4)
            line.text:SetWidth(width - indent - 4)
            line:SetHeight(line.text:GetStringHeight() + 2)
            line:Show()
            y = y - line:GetHeight() - 5
        end
        y = y - 10
    end
    for i = index + 1, #frame.lines do frame.lines[i]:Hide() end
    return -y, #days == 0
end
-- The book in a style (and mode).
local function RenderBook(person, width, style, mode, voice)
    -- Story: the whole tale with Everything, the short one with Highlights.
    local styleMode = voice == "story" and (mode == "all" and "story" or "storyBrief") or mode
    for i = 1, #frame.lines do frame.lines[i]:Hide() end
    usedBlocks = 0
    local days = A.JournalBook(person)
    local ctx = {width = width, Block = Block, Text = BlockText, Texture = BlockTexture, Place = Place, Lines = Lines, Width = Width}
    -- Story mode: the whole book is told once per voice.
    local stories = {}
    -- Another character's journal is told as they would hear it.
    local hero = whose and A.CharacterPlayer and A.CharacterPlayer(whose) or nil
    function ctx.Story(day, teller)
        teller = teller or "you"
        if not stories[teller] then
            if person.self then
                stories[teller] = A.SelfTale and A.SelfTale.Tell(person, days, styleMode == "storyBrief") or {}
            else
                stories[teller] = A.JournalTale and A.JournalTale.Tell(person, days, teller, hero, styleMode == "storyBrief") or {}
            end
        end
        return stories[teller][day.key]
    end
    -- In Story mode a day may have no chapter of its own (told with the next day,
    -- or left out of the short telling): it is not drawn, not even its date.
    local shown = days
    if styleMode == "story" or styleMode == "storyBrief" then
        shown = {}
        local teller = style == "d" and "we" or "you"
        for _, day in ipairs(days) do
            local story = ctx.Story(day, teller)
            if story and (story.text ~= "" or #story.quotes > 0) then shown[#shown + 1] = day end
        end
    end
    local height = A.JournalStyles[style](ctx, shown, person, styleMode)
    for i = usedBlocks + 1, #blocks do blocks[i]:Hide() end
    return height, #days == 0
end

function Render(scrollToEnd)
    -- A keeper who no longer has a journal with them: back to yours.
    local selfKey = SelfOf(current)
    if whose and (selfKey or not A.PersonAs(current, whose)) then whose = nil end
    if not whose and not selfKey and current and not A.People[current] then
        local others = A.OtherJournals and A.OtherJournals(current) or {}
        whose = others[1] and others[1].key or nil
    end
    local person = Shown()
    if not person then frame:Hide(); return end
    LayoutKeepers()
    local reading = whose ~= nil or (person.self and person.readOnly) or false
    frame.input:SetShown(not reading); frame.write:SetShown(not reading)
    frame.readOnly:SetShown(reading)
    if reading and person.self then
        frame.readOnly:SetText((person.name or "Another character") .. "'s own journal. Read only.")
    elseif reading then
        local keeper = A.CharacterName and A.CharacterName(whose) or "another character"
        frame.readOnly:SetText(keeper .. "'s journal with " .. (person.display or (person.name or current):gsub("%-.*$", ""))
            .. ". Read only." .. (A.People[current] and "" or " Import them (People > My characters) to start your own."))
    end
    local fullName = person.name or current
    local label = person.display and (person.display .. "  |cff9d9d9d" .. fullName .. "|r") or fullName
    frame.name:SetText(label)
    frame.name:SetTextColor(ClassColor(person.class))
    A.SetPersonClassIcon(frame.classIcon, person.class)
    if not frame.classIcon:IsShown() then
        frame.name:SetPoint("TOPLEFT", 26, -42); frame.name:SetWidth(238); frame.summary:SetWidth(238)
    else
        frame.name:SetPoint("TOPLEFT", 66, -42); frame.name:SetWidth(198); frame.summary:SetWidth(198)
    end
    local summary = A.PersonSummary(person)
    if not A.JournalOn() then
        summary = (summary ~= "" and (summary .. "\n") or "") .. "|cff888888Automatic entries are off (Companion Journal > Options).|r"
    end
    frame.summary:SetText(summary)
    local rival = A.PersonCircle and A.PersonCircle(person) == "rival"
    local atlas = rival and (person.faction == "Horde" and "QuestBG-Horde" or person.faction == "Alliance" and "QuestBG-Alliance")
        or "QuestBG-Parchment"
    if C_Texture and C_Texture.GetAtlasInfo and not C_Texture.GetAtlasInfo(atlas) then atlas = "QuestBG-Parchment" end
    frame.paper:SetAtlas(atlas)

    local style, mode = A.JournalStyle(), A.JournalMode()
    for key, button in pairs(frame.styleButtons) do SetChosen(button, key == style) end
    for key, button in pairs(frame.modeButtons) do SetChosen(button, key == mode) end
    local voice = A.JournalVoice()
    for key, button in pairs(frame.voiceButtons) do SetChosen(button, key == voice) end

    frame.retell:SetShown(voice == "story" and not reading)

    local width = frame.child:GetWidth()
    if not width or width < 50 then width = 400 end
    local height, empty
    if style == "a" and mode == "all" and voice == "simple" and not person.self then
        for i = 1, usedBlocks do blocks[i]:Hide() end
        usedBlocks = 0
        height, empty = RenderClassic(person, width)
    else
        height, empty = RenderBook(person, width, style, mode, voice)
    end
    frame.empty:SetShown(empty)
    frame.empty:SetText(empty and (reading and "Nothing recorded." or "No adventures recorded yet.\n\nWrite the first line below.") or "")
    frame.child:SetHeight(math.max(40, height))
    if scrollToEnd then
        C_Timer.After(0, function()
            if frame.scroll.UpdateScrollChildRect then frame.scroll:UpdateScrollChildRect() end
            frame.scroll:SetVerticalScroll(frame.scroll:GetVerticalScrollRange())
        end)
    end
end

-- Open someone's journal: yours by default, or charKey's (read only). Someone
-- only your other characters know opens their journal.
function A.OpenJournal(key, charKey)
    if A.db and A.db.cjLayout == "b" and A.OpenBook then A.OpenBook(key, charKey); return end
    local person = key and A.People[key]
    local others = key and A.OtherJournals and A.OtherJournals(key) or {}
    if person and person.npc then return end
    if not person and #others == 0 then return end
    if not frame then Build() end
    if key ~= current then whose = nil end
    current = key
    if charKey ~= nil then whose = charKey ~= A.Me() and charKey or nil end
    frame:Show()
    frame:Raise()
    Render(true)
end
function A.RefreshJournal(person, scrollToEnd)
    if not frame or not frame:IsShown() or not current then return end
    if person and person.self then
        if SelfOf(current) ~= person.charKey then return end
    elseif person and (whose or A.People[current] ~= person) then return end
    Render(scrollToEnd)
end
-- Your own journal (or another character's, read only).
function A.OpenSelfJournal(charKey)
    charKey = charKey or (A.Me and A.Me())
    if not charKey or not A.SelfPerson or not A.SelfPerson(charKey) then return end
    if A.db and A.db.cjLayout == "b" and A.OpenBook then A.OpenBook("self:" .. charKey); return end
    if not frame then Build() end
    current, whose = "self:" .. charKey, nil
    frame:Show()
    frame:Raise()
    Render(true)
end
function A.CloseJournal() if frame then frame:Hide() end end
function A.JournalIsOpen() return frame ~= nil and frame:IsShown() end
