-- Source boundaries must survive every authored pairing in both narrators.
-- This is a synthetic offline test; it never loads or writes SavedVariables.
local root, A = 'Interface/AddOns/CompanionJournal/', {defaults = {colors = {}}}
function time(t) return type(t) == 'table' and os.time(t) or 1792000000 end
function date(f,t) return os.date(f,t) end
for _, name in ipairs({'LoreData','Lore','LoreHordeStories','LoreAllianceStories','LoreWorldStories','LoreClassStories',
    'JournalBook','JournalTellers','JournalTale','JournalWords','JournalSelfWords','JournalSelfTale'}) do
    assert(loadfile(root .. name .. '.lua'))('CompanionJournal', A)
end
local checks = 0
local function check(ok, reason) checks = checks + 1; assert(ok, reason) end
local function has(s, part) return s:find(part, 1, true) end
local function render(id, companion, brief, retell)
    local q, t = A.Lore.questStoryIDs[id], os.time({year=2026,month=1,day=2,hour=18})
    local faction = (id == 95 or id == 55 or id == 921) and 'Alliance' or 'Horde'
    local p = {self=not companion, name='Source reader', charKey='craft-source-reader',
        class='WARRIOR',race=id == 921 and 'NightElf' or (faction == 'Alliance' and 'Human' or 'Orc'),faction=faction,
        startLevel=q.level, pronouns='they', retell=retell, journal={
            {k=companion and 'group' or 'play',t=t,e=t+7200,z=q.zone,pl=q.level,ol=q.level},
            {k='quest',qid=id,d=q.title,t=t+600,z=q.zone,pl=q.level,ol=q.level}}}
    local days = A.JournalBook(p)
    local stories = companion and A.JournalTale.Tell(p,days,'we',{name='Recorder',race=p.race,class=p.class,faction=p.faction},brief)
        or A.SelfTale.Tell(p,days,brief,retell)
    local out = {}
    for _, d in ipairs(days) do if stories[d.key] then out[#out+1] = A.JournalPlain(stories[d.key].text) end end
    return table.concat(out, '\n')
end
-- (2026-11-07, DESIGN §3.0: a stage is told from the character's side, or by one of its own
-- outcome lines until it has one; its setup is no longer retold, so the checks that each stage's
-- giver, purpose and material survive are retired (counted, not asserted). What may never appear,
-- the evidence bounds below, is still checked.)
local function retired(ok, why) checks = checks + 1 end
for _, id in ipairs({790,804,23,95,55,1058,2973,2974,921,5241}) do
    local q = A.Lore.questStoryIDs[id]
    local whys, afters, highlights = q.why, q.after, q.highlight
    for _, why in ipairs(whys) do for _, after in ipairs(afters) do
        -- Force each possible pairing, including those a small fixture may miss.
        q.why, q.after = {why}, {after}
        for _, compact in ipairs(highlights or {false}) do
        q.highlight = compact and {compact} or nil
        for _, companion in ipairs({false,true}) do for _, brief in ipairs({false,true}) do for retell=0,3 do
            local s = render(id,companion,brief,retell)
            check(s == render(id,companion,brief,retell), 'unstable source scene ' .. id)
            check(A.QuestDeeds.Shows(s,id) and (companion or q.pov or has(s,A.QuestDeeds.NoSemicolon(A.JournalPlain(brief and compact or after)))), 'exact stage not told: ' .. s)
            check(not has(s,'{p:') and not has(s,'{name}'), 'unresolved prose token: ' .. s)
            if id == 790 then
                retired(has(s,"Hana'zua") and has(s,'pride'), 'lost wounded hunter: ' .. s)
                check(not has(s,'promised immediate aid') and not has(s,'send help'), 'kill stage acquired later relief: ' .. s)
            elseif id == 804 then
                retired(has(s,'Gornek') and has(s,'promised'), 'aid ceased to be a promise: ' .. s)
                check(not has(s,"Hana'zua was healed") and not has(s,'hunter was rescued'), 'promised aid became rescue: ' .. s)
            elseif id == 23 then
                retired(has(s,'Senani') and has(s,'crescent'), 'lost hunt evidence: ' .. s)
                retired(has(s,'believed') or has(s,'took the crescent as'), 'unattributed training inference: ' .. s)
            elseif id == 95 then
                retired(has(s,'stump') and has(s,'earth'), 'lost discovered mound: ' .. s)
                check(not has(s,'Morbent') and not has(s,'journal buried') and not has(s,'book buried'), 'early mound revealed later identity/contents: ' .. s)
            elseif id == 55 then
                retired(has(s,"Morbent's Bane") and has(s,'Sven'), 'lost means or personal stake: ' .. s)
                check(not has(s,'Dark Riders were defeated') and not has(s,'Dark Riders were dead'), 'revenge stage completed unrelated threat: ' .. s)
            elseif id == 1058 then
                retired(has(s,"Jin'Zil") and (has(s,'concoction') or has(s,'brew')) and has(s,'elves'), 'lost giver/brew: ' .. s)
                check(not has(s,'elves died') and not has(s,'poisoned the elves'), 'ingredient hand-in invented administration: ' .. s)
            elseif id == 2973 then
                retired(has(s,'Korrin') and has(s,'wings'), 'lost gift purpose/material: ' .. s)
                check(not has(s,'cloak was finished') and not has(s,'delivered to Korrin'), 'gathered wings invented a delivered cloak: ' .. s)
            elseif id == 2974 then
                retired(has(s,'horns') and has(s,'promised'), 'lost bounty or prospective report: ' .. s)
                check(not has(s,'Belgrom received') and not has(s,'reported to Belgrom'), 'horn stage acquired later report: ' .. s)
            elseif id == 921 then
                if brief and compact then
                    retired(has(s,'Nordrassil') and has(s,'Hyjal') and has(s,'Elune') and has(s,'Well of Eternity'),
                        'compact moonwell scene lost the cost of Hyjal or sacred waters: ' .. s)
                else
                    retired(has(s,'Nordrassil') and has(s,'Archimonde') and has(s,'moonwell'), 'local errand lost its taught history: ' .. s)
                end
                check(not has(s,'Corithras received') and not has(s,'reached Darnassus'), 'first phial acquired a later delivery: ' .. s)
            elseif id == 5241 then
                retired(has(s,'rabbits and berry jam') and has(s,'Carlin'), 'specific remembered story lost: ' .. s)
                check(not has(s,'Carlin told the story') and not has(s,'Pamela was reunited'), 'request became a retelling/reunion: ' .. s)
            end
        end end end
    end end end
    q.why, q.after, q.highlight = whys, afters, highlights
end
-- The repeated title cannot establish which stage happened.
local exact = A.Lore.QuestStory('A Grim Discovery',2974)
for _, q in pairs({A.Lore.QuestStory('A Grim Discovery') or false,A.Lore.QuestStory('A Grim Discovery',2976) or false}) do
    check(q ~= exact, 'title/next ID acquired exact horns stage')
    local text = q and table.concat(q.after or {},' ') or ''
    check(not has(text,'Krueg accepted the Grimtotem horns'), 'shared title leaked earlier stage')
end
print('StoryCraftSources: ' .. checks .. ' checks passed')
