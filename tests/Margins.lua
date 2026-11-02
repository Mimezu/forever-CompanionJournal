-- Run from the client root: lua5.1 Interface/AddOns/CompanionJournal/tests/Margins.lua
-- Actual book geometry, paragraph measurement and physical-leaf rendering,
-- with deterministic font metrics in place of the client's font engine.
local root = "Interface/AddOns/CompanionJournal/"
local count = 0
local function check(ok, message) count = count + 1; assert(ok, message) end
local function Object()
    local obj = {shown = true, width = 400, height = 500, points = {}, scripts = {}}
    function obj:Show() self.shown = true end
    function obj:Hide() self.shown = false end
    function obj:IsShown() return self.shown end
    function obj:SetShown(value) self.shown = value and true or false end
    function obj:SetWidth(value) self.width = value end
    function obj:SetHeight(value) self.height = value end
    function obj:SetSize(w, h) self.width, self.height = w, h end
    function obj:GetWidth() return self.width end
    function obj:GetHeight() return self.height end
    function obj:GetTop() return self.top or 0 end
    function obj:SetPoint(...) self.points[#self.points + 1] = {...} end
    function obj:ClearAllPoints() self.points = {} end
    function obj:SetText(text) self.text = text end
    function obj:GetText() return self.text end
    function obj:GetStringHeight() return self.stringHeight or 16 end
    function obj:GetNumLines() return self.numLines or 1 end
    function obj:SetVerticalScroll(value) self.offset = value end
    function obj:SetScript(key, value) self.scripts[key] = value end
    function obj:GetScript(key) return self.scripts[key] end
    function obj:Style(value) self.style = value end
    function obj:Fill(info) self.info = info; self:Show() end
    return setmetatable(obj, {__index = function(_, key)
        if key:match("^[A-Z]") then return function() end end
    end})
end
function CreateFrame() return Object() end
local A = {defaults = {}, People = {}, db = {bookVariants = {portraitWhen = "start"}, bookToday = false, bookLinks = false, bookSpread = "two"}}
assert(loadfile(root .. "JournalPagination.lua"))("CompanionJournal", A)
assert(loadfile(root .. "JournalBookUI.lua"))("CompanionJournal", A)
local function Upvalue(fn, name, replacement)
    for i = 1, 100 do
        local key, value = debug.getupvalue(fn, i)
        if not key then break end
        if key == name then
            if replacement ~= nil then debug.setupvalue(fn, i, replacement) end
            return value
        end
    end
    error("Missing upvalue: " .. name)
end
local LayoutPages = Upvalue(A.RefreshBook, "LayoutPages")
local PageChapters = Upvalue(A.RefreshBook, "PageChapters")
local DrawChapter = Upvalue(PageChapters, "DrawChapter")
local PreparePage = Upvalue(A.RefreshBook, "PreparePage")
local PortraitFor = Upvalue(A.RefreshBook, "PortraitFor")
local state = Upvalue(A.RefreshBook, "state")
local function Page()
    local page = Object()
    page.box, page.pad = {30, 34, 40, 36}, 70
    page.child, page.scroll, page.empty, page.today, page.portrait = Object(), Object(), Object(), Object(), Object()
    page.blocks, page.lines, page.used = {}, {}, 0
    page.ctx = {page = page}
    return page
end
local book = Object()
book.skinB = true
book.left, book.right, book.contents, book.panel = Object(), Object(), Page(), Page()
book.leftPage, book.rightPage = Page(), Page()
book.contentsChild = book.contents.child
Upvalue(A.RefreshBook, "book", book)
local person = {self = true, charKey = "me", startLevel = 10}
A.Me = function() return "me" end
A.SelfPerson = function() return person end
function UnitGUID() return "Player-Test" end
state.key, state.view = "self:me", "journal"
local chapter = {day = {key = "opening", scenes = {{events = {{k = "mylevel", d = 10}}}}}}
A.JournalStyles = {b = function(ctx)
    -- A long paragraph wraps at the exact width DrawChapter gives the style.
    local paragraph = Object()
    paragraph.text, paragraph.numLines = "long paragraph", math.ceil(16000 / ctx.width)
    paragraph.stringHeight = paragraph.numLines * 16
    ctx.page.lines = {paragraph}
    ctx.measuredWidth = ctx.width
    return paragraph.stringHeight + 12
end}
local function Resize(width, height)
    book:SetSize(width, height)
    local half, paperHeight = math.floor((width - 20) / 2), height - 136
    book.leftPage:SetSize(half, paperHeight); book.rightPage:SetSize(half, paperHeight)
    LayoutPages()
end
local previous
for _, size in ipairs({{"a", 860, 580}, {"b", 1000, 660}, {"c", 1140, 740}}) do
    A.db.bookSize = size[1]
    state.pageCache = {old = true}
    Resize(size[2], size[3])
    check(state.pageCache == nil, "new size invalidates measured leaves")
    local left, right = book.leftPage.box, book.rightPage.box
    check(left[1] == right[3] and left[3] == right[1], "binding and outer margins mirror across both pages")
    check(left[3] > left[1] and right[1] > right[3], "both binding margins are wider than the outer edges")
    check(left[2] == right[2] and left[4] == right[4], "both pages share top and bottom margins")
    for edge = 1, 4 do
        check(left[edge] > (previous and previous[edge] or 0), "A through C progressively increase each margin")
        local expected = ({a = {38,34,40,28}, b = {54,52,58,42}, c = {70,70,76,56}})[size[1]]
        check(left[edge] == expected[edge], "margins use the requested 10 percent edge and 30 percent bottom reductions")
    end
    previous = {unpack(left)}
    local availableWidth = book.leftPage:GetWidth() - book.leftPage.pad
    local availableHeight = book.leftPage:GetHeight() - left[2] - left[4]
    check(availableWidth >= 300 and availableHeight >= 340, "chosen sizes retain a readable text area")
    check(book.leftPage.child:GetWidth() == availableWidth and book.rightPage.child:GetWidth() == availableWidth, "both styles receive the exact width between margins")
    check(book.contents.pad == 70 and book.panel.pad == 70, "contents and settings keep compact margins")
    local cache = {}; state.pageCache = cache
    LayoutPages()
    check(state.pageCache == cache, "unchanged geometry keeps the page cache")
    for _, where in ipairs({"off", "a", "c", "e"}) do
        local page = book.rightPage
        local leaves = PageChapters(page, person, {chapter}, "b", "all", nil, function(p, ch, ci)
            PreparePage(p, where ~= "off" and PortraitFor(person, ch, ci) or nil, where)
        end)
        local measuredWidth, measuredHeight = page.ctx.measuredWidth, page.contentHeight
        check(#leaves > 1, "long paragraphs continue with each chosen size and placement")
        local edge = 0
        for _, leaf in ipairs(leaves) do
            local info = where ~= "off" and PortraitFor(person, leaf, leaf.chapterIndex) or nil
            local frame = PreparePage(page, info, where, leaf)
            if frame then frame:Fill(info) end
            DrawChapter(page, person, leaf, "b", "all")
            check(page.ctx.measuredWidth == measuredWidth, "measurement and physical rendering use the same width")
            check(leaf.offset == edge and page.scroll.offset == edge, "rendered leaves preserve consecutive paragraph offsets")
            check(leaf.extent <= page:GetHeight() - page.box[2] - page.box[4] - page.topInset, "text stays above the actual bottom margin")
            check(page.scroll:GetHeight() == leaf.extent, "visible viewport matches its measured slice")
            check(page.scroll.points[1][2] == page.box[1] + page.inset and page.scroll.points[1][3] == -page.box[2] - page.topInset, "viewport starts at the measured left and top margins")
            check(page.scroll.points[2][2] == -page.box[3], "viewport ends at the measured right margin")
            check(measuredWidth >= 170 and page:GetHeight() - page.box[2] - page.box[4] - page.topInset >= 140, "portrait layouts retain usable paragraph width and height")
            check(page.portrait:IsShown() == (where ~= "off" and leaf.part == 1), "portrait still appears only on the eligible opening leaf")
            edge = leaf.offset + leaf.extent
            if leaf.part < leaf.parts then check(edge % 16 == 0, "page breaks never clip a rendered text row") end
        end
        check(edge == measuredHeight, "every measured row is reachable after reflow")
        if where == "a" or where == "c" then check(leaves[2].extent > leaves[1].extent, "continuations reclaim portrait space inside the new margins") end
    end
end
-- Dragged dimensions use the same policy rather than the last preset label.
A.db.bookSize = "custom"
state.pageCache = {}
Resize(1280, 820)
check(state.pageCache == nil, "drag resizing invalidates measured leaves")
for edge = 1, 4 do check(book.leftPage.box[edge] > previous[edge], "custom larger paper increases every margin") end
local customBox = {unpack(book.leftPage.box)}
state.pageCache = {}
Resize(1280, 900)
check(state.pageCache == nil and book.leftPage.box[2] > customBox[2], "height-only resize increases vertical margins and invalidates pagination")
check(book.leftPage.box[1] == customBox[1] and book.leftPage.box[3] == customBox[3], "height-only resize preserves horizontal margins")
Resize(760, 520)
PreparePage(book.rightPage, PortraitFor(person, chapter, 1), "e")
check(book.rightPage.child:GetWidth() >= 160, "minimum dragged size remains readable with a margin portrait")
PreparePage(book.rightPage, PortraitFor(person, chapter, 1), "a")
check(book.rightPage:GetHeight() - book.rightPage.box[2] - book.rightPage.box[4] - book.rightPage.topInset >= 140, "minimum dragged size preserves portrait text height")
print("PASS: " .. count .. " margin assertions")
