-- Band 30-50 pass 2026-11-06 (lane band3050): the level 30-50 zones of
-- LoreWorldStories.lua read as a reader and rewritten as scenes, plus the
-- coverage gaps of the band (Shimmering Flats racers, Stranglethorn leftovers,
-- Arathi, Badlands, Searing Gorge, Hinterlands, Alliance Feralas, Tanaris at
-- forty-five, the dungeon errands, Azshara). Checks: source identity, pack
-- ownership, paired prose, the writing rules (no colons, questions, meta words,
-- pronouns, repeated sentence openings within a line and across every why/after
-- pairing), stage boundaries, title-only leaks, and real renders of a connected
-- 30-50 journey per faction in both narrators, Everything and Highlights.
-- Run from the client root with Lua 5.1; --review prints the chapters (retell 0),
-- --stats prints sentence-length figures for the band's prose.
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

-- Exact stages this pass added to the world pack.
local added={
    -- B1: the Shimmering Flats racers' scheme and the Fool's Stout
    1115,1116,1117,1118,1119,1120,1121,1122,1127,1950,
    -- B2: Stranglethorn leftovers
    348,349,580,594,630,600,605,606,607,617,623,8551,8552,8553,618,
    -- B3: Arathi, Badlands, Searing Gorge finds, Hinterlands
    681,682,691,673,679,680,702,847,635,653,687,665,666,668,669,670,706,708,716,732,782,793,3481,7704,77,2877,
    -- B4: Alliance Feralas and Roon's horn
    4281,2969,2970,2972,3841,3842,3843,4297,4298,2844,2845,7735,7738,5763,
    -- B5: Tanaris at forty-five, the dungeon errands, Azshara
    243,379,654,841,1690,1691,1707,2781,2872,2873,2874,2875,2876,2954,3022,3362,5863,1560,
    704,2342,7065,3523,3525,3636,6521,5536,3517,3505,3507,
}
-- Stages rewritten as scenes (facts unchanged; the same prose rules apply).
local rewritten={
    505,512,537,507,1136,655,672,674,675,639,640,641,643,644,645,646,651,
    3377,3378,3381,3601,3508,3509,6821,6823,
    720,1106,1108,2258,709,718,733,739,717,
    1367,1368,5741,5561,6161,7046,
    1319,1320,1321,1322,1323,1204,1324,1261,
    2862,2863,2902,2903,2975,2980,2987,3520,7730,7731,3909,1113,
    3442,3443,3452,3453,3454,3462,3463,7722,3372,
    203,204,200,629,338,592,
    1389,1393,1392,1423,1424,1446,
    2768,2605,2606,2661,2662,
    2880,7839,7840,4787,7861,
    1104,1105,1131,1137,3527,
}
local pronouns={i=true,me=true,my=true,we=true,us=true,our=true,ours=true,you=true,your=true,yours=true}
local meta={journal=true,tale=true,song=true,verse=true,chronicle=true,legend=true,legends=true,bard=true,page=true,pages=true,book=true,chapter=true,story=true,record=true}
local words,sentences,long=0,0,0
local function sentencesOf(line) local out={} for s in (line.." "):gmatch("(.-[%.!])%s") do out[#out+1]=s:match("^%s*(.-)$") end return out end
local function firstWord(s) return (s:match("^(%a[%a']*)") or ""):gsub("'s$","") end
local function prose(lines,label,need)
    check(type(lines)=="table" and #lines>=(need or 2),label.." needs two variants")
    if type(lines)~="table" then return end
    check(lines[1]~=lines[2],label.." repeated variant")
    for _,line in ipairs(lines) do
        local ss=sentencesOf(line)
        for k,s in ipairs(ss) do
            local n=0 for _ in s:gmatch("%S+") do n=n+1 end
            if n>0 then sentences=sentences+1; words=words+n; if n>=18 then long=long+1 end end
            check(n<34,label.." sentence over 33 words: "..s)
            if k>1 then check(firstWord(ss[k])~=firstWord(ss[k-1]),label.." repeated opening '"..firstWord(s).."': "..line) end
        end
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
local function pairings(id,q)
    for _,w in ipairs(q.why) do local ws=sentencesOf(w) for _,a in ipairs(q.after) do
        local as=sentencesOf(a)
        check(firstWord(as[1])~=firstWord(ws[#ws]),id.." why/after repeat '"..firstWord(as[1]).."': "..ws[#ws].." / "..as[1])
    end end
end
local seen={}
for _,id in ipairs(added) do
    check(not seen[id],"listed twice "..id); seen[id]=true
    local q,s=L.questStoryIDs[id],sources[id]
    check(q and s,"missing authored or source record "..id)
    if q and s then
        check(q.pack=="world_journeys","stage "..id.." owned by "..tostring(q.pack))
        check(q.title==s.title,"source title "..id)
        check(q.level==s.level,"source level "..id.." ("..tostring(q.level).." vs "..s.level..")")
        check(q.source and table.concat(q.source," "):find(tostring(id),1,true),"provenance "..id)
        check(L.QuestStory(q.title,id)==q,"exact stage resolves "..id)
        check(q.threadLabel==L.storyThreads[q.thread],"thread label "..id)
        prose(q.why,id.." why"); prose(q.after,id.." after"); pairings(id,q)
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
for _,id in ipairs(rewritten) do
    local q=L.questStoryIDs[id]
    check(q~=nil,"rewritten stage missing "..id)
    if q then
        check(q.pack=="world_journeys","rewritten stage "..id.." owned by "..tostring(q.pack))
        prose(q.why,id.." why"); prose(q.after,id.." after"); pairings(id,q)
        if q.highlight then prose(q.highlight,id.." highlight") end
    end
end

-- Stage boundaries: an earlier stage may not claim a later one's outcome.
local boundaries={
    {id=1115,want="Krazek",reject="letter"},
    {id=1117,want="small fortune",reject="Fool's Stout"},
    {id=1118,want="Zanzil",reject="worked"},
    {id=1119,want="money",reject="placed a bet"},
    {id=348,want="dream",reject="Unbagwa"},
    {id=349,want="Mokk",reject="returning"},
    {id=594,want="captive",reject="Mukla"},
    {id=630,want="dishonor",reject="bottle"},
    {id=606,want="Sea Wolf",reject="pouch"},
    {id=8551,want="not complete",reject="Mok'rash"},
    {id=8553,want="Negolash",reject="cutlass went back"},
    {id=618,want="cutlass",reject="sash"},
    {id=639,want="good start",reject="Trol'kalar slipped"},
    {id=641,want="halfway",reject="Valorcall"},
    {id=643,want="one sigil left",reject="Galen's"},
    {id=644,want="completed the set",reject="stone hands"},
    {id=645,want="delivery to Zengu still remained",reject="Nimboya"},
    {id=651,want="restraints loosen",reject="Rod of Order"},
    {id=653,want="higher cause",reject="scroll"},
    {id=687,want="solace",reject="fragments"},
    {id=665,want="goggles worked",reject="gems"},
    {id=668,want="ankle biters",reject="Seahorn said"},
    {id=732,want="Blacklash and Hematus",reject="dead"},
    {id=782,want="Tho'grun",reject="Blacklash and Hematus were dead"},
    {id=702,want="strange power",reject="listen"},
    {id=847,want="enchantment",reject="despair"},
    {id=1367,want="would see",reject="Khan"},
    {id=1368,want="further tasks",reject="Khan"},
    {id=1319,want="not his work",reject="tauren"},
    {id=1320,want="guess",reject="Mosarn"},
    {id=1322,want="still ahead",reject="Mosarn"},
    {id=1323,want="leaving the mystery open",reject="Theramore"},
    {id=2862,want="plan",reject="Alphas fell"},
    {id=2863,want="frenzy",reject="south"},
    {id=2902,want="south",reject="Hadoken could not"},
    {id=2969,want="offensive",reject="signet"},
    {id=2970,want="hostile",reject="Tyrande"},
    {id=3841,want="come by",reject="elixirs"},
    {id=3842,want="spell",reject="Agnar"},
    {id=3843,want="food",reject="ready to hatch"},
    {id=4297,want="ready to hatch",reject="parent"},
    {id=2844,want="lost",reject="bell"},
    {id=3442,want="almost ready",reject="daggers"},
    {id=3443,want="laborer",reject="symbol"},
    {id=3453,want="final task",reject="hatred"},
    {id=3454,want="towers still stood",reject="glorious"},
    {id=243,want="free",reject="pouches"},
    {id=379,want="two hours",reject="data inside was safe"},
    {id=1690,want="far from done",reject="Luglunket"},
    {id=2872,want="none to give",reject="Cuergo"},
    {id=2873,want="settle",reject="terrible"},
    {id=3523,want="up to speed",reject="dragon"},
    {id=3505,want="diagram",reject="head"},
    {id=1389,want="debt",reject="Noboru"},
    {id=1424,want="praise",reject="Jammal'an"},
    {id=2605,want="drink it",reject="Sprinkle"},
    {id=2606,want="help",reject="Powder"},
    {id=2661,want="worse",reject="millions"},
}
for _,b in ipairs(boundaries) do
    local q=L.questStoryIDs[b.id]
    check(q~=nil,"boundary stage missing "..b.id)
    if q then
        local out=table.concat(q.after," ").." "..table.concat(q.highlight or {}," ")
        check(out:find(b.want,1,true),"missing stage marker "..b.id..": "..b.want)
        check(not out:find(b.reject,1,true),"later outcome in stage "..b.id..": "..b.reject)
    end
end
-- Title-only records never get an exact stage's resolution.
for _,sample in ipairs({{"Stranglethorn Fever","dream"},{"Stranglethorn Fever","fangs"},{"Message in a Bottle","Mukla"},{"Message in a Bottle","dishonor"},
    {"Akiris by the Bundle","Groy took"},{"Sunken Treasure","goggles worked"},{"Sunken Treasure","ankle biters"},{"Broken Alliances","Tho'grun"},{"Broken Alliances","Blackrock Spire"},
    {"Guile of the Raptor","polished"},{"Guile of the Raptor","listen"},{"Doling Justice","Tyrande"},{"Doling Justice","signet"},{"Betrayed","head"},{"Betrayed","diagram"},
    {"Myzrael's Allies","Gerrig"},{"Tremors of the Earth","Blacklash and Hematus were dead"},{"Trol'kalar","Zengu received the sword"},{"Raising Spirits","Gor'mul dismissed"},
    {"The Black Shield","Mosarn"},{"Prayer to Elune","Astarii received the prayer"},{"The Sacred Flame","Cloven Hoof reached Rau"}}) do
    check(not table.concat(L.QuestStory(sample[1],nil).after," "):find(sample[2],1,true),"title-only leak "..sample[1].." "..sample[2])
    check(not table.concat(L.QuestStory(sample[1],nil).why," "):find(sample[2],1,true),"title-only setup leak "..sample[1].." "..sample[2])
    check(not table.concat(L.QuestStory(sample[1],999999).after," "):find(sample[2],1,true),"unknown-ID leak "..sample[1])
end
-- Zone corrections of this pass: Zamael's cage is in the Searing Gorge.
check(L.questStoryIDs[3377].zone=="Searing Gorge" and L.questStoryIDs[3378].zone=="Searing Gorge","Prayer to Elune zone")
-- No colon reveals or questions anywhere in the world pack.
do
    local pack=L.storyPacks["world_journeys"]
    local function scan(entry,label)
        for _,field in ipairs({"why","after","highlight"}) do
            for _,line in ipairs(entry[field] or {}) do
                check(not line:gsub("SI:7",""):gsub("XT:%d",""):find(":",1,true),label.." "..field.." colon: "..line)
                check(not line:find("?",1,true),label.." "..field.." question: "..line)
            end
        end
    end
    for id,entry in pairs(pack.questIDs) do scan(entry,"world "..id) end
    for title,entry in pairs(pack.quests) do scan(entry,"world "..title) end
end

local function fingerprint(value)
    if type(value)~="table" then return type(value)..":"..tostring(value) end
    local keys,result={},{}
    for key in pairs(value) do keys[#keys+1]=key end
    table.sort(keys,function(a,b)return tostring(a)<tostring(b)end)
    for _,key in ipairs(keys) do result[#result+1]=fingerprint(key).."="..fingerprint(value[key]) end
    return "{"..table.concat(result,";").."}"
end
-- Connected journeys through the band: one Alliance, one Horde, each from the
-- Highlands to the desert, plus the chains the pass added.
local scenarios={
    {name="An Alliance road from Refuge Pointe to Gadgetzan",race="Human",class="PALADIN",faction="Alliance",ids={681,682,690,693,694,695,696,665,666,668,669,
        505,512,537,583,185,190,616,578,601,602,603,610,611,1282,1284,1253,1319,1320,1252,1259,1285,1286,1287,1288,
        719,720,718,733,738,739,704,706,2862,2870,2871,4124,4125,4127,4129,4130,4131,4281,2969,2970,2972,3841,3842,3843,4297,4298,
        2880,2877,2988,2989,2993,2994,992,82,10,110,113,1690,1691,1707,2781,3362,3444}},
    {name="A Horde road from Hammerfall to Tanaris",race="Troll",class="SHAMAN",faction="Horde",ids={676,655,672,674,675,702,847,673,679,680,638,639,640,641,643,644,645,646,642,651,652,688,
        581,582,584,585,586,588,589,591,592,629,596,598,568,569,570,571,572,573,
        1362,1365,1366,1367,1386,1369,1375,1381,1434,1480,1481,1482,1484,1488,
        1421,1396,1398,698,699,1424,1429,1444,1445,1418,1419,1420,2258,17,2418,2284,2318,2338,2339,2341,782,793,
        2975,2980,2976,2979,2862,2863,2902,2903,7730,7731,7816,7828,7829,7830,7839,7840,7841,7842,7843,7844,7849,7850,7845,7846,7847,7861,
        243,379,654,841,2872,2873,2874,2875,2876,5863,1560}},
    {name="The racers' scheme",race="Gnome",class="MAGE",faction="Alliance",ids={1179,1176,1115,1116,1117,1118,1119,1120,1121,1122,1127}},
    {name="Stranglethorn leftovers",race="Dwarf",class="HUNTER",faction="Alliance",ids={605,600,606,607,617,623,348,349,580,594,630,8551,8553,618,8552}},
    {name="Myzrael and the Faldir's Cove crew",race="Human",class="MAGE",faction="Alliance",ids={635,642,651,688,653,687,692,737,652,656,663,662,664,665,666,668,669,670,667}},
    {name="Kalaran's torch and the Thorium Brotherhood",race="Human",class="WARRIOR",faction="Alliance",ids={3441,3442,3443,3452,3453,3454,3462,3463,7728,7729,7723,7724,7727,7701,7722,3481,7704,3377,3378}},
    {name="The sprite darter egg and the Hinterlands",race="NightElf",class="DRUID",faction="Alliance",ids={2969,2970,2972,3841,3842,3843,4297,4298,2844,2845,7735,77,2877,3022,3445}},
    {name="The dungeon errands",race="Undead",class="WARLOCK",faction="Horde",ids={6521,3523,3525,1113,1051,1049,704,2342,2398,7028,7029,7067,7044,7046,7065,3527,4787}},
    {name="Azshara at the end of the band",race="Orc",class="ROGUE",faction="Horde",ids={5536,3601,5534,3517,3505,3507,3381}},
}
local base=os.time({year=2026,month=10,day=1,hour=18})
local function make(s,companion)
    local p={self=not companion,name=companion and "Reed-Review" or "Band3050",charKey="Band3050",race=s.race,class=s.class,faction=s.faction,pronouns="they",bond="friend",origin="together",journal={}}
    for n,id in ipairs(s.ids) do
        local q=assert(L.questStoryIDs[id],tostring(id))
        p.startLevel=p.startLevel or q.level
        local day=math.floor((n-1)/3)
        local t=base+day*86400+((n-1)%3)*3600
        p.journal[#p.journal+1]={k=companion and "group" or "play",t=t,e=t+2400,z=q.zone,pl=q.level,ol=q.level}
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
assert(#failures==0,"Band3050: "..#failures.." failed checks")
local mean=sentences>0 and words/sentences or 0
if arg[1]=="--stats" then print(string.format("band prose: %d sentences, mean %.1f words, %.0f%% of 18+ words",sentences,mean,100*long/math.max(1,sentences))) end
print("Band3050: "..checks.." checks passed; "..#added.." exact stages added and "..#rewritten.." rewritten this pass; "..#scenarios.." journeys, solo/companion, full/Highlights, four retells.")
