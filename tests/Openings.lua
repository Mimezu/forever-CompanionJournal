-- Run from the client root: lua5.1 Interface/AddOns/CompanionJournal/tests/Openings.lua [print]
-- Chapter openings after an absence (2026-11-06): a game master opening a new
-- night at the table. Keyed to the real gap since the last recorded day (own
-- book) or the last outing together (companion book): a week, ten days, two
-- weeks, a month, months, half a year, the longest silence of the book. The
-- first sentence carries the elapsed time in words; on the long gaps a second
-- sentence recalls what the book recorded last (the place, who was there, a
-- lord's fall, the level), and Highlights leave that sentence out. Every
-- telling 0-7, both companion voices, both editions. Nothing invented: every
-- recalled fact is checked against the fixture.
local root = "Interface/AddOns/CompanionJournal/"
local assertions = 0
local function check(value, message) assertions = assertions + 1; assert(value, message) end
local show = arg and arg[1] == "print"

function time(t) if type(t) == "table" then return os.time(t) end return 1790000000 + 400 * 86400 end
function date(fmt, t) return os.date(fmt, t) end
function CreateFrame() return setmetatable({}, {__index = function() return function() end end}) end
C_Timer = {After = function() end}
LOCALIZED_CLASS_NAMES_MALE = {WARRIOR = "Warrior", PRIEST = "Priest", SHAMAN = "Shaman", MAGE = "Mage", WARLOCK = "Warlock", HUNTER = "Hunter", ROGUE = "Rogue", PALADIN = "Paladin"}
local A = {defaults = {colors = {}}}
for _, file in ipairs({"LoreData.lua", "Lore.lua", "LoreHordeStories.lua", "LoreAllianceStories.lua", "LoreWorldStories.lua", "LoreClassStories.lua",
    "People.lua", "Characters.lua", "Journal.lua", "JournalBook.lua", "JournalTellers.lua", "JournalTale.lua", "JournalWords.lua",
    "JournalSelfWords.lua", "JournalSelfTale.lua"}) do
    assert(loadfile(root .. file))("CompanionJournal", A)
end
A.db = {people = {}}
A.SelfUnderground = function(name)
    for _, word in ipairs({"Mine", "Cave", "Den"}) do if name:find("%f[%a]" .. word .. "%f[%A]") then return true end end
    return false
end
A.SelfPerson = function() return nil end
local W, PB = A.SelfWords, A.JournalTale.phrases

local BASE = os.time({year = 2026, month = 1, day = 5, hour = 0})
local function At(day, hour, minute) return BASE + day * 86400 + math.floor((hour or 20) * 3600) + (minute or 0) * 60 end
local function Sentences(text)
    local list = {}
    for s in text:gmatch("[^%.!%?]+[%.!%?]") do list[#list + 1] = (s:gsub("^%s+", "")) end
    return list
end
local TIME_WORDS = {"days", "week", "weeks", "month", "months", "year"}
local function HasTime(sentence)
    local low = sentence:lower()
    for _, w in ipairs(TIME_WORDS) do if low:find("%f[%a]" .. w .. "%f[%A]") then return true end end
    return false
end
local META = {"journal", "tale", "story", "song", "verse", "record", "chronicle", "legend", "bard", "page", "book", "chapter"}
local function NoMeta(plain, where, text)
    -- (a quest title may carry a colon of its own: "Wanted: Maggot Eye")
    if text then plain = A.JournalPlain((text:gsub("{q:[^}]*}", "Q"))) end
    local low = plain:lower()
    for _, w in ipairs(META) do check(not low:find("%f[%a]" .. w .. "%f[%A]"), "no meta word '" .. w .. "' (" .. where .. "): " .. plain) end
    check(not plain:find(":", 1, true), "no colon (" .. where .. "): " .. plain)
    check(not plain:find("?", 1, true), "no question (" .. where .. "): " .. plain)
end

-- 1. The own book: a life with gaps of every size ---------------------------------------
-- Day numbers and what each chapter holds; the gap before each chapter is the test's key.
local LIFE = {
    {day = 0, zone = "Tirisfal Glades", level = 6, quests = {"Fields of Grief", "Gordo's Task"}},
    {day = 1, zone = "Tirisfal Glades", level = 7, quests = {"Wanted: Maggot Eye"}},                                  -- gap 1
    {day = 3, zone = "Tirisfal Glades", level = 8, quests = {"The Mills Overrun"}},                                   -- gap 2
    {day = 6, zone = "Silverpine Forest", level = 9, quests = {"The Decrepit Ferry"}},                                -- gap 3
    {day = 11, zone = "Silverpine Forest", level = 10, quests = {"Rot Hide Clues"}},                                  -- gap 5
    {day = 18, zone = "Silverpine Forest", level = 11, quests = {"Ivar the Foul"}, with = "Dahlia"},                  -- gap 7, same zone
    {day = 28, zone = "The Barrens", level = 13, quests = {"Lost in Battle"}},                                        -- gap 10, elsewhere
    {day = 42, zone = "The Barrens", level = 14, quests = {"Raptor Thieves"},
        dungeon = "Wailing Caverns", bosses = {"Lord Cobrahn", "Mutanus the Devourer"}},                              -- gap 14, same zone
    {day = 60, zone = "Ashenvale", level = 16, quests = {"Raene's Cleansing"}},                                       -- gap 18, elsewhere (first visit)
    {day = 85, zone = "Ashenvale", level = 19, quests = {"The Zoram Strand"}, with = "Dahlia"},                       -- gap 25, same
    {day = 120, zone = "Stonetalon Mountains", level = 22, quests = {"Elemental War"}},                               -- gap 35, elsewhere (first visit)
    {day = 180, zone = "Stonetalon Mountains", level = 22, quests = {"Cenarius' Legacy"}},                            -- gap 60, same, level unchanged
    {day = 300, zone = "The Barrens", level = 30, quests = {"Kolkar Leaders"}},                                       -- gap 120, elsewhere (known)
    {day = 500, zone = "Thousand Needles", level = 31, quests = {"Wind Rider"}},                                      -- gap 200, elsewhere (first visit): the longest
    {day = 507, zone = "Thousand Needles", level = 32, quests = {"Test of Faith"}},                                   -- gap 7, same
}
local function OwnLife()
    local j = {}
    for _, c in ipairs(LIFE) do
        local t = At(c.day, 20)
        j[#j + 1] = {k = "play", t = t, e = t + 5400, z = c.zone, pl = c.level}
        local at = t + 60
        if c.with then j[#j + 1] = {k = "with", d = c.with:lower(), n = c.with, t = t, e = t + 5400}; at = at + 60 end
        if c.dungeon then
            j[#j + 1] = {k = "dungeon", d = c.dungeon, z = c.dungeon, t = at, pl = c.level, r = "damage"}
            at = at + 300
            for _, b in ipairs(c.bosses) do j[#j + 1] = {k = "boss", d = b, z = c.dungeon, t = at, pl = c.level}; at = at + 300 end
        end
        for _, q in ipairs(c.quests) do j[#j + 1] = {k = "quest", d = q, t = at, z = c.zone, pl = c.level}; at = at + 300 end
    end
    return {self = true, charKey = "gaps", name = "Mordren", race = "Scourge", faction = "Horde", class = "WARRIOR", startLevel = 6, journal = j}
end
local function OwnTell(p, brief, retell)
    local days = A.JournalBook(p)
    local stories = A.SelfTale.Tell(p, days, brief, retell)
    local out = {}
    for _, d in ipairs(days) do
        local s = stories[d.key]
        if s and s.text ~= "" then
            out[#out + 1] = {plain = A.JournalPlain(s.text), text = s.text, title = tostring(s.title)}
            if show and retell == 0 then print(("[own%s %d] %s\n%s\n"):format(brief and " Highlights" or "", #out, tostring(s.title), A.JournalPlain(s.text))) end
        end
    end
    return out
end
-- The time words a gap must produce (any of them in the first sentence).
local EXPECT = {
    [7] = {"a week"}, [10] = {"ten days"}, [14] = {"two weeks"}, [18] = {"eighteen days", "nearly three weeks"}, [11] = {"eleven days"},
    [25] = {"nearly a month", "four weeks"}, [35] = {"five weeks", "a month"}, [60] = {"two months"}, [120] = {"four months"},
    [200] = {"half a year", "six months"},
}
do
    local p = OwnLife()
    for _, brief in ipairs({false, true}) do
        for retell = 0, 7 do
            p.retell = retell
            local chapters = OwnTell(p, brief, retell)
            check(#chapters == #LIFE, "every day a chapter (" .. #chapters .. ")")
            local firsts = {}
            for i, c in ipairs(chapters) do
                local gap = i > 1 and (LIFE[i].day - LIFE[i - 1].day) or 0
                local sentences = Sentences(c.plain)
                local first = sentences[1] or ""
                NoMeta(c.plain, "own " .. retell .. "/" .. i, c.text)
                check(not c.text:find("{%a+}"), "no raw token: " .. c.text)
                check(not firsts[first], "no opening sentence twice in a book (" .. retell .. "): " .. first)
                firsts[first] = true
                local head = first .. " " .. (sentences[2] or "")
                if gap >= 7 then
                    -- (the opening may take two sentences: "I had been in the Barrens the last time. Eighteen days later it was Ashenvale.")
                    check(HasTime(head), "a gap of " .. gap .. " days opens on the elapsed time (" .. retell .. "): " .. c.plain)
                    local expect = EXPECT[gap]
                    if expect then
                        local found = false
                        for _, w in ipairs(expect) do if head:lower():find(w, 1, true) then found = true end end
                        check(found, "the gap of " .. gap .. " days in the right words (" .. retell .. "): " .. head)
                    end
                    -- (nothing about what happened in between)
                    for _, banned in ipairs({"away", "absence", "rest", "returned to the game", "break"}) do
                        check(not first:lower():find("%f[%a]" .. banned .. "%f[%A]"), "no invented absence (" .. retell .. "): " .. first)
                    end
                    -- (the place then is the last chapter's place, never another)
                    local lastZone = LIFE[i - 1].zone
                    local thisZone = LIFE[i].zone
                    if lastZone ~= thisZone and head:find(A.JournalPlain(lastZone), 1, true) then
                        check(head:find((A.JournalPlain(thisZone):gsub("^The ", "")), 1, true), "both places in the opening (" .. retell .. "): " .. head)
                    end
                elseif gap > 0 then
                    for _, w in ipairs({"had passed", "went by", "lay between", "gone by"}) do
                        check(not first:find(w, 1, true), "the absence shapes start at a week (" .. retell .. "): " .. first)
                    end
                end
                -- The recap: long gaps only, true to the chapter before, never in Highlights.
                local second = table.concat(sentences, " ", math.min(2, #sentences), math.min(3, #sentences))
                if #sentences < 2 then second = "" end
                local recap = false
                for _, w in ipairs({"up from", "Since then I had gone", "had been with me", "had been the last place, with", "the last time out",
                    "the end of the day, and", "I was still level", "as I had been", "I had been level"}) do
                    if second:find(w, 1, true) then recap = true end
                end
                if brief then check(not recap, "Highlights keep the opening, not the recap (" .. retell .. "): " .. c.plain)
                elseif recap then
                    check(gap >= 11, "a recap only after eleven days (" .. retell .. "): " .. c.plain)
                    local prev = LIFE[i - 1]
                    if second:find("up from", 1, true) or second:find("Since then", 1, true) or second:find("had been level", 1, true) then
                        check(second:find(tostring(prev.level), 1, true) and second:find(tostring(LIFE[i].level), 1, true),
                            "the levels recalled are the recorded ones (" .. retell .. "): " .. second)
                    end
                    if second:find("Mutanus", 1, true) then check(prev.bosses ~= nil, "the lord recalled fell last chapter: " .. second) end
                    if second:find("had been with me", 1, true) then check(prev.with == "Dahlia", "the company recalled is the last chapter's: " .. second) end
                end
                if gap >= 21 and not brief then
                    check(#sentences >= 2, "a long gap gets more than one sentence (" .. retell .. "): " .. c.plain)
                end
            end
            -- The 60-day gap with the level unchanged says so, or says something else true; never "up from 22".
            for _, c in ipairs(chapters) do check(not c.plain:find("up from 22", 1, true) or not c.plain:find("level 22 by then"), "no climb where none was recorded: " .. c.plain) end
        end
    end
end

-- 2. The companion book: outings a week, two weeks, a month, three months and half a year apart --
local PLAYER = {name = "Alberich", race = "Scourge", faction = "Horde", class = "PALADIN", charKey = "alb"}
local OUTINGS = {
    {day = 0, zone = "Tirisfal Glades", pl = 8, ol = 8, quests = {"Fields of Grief"}},
    {day = 7, zone = "Tirisfal Glades", pl = 10, ol = 10, quests = {"Gordo's Task"}},                                 -- a week, same
    {day = 21, zone = "Silverpine Forest", pl = 12, ol = 12, quests = {"The Decrepit Ferry"}},                        -- two weeks, elsewhere
    {day = 51, zone = "Silverpine Forest", pl = 17, ol = 18, quests = {"Rot Hide Clues"},
        dungeon = "Shadowfang Keep", bosses = {"Razorclaw the Butcher", "Archmage Arugal"}},                          -- a month, same
    {day = 141, zone = "The Barrens", pl = 24, ol = 24, quests = {"Lost in Battle"}},                                  -- three months, elsewhere
    {day = 341, zone = "Tirisfal Glades", pl = 40, ol = 42, quests = {"The Mills Overrun"}},                           -- half a year (the longest), where they met
    {day = 351, zone = "Tirisfal Glades", pl = 41, ol = 42, quests = {"Wanted: Maggot Eye"}},                          -- ten days, same
}
local function Companion(bond)
    local p = {name = "Dahlia-Forever", race = "Scourge", class = "PRIEST", pronouns = "she", journal = {}, key = "dahlia", bond = bond}
    for _, o in ipairs(OUTINGS) do
        local t = At(o.day, 21)
        p.journal[#p.journal + 1] = {k = "group", t = t, e = t + 5400, z = o.zone, pl = o.pl, ol = o.ol}
        local at = t + 300
        if o.dungeon then
            p.journal[#p.journal + 1] = {k = "dungeon", d = o.dungeon, z = o.dungeon, t = at, pl = o.pl, ol = o.ol}
            at = at + 300
            for _, b in ipairs(o.bosses) do p.journal[#p.journal + 1] = {k = "boss", d = b, z = o.dungeon, t = at, pl = o.pl, ol = o.ol}; at = at + 300 end
        end
        for _, q in ipairs(o.quests) do p.journal[#p.journal + 1] = {k = "quest", d = q, t = at, z = o.zone, pl = o.pl, ol = o.ol}; at = at + 300 end
    end
    return p
end
local function Tell(p, voice, brief, retell)
    p.retell = retell
    local days = A.JournalBook(p)
    local stories = A.JournalTale.Tell(p, days, voice, PLAYER, brief)
    local out = {}
    for _, d in ipairs(days) do
        local s = stories[d.key]
        out[#out + 1] = {plain = s and A.JournalPlain(s.text) or "", title = s and A.JournalPlain(s.title or "") or "", text = s and s.text or ""}
        if show and retell == 0 then print(("[%s%s %d] %s\n%s\n"):format(voice, brief and " Highlights" or "", #out, out[#out].title, out[#out].plain)) end
    end
    return out
end
local CEXPECT = {[7] = {"a week"}, [14] = {"two weeks"}, [30] = {"a month", "four weeks"}, [90] = {"three months"}, [200] = {"half a year", "six months"}, [10] = {"ten days"}}
for _, bond in ipairs({nil, "spouse"}) do
    for _, voice in ipairs({"you", "we"}) do
        for _, brief in ipairs({false, true}) do
            for retell = 0, 7 do
                local p = Companion(bond)
                local chapters = Tell(p, voice, brief, retell)
                check(#chapters == #OUTINGS, "a chapter an outing")
                local firsts = {}
                for i, c in ipairs(chapters) do
                    local where = (bond or "plain") .. " " .. voice .. (brief and " brief" or "") .. " " .. retell .. "/" .. i
                    local gap = i > 1 and (OUTINGS[i].day - OUTINGS[i - 1].day) or 0
                    local sentences = Sentences(c.plain)
                    local first = sentences[1] or ""
                    NoMeta(c.plain, where, c.text)
                    check(not c.text:find("{%a+}"), "no raw token (" .. where .. "): " .. c.text)
                    if voice == "we" then check(not c.plain:find("%f[%a][Yy]ou%f[%A]") and not c.plain:find("%f[%a][Yy]our%f[%A]"), "the diary never says you (" .. where .. "): " .. c.plain) end
                    if first ~= "" then check(not firsts[first], "no opening sentence twice in a book (" .. where .. "): " .. first); firsts[first] = true end
                    local head = first .. " " .. (sentences[2] or "")
                    if gap >= 7 and (not brief or gap >= 21) then
                        check(HasTime(head), "a gap of " .. gap .. " days opens on the elapsed time (" .. where .. "): " .. c.plain)
                        local found = false
                        for _, w in ipairs(CEXPECT[gap] or {}) do if head:lower():find(w, 1, true) then found = true end end
                        check(found, "the gap of " .. gap .. " days in the right words (" .. where .. "): " .. head)
                        for _, banned in ipairs({"away", "absence", "break"}) do
                            check(not first:lower():find("%f[%a]" .. banned .. "%f[%A]"), "no invented absence (" .. where .. "): " .. first)
                        end
                        -- (the place then: the last outing's, never another)
                        local lastZone, thisZone = A.JournalPlain(OUTINGS[i - 1].zone), A.JournalPlain(OUTINGS[i].zone)
                        for _, o in ipairs(OUTINGS) do
                            local z = A.JournalPlain(o.zone)
                            if z ~= lastZone and z ~= thisZone then check(not head:find(z, 1, true), "only the places then and now (" .. where .. "): " .. head) end
                        end
                    end
                    -- The recap: Everything only, true to the outing before.
                    local second = table.concat(sentences, " ", math.min(2, #sentences), math.min(3, #sentences))
                    if #sentences < 2 then second = "" end
                    local recap = false
                    for _, w in ipairs({"up from", "Since then", "had fallen to", "the last time out", "the end of the day, and",
                        "in the meantime", "had been level", "had climbed to"}) do
                        if second:find(w, 1, true) then recap = true end
                    end
                    if second:find("level", 1, true) and second:find("by then", 1, true) then recap = true end
                    if brief then check(not recap, "Highlights keep the opening, not the recap (" .. where .. "): " .. c.plain)
                    elseif recap and gap >= 11 then
                        local prev = OUTINGS[i - 1]
                        if second:find("level", 1, true) then
                            check(second:find(tostring(OUTINGS[i].ol), 1, true), "their level now is the recorded one (" .. where .. "): " .. second)
                            if second:find("up from", 1, true) or second:find("Since then", 1, true) then
                                check(second:find(tostring(prev.ol), 1, true), "their level then is the recorded one (" .. where .. "): " .. second)
                            end
                        end
                        if second:find("Arugal", 1, true) then check(prev.bosses ~= nil, "the lord recalled fell last outing (" .. where .. "): " .. second) end
                    end
                    -- Half a year later, back where they met: the opening says so in one telling or another; never claims a third place.
                    if gap == 200 and not brief then check((first .. (sentences[2] or "")):find("Tirisfal", 1, true), "the place now is named (" .. where .. "): " .. first) end
                end
            end
        end
    end
end

-- 3. Boundaries of the gap words --------------------------------------------------------
do
    local j = {}
    local days = {0, 6, 13, 20, 26, 31, 40, 73, 160, 240, 420, 590}
    local zones = {"Durotar", "The Barrens", "Durotar", "The Barrens", "Durotar", "The Barrens", "Durotar", "The Barrens", "Durotar", "The Barrens", "Durotar", "The Barrens"}
    for i, d in ipairs(days) do
        local t = At(d, 19)
        j[#j + 1] = {k = "play", t = t, e = t + 3600, z = zones[i], pl = 10 + i}
        j[#j + 1] = {k = "quest", d = "Errand " .. i, t = t + 600, z = zones[i], pl = 10 + i}
    end
    local p = {self = true, charKey = "bounds", name = "Grak", race = "Orc", faction = "Horde", class = "WARRIOR", startLevel = 11, journal = j}
    local expect = {[2] = false, [3] = {"seven days", "a week"}, [4] = {"a week", "seven days"}, [5] = {"six days"}, [6] = {"five days"}, [7] = {"nine days"},
        [8] = {"thirty-three days", "a month", "four weeks"}, [9] = {"three months"}, [10] = {"three months", "eighty days"}, [11] = {"six months", "half a year"}, [12] = {"six months", "five months"}}
    -- (the gaps: 6, 7, 7, 6, 5, 9, 33, 87, 80, 180, 170)
    local gaps = {}
    for i = 2, #days do gaps[i] = days[i] - days[i - 1] end
    for retell = 0, 7 do
        p.retell = retell
        local chapters = OwnTell(p, false, retell)
        for i = 2, #chapters do
            local ss = Sentences(chapters[i].plain)
            local first = (ss[1] or "") .. " " .. (ss[2] or "")
            local gap = gaps[i]
            if gap >= 7 then
                check(HasTime(first), "gap " .. gap .. " opens on time (" .. retell .. "): " .. first)
                local want = ({[7] = {"a week"}, [9] = {"nine days"}, [33] = {"a month", "four weeks"}, [87] = {"three months"}, [80] = {"three months"},
                    [180] = {"six months", "half a year"}, [170] = {"six months", "half a year"}})[gap]
                local ok = false
                for _, w in ipairs(want or {}) do if first:lower():find(w, 1, true) then ok = true end end
                check(ok, "gap " .. gap .. " in the right words (" .. retell .. "): " .. first)
            else
                check(not first:find("had passed", 1, true) and not first:find("lay between", 1, true), "gap " .. gap .. " keeps the short shapes (" .. retell .. "): " .. first)
            end
        end
    end
end

print("PASS: " .. assertions .. " opening assertions")
