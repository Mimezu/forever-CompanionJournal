-- Run from the client root: lua5.1 Interface/AddOns/CompanionJournal/tests/SelfRelationships.lua
-- Use the real per-character person views: shared-card fixtures hid the bug
-- where the personal storyteller could not see a spouse or a shared beginning.
local root = "Interface/AddOns/CompanionJournal/"
local assertions = 0
local function check(value, message) assertions = assertions + 1; assert(value, message) end
function time(t) return t and os.time(t) or 1791749955 end
function date(fmt, t) return os.date(fmt, t) end
local A = {defaults = {colors = {}}}
for _, file in ipairs({"Characters.lua", "LoreData.lua", "Lore.lua", "JournalBook.lua", "JournalSelfWords.lua", "JournalSelfTale.lua"}) do
    assert(loadfile(root .. file))("CompanionJournal", A)
end
local loggedIn = "alberich"
A.Me = function() return loggedIn end
local start = os.time({year = 2026, month = 9, day = 27, hour = 19})
local function Life(owner, startLevel, reunion)
    local journal = {}
    for _, day in ipairs(reunion and {0, 28} or {0}) do
        local t = start + day * 86400
        journal[#journal + 1] = {k = "play", t = t, e = t + 3600, z = "Tirisfal Glades", pl = startLevel}
        -- Seeded journals can lack level data and split company across regrouping.
        journal[#journal + 1] = {k = "with", t = t, e = t + 1800, d = "dahlia", n = "Dahlia-Noir"}
        journal[#journal + 1] = {k = "with", t = t + 1802, e = t + 3600, d = "dahlia", n = "Dahlia-Noir"}
        journal[#journal + 1] = {k = "quest", t = t + 2000, z = "Tirisfal Glades", d = "The Mindless Ones"}
    end
    return {self = true, charKey = owner, name = owner, race = "Scourge", faction = "Horde", startLevel = startLevel, journal = journal}
end
local function Tell(p, brief, retell)
    local days = A.JournalBook(p)
    local stories = A.SelfTale.Tell(p, days, brief, retell)
    local result = {}
    for _, day in ipairs(days) do result[#result + 1] = A.JournalPlain(stories[day.key].text) end
    return result
end
local card = {name = "Dahlia-Noir", class = "WARLOCK", pronouns = "she"}
A.db = {people = {dahlia = card}, characters = {
    alberich = {people = {dahlia = {bond = "spouse", origin = "together"}}},
    other = {people = {dahlia = {}}},
}}
for _, brief in ipairs({false, true}) do
    for retell = 0, 7 do
        -- The journal's owner determines the bond even when an alt is reading it.
        loggedIn = "other"
        local first = Tell(Life("alberich", 1), brief, retell)[1]
        check(first:find("Dahlia, my wife, and I rose together at Deathknell.", 1, true) == 1,
            "the owner's shared beginning opens their personal journal: " .. first)
        check(not first:find("a warlock", 1, true), "a wife is not introduced again as a stranger: " .. first)
        check(first == Tell(Life("alberich", 1), brief, retell)[1], "the telling is repeatable")

        loggedIn = "alberich"
        local other = Tell(Life("other", 1), brief, retell)[1]
        check(not other:find("my wife", 1, true) and not other:find("rose together", 1, true),
            "another character's journal must not borrow the reader's marriage: " .. other)
        local later = Tell(Life("alberich", 15, true), brief, retell)
        check(later[1]:find("my wife", 1, true), "a late-starting journal still introduces the spouse: " .. later[1])
        check(not later[1]:find("rose together", 1, true), "a later beginning does not invent an origin scene")
        check(later[2]:find("my wife", 1, true), "a reunion knows the owner's bond: " .. later[2])
    end
end
check(card.bond == nil and card.origin == nil, "telling does not copy relationships onto the shared card")
check(A.db.characters.alberich.people.dahlia.bond == "spouse", "the saved relationship is preserved")

-- Re-render the same already-built days after live edits, with the same Retell
-- seed. The words follow today's settings; the recorded events stay intact.
local p = Life("alberich", 1)
local days = A.JournalBook(p)
local function Current()
    return A.JournalPlain(A.SelfTale.Tell(p, days, false, 3)[days[1].key].text)
end
for _, choice in ipairs({{"they", "my spouse"}, {"he", "my husband"}, {"she", "my wife"}}) do
    card.pronouns = choice[1]
    local text = Current()
    check(text:find(choice[2], 1, true), "pronoun changes apply without Retell: " .. text)
    if choice[1] == "they" then
        check(not text:find("wife", 1, true) and not text:find("husband", 1, true), "They uses a neutral spouse word")
    end
end
card.display = "Beloved Dahlia"
check(Current():find("Beloved Dahlia, my wife", 1, true), "display name edits apply to existing stories")
card.display = nil
check(not Current():find("Beloved Dahlia", 1, true), "clearing the display name restores the recorded name")
A.db.characters.alberich.people.dahlia.origin = nil
check(not Current():find("rose together", 1, true) and Current():find("my wife", 1, true), "removing Together keeps the spouse bond")
A.db.characters.alberich.people.dahlia.origin = "together"
for _, pronouns in ipairs({"they", "she", "he"}) do
    card.pronouns = pronouns
    A.db.characters.alberich.people.dahlia.bond = "partner"
    check(Current():find("my partner", 1, true), "Partner is supported for every pronoun")
end
A.db.characters.alberich.people.dahlia.bond = nil
check(not Current():find("my partner", 1, true) and not Current():find("my wife", 1, true), "clearing the bond removes its words")
A.db.characters.alberich.people.dahlia.bond = "spouse"
card.pronouns = "she"
check(Current():find("Dahlia, my wife, and I rose together at Deathknell.", 1, true) == 1, "restoring the settings restores the opening")
check(p.journal[2].n == "Dahlia-Noir" and p.retell == nil, "settings edits do not alter recorded names or the Retell seed")

-- A migrated shared card cannot override an explicit unbonded relationship.
card.bond, card.origin = "spouse", "together"
local other = Tell(Life("other", 1), false, 0)[1]
check(not other:find("my wife", 1, true), "character-specific fields take precedence over old shared fields")

-- Pre-migration data still uses the shared card.
A.db.characters = nil
check(Tell(Life("alberich", 1), false, 0)[1]:find("Dahlia, my wife, and I rose together at Deathknell.", 1, true) == 1,
    "legacy shared relationships still work")
io.write("PASS: " .. assertions .. " personal relationship assertions\n")
