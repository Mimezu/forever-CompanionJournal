-- Regressions found by external blind samples. No client or SavedVariables.
local A, root = {}, "Interface/AddOns/CompanionJournal/"
for _, file in ipairs({"LoreData.lua", "Lore.lua", "LoreHordeStories.lua", "LoreAllianceStories.lua",
    "LoreWorldStories.lua", "LoreClassStories.lua", "LoreNotes.lua", "LorePlaces.lua",
    "LorePeopleHistory.lua", "LoreWorldConnections.lua"}) do
    assert(loadfile(root .. file))("CompanionJournal", A)
end
local checks = 0
local function Check(value, why)
    checks = checks + 1
    assert(value, why)
end
-- notes3 2026-11-05: ordinary given names a player or companion could carry stay
-- plain in prose (LoreNotes.lua commonNames); markup still resolves them.
local playerLike = {Mikhail = true, Jorgen = true, Alaric = true, Herod = true, Windsor = true,
    Solomon = true, Gunther = true, Laird = true, Calor = true, Darcy = true, Tabetha = true,
    Ringo = true, Bjork = true, Kibler = true, Sneed = true, Gordo = true, Bartleby = true, Linken = true,
    Larion = true, Doan = true, Hendel = true, Carlin = true, Morin = true, Malin = true, Melor = true}
local function Expect(kind, name)
    if playerLike[name] then return "About " .. name .. "." end
    return "About {" .. kind .. ":" .. name .. "}."
end
Check(A.LoreNoteResolve("p", "Doomhammer") == "relic:doomhammer", "weapon must not open the Warchief")
Check(A.LoreNoteResolve("p", "Orgrim Doomhammer") == "npc:orgrim", "full person name retains its biography")
Check(A.LoreNoteResolve("n", "Orgrim") == "npc:orgrim", "unambiguous person alias remains")
Check(A.LoreNoteResolve("n", "Doomhammer") == nil, "bare weapon name must not be a person alias")
local marked = A.MarkKnownLore("Orgrim Doomhammer gave the Doomhammer to Thrall.")
Check(marked:find("{n:Orgrim Doomhammer}", 1, true), "longer person identity wins over embedded weapon name")
Check(marked:find("{p:the Doomhammer}", 1, true) or marked:find("{p:Doomhammer}", 1, true), "weapon mention links separately")
Check(A.LoreNoteResolve("p", "Battle of Mount Hyjal") ~= "event:third-war", "a battle must not masquerade as the whole war")
for name, id in pairs({
    ["The Seven Kingdoms"] = "book:seven-kingdoms",
    ["The Alliance of Lordaeron"] = "book:alliance-lordaeron",
    ["The Dark Portal and the Fall of Stormwind"] = "book:dark-portal-fall-stormwind",
}) do
    Check(A.LoreNoteResolve("p", name) == id, "history book resolves as its own object: " .. name)
    Check(A.GetLoreNote(id).kind == "Book", "book is not a faction or event: " .. name)
end
Check(A.LoreNoteResolve("p", "Stranglethorn") == A.LoreNoteResolve("p", "Stranglethorn Vale"), "curated region retains old shorthand")
Check(A.LoreNoteResolve("p", "Blackwing") == "dungeon:blackwing", "Blackwing Lair retains its old shorthand")
Check(A.LoreNoteResolve("n", "Alexandros Mograine") == "npc:highlord-mograine", "Alexandros uses the existing Horseman biography")
Check(A.LoreNoteResolve("n", "Scarlet Commander Mograine") == "npc:scarlet-mograine", "the Scarlet commander remains a separate person")
Check(A.LoreNoteResolve("n", "Gelbin Mekkatorque") == "npc:gelbin", "Gelbin resolves without his title")
Check(A.LoreNoteResolve("n", "Vanndar Stormpike") == "npc:vanndar", "Vanndar has a dedicated biography")
Check(A.LoreNoteResolve("p", "Ashbringer") == "relic:ashbringer", "Ashbringer opens the weapon rather than its bearer")
Check(A.LoreNoteResolve("p", "Corrupted Ashbringer") == "relic:ashbringer", "corrupted weapon shares its history")
Check(A.MarkKnownLore("Ashbringer and Frostmourne."):find("{p:Ashbringer}", 1, true), "unmarked Ashbringer name is clickable")
Check(A.MarkKnownLore("Ashbringer and Frostmourne."):find("{p:Frostmourne}", 1, true), "unmarked Frostmourne name is clickable")
Check(A.LoreNoteResolve("n", "Renault Mograine") == "npc:scarlet-mograine", "Renault aliases the son, not the Horseman")
Check(A.LoreNoteResolve("p", "Stormwind") == "region:53746f726d77696e642043697479", "bare Stormwind still opens the city")
Check(A.LoreNoteResolve("p", "Darnassus") == "region:4461726e6173737573", "bare Darnassus still opens the city")
Check(A.LoreNoteResolve("p", "Timbermaw Hold") == "place:timbermaw-hold", "bare hold name still opens the place")
for name, id in pairs({
    ["Stormwind (faction)"] = "faction:stormwind",
    ["Darnassus (faction)"] = "faction:darnassus",
    ["Timbermaw Hold (faction)"] = "faction:timbermaw",
}) do
    Check(A.LoreNoteResolve("p", name) == id, "explicit faction route: " .. name)
end
for place, faction in pairs({
    ["region:53746f726d77696e642043697479"] = "faction:stormwind",
    ["region:4461726e6173737573"] = "faction:darnassus",
    ["place:timbermaw-hold"] = "faction:timbermaw",
}) do
    local found
    for _, id in ipairs(A.GetLoreNote(place).related or {}) do found = found or id == faction end
    Check(found, "place offers the separate faction note: " .. place)
end
Check(A.LoreNoteResolve("p", "Charge of the Dragonflights") == "book:charge-dragonflights", "exact book title has its own note")
Check(A.LoreNoteResolve("p", "The Charge of the Dragonflights") ~= "book:charge-dragonflights", "quest title is not a book alias")
Check(A.MarkKnownLore("Read Charge of the Dragonflights.") == "Read {p:Charge of the Dragonflights}.", "book title still autolinks")
Check(A.MarkKnownLore("The Charge of the Dragonflights") == "The Charge of the Dragonflights", "full quest title protects its book-title substring")
Check(A.MarkKnownLore("We completed The Charge of the Dragonflights.") == "We completed The Charge of the Dragonflights.", "quest title remains distinct within a sentence")
Check(A.MarkKnownLore("{q:The Charge of the Dragonflights}") == "{q:The Charge of the Dragonflights}", "explicit quest markup remains opaque")
Check(A.LoreNoteResolve("p", "Benediction") == "relic:benediction", "explicit staff lookup resolves")
Check(A.LoreNoteResolve("p", "Anathema") == "relic:benediction", "alternate staff form resolves to the same relic")
Check(A.MarkKnownLore("Benediction and Anathema") == "{p:Benediction and Anathema}", "unambiguous compound staff name links")
Check(A.MarkKnownLore("Benediction was spoken. Anathema was pronounced.") == "Benediction was spoken. Anathema was pronounced.", "ordinary capitalized words do not turn into relic links")
Check(A.MarkKnownLore("Sulfuras") == "{p:Sulfuras}", "distinctive short weapon name autolinks")
Check(A.LoreNoteResolve("p", "War of the Ancients") == "event:war-ancients", "ordinary event name retains its event note")
Check(A.LoreNoteResolve("p", "The War of the Ancients (book)") == "book:war-ancients", "qualified book title resolves separately")
Check(A.MarkKnownLore("War of the Ancients (book)") == "{p:War of the Ancients (book)}", "longer qualified book name wins over embedded event")
local bookRelated
for _, id in ipairs(A.GetLoreNote("event:war-ancients").related or {}) do bookRelated = bookRelated or id == "book:war-ancients" end
Check(bookRelated, "event offers navigation to its distinct book")
-- Round six found both absent notes and notes that existed but could not be
-- opened from ordinary prose. Check the complete phrase, not a partial match.
for _, entry in ipairs({
    {"Vilebranch tribe", "faction:vilebranch", "p"},
    {"Bleeding Hollow clan", "faction:bleeding-hollow", "p"},
    {"Blackrock clan", "faction:blackrock-clan", "p"},
    {"Kolkar clan", "faction:kolkar", "p"},
    {"Dark Horde", "faction:dark-horde", "p"},
    {"Dragonmaw clan", "faction:dragonmaw", "p"},
    {"Quel'Serrar", "relic:quel-serrar", "p"},
    {"The Sentinels and the Long Vigil", "book:sentinels-long-vigil", "p"},
    {"Head of Onyxia", "relic:head-onyxia", "p"},
    {"The World Tree and the Emerald Dream", "book:world-tree-emerald-dream", "p"},
    {"Exile of the High Elves", "book:exile-high-elves", "p"},
    {"Rhok'delar, Longbow of the Ancient Keepers", "relic:rhokdelar", "p"},
    {"Archmage Tervosh", "npc:tervosh", "n"},
    {"Marshal Windsor", "npc:windsor", "n"},
    {"Bishop DeLavey", "npc:bishop-delavey", "n"},
    -- notes3: "Mikhail" alone is a given name a player could carry; it resolves by
    -- markup but stays plain in prose (checked below this list).
    {"Private Hendel", "npc:private-hendel", "n"},
    {"Silithus", "region:53696c6974687573", "p"},
    {"The Barrens", "region:5468652042617272656e73", "p"},
    {"Ratchet", "place:ratchet", "p"},
    {"Blasted Lands", "region:426c6173746564204c616e6473", "p"},
    {"Darkshore", "region:4461726b73686f7265", "p"},
    {"Booty Bay", "place:booty-bay", "p"},
    {"General Rajaxx", "npc:rajaxx", "n"},
    {"Wushoolay", "npc:wushoolay", "n"},
    {"Gri'lek", "npc:grilek", "n"},
    {"Kurinnaxx", "npc:kurinnaxx", "n"},
    {"High Priestess Jeklik", "npc:jeklik", "n"},
    {"Moam", "npc:moam", "n"},
}) do
    local name, id, kind = entry[1], entry[2], entry[3]
    Check(A.LoreNoteResolve(kind, name) == id, "round six exact identity: " .. name)
    Check(A.MarkKnownLore("About " .. name .. ".") == Expect(kind, name),
        "round six complete phrase autolinks: " .. name)
end
Check(A.LoreNoteResolve("n", "Mikhail") == "npc:mikhail", "round six exact identity: Mikhail")
Check(A.MarkKnownLore("About Mikhail.") == "About Mikhail.", "a player-like given name stays plain: Mikhail")
for _, name in ipairs({"Quel'Serrar", "Rhok'delar"}) do
    Check(A.MarkKnownLore(name) == "{p:" .. name .. "}", "distinctive short artifact links: " .. name)
end
Check(A.LoreNoteResolve("p", "Onyxia") == "npc:onyxia", "trophy does not replace dragon identity")
-- Round seven separates explicit generic item lookups from qualified links.
for _, entry in ipairs({
    {"Maraudine Clan", "faction:maraudine", "p", "Maraudine Clan"},
    {"Shen'dralar", "faction:shendralar", "p", "Shen'dralar"},
    {"Argent Dawn", "faction:argent-dawn", "p", "Argent Dawn"},
    {"Frostwolf Clan", "faction:frostwolf", "p", "Frostwolf Clan"},
    {"Heart of Hakkar", "relic:heart-hakkar", "p", "Heart of Hakkar"},
    {"Drakefire Amulet", "relic:drakefire-amulet", "p", "Drakefire Amulet"},
    {"Atiesh, Greatstaff of the Guardian", "relic:atiesh", "p", "Atiesh, Greatstaff of the Guardian"},
    {"Ancient Tablet", "book:ancient-tablet-zulfarrak", "p", "Ancient Tablet of Zul'Farrak"},
    {"Beginnings of the Undead Threat", "book:beginnings-undead-threat", "p", "Beginnings of the Undead Threat"},
    {"Mallet of Zul'Farrak", "relic:mallet-zulfarrak", "p", "Mallet of Zul'Farrak"},
    {"Wailing Caverns", "dungeon:wailing-caverns", "p", "Wailing Caverns"},
    {"Light's Hope Chapel", "place:lights-hope", "p", "Light's Hope Chapel"},
    {"Abercrombie", "npc:abercrombie", "n", "Abercrombie"},
    {"Stalvan Mistmantle", "npc:stalvan", "n", "Stalvan Mistmantle"},
    {"Fleet Master Seahorn", "npc:seahorn", "n", "Fleet Master Seahorn"},
    {"Thrall", "npc:thrall", "n", "Thrall"},
    {"Regthar Deathgate", "npc:regthar", "n", "Regthar Deathgate"},
    {"Ragnaros", "npc:ragnaros", "n", "Ragnaros"},
    {"Golemagg the Incinerator", "npc:golemagg", "n", "Golemagg the Incinerator"},
    {"Taerar", "npc:taerar", "n", "Taerar"},
    {"Magmadar", "npc:magmadar", "n", "Magmadar"},
}) do
    local name, id, kind, linkName = entry[1], entry[2], entry[3], entry[4]
    Check(A.LoreNoteResolve(kind, name) == id, "round seven exact identity: " .. name)
    Check(A.MarkKnownLore("About " .. linkName .. ".") == Expect(kind, linkName),
        "round seven whole identity autolinks: " .. linkName)
end
Check(A.MarkKnownLore("An Ancient Tablet lay nearby.") == "An Ancient Tablet lay nearby.",
    "generic tablet phrase must not imply this specific item")
Check(A.MarkKnownLore("{p:Ancient Tablet}") == "{p:Ancient Tablet}", "explicit tablet markup stays available")
Check(A.MarkKnownLore("Atiesh") == "{p:Atiesh}", "distinctive short staff name links")
Check(A.MarkKnownLore("Stalvan") == "{n:Stalvan}", "distinctive personal alias links")
-- Round eight: full proper identities link; generic aliases stay explicit-only.
for _, entry in ipairs({
    {"Wintersaber Trainers", "faction:wintersaber-trainers", "p", "Wintersaber Trainers"},
    {"Hakkari", "faction:hakkari", "p", "Hakkari"},
    {"Darkspear Trolls", "faction:darkspear", "p", "Darkspear Trolls"},
    {"The Scourge", "faction:scourge", "p", "The Scourge"},
    {"Tablet of Will", "relic:tablet-will", "p", "Tablet of Will"},
    {"Shattered Sword of Marduk", "relic:shattered-sword-marduk", "p", "Shattered Sword of Marduk"},
    {"Bloodsail Orders", "book:bloodsail-orders", "p", "Bloodsail Orders"},
    {"Rituals of Power", "book:rituals-power", "p", "Rituals of Power (Book)"},
    {"Davil's Libram", "relic:davils-libram", "p", "Davil's Libram"},
    {"Redpath's Shield", "relic:redpaths-shield", "p", "Redpath's Shield"},
    {"Red Cloud Mesa", "place:red-cloud", "p", "Red Cloud Mesa"},
    {"Ruins of Ravenwind", "place:ruins-ravenwind", "p", "Ruins of Ravenwind"},
    {"Sentry Point", "place:sentry-point", "p", "Sentry Point"},
    {"Silverpine Forest", "place:silverpine", "p", "Silverpine Forest"},
    {"Redridge Mountains", "region:5265647269646765204d6f756e7461696e73", "p", "Redridge Mountains"},
    {"Slim", "npc:slim", "n", "Tapoke \"Slim\" Jahn"},
    {"Jorgen", "npc:jorgen", "n", "Jorgen"},
    {"Troyas Moonbreeze", "npc:troyas", "n", "Troyas Moonbreeze"},
    {"Jorah Annison", "npc:jorah", "n", "Jorah Annison"},
    {"Elling Trias", "npc:elling", "n", "Elling Trias"},
    {"Lucifron", "npc:lucifron", "n", "Lucifron"},
    {"Sulfuron Harbinger", "npc:sulfuron", "n", "Sulfuron Harbinger"},
    {"Baron Geddon", "npc:baron-geddon", "n", "Baron Geddon"},
    {"The Prophet Skeram", "npc:skeram", "n", "The Prophet Skeram"},
    {"Garr", "npc:garr", "n", "Garr"},
    {"Anub'Rekhan", "npc:anubrekhan", "n", "Anub'Rekhan"},
}) do
    local name, id, kind, linkName = entry[1], entry[2], entry[3], entry[4]
    Check(A.LoreNoteResolve(kind, name) == id, "round eight exact identity: " .. name)
    Check(A.MarkKnownLore("About " .. linkName .. ".") == Expect(kind, linkName),
        "round eight whole identity autolinks: " .. linkName)
end
Check(A.MarkKnownLore("Slim chances remained.") == "Slim chances remained.", "ordinary adjective stays unlinked")
Check(A.MarkKnownLore("Tapoke Slim Jahn") == "{n:Tapoke Slim Jahn}", "unquoted full personal alias links")
Check(A.MarkKnownLore("We completed Rituals of Power.") == "We completed Rituals of Power.", "ordinary quest title stays unlinked")
Check(A.MarkKnownLore("{q:Rituals of Power}") == "{q:Rituals of Power}", "explicit quest markup is preserved")
Check(A.MarkKnownLore("Darkspear Trolls") == "{p:Darkspear Trolls}", "capitalized tribal name links fully")
-- Round nine: dedicated identities, full phrases and qualified written works.
for _, entry in ipairs({
    {"Freewind Post", "place:freewind", "p", "Freewind Post"},
    {"Felwood", "region:46656c776f6f64", "p", "Felwood"},
    {"Mulgore", "region:4d756c676f7265", "p", "Mulgore"},
    {"Theramore Isle", "place:theramore", "p", "Theramore Isle"},
    {"Moonglade", "region:4d6f6f6e676c616465", "p", "Moonglade"},
    {"Gadgetzan", "place:gadgetzan", "p", "Gadgetzan"},
    {"Hemet Nesingwary", "npc:hemet-nesingwary", "n", "Hemet Nesingwary"},
    {"Wizzle Brassbolts", "npc:wizzle-brassbolts", "n", "Wizzle Brassbolts"},
    {"Sage Truthseeker", "npc:sage-truthseeker", "n", "Sage Truthseeker"},
    {"Rizzle Brassbolts", "npc:rizzle-brassbolts", "n", "Rizzle Brassbolts"},
    {"Tirion Fordring", "npc:tirion", "n", "Tirion Fordring"},
    {"Zorbin Fandazzle", "npc:zorbin-fandazzle", "n", "Zorbin Fandazzle"},
    {"Ebonroc", "npc:ebonroc", "n", "Ebonroc"},
    {"Jin'do the Hexxer", "npc:jindo", "n", "Jin'do the Hexxer"},
    {"Broodlord Lashlayer", "npc:lashlayer", "n", "Broodlord Lashlayer"},
    {"Vaelastrasz the Corrupt", "npc:vaelastrasz", "n", "Vaelastrasz the Corrupt"},
    {"Emeriss", "npc:emeriss", "n", "Emeriss"},
    {"Lord Kazzak", "npc:kazzak", "n", "Lord Kazzak"},
    {"Grimtotem tribe", "faction:grimtotem", "p", "Grimtotem tribe"},
    {"Zandalar Tribe", "faction:zandalar", "p", "Zandalar Tribe"},
    {"Blackwood tribe", "faction:blackwood", "p", "Blackwood tribe"},
    {"Boulderfist clan", "faction:boulderfist", "p", "Boulderfist clan"},
    {"Skullsplitter tribe", "faction:skullsplitter", "p", "Skullsplitter tribe"},
    {"Bristleback tribe", "faction:bristleback", "p", "Bristleback tribe"},
    {"Blood of Heroes", "relic:blood-of-heroes", "p", "Blood of Heroes"},
    {"Scepter of Celebras", "relic:scepter-celebras", "p", "Scepter of Celebras"},
    {"The Green Hills of Stranglethorn", "book:green-hills-stranglethorn", "p", "The Green Hills of Stranglethorn (Book)"},
    {"The Book of Ur", "book:ur", "p", "The Book of Ur (Book)"},
    {"Blackhand's Command", "book:blackhands-command", "p", "Blackhand's Command (Letter)"},
    {"Book of the Ancients", "book:ancients", "p", "Book of the Ancients (Book)"},
}) do
    local name, id, kind, linkName = entry[1], entry[2], entry[3], entry[4]
    Check(A.LoreNoteResolve(kind, name) == id, "round nine exact identity: " .. name)
    Check(A.MarkKnownLore("About " .. linkName .. ".") == Expect(kind, linkName),
        "round nine whole identity autolinks: " .. linkName)
end
for _, name in ipairs({"The Green Hills of Stranglethorn", "The Book of Ur", "Blackhand's Command", "Book of the Ancients", "The Scepter of Celebras"}) do
    Check(A.MarkKnownLore("We completed " .. name .. ".") == "We completed " .. name .. ".", "round nine quest-title protection: " .. name)
    Check(A.MarkKnownLore("{q:" .. name .. "}") == "{q:" .. name .. "}", "round nine explicit quest markup: " .. name)
end
Check(A.LoreNoteResolve("p", "Boulderfist ogres") == "faction:boulderfist", "Arathi ogre alias identifies correct clan")
Check(A.LoreNoteResolve("p", "Stonefist ogres") ~= "faction:boulderfist", "mistranslated sampler name is not an invented alias")
Check(A.LoreNoteResolve("p", "Theramore") == "place:theramore", "city retains existing plain-name route")

-- Round ten: frozen external subjects and deliberately qualified homonyms.
for _, entry in ipairs({
    {"Zul'jin", "npc:zuljin", "n", "Zul'jin"},
    {"Alleria Windrunner", "npc:alleria-windrunner", "n", "Alleria Windrunner"},
    {"Kurdran Wildhammer", "npc:kurdran-wildhammer", "n", "Kurdran Wildhammer"},
    {"Danath Trollbane", "npc:danath-trollbane", "n", "Danath Trollbane"},
    {"Uther Lightbringer", "npc:uther", "n", "Uther Lightbringer"},
    {"Nat Pagle", "npc:nat-pagle", "n", "Nat Pagle"},
    {"Nethergarde Keep", "place:nethergarde", "p", "Nethergarde Keep"},
    {"Orgrimmar", "region:4f726772696d6d6172", "p", "Orgrimmar"},
    {"Astranaar", "place:astranaar", "p", "Astranaar"},
    {"Hammerfall", "place:hammerfall", "p", "Hammerfall"},
    {"Kargath", "place:kargath", "p", "Kargath"},
    {"Southshore", "place:southshore", "p", "Southshore"},
    {"Princess Yauj", "npc:yauj", "n", "Princess Yauj"},
    {"High Priestess Mar'li", "npc:marli", "n", "High Priestess Mar'li"},
    {"High Priest Thekal", "npc:thekal", "n", "High Priest Thekal"},
    {"Ossirian the Unscarred", "npc:ossirian", "n", "Ossirian the Unscarred"},
    {"Darkmaster Gandling", "npc:gandling", "n", "Darkmaster Gandling"},
    {"High Priestess Arlokk", "npc:arlokk", "n", "High Priestess Arlokk"},
    {"Silithid", "group:silithid", "p", "Silithid"},
    {"Sandfury tribe", "faction:sandfury", "p", "Sandfury tribe"},
    {"Blackwater Raiders", "faction:blackwater-raiders", "p", "Blackwater Raiders"},
    {"Shadow Council", "faction:shadow-council", "p", "Shadow Council"},
    {"Explorers' League", "faction:explorers-league", "p", "Explorers' League"},
    {"Arathi tribe", "faction:arathi-tribe", "p", "Arathi tribe"},
    {"Trol'kalar", "relic:trolkalar", "p", "Trol'kalar"},
    {"Discs of Norgannon", "relic:discs-norgannon", "p", "Discs of Norgannon"},
    {"The Invasion of Draenor", "book:invasion-draenor", "p", "The Invasion of Draenor (Book)"},
    {"The Battle of Darrowshire", "event:darrowshire", "p", "The Battle of Darrowshire"},
    {"The Old Gods and the Ordering of Azeroth", "book:old-gods-ordering", "p", "The Old Gods and the Ordering of Azeroth"},
    {"The Kaldorei and the Well of Eternity", "book:kaldorei-well-eternity", "p", "The Kaldorei and the Well of Eternity"},
}) do
    local name, id, kind, linkName = entry[1], entry[2], entry[3], entry[4]
    Check(A.LoreNoteResolve(kind, name) == id, "round ten exact identity: " .. name)
    Check(A.MarkKnownLore("About " .. linkName .. ".") == Expect(kind, linkName),
        "round ten complete-name autolink: " .. linkName)
end
Check(A.LoreNoteResolve("p", "Arathi") == "region:41726174686920486967686c616e6473", "Arathi shorthand still means the Highlands")
Check(A.MarkKnownLore("The Old Gods and the Ordering of Azeroth") == "{p:The Old Gods and the Ordering of Azeroth}", "whole book overrides shorter Old Gods substring")
Check(A.MarkKnownLore("The Invasion of Draenor") ~= "{p:The Invasion of Draenor}", "bare historical title does not become a book autolink")
Check(A.MarkKnownLore("{p:The Invasion of Draenor}") == "{p:The Invasion of Draenor}", "explicit history book remains available")


-- Round eleven: locations, people, factions and artifacts keep distinct routes.
for _, entry in ipairs({
    {"Finkle Einhorn", "npc:finkle-einhorn", "n"},
    {"Grand Admiral Jes-Tereth", "npc:jes-tereth", "n"},
    {"Archmage Xylem", "npc:xylem", "n"},
    {"Marshal McBride", "npc:marshal-mcbride", "n"},
    {"Marshal Maxwell", "npc:maxwell", "n"},
    {"Melor Stonehoof", "npc:melor-stonehoof", "n"},
    {"Grim Batol", "place:grim-batol", "p"},
    {"Feathermoon Stronghold", "place:feathermoon", "p"},
    {"Chillwind Camp", "place:chillwind", "p"},
    {"Camp Mojache", "place:camp-mojache", "p"},
    {"Shadowprey Village", "place:shadowprey", "p"},
    {"Darrowshire", "place:darrowshire", "p"},
    {"Overlord Wyrmthalak", "npc:wyrmthalak", "n"},
    {"Rend Blackhand", "npc:rend", "n"},
    {"Ruins of Ahn'Qiraj", "dungeon:ahnqiraj-ruins", "p"},
    {"The Beast", "npc:the-beast", "n"},
    {"Razorgore the Untamed", "npc:razorgore", "n"},
    {"Shadow Hunter Vosh'gajin", "npc:voshgajin", "n"},
    {"Black Tooth Grin Clan", "faction:black-tooth-grin", "p"},
    {"Frostmane tribe", "faction:frostmane", "p"},
    {"Quel'dorei", "group:high-elves", "p"},
    {"Searing Blade cult", "group:searing-blade", "p"},
    {"Stormreaver Clan", "faction:stormreaver", "p"},
    {"Royal Apothecary Society", "faction:royal-apothecaries", "p"},
    {"Eye of Shadow", "relic:eye-shadow", "p"},
    {"Dartol's Rod of Transformation", "relic:dartols-rod", "p"},
    {"Fall of Quel'Thalas", "event:fall-quelthalas", "p"},
    {"Orb of Noh'Orahil", "relic:orb-nohorahil", "p"},
    {"Eye of Divinity", "relic:eye-divinity", "p"},
    {"Fall of Dalaran", "event:fall-dalaran", "p"},
}) do
    local name, id, kind = entry[1], entry[2], entry[3]
    Check(A.LoreNoteResolve(kind, name) == id, "round eleven exact identity: " .. name)
    Check(A.MarkKnownLore("About " .. name .. ".") == Expect(kind, name),
        "round eleven complete-name autolink: " .. name)
end
Check(A.LoreNoteResolve("p", "Battle of Grim Batol") == "event:grim-batol", "battle remains separate from new fortress")
Check(A.LoreNoteResolve("p", "Battle of Darrowshire") == "event:darrowshire", "battle remains separate from village")
Check(A.LoreNoteResolve("p", "Dalaran") ~= "event:fall-dalaran", "plain city does not open its fall")
Check(A.LoreNoteResolve("p", "Highborne") ~= "group:high-elves", "Highborne and high elves are distinct identities")
Check(A.LoreNoteResolve("p", "Benediction") ~= "relic:eye-divinity", "staff does not become its component")
Check(A.MarkKnownLore("Searing Blade cult") == "{p:Searing Blade cult}", "full cult alias replaces partial highlight")
Check(A.MarkKnownLore("Rend the fabric.") == "Rend the fabric.", "common verb is not a personal autolink")

-- Round twelve: full names must open their own note, including the Titans book.
for _, entry in ipairs({
    {"Sorcerer-Thane Thaurissan", "npc:sorcerer-thane-thaurissan", "n"},
    {"Daelin Proudmoore", "npc:daelin-proudmoore", "n"},
    {"Rhonin", "npc:rhonin", "n"},
    {"Aegwynn", "npc:aegwynn", "n"},
    {"Madoran Bronzebeard", "npc:madoran-bronzebeard", "n"},
    {"Arthas Menethil", "npc:arthas", "n"},
    {"Tanaris", "region:54616e61726973", "p"},
    {"Quel'Lithien Lodge", "place:quellithien-lodge", "p"},
    {"Fallow Sanctuary", "place:fallow-sanctuary", "p"},
    {"Lakeshire", "place:lakeshire", "p"},
    {"Deadwind Pass", "region:4465616477696e642050617373", "p"},
    {"Aerie Peak", "place:aerie-peak", "p"},
    {"Gahz'rilla", "npc:gahzrilla", "n"},
    {"High Priest Venoxis", "npc:venoxis", "n"},
    {"Bloodlord Mandokir", "npc:mandokir", "n"},
    {"Chief Ukorz Sandscalp", "npc:ukorz", "n"},
    {"Blackfathom Deeps", "dungeon:blackfathom", "p"},
    {"Lethon", "npc:lethon", "n"},
    {"Bloodsail Buccaneers", "faction:bloodsail", "p"},
    {"Blue Dragonflight", "faction:blue-dragonflight", "p"},
    {"Warsong Outriders", "faction:warsong-outriders", "p"},
    {"Red Dragonflight", "faction:red-dragonflight", "p"},
    {"Thunderlord Clan", "faction:thunderlord", "p"},
    {"Qiraji", "faction:qiraji", "p"},
    {"The Titans and the Shaping of the Universe", "book:titans-shaping", "p"},
    {"Demon Soul", "relic:demon-soul", "p"},
    {"War of the Three Hammers", "event:three-hammers", "p"},
    {"The Scepter of the Shifting Sands", "relic:scepter-shifting-sands", "p"},
    {"The Great Masquerade", "event:great-masquerade", "p"},
    {"The Missing Diplomat", "event:missing-diplomat", "p"},
}) do
    local name, id, kind = entry[1], entry[2], entry[3]
    Check(A.LoreNoteResolve(kind, name) == id, "round twelve exact identity: " .. name)
    Check(A.MarkKnownLore("About " .. name .. ".") == Expect(kind, name),
        "round twelve complete-name autolink: " .. name)
end
Check(A.LoreNoteResolve("p", "Mythology of the Titans") == "book:titans-shaping", "alternate book title reaches the same book")
Check(A.LoreNoteResolve("p", "Titans") == "faction:titans", "ordinary Titans name keeps the group route")
Check(A.LoreNoteResolve("n", "Emperor Dagran Thaurissan") == "npc:dagran", "the emperor keeps his own route")
Check(A.LoreNoteResolve("p", "Quel'Danil Lodge") == "place:queldanil", "the other elven lodge keeps its own route")
Check(A.MarkKnownLore("{p:The Titans and the Shaping of the Universe}") == "{p:The Titans and the Shaping of the Universe}", "existing explicit book link is not nested")

-- Round thirteen: separate city/faction identities and complete proper-name links.
for _, entry in ipairs({
    {"Brother Crowley", "npc:brother-crowley", "n"},
    {"Nogg", "npc:nogg", "n"},
    {"Tabetha", "npc:tabetha", "n"},
    {"Neeru Fireblade", "npc:neeru-fireblade", "n"},
    {"Lorekeeper Raintotem", "npc:lorekeeper-raintotem", "n"},
    {"Henze Faulk", "npc:henze-faulk", "n"},
    {"Warsong Lumber Camp", "place:warsong-lumber-camp", "p"},
    {"Trollbane Hall", "place:trollbane-hall", "p"},
    {"Whelgar's Excavation Site", "place:whelgars-excavation-site", "p"},
    {"Refuge Pointe", "place:refuge-pointe", "p"},
    {"Maestra's Post", "place:maestras-post", "p"},
    {"Thelsamar", "place:thelsamar", "p"},
    {"Lord Vyletongue", "npc:vyletongue", "n"},
    {"Firemaw", "npc:firemaw", "n"},
    {"Maleki the Pallid", "npc:maleki", "n"},
    {"Antu'sul", "npc:antusul", "n"},
    {"Mekgineer Thermaplugg", "npc:thermaplugg", "n"},
    {"Ironforge (reputation faction)", "faction:ironforge", "p"},
    {"Witherbark tribe", "faction:witherbark", "p"},
    {"Undercity (reputation faction)", "faction:undercity", "p"},
    {"Green Dragonflight", "faction:green-dragonflight", "p"},
    {"People's Militia", "group:peoples-militia", "p"},
    {"Furbolgs", "race:furbolgs", "p"},
    {"Pendant of Myzrael", "relic:pendant-myzrael", "p"},
    {"Hydrocane", "relic:hydrocane", "p"},
    {"Battle of Mount Hyjal", "event:battle-mount-hyjal", "p"},
    {"Orb of Soran'ruk", "relic:orb-soranruk", "p"},
    {"Gnomeregan's fall", "event:fall-gnomeregan", "p"},
    {"Stave of Equinex", "relic:stave-equinex", "p"},
}) do
    local name, id, kind = entry[1], entry[2], entry[3]
    Check(A.LoreNoteResolve(kind, name) == id, "round thirteen exact identity: " .. name)
    Check(A.MarkKnownLore("About " .. name .. ".") == Expect(kind, name),
        "round thirteen complete-name autolink: " .. name)
end
Check(A.LoreNoteResolve("n", "Cookie") == "npc:cookie", "the named cook remains explicitly reachable")
Check(A.MarkKnownLore("Cookie") == "Cookie", "ordinary cookie word is not automatically a cook link")
Check(A.LoreNoteResolve("p", "Ironforge") == "region:49726f6e666f726765", "Ironforge city retains its original route")
Check(A.LoreNoteResolve("p", "Undercity") == "place:undercity", "Undercity city retains its original route")
Check(A.LoreNoteResolve("p", "Gnomeregan") == "dungeon:gnomeregan", "city does not become the disaster event")
Check(A.LoreNoteResolve("n", "Noggle Ficklespragg") ~= "npc:nogg", "Noggle is a different person from Nogg")
Check(A.LoreNoteResolve("p", "Orb of Noh'Orahil") ~= "relic:orb-soranruk", "warlock orbs remain distinct")
Check(A.LoreNoteResolve("p", "Battle for Mount Hyjal") == "event:battle-mount-hyjal", "alternate Hyjal battle wording")
Check(A.MarkKnownLore("{p:Ironforge (reputation faction)}") == "{p:Ironforge (reputation faction)}", "explicit qualified faction link is not nested")
for place, target in pairs({
    ["region:49726f6e666f726765"] = "faction:ironforge",
    ["place:undercity"] = "faction:undercity",
    ["dungeon:gnomeregan"] = "event:fall-gnomeregan",
}) do
    local found
    for _, id in ipairs(A.GetLoreNote(place).related or {}) do found = found or id == target end
    Check(found, "city offers its new related subject: " .. place)
end


-- Round fourteen: full sampled names, short proper names, and artifact identities.
for _, entry in ipairs({
    {"Shindrell Swiftfire", "npc:shindrell-swiftfire", "n"},
    {"Jonathan Carevin", "npc:jonathan-carevin", "n"},
    {"Jitters", "npc:jitters", "n"},
    {"Thundris Windweaver", "npc:thundris-windweaver", "n"},
    {"Thyn'tel Bladeweaver", "npc:thyntel-bladeweaver", "n"},
    {"Talvash del Kissel", "npc:talvash-del-kissel", "n"},
    {"Gilnid", "npc:gilnid", "n"},
    {"Sneed", "npc:sneed", "n"},
    {"Grimlok", "npc:grimlok", "n"},
    {"Rhahk'zor", "npc:rhahkzor", "n"},
    {"Demon Fall Ridge", "place:demon-fall-ridge", "p"},
    {"Jademir Lake", "place:jademir-lake", "p"},
    {"Angor Fortress", "place:angor-fortress", "p"},
    {"Bathran's Haunt", "place:bathrans-haunt", "p"},
    {"Satyrnaar", "place:satyrnaar", "p"},
    {"Hammertoe's Digsite", "place:hammertoes-digsite", "p"},
    {"Death's Head tribe", "faction:deaths-head", "p"},
    {"Stonesplinter tribe", "faction:stonesplinter", "p"},
    {"Razormane tribe", "faction:razormane", "p"},
    {"Shadowhide clan", "faction:shadowhide", "p"},
    {"Smolderthorn tribe", "faction:smolderthorn", "p"},
    {"Mossflayer tribe", "faction:mossflayer", "p"},
    {"Tablet of Ryun'eh", "relic:tablet-ryuneh", "p"},
    {"Ring of Zoram", "relic:ring-zoram", "p"},
    {"First Mosh'aru Tablet", "relic:first-mosharu-tablet", "p"},
    {"Ancient Egg", "relic:ancient-egg", "p"},
    {"The Heart of the Mountain", "relic:heart-mountain", "p"},
    {"Star of Xil'yeh", "relic:star-xilyeh", "p"},
    {"Lord Cobrahn", "npc:cobrahn", "n"},
    {"Lady Sarevess", "npc:sarevess", "n"},
}) do
    local name, id, kind = entry[1], entry[2], entry[3]
    Check(A.LoreNoteResolve(kind, name) == id, "round fourteen exact identity: " .. name)
    Check(A.MarkKnownLore("About " .. name .. ".") == Expect(kind, name),
        "round fourteen complete-name autolink: " .. name)
end
Check(A.LoreNoteResolve("p", "Egg of Hakkar") == "relic:ancient-egg", "ritual egg is the same relic")
Check(A.LoreNoteResolve("p", "Filled Egg of Hakkar") == "relic:ancient-egg", "filled egg keeps its relic route")
Check(A.LoreNoteResolve("p", "Heart of Hakkar") ~= "relic:heart-mountain", "different hearts are not conflated")
Check(A.LoreNoteResolve("p", "Tablet of Will") ~= "relic:first-mosharu-tablet", "distinct Uldaman and troll tablets")
Check(A.MarkKnownLore("{p:Ancient Egg}") == "{p:Ancient Egg}", "explicit egg link is not nested")

Check(A.MarkKnownLore("Rhahk'Zor and Rhahk'zor") == "{n:Rhahk'Zor} and {n:Rhahk'zor}", "canonical spelling and case-only alias both link")
Check(A.MarkKnownLore("Shindrell") == "Shindrell", "short alias does not inherit full-name opt-in")
Check(A.MarkKnownLore("Rhahk'zorian") == "Rhahk'zorian", "case alias preserves whole-word boundary")


-- Round fifteen: all blind identities and full-name navigation.
for _, entry in ipairs({
    {"Theocritus", "npc:theocritus", "n"},
    {"Ansirem Runeweaver", "npc:ansirem-runeweaver", "n"},
    {"Eitrigg", "npc:eitrigg", "n"},
    {"Keeper Remulos", "npc:remulos", "n"},
    {"Kilrogg Deadeye", "npc:kilrogg-deadeye", "n"},
    {"Dath'Remar Sunstrider", "npc:dathremar-sunstrider", "n"},
    {"Moonbrook", "place:moonbrook", "p"},
    {"Thandol Span", "place:thandol-span", "p"},
    {"The Sepulcher", "place:sepulcher", "p"},
    {"Splintertree Post", "place:splintertree", "p"},
    {"Northwatch Hold", "place:northwatch", "p"},
    {"Dun Modr", "place:dun-modr", "p"},
    {"Charlga Razorflank", "npc:charlga", "n"},
    {"Lord Roccor", "npc:roccor", "n"},
    {"Emperor Dagran Thaurissan", "npc:dagran", "n"},
    {"Atal'alarion", "npc:atalalarion", "n"},
    {"Morphaz", "npc:morphaz", "n"},
    {"Baron Rivendare", "npc:rivendare", "n"},
    {"Gordunni clan", "faction:gordunni", "p"},
    {"Woodpaw clan", "faction:woodpaw", "p"},
    {"Galak tribe", "faction:galak", "p"},
    {"Deadwood tribe", "faction:deadwood", "p"},
    {"Church of the Holy Light", "faction:church-holy-light", "p"},
    {"Stonemaul clan", "faction:stonemaul", "p"},
    {"Troll Wars", "event:troll-wars", "p"},
    {"Eye of Sargeras", "relic:eye-sargeras", "p"},
    {"The Phylactery of Kel'Thuzad", "relic:phylactery-kelthuzad", "p"},
    {"Doomsday Candle", "relic:doomsday-candle", "p"},
    {"Horn of Cenarius", "relic:horn-cenarius", "p"},
    {"Bell of Dethmoora", "relic:bell-dethmoora", "p"},
}) do
    local name, id, kind = entry[1], entry[2], entry[3]
    Check(A.LoreNoteResolve(kind, name) == id, "round fifteen exact identity: " .. name)
    Check(A.MarkKnownLore("About " .. name .. ".") == Expect(kind, name),
        "round fifteen complete-name autolink: " .. name)
end
Check(A.MarkKnownLore("Gordunni clan and Stonemaul clan") == "{p:Gordunni clan} and {p:Stonemaul clan}", "full sampled clan names link")
Check(A.LoreNoteResolve("p", "Gordunni Ogres") == "faction:gordunni", "existing Gordunni title remains stable")
Check(A.MarkKnownLore("Atal'alarion and Morphaz") == "{n:Atal'alarion} and {n:Morphaz}", "distinctive encounter names link")


-- Round sixteen: all blind identities and full-name navigation.
for _, entry in ipairs({
    {"Commander Althea Ebonlocke", "npc:althea-ebonlocke", "n"},
    {"Verna Furlbrow", "npc:verna-furlbrow", "n"},
    {"Garrick Padfoot", "npc:garrick-padfoot", "n"},
    {"Sven Yorgen", "npc:sven-yorgen", "n"},
    {"Khan Dez'hepah", "npc:khan-dezhepah", "n"},
    {"Mor'Ladim", "npc:morladim", "n"},
    {"Jangolode Mine", "place:jangolode", "p"},
    {"Tethris Aran", "place:tethris-aran", "p"},
    {"Sar'theris Strand", "place:sartheris-strand", "p"},
    {"Skulk Rock", "place:skulk-rock", "p"},
    {"Raven Hill", "place:raven-hill", "p"},
    {"The Rotting Orchard", "place:rotting-orchard", "p"},
    {"Twilight Lord Kelris", "npc:kelris", "n"},
    {"Arcanist Doan", "npc:doan", "n"},
    {"Houndmaster Loksey", "npc:loksey", "n"},
    {"Rattlegore", "npc:rattlegore", "n"},
    {"Instructor Malicia", "npc:malicia", "n"},
    {"Ragefire Chasm", "dungeon:ragefire", "p"},
    {"SI:7", "faction:si7", "p"},
    {"Theramore Guard", "faction:theramore-guard", "p"},
    {"Gorishi Hive", "group:gorishi-hive", "p"},
    {"Wildmane Tribe", "faction:wildmane", "p"},
    {"Freethinkers of Zandalar", "group:freethinkers-zandalar", "p"},
    {"The Barov Family", "group:barov-family", "p"},
    {"The Moss-twined Heart", "relic:moss-twined-heart", "p"},
    {"The Spectral Chalice", "relic:spectral-chalice", "p"},
    {"Wrath of Soulflayer", "book:wrath-soulflayer", "p"},
    {"A Mangled Journal", "book:mangled-journal", "p"},
    {"Awbee's Scale", "relic:awbees-scale", "p"},
    {"Scarab Gong", "relic:scarab-gong", "p"},
}) do
    local name, id, kind = entry[1], entry[2], entry[3]
    Check(A.LoreNoteResolve(kind, name) == id, "round sixteen exact identity: " .. name)
    Check(A.MarkKnownLore("About " .. name .. ".") == Expect(kind, name),
        "round sixteen complete-name autolink: " .. name)
end
Check(A.MarkKnownLore("SI:7 and Rattlegore") == "{p:SI:7} and {n:Rattlegore}", "organization punctuation and proper boss name link")
Check(A.MarkKnownLore("{p:SI:7}") == "{p:SI:7}", "explicit SI7 link not nested")
Check(A.LoreNoteResolve("p", "Raven Hill Cemetery") == "place:raven-hill", "established cemetery alias retained")
Check(A.LoreNoteResolve("p", "Rotting Orchard") == "place:rotting-orchard", "orchard without article resolves")


-- Round seventeen: blind sampled subjects retain dedicated full-name routes.
for _, entry in ipairs({
    {"Malyfous Darkhammer", "npc:malyfous-darkhammer", "n"},
    {"Hamuul Runetotem", "npc:hamuul", "n"},
    {"Rexxar", "npc:rexxar", "n"},
    {"Nixx Sprocketspring", "npc:nixx-sprocketspring", "n"},
    {"Nessa Shadowsong", "npc:nessa-shadowsong", "n"},
    {"Magistrate Solomon", "npc:solomon", "n"},
    {"Dragonmaw Gates", "place:dragonmaw-gates", "p"},
    {"Jintha'Alor", "place:jinthaalor", "p"},
    {"Lake Elune'ara", "place:lake-eluneara", "p"},
    {"Tyr's Hand", "place:tyrs-hand", "p"},
    {"Bael Modan", "place:bael-modan", "p"},
    {"Stonewrought Dam", "place:stonewrought-dam", "p"},
    {"Lord Incendius", "npc:incendius", "n"},
    {"Fineous Darkvire", "npc:fineous", "n"},
    {"Noth the Plaguebringer", "npc:noth", "n"},
    {"War Master Voone", "npc:voone", "n"},
    {"Chromaggus", "npc:chromaggus", "n"},
    {"Houndmaster Grebmar", "npc:grebmar", "n"},
    {"Bluegill Murlocs", "faction:bluegill", "p"},
    {"Firegut Ogres", "faction:firegut", "p"},
    {"Mosshide Gnolls", "faction:mosshide", "p"},
    {"Dreadmaul Ogres", "faction:dreadmaul", "p"},
    {"Tunnel Rat Kobolds", "faction:tunnel-rat", "p"},
    {"Redridge Gnolls", "faction:redridge-gnolls", "p"},
    {"The Ancient Leaf", "relic:ancient-petrified-leaf", "p"},
    {"The Scourge of Lordaeron (History of Warcraft book)", "book:scourge-lordaeron", "p"},
    {"The Founding of Quel'Thalas (History of Warcraft book)", "book:founding-quelthalas", "p"},
    {"The New Horde (History of Warcraft book)", "book:new-horde", "p"},
    {"Sunwell - The Fall of Quel'Thalas (History of Warcraft book)", "book:sunwell-fall-quelthalas", "p"},
    {"Civil War in the Plaguelands (History of Warcraft book)", "book:civil-war-plaguelands", "p"},
}) do
    local name, id, kind = entry[1], entry[2], entry[3]
    Check(A.LoreNoteResolve(kind, name) == id, "round seventeen exact identity: " .. name)
    Check(A.MarkKnownLore("About " .. name .. ".") == Expect(kind, name),
        "round seventeen complete-name autolink: " .. name)
end
Check(A.MarkKnownLore("Chromaggus and Rexxar") == "{n:Chromaggus} and {n:Rexxar}", "short proper boss and champion names link")
Check(A.LoreNoteResolve("p", "Sunwell - The Fall of Quel'Thalas") == "book:sunwell-fall-quelthalas", "full Sunwell book title has its own identity")
Check(A.MarkKnownLore("Sunwell - The Fall of Quel'Thalas") == "{p:Sunwell - The Fall of Quel'Thalas}", "full book title does not split into place and event")
Check(A.LoreNoteResolve("p", "Fall of Quel'Thalas") == "event:fall-quelthalas", "ordinary historical event route survives book addition")
Check(A.LoreNoteResolve("p", "Bael'dun Digsite") ~= "place:bael-modan", "Mulgore excavation is not Barrens Bael Modan")
Check(A.MarkKnownLore("Jintha'Alor and Jintha'alor") == "{p:Jintha'Alor} and {p:Jintha'alor}", "city case variants both link")
Check(A.MarkKnownLore("{p:Lake Elune'ara}") == "{p:Lake Elune'ara}", "explicit lake link is not nested")


-- Round eighteen: complete sampled names, including typographic apostrophes.
for _, entry in ipairs({
    {"Kharan Mighthammer", "npc:kharan-mighthammer", "n"},
    {"General Marcus Jonathan", "npc:marcus-jonathan", "n"},
    {"Falstad Wildhammer", "npc:falstad", "n"},
    {"Valstann Staghelm", "npc:valstann", "n"},
    {"Umi Rumplesnicker", "npc:umi-rumplesnicker", "n"},
    {"Ragged John", "npc:ragged-john", "n"},
    {"Stromgarde Keep", "place:stromgarde", "p"},
    {"Alterac Valley", "battleground:alterac-valley", "p"},
    {"Alterac Mountains", "region:416c7465726163204d6f756e7461696e73", "p"},
    {"Faldir’s Cove", "place:faldirs-cove", "p"},
    {"Ruins of Alterac", "place:ruins-alterac", "p"},
    {"Sentinel Hill", "place:sentinel-hill", "p"},
    {"Zul'Farrak", "dungeon:zulfarrak", "p"},
    {"Fenrus the Devourer", "npc:fenrus", "n"},
    {"Razorlash", "npc:razorlash", "n"},
    {"Witch Doctor Zum'rah", "npc:zumrah", "n"},
    {"Mr. Smite", "npc:mr-smite", "n"},
    {"The Stockade", "dungeon:stockade", "p"},
    {"Southsea Freebooters", "faction:southsea-freebooters", "p"},
    {"Crushridge Ogres", "faction:crushridge", "p"},
    {"Riverpaw Gnolls", "faction:riverpaw", "p"},
    {"The League of Arathor", "faction:arathor", "p"},
    {"Bloodscalp Tribe", "faction:bloodscalp", "p"},
    {"Stonevault Troggs", "faction:stonevault", "p"},
    {"Staff of Prehistoria", "relic:staff-prehistoria", "p"},
    {"The Culling", "event:culling-stratholme", "p"},
    {"Gni’kiv Medallion", "relic:gnikiv-medallion", "p"},
    {"The Shattered Necklace", "relic:shattered-necklace", "p"},
    {"Scythe of Elune", "relic:scythe-elune", "p"},
    {"Second Mosh’aru Tablet", "relic:second-mosharu-tablet", "p"},
}) do
    local name, id, kind = entry[1], entry[2], entry[3]
    Check(A.LoreNoteResolve(kind, name) == id, "round eighteen exact identity: " .. name)
    Check(A.MarkKnownLore("About " .. name .. ".") == Expect(kind, name),
        "round eighteen complete-name autolink: " .. name)
end
Check(A.LoreNoteResolve("p", "Alterac") == "region:416c7465726163204d6f756e7461696e73", "unqualified Alterac keeps its region route")
Check(A.LoreNoteResolve("p", "Alterac City") == "place:ruins-alterac", "former capital has a distinct city route")
Check(A.MarkKnownLore("The Culling of Stratholme") == "{p:The Culling of Stratholme}", "full historical event takes precedence over short alias")
Check(A.MarkKnownLore("The Purge of Stratholme") == "{p:The Purge of Stratholme}", "full historical purge alias links to dedicated event")
Check(A.LoreNoteResolve("p", "Gni'kiv Medallion") ~= A.LoreNoteResolve("p", "Staff of Prehistoria"), "staff component is distinct from assembled staff")
Check(A.LoreNoteResolve("p", "Second Mosh'aru Tablet") ~= A.LoreNoteResolve("p", "First Mosh'aru Tablet"), "second and first tablets remain distinct")
Check(A.MarkKnownLore("Razorlash") == "{n:Razorlash}", "proper-name lasher is clickable")
Check(A.MarkKnownLore("{p:The Culling}") == "{p:The Culling}", "explicit short event link not nested")

-- Round nineteen: full sampled identities and explicit homonym separation.
for _, entry in ipairs({
    {"Turalyon", "npc:turalyon", "n"},
    {"High Priestess MacDonnell", "npc:high-priestess-macdonnell", "n"},
    {"Mankrik", "npc:mankrik", "n"},
    {"Yeh'kinya", "npc:yehkinya", "n"},
    {"Theldurin the Lost", "npc:theldurin-the-lost", "n"},
    {"Archmage Malin", "npc:archmage-malin", "n"},
    {"Shimmering Flats", "place:shimmering-flats", "p"},
    {"Rethban Caverns", "place:rethban-caverns", "p"},
    {"Camp Taurajo", "place:camp-taurajo", "p"},
    {"Durnholde Keep", "place:durnholde", "p"},
    {"Dalaran", "city:dalaran", "p"},
    {"Blackrock Mountain", "place:blackrock-mountain", "p"},
    {"Ras Frostwhisper", "npc:ras", "n"},
    {"Bael'Gar", "npc:baelgar", "n"},
    {"Pyroguard Emberseer", "npc:emberseer", "n"},
    {"Doctor Theolen Krastinov", "npc:krastinov", "n"},
    {"Ayamiss the Hunter", "npc:ayamiss", "n"},
    {"C'Thun", "npc:cthun", "n"},
    {"Elementals of Azeroth", "group:elementals", "p"},
    {"Kingdom of Stromgarde", "faction:kingdom-stromgarde", "p"},
    {"The Horde", "faction:horde", "p"},
    {"Stormwind House of Nobles", "group:stormwind-nobles", "p"},
    {"Kingdom of Kul Tiras", "faction:kingdom-kul-tiras", "p"},
    {"Kingdom of Alterac", "faction:kingdom-alterac", "p"},
    {"Diary of Weavil", "book:diary-weavil", "p"},
    {"Stone of the Tides", "relic:stone-tides", "p"},
    {"Battle of Crestfall", "event:battle-crestfall", "p"},
    {"The Plague of Undeath", "history:plague-undeath", "p"},
    {"Death of King Terenas", "event:death-terenas", "p"},
    {"Foundation of Dalaran (historical event)", "event:founding-dalaran", "p"},
}) do
    local name, id, kind = entry[1], entry[2], entry[3]
    Check(A.LoreNoteResolve(kind, name) == id, "round nineteen exact identity: " .. name)
    Check(A.MarkKnownLore("About " .. name .. ".") == Expect(kind, name),
        "round nineteen complete-name autolink: " .. name)
end
Check(A.LoreNoteResolve("p", "Elementals") == "group:elementals", "generic elementals available explicitly")
Check(A.MarkKnownLore("Elementals and elementals") == "Elementals and elementals", "generic elemental word is not automatically highlighted")
Check(A.LoreNoteResolve("p", "Stromgarde") == "place:stromgarde", "ordinary Stromgarde remains geographic")
Check(A.LoreNoteResolve("p", "Alterac") == "region:416c7465726163204d6f756e7461696e73", "ordinary Alterac remains geographic")
Check(A.LoreNoteResolve("p", "Dalaran") == "city:dalaran", "ordinary Dalaran remains city")
Check(A.LoreNoteResolve("p", "Durnholde") == "place:durnholde", "short Durnholde alias reaches fortress")
Check(A.MarkKnownLore("Durnholde") == "{p:Durnholde}", "short fortress alias is automatically clickable")
Check(A.MarkKnownLore("Bael'Gar") == "{n:Bael'Gar}", "full giant name opt-in autolinks")
Check(A.MarkKnownLore("{p:Elementals}") == "{p:Elementals}", "explicit generic link not nested")

-- Rounds twenty and twenty-one: complete-name links and homonym boundaries.
for _, entry in ipairs({
    {"Menethil Harbor", "place:menethil", "p", "Menethil Harbor", true},
    {"Windshear Crag", "place:windshear-crag", "p", "Windshear Crag", true},
    {"Morlos'Aran", "place:morlos-aran", "p", "Morlos'Aran", true},
    {"Sun Rock Retreat", "place:sun-rock", "p", "Sun Rock Retreat", true},
    {"The Forsaken", "faction:forsaken", "p", "The Forsaken", true},
    {"Orgrimmar (reputation faction)", "faction:orgrimmar-reputation", "p", "Orgrimmar (reputation faction)", true},
    {"Satyrs", "group:satyrs", "p", "Satyrs", false},
    {"Worgen", "group:worgen", "p", "Worgen", false},
    {"Thunder Bluff (reputation faction)", "faction:thunder-bluff-reputation", "p", "Thunder Bluff (reputation faction)", true},
    {"Harpies", "group:harpies", "p", "Harpies", false},
    {"The Second Troll Legend", "book:second-troll-legend", "p", "The Second Troll Legend", true},
    {"Old Hatreds - The Colonization of Kalimdor", "book:old-hatreds-colonization", "p", "Old Hatreds - The Colonization of Kalimdor (book)", true},
    {"Beyond the Dark Portal (Warcraft III manual chapter)", "book:beyond-dark-portal-manual", "p", "Beyond the Dark Portal (Warcraft III manual chapter)", true},
    {"Foror's Compendium of Dragon Slaying", "book:forors-compendium", "p", "Foror's Compendium of Dragon Slaying", true},
    {"Aegwynn and the Dragon Hunt", "book:aegwynn-dragon-hunt", "p", "Aegwynn and the Dragon Hunt (book)", true},
    {"The Third Troll Legend", "book:third-troll-legend", "p", "The Third Troll Legend", true},
    {"Alonsus Faol", "npc:alonsus-faol", "n", "Alonsus Faol", true},
    {"Ysera", "npc:ysera", "n", "Ysera", true},
    {"Neltharion", "npc:deathwing", "n", "Deathwing", true},
    {"Tichondrius", "npc:tichondrius", "n", "Tichondrius", true},
    {"Blackhand", "npc:blackhand", "n", "Blackhand", true},
    {"Ner'zhul", "npc:nerzhul", "n", "Ner'zhul", true},
    {"Emperor Vek'lor", "npc:veklor", "n", "Emperor Vek'lor", true},
    {"Hazza'rah", "npc:hazzarah", "n", "Hazza'rah", true},
    {"Buru the Gorger", "npc:buru", "n", "Buru the Gorger", true},
    {"Lord Kri", "npc:kri", "n", "Lord Kri", true},
    {"Shazzrah", "npc:shazzrah", "n", "Shazzrah", true},
    {"Vem", "npc:vem", "n", "Vem", true},
}) do
    local name, id, kind, title, automatic = unpack(entry)
    Check(A.LoreNoteResolve(kind, name) == id, "round 20 exact identity: " .. name)
    local expected = automatic and ("About {" .. kind .. ":" .. title .. "}.") or ("About " .. title .. ".")
    Check(A.MarkKnownLore("About " .. title .. ".") == expected, "round 20 title linking boundary: " .. title)
end
for _, entry in ipairs({
    {"The Dead Acre", "place:dead-acre", "p", "The Dead Acre", true},
    {"Shadra'Alor", "place:shadraalor", "p", "Shadra'Alor", true},
    {"Northfold Manor", "place:northfold", "p", "Northfold Manor", true},
    {"The Creeping Ruin", "place:creeping-ruin", "p", "The Creeping Ruin", true},
    {"Circle of East Binding", "place:east-binding", "p", "Circle of East Binding", true},
    {"Lordamere Internment Camp", "place:lordamere-internment", "p", "Lordamere Internment Camp", true},
    {"Gadgetzan Water Company", "group:gadgetzan-water-company", "p", "Gadgetzan Water Company", true},
    {"Miners' League", "group:miners-league", "p", "Miners' League", true},
    {"Slitherblade", "group:slitherblade", "p", "Slitherblade", true},
    {"Bloodfury", "group:bloodfury", "p", "Bloodfury", true},
    {"Ironforge Guard", "group:ironforge-guard", "p", "Ironforge Guard", true},
    {"Firebrand Legion", "group:firebrand-legion", "p", "Firebrand Legion", true},
    {"Codex of Defense", "book:codex-defense", "p", "Codex of Defense (book)", true},
    {"Libram of Protection", "book:libram-protection", "p", "Libram of Protection (book)", true},
    {"Left Piece of Lord Valthalak's Amulet", "relic:left-valthalak-amulet", "p", "Left Piece of Lord Valthalak's Amulet (artifact)", true},
    {"Tome of the Cabal", "book:tome-cabal", "p", "Tome of the Cabal (book)", true},
    {"Frost Shock and You", "book:frost-shock", "p", "Frost Shock and You (book)", true},
    {"The Light and How to Swing It", "book:light-swing", "p", "The Light and How to Swing It (book)", true},
    {"Kreldig Ungor", "npc:kreldig-ungor", "n", "Kreldig Ungor", true},
    {"Rhapsody Shindigger", "npc:rhapsody-shindigger", "n", "Rhapsody Shindigger", true},
    {"Jannos Lighthoof", "npc:jannos-lighthoof", "n", "Jannos Lighthoof", true},
    {"Krom Stoutarm", "npc:krom-stoutarm", "n", "Krom Stoutarm", true},
    {"Hegnar Rumbleshot", "npc:hegnar-rumbleshot", "n", "Hegnar Rumbleshot", true},
    {"Brohann Caskbelly", "npc:brohann-caskbelly", "n", "Brohann Caskbelly", true},
    {"Jammal'an the Prophet", "npc:jammalan", "n", "Jammal'an the Prophet", true},
    {"Lord Valthalak", "npc:valthalak", "n", "Lord Valthalak", true},
    {"Ghamoo-ra", "npc:ghamoo-ra", "n", "Ghamoo-ra", true},
    {"Gorosh the Dervish", "npc:gorosh", "n", "Gorosh the Dervish", true},
    {"Phalanx", "npc:phalanx", "n", "Phalanx", true},
    {"Halycon", "npc:halycon", "n", "Halycon", true},
}) do
    local name, id, kind, title, automatic = unpack(entry)
    Check(A.LoreNoteResolve(kind, name) == id, "round 21 exact identity: " .. name)
    local expected = automatic and ("About {" .. kind .. ":" .. title .. "}.") or ("About " .. title .. ".")
    Check(A.MarkKnownLore("About " .. title .. ".") == expected, "round 21 title linking boundary: " .. title)
end
for _, entry in ipairs({
    {"Codex of Defense", "book:codex-defense"},
    {"Libram of Protection", "book:libram-protection"},
    {"Left Piece of Lord Valthalak's Amulet", "relic:left-valthalak-amulet"},
    {"Tome of the Cabal", "book:tome-cabal"},
    {"Frost Shock and You", "book:frost-shock"},
    {"The Light and How to Swing It", "book:light-swing"},
}) do
    local name, id = entry[1], entry[2]
    Check(A.LoreNoteResolve("q", name) ~= id, "quest homonym must not open the book/artifact: " .. name)
    Check(A.MarkKnownLore("{q:" .. name .. "}") == "{q:" .. name .. "}", "explicit quest homonym markup stays intact: " .. name)
end

-- Round twenty-two: a present boss note was not clickable, and the renewed
-- war must not resolve to the ancient war embedded in its longer name.
Check(A.LoreNoteResolve("n", "Gyth") == "npc:gyth", "Gyth keeps his existing boss identity")
Check(A.MarkKnownLore("Rend rode Gyth.") == "Rend rode {n:Gyth}.", "Gyth is clickable in ordinary journal prose")
Check(A.LoreNoteResolve("p", "Second War of the Shifting Sands") == "event:second-war-shifting-sands", "renewed campaign has its own identity")
Check(A.LoreNoteResolve("p", "War of the Shifting Sands") == "event:shifting-sands", "ancient war remains separate")
Check(A.LoreNoteResolve("p", "Ahn'Qiraj War") == "event:second-war-shifting-sands", "modern war alias reaches the renewed campaign")
Check(A.MarkKnownLore("Second War of the Shifting Sands") == "{p:Second War of the Shifting Sands}", "complete modern war name wins over ancient substring")
Check(A.MarkKnownLore("Ahn'Qiraj War") == "{p:Ahn'Qiraj War}", "alternate modern war name links in full")
for _, entry in ipairs({
    {"Perenolde Tiara", "artifact:perenolde-tiara", "The Perenolde Tiara"},
    {"Tablet of the Seven", "artifact:tablet-seven", "Tablet of the Seven"},
    {"Chained Essence of Eranikus", "artifact:chained-essence-eranikus", "The Essence of Eranikus"},
}) do
    local name, id, quest = unpack(entry)
    Check(A.LoreNoteResolve("p", name) == id, "explicit artifact lookup remains available: " .. name)
    Check(A.LoreNoteResolve("q", quest) ~= id, "quest title must not resolve as an artifact: " .. quest)
    Check(A.MarkKnownLore("We finished " .. quest .. ".") == "We finished " .. quest .. ".", "artifact name cannot capture a plain quest title: " .. quest)
    Check(A.MarkKnownLore("{q:" .. quest .. "}") == "{q:" .. quest .. "}", "quest markup remains opaque: " .. quest)
    local title = A.GetLoreNote(id).title
    Check(A.MarkKnownLore(title) == "{p:" .. title .. "}", "qualified artifact name links in full: " .. title)
end
for _, entry in ipairs({
    {"Troggs", "people:troggs"}, {"Naga", "people:naga"},
    {"Night elves", "people:night-elves"}, {"Tauren", "people:tauren"},
    {"Gnolls", "people:gnolls"}, {"Goblins", "people:goblins"},
}) do
    local name, id = unpack(entry)
    Check(A.LoreNoteResolve("p", name) == id, "people are available for explicit lore lookup: " .. name)
    Check(A.MarkKnownLore(name .. " and " .. name:lower()) == name .. " and " .. name:lower(), "ordinary people names do not create repeated links: " .. name)
end

print("LoreBlindIdentity: " .. checks .. " checks passed")
