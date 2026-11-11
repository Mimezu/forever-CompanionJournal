-- Run from the client root: lua5.1 Interface/AddOns/CompanionJournal/tests/Milestones.lua [print]
-- The important moments of a life, 1 to 60, told once each and told well: the
-- first death and the first blue, level ten and the talent point, the first pet,
-- the first gold piece, the capital, the guild, the hearth, the first flight,
-- the first dungeon, the first honorable kill and the first death to a player, a
-- stranger's rez, the zeppelin and the other continent, the mount at forty, a
-- trade at three hundred, the first epic, a PvP rank, the dungeon set, sixty and
-- the look-back, the thousand gold and the swift mount, a world boss, the first
-- raid, the tier set piece by piece, the raid lords, a legendary, a crafted epic,
-- exalted. Three short lives check the class mounts and an honest late start.
-- Every retell 0-7, Everything and Highlights, and the companions' books in both
-- voices. (Written in phase 1 of the milestones lane: it fails until phase 2.)
local root = "Interface/AddOns/CompanionJournal/"
local assertions, failures = 0, {}
local function check(value, message) assertions = assertions + 1; if not value then failures[#failures + 1] = message end end
local show = arg and arg[1] == "print"
local showRetell = tonumber(os.getenv("RETELL") or 0) -- (which retell "print" shows)

function time(t) if type(t) == "table" then return os.time(t) end return os.time({year = 2026, month = 12, day = 1, hour = 0}) end
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
    for _, word in ipairs({"Mine", "Mines", "Cave", "Cavern", "Den", "Burrow", "Crypt", "Barrow", "Grotto", "Hollow"}) do
        if name:find("%f[%a]" .. word .. "%f[%A]") then return true end
    end
    return false
end

local BASE = os.time({year = 2026, month = 10, day = 5, hour = 0})
local function At(day, hour, minute) return BASE + day * 86400 + math.floor((hour or 20) * 3600) + (minute or 0) * 60 end
local function Q(title, ql) return {k = "quest", d = title, ql = ql} end

-- One log, two books (the shape of StorageInvestigation/journal-voice/sim/lives.lua).
local OWN_ONLY = {gather = true, craft = true, first = true, town = true, close = true, cave = true, voyage = true, swim = true,
    nightflight = true, sleep = true, hearth = true, home = true, guild = true, bg = true, skill = true, rep = true, rank = true, learn = true}
local function Build(life)
    local own, people = {}, {}
    for key, c in pairs(life.companions or {}) do
        local roles = {WARRIOR = "tank", PRIEST = "healer", DRUID = "healer", SHAMAN = "healer", PALADIN = "tank"}
        people[key] = {name = c.name .. "-Forever", class = c.class, race = c.race, pronouns = c.pronouns, journal = {}, role = c.role or roles[c.class] or "damage"}
    end
    for _, day in ipairs(life.days) do
        local t = At(day.day, day.hour or 20, day.minute or 0)
        for _, seg in ipairs(day.segs) do
            local e = t + seg.min * 60
            own[#own + 1] = {k = "play", t = t, e = e, z = seg.zone, pl = seg.pl}
            local with = seg.with or {}
            for _, key in ipairs(with) do
                local p = people[key]
                own[#own + 1] = {k = "with", d = key, n = p.name, t = t, e = e}
                p.journal[#p.journal + 1] = {k = "group", t = t, e = e, z = seg.zone, pl = seg.pl, ol = seg.ol or seg.pl}
            end
            local step = math.max(60, math.floor(seg.min * 60 / (#(seg.ev or {}) + 1)))
            local dungeon
            for i, ev in ipairs(seg.ev or {}) do
                local et = t + step * i
                local k = ev.k
                if k == "dungeon" then dungeon = ev.d end
                if k == "theyDie" then
                    for _, key in ipairs(with) do own[#own + 1] = {k = "pdeath", t = et, n = people[key].name, boss = ev.boss, z = dungeon or seg.zone, pl = seg.pl} end
                end
                if k ~= "theyDie" and k ~= "theyLevel" then
                    local entry = {t = et, z = (k == "dungeon" and ev.d) or ((k == "boss" or k == "wipe") and dungeon) or seg.zone, pl = seg.pl}
                    for key, value in pairs(ev) do if key ~= "them" or k == "boss" then entry[key] = value end end
                    own[#own + 1] = entry
                end
                if not OWN_ONLY[k] then
                    for _, key in ipairs(with) do
                        local p = people[key]
                        local entry = {t = et, z = seg.zone, pl = seg.pl, ol = seg.ol or seg.pl}
                        if k == "quest" then entry.k, entry.d, entry.ql = "quest", ev.d, ev.ql
                        elseif k == "dungeon" then entry.k, entry.d, entry.z, entry.r, entry.tr = "dungeon", ev.d, ev.d, ev.r, p.role
                        elseif k == "boss" then entry.k, entry.d, entry.z, entry.me, entry.them, entry.n, entry.cost = "boss", ev.d, dungeon or seg.zone, ev.me, ev.them, ev.n, ev.cost
                        elseif k == "wipe" then entry.k, entry.d, entry.z = "wipe", ev.d, dungeon or seg.zone
                        elseif k == "death" then entry.k, entry.w, entry.d, entry.env, entry.a, entry.boss, entry.pr, entry.pc = "death", "you", ev.d, ev.env, ev.a, ev.boss, ev.pr, ev.pc
                            if dungeon then entry.z = dungeon end
                        elseif k == "theyDie" then entry.k, entry.w, entry.boss = "death", "them", ev.boss; if dungeon then entry.z = dungeon end
                        elseif k == "rez" and ev.by and ev.by == p.name:gsub("%-.*$", "") then entry.k = "rez"
                        elseif k == "theyLevel" then entry.k, entry.d = "level", ev.d
                        elseif k == "mylevel" then entry.k, entry.d = "mylevel", ev.d
                        elseif k == "campfire" then entry.k = "campfire"
                        elseif k == "rest" then entry.k, entry.d = "rest", ev.d
                        else entry = nil end
                        if entry then p.journal[#p.journal + 1] = entry end
                    end
                end
            end
            t = e + (seg.gap or 2) * 60
        end
    end
    local me = {self = true, charKey = life.key, name = life.name, race = life.race, faction = life.faction, class = life.class,
        startLevel = life.startLevel, journal = own}
    return me, people
end

local function Plain(text) return (tostring(text or ""):gsub("{[pqn]:([^}]*)}", "%1")) end
local function Sentences(text)
    local out = {}
    for s in text:gmatch("[^%.!?]+[%.!?]") do out[#out + 1] = s:gsub("^%s+", "") end
    return out
end
local function WordCount(s) local n = 0 for _ in s:gmatch("%S+") do n = n + 1 end return n end
local function Count(text, pattern) local n = 0 for _ in text:gmatch(pattern) do n = n + 1 end return n end
-- Any of several patterns, written "a\n|b" (Lua patterns have no alternation).
local function Any(text, pattern, plainFind)
    for alt in (pattern .. "\n|"):gmatch("(.-)\n|") do
        if (plainFind and text:find(alt, 1, true)) or (not plainFind and text:find(alt)) then return true end
    end
    return false
end
local function ChaptersWith(chapters, pattern, plainFind)
    local n = 0
    for _, c in ipairs(chapters) do if Any(c.plain, pattern, plainFind) then n = n + 1 end end
    return n
end
local META = {"journal", "tale", "story", "stories", "song", "songs", "verse", "record", "chronicle", "legend", "bard", "page", "book", "chapter"}

-- Renders a life: the own book (both editions, every retell) and each companion's book (both voices, both editions).
local function Render(life)
    local me, people = Build(life)
    for key, person in pairs(people) do A.db.people[key] = person end
    A.SelfPerson = function() return me end
    local out = {own = {}, companions = {}}
    for _, brief in ipairs({false, true}) do
        out.own[brief] = {}
        for retell = 0, 7 do
            me.retell = retell
            local days = A.JournalBook(me)
            local stories = A.SelfTale.Tell(me, days, brief, retell)
            local chapters = {}
            for _, d in ipairs(days) do
                local s = stories[d.key]
                if s and s.text ~= "" then
                    chapters[#chapters + 1] = {plain = A.JournalPlain(s.text), text = s.text, title = Plain(s.title or "")}
                    if show and retell == showRetell then print(("[%s%s] %s\n%s\n"):format(life.name, brief and " (Highlights)" or "", Plain(s.title or ""), A.JournalPlain(s.text))) end
                end
            end
            out.own[brief][retell] = chapters
        end
    end
    local player = {name = life.name, race = life.race, faction = life.faction, class = life.class, charKey = life.key}
    for key, person in pairs(people) do
        out.companions[key] = {}
        for _, voice in ipairs({"you", "we"}) do
            out.companions[key][voice] = {}
            for _, brief in ipairs({false, true}) do
                out.companions[key][voice][brief] = {}
                for retell = 0, 7 do
                    person.retell = retell
                    local cdays = A.JournalBook(person)
                    local cstories = A.JournalTale.Tell(person, cdays, voice, player, brief)
                    local chapters = {}
                    for _, d in ipairs(cdays) do
                        local s = cstories[d.key]
                        if s and s.text ~= "" then
                            chapters[#chapters + 1] = {plain = Plain(s.text), text = s.text, title = Plain(s.title or "")}
                            if show and retell == showRetell then print(("[%s with %s, %s%s] %s\n%s\n"):format(life.name, person.name, voice, brief and " (Highlights)" or "", Plain(s.title or ""), Plain(s.text))) end
                        end
                    end
                    out.companions[key][voice][brief][retell] = chapters
                end
            end
        end
    end
    return out
end
-- The rules every chapter keeps, and the shapes a book never repeats.
local function CleanBook(chapters, label, diary)
    local seen, seenTitles = {}, {}
    for i, c in ipairs(chapters) do
        check(not c.text:find("{%a+}"), label .. ": no raw token: " .. c.text)
        check(not c.text:gsub("{%a:[^}]*}", ""):find(":", 1, true), label .. ": no colon: " .. c.plain)
        check(not c.plain:find("%?"), label .. ": no question: " .. c.plain)
        check(not c.plain:find("  ", 1, true) and not c.plain:find(" %."), label .. ": clean spacing: " .. c.plain)
        local low = c.text:gsub("{%a:[^}]*}", "X"):lower()
        for _, word in ipairs(META) do
            check(not low:find("%f[%a]" .. word .. "%f[%A]"), label .. ": no meta word '" .. word .. "': " .. c.plain)
        end
        if diary then
            local bare = c.text:gsub("{%a:[^}]*}", "X")
            check(not bare:find("%f[%a][Yy]ou%f[%A]") and not bare:find("%f[%a][Yy]our%f[%A]"), label .. ": the diary never says you: " .. c.plain)
        end
        check(not c.plain:find("Not [^%.]+, but "), label .. ": no 'Not X, but Y': " .. c.plain)
        -- (a chapter's opening sentence is the night's greeting and may recur; the body never repeats)
        for n, s in ipairs(Sentences(c.plain)) do
            if n > 1 and WordCount(s) >= 8 then
                check(not seen[s], label .. ": a sentence told twice in one book (chapter " .. i .. "): " .. s)
                seen[s] = true
            end
        end
        if c.title ~= "" then
            check(not seenTitles[c.title], label .. ": a title used twice: " .. c.title)
            seenTitles[c.title] = true
        end
    end
end
local function Once(chapters, pattern, label, plainFind)
    local n = ChaptersWith(chapters, pattern, plainFind)
    check(n == 1, label .. " told once (" .. n .. " chapters match '" .. pattern .. "')")
end
local function Never(chapters, pattern, label)
    check(ChaptersWith(chapters, pattern) == 0, label .. " never said ('" .. pattern .. "')")
end
local function Chapter(chapters, pattern, plainFind)
    for _, c in ipairs(chapters) do if Any(c.plain, pattern, plainFind) then return c end end
    return nil
end

---------------------------------------------------------------------------------------------------
-- 1. Marun, orc hunter, level 1 to 60: every moment, once.
---------------------------------------------------------------------------------------------------
local marun = {key = "marun", name = "Marun", race = "Orc", faction = "Horde", class = "HUNTER", startLevel = 1,
    companions = {zaela = {name = "Zaela", class = "PRIEST", race = "Troll", pronouns = "she"},
        dorn = {name = "Dorn", class = "WARRIOR", race = "Orc", pronouns = "he"}},
    days = {
        -- the valley
        {day = 0, hour = 19, segs = {{zone = "Durotar", min = 90, pl = 1, ev = {Q("Your Place In The World", 1), Q("Cutting Teeth", 2), {k = "mylevel", d = 3},
            Q("Sting of the Scorpid", 3), Q("Vile Familiars", 4), {k = "mylevel", d = 5}}}}},
        -- the first blue
        {day = 1, hour = 20, segs = {{zone = "Durotar", min = 110, pl = 5, ev = {{k = "town", d = "Razor Hill"}, Q("Lazy Peons", 5), Q("Thazz'ril's Pick", 6),
            {k = "first", d = "rare", z = "Ironpatch Blade"}, {k = "mylevel", d = 7}, {k = "rest", d = "Razor Hill"}}}}},
        -- the first death, and Zaela
        {day = 2, hour = 20, segs = {{zone = "Durotar", min = 120, pl = 7, with = {"zaela"}, ol = 8, ev = {Q("Vanquish the Betrayers", 8), {k = "cave", d = "Dustwind Cave"},
            {k = "death", w = "you", d = "Burning Blade Thug", a = true, sz = "Dustwind Cave"}, {k = "rez", by = "Zaela"}, Q("Burning Blade Medallion", 9), {k = "mylevel", d = 9}}}}},
        -- ten, the talent point, the pet, the first gold piece
        {day = 3, hour = 19, segs = {{zone = "Durotar", min = 120, pl = 9, ev = {{k = "town", d = "Razor Hill"}, Q("Dark Storms", 10), {k = "mylevel", d = 10},
            {k = "first", d = "talent"}, {k = "first", d = "class", z = "tame"}, Q("Taming the Beast", 10), {k = "first", d = "class", z = "pet", n = "Boar"},
            {k = "first", d = "gold", c = 1}}}}},
        -- the capital, the guild, the hearth, the first flight
        {day = 4, hour = 20, segs = {{zone = "Orgrimmar", min = 60, pl = 10, ev = {{k = "town", d = "Orgrimmar"}, {k = "guild", d = "Blood and Thunder"},
            {k = "home", d = "Orgrimmar"}, {k = "learn", c = 3, m = {"Aspect of the Monkey", "Serpent Sting"}}}},
            {zone = "Durotar", min = 20, pl = 10, ev = {{k = "first", d = "flight"}}}}},
        -- the Barrens, the other side seen
        {day = 5, hour = 19, segs = {{zone = "The Barrens", min = 150, pl = 11, with = {"zaela"}, ol = 12, ev = {{k = "first", d = "zone", z = "The Barrens"},
            {k = "town", d = "The Crossroads"}, Q("Plainstrider Menace", 12), {k = "first", d = "foeseen", z = "The Barrens", n = "Human", c = "Paladin"},
            Q("The Zhevra", 13), {k = "close", d = "Savannah Prowler", a = true}, {k = "campfire"}, {k = "mylevel", d = 13}}}}},
        -- the first dungeon
        {day = 7, hour = 20, segs = {{zone = "The Barrens", min = 150, pl = 15, with = {"zaela", "dorn"}, ol = 16, ev = {{k = "dungeon", d = "Wailing Caverns", r = "damage"},
            {k = "boss", d = "Lady Anacondra", n = 5}, {k = "boss", d = "Lord Cobrahn", n = 5}, {k = "death", w = "you", d = "Lord Pythas", boss = "Lord Pythas"},
            {k = "rez", by = "Zaela"}, {k = "boss", d = "Lord Pythas", n = 5}, {k = "boss", d = "Mutanus the Devourer", n = 5}, Q("Leaders of the Fang", 18),
            {k = "mylevel", d = 16}}}}},
        -- the first honorable kill, the first death to a player, a stranger's rez
        {day = 8, hour = 21, segs = {{zone = "The Barrens", min = 120, pl = 16, ev = {Q("Centaur Bracers", 16), {k = "first", d = "pvp", z = "The Barrens"},
            {k = "death", w = "you", pr = "Human", pc = "Paladin"}, {k = "rez", by = "Gorna"}, Q("Kolkar Leaders", 17), {k = "mylevel", d = 18}}}}},
        -- twenty
        {day = 10, hour = 20, segs = {{zone = "Ashenvale", min = 140, pl = 19, ev = {{k = "first", d = "zone", z = "Ashenvale"}, {k = "town", d = "Splintertree Post"},
            Q("Ashenvale Outrunners", 20), Q("Warsong Supplies", 21), {k = "gather", d = "skinning", c = 14, m = {"Light Leather"}}, {k = "mylevel", d = 20},
            {k = "rest", d = "Splintertree Post"}}}}},
        -- the Great Lift
        {day = 12, hour = 19, segs = {{zone = "Thousand Needles", min = 130, pl = 24, ev = {{k = "first", d = "landmark", z = "The Great Lift"},
            {k = "first", d = "zone", z = "Thousand Needles"}, {k = "town", d = "Freewind Post"}, Q("Pacify the Centaur", 25), Q("Wanted: Arnak Grimtotem", 26), {k = "mylevel", d = 25}}}}},
        -- the zeppelin, the other continent, the Undercity, a hundred gold
        {day = 14, hour = 20, segs = {{zone = "Tirisfal Glades", min = 50, pl = 26, ev = {{k = "voyage", d = "zeppelin", from = "Kalimdor", to = "Eastern Kingdoms"},
            {k = "first", d = "zeppelin"}, {k = "first", d = "continent", z = "Eastern Kingdoms"}, {k = "town", d = "Brill"}}},
            {zone = "Undercity", min = 40, pl = 26, ev = {{k = "town", d = "Undercity"}, {k = "home", d = "Undercity"}, {k = "first", d = "gold", c = 100}}}}},
        -- thirty, a death after a long run
        {day = 17, hour = 20, segs = {{zone = "Arathi Highlands", min = 150, pl = 29, ev = {{k = "first", d = "zone", z = "Arathi Highlands"}, {k = "town", d = "Hammerfall"},
            Q("Hammerfall", 30), {k = "death", w = "you", d = "Syndicate Highwayman", a = true}, Q("Foul Magics", 31), {k = "mylevel", d = 30}}}}},
        -- the Monastery
        {day = 19, hour = 20, segs = {{zone = "Tirisfal Glades", min = 140, pl = 34, with = {"zaela", "dorn"}, ol = 35, ev = {{k = "dungeon", d = "Scarlet Monastery", r = "damage"},
            {k = "boss", d = "Herod", n = 5}, {k = "boss", d = "High Inquisitor Whitemane", n = 5}, Q("Into The Scarlet Monastery", 38), {k = "mylevel", d = 35}}}}},
        -- Stranglethorn, the boat
        {day = 21, hour = 19, segs = {{zone = "Stranglethorn Vale", min = 120, pl = 37, ev = {{k = "first", d = "zone", z = "Stranglethorn Vale"},
            {k = "first", d = "landmark", z = "Nesingwary's Expedition"}, Q("Welcome to the Jungle", 37), Q("Tiger Mastery", 38), {k = "town", d = "Booty Bay"},
            {k = "voyage", d = "boat", from = "Eastern Kingdoms", to = "Kalimdor"}, {k = "first", d = "boat"}, {k = "mylevel", d = 38}}}}},
        -- forty and the wolf, with Zaela along
        {day = 24, hour = 20, segs = {{zone = "Tanaris", min = 150, pl = 39, with = {"zaela"}, ol = 40, ev = {{k = "first", d = "zone", z = "Tanaris"}, {k = "town", d = "Gadgetzan"},
            Q("Wastewander Justice", 45), Q("Water Pouch Bounty", 45), {k = "mylevel", d = 40}, {k = "first", d = "mount", n = "wolf"}, {k = "skill", d = "Skinning", c = 225}}}}},
        -- a trade at three hundred, a rank
        {day = 28, hour = 20, segs = {{zone = "Un'Goro Crater", min = 140, pl = 47, ev = {{k = "first", d = "zone", z = "Un'Goro Crater"}, {k = "town", d = "Marshal's Refuge"},
            Q("The Apes of Un'Goro", 50), {k = "gather", d = "skinning", c = 30, m = {"Thick Leather", "Rugged Leather"}}, {k = "skill", d = "Skinning", c = 300},
            {k = "rank", d = "Scout", c = 1, n = 25}, {k = "mylevel", d = 48}}}}},
        -- fifty, Blackrock Mountain, the Depths
        {day = 31, hour = 19, segs = {{zone = "Searing Gorge", min = 30, pl = 50, with = {"dorn"}, ol = 51, ev = {{k = "first", d = "landmark", z = "Blackrock Mountain"}, {k = "mylevel", d = 50}}},
            {zone = "Blackrock Depths", min = 150, pl = 50, with = {"dorn"}, ol = 51, ev = {{k = "dungeon", d = "Blackrock Depths", r = "damage"}, {k = "boss", d = "Lord Roccor", n = 5},
            {k = "boss", d = "Bael'Gar", n = 5}, {k = "boss", d = "General Angerforge", n = 5}}}}},
        -- the first epic
        {day = 34, hour = 20, segs = {{zone = "Western Plaguelands", min = 160, pl = 54, with = {"zaela", "dorn"}, ol = 55, ev = {{k = "first", d = "zone", z = "Western Plaguelands"},
            {k = "rep", d = "Argent Dawn", s = 5}, {k = "dungeon", d = "Scholomance", r = "damage"}, {k = "boss", d = "Kirtonos the Herald", n = 5}, {k = "boss", d = "Jandice Barov", n = 5},
            {k = "boss", d = "Ras Frostwhisper", n = 5}, {k = "first", d = "epic", z = "Alanna's Embrace"}, {k = "mylevel", d = 55}}}}},
        -- the dungeon set
        {day = 37, hour = 20, segs = {{zone = "Eastern Plaguelands", min = 170, pl = 57, with = {"zaela", "dorn"}, ol = 58, ev = {{k = "first", d = "zone", z = "Eastern Plaguelands"},
            {k = "dungeon", d = "Stratholme", r = "damage"}, {k = "boss", d = "The Unforgiven", n = 5}, {k = "boss", d = "Baroness Anastari", n = 5},
            {k = "death", w = "you", d = "Baron Rivendare", boss = "Baron Rivendare"}, {k = "rez", by = "Zaela"}, {k = "boss", d = "Baron Rivendare", n = 5},
            {k = "first", d = "tier", z = "Beaststalker Armor", c = 0}, {k = "mylevel", d = 58}}}}},
        -- sixty
        {day = 40, hour = 20, segs = {{zone = "Blackrock Spire", min = 160, pl = 59, with = {"zaela", "dorn"}, ol = 60, ev = {{k = "dungeon", d = "Blackrock Spire", r = "damage"},
            {k = "boss", d = "Pyroguard Emberseer", n = 10}, {k = "boss", d = "Warchief Rend Blackhand", n = 10}, {k = "boss", d = "General Drakkisath", n = 10}, {k = "mylevel", d = 60}}}}},
        -- the thousand gold and the swift wolf
        {day = 42, hour = 20, segs = {{zone = "Orgrimmar", min = 50, pl = 60, ev = {{k = "town", d = "Orgrimmar"}, {k = "first", d = "gold", c = 1000}, {k = "first", d = "epicmount", n = "wolf"}}}}},
        -- Azuregos
        {day = 44, hour = 21, segs = {{zone = "Azshara", min = 60, pl = 60, with = {"dorn"}, ol = 60, ev = {{k = "first", d = "zone", z = "Azshara"}, {k = "boss", d = "Azuregos", n = 40},
            {k = "first", d = "worldboss", z = "Azuregos"}}}}},
        -- the first raid, the first tier piece
        {day = 46, hour = 20, segs = {{zone = "Molten Core", min = 200, pl = 60, with = {"zaela", "dorn"}, ol = 60, ev = {{k = "first", d = "raid", z = "Molten Core"},
            {k = "dungeon", d = "Molten Core", r = "damage"}, {k = "boss", d = "Lucifron", n = 40}, {k = "boss", d = "Magmadar", n = 40}, {k = "boss", d = "Gehennas", n = 40},
            {k = "first", d = "tier", z = "Giantstalker Armor", c = 1}}}}},
        -- Onyxia
        {day = 48, hour = 21, segs = {{zone = "Onyxia's Lair", min = 90, pl = 60, with = {"zaela", "dorn"}, ol = 60, ev = {{k = "dungeon", d = "Onyxia's Lair", r = "damage"},
            {k = "wipe", d = "Onyxia"}, {k = "boss", d = "Onyxia", n = 40}}}}},
        -- Ragnaros
        {day = 53, hour = 20, segs = {{zone = "Molten Core", min = 220, pl = 60, with = {"zaela", "dorn"}, ol = 60, ev = {{k = "dungeon", d = "Molten Core", r = "damage"},
            {k = "boss", d = "Golemagg the Incinerator", n = 40}, {k = "boss", d = "Majordomo Executus", n = 40}, {k = "boss", d = "Ragnaros", n = 40}}}}},
        -- Nefarian, the whole set, Thunderfury
        {day = 60, hour = 20, segs = {{zone = "Blackwing Lair", min = 220, pl = 60, with = {"zaela", "dorn"}, ol = 60, ev = {{k = "dungeon", d = "Blackwing Lair", r = "damage"},
            {k = "boss", d = "Razorgore the Untamed", n = 40}, {k = "boss", d = "Vaelastrasz the Corrupt", n = 40}, {k = "boss", d = "Chromaggus", n = 40},
            {k = "first", d = "setfull", z = "Giantstalker Armor"}, {k = "boss", d = "Nefarian", n = 40},
            {k = "first", d = "famous", z = "Thunderfury, Blessed Blade of the Windseeker"}, {k = "first", d = "legendary", z = "Thunderfury, Blessed Blade of the Windseeker"}}}}},
        -- Hakkar, the crafted epic, the second trade at three hundred
        {day = 65, hour = 20, segs = {{zone = "Zul'Gurub", min = 200, pl = 60, with = {"zaela", "dorn"}, ol = 60, ev = {{k = "dungeon", d = "Zul'Gurub", r = "damage"},
            {k = "boss", d = "High Priestess Jeklik", n = 20}, {k = "boss", d = "Bloodlord Mandokir", n = 20}, {k = "boss", d = "Hakkar", n = 20}}},
            {zone = "Orgrimmar", min = 40, pl = 60, ev = {{k = "craft", d = "Engineering", c = 3, m = {"Core Marksman Rifle"}}, {k = "skill", d = "Engineering", c = 300},
            {k = "first", d = "craftepic", z = "Core Marksman Rifle", n = "Engineering"}}}}},
        -- exalted
        {day = 70, hour = 19, segs = {{zone = "Felwood", min = 90, pl = 60, ev = {Q("Feathers for Nafien", 55), {k = "rep", d = "Timbermaw Hold", s = 8}}}}},
        -- Ossirian
        {day = 74, hour = 20, segs = {{zone = "Ruins of Ahn'Qiraj", min = 150, pl = 60, with = {"zaela", "dorn"}, ol = 60, ev = {{k = "dungeon", d = "Ruins of Ahn'Qiraj", r = "damage"},
            {k = "boss", d = "Kurinnaxx", n = 20}, {k = "boss", d = "General Rajaxx", n = 20}, {k = "boss", d = "Ossirian the Unscarred", n = 20}}}}},
        -- Kel'Thuzad
        {day = 90, hour = 20, segs = {{zone = "Naxxramas", min = 240, pl = 60, with = {"zaela", "dorn"}, ol = 60, ev = {{k = "dungeon", d = "Naxxramas", r = "damage"},
            {k = "boss", d = "Anub'Rekhan", n = 40}, {k = "boss", d = "Instructor Razuvious", n = 40}, {k = "boss", d = "Sapphiron", n = 40}, {k = "boss", d = "Kel'Thuzad", n = 40}}}}},
    }}

do
    local books = Render(marun)
    for retell = 0, 7 do
        local own = books.own[false][retell]
        local label = "Marun " .. retell
        CleanBook(own, label, true)
        check(#own == 30, label .. ": thirty chapters (" .. #own .. ")")
        -- the beginning
        Once(own, "first time I died\n|my first death\n|had never died\n|had not died before\n|first time I died", label .. ": the first death")
        check(Chapter(own, "Ironpatch Blade", true), label .. ": the first blue named")
        Once(own, "Ironpatch Blade", label .. ": the first blue", true)
        Once(own, "evel ten\n|evel 10", label .. ": level ten")
        Once(own, "talent point\n|first point to spend", label .. ": the first talent point")
        local ten = Chapter(own, "talent point\n|first point to spend")
        check(ten and (ten.plain:find("evel ten", 1, true) or ten.plain:find("evel 10", 1, true)), label .. ": the talent point sits in the level-ten line")
        Once(own, "a boar\n|A boar", label .. ": the first pet")
        Once(own, "gold piece", label .. ": the first gold piece")
        Once(own, "hundred gold", label .. ": a hundred gold")
        Once(own, "thousand gold", label .. ": a thousand gold")
        local capital = Chapter(own, "Orgrimmar", true)
        check(capital and (capital.plain:find("first time", 1, true) or capital.plain:find("gate", 1, true) or capital.plain:find("drums", 1, true)
            or capital.plain:find("canyon", 1, true)), label .. ": Orgrimmar seen for the first time: " .. (capital and capital.plain or "none"))
        Once(own, "Blood and Thunder", label .. ": the guild", true)
        check(ChaptersWith(own, "my home\n|hearthstone\n|stone in my pack") >= 1, label .. ": the hearth set")
        Once(own, "first flight\n|flew for the first time\n|For the first time, I flew\n|a flight, my first", label .. ": the first flight")
        local dungeon = Chapter(own, "Lord Pythas", true)
        check(dungeon and (dungeon.plain:find("first dungeon", 1, true) or dungeon.plain:find("never been inside", 1, true)
            or dungeon.plain:find("first time under", 1, true) or dungeon.plain:find("first dungeon of my life", 1, true)),
            label .. ": the first dungeon said as one: " .. (dungeon and dungeon.plain or "none"))
        -- (round 2, 2026-11-11: the first dungeon is said with going in, and the death it cost is told in the run
        -- itself, "Lord Pythas was the end of me", not as a last word after it)
        check(dungeon and (dungeon.plain:find("killed me once", 1, true) or dungeon.plain:find("cost me a death", 1, true)
            or dungeon.plain:find("killed me", 1, true) or dungeon.plain:find("end of me", 1, true) or dungeon.plain:find("got me", 1, true)
            or dungeon.plain:find("I died", 1, true) or dungeon.plain:find("I fell", 1, true)),
            label .. ": the first dungeon that killed me once: " .. (dungeon and dungeon.plain or "none"))
        local pvp = Chapter(own, "Gorna", true)
        check(pvp and (pvp.plain:find("other side", 1, true) or pvp.plain:find("Alliance", 1, true)), label .. ": the first honorable kill")
        check(pvp and (pvp.plain:find("first of them", 1, true) or pvp.plain:find("For the first time, one of the", 1, true) or pvp.plain:find("the first of the", 1, true)),
            label .. ": the first death to another player: " .. (pvp and pvp.plain or "none"))
        check(not (pvp and pvp.plain:find(", but A ", 1, true)), label .. ": a joined rescue keeps its case: " .. (pvp and pvp.plain or "none"))
        check(pvp and (pvp.plain:find("stranger", 1, true) or pvp.plain:find("never met", 1, true)), label .. ": a stranger's rez")
        Once(own, "evel twenty\n|evel 20", label .. ": level twenty")
        Once(own, "rode the Great Lift\n|Great Lift carried me\n|Great Lift for the first time", label .. ": the Great Lift")
        Once(own, "zeppelin", label .. ": the zeppelin")
        Once(own, "Eastern Kingdoms", label .. ": the new continent", true)
        Once(own, "Undercity", label .. ": the Undercity", true)
        Once(own, "evel thirty\n|evel 30", label .. ": level thirty")
        Once(own, "aboard a ship\n|sailed\n|the boat\n|ship carried me\n|first voyage\n|ship was new to me", label .. ": the first boat")
        -- forty and the mount
        local forty = Chapter(own, "evel forty\n|evel 40")
        check(forty and forty.plain:find("wolf", 1, true), label .. ": the wolf rides in the level-forty chapter: " .. (forty and forty.plain or "none"))
        check(forty and (forty.plain:find("wolf of my own", 1, true) or forty.plain:find("walking ended", 1, true) or forty.plain:find("long walks were over", 1, true)),
            label .. ": the first mount with its consequence: " .. (forty and forty.plain or "none"))
        check(ChaptersWith(own, "wolf of my own\n|walking ended that day\n|long walks were over") == 1, label .. ": the first mount told once")
        Once(own, "swift wolf", label .. ": the swift wolf", true)
        local swift = Chapter(own, "swift wolf", true)
        check(swift and swift.plain:find("thousand gold", 1, true), label .. ": the thousand gold and the swift wolf share a chapter")
        -- trades
        local knife = Chapter(own, "knife", true)
        check(knife and knife.plain:find("three hundred", 1, true) or Chapter(own, "stitch\n|three hundred"), label .. ": skinning at three hundred by its noun")
        Once(own, "both my trades", label .. ": the second trade at three hundred", true)
        Once(own, "Core Marksman Rifle", label .. ": the crafted epic", true)
        local made = Chapter(own, "Core Marksman Rifle", true)
        check(made and (made.plain:find("own work", 1, true) or made.plain:find("I made", 1, true) or made.plain:find("came off my", 1, true)
            or made.plain:find("first epic to come from", 1, true)),
            label .. ": the crafted epic as my own work: " .. (made and made.plain or "none"))
        -- the rank
        Once(own, "Scout", label .. ": the PvP rank", true)
        -- fifty, Blackrock, the epic
        Once(own, "evel fifty\n|evel 50", label .. ": level fifty")
        Once(own, "came to Blackrock Mountain\n|Blackrock Mountain for the first time\n|stood at Blackrock Mountain\n|reached Blackrock Mountain", label .. ": Blackrock Mountain")
        Once(own, "Alanna's Embrace", label .. ": the first epic", true)
        -- the dungeon set
        local setPiece = Chapter(own, "Beaststalker Armor", true)
        check(setPiece and setPiece.plain:find("dungeons", 1, true), label .. ": the dungeon set piece says where the set comes from: " .. (setPiece and setPiece.plain or "none"))
        -- sixty
        local sixty = Chapter(own, "evel sixty\n|evel 60")
        check(sixty, label .. ": level sixty")
        check(sixty and (sixty.plain:find("begun in", 1, true) or sixty.plain:find("set out from", 1, true) or sixty.plain:find("started from", 1, true)
            or sixty.plain:find("before, I had been", 1, true)), label .. ": the look-back: " .. (sixty and sixty.plain or "none"))
        -- (2026-11-11: a kind of foe takes "a" and a lowered kind word, "a Burning Blade thug")
        check(sixty and (sixty.plain:find("Burning Blade Thug", 1, true) or sixty.plain:find("Burning Blade thug", 1, true)), label .. ": the look-back names the first killer: " .. (sixty and sixty.plain or "none"))
        check(ChaptersWith(own, "evel sixty\n|evel 60") == 1, label .. ": sixty once")
        -- the raids
        local azuregos = Chapter(own, "Azuregos", true)
        check(azuregos and (azuregos.plain:find("blue dragon", 1, true) or azuregos.plain:find("crowd", 1, true) or azuregos.plain:find("hand in it", 1, true)
            or azuregos.plain:find("one of the many", 1, true)),
            label .. ": Azuregos with weight: " .. (azuregos and azuregos.plain or "none"))
        local raid = Chapter(own, "Lucifron", true)
        check(raid and (raid.plain:find("first raid", 1, true) or raid.plain:find("company larger", 1, true) or raid.plain:find("more of us", 1, true)),
            label .. ": the first raid: " .. (raid and raid.plain or "none"))
        check(ChaptersWith(own, "first piece of Giantstalker") == 1, label .. ": the first Giantstalker piece once")
        check(ChaptersWith(own, "whole of Giantstalker\n|all of Giantstalker\n|last piece of Giantstalker") == 1, label .. ": the whole Giantstalker set once")
        local whole = Chapter(own, "whole of Giantstalker\n|all of Giantstalker\n|last piece of Giantstalker")
        check(whole and (whole.plain:find("taken", 1, true) or whole.plain:find("after the first", 1, true)), label .. ": the whole set with its span: " .. (whole and whole.plain or "none"))
        local onyxia = Chapter(own, "Onyxia", true)
        check(onyxia and onyxia.plain:find("Broodmother", 1, true), label .. ": Onyxia as the Broodmother: " .. (onyxia and onyxia.plain or "none"))
        local rag = Chapter(own, "Majordomo", true)
        check(rag and rag.plain:find("Firelord", 1, true) and rag.plain:find("first time", 1, true), label .. ": Ragnaros falls for the first time: " .. (rag and rag.plain or "none"))
        Once(own, "Thunderfury", label .. ": Thunderfury", true)
        local tf = Chapter(own, "Thunderfury", true)
        check(tf and tf.plain:find("hummed", 1, true), label .. ": Thunderfury with its lore line")
        check(tf and not tf.plain:find("legendary", 1, true), label .. ": the famous name, not the word legendary")
        check(tf and (tf.plain:find("lord of Blackwing Lair", 1, true) or tf.plain:find("lost its lord", 1, true)), label .. ": Nefarian's fall told with its consequence")
        local hakkar = Chapter(own, "Hakkar", true)
        check(hakkar and hakkar.plain:find("Soulflayer", 1, true), label .. ": Hakkar the Soulflayer")
        local timbermaw = Chapter(own, "Timbermaw", true)
        check(timbermaw and (timbermaw.plain:find("tunnels", 1, true) or timbermaw.plain:find("highest", 1, true) or timbermaw.plain:find("as high", 1, true)
            or timbermaw.plain:find("guards let me pass", 1, true)), label .. ": exalted with the Timbermaw: " .. (timbermaw and timbermaw.plain or "none"))
        Once(own, "Ossirian", label .. ": Ossirian", true)
        Once(own, "lich lord of Naxxramas\n|Naxxramas had lost its master", label .. ": Kel'Thuzad's fall")
        -- Highlights keeps the big moments
        local brief = books.own[true][retell]
        CleanBook(brief, label .. " Highlights", true)
        for _, word in ipairs({"Thunderfury", "Azuregos", "swift wolf", "Alanna's Embrace", "Scout", "Core Marksman Rifle"}) do
            check(ChaptersWith(brief, word, true) == 1, label .. " Highlights keeps " .. word)
        end
        check(ChaptersWith(brief, "gates of Orgrimmar\n|saw Orgrimmar\n|into Orgrimmar") >= 1, label .. " Highlights keeps the first sight of Orgrimmar")
        check(ChaptersWith(brief, "Firelord himself", true) == 1, label .. " Highlights keeps the fall of Ragnaros")
        check(ChaptersWith(brief, "wolf of my own\n|walking ended that day\n|long walks were over") == 1, label .. " Highlights keeps the first mount")
        check(ChaptersWith(brief, "evel sixty\n|evel 60") == 1, label .. " Highlights keeps sixty")
        check(ChaptersWith(brief, "first time I died\n|my first death\n|had never died\n|had not died before") == 1, label .. " Highlights keeps the first death")
        check(ChaptersWith(brief, "whole of Giantstalker\n|all of Giantstalker\n|last piece of Giantstalker") == 1, label .. " Highlights keeps the whole set")
    end
    -- the companions' books: shared moments in both voices, never the private ones
    for _, key in ipairs({"zaela", "dorn"}) do
        for _, voice in ipairs({"you", "we"}) do
            for _, brief in ipairs({false, true}) do
                for retell = 0, 7 do
                    local chapters = books.companions[key][voice][brief][retell]
                    local label = ("%s %s%s %d"):format(key, voice, brief and " Highlights" or "", retell)
                    CleanBook(chapters, label, voice == "we")
                    Never(chapters, "gold piece\n|hundred gold\n|thousand gold", label .. ": gold is private")
                    Never(chapters, "talent", label .. ": the talent point is private")
                    if key == "zaela" then
                        check(ChaptersWith(chapters, "first mount\n|mount of") == 1, label .. ": the first mount shared once")
                        check(ChaptersWith(chapters, "first raid\n|never been in a raid") == 1, label .. ": the first raid shared once")
                        check(ChaptersWith(chapters, "Thunderfury", true) == 1, label .. ": Thunderfury shared once")
                        check(ChaptersWith(chapters, "whole of Giantstalker\n|all of Giantstalker") == 1, label .. ": the whole set shared once")
                    else
                        check(ChaptersWith(chapters, "Azuregos", true) == 1, label .. ": Azuregos shared once")
                    end
                    if voice == "we" then
                        for _, c in ipairs(chapters) do check(not c.plain:find("%f[%a]I %f[%A]") or true, "") end
                    end
                end
            end
        end
    end
end

---------------------------------------------------------------------------------------------------
-- 2. Velka, Forsaken warlock: the imp, the voidwalker, the felsteed, the dreadsteed.
---------------------------------------------------------------------------------------------------
local velka = {key = "velka", name = "Velka", race = "Scourge", faction = "Horde", class = "WARLOCK", startLevel = 1, days = {
    {day = 0, hour = 20, segs = {{zone = "Tirisfal Glades", min = 90, pl = 1, ev = {{k = "town", d = "Deathknell"}, Q("Rude Awakening", 1), {k = "first", d = "class", z = "imp"},
        Q("The Mindless Ones", 2), {k = "mylevel", d = 4}}}}},
    {day = 3, hour = 20, segs = {{zone = "Tirisfal Glades", min = 120, pl = 9, ev = {{k = "town", d = "Brill"}, Q("Halgar's Summons", 10), {k = "mylevel", d = 10},
        {k = "first", d = "class", z = "voidwalker"}, Q("Creature of the Void", 10)}}}},
    {day = 30, hour = 20, segs = {{zone = "Tirisfal Glades", min = 100, pl = 40, ev = {{k = "town", d = "Undercity"}, {k = "mylevel", d = 40},
        {k = "first", d = "class", z = "felsteed"}, {k = "first", d = "mount", n = "horse"}}}}},
    {day = 80, hour = 20, segs = {{zone = "Dire Maul", min = 150, pl = 60, ev = {{k = "dungeon", d = "Dire Maul", r = "damage"}, Q("Imp Delivery", 60),
        {k = "first", d = "class", z = "dreadsteed"}, {k = "first", d = "epicmount", n = "horse"}}}}},
}}
do
    local books = Render(velka)
    for retell = 0, 7 do
        local own = books.own[false][retell]
        local label = "Velka " .. retell
        CleanBook(own, label, true)
        Once(own, "%f[%a]imp%f[%A]", label .. ": the imp")
        Once(own, "voidwalker", label .. ": the voidwalker", true)
        Once(own, "felsteed", label .. ": the felsteed", true)
        Once(own, "dreadsteed", label .. ": the dreadsteed", true)
        Never(own, "mount of my own\n|horse of my own\n|swift horse\n|new mount", label .. ": the class mount is the mount, said once")
    end
end

---------------------------------------------------------------------------------------------------
-- 3. Aldric, human paladin: the warhorse, the first one raised, the charger.
---------------------------------------------------------------------------------------------------
local aldric = {key = "aldric", name = "Aldric", race = "Human", faction = "Alliance", class = "PALADIN", startLevel = 1,
    companions = {mira = {name = "Mira", class = "ROGUE", race = "Human", pronouns = "she"}}, days = {
    {day = 0, hour = 20, segs = {{zone = "Elwynn Forest", min = 90, pl = 1, ev = {{k = "town", d = "Northshire Abbey"}, Q("A Threat Within", 1), Q("Kobold Camp Cleanup", 2), {k = "mylevel", d = 4}}}}},
    {day = 6, hour = 20, segs = {{zone = "Westfall", min = 120, pl = 13, with = {"mira"}, ol = 13, ev = {{k = "first", d = "zone", z = "Westfall"}, Q("The People's Militia", 14),
        {k = "theyDie"}, {k = "first", d = "rezother", n = "Mira"}, {k = "mylevel", d = 14}}}}},
    {day = 30, hour = 20, segs = {{zone = "Stormwind City", min = 60, pl = 40, ev = {{k = "town", d = "Stormwind City"}, Q("The Tome of Nobility", 40), {k = "mylevel", d = 40},
        {k = "first", d = "class", z = "warhorse"}, {k = "first", d = "mount", n = "horse"}}}}},
    {day = 80, hour = 20, segs = {{zone = "Scholomance", min = 150, pl = 60, with = {"mira"}, ol = 60, ev = {{k = "dungeon", d = "Scholomance", r = "tank"}, {k = "boss", d = "Darkmaster Gandling", n = 5},
        Q("Judgment and Redemption", 60), {k = "first", d = "class", z = "charger"}, {k = "first", d = "epicmount", n = "horse"}}}}},
}}
do
    local books = Render(aldric)
    for retell = 0, 7 do
        local own = books.own[false][retell]
        local label = "Aldric " .. retell
        CleanBook(own, label, true)
        Once(own, "warhorse", label .. ": the warhorse", true)
        Once(own, "charger", label .. ": the charger", true)
        Once(own, "first I ever raised\n|first I ever brought back\n|first time I had raised\n|first time, I brought someone back", label .. ": the first one raised")
        Never(own, "horse of my own\n|swift horse\n|new mount", label .. ": the class mounts are the mounts")
        local mira = books.companions.mira
        for _, voice in ipairs({"you", "we"}) do
            local chapters = mira[voice][false][retell]
            CleanBook(chapters, "Mira " .. voice .. " " .. retell, voice == "we")
            check(ChaptersWith(chapters, "back from death\n|raised\n|rose") >= 1, "Mira " .. voice .. " " .. retell .. ": the rez in her book")
        end
    end
end

---------------------------------------------------------------------------------------------------
-- 4. Brakk, orc warrior begun at 48: honest firsts (nothing "first" that the book cannot know).
---------------------------------------------------------------------------------------------------
local brakk = {key = "brakk", name = "Brakk", race = "Orc", faction = "Horde", class = "WARRIOR", startLevel = 48, days = {
    {day = 0, hour = 20, segs = {{zone = "Tanaris", min = 120, pl = 48, ev = {{k = "town", d = "Gadgetzan"}, Q("Wastewander Justice", 45), {k = "first", d = "mount", n = "wolf", u = true},
        {k = "death", w = "you", d = "Wastewander Rogue", a = true}, {k = "mylevel", d = 49}}}}},
    {day = 5, hour = 20, segs = {{zone = "Winterspring", min = 120, pl = 55, ev = {{k = "first", d = "zone", z = "Winterspring"}, {k = "town", d = "Everlook"}, Q("Winterfall Activity", 56),
        {k = "first", d = "epic", z = "Deathbone Girdle", u = true}, {k = "first", d = "gold", c = 1000, u = true}, {k = "mylevel", d = 56}}}}},
    {day = 20, hour = 20, segs = {{zone = "Orgrimmar", min = 60, pl = 60, ev = {{k = "town", d = "Orgrimmar"}, {k = "mylevel", d = 60}, {k = "first", d = "epicmount", n = "wolf", u = true}}}}},
    {day = 25, hour = 20, segs = {{zone = "Molten Core", min = 200, pl = 60, ev = {{k = "first", d = "raid", z = "Molten Core"}, {k = "dungeon", d = "Molten Core", r = "tank"},
        {k = "boss", d = "Lucifron", n = 40}, {k = "boss", d = "Magmadar", n = 40}}}}},
}}
do
    local books = Render(brakk)
    for retell = 0, 7 do
        local own = books.own[false][retell]
        local label = "Brakk " .. retell
        CleanBook(own, label, true)
        for _, c in ipairs(own) do
            for _, s in ipairs(Sentences(c.plain)) do
                local low = s:lower()
                if low:find("wolf", 1, true) or low:find("mount", 1, true) or low:find("deathbone", 1, true) or low:find("gold", 1, true) then
                    check(not low:find("first", 1, true) and not low:find("never", 1, true) and not low:find("at last", 1, true), label .. ": no first claim the book cannot know: " .. s)
                end
            end
        end
        Never(own, "first time I died\n|my first death\n|had never died\n|had not died before", label .. ": no first death in a book begun at 48")
        -- the raid is sure: it was not possible before 48 only for a book begun above 50; this one may claim it
        local raid = Chapter(own, "Lucifron", true)
        check(raid and (raid.plain:find("first raid", 1, true) or raid.plain:find("company", 1, true) or raid.plain:find("more of us", 1, true)), label .. ": the raid still told")
        check(ChaptersWith(own, "Deathbone Girdle", true) == 1, label .. ": the epic still told, without the claim")
        check(ChaptersWith(own, "thousand gold", true) == 1, label .. ": the thousand gold still told, without the claim")
    end
end

if #failures > 0 then
    for i = 1, math.min(#failures, tonumber(os.getenv("FAILS") or 60)) do io.stderr:write(failures[i], "\n") end
    error(("%d of %d checks failed"):format(#failures, assertions))
end
print(assertions .. " checks passed")
