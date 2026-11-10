-- Run from the client root: lua5.1 Interface/AddOns/CompanionJournal/tests/SelfPlan.lua [print]
-- The planned telling of your own book (Settings > Testing > Storyteller: Planned, 2026-11-09,
-- JournalSelfPlan.lua). A Forsaken warlock's evening in Tirisfal Glades in two sittings, with
-- a death, a level and a meeting with Sylvanas. With the switch unset, or set to Current, the
-- chapter is the current storyteller's, word for word. A dungeon day and a thin day keep
-- their shape whatever the switch says.
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
for _, file in ipairs({"LoreData.lua", "Lore.lua", "LoreHordeStories.lua", "LoreAllianceStories.lua", "LoreWorldStories.lua",
    "LoreClassStories.lua", "LoreForeverStories.lua", "LoreNotes.lua", "LorePlaces.lua", "LorePeopleHistory.lua", "LoreWorldConnections.lua",
    "People.lua", "Characters.lua", "Journal.lua", "JournalSelf.lua", "JournalBook.lua", "JournalTellers.lua",
    "JournalFeel.lua", "JournalTale.lua", "JournalWords.lua", "JournalSelfWords.lua", "JournalSelfPlan.lua", "JournalSelfTale.lua"}) do
    assert(loadfile(root .. file))("CompanionJournal", A)
end
A.db = {people = {}}
A.SelfUnderground = function() return false end
check(A.SelfPlan and A.SelfPlan.Apply, "the planner is loaded")

local BASE = os.time({year = 2026, month = 9, day = 1, hour = 0})
local function At(day, hour, minute) return BASE + day * 86400 + math.floor((hour or 20) * 3600) + (minute or 0) * 60 end
local Z, U = "Tirisfal Glades", "Undercity"

-- (kind: "evening" the full day, "dungeon" the same with a dungeon run, "thin" two hand-ins)
local function Person(kind, retell)
    local j, level = {}, 11
    local function Add(e) e.pl, e.ol = e.pl or level, e.ol or level; j[#j + 1] = e end
    -- (an earlier day, so the evening is not the book's first and an earlier death is on record)
    Add({k = "play", t = At(0, 20), e = At(0, 22), z = Z})
    Add({k = "quest", d = "Rude Awakening", t = At(0, 20, 20), z = Z, ql = 1})
    Add({k = "quest", d = "The Mindless Ones", t = At(0, 20, 50), z = Z, ql = 2})
    Add({k = "death", d = "Vampiric Duskbat", w = "you", t = At(0, 21, 10), z = Z})
    Add({k = "quest", d = "Rattling the Rattlecages", t = At(0, 21, 40), z = Z, ql = 3})
    if kind == "thin" then
        Add({k = "play", t = At(1, 20), e = At(1, 21), z = Z})
        Add({k = "quest", d = "Rear Guard Patrol", qid = 356, t = At(1, 20, 20), z = Z, ql = 11})
        Add({k = "quest", d = "A Righteous Cause", qid = 96896, t = At(1, 20, 40), z = Z, ql = 12})
        return {name = "Alberich", charKey = "selfplan", self = true, race = "Scourge", class = "WARLOCK", faction = "Horde",
            startLevel = 1, retell = retell, journal = j}
    end
    -- (a short first sitting in the afternoon)
    Add({k = "play", t = At(1, 14, 20), e = At(1, 14, 50), z = U})
    Add({k = "town", d = U, t = At(1, 14, 21), z = U})
    Add({k = "death", d = "Dark Enforcer", w = "you", t = At(1, 14, 33), z = Z})
    Add({k = "rest", d = "Ruins of Lordaeron", t = At(1, 14, 40), z = U})
    -- (the evening)
    Add({k = "play", t = At(1, 21, 30), e = At(1, 25, 5), z = Z})
    Add({k = "gather", d = "mining", c = 16, t = At(1, 21, 32), e = At(1, 21, 50), z = Z})
    Add({k = "first", d = "rarebeast", z = "Sri'skulk", sz = Z, t = At(1, 21, 39)})
    Add({k = "quest", d = "Rear Guard Patrol", qid = 356, t = At(1, 21, 58), z = Z, ql = 11})
    Add({k = "mylevel", d = "12", t = At(1, 22, 4), z = Z}); level = 12
    Add({k = "quest", d = "Bandarion Keep", qid = 96899, t = At(1, 22, 20), z = Z, ql = 12})
    if kind == "dungeon" then
        Add({k = "dungeon", d = "Ragefire Chasm", z = "Ragefire Chasm", t = At(1, 22, 30)})
        Add({k = "boss", d = "Taragaman the Hungerer", z = "Ragefire Chasm", t = At(1, 23, 5)})
    end
    Add({k = "quest", d = "A Righteous Cause", qid = 96896, t = At(1, 23, 39), z = Z, ql = 12})
    Add({k = "death", d = "Riptear", w = "you", t = At(1, 23, 50), z = Z})
    Add({k = "mylevel", d = "13", t = At(1, 23, 55), z = Z}); level = 13
    Add({k = "quest", d = "Leonid's Letter", qid = 98545, t = At(1, 24, 21), z = U, ql = 12})
    Add({k = "first", d = "notable", n = "Lady Sylvanas Windrunner", interaction = true, z = U, t = At(1, 24, 29)})
    Add({k = "quest", d = "The Prodigal Lich Returns", qid = 411, t = At(1, 24, 25), z = U, ql = 12})
    Add({k = "sleep", d = "Ruins of Lordaeron", t = At(1, 25, 4), z = U})
    return {name = "Alberich", charKey = "selfplan", self = true, race = "Scourge", class = "WARLOCK", faction = "Horde",
        startLevel = 1, retell = retell, journal = j}
end

local PLANNED = function(k) if k == "teller" then return "planned" end end
local CURRENT = function(k) if k == "teller" then return "current" end end
local function Tell(kind, retell, variant, strict)
    local p = Person(kind, retell)
    local before = #p.journal
    A.BookVariant, A.SelfTale.PlanStrict = variant, strict or nil
    local days = A.JournalBook(p)
    local tales = A.SelfTale.Tell(p, days, false, retell)
    A.BookVariant, A.SelfTale.PlanStrict = nil, nil
    check(#p.journal == before, "telling changed the record")
    local last = days[#days]
    return last and tales[last.key] and A.JournalPlain(tales[last.key].text) or "", #days
end

local META = {"journal", "tale", "story", "stories", "song", "songs", "verse", "record", "chronicle", "legend", "bard"}
local function Clean(text, tag)
    check(not text:find("{%a"), "a token is left" .. tag .. text)
    check(not text:find(":", 1, true), "a colon" .. tag .. text)
    check(not text:find("?", 1, true), "a question" .. tag .. text)
    check(not text:find("  ", 1, true), "a double space" .. tag .. text)
    local low = " " .. text:lower():gsub("[^%a']", " ") .. " "
    for _, word in ipairs(META) do check(not low:find(" " .. word .. " ", 1, true), "meta word " .. word .. tag .. text) end
    for para in (text .. "\n\n"):gmatch("(.-)\n\n") do
        check(para:find("^%u") or para:find("^%d"), "a movement opens on a capital" .. tag .. para)
        check(para:find("[%.!]$"), "a movement ends on a full stop" .. tag .. para)
    end
end

local differs, shorter = 0, 0
for retell = 0, 7 do
    local tag = " (retell " .. retell .. "): "
    local unset = Tell("evening", retell, nil)
    local current = Tell("evening", retell, CURRENT)
    check(unset == current, "Current is the telling with the switch unset" .. tag)
    -- (strict: an error in the planner is raised here, not swallowed)
    local planned = Tell("evening", retell, PLANNED, true)
    check(planned ~= "", "the planned evening is told" .. tag)
    check(planned == Tell("evening", retell, PLANNED, true), "the planned telling is the same every time" .. tag)
    check(planned == Tell("evening", retell, PLANNED), "strict and guarded give the same chapter" .. tag)
    Clean(planned, tag)
    if planned ~= current then differs = differs + 1 end
    if #planned < #current then shorter = shorter + 1 end
    -- (what happened stays told: the deaths by name, the queen, the last level)
    for _, must in ipairs({"Riptear", "Sylvanas", "13"}) do check(planned:find(must, 1, true), must .. " is told" .. tag .. planned) end
    -- (a feeling never ends the chapter and never stands twice in a row: at most three in all)
    local F = A.JournalFeel or {}
    local felt = 0
    local function Walk(t) for _, v in pairs(t) do if type(v) == "table" then Walk(v) elseif type(v) == "string" then
        local line = A.JournalPlain(v):gsub("{I}", "I"):gsub("{my}", "my"):gsub("{me}", "me")
        if not line:find("{", 1, true) and planned:find(line, 1, true) then felt = felt + 1 end
    end end end
    Walk(F)
    check(felt <= 3, "three felt lines at most" .. tag .. planned)
    -- (a dungeon day and a thin day keep the current shape)
    check(Tell("dungeon", retell, PLANNED, true) == Tell("dungeon", retell, CURRENT), "a dungeon day is left as it was" .. tag)
    check(Tell("thin", retell, PLANNED, true) == Tell("thin", retell, CURRENT), "a thin day is left as it was" .. tag)
    if show and retell < 2 then io.write("--- current", tag, "\n", current, "\n--- planned\n", planned, "\n\n") end
end
check(differs > 0, "the planned telling differs from the current one in some telling")

-- (without the planner's file the switch does nothing: a client that has not restarted yet)
local keep = A.SelfPlan
A.SelfPlan = nil
check(Tell("evening", 0, PLANNED) == Tell("evening", 0, CURRENT), "no planner, no change")
A.SelfPlan = keep

io.write("PASS: " .. assertions .. " own planned-telling assertions (" .. differs .. " of 8 tellings differ)\n")
