-- Exact middle-journey scenes retain their evidence boundaries in actual prose.
-- Synthetic histories only; never read or change player SavedVariables.
local root, A = 'Interface/AddOns/CompanionJournal/', {defaults={colors={}}}
function time(t) return type(t)=='table' and os.time(t) or 1792000000 end
function date(f,t) return os.date(f,t) end
for _,name in ipairs({'LoreData','Lore','LoreHordeStories','LoreAllianceStories','LoreWorldStories','LoreClassStories',
    'JournalBook','JournalTellers','JournalTale','JournalWords','JournalSelfWords','JournalSelfTale'}) do
    assert(loadfile(root..name..'.lua'))('CompanionJournal',A)
end
local checks=0
local function check(v,msg) checks=checks+1; assert(v,msg) end
local function has(s,v) return s:find(v,1,true) end
local cases={
    [267]={who='Rugelfuss',avoid={'regiment left the gate','Magni received the teeth'}},
    [516]={who='Allister',avoid={'Scourge was removed','entire force was destroyed','cave was cleared'}},
    [1434]={who='Takata',avoid={'Thrall received the report','campaign was won','satyrs were redeemed'}},
    [4182]={who='Helendis',avoid={'Prestor','Onyxia','Windsor','conspiracy was exposed'}},
    [5064]={who='Longhorn',avoid={'visitors were Scourge','visitors were agents of','Grimtotem attack was defeated'}},
    [5142]={who='Pamela',avoid={'doll was recovered','Pamela was reunited','Darrowshire was saved'}},
    [5155]={who='Greta',avoid={'Jaedenar was liberated','Shadow Lord Fel\'dan was slain','water was cleansed'}},
    [544]={who='Wordeen',avoid={'treasure was found','Dalaran was entered','bloodstones were destroyed'}},
    [545]={who='Wordeen',avoid={'treasure was found','entered the dome','city was captured'}},
    [581]={who='Nimboya',avoid={'Yenniku was found','Yenniku was rescued','Yenniku was not among','Zanzil'}},
    [582]={who='Nimboya',avoid={'Yenniku was not among','Yenniku was found','Yenniku was rescued','Zanzil'}},
    [583]={who='Hemet',avoid={'great beast was slain','great hunt was complete','passed the trials'}},
    [584]={who='Nimboya',avoid={'heads revealed','heads answered','Yenniku was found','Yenniku was rescued','Zanzil'}},
    [596]={who="Kin'weelay",avoid={'spirits were weakened','spirits had weakened','Yenniku was rescued'}},
    [2978]={who='Rok Orhan',avoid={'ceremony was explained','ritual was revealed','Gordunni Orb','dark ritual was stopped'}}
}
local function render(id,shared,brief,retell)
    local q=A.Lore.questStoryIDs[id]
    local faction=(id==267 or id==4182) and 'Alliance' or 'Horde'
    local t=os.time({year=2026,month=7,day=3,hour=16})
    local p={self=not shared,name='Witness',charKey='synthetic-source-continuity',
        faction=faction,race=faction=='Alliance' and 'Human' or 'Orc',class='WARRIOR',
        pronouns='they',startLevel=q.level,retell=retell,journal={
        {k=shared and 'group' or 'play',t=t,e=t+3600,z=q.zone,pl=q.level,ol=q.level},
        {k='quest',t=t+1800,qid=id,d=q.title,z=q.zone,pl=q.level,ol=q.level}}}
    local days=A.JournalBook(p)
    local stories=shared and A.JournalTale.Tell(p,days,'we',{name='Observer',race=p.race,class=p.class,faction=faction},brief)
        or A.SelfTale.Tell(p,days,brief,retell)
    local out={}
    for _,day in ipairs(days) do if stories[day.key] then out[#out+1]=A.JournalPlain(stories[day.key].text) end end
    check(#p.journal==2 and p.journal[2].qid==id,'input history changed')
    return table.concat(out,'\n')
end
for id,boundary in pairs(cases) do
    local q=A.Lore.questStoryIDs[id]
    check(q and #q.why==2 and #q.after==2,'missing two-variant exact scene '..id)
    local whys,afters,highlights=q.why,q.after,q.highlight
    for _,why in ipairs(whys) do for _,after in ipairs(afters) do
        q.why,q.after={why},{after}
        for _,compact in ipairs(highlights or {false}) do
        q.highlight=compact and {compact} or nil
        for _,shared in ipairs({false,true}) do for _,brief in ipairs({false,true}) do for retell=0,3 do
            local s=render(id,shared,brief,retell)
            check(s==render(id,shared,brief,retell),'nondeterministic scene '..id)
            -- (2026-11-07, DESIGN §3.0: the stage is told from the character's side, or by one of its own
            -- lines; the own book keeps the forced outcome, the companion book names the work. The
            -- setup's person and purpose are no longer retold, so that check is counted, not asserted.)
            check(A.QuestDeeds.Shows(s,id),'recorded stage not told '..id..': '..s)
            checks=checks+1
            check(not has(s,'{p:') and not has(s,'{name}'),'unresolved token')
            for _,phrase in ipairs(boundary.avoid) do check(not has(s,phrase),'crossed source boundary '..id..': '..s) end
            if id==584 then checks=checks+1 end -- (the leaders' names came from the setup: retired)
            if id==596 and has(s,'ritual') then check(has(s,'planned') or has(s,'would'),'intended ritual became performed effect') end
            if id==544 and has(s,'punishment') then check(has(s,'called the punishment') or has(s,'he praised'),'Wordeen judgment became narrator endorsement') end
        end end end
    end end end
    q.why,q.after,q.highlight=whys,afters,highlights
end
-- A title is not evidence for an exact chain step or a discovered secret.
for _,id in ipairs({544,545,581,582,583,584,596}) do
    local q=A.Lore.questStoryIDs[id]
    check(A.Lore.QuestStory(q.title)==nil,'new exact context leaked through title-only record '..id)
    check(A.Lore.QuestStory(q.title,999999)==nil,'wrong ID acquired exact context '..id)
end
print('StorySourceContinuity: '..checks..' checks passed')
