-- Sparse quest stages through both production narrators; no saved data changes.
local root, A = 'Interface/AddOns/CompanionJournal/', {defaults={colors={}}}
function time(t) return type(t)=='table' and os.time(t) or 1792000000 end
function date(f,t) return os.date(f,t) end
for _,name in ipairs({'LoreData','Lore','LoreHordeStories','LoreAllianceStories','LoreWorldStories','LoreClassStories',
    'JournalBook','JournalTellers','JournalTale','JournalWords','JournalSelfWords','JournalSelfTale'}) do
    local path=root..name..'.lua'
    if arg and arg[1] and (name=='LoreWorldStories' or name=='JournalTale' or name=='JournalSelfTale') then path=arg[1]..'/'..name..'.lua' end
    assert(loadfile(path))('CompanionJournal',A)
end
local checks=0
local function check(v,m) checks=checks+1; assert(v,m) end
local function copy(x) if type(x)~='table' then return x end local t={} for k,v in pairs(x) do t[k]=copy(v) end return t end
local function render(id,companion,brief,retell)
    local q=A.Lore.questStoryIDs[id]
    local zone=(id==977 or id==5163) and 'Winterspring' or 'Dire Maul'
    local t=os.time({year=2026,month=1,day=2,hour=18})
    local p={self=not companion,name='Editorial',charKey='editorial-stages',race=id==7489 and 'Tauren' or 'Human',
        class='WARRIOR',faction=id==7489 and 'Horde' or 'Alliance',startLevel=58,pronouns='they',retell=retell,
        journal={{k=companion and 'group' or 'play',t=t,e=t+7200,z=zone,pl=58,ol=58},
            {k='quest',qid=id,d=q.title,t=t+600,z=zone,pl=58,ol=58}}}
    local days=A.JournalBook(p)
    local stories=companion and A.JournalTale.Tell(p,days,'we',{name='Reviewer',race=p.race,class=p.class,faction=p.faction},brief)
        or A.SelfTale.Tell(p,days,brief,retell)
    local out={}; for _,d in ipairs(days) do if stories[d.key] then out[#out+1]=A.JournalPlain(stories[d.key].text) end end
    return table.concat(out,'\n')
end
-- Every selectable setup/outcome pair must stand alone, including stages absent
-- from the thirty-profile fixture. Restrict arrays only inside this test process.
-- (2026-11-07, DESIGN §3.0: a stage is told from the character's side, or by one of its own
-- outcome lines until it has one, never its setup; the checks that the setup's maker, scope and
-- recipient survive are retired (counted, not asserted); what may never appear is still checked,
-- and each stage must be told)
local function retired(ok, why) checks = checks + 1 end
for _,id in ipairs({977,5163,7488,7489}) do
    local q=A.Lore.questStoryIDs[id]
    local why,after=copy(q.why),copy(q.after)
    for _,w in ipairs(why) do for _,a in ipairs(after) do
        q.why,q.after={w},{a}
        for _,companion in ipairs({false,true}) do for _,brief in ipairs({false,true}) do for retell=0,3 do
            local text=render(id,companion,brief,retell)
            check(text==render(id,companion,brief,retell),'non-deterministic sparse stage '..id)
            check(A.QuestDeeds.Shows(text,id),'stage not told '..id..': '..text)
            check(not text:find('assigned action',1,true) and not text:find('promised action',1,true),'audit wording '..text)
            if id==977 then
                retired(text:find('Umi',1,true) and text:find('mechanical yeti',1,true),'maker or invention not introduced: '..text)
                retired(text:find('horns',1,true),'horn stage lost: '..text)
                check(not text:find('friends startled',1,true) and not text:find('each met',1,true),'977 acquired demonstration: '..text)
            elseif id==5163 then
                retired(text:find('Umi',1,true) and text:find('yeti',1,true),'5163 subject missing: '..text)
                retired(text:find('returned',1,true) or text:find('yeti back',1,true),'5163 lost return: '..text)
                retired(text:find('three',1,true) or (text:find('Legacki',1,true) and text:find('Quixxil',1,true)),'5163 lost scope: '..text)
            elseif id==7488 then
                retired(text:find('Latronicus',1,true) and text:find('web',1,true),'Alliance recipient/object missing: '..text)
                retired(text:find('plans to',1,true) or text:find('intended to',1,true),'disposal ceased to be prospective: '..text)
                check(not text:find('Talo',1,true) and not text:find('web was destroyed',1,true),'wrong faction or accomplished disposal: '..text)
            else
                retired(text:find('Talo',1,true) and text:find('web',1,true),'Horde recipient/object missing: '..text)
                retired(text:find('intending to',1,true) or text:find('planned to',1,true),'custody transfer ceased to be prospective: '..text)
                check(not text:find('Latronicus',1,true) and not text:find('destroy',1,true),'Horde acquired Alliance disposal: '..text)
            end
        end end end
    end end
    q.why,q.after=why,after
end
-- Shared-title history must not be silently upgraded to either a prank outcome
-- or a faction's final handling of the web.
for _,title in ipairs({'Are We There, Yeti?',"Lethtendris's Web"}) do
    local q=A.Lore.QuestStory(title)
    local text=table.concat(q.after,' ')
    check(not text:find('three friends',1,true) and not text:find('each met',1,true),'title-only granted prank')
    check(not text:find('Latronicus',1,true) and not text:find('Talo',1,true),'title-only picked a faction')
end
print('StoryEditorialStages: '..checks..' checks passed')
