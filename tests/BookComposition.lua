-- Actual Build, LayoutPages and RefreshBook composition with deterministic
-- region geometry. Story drawing and editor contents have their own suites.
local root, checks = "Interface/AddOns/CompanionJournal/", 0
local function check(ok, why) checks = checks + 1; assert(ok, why) end
local M = {}; M.__index = function(_, key)
    if M[key] then return M[key] end
    if key:match("^[A-Z]") and key ~= "ScrollBar" and key ~= "ThumbTexture" then return function() end end
end
local function object(parent, kind)
    return setmetatable({parent = parent, kind = kind or "Frame", shown = true, points = {}, scripts = {}, regions = {}}, M)
end
function M:GetParent() return self.parent end
function M:SetParent(v) self.parent = v end
function M:SetSize(w, h) self.width, self.height = w, h end
function M:SetWidth(w) self.width = w end
function M:SetHeight(h) self.height = h end
function M:SetPoint(...) self.points[#self.points + 1] = {...} end
function M:ClearAllPoints() self.points, self.all = {}, nil end
function M:SetAllPoints(target) self.all = target or self.parent end
local function factor(point)
    return point:find("LEFT") and 0 or point:find("RIGHT") and 1 or .5,
        point:find("BOTTOM") and 0 or point:find("TOP") and 1 or .5
end
function M:Rect()
    if self.origin then return 0, 0, self.width, self.height end
    if self.all then return self.all:Rect() end
    local anchors = {}
    for _, point in ipairs(self.points) do
        local relative, relativePoint, x, y
        if type(point[2]) == "table" then relative, relativePoint, x, y = point[2], point[3] or point[1], point[4] or 0, point[5] or 0
        else relative, relativePoint, x, y = self.parent, point[1], point[2] or 0, point[3] or 0 end
        local l, b, w, h = 0, 0, 0, 0
        if relative then l, b, w, h = relative:Rect() end
        local rx, ry = factor(relativePoint)
        local sx, sy = factor(point[1])
        anchors[#anchors + 1] = {sx, sy, l + rx * w + x, b + ry * h + y}
    end
    local w, h = self.width, self.height
    if not w and #anchors > 1 and anchors[2][1] ~= anchors[1][1] then w = (anchors[2][3] - anchors[1][3]) / (anchors[2][1] - anchors[1][1]) end
    if not h and #anchors > 1 and anchors[2][2] ~= anchors[1][2] then h = (anchors[2][4] - anchors[1][4]) / (anchors[2][2] - anchors[1][2]) end
    w, h = w or (self.kind == "FontString" and #(self.text or "") * 6 or 0), h or (self.kind == "FontString" and 16 or 0)
    local anchor = anchors[1] or {0, 0, 0, 0}
    return anchor[3] - anchor[1] * w, anchor[4] - anchor[2] * h, w, h
end
function M:GetWidth() local _, _, w = self:Rect(); return w end
function M:GetHeight() local _, _, _, h = self:Rect(); return h end
function M:GetFrameLevel() return self.level or (self.parent and self.parent:GetFrameLevel() + (self.kind == "Frame" and 1 or 0)) or 1 end
function M:SetFrameLevel(v) self.level = v end
function M:SetText(v) self.text = v end
function M:SetJustifyH(v) self.justify = v end
function M:GetText() return self.text or "" end
function M:GetStringWidth() return #self:GetText() * 6 end
function M:GetStringHeight() return 16 end
function M:SetAtlas(v) self.atlas = v end
function M:SetColorTexture(...) self.color = {...} end
function M:SetTextColor(...) self.textColor = {...} end
function M:SetScript(k, v) self.scripts[k] = v end
function M:Show() self.shown = true end
function M:Hide() self.shown = false end
function M:SetShown(v) self.shown = v and true or false end
function M:IsShown() return self.shown end
function M:SetEnabled(v) self.enabled = v end
function M:IsEnabled() return self.enabled ~= false end
function M:CreateTexture(_, layer, _, sub)
    local t = object(self, "Texture"); t.layer, t.sub = layer, sub or 0; self.regions[#self.regions + 1] = t; return t
end
function M:CreateFontString()
    local f = object(self, "FontString"); self.regions[#self.regions + 1] = f; return f
end
function M:GetRegions() return unpack(self.regions) end
function M:GetDrawLayer() return self.layer, self.sub end
function CreateFrame(_, name, parent) local f = object(parent); if name then _G[name] = f end; return f end
UIParent = object(); UIParent.origin = true; UIParent:SetSize(1920, 1080)
UISpecialFrames = {}
C_Texture = {GetAtlasInfo = function() return {file = "mock-atlas", width = 800, height = 800, leftTexCoord = 0, rightTexCoord = 1, topTexCoord = 0, bottomTexCoord = 1} end}
local person = {name = "A companion with a very long custom display name", class = "SHAMAN", circle = "companion", faction = "Horde"}
local A = {defaults = {}, People = {buddy = person}, db = {bookSize = "a", bookSpread = "one", bookVariants = {skin = "b", marks = "c"}}}
A.PersonCircle = function(p) return p.circle end
A.PersonSummary = function() return "Companion · A long shared history across the world" end
A.SetPersonClassIcon = function(icon) icon:Show() end
A.JournalVoice = function() return "story" end
assert(loadfile(root .. "BookManagement.lua"))("CompanionJournal", A)
A.CreateBookManager = function() return {Refresh = function() end, Hide = function() end} end
assert(loadfile(root .. "JournalBookUI.lua"))("CompanionJournal", A)
local function upvalue(fn, name, replacement)
    for i = 1, 100 do
        local key, value = debug.getupvalue(fn, i)
        if not key then break end
        if key == name then if replacement ~= nil then debug.setupvalue(fn, i, replacement) end; return value end
    end
    error("Missing production function: " .. name)
end
local Build = upvalue(upvalue(A.OpenBook, "open"), "Build")
for _, name in ipairs({"BuildCard", "BuildNotes", "BuildWizard"}) do upvalue(Build, name, function() return object() end) end
upvalue(Build, "BuildAddBar", function() local f = object(); f.Update = function() end; return f end)
Build()
local book, state = upvalue(A.RefreshBook, "book"), upvalue(A.RefreshBook, "state")
book.origin = true; book:Show()
local LayoutPages = upvalue(A.RefreshBook, "LayoutPages")
for _, name in ipairs({"FillBookmarks", "ContentsPortrait", "FillSettings", "FillNPCs", "PlaceCard", "FillContents",
    "ClearPage", "ShowingRead", "FillTimeline", "DrawChapter", "Ribbon", "ShowRibbon", "UpdateWriteDate"}) do
    upvalue(A.RefreshBook, name, function() end)
end
upvalue(A.RefreshBook, "Chapters", function() return {}, "b", "story", function() end end)
upvalue(A.RefreshBook, "PageChapters", function() return {} end)
upvalue(A.RefreshBook, "PortraitFor", function() return nil end)
upvalue(A.RefreshBook, "PreparePage", function() return nil end)
upvalue(A.RefreshBook, "UnreadDays", function() return {} end)
local function bounds(region)
    local l, b, w, h = region:Rect(); return {left = l, right = l + w, bottom = b, top = b + h}
end
local function inside(region, paper, why, visibleText)
    local r, p = bounds(region), bounds(paper)
    if visibleText then
        local width = math.min(r.right - r.left, region:GetStringWidth())
        if region.justify == "RIGHT" then r.left = r.right - width
        elseif region.justify == "CENTER" then local center = (r.left + r.right) / 2; r.left, r.right = center - width / 2, center + width / 2
        else r.right = r.left + width end
    end
    check(r.left >= p.left and r.right <= p.right and r.bottom >= p.bottom and r.top <= p.top, why)
end
check(book.paperLeft.parent == book and book.paperLeft.layer == "BACKGROUND" and book.paperLeft.sub == 1, "full parchment is behind child content and above the book ground")
check(book.paperRight.parent == book and book.paperRight.layer == "BACKGROUND" and book.paperRight.sub == 1, "both full leaves share the book background layer")
for _, size in ipairs({{"minimum", 760, 520}, {"a", 860, 580}, {"b", 1000, 660}, {"c", 1140, 740}}) do
    book:SetSize(size[2], size[3])
    for _, view in ipairs({"journal", "settings", "people", "npcs"}) do
        for _, marks in ipairs({"a", "b", "c"}) do
            for _, spread in ipairs({"one", "two"}) do
                state.view, state.key = view, "buddy"
                A.db.bookVariants.marks, A.db.bookSpread = marks, spread
                LayoutPages(); A.RefreshBook()
                local left, right = bounds(book.paperLeft), bounds(book.paperRight)
                check(left.left == 13 and right.right == size[2] - 7 and left.right == right.left, "paper fills both leaves to the binding at " .. size[1] .. "/" .. view)
                check(left.top == size[3] - 40 and left.bottom == 18 and right.top == left.top and right.bottom == left.bottom, "full parchment retains outer chrome margins in every view")
                for _, page in ipairs({book.contents, book.leftPage, book.rightPage, book.panel, book.cardHost}) do
                    check(not page.paper:IsShown(), "viewport paper stays hidden after real refresh")
                end
                local managing = view == "people" or view == "npcs"
                check(bounds(book.left).top == size[3] - (managing and 40 or view == "journal" and 76 or 88), "manager viewport fills paper while journal/settings keep header reserves")
                check(book.footer:IsShown() == (view == "journal") and book.input:IsShown() == (view == "journal"), "footer and writing controls appear only in journal view")
                check(book.leftRule:IsShown() == (view == "journal") and book.rightRule:IsShown() == (view == "journal"), "quiet footer rules belong to journal view")
                if view == "journal" then
                    inside(book.name, book.paperLeft, "long journal heading stays on left paper")
                    inside(book.summary, book.paperLeft, "header summary stays on left paper")
                    inside(book.classIcon, book.paperLeft, "class icon stays on paper")
                    inside(book.pin, book.paperLeft, "pin beside long name stays on paper")
                    for _, control in ipairs({book.input, book.noteDate, book.write, book.retell}) do
                        inside(control, book.paperLeft, "writing action fits its leaf")
                        check(bounds(control).top < bounds(book.leftRule).bottom, "writing row clears the footer rule")
                    end
                    for _, control in ipairs({book.prev, book.next, book.chapterLabel}) do
                        inside(control, book.paperRight, "page navigation stays on right paper")
                        check(bounds(control).top < bounds(book.rightRule).bottom, "page navigation clears the rule")
                    end
                    check(bounds(book.retell).right < right.left, "writing action clears the binding")
                    if marks ~= "c" then
                        inside(book.readView, book.paperRight, "Reading view button fits its leaf")
                        check(bounds(book.next).right < bounds(book.readView).left, "Reading view button clears page navigation")
                    end
                    check(bounds(book.tabs.journal).bottom > bounds(book.right).top, "chapter tabs stay above the prose viewport")
                    check(bounds(book.summary).bottom > bounds(book.contents.scroll).top, "header summary clears contents text")
                    check(bounds(book.timeline).top < bounds(book.right).bottom + book.rightPage.box[4], "timeline clears reserved narrative text")
                    inside(book.corner, book.paperRight, "page curl follows the physical paper corner")
                elseif view == "settings" then
                    inside(book.name, book.paperLeft, "settings title stays on left paper", true)
                    inside(book.sectionHeading, book.paperRight, "settings section heading stays on right paper")
                else
                    check(not book.name:IsShown() and not book.summary:IsShown(), "manager keeps its own header without duplicate journal text")
                end
            end
        end
    end
end
-- Changing views must restore the shared paper artwork after a rival journal.
state.view, state.key = "journal", "buddy"; person.circle, person.faction = "rival", "Horde"; A.RefreshBook()
check(book.paperLeft.atlas == "QuestBG-Horde" and book.paperRight.atlas == "QuestBG-Horde", "rival faction parchment covers complete leaves")
person.faction = nil; A.RefreshBook()
check(book.paperLeft.atlas == "QuestBG-Parchment" and book.paperRight.atlas == "QuestBG-Parchment", "factionless rival retains normal parchment")
state.view = "settings"; A.RefreshBook()
check(book.paperLeft.atlas == "spellbook-background-evergreen-left" and book.paperRight.atlas == "spellbook-background-evergreen-right", "settings restores the normal full parchment")
print("BookComposition: " .. checks .. " checks passed")
