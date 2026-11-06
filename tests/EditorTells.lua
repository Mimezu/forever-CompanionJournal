-- Run from the client root: lua5.1 Interface/AddOns/CompanionJournal/tests/EditorTells.lua [print]
-- The editor pass of 2026-11-05: machine tells taken out of both tellers.
-- Own journal: a chapter a week or less after one that opened on the day
-- opens on the place or the company instead; "left home" only when the book
-- stood at home; a spirit healer is no "stranger named"; a memory says how
-- long before; a level is told once; a role line never twice, never in two
-- chapters running, never joined to the level; a small pick carries no
-- "for the most part"; Highlights drop a non-gatherer's small pick.
-- Companion journal: a weekly regular's "seven days later" is not every
-- chapter's opening; titles start with a capital; "work meant for more
-- seasoned adventurers" once a book; a role line never twice; a hand-in's
-- place never a bare "You were in X." between setup and outcome; kills in
-- one visit stay one sentence when no hand-in falls among them. Pools: no
-- "and few ever do", no "these pages", no "was banished".
local root = "Interface/AddOns/CompanionJournal/"
local assertions = 0
local function check(value, message) assertions = assertions + 1; assert(value, message) end
local show = arg and arg[1] == "print"

function time(t) if type(t) == "table" then return os.time(t) end return 1790000000 + 40 * 86400 end
function date(fmt, t) return os.date(fmt, t) end
function CreateFrame() return setmetatable({}, {__index = function() return function() end end}) end
C_Timer = {After = function() end}
LOCALIZED_CLASS_NAMES_MALE = {WARRIOR = "Warrior", PRIEST = "Priest", SHAMAN = "Shaman", MAGE = "Mage", WARLOCK = "Warlock", HUNTER = "Hunter", ROGUE = "Rogue"}
local A = {defaults = {colors = {}}}
for _, file in ipairs({"LoreData.lua", "Lore.lua", "People.lua", "Characters.lua", "Journal.lua", "JournalBook.lua", "JournalTellers.lua",
    "JournalTale.lua", "JournalWords.lua", "JournalSelfWords.lua", "JournalSelfTale.lua"}) do
    assert(loadfile(root .. file))("CompanionJournal", A)
end
A.db = {people = {}}
A.SelfUnderground = function(name)
    for _, word in ipairs({"Mine", "Cave", "Den"}) do if name:find("%f[%a]" .. word .. "%f[%A]") then return true end end
    return false
end
local W, PB = A.SelfWords, A.JournalTale.phrases

-- Pools ---------------------------------------------------------------------------
do
    local function Walk(t, path, seen)
        if type(t) ~= "table" or seen[t] then return end
        seen[t] = true
        for k, v in pairs(t) do
            if type(v) == "string" then
                check(not v:find("few ever do", 1, true) and not v:find("not many ever do", 1, true), path .. "." .. tostring(k) .. ": " .. v)
                check(not v:find("these pages", 1, true), path .. "." .. tostring(k) .. ": " .. v)
                check(not v:find("was banished", 1, true), path .. "." .. tostring(k) .. ": " .. v)
                check(not v:find("as far as any trainer", 1, true), path .. "." .. tostring(k) .. ": " .. v)
                check(not v:find("There was {what}, and I read it", 1, true) and not v:find("stood there, and I read", 1, true), path .. ": " .. v)
            elseif type(v) == "table" then Walk(v, path .. "." .. tostring(k), seen) end
        end
    end
    Walk(W, "W", {})
    Walk(PB, "PB", {})
    for _, key in ipairs({"openBare", "openStillBare", "openNewBare", "openWithBare", "openBackBare", "openSameBare", "openStillWorkBare", "openPerilBare", "openDungeonBare"}) do
        check(type(W[key]) == "table" and #W[key] >= 2, "bare pool " .. key)
        for _, line in ipairs(W[key]) do check(not line:find("{[Ww]hen}", 1, true), key .. " carries no day: " .. line) end
    end
    for _, line in ipairs(W.backMemory) do check(line:find("{ago} before", 1, true) or line:find("{ago} earlier", 1, true), "memory says how long before: " .. line) end
    for _, line in ipairs(W.openBackMemory) do check(line:find("{ago} before", 1, true) or line:find("{ago} earlier", 1, true), "memory says how long before: " .. line) end
end

-- Own journal ---------------------------------------------------------------------
local BASE = os.time({year = 2026, month = 9, day = 1, hour = 0})
local function At(day, hour, minute) return BASE + day * 86400 + math.floor((hour or 20) * 3600) + (minute or 0) * 60 end
local function Stretch(journal, t, minutes, zone, pl, events)
    journal[#journal + 1] = {k = "play", t = t, e = t + minutes * 60, z = zone, pl = pl}
    for i, ev in ipairs(events or {}) do
        local entry = {t = t + i * 90, z = zone, pl = pl}
        for key, value in pairs(ev) do entry[key] = value end
        journal[#journal + 1] = entry
    end
end
local function Q(titles) local out = {} for _, q in ipairs(titles) do out[#out + 1] = {k = "quest", d = q} end return out end
local function Join(...) local out = {} for _, list in ipairs({...}) do for _, x in ipairs(list) do out[#out + 1] = x end end return out end
local function Tellings(p, brief)
    local all = {}
    for retell = 0, 7 do
        local days = A.JournalBook(p)
        local stories = A.SelfTale.Tell(p, days, brief, retell)
        local chapters = {}
        for _, d in ipairs(days) do
            local s = stories[d.key]
            if s and s.text ~= "" then
                chapters[#chapters + 1] = {plain = A.JournalPlain(s.text), text = s.text, title = s.title}
                if show and retell == 0 then print(("[%s%s] %s\n%s\n"):format(p.name, brief and " (Highlights)" or "", tostring(s.title), A.JournalPlain(s.text))) end
            end
        end
        all[retell] = chapters
    end
    return all
end
local WEEKDAYS = {"Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday", "Sunday"}
local function DayLed(plain)
    if plain:find("^On %u") or plain:find("^The next day") or plain:find("^A day later") or plain:find("^The day after") or plain:find("^The following ")
        or plain:find("^%u%l+ days later") or plain:find("^%u%l+ weeks later") or plain:find("^%u%l+ months later") or plain:find("^Later") or plain:find("^After that") then return true end
    for _, w in ipairs(WEEKDAYS) do if plain:find("^" .. w .. " ") then return true end end
    return false
end

-- 1. Ten days in a row in the Barrens: the day leads at most two chapters in three, never a long run.
do
    local j = {}
    for d = 0, 9 do Stretch(j, At(d), 90, "The Barrens", 12 + d, Q({"Raptor Thieves " .. d, "Kolkar Leaders " .. d})) end
    local p = {self = true, charKey = "run", name = "Zuni", race = "Troll", faction = "Horde", class = "HUNTER", startLevel = 12, journal = j}
    for retell, chapters in pairs(Tellings(p, false)) do
        check(#chapters == 10, "ten chapters")
        local led, run, longest = 0, 0, 0
        for _, c in ipairs(chapters) do
            if DayLed(c.plain) then led, run = led + 1, run + 1 else run = 0 end
            longest = math.max(longest, run)
        end
        check(led <= 7 and led >= 2, "the day leads some chapters, not all (" .. retell .. "): " .. led)
        check(longest <= 3, "never four day-led chapters running (" .. retell .. "): " .. longest)
        for _, c in ipairs(chapters) do check(not c.plain:find("^%l"), "a chapter starts with a capital: " .. c.plain) end
    end
    -- (a gap of two weeks keeps its time phrase: elapsed time is news)
    local j2 = {}
    Stretch(j2, At(0), 90, "The Barrens", 12, Q({"Raptor Thieves"}))
    Stretch(j2, At(1), 90, "The Barrens", 13, Q({"Kolkar Leaders"}))
    Stretch(j2, At(20), 90, "The Barrens", 14, Q({"Lost in Battle"}))
    local p2 = {self = true, charKey = "gap", name = "Zuni", race = "Troll", faction = "Horde", class = "HUNTER", startLevel = 12, journal = j2}
    -- (since 2026-11-06 the gap opens as a game master would: the elapsed time is in the first sentence,
    -- not always in front of it)
    for retell, chapters in pairs(Tellings(p2, false)) do
        local first = chapters[3].plain:match("^[^%.]*%.")
        check(DayLed(chapters[3].plain) or first:find("weeks") or first:find("days") or first:find("month"),
            "a long gap keeps its time (" .. retell .. "): " .. chapters[3].plain)
    end
end

-- 2. A tauren whose record begins in Durotar at level six never "left Mulgore behind".
-- (A level-one start says where the race begins: that is the game's own rule, and the book opened on it.)
do
    local j = {}
    Stretch(j, At(0), 60, "Durotar", 6, Q({"Cutting Teeth"}))
    Stretch(j, At(1), 60, "Durotar", 7, Q({"Sarkoth"}))
    Stretch(j, At(2), 60, "The Barrens", 9, Join({{k = "first", d = "zone", z = "The Barrens"}}, Q({"Raptor Thieves"})))
    local p = {self = true, charKey = "thruk", name = "Thruk", race = "Tauren", faction = "Horde", class = "DRUID", startLevel = 6, journal = j}
    for retell, chapters in pairs(Tellings(p, false)) do
        for _, c in ipairs(chapters) do check(not c.plain:find("Mulgore", 1, true), "no home left behind that was never recorded (" .. retell .. "): " .. c.plain) end
    end
    -- (a tauren who did begin in Mulgore still leaves it behind)
    local j2 = {}
    Stretch(j2, At(0), 60, "Mulgore", 1, Q({"The Hunt Begins"}))
    Stretch(j2, At(1), 60, "Mulgore", 5, Q({"Rite of Strength"}))
    Stretch(j2, At(2), 60, "The Barrens", 10, Join({{k = "first", d = "zone", z = "The Barrens"}}, Q({"Raptor Thieves"})))
    local p2 = {self = true, charKey = "nahiri", name = "Nahiri", race = "Tauren", faction = "Horde", class = "DRUID", startLevel = 1, journal = j2}
    local left = 0
    for _, chapters in pairs(Tellings(p2, false)) do
        if chapters[3].plain:find("Mulgore", 1, true) then left = left + 1 end
    end
    check(left >= 4, "a recorded home is left behind in most tellings: " .. left)
end

-- 3. A spirit healer is not "a stranger named a spirit healer".
do
    local j = {}
    Stretch(j, At(0), 90, "Duskwood", 24, {{k = "death", d = "Worgen", t = At(0) + 600}, {k = "rez", by = "a spirit healer", t = At(0) + 900}})
    local p = {self = true, charKey = "arlen", name = "Arlen", race = "Human", faction = "Alliance", class = "WARRIOR", startLevel = 20, journal = j}
    for retell, chapters in pairs(Tellings(p, false)) do
        check(not chapters[1].plain:find("stranger", 1, true) and not chapters[1].plain:find("spirit healer", 1, true), "no stranger named a spirit healer (" .. retell .. "): " .. chapters[1].plain)
    end
end

-- 4. Back where a foe killed you: the memory says how long before.
do
    local j = {}
    Stretch(j, At(0), 90, "Duskwood", 24, {{k = "death", d = "Worgen", sz = "Duskwood"}})
    Stretch(j, At(1), 90, "Westfall", 25, Q({"The Killing Fields"}))
    Stretch(j, At(30), 90, "Duskwood", 28, Q({"Raven Hill"}))
    local p = {self = true, charKey = "memory", name = "Arlen", race = "Human", faction = "Alliance", class = "WARRIOR", startLevel = 20, journal = j}
    local said = 0
    for retell, chapters in pairs(Tellings(p, false)) do
        local three = chapters[3].plain
        if three:find("Worgen", 1, true) then
            said = said + 1
            check(three:find("weeks before", 1, true) or three:find("weeks earlier", 1, true) or three:find("month before", 1, true) or three:find("month earlier", 1, true),
                "the memory says how long before (" .. retell .. "): " .. three)
        end
    end
    check(said >= 1, "the memory is told in some telling")
end

-- 5. Level sixty twice in the record is told once, and the look-back names no pages.
do
    local j = {}
    for d = 0, 2 do Stretch(j, At(d), 120, "Winterspring", 57 + d, Q({"Winterfall Activity " .. d, "Wildkin of Elune " .. d})) end
    Stretch(j, At(3), 120, "Eastern Plaguelands", 59, Join(Q({"Demon Dogs", "Blood Tinged Skies"}), {{k = "mylevel", d = 60}}))
    Stretch(j, At(4), 120, "Blackrock Spire", 60, Join(Q({"Blackhand's Command"}), {{k = "mylevel", d = 60}}))
    local p = {self = true, charKey = "sixty", name = "Krosh", race = "Orc", faction = "Horde", class = "WARRIOR", startLevel = 57, journal = j}
    for retell, chapters in pairs(Tellings(p, false)) do
        local n = 0
        for _, c in ipairs(chapters) do
            for _ in c.plain:gmatch("level sixty") do n = n + 1 end
            for _ in c.plain:gmatch("level 60") do n = n + 1 end
            check(not c.plain:find("pages", 1, true), "no pages: " .. c.plain)
        end
        check(n == 1, "level sixty told once (" .. retell .. "): " .. n)
    end
end

-- 6. Role lines: never the same twice, never in two chapters running, never joined to the level.
do
    local j = {}
    local dungeons = {{"Scarlet Monastery", "Tirisfal Glades", 34}, {"Zul'Farrak", "Tanaris", 44}, {"Razorfen Downs", "The Barrens", 37}, {"Uldaman", "Badlands", 40},
        {"Maraudon", "Desolace", 46}, {"The Temple of Atal'Hakkar", "Swamp of Sorrows", 50}}
    for i, d in ipairs(dungeons) do
        local t = At(i * 2)
        j[#j + 1] = {k = "play", t = t, e = t + 7200, z = d[1], pl = d[3]}
        j[#j + 1] = {k = "dungeon", d = d[1], t = t + 60, z = d[1], pl = d[3], r = "healer", n = 5}
        j[#j + 1] = {k = "boss", d = "Recorded Lord " .. i, t = t + 1800, z = d[1], pl = d[3], n = 5}
        j[#j + 1] = {k = "boss", d = "Recorded Captain " .. i, t = t + 3600, z = d[1], pl = d[3], n = 5}
        j[#j + 1] = {k = "mylevel", d = d[3] + 1, t = t + 5000, z = d[1], pl = d[3]}
    end
    local p = {self = true, charKey = "healer", name = "Kahlu", race = "Troll", faction = "Horde", class = "PRIEST", startLevel = 34, journal = j}
    local roleWords = {"at the back", "behind the others", "kept them standing", "kept the others"}
    for retell, chapters in pairs(Tellings(p, false)) do
        local seen, lastRole = {}, nil
        for i, c in ipairs(chapters) do
            local plain = c.plain
            local hasRole = false
            for sentence in plain:gmatch("[^%.]+%.") do
                local isRole = false
                for _, word in ipairs(roleWords) do if sentence:find(word, 1, true) then isRole = true end end
                do
                    if isRole then
                        hasRole = true
                        check(not seen[sentence], "a role line said twice in one book (" .. retell .. "): " .. sentence)
                        seen[sentence] = true
                        check(not sentence:find(", and I reached level", 1, true) and not sentence:find(", and I made level", 1, true)
                            and not sentence:find(", and I went up to level", 1, true) and not sentence:find(", and I climbed to level", 1, true),
                            "a role line never takes the level (" .. retell .. "): " .. sentence)
                    end
                end
            end
            if hasRole then
                check(lastRole ~= i - 1, "no role line in two chapters running (" .. retell .. "): " .. plain)
                lastRole = i
            end
        end
    end
end

-- 7. Two herbs are not "Peacebloom for the most part"; Highlights drop a non-gatherer's small pick.
do
    local j = {}
    Stretch(j, At(0), 120, "Un'Goro Crater", 52, Join(Q({"Super Sticky", "Chasing A-Me 01"}), {{k = "gather", m = {herbs = 2}, names = {herbs = {"Peacebloom", "Silverleaf"}}}}))
    local p = {self = true, charKey = "fewherbs", name = "Arlen", race = "Human", faction = "Alliance", class = "WARRIOR", startLevel = 50, journal = j}
    for retell, chapters in pairs(Tellings(p, false)) do
        check(not chapters[1].plain:find("for the most part", 1, true) and not chapters[1].plain:find("most of them", 1, true), "no 'for the most part' on two herbs (" .. retell .. "): " .. chapters[1].plain)
    end
    for retell, chapters in pairs(Tellings(p, true)) do
        check(not chapters[1].plain:find("two herbs", 1, true), "Highlights drop a small pick on a quest day (" .. retell .. "): " .. chapters[1].plain)
    end
end

-- Companion journal -----------------------------------------------------------------
local Tell = A.JournalTale.Tell
local PLAYER = {race = "Scourge", faction = "Horde", class = "PRIEST"}
local CB = os.time({year = 2026, month = 3, day = 2, hour = 0})
local function CAt(day, hour) return CB + day * 86400 + (hour or 20) * 3600 end
local function Person(name, class, race, pronouns) return {name = name .. "-Forever", class = class, race = race, pronouns = pronouns, journal = {}} end
local function Outing(p, t, zone, minutes, pl, ol, events)
    local j = p.journal
    j[#j + 1] = {k = "group", t = t, e = t + minutes * 60, z = zone, pl = pl, ol = ol}
    local where = zone
    for i, ev in ipairs(events or {}) do
        local entry = {k = ev[1], t = t + i * 120, z = where, pl = pl, ol = ol}
        if ev[1] == "dungeon" then entry.d, entry.z, entry.r, entry.tr = ev[2], ev[2], "healer", "tank"; where = ev[2]
        elseif ev[1] == "boss" or ev[1] == "wipe" or ev[1] == "quest" or ev[1] == "level" or ev[1] == "rest" then entry.d = ev[2]
        elseif ev[1] == "death" then entry.w, entry.env, entry.boss = ev[2], ev[3], ev[4]
        end
        if ev[1] == "quest" then entry.ql = ev[3] end
        if ev[1] == "boss" then entry.n = 5 end
        j[#j + 1] = entry
    end
end
local function Chapters(p, voice)
    local days = A.JournalBook(p)
    local stories = Tell(p, days, voice or "you", PLAYER)
    local out = {}
    for _, day in ipairs(days) do
        local s = stories[day.key]
        if s and (s.text ~= "" or #s.quotes > 0) then
            out[#out + 1] = {day = day, text = s.text, title = A.JournalPlain(s.title or ""), plain = A.JournalPlain(s.text)}
            if show then print(("[with %s] %s\n%s\n"):format(p.name, A.JournalPlain(s.title or ""), A.JournalPlain(s.text))) end
        end
    end
    return out
end

-- 8. A weekly regular: "seven days later" is not every chapter's opening; titles start with a capital.
do
    local mira = Person("Mira", "PRIEST", "Tauren", "she")
    mira.met, mira.metZone = CAt(0), "Hillsbrad Foothills"
    local zones = {"Hillsbrad Foothills", "Hillsbrad Foothills", "Thousand Needles", "Stranglethorn Vale", "Desolace", "Tanaris", "Arathi Highlands", "Dustwallow Marsh",
        "Feralas", "The Hinterlands", "Un'Goro Crater", "Felwood"}
    for i, zone in ipairs(zones) do Outing(mira, CAt((i - 1) * 7), zone, 100, 20 + i * 3, 20 + i * 3, {{"quest", "Recorded Errand " .. i}}) end
    for _, voice in ipairs({"you", "we"}) do
        local chapters = Chapters(mira, voice)
        check(#chapters == 12, "twelve chapters")
        local intervals = 0
        for i, c in ipairs(chapters) do
            if c.plain:find("^%u%l+ days later") or c.plain:find("^A week later") or c.plain:find("^Seven days later") then intervals = intervals + 1 end
            check(not c.title:find("^%l"), "a title starts with a capital: " .. c.title)
        end
        check(intervals <= 4, "a regular's week is not every opening (" .. voice .. "): " .. intervals)
        check(intervals >= 1, "the week is said at least once (" .. voice .. ")")
    end
end

-- 9. "Work meant for more seasoned adventurers" once a book; a role line never twice; kills stay one sentence.
do
    local bruk = Person("Bruk", "WARRIOR", "Tauren", "he")
    bruk.met, bruk.metZone = CAt(0), "The Barrens"
    for i = 1, 6 do Outing(bruk, CAt(i * 2), "The Barrens", 100, 14 + i, 14 + i, {{"quest", "Hard Errand " .. i, 25}}) end
    local dungeons = {{"Wailing Caverns", 18}, {"Shadowfang Keep", 22}, {"Razorfen Kraul", 28}, {"Scarlet Monastery", 34}, {"Uldaman", 40}}
    for i, d in ipairs(dungeons) do
        Outing(bruk, CAt(20 + i * 3), "The Barrens", 150, d[2], d[2], {{"dungeon", d[1]}, {"boss", "Recorded Lord " .. i}, {"boss", "Recorded Captain " .. i}, {"boss", "Recorded Warden " .. i}})
    end
    local chapters = Chapters(bruk, "you")
    local hard, roles, seen = 0, {}, {}
    for _, c in ipairs(chapters) do
        for _ in c.plain:gmatch("more seasoned adventurers") do hard = hard + 1 end
        for _ in c.plain:gmatch("despite its difficulty") do hard = hard + 1 end
        for sentence in c.plain:gmatch("[^%.]+%.") do
            if sentence:find("stood in front", 1, true) or sentence:find("took the blows", 1, true) or sentence:find("held the enemies", 1, true) then
                check(not seen[sentence], "a companion role line said twice in one book: " .. sentence)
                seen[sentence] = true
            end
        end
        if c.plain:find("Recorded Lord", 1, true) then
            check(c.plain:find("Recorded Lord %d, Recorded Captain %d and Recorded Warden %d") or c.plain:find("Recorded Lord %d, then Recorded Captain %d") or c.plain:find("Recorded Lord %d and Recorded Captain %d"),
                "kills in one visit stay one sentence: " .. c.plain)
        end
    end
    check(hard <= 1, "the hard-quest phrase once a book: " .. hard)
end

-- 10. A hand-in in another zone: its place rides on the outcome, never a bare "You were in X." between setup and outcome.
do
    local story = A.Lore.QuestStory and A.Lore.QuestStory("Raptor Thieves")
    if story and story.after and story.why then
        local grosh = Person("Grosh", "SHAMAN", "Orc", "he")
        grosh.met, grosh.metZone = CAt(0), "Durotar"
        Outing(grosh, CAt(0), "Durotar", 90, 10, 10, {{"quest", "Vanquish the Betrayers"}})
        local t = CAt(1)
        grosh.journal[#grosh.journal + 1] = {k = "group", t = t, e = t + 7200, z = "Durotar", pl = 11, ol = 11}
        grosh.journal[#grosh.journal + 1] = {k = "quest", d = "Burning Blade Medallion", t = t + 600, z = "Durotar", pl = 11, ol = 11}
        grosh.journal[#grosh.journal + 1] = {k = "group", t = t + 3600, e = t + 7200, z = "The Barrens", pl = 11, ol = 11}
        grosh.journal[#grosh.journal + 1] = {k = "quest", d = "Raptor Thieves", t = t + 5000, z = "The Barrens", pl = 11, ol = 11}
        for _, voice in ipairs({"you", "we"}) do
            local chapters = Chapters(grosh, voice)
            for _, c in ipairs(chapters) do
                check(not c.plain:find("%. You were in [%w' ]+%. ") and not c.plain:find("%. We were in [%w' ]+%. "), "no bare placement between setup and outcome (" .. voice .. "): " .. c.plain)
            end
        end
    end
end

print("PASS: " .. assertions .. " editor-tell assertions")
