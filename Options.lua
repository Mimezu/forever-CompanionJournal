local _, A = ...
-- The Companion Journal window: your list with the selected person, and the
-- list's options (what shows in the world, how people are added, the
-- journal). Same look and building blocks as Forever Names' settings.
local W, H = 860, 580
local GOLD, NOTE, DIM = {1, 0.82, 0}, {0.80, 0.77, 0.70}, {0.5, 0.5, 0.5}

function A.CreateOptions()
    if A.options then return end
    local db, skin = A.db, A.OptionsSkin
    local frame = CreateFrame("Frame", "CompanionJournalOptions", UIParent, "BackdropTemplate")
    A.options = frame
    frame:Hide()
    frame:SetSize(W, H)
    frame:SetPoint("CENTER")
    frame:SetFrameStrata("DIALOG")
    frame:EnableMouse(true)
    if UISpecialFrames then table.insert(UISpecialFrames, "CompanionJournalOptions") end
    local heading = frame:CreateFontString(nil, "ARTWORK", "GameFontNormalLarge")
    heading:SetText("Companion Journal")
    if skin then
        skin.Frame(frame, heading)
    else
        frame:SetBackdrop({bgFile = "Interface\\Buttons\\WHITE8X8", edgeFile = "Interface\\Tooltips\\UI-Tooltip-Border", edgeSize = 16,
            insets = {left = 4, right = 4, top = 4, bottom = 4}})
        frame:SetBackdropColor(0.06, 0.06, 0.06, 0.98)
        heading:SetPoint("TOP", 0, -12)
    end
    local updaters = {}
    local function OnRefresh(fn) updaters[#updaters + 1] = fn end

    -- Building blocks ------------------------------------------------------
    local function Text(parent, text, x, y, template, width, color)
        local label = parent:CreateFontString(nil, "ARTWORK", template or "GameFontHighlight")
        label:SetPoint("TOPLEFT", x, y)
        label:SetJustifyH("LEFT")
        label:SetText(text)
        if width then label:SetWidth(width); label:SetWordWrap(true) end
        if color then label:SetTextColor(unpack(color)) end
        return label
    end
    local function Note(parent, text, x, y, width)
        return Text(parent, text, x, y, "GameFontHighlightSmall", width, NOTE)
    end
    local function Line(parent, x, y, width, height, alpha)
        local line = parent:CreateTexture(nil, "BORDER")
        line:SetPoint("TOPLEFT", x, y)
        line:SetSize(width, height)
        line:SetColorTexture(0.68, 0.50, 0.26, alpha or 0.45)
        return line
    end
    local function Card(parent, title, x, y, width, height)
        local card = CreateFrame("Frame", nil, parent)
        card:SetPoint("TOPLEFT", x, y)
        card:SetSize(width, height)
        local wash = card:CreateTexture(nil, "BACKGROUND", nil, -2)
        wash:SetAllPoints()
        wash:SetColorTexture(0.25, 0.17, 0.085, 0.16)
        Line(card, 0, 0, width, 1, 0.55); Line(card, 0, -height + 1, width, 1, 0.3)
        Line(card, 0, 0, 1, height, 0.3); Line(card, width - 1, 0, 1, height, 0.3)
        if title then
            Text(card, title, 14, -11, "GameFontNormal")
            Line(card, 10, -30, width - 20, 1, 0.25)
        end
        return card
    end
    local function Button(parent, text, x, y, width, onClick, height)
        local button = CreateFrame("Button", nil, parent, "UIPanelButtonTemplate")
        button:SetPoint("TOPLEFT", x, y)
        button:SetSize(width, height or 22)
        button:SetText(text)
        button:SetScript("OnClick", onClick)
        if skin then skin.Button(button) end
        return button
    end
    local checks = {}
    local function Check(parent, key, text, x, y, width)
        local check = CreateFrame("CheckButton", nil, parent, "UICheckButtonTemplate")
        check:SetPoint("TOPLEFT", x, y)
        check:SetSize(26, 26)
        local label = check.Text or check.text
        label:SetFontObject("GameFontHighlight")
        label:SetText(text)
        label:SetWidth(width or 320)
        label:SetJustifyH("LEFT")
        check:SetScript("OnClick", function(self) A.SetOption(key, self:GetChecked() == true) end)
        check.label = label
        checks[#checks + 1] = {key = key, check = check}
        return check
    end
    local function SetCheckEnabled(check, enabled)
        check:SetEnabled(enabled)
        if enabled then check.label:SetTextColor(1, 1, 1) else check.label:SetTextColor(unpack(DIM)) end
    end
    -- [-] value [+]
    local function Stepper(parent, x, y, valueWidth, onStep)
        local stepper = {}
        stepper.minus = Button(parent, "-", x, y, 24, function() onStep(-1) end)
        stepper.value = parent:CreateFontString(nil, "ARTWORK", "GameFontHighlight")
        stepper.value:SetPoint("TOPLEFT", x + 24, y - 4)
        stepper.value:SetWidth(valueWidth)
        stepper.value:SetJustifyH("CENTER")
        stepper.plus = Button(parent, "+", x + 24 + valueWidth, y, 24, function() onStep(1) end)
        function stepper:SetEnabled(enabled)
            self.minus:SetEnabled(enabled); self.plus:SetEnabled(enabled)
            if enabled then self.value:SetTextColor(1, 1, 1) else self.value:SetTextColor(unpack(DIM)) end
        end
        return stepper
    end
    local function Tooltip(owner, text)
        owner:SetScript("OnEnter", function(self)
            if not GameTooltip then return end
            GameTooltip:SetOwner(self, "ANCHOR_RIGHT")
            GameTooltip:SetText(type(text) == "function" and text() or text, 1, 1, 1, 1, true)
            GameTooltip:Show()
        end)
        owner:SetScript("OnLeave", function() if GameTooltip then GameTooltip:Hide() end end)
    end
    -- A person's icon color as it would look on a sample player (a Paladin).
    local function IconPreviewColor(person)
        local mode = A.IconColorMode("people", person)
        if mode == "class" then
            local class = RAID_CLASS_COLORS and RAID_CLASS_COLORS.PALADIN
            return class and {class.r, class.g, class.b} or {0.96, 0.55, 0.73}
        end
        if mode == "name" then return {0.4, 0.7, 1} end
        return A.IconColor("people", person)
    end
    -- A color button shows the swatch, or "Class" / "Name" for follow modes.
    local function ShowColorChoice(button, mode, color, enabled)
        local follow = mode == "class" and "Class" or mode == "name" and "Name" or ""
        button:SetText(follow)
        button.swatch:SetShown(follow == "")
        button.swatch:SetColorTexture(color[1], color[2], color[3])
        button.swatch:SetAlpha(enabled and 1 or 0.4)
    end
    -- One-of-several buttons: the selected one is washed gold.
    local function Segmented(parent, x, y, width, choices, get, set)
        local buttons, left = {}, x
        for i, choice in ipairs(choices) do
            local button = Button(parent, choice[1], left, y, choice[3] or width, function() set(choice[2]) end)
            left = left + (choice[3] or width) + 6
            button.wash = button:CreateTexture(nil, "ARTWORK")
            button.wash:SetPoint("TOPLEFT", 4, -4); button.wash:SetPoint("BOTTOMRIGHT", -4, 4)
            button.wash:SetColorTexture(1, 0.72, 0.2, 0.2)
            buttons[i] = button
        end
        function buttons:Update(enabled)
            local current = get()
            for i, choice in ipairs(choices) do
                local button, selected = self[i], choice[2] == current
                button.wash:SetShown(selected)
                button:SetEnabled(enabled ~= false) -- before coloring: disabling swaps the font object
                if selected then button:GetFontString():SetTextColor(unpack(GOLD)) else button:GetFontString():SetTextColor(0.9, 0.9, 0.9) end
            end
        end
        return buttons
    end

    -- Header, content and footer ------------------------------------------
    local content = CreateFrame("Frame", nil, frame)
    content:SetPoint("TOPLEFT", 26, -42)
    content:SetPoint("BOTTOMRIGHT", -22, 50)
    Text(content, "People", 4, -2, "GameFontNormalLarge")
    -- Your own journal: what this character lives through, alone or with others.
    local myJournal = Button(content, "My journal", 92, 0, 104, function() if A.OpenSelfJournal then A.OpenSelfJournal() end end, 20)
    Tooltip(myJournal, "Your own journal: everything this character lives through, alone or with others (also /cj me).")
    Note(content, "Players and NPCs you want to remember: display names, their own icon, a note, and the journal.", 4, -26, 560)
    local status = content:CreateFontString(nil, "ARTWORK", "GameFontHighlightSmall")
    status:SetPoint("TOPRIGHT", -4, -6)
    status:SetJustifyH("RIGHT")
    Line(content, 0, -46, W - 48, 1, 0.45)
    OnRefresh(function()
        if not db.enabled then status:SetText("|cffff6040Companion Journal is off|r")
        else status:SetText("|cff808080v" .. tostring(A.version) .. "|r") end
    end)
    local enable = Check(frame, "enabled", "Enable Companion Journal", 22, -(H - 44), 240)
    enable:ClearAllPoints(); enable:SetPoint("BOTTOMLEFT", 22, 14)
    -- "Names | Journal": the two windows of the suite, one switch (with Forever Names installed).
    local journalHere = Button(frame, "Journal", 0, 0, 90, nil, 24)
    journalHere:ClearAllPoints(); journalHere:SetPoint("BOTTOMRIGHT", -126, 14)
    journalHere:SetEnabled(false)
    local names = Button(frame, "Names", 0, 0, 90, function()
        local api = A.Names()
        if api and api.Open then api.Open(); frame:Hide() end
    end, 24)
    names:ClearAllPoints(); names:SetPoint("RIGHT", journalHere, "LEFT", -4, 0)
    Tooltip(names, "Forever Names: how names look on nameplates.")
    OnRefresh(function()
        local api = A.Names()
        local has = api ~= nil and api.Open ~= nil
        names:SetShown(has); journalHere:SetShown(has)
    end)
    local close = Button(frame, "Close", 0, 0, 100, function() frame:Hide() end, 24)
    close:ClearAllPoints(); close:SetPoint("BOTTOMRIGHT", -18, 14)
    local page = CreateFrame("Frame", nil, content)
    page:SetPoint("TOPLEFT", 0, -56)
    page:SetPoint("BOTTOMRIGHT", 0, 0)

    -- Three views: this character's list, the people of your other characters,
    -- and the list-wide options.
    local view, othersView = "list"
    local function CharacterName(key) return key and A.CharacterName and A.CharacterName(key) or "this character" end

    -- The list and its options --------------------------------------------------
    do
        local ROWS = 8
        local selected, listPage, removeArmed, clearArmed = nil, 1, false, false
        local Sorted -- defined below; the Remove button needs it
        local circle = "companion"
        local circleNames = {companion = "companions", acquaintance = "acquaintances", campfire = "from the campfire", npc = "NPCs", rival = "rivals",
            blocked = "never added automatically"}
        local circleTitles = {companion = "Companions", acquaintance = "Acquaintances", campfire = "Campfire", rival = "Rivals"}
        local function EditBox(parent, x, y, width, maxLetters)
            local box = CreateFrame("EditBox", nil, parent, "InputBoxTemplate")
            box:SetPoint("TOPLEFT", x + 6, y)
            box:SetSize(width - 6, 22)
            box:SetAutoFocus(false)
            box:SetMaxLetters(maxLetters or 60)
            box:SetScript("OnEscapePressed", function(self) self:ClearFocus(); A.RefreshOptions() end)
            return box
        end
        -- Two views: the list (with the selected person) and the list-wide options.
        local listView = CreateFrame("Frame", nil, page)
        listView:SetAllPoints(page)
        local optionsView = CreateFrame("Frame", nil, page)
        optionsView:SetAllPoints(page)
        optionsView:Hide()
        othersView = CreateFrame("Frame", nil, page)
        othersView:SetAllPoints(page)
        othersView:Hide()
        -- Sits in the page header row, right of the title.
        local views = Segmented(page, 482, 54, 70, {{"List", "list"}, {"My characters", "others", 110}, {"Options", "options"}},
            function() return view end, function(value) view = value; A.RefreshOptions() end)
        Tooltip(views[1], "This character's people.")
        Tooltip(views[2], "The people your other characters know: see them, read their journals, and add them to this character.")
        local list = Card(listView, nil, 0, 0, 390, 432)
        local search = EditBox(list, 14, -12, 220, 40)
        local searchHint = Note(list, "Search", 26, -16)
        search:SetScript("OnTextChanged", function() listPage = 1; A.RefreshOptions() end)
        local addTarget = Button(list, "Add my target", 250, -12, 126, function()
            local person, key = A.AddTargetPerson()
            if person then A.SelectPerson(key) end
        end)
        Tooltip(addTarget, "Adds the player (as a companion) or NPC you have targeted.")
        local circles = Segmented(list, 10, -40, 60, {{"Companions", "companion", 84}, {"Acquaintances", "acquaintance", 98},
            {"Campfire", "campfire", 68}, {"NPCs", "npc", 46}, {"Rivals", "rival", 56}},
            function() return circle end, function(value)
                circle, listPage, clearArmed = value, 1, false
                A.RefreshOptions()
            end)
        local rows = {}
        for i = 1, ROWS do
            local row = CreateFrame("Button", nil, list)
            row:SetPoint("TOPLEFT", 10, -72 - (i - 1) * 34)
            row:SetSize(370, 32)
            row.wash = row:CreateTexture(nil, "BACKGROUND")
            row.wash:SetAllPoints(); row.wash:SetColorTexture(1, 0.72, 0.2, 0.16)
            local hover = row:CreateTexture(nil, "HIGHLIGHT")
            hover:SetAllPoints(); hover:SetColorTexture(1, 1, 1, 0.06)
            row.icon = row:CreateTexture(nil, "ARTWORK")
            row.icon:SetPoint("LEFT", 6, 0); row.icon:SetSize(16, 16)
            row.name = Text(row, "", 30, -3, "GameFontHighlight", 290)
            row.name:SetWordWrap(false)
            row.detail = Text(row, "", 30, -18, "GameFontHighlightSmall", 290, NOTE)
            row.detail:SetWordWrap(false)
            row.classIcon = row:CreateTexture(nil, "ARTWORK")
            row.classIcon:SetPoint("RIGHT", -8, 0); row.classIcon:SetSize(16, 16)
            row.level = row:CreateFontString(nil, "ARTWORK", "GameFontHighlightSmall")
            row.level:SetPoint("RIGHT", -30, 0); row.level:SetJustifyH("RIGHT")
            row.level:SetTextColor(0.75, 0.75, 0.75)
            row:RegisterForClicks("LeftButtonUp", "RightButtonUp")
            row:SetScript("OnClick", function(self, button)
                local key = self.key
                if circle == "blocked" then selected = self.key; A.RefreshOptions() else A.SelectPerson(self.key) end
                if button == "RightButton" and circle ~= "blocked" then A.OpenPersonMenu(self, key) end
            end)
            -- Double-click: their journal (players; NPCs have none).
            row:SetScript("OnDoubleClick", function(self, button)
                if button == "LeftButton" and circle ~= "blocked" and self.key and A.OpenJournal then A.OpenJournal(self.key) end
            end)
            rows[i] = row
        end
        local prev = Button(list, "<", 14, -354, 32, function() listPage = listPage - 1; A.RefreshOptions() end)
        local pageText = Text(list, "", 52, -358, "GameFontHighlightSmall", 100)
        local nextPage = Button(list, ">", 158, -354, 32, function() listPage = listPage + 1; A.RefreshOptions() end)
        local count = Text(list, "", 200, -358, "GameFontHighlightSmall", 176, NOTE)
        count:SetJustifyH("RIGHT")
        local addName = EditBox(list, 14, -396, 240, 60)
        local addHint = Note(list, "Name or Name-Realm", 26, -400)
        local function AddTyped()
            local text = addName:GetText() or ""
            if text:match("%S") then
                local _, key = A.AddPerson((text:gsub("^%s+", ""):gsub("%s+$", "")))
                addName:SetText(""); addName:ClearFocus()
                if key then A.SelectPerson(key) end
            end
        end
        addName:SetScript("OnEnterPressed", AddTyped)
        addName:SetScript("OnTextChanged", function(self) addHint:SetShown((self:GetText() or "") == "") end)
        local addButton = Button(list, "Add", 262, -396, 114, AddTyped)
        local clearAll = Button(list, "", 14, -396, 240, function()
            if not clearArmed then clearArmed = true; A.RefreshOptions(); return end
            clearArmed = false
            selected = nil
            A.RemoveCircle(circle)
        end)
        local npcHint = Note(list, "Add NPCs with Add my target or the \"Add target to Companion Journal\" key binding.", 14, -394, 362)

        -- Only the selected person here; list-wide options are under Options.
        local detail = Card(listView, "Selected person", 400, 0, 410, 432)
        local optionsLink = Button(detail, "Options", 300, -6, 96, function() view = "options"; A.RefreshOptions() end, 20)
        -- (the book's Settings page opens the classic window on its options)
        function A.ShowOptionsView(name)
            if db.cjLayout == "b" and A.OpenBookPeople then
                if name == "options" then A.OpenBookSettings("world") else A.OpenBookPeople(nil, nil, name == "others" and "others" or "here") end
                return
            end
            view = name or "list"; A.RefreshOptions()
        end
        local journalButton = Button(detail, "Journal", 200, -6, 96, function()
            if selected and A.OpenJournal then A.OpenJournal(selected) end
        end, 20)
        Tooltip(journalButton, "Your adventures with this person, as a journal. Also: double-click them in the list, or right-click.")
        Tooltip(optionsLink, "What the People list shows in the world, and how people are added (applies to everyone).")

        -- Display names on plates, and "other icons", come from Forever Names' labels:
        -- without it, those options are not offered (the rows below move up by o).
        local withNames = A.Names() ~= nil
        local o = withNames and 0 or 52
        local shows = Card(optionsView, "What your list shows in the world", 0, 0, 400, 332 - o)
        if withNames then
            Check(shows, "peopleRename", "Their display name", 12, -36, 360)
            Note(shows, "Replaces their name on plates, for people you gave one.", 44, -60, 340)
        end
        Check(shows, "peopleIcons", withNames and "Their icon (before other icons)" or "Their icon", 12, -88 + o, 360)
        Note(shows, "Each person has their own icon, or None. This switch shows or hides them all.", 44, -112 + o, 340)
        -- With Forever Names, the icon sits among its icons, and its place is set there.
        local iconSide
        if withNames then
            Text(shows, "Position", 44, -146 + o, "GameFontHighlightSmall")
            local where = Button(shows, "Set in Forever Names", 120, -142 + o, 170, function()
                local api = A.Names()
                if api and api.Open then api.Open() end
            end, 22)
            Tooltip(where, "Before or after the name, or with the other icons: Forever Names > Players > Icons.")
        else
            Text(shows, "Position", 44, -146 + o, "GameFontHighlightSmall")
            iconSide = Segmented(shows, 120, -142 + o, 60, {{"Before", "left", 66}, {"After", "right", 60}},
                function() return db.peopleIconPosition == "right" and "right" or "left" end,
                function(value) A.SetOption("peopleIconPosition", value) end)
        end
        Text(shows, "New entries start with", 44, -176 + o, "GameFontHighlightSmall")
        local newIcon = Button(shows, "", 196, -172 + o, 60, nil, 26)
        newIcon.icon = newIcon:CreateTexture(nil, "ARTWORK")
        newIcon.icon:SetPoint("CENTER"); newIcon.icon:SetSize(18, 18)
        newIcon:SetScript("OnClick", function(self)
            A.PickGlyph(self, db.peopleNewGlyph or "diamond", db.colors.people, function(name) A.SetOption("peopleNewGlyph", name) end, true)
        end)
        Note(shows, "For people and NPCs you add yourself. Groupmates and campfire people: see Adding people.", 44, -206 + o, 340)
        Check(shows, "peopleTooltip", "My note and last seen on their tooltip", 12, -236 + o, 360)
        Note(shows, "Only for people with a note or a \"last seen\" record.", 44, -260 + o, 340)
        Check(shows, "peopleLastSeen", "Remember when and where I last saw them", 12, -288 + o, 360)
        Note(shows, "Updated at most every five minutes per person.", 44, -312 + o, 340)

        -- The journal (Forever Names had it on its Immersion page).
        local journalCard = Card(optionsView, "Journal", 0, -342 + o, 400, 90)
        local journalCheck = Check(journalCard, "peopleJournal", "Keep a journal of our adventures", 12, -36, 360)
        Tooltip(journalCheck, "For people in your list, and groupmates you add when the group ends: time grouped, dungeons, bosses, quests you both had, campfires and levels. Nothing is recorded while this is off. Open one: double-click someone in the list.")
        local journalSeen = Check(journalCard, "journalSeen", "Also when we cross paths", 40, -60, 164)
        Text(journalCard, "Writing", 238, -64, "GameFontHighlightSmall")
        local writing = Segmented(journalCard, 288, -60, 50, {{"Simple", "simple"}, {"Story", "story"}},
            function() return A.JournalVoice and A.JournalVoice() or "simple" end,
            function(value) db.journalVoice = value; if A.RefreshJournal then A.RefreshJournal() end; A.RefreshOptions() end)
        Tooltip(writing[1], "The plain record: what happened, as it happened. No storytelling.")
        Tooltip(writing[2], "Your days together told as a tale by your character's storyteller. Also switchable in the journal's header.")
        OnRefresh(function() writing:Update(true) end)
        Tooltip(journalSeen, "When their name appears near you: one line per zone every few hours, and never while you travel together.")
        local adding = Card(optionsView, "Adding people", 410, 0, 400, 432)
        Check(adding, "peopleAutoGroup", "Everyone I group with, as acquaintances", 12, -36, 360)
        Note(adding, "Checked when your group changes. People already in your list stay where they are.", 44, -60, 340)
        local groupIcon = Check(adding, "peopleGroupIcon", "Give them the group icon", 40, -86, 330)
        Tooltip(groupIcon, "Set when they are added from your group, in soft blue. Change or remove it per person afterwards.")
        local groupPrompt = Check(adding, "peopleGroupPrompt", "Ask me when they leave, instead", 40, -110, 330)
        Tooltip(groupPrompt, "Nobody is added automatically. When groupmates leave (or you leave), a small popup lists them: add to Companions, add to Acquaintances, or don't add. It waits until combat ends.")
        Text(adding, "Popup", 72, -140, "GameFontHighlightSmall")
        local promptStyle = Segmented(adding, 120, -136, 90, {{"Cards", "cards", 76}, {"Legacy", "legacy", 76}, {"Minimal", "minimal", 80}},
            function() return (db.groupPromptStyle == "loot" and "cards") or db.groupPromptStyle or "cards" end,
            function(value) db.groupPromptStyle = value; if A.RefreshGroupPrompt then A.RefreshGroupPrompt() end; A.RefreshOptions() end)
        Check(adding, "peopleAutoCampfire", "People who sit at a campfire with me (experimental)", 12, -168, 370)
        Note(adding, "While your campfire timer runs: friendly players within about 28 yards with the same timer. Needs readable auras (not in combat or instances).", 44, -192, 340)
        local campfireIcon = Check(adding, "peopleCampfireIcon", "Give them the fire icon", 40, -230, 330)
        Tooltip(campfireIcon, "Set when they are added at the campfire, in orange. Change or remove it per person afterwards.")
        Check(adding, "peopleMenu", "An \"add to People\" entry in right-click menus", 12, -260, 360)
        Note(adding, "Players and your target. Not in the gamepad interface, where the game blocks addon menu entries.", 44, -284, 340)
        Line(adding, 10, -318, 380, 1, 0.25)
        Note(adding, "Always available: \"Add my target\" on the list, /cj tag [note], and the key binding \"Add target to Companion Journal\" (Key Bindings > Companion Journal). Test the popup: /cj testleave.", 14, -326, 372)
        -- People you chose never to add again (a view of the list).
        Text(adding, "Never added automatically", 14, -378, "GameFontNormalSmall")
        local blockedCount = Note(adding, "", 14, -396, 220)
        Button(adding, "Show the list", 244, -384, 142, function()
            view, circle, listPage, selected = "list", "blocked", 1, nil
            A.RefreshOptions()
        end)
        local who = Text(detail, "", 14, -44, "GameFontNormal", 380)
        local editor = CreateFrame("Frame", nil, detail)
        editor:SetAllPoints(detail)
        Text(editor, "Display name", 14, -80, "GameFontHighlight")
        local display = EditBox(editor, 130, -76, 266, 60)
        Text(editor, "Icon", 14, -116, "GameFontHighlight")
        local glyph = Button(editor, "", 130, -112, 48, nil, 26)
        glyph.icon = glyph:CreateTexture(nil, "ARTWORK")
        glyph.icon:SetPoint("CENTER"); glyph.icon:SetSize(18, 18)
        local color = Button(editor, "", 182, -112, 60, nil, 26)
        local function Current() return circle ~= "blocked" and selected and A.People[selected] or nil end
        local function CurrentBlocked() return circle == "blocked" and selected and db.peopleBlocked[selected] or nil end
        -- This person's icon size ("Auto" = the normal size).
        local iconSize = Stepper(editor, 250, -112, 40, function(delta)
            local person = Current()
            if not person then return end
            local current = tonumber(person.iconSize) or A.DefaultIconSize(person)
            person.iconSize = math.max(6, math.min(48, math.floor(current + 0.5) + delta * 2))
            A.Refresh()
        end)
        local iconAuto = Button(editor, "Auto", 342, -112, 54, function()
            local person = Current()
            if person then person.iconSize = nil; A.Refresh() end
        end, 26)
        Tooltip(iconAuto, "Use the normal icon size.")
        color.swatch = color:CreateTexture(nil, "ARTWORK")
        color.swatch:SetPoint("TOPLEFT", 8, -7); color.swatch:SetPoint("BOTTOMRIGHT", -8, 7)
        Text(editor, "Note", 14, -152, "GameFontHighlight")
        local note = EditBox(editor, 130, -148, 266, 200)
        -- How the journal's storyteller refers to them.
        local pronounLabel = Text(editor, "Pronouns", 14, -188, "GameFontHighlight")
        local pronouns = Segmented(editor, 130, -184, 60, {{"They", "they"}, {"He", "he"}, {"She", "she"}},
            function()
                local person = Current()
                return person and person.pronouns or "they"
            end,
            function(value)
                local person = Current()
                if person and not person.npc then A.SetPersonPronouns(person, value) end
            end)
        for _, button in ipairs(pronouns) do Tooltip(button, "How the journal refers to them.") end
        -- For Story mode: how it began, and what they are to you.
        local function StoryValue(field, default)
            local person = Current()
            return person and person[field] or default
        end
        local function SetStory(field, value)
            local person = Current()
            if person then A.SetPersonStory(person, field, value) end
        end
        local originLabel = Text(editor, "How it began", 14, -220, "GameFontHighlight")
        local origin = Segmented(editor, 130, -216, 100, {{"On the road", "road"}, {"Together", "together"}},
            function() return StoryValue("origin", "road") end, function(value) SetStory("origin", value) end)
        Tooltip(origin[1], "You met in the game. The journal tells how.")
        Tooltip(origin[2], "You started your characters together (a partner, family, an old friend). Story mode begins where your people begin: rising in Deathknell, Northshire Abbey...")
        local bondLabel = Text(editor, "They are", 14, -252, "GameFontHighlight")
        local bond = Segmented(editor, 130, -248, 48, {{"-", "none"}, {"Spouse", "spouse"}, {"Partner", "partner"}, {"Friend", "friend"}, {"Family", "family"}},
            function() return StoryValue("bond", "none") end, function(value) SetStory("bond", value) end)
        for _, button in ipairs(bond) do Tooltip(button, "What they are to you, for Story mode (your wife, your oldest friend...).") end
        -- NPCs: everyone's by default; a class trainer can stay with one character.
        local onlyHere = CreateFrame("CheckButton", nil, editor, "UICheckButtonTemplate")
        onlyHere:SetPoint("TOPLEFT", 10, -184); onlyHere:SetSize(26, 26)
        onlyHere.label = onlyHere.Text or onlyHere.text
        onlyHere.label:SetFontObject("GameFontHighlight"); onlyHere.label:SetWidth(340); onlyHere.label:SetJustifyH("LEFT")
        onlyHere:SetScript("OnClick", function(self)
            local person = Current()
            if person and person.npc then A.SetNPCOnlyHere(person, self:GetChecked() == true) end
        end)
        Tooltip(onlyHere, "Hide this NPC on your other characters (a class trainer, for example). Off: every character sees them.")
        local seen = Note(editor, "", 14, -284, 382)
        local effect = Note(editor, "", 14, -330, 382)
        -- Move between the three player categories (NPCs stay put).
        local moveLabel = Text(editor, "Move to", 14, -366, "GameFontHighlight")
        local moves = {}
        for i = 1, 3 do
            moves[i] = Button(editor, "", 80 + (i - 1) * 106, -362, 100, function(self)
                local person = Current()
                if not person or person.npc or not self.target then return end
                A.MovePerson(selected, self.target)
                circle = self.target
                A.SelectPerson(selected)
            end)
        end
        local remove = Button(editor, "Remove", 14, -396, 190, nil)
        local neverArmed = false
        local never = Button(editor, "Never add again", 212, -396, 184, nil)
        Tooltip(never, "Remove them and never add them automatically again (group or campfire). Adding them yourself allows them again.")
        -- Blocked view: the name and an "Allow again" button.
        local blockedInfo = CreateFrame("Frame", nil, detail)
        blockedInfo:SetAllPoints(detail)
        local blockedText = Note(blockedInfo, "", 14, -80, 382)
        local allow = Button(blockedInfo, "Allow again", 14, -396, 190, nil)
        Tooltip(allow, "Group and campfire adding may add them again.")

        local function Save(field, box)
            local person = Current()
            if not person then return end
            local text = (box:GetText() or ""):gsub("^%s+", ""):gsub("%s+$", "")
            person[field] = text ~= "" and text or nil
            A.Refresh()
        end
        for field, box in pairs({display = display, note = note}) do
            box:SetScript("OnEnterPressed", function(self) Save(field, self); self:ClearFocus() end)
            box:SetScript("OnEditFocusLost", function(self) Save(field, self) end)
        end
        glyph:SetScript("OnClick", function(self)
            local person = Current()
            if not person then return end
            A.PickGlyph(self, A.IconGlyph("people", person), A.IconColor("people", person), function(name) person.glyph = name; A.Refresh() end, true)
        end)
        color:SetScript("OnClick", function(self)
            local person = Current()
            if person then A.PickIconColor("people", self, person) end
        end)
        local function NextAfter(key)
            local keys, nextKey = Sorted(), nil
            for i, k in ipairs(keys) do
                if k == key then nextKey = keys[i + 1] or keys[i - 1] end
            end
            return nextKey
        end
        never:SetScript("OnClick", function()
            if not Current() then return end
            if not neverArmed then neverArmed = true; A.RefreshOptions(); return end
            neverArmed = false
            local key = selected
            local nextKey = NextAfter(key)
            selected = nil
            A.BlockPerson(key)
            if nextKey and A.People[nextKey] then A.SelectPerson(nextKey) end
        end)
        allow:SetScript("OnClick", function()
            if not CurrentBlocked() then return end
            local key = selected
            local nextKey = NextAfter(key)
            A.UnblockPerson(key)
            selected = nextKey
            A.RefreshOptions()
        end)
        remove:SetScript("OnClick", function()
            if not selected then return end
            if not removeArmed then removeArmed = true; A.RefreshOptions(); return end
            removeArmed = false
            local key = selected
            -- Select the next entry of the same list (or the previous one at
            -- the end), so many people can be removed in a row.
            local keys, nextKey = Sorted(), nil
            for i, k in ipairs(keys) do
                if k == key then nextKey = keys[i + 1] or keys[i - 1] end
            end
            selected = nil
            A.RemovePerson(key)
            if nextKey and A.People[nextKey] then A.SelectPerson(nextKey) end
        end)

        function Sorted()
            local filter = (search:GetText() or ""):lower()
            local keys = {}
            if circle == "blocked" then
                for key, entry in pairs(db.peopleBlocked or {}) do
                    if filter == "" or (entry.name or key):lower():find(filter, 1, true) then keys[#keys + 1] = key end
                end
                table.sort(keys, function(a, b)
                    return (db.peopleBlocked[a].name or a):lower() < (db.peopleBlocked[b].name or b):lower()
                end)
                return keys
            end
            -- This character's people (each character has their own list).
            local byKey = {}
            for key, person in A.EachPerson() do
                local label = ((person.display or "") .. " " .. (person.name or key)):lower()
                if A.PersonCircle(person) == circle and (filter == "" or label:find(filter, 1, true)) then
                    keys[#keys + 1] = key
                    byKey[key] = person
                end
            end
            table.sort(keys, function(a, b)
                local pa, pb = byKey[a], byKey[b]
                return (pa.display or pa.name or a):lower() < (pb.display or pb.name or b):lower()
            end)
            return keys
        end
        function A.SelectPerson(key)
            if db.cjLayout == "b" and A.OpenBookPeople then A.OpenBookPeople(key); return end
            -- Someone only your other characters know: shown under My characters.
            if key and not A.People[key] and A.SelectOther then A.SelectOther(key); return end
            if not key or not A.People[key] then return end
            -- Finish an edit in progress: it saves to the person it belongs to.
            display:ClearFocus(); note:ClearFocus()
            view = "list"
            selected, removeArmed, neverArmed = key, false, false
            circle = A.PersonCircle(A.People[key])
            local keys = Sorted()
            for i, k in ipairs(keys) do
                if k == key then listPage = math.floor((i - 1) / ROWS) + 1 end
            end
            A.RefreshOptions()
            -- An open journal follows the selection.
            local person = A.People[key]
            if A.JournalIsOpen and A.JournalIsOpen() and person and not person.npc then A.OpenJournal(key) end
        end
        function A.SelectPeopleCircle(value)
            if db.cjLayout == "b" and A.OpenBookPeople then A.OpenBookPeople(nil, value); return end
            view, circle, listPage, selected = "list", value, 1, nil
            A.RefreshOptions()
        end
        -- While the window is open, targeting someone from the list opens them.
        local follow = CreateFrame("Frame")
        follow:RegisterEvent("PLAYER_TARGET_CHANGED")
        follow:SetScript("OnEvent", function()
            if not frame:IsShown() then return end
            local person, key = A.FindPerson("target")
            if person and key then A.SelectPerson(key) end
        end)
        A.optionsTargetFollower = follow
        OnRefresh(function()
            searchHint:SetShown((search:GetText() or "") == "")
            local keys = Sorted()
            local pageCount = math.max(1, math.ceil(#keys / ROWS))
            listPage = math.max(1, math.min(pageCount, listPage))
            for i, row in ipairs(rows) do
                local key = keys[(listPage - 1) * ROWS + i]
                local blocked = circle == "blocked" and key and db.peopleBlocked[key]
                local person = not blocked and key and A.People[key]
                row.key = key
                row:SetShown(person or blocked and true or false)
                row.classIcon:Hide(); row.level:SetText("")
                if blocked then
                    row.icon:Hide()
                    row.name:SetText(blocked.name or key)
                    row.detail:SetText(A.DescribeBlocked(blocked))
                    row.wash:SetShown(key == selected)
                end
                if person then
                    local tint = IconPreviewColor(person)
                    local rowGlyph = A.IconGlyph("people", person)
                    row.icon:SetShown(rowGlyph ~= "none")
                    row.icon:SetTexture(A.GlyphPath(rowGlyph))
                    row.icon:SetVertexColor(tint[1], tint[2], tint[3])
                    local label = person.display and (person.display .. "  |cff9d9d9d" .. person.name .. "|r") or person.name
                    row.name:SetText(label)
                    if not person.npc then
                        A.SetPersonClassIcon(row.classIcon, person.class)
                        row.level:SetText(person.level and tostring(person.level) or "")
                    end
                    row.detail:SetText(person.note or (A.DescribeSeen(person) and ("Last seen " .. A.DescribeSeen(person))) or A.DescribeMet(person) or "")
                    row.wash:SetShown(key == selected)
                end
            end
            prev:SetEnabled(listPage > 1); nextPage:SetEnabled(listPage < pageCount)
            pageText:SetText(listPage .. " / " .. pageCount)
            circles:Update(true)
            views:Update(true)
            local blockedTotal = 0
            for _ in pairs(db.peopleBlocked or {}) do blockedTotal = blockedTotal + 1 end
            blockedCount:SetText(blockedTotal == 0 and "Nobody yet. Use \"Never add again\" on someone in the list."
                or (blockedTotal .. (blockedTotal == 1 and " person is" or " people are") .. " skipped by group and campfire adding."))
            listView:SetShown(view == "list"); optionsView:SetShown(view == "options"); othersView:SetShown(view == "others")
            local newGlyph = db.peopleNewGlyph or "diamond"
            newIcon:SetEnabled(db.peopleIcons and true or false)
            newIcon.icon:SetShown(newGlyph ~= "none")
            newIcon.icon:SetTexture(A.GlyphPath(newGlyph))
            newIcon.icon:SetVertexColor(unpack(db.colors.people))
            newIcon:SetText(newGlyph == "none" and "None" or "")
            if iconSide then iconSide:Update(db.peopleIcons and true or false) end
            SetCheckEnabled(campfireIcon, db.peopleAutoCampfire and true or false)
            SetCheckEnabled(groupIcon, db.peopleAutoGroup and true or false)
            SetCheckEnabled(groupPrompt, db.peopleAutoGroup and true or false)
            promptStyle:Update(true)
            SetCheckEnabled(journalSeen, db.peopleJournal and true or false)
            count:SetText(#keys .. " " .. circleNames[circle])
            addName:SetShown(circle == "companion"); addButton:SetShown(circle == "companion")
            local blockedView = circle == "blocked"
            editor:SetShown(not blockedView); blockedInfo:SetShown(blockedView)
            local entry = CurrentBlocked()
            allow:SetEnabled(entry ~= nil)
            blockedText:SetText(entry and (A.DescribeBlocked(entry) .. ".\n\nAdding them yourself (Add my target, a typed name, /cj tag) also allows them again.")
                or "People you chose never to add again. Group and campfire adding skip them. Select one to allow them again.")
            never:SetShown(false)
            addHint:SetShown(circle == "companion" and (addName:GetText() or "") == "")
            clearAll:SetShown(circle == "acquaintance" or circle == "campfire")
            clearAll:SetEnabled(#keys > 0)
            clearAll:SetText(clearArmed and "Click again to remove them all"
                or (circle == "campfire" and "Remove everyone from Campfire" or "Remove all acquaintances"))
            npcHint:SetShown(circle == "npc")
        end)
        -- The selected person (a second updater: Lua 5.1 allows 60 upvalues
        -- per function, and the list alone uses most of them).
        OnRefresh(function()
            local entry, blockedView = CurrentBlocked(), circle == "blocked"
            local person = Current()
            -- Drop a selection that no longer exists (in either view).
            if not person and not CurrentBlocked() then selected = nil end
            local has = person ~= nil
            for _, control in ipairs({display, note, glyph, color, remove}) do control:SetEnabled(has) end
            local movable = has and not person.npc
            onlyHere:SetShown(has and person.npc and true or false)
            onlyHere:SetChecked(has and person.npc and person.only ~= nil or false)
            onlyHere.label:SetText("Only on " .. CharacterName(A.Me()))
            moveLabel:SetShown(movable)
            pronounLabel:SetShown(movable)
            for _, button in ipairs(pronouns) do button:SetShown(movable) end
            pronouns:Update(movable)
            originLabel:SetShown(movable); bondLabel:SetShown(movable)
            for _, button in ipairs(origin) do button:SetShown(movable) end
            for _, button in ipairs(bond) do button:SetShown(movable) end
            origin:Update(movable); bond:Update(movable)
            local targets = {}
            if movable then
                for _, key in ipairs({"companion", "acquaintance", "campfire", "rival"}) do
                    if key ~= A.PersonCircle(person) then targets[#targets + 1] = key end
                end
            end
            for i, button in ipairs(moves) do
                button.target = targets[i]
                button:SetShown(targets[i] ~= nil)
                if targets[i] then button:SetText(circleTitles[targets[i]]) end
            end
            local summary = has and not person.npc and A.PersonSummary and A.PersonSummary(person) or ""
            who:SetText(entry and entry.name or has and (person.name .. (summary ~= "" and ("  |cff9d9d9d" .. summary .. "|r") or ""))
                or (blockedView and "Never added automatically") or "Select someone on the left, or add your target.")
            journalButton:SetEnabled(has and not person.npc and true or false)
            never:SetShown(has and not person.npc)
            never:SetText(neverArmed and "Click again to confirm" or "Never add again")
            if not display:HasFocus() then display:SetText(has and person.display or "") end
            if not note:HasFocus() then note:SetText(has and person.note or "") end
            local tint = has and IconPreviewColor(person) or {0.5, 0.5, 0.5}
            local glyphName = has and A.IconGlyph("people", person) or "heart"
            glyph.icon:SetShown(glyphName ~= "none")
            glyph:SetText(glyphName == "none" and "None" or "")
            glyph.icon:SetTexture(A.GlyphPath(glyphName))
            glyph.icon:SetVertexColor(tint[1], tint[2], tint[3])
            color:SetEnabled(has and glyphName ~= "none")
            local sized = has and glyphName ~= "none"
            iconSize:SetEnabled(sized); iconAuto:SetEnabled(sized and person.iconSize ~= nil)
            iconSize.value:SetText(has and person.iconSize and tostring(person.iconSize) or "Auto")
            if has and person.iconSize then iconSize.value:SetTextColor(1, 1, 1) else iconSize.value:SetTextColor(0.6, 0.6, 0.6) end
            ShowColorChoice(color, has and A.IconColorMode("people", person) or "custom",
                has and A.IconColor("people", person) or tint, has)
            local lines = {}
            if has and person.added and date then lines[#lines + 1] = "Added " .. date("%Y-%m-%d", person.added) end
            if has and A.DescribeMet(person) then lines[#lines + 1] = A.DescribeMet(person) end
            if has and A.DescribeSeen(person) then lines[#lines + 1] = "Last seen " .. A.DescribeSeen(person) end
            -- Your other characters who know them too (their journals: Journal > Kept by).
            if has and not person.npc and A.OtherKnowers then
                local knowers = {}
                for _, knower in ipairs(A.OtherKnowers(selected)) do knowers[#knowers + 1] = knower.name end
                if #knowers > 0 then lines[#lines + 1] = "Also known by " .. table.concat(knowers, ", ") end
            end
            seen:SetText(table.concat(lines, "\n"))
            -- Say which list options actually show this entry in the world.
            local shown = {}
            if db.peopleRename and A.Names() then shown[#shown + 1] = "display name" end
            if db.peopleIcons and (not has or A.IconGlyph("people", person) ~= "none") then shown[#shown + 1] = "icon" end
            if db.peopleTooltip and (not has or (person.note and person.note ~= "") or (db.peopleLastSeen and A.DescribeSeen(person))) then shown[#shown + 1] = "tooltip" end
            effect:SetText(#shown > 0 and ("In the world: " .. table.concat(shown, ", ") .. ".")
                or "Nothing from this list shows in the world yet: turn options on under Options.")
            remove:SetText(removeArmed and "Click again to remove" or "Remove")
        end)
    end

    -- My characters: the people your other characters know ---------------------
    -- Pick one of your characters (or all), see who they know, read their
    -- journals, and add people to this character. Players of the other side
    -- stay with the character who knows them.
    do
        local ROWS = 7
        local state = {page = 1}
        local CIRCLE_TITLES = {companion = "Companion", acquaintance = "Acquaintance", campfire = "Campfire", rival = "Rival"}
        local CIRCLE_WORDS = {companion = "companion", acquaintance = "acquaintance", campfire = "campfire acquaintance", rival = "rival"}
        local listCard = Card(othersView, nil, 0, 0, 390, 432)
        local function Characters() return A.OtherCharacters and A.OtherCharacters() or {} end
        local function Step(delta)
            local list = Characters()
            local index = 0
            for i, character in ipairs(list) do if character.key == state.char then index = i end end
            index = (index + delta) % (#list + 1)
            state.char = index > 0 and list[index].key or nil
            state.page, state.selected, state.allArmed, state.status = 1, nil, false, nil
            A.RefreshOptions()
        end
        local prevChar = Button(listCard, "<", 14, -12, 28, function() Step(-1) end)
        local charName = Text(listCard, "", 48, -16, "GameFontNormal", 294)
        charName:SetJustifyH("CENTER"); charName:SetWordWrap(false)
        local nextChar = Button(listCard, ">", 348, -12, 28, function() Step(1) end)
        Tooltip(prevChar, "Your other characters (or all of them).")
        Tooltip(nextChar, "Your other characters (or all of them).")
        local recognize = Check(listCard, "peopleRecognize", "Show their people on this character too", 10, -40, 330)
        Tooltip(recognize, "Your other characters' people get a chain link beside their name on plates: gold for companions, silver for acquaintances, red for rivals (on either side: an old rival met on a new character). Their tooltip says whose they are (\"Alberich's companion\"). Campfire people: nothing. Off: each character's world is their own.")
        -- The chain links: gold for companions, silver for acquaintances (click to change).
        local links = {}
        for i, link in ipairs({{"recognizedCompanion", "Companions"}, {"recognizedAcquaintance", "Acquaintances"}, {"recognizedRival", "Rivals"}}) do
            local x = ({40, 156, 294})[i]
            local button = Button(listCard, "", x, -66, 30, nil, 22)
            button.icon = button:CreateTexture(nil, "ARTWORK")
            button.icon:SetPoint("CENTER"); button.icon:SetSize(16, 16)
            button.icon:SetTexture(A.GlyphPath("kin"))
            button.key = link[1]
            button:SetScript("OnClick", function(self)
                local original = db.colors[self.key]
                original = {original[1], original[2], original[3]}
                A.PickColor(self, original[1], original[2], original[3],
                    function(r, g, b) db.colors[self.key] = {r, g, b}; A.Refresh() end,
                    function() db.colors[self.key] = original; A.Refresh() end)
            end)
            Tooltip(button, "The chain link's color for " .. link[2]:lower() .. " of your other characters. Click to change.")
            button.label = Text(listCard, link[2], x + 36, -70, "GameFontHighlightSmall")
            links[i] = button
        end
        local rows = {}
        local Rows -- below
        for i = 1, ROWS do
            local row = CreateFrame("Button", nil, listCard)
            row:SetPoint("TOPLEFT", 10, -96 - (i - 1) * 34)
            row:SetSize(370, 32)
            row.wash = row:CreateTexture(nil, "BACKGROUND")
            row.wash:SetAllPoints(); row.wash:SetColorTexture(1, 0.72, 0.2, 0.16)
            local hover = row:CreateTexture(nil, "HIGHLIGHT")
            hover:SetAllPoints(); hover:SetColorTexture(1, 1, 1, 0.06)
            row.icon = row:CreateTexture(nil, "ARTWORK")
            row.icon:SetPoint("LEFT", 6, 0); row.icon:SetSize(16, 16)
            row.name = Text(row, "", 30, -3, "GameFontHighlight", 290)
            row.name:SetWordWrap(false)
            row.detail = Text(row, "", 30, -18, "GameFontHighlightSmall", 290, NOTE)
            row.detail:SetWordWrap(false)
            row.classIcon = row:CreateTexture(nil, "ARTWORK")
            row.classIcon:SetPoint("RIGHT", -8, 0); row.classIcon:SetSize(16, 16)
            row.level = row:CreateFontString(nil, "ARTWORK", "GameFontHighlightSmall")
            row.level:SetPoint("RIGHT", -30, 0); row.level:SetJustifyH("RIGHT")
            row.level:SetTextColor(0.75, 0.75, 0.75)
            row:SetScript("OnClick", function(self)
                state.selected, state.status, state.allArmed = self.key, nil, false
                A.RefreshOptions()
            end)
            -- Double-click: their journal, to read.
            row:SetScript("OnDoubleClick", function(self)
                if self.key and self.from and A.OpenJournal then A.OpenJournal(self.key, self.from) end
            end)
            rows[i] = row
        end
        local prevPage = Button(listCard, "<", 14, -354, 32, function() state.page = state.page - 1; A.RefreshOptions() end)
        local pageText = Text(listCard, "", 52, -358, "GameFontHighlightSmall", 100)
        local nextPage = Button(listCard, ">", 158, -354, 32, function() state.page = state.page + 1; A.RefreshOptions() end)
        local count = Text(listCard, "", 200, -358, "GameFontHighlightSmall", 176, NOTE)
        count:SetJustifyH("RIGHT")
        local empty = Note(listCard, "", 24, -104, 342)
        -- Everyone a character (or all of them) knows, companions first: the
        -- people this character can add.
        function Rows() return A.OthersPeople and A.OthersPeople(state.char) or {} end
        local function Companions(list)
            local out = {}
            for _, row in ipairs(list) do
                if row.usable and (row.rel.circle or "companion") == "companion" then out[#out + 1] = row end
            end
            return out
        end
        local importAll = Button(listCard, "", 14, -396, 362, function()
            local ready = Companions(Rows())
            if #ready == 0 then return end
            if not state.allArmed then state.allArmed = true; A.RefreshOptions(); return end
            state.allArmed = false
            local added = A.ImportFrom(state.char)
            state.status = added .. (added == 1 and " companion" or " companions") .. " added to " .. CharacterName(A.Me()) .. "'s list."
            state.selected = nil
            A.RefreshOptions()
        end)
        Tooltip(importAll, "Adds every companion shown here to this character's list (acquaintances, campfire people and rivals: one by one).")

        -- The selected person.
        local detail = Card(othersView, "Known by my other characters", 400, 0, 410, 432)
        local who = Text(detail, "", 14, -44, "GameFontNormal", 380)
        local summary = Note(detail, "", 14, -64, 382)
        local knownBy = Text(detail, "", 14, -92, "GameFontHighlight", 382)
        local shared = Note(detail, "", 14, -200, 382)
        shared:ClearAllPoints(); shared:SetPoint("TOPLEFT", knownBy, "BOTTOMLEFT", 0, -16)
        local notice = Text(detail, "", 14, -330, "GameFontHighlightSmall", 382, GOLD)
        local add = Button(detail, "", 14, -396, 190, function()
            local row = state.row
            if not row or not row.usable then return end
            local person = A.ImportPerson(row.key, row.from)
            if not person then return end
            local name = person.display or (person.name or row.key):gsub("%-.*$", "")
            local circleNames = {companion = "companions", acquaintance = "acquaintances", campfire = "campfire people", rival = "rivals"}
            state.status = name .. " added to " .. CharacterName(A.Me()) .. "'s " .. (circleNames[person.circle or "companion"] or "list") .. "."
            -- The next one in the list, to add several in a row.
            local list, nextKey = state.shown or {}, nil
            for i, other in ipairs(list) do
                if other.key == row.key then nextKey = (list[i + 1] or list[i - 1] or {}).key end
            end
            state.selected = nextKey
            A.RefreshOptions()
        end)
        local read = Button(detail, "", 212, -396, 184, function()
            local row = state.row
            if row and row.journalBy and A.OpenJournal then A.OpenJournal(row.key, row.journalBy) end
        end)
        Tooltip(read, "Their journal as that character keeps it (read only). In the journal, Kept by switches between your characters.")

        function A.SelectOther(key)
            if db.cjLayout == "b" and A.OpenBookPeople then A.OpenBookPeople(key, nil, "others"); return end
            view, state.char, state.selected, state.status = "others", nil, key, nil
            for i, row in ipairs(Rows()) do
                if row.key == key then state.page = math.floor((i - 1) / ROWS) + 1 end
            end
            A.RefreshOptions()
        end

        OnRefresh(function()
            if view ~= "others" then return end
            local characters = Characters()
            -- Just one other character: theirs, directly.
            if not state.char and #characters == 1 then state.char = characters[1].key end
            local current
            for _, character in ipairs(characters) do if character.key == state.char then current = character end end
            if state.char and not current then state.char = nil end
            local me = CharacterName(A.Me())
            if current then
                local class = current.class and ((LOCALIZED_CLASS_NAMES_MALE and LOCALIZED_CLASS_NAMES_MALE[current.class])
                    or (current.class:sub(1, 1) .. current.class:sub(2):lower()))
                local about = current.earlier and "they join its list when you log in with one" or
                    table.concat({current.faction or "", class or ""}, " "):gsub("^%s+", "")
                charName:SetText(current.name .. "  |cff9d9d9d" .. about .. "|r")
            else
                charName:SetText(#characters == 0 and "My other characters" or ("All my other characters  |cff9d9d9d(" .. #characters .. ")|r"))
            end
            prevChar:SetEnabled(#characters > 1); nextChar:SetEnabled(#characters > 1)
            for i, button in ipairs(links) do
                local tint = db.colors[button.key] or {1, 1, 1}
                button.icon:SetVertexColor(tint[1], tint[2], tint[3])
                button:SetEnabled(db.peopleRecognize and true or false)
                if db.peopleRecognize then button.label:SetTextColor(1, 1, 1) else button.label:SetTextColor(unpack(DIM)) end
                button.icon:SetAlpha(db.peopleRecognize and 1 or 0.4)
                links[i] = button
            end
            local list = Rows()
            state.shown = list
            local pageCount = math.max(1, math.ceil(#list / ROWS))
            state.page = math.max(1, math.min(pageCount, state.page or 1))
            state.row = nil
            for _, row in ipairs(list) do if row.key == state.selected then state.row = row end end
            if not state.row then state.selected = nil end
            for i, frameRow in ipairs(rows) do
                local row = list[(state.page - 1) * ROWS + i]
                frameRow.key, frameRow.from = row and row.key, row and row.from
                frameRow:SetShown(row ~= nil)
                if row then
                    local card = row.card
                    local tint = row.rel.circle == "acquaintance" and db.colors.recognizedAcquaintance
                        or row.rel.circle == "rival" and db.colors.recognizedRival or db.colors.recognizedCompanion
                    frameRow.icon:Show()
                    frameRow.icon:SetTexture(A.GlyphPath("kin"))
                    frameRow.icon:SetVertexColor(tint[1], tint[2], tint[3])
                    frameRow.icon:SetAlpha(row.usable and 1 or 0.4)
                    local name = card.name or row.key
                    frameRow.name:SetText(card.display and (card.display .. "  |cff9d9d9d" .. name .. "|r") or name)
                    if row.usable then frameRow.name:SetTextColor(1, 1, 1) else frameRow.name:SetTextColor(unpack(DIM)) end
                    local knowers = {}
                    for _, knower in ipairs(row.knowers) do knowers[#knowers + 1] = knower.name end
                    local circleTitle = CIRCLE_TITLES[row.rel.circle or "companion"] or "Companion"
                    frameRow.detail:SetText(row.usable and (circleTitle .. "  -  " .. table.concat(knowers, ", "))
                        or (row.knowers[1] and row.knowers[1].earlier and #row.knowers == 1
                            and ((card.faction or "Other") .. " side: waiting for your next " .. (card.faction or "") .. " character")
                            or ((card.faction or "Other") .. " side: stays with " .. table.concat(knowers, ", "))))
                    A.SetPersonClassIcon(frameRow.classIcon, card.class)
                    frameRow.classIcon:SetAlpha(row.usable and 1 or 0.4)
                    frameRow.level:SetText(card.level and tostring(card.level) or "")
                    frameRow.wash:SetShown(row.key == state.selected)
                end
            end
            prevPage:SetEnabled(state.page > 1); nextPage:SetEnabled(state.page < pageCount)
            prevPage:SetShown(#list > ROWS); nextPage:SetShown(#list > ROWS); pageText:SetShown(#list > ROWS)
            pageText:SetText(state.page .. " / " .. pageCount)
            local usable = 0
            for _, row in ipairs(list) do if row.usable then usable = usable + 1 end end
            count:SetText(#list == 0 and "" or (usable .. (usable == 1 and " person" or " people") .. " to add"
                .. (#list > usable and ("\n|cff888888" .. (#list - usable) .. " stay on the other side|r") or "")))
            empty:SetShown(#list == 0)
            empty:SetText(#characters == 0 and ("Your other characters' people show up here, ready to add to " .. me
                .. ".\n\nEach character has their own list and journals. Log in with another character who has people, then come back.")
                or ("Nobody to add: " .. me .. " already knows everyone " .. (current and current.name or "your other characters") .. " know" .. (current and "s" or "") .. "."))
            local ready = #Companions(list)
            importAll:SetShown(ready > 0)
            importAll:SetText(state.allArmed and ("Click again to add " .. ready) or ("Add all companions (" .. ready .. ")"))
            -- The selected person.
            local row = state.row
            if row then
                local card = row.card
                local glyphName = A.IconGlyph("people", card)
                local icon = glyphName ~= "none" and ("|T" .. A.GlyphPath(glyphName) .. ":0|t ") or ""
                who:SetText(icon .. (card.display and (card.display .. "  |cff9d9d9d" .. (card.name or row.key) .. "|r") or (card.name or row.key)))
                summary:SetText(A.PersonSummary and A.PersonSummary(card) or "")
                local lines = {}
                -- "Alberich's companion since 2026-09-26 (34 lines in his journal)"
                for _, knower in ipairs(row.knowers) do
                    local rel = knower.rel
                    local word = CIRCLE_WORDS[rel.circle or "companion"] or "companion"
                    local lines_ = type(rel.journal) == "table" and #rel.journal or 0
                    local since = (rel.met or rel.added) and date and (" since " .. date("%Y-%m-%d", rel.met or rel.added)) or ""
                    lines[#lines + 1] = "|cffffd100" .. knower.name .. "'s|r " .. word .. since
                        .. (lines_ > 0 and ("  |cff9d9d9d(" .. lines_ .. (lines_ == 1 and " journal line" or " journal lines") .. ")|r") or "")
                end
                if card.note and card.note ~= "" then lines[#lines + 1] = "|cff9d9d9dNote:|r " .. card.note end
                knownBy:SetText(table.concat(lines, "\n"))
                shared:SetText(row.usable and ("Adding them to " .. me .. " brings their icon, display name and note (shared by all your characters). "
                    .. me .. "'s journal with them starts here; the others keep theirs.")
                    or ("A player of the " .. (card.faction or "other") .. " side. They stay with your " .. (card.faction or "other side's")
                    .. " characters." .. (row.rel.circle == "rival" and " Rivals count only against the side they were made from." or "")))
                row.journalBy = nil
                for _, knower in ipairs(row.knowers) do
                    if type(knower.rel.journal) == "table" and #knower.rel.journal > 0 and not row.journalBy then row.journalBy = knower.key end
                end
                read:SetText(row.journalBy and ("Read " .. CharacterName(row.journalBy) .. "'s journal") or "No journal yet")
            else
                who:SetText(#list > 0 and "Select someone on the left" or "")
                summary:SetText("")
                knownBy:SetText("")
                shared:SetText(#characters == 0 and "" or ("Each of your characters has their own list and journals. Here are the people your other characters know: add them to "
                    .. me .. " one by one, or all companions at once.\n\nDouble-click someone to read their journal."))
            end
            add:SetShown(row ~= nil); read:SetShown(row ~= nil)
            add:SetEnabled(row ~= nil and row.usable and true or false)
            add:SetText("Add to " .. me)
            read:SetEnabled(row ~= nil and row.journalBy ~= nil)
            notice:SetText(state.status or "")
        end)
    end

    function A.RefreshOptions()
        -- Closed window: nothing to redraw (OnShow refreshes it when opened).
        if not frame:IsShown() then return end
        for _, entry in ipairs(checks) do entry.check:SetChecked(db[entry.key]) end
        for _, update in ipairs(updaters) do update() end
    end
    if frame.HookScript then frame:HookScript("OnShow", A.RefreshOptions)
    else frame:SetScript("OnShow", A.RefreshOptions) end
    function A.OpenOptions()
        if db.cjLayout == "b" and A.OpenBookPeople then A.OpenBookPeople(); return end
        if UIParent and UIParent.GetWidth and UIParent.GetHeight then
            frame:SetScale(math.max(0.4, math.min(1, (UIParent:GetWidth() - 40) / W, (UIParent:GetHeight() - 40) / H)))
        end
        A.RefreshOptions()
        frame:Show()
    end
    A.RefreshOptions()
end
