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
    "JournalFeel.lua", "JournalTale.lua", "JournalWords.lua", "JournalSelfWords.lua", "JournalSelfStyle.lua", "JournalSelfPlan.lua", "JournalSelfTale.lua"}) do
    assert(loadfile(root .. file))("CompanionJournal", A)
end
A.db = {people = {}}
A.SelfUnderground = function() return false end
check(A.SelfPlan and A.SelfPlan.Apply, "the planner is loaded")
-- (what the planner chose: the kept lines of the last planned chapter, with their tags)
local Sel = A.SelfPlan.Sel
check(Sel and Sel.Finish, "the selection is open to the tests")
local lastSel, lastSeq
local Finish = Sel.Finish
Sel.Finish = function(sel, seq) Finish(sel, seq); lastSel, lastSeq = sel, seq end

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
    -- (a paladin's long evening: errands, the chain that ends before Sylvanas, a death in
    -- Venomweb Vale, and the class chain that goes back there and ends on the spell)
    if kind == "spine" then
        local function Quest(hour, minute, qid, title, zone) Add({k = "quest", d = title, qid = qid, t = At(1, hour, minute), z = zone or Z, ql = 12}) end
        Add({k = "play", t = At(1, 21, 8), e = At(1, 22, 23), z = Z})
        Add({k = "first", d = "rarebeast", z = "Sri'skulk", sz = Z, t = At(1, 21, 39)})
        Quest(21, 58, 356, "Rear Guard Patrol")
        Add({k = "mylevel", d = "12", t = At(1, 22, 4), z = Z}); level = 12
        Quest(22, 11, 96897, "The Cult of the Damned"); Quest(22, 11, 96898, "Remnants of War")
        Quest(22, 13, 371, "At War With The Scarlet Crusade"); Quest(22, 14, 369, "A New Plague")
        Add({k = "rest", d = "Gallows' End Tavern", t = At(1, 22, 14), z = Z})
        Quest(22, 15, 492, "A New Plague"); Quest(22, 17, 99142, "Tomb Weed")
        Add({k = "play", t = At(1, 22, 23), e = At(1, 22, 53), z = U})
        Quest(22, 27, 357, "The Lich's Identity", U)
        Add({k = "play", t = At(1, 22, 53), e = At(1, 24, 18), z = Z})
        Quest(23, 4, 366, "Return the Book"); Quest(23, 6, 409, "Proving Allegiance")
        Add({k = "death", d = "Riptear", w = "you", t = At(1, 23, 10), z = Z, sz = "Venomweb Vale"})
        Quest(23, 18, 372, "At War With The Scarlet Crusade"); Quest(23, 20, 99156, "Rear Guard Patrol")
        Add({k = "mylevel", d = "13", t = At(1, 23, 29), z = Z}); level = 13
        Quest(23, 37, 96899, "Bandarion Keep"); Quest(23, 39, 96896, "A Righteous Cause")
        Quest(23, 58, 99152, "As Above, So Below"); Quest(23, 59, 99153, "The One That Got Away")
        Quest(24, 0, 91316, "Making Repairs"); Quest(24, 0, 91317, "The Tarnished"); Quest(24, 10, 408, "The Family Crypt")
        Add({k = "play", t = At(1, 24, 18), e = At(1, 24, 43), z = U})
        Quest(24, 21, 98545, "Leonid's Letter", U); Quest(24, 21, 94427, "A Lesson in Divinity", U)
        Quest(24, 22, 94434, "A Lesson in Divinity", U); Quest(24, 23, 95328, "Whispering Horror Residue", U)
        Quest(24, 25, 411, "The Prodigal Lich Returns", U)
        Add({k = "first", d = "notable", n = "Lady Sylvanas Windrunner", interaction = true, z = U, t = At(1, 24, 29)})
        Quest(24, 29, 95803, "A Token of Good Faith", U); Quest(24, 32, 97891, "Prompt Potion Runner", U)
        Add({k = "mylevel", d = "14", t = At(1, 24, 32), z = U}); level = 14
        Add({k = "play", t = At(1, 24, 43), e = At(1, 25, 22), z = Z})
        Quest(24, 50, 94435, "A Lesson in Divinity"); Quest(24, 51, 94436, "A Lesson in Divinity")
        Quest(24, 56, 94438, "A Lesson in Divinity"); Quest(25, 8, 94440, "A Lesson in Divinity")
        Quest(25, 8, 94441, "A Lesson in Divinity")
        return {name = "Alberich", charKey = "selfplan", self = true, race = "Scourge", class = "PALADIN", faction = "Horde",
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
    -- (the budget holds on a plain evening too: 340 words at most, never longer than the current telling)
    local function Count(text) local n = 0; for _ in text:gmatch("%S+") do n = n + 1 end; return n end
    check(Count(planned) <= 340, "the evening keeps to 340 words" .. tag)
    check(Count(planned) <= math.max(Count(current), 40), "the planned evening is no longer than the current one, "
        .. Count(planned) .. " of " .. Count(current) .. tag)
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

-- What is told (the selection): the setup of a peak stays and stands before it, nothing is
-- told twice, the chapter keeps to its budget, the feelings keep to their rules, and every
-- kept line says what it is (peak, setup, side, close).
local function Words(text) local n = 0; for _ in text:gmatch("%S+") do n = n + 1 end; return n end
local function Under(pool, line)
    if type(pool) ~= "table" then return false end
    for _, v in pairs(pool) do if v == line or Under(v, line) then return true end end
    return false
end
local paid = 0
for retell = 0, 7 do
    local tag = " (spine, retell " .. retell .. "): "
    local current = Tell("spine", retell, CURRENT)
    lastSel, lastSeq = nil, nil
    local planned = Tell("spine", retell, PLANNED, true)
    local sel, seq = lastSel, lastSeq
    check(sel and seq, "the long evening is planned" .. tag)
    check(planned == Tell("spine", retell, PLANNED), "strict and guarded give the same chapter" .. tag)
    Clean(planned, tag)
    -- (the budget: 340 words at most, never over the day's own cap, never longer than Current)
    check(sel.cap <= 340, "the cap is 340 at most" .. tag)
    check(Words(planned) <= sel.cap, "the chapter keeps to its budget, " .. Words(planned) .. " of " .. sel.cap .. tag .. planned)
    check(Words(planned) <= Words(current), "the planned chapter is no longer than the current one" .. tag)
    local kept = {}
    for _, entry in ipairs(seq) do if not entry.dropped then kept[#kept + 1] = entry end end
    -- (nothing is told twice: no kept line, no sentence)
    local seen = {}
    for _, entry in ipairs(kept) do
        check(not seen[entry.text], "a line is told twice" .. tag .. entry.text)
        seen[entry.text] = true
    end
    local sentences = {}
    for sentence in planned:gsub("\n", " "):gmatch("[^%.!]+[%.!]") do
        sentence = sentence:gsub("^%s+", "")
        check(not sentences[sentence], "a sentence is told twice" .. tag .. sentence)
        sentences[sentence] = true
    end
    -- (every setup of a peak is told, and stands before the peak)
    local peakAt, setups = {}, 0
    for i, entry in ipairs(kept) do if entry.peak and not peakAt[entry.peak] then peakAt[entry.peak] = i end end
    check(peakAt.figure, "the meeting with the queen is marked as a peak" .. tag .. planned)
    check(peakAt.spell, "the spell taught is marked as a peak" .. tag .. planned)
    -- (round 2: a setup that must be told is told. A second step of a chain whose other steps
    -- are told as scenes is never folded to its bare act, so it may be left out.)
    for _, u in ipairs(sel.units) do
        if u.setup and u.must then check(u.mode, "a setup was left out" .. tag .. tostring(u.plain)) end
        if u.setup and u.mode then setups = setups + 1 end
    end
    check(setups >= 4, "the peaks have their setups" .. tag)
    local head, lady, falgan
    for i, entry in ipairs(kept) do
        local plain = A.JournalPlain(entry.text)
        -- (round 2: the first step of a chain that ends in a peak is told as its full scene)
        if entry.setup and (plain:find("commander's head", 1, true) or plain:find("head of their commander", 1, true)) then head = head or i end
        if entry.setup and plain:find("Dark Lady", 1, true) then lady = lady or i end
        if entry.setup and plain:find("Falgan", 1, true) then falgan = falgan or i end
    end
    check(head and head < peakAt.figure, "the commander's head is taken before it is brought to the queen" .. tag .. planned)
    check(lady and lady < peakAt.figure, "the queen is promised before she is met" .. tag .. planned)
    check(falgan and falgan < peakAt.spell, "the class chain is told before its spell" .. tag .. planned)
    -- (the tags: a death is marked, one close at most and it comes last, an errand is no setup)
    local closes, sides, payoffs = 0, 0, 0
    for i, entry in ipairs(kept) do
        -- (round 2: a death with something said on it is a peak; a death with nothing said on it
        -- is no scene of its own and joins the paragraph it falls in)
        local said = kept[i + 1] and kept[i + 1].glue and not kept[i + 1].close
        if entry.kind == "death" and not entry.felt and said then check(entry.peak, "a death stands unmarked" .. tag .. entry.text) end
        if entry.close then closes = closes + 1; check(i == #kept, "the close is not the last line" .. tag .. planned) end
        if entry.side then sides = sides + 1; check(not entry.setup and not entry.peak, "an errand is marked as spine" .. tag .. entry.text) end
        if entry.peak == "payoff" then
            payoffs = payoffs + 1
            check(A.JournalPlain(entry.text):find("Riptear", 1, true), "the return names what killed there" .. tag .. entry.text)
        end
        -- (the join rule: no unrelated acts welded with ", then")
        if entry.work then check(not entry.text:find(", then ", 1, true), "acts are welded" .. tag .. entry.text) end
    end
    check(closes <= 1, "one close at most" .. tag)
    -- (round 2: two bare errands at most and none straight after a feeling, the steps of a
    -- chain say which chain they are of, a piece of work nobody wrote a line for is not told,
    -- and the day's own level stands in the close or at a plain seam, never last)
    local errands, chained = 0, 0
    for i, entry in ipairs(kept) do
        local before = kept[i - 1]
        if entry.errand then
            errands = errands + 1
            check(not (before and before.felt), "an errand stands after a feeling" .. tag .. planned)
        end
        if entry.chain then chained = chained + 1 end
        if entry.level and not entry.close and not entry.mate then
            check(i < #kept, "the level ends the chapter" .. tag .. planned)
            check(not (before and (before.felt or before.peak)), "the level stands after a peak or a feeling" .. tag .. planned)
        end
    end
    check(errands <= 2, "two bare errands at most" .. tag .. planned)
    check(chained >= 2, "the steps of a chain are marked" .. tag)
    check(not planned:find(" saw .- through%."), "work without a line of its own is told" .. tag .. planned)
    check(kept[#kept].close, "the chapter ends on its close" .. tag .. planned)
    check(planned:find("level 14", 1, true), "the last level is told" .. tag .. planned)
    check(sides <= 4, "four errands at most" .. tag .. planned)
    check(payoffs <= 1, "one return at most" .. tag)
    paid = paid + payoffs
    -- (furniture goes from a chapter with two peaks or more)
    check(not planned:find("Sri'skulk", 1, true), "the rare beast is left out beside two peaks" .. tag .. planned)
    -- (the feelings: three at most, never two in a row, never the last line, one at most on
    -- what the character is)
    local F = A.JournalFeel or {}
    local felt, own = 0, 0
    for i, entry in ipairs(kept) do
        if entry.felt then
            felt = felt + 1
            check(not (kept[i - 1] and kept[i - 1].felt), "two feelings in a row" .. tag .. planned)
            check(i < #kept, "a feeling ends the chapter" .. tag .. planned)
            local pool = F[entry.felt]
            if entry.line and type(pool) == "table" and (Under(pool.Scourge, entry.line) or Under(pool.PALADIN, entry.line)) then own = own + 1 end
        end
    end
    check(felt <= 3, "three feelings at most" .. tag .. planned)
    check(own <= 1, "one line at most on what the character is" .. tag .. planned)
    if show and retell < 2 then io.write("--- current", tag, "\n", current, "\n--- planned (" .. Words(planned) .. " of " .. sel.cap .. ")\n", planned, "\n\n") end
end
check(paid > 0, "the return to the place of a death is told in some telling")

-- (without the planner's file the switch does nothing: a client that has not restarted yet)
local keep = A.SelfPlan
A.SelfPlan = nil
check(Tell("evening", 0, PLANNED) == Tell("evening", 0, CURRENT), "no planner, no change")
A.SelfPlan = keep

io.write("PASS: " .. assertions .. " own planned-telling assertions (" .. differs .. " of 8 tellings differ)\n")
