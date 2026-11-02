-- Recorded actions can open a reunion chapter; sixty can recall the beginning
-- without replacing the intervening scenes with a quest/death tally.
local root, A = 'Interface/AddOns/CompanionJournal/', {defaults={colors={}}}
function time(t) return type(t)=='table' and os.time(t) or 1792000000 end
function date(f,t) return os.date(f,t) end
for _, name in ipairs({'LoreData','Lore','LoreHordeStories','LoreAllianceStories','LoreWorldStories','LoreClassStories',
    'JournalBook','JournalTellers','JournalTale','JournalWords','JournalSelfWords','JournalSelfTale'}) do
    local path = root..name..'.lua'
    if arg and arg[1] and (name=='JournalSelfWords' or name=='JournalSelfTale') then path=arg[1]..'/'..name..'.lua' end
    assert(loadfile(path))('CompanionJournal', A)
end
local checks=0
local function check(ok,why) checks=checks+1;assert(ok,why) end
local t=os.time({year=2026,month=1,day=2,hour=18})
local function journey(entry,bond)
    local p={self=true,name='Framing',charKey='framing',race='Human',class='WARRIOR',faction='Alliance',startLevel=1,journal={}}
    local card={name='Mira',race='Human',class='WARRIOR',pronouns='she',bond=bond}
    A.db={people={mira=card}}
    local function event(e) p.journal[#p.journal+1]=e end
    event({k='play',t=t,e=t+8000,z='Elwynn Forest',pl=1,ol=1})
    for i=1,21 do event({k='quest',t=t+i*120,z='Elwynn Forest',qid=910000+i,d='Recorded Errand '..i,pl=1,ol=1}) end
    event({k='with',d='mira',n='Mira',t=t,e=t+8000,z='Elwynn Forest'})
    local later=t+90*86400
    event({k='play',t=later,e=later+8000,z='Blackwing Lair',pl=59,ol=59})
    event({k='with',d='mira',n='Mira',t=later,e=later+8000,z='Blackwing Lair'})
    if entry then event({k='dungeon',d='Blackwing Lair',t=later+60,z='Blackwing Lair',pl=59,ol=59}) end
    event({k='boss',d='Razorgore the Untamed',t=later+600,z='Blackwing Lair',pl=59,ol=59})
    event({k='wipe',d='Vaelastrasz the Corrupt',t=later+900,z='Blackwing Lair',pl=59,ol=59})
    event({k='mylevel',d=60,t=later+1200,z='Blackwing Lair',pl=60,ol=60})
    return p
end
local openings={}
for _,entry in ipairs({false,true}) do for _,bond in ipairs({false,'spouse'}) do
    local p=journey(entry,bond)
    for _,brief in ipairs({false,true}) do for retell=0,31 do
        local days=A.JournalBook(p)
        local stories=A.SelfTale.Tell(p,days,brief,retell)
        local text=A.JournalPlain(stories[days[#days].key].text)
        local opening=text:match('^[^.]+%.')
        check(text:find('level sixty',1,true),'sixty lost: '..text)
        check(text:find('Northshire Abbey',1,true) and text:lower():find('three months',1,true),'recorded beginning lost: '..text)
        check(text:find('Mira',1,true),'recorded companion lost: '..text)
        check(text:find('Razorgore',1,true) and text:find('Vaelastrasz',1,true),'win or failed fight lost: '..text)
        check(not text:find('quests on the way',1,true) and not text:find('quests turned in',1,true)
            and not text:find('In between I had turned in',1,true) and not text:find('quests along the way',1,true),
            'sixty still ends with a derived work tally: '..text)
        check(not text:find('never died once',1,true),'sparse record became deathless lifetime: '..text)
        check(not opening:find('^On '),'reunion repeats the chapter date: '..opening)
        local entered=opening:find('went into',1,true) or opening:find('entered',1,true)
        check((entered and entry) or (not entered and not entry),'entry wording needs an entry event: '..text)
        check(not bond or opening:find('my wife',1,true),'bond lost: '..opening)
        check(text==A.JournalPlain(A.SelfTale.Tell(p,A.JournalBook(p),brief,retell)[days[#days].key].text),'rerender changed')
        openings[opening]=true
    end end
end end
local n=0;for _ in pairs(openings) do n=n+1 end
check(n==8,'all field/dungeon and bonded/unbonded opening alternatives exercised: '..n)
print('StoryEditorialFraming: '..checks..' checks passed; '..n..' distinct openings')
