-- Run from the client root: lua5.1 Interface/AddOns/CompanionJournal/tests/PlannedTeller.lua [print]
-- The planned telling (Settings > Testing > Storyteller: Planned, 2026-11-09): a companion's
-- evening across two zones, with a death and a late finish, told in the order it happened,
-- in paragraphs by sense (pass 2, 2026-11-09): a death and a great figure each stand in their
-- own paragraph with their feeling and nothing else, no paragraph passes sixty words, the
-- furniture of the evening (a rare beast, a campfire) is left out beside them, two deeds share
-- a sentence only when one giver or one chain asked for both, and the hour opens a paragraph
-- only on a death or after a long gap. With the switch unset the chapter is the current
-- storyteller's, word for word.
local root = "Interface/AddOns/CompanionJournal/"
local assertions = 0
local function check(value, message) assertions = assertions + 1; assert(value, message) end
local show = arg and arg[1] == "print"

function time(t) if type(t) == "table" then return os.time(t) end return 1790000000 + 40 * 86400 end
function date(fmt, t) return os.date(fmt, t) end
function CreateFrame() return setmetatable({}, {__index = function() return function() end end}) end
C_Timer = {After = function() end}
LOCALIZED_CLASS_NAMES_MALE = {WARRIOR = "Warrior", MAGE = "Mage", PRIEST = "Priest", ROGUE = "Rogue", WARLOCK = "Warlock",
    HUNTER = "Hunter", DRUID = "Druid", SHAMAN = "Shaman", PALADIN = "Paladin"}
local A = {defaults = {colors = {}}}
-- (the story packs too, so the evening's quests are told as scenes, as in game)
for _, file in ipairs({"LoreData.lua", "Lore.lua", "LoreHordeStories.lua", "LoreAllianceStories.lua", "LoreWorldStories.lua",
    "LoreClassStories.lua", "LoreForeverStories.lua", "LoreNotes.lua", "LorePlaces.lua", "LorePeopleHistory.lua", "LoreWorldConnections.lua",
    "People.lua", "Characters.lua", "Journal.lua", "JournalSelf.lua", "JournalBook.lua", "JournalTellers.lua",
    "JournalFeel.lua", "JournalTale.lua", "JournalWords.lua", "JournalSelfWords.lua", "JournalSelfTale.lua"}) do
    assert(loadfile(root .. file))("CompanionJournal", A)
end
A.db = {people = {}}
A.SelfUnderground = function() return false end

local BASE = os.time({year = 2026, month = 9, day = 1, hour = 0})
local function At(day, hour, minute) return BASE + day * 86400 + math.floor((hour or 20) * 3600) + (minute or 0) * 60 end

-- The evening: Tirisfal from nine, the Undercity at half past ten, back in Tirisfal, killed by
-- Riptear a little after eleven, Dahlia's level a minute later, Bandarion Keep at 23:37, the
-- Undercity again past midnight; Dahlia stopped at one, you played on (steps 3-4, 2026-11-09).
local me = {self = true, charKey = "alb", name = "Alberich", race = "Scourge", faction = "Horde", class = "PALADIN", startLevel = 1, journal = {}}
local dahlia = {name = "Dahlia-Noir", class = "WARLOCK", race = "Scourge", pronouns = "she", journal = {}, bond = "spouse"}
A.db.people["dahlia-noir"] = dahlia
local t0, stop = At(2, 21), At(3, 1)
me.journal[#me.journal + 1] = {k = "play", t = t0, e = stop + 1800, z = "Tirisfal Glades", pl = 12}
me.journal[#me.journal + 1] = {k = "with", d = "dahlia-noir", n = "Dahlia-Noir", t = t0, e = stop}
me.journal[#me.journal + 1] = {k = "first", d = "rarebeast", z = "Sri'skulk", sz = "Tirisfal Glades", t = At(2, 21, 20), pl = 12}
-- (step 5: Sylvanas met past midnight, after "Bethor promised the Dark Lady would hear of it")
me.journal[#me.journal + 1] = {k = "first", d = "notable", n = "Lady Sylvanas Windrunner", interaction = true, z = "Undercity", t = At(3, 0, 29), pl = 13}
local J = dahlia.journal
J[#J + 1] = {k = "group", t = t0, e = stop, z = "Tirisfal Glades", pl = 12, ol = 12}
J[#J + 1] = {k = "quest", d = "Rear Guard Patrol", qid = 356, t = At(2, 21, 45), z = "Tirisfal Glades", pl = 12, ol = 12}
J[#J + 1] = {k = "quest", d = "The Cult of the Damned", qid = 96897, t = At(2, 21, 58), z = "Tirisfal Glades", pl = 12, ol = 12}
J[#J + 1] = {k = "quest", d = "The Lich's Identity", qid = 357, t = At(2, 22, 32), z = "Undercity", pl = 12, ol = 12}
J[#J + 1] = {k = "death", d = "Riptear", w = "you", t = At(2, 23, 10), z = "Tirisfal Glades", pl = 12, ol = 12}
J[#J + 1] = {k = "level", d = "13", t = At(2, 23, 11), z = "Tirisfal Glades", pl = 12, ol = 12}
J[#J + 1] = {k = "quest", d = "Bandarion Keep", qid = 96899, t = At(2, 23, 37), z = "Tirisfal Glades", pl = 13, ol = 13}
J[#J + 1] = {k = "quest", d = "The Prodigal Lich Returns", qid = 411, t = At(3, 0, 25), z = "Undercity", pl = 13, ol = 13}
A.SelfPerson = function() return me end
local player = {name = "Alberich", race = "Scourge", faction = "Horde", class = "PALADIN", charKey = "alb"}

local PLANNED = function(k) if k == "teller" then return "planned" end end
local CURRENT = function(k) if k == "teller" then return "current" end end
local function Tell(voice, retell, variant, keep)
    A.BookVariant = variant
    A.JournalTale.keepPlan = keep
    dahlia.retell = retell
    local days = A.JournalBook(dahlia)
    local stories = A.JournalTale.Tell(dahlia, days, voice, player, false)
    A.BookVariant, A.JournalTale.keepPlan = nil, nil
    local key = days[#days].key
    for _, d in ipairs(days) do if stories[d.key] and stories[d.key].text ~= "" then key = d.key end end
    return stories[key].text
end

local ANCHOR = {"^Just after ", "^A little after ", "^Around half past ", "^Close to ", "^Past midnight", "^Back in ", "^In "}
local LEADS = {"Then ", "Then, ", "After that, ", "Later that day, ", "Later, ", "Before long, ", "Also, "}
local hourLast, differs, anchored, threads = 0, 0, 0, 0
for _, voice in ipairs({"you", "we"}) do
    for retell = 0, 7 do
        local tag = " (" .. voice .. " " .. retell .. ")"
        -- With the switch unset, or set to Current, the chapter is the current storyteller's.
        local unset = Tell(voice, retell, nil)
        local current = Tell(voice, retell, CURRENT)
        check(unset == current, "unset is the current storyteller" .. tag)
        local keep = {}
        local text = Tell(voice, retell, PLANNED, keep)
        local plain = A.JournalPlain(text)
        if show and retell == 0 then print(("[current, %s]\n%s\n\n[planned, %s]\n%s\n"):format(voice, A.JournalPlain(current), voice, plain)) end
        if text ~= current then differs = differs + 1 end
        local plan = keep[#keep]
        check(plan, "the planned chapter was planned" .. tag)
        -- Tokens are balanced, none raw.
        check(not text:find("{%a+}"), "no raw token" .. tag .. ": " .. text)
        local depth, ok = 0, true
        for c in text:gmatch("[{}]") do depth = depth + (c == "{" and 1 or -1); if depth < 0 or depth > 1 then ok = false end end
        check(ok and depth == 0, "braces balanced" .. tag .. ": " .. text)
        check(not plain:find("  ", 1, true) and not plain:find(" %."), "clean spacing" .. tag .. ": " .. plain)
        -- Lines in time order (after the opening; the hour line last).
        local lastT = 0
        for i, line in ipairs(plan.lines) do
            if line.t and not line.open and line.beat ~= "hour" then
                -- (what came within ten minutes of a death is told right after it)
                check(line.t >= lastT - 600, "line " .. i .. " in time order" .. tag .. ": " .. line.text)
                lastT = math.max(lastT, line.t)
            end
            if line.beat == "hour" then check(i == #plan.lines, "the hour line is last" .. tag); hourLast = hourLast + 1 end
        end
        -- Movements: a new paragraph after the death, and where the place changed.
        local paragraphs = {}
        for p in (text .. "\n\n"):gmatch("(.-)\n\n") do paragraphs[#paragraphs + 1] = p end
        check(#paragraphs >= 2, "more than one paragraph" .. tag .. ": " .. plain)
        local function Sentences(textOf)
            local list = {}
            for sentence in (textOf .. " "):gmatch("(.-[%.!%?])%s") do list[#list + 1] = (sentence:gsub("^%s+", "")) end
            return list
        end
        for _, p in ipairs(paragraphs) do
            local pp = A.JournalPlain(p)
            check(select(2, pp:gsub("%S+", "")) <= 60, "no paragraph over sixty words" .. tag .. ": " .. pp)
            check(#Sentences(pp) <= 5, "no paragraph over five sentences" .. tag .. ": " .. pp)
        end
        local function ParaOf(word)
            for i, p in ipairs(paragraphs) do if A.JournalPlain(p):find(word, 1, true) then return i end end
        end
        local death = ParaOf("Riptear")
        check(death and death > 1, "the death has its own paragraph after the opening" .. tag .. ": " .. plain)
        -- Furniture: beside a death and a queen, the rare beast is left out, and listed.
        local why = {}
        for _, d in ipairs(plan.dropped or {}) do why[d.why] = (why[d.why] or 0) + 1 end
        check(why.rarebeast == 1 and not ParaOf("Sri'skulk"), "the rare beast is furniture beside a death and a queen" .. tag .. ": " .. plain)
        -- The join rule: the patrol and the crystal fragments had different givers, so one of them
        -- is told, alone; no ", then" between deeds; no sentence over 24 words made by joining.
        check(not plain:find(", then ", 1, true), "no ', then' between deeds" .. tag .. ": " .. plain)
        for _, sentence in ipairs(Sentences(plain)) do
            check(not (sentence:find("Balnir", 1, true) and sentence:find("crystal", 1, true)), "two unrelated deeds never share a sentence" .. tag .. ": " .. sentence)
        end
        check((why.join or 0) >= 1, "the deed left out of a join is listed" .. tag)
        -- Nothing printed twice; a person named in full once.
        local once = {}
        for _, sentence in ipairs(Sentences(plain)) do check(not once[sentence], "no sentence twice" .. tag .. ": " .. sentence); once[sentence] = true end
        for _, name in ipairs({"Gunther Arcanus", "Bethor Iceshard"}) do
            check(select(2, plain:gsub(name, "")) <= 1, name .. " in full once" .. tag .. ": " .. plain)
        end
        -- Openers: never three sentences running on the same bare "You" / "We" / "I".
        local run, runWord = 0, nil
        for _, sentence in ipairs(Sentences((plain:gsub("\n+", " ")))) do
            local word = sentence:match("^(%a+) ")
            if (word == "You" or word == "We" or word == "I") and not sentence:find("^%a+ and ") then
                run = (word == runWord) and run + 1 or 1
                runWord = word
            else run, runWord = 0, nil end
            check(run < 3, "never three bare openers running" .. tag .. ": " .. plain)
        end
        -- 3a/3b. The death opens its movement; her level a minute later is the next line; the keep,
        -- twenty-six minutes on, opens the movement after.
        local deathAt
        for i, line in ipairs(plan.lines) do if line.beat == "death" then deathAt = i end end
        check(deathAt and (deathAt == 1 or plan.lines[deathAt - 1].para < plan.lines[deathAt].para), "the death opens its movement" .. tag .. ": " .. plain)
        local nextAt = deathAt + 1
        while plan.lines[nextAt] and (plan.lines[nextAt].beat == "rez" or plan.lines[nextAt].beat == "deathLore" or plan.lines[nextAt].beat == "felt") do nextAt = nextAt + 1 end
        local after = plan.lines[nextAt]
        check(after and after.beat == "level" and A.JournalPlain(after.text):find("Dahlia", 1, true) and after.text:find("a minute later", 1, true)
            and after.para == plan.lines[deathAt].para, "her level a minute later, right after the death" .. tag .. ": " .. plain)
        local keep23
        for _, line in ipairs(plan.lines) do
            if line.t and line.t >= At(2, 23, 30) and line.t < At(3, 0) and line.beat ~= "level" then keep23 = keep23 or line end
        end
        check(keep23 and keep23.para > plan.lines[deathAt].para, "Bandarion Keep, after the death's aftermath, opens its own movement" .. tag .. ": " .. plain)
        -- 3a. A quest's setup line is never anchored on the hour (a place, or nothing).
        for _, line in ipairs(plan.lines) do
            if line.anchor and (line.setupLine or line.isSetup) then
                check(line.anchor:find("^In ") or line.anchor:find("^Back in "), "a setup line takes no hour" .. tag .. ": " .. line.text)
            end
        end
        -- 3c. A thread's payoff (Gunther's Nether Gem) has its setup before it, and both carry the hook.
        for i, line in ipairs(plan.lines) do
            if line.setup and line.setup.kind == "thread" then
                threads = threads + 1
                local before = false
                for j = 1, i - 1 do if plan.lines[j].setupFor == line.setup.key then before = true end end
                check(before, "the thread's setup comes before its payoff" .. tag .. ": " .. line.text)
            end
        end
        -- 3d. Dahlia stopped before you, late: that is the last line.
        local closing = plan.lines[#plan.lines]
        check(closing and closing.beat == "hour" and A.JournalPlain(closing.text):find("Dahlia stopped", 1, true) and closing.text == plan.companionStop,
            "the companion stopping closes the chapter" .. tag .. ": " .. plain)
        check(not plain:find("before you stopped", 1, true) and not plain:find("before we stopped", 1, true), "no second closing hour" .. tag .. ": " .. plain)
        -- (each paragraph that tells her level by a pronoun names her; your own level needs no name)
        for _, line in ipairs(plan.lines) do
            local opener = A.JournalPlain(line.text):match("^(%a+) ")
            if line.beat == "level" and (opener == "She" or opener == "He" or opener == "They") then
                local named = false
                for _, other in ipairs(plan.lines) do if other.para == line.para and A.JournalPlain(other.text):find("Dahlia", 1, true) then named = true end end
                check(named, "a movement with her level names her" .. tag)
            end
        end
        -- Air round a peak. A paragraph of one sentence is the opening, a death, a peak or the
        -- close; the queen's paragraph holds the meeting and its feeling; the death's holds no
        -- errand, no rest, and no level but hers "a minute later".
        local byPara = {}
        for _, line in ipairs(plan.lines) do
            byPara[line.para] = byPara[line.para] or {}
            table.insert(byPara[line.para], line)
        end
        local figures = 0
        for j, list in ipairs(byPara) do
            local peak, figure, died = false, false, false
            for _, line in ipairs(list) do
                if line.peak or line.beat == "death" then peak = true end
                if line.peak == "figure" or line.peak == "city" then figure = true end
                if line.beat == "death" then died = true end
            end
            local pp = A.JournalPlain(paragraphs[j])
            if #Sentences(pp) == 1 then check(j == 1 or j == #byPara or peak, "one sentence alone only as opening, peak or close" .. tag .. ": " .. plain) end
            if figure then
                figures = figures + 1
                for _, line in ipairs(list) do
                    check(line.peak or line.beat == "felt", "a great figure's paragraph holds nothing else" .. tag .. ": " .. pp)
                end
            end
            if died then
                for _, line in ipairs(list) do
                    check(line.beat ~= "quest" and line.beat ~= "questKey" and line.beat ~= "questFold" and line.beat ~= "rest" and line.beat ~= "day",
                        "no errand or rest in a death's paragraph" .. tag .. ": " .. pp)
                    if line.beat == "level" then check(line.text:find(" later%.$"), "no level in a death's paragraph but hers right after" .. tag .. ": " .. pp) end
                end
            end
        end
        check(figures == 1, "the queen has a paragraph of her own" .. tag .. ": " .. plain)
        -- The hour opens a paragraph only on a death or after a long gap, never twice running
        -- (a death apart).
        local clockBefore = false
        for j = 2, #byPara do
            local first = byPara[j][1]
            local clock = first.anchor and not first.anchor:find("^In ") and not first.anchor:find("^Back in ")
            if clock and first.beat ~= "death" then check(not clockBefore, "never two paragraphs running open on the hour" .. tag .. ": " .. plain) end
            clockBefore = clock and true or false
        end
        -- Each later movement opens on a time or a place; no stale connective after it.
        for i = 2, #paragraphs do
            local p = A.JournalPlain(paragraphs[i])
            local hit = false
            for _, pattern in ipairs(ANCHOR) do if p:find(pattern) then hit = true end end
            if hit then anchored = anchored + 1 end
            local after = p:match("^[^,]+, (.*)$") or p
            for _, lead in ipairs(LEADS) do
                check(after:sub(1, #lead):lower() ~= lead:lower(), "no '" .. lead .. "' after an anchor" .. tag .. ": " .. p)
            end
        end
        -- Every line the plan kept is told (what it left out is in plan.dropped, with the reason).
        local feltCount = 0
        for _, line in ipairs(plan.lines) do if line.beat == "felt" then feltCount = feltCount + 1 end end
        check(#plan.lines - feltCount == plan.count, "every planned line is told" .. tag)
        for _, d in ipairs(plan.dropped or {}) do check(d.why and d.text and d.text ~= "", "a line left out is listed with its reason" .. tag) end
        if voice == "we" then check(not plain:find("%f[%a][Yy]ou%f[%A]"), "the diary never says you" .. tag .. ": " .. plain) end
    end
end
check(differs > 0, "the planned telling differs from the current one")
check(anchored > 0, "a later movement opens on a time or a place")
check(hourLast > 0, "a late night is told, last, in some telling")
check(threads > 0, "a thread's payoff is set up in some telling")

-- Step 5. Felt lines (JournalFeel.lua): earned by a setup the chapter told, rare, placed right
-- after their moment; a Forsaken before Sylvanas gets the identity line, another race the
-- stage's own; a level-50 hero gets nothing meant for a fledgling.
local F = A.JournalFeel
local fledglingLines = {}
local function Collect(t)
    for k, v in pairs(t) do
        if k == "fledgling" then for _, voiceList in pairs(v) do for _, l in ipairs(voiceList) do fledglingLines[l] = true end end
        elseif type(v) == "table" then Collect(v) end
    end
end
Collect(F)
local function FeltRun(race, level)
    player.race = race
    local saved = {}
    if level then for i, e in ipairs(J) do saved[i] = {e.pl, e.ol}; e.pl, e.ol = level, level end end
    if level then for _, e in ipairs(me.journal) do e.pl = level end end
    local results = {}
    for _, voice in ipairs({"you", "we"}) do
        for retell = 0, 7 do
            local keep = {}
            local text = Tell(voice, retell, PLANNED, keep)
            results[#results + 1] = {voice = voice, retell = retell, text = text, plan = keep[#keep]}
        end
    end
    if level then for i, e in ipairs(J) do e.pl, e.ol = saved[i][1], saved[i][2] end; for _, e in ipairs(me.journal) do e.pl = 12 end end
    player.race = "Scourge"
    return results
end
local function Felts(plan)
    local list = {}
    for i, line in ipairs(plan.lines) do if line.beat == "felt" then list[#list + 1] = {i = i, line = line} end end
    return list
end
local identitySeen, genericSeen, feltSeen = 0, 0, 0
for _, case in ipairs({{race = "Scourge"}, {race = "Orc"}, {race = "Scourge", level = 50}}) do
    for _, r in ipairs(FeltRun(case.race, case.level)) do
        local tag = " (" .. case.race .. (case.level and (" " .. case.level) or "") .. ", " .. r.voice .. " " .. r.retell .. ")"
        local plan, felts = r.plan, Felts(r.plan)
        local plain = A.JournalPlain(r.text)
        check(not r.text:find("{%a+}"), "no raw token with felt lines" .. tag .. ": " .. r.text)
        check(#felts <= 2, "two felt lines a chapter at most" .. tag)
        local paras = {}
        for k, fl in ipairs(felts) do
            feltSeen = feltSeen + 1
            check(fl.i < #plan.lines, "a felt line is never the last" .. tag .. ": " .. plain)
            check(not paras[fl.line.para], "one felt line a movement" .. tag .. ": " .. plain)
            check(not paras[fl.line.para - 1] and not paras[fl.line.para + 1], "never felt lines in two paragraphs running" .. tag .. ": " .. plain)
            paras[fl.line.para] = true
            check(fl.i > 1 and plan.lines[fl.i - 1].beat ~= "felt", "never two felt lines in a row" .. tag .. ": " .. plain)
            check(plan.lines[fl.i - 1].setup ~= nil, "a felt line follows the line it answers" .. tag .. ": " .. fl.line.text)
            check(plain:find(A.JournalPlain(fl.line.text), 1, true), "the felt line is in the text" .. tag)
            if case.level == 50 then
                for l in pairs(fledglingLines) do
                    local head = l:gsub("{%a+}", ""):sub(1, 18)
                    check(not A.JournalPlain(fl.line.text):find(head, 1, true), "no fledgling line for a level-50 hero" .. tag .. ": " .. fl.line.text)
                end
            end
            if fl.line.felt == "figureNamed" then
                if case.race == "Scourge" and not case.level then
                    check(fl.line.identity, "a Forsaken before Sylvanas: the identity line" .. tag .. ": " .. fl.line.text)
                    identitySeen = identitySeen + 1
                elseif case.race == "Orc" then
                    check(not fl.line.identity, "an orc before Sylvanas: the stage's own line" .. tag .. ": " .. fl.line.text)
                    genericSeen = genericSeen + 1
                end
            end
        end
        -- (never the same felt line twice in a book: one chapter here, so never twice in it)
        local seen = {}
        for _, fl in ipairs(felts) do check(not seen[fl.line.text], "a felt line once" .. tag); seen[fl.line.text] = true end
        check(#plan.lines - #felts == plan.count, "every planned line is told" .. tag)
    end
end
check(identitySeen > 0, "the Forsaken identity line before Sylvanas is told in some telling")
check(genericSeen > 0, "a non-Forsaken gets the stage's own figure line in some telling")
A.db.people["dahlia-noir"] = nil

-- Round 2 (2026-11-09). A second book, three days in the Barrens with Grosh: the friend dies and
-- then you do, for the first time in your life; the next day you die again and a notice with a
-- colon in its title is handed in after it; the third day your journal says you raised someone
-- and no death was recorded, and Tarok is along. The rules: a first death never takes the
-- "died again" feeling; no quest title with a colon or quote marks, no "saw X through", no
-- turn-in ahead of the death before it, no title list as the last sentence; no verdict as the
-- last line; a raise only with its death; the others never open a chapter; two deaths running
-- are not both "got the better of"; an hour never opens a quest's paragraph.
do
    local me2 = {self = true, charKey = "nah", name = "Nahiri", race = "Tauren", faction = "Horde", class = "DRUID", startLevel = 1, journal = {}}
    local grosh = {name = "Grosh", class = "SHAMAN", race = "Orc", pronouns = "he", journal = {}}
    local tarok = {name = "Tarok", class = "WARRIOR", race = "Tauren", pronouns = "he", journal = {}}
    local player2 = {name = "Nahiri", race = "Tauren", faction = "Horde", class = "DRUID", charKey = "nah"}
    local own, G, K = me2.journal, grosh.journal, tarok.journal
    local function Both(entry, theirs)
        own[#own + 1] = entry
        local copy = {}
        for k, v in pairs(theirs or entry) do copy[k] = v end
        copy.t, copy.z, copy.pl, copy.ol = entry.t, entry.z, entry.pl, entry.pl + 1
        G[#G + 1] = copy
    end
    local Z = "The Barrens"
    -- day 10
    own[#own + 1] = {k = "play", t = At(10, 20), e = At(10, 22, 10), z = Z, pl = 11}
    own[#own + 1] = {k = "with", d = "grosh", n = "Grosh", t = At(10, 20), e = At(10, 22, 10)}
    G[#G + 1] = {k = "group", t = At(10, 20), e = At(10, 22, 10), z = Z, pl = 11, ol = 12}
    Both({k = "quest", d = "The Zhevra", ql = 12, t = At(10, 20, 20), z = Z, pl = 11})
    Both({k = "pdeath", n = "Grosh", t = At(10, 20, 40), z = Z, pl = 11}, {k = "death", w = "them"})
    Both({k = "death", w = "you", d = "Bristleback Interloper", a = true, t = At(10, 21), z = Z, pl = 11})
    Both({k = "rez", by = "Grosh", t = At(10, 21, 2), z = Z, pl = 11})
    Both({k = "mylevel", d = 12, t = At(10, 21, 30), z = Z, pl = 11})
    G[#G + 1] = {k = "level", d = "13", t = At(10, 21, 40), z = Z, pl = 12, ol = 12}
    -- day 11
    own[#own + 1] = {k = "play", t = At(11, 20), e = At(11, 21, 30), z = Z, pl = 12}
    own[#own + 1] = {k = "with", d = "grosh", n = "Grosh", t = At(11, 20), e = At(11, 21, 30)}
    G[#G + 1] = {k = "group", t = At(11, 20), e = At(11, 21, 30), z = Z, pl = 12, ol = 13}
    Both({k = "death", w = "you", d = "Bristleback Thornweaver", a = true, t = At(11, 20, 20), z = Z, pl = 12})
    Both({k = "quest", d = "Lost in Battle", ql = 16, t = At(11, 20, 50), z = Z, pl = 12})
    Both({k = "quest", d = "WANTED: Baron Longshore", ql = 16, t = At(11, 21, 10), z = Z, pl = 12})
    -- day 13
    own[#own + 1] = {k = "play", t = At(13, 20), e = At(13, 21, 30), z = Z, pl = 13}
    own[#own + 1] = {k = "with", d = "grosh", n = "Grosh", t = At(13, 20), e = At(13, 21, 30)}
    own[#own + 1] = {k = "with", d = "tarok", n = "Tarok", t = At(13, 20), e = At(13, 21, 30)}
    G[#G + 1] = {k = "group", t = At(13, 20), e = At(13, 21, 30), z = Z, pl = 13, ol = 14}
    K[#K + 1] = {k = "group", t = At(13, 20), e = At(13, 21, 30), z = Z, pl = 13, ol = 14}
    own[#own + 1] = {k = "first", d = "rezother", t = At(13, 20, 30), z = Z, pl = 13}
    Both({k = "quest", d = "Echeyakee", ql = 16, t = At(13, 21), z = Z, pl = 13})
    K[#K + 1] = {k = "quest", d = "Echeyakee", ql = 16, t = At(13, 21), z = Z, pl = 13, ol = 14}

    A.db.people = {grosh = grosh, tarok = tarok}
    local savedSelf = A.SelfPerson
    A.SelfPerson = function() return me2 end
    local PB = A.JournalTale.phrases
    local verdicts = {}
    for _, key in ipairs({"grim", "triumph"}) do
        for _, l in ipairs(PB.close[key] or {}) do if type(l) == "string" and not l:find("{", 1, true) then verdicts[#verdicts + 1] = l end end
    end
    check(#verdicts > 0, "the verdict pools are read")
    local again = {}
    local function Walk(t) for _, v in pairs(t) do if type(v) == "string" then again[#again + 1] = v elseif type(v) == "table" then Walk(v) end end end
    Walk(A.JournalFeel.deathAgain or {})
    check(#again > 0, "the died-again pool is read")
    local firstSeen = 0
    for _, voice in ipairs({"you", "we"}) do
        for retell = 0, 7 do
            local tag = " (Grosh, " .. voice .. " " .. retell .. ")"
            A.BookVariant = PLANNED
            grosh.retell = retell
            local days = A.JournalBook(grosh)
            local stories = A.JournalTale.Tell(grosh, days, voice, player2, false)
            A.BookVariant = nil
            local texts = {}
            for _, d in ipairs(days) do if stories[d.key] and stories[d.key].text ~= "" then texts[#texts + 1] = stories[d.key].text end end
            check(#texts == 3, "three chapters" .. tag)
            if show and retell == 0 then print(("[Grosh, %s]\n%s\n"):format(voice, A.JournalPlain(table.concat(texts, "\n--\n")))) end
            local better = 0
            for n, text in ipairs(texts) do
                local plain = A.JournalPlain(text)
                check(not plain:find("saw [^%.]- through"), "no quest nobody has written" .. tag .. ": " .. plain)
                check(not plain:find("WANTED", 1, true) and not plain:find('"', 1, true) and not plain:find(":", 1, true), "no title with a colon or quote marks" .. tag .. ": " .. plain)
                check(not plain:find("made one more in the party", 1, true), "the others in plain words" .. tag .. ": " .. plain)
                local last = text:match("([^%.!]*[%.!])%s*$") or text
                check(not last:find("{q:", 1, true), "a list of titles is never the last sentence" .. tag .. ": " .. plain)
                for _, v in ipairs(verdicts) do check(plain:sub(-#v) ~= v, "no verdict as the last line" .. tag .. ": " .. plain) end
                better = better + select(2, plain:gsub(" got the better of ", ""))
                if n == 1 then
                    for _, l in ipairs(again) do
                        local piece = ""
                        for part in (l:gsub("{%a+}", "|") .. "|"):gmatch("([^|]*)|") do if #part > #piece then piece = part end end
                        check(#piece < 12 or not plain:find(piece, 1, true), "a first death is not a death again" .. tag .. ": " .. plain)
                    end
                    if plain:find(voice == "we" and "It was the first time I died." or "It was the first time you died.", 1, true) then firstSeen = firstSeen + 1 end
                elseif n == 2 then
                    -- (the notice was handed in after the death: its title is not told ahead of it)
                    check(not plain:find("Longshore", 1, true), "no turn-in ahead of the death" .. tag .. ": " .. plain)
                else
                    check(not plain:find("back from death", 1, true) and not plain:find("raised", 1, true) and not plain:find(" rose", 1, true),
                        "a raise only with its death" .. tag .. ": " .. plain)
                    check(not plain:find("^Tarok"), "the others never open the chapter" .. tag .. ": " .. plain)
                end
            end
            check(better <= 1, "two deaths are not both told as the better of you" .. tag)
        end
    end
    check(firstSeen > 0, "the first death of a life takes the first-death line in some telling")
    A.SelfPerson = savedSelf

    -- Dahlia's evening again: an hour never opens a quest's paragraph (the quest stands at its
    -- hand-in, and its sentence opens on what came before: "Past midnight, Gunther gave you...").
    A.db.people = {["dahlia-noir"] = dahlia}
    for _, voice in ipairs({"you", "we"}) do
        for retell = 0, 7 do
            local keep = {}
            local text = Tell(voice, retell, PLANNED, keep)
            local plan = keep[#keep]
            local paragraphs = {}
            for p in (text .. "\n\n"):gmatch("(.-)\n\n") do paragraphs[#paragraphs + 1] = A.JournalPlain(p) end
            for i, line in ipairs(plan.lines) do
                local first = i == 1 or plan.lines[i - 1].para ~= line.para
                if first and (line.beat == "quest" or line.beat == "questKey" or line.beat == "quests") then
                    local p = paragraphs[line.para] or ""
                    for _, a in ipairs({"^Just after ", "^A little after ", "^Around half past ", "^Close to ", "^Past midnight"}) do
                        check(not p:find(a), "no hour on a quest's paragraph (" .. voice .. " " .. retell .. "): " .. p)
                    end
                end
            end
        end
    end
    A.db.people = {}
end

io.write("PASS: " .. assertions .. " planned-telling assertions\n")
