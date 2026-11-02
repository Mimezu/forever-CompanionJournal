-- Source-backed later-world continuities, actual solo/companion narrators.
-- Run from client root with Lua 5.1. Optional argument prints full review prose.
local root = "Interface/AddOns/CompanionJournal/"
function time(t) return type(t)=="table" and os.time(t) or 1792000000 end
function date(f,t) return os.date(f,t) end
local A={defaults={colors={}}}
for _,file in ipairs({"LoreData.lua","Lore.lua","LoreHordeStories.lua","LoreAllianceStories.lua","LoreWorldStories.lua","LoreClassStories.lua","JournalBook.lua","JournalTellers.lua","JournalTale.lua","JournalWords.lua","JournalSelfWords.lua","JournalSelfTale.lua"}) do
    assert(loadfile(root..file))("CompanionJournal",A)
end
local checks,failures=0,{}
local function check(ok,message) checks=checks+1;if not ok then failures[#failures+1]=message end end
local owners={}
for name,pack in pairs(A.Lore.storyPacks) do
    for id in pairs(pack.questIDs or {}) do
        check(not owners[id],"duplicate exact quest ID "..id.." between "..name.." and "..tostring(owners[id]))
        owners[id]=name
    end
end
local function fingerprint(value)
    if type(value)~="table" then return type(value)..":"..tostring(value) end
    local keys,result={},{}
    for key in pairs(value) do keys[#keys+1]=key end
    table.sort(keys,function(a,b) return tostring(a)<tostring(b) end)
    for _,key in ipairs(keys) do result[#result+1]=fingerprint(key).."="..fingerprint(value[key]) end
    return "{"..table.concat(result,";").."}"
end
local scenarios={
    {name="Teronis and the rod",race="NightElf",class="HUNTER",faction="Alliance",ids={991,1023,1024,1026,1027,1028,1055,1029,1030,1045,1046}},
    {name="A veteran at Hammerfall",race="Orc",class="WARRIOR",faction="Horde",ids={655,672,674,675}},
    {name="Desert water and an improbable drink",race="Tauren",class="SHAMAN",faction="Horde",ids={992,82,10,110,113,2605,2606,2641,2661,2662}},
    {name="The Fordring keepsakes",race="Human",class="PALADIN",faction="Alliance",ids={5542,5543,5544,5742,5781,5845,5846,5848,5861,5862,5944}},
    {name="The Redpath family",race="Dwarf",class="PRIEST",faction="Alliance",ids={5142,5149,5241,5152,5153,5154,5210,5168,5181,5211,5206,5941,5721,5942}},
    {name="The Winterfall investigation",race="Tauren",class="DRUID",faction="Horde",ids={5082,5083,5084,5085,5086,5087,5121,5123}},
}
local base=os.time({year=2026,month=10,day=1,hour=18})
local function make(s,companion)
    local p={self=not companion,name=companion and "Reed-Review" or "WorldDepth",charKey="WorldDepth",race=s.race,class=s.class,faction=s.faction,pronouns="they",bond="friend",origin="together",journal={}}
    for n,id in ipairs(s.ids) do
        local q=assert(A.Lore.questStoryIDs[id])
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
                check(out==render(p,player,companion,brief,retell),s.name.." nondeterministic narrative")
                check(not out:find("{%a+}"),s.name.." unresolved placeholder: "..out)
                if arg[1]=="--review" and retell==0 then
                    print("\n"..s.name.." / "..(companion and "COMPANION" or "SOLO").." / "..(brief and "HIGHLIGHTS" or "FULL").."\n"..out)
                end
            end
        end
        check(before==fingerprint(p.journal),s.name.." changed raw history")
    end
end
-- Historical titles and mismatched exact IDs must not manufacture a finale.
for _,sample in ipairs({{"Raene's Cleansing","Ran Bloodtooth was slain"},{"Trol'kalar","Zengu received the sword"},{"Raising Spirits","Gor'mul dismissed"},{"The Black Shield","Mosarn's name"},{"Insect Part Analysis","Fizzledowser accepted"}}) do
    for _,id in ipairs({0,991,645,675,1323,113}) do
        local exact=A.Lore.questStoryIDs[id]
        if not exact or exact.title~=sample[1] then
            local story=A.Lore.QuestStory(sample[1],id)
            check(not table.concat(story.after," "):find(sample[2],1,true),sample[1].." mismatched ID leaked a stage")
        end
    end
end
for _,message in ipairs(failures) do print(message) end
assert(#failures==0,"WorldDepth: "..#failures.." failed checks")
print("WorldDepth: "..checks.." checks passed; six sustained journeys, solo/companion, full/Highlights, four retells.")
