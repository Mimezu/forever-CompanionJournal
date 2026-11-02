-- Bounded Oct 16 editorial regression. Optional output path, then 'baseline',
-- then preserved LoreDiscoveryData path reproduces the pre-policy leaks.
local root = 'Interface/AddOns/CompanionJournal/'
local count, failed, frames, shown = 0, 0, {}, nil
local A = {db={characters={Reader={level=1,journal={}},Alt={level=60,journal={}}}}}
function A.Me() return 'Reader' end
function time() return 1792100000 end
function CreateFrame()
    local f={events={}}
    function f:RegisterEvent(e) self.events[e]=true end
    function f:SetScript(_,fn) self.callback=fn end
    frames[#frames+1]=f
    return f
end
function GetQuestID() return shown end
local function Event(e,id)
    for _,f in ipairs(frames) do if f.events[e] then f.callback(f,e,id) end end
end
local baseline=arg and arg[2]=='baseline'
for _,name in ipairs({'LoreData','Lore','LoreHordeStories','LoreAllianceStories','LoreWorldStories','LoreClassStories',
    'LoreNotes','LorePlaces','LorePeopleHistory','LoreWorldConnections','LoreDiscovery','LoreDiscoveryData'}) do
    local path = name=='LoreDiscoveryData' and baseline and arg[3] or root..name..'.lua'
    assert(loadfile(path))('CompanionJournal',A)
end
local function Check(ok,label)
    count=count+1
    if not ok then failed=failed+1; if baseline then if failed<10 then print('BASELINE: '..label) end else error(label) end end
end
local function Snapshot(v)
    if type(v)~='table' then return type(v)..':'..tostring(v) end
    local keys,out={},{}
    for k in pairs(v) do keys[#keys+1]=k end
    table.sort(keys,function(a,b) return tostring(a)<tostring(b) end)
    for _,k in ipairs(keys) do out[#out+1]=Snapshot(k)..'='..Snapshot(v[k]) end
    return '{'..table.concat(out,'|')..'}'
end
local function Note(id) return A.GetKnownLoreNote(id) end
local function Has(id,words)
    local note=Note(id)
    return note and note.body:lower():find(words:lower(),1,true)
end
local function Present(id) shown=id; Event('QUEST_DETAIL') end
local function Complete(id) Event('QUEST_TURNED_IN',id) end
local function Reset() A.db.characters.Reader={level=1,journal={}}; A.db.characters.Alt.journal={} end
local guarded={
    ['faction:hydraxian-waterlords']={'quintessence','runes'},
    ['dungeon:blackwing']={'vaelastrasz','mark of drakkisath','captive'},
    ['npc:vaelastrasz']={'corrupt','forced','shard','essence of the red'},
    ['npc:nefarian']={'shard','powder'},
    ['faction:red-dragonflight']={'shard','nefarius'},
    ['relic:scepter-shifting-sands']={'vaelastrasz','azshara','red shard'},
    ['relic:discs-norgannon']={'trogg','descendant','enchanted creation'},
    ['npc:archaedas']={'trogg','descendant'},
    ['faction:explorers-league']={'earthen','enchanted creation'},
    ['npc:kelthuzad']={'phylactery','montoy'},
    ['dungeon:naxxramas']={'phylactery','mograine','montoy','cloaking'},
    ['npc:nogg']={'safe','combination'},
    ['dungeon:maraudon']={'two parts','two pieces','stole','rod and diamond'},
    ['npc:noxxion']={'scepter','orange'},
    ['npc:vyletongue']={'scepter','purple'},
    ['npc:celebras']={'scepter','rod','diamond'},
    ['relic:scepter-celebras']={'two parts','two pieces','vyletongue','noxxion'},
}
for title,words in pairs({
    ['The Platinum Discs']={'trogg','descendant','enchanted creation'},
    ["Nefarius's Corruption"]={'vaelastrasz','shard'},
    ["The Fall of Kel'Thuzad"]={'phylactery','montoy'},
    ['Legends of Maraudon']={'two parts','two pieces','noxxion'},
    ['The Scepter of Celebras']={'rod and diamond','restores','vyletongue'},
}) do
    local id=A.LoreNoteResolve('q',title)
    -- Exact-only packs intentionally publish no clickable title-only note.
    Check(id==nil or A.GetLoreNote(id).kind=='Quest','optional title reference '..title)
    if id then guarded[id]=words end
end
for _,qid in ipairs({2278,2279,2280,2439,2440}) do
    Check(A.GetLoreNote('quest:'..qid)~=nil,'exact Platinum reference registered '..qid)
    guarded['quest:'..qid]={'trogg','descendant','enchanted creation'}
end
guarded['quest:9120']={'phylactery','montoy'}
guarded['quest:7044']={'two parts','two pieces','noxxion'}
guarded['quest:7046']={'rod and diamond','restores','vyletongue'}
local raw={}
for id in pairs(guarded) do raw[id]=Snapshot(assert(A.GetLoreNote(id))) end
raw['relic:phylactery-kelthuzad']=Snapshot(assert(A.GetLoreNote('relic:phylactery-kelthuzad')))
local function Public(label)
    for id,words in pairs(guarded) do
        local note=Note(id)
        Check(note and #note.body>80,label..' useful public '..id)
        if note then
            local all=Snapshot(note):lower()
            for _,word in ipairs(words) do Check(not all:find(word,1,true),label..' no '..word..' '..id) end
            Check(not note.names and not note.autoLink,label..' raw aliases not projected')
        end
    end
    Check(Note('relic:phylactery-kelthuzad')==nil,label..' artifact remains unknown')
    local vael=Note('npc:vaelastrasz')
    Check(vael and vael.title=='Vaelastrasz',label..' title does not announce corruption')
end
Public('fresh')
local before=Snapshot(A.db)
for _=1,3 do for id in pairs(guarded) do Note(id) end end
Check(Snapshot(A.db)==before,'reading does not grant knowledge or mutate characters')
A.db.characters.Reader.level=60
A.db.characters.Reader.journal={{k='dungeon',d='Uldaman'},{k='boss',d='Archaedas'},{k='dungeon',d='Blackwing Lair'},{k='quest',d="The Fall of Kel'Thuzad"},{k='quest',d='The Platinum Discs'}}
A.db.characters.Alt.journal={{k='quest',qid=2278},{k='quest',qid=8730},{k='quest',qid=9120},{k='quest',qid=7044},{k='quest',qid=7046},{k='quest',qid=2841}}
Public('visit-level-title-alt')
for _,flag in ipairs({'imported','seeded','s'}) do
    Reset(); A.db.characters.Reader.journal={{k='quest',qid=2278,[flag]=true},{k='quest',qid=9120,[flag]=true}}
    Public(flag)
end
Reset(); Present(2278)
Check(Has('relic:discs-norgannon','making of the earthen'),'2278 presentation names record subject')
Check(not Has('relic:discs-norgannon','descendants'),'2278 presentation does not reveal dialogue answer')
local exact=A.LoreNoteResolve('q','The Platinum Discs',{qid=2278})
Check(exact and not Has(exact,'descendants'),'exact-ID reference respects presentation boundary')
Complete(2278)
Check(Has('relic:discs-norgannon','descendants') and Has('faction:explorers-league','descendants'),'2278 completed dialogue reaches relevant references')
Check(exact and Has(exact,'descendants'),'known history reaches exact quest reference')
Check(not Has('relic:discs-norgannon','miniature copy'),'2278 stops before receiving copy')
for _,qid in ipairs({2279,2280,2439,2440}) do
    Reset(); Complete(qid)
    Check(not Has('relic:discs-norgannon','descendants'),'later stage does not inherit optional history '..qid)
end
Reset(); Complete(2279)
Check(Has('relic:discs-norgannon','miniature copy') and Has('faction:explorers-league','possible evidence'),'Alliance delivery supports copy and interpretation')
Reset(); Complete(2280)
Check(Has('relic:discs-norgannon','miniature copy') and not Has('faction:explorers-league','possible evidence'),'Horde delivery does not prove Alliance interpretation')
Reset(); Present(8730)
Check(Has('npc:vaelastrasz','plans to destroy') and not Has('npc:vaelastrasz','soul is at peace'),'shard warning before return')
for _,qid in ipairs({8730,6824,7486}) do
    Reset(); Complete(qid)
    Check(not Has('npc:vaelastrasz','forced') and not Has('npc:vaelastrasz','corrupt'),'no inferred mind-control gossip '..qid)
    Check(not Has('faction:hydraxian-waterlords','quintessence'),'no inferred quintessence gossip '..qid)
end
Reset(); Complete(8730)
Check(Has('npc:vaelastrasz','soul is at peace'),'8730 return supports soul report')
Reset(); Present(7761)
Check(Has('dungeon:blackwing','Mark of Drakkisath'),'recorded orders disclose entry method')
Reset(); Present(9120)
Check(Note('relic:phylactery-kelthuzad') and Has('npc:kelthuzad','reform'),'quest presentation supports vessel danger')
for _,id in ipairs({'relic:phylactery-kelthuzad','npc:kelthuzad','dungeon:naxxramas'}) do Check(not Has(id,'Montoy'),'presentation does not reveal recipient '..id) end
Complete(9120)
Check(Has('relic:phylactery-kelthuzad','Montoy') and Has('npc:kelthuzad','Montoy'),'completion supports handoff')
Reset(); Present(7044)
Check(Has('npc:noxxion','orange') and Has('npc:vyletongue','purple'),'presented commission supports piece locations')
Check(not Has('relic:scepter-celebras','ritual restores'),'commission does not restore scepter')
Reset(); Present(7046)
Check(Has('relic:scepter-celebras','offers to reunite') and not Has('relic:scepter-celebras','ritual restores'),'ritual offer before completion')
Check(not Has('relic:scepter-celebras','Vyletongue'),'later ritual does not inherit prior thief dialogue')
Complete(7046); Check(Has('relic:scepter-celebras','ritual restores'),'completed ritual restores relic')
Reset(); Present(2841)
Check(Has('npc:nogg','safe') and not Has('npc:nogg','With the plans delivered'),'safe commission before delivery')
Complete(2841); Check(Has('npc:nogg','With the plans delivered'),'completed theft supports delivery')
Reset()
for _,name in ipairs({'Vaelastrasz','Discs of Norgannon','Hydraxian Waterlords','Scepter of Celebras'}) do
    local id=A.LoreNoteResolve('p',name) or A.LoreNoteResolve('n',name)
    Check(id and Note(id),'alias resolves through projected note '..name)
end
for id,snapshot in pairs(raw) do Check(Snapshot(A.GetLoreNote(id))==snapshot,'canonical source preserved '..id) end
if arg and arg[1] then
    local out=assert(io.open(arg[1],'w'))
    local ids={}; for id in pairs(guarded) do ids[#ids+1]=id end; table.sort(ids)
    for _,scenario in ipairs({'fresh','learned'}) do
        Reset()
        if scenario=='learned' then for _,qid in ipairs({2278,2279,8730,7761,9120,7044,7046,2841}) do Complete(qid) end end
        for _,id in ipairs(ids) do local n=Note(id); out:write(scenario,' / ',id,' / ',n.title,'\n',n.body,'\nSources: ',table.concat(n.sources or {},'; '),'\nRelated: ',table.concat(n.related or {},', '),'\n\n') end
        local artifact=Note('relic:phylactery-kelthuzad')
        if artifact then out:write(scenario,' / ',artifact.id,' / ',artifact.title,'\n',artifact.body,'\nSources: ',table.concat(artifact.sources,'; '),'\nRelated: ',table.concat(artifact.related,', '),'\n\n') end
    end
    out:close()
end
print('LoreEditorialDiscovery: '..count..' checks, '..failed..' failures')
