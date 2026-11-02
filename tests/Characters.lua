-- Run from the client root: lua Interface/AddOns/CompanionJournal/tests/Characters.lua
-- Per-character lists: the list from before moves to the first character who
-- logs in (journal lines marked with another character go to them; players
-- of the other side wait for that side); each character has their own people
-- and journals over shared cards; other characters' people are recognized
-- (rivals only on their side) and can be imported; NPCs are shared unless
-- "this character only"; another character's journal is read only.
local root = "Interface/AddOns/CompanionJournal/"
local assertions = 0
local function check(value, message) assertions = assertions + 1; assert(value, message) end
local function equal(a, b, message) check(a == b, message .. " (got " .. tostring(a) .. ", expected " .. tostring(b) .. ")") end

local methods = {}
local function Object()
    local object = {scripts = {}, events = {}}
    return setmetatable(object, {__index = function(_, key)
        if methods[key] then return methods[key] end
        if type(key) == "string" and key:match("^[A-Z]") then return function(self) return self end end
    end})
end
function methods:SetScript(key, fn) self.scripts[key] = fn end
function methods:RegisterEvent(event) self.events[event] = true end
function methods:UnregisterEvent(event) self.events[event] = nil end
function CreateFrame() return Object() end
UIParent = Object()
local clock = 1790000000
function time() return clock end
function GetTime() return clock end
function date(fmt, t) return os.date(fmt, t or clock) end
function GetRealZoneText() return "Tirisfal Glades" end
function GetNormalizedRealmName() return "Forever" end
function GetRealmName() return "Forever" end
C_Timer = {After = function(_, fn) fn() end}
function IsInInstance() return false, "none" end
print = function() end

-- Who you are right now, and the units around you.
local player = {}
local units = {}
function UnitName(unit)
    if unit == "player" then return player.name end
    return units[unit] and units[unit].name
end
function UnitFullName(unit) local u = units[unit]; if u then return u.name, u.realm or "Forever" end end
function UnitFactionGroup(unit)
    if unit == "player" then return player.faction end
    return units[unit] and units[unit].faction
end
function UnitClass(unit)
    if unit == "player" then return player.class, player.class end
    return units[unit] and units[unit].class, units[unit] and units[unit].class
end
function UnitRace(unit)
    if unit == "player" then return player.race, player.race end
    return units[unit] and units[unit].race, units[unit] and units[unit].race
end
function UnitLevel(unit) return unit == "player" and 20 or (units[unit] and units[unit].level or 0) end
function UnitIsPlayer(unit) return unit == "player" or (units[unit] ~= nil and not units[unit].npc) end
function UnitGUID(unit) local u = units[unit]; return u and u.npc and ("Creature-0-1-1-1-" .. u.npc .. "-abc") or nil end

-- The saved list from before 1.3: one list for everyone.
local db = {enabled = true, peopleJournal = true, colors = {people = {1, 1, 1}, groupmate = {0.5, 0.8, 1}},
    people = {
        ["dahlia-noir"] = {name = "Dahlia-Noir", faction = "Horde", class = "WARLOCK", race = "Scourge", glyph = "heart",
            iconSize = 18, note = "My wife", met = 1789000000, metZone = "Tirisfal Glades", origin = "together", bond = "spouse",
            journal = {
                {k = "group", t = 1789000100, e = 1789003000, z = "Tirisfal Glades"},
                {k = "quest", d = "The Mills Overrun", t = 1789001000, z = "Tirisfal Glades"},
                {k = "custom", d = "Mime's line", t = 1789002000, z = "Undercity", by = "Mime"},
            }},
        ["pox-plagueheart"] = {name = "Pox-Plagueheart", circle = "acquaintance", faction = "Horde", glyph = "party",
            met = 1789100000, metZone = "Tirisfal Glades"},
        ["sir-shiny"] = {name = "Sir-Shiny", circle = "rival", faction = "Alliance", glyph = "swords"},
        ["lia-dawn"] = {name = "Lia-Dawn", faction = "Alliance", glyph = "star", note = "Alliance friend"},
        ["npc:246152"] = {name = "Shari Stilwell", npc = true, note = "Cool trainer", glyph = "diamond"},
    }}

-- A login: the addon loads fresh with the same saved list.
local A
local function Login(name, faction, class, race)
    player = {name = name, faction = faction, class = class, race = race}
    A = {defaults = {colors = {}}}
    for _, file in ipairs({"People.lua", "Characters.lua", "Journal.lua"}) do
        assert(loadfile(root .. file))("CompanionJournal", A)
    end
    A.Refresh = function() end
    for key, value in pairs(A.defaults) do if db[key] == nil then db[key] = value end end
    A.db = db
    A.InitPeople()
    A.InitCharacters()
    return A
end
local function Count(iterator)
    local n = 0
    for _ in iterator do n = n + 1 end
    return n
end

-- 1. The first login (Alberich) takes the list; lines Mime wrote go to Mime;
-- the Alliance friend waits for the Alliance side; the rival stays (a rival
-- of the Horde side); the NPC stays everyone's.
Login("Alberich", "Horde", "PALADIN", "Scourge")
equal(db.charactersFirst, "alberich-forever", "the list from before went to the first character")
check(A.movedToCharacter, "and the login says so")
local alberich = db.characters["alberich-forever"]
check(alberich and alberich.faction == "Horde" and alberich.class == "PALADIN" and alberich.race == "Scourge", "the character's name, side, class, race")
local dahlia = A.People["dahlia-noir"]
check(dahlia, "Dahlia is Alberich's")
equal(#dahlia.journal, 2, "Alberich's journal with her")
equal(dahlia.bond, "spouse", "how it began and the bond are Alberich's")
equal(dahlia.note, "My wife", "the card: note")
equal(dahlia.glyph, "heart", "the card: icon")
check(db.people["dahlia-noir"].journal == nil and db.people["dahlia-noir"].bond == nil and db.people["dahlia-noir"].met == nil,
    "the card keeps no relationship fields")
equal(#db.characters["mime-forever"].people["dahlia-noir"].journal, 1, "Mime's line went to Mime")
check(dahlia.journal[1].by == nil and db.characters["mime-forever"].people["dahlia-noir"].journal[1].by == nil, "the marks are dropped")
check(A.People["sir-shiny"] and A.People["sir-shiny"].circle == "rival", "the rival stays with the Horde character")
check(A.People["lia-dawn"] == nil, "the Alliance friend is not Alberich's")
check(db.characters["~alliance"].people["lia-dawn"], "they wait with the Alliance side (from before)")
check(A.People["npc:246152"], "the NPC is everyone's")
equal(Count(A.EachPerson()), 4, "Alberich's list: Dahlia, Pox, the rival, the NPC")
-- A second login of the same character moves nothing again.
Login("Alberich", "Horde", "PALADIN", "Scourge")
check(not A.movedToCharacter, "moving in happens once")
equal(#A.People["dahlia-noir"].journal, 2, "nothing doubled")

-- 2. The views write where each field belongs.
dahlia = A.People["dahlia-noir"]
dahlia.display = "Dahlia"
dahlia.retell = 2
equal(db.people["dahlia-noir"].display, "Dahlia", "a display name is on the card")
equal(alberich.people["dahlia-noir"].retell, 2, "a retelling is Alberich's")
check(A.People["dahlia-noir"] == dahlia, "the same view each time (journal and plate caches)")

-- 3. NPCs: this character only.
A.SetNPCOnlyHere(A.People["npc:246152"], true)
equal(db.people["npc:246152"].only, "alberich-forever", "marked for Alberich")

-- 4. Mime (Horde): their own list; Alberich's people recognized; the NPC hidden.
Login("Mime", "Horde", "MAGE", "Scourge")
check(not A.movedToCharacter, "nothing moves for the second character")
check(A.People["dahlia-noir"] and A.People["dahlia-noir"].journal and #A.People["dahlia-noir"].journal == 1,
    "Mime knew Dahlia from the marked line")
A.RemovePerson("dahlia-noir")
check(A.People["dahlia-noir"] == nil, "removed from Mime's list")
check(db.people["dahlia-noir"] and alberich.people["dahlia-noir"], "the card and Alberich's journal stay")
check(A.People["npc:246152"] == nil, "Alberich's trainer is hidden for Mime")
equal(Count(A.EachPerson()), 0, "Mime's list is empty")
units.nameplate1 = {name = "Dahlia", realm = "Noir", faction = "Horde", class = "WARLOCK", level = 22}
local seenAs = A.FindPerson("nameplate1")
check(seenAs and seenAs.recognizedBy == "Alberich", "Dahlia is recognized as Alberich's")
equal(A.RecognizedLabel(seenAs), "Alberich's companion", "the tooltip line")
equal(seenAs.glyph, "kin", "a chain link, not her own icon")
check(seenAs.color == db.colors.recognizedCompanion, "gold: a companion of another character")
equal(db.people["dahlia-noir"].glyph, "heart", "her own icon is untouched")
check(seenAs.journal == nil and seenAs.bond == nil, "Alberich's journal and story fields stay his")
A.NotePersonSeen(seenAs, "nameplate1")
equal(#alberich.people["dahlia-noir"].journal, 2, "crossing paths writes nothing into Alberich's journal")
check(A.JournalAdd(seenAs, {k = "custom", d = "x"}) == nil, "nothing can be written through a recognized view")
equal(db.people["dahlia-noir"].level, 22, "her level is on the shared card")
units.nameplate2 = {name = "Sir", realm = "Shiny", faction = "Alliance", class = "PALADIN"}
check(A.FindPerson("nameplate2") and A.FindPerson("nameplate2").circle == "rival", "Alberich's rival is Mime's side's rival too")
check(A.FindPerson("nameplate2").color == db.colors.recognizedRival, "red: a rival marked on your side")
db.peopleRecognize = false
check(A.FindPerson("nameplate1") == nil, "recognizing turned off: each character's world is their own")
db.peopleRecognize = true

-- 5. Import: the card comes along, the journal starts fresh; companions at once.
local rows = A.OthersPeople()
local byKey = {}
for _, row in ipairs(rows) do byKey[row.key] = row end
check(byKey["dahlia-noir"] and byKey["dahlia-noir"].usable, "Dahlia can be added")
check(byKey["sir-shiny"] and byKey["sir-shiny"].usable, "a rival of your side can be added")
check(byKey["lia-dawn"] and not byKey["lia-dawn"].usable, "an Alliance friend stays on their side")
check(rows[#rows].key == "lia-dawn", "the other side at the end")
local added = A.ImportFrom(nil)
equal(added, 1, "all companions: Dahlia only (not the rival, not the other side)")
local imported = A.People["dahlia-noir"]
check(imported and imported.circle == nil and imported.journal == nil, "a companion, with a fresh journal")
equal(imported.glyph, "heart", "her icon came along")
equal(imported.display, "Dahlia", "and her display name")
check(imported.bond == nil and imported.retell == nil, "the bond is Alberich's to set, not Mime's")
A.JournalAdd(imported, {k = "custom", d = "Mime and Dahlia"})
equal(#imported.journal, 1, "Mime's own journal with her")
equal(#alberich.people["dahlia-noir"].journal, 2, "Alberich's is untouched")
local rival = A.ImportPerson("sir-shiny")
check(rival and rival.circle == "rival", "the rival stays a rival on the same side")
local withJournals = A.OtherJournals("dahlia-noir")
check(#withJournals == 1 and withJournals[1].name == "Alberich", "Alberich keeps a journal with her")
local read = A.PersonAs("dahlia-noir", "alberich-forever")
check(read.readOnly and #read.journal == 2 and read.bond == "spouse", "Alberich's journal, to read")
read.bond = "friend"
check(A.JournalAdd(read, {k = "custom", d = "x"}) == nil and alberich.people["dahlia-noir"].bond == "spouse" and #alberich.people["dahlia-noir"].journal == 2,
    "read only: nothing written")
local hero = A.CharacterPlayer("alberich-forever")
check(hero.name == "Alberich" and hero.race == "Scourge" and hero.class == "PALADIN", "told as Alberich hears it")

-- 6. Neige (Alliance): the Alliance friend is hers to take; Horde rivals are not rivals here.
Login("Neige", "Alliance", "PRIEST", "Human")
local neigeRows = {}
for _, row in ipairs(A.OthersPeople()) do neigeRows[row.key] = row end
-- The Alliance friend who waited for the Alliance side joined her list at login.
check(A.People["lia-dawn"] and A.claimedWaiting == 1, "the first Alliance character takes who waited for that side")
check(db.characters["~alliance"] == nil, "and nobody waits any more")
check(neigeRows["sir-shiny"] and neigeRows["sir-shiny"].usable, "the Horde side's rival, met on the Alliance side, can be added")
check(A.Recognize("sir-shiny") and A.Recognize("sir-shiny").color == db.colors.recognizedRival, "and still wears the red link")
check(A.Recognize("dahlia-noir") and A.Recognize("dahlia-noir").recognizedBy, "a Horde companion is still recognized (their icon)")
local oldRival = A.ImportPerson("sir-shiny")
equal(oldRival and oldRival.circle, "acquaintance", "an old rival of your own side comes in as an acquaintance")
equal(A.People["lia-dawn"].note, "Alliance friend", "with her note")
for _, character in ipairs(A.OtherCharacters()) do check(not character.earlier, "no waiting list left") end

-- 6b. Which links show: gold over red over silver; campfire people: nothing.
Login("Mime", "Horde", "MAGE", "Scourge")
local alberichPeople = db.characters["alberich-forever"].people
local function Known(key, circles)
    db.people[key] = {name = key, faction = "Horde"}
    for charKey, circle in pairs(circles) do
        db.characters[charKey] = db.characters[charKey] or {name = charKey, faction = "Horde", people = {}}
        db.characters[charKey].people[key] = {circle = circle ~= "companion" and circle or nil}
    end
end
db.characters["agonie-forever"] = {name = "Agonie", faction = "Horde", people = {}}
Known("fire-forever", {["alberich-forever"] = "campfire"})
check(A.Recognize("fire-forever") == nil, "campfire people: nothing")
Known("acq-forever", {["alberich-forever"] = "acquaintance"})
check(A.Recognize("acq-forever").color == db.colors.recognizedAcquaintance, "silver: an acquaintance")
Known("both-forever", {["alberich-forever"] = "companion", ["agonie-forever"] = "acquaintance"})
check(A.Recognize("both-forever").color == db.colors.recognizedCompanion, "companion on one, acquaintance on another: gold")
Known("feud-forever", {["alberich-forever"] = "acquaintance", ["agonie-forever"] = "rival"})
check(A.Recognize("feud-forever").color == db.colors.recognizedRival, "rival over acquaintance: red")
Known("mixed-forever", {["alberich-forever"] = "rival", ["agonie-forever"] = "companion"})
check(A.Recognize("mixed-forever").color == db.colors.recognizedCompanion, "companion over rival: gold")
local listed = {}
for _, row in ipairs(A.OthersPeople()) do listed[row.key] = true end
check(not listed["fire-forever"] and listed["acq-forever"], "My characters lists the same people: no campfire")
for _, key in ipairs({"fire-forever", "acq-forever", "both-forever", "feud-forever", "mixed-forever"}) do
    db.people[key] = nil
    alberichPeople[key] = nil
end
db.characters["agonie-forever"] = nil

-- 7. Adding someone by hand who another character knows keeps their card.
Login("Mime", "Horde", "MAGE", "Scourge")
A.RemovePerson("dahlia-noir")
local again = A.AddPerson("Dahlia-Noir")
equal(again.glyph, "heart", "added by hand: her icon is kept")
check(again.circle == nil, "as a companion")
-- An NPC added again by another character is everyone's again.
local npc = A.AddNPCPerson(246152, "Shari Stilwell")
check(npc and db.people["npc:246152"].only == nil, "added on Mime: the trainer is everyone's again")
equal(npc.note, "Cool trainer", "the note kept")

-- 8. Removing from every character removes the card.
A.RemovePerson("dahlia-noir")
Login("Alberich", "Horde", "PALADIN", "Scourge")
A.RemovePerson("dahlia-noir")
check(db.people["dahlia-noir"] == nil, "nobody knows her: the card goes too")

-- 9. The list from before on the wrong character: moved to the right one.
db = {enabled = true, colors = {people = {1, 1, 1}}, people = {
    ["kael-forever"] = {name = "Kael-Forever", faction = "Horde", journal = {{k = "quest", d = "A", t = 1}}},
    ["brom-forever"] = {name = "Brom-Forever", faction = "Horde"},
}}
Login("Agonie", "Horde", "WARLOCK", "Orc")
equal(db.charactersFirst, "agonie-forever", "the list went to Agonie")
Login("Alberich", "Horde", "PALADIN", "Scourge")
A.AddPerson("Zed")
equal(A.MoveListHere("agonie-forever"), 2, "moved to Alberich")
check(A.People["kael-forever"] and #A.People["kael-forever"].journal == 1, "with the journal")
check(next(db.characters["agonie-forever"].people) == nil, "Agonie keeps nothing she did not have")
equal(db.charactersFirst, "alberich-forever", "and the list is now Alberich's")

-- 10. People copied in later (Forever Names, 1.9 and earlier) move in too.
db.people["late-forever"] = {name = "Late-Forever", faction = "Horde", circle = "acquaintance", met = 5}
Login("Alberich", "Horde", "PALADIN", "Scourge")
check(A.People["late-forever"] and A.People["late-forever"].circle == "acquaintance" and db.people["late-forever"].circle == nil,
    "a copied entry becomes this character's")

-- 11. Without a character name (tests, very early loading): one shared list.
player = {}
A = {defaults = {colors = {}}}
for _, file in ipairs({"People.lua", "Characters.lua"}) do assert(loadfile(root .. file))("CompanionJournal", A) end
A.Refresh = function() end
A.db = {people = {["x-forever"] = {name = "X-Forever", journal = {}}}, colors = {}}
A.InitPeople(); A.InitCharacters()
check(A.People["x-forever"] == A.db.people["x-forever"] and A.db.characters == nil, "shared list until a character is known")

-- 12. Early in loading the game calls you "Unknown": never a character.
player = {name = "Unknown", faction = "Horde"}
A = {defaults = {colors = {}}}
for _, file in ipairs({"People.lua", "Characters.lua"}) do assert(loadfile(root .. file))("CompanionJournal", A) end
A.Refresh = function() end
A.db = {people = {}, colors = {}}
A.InitPeople(); A.InitCharacters()
check(A.Me() == nil and A.db.characters == nil, "\"Unknown\" is not a character")

-- 13. A list 1.3.0 filed under "Unknown" (with Neige's name) is Neige's; the
-- Horde players waiting go to the first Horde character (Alberich), journals included.
db = {enabled = true, colors = {people = {1, 1, 1}}, charactersFirst = "unknown-forever",
    people = {
        ["glow-forever"] = {name = "Glow-Forever", faction = "Horde"},
        ["dahlia-noir"] = {name = "Dahlia-Noir", faction = "Horde"},
        ["npc:1"] = {name = "Trainer", npc = true, only = "unknown-forever"},
    },
    characters = {
        ["unknown-forever"] = {name = "Neige", faction = "Alliance", people = {
            ["glow-forever"] = {circle = "acquaintance", journal = {{k = "quest", d = "Old", t = 10}}}}},
        ["neige-forever"] = {name = "Neige", faction = "Alliance", people = {
            ["glow-forever"] = {circle = "acquaintance", journal = {{k = "quest", d = "New", t = 20}}}}},
        ["~horde"] = {name = "Horde (from before)", faction = "Horde", earlier = true, people = {
            ["dahlia-noir"] = {circle = "companion", journal = {{k = "group", t = 5}, {k = "quest", d = "Q", t = 6}}}}},
    }}
Login("Neige", "Alliance", "PRIEST", "Human")
equal(db.characters["unknown-forever"], nil, "the \"Unknown\" list is gone")
equal(#A.People["glow-forever"].journal, 2, "its journal lines joined Neige's")
equal(A.People["glow-forever"].journal[1].d, "Old", "in time order")
equal(db.charactersFirst, "neige-forever", "the list from before is Neige's")
equal(db.people["npc:1"].only, "neige-forever", "an NPC kept for that character is Neige's")
equal(A.CharacterName("~horde"), "Next Horde character", "who waits for the Horde side is named plainly")
check(db.characters["~horde"], "the Horde players still wait on the Alliance side")
Login("Alberich", "Horde", "PALADIN", "Scourge")
check(A.People["dahlia-noir"] and #A.People["dahlia-noir"].journal == 2, "Alberich takes them, with the journal")
equal(A.claimedWaiting, 1, "and the login says so")
equal(db.characters["~horde"], nil, "nobody waits any more")
Login("Neige", "Alliance", "PRIEST", "Human")
local byAlberich = A.OtherJournals("dahlia-noir")
equal(byAlberich[1] and byAlberich[1].name, "Alberich", "on Neige, Dahlia's journal is Alberich's")

-- 14. A player whose side was never recorded: the side of your characters who
-- know them, when they agree (you only group with your side).
db = {enabled = true, colors = {people = {1, 1, 1}},
    people = {
        ["glow-forever"] = {name = "Glow-Forever"},
        ["both-forever"] = {name = "Both-Forever"},
    },
    characters = {
        ["alberich-forever"] = {name = "Alberich", faction = "Horde", people = {
            ["glow-forever"] = {circle = "acquaintance"}, ["both-forever"] = {circle = "acquaintance"}}},
        ["eerith-forever"] = {name = "Eerith", faction = "Alliance", people = {["both-forever"] = {circle = "acquaintance"}}},
    }}
Login("Neige", "Alliance", "PRIEST", "Human")
equal(db.people["glow-forever"].faction, "Horde", "known only by Horde characters: Horde")
equal(db.people["both-forever"].faction, nil, "known on both sides: still unknown")
local glowRow
for _, row in ipairs(A.OthersPeople()) do if row.key == "glow-forever" then glowRow = row end end
check(glowRow and not glowRow.usable, "a Horde player cannot be added on Neige")

io.write("PASS: " .. assertions .. " per-character assertions\n")
