-- Run from the client root: lua5.1 Interface/AddOns/CompanionJournal/tests/MomentsContinuity.lua [print]
-- Continuity inside one book, bounded by the record: a foe that killed you
-- before, a boss avenged on a later day, a return to a place where you died,
-- the tenth day out with a companion, the hundredth quest, a thread taken up
-- again after a week, a late "first continent" that is no first, a companion
-- who died twice in one stretch, and kills in one visit joined in one sentence.
-- Every telling 0 to 7, Everything and Highlights.
local root = "Interface/AddOns/CompanionJournal/"
local assertions = 0
local function check(value, message) assertions = assertions + 1; assert(value, message) end
local show = arg and arg[1] == "print"

function time(t) if type(t) == "table" then return os.time(t) end return 1790000000 + 40 * 86400 end
function date(fmt, t) return os.date(fmt, t) end
local A = {defaults = {colors = {}}}
for _, file in ipairs({"LoreData.lua", "Lore.lua", "JournalBook.lua", "JournalEpisodes.lua", "JournalSelfWords.lua", "JournalSelfTale.lua"}) do
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
local function Clean(p)
    for _, brief in ipairs({false, true}) do
        for retell, chapters in pairs(Tellings(p, brief)) do
            for _, c in ipairs(chapters) do
                check(not c.text:find("{%a+}"), "no raw token (" .. retell .. "): " .. c.text)
                check(not c.text:gsub("{%a:[^}]*}", ""):find(":", 1, true), "no colons: " .. c.plain)
                check(not c.plain:find("  ", 1, true) and not c.plain:find(" %."), "clean spacing: " .. c.plain)
            end
        end
    end
end

-- 1. Hogger kills you twice, weeks apart; the Defias master who killed you falls three days later;
-- back in Elwynn after a month, where Hogger did it.
do
    local j = {}
    Stretch(j, At(0, 19), 90, "Elwynn Forest", 8, Join({{k = "town", d = "Goldshire"}, {k = "death", w = "you", d = "Hogger"}}, Q({"Wanted: \"Hogger\""})))
    Stretch(j, At(2, 20), 90, "Westfall", 12, Join({{k = "death", w = "you", d = "Hogger"}}, Q({"The Killing Fields"})))
    Stretch(j, At(4, 20), 60, "The Deadmines", 18, {{k = "dungeon", d = "The Deadmines"}, {k = "boss", d = "Mr. Smite"},
        {k = "death", w = "you", d = "Edwin VanCleef", boss = "Edwin VanCleef"}, {k = "wipe", d = "Edwin VanCleef"}})
    Stretch(j, At(7, 20), 60, "The Deadmines", 19, {{k = "dungeon", d = "The Deadmines"}, {k = "boss", d = "Mr. Smite"}, {k = "boss", d = "Captain Greenskin"},
        {k = "boss", d = "Edwin VanCleef"}})
    Stretch(j, At(40, 20), 60, "Elwynn Forest", 24, Join({{k = "town", d = "Goldshire"}}, Q({"Red Linen Goods"})))
    local p = {self = true, charKey = "hog", name = "Edric", race = "Human", faction = "Alliance", class = "WARRIOR", startLevel = 1, journal = j}
    Clean(p)
    for retell, chapters in pairs(Tellings(p)) do
        local two = chapters[2].plain
        check(two:find("Hogger", 1, true) and (two:find("again", 1, true) or two:find("second time", 1, true) or two:find("before", 1, true)),
            "the second death to Hogger says so (" .. retell .. "): " .. two)
        local four = chapters[4].plain
        check(four:find("VanCleef", 1, true) and (four:find("had killed me once", 1, true) or four:find("had beaten me before", 1, true) or four:find("died to", 1, true)),
            "the master who killed you falls on a later day, and it is said: " .. four)
        check(four:find("Mr. Smite and Captain Greenskin", 1, true) or four:find("Mr. Smite, Captain Greenskin", 1, true), "the two kills before it stay one sentence: " .. four)
        local five = chapters[5].plain
        check(five:find("Hogger had killed me", 1, true) or five:find("where Hogger", 1, true) or five:find("where a Hogger", 1, true) == nil and five:find("Hogger", 1, true),
            "back in Elwynn after a month: the place remembers Hogger: " .. five)
    end
end

-- 2. Four lords of Ragefire in one sentence; a hand-in between two of them splits it.
do
    local j = {}
    Stretch(j, At(0, 20), 60, "Ragefire Chasm", 14, {{k = "dungeon", d = "Ragefire Chasm"}, {k = "boss", d = "Oggleflint"}, {k = "boss", d = "Taragaman the Hungerer"},
        {k = "boss", d = "Jergosh the Invoker"}, {k = "boss", d = "Bazzalan"}, {k = "quest", d = "Slaying the Beast"}})
    local p = {self = true, charKey = "rfc", name = "Alberich", race = "Scourge", faction = "Horde", class = "PALADIN", startLevel = 1, journal = j}
    Clean(p)
    for retell, chapters in pairs(Tellings(p)) do
        local one = chapters[1].plain
        -- (2026-11-11: the kills are told around the lord, in order, in the run's one paragraph:
        -- "Past Oggleflint, I came to Taragaman the Hungerer and killed him. Jergosh the Invoker and Bazzalan fell after him.")
        -- (round 2: the quest's boss is the goal, named before the fights: "It was Taragaman ... we had come for.
        -- Past Oggleflint, we reached him and killed him. Jergosh ... and Bazzalan fell after him.")
        local a, b, c, d = one:find("Oggleflint", 1, true), one:find("Taragaman the Hungerer", 1, true), one:find("Jergosh the Invoker", 1, true), one:find("Bazzalan", 1, true)
        check(a and b and c and d and a < c and c < d, "four kills, the last two after the goal (" .. retell .. "): " .. one)
        check(not one:find("Oggleflint, Taragaman the Hungerer, Jergosh the Invoker and Bazzalan", 1, true), "no roll call of four (" .. retell .. "): " .. one)
        local para
        for p in (one .. "\n\n"):gmatch("(.-)\n\n") do if p:find("Oggleflint", 1, true) then para = p end end
        check(para and para:find("Bazzalan", 1, true), "the four kills in one paragraph (" .. retell .. "): " .. one)
    end
    local k = {}
    Stretch(k, At(0, 20), 60, "Ragefire Chasm", 14, {{k = "dungeon", d = "Ragefire Chasm"}, {k = "boss", d = "Oggleflint"}, {k = "boss", d = "Taragaman the Hungerer"},
        {k = "quest", d = "Testing an Enemy's Strength"}, {k = "boss", d = "Jergosh the Invoker"}, {k = "boss", d = "Bazzalan"}})
    local q = {self = true, charKey = "rfc2", name = "Alberich", race = "Scourge", faction = "Horde", class = "PALADIN", startLevel = 1, journal = k}
    for retell, chapters in pairs(Tellings(q)) do
        local one = chapters[1].plain
        check((one:find("Oggleflint and Taragaman the Hungerer", 1, true) or one:find("past Oggleflint and killed Taragaman the Hungerer", 1, true)
            or one:find("Past Oggleflint, I came to Taragaman the Hungerer", 1, true) or one:find("past Oggleflint to Taragaman the Hungerer", 1, true)
            or one:find("Oggleflint fell first", 1, true) or one:find("Oggleflint came first", 1, true))
            and one:find("Jergosh the Invoker and Bazzalan", 1, true),
            "a hand-in between the second and third kill keeps two sentences (" .. retell .. "): " .. one)
    end
end

-- 3. Alberich's real shape: Silverpine and Tirisfal first, then a "first time in the Eastern Kingdoms"
-- recorded weeks later after a hearthstone from Durotar. The claim is dropped; the hearth is told.
do
    local j = {}
    Stretch(j, At(0, 20), 90, "Silverpine Forest", 12, Q({"The Decrepit Ferry"}))
    Stretch(j, At(0, 22), 60, "Tirisfal Glades", 13, Q({"Deliah's Lost Ring"}))
    Stretch(j, At(25, 20), 30, "Durotar", 17, {{k = "hearth", d = "The Sepulcher"}, {k = "voyage", d = "hearth", from = "Kalimdor", to = "Eastern Kingdoms"},
        {k = "first", d = "continent", z = "Eastern Kingdoms"}})
    Stretch(j, At(25, 20, 40), 60, "Silverpine Forest", 17, {{k = "gather", d = "mining", c = 1}})
    local p = {self = true, charKey = "ek", name = "Alberich", race = "Scourge", faction = "Horde", class = "PALADIN", startLevel = 1, journal = j}
    Clean(p)
    for retell, chapters in pairs(Tellings(p)) do
        local last = chapters[#chapters].plain
        check(not last:find("not set foot", 1, true) and not last:find("first time", 1, true) and not last:find("never been", 1, true) and not last:find("new land", 1, true),
            "no first continent after chapters there (" .. retell .. "): " .. last)
        check(last:find("hearthstone", 1, true) or last:find("Eastern Kingdoms", 1, true), "the crossing itself is still told: " .. last)
    end
    -- (the genuine first crossing of a book that began on Kalimdor keeps its claim)
    local k = {}
    Stretch(k, At(0, 20), 90, "Durotar", 12, Q({"Vile Familiars"}))
    Stretch(k, At(2, 20), 60, "Tirisfal Glades", 18, {{k = "voyage", d = "zeppelin", from = "Kalimdor", to = "Eastern Kingdoms"}, {k = "first", d = "zeppelin"},
        {k = "first", d = "continent", z = "Eastern Kingdoms"}})
    local q = {self = true, charKey = "ek2", name = "Thruk", race = "Tauren", faction = "Horde", class = "DRUID", startLevel = 1, journal = k}
    for retell, chapters in pairs(Tellings(q)) do
        local two = chapters[2].plain
        check(two:find("never been", 1, true) or two:find("first time", 1, true) or two:find("new", 1, true), "a true first continent keeps its claim (" .. retell .. "): " .. two)
    end
end

-- 4. Dahlia dies twice in one stretch: one line with the count. Ten days out with her: counted once.
do
    local j = {}
    for day = 0, 9 do
        local t = At(day * 2, 20)
        Stretch(j, t, 60, "The Barrens", 12 + day, Q({"Quest " .. day}))
        j[#j + 1] = {k = "with", d = "dahlia-noir", n = "Dahlia-Noir", t = t, e = t + 3600}
        if day == 3 then
            j[#j + 1] = {k = "pdeath", n = "Dahlia-Noir", t = t + 600, z = "The Barrens"}
            j[#j + 1] = {k = "pdeath", n = "Dahlia-Noir", t = t + 1500, z = "The Barrens"}
        end
    end
    local p = {self = true, charKey = "ten", name = "Alberich", race = "Scourge", faction = "Horde", class = "PALADIN", startLevel = 1, journal = j}
    Clean(p)
    for retell, chapters in pairs(Tellings(p)) do
        local four = chapters[4].plain
        check(four:find("twice", 1, true) and Count(four, "Dahlia") <= 2, "two deaths of hers in one stretch, one line with the count (" .. retell .. "): " .. four)
        check(not four:find("died there%. Dahlia") and not four:find("was killed there", 1, true), "not two death lines in a row: " .. four)
        local ten = chapters[10].plain
        check(ten:find("ten days", 1, true) or ten:find("tenth day", 1, true), "the tenth day out with her is counted: " .. ten)
        for n = 1, 9 do check(not chapters[n].plain:find("tenth day", 1, true) and not chapters[n].plain:find("ten days", 1, true), "only on the tenth") end
    end
end

-- 5. A hundred quests, counted where they fall; a thread taken up again after a week says since when.
do
    local j = {}
    local titles = {}
    for n = 1, 20 do titles[n] = "Errand " .. n end
    for day = 0, 4 do Stretch(j, At(day, 20), 120, "Westfall", 14 + day, Q(titles)) end
    Stretch(j, At(5, 20), 60, "Silverpine Forest", 20, Q({"Prove Your Worth"}))
    Stretch(j, At(14, 20), 60, "Silverpine Forest", 22, Q({"Arugal's Folly"}))
    local p = {self = true, charKey = "hundred", name = "Edric", race = "Human", faction = "Alliance", class = "WARRIOR", startLevel = 1, journal = j}
    Clean(p)
    for retell, chapters in pairs(Tellings(p)) do
        local five = chapters[5].plain
        check(five:find("hundred quests", 1, true), "the hundredth quest, counted (" .. retell .. "): " .. five)
        for n = 1, 4 do check(not chapters[n].plain:find("hundred quests", 1, true), "not before") end
        local seven = chapters[7].plain
        check(seven:find("since", 1, true) or seven:find("had passed", 1, true) or seven:find("waiting", 1, true), "the thread, taken up again after nine days, says since when: " .. seven)
        check(not seven:find("work on", 1, true), "not 'my work on X continued': " .. seven)
    end
end

-- 6. A death after a long run without one; the tenth death counted.
do
    local j = {}
    Stretch(j, At(0, 20), 60, "Durotar", 5, {{k = "death", w = "you", d = "Dire Mottled Boar", a = true}})
    for n = 1, 8 do Stretch(j, At(n, 20), 60, "The Barrens", 10 + n, Join(Q({"Work " .. n}), {{k = "death", w = "you", d = "Razormane Hunter", a = true}})) end
    Stretch(j, At(10, 20), 60, "Stonetalon Mountains", 22, Q({"Jin'Zil's Forest Magic"}))
    Stretch(j, At(40, 20), 60, "Ashenvale", 26, {{k = "death", w = "you", d = "Foulweald Warrior", a = true}})
    local p = {self = true, charKey = "run", name = "Zuni", race = "Troll", faction = "Horde", class = "HUNTER", startLevel = 1, journal = j}
    Clean(p)
    for retell, chapters in pairs(Tellings(p)) do
        local last = chapters[#chapters].plain
        check(last:find("first death in", 1, true) or last:find("had not died in", 1, true), "a death after a month without one says so (" .. retell .. "): " .. last)
        check(last:find("tenth time", 1, true) or last:find("Ten deaths", 1, true), "the tenth death, counted: " .. last)
    end
end

-- 7. Forever's sky elves begin in Thendal Village on Zephras Isle ("on", an island); the Ruins of
-- Lordaeron take their article; island prepositions are fixed wherever a pool said "in".
do
    local j = {}
    Stretch(j, At(0, 19), 60, "Zephras Isle", 1, Join({{k = "town", d = "Thendal Village"}}, Q({"Coming of Age"}), {{k = "mylevel", d = 3}}))
    Stretch(j, At(1, 20), 60, "Zephras Isle", 4, Q({"Harmony in Balance"}))
    Stretch(j, At(3, 20), 60, "Ruins of Lordaeron", 8, Q({"Some Errand"}))
    for _, token in ipairs({"Skyborne", "SkyElf"}) do
        local p = {self = true, charKey = "sky" .. token, name = "Aerin", race = token, faction = "Alliance", class = "MAGE", startLevel = 1, journal = j}
        Clean(p)
        for retell, chapters in pairs(Tellings(p)) do
            local one = chapters[1].plain
            check(one:find("Thendal Village", 1, true) or one:find("Zephras", 1, true), "the sky elves' first page names their start (" .. token .. ", " .. retell .. "): " .. one)
            for _, c in ipairs(chapters) do
                check(not c.plain:find("in Zephras Isle", 1, true) and not c.plain:find("In Zephras Isle", 1, true), "on the isle, not in it: " .. c.plain)
                check(not c.plain:find("%f[%a]in Ruins of Lordaeron") and not c.plain:find("from Ruins of Lordaeron", 1, true), "the Ruins of Lordaeron take their article: " .. c.plain)
            end
        end
    end
    check(A.JournalIslands("I was in {p:Zephras Isle} and in the {p:Echo Isles}. In {p:Durotar} too.") == "I was on {p:Zephras Isle} and on the {p:Echo Isles}. In {p:Durotar} too.", "island prepositions")
end

-- 8. A zone's sight lines never name the other side's town for this character.
do
    local j = {}
    Stretch(j, At(0, 20), 90, "Feralas", 44, Join({{k = "first", d = "zone", z = "Feralas"}}, Q({"The Missing Courier"})))
    for _, side in ipairs({{"Alliance", "Human", "Camp Mojache"}, {"Horde", "Tauren", "Feathermoon"}}) do
        local p = {self = true, charKey = "fer" .. side[1], name = "Tam", race = side[2], faction = side[1], class = "HUNTER", startLevel = 1, journal = j}
        for retell, chapters in pairs(Tellings(p)) do
            check(not chapters[1].plain:find(side[3], 1, true), side[1] .. " never reads of " .. side[3] .. " in the land's own lines (" .. retell .. "): " .. chapters[1].plain)
        end
    end
end

io.write("PASS: " .. assertions .. " continuity assertions\n")
