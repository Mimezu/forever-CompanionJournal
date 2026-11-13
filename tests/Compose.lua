-- Run from the client root: lua5.1 Interface/AddOns/CompanionJournal/tests/Compose.lua [print]
-- The episode layer of the own book (JournalEpisodes.Day, JournalSelfCompose, 2026-11-11):
-- a synthetic evening for a troll hunter (a stay with an errand to the capital and back, a
-- lone death in the field, a bad stretch of deaths with a quest inside it, a night flight,
-- a dungeon run with its turn-in after, a journey through two zones to the night's rest)
-- must split into episodes with the errand folded, the deaths their own episode, the run's
-- turn-in and level the run's, the journeys one; the composed chapter must have one
-- paragraph an episode (light ones merged), its lines in slot order (who, place, what, cost,
-- outcome, the way out), no inn or campfire line, at most two craft lines, the level at its
-- deed, a close built from the record and never a tally or a death as the last sentence.
-- Then forty generated days (pass3/gen_days.lua, a fixed seed): every chapter composes
-- without error, under nine paragraphs, each level number once, no raw table in the text,
-- the same text on a second telling. Never reads SavedVariables.
local root = "Interface/AddOns/CompanionJournal/"
local assertions = 0
local function check(value, message) assertions = assertions + 1; assert(value, message) end
local show = arg and arg[1] == "print"

function time(t) if type(t) == "table" then return os.time(t) end return 1790000000 + 100 * 86400 end
function date(fmt, t) return os.date(fmt, t) end
function CreateFrame() return setmetatable({}, {__index = function() return function() end end}) end
C_Timer = {After = function() end}
LOCALIZED_CLASS_NAMES_MALE = {WARRIOR = "Warrior", PRIEST = "Priest", SHAMAN = "Shaman", MAGE = "Mage", WARLOCK = "Warlock", HUNTER = "Hunter", ROGUE = "Rogue", PALADIN = "Paladin", DRUID = "Druid"}
local A = {defaults = {colors = {}}}
for _, file in ipairs({"LoreData.lua", "Lore.lua", "LoreHordeStories.lua", "LoreAllianceStories.lua", "LoreWorldStories.lua", "LoreClassStories.lua",
    "LoreForeverStories.lua", "People.lua", "Characters.lua", "Journal.lua", "JournalBook.lua", "JournalEpisodes.lua", "JournalTellers.lua", "JournalFeel.lua",
    "JournalTale.lua", "JournalWords.lua", "JournalSelfWords.lua", "JournalSelfCompose.lua", "JournalSelfStyle.lua", "JournalSelfPlan.lua", "JournalSelfTale.lua"}) do
    assert(loadfile(root .. file))("CompanionJournal", A)
end
A.db = {people = {}}
A.SelfUnderground = function(name)
    for _, word in ipairs({"Mine", "Mines", "Cave", "Caverns", "Den", "Chasm", "Kraul"}) do if name:find("%f[%a]" .. word .. "%f[%A]") then return true end end
    return false
end
local E, C = A.JournalEpisodes, A.SelfCompose
check(E and E.Day, "JournalEpisodes.Day exists")
check(C and C.Apply, "SelfCompose.Apply exists")

local function Paragraphs(text)
    local out = {}
    for para in (text .. "\n\n"):gmatch("(.-)\n\n") do if para:match("%S") then out[#out + 1] = para end end
    return out
end
local function Sentences(para)
    local list = {}
    for s in para:gsub("Co%.", "Co§"):gmatch("[^%.!%?]+[%.!%?]") do list[#list + 1] = (s:gsub("^%s+", ""):gsub("§", ".")) end
    return list
end
local function WordCount(s) local n = 0; for _ in s:gmatch("%S+") do n = n + 1 end; return n end
local function Find(text, needle) return text:find(needle, 1, true) ~= nil end
local function Index(text, needle) return (text:find(needle, 1, true)) or math.huge end

-- The synthetic evening ---------------------------------------------------------------------
local BASE = os.time({year = 2026, month = 5, day = 4, hour = 0})
local function At(h, m) return BASE + h * 3600 + m * 60 end
local journal = {}
local function Add(e) journal[#journal + 1] = e; return e end
local me = {key = "zuni", name = "Zuni", race = "Troll", faction = "Horde", class = "HUNTER", startLevel = 1, pronouns = "he", retell = 0}
A.db.people = {
    grosh = {name = "Grosh-Forever", class = "SHAMAN", race = "Orc", pronouns = "he"},
    tamu = {name = "Tamu-Forever", class = "DRUID", race = "Tauren", pronouns = "she"},
}
-- 20:00 the Barrens, with Grosh from the start: quests, an errand to Orgrimmar and back (a hand-in on the return)
Add({k = "play", t = At(20, 0), e = At(20, 50), z = "The Barrens"})
Add({k = "with", d = "grosh", n = "Grosh-Forever", t = At(20, 0), e = At(23, 55), z = "The Barrens"})
Add({k = "town", d = "The Crossroads", t = At(20, 2), z = "The Barrens"})
Add({k = "rest", d = "The Crossroads", t = At(20, 3), z = "The Barrens"})
Add({k = "campfire", t = At(20, 5), z = "The Barrens"})
Add({k = "quest", d = "Plainstrider Menace", qid = 844, ql = 12, t = At(20, 20), z = "The Barrens"})
Add({k = "gather", d = "mining", c = 12, t = At(20, 30), z = "The Barrens"})
Add({k = "quest", d = "Supplies for the Crossroads", qid = 851, ql = 13, t = At(20, 48), z = "The Barrens"})
Add({k = "play", t = At(20, 50), e = At(20, 58), z = "Orgrimmar"})
Add({k = "town", d = "Orgrimmar", t = At(20, 50), z = "Orgrimmar"})
Add({k = "rest", d = "Orgrimmar", t = At(20, 51), z = "Orgrimmar"})
Add({k = "quest", d = "Ride to Orgrimmar", qid = 6361, ql = 10, t = At(20, 53), z = "Orgrimmar"})
Add({k = "play", t = At(20, 58), e = At(22, 10), z = "The Barrens"})
Add({k = "quest", d = "Return to Thork", qid = 6362, ql = 10, t = At(20, 59), z = "The Barrens"})
-- field work with a lone death, a level, and a companion joining mid-stay
Add({k = "quest", d = "Harpy Raiders", qid = 867, ql = 12, t = At(21, 10), z = "The Barrens"})
Add({k = "death", d = "Razormane Hunter", t = At(21, 15), w = "you", z = "The Barrens"})
Add({k = "quest", d = "Centaur Bracers", qid = 855, ql = 14, t = At(21, 30), z = "The Barrens"})
Add({k = "mylevel", d = "14", t = At(21, 31), z = "The Barrens"})
Add({k = "with", d = "tamu", n = "Tamu-Forever", t = At(21, 40), e = At(22, 9), z = "The Barrens"})
Add({k = "craft", d = "Cooking", c = 8, t = At(21, 45), z = "The Barrens", m = {"Roasted Boar Meat"}})
-- a bad stretch at the oasis, with a quest turned in inside it; Tamu leaves before it ends
Add({k = "death", d = "Kolkar Marauder", sz = "Lushwater Oasis", t = At(21, 50), w = "you", z = "The Barrens"})
Add({k = "quest", d = "Lost in Battle", qid = 4921, ql = 14, t = At(21, 55), z = "The Barrens"})
Add({k = "pdeath", n = "Grosh-Forever", t = At(21, 58), z = "The Barrens"})
Add({k = "death", d = "Kolkar Marauder", sz = "Lushwater Oasis", t = At(22, 0), w = "you", z = "The Barrens"})
Add({k = "rez", by = "Grosh Forever", t = At(22, 1), w = "them", z = "The Barrens"})
Add({k = "death", d = "Barak Kodobane", sz = "Lushwater Oasis", t = At(22, 5), w = "you", z = "The Barrens"})
Add({k = "quest", d = "Echeyakee", qid = 881, ql = 16, t = At(22, 8), z = "The Barrens"})
Add({k = "nightflight", t = At(22, 9), z = "The Barrens"})
-- the dungeon, from Orgrimmar: a wipe, the walk back, four bosses, the turn-in and the level after
Add({k = "play", t = At(22, 10), e = At(22, 20), z = "Orgrimmar"})
Add({k = "town", d = "Orgrimmar", t = At(22, 10), z = "Orgrimmar"})
Add({k = "play", t = At(22, 20), e = At(22, 24), z = "Ragefire Chasm"})
Add({k = "dungeon", d = "Ragefire Chasm", r = "damage", t = At(22, 20), z = "Ragefire Chasm"})
Add({k = "death", d = "Ragefire Trogg", t = At(22, 23), w = "you", z = "Ragefire Chasm"})
Add({k = "pdeath", n = "Grosh-Forever", t = At(22, 24), z = "Ragefire Chasm"})
Add({k = "play", t = At(22, 24), e = At(22, 26), z = "Orgrimmar"})
Add({k = "play", t = At(22, 26), e = At(22, 55), z = "Ragefire Chasm"})
Add({k = "dungeon", d = "Ragefire Chasm", r = "damage", t = At(22, 26), z = "Ragefire Chasm"})
Add({k = "boss", d = "Oggleflint", n = 3, t = At(22, 32), z = "Ragefire Chasm"})
Add({k = "boss", d = "Taragaman the Hungerer", n = 3, t = At(22, 40), z = "Ragefire Chasm"})
Add({k = "boss", d = "Jergosh the Invoker", n = 3, t = At(22, 47), z = "Ragefire Chasm"})
Add({k = "boss", d = "Bazzalan", n = 3, t = At(22, 53), z = "Ragefire Chasm"})
Add({k = "play", t = At(22, 55), e = At(23, 10), z = "Orgrimmar"})
Add({k = "town", d = "Orgrimmar", t = At(22, 55), z = "Orgrimmar"})
Add({k = "mylevel", d = "15", t = At(22, 56), z = "Orgrimmar"})
Add({k = "quest", d = "Slaying the Beast", qid = 5761, ql = 16, t = At(22, 56), z = "Orgrimmar"})
-- the journey home: Durotar, then Mulgore and the rest at Bloodhoof
Add({k = "play", t = At(23, 10), e = At(23, 30), z = "Durotar"})
Add({k = "town", d = "Razor Hill", t = At(23, 15), z = "Durotar"})
Add({k = "play", t = At(23, 30), e = At(23, 59), z = "Mulgore"})
Add({k = "first", d = "zone", t = At(23, 30), z = "Mulgore"})
Add({k = "town", d = "Bloodhoof Village", t = At(23, 40), z = "Mulgore"})
Add({k = "rest", d = "Bloodhoof Village", t = At(23, 41), z = "Mulgore"})
Add({k = "gather", d = "fishing", c = 14, t = At(23, 50), z = "Mulgore"})
Add({k = "sleep", d = "Bloodhoof Village", t = At(23, 58), z = "Mulgore"})
me.journal = journal
A.SelfPerson = function() return me end

local days = A.JournalBook(me)
check(#days == 1, "one day")
local day = days[1]

-- 1. The episodes -------------------------------------------------------------------------------
local D = E.Day(day.scenes)
local eps = D.episodes
local function Kinds() local k = {} for _, ep in ipairs(eps) do k[#k + 1] = ep.kind end return table.concat(k, " ") end
if show then print("episodes: " .. Kinds()) end
check(#eps >= 4 and #eps <= 6, "four to six episodes, got " .. #eps .. " (" .. Kinds() .. ")")
check(eps[1].kind == "field" and eps[1].zone == "The Barrens", "the first episode is the Barrens field work")
check(#eps[1].errands == 1 and eps[1].errands[1].zone == "Orgrimmar", "the Orgrimmar errand folds into the Barrens episode")
local function HasQuest(ep, title) for _, q in ipairs(ep.quests) do if q.quest.title == title then return true end end return false end
check(HasQuest(eps[1], "Ride to Orgrimmar") and HasQuest(eps[1], "Return to Thork"), "the errand's quests and the hand-in on the way back are the first episode's")
local deaths, dungeon, journey
for _, ep in ipairs(eps) do
    if ep.kind == "deaths" then deaths = deaths or ep end
    if ep.kind == "dungeon" then dungeon = dungeon or ep end
    if ep.kind == "journey" and ep.sleep then journey = journey or ep end
end
check(deaths and deaths.mine == 3 and deaths.theirs == 1, "the oasis is a bad stretch of three deaths of mine and one of Grosh's")
check(deaths and HasQuest(deaths, "Lost in Battle") and HasQuest(deaths, "Echeyakee"), "the quests inside and right after the deaths belong to them")
check(deaths and deaths.lastDeath == At(22, 5), "the stretch's last death")
check(deaths and deaths.outcome and deaths.outcome.foe == "Barak Kodobane" and deaths.outcome.place == "Lushwater Oasis", "the deaths' outcome names the last named killer and the place")
check(dungeon and dungeon.run and dungeon.run.dungeon == "Ragefire Chasm", "the run is an episode")
check(dungeon and HasQuest(dungeon, "Slaying the Beast"), "the run's turn-in after it is the run's")
check(dungeon and #dungeon.levels == 1 and dungeon.levels[1].level == 15, "the level with the turn-in is the run's")
local fieldLevel = false
for _, ep in ipairs(eps) do if ep.kind == "field" then for _, lv in ipairs(ep.levels) do if lv.level == 14 then fieldLevel = true end end end end
check(fieldLevel, "level 14 sits in the field episode where it came")
check(journey and #journey.scenes >= 2 and journey.sleep.place == "Bloodhoof Village", "Orgrimmar after the run, Durotar and Mulgore are one journey with the night's rest")
check(journey and journey.night, "the journey is the night's end")
check(D.spine == dungeon, "the spine is the dungeon")
for i = 2, #eps do check(eps[i].t >= eps[i - 1].t and eps[i - 1].until_ == eps[i].t, "the episodes partition the day in order") end
check(D.voyages == 0 and D.sleep and D.from == "The Crossroads", "the day's bearings for the close")
local party = table.concat(eps[1].party, ",")
check(party == "Grosh", "the first episode's party is Grosh alone, got " .. party)
local deathsParty = table.concat(deaths and deaths.party or {}, ",")
check(deathsParty == "Grosh" or deathsParty == "Grosh,Tamu", "the deaths' party")

-- 2. The composed chapter ----------------------------------------------------------------------
local function Tell(composeOn, retell)
    C.enabled = composeOn
    me.retell = retell or 0
    local book = A.JournalBook(me)
    local stories = A.SelfTale.Tell(me, book, false, retell or 0)
    C.enabled = nil
    return A.JournalPlain(stories[book[1].key].text), stories[book[1].key]
end
local plainOff = Tell(false)
local plain = Tell(true)
if show then print("\n---- composed\n" .. plain .. "\n\n---- teller's order\n" .. plainOff) end
check(plain ~= plainOff, "the composer changes the chapter")
local paras = Paragraphs(plain)
check(#paras >= 3 and #paras <= 8, "three to eight paragraphs, got " .. #paras)
for i, para in ipairs(paras) do
    local sentences = Sentences(para)
    check(#sentences >= 1, "paragraph " .. i .. " has sentences")
    check(not Find(para:lower(), "campfire") and not Find(para:lower(), "took a room") and not Find(para:lower(), "a place to rest"), "no furniture in paragraph " .. i .. ": " .. para:sub(1, 80))
    local last = sentences[#sentences]:lower()
    check(not last:find("mined %a+ veins") and not last:find("cooked %a+ dish") and not last:find("caught %a+ fish"), "no tally ends paragraph " .. i .. ": " .. last)
    if i == #paras then
        check(Find(last, "slept") or Find(last, "ended"), "the chapter closes on the night's end, got: " .. last)
        -- (round 20: the close names where the night ended; where it began only when the night was long)
        check(Find(para, "Bloodhoof Village"), "the close names where the night ended")
    end
end
-- the chapter's close is built from the record, never a feeling, never a quest title
-- (lane S: "was behind us" belongs to the paragraph that came up with the heart; three hours and a
-- journey later it is stale, so the close has no sum and the run's paragraph keeps the heart)
check(not Find(paras[#paras], "was behind us"), "no stale sum an hour after the run")
check(Find(plain, "with Taragaman's heart"), "the run's paragraph ends on what came of it")
check(not Find(paras[#paras], "the work for"), "no work-for line when the chapter has an outcome")
-- the levels: one line a chapter, the day's last level, with the run it came out of; the other silent
local saidLevels = C.LevelsSaid(plain)
check(saidLevels["15"], "the day's last level, 15, is told")
local levelLines = 0
for _, p in ipairs(paras) do for _, sn in ipairs(Sentences(p)) do if next(C.LevelsSaid(sn)) then levelLines = levelLines + 1 end end end
check(levelLines == 1, "one level sentence in the chapter (a span for two levels), got " .. levelLines)
check(select(2, plain:lower():gsub("level 14", "")) == 0, "level 14 has no line of its own")
-- one craft sentence, the night's end's (fourteen fish) or the largest, never three
local tallies = 0
for _, p in ipairs(paras) do for _, s in ipairs(Sentences(p)) do if s:lower():find("mined %a+ veins") or s:lower():find("cooked %a+ dish") or s:lower():find("caught %a+ fish") then tallies = tallies + 1 end end end
check(tallies <= 2, "at most two tally sentences, got " .. tallies)
-- the deaths episode: the passage sits inside the errand at its time; the quest after the last death follows it
local deathsPara
for _, p in ipairs(paras) do if Find(p, "Barak Kodobane") then deathsPara = p end end
check(deathsPara, "the bad stretch has its paragraph")
if deathsPara then
    check(Index(deathsPara, "Kodobane") < Index(deathsPara, "Echeyakee") or not Find(deathsPara, "Echeyakee"), "the quest turned in after the last death follows the deaths")
    check(Index(deathsPara, "Mankrik") < Index(deathsPara, "Kodobane") or not Find(deathsPara, "Mankrik"), "the quest inside the stretch, before its middle, is told before the passage")
end
-- Tamu joins at her own time, inside the field work, not at the top of the stay
local joinAt = Index(plain, "Tamu")
check(joinAt < math.huge, "Tamu is introduced")
check(Index(plain, "Harpy") < joinAt or Index(plain, "Razormane") < joinAt, "Tamu joins after the work that preceded her, not at the stay's start")
-- the dungeon is one paragraph with its turn-in, and its lines are in the dungeon writer's order
local runPara
for _, p in ipairs(paras) do if Find(p, "Oggleflint") then runPara = p end end
check(runPara and Find(runPara, "Ragefire Chasm") and Find(runPara, "Bazzalan"), "the run is one paragraph")
check(runPara and Index(runPara, "Oggleflint") < Index(runPara, "Bazzalan"), "the bosses keep their order")
-- no raw table, no double space, nothing lower-case at a sentence start
check(not Find(plain, "table:"), "no raw table in the text")
for _, p in ipairs(paras) do for _, s in ipairs(Sentences(p)) do check(not s:match("^%l"), "no sentence starts in lower case: " .. s) end end
-- deterministic
check(Tell(true) == plain, "the same chapter twice")
local retold = Tell(true, 3)
check(retold ~= "" and #Paragraphs(retold) <= 8, "another retell composes too")
-- the switch
A.BookVariant = function(key) if key == "compose" then return "off" end end
local switched = Tell(true)
A.BookVariant = nil
check(switched == plainOff, "Settings > Testing > compose: off gives the teller's own order")

-- 3. Generated days ----------------------------------------------------------------------------
local gen = loadfile("StorageInvestigation/cj-story-breakthrough-20261109/pass3/gen_days.lua")
if gen then
    local G = gen()
    local lives = G.Generate(A, 20261111, 40)
    local chapters, composed = 0, 0
    for _, life in ipairs(lives) do
        A.db.people = {}
        for key, p in pairs(life.people) do A.db.people[key] = p end
        A.SelfPerson = function() return life end
        life.retell = 0
        local book = A.JournalBook(life)
        C.enabled = nil
        local stories = A.SelfTale.Tell(life, book, false, 0)
        C.enabled = false
        local plainStories = A.SelfTale.Tell(life, book, false, 0)
        C.enabled = nil
        for _, d in ipairs(book) do
            local st = stories[d.key]
            if st and st.text ~= "" then
                chapters = chapters + 1
                local text = A.JournalPlain(st.text)
                if plainStories[d.key] and A.JournalPlain(plainStories[d.key].text) ~= text then composed = composed + 1 end
                local ps = Paragraphs(text)
                check(#ps <= 9, life.key .. " " .. d.key .. ": at most nine paragraphs, got " .. #ps)
                check(not Find(text, "table:"), life.key .. " " .. d.key .. ": no raw table")
                check(not Find(text, "{"), life.key .. " " .. d.key .. ": no token left")
                local said = {}
                for num in text:gmatch("[Ll]evel (%d+)") do said[num] = (said[num] or 0) + 1 end
                for num, n in pairs(said) do check(n == 1, life.key .. " " .. d.key .. ": level " .. num .. " said " .. n .. " times") end
                local plainLevelLines, runWords = 0, 0
                for _, p in ipairs(ps) do
                    local ss = Sentences(p)
                    local last = (ss[#ss] or ""):lower()
                    check(not last:find("^i mined %a+ veins%.$") and not last:find("^i caught %a+ fish%.$"), life.key .. " " .. d.key .. ": a tally ends a paragraph: " .. last)
                    for _, sn in ipairs(ss) do
                        -- (the run's own "Level 22 came with Oggleflint" is the dungeon writer's, not a plain line)
                        if (sn:find("^Level %d+ came") and not sn:find("^Level %d+ came with %u")) or sn:find("^Somewhere in .- level %d+ came") then plainLevelLines = plainLevelLines + 1 end
                        check(not sn:find("^We saw .- through%.$") and not sn:find("^I saw .- through%.$"), life.key .. " " .. d.key .. ": a bare quest title: " .. sn)
                    end
                end
                check(plainLevelLines <= 1, life.key .. " " .. d.key .. ": more than one plain level line")
                local again = A.SelfTale.Tell(life, book, false, 0)
                check(A.JournalPlain(again[d.key].text) == text, life.key .. " " .. d.key .. ": the same chapter twice")
            end
        end
    end
    check(chapters >= 30, "generated chapters read: " .. chapters)
    check(composed >= chapters / 2, "most generated chapters were composed: " .. composed .. " of " .. chapters)
    if show then print(("generated: %d chapters, %d composed"):format(chapters, composed)) end
end

-- Lane S (2026-11-11): the seams ------------------------------------------------------------
-- The names a text uses bare: the ones a later chapter assumes known.
do
    local bare = C.BareNames("Magistrate Sevren found Deliah in his records and said the Rot Hides must have taken her body to Silverpine.")
    check(bare.Deliah, "a name used bare is found")
    check(not bare.Sevren, "a titled name is not bare")
    check(not bare.Hides and not bare.Hide, "a word of a two-word name is not bare")
    local strict = C.BareNames("Dalar wanted it taken for Varimathras's advance. Hadrec let me choose from the arsenal.", true)
    check(not strict.Varimathras, "a possessive is no bare name in the later text")
    check(not strict.Hadrec, "a name opening a sentence is not bare")
    check(not C.BareNames("We fought past the Bulwark.").Bulwark, "a thing after \"the\" is not a person")
    check(C.BareNames("I took the scraps to Balthule, who named them.").Balthule, "a name before a who-clause is bare")
end
-- In the synthetic chapter: no rare-creature sighting, no stakes line, no level span, no title-only quest,
-- the close opens where the chapter began, the first death is one sentence with what it was.
check(not Find(plain, "crossed my path") and not Find(plain, "few people ever see"), "a rare creature only seen is not told")
check(not Find(plain, "from level") or Find(plain, "The run took me from level"), "no level span outside the run's own line")
check(not Find(plain, " through."), "no title-only quest line")
check(not Find(plain, "Ride to Orgrimmar"), "the errand with no words of its own is left out")
-- the generated days: the seams the editor named, on every chapter
do
    local gen = loadfile("StorageInvestigation/cj-story-breakthrough-20261109/pass3/gen_days.lua")
    if gen then
        local G = gen()
        if G and G.Generate then
            local TRANSIT = {"^we flew to ", "^i flew to ", "^a flight took ", "^we rode a zeppelin", "^i rode a zeppelin", "^we took the zeppelin", "^i took the zeppelin",
                "^from there ", "^we went on to ", "^i went on to ", "hearthstone took me", "hearthstone brought me"}
            local function Transit(s) local l = s:lower(); for _, p in ipairs(TRANSIT) do if l:find(p) then return true end end return false end
            for _, life in ipairs(G.Generate(A, 9001, 30)) do
                A.db.people = {}
                for key, p in pairs(life.people) do A.db.people[key] = p end
                A.SelfPerson = function() return life end
                life.retell = 0
                local book = A.JournalBook(life)
                local stories = A.SelfTale.Tell(life, book, false, 0)
                for _, d in ipairs(book) do
                    local st = stories[d.key]
                    if st and st.text ~= "" then
                        local text = A.JournalPlain(st.text)
                        local tag = life.key .. " " .. d.key .. ": "
                        check(not Find(text, "crossed my path") and not Find(text, "few people ever see"), tag .. "a rare creature only seen")
                        check(not text:find("%a+ deaths in [%a ]+, and .- besides%.") and not text:find("%a+ deaths in [%a ]+, and .- as well%."), tag .. "a death tally")
                        check(not text:find("I went from level %d+ to %d+%.") and not text:find("I started the day at level"), tag .. "a level span")
                        local ps = Paragraphs(text)
                        for _, p in ipairs(ps) do
                            local ss = Sentences(p)
                            check(not (#ss == 1 and ss[1]:find("^Level %d+ came")), tag .. "a level standing as a paragraph")
                            for i = 2, #ss do
                                check(not (Transit(ss[i]) and Transit(ss[i - 1])), tag .. "two transit sentences in a row: " .. ss[i - 1] .. " " .. ss[i])
                                local place = ss[i]:match("^In ([%u][%w' ]+), ")
                                if place then check(not Find(ss[i - 1], place), tag .. "a place named again at the head of the next sentence: " .. ss[i]) end
                            end
                        end
                        local last = ss and ss[#ss] or ""
                        local allS = Sentences(text)
                        last = allS[#allS] or ""
                        local began = last:match("began %a+ (.-)[%.,]") or last:match("begun %a+ (.-)[%.,]")
                        if began and not began:find("^there") then
                            local bare = began:gsub("^[Tt]he ", "")
                            check(Find(text:sub(1, #text - #last), bare), tag .. "the close names a start the chapter never told: " .. last)
                        end
                    end
                end
            end
        end
    end
end

print(assertions .. " checks passed")
