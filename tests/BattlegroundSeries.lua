-- Run from the client root: lua5.1 Interface/AddOns/CompanionJournal/tests/BattlegroundSeries.lua [print]
-- Six battlegrounds in one evening (loss, loss, win, win, loss, win: the first
-- battleground ever and the first win), with a companion in two of them, then
-- an evening of Arathi Basin and a third evening of three wins in a row. The
-- own book tells each evening as one passage with rhythm, in every retell
-- (0 to 7), in Everything and in Highlights; the companion book tells the
-- matches together in both voices.
-- (Written in phase 1 of the battlegrounds lane; it fails until phase 2 lands
-- the recording fields and the passage. See
-- StorageInvestigation/cj-overnight-20261105/battlegrounds/PLAN.txt.)
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
for _, file in ipairs({"LoreData.lua", "Lore.lua", "People.lua", "Characters.lua", "Journal.lua", "JournalBook.lua", "JournalTellers.lua",
    "JournalTale.lua", "JournalWords.lua", "JournalSelfWords.lua", "JournalSelfTale.lua"}) do
    assert(loadfile(root .. file))("CompanionJournal", A)
end
A.db = {people = {}}
A.SelfUnderground = function() return false end

local BASE = os.time({year = 2026, month = 9, day = 1, hour = 0})
local function At(day, hour, minute) return BASE + day * 86400 + math.floor((hour or 20) * 3600) + (minute or 0) * 60 end
local function Count(text, word) local n = 0 for _ in text:gmatch(word) do n = n + 1 end return n end
local function Sentences(text) local n = 0 for _ in (text .. " "):gmatch("[%.!]%s") do n = n + 1 end return n end
local function Has(text, ...) for _, needle in ipairs({...}) do if text:find(needle, 1, true) then return true end end return false end

-- A match: a stretch in the battleground and the bg entry the recorder fills at
-- the end screen (r result, dur seconds, kb/hk/dt/hon my score line, m the
-- battleground's own stats, top = most killing blows on my side, c listed
-- people on my side not already in my party).
local function Match(journal, t, zone, minutes, pl, fields)
    journal[#journal + 1] = {k = "play", t = t, e = t + minutes * 60, z = zone, pl = pl}
    if fields.first then journal[#journal + 1] = {k = "first", d = "battleground", z = zone, t = t + 5} end
    local entry = {k = "bg", d = zone, z = zone, t = t + 5, dur = minutes * 60}
    for key, value in pairs(fields) do if key ~= "first" then entry[key] = value end end
    journal[#journal + 1] = entry
    return t + minutes * 60
end
local function Between(journal, t, minutes, pl)
    journal[#journal + 1] = {k = "play", t = t, e = t + minutes * 60, z = "Orgrimmar", pl = pl}
    return t + minutes * 60
end

-- The six-match evening, Warsong Gulch, and the companion for the third and fourth.
local me = {self = true, charKey = "alb", name = "Alberich", race = "Scourge", faction = "Horde", class = "PALADIN", startLevel = 1, journal = {}}
local dahlia = {name = "Dahlia-Noir", class = "WARLOCK", race = "Scourge", pronouns = "she", journal = {}, bond = "spouse"}
A.db.people["dahlia-noir"] = dahlia
local j = me.journal
local t = At(0, 19, 40)
t = Between(j, t, 4, 29)
t = Match(j, t, "Warsong Gulch", 18, 29, {first = true, r = "lost", kb = 1, hk = 6, dt = 4, hon = 90})
t = Between(j, t, 3, 29)
t = Match(j, t, "Warsong Gulch", 12, 29, {r = "lost", kb = 0, hk = 3, dt = 3, hon = 40})
t = Between(j, t, 4, 29)
local third = t
t = Match(j, t, "Warsong Gulch", 31, 29, {r = "won", kb = 4, hk = 12, dt = 2, hon = 210, m = {fc = 2}})
t = Between(j, t, 4, 29)
t = Match(j, t, "Warsong Gulch", 9, 29, {r = "won", kb = 6, hk = 9, dt = 0, hon = 160, top = true})
local fourthEnd = t
j[#j + 1] = {k = "with", d = "dahlia-noir", n = "Dahlia-Noir", t = third, e = fourthEnd}
dahlia.journal[#dahlia.journal + 1] = {k = "group", t = third, e = fourthEnd, z = "Warsong Gulch", pl = 29, ol = 30}
t = Between(j, t, 3, 29)
t = Match(j, t, "Warsong Gulch", 41, 29, {r = "lost", kb = 3, hk = 14, dt = 5, hon = 120})
t = Between(j, t, 5, 29)
t = Match(j, t, "Warsong Gulch", 15, 29, {r = "won", kb = 2, hk = 8, dt = 1, hon = 150})
Between(j, t, 6, 29)

-- Six days later, Arathi Basin twice: a win with two bases taken, then a loss.
t = At(6, 20, 10)
t = Between(j, t, 5, 31)
t = Match(j, t, "Arathi Basin", 22, 31, {r = "won", kb = 3, hk = 11, dt = 2, hon = 180, m = {ba = 2, bd = 1}})
t = Between(j, t, 4, 31)
t = Match(j, t, "Arathi Basin", 26, 31, {r = "lost", kb = 1, hk = 7, dt = 4, hon = 70})
Between(j, t, 5, 31)

-- The next evening, Warsong Gulch again: three wins in a row.
t = At(7, 20, 30)
t = Between(j, t, 5, 31)
t = Match(j, t, "Warsong Gulch", 14, 31, {r = "won", kb = 2, hk = 9, dt = 1, hon = 150})
t = Between(j, t, 3, 31)
t = Match(j, t, "Warsong Gulch", 17, 31, {r = "won", kb = 1, hk = 10, dt = 2, hon = 150, m = {fr = 1}})
t = Between(j, t, 3, 31)
t = Match(j, t, "Warsong Gulch", 11, 31, {r = "won", kb = 3, hk = 7, dt = 0, hon = 150})
Between(j, t, 4, 31)

A.SelfPerson = function() return me end

local function Tellings(brief)
    local all = {}
    for retell = 0, 7 do
        local days = A.JournalBook(me)
        local stories = A.SelfTale.Tell(me, days, brief, retell)
        local chapters = {}
        for _, d in ipairs(days) do
            local s = stories[d.key]
            if s and s.text ~= "" then
                chapters[#chapters + 1] = {plain = A.JournalPlain(s.text), text = s.text, title = s.title}
                if show and (retell == 0 or retell == 3) then
                    print(("[%s%s, retell %d] %s\n%s\n"):format(me.name, brief and " (Highlights)" or "", retell, tostring(s.title), A.JournalPlain(s.text)))
                end
            end
        end
        all[retell] = chapters
    end
    return all
end

-- The rules every chapter keeps.
local META = {"journal", "tale", "story", "song", "verse", "record", "chronicle", "legend", "bard", "page", "book", "chapter"}
local everything, highlights = Tellings(false), Tellings(true)
for _, edition in ipairs({everything, highlights}) do
    for retell, chapters in pairs(edition) do
        check(#chapters == 3, "three evenings, three chapters (" .. retell .. "): " .. #chapters)
        for _, c in ipairs(chapters) do
            check(not c.text:find("{%a+}"), "no raw token (" .. retell .. "): " .. c.text)
            check(not c.text:gsub("{%a:[^}]*}", ""):find(":", 1, true), "no colons: " .. c.plain)
            check(not c.plain:find("%?"), "no questions: " .. c.plain)
            for _, word in ipairs(META) do
                check(not c.plain:lower():find("%f[%a]" .. word .. "%f[%A]"), "no meta word '" .. word .. "': " .. c.plain)
            end
            check(not c.plain:find("  ", 1, true) and not c.plain:find(" %."), "clean spacing: " .. c.plain)
            check(not c.plain:find("%f[%a][Yy]ou%f[%A]"), "the diary never says you: " .. c.plain)
            -- (the old shape is gone: one line with a count and the side)
            check(not c.plain:find("times, with the Horde", 1, true) and not c.plain:find("times to fight for the Horde", 1, true),
                "no counted one-liner: " .. c.plain)
        end
    end
end

-- 1. The six-match evening, Everything: the first time with the place, the two
--    defeats, the first win named as such, the company, the marks, the long match,
--    the rhythm of a passage rather than six sentences of the same shape.
for retell, chapters in pairs(everything) do
    local one = chapters[1].plain
    check(one:find("first time", 1, true) and one:find("Warsong Gulch", 1, true), "the first battleground ever (" .. retell .. "): " .. one)
    check(Count(one, "Warsong Gulch") <= 2, "the place named once or twice, not per match: " .. one)
    check(Has(one, "Silverwing", "Warsong Outriders", "timber of Ashenvale", "two keeps", "Two keeps"), "what Warsong Gulch is, the first time: " .. one)
    check(Has(one:lower(), "six"), "six matches, counted in words: " .. one)
    check(Has(one, "Alliance"), "the defeats name the other side: " .. one)
    check(Has(one, "first I had ever won", "first battleground I had won", "the first the Horde won", "my first", "first win", "first I had won"),
        "the first win is called the first: " .. one)
    check(Count(one, "Dahlia") == 1, "Dahlia named once: " .. one)
    check(Has(one, "carried the flag", "took their flag", "flag crossed", "flag home"), "the two flags: " .. one)
    check(Count(one, "killing blows") == 1, "the most killing blows, said once: " .. one)
    check(Has(one, "forty minutes"), "the long fifth match: " .. one)
    check(Count(one, "I fought in") <= 1 and Count(one, "I went into") <= 1, "no repeated opening shape: " .. one)
    check(Count(one, "%f[%a]again%f[%A]") <= 1, "again at most once: " .. one)
    local n = Sentences(one)
    check(n >= 6 and n <= 14, "a passage, six to fourteen sentences (" .. n .. "): " .. one)
    check(Has(chapters[1].title or "", "Warsong Gulch", "Victory", "First Win", "Night", "Matches"), "a title from the evening: " .. tostring(chapters[1].title))
    -- (the first two went to the Alliance before any win: the order holds)
    local function First(text, ...)
        local at
        for _, needle in ipairs({...}) do local p = text:find(needle, 1, true); if p and (not at or p < at) then at = p end end
        return at
    end
    local firstLoss = First(one, "Alliance", "We lost", "we lost")
    local firstWin = First(one, "we won", "We won", "were ours", "was ours", "Horde won", "Horde took", "I had won", "my first")
    check(firstLoss and firstWin and firstLoss < firstWin, "the defeats come before the first win: " .. one)
end

-- 2. Highlights: shorter, still the first time, the count and the first win; no length, no blows.
for retell, chapters in pairs(highlights) do
    local one, full = chapters[1].plain, everything[retell][1].plain
    check(#one < #full, "Highlights shorter than Everything (" .. retell .. "): " .. one)
    check(one:find("Warsong Gulch", 1, true) and one:find("first time", 1, true), "Highlights keep the first time: " .. one)
    check(Has(one:lower(), "six"), "Highlights keep the count: " .. one)
    check(Has(one, "won", "ours", "victory"), "Highlights keep a win: " .. one)
    check(not one:find("forty minutes", 1, true) and not one:find("killing blows", 1, true), "Highlights drop the length and the blows: " .. one)
    check(Sentences(one) <= 5, "Highlights: five sentences at most: " .. one)
end

-- 3. Arathi Basin: two matches, a win then a loss, the bases, what the basin is (Everything only).
for retell, chapters in pairs(everything) do
    local two = chapters[2].plain
    check(two:find("Arathi Basin", 1, true) and Has(two, "twice", "two matches", "Two matches", "second"), "two matches in Arathi Basin (" .. retell .. "): " .. two)
    check(Has(two, "Arathor", "Defilers", "basin"), "what Arathi Basin is, the first time there: " .. two)
    check(Has(two, "bases", "base"), "the bases taken: " .. two)
    check(Has(two, "won", "ours") and Has(two, "Alliance", "lost"), "a win and a loss: " .. two)
    check(not two:find("first time", 1, true), "not a first time any more: " .. two)
    check(Count(two, "Arathi Basin") <= 2, "the place once or twice: " .. two)
end
for retell, chapters in pairs(highlights) do
    local two = chapters[2].plain
    check(not Has(two, "Arathor", "Defilers"), "Highlights leave the place lore out (" .. retell .. "): " .. two)
    check(two:find("Arathi Basin", 1, true), "Highlights keep the place: " .. two)
end

-- 4. Three wins in a row, back in Warsong Gulch: told as a sweep and a streak, not a first time.
for retell, chapters in pairs(everything) do
    local three = chapters[3].plain
    check(three:find("Warsong Gulch", 1, true) and Has(three:lower(), "three"), "three matches in Warsong Gulch (" .. retell .. "): " .. three)
    check(Has(three, "every one", "all three", "won all", "All three", "were ours"), "a sweep: " .. three)
    check(Has(three, "in a row"), "the streak across days: " .. three)
    check(not three:find("first time", 1, true) and not Has(three, "Silverwing", "Warsong Outriders"), "no first time, no place lore the second visit: " .. three)
    check(Count(three, "Warsong Gulch") <= 2, "the place once or twice: " .. three)
    check(Has(three, "returned our flag", "our own flag back"), "the flag returned: " .. three)
end

-- 5. The plain record keeps the results too.
do
    local days = A.JournalBook(me)
    local joined = {}
    for _, scene in ipairs(days[1].scenes) do
        for _, item in ipairs(A.JournalSceneItems(me, scene) or {}) do joined[#joined + 1] = A.JournalPlain(item.text or "") end
    end
    joined = table.concat(joined, " | ")
    local plain = A.JournalPlain(tostring(A.JournalDayHighlights(me, days[1], "you") or ""))
    if show then print("[plain highlights]\n" .. plain .. "\n[items] " .. joined .. "\n") end
    check(Has(plain:lower(), "won"), "the plain day text says a win: " .. plain)
    check(Has(joined, "Won in Warsong Gulch", "won"), "the plain highlights say the win: " .. joined)
    check(Has(joined, "Lost in Warsong Gulch", "lost"), "the plain highlights say the loss: " .. joined)
end

-- 6. The companion book, both voices: the two matches together as one line, the win, the first win.
local player = {name = "Alberich", race = "Scourge", faction = "Horde", class = "PALADIN", charKey = "alb"}
for _, voice in ipairs({"you", "we"}) do
    for retell = 0, 7 do
        dahlia.retell = retell
        local days = A.JournalBook(dahlia)
        local stories = A.JournalTale.Tell(dahlia, days, voice, player, false)
        local text = A.JournalPlain(stories[days[1].key].text)
        if show and retell == 0 then print(("[with Dahlia, %s]\n%s\n"):format(voice, text)) end
        check(text:find("Warsong Gulch", 1, true), "the battleground together (" .. voice .. " " .. retell .. "): " .. text)
        check(Has(text, "won", "victory"), "the win together: " .. text)
        check(Has(text, "twice", "two", "both"), "both matches, counted: " .. text)
        check(Has(text, "first"), "the first win ever, shared: " .. text)
        check(Count(text, "Warsong Gulch") <= 2, "the place at most twice (the opening and the matches): " .. text)
        check(not text:find("{%a+}"), "no raw token: " .. text)
        if voice == "we" then check(not text:find("%f[%a][Yy]ou%f[%A]"), "the diary never says you: " .. text) end
        local brief = A.JournalTale.Tell(dahlia, days, voice, player, true)
        local short = A.JournalPlain(brief[days[1].key].text)
        check(short:find("Warsong Gulch", 1, true) and Has(short, "won"), "Highlights keep the matches together: " .. short)
    end
end
A.db.people["dahlia-noir"] = nil

io.write("PASS: " .. assertions .. " battleground series assertions\n")
