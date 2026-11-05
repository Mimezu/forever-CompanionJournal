-- Run from client root: lua5.1 Interface/AddOns/CompanionJournal/tests/LoreNotesOvernight.lua
-- Notes added in the 2026-11-05 overnight pass (gaps found against Lore Forever).
-- Every note is sourced, timeline-labelled, plain reference text, and every
-- listed name opens it; ordinary words and shared family names stay unlinked.
local root = "Interface/AddOns/CompanionJournal/"
local A = {People = {}, db = {sentinel = "unchanged"}}
local count = 0
local function Check(value, message) count = count + 1; assert(value, message) end
local function Load(name) assert(loadfile(root .. name))("CompanionJournal", A) end
Load("LoreData.lua"); Load("Lore.lua")
Load("LoreAllianceStories.lua"); Load("LoreHordeStories.lua"); Load("LoreWorldStories.lua"); Load("LoreClassStories.lua")
Load("LoreNotes.lua")
Load("LoreDiscovery.lua"); Load("LoreDiscoveryData.lua")
Load("LorePlaces.lua"); Load("LorePeopleHistory.lua"); Load("LoreWorldConnections.lua")

-- id = {names that must resolve to it}; the title is always checked as well.
local notes = {
    -- Batch 1: Valley of Trials, Durotar, Red Cloud Mesa.
    ["npc:gornek"] = {"Gornek"},
    ["npc:kaltunk"] = {"Kaltunk"},
    ["npc:hana-zua"] = {"Hana'zua", "Hana’zua"},
    ["npc:sarkoth"] = {"Sarkoth"},
    ["npc:rhinag"] = {"Rhinag"},
    ["npc:kor-ghan"] = {"Kor'ghan"},
    ["npc:rezlak"] = {"Rezlak"},
    ["npc:orgnil"] = {"Orgnil Soulscar", "Orgnil"},
    ["npc:ukor"] = {"Ukor"},
    ["npc:gazlowe"] = {"Gazlowe"},
    ["npc:telf-joolam"] = {"Telf Joolam", "Telf"},
    ["npc:chief-hawkwind"] = {"Chief Hawkwind"},
    ["npc:greatmother-hawkwind"] = {"Greatmother Hawkwind"},
    ["npc:grull-hawkwind"] = {"Grull Hawkwind", "Grull"},
    ["npc:seer-graytongue"] = {"Seer Graytongue", "Graytongue"},
    ["npc:zarlman-two-moons"] = {"Zarlman Two-Moons", "Zarlman"},
    ["npc:seer-ravenfeather"] = {"Seer Ravenfeather", "Ravenfeather"},
    ["artifact:water-of-the-seers"] = {"Water of the Seers"},
    ["place:the-den"] = {"The Den", "the Den"},
    ["place:drygulch"] = {"Drygulch Ravine"},
    ["place:dormant-flame"] = {"Shrine of the Dormant Flame"},
    ["place:cleft-of-shadow"] = {"Cleft of Shadow", "the Cleft of Shadow"},
    ["place:red-rocks"] = {"Red Rocks"},
    ["place:brambleblade"] = {"Brambleblade Ravine"},
    ["place:ravaged-caravan"] = {"Ravaged Caravan", "the Ravaged Caravan"},
    -- Batch 2: Forever 1.60.1 zones, instances and their foes.
    ["region:riverglades"] = {"Riverglades", "The Riverglades"},
    ["place:sunnyglade"] = {"Sunnyglade"},
    ["place:farholde"] = {"Farholde Keep", "Farholde"},
    ["place:powderfuse-port"] = {"Powderfuse Port"},
    ["dungeon:kroldok"] = {"Krol'dok Stronghold", "Krol'dok"},
    ["region:shendralas"] = {"Shen'dralas"},
    ["region:mount-hyjal"] = {"Mount Hyjal", "Hyjal"},
    ["raid:barrow-deeps"] = {"Barrow Deeps", "the Barrow Deeps"},
    ["raid:hyjal-summit"] = {"Hyjal Summit"},
    ["battleground:darkspear-islands"] = {"Darkspear Islands", "the Darkspear Islands"},
    ["place:nordrassil"] = {"Nordrassil"},
    ["place:well-of-eternity"] = {"Well of Eternity", "the Well of Eternity"},
    ["faction:brotherhood-horse"] = {"Brotherhood of the Horse"},
    ["npc:the-baron"] = {"The Baron", "the Baron"},
    ["npc:viktor-vile"] = {"Viktor the Vile"},
    ["npc:the-abandoned"] = {"The Abandoned"},
    ["npc:bjork"] = {"Bjork"},
    ["npc:lordaeron-captain"] = {"Lordaeron Captain"},
    ["npc:faldrim-anvilmar"] = {"Faldrim Anvilmar", "Faldrim"},
    ["npc:magmatus"] = {"Magmatus"},
    ["npc:plunder"] = {"Plunder"},
    -- Batch 3: Shadowglen, Northshire, Deathknell, Brill and the capitals.
    ["npc:iverron"] = {"Iverron"},
    ["npc:ilthalaine"] = {"Conservator Ilthalaine", "Ilthalaine"},
    ["npc:tenaron"] = {"Tenaron Stormgrip", "Tenaron"},
    ["npc:denalan"] = {"Denalan"},
    ["npc:coleman-farthing"] = {"Coleman Farthing", "Coleman"},
    ["npc:calvin-montague"] = {"Calvin Montague"},
    ["npc:linnea"] = {"Deathguard Linnea", "Linnea"},
    ["npc:arren"] = {"Executor Arren", "Arren"},
    ["npc:eleanor-shackleton"] = {"Eleanor Shackleton"},
    ["npc:willem"] = {"Deputy Willem", "Willem"},
    ["npc:guard-thomas"] = {"Guard Thomas"},
    ["npc:bartleby"] = {"Bartleby"},
    ["npc:bishop-farthing"] = {"Bishop Farthing"},
    ["npc:galgar"] = {"Galgar"},
    ["npc:ahanu"] = {"Ahanu"},
    ["npc:gordon-wendham"] = {"Gordon Wendham"},
    ["place:aldrassil"] = {"Aldrassil"},
    ["place:fel-rock"] = {"Fel Rock"},
    ["place:temple-of-the-moon"] = {"Temple of the Moon", "the Temple of the Moon"},
    ["place:gallows-end"] = {"Gallows' End Tavern", "Gallow's End Tavern"},
    ["place:venomweb-vale"] = {"Venomweb Vale"},
    ["place:lions-pride"] = {"Lion's Pride Inn", "the Lion's Pride Inn"},
    ["place:mirror-lake"] = {"Mirror Lake"},
    ["place:cathedral-of-light"] = {"Cathedral of Light", "the Cathedral of Light"},
    ["faction:night-watch"] = {"Night Watch", "the Night Watch"},
    ["faction:sentinels"] = {"Sentinels", "the Sentinels"},
    ["deity:elune"] = {"Elune"},
    -- Batch 4: quest givers and places of the 10-35 prose.
    ["npc:shael-dryn"] = {"Shael'dryn"},
    ["npc:raene"] = {"Raene Wolfrunner", "Raene"},
    ["npc:sputtervalve"] = {"Sputtervalve"},
    ["npc:brine"] = {"Brine"},
    ["npc:doren"] = {"Lieutenant Doren", "Doren"},
    ["npc:kurzen"] = {"Colonel Kurzen", "Kurzen"},
    ["npc:madame-eva"] = {"Madame Eva"},
    ["npc:zargh"] = {"Zargh"},
    ["npc:thork"] = {"Thork"},
    ["npc:devrak"] = {"Devrak"},
    ["npc:uzzek"] = {"Uzzek"},
    ["npc:darcy"] = {"Darcy"},
    ["npc:huldar"] = {"Huldar"},
    ["deity:earth-mother"] = {"Earth Mother", "the Earthmother", "Earthmother"},
    ["place:bashal-aran"] = {"Bashal'Aran"},
    ["place:ameth-aran"] = {"Ameth'Aran"},
    ["place:althers-mill"] = {"Alther's Mill"},
    ["place:far-watch-post"] = {"Far Watch Post"},
    -- Batch 5: the supporting cast named in rendered chapters.
    ["npc:gryshka"] = {"Innkeeper Gryshka", "Gryshka"},
    ["npc:mangletooth"] = {"Mangletooth"},
    ["npc:wizzlecrank"] = {"Wizzlecrank"},
    ["npc:ziz-fizziks"] = {"Ziz Fizziks"},
    ["npc:gerenzo"] = {"Gerenzo Wrenchwhistle", "Gerenzo"},
    ["npc:guard-parker"] = {"Guard Parker"},
    ["npc:teronis"] = {"Teronis"},
    ["npc:elreth"] = {"Novice Elreth", "Elreth"},
    ["npc:marla-fipps"] = {"Marla Fipps"},
    ["npc:samuel-fipps"] = {"Samuel Fipps"},
    ["npc:dirania"] = {"Dirania Silvershine", "Dirania"},
    ["npc:tallonkai"] = {"Tallonkai Swiftroot", "Tallonkai"},
    ["npc:melenas"] = {"Lord Melenas", "Melenas"},
    ["npc:rellian"] = {"Rellian Greenspyre", "Rellian"},
    ["npc:renee"] = {"Innkeeper Renee", "Renee"},
    ["npc:perrine"] = {"Captain Perrine", "Perrine"},
    ["npc:karos-razok"] = {"Karos Razok"},
    ["npc:farley"] = {"Innkeeper Farley", "Farley"},
    ["npc:william-pestle"] = {"William Pestle"},
    ["npc:milly-osworth"] = {"Milly Osworth"},
    ["npc:brother-neals"] = {"Brother Neals"},
    ["place:lake-al-ameth"] = {"Lake Al'Ameth"},
    ["place:lake-falathim"] = {"Lake Falathim"},
    -- Batch 6: world names and the remaining 10-30 quest givers.
    ["region:lordaeron"] = {"Lordaeron", "Kingdom of Lordaeron"},
    ["belief:holy-light"] = {"Holy Light", "the Holy Light", "the Light"},
    ["npc:cenarius"] = {"Cenarius"},
    ["region:kul-tiras"] = {"Kul Tiras"},
    ["place:karazhan"] = {"Karazhan"},
    ["npc:agamaggan"] = {"Agamaggan"},
    ["npc:calor"] = {"Calor"},
    ["npc:kadrak"] = {"Kadrak"},
    ["npc:mull-thunderhorn"] = {"Mull Thunderhorn"},
    ["npc:morin-cloudstalker"] = {"Morin Cloudstalker"},
    ["npc:terenthis"] = {"Terenthis"},
    ["npc:grayson"] = {"Lord Grayson Shadowbreaker", "Grayson Shadowbreaker"},
    ["npc:allister"] = {"Shadow Priest Allister", "Allister"},
    ["npc:laird"] = {"Laird"},
    ["npc:gath-ilzogg"] = {"Gath'Ilzogg"},
    ["npc:gann-stonespire"] = {"Gann Stonespire"},
    ["npc:gazrog"] = {"Gazrog"},
    ["npc:old-murk-eye"] = {"Old Murk-Eye"},
    ["place:zoram-strand"] = {"Zoram Strand", "the Zoram Strand"},
    ["place:terrordale"] = {"Terrordale"},
    ["place:stonewatch"] = {"Stonewatch Keep", "Stonewatch"},
    -- Batch 7: Zephras Isle, the Skyborne starting land (Forever).
    ["people:skyborne"] = {"Skyborne", "Shen'dorei"},
    ["faction:windshapers"] = {"Windshapers", "the Windshapers"},
    ["faction:high-order"] = {"High Order", "the High Order"},
    ["group:al-aketh"] = {"Al'Aketh", "the Al'Aketh"},
    ["place:thendal"] = {"Thendal Village", "Thendal Grove"},
    ["place:shendar"] = {"Shen'dar Village", "Shen'dar"},
    ["place:valanaar"] = {"Valanaar"},
    ["npc:rorian"] = {"Rorian the Dayseeker", "Rorian"},
    ["npc:ayessa"] = {"Ayessa Dawnsinger", "Ayessa"},
    ["npc:halaan"] = {"Halaan Hawk-Eye"},
    ["npc:ventaari"] = {"Ventaari Brightwish"},
    ["region:skywall"] = {"Skywall"},
    ["npc:al-akir"] = {"Al'Akir", "Al'Akir the Windlord"},
    -- Batch 8: Alliance 15-35 names and the capitals.
    ["npc:volcor"] = {"Volcor"},
    ["npc:remtravel"] = {"Prospector Remtravel", "Remtravel"},
    ["npc:baros-alexston"] = {"Baros Alexston"},
    ["npc:kristoff"] = {"Brother Kristoff"},
    ["npc:marris"] = {"Marshal Marris", "Marris"},
    ["npc:sirra"] = {"Sirra Von'Indi"},
    ["npc:mountaineer-stormpike"] = {"Mountaineer Stormpike", "Gringer Stormpike"},
    ["place:stormwind-keep"] = {"Stormwind Keep", "the Royal Library"},
    ["place:lake-everstill"] = {"Lake Everstill"},
    ["place:caverns-of-time"] = {"Caverns of Time", "the Caverns of Time"},
    ["place:chillwind"] = {"Chillwind Camp", "Chillwind Point"},
}
local forever = {"region:riverglades", "place:sunnyglade", "place:farholde", "place:powderfuse-port", "dungeon:kroldok",
    "region:shendralas", "region:mount-hyjal", "raid:barrow-deeps", "raid:hyjal-summit", "battleground:darkspear-islands",
    "faction:brotherhood-horse", "npc:the-baron", "npc:viktor-vile", "npc:the-abandoned", "npc:bjork",
    "npc:lordaeron-captain", "npc:faldrim-anvilmar", "npc:magmatus", "npc:plunder",
    "people:skyborne", "faction:windshapers", "faction:high-order", "group:al-aketh", "place:thendal",
    "place:shendar", "place:valanaar", "npc:rorian", "npc:ayessa", "npc:halaan", "npc:ventaari"}
for _, id in ipairs(forever) do Check(A.GetLoreNote(id).setting == "Forever", "Forever content is labelled: " .. id) end

local total, aliases = 0, 0
for id, names in pairs(notes) do
    total = total + 1
    local note = A.GetLoreNote(id)
    Check(note and note.coverage == "curated", "reviewed note: " .. id)
    Check(note.setting == "Classic / Forever" or note.setting == "Forever", "timeline: " .. id)
    local sources = table.concat(note.sources, "\n")
    Check(sources:find("corpus_vanilla_quests.txt", 1, true) or sources:find("warcraft.wiki.gg", 1, true)
        or sources:find("blizzard.com", 1, true), "primary or wiki source: " .. id)
    if sources:find("LoreForever", 1, true) then
        Check(sources:find("LoreForever [%a]+:[%w%-]+ %(wiki: https://warcraft%.wiki%.gg/wiki/"),
            "Lore Forever citation names the entry and the wiki article: " .. id)
    end
    local body = note.body
    Check(not body:find("{[pqn]:") and not body:find("|H", 1, true), "plain body: " .. id)
    Check(not body:lower():find("%f[%a]you%f[%A]") and not body:lower():find("%f[%a]your%f[%A]"), "no reader address: " .. id)
    Check(not body:find(":", 1, true), "no colon in note prose: " .. id)
    for _, word in ipairs({"journal", "chronicle", "legend has it", "tale", "story", "chapter"}) do
        Check(not body:lower():find("%f[%a]" .. word .. "s?%f[%A]"), "no meta words: " .. id .. " / " .. word)
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

-- Prose as the packs write it links the new names, and only those.
local function Marks(text, expected)
    Check(A.MarkKnownLore(text) == expected, "annotation: " .. text .. "\n  got: " .. tostring(A.MarkKnownLore(text)))
end
Marks("Kaltunk sent new recruits to Gornek in the Den.",
    "{n:Kaltunk} sent new recruits to {n:Gornek} in {p:the Den}.")
Marks("Hana'zua had struck Sarkoth's claw.", "{n:Hana'zua} had struck {p:Sarkoth}'s claw.")
Marks("Grull Hawkwind received meat; Chief Hawkwind and Greatmother Hawkwind waited.",
    "{n:Grull Hawkwind} received meat; {n:Chief Hawkwind} and {n:Greatmother Hawkwind} waited.")
Marks("Rezlak wanted Drygulch Ravine cleared for Gazlowe.", "{n:Rezlak} wanted {p:Drygulch Ravine} cleared for {n:Gazlowe}.")
-- Shared family names, short aliases and ordinary words stay plain.
Marks("Hawkwind and Grull went to the den by the red rocks.", "Hawkwind and Grull went to the den by the red rocks.")
Marks("Telf and Grull spoke.", "Telf and Grull spoke.")
Marks("Orgnil and Sevren spoke.", "{n:Orgnil} and {n:Sevren} spoke.")
Check(A.LoreNoteResolve("p", "Hawkwind") == nil, "family name alone is ambiguous")
Check(A.LoreNoteResolve("p", "Den") == nil, "generic noun stays unlinked")
-- Forever names: ordinary words and Rivendare's title never become these foes.
Marks("Plunder was taken. The Baron waited. The Abandoned Tower stood.", "Plunder was taken. The Baron waited. The Abandoned Tower stood.")
Marks("Farholde Keep held; Krol'dok Stronghold and Sunnyglade fell to the Riverglades ogres.",
    "{p:Farholde Keep} held; {p:Krol'dok Stronghold} and {p:Sunnyglade} fell to {p:the Riverglades} ogres.")
Marks("Margoz and Hakkar.", "{n:Margoz} and {n:Hakkar}.")
Marks("Ilthalaine and Tenaron spoke of Elune at Aldrassil; the Night Watch held Darkshire.",
    "{n:Ilthalaine} and {n:Tenaron} spoke of {p:Elune} at {p:Aldrassil}; {p:the Night Watch} held {p:Darkshire}.")
Marks("Farthing and Coleman waited.", "Farthing and Coleman waited.")
Marks("Brine waited by the brine pool; Thork had the Earthmother's blessing.", "Brine waited by the brine pool; {n:Thork} had {p:the Earthmother}'s blessing.")
-- Madame Eva's public note does not name the subject of the Stalvan inquiry.
Check(not A.GetLoreNote("npc:madame-eva").body:find("Stalvan", 1, true), "Madame Eva note keeps the inquiry's subject unsaid")
Marks("The Light kept Lordaeron's faithful; the Lighthouse stood. Gath'Ilzogg held Stonewatch.",
    "The Light kept {p:Lordaeron}'s faithful; the Lighthouse stood. {n:Gath'Ilzogg} held {p:Stonewatch}.")
Marks("By the Light and the Holy Light.", "By {p:the Light} and {p:the Holy Light}.")
-- Quest titles and look-alike places that contain a new name stay plain text.
for _, title in ipairs({"Rites of the Earthmother", "Garments of the Light", "Report to Orgnil", "Elune's Tear",
    "Beat Bartleby", "Stonewatch Falls", "Raene's Cleansing", "Kurzen's Mystery", "Crest of Lordaeron"}) do
    Marks("We completed " .. title .. ".", "We completed " .. title .. ".")
end
-- Teronis is missing until his fate is learned at the lake or from Raene.
local teronis = A.GetKnownLoreNote("npc:teronis", {})
Check(teronis and not teronis.body:find("murlocs", 1, true) and teronis.body:find("not returned", 1, true), "public Teronis note keeps his fate unsaid")
Check(A.GetKnownLoreNote("npc:teronis", {["teronis.found"] = true}).body:find("cut down by murlocs", 1, true), "Teronis's fate once #991 or #1023 is known")
Check(not A.GetLoreNote("npc:raene").body:find("murloc", 1, true) and not A.GetLoreNote("npc:raene").body:find("Teronis is dead", 1, true), "Raene's note does not give away Teronis's fate")
-- The Baron's former identity is a discovery, never public context.
local baron = A.GetKnownLoreNote("npc:the-baron", {})
Check(baron and not baron.body:find("Othmar", 1, true) and not baron.body:find("Grand Marshal", 1, true), "public Baron note keeps Othmar hidden")
for _, related in ipairs(baron.related) do Check(related ~= "place:apothecarium", "public Baron links reveal nothing") end
local known = A.GetKnownLoreNote("npc:the-baron", {["baron.othmar"] = true})
Check(known.body:find("Othmar", 1, true), "Othmar is told once #97289 is known")
Check(A.GetLoreNote("npc:the-baron").body:find("Othmar", 1, true), "canonical note keeps the full source fact")
Check(A.db.sentinel == "unchanged" and next(A.db, "sentinel") == nil, "notes are read-only")
print(string.format("LoreNotesOvernight: %d checks passed; %d notes, %d names", count, total, aliases))
