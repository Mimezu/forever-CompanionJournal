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
function Frame:SetThickness(v) self.thick = v end
function Frame:SetColorTexture(r, g, b, a) self.color = {r, g, b, a} end
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
function Frame:SetTexCoord(...) self.coords = {...} end
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
C_MapExplorationInfo = {GetExploredMapTextures = function() return {{textureWidth = 300, textureHeight = 200, offsetX = 10, offsetY = 20, fileDataIDs = {1, 2}, numTexturesWide = 1, numTexturesTall = 1}} end}
function UnitPosition() return player.y * Size(player.map), MAPS[player.map].ox + player.x * Size(player.map) end
local onTaxi = false
function UnitOnTaxi() return onTaxi end
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
for _, file in ipairs({"Road.lua", "RoadModel.lua", "RoadMap.lua", "DeathShots.lua"}) do assert(loadfile(root .. file))("CompanionJournal", A) end
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

-- 2. Hero path: the true line, finer; Story: a bolder road (merging is section 13).
local function Thickest() local m = 0; for _, l in ipairs(rawget(sheet.ink, "cjPools").lines) do if l:IsShown() and l.thick and l.color and l.color[1] < 0.3 then m = math.max(m, l.thick) end end; return m end
local storyInk = Thickest()
sheet.hero.scripts.OnClick(sheet.hero)
check(Thickest() < storyInk and Shown("lines") > 10, "the hero path is the finer true line")
sheet.story.scripts.OnClick(sheet.story)

-- 3. The continent shows both zones' roads.
for _, tab in ipairs(sheet.tabs) do if tab.label.text == "Kalimdor" then tab.scripts.OnClick(tab) end end
local stc = (function() for i = 1, 80 do local k, v = debug.getupvalue(Map.Hover, i); if k == "state" then return v end; if not k then break end end end)()
local maps = {}
for _, item in ipairs(stc.drawn) do if item.map then maps[item.map] = true end end
check(maps[1412] and maps[1411], "the continent shows the whole evening, both zones")
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

-- 13. Story and Hero path read the day differently: the same track walked three times is one
-- road in the story and three passes in the hero path; the hero path's early hours are paler.
do
    A.db.road = {}; Road.Reset()
    clock = os.time({year = 2026, month = 11, day = 25, hour = 20, min = 0})
    player.map, player.x, player.y = 1412, 0.2, 0.5
    Look(0)
    local start = clock
    for pass = 1, 3 do
        local dir = pass % 2 == 1 and 1 or -1
        for _ = 1, 40 do player.x = player.x + dir * 0.004; Look(2) end
    end
    journal[#journal + 1] = {k = "with", d = "dahlia-noir", n = "Dahlia-Noir", t = start, e = clock}
    local passDay = Road.DayOf(clock)
    Map.OpenDay(nil, passDay)
    local function Count() local n = 0; for _, item in ipairs(rawget(sheet.ink, "cjPools").lines) do if item:IsShown() then n = n + 1 end end; return n end
    local storyLines = Count()
    sheet.hero.scripts.OnClick(sheet.hero)
    local heroLines = Count()
    check(heroLines > storyLines * 2, "three passes: one road in the story (" .. storyLines .. "), all three in the hero path (" .. heroLines .. ")")
    local st = Upvalue(Map.Hover, "state")
    local first, last
    for _, item in ipairs(st.drawn) do if item.line then first = first or item; last = item end end
    check(first.line.color[4] < last.line.color[4], "the hero path's early ink is paler than its late ink")
    -- (no second path for a companion: one road; the hover still names who was there)
    local colours = {}
    for _, l in ipairs(rawget(sheet.ink, "cjPools").lines) do if l:IsShown() and l.color then colours[string.format("%.2f", l.color[3])] = true end end
    local n = 0; for _ in pairs(colours) do n = n + 1 end
    check(n == 1, "one ink for the road, no companion line")
    local withItem
    for _, item in ipairs(st.drawn) do if item.with then withItem = item end end
    check(withItem and withItem.with == "Dahlia-Noir", "the road still knows who walked it")
    sheet.story.scripts.OnClick(sheet.story)
end

-- 14. Explored areas: laid on the layer's own tiles (not the area's own texture count, which
-- can disagree), the last column cut from the smallest file that holds it.
do
    Map.OpenDay(nil, day)
    local pieces = {}
    for _, tile in ipairs(sheet.art.tiles) do if tile:IsShown() and (tile.texture == 1 or tile.texture == 2) then pieces[tile.texture] = tile end end
    check(pieces[1] and pieces[2], "an area of 300 by 200 is two tiles wide, whatever count it claims")
    check(pieces[1].w == 256 and pieces[2].w == 44 and pieces[2].points[1][4] == 10 + 256, "the second tile is the area's last 44 pixels, beside the first")
    check(math.abs(pieces[2].coords[2] - 44 / 64) < 1e-6 and math.abs(pieces[1].coords[4] - 200 / 256) < 1e-6, "cut from files of 64 and 256")
end
-- 15. Bridges: a short break in the road is joined by a dotted curve; a hearthstone is not.
do
    A.db.road = {}; Road.Reset()
    clock = os.time({year = 2026, month = 11, day = 28, hour = 20, min = 0})
    player.map, player.x, player.y = 1412, 0.3, 0.5
    Look(0)
    for _ = 1, 30 do player.x = player.x + 0.004; Look(2) end
    -- (two minutes unseen: a loading screen, a lift; the road breaks)
    for _ = 1, 3 do clock = clock + 40 end
    player.x = player.x + 0.03
    Look(2)
    for _ = 1, 30 do player.x = player.x + 0.004; Look(2) end
    local key = Road.DayOf(clock)
    check(#Road.Day("me", key) == 2, "the road broke in two")
    Map.OpenDay(nil, key)
    local stb = Upvalue(Map.Hover, "state")
    local bridge = 0
    for _, item in ipairs(stb.drawn) do if item.blobs and not item.stay and not item.travel then bridge = bridge + 1 end end
    check(bridge >= 2, "a dotted bridge joins the two stretches: " .. bridge .. " dots")
    journal[#journal + 1] = {k = "hearth", d = "Brill", t = clock - 60 - 80, z = "Mulgore"}
    Map.OpenDay(nil, key)
    bridge = 0
    for _, item in ipairs(stb.drawn) do if item.blobs and not item.stay and not item.travel then bridge = bridge + 1 end end
    check(bridge == 0, "not across a hearthstone")
end

-- 16. The walker glides: on foot between two recorded steps, in the air along the drawn arc,
-- and a replay moves it a little each frame, never in jumps.
do
    A.db.road = {}; Road.Reset()
    clock = os.time({year = 2026, month = 11, day = 29, hour = 20, min = 0})
    player.map, player.x, player.y = 1412, 0.2, 0.5
    Look(0)
    for _ = 1, 40 do player.x = player.x + 0.005; Look(2) end
    onTaxi = true; for _ = 1, 30 do Look(2) end; onTaxi = false
    player.x, player.y = 0.6, 0.2
    Look(2)
    for _ = 1, 20 do player.y = player.y + 0.005; Look(2) end
    local key = Road.DayOf(clock)
    Map.OpenDay(nil, key)
    local sw = Upvalue(Map.Hover, "state")
    local road
    for _, piece in ipairs(sw.model.pieces) do if piece.points and not road then road = piece end end
    local a, b = road.points[3], road.points[4]
    local x1 = Map.WalkerAt(a.t)
    local x2 = Map.WalkerAt(b.t)
    local xm = Map.WalkerAt((a.t + b.t) / 2)
    check(xm > x1 and xm < x2 and math.abs(xm - (x1 + x2) / 2) < 0.5, "on foot: halfway in time is halfway between the steps")
    local flight
    for _, piece in ipairs(sw.model.pieces) do if piece.kind == "flight" then flight = piece end end
    local c
    for _, curve in ipairs(sw.curves) do if curve.t0 == flight.from.t then c = curve end end
    local fx, fy = Map.WalkerAt((flight.from.t + flight.to.t) / 2)
    local ex = 0.25 * c.ax + 0.5 * c.mx + 0.25 * c.bx
    local ey = 0.25 * c.ay + 0.5 * c.my + 0.25 * c.by
    check(c and math.abs(fx - ex) < 0.01 and math.abs(fy - ey) < 0.01, "in the air: on the dotted arc, halfway along it")
    -- (a replay at x16: each frame a small step, never a jump)
    sw.speed = 16
    Map.Play()
    local lastX, lastY, worst = nil, nil, 0
    for _ = 1, 300 do
        if sheet.scripts.OnUpdate then sheet.scripts.OnUpdate(sheet, 1 / 60) end
        local p = sheet.walker.points[1]
        if p and sheet.walker:IsShown() then
            if lastX then worst = math.max(worst, math.sqrt((p[4] - lastX) ^ 2 + (p[5] - lastY) ^ 2)) end
            lastX, lastY = p[4], p[5]
        end
    end
    check(worst * sw.scale < 25, "a frame moves the walker a few pixels at most: " .. string.format("%.1f", worst * sw.scale))
    Map.Stop(); sw.speed = 1
end

-- 17. Like a video player: a click on the map plays and pauses; a click on a death opens its
-- card; the deaths sit on the slider as small red crosses.
do
    Map.OpenDay(nil, day)
    local sv = Upvalue(Map.Hover, "state")
    sheet.track.w = 400
    Map.Ticks()
    local tick = sheet.ticks and sheet.ticks[1]
    check(tick and tick:IsShown() and tick.mark.kind == "death", "the death is on the slider")
    check(math.abs(tick.points[1][4] - Map.ShareAt(tick.mark.t) * 400) < 0.01, "at its moment of the replay")
    tick.scripts.OnClick(tick)
    check(sv.time == tick.mark.t, "its cross takes the replay there")
    -- a click on empty ground: play, then pause
    cursor[1], cursor[2] = 5, 695
    sheet.area.scripts.OnMouseDown(sheet.area, "LeftButton"); sheet.area.scripts.OnMouseUp(sheet.area)
    check(sv.playing, "a click plays")
    sheet.area.scripts.OnMouseDown(sheet.area, "LeftButton"); sheet.area.scripts.OnMouseUp(sheet.area)
    check(not sv.playing, "a second click pauses")
    -- a click on the death's X: its card
    Map.SetTime(math.huge, true)
    local d
    for _, item in ipairs(sv.drawnMarks) do if item.mark.kind == "death" then d = item end end
    cursor[1], cursor[2] = d.x, 700 - d.y
    sheet.area.scripts.OnMouseDown(sheet.area, "LeftButton"); sheet.area.scripts.OnMouseUp(sheet.area)
    local card = _G.CompanionJournalDeathCard
    check(card and card:IsShown() and card.title.text == "Fell to a duskbat", "a click on the X opens the death's card")
    check(not sv.playing, "and does not start the replay")
    card:Hide()
end

-- 18. The slider takes the map along: dragging to a moment in Durotar turns a zone tab to
-- Durotar; a tab picked by hand while paused stays.
do
    A.db.road = {}; Road.Reset()
    clock = os.time({year = 2026, month = 11, day = 30, hour = 20, min = 0})
    player.map, player.x, player.y = 1412, 0.3, 0.5
    Look(0)
    for _ = 1, 40 do player.x = player.x + 0.004; Look(2) end
    player.map, player.x = 1411, 0.05
    for _ = 1, 40 do player.x = player.x + 0.004; Look(2) end
    local evening = Road.DayOf(clock)
    Map.OpenDay(nil, evening)
    local sf = Upvalue(Map.Hover, "state")
    for _, tab in ipairs(sheet.tabs) do if tab.label.text == "Mulgore" then tab.scripts.OnClick(tab) end end
    check(sf.view == 1412, "on Mulgore's tab")
    sheet.track.w = 400
    cursor[1] = 395; buttonDown = true
    sheet.track.scripts.OnMouseDown(sheet.track, "LeftButton")
    buttonDown = false
    if sheet.track.scripts.OnUpdate then sheet.track.scripts.OnUpdate(sheet.track) end
    check(sf.view == 1411, "dragged to the evening's end: the map turns to Durotar")
    for _, tab in ipairs(sheet.tabs) do if tab.label.text == "Mulgore" then tab.scripts.OnClick(tab) end end
    check(sf.view == 1412, "Mulgore picked by hand while paused: it stays")
end

-- 19. Along a zone's border the game flips between two maps every few seconds (Hillsbrad
-- and Alterac, 2026-11-18): the road is one line, joined at every flip, no holes.
do
    A.db.road = {}; Road.Reset()
    clock = os.time({year = 2026, month = 12, day = 1, hour = 20, min = 0})
    -- (a neighbour whose map overlaps Mulgore's east edge, as real zone maps overlap at
    -- their borders: a place there is on both)
    MAPS[1500] = {mapID = 1500, mapType = 3, parentMapID = 1414, name = "Borderland", ox = 3600}
    player.map, player.x, player.y = 1412, 0.92, 0.3
    Look(0)
    for i = 1, 60 do
        local wx = 0.92 * 4000 + i * 4                  -- walking east along the border
        player.y = player.y + 0.003
        if (math.floor(i / 2)) % 2 == 0 then player.map, player.x = 1412, wx / 4000
        else player.map, player.x = 1500, (wx - 3600) / 4000 end
        Look(2)
    end
    local key = Road.DayOf(clock)
    check(#Road.Day("me", key) > 10, "the record breaks at every flip")
    Map.OpenDay(nil, key)
    local sj = Upvalue(Map.Hover, "state")
    sheet.hero.scripts.OnClick(sheet.hero)
    -- every road stroke's end is the next one's start (in time order): one unbroken line
    local strokes = {}
    for _, item in ipairs(sj.drawn) do if item.line and item.line:IsShown() then strokes[#strokes + 1] = item.line end end
    local holes = 0
    for k = 2, #strokes do
        local a, b = strokes[k - 1], strokes[k]
        if math.abs(a.x2 - b.x1) > 0.5 or math.abs(a.y2 - b.y1) > 0.5 then holes = holes + 1 end
    end
    check(#strokes > 20 and holes == 0, "one unbroken line across the flips (" .. holes .. " holes)")
    sheet.story.scripts.OnClick(sheet.story)
    MAPS[1500] = nil
end

-- 8. A chapter's map mark opens its day.
local page = New("Frame"); page.box = {70, 70, 76, 56}
Map.Mark(page, {self = true}, {day = {key = day}, part = 1})
check(page.roadMark and page.roadMark:IsShown(), "a chapter's first page has the map mark")
Map.Mark(page, {self = true}, {day = {key = day}, part = 2})
check(not page.roadMark:IsShown(), "later pages of the chapter do not")
print("RoadMap: " .. checks .. " checks passed")
