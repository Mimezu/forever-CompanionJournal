-- Run from the client root: lua5.1 Interface/AddOns/CompanionJournal/tests/DungeonRepeat.lua [print]
-- The same dungeon again and again (2026-11-06): each run told by its place in
-- the character's own history. Scenario A: the Deadmines five times in ten
-- days, the first run left after two bosses (an unfinished descent), the next
-- four to VanCleef, one with a death, some with a companion. Scenario B: six
-- runs with the failures late, four clears first, then a run abandoned after
-- Sneed, then a run that ended with the character dead at VanCleef and the
-- Defias master alive. Own book and a companion's book, both voices, both
-- editions, every telling 0-7. An unfinished run never claims the lord; the
-- run that finished what an earlier one left is told as that; a veteran
-- falling short reads differently from a first-timer turning back; the last
-- word of scenario B stays unfinished; no entry sentence repeats; no meta words.
local root = "Interface/AddOns/CompanionJournal/"
local assertions = 0
local function check(value, message) assertions = assertions + 1; assert(value, message) end
local show = arg and arg[1] == "print"

function time(t) if type(t) == "table" then return os.time(t) end return 1790000000 + 100 * 86400 end
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
A.db = {people = {bryn = {name = "Bryn-Forever", class = "PRIEST", race = "Dwarf", pronouns = "she"}}}
A.SelfUnderground = function(name)
    for _, word in ipairs({"Mine", "Mines", "Cave", "Den", "Deadmines"}) do if name:find("%f[%a]" .. word .. "%f[%A]") then return true end end
    return false
end

local BASE = os.time({year = 2026, month = 3, day = 2, hour = 0})
local function At(day, hour, minute) return BASE + day * 86400 + math.floor((hour or 20) * 3600) + (minute or 0) * 60 end
local function Sentences(text)
    local list = {}
    for s in text:gmatch("[^%.!%?]+[%.!%?]") do list[#list + 1] = (s:gsub("^%s+", "")) end
    return list
end
local META = {"journal", "tale", "story", "song", "verse", "record", "chronicle", "legend", "bard", "page", "book", "chapter"}
local function Clean(plain, text)
    local prose = A.JournalPlain((text:gsub("{q:[^}]*}", "Q")))
    local low = prose:lower()
    for _, w in ipairs(META) do check(not low:find("%f[%a]" .. w .. "%f[%A]"), "no meta word '" .. w .. "': " .. plain) end
    check(not prose:find(":", 1, true), "no colon: " .. plain)
    check(not prose:find("?", 1, true), "no question: " .. plain)
    check(not text:find("{%a+}"), "no raw token: " .. text)
end
-- A kill of VanCleef is claimed only in these shapes; an unfinished run must show none of them.
local function ClaimsVanCleef(plain)
    local p = plain:gsub("\n", " ")
    for _, s in ipairs(Sentences(p)) do
        if s:find("VanCleef", 1, true) and (s:find("killed", 1, true) or s:find("fell", 1, true) or s:find("went down", 1, true)
            or s:find("slew", 1, true) or s:find("brought down", 1, true) or s:find("dealt with", 1, true) or s:find("stayed down", 1, true)
            or s:find("did not live", 1, true) or s:find("died", 1, true) or s:find("death", 1, true)) then
            -- (a death of the character at VanCleef's hands is not a kill of him)
            if not (s:find("killed me", 1, true) or s:find("killed you", 1, true) or s:find("cut me down", 1, true) or s:find("cut you down", 1, true)
                or s:find("got me", 1, true) or s:find("got you", 1, true) or s:find("laid me low", 1, true) or s:find("laid you low", 1, true)
                or s:find("I died", 1, true) or s:find("you died", 1, true) or s:find("my death", 1, true) or s:find("your death", 1, true)
                or s:find("the end of me", 1, true) or s:find("the end of you", 1, true) or s:find("had killed me", 1, true)
                or s:find("died fighting", 1, true) or s:find("fell to", 1, true) or s:find("fell in", 1, true) or s:find("your life", 1, true) or s:find("my life", 1, true)
                or s:find("beat", 1, true) or s:find("stopped", 1, true) or s:find("held", 1, true) or s:find("unbeaten", 1, true)
                or s:find("short of", 1, true) or s:find("before", 1, true) or s:find("without", 1, true) or s:find("standing", 1, true)
                or s:find("still", 1, true) or s:find("not go as deep", 1, true) or s:find("no further", 1, true)) then return s end
        end
    end
    if p:find("lost its master", 1, true) then return "lost its master" end
    return nil
end
local UNFINISHED_WORDS = {"stopped short", "left standing", "unbeaten", "did not go as deep", "run ended", "as far as", "no further", "still down there",
    "still there", "came back out with", "before VanCleef", "had kept", "kept", "without", "stopped at", "ended at", "ended in front", "held the end",
    "the end of the run", "reach VanCleef", "VanCleef still"}
local function SaysUnfinished(plain)
    for _, w in ipairs(UNFINISHED_WORDS) do if plain:find(w, 1, true) then return w end end
    return nil
end
local RETURN_WORDS = {"stopped short", "left standing", "unbeaten", "This time", "all the way", "What the first run", "second visit", "did not again",
    "the time before", "the last run", "finished what", "the first run", "an earlier run", "the run before"}
local function SaysReturn(plain)
    for _, w in ipairs(RETURN_WORDS) do if plain:find(w, 1, true) then return w end end
    return nil
end

-- The runs: {day, hour, bosses (in order), death = boss (the character dies to it), rez = true, with = companion key, left = true (out again after)}.
local ALL = {"Rhahk'Zor", "Sneed", "Gilnid", "Mr. Smite", "Captain Greenskin", "Edwin VanCleef"}
local SCENARIO_A = {
    {day = 0, hour = 20, bosses = {"Rhahk'Zor", "Sneed"}, left = true},
    {day = 2, hour = 20.5, bosses = ALL, with = "bryn"},
    {day = 3, hour = 21, bosses = ALL, death = "Mr. Smite", rez = true, with = "bryn"},
    {day = 6, hour = 19, bosses = ALL},
    {day = 9, hour = 20, bosses = ALL, with = "bryn"},
}
local SCENARIO_B = {
    {day = 0, hour = 20, bosses = ALL, with = "bryn"},
    {day = 1, hour = 20.5, bosses = ALL, with = "bryn"},
    {day = 3, hour = 21, bosses = ALL, with = "bryn"},
    {day = 5, hour = 19.5, bosses = ALL, death = "Gilnid", rez = true, with = "bryn"},
    {day = 8, hour = 20, bosses = {"Rhahk'Zor", "Sneed"}, left = true, with = "bryn"},
    {day = 10, hour = 20, bosses = {"Rhahk'Zor", "Sneed", "Gilnid", "Mr. Smite", "Captain Greenskin"}, deathAt = "Edwin VanCleef", left = true, with = "bryn"},
}
-- Build the own journal and the companion's journal from one log.
local function Build(runs)
    local own, bryn = {}, {}
    for _, r in ipairs(runs) do
        local t = At(r.day, r.hour)
        local level = 18 + r.day
        -- Westfall first: the walk to the mines.
        own[#own + 1] = {k = "play", t = t, e = t + 600, z = "Westfall", pl = level}
        local tIn = t + 600
        local minutes = #r.bosses * 9 + 15
        local tOut = tIn + minutes * 60
        own[#own + 1] = {k = "play", t = tIn, e = tOut, z = "The Deadmines", pl = level}
        own[#own + 1] = {k = "dungeon", d = "The Deadmines", z = "The Deadmines", t = tIn + 60, pl = level, r = "damage"}
        if r.with then
            own[#own + 1] = {k = "with", d = r.with, n = "Bryn-Forever", t = t, e = tOut + (r.left and 900 or 0)}
            bryn[#bryn + 1] = {k = "group", t = t, e = tOut + (r.left and 900 or 0), z = "Westfall", pl = level, ol = level}
            bryn[#bryn + 1] = {k = "group", t = tIn, e = tOut, z = "The Deadmines", pl = level, ol = level}
            bryn[#bryn + 1] = {k = "dungeon", d = "The Deadmines", z = "The Deadmines", t = tIn + 60, pl = level, ol = level, r = "damage", tr = "healer"}
        end
        local at = tIn + 300
        for _, b in ipairs(r.bosses) do
            if r.death == b then
                own[#own + 1] = {k = "death", w = "you", d = b, boss = b, z = "The Deadmines", sz = "The Deadmines", t = at, pl = level}
                if r.rez then own[#own + 1] = {k = "rez", t = at + 60, z = "The Deadmines", pl = level} end
                if r.with then
                    bryn[#bryn + 1] = {k = "death", w = "you", d = b, boss = b, z = "The Deadmines", t = at, pl = level, ol = level}
                    if r.rez then bryn[#bryn + 1] = {k = "rez", t = at + 60, z = "The Deadmines", pl = level, ol = level} end
                end
                at = at + 180
            end
            own[#own + 1] = {k = "boss", d = b, z = "The Deadmines", t = at, pl = level, n = r.with and 2 or 1}
            if r.with then bryn[#bryn + 1] = {k = "boss", d = b, z = "The Deadmines", t = at, pl = level, ol = level} end
            at = at + 540
        end
        if r.deathAt then
            own[#own + 1] = {k = "death", w = "you", d = r.deathAt, boss = r.deathAt, z = "The Deadmines", sz = "The Deadmines", t = at, pl = level}
            if r.with then bryn[#bryn + 1] = {k = "death", w = "you", d = r.deathAt, boss = r.deathAt, z = "The Deadmines", t = at, pl = level, ol = level} end
        end
        if r.left then
            own[#own + 1] = {k = "play", t = tOut, e = tOut + 900, z = "Westfall", pl = level}
            if r.with then bryn[#bryn + 1] = {k = "group", t = tOut, e = tOut + 900, z = "Westfall", pl = level, ol = level} end
        end
    end
    local me = {self = true, charKey = "dm", name = "Aldric", race = "Human", faction = "Alliance", class = "ROGUE", startLevel = 18, journal = own}
    local companion = {name = "Bryn-Forever", race = "Dwarf", class = "PRIEST", pronouns = "she", journal = bryn, key = "bryn"}
    return me, companion
end
local PLAYER = {name = "Aldric", race = "Human", faction = "Alliance", class = "ROGUE", charKey = "dm"}
local function OwnTell(me, brief, retell, label)
    A.SelfPerson = function() return me end
    local days = A.JournalBook(me)
    local stories = A.SelfTale.Tell(me, days, brief, retell)
    local out = {}
    for _, d in ipairs(days) do
        local s = stories[d.key]
        if s and s.text ~= "" then
            out[#out + 1] = {plain = A.JournalPlain(s.text), text = s.text, title = tostring(s.title)}
            if show and retell == 0 then print(("[%s own%s %d] %s\n%s\n"):format(label, brief and " Highlights" or "", #out, tostring(s.title), out[#out].plain)) end
        end
    end
    return out
end
local function CompanionTell(me, companion, voice, brief, retell, label)
    A.SelfPerson = function() return me end
    companion.retell = retell
    local days = A.JournalBook(companion)
    local stories = A.JournalTale.Tell(companion, days, voice, PLAYER, brief)
    local out = {}
    for _, d in ipairs(days) do
        local s = stories[d.key]
        if s and s.text ~= "" then
            out[#out + 1] = {plain = A.JournalPlain(s.text), text = s.text, title = A.JournalPlain(s.title or "")}
            if show and retell == 0 then print(("[%s %s%s %d] %s\n%s\n"):format(label, voice, brief and " Highlights" or "", #out, out[#out].title, out[#out].plain)) end
        end
    end
    return out
end
-- The sentences of a chapter that name the place: none may repeat across the chapters of one book.
local function EntrySentences(plain)
    local list = {}
    for _, s in ipairs(Sentences(plain)) do if s:find("Deadmines", 1, true) then list[#list + 1] = s end end
    return list
end
local function CommonChecks(chapters, label)
    local firsts, entries = {}, {}
    for i, c in ipairs(chapters) do
        Clean(c.plain, c.text)
        local first = Sentences(c.plain)[1] or ""
        check(not firsts[first], "no opening sentence twice (" .. label .. "): " .. first)
        firsts[first] = true
        for _, s in ipairs(EntrySentences(c.plain)) do
            check(not entries[s], "no entry sentence twice in a book (" .. label .. " " .. i .. "): " .. s)
            entries[s] = true
        end
    end
end

-- Scenario A --------------------------------------------------------------------------
do
    local me, bryn = Build(SCENARIO_A)
    for _, brief in ipairs({false, true}) do
        for retell = 0, 7 do
            local label = "A own" .. (brief and " brief" or "") .. " " .. retell
            local chapters = OwnTell(me, brief, retell, label)
            check(#chapters == 5, "five chapters (" .. label .. ")")
            CommonChecks(chapters, label)
            -- Run 1: two bosses, then out. Never VanCleef's fall; the unfinished descent is said, in both editions.
            local one = chapters[1].plain
            check(not ClaimsVanCleef(one), "run 1 never claims VanCleef (" .. label .. "): " .. tostring(ClaimsVanCleef(one)) .. " | " .. one)
            check(one:find("Rhahk'Zor", 1, true) and one:find("Sneed", 1, true), "run 1 names its two kills (" .. label .. "): " .. one)
            check(SaysUnfinished(one), "run 1 reads as unfinished (" .. label .. "): " .. one)
            -- Run 2: the return that finished it (Everything).
            local two = chapters[2].plain
            check(two:find("VanCleef", 1, true), "run 2 reaches VanCleef (" .. label .. "): " .. two)
            if not brief then check(SaysReturn(two), "run 2 reads as the return that finished it (" .. label .. "): " .. two) end
            check(two:find("lost its master", 1, true), "the lord's first fall has its consequence (" .. label .. "): " .. two)
            -- Run 3: the death to Mr. Smite, and the rescue.
            local three = chapters[3].plain
            check(three:find("Smite", 1, true) and (three:find("killed me", 1, true) or three:find("cut me down", 1, true) or three:find("died", 1, true)
                or three:find("death", 1, true) or three:find("end of me", 1, true) or three:find("got me", 1, true) or three:find("laid me low", 1, true)),
                "run 3 tells the death (" .. label .. "): " .. three)
            -- Runs 4 and 5: a place grown familiar; the consequence is not repeated.
            for n = 3, 5 do
                check(not chapters[n].plain:find("lost its master", 1, true), "the consequence is said once (" .. label .. " " .. n .. "): " .. chapters[n].plain)
                check(not chapters[n].plain:find("first time", 1, true) or chapters[n].plain:find("Bryn", 1, true), "no first time on a later run (" .. label .. " " .. n .. "): " .. chapters[n].plain)
            end
        end
    end
    for _, voice in ipairs({"you", "we"}) do
        for _, brief in ipairs({false, true}) do
            for retell = 0, 7 do
                local label = "A " .. voice .. (brief and " brief" or "") .. " " .. retell
                local chapters = CompanionTell(me, bryn, voice, brief, retell, label)
                check(#chapters == 3, "three chapters with Bryn (" .. label .. ")")
                CommonChecks(chapters, label)
                for i, c in ipairs(chapters) do
                    if voice == "we" then check(not c.plain:find("%f[%a][Yy]ou%f[%A]") and not c.plain:find("%f[%a][Yy]our%f[%A]"), "the diary never says you (" .. label .. "): " .. c.plain) end
                    check(c.plain:find("VanCleef", 1, true), "every run with Bryn reaches VanCleef (" .. label .. " " .. i .. "): " .. c.plain)
                    if i > 1 then check(not c.plain:find("lost its master", 1, true), "the consequence once (" .. label .. " " .. i .. "): " .. c.plain) end
                end
                check(chapters[2].plain:find("Smite", 1, true), "the death to Mr. Smite in Bryn's second chapter (" .. label .. "): " .. chapters[2].plain)
            end
        end
    end
end

-- Scenario B --------------------------------------------------------------------------
do
    local me, bryn = Build(SCENARIO_B)
    for _, brief in ipairs({false, true}) do
        for retell = 0, 7 do
            local label = "B own" .. (brief and " brief" or "") .. " " .. retell
            local chapters = OwnTell(me, brief, retell, label)
            check(#chapters == 6, "six chapters (" .. label .. ")")
            CommonChecks(chapters, label)
            for n = 1, 4 do
                check(chapters[n].plain:find("VanCleef", 1, true), "run " .. n .. " reaches VanCleef (" .. label .. "): " .. chapters[n].plain)
                check((n == 1) == (chapters[n].plain:find("lost its master", 1, true) ~= nil), "the consequence on the first fall only (" .. label .. " " .. n .. "): " .. chapters[n].plain)
            end
            check(chapters[4].plain:find("Gilnid", 1, true), "the death to Gilnid is in run 4 (" .. label .. "): " .. chapters[4].plain)
            -- Run 5: a veteran of the place, out after Sneed.
            local five = chapters[5].plain
            check(not ClaimsVanCleef(five), "run 5 never claims VanCleef (" .. label .. "): " .. tostring(ClaimsVanCleef(five)) .. " | " .. five)
            check(SaysUnfinished(five), "run 5 reads as unfinished (" .. label .. "): " .. five)
            if not brief then
                check(five:find("had been to the bottom", 1, true) or five:find("first time", 1, true) or five:find("had reached", 1, true)
                    or five:find("For once", 1, true) or five:find("before, and", 1, true) or five:find("knew", 1, true),
                    "run 5 reads as a veteran falling short (" .. label .. "): " .. five)
            end
            -- Run 6: dead at VanCleef, the Defias master alive; nothing wraps it up.
            local six = chapters[6].plain
            check(six:find("VanCleef", 1, true), "run 6 names VanCleef (" .. label .. "): " .. six)
            check(not ClaimsVanCleef(six), "run 6 never claims VanCleef (" .. label .. "): " .. tostring(ClaimsVanCleef(six)) .. " | " .. six)
            check(six:find("killed me", 1, true) or six:find("cut me down", 1, true) or six:find("died", 1, true) or six:find("death", 1, true)
                or six:find("end of me", 1, true) or six:find("got me", 1, true) or six:find("laid me low", 1, true) or six:find("beat", 1, true),
                "run 6 tells the death at VanCleef (" .. label .. "): " .. six)
            local last = Sentences(six)
            local closing = last[#last] or ""
            check(not closing:find("quieter", 1, true) and not closing:find("lost its", 1, true) and not closing:find("rid of", 1, true),
                "the last word stays unfinished (" .. label .. "): " .. closing)
        end
    end
    for _, voice in ipairs({"you", "we"}) do
        for _, brief in ipairs({false, true}) do
            for retell = 0, 7 do
                local label = "B " .. voice .. (brief and " brief" or "") .. " " .. retell
                local chapters = CompanionTell(me, bryn, voice, brief, retell, label)
                check(#chapters == 6, "six chapters with Bryn (" .. label .. ")")
                CommonChecks(chapters, label)
                local consequences = 0
                for i, c in ipairs(chapters) do
                    if voice == "we" then check(not c.plain:find("%f[%a][Yy]ou%f[%A]") and not c.plain:find("%f[%a][Yy]our%f[%A]"), "the diary never says you (" .. label .. "): " .. c.plain) end
                    if c.plain:find("lost its master", 1, true) or c.plain:find("was dead", 1, true) then consequences = consequences + 1 end
                    if i <= 4 then check(c.plain:find("VanCleef", 1, true), "run " .. i .. " reaches VanCleef (" .. label .. "): " .. c.plain) end
                end
                check(consequences <= 1, "the lord's consequence at most once in a book (" .. label .. ")")
                for n = 5, 6 do
                    check(not ClaimsVanCleef(chapters[n].plain), "run " .. n .. " never claims VanCleef (" .. label .. "): " .. tostring(ClaimsVanCleef(chapters[n].plain)) .. " | " .. chapters[n].plain)
                    check(SaysUnfinished(chapters[n].plain), "run " .. n .. " reads as unfinished (" .. label .. "): " .. chapters[n].plain)
                end
                check(chapters[6].plain:find("VanCleef", 1, true), "run 6 names VanCleef (" .. label .. "): " .. chapters[6].plain)
                local last = Sentences(chapters[6].plain)
                local closing = last[#last] or ""
                check(not closing:find("quieter", 1, true) and not closing:find("lost its", 1, true), "the last word stays unfinished (" .. label .. "): " .. closing)
            end
        end
    end
end

print("PASS: " .. assertions .. " dungeon-repeat assertions")
