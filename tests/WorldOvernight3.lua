-- World lane, third overnight pass 2026-11-05 (lane world3): exact stages added
-- to LoreWorldStories.lua and LoreClassStories.lua (Stranglethorn's rebel camp and
-- the Stone of the Tides, Searing Gorge, the Burning Steppes, Horde Hinterlands and
-- Feralas, Desolace, dungeon chains, thin class chains). Same checks as
-- WorldOvernight2: source identity, paired prose, writing rules, stage boundaries,
-- pack ownership, and real renders in both narrators, Everything and Highlights.
-- Run from the client root with Lua 5.1; --review prints the chapters (retell 0),
-- --stats prints sentence-length figures for the new prose.
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
    -- W3-1: Stranglethorn rebel camp, Kaleb's crock pot, the Stone of the Tides, Drizzlik
    198,215,328,329,330,331,210,627,622,616,578,601,602,603,610,611,575,577,628,
    -- W3-2: the Missing Diplomat in Theramore, Desolace referrals, the Gizelton caravan, Leftwitch's reagents, Brother Anton
    1264,1265,1266,1362,1453,5821,5943,1458,1459,1466,1467,6141,261,1052,
    -- W3-3: Searing Gorge (Locheed, Pebblebitty, the Suntara Stones, Kalaran, the Thorium Brotherhood postings)
    4449,4450,4451,3181,3367,3368,3372,3566,3441,7728,7729,7723,7724,7727,7701,
    -- W3-4: Desolace coast and valleys; Burning Steppes roads (Archesonus, Oralius, Goretooth, Lotwil)
    6142,6143,5386,5381,5581,6027,6132,6134,5501,3701,3702,4283,4081,4082,4062,
    -- W3-5: Blackrock Depths (Gor'shak and Thrall, Magni and Kharan, Screwspigot, Thunderbrew Lager, Nagmara, Pyron and Incendius)
    3981,3982,4001,4002,4341,4342,4361,4324,4136,4128,4126,4133,4134,4201,3906,3907,4262,
    -- W3-6: Revantusk Village (Katoom, Markhor, Otho, Yayo'jin, the Torntusks, the guard captain's post)
    7816,7815,7828,7829,7830,7849,7841,7842,7843,7844,7850,7845,7846,7847,7862,
    -- W3-7: Camp Mojache (the muisek vessel, Krueg and Belgrom, Rok Orhan, Talo Thornhoof) and the yeti hides
    3121,3122,3125,3124,3126,3127,3128,3129,2976,2979,3063,3062,4120,2821,2822,7733,7734,
    -- W3-8: Oglethorpe's robots, Zorbin's shrinker, Nimboya and the Witherbark venom to Shadra, Rin'ji's tablet
    351,648,485,836,2766,2767,7003,7721,7725,7726,2932,2933,2934,2935,2936,2937,2938,2742,2782,
    -- W3-9: Stranglethorn (Nesingwary's manuscript parts, the Bloodscalp heads, the Mind's Eye, Trollbane, Kebok, Zanzil's mixture, the gamblers' debts, robbed sailors)
    339,340,341,342,585,586,591,598,638,189,213,209,621,609,613,587,576,
    -- W3-10: early dungeons (Deadmines, Shadowfang for the Forsaken, the Stockade, Ragefire Chasm, Wailing Caverns finds)
    214,168,167,2040,1098,1014,386,377,387,388,378,391,5722,5724,5725,959,6981,
    -- W3-11: Theldurin the Lost (the Scroll of Myzrael's fragments, Yagyin's Digest through Gerrig or Bel'dugur)
    692,727,728,735,736,737,
    -- W3-C1 (LoreClassStories.lua): requested class referrals and trials (Menara, Klockmort, Muren, Fray Island, Orm, Bink, Anastasia, Dendrite, Tiza, Rall)
    4736,4738,1704,1708,1679,1681,1718,1840,1844,1879,1959,27,6126,2997,2999,3000,3681,
    -- W3-C2 (LoreClassStories.lua, plus 5930 in the world pack): priests' rites, Rall at forty, the Hidden Circle, the Great Bear Spirit
    5642,5643,5673,5675,4486,2238,5930,
    -- W3-12: Blackfathom Deeps both factions; the Scarlet Monastery errands
    6562,6563,1198,1275,1199,6565,824,1200,6561,6921,6922,1048,1049,1050,1051,1053,
    -- W3-13: Uldaman (Baelog, Khaz'mul, the Tablet of Will, power stones, magenta caps, the dead paladin's necklace both factions)
    2398,2240,1139,2418,17,2202,2198,2199,2200,2201,2204,2283,2284,2318,2338,2339,2340,2341,
    -- W3-14: Zul'Farrak errands, Maraudon errands, the Sunken Temple (Fel'Zerul, Brohann)
    2770,2846,2991,3042,2864,2865,7028,7029,7041,7067,1444,1445,1475,
}
local classPack={}
for _,id in ipairs({4736,4738,1704,1708,1679,1681,1718,1840,1844,1879,1959,27,6126,2997,2999,3000,3681,5642,5643,5673,5675,4486,2238}) do classPack[id]=true end
-- Referrals reach a trainer and never claim a lesson, form or spell.
local referralsW3={4736,4738,1679,1718,1840,1879,1959,27,6126,2997,2999,3000,3681,5642,5643,5673,5675,4486}
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
    {id=198,want="land mines",reject="traitor"},
    {id=215,want="traitor",reject="Merle"},
    {id=329,want="note",reject="Merle"},
    {id=330,want="Merle",reject="betrayed"},
    {id=331,want="Merle",reject="dead"},
    {id=210,want="price",reject="bloodstone"},
    {id=616,want="Stone of the Tides",reject="curse"},
    {id=578,want="curse",reject="bracers"},
    {id=602,want="residue",reject="dagger"},
    {id=603,want="Bloodsail",reject="Duncan"},
    {id=610,want="Duncan",reject="altar"},
    {id=575,want="skins",reject="Undermine"},
    {id=1264,want="Samaul",reject="Hendel was"},
    {id=1265,want="justice",reject="arrest"},
    {id=1266,want="Hendel",reject="Defias"},
    {id=1458,want="horns",reject="demon"},
    {id=1466,want="Roetten",reject="paid"},
    {id=261,want="Crusade",reject="Raleigh"},
    {id=6141,want="Anton",reject="Valley of Bones"},
    {id=4449,want="silk",reject="key"},
    {id=3367,want="letter",reject="Lathoric"},
    {id=3368,want="Thorius",reject="betray"},
    {id=3372,want="altar",reject="brother"},
    {id=3181,want="Pebblebitty",reject="gate opened"},
    {id=5381,want="Demon Box",reject="banished"},
    {id=4081,want="Goretooth",reject="third"},
    {id=4062,want="Lotwil",reject="Argelmach"},
    {id=6132,want="Hornizz",reject="ghost"},
    {id=3981,want="Gor'shak",reject="princess"},
    {id=4342,want="nothing he could",reject="Dagran"},
    {id=4341,want="Kharan",reject="husband"},
    {id=4361,want="Magni",reject="child"},
    {id=3906,want="Pyron",reject="Ragnaros"},
    {id=4262,want="Incendius",reject="Ragnaros"},
    {id=4128,want="recipe",reject="Hurley"},
    {id=7845,want="alive",reject="free"},
    {id=7846,want="free",reject="Primal"},
    {id=7842,want="step",reject="Aerie Peak"},
    {id=7850,want="Hexx",reject="sacrifice"},
    {id=3127,want="collection",reject="weapon"},
    {id=3128,want="materials",reject="weapon"},
    {id=3063,want="Talo",reject="Edana"},
    {id=351,want="repairs",reject="savior"},
    {id=485,want="Oglethorpe",reject="savior"},
    {id=2766,want="Oglethorpe",reject="savior"},
    {id=2935,want="Gadrin",reject="Elortha"},
    {id=2936,want="Elortha",reject="venom at last"},
    {id=2742,want="tablet",reject="Oran"},
    {id=339,want="first part",reject="finale"},
    {id=585,want="Nezzliok",reject="Zanzil"},
    {id=586,want="Ana'thek",reject="Yenniku was"},
    {id=591,want="ritual",reject="freed"},
    {id=609,want="Maury",reject="key"},
    {id=5722,want="Maur",reject="satchel"},
    {id=1098,want="Vincent",reject="Arugal"},
    {id=387,want="Thelwater",reject="Thredd"},
    {id=692,want="Myzrael",reject="bound again"},
    {id=727,want="brother",reject="relic"},
    {id=735,want="relics",reject="Theldurin"},
    {id=27,want="trials",reject="aquatic form was"},
    {id=1844,want="helm",reject="wore"},
    {id=5930,want="bear",reject="bear form"},
    {id=1198,want="Thaelrid",reject="Kelris"},
    {id=6563,want="crystals",reject="Lorgus"},
    {id=2200,want="diary",reject="power source"},
    {id=2201,want="gems",reject="fusing"},
    {id=2284,want="diary",reject="Jarkal"},
    {id=2339,want="power source",reject="two necklaces"},
    {id=2991,want="Sharpbeak",reject="found Sharpbeak"},
    {id=2864,want="shells",reject="lifesaver"},
    {id=1444,want="Fel'Zerul",reject="fetishes were"},
}
for _,id in ipairs(referralsW3) do
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
for _,sample in ipairs({{"The Missing Diplomat","king"},{"The Missing Diplomat","King"},{"The Missing Diplomat","Hendel"},
    {"Reagents for Reclaimers Inc.","Roetten"},{"Reagents for Reclaimers Inc.","demon"},{"Down the Scarlet Path","Raleigh"},{"Suntara Stones","shot"},{"Suntara Stones","betray"},{"Suntara Stones","vow"},{"The Smoldering Ruins of Thaurissan","explained"},{"The Rise of the Machines","white"},{"What Is Going On?","Thrall saw"},{"What Is Going On?","guards"},{"The Mark of Quality","Pratt"},{"The Mark of Quality","Jangdor"},{"Improved Quality","Rage Scar hides would"},{"The Star, the Hand and the Heart","Gerrig"},{"The Star, the Hand and the Heart","Bel'dugur"},{"The Star, the Hand and the Heart","order"},{"In Search of Menara Voidrender","Briarthorn"},{"In Search of Menara Voidrender","Demisette"},{"Tome of Divinity","Tiza"},{"Shadowguard","Ur'kyo said"},{"Elune's Grace","swift"},{"Great Bear Spirit","new wisdom"},{"Blackfathom Villainy","Selgorm"},{"Blackfathom Villainy","Bashana"},{"Translating the Journal","Jarkal"},{"Uldaman Reagent Run","restorative"},{"Vyletongue Corruption","healed"}}) do
    check(not table.concat(L.QuestStory(sample[1],nil).after," "):find(sample[2],1,true),"title-only leak "..sample[1].." "..sample[2])
    check(not table.concat(L.QuestStory(sample[1],nil).why," "):find(sample[2],1,true),"title-only setup leak "..sample[1].." "..sample[2])
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
    {name="Thorsen and the traitor",race="Human",class="WARRIOR",faction="Alliance",ids={198,203,215,200,328,329,330,331}},
    {name="Kaleb's crock pot",race="Dwarf",class="HUNTER",faction="Alliance",ids={210,627,622}},
    {name="The Stone of the Tides",race="Gnome",class="MAGE",faction="Alliance",ids={616,578,601,602,603,610,611}},
    {name="Drizzlik's Excelsior boots",race="Orc",class="ROGUE",faction="Horde",ids={575,577,628}},
    {name="Hendel in Theramore",race="Human",class="PALADIN",faction="Alliance",ids={1249,1250,1264,1265,1266,1324}},
    {name="Kreldig's reagents and the caravan",race="Dwarf",class="WARRIOR",faction="Alliance",ids={1453,1458,5821,1459,1454,5943,1466,1467}},
    {name="Brother Anton's recruitment",race="Human",class="PRIEST",faction="Alliance",ids={6141,261,1052}},
    {name="Locheed's outhouse",race="Gnome",class="ROGUE",faction="Alliance",ids={4449,4450,4451}},
    {name="The Suntara Stones",race="Dwarf",class="PALADIN",faction="Alliance",ids={3181,3367,3368,3372,3566}},
    {name="Kalaran and the Thorium Brotherhood",race="Orc",class="WARRIOR",faction="Horde",ids={3441,3442,7728,7729,7723,7724,7727,7722,7701}},
    {name="Shadowprey and Mannoroc",race="Troll",class="HUNTER",faction="Horde",ids={6142,6143,5386,5381,5581,6027}},
    {name="The Brimbuzzles and Bibbly",race="Gnome",class="WARLOCK",faction="Alliance",ids={6132,6134,5501}},
    {name="Archesonus and Oralius",race="Dwarf",class="PRIEST",faction="Alliance",ids={3702,3701,4283,4182}},
    {name="Goretooth's postings and the G.L.A. shard",race="Orc",class="WARRIOR",faction="Horde",ids={4081,4061,4062,4082,4063}},
    {name="Gor'shak and the Warchief",race="Orc",class="WARRIOR",faction="Horde",ids={4081,3981,3982,4001,4002,4003,4004}},
    {name="Magni and Kharan",race="Dwarf",class="PALADIN",faction="Alliance",ids={4262,4341,4342,4361,4362,4363}},
    {name="Thunderbrew Lager, both sides",race="Dwarf",class="HUNTER",faction="Alliance",ids={4128,4126,4123,4201}},
    {name="Vivian, the Screwspigots and Thunderheart",race="Undead",class="MAGE",faction="Horde",ids={4133,4134,4324,4136,3906,3907}},
    {name="Revantusk's hunters and messages",race="Troll",class="HUNTER",faction="Horde",ids={7816,7815,7828,7829,7830,7841,7842,7843,7844}},
    {name="The Torntusks and Malkhor",race="Orc",class="SHAMAN",faction="Horde",ids={7850,7845,7846,7847,7849,7862}},
    {name="The muisek vessel",race="Troll",class="SHAMAN",faction="Horde",ids={3121,3122,3125,3124,3126,3127,3128,3129}},
    {name="Camp Mojache's grudges",race="Tauren",class="HUNTER",faction="Horde",ids={2973,2976,2978,2979,3063,3062,4120,2822,7734}},
    {name="Pratt's yeti hides",race="NightElf",class="DRUID",faction="Alliance",ids={2821,7733}},
    {name="Oglethorpe's robots",race="Gnome",class="WARRIOR",faction="Alliance",ids={351,648,485,836,2766,2767}},
    {name="Zorbin's Ultra-Shrinker",race="Undead",class="WARLOCK",faction="Horde",ids={7003,7721,7725,7726}},
    {name="The venom of Shadra",race="Undead",class="ROGUE",faction="Horde",ids={2932,2933,2934,2935,2936,2937,2938,2742,2782}},
    {name="Nesingwary's manuscript",race="Dwarf",class="HUNTER",faction="Alliance",ids={339,340,341,342,338}},
    {name="The Darkspear and the Bloodscalp heads",race="Troll",class="PRIEST",faction="Horde",ids={581,582,584,585,598,586,588,589,591,592,638}},
    {name="Kebok, Crank and the gamblers",race="Human",class="ROGUE",faction="Alliance",ids={189,213,209,621,609,613,587,576}},
    {name="The Deadmines and the Stockade",race="Human",class="WARRIOR",faction="Alliance",ids={214,168,167,2040,386,377,387,388,378,391}},
    {name="Shadowfang and Ragefire for the Horde",race="Undead",class="MAGE",faction="Horde",ids={5722,5724,5725,959,6981,1098,1014}},
    {name="Theldurin and Gerrig",race="Dwarf",class="PRIEST",faction="Alliance",ids={692,709,727,735,737}},
    {name="Theldurin and Bel'dugur",race="Undead",class="WARLOCK",faction="Horde",ids={709,728,736,737}},
    {name="A dwarf warrior from Muren to Klockmort",race="Dwarf",class="WARRIOR",faction="Alliance",ids={1679,1681,1702,1704,1708,1718}},
    {name="A tauren warrior's brutal helm",race="Tauren",class="WARRIOR",faction="Horde",ids={1840,1844}},
    {name="Alliance warlocks to Menara",race="Human",class="WARLOCK",faction="Alliance",ids={4736,4738}},
    {name="Mages to Bink and Anastasia",race="Gnome",class="MAGE",faction="Alliance",ids={1879,1959}},
    {name="A druid to Moonglade",race="NightElf",class="DRUID",faction="Alliance",ids={6126,27}},
    {name="Dwarf paladins to Tiza and Rall",race="Dwarf",class="PALADIN",faction="Alliance",ids={2997,2999,3000,3681}},
    {name="Priests called home",race="Troll",class="PRIEST",faction="Horde",ids={5642,5643}},
    {name="A night elf priest and a dwarf rogue",race="NightElf",class="PRIEST",faction="Alliance",ids={5673,5675,2238}},
    {name="A druid and the Great Bear Spirit",race="Tauren",class="DRUID",faction="Horde",ids={5921,5930}},
    {name="Rall at forty",race="Human",class="PALADIN",faction="Alliance",ids={4485,4486}},
    {name="Blackfathom for the Alliance",race="NightElf",class="PRIEST",faction="Alliance",ids={1198,1275,1199,1200}},
    {name="Blackfathom for the Horde",race="Orc",class="SHAMAN",faction="Horde",ids={1918,824,6562,6563,6565,6921,6922,6561}},
    {name="The Scarlet Monastery errands",race="Undead",class="PRIEST",faction="Horde",ids={1051,1049,1048}},
    {name="Raleigh's charge",race="Human",class="PALADIN",faction="Alliance",ids={6141,261,1052,1050,1053}},
    {name="Baelog and Talvash",race="Dwarf",class="WARRIOR",faction="Alliance",ids={2398,2240,2202,2198,2199,2200,2201,2204,1139}},
    {name="Droffers and Jarkal",race="Orc",class="ROGUE",faction="Horde",ids={2418,17,2283,2284,2318,2338,2339,2340,2341}},
    {name="Zul'Farrak errands",race="Gnome",class="ROGUE",faction="Alliance",ids={2770,2846,2990,2991,3042,2864,2865}},
    {name="Maraudon and the Sunken Temple",race="Troll",class="MAGE",faction="Horde",ids={7028,7041,7067,7044,1444,1445}},
    {name="Brohann's last task",race="Dwarf",class="HUNTER",faction="Alliance",ids={1448,1475,7029}},
    {name="Felgur's Kolkar campaign",race="Orc",class="SHAMAN",faction="Horde",ids={1362,1365,1366}},
}
local base=os.time({year=2026,month=10,day=1,hour=18})
local function make(s,companion)
    local p={self=not companion,name=companion and "Reed-Review" or "WorldOvernight",charKey="WorldOvernight3",race=s.race,class=s.class,faction=s.faction,pronouns="they",bond="friend",origin="together",journal={}}
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
                    check(not out:find("%.%."),s.name.." doubled stop")
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
assert(#failures==0,"WorldOvernight3: "..#failures.." failed checks")
local mean=sentences>0 and words/sentences or 0
if arg[1]=="--stats" then print(string.format("new prose: %d sentences, mean %.1f words, %.0f%% of 18+ words",sentences,mean,100*long/math.max(1,sentences))) end
print("WorldOvernight3: "..checks.." checks passed; "..#added.." exact stages added this pass; "..#scenarios.." journeys, solo/companion, full/Highlights, four retells.")
