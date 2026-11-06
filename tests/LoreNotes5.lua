-- Run from client root: lua5.1 Interface/AddOns/CompanionJournal/tests/LoreNotes5.lua
-- Fifth notes lane (notes5, 2026-11-06): notes for the people and places the 40-60 and
-- end-game scenes name most. Every note is sourced and plain; its names resolve; a reader
-- who has done no quest meets no guarded fact in a public note (the Fallen Hero's account
-- and name, Kalaran's true form, Bijou's double dealing, Kirith's fate, Trey Lightforge's
-- death, who commands the Twilight's Hammer, and others); each secret returns with the
-- exact quest that tells it. Distinctive short forms link; given names, shared names, quest
-- titles and the user's own character names do not.
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

-- 1. The new and deepened notes, and the names that must open them.
local notes = {
    ["npc:bilgewhizzle"] = {"Chief Engineer Bilgewhizzle", "Bilgewhizzle"},
    ["npc:greta-mosshoof"] = {"Greta Mosshoof"},
    ["npc:marvon"] = {"Marvon Rivetseeker", "Marvon"},
    ["npc:bijou"] = {"Operative Bijou", "Operative Bijou"},
    ["npc:lexlort"] = {"Grandmaster Lexlort", "Lexlort"},
    ["npc:kalaran"] = {"Kalaran Windblade", "Kalaran"},
    ["npc:maltrake"] = {"Squire Maltrake", "Maltrake"},
    ["npc:aurel-goldleaf"] = {"Aurel Goldleaf", "Goldleaf"},
    ["npc:dithers"] = {"Apothecary Dithers", "Dithers"},
    ["npc:arbington"] = {"Alchemist Arbington", "Arbington"},
    ["npc:araj"] = {"Araj the Summoner", "Araj"},
    ["npc:valorfist"] = {"Commander Ashlam Valorfist", "Valorfist", "Ashlam Valorfist", "Commander Valorfist"},
    ["npc:oralius"] = {"Oralius"},
    ["npc:duthorian-rall"] = {"Duthorian Rall", "Rall"},
    ["npc:fizzle-darkstorm"] = {"Fizzle Darkstorm"},
    ["npc:fizzle-brassbolts"] = {"Fizzle Brassbolts"},
    ["npc:krusk"] = {"Krusk"},
    ["npc:maleb"] = {"Magistrate Henry Maleb", "Maleb", "Henry Maleb", "Magistrate Maleb"},
    ["npc:latronicus"] = {"Latronicus Moonspear", "Latronicus"},
    ["npc:strahad"] = {"Strahad Farsan", "Strahad"},
    ["npc:viktori"] = {"Viktori Prism'Antras"},
    ["npc:katar"] = {"Katar"},
    ["npc:tokkar"] = {"Tok'Kar"},
    ["npc:kumisha"] = {"Kum'isha the Collector", "Kum'isha"},
    ["npc:razelikh"] = {"Razelikh the Defiler", "Razelikh", "the Defiler"},
    ["npc:fallen-hero"] = {"Fallen Hero of the Horde", "the Fallen Hero", "Fallen Hero", "the Fallen Hero of the Horde"},
    ["npc:marin"] = {"Marin Noggenfogger", "Noggenfogger", "Marin"},
    ["npc:sprinkle"] = {"Sprinkle"},
    ["npc:krinkle"] = {"Krinkle Goodsteel", "Krinkle", "Goodsteel"},
    ["npc:tranrek"] = {"Tran'rek"},
    ["npc:stoley"] = {"Stoley"},
    ["npc:mackinley"] = {"Sea Wolf MacKinley", "MacKinley"},
    ["npc:smotts"] = {"Captain Hecklebury Smotts", "Smotts", "Hecklebury Smotts", "Captain Smotts"},
    ["npc:barnil"] = {"Barnil Stonepot", "Barnil"},
    ["npc:nimetz"] = {"Brother Nimetz", "Nimetz"},
    ["npc:yohwa"] = {"Sergeant Yohwa", "Yohwa"},
    ["npc:obreen"] = {"Shakes O'Breen", "O'Breen", "Captain O'Breen"},
    ["npc:kryten"] = {"Apprentice Kryten", "Kryten"},
    ["npc:zardeth"] = {"Zardeth of the Black Claw", "Zardeth"},
    ["npc:furen"] = {"Furen Longbeard", "Furen"},
    ["npc:klockmort"] = {"Klockmort Spannerspan", "Klockmort"},
    ["npc:felzerul"] = {"Fel'Zerul", "Fel'zerul"},
    ["npc:ryedol"] = {"Prospector Ryedol", "Ryedol"},
    ["npc:karnik"] = {"Historian Karnik", "Karnik"},
    ["npc:goretooth"] = {"Warlord Goretooth", "Goretooth"},
    ["npc:jarkal"] = {"Jarkal Mossmeld", "Jarkal"},
    ["npc:martek"] = {"Martek the Exiled", "Martek"},
    ["npc:primal-torntusk"] = {"Primal Torntusk"},
    ["npc:itharius"] = {"Itharius"},
    ["npc:lydros"] = {"Lorekeeper Lydros", "Lydros"},
    ["npc:talo"] = {"Talo Thornhoof", "Thornhoof"},
    ["npc:leftwitch"] = {"Leftwitch"},
    ["npc:marduke"] = {"Magistrate Marduke", "Marduke"},
    ["npc:zverenhoff"] = {"Duke Nicholas Zverenhoff", "Zverenhoff", "Nicholas Zverenhoff"},
    ["npc:maxwell-tyrosus"] = {"Lord Maxwell Tyrosus", "Maxwell Tyrosus", "Lord Maxwell"},
    ["npc:korfax"] = {"Korfax"},
    ["npc:ramaladni"] = {"Ramaladni"},
    ["npc:huum"] = {"Huum Wildmane", "Huum"},
    ["group:abyssal-council"] = {"Abyssal Council", "the Abyssal Council", "Abyssal Dukes", "Abyssal Lords"},
    ["npc:ortell"] = {"Hermit Ortell", "Ortell"},
    ["npc:kirith"] = {"Lieutenant Kirith", "Kirith", "Kirith the Damned"},
    ["npc:arkonarin"] = {"Arko'narin", "Arko"},
    ["npc:trey-lightforge"] = {"Trey Lightforge"},
    ["npc:jessir"] = {"Jessir Moonbow", "Jessir"},
    ["npc:mauari"] = {"Mau'ari"},
    ["npc:trull-failbane"] = {"Trull Failbane", "Failbane"},
    ["npc:mayara"] = {"Mayara Brightwing", "Mayara"},
    ["npc:vivian-lagrave"] = {"Shadowmaster Vivian Lagrave", "Vivian Lagrave"},
    ["item:darkstone-tablet"] = {"Darkstone Tablet", "the Darkstone Tablet"},
    ["item:gauntlet-gordok-might"] = {"Gauntlet of Gordok Might", "the Gauntlet of Gordok Might"},
    ["item:felvine"] = {"Felvine", "the Felvine", "Fruit of Fertility"},
    ["npc:kariel"] = {"Kariel Winthalus", "Kariel", "Winthalus"},
    ["npc:serge-hinott"] = {"Serge Hinott", "Hinott"},
    ["place:dun-algaz"] = {"Dun Algaz", "Algaz"},
    ["place:menethil-keep"] = {"Menethil Keep"},
    ["place:ironbeards-tomb"] = {"Ironbeard's Tomb"},
    ["place:intrepid"] = {"Intrepid", "the Intrepid"},
    ["place:rolands-doom"] = {"Roland's Doom"},
    ["place:menethils-gift"] = {"Menethil's Gift"},
    ["place:argent-hold"] = {"Argent Hold", "the Argent Hold"},
    ["npc:kromcrush"] = {"Captain Kromcrush", "Kromcrush"},
    ["npc:alzzin"] = {"Alzzin the Wildshaper", "Alzzin"},
    ["npc:king-gordok"] = {"King Gordok"},
    ["npc:ras"] = {"Ras Frostwhisper"},
    -- Batch 5.
    ["faction:wastewander"] = {"Wastewander", "Wastewander nomads", "the Wastewander"},
    ["npc:scorpidsting"] = {"Caliph Scorpidsting", "Scorpidsting"},
    ["npc:andre-firebeard"] = {"Andre Firebeard"},
    ["npc:cuergo"] = {"Captain Cuergo", "Cuergo"},
    ["npc:shaky-phillipe"] = {"Shaky Phillipe", "Phillipe"},
    ["npc:gorlash"] = {"Gorlash"},
    ["npc:mokrash"] = {"Mok'rash"},
    ["npc:negolash"] = {"Negolash"},
    ["npc:sprogger"] = {"Sprogger"},
    ["faction:hatecrest"] = {"Hatecrest", "Hatecrest naga", "the Hatecrest"},
    ["group:zukkash"] = {"Zukk'ash", "the Zukk'ash", "Zukk'ash insects"},
    ["group:shadowforge"] = {"Shadowforge clan", "Shadowforge", "the Shadowforge", "Shadowforge City"},
    ["group:reclaimers"] = {"Reclaimers Inc.", "Reclaimers", "the Reclaimers"},
    ["npc:proudhorn"] = {"Windcaller Proudhorn", "Proudhorn"},
    ["place:athenaeum"] = {"Athenaeum", "the Athenaeum"},
    ["item:skeleton-key"] = {"Skeleton Key", "the Skeleton Key", "Skeleton Key to Scholomance"},
    ["npc:nara-wildmane"] = {"Nara Wildmane"},
    ["npc:gilveradin"] = {"Gilveradin Sunchaser", "Gilveradin"},
    ["npc:falfindel"] = {"Falfindel Waywarder", "Falfindel"},
    ["npc:agnar"] = {"Agnar Beastamer", "Agnar"},
    -- Deepened in batch 4.
    ["npc:alexi-barov"] = {"Alexi Barov"}, ["npc:weldon-barov"] = {"Weldon Barov"}, ["npc:calandrath"] = {"Calandrath"},
    ["npc:bor-wildmane"] = {"Bor Wildmane"}, ["npc:kibler"] = {"Kibler"}, ["npc:torwa"] = {"Torwa Pathfinder", "Torwa"},
    ["npc:linken"] = {"Linken"},
}
local hidden = {["npc:kirith"] = true}
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
Check(A.LoreNoteResolve("p", "Whelgar Excavation Site") == "place:whelgars-excavation-site", "the Whelgar spelling of the scenes")
Check(A.LoreNoteResolve("p", "the Firelord") == "npc:ragnaros" and A.LoreNoteResolve("p", "Light's Hope") == "place:lights-hope", "short names of two older notes")
Check(A.LoreNoteResolve("p", "Trebor") == nil and A.LoreNoteResolve("n", "Trebor") == nil, "no alias carries the Fallen Hero's name")
for _, shared in ipairs({"Fizzle", "Brassbolts", "Torntusk", "Lightforge", "Frostwhisper"}) do
    local id = A.LoreNoteResolve("p", shared)
    Check(not id or not notes[id], "a shared name opens none of these notes: " .. shared .. " -> " .. tostring(id))
end

-- 2. Guarded facts never reach a public note, title or body.
local guards = {
    {"the Fallen Hero's regiment and name", {"Thrall's Grasp", "Trebor"}},
    {"Kalaran's true form", {"Kalaran"}, {"black drake", "true form", "Deceiver", "was a lie"}},
    {"Bijou's double dealing", {"Bijou"}, {"Kibler", "Horde funds", "two-timing", "two timing"}},
    {"Kirith's fate", {"Kirith the Damned"}},
    {"Kirith turned demon", {"Kirith"}, {"demon", "felhound", "twisted"}},
    {"Trey Lightforge's death", {"Trey"}, {"died", "death", "remains", "tortured", "killed"}},
    {"who commands the Twilight's Hammer", {"Abyssal Council"}, {"commands the Twilight", "controls the Twilight", "commands it", "controls the Hammer", "command the Twilight"}},
    {"the Grand Crusader's nature", {"Zverenhoff"}, {"Balnazzar", "dreadlord", "demon"}},
    {"what was found of Ramaladni", {"Ramaladni"}, {"ring", "body", "was found"}},
    {"Kariel Winthalus's fate", {"Kariel"}, {"remains", "skeleton", "was found dead", "died"}},
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
    {"npc:fallen-hero", {"fallenhero.account"}, "Thrall's Grasp"},
    {"npc:fallen-hero", {"fallenhero.trebor"}, "Trebor"},
    {"npc:kalaran", {"kalaran.deceiver"}, "black drake"},
    {"npc:bijou", {"bijou.kibler"}, "Kibler"},
    {"npc:trey-lightforge", {"trey.dead"}, "died in Shadow Hold"},
    {"group:abyssal-council", {"abyssal.control"}, "command the Twilight's Hammer"},
    {"npc:huum", {"abyssal.control"}, "Abyssal Council"},
    {"npc:aurel-goldleaf", {"abyssal.control"}, "Abyssal Council"},
}
for _, r in ipairs(reveals) do
    local id, facts, phrase = r[1], r[2], r[3]
    Check(not Public(id).body:find(phrase, 1, true), "public keeps it unsaid: " .. id .. " / " .. phrase)
    Check(Known(id, facts).body:find(phrase, 1, true), "told once known: " .. id .. " / " .. phrase)
end
Check(not Known("npc:fallen-hero", {"fallenhero.account"}).body:find("Trebor", 1, true), "the account alone does not name him")
for _, case in ipairs({{"npc:fallen-hero", {"fallenhero.account", "fallenhero.trebor"}}, {"npc:kalaran", {"kalaran.deceiver"}},
    {"npc:bijou", {"bijou.kibler"}}, {"npc:kirith", {"fallenhero.account", "kirith.damned"}}, {"npc:trey-lightforge", {"trey.dead"}},
    {"group:abyssal-council", {"abyssal.control"}}}) do
    Check(Known(case[1], case[2]).body == A.GetLoreNote(case[1]).body, "the whole note once all is known: " .. case[1])
end
Check(Known("npc:kirith", {"kirith.damned"}) == nil, "Kirith stays hidden until the Fallen Hero's account names him")
Check(Known("npc:kirith", {"fallenhero.account"}) and not Known("npc:kirith", {"fallenhero.account"}).body:find("Damned", 1, true), "the account names Kirith, not his fate")
for _, related in ipairs(Public("npc:bijou").related) do Check(related ~= "npc:kibler", "public Bijou does not link Kibler") end
for _, related in ipairs(Public("npc:huum").related) do Check(related ~= "group:abyssal-council", "public Huum does not link the Council") end
for _, related in ipairs(Public("npc:aurel-goldleaf").related) do Check(related ~= "group:abyssal-council", "public Aurel does not link the Council") end
for _, related in ipairs(Public("npc:fallen-hero").related) do Check(related ~= "npc:kirith", "public Fallen Hero does not link Kirith") end

-- 3. Linking.
local function Marks(text, expected)
    Check(A.MarkKnownLore(text) == expected, "annotation: " .. text .. "\n  got: " .. tostring(A.MarkKnownLore(text)))
end
Marks("Bilgewhizzle, Marvon, Lexlort and Kalaran met Maltrake at the Bulwark.",
    "{n:Bilgewhizzle}, {n:Marvon}, {n:Lexlort} and {n:Kalaran} met {n:Maltrake} at the {p:Bulwark}.")
Marks("Greta, Aurel, Bijou, Katar, Viktori, Fizzle, Marin, MacKinley, O'Breen, Martek, Arko, Kariel, Torntusk, Brassbolts, Lightforge and Trebor waited.",
    "Greta, Aurel, Bijou, Katar, Viktori, Fizzle, Marin, MacKinley, O'Breen, Martek, Arko, Kariel, Torntusk, Brassbolts, Lightforge and Trebor waited.")
Marks("Fizzle Darkstorm, Fizzle Brassbolts, Greta Mosshoof, Aurel Goldleaf and Operative Bijou.",
    "{n:Fizzle Darkstorm}, {n:Fizzle Brassbolts}, {n:Greta Mosshoof}, {n:Aurel Goldleaf} and {n:Operative Bijou}.")
Marks("Krinkle, Smotts, Barnil, Nimetz, Yohwa, Kryten, Zardeth, Furen, Klockmort, Ryedol, Karnik, Goretooth, Jarkal and Lydros.",
    "{n:Krinkle}, {n:Smotts}, {n:Barnil}, {n:Nimetz}, {n:Yohwa}, {n:Kryten}, {n:Zardeth}, {n:Furen}, {n:Klockmort}, {n:Ryedol}, {n:Karnik}, {n:Goretooth}, {n:Jarkal} and {n:Lydros}.")
Marks("Marduke, Zverenhoff, Huum, Ortell, Kirith, Jessir, Mayara, Kromcrush, Winthalus, Hinott, Failbane, Alzzin, Korfax and Ramaladni.",
    "{n:Marduke}, {n:Zverenhoff}, {n:Huum}, {n:Ortell}, {n:Kirith}, {n:Jessir}, {n:Mayara}, {n:Kromcrush}, {n:Winthalus}, {n:Hinott}, {n:Failbane}, {n:Alzzin}, {n:Korfax} and {n:Ramaladni}.")
Marks("Sprinkle, Tran'rek, Leftwitch, Fel'Zerul, Itharius, Mau'ari, Oralius, Krusk and Tok'Kar.",
    "{n:Sprinkle}, {n:Tran'rek}, {n:Leftwitch}, {n:Fel'Zerul}, {n:Itharius}, {n:Mau'ari}, {n:Oralius}, {n:Krusk} and {n:Tok'Kar}.")
Marks("Dun Algaz, Menethil Keep, Ironbeard's Tomb, Roland's Doom, Menethil's Gift and the Whelgar Excavation Site.",
    "{p:Dun Algaz}, {p:Menethil Keep}, {p:Ironbeard's Tomb}, {p:Roland's Doom}, {p:Menethil's Gift} and {p:the Whelgar Excavation Site}.")
Marks("The Fallen Hero spoke of Razelikh.", "The {n:Fallen Hero} spoke of {n:Razelikh}.")
Marks("Wastewander, Hatecrest, Zukk'ash and Shadowforge met Scorpidsting, Cuergo, Proudhorn, Gorlash and Sprogger.",
    "{p:Wastewander}, {p:Hatecrest}, {p:Zukk'ash} and {p:Shadowforge} met {n:Scorpidsting}, {n:Cuergo}, {n:Proudhorn}, {n:Gorlash} and {n:Sprogger}.")
Marks("Shaky, Phillipe and Agnar found the Silver Skeleton Key at Light's Hope, far from the Firelord.",
    "Shaky, Phillipe and Agnar found the Silver Skeleton Key at {p:Light's Hope}, far from {n:the Firelord}.")
-- A quest title that only contains one of these names stays plain; a title that is the
-- subject's own name ("Squire Maltrake", "Tran'rek", "The Argent Hold") may open its note.
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
                if id and mine[id] and name ~= title and "The " .. name ~= title then bad[#bad + 1] = title .. " -> " .. marked end
            end
        end
    end
    table.sort(bad)
    Check(#bad == 0, "quest titles that would open a notes5 note:\n  " .. table.concat(bad, "\n  "))
end
-- Own characters and listed players never link to a namesake.
A.db.characters = {["bilgewhizzle-realm"] = {}}
A.db.people = {["krusk-otherrealm"] = {name = "Krusk-OtherRealm"}}
Marks("Bilgewhizzle and Krusk met Lexlort.", "Bilgewhizzle and Krusk met {n:Lexlort}.")
A.db.characters, A.db.people = nil, nil
Marks("Bilgewhizzle waited.", "{n:Bilgewhizzle} waited.")

Check(A.db.sentinel == "unchanged" and next(A.db, "sentinel") == nil, "notes are read-only")
print(string.format("LoreNotes5: %d checks passed; %d new or deepened notes, %d names; %d public notes guarded against %d rules",
    count, total, aliases, publicCount, #guards))
