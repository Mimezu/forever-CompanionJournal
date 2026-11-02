local _, A = ...
-- Your people's icons: small single-color glyphs (the same set as Forever
-- Names), each person with their own glyph, color and size.
local GLYPH_PATH = "Interface\\AddOns\\CompanionJournal\\Media\\Glyphs\\"
A.glyphs = {"heart", "star", "sparkle", "diamond", "dot", "ring", "crown", "shield", "person",
    "party", "flower", "moon", "sun", "leaf", "flag", "check", "note", "fire", "swords"}
-- Not for your own people: "kin" marks someone another character of yours knows.
A.glyphsReserved = {"kin"}
function A.GlyphPath(name) return GLYPH_PATH .. (name or "dot") end
local function Public(value) return not issecretvalue or not issecretvalue(value) end

-- The key is always "people" here (kept for Forever Names' call shape).
function A.IconGlyph(_, person)
    return person and (person.glyph or A.PersonDefaultGlyph(person)) or "heart"
end
function A.IconColor(_, person)
    return person and (person.color or A.PersonDefaultColor(person)) or A.db.colors.people
end
-- "custom" (their own color), "class", or "name" (the name's color).
function A.IconColorMode(_, person)
    return person and person.colorMode or "custom"
end

-- Class colors for players only (NPC "classes" say nothing useful).
local classColors = {}
function A.UnitClassColor(unit)
    local okPlayer, player = pcall(UnitIsPlayer, unit)
    if not okPlayer or not Public(player) or player ~= true then return nil end
    local ok, _, classFile = pcall(UnitClass, unit)
    if not ok or not Public(classFile) or type(classFile) ~= "string" then return nil end
    local cached = classColors[classFile]
    if cached == nil then
        local class = RAID_CLASS_COLORS and RAID_CLASS_COLORS[classFile]
        cached = class and {class.r, class.g, class.b} or false
        classColors[classFile] = cached
    end
    return cached or nil
end

-- Palette with the two follow-the-player choices, for one person.
function A.PickIconColor(_, anchor, person)
    if not person then return end
    local mode = A.IconColorMode("people", person)
    local original = A.IconColor("people", person)
    original = {original[1], original[2], original[3]}
    local hadOwn = person.color ~= nil
    local function SetMode(value) person.colorMode = value ~= "custom" and value or nil end
    A.PickColor(anchor, original[1], original[2], original[3],
        function(r, g, b) person.color = {r, g, b}; SetMode("custom"); A.Refresh() end,
        function() person.color = hadOwn and original or nil; SetMode(mode); A.Refresh() end,
        {current = mode, set = function(value) SetMode(value); A.Refresh() end})
end

-- The automatic icon size: Forever Names' (the name's height) when it is
-- installed, otherwise about the height of Blizzard's nameplate names.
function A.DefaultIconSize(person)
    local names = A.Names()
    local size = names and names.IconSize and names.IconSize(person and person.npc)
    return tonumber(size) or 14
end
