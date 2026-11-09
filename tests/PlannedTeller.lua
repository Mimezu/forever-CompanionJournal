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
    "JournalTale.lua", "JournalWords.lua", "JournalSelfWords.lua", "JournalSelfTale.lua"}) do
    assert(loadfile(root .. file))("CompanionJournal", A)
end
A.db = {people = {}}
A.SelfUnderground = function() return false end

local BASE = os.time({year = 2026, month = 9, day = 1, hour = 0})
local function At(day, hour, minute) return BASE + day * 86400 + math.floor((hour or 20) * 3600) + (minute or 0) * 60 end

-- The evening: Tirisfal from nine, the Undercity at half past ten, back in Tirisfal, killed by
-- Riptear a little after eleven, the Undercity again past midnight, stopped at one.
local me = {self = true, charKey = "alb", name = "Alberich", race = "Scourge", faction = "Horde", class = "PALADIN", startLevel = 1, journal = {}}
local dahlia = {name = "Dahlia-Noir", class = "WARLOCK", race = "Scourge", pronouns = "she", journal = {}, bond = "spouse"}
A.db.people["dahlia-noir"] = dahlia
local t0, stop = At(2, 21), At(3, 1)
me.journal[#me.journal + 1] = {k = "play", t = t0, e = stop, z = "Tirisfal Glades", pl = 12}
me.journal[#me.journal + 1] = {k = "with", d = "dahlia-noir", n = "Dahlia-Noir", t = t0, e = stop}
me.journal[#me.journal + 1] = {k = "first", d = "rarebeast", z = "Sri'skulk", sz = "Tirisfal Glades", t = At(2, 21, 20), pl = 12}
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
local hourLast, differs, anchored = 0, 0, 0
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
                check(line.t >= lastT, "line " .. i .. " in time order" .. tag .. ": " .. line.text)
                lastT = line.t
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
        for i, line in ipairs(plan.lines) do
            -- (the first timed line after the death's own lines opens a new paragraph)
            if line.beat == "death" then
                for j = i + 1, #plan.lines do
                    local nextLine = plan.lines[j]
                    if nextLine.t and nextLine.beat ~= "rez" and nextLine.beat ~= "deathLore" and nextLine.beat ~= "consequence" then
                        check(nextLine.para > line.para or nextLine.merged, "a new movement after the death" .. tag .. ": " .. nextLine.text)
                        break
                    end
                end
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
        check(#plan.lines == plan.count, "no line dropped by the planner" .. tag)
        if voice == "we" then check(not plain:find("%f[%a][Yy]ou%f[%A]"), "the diary never says you" .. tag .. ": " .. plain) end
    end
end
check(differs > 0, "the planned telling differs from the current one")
check(anchored > 0, "a later movement opens on a time or a place")
check(hourLast > 0, "a late night is told, last, in some telling")
A.db.people["dahlia-noir"] = nil

io.write("PASS: " .. assertions .. " planned-telling assertions\n")
