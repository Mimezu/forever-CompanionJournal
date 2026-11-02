-- Run from the client root: lua5.1 Interface/AddOns/CompanionJournal/tests/Book.lua
-- The journal as a book: scenes (merged outings, a night's run kept on its
-- day), the Everything prose, the Highlights (only what was recorded), the
-- short items and totals, and every page style in both modes laid out on a
-- stand-in page: removable blocks, the diary's drop cap, the ledger's band.
local root = "Interface/AddOns/CompanionJournal/"
local assertions = 0
local function check(value, message) assertions = assertions + 1; assert(value, message) end
local function has(text, part, message) check(type(text) == "string" and text:find(part, 1, true) ~= nil, message .. " (in: " .. tostring(text) .. ")") end
local function lacks(text, part, message) check(type(text) == "string" and text:find(part, 1, true) == nil, message .. " (in: " .. tostring(text) .. ")") end

function time() return os.time() end
function date(fmt, t) return os.date(fmt, t) end
function CreateFrame() return setmetatable({}, {__index = function() return function() end end}) end
C_Timer = {After = function() end}
local createdFonts = {}
function CreateFont(name)
    local font = {name = name}
    function font:SetFont(path, size) self.path, self.size = path, size end
    function font:SetShadowOffset() end
    createdFonts[name] = font
    return font
end
function GetLocale() return "enUS" end
QuestFont = CreateFont("QuestFont")

local A = {defaults = {colors = {}}}
for _, file in ipairs({"LoreData.lua", "Lore.lua", "Journal.lua", "JournalBook.lua", "JournalTellers.lua", "JournalTale.lua", "JournalWords.lua", "JournalStyles.lua"}) do
    assert(loadfile(root .. file))("CompanionJournal", A)
end
A.db = {people = {}}
A.GlyphPath = function(name) return "glyphs/" .. name end

-- Dahlia's weekend: met on Saturday; on Sunday two outings in Silverpine
-- (the first in two parts), then Tirisfal and Orgrimmar past midnight.
local function T(day, hour, minute) return os.time({year = 2026, month = 9, day = day, hour = hour, min = minute, sec = 0}) end
local journal = {}
local function Add(entry) journal[#journal + 1] = entry; return entry end
local function Outing(z, t, e) return Add({k = "group", z = z, t = t, e = e}) end
Outing("Silverpine Forest", T(27, 19, 12), T(27, 19, 29))
Add({k = "quest", d = "The Decrepit Ferry", z = "Silverpine Forest", t = T(27, 19, 20)})
Add({k = "quest", d = "Rot Hide Clues", z = "Silverpine Forest", t = T(27, 19, 21)})
Outing("Silverpine Forest", T(27, 19, 31), T(27, 19, 46))
Add({k = "quest", d = "Michael Garrett", z = "Silverpine Forest", t = T(27, 19, 40)})
Outing("Silverpine Forest", T(27, 21, 54), T(27, 22, 29))
Add({k = "campfire", z = "Silverpine Forest", t = T(27, 22, 0)})
Add({k = "dungeon", d = "Shadowfang Keep", z = "Shadowfang Keep", t = T(27, 22, 10)})
Add({k = "level", d = 16, z = "Shadowfang Keep", t = T(27, 22, 20)})
Add({k = "quest", d = "Arugal's Folly", z = "Silverpine Forest", t = T(27, 22, 25)})
Outing("Silverpine Forest", T(27, 22, 35), T(27, 23, 5))
Add({k = "quest", d = "Arugal's Folly", z = "Silverpine Forest", t = T(27, 22, 50)})
Outing("Tirisfal Glades", T(27, 23, 12), T(27, 23, 30))
Add({k = "quest", d = "The Engraved Ring", z = "Tirisfal Glades", t = T(27, 23, 20)})
Outing("Orgrimmar", T(27, 23, 31), T(28, 0, 13))
Add({k = "dungeon", d = "Ragefire Chasm", z = "Ragefire Chasm", t = T(27, 23, 40)})
for i, boss in ipairs({"Oggleflint", "Taragaman the Hungerer", "Jergosh the Invoker", "Bazzalan"}) do
    Add({k = "boss", d = boss, z = "Ragefire Chasm", t = T(27, 23, 50) + i * 120})
end
Add({k = "quest", d = "Slaying the Beast", z = "Orgrimmar", t = T(28, 0, 10)})
local custom = Add({k = "custom", d = "Dahlia kept the fire going. Best night so far.", z = "Orgrimmar", t = T(28, 0, 12)})
local person = {name = "Dahlia-Noir", class = "WARLOCK", met = T(26, 5, 16), metZone = "Tirisfal Glades", journal = journal}
A.db.people["dahlia-noir"] = person

-- 1. The book: two days; the night's run stays on Sunday; outings merged.
local days = A.JournalBook(person)
check(#days == 2, "two days, the run past midnight stays on Sunday: " .. #days)
local saturday, sunday = days[1], days[2]
check(saturday.weekday == "Saturday" and #saturday.scenes == 1 and saturday.scenes[1].kind == "met", "Saturday: how you met")
local kinds = {}
for _, scene in ipairs(sunday.scenes) do kinds[#kinds + 1] = scene.kind .. ":" .. tostring(scene.zone) end
check(table.concat(kinds, ",") == "outing:Silverpine Forest,outing:Silverpine Forest,outing:Tirisfal Glades,outing:Orgrimmar,custom:Orgrimmar",
    "Sunday's scenes: " .. table.concat(kinds, ","))
local early, late, tirisfal, orgrimmar = sunday.scenes[1], sunday.scenes[2], sunday.scenes[3], sunday.scenes[4]
check(#early.entries == 5 and early.questCount == 3, "the two-part outing is one scene with its three quests")
check(late.again and late.campfire and late.dungeons[1] == "Shadowfang Keep" and late.levels[1] == 16, "the evening outing and its deeds")
check(#late.quests == 1 and late.quests[1].count == 2, "a quest done twice is listed once, counted twice")
check(orgrimmar.continues == tirisfal and tirisfal.continues == late, "one chain from Silverpine to Orgrimmar")

-- 2. Everything: a paragraph per scene.
-- (Simple mode varies its words a little, so the facts are checked, not the wording.)
local function Count(text, word) local n = 0; for _ in text:gmatch(word) do n = n + 1 end; return n end
local text = A.JournalSceneText(person, early, "you")
check(text:find("{p:Silverpine Forest}", 1, true) and text:find("thirty-four minutes", 1, true), "opening sentence: " .. text)
has(text, "three quests", "how many quests")
has(text, "{q:The Decrepit Ferry}, {q:Rot Hide Clues} and {q:Michael Garrett}.", "quests of the scene")
check(Count(text, "together") <= 1, "\"together\" once at most: " .. text)
check(A.JournalSceneText(person, early, "you") == text, "the same words every time the page is opened")
text = A.JournalSceneText(person, late, "you")
check(text:find("Later that evening", 1, true) and text:find("{p:Silverpine Forest}", 1, true)
    and (text:find("again", 1, true) or text:find("once more", 1, true)), "the second visit: " .. text)
check(text:find("campfire", 1, true) and text:find("into {p:Shadowfang Keep}.", 1, true)
    and text:find("campfire", 1, true) < text:find("Shadowfang", 1, true), "deeds in order: " .. text)
check(text:find("{n:Dahlia} [%a ]+ level 16%.") ~= nil, "their level: " .. text)
has(text, "{q:Arugal's Folly} (twice)", "a repeated quest")
text = A.JournalSceneText(person, orgrimmar, "we")
check(text:find("{p:Orgrimmar}", 1, true) and text:find("forty-two minutes", 1, true) and text:find("we", 1, true),
    "the diary's voice, a continued outing: " .. text)
check(text:find("{p:Oggleflint}, {p:Taragaman the Hungerer}, {p:Jergosh the Invoker} and {p:Bazzalan}", 1, true)
    and (text:find("defeated {p:Oggleflint}", 1, true) or text:find("took down {p:Oggleflint}", 1, true)), "bosses in one clause: " .. text)

-- 3. Highlights: one paragraph a day, from what was recorded only.
local highlights, quotes = A.JournalDayHighlights(person, sunday, "you")
has(highlights, "A long day on the road: nearly three hours together, from {p:Silverpine Forest} to {p:Orgrimmar}, with seven quests seen through.", "the day in one line")
has(highlights, "{p:Shadowfang Keep}", "a dungeon")
has(highlights, "{n:Dahlia} grew to level 16", "their level")
has(highlights, "{p:Ragefire Chasm}", "the second dungeon")
has(highlights, "{p:Bazzalan}", "the foes brought down")
lacks(highlights, "Engraved Ring", "no single quest titles when there are many")
check(#quotes == 1 and quotes[1].text == custom.d and quotes[1].entries[1] == custom, "your line kept word for word")
local first = A.JournalDayHighlights(person, saturday, "we")
check(first == "It began in {p:Tirisfal Glades}, where I first met {n:Dahlia}."
    or first == "This is where it started: {p:Tirisfal Glades}, the day I first met {n:Dahlia}.", "how it began: " .. first)
check(A.JournalDayHighlights(person, sunday, "you") == highlights, "the same words every time")

-- 4. Short forms: items in the order they happened, quests last; totals.
local items = A.JournalSceneItems(person, late)
local glyphs = {}
for _, item in ipairs(items) do glyphs[#glyphs + 1] = item.glyph end
check(table.concat(glyphs, ",") == "fire,shield,star,note", "items: " .. table.concat(glyphs, ","))
check(items[4].text == "Two quests: {q:Arugal's Folly} (twice)", "the quest item: " .. items[4].text)
items = A.JournalSceneItems(person, orgrimmar)
check(items[2].glyph == "swords" and items[2].text:find("^Defeated {p:Oggleflint}") ~= nil, "foes as one item")
local totals = A.JournalDayTotals(sunday)
check(totals.minutes == 34 + 71 + 18 + 42 and totals.quests == 7 and totals.foes == 4 and totals.zone == "Silverpine Forest",
    "Sunday in numbers: " .. totals.minutes .. " min, " .. totals.quests .. " quests, " .. totals.foes .. " foes")
check(A.JournalColored("{p:Orgrimmar} and {q:A Quest}", {p = {0.49, 0.11, 0.04}}) == "|cff7d1c0aOrgrimmar|r and A Quest", "markup to color codes")
check(A.JournalPlain("{p:Orgrimmar}, {n:Dahlia}") == "Orgrimmar, Dahlia", "markup to plain text")

-- 5. The styles on a stand-in page (text measured at ~6.5 px a character,
-- 16 px a line).
local function Plain(value) return (tostring(value or ""):gsub("|H.-|h(.-)|h", "%1"):gsub("|c%x%x%x%x%x%x%x%x", ""):gsub("|r", ""):gsub("|T.-|t", "")) end
local function WrapLines(value, width)
    local lines, length = 1, 0
    local perLine = math.max(1, math.floor((width or 400) / 6.5))
    for word in Plain(value):gmatch("%S+") do
        if length > 0 and length + 1 + #word > perLine then lines, length = lines + 1, #word
        else length = length + (length > 0 and 1 or 0) + #word end
    end
    return lines
end
local page
local function Stand()
    page = {blocks = {}}
    local ctx = {width = 400}
    function ctx.Block(entries, what)
        local block = {texts = {}, textures = {}, entries = entries, what = what}
        page.blocks[#page.blocks + 1] = block
        return block
    end
    function ctx.Text(block, key, font, color, justify)
        local fs = {font = font, color = color, justify = justify, spacing = 0}
        function fs:SetSpacing(n) self.spacing = n end
        function fs:SetPoint(...) self.point = {...} end
        function fs:SetWidth(w) self.width = w end
        function fs:SetText(t) self.text = t end
        function fs:SetWordWrap(v) self.wrap = v end
        function fs:GetStringWidth() return #Plain(self.text) * 6.5 end
        function fs:GetStringHeight() return WrapLines(self.text, self.width) * (16 + self.spacing) - self.spacing end
        block.texts[key] = fs
        return fs
    end
    function ctx.Texture(block, key)
        local texture = {}
        setmetatable(texture, {__index = function(_, method) return function(self, ...) rawset(self, "_" .. method, {...}) end end})
        block.textures[key] = texture
        return texture
    end
    function ctx.Place(block, x, y, width, height) block.x, block.y, block.width, block.height = x, y, width, height end
    function ctx.Lines(_, _, width, value) return WrapLines(value, width) end
    function ctx.Width(_, value) return #Plain(value) * 6.5 end
    return ctx
end
local function Removable(scene)
    for _, block in ipairs(page.blocks) do
        if block.entries == scene.entries then return true end
    end
    return false
end
for _, style in ipairs({"a", "b", "c", "d", "e"}) do
    for _, mode in ipairs({"all", "highlights", "story", "storyBrief"}) do
        if not (style == "a" and mode == "all") then
            local book = A.JournalBook(person)
            local ctx = Stand()
            local told = {}
            function ctx.Story(day, voice)
                told[voice] = told[voice] or A.JournalTale.Tell(person, book, voice, {race = "Scourge", faction = "Horde"}, mode == "storyBrief")
                return told[voice][day.key]
            end
            local height = A.JournalStyles[style](ctx, book, person, mode)
            check(type(height) == "number" and height > 100, style .. "/" .. mode .. ": laid out (" .. tostring(height) .. " px)")
            local lastY = 1
            for _, block in ipairs(page.blocks) do
                check(block.y ~= nil and block.height and block.height > 0, style .. "/" .. mode .. ": every block placed")
                if block.x == 0 or style ~= "c" then
                    check(block.y <= lastY, style .. "/" .. mode .. ": blocks go down the page")
                    lastY = block.y
                end
            end
            -- A right-click removes what a block shows: every scene in
            -- Everything, your line in Highlights.
            if mode == "all" then
                for _, scene in ipairs(book[2].scenes) do
                    check(Removable(scene), style .. ": the " .. scene.kind .. " scene can be removed")
                end
            else
                local quote, heading
                for _, block in ipairs(page.blocks) do
                    if block.entries and block.entries[1] == custom then quote = block end
                    for _, fs in pairs(block.texts) do
                        if type(fs.text) == "string" and fs.text:upper():find("CHAPTER ", 1, true) then heading = true end
                    end
                end
                check(quote and quote.what == "line", style .. "/" .. mode .. ": your line can be removed")
                if mode ~= "highlights" then check(heading, style .. "/" .. mode .. ": chapter headings") end
            end
        end
    end
end

-- The diary: a red drop cap, the words beside it and below it all there.
days = A.JournalBook(person)
A.JournalStyles.d(Stand(), days, person, "all")
local opening
for _, block in ipairs(page.blocks) do
    if block.texts.cap and block.entries == days[2].scenes[1].entries then opening = block end
end
local openingText = A.JournalPlain(A.JournalSceneText(person, sunday.scenes[1], "we"))
check(opening and opening.texts.cap.text == openingText:sub(1, 1), "Sunday opens with a drop cap")
-- The diary sets its own lines: all in ink, every word kept, two lines beside the capital.
local lines, beside = {}, 0
for i = 1, 40 do
    local line = opening.texts["line" .. i]
    if not line then break end
    lines[#lines + 1] = line.text
    check(not line.text:find("|c", 1, true), "the diary's words are all in ink: " .. line.text)
    check(#Plain(line.text) * 6.5 <= line.width - 20 + 0.01, "each line fits its width: " .. line.text)
    if line.point[2] > 0 then beside = beside + 1 end
end
local rebuilt = Plain(opening.texts.cap.text .. table.concat(lines, " "))
check(rebuilt == Plain(A.JournalColored(A.JournalSceneText(person, sunday.scenes[1], "we"), {})),
    "every word is kept around the drop cap: " .. rebuilt)
check(beside == 2, "two lines beside the capital: " .. beside)
check(opening.texts["line3"].point[2] == 0 and opening.texts["line3"].point[3] < 0, "the rest runs below at full width")
-- Places and foes get a red quill stroke, quests a faint brown one, under the name alone.
local strokes, red = 0, 0
for key, texture in pairs(opening.textures) do
    if key:match("^ink%d+$") then
        strokes = strokes + 1
        check(texture._SetTexture[1]:find("Ornaments\\ink%d$"), "a quill stroke: " .. tostring(texture._SetTexture[1]))
        if texture._SetVertexColor[1] == 0.49 then red = red + 1 end
        check(texture._SetSize[1] > 6 and texture._SetSize[2] == 7, "a stroke as long as its name")
    end
end
check(strokes > 0 and red > 0, "names are underlined in ink: " .. strokes .. " strokes, " .. red .. " red")
-- A two-word name is one stroke: "Silverpine Forest" (15 characters, 6.5 px each, plus the overhang).
local long = false
for key, texture in pairs(opening.textures) do
    if key:match("^ink%d+$") and math.abs(texture._SetSize[1] - (#"Silverpine Forest" * 6.5 + 6)) < 0.01 then long = true end
end
check(long, "a name of two words is underlined in one stroke")
-- The diary reads in DialogueUI's Friz (the game's Friz without it), 14; Morpheus only for titles.
local reading = createdFonts["CompanionJournalFont_dialogue14"]
check(reading and (reading.path == "Fonts\\FRIZQT__.TTF" or reading.path:find("DialogueUI", 1, true)), "the diary is set in the reading font")

-- The ledger: the day's band with its numbers.
A.JournalStyles.e(Stand(), A.JournalBook(person), person, "all")
local band = page.blocks[3]
check(band.texts.date.text == "SUN 27 SEP", "the band's date: " .. tostring(band.texts.date.text))
check(band.texts.totals.text == "2 h 45 together  \194\183  7 quests  \194\183  4 foes", "the band's numbers: " .. tostring(band.texts.totals.text))

-- The margins: the day number beside its scenes, times on the right.
A.JournalStyles.c(Stand(), A.JournalBook(person), person, "all")
local margins, times = {}, 0
for _, block in ipairs(page.blocks) do
    if block.texts.day then margins[#margins + 1] = block.texts.day.text end
    if block.texts.time and block.texts.time.justify == "RIGHT" then times = times + 1 end
end
check(table.concat(margins, ",") == "26,27", "day numbers in the margin: " .. table.concat(margins, ","))
check(times == 5, "each scene's time on the right: " .. times)

-- 6. Removing a whole scene with one refresh.
local refreshed = 0
A.RefreshJournal = function() refreshed = refreshed + 1 end
A.JournalRemoveEntries(person, early.entries)
check(refreshed == 1 and #journal == 22 - 5, "the scene's five lines removed at once: " .. #journal)
days = A.JournalBook(person)
check(days[2].scenes[1].zone == "Silverpine Forest" and days[2].scenes[1].campfire, "the evening outing now opens the day")

-- Your own level-ups (kept since 1.3): told as yours, and as "both" when you
-- level together.
do
    local p = {name = "Mira-Forever", class = "PRIEST", journal = {}}
    local t = os.time({year = 2026, month = 9, day = 28, hour = 20})
    p.journal = {
        {k = "group", t = t, e = t + 3600, z = "The Barrens"},
        {k = "level", t = t + 600, d = 18, z = "The Barrens"},
        {k = "mylevel", t = t + 700, d = 18, z = "The Barrens"},
        {k = "mylevel", t = t + 3000, d = 19, z = "The Barrens"},
    }
    local book = A.JournalBook(p)
    local scene = book[#book].scenes[1]
    local text = A.JournalPlain(A.JournalSceneText(p, scene, "we"))
    check(text:find("Mira and I both reached level 18.", 1, true), "levelling together, one sentence: " .. text)
    check(text:find("I [%a ]+ level 19%.") ~= nil, "your level alone: " .. text)
    check(not text:find("Mira [%a ]*level 19", 1), "your level is never theirs: " .. text)
    local highlights = A.JournalPlain(A.JournalDayHighlights(p, book[#book], "you"))
    check(highlights:find("you and Mira both reached level 18", 1, true) or highlights:find("You and Mira both reached level 18", 1, true),
        "Highlights: both levels in one sentence: " .. highlights)
    local items = A.JournalSceneItems(p, scene)
    local mine = false
    for _, item in ipairs(items) do if item.text == "You reached level 19" then mine = true end end
    check(mine, "the list styles show your level too")
end

-- A full display name must keep its identity when a style splits it into
do
    local t = T(28, 10, 0)
    local p = {name = "Dahlia-Noir", journal = {
        {k = "group", z = "Mulgore", t = t, e = t + 1800},
        {k = "quest", d = "Call of Earth", qid = 1519, t = t + 60, z = "Mulgore"},
        {k = "quest", d = "Call of Earth", qid = 1520, t = t + 120, z = "Mulgore"},
    }}
    local scene = A.JournalBook(p)[1].scenes[1]
    check(#scene.quests == 2, "same-title chain stages keep separate identities")
    check(scene.quests[1].qid == 1519 and scene.quests[2].qid == 1520, "quest IDs survive scene grouping in order")
end

-- A full display name must keep its identity when a style splits it into
-- words or turns its initial into a decorative capital.
do
    A.bookLinks = {["dahlia of the long remembered name"] = "dahlia-noir"}
    local markup = "{n:Dahlia of the Long Remembered Name}, my spouse, stood beside {p:Undercity}."
    has(A.JournalColored(markup, {}), "|Hcjperson:dahlia-noir|h|cff3b3870", "companion links use distinct ink")
    lacks(A.JournalColored("{n:A stranger} and {p:Undercity}", {}), "|H", "unmapped names and places do not acquire false links")
    for _, style in ipairs({"a", "b", "c", "d", "e"}) do
        local ctx = Stand()
        ctx.width, ctx.reading = 180, true
        function ctx.Story() return {text = markup, quotes = {}, chapter = 1, title = "Together"} end
        A.JournalStyles[style](ctx, {saturday}, person, "storyBrief")
        local labels, capLinked = {}, false
        for _, block in ipairs(page.blocks) do
            for key, fs in pairs(block.texts) do
                for target, label in (fs.text or ""):gmatch("|Hcjperson:([^|]+)|h(.-)|h") do
                    check(target == "dahlia-noir", style .. ": every alias fragment opens the same companion")
                    labels[#labels + 1] = Plain(label)
                    if key == "cap" then capLinked = true end
                end
            end
        end
        local joined = table.concat(labels, " ")
        for _, word in ipairs({"of", "the", "Long", "Remembered", "Name"}) do
            has(joined, word, style .. ": full alias stays linked across line breaks")
        end
        if style == "b" or style == "d" then check(capLinked, style .. ": opening capital remains clickable") end
    end
    A.bookLinks = nil
end

io.write("PASS: " .. assertions .. " book assertions\n")
