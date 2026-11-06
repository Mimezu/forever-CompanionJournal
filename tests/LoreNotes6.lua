-- Run from client root: lua5.1 Interface/AddOns/CompanionJournal/tests/LoreNotes6.lua
-- Sixth notes lane (notes6, 2026-11-06): notes for the people and places the 20-60 scenes
-- and Forever's own quests still named without one. Every note is sourced and plain; its
-- names resolve; a reader who has done no quest meets no guarded fact in a public note
-- (Mai'Zoth's part in Kurzen's fall, what Vaelan is, Walton's desertion, why Linken came to
-- Un'Goro, whose head the Baron wears, Raleigh and Mulgris before they are named); each
-- secret returns with the exact quest that tells it. Distinctive short forms link; given
-- names, surnames, shared names, quest titles and the user's own character names do not.
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
    -- Batch 1.
    ["npc:mebok"] = {"Mebok Mizzyrix", "Mebok"}, ["npc:smitts"] = {"Tavernkeep Smitts", "Smitts"},
    ["npc:niby"] = {"Niby the Almighty", "Niby"}, ["npc:daio"] = {"Daio the Decrepit", "Daio"},
    ["npc:jaron"] = {"Jaron Stoneshaper"}, ["npc:vaelan"] = {"Vaelan"}, ["npc:maizoth"] = {"Mai'Zoth"},
    ["npc:rau"] = {"Rau Cliffrunner", "Rau"}, ["npc:nezzliok"] = {"Nezzliok the Dire", "Nezzliok"},
    ["npc:ganzulah"] = {"Gan'zulah"}, ["npc:daltry"] = {"Clerk Daltry"}, ["npc:biggs"] = {"Watcher Biggs"},
    ["npc:raleigh-devout"] = {"Raleigh the Devout"}, ["npc:raleigh"] = {"Raleigh"}, ["npc:emberstrife"] = {"Emberstrife"},
    ["place:mannoroc-coven"] = {"Mannoroc Coven", "the Mannoroc Coven"},
    ["place:lethlor-ravine"] = {"Lethlor Ravine", "Lethlor"}, ["place:grizzled-den"] = {"Grizzled Den", "the Grizzled Den"},
    ["place:cenarion-enclave"] = {"Cenarion Enclave", "the Cenarion Enclave"},
    ["place:scarlet-raven"] = {"Scarlet Raven Tavern", "Scarlet Raven", "the Scarlet Raven", "the Scarlet Raven Tavern"},
    -- Batch 2.
    ["npc:garithos"] = {"Othmar Garithos", "Grand Marshal Garithos", "Garithos", "Othmar", "Grand Marshal Othmar Garithos"},
    ["npc:ott"] = {"Ott"}, ["npc:norric"] = {"Norric Lochthane", "Norric"}, ["npc:byancie"] = {"Byancie"},
    ["npc:yorana"] = {"Yorana Windyreed", "Yorana"}, ["npc:elaadrin"] = {"Elaadrin Evengale", "Elaadrin", "Supreme Magister Elaadrin Evengale"},
    ["npc:yelmak"] = {"Yelmak"}, ["npc:thra"] = {"Thra"}, ["npc:walton"] = {"Walton"},
    ["npc:jemma-quikswitch"] = {"Jemma Quikswitch"}, ["npc:thesten"] = {"Quarrymaster Thesten", "Thesten"},
    ["npc:belgrum"] = {"Advisor Belgrum", "Belgrum"}, ["npc:stoutfist"] = {"Captain Stoutfist", "Stoutfist"},
    ["npc:prospector-stormpike"] = {"Prospector Stormpike"}, ["npc:roetten"] = {"Roetten Stonehammer", "Roetten"},
    ["npc:salfa"] = {"Salfa"}, ["npc:erelas"] = {"Erelas Ambersky", "Erelas"}, ["npc:gnoarn"] = {"Gnoarn"},
    ["npc:ozzie"] = {"Ozzie Togglevolt", "Ozzie"}, ["npc:blazerunner"] = {"Blazerunner"},
    -- Batch 3.
    ["npc:ruzzgot"] = {"Caravaneer Ruzzgot", "Ruzzgot"}, ["npc:red-jack-flint"] = {"Red Jack Flint"},
    ["npc:fiora-longears"] = {"Fiora Longears", "Fiora"}, ["npc:heralath"] = {"Heralath Fallowbrook", "Heralath"},
    ["npc:treshala"] = {"Treshala Fallowbrook", "Treshala"}, ["npc:castpipe"] = {"Master Mechanic Castpipe", "Castpipe"},
    ["npc:kernobee"] = {"Kernobee"}, ["npc:shoni"] = {"Shoni the Shilent", "Shoni"}, ["npc:tsunaman"] = {"Tsunaman"},
    ["npc:willix"] = {"Willix the Importer", "Willix"}, ["npc:veren"] = {"Veren Tallstrider", "Veren"},
    ["npc:feegly"] = {"Feegly the Exiled", "Feegly"}, ["npc:tatternack"] = {"Tatternack Steelforge", "Tatternack"},
    ["npc:bellygrub"] = {"Bellygrub"}, ["npc:blind-mary"] = {"Blind Mary"},
    ["artifact:sparklematic"] = {"Sparklematic 5200", "the Sparklematic 5200", "Sparklematic"},
    ["npc:laris"] = {"Laris Geardawdle", "Geardawdle"}, ["npc:mulgris"] = {"Mulgris"},
    -- Batch 4.
    ["npc:fin-fizracket"] = {"Fin Fizracket"}, ["npc:unbagwa"] = {"Witch Doctor Unbagwa", "Unbagwa"},
    ["npc:mokk"] = {"Mokk the Savage", "Mokk"}, ["npc:whiskey-slim"] = {"Whiskey Slim"},
    ["npc:poobah"] = {"Princess Poobah", "Poobah"}, ["npc:bloads"] = {"Privateer Bloads", "Bloads"},
    ["npc:groy"] = {"Privateer Groy", "Groy"}, ["npc:nials"] = {"Captain Nials"}, ["npc:korin-fel"] = {"Korin Fel"},
    ["npc:orkalar"] = {"Or'Kalar"}, ["npc:phizzlethorpe"] = {"Professor Phizzlethorpe", "Phizzlethorpe"},
    ["npc:draxlegauge"] = {"Doctor Draxlegauge", "Draxlegauge"}, ["npc:sigrun"] = {"Sigrun Ironhew"},
    ["npc:lucien"] = {"Lucien Tosselwrench", "Tosselwrench"}, ["npc:thogrun"] = {"Boss Tho'grun", "Tho'grun"},
    ["npc:rockbiter"] = {"Rockbiter"}, ["npc:shay"] = {"Shay Leafrunner"}, ["npc:roon-wildmane"] = {"Roon Wildmane"},
    ["npc:luglunket"] = {"Spigot Operator Luglunket", "Luglunket"},
    -- Batch 5.
    ["npc:curgle"] = {"Curgle Cranklehop", "Curgle"}, ["npc:andi-lynn"] = {"Andi Lynn"},
    ["npc:gormarok"] = {"Gor'marok the Ravager", "Gor'marok"}, ["npc:tooga"] = {"Tooga"}, ["npc:torta"] = {"Torta"},
    ["npc:malcin"] = {"Ambassador Malcin", "Malcin"}, ["npc:rimtori"] = {"Magus Rimtori", "Rimtori"},
    ["npc:agtor"] = {"Ag'tor Bloodfist", "Ag'tor"}, ["npc:zamael"] = {"Zamael Lunthistle", "Zamael"},
    ["npc:azore"] = {"Azore Aldamort", "Aldamort"}, ["npc:gurda-wildmane"] = {"Gurda Wildmane"},
    ["npc:magtoor"] = {"Magtoor"}, ["npc:galen"] = {"Galen Goodward", "Goodward"},
    ["npc:lungertz"] = {"Quartermaster Lungertz", "Lungertz"}, ["npc:orwin"] = {"Orwin Gizzmick", "Gizzmick"},
    ["npc:slagtree"] = {"Smith Slagtree", "Slagtree"}, ["npc:fraggar"] = {"Fraggar Thundermantle", "Fraggar"},
    ["npc:burninate"] = {"Master Smith Burninate", "Burninate"}, ["place:harborage"] = {"The Harborage", "Harborage", "the Harborage"},
    -- Batch 6.
    ["npc:security-chief-bilgewhizzle"] = {"Security Chief Bilgewhizzle"}, ["npc:garek"] = {"Garek"},
    ["npc:gorn"] = {"Gorn"}, ["npc:blacklash"] = {"Blacklash"}, ["npc:hematus"] = {"Hematus"},
    ["npc:nafien"] = {"Nafien"}, ["npc:krakle"] = {"Krakle"}, ["npc:tinkee"] = {"Tinkee Steamboil", "Tinkee"},
    ["npc:albagorm"] = {"Keeper Albagorm", "Albagorm"}, ["npc:dogol"] = {"Do'gol"},
}
local hidden = {["npc:raleigh"] = true, ["npc:mulgris"] = true}
local primary = {"corpus_vanilla_quests.txt", "part1_corpus.txt"}
local total, aliases = 0, 0
local meta = {"journal", "chronicle", "tale", "story", "chapter", "page", "record", "song", "verse", "bard"}
local function Prose(id, body)
    Check(not body:find("{[pqn]:") and not body:find("|H", 1, true), "plain body: " .. id)
    Check(not body:lower():find("%f[%a]you%f[%A]") and not body:lower():find("%f[%a]your%f[%A]"), "no reader address: " .. id)
    Check(not body:find(":", 1, true) and not body:find("?", 1, true), "no colon or question: " .. id)
    for _, word in ipairs(meta) do
        Check(not body:lower():find("%f[%a]" .. word .. "s?%f[%A]"), "no meta words: " .. id .. " / " .. word)
    end
end
for id, names in pairs(notes) do
    total = total + 1
    local note = A.GetLoreNote(id)
    Check(note and note.coverage == "curated", "reviewed note: " .. id)
    Check(note.setting == "Classic / Forever" or note.setting == "Forever", "timeline: " .. id)
    local sources = table.concat(note.sources, "\n")
    Check(sources:find(primary[1], 1, true) or sources:find(primary[2], 1, true), "primary source: " .. id)
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
-- Two goblins named Bilgewhizzle: the short name stays with Gadgetzan's chief engineer.
Check(A.LoreNoteResolve("p", "Bilgewhizzle") == "npc:bilgewhizzle", "Bilgewhizzle is the chief engineer")
local chief = A.GetLoreNote("npc:bilgewhizzle").body
Check(not chief:find("Andre", 1, true) and not chief:find("security chief", 1, true), "the chief engineer note no longer holds the security chief")
Check(A.GetLoreNote("npc:security-chief-bilgewhizzle").body:find("Steamwheedle Port", 1, true), "the security chief keeps Steamwheedle Port")
-- Raleigh alone is the Undercity's; the Southshore man is only ever the Devout.
Check(A.LoreNoteResolve("p", "Raleigh") == "npc:raleigh" and A.LoreNoteResolve("p", "Raleigh the Devout") == "npc:raleigh-devout", "two Raleighs")

-- 2. Guarded facts never reach a public note, title or body.
local guards = {
    {"Mai'Zoth's part in Kurzen's fall", {"Mai'Zoth"}, {"Kurzen", "corrupted"}},
    {"what Vaelan is", {"Vaelan"}, {"red flight", "red dragon", "twin orbs", "orbs of flame"}},
    {"Walton's desertion", {"Walton"}, {"deserter", "navy", "deserted"}},
    {"why Linken came to Un'Goro", {"Blazerunner"}, {"Linken", "Golden Flame"}},
    {"whose head the Baron wears", {"Garithos"}, {"Baron", "head", "abomination"}},
    {"Raleigh's charge", {"Valdred"}},
    {"the dead druid's name", {"Mulgris"}},
    {"Smitts in the Stalvan case", {"Smitts"}, {"Stalvan", "handwriting"}},
    {"Daltry in the Stalvan case", {"Daltry"}, {"Stalvan", "handwriting"}},
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
    {"npc:maizoth", {"maizoth.kurzen"}, "corrupted Colonel Kurzen"},
    {"npc:maizoth", {"yenniku.zanzil"}, "free Yenniku"},
    {"npc:vaelan", {"vaelan.red"}, "red flight"},
    {"npc:walton", {"walton.deserter"}, "deserter"},
    {"npc:blazerunner", {"linken.blazerunner"}, "Golden Flame"},
    {"npc:garithos", {"baron.othmar"}, "the Baron"},
    {"npc:garithos", {"baron.othmar", "othmar.bound"}, "Faranell"},
}
for _, r in ipairs(reveals) do
    local id, facts, phrase = r[1], r[2], r[3]
    Check(not Public(id).body:find(phrase, 1, true), "public keeps it unsaid: " .. id .. " / " .. phrase)
    Check(Known(id, facts).body:find(phrase, 1, true), "told once known: " .. id .. " / " .. phrase)
end
for _, case in ipairs({{"npc:maizoth", {"maizoth.kurzen", "yenniku.zanzil"}}, {"npc:vaelan", {"vaelan.red"}},
    {"npc:walton", {"walton.deserter"}}, {"npc:blazerunner", {"linken.blazerunner"}}, {"npc:garithos", {"baron.othmar", "othmar.bound"}},
    {"npc:raleigh", {"deliah.raleigh", "deliah.murder"}}, {"npc:mulgris", {"mulgris.named"}}}) do
    Check(Known(case[1], case[2]).body == A.GetLoreNote(case[1]).body, "the whole note once all is known: " .. case[1])
end
Check(Public("npc:garithos").title == "Grand Marshal Garithos", "the public Garithos note keeps his given name unsaid")
Check(Known("npc:garithos", {"othmar.bound"}) and not Known("npc:garithos", {"othmar.bound"}).body:find("Baron", 1, true),
    "the binding alone does not tell whose head it is")
Check(Known("npc:raleigh", {"deliah.raleigh"}) and not Known("npc:raleigh", {"deliah.raleigh"}).body:find("Valdred", 1, true),
    "Raleigh's note waits for #530 before naming the murderer")
Check(Known("npc:raleigh", {"deliah.murder"}) == nil, "Raleigh stays hidden until #441 names him")
for _, pair in ipairs({{"npc:maizoth", "npc:kurzen"}, {"npc:maizoth", "npc:nimetz"}, {"npc:vaelan", "npc:nefarian"},
    {"npc:blazerunner", "npc:linken"}, {"npc:garithos", "npc:the-baron"}, {"npc:garithos", "npc:faranell"}}) do
    for _, related in ipairs(Public(pair[1]).related) do Check(related ~= pair[2], "public " .. pair[1] .. " does not link " .. pair[2]) end
end
for _, related in ipairs(Known("npc:the-baron", {"baron.othmar"}).related) do
    if related == "npc:garithos" then count = count + 1 end
end
Check(Known("npc:deliah", {"deliah.ring", "deliah.raleigh"}).related[1] == "npc:raleigh", "Deliah's husband block opens Raleigh's note")
-- The Greymane Wall and Gilneas told Raleigh's charge to every reader before notes6.
for _, id in ipairs({"place:greymane-wall", "region:gilneas"}) do
    Check(not Public(id).body:find("Valdred", 1, true) and not Public(id).body:find("Raleigh", 1, true), "public geography only: " .. id)
    Check(Known(id, {"deliah.murder"}).body == A.GetLoreNote(id).body and A.GetLoreNote(id).body:find("Valdred", 1, true), "the charge returns with #530: " .. id)
    Prose(id, A.GetLoreNote(id).body)
end

-- 3. Linking.
local function Marks(text, expected)
    Check(A.MarkKnownLore(text) == expected, "annotation: " .. text .. "\n  got: " .. tostring(A.MarkKnownLore(text)))
end
Marks("Mebok, Smitts, Niby, Daio, Vaelan, Mai'Zoth, Rau, Nezzliok, Gan'zulah, Kindal and Emberstrife went to Lethlor.",
    "{n:Mebok}, {n:Smitts}, {n:Niby}, {n:Daio}, {n:Vaelan}, {n:Mai'Zoth}, {n:Rau}, {n:Nezzliok}, {n:Gan'zulah}, {n:Kindal} and {n:Emberstrife} went to {p:Lethlor}.")
Marks("Norric, Byancie, Yorana, Elaadrin, Yelmak, Thra, Thesten, Belgrum, Stoutfist, Roetten, Salfa, Erelas, Gnoarn, Blazerunner and Garithos.",
    "{n:Norric}, {n:Byancie}, {n:Yorana}, {n:Elaadrin}, {n:Yelmak}, {n:Thra}, {n:Thesten}, {n:Belgrum}, {n:Stoutfist}, {n:Roetten}, {n:Salfa}, {n:Erelas}, {n:Gnoarn}, {n:Blazerunner} and {n:Garithos}.")
Marks("Ruzzgot, Castpipe, Kernobee, Shoni, Tsunaman, Willix, Feegly, Tatternack, Bellygrub, Geardawdle, Heralath, Treshala, Sparklematic and Mulgris.",
    "{n:Ruzzgot}, {n:Castpipe}, {n:Kernobee}, {n:Shoni}, {n:Tsunaman}, {n:Willix}, {n:Feegly}, {n:Tatternack}, {p:Bellygrub}, {n:Geardawdle}, {n:Heralath}, {n:Treshala}, {p:Sparklematic} and {n:Mulgris}.")
Marks("Unbagwa, Mokk, Poobah, Bloads, Groy, Or'Kalar, Phizzlethorpe, Draxlegauge, Tosselwrench, Tho'grun, Rockbiter and Luglunket.",
    "{n:Unbagwa}, {p:Mokk}, {n:Poobah}, {n:Bloads}, {n:Groy}, {n:Or'Kalar}, {n:Phizzlethorpe}, {n:Draxlegauge}, {n:Tosselwrench}, {n:Tho'grun}, {n:Rockbiter} and {n:Luglunket}.")
Marks("Curgle, Gor'marok, Malcin, Rimtori, Ag'tor, Zamael, Aldamort, Magtoor, Lungertz, Gizzmick, Slagtree, Fraggar and Burninate.",
    "{n:Curgle}, {n:Gor'marok}, {n:Malcin}, {n:Rimtori}, {n:Ag'tor}, {n:Zamael}, {n:Aldamort}, {n:Magtoor}, {n:Lungertz}, {n:Gizzmick}, {n:Slagtree}, {n:Fraggar} and {n:Burninate}.")
Marks("Garek, Gorn, Blacklash, Hematus, Nafien, Krakle, Tinkee, Albagorm and Do'gol met Security Chief Bilgewhizzle.",
    "{n:Garek}, {n:Gorn}, {n:Blacklash}, {n:Hematus}, {n:Nafien}, {n:Krakle}, {n:Tinkee}, {n:Albagorm} and {n:Do'gol} met {n:Security Chief Bilgewhizzle}.")
Marks("Mannoroc Coven, Lethlor Ravine, the Grizzled Den, the Cenarion Enclave, the Scarlet Raven and the Harborage.",
    "{p:Mannoroc Coven}, {p:Lethlor Ravine}, {p:the Grizzled Den}, {p:the Cenarion Enclave}, {p:the Scarlet Raven} and {p:the Harborage}.")
-- Given names, surnames and shared names stay plain; their full names still link.
Marks("Jaron, Daltry, Biggs, Raleigh, Othmar, Ott, Walton, Jemma, Ozzie, Fiora, Veren, Laris, Sigrun, Shay, Korin, Roon, Fin, Nials, Galen, Goodward, Andi, Gurda, Tooga, Torta and Quentin waited.",
    "Jaron, Daltry, Biggs, Raleigh, Othmar, Ott, Walton, Jemma, Ozzie, Fiora, Veren, Laris, Sigrun, Shay, Korin, Roon, Fin, Nials, Galen, Goodward, Andi, Gurda, Tooga, Torta and Quentin waited.")
Marks("Jaron Stoneshaper, Clerk Daltry, Watcher Biggs, Raleigh the Devout, Ozzie Togglevolt and Sigrun Ironhew.",
    "{n:Jaron Stoneshaper}, {n:Clerk Daltry}, {n:Watcher Biggs}, {n:Raleigh the Devout}, {n:Ozzie Togglevolt} and {n:Sigrun Ironhew}.")
-- A quest title that only contains one of these names stays plain; a title that is the
-- subject's own name ("Mai'Zoth", "Emberstrife", "The Grizzled Den") may open its note.
do
    local mine = {}
    for id in pairs(notes) do mine[id] = true end
    local seen, bad = {}, {}
    for _, file in ipairs({"StorageInvestigation/journal-voice/review/corpus_vanilla_quests.txt", "StorageInvestigation/journal-voice/part1_corpus.txt"}) do
        local h = io.open(file)
        local corpus = h and h:read("*a") or ""
        if h then h:close() end
        for title in corpus:gmatch("\n### (.-)  %(id %d+") do seen[title] = seen[title] or false end
        for title in corpus:gmatch("\n### %d+ (.-) %(lvl") do seen[title] = seen[title] or false end
    end
    for title in pairs(seen) do
        local marked = A.MarkKnownLore(title)
        for kind, name in marked:gmatch("{([pn]):([^}]*)}") do
            local id = A.LoreNoteResolve(kind, name)
            if id and mine[id] and name ~= title and "The " .. name ~= title then bad[#bad + 1] = title .. " -> " .. marked end
        end
    end
    table.sort(bad)
    Check(#bad == 0, "quest titles that would open a notes6 note:\n  " .. table.concat(bad, "\n  "))
end
-- Own characters and listed players never link to a namesake.
A.db.characters = {["vaelan-realm"] = {}}
A.db.people = {["gorn-otherrealm"] = {name = "Gorn-OtherRealm"}}
Marks("Vaelan and Gorn met Garek.", "Vaelan and Gorn met {n:Garek}.")
A.db.characters, A.db.people = nil, nil
Marks("Vaelan waited.", "{n:Vaelan} waited.")

Check(A.db.sentinel == "unchanged" and next(A.db, "sentinel") == nil, "notes are read-only")
print(string.format("LoreNotes6: %d checks passed; %d new notes, %d names; %d public notes guarded against %d rules",
    count, total, aliases, publicCount, #guards))
