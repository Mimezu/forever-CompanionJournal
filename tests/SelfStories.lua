-- Run from the client root: lua5.1 Interface/AddOns/CompanionJournal/tests/SelfStories.lua [print]
-- Your own journal over whole lives: a first page by race, a first death, a
-- reunion, a quiet day ending on a sunset, a clumsy day, a raid night, the
-- first sight of a capital and of the other side, a guild, a home, a
-- battleground, level sixty looking back. Every telling (0 to 7) is checked.
local root = "Interface/AddOns/CompanionJournal/"
local assertions = 0
local function check(value, message) assertions = assertions + 1; assert(value, message) end
local show = arg and arg[1] == "print"

function time(t) if type(t) == "table" then return os.time(t) end return 1790000000 + 40 * 86400 end
function date(fmt, t) return os.date(fmt, t) end
local A = {defaults = {colors = {}}}
for _, file in ipairs({"LoreData.lua", "Lore.lua", "JournalBook.lua", "JournalSelfWords.lua", "JournalSelfTale.lua"}) do
    assert(loadfile(root .. file))("CompanionJournal", A)
end
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
-- Every telling of a life: {retell = {chapters in order: {plain, title}}}.
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
                if show and retell == 0 then print(("[%s] %s\n%s\n"):format(p.name, tostring(s.title), A.JournalPlain(s.text))) end
            end
        end
        all[retell] = chapters
    end
    return all
end
local function Count(text, word) local n = 0 for _ in text:gmatch(word) do n = n + 1 end return n end
-- The rules for every chapter of every life.
local function Clean(p)
    for _, brief in ipairs({false, true}) do
        for retell, chapters in pairs(Tellings(p, brief)) do
            local titles = {}
            for n, c in ipairs(chapters) do
                check(not c.text:find("{%a+}"), "no raw token: " .. c.text)
                check(not c.plain:find(" were back out", 1, true) or c.plain:find("We were back out", 1, true) or c.plain:find("we were back out", 1, true),
                    "I was, not I were: " .. c.plain)
                -- "Dahlia and I were" is a plural subject, not singular "I were".
                check(not c.plain:gsub(" and I were", " and we were"):find("I were", 1, true), "never singular 'I were': " .. c.plain)
                check(not c.plain:find("spent after", 1, true) and not c.plain:find("spent on ", 1, true) and not c.plain:find("later in ", 1, true),
                    "no 'I spent after a week away': " .. c.plain)
                check(not c.plain:find("one weeks", 1, true) and not c.plain:find("one months", 1, true), "no 'one weeks': " .. c.plain)
                check(not c.text:gsub("{%a:[^}]*}", ""):find(":", 1, true), "no colons (names aside): " .. c.plain)
                check(not c.plain:find(", [A-Z][a-z]+ the first time", 1) and not c.plain:find("later, For", 1, true), "no capital after a comma: " .. c.plain)
                check(not c.plain:find("found me in", 1, true), "no 'Tuesday found me in': " .. c.plain)
                check(Count(c.plain:lower(), "for the first time") <= 2, "'for the first time' at most twice a chapter: " .. c.plain)
                if not brief and n > 1 then
                    check(not titles[c.title or "?"], "chapter titles differ (" .. retell .. "): " .. tostring(c.title))
                end
                titles[c.title or "?"] = true
            end
        end
    end
end

-- 1. A Forsaken rises: the first page is Deathknell, said once; the first death.
do
    local j = {}
    Stretch(j, At(0, 19), 60, "Tirisfal Glades", 1, Join({{k = "town", d = "Deathknell"}}, Q({"Rude Awakening", "The Mindless Ones"}), {{k = "mylevel", d = 3}}))
    Stretch(j, At(1, 20), 90, "Tirisfal Glades", 4, Join({{k = "cave", d = "Agamand Mills Mine"},
        {k = "death", w = "you", d = "Rot Hide Gnoll", a = true, sz = "Agamand Mills Mine"}}, Q({"Graverobbers"})))
    Stretch(j, At(2, 20), 60, "Tirisfal Glades", 5, {{k = "death", w = "you", d = "Scarlet Warrior", a = true}, {k = "rez", by = "Nobody"}})
    local p = {self = true, charKey = "m", name = "Mordren", race = "Scourge", faction = "Horde", class = "WARRIOR", startLevel = 1, journal = j}
    Clean(p)
    for retell, chapters in pairs(Tellings(p)) do
        local one = chapters[1].plain
        check(one:find("Deathknell", 1, true) and Count(one, "Deathknell") <= 2 and not one:find("came to Deathknell", 1, true) and not one:find("stopped in Deathknell", 1, true), "the first page begins where the Forsaken rise; no town line after it (" .. retell .. "): " .. one)
        check(chapters[2].plain:find("died once before", 1, true) or chapters[2].plain:find("since I rose", 1, true) or chapters[2].plain:find("second death", 1, true)
            or chapters[2].plain:find("nothing new", 1, true) or chapters[2].plain:find("dead before", 1, true),
            "a Forsaken's first death, as a Forsaken would see it: " .. chapters[2].plain)
        check(not chapters[3].plain:find("died once before", 1, true) and not chapters[3].plain:find("first death", 1, true) and not chapters[3].plain:find("second death", 1, true), "only the first is the first")
    end
end

-- 2. A quiet day: a new zone, herbs by name, towns, and the sunset last.
do
    local j = {}
    Stretch(j, At(0, 17), 70, "Stranglethorn Vale", 34, {{k = "first", d = "zone", z = "Stranglethorn Vale"},
        {k = "gather", d = "herbs", c = 23, m = {"Liferoot", "Kingsblood"}}, {k = "town", d = "Grom'gol Base Camp"}})
    Stretch(j, At(0, 18, 20), 60, "Stranglethorn Vale", 34, {{k = "town", d = "Booty Bay"}, {k = "first", d = "sunset", z = "The Savage Coast"},
        {k = "gather", d = "herbs", c = 11}})
    local p = {self = true, charKey = "z", name = "Zanji", race = "Troll", faction = "Horde", class = "SHAMAN", startLevel = 5, journal = j}
    Clean(p)
    for retell, chapters in pairs(Tellings(p)) do
        local c = chapters[1].plain
        local sun = c:find("sun go", 1, true) or c:find("sun went", 1, true)
        check(sun and c:find("herbs", 1, true) < sun and c:find("Booty Bay", 1, true) < sun, "the day ends on its sunset (" .. retell .. "): " .. c)
        check(not c:find("honest work", 1, true) and not c:find("my trades", 1, true), "a quiet day, not a working one: " .. c)
        check(c:find("quiet", 1, true) or c:find("no errands", 1, true) or c:find("nowhere I had to be", 1, true) or c:find("nobody asked", 1, true),
            "the pace of it is said: " .. c)
        check(chapters[1].title == "The Sun Goes Down" or chapters[1].title == "Sunset", "titled for the sunset: " .. tostring(chapters[1].title))
    end
end

-- 3. A clumsy day: two falls, told once with the count; a close call in the water.
do
    local j = {}
    Stretch(j, At(0, 20), 90, "Thousand Needles", 27, {{k = "death", w = "you", env = "FALLING"}, {k = "quest", d = "Hypercapacitor Gizmo"},
        {k = "close", env = "DROWNING"}, {k = "death", w = "you", env = "FALLING"}})
    local p = {self = true, charKey = "g", name = "Grishka", race = "Orc", faction = "Horde", class = "HUNTER", startLevel = 3, journal = j}
    Clean(p)
    for retell, chapters in pairs(Tellings(p)) do
        local c = chapters[1].plain
        check(c:find("twice", 1, true) or c:find("Twice", 1, true), "the same fall twice, counted (" .. retell .. "): " .. c)
        check(Count(c, "fell to my death") + Count(c, "misjudged a drop") == 1, "told once: " .. c)
    end
end

-- 4. Shared records two months apart establish company and place, not absence.
do
    local j = {}
    Stretch(j, At(0, 20), 90, "Silverpine Forest", 16, Q({"Arugal's Folly"}))
    j[#j + 1] = {k = "with", d = "dahlia-noir", n = "Dahlia-Noir", t = At(0, 20), e = At(0, 21, 30)}
    Stretch(j, At(62, 20), 60, "Arathi Highlands", 34, Q({"Call to Arms"}))
    j[#j + 1] = {k = "with", d = "dahlia-noir", n = "Dahlia-Noir", t = At(62, 20), e = At(62, 21)}
    local p = {self = true, charKey = "a", name = "Alberich", race = "Scourge", faction = "Horde", class = "PALADIN", startLevel = 1, journal = j}
    Clean(p)
    for retell, chapters in pairs(Tellings(p)) do
        local c = chapters[2].plain
        check(c:find("Dahlia", 1, true) and c:find("Arathi", 1, true), "recorded company and place retained (" .. retell .. "): " .. c)
        check(not c:find("apart", 1, true) and not c:find("away", 1, true)
            and Count(c:lower(), "two months") + Count(c:lower(), "nine weeks") <= 1, "no invented or repeated absence: " .. c)
    end
end

-- 5. A raid night: Molten Core said once, Benediction once, "we" for the kills.
do
    local j = {}
    Stretch(j, At(0, 20), 150, "Molten Core", 60, {{k = "first", d = "raid", z = "Molten Core"}, {k = "dungeon", d = "Molten Core", r = "healer"},
        {k = "boss", d = "Lucifron", n = 40}, {k = "boss", d = "Magmadar", n = 40}, {k = "first", d = "famous", z = "Benediction"},
        {k = "first", d = "legendary", z = "Benediction"}})
    local p = {self = true, charKey = "r", name = "Aelwyn", race = "Human", faction = "Alliance", class = "PRIEST", startLevel = 58, journal = j}
    Clean(p)
    for retell, chapters in pairs(Tellings(p)) do
        local c = chapters[1].plain
        check(Count(c, "went into Molten Core") + Count(c, "made for Molten Core") + Count(c, "set out for Molten Core") <= 1, "going in, said once (" .. retell .. "): " .. c)
        check(Count(c, "Benediction") == 1, "Benediction once: " .. c)
        check(not c:find("I killed", 1, true), "forty of us: 'we', not 'I': " .. c)
        check(c:find("Anathema", 1, true), "what Benediction is: " .. c)
    end
end

-- 6. A human's first weeks: a capital, a guild, a home, the other side, a battleground.
do
    local j = {}
    Stretch(j, At(0, 18), 70, "Elwynn Forest", 1, Join({{k = "town", d = "Northshire Abbey"}}, Q({"A Threat Within"}), {{k = "first", d = "rare", z = "Soft Fur-lined Shoes"}}))
    Stretch(j, At(1, 19), 90, "Elwynn Forest", 6, {{k = "town", d = "Goldshire"}, {k = "home", d = "Goldshire"},
        {k = "death", w = "you", d = "Hogger"}, {k = "rez", by = "Thandrel"}})
    Stretch(j, At(2, 20), 60, "Stormwind City", 9, {{k = "town", d = "Stormwind City"}, {k = "guild", d = "Knights of Ember"}, {k = "first", d = "class", z = "voidwalker"}})
    Stretch(j, At(4, 20), 80, "Redridge Mountains", 16, {{k = "first", d = "foeseen", z = "Redridge Mountains", n = "Orc", c = "Warrior"},
        {k = "death", w = "you", pr = "Undead", pc = "Rogue"}, {k = "death", w = "you", pr = "Undead", pc = "Rogue"}})
    Stretch(j, At(5, 21), 40, "Warsong Gulch", 18, {{k = "first", d = "battleground", z = "Warsong Gulch"}, {k = "bg", d = "Warsong Gulch"}})
    local p = {self = true, charKey = "e", name = "Edric", race = "Human", faction = "Alliance", class = "WARLOCK", startLevel = 1, journal = j}
    Clean(p)
    for retell, chapters in pairs(Tellings(p)) do
        check(chapters[1].plain:find("Northshire", 1, true) and chapters[1].plain:find("Soft Fur-lined Shoes", 1, true), "the first page and the first find (" .. retell .. ")")
        local two = chapters[2].plain
        check((two:find("hearthstone", 1, true) or two:find("my home", 1, true)) and two:find("Hogger", 1, true) and (two:find("Half of Elwynn", 1, true) or two:find("Dughan", 1, true) or two:find("Hogger", 1, true) and two:find(" him", 1, true)), "home, and Hogger: " .. two)
        check((two:find("stranger", 1, true) or two:find("never met", 1, true)) and not two:find("spirit healer", 1, true), "a stranger brought me back, so no corpse run: " .. two)
        local three = chapters[3].plain
        check(three:find("Stormwind", 1, true) and three:find("Knights of Ember", 1, true) and three:find("voidwalker", 1, true), "a capital, a guild, a voidwalker: " .. three)
        local four = chapters[4].plain
        check(four:find("orc warrior", 1, true) and four:find("undead rogue", 1, true) and (four:find("again", 1, true)), "the other side, seen and met: " .. four)
        local five = chapters[5].plain
        check(Count(five, "Warsong Gulch") == 1, "a battleground, said once: " .. five)
    end
end

-- 7. Level sixty, looking back, with the one who was there most.
do
    local j = {}
    local many = {}
    for n = 1, 24 do many[n] = "Errand " .. n end
    Stretch(j, At(0, 19), 60, "Tirisfal Glades", 1, Q(many))
    j[#j + 1] = {k = "with", d = "dahlia-noir", n = "Dahlia-Noir", t = At(0, 19), e = At(0, 22)}
    Stretch(j, At(80, 20), 120, "Eastern Plaguelands", 59, Join(Q({"Demon Dogs"}), {{k = "mylevel", d = 60}}))
    local p = {self = true, charKey = "k", name = "Krosh", race = "Scourge", faction = "Horde", class = "WARRIOR", startLevel = 1, journal = j}
    Clean(p)
    for retell, chapters in pairs(Tellings(p)) do
        local c = chapters[#chapters].plain
        check(c:find("sixty", 1, true) and c:find("Deathknell", 1, true) and (c:find("months", 1, true) or c:find("weeks", 1, true)),
            "sixty, looking back to where it began (" .. retell .. "): " .. c)
        check(c:find("Dahlia", 1, true), "and who was there: " .. c)
    end
end

-- 8. Small wonders, told: snow, a rare creature, a swim, a night flight and no
-- move line after it, a night at the inn, a first sale, fishing from a dock.
do
    local j = {}
    Stretch(j, At(0, 19), 90, "Alterac Mountains", 30, {{k = "first", d = "snow", z = "Alterac Mountains"},
        {k = "first", d = "rarebeast", z = "Gravis Slipknot", sz = "Alterac Mountains"}, {k = "quest", d = "Frostmaw"}})
    Stretch(j, At(0, 20, 40), 60, "Hillsbrad Foothills", 30, {{k = "swim", d = "Lordamere Lake"}, {k = "town", d = "Tarren Mill"},
        {k = "sleep", d = "Tarren Mill"}})
    Stretch(j, At(1, 21), 30, "Hillsbrad Foothills", 30, {{k = "nightflight"}})
    Stretch(j, At(1, 21, 35), 50, "Stranglethorn Vale", 30, {{k = "town", d = "Booty Bay"},
        {k = "gather", d = "fishing", c = 9, sz = "Booty Bay"}, {k = "first", d = "aucsale", z = "Heavy Silk Bandage"}})
    local p = {self = true, charKey = "w", name = "Kesh", race = "Troll", faction = "Horde", class = "ROGUE", startLevel = 1, journal = j}
    Clean(p)
    local slept, swum = 0, 0
    for retell, chapters in pairs(Tellings(p)) do
        local one, two = chapters[1].plain, chapters[2].plain
        check(one:find("snow", 1, true) and one:find("Gravis Slipknot", 1, true), "snow and the rare creature (" .. retell .. "): " .. one)
        check(Count(one, "Alterac Mountains") <= 2, "the zone not said over and over: " .. one)
        if one:find("slept", 1, true) or one:find("a bed for me", 1, true) then slept = slept + 1 end
        if one:find("swam", 1, true) or one:find("swim", 1, true) then swum = swum + 1 end
        check(two:find("after dark", 1, true) or two:find("by night", 1, true) or two:find("night", 1, true) or two:find("dark", 1, true), "the flight by night: " .. two)
        check(Count(two, "Stranglethorn Vale") == 1, "the flight says where it went, and no move line after it: " .. two)
        check(two:find("Heavy Silk Bandage", 1, true) and two:find("nine fish", 1, true), "the sale and the fishing: " .. two)
    end
    check(slept >= 4, "a night at the inn, most tellings: " .. slept)
    check(swum >= 4, "the swim, most tellings: " .. swum)
end

-- 9. Round 8: someone met for the first time is introduced; the warhorse is the
-- first mount (one line); a sunset at Ratchet is not "into the sea"; a lost fight
-- and your death in it are told once; ore is smelted into bars.
do
    A.db = {people = {tarok = {name = "Tarok-Forever", race = "Tauren", class = "WARRIOR"}}}
    LOCALIZED_CLASS_NAMES_MALE = {WARRIOR = "Warrior"}
    local j = {}
    Stretch(j, At(0, 20), 90, "The Barrens", 14, {{k = "quest", d = "Raptor Thieves"}})
    j[#j + 1] = {k = "with", d = "tarok", n = "Tarok-Forever", t = At(0, 20), e = At(0, 21, 30)}
    Stretch(j, At(1, 19), 60, "The Barrens", 15, {{k = "town", d = "Ratchet"}, {k = "first", d = "sunset", z = "Ratchet"}})
    Stretch(j, At(2, 20), 90, "The Deadmines", 18, {{k = "dungeon", d = "The Deadmines"}, {k = "wipe", d = "Mr. Smite"},
        {k = "death", w = "you", d = "Mr. Smite", boss = "Mr. Smite"}, {k = "boss", d = "Mr. Smite", n = 5}})
    Stretch(j, At(3, 20), 60, "Ironforge", 40, {{k = "first", d = "class", z = "warhorse"}, {k = "first", d = "mount"},
        {k = "craft", d = "Mining", c = 6, m = {"Copper Bar"}}})
    local p = {self = true, charKey = "r8", name = "Thorgrim", race = "Dwarf", faction = "Alliance", class = "PALADIN", startLevel = 1, journal = j}
    Clean(p)
    for retell, chapters in pairs(Tellings(p)) do
        check(chapters[1].plain:find("Tarok, a tauren warrior", 1, true), "who Tarok is, the first time (" .. retell .. "): " .. chapters[1].plain)
        local two = chapters[2].plain
        check(not two:find("into the sea", 1, true) and not two:find("over the sea at", 1, true), "Ratchet faces east: " .. two)
        local three = chapters[3].plain
        check(Count(three, "Smite") <= 2, "the lost fight and the death in it, told once: " .. three)
        local four = chapters[4].plain
        check(Count(four:lower(), "mount") + Count(four:lower(), "warhorse") <= 2 and not four:find("rode my own mount", 1, true), "the warhorse is the mount: " .. four)
        check(not four:find("bars of Copper Bar", 1, true), "bars of copper: " .. four)
    end
    A.db = nil
end

-- 10. Round 8 hooks: the first zone beyond home; a newcomer joining friends; the
-- party's deaths told with the boss that killed them; a lost fight, then the win.
do
    A.db = {people = {morwen = {name = "Morwen-Forever", race = "Scourge", class = "MAGE"},
        tarok = {name = "Tarok-Forever", race = "Tauren", class = "WARRIOR"}}}
    LOCALIZED_CLASS_NAMES_MALE = {WARRIOR = "Warrior", MAGE = "Mage"}
    local j = {}
    Stretch(j, At(0, 19), 60, "Durotar", 1, {{k = "quest", d = "Sarkoth"}})
    Stretch(j, At(1, 19), 60, "The Barrens", 12, {{k = "first", d = "zone", z = "The Barrens"}, {k = "quest", d = "Raptor Thieves"}})
    Stretch(j, At(2, 19), 60, "The Barrens", 14, {{k = "quest", d = "Serpentbloom"}})
    j[#j + 1] = {k = "with", d = "morwen", n = "Morwen-Forever", t = At(2, 19), e = At(2, 20)}
    Stretch(j, At(3, 19), 30, "The Barrens", 16, {})
    j[#j + 1] = {k = "with", d = "morwen", n = "Morwen-Forever", t = At(3, 19), e = At(3, 22)}
    j[#j + 1] = {k = "with", d = "tarok", n = "Tarok-Forever", t = At(3, 19), e = At(3, 22)}
    Stretch(j, At(3, 19, 32), 100, "Wailing Caverns", 16, {{k = "dungeon", d = "Wailing Caverns"}, {k = "boss", d = "Lady Anacondra", n = 5},
        {k = "pdeath", n = "Morwen-Forever", boss = "Skum"}, {k = "pdeath", n = "Tarok-Forever", boss = "Skum"}, {k = "boss", d = "Skum", n = 5},
        {k = "wipe", d = "Lord Pythas"}, {k = "boss", d = "Lord Pythas", n = 5}, {k = "boss", d = "Mutanus the Devourer", n = 5}})
    local p = {self = true, charKey = "r8b", name = "Zuni", race = "Troll", faction = "Horde", class = "HUNTER", startLevel = 1, journal = j}
    Clean(p)
    for retell, chapters in pairs(Tellings(p)) do
        local two = chapters[2].plain
        check(two:find("Durotar", 1, true) or two:find("first time", 1, true) or two:find("somewhere new", 1, true) or two:find("behind me", 1, true),
            "the first zone beyond home (" .. retell .. "): " .. two)
        local four = chapters[4].plain
        check(four:find("Tarok, a tauren warrior", 1, true) and Count(four, "Morwen") <= 3, "a newcomer among friends: " .. four)
        check(four:find("Skum killed Morwen and Tarok", 1, true) or four:find("Morwen and Tarok died", 1, true) or four:find("killed Morwen and Tarok", 1, true),
            "the party's deaths, with their killer: " .. four)
        check(Count(four, "Pythas") <= 1, "a lost fight and the win, one line: " .. four)
    end
    A.db = nil
end

-- 11. Round 9: a level reached before the day's last turn-in; a mount after the
-- level that bought it; a friend's rez by their class; "we" only once named.
do
    A.db = {people = {grosh = {name = "Grosh-Forever", race = "Orc", class = "SHAMAN"}}}
    LOCALIZED_CLASS_NAMES_MALE = {SHAMAN = "Shaman"}
    local j = {}
    Stretch(j, At(0, 19), 60, "The Barrens", 15, {{k = "quest", d = "Raptor Thieves"}})
    j[#j + 1] = {k = "with", d = "grosh", n = "Grosh-Forever", t = At(0, 19), e = At(0, 20)}
    -- day 1: the level at seven, the quests at eight
    Stretch(j, At(1, 19), 50, "The Barrens", 16, {{k = "mylevel", d = 17}})
    Stretch(j, At(1, 20), 40, "The Barrens", 17, Q({"Leaders of the Fang", "Smart Drinks"}))
    -- day 2: a mount, then level 40 (told the other way round)
    Stretch(j, At(2, 19), 60, "Orgrimmar", 39, {{k = "first", d = "mount"}, {k = "mylevel", d = 40}})
    -- day 3: with Grosh all along, one quest; a death and his rez
    Stretch(j, At(3, 19), 90, "The Barrens", 40, {{k = "death", d = "Bristleback Interloper", a = true}, {k = "rez", by = "Grosh"},
        {k = "quest", d = "The Zhevra"}})
    j[#j + 1] = {k = "with", d = "grosh", n = "Grosh-Forever", t = At(3, 19), e = At(3, 20, 30)}
    local p = {self = true, charKey = "r9", name = "Zuni", race = "Troll", faction = "Horde", class = "HUNTER", startLevel = 15, journal = j}
    Clean(p)
    local spirits = false
    for retell, chapters in pairs(Tellings(p)) do
        local two = chapters[2].plain
        check(not two:find("level 17", 1, true) or two:find("earlier", 1, true) or two:find("in all of it", 1, true),
            "a level before the turn-ins is not told as their end (" .. retell .. "): " .. two)
        local three = chapters[3].plain
        local mount, forty = three:find("mount", 1, true), three:find("forty", 1, true) or three:find("40", 1, true)
        check(mount and forty and forty < mount, "the mount after the level that bought it: " .. three)
        local four = chapters[4].plain
        if four:find("spirit", 1, true) then spirits = true end
        local named = four:find("Grosh", 1, true)
        local we = four:find("%f[%a][Ww]e%f[%A]") or four:find("%f[%a]our%f[%A]")
        check(named and (not we or we > named), "\"we\" only once Grosh is named: " .. four)
    end
    check(spirits, "a shaman's rez told by the spirits, now and then")
    A.db = nil
end

-- 12. Round 10: a day of battlegrounds is a chapter; three deaths to the other side
-- are counted once; a couple who began together open the book together.
do
    A.db = {people = {ragh = {name = "Ragh-Forever", race = "Orc", class = "WARRIOR", origin = "together", bond = "spouse", pronouns = "she"}}}
    LOCALIZED_CLASS_NAMES_MALE = {WARRIOR = "Warrior"}
    local j = {}
    Stretch(j, At(0, 19), 90, "Durotar", 1, {{k = "quest", d = "Your Place in the World"}, {k = "quest", d = "Cutting Teeth"}})
    j[#j + 1] = {k = "with", d = "ragh", n = "Ragh-Forever", t = At(0, 19), e = At(0, 20, 30)}
    Stretch(j, At(2, 20), 50, "Warsong Gulch", 22, {{k = "first", d = "battleground", z = "Warsong Gulch", u = true}, {k = "bg", d = "Warsong Gulch"}})
    Stretch(j, At(2, 21), 40, "Warsong Gulch", 22, {{k = "bg", d = "Warsong Gulch"}})
    Stretch(j, At(4, 20), 90, "Hillsbrad Foothills", 23, {{k = "death", pr = "Human", pc = "Warrior"}, {k = "death", pr = "Human", pc = "Warrior"},
        {k = "death", pr = "Human", pc = "Warrior"}, {k = "quest", d = "Battle of Hillsbrad"}})
    local p = {self = true, charKey = "r10", name = "Durka", race = "Orc", faction = "Horde", class = "SHAMAN", startLevel = 1, journal = j}
    Clean(p)
    for retell, chapters in pairs(Tellings(p)) do
        local one = chapters[1].plain
        check(Count(one, "Ragh") == 1 and one:find("began together", 1, true) or one:find("came of age together", 1, true),
            "a life begun together opens as theirs, Ragh named once (" .. retell .. "): " .. one)
        check(chapters[2] and chapters[2].plain:find("Warsong Gulch twice", 1, true), "a battleground day is a chapter: " .. tostring(chapters[2] and chapters[2].plain))
        local three = chapters[3].plain
        check(not three:find("%f[%a]again%f[%A]") and (three:find("three times", 1, true)), "three deaths, counted once: " .. three)
    end
    A.db = nil
end

-- 13. Round 12: the foe's own quest after it killed you (no third name); the third
-- fall of a book counted; the pace of a speed leveller, once.
do
    A.db = {people = {}}
    local j = {}
    Stretch(j, At(0, 19), 90, "Elwynn Forest", 9, {{k = "death", d = "Hogger"}, {k = "quest", d = 'WANTED: "Hogger"'}, {k = "mylevel", d = 10}})
    Stretch(j, At(1, 19), 60, "Westfall", 11, {{k = "death", env = "FALLING"}, {k = "death", env = "FALLING"}})
    Stretch(j, At(2, 19), 60, "Westfall", 12, {{k = "death", env = "FALLING"}, {k = "quest", d = "The People's Militia"}, {k = "mylevel", d = 13}})
    Stretch(j, At(3, 19), 60, "Westfall", 13, {{k = "quest", d = "Patrolling Westfall"}, {k = "mylevel", d = 17}})
    Stretch(j, At(4, 19), 60, "Westfall", 17, {{k = "quest", d = "The Defias Brotherhood"}, {k = "mylevel", d = 21}})
    local p = {self = true, charKey = "r12", name = "Wenna", race = "Human", faction = "Alliance", class = "PALADIN", startLevel = 6, journal = j}
    Clean(p)
    for retell, chapters in pairs(Tellings(p)) do
        local one = chapters[1].plain
        check(Count(one, "Hogger") <= 3 and (one:find("other way", 1, true) or one:find("still standing", 1, true) or one:find("who went down", 1, true)
            or one:find("who died", 1, true)), "the foe's quest after the death is the revenge (" .. retell .. "): " .. one)
        check(chapters[3].plain:find("third time", 1, true), "the third fall is counted: " .. chapters[3].plain)
        local all = ""
        for _, c in ipairs(chapters) do all = all .. " " .. c.plain end
        check(Count(all, "had gone from level") <= 1, "the pace said once at most: " .. all)
    end
    A.db = nil
end

-- 14. Alberich (in game, 2026-10-02): Orgrimmar in chapter one, then a "first visit"
-- recorded late (a journal older than its firsts) is no first; and play after
-- midnight belongs to the evening before ("Thursday night", not "Friday night").
do
    A.db = {people = {}}
    local j = {}
    Stretch(j, At(0, 20), 60, "Tirisfal Glades", 10, {{k = "quest", d = "Rot Hide Clues"}})
    Stretch(j, At(0, 21, 30), 30, "Orgrimmar", 12, {})
    Stretch(j, At(5, 0, 30), 40, "Orgrimmar", 17, {{k = "first", d = "zone", z = "Orgrimmar"}})
    local p = {self = true, charKey = "night", name = "Alberich", race = "Scourge", faction = "Horde", class = "PALADIN", startLevel = 1, journal = j}
    Clean(p)
    local days = A.JournalBook(p)
    local eve = os.date("%A", At(4, 21))
    check(days[#days].weekday == eve, "after midnight, the evening before: " .. tostring(days[#days].weekday) .. " / " .. eve)
    for retell, chapters in pairs(Tellings(p)) do
        local two = chapters[#chapters].plain
        check(not two:find("first time", 1, true) and not two:find("never", 1, true) and not two:find("new to me", 1, true),
            "Orgrimmar seen in chapter one is no first (" .. retell .. "): " .. two)
        check(not two:find(os.date("%A", At(5, 12)), 1, true), "not the calendar day after midnight: " .. two)
    end
    A.db = nil
end

io.write("PASS: " .. assertions .. " own-life assertions\n")
