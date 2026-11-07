-- World lane, overnight pass 2026-11-05: exact stages added to LoreWorldStories.lua
-- and LoreClassStories.lua. Checks source identity, paired prose, the writing
-- rules that apply to quest scenes, stage boundaries, and real renders in both
-- narrators, Everything and Highlights. Run from the client root with Lua 5.1;
-- --review prints the full chapters (retell 0) for reading.
local root = "Interface/AddOns/CompanionJournal/"
function time(t) return type(t)=="table" and os.time(t) or 1792000000 end
function date(f,t) return os.date(f,t) end
local A={defaults={colors={}}}
for _,file in ipairs({"LoreData.lua","Lore.lua","LoreHordeStories.lua","LoreAllianceStories.lua","LoreWorldStories.lua","LoreClassStories.lua","JournalBook.lua","JournalTellers.lua","JournalTale.lua","JournalWords.lua","JournalSelfWords.lua","JournalSelfTale.lua"}) do
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
    -- batch 1: Tanaris investigation and Feathermoon's courier
    32,162,4267,4493,4494,4496,4507,4508,4509,3161,4124,4125,4127,4129,4130,4131,4135,4265,4266,
    -- batch 2: the level-sixty roads to Onyxia's lair, both factions
    4183,4184,4185,4186,4223,4224,4241,4242,4264,4282,4322,6402,6403,6501,6502,
    4903,4941,4974,6567,6569,6570,6601,6602,
    -- batch 3: the Eastern Plaguelands at level sixty
    6133,6135,6136,6022,6042,6144,6145,6146,6147,6148,6182,6183,6184,6185,6186,6187,
    5243,5212,5213,5281,5214,6026,6041,
    -- batch 4: Winterspring's ruins and the Felstone farm
    5249,5250,5244,5245,5246,5247,5248,5252,5253,979,4901,4902,5251,
    5021,5022,5023,5048,5049,5050,5051,
    -- batch 5 (LoreClassStories.lua): the warlock's level-sixty rituals
    7562,7563,7564,7623,7624,7625,7626,7627,7628,7629,7630,7601,7602,7603,7581,7582,7583,
    -- batch 6 (LoreClassStories.lua): the paladin's charger and the hunter's ancients
    7638,7670,7637,7639,7640,7641,7642,7648,7643,7645,7644,7646,7647,7632,7636,7635,7634,
    -- batch 8: Un'Goro (Linken's middle stages, Torwa's hunts, A-Me 01, Williden)
    3912,3913,3914,3941,3942,4084,4005,4289,4301,4290,4291,4292,4243,4244,4245,3884,
    -- batch 9: Silithus and the bronze dragonflight
    8286,8288,8301,8302,8303,8305,8278,8282,8283,8308,8309,8310,8321,8323,
    -- batch 10: the Defiler's weapon, Hydraxis, Kim'jael, the Fallen Hero, Firegut, the K.E.F., Theodora
    3510,3511,3602,3621,3625,3626,2621,2622,2623,6804,6805,5534,3824,3825,4122,4121,4132,4061,4063,
    -- batch 11: the Stonemaul, Trelane's items, Faldir's Cove
    1166,1168,1169,1170,1171,1172,1173,690,693,694,695,696,697,663,662,664,667,
    -- batch 12 (LoreClassStories.lua): Brill warrior trial, Zephras class referrals
    1818,1819,1820,1821,92481,92482,92483,92484,92485,92532,
    -- batch 12 (alliance hand-off): the Ashenvale stages of the Tower of Althalaxx
    967,970,973,1140,981,
}
-- A referral to a trainer never claims a lesson.
local referrals={92481,92482,92483,92484,92485,92532,1818,1820}
local pronouns={i=true,me=true,my=true,mine=true,we=true,us=true,our=true,ours=true,you=true,your=true,yours=true}
local meta={journal=true,tale=true,song=true,verse=true,chronicle=true,legend=true,bard=true,page=true,book=true,chapter=true,story=true}
local function prose(lines,label,need)
    check(type(lines)=="table" and #lines>=(need or 2),label.." needs two variants")
    if type(lines)~="table" then return end
    check(lines[1]~=lines[2],label.." repeated variant")
    for _,line in ipairs(lines) do
        check(line:match("[%.!]$")~=nil,label.." must end a sentence: "..line)
        check(not line:gsub("SI:7",""):find(":",1,true),label.." colon in narration: "..line)
        check(not line:find("?",1,true),label.." question in narration: "..line)
        check(not line:find("<",1,true) and not line:find("{",1,true),label.." raw markup: "..line)
        check(not line:find("Not only",1,true) and not line:find(", but rather",1,true),label.." banned shape: "..line)
        for word in line:lower():gmatch("%a+") do
            check(not pronouns[word],label.." player/narrator pronoun '"..word.."': "..line)
            check(not meta[word],label.." meta word '"..word.."': "..line)
        end
    end
end
local seen={}
for _,id in ipairs(added) do
    check(not seen[id],"listed twice "..id); seen[id]=true
    local q,s=L.questStoryIDs[id],sources[id]
    check(q and s,"missing authored or source record "..id)
    if q and s then
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

-- No colon reveals or questions anywhere in the two lane packs (the cleanup of
-- 2026-11-05 removed the last ones); titles are not narration and are skipped.
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

for _,id in ipairs(referrals) do
    local out=table.concat(L.questStoryIDs[id].after," "):lower()
    check(not out:find("taught",1,true) and not out:find("learned",1,true),"referral claims a lesson "..id)
end
-- Stage boundaries: an earlier stage may not claim a later one's outcome.
local boundaries={
    {id=4496,want="lure",reject="brain"},
    {id=4493,want="Un'Goro",reject="queen"},
    {id=4125,want="crest",reject="knife"},
    {id=4127,want="psychometry",reject="Woodpaw"},
    {id=4131,want="backpacks",reject="pod"},
    {id=4135,want="pod",reject="alive"},
    {id=4266,want="Zukk'ash",reject="silithid"},
    {id=4242,want="Windsor",reject="escaped"},
    {id=4282,want="tablets",reject="Stormwind"},
    {id=6402,want="army",reject="Onyxia"},
    {id=6402,want="army",reject="dragon"},
    {id=6501,want="Haleh",reject="Drakefire"},
    {id=6570,want="Emberstrife",reject="Drakkisath's blood"},
    {id=4903,want="Goretooth",reject="Rend"},
    {id=6145,want="Oracle",reject="Demetria was dead"},
    {id=6026,want="half",reject="demolition was done"},
    {id=5212,want="more",reject="Seal"},
    {id=5246,want="pages",reject="fusing"},
    {id=5247,want="fusing",reject="Fandral"},
    {id=5021,want="package",reject="Emma"},
    {id=5050,want="John",reject="freed"},
    {id=979,want="Ranshalla",reject="altar"},
    {id=7630,want="arcanite",reject="dreadsteed's spirit"},
    {id=7582,want="prison",reject="imprisoned"},
    {id=7602,want="fel fire",reject="core"},
    {id=7646,want="Darkreaver",reject="redeemed"},
    {id=7644,want="barding",reject="redeemed"},
    {id=7636,want="stave",reject="quiver"},
    {id=4005,want="Blazerunner",reject="Blazerunner fell"},
    {id=3914,want="sword",reject="remembered why"},
    {id=4291,want="glands",reject="Lar'korwi was dead"},
    {id=4244,want="casing",reject="came home"},
    {id=8305,want="sorrow",reject="Scepter"},
    {id=8278,want="Noggle",reject="satchel"},
    {id=8309,want="Rutgar",reject="elixir"},
    {id=3511,want="temper",reject="Galvan"},
    {id=3625,want="demon slayer",reject="Razelikh fell"},
    {id=4061,want="initials",reject="Argelmach"},
    {id=4122,want="Grark",reject="custody"},
    {id=1171,want="coward",reject="eggs"},
    {id=1172,want="eggs",reject="fled"},
    {id=694,want="agate",reject="phylactery"},
    {id=1140,want="soulgems",reject="Athrikus Narassin was dead"},
    {id=973,want="Ilkrud",reject="Athrikus"},
}
-- The compendium shows why[1] as a stage note: no new why[1] may carry Natalia's fate.
for _,id in ipairs({8308,8309,8310}) do
    check(not L.questStoryIDs[id].why[1]:find("Natalia",1,true) and not L.questStoryIDs[id].why[1]:find("madness",1,true),"stage note leaks Natalia's fate "..id)
end
for _,id in ipairs({7638,7670,7637,7639,7640,7641,7642,7648,7643,7645,7644,7646}) do
    local out=table.concat(L.questStoryIDs[id].after," "):lower(); check(not out:find("epic charger",1,true) and not out:find("redeemed",1,true) and not out:find("as a steed",1,true),"charger claimed before 7647: "..id)
end
-- Ritual preparations never claim the summoning knowledge they prepare.
for _,id in ipairs({7562,7563,7564,7623,7624,7625,7626,7627,7628,7629,7630,7601,7602,7581,7582}) do
    local out=table.concat(L.questStoryIDs[id].after," "):lower()
    check(not out:find("knowledge",1,true) and not out:find("taught",1,true) and not out:find("learned",1,true),"preparation claims a lesson "..id)
end
-- The Alliance SI:7 case learns that Nathanos is the Blightcaller only in 6186.
for _,id in ipairs({6182,6183,6184,6185}) do
    local q=L.questStoryIDs[id]
    for _,line in ipairs(q.after) do
        check(not (line:find("Nathanos",1,true) and line:find("Blightcaller",1,true)),"Blightcaller named as Nathanos before 6186: "..id)
    end
    check(not q.threadLabel:find("Nathanos",1,true) and not q.threadLabel:find("Blightcaller",1,true),"thread label leaks the Marris case "..id)
end
-- The court's secret is presented only by 6403 (LoreDiscoveryData prestor_identity):
-- no earlier Alliance stage, fallback or thread label may name it.
for _,id in ipairs({4183,4184,4185,4186,4223,4224,4241,4242,4264,4282,4322,6402}) do
    local q=L.questStoryIDs[id]
    local all=table.concat(q.why," ").." "..table.concat(q.after," ").." "..table.concat(q.highlight or {}," ").." "..tostring(q.threadLabel)
    check(not all:find("Onyxia",1,true) and not all:find("reptile",1,true) and not all:lower():find("dragon's",1,true),"court secret before 6403 in "..id)
end
for _,title in ipairs({"The True Masters"}) do
    local g=L.QuestStory(title,nil)
    check(not (table.concat(g.why," ")..table.concat(g.after," ")):find("Onyxia",1,true),"fallback leaks court secret")
end
for _,b in ipairs(boundaries) do
    local q=L.questStoryIDs[b.id]
    local out=table.concat(q.after," ")
    check(out:find(b.want,1,true),"missing stage marker "..b.id)
    check(not out:find(b.reject,1,true),"later outcome in stage "..b.id)
end
-- Title-only records never get an exact stage's resolution.
for _,sample in ipairs({{"The Missing Courier","gnoll teeth"},{"The Missing Courier","crest"},{"Rise of the Silithid","Zilzibin"},
    {"Rise of the Silithid","Gracina"},{"Calm Before the Storm","Staghelm"},{"Calm Before the Storm","Thrall"}}) do
    check(not table.concat(L.QuestStory(sample[1],nil).after," "):find(sample[2],1,true),"title-only leak "..sample[1].." "..sample[2])
    check(not table.concat(L.QuestStory(sample[1],999999).after," "):find(sample[2],1,true),"unknown-ID leak "..sample[1])
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
    {name="From the Gaping Chasm to the Un'Goro queen (Horde)",race="Troll",class="HUNTER",faction="Horde",ids={10,110,113,32,4494,4496,4507,4509}},
    {name="From the Gaping Chasm to the Un'Goro queen (Alliance)",race="NightElf",class="DRUID",faction="Alliance",ids={10,110,113,162,4493,4496,4507,4508}},
    {name="Feathermoon's missing courier",race="Human",class="PALADIN",faction="Alliance",ids={4124,4125,4127,4129,4130,4131,4135,4265,4266,4267}},
    {name="Windsor's evidence and the masquerade",race="Dwarf",class="WARRIOR",faction="Alliance",ids={4183,4184,4185,4186,4223,4224,4241,4242,4264,4282,4322,6402,6403,6501,6502}},
    {name="Rend, Rexxar and the Drakefire Amulet",race="Orc",class="SHAMAN",faction="Horde",ids={4903,4941,4974,6567,6569,6570,6601,6602}},
    {name="Nathanos's errands and the Scarlet Oracle",race="Scourge",class="ROGUE",faction="Horde",ids={6022,6042,6133,6135,6136,6144,6145,6146,6147,6148,5214,6026,6041}},
    {name="The Marris case",race="Human",class="PRIEST",faction="Alliance",ids={6182,6183,6184,6185,6186,6187,5243,5212,5213,5281}},
    {name="The crystal of Kel'Theril and the wildkin altar",race="NightElf",class="DRUID",faction="Alliance",ids={5249,5244,5245,5246,5247,5248,5252,5253,979,4901,4902}},
    {name="Janice Felstone's package (Alliance)",race="Human",class="WARRIOR",faction="Alliance",ids={5021,5022,5048,5050,5051}},
    {name="The dreadsteed of Xoroth",race="Gnome",class="WARLOCK",faction="Alliance",ids={7562,7563,7564,7623,7624,7625,7626,7627,7628,7629,7630,7631}},
    {name="Infernal and Doomguard",race="Orc",class="WARLOCK",faction="Horde",ids={7601,7602,7603,7581,7582,7583}},
    {name="The redemption of a charger",race="Dwarf",class="PALADIN",faction="Alliance",ids={7670,7637,7639,7640,7641,7642,7648,7645,7643,7644,7646,7647}},
    {name="Felwood's ancients",race="NightElf",class="HUNTER",faction="Alliance",ids={7632,7636,7635,7634}},
    {name="Linken's sword and the totem",race="Gnome",class="ROGUE",faction="Alliance",ids={3909,3912,3913,3914,3941,3942,4084,4005,3961}},
    {name="Torwa's hunts and A-Me 01",race="Tauren",class="HUNTER",faction="Horde",ids={3884,4289,4290,4291,4243,4244,4245,4301,4292}},
    {name="The bronze Brood and the Bronzebeard camp",race="Troll",class="PRIEST",faction="Horde",ids={8277,8278,8282,8283,8286,8288,8301,8302,8303,8305,8308,8309,8310,8321,8323}},
    {name="The Defiler's weapon",race="Orc",class="WARRIOR",faction="Horde",ids={2621,2622,2623,3509,3510,3511,3602,3621,3625,3626,3627,3628}},
    {name="Goretooth's K.E.F. and Theodora's machines",race="Troll",class="SHAMAN",faction="Horde",ids={4061,4063,4122,4121,4132,3824,3825,6804,6805,5534}},
    {name="The Stonemaul and Onyxia's eggs",race="Tauren",class="DRUID",faction="Horde",ids={1166,1168,1169,1170,1171,1172,1173}},
    {name="Trelane's items and Faldir's Cove",race="Human",class="MAGE",faction="Alliance",ids={690,663,662,664,667,693,694,695,696,697}},
    {name="The Deathguards' test in Brill",race="Scourge",class="WARRIOR",faction="Horde",ids={1818,1819,1820,1821}},
    {name="Thendal Grove's trainers",race="SkyElf",class="SHAMAN",faction="Horde",ids={92484,92481,92532}},
    {name="The Tower of Althalaxx in Ashenvale",race="NightElf",class="PRIEST",faction="Alliance",ids={967,970,973,1140,981}},
    {name="Janice Felstone's package (Horde)",race="Scourge",class="MAGE",faction="Horde",ids={5021,5023,5049,5050,5051,5251}},
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
assert(#failures==0,"WorldOvernight: "..#failures.." failed checks")
print("WorldOvernight: "..checks.." checks passed; "..#added.." exact stages added this pass; "..#scenarios.." journeys, solo/companion, full/Highlights, four retells.")
