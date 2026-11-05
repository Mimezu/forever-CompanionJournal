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
    ["Oggleflint"] = {e = "the trogg chieftain"},
    -- Neeru names Taragaman in 5761; Thrall identifies Jergosh and Bazzalan
    -- as the leaders in 5728. Keep Neeru's claim out of omniscient narration.
    ["Taragaman the Hungerer"] = {e = "the felguard of Ragefire Chasm", kind = "demon", last = true, after = "One of the Searing Blade's demons lay dead beneath Orgrimmar."},
    ["Jergosh the Invoker"] = {e = "the Searing Blade's warlock"},
    ["Bazzalan"] = {e = "the satyr of the Searing Blade", kind = "demon"},
})
-- Wailing Caverns
Add("humanoid", {
    ["Lady Anacondra"] = {e = "a Fang druid lost to the nightmare"},
    ["Lord Cobrahn"] = {e = "a Fang druid lost to the nightmare"},
    ["Lord Pythas"] = {e = "a Fang druid lost to the nightmare"},
    ["Lord Serpentis"] = {e = "a Fang druid lost to the nightmare"},
    ["Kresh"] = {e = "the great turtle of the caverns", kind = "beast"},
    ["Skum"] = {e = "the thunder lizard of the deep pools", kind = "beast"},
    ["Verdan the Everliving"] = {e = "a twisted keeper of the grove", kind = "elemental"},
    ["Mutanus the Devourer"] = {e = "the murloc horror in Naralex's dream", kind = "aberration", last = true, after = "The nightmare's devourer had fallen."},
    ["Mad Magglish"] = {e = "a goblin who wandered too deep"},
})
-- The Deadmines
Add("humanoid", {
    ["Rhahk'Zor"] = {e = "the ogre foreman", kind = "giant"},
    ["Sneed"] = {e = "the goblin in his shredder"},
    ["Sneed's Shredder"] = {e = "Sneed's shredder", kind = "construct"},
    ["Gilnid"] = {e = "the goblin smelter"},
    ["Mr. Smite"] = {e = "VanCleef's first mate"},
    ["Captain Greenskin"] = {e = "the goblin captain"},
    ["Edwin VanCleef"] = {e = "the master of the Defias Brotherhood", last = true, after = "The Defias Brotherhood had lost its master."},
    ["Cookie"] = {e = "the murloc cook of the Defias ship", kind = "beast"},
})
-- Shadowfang Keep
Add("humanoid", {
    ["Rethilgore"] = {e = "Arugal's jailer", kind = "beast"},
    ["Razorclaw the Butcher"] = {e = "the keep's butcher", kind = "beast"},
    ["Baron Silverlaine"] = {e = "the keep's old lord, restless in death", kind = "undead"},
    ["Commander Springvale"] = {e = "a paladin fallen to darkness", kind = "undead"},
    ["Odo the Blindwatcher"] = {e = "the blind worgen of the tower", kind = "beast"},
    ["Fenrus the Devourer"] = {e = "Arugal's pet in the keep", kind = "beast"}, -- Classic NPC 4274
    ["Wolf Master Nandos"] = {e = "the keeper of Arugal's wolves", kind = "beast"},
    ["Archmage Arugal"] = {e = "the mad archmage who brought the worgen", last = true, after = "Silverpine was rid of Arugal, for now."},
})
-- Blackfathom Deeps
Add("humanoid", {
    ["Ghamoo-ra"] = {e = "the great turtle", kind = "beast"},
    ["Lady Sarevess"] = {e = "the naga witch"},
    ["Gelihast"] = {e = "the murloc chief", kind = "beast"},
    ["Lorgus Jett"] = {e = "a Twilight's Hammer priest"},
    ["Baron Aquanis"] = {e = "a water lord of the deep", kind = "elemental"},
    ["Twilight Lord Kelris"] = {e = "the Twilight's Hammer's high priest"},
    ["Old Serra'kis"] = {e = "the old shark of the depths", kind = "beast"},
    ["Aku'mai"] = {e = "the Old Gods' hydra in the deep water", kind = "beast", last = true, after = "The great hydra lay still in the deep water."},
})
-- The Stockade
Add("humanoid", {
    ["Targorr the Dread"] = {e = "the prison's cruellest inmate"},
    ["Kam Deepfury"] = {e = "a Dark Iron prisoner"},
    ["Hamhock"] = {e = "the ogre inmate", kind = "giant"},
    ["Dextren Ward"] = {e = "a murderer in the cells"},
    ["Bazil Thredd"] = {e = "the leader of the riot", last = true, after = "The riot had lost its leader."},
    ["Bruegal Ironknuckle"] = {e = "the dwarf in the far cell"},
})
-- Gnomeregan
Add("humanoid", {
    ["Grubbis"] = {e = "the trogg brute"},
    ["Viscous Fallout"] = {e = "a living pool of fallout", kind = "aberration"},
    ["Electrocutioner 6000"] = {e = "a gnomish war machine", kind = "construct"},
    ["Crowd Pummeler 9-60"] = {e = "a gnomish war machine", kind = "construct"},
    ["Mekgineer Thermaplugg"] = {e = "the traitor who flooded Gnomeregan with radiation", last = true, after = "Gnomeregan's traitor was dead."},
})
-- Razorfen Kraul and Downs
Add("humanoid", {
    ["Roogug"] = {e = "a quilboar geomancer"},
    ["Aggem Thorncurse"] = {e = "a Death's Head prophet"},
    ["Death Speaker Jargba"] = {e = "a Death's Head priest"},
    ["Overlord Ramtusk"] = {e = "the Kraul's overlord"},
    ["Agathelos the Raging"] = {e = "the boar god's champion", kind = "beast"},
    ["Charlga Razorflank"] = {e = "the quilboar matriarch", last = true, after = "The Kraul had lost its matriarch."},
    ["Tuten'kash"] = {e = "the great spider of the barrows", kind = "beast"},
    ["Mordresh Fire Eye"] = {e = "an undead servant of the Scourge", kind = "undead"}, -- Classic NPC 7357
    ["Glutton"] = {e = "a bloated horror of the Scourge", kind = "undead"},
    ["Amnennar the Coldbringer"] = {e = "the lich who rules the Downs", kind = "undead", last = true, after = "The Downs had lost their lich."},
})
-- Scarlet Monastery
Add("humanoid", {
    ["Interrogator Vishas"] = {e = "the Crusade's torturer"},
    ["Bloodmage Thalnos"] = {e = "a Crusader risen from the graveyard", kind = "undead"},
    ["Houndmaster Loksey"] = {e = "the Crusade's houndmaster"},
    ["Arcanist Doan"] = {e = "the keeper of the Crusade's library"},
    ["Herod"] = {e = "the Scarlet Champion"},
    ["Scarlet Commander Mograine"] = {e = "the Crusade's commander"},
    ["High Inquisitor Whitemane"] = {e = "who could raise the Crusade's dead", last = true, after = "The Crusade had lost its high inquisitor."},
    ["High Inquisitor Fairbanks"] = {e = "a forgotten inquisitor, cursed in the cathedral", kind = "undead"},
})
-- Uldaman
Add("humanoid", {
    ["Revelosh"] = {e = "a trogg sorcerer"},
    ["Baelog"] = {e = "a dwarven explorer who went too deep"},
    ["Ironaya"] = {e = "a titan-forged guardian", kind = "construct"},
    ["Obsidian Sentinel"] = {e = "a living stone guardian", kind = "construct"},
    ["Ancient Stone Keeper"] = {e = "an ancient stone keeper", kind = "construct"},
    ["Galgann Firehammer"] = {e = "a Dark Iron treasure hunter"},
    ["Grimlok"] = {e = "the trogg king"},
    ["Archaedas"] = {e = "the ancient stone watcher", kind = "construct", last = true, after = "The stone watcher of Uldaman was still."},
})
-- Zul'Farrak
Add("humanoid", {
    ["Antu'sul"] = {e = "the Sandfury overseer"},
    ["Witch Doctor Zum'rah"] = {e = "the witch doctor of the graveyard"},
    ["Hydromancer Velratha"] = {e = "the Sandfury hydromancer"},
    ["Gahz'rilla"] = {e = "the great hydra of the sacred pool", kind = "beast"},
    ["Sergeant Bly"] = {e = "a treasure hunter in over his head"},
    ["Theka the Martyr"] = {e = "a Sandfury martyr"},
    ["Nekrum Gutchewer"] = {e = "a Sandfury ghoul lord", kind = "undead"},
    ["Shadowpriest Sezz'ziz"] = {e = "the Sandfury shadowpriest"},
    ["Chief Ukorz Sandscalp"] = {e = "the Sandfury chieftain", last = true, after = "The Sandfury would need a new chief."},
})
-- Maraudon
Add("humanoid", {
    ["Noxxion"] = {e = "a poisonous horror", kind = "elemental"},
    ["Razorlash"] = {e = "a thorned beast of the caverns", kind = "beast"},
    -- Quest 7044 names Vyletongue as a satyr and Celebras as cursed;
    -- 7046 describes Celebras's living work after the encounter. Neither
    -- supports the old 'sons of Zaetar' or undead characterization.
    ["Lord Vyletongue"] = {e = "the satyr spreading corruption through Maraudon", kind = "demon"},
    ["Celebras the Cursed"] = {e = "a keeper lost in Maraudon's corruption", victory = {"{p:Celebras the Cursed} was overcome, freeing the keeper from his curse.", "The fight with {p:Celebras the Cursed} ended with the keeper freed from his curse."}},
    ["Landslide"] = {e = "a living landslide", kind = "elemental"},
    ["Tinkerer Gizlock"] = {e = "a goblin tinkerer"},
    ["Rotgrip"] = {e = "a great crocolisk", kind = "beast"},
    ["Princess Theradras"] = {e = "the earth's daughter", kind = "elemental", last = true, after = "Maraudon was free of Theradras, for now."},
})
-- Sunken Temple
Add("humanoid", {
    ["Atal'alarion"] = {e = "the idol's guardian", kind = "construct"},
    ["Dreamscythe"] = {e = "a green dragon of the corrupted flight", kind = "dragon"},
    ["Weaver"] = {e = "a green dragon of the corrupted flight", kind = "dragon"},
    ["Jammal'an the Prophet"] = {e = "the Atal'ai prophet"},
    ["Morphaz"] = {e = "a green dragon of the corrupted flight", kind = "dragon"},
    ["Hazzas"] = {e = "a green dragon of the corrupted flight", kind = "dragon"},
    ["Avatar of Hakkar"] = {e = "the blood god's avatar", kind = "demon"},
    ["Shade of Eranikus"] = {e = "the shade of the green dragon consort", kind = "dragon", last = true, after = "The shade had fallen within the sunken temple."},
})
-- Blackrock Depths
Add("humanoid", {
    ["Lord Roccor"] = {e = "a lord of fire and stone", kind = "elemental"},
    ["High Interrogator Gerstahn"] = {e = "the Dark Iron interrogator"},
    ["Houndmaster Grebmar"] = {e = "the Dark Iron houndmaster"},
    ["Bael'Gar"] = {e = "a giant of living magma", kind = "elemental"},
    ["Lord Incendius"] = {e = "Ragnaros' servant at the Black Anvil", kind = "elemental"},
    ["Fineous Darkvire"] = {e = "the Dark Iron's chief architect"},
    ["Pyromancer Loregrain"] = {e = "the Dark Iron pyromancer"},
    ["Warder Stilgiss"] = {e = "the Dark Iron warder"},
    ["General Angerforge"] = {e = "the Dark Iron general"},
    ["Golem Lord Argelmach"] = {e = "the master of the Dark Iron golems"},
    ["Hurley Blackbreath"] = {e = "a brewer with a grudge"},
    ["Plugger Spazzring"] = {e = "the Grim Guzzler's barkeep"},
    ["Ambassador Flamelash"] = {e = "Ragnaros' ambassador", kind = "elemental"},
    ["Magmus"] = {e = "the golem at the throne room's gate", kind = "construct"},
    ["Princess Moira Bronzebeard"] = {e = "King Magni's daughter"},
    ["Emperor Dagran Thaurissan"] = {e = "the Dark Iron emperor", last = true, after = "The Dark Iron empire had lost its emperor."},
})
-- Blackrock Spire
Add("humanoid", {
    ["Highlord Omokk"] = {e = "the ogre highlord", kind = "giant"},
    ["Shadow Hunter Vosh'gajin"] = {e = "a Smolderthorn shadow hunter"},
    ["War Master Voone"] = {e = "the Smolderthorn war master"},
    ["Mother Smolderweb"] = {e = "the spider queen of the Spire", kind = "beast"},
    ["Urok Doomhowl"] = {e = "an ogre champion", kind = "giant"},
    ["Quartermaster Zigris"] = {e = "the Blackrock quartermaster"},
    ["Halycon"] = {e = "the worg mother", kind = "beast"},
    ["Gizrul the Slavener"] = {e = "a great worg", kind = "beast"},
    ["Overlord Wyrmthalak"] = {e = "the Blackrock overlord", last = true, after = "The lower Spire had lost its overlord."},
    ["Pyroguard Emberseer"] = {e = "the fire elemental bound in the Spire", kind = "elemental"},
    ["Warchief Rend Blackhand"] = {e = "the false warchief of the Dark Horde"},
    ["Gyth"] = {e = "Rend's dragon mount", kind = "dragon"},
    ["The Beast"] = {e = "the core hound of the upper Spire", kind = "beast"}, -- Classic NPC 10430
    ["General Drakkisath"] = {e = "the black dragon general of the Spire", kind = "dragon", last = true, after = "The Spire had lost its dragon general."},
})
-- Dire Maul
Add("humanoid", {
    ["Zevrim Thornhoof"] = {e = "a satyr of the east wing", kind = "demon"},
    ["Hydrospawn"] = {e = "a water elemental", kind = "elemental"},
    -- Quests 7488/7489 identify the mage and the purpose of her web.
    ["Lethtendris"] = {e = "the blood elf mage siphoning Dire Maul's magic"},
    ["Alzzin the Wildshaper"] = {e = "the satyr who corrupted the gardens", kind = "demon", last = true, after = "The gardens of Dire Maul were rid of Alzzin."},
    ["Tendris Warpwood"] = {e = "a corrupted treant", kind = "elemental"},
    ["Illyanna Ravenoak"] = {e = "a night elf ghost", kind = "undead"},
    ["Magister Kalendris"] = {e = "a Highborne magister"},
    ["Immol'thar"] = {e = "the demon the Highborne kept imprisoned", kind = "demon"},
    ["Prince Tortheldrin"] = {e = "the prince of the Shen'dralar", last = true, after = "The Shen'dralar had lost their prince."},
    ["King Gordok"] = {e = "the ogre king", kind = "giant", last = true, after = "The Gordok would need a new king."},
    ["Cho'Rush the Observer"] = {e = "the king's ogre mage", kind = "giant"},
})
-- Stratholme
Add("undead", {
    ["The Unforgiven"] = {e = "a restless spirit"},
    ["Timmy the Cruel"] = {e = "a horror in the market square"},
    ["Cannon Master Willey"] = {e = "the Crusade's cannon master", kind = "humanoid"},
    ["Archivist Galford"] = {e = "the Crusade's archivist", kind = "humanoid"},
    ["Balnazzar"] = {e = "the dreadlord in the Scarlet Bastion", kind = "demon", last = true, after = "The dreadlord had fallen in the Scarlet Bastion."},
    ["Baroness Anastari"] = {e = "a banshee of the Scourge"},
    ["Nerub'enkan"] = {e = "a crypt lord of the Scourge"},
    ["Maleki the Pallid"] = {e = "a Scourge necromancer"},
    ["Magistrate Barthilas"] = {e = "the city's magistrate, risen"},
    ["Ramstein the Gorger"] = {e = "an abomination of the slaughterhouse"},
    ["Baron Rivendare"] = {e = "the Scourge's baron", last = true, after = "Stratholme had lost its baron."},
    ["Postmaster Malown"] = {e = "the city's postmaster, still delivering"},
})
-- Scholomance
Add("undead", {
    ["Kirtonos the Herald"] = {e = "the herald of the school", kind = "demon"},
    ["Jandice Barov"] = {e = "a Barov of the Scholomance"},
    ["Rattlegore"] = {e = "a bone golem"},
    ["Ras Frostwhisper"] = {e = "a lich of the Scholomance"},
    ["Instructor Malicia"] = {e = "an instructor of the Scholomance"},
    ["Doctor Theolen Krastinov"] = {e = "the Butcher of the Scholomance", kind = "humanoid"},
    ["Lorekeeper Polkelt"] = {e = "the school's lorekeeper"},
    ["The Ravenian"] = {e = "a horror of the lower halls"},
    ["Lord Alexei Barov"] = {e = "a Barov of the Scholomance"},
    ["Lady Illucia Barov"] = {e = "a Barov of the Scholomance"},
    ["Darkmaster Gandling"] = {e = "the headmaster of the Scholomance", kind = "humanoid", last = true, after = "The Scholomance had lost its headmaster."},
})
-- Raids and great foes
Add("elemental", {
    ["Lucifron"] = {e = "a lieutenant of the Firelord", kind = "demon"},
    ["Magmadar"] = {e = "the core hound of the Firelord", kind = "beast"},
    ["Gehennas"] = {e = "a lieutenant of the Firelord", kind = "demon"},
    ["Garr"] = {e = "a great lord of fire"},
    ["Shazzrah"] = {e = "a lieutenant of the Firelord", kind = "demon"},
    ["Baron Geddon"] = {e = "a great lord of fire"},
    ["Sulfuron Harbinger"] = {e = "the Firelord's herald", kind = "demon"},
    ["Golemagg the Incinerator"] = {e = "the giant of the core", kind = "giant"},
    -- NPC 12018's surrender dialogue: success is not the steward's death.
    -- https://www.wowhead.com/classic/npc=12018/majordomo-executus
    ["Majordomo Executus"] = {e = "the Firelord's steward", victory = {"{p:Majordomo Executus} surrendered when his guards were defeated.", "With his guards defeated, {p:Majordomo Executus} submitted."}},
    ["Ragnaros"] = {e = "the Firelord himself", last = true, after = "The Firelord was driven back into the fire, for a time."},
    ["Onyxia"] = {e = "the Broodmother of the Black Dragonflight", kind = "dragon", last = true, after = "The Broodmother lay defeated in her lair."},
    ["Razorgore the Untamed"] = {e = "the guardian of Blackwing Lair's eggs", kind = "dragon"}, -- Classic NPC 12435
    ["Vaelastrasz the Corrupt"] = {e = "a red dragon, tortured and bound", kind = "dragon"},
    ["Broodlord Lashlayer"] = {e = "the broodlord of the lair", kind = "dragon"},
    ["Firemaw"] = {e = "a black drake", kind = "dragon"},
    ["Ebonroc"] = {e = "a black drake", kind = "dragon"},
    ["Flamegor"] = {e = "a black drake", kind = "dragon"},
    ["Chromaggus"] = {e = "Nefarian's two-headed abomination", kind = "dragon"},
    ["Nefarian"] = {e = "the lord of Blackwing Lair", kind = "dragon", last = true, after = "Blackwing Lair had lost its lord."},
    ["Hakkar"] = {e = "the Soulflayer, the blood god", kind = "demon", last = true, after = "The Soulflayer was cast out of the world."},
    ["High Priestess Jeklik"] = {e = "a priestess of the Gurubashi", kind = "humanoid"},
    ["High Priest Venoxis"] = {e = "a priest of the Gurubashi", kind = "humanoid"},
    ["High Priestess Mar'li"] = {e = "a priestess of the Gurubashi", kind = "humanoid"},
    ["High Priest Thekal"] = {e = "a priest of the Gurubashi", kind = "humanoid"},
    ["High Priestess Arlokk"] = {e = "a priestess of the Gurubashi", kind = "humanoid"},
    ["Bloodlord Mandokir"] = {e = "the Gurubashi's bloodlord", kind = "humanoid"},
    ["Jin'do the Hexxer"] = {e = "the hexxer of Zul'Gurub", kind = "humanoid"},
    ["Ossirian the Unscarred"] = {e = "the unscarred general of the swarm", kind = "aberration", last = true, after = "The swarm's general was dead."},
    ["C'Thun"] = {e = "an old god, waking", kind = "aberration", last = true, after = "An old god lay dead beneath the sand."},
    ["Kel'Thuzad"] = {e = "the lich lord of Naxxramas", kind = "undead", last = true, after = "Naxxramas had lost its master, for a time."},
    ["Patchwerk"] = {e = "the Scourge's greatest abomination", kind = "undead"},
    ["Sapphiron"] = {e = "the frost wyrm of Naxxramas", kind = "undead"},
    ["Azuregos"] = {e = "the blue dragon of Azshara", kind = "dragon"},
    ["Lord Kazzak"] = {e = "the demon lord of the Blasted Lands", kind = "demon"},
})
-- Forever's own
Add("undead", {
    ["Rath'mael"] = {e = "the necromancer who brought the fog", kind = "humanoid", last = true,
        after = "The fog over the ruins had lost its maker."},
    ["Durgen Dirgehammer"] = {e = "the Dark Iron commander under Ironforge", kind = "humanoid", last = true,
        after = "The Dark Iron incursion beneath Ironforge had lost its commander."},
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
        why = {"Ragefire Chasm opened beneath Orgrimmar, through the Cleft of Shadow.", "Troggs and cultists occupied the caverns below the Horde capital.", "The Searing Blade occupied part of the chasm beneath Orgrimmar."},
        inside = {"The chasm ran hot and red under the city, and troggs and cultists filled it.",
            "Lava ran through the lower caves, and the heat never let up.", -- fixed
            "Troggs held the upper caves, and the Searing Blade kept to the deeper ones."}, -- new
        detail = {"Lava lit the caverns beneath the city."}}, -- new
    ["Wailing Caverns"] = {
        why = {"The druid Naralex had fallen into a nightmare in the caverns, and his own disciples had turned against him.",
            "The Druids of the Fang had gone mad in the caverns, and the dreaming Naralex needed waking.",
            "Naralex had gone into the caverns to dream the Barrens green again, and the dream had turned to nightmare."}, -- new
        inside = {"The caves were green and damp, and the wailing never stopped.",
            "Deviate beasts and mad druids prowled the tunnels.",
            "Wind moaned through cracks in the rock, and that sound gave the caverns their name."}, -- new
        detail = {"Strange beasts had risen from beneath the Barrens into these caverns."}}, -- new
    ["The Deadmines"] = {
        why = {"The Defias Brotherhood had turned the old mines of Moonbrook into a hidden shipyard, and Westfall wanted Edwin VanCleef dead.",
            "Edwin VanCleef had rebuilt {p:Stormwind} and was never paid, and now his Defias were building a ship under Westfall.", -- fixed
            "Stormwind would not help Westfall, so the People's Militia went after the Defias themselves."}, -- new
        inside = {"Deep in the mines, the Defias had built a whole ship in the dark.",
            "Goblins and outlaws worked the tunnels, and the mine carts never stopped.",
            "At the end of the tunnels the cave opened onto the sea, where the ship lay at anchor."}, -- new
        detail = {"The thieves wore rings of the old Stonemasons' Guild, the men who had rebuilt Stormwind.", -- new
            "A goblin shredder still worked deep in the mine."}}, -- new
    ["Shadowfang Keep"] = {
        why = {"Archmage Arugal had filled the old keep with worgen, and Silverpine paid the price.",
            "The worgen of Silverpine came from the keep, and Arugal was their master.",
            "Arugal had called the worgen to fight the Scourge, and lost control of them.", -- new
            "The keep had belonged to Baron Silverlaine before Arugal took it."}, -- new
        inside = {"The keep was cold, and old ghosts walked its halls beside the worgen.",
            "Worgen howled on the floors above.", -- fixed
            "The keep's old servants still walked its halls, long dead."}, -- new
        detail = {"In the courtyard cells, prisoners waited for someone to open the doors.", -- new
            "Somewhere in the keep lay the Book of Ur, written by a great mage of Dalaran."}}, -- new
    ["Blackfathom Deeps"] = {
        why = {"The Twilight's Hammer had taken an old night elf temple on the coast, and few knew what they served down there.", -- fixed
            "Cultists of the Twilight's Hammer were feeding something in the deep water of Blackfathom.",
            "Blackfathom had been a temple of Elune, until something from below fouled its moonwell."}, -- new
        inside = {"Water filled the halls of the sunken temple.",
            "The old temple was half under the sea, and the naga swam its halls.",
            "Statues of the night elves stood to their knees in black water."}, -- new
        detail = {"Twilight's Hammer cultists and naga occupied the ruined temple together."}}, -- new
    ["The Stockade"] = {
        why = {"The prisoners of the Stockade had risen and taken the prison, right in the heart of {p:Stormwind}.",
            "The Stockade's inmates had killed their guards, and Stormwind wanted order back.",
            "The riot had a leader, Bazil Thredd, and the warden wanted his head."}, -- new
        inside = {"The cells stood open and the prisoners were loose.",
            "Loose prisoners filled the corridors, and no guard stood in them.", -- fixed
            "The prison lay under the city, by the canals."}, -- new
        detail = {"Among the prisoners was a Dark Iron dwarf, Kam Deepfury, held there for political reasons."}}, -- new
    ["Gnomeregan"] = {
        why = {"Gnomeregan had fallen to troggs and to the traitor Mekgineer Thermaplugg, and the gnomes wanted their city back.",
            "The gnomes had lost their city to radiation, troggs and a traitor, and asked for help taking it back.",
            "To kill the troggs, the gnomes had flooded their own city with radiation, and most of their people were caught in it."}, -- new
        inside = {"The city was all pipes, gears and green poison.",
            "Machines still ran in the empty halls, and not all of them were friendly.",
            "The gnomes who stayed behind wandered the halls as lepers, their minds gone."}, -- new
        detail = {"Important records had been left inside when the gnomes fled their city."}}, -- new
    ["Razorfen Kraul"] = {
        why = {"Charlga Razorflank was gathering an army in the Kraul, and the Barrens had had enough of quilboar raids.", -- fixed
            "The quilboar raided the Barrens from their thorn maze, and someone had to go in.",
            "The quilboar held the brambles sacred, for they grew where the demigod Agamaggan fell."}, -- new
        inside = {"Great thorns grew over everything in the Kraul.",
            "The maze of thorns turned back on itself, and the quilboar knew every path.",
            "The quilboar kept prisoners deep in the maze."}, -- new
        detail = {"A goblin named Willix had come for the Redleaf Tuber, and had been a prisoner ever since."}}, -- new
    ["Scarlet Monastery"] = {
        why = {"The Scarlet Crusade had made the monastery their stronghold, and their zeal made enemies of everyone.",
            "The Crusade held the monastery in Tirisfal, and it killed anyone it thought unclean.", -- fixed
            "High Inquisitor Whitemane led the Crusade from the monastery, and Horde and Alliance alike wanted her dead."}, -- new
        inside = {"Crusaders filled the halls, ready to die for their cause.",
            "Every room held more of the Crusade, and none of them would surrender.",
            "The graveyard behind the monastery was full of dead the Crusade could not put down."}, -- new
        detail = {"The monastery had once been a center of learning for Lordaeron's priesthood."}, -- new
        -- The monastery's four wings, known by who fell there (L.DungeonSight).
        wings = {
            {bosses = {"Interrogator Vishas", "Bloodmage Thalnos"},
                inside = {"The graveyard behind the monastery was full of dead the Crusade could not put down."},
                detail = {"Interrogator Vishas questioned the Crusade's prisoners in the crypts below the graveyard."}},
            {bosses = {"Houndmaster Loksey", "Arcanist Doan"},
                inside = {"Shelves of old books filled the library, and the Crusade's scholars guarded them."},
                detail = {"Arcanist Doan kept the library, and Houndmaster Loksey and his dogs kept its door."}},
            {bosses = {"Herod"},
                inside = {"Racks of weapons lined the armory, and the Crusade's champions trained among them."},
                detail = {"Herod, the Scarlet Champion, kept the armory, and his men trained there day and night."}},
            {bosses = {"Scarlet Commander Mograine", "High Inquisitor Whitemane", "High Inquisitor Fairbanks"},
                inside = {"The cathedral was the Crusade's heart, and its faithful knelt in rows before the altar."},
                detail = {"Scarlet Commander Mograine commanded a garrison of devoted warriors."}},
        }},
    ["Razorfen Downs"] = {
        why = {"The Scourge had come to the Razorfen, and Amnennar the Coldbringer ruled the Downs.",
            "The quilboar of the Downs had joined the Scourge, and the Barrens were in danger.",
            "A lich, Amnennar the Coldbringer, ruled the quilboar of the Downs, and his mind was bound to the Lich King's."}, -- new
        inside = {"The dead walked among the thorns of the Downs.",
            "Bones and thorns filled the barrows of the Downs.",
            "Quilboar priests and Scourge dead guarded the barrows side by side."}, -- new
        detail = {"Near the entrance stood an idol the quilboar used as an oven, for the people they took from the Barrens."}}, -- new
    ["Uldaman"] = {
        why = {"Uldaman held the secrets of the titans, and diggers of every kind wanted them.",
            "The old titan vault under the Badlands had been opened, and its keepers were waking.",
            "Explorers from Ironforge and Dark Iron diggers both worked at Uldaman, and each wanted the vault first."}, -- new
        inside = {"Stone keepers stood in the halls, older than any kingdom.",
            "Troggs and Dark Irons dug through the vaults of the titans.",
            "Troggs filled the upper halls, and deeper down the stone itself stood up and fought."}, -- new
        detail = {"Explorers searched the buried halls for records of the titans."}}, -- new
    ["Zul'Farrak"] = {
        why = {"The Sandfury trolls held Zul'Farrak, and the goblins of {p:Gadgetzan} wanted things from inside it.", -- fixed
            "Sergeant Bly and his crew had gone into Zul'Farrak, and ended up prisoners on top of the pyramid.", -- fixed
            "Deep in the city lay a sacred pool, and from it the trolls called up a great beast."}, -- new
        inside = {"The sun beat down on the troll city, and the sand hid the dead.",
            "The pyramid of Zul'Farrak rose over the sand, and trolls came up its steps in waves.", -- fixed
            "Sandfury dead rose out of the sand in the graveyard."}, -- new
        detail = {"Gahz'rilla, the beast of the sacred pool, had scales that crackled with energy."}}, -- new
    ["Maraudon"] = {
        why = {"Zaetar, first son of Cenarius, lay in Maraudon, and Princess Theradras kept his remains.", -- fixed
            "A satyr, Lord Vyletongue, had spread his poison through the caves, and Celebras wandered them blind with the curse.", -- fixed
            "The centaur were the children of Zaetar and Theradras, and they had killed their own father."}, -- new
        inside = {"The caves ran green with poison and purple with crystal.",
            "Great roots and waterfalls filled the caves under Desolace.",
            "Deep down, the caves opened onto an underground lake and its falls."}, -- new
        detail = {"Purple and orange crystals marked the branching caverns."}}, -- new
    ["The Temple of Atal'Hakkar"] = {
        why = {"The Atal'ai priests were trying to call the blood god Hakkar into the world, in the temple under the swamp.",
            "The green dragonflight guarded the sunken temple, where the Atal'ai worshipped Hakkar.",
            "Long ago the green dragons had sunk the temple into the swamp, to stop the Atal'ai."}, -- new
        inside = {"The temple lay half drowned in the swamp, and green dragons waited in its deepest hall.", -- fixed
            "Troll priests chanted in the dark water of the temple.",
            "The temple was built in rings, and each ring went further down into the water."}, -- new
        detail = {"A font in the temple held the essence of Eranikus, the green dragon set to guard it."}}, -- new
    ["Blackrock Depths"] = {
        why = {"The Dark Iron dwarves ruled from the depths of Blackrock Mountain, under Emperor Dagran Thaurissan.",
            "Deep in the mountain, the Dark Irons served Ragnaros and schemed against everyone.",
            "King Magni feared for his missing daughter, Moira, and sought answers from a prisoner in the depths.", -- new
            "Long ago the Dark Irons had called Ragnaros into the world, and he had never left."}, -- new
        inside = {"The depths were a whole city of forges and fire.",
            "Lava lit the Dark Iron city from below.",
            "In the middle of the city stood a tavern, the Grim Guzzler."}, -- new
        detail = {"The Dark Iron city filled a volcanic labyrinth beneath Blackrock Mountain."}}, -- new
    ["Blackrock Spire"] = {
        why = {"The Blackrock orcs and the black dragonflight held the spire above the mountain.",
            "Warchief Rend Blackhand ruled the spire, and the black dragons nested above him.",
            "General Drakkisath held the upper spire for Nefarian, and the black dragons bred there."}, -- new
        inside = {"Orcs and dragonkin filled the spire, floor after floor.",
            "Dragon eggs lay in the dark of the upper spire.",
            "The lower spire was a warren of orcs, trolls and ogres."}, -- new
        detail = {"Rend Blackhand rode into battle on the back of a dragon named Gyth."}}, -- new
    ["Dire Maul"] = {
        why = {"The ruins of Eldre'Thalas were divided among ogres, satyrs and the ghosts of the Highborne.",
            "The old highborne city in Feralas had its secrets, and ogres guarded the gate.",
            "Satyrs had taken the eastern halls, and the forest inside had gone wild and wrong."}, -- new
        inside = {"The ruins were overgrown, and some of the old wards still held.", -- fixed
            "Ogres, satyrs and ghosts shared the broken halls."},
        detail = {"The Athenaeum preserved thousands of years of elven records."}}, -- new
    ["Stratholme"] = {
        why = {"Stratholme had fallen to the plague, and its dead still walked the streets.",
            "The city Arthas purged still burned, and the Scourge and the Crusade fought over its ruins.",
            "Baron Rivendare ruled the dead half of the city for the Scourge."}, -- new
        inside = {"Fire and ash filled the streets of Stratholme.",
            "The dead walked in the ruins, and the Scarlet Crusade held out in the other half.",
            "Ghosts of the people Arthas killed still walked the streets."}, -- new
        detail = {"The postboxes of Stratholme still held letters no one would ever collect.", -- new
            "In the dead half of the city, Baron Rivendare held court in the slaughterhouse."}}, -- new
    ["Scholomance"] = {
        why = {"The Cult of the Damned taught necromancy in the Scholomance, under Darkmaster Gandling.",
            "Under Caer Darrow, the Scholomance trained the Scourge's necromancers.",
            "The Barov family had handed Caer Darrow to the Cult of the Damned."}, -- new
        inside = {"The crypts of the school were full of students of death.",
            "Bones, books and cold magic filled the halls.",
            "Students of the cult worked over the dead in the lower rooms."}, -- new
        detail = {"The dead lords of house Barov still walked the halls of the keep they had given away."}}, -- new
    ["Molten Core"] = {
        why = {"Ragnaros the Firelord waited in the Molten Core, deep under Blackrock Mountain.",
            "Long ago Thaurissan had called Ragnaros into the world, and the Firelord made the mountain his."}, -- new
        inside = {"The core was all fire and lava, and elementals rose from it.",
            "Lava crossed the cave floors, and giants of fire and stone walked beside it."}, -- new
        detail = {"Pools of lava lit the caverns deep beneath Blackrock Mountain."}}, -- new
    ["Onyxia's Lair"] = {
        why = {"Onyxia, daughter of Deathwing, nested in the caves of Dustwallow Marsh.",
            "The lair sheltered Onyxia's eggs and the growing strength of her brood."},
        inside = {"Whelps swarmed the lair, and the dragon waited at its heart.",
            "Her eggs lined the side caves, and whelps poured out of them."}, -- new
        detail = {"No one entered the lair without the Drakefire Amulet."}}, -- new
    -- Raids listed in L.dungeons but missing here (all new).
    ["Blackwing Lair"] = {
        why = {"Nefarian, son of Deathwing, bred new dragons at the top of Blackrock Mountain.",
            "In his lair above the spire, Nefarian worked to make dragons of every color at once."},
        inside = {"Broken eggs and failed dragons filled the halls of the lair.",
            "Nefarian's servants and his experiments guarded every hall."},
        detail = {"Black dragons and drakonid guarded Nefarian's halls."}},
    ["Zul'Gurub"] = {
        why = {"The Gurubashi priests had called Hakkar the Soulflayer back into the world, in their old capital in Stranglethorn.",
            "The Zandalar trolls had come to Yojamba Isle to ask for help against Hakkar."},
        inside = {"The jungle had grown back over the troll city, and its high priests had taken the shapes of the old troll gods.",
            "Tigers, bats and raptors served the priests of the jungle city."},
        detail = {"Each high priest of Zul'Gurub had taken the power of a troll god, the bat, the snake, the panther, the tiger or the spider."}},
    ["Ruins of Ahn'Qiraj"] = {
        why = {"The silithid had come out of Ahn'Qiraj, and the Cenarion Circle carried the fight into the ruins."},
        inside = {"Great stone ruins stood half buried in the sand, and the silithid swarmed between them."},
        detail = {"The ruins formed part of the qiraji fortress beyond the Scarab Wall."}},
    ["Ahn'Qiraj Temple"] = {
        why = {"Under the temple, the old god C'Thun was waking, and the qiraji served him."},
        inside = {"The temple went down and down, to where C'Thun lay."},
        detail = {"The twin emperors, Vek'lor and Vek'nilash, ruled the qiraji from the temple."}},
    ["Naxxramas"] = {
        why = {"Kel'Thuzad ruled the necropolis of Naxxramas, floating above the Plaguelands."},
        inside = {"The necropolis was cold, and each of its four wings held one of the Scourge's worst."},
        detail = {"The Scourge gathered inside the floating necropolis, preparing for another assault."}},
}
-- Captured Forever quest text, kept separate from the Classic dungeon roster.
L.dungeonStory['Ruins of Lordaeron'] = {
    setting = 'Forever', source = 'StorageInvestigation/journal-voice/quests_corpus.txt #92401, #92422',
    why = {"Reports from {p:Lordamere Overlook} named Rath'mael as the source of the fog over the ruined capital."},
    inside = {"An unholy fog gave the Scourge cover in the streets and graveyard above the {p:Undercity}."},
    detail = {"Families still searched the overrun graveyard for their missing dead."},
}
L.dungeonStory['The Hall of Thanes'] = {
    setting = 'Forever', source = 'StorageInvestigation/journal-voice/part1_corpus.txt #96393, #96394, #96403',
    why = {"A Dark Iron incursion had disturbed the tombs beneath {p:Old Ironforge}."},
    inside = {"Restless dead stirred in the lower vaults of the {p:Hall of Thanes}."},
    detail = {"Dark Iron invaders had emerged from the deeper caverns in mole machines."},
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
}
L.dungeonStory["Barrow Deeps"] = {
    setting = 'Forever', source = 'https://warcraft.wiki.gg/wiki/Mount_Hyjal_(Forever); LoreForever zone:hyjal (wiki Barrow Deeps)',
    why = {"Beneath Mount Hyjal lay the barrow deeps, where the Druids of the Claw had slept for thousands of years."},
    inside = {"The barrow dens ran deep under the mountain, among the oldest places of the night elves."},
    detail = {"Malfurion Stormrage had woken the sleeping druids here with the Horn of Cenarius, to fight the Legion."},
}
L.dungeonStory["Hyjal Summit"] = {
    setting = 'Forever', source = 'https://warcraft.wiki.gg/wiki/Mount_Hyjal_(Forever); LoreForever zone:hyjal (wiki Battle of Mount Hyjal, Nordrassil)',
    why = {"The summit of Hyjal held Nordrassil, the World Tree, and the Well of Eternity beneath it."},
    inside = {"Nordrassil stood over the summit, still scarred from the last battle of the Third War."},
    detail = {"Archimonde had died at the roots of the tree, and the night elves had lost their immortality with him."},
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
            "Mills and vineyards stood around {p:Goldshire}.", -- new
            "The road from {p:Stormwind} ran through {p:Goldshire} and on to the woods of Eastvale."}, -- new
        stakes = {"Kobolds dug in the mines, and the Defias robbed the roads.",
            "A gnoll called Hogger led the gnolls of the western woods, and the guards could not catch him.", -- new
            "Stormwind's army was far away, and the few guards left could not watch every farm."}}, -- new
    ["Westfall"] = {
        sight = {"Empty farms and scarecrows stood in the dry fields of {p:Westfall}.",
            "Old harvest machines walked the empty fields.", -- new
            "The road ran south past the ruins of {p:Moonbrook}, down to the lighthouse on the coast."}, -- new
        stakes = {"The Defias Brotherhood had driven the farmers out, and the People's Militia held Sentinel Hill.",
            "Stormwind had never paid the stonemasons, and now their Defias took Westfall for themselves.", -- new
            "Gnolls worked with the Defias, and murlocs held the coast."}}, -- new
    ["Redridge Mountains"] = {
        sight = {"Red hills rose around the lake at {p:Lakeshire}.",
            "A long stone bridge crossed the water at {p:Lakeshire}.", -- new
            "Pines grew on the red hills, and the lake lay still below them."}, -- new
        stakes = {"The Blackrock orcs came down from the mountains, and Lakeshire could barely hold.",
            "Gnolls raided the farms around the lake, and the town sent for help.", -- new
            "The Blackrock orcs had taken Stonewatch Keep, and Shadowhide gnolls held the hills around it."}}, -- new
    ["Duskwood"] = {
        sight = {"{p:Duskwood} lay in a night that never lifted, under old and twisted trees.",
            "Lamps burned in {p:Darkshire} at every hour, for the day never came.", -- new
            "Graves filled the cemetery on Raven Hill, and not all of them stayed closed."}, -- new
        stakes = {"The dead walked in its woods, and the Night Watch kept Darkshire lit.",
            "Stormwind had pulled its guards out of Duskwood, and the Night Watch was all that was left.", -- new
            "Worgen hunted in the Brightwood, and the dead rose on Raven Hill."}}, -- new
    ["Stranglethorn Vale"] = {
        sight = {"The jungle of {p:Stranglethorn} was thick and loud, with ruins of troll cities in its green.",
            "Rivers ran through the jungle, down to {p:Booty Bay} in the south.", -- new
            "Broken troll temples stood among the vines."}, -- new
        stakes = {"Trolls, pirates and hunters of every kind fought over the vale.",
            "Hemet Nesingwary's hunters camped in the north, and the jungle beasts paid for it.", -- new
            "The Bloodsail pirates raided the coast and wanted {p:Booty Bay} for themselves.", -- new
            "The Gurubashi trolls had split into tribes, and in Zul'Gurub their blood god stirred."}}, -- new
    ["Dun Morogh"] = {
        sight = {"Snow lay deep on the mountains of {p:Dun Morogh}, around the gates of Ironforge.",
            "Pines and snow ran from {p:Kharanos} up to the gates of {p:Ironforge}.", -- new
            "The gates of {p:Ironforge} were cut into the side of the mountain."}, -- new
        stakes = {"Troggs had come up from below, and the frost trolls pressed in from the hills.",
            "Gnomeregan had fallen, and its people had fled to Ironforge.", -- new
            "Leper gnomes wandered outside the gates of {p:Gnomeregan}."}}, -- new
    ["Loch Modan"] = {
        sight = {"A great dam held back the water of {p:Loch Modan}.",
            "{p:Thelsamar} stood under the hills of the loch.", -- new
            "Farms and hills ran around the water of the loch."}, -- new
        stakes = {"Troggs and Dark Iron dwarves troubled the hills, and the dam had to hold.",
            "Ogres raided {p:Thelsamar} from the hills, led by one called Chok'sul.", -- new
            "Dark Iron saboteurs wanted the Stonewrought Dam brought down."}}, -- new
    ["Wetlands"] = {
        sight = {"The marshes of the {p:Wetlands} stretched between Menethil Harbor and the mountains.",
            "{p:Menethil Harbor} stood on the western shore of the marshes.",
            "The mountain fortress of Grim Batol rose in the east, and no one went near it."}, -- new
        stakes = {"The Dragonmaw orcs had been driven out of Grim Batol, and they camped in the hills below it.", -- fixed
            "Dark Iron dwarves held Dun Modr, in the north of the marsh.", -- new
            "Red dragons still held Grim Batol, and hunted the orcs who had once enslaved them."}}, -- new
    ["Arathi Highlands"] = {
        sight = {"The broken walls of Stromgarde stood over the hills of {p:Arathi}.",
            "The great bridge of Thandol Span crossed south into the {p:Wetlands}.", -- new
            "Stone circles stood on the hills, older than Stromgarde."}, -- new
        stakes = {"The Syndicate and the ogres fought over Stromgarde, and its last loyal men held {p:Refuge Pointe}.", -- fixed
            "The Horde held {p:Hammerfall}, and the two sides fought over the hills.", -- new
            "Witherbark trolls and Boulderfist ogres held the eastern hills."}}, -- new
    ["Hillsbrad Foothills"] = {
        sight = {"Green farms and orchards ran down to the sea at {p:Southshore}.",
            "The old fortress of Durnholde stood over the hills, where Thrall had once been a slave.", -- new
            "Orchards and farms ran from the hills of {p:Tarren Mill} down to the coast."}, -- new
        stakes = {"Tarren Mill and Southshore watched each other across the hills, and neither forgave.",
            "The Syndicate held Durnholde and raided the farms below.", -- new
            "The Forsaken raided the farms of Hillsbrad, and the farmers took up arms."}}, -- new
    ["Alterac Mountains"] = {
        sight = {"Snow and ruins covered the {p:Alterac Mountains}.",
            "The city of Dalaran stood inside a great violet dome, on the shore of the lake.", -- new
            "Ruins of the old Alterac city lay deep in the snow."}, -- new
        stakes = {"The Syndicate and the ogres held what remained of the kingdom of Alterac.",
            "The wizards of Dalaran worked behind their dome, and let no one in.", -- new
            "The Syndicate were the old nobles of Alterac, turned thieves."}}, -- new
    ["Silverpine Forest"] = {
        sight = {"Tall pines and cold mist covered {p:Silverpine}, down to the shore of the lake.",
            "{p:Pyrewood Village} looked like any human town by day.", -- new
            "Shadowfang Keep stood on its hill above the pines."}, -- new
        stakes = {"Worgen hunted in the pines, and the Forsaken held the Sepulcher against them.",
            "Arugal's curse had made worgen of the people of Pyrewood, and they turned at night.", -- new
            "Dalaran's wizards were at work in Ambermill, and the Forsaken wanted to know why.", -- new
            "Rot hide gnolls carried corpses from Tirisfal across the lake to Fenris Isle."}}, -- new
    ["Tirisfal Glades"] = {
        sight = {"Grey fields and dead trees spread across the glades of {p:Tirisfal}.",
            "The ruins of Lordaeron stood over the glades, and the {p:Undercity} lay beneath them.", -- new
            "The windmills of Agamand Mills stood over empty fields."}, -- new
        stakes = {"The Forsaken held the glades, and the Scarlet Crusade burned what it called unclean.",
            "The Scourge were trying to make a base at the Agamand Mills, to strike deeper into Tirisfal.", -- new
            "The Forsaken rose from their graves at {p:Deathknell}, and each was sent out to fight."}}, -- new
    ["Western Plaguelands"] = {
        sight = {"The farms of the {p:Western Plaguelands} were sick, and the grain was black.",
            "The towers of {p:Andorhal} stood in ruins, and the Scourge walked its streets.", -- new
            "An island keep, Caer Darrow, stood in the lake to the south."}, -- new
        stakes = {"The Scourge held the land, and the Argent Dawn fought to cleanse it.",
            "A lich held {p:Andorhal}, and the Argent Dawn meant to drive him out.", -- new
            "Under Caer Darrow, the Scholomance trained the Scourge's necromancers."}}, -- new
    ["Eastern Plaguelands"] = {
        sight = {"Rot and ash covered the {p:Eastern Plaguelands}, as far as the eye could see.",
            "The trees had turned red and strange, and the rivers ran foul.", -- new
            "{p:Light's Hope Chapel} stood alone on its hill in the east."}, -- new
        stakes = {"The Scourge ruled there, from Stratholme to Naxxramas in the sky.",
            "The Argent Dawn held {p:Light's Hope Chapel} against the dead.", -- new
            "The Scarlet Crusade held Tyr's Hand, and trusted no one."}}, -- new
    ["The Hinterlands"] = {
        sight = {"Wooded hills and troll ruins filled the {p:Hinterlands}.",
            "Gryphons flew over {p:Aerie Peak}, home of the Wildhammer dwarves.", -- new
            "The troll city of Jintha'Alor rose in terraces over the hills."}, -- new
        stakes = {"The Witherbark and Vilebranch trolls held the old ruins, and the Wildhammer held Aerie Peak.", -- fixed
            "The Revantusk trolls on the coast had broken with the others and joined the Horde.", -- new
            "Green dragons had come to the Seradane, and they did not welcome visitors."}}, -- new
    ["Badlands"] = {
        sight = {"The {p:Badlands} were dry, cracked and red, with dragon bones in the dust.",
            "The old doors of Uldaman were cut into the cliffs in the north.", -- new
            "{p:Kargath} stood in the western cliffs, and dry canyons ran east from it."}, -- new
        stakes = {"Ogres, Dark Irons and dragons all laid claim to the waste.",
            "Black dragons nested in Lethlor Ravine.", -- new
            "Diggers from every side worked at Uldaman, looking for the titans' secrets."}}, -- new
    ["Searing Gorge"] = {
        sight = {"Fire and slag filled the {p:Searing Gorge}, under Blackrock Mountain.",
            "The Cauldron, a great pit of slag and fire, lay at the heart of the gorge.", -- new
            "The way into Blackrock Mountain lay at the south end of the gorge."}, -- new
        stakes = {"The Dark Iron dwarves worked their slaves in the gorge.",
            "The Thorium Brotherhood had broken from the Dark Irons and made camp on the edge of the gorge.", -- new
            "Fire elementals walked the gorge, called up by the Dark Irons."}}, -- new
    ["Burning Steppes"] = {
        sight = {"Ash fell on the {p:Burning Steppes}, and the ground still smoked.",
            "The black peak of Blackrock Mountain rose over the steppes.", -- new
            "Lava ran in cracks through the dark ground."}, -- new
        stakes = {"The Blackrock orcs and the black dragonflight ruled the steppes.",
            "The Blackrock orcs gathered at their stronghold, and the Alliance watched them from {p:Morgan's Vigil}.", -- new
            "Black dragonkin held the hills to the south."}}, -- new
    ["Swamp of Sorrows"] = {
        sight = {"Mist and dark water lay over the {p:Swamp of Sorrows}.",
            "The sunken temple of the Atal'ai lay drowned in the heart of the swamp.", -- new
            "The orc fortress of {p:Stonard} stood among the reeds."}, -- new
        stakes = {"Below the swamp, the Atal'ai called on their blood god.",
            "{p:Stonard} was the Horde's hold in the east, far from any help.", -- new
            "Green dragons guarded the temple, to keep the Atal'ai from their god."}}, -- new
    ["Blasted Lands"] = {
        sight = {"Red earth and ruin stretched to the {p:Dark Portal}.",
            "Bare red rock stretched south from {p:Nethergarde Keep}.", -- new
            "The Dark Portal stood at the end of the valley, dark and silent."}, -- new
        stakes = {"Demons still walked the {p:Blasted Lands}, and the mages of Nethergarde kept watch on the Portal.", -- fixed
            "The orcs had first come into the world here, and the land had never healed.", -- new
            "Dreadmaul ogres held the hills."}}, -- new
    ["Deadwind Pass"] = {
        sight = {"A dead pass wound between bare mountains, past the tower of Karazhan.", -- fixed
            "Karazhan, the tower of Medivh, stood empty in the pass.", -- new
            "Nothing grew in the pass, and the trees stood grey and bare."}, -- new
        stakes = {"The tower of Karazhan was shut, and something still moved inside.", -- fixed
            "Ogres held the pass, and beyond it lay the Swamp of Sorrows."}}, -- new
    ["Teldrassil"] = {
        sight = {"The great tree {p:Teldrassil} rose from the sea, with forests on its boughs.",
            "Paths ran under the leaves to {p:Dolanaar}.", -- new
            "{p:Darnassus} stood high in the boughs, among pools and white towers."}, -- new
        stakes = {"Even here, corruption had crept into the woods of the night elves.",
            "The Gnarlpine furbolgs had turned wild, and no one yet knew why."}}, -- new
    ["Darkshore"] = {
        sight = {"Old night elf ruins lay along the dark coast of {p:Darkshore}.",
            "Mist hung over the water at {p:Auberdine}.", -- new
            "The Cliffspring River ran down to the sea at the Mist's Edge."}, -- new
        stakes = {"The Blackwood furbolgs had gone mad, and the Cliffspring River was turning foul.", -- fixed
            "Naga came ashore along the coast.", -- new
            "{p:Auberdine} was the only town on the long coast, and it had few hands to spare."}}, -- new
    ["Ashenvale"] = {
        sight = {"The great trees of {p:Ashenvale} stood old and quiet, and the Sentinels watched them.",
            "{p:Astranaar} stood on its island in the lake, in the middle of the forest.", -- new
            "Moonwells stood in the clearings, and the night elves kept them clean."}, -- new
        stakes = {"The Horde cut the trees, and the night elves fought them for every one.",
            "Satyrs haunted the eastern woods, near the borders of Felwood.", -- new
            "The furbolgs of Ashenvale had turned on the night elves, their old friends."}}, -- new
    ["Stonetalon Mountains"] = {
        sight = {"Peaks and cliffs rose over the {p:Stonetalon Mountains}, and the great peak stood over them all.", -- fixed
            "Where the goblins had been, the forest was stumps and ash.", -- new
            "{p:Sun Rock Retreat} stood high on a ridge, out of the wind."}, -- new
        stakes = {"The Venture Company logged the mountains bare, and the druids could not stop them.",
            "The Charred Vale had burned, and fire elementals walked it.", -- new
            "Harpies held the high cliffs, and kobolds dug in the mines."}}, -- new
    ["The Barrens"] = {
        sight = {"Dry grass and lone trees stretched across {p:the Barrens}, under a wide sky.",
            "Kodo bones lay in the dry grass, and zhevra ran past them.", -- new
            "The oases of the Barrens were few, and every one was fought over."}, -- new
        stakes = {"Centaur and quilboar raided the plains, and the Crossroads held the middle of it all.",
            "Deviate beasts had come out of the Wailing Caverns and fouled the oases.", -- new
            "The Alliance held Northwatch on the coast, and the Kolkar centaur raided the caravans."}}, -- new
    ["Durotar"] = {
        sight = {"{p:Durotar} was red earth and thorn, around the walls of Orgrimmar.",
            "The sea broke on the rocks below {p:Razor Hill}.", -- new
            "Scorpids and boars ran over the red ground."}, -- new
        stakes = {"The orcs had made a home of the hard land, and they meant to keep it.",
            "The Burning Blade hid in the caves of Skull Rock and Dustwind.", -- new
            "Kul Tiran marines held Tiragarde Keep on the coast.", -- new
            "Kolkar centaur raided from the north."}}, -- new
    ["Mulgore"] = {
        sight = {"Green plains and mesas rolled under the wind of {p:Mulgore}.",
            "The mesas of {p:Thunder Bluff} rose over the plains, with lifts to their tops.", -- new
            "The Red Rocks, where the tauren bury their dead, stood above the plains."}, -- new
        stakes = {"The tauren kept the plains, and the Venture Company wanted the land.", -- fixed
            "Palemane gnolls raided the plains, and dwarves dug at the Bael'dun site."}}, -- new
    ["Thousand Needles"] = {
        sight = {"Tall stone spires rose from the canyons of {p:Thousand Needles}.",
            "Salt flats lay white at the east end of the canyons.", -- new
            "Rope bridges ran between the mesas at {p:Freewind Post}."}, -- new
        stakes = {"Centaur held the canyons, and the goblins raced on the salt flats below.",
            "The Grimtotem clan had turned against the other tauren, and camped among the needles."}}, -- new
    ["Desolace"] = {
        sight = {"{p:Desolace} was grey and empty, and bones lay in its valleys.",
            "Great kodo bones lay in the Kodo Graveyard, where the old beasts came to die.", -- new
            "The caves of {p:Maraudon} opened in the hills to the south."}, -- new
        stakes = {"The centaur clans fought each other for the waste.",
            "Demons of the Legion held Mannoroc Coven.", -- new
            "The centaur held Maraudon holy, for their father Zaetar lay there."}}, -- new
    ["Dustwallow Marsh"] = {
        sight = {"Fog and marsh surrounded {p:Theramore}, on the edge of the sea.",
            "{p:Brackenwall Village} stood in the northern marsh.", -- new
            "Crocolisks lay in the shallows, waiting."}, -- new
        stakes = {"Onyxia hid in the marsh, and the black dragons worked in secret.",
            "{p:Theramore} and the Horde kept an uneasy peace in the marsh.", -- new
            "Stonemaul ogres held the south of the marsh."}}, -- new
    ["Feralas"] = {
        sight = {"Rain and giant trees filled the jungle of {p:Feralas}.",
            "The ruins of Dire Maul stood deep in the forest, broken and overgrown.", -- new
            "{p:Feathermoon Stronghold} stood on an island off the coast."}, -- new
        stakes = {"Gordunni ogres held the ruins, and the Grimtotem camped in the hills.",
            "Gnolls and ogres raided the forest roads."}}, -- new
    ["Tanaris"] = {
        sight = {"Sand and sun covered {p:Tanaris}, from the goblin town to the sea.",
            "The walls of {p:Gadgetzan} stood alone in the sand.", -- new
            "The pyramid of Zul'Farrak rose in the north."}, -- new
        stakes = {"Trolls, pirates and the silithid all troubled the desert.",
            "Wastewander bandits robbed every caravan they could.", -- new
            "Southsea pirates held the southern coast."}}, -- new
    ["Un'Goro Crater"] = {
        sight = {"Great beasts walked the steaming jungle of {p:Un'Goro Crater}.",
            "Hot springs and crystal pylons stood in the jungle of the crater.", -- new
            "A volcano, Fire Plume Ridge, rose from the heart of the crater."}, -- new
        stakes = {"Old titan machines slept in the crater, and the silithid dug beneath it.",
            "Great beasts hunted in the crater, and the camp at {p:Marshal's Refuge} was small."}}, -- new
    ["Azshara"] = {
        sight = {"Ruins of the old night elf empire lay on the coast of {p:Azshara}.",
            "The trees of {p:Azshara} were red and gold, as if it were always autumn.", -- new
            "Stairs of the old elves ran down into the sea."}, -- new
        stakes = {"Naga and satyrs held the ruins of Azshara's old land.",
            "Azuregos, a blue dragon, guarded the ruins of the old city."}}, -- new
    ["Felwood"] = {
        sight = {"The trees of {p:Felwood} were twisted and sick, and the water ran green.",
            "Jaedenar, once a night elf town, was full of demons.", -- new
            "The Emerald Sanctuary was the one clean place in the forest."}, -- new
        stakes = {"The Legion's corruption had poisoned the forest to its roots.",
            "The Shadow Council held Jaedenar, and served the demons openly.", -- new
            "Deadwood furbolgs, sick with the corruption, attacked anyone who passed."}}, -- new
    ["Winterspring"] = {
        sight = {"Snow covered the quiet valleys of {p:Winterspring}.",
            "The goblin town of {p:Everlook} stood in the middle of the snow, loud and warm.", -- new
            "Hot springs steamed in the snow of the valleys."}, -- new
        stakes = {"The Winterfall furbolgs had turned savage, and the blue dragons watched from above.",
            "Demons held Darkwhisper Gorge in the south.", -- new
            "Frostsabers and chimaerae hunted in the snow."}}, -- new
    ["Moonglade"] = {
        sight = {"{p:Moonglade} was green and still, a place the druids kept.", -- fixed
            "Lake Elune'ara lay at the heart of the glade.", -- new
            "Nighthaven, the druids' town, stood by the lake."}, -- new
        stakes = {"No one fought in Moonglade. The druids made sure of it.",
            "Druids of every people came to Moonglade to train.", -- new
            "The Timbermaw furbolgs held the tunnels into the glade, and let only friends pass."}}, -- new
    ["Silithus"] = {
        sight = {"Hives and sand covered {p:Silithus}, and the wind never stopped.", -- fixed
            "The Scarab Wall stood in the south, holding shut the gates of Ahn'Qiraj.", -- new
            "Silithid hives rose from the sand, taller than any building."}, -- new
        stakes = {"The silithid swarmed from Ahn'Qiraj, and the Cenarion Circle held them back.",
            "The Twilight's Hammer camped among the dunes, working for their own ends.", -- new
            "A thousand years ago, the Scarab Wall had been raised to keep the silithid in."}}, -- new
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
        "Boats left {p:Powderfuse Port} for {p:Steamwheedle Port}, across the sea in {p:Tanaris}."},
    stakes = {"The Brotherhood of the Horse held Farholde Keep, and fought to win back land Stormwind had given up in the First War.",
        "The Twilight's Hammer held the ruins of Sunnyglade, and its ogres held {p:Krol'dok Stronghold}.",
        "The Horde kept outposts at Rog'mar and Bolder'ok, where ogres who had left the Twilight's Hammer now fought beside it."}}
L.zoneStory["The Riverglades"] = L.zoneStory["Riverglades"]
L.zoneStory["Shen'dralas"] = {setting = "Forever",
    sight = {"Highborne ruins stood among the crags, south of Desolace.",
        "The way in from Desolace ran through the Valley of Bones, past two great skeletons slumped against the cliffs."},
    stakes = {"The Magram centaur fought along their front, and the Bristleback quilboar held a fortified retreat.",
        "Neither Horde nor Alliance held the crags, and outcasts hid there from both."}}
L.zoneStory["Mount Hyjal"] = {setting = "Forever",
    sight = {"Nordrassil, the World Tree, stood over the summit, still scarred by the last battle of the Third War.",
        "Forest covered the slopes of the mountain, sacred to the night elves and the Wild Gods before them."},
    stakes = {"Archimonde had died at the roots of the World Tree, and the night elves had paid for it with their immortality.",
        "Malfurion Stormrage had sealed the mountain off after the war, and the tree had been slowly healing."}}
L.zoneStory["Darkspear Islands"] = {setting = "Forever",
    sight = {"The isles lay off the coast of Kalimdor, ceremonial ground of Vol'jin's trolls.",
        "The fighting ran from the camp and the old ruins to the abandoned tower and Shipwreck Cove."},
    stakes = {"The Horde fought for the isles out of an old debt to the Darkspear, who had stood with Thrall when he had little else.",
        "The Alliance wanted a foothold off Kalimdor's coast, and a blow at one of the Horde's proudest peoples."}}
L.zoneStory["Zephras Isle"] = L.zoneStory["Zephras Isle"] or {setting = "Forever",
    sight = {"Zephras floated high in Skywall, the elemental plane of air, far above the world below.",
        "An elder tree stood in the center of Thendal Village, and the greatfather tree rose just west of it."},
    stakes = {"The air elementals who had shared the island were gone, and the magic holding it aloft was fading.",
        "The Al'Aketh cult worshipped Al'Akir the Windlord, and its zealots grew bolder by the day."}}

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
        after = {"The trail ran from a cheese shop in {p:Stormwind} to a tavern in {p:Menethil Harbor}, and the missing diplomat turned out to be the king himself.",
            "Private Hendel had helped the Defias get a man aboard the king's ship, and Jaina's soldiers took him to {p:Theramore} for questioning."},
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

-- Zone stories. A sight or stake that names its zone, or repeats a name another line already says.
L.zoneStory["Moonglade"].sight[1] = "The glade was green and still, a place the druids kept."
L.zoneStory["The Barrens"].sight[3] = "The oases were few, and every one was fought over."
L.zoneStory["Darkshore"].stakes[1] = "The Blackwood furbolgs had gone mad, and the river was turning foul."
L.zoneStory["Wetlands"].stakes[3] = "Red dragons still held the fortress, and hunted the orcs who had once enslaved them."
-- EXTEND: what you can see from there (true from the coast at Auberdine and from Sen'jin).
Extend(L.zoneStory["Darkshore"].sight, {"Across the water, {p:Teldrassil} rose out of the sea."})
Extend(L.zoneStory["Darkshore"].stakes, {"Dwarves of the Explorers' League dug among the old ruins of the coast."})
Extend(L.zoneStory["Durotar"].stakes, {"The witch doctor Zalazane held the Echo Isles, off the coast, and hexed the Darkspear to his side."})

-- Archaedas: the epithet "the ancient stone watcher" and the consequence "The stone watcher of
-- Uldaman was still." came one after the other. The consequence changes.
if L.bosses["Archaedas"] then L.bosses["Archaedas"].after = "The ancient stone watcher no longer barred the way." end
-- NEW FIELD L.bosses[...].afterMore (engine hook: a lord's consequence already said for this day
-- in another of the player's books takes one of these instead; CRITIQUE8 fix 3).
local afterMore = {
    ["Mutanus the Devourer"] = {"The devourer from Naralex's nightmare lay defeated."},
    ["Edwin VanCleef"] = {"Westfall was rid of Edwin VanCleef.", "The Defias ship had lost its master."},
    ["Archaedas"] = {"The ancient stone watcher no longer barred the way."},
    ["Taragaman the Hungerer"] = {"The felguard beneath Orgrimmar had fallen."},
    ["Archmage Arugal"] = {"Silverpine was rid of Arugal, for now."},
}
for boss, lines in pairs(afterMore) do if L.bosses[boss] then L.bosses[boss].afterMore = lines end end

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

