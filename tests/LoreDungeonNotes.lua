-- Run from the client root: lua Interface/AddOns/CompanionJournal/tests/LoreDungeonNotes.lua
-- An independent Classic roster contract, not an assertion about player kills.
local root = "Interface/AddOns/CompanionJournal/"
local A = {db = {sentinel = "untouched"}}
for _, file in ipairs({"LoreData.lua", "Lore.lua", "LoreAllianceStories.lua", "LoreHordeStories.lua", "LoreWorldStories.lua", "LoreClassStories.lua", "LoreNotes.lua"}) do
    assert(loadfile(root .. file))("CompanionJournal", A)
end
for _, file in ipairs({"LorePlaces.lua", "LorePeopleHistory.lua", "LoreWorldConnections.lua"}) do
    assert(loadfile(root .. file))("CompanionJournal", A)
end
local count = 0
local function Check(value, message) count = count + 1; assert(value, message) end
local roster = {
    ["Ragefire Chasm"] = {"Oggleflint", "Taragaman the Hungerer", "Jergosh the Invoker", "Bazzalan"},
    ["Wailing Caverns"] = {"Lady Anacondra", "Lord Cobrahn", "Lord Pythas", "Lord Serpentis", "Kresh", "Skum", "Verdan the Everliving", "Mutanus the Devourer", "Mad Magglish"},
    ["The Deadmines"] = {"Rhahk'Zor", "Sneed", "Sneed's Shredder", "Gilnid", "Mr. Smite", "Captain Greenskin", "Edwin VanCleef", "Cookie", "Miner Johnson", "Foreman Thistlenettle"},
    ["Shadowfang Keep"] = {"Sever", "Rethilgore", "Razorclaw the Butcher", "Baron Silverlaine", "Commander Springvale", "Odo the Blindwatcher", "Deathsworn Captain", "Fenrus the Devourer", "Wolf Master Nandos", "Archmage Arugal"},
    ["Blackfathom Deeps"] = {"Ghamoo-ra", "Lady Sarevess", "Gelihast", "Lorgus Jett", "Baron Aquanis", "Twilight Lord Kelris", "Old Serra'kis", "Aku'mai"},
    ["The Stockade"] = {"Targorr the Dread", "Kam Deepfury", "Hamhock", "Dextren Ward", "Bazil Thredd", "Bruegal Ironknuckle"},
    ["Gnomeregan"] = {"Grubbis", "Viscous Fallout", "Electrocutioner 6000", "Crowd Pummeler 9-60", "Dark Iron Ambassador", "Mekgineer Thermaplugg", "Techbot"},
    ["Razorfen Kraul"] = {"Roogug", "Aggem Thorncurse", "Death Speaker Jargba", "Overlord Ramtusk", "Agathelos the Raging", "Charlga Razorflank", "Blind Hunter", "Earthcaller Halmgar"},
    ["Scarlet Monastery"] = {"Scorn", "Interrogator Vishas", "Bloodmage Thalnos", "Houndmaster Loksey", "Arcanist Doan", "Herod", "Scarlet Commander Mograine", "High Inquisitor Whitemane", "High Inquisitor Fairbanks", "Azshir the Sleepless", "Fallen Champion", "Ironspine"},
    ["Razorfen Downs"] = {"Lady Falther'ess", "Tuten'kash", "Mordresh Fire Eye", "Glutton", "Amnennar the Coldbringer", "Ragglesnout", "Plaguemaw the Rotting"},
    ["Uldaman"] = {"Revelosh", "Baelog", "Eric \"The Swift\"", "Olaf", "Ironaya", "Obsidian Sentinel", "Ancient Stone Keeper", "Galgann Firehammer", "Grimlok", "Archaedas", "Digmaster Shovelphlange"},
    ["Zul'Farrak"] = {"Dustwraith", "Sandarr Dunereaver", "Antu'sul", "Theka the Martyr", "Witch Doctor Zum'rah", "Nekrum Gutchewer", "Shadowpriest Sezz'ziz", "Sergeant Bly", "Hydromancer Velratha", "Chief Ukorz Sandscalp", "Ruuzlu", "Zerillis", "Gahz'rilla"},
    ["Maraudon"] = {"Noxxion", "Razorlash", "Lord Vyletongue", "Celebras the Cursed", "Meshlok the Harvester", "Landslide", "Tinkerer Gizlock", "Rotgrip", "Princess Theradras"},
    ["The Temple of Atal'Hakkar"] = {"Atal'alarion", "Loro", "Gasher", "Mijan", "Zolo", "Zul'Lor", "Hukku", "Jammal'an the Prophet", "Ogom the Wretched", "Dreamscythe", "Weaver", "Morphaz", "Hazzas", "Avatar of Hakkar", "Shade of Eranikus"},
    ["Blackrock Depths"] = {"Lord Roccor", "High Interrogator Gerstahn", "Houndmaster Grebmar", "Gorosh the Dervish", "Grizzle", "Eviscerator", "Ok'thor the Breaker", "Anub'shiah", "Hedrum the Creeper", "Theldren", "Pyromancer Loregrain", "Bael'Gar", "Warder Stilgiss", "Verek", "Watchman Doomgrip", "General Angerforge", "Hurley Blackbreath", "Ribbly Screwspigot", "Plugger Spazzring", "Phalanx", "Ambassador Flamelash", "Panzor the Invincible", "Hate'rel", "Anger'rel", "Vile'rel", "Gloom'rel", "Seeth'rel", "Doom'rel", "Dope'rel", "Magmus", "Emperor Dagran Thaurissan", "Fineous Darkvire", "Lord Incendius", "Golem Lord Argelmach", "Princess Moira Bronzebeard"},
    ["Lower Blackrock Spire"] = {"Spirestone Butcher", "Spirestone Battle Lord", "Spirestone Lord Magus", "Ghok Bashguud", "Highlord Omokk", "Shadow Hunter Vosh'gajin", "War Master Voone", "Mor Grayhoof", "Bannok Grimaxe", "Mother Smolderweb", "Crystal Fang", "Urok Doomhowl", "Quartermaster Zigris", "Halycon", "Gizrul the Slavener", "Overlord Wyrmthalak"},
    ["Upper Blackrock Spire"] = {"Pyroguard Emberseer", "Solakar Flamewreath", "Goraluk Anvilcrack", "Jed Runewatcher", "Gyth", "The Beast", "Lord Valthalak", "Warchief Rend Blackhand", "General Drakkisath"},
    ["Dire Maul"] = {"Revanchion", "Pusillin", "Zevrim Thornhoof", "Hydrospawn", "Pimgib", "Alzzin the Wildshaper", "Lethtendris", "Tendris Warpwood", "Magister Kalendris", "Tsu'zee", "Illyanna Ravenoak", "Ferra", "Lord Hel'nurath", "Immol'thar", "Prince Tortheldrin", "Guard Mol'dar", "Stomper Kreeg", "Guard Fengus", "Guard Slip'kik", "Captain Kromcrush", "Cho'Rush the Observer", "King Gordok", "The Razza", "Skarr the Unbreakable", "Mushgog"},
    ["Stratholme"] = {"Balzaphon", "The Unforgiven", "Postmaster Malown", "Timmy the Cruel", "Malor the Zealous", "Crimson Hammersmith", "Cannon Master Willey", "Archivist Galford", "Balnazzar", "Baroness Anastari", "Nerub'enkan", "Maleki the Pallid", "Magistrate Barthilas", "Ramstein the Gorger", "Baron Rivendare", "Black Guard Swordsmith", "Hearthsinger Forresten", "Skul", "Stonespine", "Jarien", "Sothos"},
    ["Scholomance"] = {"Lord Blackwood", "Blood Steward of Kirtonos", "Jandice Barov", "Rattlegore", "Marduk Blackpool", "Vectus", "Kormok", "Instructor Malicia", "Lorekeeper Polkelt", "The Ravenian", "Lord Alexei Barov", "Lady Illucia Barov", "Darkmaster Gandling", "Doctor Theolen Krastinov", "Kirtonos the Herald", "Ras Frostwhisper", "Death Knight Darkreaver"},
    ["Onyxia's Lair"] = {"Onyxia"},
    ["Molten Core"] = {"Lucifron", "Magmadar", "Gehennas", "Garr", "Baron Geddon", "Shazzrah", "Sulfuron Harbinger", "Golemagg the Incinerator", "Majordomo Executus", "Ragnaros"},
    ["Blackwing Lair"] = {"Razorgore the Untamed", "Vaelastrasz the Corrupt", "Broodlord Lashlayer", "Firemaw", "Ebonroc", "Flamegor", "Chromaggus", "Nefarian"},
    ["Zul'Gurub"] = {"High Priestess Jeklik", "High Priest Venoxis", "High Priestess Mar'li", "High Priest Thekal", "Zealot Lor'Khan", "Zealot Zath", "High Priestess Arlokk", "Bloodlord Mandokir", "Ohgan", "Jin'do the Hexxer", "Gahz'ranka", "Gri'lek", "Hazza'rah", "Renataki", "Wushoolay", "Hakkar"},
    ["Ruins of Ahn'Qiraj"] = {"Kurinnaxx", "General Rajaxx", "Moam", "Buru the Gorger", "Ayamiss the Hunter", "Ossirian the Unscarred"},
    ["Temple of Ahn'Qiraj"] = {"The Prophet Skeram", "Lord Kri", "Princess Yauj", "Vem", "Battleguard Sartura", "Fankriss the Unyielding", "Viscidus", "Princess Huhuran", "Emperor Vek'lor", "Emperor Vek'nilash", "Ouro", "C'Thun"},
    ["Naxxramas"] = {"Feugen", "Stalagg", "Anub'Rekhan", "Grand Widow Faerlina", "Maexxna", "Noth the Plaguebringer", "Heigan the Unclean", "Loatheb", "Instructor Razuvious", "Gothik the Harvester", "Thane Korth'azz", "Lady Blaumeux", "Sir Zeliek", "Highlord Mograine", "Patchwerk", "Grobbulus", "Gluth", "Thaddius", "Sapphiron", "Kel'Thuzad"},
    ["Ruins of Lordaeron"] = {"Rath'mael", "Witherfang"},
    ["The Hall of Thanes"] = {"Durgen Dirgehammer"},
}
-- Round 22's independent discovery review withheld these direct footer edges:
-- BRD currently reveals Moira's quest twist; Stratholme reveals Dathrohan's
-- identity. Restore navigation when the destination has a safe public projection.
-- Other encounter links still retain their original coverage requirement.
local deferredParentLinks = {
    ["npc:flamelash"] = "dungeon:blackrock-depths",
    ["npc:timmy"] = "dungeon:stratholme",
}
local bosses, dungeons = 0, 0
for dungeon, names in pairs(roster) do
    dungeons = dungeons + 1
    local parent = A.LoreNoteResolve("p", dungeon)
    Check(parent ~= nil, "dungeon context exists: " .. dungeon)
    for _, name in ipairs(names) do
        bosses = bosses + 1
        Check(A.Lore.Boss(name) ~= nil, "storyteller recognizes reviewed encounter: " .. name)
        local id = A.LoreNoteResolve("n", name)
        local note = A.GetLoreNote(id)
        Check(note and note.kind == "Person", "named encounter context: " .. name)
        Check(A.LoreNoteResolve("p", name) == id, "foe markup resolves: " .. name)
        Check(#note.sources > 0, "source provenance: " .. name)
        local linked = false
        for _, related in ipairs(note.related or {}) do if related == parent then linked = true end end
        if deferredParentLinks[id] then
            Check(parent == deferredParentLinks[id], "withheld edge still names the correct dungeon: " .. name)
            Check(not linked, "reviewed unsafe dungeon footer remains withheld: " .. name)
        else
            Check(linked, "boss links to its dungeon: " .. name)
        end
        Check(note.qid == nil and note.after == nil and note.completed == nil, "context cannot claim a completion: " .. name)
        Check(not note.body:lower():find("you ") and not note.body:lower():find("your "), "no invented encounter: " .. name)
        Check(A.LoreNoteLink(name, id):find("|Hcjlore:" .. id .. "|h", 1, true), "clickable identity: " .. name)
    end
end
-- Check every explicitly curated entry, including groups and cross-dungeon links.
local file = assert(io.open(root .. "LoreNotes.lua", "r"))
local source = file:read("*a"); file:close()
local seen, entries = {}, 0
local function CheckEntry(id)
    Check(not seen[id], "no silently ignored duplicate id: " .. id)
    seen[id], entries = true, entries + 1
    local note = A.GetLoreNote(id)
    Check(note ~= nil, "well-formed public ID: " .. id)
    Check(A.LoreNoteResolve("p", note.title) == id, "canonical name is unambiguous: " .. note.title)
    for _, related in ipairs(note.related or {}) do
        Check(A.GetLoreNote(related) ~= nil, "crosslink resolves from " .. id .. " to " .. related)
    end
end
for id in source:gmatch('Curated%("([^"]+)"%s*,') do CheckEntry(id) end
for id in source:gmatch('Encounter%("([^"]+)"%s*,') do CheckEntry("npc:" .. id) end
for _, name in ipairs({"Azuregos", "Lord Kazzak", "Teremus the Devourer", "Emeriss", "Lethon", "Taerar", "Ysondre"}) do
    Check(A.LoreNoteResolve("n", name) ~= nil, "world boss context: " .. name)
    Check(A.Lore.Boss(name) ~= nil, "storyteller recognizes outdoor boss: " .. name)
end
for _, name in ipairs({"Twin Emperors", "The Four Horsemen", "Bug Trio", "Dragons of Nightmare"}) do
    local note = A.GetLoreNote(A.LoreNoteResolve("p", name))
    Check(note and note.kind == "Group", "group encounter identity: " .. name)
end
for _, id in ipairs({"dungeon:lordaeron-ruins", "dungeon:hall-thanes", "npc:rathmael", "npc:witherfang", "npc:durgen"}) do
    Check(A.GetLoreNote(id).setting == "Forever", "custom setting remains explicit: " .. id)
end
Check(A.LoreNoteResolve("n", "Mograine") == nil, "ambiguous family name remains unlinked")
Check(A.LoreNoteResolve("n", "Aku'Mai") == A.LoreNoteResolve("n", "Aku'mai"), "game capitalization variant")
local marked = A.MarkKnownLore("Edwin VanCleef and the Defias Brotherhood; Scarlet Commander Mograine.")
Check(marked:find("{n:Edwin VanCleef}", 1, true), "full-name text becomes clickable")
Check(marked:find("{p:the Defias Brotherhood}", 1, true), "group text becomes clickable")
Check(A.MarkKnownLore(marked) == marked, "annotation is idempotent")
Check(A.db.sentinel == "untouched" and next(A.db, "sentinel") == nil, "references never write saved state")
print(string.format("LoreDungeonNotes: %d checks passed; %d named encounters across %d dungeons; %d explicit curated entries checked", count, bosses, dungeons, entries))
