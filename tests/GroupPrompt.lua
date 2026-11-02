-- Run from the client root: lua Interface/AddOns/CompanionJournal/tests/GroupPrompt.lua
-- Group prompt: who left, you leaving, hidden identities, combat, choices, styles.
local root = "Interface/AddOns/CompanionJournal/"
local assertions = 0
local function check(value, message) assertions = assertions + 1; assert(value, message) end

-- Minimal frame mock: every unknown method is a no-op returning the frame.
local frames = {}
local methods = {}
local function Object(parent)
    local object = {parent = parent, scripts = {}, shown = true, points = {}}
    setmetatable(object, {__index = function(_, key)
        if methods[key] then return methods[key] end
        if type(key) == "string" and key:match("^[A-Z]") then return function(self) return self end end
    end})
    frames[#frames + 1] = object
    return object
end
function methods:SetScript(key, fn) self.scripts[key] = fn end
function methods:GetScript(key) return self.scripts[key] end
function methods:Show() self.shown = true end
function methods:Hide() self.shown = false end
function methods:SetShown(v) self.shown = v and true or false end
function methods:IsShown() return self.shown end
function methods:SetText(t) self.text = t end
function methods:GetText() return self.text end
function methods:SetHeight(h) self.height = h end
function methods:SetWidth(w) self.width = w end
function methods:SetSize(w, h) self.width, self.height = w, h end
function methods:GetPoint() return "TOP", nil, "TOP", 0, -150 end
function methods:CreateTexture() return Object(self) end
function methods:CreateFontString() return Object(self) end
function methods:GetParent() return self.parent end
function CreateFrame(_, _, parent) return Object(parent) end
UIParent = Object()
GameTooltip = Object()
GameFontNormalSmall, GameFontHighlightSmall = {}, {}
function CreateColor(r, g, b, a) return {r, g, b, a} end
local combat = false
function InCombatLockdown() return combat end
function time() return 1000 end
function date() return "2026-09-27" end
function GetRealZoneText() return "Elwynn Forest" end
function GetNormalizedRealmName() return "Forever" end
function GetRealmName() return "Forever" end
function GetClassAtlas(class) return "classicon-" .. class end
C_Texture = {GetAtlasInfo = function() return {} end}
RAID_CLASS_COLORS = {MAGE = {r = 0.2, g = 0.8, b = 1}}
C_Timer = {After = function(_, fn) fn() end}
local printed = {}
print = function(text) printed[#printed + 1] = text end

-- Group state.
local members, inGroup, hidden = {}, false, {}
function IsInGroup() return inGroup end
function IsInRaid() return false end
function GetNumGroupMembers() return inGroup and (#members + 1) or 0 end
function UnitIsUnit(unit, other) return false end
function UnitIsPlayer() return true end
local function Member(unit) return members[tonumber(unit:match("%d+"))] end
function UnitFullName(unit)
    local member = Member(unit)
    if not member then return nil end
    if hidden[member[1]] then return nil end
    return member[1], "Forever"
end
function UnitClass(unit) local m = Member(unit); return m and m[2], m and m[2] end
function UnitLevel(unit) local m = Member(unit); return m and m[3] or 0 end

local A = {defaults = {colors = {}}}
for _, file in ipairs({"People.lua", "Characters.lua", "GroupPrompt.lua"}) do
    assert(loadfile(root .. file))("ForeverNames", A)
end
A.GlyphPath = function(name) return name end
A.Refresh = function() end
local db = {enabled = true, peopleAutoGroup = true, peopleGroupPrompt = true, peopleGroupIcon = true,
    groupPromptStyle = "cards", colors = {people = {1, 0.5, 0.8}, groupmate = {0.5, 0.8, 1}}}
for key, value in pairs(A.defaults) do if db[key] == nil then db[key] = value end end
A.db = db
A.InitPeople()

local function Visible()
    for _, frame in ipairs(frames) do
        if rawget(frame, "rows") and frame.shown then return frame end
    end
end
local function Names(frame)
    local names = {}
    for _, row in ipairs(frame.rows) do if row.shown then names[#names + 1] = row.name.text end end
    return names
end

-- 1. Forming a group establishes a baseline: nobody is asked about.
inGroup, members = true, {{"Aeryn", "MAGE", 20}, {"Brom", "WARRIOR", 21}, {"Cael", "PRIEST", 22}}
A.UpdatePeopleHooks()
A.TrackGroupRoster()
check(Visible() == nil, "joining a group asks nothing")

-- 2. One member leaves.
table.remove(members, 2)
A.TrackGroupRoster()
local frame = Visible()
check(frame and #Names(frame) == 1 and Names(frame)[1]:find("Brom"), "the member who left is listed")
check(frame.title.text == "Left your group", "headline for someone leaving")

-- 3. Choices: acquaintance adds with the group icon.
A.ResolveGroupPrompt(1, "acquaintance")
local brom = db.people["brom-forever"]
check(brom and brom.circle == "acquaintance" and brom.glyph == "party" and brom.metZone == "Elwynn Forest", "acquaintance added with group icon")
check(not Visible(), "popup closes when the list is empty")

-- 4. Hidden identities (instances) must not look like people leaving.
hidden.Cael = true
A.TrackGroupRoster()
check(not Visible(), "an unreadable member is not treated as gone")
hidden.Cael = nil

-- 5. Leaving yourself lists everyone; people already known or blocked are skipped.
db.peopleBlocked["cael-forever"] = {name = "Cael-Forever"}
inGroup, members = false, {}
A.TrackGroupRoster()
frame = Visible()
check(frame and #Names(frame) == 1 and Names(frame)[1]:find("Aeryn"), "leaving lists the rest, minus blocked people")
check(frame.title.text == "You left the group", "headline when you leave")
A.ResolveGroupPrompt(1, "companion")
local aeryn = db.people["aeryn-forever"]
check(aeryn and aeryn.circle == nil and aeryn.met == 1000, "companion added with when/where you met")

-- 6. Don't add: nothing stored, nothing blocked.
inGroup, members = true, {{"Dara", "ROGUE", 20}}
A.TrackGroupRoster(true)
inGroup, members = false, {}
A.TrackGroupRoster()
local forgotten = {}
A.JournalForget = function(key) forgotten[#forgotten + 1] = key end
check(A.GroupPromptQueued("dara-forever") and not A.GroupPromptQueued("nobody-forever"), "the prompt says who it is still asking about")
A.ResolveGroupPrompt(1, "pass")
check(db.people["dara-forever"] == nil and db.peopleBlocked["dara-forever"] == nil, "don't add stores nothing")
check(forgotten[1] == "dara-forever" and not A.GroupPromptQueued("dara-forever"), "don't add: the journal forgets what it kept aside")

-- 7. Combat defers the popup until it ends.
combat = true
A.SimulateGroupLeave(2)
check(not Visible(), "no popup during combat")
combat = false
-- The combat watcher is the frame whose OnEvent refreshes the prompt.
for _, f in ipairs(frames) do if f.scripts.OnEvent then f.scripts.OnEvent(f, "PLAYER_REGEN_ENABLED") end end
frame = Visible()
check(frame and #Names(frame) == 2, "shown after combat")

-- 8. Test entries never touch the list; each style renders the same entries.
local before = 0
for _ in pairs(db.people) do before = before + 1 end
for _, style in ipairs({"legacy", "minimal", "cards"}) do
    db.groupPromptStyle = style
    A.RefreshGroupPrompt()
    local shown = Visible()
    check(shown and #Names(shown) == 2, style .. " style shows both test rows")
end
A.ResolveGroupPrompt(1, "companion"); A.ResolveGroupPrompt(1, "acquaintance")
local after = 0
for _ in pairs(db.people) do after = after + 1 end
check(after == before and printed[#printed]:find("(test)", 1, true), "test choices only print")

-- 9. More than six leaving: six rows, the rest counted in the headline.
A.SimulateGroupLeave(9)
frame = Visible()
check(#Names(frame) == 6 and frame.more.shown and frame.more.text:find("3 more", 1, true) and not frame.title.text:find("+", 1, true), "overflow shown under the rows, not in the title")
A.ClearGroupPrompt()
check(not Visible(), "clearing empties the popup")
-- The close button: nobody added; the journal forgets real entries (not tests).
inGroup, members = true, {{"Eryn", "MAGE", 20}}
A.TrackGroupRoster(true)
inGroup, members = false, {}
A.TrackGroupRoster()
A.SimulateGroupLeave(1)
forgotten = {}
frame = Visible()
frame.close.scripts.OnClick(frame.close)
check(not Visible() and #forgotten == 1 and forgotten[1] == "eryn-forever" and db.people["eryn-forever"] == nil,
    "close button: nobody added, kept memories forgotten")

-- 10. Off: automatic adding and prompting both stop.
db.peopleGroupPrompt = false
check(A.GroupPromptActive() == false, "prompt inactive when the option is off")

-- A settings preview is isolated from real pending groupmates and works even
-- with automatic recording disabled. Every choice is safe to experiment with.
A.QueueGroupPrompt({key = "real-pending", name = "Realpending", level = 20}, "left")
local forgottenBefore = #forgotten
local peopleBefore = 0
for _ in pairs(db.people) do peopleBefore = peopleBefore + 1 end
for _, style in ipairs({"cards", "legacy", "minimal"}) do
    db.groupPromptStyle = style
    check(A.ToggleGroupPromptPreview(), "preview opens for " .. style)
    local shown = Visible()
    check(shown and #Names(shown) == 2 and shown.title.text == "Group prompt preview", "sample uses selected style")
    A.ResolveGroupPrompt(1, "companion")
    A.ResolveGroupPrompt(1, "acquaintance")
    check(not A.IsGroupPromptPreview() and A.GroupPromptQueued("real-pending"), "preview choices preserve real queue")
end
A.ToggleGroupPromptPreview()
db.groupPromptStyle = "cards"; A.RefreshGroupPrompt()
check(A.IsGroupPromptPreview() and #Names(Visible()) == 2, "changing style keeps sample")
Visible().close.scripts.OnClick()
check(not A.IsGroupPromptPreview() and A.GroupPromptQueued("real-pending"), "close only dismisses preview")
A.ToggleGroupPromptPreview()
check(not A.ToggleGroupPromptPreview() and A.GroupPromptQueued("real-pending"), "toggle off restores real prompt")
A.ToggleGroupPromptPreview()
A.QueueGroupPrompt({key = "new-pending", name = "Newpending"}, "left")
check(not A.IsGroupPromptPreview() and A.GroupPromptQueued("real-pending") and A.GroupPromptQueued("new-pending"), "new real event takes priority")
local peopleAfter = 0
for _ in pairs(db.people) do peopleAfter = peopleAfter + 1 end
check(peopleAfter == peopleBefore and #forgotten == forgottenBefore, "preview never changes people or journal memories")
A.ClearGroupPrompt()
combat = true
A.ToggleGroupPromptPreview()
check(A.IsGroupPromptPreview() and not Visible(), "preview waits during combat")
combat = false
for _, f in ipairs(frames) do if f.scripts.OnEvent then f.scripts.OnEvent(f, "PLAYER_REGEN_ENABLED") end end
check(Visible() and Visible().title.text == "Group prompt preview", "preview opens after combat")
A.ResolveGroupPrompt(1, "pass"); A.ResolveGroupPrompt(1, "pass")
check(not A.IsGroupPromptPreview() and not Visible(), "sample pass buttons exhaust preview without queue mutation")

print = _G.print
io.write("PASS: " .. assertions .. " group prompt assertions\n")
