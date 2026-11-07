-- Run from the client root: lua5.1 Interface/AddOns/CompanionJournal/tests/Editor2Tells.lua [print]
-- The second editor pass of 2026-11-05: the companion book as a shared history.
-- Two voices: the diary ("we") is one of the two writing what both lived
-- through ("Dahlia and I", "the two of us", "between us") and never says "you"
-- nor praises its writer; the game master ("you") recaps a campaign ("your
-- party", "the pair of you"). Highlights: a title-only middle stage of a chain
-- is dropped and its day bridged, an exact stage is kept, a second fire on a
-- dungeon day and a handful of herbs are left to Everything. A lord killed
-- before the final kill stays in one sentence with the kills around it. A
-- quest title's own "... and Bugs" keeps its small "and". An outcome that
-- opens on its own place ("At the waystation, ...") takes no "In X," in front.
-- A death and the rescue join without a stray capital.
local root = "Interface/AddOns/CompanionJournal/"
local assertions = 0
local function check(value, message) assertions = assertions + 1; assert(value, message) end
local show = arg and arg[1] == "print"

function time(t) if type(t) == "table" then return os.time(t) end return 1790000000 + 40 * 86400 end
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
local T, PB = A.JournalTale, A.JournalTale.phrases

local BASE = os.time({year = 2026, month = 9, day = 1, hour = 0})
local function At(day, hour, minute) return BASE + day * 86400 + math.floor((hour or 20) * 3600) + (minute or 0) * 60 end
local function Dahlia() return {name = "Dahlia-Forever", race = "Scourge", class = "PRIEST", pronouns = "she", bond = "spouse", journal = {}, key = "dahlia"} end
local PLAYER = {name = "Alberich", race = "Scourge", faction = "Horde", class = "PALADIN", charKey = "alb"}
-- One outing: events are {k = ..., ...} tables placed every five minutes.
local function Group(p, day, zone, minutes, events)
    local t = At(day)
    p.journal[#p.journal + 1] = {k = "group", t = t, e = t + minutes * 60, z = zone, pl = 20, ol = 20}
    for i, ev in ipairs(events or {}) do
        local entry = {t = t + i * 300, z = zone, pl = 20, ol = 20}
        for key, value in pairs(ev) do entry[key] = value end
        p.journal[#p.journal + 1] = entry
    end
end
local function Tell(p, voice, brief, retell)
    p.retell = retell
    local days = A.JournalBook(p)
    local stories = A.JournalTale.Tell(p, days, voice, PLAYER, brief)
    local out = {}
    for i, d in ipairs(days) do
        local s = stories[d.key]
        -- (prose: the text with the quest titles taken out, for the checks on the teller's own words)
        out[i] = {plain = s and A.JournalPlain(s.text) or "", title = s and A.JournalPlain(s.title or "") or "",
            prose = s and A.JournalPlain((s.text:gsub("{q:[^}]*}", "Q"))) or ""}
        if show and retell == 0 then print(("[%s%s %d] %s\n%s\n"):format(voice, brief and " Highlights" or "", i, out[i].title, out[i].plain)) end
    end
    return out
end
local function Sentences(text)
    local list = {}
    for s in text:gmatch("[^%.!%?]+[%.!%?]") do list[#list + 1] = s end
    return list
end

-- 1. A small shared life: the voices, the lord in the roll, the rescue joined, the boast --------
A.SelfPerson = function() return nil end
do
    local p = Dahlia()
    Group(p, 0, "Tirisfal Glades", 90, {{k = "quest", d = "The Mindless Ones"}, {k = "quest", d = "Rattling the Rattlecages"}, {k = "campfire"}})
    Group(p, 1, "Tirisfal Glades", 80, {{k = "quest", d = "Deaths in the Family"}, {k = "rest", d = "Brill"}})
    Group(p, 2, "Silverpine Forest", 100, {{k = "quest", d = "The Family Crypt"}, {k = "quest", d = "Prove Your Worth"}})
    Group(p, 3, "Ragefire Chasm", 70, {{k = "dungeon", d = "Ragefire Chasm", z = "Ragefire Chasm", r = "tank", tr = "healer"},
        {k = "boss", d = "Oggleflint"}, {k = "death", w = "you", d = "Searing Blade Cultist", a = true}, {k = "rez"},
        {k = "boss", d = "Taragaman the Hungerer", n = 3, me = {d = 1, ds = 45, t = 1}, them = {h = 1, hs = 70}},
        {k = "boss", d = "Jergosh the Invoker"}, {k = "boss", d = "Bazzalan"}})
    Group(p, 4, "Silverpine Forest", 60, {{k = "quest", d = "Arugal's Folly"}, {k = "campfire"}})
    Group(p, 6, "The Barrens", 60, {{k = "quest", d = "... and Bugs"}})
    local markers = {we = {" and I ", "the two of us", "between us", "my wife"}, you = {"your party", "the pair of you", "your wife"}}
    for _, voice in ipairs({"we", "you"}) do
        local voiced = false
        for _, brief in ipairs({false, true}) do
            for retell = 0, 7 do
                local out = Tell(p, voice, brief, retell)
                local all, prose = {}, {}
                for i, c in ipairs(out) do all[#all + 1] = c.plain; prose[#prose + 1] = c.prose end
                local text = table.concat(all, "\n")
                prose = table.concat(prose, "\n")
                check(not text:find("{%a+}"), "no raw token (" .. voice .. "): " .. text)
                if voice == "we" then
                    check(not prose:find("%f[%a][Yy]ou%f[%A]") and not prose:find("%f[%a][Yy]our%f[%A]"), "the diary never says you: " .. prose)
                    check(not text:find("I did more than anyone", 1, true) and not text:find("fell mostly to my", 1, true)
                        and not text:find("never got past me", 1, true), "the diary never praises its writer: " .. text)
                end
                for _, m in ipairs(markers[voice]) do if text:lower():find(m, 1, true) then voiced = true end end
                check(not text:find(", and It ", 1, true) and not text:find(", and The ", 1, true), "a joined clause keeps no capital: " .. text)
                check(not text:find(",%."), "no ',.' left where a place was dropped: " .. text)
                -- the lord fell between the kills: one sentence with the kills around it
                local ragefire = out[4].plain
                local joined = false
                for _, s in ipairs(Sentences(ragefire)) do
                    if s:find("Taragaman", 1, true) and s:find("Bazzalan", 1, true) and s:find("Jergosh", 1, true) then joined = true end
                end
                check(joined, "a lord killed before the final kill stays in the roll (" .. voice .. " " .. retell .. "): " .. ragefire)
                check(ragefire:find("Cultist", 1, true), "the death before the lord is told: " .. ragefire)
                check(ragefire:find("brought", 1, true) or ragefire:find("bring", 1, true) or ragefire:find("raised", 1, true) or ragefire:find("prayed", 1, true)
                    or ragefire:find("prayers", 1, true) or ragefire:find("back on", 1, true) or ragefire:find("feet", 1, true), "the rescue is told: " .. ragefire)
                -- the quest title keeps its own small "and"
                local bugs = out[6].plain .. " " .. out[6].title
                check(not bugs:find("And Bugs", 1, true), "a title's '... and Bugs' keeps its small and: " .. bugs)
                check(brief or bugs:find("... and Bugs", 1, true), "the quest is named: " .. bugs)
            end
        end
        check(voiced, "the " .. voice .. " voice has its own lines somewhere in the book")
    end
end

-- 2. Highlights: a title-only middle stage is dropped and its day bridged; an exact stage is kept ----
do
    -- a chain of three title-only stages (the packs' shared-title entries), in recorded order
    local byThread = {}
    for title, story in pairs(A.Lore.questStory) do
        local city = A.Lore.Zone and A.Lore.Zone(story.zone) and A.Lore.Zone(story.zone).kind == "city"
        if story.thread and story.after and #story.after > 0 and (story.importance or 1) <= 3 and story.zone and not city and not title:find("[!?]") then
            byThread[story.thread] = byThread[story.thread] or {}
            table.insert(byThread[story.thread], title)
        end
    end
    local threads = {}
    for thread, titles in pairs(byThread) do if #titles >= 3 then threads[#threads + 1] = thread end end
    table.sort(threads)
    check(#threads > 0, "a thread with three title-only stages exists")
    local titles = byThread[threads[1]]
    table.sort(titles)
    local zone = A.Lore.questStory[titles[1]].zone
    -- (the first three days together are formative and always kept: the middle stage falls on the fourth)
    local p = Dahlia()
    Group(p, 0, zone, 60, {{k = "quest", d = titles[1]}})
    Group(p, 1, zone, 60, {{k = "quest", d = "Recorded Errand"}})
    Group(p, 2, zone, 60, {{k = "quest", d = "Recorded Errand"}})
    Group(p, 3, zone, 60, {{k = "quest", d = titles[2]}})
    Group(p, 4, zone, 60, {{k = "quest", d = titles[3]}})
    -- (2026-11-07, DESIGN §3.0: the companion book tells a stage by its name, act or point of
    -- view, not by its authored outcome prose)
    local function Outcome(text, title)
        return A.QuestDeeds.Shows(text, nil, title) ~= nil
    end
    for _, voice in ipairs({"we", "you"}) do
        for retell = 0, 5 do
            local full, brief = Tell(p, voice, false, retell), Tell(p, voice, true, retell)
            -- (a quiet day may be told with the next one in Everything)
            check(Outcome(full[4].plain .. " " .. full[5].plain, titles[2]), "Everything tells the middle stage: " .. full[4].plain .. " | " .. full[5].plain)
            check(not Outcome(brief[4].plain, titles[2]), "Highlights drops a title-only middle stage: " .. brief[4].plain)
            check(brief[4].plain == "", "the dropped day is bridged, not left as a stub: " .. brief[4].plain)
            check(brief[5].plain:find("followed", 1, true) or brief[5].plain:find("came next", 1, true) or brief[5].plain:find("more days", 1, true) or brief[5].plain:find("next two", 1, true), "the next chapter bridges the day: " .. brief[5].plain)
            check(Outcome(brief[5].plain, titles[3]), "the chain's last stage stays in Highlights: " .. brief[5].plain)
            check(Outcome(brief[1].plain, titles[1]), "the chain's first stage stays in Highlights: " .. brief[1].plain)
        end
    end
    -- an exact stage (quest ID) keeps its scene in Highlights, whatever its place in a chain
    local ids = {}
    for id, s in pairs(A.Lore.questStoryIDs) do if s.zone and s.thread and (s.importance or 1) <= 3 then ids[#ids + 1] = id end end
    table.sort(ids)
    local s1, s2 = A.Lore.questStoryIDs[ids[1]], A.Lore.questStoryIDs[ids[2]]
    local q = Dahlia()
    Group(q, 0, s1.zone, 60, {{k = "quest", d = s1.title, qid = ids[1]}})
    Group(q, 1, s2.zone, 60, {{k = "quest", d = s2.title, qid = ids[2]}})
    Group(q, 2, s2.zone, 60, {{k = "quest", d = "Recorded Errand"}})
    for retell = 0, 3 do
        local brief = Tell(q, "you", true, retell)
        local kept = A.QuestDeeds.Shows(brief[2].plain, ids[2]) ~= nil
        check(kept, "an exact stage keeps its scene in Highlights: " .. brief[2].plain)
    end
end

-- 3. Highlights: a second fire on a dungeon day and a handful of herbs stay in Everything ----
do
    local p = Dahlia()
    local me = {self = true, charKey = "alb", name = "Alberich", race = "Scourge", faction = "Horde", class = "PALADIN", startLevel = 1, journal = {}}
    A.SelfPerson = function() return me end
    Group(p, 0, "Silverpine Forest", 90, {{k = "quest", d = "Deaths in the Family"}, {k = "campfire"}})
    Group(p, 1, "Silverpine Forest", 90, {{k = "quest", d = "The Family Crypt"}, {k = "death", w = "you", d = "Moonrage Whitescalp"}})
    Group(p, 2, "Shadowfang Keep", 80, {{k = "dungeon", d = "Shadowfang Keep", z = "Shadowfang Keep"}, {k = "boss", d = "Baron Silverlaine"},
        {k = "boss", d = "Archmage Arugal"}, {k = "campfire", z = "Silverpine Forest"}})
    me.journal = {{k = "play", t = At(1), e = At(1) + 5400, z = "Silverpine Forest", pl = 20},
        {k = "gather", d = "herbs", c = 12, t = At(1) + 900, z = "Silverpine Forest"}}
    for _, voice in ipairs({"we", "you"}) do
        for retell = 0, 5 do
            local full, brief = Tell(p, voice, false, retell), Tell(p, voice, true, retell)
            check(full[2].plain:find("herb", 1, true), "Everything keeps the herbs picked together: " .. full[2].plain)
            check(not brief[2].plain:find("herb", 1, true), "Highlights leaves a handful of herbs out: " .. brief[2].plain)
            check(full[3].plain:find("fire", 1, true) or full[3].plain:find("camp", 1, true), "Everything keeps the fire after the keep: " .. full[3].plain)
            check(not brief[3].plain:find("fire", 1, true) and not brief[3].plain:find("camp", 1, true), "Highlights leaves a second fire out: " .. brief[3].plain)
            check(brief[1].plain:find("fire", 1, true) or brief[1].plain:find("camp", 1, true), "Highlights keeps the first fire shared: " .. brief[1].plain)
            check(brief[3].plain:find("Arugal", 1, true), "Highlights keeps the lord: " .. brief[3].plain)
        end
    end
    A.SelfPerson = function() return nil end
end

-- 4. An outcome that opens on its own place takes no "In X," in front ------------------------
do
    check(T.PlaceLed("At Aerie Peak, the trolls were counted.") and T.PlaceLed("Back at the Sepulcher, word spread.")
        and T.PlaceLed("Inside the keep, the worgen howled."), "place-led lines are recognized")
    check(not T.PlaceLed("The ring was Deliah's.") and not T.PlaceLed("Sevren confirmed the name.") and not T.PlaceLed("Attacks on the farm ended."),
        "other lines are not")
    -- a companion day in two zones: the second outing's exact stage opens on its own place
    local placed
    local ids = {}
    for id in pairs(A.Lore.questStoryIDs) do ids[#ids + 1] = id end
    table.sort(ids)
    for _, id in ipairs(ids) do
        local s = A.Lore.questStoryIDs[id]
        if not placed and s.zone and s.after and s.after[1]:match("^At ") and s.after[2] and s.after[2]:match("^At ") then placed = id end
    end
    if not placed then
        for _, id in ipairs(ids) do
            local s = A.Lore.questStoryIDs[id]
            if not placed and s.zone and s.after and s.after[1]:match("^At ") then placed = id end
        end
    end
    check(placed, "a pack outcome that opens on its own place exists")
    local s = A.Lore.questStoryIDs[placed]
    local other
    for _, id in ipairs(ids) do
        local o = A.Lore.questStoryIDs[id]
        if not other and o.zone and o.zone ~= s.zone and o.after and not T.PlaceLed(o.after[1]) and not T.PlaceLed(o.after[2] or "") then other = id end
    end
    local o = A.Lore.questStoryIDs[other]
    local p = Dahlia()
    local t = At(0)
    p.journal[#p.journal + 1] = {k = "group", t = t, e = t + 5400, z = o.zone, pl = 20, ol = 20}
    p.journal[#p.journal + 1] = {k = "quest", d = o.title, qid = other, t = t + 1200, z = o.zone, pl = 20, ol = 20}
    p.journal[#p.journal + 1] = {k = "group", t = t + 6000, e = t + 7800, z = s.zone, pl = 20, ol = 20}
    p.journal[#p.journal + 1] = {k = "quest", d = s.title, qid = placed, t = t + 6600, z = s.zone, pl = 20, ol = 20}
    for _, voice in ipairs({"we", "you"}) do
        for _, brief in ipairs({false, true}) do
            for retell = 0, 5 do
                local out = Tell(p, voice, brief, retell)
                local text = out[1].plain
                check(not text:find("[Ii]n [^%.]-, At "), "no place in front of a place-led outcome: " .. text)
                check(not text:find("[Ii]n [^%.]-, Back at ") and not text:find("[Ii]n [^%.]-, Inside "), "no place in front of a place-led outcome: " .. text)
            end
        end
    end
    -- your own book: the same outcome after a dungeon anchors with "by then", never "In X, At"
    local me = {self = true, charKey = "alb", name = "Alberich", race = "Scourge", faction = "Horde", class = "PALADIN", startLevel = 1, journal = {}}
    local t2 = At(3)
    me.journal = {
        {k = "play", t = t2, e = t2 + 3600, z = "Shadowfang Keep", pl = 20},
        {k = "dungeon", d = "Shadowfang Keep", z = "Shadowfang Keep", t = t2 + 60, pl = 20},
        {k = "boss", d = "Archmage Arugal", z = "Shadowfang Keep", t = t2 + 1800, pl = 20},
        {k = "play", t = t2 + 3700, e = t2 + 7200, z = s.zone, pl = 20},
        {k = "quest", d = s.title, qid = placed, t = t2 + 5000, z = s.zone, pl = 20},
    }
    for retell = 0, 7 do
        local days = A.JournalBook(me)
        local stories = A.SelfTale.Tell(me, days, false, retell)
        local text = A.JournalPlain(stories[days[1].key].text)
        check(not text:find("[Ii]n [^%.]-, At ") and not text:find("[Ii]n [^%.]-, at the"), "your own book: no place in front of a place-led outcome: " .. text)
    end
end

-- 5. Shared moments reaching the companion book: your raise of them, your first time in a
-- country, a cave and a battleground entered together, a first mount --------------------------
do
    local p = Dahlia()
    local me = {self = true, charKey = "alb", name = "Alberich", race = "Scourge", faction = "Horde", class = "PALADIN", startLevel = 1, journal = {}}
    A.SelfPerson = function() return me end
    -- day 0: her death and your raise of her (recorded with more moments on)
    Group(p, 0, "Silverpine Forest", 90, {{k = "quest", d = "Deaths in the Family"}, {k = "death", w = "them"}, {k = "rez", w = "you"}})
    -- day 1: your own first time in the Hillsbrad Foothills, a cave, with her
    Group(p, 1, "Hillsbrad Foothills", 90, {{k = "quest", d = "Elixir of Suffering"}})
    -- day 2: a battleground together, and your first mount
    Group(p, 2, "Warsong Gulch", 60, {})
    me.journal = {
        {k = "play", t = At(1), e = At(1) + 5400, z = "Hillsbrad Foothills", pl = 40},
        {k = "first", d = "zone", z = "Hillsbrad Foothills", t = At(1) + 30},
        {k = "cave", d = "Azurelode Mine", t = At(1) + 1800, z = "Hillsbrad Foothills"},
        {k = "play", t = At(2), e = At(2) + 3600, z = "Warsong Gulch", pl = 40},
        {k = "bg", d = "Warsong Gulch", z = "Warsong Gulch", t = At(2) + 60},
        {k = "first", d = "mount", n = "skeletal horse", t = At(2) + 2400, z = "Warsong Gulch"},
    }
    for _, voice in ipairs({"we", "you"}) do
        for _, brief in ipairs({false, true}) do
            for retell = 0, 7 do
                local out = Tell(p, voice, brief, retell)
                local raise = out[1].plain
                check(raise:find("brought", 1, true) or raise:find("raised", 1, true) or raise:find("rose", 1, true)
                    or raise:find("feet", 1, true) or raise:find("came back", 1, true), "your raise of her is told (" .. voice .. "): " .. raise)
                check(not raise:find("Dahlia brought", 1, true) and not raise:find("Dahlia raised", 1, true), "not as hers of you: " .. raise)
                local first = out[2].plain
                check(first:find("Hillsbrad", 1, true) and (first:find("first time", 1, true) or first:find("never", 1, true) or first:find("new ground", 1, true)
                    or first:find("new to", 1, true)),
                    "your own first time in the country, while together (" .. voice .. "): " .. first)
                check(brief or first:find("Azurelode Mine", 1, true), "the cave entered together: " .. first)
                check(not brief or not first:find("Azurelode Mine", 1, true), "Highlights leaves the cave out: " .. first)
                local gulch = out[3].plain
                check(gulch:find("Warsong Gulch", 1, true), "the battleground together: " .. gulch)
                check(gulch:find("mount", 1, true), "your first mount, with her along: " .. gulch)
                if voice == "we" then check(not gulch:find("%f[%a][Yy]ou%f[%A]"), "the diary never says you: " .. gulch) end
            end
        end
    end
    A.SelfPerson = function() return nil end
end

io.write("PASS: " .. assertions .. " editor2 assertions\n")
