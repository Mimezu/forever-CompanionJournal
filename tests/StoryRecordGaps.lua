-- Evidence regressions from the thirty-character story study; actual renderers.
-- Run from the client root with Lua 5.1. No frozen study data is modified.
local root = 'Interface/AddOns/CompanionJournal/'
function time(t) return type(t) == 'table' and os.time(t) or 1792000000 end
function date(f, t) return os.date(f, t) end
local A = {defaults = {colors = {}}}
for _, file in ipairs({'LoreData', 'Lore', 'LoreHordeStories', 'LoreAllianceStories', 'LoreWorldStories', 'LoreClassStories',
    'JournalBook', 'JournalTellers', 'JournalTale', 'JournalWords', 'JournalSelfWords', 'JournalSelfTale'}) do
    local path = arg and arg[1] and file == 'JournalTale' and (arg[1] .. '/' .. file .. '.lua') or (root .. file .. '.lua')
    assert(loadfile(path))('CompanionJournal', A)
end
local checks, samples = 0, {}
local function check(ok, why) checks = checks + 1; assert(ok, why) end
local BASE = os.time({year = 2026, month = 1, day = 2, hour = 18})
local function person(self)
    return {self = self, name = 'Reed-Study', charKey = 'study-regression', race = 'Tauren', class = 'SHAMAN',
        faction = 'Horde', startLevel = 1, pronouns = 'they', journal = {}}
end
local function outing(p, day, zone, level, events)
    local t = BASE + day * 86400
    p.journal[#p.journal + 1] = {k = p.self and 'play' or 'group', t = t, e = t + 8000, z = zone, pl = level, ol = level}
    for i, data in ipairs(events or {}) do
        local e = {t = t + i * 120, z = zone, pl = level, ol = level}
        for k, v in pairs(data) do e[k] = v end
        p.journal[#p.journal + 1] = e
    end
end
local function render(p, brief, retell, player, voice)
    p.retell = retell
    local days = A.JournalBook(p)
    local stories = p.self and A.SelfTale.Tell(p, days, brief, retell)
        or A.JournalTale.Tell(p, days, voice or 'we', player, brief)
    local chapters = {}
    for _, day in ipairs(days) do
        if stories[day.key] then chapters[#chapters + 1] = A.JournalPlain(stories[day.key].text) end
    end
    return chapters[#chapters] or '', table.concat(chapters, '\n\n')
end

local players = {}
for n = 1, 300 do
    local player = {name = 'Gap' .. n, race = 'Tauren', class = 'SHAMAN', faction = 'Horde'}
    local _, key = A.JournalTellers.For(player)
    players[key] = players[key] or player
end
local forbidden = {'had been away', 'weeks away', 'months away', 'After a week away',
    'since I last took up', 'since I was last out', 'before I took up',
    'apart', 'an absence', 'was gone', 'had been gone', 'did not join',
    'usually stayed away', 'last travelled together', 'last went out together',
    'first time in', 'first time out in', 'few times a week', 'most weeks', 'once a month',
    'would not be back', 'would be a long while before'}
local sample
for _, brief in ipairs({false, true}) do for retell = 0, 15 do
    local own = person(true)
    local card = person(false); card.name = 'Mira'; card.charKey = 'gap-partner'; card.bond = 'friend'
    A.SelfPerson = function(key) return key == card.charKey and card or own end
    for _, day in ipairs({0, 1, 2, 3, 4, 34, 38, 98}) do
        outing(own, day, 'The Barrens', 20, {{k='quest', qid=900100+day, d='Recorded Errand '..day}})
        outing(card, day, 'The Barrens', 20, {{k='quest', qid=900100+day, d='Recorded Errand '..day}})
        local t=BASE+day*86400
        own.journal[#own.journal+1]={k='with',d=card.charKey,n=card.name,t=t,e=t+8000,z='The Barrens'}
    end
    local last, text = render(own, brief, retell)
    for _, bad in ipairs(forbidden) do check(not text:find(bad,1,true), 'personal invented gap: '..bad..'\n'..text) end
    local _, repeatText = render(own, brief, retell)
    check(text == repeatText,'personal gap telling changed on repeat')
    check(last:find('Barrens',1,true) and last:find('Mira',1,true),'recorded location/presence lost')
    check(not text:find('{ago}',1,true),'unfilled date token')
    for _, player in pairs(players) do for _, voice in ipairs({'we','you'}) do
        local last, text = render(card, brief, retell, player, voice)
        for _, bad in ipairs(forbidden) do check(not text:find(bad,1,true),'companion invented gap: '..bad..'\n'..text) end
        local _, repeated=render(card, brief, retell, player, voice)
        check(text==repeated,'companion gap telling changed on repeat')
        check(text:find('Mira',1,true) and last:find('together',1,true) or last:find('Mira',1,true),'companion disappeared: '..last)
        check(not text:find('{gap}',1,true),'unfilled interval token')
        sample=sample or last
    end end
end end
-- The saved night elf journey reaches the quiet-chapter closer that forecasts
-- the next month's absence. The earlier dense synthetic pattern did not reach it.
local studyRoot = 'StorageInvestigation/storytelling-thirty-20261013/v2/'
local Study = dofile(studyRoot .. 'study-lib.lua')
local fixtures = dofile(studyRoot .. 'fixtures.lua')
local rows = Study.materialize(fixtures, Study.questCatalog('StorageInvestigation/journal-voice/review/corpus_vanilla_quests.txt'))
local row = rows[15]
for _, player in pairs(players) do for _, voice in ipairs({'we','you'}) do for retell=0,15 do
    local card = Study.clone(row.sharedPerson)
    A.SelfPerson = function() return row.person end
    local _, text = render(card, false, retell, player, voice)
    check(not text:find('would not be back',1,true), 'record gap became future absence: '..text)
    check(not text:find('would be a long while before',1,true), 'record gap forecast a long absence: '..text)
end end end
print('StoryRecordGaps: '..checks..' checks passed')
print('SAMPLE '..(sample or ''))
