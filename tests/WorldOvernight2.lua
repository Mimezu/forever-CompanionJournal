-- World lane, second overnight pass 2026-11-05 (lane world2): exact stages added
-- to LoreWorldStories.lua and LoreClassStories.lua for the mid-level shared zones,
-- hand-offs and Stormwind class chains. Checks source identity, paired prose, the
-- writing rules for quest scenes, stage boundaries, ID ownership across every
-- story pack, sentence length, and real renders in both narrators, Everything and
-- Highlights. Run from the client root with Lua 5.1; --review prints the chapters
-- (retell 0) for reading, --stats prints sentence-length figures for the new prose.
local root = "Interface/AddOns/CompanionJournal/"
function time(t) return type(t)=="table" and os.time(t) or 1792000000 end
function date(f,t) return os.date(f,t) end
local A={defaults={colors={}}}
for _,file in ipairs({"LoreData.lua","Lore.lua","LoreHordeStories.lua","LoreAllianceStories.lua","LoreWorldStories.lua","LoreClassStories.lua","LoreForeverStories.lua","JournalBook.lua","JournalTellers.lua","JournalTale.lua","JournalWords.lua","JournalSelfWords.lua","JournalSelfTale.lua"}) do
    assert(loadfile(root..file))("CompanionJournal",A)
end
local L=A.Lore
local checks,failures=0,{}
local function check(ok,message) checks=checks+1; if not ok then failures[#failures+1]=message end end
local function read(path) local f=assert(io.open(path,"rb")); local s=f:read("*a"); f:close(); return s end
local corpus=read("StorageInvestigation/journal-voice/review/corpus_vanilla_quests.txt")
local sources,repeats={},{}
for title,id,level in corpus:gmatch("### ([^\r\n]+)  %(id (%d+), level (%d+)%)") do
    sources[tonumber(id)]={title=title,level=tonumber(level)}
    repeats[title]=(repeats[title] or 0)+1
end

-- Every exact stage this pass added, by batch.
local added={
    -- W2-1: Hillsbrad (Lydon, the Crown of Will, Krusk and Gol'dir, Farren, the Go'Shek Farm)
    496,499,501,502,509,513,515,517,524,495,518,519,520,521,498,533,503,506,
    536,559,560,561,562,563,659,658,657,660,661,
    -- W2-2: Southshore and Tarren Mill around Alterac, plus the hand-offs 634, 647, 5321
    510,511,514,551,554,522,523,535,566,546,547,567,552,553,556,557,555,7321,564,500,504,676,634,647,5321,
    -- W2-3: Desolace (the Corrupter, the centaur clans and khans, Vahlarriel, the Karnitol shipwreck)
    1480,1481,1482,1484,1488,1437,1465,1438,1439,1440,1454,1455,1456,1457,
    1384,1386,1369,1370,1371,1373,1374,1375,1380,1381,1382,1385,1365,1366,1387,
    -- W2-4: Dustwallow (the Shady Rest Inn both sides, the spies and Marg Nighteye, the Sterns, Stinky, Jarl, Mud)
    1282,1284,1268,1252,1259,1269,1253,1251,1276,1273,1285,1286,1287,1288,
    1201,1202,1219,1220,1238,1239,1240,1262,1260,1258,1222,1270,1203,1206,1218,1177,
    -- W2-5: Stranglethorn (the Bloodsail plot, Cortello, Mok'thardin, Grom'gol, the three masteries)
    595,597,599,604,608,624,625,626,570,572,571,573,568,569,185,187,188,190,191,192,193,194,195,196,197,208,
    -- W2-6: hand-offs (Wailing Caverns lead-ins, 1094, 79192; class pack 1485, 1499)
    1489,1490,914,962,1486,1487,1094,79192,1485,1499,
    -- W2-7 (LoreClassStories.lua): Northshire letters and the Stormwind class chains
    3100,3101,3102,3103,3104,3105,1639,1666,1667,1698,1699,1702,1701,1700,1705,2998,1649,1650,1651,1652,1939,1938,1940,2300,2281,
    -- W2-8: Thousand Needles (the racing teams, Freewind Post, Moktar's swarm, Dorn's Final Passage)
    1394,1176,1178,1180,1181,1182,1183,1186,1187,1188,1189,1190,1194,1179,1175,1111,1112,1114,4767,4821,4865,5147,5361,1147,1148,1184,
    -- W2-9: Swamp of Sorrows (Stonard's coast, the Atal'ai exile, Biggs, Kargath's runners, Eranikus)
    698,699,1422,1426,1427,1428,1430,1429,1396,1421,1398,1425,1418,1419,1420,3374,3512,
    -- W2-10: Badlands (Hammertoe's amulet, Infernus, Agmond, Lotwil, Rigglefuzz) and Cyrus's taste of flame
    719,723,724,725,726,762,738,710,711,712,713,714,734,777,778,703,705,4022,4023,4024,
    -- W2-11: the Hinterlands (Brohann, Rhapsody, Sharpbeak) and Feralas (Latronicus, Troyas)
    1448,1449,1450,1451,1452,1469,2988,2989,2990,2992,2993,2994,2870,2871,2982,2939,2940,2941,2944,2943,2879,2942,
}
local classPack={[1485]=true,[1499]=true}
for _,id in ipairs({3100,3101,3102,3103,3104,3105,1639,1666,1667,1698,1699,1702,1701,1700,1705,2998,1649,1650,1651,1652,1939,1938,1940,2300,2281}) do classPack[id]=true end
-- Northshire letters are referrals: they reach a trainer and never claim a lesson.
local referralsW2={3100,3101,3102,3103,3104,3105,2998,1939,2300}
local pronouns={i=true,me=true,my=true,mine=true,we=true,us=true,our=true,ours=true,you=true,your=true,yours=true}
local meta={journal=true,tale=true,song=true,verse=true,chronicle=true,legend=true,bard=true,page=true,book=true,chapter=true,story=true}
local words,sentences,long=0,0,0
local function measure(line)
    for sentence in (line.." "):gmatch("(.-[%.!])%s") do
        local n=0; for _ in sentence:gmatch("%S+") do n=n+1 end
        if n>0 then sentences=sentences+1; words=words+n; if n>=18 then long=long+1 end end
    end
end
local function prose(lines,label,need)
    check(type(lines)=="table" and #lines>=(need or 2),label.." needs two variants")
    if type(lines)~="table" then return end
    check(lines[1]~=lines[2],label.." repeated variant")
    for _,line in ipairs(lines) do
        measure(line)
        check(line:match("[%.!]$")~=nil,label.." must end a sentence: "..line)
        check(not line:gsub("SI:7",""):find(":",1,true),label.." colon in narration: "..line)
        check(not line:find("?",1,true),label.." question in narration: "..line)
        check(not line:find("<",1,true) and not line:find("{",1,true),label.." raw markup: "..line)
        check(not line:find("Not only",1,true) and not line:find(", but rather",1,true),label.." banned shape: "..line)
        check(not line:find("%f[%a][Tt]he [Tt]he%f[%A]"),label.." doubled article: "..line)
        for word in line:lower():gmatch("%a+") do
            check(not pronouns[word],label.." player/narrator pronoun '"..word.."': "..line)
            check(not meta[word],label.." meta word '"..word.."': "..line)
        end
    end
end
-- Vary openings: no two consecutive sentences start with the same word, within a
-- line and across every why/after pairing the teller can choose.
local function sentencesOf(line) local out={} for s in (line.." "):gmatch("(.-[%.!])%s") do out[#out+1]=s:match("^%s*(.-)$") end return out end
local function firstWord(s) return (s:match("^(%a[%a']*)") or ""):gsub("'s$","") end
local function openings(id,lines,label)
    for _,line in ipairs(lines) do
        local ss=sentencesOf(line)
        for k=2,#ss do check(firstWord(ss[k])~=firstWord(ss[k-1]),label.." repeated opening '"..firstWord(ss[k]).."': "..line) end
    end
end
local seen={}
for _,id in ipairs(added) do
    local e=L.questStoryIDs[id]
    if e then
        openings(id,e.why,id.." why"); openings(id,e.after,id.." after"); if e.highlight then openings(id,e.highlight,id.." highlight") end
        for _,w in ipairs(e.why) do local ws=sentencesOf(w) for _,a in ipairs(e.after) do
            local as=sentencesOf(a)
            check(firstWord(as[1])~=firstWord(ws[#ws]),id.." why/after repeat '"..firstWord(as[1]).."': "..ws[#ws].." / "..as[1])
        end end
    end
    check(not seen[id],"listed twice "..id); seen[id]=true
    local q,s=L.questStoryIDs[id],sources[id]
    check(q and s,"missing authored or source record "..id)
    if q and s then
        local want=classPack[id] and "class-stories" or "world_journeys"
        check(q.pack==want,"stage "..id.." owned by "..tostring(q.pack).." instead of "..want)
        check(q.title==s.title,"source title "..id)
        check(q.level==s.level,"source level "..id)
        check(q.source and table.concat(q.source," "):find(tostring(id),1,true),"provenance "..id)
        check(L.QuestStory(q.title,id)==q,"exact stage resolves "..id)
        check(q.threadLabel==L.storyThreads[q.thread],"thread label "..id)
        prose(q.why,id.." why"); prose(q.after,id.." after")
        if q.highlight then prose(q.highlight,id.." highlight") end
        if repeats[q.title]>1 then
            local general=L.questStory[q.title]
            check(general and general~=q,"shared title needs a conservative fallback: "..q.title)
            if general and general~=q then
                prose(general.why,q.title.." fallback why"); prose(general.after,q.title.." fallback after")
                for _,line in ipairs(q.after) do
                    check(table.concat(general.after," "):find(line,1,true)==nil,"fallback copies stage outcome "..id)
                end
            end
        end
    end
end

-- Stage boundaries: an earlier stage may not claim a later one's outcome.
local boundaries={
    {id=499,want="Umpi",reject="died"},
    {id=502,want="Stanley",reject="grew"},
    {id=509,want="mudsnout",reject="keg"},
    {id=517,want="keg",reject="prisoners"},
    {id=518,want="Crushridge",reject="Mug'Thol was dead"},
    {id=519,want="Targ",reject="Mug'Thol was dead"},
    {id=520,want="Mug'Thol",reject="Sharlindra"},
    {id=498,want="Drull",reject="Strahnbrad"},
    {id=533,want="Gol'dir",reject="freed"},
    {id=503,want="freed",reject="pendant"},
    {id=506,want="Perenolde",reject="Elysa surrendered"},
    {id=559,want="heads",reject="Redpath received"},
    {id=562,want="Stormwind",reject="Samuelson"},
    {id=659,want="Quae",reject="Jorell"},
    {id=658,want="folder",reject="Jorell"},
    {id=657,want="Kinelory",reject="came back"},
    {id=660,want="Kinelory",reject="Phin"},
    {id=511,want="Dibbs",reject="Stormpike"},
    {id=514,want="Stormpike",reject="decrypted"},
    {id=551,want="Dibbs",reject="Stormpike"},
    {id=522,want="Maleb",reject="Vardus"},
    {id=552,want="rod",reject="grave"},
    {id=634,want="Nials",reject="reinforcements arrived"},
    {id=1480,want="Azrethoc",reject="dead"},
    {id=1482,want="crystal",reject="stronger"},
    {id=1484,want="Takata",reject="Azrethoc was dead"},
    {id=1437,want="wagon",reject="Dalinda"},
    {id=1465,want="pendant",reject="Dalinda"},
    {id=1438,want="Dalinda",reject="Tyranis was dead"},
    {id=1439,want="Tyranis",reject="Nijel's Point"},
    {id=1454,want="chest",reject="naga"},
    {id=1455,want="empty",reject="belongings were found"},
    {id=1456,want="naga",reject="Roetten"},
    {id=1282,want="James Hyal",reject="Reethe"},
    {id=1252,want="badge",reject="deserter"},
    {id=1269,want="Ogron",reject="arrow"},
    {id=1259,want="Tesoran",reject="Daelin"},
    {id=1285,want="Daelin",reject="Lost Point"},
    {id=1286,want="Jacken",reject="Caldwell"},
    {id=1251,want="shield",reject="Mosarn"},
    {id=1253,want="shield",reject="tauren"},
    {id=1238,want="Marg",reject="head"},
    {id=1239,want="Marg",reject="muckshell"},
    {id=1240,want="spirit",reject="pendant"},
    {id=1219,want="spy",reject="Vimes"},
    {id=595,want="map",reject="attack"},
    {id=604,want="charts",reject="cheers"},
    {id=624,want="soggy",reject="chest"},
    {id=625,want="musty",reject="chest"},
    {id=570,want="fang",reject="choker"},
    {id=571,want="sinew",reject="choker"},
    {id=187,want="tigers",reject="Master Tiger Hunter"},
    {id=192,want="Shadowmaw",reject="Bhag'thera"},
    {id=196,want="Jungle Stalkers",reject="Tethis"},
    {id=1490,want="Nara",reject="gems"},
    {id=1489,want="Hamuul",reject="Fang"},
    {id=1485,want="Ruzan",reject="taught"},
    {id=1499,want="Zureetha",reject="taught"},
    {id=1666,want="Haggard",reject="weapons"},
    {id=1698,want="Barleybrew",reject="Rethban"},
    {id=1702,want="shield",reject="mail"},
    {id=1650,want="Daphne",reject="beaten back"},
    {id=1651,want="Defias",reject="reward"},
    {id=1649,want="Rall",reject="Daphne"},
    {id=2281,want="Lucius",reject="taught"},
    {id=1181,want="Revilgaz",reject="Cozzle"},
    {id=1180,want="Lozgil",reject="blueprints"},
    {id=1187,want="booster",reject="safety"},
    {id=1188,want="Shreev",reject="course record"},
    {id=1190,want="Rizzle",reject="indurium"},
    {id=4821,want="egg",reject="Arikara"},
    {id=1148,want="Korran",reject="Warchief"},
    {id=3374,want="Itharius",reject="Umbranse"},
    {id=3512,want="augury",reject="redeemed"},
    {id=1421,want="reagents",reject="Lungertz"},
    {id=1418,want="Neeka",reject="Helgrum learned"},
    {id=723,want="amulet",reject="Karnik"},
    {id=726,want="Angor",reject="Infernus"},
    {id=777,want="cog",reject="sent"},
    {id=4022,want="molt",reject="Bael'Gar"},
    {id=2988,want="Sharpbeak",reject="Jintha'Alor"},
    {id=2990,want="feather",reject="Hexx"},
    {id=2993,want="Vilebranch",reject="parents"},
    {id=2879,want="artifact",reject="Morrow"},
    {id=1452,want="drink",reject="temple"},
    {id=1382,want="Uthek",reject="Jehn"},
    {id=1385,want="Warug",reject="Shaka"},
}
for _,id in ipairs(referralsW2) do
    local out=table.concat(L.questStoryIDs[id].after," "):lower()
    check(not out:find("taught",1,true) and not out:find("learned",1,true),"referral claims a lesson "..id)
end
for _,b in ipairs(boundaries) do
    local q=L.questStoryIDs[b.id]
    local out=table.concat(q.after," ").." "..table.concat(q.highlight or {}," ")
    check(out:find(b.want,1,true),"missing stage marker "..b.id..": "..b.want)
    check(not out:find(b.reject,1,true),"later outcome in stage "..b.id..": "..b.reject)
end
-- Title-only records never get an exact stage's resolution.
for _,sample in ipairs({{"The Crown of Will","Mug'Thol was dead"},{"The Crown of Will","Sharlindra"},{"Elixir of Agony","keg"},
    {"Elixir of Pain","Stanley"},{"Hints of a New Plague?","Phin was glad"},{"Farren's Proof","Redpath took"},
    {"Encrypted Letter","Dibbs"},{"Encrypted Letter","Syndicate"},{"Helcular's Revenge","rumbl"},{"Soothing Turtle Bisque","Jessen"},
    {"The Corrupter","Azrethoc"},{"Vahlarriel's Search","Dalinda"},{"The Karnitol Shipwreck","Roetten"},{"Khan Hratha","Warug"},
    {"Khan Hratha","Uthek"},{"Centaur Bounty","Melkins"},{"Centaur Bounty","Felgur"},
    {"The Black Shield","Mosarn confirmed"},{"Lieutenant Paval Reethe","Krog"},{"Lieutenant Paval Reethe","Tesoran"},
    {"The Deserters","Caldwell"},{"Suspicious Hoofprints","Kagoro"},{"Suspicious Hoofprints","Falgran"},{"Stinky's Escape","Mebok"},
    {"The Bloodsail Buccaneers","cheers"},{"Cortello's Riddle","chest"},{"Mok'thardin's Enchantment","choker"},{"Tiger Mastery","Sin'Dall"},
    {"Panther Mastery","Bhag'thera"},{"Raptor Mastery","Tethis"},{"Vile Familiars","Ruzan"},{"Further Instructions","Distrustful"},
    {"Encrypted Letter","Jorik"},{"The Tome of Valor","Daphne"},{"The Tome of Valor","reward"},
    {"Goblin Sponsorship","Cozzle"},{"Goblin Sponsorship","blueprints"},{"Safety First","burnt"},{"Parts of the Swarm","Belgrom"},
    {"Lack of Surplus","weapon"},{"Threat From the Sea","Tok'Kar offered"},{"Prospect of Faith","Karnik"},{"Passing Word of a Threat","Angor"},
    {"This Is Going to Be Hard","banished"},{"This Is Going to Be Hard","went wrong"},{"A Taste of Flame","Bael'Gar"},{"Study of the Elements: Rock","bracers"}}) do
    check(not table.concat(L.QuestStory(sample[1],nil).after," "):find(sample[2],1,true),"title-only leak "..sample[1].." "..sample[2])
    check(not table.concat(L.QuestStory(sample[1],999999).after," "):find(sample[2],1,true),"unknown-ID leak "..sample[1])
end

-- Every authored stage keeps the thread label its pack registered (a later pack
-- or batch must not relabel an existing thread key).
for id,v in pairs(L.questStoryIDs) do
    check(v.threadLabel==L.storyThreads[v.thread],"inherited thread label "..id)
end
-- No colon reveals or questions anywhere in the two lane packs.
for _,packID in ipairs({"world_journeys","class-stories"}) do
    local pack=L.storyPacks[packID]
    local function scan(entry,label)
        for _,field in ipairs({"why","after","highlight"}) do
            for _,line in ipairs(entry[field] or {}) do
                check(not line:gsub("SI:7",""):gsub("XT:%d",""):find(":",1,true),label.." "..field.." colon: "..line)
                check(not line:find("?",1,true),label.." "..field.." question: "..line)
            end
        end
    end
    for id,entry in pairs(pack.questIDs) do scan(entry,packID.." "..id) end
    for title,entry in pairs(pack.quests) do scan(entry,packID.." "..title) end
end

local function fingerprint(value)
    if type(value)~="table" then return type(value)..":"..tostring(value) end
    local keys,result={},{}
    for key in pairs(value) do keys[#keys+1]=key end
    table.sort(keys,function(a,b)return tostring(a)<tostring(b)end)
    for _,key in ipairs(keys) do result[#result+1]=fingerprint(key).."="..fingerprint(value[key]) end
    return "{"..table.concat(result,";").."}"
end
local scenarios={
    {name="Apothecary Lydon's elixirs",race="Scourge",class="PRIEST",faction="Horde",ids={496,499,501,502,509,513,515,517,524}},
    {name="The Crown of Will",race="Orc",class="WARRIOR",faction="Horde",ids={495,518,519,520,521}},
    {name="Krusk, Gol'dir and the pendant",race="Troll",class="HUNTER",faction="Horde",ids={498,549,533,503,506,507,508}},
    {name="Farren Orinelle's transfer",race="Human",class="PALADIN",faction="Alliance",ids={536,559,560,561,562,563}},
    {name="The Go'Shek Farm",race="Dwarf",class="HUNTER",faction="Alliance",ids={659,658,657,660,661}},
    {name="Maleb and the Syndicate",race="Human",class="MAGE",faction="Alliance",ids={510,511,514,525,505,522,523,551,554,537}},
    {name="Darthalia's Tarren Mill",race="Scourge",class="WARLOCK",faction="Horde",ids={546,567,547,549,535,552,553,556,557,566,7321}},
    {name="Redpath's Southshore",race="Dwarf",class="WARRIOR",faction="Alliance",ids={564,555,500,504,647,634}},
    {name="Hammerfall and Kerlonian",race="Orc",class="SHAMAN",faction="Horde",ids={676,5321}},
    {name="The Corrupter",race="Tauren",class="WARRIOR",faction="Horde",ids={1434,1480,1481,1482,1484,1488,5741}},
    {name="The Malems of Darnassus",race="NightElf",class="DRUID",faction="Alliance",ids={1437,1465,1438,1439,1440}},
    {name="Karnitol's chest and Pentigast's politics",race="Dwarf",class="PALADIN",faction="Alliance",ids={1454,1455,1456,1457,1387,1382,1384,1370,1373,1374,1380}},
    {name="Felgur's centaur war and the Magram",race="Orc",class="HUNTER",faction="Horde",ids={1365,1366,1367,1386,1369,1371,1375,1381}},
    {name="Vimes and the Shady Rest Inn",race="Human",class="PRIEST",faction="Alliance",ids={1282,1284,1252,1253,1319,1320,1259,1285,1286,1287,1288,1219,1220}},
    {name="Krog, Reethe and the black shield",race="Tauren",class="DRUID",faction="Horde",ids={1268,1269,1251,1321,1273,1322,1323,1276}},
    {name="Nazeer's spies and Marg Nighteye",race="Orc",class="ROGUE",faction="Horde",ids={1201,1202,1238,1239,1240,1261,1262,1270}},
    -- 1258 "... and Bugs" is left out of the renders: the companion teller names it
    -- as "turned in ... And Bugs." (engine title handling, reported to the moments lane).
    {name="The Sterns, Jarl and Mud",race="Gnome",class="MAGE",faction="Alliance",ids={1260,1222,1203,1206,1218,1177}},
    {name="The Bloodsail plot and Cortello's riddle",race="Human",class="ROGUE",faction="Alliance",ids={595,597,599,604,608,624,625,626}},
    {name="Grom'gol and Mok'thardin",race="Troll",class="SHAMAN",faction="Horde",ids={568,569,570,572,571,573}},
    {name="Nesingwary's masteries",race="Dwarf",class="HUNTER",faction="Alliance",ids={583,185,190,194,187,191,195,188,192,196,193,197,208}},
    {name="Tonga's taint and the Druids of the Fang",race="Tauren",class="DRUID",faction="Horde",ids={880,1489,1490,962,1486,1487,914}},
    {name="Ruzan's warlock and the vile familiars",race="Orc",class="WARLOCK",faction="Horde",ids={1485,1499,792}},
    {name="Fizziks's envelope and the Stepping Stones note",race="Undead",class="ROGUE",faction="Horde",ids={1093,1094,1095,79192}},
    {name="A Northshire warrior to Barleybrew's gauntlet",race="Human",class="WARRIOR",faction="Alliance",ids={3100,1638,1639,1640,1665,1666,1667,1698,1699,1702,1701,1700,1705}},
    {name="A Northshire paladin and the test of valor",race="Human",class="PALADIN",faction="Alliance",ids={3101,2998,1649,1650,1651,1652}},
    {name="A Northshire rogue and SI:7",race="Human",class="ROGUE",faction="Alliance",ids={3102,2300,2281,2282}},
    {name="Northshire mage, priest and warlock",race="Human",class="MAGE",faction="Alliance",ids={3104,3103,3105,1939,1938,1940}},
    {name="The goblin racing team",race="Orc",class="WARRIOR",faction="Horde",ids={1176,1175,1178,1180,1181,1182,1183,1186,1187,1188,1189,1190,1194}},
    {name="The gnomes' helmets and parts",race="Gnome",class="WARLOCK",faction="Alliance",ids={1179,1110,1111,1112,1114,1137}},
    {name="Freewind Post and the swarm",race="Tauren",class="HUNTER",faction="Horde",ids={4821,4865,4767,5147,1147,1148,1184,5361,1394}},
    {name="Stonard's coast and Kargath's runners",race="Orc",class="WARRIOR",faction="Horde",ids={1418,1419,1420,698,699,1422,1426,1427,1428,1430,1429}},
    {name="Watcher Biggs's caravan",race="Human",class="PALADIN",faction="Alliance",ids={1396,1421,1398,1425}},
    {name="Itharius and Eranikus",race="NightElf",class="DRUID",faction="Alliance",ids={3374,3512}},
    {name="Hammertoe's amulet and Angor Fortress",race="Dwarf",class="PRIEST",faction="Alliance",ids={719,720,723,724,725,726,738,762}},
    {name="Lotwil's shackles and Rigglefuzz",race="Gnome",class="MAGE",faction="Alliance",ids={710,713,714,711,712,734,777,778,703,705}},
    {name="Cyrus Therepentous",race="Orc",class="WARLOCK",faction="Horde",ids={3442,4022,4024}},
    {name="Brohann, Rhapsody and Sharpbeak",race="Dwarf",class="HUNTER",faction="Alliance",ids={1448,1449,1450,1451,1452,1469,2988,2989,2990,2992,2993,2994}},
    {name="Latronicus and Troyas in Feralas",race="NightElf",class="DRUID",faction="Alliance",ids={2870,2871,2982,2939,2940,2941,2944,2943,2879,2942}},
}
local base=os.time({year=2026,month=10,day=1,hour=18})
local function make(s,companion)
    local p={self=not companion,name=companion and "Reed-Review" or "WorldOvernight",charKey="WorldOvernight",race=s.race,class=s.class,faction=s.faction,pronouns="they",bond="friend",origin="together",journal={}}
    for n,id in ipairs(s.ids) do
        local q=assert(L.questStoryIDs[id],tostring(id))
        p.startLevel=p.startLevel or q.level
        local day=math.floor((n-1)/2)
        local t=base+day*86400+((n-1)%2)*5400
        p.journal[#p.journal+1]={k=companion and "group" or "play",t=t,e=t+3600,z=q.zone,pl=q.level,ol=q.level}
        p.journal[#p.journal+1]={k="quest",t=t+120,z=q.zone,d=q.title,qid=id,pl=q.level,ol=q.level}
    end
    return p
end
local function render(p,player,companion,brief,retell,voice)
    local days=A.JournalBook(p)
    p.retell=retell
    local tale=companion and A.JournalTale.Tell(p,days,voice or "we",player,brief) or A.SelfTale.Tell(p,days,brief,retell)
    local out={}
    for _,day in ipairs(days) do if tale[day.key] then out[#out+1]=A.JournalPlain(tale[day.key].text) end end
    return table.concat(out,"\n\n")
end
for _,s in ipairs(scenarios) do
    local player=make(s,false)
    for _,companion in ipairs({false,true}) do
        local p=companion and make(s,true) or player
        local before=fingerprint(p.journal)
        for _,voice in ipairs(companion and {"we","you"} or {"we"}) do
            for _,brief in ipairs({false,true}) do
                for retell=0,3 do
                    local out=render(p,player,companion,brief,retell,voice)
                    check(#out>0,s.name.." empty narrative")
                    check(out==render(p,player,companion,brief,retell,voice),s.name.." nondeterministic retell")
                    check(not out:find("{%a+}"),s.name.." unresolved placeholder")
                    check(not out:lower():find("%f[%a]the the%f[%A]"),s.name.." doubled article")
                    check(not out:gsub("%.%.%.",""):find("%.%."),s.name.." doubled stop")
                    if arg[1]=="--review" and retell==0 then
                        print("\n"..s.name.." / "..(companion and ("COMPANION "..voice) or "SOLO").." / "..(brief and "HIGHLIGHTS" or "FULL").."\n"..out)
                    end
                end
            end
        end
        check(before==fingerprint(p.journal),s.name.." mutated raw history")
    end
end
for _,message in ipairs(failures) do print(message) end
assert(#failures==0,"WorldOvernight2: "..#failures.." failed checks")
local mean=sentences>0 and words/sentences or 0
if arg[1]=="--stats" then print(string.format("new prose: %d sentences, mean %.1f words, %.0f%% of 18+ words",sentences,mean,100*long/math.max(1,sentences))) end
print("WorldOvernight2: "..checks.." checks passed; "..#added.." exact stages added this pass; "..#scenarios.." journeys, solo/companion, full/Highlights, four retells.")
