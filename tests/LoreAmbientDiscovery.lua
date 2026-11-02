-- Bounded regression: MC rune solution and BWL's captive ally are not ambient.
-- Optional argv[1] writes representative generated prose; argv[2]=='baseline'
-- records the pre-fix failures without interrupting the snapshot run.
-- Baseline argv[3] may name the preserved pre-fix Lore.lua source.
function time(t) return type(t) == 'table' and os.time(t) or 1792000000 end
function date(f,t) return os.date(f,t) end
local root = 'Interface/AddOns/CompanionJournal/'
local A = {defaults = {colors = {}}, db = {characters = {Reader = {level = 60, journal = {}}, Alt = {journal = {}}}}}
function A.Me() return 'Reader' end
for _, file in ipairs({'LoreData','Lore','LoreHordeStories','LoreAllianceStories','LoreWorldStories','LoreClassStories',
    'LoreNotes','LorePlaces','LorePeopleHistory','LoreWorldConnections','LoreDiscovery','LoreDiscoveryData',
    'JournalBook','JournalTellers','JournalTale','JournalWords','JournalSelfWords','JournalSelfTale'}) do
    local path = file == 'Lore' and arg and arg[2] == 'baseline' and arg[3] or (root .. file .. '.lua')
    assert(loadfile(path))('CompanionJournal', A)
end
local checks, failures, renders = 0, 0, 0
local baseline = arg and arg[2] == 'baseline'
local output = arg and arg[1] and assert(io.open(arg[1], 'w'))
local function Check(ok, label)
    checks = checks + 1
    if not ok then
        failures = failures + 1
        if baseline then if failures < 10 then print('BASELINE: ' .. label) end else error(label) end
    end
end
local function Snapshot(value)
    if type(value) ~= 'table' then return type(value) .. ':' .. tostring(value) end
    local keys, out = {}, {}
    for k in pairs(value) do keys[#keys + 1] = k end
    table.sort(keys, function(a,b) return tostring(a) < tostring(b) end)
    for _, k in ipairs(keys) do out[#out + 1] = Snapshot(k) .. '=' .. Snapshot(value[k]) end
    return '{' .. table.concat(out, '|') .. '}'
end
local function Safe(text, dungeon, label)
    if dungeon == 'Molten Core' then
        Check(not text:find('Waterlords knew how', 1, true) and not text:lower():find('quintessence', 1, true), label .. ': rune solution')
    else
        Check(not text:find("bound to Nefarian's will", 1, true), label .. ': captive revelation')
    end
end
local cases = {'fresh-visit','first-unrelated-boss','exact-quests','title-only-quests','alt-history','later-quests','named-encounter'}
for _, dungeon in ipairs({'Molten Core', 'Blackwing Lair'}) do
    local story = assert(A.Lore.DungeonStory(dungeon))
    local sourceBefore = Snapshot(story)
    Check(#story.why > 0 and #story.inside > 0 and #story.detail > 0, 'public setting retained: ' .. dungeon)
    for _, field in ipairs({'why','inside','detail'}) do
        for _, line in ipairs(story[field]) do Safe(line, dungeon, 'ambient source ' .. field) end
    end
    for _, scenario in ipairs(cases) do
        for _, companion in ipairs({false,true}) do for _, brief in ipairs({false,true}) do for retell = 0,15 do
            local p = {self = not companion, name = 'Reed-Review', charKey = 'Reader', race = 'Tauren', class = 'SHAMAN',
                faction = 'Horde', pronouns = 'they', bond = 'friend', startLevel = 60, journal = {}, retell = retell}
            local t = 1792000000
            local function Event(k, seconds, extra)
                local e = {k = k, t = t + seconds, z = dungeon, pl = 60, ol = 60}
                for key, value in pairs(extra or {}) do e[key] = value end
                p.journal[#p.journal + 1] = e
            end
            Event(companion and 'group' or 'play', 0, {e = t + 7200})
            local quests = dungeon == 'Molten Core' and {{6824,'Hands of the Enemy'},{7486,"A Hero's Reward"}} or {{8730,"Nefarius's Corruption"}}
            if scenario == 'exact-quests' or scenario == 'title-only-quests' then
                for i,q in ipairs(quests) do Event('quest', i, {d = q[2], qid = scenario == 'exact-quests' and q[1] or nil}) end
            end
            Event('dungeon', 20, {d = dungeon})
            if scenario ~= 'fresh-visit' then
                local boss = dungeon == 'Molten Core' and 'Lucifron' or 'Razorgore the Untamed'
                if scenario == 'named-encounter' and dungeon == 'Blackwing Lair' then boss = 'Vaelastrasz the Corrupt' end
                Event('boss', 600, {d = boss})
            end
            if scenario == 'later-quests' then
                for i,q in ipairs(quests) do Event('quest', 3600+i, {d = q[2], qid = q[1]}) end
            end
            A.db.characters.Reader = {level = 60, journal = p.journal}
            A.db.characters.Alt.journal = scenario == 'alt-history' and {{k='quest',qid=6824},{k='quest',qid=7486},{k='quest',qid=8730}} or {}
            local before, dbBefore = Snapshot(p), Snapshot(A.db)
            local days = A.JournalBook(p)
            local tale = companion and A.JournalTale.Tell(p, days, 'we', {name='Review',race='Tauren',class='SHAMAN',faction='Horde'}, brief)
                or A.SelfTale.Tell(p, days, brief, retell)
            local all = {}
            for _,day in ipairs(days) do if tale[day.key] then all[#all+1] = A.JournalPlain(tale[day.key].text) end end
            local text = table.concat(all, '\n')
            local label = dungeon .. '/' .. scenario .. '/' .. tostring(companion) .. '/' .. tostring(brief) .. '/' .. retell
            Safe(text, dungeon, label)
            Check(#text > 0, 'nonempty ' .. label)
            if dungeon == 'Blackwing Lair' and (scenario == 'fresh-visit' or scenario == 'first-unrelated-boss' or scenario == 'alt-history') then
                Check(not text:find('Vaelastrasz', 1, true), 'unrecorded ally ' .. label)
            end
            -- Highlights may compress a named fight; the full edition retains it.
            if dungeon == 'Blackwing Lair' and scenario == 'named-encounter' and not brief then
                Check(text:find('Vaelastrasz', 1, true), 'recorded encounter preserved ' .. label)
            end
            Check(Snapshot(p) == before and Snapshot(A.db) == dbBefore, 'read-only rendering ' .. label)
            renders = renders + 1
            if output and retell == 0 then output:write(label, '\n', text, '\n\n') end
        end end end
    end
    Check(Snapshot(story) == sourceBefore, 'ambient source unchanged by reads')
end
-- Revision 2: these ambient facts must remain public even when the journal has
-- unrelated victories, title-only quests, later discoveries or an informed alt.
-- Boss-result prose is deliberately tested with unrelated bosses: defeating the
-- named encounter has a different evidence boundary from merely entering it.
local nearby = {
    {'Blackfathom Deeps', 'Ghamoo-ra', 1200, 'Blackfathom Villainy', {'lighting them', 'four old braziers'}},
    {'Scarlet Monastery', 'High Inquisitor Fairbanks', 1048, 'Into The Scarlet Monastery', {'raise Commander', 'resurrect'}},
    {'Blackrock Depths', 'Lord Roccor', 4363, "The Princess's Surprise", {'for his bride', 'married to', 'unborn child'}},
    {'Dire Maul', 'Lethtendris', 7461, 'The Madness Within', {'demon bound for', 'made king whoever', 'immortality'}},
    {"Ruins of Ahn'Qiraj", 'Kurinnaxx', 8791, 'The Fall of Ossirian', {'hurt beside', 'crystal vulnerability'}},
    {'Naxxramas', "Anub'Rekhan", 9120, "The Fall of Kel'Thuzad", {'Mograine', 'Ashbringer'}},
    {'Wailing Caverns', 'Lady Anacondra', 6981, 'The Glowing Shard', {'carried a green shard'}},
    {'Gnomeregan', 'Grubbis', 2841, 'Rig Wars', {'safe near', 'combination'}, 'Gnome'},
    {'Uldaman', 'Ironaya', 2278, 'The Platinum Discs', {'earthen', 'making of the dwarves'}, 'Dwarf'},
    {'Maraudon', 'Razorlash', 7044, 'Legends of Maraudon', {'Scepter of Celebras lay', 'one beyond the purple'}},
}
local function NearbySafe(text, row, label)
    for _, forbidden in ipairs(row[5]) do
        Check(not text:lower():find(forbidden:lower(), 1, true), label .. ': ' .. forbidden)
    end
end
for _, row in ipairs(nearby) do
    local dungeon, story = row[1], assert(A.Lore.DungeonStory(row[1]))
    local storyBefore = Snapshot(story)
    for _, field in ipairs({'why','inside','detail'}) do
        for _, line in ipairs(story[field]) do NearbySafe(line, row, dungeon .. ' source ' .. field) end
    end
    if story.wings then
        for _, wing in ipairs(story.wings) do
            for _, field in ipairs({'inside','detail'}) do
                for _, line in ipairs(wing[field]) do NearbySafe(line, row, dungeon .. ' wing ' .. field) end
            end
        end
    end
    for _, lines in pairs(story.detailRace or {}) do
        for _, line in ipairs(lines) do NearbySafe(line, row, dungeon .. ' racial detail') end
    end
    for _, scenario in ipairs({'fresh-visit','first-unrelated-boss','title-only-quests','alt-history','later-quests'}) do
        for _, companion in ipairs({false,true}) do for _, brief in ipairs({false,true}) do for retell = 0,15 do
            local t = 1792000000
            local p = {self = not companion, name = 'Reed-Review', charKey = 'Reader', race = row[6] or 'Tauren', class = 'SHAMAN',
                faction = 'Horde', pronouns = 'they', bond = 'friend', startLevel = 60, journal = {}, retell = retell}
            local function Event(k, seconds, extra)
                local e = {k=k, t=t+seconds, z=dungeon, pl=60, ol=60}
                for key,value in pairs(extra or {}) do e[key]=value end
                p.journal[#p.journal+1]=e
            end
            Event(companion and 'group' or 'play', 0, {e=t+7200})
            if scenario == 'title-only-quests' then Event('quest', 1, {d=row[4]}) end
            Event('dungeon', 20, {d=dungeon})
            if scenario == 'first-unrelated-boss' then Event('boss', 600, {d=row[2]}) end
            -- Later exact quests are placed on a later day: their own supported
            -- outcomes may disclose facts, but must not rewrite the first visit.
            if scenario == 'later-quests' then Event('quest', 172800, {d=row[4],qid=row[3]}) end
            A.db.characters.Reader = {level=60,journal=p.journal}
            A.db.characters.Alt.journal = scenario == 'alt-history' and {{k='quest',qid=row[3]}} or {}
            local before, dbBefore = Snapshot(p), Snapshot(A.db)
            local days = A.JournalBook(p)
            local tale = companion and A.JournalTale.Tell(p, days, 'we', {name='Review',race='Tauren',class='SHAMAN',faction='Horde'}, brief)
                or A.SelfTale.Tell(p, days, brief, retell)
            local text = tale[days[1].key] and A.JournalPlain(tale[days[1].key].text) or ''
            local label = dungeon .. '/' .. scenario .. '/' .. tostring(companion) .. '/' .. tostring(brief) .. '/' .. retell
            NearbySafe(text, row, label)
            Check(#text > 0, 'nonempty ' .. label)
            Check(Snapshot(p) == before and Snapshot(A.db) == dbBefore, 'read-only rendering ' .. label)
            renders = renders + 1
            if output and retell == 0 then output:write(label, '\n', text, '\n\n') end
        end end end
    end
    Check(Snapshot(story) == storyBefore, 'nearby source unchanged by reads ' .. dungeon)
end
if output then output:close() end
print('LoreAmbientDiscovery: ' .. checks .. ' checks, ' .. renders .. ' renders, ' .. failures .. ' failures')
