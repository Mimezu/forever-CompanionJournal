-- Staged quest evidence and sustained journeys across the requested level bands.
-- Run from the client root with Lua 5.1; --review prints representative retells.
local root = "Interface/AddOns/CompanionJournal/"
function time(t) return type(t)=="table" and os.time(t) or 1792000000 end
function date(f,t) return os.date(f,t) end
local A={defaults={colors={}}}
for _,file in ipairs({"LoreData.lua","Lore.lua","LoreHordeStories.lua","LoreAllianceStories.lua","LoreWorldStories.lua","LoreClassStories.lua","JournalBook.lua","JournalTellers.lua","JournalTale.lua","JournalWords.lua","JournalSelfWords.lua","JournalSelfTale.lua"}) do
    assert(loadfile(root..file))("CompanionJournal",A)
end
local checks,failures=0,{}
local function check(ok,message) checks=checks+1; if not ok then failures[#failures+1]=message end end
local function read(path) local f=assert(io.open(path,"rb"));local s=f:read("*a");f:close();return s end
local corpus=read("StorageInvestigation/journal-voice/review/corpus_vanilla_quests.txt")
local sources,titles={},{}
for title,id,level in corpus:gmatch("### ([^\r\n]+)  %(id (%d+), level (%d+)%)") do
    sources[tonumber(id)]={title=title,level=tonumber(level)}
    titles[title]=(titles[title] or 0)+1
end
local added={}
for id in read("StorageInvestigation/cj-world-band-additions-20261012.txt"):gmatch("\n(%d+)|") do added[#added+1]=tonumber(id) end
for _,id in ipairs({5229,5230,5231,5232,5233,5234,5235,5236,
    1740,8417,8423,8424,8415,8414,8416,8418,8233,8234,8235,8250,8251,8252,
    8410,8411,8412,8413,8419,8420,8421,8422}) do added[#added+1]=id end
check(#added==142,"review inventory must contain 120 world and 22 class additions")
local owner={}
for name,pack in pairs(A.Lore.storyPacks) do
    for id in pairs(pack.questIDs or {}) do
        check(not owner[id],"duplicate exact ID "..id.." in "..name.." and "..tostring(owner[id]))
        owner[id]=name
    end
end
for _,id in ipairs(added) do
    local q,s=A.Lore.questStoryIDs[id],sources[id]
    check(q and s,"missing authored or source record "..id)
    if q and s then
        check(q.title==s.title,"wrong source title "..id)
        check(q.level==s.level,"wrong source level "..id)
        check(q.why and #q.why==2 and q.after and #q.after==2,"missing paired prose "..id)
        check(q.why[1]~=q.why[2] and q.after[1]~=q.after[2],"duplicate variants "..id)
        check(q.source and table.concat(q.source," "):find(tostring(id),1,true),"missing exact provenance "..id)
        check(A.Lore.QuestStory(q.title,id).after[1]==q.after[1],"exact stage not selected "..id)
    end
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
    {name="Fire, water, air, and a troubled Windwatcher",race="Tauren",class="SHAMAN",faction="Horde",ids={1523,1524,1525,1526,1527,1529,1530,1535,1536,1534,220,63,100,96,1532,8410,8412,8413}},
    {name="Racing from the Flats to the Badlands",race="Gnome",class="MAGE",faction="Alliance",ids={1104,1105,1110,1106,1108,1137,720,718,733,739,717}},
    {name="The Darkspear's memory and missing son",race="Troll",class="HUNTER",faction="Horde",ids={629,588,589,592}},
    {name="The Harborage and the missing wife",race="Tauren",class="WARRIOR",faction="Horde",ids={1389,1392,1393,3821,3822}},
    {name="Camp Mojache's widening insect threat",race="Orc",class="HUNTER",faction="Horde",ids={2862,2863,2902,2903,7730,7731,7732,992,82,10,110,113,8284,8285,8287}},
    {name="A torch before the tower fires",race="Human",class="PALADIN",faction="Alliance",ids={3442,3443,3452,3453,3454,3462,3463}},
    {name="The flute and the Timbermaw",race="NightElf",class="DRUID",faction="Alliance",ids={4441,4442,8460,8462,8461,8465,8464}},
    {name="The raft and Linken's memory",race="Dwarf",class="HUNTER",faction="Alliance",ids={3844,3845,3908,3909,3961,3962}},
    {name="Chillwind's four cauldrons",race="Human",class="PALADIN",faction="Alliance",ids={5216,5217,5219,5220,5222,5223,5225,5226}},
    {name="The Bulwark's four cauldrons",race="Scourge",class="PRIEST",faction="Horde",ids={5229,5230,5231,5232,5233,5234,5235,5236}},
    {name="Caer Darrow and an uncertain invention",race="Dwarf",class="PRIEST",faction="Alliance",ids={5382,5515,5384,5529,5531,4771,5282}},
    {name="Temple feathers for the Light",race="Human",class="PALADIN",faction="Alliance",ids={8415,8414,8416,8418}},
    {name="Temple feathers for a warrior",race="Orc",class="WARRIOR",faction="Horde",ids={8417,8423,8424,8425}},
    {name="An orb and an imp's own pet",race="Scourge",class="WARLOCK",faction="Horde",ids={1740,8419,8421,8422}},
    {name="Xylem's research and the temple",race="Gnome",class="MAGE",faction="Alliance",ids={8250,8251,8252,8253}},
    {name="Ravenholdt's private possession",race="Human",class="ROGUE",faction="Alliance",ids={8233,8234,8235,8236}},
    {name="Hakkar's essence and the later heart",race="Troll",class="PRIEST",faction="Horde",ids={3520,3527,4787,3528,4788,8183}},
    {name="Access, proofs, and the surviving phylactery",race="Human",class="MAGE",faction="Alliance",ids={3801,3802,7848,6821,6822,6823,6824,7761,9121,9120}},
    {name="Natalia, the hive code, and the freed dragons",race="Tauren",class="DRUID",faction="Horde",ids={8304,8306,8314,8315,8801,8802}},
}
local base=os.time({year=2026,month=10,day=1,hour=18})
local function make(s,companion)
    local p={self=not companion,name=companion and "Reed-Review" or "BandReview",charKey="BandReview",race=s.race,class=s.class,faction=s.faction,pronouns="they",bond="friend",origin="together",journal={}}
    for n,id in ipairs(s.ids) do
        local q=assert(A.Lore.questStoryIDs[id],tostring(id))
        p.startLevel=p.startLevel or q.level
        local t=base+(n-1)*86400
        p.journal[#p.journal+1]={k=companion and "group" or "play",t=t,e=t+3600,z=q.zone,pl=q.level,ol=q.level}
        p.journal[#p.journal+1]={k="quest",t=t+120,z=q.zone,d=q.title,qid=id,pl=q.level,ol=q.level}
    end
    return p
end
local function render(p,player,companion,brief,retell)
    local days=A.JournalBook(p)
    p.retell=retell
    local tale=companion and A.JournalTale.Tell(p,days,"we",player,brief) or A.SelfTale.Tell(p,days,brief,retell)
    local out={}
    for _,day in ipairs(days) do if tale[day.key] then out[#out+1]=A.JournalPlain(tale[day.key].text) end end
    return table.concat(out,"\n\n")
end
for _,s in ipairs(scenarios) do
    local player=make(s,false)
    for _,companion in ipairs({false,true}) do
        local p=companion and make(s,true) or player
        local before=fingerprint(p.journal)
        for _,brief in ipairs({false,true}) do
            for retell=0,3 do
                local out=render(p,player,companion,brief,retell)
                check(#out>0,s.name.." empty narrative")
                check(out==render(p,player,companion,brief,retell),s.name.." nondeterministic retell")
                check(not out:find("{%a+}"),s.name.." unresolved placeholder")
                check(not out:find("the the",1,true),s.name.." doubled article")
                if arg[1]=="--review" and retell==0 then
                    print("\n"..s.name.." / "..(companion and "COMPANION" or "SOLO").." / "..(brief and "HIGHLIGHTS" or "FULL").."\n"..out)
                end
            end
        end
        check(before==fingerprint(p.journal),s.name.." mutated raw history")
    end
end

-- Positive stage markers paired with forbidden later-stage claims.
local boundaries={
    {id=3453,want="torch",reject="towers were set ablaze"},
    {id=3454,want="hatred",reject="towers were set ablaze"},
    {id=3844,want="pack",reject="Golden Flame was recovered"},
    {id=3801,want="Forgewright",reject="compartment opened"},
    {id=3509,want="Arkkoroc",reject="amulet"},
    {id=5216,want="sampling",reject="sample reached"},
    {id=5515,want="bag",reject="Kirtonos fell"},
    {id=4771,want="Vectus",reject="worked perfectly"},
    {id=7488,want="web",reject="web was destroyed"},
    {id=7489,want="web",reject="web was destroyed"},
    {id=7848,want="attunement complete",reject="Ragnaros fell"},
    {id=9120,want="Montoy",reject="phylactery was destroyed"},
    {id=9121,want="portal",reject="Kel'Thuzad fell"},
    {id=8801,want="dragons",reject="left the temple"},
    {id=8412,want="Bath'rah",reject="ready to guard"},
}
for _,s in ipairs(boundaries) do
    local q=A.Lore.questStoryIDs[s.id]
    local out=table.concat(q.after," ")
    check(out:find(s.want,1,true),"missing stage boundary "..s.id)
    check(not out:find(s.reject,1,true),"future event in stage "..s.id)
end
for _,sample in ipairs({{"The Torch of Retribution","surge of hatred"},{"It's a Secret to Everybody","sword for tempering"},
    {"Dark Iron Legacy","compartment opened"},{"Return to Chillwind Camp","fourth sample"},
    {"Return to the Bulwark","fourth sample"},{"Lethtendris's Web","disperse its energy"},
    {"The Restless Souls","souls' release"},{"The Name of the Beast","name was not yet supplied"}}) do
    for _,id in ipairs({0,3802,3454,3908,7488,9120}) do
        local exact=A.Lore.questStoryIDs[id]
        if not exact or exact.title~=sample[1] then
            local story=A.Lore.QuestStory(sample[1],id)
            check(story and not table.concat(story.after," "):find(sample[2],1,true),"shared title leaked exact stage: "..sample[1])
        end
    end
end
for _,message in ipairs(failures) do print(message) end
assert(#failures==0,"WorldBandDepth: "..#failures.." failed checks")
print("WorldBandDepth: "..checks.." checks passed; 142 added stages; 19 journeys, solo/companion, full/Highlights, four retells.")
