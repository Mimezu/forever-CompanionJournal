-- Runtime coverage contract: names used by the storyteller must open a note.
-- Run from the client root with lua5.1. Never reads or writes SavedVariables.
local root = "Interface/AddOns/CompanionJournal/"
local A = {db = {sentinel = "unchanged"}}
local checks, failures = 0, {}
local function Check(ok, why)
    checks = checks + 1
    if not ok then failures[#failures + 1] = why end
end
local function Load(file) assert(loadfile(root .. file))("CompanionJournal", A) end
for _, file in ipairs({"LoreData.lua", "Lore.lua", "LoreHordeStories.lua", "LoreAllianceStories.lua",
    "LoreWorldStories.lua", "LoreClassStories.lua", "LoreNotes.lua", "LorePlaces.lua",
    "LorePeopleHistory.lua", "LoreWorldConnections.lua", "JournalSelfWords.lua"}) do Load(file) end
local inventory = {}
local function Named(name, kind)
    local id = A.LoreNoteResolve(kind or "p", name)
    local note = id and A.GetLoreNote(id)
    Check(note and note.body ~= "" and #note.sources > 0, "unresolved name: " .. name)
    if note then Check(A.LoreNoteLink(name, id):find("|Hcjlore:" .. id .. "|h", 1, true), "missing link: " .. name) end
end
for _, field in ipairs({"zones", "dungeons", "bosses"}) do
    local count = 0
    for name in pairs(A.Lore[field]) do
        Named(name)
        if field == "bosses" then Named(name, "n") end
        count = count + 1
    end
    inventory[field] = count
end
local towns = 0
for name, entry in pairs(A.SelfWords.towns) do
    Named(name)
    for display in entry.name:gmatch("{p:([^}]+)}") do Named(display) end
    towns = towns + 1
end
local literalNames = {}
for _, file in ipairs({"Lore.lua", "JournalSelfWords.lua", "JournalWords.lua", "LoreHordeStories.lua",
    "LoreAllianceStories.lua", "LoreWorldStories.lua", "LoreClassStories.lua"}) do
    local handle = assert(io.open(root .. file, "r"))
    for line in handle:lines() do
        if not line:match("^%s*%-%-") then
            for kind, name in line:gmatch("{([pn]):([^}]+)}") do
                -- Runtime concatenation is not a literal world name.
                if not name:find('"', 1, true) and name ~= "Name" then literalNames[kind .. ":" .. name] = {kind, name} end
            end
        end
    end
    handle:close()
end
local literalCount = 0
for _, item in pairs(literalNames) do Named(item[2], item[1]); literalCount = literalCount + 1 end
-- Independent reference families: these must survive future catalogue edits.
for _, name in ipairs({"Alliance", "Horde", "Forsaken", "Scourge", "Argent Dawn", "Cenarion Circle",
    "Earthen Ring", "Kirin Tor", "Burning Legion", "Royal Apothecary Society", "Explorers' League",
    "SI:7", "Old Gods", "Titans", "Highborne", "Dragonflights", "League of Arathor", "The Defilers",
    "Warsong Gulch", "Alterac Valley", "Arathi Basin", "Kalimdor", "Eastern Kingdoms", "Emerald Dream",
    "Twisting Nether", "First War", "Second War", "Third War", "War of the Ancients",
    "War of the Three Hammers", "War of the Shifting Sands", "Battle of Darrowshire", "Great Sundering",
    "Culling of Stratholme", "Ahn'Qiraj War Effort", "Gates of Ahn'Qiraj", "Scourge Invasion",
    "Darkmoon Faire", "Sargeras", "Archimonde", "Kil'jaeden", "Mannoroth", "Illidan", "Lothar",
    "Turalyon", "Khadgar", "King Llane", "Deathwing", "Alexstrasza", "Nozdormu", "Ysera", "Malygos",
    "Dalaran", "Gilneas", "Greymane Wall"}) do Named(name) end
local curated, kinds = 0, {}
for _, entry in ipairs(A.LoreNoteCatalog()) do
    if entry.kind ~= "Quest" then
        curated = curated + 1
        kinds[entry.kind] = (kinds[entry.kind] or 0) + 1
        Check(A.LoreNoteResolve("p", entry.title) == entry.id, "canonical collision: " .. entry.title .. " / " .. entry.id)
        for _, name in ipairs(entry.names or {}) do
            Check(A.LoreNoteResolve("p", name) == entry.id, "alias collision: " .. name .. " / " .. entry.id)
        end
        for _, related in ipairs(entry.related or {}) do
            Check(A.GetLoreNote(related), "broken related note: " .. entry.id .. " -> " .. related)
        end
        Check(entry.setting == "Classic / Forever" or entry.setting == "Forever", "timeline missing: " .. entry.id)
        Check(not entry.body:find("|H", 1, true), "embedded link in body: " .. entry.id)
    end
end
for _, name in ipairs({"Gnomeregan", "Maraudon", "Naxxramas", "Scholomance", "Stratholme", "Uldaman",
    "Ambermill", "Auberdine", "Astranaar", "Gadgetzan", "Everlook"}) do
    Check(A.MarkKnownLore(name) ~= name, "canonical world name not annotated: " .. name)
end
Check(A.MarkKnownLore("Weaver and Cookie waited by the Keep.") == "Weaver and Cookie waited by the Keep.", "ordinary words became bosses")
local native = "|Hitem:1|h[Booty Bay]|h"
Check(A.MarkKnownLore(native) == native, "native item link changed")
local marked = A.MarkKnownLore("Auberdine and Booty Bay; Argent Dawn and the Scourge.")
Check(A.MarkKnownLore(marked) == marked, "repeated rendering nested markup")
Load("JournalBook.lua")
A.bookLinks = {thrall = "my-companion"}
Check(A.JournalColored("{n:Thrall}"):find("|Hcjperson:my-companion|h", 1, true), "world name stole a companion link")
Check(A.JournalColored("Gadgetzan and the Argent Dawn"):find("|Hcjlore:", 1, true), "world annotation failed in actual journal renderer")
Check(A.JournalColored("{p:Gates of Ahn'Qiraj}"):find("|Hcjlore:event:gates-of-ahnqiraj|h", 1, true), "world event link did not render")
local countBefore = A.LoreNoteCoverage().total
local valid = {id="place:test-atomic",title="Test atomic",kind="Place",body="Test only.",sources={"test"}}
Check(not pcall(A.RegisterLoreNotes, {valid, {id="place:test-invalid",title="Missing source",kind="Place",body="Test only."}}), "invalid entry accepted")
Check(A.GetLoreNote(valid.id) == nil and A.LoreNoteCoverage().total == countBefore, "invalid batch partly registered")
Check(A.db.sentinel == "unchanged" and next(A.db, "sentinel") == nil, "catalogue changed saved data")
for _, failure in ipairs(failures) do print("FAIL: " .. failure) end
assert(#failures == 0, #failures .. " catalogue checks failed")
local counts = A.LoreNoteCoverage()
print(string.format("LoreCatalog: %d checks passed; %d world notes; %d zones, %d dungeon/raid keys, %d bosses, %d towns, %d literal names; %d total notes", checks, curated, inventory.zones, inventory.dungeons, inventory.bosses, towns, literalCount, counts.total))
local keys = {}; for kind in pairs(kinds) do keys[#keys+1] = kind end; table.sort(keys)
for _, kind in ipairs(keys) do print("  " .. kind .. ": " .. kinds[kind]) end
