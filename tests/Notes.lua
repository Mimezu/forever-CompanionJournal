-- Run from the client root: lua5.1 Interface/AddOns/CompanionJournal/tests/Notes.lua
-- Manual-note identity/ownership, dates, actual book note actions and footer.
local root, count = "Interface/AddOns/CompanionJournal/", 0
local function check(ok, message) count = count + 1; assert(ok, message) end
local function Object()
    local obj = {shown = true, width = 400, height = 500, points = {}, scripts = {}, spacing = 0}
    function obj:Show() self.shown = true end
    function obj:Hide() self.shown = false end
    function obj:IsShown() return self.shown end
    function obj:SetShown(v) self.shown = v and true or false end
    function obj:SetWidth(v) self.width = v end
    function obj:SetHeight(v) self.height = v end
    function obj:SetSize(w, h) self.width, self.height = w, h end
    function obj:GetWidth() return self.width end
    function obj:GetHeight() return self.height end
    function obj:GetTop() return 0 end
    function obj:GetFrameLevel() return 1 end
    function obj:SetPoint(...) self.points[#self.points + 1] = {...} end
    function obj:ClearAllPoints() self.points = {} end
    function obj:SetText(v) self.text = v end
    function obj:GetText() return self.text or "" end
    function obj:SetSpacing(v) self.spacing = v end
    function obj:GetSpacing() return self.spacing end
    function obj:GetNumLines() return math.max(1, math.ceil(#self:GetText() * 6 / math.max(1, self.width))) end
    function obj:GetStringHeight() return self:GetNumLines() * 16 + (self:GetNumLines() - 1) * self.spacing end
    function obj:GetStringWidth() return #self:GetText() * 6 end
    function obj:GetUnboundedStringWidth() return self:GetStringWidth() end
    function obj:SetScript(k, v) self.scripts[k] = v end
    function obj:GetScript(k) return self.scripts[k] end
    function obj:CreateTexture() return Object() end
    function obj:CreateFontString() return Object() end
    function obj:RegisterForClicks(...) self.clicks = {...} end
    function obj:SetFocus() self.focus = true end
    function obj:ClearFocus() self.focus = false end
    return setmetatable(obj, {__index = function(_, key)
        if key:match("^[A-Z]") and key ~= "ScrollBar" and key ~= "ThumbTexture" then return function() end end
    end})
end
function CreateFrame() return Object() end
function CreateFont() return Object() end
QuestFont, UIParent, GameTooltip = Object(), Object(), Object()
function GetLocale() return "enUS" end
function UnitLevel() return 10 end
local clock = os.time({year = 2026, month = 10, day = 13, hour = 14, min = 0, sec = 0})
function time(arg) return arg and os.time(arg) or clock end
function date(fmt, stamp) return os.date(fmt, stamp or clock) end
function GetRealZoneText() return "Current zone" end
C_Timer = {After = function() end}
local A = {defaults = {colors = {}}}
for _, file in ipairs({"Characters.lua", "Journal.lua", "JournalSelf.lua", "JournalBook.lua", "JournalStyles.lua"}) do
    assert(loadfile(root .. file))("CompanionJournal", A)
end
A.Me = function() return "me" end
A.GlyphPath = function(name) return "glyphs/" .. name end
local stamp = A.JournalNoteTimestamp("2026-10-12")
local one = {k = "custom", d = "I was arisen!", t = stamp}
local two = {k = "custom", d = "I was arisen!", t = stamp}
local automatic = {k = "mylevel", d = 10, t = stamp}
local altNote = {k = "custom", d = "Alt note", t = stamp}
local friendNote = {k = "custom", d = "Companion note", t = stamp}
local altFriendNote = {k = "custom", d = "Other keeper note", t = stamp}
A.db = {bookToday = false, bookLinks = false, bookVariants = {}, people = {buddy = {name = "Dahlia", note = "Shared card"}}, characters = {
    me = {name = "Me", journal = {one, two, automatic}, people = {buddy = {journal = {friendNote}}}},
    alt = {name = "Alt", journal = {altNote}, people = {buddy = {journal = {altFriendNote}}}},
}}
local refreshes = 0
A.RefreshJournal = function() refreshes = refreshes + 1 end
local own, buddy, alt, otherKeeper = A.SelfPerson(), A.People.buddy, A.SelfPerson("alt"), A.PersonAs("buddy", "alt")
check(own.journal == A.db.characters.me.journal and buddy.journal == A.db.characters.me.people.buddy.journal, "real views use their character's journals")
check(A.JournalRemoveNote(own, two), "targeted manual note can be removed")
check(#own.journal == 2 and own.journal[1] == one and own.journal[2] == automatic, "duplicate text preserves the other identity and generated event")
check(not A.JournalRemoveNote(own, automatic), "generated events cannot be removed as notes")
check(not A.JournalRemoveNote(own, {k = "custom", d = one.d, t = one.t}), "matching content cannot remove the original")
check(not A.JournalRemoveNote(own, friendNote), "another journal's note cannot be removed")
check(not A.JournalRemoveNote(alt, altNote) and not A.JournalRemoveNote(otherKeeper, altFriendNote), "other characters and keepers remain read only")
check(not A.JournalRemoveNote({self = true, charKey = "alt", journal = alt.journal}, altNote), "omitting readOnly cannot bypass self ownership")
check(not A.JournalRemoveNote({npc = true, journal = {one}}, one), "NPC profile notes are separate")
check(not A.JournalRemoveNote({recognizedBy = "alt", journal = {one}}, one), "recognized-only companions cannot be edited")
check(not A.JournalRemoveNote(own, {k = "custom", synthetic = true}), "synthetic text is protected")
check(refreshes == 1, "rejected removals do not refresh or mutate")
local past = A.JournalWrite(own, "  Earlier note  ", "2026-10-12")
check(past and past.d == "Earlier note" and date("%Y-%m-%d %H", past.t) == "2026-10-12 12", "past notes use the selected date at noon")
check(past.z == "", "past notes do not invent the player's current location")
check(A.JournalBook(own)[1].key == "2026-10-12", "backdated note renders in the correct chapter")
for _, invalid in ipairs({"2026-10-14", "2026-02-30", "2026-13-01", "2026-00-10", "2026-10-00", "12 October", ""}) do
    local before = #own.journal
    check(not A.JournalWrite(own, "Must not be written", invalid) and #own.journal == before, "invalid/future date is rejected: " .. invalid)
end
check(not A.JournalWrite(alt, "No", "2026-10-12") and not A.JournalWrite(otherKeeper, "No", "2026-10-12"), "dated writes honor read-only ownership")
local companion = A.JournalWrite(buddy, "Friend's past note", "2026-10-12")
check(companion and buddy.journal[2] == companion, "companion notes use only the selected relationship")
check(#alt.journal == 1 and alt.journal[1] == altNote and #otherKeeper.journal == 1 and otherKeeper.journal[1] == altFriendNote, "other character histories stay unchanged")
check(A.db.people.buddy.note == "Shared card", "shared card notes stay unchanged")
local ordinary = A.JournalWrite(own, "Today without a date")
check(ordinary.t == clock and ordinary.z == "Current zone", "legacy writes preserve timestamp and place")
clock = os.time({year = 2026, month = 10, day = 14, hour = 2, min = 0, sec = 0})
local night = A.JournalWrite(own, "After midnight", "2026-10-13")
check(night.t == clock and A.JournalBook(own)[#A.JournalBook(own)].key == "2026-10-13", "today honors the evening boundary after midnight")
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
local Build = Upvalue(Upvalue(A.OpenBook, "open"), "Build")
local Page = Upvalue(Build, "Page")
local BindNoteActions = Upvalue(Page, "BindNoteActions")
local UpdateWriteDate = Upvalue(A.RefreshBook, "UpdateWriteDate")
local ChooseWriteDate, WriteNote = Upvalue(Build, "ChooseWriteDate"), Upvalue(Build, "WriteNote")
local DrawChapter = Upvalue(Upvalue(A.RefreshBook, "PageChapters"), "DrawChapter")
local LayoutPages, state = Upvalue(A.RefreshBook, "LayoutPages"), Upvalue(A.RefreshBook, "state")
local book = Object()
book.input, book.write, book.noteDate, book.writeHint = Object(), Object(), Object(), Object()
book.noteDate.label = Object(); book.noteDate:SetWidth(58)
Upvalue(A.RefreshBook, "book", book)
state.key, state.owner, state.view = "self:me", nil, "journal"
local current = {day = {key = "2026-10-13"}}
A.RefreshJournal = function() refreshes = refreshes + 1 end
A.RefreshBook = function() UpdateWriteDate(A.SelfPerson(), current) end
UpdateWriteDate(A.SelfPerson(), current)
check(book.writeDay == "2026-10-13" and book.noteDate.label:GetText() == "Today", "footer defaults to the reading day")
local NoteDateLabel = Upvalue(UpdateWriteDate, "NoteDateLabel")
check(NoteDateLabel("2026-10-13"):find("13 October", 1, true) ~= nil, "full target date honors the evening boundary after midnight")
ChooseWriteDate()
check(book.notePopup.title:GetText() == "Add a note on..." and #book.notePopup.rows == 2, "date choices contain today and this journal's earlier day")
book.notePopup.rows[2]:GetScript("OnClick")()
check(book.writeDay == "2026-10-12" and book.noteDate.label:GetText() == "12 Oct", "choosing an earlier date updates the visible target")
book.input:SetText("Added through footer")
local added = WriteNote()
check(added and date("%Y-%m-%d", added.t) == "2026-10-12" and state.jumpDay == "2026-10-12", "footer write targets and returns to chosen day")
check(book.input:GetText() == "", "successful write clears the draft")
book.input:SetText("Own draft"); state.key = "buddy"
UpdateWriteDate(buddy, {classic = {key = "2026-10-12"}})
check(book.input:GetText() == "" and book.writeDay == "2026-10-12", "journal switches clear drafts and use their own reading day")
state.key = "self:alt"; UpdateWriteDate(alt, current)
check(not book.input:IsShown() and not book.write:IsShown() and not book.noteDate:IsShown() and not WriteNote(), "read-only journals hide and block writing")
state.key = "self:me"; UpdateWriteDate(A.SelfPerson(), current); ChooseWriteDate()
local staleChoice = book.notePopup.rows[2]:GetScript("OnClick")
state.key = "buddy"; staleChoice()
check(state.noteDay == nil, "stale date choices cannot change another journal")
state.key = "self:me"; UpdateWriteDate(A.SelfPerson(), current)
local uiOne = {k = "custom", d = "Duplicate UI note", t = stamp}
local uiTwo = {k = "custom", d = "Duplicate UI note", t = stamp}
own.journal[#own.journal + 1] = uiOne; own.journal[#own.journal + 1] = uiTwo
-- Notes are edited where they stand: a click opens the field, Enter keeps, Escape drops,
-- and clearing the text asks before removing. (The commit runs a frame later in game.)
C_Timer.After = function(_, f) f() end
local page = Page(book, "single", true); page.owner, page.notePerson = book, A.SelfPerson()
local function Finish(text, cancel)
    local edit = page.noteEditor
    if text then edit:SetText(text) end
    edit:GetScript(cancel and "OnEscapePressed" or "OnEnterPressed")(edit)
    edit:GetScript("OnEditFocusLost")(edit)
end
local both = Object(); both.entries = {uiOne, uiTwo}; BindNoteActions(both, page)
both:GetScript("OnClick")(both, "LeftButton")
check(book.notePopup.title:GetText() == "Edit which note?" and book.notePopup.rows[2] ~= nil, "several notes on one line ask which to edit")
book.notePopup.rows[2]:GetScript("OnClick")()
check(page.noteEditor:IsShown() and page.noteEditor:GetText() == uiTwo.d, "the chosen note opens for editing")
Finish(nil, true)
local anchor = Object(); anchor.entries = {automatic, uiTwo}; BindNoteActions(anchor, page)
local before = #own.journal
anchor:GetScript("OnClick")(anchor, "LeftButton")
check(page.noteEditor:IsShown() and page.noteEditor:GetText() == "Duplicate UI note" and page.noteEditor.focus, "a click opens the note for editing on the page")
Finish("  Edited in place  ")
check(uiTwo.d == "Edited in place" and uiOne.d == "Duplicate UI note" and #own.journal == before and not page.noteEditor:IsShown(), "Enter keeps the edit, on that note only")
anchor:GetScript("OnClick")(anchor, "RightButton"); Finish("Not kept", true)
check(uiTwo.d == "Edited in place", "Escape drops the change")
anchor:GetScript("OnClick")(anchor); Finish("   ")
check(book.notePopup.title:GetText() == "Remove this note?" and #own.journal == before, "clearing the text asks before removing")
book.notePopup.rows[2]:GetScript("OnClick")()
check(#own.journal == before and uiTwo.d == "Edited in place", "Keep note preserves history")
anchor:GetScript("OnClick")(anchor); Finish(""); book.notePopup.rows[1]:GetScript("OnClick")()
check(#own.journal == before - 1 and own.journal[#own.journal] == uiOne, "UI removes only the selected duplicate identity")
anchor.entries = {uiOne}; anchor:GetScript("OnClick")(anchor); Finish("")
local staleRemove = book.notePopup.rows[1]:GetScript("OnClick")
state.key = "buddy"; staleRemove()
check(own.journal[#own.journal] == uiOne and buddy.journal[1] == friendNote, "stale confirmations do not cross journals")
state.key = "self:me"; anchor:GetScript("OnClick")(anchor); state.key = "buddy"; Finish("Crossed")
check(uiOne.d == "Duplicate UI note", "stale edits do not cross journals")
book.notePopup:Hide(); page.noteEditor:Hide(); anchor.entries = {automatic}; state.key = "self:me"
anchor:GetScript("OnClick")(anchor)
check(not book.notePopup:IsShown() and not page.noteEditor:IsShown(), "generated entries cannot be edited")
check(not A.JournalEditNote(own, automatic, "x") and not A.JournalEditNote(alt, altNote, "x") and not A.JournalEditNote(own, uiOne, "  "), "only your own written notes take an edit, and not an empty one")
DrawChapter(page, own, {classic = {key = "2026-10-12", title = "12 October", lines = {
    {text = "I was arisen!", custom = true, entry = one}, {text = "Reached level 10", entry = automatic},
}}}, "a", "all")
check(page.lines[2].noteHit:IsShown() and not page.lines[3].noteHit:IsShown(), "classic log exposes only manual notes")
page.lines[2].noteHit:GetScript("OnClick")(page.lines[2].noteHit, "LeftButton")
check(page.noteEditor:IsShown() and page.noteEditor:GetText() == one.d, "classic note click opens it for editing")
Finish(nil, true)
local day = A.JournalBook(own)[1]
A.JournalTale = {Roman = function(n) return tostring(n) end}
local function Story() return {text = "", title = "", chapter = 1, quotes = {{text = one.d, entries = {one}}}} end
for _, style in ipairs({"a", "b", "c", "d", "e"}) do
    for _, mode in ipairs({"all", "highlights", "story", "storyBrief"}) do
        DrawChapter(page, own, {day = day}, style, mode, Story)
        local found
        for i = 1, page.used do
            local block = page.blocks[i]
            for _, entry in ipairs(block.entries or {}) do if entry == one then found = block end end
        end
        check(found ~= nil, style .. "/" .. mode .. ": authored note retains source identity")
        page.noteEditor:Hide(); found:GetScript("OnClick")(found, "LeftButton")
        check(page.noteEditor:IsShown() and page.noteEditor:GetText() == one.d, style .. "/" .. mode .. ": the note can be edited")
        Finish(nil, true)
    end
end
check(not page.lines[2].noteHit:IsShown(), "changing classic mode hides stale note hit regions")
state.key, page.notePerson, anchor.entries = "buddy", buddy, {friendNote, automatic}
local ownCount, buddyCount = #own.journal, #buddy.journal
anchor:GetScript("OnClick")(anchor, "LeftButton")
check(page.noteEditor:GetText() == "Companion note", "companion note editing opens the selected journal's note")
Finish(""); book.notePopup.rows[1]:GetScript("OnClick")()
check(#buddy.journal == buddyCount - 1 and buddy.journal[1] == companion and #own.journal == ownCount, "companion removal affects only its manual note and keeps the player's journal")
check(otherKeeper.journal[1] == altFriendNote, "companion removal preserves the same person's other keeper history")
state.key = "self:me"
book.skinB, book.left, book.right = true, Object(), Object()
book.leftPage, book.rightPage, book.contents, book.panel = Page(book, "single", true), Page(book, "single", true), Page(book, "single"), Page(book, "single")
book.contentsChild, book.chapterLabel = book.contents.child, Object()
for _, marks in ipairs({"a", "c"}) do
    A.db.bookVariants.marks = marks
    for _, width in ipairs({760, 860, 1000, 1140}) do
        book:SetSize(width, 580); LayoutPages()
        local half = math.floor((width - 20) / 2)
        local writingEnd = 41 + book.input:GetWidth() + 8 + 58 + 6 + 50 + 6 + 56
        local arrowLeft = width - 7 - half / 2 - (marks ~= "c" and 38 or 0) - book.chapterLabel:GetWidth() / 2 - 4 - 26
        check(writingEnd <= 13 + half - 16 and writingEnd + 20 <= arrowLeft and book.input:GetWidth() >= 140, "date/write/retell stay on their leaf and clear of navigation: " .. width .. "/" .. marks)
    end
end
check(#alt.journal == 1 and otherKeeper.journal[1] == altFriendNote and A.db.people.buddy.note == "Shared card", "UI preserves other characters and shared profiles")
print("PASS: " .. count .. " note assertions")
