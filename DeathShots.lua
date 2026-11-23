local _, A = ...
-- Deaths and levels, remembered with a picture (2026-11-19; levels 2026-11-20). When you die, Frame Gambit's clean
-- screenshot (no interface, for one frame) is taken; WoW Helper turns new screenshots
-- into thumbnails in its data addon (WowHelperData\Shots\, listed in WowHelperShots by
-- the screenshot's time). A death's card, opened from its X on the Road's map or from its
-- link in the chapter, shows the cause, the hour, the place and that thumbnail.
-- WoW finds addon files that existed when it started: a picture taken today shows after
-- the next restart; until then the card says so.

A.defaults.deathShots = true -- (needs Frame Gambit; WoW Helper makes the thumbnails)

local INK, SOFT, RED = {0.20, 0.11, 0.04}, {0.36, 0.22, 0.08}, {0.42, 0.10, 0.04}
local PAPER = "paper3"
local NEAR = 10 -- seconds between the request and a screenshot that is its picture

-- Taking the picture: at the moment (a death, a level), when Frame Gambit can hide the
-- interface. Returns the time of the request (kept on the line as `shot`), or nil.
function A.MomentShot()
    if not A.db or A.db.deathShots == false then return nil end
    if type(FrameGambit_CleanScreenshot) ~= "function" then return nil end
    local now = time and time() or nil
    if not pcall(FrameGambit_CleanScreenshot) then return nil end
    return now
end

-- The helper's entry nearest a request time, within NEAR seconds.
local function Nearest(list, at)
    if not at or type(list) ~= "table" then return nil end
    local best, gap
    for t, value in pairs(list) do
        local d = math.abs((tonumber(t) or 0) - at)
        if d <= NEAR and (not gap or d < gap) then best, gap = value, d end
    end
    return best
end
-- The thumbnail for a request time (512x256, the centre 2:1).
function A.ShotPath(at) return Nearest(WowHelperShots, at) end
-- The large copy for the card: the whole picture in the top-left of a 2048x1024 texture.
-- -> path, the width and height it fills (texcoords), or nil.
function A.ShotLarge(at)
    local e = Nearest(WowHelperShotsLarge, at)
    if type(e) ~= "table" or type(e[1]) ~= "string" then return nil end
    local u, v = tonumber(e[2]) or 1, tonumber(e[3]) or 1
    if u <= 0 or v <= 0 then return nil end
    return e[1], u, v
end

A.DeathShot = A.MomentShot

-- Your own moments with a card (deaths, levels), and one by its time.
local function MyJournal()
    local me = A.SelfPerson and A.SelfPerson()
    return me and me.journal or {}
end
local CARDS = {death = true, mylevel = true}
function A.DeathEntry(t)
    for _, e in ipairs(MyJournal()) do
        if CARDS[e.k] and e.t and math.abs(e.t - t) <= 2 then return e end
    end
    return nil
end
-- The picture of a moment by its time (the small photo in a chapter), or nil.
function A.MomentPicture(t)
    local e = t and A.DeathEntry(t)
    return e and A.ShotPath(e.shot)
end

-- The card -------------------------------------------------------------------------------
local card
local function Text(parent, font, color, justify)
    local fs = parent:CreateFontString(nil, "OVERLAY", font)
    fs:SetTextColor(color[1], color[2], color[3]); fs:SetJustifyH(justify or "CENTER")
    if fs.SetShadowOffset then fs:SetShadowOffset(0, 0) end
    return fs
end
local function Make()
    if card then return end
    card = CreateFrame("Button", "CompanionJournalDeathCard", UIParent)
    card:SetFrameStrata("FULLSCREEN_DIALOG"); card:SetToplevel(true); card:EnableMouse(true)
    if UISpecialFrames then table.insert(UISpecialFrames, "CompanionJournalDeathCard") end
    card:SetScript("OnClick", function(self) self:Hide() end)
    card:Hide()
    card.title = Text(card, "GameFontNormalLarge", RED)
    if A.BookTitleFont and A.BookTitleFont(20) then card.title:SetFontObject(A.BookTitleFont(20)) end
    card.sub = Text(card, "GameFontNormalSmall", SOFT)
    card.frame = card:CreateTexture(nil, "ARTWORK", nil, 1)
    card.frame:SetColorTexture(INK[1], INK[2], INK[3], 0.55)
    card.picture = card:CreateTexture(nil, "ARTWORK", nil, 2)
    card.none = Text(card, "GameFontNormalSmall", SOFT)
    card.close = CreateFrame("Button", nil, card)
    card.close:SetSize(20, 20)
    card.close.label = Text(card.close, "GameFontNormalSmall", INK)
    card.close.label:SetPoint("CENTER"); card.close.label:SetText("\195\151")
    card.close:SetScript("OnClick", function() card:Hide() end)
end
-- Open a death's card: `death` is a journal line (or a map mark with its time), `owner`
-- the frame it opens over (the book or the map). With a picture it is as large as the
-- Atlas map, the whole screenshot over the paper (2026-11-22); without, a small card.
function A.OpenDeathCard(death, owner)
    if not death then return end
    local entry = CARDS[death.k] and death or (death.t and A.DeathEntry(death.t)) or death
    Make()
    card:SetParent(owner or UIParent)
    card:SetFrameStrata("FULLSCREEN_DIALOG")
    card:ClearAllPoints(); card:SetPoint("CENTER", owner or UIParent, "CENTER", 0, -8)
    -- (the cause, in the book's words: "Fell to a vampiric duskbat")
    local killer = entry.d
    local cause = entry.k == "mylevel" and ("Level " .. tostring(entry.d))
        or killer and ("Fell to " .. (entry.a and "a " or "") .. killer)
        or (entry.env == "FALLING" and "Fell from a height") or (entry.env == "DROWNING" and "Drowned")
        or (entry.env == "FIRE" or entry.env == "LAVA") and "Burned" or (death.text) or "Fell"
    card.title:SetText(cause)
    local when = entry.t and date and date("%H:%M", entry.t) or ""
    local where = entry.sz and entry.z and entry.sz ~= entry.z and (entry.sz .. ", " .. entry.z) or entry.z or ""
    card.sub:SetText(when .. (where ~= "" and ("  \194\183  " .. where) or ""))
    -- The picture: the large copy (its own shape), else the 2:1 thumbnail, else a quiet line.
    local large, u, v = A.ShotLarge(entry.shot)
    local path = large or A.ShotPath(entry.shot)
    local width, height = 440, 150
    if path and A.MapSheetSize then width, height = A.MapSheetSize() end
    local paper = A.LorePapers and A.LorePapers[PAPER]
    local side, top, bottom = 40, 30, 22
    if paper and A.PaperRoom then local _; _, side, top, bottom = A.PaperRoom(paper, width) end
    side, top, bottom = math.max(side, 36), math.max(top, 28), math.max(bottom, 18)
    card:SetSize(width, height)
    if paper and A.LayPaperOn then A.LayPaperOn(card, paper, width, height) end
    card.title:ClearAllPoints(); card.title:SetPoint("TOP", 0, -top + 4); card.title:SetWidth(width - 2 * side - 40)
    card.sub:ClearAllPoints(); card.sub:SetPoint("TOP", card.title, "BOTTOM", 0, -4)
    card.picture:SetShown(path ~= nil); card.frame:SetShown(path ~= nil)
    if path then
        local aspect = large and (u * 2048) / (v * 1024) or 2
        local room = height - top - bottom - 54
        local pw = math.min(width - 2 * side, room * aspect)
        local ph = pw / aspect
        card.frame:ClearAllPoints(); card.frame:SetPoint("TOP", card.sub, "BOTTOM", 0, -10); card.frame:SetSize(pw + 2, ph + 2)
        card.picture:ClearAllPoints(); card.picture:SetPoint("CENTER", card.frame, "CENTER"); card.picture:SetSize(pw, ph)
        card.picture:SetTexture(path)
        card.picture:SetTexCoord(0, large and u or 1, 0, large and v or 1)
    end
    card.none:ClearAllPoints(); card.none:SetPoint("TOP", card.sub, "BOTTOM", 0, -16)
    card.none:SetShown(path == nil)
    card.none:SetText(entry.shot and "The picture shows after a restart" or "No picture")
    card.close:ClearAllPoints(); card.close:SetPoint("TOPRIGHT", -side + 14, -top + 6)
    card:Show(); card:Raise()
end

-- Links in a chapter: each death of the day (yours, with a known killer) makes the first
-- unlinked mention of its killer a link to its card, in order; each level with a picture,
-- the first "level N". Text already in a link or in a name's markup is left alone.
-- (1.54.0: where each mark starts in the text, found once per death instead of searching all
-- the text before every match again; a chapter took up to 150 ms)
local function Starts(text, mark)
    local list, at = {}, text:find(mark, 1, true)
    while at do list[#list + 1] = at; at = text:find(mark, at + 1, true) end
    return list
end
-- (the last start of a mark that ends before `limit`, or 0)
local function LastBefore(list, size, limit)
    local best = 0
    for _, at in ipairs(list) do
        if at + size - 1 < limit then best = at else break end
    end
    return best
end
local linkCache, linkCacheSize = {}, 0
function A.DeathLinks(text, day)
    if type(text) ~= "string" or not day then return text end
    local deaths = {}
    for _, scene in ipairs(day.scenes or {}) do
        for _, e in ipairs(scene.entries or {}) do
            if e.k == "death" and (e.w == nil or e.w == "you") and type(e.d) == "string" and e.d ~= "" and e.t then
                deaths[#deaths + 1] = {t = e.t, name = e.d:lower()}
            elseif e.k == "mylevel" and e.shot and e.d and e.t then
                deaths[#deaths + 1] = {t = e.t, name = "level " .. tostring(e.d), whole = true}
            end
        end
    end
    if #deaths == 0 then return text end
    table.sort(deaths, function(a, b) return a.t < b.t end)
    -- (the same text and the same deaths give the same links: kept, for redraws)
    local sig = {}
    for i, e in ipairs(deaths) do sig[i] = e.t .. "=" .. e.name end
    local cacheKey = table.concat(sig, "\1") .. "\2" .. text
    if linkCache[cacheKey] then return linkCache[cacheKey] end
    local from = 1
    for _, e in ipairs(deaths) do
        local lower, name = text:lower(), e.name
        local at = lower:find(name, from, true)
        local opens, shuts, hopens, hshuts, rshuts
        while at do
            -- (not inside {n:...} markup or an existing |H...|h link)
            if not opens then
                opens, shuts, hopens = Starts(text, "{"), Starts(text, "}"), Starts(text, "|H")
                hshuts, rshuts = Starts(text, "|h|r|h"), Starts(text, "|r|h")
            end
            local open = LastBefore(opens, 1, at)
            local shut = LastBefore(shuts, 1, at)
            local hopen = LastBefore(hopens, 2, at)
            local hshut = LastBefore(hshuts, 6, at)
            if hshut == 0 then hshut = LastBefore(rshuts, 4, at) end
            -- ("level 2" is not the start of "level 21")
            local whole = not e.whole or not lower:sub(at + #name, at + #name):match("%d")
            if whole and open <= shut and hopen <= hshut then break end
            at = lower:find(name, at + 1, true)
        end
        if at then
            local stop = at + #name - 1
            local link = "|Hcjdeath:" .. e.t .. "|h|cff7d1c0a" .. text:sub(at, stop) .. "|r|h"
            text = text:sub(1, at - 1) .. link .. text:sub(stop + 1)
            from = at + #link
        end
    end
    if linkCacheSize >= 200 then linkCache, linkCacheSize = {}, 0 end
    linkCache[cacheKey], linkCacheSize = text, linkCacheSize + 1
    return text
end
