-- Run from the client root: lua5.1 Interface/AddOns/CompanionJournal/tests/MomentsTell.lua [print]
-- The more moments, told: books and plaques, areas found, a flight path, spells
-- from a trainer, standings, duels, trade marks, honorable kills and a rare
-- killed, in your own words over every retell (0 to 7), in Everything and in
-- Highlights; and the ones a companion's chapter shares, in both voices.
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
local function Count(text, word) local n = 0 for _ in text:gmatch(word) do n = n + 1 end return n end
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
-- The rules every chapter keeps.
local META = {"journal", "tale", "story", "song", "verse", "record", "chronicle", "legend", "bard"}
local function Clean(p)
    for _, brief in ipairs({false, true}) do
        for retell, chapters in pairs(Tellings(p, brief)) do
            for _, c in ipairs(chapters) do
                check(not c.text:find("{%a+}"), "no raw token (" .. retell .. "): " .. c.text)
                check(not c.text:gsub("{%a:[^}]*}", ""):find(":", 1, true), "no colons: " .. c.plain)
                check(not c.plain:find("%?"), "no questions: " .. c.plain)
                for _, word in ipairs(META) do
                    check(not c.plain:gsub("{%a:[^}]*}", ""):lower():find("%f[%a]" .. word .. "%f[%A]") or c.plain:find("The Story of", 1, true),
                        "no meta word '" .. word .. "' (a book's own title aside): " .. c.plain)
                end
                check(not c.plain:find("  ", 1, true) and not c.plain:find(" %."), "clean spacing: " .. c.plain)
            end
        end
    end
end

-- 1. A reader and a wanderer: books and a stone, areas found, a flight path, the trainer.
do
    local j = {}
    Stretch(j, At(0, 19), 90, "Duskwood", 24, Join({{k = "town", d = "Darkshire"}, {k = "explore", d = "Raven Hill"}, {k = "explore", d = "The Rotting Orchard"},
        {k = "explore", d = "Brightwood Grove"}, {k = "explore", d = "Twilight Grove"}, {k = "explore", d = "Vul'Gol Ogre Mound"},
        {k = "read", d = "The Story of Morgan Ladimore", m = "parchment"}, {k = "read", d = "Grave of Tirion's Son", m = "stone"},
        {k = "taxi", d = "Darkshire"}}, Q({"The Legend of Stalvan"})))
    Stretch(j, At(1, 20), 60, "Stormwind City", 25, {{k = "town", d = "Stormwind City"}, {k = "learn", c = 4, m = {"Shadow Word: Pain", "Renew", "Inner Fire"}},
        {k = "read", d = "The Story of Morgan Ladimore", m = "parchment"}})
    Stretch(j, At(3, 20), 60, "Redridge Mountains", 25, {{k = "explore", d = "Lake Everstill"}, {k = "read", d = "Beyond the Dark Portal", m = "parchment"},
        {k = "read", d = "The Last Guardian", m = "parchment"}})
    local p = {self = true, charKey = "reader", name = "Elwin", race = "Human", faction = "Alliance", class = "PRIEST", startLevel = 1, journal = j}
    Clean(p)
    for retell, chapters in pairs(Tellings(p)) do
        local one = chapters[1].plain
        -- (2026-11-07: three named, no counter of the rest; the user found "six more places" log-speak)
        check(one:find("Raven Hill", 1, true) and one:find("Rotting Orchard", 1, true) and not one:find("other places", 1, true)
            and not one:find("more places", 1, true), "five areas: three named, no count (" .. retell .. "): " .. one)
        check(one:find("read The Story of Morgan Ladimore", 1, true) or one:find("The Story of Morgan Ladimore, and I read it", 1, true)
            or one:find("The Story of Morgan Ladimore and read it", 1, true), "the book read: " .. one)
        check(one:find("Grave of Tirion's Son", 1, true) and (one:find("cut into", 1, true) or one:find("written on it", 1, true) or one:find("inscription", 1, true)),
            "the stone read as a stone: " .. one)
        local flight = one:match("[^%.]*flight[^%.]*%.")
        check(flight and not flight:find("Darkshire", 1, true), "Darkshire already named: the flight path without it: " .. one)
        local two = chapters[2].plain
        -- (2026-11-07: the spells by name, without "and more" or a count; the user found it log-speak)
        check(two:find("Shadow Word: Pain, Renew and Inner Fire", 1, true) and not two:find("and more", 1, true) and not two:find("one more", 1, true),
            "the trainer's spells, named, nothing counted: " .. two)
        check(two:find("The Story of Morgan Ladimore again", 1, true) or two:find("Morgan Ladimore again, and read it once more", 1, true), "a book read again says so: " .. two)
        local three = chapters[3].plain
        check(three:find("Lake Everstill was new ground", 1, true) or three:find("found my way to Lake Everstill", 1, true) or three:find("came upon Lake Everstill", 1, true),
            "one area, singular: " .. three)
        check(three:find("Beyond the Dark Portal and The Last Guardian", 1, true), "two books in one line: " .. three)
    end
    for retell, chapters in pairs(Tellings(p, true)) do
        check(chapters[2].plain:find("Stormwind", 1, true), "Highlights keep the day's bearings (" .. retell .. "): " .. chapters[2].plain)
        check(not chapters[2].plain:find("trainer", 1, true), "Highlights leave the trainer out: " .. chapters[2].plain)
    end
end

-- 2. Standing with a faction, from friendly to exalted; a trade mastered.
do
    local j = {}
    Stretch(j, At(0, 20), 60, "Felwood", 52, Join({{k = "rep", d = "Timbermaw Hold", s = 5}}, Q({"Winterfall Activity"})))
    Stretch(j, At(2, 20), 60, "Western Plaguelands", 55, Join({{k = "rep", d = "Argent Dawn", s = 6}, {k = "skill", d = "First Aid", c = 225}}, Q({"Scholomance"})))
    Stretch(j, At(5, 20), 60, "Eastern Plaguelands", 58, Join({{k = "rep", d = "Argent Dawn", s = 8}, {k = "skill", d = "First Aid", c = 300}}, Q({"Scourgestones"})))
    local p = {self = true, charKey = "standing", name = "Kaelen", race = "Dwarf", faction = "Alliance", class = "PALADIN", startLevel = 1, journal = j}
    Clean(p)
    for retell, chapters in pairs(Tellings(p)) do
        check(chapters[1].plain:find("Timbermaw Hold", 1, true) and (chapters[1].plain:find("friend", 1, true) or chapters[1].plain:find("good standing", 1, true)),
            "friendly with Timbermaw Hold (" .. retell .. "): " .. chapters[1].plain)
        check(chapters[2].plain:find("the Argent Dawn", 1, true) or chapters[2].plain:find("The Argent Dawn", 1, true), "the Argent Dawn takes its article: " .. chapters[2].plain)
        check(chapters[2].plain:find("honor", 1, true), "honored: " .. chapters[2].plain)
        check(chapters[2].plain:find("expert at first aid", 1, true) or chapters[2].plain:find("first aid had reached an expert's", 1, true), "an expert's first aid: " .. chapters[2].plain)
        local three = chapters[3].plain
        check(three:find("no higher standing", 1, true) or three:find("highest standing", 1, true) or three:find("as high with", 1, true), "exalted: " .. three)
        check(three:find("nothing more anyone could teach me of first aid", 1, true) or three:find("anything left to teach me of first aid", 1, true)
            or three:find("a bandage left to teach me", 1, true) or three:find("first aid had reached three hundred", 1, true), "first aid mastered: " .. three)
        check(chapters[3].title == "Argent Dawn" or chapters[3].title == "First Aid", "titled for the standing or the trade: " .. tostring(chapters[3].title))
    end
end

-- 3. Duels, honorable kills and a rare killed; the first win and the tally share one stretch.
do
    local j = {}
    Stretch(j, At(0, 20), 60, "Hillsbrad Foothills", 30, Join({{k = "duel", d = "Dahlia", w = "won"}, {k = "town", d = "Tarren Mill"}}, Q({"Battle of Hillsbrad"})))
    Stretch(j, At(1, 20), 90, "Hillsbrad Foothills", 31, {{k = "first", d = "pvp", z = "Hillsbrad Foothills"}, {k = "hk", c = 3}, {k = "death", w = "you", pr = "Human", pc = "Paladin"}})
    Stretch(j, At(3, 20), 60, "Arathi Highlands", 33, Join({{k = "first", d = "rarebeast", z = "Foulbelly", sz = "Arathi Highlands"}, {k = "rarekill", d = "Foulbelly", sz = "Arathi Highlands"},
        {k = "hk", c = 1}}, Q({"Hammerfall"})))
    Stretch(j, At(4, 20), 60, "Arathi Highlands", 33, {{k = "duel", d = "Dahlia", w = "lost"}, {k = "duel", d = "Dahlia", w = "won"}, {k = "duel", d = "Dahlia", w = "won"},
        {k = "duel", d = "Grak", w = "lost", fled = true}})
    local p = {self = true, charKey = "duellist", name = "Alberich", race = "Scourge", faction = "Horde", class = "PALADIN", startLevel = 1, journal = j}
    Clean(p)
    for retell, chapters in pairs(Tellings(p)) do
        local one = chapters[1].plain
        check(one:find("Dahlia", 1, true) and one:find("duel", 1, true) and (one:find("won", 1, true) or one:find("went my way", 1, true) or one:find("beat Dahlia", 1, true)),
            "a duel won (" .. retell .. "): " .. one)
        local two = chapters[2].plain
        check(two:find("first", 1, true) and (two:find("three of them", 1, true) or two:find("Three of them", 1, true)), "the first win, then the day's count: " .. two)
        check(not two:find("Three of the Alliance fell to me", 1, true), "no second count beside the first: " .. two)
        local three = chapters[3].plain
        check(three:find("Foulbelly", 1, true) and (three:find("killed", 1, true) or three:find("brought down", 1, true)), "the rare killed: " .. three)
        check(Count(three, "Foulbelly") == 1, "the sighting goes without saying: " .. three)
        check(three:find("One of the Alliance", 1, true) or three:find("one of the Alliance", 1, true), "one honorable kill, in words: " .. three)
        local four = chapters[4].plain
        check(four:find("three times", 1, true) and four:find("two of them", 1, true) or four:find("won two", 1, true), "three duels with Dahlia in one line: " .. four)
        check(four:find("Grak", 1, true) and (four:find("left the ring", 1, true) or four:find("out of bounds", 1, true)), "a duel lost by leaving the ring: " .. four)
        check(four:find("three to one", 1, true) or four:find("Three to one", 1, true), "the running count with Dahlia (" .. retell .. "): " .. four)
    end
    for retell, chapters in pairs(Tellings(p, true)) do
        check(chapters[1].plain:find("duel", 1, true), "Highlights keep a duel (" .. retell .. "): " .. chapters[1].plain)
        check(chapters[3].plain:find("Foulbelly", 1, true), "Highlights keep the rare: " .. chapters[3].plain)
    end
end

-- 4. Shared with a companion: a duel against her, a rare killed and a standing while together, both voices.
do
    local me = {self = true, charKey = "alb", name = "Alberich", race = "Scourge", faction = "Horde", class = "PALADIN", startLevel = 1, journal = {}}
    local dahlia = {name = "Dahlia-Noir", class = "WARLOCK", race = "Scourge", pronouns = "she", journal = {}, bond = "spouse"}
    A.db.people["dahlia-noir"] = dahlia
    local t = At(0, 20)
    me.journal[#me.journal + 1] = {k = "play", t = t, e = t + 5400, z = "Hillsbrad Foothills", pl = 30}
    me.journal[#me.journal + 1] = {k = "with", d = "dahlia-noir", n = "Dahlia-Noir", t = t, e = t + 5400}
    me.journal[#me.journal + 1] = {k = "duel", d = "Dahlia", w = "lost", t = t + 600, z = "Hillsbrad Foothills"}
    me.journal[#me.journal + 1] = {k = "rarekill", d = "Foulbelly", sz = "Hillsbrad Foothills", t = t + 1800, z = "Hillsbrad Foothills"}
    me.journal[#me.journal + 1] = {k = "rep", d = "Undercity", s = 6, t = t + 2400, z = "Hillsbrad Foothills"}
    dahlia.journal[#dahlia.journal + 1] = {k = "group", t = t, e = t + 5400, z = "Hillsbrad Foothills", pl = 30, ol = 30}
    dahlia.journal[#dahlia.journal + 1] = {k = "quest", d = "Battle of Hillsbrad", t = t + 3000, z = "Hillsbrad Foothills"}
    -- (she died twice, with no boss to tell it with: one line, with the count)
    dahlia.journal[#dahlia.journal + 1] = {k = "death", w = "them", t = t + 3300, z = "Hillsbrad Foothills"}
    dahlia.journal[#dahlia.journal + 1] = {k = "death", w = "them", t = t + 3900, z = "Hillsbrad Foothills"}
    A.SelfPerson = function() return me end
    local player = {name = "Alberich", race = "Scourge", faction = "Horde", class = "PALADIN", charKey = "alb"}
    for _, voice in ipairs({"you", "we"}) do
        for retell = 0, 7 do
            dahlia.retell = retell
            local days = A.JournalBook(dahlia)
            local stories = A.JournalTale.Tell(dahlia, days, voice, player, false)
            local text = A.JournalPlain(stories[days[1].key].text)
            if show and retell == 0 then print(("[with Dahlia, %s]\n%s\n"):format(voice, text)) end
            check(text:find("duel", 1, true) and text:find("Dahlia won", 1, true), "the duel against her, and she won (" .. voice .. " " .. retell .. "): " .. text)
            check(not text:find("I lost", 1, true) and not text:find("you lost", 1, true), "told once, as her win: " .. text)
            check(text:find("Foulbelly", 1, true), "the rare killed while together: " .. text)
            check(not text:find("Undercity", 1, true) or text:find("honor", 1, true), "a standing, if kept, is the honored one: " .. text)
            check(not text:find("{%a+}"), "no raw token: " .. text)
            check(text:lower():find("twice", 1, true) and not text:find("died there and", 1, true) and not text:find("died there%. Dahlia"),
                "her two deaths in one line, with the count: " .. text)
            if voice == "we" then check(not text:find("%f[%a][Yy]ou%f[%A]"), "the diary never says you: " .. text) end
        end
    end
    A.db.people["dahlia-noir"] = nil
end

-- 5. In the order it happened (2026-11-09): a rare seen at the start of the evening is told
-- before the day's work, and the hour you stopped closes the chapter. It used to follow
-- "Midnight came and went before you stopped".
do
    local me = {self = true, charKey = "alb", name = "Alberich", race = "Scourge", faction = "Horde", class = "PALADIN", startLevel = 1, journal = {}}
    local dahlia = {name = "Dahlia-Noir", class = "WARLOCK", race = "Scourge", pronouns = "she", journal = {}, bond = "spouse"}
    A.db.people["dahlia-noir"] = dahlia
    local t = At(2, 22)
    me.journal[#me.journal + 1] = {k = "play", t = t, e = t + 4 * 3600, z = "Tirisfal Glades", pl = 12}
    me.journal[#me.journal + 1] = {k = "with", d = "dahlia-noir", n = "Dahlia-Noir", t = t, e = t + 4 * 3600}
    me.journal[#me.journal + 1] = {k = "first", d = "rarebeast", z = "Sri'skulk", sz = "Tirisfal Glades", t = t + 600, pl = 12}
    dahlia.journal[#dahlia.journal + 1] = {k = "group", t = t, e = t + 4 * 3600, z = "Tirisfal Glades", pl = 12, ol = 12}
    dahlia.journal[#dahlia.journal + 1] = {k = "death", w = "them", t = t + 1800, z = "Tirisfal Glades"}
    dahlia.journal[#dahlia.journal + 1] = {k = "quest", d = "Rear Guard Patrol", t = t + 2400, z = "Tirisfal Glades"}
    A.SelfPerson = function() return me end
    local player = {name = "Alberich", race = "Scourge", faction = "Horde", class = "PALADIN", charKey = "alb"}
    local lateSeen = 0
    for _, voice in ipairs({"you", "we"}) do
        for retell = 0, 7 do
            dahlia.retell = retell
            local days = A.JournalBook(dahlia)
            local stories = A.JournalTale.Tell(dahlia, days, voice, player, false)
            local text = A.JournalPlain(stories[days[1].key].text)
            if show and retell == 0 then print(("[in order, %s]\n%s\n"):format(voice, text)) end
            local rare = text:find("Sri'skulk", 1, true)
            local died = text:find("died", 1, true) or text:find("fell", 1, true) or text:find("killed", 1, true) or text:find("got the better", 1, true)
            check(rare, "the rare seen together is told (" .. voice .. " " .. retell .. "): " .. text)
            check(not died or rare < died, "the rare, seen first, comes before the death (" .. voice .. " " .. retell .. "): " .. text)
            local late = text:find("midnight", 1, true)
            if late then
                lateSeen = lateSeen + 1
                check(not text:sub(late):find("%.%s+%S"), "the hour you stopped is the last line (" .. voice .. " " .. retell .. "): " .. text)
            end
        end
    end
    check(lateSeen > 0, "a late night is told in some telling")
    A.db.people["dahlia-noir"] = nil
end

io.write("PASS: " .. assertions .. " more-moment telling assertions\n")
