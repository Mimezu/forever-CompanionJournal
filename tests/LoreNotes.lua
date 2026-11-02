-- Run from client root: lua Interface/AddOns/CompanionJournal/tests/LoreNotes.lua
local root = "Interface/AddOns/CompanionJournal/"
local A = {People = {dahlia = {name = "Dahlia"}}, db = {sentinel = "unchanged"}}
local count = 0
local function Check(value, message) count = count + 1; assert(value, message) end
local function Load(name) assert(loadfile(root .. name))("CompanionJournal", A) end
local function HasRelated(entry, id)
    for _, target in ipairs(entry.related or {}) do if target == id then return true end end
    return false
end
local function WorldContext(entry)
    Check(entry.after == nil, "world reference has no quest completion passage: " .. entry.id)
    local body = entry.body:lower()
    for _, claim in ipairs({"you defeated", "you killed", "we defeated", "we killed", "your victory"}) do
        Check(not body:find(claim, 1, true), "world reference does not invent a player victory: " .. entry.id)
    end
    for _, id in ipairs(entry.related or {}) do
        local related = A.GetLoreNote(id)
        Check(related and related.kind ~= "Quest" and related.after == nil, "related link resolves to world context rather than a quest ending: " .. entry.id)
    end
end
Load("LoreData.lua"); Load("Lore.lua")
Load("LoreAllianceStories.lua"); Load("LoreHordeStories.lua"); Load("LoreWorldStories.lua"); Load("LoreClassStories.lua")
Load("LoreNotes.lua")
Load("LoreDiscovery.lua"); Load("LoreDiscoveryData.lua")
Load("LorePlaces.lua"); Load("LorePeopleHistory.lua"); Load("LoreWorldConnections.lua")
local before = A.LoreNoteCoverage()
Check(before.curated >= 50, "reviewed starting-region, dungeon, raid and named-foe notes")
Check(before.packs == 5 and before.questID > 400, "regional, class and exact investigation quest coverage")
local geographicNotes = 0
for _, note in ipairs(A.LoreNoteCatalog()) do
    if note.kind == "Region" or note.kind == "City" then geographicNotes = geographicNotes + 1 end
end
-- Promoting an imported summary to reviewed prose must not look like lost coverage.
Check(geographicNotes >= 40, "regional coverage survives promotion to curated notes")
Check(A.LoreNoteResolve("p", "deathknell") == "place:deathknell", "case-insensitive exact alias")
Check(A.LoreNoteResolve("p", "  Tirisfal  ") == "place:tirisfal", "short alias")
Check(A.LoreNoteResolve("p", "Tyr’s Watch") == "place:tyrs-watch", "curly apostrophe alias")
Check(A.LoreNoteResolve("n", "Sylvanas") == "npc:sylvanas", "named NPC")
Check(A.LoreNoteResolve("p", "Arugal") == "npc:arugal", "foe markup resolves NPC")
Check(A.LoreNoteResolve("n", "Dahlia") == nil, "companions not fabricated as world lore")
Check(A.LoreNoteResolve("p", "unknown settlement") == nil, "unknown stays unlinked")
Check(A.LoreNoteResolve("bad", "Deathknell") == nil, "unknown markup stays unlinked")
Check(A.GetLoreNote("place:deathknell|hBAD") == nil, "malformed IDs rejected")
Check(A.GetLoreNote("npc:made-up") == nil, "unregistered IDs rejected")
Check(A.LoreNoteLink("Deathknell", "place:deathknell") == "|Hcjlore:place:deathknell|hDeathknell|h", "validated link")
Check(A.LoreNoteLink("unknown", "place:unknown") == "unknown", "unknown link unchanged")
Check(A.LoreNoteLink("|Hbad|hx|h", "place:deathknell") == "|Hbad|hx|h", "no nested hyperlinks")
local dungeons = {"Ragefire Chasm", "Wailing Caverns", "The Deadmines", "The Stockade", "Shadowfang Keep", "Blackfathom Deeps",
    "Gnomeregan", "Razorfen Kraul", "Razorfen Downs", "Scarlet Monastery", "Uldaman", "Zul'Farrak", "Maraudon",
    "The Temple of Atal'Hakkar", "Blackrock Depths", "Blackrock Spire", "Lower Blackrock Spire", "Upper Blackrock Spire",
    "Dire Maul", "Stratholme", "Scholomance", "Molten Core", "Onyxia's Lair", "Blackwing Lair", "Zul'Gurub",
    "Ruins of Ahn'Qiraj", "Temple of Ahn'Qiraj", "Naxxramas"}
for _, name in ipairs(dungeons) do
    local entry = A.GetLoreNote(A.LoreNoteResolve("p", name))
    Check(entry and (entry.kind == "Dungeon" or entry.kind == "Raid") and #entry.sources > 0, "sourced dungeon: " .. name)
    for _, id in ipairs(entry.related or {}) do
        local related = A.GetLoreNote(id)
        Check(related and related.kind ~= "Quest" and related.after == nil, "dungeon links resolve to places or established characters: " .. name)
    end
end
for _, name in ipairs({"Oggleflint", "Taragaman the Hungerer", "Jergosh the Invoker", "Bazzalan"}) do
    local p, n = A.LoreNoteResolve("p", name), A.LoreNoteResolve("n", name)
    Check(p and p == n and A.GetLoreNote(p).kind == "Person", "Ragefire identity from either markup: " .. name)
end
for _, name in ipairs({"Onyxia", "Nefarian"}) do
    local entry = A.GetLoreNote(A.LoreNoteResolve("p", name))
    Check(entry and entry.kind == "Person" and #entry.sources > 0, "source-supported raid figure: " .. name)
    WorldContext(entry)
end
local onyxia = A.GetLoreNote("npc:onyxia")
for _, name in ipairs({"Lady Katrana Prestor", "Lady Prestor"}) do
    Check(A.LoreNoteResolve("n", name) == "npc:katrana-prestor" and A.LoreNoteResolve("p", name) == "npc:katrana-prestor", "Prestor retains her public identity: " .. name)
    Check(A.LoreNoteLink(name, "npc:katrana-prestor"):find("|Hcjlore:npc:katrana-prestor|h", 1, true), "Prestor public identity is clickable: " .. name)
end
Check(onyxia.body:find("Lady Katrana Prestor", 1, true) and onyxia.body:find("Stormwind", 1, true), "Onyxia reference explains her established disguise and court influence")
Check(HasRelated(onyxia, "npc:bolvar") and HasRelated(onyxia, "dungeon:onyxia"), "Onyxia reference connects her court influence with her lair")
local varimathras = A.GetLoreNote(A.LoreNoteResolve("n", "Varimathras"))
Check(varimathras and varimathras.kind == "Person" and #varimathras.sources > 0, "Varimathras has a sourced character identity")
Check(A.LoreNoteResolve("p", "Varimathras") == varimathras.id and A.LoreNoteResolve("n", "Lord Varimathras") == varimathras.id, "Varimathras resolves from world markup and reviewed title alias")
Check(varimathras.body:find("dreadlord", 1, true) and varimathras.body:find("Sylvanas", 1, true) and varimathras.body:find("Undercity", 1, true), "Varimathras reference explains his identity, allegiance and authority")
Check(HasRelated(varimathras, "npc:sylvanas") and HasRelated(varimathras, "place:undercity"), "Varimathras links his leader and seat of authority")
WorldContext(varimathras)
for _, data in ipairs({
    {"dungeon:maraudon", "npc:zaetar", "npc:theradras"},
    {"dungeon:dire-maul", "npc:tortheldrin", "npc:immolthar"},
    {"dungeon:molten-core", "npc:ragnaros", "npc:executus"},
}) do
    local entry = A.GetLoreNote(data[1])
    Check(HasRelated(entry, data[2]) and HasRelated(entry, data[3]), "major dungeon reference links figures central to its history: " .. data[1])
    WorldContext(entry)
end
WorldContext(A.GetLoreNote("npc:rivendare"))
for _, id in ipairs({"dungeon:maraudon", "dungeon:dire-maul", "dungeon:molten-core", "npc:onyxia", "npc:varimathras", "npc:rivendare"}) do
    Check(#(A.GetLoreNote(id).related or {}) <= 3, "benchmark related links all fit the popup footer: " .. id)
end
Check(A.LoreNoteResolve("p", "DM") == nil, "ambiguous dungeon abbreviation is not guessed")
Check(A.LoreNoteResolve("p", "Ahn'Qiraj") == "place:ahnqiraj", "generic Ahn'Qiraj is not guessed to mean one instance")
Check(A.LoreNoteResolve("p", "LBRS") ~= A.LoreNoteResolve("p", "UBRS"), "Blackrock wings retain distinct identities")
Check(A.LoreNoteResolve("p", "Sunken Temple") == A.LoreNoteResolve("p", "The Temple of Atal'Hakkar"), "temple alias")
for _, name in ipairs({"Orgrimmar", "Undercity", "Thunder Bluff", "Stormwind", "Ironforge", "Darnassus"}) do
    Check(A.GetLoreNote(A.LoreNoteResolve("p", name)).kind == "City", "capital type: " .. name)
end
for packID, pack in pairs(A.Lore.storyPacks) do
    for qid, data in pairs(pack.questIDs or {}) do
        local id = A.LoreNoteResolve("q", data.title, {qid = qid})
        local note = id and A.GetLoreNote(id)
        Check(note and note.qid == qid and #note.sources > 0, "sourced exact quest " .. qid)
        local background = data.noteSummary or data.why[1]
        Check(note.after == nil and note.body == background:gsub("{[pqn]:([^}]*)}", "%1"):gsub("|", ""), "reference background without completion " .. qid)
    end
end
A.Lore.RegisterStoryPack("note-tests", {
    sources = {"test quest dialogue"},
    questIDs = {
        [990001] = {title = "Shared Test Title", why = {"First stage setup."}, after = {"SECRET ENDING ONE"}},
        [990002] = {title = "Shared Test Title", why = {"Second stage setup."}, after = {"SECRET ENDING TWO"}},
        [990003] = {title = "Stage Only", why = {"A stage without a generic title context."}, after = {"SECRET ENDING THREE"}},
    },
    quests = {['Shared Test Title'] = {why = {"Conservative chain background."}, after = {"SECRET GENERIC ENDING"}}},
    zones = {['Unreviewed Region'] = {sight = {"We won the whole campaign."}},
        ['Reviewed Future Region'] = {noteSummary = "A valley between wooded hills."}},
})
local general = A.GetLoreNote(A.LoreNoteResolve("q", "Shared Test Title"))
Check(general.body == "Conservative chain background." and not general.qid, "old title history gets conservative background")
Check(A.GetLoreNote(A.LoreNoteResolve("q", "Shared Test Title", {qid = 990002})).body == "Second stage setup.", "exact second stage")
Check(A.GetLoreNote(A.LoreNoteResolve("q", "Shared Test Title", {qid = 990003})).body == general.body, "mismatched ID cannot resolve another stage")
Check(A.LoreNoteResolve("q", "Stage Only") == nil, "stage-only title cannot guess ID")
Check(A.LoreNoteResolve("p", "Unreviewed Region") == nil, "new region sight pool not blindly trusted")
Check(A.LoreNoteResolve("p", "Reviewed Future Region") ~= nil, "future explicit note summary supported")
Check(A.LoreNoteResolve("q", "Shared Test Title", {qid = "990002|hBAD"}) ~= "quest:990002", "malformed quest ID not interpreted")

-- Minimal frame model exercises ownership, navigation, Escape and read-only UI.
local methods = {}
local function Object(parent, region)
    local obj = setmetatable({parent = parent, scripts = {}, children = {}, shown = true, width = 400, height = 300, text = "", scroll = 0,
        level = parent and parent:GetFrameLevel() + 1 or 0, region = region}, {__index = methods})
    if parent and not region then parent.children[#parent.children + 1] = obj end
    return obj
end
function methods:SetScript(key, fn) self.scripts[key] = fn end
function methods:GetParent() return self.parent end
function methods:SetParent(parent)
    if self.parent then
        for i, child in ipairs(self.parent.children) do if child == self then table.remove(self.parent.children, i); break end end
    end
    self.parent = parent
    if parent then parent.children[#parent.children + 1] = self end
end
function methods:GetChildren() return unpack(self.children) end
function methods:SetSize(w, h) self.width, self.height = w, h end
function methods:SetWidth(w) self.width = w end
function methods:SetHeight(h) self.height = h end
function methods:GetWidth() return self.width end
function methods:GetHeight() return self.height end
function methods:IsShown() return self.shown end
function methods:Show() self.shown = true end
function methods:Hide()
    local was = self.shown; self.shown = false
    if was and self.scripts.OnHide then self.scripts.OnHide(self) end
    if was then
        for _, child in ipairs(self.children) do
            if child.shown and child.scripts.OnHide then child.scripts.OnHide(child) end
        end
    end
end
function methods:SetShown(value) if value then self:Show() else self:Hide() end end
function methods:SetText(value) self.text = value end
function methods:GetStringHeight()
    local rows, columns = 0, math.max(1, math.floor(self.width / 7))
    for line in (self.text .. "\n"):gmatch("(.-)\n") do rows = rows + math.max(1, math.ceil(#line / columns)) end
    return rows * (self.fontSize or 16) + math.max(0, rows - 1) * (self.spacing or 0)
end
function methods:CreateFontString() return Object(self, true) end
function methods:CreateTexture() return Object(self, true) end
function methods:SetAtlas(atlas) self.atlas = atlas end
function methods:SetTexture(texture) self.texture = texture end
function methods:SetBlendMode(mode) self.blend = mode end
function methods:SetAlpha(alpha) self.alpha = alpha end
function methods:SetVertexColor(...) self.vertexColor = {...} end
function methods:SetFontObject(font) self.fontObject = font end
function methods:SetFont(path, size) self.fontPath, self.fontSize = path, size end
function methods:SetSpacing(value) self.spacing = value end
function methods:SetColorTexture(...) self.color = {...} end
function methods:SetAllPoints(target) self.fillsParent = true; self.allPointsTarget = target or self.parent end
function methods:SetBackdrop(value) self.backdrop = value end
function methods:GetFrameStrata() return self.strata or "DIALOG" end
function methods:SetFrameStrata(value) self.strata = value end
function methods:GetFrameLevel() return self.level end
function methods:SetFrameLevel(value)
    local delta = value - self.level; self.level = value
    for _, child in ipairs(self.children) do child:SetFrameLevel(child:GetFrameLevel() + delta) end
end
function methods:RegisterForClicks(...) self.clicks = {};for _, click in ipairs({...}) do self.clicks[click] = true end end
function methods:EnableMouse(value) self.mouseEnabled = value end
function methods:SetPropagateKeyboardInput(value) self.propagate = value end
function methods:SetVerticalScroll(value) self.scroll = value end
function methods:GetVerticalScroll() return self.scroll end
function methods:GetVerticalScrollRange() return 100 end
function methods:SetPoint(...) self.point = {...} end
local noop = function() end
for _, name in ipairs({"ClearAllPoints", "SetClampedToScreen", "SetTextColor", "SetJustifyH", "SetJustifyV", "SetShadowOffset", "SetBackdropBorderColor", "SetScrollChild", "EnableMouseWheel", "EnableKeyboard"}) do methods[name] = noop end
UIParent = Object(); UIParent:SetSize(1280, 900)
function CreateFrame(_, name, parent)
    local obj = Object(parent)
    if name then _G[name] = obj end
    return obj
end
GameTooltip = {
    SetOwner = function(self, owner) self.owner = owner end,
    SetText = function(self, text) self.lines = {text} end,
    AddLine = function(self, text) self.lines[#self.lines + 1] = text end,
    Show = function(self) self.shown = true end,
    Hide = function(self) self.shown = false end,
}
Load("LoreNotesUI.lua")
local book = Object(UIParent); book:SetSize(900, 650)
local reader = Object(UIParent); reader:SetSize(500, 600)
book.rightPage, reader.page = {}, {}
local row = Object(book); row:SetSize(360, 80)
local pageControl = Object(book); pageControl:SetFrameLevel(book:GetFrameLevel() + 80)
local linkedChild = Object(row)
local underlyingClicks = 0
for _, target in ipairs({book, row, pageControl, linkedChild, reader}) do
    target:RegisterForClicks("LeftButtonUp", "RightButtonUp")
    target:SetScript("OnClick", function() underlyingClicks = underlyingClicks + 1 end)
end
-- Models native hit arbitration inside a book: the top mouse-enabled layer
-- owns the whole press/release. A disappearing overlay must not replay it.
local function Click(target, mouseButton)
    local shield = CompanionJournalLoreDismiss
    local ancestor, inOwner = target, false
    while ancestor do
        if shield and ancestor == shield:GetParent() then inOwner = true end
        ancestor = ancestor:GetParent()
    end
    if shield and shield:IsShown() and inOwner and target:GetFrameLevel() < shield:GetFrameLevel() then target = shield end
    if target.scripts.OnClick and target.clicks and target.clicks[mouseButton .. "Up"] then target.scripts.OnClick(target, mouseButton)
    elseif target.scripts.OnMouseUp then target.scripts.OnMouseUp(target, mouseButton) end
end
local chunks = A.LoreNotePages("one two three four five six seven", function(text) return #text end, 11)
Check(table.concat(chunks, " ") == "one two three four five six seven", "pagination preserves words")
for _, chunk in ipairs(chunks) do Check(#chunk <= 11, "measured leaf capacity") end
local paragraphs = "First paragraph.\n\nSecond paragraph.\nA new line."
Check(A.LoreNotePages(paragraphs, function(text) return #text end, 100)[1] == paragraphs, "pagination preserves authored paragraph and line breaks")
Check(A.LoreNotePages("First.\r\n\r\nSecond.", function(text) return #text end, 100)[1] == "First.\n\nSecond.", "Windows paragraph breaks normalize without flattening")
local paragraphBoundary = A.LoreNotePages("First paragraph.\n\nSecond.", function(text) return #text end, 16)
Check(#paragraphBoundary == 2 and paragraphBoundary[1] == "First paragraph." and paragraphBoundary[2] == "Second.", "page boundary replaces paragraph gap without empty leading rows")
local unicode = string.rep("é", 24)
local unicodeChunks = A.LoreNotePages(unicode, function(text) return #text end, 8)
Check(table.concat(unicodeChunks) == unicode, "oversized token preserves UTF-8")
Check(not A.OpenLoreNote("npc:unknown", row), "unknown note does not open")
Check(A.OpenLoreNote("place:deathknell", row, {owner = book}), "note opens inside book")
local slip = CompanionJournalLoreNote
Check(slip:GetParent() == book and slip:GetWidth() < book:GetWidth() and slip:GetHeight() < book:GetHeight(), "note fits inside owner")
Check(A.LoreNoteIsOpen() and slip.heading.text == "Deathknell", "visible note heading")
Check(slip.backing.fillsParent and slip.backing.color[4] == 1, "entire note has opaque backing")
Check(slip.paper.atlas == "QuestBG-Parchment" and not slip.backdrop.bgFile, "scalable parchment replaces partially transparent legacy sheet")
Check(slip.point[5] == -94 and slip:GetHeight() + 94 + 60 <= book:GetHeight(), "note clears book header and footer")
Check(slip.body.fontSize == 14 and slip.body:GetWidth() <= slip:GetWidth() - 36, "independent readable font and bounded body")
local shield = CompanionJournalLoreDismiss
Check(shield:IsShown() and shield:GetParent() == book and shield.allPointsTarget == book, "dismiss layer covers only the owning book")
Check(shield:GetFrameLevel() > pageControl:GetFrameLevel() and shield:GetFrameLevel() < slip:GetFrameLevel(), "dismiss layer is above even elevated book controls but below note")
Check(shield.clicks.LeftButtonUp and shield.clicks.RightButtonUp and not shield.scripts.OnMouseDown, "dismiss consumes completed clicks before hiding")
Click(slip, "LeftButton")
Check(A.LoreNoteIsOpen(), "left click on note body keeps note open")
for _, child in ipairs({slip:GetChildren()}) do
    Check(child.clicks and child.clicks.RightButtonUp, "every note button accepts right-click dismissal")
end
local unrelated = Object(UIParent)
unrelated:RegisterForClicks("LeftButtonUp")
local unrelatedClicks = 0
unrelated:SetScript("OnClick", function() unrelatedClicks = unrelatedClicks + 1 end)
Click(unrelated, "LeftButton")
Check(A.LoreNoteIsOpen() and unrelatedClicks == 1, "click outside owner is not captured globally")
for _, target in ipairs({book, row, pageControl, linkedChild}) do
    for _, mouseButton in ipairs({"LeftButton", "RightButton"}) do
        A.OpenLoreNote("place:deathknell", row, {owner = book})
        Click(target, mouseButton)
        Check(not A.LoreNoteIsOpen() and not shield:IsShown() and underlyingClicks == 0, "book click dismisses without activating control: " .. mouseButton)
    end
end
Click(pageControl, "LeftButton")
Check(underlyingClicks == 1, "book controls work again on the next click")
A.OpenLoreNote("place:deathknell", row, {owner = book})
Click(slip, "RightButton")
Check(not A.LoreNoteIsOpen() and book:IsShown(), "right click on note body closes only note")
A.OpenLoreNote("place:deathknell", row, {owner = book})
local relatedID = slip.related[1].noteID
Click(slip.related[1], "RightButton")
Check(not A.LoreNoteIsOpen() and slip.heading.text == "Deathknell" and slip.related[1].noteID == relatedID, "right clicking related link closes without following it")
A.OpenLoreNote("place:deathknell", row, {owner = book})
slip.related[1].scripts.OnClick(slip.related[1])
Check(slip.heading.text == "Undertaker Mordo" and slip.back:IsShown(), "safe related note")
Click(slip.back, "RightButton")
Check(not A.LoreNoteIsOpen() and slip.heading.text == "Undertaker Mordo", "right clicking Back closes without navigating")
A.OpenLoreNote("place:deathknell", row, {owner = book})
Click(slip.related[1], "LeftButton")
slip.back.scripts.OnClick(slip.back)
Check(slip.heading.text == "Deathknell" and not slip.back:IsShown(), "back restores prior note")
slip.scripts.OnKeyDown(slip, "ESCAPE")
Check(not A.LoreNoteIsOpen() and book:IsShown() and slip.propagate == false, "Escape consumes key and leaves book open")
Check(A.OpenLoreNote("npc:sylvanas", reader, {owner = reader}) and slip:GetParent() == reader, "reader ownership")
Check(shield:GetParent() == reader and shield.allPointsTarget == reader, "dismiss layer follows reader ownership")
Check(slip.propagate == true, "keyboard propagation resets on reopen")
Check(A.HandleLoreNoteKey("ESCAPE") and not A.HandleLoreNoteKey("ESCAPE"), "external Escape handler closes only open note")
for _, mouseButton in ipairs({"LeftButton", "RightButton"}) do
    A.OpenLoreNote("npc:sylvanas", reader, {owner = reader})
    Click(reader, mouseButton)
    Check(not A.LoreNoteIsOpen() and reader:IsShown() and underlyingClicks == 1, "reader click closes note without operating reader")
end
A.OpenLoreNote("npc:sylvanas", reader, {owner = reader})
reader:Hide(); reader:Show()
Check(not A.LoreNoteIsOpen() and not slip:IsShown() and not shield:IsShown(), "owner hide clears note and shield permanently")
local longText = string.rep("Every word of this longer reference remains available on another leaf. ", 45):match("^(.-)%s*$")
A.Lore.RegisterStoryPack("note-page-tests", {sources = {"test reference"},
    quests = {['A Longer Reference Note'] = {noteSummary = longText}},
})
local smallBook = Object(UIParent); smallBook:SetSize(320, 370)
local longID = A.LoreNoteResolve("q", "A Longer Reference Note")
Check(A.OpenLoreNote(longID, smallBook, {owner = smallBook}), "long note fits smaller book")
Check(#slip.leaves > 1 and slip.next:IsShown(), "long note has visible next leaf")
Check(table.concat(slip.leaves, " ") == longText, "long note retains every word")
for i, leaf in ipairs(slip.leaves) do
    slip.body:SetText(leaf)
    Check(slip.body:GetStringHeight() <= slip.capacity, "body does not overlap related links on leaf " .. i)
end
slip.next.scripts.OnClick(slip.next)
Check(slip.leaf == 2 and slip.previous:IsShown(), "next turns a complete leaf")
Click(slip.next, "RightButton")
Check(not A.LoreNoteIsOpen() and slip.leaf == 2, "right clicking next dismisses without turning")
A.OpenLoreNote(longID, smallBook, {owner = smallBook})
Click(slip.next, "LeftButton")
Check(A.LoreNoteIsOpen() and slip.leaf == 2, "left clicking note next remains functional")
slip.scripts.OnMouseWheel(slip, 1)
Check(slip.leaf == 1, "wheel turns previous leaf rather than scrolling")
A.CloseLoreNote()
-- A major 300-word reference exercises explicit paragraphs, footer access and
-- returning from a related note in both journal owners at a stable font/size.
local paragraph = string.rep("The old road crossed the valley beside watchtowers where travelers found shelter before reaching town. ", 5):match("^(.-)%s*$")
local majorText = table.concat({paragraph, paragraph, paragraph, paragraph}, "\n\n")
A.RegisterLoreNotes({{id = "place:long-ui-test", title = "A Longer Reference", kind = "Place", body = majorText,
    sources = {"First long-note source", "Second long-note source"},
    related = {"place:deathknell", "place:tirisfal", "npc:sylvanas"}}})
local sourcesButton
for _, child in ipairs({slip:GetChildren()}) do if child.label and child.label.text == "Sources" then sourcesButton = child end end
Check(sourcesButton ~= nil, "sources footer control is present")
for _, parent in ipairs({book, reader, smallBook}) do
    Check(A.OpenLoreNote("place:long-ui-test", parent, {owner = parent}), "major reference opens for owner")
    local width, height, keptBreaks = slip:GetWidth(), slip:GetHeight(), false
    Check(#slip.leaves > 1, "major reference spans complete leaves")
    Check(table.concat(slip.leaves, " "):gsub("%s+", " ") == majorText:gsub("%s+", " "), "major reference retains all words in order")
    for i = 1, #slip.leaves do
        Check(slip.leaf == i and slip.body.text == slip.leaves[i], "page turns display the corresponding body leaf")
        Check(slip.body:GetStringHeight() <= slip.capacity, "paragraph-aware body fits above footer")
        Check(-slip.body.point[3] + slip.body:GetStringHeight() <= height - 94, "body clears related controls")
        Check(slip:GetWidth() == width and slip:GetHeight() == height and slip.body.fontSize == 14, "page turns keep popup size and readable font")
        Check(slip.related[1]:IsShown() and slip.related[2]:IsShown() and slip.related[3]:IsShown() and sourcesButton:IsShown(), "all related links and sources stay reachable on every leaf")
        if slip.body.text:find("\n\n", 1, true) then keptBreaks = true end
        if i < #slip.leaves then Click(slip.next, "LeftButton") end
    end
    Check(keptBreaks, "major reference retains paragraph spacing within leaves")
    Check(not slip.next:IsShown() and slip.previous:IsShown(), "last leaf has only previous page turn")
    sourcesButton.scripts.OnEnter(sourcesButton)
    Check(GameTooltip.shown and GameTooltip.owner == sourcesButton and GameTooltip.lines[2] == "First long-note source" and GameTooltip.lines[3] == "Second long-note source", "sources tooltip remains available after final body leaf")
    sourcesButton.scripts.OnLeave(sourcesButton)
    Check(not GameTooltip.shown, "sources tooltip closes on leave")
    local priorLeaf = slip.leaf
    Click(slip.related[1], "LeftButton")
    Check(slip.heading.text == "Deathknell" and slip.back:IsShown(), "related note opens from final leaf")
    Click(slip.back, "LeftButton")
    Check(slip.heading.text == "A Longer Reference" and slip.leaf == priorLeaf and slip.body.text == slip.leaves[priorLeaf], "Back restores the previous note and reading position")
    while slip.previous:IsShown() do Click(slip.previous, "LeftButton") end
    Check(slip.leaf == 1 and not slip.previous:IsShown() and slip.next:IsShown(), "previous turns return to first complete leaf")
    A.CloseLoreNote()
end
for _, pack in pairs(A.Lore.storyPacks) do
    for qid, data in pairs(pack.questIDs or {}) do
        local id = A.LoreNoteResolve("q", data.title, {qid = qid})
        Check(A.OpenLoreNote(id, smallBook, {owner = smallBook}), "compact note opens " .. qid)
        for _, leaf in ipairs(slip.leaves) do
            slip.body:SetText(leaf)
            Check(slip.body:GetStringHeight() <= slip.capacity, "compact note body fits " .. qid)
        end
    end
end
Check(A.OpenLoreNote("place:deathknell", row), "owner found from anchor ancestry")
for _, entry in ipairs(A.LoreNoteCatalog()) do
    -- (a note the discovery rules hide until a quest reveals it cannot open blind)
    if entry.kind ~= "Quest" and A.GetKnownLoreNote(entry.id) then
        Check(A.OpenLoreNote(entry.id, smallBook, {owner = smallBook}), "world note opens: " .. entry.id)
        for _, leaf in ipairs(slip.leaves) do
            slip.body:SetText(leaf)
            Check(slip.body:GetStringHeight() <= slip.capacity, "world note fits: " .. entry.id)
        end
    end
end
slip.scripts.OnHide(slip)
Check(not slip:IsShown() and not A.LoreNoteIsOpen(), "parent hide cannot resurrect stale note")
Check(A.db.sentinel == "unchanged" and next(A.db, "sentinel") == nil and A.People.dahlia.name == "Dahlia", "rendering does not write saved state")
-- Reproduce the new-reader route through the actual popup, including source
-- hover, related buttons and Back. The viewed companion cannot grant knowledge.
A.Me = function() return "Neige" end
A.db.characters = {Neige = {level = 2, journal = {}}}
Check(A.OpenLoreNote(A.LoreNoteResolve("p", "Stormwind"), book, {owner = book}), "fresh reader opens Stormwind")
local bolvarButton
for _, button in ipairs(slip.related) do if button.noteID == "npc:bolvar" then bolvarButton = button end end
Check(bolvarButton, "Stormwind offers public Bolvar link")
Click(bolvarButton, "LeftButton")
Check(slip.heading.text == "Highlord Bolvar Fordragon" and not table.concat(slip.leaves):find("Onyxia", 1, true), "Stormwind to Bolvar does not spoil disguise")
sourcesButton.scripts.OnEnter(sourcesButton)
Check(not table.concat(GameTooltip.lines):find("Masquerade", 1, true), "public source hover does not leak hidden source caption")
local prestorButton
for _, button in ipairs(slip.related) do
    Check(button.noteID ~= "npc:onyxia", "unrevealed footer association removed")
    if button.noteID == "npc:katrana-prestor" then prestorButton = button end
end
Check(prestorButton, "public court adviser remains explorable")
Click(prestorButton, "LeftButton")
Check(slip.heading.text == "Lady Katrana Prestor" and not table.concat(slip.leaves):find("Onyxia", 1, true), "Prestor has her own public card")
Click(slip.back, "LeftButton")
Check(slip.heading.text == "Highlord Bolvar Fordragon" and not table.concat(slip.leaves):find("Onyxia", 1, true), "Back uses the same projection")
Check(A.OpenLoreNote("npc:bolvar", reader, {owner = reader, person = {journal = {{k = "quest", qid = 6403}}}}), "companion context opens reference")
Check(not table.concat(slip.leaves):find("Onyxia", 1, true), "viewed companion journal cannot grant reader knowledge")
A.db.characters.Neige.journal[1] = {k = "quest", qid = 6403}
A.RefreshOpenLoreNote()
Check(table.concat(slip.leaves):find("mortally", 1, true), "an open note refreshes after new discovery")
A.db.characters.Neige.journal[1].qid = 6402
A.RefreshOpenLoreNote()
Check(not table.concat(slip.leaves):find("Onyxia", 1, true), "corrected history reprojects open note")
A.CloseLoreNote()
for _, style in ipairs({"slip", "letter", "tucked"}) do
    A.BookVariant = function() return style end
    Check(A.OpenLoreNote("npc:bolvar", book, {owner = book}), "reference opens in style " .. style)
    Check(not table.concat(slip.leaves):find("Onyxia", 1, true), "style cannot bypass knowledge: " .. style)
    sourcesButton.scripts.OnEnter(sourcesButton)
    Check(not table.concat(GameTooltip.lines):find("Masquerade", 1, true), "style source hover respects knowledge: " .. style)
    for _, button in ipairs(slip.related) do Check(button.noteID ~= "npc:onyxia", "style related links respect knowledge: " .. style) end
    A.CloseLoreNote()
end
print(string.format("LoreNotes: %d assertions; %d curated, %d regional, %d title contexts, %d exact quest stages across %d packs", count,
    before.curated, before.regional, before.questTitle, before.questID, before.packs))
