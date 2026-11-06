-- Band 50-60 and end game, 2026-11-06 (lane band5060): the level 50-60 zones,
-- the high dungeons, attunements, raid quests and level-sixty class quests in
-- LoreWorldStories.lua and LoreClassStories.lua, read as connected journeys per
-- faction. Checks: source identity, paired prose, the writing rules, stage
-- boundaries, pack ownership, and real renders in both narrators, Everything and
-- Highlights. Run from the client root with Lua 5.1; --review prints the chapters
-- (retell 0), --stats prints sentence-length figures for the touched prose.
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

-- Every exact stage this lane rewrote or added, by batch (world pack unless listed in classPack).
local touched={
    -- B-1 Un'Goro: the crystals and pylons, Ringo, Williden
    4284,4285,4287,4288,4321,4492,4491,
    -- B-2 Felwood: the Jadefire, Greta and Shadow Hold, the felbound flute, the Timbermaw
    4421,5157,5159,5165,4441,4442,5242,8460,8461,8462,8465,8464,
    -- B-3 Winterspring: Donova and the Winterfall, Ursius, the mechanical yeti, Ranshalla
    5054,5082,3783,977,5163,5083,5084,5085,5086,5087,5121,5123,979,
    -- B-4 Silithus: Noggle, the Twilight's Hammer tablet, Natalia, the glyphed prism
    8277,8284,8279,8320,8285,8287,8304,8306,8314,8315,
    -- B-5 End game: the Molten Core, the rift, the Seal of Ascension, Atiesh
    6822,6824,7487,7848,4742,4743,9251,9257,
    -- B-6 Plaguelands: Darrowshire, Tirion, Hameya, the watchtowers and cauldrons briefing
    5149,5721,5211,5206,5941,5942,5846,5848,5944,5542,5543,5544,5742,5781,5845,6024,5097,5215,
    -- B-7 Scholomance, Stratholme, Dire Maul and the raids: Betina, Eva, Egan, Azj'Tordin, Hakkar, C'Thun, Kel'Thuzad
    5531,5529,4771,5382,5515,5384,5282,7441,8183,8801,8802,9120,9121,9122,9123,
    -- B-8 The Defiler, Hakkar's egg and temple, Linken, Blackrock Depths, the Steppes
    3627,3628,3528,4788,3844,3845,3908,3961,3962,4123,3801,3802,4263,4296,4726,
    -- N-1 new: Blackrock Spire chains (Helendis's worgs, Kibler, Tinkee's eggs, Ridgewell, Lagrave, Ragged John, Bijou, Finkle, Maxwell)
    4701,4729,4734,4735,4764,4765,4766,4768,4769,4866,4867,4981,4982,4983,5001,5002,5047,5081,5089,5102,
    -- N-2 new: Felwood (Xavaric's flute, blood amber, the ancient spirit, corrupted sabers, wildkin, Greta's water, Arko'narin, Mulgris, ritual totems)
    939,4101,4102,4261,4505,4506,4521,4741,4721,4906,4984,4985,4986,4987,5156,5158,5202,5203,5204,5385,8470,8471,
    -- N-3 new: Winterspring (Mau'ari, Krakle and Donova's springs, Kelek, Meggi, Erelas's feathers, Jaron's camp, Kibler's spiders, the wildkin necklace, the frostsaber trainer)
    969,975,974,980,4842,5128,6603,978,4861,4863,4864,6604,4862,4882,4883,4970,5055,5056,5057,5201,
    -- N-4 new: Scholomance and Stratholme (the Skeleton Key, the Barovs, Ras Frostwhisper, Zverenhoff's champion, Ramstein, Betina's scale)
    838,5533,964,5537,5514,5538,5801,5802,5341,5343,5342,5344,5461,5462,5463,5464,5465,5466,5262,5263,5264,5265,6163,5582,
    -- N-5 new: Dire Maul (the Gordok king, the ogre suit, the Felvine, the Shen'dralar, Kariel Winthalus, Hydraxis's coffer, Quel'Serrar)
    1318,7703,5518,5527,5526,7461,7462,7877,7481,7482,7486,7507,7508,7509,
    -- N-6 new: Silithus and the end game (Cenarion Hold's war, Calandrath, the Abyssal Council, field duty, scouts, templars, dukes, Morna, Narain, Vaelastrasz, Eranikus, Malfurion's ring, Xandivious, the Timbermaw peace, the Qiraji dragons, Ossirian, the colossi, silithyst)
    8275,8276,8280,8281,8307,8313,8317,8318,8331,8332,8341,8343,8348,8349,8351,8352,8361,8498,8507,8731,8534,8738,8739,8535,8536,8537,8737,8538,8740,8728,8729,8730,8733,8734,8735,8736,8741,8446,8447,8481,8484,8485,8519,8829,8784,8789,8790,8791,8857,8858,8859,9419,9422,
    -- N-7 new: the Blasted Lands (Kum'isha, the Fallen Hero's account, the eighteen stones, Kirith, Trebor, Loramus)
    2521,2522,3501,3502,2783,2784,2801,2681,2701,2702,2721,2743,2744,3141,
    -- N-8 new: the Sunken Temple (Eranikus's gem, Itharius, Marvon's stone circle and the idol's eye)
    3373,3374,3380,3445,3444,3446,3447,
    -- N-9 new: the Plaguelands (Araj, the call to arms, Sorrow Hill, Jessica, Araj's scarab, the termites, Sylvanas's champion, the Hearthglen scout, Zaeldarr, Gregor, Umbranse, the widow, Augustus, the necropolises, Ramaladni, Omarion)
    105,211,5066,5090,5091,5094,5095,5092,5098,5601,5803,5804,5901,5902,6389,5903,5904,6390,5961,6004,6023,6025,6021,6028,6029,6030,6162,6164,9033,9085,9153,9154,9229,9230,9233,9292,
    -- N-10 new: Un'Goro (the Circle's soil and morrowgrain, Jonespyre, the expedition's bones and hives, Muigin and Larion, Oralius, the slime samples, Spraggle, the apprentice, Shizzle, super sticky tar)
    3762,3784,3763,3789,3790,3761,3764,3781,3782,3785,3786,3787,3788,3791,3882,3883,4141,4142,4143,4145,4147,4146,4286,4293,4294,4501,4502,4503,4504,
    -- C-1 class pack rewrites at 52-60 (the Fallen Hero's warrior, Ogtinc, Ravenholdt, Xylem, Lydros, the dreadsteed, Valorfist's paladin, Bath'rah, Impsy)
    8425,8151,8232,8236,8254,8255,8256,8257,8253,7463,7631,8417,8423,8424,8415,8414,8416,8418,8233,8234,8235,8250,8251,8252,8410,8411,8412,8413,8419,8420,8421,8422,
    -- C-2 class pack new: Strahad and the felsteed, the Orb of Orahil, the mage's robes and wand, Tabetha's grudge, Serge Hinott, Torwa's toxin
    1798,2996,3001,3631,4487,4488,4489,4490,4965,4967,4968,4969,1799,4961,4962,4963,4964,4975,1920,1921,1961,1943,1947,1948,1951,1955,1957,2861,2479,2480,9063,9052,9053,
}
local classPack={}
for _,id in ipairs({8425,8151,8232,8236,8254,8255,8256,8257,8253,7463,7631,8417,8423,8424,8415,8414,8416,8418,8233,8234,8235,8250,8251,8252,8410,8411,8412,8413,8419,8420,8421,8422,
    1798,2996,3001,3631,4487,4488,4489,4490,4965,4967,4968,4969,1799,4961,4962,4963,4964,4975,1920,1921,1961,1943,1947,1948,1951,1955,1957,2861,2479,2480,9063,9052,9053}) do classPack[id]=true end
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
local function sentencesOf(line) local out={} for s in (line.." "):gmatch("(.-[%.!])%s") do out[#out+1]=s:match("^%s*(.-)$") end return out end
local function firstWord(s) return (s:match("^(%a[%a']*)") or ""):gsub("'s$","") end
local function openings(id,lines,label)
    for _,line in ipairs(lines) do
        local ss=sentencesOf(line)
        for k=2,#ss do check(firstWord(ss[k])~=firstWord(ss[k-1]),label.." repeated opening '"..firstWord(ss[k]).."': "..line) end
    end
end
local seen={}
for _,id in ipairs(touched) do
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
    {id=4284,want="crystals",reject="pylon"},
    {id=4288,want="pylon",reject="manual"},
    {id=4492,want="Ringo",reject="Marshal's Refuge"},
    {id=5157,want="water",reject="braziers went"},
    {id=5165,want="brazier",reject="Fel'dan"},
    {id=4441,want="water",reject="broke"},
    {id=5083,want="Donova",reject="Deadwood"},
    {id=5084,want="cauldron",reject="toxic"},
    {id=5087,want="crate",reject="chief"},
    {id=5121,want="chief",reject="log"},
    {id=3783,want="fur",reject="horns"},
    {id=977,want="horns",reject="Legacki"},
    {id=8460,want="Timbermaw",reject="Nafien"},
    {id=8465,want="Salfa",reject="thinned"},
}
for _,b in ipairs(boundaries) do
    local q=L.questStoryIDs[b.id]
    local out=table.concat(q.after," ").." "..table.concat(q.highlight or {}," ")
    check(out:find(b.want,1,true),"missing stage marker "..b.id..": "..b.want)
    check(not out:find(b.reject,1,true),"later outcome in stage "..b.id..": "..b.reject)
end
-- Title-only records never get an exact stage's resolution.
for _,sample in ipairs({{"Are We There, Yeti?","Legacki"},{"Are We There, Yeti?","horns"},{"It's a Secret to Everybody","Donova"},{"Seal of Ascension","was finished"},{"The Name of the Beast","Razelikh"},{"Fragments of the Past","fusing"},{"Of Love and Family","Renfray's spirit"},{"Attunement to the Core","Lothos confirmed"},{"The Dread Citadel - Naxxramas","waiving"},{"The True Masters","Prestor"},{"The Brood of Onyxia","Tharg as"}}) do
    check(not table.concat(L.QuestStory(sample[1],nil).after," "):find(sample[2],1,true),"title-only leak "..sample[1].." "..sample[2])
    check(not table.concat(L.QuestStory(sample[1],nil).why," "):find(sample[2],1,true),"title-only setup leak "..sample[1].." "..sample[2])
    check(not table.concat(L.QuestStory(sample[1],999999).after," "):find(sample[2],1,true),"unknown-ID leak "..sample[1])
end
-- Discovery boundaries: Prestor is named as Onyxia only from 6403; Moira's child only from 4004/4363.
for _,id in ipairs({4185,4186,4223,4224,4241,4242,4264,4282,4322,6402}) do
    local q=L.questStoryIDs[id]
    local all=table.concat(q.why," ").." "..table.concat(q.after," ")
    check(not all:find("Onyxia",1,true),"Onyxia named before the Masquerade in "..id)
end
for _,id in ipairs({4003,4362}) do
    local all=table.concat(L.questStoryIDs[id].why," ").." "..table.concat(L.questStoryIDs[id].after," ")
    check(not all:find("child",1,true) and not all:find("husband",1,true),"Moira's secret before its stage in "..id)
end
-- Every authored stage keeps the thread label its pack registered.
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
-- Two connected journeys, one per faction, in the order a level 50-60 character
-- would meet the work; the end game follows the zones.
local scenarios={
    -- Alliance
    {name="A1 Un'Goro: Williden, the crystals, Ringo",race="Gnome",class="MAGE",faction="Alliance",ids={3884,3881,4284,4285,4287,4288,4321,4492,4491}},
    {name="A2 Un'Goro: Torwa, Karna's ape",race="Dwarf",class="HUNTER",faction="Alliance",ids={4289,4301,4290,4291,4292,4243,4244,4245}},
    {name="A3 Felwood: the Emerald Circle and Shadow Hold",race="NightElf",class="DRUID",faction="Alliance",ids={4421,5155,5157,5159,5165,5242,4441,4442}},
    {name="A4 The Timbermaw and Donova",race="NightElf",class="HUNTER",faction="Alliance",ids={8460,8461,8462,8465,8464,5082,5083,5084,5085,5086,5087,5121,5123}},
    {name="A5 Winterspring: Ursius, the yeti, Ranshalla, Kel'Theril",race="Gnome",class="WARLOCK",faction="Alliance",ids={5054,3783,977,5163,979,5244,5245,5246,5247,5248,5252,5253}},
    {name="A6 The western cauldrons",race="Dwarf",class="PRIEST",faction="Alliance",ids={5097,5215,5216,5217,5219,5220,5222,5223,5225,5226}},
    {name="A7 Darrowshire",race="Human",class="PALADIN",faction="Alliance",ids={5142,5149,5152,5153,5154,5210,5241,5168,5181,5211,5206,5941,5721,5942}},
    {name="A8 Tirion Fordring",race="Human",class="PALADIN",faction="Alliance",ids={5542,5543,5544,5742,5781,5845,5846,5848,5861,5862,5944}},
    {name="A9 The Argent Dawn in Stratholme and Scholomance",race="Human",class="PRIEST",faction="Alliance",ids={5243,5212,5213,5251,5281,5282,5529,5531,4771,5382,5515,5384}},
    {name="A10 Windsor and the Masquerade",race="Human",class="WARRIOR",faction="Alliance",ids={4182,4183,4184,4185,4186,4223,4224,4241,4242,4264,4282,4322,6402,6403,6501,6502}},
    {name="A11 Magni and Moira",race="Dwarf",class="PALADIN",faction="Alliance",ids={4262,4341,4342,4361,4362,4363}},
    {name="A12 Silithus: Noggle, the Twilight's Hammer, Natalia",race="NightElf",class="HUNTER",faction="Alliance",ids={8277,8278,8282,8283,8284,8279,8285,8287,8323,8320,8321,8304,8306}},
    {name="A13 Hydraxis, the Core, the Scepter, Atiesh",race="Dwarf",class="PALADIN",faction="Alliance",ids={6804,6805,6821,7487,6822,6823,6824,8286,8288,8301,8302,8303,8305,9251,9257}},
    {name="A14 Blackrock Spire: Maxwell's strike",race="Human",class="WARRIOR",faction="Alliance",ids={4701,4766,4764,4765,4734,4735,5001,5002,5081,5089,5102}},
    {name="A15 Felwood: Eridan, Greta's water, Arko'narin, Mulgris",race="NightElf",class="PRIEST",faction="Alliance",ids={939,4101,4906,4261,5156,5158,5202,5203,5204,5385,4984,4985,4986,8470}},
    {name="A16 Winterspring: Krakle's springs, Jaron's camp, the wildkin necklace, Mau'ari",race="Gnome",class="MAGE",faction="Alliance",ids={974,980,6603,4842,978,4861,4863,4864,6604,4882,969,975,5128}},
    {name="A17 The Skeleton Key and the Barovs, for the Alliance",race="Human",class="WARRIOR",faction="Alliance",ids={5533,5537,5538,5801,5343,5344}},
    {name="A18 Ras Frostwhisper, Zverenhoff's champion, the Argent Hold",race="Dwarf",class="PRIEST",faction="Alliance",ids={5582,5461,5462,5463,5464,5465,5466,5262,5263,5264,5265}},
    {name="A19 Silithus: Cenarion Hold's war and the Abyssal Council",race="Human",class="PALADIN",faction="Alliance",ids={8275,8280,8281,8307,8313,8317,8318,8507,8534,8739,8498,8740,8331,8332,8343,8348,8349,8361,8341,8351,8352,8538,8829,8784,8789,8791,9419}},
    {name="A20 The Scepter's shards: Narain, Vaelastrasz, Eranikus, the Timbermaw peace",race="NightElf",class="DRUID",faction="Alliance",ids={8728,8729,8730,8733,8734,8735,8736,8741,8446,8447,8519,8481,8484}},
    {name="A22 The Plaguelands campaign for the Alliance: Valorfist, the scout, the Scourge's return",race="Dwarf",class="PALADIN",faction="Alliance",ids={5066,5092,6004,6023,6025,5901,5902,6389,5601,6028,6030,6164,211,5803,9154,9153,9085,9292,9033,9229,9230,9233}},
    {name="A23 Un'Goro for the Alliance: Staghelm's morrowgrain, Jonespyre, the refuge's inventors",race="NightElf",class="DRUID",faction="Alliance",ids={3763,3764,3781,3785,3787,3791,3882,3883,4141,4142,4143,4501,4502,4503,4504}},
    -- Horde
    {name="H21 Un'Goro for the Horde: Hamuul's morrowgrain, Larion, the Forsaken slimes, Oralius",race="Tauren",class="SHAMAN",faction="Horde",ids={3762,3761,3782,3786,3788,4145,4147,4146,4293,4294,4286}},
    {name="H20 The Plaguelands campaign for the Horde: Derrington, the termites, Sylvanas's champion",race="Orc",class="SHAMAN",faction="Horde",ids={5094,5098,5903,5904,6390,5961,6021,6029,6162,105,5804}},
    {name="H18 Silithus for the Horde: field duty, the templars, the colossi, silithyst",race="Troll",class="HUNTER",faction="Horde",ids={8276,8731,8738,8535,8536,8537,8737,8790,8857,8858,8859,9422,8485}},
    {name="H16 The Skeleton Key and the Barovs, for the Horde",race="Undead",class="WARLOCK",faction="Horde",ids={838,964,5514,5802,5341,5342,6163}},
    {name="H17 Dire Maul: the Shen'dralar, the Gordok king, the Felvine, Quel'Serrar",race="Orc",class="WARRIOR",faction="Horde",ids={7461,7462,7481,7703,5518,5527,5526,7507,7508,7509,7486}},
    {name="H15 Winterspring hunts: the frostsaber trainer, Nara Wildmane, Kibler's spiders",race="Tauren",class="HUNTER",faction="Horde",ids={4970,5055,5056,5201,5057,4883,4862}},
    {name="H14 Felwood for the Horde: blood amber, corrupted sabers, the wildkin, Mulgris",race="Tauren",class="DRUID",faction="Horde",ids={4102,4505,4506,4521,4741,4721,8471,4984,4985,4987}},
    {name="H13 Blackrock Spire: Bijou, Lagrave, Ragged John",race="Orc",class="HUNTER",faction="Horde",ids={4981,4982,4983,4769,4768,4866,4867,4729,5047}},
    {name="H1 The Defiler of the Blasted Lands",race="Orc",class="WARLOCK",faction="Horde",ids={2784,2623,2801,2681,2701,2702,2721,2743,2744,3141,3508,3509,3510,3511,3602,3626,3627,3628}},
    {name="H19 Kum'isha's draenethyst",race="Undead",class="MAGE",faction="Horde",ids={2521,2522,3501,3502}},
    {name="A21 Petty Squabbles: the Alliance and the Fallen Hero",race="Human",class="PRIEST",faction="Alliance",ids={2783,2784,2801,2681,2702}},
    {name="H2 Linken's missing memory",race="Troll",class="ROGUE",faction="Horde",ids={3844,3845,3908,3909,3912,3913,3914,3941,3942,4084,4005,3961,3962}},
    {name="H3 Sha'ni, Oralius and the Firegut",race="Orc",class="WARRIOR",faction="Horde",ids={3821,3822,3823,3824,3825,4283}},
    {name="H4 The K.E.F. against Angerforge",race="Orc",class="SHAMAN",faction="Horde",ids={4081,4082,4122,4121,4132}},
    {name="H5 Gor'shak, Thrall and the princess",race="Orc",class="WARRIOR",faction="Horde",ids={3981,3982,4001,4002,4003,4004}},
    {name="H6 Nathanos Blightcaller",race="Undead",class="ROGUE",faction="Horde",ids={6133,6135,6136,6022,6042,6145,6146,6147,6148}},
    {name="H7 Egan, Smokey and the Dawn",race="Undead",class="MAGE",faction="Horde",ids={5281,5282,5214,6026,6041,5243,5212,5213,5251}},
    {name="H8 Horde Plaguelands: Derrington and the Scourge cauldrons",race="Tauren",class="DRUID",faction="Horde",ids={5093,5096,5228,5097}},
    {name="H9 Rexxar and the Drakefire Amulet",race="Orc",class="HUNTER",faction="Horde",ids={6567,6569,6570,6601,6602}},
    {name="H10 Hakkar: the egg and the temple",race="Troll",class="PRIEST",faction="Horde",ids={3380,3444,3446,3447,3373,3374,3520,3527,4787,3528,4788}},
    {name="H11 Zul'Gurub and Ahn'Qiraj",race="Troll",class="SHAMAN",faction="Horde",ids={8183,8801,8802}},
    {name="H12 Naxxramas",race="Undead",class="WARLOCK",faction="Horde",ids={9121,9120}},
    -- Level-sixty class quests
    {name="C1 The dreadsteed of Xoroth",race="Orc",class="WARLOCK",faction="Horde",ids={7562,7563,7564,7623,7624,7625,7626,7627,7628,7629,7630,7631}},
    {name="C2 Niby, Impsy and the doomguard",race="Gnome",class="WARLOCK",faction="Alliance",ids={7601,7602,7603,8419,8420,8421,8422,7581,7582,7583}},
    {name="C3 The paladin's charger",race="Human",class="PALADIN",faction="Alliance",ids={7638,7637,7639,7640,7641,7642,7648,7643,7645,7644,7646,7647}},
    {name="C4 Rhok'delar",race="NightElf",class="HUNTER",faction="Alliance",ids={7632,7636,7635,7634}},
    {name="C5 The Sunken Temple class quests",race="Troll",class="SHAMAN",faction="Horde",ids={8410,8411,8412,8413}},
    {name="C6 Ogtinc, Xylem and Ravenholdt",race="Human",class="MAGE",faction="Alliance",ids={8250,8251,8252,8253,8254,8255,8256,8257,8233,8234,8235,8236,8151,8232,8417,8423,8424,8425}},
    {name="C8 Strahad, the felsteed and the Orb of Orahil",race="Orc",class="WARLOCK",faction="Horde",ids={2996,1740,4489,4490,4969,1799,4961,4962,4964}},
    {name="C9 The mage's robes and wand",race="Human",class="MAGE",faction="Alliance",ids={1920,1921,1947,1948,1951,1955,1957,2861}},
    {name="C10 Serge Hinott's cure and Torwa's toxin",race="Tauren",class="DRUID",faction="Horde",ids={9063,9052,9053}},
    {name="C11 A Forsaken mage and an undead rogue",race="Undead",class="MAGE",faction="Horde",ids={1961,1943,2479,2480}},
    {name="C7 Paladins at Chillwind, the mage at Dire Maul",race="Dwarf",class="PALADIN",faction="Alliance",ids={8415,8414,8416,8418,7463}},
}
local base=os.time({year=2026,month=10,day=1,hour=18})
local function make(s,companion)
    local p={self=not companion,name=companion and "Reed-Review" or "Band5060",charKey="Band5060",race=s.race,class=s.class,faction=s.faction,pronouns="they",bond="friend",origin="together",journal={}}
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
local only=arg[2]
for _,s in ipairs(scenarios) do
    if not only or s.name:find(only,1,true) then
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
end
for _,message in ipairs(failures) do print(message) end
assert(#failures==0,"Band5060: "..#failures.." failed checks")
local mean=sentences>0 and words/sentences or 0
if arg[1]=="--stats" then print(string.format("touched prose: %d sentences, mean %.1f words, %.0f%% of 18+ words",sentences,mean,100*long/math.max(1,sentences))) end
print("Band5060: "..checks.." checks passed; "..#touched.." stages rewritten or added by this lane; "..#scenarios.." journeys, solo/companion, full/Highlights, four retells.")
