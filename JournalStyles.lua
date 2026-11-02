local _, A = ...
-- The journal window's page styles, B to E, and the Highlights mode of every
-- style (A's Everything is the original page, drawn by JournalUI.lua).
--   B Chronicle  a printed chronicle: chapter-like dates, book paragraphs
--   C Margins    the date in a left margin, each scene a heading with glyphs
--   D Diary      your own voice ("we"), the book font, a drop cap each day
--   E Ledger     a band per day with totals, aligned rows with times
-- A style lays the book (A.JournalBook) out into blocks the window lends it:
-- ctx.Block(entries, what) gives a button (a right-click removes the entries
-- it shows), ctx.Text / ctx.Texture its parts, ctx.Place puts it on the page,
-- ctx.Lines measures how many lines a text wraps to. Each style returns the
-- height it used.

local ORNAMENTS = "Interface\\AddOns\\CompanionJournal\\Media\\Ornaments\\"
local OPEN, CLOSE = "\226\128\156", "\226\128\157"

local INK = {0.20, 0.125, 0.05}
local SOFT = {0.36, 0.23, 0.09}
local FAINT = {0.54, 0.42, 0.26}
local RUBRIC = {0.49, 0.11, 0.04}
local CHAPTER = {0.42, 0.10, 0.04}
local BOOK_MARKUP = {p = RUBRIC, q = SOFT} -- places and foes in red, quests softer
local DIARY_MARKUP = BOOK_MARKUP             -- the diary colors places and foes too
local FAINT_CODE = "|cff8a6b42"

-- Fonts: Friz (the interface), Morpheus (the game's books), Arial Narrow
-- (small labels). Other alphabets use the interface font throughout.
local FACES = {friz = "Fonts\\FRIZQT__.TTF", book = "Fonts\\MORPHEUS.TTF", narrow = "Fonts\\ARIALN.TTF"}
-- The reading text (styles B and D): DialogueUI's paragraph font (its own Friz Quadrata,
-- at 14 (a touch under its 16), line spacing 0.35 x size), or the game's Friz without DialogueUI.
local DIALOGUE_FONT = "Interface\\AddOns\\DialogueUI\\Fonts\\frizqt__.ttf"
local DIARY_SIZE = 14
local DIARY_SPACING = 0.35 * DIARY_SIZE
local function BodySize(ctx) return ctx.reading and 16 or DIARY_SIZE end
local function BodySpacing(ctx) return ctx.reading and 5.6 or DIARY_SPACING end
-- A modest half-em pause distinguishes paragraphs without adding an empty
-- line or combining a large gap with first-line indentation. Existing body
-- leading stays near 135%; headings, drop caps and quoted notes keep their look.
-- Typography reference: practicaltypography.com/space-between-paragraphs.html
local function ParagraphGap(ctx) return ctx.reading and 8 or 7 end
local function HasDialogueUI()
    local info = (C_AddOns and C_AddOns.GetAddOnInfo) or GetAddOnInfo
    if not info then return false end
    local ok, name, _, _, _, reason = pcall(info, "DialogueUI")
    return ok and name ~= nil and reason ~= "MISSING"
end
local LATIN = {enUS = true, enGB = true, frFR = true, deDE = true, esES = true, esMX = true, itIT = true, ptBR = true}
local fonts = {}
local function Font(face, size)
    if face == "quest" then return QuestFont end
    local key = face .. size
    local font = fonts[key]
    if not font then
        local locale = GetLocale and GetLocale()
        local path = FACES[face]
        if face == "dialogue" then path = HasDialogueUI() and DIALOGUE_FONT or FACES.friz end
        if locale and not LATIN[locale] then path = STANDARD_TEXT_FONT or path end
        font = CreateFont("CompanionJournalFont_" .. key)
        -- (a font file that cannot be read: the interface's Friz instead)
        if font:SetFont(path, size, "") == false then font:SetFont(FACES.friz, size, "") end
        font:SetShadowOffset(0, 0)
        fonts[key] = font
    end
    return font
end

local S = {}
A.JournalStyles = S
local DropCap -- also used by the Chronicle in the dedicated reading view

local function Colored(text, colors) return A.JournalColored(text, colors) end
local function Entries(scene) return #scene.entries > 0 and scene.entries or nil end
local function What(scene) return scene.kind == "outing" and "outing" or scene.kind == "custom" and "line" or "entry" end
local function Clock(t) return date and date("%H:%M", t or 0) or "" end
local function Length(scene)
    local minutes = math.max(1, math.floor((scene.e - scene.t) / 60 + 0.5))
    local text = minutes >= 60 and string.format("%d h %02d", math.floor(minutes / 60), minutes % 60) or (minutes .. " min")
    return scene.open and (text .. " so far") or text
end

-- A wrapped paragraph at (x, y) in the block; returns its height.
local function Paragraph(ctx, block, key, font, color, spacing, x, y, width, text, justify)
    local fs = ctx.Text(block, key, font, color, justify)
    fs:SetSpacing(spacing or 0)
    fs:SetPoint("TOPLEFT", x, y)
    fs:SetWidth(width)
    fs:SetText(text)
    return fs:GetStringHeight(), fs
end
-- One line sized to its text (at most maxWidth).
local function Fit(fs, text, maxWidth)
    fs:SetWordWrap(false)
    fs:SetWidth(maxWidth)
    fs:SetText(text)
    fs:SetWidth(math.min(maxWidth, math.ceil(fs:GetStringWidth() or maxWidth) + 2))
    return fs
end
-- An ornament (tinted art) centered on the page.
local function Ornament(ctx, y, name, width, height, alpha)
    local block = ctx.Block()
    local art = ctx.Texture(block, "art")
    art:SetTexture(ORNAMENTS .. name)
    art:SetVertexColor(RUBRIC[1], RUBRIC[2], RUBRIC[3], alpha or 1)
    art:SetAllPoints()
    ctx.Place(block, math.floor((ctx.width - width) / 2), y, width, height)
    return height
end
-- A small glyph and its text with a hanging indent.
local function Item(ctx, block, i, x, y, width, glyph, text, color)
    local icon = ctx.Texture(block, "glyph" .. i)
    icon:SetTexture(A.GlyphPath(glyph))
    icon:SetVertexColor(SOFT[1], SOFT[2], SOFT[3], 1)
    icon:SetSize(13, 13)
    icon:SetPoint("TOPLEFT", x + 1, y - 1)
    return (Paragraph(ctx, block, "item" .. i, Font("friz", 12), color or INK, 4, x + 19, y, width - 19, Colored(text, BOOK_MARKUP)))
end
-- A line of yours set off by a thin red rule on its left.
local function RuledQuote(ctx, x, y, width, text, entries, font, spacing)
    local block = ctx.Block(entries, "line")
    local h = Paragraph(ctx, block, "text", font, SOFT, spacing, 12, 0, width - 12, text)
    local rule = ctx.Texture(block, "rule")
    rule:SetColorTexture(RUBRIC[1], RUBRIC[2], RUBRIC[3], 0.6)
    rule:SetPoint("TOPLEFT", 0, 1)
    rule:SetSize(2, h + 2)
    ctx.Place(block, x, y, width, h)
    return h
end
-- What a day says, as paragraphs: {text} for prose, {quote} for your lines,
-- {heading} for a Story chapter's title.
local function DayParagraphs(person, day, mode, voice, ctx)
    local paragraphs = {}
    local function Prose(text, entries, what)
        -- Only authored blank lines create a new paragraph. A wrapped line or
        -- a single newline is not a new scene, and notes remain intact quotes.
        text = (text or ""):gsub("\r\n", "\n")
        -- Annotate before Diary splits its ink into words; saved prose and
        -- the player's quoted notes remain untouched.
        if A.bookLinks and A.MarkKnownLore then text = A.MarkKnownLore(text) end
        for paragraph in (text .. "\n\n"):gmatch("(.-)\n%s*\n+") do
            if paragraph:find("%S") then paragraphs[#paragraphs + 1] = {text = paragraph, entries = entries, what = what} end
        end
    end
    if mode == "story" or mode == "storyBrief" then
        local story = ctx and ctx.Story and ctx.Story(day, voice)
        if story then
            if story.text ~= "" or #story.quotes > 0 then
                local title = story.title and A.JournalPlain(story.title) or nil
                paragraphs[1] = {heading = (day.readerEdition == "fire" and "Episode " or "Chapter ") .. A.JournalTale.Roman(story.chapter) .. (title and ("  \194\183  " .. title) or "")}
            end
            -- Scene breaks belong to the prose. Give each scene its own block so
            -- Diary's word-by-word ink layout keeps them, too.
            Prose(story.text)
            for _, quote in ipairs(story.quotes) do paragraphs[#paragraphs + 1] = {quote = quote.text, entries = quote.entries} end
        end
    elseif mode == "highlights" then
        local text, quotes = A.JournalDayHighlights(person, day, voice)
        Prose(text)
        for _, quote in ipairs(quotes) do paragraphs[#paragraphs + 1] = {quote = quote.text, entries = quote.entries} end
    else
        for _, scene in ipairs(day.scenes) do
            if scene.kind == "custom" then
                if scene.text then paragraphs[#paragraphs + 1] = {quote = scene.text, entries = Entries(scene)} end
            else
                local text = A.JournalSceneText(person, scene, voice)
                if text and text ~= "" then
                    Prose(text, Entries(scene), What(scene))
                end
            end
        end
    end
    return paragraphs
end

-- A: Highlights for the original page ---------------------------------------------
-- Its chapter titles and fonts, one plain paragraph a day.
function S.a(ctx, days, person, mode)
    local width, y = ctx.width, -4
    for _, day in ipairs(days) do
        local title = ctx.Block()
        local h = Paragraph(ctx, title, "text", Font("quest"), CHAPTER, 0, 0, 0, width, "~  " .. day.title .. "  ~", "CENTER")
        ctx.Place(title, 0, y, width, h + 2)
        y = y - h - 2 - 6
        -- (style A's Everything is the classic list, except for your own journal: its scenes)
        local shownMode = (mode == "story" or mode == "storyBrief") and mode or ((person.self and mode == "all") and "all" or "highlights")
        for _, p in ipairs(DayParagraphs(person, day, shownMode, "you", ctx)) do
            local block = ctx.Block(p.entries, "line")
            local indent = p.quote and 22 or 8
            if p.heading then
                h = Paragraph(ctx, block, "text", Font("quest"), SOFT, 0, 0, 0, width, p.heading, "CENTER")
                ctx.Place(block, 0, y, width, h + 2)
                y = y - h - 2 - 5
            else
            h = Paragraph(ctx, block, "text", Font("quest"), p.quote and SOFT or INK, 3, 0, 0, width - indent - 4,
                p.quote and (OPEN .. p.quote .. CLOSE) or Colored(p.text, {}))
            ctx.Place(block, indent, y, width - indent - 4, h + 2)
            y = y - h - ParagraphGap(ctx)
            end
        end
        y = y - 10
    end
    return -y
end

-- B: Chronicle ---------------------------------------------------------------------
-- A centered line of yours under a large red quotation mark.
local function BookQuote(ctx, y, text, entries)
    local width = ctx.width
    local block = ctx.Block(entries, "line")
    local mark = ctx.Text(block, "mark", Font("friz", 30), RUBRIC, "CENTER")
    mark:SetPoint("TOPLEFT", 0, 0)
    mark:SetWidth(width)
    mark:SetText(OPEN)
    local h = Paragraph(ctx, block, "text", Font("dialogue", BodySize(ctx)), SOFT, BodySpacing(ctx), 34, -18, width - 68, text, "CENTER")
    ctx.Place(block, 0, y, width, h + 18)
    return h + 18
end
function S.b(ctx, days, person, mode)
    local width, y = ctx.width, -6
    for _, day in ipairs(days) do
        -- The day opens like a chapter: weekday, date, an ornamental rule.
        local head = ctx.Block()
        local h1 = Paragraph(ctx, head, "weekday", Font("narrow", 11), SOFT, 0, 0, 0, width,
            day.readerEdition and day.readerDate or day.weekday:upper(), "CENTER")
        local h2 = 0
        if not day.readerEdition then
            h2 = Paragraph(ctx, head, "date", Font("book", 21), RUBRIC, 0, 0, -(h1 + 1), width,
                day.dayNumber .. " " .. day.month .. " " .. day.year, "CENTER")
        end
        local rule = ctx.Texture(head, "rule")
        rule:SetTexture(ORNAMENTS .. "rule")
        rule:SetVertexColor(RUBRIC[1], RUBRIC[2], RUBRIC[3], 0.9)
        rule:SetSize(200, 12)
        rule:SetPoint("TOP", 0, -(h1 + 1 + h2 + 5))
        local height = h1 + 1 + h2 + 5 + 12
        ctx.Place(head, 0, y, width, height)
        y = y - height - 10
        local first = true
        for _, p in ipairs(DayParagraphs(person, day, mode, "you", ctx)) do
            if p.heading then
                local block = ctx.Block()
                local h = Paragraph(ctx, block, "text", Font("book", 17), INK, 0, 0, 0, width, p.heading, "CENTER")
                ctx.Place(block, 0, y, width, h)
                y = y - h - 8
            elseif p.quote then
                y = y - 4 - BookQuote(ctx, y - 4, p.quote, p.entries) - 12
            else
                local block = ctx.Block(p.entries, p.what)
                local text = Colored(p.text, BOOK_MARKUP)
                local h
                -- The reading font (as the diary's); Morpheus stays for dates and headings.
                if ctx.reading and first then
                    h = DropCap(ctx, block, width, p.text, Font("dialogue", BodySize(ctx)), BodySpacing(ctx), BOOK_MARKUP)
                else
                    h = Paragraph(ctx, block, "text", Font("dialogue", BodySize(ctx)), INK, BodySpacing(ctx), 0, 0, width, text)
                end
                ctx.Place(block, 0, y, width, h)
                y = y - h - ParagraphGap(ctx)
                first = false
            end
        end
        y = y - 12
    end
    -- A fleuron closes the book.
    if #days > 0 then y = y - Ornament(ctx, y, "fleuron", 96, 48, 0.8) end
    return -y
end

-- C: Margins -----------------------------------------------------------------------
local MARGIN = 58     -- the date column
local CONTENT = 83    -- where the scenes start (margin, gap, hairline, gap)
local function MarginScene(ctx, person, scene, x, y, width)
    local block = ctx.Block(Entries(scene), What(scene))
    local clock = ctx.Text(block, "time", Font("narrow", 11), FAINT, "RIGHT")
    clock:SetPoint("TOPRIGHT", 0, -4)
    clock:SetWidth(44)
    clock:SetText(Clock(scene.t))
    local h = 0
    if scene.kind == "outing" or scene.kind == "met" then
        local head = ctx.Text(block, "head", Font("book", 16), INK)
        head:SetPoint("TOPLEFT", 0, 0)
        Fit(head, scene.kind == "met" and "First meeting" or (scene.zone or "On the road"), width - 120)
        if scene.kind == "outing" then
            local length = ctx.Text(block, "length", Font("friz", 11), FAINT)
            length:SetPoint("BOTTOMLEFT", head, "BOTTOMRIGHT", 4, 2)
            Fit(length, "\194\183 " .. Length(scene), 90)
        end
        h = head:GetStringHeight() + 3
    end
    local items
    if scene.kind == "outing" then
        items = A.JournalSceneItems(person, scene)
    else
        items = {{glyph = A.JournalSceneGlyph(scene), text = A.JournalSceneText(person, scene, "you") or ""}}
    end
    for i, item in ipairs(items) do
        if i > 1 then h = h + 3 end
        -- A first row beside the time leaves it room.
        h = h + Item(ctx, block, i, 0, -h, h == 0 and (width - 48) or width, item.glyph, item.text)
    end
    h = math.max(h, 16)
    ctx.Place(block, x, y, width, h)
    return h
end
function S.c(ctx, days, person, mode)
    local width, y = ctx.width, -4
    local inner = width - CONTENT
    for _, day in ipairs(days) do
        local top, bottom = y, y
        local first = true
        local function Gap(space)
            if not first then bottom = bottom - space end
            first = false
        end
        if mode ~= "all" then
            for _, p in ipairs(DayParagraphs(person, day, mode, "you", ctx)) do
                Gap(ParagraphGap(ctx))
                if p.heading then
                    local block = ctx.Block()
                    local h = Paragraph(ctx, block, "text", Font("book", 16), INK, 0, 0, 0, inner, p.heading)
                    ctx.Place(block, CONTENT, bottom, inner, h)
                    bottom = bottom - h + 2
                elseif p.quote then
                    bottom = bottom - RuledQuote(ctx, CONTENT, bottom, inner, p.quote, p.entries, Font("book", 14), 4)
                else
                    local block = ctx.Block()
                    local h = Paragraph(ctx, block, "text", Font("friz", 13), INK, 5, 0, 0, inner, Colored(p.text, BOOK_MARKUP))
                    ctx.Place(block, CONTENT, bottom, inner, h)
                    bottom = bottom - h
                end
            end
        else
            for _, scene in ipairs(day.scenes) do
                if scene.kind == "custom" then
                    if scene.text then
                        Gap(10)
                        bottom = bottom - 2 - RuledQuote(ctx, CONTENT, bottom - 2, inner, scene.text, Entries(scene), Font("book", 14), 4)
                    end
                else
                    Gap(10)
                    bottom = bottom - MarginScene(ctx, person, scene, CONTENT, bottom, inner)
                end
            end
        end
        -- The margin: day number, month, weekday, and a hairline down the day.
        local margin = ctx.Block()
        local h1 = Paragraph(ctx, margin, "day", Font("book", 32), RUBRIC, 0, 0, 0, MARGIN, tostring(day.dayNumber), "RIGHT")
        local h2 = Paragraph(ctx, margin, "month", Font("narrow", 10), SOFT, 0, 0, -(h1 + 1), MARGIN, day.month:upper(), "RIGHT")
        local h3 = Paragraph(ctx, margin, "weekday", Font("narrow", 10), FAINT, 0, 0, -(h1 + 1 + h2 + 1), MARGIN, day.weekday, "RIGHT")
        local height = math.max(top - bottom, h1 + h2 + h3 + 4)
        local rule = ctx.Texture(margin, "rule")
        rule:SetColorTexture(SOFT[1], SOFT[2], SOFT[3], 0.33)
        rule:SetPoint("TOPLEFT", MARGIN + 12, 0)
        rule:SetSize(1, height)
        ctx.Place(margin, 0, top, MARGIN + 13, height)
        y = top - height - 16
    end
    return -y
end

-- D: Diary -------------------------------------------------------------------------
local DROP_SIZE = 46   -- the drop cap's font size
local DROP_LINES = 2   -- lines set beside it
local DROP_RAISE = 7   -- lifts the capital to the first line's cap height
local DROP_GAP = 5
-- One markup tag per word, so the text can be cut between any two words.
local function SplitWords(markup)
    local names = {}
    markup = markup:gsub("{([pqn]):([^}]*)}", function(kind, value)
        local key = A.JournalNameTarget(kind, value)
        if key then
            return (value:gsub("%S+", function(word)
                names[#names + 1] = {text = word, key = key}
                return "\1" .. #names .. "\2"
            end))
        end
        return (value:gsub("%S+", function(word) return "{" .. kind .. ":" .. word .. "}" end))
    end)
    local words, firstName = {}, nil
    for word in markup:gmatch("%S+") do
        local id, tail = word:match("^\1(%d+)\2(.*)$")
        if #words == 0 and id then firstName = {text = names[tonumber(id)].text, key = names[tonumber(id)].key, tail = tail} end
        words[#words + 1] = word:gsub("\1(%d+)\2", function(n)
            local name = names[tonumber(n)]
            return A.JournalTextLink(name.text, name.key)
        end)
    end
    return words, firstName
end
-- The first letter of a word, and what is left of the word (markup kept).
local function Initial(word)
    local kind, value, tail = word:match("^{([pqn]):([^}]*)}(.*)$")
    local text = kind and value or word
    local initial = text:match("^[%z\1-\127\194-\244][\128-\191]*")
    if not initial or not (initial:match("^%a") or #initial > 1) then return nil end
    local rest = text:sub(#initial + 1)
    if kind then rest = (rest ~= "" and ("{" .. kind .. ":" .. rest .. "}") or "") .. tail end
    return initial, rest
end
-- A paragraph opened by a red drop cap: as many words as fit beside it, the
-- rest below at full width. Returns the height.
DropCap = function(ctx, block, width, markup, font, spacing, colors)
    local words, firstName = SplitWords(markup)
    local initial, rest = Initial(firstName and firstName.text or words[1] or "")
    if not initial then
        return (Paragraph(ctx, block, "text", font, INK, spacing, 0, 0, width, Colored(markup, colors)))
    end
    words[1] = firstName and (A.JournalTextLink(rest, firstName.key) .. firstName.tail) or rest
    local cap = ctx.Text(block, "cap", Font("book", DROP_SIZE), RUBRIC)
    cap:SetPoint("TOPLEFT", 0, DROP_RAISE)
    Fit(cap, initial, 80)
    local indent = math.ceil(cap:GetStringWidth() or 30) + DROP_GAP
    if firstName then cap:SetText(A.JournalTextLink(initial, firstName.key)) end
    local capHeight = (cap:GetStringHeight() or DROP_SIZE) - DROP_RAISE - 6
    local function Join(from, to)
        local parts = {}
        for n = from, to do if words[n] ~= "" then parts[#parts + 1] = words[n] end end
        return table.concat(parts, " ")
    end
    -- The most words that stay within DROP_LINES beside the capital.
    local low, high = 1, #words
    while low < high do
        local mid = math.floor((low + high + 1) / 2)
        if ctx.Lines(font, spacing, width - indent, Colored(Join(1, mid), colors)) <= DROP_LINES then low = mid else high = mid - 1 end
    end
    local h = Paragraph(ctx, block, "text", font, INK, spacing, indent, 0, width - indent, Colored(Join(1, low), colors))
    h = math.max(h, capHeight)
    if low < #words then
        local more = Paragraph(ctx, block, "more", font, INK, spacing, 0, -(h + spacing), width, Colored(Join(low + 1, #words), colors))
        h = h + spacing + more
    end
    return h
end
-- Handwritten underlines: the diary keeps every word in ink and underlines
-- places and foes (red) and quests (faint brown) with a quill stroke. The text
-- is set line by line, so each name's place on its line is known.
local INK_LINES = {p = {RUBRIC, 0.8}, q = {SOFT, 0.55}, n = {A.JournalLinkColor or {0.23, 0.22, 0.44}, 0.75}}
local STROKES = 3
local function Hash(text)
    local h = 0
    for i = 1, #text do h = (h * 31 + text:byte(i)) % 16777216 end
    return h
end
-- Words with their markup: {lead, kind, tag, core, trail}; tag groups the words
-- of one name ("Silverpine Forest"), core is the part to underline.
local function InkWords(markup)
    local id, links = 0, {}
    markup = markup:gsub("{([pqn]):([^}]*)}", function(kind, value)
        id = id + 1
        links[tostring(id)] = A.JournalNameTarget(kind, value)
        return (value:gsub("%S+", function(word) return "\1" .. kind .. id .. "\2" .. word .. "\3" end))
    end)
    local words = {}
    for token in markup:gmatch("%S+") do
        local lead, kind, tag, core, trail = token:match("^(.-)\1(%a)(%d+)\2(.-)\3(.*)$")
        if lead then
            words[#words + 1] = {lead = lead, kind = kind, tag = tag, core = core, trail = trail, link = links[tag]}
        else
            words[#words + 1] = {lead = token, core = "", trail = ""}
        end
    end
    return words
end
-- A paragraph in ink, optionally opened by a red drop cap. Inter-paragraph
-- space supplies the other boundaries, so ordinary first lines remain flush.
-- Returns the height.
local function InkParagraph(ctx, block, font, spacing, width, markup, cap)
    local words = InkWords(markup)
    local capIndent, capHeight = 0, 0
    if cap and words[1] then
        local first = words[1]
        local initial = Initial(first.lead .. first.core .. first.trail)
        if initial then
            if first.lead ~= "" then first.lead = first.lead:sub(#initial + 1) else first.core = first.core:sub(#initial + 1) end
            local capText = ctx.Text(block, "cap", Font("book", DROP_SIZE), RUBRIC)
            capText:SetPoint("TOPLEFT", 0, DROP_RAISE)
            Fit(capText, initial, 80)
            capIndent = math.ceil(capText:GetStringWidth() or 30) + DROP_GAP
            if first.link then capText:SetText(A.JournalTextLink(initial, first.link)) end
            capHeight = (capText:GetStringHeight() or DROP_SIZE) - DROP_RAISE - 6
        end
    end
    local function Measure(text)
        if text == "" then return 0 end
        if text:sub(-1) == " " then
            return ctx.Width(font, text:sub(1, -2)) + ctx.Width(font, "a a") - ctx.Width(font, "aa")
        end
        return ctx.Width(font, text)
    end
    -- Fill lines: beside the capital first, then at full width.
    local lines, current = {}, nil
    for _, word in ipairs(words) do
        local text = word.lead .. word.core .. word.trail
        if text ~= "" then
            if current and Measure(current.text .. " " .. text) <= current.width then
                current.words[#current.words + 1] = word
                current.text = current.text .. " " .. text
            else
                local n = #lines + 1
                local x = (capIndent > 0 and n <= DROP_LINES) and capIndent or 0
                current = {x = x, width = width - x, words = {word}, text = text}
                lines[n] = current
            end
        end
    end
    local y, strokes = 0, 0
    for i, line in ipairs(lines) do
        local fs = ctx.Text(block, "line" .. i, font, INK)
        fs:SetSpacing(0); fs:SetWordWrap(false)
        fs:SetPoint("TOPLEFT", line.x, -y)
        fs:SetWidth(line.width + 20)
        local shown = {}
        for _, word in ipairs(line.words) do
            shown[#shown + 1] = word.lead .. A.JournalTextLink(word.core, word.link) .. word.trail
        end
        fs:SetText(table.concat(shown, " "))
        local h = fs:GetStringHeight()
        -- One stroke per name on this line (a name cut by the line end gets two).
        local before, run = "", nil
        local function Stroke()
            if not run then return end
            strokes = strokes + 1
            local look, hash = INK_LINES[run.kind], Hash(run.key .. i)
            if run.link and run.link:match("^cjlore:") then look = INK_LINES.p end
            local stroke = ctx.Texture(block, "ink" .. strokes, "BORDER")
            stroke:SetTexture(ORNAMENTS .. "ink" .. (hash % STROKES + 1))
            if hash % 2 == 1 then stroke:SetTexCoord(1, 0, 0, 1) else stroke:SetTexCoord(0, 1, 0, 1) end
            stroke:SetVertexColor(look[1][1], look[1][2], look[1][3], look[2])
            stroke:SetSize(run.e - run.s + 6, 7)
            stroke:SetPoint("TOPLEFT", line.x + run.s - 3, -(y + h - 3) + ((hash % 3) - 1) * 0.5)
            if stroke.SetRotation then stroke:SetRotation(((hash % 5) - 2) * 0.004) end
            run = nil
        end
        for j, word in ipairs(line.words) do
            local start = j == 1 and "" or (before .. " ")
            if word.kind and INK_LINES[word.kind] and (word.kind ~= "n" or word.link) and word.core ~= "" then
                local s0, s1 = Measure(start .. word.lead), Measure(start .. word.lead .. word.core)
                if run and run.tag == word.tag then run.e = s1
                else Stroke(); run = {tag = word.tag, kind = word.kind, s = s0, e = s1, key = word.core, link = word.link} end
                if word.trail ~= "" then Stroke() end
            else
                Stroke()
            end
            before = start .. word.lead .. word.core .. word.trail
        end
        Stroke()
        y = y + h + spacing
    end
    if #lines > 0 then y = y - spacing end
    return math.max(y, capHeight)
end
function S.d(ctx, days, person, mode)
    local width, y = ctx.width, -4
    for _, day in ipairs(days) do
        local zone = A.JournalDayTotals(day).zone
        local dateline = ctx.Block()
        local h = Paragraph(ctx, dateline, "text", Font("book", 14), SOFT, 0, 0, 0, width,
            (zone and (zone .. ", ") or "") .. day.weekday .. " " .. day.dayNumber .. " " .. day.month, "RIGHT")
        ctx.Place(dateline, 0, y, width, h)
        y = y - h - 8
        local first = true
        for _, p in ipairs(DayParagraphs(person, day, mode, "we", ctx)) do
            if p.heading then
                local block = ctx.Block()
                h = Paragraph(ctx, block, "text", Font("book", 17), RUBRIC, 0, 0, 0, width, p.heading, "CENTER")
                ctx.Place(block, 0, y, width, h)
                y = y - h - 8
            elseif p.quote then
                y = y - 2 - RuledQuote(ctx, 18, y - 2, width - 18, p.quote, p.entries, Font("friz", 13), 4) - 10
            else
                local block = ctx.Block(p.entries, p.what)
                if ctx.Width then
                    -- In ink, names underlined by hand.
                    h = InkParagraph(ctx, block, Font("dialogue", BodySize(ctx)), BodySpacing(ctx), width, p.text, first)
                elseif first then
                    h = DropCap(ctx, block, width, p.text, Font("dialogue", BodySize(ctx)), BodySpacing(ctx), DIARY_MARKUP)
                else
                    h = Paragraph(ctx, block, "text", Font("dialogue", BodySize(ctx)), INK, BodySpacing(ctx), 0, 0, width,
                        Colored(p.text, DIARY_MARKUP))
                end
                ctx.Place(block, 0, y, width, h)
                y = y - h - ParagraphGap(ctx)
                first = false
            end
        end
        -- A fleuron between days.
        y = y - 4 - Ornament(ctx, y - 4, "fleuron", 88, 44, 0.75) - 12
    end
    return -y
end

-- E: Ledger ------------------------------------------------------------------------
local TIME_COLUMN = 38 -- then an 18 px glyph column, then the text
local function LedgerRow(ctx, block, i, y, clock, glyph, text, color)
    if clock then
        -- Readable times: a size up, in the soft ink, right-aligned clear of the page edge.
        local fs = ctx.Text(block, "time" .. i, Font("narrow", 12), SOFT, "RIGHT")
        fs:SetPoint("TOPLEFT", 0, y - 1)
        fs:SetWidth(TIME_COLUMN - 6)
        fs:SetText(clock)
    end
    return Item(ctx, block, i, TIME_COLUMN, y, ctx.width - TIME_COLUMN, glyph, text, color)
end
local function Separator(ctx, block)
    local line = ctx.Texture(block, "separator")
    line:SetColorTexture(SOFT[1], SOFT[2], SOFT[3], 0.15)
    line:SetPoint("TOPLEFT", TIME_COLUMN, 0)
    line:SetSize(ctx.width - TIME_COLUMN, 1)
    return 5
end
function S.e(ctx, days, person, mode)
    local width, y = ctx.width, -2
    for _, day in ipairs(days) do
        -- The day's band: short date on the left, the day in numbers on the right.
        local totals = A.JournalDayTotals(day)
        local band = ctx.Block()
        local fill = ctx.Texture(band, "fill", "BACKGROUND")
        fill:SetColorTexture(SOFT[1], SOFT[2], SOFT[3], 0.11)
        fill:SetAllPoints()
        for _, side in ipairs({"TOP", "BOTTOM"}) do
            local edge = ctx.Texture(band, side)
            edge:SetColorTexture(SOFT[1], SOFT[2], SOFT[3], 0.25)
            edge:SetPoint(side .. "LEFT")
            edge:SetPoint(side .. "RIGHT")
            edge:SetHeight(1)
        end
        local left = ctx.Text(band, "date", Font("narrow", 13), RUBRIC)
        left:SetPoint("LEFT", 6, 0)
        Fit(left, day.weekday:sub(1, 3):upper() .. " " .. day.dayNumber .. " " .. day.month:sub(1, 3):upper(), 120)
        local parts = {}
        if totals.minutes > 0 then
            parts[#parts + 1] = (totals.minutes >= 60 and string.format("%d h %02d", math.floor(totals.minutes / 60), totals.minutes % 60)
                or (totals.minutes .. " min")) .. (person.self and "" or " together")
        end
        if totals.quests > 0 then parts[#parts + 1] = totals.quests .. (totals.quests == 1 and " quest" or " quests") end
        if totals.foes > 0 then parts[#parts + 1] = totals.foes .. (totals.foes == 1 and " foe" or " foes") end
        local right = ctx.Text(band, "totals", Font("narrow", 11), SOFT, "RIGHT")
        right:SetPoint("RIGHT", -6, 0)
        Fit(right, table.concat(parts, "  \194\183  "), width - 140)
        ctx.Place(band, 0, y - 2, width, 22)
        y = y - 2 - 22 - 6
        if mode ~= "all" then
            for i, p in ipairs(DayParagraphs(person, day, mode, "you", ctx)) do
                local block = ctx.Block(p.entries, "line")
                local h = 0
                if p.heading then
                    h = h + Paragraph(ctx, block, "text", Font("narrow", 12), RUBRIC, 0, TIME_COLUMN, -h, width - TIME_COLUMN, p.heading:upper())
                elseif p.quote then
                    h = h + LedgerRow(ctx, block, 1, -h, nil, "note", OPEN .. p.quote .. CLOSE, SOFT)
                else
                    h = h + LedgerRow(ctx, block, 1, -h, nil, "sparkle", p.text)
                end
                ctx.Place(block, 0, y, width, h)
                y = y - h - ParagraphGap(ctx)
            end
        else
            for i, scene in ipairs(day.scenes) do
                local block = ctx.Block(Entries(scene), What(scene))
                local h = i > 1 and Separator(ctx, block) or 0
                if scene.kind == "outing" then
                    h = h + LedgerRow(ctx, block, 1, -h, Clock(scene.t), "party",
                        (scene.zone or "On the road") .. "  " .. FAINT_CODE .. "\194\183  " .. Length(scene) .. "|r")
                    for n, item in ipairs(A.JournalSceneItems(person, scene)) do
                        h = h + 3 + LedgerRow(ctx, block, n + 1, -(h + 3), nil, item.glyph, item.text)
                    end
                elseif scene.kind == "custom" then
                    h = h + LedgerRow(ctx, block, 1, -h, Clock(scene.t), "note", OPEN .. (scene.text or "") .. CLOSE, SOFT)
                else
                    h = h + LedgerRow(ctx, block, 1, -h, Clock(scene.t), A.JournalSceneGlyph(scene), A.JournalSceneText(person, scene, "you") or "")
                end
                ctx.Place(block, 0, y, width, h)
                y = y - h - 4
            end
        end
        y = y - 10
    end
    return -y
end

-- Names for the style buttons' tooltips.
A.JournalStyleNames = {a = "Today (the original page)", b = "Chronicle", c = "Margins", d = "Diary", e = "Ledger"}
