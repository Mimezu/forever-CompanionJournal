-- Run from client root: lua5.1 Interface/AddOns/CompanionJournal/tests/LoreNotes4.lua
-- Fourth notes lane (notes4, 2026-11-06): notes for the places and people the new
-- 20-30 quest scenes name. Every note is sourced and plain; its names resolve; a
-- reader who has done no quest meets no guarded fact in a public note, and each secret
-- returns once the exact quest that tells it is known. Distinctive short forms link;
-- ordinary given names, quest titles and the user's own character names do not.
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

local function Public(id) return A.GetKnownLoreNote(id, {}) end
local function Known(id, facts)
    local k = {}
    for _, f in ipairs(facts) do k[f] = true end
    return A.GetKnownLoreNote(id, k)
end

-- 1. The new notes and the names that must open them.
local notes = {
    -- Batch 1: the Stonetalon Mountains.
    ["place:talon-den"] = {"Talon Den", "the Talon Den"}, ["place:sishir-canyon"] = {"Sishir Canyon"},
    ["place:boulderslide-ravine"] = {"Boulderslide Ravine"}, ["place:greatwood-vale"] = {"Greatwood Vale", "the Greatwood Vale"},
    ["place:malakajin"] = {"Malaka'jin", "Malaka'Jin"}, ["place:mirkfallon-lake"] = {"Mirkfallon Lake"},
    ["place:grimtotem-post"] = {"Grimtotem Post"}, ["place:camp-aparaje"] = {"Camp Aparaje"},
    ["place:raynewood-retreat"] = {"Raynewood Retreat", "Raynewood"},
    ["npc:makaba-flathoof"] = {"Makaba Flathoof", "Makaba"}, ["npc:tammra-windfield"] = {"Tammra Windfield"},
    ["npc:morrogal"] = {"Mor'rogal"}, ["npc:goggeroc"] = {"Goggeroc"}, ["npc:maggran"] = {"Maggran Earthbinder", "Maggran"},
    ["npc:braelyn-firehand"] = {"Braelyn Firehand"}, ["npc:ordanus"] = {"Keeper Ordanus", "Ordanus"},
    ["npc:xenzilla"] = {"Xen'Zilla"}, ["npc:jinzil"] = {"Witch Doctor Jin'Zil", "Jin'Zil"},
    -- Batch 2: the Barrens, Thousand Needles and Hillsbrad.
    ["place:whitereach-post"] = {"Whitereach Post"}, ["place:darkcloud-pinnacle"] = {"Darkcloud Pinnacle"},
    ["place:boiling-pool"] = {"Boiling Pool", "the Boiling Pool"}, ["place:azurelode-mine"] = {"Azurelode Mine", "Azureload Mine"},
    ["place:field-of-giants"] = {"Field of Giants", "the Field of Giants"}, ["place:sludge-fen"] = {"Sludge Fen", "the Sludge Fen"},
    ["place:hillsbrad-fields"] = {"Hillsbrad Fields"},
    ["npc:motega-firemane"] = {"Motega Firemane", "Motega"}, ["npc:paoka"] = {"Pao'ka Swiftmountain", "Pao'ka"},
    ["npc:lakota-windsong"] = {"Lakota Windsong"}, ["npc:thalia-amberhide"] = {"Thalia Amberhide"},
    ["npc:grish-longrunner"] = {"Grish Longrunner"}, ["npc:moonhorn"] = {"Brave Moonhorn"},
    ["npc:wizlo"] = {"Wizlo Bearingshiner", "Wizlo"}, ["npc:korran"] = {"Korran"},
    ["npc:verringtan"] = {"Blacksmith Verringtan", "Verringtan"}, ["npc:burnside"] = {"Magistrate Burnside", "Burnside"},
    ["npc:ironhill"] = {"Captain Ironhill", "Ironhill"},
    -- Batch 3: Ashenvale for the Alliance, and Dreadmist Peak.
    ["place:ruins-of-stardust"] = {"Ruins of Stardust", "the Ruins of Stardust"}, ["place:iris-lake"] = {"Iris Lake"},
    ["place:fallen-sky-lake"] = {"Fallen Sky Lake"}, ["place:forest-song"] = {"Forest Song"},
    ["place:howling-vale"] = {"Howling Vale", "the Howling Vale"}, ["place:xavian"] = {"Xavian"},
    ["place:silverwind-refuge"] = {"Silverwind Refuge"}, ["place:dordanil"] = {"Dor'Danil Barrow Den", "Dor'danil Barrow Den"},
    ["place:dreadmist-peak"] = {"Dreadmist Peak"},
    ["npc:illiyana"] = {"Illiyana"}, ["npc:anilia"] = {"Anilia"}, ["npc:geltharis"] = {"Geltharis"},
    ["npc:melyria"] = {"Melyria Frostshadow", "Sentinel Melyria Frostshadow", "Melyria"},
    ["npc:kayneth"] = {"Kayneth Stillwind", "Kayneth"}, ["npc:velene"] = {"Sentinel Velene Starstrike", "Velene Starstrike"},
    ["npc:sarilus"] = {"Sarilus Foulborne", "Sarilus"}, ["npc:pelturas"] = {"Pelturas Whitemoon", "Pelturas"},
    ["npc:relara"] = {"Relara"}, ["npc:therysil"] = {"Therysil"}, ["npc:dal-bloodclaw"] = {"Dal Bloodclaw"},
    -- Batch 4: the Horde's Ashenvale, Kaela Shadowspear and Gaxim Rustfizzle.
    ["place:silverwing-outpost"] = {"Silverwing Outpost"}, ["place:thistlefur-hold"] = {"Thistlefur Hold"},
    ["place:falfarren-river"] = {"Falfarren River", "the Falfarren River"}, ["place:cragpool-lake"] = {"Cragpool Lake"},
    ["npc:muglash"] = {"Muglash"}, ["npc:vorsha"] = {"Vorsha the Lasher", "Vorsha"}, ["npc:mitsuwa"] = {"Mitsuwa"},
    ["npc:kuraybin"] = {"Kuray'bin"}, ["npc:ertog"] = {"Ertog Ragetusk", "Ertog"}, ["npc:torek"] = {"Torek"},
    ["npc:duriel-moonfire"] = {"Duriel Moonfire", "Duriel"}, ["npc:locke-okarr"] = {"Locke Okarr"},
    ["npc:gurda-ragescar"] = {"Gurda Ragescar"}, ["npc:karang"] = {"Karang Amakkar", "Karang"},
    ["npc:murgut"] = {"Chief Murgut", "Murgut"}, ["npc:kaela"] = {"Kaela Shadowspear", "Kaela"},
    ["npc:gaxim"] = {"Gaxim Rustfizzle", "Gaxim"}, ["npc:collin-mauren"] = {"Collin Mauren", "Mauren"},
    ["npc:lomac-gearstrip"] = {"Lomac Gearstrip", "Lomac"},
    -- Batch 5: Booty Bay, Nesingwary's camp, the Hinterlands, the Mirage Raceway.
    ["npc:revilgaz"] = {"Baron Revilgaz", "Revilgaz"}, ["npc:krazek"] = {"Krazek"}, ["npc:kebok"] = {"Kebok"},
    ["npc:zanzil"] = {"Zanzil the Outcast", "Zanzil"}, ["npc:ajeck"] = {"Ajeck Rouack", "Ajeck"}, ["npc:drizzlik"] = {"Drizzlik"},
    ["npc:thorsen"] = {"Private Thorsen", "Thorsen"}, ["npc:oglethorpe"] = {"Oglethorpe Obnoticus", "Oglethorpe"},
    ["npc:sharpbeak"] = {"Sharpbeak"}, ["npc:talonaxe"] = {"Gryphon Master Talonaxe", "Talonaxe"}, ["npc:zengu"] = {"Zengu"},
    ["npc:kravel"] = {"Kravel Koalbeard", "Kravel"},
    -- Batch 6: notes3's leftovers and the band3050 lane's request.
    ["npc:deliah"] = {"Deliah"}, ["npc:islen"] = {"Islen Waterseer", "Islen"}, ["npc:zalazane"] = {"Zalazane"},
    ["npc:hinderweir"] = {"Chief Engineer Hinderweir VII", "Hinderweir"}, ["npc:longbraid"] = {"Longbraid the Grim", "Longbraid"},
    ["npc:hadoken"] = {"Hadoken Swiftstrider", "Hadoken"}, ["npc:belgrom"] = {"Belgrom Rockmaul", "Belgrom"},
    ["npc:nazz"] = {"Nazz Steamboil", "Nazz"}, ["npc:crank-fizzlebub"] = {"Crank Fizzlebub", "Fizzlebub"},
    ["npc:mukla"] = {"King Mukla", "Mukla"},
}
local hidden = {["npc:goggeroc"] = true, ["npc:geltharis"] = true, ["npc:deliah"] = true}
local total, aliases = 0, 0
local meta = {"journal", "chronicle", "tale", "story", "chapter", "page", "record", "song", "verse", "bard"}
local function Prose(id, body)
    Check(not body:find("{[pqn]:") and not body:find("|H", 1, true), "plain body: " .. id)
    Check(not body:lower():find("%f[%a]you%f[%A]") and not body:lower():find("%f[%a]your%f[%A]"), "no reader address: " .. id)
    Check(not body:find(":", 1, true) and not body:find("?", 1, true), "no colon or question: " .. id)
    -- A proper name such as Forest Song is not a word about the telling.
    local plain = body:gsub("Forest Song", "Forest")
    for _, word in ipairs(meta) do
        Check(not plain:lower():find("%f[%a]" .. word .. "s?%f[%A]"), "no meta words: " .. id .. " / " .. word)
    end
end
for id, names in pairs(notes) do
    total = total + 1
    local note = A.GetLoreNote(id)
    Check(note and note.coverage == "curated", "reviewed note: " .. id)
    Check(note.setting == "Classic / Forever" or note.setting == "Forever", "timeline: " .. id)
    local sources = table.concat(note.sources, "\n")
    Check(sources:find("corpus_vanilla_quests.txt", 1, true), "primary source: " .. id)
    for source in sources:gmatch("LoreForever[^\n]*") do
        Check(source:find("^LoreForever %a+:[%w%-]+ %(wiki%: https://warcraft%.wiki%.gg/wiki/"), "Lore Forever citation shape: " .. id .. " / " .. source)
    end
    Prose(id, note.body)
    local public = Public(id)
    if hidden[id] then Check(public == nil, "hidden until discovered: " .. id)
    else
        Check(public, "public note: " .. id)
        if public.body ~= note.body then Prose(id, public.body) end
        for _, related in ipairs(public.related or {}) do Check(A.GetLoreNote(related), "public related exists: " .. id .. " -> " .. related) end
    end
    for _, related in ipairs(note.related or {}) do
        local target = A.GetLoreNote(related)
        Check(target and target.kind ~= "Quest", "related note exists: " .. id .. " -> " .. related)
    end
    Check(A.LoreNoteResolve("p", note.title) == id, "title resolves: " .. id)
    for _, name in ipairs(names) do
        aliases = aliases + 1
        Check(A.LoreNoteResolve("p", name) == id, "name resolves: " .. name .. " -> " .. tostring(A.LoreNoteResolve("p", name)))
    end
end

-- 2. Guarded facts never reach a public note, title or body.
local guards = {
    {"the Earthen under Boulderslide Ravine", {"Goggeroc", "Earthen magic", "Resonite cask"}},
    {"Anilia's death", {"Anilia"}, {"died", "death", "dying", "wound", "last breath", "is gone", "did not come back"}},
    {"Geltharis took the Branch", {"Geltharis"}},
    {"the Dor'Danil druids murdered", {"Dor'Danil", "Dor'danil"}, {"murdered", "driven mad", "errant ghosts", "Taneel", "Uthil", "Mavoris"}},
    {"Sarilus is the summoner", {"Sarilus"}, {"summoner", "elementals", "Velene", "divination"}},
    {"who holds Yenniku", {"Yenniku"}, {"Zanzil", "Aboraz", "soul gem", "Kin'weelay"}},
    {"Deliah", {"Deliah"}},
    {"Belnistrasz is a dragon", {"Belnistrasz"}, {"dragon", "brazier"}},
    {"Kaya Flathoof survived", {"Kaya survived", "Kaya escaped", "Kaya is alive", "Kaya was alive", "survived the raid", "made her way out"}},
}
local function Has(text, terms)
    for _, term in ipairs(terms) do
        local pattern = term:gsub("[%^%$%(%)%%%.%[%]%*%+%-%?]", "%%%0")
        if term:match("^%w") then pattern = "%f[%w]" .. pattern end
        if term:match("%w$") then pattern = pattern .. "%f[%W]" end
        if text:find(pattern) then return term end
    end
end
local leaks, publicCount = {}, 0
for _, entry in ipairs(A.LoreNoteCatalog()) do
    if entry.kind ~= "Quest" then
        local public = Public(entry.id)
        if public then
            publicCount = publicCount + 1
            local text = public.title .. "\n" .. public.body
            for _, rule in ipairs(guards) do
                local first = Has(text, rule[2])
                count = count + 1
                if first and (not rule[3] or Has(text, rule[3])) then leaks[#leaks + 1] = entry.id .. ": " .. rule[1] .. " (" .. first .. ")" end
            end
        end
    end
end
Check(#leaks == 0, "public notes tell guarded facts:\n  " .. table.concat(leaks, "\n  "))
local reveals = {
    {"place:boulderslide-ravine", {"goggeroc.earthen"}, "Goggeroc"},
    {"npc:morrogal", {"goggeroc.earthen"}, "Earthen magic"},
    {"npc:makaba-flathoof", {"kaya.alive"}, "survived the raid"},
    {"npc:illiyana", {"anilia.dead"}, "did not come back"}, {"npc:anilia", {"anilia.dead"}, "Geltharis"},
    {"place:dordanil", {"dordanil.vision"}, "murdered by the undead"}, {"npc:kayneth", {"dordanil.vision"}, "vision"},
    {"npc:velene", {"sarilus.summoner"}, "Sarilus Foulborne"},
    {"npc:belnistrasz", {"belnistrasz.dragon"}, "great red dragon"},
    {"npc:zanzil", {"yenniku.zanzil"}, "Yenniku"}, {"npc:yenniku", {"yenniku.zanzil"}, "Zanzil"},
    {"npc:nimboya", {"yenniku.zanzil"}, "soul gem"}, {"npc:nimboya", {"yenniku.saved"}, "in stone"}, {"npc:sarilus", {"sarilus.summoner"}, "summoner"},
}
for _, r in ipairs(reveals) do
    local id, facts, phrase = r[1], r[2], r[3]
    Check(not Public(id).body:find(phrase, 1, true), "public keeps it unsaid: " .. id .. " / " .. phrase)
    Check(Known(id, facts).body:find(phrase, 1, true), "told once known: " .. id .. " / " .. phrase)
end
Check(Public("npc:makaba-flathoof").body:find("was lost in the attack", 1, true), "Makaba believes Kaya lost")
Check(not Known("npc:makaba-flathoof", {"kaya.alive"}).body:find("was lost in the attack", 1, true), "the belief goes once she is found")
Check(Known("npc:goggeroc", {"goggeroc.earthen"}).body == A.GetLoreNote("npc:goggeroc").body, "Goggeroc's note once known")
for _, related in ipairs(Public("place:boulderslide-ravine").related) do Check(related ~= "npc:goggeroc", "public ravine does not link Goggeroc") end
for _, related in ipairs(Public("npc:anilia").related) do Check(related ~= "npc:geltharis", "public Anilia does not link Geltharis") end
for _, related in ipairs(Public("npc:velene").related) do Check(related ~= "npc:sarilus", "public Velene does not link Sarilus") end
Check(Known("npc:geltharis", {"anilia.dead"}), "Geltharis once Anilia names him")
for _, related in ipairs(Public("npc:morrogal").related) do Check(related ~= "npc:goggeroc", "public Mor'rogal does not link Goggeroc") end

-- 3. Linking.
local function Marks(text, expected)
    Check(A.MarkKnownLore(text) == expected, "annotation: " .. text .. "\n  got: " .. tostring(A.MarkKnownLore(text)))
end
Marks("Makaba and Maggran met Mor'rogal, Xen'Zilla and Jin'Zil at Malaka'jin.",
    "{n:Makaba} and {n:Maggran} met {n:Mor'rogal}, {n:Xen'Zilla} and {n:Jin'Zil} at {p:Malaka'jin}.")
Marks("Braelyn and Tammra waited at Raynewood.", "Braelyn and Tammra waited at {p:Raynewood}.")
Marks("Braelyn Firehand sent word to Tammra Windfield.", "{n:Braelyn Firehand} sent word to {n:Tammra Windfield}.")
Marks("The Talon Den, Sishir Canyon and Camp Aparaje.", "The {p:Talon Den}, {p:Sishir Canyon} and {p:Camp Aparaje}.")
Marks("Motega sent Pao'ka and Wizlo to Korran and Verringtan.", "{n:Motega} sent {n:Pao'ka} and {n:Wizlo} to {n:Korran} and {n:Verringtan}.")
Marks("Lakota'mani, Lakota, Burnside and Ironhill.", "Lakota'mani, Lakota, Burnside and Ironhill.")
Marks("Lakota Windsong and Magistrate Burnside.", "{n:Lakota Windsong} and {n:Magistrate Burnside}.")
Marks("Illiyana, Anilia, Relara, Pelturas, Kayneth and Sarilus met Melyria at Xavian.",
    "{n:Illiyana}, {n:Anilia}, {n:Relara}, {n:Pelturas}, {n:Kayneth} and {n:Sarilus} met {n:Melyria} at {p:Xavian}.")
Marks("Velene waited at Forest Song.", "Velene waited at {p:Forest Song}.")
Marks("Gaxim, Vorsha, Ertog, Murgut, Karang, Lomac, Muglash, Mitsuwa and Kuray'bin.",
    "{n:Gaxim}, {n:Vorsha}, {n:Ertog}, {n:Murgut}, {n:Karang}, {n:Lomac}, {n:Muglash}, {n:Mitsuwa} and {n:Kuray'bin}.")
Marks("Revilgaz, Krazek, Kebok, Zanzil, Ajeck, Drizzlik, Oglethorpe, Sharpbeak, Talonaxe, Zengu and Kravel.",
    "{n:Revilgaz}, {n:Krazek}, {n:Kebok}, {n:Zanzil}, {n:Ajeck}, {n:Drizzlik}, {n:Oglethorpe}, {n:Sharpbeak}, {n:Talonaxe}, {n:Zengu} and {n:Kravel}.")
Marks("Thorsen waited.", "Thorsen waited.")
Marks("Deliah, Islen, Zalazane, Hinderweir, Longbraid, Hadoken, Belgrom, Nazz, Fizzlebub and Mukla.",
    "{n:Deliah}, {n:Islen}, {n:Zalazane}, {n:Hinderweir}, {n:Longbraid}, {n:Hadoken}, {n:Belgrom}, {n:Nazz}, {n:Fizzlebub} and {n:Mukla}.")
-- Deliah's note opens in stages: the ring, her husband, her murder.
Check(Known("npc:deliah", {"deliah.ring"}) and not Known("npc:deliah", {"deliah.ring"}).body:find("Raleigh", 1, true), "the ring alone names no husband")
Check(Known("npc:deliah", {"deliah.ring", "deliah.raleigh"}).body:find("Raleigh", 1, true), "Sevren's records name Raleigh")
Check(not Known("npc:deliah", {"deliah.ring", "deliah.raleigh"}).body:find("murdered", 1, true), "the husband alone tells no murder")
Check(Known("npc:deliah", {"deliah.ring", "deliah.raleigh", "deliah.murder"}).body == A.GetLoreNote("npc:deliah").body, "the whole note once all is known")
Check(Known("npc:deliah", {"deliah.raleigh"}) == nil, "no note before the ring")
Marks("Kaela, Tara, Duriel, Mauren and Torek waited.", "Kaela, Tara, Duriel, Mauren and Torek waited.")
-- A quest title that only contains one of these names stays plain; a title that is
-- the subject's own name ("Ordanus", "Vorsha the Lasher") may open its note.
do
    local mine = {}
    for id in pairs(notes) do mine[id] = true end
    local corpus = assert(io.open("StorageInvestigation/journal-voice/review/corpus_vanilla_quests.txt")):read("*a")
    local seen, bad = {}, {}
    for title in corpus:gmatch("\n### (.-)  %(id %d+") do
        if not seen[title] then
            seen[title] = true
            local marked = A.MarkKnownLore(title)
            for kind, name in marked:gmatch("{([pn]):([^}]*)}") do
                local id = A.LoreNoteResolve(kind, name)
                if id and mine[id] and name ~= title then bad[#bad + 1] = title .. " -> " .. marked end
            end
        end
    end
    table.sort(bad)
    Check(#bad == 0, "quest titles that would open a notes4 note:\n  " .. table.concat(bad, "\n  "))
end
-- Own characters and listed players never link to a namesake.
A.db.characters = {["makaba-realm"] = {}}
A.db.people = {["maggran-otherrealm"] = {name = "Maggran-OtherRealm"}}
Marks("Makaba and Maggran met Ordanus.", "Makaba and Maggran met {n:Ordanus}.")
A.db.characters, A.db.people = nil, nil
Marks("Makaba waited.", "{n:Makaba} waited.")

Check(A.db.sentinel == "unchanged" and next(A.db, "sentinel") == nil, "notes are read-only")
print(string.format("LoreNotes4: %d checks passed; %d new notes, %d names; %d public notes guarded against %d rules",
    count, total, aliases, publicCount, #guards))
