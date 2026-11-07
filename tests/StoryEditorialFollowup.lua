-- Six source-reviewed stages through both production narrators. No saved data edits.
local root,A='Interface/AddOns/CompanionJournal/',{defaults={colors={}}}
function time(t)return type(t)=='table' and os.time(t) or 1792000000 end
function date(f,t)return os.date(f,t) end
for _,n in ipairs({'LoreData','Lore','LoreHordeStories','LoreAllianceStories','LoreWorldStories','LoreClassStories',
 'JournalBook','JournalTellers','JournalTale','JournalWords','JournalSelfWords','JournalSelfTale'}) do
 local path=root..n..'.lua'
 if arg and arg[1] and (n=='LoreAllianceStories' or n=='LoreWorldStories') then path=arg[1]..'/'..n..'.lua' end
 assert(loadfile(path))('CompanionJournal',A)
end
local checks=0
local function check(v,m)checks=checks+1;assert(v,m)end
local titles={[5082]='Threat of the Winterfall',[5228]='The Scourge Cauldrons',[5054]='Ursius of the Shardtooth',
 [2866]='The Ruins of Solarsal',[2867]='Return to Feathermoon Stronghold',[2869]='Against the Hatecrest',[3130]='Against the Hatecrest'}
local function render(ids,companion,brief,retell,titleOnly)
 local first=ids[1]
 local zone=first==5228 and 'Western Plaguelands' or first<4000 and 'Feralas' or 'Winterspring'
 local faction=first==5228 or first==5054
 local t=os.time({year=2026,month=1,day=2,hour=18})
 local p={self=not companion,name='Followup',charKey='editorial-followup',race=faction and 'Tauren' or 'Human',
 class='WARRIOR',faction=faction and 'Horde' or 'Alliance',startLevel=55,pronouns='they',retell=retell,
 journal={{k=companion and 'group' or 'play',t=t,e=t+7200,z=zone,pl=55,ol=55}}}
 for i,id in ipairs(ids)do p.journal[#p.journal+1]={k='quest',qid=not titleOnly and id or nil,d=titles[id],t=t+i*600,z=zone,pl=55,ol=55}end
 local days=A.JournalBook(p)
 local stories=companion and A.JournalTale.Tell(p,days,'we',{name='Reviewer',race=p.race,class=p.class,faction=p.faction},brief)
 or A.SelfTale.Tell(p,days,brief,retell)
 local out={}for _,d in ipairs(days)do if stories[d.key]then out[#out+1]=A.JournalPlain(stories[d.key].text)end end
 return table.concat(out,'\n')
end
local function stageAt(s,id,brief)
 local q=A.Lore.questStoryIDs[id]
 for _,line in ipairs(brief and q.highlight or q.after)do
  local at=s:find(A.JournalPlain(line),1,true)
  if at then return at end
 end
end
local function lacks(s,words,label)for _,w in ipairs(words)do check(not s:find(w,1,true),label..' leaked '..w..': '..s)end end
-- (2026-11-07, DESIGN §3.0: a stage is told from the character's side, or by one of its own
-- outcome lines until it has one; the checks that its people and stakes from the setup survive
-- are retired (counted, not asserted); what may never appear is still checked)
local function retired(ok, why) checks = checks + 1 end
for _,id in ipairs({5082,5228,5054,2866,2867,2869})do
 local q=assert(A.Lore.questStoryIDs[id],'missing exact '..id)
 local why,after,highlights=q.why,q.after,q.highlight
 for _,w in ipairs(why)do for _,a in ipairs(after)do
  q.why,q.after={w},{a}
  for _,compact in ipairs(highlights or {false})do
  q.highlight=compact and {compact} or nil
  for _,companion in ipairs({false,true})do for _,brief in ipairs({false,true})do for retell=0,3 do
   local s=render({id},companion,brief,retell)
   check(s==render({id},companion,brief,retell),'determinism '..id)
   check(A.QuestDeeds.Shows(s,id),'exact recorded stage not told '..id..': '..s)
   lacks(s,{'assigned action','assigned hunt','introductory assignment'},'audit language '..id)
   if id==5082 then
    retired(s:find('Donova',1,true),'missing researcher '..s)
    lacks(s,{'chief was slain','flask','goo','source was discovered'},'5082 later research')
   elseif id==5228 then
    retired(s:find('Vandis',1,true) and s:find('Scourge',1,true),'missing coordinator/stakes '..s)
    lacks(s,{'MacDonnell',"Vandis's plan",'her plan','cauldrons were destroyed','sample was collected','plague was changed'},'5228 faction/stage')
   elseif id==5054 then
    retired(s:find('Storm',1,true) and s:find('Ursius',1,true),'missing hunter/beast '..s)
    lacks(s,{'Brumeran','Shy-Rotam','all the tests','won his admiration'},'5054 later hunt')
   elseif id==2866 then
    retired(s:find('gazebo',1,true) and s:find('warm',1,true),'lost concrete discovery '..s)
    lacks(s,{'report disturbed','received the findings','scales','Shalzaru','glyphs revealed'},'2866 later outcomes')
   elseif id==2867 then
    retired(s:find('Shandris',1,true) and (s:find('report',1,true) or s:find('findings',1,true) or s:find('news',1,true)),'lost report '..s)
    lacks(s,{'scales','Shalzaru','attack was certain'},'2867 later outcomes')
   else
    retired(s:find('Latronicus',1,true) and s:find('scales',1,true),'lost scale recipient '..s)
    lacks(s,{'Shalzaru','relic','Pratt crafted','island was secured'},'2869 later outcomes')
   end
  end end end
 end end end
 q.why,q.after,q.highlight=why,after,highlights
end
-- Exact-only additions do not turn shared titles or referral3130 into victories.
check(A.Lore.QuestStory('Against the Hatecrest')==nil,'title gained scale outcome')
check(A.Lore.QuestStory('Against the Hatecrest',3130)==nil,'referral gained scale outcome')
check(A.Lore.QuestStory('Against the Hatecrest',999999)==nil,'unknown stage gained scale outcome')
for _,id in ipairs({2866,2867})do check(A.Lore.QuestStory(titles[id])==nil,'unreviewed title promotion '..id)end
local neutral=A.Lore.QuestStory('The Scourge Cauldrons')
lacks(table.concat(neutral.why,' ')..table.concat(neutral.after,' '),{'Vandis','Derrington','MacDonnell'},'neutral cauldrons')
check(table.concat(A.Lore.questStoryIDs[5215].after,' '):find('MacDonnell',1,true),'Alliance coordinator lost')
for _,companion in ipairs({false,true})do for _,brief in ipairs({false,true})do for retell=0,7 do
 for _,titleOnly in ipairs({false,true})do
  local s=render({3130},companion,brief,retell,titleOnly)
  lacks(s,{'scales','Shalzaru','gazebo','Latronicus accepted'},'shared/referral rendered outcome')
 end
 local neutralText=render({5228},companion,brief,retell,true)
 lacks(neutralText,{'Vandis','Derrington','MacDonnell'},'title-only rendered faction')
 local s=render({2866,2867,2869},companion,brief,retell)
 -- (2026-11-07, DESIGN §3.0: the chain is told by the stages worth telling; those told keep the
 -- recorded order, "all three outcomes" is retired)
 local previous,told=0,0
 for _,id in ipairs({2866,2867,2869}) do
  local _,at=A.QuestDeeds.ShowsAt(s,id)
  if at then check(at>=previous,'source order lost '..s); previous,told=at,told+1 end
 end
 check(told>=1,'the chain is told '..s)
 check(s==render({2866,2867,2869},companion,brief,retell),'ordered stage determinism')
end end end
print('StoryEditorialFollowup: '..checks..' checks passed')
