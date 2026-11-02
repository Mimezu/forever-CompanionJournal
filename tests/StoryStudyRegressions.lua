-- Evidence regressions from the thirty-character story study; actual renderers.
-- Run from the client root with Lua 5.1. No frozen study data is modified.
local root = 'Interface/AddOns/CompanionJournal/'
function time(t) return type(t) == 'table' and os.time(t) or 1792000000 end
function date(f, t) return os.date(f, t) end
local A = {defaults = {colors = {}}}
for _, file in ipairs({'LoreData', 'Lore', 'LoreHordeStories', 'LoreAllianceStories', 'LoreWorldStories', 'LoreClassStories',
    'JournalBook', 'JournalTellers', 'JournalTale', 'JournalWords', 'JournalSelfWords', 'JournalSelfTale'}) do
    assert(loadfile(root .. file .. '.lua'))('CompanionJournal', A)
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
local firstPhrases = {'never been inside a dungeon', 'first time I had gone into such a place',
    'my first time in such a place', 'first dungeon I had ever', 'first dungeon you had ever', 'first dungeon we had ever'}
local function noFalseFirst(text)
    for _, phrase in ipairs(firstPhrases) do check(not text:find(phrase, 1, true), 'false first dungeon: ' .. text) end
end
local players = {}
for n = 1, 300 do
    local player = {name = 'Study' .. n, race = 'Tauren', class = 'SHAMAN', faction = 'Horde'}
    local _, key = A.JournalTellers.For(player)
    players[key] = players[key] or player
end

-- An empty earlier entry counts in both personal editions; the late raid is
-- not the character's first dungeon. Retells exercise every first-ever phrase.
local firstSeen = false
for _, brief in ipairs({false, true}) do for retell = 0, 23 do
    local p = person(true)
    outing(p, 0, 'Mulgore', 1)
    outing(p, 7, 'Wailing Caverns', 20, {{k = 'dungeon', d = 'Wailing Caverns'}})
    outing(p, 14, 'Molten Core', 60, {{k = 'dungeon', d = 'Molten Core'}, {k = 'boss', d = 'Lucifron'}})
    local text = render(p, brief, retell)
    noFalseFirst(text)
    check(text:find('Lucifron', 1, true), 'later recorded boss lost: ' .. text)
    check(#p.journal == 6, 'render changed recorded entries')
    samples.dungeon = samples.dungeon or text
    -- A sparse entry rules out first-ever, but must not consume the setting
    -- introduction on the first later visit with a recorded encounter.
    local returning = person(true)
    outing(returning, 0, 'Mulgore', 1)
    outing(returning, 7, 'Wailing Caverns', 20, {{k = 'dungeon', d = 'Wailing Caverns'}})
    outing(returning, 14, 'Wailing Caverns', 20, {{k = 'dungeon', d = 'Wailing Caverns'}, {k = 'boss', d = 'Lady Anacondra'}})
    local returnText = render(returning, brief, retell)
    noFalseFirst(returnText)
    check(returnText:find('Naralex', 1, true), 'first substantive visit lost setting context: ' .. returnText)
    check(returnText:find('Lady Anacondra', 1, true), 'return encounter disappeared: ' .. returnText)
    samples.sparseReturn = samples.sparseReturn or returnText
    local first = person(true)
    outing(first, 0, 'Mulgore', 1)
    outing(first, 7, 'Wailing Caverns', 20, {{k = 'dungeon', d = 'Wailing Caverns'}, {k = 'boss', d = 'Lady Anacondra'}})
    local genuine = render(first, brief, retell)
    for _, phrase in ipairs(firstPhrases) do firstSeen = firstSeen or genuine:find(phrase, 1, true) ~= nil end
    local wipe = person(true)
    outing(wipe, 0, 'Molten Core', 60, {{k = 'dungeon', d = 'Molten Core'}, {k = 'wipe', d = 'Shazzrah'}})
    local defeat = render(wipe, brief, retell)
    check(not defeat:find('all of me', 1, true), 'singular wipe grammar: ' .. defeat)
    check(defeat:find('Shazzrah', 1, true), 'wipe lost')
    check(not defeat:find('raised', 1, true), 'wipe invented resurrection')
    samples.wipe = samples.wipe or defeat
end end
check(firstSeen, 'genuine first-dungeon narration was disabled')

for voiceKey, player in pairs(players) do for _, voice in ipairs({'we', 'you'}) do for _, brief in ipairs({false, true}) do for retell = 0, 11 do
    -- The companion history itself is sufficient to disprove first-ever,
    -- even when the personal journal is sparse and starts at level one.
    local own = person(true)
    outing(own, 0, 'Mulgore', 1)
    A.SelfPerson = function() return own end
    local p = person(false)
    outing(p, 0, 'Mulgore', 1)
    outing(p, 7, 'Wailing Caverns', 20, {{k = 'dungeon', d = 'Wailing Caverns'}})
    outing(p, 14, 'Molten Core', 60, {{k = 'dungeon', d = 'Molten Core'}, {k = 'boss', d = 'Lucifron'}})
    noFalseFirst(render(p, brief, retell, player, voice))

    -- A different prior dungeon less than ten minutes before the current
    -- entry still disproves first-ever; it is not a timestamp tolerance.
    own.journal[#own.journal + 1] = {k = 'dungeon', d = 'Blackrock Depths', z = 'Blackrock Depths', t = BASE + 14 * 86400}
    local short = person(false)
    outing(short, 14, 'Molten Core', 60, {{k = 'dungeon', d = 'Molten Core'}, {k = 'boss', d = 'Lucifron'}})
    noFalseFirst(render(short, brief, retell, player, voice))
    A.SelfPerson = nil

    -- Usual weekly cadence cannot overwrite a concrete six/19/22-day gap;
    -- even seven-day repetition is not evidence of an appointment.
    for _, gap in ipairs({6, 7, 19, 22}) do
        local returning = person(false); returning.origin = 'together'
        for _, day in ipairs({0, 9, 18, 27, 36, 36 + gap}) do outing(returning, day, 'The Barrens', 20) end
        local text = render(returning, brief, retell, player, voice)
        if gap ~= 7 then
            for _, bad in ipairs({'A week passed', 'A week on', 'A week having passed', 'A week turned', 'After a week apart'}) do
                check(not text:find(bad, 1, true), 'wrong elapsed interval: ' .. text)
            end
        end
        check(not text:find('appointment', 1, true) and not text:find('on schedule', 1, true), 'invented appointment: ' .. text)
        if gap == 22 and voiceKey == 'bard' then samples.interval = samples.interval or text end
    end

    -- The question mark in the selected quest title previously consumed the
    -- only sentence boundary when its completion announcement was replaced.
    local quests = person(false); quests.origin = 'together'
    outing(quests, 0, 'Winterspring', 58, {{k = 'quest', d = 'Are We There, Yeti?', qid = 977},
        {k = 'quest', d = 'Winterfall Activity', qid = 8464}, {k = 'quest', d = 'Threat of the Winterfall', qid = 5082}, {k = 'quest', d = 'Uncatalogued Snow Errand', qid = 999999}})
    local text = render(quests, brief, retell, player, voice)
    check(not text:find('quests [A-Z]'), 'missing terminator after quest count: ' .. text)
    check(not text:find('%.%.'), 'duplicate terminator: ' .. text)
    if brief then check(not text:find('Are We There, Yeti?', 1, true), 'Highlights should use the supported yeti outcome without a redundant title') end
    if not brief and text:find('completed four quests', 1, true) then
        samples.punctuation = samples.punctuation or text
        check(text:find('completed four quests[.,]'), 'quest count lacks sentence punctuation: ' .. text)
    end
end end end end
check(samples.punctuation, 'punctuation replacement path was not exercised')

-- Original quest 5386 calls Shadowprey a troll village and its fishers trolls.
local coastal = person(true)
outing(coastal, 0, 'Desolace', 37, {{k = 'town', d = 'Shadowprey Village'}})
local coastalSeen = false
for retell = 0, 31 do
    local text = render(coastal, false, retell)
    check(not text:find('tauren village', 1, true), 'incorrect Shadowprey identity: ' .. text)
    coastalSeen = coastalSeen or text:find('troll fishing village', 1, true) ~= nil
end
check(coastalSeen, 'Shadowprey descriptor was not exercised')
print('StoryStudyRegressions: ' .. checks .. ' checks passed')
for _, key in ipairs({'dungeon', 'sparseReturn', 'wipe', 'interval', 'punctuation'}) do print('\n' .. key .. '\n' .. (samples[key] or '')) end
