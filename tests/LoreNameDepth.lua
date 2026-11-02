-- Run from client root: lua Interface/AddOns/CompanionJournal/tests/LoreNameDepth.lua
local root = "Interface/AddOns/CompanionJournal/"
local A = {db = {sentinel = "unchanged"}}
assert(loadfile(root .. "LoreNotes.lua"))("CompanionJournal", A)
-- Cross-references may now lead into the supplementary world biographies.
for _, file in ipairs({"LorePlaces.lua", "LorePeopleHistory.lua", "LoreWorldConnections.lua"}) do
    assert(loadfile(root .. file))("CompanionJournal", A)
end
local count = 0
local function Check(value, label) count = count + 1; assert(value, label) end
-- Every new canonical name and alias is listed independently of the registry.
local names = {
    ["place:fenris-isle"] = {"Fenris Isle"},
    ["place:fenris-keep"] = {"Fenris Keep"},
    ["place:lordamere"] = {"Lordamere Lake", "Lake Lordamere"},
    ["place:decrepit-ferry"] = {"The Decrepit Ferry", "Decrepit Ferry"},
    ["place:pyrewood"] = {"Pyrewood Village", "Pyrewood"},
    ["place:ambermill"] = {"Ambermill"},
    ["place:deep-elem"] = {"Deep Elem Mine", "the Deep Elem Mine"},
    ["place:dead-fields"] = {"The Dead Fields", "Dead Fields"},
    ["place:skittering-dark"] = {"The Skittering Dark", "Skittering Dark"},
    ["npc:hadrec"] = {"High Executor Hadrec", "Hadrec", "Executor Hadrec"},
    ["npc:renferrel"] = {"Apothecary Renferrel", "Renferrel"},
    ["npc:thule"] = {"Thule Ravenclaw", "Thule"},
    ["npc:bethor"] = {"Bethor Iceshard", "Bethor"},
    ["npc:alaric"] = {"Alaric"},
    ["npc:rane"] = {"Rane Yorick", "Rane"},
    ["npc:quinn"] = {"Quinn Yorick", "Quinn"},
    ["npc:ivar"] = {"Ivar the Foul"},
    ["npc:grimson"] = {"Grimson the Pale", "Grimson"},
    ["npc:berard"] = {"Apothecary Berard", "Berard"},
    ["npc:faranell"] = {"Master Apothecary Faranell", "Apothecary Faranell", "Faranell"},
    ["place:agamand-mills"] = {"Agamand Mills", "the Agamand Mills"},
    ["place:agamand-crypt"] = {"Agamand Family Crypt", "the Agamand Family Crypt", "Agamand Crypt"},
    ["place:balnir"] = {"Balnir Farmstead"},
    ["place:bulwark"] = {"The Bulwark", "Bulwark"},
    ["place:garrens-haunt"] = {"Garren's Haunt"},
    ["place:mass-graves"] = {"The Mass Graves", "Mass Graves"},
    ["place:brightwater"] = {"Brightwater Lake"},
    ["place:solliden"] = {"Solliden Farmstead"},
    ["npc:sevren"] = {"Magistrate Sevren", "Sevren"},
    ["npc:zygand"] = {"Executor Zygand", "Zygand"},
    ["npc:johaan"] = {"Apothecary Johaan", "Johaan"},
    ["npc:dargol"] = {"Captain Dargol", "Dargol"},
    ["place:northshire"] = {"Northshire", "Northshire Valley"},
    ["place:goldshire"] = {"Goldshire"},
    ["npc:dughan"] = {"Marshal Dughan", "Dughan"},
    ["place:fargodeep"] = {"Fargodeep Mine", "the Fargodeep Mine"},
    ["place:sentinel-hill"] = {"Sentinel Hill"},
    ["npc:stoutmantle"] = {"Gryan Stoutmantle", "Stoutmantle"},
    ["place:coldridge"] = {"Coldridge Valley"},
    ["place:anvilmar"] = {"Anvilmar"},
    ["place:thelsamar"] = {"Thelsamar"},
    ["place:ironbands-excavation"] = {"Ironband's Excavation"},
    ["place:shadowglen"] = {"Shadowglen"},
    ["npc:tarindrella"] = {"Tarindrella"},
    ["place:dolanaar"] = {"Dolanaar"},
    ["place:banethil"] = {"Ban'ethil Barrow Den", "Ban'ethil"},
    ["place:grove-ancients"] = {"Grove of the Ancients", "the Grove of the Ancients"},
    ["npc:onu"] = {"Onu"},
    ["place:narache"] = {"Camp Narache", "Narache"},
    ["place:red-cloud"] = {"Red Cloud Mesa"},
    ["place:bloodhoof"] = {"Bloodhoof Village"},
    ["npc:baine"] = {"Baine Bloodhoof", "Baine"},
    ["place:valley-trials"] = {"Valley of Trials", "the Valley of Trials"},
    ["place:senjin"] = {"Sen'jin Village", "Sen'jin"},
    ["npc:gadrin"] = {"Master Gadrin", "Gadrin"},
    ["place:echo-isles"] = {"Echo Isles", "the Echo Isles"},
    ["place:razor-hill"] = {"Razor Hill"},
    ["npc:garthok"] = {"Gar'Thok"},
    ["place:skull-rock"] = {"Skull Rock"},
    ["npc:margoz"] = {"Margoz"},
    ["place:ratchet"] = {"Ratchet"},
    ["npc:dizzywig"] = {"Wharfmaster Dizzywig", "Dizzywig"},
    ["place:pools-vision"] = {"Pools of Vision", "the Pools of Vision"},
    ["npc:zamah"] = {"Apothecary Zamah", "Zamah"},
    ["place:kharanos"] = {"Kharanos"},
    ["place:crossroads"] = {"The Crossroads", "Crossroads"},
    ["npc:cairne"] = {"Cairne Bloodhoof", "Cairne"},
    ["place:southshore"] = {"Southshore"},
    ["place:tarren-mill"] = {"Tarren Mill"},
    ["place:lights-hope"] = {"Light's Hope Chapel", "the Light's Hope Chapel"},
}
local entries, aliases = 0, 0
for id, list in pairs(names) do
    entries = entries + 1
    local note = A.GetLoreNote(id)
    Check(note and note.coverage == "curated", "reviewed note: " .. id)
    local sourceText = table.concat(note.sources, "\n")
    Check(sourceText:find("corpus_vanilla_quests.txt", 1, true)
        and (sourceText:find("#%d+") or sourceText:find("quests? %d+")), "exact captured quest source: " .. id)
    Check(note.setting == "Classic / Forever", "chronology: " .. id)
    Check(not note.body:find("{[pqn]:") and not note.body:find("|H"), "plain context: " .. id)
    Check(not note.body:lower():find("you ") and not note.body:find("quest completed"), "no invented player action: " .. id)
    Check(note.after == nil and note.qid == nil, "not a recorded quest outcome: " .. id)
    for _, related in ipairs(note.related or {}) do
        Check(A.GetLoreNote(related), "related note exists: " .. related)
    end
    for _, name in ipairs(list) do
        aliases = aliases + 1
        Check(A.LoreNoteResolve("p", name) == id, "place/name markup resolves: " .. name)
        Check(A.LoreNoteResolve("p", "  " .. name:upper() .. "  ") == id, "normalized alias: " .. name)
        if id:match("^npc:") then Check(A.LoreNoteResolve("n", name) == id, "NPC markup resolves: " .. name) end
        Check(A.LoreNoteLink(name, id):find("|Hcjlore:" .. id .. "|h", 1, true), "clickable note: " .. name)
        Check(A.LoreNoteResolve("q", name) == nil, "world name cannot imply a quest: " .. name)
    end
end
Check(entries == 70, "all 70 new notes covered")
Check(A.LoreNoteResolve("p", "Fenris") == nil, "ambiguous shortened place is not guessed")
Check(A.LoreNoteResolve("p", "Keep") == nil, "generic noun stays unlinked")
Check(A.LoreNoteResolve("p", "Bloodhoof") == nil, "family name does not imply village or person")
Check(A.LoreNoteResolve("p", "Garren’s Haunt") == "place:garrens-haunt", "curly apostrophe")
Check(A.GetLoreNote("place:fenris-isle").body:find("defeated") == nil, "Fenris has no quest victory")
Check(A.db.sentinel == "unchanged" and next(A.db, "sentinel") == nil, "opening references is read-only")
local plain = "Baine Bloodhoof watched Bloodhoof Village; Fenris Isle lay beyond Lordamere Lake."
local marked = "{n:Baine Bloodhoof} watched {p:Bloodhoof Village}; {p:Fenris Isle} lay beyond {p:Lordamere Lake}."
Check(A.MarkKnownLore(plain) == marked, "unmarked full people/place names gain markup")
Check(A.MarkKnownLore(marked) == marked, "annotation is idempotent")
Check(plain == "Baine Bloodhoof watched Bloodhoof Village; Fenris Isle lay beyond Lordamere Lake.", "source text unchanged")
Check(A.MarkKnownLore("Baine and the Keep in Fenris; Ambermill.") == "Baine and the Keep in Fenris; {p:Ambermill}.", "canonical settlement links, ambiguous short names stay plain")
Check(A.MarkKnownLore("Weaver and Cookie waited by the Keep.") == "Weaver and Cookie waited by the Keep.", "common words are not inferred as bosses")
Check(A.MarkKnownLore("baine bloodhoof and fenris isle") == "baine bloodhoof and fenris isle", "automatic names require original case")
Check(A.MarkKnownLore("NotFenris Isle Fenris Isles _Fenris Isle Fenris Isle_") == "NotFenris Isle Fenris Isles _Fenris Isle Fenris Isle_", "whole-word boundaries")
Check(A.MarkKnownLore("(Fenris Isle), Baine Bloodhoof's report.") == "({p:Fenris Isle}), {n:Baine Bloodhoof}'s report.", "punctuation and possessives")
Check(A.MarkKnownLore("The Decrepit Ferry") == "{p:The Decrepit Ferry}", "longest overlapping name wins")
Check(A.MarkKnownLore("{q:Assault on Fenris Isle} {n:Baine Bloodhoof} {anything Fenris Isle}") == "{q:Assault on Fenris Isle} {n:Baine Bloodhoof} {anything Fenris Isle}", "all existing brace spans opaque")
local native = "|Hitem:123|h[Fenris Isle / Baine Bloodhoof]|h"
Check(A.MarkKnownLore(native .. " Fenris Isle") == native .. " {p:Fenris Isle}", "native hyperlink label opaque, subsequent name works")
Check(A.MarkKnownLore("|Hbroken:Fenris Isle") == "|Hbroken:Fenris Isle", "incomplete native link preserved")
Check(A.MarkKnownLore("{unfinished Fenris Isle") == "{unfinished Fenris Isle", "incomplete brace span preserved")
Check(A.MarkKnownLore(nil) == nil and A.MarkKnownLore(12) == 12 and A.MarkKnownLore("") == "", "non-text and empty input preserved")
Check(A.MarkKnownLore("A Recipe For Death") == "A Recipe For Death", "quest title not auto-marked")
Check(A.db.sentinel == "unchanged" and next(A.db, "sentinel") == nil, "annotation is read-only")
print("LoreNameDepth: " .. count .. " checks passed; " .. entries .. " notes, " .. aliases .. " names/aliases")
