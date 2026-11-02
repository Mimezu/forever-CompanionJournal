-- Semantic paragraphs survive every prose style without splitting sentences.
local A = {JournalTale = {Roman = function() return "I" end}}
local checks = 0
local function check(ok, message) checks = checks + 1; assert(ok, message) end
local function object()
    local o = {size = 14, spacing = 0, width = 500, text = ""}
    function o:SetFont(_, size) self.size = size end
    function o:SetSpacing(n) self.spacing = n end
    function o:SetPoint(_, x, y) self.x, self.y = x, y end
    function o:SetWidth(n) self.width = n end
    function o:SetText(text) self.text = text end
    function o:GetStringWidth() return #self.text * self.size * .45 end
    function o:GetStringHeight()
        local n = math.max(1, math.ceil(self:GetStringWidth() / self.width))
        return n * self.size + (n - 1) * self.spacing
    end
    return setmetatable(o, {__index = function() return function() end end})
end
CreateFont = object
QuestFont = object()
function GetLocale() return "enUS" end
A.JournalColored = function(text) return text end
A.JournalPlain = function(text) return text end
A.JournalNameTarget = function() end
A.JournalTextLink = function(text) return text end
A.GlyphPath = function(glyph) return glyph end
A.JournalDayTotals = function() return {minutes = 60, quests = 3, foes = 0, zone = "Elwynn Forest"} end
local prose = "First work stayed together. Its result belonged here.\n\nSecond purpose started here. Its result stayed with it."
A.JournalDayHighlights = function() return prose, {} end
A.JournalSceneText = function() return prose end
assert(loadfile("Interface/AddOns/CompanionJournal/JournalStyles.lua"))("CompanionJournal", A)
local day = {title = "A day", weekday = "Monday", dayNumber = 3, month = "September", year = 2026, scenes = {}}
for _, reading in ipairs({false, true}) do for _, mode in ipairs({"story", "storyBrief", "highlights"}) do
    for _, style in ipairs({"a", "b", "c", "d", "e"}) do
        local placed = {}
        local ctx = {width = 480, reading = reading}
        ctx.Block = function() return {texts = {}} end
        ctx.Text = function(block, key, font)
            local fs = object(); fs.size = font.size
            block.texts[key] = fs; return fs
        end
        ctx.Texture = object
        ctx.Place = function(block, x, y, width, height)
            block.y, block.height = y, height; placed[#placed + 1] = block
        end
        ctx.Width = function(font, text) return #text * font.size * .45 end
        ctx.Lines = function(font, spacing, width, text) return math.max(1, math.ceil(ctx.Width(font, text) / width)) end
        ctx.Story = function() return {chapter = 1, text = prose, quotes = {}} end
        A.JournalStyles[style](ctx, {day}, {self = true}, mode)
        local bodies = {}
        for _, block in ipairs(placed) do
            local joined = ""
            for _, fs in pairs(block.texts) do joined = joined .. " " .. fs.text end
            if joined:find("stayed together", 1, true) or joined:find("Second purpose", 1, true) then
                bodies[#bodies + 1] = block
                check(not joined:find("\n\n", 1, true), style .. " lays out paragraph boundaries instead of embedding blank lines")
            end
        end
        check(#bodies == 2, style .. " keeps two complete semantic paragraphs")
        local gap = bodies[1].y - bodies[1].height - bodies[2].y
        -- Original A reserves two pixels inside the block for its hit region.
        check(gap >= 5 and gap <= 8, style .. " has a modest visible paragraph gap")
    end
end end
print("StyleReadability: " .. checks .. " checks")
