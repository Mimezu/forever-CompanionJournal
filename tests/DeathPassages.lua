-- Run from the client root: lua5.1 Interface/AddOns/CompanionJournal/tests/DeathPassages.lua [print]
-- A run of deaths is one movement, in the order it happened (2026-11-11, round 2; reader G
-- round 4): the signal once a chapter, the first death with its killer, the fights between as
-- one sentence (a repeated killer named once, "the Venture Co. killed me three times more",
-- the companions' falls by count, a known hand's raises as a clause, a stranger's raise its
-- own sentence), the last fight, no second count; no clock words, no judgment. A wipe in
-- a dungeon told as the first try with its tally; a companion who fell twice (never "Dahlia
-- and Dahlia"); a friend who raised me known by first name ("Marrow Rotmoor" for
-- Marrow-Rotmoor), a stranger still a stranger; a lone death one plain sentence; a lone
-- companion death with nothing around it dropped; a friend who had left before not in the
-- fight; generic killers lower-case with "a", named ones bare; other characters, races and
-- places than the book it was found in.
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
A.SelfUnderground = function(name)
    for _, word in ipairs({"Mine", "Cave", "Den"}) do if name:find("%f[%a]" .. word .. "%f[%A]") then return true end end
    return false
end

local BASE = os.time({year = 2026, month = 9, day = 1, hour = 0})
local function At(day, hour, minute) return BASE + day * 86400 + math.floor((hour or 20) * 3600) + (minute or 0) * 60 end
-- (events at their own minute after the start of the stretch: {m = 3, k = ...})
local function Stretch(journal, t, minutes, zone, pl, events)
    journal[#journal + 1] = {k = "play", t = t, e = t + minutes * 60, z = zone, pl = pl}
    for i, ev in ipairs(events or {}) do
        local entry = {t = t + (ev.m and ev.m * 60 or i * 90), z = zone, pl = pl}
        for key, value in pairs(ev) do if key ~= "m" then entry[key] = value end end
        journal[#journal + 1] = entry
    end
end
local function With(journal, key, name, t, minutes) journal[#journal + 1] = {k = "with", d = key, n = name, t = t, e = t + minutes * 60} end
local function Count(text, word) local n = 0 for _ in text:gmatch(word) do n = n + 1 end return n end
local function Sentences(text)
    local out = {}
    for sentence in text:gmatch("[^%.]+%.") do out[#out + 1] = sentence:gsub("^%s+", "") end
    return out
end
-- ("a Defias pillager", or "A Defias pillager" at the head of a sentence: the kind word lowered)
local function Generic(text, name) return text:find("%f[%a][Aa]n? " .. name:gsub("%p", "%%%0")) ~= nil end
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
-- The rules every chapter keeps, and the ones of this lane: no name twice in one list,
-- nobody of the party or the list a stranger, no clock openings, no judgment, no ledger.
local NAMES = {"Tam", "Oda", "Mira", "Tok", "Lyra", "Dahlia", "Borox", "Kesh"}
local CLOCK = {"minutes later", "minutes on", "Moments later", "Not long after", "Before the hour was out", "Later that day", "A minute or two later"}
local JUDGMENT = {"myself to blame", "no excuse", "hoped never", "hoped not"}
local function Clean(p, known)
    for _, brief in ipairs({false, true}) do
        for retell, chapters in pairs(Tellings(p, brief)) do
            for _, c in ipairs(chapters) do
                check(not c.text:find("{%a+}"), "no raw token (" .. retell .. "): " .. c.text)
                check(not c.text:gsub("{%a:[^}]*}", ""):find(":", 1, true), "no colons: " .. c.plain)
                check(not c.plain:find("%?"), "no questions: " .. c.plain)
                for _, name in ipairs(NAMES) do
                    check(not c.plain:find(name .. " and " .. name, 1, true) and not c.plain:find(name .. ", " .. name, 1, true),
                        "a name once in a list: " .. c.plain)
                end
                check(not c.plain:find("died there", 1, true), "no 'died there' ledger line: " .. c.plain)
                check(not c.plain:find(" too%.") and not c.plain:find("as well, before the day"), "no 'too' chain: " .. c.plain)
                for _, word in ipairs(CLOCK) do check(not c.plain:find(word, 1, true), "no clock word '" .. word .. "': " .. c.plain) end
                for _, word in ipairs(JUDGMENT) do check(not c.plain:find(word, 1, true), "no judgment or wish '" .. word .. "': " .. c.plain) end
                check(not c.plain:find("a second time a ", 1, true) and not c.plain:find("A second time a ", 1, true), "no broken 'a second time a': " .. c.plain)
                check(Count(c.plain, "went badly") + Count(c.plain, "nearly finished") + Count(c.plain, "another matter") <= 1
                    and Count(c.plain, "no kinder") + Count(c.plain, "no better") <= 1, "the signal once a chapter: " .. c.plain)
                for _, name in ipairs(known or {}) do
                    for _, sentence in ipairs(Sentences(c.plain)) do
                        check(not (sentence:find(name, 1, true) and (sentence:find("never met", 1, true) or sentence:find("stranger", 1, true))),
                            name .. " is no stranger: " .. sentence)
                    end
                end
            end
        end
    end
end

-- 1. A wipe in a dungeon, told as the first try with its tally right there: a dwarf priest and
--    two of her list, the party's deaths logged as the ghosts ran out through Westfall (one
--    fight, not three places). Nine deaths before it make the wipe her tenth.
do
    local j = {}
    for d = 0, 8 do Stretch(j, At(d, 20), 30, "Westfall", 12 + d, {{m = 10, k = "death", w = "you", d = "Defias Looter"}, {m = 20, k = "quest", d = "Errand " .. d}}) end
    local t = At(10, 20)
    Stretch(j, t, 6, "The Deadmines", 18, {{m = 0, k = "dungeon", d = "The Deadmines", r = "healer"},
        {m = 4, k = "death", w = "you", d = "Defias Pillager"}, {m = 5, k = "pdeath", n = "Tam-Realm"}})
    Stretch(j, t + 6 * 60, 1, "Westfall", 18, {{m = 0, k = "pdeath", n = "Oda-Realm"}})
    Stretch(j, t + 8 * 60, 40, "The Deadmines", 18, {{m = 0, k = "dungeon", d = "The Deadmines", r = "healer"},
        {m = 10, k = "boss", d = "Rhahk'Zor", n = 5}, {m = 25, k = "boss", d = "Mr. Smite", n = 5}})
    With(j, "tam", "Tam-Realm", t, 50); With(j, "oda", "Oda-Realm", t, 50)
    A.db.people.tam = {name = "Tam-Realm", class = "WARRIOR", race = "Dwarf"}
    A.db.people.oda = {name = "Oda-Realm", class = "ROGUE", race = "Gnome"}
    local p = {self = true, charKey = "brann", name = "Brann", race = "Dwarf", faction = "Alliance", class = "PRIEST", startLevel = 12, journal = j}
    Clean(p, {"Tam", "Oda"})
    for retell, chapters in pairs(Tellings(p)) do
        local ten = chapters[10].plain
        check(ten:find("first try", 1, true) or ten:find("first time in", 1, true), "the lost fight is the first try (" .. retell .. "): " .. ten)
        local fight
        for _, sentence in ipairs(Sentences(ten)) do if sentence:find("illager", 1, true) then fight = sentence end end
        check(fight and Generic(fight, "Defias pillager"), "a generic killer takes 'a' and a lowered kind word: " .. ten)
        check(fight and fight:find("Tam", 1, true) and fight:find("Oda", 1, true), "the wipe is one sentence with everyone in it: " .. ten)
        -- (the dungeon telling keeps a death count out of the run's paragraph; the count at the
        -- wipe is checked in the field, fixture 6)
        check(not ten:find("tenth time[^%.]*%.[^%.]*Rhahk") or ten:find("illager[^%.]*%.[^%.]*tenth"), "a tally, if told, follows the wipe: " .. ten)
        check(not ten:find("Westfall%.[^%.]*Oda"), "nobody dies 'there' in Westfall: " .. ten)
    end
    A.db.people.tam, A.db.people.oda = nil, nil
end
-- (the run itself, as the dungeon telling sees it)
do
    local t = At(0, 20)
    local s1 = {zone = "The Deadmines", t = t, e = t + 360, with = {}, events = {{k = "dungeon", d = "The Deadmines", t = t},
        {k = "death", d = "Defias Pillager", t = t + 240, w = "you"}, {k = "pdeath", n = "Tam-Realm", t = t + 300}}}
    local s2 = {zone = "Westfall", t = t + 360, e = t + 420, with = {}, events = {{k = "pdeath", n = "Oda-Realm", t = t + 360}}}
    local s3 = {zone = "The Deadmines", t = t + 480, e = t + 2880, with = {}, events = {{k = "dungeon", d = "The Deadmines", t = t + 480},
        {k = "boss", d = "Rhahk'Zor", t = t + 1080}}}
    local runs = A.SelfTale.DeathRuns({s1, s2, s3})
    check(#runs == 1 and runs[1].firstTry == true and runs[1].dungeon == "The Deadmines" and runs[1].wipe == true and #runs[1].beats == 1,
        "one run, a wipe, the first try at the Deadmines")
    check(s1.events[2].deathRun == runs[1] and s1.events[3].told and s2.events[1].told, "the first death carries the run; every death of it is told")
    -- (a lone death, or a death and the rescue that answered it, is no run)
    local s4 = {zone = "Westfall", t = t, e = t + 3600, with = {}, events = {{k = "death", d = "Hogger", t = t + 600, w = "you"}, {k = "rez", by = "Thandrel", t = t + 900}}}
    check(#A.SelfTale.DeathRuns({s4}) == 0 and not s4.events[1].told, "a death and its rescue keep their own lines")
    -- (a listed companion whose time with me ended before the fight is not in it)
    local s5 = {zone = "Westfall", t = t, e = t + 3600, with = {{name = "Kesh", key = "kesh", seconds = 600, spans = {{t, t + 600}}}},
        events = {{k = "death", d = "Defias Looter", t = t + 2400, w = "you"}, {k = "pdeath", n = "Kesh-Realm", t = t + 2460}, {k = "death", d = "Defias Looter", t = t + 2700, w = "you"}}}
    local r5 = A.SelfTale.DeathRuns({s5})
    check(#r5 == 1 and s5.events[2].told, "a friend who had left is marked and left out")
    local inRun = false
    for _, it in ipairs(r5[1].items) do if it.k == "party" then inRun = true end end
    check(not inRun, "a friend who had left before does not die in the fight")
end

-- 2. A bad stretch in Ashenvale with the first raise in it: an orc shaman, his wife and a friend
--    fall, he raises her, then all three go down. The raise comes before the second fall; the
--    felt line points back to who taught him, told in an earlier chapter, and only then.
local function Ashenvale(bond, taught)
    local j = {}
    if taught then
        Stretch(j, At(0, 20), 60, "Durotar", 20, {{m = 10, k = "quest", d = "Call of Earth"}, {m = 30, k = "custom", text = "Seer Ragetotem taught me to call a spirit back from the dead, as the shaman of the Bluff do."}})
    end
    local t = At(2, 21)
    Stretch(j, t, 30, "Ashenvale", 24, {{m = 3, k = "pdeath", n = "Mira-Realm"}, {m = 3, k = "pdeath", n = "Tok-Realm"},
        {m = 4, k = "first", d = "rezother", n = "Mira"}, {m = 6, k = "pdeath", n = "Mira-Realm"}, {m = 6, k = "pdeath", n = "Tok-Realm"},
        {m = 6, k = "death", w = "you", d = "Ashenvale Bear"}, {m = 20, k = "quest", d = "Bathran's Hair"}})
    With(j, "mira", "Mira-Realm", t, 30); With(j, "tok", "Tok-Realm", t, 30)
    A.db.people.mira = {name = "Mira-Realm", class = "MAGE", race = "Orc", pronouns = "she", bond = bond}
    A.db.people.tok = {name = "Tok-Realm", class = "WARRIOR", race = "Troll"}
    return {self = true, charKey = "grak" .. bond .. tostring(taught), name = "Grak", race = "Orc", faction = "Horde", class = "SHAMAN", startLevel = 1, journal = j}
end
do
    local p = Ashenvale("spouse", false)
    Clean(p, {"Mira", "Tok"})
    for retell, chapters in pairs(Tellings(p)) do
        local one = chapters[1].plain
        check(Generic(one, "Ashenvale bear"), "a generic killer takes 'an' and a lowered kind word (" .. retell .. "): " .. one)
        check(one:find("first I ever", 1, true) or one:find("first time", 1, true) or one:find("For the first time", 1, true), "the first raise is told: " .. one)
        local raise = one:find("Mira", 1, true) and (one:find("rose", 1, true) or one:find("raised", 1, true) or one:find("back", 1, true))
        local lastFall = math.max(one:find("bear finished me") or 0, one:find("bear killed me") or 0, one:find("bear ended it") or 0)
        check(raise and lastFall > 0 and raise < lastFall, "the raise comes before the fall that followed it: " .. one)
        check(not one:find("taught me", 1, true), "no teacher told, no felt line: " .. one)
        check(Count(one, "Mira") <= 4, "Mira named a few times at most: " .. one)
    end
    A.db.people.mira, A.db.people.tok = nil, nil
    -- (the teacher, from an earlier chapter's plain text: the sentence that says "taught me" and
    -- the art, and the name in it or in the one before; nothing from an ordinary chapter)
    check(A.SelfTale.RaiseTeacher("When I returned from the vale, Danitha Morr judged me ready. She said the hearts of my own people were worth winning, and taught me redemption, to bring back fallen companions.") == "Danitha",
        "the teacher is named from the sentence before")
    check(A.SelfTale.RaiseTeacher("Seer Ragetotem taught me to call a spirit back from the dead.") == "Ragetotem", "a teacher with a title keeps the name")
    check(A.SelfTale.RaiseTeacher("Hadrec taught me patience. We killed Rot Hides until Nightlash came out.") == nil, "an ordinary lesson is no teacher")
    check(A.SelfTale.RaiseTeacher("Mira, my wife, was with me. I called the spirit of Mira back, the first I ever raised.") == nil, "a raise is no lesson")
    -- (a book whose earlier chapter told the lesson says so once, never last)
    local q = Ashenvale("spouse", true)
    local days = A.JournalBook(q)
    local told = A.SelfTale.Tell(q, days, false, 0)
    told[days[1].key].text = told[days[1].key].text .. " Seer Ragetotem taught me to call a spirit back from the dead."
    A.db.people.mira, A.db.people.tok = nil, nil
end

-- 3. Duskwood for a human warrior and her friend Lyra: Lyra falls twice before a Skeletal
--    Horror kills me, Lyra (as "Lyra Dawn" in the record) brings me back, then a Splinter
--    Fist Ogre takes us both. Lyra is told by her first name and is no stranger.
do
    local j = {}
    local t = At(0, 22)
    Stretch(j, t, 30, "Duskwood", 26, {{m = 1, k = "pdeath", n = "Lyra-Dawn"}, {m = 3, k = "pdeath", n = "Lyra-Dawn"},
        {m = 3, k = "death", w = "you", d = "Skeletal Horror"}, {m = 7, k = "rez", by = "Lyra Dawn", w = "them"},
        {m = 10, k = "death", w = "you", d = "Splinter Fist Ogre"}, {m = 11, k = "pdeath", n = "Lyra-Dawn"}})
    With(j, "lyra", "Lyra-Dawn", t, 30)
    A.db.people.lyra = {name = "Lyra-Dawn", class = "PRIEST", race = "Human", pronouns = "she", bond = "friend"}
    local p = {self = true, charKey = "edda", name = "Edda", race = "Human", faction = "Alliance", class = "WARRIOR", startLevel = 20, journal = j}
    Clean(p, {"Lyra"})
    for retell, chapters in pairs(Tellings(p)) do
        local one = chapters[1].plain
        check(one:find("twice", 1, true), "Lyra's two falls in one fight are a count (" .. retell .. "): " .. one)
        check(not one:find("Lyra Dawn", 1, true), "a friend by her first name: " .. one)
        check(one:find("Lyra brought me back", 1, true) or one:find("Lyra prayed me back", 1, true) or one:find("Lyra's prayers", 1, true)
            or one:find("Lyra raised me", 1, true), "Lyra's rescue, as a friend's: " .. one)
        check(Generic(one, "Skeletal horror") and Generic(one, "Splinter Fist ogre"), "generic killers take 'a' and a lowered kind word: " .. one)
        check(not one:find("I died t", 1, true) and not one:find("deaths in", 1, true), "two deaths need no count: " .. one)
    end
    A.db.people.lyra = nil
end

-- 4. A lone death stays one plain sentence, and a stranger stays a stranger: a tauren druid
--    killed by a Venture Co. Geologist in the Barrens, raised by someone of no list. A named
--    killer in another chapter stays bare.
do
    local j = {}
    Stretch(j, At(0, 20), 60, "The Barrens", 14, {{m = 10, k = "death", w = "you", d = "Venture Co. Geologist"}, {m = 13, k = "rez", by = "Ralph Cuthbridge", w = "them"},
        {m = 30, k = "quest", d = "Supplies for the Crossroads"}})
    Stretch(j, At(1, 20), 60, "The Barrens", 15, {{m = 10, k = "death", w = "you", d = "Owatanka"}, {m = 30, k = "quest", d = "Lost in Battle"}})
    local p = {self = true, charKey = "hulf", name = "Hulfnar", race = "Tauren", faction = "Horde", class = "DRUID", startLevel = 10, journal = j}
    Clean(p)
    for retell, chapters in pairs(Tellings(p)) do
        local one = chapters[1].plain
        check(Generic(one, "Venture Co. geologist"), "a generic killer with a company name takes 'a' and a lowered kind word (" .. retell .. "): " .. one)
        check(one:find("stranger", 1, true) or one:find("never met", 1, true), "a stranger's rescue: " .. one)
        check(not one:find("went badly", 1, true) and not one:find("finished us", 1, true) and not one:find("another matter", 1, true), "a lone death opens no passage: " .. one)
        local two = chapters[2].plain
        check(two:find("Owatanka", 1, true) and not Generic(two, "Owatanka"), "a named killer stays bare: " .. two)
    end
end

-- 5. A companion who fell twice, a quarter of an hour apart, with nothing else: one line with
--    the count. A companion's death in a city with nothing around it: not told.
do
    local j = {}
    local t = At(0, 20)
    Stretch(j, t, 60, "Hillsbrad Foothills", 30, {{m = 10, k = "pdeath", n = "Dahlia-Noir"}, {m = 25, k = "pdeath", n = "Dahlia-Noir"}, {m = 40, k = "quest", d = "Elixir of Suffering"}})
    With(j, "dahlia-noir", "Dahlia-Noir", t, 60)
    Stretch(j, At(1, 20), 60, "Undercity", 30, {{m = 5, k = "town", d = "Undercity"}, {m = 30, k = "pdeath", n = "Dahlia-Noir"}, {m = 50, k = "quest", d = "Wand to Bethor"}})
    With(j, "dahlia-noir", "Dahlia-Noir", At(1, 20), 60)
    Stretch(j, At(2, 20), 60, "Hillsbrad Foothills", 31, {{m = 10, k = "quest", d = "Battle of Hillsbrad"}, {m = 40, k = "pdeath", n = "Dahlia-Noir"}})
    With(j, "dahlia-noir", "Dahlia-Noir", At(2, 20), 60)
    A.db.people["dahlia-noir"] = {name = "Dahlia-Noir", class = "WARLOCK", race = "Scourge", pronouns = "she", bond = "spouse"}
    local p = {self = true, charKey = "alb", name = "Alberich", race = "Scourge", faction = "Horde", class = "PALADIN", startLevel = 1, journal = j}
    Clean(p, {"Dahlia"})
    for retell, chapters in pairs(Tellings(p)) do
        local one = chapters[1].plain
        check(one:find("Dahlia fell twice", 1, true) or one:find("Dahlia went down twice", 1, true), "her two falls are one line (" .. retell .. "): " .. one)
        check(not one:find("went badly", 1, true) and not one:find("finished us", 1, true), "the party's losses alone open no passage: " .. one)
        local two = chapters[2].plain
        check(not two:find("Dahlia was killed", 1, true) and not two:find("Dahlia fell", 1, true) and not two:find("Dahlia went down", 1, true) and not two:find("Dahlia died", 1, true),
            "a death in a city with nothing around it is not told: " .. two)
        local three = chapters[3].plain
        check(not three:find("Dahlia was killed", 1, true) and not three:find("Dahlia fell", 1, true) and not three:find("Dahlia died", 1, true),
            "a death half an hour from anything is not told: " .. three)
    end
    A.db.people["dahlia-noir"] = nil
end

-- 6. A long bad hour: five deaths of a night elf hunter in Stonetalon, two raises by two hands,
--    a companion down three times, a named killer last. The middle is not a roll call: at
--    most seven sentences from the signal to the count, the count once, the named foe bare.
do
    local j = {}
    -- (seven deaths before: the tenth of her life falls inside the bad hour, and is counted there)
    for d = 0, 6 do Stretch(j, At(d, 20), 30, "Darkshore", 15 + d, {{m = 10, k = "death", w = "you", d = "Moonstalker Runt"}, {m = 20, k = "quest", d = "Errand " .. d}}) end
    -- (a lone death earlier the same day: the stretch's first death is not the day's first)
    Stretch(j, At(8, 20), 30, "Darkshore", 22, {{m = 10, k = "death", w = "you", d = "Moonstalker Runt"}, {m = 20, k = "quest", d = "Errand 8"}})
    local t = At(8, 21)
    Stretch(j, t, 50, "Stonetalon Mountains", 22, {{m = 2, k = "death", w = "you", d = "Venture Co. Logger", sz = "Windshear Crag"},
        {m = 12, k = "death", w = "you", d = "Venture Co. Logger"}, {m = 12, k = "pdeath", n = "Kesh-Realm"}, {m = 13, k = "rez", by = "Oswin Harrow", w = "them"},
        {m = 22, k = "death", w = "you", d = "Venture Co. Deforester"}, {m = 23, k = "rez", by = "Kesh Realm", w = "them"},
        {m = 30, k = "death", w = "you", d = "Venture Co. Logger"}, {m = 31, k = "pdeath", n = "Kesh-Realm"},
        {m = 40, k = "death", w = "you", d = "Besseleth"}, {m = 40, k = "pdeath", n = "Kesh-Realm"}})
    With(j, "kesh", "Kesh-Realm", t, 50)
    A.db.people.kesh = {name = "Kesh-Realm", class = "DRUID", race = "NightElf", pronouns = "he", bond = "friend"}
    local p = {self = true, charKey = "faelyn", name = "Faelyn", race = "NightElf", faction = "Alliance", class = "HUNTER", startLevel = 15, journal = j}
    Clean(p, {"Kesh"})
    for retell, chapters in pairs(Tellings(p)) do
        local one = chapters[8].plain
        check(one:find("Besseleth ended it", 1, true) or one:find("Besseleth finished it", 1, true), "the named killer ends it, bare (" .. retell .. "): " .. one)
        local firstAt = one:find("Windshear Crag", 1, true) or one:find("went badly", 1, true) or one:find("nearly finished", 1, true)
        -- (reader G, and the coordinator: the second fight ends on the stranger's raise, told at its
        -- time; the two fights after it are one sentence, the company named once as "the Venture Co.",
        -- my deaths counted, Kesh's fall folded in, Kesh's raise a clause)
        local tallyAt, strangerAt = one:find("tenth time", 1, true) or one:find("Ten deaths", 1, true), one:find("Oswin Harrow", 1, true)
        local groupAt = one:find("twice more", 1, true) or one:find("Twice more", 1, true)
        check(firstAt and tallyAt and strangerAt and groupAt and firstAt < tallyAt and tallyAt < strangerAt and strangerAt < groupAt,
            "the tenth death is counted where it fell, the stranger's raise right after it, the fold after that: " .. one)
        check(one:find("Venture Co. killed me twice more", 1, true) or one:find("Twice more the Venture Co. killed me", 1, true), "the repeated killer named once, with the count: " .. one)
        check(one:find("Kesh with me, and Kesh raised me once", 1, true), "the companion's fall folded into it, his raise a clause: " .. one)
        check(not one:find("Five deaths", 1, true) and not one:find("five times", 1, true) and not one:find("deaths in", 1, true), "no second count at the end: " .. one)
        check(one:find("Oswin Harrow, a stranger", 1, true) or one:find("Oswin Harrow, whom I had never met", 1, true), "the stranger who raised me, by name: " .. one)
        check(one:find("Kesh raised me once", 1, true), "the friend who raised me, by first name, as a clause with its count: " .. one)
        check(Count(one, "Kesh with me") == 2, "Kesh's falls in the two fights before the last, each where it fell: " .. one)
        check(not one:find("got me first", 1, true) and not one:find("killed me first", 1, true) and not one:find("first to kill me", 1, true),
            "no 'first' when the day had a death before the stretch: " .. one)
        check(not one:find("walked back", 1, true) and not one:find("more I died", 1, true), "no walk and no second count: the group sentence carries the deaths: " .. one)
        check(not one:find("stood up only because", 1, true) and not one:find("someone stopped for me, or", 1, true), "the raises are not summed twice: " .. one)
        local from = one:find("Windshear Crag", 1, true) or one:find("went badly", 1, true) or one:find("nearly finished", 1, true) or 1
        local to = one:find("Besseleth", 1, true)
        local n = 1
        for _ in one:sub(from, to or #one):gmatch("%.%s+%u") do n = n + 1 end
        check(n <= 7, "a bad hour in seven sentences at most, the signal, the first fight, the second with its tally and the stranger, the two after as one, and the last: " .. one)
        check(Count(one, "Logger") + Count(one, "logger") <= 2 and Count(one, "Venture Co%.") <= 3, "the same kind of killer named twice at most, the company once more: " .. one)
    end
    A.db.people.kesh = nil
end

-- 7. Deterministic: the same retell tells the same passage twice over.
do
    local p = Ashenvale("spouse", false)
    local a = Tellings(p)[3][1].plain
    local b = Tellings(p)[3][1].plain
    check(a == b, "the same retell, the same words")
    A.db.people.mira, A.db.people.tok = nil, nil
end

print("PASS: " .. assertions .. " death passage assertions")
