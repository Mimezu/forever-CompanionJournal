-- Run from the client root: lua5.1 Interface/AddOns/CompanionJournal/tests/DungeonRun.lua [print]
-- The dungeon run as one unit (JournalEpisodes.DungeonRuns, 2026-11-11) and its telling in
-- the own book: synthetic runs in four dungeons (Horde and Alliance), solo and with three-
-- and five-player parties, clean, one wipe, two wipes, a ghost run out through one or two
-- zones and back, with or without a quest about the dungeon (turned in right outside, or
-- later in another city), with or without a level; a death elsewhere the same evening; a
-- two-dungeon day. The unit must find one run per visit with its attempts, wipes, party,
-- bosses in order, deaths, quests and level. The chapter must tell the run as one paragraph
-- in time order: one entry, one "back down" per wipe, the lord's kill claimed once, a turn-in
-- that never retells the kill, no death from elsewhere inside it, no meta words.
local root = "Interface/AddOns/CompanionJournal/"
local assertions = 0
local function check(value, message) assertions = assertions + 1; assert(value, message) end
local show = arg and arg[1] == "print"

function time(t) if type(t) == "table" then return os.time(t) end return 1790000000 + 100 * 86400 end
function date(fmt, t) return os.date(fmt, t) end
function CreateFrame() return setmetatable({}, {__index = function() return function() end end}) end
C_Timer = {After = function() end}
LOCALIZED_CLASS_NAMES_MALE = {WARRIOR = "Warrior", PRIEST = "Priest", SHAMAN = "Shaman", MAGE = "Mage", WARLOCK = "Warlock", HUNTER = "Hunter", ROGUE = "Rogue", PALADIN = "Paladin"}
local A = {defaults = {colors = {}}}
for _, file in ipairs({"LoreData.lua", "Lore.lua", "LoreHordeStories.lua", "LoreAllianceStories.lua", "LoreWorldStories.lua", "LoreClassStories.lua",
    "People.lua", "Characters.lua", "Journal.lua", "JournalBook.lua", "JournalEpisodes.lua", "JournalTellers.lua", "JournalTale.lua", "JournalWords.lua",
    "JournalSelfWords.lua", "JournalSelfTale.lua"}) do
    assert(loadfile(root .. file))("CompanionJournal", A)
end
local COMPANIONS = {
    {key = "bryn", name = "Bryn", class = "PRIEST", race = "Dwarf", pronouns = "she"},
    {key = "grak", name = "Grak", class = "WARRIOR", race = "Orc", pronouns = "he"},
    {key = "mira", name = "Mira", class = "MAGE", race = "Human", pronouns = "she"},
    {key = "tarok", name = "Tarok", class = "SHAMAN", race = "Tauren", pronouns = "he"},
}
A.db = {people = {}}
for _, c in ipairs(COMPANIONS) do A.db.people[c.key] = {name = c.name .. "-Forever", class = c.class, race = c.race, pronouns = c.pronouns} end
A.SelfUnderground = function(name)
    for _, word in ipairs({"Mine", "Mines", "Cave", "Caverns", "Den", "Deadmines", "Chasm"}) do if name:find("%f[%a]" .. word .. "%f[%A]") then return true end end
    return false
end
local E = A.JournalEpisodes

local DUNGEONS = {
    {name = "Ragefire Chasm", zone = "Orgrimmar", city = "Orgrimmar", faction = "Horde", race = "Scourge", class = "PALADIN", level = 16, trash = "Ragefire Trogg",
        bosses = {"Oggleflint", "Taragaman the Hungerer", "Jergosh the Invoker", "Bazzalan"}, lord = "Taragaman the Hungerer",
        quest = {d = "Slaying the Beast", qid = 5761, mark = "Thrall"}, ghost = {"Durotar", "Orgrimmar"}, later = "Thunder Bluff"},
    {name = "The Deadmines", zone = "Westfall", city = "Westfall", faction = "Alliance", race = "Human", class = "ROGUE", level = 19, trash = "Defias Miner",
        bosses = {"Rhahk'Zor", "Sneed", "Gilnid", "Mr. Smite", "Captain Greenskin", "Edwin VanCleef"}, lord = "Edwin VanCleef",
        quest = {d = "The Defias Brotherhood", qid = 166, mark = "Stoutmantle"}, ghost = {"Westfall"}, later = "Stormwind City"},
    {name = "Wailing Caverns", zone = "The Barrens", city = "The Barrens", faction = "Horde", race = "Tauren", class = "SHAMAN", level = 20, trash = "Deviate Guardian",
        bosses = {"Lady Anacondra", "Lord Cobrahn", "Lord Pythas", "Skum", "Lord Serpentis", "Verdan the Everliving", "Mutanus the Devourer"}, lord = "Mutanus the Devourer",
        quest = {d = "Leaders of the Fang", qid = 914, mark = "Fang"}, ghost = {"The Barrens"}, later = "Thunder Bluff"},
    {name = "Shadowfang Keep", zone = "Silverpine Forest", city = "Silverpine Forest", faction = "Alliance", race = "NightElf", class = "HUNTER", level = 23, trash = "Shadowfang Moonwalker",
        bosses = {"Rethilgore", "Razorclaw the Butcher", "Baron Silverlaine", "Commander Springvale", "Odo the Blindwatcher", "Fenrus the Devourer", "Wolf Master Nandos", "Archmage Arugal"},
        lord = "Archmage Arugal", quest = nil, ghost = {"Silverpine Forest"}, later = nil},
}
local BASE = os.time({year = 2026, month = 4, day = 6, hour = 0})
local function At(day, hour, minute) return BASE + day * 86400 + math.floor((hour or 20) * 3600) + (minute or 0) * 60 end
local function Sentences(text)
    local list = {}
    for s in text:gmatch("[^%.!%?]+[%.!%?]") do list[#list + 1] = (s:gsub("^%s+", "")) end
    return list
end
-- (no "book": Shadowfang Keep's lore names the Book of Ur)
local META = {"journal", "tale", "story", "song", "verse", "record", "chronicle", "legend", "bard", "chapter"}
local function CleanText(plain, text)
    local prose = A.JournalPlain((text:gsub("{q:[^}]*}", "Q")))
    local low = prose:lower()
    for _, w in ipairs(META) do check(not low:find("%f[%a]" .. w .. "%f[%A]"), "no meta word '" .. w .. "': " .. plain) end
    check(not prose:find(":", 1, true), "no colon: " .. plain)
    check(not prose:find("?", 1, true), "no question: " .. plain)
    check(not text:find("{%a+}"), "no raw token: " .. text)
end
local function Short(name) return (A.Lore.Short and A.Lore.Short(name)) or name end

-- One run: {dungeon, party (1, 3, 5), wipes (0, 1, 2), ghostZones (1 or 2), quest, later, level, elsewhere (a death before), day, hour}.
-- Returns the entries it adds to the journal and what the chapter must show.
local function BuildRun(journal, r, companionsUsed)
    local D = r.dungeon
    local t0 = At(r.day, r.hour)
    local level = D.level
    local party = r.party
    local names = {}
    for i = 1, party - 1 do names[#names + 1] = COMPANIONS[((companionsUsed + i - 1) % #COMPANIONS) + 1] end
    -- the zone before: a town, and now and then a death out there
    journal[#journal + 1] = {k = "play", t = t0, e = t0 + 900, z = D.zone, pl = level}
    journal[#journal + 1] = {k = "town", d = D.zone, t = t0 + 60, z = D.zone, pl = level}
    if r.elsewhere then journal[#journal + 1] = {k = "death", w = "you", d = r.elsewhere, a = true, t = t0 + 300, z = D.zone, pl = level} end
    local tIn = t0 + 900
    local bossAt = 1
    local attempts = r.wipes + 1
    local t = tIn
    local tEnd
    for a = 1, attempts do
        local start = t
        journal[#journal + 1] = {k = "dungeon", d = D.name, z = D.name, t = start + 30, pl = level, r = r.role}
        local killsNow
        if a < attempts then killsNow = (a == 1 and r.wipes > 0) and 1 or 0 else killsNow = #D.bosses - bossAt + 1 end
        t = start + 300
        for _ = 1, killsNow do
            journal[#journal + 1] = {k = "boss", d = D.bosses[bossAt], z = D.name, t = t, pl = level, n = party > 1 and party or nil}
            bossAt = bossAt + 1
            t = t + 480
        end
        if a < attempts then
            -- the wipe: me to the trash, the others within the minute, some of them already out
            journal[#journal + 1] = {k = "death", w = "you", d = D.trash, a = true, t = t, z = D.name, sz = D.name, pl = level}
            for i, c in ipairs(names) do
                local where = (i == 1 or #r.ghost == 0) and D.name or r.ghost[1]
                journal[#journal + 1] = {k = "pdeath", n = c.name .. "-Forever", t = t + 20 * i, z = where, pl = level}
            end
            journal[#journal + 1] = {k = "play", t = start, e = t + 60, z = D.name, pl = level}
            -- the ghost run: four minutes a zone (too long for JournalBook's own flicker fold)
            local g = t + 60
            for gi, zone in ipairs(r.ghost) do
                journal[#journal + 1] = {k = "play", t = g, e = g + 240, z = zone, pl = level}
                if gi == #r.ghost then
                    journal[#journal + 1] = {k = "town", d = zone, t = g + 30, z = zone, pl = level}
                    journal[#journal + 1] = {k = "rest", d = zone, t = g + 40, z = zone, pl = level}
                end
                g = g + 240
            end
            t = g
        else
            tEnd = t
            journal[#journal + 1] = {k = "play", t = start, e = tEnd, z = D.name, pl = level}
        end
    end
    -- out: the city, a level, the turn-in
    local tOut = tEnd
    local cityEnd = tOut + 1200
    journal[#journal + 1] = {k = "play", t = tOut, e = cityEnd, z = D.city, pl = level}
    journal[#journal + 1] = {k = "town", d = D.city, t = tOut + 10, z = D.city, pl = level}
    if r.level then journal[#journal + 1] = {k = "mylevel", d = tostring(level + 1), t = tOut + 30, z = D.city, pl = level} end
    local quest = r.quest and D.quest
    if quest and not r.later then
        journal[#journal + 1] = {k = "quest", d = quest.d, qid = quest.qid, ql = level, t = tOut + 60, z = D.city, pl = level}
    elseif quest and r.later then
        journal[#journal + 1] = {k = "play", t = cityEnd + 600, e = cityEnd + 2400, z = D.later, pl = level}
        journal[#journal + 1] = {k = "town", d = D.later, t = cityEnd + 620, z = D.later, pl = level}
        journal[#journal + 1] = {k = "quest", d = quest.d, qid = quest.qid, ql = level, t = cityEnd + 1500, z = D.later, pl = level}
    end
    for _, c in ipairs(names) do journal[#journal + 1] = {k = "with", d = c.key, n = c.name .. "-Forever", t = t0, e = cityEnd} end
    return {dungeon = D, names = names, party = party, wipes = r.wipes, quest = quest, later = r.later, level = r.level and level + 1 or nil,
        elsewhere = r.elsewhere, tIn = tIn, tOut = tOut, bosses = D.bosses}
end
local function Person(D, journal)
    return {self = true, charKey = "dr" .. D.name:gsub("%W", ""), name = "Tested", race = D.race, faction = D.faction, class = D.class,
        startLevel = D.level, journal = journal}
end
local function Tell(me, brief, retell)
    A.SelfPerson = function() return me end
    local days = A.JournalBook(me)
    local stories = A.SelfTale.Tell(me, days, brief, retell)
    local out = {}
    for _, d in ipairs(days) do
        local s = stories[d.key]
        if s and s.text ~= "" then out[#out + 1] = {plain = A.JournalPlain(s.text), text = s.text, title = tostring(s.title), day = d} end
    end
    return out, days
end
local function Paragraphs(plain)
    local list = {}
    for p in (plain .. "\n\n"):gmatch("(.-)\n\n") do if p ~= "" then list[#list + 1] = p end end
    return list
end
local KILL_WORDS = {"killed", "slew", "brought down", "cut down", "went down", "fell"}
local function ClaimsKill(sentence, name)
    if not sentence:find(name, 1, true) then return false end
    for _, w in ipairs(KILL_WORDS) do
        if sentence:find(w, 1, true) and not sentence:find("killed me", 1, true) and not sentence:find("fell to", 1, true) then return true end
    end
    return false
end

-- The unit --------------------------------------------------------------------------------
local function CheckUnit(expect, days, label)
    local runs = E.DungeonRuns(days[1].scenes)
    check(#runs == 1, "one run per visit (" .. label .. "): " .. #runs)
    local run = runs[1]
    check(run.dungeon == expect.dungeon.name, "the dungeon (" .. label .. ")")
    check(#run.attempts == expect.wipes + 1, "attempts = wipes + 1 (" .. label .. "): " .. #run.attempts)
    check(run.wipes == expect.wipes, "wipes counted (" .. label .. "): " .. run.wipes)
    for a = 1, expect.wipes do check(run.attempts[a].wipe, "attempt " .. a .. " is a wipe (" .. label .. ")") end
    check(not run.attempts[#run.attempts].wipe, "the last attempt is not a wipe (" .. label .. ")")
    check(#run.bosses == #expect.bosses, "every boss (" .. label .. "): " .. #run.bosses)
    for i, b in ipairs(run.bosses) do check(b.name == expect.bosses[i], "bosses in true order (" .. label .. "): " .. b.name) end
    for i = 2, #run.bosses do check(run.bosses[i].t > run.bosses[i - 1].t, "boss times rise (" .. label .. ")") end
    check(run.party.count == expect.party, "party count (" .. label .. "): " .. tostring(run.party.count))
    check(#run.party.names == expect.party - 1, "party names (" .. label .. "): " .. #run.party.names)
    check(#run.deaths == expect.wipes * expect.party, "deaths inside the run, mine and theirs (" .. label .. "): " .. #run.deaths)
    for _, d in ipairs(run.deaths) do check(d.t >= run.entered and d.t <= run.left, "a death inside the run's time (" .. label .. ")") end
    if expect.elsewhere then
        for _, d in ipairs(run.deaths) do check(d.foe ~= expect.elsewhere, "the death before the run is not inside it (" .. label .. ")") end
    end
    -- (JournalBook may drop a quiet ghost stay before the unit sees it; the attempts come from the entries either way)
    if expect.wipes > 0 then check(run.left - run.entered > (expect.tOut - expect.tIn) - 120, "the run spans the ghost run and the second try (" .. label .. ")") end
    check(run.party.roles.me == "tank" or run.party.roles.me == "damage" or run.party.roles.me == "healer" or run.party.roles.me == nil, "a role (" .. label .. ")")
    if expect.quest then
        check(#run.quests >= 1 and run.quests[1].quest.title == expect.quest.d, "the quest about the dungeon (" .. label .. ")")
    else
        check(#run.quests == 0, "no quest claimed (" .. label .. ")")
    end
    if expect.level then check(run.level and run.level.level == expect.level, "the level with the run (" .. label .. ")")
    else check(run.level == nil, "no level claimed (" .. label .. ")") end
    return run
end

-- The telling -----------------------------------------------------------------------------
local function RunParagraph(plain, D)
    local paras = Paragraphs(plain)
    local found, n = nil, 0
    for _, p in ipairs(paras) do
        if p:find(D.name:gsub("^The ", ""), 1, true) and (p:find("went", 1, true) or p:find("made", 1, true) or p:find("tried", 1, true)
            or p:find("set out", 1, true) or p:find("going", 1, true)) then
            found = found or p
            n = n + 1
        end
    end
    return found, n, paras
end
local function CheckChapter(c, expect, label)
    local D = expect.dungeon
    local plain = c.plain
    CleanText(plain, c.text)
    local para, n, paras = RunParagraph(plain, D)
    check(para, "a paragraph tells the run (" .. label .. "):\n" .. plain)
    local place = D.name:gsub("^The ", "")
    -- one entry sentence: the place with a going-in verb, once in the chapter
    local entries, entrySentence = 0, nil
    for _, s in ipairs(Sentences(plain)) do
        if s:find(place, 1, true) and (s:find("into", 1, true) or s:find("made for", 1, true) or s:find("set out for", 1, true)
            or s:find("tried", 1, true) or s:find("went in", 1, true) or s:find("back in", 1, true) or s:find("held little danger", 1, true)
            or s:find("run through", 1, true) or s:find("time in", 1, true) or s:find("time there", 1, true)) then
            entries = entries + 1
            entrySentence = entrySentence or s
        end
    end
    check(entries == 1, "one entry into the place (" .. label .. "): " .. entries .. "\n" .. plain)
    -- one "back down" per wipe
    local backs = 0
    for _ in plain:lower():gmatch("back down") do backs = backs + 1 end
    for _ in plain:lower():gmatch("back in%f[^%a]") do backs = backs + 1 end -- (not "a way back into Gnomeregan")
    -- (two wipes told as one passage take one "back down")
    check(backs == expect.wipes or (expect.wipes >= 2 and backs >= 1 and backs <= expect.wipes),
        "one 'back down' per wipe (" .. label .. "): " .. backs .. " for " .. expect.wipes .. "\n" .. plain)
    -- the run is one paragraph: every kill claim is in it
    for _, p in ipairs(paras) do
        if p ~= para then
            for _, s in ipairs(Sentences(p)) do
                for _, b in ipairs(expect.bosses) do
                    check(not ClaimsKill(s, Short(b)), "a kill told outside the run's paragraph (" .. label .. "): " .. s .. "\n" .. plain)
                end
            end
        end
    end
    -- the lord's kill is claimed once
    local lordClaims = 0
    for _, s in ipairs(Sentences(para)) do if ClaimsKill(s, Short(D.lord)) then lordClaims = lordClaims + 1 end end
    check(lordClaims <= 1, "the lord's kill told once (" .. label .. "):\n" .. para)
    check(para:find(Short(D.lord), 1, true), "the lord named in the run (" .. label .. "):\n" .. para)
    -- the kills come after the wipe, the wipe after the entry
    if expect.wipes > 0 then
        local entryAt = entrySentence and para:find(entrySentence, 1, true)
        local wipeAt = para:lower():find(D.trash:lower(), 1, true) -- (a generic foe may be told in lower case, "a Ragefire trogg")
        local backAt = para:lower():find("back down", 1, true) or para:lower():find("back in%f[^%a]")
        local killAt = backAt and para:find(Short(D.lord), backAt, true) -- (the lord may be named in the entry's lore clause)
        check(entryAt and wipeAt and backAt and killAt and entryAt < wipeAt and wipeAt < backAt and backAt < killAt,
            "entry, wipe, back down, kills, in that order (" .. label .. "):\n" .. para)
    end
    -- no roll call and summary: never four names in one "went down in turn" line
    check(not para:find("went down in turn", 1, true) or #expect.bosses <= 3, "no roll call of four (" .. label .. "):\n" .. para)
    -- the lord's consequence and the turn-in never both in full
    if expect.quest then
        check(plain:find(expect.quest.mark, 1, true), "the turn-in told (" .. label .. "):\n" .. plain)
        if not expect.later then
            check(para:find(expect.quest.mark, 1, true), "the turn-in is in the run's paragraph (" .. label .. "):\n" .. plain)
        end
        -- (only when the quest is about the lord: the Fang leaders' quest is not about Mutanus)
        local lore = A.Lore.Boss(D.lord)
        local aboutLord = E.Names(E.QuestText({title = expect.quest.d, qid = expect.quest.qid}), D.lord)
        if lore and lore.after and aboutLord then
            check(not plain:find(A.JournalPlain(lore.after), 1, true), "the lord's after line gives way to the turn-in (" .. label .. "):\n" .. plain)
        end
    end
    if expect.level and expect.quest and not expect.later then
        check(para:find("level " .. expect.level, 1, true) or para:find("Level " .. expect.level, 1, true), "the level is in the run's paragraph (" .. label .. "):\n" .. plain)
    end
    -- a death elsewhere stays outside the run's paragraph
    if expect.elsewhere then check(not para:find(expect.elsewhere, 1, true), "a death elsewhere is not in the run (" .. label .. "):\n" .. plain) end
    -- the first dungeon of my life, with going in, not as a last word after the deaths
    if plain:find("first dungeon", 1, true) or plain:find("my first dungeon", 1, true) then
        check(not plain:find("It cost me a death", 1, true), "the first dungeon is said with going in (" .. label .. "):\n" .. plain)
    end
    -- the paragraph reads as one story: at least five sentences for a run with kills and a quest
    if expect.quest and not expect.later then check(#Sentences(para) >= 5, "a run with a quest fills a paragraph (" .. label .. "):\n" .. para) end
    return para
end

-- Scenarios: the real shape (Ragefire, five, one wipe through two zones, quest and level), then random ones.
local scenarios = {
    {dungeon = DUNGEONS[1], party = 5, wipes = 1, ghost = {"Durotar", "Orgrimmar"}, quest = true, later = false, level = true, role = "tank", day = 0, hour = 22},
    {dungeon = DUNGEONS[2], party = 3, wipes = 0, ghost = {}, quest = true, later = true, level = false, role = "damage", day = 0, hour = 20},
    {dungeon = DUNGEONS[3], party = 5, wipes = 2, ghost = {"The Barrens"}, quest = true, later = false, level = true, role = "healer", day = 0, hour = 19},
    {dungeon = DUNGEONS[4], party = 1, wipes = 0, ghost = {}, quest = false, later = false, level = true, role = nil, day = 0, hour = 21},
}
math.randomseed(20261111)
local function Pick(list) return list[math.random(#list)] end
for i = 1, 20 do
    local D = Pick(DUNGEONS)
    local party = Pick({1, 3, 5})
    local wipes = Pick({0, 0, 1, 1, 2})
    local ghost = wipes > 0 and (Pick({1, 2}) == 1 and {D.ghost[1]} or D.ghost) or {}
    scenarios[#scenarios + 1] = {dungeon = D, party = party, wipes = wipes, ghost = ghost, quest = D.quest ~= nil and Pick({true, true, false}),
        later = Pick({false, false, true}), level = Pick({true, false}), role = party > 1 and Pick({"tank", "damage", "healer"}) or nil,
        elsewhere = Pick({false, false, true}) and D.trash:gsub("^%a+", "Wandering") or nil, day = i, hour = Pick({19, 20, 21, 22})}
end
local told = 0
for si, sc in ipairs(scenarios) do
    local journal = {}
    local expect = BuildRun(journal, sc, si)
    local me = Person(sc.dungeon, journal)
    local label = ("#%d %s party %d wipes %d ghost %d quest %s level %s"):format(si, sc.dungeon.name, sc.party, sc.wipes, #sc.ghost,
        tostring(sc.quest and (sc.later and "later" or "yes")), tostring(sc.level))
    local _, days = Tell(me, false, 0)
    CheckUnit(expect, days, label)
    for retell = 0, 3 do
        for _, brief in ipairs({false, true}) do
            local chapters = Tell(me, brief, retell)
            check(#chapters >= 1, "a chapter (" .. label .. ")")
            local para = CheckChapter(chapters[1], expect, label .. (brief and " Highlights" or "") .. " retell " .. retell)
            told = told + 1
            if show and retell == 0 and not brief then print("[" .. label .. "] " .. chapters[1].title .. "\n" .. chapters[1].plain .. "\n") end
        end
    end
end

-- A two-dungeon day: Ragefire, then the Wailing Caverns an hour later, with company.
do
    local journal = {}
    local first = BuildRun(journal, {dungeon = DUNGEONS[1], party = 5, wipes = 1, ghost = {"Durotar"}, quest = true, later = false, level = false, role = "tank", day = 30, hour = 19}, 0)
    local second = BuildRun(journal, {dungeon = DUNGEONS[3], party = 5, wipes = 0, ghost = {}, quest = false, later = false, level = true, role = "tank", day = 30, hour = 21.5}, 0)
    local me = Person(DUNGEONS[1], journal)
    me.charKey = "drtwo"
    A.SelfPerson = function() return me end
    local days = A.JournalBook(me)
    local runs = E.DungeonRuns(days[1].scenes)
    check(#runs == 2, "two runs on a two-dungeon day: " .. #runs)
    check(runs[1].dungeon == "Ragefire Chasm" and runs[2].dungeon == "Wailing Caverns", "the runs in order")
    check(#runs[1].quests == 1 and #runs[2].quests == 0, "each run's own quests")
    check(runs[1].level == nil and runs[2].level and runs[2].level.level == 21, "each run's own level: " .. tostring(runs[1].level and runs[1].level.level) .. " / " .. tostring(runs[2].level and runs[2].level.level))
    for retell = 0, 3 do
        local chapters = Tell(me, false, retell)
        local plain = chapters[1].plain
        CleanText(plain, chapters[1].text)
        local p1 = RunParagraph(plain, DUNGEONS[1])
        local p2 = RunParagraph(plain, DUNGEONS[3])
        check(p1 and p2 and p1 ~= p2, "two paragraphs, one a run (retell " .. retell .. "):\n" .. plain)
        for _, b in ipairs(DUNGEONS[3].bosses) do check(not p1:find(Short(b), 1, true), "no Wailing Caverns boss in the Ragefire paragraph:\n" .. p1) end
        for _, b in ipairs(DUNGEONS[1].bosses) do check(not p2:find(Short(b), 1, true), "no Ragefire boss in the Wailing Caverns paragraph:\n" .. p2) end
        check(plain:find(p1, 1, true) < plain:find(p2, 1, true), "the runs in time order")
        if show and retell == 0 then print("[two dungeons] " .. chapters[1].title .. "\n" .. plain .. "\n") end
    end
end

print("PASS: " .. assertions .. " dungeon-run assertions over " .. told .. " tellings")
