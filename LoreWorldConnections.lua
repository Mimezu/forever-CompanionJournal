local _, A = ...
-- Compact geography and battlefield notes grounded in Classic-era sources.
local V = "StorageInvestigation/journal-voice/review/corpus_vanilla_quests.txt"
local ORGRIMMAR = "https://worldofwarcraft.blizzard.com/en-us/news/23156369/wow-classic-city-tour-orgrimmar"
local UNDERCITY = "https://worldofwarcraft.blizzard.com/en-us/news/23149528/wow-classic-city-tour-undercity"
local TRAVEL = "https://worldofwarcraft.blizzard.com/en-us/news/23156366/wow-classic-getting-around-azeroth"
local WSG_AV = "https://worldofwarcraft.blizzard.com/en-us/news/23237900/wow-classic-warsong-gulch-and-alterac-valley-now-live"
local AB = "https://worldofwarcraft.blizzard.com/en-us/news/23320961/wow-classic-arathi-basin-now-available"
local AQ_TIMELINE = "https://worldofwarcraft.blizzard.com/en-us/story/timeline/chapter-9"
local SCOURGE_EVENT = "https://worldofwarcraft.blizzard.com/en-us/news/23586607/wow-classic-the-scourge-invasion-has-begun"

local function Note(id, title, kind, body, sources, names, related)
    return {id = id, title = title, kind = kind, body = body, sources = sources,
        names = names, related = related}
end

A.RegisterLoreNotes({
    {id = "city:dalaran",
        title = "Dalaran",
        kind = "City",
        body = "Dalaran was the mage-city of the Kirin Tor, standing in the Alterac Mountains. Its towers had fallen during the Third War, when Archimonde destroyed the city with a spell. By the time of the adventures in Lordaeron's ruins, a vast magical dome enclosed its heart, while wizards and bound elementals patrolled the ruined outskirts.\n\nThe barrier kept the city's interior out of view. In Tarren Mill, Magus Wordeen Voidglare repeated competing explanations: protection from war, or seclusion for magical study and plotting. His own interest lay in treasures still hidden outside the dome. Even broken, the city drew intruders seeking the power its mages had left behind.",
        sources = {"https://warcraft.wiki.gg/wiki/Dalaran", "https://warcraft.wiki.gg/wiki/The_Destruction_of_Dalaran_(WC3_Undead)", "https://classicdb.ch/?quest=545"},
        names = {},
        related = {"faction:kirin-tor", "event:fall-dalaran", "event:founding-dalaran"},
        setting = "Classic / Forever"},
    Note("place:greymane-wall", "Greymane Wall", "Place",
        "The Greymane Wall stands in southern Silverpine Forest, on the border of the kingdom of Gilneas.\n\nValdred, whom Raleigh of the Undercity names as the murderer of his wife, Deliah, was last heard of at the wall, trying to flee into Gilneas.",
        {"https://warcraft.wiki.gg/wiki/Greymane_Wall", V .. " (quest 530)"}, {"The Greymane Wall"}, {"region:gilneas", "npc:raleigh"}),
    Note("region:gilneas", "Gilneas", "Region",
        "The kingdom of Gilneas lies beyond the Greymane Wall in southern Silverpine Forest.\n\nValdred, whom Raleigh of the Undercity names as the murderer of his wife, Deliah, was last heard of trying to flee into Gilneas.",
        {"https://warcraft.wiki.gg/wiki/Gilneas", V .. " (quest 530)"}, {"Kingdom of Gilneas"}, {"place:greymane-wall", "npc:raleigh"}),
    Note("place:valley-of-wisdom", "Valley of Wisdom", "Place",
        "Within Orgrimmar, the Valley of Wisdom shelters Grommash Hold and the city's shaman trainers; Asoran's Market supplies reagents.",
        {ORGRIMMAR}),
    Note("place:rogues-quarter", "Rogues' Quarter", "Place",
        "Within Undercity, the Rogues' Quarter gathers rogue trainers and poison supplies alongside engineering and leatherworking services.",
        {UNDERCITY}, {"Rogues’ Quarter"}, {"place:undercity"}),
    Note("place:talonbranch-glade", "Talonbranch Glade", "Place",
        "Talonbranch Glade was an Alliance outpost in northern Felwood. Its flight route, supplies, and trainers offered a foothold for travelers working through the corrupted forest and toward Timbermaw territory.",
        {TRAVEL, "https://www.wowhead.com/classic/guide/felwood-gold-farming-classic-wow", "https://classic-wow-archive.fandom.com/wiki/Talonbranch_Glade"}),
    Note("battleground:warsong-gulch", "Warsong Gulch", "Battleground",
        "Warsong Gulch brought the Warsong Outriders and Silverwing Sentinels into conflict over Ashenvale's timber, with the Alliance defending the forest and the Horde demanding access to its lumber.",
        {WSG_AV, V .. " (quest 8429)"}, nil, {"faction:warsong-outriders", "faction:silverwing"}),
    {id = "battleground:alterac-valley",
        title = "Alterac Valley",
        kind = "Battleground",
        body = "Alterac Valley is the mountain battlefield between the Frostwolf Clan and the Stormpike Guard. The dwarven expedition seeks ancient artifacts; the Frostwolves see its advance as an invasion of their home. Drek'Thar commands from Frostwolf Keep in the south, while Vanndar Stormpike holds Dun Baldar in the north.\n\nBetween their strongholds, armies fight for towers, graveyards and the mines that supply the war. Irondeep and Coldtooth hold stores cached by both sides, making control of the workings valuable beyond their minerals. Each army aims to break the opposing general's command, but the struggle also depends on the soldiers who gather supplies and hold the ground between them.",
        sources = {"https://classicdb.ch/?quest=7141", "https://classicdb.ch/?quest=7142", "https://classicdb.ch/?quest=7122", "https://worldofwarcraft.blizzard.com/en-us/news/23237900/wow-classic-warsong-gulch-and-alterac-valley-now-live"},
        names = {},
        related = {"faction:frostwolf", "faction:stormpike", "region:416c7465726163204d6f756e7461696e73"},
        setting = "Classic / Forever",
        autoLink = true},
    Note("battleground:arathi-basin", "Arathi Basin", "Battleground",
        "At Arathi Basin, the League of Arathor and the Defilers fight over strategic resource sites. Each side seeks to hold the basin's bases and secure supplies for its war effort.",
        {AB}, nil, {"faction:arathor", "faction:defilers"}),
    Note("region:kalimdor", "Kalimdor", "Region",
        "Ships carried travelers between Ratchet in Kalimdor and Booty Bay in the Eastern Kingdoms; zeppelins also crossed the Great Sea, linking Orgrimmar and Undercity.",
        {TRAVEL}, nil, {"region:eastern-kingdoms"}),
    Note("region:eastern-kingdoms", "Eastern Kingdoms", "Region",
        "Booty Bay opened the Eastern Kingdoms to the sea route from Ratchet, while zeppelins tied Undercity to Orgrimmar across the Great Sea.",
        {TRAVEL}, nil, {"region:kalimdor"}),
    Note("place:emerald-dream", "Emerald Dream", "Place",
        "The sacred Relics of Wakening were needed to break the Druids of the Talon's hibernation ritual before they were trapped in the Emerald Dream forever.",
        {V .. " (quest 483)"}, nil, {"place:banethil"}),
    Note("place:twisting-nether", "Twisting Nether", "Place",
        "Drusilla cautioned a young practitioner that dealings with creatures from the Twisting Nether could invite corruption; patience and prudence mattered, but ambition should not be repressed.",
        {V .. " (quest 3105)"}),
    Note("event:ahnqiraj-war-effort", "Ahn'Qiraj War Effort", "Event",
        "As the qiraji stirred behind the Scarab Wall, Alliance and Horde collectors gathered supplies for the coming war. Their shared effort prepared both factions for a campaign against Ahn'Qiraj.",
        {AQ_TIMELINE, V .. " (quest 8792)", V .. " (quest 8795)"}, nil,
        {"place:ahnqiraj", "faction:alliance", "faction:horde"}),
    Note("event:gates-of-ahnqiraj", "Opening of the Gates of Ahn'Qiraj", "Event",
        "The Alliance and Horde joined as the Might of Kalimdor under Varok Saurfang. Their force opened the gates of Ahn'Qiraj and laid siege to its ruins and temple.",
        {AQ_TIMELINE}, {"Gates of Ahn'Qiraj", "Might of Kalimdor", "The Might of Kalimdor"},
        {"event:ahnqiraj-war-effort", "event:shifting-sands", "place:ahnqiraj",
            "dungeon:ahnqiraj-ruins", "dungeon:ahnqiraj-temple"}),
    Note("event:scourge-invasion", "Scourge Invasion", "Event",
        "The Scourge returned in force, and floating necropolises shadowed Horde and Alliance lands. The Argent Dawn rallied defenders against the invasion and the summoning circles that supported the necropolises. The assault reached cities and strongholds as well as the open country.",
        {SCOURGE_EVENT, V .. " (quest 9153)", V .. " (quest 9154)", V .. " (quest 9085)"},
        nil, {"faction:argent-dawn", "faction:scourge", "place:lights-hope", "dungeon:naxxramas"}),
})
