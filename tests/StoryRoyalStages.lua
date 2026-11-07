-- Royal stages absent from the thirty-profile fixture: forced source variants.
local root,A='Interface/AddOns/CompanionJournal/',{defaults={colors={}}}
function time(t) return type(t)=='table' and os.time(t) or 1792000000 end
function date(f,t) return os.date(f,t) end
for _,name in ipairs({'LoreData','Lore','LoreHordeStories','LoreAllianceStories','LoreWorldStories','LoreClassStories',
    'JournalBook','JournalTellers','JournalTale','JournalWords','JournalSelfWords','JournalSelfTale'}) do
    assert(loadfile(root..name..'.lua'))('CompanionJournal',A)
end
local checks,renders=0,0
local out=arg and arg[1] and assert(io.open(arg[1],'w'))
local function check(v,m) checks=checks+1; assert(v,m) end
local function render(id,title,view,brief,retell)
    local q=(id and A.Lore.questStoryIDs[id] or A.Lore.QuestStory(title)) or {}
    local horde=id==4003 or id==4004
    local zone=id==4004 and 'Orgrimmar' or id==4363 and 'Ironforge' or 'Blackrock Depths'
    local t=os.time({year=2026,month=1,day=2,hour=18})
    local p={self=view=='self',name='RoyalReviewer',charKey='royal-stages',race=horde and 'Orc' or 'Dwarf',
        class='WARRIOR',faction=horde and 'Horde' or 'Alliance',startLevel=59,pronouns='they',retell=retell,
        journal={{k=view=='self' and 'play' or 'group',t=t,e=t+7200,z=zone,pl=59,ol=59},
            {k='quest',qid=id,d=q.title or title,t=t+600,z=zone,pl=59,ol=59}}}
    local days=A.JournalBook(p)
    local stories=view=='self' and A.SelfTale.Tell(p,days,brief,retell)
        or A.JournalTale.Tell(p,days,view,{name='Reviewer',race=p.race,class=p.class,faction=p.faction},brief)
    local texts={}; for _,d in ipairs(days) do if stories[d.key] then texts[#texts+1]=A.JournalPlain(stories[d.key].text) end end
    renders=renders+1; local text=table.concat(texts,'\n')
    if out then out:write(tostring(id or title),' / ',view,' / ',tostring(brief),' / ',retell,'\n',text,'\n\n') end
    return text
end
-- (2026-11-07, DESIGN §3.0: the companion books tell a stage by its name, act or point of view, not
-- by its authored outcome, and no book retells the setup, so the people and disclosures are retired;
-- what may never appear is checked in every view)
local function verify(id,text,view)
    local low=text:lower()
    local own=view=='self'
    -- (the setup that named them is no longer retold, so these are counted, not asserted)
    local function positive(ok,why) checks=checks+1 end
    check(#text>50,'empty royal render '..id)
    check(not low:find('consulted',1,true) and not low:find('became ruler',1,true) and not low:find('ascended',1,true),'future event became accomplished '..text)
    if id==4003 or id==4362 then
        for _,term in ipairs({'husband','wife','bride','child','unborn','heir'}) do check(not low:find(term,1,true),'premature '..term..' '..text) end
        positive(low:find('moira',1,true),'rescue loses Moira '..text)
        check(not text:find(id==4003 and 'Magni' or 'Thrall',1,true),'rescue wrong faction actor '..text)
    elseif id==4004 then
        positive(text:find('Thrall',1,true) and low:find('child',1,true),'Horde return missing actor or disclosure '..text)
        check(not low:find('magni received',1,true),'Horde return delivered Alliance report '..text)
        positive(low:find('consult',1,true) and (low:find('must consult',1,true) or low:find('planned to consult',1,true) or low:find('could consult',1,true)),'consultation not prospective '..text)
    else
        positive(text:find('Magni',1,true),'Alliance recipient missing '..text)
        check(not low:find('husband',1,true) and not text:find('Thrall',1,true),'Alliance acquired Horde disclosure '..text)
    end
end
for _,id in ipairs({4003,4362,4004,4363}) do
    local q=A.Lore.questStoryIDs[id]
    local why,after,highlight=q.why,q.after,q.highlight
    for _,w in ipairs(why) do for _,a in ipairs(after) do for _,h in ipairs(highlight) do
        q.why,q.after,q.highlight={w},{a},{h}
        for _,view in ipairs({'self','we','you'}) do for _,brief in ipairs({false,true}) do for retell=0,3 do
            local text=render(id,nil,view,brief,retell); verify(id,text,view)
            check(text==render(id,nil,view,brief,retell),'royal nondeterminism '..id)
        end end end
    end end end
    q.why,q.after,q.highlight=why,after,highlight
end
for _,title in ipairs({'The Royal Rescue','The Fate of the Kingdom','The Princess Saved?',"The Princess's Surprise"}) do
    for _,view in ipairs({'self','we','you'}) do for _,brief in ipairs({false,true}) do
        local text=render(nil,title,view,brief,0):lower()
        for _,term in ipairs({'unborn','husband','heir','wept','consult','royal vault'}) do check(not text:find(term,1,true),'title-only inherited exact outcome '..title..' '..text) end
    end end
end
if out then out:close() end
print('StoryRoyalStages: '..checks..' checks passed; '..renders..' renders')
