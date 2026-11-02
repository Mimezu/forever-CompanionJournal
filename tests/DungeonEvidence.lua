-- Boss victories must not grant unrecorded follow-up events or global cures.
function time(t) return type(t)=='table' and os.time(t) or 1792000000 end
function date(f,t) return os.date(f,t) end
local A={defaults={colors={}}}
for _,file in ipairs({'LoreData','Lore'}) do assert(loadfile('Interface/AddOns/CompanionJournal/'..file..'.lua'))('CompanionJournal',A) end
local L,checks=A.Lore,0
local function check(value,why) checks=checks+1; assert(value,why) end
for alias,canonical in pairs({Deadmines='The Deadmines',['Sunken Temple']="The Temple of Atal'Hakkar",['Stormwind Stockade']='The Stockade',
    ["Temple of Ahn'Qiraj"]="Ahn'Qiraj Temple",['Hall of Thanes']='The Hall of Thanes'}) do
    check(L.DungeonStory(alias)==L.DungeonStory(canonical),alias..' retains authored dungeon scenes')
    check(L.DungeonLevels(alias)==L.DungeonLevels(canonical),alias..' retains level context')
end
for _,dungeon in ipairs({'Ruins of Lordaeron','The Hall of Thanes'}) do
    local story=assert(L.DungeonStory(dungeon))
    check(story.setting=='Forever' and story.source and #story.why>0 and #story.inside>0,'captured custom setting remains distinct: '..dungeon)
end
local forbidden={
    Onyxia={'city gate','head would'},
    ['Mutanus the Devourer']={'Naralex woke','Naralex was awake','Barrens had a chance to heal','nightmare in the caverns was broken'},
    ['Edwin VanCleef']={'would not sail'},
    Archaedas={'keepers slept','vault of Uldaman was quiet'},
    ["Aku'mai"]={'nothing left'},
    ['Shade of Eranikus']={'at rest'},
    ['Prince Tortheldrin']={'last Highborne'},
}
for name,phrases in pairs(forbidden) do
    local boss=assert(L.Boss(name))
    local all={boss.e,boss.after}; for _,line in ipairs(boss.afterMore or {}) do all[#all+1]=line end
    for _,line in ipairs(all) do for _,phrase in ipairs(phrases) do check(not line:find(phrase,1,true),name..' invents '..phrase) end end
end
check(L.Boss('Lord Vyletongue').e:find('satyr',1,true),'quest7044 satyr identity')
check(not L.Boss('Celebras the Cursed').e:find('son of Zaetar',1,true),'quest7046 describes his uncle')
check(L.Boss('Celebras the Cursed').kind~='undead','quest7044/7046 living Celebras')
check(L.Boss('Lethtendris').e:find('blood elf',1,true),'quests7488/7489 blood elf mage')
for _,file in ipairs({'JournalBook','JournalTellers','JournalTale','JournalWords','JournalSelfWords','JournalSelfTale'}) do
    assert(loadfile('Interface/AddOns/CompanionJournal/'..file..'.lua'))('CompanionJournal',A)
end
local t=1792000000
for _,scenario in ipairs({{'Majordomo Executus','Molten Core',60,'submitted','surrendered'},{'Celebras the Cursed','Maraudon',49,'curse','corruption'}}) do
    for _,companion in ipairs({false,true}) do for _,brief in ipairs({false,true}) do for _,loss in ipairs({false,true}) do
        local p={self=not companion,name='Reed-Review',charKey='evidence',race='Tauren',class='SHAMAN',faction='Horde',pronouns='they',bond='friend',startLevel=scenario[3],journal={}}
        local function event(k,seconds,extra)
            local e={k=k,t=t+seconds,z=scenario[2],pl=scenario[3],ol=scenario[3]}
            for key,value in pairs(extra or {}) do e[key]=value end
            p.journal[#p.journal+1]=e
        end
        event(companion and 'group' or 'play',0,{e=t+3600})
        event('dungeon',20,{d=scenario[2]})
        if loss then event('death',100,{d=scenario[1],boss=scenario[1],w='you'}); event('wipe',200,{d=scenario[1]}) end
        event('boss',600,{d=scenario[1]})
        for retell=0,7 do
            p.retell=retell
            local days=A.JournalBook(p)
            local tale=companion and A.JournalTale.Tell(p,days,'we',{name='Review',race='Tauren',class='SHAMAN',faction='Horde'},brief) or A.SelfTale.Tell(p,days,brief,retell)
            local out={} for _,d in ipairs(days) do if tale[d.key] then out[#out+1]=A.JournalPlain(tale[d.key].text) end end
            local text=table.concat(out,' ')
            check(text:find(scenario[4],1,true) or text:find(scenario[5],1,true),scenario[1]..' lacks the actual encounter outcome: '..text)
            for sentence in text:gmatch('[^.!?]+[.!?]') do
                if sentence:find(scenario[1],1,true) then
                    check(not sentence:find('slain',1,true) and not sentence:find('killed '..scenario[1],1,true) and not sentence:find('lay dead',1,true), 'nonlethal encounter described as a kill: '..sentence)
                end
            end
        end
    end end end
end
print('DungeonEvidence: '..checks..' checks; aliases and evidence-bounded boss consequences')
