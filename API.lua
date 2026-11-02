local _, A = ...
-- What other addons can ask Companion Journal (Forever Names uses it to draw
-- your people's names and icons on its labels). Version 1.
-- A "person" is an opaque value: pass it back to these functions only.
local api = {version = 1}
local CIRCLES = {companion = true, acquaintance = true, campfire = true, npc = true, rival = true, blocked = true}

-- Any in-world feature on (display names, icons, tooltip, last seen). While
-- false, callers need not look anyone up.
function api.Active()
    local db = A.db
    return db ~= nil and db.enabled and A.PeopleActive() and true or false
end
-- The person for a unit (players and NPCs in your list, or in your other
-- characters' lists while they are recognized), or nil.
function api.Find(unit)
    local db = A.db
    if not db or not db.enabled then return nil end
    return (A.FindPerson(unit))
end
-- The unit's plate showed them: last seen, the journal's crossed paths, and
-- (with a unit) their class and level.
function api.Seen(person, unit)
    if person and A.db and A.db.enabled then A.NotePersonSeen(person, unit) end
end
-- Their display name, when renaming is on and they have one.
function api.DisplayName(person)
    local db = A.db
    if db and db.peopleRename and person and person.display and person.display ~= "" then return person.display end
    return nil
end
-- Their icon while icons are on: texture path, color {r, g, b}, color mode
-- ("custom", "class" or "name"), own size (nil = automatic), own side
-- ("left", "right", or nil = with the other icons). Nil when they have none.
function api.Icon(person)
    local db = A.db
    if not (db and db.peopleIcons and person) then return nil end
    local glyph = A.IconGlyph("people", person)
    if glyph == "none" then return nil end
    local side = db.peopleIconPosition
    return A.GlyphPath(glyph), A.IconColor("people", person), A.IconColorMode("people", person),
        tonumber(person.iconSize), (side == "left" or side == "right") and side or nil
end
-- Called whenever your people or these options change.
function api.Subscribe(fn) A.Subscribe(fn) end
-- The caller's plates changed hands (for example Forever Names' settings):
-- redraw our icons beside Blizzard's names.
function api.RefreshPlates() if A.RefreshPlateIcons then A.RefreshPlateIcons() end end
-- Open the window: at a person (key or unit token), a category, or the list.
function api.Open(target)
    if not A.options or not A.db then return end
    A.OpenOptions()
    if type(target) ~= "string" then return end
    if A.People[target] or #A.OtherKnowers(target) > 0 then
        A.SelectPerson(target)
    elseif CIRCLES[target] then
        A.SelectPeopleCircle(target)
    else
        local person, key = A.FindPerson(target)
        if person and key then A.SelectPerson(key) end
    end
end
-- Their journal: a name ("Name" or "Name-Realm"), or your target.
function api.OpenJournal(name)
    local key
    if type(name) == "string" and name ~= "" then key = A.PersonKey(name) else local _, found = A.FindPerson("target"); key = found end
    if key and A.db and (A.People[key] or #A.OtherJournals(key) > 0) then A.OpenJournal(key); return true end
    return false
end
-- Add your target (a player, or an NPC), with an optional note.
function api.AddTarget(note) return A.AddTargetPerson(note) end

CompanionJournalAPI = api
