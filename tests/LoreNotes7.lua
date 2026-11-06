-- Run from client root: lua5.1 Interface/AddOns/CompanionJournal/tests/LoreNotes7.lua
-- Seventh notes lane (notes7, 2026-11-06): notes for the people, places and groups the
-- 20-60 scenes and Forever's own quests still named without one. Every note is sourced and
-- plain; its names resolve; a reader who has done no quest meets no guarded fact in a
-- public note (Agmond's death, his last report and his last word, Murdaloc at all,
-- Magatha's fear for Cairne and Motega's doubt of it); each secret returns with the exact
-- quest that tells it. Distinctive short forms link; given names, words, shared names,
-- quest titles and the user's own character names do not.
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
    ["npc:talen"] = {"Talen"}, ["npc:piznik"] = {"Piznik"}, ["npc:drum-fel"] = {"Drum Fel"},
    ["npc:scooty"] = {"Chief Engineer Scooty", "Scooty"}, ["npc:seereth"] = {"Seereth Stonebreak", "Seereth"},
    ["npc:marukai"] = {"Marukai"}, ["npc:daryn-lightwind"] = {"Daryn Lightwind"}, ["npc:trevan-rol"] = {"Trevan Rol"},
    ["place:hive-regal"] = {"Hive'Regal"}, ["place:hive-zora"] = {"Hive'Zora"}, ["place:hive-ashi"] = {"Hive'Ashi"},
    ["place:shrine-aessina"] = {"Shrine of Aessina", "the Shrine of Aessina"},
    ["place:irontree-woods"] = {"Irontree Woods", "the Irontree Woods"}, ["place:sorrow-hill"] = {"Sorrow Hill"},
    ["place:strahnbrad"] = {"Strahnbrad"}, ["place:thunder-axe-fortress"] = {"Thunder Axe Fortress"},
    ["place:ethel-rethor"] = {"Ethel Rethor"},
    -- Batch 2.
    ["npc:agmond"] = {"Prospector Agmond", "Agmond"}, ["npc:murdaloc"] = {"Murdaloc"},
    ["npc:ironband"] = {"Prospector Ironband", "Ironband"}, ["npc:arikara"] = {"Arikara"},
    ["npc:nekrosh"] = {"Nek'rosh", "Chieftain Nek'rosh"}, ["npc:valstag"] = {"Valstag Ironjaw", "Valstag"},
    ["npc:karl-boran"] = {"Karl Boran"}, ["npc:darsok"] = {"Darsok Swiftdagger", "Darsok"},
    ["npc:orendil"] = {"Orendil Broadleaf", "Orendil"}, ["npc:sanath"] = {"Sanath Lim-yo", "Sanath"},
    ["npc:jd-collie"] = {"J.D. Collie"}, ["npc:cliffwatcher-longhorn"] = {"Cliffwatcher Longhorn"},
    ["npc:xavathras"] = {"Xavathras"}, ["npc:hagar"] = {"Hagar Lightninghoof"},
    -- Batch 3.
    ["place:ruins-constellas"] = {"Ruins of Constellas", "the Ruins of Constellas", "Constellas"},
    ["place:winterfall-village"] = {"Winterfall Village"}, ["place:high-wilderness"] = {"High Wilderness", "the High Wilderness"},
    ["place:slag-pit"] = {"Slag Pit", "the Slag Pit"}, ["place:night-run"] = {"Night Run"},
    ["place:uplands"] = {"Uplands", "the Uplands"}, ["place:camp-kosh"] = {"Camp Kosh"},
    ["place:warpwood-quarter"] = {"Warpwood Quarter", "the Warpwood Quarter"}, ["place:tainted-scar"] = {"Tainted Scar", "the Tainted Scar"},
    ["faction:foulweald"] = {"Foulweald", "the Foulweald", "Foulweald furbolgs"},
    ["faction:emerald-circle"] = {"Emerald Circle", "the Emerald Circle"},
    -- Batch 4.
    ["npc:canaga"] = {"Canaga Earthcaller", "Canaga"}, ["npc:kranal"] = {"Kranal Fiss", "Kranal"},
    ["npc:prate"] = {"Prate Cloudseer", "Prate"}, ["npc:bruegs"] = {"Bruegs Kindleborn", "Bruegs"},
    ["npc:braldir"] = {"Braldir Ashmantle", "Braldir"}, ["npc:hervdana"] = {"Hervdana Saegrund", "Hervdana"},
    ["npc:mathrengyl"] = {"Mathrengyl Bearwalker", "Mathrengyl"}, ["npc:overspark"] = {"Tinkmaster Overspark", "Overspark"},
    ["npc:ruuzel"] = {"Ruuzel"}, ["npc:serena-bloodfeather"] = {"Serena Bloodfeather"},
    ["place:spirit-rock"] = {"Spirit Rock"}, ["place:stendels-pond"] = {"Stendel's Pond"},
    -- Batch 5.
    ["npc:tarrel"] = {"Tarrel Rockweaver", "Tarrel"}, ["npc:rockgar"] = {"Mountaineer Rockgar", "Rockgar"},
    ["npc:ashlan"] = {"Ashlan Stonesmirk", "Stonesmirk"}, ["npc:kanati"] = {"Kanati Greycloud"},
    ["npc:noboru"] = {"Noboru the Cudgel"}, ["npc:oilfist"] = {"Overseer Oilfist", "Oilfist"},
    ["npc:hansel"] = {"Hansel Heavyhands"}, ["npc:bashana"] = {"Bashana Runetotem", "Bashana"},
    ["npc:nightlash"] = {"Nightlash"}, ["npc:smeed"] = {"Smeed Scrabblescrew", "Smeed"},
    ["npc:bibbly"] = {"Bibbly F'utzbuckle", "Bibbly"}, ["npc:umbranse"] = {"Umbranse the Spiritspeaker", "Umbranse"},
    ["npc:grundig"] = {"Grundig Darkcloud", "Grundig"},
    -- Batch 6.
    ["place:thistlefur-village"] = {"Thistlefur Village"}, ["place:valley-of-spears"] = {"Valley of Spears"},
    ["place:pool-of-tears"] = {"Pool of Tears", "the Pool of Tears"}, ["place:boulderfist-hall"] = {"Boulderfist Hall"},
    ["place:stonemaul-ruins"] = {"Stonemaul Ruins", "the Stonemaul Ruins"}, ["place:fungal-vale"] = {"Fungal Vale", "the Fungal Vale"},
    ["place:northridge-lumber-mill"] = {"Northridge Lumber Mill", "the Northridge Lumber Mill"},
    ["place:rage-scar-hold"] = {"Rage Scar Hold", "Rage Scar"}, ["place:grommash-hold"] = {"Grommash Hold"},
    --@BATCHES@
}
local hidden = {["npc:murdaloc"] = true}
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
-- Daryn Lightwind is a woman in every quest that names her (#2939 "talk to her").
Check(A.GetLoreNote("npc:daryn-lightwind").body:find("studied many subjects in her time", 1, true), "Daryn Lightwind is a historian, she")

-- 2. Guarded facts never reach a public note, title or body.
local guards = {
    {"Agmond dead", {"Agmond"}, {"dead", "death", "died", "bones", "remains", "killed", "Murdaloc"}},
    {"Agmond's last report", {"Agmond"}, {"last report", "his diggers"}},
    {"Murdaloc at all", {"Murdaloc"}},
    {"Magatha's fear for Cairne", {"Arikara"}, {"Cairne", "High Chieftain", "stalking", "heinous"}},
    {"Motega's doubt", {"Arikara"}, {"makes no sense", "could not be wrong", "explanation"}},
    {"Natalia in Hive'Regal", {"Hive'Regal"}, {"Natalia", "C'Thun"}},
    {"the Malem siblings", {"Thunder Axe Fortress"}, {"Tyranis", "Dalinda", "sacrifice"}},
    {"the Night Run soulgems", {"Night Run"}, {"soulgem", "Athrikus"}},
    {"what drives the Winterfall", {"Winterfall Village"}, {"Xandivious", "demon", "firewater"}},
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
    {"npc:agmond", {"agmond.dead"}, "Agmond is dead"},
    {"npc:agmond", {"agmond.urns"}, "ancient urns"},
    {"npc:agmond", {"agmond.murdaloc"}, "Murdaloc"},
    {"npc:agmond", {"agmond.avenged"}, "sobering news"},
    {"npc:murdaloc", {"agmond.murdaloc"}, "beside the dead hand"},
    {"npc:murdaloc", {"agmond.murdaloc", "agmond.avenged"}, "the troggs killed Agmond"},
    {"npc:arikara", {"arikara.heinous"}, "heinous acts"},
    {"npc:arikara", {"arikara.cairne"}, "Cairne Bloodhoof"},
    {"npc:arikara", {"arikara.doubt"}, "makes no sense"},
}
for _, r in ipairs(reveals) do
    local id, facts, phrase = r[1], r[2], r[3]
    Check(not Public(id) or not Public(id).body:find(phrase, 1, true), "public keeps it unsaid: " .. id .. " / " .. phrase)
    Check(Known(id, facts).body:find(phrase, 1, true), "told once known: " .. id .. " / " .. phrase)
end
for _, case in ipairs({{"npc:agmond", {"agmond.dead", "agmond.urns", "agmond.murdaloc", "agmond.avenged"}},
    {"npc:murdaloc", {"agmond.murdaloc", "agmond.avenged"}}, {"npc:arikara", {"arikara.heinous", "arikara.cairne", "arikara.doubt"}}}) do
    Check(Known(case[1], case[2]).body == A.GetLoreNote(case[1]).body, "the whole note once all is known: " .. case[1])
end
-- Exact stages: the offer of #5088 tells Magatha's fear, only its completion tells Motega's doubt;
-- the urns are Ironband's word in #704, the word in the sand is #739's.
do
    local function Facts(presented, completed)
        local ledger = {completed = {}, presented = {}}
        for _, q in ipairs(presented) do ledger.presented[q] = {origin = "quest-detail"} end
        for _, q in ipairs(completed) do ledger.completed[q] = {origin = "quest-turn-in"} end
        A.Me = function() return "reader-realm" end
        A.db.characters = {["reader-realm"] = {loreDiscoveries = ledger}}
        local k = A.LoreKnowledge()
        A.db.characters, A.Me = nil, nil
        return k
    end
    local k = Facts({5088}, {})
    Check(k["arikara.cairne"] and not k["arikara.doubt"], "#5088 offered: Magatha's fear only")
    Check(A.GetKnownLoreNote("npc:arikara", k).body:find("Cairne", 1, true) and not A.GetKnownLoreNote("npc:arikara", k).body:find("makes no sense", 1, true),
        "Motega's doubt waits for the #5088 completion")
    k = Facts({}, {5088})
    Check(k["arikara.doubt"] and k["arikara.cairne"], "#5088 completed: both")
    k = Facts({}, {738})
    Check(k["agmond.dead"] and not k["agmond.murdaloc"] and not k["agmond.urns"], "#738 shows the bones, not the word or the urns")
    Check(A.GetKnownLoreNote("npc:murdaloc", k) == nil, "Murdaloc stays hidden after #738 alone")
    k = Facts({739}, {})
    Check(k["agmond.murdaloc"] and not k["agmond.avenged"], "#739 offered: the word, not Ironband's verdict")
    Check(A.GetKnownLoreNote("npc:murdaloc", k) and not A.GetKnownLoreNote("npc:murdaloc", k).body:find("troggs killed", 1, true),
        "Murdaloc's note opens with the word and waits for the verdict")
    k = Facts({}, {704})
    Check(k["agmond.urns"] and k["agmond.dead"] and not k["agmond.murdaloc"], "#704 tells the urns and the death, not the word")
end
for _, pair in ipairs({{"npc:agmond", "npc:murdaloc"}, {"npc:agmond", "faction:stonevault"}, {"npc:arikara", "npc:cairne"}}) do
    for _, related in ipairs(Public(pair[1]).related) do Check(related ~= pair[2], "public " .. pair[1] .. " does not link " .. pair[2]) end
end
Check(Known("npc:agmond", {"agmond.murdaloc"}).related[1] == "npc:murdaloc", "the word in the sand opens Murdaloc's note")

-- 3. Linking.
local function Marks(text, expected)
    Check(A.MarkKnownLore(text) == expected, "annotation: " .. text .. "\n  got: " .. tostring(A.MarkKnownLore(text)))
end
Marks("Talen, Piznik, Scooty, Seereth and Marukai met Drum Fel, Daryn Lightwind and Trevan Rol.",
    "{n:Talen}, {n:Piznik}, {n:Scooty}, {n:Seereth} and {n:Marukai} met {n:Drum Fel}, {n:Daryn Lightwind} and {n:Trevan Rol}.")
Marks("Hive'Regal, Hive'Zora, Hive'Ashi, the Shrine of Aessina, the Irontree Woods, Sorrow Hill, Strahnbrad, Thunder Axe Fortress and Ethel Rethor.",
    "{p:Hive'Regal}, {p:Hive'Zora}, {p:Hive'Ashi}, {p:the Shrine of Aessina}, {p:the Irontree Woods}, {p:Sorrow Hill}, {p:Strahnbrad}, {p:Thunder Axe Fortress} and {p:Ethel Rethor}.")
Marks("Agmond, Murdaloc, Ironband, Arikara, Nek'rosh, Valstag, Darsok, Orendil, Sanath and Xavathras met J.D. Collie, Karl Boran, Cliffwatcher Longhorn and Hagar Lightninghoof.",
    "{n:Agmond}, {n:Murdaloc}, {n:Ironband}, {n:Arikara}, {n:Nek'rosh}, {n:Valstag}, {n:Darsok}, {n:Orendil}, {n:Sanath} and {n:Xavathras} met {n:J.D. Collie}, {n:Karl Boran}, {n:Cliffwatcher Longhorn} and {n:Hagar Lightninghoof}.")
Marks("Ironband's dig lay by Ironband's Excavation.", "{n:Ironband}'s dig lay by {p:Ironband's Excavation}.")
Marks("Constellas, the Uplands, Night Run, Camp Kosh, the Slag Pit, the High Wilderness, the Warpwood Quarter, the Tainted Scar and Winterfall Village.",
    "{p:Constellas}, {p:the Uplands}, {p:Night Run}, {p:Camp Kosh}, {p:the Slag Pit}, {p:the High Wilderness}, {p:the Warpwood Quarter}, {p:the Tainted Scar} and {p:Winterfall Village}.")
Marks("The Foulweald and the Emerald Circle.", "The {p:Foulweald} and {p:the Emerald Circle}.")
-- Given names and words stay plain; the full names still link.
Marks("Trevan, Daryn, Drum, Hagar, Karl and Longhorn waited.", "Trevan, Daryn, Drum, Hagar, Karl and Longhorn waited.")
Marks("Canaga, Kranal, Bruegs, Braldir, Hervdana, Mathrengyl, Overspark and Ruuzel met Prate Cloudseer and Serena Bloodfeather at Spirit Rock and Stendel's Pond.",
    "{n:Canaga}, {n:Kranal}, {n:Bruegs}, {n:Braldir}, {n:Hervdana}, {n:Mathrengyl}, {n:Overspark} and {n:Ruuzel} met {n:Prate Cloudseer} and {n:Serena Bloodfeather} at {p:Spirit Rock} and {p:Stendel's Pond}.")
Marks("Prate and Serena waited.", "Prate and Serena waited.")
Marks("Tarrel, Rockgar, Stonesmirk, Oilfist, Bashana, Nightlash, Smeed, Bibbly, Umbranse and Grundig met Kanati Greycloud, Noboru the Cudgel and Hansel Heavyhands.",
    "{n:Tarrel}, {n:Rockgar}, {n:Stonesmirk}, {n:Oilfist}, {n:Bashana}, {n:Nightlash}, {n:Smeed}, {n:Bibbly}, {n:Umbranse} and {n:Grundig} met {n:Kanati Greycloud}, {n:Noboru the Cudgel} and {n:Hansel Heavyhands}.")
Marks("Kanati, Noboru and Hansel waited.", "Kanati, Noboru and Hansel waited.")
Marks("Thistlefur Village, the Valley of Spears, the Pool of Tears, Boulderfist Hall, the Stonemaul Ruins, the Fungal Vale, the Northridge Lumber Mill, the yeti of Rage Scar and Grommash Hold.",
    "{p:Thistlefur Village}, the {p:Valley of Spears}, {p:the Pool of Tears}, {p:Boulderfist Hall}, {p:the Stonemaul Ruins}, {p:the Fungal Vale}, {p:the Northridge Lumber Mill}, the yeti of {p:Rage Scar} and {p:Grommash Hold}.")
--@MARKS@
-- A quest title that only contains one of these names stays plain; a title that is the
-- subject's own name ("Murdaloc", "Arikara", "Chief Engineer Scooty", "The High Wilderness") may open its note.
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
    Check(#bad == 0, "quest titles that would open a notes7 note:\n  " .. table.concat(bad, "\n  "))
end
-- Own characters and listed players never link to a namesake.
A.db.characters = {["talen-realm"] = {}}
A.db.people = {["arikara-otherrealm"] = {name = "Arikara-OtherRealm"}}
Marks("Talen and Arikara met Piznik.", "Talen and Arikara met {n:Piznik}.")
A.db.characters, A.db.people = nil, nil
Marks("Talen waited.", "{n:Talen} waited.")

Check(A.db.sentinel == "unchanged" and next(A.db, "sentinel") == nil, "notes are read-only")
print(string.format("LoreNotes7: %d checks passed; %d new notes, %d names; %d public notes guarded against %d rules",
    count, total, aliases, publicCount, #guards))
