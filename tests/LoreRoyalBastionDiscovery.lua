-- Bounded Oct 29 mystery review. Optional: output path, 'baseline', before-data path.
local root='Interface/AddOns/CompanionJournal/'
local A={db={characters={Reader={level=1,journal={}},Alt={level=60,journal={}}}}}
local frames,shown={},nil
function A.Me() return 'Reader' end
function time() return 1793200000 end
function CreateFrame()
    local f={events={}}
    function f:RegisterEvent(e) self.events[e]=true end
    function f:SetScript(_,fn) self.callback=fn end
    frames[#frames+1]=f; return f
end
function GetQuestID() return shown end
local baseline=arg and arg[2]=='baseline'
for _,name in ipairs({'LoreData','Lore','LoreHordeStories','LoreAllianceStories','LoreWorldStories','LoreClassStories',
    'LoreNotes','LorePlaces','LorePeopleHistory','LoreWorldConnections','LoreDiscovery','LoreDiscoveryData'}) do
    assert(loadfile(name=='LoreDiscoveryData' and baseline and arg[3] or root..name..'.lua'))('CompanionJournal',A)
end
local count,failed=0,0
local function Check(ok,label)
    count=count+1
    if not ok then failed=failed+1; if not baseline or failed<=20 then print((baseline and 'BASELINE: ' or 'FAIL: ')..label) end end
end
local function Snapshot(v)
    if type(v)~='table' then return type(v)..':'..tostring(v) end
    local keys,out={},{}; for k in pairs(v) do keys[#keys+1]=k end
    table.sort(keys,function(a,b) return tostring(a)<tostring(b) end)
    for _,k in ipairs(keys) do out[#out+1]=Snapshot(k)..'='..Snapshot(v[k]) end
    return '{'..table.concat(out,'|')..'}'
end
local function Event(e,id) for _,f in ipairs(frames) do if f.events[e] then f.callback(f,e,id) end end end
local function Present(id) shown=id; Event('QUEST_DETAIL') end
local function Complete(id) Event('QUEST_TURNED_IN',id) end
local function Reset() A.db.characters.Reader={level=1,journal={}}; A.db.characters.Alt={level=60,journal={}} end
local function Note(id) return A.GetKnownLoreNote(id) end
local function Has(id,text) local n=Note(id); return n and n.body:lower():find(text:lower(),1,true)~=nil end
local royal={'dungeon:blackrock-depths','npc:magni','npc:dagran','npc:moira'}
local bastion={'dungeon:stratholme','group:scarlet-crusade','npc:jarien','npc:sothos'}
local targets={}; for _,group in ipairs({royal,bastion,{'npc:balnazzar','npc:varimathras'}}) do for _,id in ipairs(group) do targets[#targets+1]=id end end
local lookup,synthetic=A.GetLoreNote,{}
A.GetLoreNote=function(id) return lookup(id) or synthetic[id] end
-- Title policies must also protect new exact reference rows without treating the
-- existence or title of such a row as evidence. Existing rows are used if present.
for _,row in ipairs({{4003,'The Royal Rescue'},{4004,'The Princess Saved?'},{4362,'The Fate of the Kingdom'},
    {4363,"The Princess's Surprise"},{5262,'The Truth Comes Crashing Down'}}) do
    local id='quest:'..row[1]
    if not A.GetLoreNote(id) then synthetic[id]={id=id,title=row[2],kind='Quest',body='A report from a contested fortress concerns the leaders of its realm and the forces entering its halls.',sources={'test-only safe context for absent reference'},related={}} end
    targets[#targets+1]=id
end
local canonical={}; for _,id in ipairs(targets) do canonical[id]=Snapshot(assert(A.GetLoreNote(id),id)) end
local function Public(label)
    for _,id in ipairs(royal) do
        local n=Note(id); Check(n and #n.body>90,label..' useful royal introduction '..id)
        local value=n and Snapshot(n):lower() or ''
        for _,word in ipairs({'unborn','her husband and','heir','honorable','won even in death'}) do Check(not value:find(word,1,true),label..' no '..word..' '..id) end
    end
    for _,id in ipairs(bastion) do
        local n=Note(id); Check(n and #n.body>90,label..' useful bastion introduction '..id)
        local value=n and Snapshot(n):lower() or ''
        for _,word in ipairs({'balnazzar','dreadlord','demon','disguis'}) do Check(not value:find(word,1,true),label..' no '..word..' '..id) end
    end
    Check(Note('npc:balnazzar')==nil,label..' shared identity note remains hidden')
    for _,qid in ipairs({4003,4004,4362,4363,5262}) do
        local n=Note('quest:'..qid); local value=n and Snapshot(n):lower() or ''
        Check(n and #n.body>70,label..' useful exact quest context '..qid)
        for _,word in ipairs({'unborn','husband','heir','balnazzar','demon'}) do Check(not value:find(word,1,true),label..' quest no '..word..' '..qid) end
    end
    -- Walk every related edge reachable from the scoped entrances. Unrelated
    -- mysteries are not asserted safe, but this pair cannot be reached raw.
    local pending,seen={},{}
    for _,id in ipairs(targets) do pending[#pending+1]=id end
    local i=1
    while pending[i] do
        local id=pending[i]; i=i+1
        if not seen[id] then
            seen[id]=true; local n=Note(id)
            if n then
                Check(not n.names and not n.autoLink,label..' projected aliases '..id)
                if canonical[id] then
                    if id~='npc:varimathras' then Check(not Snapshot(n):lower():find('balnazzar',1,true),label..' traversal no identity '..id) end
                end
                for _,nextID in ipairs(n.related or {}) do
                    Check(nextID~='npc:balnazzar',label..' no concealed identity edge from '..id)
                    pending[#pending+1]=nextID
                end
            end
        end
    end
end
Public('fresh')
local unchanged=Snapshot(A.db)
for _,id in ipairs(targets) do Note(id) end
Check(Snapshot(A.db)==unchanged,'opening references does not learn or mutate')
A.db.characters.Reader.level=60
A.db.characters.Reader.journal={{k='dungeon',d='Blackrock Depths'},{k='dungeon',d='Stratholme'},
    {k='boss',d='Emperor Dagran Thaurissan'},{k='boss',d='Balnazzar'},
    {k='quest',d="The Princess's Surprise"},{k='quest',d='The Truth Comes Crashing Down'}}
A.db.characters.Alt.journal={{k='quest',qid=4004},{k='quest',qid=4363},{k='quest',qid=5262}}
Public('level-visit-boss-title-alt')
for _,flag in ipairs({'seeded','imported','s'}) do
    Reset(); for _,qid in ipairs({4004,4363,5262}) do A.db.characters.Reader.journal[#A.db.characters.Reader.journal+1]={k='quest',qid=qid,[flag]=true} end
    Public(flag)
end
for _,qid in ipairs({4003,4362,5263,5264,5265,8968,8991}) do
    Reset(); Present(qid); Complete(qid); Public('unrevealing exact '..qid)
end
for _,qid in ipairs({4004,4363}) do
    Reset(); Present(qid)
    for _,id in ipairs(royal) do Check(Has(id,'unborn child'),'presented family reaches '..id..' '..qid) end
    Check(not Has('npc:magni','visibly upset'),'presentation does not deliver report '..qid)
    Check(not Has('quest:4004','Thrall is taken aback'),'presentation does not report to Thrall '..qid)
    Check(not Has('npc:moira','her husband') or qid==4004,'Alliance description does not inherit Horde marriage wording')
    Check(Note('npc:balnazzar')==nil,'royal discovery does not reveal demon')
    Complete(qid)
    Check(Has('npc:magni','visibly upset')==(qid==4363),'own report recipient '..qid)
    Check(Has('quest:4004','Thrall is taken aback')==(qid==4004),'own Thrall reaction '..qid)
end
Reset(); Present(5262)
for _,id in ipairs(bastion) do Check(Has(id,'dreadlord'),'presented demon reaches '..id) end
Check(Note('npc:balnazzar') and Has('npc:balnazzar','dreadlord'),'identity note unlocks with exact disclosure')
Check(not Has('dungeon:stratholme','Zverenhoff asks'),'presentation does not deliver demon report')
Check(not Has('npc:moira','unborn'),'demon discovery does not reveal royal family')
Complete(5262); Check(Has('dungeon:stratholme','Zverenhoff asks'),'completion permits attributed suspicion')
Reset(); A.db.characters.Reader.journal={{k='quest',qid=4363}}
Check(Has('npc:moira','unborn'),'own exact journal recovery supports family')
Check(not Has('npc:moira','her husband'),'exact Alliance completion never inherits Horde description')
Reset(); A.db.characters.Reader.journal={{k='quest',qid=5262}}
Check(Has('dungeon:stratholme','dreadlord'),'own exact journal recovery supports demon')
Reset(); A.db.characters.Reader.loreDiscoveries={presented={[5262]={origin='game-history'}}}
Public('invalid presentation provenance')
for _,name in ipairs({'Grand Crusader Dathrohan','Balnazzar'}) do
    local id=A.LoreNoteResolve('n',name)
    Check(id=='npc:balnazzar' and Note(id)==nil,'both raw aliases respect hidden shared identity '..name)
end
Reset(); IsQuestFlaggedCompleted=function(id) return id==5262 end
Event('PLAYER_ENTERING_WORLD'); IsQuestFlaggedCompleted=nil
Check(Has('dungeon:stratholme','dreadlord') and not Has('npc:moira','unborn'),'current-character positive history only')
for id,before in pairs(canonical) do Check(Snapshot(A.GetLoreNote(id))==before,'canonical immutable '..id) end
if arg and arg[1] then
    local out=assert(io.open(arg[1],'w'))
    for _,scenario in ipairs({'fresh','all-disclosed'}) do
        Reset(); if scenario=='all-disclosed' then for _,id in ipairs({4004,4363,5262}) do Complete(id) end end
        for _,id in ipairs(targets) do
            local n=Note(id); out:write(scenario,' / ',id,'\n')
            if n then out:write(n.title,'\n',n.body,'\nSources: ',table.concat(n.sources or {},'; '),'\nRelated: ',table.concat(n.related or {},', '),'\n\n') else out:write('(undisclosed)\n\n') end
        end
    end
    out:close()
end
print('LoreRoyalBastionDiscovery: '..count..' checks, '..failed..' failures')
if failed>0 and not baseline then os.exit(1) end
