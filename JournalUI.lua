local _, A = ...
-- What the book (JournalBookUI.lua) shares with the rest of the addon: the
-- reading choices, a person's one-line summary and class icon, and the ways in
-- to someone's journal. The book is the only window.

A.defaults.journalStyle = "b"
A.defaults.journalMode = "all"
A.defaults.journalVoice = "story"
local STYLES = {"a", "b", "c", "d", "e"}
function A.JournalStyle()
    local style = A.db and A.db.journalStyle
    for _, known in ipairs(STYLES) do if style == known then return style end end
    return "a"
end
-- Everything or Highlights; and, separately, Simple (the plain prose) or Story.
function A.JournalMode()
    local db = A.db
    if db and db.journalMode == "story" then db.journalMode, db.journalVoice = "all", "story" end -- 1.2.0 test builds
    return db and db.journalMode == "highlights" and "highlights" or "all"
end
function A.JournalVoice()
    return A.db and A.db.journalVoice == "story" and "story" or "simple"
end

local function ClassName(class)
    return class and ((LOCALIZED_CLASS_NAMES_MALE and LOCALIZED_CLASS_NAMES_MALE[class])
        or (class:sub(1, 1) .. class:sub(2):lower())) or nil
end
function A.PersonSummary(person)
    local parts = {}
    if person.level then parts[#parts + 1] = (LEVEL or "Level") .. " " .. person.level end
    local class = ClassName(person.class)
    if class then
        if #parts > 0 then parts[#parts] = parts[#parts] .. " " .. class else parts[1] = class end
    end
    if person.faction then parts[#parts + 1] = person.faction end
    return table.concat(parts, "  -  ")
end
function A.SetPersonClassIcon(texture, class)
    local atlas = class and GetClassAtlas and GetClassAtlas(class:lower())
    if atlas and C_Texture and C_Texture.GetAtlasInfo and C_Texture.GetAtlasInfo(atlas) then
        texture:SetAtlas(atlas); texture:Show()
    else
        texture:Hide()
    end
end

-- Open someone's journal in the book: yours by default, or charKey's (read
-- only). Someone only your other characters know opens their journal.
function A.OpenJournal(key, charKey)
    if A.OpenBook then A.OpenBook(key, charKey) end
end
-- Your own journal (or another character's, read only).
function A.OpenSelfJournal(charKey)
    charKey = charKey or (A.Me and A.Me())
    if not charKey or not A.SelfPerson or not A.SelfPerson(charKey) then return end
    if A.OpenBook then A.OpenBook("self:" .. charKey) end
end
