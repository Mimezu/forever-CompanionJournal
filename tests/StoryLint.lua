-- Run from the client root: lua5.1 Interface/AddOns/CompanionJournal/tests/StoryLint.lua [print] [rule] [days]
-- An automated reader for the storytellers. It tells many lives (the 30-life simulator's
-- batches, forty generated days from pass3/gen_days.lua with a fixed seed, a replay of
-- Alberich's real days of 2026-11-09/10, and a trio built to provoke known faults) through
-- both tellers (current, planned), both books (own, companion) and both voices (you, we),
-- then reads every chapter against the record it came from and flags the faults a program
-- can see. Hard rules fail the suite; soft rules only report counts and the worst examples.
-- `print` shows every example of every rule; `print <rule>` only that rule's; a third
-- argument sets how many days to generate (default 40). DUMP=<life key> (alberich, trio,
-- gen3-gorrash, batch1:hunter) prints that life's chapters as they are read. Never reads SavedVariables.
local root = "Interface/AddOns/CompanionJournal/"
local show, only, genDays = arg and arg[1] == "print", arg and arg[2] ~= "-" and arg[2] or nil, tonumber(arg and arg[3]) or 40

function time(t) if type(t) == "table" then return os.time(t) end return os.time({year = 2026, month = 12, day = 1, hour = 0}) end
function date(fmt, t) return os.date(fmt, t) end
local function Stub() return setmetatable({}, {__index = function() return function() end end}) end
function CreateFrame() return Stub() end
C_Timer = {After = function() end}
UIParent = Stub()
LOCALIZED_CLASS_NAMES_MALE = {WARRIOR = "Warrior", MAGE = "Mage", PRIEST = "Priest", ROGUE = "Rogue", WARLOCK = "Warlock",
    HUNTER = "Hunter", DRUID = "Druid", SHAMAN = "Shaman", PALADIN = "Paladin"}
local A = {defaults = {colors = {}}}
for _, file in ipairs({"LoreData.lua", "Lore.lua", "LoreHordeStories.lua", "LoreAllianceStories.lua", "LoreWorldStories.lua",
    "LoreClassStories.lua", "LoreForeverStories.lua", "People.lua", "Characters.lua", "Journal.lua", "JournalBook.lua",
    "JournalTellers.lua", "JournalFeel.lua", "JournalTale.lua", "JournalWords.lua", "JournalSelfWords.lua", "JournalSelfStyle.lua",
    "JournalSelfPlan.lua", "JournalSelfTale.lua", "JournalEpisodes.lua", "JournalSelfCompose.lua"}) do
    assert(loadfile(root .. file))("CompanionJournal", A)
end
A.db = {people = {}}
-- (COMPOSE=off reads the own book without the composer, to compare its counts)
if os.getenv("COMPOSE") == "off" and A.SelfCompose then A.SelfCompose.enabled = false end
local UNDER = {"Mine", "Mines", "Cave", "Cavern", "Den", "Burrow", "Crypt", "Barrow", "Grotto", "Hollow"}
A.SelfUnderground = function(name)
    for _, word in ipairs(UNDER) do if name:find("%f[%a]" .. word .. "%f[%A]") then return true end end
    return false
end
local PLANNED = function(k) if k == "teller" then return "planned" end end

-- Words ---------------------------------------------------------------------------------------
local NUMBER = {one = 1, two = 2, three = 3, four = 4, five = 5, six = 6, seven = 7, eight = 8, nine = 9, ten = 10, eleven = 11,
    twelve = 12, thirteen = 13, fourteen = 14, fifteen = 15, sixteen = 16, seventeen = 17, eighteen = 18, nineteen = 19, twenty = 20,
    thirty = 30, forty = 40, fifty = 50, sixty = 60, twice = 2, once = 1}
local function Num(word)
    word = tostring(word or ""):lower()
    if tonumber(word) then return tonumber(word) end
    if NUMBER[word] then return NUMBER[word] end
    local tens, ones = word:match("^(%a+)%-(%a+)$")
    if tens and NUMBER[tens] and NUMBER[ones] then return NUMBER[tens] + NUMBER[ones] end
    return nil
end
local function Esc(text) return (text:gsub("[%^%$%(%)%%%.%[%]%*%+%-%?]", "%%%0")) end
local function First(name) return (tostring(name or ""):gsub("[{}]", ""):gsub("%-.*$", "")) end
local function Trim(s) return (s:gsub("^%s+", ""):gsub("%s+$", "")) end
-- A place as it is named in prose: "The Barrens" is "the Barrens"; match without the article.
local function Bare(place) return (tostring(place or ""):gsub("^[Tt]he ", "")) end
local function Has(text, place)
    place = Bare(place)
    if place == "" then return false end
    return text:find("%f[%w]" .. Esc(place) .. "%f[%W]") ~= nil
end
local function CountIn(text, place)
    local n = 0
    for _ in text:gmatch("%f[%w]" .. Esc(Bare(place)) .. "%f[%W]") do n = n + 1 end
    return n
end
local function Paragraphs(plain)
    local out = {}
    for para in (plain .. "\n"):gmatch("(.-)\n") do
        para = Trim(para)
        if para ~= "" then out[#out + 1] = para end
    end
    return out
end
local function Sentences(para)
    local text = para:gsub("Mr%.", "Mr§"):gsub("Mrs%.", "Mrs§"):gsub("Co%.", "Co§"):gsub("St%.", "St§"):gsub("Dr%.", "Dr§"):gsub("%.%.%.", "…")
    local out = {}
    for s in text:gmatch("[^%.!?]+[%.!?]+") do
        s = Trim(s):gsub("§", "."):gsub("…", "...")
        if s ~= "" then out[#out + 1] = s end
    end
    return out
end
local function WordCount(s) local n = 0; for _ in s:gmatch("%S+") do n = n + 1 end; return n end
local function FirstWord(s) return (s:match("^[%w']+") or ""):lower() end
-- (Lua patterns have no alternation: a list of patterns, any of which may match)
local function Any(text, list) for _, p in ipairs(list) do if text:find(p) then return true end end return false end
local function Opt(prefix, bare, suffix) return {prefix .. bare .. (suffix or ""), prefix .. "the " .. bare .. (suffix or "")} end
local function Short(text, n) return (text:gsub("\n+", " / ")):sub(1, n or 160) end

-- Rules ---------------------------------------------------------------------------------------
local RULES, ORDER = {}, {}
local function Rule(name, hard, what)
    RULES[name] = {name = name, hard = hard, what = what, count = 0, examples = {}, by = {}}
    ORDER[#ORDER + 1] = name
end
-- hard: clear bugs
Rule("dup-name-list", true, "the same name twice in one list (\"Dahlia and Dahlia\")")
Rule("punct-double", true, "a doubled comma or a comma before a full stop (\"a human priest,, Brannoc\")")
Rule("stranger-known", true, "someone who travelled with you on an earlier day called a stranger")
Rule("level-twice", true, "the same level number said more than once in a chapter")
Rule("dungeon-twice", true, "a dungeon entered twice in one chapter")
Rule("death-count-wrong", true, "a death count that does not match the record")
Rule("pair-three", true, "\"the pair of you\" with three or more present")
-- soft: reading faults, counted
Rule("lower-start", false, "a sentence that starts in lower case")
Rule("stranger-met-today", false, "someone first met that day called a stranger when they raise you")
Rule("level-place", false, "a level told in a paragraph set somewhere else than where it came")
Rule("place-3-paragraph", false, "the same place named three or more times in a paragraph")
Rule("place-2-sentence", false, "the same place named twice in one sentence")
Rule("boss-twice", false, "a boss kill told in two sentences (the run and the quest line)")
Rule("too-chain", false, "\"too\" / \"as well\" / \"also\" twice in a paragraph")
Rule("article-named", false, "an article before a named foe (\"A Bishop Jericho\")")
Rule("generic-no-article", false, "no article before a generic foe (\"Venture Co. Geologist killed me\")")
Rule("flicker-told", false, "a stay of under three minutes, with nothing in it, told as travel")
Rule("mouth-as-zone", false, "a cave mouth or instance zone told as a new place beside the dungeon itself")
Rule("transit-repeat", false, "the same movement sentence more than once in a book")
Rule("transit-share", false, "chapters where over a third of the sentences only move or rest the character")
Rule("burst-paragraphs", false, "three or more paragraphs in a row of one or two sentences")
Rule("one-liners", false, "chapters with three or more one-sentence paragraphs")
Rule("episode-split", false, "a dungeon run (bosses, deaths, the way in) told across two or more paragraphs")
Rule("episode-mixed", false, "a paragraph that names three or more different zones of the day")
Rule("deaths-split", false, "deaths of one day told in three or more paragraphs")
Rule("death-ledger", false, "five or more death sentences in a chapter")
Rule("death-tail-chain", false, "\"killed me too\" / \"killed me as well\" more than once in a chapter")
Rule("orphan-death-line", false, "a paragraph that is one short death line (\"Dahlia died.\")")
Rule("boss-ledger", false, "three or more consecutive short sentences that each only name a kill or a death")
Rule("craft-ledger", false, "three or more tally sentences (veins, pieces, bars, dishes) in a chapter")
Rule("unintroduced-name", false, "a name that dies or raises without ever being introduced")
Rule("we-alone", false, "\"we\" on a day nobody was in the party")
Rule("first-again", false, "a place \"new to me\" after an earlier chapter already had it")
Rule("long-paragraph", false, "a paragraph over a hundred and ten words")
Rule("same-opening", false, "consecutive sentences opening with the same word")
Rule("short-run", false, "three or more sentences of six words or fewer in a row")
Rule("sentence-repeat", false, "an identical sentence twice in a book")
Rule("first-time-chain", false, "\"first\" said four or more times in a chapter")
Rule("clock-chain", false, "three or more sentences in a chapter opening on the clock (\"Just after ten\", \"Ten minutes on\")")

local function Flag(rule, where, example)
    local r = RULES[rule]
    r.count = r.count + 1
    r.by[where.teller] = (r.by[where.teller] or 0) + 1
    r.by[where.source] = (r.by[where.source] or 0) + 1
    local tag = ("%s/%s/%s/%s ch.%d"):format(where.life, where.book, where.teller, where.voice, where.chapter)
    if show and (not only or only == rule) then print(("[%s] %s: %s"):format(rule, tag, example)) end
    if #r.examples < 3 then
        local dup = false
        for _, x in ipairs(r.examples) do if x.example == example then dup = true end end
        if not dup then r.examples[#r.examples + 1] = {tag = tag, example = example} end
    end
end

-- Foes: generic kinds carry an article, named ones do not.
local GENERIC_LAST = {}
for w in ([[Trogg Guard Hunter Geologist Brute Savage Thug Headhunter Snowstrider Interloper Enforcer Duskbat Spider Wolf Skeleton Zealot
    Crusader Bat Rogue Warrior Mage Priest Shaman Paladin Warlock Druid Highwayman Scout Raider Cultist Worg Bear Raptor Ghoul Gnoll Murloc
    Kobold Pillager Looter Bandit Soldier Footman Grunt Archer Mystic Acolyte Initiate Sentinel Warden Watcher Stalker Prowler Lurker Crawler
    Walker Shade Wraith Sorcerer Necromancer Apprentice Pirate Buccaneer Swashbuckler Marauder Outrunner Scavenger Vagrant Fiend Horror
    Abomination Familiar Imp Felguard Succubus Elemental Ooze Slime Basilisk Crocolisk Hyena Lion Tiger Panther Gorilla Scorpid Boar
    Plainstrider Zhevra Kodo Stag Owl Hide Shambler Worgen Whitescalp Hound Darkhound Zombie Geomancer Invader Bodyguard Berserker
    Shadowcaster Magician Conjurer Deathguard Guardian Protector Ambusher Shieldbearer Blademaster Ravager Spirit Worker Logger Creeper
    Mercenary Summoner Farmer Commando Venomlash Smasher Ogre Darter Fisherman Tarantula Devilsaur Satyr Ursa Frostsaber Invoker Plaguehound
    Champion Golem Mongrel Buzzard Wendigo Bonewarder Moonstalker Thief Legionnaire Guardsman Treant Myrmidon Prisoner Gnome Miner Moonwalker
    Deathwalker Shadowhunter Dragonspawn Slaver Avenger Reaver Stinger Darkrunner Drudger Runner Assassin Spy Captain Lieutenant Sergeant]]):gmatch("%S+") do GENERIC_LAST[w] = true end
local TITLE = {Bishop = true, Captain = true, Lord = true, Lady = true, Son = true, Archmage = true, Commander = true, Chief = true, Baron = true,
    King = true, Queen = true, Prince = true, Princess = true, High = true, Overlord = true, Warlord = true, Mother = true, Father = true,
    Doctor = true, Sergeant = true, Lieutenant = true, Marshal = true, General = true, Deathguard = true, Executor = true, Magistrate = true, Boss = true}
local function GenericFoe(name)
    name = tostring(name or "")
    if name:find("Co%.") then return true end
    local words = {}
    for w in name:gmatch("%S+") do words[#words + 1] = w end
    if #words == 1 then return GENERIC_LAST[words[1]] == true end
    if TITLE[words[1]] and not GENERIC_LAST[words[#words]] then return false end
    return GENERIC_LAST[words[#words]] == true
end

-- Movement and furniture: sentences that only carry the character from one place to the next.
local MOVE = {"rode the lift", "zeppelin", "came up out of", "went on through", "went on to", "left [%w' ]+ for ", "took me on to",
    "took me to", "hearthstone took me", "flight to", "flew to", "went into ", "came into ", "came to ", "^after [%w' ]+ came ",
    "^from [%w' ]+, we went", "^from [%w' ]+, i went", "went down into", "went back to", "my way took me", "the road took me", "a moment later",
    "passed through", "came through", "walked into", "headed into", "went out into", "made my way", "made our way", "^i set out", "^we set out",
    "carried me over", "carried us over", "carried me to", "carried us to", "carried me across", "carried us across", "took the flight",
    "took myself out to", "came back out into", "came out of the dark into", "found my way into", "spent a while underground", "stayed on in",
    "still had work for me", "came down in the dark", "next part of the day took me", "the day's travels brought", "ship carried", "boat carried",
    "a bat carried", "rode a bat", "went up to [%w' ]+,", "i came up to", "without stopping", "gave way to", "sailed to", "took the boat",
    "i reached [%u]", "was behind me now", "was across the sea now", "set out on the road", "i went back to", "went home to"}
local FURNITURE = {"stopped at ", "stopped in ", "stopped a while at", "stopped a while in", "took a room", "rested at", "rested a while at",
    "slept at", "a place to rest", "to rest%.", "for the night", "stopped for the night", "looked in at", "we stopped by a campfire",
    "sat down by a campfire", "sat by a campfire", "found a campfire", "rested by a campfire", "made camp", "stopped a while", "we stopped at",
    "bound my hearthstone", "set my hearthstone", "my home%."}
local ACTION = {"killed", "died", "death", "dead", "quest", "turned in", "finished", "brought", "made level", "level ", "mined", "caught",
    "picked", "spoke", "met ", "learned", "said", "found ", "fell", "rose", "raised", "freed", "took .- ring", "took .- head", "took .- order",
    "carried .- to ", "carried .- for ", "for the first time", "first time", "never been", "new to", "saw ", "joined", "fought"}
local function IsMove(sentence)
    local s = sentence:lower()
    if WordCount(sentence) > 22 then return false end
    for _, a in ipairs(ACTION) do if s:find(a) then return false end end
    for _, m in ipairs(MOVE) do if s:find(m) then return "move" end end
    for _, f in ipairs(FURNITURE) do if s:find(f) then return "rest" end end
    return false
end
local DEATH = {"killed me", "was the end of me", "got the better of me", "died there", "died%.", "was killed", "died twice", "died %a+ times",
    "killed you", "got you%.", "cut you down", "got the better of you", "died,", "killed .- and died all the same", "i died", "you died",
    "fell to ", "made short work of", "nearly got me", "was killed there", "time i had died", "time i died", "got me", "went down%.", "went down with",
    "laid me low", "did not last", "down before long"}
local function IsDeath(sentence)
    local s = sentence:lower()
    for _, d in ipairs(DEATH) do if s:find(d) then return true end end
    return false
end
local KILL = {"fell%.$", "went down%.$", "was hunted down%.$", "was broken apart%.$", "died there%.$", "died%.$", "was killed%.$", "was defeated%.$",
    "^we killed [%u][%w' ]+%.$", "^you killed [%u][%w' ]+%.$", "^we brought down [%u][%w' ]+%.$", "went down in turn%.$"}
local CLOCK = {"^just after", "^a little after", "^close to", "^past midnight", "^around half past", "^%a+ minutes? on,", "^%a+ minutes? later",
    "^moments later", "^within minutes", "^before the hour was out", "^by the time we stopped", "^a minute or two later", "^by then", "^an hour on"}
local TALLY = {"mined %a+[%a%-]* veins?", "made %a+[%a%-]* (pieces|things)", "smelted", "cooked %a+[%a%-]* dish", "caught %a+[%a%-]* fish", "picked %a+[%a%-]* herbs",
    "bars of copper", "sewed %a+ pieces", "made %a+[%a%-]* pieces", "made %a+[%a%-]* things"}

-- The record of one day, for the cross-checks -----------------------------------------------
local function DayKey(t) return date("%Y-%m-%d", A.JournalEvening(t or 0)) end
local function Record(journal, dayKey)
    local r = {places = {}, zones = {}, dungeons = {}, mouths = {}, bosses = {}, foes = {}, ownDeaths = 0, theirDeaths = 0, pdeaths = {}, levels = {}, stays = {}, rezBy = {}}
    local plays = {}
    for _, e in ipairs(journal) do
        if e.k ~= "with" and DayKey(e.t) == dayKey then
            if e.z and e.k ~= "first" then r.places[e.z] = true; if e.k == "play" or e.k == "group" then r.zones[e.z] = true end end
            if e.sz then r.places[e.sz] = true end
            if e.k == "first" and e.d == "zone" and e.z then r.places[e.z] = true; r.zones[e.z] = true end
            if e.k == "dungeon" or e.k == "cave" then
                r.places[e.d] = true
                if e.k == "dungeon" then r.dungeons[e.d] = (r.dungeons[e.d] or 0) + 1; r.zones[e.d] = true end
                if e.k == "cave" and e.z and e.z ~= e.d and Bare(e.z) == Bare(e.d) then r.mouths[e.z] = e.d end
            end
            if e.k == "town" or e.k == "rest" or e.k == "sleep" or e.k == "home" or e.k == "hearth" then r.places[e.d] = true end
            if e.k == "boss" and e.d then r.bosses[e.d] = true end
            if e.k == "death" then
                if e.w == "them" then r.theirDeaths = r.theirDeaths + 1 else r.ownDeaths = r.ownDeaths + 1 end
                if e.d then r.foes[e.d] = true end
            end
            if e.k == "pdeath" and e.n then local n = First(e.n); r.pdeaths[n] = (r.pdeaths[n] or 0) + 1 end
            if e.k == "mylevel" then r.levels[#r.levels + 1] = {n = tonumber(e.d), z = e.z} end
            if e.k == "rez" and e.by then r.rezBy[#r.rezBy + 1] = First(e.by) end
            if e.k == "play" or e.k == "group" then plays[#plays + 1] = e end
        end
    end
    -- (the mouth of an instance: "The Wailing Caverns" outside "Wailing Caverns")
    for z in pairs(r.zones) do for d in pairs(r.dungeons) do if z ~= d and Bare(z) == Bare(d) then r.mouths[z] = d end end end
    -- stays: short and empty, or real
    for _, p in ipairs(plays) do
        local busy = false
        for _, e in ipairs(journal) do
            if e.k ~= "play" and e.k ~= "group" and e.k ~= "with" and (e.t or 0) >= (p.t or 0) and (e.t or 0) <= (p.e or p.t or 0) and (e.z == p.z or e.z == nil) then busy = true end
        end
        local short = ((p.e or p.t or 0) - (p.t or 0)) < 180
        r.stays[#r.stays + 1] = {zone = p.z, flicker = short and not busy}
    end
    return r
end
-- Who was in the party that day, and who was known from earlier days (the own journal's "with").
local function Party(own, dayKey)
    local present, known = {}, {}
    for _, e in ipairs(own) do
        if e.k == "with" and e.n then
            local n = First(e.n)
            if DayKey(e.t) < dayKey then known[n] = true end
            if DayKey(e.t) == dayKey or DayKey(e.e or e.t) == dayKey then present[n] = true end
        end
    end
    return present, known
end

-- The reading ---------------------------------------------------------------------------------
local DUMP = os.getenv("DUMP")   -- DUMP=<life key> prints every chapter of that life as it is read
local function Read(where, plain, rec, present, known, people, bookSeen, book)
    if DUMP and where.life == DUMP then print(("---- %s/%s/%s/%s ch.%d\n%s\n"):format(where.life, where.book, where.teller, where.voice, where.chapter, plain)) end
    local paras = Paragraphs(plain)
    local allSentences = {}
    local placeList = {}
    for p in pairs(rec.places) do if Bare(p) ~= "" then placeList[#placeList + 1] = p end end
    table.sort(placeList, function(a, b) return #a > #b end)
    local presentCount = 0
    for _ in pairs(present) do presentCount = presentCount + 1 end
    local deathParas, dungeonParas, levelSaid, dungeonEntered = 0, {}, {}, {}
    local moveCount, restCount, total = 0, 0, 0
    local oneLiners, shortRun, killRun = 0, 0, 0
    local tailChain, deathSentences, tally, firsts, clocks = 0, 0, 0, 0, 0
    local seenSentence = {}
    if plain:find(",,") or plain:find(" ,") or plain:find(",%.") or plain:find("%.%s*,") then Flag("punct-double", where, Short(plain:match("[^.]*,,[^.]*") or plain:match("[^.]* ,[^.]*") or plain, 120)) end
    for pi, para in ipairs(paras) do
        local sentences = Sentences(para)
        local words = WordCount(para)
        if words > 110 then Flag("long-paragraph", where, ("%d words: %s"):format(words, para:sub(1, 90) .. "...")) end
        if #sentences == 1 then oneLiners = oneLiners + 1 end
        if #sentences == 1 and IsDeath(sentences[1]) and WordCount(sentences[1]) <= 7 then Flag("orphan-death-line", where, para) end
        for _, place in ipairs(placeList) do
            local n = CountIn(para, place)
            if n >= 3 then Flag("place-3-paragraph", where, ("%s x%d: %s"):format(place, n, para:sub(1, 100) .. "...")) end
        end
        -- (a town inside its zone is not a different place; zones and dungeons are)
        local zonesHere = {}
        for _, place in ipairs(placeList) do if rec.zones[place] and not rec.mouths[place] and Has(para, place) then zonesHere[#zonesHere + 1] = place end end
        if #zonesHere >= 3 then Flag("episode-mixed", where, table.concat(zonesHere, " / ") .. ": " .. para:sub(1, 80) .. "...") end
        -- (the run itself: a paragraph that names the dungeon with a boss, a death or the way in; the
        -- quest turned in later or a closing line is not a second piece of the episode)
        for d in pairs(rec.dungeons) do
            if Has(para, d) then
                local run = IsDeath(para) or Any(para:lower(), {"into ", "went in", "inside"})
                for b in pairs(rec.bosses) do if Has(para, b) then run = true end end
                if run then dungeonParas[d] = (dungeonParas[d] or 0) + 1 end
            end
        end
        local deathHere = false
        local tooHere = 0
        for si, s in ipairs(sentences) do
            total = total + 1
            allSentences[#allSentences + 1] = s
            local low = s:lower()
            if s:match("^%l") then Flag("lower-start", where, s) end
            -- duplicate name in a list
            local a, b = s:match("(%u[%w']+) and (%u[%w']+)")
            if a and a == b then Flag("dup-name-list", where, s) end
            local c, d = s:match("(%u[%w']+), (%u[%w']+)")
            if c and c == d and (present[c] or people[c] or rec.pdeaths[c]) then Flag("dup-name-list", where, s) end
            -- a stranger who is known
            if Any(low, {"stranger", "never met", "whom i had never", "who stopped for me"}) then
                for name in pairs(known) do
                    if s:find("%f[%w]" .. Esc(name) .. "%f[%W]") then Flag("stranger-known", where, s) end
                end
                for name in pairs(present) do
                    if not known[name] and s:find("%f[%w]" .. Esc(name) .. "%f[%W]") then Flag("stranger-met-today", where, s) end
                end
            end
            -- levels
            for num in s:gmatch("[Ll]evel (%w+[%-]?%w*)") do
                local n = Num(num)
                if n then levelSaid[n] = (levelSaid[n] or 0) + 1 end
            end
            -- dungeon entered
            for d in pairs(rec.dungeons) do
                local bare = Esc(Bare(d)):lower()
                if Any(low, Opt("into ", bare)) or Any(low, Opt("for ", bare, "%.")) or Any(low, Opt("tried ", bare)) or Any(low, Opt("looked in at ", bare))
                    or Any(low, Opt("visit to ", bare)) or Any(low, Opt("went back down", "")) and false then
                    dungeonEntered[d] = (dungeonEntered[d] or 0) + 1
                end
            end
            -- the mouth told as a place of its own
            for mouth, d in pairs(rec.mouths) do
                if Any(low, {"gave way to the " .. Esc(Bare(mouth)):lower(), "came to the " .. Esc(Bare(mouth)):lower(), "after .- came the " .. Esc(Bare(mouth)):lower(),
                    "the " .. Esc(Bare(mouth)):lower() .. ", where i had never been", "the " .. Esc(Bare(mouth)):lower() .. " was new", "first time in the " .. Esc(Bare(mouth)):lower(),
                    "went on to the " .. Esc(Bare(mouth)):lower(), "on to the " .. Esc(Bare(mouth)):lower() .. "%.", "^the " .. Esc(Bare(mouth)):lower() .. " gave way"}) then
                    Flag("mouth-as-zone", where, s)
                end
            end
            -- death counts against the record
            local times = low:match("i died (%w+) times") or low:match("you died (%w+) times")
            if times and Num(times) and Num(times) ~= rec.ownDeaths then Flag("death-count-wrong", where, ("%s (record %d): %s"):format(times, rec.ownDeaths, s)) end
            local name, ntimes = s:match("(%u[%w']+) died[^.]-, (%w+ times)")
            if not name then name, ntimes = s:match("(%u[%w']+) died (twice)") end
            if not name then name, ntimes = s:match("(%u[%w']+) died there, (%w+ times)") end
            if name and ntimes then
                local n = Num(ntimes:match("^%w+"))
                if n and rec.pdeaths[name] and n ~= rec.pdeaths[name] then Flag("death-count-wrong", where, ("%s %s (record %d): %s"):format(name, ntimes, rec.pdeaths[name], s)) end
            end
            local tn = s:match("(%u?%w+) times that day, %u[%w']+ was killed")
            if tn and Num(tn) and where.book ~= "own" and Num(tn) ~= rec.theirDeaths then Flag("death-count-wrong", where, ("%s (record %d): %s"):format(tn, rec.theirDeaths, s)) end
            -- pair of you with three present
            if Any(low, {"the pair of you", "the two of you", "both of you", "the two of us", "the pair of us"}) and presentCount >= 2 then
                Flag("pair-three", where, ("%d present: %s"):format(presentCount + 1, s))
            end
            -- place twice in a sentence
            for _, place in ipairs(placeList) do if CountIn(s, place) >= 2 then Flag("place-2-sentence", where, s) end end
            -- articles before foes
            for foe in pairs(rec.foes) do
                local bare = Esc(foe)
                if not GenericFoe(foe) and s:find("%f[%w][Aa]n? " .. bare) then Flag("article-named", where, s) end
                if GenericFoe(foe) and (s:find("^" .. bare) or s:find("[,;] " .. bare)) then Flag("generic-no-article", where, s) end
            end
            -- too / as well / also
            if Any(low, {" too[%.,]", " as well[%.,]", "^i also", "^we also", "^you also"}) then tooHere = tooHere + 1 end
            if Any(low, {"killed me too", "killed me as well", "killed you too", "killed you as well"}) then tailChain = tailChain + 1 end
            -- movement and furniture
            local kind = IsMove(s)
            if kind == "move" then moveCount = moveCount + 1 elseif kind == "rest" then restCount = restCount + 1 end
            if kind == "move" then
                local norm = low:gsub("^then ", ""):gsub("^after that, ", ""):gsub("^at the end of it, ", ""):gsub("^later, ", ""):gsub("^later that day, ", ""):gsub("%s+", " ")
                book.moves[norm] = (book.moves[norm] or 0) + 1
                if book.moves[norm] == 2 then Flag("transit-repeat", where, s) end
                -- a flicker told as travel: more movement sentences naming the zone than real stays in it
                for _, stay in ipairs(rec.stays) do
                    if stay.flicker and stay.zone and not rec.mouths[stay.zone] and Has(s, stay.zone) then
                        local key = where.chapter .. stay.zone
                        book.zoneMoves[key] = (book.zoneMoves[key] or 0) + 1
                        local real = 0
                        for _, st in ipairs(rec.stays) do if st.zone == stay.zone and not st.flicker then real = real + 1 end end
                        if book.zoneMoves[key] > real and not book.flagged[key] then
                            book.flagged[key] = true
                            Flag("flicker-told", where, stay.zone .. ": " .. s)
                        end
                    end
                end
            end
            -- deaths and kills
            if IsDeath(s) then deathSentences = deathSentences + 1; deathHere = true end
            if WordCount(s) <= 7 and Any(low, KILL) then killRun = killRun + 1 else killRun = 0 end
            if killRun == 3 then Flag("boss-ledger", where, (sentences[si - 2] or "") .. " " .. (sentences[si - 1] or "") .. " " .. s) end
            -- tallies
            for _, t in ipairs(TALLY) do if low:find(t) then tally = tally + 1; break end end
            if low:find("first") then firsts = firsts + 1 end
            if Any(low, CLOCK) then clocks = clocks + 1 end
            -- openings
            if si > 1 then
                local w1, w0 = FirstWord(s), FirstWord(sentences[si - 1])
                local pronoun = {i = true, we = true, you = true}
                if w1 == w0 and w1 ~= "" and (not pronoun[w1] or (si > 2 and FirstWord(sentences[si - 2]) == w1)) then
                    Flag("same-opening", where, sentences[si - 1] .. " " .. s)
                end
            end
            if WordCount(s) <= 6 then shortRun = shortRun + 1 else shortRun = 0 end
            if shortRun == 3 then Flag("short-run", where, (sentences[si - 2] or "") .. " " .. (sentences[si - 1] or "") .. " " .. s) end
            -- repeats
            local norm = low:gsub("%s+", " ")
            if seenSentence[norm] then Flag("sentence-repeat", where, "(chapter) " .. s)
            elseif bookSeen[norm] then Flag("sentence-repeat", where, "(book) " .. s) end
            seenSentence[norm] = true
        end
        for norm in pairs(seenSentence) do bookSeen[norm] = true end
        if tooHere >= 2 then Flag("too-chain", where, para:sub(1, 160)) end
        if deathHere then deathParas = deathParas + 1 end
        -- bursts
        if pi >= 3 then
            local n1, n2, n3 = #Sentences(paras[pi - 2]), #Sentences(paras[pi - 1]), #sentences
            if n1 <= 2 and n2 <= 2 and n3 <= 2 and not book.burst[where.chapter .. ":" .. (pi - 1)] then
                book.burst[where.chapter .. ":" .. pi] = true
                Flag("burst-paragraphs", where, paras[pi - 2] .. " | " .. paras[pi - 1] .. " | " .. para)
            end
        end
        -- we alone
        if where.book == "own" and presentCount == 0 then
            for _, s in ipairs(sentences) do
                if Any(s, {"^We ", "^Then we ", "[,;] we ", "^Both of us", "^The two of us"}) and not Any(s:lower(), {"we had never met", "we had not met", "we never met"}) then
                    Flag("we-alone", where, s)
                end
            end
        end
    end
    -- chapter-wide
    for n, c in pairs(levelSaid) do if c >= 2 then Flag("level-twice", where, ("level %d x%d: %s"):format(n, c, Short(plain, 200))) end end
    for d, c in pairs(dungeonEntered) do if c >= 2 then Flag("dungeon-twice", where, ("%s x%d: %s"):format(d, c, Short(plain, 160))) end end
    for d, c in pairs(dungeonParas) do if c >= 2 then Flag("episode-split", where, ("%s in %d paragraphs: %s"):format(d, c, Short(plain, 120))) end end
    for b in pairs(rec.bosses) do
        local n = 0
        for _, s in ipairs(allSentences) do if Has(s, b) then n = n + 1 end end
        if n >= 2 then Flag("boss-twice", where, ("%s x%d: %s"):format(b, n, Short(plain, 120))) end
    end
    -- a level told away from where it came
    for _, lv in ipairs(rec.levels) do
        if lv.n and lv.z then
            for _, para in ipairs(paras) do
                if para:find("[Ll]evel " .. lv.n .. "%f[%D]") or (A.JournalWords and para:find("[Ll]evel " .. A.JournalWords(lv.n) .. "%f[%W]")) then
                    local named = {}
                    for _, place in ipairs(placeList) do if rec.zones[place] and Has(para, place) then named[#named + 1] = place end end
                    local there = Has(para, lv.z) or (rec.mouths[lv.z] and Has(para, rec.mouths[lv.z]))
                    if #named > 0 and not there then
                        Flag("level-place", where, ("level %d came in %s, told among %s: %s"):format(lv.n, lv.z, table.concat(named, ", "), para:sub(1, 100) .. "..."))
                    end
                end
            end
        end
    end
    if deathParas >= 3 then Flag("deaths-split", where, ("%d paragraphs with deaths: %s"):format(deathParas, Short(plain))) end
    if deathSentences >= 5 then Flag("death-ledger", where, ("%d death sentences: %s"):format(deathSentences, Short(plain))) end
    if tailChain >= 2 then Flag("death-tail-chain", where, Short(plain)) end
    if tally >= 3 then Flag("craft-ledger", where, ("%d tallies: %s"):format(tally, Short(plain, 120))) end
    if oneLiners >= 3 then Flag("one-liners", where, ("%d one-sentence paragraphs: %s"):format(oneLiners, Short(plain))) end
    if total >= 8 and (moveCount + restCount) / total > 0.34 then
        Flag("transit-share", where, ("%d of %d sentences move or rest: %s"):format(moveCount + restCount, total, Short(plain)))
    end
    if firsts >= 4 then Flag("first-time-chain", where, ("%d x first: %s"):format(firsts, Short(plain, 120))) end
    if clocks >= 3 then Flag("clock-chain", where, ("%d clock openings: %s"):format(clocks, Short(plain, 120))) end
    -- names that die or raise without an introduction
    local function Introduced(name)
        return Any(plain, {Esc(name) .. "[%w' ]*, an? ", Esc(name) .. "[%w' ]*, whom", Esc(name) .. "[%w' ]*, though", Esc(name) .. "[%w' ]*, who ",
            Esc(name) .. "[%w' ]*, barely", Esc(name) .. "[%w' ]*, my ", Esc(name) .. "[%w' ]*, your ", "stranger named " .. Esc(name)})
    end
    for name in pairs(rec.pdeaths) do
        if not present[name] and not people[name] and plain:find("%f[%w]" .. Esc(name) .. "%f[%W]") and not Introduced(name) then
            Flag("unintroduced-name", where, name .. ": " .. (plain:match("[^%.]*%f[%w]" .. Esc(name) .. "%f[%W][^%.]*%.") or ""))
        end
    end
    for _, name in ipairs(rec.rezBy) do
        if not present[name] and not people[name] and plain:find("%f[%w]" .. Esc(name) .. "%f[%W]") and not Introduced(name) then
            Flag("unintroduced-name", where, name .. ": " .. (plain:match("[^%.]*%f[%w]" .. Esc(name) .. "%f[%W][^%.]*%.") or ""))
        end
    end
    -- a place new again
    for _, place in ipairs(placeList) do
        local bare = Esc(Bare(place))
        local fresh
        for _, pat in ipairs({Opt("first time in ", bare), {bare .. " was new to"}, Opt("never been to ", bare), Opt("never seen ", bare),
            Opt("came into ", bare, ", where I had never been"), Opt("came to ", bare, " for the first time"), Opt("", bare, ", where I had never been"),
            Opt("", bare, ", my first time there"), Opt("", bare, ", new to me")}) do
            for _, p in ipairs(pat) do fresh = fresh or plain:find(p) end
        end
        if fresh and book.places[place] then Flag("first-again", where, place .. ": " .. plain:sub(fresh, fresh + 80)) end
    end
    for _, place in ipairs(placeList) do if Has(plain, place) then book.places[place] = true end end
    return total
end

-- Telling a life through every teller, book and voice ---------------------------------------
local sentencesRead, chaptersRead = 0, 0
local function NewBook() return {moves = {}, zoneMoves = {}, flagged = {}, burst = {}, places = {}} end
local function Tell(life, me, people, source)
    for _, teller in ipairs({"current", "planned"}) do
        A.BookVariant = teller == "planned" and PLANNED or nil
        A.db.people = {}
        for key, p in pairs(people) do A.db.people[key] = p end
        local peopleNames = {}
        for _, p in pairs(people) do peopleNames[First(p.name)] = true end
        A.SelfPerson = function() return me end
        me.retell = 0
        local days = A.JournalBook(me)
        local stories = A.SelfTale.Tell(me, days, false, 0)
        local bookSeen, book = {}, NewBook()
        for _, d in ipairs(days) do
            local s = stories[d.key]
            if s and s.text ~= "" then
                chaptersRead = chaptersRead + 1
                local present, known = Party(me.journal, d.key)
                local where = {life = life, book = "own", teller = teller, voice = "i", chapter = s.chapter or 0, source = source}
                sentencesRead = sentencesRead + Read(where, A.JournalPlain(s.text), Record(me.journal, d.key), present, known, peopleNames, bookSeen, book)
            end
        end
        local player = {name = me.name, race = me.race, faction = me.faction, class = me.class, charKey = me.charKey}
        for _, person in pairs(people) do
            for _, voice in ipairs({"you", "we"}) do
                person.retell = 0
                local cdays = A.JournalBook(person)
                local cstories = A.JournalTale.Tell(person, cdays, voice, player, false)
                local cSeen, cbook = {}, NewBook()
                for _, d in ipairs(cdays) do
                    local s = cstories[d.key]
                    if s and s.text ~= "" then
                        chaptersRead = chaptersRead + 1
                        local present, known = Party(me.journal, d.key)
                        present[First(person.name)] = nil
                        local where = {life = life, book = First(person.name), teller = teller, voice = voice, chapter = s.chapter or 0, source = source}
                        sentencesRead = sentencesRead + Read(where, A.JournalPlain(s.text), Record(person.journal, d.key), present, known, peopleNames, cSeen, cbook)
                    end
                end
            end
        end
    end
    A.BookVariant = nil
end

-- Lives from the simulator's batches (the log written once, both journals from it: a copy of
-- StorageInvestigation/journal-voice/sim/lives.lua Build) ---------------------------------------
local SIM_BASE = os.time({year = 2026, month = 10, day = 5, hour = 0})
local function SimAt(day, hour, minute) return SIM_BASE + day * 86400 + math.floor((hour or 20) * 3600) + (minute or 0) * 60 end
local OWN_ONLY = {gather = true, craft = true, first = true, town = true, close = true, cave = true, voyage = true, swim = true,
    nightflight = true, sleep = true, hearth = true, home = true, guild = true, bg = true}
local function BuildSim(life)
    local own, people = {}, {}
    for key, c in pairs(life.companions or {}) do
        local roles = {WARRIOR = "tank", PRIEST = "healer", DRUID = "healer", SHAMAN = "healer", PALADIN = "tank"}
        people[key] = {name = c.name .. "-Forever", class = c.class, race = c.race, pronouns = c.pronouns, journal = {}, origin = c.origin, bond = c.bond,
            role = c.role or roles[c.class] or "damage"}
    end
    for _, day in ipairs(life.days) do
        local t = SimAt(day.day, day.hour or 20, day.minute or 0)
        for _, seg in ipairs(day.segs) do
            local e = t + seg.min * 60
            own[#own + 1] = {k = "play", t = t, e = e, z = seg.zone, pl = seg.pl}
            local with = seg.with or {}
            for _, key in ipairs(with) do
                local p = people[key]
                own[#own + 1] = {k = "with", d = key, n = p.name, t = t, e = e}
                p.met = p.met or t
                p.metZone = p.metZone or seg.zone
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
                    if k == "rez" then entry.by = ev.by end
                    own[#own + 1] = entry
                end
                if not OWN_ONLY[k] then
                    for _, key in ipairs(with) do
                        local p = people[key]
                        local entry = {t = et, z = seg.zone, pl = seg.pl, ol = seg.ol or seg.pl}
                        if k == "quest" then entry.k, entry.d, entry.ql = "quest", ev.d, ev.ql
                        elseif k == "dungeon" then entry.k, entry.d, entry.z, entry.r, entry.tr = "dungeon", ev.d, ev.d, ev.r, p.role or ev.tr
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
local simCount = 0
for _, batch in ipairs({"batch1", "batch2", "batch3"}) do
    local chunk = loadfile("StorageInvestigation/journal-voice/sim/lives/" .. batch .. ".lua")
    if chunk then
        local LIVES, ORDER2 = {}, {}
        chunk(function(key, life) life.key = key; LIVES[key] = life; ORDER2[#ORDER2 + 1] = key end,
            function(title, ql) return {k = "quest", d = title, ql = ql} end)
        for _, key in ipairs(ORDER2) do
            local me, people = BuildSim(LIVES[key])
            Tell(batch .. ":" .. key, me, people, "sim")
            simCount = simCount + 1
        end
    end
end

-- Generated days: pass3/gen_days.lua with a fixed seed ---------------------------------------
local genCount, genLives = 0, 0
local gen = loadfile("StorageInvestigation/cj-story-breakthrough-20261109/pass3/gen_days.lua")
if gen then
    local G = gen()
    for _, life in ipairs(G.Generate(A, 20261111, genDays)) do
        Tell(life.key, life, life.people, "gen")
        genLives, genCount = genLives + 1, genCount + life.dayCount
    end
end

-- Lives written as a record: a day is a date, then stays ("21:11-21:18 Zone"), party spans
-- ("with name 21:18 02:01") and entries ("21:13 hearth d=Gallows' End Tavern"). A time before
-- noon is the small hours of the next date. --------------------------------------------------
local function Minutes(hm) local h, m = hm:match("(%d+):(%d+)"); return tonumber(h) * 60 + tonumber(m) end
local function BuildRecord(spec)
    local own, people, with = {}, {}, {}
    for key, c in pairs(spec.companions or {}) do
        people[key] = {name = c.name .. "-" .. (c.realm or "Forever"), class = c.class, race = c.race, pronouns = c.pronouns, journal = {}, role = c.role or "damage"}
    end
    local level = spec.startLevel or 1
    local dayBase
    local function At(hm)
        local m = Minutes(hm)
        return dayBase + m * 60 + (m < 12 * 60 and 86400 or 0)
    end
    for line in (spec.days .. "\n"):gmatch("(.-)\n") do
        line = Trim(line)
        if line:match("^@") then
            local y, mo, d = line:match("@(%d+)%-(%d+)%-(%d+)")
            dayBase = os.time({year = tonumber(y), month = tonumber(mo), day = tonumber(d), hour = 0})
            local pl = line:match("pl=(%d+)")
            if pl then level = tonumber(pl) end
        elseif line:match("^with ") then
            local who, a, b = line:match("^with (%S+) (%d+:%d+) (%d+:%d+)")
            local p = people[who] or error("unknown companion " .. tostring(who))
            local t, e = At(a), At(b)
            own[#own + 1] = {k = "with", d = who, n = p.name, t = t, e = e}
            with[#with + 1] = {key = who, t = t, e = e}
            p.met = p.met or t
        elseif line:match("^%d+:%d+%-%d+:%d+ ") then
            local a, b, zone = line:match("^(%d+:%d+)%-(%d+:%d+) (.+)$")
            local t, e = At(a), At(b)
            own[#own + 1] = {k = "play", t = t, e = e, z = zone, pl = level}
            for _, w in ipairs(with) do
                if math.min(w.e, e) - math.max(w.t, t) > 0 then
                    people[w.key].metZone = people[w.key].metZone or zone
                    local j = people[w.key].journal
                    j[#j + 1] = {k = "group", t = math.max(w.t, t), e = math.min(w.e, e), z = zone, pl = level, ol = level}
                end
            end
        elseif line ~= "" and not line:match("^%-%-") then
            local hm, kind, rest = line:match("^(%d+:%d+) (%S+) ?(.*)$")
            local entry = {k = kind, t = At(hm), pl = level}
            local keys = {}
            for pos, key in rest:gmatch("()(%w+)=") do keys[#keys + 1] = {pos = pos, key = key} end
            for i, kv in ipairs(keys) do
                local from = kv.pos + #kv.key + 1
                local to = keys[i + 1] and keys[i + 1].pos - 2 or #rest
                local value = Trim(rest:sub(from, to))
                entry[kv.key] = tonumber(value) or value
            end
            if kind == "mylevel" then level = tonumber(entry.d); entry.pl = level end
            if not entry.z then
                for i = #own, 1, -1 do if own[i].k == "play" then entry.z = own[i].z; break end end
            end
            own[#own + 1] = entry
            for _, w in ipairs(with) do
                if entry.t >= w.t and entry.t <= w.e then
                    local p = people[w.key]
                    local c = {t = entry.t, z = entry.z, pl = level, ol = level}
                    if kind == "quest" then c.k, c.d, c.ql, c.qid = "quest", entry.d, entry.ql, entry.qid
                    elseif kind == "dungeon" then c.k, c.d, c.r, c.tr = "dungeon", entry.d, entry.r, p.role
                    elseif kind == "boss" then c.k, c.d, c.n = "boss", entry.d, entry.n
                    elseif kind == "wipe" then c.k, c.d = "wipe", entry.d
                    elseif kind == "death" then c.k, c.w, c.d, c.env, c.boss = "death", "you", entry.d, entry.env, entry.boss
                    elseif kind == "pdeath" and First(entry.n) == First(p.name) then c.k, c.w, c.boss = "death", "them", entry.boss
                    elseif kind == "rez" and entry.by and First(entry.by) == First(p.name) then c.k = "rez"
                    elseif kind == "mylevel" then c.k, c.d = "mylevel", entry.d
                    elseif kind == "campfire" then c.k = "campfire"
                    elseif kind == "rest" then c.k, c.d = "rest", entry.d
                    else c = nil end
                    if c then p.journal[#p.journal + 1] = c end
                end
            end
        end
    end
    local me = {self = true, charKey = spec.key, name = spec.name, race = spec.race, faction = spec.faction, class = spec.class,
        startLevel = spec.startLevel, journal = own}
    return me, people
end

-- Alberich's real days 4 and 5 (2026-11-09 and 10), as the raw record printed them, with the
-- party spans the printer leaves out, after three short days with Dahlia so she is known.
local ALBERICH = {key = "alberich", name = "Alberich", race = "Scourge", faction = "Horde", class = "PALADIN", startLevel = 1,
    companions = {dahlia = {name = "Dahlia", realm = "Noir", class = "MAGE", race = "Scourge", pronouns = "she"},
        marrow = {name = "Marrow", realm = "Rotmoor", class = "PALADIN", race = "Scourge", pronouns = "he", role = "tank"},
        varreth = {name = "Varreth", realm = "Aurenar", class = "PALADIN", race = "Scourge", pronouns = "he", role = "tank"}},
    days = [[
@2026-11-06 pl=1
with dahlia 20:00 23:30
20:00-23:30 Tirisfal Glades
20:02 town d=Deathknell
20:40 quest d=Rattling the Rattlecages qid=365 ql=3
21:10 death d=Vampiric Duskbat w=you
21:30 mylevel d=6
22:00 town d=Brill
22:30 quest d=A Putrid Task qid=380 ql=6
23:00 mylevel d=8
23:10 rest d=Gallows' End Tavern
@2026-11-07 pl=8
with dahlia 20:00 01:30
20:00-23:00 Tirisfal Glades
20:30 quest d=Scavenging Deathknell qid=367 ql=3
21:30 quest d=The Mills Overrun qid=426 ql=10
22:00 mylevel d=11
23:00-01:30 Undercity
23:01 town d=Undercity
23:30 quest d=Speak with Sevren qid=404 ql=8
@2026-11-08 pl=11
with dahlia 21:10 01:00
with marrow 21:10 21:40
20:00-21:00 Undercity
21:00-21:10 Tirisfal Glades
21:05 death d=Dark Enforcer w=you
21:10-01:00 Tirisfal Glades
22:00 quest d=Fields of Grief qid=405 ql=10
22:40 death d=Riptear w=you sz=Venomweb Vale
23:30 quest d=Rear Guard Patrol qid=1819 ql=11
00:10 mylevel d=14
@2026-11-09 pl=14
with dahlia 21:18 02:01
with marrow 21:56 23:25
with varreth 23:33 01:11
21:11-21:18 Tirisfal Glades
21:13 hearth d=Gallows' End Tavern
21:13 rest d=Gallows' End Tavern
21:14 town d=Brill
21:18-21:49 Silverpine Forest
21:18 first d=zone z=Silverpine Forest
21:23 gather d=mining c=11
21:40 town d=The Sepulcher
21:42 campfire
21:45 quest d=Delivery to Silverpine Forest qid=445 ql=10
21:45 quest d=Wild Hearts qid=429 ql=11
21:46 rest d=The Sepulcher
21:48 quest d=Supplying the Sepulcher qid=6321 ql=10
21:48 first d=flight
21:49-21:49 Tirisfal Glades
21:49-21:55 Undercity
21:49 town d=Undercity
21:49 rest d=Sewers
21:51 quest d=Ride to the Undercity qid=6323 ql=10
21:51 quest d=Michael Garrett qid=6322 ql=10
21:55-21:56 Tirisfal Glades
21:56-23:25 Silverpine Forest
21:56 cave d=North Tide's Hollow
21:57 town d=The Sepulcher
21:58 quest d=Return to Podrig qid=6324 ql=10
22:03 gather d=mining c=25
22:04 quest d=Prove Your Worth qid=421 ql=11
22:06 death d=Son of Arugal w=you
22:10 first d=rarebeast z=Gorefang sz=Silverpine Forest
22:16 quest d=Return to Quinn qid=430 ql=11
22:30 mylevel d=15
22:35 craft d=Cooking c=23
22:52 home d=The Sepulcher
22:52 quest d=Wild Eyes qid=91920 ql=11
22:53 rest d=The Sepulcher
22:53 quest d=The Dead Fields qid=437 ql=14
22:54 quest d=Arugal's Folly qid=422 ql=11
23:24 nightflight
23:25-23:26 Tirisfal Glades
23:26-23:33 Undercity
23:26 town d=Undercity
23:26 rest d=Sewers
23:28 quest d=A Recipe For Death qid=447
23:33 hearth d=The Sepulcher
23:33-01:11 Silverpine Forest
23:33 town d=The Sepulcher
23:39 cave d=North Tide's Hollow
23:57 gather d=mining c=17
23:59 quest d=Return to Quinn (Again) qid=91921 ql=11
00:02 quest d=Ivar the Foul qid=425 ql=12
00:07 campfire
00:08 quest d=Arugal's Folly qid=423 ql=14
00:12 quest d=The Decrepit Ferry qid=438 ql=16
00:13 cave d=Deep Elem Mine
00:21 quest d=Arugal's Folly qid=424 ql=15
00:21 rest d=The Sepulcher
00:21 mylevel d=16
00:21 quest d=Rot Hide Clues qid=439 ql=16
00:30 death d=Rot Hide Brute w=you sz=Fenris Isle
00:35 quest d=Resting in Pieces qid=460 ql=17
00:40 death d=Raging Rot Hide w=you sz=Fenris Isle
00:40 pdeath n=Dahlia-Noir
00:40 rez by=Ralph Cuthbridge w=them
00:49 first d=rarebeast z=Snarlmane sz=Silverpine Forest
00:50 death d=Rot Hide Savage w=you sz=Fenris Keep
00:50 rez by=Varreth Aurenar w=them
00:53 death d=Raging Rot Hide w=you sz=Fenris Keep walk=200
00:54 pdeath n=Dahlia-Noir
00:55 pdeath n=Varreth-Aurenar
01:00 quest d=The Hidden Niche qid=461 ql=18
01:03 death d=Thule Ravenclaw w=you sz=Fenris Keep
01:03 pdeath n=Dahlia-Noir
01:03 pdeath n=Saint-Sunny
01:04 pdeath n=Varreth-Aurenar
01:07 quest d=Rot Hide Ichor qid=443 ql=17
01:10 nightflight
01:11-01:11 Tirisfal Glades
01:11-02:01 Undercity
01:11 town d=Undercity
01:12 rest d=Sewers
01:13 quest d=Rot Hide Origins qid=444 ql=17
01:14 quest d=Wand to Bethor qid=491
01:17 craft d=Mining c=53
01:29 pdeath n=Dahlia-Noir
01:40 craft d=Blacksmithing c=20
@2026-11-10 pl=16
with dahlia 21:57 01:20
with marrow 21:57 00:05
21:26-21:28 Undercity
21:26 town d=Undercity
21:26 sleep d=Trade Quarter
21:28-21:35 Tirisfal Glades
21:29 town d=Brill
21:31 craft d=First Aid c=35
21:33 quest d=The Engraved Ring qid=440 ql=16
21:35-21:53 Undercity
21:35 town d=Undercity
21:35 rest d=Ruins of Lordaeron
21:36 quest d=Raleigh and the Undercity qid=441 ql=16
21:48 sleep d=Trade Quarter
21:53-21:56 Tirisfal Glades
21:55 town d=Brill
21:56 voyage d=zeppelin from=Eastern Kingdoms to=Kalimdor
21:56 first d=zeppelin
21:56 first d=continent z=Kalimdor
21:56-21:57 Durotar
21:57-22:11 Orgrimmar
21:57 first d=zone z=Orgrimmar
21:57 town d=Orgrimmar
21:57 rest d=Orgrimmar
22:07 quest d=Meal Appeal qid=97246 ql=15
22:11-22:15 Ragefire Chasm
22:11 dungeon d=Ragefire Chasm r=tank
22:14 death d=Ragefire Trogg w=you
22:15 pdeath n=Borox-Cryptcreeper
22:15-22:15 Durotar
22:15 pdeath n=Marrow-Rotmoor
22:15-22:17 Orgrimmar
22:15 town d=Orgrimmar
22:15 rest d=Orgrimmar
22:15 pdeath n=Dahlia-Noir
22:17-22:47 Ragefire Chasm
22:17 dungeon d=Ragefire Chasm r=tank
22:23 boss d=Oggleflint n=5
22:31 boss d=Taragaman the Hungerer n=5
22:39 boss d=Jergosh the Invoker
22:44 boss d=Bazzalan n=5
22:47-23:17 Orgrimmar
22:47 town d=Orgrimmar
22:47 mylevel d=17
22:47 quest d=Slaying the Beast qid=5761 ql=16
23:17-23:24 Durotar
23:24 voyage d=zeppelin from=Kalimdor to=Eastern Kingdoms
23:24 first d=continent z=Eastern Kingdoms
23:24-23:32 Stranglethorn Vale
23:24 first d=zone z=Stranglethorn Vale
23:24 town d=Grom'gol Base Camp
23:27 pdeath n=Marrow-Rotmoor
23:27 pdeath n=Dahlia-Noir
23:28 first d=rezother n=Dahlia
23:30 pdeath n=Dahlia-Noir
23:30 pdeath n=Marrow-Rotmoor
23:30 death d=Venture Co. Geologist w=you sz=Venture Co. Base Camp
23:32-23:46 Duskwood
23:32 first d=zone z=Duskwood
23:33 pdeath n=Dahlia-Noir
23:35 pdeath n=Dahlia-Noir
23:35 death d=Bishop Jericho w=you
23:39 rez by=Marrow Rotmoor w=them
23:42 death d=Veni Lace w=you
23:43 pdeath n=Marrow-Rotmoor
23:43 pdeath n=Dahlia-Noir
23:46-23:46 Stranglethorn Vale
23:46-23:46 Duskwood
23:46-23:49 Stranglethorn Vale
23:49-23:59 Duskwood
23:53 quest d=An Unfortunate End qid=98372
23:59-00:05 Stranglethorn Vale
00:05 hearth d=The Sepulcher
00:05-00:08 Silverpine Forest
00:05 town d=The Sepulcher
00:05 quest d=Thule Ravenclaw qid=446 ql=16
00:06 rest d=The Sepulcher
00:06 quest d=Report to Hadrec qid=448 ql=16
00:07 nightflight
00:08-00:08 Tirisfal Glades
00:08-00:21 Undercity
00:08 town d=Undercity
00:08 rest d=Sewers
00:11 quest d=The Power to Destroy... qid=5725 ql=16
00:14 sleep d=Canals
00:21-00:24 Tirisfal Glades
00:24 town d=Brill
00:24 voyage d=zeppelin from=Eastern Kingdoms to=Kalimdor
00:24-00:30 Durotar
00:30-00:43 The Barrens
00:30 first d=zone z=The Barrens
00:34 town d=The Crossroads
00:35 rest d=The Crossroads
00:43-00:44 The Wailing Caverns
00:43 cave d=Wailing Caverns
00:44-00:44 The Barrens
00:44-00:44 The Wailing Caverns
00:44 cave d=Wailing Caverns
00:44-01:06 The Barrens
00:48 gather d=mining c=7
01:04 town d=Camp Taurajo
01:06-01:20 Mulgore
01:12 town d=Bloodhoof Village
01:12 rest d=Bloodhoof Village
01:20-02:04 Thunder Bluff
01:20 first d=zone z=Thunder Bluff
01:20 town d=Thunder Bluff
01:20 rest d=Thunder Bluff
01:29 sleep d=Thunder Bluff
01:35 craft d=Fishing c=3
01:35 gather d=fishing c=15
]]}

-- A trio with a known raiser: three present in a dungeon (never "the pair of you"), the healer
-- met the day before raising you (never "a stranger"), a companion dying twice within a minute
-- (never "Gromm and Gromm"), a level that comes in the dungeon and must be told there.
local TRIO = {key = "trio", name = "Korrin", race = "Orc", faction = "Horde", class = "WARRIOR", startLevel = 14,
    companions = {sela = {name = "Sela", class = "PRIEST", race = "Troll", pronouns = "she", role = "healer"},
        gromm = {name = "Gromm", class = "ROGUE", race = "Orc", pronouns = "he"}},
    days = [[
@2026-10-12 pl=14
with sela 20:00 22:00
20:00-22:00 The Barrens
20:05 town d=The Crossroads
20:40 quest d=Raptor Thieves qid=870 ql=12
21:10 death d=Razormane Hunter w=you
21:12 rez by=Sela w=them
21:40 mylevel d=15
@2026-10-13 pl=15
with sela 20:00 23:40
with gromm 20:00 23:40
20:00-20:30 The Barrens
20:05 town d=The Crossroads
20:30-20:31 The Wailing Caverns
20:30 cave d=Wailing Caverns
20:31-22:40 Wailing Caverns
20:31 dungeon d=Wailing Caverns r=tank
20:50 boss d=Lady Anacondra n=5
21:05 death d=Deviate Shambler w=you
21:06 rez by=Sela w=them
21:20 boss d=Lord Cobrahn n=5
21:30 pdeath n=Gromm-Forever
21:31 pdeath n=Gromm-Forever
21:50 mylevel d=16
22:00 boss d=Lord Pythas n=5
22:25 boss d=Mutanus the Devourer n=5
22:40-22:40 The Wailing Caverns
22:40-23:40 The Barrens
22:45 quest d=Deviate Eradication qid=1487 ql=20
23:00 town d=Ratchet
23:10 mylevel d=17
]]}

for _, spec in ipairs({ALBERICH, TRIO}) do
    local me, people = BuildRecord(spec)
    Tell(spec.key, me, people, "record")
end

-- Report --------------------------------------------------------------------------------------
local hardFails = 0
print(("StoryLint read %d chapters, %d sentences: %d simulated lives, %d generated lives (%d days, seed 20261111), 2 recorded lives; both tellers, both voices"):format(
    chaptersRead, sentencesRead, simCount, genLives, genCount))
print("")
print("rule                  hard  count  current planned    sim  gen record   what")
for _, name in ipairs(ORDER) do
    local r = RULES[name]
    if r.hard and r.count > 0 then hardFails = hardFails + 1 end
    print(("%-21s %-5s %5d  %7d %7d  %5d %4d %6d   %s"):format(name, r.hard and "HARD" or "soft", r.count, r.by.current or 0, r.by.planned or 0,
        r.by.sim or 0, r.by.gen or 0, r.by.record or 0, r.what))
end
print("")
print("Worst examples")
for _, name in ipairs(ORDER) do
    local r = RULES[name]
    if r.count > 0 then
        print(("  %s (%d)"):format(name, r.count))
        for _, x in ipairs(r.examples) do print(("    %s: %s"):format(x.tag, x.example)) end
    end
end
print("")
if hardFails > 0 then
    io.write(("FAIL: %d hard rules flagged\n"):format(hardFails))
    os.exit(1)
end
io.write("PASS: no hard rule flagged\n")
