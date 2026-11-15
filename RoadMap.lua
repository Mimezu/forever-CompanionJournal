local _, A = ...
-- The Road's map (docs/HERO-PATH.md): a folded map sheet laid over the book, showing a
-- day (from the map mark on a chapter) or the whole adventure (the Atlas bookmark).
--   Story view: the road smoothed, ink washes where you stayed, the chapter's moments.
--   Hero path: the true line, every step.
-- Tabs: the day's zones in the order you saw them, their continents, the world.
-- Replay: your class crest walks the road again, the ink follows it, the moments appear as
-- they are passed, with quiet sounds; three speeds and a time slider.
-- All drawing is our own frames over the game's map art: Blizzard's map is never touched.

local Model = A.RoadModel
local Map = {}
A.RoadMap = Map
A.defaults.roadSounds = true

local INK = {0.24, 0.13, 0.05}
local SOFT = {0.36, 0.22, 0.08}
local RED = {0.55, 0.08, 0.04}
local PAPER_INK = {0.91, 0.84, 0.69} -- (the paper, for the hollow of a ring)
local WORLD = 947
local PAPER = "paper3" -- (the folded cream: a map is a sheet folded in four)
local B = "Interface\\Icons\\"
local ICONS = {campfire = B .. "Spell_Fire_Fire", inn = B .. "Spell_Nature_Sleep", dungeon = B .. "INV_Misc_Key_03",
    hearth = B .. "INV_Misc_Rune_01", voyage = B .. "INV_Misc_Spyglass_02", rez = B .. "Spell_Holy_Resurrection"}
local HERO_LIMIT, STORY_LIMIT = 900, 500 -- segments a view draws at most (thinned to fit)

local function Public(value) return not issecretvalue or not issecretvalue(value) end
local function Ask(fn, ...)
    if type(fn) ~= "function" then return nil end
    local ok, a, b, c = pcall(fn, ...)
    if not ok or not Public(a) then return nil end
    return a, b, c
end
local function Clock(t) return date and date("%H:%M", t) or "" end

local sheet
local state = {mode = "story", speed = 1}

-- Sounds -------------------------------------------------------------------------------
-- The game's own, quiet; the first that exists of each list. Off with "Sounds" (Settings).
local SOUNDS = {
    page = {"IG_ABILITY_PAGE_TURN", "IG_SPELLBOOK_OPEN"},
    death = {"IG_QUEST_FAILED", "IG_PLAYER_INVITE_DECLINE"},
    level = {"LEVELUPSOUND", "UI_CLASS_TALENT_APPLY_COMPLETE", "IG_QUEST_LIST_COMPLETE"},
    dungeon = {"IG_CHARACTER_INFO_OPEN", "IG_MAINMENU_OPEN"},
    mark = {"U_CHAT_SCROLL_BUTTON"},
    play = {"IG_QUEST_LOG_OPEN"},
}
local function Sound(kind)
    if A.db and A.db.roadSounds == false or not PlaySound or not SOUNDKIT then return end
    for _, name in ipairs(SOUNDS[kind] or {}) do
        if SOUNDKIT[name] then pcall(PlaySound, SOUNDKIT[name]); return end
    end
end

-- Small helpers ----------------------------------------------------------------------
local function InkButton(parent, text, width, onClick)
    local button = CreateFrame("Button", nil, parent)
    button.label = button:CreateFontString(nil, "ARTWORK", "GameFontNormalSmall")
    button.label:SetPoint("CENTER"); button.label:SetText(text)
    button.ink = true
    button:SetSize(width, 20)
    button:SetScript("OnClick", onClick)
    if A.StyleBookControl then A.StyleBookControl(button, false) end
    return button
end
local function Chosen(button, chosen) if A.StyleBookControl then A.StyleBookControl(button, chosen) end end

-- Douglas-Peucker: the fewest points within tol of the line (points {x, y, t}).
local function Simplify(pts, tol)
    if #pts < 3 then return pts end
    local keep = {[1] = true, [#pts] = true}
    local stack = {{1, #pts}}
    while #stack > 0 do
        local span = table.remove(stack)
        local a, b = pts[span[1]], pts[span[2]]
        local dx, dy = b.x - a.x, b.y - a.y
        local len = math.sqrt(dx * dx + dy * dy)
        local far, at = 0, nil
        for i = span[1] + 1, span[2] - 1 do
            local p = pts[i]
            local d = len > 0 and math.abs(dy * p.x - dx * p.y + b.x * a.y - b.y * a.x) / len or math.sqrt((p.x - a.x) ^ 2 + (p.y - a.y) ^ 2)
            if d > far then far, at = d, i end
        end
        if at and far > tol then
            keep[at] = true
            stack[#stack + 1] = {span[1], at}; stack[#stack + 1] = {at, span[2]}
        end
    end
    local out = {}
    for i = 1, #pts do if keep[i] then out[#out + 1] = pts[i] end end
    return out
end
-- Chaikin: corners cut twice, a hand-drawn road.
local function Smooth(pts)
    for _ = 1, 2 do
        if #pts < 3 then return pts end
        local out = {pts[1]}
        for i = 1, #pts - 1 do
            local a, b = pts[i], pts[i + 1]
            out[#out + 1] = {x = a.x * 0.75 + b.x * 0.25, y = a.y * 0.75 + b.y * 0.25, t = a.t + (b.t - a.t) * 0.25}
            out[#out + 1] = {x = a.x * 0.25 + b.x * 0.75, y = a.y * 0.25 + b.y * 0.75, t = a.t + (b.t - a.t) * 0.75}
        end
        out[#out + 1] = pts[#pts]
        pts = out
    end
    return pts
end
-- Fewer points: one every step (in map units), the first and last kept.
local function Thin(pts, step)
    if #pts < 3 then return pts end
    local out, last = {pts[1]}, pts[1]
    for i = 2, #pts - 1 do
        local p = pts[i]
        if (p.x - last.x) ^ 2 + (p.y - last.y) ^ 2 >= step * step then out[#out + 1] = p; last = p end
    end
    out[#out + 1] = pts[#pts]
    return out
end
Map.Simplify, Map.Smooth, Map.Thin = Simplify, Smooth, Thin

-- The map art ------------------------------------------------------------------------
-- The zone's tiles and the parts you have explored, tinted to the paper's inks.
local function ArtSize(map)
    local layers = Ask(C_Map.GetMapArtLayers, map)
    local layer = type(layers) == "table" and layers[1]
    if not layer then return nil end
    return layer.layerWidth, layer.layerHeight, layer.tileWidth or 256, layer.tileHeight or 256
end
local function DrawArt(art, map)
    art.tiles = art.tiles or {}
    local used = 0
    local function Tile()
        used = used + 1
        local tile = art.tiles[used]
        if not tile then tile = art:CreateTexture(nil, "BACKGROUND"); art.tiles[used] = tile end
        tile:ClearAllPoints(); tile:SetTexCoord(0, 1, 0, 1); tile:Show()
        tile:SetVertexColor(1, 0.93, 0.80); tile:SetAlpha(0.88)
        if tile.SetDesaturation then tile:SetDesaturation(0.35) end
        return tile
    end
    local w, h, tw, th = ArtSize(map)
    if not w then for _, tile in ipairs(art.tiles) do tile:Hide() end; return nil end
    local files = Ask(C_Map.GetMapArtLayerTextures, map, 1)
    local cols = math.max(1, math.ceil(w / tw))
    for i, file in ipairs(type(files) == "table" and files or {}) do
        local col, row = (i - 1) % cols, math.floor((i - 1) / cols)
        local tile = Tile()
        tile:SetTexture(file); tile:SetSize(tw, th); tile:SetPoint("TOPLEFT", art, "TOPLEFT", col * tw, -row * th)
    end
    local overlays = C_MapExplorationInfo and Ask(C_MapExplorationInfo.GetExploredMapTextures, map)
    for _, o in ipairs(type(overlays) == "table" and overlays or {}) do
        if not o.isShownByMouseOver and o.fileDataIDs then
            local wide, tall = o.numTexturesWide or 1, o.numTexturesTall or 1
            for r = 1, tall do
                for c = 1, wide do
                    local file = o.fileDataIDs[(r - 1) * wide + c]
                    if file then
                        local cw = c < wide and 256 or (o.textureWidth - 256 * (wide - 1))
                        local ch = r < tall and 256 or (o.textureHeight - 256 * (tall - 1))
                        local pw, ph = 16, 16
                        while pw < cw do pw = pw * 2 end
                        while ph < ch do ph = ph * 2 end
                        local tile = Tile()
                        tile:SetTexture(file); tile:SetSize(cw, ch); tile:SetTexCoord(0, cw / pw, 0, ch / ph)
                        tile:SetPoint("TOPLEFT", art, "TOPLEFT", (o.offsetX or 0) + 256 * (c - 1), -((o.offsetY or 0) + 256 * (r - 1)))
                    end
                end
            end
        end
    end
    for i = used + 1, #art.tiles do art.tiles[i]:Hide() end
    return w, h
end

-- Ink --------------------------------------------------------------------------------
-- (pools of lines, washes and crests, kept in their own table on the ink frame)
local function Pools(ink) ink.cjPools = rawget(ink, "cjPools") or {}; return ink.cjPools end
local function Pool(ink, key, make)
    local pools = Pools(ink)
    pools[key] = pools[key] or {}
    pools[key].used = 0
    pools[key].make = make or pools[key].make
end
local function Take(ink, key)
    local pool = Pools(ink)[key]
    pool.used = pool.used + 1
    local item = pool[pool.used]
    if not item then item = pool.make(); pool[pool.used] = item end
    item:Show()
    return item
end
local function Finish(ink, key)
    local pool = Pools(ink)[key]
    for i = pool.used + 1, #pool do pool[i]:Hide() end
end
local function Line(ink, x1, y1, x2, y2, thick, color, alpha)
    local line = Take(ink, "lines")
    line:SetColorTexture(color[1], color[2], color[3], alpha or 0.9)
    line:SetThickness(thick)
    line:SetStartPoint("TOPLEFT", ink, x1, -y1); line:SetEndPoint("TOPLEFT", ink, x2, -y2)
    return line
end
local function Blob(ink, x, y, size, alpha, color)
    local blob = Take(ink, "blobs")
    color = color or INK
    blob:SetVertexColor(color[1], color[2], color[3], alpha)
    blob:ClearAllPoints(); blob:SetPoint("CENTER", ink, "TOPLEFT", x, -y); blob:SetSize(size, size)
    return blob
end

-- Drawing a view -----------------------------------------------------------------------
-- view: a map id; the model's pieces, stays and marks put on it.
local function Place(map, view, x, y)
    local fn = Model.Transform(map, view)
    if not fn then return nil end
    local vx, vy = fn(x, y)
    if not vx or vx < -0.02 or vx > 1.02 or vy < -0.02 or vy > 1.02 then return nil end
    return vx, vy
end
local function Companion(key)
    local person = key and A.People and A.People[key]
    local color = person and person.class and RAID_CLASS_COLORS and RAID_CLASS_COLORS[person.class]
    if not color then return {0.20, 0.30, 0.55} end
    return {color.r * 0.55 + INK[1] * 0.45, color.g * 0.55 + INK[2] * 0.45, color.b * 0.55 + INK[3] * 0.45}
end

local function DrawView()
    local s = sheet
    local view = state.view
    local art, ink = s.art, s.ink
    local w, h = DrawArt(art, view)
    s.empty:SetShown(w == nil)
    if not w then w, h = 1002, 668 end
    -- (the area's size as laid out, not as the frame reports it before it is drawn)
    local areaW, areaH = state.areaW or s.area:GetWidth(), state.areaH or s.area:GetHeight()
    local base = math.max(0.05, math.min(areaW / w, areaH / h))
    local scale = base * (state.zoom or 1)
    art:SetSize(w, h); art:SetScale(math.max(0.05, scale))
    ink:SetAllPoints(art)
    state.w, state.h, state.scale, state.base = w, h, scale, base
    Map.Pan(state.panX or 0, state.panY or 0)
    local px = 1 / scale -- (one screen pixel in map units)
    for _, key in ipairs({"lines", "blobs", "marks"}) do Pool(ink, key) end
    state.drawn, state.drawnMarks, state.hover = {}, {}, {}
    local story = state.mode == "story"
    local models = state.atlas and state.atlasModels or {state.model}
    -- The road, piece by piece.
    for mi, model in ipairs(models) do
        local age = state.atlas and (0.30 + 0.62 * mi / #models) or 1
        for _, piece in ipairs(model.pieces) do
            if piece.points then
                local pts = {}
                for _, p in ipairs(piece.points) do
                    local vx, vy = Place(piece.map, view, p.x, p.y)
                    if vx then pts[#pts + 1] = {x = vx * w, y = vy * h, t = p.t} end
                end
                if story or state.atlas then pts = Smooth(Simplify(pts, (state.atlas and 3 or 2.2) * px))
                else pts = Thin(pts, 1.6 * px) end
                -- (a very long day stays light to draw: fewer points until it fits)
                local limit, step = story and STORY_LIMIT or HERO_LIMIT, 3 * px
                while #pts > limit do pts = Thin(pts, step); step = step * 2 end
                local ghost = piece.kind == "ghost"
                local thick = (story and 2.4 or 1.5) * px
                for k = 2, #pts do
                    local a, b = pts[k - 1], pts[k]
                    if not ghost or k % 2 == 0 then
                        local line = Line(ink, a.x, a.y, b.x, b.y, thick, INK, (ghost and 0.45 or 0.88) * age)
                        local item = {t = b.t, x = b.x, y = b.y, line = line, map = piece.map, day = model.day}
                        local with = not state.atlas and Model.WithAt(model, b.t)
                        if with then
                            -- (the road walked together: a second line beside it, in their colour)
                            local dx, dy = b.x - a.x, b.y - a.y
                            local len = math.sqrt(dx * dx + dy * dy)
                            if len > 0 then
                                local ox, oy = -dy / len * 2.6 * px, dx / len * 2.6 * px
                                item.line2 = Line(ink, a.x + ox, a.y + oy, b.x + ox, b.y + oy, 1.4 * px, Companion(with.key), 0.85)
                                item.with = with.name
                            end
                        end
                        state.drawn[#state.drawn + 1] = item
                    end
                end
            elseif piece.from then
                -- A flight or a voyage: a dotted line (an arc for a wyvern, a gentler one at
                -- sea), with a small ring where it began and where it ended.
                local ax, ay = Place(piece.from.map, view, piece.from.x, piece.from.y)
                local bx, by = Place(piece.to.map, view, piece.to.x, piece.to.y)
                if ax and bx then
                    ax, ay, bx, by = ax * w, ay * h, bx * w, by * h
                    local bow = piece.kind == "flight" and 0.15 or 0.08
                    local mx, my = (ax + bx) / 2 - (by - ay) * bow, (ay + by) / 2 + (bx - ax) * bow
                    local length = math.sqrt((bx - ax) ^ 2 + (by - ay) ^ 2)
                    local dots = math.max(3, math.min(80, math.floor(length / (7 * px))))
                    for k = 1, dots - 1 do
                        local u = k / dots
                        local x = (1 - u) ^ 2 * ax + 2 * (1 - u) * u * mx + u ^ 2 * bx
                        local y = (1 - u) ^ 2 * ay + 2 * (1 - u) * u * my + u ^ 2 * by
                        local dot = Blob(ink, x, y, 2.6 * px, 0.75 * age)
                        state.drawn[#state.drawn + 1] = {t = piece.from.t + (piece.to.t - piece.from.t) * u, x = x, y = y, blobs = {dot}, day = model.day, travel = piece}
                    end
                    for i, end_ in ipairs({{ax, ay, piece.from.t}, {bx, by, piece.to.t}}) do
                        local ring = {Blob(ink, end_[1], end_[2], 8 * px, 0.9 * age), Blob(ink, end_[1], end_[2], 4.4 * px, 1, PAPER_INK)}
                        state.drawn[#state.drawn + 1] = {t = end_[3], x = end_[1], y = end_[2], blobs = ring, day = model.day, travel = piece, landing = i == 2}
                    end
                end
            end
        end
        -- Stays: ink washes, darker the longer you stayed (Story view and the Atlas).
        if story or state.atlas or not model.recorded then
            for _, stay in ipairs(model.stays) do
                local vx, vy = Place(stay.map, view, stay.x, stay.y)
                if vx then
                    local minutes = stay.secs / 60
                    local yw = Model.Yards(stay.map)
                    local reach = (stay.yards / yw) * w -- (its spread on this view)
                    local size = math.max((8 + 3 * math.sqrt(minutes)) * px, math.min(reach * 2, 90 * px))
                    if state.atlas or view == WORLD then size = math.max(5 * px, math.min(size, 14 * px)) end
                    local strength = math.min(0.32, 0.10 + minutes / 400)
                    local wash = {Blob(ink, vx * w, vy * h, size, strength * age), Blob(ink, vx * w, vy * h, size * 0.62, strength * 0.8 * age)}
                    state.drawn[#state.drawn + 1] = {t = stay.t, x = vx * w, y = vy * h, blobs = wash, day = model.day, stay = stay}
                end
            end
            -- (a day before the recorder: its zones joined in order by a faint dashed line)
            if not model.recorded then
                local last
                for _, stay in ipairs(model.stays) do
                    local vx, vy = Place(stay.map, view, stay.x, stay.y)
                    if vx then
                        local here = {x = vx * w, y = vy * h}
                        if last then
                            local len = math.sqrt((here.x - last.x) ^ 2 + (here.y - last.y) ^ 2)
                            local dashes = math.max(1, math.floor(len / (10 * px)))
                            for k = 0, dashes - 1, 2 do
                                local u1, u2 = k / dashes, math.min(1, (k + 1) / dashes)
                                local line = Line(ink, last.x + (here.x - last.x) * u1, last.y + (here.y - last.y) * u1,
                                    last.x + (here.x - last.x) * u2, last.y + (here.y - last.y) * u2, 1.2 * px, INK, 0.38 * age)
                                state.drawn[#state.drawn + 1] = {t = stay.t, x = here.x, y = here.y, line = line, day = model.day}
                            end
                        end
                        last = here
                    end
                end
            end
        end
    end
    -- Marks: the moments, as small ink signs and crests.
    if not state.atlas then
        for _, mark in ipairs(state.model.marks) do
            local vx, vy = Place(mark.map, view, mark.x, mark.y)
            if vx then
                local x, y = vx * w, vy * h
                local parts = {}
                if mark.kind == "death" then
                    local r = 5 * px
                    parts[1] = Line(ink, x - r, y - r, x + r, y + r, 2.2 * px, RED, 0.95)
                    parts[2] = Line(ink, x - r, y + r, x + r, y - r, 2.2 * px, RED, 0.95)
                elseif mark.kind == "level" then
                    local r = 4.5 * px
                    parts[1] = Line(ink, x - r, y, x + r, y, 1.8 * px, {0.55, 0.38, 0.10}, 0.95)
                    parts[2] = Line(ink, x, y - r, x, y + r, 1.8 * px, {0.55, 0.38, 0.10}, 0.95)
                elseif mark.kind == "first" then
                    parts[1] = Blob(ink, x, y, 7 * px, 0.9, RED)
                else
                    local crest = Take(ink, "marks")
                    crest:SetScale(1); crest:SetSize(15 * px, 15 * px)
                    crest.icon:SetSize(13 * px, 13 * px)
                    crest.icon:SetTexture(ICONS[mark.kind] or ICONS.hearth)
                    crest:ClearAllPoints(); crest:SetPoint("CENTER", ink, "TOPLEFT", x, -y)
                    parts[1] = crest
                end
                if mark.guess then for _, part in ipairs(parts) do part:SetAlpha(0.5) end end
                state.drawnMarks[#state.drawnMarks + 1] = {t = mark.t, x = x, y = y, parts = parts, mark = mark}
            end
        end
    end
    for _, key in ipairs({"lines", "blobs", "marks"}) do Finish(ink, key) end
    table.sort(state.drawn, function(a, b) return a.t < b.t end)
    state.shownTo = nil
    Map.SetTime(state.time or math.huge, true)
end

-- Time: what is shown up to a moment (the replay and the slider) ---------------------------
local function Show(item, shown)
    for _, key in ipairs({"line", "line2"}) do if item[key] then item[key]:SetShown(shown) end end
    for _, part in ipairs(item.blobs or item.parts or {}) do part:SetShown(shown) end
end
function Map.SetTime(t, quiet)
    if not sheet or not state.drawn then return end
    state.time = t
    for _, item in ipairs(state.drawn) do Show(item, item.t <= t) end
    for _, item in ipairs(state.drawnMarks) do
        local shown = item.t <= t
        if shown and not item.shown and not quiet and state.playing then
            Sound(item.mark.kind == "death" and "death" or item.mark.kind == "level" and "level"
                or item.mark.kind == "dungeon" and "dungeon" or "mark")
        end
        item.shown = shown
        Show(item, shown)
    end
    -- The walker: your class crest where you were then.
    local walker = sheet.walker
    local place = state.model and not state.atlas and t ~= math.huge and Model.PlaceAt(state.model, t)
    local vx, vy
    if place then vx, vy = Place(place.map, state.view, place.x, place.y) end
    walker:SetShown(vx ~= nil)
    if vx then walker:ClearAllPoints(); walker:SetPoint("CENTER", sheet.ink, "TOPLEFT", vx * state.w, -vy * state.h) end
    -- The slider and the clock.
    local u
    if state.atlas then
        local count = #(state.atlasDays or {})
        u = (t == math.huge or count < 2) and 1 or math.max(0, math.min(1, ((t or 1) - 1) / (count - 1)))
    else
        u = t == math.huge and 1 or Map.ShareAt(t)
    end
    sheet.knob:ClearAllPoints(); sheet.knob:SetPoint("CENTER", sheet.track, "LEFT", u * sheet.track:GetWidth(), 0)
    if state.atlas then
        local day = state.atlasDays and state.atlasDays[math.max(1, math.min(#state.atlasDays, math.floor(u * (#state.atlasDays - 1) + 1.5)))]
        sheet.clock:SetText(t == math.huge and "" or (day or ""))
    else
        sheet.clock:SetText(t == math.huge and "" or Clock(t))
    end
    -- On a zone's tab, the map follows the walker into the next zone.
    if place and not vx and state.playing and state.zoneView and place.map ~= state.view then
        for _, zone in ipairs(state.model.zones) do
            if zone.map == place.map then Sound("page"); Map.SetView(place.map); return end
        end
    end
end

-- Replay ------------------------------------------------------------------------------
-- One playhead, state.share (0 at the day's start, 1 at its end), moved by Play, shown by
-- the slider, set by dragging it: the three always agree. The share is of the day's
-- "effort": every step counts, but a pause counts at most WAIT seconds, so a day replays
-- its walking, not its idling. About DAY_SECONDS for a day at x1.
local WAIT, DAY_SECONDS = 20, 60
-- The effort table: {t, w} rising with time, from the day's first moment to its last.
local function Effort()
    local times = {}
    if not state.atlas and state.model then
        for _, piece in ipairs(state.model.pieces) do
            for _, p in ipairs(piece.points or {}) do times[#times + 1] = p.t end
            if piece.from then times[#times + 1] = piece.from.t; times[#times + 1] = piece.to.t end
        end
        for _, mark in ipairs(state.model.marks) do times[#times + 1] = mark.t end
    end
    if state.t0 then times[#times + 1] = state.t0 end
    if state.t1 then times[#times + 1] = state.t1 end
    table.sort(times)
    local list, w = {}, 0
    for i, t in ipairs(times) do
        if i > 1 then w = w + math.min(t - times[i - 1], WAIT) end
        list[#list + 1] = {t = t, w = w}
    end
    -- (nothing to walk: the day's hours, evenly)
    if w <= 0 then list = {{t = state.t0 or 0, w = 0}, {t = state.t1 or state.t0 or 0, w = 1}} end
    state.efforts = list
end
-- The playhead's time, and a time's playhead.
local function TimeAt(share)
    local list = state.efforts
    if not list then return state.t1 or 0 end
    local w = share * list[#list].w
    for i = 2, #list do
        if list[i].w >= w then
            local a, b = list[i - 1], list[i]
            local u = b.w > a.w and (w - a.w) / (b.w - a.w) or 1
            return a.t + (b.t - a.t) * u
        end
    end
    return list[#list].t
end
local function ShareAt(t)
    local list = state.efforts
    if not list or t == math.huge then return 1 end
    if t <= list[1].t then return 0 end
    for i = 2, #list do
        if list[i].t >= t then
            local a, b = list[i - 1], list[i]
            local u = b.t > a.t and (t - a.t) / (b.t - a.t) or 1
            return (a.w + (b.w - a.w) * u) / list[#list].w
        end
    end
    return 1
end
Map.TimeAt, Map.ShareAt = TimeAt, ShareAt

-- Running and stopping: the only two places the replay's clock is started or stopped.
local OnUpdate
local function Stop()
    state.playing = false
    if sheet then sheet:SetScript("OnUpdate", nil) end
    Map.Controls()
end
local function Run()
    state.playing = true
    sheet:SetScript("OnUpdate", OnUpdate)
    Map.Controls()
end
function OnUpdate(_, elapsed)
    if not state.playing then sheet:SetScript("OnUpdate", nil); return end
    state.share = math.min(1, (state.share or 0) + elapsed * (state.speed or 1) / DAY_SECONDS)
    if state.share >= 1 then
        Stop()
        Map.SetTime(math.huge)
        if state.tour then Map.TourNext() end
        return
    end
    Map.SetTime(TimeAt(state.share))
end
function Map.Play()
    if state.playing then Stop(); return end
    if state.atlas then
        -- (the Atlas plays the whole adventure: every day's replay, one after another)
        if #(state.atlasDays or {}) == 0 then return end
        state.tour = {days = state.atlasDays, index = 1, person = state.atlasPerson}
        Map.TourDay()
        return
    end
    if not state.efforts then Effort() end
    -- (from the start when the whole day is shown or the end was reached; else from here)
    if state.time == math.huge or not state.share or state.share >= 1 then state.share = 0 end
    Sound("play")
    Map.SetTime(TimeAt(state.share), true)
    Run()
end
Map.Stop = Stop

-- The slider: press and drag to move the playhead; it lets go when the button is up,
-- wherever the cursor is (no drag registration: a dragged frame never hears its mouse-up).
-- Playing before, playing after. Silent while you scrub.
local function ScrubTo()
    local track = sheet.track
    local x = GetCursorPosition() / track:GetEffectiveScale()
    local u = math.max(0, math.min(1, (x - (track:GetLeft() or 0)) / math.max(1, track:GetWidth())))
    if state.atlas then
        local count = #(state.atlasDays or {})
        if count == 0 then return end
        local day = state.atlasDays[math.max(1, math.min(count, math.floor(u * (count - 1) + 1.5)))]
        Map.SetTime(u >= 1 and math.huge or state.atlasTimes[day], true)
        return
    end
    if not state.efforts then Effort() end
    state.share = u
    Map.SetTime(u >= 1 and math.huge or TimeAt(u), true)
end
local function EndScrub()
    if not state.scrubbing then return end
    state.scrubbing = false
    if sheet then sheet.track:SetScript("OnUpdate", nil) end
    if state.resume and (state.share or 1) < 1 then Run() end
    state.resume = nil
end
local function BeginScrub(button)
    if button and button ~= "LeftButton" then return end
    state.resume = state.playing
    if state.playing then Stop() end
    state.scrubbing = true
    ScrubTo()
    sheet.track:SetScript("OnUpdate", function()
        if IsMouseButtonDown and not IsMouseButtonDown("LeftButton") then EndScrub(); return end
        ScrubTo()
    end)
end
Map.EndScrub = EndScrub

-- The sheet ---------------------------------------------------------------------------
local function Make()
    if sheet then return end
    local book = A.BookFrame and A.BookFrame()
    sheet = CreateFrame("Frame", "CompanionJournalRoad", book or UIParent)
    -- (the book is on the DIALOG layer and its pages climb high within it: the sheet lies
    -- one layer up, so no page, text or ribbon can draw over the map; everything made
    -- inside the sheet takes its layer)
    sheet:SetFrameStrata("FULLSCREEN"); sheet:EnableMouse(true); sheet:SetToplevel(true)
    if UISpecialFrames then table.insert(UISpecialFrames, "CompanionJournalRoad") end
    sheet:Hide()
    sheet:SetScript("OnHide", function()
        state.tour = nil
        EndScrub(); Stop()
        if A.RefreshBookmarks then A.RefreshBookmarks() end
    end)
    sheet.title = sheet:CreateFontString(nil, "OVERLAY", "GameFontNormalLarge")
    if A.BookTitleFont and A.BookTitleFont(20) then sheet.title:SetFontObject(A.BookTitleFont(20)) end
    sheet.title:SetTextColor(RED[1], RED[2], RED[3]); if sheet.title.SetShadowOffset then sheet.title:SetShadowOffset(0, 0) end
    sheet.facts = sheet:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
    sheet.facts:SetTextColor(SOFT[1], SOFT[2], SOFT[3]); if sheet.facts.SetShadowOffset then sheet.facts:SetShadowOffset(0, 0) end
    sheet.close = InkButton(sheet, "\195\151", 22, function() sheet:Hide() end)
    sheet.tabs = {}
    -- The map: a clipped area with the art, and the ink over it.
    sheet.area = CreateFrame("Frame", nil, sheet)
    if sheet.area.SetClipsChildren then sheet.area:SetClipsChildren(true) end
    sheet.art = CreateFrame("Frame", nil, sheet.area)
    sheet.ink = CreateFrame("Frame", nil, sheet.art)
    sheet.ink:SetFrameLevel(sheet.art:GetFrameLevel() + 2)
    local ink = sheet.ink
    Pool(ink, "lines", function() return ink:CreateLine(nil, "ARTWORK") end)
    Pool(ink, "blobs", function()
        local blob = ink:CreateTexture(nil, "BORDER")
        blob:SetTexture("Interface\\CharacterFrame\\TempPortraitAlphaMask")
        return blob
    end)
    Pool(ink, "marks", function()
        local crest = A.BookCrest and A.BookCrest(ink, 15)
        if not crest then crest = CreateFrame("Frame", nil, ink); crest.icon = crest:CreateTexture(nil, "ARTWORK"); crest.icon:SetAllPoints() end
        crest:SetFrameLevel(ink:GetFrameLevel() + 3)
        return crest
    end)
    sheet.empty = sheet.area:CreateFontString(nil, "OVERLAY", "GameFontNormal")
    sheet.empty:SetPoint("CENTER"); sheet.empty:SetTextColor(SOFT[1], SOFT[2], SOFT[3]); sheet.empty:SetText("No map here")
    -- The walker: your class crest.
    sheet.walker = A.BookCrest and A.BookCrest(sheet.ink, 20) or CreateFrame("Frame", nil, sheet.ink)
    sheet.walker:SetFrameLevel(sheet.ink:GetFrameLevel() + 6)
    sheet.walker:Hide()
    -- Controls: Story | Hero path, Play, speeds, the slider and the clock.
    sheet.story = InkButton(sheet, "Story", 60, function() state.mode = "story"; DrawView(); Map.Controls() end)
    sheet.hero = InkButton(sheet, "Hero path", 76, function() state.mode = "hero"; DrawView(); Map.Controls() end)
    sheet.play = InkButton(sheet, "Play", 54, function() Map.Play() end)
    sheet.speeds = {}
    for i, speed in ipairs({1, 4, 16}) do
        sheet.speeds[i] = InkButton(sheet, "\195\151" .. speed, 32, function() state.speed = speed; Map.Controls() end)
        sheet.speeds[i].speed = speed
    end
    sheet.track = CreateFrame("Button", nil, sheet)
    sheet.track:SetHeight(16)
    local rule = sheet.track:CreateTexture(nil, "ARTWORK")
    rule:SetPoint("LEFT"); rule:SetPoint("RIGHT"); rule:SetHeight(1); rule:SetColorTexture(SOFT[1], SOFT[2], SOFT[3], 0.6)
    sheet.knob = sheet.track:CreateTexture(nil, "OVERLAY")
    sheet.knob:SetTexture("Interface\\CharacterFrame\\TempPortraitAlphaMask"); sheet.knob:SetSize(9, 9)
    sheet.knob:SetVertexColor(RED[1], RED[2], RED[3], 1)
    sheet.track:SetScript("OnMouseDown", function(_, button) BeginScrub(button) end)
    sheet.track:SetScript("OnMouseUp", function() EndScrub() end)
    sheet.clock = sheet:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
    sheet.clock:SetTextColor(SOFT[1], SOFT[2], SOFT[3]); if sheet.clock.SetShadowOffset then sheet.clock:SetShadowOffset(0, 0) end
    -- Hover: the time and what was happening at the nearest bit of road or moment.
    sheet.area:EnableMouse(true)
    sheet.area:SetScript("OnEnter", function(self) self:SetScript("OnUpdate", Map.Hover) end)
    sheet.area:SetScript("OnLeave", function(self) self:SetScript("OnUpdate", nil); if GameTooltip then GameTooltip:Hide() end end)
    -- The wheel belongs to the map while the sheet is open (the book's pages wait): over
    -- the map it zooms around the cursor; drag to move a zoomed map.
    sheet:EnableMouseWheel(true)
    sheet:SetScript("OnMouseWheel", function() end)
    sheet.area:EnableMouseWheel(true)
    sheet.area:SetScript("OnMouseWheel", function(_, delta) Map.Zoom(delta > 0 and 1.25 or 0.8) end)
    sheet.area:SetScript("OnMouseDown", function(self, button)
        if button ~= "LeftButton" then return end
        local cx, cy = GetCursorPosition()
        local scale = self:GetEffectiveScale()
        state.drag = {x = cx / scale, y = cy / scale, panX = state.panX or 0, panY = state.panY or 0, moved = false}
        self:SetScript("OnUpdate", function()
            local nx, ny = GetCursorPosition()
            local d = state.drag
            if not d then return end
            local dx, dy = nx / scale - d.x, ny / scale - d.y
            if math.abs(dx) + math.abs(dy) > 3 then d.moved = true end
            if d.moved then Map.Pan(d.panX + dx, d.panY + dy) end
            Map.Hover()
        end)
    end)
    sheet.area:SetScript("OnMouseUp", function(self)
        local dragged = state.drag and state.drag.moved
        state.drag = nil
        self:SetScript("OnUpdate", Map.Hover)
        if not dragged and state.atlas and state.hoverDay then Map.OpenDay(state.atlasPerson, state.hoverDay) end
    end)
    -- The day before and the day after, beside the date: no need to go back to the book.
    local function Arrow(text, delta)
        local button = InkButton(sheet, text, 22, function() Map.Step(delta) end)
        button:SetScript("OnEnter", function(self)
            local day = Map.Neighbour(delta)
            if not day or not GameTooltip then return end
            GameTooltip:SetOwner(self, "ANCHOR_TOP"); GameTooltip:SetText(Map.DayTitle(day), 1, 0.9, 0.7); GameTooltip:Show()
        end)
        button:SetScript("OnLeave", function() if GameTooltip then GameTooltip:Hide() end end)
        return button
    end
    sheet.prevDay, sheet.nextDay = Arrow("<", -1), Arrow(">", 1)
end

-- Zoom and pan: the map's place in its area (pan, in screen units from the middle), kept
-- inside so the map always covers what it can of the area.
function Map.Pan(x, y)
    if not sheet then return end
    local w, h, scale = state.w or 1, state.h or 1, state.scale or 1
    local areaW, areaH = state.areaW or sheet.area:GetWidth(), state.areaH or sheet.area:GetHeight()
    local maxX, maxY = math.max(0, (w * scale - areaW) / 2), math.max(0, (h * scale - areaH) / 2)
    state.panX, state.panY = math.max(-maxX, math.min(maxX, x)), math.max(-maxY, math.min(maxY, y))
    sheet.art:ClearAllPoints()
    sheet.art:SetPoint("CENTER", sheet.area, "CENTER", state.panX / scale, state.panY / scale)
end
function Map.Zoom(factor)
    if not sheet or not state.w then return end
    local old = state.zoom or 1
    -- (the spot under the cursor stays under it)
    local areaScale = sheet.area:GetEffectiveScale()
    local cx, cy = GetCursorPosition()
    cx, cy = cx / areaScale, cy / areaScale
    local midX = (sheet.area:GetLeft() or 0) + (state.areaW or 0) / 2
    local midY = (sheet.area:GetTop() or 0) - (state.areaH or 0) / 2
    local scale = state.scale
    local ax = (cx - midX - (state.panX or 0)) / scale + state.w / 2
    local ay = -(cy - midY - (state.panY or 0)) / scale + state.h / 2
    -- Across levels: deep into a continent (or the world) opens the zone (or continent)
    -- under the cursor; out of a zone at its widest goes up to its continent, then the world.
    local kind = Model.MapType(state.view)
    if factor > 1 and old >= 3 and kind and kind <= 2 then
        local below = C_Map and C_Map.GetMapInfoAtPosition and select(2, pcall(C_Map.GetMapInfoAtPosition, state.view, ax / state.w, ay / state.h))
        if type(below) == "table" and below.mapID and below.mapID ~= state.view and (below.mapType == 3 or below.mapType == 2) then
            Sound("page"); Map.SetView(below.mapID); return
        end
    elseif factor < 1 and old <= 1 and kind and kind >= 2 and state.view ~= WORLD then
        local up = kind == 2 and WORLD or Model.Continent(state.view)
        if up and up ~= state.view then Sound("page"); Map.SetView(up); return end
    end
    local new = math.max(1, math.min(8, old * factor))
    if new == old then return end
    state.zoom = new
    local newScale = state.base * new
    state.panX = cx - midX - (ax - state.w / 2) * newScale
    state.panY = cy - midY + (ay - state.h / 2) * newScale
    -- (redrawn: lines keep their width on screen at any zoom)
    local t = state.time
    DrawView()
    if t then Map.SetTime(t, true) end
end

function Map.Hover()
    if not sheet or not state.drawn or not GameTooltip then return end
    local scale = sheet.art:GetEffectiveScale()
    local cx, cy = GetCursorPosition()
    local x, y = cx / scale - sheet.art:GetLeft(), sheet.art:GetTop() - cy / scale
    local reach = 10 / (state.scale or 1)
    local best, bestD
    local function Near(item)
        local shown = item.t <= (state.time or math.huge)
        if not shown then return end
        local d = (item.x - x) ^ 2 + (item.y - y) ^ 2
        if d <= reach * reach and (not bestD or d < bestD) then best, bestD = item, d end
    end
    for _, item in ipairs(state.drawnMarks or {}) do Near(item) end
    if not best then for _, item in ipairs(state.drawn) do Near(item) end end
    state.hoverDay = best and best.day or nil
    if not best then GameTooltip:Hide(); return end
    GameTooltip:SetOwner(sheet.area, "ANCHOR_CURSOR")
    if state.atlas then
        GameTooltip:SetText(best.day or "", INK[1] + 0.7, INK[2] + 0.7, INK[3] + 0.6)
        GameTooltip:AddLine("Click to open", 0.8, 0.8, 0.8)
    elseif best.mark then
        GameTooltip:SetText(Clock(best.t) .. "  " .. best.mark.text, 1, 0.9, 0.7)
    else
        local line = Clock(best.t)
        if best.stay then line = line .. "  " .. math.floor(best.stay.secs / 60 + 0.5) .. " min" end
        GameTooltip:SetText(line, 1, 0.9, 0.7)
        if best.travel then
            local how = best.travel.kind == "flight" and "Flight" or ("By " .. (best.travel.how or "ship"))
            GameTooltip:SetText(how .. "  " .. Clock(best.travel.from.t) .. " \226\128\147 " .. Clock(best.travel.to.t), 1, 0.9, 0.7)
        end
        if best.with then GameTooltip:AddLine("With " .. best.with:gsub("%-.*$", ""), 0.85, 0.85, 0.85) end
        if best.map then local name = Model.MapName(best.map); if name then GameTooltip:AddLine(name, 0.75, 0.75, 0.75) end end
    end
    GameTooltip:Show()
end

-- Layout: the paper, the title and tabs above, the map, the controls below.
local function Layout()
    local book = A.BookFrame and A.BookFrame()
    local width = math.min(980, (book and book:GetWidth() or 1000) - 70)
    local paper = A.LorePapers and A.LorePapers[PAPER]
    local height = math.min((book and book:GetHeight() or 680) - 60, width * 0.62)
    sheet:ClearAllPoints(); sheet:SetPoint("CENTER", book or UIParent, "CENTER", 0, -8)
    sheet:SetSize(width, height)
    if paper and A.LayPaperOn then A.LayPaperOn(sheet, paper, width, height) end
    local side, top, bottom = 40, 30, 22
    if paper and A.PaperRoom then local _; _, side, top, bottom = A.PaperRoom(paper, width) end
    -- (a map sheet wants a little more air than a note: never closer than this to its edges)
    side, top, bottom = math.max(side, 36), math.max(top, 28), math.max(bottom, 18)
    -- ("< 10 November >": the arrows hold the date between them; the Atlas has none)
    local arrows = not state.atlas
    sheet.prevDay:ClearAllPoints(); sheet.prevDay:SetPoint("TOPLEFT", side, -top + 4)
    sheet.title:ClearAllPoints()
    if arrows then sheet.title:SetPoint("LEFT", sheet.prevDay, "RIGHT", 8, -1) else sheet.title:SetPoint("TOPLEFT", side, -top + 4) end
    sheet.nextDay:ClearAllPoints(); sheet.nextDay:SetPoint("LEFT", sheet.title, "RIGHT", 8, 1)
    sheet.prevDay:SetShown(arrows); sheet.nextDay:SetShown(arrows)
    sheet.facts:ClearAllPoints(); sheet.facts:SetPoint("LEFT", arrows and sheet.nextDay or sheet.title, "RIGHT", 12, -1)
    sheet.close:ClearAllPoints(); sheet.close:SetPoint("TOPRIGHT", -side + 6, -top + 6)
    sheet.area:ClearAllPoints()
    sheet.area:SetPoint("TOPLEFT", side, -(top + 54)); sheet.area:SetPoint("BOTTOMRIGHT", -side, bottom + 34)
    state.areaW, state.areaH = width - side * 2, height - (top + 54) - (bottom + 34)
    -- (controls, along the bottom)
    sheet.story:ClearAllPoints(); sheet.story:SetPoint("BOTTOMLEFT", side, bottom + 6)
    sheet.hero:ClearAllPoints(); sheet.hero:SetPoint("LEFT", sheet.story, "RIGHT", 4, 0)
    sheet.play:ClearAllPoints(); sheet.play:SetPoint("LEFT", sheet.hero, "RIGHT", 18, 0)
    for i, button in ipairs(sheet.speeds) do
        button:ClearAllPoints(); button:SetPoint("LEFT", i == 1 and sheet.play or sheet.speeds[i - 1], "RIGHT", i == 1 and 8 or 3, 0)
    end
    sheet.clock:ClearAllPoints(); sheet.clock:SetPoint("BOTTOMRIGHT", -side, bottom + 10); sheet.clock:SetWidth(70); sheet.clock:SetJustifyH("RIGHT")
    sheet.track:ClearAllPoints()
    sheet.track:SetPoint("LEFT", sheet.speeds[3], "RIGHT", 14, 0); sheet.track:SetPoint("RIGHT", sheet.clock, "LEFT", -10, 0)
    sheet.tabTop, sheet.tabLeft, sheet.tabRight = top + 28, side, side
end
-- The tabs: the zones in the order you saw them, then their continents and the world.
local function Tabs()
    local list = {}
    if state.atlas then
        list[#list + 1] = {map = WORLD, label = "World"}
        for _, cont in ipairs(state.atlasContinents or {}) do list[#list + 1] = {map = cont, label = Model.MapName(cont) or "?"} end
    else
        local continents, seen = {}, {}
        for _, zone in ipairs(state.model.zones) do
            list[#list + 1] = {map = zone.map, label = zone.name or Model.MapName(zone.map) or "?", zone = true}
            local cont = Model.Continent(zone.map)
            if cont and not seen[cont] then seen[cont] = true; continents[#continents + 1] = cont end
        end
        for _, cont in ipairs(continents) do list[#list + 1] = {map = cont, label = Model.MapName(cont) or "?"} end
        list[#list + 1] = {map = WORLD, label = "World"}
    end
    local x = sheet.tabLeft
    for i, item in ipairs(list) do
        local tab = sheet.tabs[i]
        if not tab then
            tab = InkButton(sheet, "", 60, function(self) Map.SetView(self.map) end)
            sheet.tabs[i] = tab
        end
        tab.map, tab.zone = item.map, item.zone
        tab.label:SetText(item.label)
        local width = math.floor((tab.label:GetStringWidth() or 40) + 18)
        tab:SetWidth(width)
        tab:ClearAllPoints(); tab:SetPoint("TOPLEFT", sheet, "TOPLEFT", x, -sheet.tabTop)
        tab:SetShown(x + width < sheet:GetWidth() - sheet.tabRight)
        x = x + width + 4
    end
    for i = #list + 1, #sheet.tabs do sheet.tabs[i]:Hide() end
end
function Map.Controls()
    if not sheet then return end
    for _, tab in ipairs(sheet.tabs) do if tab:IsShown() then Chosen(tab, tab.map == state.view) end end
    Chosen(sheet.story, state.mode == "story"); Chosen(sheet.hero, state.mode == "hero")
    sheet.story:SetShown(not state.atlas); sheet.hero:SetShown(not state.atlas)
    sheet.play.label:SetText(state.playing and "Pause" or "Play")
    for _, button in ipairs(sheet.speeds) do Chosen(button, button.speed == state.speed) end
end
function Map.SetView(map)
    if map ~= state.view then state.zoom, state.panX, state.panY = 1, 0, 0 end
    state.view = map
    state.zoneView = false
    for _, zone in ipairs(state.model and state.model.zones or {}) do if zone.map == map then state.zoneView = true end end
    DrawView()
    Map.Controls()
end

-- Opening ------------------------------------------------------------------------------
-- The person whose book it is, the character whose road, the journal with the moments,
-- and for a companion's book their key (only the road you shared).
local function Whose(person)
    if not person or person.self then
        local me = person and person.charKey or (A.Me and A.Me())
        local self = person or (A.SelfPerson and A.SelfPerson(me))
        return me, self and self.journal or {}, nil
    end
    local me = A.Me and A.Me()
    local self = A.SelfPerson and A.SelfPerson(me)
    local key
    for k, p in pairs(A.People or {}) do if p == person then key = k end end
    return me, self and self.journal or {}, key or person.__key
end
function Map.OpenDay(person, day, touring)
    Make()
    if not touring then state.tour = nil end
    local character, journal, companion = Whose(person)
    state.atlas, state.person, state.day = false, person, day
    state.model = Model.Build(journal, day, character, companion)
    state.t0, state.t1 = state.model.t0, state.model.t1
    if state.playing then Stop() end
    EndScrub()
    state.time, state.share, state.efforts = math.huge, 1, nil
    Layout()
    Effort()
    sheet.title:SetText(Map.DayTitle(day))
    sheet.prevDay:Show(); sheet.nextDay:Show()
    sheet.prevDay:SetEnabled(Map.Neighbour(-1) ~= nil); sheet.nextDay:SetEnabled(Map.Neighbour(1) ~= nil)
    sheet.facts:SetText(state.tour and string.format("Day %d of %d", state.tour.index, #state.tour.days)
        or (state.model.recorded and "" or "No road recorded; zones only"))
    local first = state.model.zones[1]
    sheet:Show()
    Tabs()
    Map.SetView(first and first.map or WORLD)
    if A.RefreshBookmarks then A.RefreshBookmarks() end
    if A.SetPersonClassIcon and sheet.walker.icon then A.SetPersonClassIcon(sheet.walker.icon, (A.SelfPerson and A.SelfPerson(character) or {}).class) end
    Sound("page")
end
-- The tour: each day of the adventure replayed in turn, on its own zones; back to the
-- Atlas at the end.
function Map.TourDay()
    local tour = state.tour
    if not tour then return end
    Map.OpenDay(tour.person, tour.days[tour.index], true)
    state.share = 0
    Map.SetTime(TimeAt(0), true)
    Run()
end
function Map.TourNext()
    local tour = state.tour
    if not tour then return end
    tour.index = tour.index + 1
    if tour.index > #tour.days then
        state.tour = nil
        Map.OpenAtlas(tour.person)
        return
    end
    -- (a breath between two days)
    if C_Timer and C_Timer.After then C_Timer.After(0.8, function() if state.tour == tour then Map.TourDay() end end)
    else Map.TourDay() end
end
-- The day's name for the title and the arrows' hover ("10 November").
function Map.DayTitle(day)
    local y, m, d = (day or ""):match("^(%d+)%-(%d+)%-(%d+)$")
    local title = y and date and time and date("%d %B", time({year = tonumber(y), month = tonumber(m), day = tonumber(d), hour = 12}))
    return (string.gsub(title or day or "", "^0", ""))
end
-- The day before or after this one that has a map (a road or zones), or nil.
function Map.Neighbour(delta)
    if state.atlas or not state.day then return nil end
    local character, journal = Whose(state.person)
    local days = Model.Days(journal, character)
    for i, day in ipairs(days) do
        if day == state.day then return days[i + delta] end
    end
    return nil
end
-- To the next or previous day, keeping the view (Story or Hero path) and, when the new
-- day was there too, the same zone or continent.
function Map.Step(delta)
    local day = Map.Neighbour(delta)
    if not day then return end
    local keep = state.view
    Map.OpenDay(state.person, day)
    for _, tab in ipairs(sheet.tabs) do
        if tab:IsShown() and tab.map == keep and keep ~= state.view then Map.SetView(keep); break end
    end
end
-- The Atlas: the whole adventure on the world, every road, the older the fainter.
function Map.OpenAtlas(person)
    Make()
    local character, journal = Whose(person)
    state.atlas, state.person, state.atlasPerson = true, person, person
    state.atlasDays = Model.Days(journal, character)
    state.atlasModels, state.atlasTimes = {}, {}
    local continents, seen, zones, deaths, yards = {}, {}, {}, 0, 0
    -- (the journal split by day once, so each day's model reads only its own lines)
    local byDay = {}
    local DayOf = A.Road and A.Road.DayOf
    for _, e in ipairs(journal or {}) do
        if e.t and DayOf then local key = DayOf(e.t); byDay[key] = byDay[key] or {}; table.insert(byDay[key], e) end
    end
    for i, day in ipairs(state.atlasDays) do
        local model = Model.Build(byDay[day] or {}, day, character)
        state.atlasModels[i] = model
        state.atlasTimes[day] = i
        for _, zone in ipairs(model.zones) do
            zones[zone.map] = true
            local cont = Model.Continent(zone.map)
            if cont and not seen[cont] then seen[cont] = true; continents[#continents + 1] = cont end
        end
        for _, mark in ipairs(model.marks) do if mark.kind == "death" then deaths = deaths + 1 end end
        for _, piece in ipairs(model.pieces) do
            if piece.points then
                local w, h = Model.Yards(piece.map)
                for k = 2, #piece.points do
                    local a, b = piece.points[k - 1], piece.points[k]
                    yards = yards + math.sqrt(((a.x - b.x) * w) ^ 2 + ((a.y - b.y) * h) ^ 2)
                end
            end
        end
    end
    -- (the replay's clock is the day's number: one day a second at x1)
    for _, model in ipairs(state.atlasModels) do
        local index = state.atlasTimes[model.day]
        for _, piece in ipairs(model.pieces) do
            for _, p in ipairs(piece.points or {}) do p.t = index end
            if piece.from then piece.from.t, piece.to.t = index, index end
        end
        for _, stay in ipairs(model.stays) do stay.t = index end
    end
    state.atlasContinents = continents
    state.model = {zones = {}, marks = {}, pieces = {}, stays = {}}
    state.t0, state.t1 = 1, math.max(1, #state.atlasDays)
    if state.playing then Stop() end
    EndScrub()
    state.time, state.share, state.efforts = math.huge, 1, nil
    Layout()
    sheet.title:SetText("The Road")
    local zoneCount = 0
    for _ in pairs(zones) do zoneCount = zoneCount + 1 end
    sheet.facts:SetText(string.format("%d days  \194\183  %d zones  \194\183  %d leagues  \194\183  %d deaths",
        #state.atlasDays, zoneCount, math.floor(yards / 5280 + 0.5), deaths))
    sheet:Show()
    Tabs()
    Map.SetView(continents[#continents] or WORLD)
    if A.RefreshBookmarks then A.RefreshBookmarks() end
    Sound("page")
end
function Map.IsOpen() return sheet and sheet:IsShown() or false end
function Map.IsAtlas() return Map.IsOpen() and state.atlas == true end
function Map.Close() if sheet then sheet:Hide() end end

-- The map mark on a chapter's opening page: a small crest with a map, top right.
function Map.Mark(page, person, chapter)
    local day = chapter and (chapter.day and chapter.day.key)
    local shown = day and (not chapter.part or chapter.part == 1) and person and not person.npc
    if not shown then if page.roadMark then page.roadMark:Hide() end; return end
    if not page.roadMark then
        local mark = A.BookCrest and A.BookCrest(page, 22) or CreateFrame("Button", nil, page)
        mark.icon = mark.icon or mark:CreateTexture(nil, "ARTWORK")
        mark.icon:SetTexture("Interface\\Icons\\INV_Misc_Map_01")
        local hit = CreateFrame("Button", nil, mark)
        hit:SetAllPoints()
        hit:SetScript("OnClick", function() Map.OpenDay(mark.person, mark.day) end)
        hit:SetScript("OnEnter", function(self)
            if not GameTooltip then return end
            GameTooltip:SetOwner(self, "ANCHOR_LEFT"); GameTooltip:SetText("The road", 1, 0.82, 0); GameTooltip:Show()
        end)
        hit:SetScript("OnLeave", function() if GameTooltip then GameTooltip:Hide() end end)
        mark:SetFrameLevel(page:GetFrameLevel() + 20)
        page.roadMark = mark
    end
    local mark = page.roadMark
    mark.person, mark.day = person, day
    local box = page.box or {30, 34, 40, 36}
    mark:ClearAllPoints(); mark:SetPoint("TOPRIGHT", page, "TOPRIGHT", -box[3] + 4, -math.max(8, box[2] - 26))
    mark:Show()
end
