-- Regressions exposed by the saved thirty journeys, through actual renderers.
local root,A='Interface/AddOns/CompanionJournal/',{defaults={colors={}}}
function time(t) return type(t)=='table' and os.time(t) or 1792000000 end
function date(f,t) return os.date(f,t) end
for _,name in ipairs({'LoreData','Lore','LoreHordeStories','LoreAllianceStories','LoreWorldStories','LoreClassStories',
    'JournalBook','JournalTellers','JournalTale','JournalWords','JournalSelfWords','JournalSelfTale'}) do
    local path=root..name..'.lua'
    if arg and arg[1] and (name=='JournalTale' or (name=='JournalSelfTale' and arg[2]~='companion')) then path=arg[1]..'/'..name..'.lua' end
    assert(loadfile(path))('CompanionJournal',A)
end
local checks=0
local function check(v,m) checks=checks+1;assert(v,m) end
local function render(p,brief,retell,player,voice)
    p.retell=retell
    local days=A.JournalBook(p)
    local stories=p.self and A.SelfTale.Tell(p,days,brief,retell) or A.JournalTale.Tell(p,days,voice or 'we',player,brief)
    local out={};for _,d in ipairs(days) do if stories[d.key] then out[#out+1]=A.JournalPlain(stories[d.key].text) end end
    return table.concat(out,'\n\n')
end
local t=os.time({year=2026,month=1,day=2,hour=18})
local p={self=true,name='Writer',race='Human',class='WARRIOR',startLevel=60,journal={
    {k='play',t=t,e=t+14400,z='Blackwing Lair',pl=60,ol=60},
    {k='dungeon',d='Blackwing Lair',t=t+60,z='Blackwing Lair',pl=60,ol=60},
    {k='boss',d='Razorgore the Untamed',t=t+3600,z='Blackwing Lair',pl=60,ol=60}}}
local original=A.SelfWords.killOne
-- Check both grammatical positions; a blanket trailing comma breaks objects.
for _,template in ipairs({'{boss} fell.','{We} killed {boss}.','{We} brought down {boss}.'}) do
    A.SelfWords.killOne={template}
    for _,brief in ipairs({false,true}) do for retell=0,7 do
        local text=render(p,brief,retell)
        check(text:find("guardian of Blackwing Lair's eggs",1,true),'boss epithet case not exercised')
        check(not text:find("eggs fell",1,true),'unclosed subject epithet: '..text)
        check(not text:find(',.',1,true),'object epithet acquired dangling comma: '..text)
        check(text==render(p,brief,retell),'boss render not stable')
    end end
end
A.SelfWords.killOne=original

local players={}
for n=1,300 do local player={name='Grammar'..n,race='Human',class='WARRIOR',faction='Alliance'}
    local _,key=A.JournalTellers.For(player);players[key]=players[key] or player end
local base='StorageInvestigation/storytelling-thirty-20261013/v2/'
local Study=dofile(base..'study-lib.lua')
local fixtures=dofile(base..'fixtures.lua')
local people=Study.materialize(fixtures,Study.questCatalog('StorageInvestigation/journal-voice/review/corpus_vanilla_quests.txt'))
local sampleCount=0
for _,index in ipairs({15,16,18,22,26,27}) do
    local row=people[index]
    -- The study's companion conversion is part of the accepted input contract.
    local card=Study.clone(row.sharedPerson)
    card.journal=Study.clone(row.sharedJournal)
    card.charKey='editorial-'..index
    A.SelfPerson=function() return row.person end
    for _,player in pairs(players) do for _,voice in ipairs({'we','you'}) do for retell=0,3 do
        local text=render(card,false,retell,player,voice)
        check(not text:find('%. Spent ') and not text:find('^Spent ') and not text:find('\nSpent '),'bare Spent predicate: '..text)
        check(not text:find('%. Stayed ') and not text:find('^Stayed ') and not text:find('\nStayed '),'bare Stayed predicate: '..text)
        check(not text:find('make war for ',1,true),'duration attached to centaur war: '..text)
        check(not text:find('all frost and silence for ',1,true),'duration inside Winterspring description: '..text)
        check(not text:find(',.',1,true) and not text:find(',,',1,true),'punctuation doubled: '..text)
        sampleCount=sampleCount+1
    end end end
end
check(sampleCount==240,'profile grammar sample matrix incomplete')
-- Exercise the descriptive insertion even when the neutral gap opener already
-- names the zone in most saved outings. The test keeps a real recorded outing
-- but fixes the surrounding phrase choices to isolate the grammatical boundary.
local PB=A.JournalTale.phrases
PB.meetGroup={'I met {name}.'}
PB.dayGo={'were {inZone} for {length}'}
PB.dayGoQuiet=PB.dayGo
PB.day={'{pair} {day}.'}
PB.dayAlt=nil;PB.dayLead=nil
for _,key in ipairs(A.JournalTellers.order) do
    A.JournalTellers[key].meetGroup=PB.meetGroup
    A.JournalTellers[key].dayGo=PB.dayGo
    A.JournalTellers[key].day=PB.day
end
local described=0
for _,zone in ipairs({'Desolace','Winterspring'}) do for retell=0,31 do
    local card={name='QuietCompanion',race='Human',class='WARRIOR',pronouns='they',journal={
        {k='group',t=t,e=t+12000,z=zone,pl=55,ol=55},
        {k='quest',d='Recorded Errand',qid=900101,t=t+600,z=zone,pl=55,ol=55},
        {k='quest',d='Another Errand',qid=900102,t=t+900,z=zone,pl=55,ol=55}}}
    A.SelfPerson=function() return nil end
    local text=render(card,false,retell,{name='ClauseTest',race='Human',class='WARRIOR'},'we')
    check(not text:find('make war for ',1,true) and not text:find('all frost and silence for ',1,true),'unclosed descriptive place: '..text)
    check(not text:find(',,',1,true) and not text:find(',.',1,true),'bad clause punctuation: '..text)
    if text:find('make war, for ',1,true) or text:find('all frost and silence, for ',1,true) then described=described+1 end
end end
check(described>0,'descriptive place before duration was not exercised')
print('StoryEditorialGrammar: '..checks..' checks passed; '..sampleCount..' companion renders')
