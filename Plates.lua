local _, A = ...
-- Your people on Blizzard's nameplates: a small icon beside Blizzard's name.
-- Plates that Forever Names labels get the icon on its label instead, so the
-- two never double up. Nothing is registered while icons are off, and each
-- plate gets one small frame, made the first time someone from your list
-- shows on it.
local function Public(value) return not issecretvalue or not issecretvalue(value) end
local marks = {}   -- plate -> {holder, texture}
-- unit -> the person from your list on that plate, or false (looked up once per
-- arrival and whenever your list changes, not on every name update)
local tracked = {}
local events = CreateFrame("Frame")
local hooked = false

local function PlateFor(unit)
    if not C_NamePlate or not C_NamePlate.GetNamePlateForUnit then return nil end
    local ok, plate = pcall(C_NamePlate.GetNamePlateForUnit, unit)
    if not ok or not plate or (plate.IsForbidden and plate:IsForbidden()) then return nil end
    return plate
end
local function Hide(plate)
    local mark = plate and marks[plate]
    if mark then mark.texture:Hide() end
end

-- Their own color, their class color, or the color of Blizzard's name.
local function Tint(person, unit, name)
    local mode = A.IconColorMode("people", person)
    if mode == "class" then
        local color = A.UnitClassColor(unit)
        if color then return color end
    elseif mode == "name" and name.GetTextColor then
        local ok, r, g, b = pcall(name.GetTextColor, name)
        if ok and Public(r) and Public(g) and Public(b) and type(r) == "number" then return {r, g, b} end
    end
    return A.IconColor("people", person)
end

local function Lookup(unit)
    local db = A.db
    if not db or not db.enabled or not db.peopleIcons or next(db.people) == nil then return false end
    return (A.FindPerson(unit)) or false
end

local function Update(unit)
    local person = tracked[unit]
    local plate = PlateFor(unit)
    if not plate then return end
    if not person then Hide(plate); return end
    local db = A.db
    local frame = plate.UnitFrame
    local name = frame and frame.name
    local names = A.Names()
    if not (db and db.enabled and db.peopleIcons and name) or (names and names.OwnsUnit and names.OwnsUnit(unit)) then
        Hide(plate)
        return
    end
    local glyph = A.IconGlyph("people", person)
    local ok, shown = pcall(name.IsShown, name)
    if not person or glyph == "none" or not ok or shown ~= true then Hide(plate); return end
    local mark = marks[plate]
    if not mark then
        -- A sibling of Blizzard's unit frame (like Forever Names' labels):
        -- it follows the plate's position, scale and fade.
        local holder = CreateFrame("Frame", nil, plate)
        holder:SetAllPoints(plate)
        holder:EnableMouse(false)
        mark = {holder = holder, texture = holder:CreateTexture(nil, "OVERLAY")}
        marks[plate] = mark
    end
    local texture = mark.texture
    local size = tonumber(person.iconSize) or A.DefaultIconSize(person)
    local path = A.GlyphPath(glyph)
    if texture.path ~= path then texture.path = path; texture:SetTexture(path) end
    local tint = Tint(person, unit, name)
    texture:SetVertexColor(tint[1], tint[2], tint[3])
    texture:SetSize(size, size)
    texture:ClearAllPoints()
    if db.peopleIconPosition == "right" then texture:SetPoint("LEFT", name, "RIGHT", 3, 0)
    else texture:SetPoint("RIGHT", name, "LEFT", -3, 0) end
    texture:Show()
end

function A.RefreshPlateIcons()
    for unit in pairs(tracked) do
        tracked[unit] = Lookup(unit)
        Update(unit)
    end
end

events:SetScript("OnEvent", function(_, event, unit)
    if type(unit) ~= "string" then return end
    if event == "NAME_PLATE_UNIT_ADDED" then
        tracked[unit] = Lookup(unit)
        if tracked[unit] then Update(unit) else Hide(PlateFor(unit)) end
    elseif event == "NAME_PLATE_UNIT_REMOVED" then
        tracked[unit] = nil
        Hide(PlateFor(unit))
    end
end)

-- Icons on: follow plates as they come and go (and pick up the ones in view).
function A.UpdatePlateEvents()
    local db = A.db
    if db and db.enabled and db.peopleIcons then
        events:RegisterEvent("NAME_PLATE_UNIT_ADDED")
        events:RegisterEvent("NAME_PLATE_UNIT_REMOVED")
        -- Blizzard shows or hides its name (target, settings): follow it.
        if not hooked and hooksecurefunc and CompactUnitFrame_UpdateName then
            hooked = true
            hooksecurefunc("CompactUnitFrame_UpdateName", function(frame)
                local frameUnit = frame and frame.unit
                -- Most plates are not in your list: one table read.
                if type(frameUnit) == "string" and tracked[frameUnit] then Update(frameUnit) end
            end)
        end
        A.EachTrackedUnit(function(unit) tracked[unit] = false end)
        A.RefreshPlateIcons()
    else
        events:UnregisterEvent("NAME_PLATE_UNIT_ADDED")
        events:UnregisterEvent("NAME_PLATE_UNIT_REMOVED")
        for plate in pairs(marks) do Hide(plate) end
        tracked = {}
    end
end
