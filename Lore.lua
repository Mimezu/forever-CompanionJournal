local _, A = ...
-- What the storyteller knows of the world: how places feel, whose homeland
-- they are, and who waits at the bottom of each dungeon. Only lore, never
-- events: the journal says what happened, this says what the place is.
-- Level ranges come from LoreData.lua (generated).
-- Phrases carry the journal's markup: {p:place or foe}.
local L = {}
A.Lore = L

-- Zones ------------------------------------------------------------------------
-- e: ways to name the place (the short name, a plain noun phrase, one "where"
-- clause; no adjective-first epithets); kind: what it is like.
L.zones = {
    ["Elwynn Forest"] = {kind = "gentle", e = {"{p:Elwynn}", "the farms of {p:Elwynn}", "{p:Elwynn Forest}, where the farms run down to the river"}},
    ["Dun Morogh"] = {kind = "snow", e = {"{p:Dun Morogh}", "the snows of {p:Dun Morogh}", "{p:Dun Morogh}, all ice and pine"}},
    ["Teldrassil"] = {kind = "gentle", e = {"{p:Teldrassil}", "the boughs of {p:Teldrassil}", "{p:Teldrassil}, under the World Tree's canopy"}},
    ["Durotar"] = {kind = "wild", e = {"{p:Durotar}", "the red earth of {p:Durotar}", "{p:Durotar}, all dust and thorn"}},
    ["Mulgore"] = {kind = "gentle", e = {"{p:Mulgore}", "the plains of {p:Mulgore}", "{p:Mulgore}, where the kodo graze"}},
    ["Tirisfal Glades"] = {kind = "dark", e = {"{p:Tirisfal}", "the glades of {p:Tirisfal}", "{p:Tirisfal Glades}, where the dead keep watch"}},
    ["Westfall"] = {kind = "wild", e = {"{p:Westfall}", "the farms of {p:Westfall}", "{p:Westfall}, where the scarecrows walk"}},
    ["Loch Modan"] = {kind = "wild", e = {"{p:Loch Modan}", "the hills of {p:Loch Modan}", "{p:Loch Modan}, below the dam"}},
    ["Darkshore"] = {kind = "coast", e = {"{p:Darkshore}", "the coast of {p:Darkshore}", "{p:Darkshore}, where the sea eats at old ruins"}},
    ["Silverpine Forest"] = {kind = "dark", e = {"{p:Silverpine}", "the pines of {p:Silverpine}", "{p:Silverpine Forest}, where the worgen howl"}},
    ["The Barrens"] = {kind = "wild", e = {"{p:the Barrens}", "the dry grass of {p:the Barrens}", "{p:the Barrens}, under a wide sky"}},
    ["Redridge Mountains"] = {kind = "wild", e = {"{p:Redridge}", "the hills of {p:Redridge}", "{p:Redridge}, where the gnolls grow bold"}},
    ["Stonetalon Mountains"] = {kind = "mountains", e = {"{p:Stonetalon}", "the peaks of {p:Stonetalon}", "{p:Stonetalon}, scarred by goblin saws"}},
    ["Ashenvale"] = {kind = "forest", e = {"{p:Ashenvale}", "the woods of {p:Ashenvale}", "{p:Ashenvale}, where the Sentinels keep watch"}},
    ["Duskwood"] = {kind = "dark", e = {"{p:Duskwood}", "the woods of {p:Duskwood}", "{p:Duskwood}, where the sun never quite rises"}},
    ["Wetlands"] = {kind = "swamp", e = {"{p:the Wetlands}", "the marshes of {p:the Wetlands}", "{p:the Wetlands}, all reed and rain"}},
    ["Hillsbrad Foothills"] = {kind = "wild", e = {"{p:Hillsbrad}", "the farmlands of {p:Hillsbrad}", "{p:Hillsbrad}, between Southshore and Tarren Mill"}},
    ["Thousand Needles"] = {kind = "desert", e = {"{p:Thousand Needles}", "the mesas of {p:Thousand Needles}", "{p:Thousand Needles}, among the stone spires"}},
    ["Alterac Mountains"] = {kind = "snow", e = {"{p:Alterac}", "the heights of {p:Alterac}", "{p:Alterac}, in the ruins of a fallen kingdom"}},
    ["Arathi Highlands"] = {kind = "wild", e = {"{p:Arathi}", "the highlands of {p:Arathi}", "{p:Arathi}, among the ruins of old Stromgarde"}},
    ["Desolace"] = {kind = "desert", e = {"{p:Desolace}", "the wastes of {p:Desolace}", "{p:Desolace}, where the centaur clans make war"}},
    ["Stranglethorn Vale"] = {kind = "jungle", e = {"{p:Stranglethorn}", "the jungles of {p:Stranglethorn}", "{p:Stranglethorn Vale}, where the tigers hunt"}},
    ["Dustwallow Marsh"] = {kind = "swamp", e = {"{p:Dustwallow}", "the swamps of {p:Dustwallow}", "{p:Dustwallow Marsh}, in the black dragonflight's shadow"}},
    ["Badlands"] = {kind = "desert", e = {"{p:the Badlands}", "the red rock of {p:the Badlands}", "{p:the Badlands}, where the dragons' bones bake"}},
    ["Swamp of Sorrows"] = {kind = "swamp", e = {"{p:the Swamp of Sorrows}", "the groves of {p:the Swamp of Sorrows}", "{p:the Swamp of Sorrows}, heavy with mist"}},
    ["Feralas"] = {kind = "jungle", e = {"{p:Feralas}", "the forests of {p:Feralas}", "{p:Feralas}, among the giants' ruins"}},
    ["The Hinterlands"] = {kind = "wild", e = {"{p:the Hinterlands}", "the hills of {p:the Hinterlands}", "{p:the Hinterlands}, where the gryphons nest"}},
    ["Tanaris"] = {kind = "desert", e = {"{p:Tanaris}", "the dunes of {p:Tanaris}", "{p:Tanaris}, all sand and sun"}},
    ["Searing Gorge"] = {kind = "fire", e = {"{p:the Searing Gorge}", "the pits of {p:the Searing Gorge}", "{p:the Searing Gorge}, in the Dark Irons' shadow"}},
    ["Azshara"] = {kind = "coast", e = {"{p:Azshara}", "the coast of {p:Azshara}", "{p:Azshara}, among the ruins of an old empire"}},
    ["Blasted Lands"] = {kind = "fire", e = {"{p:the Blasted Lands}", "the broken earth of {p:the Blasted Lands}", "{p:the Blasted Lands}, below the Dark Portal"}},
    ["Un'Goro Crater"] = {kind = "jungle", e = {"{p:Un'Goro}", "the crater of {p:Un'Goro}", "{p:Un'Goro Crater}, where the old beasts roam"}},
    ["Felwood"] = {kind = "plague", e = {"{p:Felwood}", "the woods of {p:Felwood}", "{p:Felwood}, poisoned by the Legion"}},
    ["Burning Steppes"] = {kind = "fire", e = {"{p:the Burning Steppes}", "the ash fields of {p:the Burning Steppes}", "{p:the Burning Steppes}, below Blackrock Mountain"}},
    ["Western Plaguelands"] = {kind = "plague", e = {"{p:the Western Plaguelands}", "the farms of {p:the Western Plaguelands}", "{p:the Western Plaguelands}, where the Scourge still walks"}},
    ["Eastern Plaguelands"] = {kind = "plague", e = {"{p:the Eastern Plaguelands}", "the dead country of {p:the Eastern Plaguelands}", "{p:the Eastern Plaguelands}, in the Scourge's heartland"}},
    ["Winterspring"] = {kind = "snow", e = {"{p:Winterspring}", "the snows of {p:Winterspring}", "{p:Winterspring}, all frost and silence"}},
    ["Silithus"] = {kind = "desert", e = {"{p:Silithus}", "the sands of {p:Silithus}", "{p:Silithus}, where the silithid dig their hives"}},
    ["Deadwind Pass"] = {kind = "dark", e = {"{p:Deadwind Pass}", "{p:Deadwind}", "{p:Deadwind Pass}, below Karazhan"}},
    ["Moonglade"] = {kind = "gentle", e = {"{p:Moonglade}", "the glades of {p:Moonglade}", "{p:Moonglade}, where the druids gather"}},
    ["Zephras Isle"] = {kind = "gentle", e = {"{p:Zephras}", "{p:Zephras Isle}", "{p:Zephras Isle}, adrift on the winds"}},
    -- Forever 1.60.1 zones (warcraft.wiki.gg Riverglades, Shen'dralas, Mount Hyjal
    -- (Forever), Darkspear Islands; each name opens its lore note).
    ["Riverglades"] = {kind = "wild", e = {"{p:the Riverglades}", "the river valleys of {p:the Riverglades}", "{p:the Riverglades}, where the Brotherhood of the Horse holds Farholde"}},
    ["Shen'dralas"] = {kind = "mountains", e = {"{p:Shen'dralas}", "the crags of {p:Shen'dralas}", "{p:Shen'dralas}, among Highborne ruins south of Desolace"}},
    ["Mount Hyjal"] = {kind = "forest", e = {"{p:Mount Hyjal}", "the slopes of {p:Hyjal}", "{p:Mount Hyjal}, below the World Tree"}},
    ["Darkspear Islands"] = {kind = "coast", e = {"the {p:Darkspear Islands}", "the shores of the {p:Darkspear Islands}", "the {p:Darkspear Islands}, ceremonial ground of the Darkspear trolls"}},
    -- Cities
    ["Orgrimmar"] = {kind = "city", e = {"{p:Orgrimmar}", "the streets of {p:Orgrimmar}", "{p:Orgrimmar}, the Warchief's city"}},
    ["Undercity"] = {kind = "city", e = {"{p:the Undercity}", "the halls of {p:the Undercity}", "{p:the Undercity}, beneath the ruins of Lordaeron"}},
    ["Thunder Bluff"] = {kind = "city", e = {"{p:Thunder Bluff}", "the bluffs of {p:Thunder Bluff}", "{p:Thunder Bluff}, high above Mulgore"}},
    ["Stormwind City"] = {kind = "city", e = {"{p:Stormwind}", "the streets of {p:Stormwind}", "{p:Stormwind}, the king's city"}},
    ["Ironforge"] = {kind = "city", e = {"{p:Ironforge}", "the halls of {p:Ironforge}", "{p:Ironforge}, around the Great Forge"}},
    ["Darnassus"] = {kind = "city", e = {"{p:Darnassus}", "the gardens of {p:Darnassus}", "{p:Darnassus}, high in the World Tree"}},
}
-- Other names the game may show for the same places.
L.zones["Stormwind"] = L.zones["Stormwind City"]
L.zones["The Riverglades"] = L.zones["Riverglades"]
L.zones["The Undercity"] = L.zones["Undercity"]

-- Homelands: race (the game's race file) -> the places that are home.
L.homes = {
    Human = {"Elwynn Forest", "Stormwind City", "Westfall", "Redridge Mountains", "Duskwood"},
    Dwarf = {"Dun Morogh", "Ironforge", "Loch Modan", "Wetlands"},
    Gnome = {"Dun Morogh", "Ironforge"},
    NightElf = {"Teldrassil", "Darnassus", "Darkshore", "Ashenvale"},
    Orc = {"Durotar", "Orgrimmar"},
    Troll = {"Durotar", "Orgrimmar", "Stranglethorn Vale"},
    Tauren = {"Mulgore", "Thunder Bluff"},
    Scourge = {"Tirisfal Glades", "Undercity"},
}
-- The people of each race, as the storyteller names them.
L.peoples = {Human = "human", Dwarf = "dwarf", Gnome = "gnome", NightElf = "night elf", Orc = "orc", Troll = "troll",
    Tauren = "tauren", Scourge = "Forsaken"}
-- Forever's sky elves (whatever the game calls their race file).
local function SkyElf(race) return type(race) == "string" and (race:find("Sky") or race:find("Shen")) ~= nil end
-- Where each people begins (the first zone of a new life).
L.starts = {Human = "Elwynn Forest", Dwarf = "Dun Morogh", Gnome = "Dun Morogh", NightElf = "Teldrassil", Orc = "Durotar", Troll = "Durotar",
    Tauren = "Mulgore", Scourge = "Tirisfal Glades", Skyborne = "Zephras Isle"}
-- The Skyborne begin on Zephras Isle (warcraft.wiki.gg Zephras Isle; LoreForever
-- UI RACE_START). Trolls still begin in Durotar: Forever's Darkspear Islands are a
-- battleground, not a starting zone (LoreForever zone:darkspearislands).
function L.IsStart(race, zone)
    if not race or not zone then return false end
    if SkyElf(race) then return zone == "Zephras Isle" end
    return L.starts[race] == zone
end
function L.IsHome(race, zone)
    if not race or not zone then return false end
    if SkyElf(race) then return zone == "Zephras Isle" end
    for _, place in ipairs(L.homes[race] or {}) do if place == zone then return true end end
    return false
end
function L.People(race)
    if SkyElf(race) then return "shen'dorei" end
    return L.peoples[race]
end

-- Inns and taverns (a rest there is "at the inn").
L.innWords = {"Inn", "Tavern", "Distillery", "Lodge", "Rest"}

-- Dungeons -----------------------------------------------------------------------
-- e: ways to name it; lore: a clause about what it is (after a comma).
L.dungeons = {
    ["Ragefire Chasm"] = {e = {"{p:Ragefire Chasm}", "the caves of {p:Ragefire Chasm}"},
        lore = {"where the Searing Blade hid beneath Orgrimmar", "a lava cave crawling with troggs"}},
    ["Wailing Caverns"] = {e = {"the {p:Wailing Caverns}"},
        lore = {"where the Druids of the Fang went mad in their dreams", "where Naralex lies dreaming"}},
    ["The Deadmines"] = {e = {"{p:the Deadmines}", "the tunnels of {p:the Deadmines}"},
        lore = {"where the Defias built their secret ship", "beneath the ruins of Moonbrook"}},
    ["Shadowfang Keep"] = {e = {"{p:Shadowfang Keep}"},
        lore = {"where Arugal held court", "the keep Arugal took from the Silverlaines"}},
    ["Blackfathom Deeps"] = {e = {"{p:Blackfathom Deeps}", "the flooded temple of {p:Blackfathom Deeps}"},
        lore = {"where the Twilight's Hammer worships in the dark water", "a sunken temple of the night elves"}},
    ["The Stockade"] = {e = {"{p:the Stockade}", "the cells of {p:the Stockade}"},
        lore = {"Stormwind's prison, taken by its own inmates", "where the riot never ended"}},
    ["Gnomeregan"] = {e = {"{p:Gnomeregan}", "the halls of {p:Gnomeregan}"},
        lore = {"the gnomes' lost capital", "where the troggs came up from below"}},
    ["Razorfen Kraul"] = {e = {"{p:Razorfen Kraul}", "the thorn maze of {p:Razorfen Kraul}"},
        lore = {"the quilboar's thorned stronghold", "where the quilboar hide behind their briars"}},
    ["Scarlet Monastery"] = {e = {"the {p:Scarlet Monastery}", "the halls of the {p:Scarlet Monastery}"},
        lore = {"the Crusade's stronghold", "where the zealots keep their fires lit"}},
    ["Razorfen Downs"] = {e = {"{p:Razorfen Downs}", "the barrows of {p:Razorfen Downs}"},
        lore = {"where the Scourge found the quilboar", "a quilboar tomb gone cold"}},
    ["Uldaman"] = {e = {"{p:Uldaman}", "the titan vaults of {p:Uldaman}"},
        lore = {"older than any kingdom", "where the stone keepers wait"}},
    ["Zul'Farrak"] = {e = {"{p:Zul'Farrak}", "the troll city of {p:Zul'Farrak}"},
        lore = {"the Sandfury trolls' desert city", "where the sand trolls keep their idols"}},
    ["Maraudon"] = {e = {"{p:Maraudon}", "the caverns of {p:Maraudon}"},
        lore = {"holy ground to the centaur", "where Theradras sleeps in the stone"}},
    ["The Temple of Atal'Hakkar"] = {e = {"the {p:Sunken Temple}", "the {p:Temple of Atal'Hakkar}"},
        lore = {"where the Atal'ai called their blood god", "drowned in the Swamp of Sorrows"}},
    ["Blackrock Depths"] = {e = {"{p:Blackrock Depths}", "the Dark Iron city of {p:Blackrock Depths}"},
        lore = {"the Dark Irons' capital", "at the heart of the mountain"}},
    ["Blackrock Spire"] = {e = {"{p:Blackrock Spire}", "the heights of {p:Blackrock Spire}"},
        lore = {"where the Blackrock orcs and their dragons hold the mountain", "Rend Blackhand's fortress"}},
    ["Dire Maul"] = {e = {"{p:Dire Maul}", "the ruins of {p:Dire Maul}"},
        lore = {"old Eldre'Thalas, overrun by ogres and worse", "where the Highborne's ghosts still linger"}},
    ["Stratholme"] = {e = {"{p:Stratholme}", "the streets of {p:Stratholme}"},
        lore = {"the city Arthas purged", "where the Scourge and the Crusade fight over the ashes"}},
    ["Scholomance"] = {e = {"the {p:Scholomance}", "the crypts of the {p:Scholomance}"},
        lore = {"the Cult of the Damned's school of necromancy", "where necromancers learn their craft"}},
    ["Molten Core"] = {e = {"the {p:Molten Core}"},
        lore = {"the Firelord's domain", "at the heart of Blackrock Mountain"}},
    ["Onyxia's Lair"] = {e = {"{p:Onyxia's Lair}", "the Broodmother's lair"},
        lore = {"where the black dragon waits on her hoard", "deep in Dustwallow Marsh"}},
    ["Blackwing Lair"] = {e = {"{p:Blackwing Lair}", "the halls of {p:Blackwing Lair}"},
        lore = {"Nefarian's laboratory of dragons", "at the top of the mountain"}},
    ["Zul'Gurub"] = {e = {"{p:Zul'Gurub}", "the jungle city of {p:Zul'Gurub}"},
        lore = {"where the Gurubashi called the Soulflayer back", "the blood god's temple city"}},
    ["Ruins of Ahn'Qiraj"] = {e = {"the {p:Ruins of Ahn'Qiraj}"}, lore = {"at the gates of the silithid empire"}},
    ["Ahn'Qiraj Temple"] = {e = {"{p:Ahn'Qiraj}", "the {p:Temple of Ahn'Qiraj}"}, lore = {"where an old god dreams beneath the sand"}},
    ["Naxxramas"] = {e = {"{p:Naxxramas}", "the necropolis of {p:Naxxramas}"}, lore = {"Kel'Thuzad's floating citadel"}},
    ["Ruins of Lordaeron"] = {e = {"the {p:Ruins of Lordaeron}", "the fallen capital above the {p:Undercity}"},
        lore = {"where the Scourge still roam the old streets", "above the Forsaken's own halls"}},
    ["The Hall of Thanes"] = {e = {"the {p:Hall of Thanes}", "the tombs beneath old Ironforge"},
        lore = {"where the old kings of Ironforge rest, or tried to", "below old Ironforge"}},
    -- Forever 1.60.1 dungeon and raids (warcraft.wiki.gg Krol'dok Stronghold,
    -- Mount Hyjal (Forever); LoreForever zone:hyjal for the Druids of the Claw).
    ["Krol'dok Stronghold"] = {e = {"{p:Krol'dok Stronghold}", "the ogre fortress of {p:Krol'dok}"},
        lore = {"where the Twilight's Hammer ogres hold the walls", "where the Horde fled after the siege of Farholde failed"}},
    ["Barrow Deeps"] = {e = {"the {p:Barrow Deeps}", "the barrow dens of the {p:Barrow Deeps}"},
        lore = {"where the Druids of the Claw slept beneath Hyjal", "deep under Mount Hyjal"}},
    ["Hyjal Summit"] = {e = {"{p:Hyjal Summit}", "the summit of {p:Hyjal}"},
        lore = {"beneath Nordrassil, the World Tree", "where Archimonde fell at the roots of the World Tree"}},
}
L.dungeons["Sunken Temple"] = L.dungeons["The Temple of Atal'Hakkar"]
L.dungeons["Deadmines"] = L.dungeons["The Deadmines"]
L.dungeons["Stormwind Stockade"] = L.dungeons["The Stockade"]
local DUNGEON_ALIASES = {['Sunken Temple'] = "The Temple of Atal'Hakkar", Deadmines = 'The Deadmines',
    ['Stormwind Stockade'] = 'The Stockade', ["Temple of Ahn'Qiraj"] = "Ahn'Qiraj Temple",
    ['Hall of Thanes'] = 'The Hall of Thanes'}
for alias, canonical in pairs(DUNGEON_ALIASES) do L.dungeons[alias] = L.dungeons[canonical] end

-- Bosses -------------------------------------------------------------------------
-- kind: undead, demon, beast, humanoid, dragon, elemental, giant, construct,
-- aberration (the storyteller picks its verbs from it); e: who they were;
-- last: the dungeon's master (a bigger moment); after: what its death meant,
-- said once, on the first kill, without claiming unseen later victories.
local B = {}
L.bosses = B
local function Add(kind, list)
    for name, info in pairs(list) do
        info.kind = info.kind or kind
        B[name] = info
    end
end
-- Ragefire Chasm
Add("humanoid", {
    ["Oggleflint"] = {e = "the chieftain of the chasm's troggs"},
    -- Neeru names Taragaman in 5761; Thrall identifies Jergosh and Bazzalan
    -- as the leaders in 5728. Keep Neeru's claim out of omniscient narration.
    ["Taragaman the Hungerer"] = {e = "the felguard of Ragefire Chasm", kind = "demon", last = true, after = "One of the Searing Blade's demons lay dead beneath Orgrimmar.", afterMore = {"The felguard beneath Orgrimmar had fallen.", "The Searing Blade had lost the demon it summoned under the city."}},
    ["Jergosh the Invoker"] = {e = "the warlock who led the Searing Blade's rites"},
    ["Bazzalan"] = {e = "the satyr who kept the Searing Blade's deepest cave", kind = "demon"},
})
-- Wailing Caverns
Add("humanoid", {
    ["Lady Anacondra"] = {e = "the first of the four Fang lords, a priestess of the serpent"},
    ["Lord Cobrahn"] = {e = "a lord of the Fang, lost to Naralex's nightmare"},
    ["Lord Pythas"] = {e = "a Fang druid who had taken the serpent's shape"},
    ["Lord Serpentis"] = {e = "the last of the four Fang lords"},
    ["Kresh"] = {e = "the great turtle of the caverns", kind = "beast"},
    ["Skum"] = {e = "the thunder lizard of the deep pools", kind = "beast"},
    ["Verdan the Everliving"] = {e = "a keeper of the grove gone wrong in the dream", kind = "elemental"},
    ["Mutanus the Devourer"] = {e = "the murloc horror in Naralex's dream", kind = "aberration", last = true, after = "The nightmare's devourer had fallen.", afterMore = {"The devourer from Naralex's nightmare lay defeated.", "The deepest pool of the caverns had lost its horror."}},
    ["Mad Magglish"] = {e = "a goblin who wandered too deep"},
})
-- The Deadmines
Add("humanoid", {
    ["Rhahk'Zor"] = {e = "the ogre who kept the first door of the mine", kind = "giant"},
    ["Sneed"] = {e = "the goblin in his shredder"},
    ["Sneed's Shredder"] = {e = "Sneed's shredder", kind = "construct"},
    ["Gilnid"] = {e = "the goblin who ran the Defias foundry"},
    ["Mr. Smite"] = {e = "VanCleef's first mate"},
    ["Captain Greenskin"] = {e = "the goblin captain of the Defias ship"},
    ["Edwin VanCleef"] = {e = "the master of the Defias Brotherhood", last = true, after = "The Defias Brotherhood had lost its master.", afterMore = {"Westfall was rid of Edwin VanCleef.", "The Defias ship had lost its master.", "The mason who had made a brotherhood of Stormwind's unpaid men was dead."}},
    ["Cookie"] = {e = "the murloc cook of the Defias ship", kind = "beast"},
})
-- Shadowfang Keep
Add("humanoid", {
    ["Rethilgore"] = {e = "the worgen who kept Arugal's prisoners", kind = "beast"},
    ["Razorclaw the Butcher"] = {e = "the worgen of the keep's kitchens", kind = "beast"},
    ["Baron Silverlaine"] = {e = "the keep's old lord, restless in death", kind = "undead"},
    ["Commander Springvale"] = {e = "a paladin of Lordaeron who had not stayed dead", kind = "undead"},
    ["Odo the Blindwatcher"] = {e = "the blind worgen of the tower", kind = "beast"},
    ["Fenrus the Devourer"] = {e = "the wolf Arugal kept in the keep", kind = "beast"}, -- Classic NPC 4274
    ["Wolf Master Nandos"] = {e = "the keeper of Arugal's wolves", kind = "beast"},
    ["Archmage Arugal"] = {e = "the mad archmage who brought the worgen", last = true, after = "Silverpine was rid of Arugal, for now."},
})
-- Blackfathom Deeps
Add("humanoid", {
    ["Ghamoo-ra"] = {e = "the great turtle of the first pool", kind = "beast"},
    ["Lady Sarevess"] = {e = "the naga witch of the drowned halls"},
    ["Gelihast"] = {e = "the chief of the temple's murlocs", kind = "beast"},
    ["Lorgus Jett"] = {e = "a priest of the Twilight's Hammer"},
    ["Baron Aquanis"] = {e = "a lord of water called up at the cult's altar", kind = "elemental"},
    ["Twilight Lord Kelris"] = {e = "the high priest of the Twilight's Hammer in the deeps"},
    ["Old Serra'kis"] = {e = "the old shark of the flooded halls", kind = "beast"},
    ["Aku'mai"] = {e = "the Old Gods' hydra in the deep water", kind = "beast", last = true, after = "The hydra the cult had fed lay still.", afterMore = {"The Twilight's Hammer had lost the thing it fed in the deep water.", "The deep water of Blackfathom had lost its god."}},
})
-- The Stockade
Add("humanoid", {
    ["Targorr the Dread"] = {e = "the worst of the Stockade's inmates"},
    ["Kam Deepfury"] = {e = "a Dark Iron held in the Stockade for his politics"},
    ["Hamhock"] = {e = "the ogre in the cells", kind = "giant"},
    ["Dextren Ward"] = {e = "a murderer loose in the cells"},
    ["Bazil Thredd"] = {e = "the leader of the riot", last = true, after = "The riot had lost its leader.", afterMore = {"The Stockade's riot had no one left to lead it.", "Stormwind's prison had lost the man who raised it."}},
    ["Bruegal Ironknuckle"] = {e = "the dwarf in the far cell"},
})
-- Gnomeregan
Add("humanoid", {
    ["Grubbis"] = {e = "the trogg who led the diggers into the city"},
    ["Viscous Fallout"] = {e = "a living pool of the city's fallout", kind = "aberration"},
    ["Electrocutioner 6000"] = {e = "a war machine of Gnomeregan, still running", kind = "construct"},
    ["Crowd Pummeler 9-60"] = {e = "a riot machine of Gnomeregan", kind = "construct"},
    ["Mekgineer Thermaplugg"] = {e = "the traitor who drowned Gnomeregan in radiation", last = true, after = "Gnomeregan's traitor was dead.", afterMore = {"The lowest halls of Gnomeregan had lost their master.", "The gnome who had flooded his own city with radiation was dead."}},
})
-- Razorfen Kraul and Downs
Add("humanoid", {
    ["Roogug"] = {e = "a geomancer of the Kraul"},
    ["Aggem Thorncurse"] = {e = "a prophet of the Death's Head"},
    ["Death Speaker Jargba"] = {e = "a priest of the Death's Head"},
    ["Overlord Ramtusk"] = {e = "the overlord of the Kraul's warriors"},
    ["Agathelos the Raging"] = {e = "the boar the quilboar kept as their god's champion", kind = "beast"},
    ["Charlga Razorflank"] = {e = "the quilboar matriarch", last = true, after = "The Kraul had lost its matriarch.", afterMore = {"The quilboar of the Kraul had no matriarch left to gather their army.", "Charlga's army would gather without her."}},
    ["Tuten'kash"] = {e = "the great spider the gong of the Downs called up", kind = "beast"},
    ["Mordresh Fire Eye"] = {e = "a quilboar raised to serve the Scourge", kind = "undead"}, -- Classic NPC 7357
    ["Glutton"] = {e = "a bloated horror of the Scourge", kind = "undead"},
    ["Amnennar the Coldbringer"] = {e = "the lich who rules the Downs", kind = "undead", last = true, after = "The Downs had lost their lich.", afterMore = {"The Scourge's hold on the Razorfen had lost its lich.", "The quilboar of the Downs had no lich left to serve."}},
})
-- Scarlet Monastery
Add("humanoid", {
    ["Interrogator Vishas"] = {e = "the Crusade's torturer in the crypts"},
    ["Bloodmage Thalnos"] = {e = "a Crusader risen from the graveyard", kind = "undead"},
    ["Houndmaster Loksey"] = {e = "the keeper of the Crusade's hounds"},
    ["Arcanist Doan"] = {e = "the keeper of the Crusade's library"},
    ["Herod"] = {e = "the Scarlet Champion"},
    ["Scarlet Commander Mograine"] = {e = "the commander of the Crusade's garrison"},
    ["High Inquisitor Whitemane"] = {e = "the high inquisitor the Crusade believed could raise its dead", last = true, after = "The Crusade had lost its high inquisitor.", afterMore = {"The cathedral of the monastery had lost its high inquisitor.", "The Crusade's fallen in the cathedral would not rise again."}},
    ["High Inquisitor Fairbanks"] = {e = "an inquisitor the Crusade had forgotten in its own cathedral", kind = "undead"},
})
-- Uldaman
Add("humanoid", {
    ["Revelosh"] = {e = "a trogg who had learned the titans' sorcery"},
    ["Baelog"] = {e = "a dwarf of the League who went too deep"},
    ["Ironaya"] = {e = "a guardian the titans forged and left behind", kind = "construct"},
    ["Obsidian Sentinel"] = {e = "a sentinel of living stone", kind = "construct"},
    ["Ancient Stone Keeper"] = {e = "a keeper of the titans' stone", kind = "construct"},
    ["Galgann Firehammer"] = {e = "the Dark Iron who led the diggers in the vault"},
    ["Grimlok"] = {e = "the king of the vault's troggs"},
    ["Archaedas"] = {e = "the ancient stone watcher", kind = "construct", last = true, after = "The ancient stone watcher no longer barred the way.", afterMore = {"The vault of the titans had lost its keeper.", "The discs of Uldaman lay unguarded."}},
})
-- Zul'Farrak
Add("humanoid", {
    ["Antu'sul"] = {e = "the overseer of the Sandfury's basilisks"},
    ["Witch Doctor Zum'rah"] = {e = "the witch doctor who kept the Sandfury's dead"},
    ["Hydromancer Velratha"] = {e = "the hydromancer of the sacred pool"},
    ["Gahz'rilla"] = {e = "the hydra called up out of the sacred pool", kind = "beast"},
    ["Sergeant Bly"] = {e = "a treasure hunter in over his head"},
    ["Theka the Martyr"] = {e = "a Sandfury martyr, dead and still fighting"},
    ["Nekrum Gutchewer"] = {e = "a Sandfury priest who raised the dead of the pyramid", kind = "undead"},
    ["Shadowpriest Sezz'ziz"] = {e = "the shadowpriest of the pyramid"},
    ["Chief Ukorz Sandscalp"] = {e = "the Sandfury chieftain", last = true, after = "The Sandfury would need a new chief.", afterMore = {"Zul'Farrak had lost its chief.", "The Sandfury of Zul'Farrak were without a chief."}},
})
-- Maraudon
Add("humanoid", {
    ["Noxxion"] = {e = "a horror of the poisoned caves", kind = "elemental"},
    ["Razorlash"] = {e = "a thorned beast of the caverns", kind = "beast"},
    -- Quest 7044 names Vyletongue as a satyr and Celebras as cursed;
    -- 7046 describes Celebras's living work after the encounter. Neither
    -- supports the old 'sons of Zaetar' or undead characterization.
    ["Lord Vyletongue"] = {e = "the satyr spreading corruption through Maraudon", kind = "demon"},
    ["Celebras the Cursed"] = {e = "a keeper lost in Maraudon's corruption", victory = {"{p:Celebras the Cursed} was overcome, freeing the keeper from his curse.", "The fight with {p:Celebras the Cursed} ended with the keeper freed from his curse."}},
    ["Landslide"] = {e = "a landslide that walked", kind = "elemental"},
    ["Tinkerer Gizlock"] = {e = "a goblin tinkerer lost in the caves"},
    ["Rotgrip"] = {e = "the crocolisk of the deep lake", kind = "beast"},
    ["Princess Theradras"] = {e = "the earth's daughter", kind = "elemental", last = true, after = "Maraudon was free of Theradras, for now.", afterMore = {"Zaetar's remains lay without their keeper.", "The earth under Desolace had lost its princess."}},
})
-- Sunken Temple
Add("humanoid", {
    ["Atal'alarion"] = {e = "the guardian the Atal'ai set over their idol", kind = "construct"},
    ["Dreamscythe"] = {e = "the first of the temple's green dragons", kind = "dragon"},
    ["Weaver"] = {e = "a green dragon set to guard the temple", kind = "dragon"},
    ["Jammal'an the Prophet"] = {e = "the prophet who led the Atal'ai"},
    ["Morphaz"] = {e = "a green dragon turned by the nightmare", kind = "dragon"},
    ["Hazzas"] = {e = "the last of the temple's four dragons", kind = "dragon"},
    ["Avatar of Hakkar"] = {e = "the blood god's avatar, called up at the altar", kind = "demon"},
    ["Shade of Eranikus"] = {e = "the shade of the green dragon consort", kind = "dragon", last = true, after = "The shade had fallen within the sunken temple.", afterMore = {"The deepest hall of the temple had lost its dragon.", "Eranikus's shade no longer kept the altar of Hakkar."}},
})
-- Blackrock Depths
Add("humanoid", {
    ["Lord Roccor"] = {e = "a lord of fire and stone at the gate of the depths", kind = "elemental"},
    ["High Interrogator Gerstahn"] = {e = "the Dark Iron who ran the prison of the depths"},
    ["Houndmaster Grebmar"] = {e = "the keeper of the Dark Irons' hounds"},
    ["Bael'Gar"] = {e = "a giant of living magma", kind = "elemental"},
    ["Lord Incendius"] = {e = "Ragnaros' servant at the Black Anvil", kind = "elemental"},
    ["Fineous Darkvire"] = {e = "the chief architect of the Dark Irons"},
    ["Pyromancer Loregrain"] = {e = "a pyromancer of the Dark Irons"},
    ["Warder Stilgiss"] = {e = "the warder of the Dark Irons' vault"},
    ["General Angerforge"] = {e = "the general of the Dark Iron army"},
    ["Golem Lord Argelmach"] = {e = "the master of the Dark Iron golems"},
    ["Hurley Blackbreath"] = {e = "a brewer with a grudge"},
    ["Plugger Spazzring"] = {e = "the barkeep of the depths' tavern"},
    ["Ambassador Flamelash"] = {e = "Ragnaros' ambassador to the Dark Irons", kind = "elemental"},
    ["Magmus"] = {e = "the golem at the throne room's gate", kind = "construct"},
    ["Princess Moira Bronzebeard"] = {e = "King Magni's daughter"},
    ["Emperor Dagran Thaurissan"] = {e = "the Dark Iron emperor", last = true, after = "The Dark Iron empire had lost its emperor.", afterMore = {"Shadowforge City had lost its emperor.", "The throne of the Dark Irons stood empty."}},
})
-- Blackrock Spire
Add("humanoid", {
    ["Highlord Omokk"] = {e = "the ogre highlord of the lower spire", kind = "giant"},
    ["Shadow Hunter Vosh'gajin"] = {e = "a shadow hunter of the spire's trolls"},
    ["War Master Voone"] = {e = "the war master of the spire's trolls"},
    ["Mother Smolderweb"] = {e = "the spider queen of the spire", kind = "beast"},
    ["Urok Doomhowl"] = {e = "an ogre champion called up by his own banner", kind = "giant"},
    ["Quartermaster Zigris"] = {e = "the quartermaster of the Blackrock orcs"},
    ["Halycon"] = {e = "the worg mother of the spire", kind = "beast"},
    ["Gizrul the Slavener"] = {e = "the great worg of the spire's kennels", kind = "beast"},
    ["Overlord Wyrmthalak"] = {e = "the Blackrock overlord", last = true, after = "The lower Spire had lost its overlord.", afterMore = {"The Blackrock orcs of the lower spire were without their overlord."}},
    ["Pyroguard Emberseer"] = {e = "the fire elemental the orcs kept bound in the spire", kind = "elemental"},
    ["Warchief Rend Blackhand"] = {e = "the false warchief of the Dark Horde"},
    ["Gyth"] = {e = "the dragon Rend rode into his arena", kind = "dragon"},
    ["The Beast"] = {e = "the hound of the upper spire", kind = "beast"}, -- Classic NPC 10430
    ["General Drakkisath"] = {e = "the black dragon general of the Spire", kind = "dragon", last = true, after = "The Spire had lost its dragon general.", afterMore = {"Nefarian had lost his general.", "The black dragons of the spire had lost their general."}},
})
-- Dire Maul
Add("humanoid", {
    ["Zevrim Thornhoof"] = {e = "a satyr of the east wing", kind = "demon"},
    ["Hydrospawn"] = {e = "a water elemental of the eastern pools", kind = "elemental"},
    -- Quests 7488/7489 identify the mage and the purpose of her web.
    ["Lethtendris"] = {e = "the blood elf mage siphoning Dire Maul's magic"},
    ["Alzzin the Wildshaper"] = {e = "the satyr who corrupted the gardens", kind = "demon", last = true, after = "The gardens of Dire Maul were rid of Alzzin.", afterMore = {"The eastern halls of Dire Maul had lost their satyr."}},
    ["Tendris Warpwood"] = {e = "a warpwood treant turned against the city", kind = "elemental"},
    ["Illyanna Ravenoak"] = {e = "a night elf ghost of the old city", kind = "undead"},
    ["Magister Kalendris"] = {e = "a magister of the Shen'dralar"},
    ["Immol'thar"] = {e = "the demon the Highborne kept imprisoned", kind = "demon"},
    ["Prince Tortheldrin"] = {e = "the prince of the Shen'dralar", last = true, after = "The Shen'dralar had lost their prince.", afterMore = {"The prince who had kept a demon in chains for ten thousand years was dead.", "The Shen'dralar were without their prince."}},
    ["King Gordok"] = {e = "the ogre king", kind = "giant", last = true, after = "The Gordok would need a new king.", afterMore = {"The ogres of Dire Maul had lost their king.", "The throne of the Gordok stood empty."}},
    ["Cho'Rush the Observer"] = {e = "the king's ogre mage", kind = "giant"},
})
-- Stratholme
Add("undead", {
    ["The Unforgiven"] = {e = "a spirit of the city's dead that would not rest"},
    ["Timmy the Cruel"] = {e = "a ghoul of the market square"},
    ["Cannon Master Willey"] = {e = "the Crusade's cannon master", kind = "humanoid"},
    ["Archivist Galford"] = {e = "the keeper of the Crusade's archive", kind = "humanoid"},
    ["Balnazzar"] = {e = "the dreadlord in the Scarlet Bastion", kind = "demon", last = true, after = "The dreadlord had fallen in the Scarlet Bastion.", afterMore = {"The Scarlet Bastion had lost the dreadlord who ruled it."}},
    ["Baroness Anastari"] = {e = "a banshee of the Scourge in her ziggurat"},
    ["Nerub'enkan"] = {e = "a crypt lord of the Scourge"},
    ["Maleki the Pallid"] = {e = "a necromancer of the Scourge in his ziggurat"},
    ["Magistrate Barthilas"] = {e = "the city's magistrate, risen"},
    ["Ramstein the Gorger"] = {e = "the abomination of the slaughterhouse"},
    ["Baron Rivendare"] = {e = "the Scourge's baron", last = true, after = "Stratholme had lost its baron.", afterMore = {"The dead half of Stratholme had lost its baron.", "The slaughterhouse of Stratholme stood without its master."}},
    ["Postmaster Malown"] = {e = "the city's postmaster, still delivering"},
})
-- Scholomance
Add("undead", {
    ["Kirtonos the Herald"] = {e = "the herald of the school, called down by blood", kind = "demon"},
    ["Jandice Barov"] = {e = "the illusionist of house Barov"},
    ["Rattlegore"] = {e = "a golem of bones"},
    ["Ras Frostwhisper"] = {e = "the lich who taught in the Scholomance"},
    ["Instructor Malicia"] = {e = "an instructor of the school"},
    ["Doctor Theolen Krastinov"] = {e = "the Butcher of the Scholomance", kind = "humanoid"},
    ["Lorekeeper Polkelt"] = {e = "the school's lorekeeper"},
    ["The Ravenian"] = {e = "a horror of the lower halls"},
    ["Lord Alexei Barov"] = {e = "the lord of house Barov, dead in his own keep"},
    ["Lady Illucia Barov"] = {e = "the lady of house Barov"},
    ["Darkmaster Gandling"] = {e = "the headmaster of the Scholomance", kind = "humanoid", last = true, after = "The Scholomance had lost its headmaster.", afterMore = {"The school of necromancy had lost its headmaster.", "The Cult of the Damned's classes would meet without their darkmaster."}},
})
-- Raids and great foes
Add("elemental", {
    ["Lucifron"] = {e = "the first of the Firelord's lieutenants", kind = "demon"},
    ["Magmadar"] = {e = "the hound of the Firelord", kind = "beast"},
    ["Gehennas"] = {e = "a lieutenant of the Firelord's court", kind = "demon"},
    ["Garr"] = {e = "a great lord of fire"},
    ["Shazzrah"] = {e = "the Firelord's spellcaster", kind = "demon"},
    ["Baron Geddon"] = {e = "a baron of the fire elementals"},
    ["Sulfuron Harbinger"] = {e = "the Firelord's herald", kind = "demon"},
    ["Golemagg the Incinerator"] = {e = "the giant of the core", kind = "giant"},
    -- NPC 12018's surrender dialogue: success is not the steward's death.
    -- https://www.wowhead.com/classic/npc=12018/majordomo-executus
    ["Majordomo Executus"] = {e = "the Firelord's steward", victory = {"{p:Majordomo Executus} surrendered when his guards were defeated.", "With his guards defeated, {p:Majordomo Executus} submitted."}},
    ["Ragnaros"] = {e = "the Firelord himself", last = true, after = "The Firelord was driven back into the fire, for a time.", afterMore = {"The Molten Core had lost its lord, for a time."}},
    ["Onyxia"] = {e = "the Broodmother of the Black Dragonflight", kind = "dragon", last = true, after = "The Broodmother lay defeated in her lair.", afterMore = {"The black dragonflight had lost its Broodmother.", "The brood under Dustwallow had lost its mother."}},
    ["Razorgore the Untamed"] = {e = "the guardian of Blackwing Lair's eggs", kind = "dragon"}, -- Classic NPC 12435
    ["Vaelastrasz the Corrupt"] = {e = "a red dragon, bound and corrupted in Nefarian's lair", kind = "dragon"},
    ["Broodlord Lashlayer"] = {e = "the broodlord of the lair", kind = "dragon"},
    ["Firemaw"] = {e = "a black drake of the lair", kind = "dragon"},
    ["Ebonroc"] = {e = "a black drake of Nefarian's brood", kind = "dragon"},
    ["Flamegor"] = {e = "the last of the lair's three drakes", kind = "dragon"},
    ["Chromaggus"] = {e = "Nefarian's two-headed experiment", kind = "dragon"},
    ["Nefarian"] = {e = "the lord of Blackwing Lair", kind = "dragon", last = true, after = "Blackwing Lair had lost its lord.", afterMore = {"The son of Deathwing lay dead at the top of the mountain."}},
    ["Hakkar"] = {e = "the Soulflayer, the blood god", kind = "demon", last = true, after = "The Soulflayer was cast out of the world.", afterMore = {"Zul'Gurub had lost its god.", "The Gurubashi had lost the god they had called back."}},
    ["High Priestess Jeklik"] = {e = "the bat priestess of the Gurubashi", kind = "humanoid"},
    ["High Priest Venoxis"] = {e = "the snake priest of the Gurubashi", kind = "humanoid"},
    ["High Priestess Mar'li"] = {e = "the spider priestess of the Gurubashi", kind = "humanoid"},
    ["High Priest Thekal"] = {e = "the tiger priest of the Gurubashi", kind = "humanoid"},
    ["High Priestess Arlokk"] = {e = "the panther priestess of the Gurubashi", kind = "humanoid"},
    ["Bloodlord Mandokir"] = {e = "the bloodlord of the Gurubashi, who rode a raptor", kind = "humanoid"},
    ["Jin'do the Hexxer"] = {e = "the hexxer of Zul'Gurub", kind = "humanoid"},
    ["Ossirian the Unscarred"] = {e = "the unscarred general of the swarm", kind = "aberration", last = true, after = "The swarm's general was dead.", afterMore = {"The ruins of Ahn'Qiraj had lost their general."}},
    ["C'Thun"] = {e = "an old god, waking", kind = "aberration", last = true, after = "An old god lay dead beneath the sand.", afterMore = {"The qiraji had lost the god they served."}},
    ["Kel'Thuzad"] = {e = "the lich lord of Naxxramas", kind = "undead", last = true, after = "Naxxramas had lost its master, for a time.", afterMore = {"The necropolis had lost its lich, for a time."}},
    ["Patchwerk"] = {e = "the Scourge's largest abomination", kind = "undead"},
    ["Sapphiron"] = {e = "the frost wyrm raised to guard the lich's hall", kind = "undead"},
    ["Azuregos"] = {e = "the blue dragon who guarded the ruins of Azshara", kind = "dragon"},
    ["Lord Kazzak"] = {e = "the demon lord of the Tainted Scar", kind = "demon"},
})
-- Forever's own
Add("undead", {
    ["Rath'mael"] = {e = "the necromancer who brought the fog", kind = "humanoid", last = true,
        after = "The fog over the ruins had lost its maker.", afterMore = {"The ruins of Lordaeron had lost the necromancer who fogged them."}},
    ["Durgen Dirgehammer"] = {e = "the Dark Iron commander under Ironforge", kind = "humanoid", last = true,
        after = "The Dark Iron incursion beneath Ironforge had lost its commander.", afterMore = {"The Dark Irons under Ironforge had lost their commander."}},
})
-- Forever's dungeon rosters (warcraft.wiki.gg Ruins of Lordaeron (instance) for the
-- creature type; corpus #95216 for the venom). Every name here opens a lore note
-- (LorePeopleHistory.lua; tests/LoreCatalog.lua requires it).
do
    local RoL = {dungeon = "Ruins of Lordaeron", setting = "Forever", source = "https://warcraft.wiki.gg/wiki/Ruins_of_Lordaeron_(instance)"}
    local function With(base, info) for k, v in pairs(base) do info[k] = info[k] or v end return info end
    Add("undead", {
        ["Witherfang"] = With(RoL, {e = "the spider whose venom ate through undead flesh", kind = "beast",
            source = "StorageInvestigation/journal-voice/quests_corpus.txt #95216 The New Plague; https://warcraft.wiki.gg/wiki/Ruins_of_Lordaeron_(instance)"}),
        -- The Baron's epithet stays public: whose head it wears is a discovery
        -- (LoreDiscoveryData.lua, baron.othmar). Keyed "The Baron", so Stratholme's
        -- "Baron Rivendare" never matches it.
        ["The Baron"] = With(RoL, {e = "an abomination of the ruins"}),
        ["Viktor the Vile"] = With(RoL, {e = "a ghoul of the ruins"}),
        ["The Abandoned"] = With(RoL, {e = "a wraith of the ruins"}),
        ["Bjork"] = With(RoL, {e = "a wight of the ruins"}),
        ["Lordaeron Captain"] = With(RoL, {e = "the ghost of one of Lordaeron's officers"}),
    })
    -- The Hall of Thanes (warcraft.wiki.gg Hall of Thanes (instance); corpus #96395).
    local HoT = {dungeon = "The Hall of Thanes", setting = "Forever", source = "https://warcraft.wiki.gg/wiki/Hall_of_Thanes_(instance)"}
    Add("humanoid", {
        ["Faldrim Anvilmar"] = With(HoT, {e = "a thane kept from rest by an ancient grudge", kind = "undead",
            source = "https://warcraft.wiki.gg/wiki/Hall_of_Thanes_(instance); StorageInvestigation/journal-voice/review/corpus_vanilla_quests.txt #96395 An Ancient Grudge"}),
        ["Magmatus"] = With(HoT, {e = "a fiery brute of the lower vaults", kind = "elemental"}),
        ["Plunder"] = With(HoT, {e = "an enchanted golem of the vaults", kind = "construct"}),
    })
end

-- How a place is written mid-sentence ("the Barrens", "the Undercity").
local ARTICLE = {["Undercity"] = "the Undercity", ["The Barrens"] = "the Barrens", ["The Hinterlands"] = "the Hinterlands",
    ["Burning Steppes"] = "the Burning Steppes", ["Searing Gorge"] = "the Searing Gorge", ["Badlands"] = "the Badlands",
    ["Wetlands"] = "the Wetlands", ["Blasted Lands"] = "the Blasted Lands", ["Swamp of Sorrows"] = "the Swamp of Sorrows",
    ["Western Plaguelands"] = "the Western Plaguelands", ["Eastern Plaguelands"] = "the Eastern Plaguelands",
    ["The Deadmines"] = "the Deadmines", ["The Stockade"] = "the Stockade", ["Wailing Caverns"] = "the Wailing Caverns",
    ["Scarlet Monastery"] = "the Scarlet Monastery", ["Molten Core"] = "the Molten Core", ["Scholomance"] = "the Scholomance",
    ["The Temple of Atal'Hakkar"] = "the Sunken Temple", ["Ruins of Lordaeron"] = "the Ruins of Lordaeron",
    ["The Hall of Thanes"] = "the Hall of Thanes", ["Ruins of Ahn'Qiraj"] = "the Ruins of Ahn'Qiraj",
    ["The Crossroads"] = "the Crossroads", ["The Sepulcher"] = "the Sepulcher",
    ["Riverglades"] = "the Riverglades", ["Darkspear Islands"] = "the Darkspear Islands", ["Barrow Deeps"] = "the Barrow Deeps"}
function L.Display(name)
    if not name then return nil end
    return ARTICLE[name] or (name:gsub("^The ", "the "))
end
-- Short names for a second mention: "Taragaman", "Arugal", "Thaurissan".
local TITLES = {"Archmage", "Lord", "Lady", "High Inquisitor", "Scarlet Commander", "Commander", "Baron", "Baroness",
    "Chief", "Emperor", "Princess", "Prince", "General", "Overlord", "Highlord", "Warchief", "Mekgineer", "Twilight Lord",
    "Death Speaker", "Witch Doctor", "Hydromancer", "Shadowpriest", "Sergeant", "Captain", "Interrogator", "Bloodmage",
    "Houndmaster", "Arcanist", "High Interrogator", "Pyromancer", "Warder", "Golem Lord", "Ambassador", "Magistrate",
    "Cannon Master", "Archivist", "Instructor", "Doctor", "Lorekeeper", "Darkmaster", "Wolf Master", "High Priestess",
    "High Priest", "Bloodlord", "Shadow Hunter", "War Master", "Quartermaster", "Pyroguard", "Magister", "Guard",
    "Grand Foreman", "Foreman", "King", "Queen", "Mother", "Old", "Tinkerer", "Mad"}
table.sort(TITLES, function(a, b) return #a > #b end)
local SHORT = {["Edwin VanCleef"] = "VanCleef", ["Emperor Dagran Thaurissan"] = "Thaurissan", ["Baron Rivendare"] = "Rivendare",
    ["Darkmaster Gandling"] = "Gandling", ["High Inquisitor Whitemane"] = "Whitemane", ["Scarlet Commander Mograine"] = "Mograine",
    ["Baron Silverlaine"] = "Silverlaine", ["Commander Springvale"] = "Springvale", ["Princess Theradras"] = "Theradras",
    ["Warchief Rend Blackhand"] = "Rend", ["General Drakkisath"] = "Drakkisath", ["Mr. Smite"] = "Smite",
    ["Crowd Pummeler 9-60"] = "the Pummeler", ["Electrocutioner 6000"] = "the Electrocutioner", ["The Beast"] = "the Beast",
    ["The Baron"] = "the Baron", ["The Abandoned"] = "the Abandoned", ["Lordaeron Captain"] = "the captain"}
function L.Short(name)
    if not name then return nil end
    if SHORT[name] then return SHORT[name] end
    local rest = name
    for _, title in ipairs(TITLES) do
        if rest:sub(1, #title + 1) == title .. " " then rest = rest:sub(#title + 2); break end
    end
    rest = rest:match("^(.-) the ") or rest
    return rest:match("^(%S+)") or rest
end
-- Dungeon stories: why adventurers go in (the old quests' reasons), and what
-- it is like inside; detail is one concrete thing seen there. Plain sentences, no "you" or "I": both storytellers use
-- them, for a first visit (why, then inside) and now and then after.
L.dungeonStory = {
    ["Ragefire Chasm"] = {
        last = "Taragaman the Hungerer",
        why = {"Ragefire Chasm opened beneath Orgrimmar, through the Cleft of Shadow.",
            "Troggs and cultists occupied the caverns below the Horde capital.",
            "The Searing Blade occupied part of the chasm beneath Orgrimmar.",
            "Thrall wanted to know how a cult of demon worshippers had made its home under his own city.",
            "The chasm ran under the Cleft of Shadow, where the warlocks of Orgrimmar kept out of sight."},
        inside = {"The chasm ran hot and red under the city, and troggs and cultists filled it.",
            "Lava ran through the lower caves, and the heat never let up.",
            "Troggs held the upper caves, and the Searing Blade kept to the deeper ones.",
            "The caves opened out above a lake of lava, and the cultists had built their altars on the ledges over it."},
        detail = {"Lava lit the caverns beneath the city.",
            "The Searing Blade had left its orders and its idols on the ledges above the lava."},
        again = {"The heat of the chasm met whoever came down the ramp from the Cleft of Shadow, as it always had.",
            "Troggs had come back into the upper caves, as they did whenever no one was killing them.",
            "The ledges over the lava still held the altars of the Searing Blade.",
            "The chasm was the first deep place most of the Horde's young ever went into, and the lava looked the same every time."},
        unfinished = {"Past the troggs, the deeper caves belonged to the Searing Blade, and the felguard who led them stood at the bottom.",
            "The warlocks of the Searing Blade kept to the far caverns, above the lava, and had not been reached.",
            "Taragaman the Hungerer still held the deepest cave, where the cult had summoned him."}},
    ["Wailing Caverns"] = {
        last = "Mutanus the Devourer",
        why = {"The druid Naralex had fallen into a nightmare in the caverns, and his own disciples had turned against him.",
            "The Druids of the Fang had gone mad in the caverns, and the dreaming Naralex needed waking.",
            "Naralex had gone into the caverns to dream the Barrens green again, and the dream had turned to nightmare.",
            "A disciple of Naralex waited at the mouth of the caverns for anyone willing to help wake his master.",
            "The beasts under the oasis had changed in Naralex's nightmare, and the oases of the Barrens were turning foul with them."},
        inside = {"The caves were green and damp, and the wailing never stopped.",
            "Deviate beasts and mad druids prowled the tunnels.",
            "Wind moaned through cracks in the rock, and that sound gave the caverns their name.",
            "The tunnels wound down under the oasis, and water dripped from every root that came through the roof.",
            "Snakes and raptors in the caverns had changed under the nightmare, and their hides had turned strange colors."},
        detail = {"Strange beasts had risen from beneath the Barrens into these caverns.",
            "Naralex lay sleeping in the deepest chamber, and the nightmare poured out of his dream.",
            "The four Druids of the Fang each carried a gem of the dream, and the gems kept Naralex under."},
        again = {"The wailing of the caverns had not changed, and the deviates had bred back into the tunnels.",
            "The caverns still ran green and wet under the oasis, and the way down wound the same as before.",
            "Naralex's disciple still kept his place at the mouth of the caverns.",
            "The serpents of the Fang still coiled in the side caves, and the roots still dripped overhead.",
            "Mad Magglish still hid in a side tunnel with his stolen port, as he had the last time."},
        unfinished = {"The deeper caverns still belonged to the Druids of the Fang, and Naralex still slept at the bottom of them.",
            "Past the pools of the great turtle, the tunnels ran on to where the Fang druids kept their dreaming master.",
            "Mutanus the Devourer still waited in Naralex's dream, at the end of the caverns.",
            "The nightmare had not been broken, and the oases of the Barrens went on souring."}},
    ["The Deadmines"] = {
        last = "Edwin VanCleef",
        why = {"The Defias Brotherhood had turned the old mines of Moonbrook into a hidden shipyard, and Westfall wanted Edwin VanCleef dead.",
            "Edwin VanCleef had rebuilt {p:Stormwind} and was never paid, and now his Defias were building a ship under Westfall.",
            "Stormwind would not help Westfall, so the People's Militia went after the Defias themselves.",
            "The Defias had taken the mines under Moonbrook, and the whole of Westfall paid them tribute or burned.",
            "Gryan Stoutmantle had traced the Defias to the mines under Moonbrook, and he wanted their leader's head."},
        inside = {"At the bottom of the mines, the Defias had built a whole ship in the dark.",
            "Goblins and outlaws worked the tunnels, and the mine carts never stopped.",
            "At the end of the tunnels the cave opened onto the sea, where the ship lay at anchor.",
            "The Defias had hired goblins to run their foundry, and the smelters glowed in the dark of the mine.",
            "An iron door closed off the shipyard, and nothing short of the Defias' own cannon would open it."},
        detail = {"The thieves wore rings of the old Stonemasons' Guild, the men who had rebuilt Stormwind.",
            "A goblin shredder still worked deep in the mine.",
            "The Defias had built their ship from timber brought down the tunnels one cart at a time."},
        again = {"The mine carts still ran on their rails, and the smell of the foundry still reached the first tunnel.",
            "The Defias still held the mines, whatever had happened to the men who held them last time.",
            "The tunnels under Moonbrook were the same, and so was the cold of the cave at the end of them.",
            "The ship still lay at anchor in the cave under Westfall, and the Defias still guarded it.",
            "The goblins of the foundry had gone back to their smelters, as goblins do when there is pay in it."},
        unfinished = {"Past the foundry, the tunnels ran on to the shipyard, and Edwin VanCleef stood on the deck of his ship.",
            "The iron door still stood between the mines and the cave where the Defias kept their ship.",
            "The ship had not been reached, and the master of the Brotherhood had not been seen.",
            "The Defias still had their leader, and the shipyard at the end of the mines still worked."}},
    ["Shadowfang Keep"] = {
        last = "Archmage Arugal",
        why = {"Archmage Arugal had filled the old keep with worgen, and Silverpine paid the price.",
            "The worgen of Silverpine came from the keep, and Arugal was their master.",
            "Arugal had called the worgen to fight the Scourge, and lost control of them.",
            "The keep had belonged to Baron Silverlaine before Arugal took it.",
            "The Forsaken could not hold Silverpine while Arugal lived in the keep above Pyrewood.",
            "Two Deathstalkers had gone into the keep to scout it for the Sepulcher, and neither had come back."},
        inside = {"Ghosts of the keep's household walked its halls beside the worgen.",
            "Worgen howled on the floors above.",
            "The keep's servants still walked its halls, dead these many years.",
            "The stairs wound up through the keep floor by floor, and Arugal kept the topmost room.",
            "The Silverlaine family's dead still kept the dining hall, and the worgen had the kitchens and the yards."},
        detail = {"In the courtyard cells, prisoners waited for someone to open the doors.",
            "Somewhere in the keep lay the Book of Ur, written by a great mage of Dalaran.",
            "The wolves of the keep answered to a wolf master, and the master answered to Arugal."},
        again = {"The keep still stood over Pyrewood, and the worgen still howled on its upper floors.",
            "The courtyard gate of the keep opened the same way it had before, onto the same cold yard.",
            "The dead of the Silverlaine house still kept their places in the hall.",
            "The stairs of the keep climbed as far as they ever had, and the wind still came through the arrow slits."},
        unfinished = {"The upper floors of the keep had not been climbed, and Arugal still kept his room at the top.",
            "Past the wolves and their master, the stairs went on up to the archmage.",
            "Arugal still held the keep, and Silverpine still paid for it.",
            "The worgen still had their master, in the tower above the floors already fought through."}},
    ["Blackfathom Deeps"] = {
        last = "Aku'mai",
        why = {"The Twilight's Hammer had taken an old night elf temple on the coast, and few knew what they served down there.",
            "Cultists of the Twilight's Hammer were feeding something in the deep water of Blackfathom.",
            "Blackfathom had been a temple of Elune, until something from below fouled its moonwell.",
            "Naga had come up the Zoram Strand into the drowned temple, and the Twilight's Hammer had come after them.",
            "The temple had drowned in the Sundering, and the cult had found a use for what lived in its lowest pool."},
        inside = {"Water filled the halls of the sunken temple.",
            "The old temple was half under the sea, and the naga swam its halls.",
            "Statues of the night elves stood to their knees in black water.",
            "The halls went down in steps, each one deeper under the sea than the last.",
            "Cultists chanted in the drowned halls, and the water in the deepest pool moved when they did."},
        detail = {"Twilight's Hammer cultists and naga occupied the ruined temple together.",
            "The moonwell of the temple had gone black, and the cult had built its altar beside it.",
            "A great turtle kept the first pool of the temple, and the way in ran past it."},
        again = {"The water in the halls stood as high as it had before, and the statues still stood in it.",
            "The naga had come back into the flooded halls, as they did whenever the way was clear.",
            "The way down into the temple still ran past the great turtle's pool.",
            "The cult's altars still stood by the black moonwell, and the chanting had started up again."},
        unfinished = {"The deepest hall of the temple had not been reached, and the thing the cult fed there still waited in the water.",
            "Past the altar of the cult, the halls went down to the pool where Aku'mai lay.",
            "Twilight Lord Kelris still kept the altar, and the hydra still kept the deep water below it.",
            "The cult still fed what lived in the deep water, in the halls not yet fought through."}},
    ["The Stockade"] = {
        last = "Bazil Thredd",
        why = {"The prisoners of the Stockade had risen and taken the prison, right in the heart of {p:Stormwind}.",
            "The Stockade's inmates had killed their guards, and Stormwind wanted order back.",
            "The riot had a leader, Bazil Thredd, and the warden wanted his head.",
            "Warden Thelwater stood outside his own prison, and asked anyone with a sword to go in and take it back.",
            "The Defias had friends inside the Stockade, and the riot had not started on its own."},
        inside = {"The cells stood open and the prisoners were loose.",
            "Loose prisoners filled the corridors, and no guard stood in them.",
            "The prison lay under the city, by the canals.",
            "The cell blocks ran in two arms from the gate, and the prisoners held both.",
            "Torches still burned in the corridors, and the prisoners had taken the guards' weapons from the racks."},
        detail = {"Among the prisoners was a Dark Iron dwarf, Kam Deepfury, held there for political reasons.",
            "Stormwind's worst were kept in the Stockade, and the riot had let all of them out of their cells."},
        again = {"The cells stood open as before, and the prisoners had not gone back into them.",
            "The warden still stood outside the gate of his prison, and the corridors inside were still his inmates'.",
            "The Stockade lay where it always had, under the city by the canals, and the riot in it had not ended.",
            "The guards' weapon racks stood empty, and the prisoners who had taken them were still loose."},
        unfinished = {"Bazil Thredd still held the far cell block, where the riot had started.",
            "The leader of the riot had not been reached, in the cells at the end of the corridor.",
            "The riot still had its leader, and the warden still waited outside the gate."}},
    ["Gnomeregan"] = {
        last = "Mekgineer Thermaplugg",
        why = {"Gnomeregan had fallen to troggs and to the traitor Mekgineer Thermaplugg, and the gnomes wanted their city back.",
            "The gnomes had lost their city to radiation, troggs and a traitor, and asked for help taking it back.",
            "To kill the troggs, the gnomes had flooded their own city with radiation, and most of their people were caught in it.",
            "The gnomes of Tinker Town had left their records, their machines and most of their people in the city, and wanted all three back.",
            "Thermaplugg had betrayed the gnomes and stayed in the city after the radiation took it, and the High Tinker wanted him dead."},
        inside = {"The city was all pipes, gears and green poison.",
            "Machines still ran in the empty halls, and not all of them were friendly.",
            "The gnomes who stayed behind wandered the halls as lepers, their minds gone.",
            "Green fallout pooled on the floors of the lower halls, and the air glowed with it.",
            "The halls went down level by level, through workshops and gear rooms, to the launch bay at the bottom."},
        detail = {"Important records had been left inside when the gnomes fled their city.",
            "Troggs had come up through the lower halls, and the gnomes' own machines had turned on anyone who came near.",
            "The Hall of Gears and the engineering labs lay on the way down, and the gnomes' own machines guarded them."},
        again = {"The halls of the city still glowed green, from the first gear room to the last.",
            "Troggs had come back up into the halls, and the lepers still wandered among them.",
            "The pipes and gears of the city still turned, for no one, as they had the last time.",
            "The radiation had not thinned, and the fallout still pooled on the lower floors.",
            "Gnomeregan was still the gnomes' lost city, and its halls were no emptier for having been fought through once."},
        unfinished = {"The lower halls had not been reached, and Thermaplugg still sat in his workshop at the bottom of the city.",
            "Past the gear rooms, the halls went down to the launch bay, where the traitor kept his machines.",
            "The gnomes' traitor still held the deepest level of the city.",
            "Thermaplugg still ruled what was left of Gnomeregan, from the halls not yet fought through."}},
    ["Razorfen Kraul"] = {
        last = "Charlga Razorflank",
        why = {"Charlga Razorflank was gathering an army in the Kraul, and the Barrens had had enough of quilboar raids.",
            "The quilboar raided the Barrens from their thorn maze, and someone had to go in.",
            "The quilboar held the brambles sacred, for they grew where the demigod Agamaggan fell.",
            "The Death's Head cult ruled the Kraul under Charlga, and the Barrens tribes answered to her.",
            "A goblin had gone into the Kraul for a tuber and not come out, and his employer wanted him back."},
        inside = {"Great thorns grew over everything in the Kraul.",
            "The maze of thorns turned back on itself, and the quilboar knew every path.",
            "The quilboar kept prisoners deep in the maze.",
            "Boars ran in pens among the thorns, and the quilboar bred them for war.",
            "The thorns grew thicker toward the heart of the Kraul, where the quilboar kept their matriarch."},
        detail = {"A goblin named Willix had come for the Redleaf Tuber, and had been a prisoner ever since.",
            "The thorns of the Kraul had grown from the blood of Agamaggan, and the quilboar tended them as a shrine.",
            "Totems of bone and thorn marked the paths the quilboar used."},
        again = {"The thorns of the Kraul had grown back over the paths, as thorns do.",
            "The quilboar still held the maze, and their boars still ran in the pens.",
            "The way through the brambles turned the same way it had before, and the quilboar still knew it better.",
            "The Kraul still stood where Agamaggan fell, and the quilboar still tended it."},
        unfinished = {"Charlga Razorflank still held the heart of the Kraul, beyond the thorns already cut through.",
            "The quilboar still had their matriarch, in the inner maze.",
            "Past the pens and the Death's Head priests, the thorns ran on to Charlga's platform.",
            "The army Charlga was gathering had lost some of its warriors, and none of its leader."}},
    ["Scarlet Monastery"] = {
        last = {"Bloodmage Thalnos", "Arcanist Doan", "Herod", "High Inquisitor Whitemane"},
        why = {"The Scarlet Crusade had made the monastery their stronghold, and their zeal made enemies of everyone.",
            "The Crusade held the monastery in Tirisfal, and it killed anyone it thought unclean.",
            "High Inquisitor Whitemane led the Crusade from the monastery, and Horde and Alliance alike wanted her dead.",
            "The monastery had taught Lordaeron's priests once, and the Crusade had made it an armory and a prison.",
            "The Crusade burned Forsaken and plague victims alike, and the Forsaken meant to burn the Crusade in turn."},
        inside = {"Crusaders filled the halls, ready to die for their cause.",
            "Every room held more of the Crusade, and none of them would surrender.",
            "The graveyard behind the monastery was full of dead the Crusade could not put down.",
            "The monastery stood in four parts, the graveyard, the library, the armory and the cathedral, and the Crusade held every one."},
        detail = {"The monastery had once been a center of learning for Lordaeron's priesthood.",
            "The Crusade's banners hung in every hall, red on white, and its priests prayed under them for the death of the unclean."},
        again = {"The Crusade still held the monastery, and its bells still rang over Tirisfal.",
            "The halls of the monastery were full again, as the Crusade's were whenever one of its own fell.",
            "The red banners still hung in the halls, and the Crusaders under them were no less willing to die.",
            "The monastery had four doors, and whichever one opened, the Crusade waited behind it."},
        unfinished = {"The cathedral had not been reached, and Whitemane still held the Crusade from its altar.",
            "The Crusade still had its high inquisitor and its commander, in the cathedral past the halls already fought through.",
            "Whitemane still prayed in the cathedral, and Mograine still commanded its garrison."},
        -- The monastery's four wings, known by who fell there (L.DungeonSight).
        wings = {
            {bosses = {"Interrogator Vishas", "Bloodmage Thalnos"},
                inside = {"The graveyard behind the monastery was full of dead the Crusade could not put down.",
                    "Crypts ran under the graveyard, and the Crusade's prisoners were kept in them."},
                detail = {"Interrogator Vishas questioned the Crusade's prisoners in the crypts below the graveyard.",
                    "The Crusade's own dead rose in the graveyard, and the Crusade did not know how to stop them."}},
            {bosses = {"Houndmaster Loksey", "Arcanist Doan"},
                inside = {"Shelves of old books filled the library, and the Crusade's scholars guarded them.",
                    "The library kept the records of Lordaeron's priesthood, and the Crusade let no one read them."},
                detail = {"Arcanist Doan kept the library, and Houndmaster Loksey and his dogs kept its door.",
                    "The Crusade's hounds slept among the stacks, and woke for strangers."}},
            {bosses = {"Herod"},
                inside = {"Racks of weapons lined the armory, and the Crusade's champions trained among them.",
                    "The armory's yard rang with the Crusade's drills from dawn to dark."},
                detail = {"Herod, the Scarlet Champion, kept the armory, and his men trained there day and night.",
                    "The Crusade's trainees were sworn to follow their champion to the death, and did."}},
            {bosses = {"Scarlet Commander Mograine", "High Inquisitor Whitemane", "High Inquisitor Fairbanks"},
                inside = {"The cathedral was the Crusade's heart, and its faithful knelt in rows before the altar.",
                    "The cathedral's bells rang over the monastery, and the Crusade's faithful filled its nave."},
                detail = {"Scarlet Commander Mograine commanded a garrison of devoted warriors.",
                    "The high inquisitor held the cathedral's altar, and the Crusade believed she could raise its dead."}},
        }},
    ["Razorfen Downs"] = {
        last = "Amnennar the Coldbringer",
        why = {"The Scourge had come to the Razorfen, and Amnennar the Coldbringer ruled the Downs.",
            "The quilboar of the Downs had joined the Scourge, and the Barrens were in danger.",
            "A lich, Amnennar the Coldbringer, ruled the quilboar of the Downs, and his mind was bound to the Lich King's.",
            "The Downs had been the quilboar's burial ground, and the Scourge had raised what was buried there.",
            "A red dragon in the shape of a dwarf waited near the Downs, and wanted the Scourge's idol there destroyed."},
        inside = {"The dead walked among the thorns of the Downs.",
            "Bones and thorns filled the barrows of the Downs.",
            "Quilboar priests and Scourge dead guarded the barrows side by side.",
            "The barrows wound up through the thorns to a spire of bone, and the cold grew with every turn.",
            "A gong hung in the first barrow, and the quilboar struck it to call the great spider."},
        detail = {"Near the entrance stood an idol the quilboar used as an oven, for the people they took from the Barrens.",
            "A spire of bone stood at the top of the Downs, and the lich held court on it.",
            "The quilboar dead of generations had been dug up and set walking by the Scourge."},
        again = {"The cold of the Downs met whoever came through the thorns, as it had before.",
            "The barrows of the Downs still held their dead, and the dead still walked them.",
            "The gong still hung in the first barrow, and the thorns still wound up toward the spire.",
            "The quilboar of the Downs still served the Scourge, and their priests still chanted over the bones."},
        unfinished = {"Amnennar still held the spire of bone at the top of the Downs, past the barrows already fought through.",
            "The lich had not been reached, and the quilboar of the Downs still answered to him.",
            "The spire at the top of the Downs still stood, and the Coldbringer still held court on it.",
            "Past the spider's barrow and the Scourge's priests, the path wound on up to the lich."}},
    ["Uldaman"] = {
        last = "Archaedas",
        why = {"Uldaman held the secrets of the titans, and diggers of every kind wanted them.",
            "The old titan vault under the Badlands had been opened, and its keepers were waking.",
            "Explorers from Ironforge and Dark Iron diggers both worked at Uldaman, and each wanted the vault first.",
            "The Explorers' League believed the dwarves' own beginnings lay written somewhere in the vault.",
            "Three dwarves of the League had gone into the vault ahead of everyone and not come out, and their kin wanted word of them."},
        inside = {"Stone keepers stood in the halls, older than any kingdom.",
            "Troggs and Dark Irons dug through the vaults of the titans.",
            "Troggs filled the upper halls, and deeper down the stone itself stood up and fought.",
            "The halls were cut square and tall, in a stone no dwarf had ever quarried.",
            "A map of the world lay set into the floor of one chamber, older than the kingdoms drawn on it."},
        detail = {"Explorers searched the buried halls for records of the titans.",
            "The Explorers' League believed the vault held the answer to where the dwarves had come from, and wanted its records more than any treasure.",
            "Discs of the titans lay in the deepest vault, and the League wanted them more than any treasure."},
        again = {"The halls of the vault stood as square and silent as before, and the troggs had come back into the upper ones.",
            "The Dark Irons still dug at the vault, and the League still raced them.",
            "The stone keepers still stood in their alcoves, and some of them still woke.",
            "The vault was older than any kingdom the last time, and it had not grown younger."},
        unfinished = {"The deepest vault had not been reached, and Archaedas still stood in it.",
            "Past the map chamber, the halls ran on down to the keeper of the vault and the discs he guarded.",
            "The stone watcher still held the last hall, and the titans' discs with him.",
            "The trogg king and the stone watcher still held the lower halls."}},
    ["Zul'Farrak"] = {
        last = "Chief Ukorz Sandscalp",
        why = {"The Sandfury trolls held Zul'Farrak, and the goblins of {p:Gadgetzan} wanted things from inside it.",
            "Sergeant Bly and his crew had gone into Zul'Farrak, and ended up prisoners on top of the pyramid.",
            "At the back of the city lay a sacred pool, and from it the trolls called up a hydra.",
            "The Sandfury had built the city when the troll empires still stood, and they had never left it.",
            "A goblin engineer of Gadgetzan had lost a device inside the troll city, and paid well to have it back."},
        inside = {"The sun beat down on the troll city, and the sand hid the dead.",
            "The pyramid of Zul'Farrak rose over the sand, and trolls came up its steps in waves.",
            "Sandfury dead rose out of the sand in the graveyard.",
            "The city stood open to the sky, street after street of troll huts and shrines, with the pyramid at its heart.",
            "Basilisks and hyenas were kept in pens among the huts, and the trolls set them loose on strangers."},
        detail = {"Gahz'rilla, the beast of the sacred pool, had scales that crackled with energy.",
            "A mallet struck on a gong by the sacred pool called the great hydra up out of it.",
            "The Sandfury kept their dead in a graveyard inside the walls, and a witch doctor kept them walking."},
        again = {"The sun still beat on the troll city, and the Sandfury still filled its streets.",
            "The pyramid still rose over the sand, and the steps up it were no shorter.",
            "The sand of the graveyard still gave up its dead.",
            "The gong still hung by the sacred pool, and the pool was still deep."},
        unfinished = {"The chief of the Sandfury still held the far end of the city, past the pyramid.",
            "Ukorz Sandscalp still sat in his hall at the back of the city, and the Sandfury still answered to him.",
            "The pyramid and the pool beyond it had not been reached.",
            "The Sandfury still had their chief, in the halls not yet fought through."}},
    ["Maraudon"] = {
        last = "Princess Theradras",
        why = {"Zaetar, first son of Cenarius, lay in Maraudon, and Princess Theradras kept his remains.",
            "A satyr, Lord Vyletongue, had spread his poison through the caves, and Celebras wandered them blind with the curse.",
            "The centaur were the children of Zaetar and Theradras, and they had killed their own father.",
            "The centaur held the caves holy and would not go in, and whoever did went in against every clan at once.",
            "Theradras had made the caves her own after Zaetar died, and the earth around her had gone wrong."},
        inside = {"The caves ran green with poison and purple with crystal.",
            "Great roots and waterfalls filled the caves under Desolace.",
            "Deep down, the caves opened onto an underground lake and its falls.",
            "Two ways led down into the caves, one through poison and one through crystal, and both met at the water below.",
            "Centaur guards stood in the Valley of Spears outside, and would not go in after anyone."},
        detail = {"Purple and orange crystals marked the branching caverns.",
            "Celebras had been a keeper of the grove, and the curse had left him wandering the caves.",
            "The water of the deep caves ran clean, the only clean water in Desolace."},
        again = {"The caves still ran poison on one side and crystal on the other, and the falls still sounded from below.",
            "The centaur still stood guard in the Valley of Spears, and still would not follow anyone in.",
            "The roots of the caves had grown no thinner, and the water below still ran clean.",
            "Maraudon was still the centaur's holy ground, and still full of things that were not centaur."},
        unfinished = {"The deep caves had not been reached, and Theradras still kept Zaetar's remains beside the lake.",
            "Past the falls, the caverns opened on the earth princess and the water she had made her own.",
            "Theradras still held the lowest cave, and the centaur's father still lay with her.",
            "The princess of the earth had not been reached, below the halls already fought through."}},
    ["The Temple of Atal'Hakkar"] = {
        last = "Shade of Eranikus",
        why = {"The Atal'ai priests were trying to call the blood god Hakkar into the world, in the temple under the swamp.",
            "The green dragonflight guarded the sunken temple, where the Atal'ai worshipped Hakkar.",
            "Long ago the green dragons had sunk the temple into the swamp, to stop the Atal'ai.",
            "The Atal'ai had been cast out of Zul'Gurub for what they worshipped, and had built this temple to go on worshipping it.",
            "The prophet Jammal'an led the Atal'ai in the temple, and he meant to see Hakkar reborn."},
        inside = {"The temple lay half drowned in the swamp, and green dragons waited in its deepest hall.",
            "Troll priests chanted in the dark water of the temple.",
            "The temple was built in rings, and each ring went further down into the water.",
            "Statues of the troll gods stood around the upper hall, and the way down opened only when they were lit in order.",
            "The idol of Hakkar stood in the lowest hall, and the priests kept its altar wet."},
        detail = {"A font in the temple held the essence of Eranikus, the green dragon set to guard it.",
            "The green dragons who guarded the temple had been touched by the same nightmare that was spreading through the Dream.",
            "Six statues stood in the upper hall, and the Atal'ai had built the way down around them."},
        again = {"The temple still stood drowned in the swamp, and the water in its halls had not gone down.",
            "The Atal'ai still chanted in the rings of the temple, and the dragons still kept the deepest one.",
            "The statues still stood in the upper hall, and the way down still turned the same way.",
            "The idol of Hakkar still stood in the lowest hall, and the priests still kept it."},
        unfinished = {"The deepest hall had not been reached, and the shade of Eranikus still kept it.",
            "Past the prophet's hall, the rings went down to the altar of Hakkar and the dragon who guarded it.",
            "The shade of the green dragon still held the bottom of the temple.",
            "Hakkar's altar and the dragons around it lay below the halls already fought through."}},
    ["Blackrock Depths"] = {
        last = "Emperor Dagran Thaurissan",
        why = {"The Dark Iron dwarves ruled from the depths of Blackrock Mountain, under Emperor Dagran Thaurissan.",
            "Deep in the mountain, the Dark Irons served Ragnaros and schemed against everyone.",
            "King Magni feared for his missing daughter, Moira, and sought answers from a prisoner in the depths.",
            "Long ago the Dark Irons had called Ragnaros into the world, and he had never left.",
            "The Dark Irons kept prisoners of every people in the depths, and more than one kingdom wanted its own back.",
            "The Thorium Brotherhood wanted the Dark Irons' secrets of the forge, and the forge was in the depths."},
        inside = {"The depths were a whole city of forges and fire.",
            "Lava lit the Dark Iron city from below.",
            "In the middle of the city stood a tavern, the Grim Guzzler.",
            "The city went on for halls and halls, from the prison at the gate to the emperor's throne room at the far end.",
            "The Dark Irons held trials in a ring of law, and the accused fought beasts before a crowd."},
        detail = {"The Dark Iron city filled a volcanic labyrinth beneath Blackrock Mountain.",
            "A servant of Ragnaros kept the anvil of the forge halls, and the Dark Irons worked it under his eye.",
            "The ghost of Franclorn Forgewright, the architect of the mountain, still walked the depths."},
        again = {"The heat of the depths met whoever came through the gate, and the city beyond it was no smaller.",
            "The Dark Iron city still ran on its forges, and its halls still went on and on.",
            "The tavern in the middle of the city still served ale, to anyone who did not start a fight.",
            "The prison at the gate still held its cells, and the ring of law still held its trials.",
            "The depths had been a city of the Dark Irons for three hundred years, and one visit had not changed that."},
        unfinished = {"The throne room had not been reached, and Thaurissan still sat the imperial seat.",
            "Past the forges, the halls ran on to the emperor and his court.",
            "The Dark Iron empire still had its emperor, at the far end of the city.",
            "The golem at the throne room's gate still stood, and the emperor behind it had not been seen."}},
    ["Blackrock Spire"] = {
        last = {"Overlord Wyrmthalak", "General Drakkisath"},
        why = {"The Blackrock orcs and the black dragonflight held the spire above the mountain.",
            "Warchief Rend Blackhand ruled the spire, and the black dragons nested above him.",
            "General Drakkisath held the upper spire for Nefarian, and the black dragons bred there.",
            "Rend Blackhand called himself warchief of the Horde, and Thrall's Horde meant to answer that.",
            "The spire had been built by the Dark Irons, and the Blackrock orcs held it now for a warchief of their own."},
        inside = {"Orcs and dragonkin filled the spire, floor after floor.",
            "Dragon eggs lay in the dark of the upper spire.",
            "The lower spire was a warren of orcs, trolls and ogres.",
            "The spire climbed in halls and bridges inside the mountain, and the orcs held every landing.",
            "The upper spire held a rookery of dragon eggs and an arena where the warchief watched the fighting."},
        detail = {"Rend Blackhand rode into battle on the back of a dragon named Gyth.",
            "Trolls and ogres served the Blackrock orcs in the lower halls, and the worgs of the spire ran loose among them.",
            "A seal was needed to open the upper spire, and the orcs did not give it up."},
        again = {"The spire still climbed inside the mountain, landing after landing, and the orcs still held them.",
            "The lower halls still held their orcs, trolls and ogres, and the stairs were no shorter.",
            "The eggs of the rookery had not hatched, and the dragonkin still kept them.",
            "The Dark Horde still called the spire its own."},
        unfinished = {"The upper spire had not been reached, and Drakkisath still held its hall for Nefarian.",
            "Past the overlord's hall, the stairs went on up to the rookery and the warchief's arena.",
            "The black dragon general still held the top of the spire.",
            "Rend Blackhand still sat over his arena, and the dragon general still held the hall beyond it."}},
    ["Dire Maul"] = {
        last = {"Alzzin the Wildshaper", "Prince Tortheldrin", "King Gordok"},
        why = {"The ruins of Eldre'Thalas were divided among ogres, satyrs and the ghosts of the Highborne.",
            "The old highborne city in Feralas had its secrets, and ogres guarded the gate.",
            "Satyrs had taken the eastern halls, and the forest inside had gone wild and wrong.",
            "The Shen'dralar had kept themselves alive for ten thousand years in the west of the city, and the price of it lived in their prison.",
            "The Gordok ogres ruled the north of the city under their king, and took tribute from anyone who wanted through."},
        inside = {"The ruins were overgrown, and some of the old wards still held.",
            "Ogres, satyrs and ghosts shared the broken halls.",
            "The city stood in three parts, east, west and north, and a courtyard between them where ogres fought for sport.",
            "The halls of the west still held the Highborne who built them, and they had not left in ten thousand years."},
        detail = {"The Athenaeum preserved thousands of years of elven records.",
            "Five pylons in the west of the city fed the prison of a demon, and the Highborne fed on the demon.",
            "The warpwood trees of the east had turned on the city, and their roots had broken the floors."},
        again = {"The ruins stood as broken as before, and the ogres still kept the gate.",
            "The pylons in the west still hummed, and the wards of the Highborne still held.",
            "The Gordok still took their tribute, and the courtyard still rang with their fights.",
            "Eldre'Thalas had stood for ten thousand years, and one visit had not shortened that."},
        unfinished = {"The king of the Gordok still held the north of the city, past the guards already fought through.",
            "The prince of the Shen'dralar still kept his hall in the west, beside the demon's prison.",
            "The satyr who had corrupted the gardens still held the eastern halls.",
            "The deepest halls of the city had not been reached, and their masters still held them."}},
    ["Stratholme"] = {
        last = {"Balnazzar", "Baron Rivendare"},
        why = {"Stratholme had fallen to the plague, and its dead still walked the streets.",
            "The city Arthas purged still burned, and the Scourge and the Crusade fought over its ruins.",
            "Baron Rivendare ruled the dead half of the city for the Scourge.",
            "The Scarlet Crusade held the Bastion in the living half of the city, and the Scourge held the ziggurats in the other.",
            "The Argent Dawn wanted the city's dead put down, and the Crusade wanted them burned, and neither wanted the other there."},
        inside = {"Fire and ash filled the streets of Stratholme.",
            "The dead walked in the ruins, and the Scarlet Crusade held out in the other half.",
            "Ghosts of the people Arthas killed still walked the streets.",
            "The city gates opened onto streets of burned houses, and the fires had not gone out since the purge.",
            "Three ziggurats stood in the dead half of the city, and the Scourge's lieutenants held them."},
        detail = {"The postboxes of Stratholme still held letters no one would ever collect.",
            "In the dead half of the city, Baron Rivendare held court in the slaughterhouse.",
            "The Scarlet Bastion had been the city's hall once, and the Crusade had made it a fortress."},
        again = {"The fires of Stratholme still burned, and the dead still walked its streets.",
            "The gates of the city opened as they had before, onto the same ash.",
            "The Crusade still held the Bastion, and the Scourge still held the ziggurats.",
            "Stratholme had burned since Arthas put it to the torch, and it was still burning."},
        unfinished = {"The slaughterhouse had not been reached, and Rivendare still held court in it.",
            "Past the ziggurats, the streets ran on to the slaughterhouse and the Scourge's baron.",
            "The Scarlet Bastion still held the Crusade's grand crusader, in the halls beyond the ones fought through.",
            "The baron still held the dead half of the city, and the Crusade's master still held the living half."}},
    ["Scholomance"] = {
        last = "Darkmaster Gandling",
        why = {"The Cult of the Damned taught necromancy in the Scholomance, under Darkmaster Gandling.",
            "Under Caer Darrow, the Scholomance trained the Scourge's necromancers.",
            "The Barov family had handed Caer Darrow to the Cult of the Damned.",
            "The Argent Dawn wanted the school closed, and the Scourge kept opening it.",
            "Kel'Thuzad had founded the school before he died, and his cult had kept it running after."},
        inside = {"The crypts of the school were full of students of death.",
            "Bones, books and cold magic filled the halls.",
            "Students of the cult worked over the dead in the lower rooms.",
            "The school ran down through the crypts of the keep, classroom under classroom, to the headmaster's hall.",
            "The cult's instructors taught in rooms full of bones, and the bones were the lesson."},
        detail = {"The dead lords of house Barov still walked the halls of the keep they had given away.",
            "A key of bone opened the door of the school, and the Argent Dawn knew how to make one.",
            "Kel'Thuzad's cult kept its own dead in the crypts of the school, and raised them for lessons."},
        again = {"The crypts of the school were as cold as before, and as full of students.",
            "The door of the school still took a key of bone, and the halls behind it still smelled of the dead.",
            "The Barovs still walked their keep, and the cult still taught in its crypts.",
            "The school had not closed, whatever had happened to its last class."},
        unfinished = {"The headmaster's hall had not been reached, and Gandling still taught from it.",
            "Past the Barovs' halls, the crypts ran down to the classrooms and the darkmaster who ruled them.",
            "The school still had its headmaster, in the lowest hall.",
            "Gandling still held the Scholomance, and his classes still met."}},
    ["Molten Core"] = {
        last = "Ragnaros",
        why = {"Ragnaros the Firelord waited in the Molten Core, deep under Blackrock Mountain.",
            "Long ago Thaurissan had called Ragnaros into the world, and the Firelord made the mountain his.",
            "The Hydraxian Waterlords wanted the Firelord driven back into his own plane, and sent whoever would go.",
            "The Dark Irons had summoned Ragnaros to win a war three hundred years before, and he had ruled the mountain since."},
        inside = {"The core was all fire and lava, and elementals rose from it.",
            "Lava crossed the cave floors, and giants of fire and stone walked beside it.",
            "Runes of the Firelord's lieutenants burned on the cave floors, and each one had to be put out in turn.",
            "The caves ran down through the roots of the mountain to the Firelord's own hall."},
        detail = {"Pools of lava lit the caverns deep beneath Blackrock Mountain.",
            "Hounds of the Firelord ran in packs through the caves, and did not stay dead while one of the pack still stood.",
            "The Firelord's steward kept the last hall before his master's, and would not fight to the death."},
        again = {"The heat of the core met whoever came through the rift, as it had before.",
            "The lava still crossed the cave floors, and the elementals still rose from it.",
            "The runes of the lieutenants still burned, and the Firelord's hall still lay past them.",
            "The core was the Firelord's own, and nothing done in it the last time had made it less so."},
        unfinished = {"The Firelord's hall had not been reached, and Ragnaros still slept in his lava.",
            "Past the lieutenants' halls, the caves ran on to the steward and the Firelord behind him.",
            "Ragnaros still held the heart of the mountain.",
            "The steward of the Firelord still kept the last hall, and the Firelord had not been woken."}},
    ["Onyxia's Lair"] = {
        last = "Onyxia",
        why = {"Onyxia, daughter of Deathwing, nested in the caves of Dustwallow Marsh.",
            "The lair sheltered Onyxia's eggs and the growing strength of her brood.",
            "The black dragonflight had worked in secret for years, and the Broodmother's lair in the marsh was where the work came from.",
            "The Broodmother of the black dragonflight kept her lair in the Wyrmbog, and no one who went in without the amulet came out."},
        inside = {"Whelps swarmed the lair, and the dragon waited at its heart.",
            "Her eggs lined the side caves, and whelps poured out of them.",
            "The caves ran back under the marsh to one great hall, and the dragon kept it.",
            "Dragonkin warders stood in the first caves, and the whelps' eggs lay in the alcoves behind them."},
        detail = {"No one entered the lair without the Drakefire Amulet.",
            "The hall of the Broodmother was wide enough for her to take wing in it.",
            "Deathwing's daughter had bred her whelps in the dark under Dustwallow for years before anyone found the lair."},
        again = {"The whelps had hatched back into the side caves, as a brood does.",
            "The lair still opened under the Wyrmbog, and the warders still stood in its first caves.",
            "The hall of the Broodmother was as wide as before, and no safer.",
            "The amulet still opened the lair, and the lair still led to the same hall."},
        unfinished = {"The Broodmother's hall had not been reached, and Onyxia still kept it.",
            "Past the warders and the eggs, the caves ran on to the dragon herself.",
            "Onyxia still held her lair, and her brood still hatched in it."}},
    ["Blackwing Lair"] = {
        last = "Nefarian",
        why = {"Nefarian, son of Deathwing, bred new dragons at the top of Blackrock Mountain.",
            "In his lair above the spire, Nefarian worked to make dragons of every color at once.",
            "The lair opened behind the dragon general's hall at the top of the spire, and only those marked by his blood could pass.",
            "Nefarian held the Blackrock orcs and their Dark Horde as his servants, and bred his chromatic dragons above them."},
        inside = {"Broken eggs and failed dragons filled the halls of the lair.",
            "Nefarian's servants and his experiments guarded every hall.",
            "The lair began in a hatchery of eggs, and the eggs had to be broken before the halls beyond would open.",
            "Dragons of five colors had been bred together in the lair, and most of what came out of the eggs had not lived long."},
        detail = {"Black dragons and drakonid guarded Nefarian's halls.",
            "A red dragon lay chained in the lair, bound and corrupted by Nefarian's work.",
            "The lair's laboratories held the failed results of Nefarian's breeding, and some of them still moved."},
        again = {"The hatchery still held its eggs, and the drakonid still guarded them.",
            "The halls of the lair were as full of Nefarian's work as before.",
            "The lair still crowned the mountain, and the son of Deathwing still ruled it.",
            "Broken eggs and failed dragons still filled the halls, and new ones had been laid."},
        unfinished = {"Nefarian's own hall had not been reached, at the top of the lair.",
            "Past the drakes and the laboratories, the halls ran on to the lord of the lair.",
            "The son of Deathwing still held the top of the mountain.",
            "Nefarian still bred his dragons in the halls not yet fought through."}},
    ["Zul'Gurub"] = {
        last = "Hakkar",
        why = {"The Gurubashi priests had called Hakkar the Soulflayer back into the world, in their old capital in Stranglethorn.",
            "The Zandalar trolls had come to Yojamba Isle to ask for help against Hakkar.",
            "The Gurubashi empire had torn itself apart over Hakkar once, and the priests of Zul'Gurub had called him back all the same.",
            "The Zandalar feared what the Soulflayer would do to all trolls, and asked outsiders to go where they would not."},
        inside = {"The jungle had grown back over the troll city, and its high priests had taken the shapes of the old troll gods.",
            "Tigers, bats and raptors served the priests of the jungle city.",
            "The city climbed in terraces through the jungle to the temple of Hakkar at the top.",
            "Five high priests held five temples in the city, each one given to an animal god of the trolls."},
        detail = {"Each high priest of Zul'Gurub had taken the power of a troll god, the bat, the snake, the panther, the tiger or the spider.",
            "The blood god took his strength from his priests, and each priest who fell left him weaker.",
            "A hexxer kept the way to the temple, and the raptor-riding bloodlord kept the arena below it."},
        again = {"The jungle still covered the troll city, and the priests still held their temples.",
            "The terraces still climbed to the temple of Hakkar, and the way up was no shorter.",
            "The animal gods' priests had been replaced, as the Gurubashi replaced them.",
            "Zul'Gurub was still the blood god's city."},
        unfinished = {"The temple of Hakkar had not been reached, at the top of the city.",
            "Past the priests' temples, the terraces climbed to the Soulflayer himself.",
            "Hakkar still held his temple, and the priests not yet fought still fed him.",
            "The Soulflayer still waited at the top of the city."}},
    ["Ruins of Ahn'Qiraj"] = {
        last = "Ossirian the Unscarred",
        why = {"The silithid had come out of Ahn'Qiraj, and the Cenarion Circle carried the fight into the ruins.",
            "The Scarab Wall had been opened, and the qiraji army waited in the ruins behind it.",
            "The qiraji had raised an army behind the wall for a thousand years, and the Cenarion Circle meant to break it before it marched."},
        inside = {"Great stone ruins stood half buried in the sand, and the silithid swarmed between them.",
            "The ruins ran back from the gate to the hall of the qiraji general, and the swarms held every yard of them.",
            "Qiraji and silithid held the ruins together, the one commanding and the other without number."},
        detail = {"The ruins formed part of the qiraji fortress beyond the Scarab Wall.",
            "Crystals stood among the ruins, and the qiraji general drew his strength from them.",
            "The Cenarion Circle had sent a night elf captain and his men into the ruins, and they held a camp inside."},
        again = {"The sand of the ruins still swarmed with silithid, and the qiraji still commanded them.",
            "The ruins stood as broken as before, and the swarms had come back into them.",
            "The gate of the Scarab Wall still stood open on the ruins."},
        unfinished = {"The qiraji general had not been reached, in the hall at the back of the ruins.",
            "Past the hives and the general's officers, the ruins ran on to Ossirian.",
            "The swarm still had its general."}},
    ["Ahn'Qiraj Temple"] = {
        last = "C'Thun",
        why = {"Under the temple, the old god C'Thun was waking, and the qiraji served him.",
            "The twin emperors ruled the qiraji from the temple, and the thing they served lay beneath it.",
            "The night elves and the bronze dragons had sealed the qiraji in a thousand years before, and the seal had been broken."},
        inside = {"The temple went down and down, to where C'Thun lay.",
            "The halls of the temple were built for the qiraji, and the stone of them was not stone.",
            "Silithid of every kind filled the temple, and the qiraji drove them."},
        detail = {"The twin emperors, Vek'lor and Vek'nilash, ruled the qiraji from the temple.",
            "A prophet of the qiraji kept the first hall of the temple, and spoke with the old god's voice.",
            "The old god lay in the deepest hall, and the halls above it had been built to keep him."},
        again = {"The temple still went down and down, and the qiraji still held every hall of it.",
            "The halls of the temple were as strange as before, and as full.",
            "The old god still lay under the temple."},
        unfinished = {"The deepest hall had not been reached, and C'Thun still lay in it.",
            "Past the emperors' hall, the temple went down to the old god himself.",
            "The twin emperors still ruled the qiraji, and the old god still dreamed beneath them."}},
    ["Naxxramas"] = {
        last = "Kel'Thuzad",
        why = {"Kel'Thuzad ruled the necropolis of Naxxramas, floating above the Plaguelands.",
            "The Scourge had brought the necropolis down out of the north, and the Argent Dawn wanted it emptied.",
            "Kel'Thuzad had founded the Cult of the Damned and died for it, and the Lich King had raised him to rule from the necropolis."},
        inside = {"The necropolis was cold, and each of its four wings held one of the Scourge's worst.",
            "Four wings ran out from the center of the necropolis, and the lich's own hall lay above them all.",
            "The halls of the necropolis were built of bone and black stone, and the Scourge filled every one."},
        detail = {"The Scourge gathered inside the floating necropolis, preparing for another assault.",
            "One wing of the necropolis held the Scourge's spiders, one its plague, one its soldiers and one its constructs.",
            "A frost wyrm guarded the way to the lich's hall, raised from a blue dragon the Scourge had killed."},
        again = {"The necropolis still hung over the Plaguelands, and its halls were as cold as before.",
            "The four wings still ran out from the center, and the Scourge still held them.",
            "Naxxramas was still the lich's, whatever had been done in its wings."},
        unfinished = {"The lich's hall had not been reached, above the four wings.",
            "Past the wings, the way ran up to the frost wyrm and the lich beyond it.",
            "Kel'Thuzad still ruled the necropolis.",
            "The four wings had not all been emptied, and the way to the lich stayed shut."}},
}
-- Captured Forever quest text, kept separate from the Classic dungeon roster.
L.dungeonStory['Ruins of Lordaeron'] = {
    setting = 'Forever', source = 'StorageInvestigation/journal-voice/quests_corpus.txt #92401, #92422',
    why = {"Reports from {p:Lordamere Overlook} named Rath'mael as the source of the fog over the ruined capital."},
    inside = {"An unholy fog gave the Scourge cover in the streets and graveyard above the {p:Undercity}."},
    detail = {"Families still searched the overrun graveyard for their missing dead."},
    last = "Rath'mael",
    again = {"The fog still lay over the streets of the capital, and the Scourge still walked in it.",
        "The graveyard above the {p:Undercity} was as trodden as before, and no quieter.",
        "The ruins of Lordaeron had been the Scourge's since Arthas razed the city, and one visit had not changed that.",
        "The broken streets still ran up toward the old throne room, and the Scourge still held them."},
    unfinished = {"The necromancer who had brought the fog had not been reached, in the deeper streets of the ruin.",
        "Rath'mael still kept his place in the ruins, and the fog over them was his.",
        "Past the graveyard, the streets ran on into the fog, and its maker still stood at the end of them."},
}
L.dungeonStory['The Hall of Thanes'] = {
    setting = 'Forever', source = 'StorageInvestigation/journal-voice/part1_corpus.txt #96393, #96394, #96403',
    why = {"A Dark Iron incursion had disturbed the tombs beneath {p:Old Ironforge}."},
    inside = {"Restless dead stirred in the lower vaults of the {p:Hall of Thanes}."},
    detail = {"Dark Iron invaders had emerged from the deeper caverns in mole machines."},
    last = "Durgen Dirgehammer",
    again = {"The tombs beneath {p:Old Ironforge} were as cold as before, and the thanes in them no quieter.",
        "The Dark Irons still dug under Ironforge, and the dead of the hall still stirred for it.",
        "The way down into the vaults ran the same as it had, past the same closed tombs.",
        "The keepers of the hall still would not go in."},
    unfinished = {"The Dark Iron commander had not been reached, in the deeper vaults under the city.",
        "Durgen Dirgehammer still held the lower caverns, and his diggers still worked toward the vaults.",
        "Past the tombs of the thanes, the tunnels ran on down to the mole machines and the commander who had brought them."},
}
-- Forever pass 2026-11-05: more lines from the captured quest text, so a
-- return visit does not repeat the first. Sources per line in the comments.
do
    local function More(pool, lines) for _, line in ipairs(lines) do pool[#pool + 1] = line end end
    local RoL, HoT = L.dungeonStory['Ruins of Lordaeron'], L.dungeonStory['The Hall of Thanes']
    RoL.source = RoL.source .. ', #92421, #95189, #95195, #95216'
    More(RoL.why, {"The Scourge still roamed the old capital in great numbers, and the Forsaken who fought to reclaim it were dwindling.", -- #92421
        "Relics of the fallen kingdom lay in the ruins, and both {p:Stormwind} and the {p:Undercity} wanted them back."}) -- #95189, #95204
    More(RoL.inside, {"Ghouls, wights and abominations walked the broken streets of Lordaeron's old capital.", -- wiki boss types
        "The graveyard lay trodden by the dead, among the ruins of the city Arthas had razed."}) -- #92401, #92415
    More(RoL.detail, {"Old crests of Lordaeron and the insignia of its soldiers still lay in the rubble.", -- #95189, #95195
        "A spider in the ruins carried a venom said to eat through undead flesh."}) -- #95216
    HoT.source = HoT.source .. ', #96391, #96392, #96395'
    More(HoT.why, {"A Dark Iron map showed tunnels that met beneath {p:Ironforge}, and their diggers were heading for its vaults.", -- #96391
        "Earthseer Farsen, a Wildhammer visiting from Aerie Peak, had seen the Dark Iron spies gather in {p:Dun Morogh}."}) -- #96392
    More(HoT.inside, {"The keepers of the hall would not go in, for the dead had woken in their tombs.", -- #96394
        "Below the halls of the living city lay the old tombs of Ironforge's thanes."}) -- #96393, #96394
    More(HoT.detail, {"The ghost of an old thane could not rest for an ancient grudge.", -- #96395
        "A gnome named Thom had offered to look after the vaults' heirlooms, and seemed eager to appraise them."}) -- #96403
end
-- Forever 1.60.1 dungeons and raids with no captured quest text yet: public
-- setting only (warcraft.wiki.gg Krol'dok Stronghold, Riverglades, Mount Hyjal
-- (Forever), Barrow Deeps; LoreForever zone:hyjal for the Druids of the Claw).
L.dungeonStory["Krol'dok Stronghold"] = {
    setting = 'Forever', source = 'https://warcraft.wiki.gg/wiki/Krol%27dok_Stronghold; https://warcraft.wiki.gg/wiki/Riverglades',
    why = {"Ogres of the Twilight's Hammer held Krol'dok Stronghold in the Riverglades.",
        "Long ago the Horde had fallen back to Krol'dok after its siege of Farholde failed, and the ogres had kept the fortress since."},
    inside = {"Ogres of the Twilight's Hammer filled the fortress."},
    detail = {"In the Second War, the Brotherhood of the Horse had driven the besiegers of Farholde back to these walls."},
    again = {"The ogre walls of Krol'dok still stood over the valley, and the Twilight's Hammer still held them.",
        "The fortress had been built for a siege and kept for one, and the way in was no easier the second time.",
        "The ogres of the Twilight's Hammer still filled the yards of the stronghold."},
    unfinished = {"The inner halls of the stronghold had not been reached, and the ogres' masters still held them.",
        "Past the outer yards, the fortress went on into halls the Twilight's Hammer still kept.",
        "The stronghold still had its masters, in the halls beyond the walls already fought through."},
}
L.dungeonStory["Barrow Deeps"] = {
    setting = 'Forever', source = 'https://warcraft.wiki.gg/wiki/Mount_Hyjal_(Forever); LoreForever zone:hyjal (wiki Barrow Deeps)',
    why = {"Beneath Mount Hyjal lay the barrow deeps, where the Druids of the Claw had slept for thousands of years."},
    inside = {"The barrow dens ran deep under the mountain, among the oldest places of the night elves."},
    detail = {"Malfurion Stormrage had woken the sleeping druids here with the Horn of Cenarius, to fight the Legion."},
    again = {"The barrow dens ran as far under the mountain as before, and had not grown younger.",
        "The dens had held sleeping druids for thousands of years, and the quiet of them had not changed.",
        "The way down under the mountain wound the same as it had, root over root."},
    unfinished = {"The deepest dens had not been reached, and whatever held them still did.",
        "Past the first dens, the barrows ran on under the mountain into halls not yet fought through."},
}
L.dungeonStory["Hyjal Summit"] = {
    setting = 'Forever', source = 'https://warcraft.wiki.gg/wiki/Mount_Hyjal_(Forever); LoreForever zone:hyjal (wiki Battle of Mount Hyjal, Nordrassil)',
    why = {"The summit of Hyjal held Nordrassil, the World Tree, and the Well of Eternity beneath it."},
    inside = {"Nordrassil stood over the summit, still scarred from the last battle of the Third War."},
    detail = {"Archimonde had died at the roots of the tree, and the night elves had lost their immortality with him."},
    again = {"Nordrassil still stood over the summit, scarred as before, and the Well still lay under its roots.",
        "The slopes below the tree still showed where the Legion had burned its way up them.",
        "The summit of the mountain was the same ground the last battle of the Third War had been fought on, and it kept the marks."},
    unfinished = {"The summit had not been reached, and whatever held it still did.",
        "Past the lower slopes, the way ran on up toward the roots of the World Tree."},
}
function L.DungeonStory(name) return name and L.dungeonStory[DUNGEON_ALIASES[name] or name] end
-- What was seen inside, by the part of the dungeon you fought in (the
-- Scarlet Monastery's wings, from its bosses): {inside, detail}, or nil.
-- bosses: a list of names, or of {name = ...} / {d = ...}.
-- The lines of a list that do not name any of these bosses (the kill line will).
function L.WithoutBosses(list, bosses)
    if not list then return nil end
    local kept = {}
    for _, line in ipairs(list) do
        local names = false
        for _, boss in ipairs(bosses or {}) do
            local bossName = type(boss) == "table" and (boss.name or boss.d) or boss
            local short = type(bossName) == "string" and (L.Short and L.Short(bossName) or bossName)
            if type(bossName) == "string" and (line:find(bossName, 1, true) or (short and #short >= 4 and line:find(short, 1, true))) then names = true end
        end
        if not names then kept[#kept + 1] = line end
    end
    return #kept > 0 and kept or nil
end
function L.DungeonSight(name, bosses)
    local story = L.DungeonStory(name)
    if not story or not story.wings then return nil end
    for _, boss in ipairs(bosses or {}) do
        local bossName = type(boss) == "table" and (boss.name or boss.d) or boss
        for _, wing in ipairs(story.wings) do
            for _, known in ipairs(wing.bosses) do if known == bossName then return wing end end
        end
    end
    return nil
end
-- Zone stories, for a first visit: what you see (sight) and what is at stake
-- there (stakes). Plain sentences, no "you" or "I", vanilla lore only.
L.zoneStory = {
    ["Elwynn Forest"] = {
        sight = {"Farms and woods ran green down to the river, under the walls of {p:Stormwind}.",
            "The road out of {p:Northshire} ran past the abbey's vineyards to the Lion's Pride Inn at {p:Goldshire}.",
            "Kobolds had dug into the {p:Fargodeep Mine} and the {p:Jasperlode Mine}, and no miner of Stormwind worked them any more.",
            "The loggers of {p:Eastvale Logging Camp} cut timber for Stormwind where the forest climbed toward the hills of {p:Redridge}.",
            "The Stonefields and the Maclures farmed side by side south of Goldshire, and had feuded for as long as anyone remembered.",
            "Fishermen worked the shore of {p:Crystal Lake}, below the inn at Goldshire, and murlocs had made camps across the water from them."},
        stakes = {"Kobolds dug in the mines, and the Defias robbed the roads.",
            "{p:Hogger} led the Riverpaw gnolls out of the western woods, and the guards of Stormwind had never caught him.",
            "Stormwind's army was away in distant lands, and the few guards left could not watch every farm.",
            "Defias bandits had slipped in from {p:Westfall} and hid among the farms south of Goldshire.",
            "Murlocs had come up the rivers from the coast and camped on the shores of Crystal Lake and Stone Cairn Lake.",
            "The Riverpaw gnolls had crossed over from Westfall, and the garrison at Westbrook could not hold them off alone."}},
    ["Westfall"] = {
        sight = {"Empty farms and scarecrows stood in the dry fields, and the wind turned the windmills for no one.",
            "Harvest golems built to reap the wheat walked the fields on their own, long after the farmers had gone.",
            "The road ran south past the ruins of {p:Moonbrook}, down to the lighthouse on the coast.",
            "The Saldean and Furlbrow farms still stood along the road, among fields that had once fed {p:Stormwind}.",
            "The {p:Jangolode Mine} opened in the hills to the north, and kobolds had taken it for themselves.",
            "The tower of {p:Sentinel Hill} stood over the plains, and the People's Militia flew its banner from the top."},
        stakes = {"The Defias Brotherhood had driven the farmers out, and the People's Militia held {p:Sentinel Hill}.",
            "Stormwind had never paid the stonemasons who rebuilt it, and the Defias they became had taken Westfall for themselves.",
            "Gnolls worked with the Defias, and murlocs held the coast.",
            "Stormwind sent no soldiers, so Gryan Stoutmantle raised a militia out of the farmers the Defias had robbed.",
            "The Defias wore red bandanas and held {p:Moonbrook} openly, and something larger was being built in the mines beneath it.",
            "Riverpaw gnolls had set up camps from the Dagger Hills to the Alexston farm, and robbed whoever still travelled the road."}},
    ["Redridge Mountains"] = {
        sight = {"Red hills rose around Lake Everstill, and {p:Lakeshire} stood on its shore.",
            "A stone bridge crossed the lake at {p:Lakeshire}, and the masons had never finished repairing it.",
            "Pines grew on the red hills, and the lake lay still below them.",
            "Stonewatch Keep stood on its hill east of the lake, and orc banners hung from it.",
            "The road climbed east out of Lakeshire past Alther's Mill, toward the tower of Ilgalar.",
            "Murlocs had come up out of the lake and camped along its shores, within sight of the town."},
        stakes = {"The Blackrock orcs came down from the mountains, and {p:Lakeshire} could barely hold.",
            "Gnolls raided the farms around the lake, and the town sent to Stormwind for help that never came.",
            "The Blackrock orcs had taken Stonewatch Keep, and Shadowhide gnolls held the hills around it.",
            "Magistrate Solomon had written to Stormwind for soldiers again and again, and no soldiers came.",
            "Blackrock Mountain lay to the north, and its orcs had crossed the hills into Redridge in force.",
            "The wizard Morganth had made himself at home in the tower of Ilgalar and taught the gnolls his shadow magic."}},
    ["Duskwood"] = {
        sight = {"The woods lay in a night that never lifted, under trees that had grown crooked in it.",
            "Lamps burned in {p:Darkshire} at every hour, for the day never came.",
            "Graves filled the cemetery on Raven Hill, and not all of them stayed closed.",
            "The ogres of the Vul'Gol mound had settled in the south of the woods, and no one had moved them since.",
            "Raven Hill had been a town once, and only its graveyard still had company.",
            "A stone road ran through the woods from {p:Elwynn} toward {p:Deadwind Pass}, and the Night Watch patrolled it."},
        stakes = {"The dead walked in its woods, and only the Night Watch stood against them.",
            "Stormwind had pulled its guards out, and the Night Watch of {p:Darkshire} was all that was left.",
            "Worgen hunted in the Brightwood, and the dead rose on Raven Hill.",
            "The necromancer Morbent Fel kept to the Forlorn Rowe at Raven Hill, and the dead there answered to him.",
            "The woods had been Brightwood once, before the darkness settled on them and the dead began to walk.",
            "Spiders the size of hounds filled the Rotting Orchard, and the farms around it stood empty."}},
    ["Stranglethorn Vale"] = {
        sight = {"The jungle was thick and loud, with ruins of troll cities in its green.",
            "Rivers ran through the jungle, down to {p:Booty Bay} in the south.",
            "Broken troll temples stood among the vines.",
            "The {p:Gurubashi Arena} stood in the middle of the jungle, and fighters of both sides came to it.",
            "{p:Booty Bay} hung on the cliffs of the southern cape, built by goblins out of timber and ship's planks.",
            "Zul'Gurub lay in the eastern jungle, the old capital of the Gurubashi empire, and the trolls had gone back to it.",
            "Hemet Nesingwary's camp stood in the northern jungle, and the hunters there talked of nothing but raptors and tigers."},
        stakes = {"Trolls, pirates and hunters of every kind fought over the vale.",
            "Hemet Nesingwary's hunters camped in the north, and the jungle beasts paid for it.",
            "The Bloodsail pirates raided the coast and wanted {p:Booty Bay} for themselves.",
            "The Gurubashi trolls had split into tribes, and in {p:Zul'Gurub} their blood god stirred.",
            "The Bloodscalp and Skullsplitter trolls fought each other across the jungle, and killed any traveller caught between them.",
            "Colonel Kurzen had deserted Stormwind with his men and ruled a camp in the northern jungle, and the soldiers who stayed loyal held a camp of their own against him.",
            "The Gurubashi had called the blood god Hakkar into their capital long ago, and the empire had torn itself apart over it."}},
    ["Dun Morogh"] = {
        sight = {"Snow lay deep on the mountains, around the gates of {p:Ironforge}.",
            "Pines and snow ran from {p:Kharanos} up to the gates of {p:Ironforge}.",
            "The gates of {p:Ironforge} were cut into the side of the mountain, and a stone ramp climbed to them through the snow.",
            "The Thunderbrew Distillery stood at {p:Kharanos}, and its ale went up the mountain to Ironforge by the cask.",
            "The rams of Amberstill Ranch grazed in the snow east of Kharanos, bred for the riders of Ironforge.",
            "The Gol'Bolar quarry lay cut into the hills south of the road, and troggs had come up through its floor."},
        stakes = {"Troggs had come up from below, and the Frostmane trolls pressed in from the hills.",
            "{p:Gnomeregan} had fallen, and its people had fled to Ironforge.",
            "Leper gnomes wandered outside the gates of {p:Gnomeregan}, their minds gone.",
            "The Frostmane trolls held Shimmer Ridge and the caves of the Grizzled Den, and raided the farms below.",
            "Wendigos had come down from the high caves and taken the rams of Amberstill Ranch.",
            "The Dark Irons had been driven out of Dun Morogh long ago, and their spies had begun to come back."}},
    ["Loch Modan"] = {
        sight = {"A great dam held back the water of the loch.",
            "{p:Thelsamar} stood under the hills on the western shore.",
            "Farms and hills ran around the water of the loch.",
            "The Stonewrought Dam stood at the north end of the water, and the dwarves who built it still walked its top.",
            "The pass of Dun Algaz ran north out of the hills, down toward the {p:Wetlands}.",
            "The Explorers' League had dug into the hills at Ironband's excavation, and troggs had come up where they dug."},
        stakes = {"Troggs and Dark Iron dwarves troubled the hills, and the dam had to hold.",
            "Ogres raided {p:Thelsamar} from the hills, led by one called Chok'sul.",
            "Dark Iron saboteurs wanted the Stonewrought Dam brought down.",
            "The Mo'grosh ogres had settled the eastern hills above the loch, and the Mountaineers could not shift them.",
            "Stonesplinter troggs had taken the Silver Stream mine and the hills around it, and the miners had fled.",
            "The dam held back the whole loch above the {p:Wetlands}, and the Dark Irons knew it."}},
    ["Wetlands"] = {
        sight = {"The marshes stretched between {p:Menethil Harbor} and the mountains.",
            "{p:Menethil Harbor} stood on the western shore of the marshes, and ships came in from across the sea.",
            "The mountain fortress of Grim Batol rose in the east, and no one went near it.",
            "The Thandol Span crossed the water in the north, the one bridge between the marshes and {p:Arathi}.",
            "Raptors nested among the dig sites of the Explorers' League, who had come for the bones in the marsh.",
            "The harbor was named for the kings of Lordaeron, and its stone pier took the ships from Kalimdor."},
        stakes = {"The Dragonmaw orcs had been driven out of Grim Batol, and they camped in the hills below it.",
            "Dark Iron dwarves held Dun Modr, in the north of the marsh.",
            "Red dragons still held the fortress, and hunted the orcs who had once enslaved them.",
            "In the Second War the Dragonmaw clan had held the red dragons in chains at Grim Batol, and the dragons had not forgotten.",
            "Murlocs of the Bluegill tribe held the marsh north of the harbor, and the road to the Thandol Span ran through them.",
            "The Dark Irons had taken Dun Modr and the northern end of the Thandol Span, and travel to Arathi had stopped."}},
    ["Arathi Highlands"] = {
        sight = {"The broken walls of Stromgarde stood over the hills.",
            "The great bridge of the Thandol Span crossed south into {p:the Wetlands}.",
            "Stone circles stood on the hills, older than Stromgarde.",
            "The highlands had been the heart of Arathor, the first kingdom of men, and Stromgarde its capital.",
            "{p:Hammerfall} stood in the northeast, built where the orcs had once been kept in a camp.",
            "Ogres of the Boulderfist held the hills in the south, around their hall in the cliffs."},
        stakes = {"The Syndicate and the ogres fought over Stromgarde, and its last loyal men held {p:Refuge Pointe}.",
            "The Horde held {p:Hammerfall}, and the two sides fought over the hills.",
            "Witherbark trolls and Boulderfist ogres held the eastern hills.",
            "Stromgarde had fallen three ways, to the Syndicate, the Boulderfist and the men still loyal to Trollbane.",
            "The Horde named {p:Hammerfall} for Orgrim Doomhammer, who died there freeing the orcs of the camps.",
            "Elementals walked in the stone circles of the hills, bound there longer than anyone could say."}},
    ["Hillsbrad Foothills"] = {
        sight = {"Green farms and orchards ran down to the sea at {p:Southshore}.",
            "The old fortress of Durnholde stood over the hills, where Thrall had once been a slave.",
            "Orchards and farms ran from the hills of {p:Tarren Mill} down to the coast.",
            "The farms of the Hillsbrad Fields still grew their crops, among the last in Lordaeron to do so.",
            "Thoradin's Wall ran along the eastern hills, built by the first kingdom of men against the trolls.",
            "Dwarves of Ironforge held Dun Garok on the southern coast, and watched the sea."},
        stakes = {"{p:Tarren Mill} and {p:Southshore} watched each other across the hills, and neither forgave.",
            "The Syndicate held Durnholde and raided the farms below.",
            "The Forsaken raided the farms, and the farmers took up arms.",
            "Durnholde had been the prison where Aedelas Blackmoore raised Thrall as a slave, and the Syndicate held it now.",
            "Murlocs had come ashore along the eastern strand, and the fishermen could not work the coast."}},
    ["Alterac Mountains"] = {
        sight = {"Snow and ruins covered the mountains.",
            "The city of Dalaran stood inside a great violet dome, on the shore of the lake.",
            "Ruins of the city of Alterac lay under the snow, and ogres camped among them.",
            "The passes of the mountains led north to the Alterac Valley, where the Frostwolf orcs and the Stormpike dwarves fought.",
            "Lordamere Lake lay below the mountains, and the Syndicate kept a camp on its western shore."},
        stakes = {"The Syndicate and the ogres held what remained of the kingdom of Alterac.",
            "The wizards of Dalaran worked behind their dome, and let no one in.",
            "The Syndicate were the old nobles of Alterac, turned thieves.",
            "Alterac had betrayed the Alliance in the Second War, and the Alliance had razed its capital for it.",
            "The Crushridge ogres held the ruins of the capital, and the Syndicate held the town of Strahnbrad below it."}},
    ["Silverpine Forest"] = {
        sight = {"Tall pines ran down to the shore of Lordamere Lake.",
            "{p:Pyrewood Village} looked like any human town by day.",
            "{p:Shadowfang Keep} stood on its hill above the pines.",
            "The Greymane Wall closed the southern road, and Gilneas lay shut behind it.",
            "The towers of {p:Ambermill} stood in the southeast, and the mages of Dalaran still held the village.",
            "{p:Fenris Isle} lay out in the lake, and the keep on it had belonged to a lord of Lordaeron once."},
        stakes = {"Worgen hunted in the pines, and the Forsaken held {p:the Sepulcher} against them.",
            "Arugal's curse had made worgen of the people of {p:Pyrewood Village}, and they turned at night.",
            "Dalaran's wizards were at work in {p:Ambermill}, and the Forsaken wanted to know why.",
            "Rot Hide gnolls carried corpses from Tirisfal across the lake to {p:Fenris Isle}.",
            "Gilneas had walled itself off behind the Greymane Wall before the plague, and had not opened the gate since.",
            "The Deathstalkers of the Sepulcher watched the keep on the hill, and the worgen that came down from it."}},
    ["Tirisfal Glades"] = {
        sight = {"Fields gone to weed and trees without leaves spread across the glades.",
            "The ruins of Lordaeron stood over the glades, and the {p:Undercity} lay beneath them.",
            "The windmills of Agamand Mills turned over empty fields.",
            "The Gallows' End Tavern stood in {p:Brill}, and the Forsaken kept it open for their own.",
            "The {p:Scarlet Monastery} stood in the northeast of the glades, and its bells still rang.",
            "The farms of the glades had fed the capital of Lordaeron once, and the plague had emptied every one of them."},
        stakes = {"The Forsaken held the glades, and the Scarlet Crusade burned what it called unclean.",
            "The Scourge were trying to make a base at Agamand Mills, to strike deeper into the glades.",
            "The Forsaken rose from their graves at {p:Deathknell}, and each was sent out to fight.",
            "The Scarlet Crusade held the monastery and a chain of towers, and killed every Forsaken they caught.",
            "The Royal Apothecary Society worked in the {p:Undercity} on a plague of its own, and tested it on whatever it could find.",
            "Rot Hide gnolls held Garren's Haunt, and carried corpses out of the glades by night."}},
    ["Western Plaguelands"] = {
        sight = {"The farms were sick, and the grain was black.",
            "The towers of {p:Andorhal} stood in ruins, and the Scourge walked its streets.",
            "An island keep, {p:Caer Darrow}, stood in the lake to the south.",
            "Uther Lightbringer lay in his tomb on Sorrow Hill, and the Scourge had not touched it.",
            "Cauldrons of plague stood on the farms, and the fields around them had turned grey.",
            "{p:Hearthglen} stood in the northern hills, and the Scarlet Crusade held it."},
        stakes = {"The Scourge held the land, and the Argent Dawn fought to cleanse it.",
            "A lich held {p:Andorhal}, and the Argent Dawn meant to drive him out.",
            "Under {p:Caer Darrow}, the {p:Scholomance} trained the Scourge's necromancers.",
            "The plague had gone out in the grain from Andorhal, and the farms that grew it had been the first to die.",
            "The Scarlet Crusade held Hearthglen and trusted no one, and the Argent Dawn had broken from them over it."}},
    ["Eastern Plaguelands"] = {
        sight = {"Rot and ash covered the land, as far as the eye could see.",
            "The trees had turned red and strange, and the rivers ran foul.",
            "{p:Light's Hope Chapel} stood alone on its hill in the east.",
            "{p:Naxxramas} hung in the sky over the plaguewood, and the dead gathered under it.",
            "The walls of {p:Stratholme} stood in the north, and the city still burned inside them.",
            "Mushrooms grew taller than men in the Fungal Vale, fed on the rot."},
        stakes = {"The Scourge ruled there, from {p:Stratholme} to {p:Naxxramas} in the sky.",
            "The Argent Dawn held {p:Light's Hope Chapel} against the dead.",
            "The Scarlet Crusade held Tyr's Hand, and trusted no one.",
            "The Mossflayer trolls of Zul'Mashar had fallen to the plague, and walked as the Scourge's own.",
            "The high elves held Quel'Lithien Lodge in the north, one of the last of their kind south of Quel'Thalas."}},
    ["The Hinterlands"] = {
        sight = {"Wooded hills and troll ruins filled the land.",
            "Gryphons flew over {p:Aerie Peak}, home of the Wildhammer dwarves.",
            "The troll city of Jintha'Alor rose in terraces over the hills.",
            "The Wildhammer dwarves kept {p:Aerie Peak} in the western hills, apart from Ironforge since the War of the Three Hammers.",
            "The high elves of Quel'Danil Lodge kept to the northern hills, one of the last of their outposts.",
            "The Altar of Zul stood among the troll ruins in the south, and the trolls still came to it."},
        stakes = {"The Witherbark and Vilebranch trolls held the old ruins, and the Wildhammer held Aerie Peak.",
            "The Revantusk trolls on the coast had broken with the others and joined the Horde.",
            "Green dragons had come to the Seradane, and they did not welcome visitors.",
            "The Vilebranch held Jintha'Alor and served the spider god Shadra, and kept prisoners for her.",
            "The Wildhammer and the forest trolls had fought over these hills since before the Second War."}},
    ["Badlands"] = {
        sight = {"The land was dry, cracked and red, with dragon bones in the dust.",
            "The old doors of {p:Uldaman} were cut into the cliffs in the north.",
            "{p:Kargath} stood in the western cliffs, and dry canyons ran east from it.",
            "Black dragons nested in Lethlor Ravine, at the eastern edge of the waste.",
            "Angor Fortress stood in the middle of the waste, and the Dark Irons held it.",
            "Dustbelcher ogres held the southern canyons, among the bones of things that had died long before them."},
        stakes = {"Ogres, Dark Irons and dragons all laid claim to the waste.",
            "Black dragons nested in Lethlor Ravine.",
            "Diggers from every side worked at {p:Uldaman}, looking for the titans' secrets.",
            "The Dark Irons held Angor Fortress and sent their diggers into Uldaman, and the Explorers' League raced them for it.",
            "The Dustbelcher ogres had made a camp of Agmond's End in the south, and raided the road from Kargath."}},
    ["Searing Gorge"] = {
        sight = {"Fire and slag filled the gorge, under {p:Blackrock Mountain}.",
            "The Cauldron, a great pit of slag and fire, lay at the heart of the gorge.",
            "The way into {p:Blackrock Mountain} lay at the south end of the gorge.",
            "The Dark Irons worked slaves in the Slag Pit, in the pits below the Cauldron.",
            "{p:Thorium Point} stood on the northern edge of the gorge, where the Thorium Brotherhood kept its forges.",
            "The gorge had burned since Thaurissan called Ragnaros out of the earth, and the mountain rose where his city had been."},
        stakes = {"The Dark Iron dwarves worked their slaves in the gorge.",
            "The Thorium Brotherhood had broken from the Dark Irons and made camp on the edge of the gorge.",
            "Fire elementals walked the gorge, called up by the Dark Irons.",
            "The Dark Irons had made slaves of the dwarves they captured, and worked them in the pits of the Cauldron.",
            "Golems of the Dark Irons walked the gorge, and nothing living grew on the ash."}},
    ["Burning Steppes"] = {
        sight = {"Ash fell on the steppes, and the ground still smoked.",
            "The black peak of {p:Blackrock Mountain} rose over the steppes.",
            "Lava ran in cracks through the dark ground.",
            "The ruins of Thaurissan lay in the eastern steppes, what was left of the Dark Iron city when Ragnaros rose.",
            "The Blackrock orcs kept their stronghold in the north, under the mountain.",
            "Black dragonkin held the southern hills of the steppes, and the Alliance watched them from {p:Morgan's Vigil}."},
        stakes = {"The Blackrock orcs and the black dragonflight ruled the steppes.",
            "The Blackrock orcs gathered at their stronghold, and the Alliance watched them from {p:Morgan's Vigil}.",
            "Black dragonkin held the hills to the south.",
            "The steppes had burned since Thaurissan called Ragnaros out of the earth, and the Dark Iron city had died in the fire.",
            "The Thorium Brotherhood kept a camp at Flame Crest, and traded with anyone who paid."}},
    ["Swamp of Sorrows"] = {
        sight = {"Mist and dark water lay over the swamp.",
            "The temple of the Atal'ai lay drowned in the heart of the swamp.",
            "The orc fortress of {p:Stonard} stood among the reeds.",
            "{p:Stonard} had been the Horde's first fortress in the First War, and the orcs still held it.",
            "The Pool of Tears lay in the eastern swamp, and the roof of the temple showed above its water.",
            "The Lost Ones kept a camp in the swamp, draenei who had come through the Portal and been broken by it."},
        stakes = {"Below the swamp, the Atal'ai called on their blood god.",
            "{p:Stonard} was the Horde's hold in the east, far from any help.",
            "Green dragons guarded the temple, to keep the Atal'ai from their god.",
            "The Atal'ai had been cast out of Zul'Gurub for serving Hakkar, and had built their temple in the swamp to call him back.",
            "Ysera's green dragons had sunk the temple into the swamp, and still watched over the ruin."}},
    ["Blasted Lands"] = {
        sight = {"Red earth and ruin stretched to the {p:Dark Portal}.",
            "Bare red rock stretched south from {p:Nethergarde Keep}.",
            "The {p:Dark Portal} stood at the end of the valley, and nothing came through it.",
            "{p:Nethergarde Keep} stood on the northern cliffs, built by the mages of Dalaran to watch the Portal.",
            "The Dreadmaul ogres held the rock in the south, around the Altar of Storms.",
            "The Tainted Scar lay in the west, and demons walked there openly."},
        stakes = {"Demons still walked the land, and the mages of Nethergarde kept watch on the Portal.",
            "The orcs had first come into the world here, and the land had never healed.",
            "Dreadmaul ogres held the hills.",
            "The Portal had been shut at the end of the Second War, and the mages of Nethergarde watched in case it opened again.",
            "Lord Kazzak, a demon lord of the Legion, held the Tainted Scar, and the demons there answered to him."}},
    ["Deadwind Pass"] = {
        sight = {"A dead pass wound between bare mountains, past the tower of Karazhan.",
            "Karazhan, the tower of Medivh, stood empty in the pass.",
            "Nothing grew in the pass, and the trees stood grey and bare.",
            "The road ran through the pass from {p:Duskwood} to {p:the Swamp of Sorrows}, and few travelled it.",
            "Ogres had made a mound in the pass below the tower, and kept to it."},
        stakes = {"The tower of Karazhan was shut, and something still moved inside.",
            "Ogres held the pass, and beyond it lay {p:the Swamp of Sorrows}.",
            "Medivh had opened the Dark Portal from his tower, and the land around it had died with him."}},
    ["Teldrassil"] = {
        sight = {"The great tree rose from the sea, with forests on its boughs.",
            "Paths ran under the leaves to {p:Dolanaar}.",
            "{p:Darnassus} stood high in the boughs, among pools and white towers.",
            "{p:Lake Al'Ameth} lay below Dolanaar, and the Gnarlpine had made camps along its shore.",
            "The whole forest grew on the crown of one tree, planted at the sea's edge after the last war.",
            "{p:Shadowglen} lay under the boughs of {p:Aldrassil}, where the youngest of the night elves began."},
        stakes = {"Even here, corruption had crept into the woods of the night elves.",
            "The Gnarlpine furbolgs had turned wild, and no one yet knew why.",
            "The tree had been planted after the Third War, without the blessing of the dragons, and it had not grown clean.",
            "The Gnarlpine had taken Starbreeze Village from the night elves and dug into the barrow den of {p:Ban'ethil Barrow Den}.",
            "Spiders had grown large in the Shadowthread Cave, and the druids wondered what the new tree had done to them."}},
    ["Darkshore"] = {
        sight = {"Ruins of the night elves lay along the coast, from before the Sundering.",
            "{p:Auberdine} stood on its piers over the water, the one town on the long coast.",
            "The Cliffspring River ran down to the sea at the Mist's Edge.",
            "Across the water, {p:Teldrassil} rose out of the sea.",
            "The ruins of Ameth'Aran and Bashal'Aran stood along the coast, left from before the Sundering.",
            "A great skull lay on the beach at the Master's Glaive, with a blade still standing in it.",
            "Dead sea creatures lay washed up along the shore, and the night elves could not say why."},
        stakes = {"The Blackwood furbolgs had gone mad, and the river was turning foul.",
            "Naga came ashore along the coast.",
            "{p:Auberdine} was the only town on the long coast, and it had few hands to spare.",
            "Dwarves of the Explorers' League dug among the old ruins of the coast.",
            "The Twilight's Hammer had made camp at the Master's Glaive, among the bones of something that had died there long ago.",
            "Naga held the ruins of Mathystra in the north, and no one had driven them out."}},
    ["Ashenvale"] = {
        sight = {"The trees of the forest had stood since before the Sundering, and the Sentinels watched them.",
            "{p:Astranaar} stood on its island in the lake, in the middle of the forest.",
            "Moonwells stood in the clearings, and the night elves kept them clean.",
            "A monument stood in Demon Fall Canyon, where Grom Hellscream had killed Mannoroth and died of it.",
            "The Warsong lumber camp in the east had cut the forest back to stumps, and the saws still ran.",
            "The barrow den of Dor'Danil lay in the eastern woods, and the druids who had slept there did not wake."},
        stakes = {"The Horde cut the trees, and the night elves fought them for every one.",
            "Satyrs haunted the eastern woods, near the borders of {p:Felwood}.",
            "The furbolgs of the forest had turned on the night elves, their old friends.",
            "The Warsong clan had come for timber in the Third War and never left, and the Sentinels fought them for every tree.",
            "The Thistlefur and Foulweald furbolgs had turned savage, and the night elves did not know what had sickened them.",
            "Naga had come up the Zoram Strand from the sea, and the Horde had built an outpost on the shore to watch them."}},
    ["Stonetalon Mountains"] = {
        sight = {"Peaks and cliffs rose over the pass, and the great peak stood over them all.",
            "Where the goblins had been, the forest was stumps and ash.",
            "{p:Sun Rock Retreat} stood high on a ridge, out of the wind.",
            "Shredders of the Venture Company worked Windshear Crag, and the logs went out by the cartload.",
            "The Charred Vale lay burned to the rock in the west, and nothing had grown back.",
            "The druids kept {p:Stonetalon Peak} at the top of the mountains, and a pool of vision lay in their den."},
        stakes = {"The Venture Company logged the mountains bare, and the druids could not stop them.",
            "The Charred Vale had burned, and fire elementals walked it.",
            "Harpies held the high cliffs, and kobolds dug in the mines.",
            "The Grimtotem had camped in the mountains and kept apart from the other tauren.",
            "The goblin Gerenzo Wrenchwhistle ran the Venture Company's logging at Windshear Crag, and the forest fell to his machines."}},
    ["The Barrens"] = {
        sight = {"Dry grass and lone trees stretched under a wide sky.",
            "Kodo bones lay in the dry grass, and zhevra ran past them.",
            "The oases were few, and every one was fought over.",
            "The Gold Road ran north to south through the whole land, and the {p:Crossroads} stood where it met the road to the sea.",
            "The goblins of {p:Ratchet} kept the port on the coast, and sold to both sides.",
            "The {p:Great Lift} at the southern edge dropped down the cliffs into {p:Thousand Needles}.",
            "Silithid hives had risen in the Field of Giants, in the south of the grass."},
        stakes = {"Centaur and quilboar raided the plains, and the {p:Crossroads} held the middle of it all.",
            "Deviate beasts had come out of the {p:Wailing Caverns} and fouled the oases.",
            "The Alliance held Northwatch on the coast, and the Kolkar centaur raided the caravans.",
            "The Razormane and Bristleback quilboar held the thorn hills, and had killed the tauren of more than one camp.",
            "The Venture Company pumped oil at the Sludge Fen, and dwarves dug at Bael Modan in the south.",
            "Harpies of the Witchwing nested in the Dry Hills and swooped on whatever moved on the road."}},
    ["Durotar"] = {
        sight = {"Red earth and thorn ran up to the walls of {p:Orgrimmar}.",
            "The sea broke on the rocks below {p:Razor Hill}.",
            "Scorpids and boars ran over the red ground, and the orcs hunted both.",
            "The huts of {p:Sen'jin Village} stood by the water, and the Echo Isles lay out across the strait.",
            "The Southfury River ran down the western edge of the land, and beyond it lay the grass of {p:the Barrens}.",
            "Thrall had named the land for his father Durotan, and the orcs had built their capital in its northern canyon.",
            "The barracks at {p:Razor Hill} stood over the road south, where every young orc of the Horde came through."},
        stakes = {"The orcs had made a home of the hard land, and they meant to keep it.",
            "The Burning Blade hid in the caves of Skull Rock and Dustwind.",
            "Kul Tiran marines held Tiragarde Keep on the coast.",
            "Kolkar centaur raided from the north.",
            "The witch doctor Zalazane held the Echo Isles, off the coast, and hexed the Darkspear to his side.",
            "Men of Kul Tiras still held Tiragarde Keep, left behind when Admiral Proudmoore's fleet broke on the Horde.",
            "Harpies nested in Drygulch Ravine and the Dustwind caves, and the goblins' caravans paid for it."}},
    ["Mulgore"] = {
        sight = {"Green plains and mesas rolled under the wind.",
            "The mesas of {p:Thunder Bluff} rose over the plains, with lifts to their tops.",
            "The Red Rocks, where the tauren buried their dead, stood above the plains.",
            "Kodo grazed on the plains, and the tauren followed the herds as they had for generations.",
            "Stonebull Lake lay below {p:Bloodhoof Village}, and the plains ran green around it in every direction.",
            "The tauren had wandered for generations before Cairne Bloodhoof settled them here, with Thrall's help."},
        stakes = {"The tauren kept the plains, and the Venture Company wanted the land.",
            "Palemane gnolls raided the plains, and dwarves dug at the Bael'dun site.",
            "The Bristleback quilboar held the ravines in the south, and raided the tauren camps from them.",
            "The Venture Company had sunk a mine into the hills, and its filth had reached the water wells of the tauren.",
            "Dwarves of the Bael'dun dig cut into the ground for relics, and the tauren held that the earth was not theirs to cut."}},
    ["Thousand Needles"] = {
        sight = {"Tall stone spires rose from the canyon floor.",
            "Salt flats lay white at the east end of the canyons.",
            "Rope bridges ran between the mesas at {p:Freewind Post}.",
            "Goblin and gnome racers ran their machines on the salt flats at the {p:Mirage Raceway}.",
            "The {p:Great Lift} came down the cliffs from {p:the Barrens}, and the canyons opened below it.",
            "The Shimmering Flats lay at the bottom of the canyons, a dry lake bed white with salt."},
        stakes = {"Centaur held the canyons, and the goblins raced on the salt flats below.",
            "The Grimtotem clan had turned against the other tauren, and camped among the needles.",
            "The Galak centaur held the canyons and raided {p:Freewind Post} from the mesas around it.",
            "Harpies had taken the high ground above the canyons, and the tauren could not reach their nests."}},
    ["Desolace"] = {
        sight = {"The land was grey and empty, and bones lay in its valleys.",
            "Kodo bones lay in the Kodo Graveyard, where the beasts came to die.",
            "The caves of {p:Maraudon} opened in the hills to the south.",
            "Nothing grew on the grey ground, and the centaur rode over it in war bands.",
            "The Horde held {p:Shadowprey Village} on the western coast, and the Alliance held {p:Nijel's Point} in the northern hills.",
            "Naga had come ashore on the Sar'theris Strand, among the ruins along the western coast."},
        stakes = {"The centaur clans fought each other for the waste.",
            "Demons of the Legion held Mannoroc Coven.",
            "The centaur held {p:Maraudon} holy, for their father Zaetar lay there.",
            "The Gelkis and the Magram had fought each other for generations, and the land had died under their hooves.",
            "The Burning Blade kept a fortress at Thunder Axe and a coven in the south, and demons walked openly among its warlocks.",
            "Ghost Walker Post stood in the middle of the waste, the Horde's one foothold between the centaur clans."}},
    ["Dustwallow Marsh"] = {
        sight = {"Fog and marsh surrounded {p:Theramore}, on the edge of the sea.",
            "{p:Brackenwall Village} stood in the northern marsh.",
            "Crocolisks lay in the shallows, waiting.",
            "{p:Theramore} stood on its island off the coast, built by Jaina Proudmoore for the survivors of Lordaeron.",
            "The Shady Rest Inn stood burned to its stones on the road into the marsh, and no one had found out who did it.",
            "The Stonemaul ogres had lost their village in the marsh and settled at {p:Brackenwall Village} under the Horde."},
        stakes = {"Onyxia hid in the marsh, and the black dragons worked in secret.",
            "{p:Theramore} and the Horde kept an uneasy peace in the marsh.",
            "Stonemaul ogres held the south of the marsh.",
            "Black dragonkin held the Wyrmbog in the south, and no one went into it who meant to come out.",
            "The Grimtotem had camped in the marsh, and the Alliance did not know what they wanted there.",
            "Murlocs held the Dreadmurk Shore in the north, and the road from Theramore ran through their fishing grounds."}},
    ["Feralas"] = {
        sight = {"Rain and giant trees filled the forest.",
            "The ruins of {p:Dire Maul} stood deep in the forest, broken and overgrown.",
            "{p:Feathermoon Stronghold} stood on an island off the coast.",
            "The Twin Colossals stood in the north of the forest, two pillars of rock above the trees.",
            "{p:Camp Mojache} stood in the eastern forest, where the tauren watched the road from {p:Thousand Needles}.",
            "The Highborne had built Eldre'Thalas in the heart of the forest, and its ruins were called {p:Dire Maul} now."},
        stakes = {"Gordunni ogres held the old city, and the Grimtotem camped in the hills.",
            "Gnolls and ogres raided the forest roads.",
            "The Woodpaw gnolls had taken the eastern hills, and the Gordunni ogres held the ruins of the old elf city.",
            "Naga held the ruins of Solarsal on the southern coast, and the Sentinels of Feathermoon watched them.",
            "Silithid had dug hives in the Writhing Deep, in the southeast of the forest."}},
    ["Tanaris"] = {
        sight = {"Sand and sun covered the land, from the goblin town to the sea.",
            "The walls of {p:Gadgetzan} stood alone in the sand.",
            "The pyramid of {p:Zul'Farrak} rose in the north.",
            "The Caverns of Time opened in the eastern cliffs, and bronze dragons guarded the way in.",
            "{p:Steamwheedle Port} stood on the eastern coast, and the goblins shipped their goods out of it.",
            "The Sandfury trolls had built their city at {p:Zul'Farrak} when the troll empires still stood, and they held it yet."},
        stakes = {"Trolls, pirates and the silithid all troubled the desert.",
            "Wastewander bandits robbed every caravan they could.",
            "Southsea pirates held the southern coast.",
            "The Wastewander had taken the water holes east of Gadgetzan, and water in the desert was worth more than gold.",
            "Silithid had dug the Noxious Lair and the Gaping Chasm in the southern sands, and the swarms came up out of them.",
            "The Dunemaul ogres held the southwestern canyons, and the goblins paid a bounty on them."}},
    ["Un'Goro Crater"] = {
        sight = {"Beasts the size of houses walked the jungle of the crater.",
            "Hot springs and crystal pylons stood in the jungle of the crater.",
            "A volcano, {p:Fire Plume Ridge}, rose from the heart of the crater.",
            "Devilsaurs hunted the crater floor, and their tracks ran across every path.",
            "Tar pits bubbled in the north of the crater, and the beasts that fell in did not climb out.",
            "The titans had shaped the crater long ago, and their terrace still stood on its eastern rim."},
        stakes = {"Old titan machines slept in the crater, and the silithid dug beneath it.",
            "Devilsaurs hunted in the crater, and the camp at {p:Marshal's Refuge} had few walls.",
            "The Slithering Scar lay in the southern crater, and silithid came up out of it.",
            "Crystals of four colors grew in the crater, and the pylons that used them were older than anyone could say."}},
    ["Azshara"] = {
        sight = {"Ruins of the old night elf empire lay on the coast.",
            "The trees were red and gold, as if it were always autumn.",
            "Stairs of the old elves ran down into the sea.",
            "The ruins of Eldarath stood above the Bay of Storms, built when Queen Azshara ruled the night elves.",
            "The Horde held {p:Valormok} in the western hills, and the Alliance held Talrendis Point at the gate from {p:Ashenvale}.",
            "Giants walked the southern shore, and the naga held the ruins along the water."},
        stakes = {"Naga and satyrs held the ruins of Azshara's old land.",
            "Azuregos, a blue dragon, guarded the ruins of the old city.",
            "The naga had come back to the coast of their queen, and held the Temple of Zin-Malor.",
            "Satyrs of the Legash and the Haldarr held camps among the ruins, and the furbolgs of Ursolan had turned savage.",
            "The land had been named for Queen Azshara, whose pride had brought the Legion and the Sundering."}},
    ["Felwood"] = {
        sight = {"The trees had grown crooked with the sickness, and the water ran green.",
            "Jaedenar, once a night elf town, was full of demons.",
            "The Emerald Sanctuary was the one clean place in the forest.",
            "The Bloodvenom River ran green through the whole forest, down from the north.",
            "Craters of the infernals still pocked the Shatter Scar Vale, from the Legion's landing in the Third War.",
            "{p:Timbermaw Hold} stood at the north end of the forest, and the furbolgs there let only friends through to {p:Winterspring}."},
        stakes = {"The Legion's corruption had poisoned the forest to its roots.",
            "The Shadow Council held Jaedenar, and served the demons openly.",
            "Deadwood furbolgs, sick with the corruption, attacked anyone who passed.",
            "The Legion had marched through the forest in the Third War, and the sickness it left had never healed.",
            "The druids of the Emerald Sanctuary cleansed what plants they could, one root at a time."}},
    ["Winterspring"] = {
        sight = {"Snow covered the quiet valleys.",
            "The goblin town of {p:Everlook} stood in the middle of the snow, loud and warm.",
            "Hot springs steamed in the snow of the valleys.",
            "The ruins of Kel'Theril lay on the frozen lake, and the ghosts of the Highborne who built them still walked there.",
            "Frostsabers hunted the snow, and the night elves of Frostsaber Rock bred them for riders.",
            "Blue dragonkin kept the cave of Mazthoril in the southern mountains."},
        stakes = {"The Winterfall furbolgs had turned savage, and the blue dragons watched from above.",
            "Demons held Darkwhisper Gorge in the south.",
            "Frostsabers and chimaerae hunted in the snow.",
            "The Winterfall furbolgs brewed a firewater that drove them mad, and attacked anyone who passed their village.",
            "The goblins of {p:Everlook} traded with anyone, and the yetis of the Ice Thistle Hills took their caravans."}},
    ["Moonglade"] = {
        sight = {"The glade was green and still, a place the druids kept.",
            "Lake Elune'ara lay at the heart of the glade.",
            "Nighthaven, the druids' town, stood by the lake.",
            "The barrow dens of the Stormrage brothers lay under the hills, and Malfurion slept in one of them.",
            "Keeper Remulos, son of Cenarius, kept his shrine on the shore of the lake."},
        stakes = {"No one fought in the glade. The druids made sure of it.",
            "Druids of every people came to the glade to train.",
            "The Timbermaw furbolgs held the tunnels into the glade, and let only friends pass.",
            "The Cenarion Circle kept the glade as neutral ground, and tauren and night elf druids trained side by side there."}},
    ["Silithus"] = {
        sight = {"Hives and sand covered the land, and the wind never stopped.",
            "The Scarab Wall stood in the south, holding shut the gates of {p:Ahn'Qiraj}.",
            "Silithid hives rose from the sand, taller than any building.",
            "{p:Cenarion Hold} stood in the middle of the desert, and the druids held it against the swarms.",
            "Three great hives had risen in the sand, and the silithid came up out of them without end.",
            "Crystals grew in the Crystal Vale in the north, and elementals walked among them."},
        stakes = {"The silithid swarmed from {p:Ahn'Qiraj}, and the Cenarion Circle held them back.",
            "The Twilight's Hammer camped among the dunes, working for their own ends.",
            "A thousand years ago, the Scarab Wall had been raised to keep the silithid in.",
            "The night elves and the bronze dragons had fought the War of the Shifting Sands here, and sealed the qiraji behind the wall.",
            "Southwind Village lay in ruins in the southeast, overrun by the silithid."}},
    ["Stormwind City"] = {
        sight = {"Statues of the Second War's heroes lined the Valley of Heroes, before the gates.",
            "Canals ran between the districts, and bridges crossed them to the Cathedral of Light.",
            "The city had been burned in the First War and rebuilt stone by stone, and the Stonemasons who rebuilt it were never paid.",
            "The Deeprun Tram ran under the mountains from the Dwarven District to {p:Ironforge}."},
        stakes = {"The Defias had been Stormwind's own stonemasons before the city refused to pay them.",
            "Stormwind's army was away in distant lands, and the kingdom's own farms went unguarded.",
            "The Stockade lay under the city by the canals, and its prisoners had risen against their guards."}},
    ["Ironforge"] = {
        sight = {"The Great Forge burned at the center of the city, and the heat of it reached every hall.",
            "The Hall of Explorers held the bones and relics the Explorers' League had dug out of the earth.",
            "The gnomes who had fled {p:Gnomeregan} had crowded into Tinker Town, on the city's edge.",
            "King Magni Bronzebeard held the High Seat, as the Bronzebeards had since the War of the Three Hammers."},
        stakes = {"The gnomes had lost {p:Gnomeregan}, and Ironforge had taken in what was left of them.",
            "The Dark Irons had lost the War of the Three Hammers and never forgiven it.",
            "The Explorers' League dug for the dwarves' own beginnings, and the stone had started to answer."}},
    ["Darnassus"] = {
        sight = {"The Temple of the Moon stood over the city, where the priestesses of Elune kept watch.",
            "The city stood in the boughs of {p:Teldrassil}, built after the last war, and its stone was still new.",
            "The Cenarion Enclave stood in the north of the city, and the druids kept it.",
            "A portal in the city opened down onto the shore at Rut'theran Village, where the ships left for {p:Auberdine}."},
        stakes = {"Tyrande Whisperwind led the night elves from the Temple of the Moon, and the Sentinels answered to her.",
            "The druids of the Cenarion Enclave answered to Fandral Staghelm, who had planted the tree the city stood in.",
            "The city was new, and the forest around it had not grown clean."}},
    ["Orgrimmar"] = {
        sight = {"The city stood in a canyon of red rock, and its gates faced the road from {p:Razor Hill}.",
            "Thrall held court in Grommash Hold, in the Valley of Wisdom.",
            "The Cleft of Shadow lay under the city, and {p:Ragefire Chasm} opened below it.",
            "The city was named for Orgrim Doomhammer, and Thrall had built it after the Horde crossed the sea."},
        stakes = {"Thrall ruled from Grommash Hold, and the Horde he had made of orcs, trolls and tauren answered to him.",
            "Troggs and cultists had been found in the chasm beneath the city, and Thrall wanted to know who had let them in.",
            "The Valley of Spirits held the Darkspear trolls, who had followed Thrall from the islands."}},
    ["Thunder Bluff"] = {
        sight = {"The city stood on mesas above the plains, and lifts carried its people up and down.",
            "Cairne Bloodhoof kept his lodge on the high rise, and the elders of the tauren around him.",
            "Totems stood on every rise of the bluff, and the wind never left them.",
            "The Grimtotem kept their own tents on Elder Rise, under Magatha."},
        stakes = {"Cairne Bloodhoof led the tauren from the bluff, and the Horde had given him the plains to keep.",
            "Magatha Grimtotem sat on Elder Rise among the other elders, and her clan kept apart from the rest.",
            "The tauren had built the city only a few years before, after generations without a home."}},
    ["Undercity"] = {
        sight = {"The city lay in the crypts and sewers beneath the ruins of Lordaeron's capital.",
            "Lady Sylvanas held court in the Royal Quarter, with the dreadlord Varimathras beside her.",
            "Green sewage ran in the canals, and the apothecaries worked above them.",
            "The Royal Apothecary Society kept its laboratories in the Apothecarium, in the heart of the city.",
            "The throne room of Lordaeron stood empty above the city, where Arthas had killed his father."},
        stakes = {"Sylvanas Windrunner ruled the Forsaken from the ruins of the kingdom that had once been her enemy's.",
            "The Scourge had dug the crypts under the capital, and the Forsaken had taken them for their own.",
            "The apothecaries worked on a new plague in the Apothecarium, and did not say for whom."}},
}
function L.ZoneStory(name) return name and L.zoneStory[name] end
-- Forever's own zones (pass of 2026-11-05). Facts from warcraft.wiki.gg
-- (Riverglades, Shen'dralas, Zephras Isle, Mount Hyjal (Forever)), LoreForever
-- (zone:riverglades, subzone:sunnyglade, zone:shendralas, subzone:valley-of-bones,
-- zone:hyjal, zone:darkspearislands; facts only, CC BY-SA) and, for Zephras, the
-- quest corpus (#92460, #92472, #92473, #94414). The story packs append more.
L.zoneStory["Riverglades"] = {setting = "Forever",
    sight = {"Farms and logging camps lay along the rivers of the valley, down to the Forbidding Sea.",
        "The stone tower of {p:Sunnyglade} still stood over the ruins of the town.",
        "Boats left {p:Powderfuse Port} for {p:Steamwheedle Port}, across the sea in {p:Tanaris}.",
        "{p:Sunnyglade} had been a wealthy town under Stormwind, until the Horde burned it in the First War.",
        "The valley lay east of {p:the Badlands} and {p:the Burning Steppes}, and the hills of {p:Redridge} rose to the southwest.",
        "The ogre walls of {p:Krol'dok Stronghold} stood over the valley, built when the Horde first came through."},
    stakes = {"The Brotherhood of the Horse held Farholde Keep, and fought to win back land Stormwind had given up in the First War.",
        "The Twilight's Hammer held the ruins of Sunnyglade, and its ogres held {p:Krol'dok Stronghold}.",
        "The Horde kept outposts at Rog'mar and Bolder'ok, where ogres who had left the Twilight's Hammer now fought beside it.",
        "Stormwind had claimed the valley once, and the Old Horde had overrun it in the First War.",
        "Human loyalists and Horde outposts still fought over the valley, and neither side had won it."}}
L.zoneStory["The Riverglades"] = L.zoneStory["Riverglades"]
L.zoneStory["Shen'dralas"] = {setting = "Forever",
    sight = {"Highborne ruins stood among the crags, south of Desolace.",
        "The way in from Desolace ran through the Valley of Bones, past two great skeletons slumped against the cliffs.",
        "The crags lay between {p:Feralas} and {p:Mulgore}, and the ruins on them were older than either.",
        "Dust choked the Valley of Bones, and the dead there did not stay down."},
    stakes = {"The Magram centaur fought along their front, and the Bristleback quilboar held a fortified retreat.",
        "Neither Horde nor Alliance held the crags, and outcasts hid there from both.",
        "Centaur necromancers walked the Valley of Bones among the ribs of the two dead goliaths, and the dead of the valley answered them.",
        "Centaur, outcasts and quilboar fought over the crags, and the ruins changed hands with the seasons."}}
L.zoneStory["Mount Hyjal"] = {setting = "Forever",
    sight = {"Nordrassil, the World Tree, stood over the summit, still scarred by the last battle of the Third War.",
        "Forest covered the slopes of the mountain, sacred to the night elves and the Wild Gods before them.",
        "The second Well of Eternity lay under the roots of the World Tree, on the summit of the mountain.",
        "Night elves, humans and orcs had held these slopes together against the Legion, and the ground still showed it."},
    stakes = {"Archimonde had died at the roots of the World Tree, and the night elves had paid for it with their immortality.",
        "Malfurion Stormrage had sealed the mountain off after the war, and the tree had been slowly healing.",
        "The Legion had burned its way up the mountain in the Third War, and what it burned had not all grown back.",
        "The tree stood wounded over the Well, and the druids watched it as a healer watches a patient."}}
L.zoneStory["Darkspear Islands"] = {setting = "Forever",
    sight = {"The isles lay off the coast of Kalimdor, ceremonial ground of Vol'jin's trolls.",
        "The fighting ran from the camp and the old ruins to the abandoned tower and Shipwreck Cove.",
        "The Darkspear had been an island people before Zalazane and the murlocs drove them from their home.",
        "Strongpoints stood across the isles, and whichever side held them held the ground."},
    stakes = {"The Horde fought for the isles out of an old debt to the Darkspear, who had stood with Thrall when he had little else.",
        "The Alliance wanted a foothold off Kalimdor's coast, and a blow at one of the Horde's proudest peoples.",
        "The isles were sacred to Vol'jin's trolls, and the Horde did not mean to lose them.",
        "The side that held the strongpoints and took the flag held the isles, and neither side held them for long."}}
L.zoneStory["Zephras Isle"] = L.zoneStory["Zephras Isle"] or {setting = "Forever",
    sight = {"Zephras floated high in Skywall, the elemental plane of air, far above the world below.",
        "An elder tree stood in the center of Thendal Village, and the greatfather tree rose just west of it.",
        "The shen'dorei of the island were Highborne, descended from the mages of Eldre'Thalas.",
        "Valanaar stood in the lowlands, and the Windshapers and the High Order kept lodges there under an uneasy truce.",
        "Standing stones stood on the overlook above the Shen'dar Highlands, and the High Order took its readings from them.",
        "Skycutters carried travellers off the island and down to {p:Mulgore}, far below."},
    stakes = {"The air elementals who had shared the island were gone, and the magic holding it aloft was fading.",
        "The Al'Aketh cult worshipped Al'Akir the Windlord, and its zealots grew bolder by the day.",
        "The Windshapers sought the wind spirits that had vanished, and the High Order turned to the old arcane magic instead.",
        "The Al'Aketh held Falaath Village in the highlands and gathered there for war on the settlements below.",
        "Hollows had begun to appear in Shadowgale Forest where the true wind spirits had been, and no one knew what had driven them away."}}

-- Quests worth a line when turned in (why, after; zone and level of the giver).
-- Quest lore pack for the Companion Journal storyteller.
-- One true, concrete thing to say when a memorable vanilla quest is turned in.
--
-- Keys are the exact titles from review/corpus_vanilla_quests.txt. Facts come
-- from that corpus; where it is silent, only well-known vanilla lore is used.
-- Lines are shared by the "I" and "you" journals, so none of them names the
-- player: no I, you, we or they for the player. Past tense, no colons, no meta
-- words. {p:Name} marks zones and towns only.
--
-- Titles shared by several quests (a chain, or one title per race or faction)
-- get lines that hold for every part: they state the world, not the step.
-- level is the corpus level of the first part; zone is the giver's zone (for
-- chains, the NPC at the heart of the chain; see the notes).
--
-- Not in the corpus, so left out: the Test of Skulls quests, Whirlwind Weapon,
-- The Testament of Rexxar.

L.questStory = {

    ---------------------------------------------------------------- first steps

    ["Rude Awakening"] = { -- 363
        why = {"Mordo kept the crypt at {p:Deathknell}, where the risen who did not wake in time went into the fire."},
        after = {"Shadow Priest Sarvis told of Lady Sylvanas, who had freed the Forsaken from the Lich King's will."},
        zone = "Tirisfal Glades",
        level = 1,
    },
    ["A Threat Within"] = { -- 783
        why = {"With so many of Stormwind's soldiers fighting in distant lands, {p:Northshire} was calling on anyone willing to defend it."},
        after = {"Marshal McBride took one more volunteer at the abbey and spoke of a long campaign against the lawless inside the kingdom."},
        zone = "Elwynn Forest",
        level = 1,
    },
    ["Dwarven Outfitters"] = { -- 179
        why = {"Adlin Pridedrift in Coldridge Valley offered a pair of warm gloves for a bundle of wolf meat."},
        after = {"Adlin had his wolf meat, and one more pair of his gloves went out against the frostbite of {p:Dun Morogh}."},
        zone = "Dun Morogh",
        level = 1,
    },
    ["The Balance of Nature"] = { -- 456, 457
        why = {"Heavy spring rains had let the nightsabers and thistle boars of Shadowglen grow too many for the forest to feed."},
        after = {"The herds of Shadowglen were thinned, and Conservator Ilthalaine judged the balance kept."},
        zone = "Teldrassil",
        level = 2,
    },
    ["The Hunt Begins"] = { -- 747
        why = {"Camp Narache had run low on meat and feathers, and Grull Hawkwind sent the young to hunt plainstriders for the tribe."},
        after = {"The plainstrider meat and feathers came home to {p:Camp Narache}, the first proof set before Chief Hawkwind."},
        zone = "Mulgore",
        level = 2,
    },
    ["Your Place in the World"] = { -- 4641, the first orc and troll quest
        why = {"Kaltunk looked over each recruit who came of age in the Valley of Trials and sent each one to Gornek, for work less dangerous than dragons."},
        after = {"Gornek took in another of Kaltunk's recruits and said plainly that the Horde had seen better."},
        zone = "Durotar",
        level = 1,
    },
    ["Sarkoth"] = { -- 790, 804
        why = {"Hana'zua lay bleeding under a tree in the Valley of Trials, cut open by the stinger of a scorpid called Sarkoth."},
        after = {"Sarkoth lay dead on the plateau, and Gornek sent help out to Hana'zua."},
        zone = "Durotar",
        level = 5,
    },
    ["Lazy Peons"] = { -- 5441
        why = {"The peons of the Valley of Trials kept napping on the job, and Foreman Thazz'ril handed out a blackjack to wake them."},
        after = {"A few sore peons went back to their lumber, and the blackjack went back to the foreman."},
        zone = "Durotar",
        level = 4,
    },

    ---------------------------------------------------------------- Tirisfal and Silverpine

    ["The Scarlet Crusade"] = { -- 381
        why = {"Scouts at {p:Deathknell} found the Scarlet Crusade making camp to the southeast, sworn to destroy every undead in the land."},
        after = {"The Scarlet camp near {p:Deathknell} was broken before it could strike."},
        zone = "Tirisfal Glades",
        level = 4,
    },
    ["At War With The Scarlet Crusade"] = { -- 427, 370, 371, 372
        why = {"Documents taken by Executor Arren showed where every Scarlet brigade stood in {p:Tirisfal}, down to the ruined towers they held."},
        after = {"Captains Perrine, Vachon and Melrache fell in their towers, and the Crusade's advance through the glades slowed."},
        zone = "Tirisfal Glades",
        level = 8,
    },
    ["Rot Hide Clues"] = { -- 439
        why = {"Among the corpses the Rot Hide gnolls had carried off lay a woman's hand, and on it a ring engraved For Deliah."},
        after = {"The Rot Hides had been stealing bodies from the mass graves of {p:Tirisfal} and taking them to Fenris Isle."},
        zone = "Silverpine Forest",
        level = 16,
    },
    ["A Husband's Revenge"] = { -- 530
        why = {"Raleigh of the Undercity learned that Valdred, once his good friend, had murdered his wife Deliah."},
        after = {"Valdred died at the Greymane Wall, and Raleigh kept his hands and gave away his wife's ring."},
        zone = "Undercity",
        level = 20,
    },
    ["Deathstalkers in Shadowfang"] = { -- 1098
        why = {"High Executor Hadrec had sent two deathstalkers, Adamant and Vincent, to scout Shadowfang Keep, and neither had come back."},
        after = {"Vincent lay dead in the keep with a small trinket in his hand, and whatever else he had learned died with him."},
        zone = "Silverpine Forest",
        level = 25,
    },
    ["Arugal Must Die"] = { -- 1014
        why = {"The Forsaken could not hold {p:Silverpine} for the Dark Lady while Archmage Arugal lived in Shadowfang Keep."},
        after = {"Arugal's head went back to {p:the Sepulcher}, and {p:Silverpine Forest} was free of the wizard who had called the worgen."},
        zone = "Silverpine Forest",
        level = 27,
    },

    ---------------------------------------------------------------- Durotar, the Barrens, Mulgore

    ["Zalazane"] = { -- 826
        why = {"The witch doctor Zalazane held the Echo Isles, once home to the Darkspear, and hexed their people to his side."},
        after = {"Zalazane was dead, and the Darkspear of {p:Sen'jin Village} could sleep in peace."},
        zone = "Durotar",
        level = 10,
    },
    ["Hidden Enemies"] = { -- 5726 to 5730
        why = {"Thrall's investigation concerned threats within the Horde's new homeland.", "The work formed part of Thrall's efforts to secure Orgrimmar."},
        after = {"Another assignment in Thrall's investigation had been completed.", "The recorded work contributed to the investigation around Orgrimmar."},
        zone = "Orgrimmar",
        level = 12,
    },
    ["Raptor Thieves"] = { -- 869
        why = {"Raptors had stolen the silver meant to pay the guards of {p:the Crossroads}, and one had been caught in the act."},
        after = {"The raptors paid for the theft with their heads, though no one ever learned what they wanted with silver."},
        zone = "The Barrens",
        level = 13,
    },
    ["Samophlange"] = { -- 894, 900, 901, 902
        why = {"Sputtervalve in {p:Ratchet} wanted a Venture Company device called a samophlange, though he could not say what it was."},
        after = {"The samophlange came out of a console full of wires and tubing, bound for the Tinkers' Union in Undermine once Sputtervalve had looked it over."},
        zone = "The Barrens",
        level = 14,
    },
    ["Lost in Battle"] = { -- 4921
        why = {"Mankrik had lost his wife in a small tauren camp, where she held off three Bristlebacks alone until more of them came."},
        after = {"Mankrik's wife lay dead where the quilboar had overrun the camp, and he had his answer."},
        zone = "The Barrens",
        level = 20,
    },
    ["Deviate Hides"] = { -- 1486
        why = {"Nalpak believed the hides of the deviate beasts, born of Naralex's nightmare, could still be put to use by leatherworkers."},
        after = {"The deviate hides went to Nalpak, some small good out of Naralex's nightmare."},
        zone = "The Barrens",
        level = 17,
    },
    ["Serpentbloom"] = { -- 962
        why = {"Serpentbloom grew only in the far reaches of the Wailing Caverns, and many sent after it for the Royal Apothecary Society had not come back."},
        after = {"The Serpentbloom reached Apothecary Zamah, and the Forsaken had their rare herb from the caverns."},
        zone = "Thunder Bluff",
        level = 18,
    },
    ["Leaders of the Fang"] = { -- 914
        why = {"Nara Wildmane was haunted by the faces of the four Druids of the Fang, who had turned from healing the Barrens to remaking it."},
        after = {"The four dream gems came back to {p:Thunder Bluff}, and Nara Wildmane's dreams were free of the Fang."},
        zone = "Thunder Bluff",
        level = 22,
    },

    ---------------------------------------------------------------- Elwynn, Westfall, Duskwood, Stormwind

    ["WANTED: \"Hogger\""] = { -- 176
        why = {"Hogger, a huge gnoll, prowled the woods of southwestern {p:Elwynn}, and every attempt to capture him had failed."},
        after = {"Marshal Dughan had proof of Hogger's death, and an end to a headache the size of Blackrock Spire."},
        zone = "Elwynn Forest",
        level = 11,
    },
    ["The Defias Brotherhood"] = { -- 65, 132, 135, 141, 142, 155, 166
        why = {"Gryan Stoutmantle of the People's Militia wanted to know who led the Defias, the band that had driven the farmers out of {p:Westfall}."},
        after = {"The trail ran through Wiley in {p:Lakeshire} and Mathias Shaw in {p:Stormwind}, and ended at Edwin VanCleef.",
            "Edwin VanCleef had rebuilt {p:Stormwind} after the First War, and his Stonemasons turned outlaw over how the king had treated them."},
        zone = "Westfall",
        level = 18,
    },
    ["The Touch of Zanzil"] = { -- 2607, 2608, 2609
        why = {"A touch of Zanzil's poison left a young rogue with what Doc Mixilpixil called the 'itis'."},
        after = {"The cure for the 'itis' came out of a spray bottle, and Doc Mixilpixil swore it smelled fantastic."},
        zone = "Stormwind City",
        level = 20,
    },
    ["The Legend of Stalvan"] = { -- 66 to 98
        why = {"Madame Eva of {p:Darkshire} saw Death in her cards and feared for her granddaughter Alyssa, and a name came to her, Stalvan."},
        -- The same title covers the whole investigation; only exact stage 98
        -- in the Alliance pack can establish the killing.
        after = {"The inquiry into Stalvan continued."},
        zone = "Duskwood",
        level = 28,
    },
    ["Translation to Ello"] = { -- 252
        why = {"A note from the old man Abercrombie, once translated, showed he had done something unspeakable in his shack in {p:Duskwood}."},
        after = {"Lord Ello Ebonlocke learned what Abercrombie had made, and Stitches was already lumbering toward {p:Darkshire}."},
        zone = "Duskwood",
        level = 30,
    },
    ["Mor'Ladim"] = { -- 228
        why = {"Mor'Ladim, the risen body of Morgan Ladimore, walked the cemetery of {p:Duskwood} and had killed some of the Night Watch's strongest."},
        after = {"The Night Watch was rid of Mor'Ladim, and Morgan Ladimore's daughter Sarah still served among its Watchers."},
        zone = "Duskwood",
        level = 35,
    },
    ["The Missing Diplomat"] = { -- 1274, 1241 to 1250, 1264 to 1266, 1324
        why = {"A diplomat sent from {p:Stormwind} to meet Jaina Proudmoore in {p:Theramore} had never arrived, and Bishop DeLavey wanted it kept quiet."},
        -- A title-only record names no stage: who the diplomat was belongs to
        -- exact stage 1250 (LoreAllianceStories.lua), Hendel's arrest to later ones.
        after = {"Bishop DeLavey's quiet inquiry into the missing diplomat went on, from a cheese shop in {p:Stormwind} outward."},
        zone = "Stormwind City",
        level = 28,
    },
    ["The Stockade Riots"] = { -- 391
        why = {"The prisoners of the Stockade had risen under Bazil Thredd, and Warden Thelwater trusted no one who went down to talk to him."},
        after = {"Thredd's head went to the warden, and the riot in the Stockade had lost its leader."},
        zone = "Stormwind City",
        level = 29,
    },

    ---------------------------------------------------------------- Stranglethorn and Nesingwary

    ["Tiger Mastery"] = { -- 185, 187, 188
        why = {"Ajeck Rouack of Nesingwary's camp had learned tiger hunting from her father, and she tested new hunters on the young cats first."},
        after = {"The tiger hunts led up to Sin'Dall, a tiger the camp had tracked for weeks, and her paw was the proof of a master."},
        zone = "Stranglethorn Vale",
        level = 31,
    },
    ["Panther Mastery"] = { -- 190 to 193
        why = {"Sir S. J. Erlgadin wanted proof of skill with panthers before any hunter joined Hemet Nesingwary's party."},
        after = {"The panther hunts ended with Bhag'thera, a panther that had long eluded the whole party."},
        zone = "Stranglethorn Vale",
        level = 31,
    },
    ["Raptor Mastery"] = { -- 194 to 197
        why = {"Hemet Nesingwary Jr. tested new hunters on the raptors of {p:Stranglethorn}, and finding the beasts was half the test."},
        after = {"The raptor hunts led to Tethis, a raptor that even Nesingwary had failed to kill."},
        zone = "Stranglethorn Vale",
        level = 34,
    },
    ["The Green Hills of Stranglethorn"] = { -- 338
        why = {"Barnil Stonepot had been trusted to proofread Hemet Nesingwary's novel, until a gust of wind scattered the pages across the jungle."},
        after = {"Barnil had every page of The Green Hills of Stranglethorn back, sorted into its four parts."},
        zone = "Stranglethorn Vale",
        level = 40,
    },
    ["Big Game Hunter"] = { -- 208
        why = {"King Bangalash, a white tiger, was the reason Hemet Nesingwary had come to {p:Stranglethorn}, and it had sent him back to camp many times."},
        after = {"King Bangalash was dead, and Nesingwary's party counted one more hunter among its own."},
        zone = "Stranglethorn Vale",
        level = 43,
    },

    ---------------------------------------------------------------- Ashenvale, Desolace, Feralas, Kalimdor

    ["The Ashenvale Hunt"] = { -- 235, 742, 6382; run from Splintertree Post
        why = {"Senani Thunderheart at {p:Splintertree Post} called on the young of the Horde to join a great hunt of {p:Ashenvale}."},
        after = {"Senani Thunderheart took one more hunter into the Ashenvale Hunt, run from the Horde's two outposts in the forest."},
        zone = "Ashenvale",
        level = 20,
    },
    ["Sharptalon's Claw"] = { -- 2
        why = {"The hippogryph Sharptalon had long preyed on the peons who walked from the lumber camps to {p:Splintertree Post}."},
        after = {"Sharptalon was dead, and its claw went to Senani Thunderheart as proof."},
        zone = "Ashenvale",
        level = 30,
    },
    ["Kodo Roundup"] = { -- 5561
        why = {"Smeed Scrabblescrew's kodo kombobulator could jolt a dying kodo into a tame one, and the only caravan in {p:Desolace} needed five."},
        after = {"Smeed counted five tamed kodos for Cork's caravan, and one more reason to gloat over his rival Bibbly."},
        zone = "Desolace",
        level = 34,
    },
    ["The Crone of the Kraul"] = { -- 1101
        why = {"Heralath had died in Razorfen Kraul, and the dwarf Lonebrow carried word of Charlga Razorflank, the crone mustering the quilboar there."},
        after = {"Razorflank's medallion reached Falfindel Waywarder, and the study of what had corrupted Agamaggan's resting place could go on."},
        zone = "Feralas",
        level = 34,
    },
    ["Mortality Wanes"] = { -- 1142
        why = {"Heralath Fallowbrook lay dying in Razorfen Kraul, and a quilboar had stolen his wife's pendant of bonding."},
        after = {"Treshala Fallowbrook in {p:Darnassus} had her pendant back, and with it the news of her husband's death."},
        zone = "Razorfen Kraul",
        level = 30,
    },
    ["Blackfathom Villainy"] = { -- 1200, 6561
        why = {"Kelris led the Twilight's Hammer in Blackfathom Deeps and sacrificed innocents to Aku'Mai, a servant of an Old God."},
        after = {"Kelris's head left Blackfathom Deeps as proof, and his sacrifices to Aku'Mai were over."},
        zone = "Blackfathom Deeps",
        level = 27,
    },
    ["Rescue OOX-17/TN!"] = { -- 648
        why = {"Oglethorpe Obnoticus of {p:Booty Bay} had lost one of his homing robots, OOX-17/TN, in the desert of {p:Tanaris}."},
        after = {"OOX-17/TN reached Steamwheedle Port in one piece, and its maker was spared the gold of building another."},
        zone = "Tanaris",
        level = 48,
    },
    ["Are We There, Yeti?"] = { -- 3783, 977, 5163
        why = {"Umi Rumplesnicker of {p:Everlook} was building a mechanical yeti from real fur and horns to frighten her friends."},
        after = {"The mechanical yeti gave Legacki, Sprinkle and Quixxil a fright, and Umi had the last laugh on her friends."},
        zone = "Winterspring",
        level = 56,
    },

    ---------------------------------------------------------------- dungeons, 20 to 50

    ["Hearts of Zeal"] = { -- 1113
        why = {"Faranell wanted the hearts of the Scarlet zealots in the Monastery, to set against his Kraul guano in a wicked brew."},
        after = {"A load of Scarlet hearts reached the Apothecarium, and the Monastery had that many fewer zealots."},
        zone = "Undercity",
        level = 33,
    },
    ["In the Name of the Light"] = { -- 1053
        why = {"Raleigh the Devout had served the Scarlet Crusade until he watched it torture innocents it called plagued."},
        after = {"Whitemane, Mograine, Herod and Loksey were dead, and the Scarlet Monastery had lost its leaders."},
        zone = "Hillsbrad Foothills",
        level = 40,
    },
    ["Into The Scarlet Monastery"] = { -- 1048
        why = {"Varimathras called the Scarlet Crusade the sharpest thorn in the Forsaken's side, and wanted High Inquisitor Whitemane dead."},
        after = {"Whitemane, Mograine, Herod and Loksey fell in the Monastery, and Varimathras took note of the deed."},
        zone = "Undercity",
        level = 42,
    },
    ["Bring the End"] = { -- 3341
        why = {"A lich named Amnennar the Coldbringer ruled the quilboar of Razorfen Downs, his mind linked to Ner'zhul himself."},
        after = {"Amnennar the Coldbringer was destroyed, and the link between the Downs and the Lich King was cut."},
        zone = "Undercity",
        level = 42,
    },
    ["Bring the Light"] = { -- 3636
        why = {"The quilboar of Razorfen Downs had made a pact with the Scourge and served the lich Amnennar the Coldbringer."},
        after = {"Amnennar was destroyed, and the Scourge lost its lich among the quilboar of the Downs."},
        zone = "Stormwind City",
        level = 42,
    },
    ["Grime-Encrusted Ring"] = { -- 2945
        why = {"A ring taken from a Dark Iron dwarf in Gnomeregan was so caked with grime that no one could wear it."},
        after = {"The Sparklematic 5200 took a silver coin, lurched and ground, and gave the ring back in a small box tied with a red bow."},
        zone = "Gnomeregan",
        level = 34,
    },
    ["The Lost Dwarves"] = { -- 2398
        why = {"Baelog had led a band of dwarves deep into the Uldaman dig just before the troggs overran it."},
        after = {"Baelog was alive in Uldaman, and he won his bet with Olaf, whose beard had not yet reached his knees."},
        zone = "Ironforge",
        level = 40,
    },
    ["The Platinum Discs"] = { -- 2278, 2279, 2280, 2439, 2440
        why = {"The ancient records of Uldaman drew scholars seeking the history of Azeroth."},
        zone = "Uldaman",
        level = 47,
    },
    ["Divino-matic Rod"] = { -- 2768
        why = {"Sergeant Bly had borrowed Chief Engineer Bilgewhizzle's divino-matic rod and taken it treasure hunting in Zul'Farrak."},
        after = {"The rod was back in Bilgewhizzle's hands, and {p:Gadgetzan} could find its new water holes."},
        zone = "Tanaris",
        level = 47,
    },
    ["Gahz'rilla"] = { -- 2770
        why = {"Wizzle Brassbolts wanted a scale from Gahz'rilla, the beast the trolls of Zul'Farrak called from their sacred pool, to power his car."},
        after = {"Gahz'rilla's electrified scale went to the Shimmering Flats, to be tried in the Brassbolts' car."},
        zone = "Thousand Needles",
        level = 50,
    },

    ---------------------------------------------------------------- Blackrock Mountain

    ["Dark Iron Legacy"] = { -- 3801, 3802
        why = {"The ghost of Franclorn Forgewright, whose stonewrought halls stood all over the world, offered the key to the depths of his city."},
        after = {"Ironfel was set back in the hands of Franclorn's statue, and a compartment at its base gave up the master key."},
        zone = "Blackrock Mountain",
        level = 52,
    },
    ["Marshal Windsor"] = { -- 4241
        why = {"Marshal Maxwell at {p:Morgan's Vigil} heard that Reginald Windsor was alive, a prisoner of the Dark Irons in Blackrock Depths."},
        after = {"Reginald Windsor was alive in the depths, but the proof he had gathered against Lady Prestor was lost."},
        zone = "Burning Steppes",
        level = 54,
    },
    ["The Heart of the Mountain"] = { -- 4123
        why = {"Maxwort Uberglint had sought the Heart of the Mountain for years, a gem the size of a fist locked in the Dark Irons' vault."},
        after = {"The Heart was taken from the secret safe of the Lower Vault, the gem the Dark Irons had refused to sell."},
        zone = "Burning Steppes",
        level = 55,
    },
    ["Jail Break!"] = { -- 4322
        why = {"Reginald Windsor needed his gear back and his friends freed before he could break out of Blackrock Depths."},
        after = {"Windsor stormed out of the depths with his evidence, bound for {p:Stormwind} to face Bolvar and Lady Prestor."},
        zone = "Blackrock Depths",
        level = 58,
    },
    ["The Royal Rescue"] = { -- 4003
        why = {"Thrall sought Princess Moira Bronzebeard's rescue from Blackrock Depths."},
        zone = "Orgrimmar",
        level = 59,
    },
    ["The Princess's Surprise"] = { -- 4363
        why = {"Princess Moira Bronzebeard had a message for her father in {p:Ironforge}."},
        zone = "Blackrock Depths",
        level = 59,
    },
    ["Attunement to the Core"] = { -- 7487, 7848
        why = {"Lothos Riftwaker claimed a rift into the Molten Core stood two paces from him, opened by a core fragment from Blackrock Depths."},
        after = {"The core fragment was given up, and Lothos could send a raid through the rift into the Molten Core."},
        zone = "Blackrock Mountain",
        level = 60,
    },
    ["Seal of Ascension"] = { -- 4742, 4743
        why = {"Vaelan of the red flight said the seal to the upper Spire needed three gems from the generals of the lower citadel."},
        after = {"The Seal of Ascension was forged in the breath of the drake Emberstrife, and the doors of the upper Spire opened to it."},
        zone = "Blackrock Spire",
        level = 60,
    },
    ["Warlord's Command"] = { -- 4903
        why = {"Warlord Goretooth of {p:Kargath} ordered the deaths of Highlord Omokk, War Master Voone and Overlord Wyrmthalak of Blackrock Spire."},
        after = {"Omokk, Voone and Wyrmthalak were dead, and among their papers was one that turned the Warlord pale."},
        zone = "Badlands",
        level = 60,
    },
    ["For The Horde!"] = { -- 4974
        why = {"Rend Blackhand called himself Warchief from Blackrock Spire, safe under the protection of the black dragonflight."},
        after = {"Rend's head was raised in {p:Orgrimmar}, and the Blackrock legion was thrown into chaos."},
        zone = "Orgrimmar",
        level = 60,
    },

    ---------------------------------------------------------------- Onyxia

    ["The Great Masquerade"] = { -- 6403
        why = {"Reginald Windsor had proof that Lady Prestor, who held Highlord Bolvar in her gaze, was the black dragon Onyxia."},
        after = {"Onyxia's disguise was broken in {p:Stormwind}, and Windsor died in the fight that freed Bolvar."},
        zone = "Stormwind City",
        level = 60,
    },
    ["Drakefire Amulet"] = { -- 6502
        why = {"Haleh of the blue flight could mend the shattered dragon scale into a key, but only with the blood of General Drakkisath."},
        after = {"Haleh enchanted the scale with Drakkisath's blood, and Onyxia's wards in {p:Dustwallow Marsh} could no longer keep its bearer out."},
        zone = "Winterspring",
        level = 60,
    },
    ["Blood of the Black Dragon Champion"] = { -- 6602
        why = {"Rexxar knew the key to Onyxia's lair was an amulet that woke only with the blood of General Drakkisath."},
        after = {"Drakkisath's blood woke the Drakefire Amulet, and the Horde had a key to Onyxia's lair in {p:Dustwallow Marsh}."},
        zone = "Desolace",
        level = 60,
    },

    ---------------------------------------------------------------- the Plaguelands

    ["Scholomance"] = { -- 838, 5533
        why = {"The Scourge held Scholomance on the island of {p:Caer Darrow}, and its door opened to no one without a key."},
        after = {"An apothecary who had studied Scholomance knew how a key might be made, and the long work on it began."},
        zone = "Western Plaguelands",
        level = 55,
    },
    ["Araj's Scarab"] = { -- 5803, 5804
        why = {"Araj the Summoner, once master of Scholomance, ruled the ruins of {p:Andorhal}, and his scarab was to be the head of the key."},
        after = {"Araj was destroyed, and his scarab was fused onto the key to Scholomance."},
        zone = "Western Plaguelands",
        level = 60,
    },
    ["The Lich, Ras Frostwhisper"] = { -- 5466
        why = {"Ras Frostwhisper had cut his own throat to be reborn a lich, and only his keepsake could make him mortal once more."},
        after = {"Ras Frostwhisper died a mortal man, and ten thousand souls cried out at once."},
        zone = "Western Plaguelands",
        level = 60,
    },
    ["In Dreams"] = { -- 5944
        why = {"Taelan Fordring had served the Scarlet Crusade for years, and he asked to be taken from {p:Hearthglen} to his father, Tirion."},
        after = {"Taelan was killed by the Crusade he had served, and Tirion took his place as Highlord of a reborn Order of the Silver Hand."},
        zone = "Western Plaguelands",
        level = 60,
    },
    ["Of Love and Family"] = { -- 5846, 5848
        why = {"Tirion Fordring asked after a painting of his wife and son, made by the artist Renfray on the shore of {p:Caer Darrow}."},
        after = {"The painting was found hidden under another in the Scarlet Bastion of {p:Stratholme}, and Tirion nearly collapsed at the sight of it."},
        zone = "Eastern Plaguelands",
        level = 58,
    },
    ["Ramstein"] = { -- 6163
        why = {"Nathanos Blightcaller had hunted the abomination that killed him across the Plaguelands, until it fled into {p:Stratholme}."},
        after = {"Ramstein's head went to Nathanos, to hang on his wall."},
        zone = "Eastern Plaguelands",
        level = 60,
    },
    ["Dead Man's Plea"] = { -- 8945
        why = {"Anthion Harmon's wife Ysida had joined the Argent Dawn's crusade and been taken prisoner by Baron Rivendare in {p:Stratholme}."},
        after = {"Ysida Harmon was freed, and learned that Anthion was dead."},
        zone = "Eastern Plaguelands",
        level = 60,
    },

    ---------------------------------------------------------------- Dire Maul

    ["Shards of the Felvine"] = { -- 5526
        why = {"The Fruit of Fertility had turned to the Felvine in Dire Maul, and the Cenarion Circle wanted its essence sealed away."},
        after = {"Alzzin the Wildshaper fell, and the Felvine was sealed in the Reliquary of Purity, under the Circle's watch."},
        zone = "Moonglade",
        level = 60,
    },
    ["The Madness Within"] = { -- 7461
        why = {"The Shen'dralar wanted the madness of Eldre'Thalas ended, first the demon Immol'thar and then Prince Tortheldrin."},
        after = {"Immol'thar and the Prince were dead, and the spirits of Eldre'Thalas could rest."},
        zone = "Dire Maul",
        level = 60,
    },
    ["Unfinished Gordok Business"] = { -- 7703, 1318
        why = {"The elf Tortheldrin had stolen the Gauntlet of Gordok Might from an old ogre king, and no Gordok king since had taken it back."},
        after = {"The Gauntlet of Gordok Might was back with the Gordok, its old mark brought to life by Captain Kromcrush."},
        zone = "Dire Maul",
        level = 60,
    },

    ---------------------------------------------------------------- class quests

    ["The Binding"] = { -- 1471, 1504, 1689 (voidwalker); 1474, 1513, 1739 (succubus); 1795 (felhunter)
        why = {"A warlock's demon had to be called forth at a circle of summoning and beaten by force of arms and magic before it would serve."},
        after = {"The demon was subdued at the circle, and the spell to summon it was taught."},
        zone = "Undercity",
        level = 10,
    },
    ["Creature of the Void"] = { -- 1473, 1501
        why = {"The writings for calling a voidwalker had been stolen from the warlocks by enemies of the Horde."},
        after = {"The stolen writings came back to the warlocks, and with them the way to summon a voidwalker."},
        zone = "Undercity",
        level = 10,
    },
    ["Taming the Beast"] = { -- 6061 to 6064, 6082 to 6088, 6101, 6102
        why = {"Before a hunter could keep a pet, the trainer wanted three beasts tamed in turn with a taming rod, for practice."},
        after = {"The trainer granted the power to tame a beast of any kind, and to call it and dismiss it at will."},
        zone = "Mulgore",
        level = 10,
    },
    ["Training the Beast"] = { -- 6081, 6086, 6089, 6103
        why = {"A hunter could tame a pet but not yet teach it, and only the master hunters of the capitals taught that."},
        after = {"The pet could now be fed, taught new abilities and revived when it fell."},
        zone = "Orgrimmar",
        level = 10,
    },
    ["Body and Heart"] = { -- 6001 (Darkshore), 6002 (the Barrens)
        why = {"A druid of the Claw had to face Lunaclaw, the defender of a Moonkin Stone, to earn strength of body and of heart."},
        after = {"Lunaclaw yielded, and the Great Bear Spirit gave its teaching in return."},
        zone = "Darnassus",
        level = 10,
    },
    ["The Tome of Nobility"] = { -- 1661, 4485, 4486
        why = {"The paladin trainer offered a great boon to a paladin who had proven true to the Light, given freely for now."},
        after = {"The Tome of Nobility taught the calling of a warhorse."},
        zone = "Stormwind City",
        level = 40,
    },
    ["Dreadsteed of Xoroth"] = { -- 7631
        why = {"Mor'zul Bloodbringer had made every preparation for the ritual that would open a portal to Xoroth and call its dreadsteed."},
        after = {"The spirit of the Xorothian dreadsteed was beaten in Dire Maul, and the knowledge to summon it was won."},
        zone = "Burning Steppes",
        level = 60,
    },
    ["Call of Earth"] = { -- 1516 to 1521
        why = {"A young shaman's first sapta had to be drunk in a holy place, where the spirit of earth could be seen."},
        after = {"The spirit of earth gave a small stone, and around it a trainer crafted the first totem."},
        zone = "Durotar",
        level = 4,
    },
    ["Call of Fire"] = { -- 1522 to 1527, 2984; Kranal Fiss gives the totem
        why = {"Kranal Fiss, north of {p:the Crossroads}, taught fire to shamans who had already learned patience from earth."},
        after = {"The torch was lit at the Shrine of the Dormant Flame high above {p:Durotar}, and Kranal Fiss gave the totem of fire."},
        zone = "The Barrens",
        level = 10,
    },
    ["Call of Water"] = { -- 1528 to 1536, 63, 96, 100, 220, 1103, 2986; Islen gives the totem
        why = {"Islen Waterseer, south of {p:Ratchet}, taught the purity of water and sent her pupils after water from far places."},
        after = {"The spirit's pool on the coast of {p:Silverpine} was cleansed, and Islen gave the totem of water."},
        zone = "The Barrens",
        level = 20,
    },
    ["Call of Air"] = { -- 1531, 1532
        why = {"Prate Cloudseer, hidden in a hole in {p:Thousand Needles}, held the air totem for shamans ready for the element hardest to control."},
        after = {"Prate Cloudseer handed over the air totem, and set no trial for it."},
        zone = "Thousand Needles",
        level = 30,
    },
    ["The Affray"] = { -- 1719
        why = {"Klannoc Macleod tested rising warriors in The Affray, one challenger after another until Big Will came out."},
        after = {"Big Will was beaten on Fray Island, and Klannoc Macleod agreed to teach the berserker's stance."},
        zone = "The Barrens",
        level = 30,
    },
    ["The Summoning"] = { -- 1713
        why = {"Bath'rah the Windwatcher was ready to call the wind lord Cyclonian, and he needed its whirlwind heart for a weapon."},
        after = {"Cyclonian was defeated, and Bath'rah had the Whirlwind Heart to put into a weapon."},
        zone = "Alterac Mountains",
        level = 40,
    },
    ["The Manor, Ravenholdt"] = { -- 6681
        why = {"A letter from Fahrad said Ravenholdt had been watching, and that the manor lay hidden in the hills of {p:Hillsbrad}."},
        after = {"The Seal of Ravenholdt reached the manor, and the Assassin's League opened its doors."},
        zone = "Alterac Mountains",
        level = 24,
    },

    ---------------------------------------------------------------- odd corners

    ["Deeprun Rat Roundup"] = { -- 6661
        why = {"Monty in the Deeprun Tram had a rat problem, and a flute that made the vermin follow whoever played it."},
        after = {"Five live rats went to Monty, meant for his brother's rat kabobs."},
        zone = "Deeprun Tram",
        level = 12,
    },
}
function L.QuestStory(title, questID)
    local precise = questID and L.questStoryIDs and L.questStoryIDs[tonumber(questID)]
    if precise and precise.title == title then return precise end
    return title and L.questStory[title]
end

-- Early Lordaeron scenes. Source: the local quest corpus, exact quest ids
-- below (including Forever's additional Arugal's Folly, 98298). Why describes
-- the problem; after is either a single quest's supported result or a neutral
-- continuation for titles reused across several stages. A title alone cannot
-- establish which stage was completed, so never finish a whole chain from it.
local earlyScenes = {
    ["Prove Your Worth"] = { -- 421
        zone = "Silverpine Forest", level = 10, thread = "arugal", importance = 3,
        why = {"Moonrage Whitescalps prowled below the road in {p:Silverpine}, and Dalar Dawnweaver needed help against Arugal's beasts.",
            "Arugal's magic had made {p:Silverpine} a poor stronghold for the Forsaken's advance south."},
        after = {"Dalar judged the work against the Moonrage beasts worthy of more difficult assignments.",
            "The fight against the Whitescalps opened the way into Dalar's inquiry into Arugal's magic."},
    },
    ["Arugal's Folly"] = { -- 422, 423, 424, 99, 98298, shared title
        zone = "Silverpine Forest", level = 11, thread = "arugal", importance = 5,
        why = {"Dalar Dawnweaver wanted to understand the magic behind Arugal's hold on the worgen of {p:Silverpine}.",
            "Arugal's spellwork had become a problem for the Forsaken as well as for the people living under the keep.",
            "Dalar's research followed Arugal's spells and enchanted shackles, searching for a way to break his power."},
        after = {"The beasts in {p:Silverpine} made Arugal's magic a matter of survival, not merely a quarrel between wizards.",
            "Arugal's work connected the worgen of {p:Silverpine} with the wizard's stronghold at {p:Shadowfang Keep}.",
            "Dalar was studying a wizard's hold over living beasts, while the Forsaken sought to secure the forest around him."},
    },
    ["Border Crossings"] = { -- 477
        zone = "Silverpine Forest", level = 14, thread = "ambermill", importance = 4,
        why = {"Wagons from {p:Hillsbrad} were carrying supplies to the Dalaran-backed humans of {p:Ambermill}.",
            "A camp north of {p:Pyrewood} received crates for {p:Ambermill}, and the Forsaken wanted to know what the wizards were shipping."},
        after = {"The crate held old maps of western Lordaeron, with a magical pendant packed beneath them.",
            "Carefully packed maps and a pendant lay inside the crate, a clue to Dalaran's interest in {p:Ambermill}."},
    },
    ["Maps and Runes"] = { -- 478
        zone = "Silverpine Forest", level = 14, thread = "ambermill", importance = 4,
        why = {"The maps and pendant taken from Dalaran's supplies needed more than a soldier's eye to explain them.",
            "The wizards were supplying {p:Ambermill}, but the purpose of their maps and magical pendant was still hidden."},
        after = {"Dalar Dawnweaver was the next hope of explaining what the pendant meant.",
            "The pendant pointed toward Dalaran's spellwork, though the purpose behind the shipments remained uncertain."},
    },
    ["Dalar's Analysis"] = { -- 481
        zone = "Silverpine Forest", level = 14, thread = "ambermill", importance = 4,
        why = {"Dalar Dawnweaver was asked to examine the pendant found among the supplies for {p:Ambermill}.",
            "A pendant from the wizards' shipments had reached a wizard who could read its purpose."},
        after = {"Dalar recognized a device used by powerful Kirin Tor wizards to channel magical energy.",
            "So many channeling pendants bound for {p:Ambermill} suggested a work of considerable power."},
    },
    ["Dalaran's Intentions"] = { -- 482
        zone = "Silverpine Forest", level = 14, thread = "ambermill", importance = 5,
        why = {"The Kirin Tor had marked {p:Ambermill} as the site of a dormant node of ley energy.",
            "Dalar's answer connected the pendants to the sleeping ley energies beneath {p:Ambermill}."},
        after = {"The Forsaken learned that the wizards intended to awaken the ley node, and that taking their pendants could delay them.",
            "Allister received Dalar's warning about the ley node, and the shipments became something more dangerous than ordinary supplies."},
    },
    ["Ambermill Investigations"] = { -- 479
        zone = "Silverpine Forest", level = 16, thread = "ambermill", importance = 4,
        why = {"The conjurers and protectors of {p:Ambermill} carried pendants for the work of awakening the ley node.",
            "While Dalar searched for the source of the spellcasting, the Forsaken sought to slow the wizards by taking their pendants."},
        after = {"Dalar found the weaving already far advanced, with a powerful wizard guiding the energies.",
            "The interference had not stopped the weaving, and Dalar traced it to a wizard of great power."},
    },
    ["The Weaver"] = { -- 480
        zone = "Silverpine Forest", level = 22, thread = "ambermill", importance = 6,
        why = {"An archmage, guarded by mages and warders, was directing the awakening of {p:Ambermill}'s ley node.",
            "The Forsaken's remaining hope of stopping the weaving was to remove the archmage guiding it."},
        after = {"The weaving dissipated, and the ley energies sank back into dormancy.",
            "The ley node fell dormant again, though the Forsaken knew the source of power would remain beneath {p:Ambermill}."},
    },
    ["The Decrepit Ferry"] = { -- 438
        zone = "Silverpine Forest", level = 16, thread = "rothide", importance = 5,
        why = {"Rot Hide gnolls and other Scourge patrolled a derelict ferry east of {p:the Sepulcher}.",
            "The Forsaken had found another Scourge foothold at the ferry, but had not learned why the undead held it."},
        after = {"Wrapped corpses lay heaped in the boat, and across Lordamere Lake stood the dock on {p:Fenris Isle}.",
            "The ferry's cargo was a pile of corpses. The opposite dock on {p:Fenris Isle} pointed toward their destination."},
    },
    ["The Engraved Ring"] = { -- 440
        zone = "Tirisfal Glades", level = 16, thread = "rothide", importance = 5,
        why = {"The name Deliah, engraved on a ring from the stolen dead, led back to Magistrate Sevren in {p:Brill}.",
            "A woman's ring offered a name where the ferry had offered only a cargo of corpses."},
        after = {"Sevren knew Deliah had lived in {p:Brill} and been buried in its mass grave before the Rot Hides stole her body.",
            "Deliah was no nameless corpse to {p:Brill}. Her burial confirmed where the Rot Hides had found their cargo."},
    },
    ["Graverobbers"] = { -- 358
        zone = "Tirisfal Glades", level = 8, thread = "rothide", importance = 4,
        why = {"Rot Hide gnolls were opening the mass graves of {p:Tirisfal}, taking the plague's dead for the Scourge's armies.",
            "The dead in {p:Tirisfal}'s mass graves had escaped undeath until the Rot Hides came to gather them."},
        after = {"The apothecaries had embalming ichor to study, and the Rot Hides had met resistance at the graves.",
            "Ichor from the Rot Hide slaves went to the Forsaken's apothecaries, while the struggle for the graves continued."},
    },
    ["Lost Deathstalkers"] = { -- 428
        zone = "Silverpine Forest", level = 12, thread = "yorick", importance = 4,
        why = {"Rane and Quinn Yorick had vanished while scouting the farms of northern {p:Silverpine}.",
            "Two Deathstalkers sent to reconnoitre the northern farms had sent no word for weeks."},
        after = {"The missing Deathstalkers were found alive, though their scouting had gone badly.",
            "Rane and Quinn had survived. Their silence had hidden trouble on the northern farms."},
    },
    ["Wild Hearts"] = { -- 429
        zone = "Silverpine Forest", level = 11, thread = "yorick", importance = 3,
        why = {"Quinn Yorick had been mauled by Ivar the Foul, and worg hearts could supply the apothecaries with a healing reagent.",
            "Rane needed alchemical help for Quinn's wounds, and Apothecary Renferrel worked at {p:the Sepulcher}."},
        after = {"Quinn's wounds had drawn the work of the apothecaries into the Deathstalkers' troubled reconnaissance.",
            "A wounded scout's recovery depended on more than a clear route back to {p:the Sepulcher}."},
    },
    ["Ivar the Foul"] = { -- 425
        zone = "Silverpine Forest", level = 12, thread = "yorick", importance = 4,
        why = {"The ghoul Ivar the Foul had attacked Rane and Quinn on a farm and left Quinn badly wounded.",
            "Ivar waited in the barn while Rane guarded a brother who had not yet recovered."},
        after = {"Ivar's death gave Quinn time to recover without another attack from the ghoul.",
            "Rane could watch over Quinn without Ivar waiting for a lapse in the guard."},
    },
    ["The Deathstalkers' Report"] = { -- 449
        zone = "Silverpine Forest", level = 11, thread = "yorick", importance = 4,
        why = {"With Quinn's wounds mending, Rane wanted the reconnaissance report delivered quickly to High Executor Hadrec.",
            "What the Yoricks had learned was vital to the Forsaken's hold on {p:Silverpine}."},
        after = {"Hadrec learned how badly Scourge activity had hampered the northern scouting.",
            "The report made the troubles in northern {p:Silverpine} clear to the commander at {p:the Sepulcher}."},
    },
    ["The Dead Fields"] = { -- 437
        zone = "Silverpine Forest", level = 14, thread = "rothide", importance = 5,
        why = {"The banshee Nightlash repeatedly reinforced the Rot Hides at an old farm called the Dead Fields.",
            "Small Forsaken assaults on the Dead Fields had failed when Nightlash arrived to drive them back."},
        after = {"Nightlash's dust proved the banshee dead, and the Scourge had lost ground at the farm.",
            "Without Nightlash's reinforcement, the Rot Hides at the Dead Fields had lost the magic that routed earlier attacks."},
    },
    ["Deaths in the Family"] = { -- 354
        zone = "Tirisfal Glades", level = 11, thread = "agamand", importance = 4,
        why = {"The prosperous Agamands had kept their workers at the mills when the plague came, and now served the Scourge.",
            "The Agamands' former workers had survived as Forsaken, with bitter accounts of the family who doomed them."},
        after = {"The Agamands' remains gave a former worker his revenge, but their mills were still a threat to the Forsaken.",
            "A family's remains settled one old grievance. The Scourge foothold at the mills was another matter."},
    },
    ["The Haunted Mills"] = { -- 362
        zone = "Tirisfal Glades", level = 10, thread = "agamand", importance = 3,
        why = {"Devlin Agamand's mad chattering still came from near the road to his family's mills.",
            "The younger Agamand son had fallen quickly to the plague, and a former worker wanted his bones."},
        after = {"Devlin's bones went to the former worker who held the Agamands responsible for his family's fate.",
            "One more Agamand's remains had been gathered out of the mills."},
    },
    ["The Family Crypt"] = { -- 408
        zone = "Tirisfal Glades", level = 13, thread = "agamand", importance = 6,
        why = {"Captain Dargol had made the Agamand crypt a Scourge headquarters and raised the family's ancestors.",
            "The Scourge's strongest point at the mills lay underground, where Dargol commanded the risen Agamands."},
        after = {"Dargol's skull marked a blow against the Scourge's command at the Agamand crypt.",
            "The crypt's commander was dead, and the Forsaken had struck at the heart of the foothold at the mills."},
    },
    ["A New Plague"] = { -- 367, 368, 369, 492, shared title
        zone = "Tirisfal Glades", level = 6, thread = "apothecary", importance = 4,
        why = {"The Royal Apothecary Society sought a disease that would destroy the Scourge, gathering reagents from {p:Tirisfal}'s beasts.",
            "Sylvanas had charged the apothecaries with making a plague of their own to turn against Arthas's army."},
        after = {"The research treated the beasts of {p:Tirisfal} as a store of ingredients for a new weapon.",
            "Behind the apothecaries' requests lay an attempt to answer the Scourge with another plague."},
    },
    ["A Recipe For Death"] = { -- 447, 450, 451, shared title
        zone = "Silverpine Forest", level = 12, thread = "apothecary", importance = 4,
        why = {"Apothecary Renferrel and Master Faranell sought poisonous reagents for the Forsaken's new plague.",
            "The Royal Apothecary Society's work reached from {p:Silverpine}'s bears and spiders to the shores of Lordamere Lake."},
        after = {"The work in {p:Silverpine} fed the Royal Apothecary Society's search for a weapon against the Scourge.",
            "The forest's poisonous life had become part of the apothecaries' war against Arthas."},
    },
    ["Gordo's Task"] = { -- 5481
        zone = "Tirisfal Glades", level = 5, thread = "apothecary", importance = 2,
        why = {"Gordo's large hands were poor at picking weeds, and he had misunderstood which plants his master wanted.",
            "The abomination Gordo was gathering gloom weed for an apothecary who needed doom weed."},
        after = {"Junior Apothecary Holland had no use for the gloom weed. Gordo had sent the wrong plants.",
            "Holland's answer exposed Gordo's mistake, and the work turned to finding doom weed instead."},
    },
    ["Doom Weed"] = { -- 5482
        zone = "Tirisfal Glades", level = 6, thread = "apothecary", importance = 2,
        why = {"The doom weed Holland needed grew near the mass graves, where gnolls made gathering it dangerous.",
            "Junior Apothecary Holland wanted doom weed from north of the graveyard in {p:Brill}."},
        after = {"Holland had the doom weed he wanted, rather than another armful of Gordo's mistaken gloom weed.",
            "The correct weeds reached Holland's hands, another small supply for the apothecaries' work."},
    },
    ["Michael Garrett"] = { -- 6322
        zone = "Undercity", level = 10, thread = "sepulcherSupplies", importance = 3,
        why = {"A crate of weapons for {p:the Sepulcher} needed transport from {p:the Undercity}.",
            "Michael Garrett's bats connected {p:the Undercity} with the outpost at {p:the Sepulcher}."},
        after = {"Garrett confirmed that the bats flew daily to {p:the Sepulcher}, where the supplies were needed.",
            "A regular bat route linked the capital with the Deathguards' outpost in {p:Silverpine}."},
    },
    ["Return to Podrig"] = { -- 6324
        zone = "Silverpine Forest", level = 10, thread = "sepulcherSupplies", importance = 3,
        why = {"The supplies from {p:the Undercity} were bound for the Deathguards at {p:the Sepulcher}.",
            "Karos Razok's bat station gave the weapons from the capital a route back to {p:Silverpine}."},
        after = {"The weapons reached Podrig, keeping the Deathguards supplied at their outpost.",
            "The Deathguards at {p:the Sepulcher} had the weapons ordered from the capital."},
    },
}
L.storyThreads = {
    arugal = "Dalar's inquiry into Arugal's magic", ambermill = "Dalaran's designs for Ambermill",
    rothide = "the Rot Hides and the stolen dead", yorick = "the missing Deathstalkers",
    agamand = "the Scourge foothold at the Agamand mills", apothecary = "the apothecaries' search for a new plague",
    sepulcherSupplies = "the Sepulcher's supplies",
}
for title, scene in pairs(earlyScenes) do
    scene.threadLabel = L.storyThreads[scene.thread]
    L.questStory[title] = scene
end
L.questStory["Rot Hide Clues"].thread = "rothide"
L.questStory["Rot Hide Clues"].threadLabel = L.storyThreads.rothide
L.questStory["Rot Hide Clues"].importance = 5
function L.QuestThread(title, questID)
    local scene = L.QuestStory(title, questID)
    return scene and scene.thread, scene and scene.threadLabel
end
-- What someone fights with, by class (for the rare boast).
L.weapons = {WARRIOR = "blade", PALADIN = "blade", ROGUE = "blades", HUNTER = "arrows", MAGE = "spells", WARLOCK = "spells",
    PRIEST = "spells", SHAMAN = "strikes", DRUID = "strikes", DEATHKNIGHT = "blade"}
function L.Weapon(class) return class and L.weapons[class] or "strikes" end
-- A role: the one the game assigned, else what the meter showed (the most
-- healing is the healer; the most blows taken is the tank; else damage).
function L.Role(assigned, stats)
    if assigned then return assigned end
    if type(stats) ~= "table" then return nil end
    if stats.h == 1 and (stats.hs or 0) >= 50 then return "healer" end
    if stats.t == 1 then return "tank" end
    if stats.d then return "damage" end
    return nil
end
function L.Zone(name) return name and L.zones[name] end
-- A killer no one is proud to die to: a critter or a farmhand ("Hillsbrad Farmer").
local HUMBLE = {"Farmer", "Peasant", "Farmhand", "Laborer", "Villager", "Peon", "Rabbit", "Squirrel", "Sheep", "Cow", "Chicken",
    "Rat", "Toad", "Frog", "Deer", "Prairie Dog", "Hare", "Fawn", "Cat", "Roach", "Snake"}
function L.Humble(name)
    if type(name) ~= "string" or L.Boss(name) then return false end
    for _, word in ipairs(HUMBLE) do if name:find(word .. "$") then return true end end
    return false
end
function L.Dungeon(name) return name and L.dungeons[name] end
-- Additional reviewed Classic/Forever encounter identities (2026-10-12).
-- Recognition is not proof of a clear, a quest outcome, or a creature type.
-- Source-only entries intentionally use the ordinary victory wording.
local encounterRegistry = {
    ["Anger'rel"] = {dungeon = "Blackrock Depths", source = "https://www.wowhead.com/classic/guide/blackrock-depths-shadowforge-city-dungeon-strategy-wow-classic (Anger'rel)"},
    ["Anub'Rekhan"] = {dungeon = "Naxxramas", source = "https://www.wowhead.com/classic/npc=15952/maexxna (Classic raid roster and wings) (Anub'Rekhan)"},
    ["Anub'shiah"] = {dungeon = "Blackrock Depths", source = "https://www.wowhead.com/classic/guide/blackrock-depths-detention-block-dungeon-strategy-wow-classic (Anub'shiah)"},
    ["Ayamiss the Hunter"] = {dungeon = "Ruins of Ahn'Qiraj", source = "https://www.wowhead.com/classic/guide/ruins-ahnqiraj-aq20-overview-classic-wow (Ayamiss the Hunter)"},
    ["Azshir the Sleepless"] = {dungeon = "Scarlet Monastery", source = "https://www.wowhead.com/classic/guide/scarlet-monastery-dungeon-strategy-wow-classic (Classic wings, roster and abilities): Azshir the Sleepless, Soul Siphon and Terrify"},
    ["Balzaphon"] = {dungeon = "Stratholme", source = "https://www.wowhead.com/classic/news/new-dungeon-bosses-and-gear-available-in-classic-anniversary-phase-6-378727 (Balzaphon)"},
    ["Bannok Grimaxe"] = {dungeon = "Lower Blackrock Spire", source = "https://www.wowhead.com/classic/guide/lower-blackrock-spire-lbrs-dungeon-strategy-wow-classic (Bannok Grimaxe)"},
    ["Battleguard Sartura"] = {dungeon = "Temple of Ahn'Qiraj", source = "https://www.wowhead.com/classic/guide/temple-ahnqiraj-aq40-overview-classic-wow (Battleguard Sartura)"},
    ["Black Guard Swordsmith"] = {dungeon = "Stratholme", source = "StorageInvestigation/journal-voice/review/corpus_vanilla_quests.txt #5307 Corruption (Black Guard Swordsmith)"},
    ["Blind Hunter"] = {dungeon = "Razorfen Kraul", source = "https://www.wowhead.com/classic/guide/razorfen-kraul-dungeon-strategy-wow-classic (Classic boss roster and abilities): Blind Hunter, Sonic Burst"},
    ["Blood Steward of Kirtonos"] = {dungeon = "Scholomance", source = "https://www.wowhead.com/classic/guide/scholomance-dungeon-strategy-wow-classic (Blood Steward of Kirtonos)"},
    ["Buru the Gorger"] = {dungeon = "Ruins of Ahn'Qiraj", source = "https://www.wowhead.com/classic/guide/ruins-ahnqiraj-aq20-overview-classic-wow (Buru the Gorger)"},
    ["Captain Kromcrush"] = {dungeon = "Dire Maul", source = "https://www.wowhead.com/classic/guide/dire-maul-north-dungeon-strategy-wow-classic (Captain Kromcrush)"},
    ["Crimson Hammersmith"] = {dungeon = "Stratholme", source = "https://www.wowhead.com/classic/guide/stratholme-live-dungeon-strategy-wow-classic (Crimson Hammersmith)"},
    ["Crystal Fang"] = {dungeon = "Lower Blackrock Spire", source = "https://www.wowhead.com/classic/guide/lower-blackrock-spire-lbrs-dungeon-strategy-wow-classic (Crystal Fang)"},
    ["Dark Iron Ambassador"] = {dungeon = "Gnomeregan", source = "https://www.wowhead.com/classic/guide/gnomeregan-dungeon-strategy-wow-classic (Classic boss locations): rare encounter, Dark Iron Ambassador"},
    ["Death Knight Darkreaver"] = {dungeon = "Scholomance", source = "StorageInvestigation/journal-voice/review/corpus_vanilla_quests.txt #7646 The Divination Scryer, completion dialogue (Death Knight Darkreaver)"},
    ["Deathsworn Captain"] = {dungeon = "Shadowfang Keep", source = "https://www.wowhead.com/classic/guide/shadowfang-keep-dungeon-strategy-wow-classic (Classic boss roster and abilities): rare encounter, Cleave and Hamstring"},
    ["Digmaster Shovelphlange"] = {dungeon = "Uldaman", source = "https://www.wowhead.com/classic/guide/uldaman-dungeon-strategy-wow-classic (Classic roster and locations): Digmaster Shovelphlange"},
    ["Doom'rel"] = {dungeon = "Blackrock Depths", source = "https://www.wowhead.com/classic/guide/blackrock-depths-shadowforge-city-dungeon-strategy-wow-classic (Doom'rel)"},
    ["Dope'rel"] = {dungeon = "Blackrock Depths", source = "https://www.wowhead.com/classic/guide/blackrock-depths-shadowforge-city-dungeon-strategy-wow-classic (Dope'rel)"},
    ["Dustwraith"] = {dungeon = "Zul'Farrak", source = "https://www.wowhead.com/classic/npc=10081/dustwraith (Classic Zul'Farrak roster) (Dustwraith)"},
    ["Earthcaller Halmgar"] = {dungeon = "Razorfen Kraul", source = "https://www.wowhead.com/classic/guide/razorfen-kraul-dungeon-strategy-wow-classic (Classic boss roster and abilities): Earthcaller Halmgar, Earthbind Totem"},
    ["Emeriss"] = {dungeon = "World encounters", source = "https://www.wowhead.com/classic/guide/classic-world-boss"},
    ["Emperor Vek'lor"] = {dungeon = "Temple of Ahn'Qiraj", source = "https://www.wowhead.com/classic/guide/temple-ahnqiraj-aq40-overview-classic-wow (Emperor Vek'lor)"},
    ["Emperor Vek'nilash"] = {dungeon = "Temple of Ahn'Qiraj", source = "https://www.wowhead.com/classic/guide/temple-ahnqiraj-aq40-overview-classic-wow (Emperor Vek'nilash)"},
    ["Eric \"The Swift\""] = {dungeon = "Uldaman", source = "https://www.wowhead.com/classic/guide/uldaman-dungeon-strategy-wow-classic (Classic roster and locations): The Lost Dwarves"},
    ["Eviscerator"] = {dungeon = "Blackrock Depths", source = "https://www.wowhead.com/classic/guide/blackrock-depths-detention-block-dungeon-strategy-wow-classic (Eviscerator)"},
    ["Fallen Champion"] = {dungeon = "Scarlet Monastery", source = "https://www.wowhead.com/classic/guide/scarlet-monastery-dungeon-strategy-wow-classic (Classic wings, roster and abilities): Graveyard rares, Fallen Champion"},
    ["Fankriss the Unyielding"] = {dungeon = "Temple of Ahn'Qiraj", source = "https://www.wowhead.com/classic/guide/temple-ahnqiraj-aq40-overview-classic-wow (Fankriss the Unyielding)"},
    ["Ferra"] = {dungeon = "Dire Maul", source = "https://www.wowhead.com/classic/guide/dire-maul-west-dungeon-strategy-wow-classic (Ferra)"},
    ["Feugen"] = {dungeon = "Naxxramas", source = "https://www.wowhead.com/classic/guide/thaddius-naxxramas-raid-strategy (Feugen)"},
    ["Foreman Thistlenettle"] = {dungeon = "The Deadmines", source = "https://ptgmedia.pearsoncmg.com/imprint_downloads/brady/wow/deadmines/Deadmines%20LR.pdf (original BradyGames Deadmines guide) p. 3, Oh Brother..."},
    ["Gahz'ranka"] = {dungeon = "Zul'Gurub", source = "https://www.wowhead.com/classic/guide/wow-classic-zulgurub-overview (Gahz'ranka)"},
    ["Gasher"] = {dungeon = "The Temple of Atal'Hakkar", source = "https://www.wowhead.com/classic/guide/temple-of-atalhakkar-sunken-temple-dungeon-strategy-wow-classic (Classic dungeon, not Season of Discovery): Gasher, Dual Wield"},
    ["General Rajaxx"] = {dungeon = "Ruins of Ahn'Qiraj", source = "https://www.wowhead.com/classic/guide/ruins-ahnqiraj-aq20-overview-classic-wow (General Rajaxx)"},
    ["Ghok Bashguud"] = {dungeon = "Lower Blackrock Spire", source = "https://www.wowhead.com/classic/npc=9718/ghok-bashguud (Ghok Bashguud)"},
    ["Gloom'rel"] = {dungeon = "Blackrock Depths", source = "https://www.wowhead.com/classic/guide/blackrock-depths-shadowforge-city-dungeon-strategy-wow-classic (Gloom'rel)"},
    ["Gluth"] = {dungeon = "Naxxramas", source = "https://www.wowhead.com/classic/npc=15952/maexxna (Classic raid roster and wings) (Gluth)"},
    ["Goraluk Anvilcrack"] = {dungeon = "Upper Blackrock Spire", source = "https://www.wowhead.com/classic/guide/upper-blackrock-spire-ubrs-dungeon-strategy-wow-classic (Goraluk Anvilcrack)"},
    ["Gorosh the Dervish"] = {dungeon = "Blackrock Depths", source = "https://www.wowhead.com/classic/guide/blackrock-depths-detention-block-dungeon-strategy-wow-classic (Gorosh the Dervish)"},
    ["Gothik the Harvester"] = {dungeon = "Naxxramas", source = "https://www.wowhead.com/classic/npc=15952/maexxna (Classic raid roster and wings) (Gothik the Harvester)"},
    ["Grand Widow Faerlina"] = {dungeon = "Naxxramas", source = "https://www.wowhead.com/classic/npc=15952/maexxna (Classic raid roster and wings) (Grand Widow Faerlina)"},
    ["Gri'lek"] = {dungeon = "Zul'Gurub", source = "https://www.wowhead.com/classic/guide/wow-classic-zulgurub-overview (Gri'lek)"},
    ["Grizzle"] = {dungeon = "Blackrock Depths", source = "https://www.wowhead.com/classic/guide/blackrock-depths-detention-block-dungeon-strategy-wow-classic (Grizzle)"},
    ["Grobbulus"] = {dungeon = "Naxxramas", source = "https://www.wowhead.com/classic/npc=15952/maexxna (Classic raid roster and wings) (Grobbulus)"},
    ["Guard Fengus"] = {dungeon = "Dire Maul", source = "https://www.wowhead.com/classic/guide/dire-maul-north-dungeon-strategy-wow-classic (Guard Fengus)"},
    ["Guard Mol'dar"] = {dungeon = "Dire Maul", source = "https://www.wowhead.com/classic/guide/dire-maul-north-dungeon-strategy-wow-classic (Guard Mol'dar)"},
    ["Guard Slip'kik"] = {dungeon = "Dire Maul", source = "https://www.wowhead.com/classic/guide/dire-maul-north-dungeon-strategy-wow-classic (Guard Slip'kik)"},
    ["Hate'rel"] = {dungeon = "Blackrock Depths", source = "https://www.wowhead.com/classic/guide/blackrock-depths-shadowforge-city-dungeon-strategy-wow-classic (Hate'rel)"},
    ["Hazza'rah"] = {dungeon = "Zul'Gurub", source = "https://www.wowhead.com/classic/guide/wow-classic-zulgurub-overview (Hazza'rah)"},
    ["Hearthsinger Forresten"] = {dungeon = "Stratholme", source = "https://www.wowhead.com/classic/guide/classic-dungeons-overview (Hearthsinger Forresten)"},
    ["Hedrum the Creeper"] = {dungeon = "Blackrock Depths", source = "https://www.wowhead.com/classic/guide/blackrock-depths-detention-block-dungeon-strategy-wow-classic (Hedrum the Creeper)"},
    ["Heigan the Unclean"] = {dungeon = "Naxxramas", source = "https://www.wowhead.com/classic/npc=15952/maexxna (Classic raid roster and wings) (Heigan the Unclean)"},
    ["Highlord Mograine"] = {dungeon = "Naxxramas", source = "https://www.wowhead.com/classic/guide/four-horsemen-naxxramas-raid-strategy (Highlord Mograine)"},
    ["Hukku"] = {dungeon = "The Temple of Atal'Hakkar", source = "https://www.wowhead.com/classic/guide/temple-of-atalhakkar-sunken-temple-dungeon-strategy-wow-classic (Classic dungeon, not Season of Discovery): Hukku"},
    ["Instructor Razuvious"] = {dungeon = "Naxxramas", source = "https://www.wowhead.com/classic/npc=15952/maexxna (Classic raid roster and wings) (Instructor Razuvious)"},
    ["Ironspine"] = {dungeon = "Scarlet Monastery", source = "https://www.wowhead.com/classic/guide/scarlet-monastery-dungeon-strategy-wow-classic (Classic wings, roster and abilities): Ironspine, Poison Cloud"},
    ["Jarien"] = {dungeon = "Stratholme", source = "https://www.wowhead.com/classic/npc=16101/jarien (Jarien)"},
    ["Jed Runewatcher"] = {dungeon = "Upper Blackrock Spire", source = "https://www.wowhead.com/classic/guide/upper-blackrock-spire-ubrs-dungeon-strategy-wow-classic (Jed Runewatcher)"},
    ["Kormok"] = {dungeon = "Scholomance", source = "https://www.wowhead.com/classic/guide/scholomance-dungeon-strategy-wow-classic (Kormok)"},
    ["Kurinnaxx"] = {dungeon = "Ruins of Ahn'Qiraj", source = "StorageInvestigation/journal-voice/review/corpus_vanilla_quests.txt #9023 The Perfect Poison (Kurinnaxx)"},
    ["Lady Blaumeux"] = {dungeon = "Naxxramas", source = "https://www.wowhead.com/classic/guide/four-horsemen-naxxramas-raid-strategy (Lady Blaumeux)"},
    ["Lady Falther'ess"] = {dungeon = "Razorfen Downs", source = "https://www.wowhead.com/classic/news/new-dungeon-bosses-and-gear-available-in-classic-anniversary-phase-6-378727 (Lady Falther'ess)"},
    ["Lethon"] = {dungeon = "World encounters", source = "https://www.wowhead.com/classic/guide/classic-world-boss"},
    ["Loatheb"] = {dungeon = "Naxxramas", source = "https://www.wowhead.com/classic/npc=15952/maexxna (Classic raid roster and wings) (Loatheb)"},
    ["Lord Blackwood"] = {dungeon = "Scholomance", source = "https://www.wowhead.com/classic/news/new-dungeon-bosses-and-gear-available-in-classic-anniversary-phase-6-378727 (Lord Blackwood)"},
    ["Lord Hel'nurath"] = {dungeon = "Dire Maul", source = "https://www.wowhead.com/classic/guide/dire-maul-west-dungeon-strategy-wow-classic (Lord Hel'nurath)"},
    ["Lord Kri"] = {dungeon = "Temple of Ahn'Qiraj", source = "https://www.wowhead.com/classic/guide/temple-ahnqiraj-aq40-overview-classic-wow (Lord Kri)"},
    ["Lord Valthalak"] = {dungeon = "Upper Blackrock Spire", source = "https://www.wowhead.com/classic/guide/upper-blackrock-spire-ubrs-dungeon-strategy-wow-classic (Lord Valthalak)"},
    ["Loro"] = {dungeon = "The Temple of Atal'Hakkar", source = "https://www.wowhead.com/classic/guide/temple-of-atalhakkar-sunken-temple-dungeon-strategy-wow-classic (Classic dungeon, not Season of Discovery): Atal'ai Defenders"},
    ["Maexxna"] = {dungeon = "Naxxramas", source = "https://www.wowhead.com/classic/npc=15952/maexxna (Classic raid roster and wings) (Maexxna)"},
    ["Malor the Zealous"] = {dungeon = "Stratholme", source = "https://www.wowhead.com/classic/guide/stratholme-live-dungeon-strategy-wow-classic (Malor the Zealous)"},
    ["Marduk Blackpool"] = {dungeon = "Scholomance", source = "https://www.wowhead.com/classic/guide/scholomance-dungeon-strategy-wow-classic (Marduk Blackpool)"},
    ["Meshlok the Harvester"] = {dungeon = "Maraudon", source = "https://www.wowhead.com/classic/guide/maraudon-dungeon-strategy-wow-classic (Classic roster and locations): Meshlok the Harvester"},
    ["Mijan"] = {dungeon = "The Temple of Atal'Hakkar", source = "https://www.wowhead.com/classic/guide/temple-of-atalhakkar-sunken-temple-dungeon-strategy-wow-classic (Classic dungeon, not Season of Discovery): Mijan, Greater Healing Ward"},
    ["Miner Johnson"] = {dungeon = "The Deadmines", source = "https://ptgmedia.pearsoncmg.com/imprint_downloads/brady/wow/deadmines/Deadmines%20LR.pdf (original BradyGames Deadmines guide) pp. 3, 5"},
    ["Moam"] = {dungeon = "Ruins of Ahn'Qiraj", source = "https://www.wowhead.com/classic/guide/ruins-ahnqiraj-aq20-overview-classic-wow (Moam)"},
    ["Mor Grayhoof"] = {dungeon = "Lower Blackrock Spire", source = "https://www.wowhead.com/classic/guide/lower-blackrock-spire-lbrs-dungeon-strategy-wow-classic (Mor Grayhoof)"},
    ["Mushgog"] = {dungeon = "Dire Maul", source = "https://www.wowhead.com/classic/guide/dire-maul-dungeon-strategy-wow-classic (Mushgog)"},
    ["Noth the Plaguebringer"] = {dungeon = "Naxxramas", source = "https://www.wowhead.com/classic/npc=15952/maexxna (Classic raid roster and wings) (Noth the Plaguebringer)"},
    ["Ogom the Wretched"] = {dungeon = "The Temple of Atal'Hakkar", source = "https://www.wowhead.com/classic/guide/temple-of-atalhakkar-sunken-temple-dungeon-strategy-wow-classic (Classic dungeon, not Season of Discovery): Jammal'an and Ogom"},
    ["Ohgan"] = {dungeon = "Zul'Gurub", source = "https://www.wowhead.com/classic/guide/wow-classic-zulgurub-overview (Ohgan)"},
    ["Ok'thor the Breaker"] = {dungeon = "Blackrock Depths", source = "https://www.wowhead.com/classic/guide/blackrock-depths-detention-block-dungeon-strategy-wow-classic (Ok'thor the Breaker)"},
    ["Olaf"] = {dungeon = "Uldaman", source = "https://www.wowhead.com/classic/guide/uldaman-dungeon-strategy-wow-classic (Classic roster and locations): The Lost Dwarves, Olaf's All Purpose Shield"},
    ["Ouro"] = {dungeon = "Temple of Ahn'Qiraj", source = "StorageInvestigation/journal-voice/review/corpus_vanilla_quests.txt #8560 Conqueror's Legguards (Ouro)"},
    ["Panzor the Invincible"] = {dungeon = "Blackrock Depths", source = "https://www.wowhead.com/classic/guide/blackrock-depths-shadowforge-city-dungeon-strategy-wow-classic (Panzor the Invincible)"},
    ["Phalanx"] = {dungeon = "Blackrock Depths", source = "https://www.wowhead.com/classic/guide/blackrock-depths-shadowforge-city-dungeon-strategy-wow-classic (Phalanx)"},
    ["Pimgib"] = {dungeon = "Dire Maul", source = "https://www.wowhead.com/classic/guide/dire-maul-east-dungeon-strategy-wow-classic (Pimgib)"},
    ["Plaguemaw the Rotting"] = {dungeon = "Razorfen Downs", source = "https://www.wowhead.com/classic/guide/razorfen-downs-dungeon-strategy-wow-classic (Classic roster and events): Plaguemaw the Rotting event"},
    ["Princess Huhuran"] = {dungeon = "Temple of Ahn'Qiraj", source = "https://www.wowhead.com/classic/guide/temple-ahnqiraj-aq40-overview-classic-wow (Princess Huhuran)"},
    ["Princess Yauj"] = {dungeon = "Temple of Ahn'Qiraj", source = "https://www.wowhead.com/classic/guide/temple-ahnqiraj-aq40-overview-classic-wow (Princess Yauj)"},
    ["Pusillin"] = {dungeon = "Dire Maul", source = "https://www.wowhead.com/classic/guide/dire-maul-dungeon-strategy-wow-classic (Pusillin)"},
    ["Ragglesnout"] = {dungeon = "Razorfen Downs", source = "https://www.wowhead.com/classic/guide/razorfen-downs-dungeon-strategy-wow-classic (Classic roster and events): Ragglesnout"},
    ["Renataki"] = {dungeon = "Zul'Gurub", source = "https://www.wowhead.com/classic/guide/wow-classic-zulgurub-overview (Renataki)"},
    ["Revanchion"] = {dungeon = "Dire Maul", source = "https://www.wowhead.com/classic/news/new-dungeon-bosses-and-gear-available-in-classic-anniversary-phase-6-378727 (Revanchion)"},
    ["Ribbly Screwspigot"] = {dungeon = "Blackrock Depths", source = "https://www.wowhead.com/classic/guide/blackrock-depths-shadowforge-city-dungeon-strategy-wow-classic (Ribbly Screwspigot)"},
    ["Ruuzlu"] = {dungeon = "Zul'Farrak", source = "https://www.wowhead.com/classic/guide/zulfarrak-dungeon-strategy-wow-classic (Classic roster and events): Chief Ukorz Sandscalp, paired encounter"},
    ["Sandarr Dunereaver"] = {dungeon = "Zul'Farrak", source = "https://www.wowhead.com/classic/npc=10080/sandarr-dunereaver (Sandarr Dunereaver)"},
    ["Scorn"] = {dungeon = "Scarlet Monastery", source = "https://www.wowhead.com/classic/news/new-dungeon-bosses-and-gear-available-in-classic-anniversary-phase-6-378727 (Scorn)"},
    ["Seeth'rel"] = {dungeon = "Blackrock Depths", source = "https://www.wowhead.com/classic/guide/blackrock-depths-shadowforge-city-dungeon-strategy-wow-classic (Seeth'rel)"},
    ["Sever"] = {dungeon = "Shadowfang Keep", source = "https://www.wowhead.com/classic/news/new-dungeon-bosses-and-gear-available-in-classic-anniversary-phase-6-378727 (Sever)"},
    ["Sir Zeliek"] = {dungeon = "Naxxramas", source = "https://www.wowhead.com/classic/guide/four-horsemen-naxxramas-raid-strategy (Sir Zeliek)"},
    ["Skarr the Unbreakable"] = {dungeon = "Dire Maul", source = "https://www.wowhead.com/classic/guide/dire-maul-dungeon-strategy-wow-classic (Skarr the Unbreakable)"},
    ["Skul"] = {dungeon = "Stratholme", source = "https://www.wowhead.com/classic/guide/classic-dungeons-overview (Skul)"},
    ["Solakar Flamewreath"] = {dungeon = "Upper Blackrock Spire", source = "https://www.wowhead.com/classic/guide/upper-blackrock-spire-ubrs-dungeon-strategy-wow-classic (Solakar Flamewreath)"},
    ["Sothos"] = {dungeon = "Stratholme", source = "https://www.wowhead.com/classic/npc=16102/sothos (Sothos)"},
    ["Spirestone Battle Lord"] = {dungeon = "Lower Blackrock Spire", source = "https://www.wowhead.com/classic/guide/lower-blackrock-spire-lbrs-dungeon-strategy-wow-classic (Spirestone Battle Lord)"},
    ["Spirestone Butcher"] = {dungeon = "Lower Blackrock Spire", source = "https://www.wowhead.com/classic/guide/lower-blackrock-spire-lbrs-dungeon-strategy-wow-classic (Spirestone Butcher)"},
    ["Spirestone Lord Magus"] = {dungeon = "Lower Blackrock Spire", source = "https://www.wowhead.com/classic/npc=9217/spirestone-lord-magus (Spirestone Lord Magus)"},
    ["Stalagg"] = {dungeon = "Naxxramas", source = "https://www.wowhead.com/classic/guide/thaddius-naxxramas-raid-strategy (Stalagg)"},
    ["Stomper Kreeg"] = {dungeon = "Dire Maul", source = "https://www.wowhead.com/classic/guide/dire-maul-north-dungeon-strategy-wow-classic (Stomper Kreeg)"},
    ["Stonespine"] = {dungeon = "Stratholme", source = "https://www.wowhead.com/classic/guide/classic-dungeons-overview (Stonespine)"},
    ["Taerar"] = {dungeon = "World encounters", source = "https://www.wowhead.com/classic/guide/classic-world-boss"},
    ["Techbot"] = {dungeon = "Gnomeregan", source = "StorageInvestigation/journal-voice/review/corpus_vanilla_quests.txt #2922 Save Techbot's Brain!"},
    ["Teremus the Devourer"] = {dungeon = "World encounters", source = "https://www.wowhead.com/classic/guide/classic-world-boss"},
    ["Thaddius"] = {dungeon = "Naxxramas", source = "https://www.wowhead.com/classic/npc=15952/maexxna (Classic raid roster and wings) (Thaddius)"},
    ["Thane Korth'azz"] = {dungeon = "Naxxramas", source = "https://www.wowhead.com/classic/guide/four-horsemen-naxxramas-raid-strategy (Thane Korth'azz)"},
    ["The Prophet Skeram"] = {dungeon = "Temple of Ahn'Qiraj", source = "https://www.wowhead.com/classic/guide/temple-ahnqiraj-aq40-overview-classic-wow (The Prophet Skeram)"},
    ["The Razza"] = {dungeon = "Dire Maul", source = "https://www.wowhead.com/classic/guide/dire-maul-dungeon-strategy-wow-classic (The Razza)"},
    ["Theldren"] = {dungeon = "Blackrock Depths", source = "https://www.wowhead.com/classic/guide/blackrock-depths-detention-block-dungeon-strategy-wow-classic (Theldren)"},
    ["Tsu'zee"] = {dungeon = "Dire Maul", source = "https://www.wowhead.com/classic/guide/dire-maul-west-dungeon-strategy-wow-classic (Tsu'zee)"},
    ["Vectus"] = {dungeon = "Scholomance", source = "https://www.wowhead.com/classic/guide/scholomance-dungeon-strategy-wow-classic (Vectus)"},
    ["Vem"] = {dungeon = "Temple of Ahn'Qiraj", source = "https://www.wowhead.com/classic/guide/temple-ahnqiraj-aq40-overview-classic-wow (Vem)"},
    ["Verek"] = {dungeon = "Blackrock Depths", source = "https://www.wowhead.com/classic/guide/blackrock-depths-detention-block-dungeon-strategy-wow-classic (Verek)"},
    ["Vile'rel"] = {dungeon = "Blackrock Depths", source = "https://www.wowhead.com/classic/guide/blackrock-depths-shadowforge-city-dungeon-strategy-wow-classic (Vile'rel)"},
    ["Viscidus"] = {dungeon = "Temple of Ahn'Qiraj", source = "https://www.wowhead.com/classic/guide/temple-ahnqiraj-aq40-overview-classic-wow (Viscidus)"},
    ["Watchman Doomgrip"] = {dungeon = "Blackrock Depths", source = "https://www.wowhead.com/classic/guide/blackrock-depths-detention-block-dungeon-strategy-wow-classic (Watchman Doomgrip)"},
    ["Witherfang"] = {dungeon = "Ruins of Lordaeron", source = "StorageInvestigation/journal-voice/quests_corpus.txt #95216 The New Plague, objective and description", setting = "Forever"},
    ["Wushoolay"] = {dungeon = "Zul'Gurub", source = "https://www.wowhead.com/classic/guide/wow-classic-zulgurub-overview (Wushoolay)"},
    ["Ysondre"] = {dungeon = "World encounters", source = "https://www.wowhead.com/classic/guide/classic-world-boss"},
    ["Zealot Lor'Khan"] = {dungeon = "Zul'Gurub", source = "https://www.wowhead.com/classic/guide/wow-classic-zulgurub-overview (Zealot Lor'Khan)"},
    ["Zealot Zath"] = {dungeon = "Zul'Gurub", source = "https://www.wowhead.com/classic/guide/wow-classic-zulgurub-overview (Zealot Zath)"},
    ["Zerillis"] = {dungeon = "Zul'Farrak", source = "https://www.wowhead.com/classic/guide/zulfarrak-dungeon-strategy-wow-classic (Classic roster and events): Zerillis"},
    ["Zolo"] = {dungeon = "The Temple of Atal'Hakkar", source = "https://www.wowhead.com/classic/guide/temple-of-atalhakkar-sunken-temple-dungeon-strategy-wow-classic (Classic dungeon, not Season of Discovery): Zolo"},
    ["Zul'Lor"] = {dungeon = "The Temple of Atal'Hakkar", source = "https://www.wowhead.com/classic/guide/temple-of-atalhakkar-sunken-temple-dungeon-strategy-wow-classic (Classic dungeon, not Season of Discovery): Zul'lor, Frailty"},
}
for name, info in pairs(encounterRegistry) do if not B[name] then B[name] = info end end

function L.Boss(name) return name and B[name] end
function L.ZoneLevels(name) return name and A.LoreZoneLevels and A.LoreZoneLevels[name] end
function L.DungeonLevels(name) return name and A.LoreDungeonLevels and (A.LoreDungeonLevels[name] or A.LoreDungeonLevels[DUNGEON_ALIASES[name]]) end

-- Quests: title -> level, kind (from LoreData's pack, read on first use).
local quests
function L.Quest(title)
    if not title then return nil end
    if not quests then
        quests = {}
        for name, level, kind in (A.LoreQuestPack or ""):gmatch("([^\t\n]+)\t(%d+)\t(%d+)\n") do
            quests[name] = {level = tonumber(level), kind = tonumber(kind)}
        end
        A.LoreQuestPack = nil -- the table replaces the string
    end
    return quests[title]
end

-- Round 8 (the writer): epithets, stories, consequences, quest lore.
do
local function Extend(pool, list) for _, line in ipairs(list) do pool[#pool + 1] = line end end
---------------------------------------------------------------------------
-- 7. LORE DATA (L.zones, L.zoneStory, L.bosses, L.dungeonStory)
---------------------------------------------------------------------------

-- Zone epithets. "the Barrens, under a wide sky" sat next to the sight "...across the Barrens,
-- under a wide sky"; "Stonetalon, scarred by goblin saws" next to "Where the goblins had been";
-- "Ashenvale, where the Sentinels keep watch" next to "...and the Sentinels watched them".
-- "all X and Y" closed five epithets (ice and pine, dust and thorn, reed and rain, sand and sun,
-- frost and silence): two of them change.
L.zones["The Barrens"].e[3] = "{p:the Barrens}, where the caravans cross the grass"
L.zones["Stonetalon Mountains"].e[3] = "{p:Stonetalon}, where the druids keep their peak"
L.zones["Ashenvale"].e[3] = "{p:Ashenvale}, the old forest of the night elves"
L.zones["Dun Morogh"].e[3] = "{p:Dun Morogh}, in the mountains of the dwarves"
L.zones["Durotar"].e[3] = "{p:Durotar}, on the eastern coast of Kalimdor"
-- Uldaman: "The titan vaults of Uldaman was a few levels above us" (plural with "was").
L.dungeons["Uldaman"].e[2] = "the titan vault at {p:Uldaman}"

-- Zone stories: the round 8 index patches (Moonglade, the Barrens, Darkshore, Wetlands, Durotar)
-- were folded into the zone tables above in the places pass of 2026-11-06.

-- Archaedas: the epithet "the ancient stone watcher" and the consequence "The stone watcher of
-- Uldaman was still." came one after the other. The consequence changes.
if L.bosses["Archaedas"] then L.bosses["Archaedas"].after = "The ancient stone watcher no longer barred the way." end
-- NEW FIELD L.bosses[...].afterMore (engine hook: a lord's consequence already said for this day
-- in another of the player's books takes one of these instead; CRITIQUE8 fix 3).
-- (afterMore now lives on each boss entry; places pass 2026-11-06)

-- NEW FIELDS L.dungeonStory[...].whyRace / detailRace / insideRace / whyClass (engine hook: said
-- in place of the common why / detail / inside when the player's race or class matches; once per
-- book). Uldaman draws dwarven researchers seeking their origins; Gnomeregan is
-- the gnomes' own city; the Scarlet Crusade calls on the paladin's Light; Naralex was a druid.
L.dungeonStory["Uldaman"].whyRace = {
    Dwarf = {"The Explorers' League of Ironforge had dug at Uldaman for years, looking for where my people came from."},
}
L.dungeonStory["Uldaman"].detailRace = {
    Dwarf = {"The Explorers' League searched these buried halls for answers about my people's beginnings."},
}
L.dungeonStory["Gnomeregan"].insideRace = {
    Gnome = {"The lepers in the halls had been gnomes of the city, my own people, and their minds were gone."},
}
L.dungeonStory["Gnomeregan"].whyRace = {
    Gnome = {"Gnomeregan was my people's city, and we wanted it back from the troggs and the traitor Thermaplugg."},
}
L.dungeonStory["Scarlet Monastery"].whyClass = {
    PALADIN = {"The Crusade called on the same Light I did, and burned whoever it called unclean with it."},
    PRIEST = {"The Crusade's priests prayed to the same Light I did, and used it against everyone who was not one of them."},
}
L.dungeonStory["Wailing Caverns"].whyClass = {
    DRUID = {"Naralex was a druid of the Cenarion Circle, and his own disciples had turned the dream against him."},
}

---------------------------------------------------------------------------
-- 8. QUEST LORE (L.questStory): the race and class quests of round 8
-- Each from its corpus text. Shared titles (one per race or faction) state the world, not the step.
-- why: said before the quest's sentence; after: right after it, never next to a death.
---------------------------------------------------------------------------
local function Q(title, why, after, zone, level)
    L.questStory[title] = {why = why, after = after, zone = zone, level = level}
end
-- Tauren: the Rites of the Earthmother (corpus 755, 757, 767, 771, 772, 773)
Q("Rite of Strength",
    {"The Rites of the Earthmother were the steps a young tauren took to earn respect in {p:Thunder Bluff}, and strength came first."},
    {"The Bristleback belts went to the chief, and the first of the Rites of the Earthmother was passed."},
    "Mulgore", 4)
Q("Rite of Vision",
    {"Zarlman Two-Moons brewed the Water of the Seers from well stones and ambercorn, for the young on the Rites of the Earthmother."},
    {"The Water of the Seers was drunk by the tribal fire, and a vision came out of the flames to be followed."},
    "Mulgore", 6)
Q("Rite of Wisdom",
    {"Only those who had drunk the Water of the Seers could ask the ancestral spirits at the Red Rocks for their blessing."},
    {"The Ancestral Spirit at the Red Rocks gave its blessing, and a young tauren could enter {p:Thunder Bluff} with pride."},
    "Mulgore", 10)
Q("Poison Water",
    {"Goblins and their servants had tainted the sacred water wells of {p:Mulgore}, and only a cleansing totem could clean them."},
    {"The paws and talons went into a cleansing totem, the first step to clean water in the wells of {p:Mulgore}."},
    "Mulgore", 5)
Q("Swoop Hunting",
    {"A bundle of swoop quills was a badge of cleverness among the hunters of {p:Bloodhoof Village}."},
    {"The swoop quills proved one more hunter of merit at {p:Bloodhoof Village}."},
    "Mulgore", 6)
Q("Dwarven Digging",
    {"Dwarves were digging in {p:Mulgore}, and the tauren held that hollowing out the land was no way to learn from it."},
    {"The dwarves' tools were broken at a forge, and the kodos of {p:Mulgore} were calmer for it."},
    "Mulgore", 8)
-- Druid (5923 to 5927: Darnassus and Thunder Bluff; the lines hold for both)
Q("Heeding the Call",
    {"Word came that one of the Arch Druid's assistants wished to train a young druid himself."},
    {"A young druid's training began with the ways of the bear, and with strength of body and heart."},
    "Thunder Bluff", 10)
-- Troll and orc (805, 786, 835)
Q("Report to Sen'jin Village",
    {"The Burning Blade had reached the Valley of Trials, and Master Gadrin of {p:Sen'jin Village} had to be told."},
    {"Master Gadrin heard the news, and told of a darker evil taking root on the Echo Isles."},
    "Durotar", 5)
Q("Thwarting Kolkar Aggression",
    {"The Kolkar centaurs had planned an attack on the orcs and trolls of {p:Durotar}, and split the plans among three of their leaders."},
    {"The Kolkar plans were destroyed, and the attack on {p:Durotar} never came."},
    "Durotar", 8)
Q("Securing the Lines",
    {"Rezlak had lost too many caravans to the harpies of Drygulch Ravine, and meant to see it done himself, or pay for it."},
    {"The harpies of Drygulch Ravine were thinned, and Rezlak's caravans could move again."},
    "Durotar", 11)
-- The Barrens (1491, 848)
Q("Smart Drinks",
    {"Mebok Mizzyrix believed Wailing Essence from the caverns would make his smart drinks work at last."},
    {"Mebok had his Wailing Essence, and promised to pay more once he was rich."},
    "The Barrens", 18)
Q("Fungal Spores",
    {"The apothecaries of Lordaeron wanted the spores of the mushrooms that grew by the oases of {p:the Barrens}."},
    {"The spores went to the apothecary, and the Forsaken kept their side of the bargain."},
    "The Barrens", 15)
-- Night elf and the class sigils (916, 3524, 458/459, 3117, 3118)
Q("Webwood Venom",
    {"A scholar in {p:Shadowglen} believed the new World Tree had changed the spiders of the Shadowthread Cave, and wanted their venom."},
    {"The venom sacs went to {p:Darnassus}, to be studied for what the World Tree had done to the spiders."},
    "Teldrassil", 4)
Q("Washed Ashore",
    {"Great sea creatures were beaching themselves on {p:Darkshore} in growing numbers, and the Temple of the Moon wanted to know why."},
    {"The bones went to the Temple of the Moon, and no one there yet knew why the creatures came ashore to die."},
    "Darkshore", 13)
Q("The Woodland Protector",
    {"The dryad Tarindrella had come back to {p:Shadowglen} after years away, and the druids feared something was wrong."},
    {"The Fel Moss on the grells proved it, and the corruption had reached the forests of {p:Teldrassil}."},
    "Teldrassil", 1)
Q("Etched Sigil",
    {"A sigil from Ayanna, the hunter trainer of {p:Shadowglen}, called a new hunter to her."},
    {"Ayanna spoke of beasts to tame and a bow to master, and sent the new hunter on with Elune."},
    "Teldrassil", 1)
Q("Encrypted Sigil",
    {"A sigil from Frahun, the rogue trainer of {p:Shadowglen}, called a new rogue to him."},
    {"Frahun warned that the peace with the other races could fail at any moment."},
    "Teldrassil", 1)
-- Dwarf and gnome (182, 384, 436, 353)
Q("The Troll Cave",
    {"The Frostmane trolls held a cave in the south of Coldridge Valley, and the dwarves sent a few strong arms instead of an army."},
    {"The trolls of the Coldridge cave were thinned, though a band of them had already come in the night and robbed a dwarf."},
    "Dun Morogh", 4)
Q("Beer Basted Boar Ribs",
    {"The tavern in {p:Kharanos} had lost its trapper to the war, and needed crag boar ribs from someone else."},
    {"The tavern in {p:Kharanos} gave up its family recipe for boar ribs, and the secret was in the malt."},
    "Dun Morogh", 7)
Q("Ironband's Excavation",
    {"Supplies kept going to Prospector Ironband's dig east of the loch, and the work kept going slowly."},
    {"The trouble at Ironband's dig was troggs, as Magmar Fellhew said."},
    "Loch Modan", 18)
Q("Stormpike's Delivery",
    {"Mountaineer Stormpike had ordered a new axe from Ironforge, and he was stationed far away in {p:Loch Modan}."},
    {"Mountaineer Stormpike had his new axe, and could hardly wait to try it on the troggs."},
    "Loch Modan", 15)
-- Priest (5624, 5625: Goldshire and Kharanos; the lines hold for both)
Q("Garments of the Light",
    {"A young priest earned the first robes of the order by healing someone hurt outside town."},
    {"Someone hurt outside town was on his feet again, and one more priest wore the robes of the order."},
    "Dun Morogh", 4)
-- The paladin's road (681, 536)
Q("Northfold Manor",
    {"Stromgarde's last men at {p:Refuge Pointe} were losing the war, and the Syndicate held the way their supplies came by."},
    {"The Syndicate at Northfold Manor were cut down, and supplies from {p:Southshore} could reach {p:Refuge Pointe} again."},
    "Arathi Highlands", 31)
Q("Down the Coast",
    {"A guard sent from {p:Stormwind} to {p:Southshore} had been told to deal with the murlocs, and would rather have another ale."},
    {"The guard in {p:Southshore} could tell Redpath the murlocs were dealt with, and called for another ale."},
    "Hillsbrad Foothills", 30)
-- Two lines CRITIQUE7 asked to change (the zeugma, and a spell tooltip).
L.questStory["Kodo Roundup"].after = {"Smeed had his five tamed kodos for Cork's caravan, and one more reason to gloat over Bibbly."}
L.questStory["Taming the Beast"].after = {"After three beasts tamed for practice, the trainer taught the taming of any beast."}
L.questStory["Taming the Beast"].covers = "tame"

end

-- Round 8b (the writer).
-- L.bosses.Archaedas.afterMore. "Archaedas never got past you. Archaedas lay still..." (my line).
if L.bosses["Archaedas"] then L.bosses["Archaedas"].afterMore = {"The ancient stone watcher no longer barred the way."} end

-- L.dungeonStory.Uldaman.whyRace. With detailRace in the same chapter, "my people" came twice in two
-- sentences. ENGINE: one race line per visit (prefer the detail). The why no longer says it.
L.dungeonStory["Uldaman"].whyRace = {
    Dwarf = {"The Explorers' League of Ironforge had dug at Uldaman for years, looking for where the dwarves came from."},
}

-- Curated regional modules share one resolver and retain their source inventory.
-- Loading content never reads or changes a character's recorded history.
L.storyPacks, L.questStoryIDs = {}, {}
-- Choose substance before wording. A significant finale should not erase the
-- recorded earlier steps of its own chain. The result is always chronological;
-- this never manufactures a missing stage or modifies the caller's quest list.
function L.QuestBeats(quests, seen, limit, exclude)
    local candidates, unique = {}, {}
    for order, quest in ipairs(quests or {}) do
        local key = quest.qid or quest.title
        local story = L.QuestStory(quest.title, quest.qid)
        if story and story.after and #story.after > 0 and not (seen and seen[key])
            and not unique[key] and not (exclude and exclude(quest)) then
            unique[key] = true
            candidates[#candidates + 1] = {quest = quest, story = story, order = order,
                importance = story.importance or 1}
        end
    end
    local function Earlier(a, b)
        local at, bt = a.quest.t or 0, b.quest.t or 0
        return at < bt or (at == bt and a.order < b.order)
    end
    table.sort(candidates, function(a, b)
        if a.importance ~= b.importance then return a.importance > b.importance end
        return Earlier(a, b)
    end)
    limit = math.max(1, limit or 3)
    local focus, chosen, selected = candidates[1], {}, {}
    if not focus then return chosen end
    local function Take(item)
        if not selected[item] and #chosen < limit then
            chosen[#chosen + 1], selected[item] = item, true
        end
    end
    Take(focus)
    local related = {}
    for _, item in ipairs(candidates) do
        if focus.story.thread and item.story.thread == focus.story.thread then related[#related + 1] = item end
    end
    table.sort(related, Earlier)
    -- Preserve the beginning, then meaningful resolutions before intermediate
    -- referrals. Sorting every sibling by time here could crowd out the finale.
    if related[1] then Take(related[1]) end
    table.sort(related, function(a, b)
        if a.importance ~= b.importance then return a.importance > b.importance end
        return Earlier(a, b)
    end)
    for _, item in ipairs(related) do Take(item) end
    for _, item in ipairs(candidates) do Take(item) end
    table.sort(chosen, Earlier)
    return chosen
end
function L.RegisterStoryPack(id, pack)
    assert(type(id) == "string" and not L.storyPacks[id], "duplicate story pack")
    assert(type(pack) == "table" and type(pack.sources) == "table", "story pack needs provenance")
    L.storyPacks[id] = pack
    for key, label in pairs(pack.threads or {}) do L.storyThreads[key] = label end
    for title, entry in pairs(pack.quests or {}) do
        local combined = {}
        for k, v in pairs(L.questStory[title] or {}) do combined[k] = v end
        for k, v in pairs(entry) do combined[k] = v end
        combined.threadLabel = combined.threadLabel or L.storyThreads[combined.thread]
        combined.pack = id
        L.questStory[title] = combined
    end
    for questID, entry in pairs(pack.questIDs or {}) do
        assert(type(questID) == "number" and type(entry.title) == "string", "quest ID needs exact title")
        assert(not L.questStoryIDs[questID], "duplicate quest ID in story packs")
        local combined = {}
        for k, v in pairs(L.questStory[entry.title] or {}) do combined[k] = v end
        for k, v in pairs(entry) do combined[k] = v end
        combined.threadLabel = combined.threadLabel or L.storyThreads[combined.thread]
        combined.pack = id
        L.questStoryIDs[questID] = combined
    end
    for name, entry in pairs(pack.zones or {}) do
        local zone = L.zoneStory[name] or {}
        L.zoneStory[name] = zone
        for kind, lines in pairs(entry) do
            if kind == "sight" or kind == "stakes" then
                zone[kind] = zone[kind] or {}
                for _, line in ipairs(lines) do
                    local found = false
                    for _, old in ipairs(zone[kind]) do if old == line then found = true end end
                    if not found then zone[kind][#zone[kind] + 1] = line end
                end
            end
        end
    end
end

