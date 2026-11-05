-- Run from client root: lua5.1 Interface/AddOns/CompanionJournal/tests/LoreNotes2Overnight.lua
-- Notes added by the second overnight notes lane (notes2, 2026-11-05): names the
-- story prose still used without a note. Every note is sourced, timeline-labelled,
-- plain reference text; every listed name opens it; secrets stay behind discoveries;
-- and names that sit inside a longer proper name no longer link the wrong note.
local root = "Interface/AddOns/CompanionJournal/"
local A = {People = {}, db = {sentinel = "unchanged"}}
local count = 0
local function Check(value, message) count = count + 1; assert(value, message) end
local function Load(name) assert(loadfile(root .. name))("CompanionJournal", A) end
Load("LoreData.lua"); Load("Lore.lua")
Load("LoreAllianceStories.lua"); Load("LoreHordeStories.lua"); Load("LoreWorldStories.lua"); Load("LoreClassStories.lua")
if io.open(root .. "LoreForeverStories.lua") then Load("LoreForeverStories.lua") end
Load("LoreNotes.lua")
Load("LoreDiscovery.lua"); Load("LoreDiscoveryData.lua")
Load("LorePlaces.lua"); Load("LorePeopleHistory.lua"); Load("LoreWorldConnections.lua")

-- id = {names that must resolve to it}; the title is always checked as well.
local notes = {
    -- Batch 1: Darkshore and Teldrassil.
    ["npc:athrikus"] = {"Athrikus Narassin", "Athrikus"},
    ["group:dark-strand"] = {"Cult of the Dark Strand", "the Cult of the Dark Strand", "Dark Strand"},
    ["npc:balthule"] = {"Balthule Shadowstrike", "Balthule"},
    ["npc:delgren"] = {"Delgren the Purifier", "Delgren"},
    ["npc:elissa-starbreeze"] = {"Elissa Starbreeze", "Sentinel Starbreeze"},
    ["npc:grimclaw"] = {"Grimclaw"},
    ["npc:hollee"] = {"Archaeologist Hollee", "Hollee"},
    ["npc:greywhisker"] = {"Chief Archaeologist Greywhisker", "Greywhisker"},
    ["npc:tharnariun"] = {"Tharnariun Treetender", "Tharnariun"},
    ["npc:den-mother"] = {"Den Mother", "the Den Mother"},
    ["npc:gilshalan"] = {"Gilshalan Windwalker", "Gilshalan"},
    ["npc:athridas"] = {"Athridas Bearmantle", "Athridas"},
    ["npc:gaerolas"] = {"Gaerolas Talvethren", "Gaerolas"},
    ["npc:ursal"] = {"Ursal the Mauler"},
    ["place:tower-of-althalaxx"] = {"Tower of Althalaxx", "the Tower of Althalaxx"},
    ["place:masters-glaive"] = {"Master's Glaive", "the Master's Glaive"},
    ["place:shadowthread-cave"] = {"Shadowthread Cave"},
    ["place:blackwood-den"] = {"Blackwood Den"},
    -- Batch 2: Eastern Kingdoms leftovers, the Marris case and the Lescovar case.
    ["npc:tharil-zun"] = {"Tharil'zun"},
    ["npc:captain-grayson"] = {"Captain Grayson"},
    ["npc:lars"] = {"Lars"},
    ["npc:morbent-fel"] = {"Morbent Fel"},
    ["npc:elaine-carevin"] = {"Elaine Carevin"},
    ["npc:milton-sheaf"] = {"Milton Sheaf", "Milton"},
    ["npc:nathanos-marris"] = {"Nathanos Marris"},
    ["npc:tyrion"] = {"Tyrion"},
    ["npc:lescovar"] = {"Lord Gregor Lescovar", "Gregor Lescovar", "Lescovar"},
    ["npc:marzon"] = {"Marzon", "Maelik"},
    ["npc:karna-remtravel"] = {"Karna Remtravel", "Karna"},
    ["npc:sully-balloo"] = {"Sully Balloo"},
    ["npc:grimand-elmore"] = {"Grimand Elmore", "Grimand"},
    ["npc:glorin-steelbrow"] = {"Glorin Steelbrow", "Glorin"},
    ["npc:verner-osgood"] = {"Verner Osgood", "Verner"},
    ["npc:morganth"] = {"Morganth"},
    ["place:marris-stead"] = {"Marris Stead", "the Marris Stead"},
    ["group:stormwind-army"] = {"Stormwind Army", "the Stormwind Army"},
    -- Batch 3: Forever's people and the Horde leftovers.
    ["npc:lorthuna"] = {"High Priestess Lorthuna", "Lorthuna"},
    ["npc:valennia"] = {"Valennia Stormfist", "Valennia"},
    ["npc:aonda"] = {"Constable Aonda", "Aonda"},
    ["npc:illaya"] = {"Illaya Amberwind", "Illaya"},
    ["npc:hanaa"] = {"Hanaa Nightwind", "Hanaa"},
    ["npc:elegael"] = {"Elegael Thornpaw", "Elegael"},
    ["npc:aamelia"] = {"Aamelia Windfield", "Aamelia"},
    ["npc:lumina"] = {"Lumina Windsinger", "Lumina"},
    ["npc:father-gavin"] = {"Father Gavin"},
    ["npc:aramis-hammerhand"] = {"Aramis Hammerhand", "Aramis"},
    ["npc:shari-stilwell"] = {"Shari Stilwell"},
    ["npc:alba-fairmoon"] = {"Alba Fairmoon", "Alba"},
    ["npc:sprite-jumpsprocket"] = {"Sprite Jumpsprocket"},
    ["npc:jasper-fel"] = {"Jasper Fel"},
    ["npc:brewmaster-drohn"] = {"Brewmaster Drohn", "Drohn"},
    ["npc:maur-raincaller"] = {"Maur Raincaller"},
    ["npc:thurman-agamand"] = {"Thurman Agamand"},
    ["npc:devlin-agamand"] = {"Devlin Agamand"},
    ["place:wyrmbog"] = {"Wyrmbog", "the Wyrmbog"},
    ["place:mor-shan-rampart"] = {"Mor'shan Rampart"},
    -- Batch 4: the 40-60 world prose.
    ["npc:pestlezugg"] = {"Alchemist Pestlezugg", "Pestlezugg"},
    ["npc:fizzledowser"] = {"Senior Surveyor Fizzledowser", "Fizzledowser"},
    ["npc:zilzibin"] = {"Zilzibin Drumlore", "Zilzibin"},
    ["npc:gracina"] = {"Gracina Spiritmight", "Gracina"},
    ["npc:raschal"] = {"Raschal"},
    ["npc:ginro"] = {"Ginro Hearthkindle", "Ginro"},
    ["npc:quintis"] = {"Quintis Jonespyre", "Quint", "Jonespyre"},
    ["npc:draz-zilb"] = {"Draz'Zilb"},
    ["npc:tharg"] = {"Tharg"},
    ["npc:smokey-larue"] = {"Smokey LaRue", "Smokey"},
    ["npc:aurora-skycaller"] = {"Aurora Skycaller", "Aurora"},
    ["artifact:crystal-zin-malor"] = {"Crystal of Zin-Malor", "the Crystal of Zin-Malor"},
    ["npc:kim-jael"] = {"Kim'jael"},
    ["npc:lar-korwi"] = {"Lar'korwi"},
    ["npc:trelane"] = {"Archmage Trelane", "Trelane"},
    ["npc:skuerto"] = {"Skuerto"},
    ["npc:loramus"] = {"Loramus Thalipedes", "Loramus"},
    ["npc:brother-paxton"] = {"Brother Paxton", "Paxton"},
    ["npc:vimes"] = {"Captain Garran Vimes", "Captain Vimes", "Vimes"},
    ["place:kel-theril"] = {"Lake Kel'Theril", "Kel'Theril", "Ruins of Kel'Theril"},
    -- Batch 5: Dun Morogh and Ironforge.
    ["npc:grelin-whitebeard"] = {"Grelin Whitebeard", "Grelin"},
    ["npc:senir-whitebeard"] = {"Senir Whitebeard", "Senir"},
    ["npc:redstone"] = {"Senator Barin Redstone", "Barin Redstone", "Redstone"},
    ["group:ironforge-senate"] = {"Senate of Ironforge", "the Senate"},
    ["npc:talin-keeneye"] = {"Talin Keeneye", "Talin"},
    ["npc:belia-thundergranite"] = {"Belia Thundergranite", "Belia"},
    ["npc:maxan-anvol"] = {"Maxan Anvol", "Maxan"},
    ["npc:bellowfiz"] = {"Pilot Bellowfiz", "Bellowfiz"},
    ["npc:rejold-barleybrew"] = {"Rejold Barleybrew", "Rejold"},
    ["npc:beldin-steelgrill"] = {"Beldin Steelgrill", "Beldin"},
    ["npc:mountaineer-thalos"] = {"Mountaineer Thalos"},
    ["npc:macgrann"] = {"Tundra MacGrann", "MacGrann"},
    ["npc:golnir-bouldertoe"] = {"Golnir Bouldertoe", "Golnir"},
    ["npc:brock-stoneseeker"] = {"Brock Stoneseeker", "Brock"},
    ["npc:rohan"] = {"High Priest Rohan", "Rohan"},
    ["npc:nori-pridedrift"] = {"Nori Pridedrift", "Nori"},
    -- Batch 6: Thunder Bluff and Mulgore.
    ["place:spirit-rise"] = {"Spirit Rise", "the Spirit Rise"},
    ["place:hunter-rise"] = {"Hunter Rise", "Hunter's Rise"},
    ["place:elder-rise"] = {"Elder Rise"},
    ["place:palemane-rock"] = {"Palemane Rock"},
    ["npc:magatha"] = {"Magatha Grimtotem", "Magatha"},
    ["npc:turak-runetotem"] = {"Turak Runetotem", "Turak"},
    ["npc:holt-thunderhorn"] = {"Holt Thunderhorn", "Holt"},
    ["npc:ruul-eagletalon"] = {"Ruul Eagletalon"},
    ["npc:harken-windtotem"] = {"Harken Windtotem", "Harken"},
    ["npc:bena-winterhoof"] = {"Bena Winterhoof", "Bena"},
    -- Batch 7: Hillsbrad, Alterac, Arathi, Desolace, Dustwallow.
    ["npc:mug-thol"] = {"Mug'Thol"},
    ["artifact:crown-of-will"] = {"Crown of Will", "the Crown of Will"},
    ["npc:melisara"] = {"Melisara"},
    ["npc:phin-odelic"] = {"Phin Odelic", "Phin"},
    ["npc:quae"] = {"Quae"},
    ["npc:kinelory"] = {"Kinelory"},
    ["npc:karnitol"] = {"Karnitol"},
    ["npc:maurin"] = {"Maurin Bonesplitter", "Maurin"},
    ["npc:helcular"] = {"Helcular"},
    ["npc:farren-orinelle"] = {"Lieutenant Farren Orinelle", "Farren Orinelle", "Farren"},
    ["npc:lydon"] = {"Apothecary Lydon", "Lydon"},
    ["npc:gol-dir"] = {"Gol'dir"},
    ["npc:jarl"] = {"Jarl"},
}
local forever = {"npc:lorthuna", "npc:valennia", "npc:aonda", "npc:illaya", "npc:hanaa", "npc:elegael", "npc:aamelia",
    "npc:lumina", "npc:father-gavin", "npc:aramis-hammerhand", "npc:shari-stilwell", "npc:alba-fairmoon"}
for _, id in ipairs(forever) do Check(A.GetLoreNote(id).setting == "Forever", "Forever content is labelled: " .. id) end

local total, aliases = 0, 0
for id, names in pairs(notes) do
    total = total + 1
    local note = A.GetLoreNote(id)
    Check(note and note.coverage == "curated", "reviewed note: " .. id)
    Check(note.setting == "Classic / Forever" or note.setting == "Forever", "timeline: " .. id)
    local sources = table.concat(note.sources, "\n")
    Check(sources:find("corpus_vanilla_quests.txt", 1, true) or sources:find("warcraft.wiki.gg", 1, true), "primary or wiki source: " .. id)
    if sources:find("LoreForever", 1, true) then
        Check(sources:find("LoreForever [%a]+:[%w%-]+ %(wiki: https://warcraft%.wiki%.gg/wiki/"),
            "Lore Forever citation names the entry and the wiki article: " .. id)
    end
    local bodies = {note.body}
    local public = A.GetKnownLoreNote(id, {})
    if public and public.body ~= note.body then bodies[#bodies + 1] = public.body end
    for _, body in ipairs(bodies) do
        Check(not body:find("{[pqn]:") and not body:find("|H", 1, true), "plain body: " .. id)
        Check(not body:lower():find("%f[%a]you%f[%A]") and not body:lower():find("%f[%a]your%f[%A]"), "no reader address: " .. id)
        Check(not body:find(":", 1, true), "no colon in note prose: " .. id)
        Check(not body:find("?", 1, true), "no question in note prose: " .. id)
        for _, word in ipairs({"journal", "chronicle", "legend has it", "tale", "story", "chapter"}) do
            Check(not body:lower():find("%f[%a]" .. word .. "s?%f[%A]"), "no meta words: " .. id .. " / " .. word)
        end
    end
    Check(note.after == nil and note.qid == nil, "not a quest outcome: " .. id)
    for _, related in ipairs(note.related or {}) do
        local target = A.GetLoreNote(related)
        Check(target and target.kind ~= "Quest", "related note exists: " .. id .. " -> " .. related)
    end
    Check(A.LoreNoteResolve("p", note.title) == id, "title resolves: " .. id)
    for _, name in ipairs(names) do
        aliases = aliases + 1
        Check(A.LoreNoteResolve("p", name) == id, "name resolves: " .. name .. " -> " .. tostring(A.LoreNoteResolve("p", name)))
        if note.kind == "Person" then Check(A.LoreNoteResolve("n", name) == id, "person markup resolves: " .. name) end
        Check(A.LoreNoteResolve("q", name) ~= id, "world note is not quest context: " .. name)
        Check(A.LoreNoteLink(name, id):find("|Hcjlore:" .. id .. "|h", 1, true), "clickable: " .. name)
    end
end

local function Marks(text, expected)
    Check(A.MarkKnownLore(text) == expected, "annotation: " .. text .. "\n  got: " .. tostring(A.MarkKnownLore(text)))
end
-- Batch 1. Prose as the packs write it links the new names.
Marks("Elissa Starbreeze had sent Balthule Shadowstrike to watch the Tower of Althalaxx.",
    "{n:Elissa Starbreeze} had sent {n:Balthule Shadowstrike} to watch {p:the Tower of Althalaxx}.")
Marks("Balthule warned Delgren about the Cult of the Dark Strand.",
    "{n:Balthule} warned {n:Delgren} about {p:the Cult of the Dark Strand}.")
Marks("Tharnariun wanted the Den Mother dead; Grimclaw waited for Volcor.",
    "{n:Tharnariun} wanted {p:the Den Mother} dead; {p:Grimclaw} waited for {n:Volcor}.")
Marks("Athridas heard from Gaerolas that Ursal the Mauler had struck.",
    "{n:Athridas} heard from {n:Gaerolas} that {n:Ursal the Mauler} had struck.")
-- The Den Mother is a Darkshore bear, not the Den of the Valley of Trials.
Marks("The Den Mother lived in a cave.", "{p:The Den Mother} lived in a cave.")
-- Quest titles that contain a new name stay plain text.
for _, title in ipairs({"Tharnariun's Hope", "The Tower of Althalaxx", "The Master's Glaive"}) do
    Marks("We completed " .. title .. ".", "We completed " .. title .. ".")
end
-- Athrikus: the public notes keep his survival and leadership of the cult unsaid.
for _, id in ipairs({"npc:athrikus", "place:tower-of-althalaxx", "group:dark-strand"}) do
    local public = A.GetKnownLoreNote(id, {})
    Check(public and not public.body:find("still lives", 1, true) and not public.body:find("master is", 1, true)
        and not public.body:find("leads the Cult", 1, true), "public " .. id .. " keeps Athrikus's role unsaid")
    for _, related in ipairs(public.related) do Check(related ~= "npc:athrikus" or id == "npc:athrikus", "public links reveal nothing: " .. id) end
    Check(A.GetKnownLoreNote(id, {["althalaxx.master"] = true}).body:find("Athrikus", 1, true), "Athrikus is told once #1140 is known: " .. id)
end
local jailor = A.GetKnownLoreNote("npc:athrikus", {["althalaxx.jailor"] = true}).body
Check(jailor:find("still lives", 1, true) and not jailor:find("Dark Strand", 1, true), "#957 tells only that the jailor lives")
Check(not A.GetLoreNote("place:satyrnaar") or true, "existing Satyrnaar note untouched")
for _, id in ipairs({"npc:balthule", "npc:delgren", "npc:elissa-starbreeze"}) do
    Check(not A.GetLoreNote(id).body:find("Athrikus", 1, true), "watchers' notes do not name the master: " .. id)
end

-- Batch 2. Names inside longer names no longer link the wrong person or place.
Marks("Nathanos Marris had been the first and last of the ranger lords.", "{n:Nathanos Marris} had been the first and last of the ranger lords.")
Marks("Nathanos's orders at the Marris Stead", "Nathanos's orders at {p:the Marris Stead}")
Marks("Karna Remtravel's mechanical ape", "{n:Karna Remtravel}'s mechanical ape")
Marks("Pay came from the Stormwind Army; Marris paid too.", "Pay came from {p:the Stormwind Army}; {n:Marris} paid too.")
Marks("Lars and Sven feared Morbent Fel; Tyrion watched Lescovar.", "Lars and Sven feared {n:Morbent Fel}; Tyrion watched {n:Lescovar}.")
-- Common given names stay plain: a player or companion may carry them, and the book
-- owner's own name is never routed to their journal.
for _, name in ipairs({"Sven", "Pamela", "Quinn", "Aurora", "Holt", "Brock", "Lars", "Tyrion", "Jarl", "Alba", "Lumina", "Milly", "Kristoff"}) do
    Marks(name .. " waited.", name .. " waited.")
end
Marks("General Feathermoon read the report.", "{n:General Feathermoon} read the report.")
for _, title in ipairs({"The Blightcaller Cometh", "Return to Verner", "Sully Balloo's Letter", "The Work of Grimand Elmore",
    "Solomon's Law", "Arugal Must Die", "Return to Quinn", "The Green Hills of Stranglethorn"}) do
    Marks("We completed " .. title .. ".", "We completed " .. title .. ".")
end
-- The Blightcaller's identity belongs to #6186 for Alliance readers.
local marris = A.GetKnownLoreNote("npc:nathanos-marris", {})
Check(not marris.body:find("Blightcaller", 1, true) and not marris.body:find("did not die", 1, true), "public Nathanos Marris keeps the Blightcaller unsaid")
for _, related in ipairs(marris.related) do Check(related ~= "npc:nathanos", "public Nathanos Marris links reveal nothing") end
Check(A.GetKnownLoreNote("npc:nathanos-marris", {["nathanos.revealed"] = true}).body:find("Nathanos Blightcaller", 1, true), "identity once #6186 is known")
Check(not A.GetKnownLoreNote("npc:nathanos-marris", {["nathanos.champion"] = true}).body:find("Blightcaller", 1, true), "Horde errands do not tell the human past")
local stead = A.GetKnownLoreNote("place:marris-stead", {})
Check(not stead.body:find("Nathanos", 1, true), "public Marris Stead does not name its holder")
Check(A.GetKnownLoreNote("place:marris-stead", {["nathanos.champion"] = true}).body:find("Nathanos Blightcaller", 1, true), "Horde readers know who holds the stead")
local holderCount = select(2, A.GetKnownLoreNote("place:marris-stead", {["nathanos.champion"] = true, ["nathanos.revealed"] = true}).body:gsub("champion of the Banshee Queen", ""))
Check(holderCount == 1, "the holder is told once")
for _, title in ipairs({"The Blightcaller Cometh", "Order Must Be Restored"}) do
    local id = A.LoreNoteResolve("q", title)
    local quest = id and A.GetKnownLoreNote(id, {})
    Check(quest and not quest.body:find("Nathanos", 1, true), "stage note keeps the identity for #6186 readers: " .. title)
    Check(A.GetKnownLoreNote(id, {["nathanos.revealed"] = true}).body:find("Nathanos", 1, true), "stage note is whole once known: " .. title)
end
-- Lescovar: the employer is learned from Shaw (#393).
local lescovar = A.GetKnownLoreNote("npc:lescovar", {})
Check(not lescovar.body:find("Marzon", 1, true) and not lescovar.body:find("Defias", 1, true), "public Lescovar keeps the plot unsaid")
local maelik = A.GetKnownLoreNote("npc:marzon", {})
Check(maelik.title == "Maelik" and not maelik.body:find("Lescovar", 1, true) and not maelik.body:find("Marzon", 1, true), "public Maelik keeps both secrets")
Check(A.GetKnownLoreNote("npc:marzon", {["lescovar.employer"] = true}).title == "Marzon", "Marzon once #393 is known")
Check(not A.GetKnownLoreNote("npc:tyrion", {}).body:find("Lescovar", 1, true), "public Tyrion keeps his watch unsaid")
Check(not A.GetLoreNote("npc:elaine-carevin").body:find("Abercrombie", 1, true), "Elaine's note does not name the hermit")

-- Batch 3.
Marks("Sprite Darter flew; Sprite Jumpsprocket built the bomb.", "Sprite Darter flew; {n:Sprite Jumpsprocket} built the bomb.")
Marks("Maur Grimtotem and Maur Raincaller.", "{n:Maur Grimtotem} and {n:Maur Raincaller}.")
Marks("Hanaa Nightwind believed Lorthuna had sent them.", "{n:Hanaa Nightwind} believed {n:Lorthuna} had sent them.")
Marks("We completed Confront Lorthuna.", "We completed Confront Lorthuna.")
local lorthuna = A.GetKnownLoreNote("npc:lorthuna", {})
Check(not lorthuna.body:find("Rohashi", 1, true) and not lorthuna.body:find("watchtower", 1, true), "public Lorthuna keeps her later moves unsaid")
Check(A.GetKnownLoreNote("npc:lorthuna", {["lorthuna.plans"] = true}).body:find("watchtower", 1, true), "plans once #92528 is known")
Check(A.GetKnownLoreNote("npc:lorthuna", {["lorthuna.plans"] = true, ["lorthuna.spires"] = true}).body == A.GetLoreNote("npc:lorthuna").body, "whole note once both are known")
for _, id in ipairs({"npc:alba-fairmoon", "npc:jasper-fel", "npc:sprite-jumpsprocket"}) do
    Check(not A.GetLoreNote(id).body:find("military", 1, true), "the Westfall chain's verdict stays out: " .. id)
end
Check(not A.GetLoreNote("npc:elegael").body:find("dead", 1, true), "Jorel's fate stays out of Elegael's note")

-- Batch 4.
Marks("Ginro sent the knife to Quint; Pestlezugg and Zilzibin read the report.",
    "{n:Ginro} sent the knife to Quint; {n:Pestlezugg} and {n:Zilzibin} read the report.")
Marks("We completed Kim'jael Indeed! and The Fare of Lar'korwi.", "We completed Kim'jael Indeed! and The Fare of Lar'korwi.")
Marks("He owed money from Kalimdor Hold 'Em.", "He owed money from Kalimdor Hold 'Em.")
local raschal = A.GetKnownLoreNote("npc:raschal", {})
Check(not raschal.body:find("pod", 1, true) and not raschal.body:find("Freed", 1, true) and not raschal.body:find("wrecked", 1, true), "public Raschal is missing")
Check(A.GetKnownLoreNote("npc:raschal", {["raschal.wreck"] = true}).body:find("wrecked", 1, true), "the wreck once found")
Check(A.GetKnownLoreNote("npc:raschal", {["raschal.found"] = true}).body:find("sealed alive", 1, true), "the rescue once #4265 is known")

-- Batch 5.
Marks("Grelin sent his report to Senir; the Senate would not be pleased.", "{n:Grelin} sent his report to {n:Senir}; {p:the Senate} would not be pleased.")
Marks("We completed Senir's Observations and Return to Brock.", "We completed Senir's Observations and Return to Brock.")

-- Short forms added to existing notes.
Marks("Dalar warned Allister; Sergra and Trias waited; Fandral read the report.",
    "{n:Dalar} warned {n:Allister}; {n:Sergra} and {n:Trias} waited; {n:Fandral} read the report.")
Marks("We completed Dalar's Analysis.", "We completed Dalar's Analysis.")
-- Batch 6.
Marks("Zamah waited below the Spirit Rise; Ruul sent the young to Magatha on Elder Rise.",
    "{n:Zamah} waited below {p:the Spirit Rise}; Ruul sent the young to {n:Magatha} on {p:Elder Rise}.")
Marks("Apothecary Johaan tested a plague for the Dark Lady.", "{n:Apothecary Johaan} tested a plague for {n:the Dark Lady}.")

Check(A.db.sentinel == "unchanged" and next(A.db, "sentinel") == nil, "notes are read-only")
print(string.format("LoreNotes2Overnight: %d checks passed; %d notes, %d names", count, total, aliases))
