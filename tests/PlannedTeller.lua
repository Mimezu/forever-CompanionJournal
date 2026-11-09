-- Run from the client root: lua5.1 Interface/AddOns/CompanionJournal/tests/PlannedTeller.lua [print]
-- The planned telling (Settings > Testing > Storyteller: Planned, 2026-11-09): a companion's
-- evening across two zones, with a death and a late finish, told in the order it happened,
-- in movements (a new paragraph where the place changes, after the death, after a long gap),
-- each later movement opened by a time or a place. With the switch unset the chapter is the
-- current storyteller's, word for word.
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
        check(#paragraphs >= 2 and #paragraphs <= 5, "two to five movements" .. tag .. ": " .. plain)
        local function ParaOf(word)
            for i, p in ipairs(paragraphs) do if A.JournalPlain(p):find(word, 1, true) then return i end end
        end
        local death, rare = ParaOf("Riptear"), ParaOf("Sri'skulk")
        check(death and rare and rare < death, "the rare and the death in different movements, in order" .. tag .. ": " .. plain)
        -- 3a/3b. The death opens its movement; her level a minute later is the next line; the keep,
        -- twenty-six minutes on, opens the movement after.
        local deathAt
        for i, line in ipairs(plan.lines) do if line.beat == "death" then deathAt = i end end
        check(deathAt and (deathAt == 1 or plan.lines[deathAt - 1].para < plan.lines[deathAt].para), "the death opens its movement" .. tag .. ": " .. plain)
        local nextAt = deathAt + 1
        while plan.lines[nextAt] and (plan.lines[nextAt].beat == "rez" or plan.lines[nextAt].beat == "deathLore") do nextAt = nextAt + 1 end
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
        -- (each movement that holds her level names her)
        for _, line in ipairs(plan.lines) do
            if line.beat == "level" then
                local named = false
                for _, other in ipairs(plan.lines) do if other.para == line.para and A.JournalPlain(other.text):find("Dahlia", 1, true) then named = true end end
                check(named, "a movement with her level names her" .. tag)
            end
        end
        local zoneBreaks = 0
        for i = 2, #plan.lines do
            local a, b = plan.lines[i - 1], plan.lines[i]
            if a.para ~= b.para and b.reason == "place" then zoneBreaks = zoneBreaks + 1 end
        end
        check(zoneBreaks >= 1, "a movement opens where the place changed" .. tag .. ": " .. plain)
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
        -- Never drops a quest or the hour line: every line of the current telling's facts is kept.
        local feltCount = 0
        for _, line in ipairs(plan.lines) do if line.beat == "felt" then feltCount = feltCount + 1 end end
        check(#plan.lines - feltCount == plan.count, "no line dropped by the planner" .. tag)
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
        check(#plan.lines - #felts == plan.count, "the planner drops no line" .. tag)
    end
end
check(identitySeen > 0, "the Forsaken identity line before Sylvanas is told in some telling")
check(genericSeen > 0, "a non-Forsaken gets the stage's own figure line in some telling")
A.db.people["dahlia-noir"] = nil

io.write("PASS: " .. assertions .. " planned-telling assertions\n")
