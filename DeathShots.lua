local _, A = ...
-- Deaths, remembered with a picture (2026-11-19). When you die, Frame Gambit's clean
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

-- Taking the picture: at the moment of death, when Frame Gambit can hide the interface.
-- Returns the time of the request (kept on the death line as `shot`), or nil.
function A.DeathShot()
    if not A.db or A.db.deathShots == false then return nil end
    if type(FrameGambit_CleanScreenshot) ~= "function" then return nil end
    local now = time and time() or nil
    if not pcall(FrameGambit_CleanScreenshot) then return nil end
    return now
end

-- The thumbnail for a request time: the helper's list, the nearest within NEAR seconds.
function A.ShotPath(at)
    local list = type(WowHelperShots) == "table" and WowHelperShots
    if not at or not list then return nil end
    local best, gap
    for t, path in pairs(list) do
        local d = math.abs((tonumber(t) or 0) - at)
        if d <= NEAR and (not gap or d < gap) then best, gap = path, d end
    end
    return best
end

-- Your own death lines, and one by its time.
local function MyJournal()
    local me = A.SelfPerson and A.SelfPerson()
    return me and me.journal or {}
end
function A.DeathEntry(t)
    for _, e in ipairs(MyJournal()) do
        if e.k == "death" and e.t and math.abs(e.t - t) <= 2 then return e end
    end
    return nil
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
-- the frame it opens over (the book or the map).
function A.OpenDeathCard(death, owner)
    if not death then return end
    local entry = death.k == "death" and death or (death.t and A.DeathEntry(death.t)) or death
    Make()
    local width, height = 440, 300
    card:SetParent(owner or UIParent)
    card:SetFrameStrata("FULLSCREEN_DIALOG")
    card:ClearAllPoints(); card:SetPoint("CENTER", owner or UIParent, "CENTER", 0, 0)
    card:SetSize(width, height)
    local paper = A.LorePapers and A.LorePapers[PAPER]
    if paper and A.LayPaperOn then A.LayPaperOn(card, paper, width, height) end
    -- (the cause, in the book's words: "Fell to a vampiric duskbat")
    local killer = entry.d
    local cause = killer and ("Fell to " .. (entry.a and "a " or "") .. killer)
        or (entry.env == "FALLING" and "Fell from a height") or (entry.env == "DROWNING" and "Drowned")
        or (entry.env == "FIRE" or entry.env == "LAVA") and "Burned" or (death.text) or "Fell"
    card.title:SetText(cause)
    local when = entry.t and date and date("%H:%M", entry.t) or ""
    local where = entry.sz and entry.z and entry.sz ~= entry.z and (entry.sz .. ", " .. entry.z) or entry.z or ""
    card.sub:SetText(when .. (where ~= "" and ("  \194\183  " .. where) or ""))
    card.title:ClearAllPoints(); card.title:SetPoint("TOP", 0, -30); card.title:SetWidth(width - 70)
    card.sub:ClearAllPoints(); card.sub:SetPoint("TOP", card.title, "BOTTOM", 0, -6)
    -- The picture: a 2:1 thumbnail in a thin ink frame, or a quiet line when there is none.
    local pw, ph = 340, 170
    card.frame:ClearAllPoints(); card.frame:SetPoint("TOP", card.sub, "BOTTOM", 0, -14); card.frame:SetSize(pw + 2, ph + 2)
    card.picture:ClearAllPoints(); card.picture:SetPoint("CENTER", card.frame, "CENTER"); card.picture:SetSize(pw, ph)
    local path = A.ShotPath(entry.shot)
    card.picture:SetShown(path ~= nil); card.frame:SetShown(path ~= nil)
    if path then card.picture:SetTexture(path) end
    card.none:ClearAllPoints(); card.none:SetPoint("TOP", card.sub, "BOTTOM", 0, -40)
    card.none:SetShown(path == nil)
    card.none:SetText(entry.shot and "The picture shows after a restart" or "No picture")
    card:SetSize(width, path and (ph + 120) or 150)
    if paper and A.LayPaperOn then A.LayPaperOn(card, paper, width, card:GetHeight()) end
    card.close:ClearAllPoints(); card.close:SetPoint("TOPRIGHT", -26, -20)
    card:Show(); card:Raise()
end
function A.CloseDeathCard() if card then card:Hide() end end

-- Links in a chapter: each death of the day (yours, with a known killer) makes the first
-- unlinked mention of its killer a link to its card, in order. Text already in a link or
-- in a name's markup is left alone.
function A.DeathLinks(text, day)
    if type(text) ~= "string" or not day then return text end
    local deaths = {}
    for _, scene in ipairs(day.scenes or {}) do
        for _, e in ipairs(scene.entries or {}) do
            if e.k == "death" and (e.w == nil or e.w == "you") and type(e.d) == "string" and e.d ~= "" and e.t then
                deaths[#deaths + 1] = e
            end
        end
    end
    table.sort(deaths, function(a, b) return a.t < b.t end)
    local from = 1
    for _, e in ipairs(deaths) do
        local lower, name = text:lower(), e.d:lower()
        local at = lower:find(name, from, true)
        while at do
            -- (not inside {n:...} markup or an existing |H...|h link)
            local before = text:sub(1, at - 1)
            local open = before:match(".*()%{") or 0
            local shut = before:match(".*()%}") or 0
            local hopen = before:match(".*()|H") or 0
            local hshut = before:match(".*()|h|r|h") or before:match(".*()|r|h") or 0
            if open <= shut and hopen <= hshut then break end
            at = lower:find(name, at + 1, true)
        end
        if at then
            local stop = at + #name - 1
            local link = "|Hcjdeath:" .. e.t .. "|h|cff7d1c0a" .. text:sub(at, stop) .. "|r|h"
            text = text:sub(1, at - 1) .. link .. text:sub(stop + 1)
            from = at + #link
        end
    end
    return text
end
