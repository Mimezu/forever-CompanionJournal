-- Run from the client root: lua5.1 Interface/AddOns/CompanionJournal/tests/Portraits.lua
-- Exercise the actual book selection, page preparation and spread navigation.
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
    function obj:GetStringWidth() return 100 end
    function obj:GetStringHeight() return self.stringHeight or 14 end
    function obj:GetNumLines() return 1 end
    function obj:SetScript(key, value) self.scripts[key] = value end
    function obj:GetScript(key) return self.scripts[key] end
    function obj:CreateTexture() return Object() end
    function obj:SetEnabled(value) self.enabled = value end
    function obj:Style(value) self.style = value end
    function obj:Fill(info) self.info = info; self:Show() end
    return setmetatable(obj, {__index = function(_, key)
        if key:match("^[A-Z]") then return function() end end
    end})
end
function CreateFrame() return Object() end
function UnitGUID() return "Player-Test" end
local A = {defaults = {}, db = {bookVariants = {}, bookSpread = "one"}, People = {}}
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
local PortraitFor = Upvalue(A.RefreshBook, "PortraitFor")
local PreparePage = Upvalue(A.RefreshBook, "PreparePage")
local PageChapters = Upvalue(A.RefreshBook, "PageChapters")
local FillContents = Upvalue(A.RefreshBook, "FillContents")
local ContentsPortrait = Upvalue(A.RefreshBook, "ContentsPortrait")
local state = Upvalue(A.RefreshBook, "state")
local person = {self = true, charKey = "me", name = "Test", startLevel = 3}
A.Me = function() return "me" end
A.SelfPerson = function(key) return key == "me" and person or nil end
A.EachPerson = function() return function() end end
A.PersonSummary = function() return "" end
A.JournalVoice = function() return "simple" end
A.SetPersonClassIcon = function(icon) icon:Hide() end
local saved = {level = 10, items = {}, zone = "Opening zone"}
WardrobeTimeCapsuleDB = {forever = {characters = {["Player-Test"] = {entries = {saved, {level = 30, items = {}}}}}}}
local function Chapter(levels, ci, part)
    local events = {}
    for _, level in ipairs(levels) do events[#events + 1] = {k = "mylevel", d = level} end
    return {day = {key = "day" .. ci, zone = "Chapter zone", scenes = {{events = events}}}, chapterIndex = ci, part = part}
end
local first, continuation = Chapter({10, 11}, 1, 1), Chapter({10, 11}, 1, 2)
for _, where in ipairs({"a", "b", "c", "d", "e"}) do
    A.db.bookVariants.portraitWhere = where
    for _, when in ipairs({"start", "ten", "level"}) do
        A.db.bookVariants.portraitWhen = when
        local info = PortraitFor(person, first, 1)
        check(info ~= nil, where .. "/" .. when .. ": opening leaf has portrait")
        check(info.level == (when == "level" and 11 or 10), "scheduled level selected")
        check(info.look == saved, "historical look selected for the scheduled level")
        for part = 2, 5 do
            continuation.part = part
            check(PortraitFor(person, continuation, 1) == nil, where .. "/" .. when .. ": continuation has no portrait")
        end
    end
end
A.db.bookVariants.portraitWhen = "start"
check(PortraitFor(person, Chapter({}, 1, 1), 1).level == 3, "book start falls back to recorded starting level")
check(PortraitFor(person, Chapter({20}, 2, 1), 2) == nil, "book start excludes later chapters")
A.db.bookVariants.portraitWhen = "ten"
check(PortraitFor(person, Chapter({11}, 2, 1), 2) == nil, "ten-level schedule excludes other levels")
check(PortraitFor(person, Chapter({20}, 2, 1), 2).level == 20, "ten-level schedule includes a later milestone")
A.db.bookVariants.portraitWhen = "level"
check(PortraitFor(person, Chapter({}, 2, 1), 2) == nil, "level schedule excludes chapters without a level")
check(PortraitFor({self = false}, first, 1) == nil, "companion journals do not get player portraits")
check(PortraitFor({self = true, charKey = "other"}, first, 1) == nil, "another character does not get current player's look")
A.db.bookVariants.portraitWhen = "off"
check(PortraitFor(person, first, 1) == nil, "off suppresses portraits")

local function Page()
    local page = Object()
    page.box, page.pad = {20, 20, 20, 20}, 40
    page.scroll, page.child, page.empty, page.today, page.portrait = Object(), Object(), Object(), Object(), Object()
    page.blocks, page.lines, page.ctx, page.used = {}, {}, {}, 0
    return page
end
-- Keep rendering independent of WoW's fonts, but use the actual paginator and
-- preparation code. Simulated rows represent a long, measured chapter.
Upvalue(PageChapters, "DrawChapter", function(page, _, chapter)
    page.leaf = chapter
    page.empty:SetShown(not chapter)
    page.contentHeight = 1000
    page.lines = {}
    for y = 0, 980, 20 do
        local row = Object(); row.top, row.text = -y, "text"
        page.lines[#page.lines + 1] = row
    end
end)
local page = Page()
A.db.bookVariants.portraitWhen = "start"
for _, where in ipairs({"a", "b", "c", "e"}) do
    local leaves = PageChapters(page, person, {first}, "b", "all", nil, function(p, chapter, ci)
        PreparePage(p, PortraitFor(person, chapter, ci), where)
    end)
    check(#leaves > 1, "portrait chapter paginates")
    check(leaves[2].extent > leaves[1].extent or where == "e", "continuations reclaim plate/cameo height")
    local edge = 0
    for i, leaf in ipairs(leaves) do
        check(leaf.offset == edge, "measured leaves preserve consecutive offsets")
        edge = leaf.offset + leaf.extent
        local info = PortraitFor(person, leaf, leaf.chapterIndex)
        local frame = PreparePage(page, info, where, leaf)
        if frame then frame:Fill(info) end
        check(page.portrait:IsShown() == (i == 1), "portrait appears only on opening physical leaf")
        check(page.topInset == (i == 1 and (where == "c" and 176 or where == "e" and 0 or 236) or 0), "top inset belongs only to opening leaf")
        check(page.inset == (where == "e" and 118 or 0), "continuation retains measured margin width")
        check(page.child:GetWidth() == (where == "e" and 242 or 360), "redraw retains the measured text width")
    end
    check(edge == 1000, "last measured text remains reachable")
end

-- Run RefreshBook with UI-only helpers stubbed, keeping portrait preparation,
-- eligible-leaf selection, contents scheduling and navigation unchanged.
local book = Object()
for _, key in ipairs({"contents", "panel", "name", "summary", "readView", "footer", "input", "write", "retell", "cardHost", "quill", "flip", "addBar", "timeline", "classIcon", "pin", "chapterLabel", "prev", "next"}) do book[key] = Object() end
book.contents.box, book.contents.scroll, book.contents.portrait = {20, 20, 20, 20}, Object(), Object()
book.panel.scroll = Object()
book.leftPage, book.rightPage = Page(), Page()
book.leftPage.paper, book.rightPage.paper = Object(), Object()
book.sizeButtons, book.tabs, book.sections = {}, {}, {}
book.contentsChild = Object()
Upvalue(A.RefreshBook, "book", book)
for _, name in ipairs({"LayoutPages", "FillBookmarks", "PlaceCard", "FillTimeline", "ShowingRead", "FillSettings", "FillNPCs"}) do
    Upvalue(A.RefreshBook, name, function() end)
end
Upvalue(A.RefreshBook, "UnreadDays", function() return {} end)
Upvalue(FillContents, "AllUnread", function() return {} end)
Upvalue(FillContents, "FillList", function() end)
state.key, state.view = "self:me", "journal"
local leaves = {first, Chapter({10}, 1, 2), Chapter({20}, 2, 1), Chapter({20}, 2, 2), Chapter({21}, 3, 1)}
for _, leaf in ipairs(leaves) do leaf.parts = leaf.part == 1 and 2 or leaf.part end
local function Refresh(index, where, when, spread)
    A.db.bookVariants.portraitWhere, A.db.bookVariants.portraitWhen = where, when
    A.db.bookSpread = spread
    state.index = index
    state.pageCache = {leaves = leaves, style = "b", mode = "all"}
    book.contents:SetShown(spread == "one")
    A.RefreshBook(nil, true)
end
Refresh(1, "d", "start", "one")
check(book.contents.portrait:IsShown() and book.contents.portrait.info.level == 10, "contents follows opening leaf and historical level")
Refresh(2, "d", "start", "one")
check(not book.contents.portrait:IsShown(), "contents hides portrait on continuation")
Refresh(3, "d", "ten", "one")
check(book.contents.portrait:IsShown() and book.contents.portrait.info.level == 20, "contents follows later eligible milestone")
state.view = "settings"; A.RefreshBook(nil, true)
check(not book.contents.portrait:IsShown(), "settings hides stale contents portrait")
check(book.contents.scroll.points[1][3] == -20, "settings restores full contents viewport")
state.view = "journal"; Refresh(1, "d", "start", "one")
state.view = "npcs"; A.RefreshBook(nil, true)
check(not book.contents.portrait:IsShown(), "NPC section hides stale contents portrait")
state.view = "journal"
for _, where in ipairs({"a", "c", "e"}) do
    Refresh(1, where, "start", "two")
    check(book.leftPage.portrait:IsShown() and not book.rightPage.portrait:IsShown(), where .. ": opening spread excludes continuation portrait on the right")
    A.BookTurn(1)
    check(not book.leftPage.portrait:IsShown() and not book.rightPage.portrait:IsShown(), where .. ": later spread excludes book-start portrait on both pages")
    A.BookTurn(-1)
    check(book.leftPage.portrait:IsShown() and not book.rightPage.portrait:IsShown(), where .. ": return to book start restores one portrait")
    Refresh(1, where, "start", "one")
    check(book.rightPage.portrait:IsShown(), where .. ": single-page opening shows portrait")
    A.BookTurn(1)
    check(not book.rightPage.portrait:IsShown(), where .. ": single-page continuation hides portrait")
end
Refresh(1, "b", "start", "two")
check(table.concat(state.displayStarts, ",") == "1,2,4", "book-start facing plate reserves only the opening spread")
A.BookTurn(1)
check(state.index == 2 and state.spreadStep == 2, "book-start continuation uses a normal two-page spread")
check(not book.leftPage.portrait:IsShown() and not book.rightPage.portrait:IsShown(), "book-start continuation shows neither repeated facing plate nor inline portrait")
A.BookTurn(-1)
check(state.index == 1 and book.leftPage.portrait:IsShown(), "backward turn returns to the single book-start plate")
Refresh(1, "b", "ten", "two")
check(book.leftPage.portrait:IsShown() and not book.rightPage.portrait:IsShown(), "facing opening uses one portrait leaf")
check(table.concat(state.displayStarts, ",") == "1,2,3,4", "upcoming eligible leaf starts its own facing spread")
A.BookTurn(1)
check(state.index == 2 and state.spreadStep == 1, "continuation before milestone occupies one text leaf")
check(not book.leftPage.portrait:IsShown() and not book.rightPage.portrait:IsShown(), "continuation spread has no repeated portraits")
check(book.rightPage.leaf == nil, "next milestone waits for its own facing spread")
A.BookTurn(1)
check(state.index == 3 and book.leftPage.portrait.info.level == 20, "next milestone has its own facing portrait")
A.BookTurn(1)
check(state.index == 4 and state.spreadStep == 2, "remaining continuation and nonmilestone share a spread")
check(not book.leftPage.portrait:IsShown() and not book.rightPage.portrait:IsShown(), "shared continuation spread has no portraits")
A.BookTurn(-1)
check(state.index == 3 and book.leftPage.portrait.info.level == 20, "backward turn returns to milestone portrait")
A.BookTurn(-1)
check(state.index == 2 and not book.leftPage.portrait:IsShown(), "backward turn returns to preceding text leaf")
local originalLeaves = leaves
leaves = {first, Chapter({10}, 1, 2), Chapter({10}, 1, 3), Chapter({20}, 2, 1), Chapter({20}, 2, 2)}
for _, leaf in ipairs(leaves) do leaf.parts = leaf.chapterIndex == 1 and 3 or 2 end
state.jumpDay = "day2"
Refresh(1, "b", "ten", "two")
check(state.index == 4 and book.leftPage.portrait.info.level == 20, "day jump keeps an even-numbered facing milestone")
Upvalue(A.RefreshBook, "UnreadDays", function() return {"day2"} end)
state.jumpUnread = true
Refresh(1, "b", "ten", "two")
check(state.index == 4 and book.leftPage.portrait.info.level == 20, "unread jump keeps an even-numbered facing milestone")
Upvalue(A.RefreshBook, "UnreadDays", function() return {} end)
leaves = originalLeaves

local realRefresh, refreshes = A.RefreshBook, 0
A.RefreshBook = function() refreshes = refreshes + 1 end
state.pageCache = {}
A.SetBookVariant("portraitWhen", "off")
check(refreshes == 1 and state.pageCache == nil, "portrait setting invalidates measured pages and refreshes live")
A.SetBookVariant("portraitWhen", "off")
check(refreshes == 1, "unchanged portrait setting does not redraw")
A.RefreshBook = realRefresh
print("PASS: " .. count .. " portrait assertions")
