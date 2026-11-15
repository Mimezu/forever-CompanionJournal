-- The Road's map (RoadMap.lua) driven through a mock UI: a day opens on its zones with the
-- road, the moments and the walk shared with a companion; views switch; the replay walks,
-- follows the road into the next zone and plays the moments' sounds; the slider and the
-- hover answer; the Atlas gathers every day. Geometry and art come from a small mock world.
local root = "Interface/AddOns/CompanionJournal/"
local checks = 0
local function check(ok, label) checks = checks + 1; assert(ok, label) end

-- A generic frame: remembers sizes, points, shown state and scripts; any other call is a no-op.
local Frame = {}
local function New(kind)
    local f = setmetatable({kind = kind, shown = true, w = 0, h = 0, scripts = {}, points = {}}, Frame)
    return f
end
Frame.__index = function(self, key)
    local method = rawget(Frame, key)
    if method then return method end
    -- (only method names, capitalised, answer; any other field is simply absent)
    if type(key) == "string" and key:match("^%u") then return function() end end
    return nil
end
function Frame:SetSize(w, h) self.w, self.h = w, h end
function Frame:SetWidth(w) self.w = w end
function Frame:SetHeight(h) self.h = h end
function Frame:GetWidth() return self.w end
function Frame:GetHeight() return self.h end
function Frame:Show() self.shown = true end
function Frame:Hide() self.shown = false; if self.scripts.OnHide then self.scripts.OnHide(self) end end
function Frame:SetShown(v) self.shown = v and true or false end
function Frame:IsShown() return self.shown end
function Frame:SetScript(k, fn) self.scripts[k] = fn end
function Frame:GetScript(k) return self.scripts[k] end
function Frame:SetText(t) self.text = t end
function Frame:SetFrameStrata(v) self.strata = v end
function Frame:GetText() return self.text end
function Frame:GetStringWidth() return #(self.text or "") * 6 end
function Frame:SetPoint(...) self.points[#self.points + 1] = {...} end
function Frame:ClearAllPoints() self.points = {} end
function Frame:SetStartPoint(_, _, x, y) self.x1, self.y1 = x, y end
function Frame:SetEndPoint(_, _, x, y) self.x2, self.y2 = x, y end
function Frame:SetScale(s) self.scale = s end
function Frame:GetEffectiveScale() return 1 end
function Frame:GetLeft() return 0 end
function Frame:GetTop() return 700 end
function Frame:GetFrameLevel() return 1 end
function Frame:IsEnabled() return true end
function Frame:SetTexture(t) self.texture = t end
for _, make in ipairs({"CreateTexture", "CreateFontString", "CreateLine", "CreateMaskTexture"}) do
    Frame[make] = function(self) local child = New(make); child.parent = self; return child end
end
function CreateFrame(kind, name, parent) local f = New(kind); f.parent = parent; if name then _G[name] = f end; return f end
UIParent = New("Frame")
UISpecialFrames = {}
GameTooltip = New("Tooltip"); GameTooltip.lines = {}
function GameTooltip:SetText(t) self.lines = {t} end
function GameTooltip:AddLine(t) self.lines[#self.lines + 1] = t end
local played = {}
SOUNDKIT = {IG_ABILITY_PAGE_TURN = 1, IG_QUEST_FAILED = 2, IG_QUEST_LIST_COMPLETE = 3, IG_CHARACTER_INFO_OPEN = 4, U_CHAT_SCROLL_BUTTON = 5, IG_QUEST_LOG_OPEN = 6}
function PlaySound(id) played[#played + 1] = id end
local cursor = {0, 0}
function GetCursorPosition() return cursor[1], cursor[2] end
local buttonDown = false
function IsMouseButtonDown() return buttonDown end
RAID_CLASS_COLORS = {MAGE = {r = 0.4, g = 0.8, b = 1}}

-- The world: Mulgore (1412) and Durotar (1411) side by side on Kalimdor (1414), Kalimdor in
-- the world (947). Map units: a zone is 4000 yards; Kalimdor 8000 x 4000.
local MAPS = {
    [1412] = {mapID = 1412, mapType = 3, parentMapID = 1414, name = "Mulgore", ox = 0},
    [1411] = {mapID = 1411, mapType = 3, parentMapID = 1414, name = "Durotar", ox = 4000},
    [1414] = {mapID = 1414, mapType = 2, parentMapID = 947, name = "Kalimdor", ox = 0, size = 8000},
    [947] = {mapID = 947, mapType = 1, name = "Azeroth", ox = 0, size = 16000},
}
local function Size(map) return MAPS[map].size or 4000 end
function CreateVector2D(x, y) return {x = x, y = y} end
local player = {map = 1412, x = 0.1, y = 0.5}
C_Map = {
    GetBestMapForUnit = function() return player.map end,
    GetPlayerMapPosition = function() return {x = player.x, y = player.y} end,
    GetMapInfo = function(map) return MAPS[map] end,
    GetMapChildrenInfo = function() return {MAPS[1412], MAPS[1411], MAPS[1414]} end,
    GetMapInfoAtPosition = function(map, x) if map == 1414 then return x < 0.5 and MAPS[1412] or MAPS[1411] end; if map == 947 then return MAPS[1414] end end,
    GetMapWorldSize = function(map) return Size(map), Size(map) end,
    GetWorldPosFromMapPos = function(map, v) return 1, {x = MAPS[map].ox + v.x * Size(map), y = v.y * Size(map)} end,
    GetMapPosFromWorldPos = function(_, w, map) return map, {x = (w.x - MAPS[map].ox) / Size(map), y = w.y / Size(map)} end,
    GetMapArtLayers = function() return {{layerWidth = 1002, layerHeight = 668, tileWidth = 256, tileHeight = 256}} end,
    GetMapArtLayerTextures = function() local t = {}; for i = 1, 12 do t[i] = 100 + i end; return t end,
}
C_MapExplorationInfo = {GetExploredMapTextures = function() return {{textureWidth = 300, textureHeight = 200, offsetX = 10, offsetY = 20, fileDataIDs = {1, 2}, numTexturesWide = 2, numTexturesTall = 1}} end}
function UnitPosition() return player.y * Size(player.map), MAPS[player.map].ox + player.x * Size(player.map) end
function UnitOnTaxi() return false end
function IsInInstance() return false end
function UnitAffectingCombat() return false end
function UnitIsGhost() return false end
local clock = os.time({year = 2026, month = 11, day = 21, hour = 20, min = 0})
function time(t) if t then return os.time(t) end; return clock end
date = os.date

local A = {defaults = {}, db = {roadRecord = true}, People = {["dahlia-noir"] = {name = "Dahlia-Noir", class = "MAGE"}}}
A.Me = function() return "me" end
A.SelfJournalOn = function() return true end
A.JournalEvening = function(t) local h = tonumber(os.date("%H", t)); if h < 5 then return t - 5 * 3600 end; return t end
local journal = {}
A.SelfPerson = function() return {self = true, charKey = "me", class = "PALADIN", journal = journal} end
local book = New("Frame"); book.w, book.h = 1140, 740
A.BookFrame = function() return book end
A.StyleBookControl = function(button, chosen) button.chosen = chosen end
A.BookCrest = function(parent) local c = New("Frame"); c.icon = New("Texture"); c.parent = parent; return c end
A.SetPersonClassIcon = function(tex, class) tex.class = class end
for _, file in ipairs({"Road.lua", "RoadModel.lua", "RoadMap.lua"}) do assert(loadfile(root .. file))("CompanionJournal", A) end
local Map, Road = A.RoadMap, A.Road

-- An evening: Mulgore with Dahlia, a long stop, a death, then Durotar.
local function Look(s) clock = clock + (s or 2); Road.Look(clock) end
Look(0)
local t0 = clock
for _ = 1, 40 do player.x = player.x + 0.004; Look(2) end
for _ = 1, 150 do Look(2) end
local deathAt = clock
for _ = 1, 40 do player.x = player.x + 0.004; player.y = player.y + 0.002; Look(2) end
player.map, player.x = 1411, 0.05
for _ = 1, 60 do player.x = player.x + 0.004; Look(2) end
journal[#journal + 1] = {k = "with", d = "dahlia-noir", n = "Dahlia-Noir", t = t0, e = deathAt}
journal[#journal + 1] = {k = "death", d = "a duskbat", t = deathAt, z = "Mulgore"}
journal[#journal + 1] = {k = "mylevel", d = 12, t = clock - 30, z = "Durotar"}
journal[#journal + 1] = {k = "campfire", t = t0 + 200, z = "Mulgore"}
journal[#journal + 1] = {k = "play", t = t0, e = clock, z = "Mulgore"}
local day = Road.DayOf(clock)

-- 1. The day opens on its first zone, in the Story view, with tabs in order.
Map.OpenDay(nil, day)
local sheet = _G.CompanionJournalRoad
check(sheet and sheet:IsShown(), "the day's map opens")
check(sheet.strata == "FULLSCREEN", "the map lies above the book (its own layer)")
local labels = {}
for _, tab in ipairs(sheet.tabs) do if tab:IsShown() then labels[#labels + 1] = tab.label.text end end
check(table.concat(labels, "|") == "Mulgore|Durotar|Kalimdor|World", "tabs: the zones in order, their continent, the world: " .. table.concat(labels, "|"))
local function Shown(pool) local n = 0; for _, item in ipairs(rawget(sheet.ink, "cjPools")[pool] or {}) do if item:IsShown() then n = n + 1 end end; return n end
check(Shown("lines") > 10 and Shown("blobs") >= 2, "the road is inked, the long stop is a wash")
check(sheet.art.tiles and #sheet.art.tiles >= 14, "the zone's art and its explored parts are drawn")
-- (the death: two red strokes; Dahlia: a second line beside the shared stretch)
local story = Shown("lines")

-- 2. Hero path draws the true line: more strokes than the story.
sheet.hero.scripts.OnClick(sheet.hero)
check(Shown("lines") > story, "the hero path keeps every step")
sheet.story.scripts.OnClick(sheet.story)

-- 3. The continent shows both zones' roads.
for _, tab in ipairs(sheet.tabs) do if tab.label.text == "Kalimdor" then tab.scripts.OnClick(tab) end end
check(Shown("lines") > story, "the continent shows the whole evening")
for _, tab in ipairs(sheet.tabs) do if tab.label.text == "Mulgore" then tab.scripts.OnClick(tab) end end

-- 4. The replay: the walker walks, the moments sound as they are passed, the map follows
-- the road into Durotar.
Map.Play()
local update = sheet.scripts.OnUpdate
check(update ~= nil, "the replay runs")
local switched = false
for _ = 1, 400 do
    if sheet.scripts.OnUpdate then sheet.scripts.OnUpdate(sheet, 0.25) end
    for _, tab in ipairs(sheet.tabs) do if tab.chosen and tab.label.text == "Durotar" then switched = true end end
end
check(switched, "the replay follows the road into the next zone")
local heard = {}
for _, id in ipairs(played) do heard[id] = true end
check(heard[2] and heard[3] and heard[1], "the death, the level and the page turn are heard")
check(sheet.scripts.OnUpdate == nil and sheet.play.label.text == "Play", "the replay ends by itself")

-- 5. The slider: halfway shows only the first half.
sheet.track.w = 400
cursor[1] = 200
sheet.track.scripts.OnMouseDown(sheet.track)
local half = Shown("lines")
cursor[1] = 400
sheet.track.scripts.OnMouseDown(sheet.track)
check(half < Shown("lines"), "the slider shows the road up to its time")
sheet.track.scripts.OnMouseUp(sheet.track)

-- 6. Hover: the nearest moment answers with its time and words.
Map.SetTime(math.huge)
local mark
for _, item in ipairs({}) do end
local scale = 1
for _, tab in ipairs(sheet.tabs) do if tab.label.text == "Mulgore" then tab.scripts.OnClick(tab) end end
local deathItem
local Upvalue = function(fn, name) for i = 1, 80 do local k, v = debug.getupvalue(fn, i); if k == name then return v end; if not k then break end end end
local st = Upvalue(Map.Hover, "state")
for _, item in ipairs(st.drawnMarks) do if item.mark.kind == "death" then deathItem = item end end
check(deathItem ~= nil, "the death is marked on the map")
cursor[1], cursor[2] = deathItem.x, 700 - deathItem.y
Map.Hover()
check(GameTooltip.lines[1] and GameTooltip.lines[1]:find("Fell to a duskbat", 1, true), "hovering the X: when and what")

-- 7. The Atlas: every day, the facts in a line.
Map.OpenAtlas(nil)
check(sheet:IsShown() and sheet.title.text == "The Road", "the Atlas opens")
check(sheet.facts.text:find("1 days", 1, true) or sheet.facts.text:find("days", 1, true), "the Atlas counts the days")
check(Shown("lines") > 5, "the Atlas inks every road")

-- 9. The wheel: zooms the map around the cursor, never past its edges; deep into a
-- continent opens the zone under the cursor; out of a zone goes back to its continent.
Map.OpenDay(nil, day)
local st9 = Upvalue(Map.Hover, "state")
local base = st9.scale
cursor[1], cursor[2] = 100, 500
sheet.area.scripts.OnMouseWheel(sheet.area, 1)
check(math.abs(st9.scale - base * 1.25) < 1e-6 and st9.zoom == 1.25, "the wheel zooms in")
for _ = 1, 30 do sheet.area.scripts.OnMouseWheel(sheet.area, -1) end
check(st9.view == 947 or st9.view == 1414, "zooming out of a zone goes up to its continent, then the world")
Map.SetView(1414)
for _ = 1, 8 do sheet.area.scripts.OnMouseWheel(sheet.area, 1) end
check(MAPS[st9.view] and MAPS[st9.view].mapType == 3, "zooming deep into the continent opens a zone")
check(sheet.scripts.OnMouseWheel ~= nil, "the sheet keeps the wheel from the book's pages")
-- 10. The day arrows: to the day before, and back.
journal[#journal + 1] = {k = "play", t = t0 - 86400, e = t0 - 86400 + 3600, z = "Durotar"}
Map.OpenDay(nil, day)
check(sheet.prevDay:IsShown() and Map.Neighbour(-1) ~= nil and Map.Neighbour(1) == nil, "an earlier day, no later one")
sheet.prevDay.scripts.OnClick(sheet.prevDay)
check(st9.day ~= day, "the arrow opens the day before")
sheet.nextDay.scripts.OnClick(sheet.nextDay)
check(st9.day == day, "and back")
-- 11. The Atlas plays the adventure as a tour of each day's replay, then comes back.
Map.OpenAtlas(nil)
check(not sheet.prevDay:IsShown(), "the Atlas has no day arrows")
Map.Play()
check(st9.tour and not st9.atlas, "the tour opens the first day")
local seen = {}
for _ = 1, 4000 do
    if st9.tour then seen[st9.day] = true end
    if sheet.scripts.OnUpdate then sheet.scripts.OnUpdate(sheet, 0.25) elseif st9.tour then Map.TourDay() end
    if st9.atlas then break end
end
local count = 0; for _ in pairs(seen) do count = count + 1 end
check(count == 2 and st9.atlas and not st9.tour, "every day replayed, then back to the Atlas")

-- 12. Play, pause and the slider, the way a hand uses them.
Map.OpenDay(nil, day)
local st = Upvalue(Map.Hover, "state")
local function Frame(dt) if sheet.scripts.OnUpdate then sheet.scripts.OnUpdate(sheet, dt or 0.25) end end
local function TrackFrame() if sheet.track.scripts.OnUpdate then sheet.track.scripts.OnUpdate(sheet.track) end end
sheet.play.scripts.OnClick(sheet.play)
check(st.playing and sheet.scripts.OnUpdate and sheet.play.label.text == "Pause", "Play plays")
for _ = 1, 20 do Frame() end
local share = st.share
check(share > 0 and share < 1, "the playhead moves")
sheet.play.scripts.OnClick(sheet.play)
check(not st.playing and sheet.scripts.OnUpdate == nil and sheet.play.label.text == "Play", "Pause pauses")
Frame(); Frame()
check(st.share == share, "paused, the playhead stays")
sheet.play.scripts.OnClick(sheet.play)
check(st.playing and st.share == share, "Play again goes on from there, not from the start")
-- the knob is where the playhead is
sheet.track.w = 400
Frame()
local knobX = sheet.knob.points[1][4]
check(math.abs(knobX - st.share * 400) < 0.01, "the slider shows the playhead")
-- grabbing the slider while playing: paused while held, playing again on release
cursor[1] = 100; buttonDown = true
sheet.track.scripts.OnMouseDown(sheet.track, "LeftButton")
check(not st.playing and math.abs(st.share - 0.25) < 1e-6, "held: the playhead follows the slider, paused")
cursor[1] = 300; TrackFrame()
check(math.abs(st.share - 0.75) < 1e-6, "dragging moves it")
-- released away from the slider: no mouse-up reaches it, the button is simply up
buttonDown = false; cursor[1] = 50; TrackFrame()
check(sheet.track.scripts.OnUpdate == nil and math.abs(st.share - 0.75) < 1e-6, "let go anywhere: the playhead stays where it was left")
check(st.playing, "and it plays on, as before it was grabbed")
TrackFrame(); cursor[1] = 10
check(math.abs(st.share - 0.75) < 0.02, "it no longer follows the mouse")
Map.Stop()
-- a day with zones only still takes its time
local quietDay = Road.DayOf(t0 - 86400)
Map.OpenDay(nil, quietDay)
sheet.play.scripts.OnClick(sheet.play)
local frames = 0
while st.playing and frames < 1000 do Frame(0.25); frames = frames + 1 end
check(frames >= 200, "a day of zones only plays for its minute, not an instant: " .. frames .. " frames")

-- 8. A chapter's map mark opens its day.
local page = New("Frame"); page.box = {70, 70, 76, 56}
Map.Mark(page, {self = true}, {day = {key = day}, part = 1})
check(page.roadMark and page.roadMark:IsShown(), "a chapter's first page has the map mark")
Map.Mark(page, {self = true}, {day = {key = day}, part = 2})
check(not page.roadMark:IsShown(), "later pages of the chapter do not")
print("RoadMap: " .. checks .. " checks passed")
