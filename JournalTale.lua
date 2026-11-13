local _, A = ...
-- The storyteller: Story mode. Each day of the book becomes a short chapter,
-- told like a game master recapping the campaign in the plain, weathered
-- voice of the old quest givers. What it says always happened: places, foes,
-- levels, deaths, fires, lengths and counts come from the journal; the lore
-- (Lore.lua) only says what a place or a foe is. The telling changes with the
-- companionship: how long you have known each other and how often you meet
-- (every day, several times a week, weekly, every couple of weeks, monthly,
-- rarely, or only in passing), a long silence and the return, a streak; with
-- your levels (fledglings to legends, or one far ahead of the other), the
-- danger (a dungeon above your station or an old haunt), the land (home, old
-- roads, perilous country, new country), and what happened (bosses, deaths
-- heroic or silly, a fight lost and won back, a rescue, a fire, an inn).
-- Wording comes from a seeded draw (the same day always reads the same) and
-- avoids what the last days already said.
local T = {}
A.JournalTale = T

-- A short scene is authored as a whole: purpose, action and consequence.
-- Only an exact matching stage may opt in; old title-only records keep their
-- conservative full scene. Never infer compression from importance or length.
local function CompactQuest(quest, story, brief)
    local precise = quest and quest.qid and A.Lore.questStoryIDs[tonumber(quest.qid)]
    return brief and precise == story and precise.title == quest.title
        and type(story.highlight) == "table" and #story.highlight > 0
end
local function CompactBeat(story, previous)
    if previous and story.thread and previous.thread then
        return story.thread == previous.thread and "questOutcome" or "questTurn"
    end
    return "questStart"
end
local function QuestEnding(quest, story, brief, rng)
    -- Use the existing outcome draw for either edition, leaving later choices
    -- unchanged when an author adds a compact scene or another short variant.
    local draw = rng()
    local lines = CompactQuest(quest, story, brief) and story.highlight or story.after
    return lines[math.floor(draw * #lines) + 1]
end

-- Draws ---------------------------------------------------------------------------
local function Hash(text)
    local h = 5381
    for i = 1, #text do h = (h * 33 + text:byte(i)) % 2147483647 end
    return h
end
local function Rng(seed)
    local state = Hash(seed)
    return function(n)
        state = (state * 1103515245 + 12345) % 2147483648
        local value = math.floor(state / 65536) / 32768
        if n then return math.floor(value * n) + 1 end
        return value
    end
end

-- Words -----------------------------------------------------------------------------
local ONES = {"one", "two", "three", "four", "five", "six", "seven", "eight", "nine", "ten", "eleven", "twelve",
    "thirteen", "fourteen", "fifteen", "sixteen", "seventeen", "eighteen", "nineteen"}
local TENS = {[2] = "twenty", [3] = "thirty", [4] = "forty", [5] = "fifty", [6] = "sixty", [7] = "seventy", [8] = "eighty", [9] = "ninety"}
local function Words(n)
    n = math.floor(tonumber(n) or 0)
    if n >= 1 and n <= 19 then return ONES[n] end
    if n >= 20 and n <= 99 then
        local tens, ones = math.floor(n / 10), n % 10
        return TENS[tens] .. (ones > 0 and ("-" .. ONES[ones]) or "")
    end
    if n == 100 then return "a hundred" end
    return tostring(n)
end
local ORD = {"first", "second", "third", "fourth", "fifth", "sixth", "seventh", "eighth", "ninth", "tenth", "eleventh", "twelfth",
    "thirteenth", "fourteenth", "fifteenth", "sixteenth", "seventeenth", "eighteenth", "nineteenth", "twentieth"}
local function Ordinal(n)
    n = math.floor(tonumber(n) or 0)
    if ORD[n] then return ORD[n] end
    local last = n % 10
    local suffix = (n % 100 >= 11 and n % 100 <= 13) and "th" or last == 1 and "st" or last == 2 and "nd" or last == 3 and "rd" or "th"
    return n .. suffix
end
local ROMAN = {{1000, "M"}, {900, "CM"}, {500, "D"}, {400, "CD"}, {100, "C"}, {90, "XC"}, {50, "L"}, {40, "XL"},
    {10, "X"}, {9, "IX"}, {5, "V"}, {4, "IV"}, {1, "I"}}
local function Roman(n)
    local out = {}
    for _, pair in ipairs(ROMAN) do
        while n >= pair[1] do out[#out + 1] = pair[2]; n = n - pair[1] end
    end
    return table.concat(out)
end
local function List(items)
    if #items <= 1 then return items[1] or "" end
    return table.concat(items, ", ", 1, #items - 1) .. " and " .. items[#items]
end
-- A title that ends in a full stop ("Reagents for Reclaimers Inc.") takes no second one.
local function OneStop(text)
    text = tostring(text or ""):gsub("%.(})%.", ".%1"):gsub("([^%.])%.%.([^%.])", "%1.%2"):gsub("([^%.])%.%.$", "%1.")
    return text
end
local function Clean(text) return (tostring(text or ""):gsub("[{}%[%]|]", "")) end
local function Q(text) return "{q:" .. Clean(text) .. "}" end
local function About(seconds)
    local minutes = (seconds or 0) / 60
    if minutes < 12 then return "a short while" end
    if minutes < 50 then return "about " .. Words(math.floor(minutes / 5 + 0.5) * 5) .. " minutes" end
    if minutes < 75 then return "about an hour" end
    local hours = minutes / 60
    local whole, frac = math.floor(hours), hours - math.floor(hours)
    if frac < 0.2 then return "about " .. Words(whole) .. " hours" end
    if frac < 0.7 then return "over " .. (whole == 1 and "an hour" or (Words(whole) .. " hours")) end
    return "nearly " .. Words(whole + 1) .. " hours"
end
local function Span(days)
    days = math.floor(days + 0.5)
    if days < 14 then return Words(days) .. (days == 1 and " day" or " days") end
    if days < 60 then local weeks = math.floor(days / 7 + 0.5); return Words(weeks) .. (weeks == 1 and " week" or " weeks") end
    if days < 350 then local months = math.floor(days / 30 + 0.5); return Words(months) .. (months == 1 and " month" or " months") end
    local years = math.floor(days / 365 + 0.5)
    return years == 1 and "a year" or (Words(years) .. " years")
end
-- "The very next day", "a week to the day", "some ten days later"... (rng: a draw).
local function Later(days, rng)
    local function One(options) return options[rng and rng(#options) or 1] end
    days = math.floor(days + 0.5)
    if days <= 1 then return One({"the very next day", "the next day", "a day later"}) end
    if days == 2 then return One({"two days later", "a couple of days later"}) end
    if days <= 4 then return One({Words(days) .. " days later", "a few days later"}) end
    if days <= 6 then return One({"a few days later", Words(days) .. " days later", "most of a week later"}) end
    if days == 7 then return One({"a week later", "seven days later", "a week to the day"}) end
    if days <= 10 then return One({"a week or so later", "some " .. Words(days) .. " days later", "the next week"}) end
    if days <= 13 then return One({"nearly two weeks later", "some " .. Words(days) .. " days later"}) end
    return Span(days) .. " later"
end
-- A gap in words, as a game master says it ("a week", "two months", "half a year").
-- n alternates the near forms by a counter, never by a draw.
local function SinceWords(days, n)
    local alt = (n or 0) % 2 == 1
    if days <= 10 then return days == 7 and "a week" or (Words(days) .. " days") end
    if days <= 13 then return Words(days) .. " days" end
    if days <= 16 then return "two weeks" end
    if days <= 20 then return alt and "nearly three weeks" or (Words(days) .. " days") end
    if days <= 24 then return "three weeks" end
    if days <= 27 then return alt and "nearly a month" or "four weeks" end
    if days <= 33 then return alt and "four weeks" or "a month" end
    if days <= 38 then return alt and "a month" or "five weeks" end
    if days <= 45 then return alt and "a month and a half" or "six weeks" end
    if days <= 165 then return Words(math.floor(days / 30 + 0.5)) .. " months" end
    if days <= 200 then return alt and "six months" or "half a year" end
    if days <= 330 then return Words(math.floor(days / 30 + 0.5)) .. " months" end
    if days <= 400 then return "a year" end
    if days <= 540 then return "more than a year" end
    return Words(math.floor(days / 365 + 0.5)) .. " years"
end
-- "The dunes of Tanaris were", "the green hell of Stranglethorn was".
-- Names that are plural too: "the Wailing Caverns were", "Blackfathom Deeps were".
local PLURAL_NAMES = {Caverns = true, Deeps = true, Downs = true, Deadmines = true, Barrens = true, Wetlands = true,
    Badlands = true, Hinterlands = true, Steppes = true, Plaguelands = true, Lands = true, Foothills = true, Mountains = true,
    Needles = true, Highlands = true, Glades = true, Islands = true}
local function Plural(phrase)
    if type(phrase) ~= "string" then return false end
    local before = phrase:match("^(.-) of ")
    if not before then
        local plain = phrase:gsub("{%a:", ""):gsub("[{}]", "")
        local last = plain:match("([%a']+)%s*$")

        return last ~= nil and PLURAL_NAMES[last] == true and plain:find("^[Tt]he ") ~= nil
    end
    local head = before:match("([%a%-']+)$")
    return head ~= nil and head:find("[^s]s$") ~= nil
end
local function Hour(t) return tonumber(date and t and date("%H", t) or 12) or 12 end
local function PartOf(hour)
    return (hour >= 22 or hour < 5) and "night" or hour >= 17 and "evening" or hour >= 12 and "afternoon" or "morning"
end
local function Cap(text)
    local head, rest = text:match("^({[pqn]:)(.*)$")
    if head then return head .. rest:gsub("^%l", string.upper) end
    return (text:gsub("^%l", string.upper))
end
local function Article(word)
    return (word:match("^[aeiouAEIOU]") and "an " or "a ") .. word
end
-- Play after midnight, before five in the morning, belongs to the evening before
-- ("On Thursday night", under Thursday's date), as a player thinks of it.
local function Evening(t)
    local h = tonumber(date and t and date("%H", t) or 12) or 12
    if t and h < 5 then return t - 5 * 3600 end
    return t
end
local DAY = 86400
local function DayNumber(t)
    -- Local calendar days (a day's scenes may run past midnight).
    local d = date and date("*t", Evening(t or 0))
    if type(d) ~= "table" then return math.floor((t or 0) / DAY) end
    -- (the game has no os library: time() is os.time)
    local stamp = (os and os.time or time)({year = d.year, month = d.month, day = d.day, hour = 12})
    return math.floor(stamp / DAY)
end

-- The phrasebook ---------------------------------------------------------------------
-- The lines live in JournalWords.lua (loaded after this file), by moment.
local PB = {}
T.phrases = PB

-- Context -----------------------------------------------------------------------------
local THEY = {they = "they", them = "them", their = "their", theirs = "theirs", self = "themselves", was = "were", has = "have"}
local function Pronouns(person) return A.PersonPronouns and A.PersonPronouns(person) or THEY end
local function FirstName(person) return person.display or (person.name or ""):match("^[^%-]+") or "They" end
local function ClassWord(class)
    if not class then return nil end
    local names = LOCALIZED_CLASS_NAMES_MALE
    local word = names and names[class] or (class:sub(1, 1) .. class:sub(2):lower())
    return word:lower()
end
local STAGES = {{10, "fledgling"}, {20, "young"}, {30, "blooded"}, {40, "seasoned"}, {50, "veteran"}, {60, "hero"}}
local STAGE_WORDS = {fledgling = "fledgling", young = "young adventurer", blooded = "blooded adventurer", seasoned = "seasoned adventurer",
    veteran = "veteran", hero = "hero", legend = "legend"}
local function Stage(level)
    level = tonumber(level)
    if not level then return nil end
    for _, stage in ipairs(STAGES) do if level < stage[1] then return stage[2] end end
    return "legend"
end
local function Danger(level, lo, hi)
    if not level or not lo then return "fair" end
    if level >= hi + 10 then return "revisit" end
    if level > hi + 2 then return "easy" end
    if level >= lo - 1 then return "fair" end
    if level >= lo - 5 then return "daring" end
    return "reckless"
end
-- How often you meet: the median of your recent gaps.
local function Cadence(gaps)
    if #gaps == 0 then return nil end
    local recent = {}
    for i = math.max(1, #gaps - 7), #gaps do recent[#recent + 1] = gaps[i] end
    table.sort(recent)
    local median = recent[math.floor((#recent + 1) / 2)]
    if median <= 1.5 then return "daily", median end
    if median <= 3.5 then return "often", median end
    if median <= 9 then return "weekly", median end
    if median <= 18 then return "fortnightly", median end
    if median <= 45 then return "monthly", median end
    return "rare", median
end
local USUAL = {daily = "almost every day", often = "several times a week", weekly = "every week",
    fortnightly = "every couple of weeks", monthly = "about once a month", rare = "now and then"}

-- The teller ---------------------------------------------------------------------------
local BONDS = {
    spouse = {they = "spouse", he = "husband", she = "wife"},
    partner = {they = "partner", he = "partner", she = "partner"},
    -- (lane C9 round 10: "friend", not "oldest friend": a first meeting cannot call him oldest)
    friend = {they = "friend", he = "friend", she = "friend"},
    family = {they = "sibling", he = "brother", she = "sister"},
}
-- Lines a reader remembers (PB.oncePerBook): once in a book.
local onceSet
local function Once()
    if not onceSet then
        onceSet = {}
        local phrases = A.JournalTale and A.JournalTale.phrases
        for _, template in ipairs(phrases and phrases.oncePerBook or {}) do onceSet[template] = true end
    end
    return onceSet
end
-- Coasts that face east (the sea is behind you at sunset).
local EAST_COASTS = {["Ratchet"] = true, ["Sen'jin Village"] = true, ["Echo Isles"] = true, ["Jaguero Isle"] = true, ["The Merchant Coast"] = true}
-- Lines that are a joke: each one once in a book.
local JOKES = {"short way down", "takes some doing", "hot as it looked", "better ways to go", "better deaths", "if the first one counts", "less said about that", "Of all things", "best of us", "graceful", "no one to blame"}
local function Teller(person, voice, player)
    local we = voice == "we"
    local pro = Pronouns(person)
    local bond = BONDS[person.bond or ""]
    local bondWord = bond and ((we and "my " or "your ") .. (bond[person.pronouns or "they"] or bond.they)) or nil
    local name = "{n:" .. Clean(FirstName(person)) .. "}"
    local persona = A.JournalTellers and A.JournalTellers.For(player) or {}
    local teller = {person = person, recent = {}, jokes = {}, onceUsed = {}, day = 0, player = player or {}, named = false, persona = persona}
    teller.base = {
        name = name,
        they = pro.they, them = pro.them, their = pro.their, theirs = pro.theirs, self = pro.self, was = pro.was, has = pro.has,
        They = Cap(pro.they), Their = Cap(pro.their),
        we = we and "we" or "you", us = we and "us" or "you", our = we and "our" or "your",
        I = we and "I" or "you", me = we and "me" or "you", my = we and "my" or "your", Iwas = we and "I was" or "you were",
        bondWord = bondWord, Bond = bondWord and Cap(bondWord), Name = name, yours = we and "mine" or "yours",
        friend = bondWord or "an old friend", possessive = pro.theirs,
        pairNamed = we and (name .. " and I") or ("you and " .. name),
    }
    function teller:Pair(rng)
        if self.crowd then return self.base.we end
        local named = we and (name .. " and I") or ("you and " .. name)
        -- Every third time "you both" ("took you both"), without drawing on the rng; the diary
        -- keeps "the two of us" ("took we both" is wrong).
        local function Both()
            if self.crowd then return named end
            if we then return "the two of us" end
            -- not "you both ... together", nor "you both were" ("you were both" is how it is said)
            local line = self.sayLine or ""
            if line:find("together", 1, true) or line:find("{pair} were ", 1, true) or line:find("{pair} had ", 1, true)
                or line:find("{pair} would ", 1, true) then
                return "the two of you"
            end
            self.bothN = (self.bothN or 0) + 1
            return self.bothN % 3 == 2 and "you both" or "the two of you"
        end
        -- yesterday's companion, unnamed today: "the two of you" first, then "you".
        if not self.named and self.implicit then
            if not self.bothSaid and not self.youSaid then
                -- (a one-sentence chapter needs "the two of you"; a line that says "together" does not)
                local together = (self.sayLine or ""):find("together", 1, true)
                if self.sayKey == "dayShort" or (not together and rng() < 0.5) then
                    self.bothSaid = true; self.lastPair = Both(); return self.lastPair
                end
                self.youSaid = true
            end
            self.lastPair = self.base.we
            return self.base.we
        end
        if not self.named and not self.implicit then self.lastPair = named; return named end
        -- Once named, mostly "the two of you", never the same pairing twice running.
        -- after the name, mostly "you"/"we"; "the two of you" at most once.
        local roll = rng()
        local pair = self.base.we
        if roll < 0.12 and self.lastPair ~= named then pair = named
        elseif roll < 0.35 and not self.bothSaid then pair = Both(); self.bothSaid = true end
        self.lastPair = pair
        return pair
    end
    -- The freshest line of a list: one not used in the last days if possible.
    -- Returns the line and whether it was fresh.
    -- avoid(line) -> hard, soft: a hard line is taken only if nothing else is
    -- left (a token that must not be said, "you" in the diary); a soft one only
    -- if every other rested line is soft too (the same opening word as the
    -- sentence before).
    function teller:Pick(key, list, rng, peek, window, avoid)
        window = window or math.max(5, math.min(#list - 1, 40))
        -- Lines never said come first (in a random order), then a random one
        -- among the longest rested; the oldest if all were said lately.
        local never, rested, neverSoft, restedSoft, best, bestAge = {}, {}, {}, {}, nil, nil
        for i = 1, #list do
            local used = self.recent[key .. i]
            local age = used and (self.day - used) or 1000
            -- "road" at most once a chapter (evocative, not every time).
            if (self.roads or 0) >= 1 and list[i]:find("road") then age = -1 end
            local hard, soft = false, false
            if avoid then hard, soft = avoid(list[i]) end
            if hard then age = -2 end
            if age == 1000 then table.insert(soft and neverSoft or never, i)
            elseif age > window then table.insert(soft and restedSoft or rested, {i, age}) end
            if not bestAge or age > bestAge then best, bestAge = i, age end
        end
        local function Rested(pool)
            table.sort(pool, function(a, b) if a[2] ~= b[2] then return a[2] > b[2] end return a[1] < b[1] end)
            return pool[rng(math.max(1, math.ceil(#pool / 2)))][1]
        end
        local choice
        if #never > 0 then choice = never[rng(#never)]
        elseif #rested > 0 then choice = Rested(rested)
        elseif #neverSoft > 0 then choice = neverSoft[rng(#neverSoft)]
        elseif #restedSoft > 0 then choice = Rested(restedSoft) end
        if peek and not choice then return nil end
        choice = choice or best
        self.recent[key .. choice] = self.day
        return list[choice], choice ~= nil
    end
    -- The first word a line would say ("you", "kael", "the"...).
    local function Plain(text) return (text:gsub("{%a:", ""):gsub("[{}]", "")) end
    function teller:First(line, tokens)
        local token = line:match("^{(%a+)}")
        local word
        if token == "pair" then
            word = (self.implicit and not self.named and not self.bothSaid and not self.youSaid) and "the"
                or ((self.named or not we) and self.base.we or Plain(name))
        elseif token then
            local value = tokens and tokens[token]
            if value == nil then value = self.base[token] end
            word = type(value) == "string" and Plain(value):match("^([%a']+)") or nil
        else
            word = Plain(line):match("^([%a']+)")
        end
        return word and word:lower()
    end
    -- the first two words a line would write ("you and", "the two", "that evening").
    function teller:FirstTwo(line, tokens)
        local text = line:gsub("{(%a+)}", function(token)
            if token == "pair" then
                if self.implicit and not self.named and not self.bothSaid then return we and "the two of us" or "the two of you" end
                return (self.named) and self.base.we or (we and (Plain(name) .. " and I") or ("you and " .. Plain(name)))
            end
            local value = tokens and tokens[token]
            if value == nil then value = self.base[token] end
            return type(value) == "string" and Plain(value) or ""
        end)
        local two = text:match("^%s*(%S+%s+%S+)")
        return two and two:lower():gsub("[,.]", "")
    end
    function teller:Say(key, list, rng, tokens)
        if not list or #list == 0 then return nil end
        self.sayKey = key
        -- The two voices have lines of their own for many moments (PB.voice.we: the
        -- diary one of the two keeps, "Mira and I", "between us", our firsts;
        -- PB.voice.you: a game master's recap, "your party", "the pair of you").
        -- They sit behind the common lines and are preferred every other time
        -- (a counter, not a draw: the stream stays where it was).
        local voicedSet, voicedAll
        do
            local own = PB.voice and PB.voice[we and "we" or "you"]
            local extra = own and own[key]
            if type(extra) == "table" and #extra > 0 then
                self.merged = self.merged or {}
                local m = self.merged[key]
                if not m or m.base ~= list then
                    m = {base = list, list = {}, set = {}}
                    for _, line in ipairs(list) do m.list[#m.list + 1] = line end
                    for _, line in ipairs(extra) do m.list[#m.list + 1] = line; m.set[line] = true end
                    self.merged[key] = m
                end
                list = m.list
                voicedAll = m.set
                self.voiceN = (self.voiceN or 0) + 1
                if self.voiceN % 2 == 1 then voicedSet = m.set end
            end
        end
        -- Tokens set to false must not be said here (an epithet already given,
        -- lore on a return visit); the diary never says "you"; and a sentence
        -- does not open with the word the one before it opened with.
        local banned = {}
        for token, value in pairs(tokens or {}) do if value == false then banned[token] = true end end
        local lastFirst = self.lastFirst
        local function Avoid(line)
            local hard = false
            for token in line:gmatch("{(%a+)}") do if banned[token] then hard = true end end
            if we and line:find("%f[%a][Yy]ou%f[%A]") then hard = true end
            -- "Hear how it began" speaks to a listener: not in a diary.
            if we and line:find("^Hear ") then hard = true end
            -- a joke, or a line a reader remembers, is told once in a book
            for _, joke in ipairs(JOKES) do if self.jokes[joke] and line:find(joke, 1, true) then hard = true end end
            if self.onceUsed[line] then hard = true end
            -- "as usual" is not true in the first days together.
            if self.fewDays and (line:find("as usual", 1, true) or line:find("most days", 1, true) or line:find("so often", 1, true)) then hard = true end
            -- some lines only open a chapter.
            if self.started and (line:find("^First ") or line:find("^And so ") or line:find("^On {[Ww]eekday}")
                or line:find("^The {part} began") or line:find("^Hear how") or line:find("^So it was")
                or line:find("started the {part}", 1, true)) then hard = true end
            local first = self:First(line, tokens)
            local soft = (lastFirst ~= nil and first == lastFirst) or (self.avoidAlso ~= nil and first == self.avoidAlso)
            -- (this time the voice's own lines come first; the common ones wait)
            if voicedSet and not voicedSet[line] then soft = true end
            -- (a voice's own line names the companion only before the chapter has; "the two of us",
            -- "the pair of you" and "your party" once a chapter: after that, the common lines)
            if voicedAll and voicedAll[line] then
                if self.named and (line:find("{name}", 1, true) or line:find("{pairNamed}", 1, true)) then hard = true end
                if self.twoSaid and (line:lower():find("the two of ", 1, true) or line:lower():find("the pair of ", 1, true)) then hard = true end
                if self.partySaid and line:find("{my} party", 1, true) then hard = true end
            end
            -- (three or more in the party: no line that says "the pair of you" or "the two of us" outright;
            -- "The pair of {us} made level 17" opened a sentence with a capital and slipped past, 2026-11-11)
            if self.crowd and (line:lower():find("the two of ", 1, true) or line:lower():find("the pair of ", 1, true)) then hard = true end
            -- the chapter's first sentence does not open like either of the last two chapters.
            if not self.started and self.openTwo then
                local two = self:FirstTwo(line, tokens)
                for _, prev in ipairs(self.openTwo) do if two and prev == two then soft = true end end
            end
            return hard, soft
        end
        -- This character's storyteller has lines of its own for many moments.
        local own = persona[key]
        local text
        local strong = A.JournalTellers and A.JournalTellers.strong and A.JournalTellers.strong[key]
        local chance = strong and (persona.strong or 0.6) or (persona.mix or 0)
        -- A storyteller flavours the tale; it does not take it over.
        if (self.ownCount or 0) >= 1 then chance = 0 end
        if self.lastOwn and self.day - self.lastOwn <= 1 then chance = chance * 0.5 end
        self.ownLine = false
        if type(own) == "table" and #own > 0 and rng() < chance then
            -- Its own lines, unless all of them were said lately.
            text = self:Pick(key .. "@", own, rng, true, math.max(14, #own - 1), Avoid)
            self.ownLine = text ~= nil
            if text then self.ownCount, self.lastOwn = (self.ownCount or 0) + 1, self.day end
        end
        if not text then text = self:Pick(key, list, rng, nil, nil, Avoid) end
        -- (a template said word for word earlier in the book gives way to another while the pool has
        -- one; the tokens are the same in most chapters, so the template is the shape: 2026-11-06)
        self.saidTemplates = self.saidTemplates or {}
        if text and self.saidTemplates[key .. "|" .. text] and #list > 1 and not self.ownLine then
            for _ = 1, math.min(4, #list) do
                local other = self:Pick(key, list, rng, nil, nil, Avoid)
                if other and not self.saidTemplates[key .. "|" .. other] then text = other; break end
            end
        end
        if text then self.saidTemplates[key .. "|" .. text] = true end
        for _, joke in ipairs(JOKES) do if text and text:find(joke, 1, true) then self.jokes[joke] = true end end
        if text and Once()[text] then self.onceUsed[text] = true end
        self.sayLine = text
        if tokens and text:find("{part}", 1, true) and tokens.part then tokens.partUsed = tokens.part end
        if tokens and text:find("{[Ww]eekday}") and tokens.weekday then tokens.weekdayUsed = true end
        text = text:gsub("%[([^%]]+)%]", function(choices)
            local options = {}
            for choice in (choices .. "|"):gmatch("([^|]*)|") do options[#options + 1] = choice end
            return options[rng(#options)]
        end)
        local base = self.base
        text = text:gsub("{(%a+)}", function(token)
            if token == "pair" then return self:Pair(rng) end
            -- the pair after a verb: "kept Kael and me busy", "took us"
            if token == "pairObj" then
                local pair = self:Pair(rng)
                return (pair:gsub(" and I$", " and me"):gsub("^we$", "us"):gsub("^We$", "Us"))
            end
            if token == "pairFull" then
                local named = we and (name .. " and I") or ("you and " .. name)
                local full = (self.lastPair ~= named) and named or (we and "the two of us" or "the two of you")
                self.lastPair = full
                return full
            end
            local value = tokens and tokens[token]
            if value == nil then value = base[token] end
            if value == false then return "" end
            if value == nil then return "{" .. token .. "}" end
            return tostring(value)
        end)
        -- A token left out (nothing else fitted): no stray commas. A title that
        -- ends on "!" or "?" ends the sentence too ("Hungry!", not "Hungry!.").
        text = text:gsub(",%s*,", ","):gsub(",%s*%.", "."):gsub(" +", " "):gsub(" ,", ",")
        text = text:gsub("([!?]})%.", "%1"):gsub("([!?])%.", "%1")
        -- "you both were out" is said "you were both out".
        text = text:gsub("([Yy]ou) both (were) ", "%1 %2 both "):gsub("([Yy]ou) both (had) ", "%1 %2 both ")
        -- a place already named this chapter becomes "there".
        self.saidPlaces = self.saidPlaces or {}
        -- "was in X" becomes "was there"; otherwise the clause goes ("You made
        -- camp." not "You made camp there."). Lines keep " in {place}" at the end.
        do
            -- (a sentence that opens "In X, " once X was named this chapter drops the opening)
            text = text:gsub("^In {p:([^}]+)}, ", function(place)
                local k = place:gsub("^[Tt]he ", ""):match("^(%S+)")
                if self.saidPlaces[k] then return "" end
            end)
            text = text:gsub(" around {p:([^}]+)}", function(place)
                local k = place:gsub("^[Tt]he ", ""):match("^(%S+)")
                if self.saidPlaces[k] then return "" end
            end)
            text = text:gsub("(%a*) in {p:([^}]+)}", function(before, place)
                local k = place:gsub("^[Tt]he ", ""):match("^(%S+)")
                if not self.saidPlaces[k] then return nil end
                if before == "was" or before == "were" then return before .. " there" end
                -- ("set foot in X", "the first time in X" keep their place as "there": without it
                -- the sentence lost its point, "You had never set foot before that day", 2026-11-06)
                if before == "foot" or before == "time" or before == "stood" or before == "day" or before == "been" then return before .. " there" end
                return before
            end)
        end
        text = text:gsub(",,", ","):gsub(" ,", ","):gsub(",%s*%.", "."):gsub(" +%.$", ".")
        -- places are marked as said when the line is written (Add).
        -- (a sentence start is capitalized; a title's own "... and Bugs" is not)
        local spans = {}
        text = Cap(text):gsub("{[pqn]:[^}]*}", function(span) spans[#spans + 1] = span; return "\1" .. #spans .. "\2" end)
        text = text:gsub("([%.!%?]%s+)(%l)", function(stop, letter) return stop .. letter:upper() end)
        text = text:gsub("\1(%d+)\2", function(i) return spans[tonumber(i)] end)
        local lastSentence = text:match("([^%.!%?]+[%.!%?]?)%s*$") or text
        self.lastFirst = Plain(text):match("^([%a']+)")
        self.lastFirst = self.lastFirst and self.lastFirst:lower()
        if lastSentence ~= text then self.lastFirst = self.lastFirst end
        -- the bans wait until the line is written (Add); a dropped line bans nothing.
        self.pendingTokens = tokens
        for _ in text:gmatch("road") do self.roads = (self.roads or 0) + 1 end
        return text
    end
    return teller
end

-- The companion's day as zone stretches, the shape A.JournalEpisodes.DungeonRuns reads (the
-- own book's scenes): one scene per zone stay, the companion's own deaths as "pdeath" (the
-- record keeps them as "death" w=them), hand-ins as quests, levels as events (2026-11-11).
local function Stretches(day, person)
    local out = {}
    local who = person and (Clean(person.name or ""):gsub("%-.*$", "")) or "them"
    for _, scene in ipairs(day.scenes) do
        if scene.kind == "outing" then
            local cur
            for _, entry in ipairs(scene.entries or {}) do
                local z = entry.z or scene.zone
                if not cur or cur.zone ~= z then
                    if cur then cur.e = entry.t or cur.e end
                    cur = {kind = "outing", zone = z, t = entry.t or scene.t, e = scene.e or scene.t, entries = {}, events = {},
                        quests = {}, questCount = 0, bosses = {}, with = {}}
                    out[#out + 1] = cur
                end
                cur.entries[#cur.entries + 1] = entry
                local k = entry.k
                if k == "boss" and entry.d then
                    cur.events[#cur.events + 1] = {k = "boss", t = entry.t, d = entry.d, n = entry.n, me = entry.me, them = entry.them}
                    cur.bosses[#cur.bosses + 1] = {name = entry.d, where = entry.z}
                elseif k == "dungeon" then
                    cur.events[#cur.events + 1] = {k = "dungeon", t = entry.t, d = entry.d or entry.z, r = entry.r, tr = entry.tr}
                elseif k == "death" and entry.w == "you" then
                    cur.events[#cur.events + 1] = {k = "death", t = entry.t, d = entry.d, boss = entry.boss, sz = entry.sz, entry = entry}
                elseif k == "death" then
                    cur.events[#cur.events + 1] = {k = "pdeath", t = entry.t, n = who, boss = entry.boss, entry = entry}
                elseif k == "quest" and entry.d then
                    cur.quests[#cur.quests + 1] = {title = entry.d, qid = entry.qid, t = entry.t, count = 1}
                    cur.questCount = cur.questCount + 1
                elseif k ~= "play" and k ~= "group" then
                    cur.events[#cur.events + 1] = {k = k, t = entry.t, d = entry.d, w = entry.w, by = entry.by, n = entry.n}
                end
            end
        end
    end
    return out
end
-- The runs of the day onto the facts: each attempt's entry, the ghost-run deaths into the
-- run's events, the wipe (your death that ended an attempt, theirs with it, whether the
-- party went back down), the hand-ins about the dungeon and the level that came with it.
local function RunUnits(f, day, person)
    local E = A.JournalEpisodes
    if not (E and E.DungeonRuns) then return false end
    local ok, runs = pcall(E.DungeonRuns, Stretches(day, person))
    if not ok or type(runs) ~= "table" then return false end
    -- (a long ghost run splits one visit into two runs of the same dungeon: this book keeps one
    -- unit per dungeon a day, so later runs of it are further attempts of the first)
    local merged, byName = {}, {}
    for _, run in ipairs(runs) do
        local first = byName[run.dungeon]
        if first then
            for _, at in ipairs(run.attempts or {}) do first.attempts[#first.attempts + 1] = at end
            for _, x in ipairs(run.deaths or {}) do first.deaths[#first.deaths + 1] = x end
            for _, x in ipairs(run.quests or {}) do first.quests[#first.quests + 1] = x end
            first.level = first.level or run.level
            first.left = math.max(first.left or 0, run.left or 0)
        else
            local copy = {dungeon = run.dungeon, entered = run.entered, left = run.left, level = run.level, attempts = {}, deaths = {}, quests = {}, run = run}
            for _, at in ipairs(run.attempts or {}) do copy.attempts[#copy.attempts + 1] = at end
            for _, x in ipairs(run.deaths or {}) do copy.deaths[#copy.deaths + 1] = x end
            for _, x in ipairs(run.quests or {}) do copy.quests[#copy.quests + 1] = x end
            byName[run.dungeon] = copy
            merged[#merged + 1] = copy
        end
    end
    for _, run in ipairs(merged) do
        local d = f.byDungeon[run.dungeon]
        if d then
            d.run = run.run
            d.entries = {}
            for _, at in ipairs(run.attempts or {}) do d.entries[#d.entries + 1] = at.entered end
            for _, death in ipairs(run.deaths or {}) do
                local raw = death.event and death.event.entry
                if raw then
                    for n = #f.deaths, 1, -1 do
                        if f.deaths[n] == raw then
                            table.remove(f.deaths, n)
                            d.events[#d.events + 1] = {k = "death", t = raw.t or 0, e = raw, ghost = true}
                        end
                    end
                end
            end
            -- (the run ended on the wipe and nobody walked back in: their death on the ghost run out,
            -- within five minutes of yours, is still the wipe's)
            for n = #f.deaths, 1, -1 do
                local e = f.deaths[n]
                for _, ev in ipairs(d.events) do
                    if ev.k == "death" and ev.e and ev.e.w == "you" and e.w ~= "you" and (e.t or 0) >= (ev.t or 0) and (e.t or 0) - (ev.t or 0) <= 5 * 60 then
                        table.remove(f.deaths, n)
                        d.events[#d.events + 1] = {k = "death", t = e.t or 0, e = e, ghost = true}
                        break
                    end
                end
            end
            table.sort(d.events, function(a, b) return a.t < b.t end)
            -- (the companion's record keeps no second "dungeon" entry for the walk back in: your
            -- death with theirs in the five minutes after it, then bosses killed on, is the wipe and
            -- the retry; a death that ended the attempt is the wipe, the next attempt the retry)
            for a, at in ipairs(run.attempts or {}) do
                local nextAttempt = run.attempts[a + 1] ~= nil
                for _, ev in ipairs(d.events) do
                    if ev.k == "death" and ev.e and ev.e.w == "you" and (ev.t or 0) >= at.entered and (ev.t or 0) < at.left and not ev.wipe and not ev.wipeOf then
                        -- (theirs on the ghost run out may be stamped at the attempt's end or just after it;
                        -- "went back down" only on evidence: a second entry, or their death logged outside
                        -- the dungeon, the ghost run out, before bosses fell)
                        local them, bossesAfter, ranOut = 0, false, false
                        for _, x in ipairs(d.events) do
                            if x.k == "death" and x.e and x.e.w ~= "you" and (x.t or 0) >= (ev.t or 0) and (x.t or 0) - (ev.t or 0) <= 5 * 60
                                and (x.t or 0) <= at.left + 5 * 60 and not x.wipeOf then
                                them = them + 1
                                if x.e.z and x.e.z ~= run.dungeon then ranOut = true end
                            end
                            if x.k == "boss" and (x.t or 0) > (ev.t or 0) and (x.t or 0) < at.left then bossesAfter = true end
                        end
                        if them > 0 or not bossesAfter then
                            ev.wipe = {them = them, retry = nextAttempt or (bossesAfter and ranOut)}
                            for _, x in ipairs(d.events) do
                                if x.k == "death" and x.e and x.e.w ~= "you" and (x.t or 0) >= (ev.t or 0) and (x.t or 0) - (ev.t or 0) <= 5 * 60
                                    and (x.t or 0) <= at.left + 5 * 60 and not x.wipeOf then x.wipeOf = ev end
                            end
                        end
                    end
                end
            end
            d.runQuests = {}
            for _, q in ipairs(run.quests or {}) do if q.quest then d.runQuests[q.quest.qid or q.quest.title] = true end end
            d.runLevel = run.level
            -- (the lord of the place as the goal: a hand-in of the day about the run names it)
            local lordList = A.DungeonLast and A.DungeonLast(run.dungeon)
            local lord = lordList and lordList[1]
            if lord and E.QuestText and E.Names then
                for _, q in ipairs(run.quests or {}) do
                    if q.quest and E.Names(E.QuestText(q.quest), lord) then d.goal = lord end
                end
            end
        end
    end
    return true
end
-- One day's facts.
local function DayFacts(day, person)
    local f = {zones = {}, zoneTime = {}, together = 0, outings = 0, quests = {}, dungeons = {}, byDungeon = {},
        deaths = {}, wipes = {}, rez = 0, rezT = {}, levels = {}, fires = {}, rests = {}, seen = nil, met = nil, added = false,
        plStart = nil, plEnd = nil, ol = nil, quotes = {}}
    for _, scene in ipairs(day.scenes) do
        if scene.kind == "outing" then
            f.outings = f.outings + 1
            f.together = f.together + (scene.e - scene.t)
            if scene.zone then
                if not f.zoneTime[scene.zone] then f.zones[#f.zones + 1] = scene.zone end
                f.zoneTime[scene.zone] = (f.zoneTime[scene.zone] or 0) + (scene.e - scene.t)
            end
        elseif scene.kind == "met" then f.met = scene
        elseif scene.kind == "added" then f.added = true
        elseif scene.kind == "seen" then f.seen = f.seen or scene
        elseif scene.kind == "custom" and scene.text then f.quotes[#f.quotes + 1] = {text = scene.text, entries = scene.entries}
        end
        for _, entry in ipairs(scene.entries) do
            if entry.pl then
                f.plStart = f.plStart or entry.pl
                f.plEnd = math.max(f.plEnd or 0, entry.pl)
            end
            if entry.ol then f.ol = math.max(f.ol or 0, entry.ol) end
            -- (their level at the latest entry, and after a level of theirs its new level: the two
            -- levels are compared at the same moment, the end of the day; a stale higher level read
            -- at the first sighting once said "Mira was level 16, well ahead of me at 7" of two
            -- characters who levelled side by side, 2026-11-07)
            do
                local theirs = (entry.k == "level" and tonumber(entry.d)) or tonumber(entry.ol)
                if theirs and (entry.t or 0) >= (f.olT or 0) then f.olLast, f.olT = theirs, entry.t or 0 end
            end
            local k = entry.k
            local function Dungeon(name, t, pl)
                local d = f.byDungeon[name]
                if not d then
                    d = {name = name, t = t or 0, pl = pl, events = {}}
                    f.byDungeon[name] = d
                    f.dungeons[#f.dungeons + 1] = d
                end
                return d
            end
            if k == "quest" and entry.d then
                f.quests[#f.quests + 1] = {title = entry.d, qid = entry.qid, level = entry.ql, kind = entry.qt, pl = entry.pl, t = entry.t or 0, scene = scene, z = entry.z}
            elseif k == "dungeon" then
                local name = entry.d or entry.z
                if name then
                    local d = Dungeon(name, entry.t, entry.pl)
                    d.r, d.tr = d.r or entry.r, d.tr or entry.tr
                    -- (each time the party went in: a second entry after a wipe is the retry)
                    d.entries = d.entries or {}
                    d.entries[#d.entries + 1] = entry.t or 0
                end
            elseif k == "boss" and entry.d then
                local d = Dungeon(entry.z or "?", entry.t, entry.pl)
                d.events[#d.events + 1] = {k = "boss", t = entry.t or 0, d = entry.d, cost = entry.cost, me = entry.me, them = entry.them, n = entry.n}
            elseif k == "death" then
                local d = entry.z and f.byDungeon[entry.z]
                if d then d.events[#d.events + 1] = {k = "death", t = entry.t or 0, e = entry}
                else f.deaths[#f.deaths + 1] = entry end
            elseif k == "wipe" then
                local d = entry.z and f.byDungeon[entry.z]
                if d then d.events[#d.events + 1] = {k = "wipe", t = entry.t or 0, d = entry.d}
                else f.wipes[#f.wipes + 1] = entry end
            elseif k == "rez" then
                -- (w = "you": you brought them back; otherwise they brought you back)
                if entry.w == "you" then
                    f.rezGiven = (f.rezGiven or 0) + 1
                    if entry.t then f.rezGivenT = f.rezGivenT or {}; f.rezGivenT[#f.rezGivenT + 1] = entry.t end
                else f.rez = f.rez + 1; if entry.t then f.rezT[#f.rezT + 1] = entry.t end end
            elseif k == "level" then
                f.levels[#f.levels + 1] = tonumber(entry.d)
                f.levelT, f.levelZ = entry.t, entry.z
            elseif k == "mylevel" then
                if (tonumber(entry.d) or 0) >= (f.myLevel or 0) then f.myLevelT, f.myLevelZ = entry.t, entry.z end
                f.myLevel = math.max(f.myLevel or 0, tonumber(entry.d) or 0)
            elseif k == "campfire" then
                f.fires[#f.fires + 1] = entry.z
                f.restT = f.restT or entry.t
                f.fireT = f.fireT or entry.t
                f.restZ = f.restZ or entry.z
            elseif k == "rest" then
                f.rests[#f.rests + 1] = entry.d or entry.z
                f.restT = f.restT or entry.t
                f.restZ = f.restZ or entry.z
            end
        end
        if scene.kind == "level" and #scene.entries == 0 then
            for _, level in ipairs(scene.levels) do f.levels[#f.levels + 1] = tonumber(level) end
        end
        if scene.kind == "campfire" and #scene.entries == 0 then f.fires[#f.fires + 1] = scene.zone end
    end
    for _, d in ipairs(f.dungeons) do table.sort(d.events, function(a, b) return a.t < b.t end) end
    -- The run as one unit (2026-11-11): JournalEpisodes.DungeonRuns (RunUnits above) gives the
    -- attempts, the ghost-run deaths, the wipes, the hand-ins about it and its level. Without
    -- the module, the same facts are found here: a death recorded outside the dungeon while
    -- the run was on belongs to it (the companion's death is logged on the ghost run, in the
    -- zone above), and a death of yours followed within five minutes by theirs is a wipe.
    local fromEpisodes = RunUnits(f, day, person)
    for _, d in ipairs(f.dungeons) do
        if #d.events > 0 and not fromEpisodes then
            local lastT = d.t or 0
            for _, ev in ipairs(d.events) do lastT = math.max(lastT, ev.t or 0) end
            for _, t in ipairs(d.entries or {}) do lastT = math.max(lastT, t) end
            local n = 1
            while n <= #f.deaths do
                local e = f.deaths[n]
                local t = e.t or 0
                local inRun = false
                if t >= (d.t or 0) and t <= lastT then
                    -- (between two events of the run, each within a quarter of an hour)
                    local before, after = d.t or 0, lastT
                    for _, ev in ipairs(d.events) do
                        if (ev.t or 0) <= t then before = math.max(before, ev.t or 0) end
                        if (ev.t or 0) >= t then after = math.min(after, ev.t or 0) end
                    end
                    for _, et in ipairs(d.entries or {}) do
                        if et <= t then before = math.max(before, et) end
                        if et >= t then after = math.min(after, et) end
                    end
                    inRun = (t - before) <= 15 * 60 and (after - t) <= 15 * 60
                end
                for _, ev in ipairs(d.events) do
                    if ev.k == "death" and ev.e and ev.e.w == "you" and t >= (ev.t or 0) and t - (ev.t or 0) <= 5 * 60 then inRun = true end
                end
                if inRun then
                    d.events[#d.events + 1] = {k = "death", t = t, e = e, ghost = true}
                    table.remove(f.deaths, n)
                else n = n + 1 end
            end
            table.sort(d.events, function(a, b) return a.t < b.t end)
            for i, ev in ipairs(d.events) do
                if ev.k == "death" and ev.e and ev.e.w == "you" and not ev.wipeOf then
                    local them, retry = 0, false
                    for j = i + 1, #d.events do
                        local x = d.events[j]
                        if x.k == "death" and x.e and x.e.w ~= "you" and (x.t or 0) - (ev.t or 0) <= 5 * 60 and not x.wipeOf then
                            them = them + 1
                            x.wipeOf = ev
                        end
                        if x.k == "boss" then retry = true end
                    end
                    for _, et in ipairs(d.entries or {}) do if et > (ev.t or 0) then retry = true end end
                    if them > 0 or retry then ev.wipe = {them = them, retry = retry} end
                end
            end
        end
    end
    -- A dungeon with nothing in it, left at once: the next thing recorded was
    -- outside it within five minutes (d.outAfter, in seconds).
    for _, d in ipairs(f.dungeons) do
        if #d.events == 0 then
            local nextT
            for _, scene in ipairs(day.scenes) do
                for _, entry in ipairs(scene.entries) do
                    local t = entry.t or 0
                    if t > d.t and entry.z and entry.z ~= d.name and (not nextT or t < nextT) then nextT = t end
                end
            end
            if nextT and nextT - d.t <= 300 then d.outAfter = nextT - d.t end
        end
    end
    return f
end
local function Together(f) return f.outings > 0 or #f.fires > 0 or #f.rests > 0 end

-- A line that opens on its own place ("At Aerie Peak, ...", "Back at the
-- Sepulcher, ...", "Inside the keep, ..."): no second place goes in front of it.
local PLACE_LEADS = {At = true, In = true, On = true, Back = true, Inside = true, Outside = true, Beneath = true, Beyond = true, Near = true,
    Along = true, Across = true, Within = true, Under = true, Over = true, From = true, Up = true, Down = true, Out = true, Deep = true,
    Far = true, Below = true, Above = true, Aboard = true, Among = true, Atop = true}
function T.PlaceLed(text)
    local word = type(text) == "string" and text:match("^(%a+) ")
    return word ~= nil and PLACE_LEADS[word] == true
end

-- A chapter has scenes, not one unbroken roll of sentences. Keep a fight and
-- its immediate rescue together; give the setting and aftermath their own
-- space when there is enough prose to warrant it. This changes no ordering.
-- (groups: line index -> a key; lines of one key are one paragraph, never cut, never
-- joined with their neighbours: a dungeon run, 2026-11-11)
function T.Paragraphs(lines, beats, groups)
    local paragraphs, current, words, previous = {}, {}, 0, nil
    local function Phase(beat)
        if beat == "prologue" then return "prologue" end
        if beat == "dungeon" or beat == "kills" or beat == "climax" or beat == "roles" or beat == "death" or beat == "rez" or beat == "deathLore" then return "conflict" end
        if beat == "rest" or beat == "milestone" or beat == "close" or beat == "consequence" then return "aftermath" end
        return "setting"
    end
    local phases, groupOf = {}, {}
    local function Flush(short)
        if #current > 0 then
            -- (a few words before a group, "You sat by a fire a while.", join the paragraph before them
            -- rather than standing alone, 2026-11-11 round 2)
            if short and #paragraphs > 0 and not groupOf[#paragraphs] and phases[#paragraphs] ~= "prologue" then
                paragraphs[#paragraphs] = paragraphs[#paragraphs] .. " " .. table.concat(current, " ")
            else
                paragraphs[#paragraphs + 1] = table.concat(current, " "); phases[#paragraphs] = previous
            end
        end
        current, words = {}, 0
    end
    for i, line in ipairs(lines) do
        local phase = Phase(beats[i])
        local linked = beats[i] == "questOutcome"
            or ((beats[i] == "rez" or beats[i] == "deathLore" or beats[i] == "consequence") and previous == "conflict")
        local group, previousGroup = groups and groups[i], groups and groups[i - 1]
        if #current > 0 and group ~= previousGroup then
            if previousGroup ~= nil then groupOf[#paragraphs + 1] = true end
            Flush(group ~= nil and previousGroup == nil and words < 25)
        elseif group ~= nil and group == previousGroup then -- (one paragraph, whatever its length)
        elseif #current > 0 and not linked and ((phase ~= previous and (words >= 34 or previous == "prologue"))
            or beats[i] == "questTurn" or (beats[i] == "questStart" and words >= 45) or words >= 95) then Flush() end
        current[#current + 1] = line
        for _ in line:gsub("{%a:", ""):gmatch("%S+") do words = words + 1 end
        previous = phase
    end
    Flush()
    -- (a last paragraph of one short sentence, "You reached level 32.", joins the one before it;
    -- never the backstory of a prologue)
    if #paragraphs >= 2 and phases[#paragraphs - 1] ~= "prologue" and not groupOf[#paragraphs - 1] then
        local last = paragraphs[#paragraphs]
        local n = 0
        for _ in last:gsub("{%a:", ""):gmatch("%S+") do n = n + 1 end
        local sentences = select(2, last:gsub("[%.!%?]%s", "")) + 1
        if n <= 9 and sentences <= 1 then
            paragraphs[#paragraphs - 1] = paragraphs[#paragraphs - 1] .. " " .. last
            paragraphs[#paragraphs] = nil
        end
    end
    return table.concat(paragraphs, "\n\n")
end
-- The planned telling (2026-11-09, story planner steps 2-4; Settings > Testing > Storyteller:
-- Planned). The same facts as the current storyteller, told in the order they happened and cut
-- into movements: the death opens its own; a change of place or a gap of three quarters of an
-- hour (twenty minutes once a death's aftermath is told) opens the next. Each later movement
-- opens on the hour or the place, never on a quest's setup. After a death, what the record says
-- came next (a level within minutes). A thread's payoff gets its setup at the earlier beat's time,
-- from the stage's own lines. A figure's lore sentence is folded or dropped once the figure was
-- named. No event is added and no told fact dropped.
-- PROPOSAL: StorageInvestigation/cj-story-breakthrough-20261109.
local PLAN_OPEN = {open = true, day = true, prologue = true, recap = true, greeting = true}
-- (connectives that tied a line to the one before it in the old order; wrong once it moves)
local PLAN_LEADS = {"Then, ", "Then ", "After that, ", "Later that day, ", "Later, ", "Before long, ", "Also, "}
local PLAN_GAP, PLAN_GAP_AFTER_DEATH, PLAN_AFTERMATH, PLAN_NEXT = 45 * 60, 20 * 60, 5 * 60, 10 * 60
local HOUR_WORDS = {"one", "two", "three", "four", "five", "six", "seven", "eight", "nine", "ten", "eleven", "twelve"}
-- (first words that take a small letter behind an anchor; a name keeps its capital)
local PLAN_SMALL = {}
for word in ("you your we our the a an it its there both two one he she they his her their my me all each nothing no some "
    .. "after before at in on with by from when while as this that these those once back every word news what"):gmatch("%a+") do PLAN_SMALL[word] = true end
-- (the other names a notable figure goes by in these books: "the Dark Lady" is Sylvanas)
local FIGURE_ALIASES = {["Lady Sylvanas Windrunner"] = {"Sylvanas", "Dark Lady", "Banshee Queen"}, ["Thrall"] = {"Thrall", "warchief", "Warchief"},
    ["Cairne Bloodhoof"] = {"Cairne", "high chieftain"}, ["Vol'jin"] = {"Vol'jin"}, ["King Magni Bronzebeard"] = {"Magni"},
    ["High Tinker Mekkatorque"] = {"Mekkatorque", "high tinker"}, ["Tyrande Whisperwind"] = {"Tyrande"}, ["Arch Druid Fandral Staghelm"] = {"Fandral", "Staghelm"}}
local PLAN_TITLES = {Lady = true, Lord = true, King = true, Queen = true, High = true, Arch = true, Druid = true, Tinker = true, Captain = true,
    Deathguard = true, Executor = true, Magistrate = true, Apothecary = true, Commander = true, General = true,
    Novice = true, Shadow = true, Priest = true, Priestess = true, Sergeant = true, Lieutenant = true, Corporal = true, Private = true,
    Major = true, Colonel = true, Admiral = true, Marshal = true, Deputy = true, Mountaineer = true, Sentinel = true, Warden = true,
    Scout = true, Grunt = true, Farmer = true, Innkeeper = true, Brother = true, Sister = true, Father = true, Elder = true, Seer = true,
    Chief = true, Chieftain = true, Overseer = true, Foreman = true, Prince = true, Princess = true, Mayor = true, Master = true,
    Mistress = true, Doctor = true, Professor = true, Archmage = true, Magus = true, Thane = true, Baron = true, Duke = true, Sir = true,
    Keeper = true, Loremaster = true, Prospector = true, Senior = true, Junior = true, Grand = true, Initiate = true, Acolyte = true,
    Bishop = true, Guard = true, Watcher = true, Dark = true, Ranger = true, Warlord = true, Overlord = true, Shaman = true, Mage = true}
local function PlanPlain(s) return (tostring(s or ""):gsub("{%a:([^}]*)}", "%1")) end
local function PlanWords(s) local c = 0 for _ in PlanPlain(s):gmatch("%S+") do c = c + 1 end return c end

-- "A little after eleven", "Past midnight", "Close to ten": the hour of t in words.
local function ClockPhrase(t)
    if type(t) ~= "number" or not date then return nil end
    local h, m = tonumber(date("%H", t)), tonumber(date("%M", t))
    if not h or not m then return nil end
    local function Word(x)
        if x % 24 == 0 then return "midnight" end
        if x % 24 == 12 then return "noon" end
        x = x % 12
        return HOUR_WORDS[x == 0 and 12 or x]
    end
    if h == 0 and m < 45 then return "Past midnight" end
    if m < 10 then return "Just after " .. Word(h) end
    if m < 30 then return "A little after " .. Word(h) end
    if m < 45 then return "Around half past " .. Word(h) end
    return "Close to " .. Word(h + 1)
end
T.ClockPhrase = ClockPhrase
T.FigureAliases = FIGURE_ALIASES

local function StripLead(text)
    for _, lead in ipairs(PLAN_LEADS) do
        if text:sub(1, #lead) == lead then return (text:sub(#lead + 1):gsub("^%l", string.upper)) end
    end
    return text
end
-- (a line rewritten keeps what is known of it: its time, place, quest, setup and hooks)
local function Rekey(S, times, zones, old, new)
    if old == new or not old or not new then return new end
    if times[new] == nil then times[new] = times[old] end
    if zones[new] == nil then zones[new] = zones[old] end
    if S then
        for _, map in ipairs({S.Q, S.Qs, S.SL, S.D, S.LV, S.setup, S.setupFor, S.ME or {}, S.peak or {}}) do
            if map and map[new] == nil then map[new] = map[old] end
        end
    end
    return new
end

-- Order: the opening stays first and the hour you stopped last; the rest by time, a line
-- without a time kept right after the line before it. A moved line loses its old connective.
-- (lines, beats in place; times and zones are keyed by the line's text)
function T.PlanOrder(lines, beats, times, zones, S)
    local n = #lines
    local head = 0
    while head < n and PLAN_OPEN[beats[head + 1] or ""] do head = head + 1 end
    local groups, hours, lead, current = {}, {}, {}, nil
    for i = head + 1, n do
        local t = times[lines[i]]
        if t and t <= 0 then t = nil end
        if beats[i] == "hour" then hours[#hours + 1] = i
        elseif t then current = {t = t, first = i, items = {i}}; groups[#groups + 1] = current
        elseif current then current.items[#current.items + 1] = i
        else lead[#lead + 1] = i end
    end
    table.sort(groups, function(a, b) if a.t ~= b.t then return a.t < b.t end return a.first < b.first end)
    local order = {}
    for i = 1, head do order[#order + 1] = i end
    for _, i in ipairs(lead) do order[#order + 1] = i end
    for _, g in ipairs(groups) do for _, i in ipairs(g.items) do order[#order + 1] = i end end
    for _, i in ipairs(hours) do order[#order + 1] = i end
    local newLines, newBeats = {}, {}
    for k, i in ipairs(order) do
        local text = lines[i]
        -- (moved: the line before it is not the one it followed)
        if k > head and order[k - 1] ~= i - 1 then text = Rekey(S, times, zones, text, StripLead(text)) end
        newLines[k], newBeats[k] = text, beats[i]
    end
    for k = 1, n do lines[k], beats[k] = newLines[k], newBeats[k] end
    return head
end

-- The shape of a chapter (2026-11-09, pass 2). A peak is a death, a great figure met or a first
-- sight of a capital. A chapter that has peaks drops its furniture (places passed, a cave gone
-- into, a rare beast, herbs and fish, a campfire), and a campfire never follows a death. A line
-- of light deeds joins two only when one giver or one chain asked for both and the sentence
-- stays at eighteen words; otherwise the worthier deed stands alone (a thin chapter keeps two,
-- a sentence each). S.dropped lists what was left out and why.
local PLAN_CITIES = {Orgrimmar = true, ["Thunder Bluff"] = true, Undercity = true, ["Stormwind City"] = true, Stormwind = true,
    Ironforge = true, Darnassus = true}
local PLAN_FURNITURE = {explore = true, cave = true, gather = true, swim = true}
-- (round 2) The day's line without its list of quest titles: "... for about two hours and turned
-- in X, a job for a whole party." keeps the span; a line that is only its titles gives nil.
local function PlanStripTitles(line)
    local s = line:find(",? and turned in {q:") or line:find(",? and finished {q:")
    if s then return line:sub(1, s - 1) .. "." end
    s = line:find(", turned in {q:", 1, true) or line:find(", finished {q:", 1, true)
    if s then
        local rest
        for at in line:gmatch("(), and ") do if at > s then rest = line:sub(at + 6) end end
        return line:sub(1, s - 1) .. (rest and (" and " .. rest) or ".")
    end
    return nil
end
-- (round 2) A raise you gave: "You brought him back from death."
local function PlanRaiseGiven(S, line, beat)
    local e = S.ME[line]
    if e and e.k == "first" and e.d == "rezother" then return true end
    if beat ~= "rez" then return false end
    local plain = PlanPlain(line)
    return (plain:find("^You ") or plain:find("^I ") or plain:find("^Your ") or plain:find("^My ") or plain:find("^The Light answered ")) ~= nil
end
-- (round 2) Where the line "Tarok, a tauren warrior, came along too." stands, if the chapter has one.
local function PlanAlsoAt(out, beats)
    local ends = {}
    for _, pool in ipairs({PB.alsoThere or {}, PB.alsoTherePlural or {}}) do
        for _, l in ipairs(pool) do
            local tail = l:match("^{others}(.+)$")
            if tail then ends[#ends + 1] = ((tail:gsub("%p", "%%%0")):gsub("%%{pairObj%%}", ".-")) .. "$" end
        end
    end
    ends[#ends + 1] = " came along too%.$"
    for i, line in ipairs(out) do
        if beats[i] == "shared" then
            local plain = PlanPlain(line)
            for _, pat in ipairs(ends) do if plain:find(pat) then return i end end
        end
    end
end
function T.PlanShape(c)
    local out, beats, times, zones, S, teller = c.out, c.beats, c.times, c.zones, c.S, c.teller
    local L, QD, b = A.Lore, A.QuestDeeds, teller.base
    local function Story(q) return q and L and L.QuestStory and L.QuestStory(q.title, q.qid) or nil end
    S.dropped = {}
    S.subject = b.we
    local peaks, words, deathT, seenE = 0, 0, {}, {}
    for i, line in ipairs(out) do
        local e, kind = S.ME[line], nil
        if beats[i] == "death" then kind = "death"; deathT[#deathT + 1] = times[line]
        elseif e and not seenE[e] and e.k == "first" and e.d == "notable" and line:find("{n:", 1, true) then kind = "figure"
        elseif e and not seenE[e] and e.k == "first" and e.d == "zone" and PLAN_CITIES[(tostring(e.z or ""):gsub("^[Tt]he ", ""))] then kind = "city" end
        if kind then S.peak[line] = kind; peaks = peaks + 1; if e then seenE[e] = true end end
        words = words + PlanWords(line)
    end
    local crowded = peaks >= 2 or (peaks >= 1 and words > 110)
    local run = false
    for i = 1, #out do if beats[i] == "climax" then run = true end end
    -- Round 2 (2026-11-09). The companion's deaths this chapter tells, and the first death of
    -- anyone, by time.
    local theirDeaths, firstDeath = {}, nil
    for i, line in ipairs(out) do
        local e = S.D[line]
        if e then
            local t = times[line] or e.t
            if e.w ~= "you" then theirDeaths[#theirDeaths + 1] = t or 0 end
            if beats[i] == "death" and t and t > 0 and (not firstDeath or t < firstDeath) then firstDeath = t end
        end
    end
    -- (the day's line never says "for" twice: "in Durotar for a second day for about two hours")
    for i, line in ipairs(out) do
        if beats[i] == "day" then
            local new, n = line:gsub("( for a %a+ day) for [%a ]-( and )", "%1%2", 1)
            if n == 0 then new, n = line:gsub("( for a %a+ day) for [%a ]-([,%.])", "%1%2", 1) end
            if n > 0 then out[i] = Rekey(S, times, zones, line, new) end
        end
    end
    -- (someone else of the list who came along: plain words, and no hour of its own, so it
    -- stays where the telling put it; PlanChapter keeps it from opening the chapter)
    do
        local i = PlanAlsoAt(out, beats)
        if i then
            local line = out[i]
            local new = line:gsub(" made one more in the party%.$", " came along too."):gsub(" was in the party as well%.$", " came along too.")
            if new ~= line then out[i] = Rekey(S, times, zones, line, new) end
            times[out[i]] = nil
        end
    end
    -- (quest titles: a quest nobody has written is not told, so "saw X through" goes; one list
    -- of titles a chapter at most, none with a colon or quote marks in a title, and none that
    -- tells a turn-in ahead of the death that came before it)
    do
        local listed, i = false, 1
        while i <= #out do
            local line = out[i]
            local why
            if beats[i] ~= "shared" and line:find("{q:", 1, true) and not S.setup[line] and not S.setupFor[line] then
                if line:find(" saw {q:[^}]*} through") then why = "title"
                else
                    local bad = listed
                    for title in line:gmatch("{q:([^}]*)}") do
                        if title:find("[:\"]") then bad = true end
                        for _, q in ipairs(c.f and c.f.quests or {}) do
                            if firstDeath and (tostring(q.title):gsub("[{}]", "")) == title and (q.t or 0) > firstDeath
                                and (times[line] or 0) < firstDeath then bad = true end
                        end
                    end
                    if bad then
                        local new = beats[i] == "day" and PlanStripTitles(line) or nil
                        if new then
                            S.dropped[#S.dropped + 1] = {why = "titles", text = line, kept = new}
                            out[i] = Rekey(S, times, zones, line, new)
                        else why = "titles" end
                    else listed = true end
                end
            end
            if why then
                S.dropped[#S.dropped + 1] = {why = why, text = line}
                table.remove(out, i); table.remove(beats, i)
                words = words - PlanWords(line)
            else i = i + 1 end
        end
    end
    for i = #out, 1, -1 do
        local line = out[i]
        local e, why = S.ME[line], nil
        -- (a verdict on the day is not a close: "It had been a good day's work.")
        if beats[i] == "close" and not line:find("{", 1, true) and PlanWords(line) <= 8 then why = "verdict" end
        -- (a raise is told only with the death it answers)
        do
            if PlanRaiseGiven(S, line, beats[i]) then
                local t, told = times[line], false
                for _, dt in ipairs(theirDeaths) do if not t or dt <= t then told = true end end
                if not told then why = "raise" end
            end
        end
        -- (a quest told by its title alone, "You saw Leaders of the Fang through.", beside a
        -- dungeon run or in a chapter of peaks)
        if (crowded or run) and (beats[i] == "questKey" or beats[i] == "quest") and not S.setup[line] and not S.setupFor[line]
            and line:find("{q:", 1, true) and not line:find("[%.!%?]%s") and PlanWords((line:gsub("{q:[^}]*}", "Q"))) <= 5 then
            why = "title"
        end
        if not S.peak[line] and not S.Q[line] and not S.Qs[line] and not S.setup[line] and not S.setupFor[line] then
            if beats[i] == "rest" then
                local plain, t = PlanPlain(line):lower(), times[line]
                local camp = (plain:find("fire", 1, true) or plain:find("camp", 1, true)) and not plain:find("first", 1, true) and not plain:find(" inn", 1, true)
                local byDeath = false
                for _, dt in ipairs(deathT) do if t and t >= dt and t - dt <= PLAN_NEXT then byDeath = true end end
                if camp and (crowded or byDeath) then why = "rest" end
            elseif beats[i] == "shared" and crowded and e and (PLAN_FURNITURE[e.k] or (e.k == "first" and e.d == "rarebeast")) then
                why = e.k == "first" and e.d or e.k
            end
        end
        if why then
            S.dropped[#S.dropped + 1] = {why = why, text = line}
            table.remove(out, i); table.remove(beats, i)
            words = words - PlanWords(line)
        end
    end
    -- (a fact of the place told twice in other words: the later telling goes)
    local PLACE_FACT = {land = true, dungeon = true, lore = true}
    local function Content(line)
        local set, n = {}, 0
        for w in PlanPlain(line):lower():gmatch("%a+") do if #w >= 5 and not set[w] then set[w] = true; n = n + 1 end end
        return set, n
    end
    for i = #out, 2, -1 do
        local line = out[i]
        if PLACE_FACT[beats[i]] and not S.peak[line] and not S.Q[line] and not S.Qs[line] and not S.setup[line] and not S.setupFor[line] then
            local set, n = Content(line)
            local twice = false
            for k = 1, i - 1 do
                if PLACE_FACT[beats[k]] then
                    local other, shared = Content(out[k]), 0
                    for w in pairs(set) do if other[w] then shared = shared + 1 end end
                    if shared >= 4 and shared * 5 >= n * 3 then twice = true end
                end
            end
            if twice then
                S.dropped[#S.dropped + 1] = {why = "twice", text = line}
                table.remove(out, i); table.remove(beats, i)
            end
        end
    end
    -- The join rule.
    local function Short(giver) return giver and giver:match("(%S+)$") or nil end
    for i = 1, #out do
        local l = out[i]
        local qs = {}
        for _, q in pairs(S.Qs[l] or {}) do if q then qs[#qs + 1] = q end end
        table.sort(qs, function(x, y) return (x.t or 0) < (y.t or 0) end)
        local acts = {}
        for _, q in ipairs(qs) do
            local s = Story(q)
            local a = QD and QD.Act and QD.Act(q, s)
            if a and a.act and a.act ~= "" then
                acts[#acts + 1] = {q = q, act = a.act, giver = a.giver, solo = a.solo, thread = s and s.thread, worth = (s and s.importance) or 3, at = #acts}
            end
        end
        if #qs >= 2 and #acts == #qs then
            local lead = l:match("^(In {%a:[^{}]*}, )") or ""
            local function Sentence(list, first)
                local subject = list[1].solo and b.I or b.we
                if first and lead ~= "" then subject = lead .. subject else subject = Cap(subject) end
                local parts = {}
                for _, a in ipairs(list) do parts[#parts + 1] = a.act end
                return subject .. " " .. table.concat(parts, " and ") .. "."
            end
            local a1, a2 = acts[1], acts[2]
            local related = #acts == 2 and (a1.solo == a2.solo) and ((a1.giver and Short(a1.giver) == Short(a2.giver)) or (a1.thread and a1.thread == a2.thread))
            local new, kept
            if related and not (a1.act .. a2.act):find(",", 1, true) and PlanWords(Sentence(acts, true)) <= 18 then
                new, kept = Sentence(acts, true), acts
            else
                -- (the worthier: the one a thread hangs on, one whose giver the chapter names
                -- elsewhere, then by importance, then the earlier)
                local others = {}
                for k, other in ipairs(out) do if k ~= i then others[#others + 1] = other end end
                local rest = PlanPlain(table.concat(others, " "))
                local key = S.setupFor[l]
                for _, a in ipairs(acts) do
                    a.score = a.worth
                    if a.giver and rest:find(Short(a.giver), 1, true) then a.score = a.score + 10 end
                    if key and (a.act:find(key, 1, true) or (a.giver or ""):find(key, 1, true)) then a.score = a.score + 100 end
                end
                table.sort(acts, function(x, y) if x.score ~= y.score then return x.score > y.score end return x.at < y.at end)
                if peaks == 0 and words < 60 then
                    kept = {acts[1], acts[2]}
                    table.sort(kept, function(x, y) return x.at < y.at end)
                    new = Sentence({kept[1]}, true) .. " " .. Sentence({kept[2]})
                else
                    kept = {acts[1]}
                    new = Sentence(kept, true)
                end
                for k = #kept + 1, #acts do S.dropped[#S.dropped + 1] = {why = "join", text = acts[k].act} end
            end
            if new ~= l then
                local first = kept[1].q
                times[new] = times[new] or first.t or times[l]
                zones[new] = zones[new] or first.z or (first.scene and first.scene.zone) or zones[l]
                out[i] = Rekey(S, times, zones, l, new)
                S.Qs[new] = {}
                for _, a in ipairs(kept) do S.Qs[new][#S.Qs[new] + 1] = a.q end
            end
        end
    end
end

-- The chapter's plan, in place (c: out, beats, times, zones, S, f, day, teller, place, person,
-- history, ownJournal, lastOuting). Steps 3-4: the level after a death, the companion stopping,
-- a thread's setup, the order, the aftermath of a death, figures' lore, and the hooks felt lines
-- will use (S.setup[line] = what it points back to; S.setupFor[line] = the thread it sets up).
function T.PlanChapter(c)
    local out, beats, times, zones, S, f, teller = c.out, c.beats, c.times, c.zones, c.S, c.f, c.teller
    local rng = Rng("plan" .. tostring(c.day and c.day.key) .. tostring(c.person and c.person.name) .. tostring(c.person and c.person.retell or ""))
    local function Put(text, beat, t, z, at)
        at = math.min(at or #out + 1, #out + 1)
        table.insert(out, at, text); table.insert(beats, at, beat)
        times[text], zones[text] = t, z
        return text
    end
    local function Say(key, tokens)
        -- (the chapter's places are not "there" in a line the planner writes: it may stand first)
        local saved = teller.saidPlaces
        teller.saidPlaces = {}
        local line = teller:Say(key, PB[key], rng, tokens)
        teller.saidPlaces = saved
        teller.pendingTokens = nil
        return line
    end
    local function Remove(i) table.remove(out, i); table.remove(beats, i) end
    local L = A.Lore
    local function Story(q) return q and L and L.QuestStory and L.QuestStory(q.title, q.qid) or nil end
    -- (a quest's setup prose, wherever it stands, is a setup line; so is a told stage that opens
    -- on its setup, "A poster in Brill named the gnoll Maggot Eye. You found him...": its first
    -- sentence has nobody of ours in it; "Leonid told you of the day..." is what happened then)
    local OURS = {"{We}", "{we}", "{us}", "{our}", "{Our}", "{I}", "{me}", "{my}", "{My}"}
    local function Ours(sentence)
        for _, tok in ipairs(OURS) do if sentence:find(tok, 1, true) then return true end end
        return false
    end
    for _, q in ipairs(f.quests) do
        local s = Story(q)
        for _, w in ipairs(s and s.why or {}) do S.SL[w] = true; if A.JournalIslands then S.SL[A.JournalIslands(w)] = true end end
    end
    for _, line in ipairs(out) do
        local s = Story(S.Q[line])
        for _, v in ipairs(s and s.pov or {}) do
            local lead = PlanPlain(v):match("^[^{]*")
            local firstSentence = v:match("^(.-[%.!%?])%s") or v
            if #lead >= 12 and PlanPlain(line):sub(1, #lead) == lead and not Ours(firstSentence) then S.SL[line] = true end
        end
    end
    local deaths = {}
    for i, line in ipairs(out) do if beats[i] == "death" and times[line] then deaths[#deaths + 1] = {text = line, t = times[line]} end end

    -- 3b. The level reached right after a death says so ("Dahlia reached level 13 a minute later");
    -- a level of yours told with it keeps its own time.
    do
        local theirs, dT = f.levels[#f.levels], nil
        for _, d in ipairs(deaths) do if f.levelT and f.levelT >= d.t and f.levelT - d.t <= PLAN_NEXT then dT = d.t end end
        local first
        for i, line in ipairs(out) do if S.LV[line] and not first then first = i end end
        if dT and theirs and first then
            local function After(gap) return gap <= 90 and "a minute later" or gap <= 300 and "a few minutes later" or "soon after" end
            local theirsLine = Say("levelAfterDeath", {theirs = theirs, after = After(f.levelT - dT)})
            local mineLine, mineT = nil, f.myLevelT
            if theirsLine and S.levelMine then
                if mineT and mineT >= dT and mineT - dT <= PLAN_NEXT then
                    mineLine = Say("levelAfterDeathMine", {mine = S.levelMine, after = After(mineT - dT)})
                else
                    mineLine = Say("myLevel", {mine = S.levelMine})
                end
                if not mineLine then theirsLine = nil end
            end
            if theirsLine then
                for i = #out, 1, -1 do if S.LV[out[i]] then Remove(i) end end
                Put(theirsLine, "level", f.levelT, f.levelZ, first)
                S.LV[theirsLine] = true
                if mineLine then Put(mineLine, "level", mineT or f.levelT, f.myLevelZ or f.levelZ, first + 1); S.LV[mineLine] = true end
            end
        end
    end

    -- 3d. The companion stopped before you, late: that is the last fact ("It was just after one
    -- when Dahlia stopped"), in place of the hour line.
    do
        local last = c.lastOuting
        local h = last and last.e and date and tonumber(date("%H", last.e))
        local onAfter = false
        for _, e in ipairs(c.ownJournal or {}) do
            if last and e.k == "play" and (e.e or e.t or 0) >= last.e + 300 and (e.t or 0) <= last.e + 600 then onAfter = true end
        end
        if onAfter and h and (h >= 23 or h < 5) then
            local clock = ClockPhrase(last.e)
            local line = clock and Say("companionStopped", {clock = (clock:gsub("^%u", string.lower))})
            if line then
                for i = #out, 1, -1 do if beats[i] == "hour" then Remove(i) end end
                Put(line, "hour", last.e, last.zone)
                S.companionStop = line
            end
        elseif last and h and h < 5 then
            -- (the pair stopping past midnight: the close names the company, not the clock alone)
            for i = #out, 1, -1 do
                if beats[i] == "hour" and PlanPlain(out[i]):lower():find("midnight", 1, true) then
                    local clock = ClockPhrase(last.e)
                    local b = teller.base
                    local who = c.voice == "we" and (b.name .. " and I") or ("you and " .. b.name)
                    local line = clock and Say("planClose", {clock = (clock:gsub("^%u", string.lower)), who = who, Who = Cap(who)})
                    if line then out[i] = Rekey(S, times, zones, out[i], line) end
                    break
                end
            end
        end
    end

    -- 3c. Threads: a told beat that names someone (Gunther, Bethor) whose earlier beat today was
    -- folded into a light line or not told gets its setup, once, at that beat's time.
    do
        local names = {}
        for _, q in ipairs(f.quests) do local s = Story(q); local g = s and s.pov and s.pov.giver; if g then names[g] = true end end
        for _, line in ipairs(out) do for n in line:gmatch("{n:([^}]+)}") do names[n] = true end end
        local keys = {}
        for name in pairs(names) do
            for w in name:gmatch("[%a']+") do if #w >= 5 and not PLAN_TITLES[w] then keys[#keys + 1] = w; break end end
        end
        table.sort(keys)
        local toldQ, folded = {}, {}
        for _, line in ipairs(out) do
            local q = S.Q[line]
            if q and not toldQ[q] then toldQ[q] = line end
            for _, fq in pairs(S.Qs[line] or {}) do folded[fq] = line end
        end
        local function StoryText(s)
            if not s then return "" end
            local parts = {}
            for _, key in ipairs({"why", "after", "highlight"}) do for _, x in ipairs(s[key] or {}) do parts[#parts + 1] = x end end
            if s.pov then for _, x in ipairs(s.pov) do parts[#parts + 1] = x end; parts[#parts + 1] = s.pov.giver or "" end
            return PlanPlain(table.concat(parts, " "))
        end
        local done = {}
        local snapshot = {}
        for i, line in ipairs(out) do snapshot[i] = line end
        for _, payoff in ipairs(snapshot) do
            local qp = S.Q[payoff]
            local plain = PlanPlain(payoff)
            -- (the one who gave the payoff's quest is not its thread: Zygand gives half of Brill's work)
            local sp = Story(qp)
            local giver = sp and sp.pov and sp.pov.giver or ""
            for _, key in ipairs(keys) do
                if qp and not done[key] and plain:find(key, 1, true) and not giver:find(key, 1, true) then
                    -- (already set up: an earlier line of the chapter names them)
                    local earlierLine
                    for _, other in ipairs(out) do
                        if other ~= payoff and times[other] and times[payoff] and times[other] < times[payoff] and PlanPlain(other):find(key, 1, true) then earlierLine = other; break end
                    end
                    local earliest
                    for _, q in ipairs(f.quests) do
                        if q ~= qp and (q.t or 0) < (qp.t or 0) and not toldQ[q] and StoryText(Story(q)):find(key, 1, true)
                            and (not earliest or q.t < earliest.t) then earliest = q end
                    end
                    if earlierLine then
                        done[key] = true
                        S.setup[payoff] = {kind = "thread", key = key, setupName = key}
                        S.setupFor[earlierLine] = key
                    elseif earliest and folded[earliest] then
                        done[key] = true
                        S.setup[payoff] = {kind = "thread", key = key, setupName = key}
                        S.setupFor[folded[earliest]] = key
                    elseif earliest then
                        local s = Story(earliest)
                        local b = teller.base
                        local text
                        local pov = s and s.pov
                        if pov and #pov > 0 then
                            local v = A.QuestDeeds and A.QuestDeeds.Variant and A.QuestDeeds.Variant(earliest.qid or earliest.title, nil, T.BondKind(c.person) ~= "friend") or 1
                            text = pov[v] or pov[1]
                            local tok = {We = Cap(b.we), we = b.we, us = b.us, our = b.our, Our = Cap(b.our), I = b.I, me = b.me, my = b.my, My = Cap(b.my)}
                            text = text:gsub("{(%a+)}", function(k) return tok[k] end)
                        elseif s and s.highlight and #s.highlight > 0 then
                            text = s.highlight[1]
                        elseif pov and pov.giver then
                            text = "{n:" .. pov.giver .. "}'s errand took " .. b.us .. " to " .. c.place(earliest.z or (earliest.scene and earliest.scene.zone) or "") .. "."
                        end
                        if text and not text:find("{%a+}") then
                            text = Cap(text)
                            if A.JournalIslands then text = A.JournalIslands(text) end
                            done[key] = true
                            Put(text, "questKey", earliest.t, earliest.z or (earliest.scene and earliest.scene.zone))
                            S.Q[text] = earliest
                            S.setupFor[text] = key
                            S.setup[payoff] = {kind = "thread", key = key, setupName = key}
                        end
                    end
                end
            end
        end
    end

    -- 5B. The opening: the hour and the place of the first outing ("Sunday evening found you and
    -- Dahlia back in Tirisfal Glades for a third night running"), not the hours and the count.
    -- A line that also folds in a rest or a named quest stays as it was.
    do
        local at
        for i = 1, math.min(#out, 3) do
            local l = out[i]
            local plain = PlanPlain(l):lower()
            if not at and beats[i] == "day" and not l:find("{q:", 1, true) and (plain:find(" hours?") or plain:find("quests?") or plain:find("minutes"))
                and not plain:find(" inn") and not plain:find("fire") and not plain:find("camp") and not plain:find("rest") then at = i end
        end
        local start = c.firstOuting and c.firstOuting.t
        local h = start and date and tonumber(date("%H", start))
        if at and h and c.mainZone then
            local part = (h >= 5 and h < 12) and "morning" or (h >= 12 and h < 17) and "afternoon" or (h >= 17 and h < 22) and "evening" or "night"
            local b = teller.base
            local named = false
            for i = 1, at - 1 do if out[i]:find(b.name, 1, true) then named = true end end
            local we = c.voice == "we"
            local back = c.history and c.history.zones and c.history.zones[c.mainZone]
            local run = ""
            -- (round 2: from the second night on, so "the very next day she was in the party
            -- again" folds into this line and the chapter has one opener)
            -- (the run is said on the nights the Current telling says it: 2, 3, 5, 7, 10)
            local zr = c.zoneRun or 1
            if zr == 2 or zr == 3 or zr == 5 or zr == 7 or zr == 10 then
                run = " for a " .. Ordinal(c.zoneRun) .. ((part == "evening" or part == "night") and " night" or " day") .. " running"
            end
            -- (on a run of days the line says the rhythm itself: a short "she was in the party
            -- again" before it would say it twice, so the two become one)
            local fold = at == 2 and zr >= 2 and beats[1] == "open" and not out[1]:find("{q:", 1, true)
                and not PlanPlain(out[1]):find("%. ") and select(2, PlanPlain(out[1]):gsub("%S+", "")) <= 10
            if fold then named = false end
            local who = named and (we and "us" or "you") or (we and (b.name .. " and me") or ("you and " .. b.name))
            local line = Say("planOpen", {Weekday = c.weekday or "That", weekday = c.weekday or "that", part = part, who = who,
                backIn = back and "back in " or "in ", backTo = back and "back to " or "to ", zone = c.place(c.mainZone), run = run})
            if line then
                out[at] = Rekey(S, times, zones, out[at], line)
                if fold then table.remove(out, 1); table.remove(beats, 1) end
            end
        end
    end

    -- 5C. The chapter is about the pair already: a shared moment does not say "during your time
    -- together" again.
    for i, l in ipairs(out) do
        if beats[i] == "shared" then
            local new = l:gsub(" during %a+ time together%.$", "."):gsub(" during %a+ travels together%.$", ".")
            -- (a moment of one minute is not "the day": the pool's plain line instead)
            local who, side, foe = new:match("^That was the day (%S+) first saw one of (.-), (.-)%.$")
            if who then new = Cap(who) .. " saw one of " .. side .. " for the first time, " .. foe .. "." end
            -- (the place leads, so the figure's name ends the line and can take a clause after it)
            local head, where = new:match("^(.-) in ({%a:[^{}]*})%.$")
            if new ~= l and head and not head:find(",", 1, true) then
                local word = head:match("^(%a+) ")
                new = "In " .. where .. ", " .. ((word == "You" or word == "We") and head:gsub("^%u", string.lower) or head) .. "."
            end
            if new ~= l then
                out[i] = Rekey(S, times, zones, l, new)
                S.M[new] = S.M[l]
            end
        end
    end

    -- 5B. The ledger: a line of three light deeds keeps the two most worthy ("patrolled east of
    -- the waystation to Balnir Farmstead and cut down cultists..."); the third was light work.
    do
        for i, l in ipairs(out) do
            local qs = {}
            for _, q in pairs(S.Qs[l] or {}) do if q then qs[#qs + 1] = q end end
            if #qs >= 3 and not S.setupFor[l] then
                local acts = {}
                for _, q in ipairs(qs) do
                    local s = Story(q)
                    local act = s and s.pov and s.pov.act
                    local at = act and l:find(act, 1, true)
                    if at then acts[#acts + 1] = {q = q, act = act, at = at, worth = s.importance or 1} end
                end
                if #acts == #qs then
                    table.sort(acts, function(a, b) return a.at < b.at end)
                    local first, lastAct = acts[1], acts[#acts]
                    local prefix, suffix = l:sub(1, first.at - 1), l:sub(lastAct.at + #lastAct.act)
                    while #acts > 2 do
                        local worst = 1
                        for k = 2, #acts do if acts[k].worth <= acts[worst].worth then worst = k end end
                        table.remove(acts, worst)
                    end
                    local new = prefix .. acts[1].act .. " and " .. acts[2].act .. suffix
                    out[i] = Rekey(S, times, zones, l, new)
                    S.Qs[new] = {acts[1].q, acts[2].q}
                end
            end
        end
    end

    -- Peaks, furniture and the join rule (T.PlanShape), then the order of the evening.
    T.PlanShape(c)
    T.PlanOrder(out, beats, times, zones, S)
    -- (round 2: the others in the party never open the chapter, before the companion is named)
    do
        local i = PlanAlsoAt(out, beats)
        if i == 1 and #out >= 2 then
            local line, bt = out[1], beats[1]
            table.remove(out, 1); table.remove(beats, 1)
            table.insert(out, 2, line); table.insert(beats, 2, bt)
        end
    end
    -- (round 2: a raise you gave stands right after the death it answers, not at the day's end)
    do
        local death
        for i, line in ipairs(out) do
            local e = S.D[line]
            if e and e.w ~= "you" then death = i
            elseif death and PlanRaiseGiven(S, line, beats[i]) then
                local to = death + 1
                while to < i and beats[to] == "deathLore" do to = to + 1 end
                if to < i then
                    local bt = beats[i]
                    table.remove(out, i); table.remove(beats, i)
                    table.insert(out, to, line); table.insert(beats, to, bt)
                end
                break
            end
        end
    end

    -- 3b. Right after a death, what the record says came next within ten minutes (a level, a
    -- raise, a rest); other lines of those minutes follow them.
    do
        local i = 1
        while i <= #out do
            local t = beats[i] == "death" and times[out[i]]
            if t then
                local at = i
                while beats[at + 1] == "rez" or beats[at + 1] == "deathLore" or beats[at + 1] == "consequence" do at = at + 1 end
                local j = at + 1
                while j <= #out do
                    local tj = times[out[j]]
                    if beats[j] == "hour" or (tj and tj - t > PLAN_NEXT) then break end
                    if beats[j] == "level" or beats[j] == "levelMark" or beats[j] == "rez" or beats[j] == "rest" then
                        if j > at + 1 then
                            local text, beat = table.remove(out, j), table.remove(beats, j)
                            table.insert(out, at + 1, text); table.insert(beats, at + 1, beat)
                        end
                        at = at + 1
                    end
                    j = j + 1
                end
                i = at + 1
            else i = i + 1 end
        end
    end

    -- 5C. A country first seen as the last thing of the day closes the chapter as an arrival
    -- ("Before the night was over, you had set foot in the Undercity for the first time.").
    do
        local last = #out
        while last > 1 and beats[last] == "hour" do last = last - 1 end
        local l = out[last]
        local t = l and times[l]
        local h = t and t > 0 and date and tonumber(date("%H", t))
        if last > 3 and beats[last] == "shared" and S.zoneFirstD and h and PlanPlain(l):lower():find(PlanPlain(S.zoneFirstD):lower(), 1, true) and not PlanPlain(l):find("%. ") then
            local line = Say("planArriveLast", {span = (h >= 17 or h < 5) and "night" or "day", zoneD = S.zoneFirstD})
            if line then
                out[last] = Rekey(S, times, zones, l, line)
                S.M[line] = S.M[l]
            end
        end
    end

    -- 3e. A figure's lore sentence: a clause on the meeting line when short enough, else gone when
    -- the chapter named the figure before. The meeting line remembers that it was set up.
    do
        local npcs = A.SelfWords and A.SelfWords.notableNPCs or {}
        local lore = {}
        for figure, list in pairs(npcs) do
            for _, l in ipairs(list) do lore[l] = figure; if A.JournalIslands then lore[A.JournalIslands(l)] = figure end end
        end
        -- (people the day's work names: who spoke of the figure, "Bethor promised the Dark Lady")
        local people = {}
        for _, q in ipairs(f.quests) do
            local s = Story(q)
            local g = s and s.pov and s.pov.giver
            for w in (g or ""):gmatch("[%a']+") do if #w >= 5 and not PLAN_TITLES[w] then people[#people + 1] = w; break end end
        end
        for _, l in ipairs(out) do
            for n in l:gmatch("{n:([^}]+)}") do
                for w in n:gmatch("[%a']+") do if #w >= 5 and not PLAN_TITLES[w] then people[#people + 1] = w; break end end
            end
        end
        -- (true when named before; then the name it went by and who said it, when the line shows it)
        local function NamedBefore(figure, upto)
            local before = PlanPlain(table.concat(out, " ", 1, upto))
            local function Speaker(at)
                local sentence = before:sub(1, at - 1):match("([^%.!%?]*)$") or ""
                local best, bestAt
                for _, w in ipairs(people) do
                    local from = 1
                    while true do
                        local s0 = sentence:find(w, from, true)
                        if not s0 then break end
                        if not figure:find(w, 1, true) and (not bestAt or s0 > bestAt) then best, bestAt = w, s0 end
                        from = s0 + 1
                    end
                end
                return best
            end
            for _, alias in ipairs(FIGURE_ALIASES[figure] or {}) do
                local at = before:find(alias, 1, true)
                if at then return true, alias, Speaker(at) end
            end
            if not FIGURE_ALIASES[figure] then
                for w in figure:gmatch("[%a']+") do
                    local at = #w >= 5 and not PLAN_TITLES[w] and before:find(w, 1, true)
                    if at then return true, nil, Speaker(at) end
                end
            end
            return false
        end
        local i = 1
        while i <= #out do
            local line = out[i]
            local figure = lore[line]
            local meet = out[i - 1]
            if figure and meet and meet:find("{n:" .. figure .. "}", 1, true) then
                local named = NamedBefore(figure, i - 2)
                local once, pro, rest = line:match("^Once (.-), (%a+) now (.-)%.$")
                local merged
                if once and (pro == "she" or pro == "he") then
                    local mark = "{n:" .. figure .. "}"
                    local at = meet:find(mark, 1, true)
                    merged = meet:sub(1, at + #mark - 1) .. ", once " .. once .. ", who now " .. rest .. "," .. meet:sub(at + #mark)
                    merged = merged:gsub(",,", ","):gsub(",%.", ".")
                    if PlanWords(merged) > 22 then merged = nil end
                end
                if merged then
                    out[i - 1] = Rekey(S, times, zones, meet, merged)
                    Remove(i)
                elseif named then
                    Remove(i)
                else
                    i = i + 1
                end
            else
                i = i + 1
            end
        end
        -- (the hook: a figure met who was named earlier in the chapter)
        for k, l in ipairs(out) do
            for figure in l:gmatch("{n:([^}]+)}") do
                local named, alias, speaker = false, nil, nil
                if npcs[figure] then named, alias, speaker = NamedBefore(figure, k - 1) end
                if named then S.setup[l] = S.setup[l] or {kind = "figureNamed", figure = figure, alias = alias, setupName = speaker} end
            end
        end
    end

    -- (round 2) A list of quest titles is never the chapter's last sentence.
    do
        local last = #out
        local line = out[last]
        while last > 1 and line and beats[last] ~= "shared" and beats[last] ~= "hour" and line:find("{q:", 1, true)
            and not S.setup[line] and not S.setupFor[line] and not S.SL[line] do
            local new = beats[last] == "day" and PlanStripTitles(line) or nil
            S.dropped[#S.dropped + 1] = {why = "titles", text = line, kept = new}
            if new then out[last] = Rekey(S, times, zones, line, new); break end
            table.remove(out, last); table.remove(beats, last)
            last = #out
            line = out[last]
        end
    end

    -- Hooks: a death after an earlier death anywhere in the book (the setup that earns it,
    -- DESIGN §3.0 rule 5: the second death stings because the first was told).
    -- (round 2: only your own deaths count and only your own death takes the hook; a friend's
    -- death an hour before is not an earlier death of yours. The first death of your life, by
    -- your own journal, takes the first-death line. Two deaths running are not both "got the
    -- better of".)
    do
        local h = c.history or {}
        local seen, any = {}, false
        for _, foe in ipairs(h.planDeaths or {}) do seen[foe] = true; any = true end
        local mine, counted = {}, {}
        for i, line in ipairs(out) do
            local e = S.D[line]
            if e and e.w == "you" and not counted[e] then
                counted[e] = true
                local foe = e.boss or e.d
                if beats[i] == "death" then
                    local plain = PlanPlain(line)
                    local shape = plain:find(" got the better of ", 1, true) and "better" or "other"
                    if shape == "better" and h.planDeathShape == "better" and not plain:find("%. ") then
                        -- ("Riptear got the better of you." -> "You fell to Riptear.")
                        local killer, me = line:match("^(.-) got the better of (%a+)%.$")
                        local subj = me == "you" and "You" or me == "me" and "I" or nil
                        local new
                        if killer and subj then
                            killer = killer:gsub("^A ", "a "):gsub("^An ", "an "):gsub("^The ", "the ")
                            new = subj .. " fell to " .. killer .. "."
                        else new = line:gsub(" got the better of ", " killed ", 1) end
                        out[i] = Rekey(S, times, zones, line, new)
                        line, shape = new, "other"
                    end
                    h.planDeathShape = shape
                    if any then
                        S.setup[line] = S.setup[line] or {kind = "deathAgain", foe = foe, same = foe and seen[foe] or nil}
                    elseif c.ownJournal and (tonumber(c.startLevel) or 99) <= 9 then
                        local earlier = false
                        for _, x in ipairs(c.ownJournal) do
                            if x.k == "death" and x.w ~= "them" and (x.t or 0) < (e.t or 0) - 1 then earlier = true end
                        end
                        local key = (c.player and c.player.race == "Scourge") and "planFirstDeathScourge" or "planFirstDeath"
                        local felt = not earlier and PB[key] and PB[key][c.voice == "we" and "we" or "you"] or nil
                        if felt then S.setup[line] = S.setup[line] or {kind = "deathFirst", line = felt} end
                    end
                end
                any = true
                if foe then seen[foe] = true end
                mine[#mine + 1] = foe or "?"
            end
        end
        local all = h.planDeaths or {}
        for _, foe in ipairs(mine) do all[#all + 1] = foe end
        h.planDeaths = all
    end

    -- What the felt lines need (placed when the movements are known, in T.PlanText).
    S.feel = {voice = c.voice, race = c.player and c.player.race, level = f.plEnd or f.plStart, history = c.history, index = c.index,
        foe = c.foe, rng = Rng("feel" .. tostring(c.day and c.day.key) .. tostring(c.person and c.person.name) .. tostring(c.person and c.person.retell or ""))}
end

-- Felt lines (JournalFeel.lua; DESIGN §3.0 rule 5): one after a line whose setup the chapter told
-- (a death after a death, a figure named before, a thread's payoff), two a chapter at most, one a
-- movement, never the chapter's last line; the same kind not within three chapters, the same
-- line never twice in a book. Figures first, then threads, then deaths; an identity pool (a
-- Forsaken before Sylvanas) before the stage's own. No pool for the stage or voice: no line.
local FIGURE_KEYS = {["Lady Sylvanas Windrunner"] = "Sylvanas"}
T.FigureKeys = FIGURE_KEYS
local FEEL_RANK = {figureNamed = 1, thread = 2, deathFirst = 3, deathAgain = 4}
-- (first words of a felt line that need no name in the chapter behind them)
local FEEL_COMMON = {here = true, somehow = true, dying = true, death = true, earlier = true, ["until"] = true, i = true}
local function FeelStage(level)
    level = tonumber(level)
    if not level then return nil end
    return level < 20 and "fledgling" or level < 45 and "seasoned" or "known"
end
function T.PlanFeel(paras, info, S, total)
    local F, fc = A.JournalFeel, S and S.feel
    if not F or not fc or #paras == 0 then return total end
    local voice = fc.voice == "we" and "i" or "you"
    local hist = fc.history or {}
    hist.feelKind, hist.feelSaid = hist.feelKind or {}, hist.feelSaid or {}
    local said = {}
    for _, p in ipairs(paras) do said[#said + 1] = table.concat(p.lines, " ") end
    said = PlanPlain(table.concat(said, " "))
    local lastPara, lastM = #paras, #paras[#paras].lines
    local cands = {}
    for j, p in ipairs(paras) do
        for m, text in ipairs(p.lines) do
            local hook = S.setup[text]
            local kindPool = hook and F[hook.kind]
            -- (the first death of your life: one line the planner wrote, round 2)
            if hook and hook.kind == "deathFirst" and hook.line then kindPool = {} end
            if type(kindPool) == "table" and not (j == lastPara and m == lastM) then
                local e, q = S.D[text], S.Q[text]
                local stage = FeelStage((e and e.pl) or (q and q.pl) or fc.level)
                local race = fc.race or ""
                local idPool
                local figKey = hook.kind == "figureNamed" and FIGURE_KEYS[hook.figure or ""]
                if figKey then idPool = kindPool[figKey] and kindPool[figKey][race]
                elseif hook.kind ~= "figureNamed" then idPool = kindPool[race] end
                idPool = stage and type(idPool) == "table" and idPool[stage] and idPool[stage][voice] or nil
                local generic = stage and type(kindPool[stage]) == "table" and kindPool[stage][voice] or nil
                if hook.kind == "deathFirst" then idPool, generic = nil, {hook.line} end
                cands[#cands + 1] = {j = j, m = m, hook = hook, id = idPool, gen = generic, e = e, order = #cands}
            end
        end
    end
    table.sort(cands, function(a, b)
        local ra, rb = FEEL_RANK[a.hook.kind] or 9, FEEL_RANK[b.hook.kind] or 9
        if ra ~= rb then return ra < rb end
        if (a.id ~= nil) ~= (b.id ~= nil) then return a.id ~= nil end
        return a.order < b.order
    end)
    -- (2026-11-09: never in two paragraphs running, so two feelings never stand a paragraph apart)
    local chosen, usedPara = 0, {}
    for _, cd in ipairs(cands) do
        if chosen >= 2 then break end
        local kind = cd.hook.kind
        local lastUse = hist.feelKind[kind]
        if not usedPara[cd.j] and not usedPara[cd.j - 1] and not usedPara[cd.j + 1] and not (lastUse and (fc.index or 0) - lastUse <= 3) then
            local tokens = {}
            if cd.e and fc.foe and (cd.e.boss or cd.e.d) then tokens.foe = fc.foe(cd.e.boss or cd.e.d, cd.e.a) end
            if cd.hook.setupName then tokens.setupName = "{n:" .. cd.hook.setupName .. "}" end
            if cd.hook.figure then
                local alias = cd.hook.alias
                tokens.figure = alias and (alias:find(" ") and ("the " .. alias) or ("{n:" .. alias .. "}")) or ("{n:" .. cd.hook.figure .. "}")
            end
            -- (the death line named the killer: the felt line after it does not name it again)
            local foeSaid = false
            if tokens.foe then
                local name = PlanPlain(tokens.foe):gsub("^[Aa]n? ", ""):gsub("^[Tt]he ", "")
                foeSaid = name ~= "" and PlanPlain(paras[cd.j].lines[cd.m]):find(name, 1, true) ~= nil
            end
            local function Usable(list)
                local ok = {}
                for _, l in ipairs(list or {}) do
                    local fits = not hist.feelSaid[l]
                    if foeSaid and l:find("{foe}", 1, true) then fits = false end
                    for tok in l:gmatch("{(%a+)}") do if not tokens[tok] then fits = false end end
                    -- (a name the line says outright must be one the chapter said: "Bethor had promised...")
                    for w in l:gsub("{%a+}", ""):gmatch("%u[%a']+") do
                        if not PLAN_SMALL[w:lower()] and not FEEL_COMMON[w:lower()] and not said:find(w, 1, true) then fits = false end
                    end
                    if fits then ok[#ok + 1] = l end
                end
                return ok
            end
            local pool, identity = Usable(cd.id), true
            if #pool == 0 then pool, identity = Usable(cd.gen), false end
            if #pool > 0 then
                local pick = pool[fc.rng(#pool)]
                local felt = Cap((pick:gsub("{(%a+)}", function(tok) return tokens[tok] end)))
                hist.feelSaid[pick] = true
                hist.feelKind[kind] = fc.index or 0
                usedPara[cd.j] = true
                chosen = chosen + 1
                local p = paras[cd.j]
                total = total + 1
                table.insert(p.lines, cd.m + 1, felt)
                table.insert(p.idx, cd.m + 1, total)
                info[total] = {text = felt, beat = "felt", felt = kind, identity = identity or nil, after = p.lines[cd.m]}
            end
        end
    end
    return total
end

-- The last pass over the words (2026-11-09, pass 2). A person named in full earlier in the
-- chapter goes by the short name after that: "Novice Elreth", then "Elreth"; "Gunther Arcanus",
-- then "Gunther" when the chapter itself calls him that. A sentence over 24 words breaks at
-- ", and you ..." when both halves stand. Nothing is added.
local PLAN_SUB = {When = true, While = true, After = true, Before = true, As = true, If = true, Once = true, Though = true,
    Because = true, Since = true, Until = true, Although = true}
function T.PlanPolish(paras, info, S, times, zones)
    local L = A.Lore
    local npcs = A.SelfWords and A.SelfWords.notableNPCs or {}
    local function Esc(x) return (x:gsub("%p", "%%%0")) end
    local names, known, whole = {}, {}, {}
    local function Note(name)
        if name and name:find(" ", 1, true) and not known[name] and not npcs[name] then known[name] = true; names[#names + 1] = name end
    end
    for _, p in ipairs(paras) do
        for _, line in ipairs(p.lines) do
            whole[#whole + 1] = line
            local qs = {}
            if S.Q[line] then qs[1] = S.Q[line] end
            for _, q in pairs(S.Qs[line] or {}) do if q then qs[#qs + 1] = q end end
            for _, q in ipairs(qs) do
                local s = L and L.QuestStory and L.QuestStory(q.title, q.qid)
                Note(s and s.pov and s.pov.giver)
            end
            for n in line:gmatch("{n:([^}]+)}") do Note(n) end
        end
    end
    local text = PlanPlain(table.concat(whole, " "))
    local short = {}
    for _, name in ipairs(names) do
        local words = {}
        for w in name:gmatch("%S+") do words[#words + 1] = w end
        local k = 1
        while k < #words and PLAN_TITLES[words[k]] do k = k + 1 end
        local blank = text:gsub(Esc(name), string.rep("#", #name))
        local cand
        if k > 1 and k == #words then cand = words[k]
        elseif k == 1 and #words == 2 and #words[1] >= 4 and blank:find("%f[%a]" .. Esc(words[1]) .. "%f[%A]") then
            -- (no title: the first name, when the chapter itself uses it alone)
            cand = words[1]
        end
        -- (only when the full name comes first)
        local full = text:find(name, 1, true)
        local alone = cand and blank:find("%f[%a]" .. Esc(cand) .. "%f[%A]")
        if cand and full and not (alone and alone < full) then short[name] = cand end
    end
    local met = {}
    for _, p in ipairs(paras) do
        for m, line in ipairs(p.lines) do
            local new = line
            for _, name in ipairs(names) do
                local sh = short[name]
                if sh then
                    local count = 0
                    new = new:gsub(Esc(name), function()
                        count = count + 1
                        if met[name] or count > 1 then return sh end
                    end)
                    if count > 0 then met[name] = true end
                end
            end
            -- (the long sentence)
            local pieces, rebuilt = {}, ""
            for sentence, gap in new:gmatch("([^%.!%?]+[%.!%?]+)(%s*)") do pieces[#pieces + 1] = {sentence, gap}; rebuilt = rebuilt .. sentence .. gap end
            if rebuilt == new then
                for _, piece in ipairs(pieces) do
                    local sentence = piece[1]
                    if PlanWords(sentence) > 24 and not PLAN_SUB[sentence:match("^(%a+)") or ""] then
                        local best, bestOff
                        local total = #sentence
                        for _, subject in ipairs({"you", "we", "I"}) do
                            local from = 1
                            while true do
                                local a, z = sentence:find(", and " .. subject .. " ", from, true)
                                if not a then break end
                                local firstHalf, secondHalf = sentence:sub(1, a - 1), sentence:sub(z + 1)
                                local off = math.abs(a - total / 2)
                                if PlanWords(firstHalf) >= 7 and PlanWords(secondHalf) >= 5 and (not bestOff or off < bestOff) then
                                    best, bestOff = firstHalf .. ". " .. Cap(subject) .. " " .. secondHalf, off
                                end
                                from = z
                            end
                        end
                        if not best and S.subject then
                            for _, verb in ipairs({"finished", "turned in"}) do
                                local a, z = sentence:find(",? and " .. verb .. " ")
                                if a and not best then
                                    local firstHalf, secondHalf = sentence:sub(1, a - 1), verb .. " " .. sentence:sub(z + 1)
                                    if PlanWords(firstHalf) >= 7 and PlanWords(secondHalf) >= 4 and not firstHalf:find(", " .. verb, 1, true) then
                                        best = firstHalf .. ". " .. Cap(S.subject) .. " " .. secondHalf
                                    end
                                end
                            end
                        end
                        if best then piece[1] = best end
                    end
                end
                local parts = {}
                for _, piece in ipairs(pieces) do parts[#parts + 1] = piece[1] .. piece[2] end
                new = table.concat(parts)
            end
            if new ~= line then
                p.lines[m] = Rekey(S, times, zones, line, new)
                info[p.idx[m]].text = new
            end
        end
    end
    -- (three sentences running that open on the same bare "You" / "We" / "I": a level line
    -- among them opens on "By then")
    local flat = {}
    for _, p in ipairs(paras) do
        for m, line in ipairs(p.lines) do
            local plain = PlanPlain(line)
            local first = true
            for sentence in plain:gmatch("[^%.!%?]+[%.!%?]+") do
                local opener = sentence:match("^%s*(%a+) ")
                if opener ~= "You" and opener ~= "We" and opener ~= "I" then opener = nil end
                if opener and sentence:find("^%s*%a+ and ") then opener = nil end
                local who, level = plain:match("^(%a+) [%a ]-level (%d+)%.$")
                if not who then who, level = plain:match("^(%a+) [%a ]-level (%d+) along the way%.$") end
                local both = false
                if not who then
                    who, level = plain:match("^(%a+) [%a ]-level (%d+) together%.$")
                    both = who == "You" or who == "We"
                    if not both then who, level = nil, nil end
                end
                local beat = info[p.idx[m]].beat
                flat[#flat + 1] = {p = p, m = m, opener = opener,
                    level = first and who == opener and (beat == "level" or beat == "levelMark") and level or nil, both = both}
                first = false
            end
        end
    end
    for k = 3, #flat do
        local a, b, c = flat[k - 2], flat[k - 1], flat[k]
        if c.opener and a.opener == c.opener and b.opener == c.opener then
            local pick = (b.level and b) or (c.level and c) or (a.level and a) or nil
            if pick then
                local who = pick.opener
                local new = "By then " .. (who == "I" and "I was" or (who:lower() .. " were")) .. (pick.both and " both" or "") .. " level " .. pick.level .. "."
                local old = pick.p.lines[pick.m]
                pick.p.lines[pick.m] = Rekey(S, times, zones, old, new)
                info[pick.p.idx[pick.m]].text = new
                pick.opener, pick.level = nil, nil
            end
        end
    end
end

-- Paragraphs and their openings, as the chapter's text. place(zone) gives the zone's token.
-- (2026-11-09, pass 2: paragraphs by sense.) A paragraph ends before a death; before and after a
-- peak (a great figure, a first city), which stands with its feeling and nothing else; where the
-- place changes; after a long gap; and before it would pass four sentences or 55 words. A death
-- keeps what the record says came right after it (a raise, a level "a minute later"), no other
-- level and no errand. One sentence stands alone only as the opening, a death, a peak or the
-- close. Only a death and a long gap open on the hour, and never two paragraphs running.
-- T.keepPlan (tests): a table that receives each chapter's plan.
local PLAN_AFTER = {rez = true, deathLore = true, consequence = true}
local function PlanOurs(plain)
    for _, lead in ipairs({"You ", "We ", "I ", "Your ", "Our ", "My ", "The two of ", "The pair of ", "Both of "}) do
        if plain:sub(1, #lead) == lead then return true end
    end
    return false
end
function T.PlanText(lines, beats, times, zones, place, S)
    local Plain, Words = PlanPlain, PlanWords
    local function Count(line) return select(2, Plain(line):gsub("[%.!%?]%s", "")) + 1 end
    local head = 0
    while head < #lines and PLAN_OPEN[beats[head + 1] or ""] do head = head + 1 end
    local paras, current = {}, nil
    local lastT, lastZ, deathT = nil, nil, nil
    local info = {}
    for i, line in ipairs(lines) do
        local t, z = times[line], zones[line]
        if t and t <= 0 then t = nil end
        local peak = beats[i] == "death" and "death" or (S and S.peak[line]) or nil
        local w, n = Words(line), Count(line)
        local reason
        if current and i > head then
            if peak == "death" then
                -- (two deaths of one fight share the paragraph)
                if not (current.peak == "death" and deathT and t and t - deathT <= PLAN_NEXT) then reason = "death" end
            elseif peak then reason = "peak"
            elseif current.peak == "death" then
                -- (her level "a minute later" belongs to the death; a plain level line does not)
                local plain = Plain(line)
                local said = (beats[i] == "level" or beats[i] == "levelMark") and (plain:find(" later%.$") or plain:find(" soon after%.$"))
                -- (so does a first raise told as a moment)
                local raised = plain:find("from death", 1, true) or plain:find("back to life", 1, true) or plain:find("ever raised", 1, true)
                if not (PLAN_AFTER[beats[i]] or raised or (said and deathT and t and t - deathT <= PLAN_NEXT)) then reason = "after" end
            elseif current.peak then
                if not (S and current.e and S.ME[line] == current.e) then reason = "after" end
            elseif t and z and lastZ and z ~= lastZ then reason = "place"
            elseif t and lastT and t - lastT >= PLAN_GAP then reason = "time"
            elseif current.w + w > 60 or (current.n >= 2 and (current.w + w > 55 or current.n + n > 4)) then reason = "size" end
        end
        if not current or reason then
            current = {lines = {}, idx = {}, reason = reason, prevZ = lastZ, peak = peak, e = peak and S and S.ME[line] or nil, w = 0, n = 0,
                gap = (t and lastT and t - lastT >= PLAN_GAP) or nil}
            paras[#paras + 1] = current
            deathT = nil
        end
        current.lines[#current.lines + 1] = line
        current.idx[#current.idx + 1] = i
        current.w, current.n = current.w + w, current.n + n
        info[i] = {text = line, t = t, z = z, beat = beats[i], open = i <= head or nil, reason = reason, peak = S and S.peak[line] or nil}
        if beats[i] == "death" then deathT = t end
        if t then lastT = t end
        if z and t then lastZ = z end
    end
    -- (a paragraph of one sentence joins a neighbour that has room, the one before it first; a
    -- peak neither takes one in nor is taken in)
    local function Merge(into, from)
        for m, line in ipairs(from.lines) do into.lines[#into.lines + 1] = line; into.idx[#into.idx + 1] = from.idx[m] end
        for _, i in ipairs(from.idx) do info[i].merged = true end
        into.w, into.n = into.w + from.w, into.n + from.n
    end
    local function Fits(x, y) return x and y and not x.peak and not y.peak and x.w + y.w <= 60 and x.n + y.n <= 5 end
    local k = 1
    while k <= #paras and #paras > 1 do
        local p, prev, nextP = paras[k], paras[k - 1], paras[k + 1]
        if p.n <= 1 and not p.peak and Fits(prev, p) then
            Merge(prev, p)
            table.remove(paras, k)
        elseif p.n <= 1 and not p.peak and Fits(p, nextP) then
            Merge(p, nextP)
            table.remove(paras, k + 1)
        else k = k + 1 end
    end
    -- Felt lines, one a movement at most, after the line whose setup the chapter told.
    if S and S.feel then T.PlanFeel(paras, info, S, #lines) end
    -- Openings: a later paragraph opens on its place (a new zone the paragraph does not name), or
    -- on its hour when it is a death or follows a long gap; the hour only on a line that tells
    -- what happened then, never a quest's setup, and never on two paragraphs running.
    local seen, clockBefore = {}, false
    for j, p in ipairs(paras) do
        local first = p.lines[1]
        local t, z
        for _, i in ipairs(p.idx) do if info[i].t then t, z = info[i].t, info[i].z; break end end
        if j == 1 then
            for _, i in ipairs(p.idx) do if info[i].z then seen[info[i].z] = true end end
        else
            local body = StripLead(first)
            local prefix
            local plainBody = Plain(body)
            local setupLine = (S and S.SL[first]) or beats[p.idx[1]] == "questStart"
            -- (named: the movement says the place itself, in its first line or later)
            local named = z and Plain(table.concat(p.lines, " ")):find((Plain(place(z)):gsub("^[Tt]he ", "")), 1, true)
            local timed = plainBody:find("^[%a ]*[Mm]idnight") or plainBody:find("^Past ") or plainBody:find("^Just after ")
                or plainBody:find("^A little after ") or plainBody:find("^Close to ") or plainBody:find("^Around ")
                or plainBody:find("^That ") or plainBody:find("^By ") or plainBody:find("^Late ") or plainBody:find("^Early ")
            -- (a death opens on its hour, "A little after eleven, Riptear...", wherever it was)
            local leadIn = not PlanOurs(plainBody) and (plainBody:match("^%a+ [^,%.]-,") ~= nil) and select(2, (plainBody:match("^[^,%.]*") or ""):gsub("%S+", "")) <= 4
            local clockFirst = p.reason == "death" and not setupLine and not leadIn and ClockPhrase(t)
            -- (a deed the line places itself, "from the lich's camp on Brightwater Lake", is not
            -- placed in the town where it was handed in: it opens on its hour instead)
            local sentence = plainBody:match("^[^.]*") or plainBody
            local elsewhere = sentence:find(" on %u") or sentence:find(" on the %u") or sentence:find(" at %u") or sentence:find(" at the %u")
                or sentence:find(" in %u") or sentence:find(" in the %u")
            if T.PlaceLed(body) or timed then prefix = nil
            elseif clockFirst then prefix = clockFirst .. ", "
            elseif z and p.prevZ and z ~= p.prevZ and not named and not elsewhere and not (S and (S.Q[first] or S.Qs[first]))
                and beats[p.idx[1]] ~= "hour" then
                -- (the hour the day ended is not placed: its place is only where the evening began)
                prefix = (seen[z] and "Back in " or "In ") .. place(z) .. ", "
            elseif not setupLine and p.gap and not clockBefore and beats[p.idx[1]] ~= "level" and beats[p.idx[1]] ~= "levelMark"
                and PlanOurs(plainBody) and not (S and (S.Q[first] or S.Qs[first])) then
                -- (never on a line about a place, "The Scarlet Monastery was a hard venture...";
                -- never on a quest, whose time is its hand-in: "Past midnight, Gunther gave you...")
                local clock = ClockPhrase(t)
                prefix = clock and (clock .. ", ") or nil
            end
            clockBefore = (timed and true) or (prefix ~= nil and prefix:find("^In ") == nil and prefix:find("^Back in ") == nil)
            if prefix then
                body = body:gsub("^Later that day,? ", ""):gsub("^Later,? ", "")
                local word = body:match("^(%a+)")
                if word and word ~= "I" and PLAN_SMALL[word:lower()] then body = body:gsub("^%u", string.lower) end
                body = prefix .. body
            end
            p.lines[1] = Rekey(S, times, zones, first, body)
            info[p.idx[1]].text = body
            info[p.idx[1]].anchor = prefix
            info[p.idx[1]].setupLine = setupLine or nil
            for _, i in ipairs(p.idx) do if info[i].z then seen[info[i].z] = true end end
        end
    end
    if S then T.PlanPolish(paras, info, S, times, zones) end
    local texts = {}
    for j, p in ipairs(paras) do
        texts[j] = table.concat(p.lines, " ")
        for m, i in ipairs(p.idx) do
            info[i].para = j
            local text = p.lines[m]
            if S then info[i].setup, info[i].setupFor, info[i].isSetup = S.setup[text], S.setupFor[text], S.SL[text] or nil end
        end
    end
    if T.keepPlan then
        -- (in reading order; felt lines are marked felt)
        local list = {}
        for _, p in ipairs(paras) do for _, i in ipairs(p.idx) do list[#list + 1] = info[i] end end
        T.keepPlan[#T.keepPlan + 1] = {lines = list, count = #lines, companionStop = S and S.companionStop, dropped = S and S.dropped}
    end
    return table.concat(texts, "\n\n")
end

-- The book ---------------------------------------------------------------------------------
-- brief: Highlights in Story mode (the notable beats only).
-- The companion chapter composed (2026-11-12, lane C8). Once the teller has written the day's
-- lines, this pass reads them as the own book's composer does (JournalSelfCompose.lua): the
-- day in episodes (A.JournalEpisodes.Day over the companion's record), every line given to
-- its episode by its stamp, the lines of an episode in time order behind its setting, the
-- furniture dropped (a fire or an inn on a day of work, a cave nothing happened in, a going
-- that led to nothing told, the companion's death with nothing around it or inside a city, a
-- tally of the day's quests or hours), a level told as a clause of the deed it came with or
-- once before the close, the others of the party named only when the chapter shows them doing
-- something, an opener that names the companion and the place the close will answer, and one
-- paragraph an episode (T.ComposeParagraphs: a light one joins its neighbour, a long one splits
-- at a turn, eight at most). Nothing is added to the record; the close stays the teller's.
T.COMPOSE = true
T.MIN_WORDS, T.MAX_WORDS, T.MAX_PARAGRAPHS = 40, 110, 8
local SETTING_BEATS = {open = true, day = true, land = true, landKey = true, travel = true, stage = true, prologue = true, recap = true,
    again = true, greeting = true, city = true}
local WORK_BEATS = {questKey = true, quests = true, questStart = true, questOutcome = true, questTurn = true, dungeon = true, climax = true,
    kills = true, death = true, rez = true, consequence = true, roles = true, deathLore = true}
local OTHERS_MARKS = {"made a third", "came along too", "one more in the party", "went with", "joined {", "for the day", "there too",
    "along as well", "filled out the party", "was along", "in the party as well"}
local function PlainOf(text) return A.JournalPlain and A.JournalPlain(text) or (tostring(text or ""):gsub("{%a:([^}]*)}", "%1")) end
local function CountWords(text) local n = 0 for _ in PlainOf(text):gmatch("%S+") do n = n + 1 end return n end
local function IsCity(zone)
    local L = A.Lore
    local info = zone and L and L.Zone and L.Zone(zone)
    if info and info.kind == "city" then return true end
    local z = Clean(zone or "")
    return z == "Undercity" or z == "Orgrimmar" or z == "Thunder Bluff" or z == "Stormwind City" or z == "Ironforge" or z == "Darnassus"
end
local function OthersLine(text)
    if text:find("^With {") or text:find("^With you went ") or text:find("^With us went ") or text:find("^With me went ") then return true end
    for _, mark in ipairs(OTHERS_MARKS) do if text:find(mark, 1, true) then return true end end
    return false
end
local function FirstTold(low)
    return low:find("first", 1, true) or low:find("never", 1, true) or low:find("new to", 1, true) or low:find("new ground", 1, true)
end
-- The road and the company (lane C8, 2026-11-12), two passes of T.Compose over the kept lines.
-- T.ComposeRoad: a long walk while together (your own book's stays joined on foot, no flight,
-- zeppelin, boat or hearth between them, cities and dungeons left out; four lands or more, or two
-- new ones with a death on the way or lands well above your level, and little questing) is one
-- paragraph: setting out (from where, the lands, the firsts folded in, how far above you), the
-- dangers as the road's own lines in time order, where it turned back and how long out.
-- T.ComposeCompany: the strangers your own book saw in the group ("member" lines with no circle,
-- lane REC8): a short company that did something the chapter tells (work handed in while they
-- were there) or fought elites long enough to be dangerous is a small adventure: who joined (by
-- name, by kind or as strangers, the same per retell), the elites said subtly when they were
-- many, and the parting; one together ten minutes or more is said at least as who they were.
-- Neither pass adds a fact the record lacks; without "member" lines nothing changes.
local CARRIED = {voyage = true, hearth = true, nightflight = true, taxi = true, portal = true}
local function DayWindow(day)
    local t0, e0 = math.huge, 0
    for _, scene in ipairs(day and day.scenes or {}) do
        if scene.kind == "outing" then t0 = math.min(t0, scene.t or t0); e0 = math.max(e0, scene.e or scene.t or 0) end
    end
    return t0, e0
end
local function NewLine(lines, text, beat, t, EpisodeAt, S, zone)
    local l = {n = #lines + 1.5, text = text, beat = beat, t = t, ep = EpisodeAt(t), added = true}
    if S and zone and S.Z[text] == nil then S.Z[text] = zone end
    lines[#lines + 1] = l
    return l
end
function T.ComposeRoad(c, lines, EpisodeAt, Place)
    local crowd0 = c.teller.crowd
    T.ComposeRoadInner(c, lines, EpisodeAt, Place)
    c.teller.crowd = crowd0
end
function T.ComposeRoadInner(c, lines, EpisodeAt, Place)
    local own, S, f, teller, PB, rng, tokens = c.ownJournal, c.S, c.f, c.teller, c.PB, c.rng, c.tokens
    if type(own) ~= "table" or not PB.roadOut or not PB.roadOn then return end
    local t0, e0 = DayWindow(c.day)
    if e0 <= t0 then return end
    local stays, breaks, firsts = {}, {}, {}
    -- (round 13: a stay begun while walking back as a ghost after a death is no land walked: the
    -- graveyard of another land, "back through the Hillsbrad Foothills", is not the road)
    local ghost = {}
    for _, x in ipairs(own) do
        if x.k == "death" and x.w == "you" and x.t and tonumber(x.walk) then ghost[#ghost + 1] = {x.t, x.t + tonumber(x.walk) + 60} end
    end
    local function Ghost(t)
        for _, g in ipairs(ghost) do if t > g[1] and t <= g[2] then return true end end
        return false
    end
    for _, x in ipairs(own) do
        local t = x.t or 0
        if t >= t0 - 60 and t <= e0 then
            if x.k == "play" and x.z and not Ghost(t) then stays[#stays + 1] = {zone = x.z, t = t, e = x.e or t, pl = tonumber(x.pl)}
            elseif CARRIED[x.k] then breaks[#breaks + 1] = t
            elseif x.k == "first" and x.d == "zone" and x.z then firsts[x.z] = true end
        end
    end
    table.sort(stays, function(a, b) return a.t < b.t end)
    -- (a border crossed back and forth, a stay of under three minutes with no first in it, is no land)
    local firstAt = {}
    for _, x in ipairs(own) do if x.k == "first" and x.d == "zone" and x.z then firstAt[#firstAt + 1] = x end end
    local kept = {}
    for _, s in ipairs(stays) do
        local brief = s.e - s.t < 180
        if brief then
            for _, x in ipairs(firstAt) do if x.z == s.zone and (x.t or 0) >= s.t - 5 and (x.t or 0) <= s.e + 5 then brief = false end end
        end
        if not brief then kept[#kept + 1] = s end
    end
    stays = kept
    local seq = {}
    for _, s in ipairs(stays) do
        local last = seq[#seq]
        if last and last.zone == s.zone then last.e = math.max(last.e, s.e) else seq[#seq + 1] = {zone = s.zone, t = s.t, e = s.e, pl = s.pl} end
    end
    local function Walked(a, b)
        for _, bt in ipairs(breaks) do if bt > a.t + 30 and bt <= b.t + 30 then return false end end
        return true
    end
    local L = A.Lore
    local chains, cur = {}, nil
    for i, s in ipairs(seq) do
        local open = not IsCity(s.zone) and not (L and L.Dungeon and L.Dungeon(s.zone))
        if open and cur and cur[#cur] == seq[i - 1] and Walked(seq[i - 1], s) then cur[#cur + 1] = s
        elseif open then cur = {s}; chains[#chains + 1] = cur
        else cur = nil end
    end
    for _, chain in ipairs(chains) do
        local from, to = chain[1].t, chain[#chain].e
        local distinct, seen = {}, {}
        for _, s in ipairs(chain) do if not seen[s.zone] then seen[s.zone] = true; distinct[#distinct + 1] = s.zone end end
        local level = chain[1].pl or tonumber(f.plStart)
        local deaths, quests = 0, 0
        for _, d in ipairs(f.deaths or {}) do if (d.t or 0) >= from and (d.t or 0) <= to then deaths = deaths + 1 end end
        for _, q in ipairs(f.quests or {}) do if (q.t or 0) >= from and (q.t or 0) <= to then quests = quests + 1 end end
        local startNew = firsts[chain[1].zone]
        -- out to the first land walked again, then back
        local outLeg, back, turned, been = {}, {}, nil, {}
        for i, s in ipairs(chain) do
            if not turned and been[s.zone] then turned = i end
            if turned then back[#back + 1] = s else outLeg[#outLeg + 1] = s; been[s.zone] = true end
        end
        local lands, landsNew, above = {}, 0, 0
        for i, s in ipairs(outLeg) do
            if i > 1 or startNew then
                lands[#lands + 1] = Place(s.zone)
                if firsts[s.zone] then landsNew = landsNew + 1 end
                local range = A.LoreZoneLevels and A.LoreZoneLevels[s.zone]
                if level and range and range[1] and range[1] >= level + 5 then above = above + 1 end
            end
        end
        local long = #lands >= 3 or (T.BondKind(c.person) ~= "plain" and #lands >= 2 and to - from >= 30 * 60)
        local hard = #distinct >= 2 and #lands >= 1 and landsNew == #lands and (deaths > 0 or above > 0)
        -- (the register: a hard road only when the record holds it, two deaths, or one in lands above you)
        local rough = deaths >= 2 or (deaths >= 1 and above > 0)
        if (long or hard) and quests <= #distinct and to - from <= 3 * 3600 then
            if #lands >= 1 then
                local me, my = teller.base.me, teller.base.my
                local note = ""
                if landsNew == #lands and #lands >= 2 then note = ", all of it new to " .. me
                elseif landsNew == 1 and #lands == 1 then note = ", new to " .. me
                elseif landsNew * 2 >= #lands and landsNew > 0 then note = ", most of it new to " .. me end
                if above > 0 then
                    local which = (above == #lands and #lands >= 2 and "all of it ") or (above < #lands and "some of it ") or ""
                    note = note .. (note == "" and ", " or ", and ") .. which .. "well above " .. my .. " level"
                end
                -- (round 11: a close bond's road says it as the two's: lands neither had seen, country
                -- beyond them; a friend's keeps "new to me ... well above my level")
                if T.BondKind(c.person) == "close" then
                    local we2 = teller.base.I == "I"
                    local either = we2 and "either of us" or "either of you"
                    local them = we2 and "us" or "you both"
                    note = ""
                    if landsNew == #lands and #lands >= 2 then note = ", all of it new to " .. (we2 and "me" or "you")
                    elseif landsNew == 1 and #lands == 1 then note = ", ground new to " .. (we2 and "me" or "you")
                    elseif landsNew * 2 >= #lands and landsNew > 0 then note = ", much of it new to " .. (we2 and "me" or "you") end
                    if above > 0 then
                        local which = (above == #lands and #lands >= 2 and "all of it ") or (above < #lands and "some of it ") or ""
                        note = note .. (note == "" and ", " or ", and ") .. which .. "country far beyond " .. them
                    end
                end
                tokens.from, tokens.lands, tokens.roadNote = Place(chain[1].zone), List(lands), note
                local key = (startNew and "roadOn" or "roadOut") .. ((rough and PB.roadOutHard) and "Hard" or "")
                -- (round 17: others on this road, from the group records over its own time)
                local othersHere = false
                for _, x in ipairs(own) do
                    local self0 = c.person and ((x.d and x.d == c.person.key) or (x.n and Clean(x.n) == Clean(c.person.name or "")))
                    if x.k == "with" and not self0 and (x.t or 0) < to and (x.e or x.t or 0) > from + 60 then othersHere = true end
                end
                teller.crowd = othersHere
                -- (round 12: the way there from the record: a zeppelin, boat or flight that set you down in
                -- the road's first land within ten minutes is said, never "on foot" across a sea)
                local craft
                for _, x in ipairs(own) do
                    if CARRIED[x.k] and x.t and x.t <= chain[1].t + 30 and chain[1].t - x.t <= 10 * 60 then
                        if x.k == "voyage" and (x.d == "zeppelin" or x.d == "boat") then craft = x.d
                        elseif (x.k == "taxi" or x.k == "nightflight") and not craft then craft = "flight" end
                    end
                end
                if craft and #outLeg >= 2 then
                    local rest = {}
                    for i, s in ipairs(outLeg) do if i > 1 then rest[#rest + 1] = Place(s.zone) end end
                    tokens.lands, tokens.craft = List(rest), craft
                    key = craft == "flight" and "roadByFlight" or ((T.BondKind(c.person) == "close" and not teller.crowd and PB.roadByCraftBond) and "roadByCraftBond")
                        or ((T.BondKind(c.person) == "close" and PB.roadByCraftParty) and "roadByCraftParty") or "roadByCraft"
                end
                -- (round 11: a close bond's road is the two side by side, never the friend's sentence)
                if not craft and T.BondKind(c.person) == "close" and not teller.crowd and PB[key .. "Bond"] then key = key .. "Bond"
                elseif not craft and T.BondKind(c.person) == "close" and PB[key .. "Party"] then key = key .. "Party" end
                -- (round 14: a shared journey has its goal: a quest chain the own book names, "where the
                -- trail of notes led", and the chain's own step lines for the work done on the road)
                local chainHit
                local chains = A.SelfWords and A.SelfWords.compose and A.SelfWords.compose.questChains
                for _, ch in ipairs(chains or {}) do
                    local ids = {}
                    for _, id in ipairs(ch.qids or {}) do ids[id] = true end
                    for _, q in ipairs(f.quests or {}) do
                        if q.qid and ids[q.qid] and (q.t or 0) >= from and (q.t or 0) <= to + 60 then chainHit = ch end
                    end
                end
                if chainHit and chainHit.road and T.BondKind(c.person) ~= "plain" then
                    local goal = chainHit.road:gsub("{us}", teller.base.us):gsub("{we}", teller.base.we)
                    tokens.roadNote = (tokens.roadNote or "") .. ", " .. goal
                end
                local line = teller:Say(key, PB[key], rng, tokens)
                -- (the steps in a close bond's book only: the friend's book of the same night keeps the goal,
                -- so the two never say the same sentence)
                -- (round 18: a friend's book closes the trail too, in a line of its own)
                if line and chainHit and chainHit.steps and T.BondKind(c.person) == "friend" then
                    local lastQ
                    for _, q in ipairs(f.quests or {}) do
                        if q.qid and chainHit.steps[q.qid] and (q.t or 0) >= from and (q.t or 0) <= to + 60 and (not lastQ or q.t > lastQ.t) then lastQ = q end
                    end
                    if not lastQ then
                        for _, x in ipairs(own) do
                            if x.k == "quest" and x.qid and chainHit.steps[x.qid] and (x.t or 0) >= from and (x.t or 0) <= to + 60 and (not lastQ or x.t > lastQ.t) then lastQ = x end
                        end
                    end
                    if lastQ then
                        local text = Cap(teller.base.we) .. " followed the notes to their end in " .. Place(lastQ.z or chain[#chain].zone) .. "."
                        NewLine(lines, text, "questKey", lastQ.t, EpisodeAt, S, lastQ.z)
                    end
                end
                if line and chainHit and chainHit.steps and T.BondKind(c.person) == "close" then
                    for _, q in ipairs(f.quests or {}) do
                        local step = q.qid and chainHit.steps[q.qid]
                        if step and (q.t or 0) >= from and (q.t or 0) <= to + 60 then
                            local text = step:gsub("{zone}", Place(q.z or chain[1].zone)):gsub("{we}", teller.base.we):gsub("{We}", Cap(teller.base.we))
                                :gsub("{us}", teller.base.us):gsub("{our}", teller.base.our)
                            text = Cap(text)
                            local done = false
                            for _, l in ipairs(lines) do if l.text == text then done = true end end
                            if not done then NewLine(lines, text, "questKey", q.t, EpisodeAt, S, q.z) end
                        end
                    end
                end
                if line then
                    local open = NewLine(lines, line, "road", from, EpisodeAt, S, chain[1].zone)
                    -- (the firsts of the lands crossed are folded into the setting out, and a line that
                    -- only says how long went to one of them; the chapter's first line too when it is
                    -- no more than that)
                    for _, l in ipairs(lines) do
                        local low = PlainOf(l.text):lower()
                        local short = CountWords(l.text) <= 12 and not l.text:find(teller.base.name, 1, true)
                        local first = FirstTold(low) and not low:find("raise", 1, true) and not low:find(" rose", 1, true)
                        local spent = l.beat == "day" and (short or low:find("spent", 1, true) or low:find(" went to ", 1, true) or low:find(" out for ", 1, true))
                        local meeting = low:find(" met ", 1, true) or low:find("grouped", 1, true) or low:find("went out with", 1, true)
                            or low:find("fell in with", 1, true) or low:find("walked with", 1, true) or low:find("joined", 1, true)
                        local onlyNew = first and not meeting and (low:find("never", 1, true) or low:find("first look", 1, true) or low:find("first time", 1, true))
                        if not l.drop and not l.added and not l.run and not WORK_BEATS[l.beat] and l.beat ~= "close" and l.beat ~= "level" and l.beat ~= "levelMark"
                            and (l.n > 1 or short or onlyNew or (spent and not meeting)) and l.t >= t0 - 60 and l.t <= to and (first or spent) then
                            for zone in pairs(seen) do
                                if PlainOf(l.text):find((Clean(zone):gsub("^The ", "")), 1, true) then l.drop = true end
                            end
                            -- ("never been there": the line's own place)
                            if first and S.Z[l.text] and seen[S.Z[l.text]] and low:find(" there", 1, true) then l.drop = true end
                        end
                    end
                    if #back > 0 and PB.roadBack then
                        local backs = {}
                        for _, s in ipairs(back) do
                            local p = Place(s.zone)
                            if backs[#backs] ~= p then backs[#backs + 1] = p end
                        end
                        tokens.far = Place(outLeg[#outLeg].zone)
                        tokens.span = About(back[1].t - from)
                        local uniq, got = {}, {}
                        for _, p in ipairs(backs) do if not got[p] then got[p] = true; uniq[#uniq + 1] = p end end
                        tokens.backWay = (#backs <= 3 and #uniq == #backs and #backs >= 2 and ("through " .. List({unpack(backs, 1, #backs - 1)}) .. " to " .. backs[#backs]))
                            or ("to " .. backs[#backs])
                        -- (round 13: where work was done in the far land it was no retreat: the plain way back)
                        local farZone, worked = outLeg[#outLeg].zone, false
                        for _, q in ipairs(f.quests or {}) do if q.z == farZone and (q.t or 0) >= from and (q.t or 0) <= to then worked = true end end
                        local backRough = rough and not worked
                        local backPool = (backRough and PB.roadBackHard) or PB.roadBack
                        if T.BondKind(c.person) == "close" and not teller.crowd then backPool = (backRough and PB.roadBackHardBond) or PB.roadBackBond or backPool
                        elseif T.BondKind(c.person) == "close" then backPool = (backRough and PB.roadBackHardParty) or PB.roadBackParty or backPool end
                        local bl = teller:Say("roadBack", backPool, rng, tokens)
                        if bl then NewLine(lines, bl, "road", back[1].t - 0.5, EpisodeAt, S, back[1].zone) end
                    end
                    -- (one paragraph: every kept line of the road's time goes with its setting out)
                    for _, l in ipairs(lines) do
                        local lz = S.Z[l.text]
                        if not l.drop and l.t >= from and l.t <= to + 60 and l.beat ~= "close" and not l.toClose and (not lz or seen[lz] or l.added) then
                            if not l.run then l.ep, l.whole = open.ep, "road" .. from end
                        end
                    end
                end
            end
        end
    end
end
-- The kinds of members ("Scourge", "MAGE") in words: "a Forsaken mage".
local function MemberWho(m)
    local L = A.Lore
    local people = m.r and L and L.People and L.People(m.r)
    local class = m.c and ClassWord(m.c)
    local kind = (people and class and (people .. " " .. class)) or class or people
    return kind and Article(kind) or nil
end
function T.ComposeCompany(c, lines, EpisodeAt, Place)
    local own, S, f, teller, PB, rng, tokens = c.ownJournal, c.S, c.f, c.teller, c.PB, c.rng, c.tokens
    if type(own) ~= "table" or not PB.companyJoin then return end
    local t0, e0 = DayWindow(c.day)
    if e0 <= t0 then return end
    local myName = (Clean(teller.player and teller.player.name or ""):gsub("%-.*$", ""))
    local theirName = (Clean(teller.person and teller.person.name or ""):gsub("%-.*$", ""))
    local strangers, elites = {}, {}
    for _, x in ipairs(own) do
        if x.k == "member" and type(x.n) == "string" and not x.l then
            local short = (Clean(x.n):gsub("%-.*$", ""))
            local a, b = math.max(x.t or 0, t0), math.min(x.e or e0, e0)
            if short ~= "" and short ~= myName and short ~= theirName and b - a >= 60 then
                strangers[#strangers + 1] = {name = short, c = x.c, r = x.r, g = x.g, f = x.f, t = a, e = b}
            end
        elseif x.k == "elites" and (x.t or 0) >= t0 and (x.t or 0) <= e0 then
            elites[#elites + 1] = x
        end
    end
    if T.DebugCompany then T.DebugCompany({t = t0, e = e0, window = true}, #strangers) end
    if #strangers == 0 then return end
    table.sort(strangers, function(a, b) if a.t ~= b.t then return a.t < b.t end return a.name < b.name end)
    -- (the strangers whose times overlap are one company)
    local companies, cur = {}, nil
    for _, s in ipairs(strangers) do
        if cur and s.t <= cur.e then cur[#cur + 1] = s; cur.e = math.max(cur.e, s.e)
        else cur = {s, t = s.t, e = s.e}; companies[#companies + 1] = cur end
    end
    for _, co in ipairs(companies) do
        local count, seconds, named = 0, 0, {}
        for _, x in ipairs(elites) do
            if (x.t or 0) >= co.t - 60 and (x.t or 0) <= co.e then
                count = count + (tonumber(x.c) or 1); seconds = seconds + (tonumber(x.s) or 0)
                for _, n in ipairs(type(x.x) == "table" and x.x or {}) do if type(n) == "string" then named[#named + 1] = n end end
            end
        end
        local dangerous = A.JournalDangerous and A.JournalDangerous(count, seconds) or false
        local deed
        for _, l in ipairs(lines) do
            if not l.drop and not l.added and not l.run and l.n > 1 and (l.beat == "questKey" or l.beat == "quests" or l.beat == "questOutcome" or l.beat == "kills")
                and l.t >= co.t and l.t <= co.e + 120 and (not deed or l.t < deed.t) then deed = l end
        end
        local long = false
        for _, s in ipairs(co) do if s.e - s.t >= (A.JournalMemberSignificant or 600) then long = true end end
        if T.DebugCompany then T.DebugCompany(co, deed, dangerous, long, count, seconds) end
        if deed or dangerous or long then
            -- who: by name (always for a guildmate or a friend), by kind, or as strangers; the same per retell
            local friendly = false
            for _, s in ipairs(co) do if s.g or s.f then friendly = true end end
            local roll = rng()
            local mode = (friendly or roll < 0.4) and "named" or ((#co >= 2 and roll > 0.8) and "plain" or "kind")
            local parts, names = {}, {}
            for _, s in ipairs(co) do
                local kind = MemberWho(s)
                names[#names + 1] = "{n:" .. s.name .. "}"
                if mode == "named" then
                    local tail = (s.g and (" of " .. teller.base.my .. " guild")) or ""
                    parts[#parts + 1] = (s.f and not s.g and (teller.base.my .. " friend {n:" .. s.name .. "}"))
                        or ("{n:" .. s.name .. "}" .. (kind and (", " .. kind .. tail) or tail))
                else
                    parts[#parts + 1] = kind or "one more"
                end
            end
            local who
            if mode == "named" then who = List(parts)
            elseif mode == "plain" then who = (#co == 2 and "a pair of strangers") or (Words(#co) .. " strangers")
            elseif #co == 1 then who = "a stranger, " .. parts[1]
            else who = Words(#co) .. " strangers, " .. List(parts) end
            -- (an apposition closes before the verb: "two strangers, a human paladin and a night elf druid, joined you")
            if mode ~= "plain" and who:find(", ", 1, true) and not (mode == "named" and co[#co].f and not co[#co].g) then who = who .. "," end
            tokens.company, tokens.Company = who, Cap(who)
            local zone
            for _, x in ipairs(own) do if x.k == "play" and x.z and (x.t or 0) <= co.t + 60 then zone = x.z end end
            tokens.place = zone and Place(zone) or tokens.zoneD
            -- (the place once: not again when a kept line before it named it)
            local key0 = zone and Clean(zone):gsub("^[Tt]he ", ""):match("^(%S+)")
            for _, l in ipairs(lines) do if key0 and not l.drop and l.t <= co.t and PlainOf(l.text):find(key0, 1, true) then tokens.place = false end end
            local key = (deed or dangerous) and "companyJoin" or "companyAlong"
            local join = teller:Say(key, PB[key], rng, tokens)
            if join then
                local at = deed and math.min(co.t, deed.t - 1) or co.t
                NewLine(lines, join, "company", at, EpisodeAt, S, zone)
                if dangerous and PB.companyHard then
                    tokens.elite = named[1] and Place(named[1]) or false
                    local pool = (named[1] and PB.companyHardNamed) or PB.companyHard
                    local hard = teller:Say("companyHard", pool, rng, tokens)
                    if hard then NewLine(lines, hard, "company", deed and (deed.t - 0.5) or (co.t + 1), EpisodeAt, S, zone) end
                end
                if (deed or dangerous) and PB.companyPart and PB.companyPartOne then
                    tokens.parted = (mode == "named" and List(names)) or (#co == 1 and "the stranger") or "the strangers"
                    tokens.Parted = Cap(tokens.parted)
                    local pool = (#co == 1 and PB.companyPartOne) or PB.companyPart
                    local part = teller:Say("companyPart", pool, rng, tokens)
                    if part then NewLine(lines, part, "company", math.max(co.e, (deed and deed.t or co.e) + 0.25), EpisodeAt, S, zone) end
                end
            end
        end
    end
end
-- The register (lane C8): how dangerous an episode was, 0 to 3, from the record only (your
-- deaths and the companion's, a bad stretch, lands well above you, a long fight among elites);
-- the episodes' own danger when JournalEpisodes gives one. In an episode at 2 or more a few
-- plain verbs of its lines take the harder word, once a line, two lines at most.
local REGISTER = {{" went into ", " pushed into "}, {" went on through ", " pressed on through "}, {" went on to ", " pushed on to "},
    {" set out ", " struck out "}, {" made your way ", " fought your way "}, {" made our way ", " fought our way "},
    {" made my way ", " fought my way "}, {" turned back ", " fell back "}}
function T.EpisodeDanger(ep, level)
    if type(ep.danger) == "number" then return ep.danger end
    local mine, theirs = ep.mine or 0, ep.theirs or 0
    local d = 0
    if mine >= 1 or theirs >= 2 then d = 1 end
    if mine >= 2 or (mine >= 1 and theirs >= 2) or ep.kind == "deaths" then d = 2 end
    if mine >= 3 or (mine >= 2 and theirs >= 3) then d = 3 end
    local range = ep.zone and A.LoreZoneLevels and A.LoreZoneLevels[ep.zone]
    if d >= 1 and level and range and range[1] and range[1] >= level + 5 then d = math.min(3, d + 1) end
    if ep.dangerous then d = math.max(d, 2) end
    return d
end
function T.ComposeRegister(c, lines, episodes)
    local level = tonumber(c.f and c.f.plStart)
    local changed = {}
    for _, l in ipairs(lines) do
        local ep = l.ep
        if ep and not l.drop and not l.added and l.beat ~= "close" and l.beat ~= "open" then
            ep.registerC = ep.registerC or T.EpisodeDanger(ep, level)
            if ep.registerC >= 2 and (changed[ep] or 0) < 2 then
                for _, swap in ipairs(REGISTER) do
                    local at = l.text:find(swap[1], 1, true)
                    if at then
                        l.text = c.S.Carry(l.text, l.text:sub(1, at - 1) .. swap[2] .. l.text:sub(at + #swap[1]))
                        changed[ep] = (changed[ep] or 0) + 1
                        break
                    end
                end
            end
        end
    end
end
-- The companionship (lane C8): what was shared is told as shared, and the bond on the card
-- colours the telling in its choices, never as a label. In the diary voice a going or a finding
-- done while together is "we" ("I found my way to Deathknell ... while we were out" -> "We found
-- our way to Deathknell ..."). For a spouse, partner or family, the other's fall in the land you
-- were in yourself is "fell at my side" (the record: grouped, the same land at that moment);
-- a friend's stays plain. Nothing is added.
local WE_LEADS = {{"^I found my way ", "We found our way "}, {"^I made my way ", "We made our way "}, {"^I went on to ", "We went on to "},
    {"^I went into ", "We went into "}, {"^I went to ", "We went to "}, {"^I came to ", "We came to "}, {"^I crossed ", "We crossed "}}
local CLOSE_BONDS = {spouse = true, partner = true, family = true}
function T.ComposeBond(c, lines)
    local teller, S = c.teller, c.S
    local we = teller.base.I == "I"
    local name = teller.base.name
    local close = CLOSE_BONDS[(c.person and c.person.bond) or ""]
    for _, l in ipairs(lines) do
        if not l.drop and l.beat ~= "close" then
            if we then
                for _, lead in ipairs(WE_LEADS) do
                    if l.text:find(lead[1]) and not l.text:find("killed", 1, true) and not l.text:find("died", 1, true) then
                        local text = l.text:gsub(lead[1], lead[2], 1):gsub(" while we were out%.$", "."):gsub(" while we were out,", ",")
                        text = text:gsub("%f[%a]my%f[%A]", "our")
                        l.text = S.Carry(l.text, text)
                        break
                    end
                end
            end
            local e = S.D[l.text]
            if close and l.beat == "death" and e and e.w ~= "you" and type(c.ownJournal) == "table" then
                -- (the land you were in yourself at that moment, from your own book)
                local here
                for _, x in ipairs(c.ownJournal) do if x.k == "play" and x.z and (x.t or 0) <= (e.t or 0) and (x.e or x.t or 0) >= (e.t or 0) then here = x.z end end
                local plain = PlainOf(l.text)
                local who = PlainOf(name)
                local place = l.text:match("{p:([^}]+)}")
                if here and place and Clean(place) == Clean(here) then
                    local mine = we and "my" or "your"
                    for _, pat in ipairs({"^" .. who .. " died in [^,%.]+%.$", "^" .. who .. " was killed in [^,%.]+%.$", "^In [^,]+, " .. who .. " died%.$"}) do
                        if plain:find(pat) then
                            l.text = S.Carry(l.text, name .. " fell at " .. mine .. " side in {p:" .. Clean(place) .. "}.")
                            break
                        end
                    end
                end
            end
        end
    end
end
-- The shared story (lane C9, 2026-11-12; the player: "more focus on we, on the kind of
-- relationship, on the companionship and shared adventure"). What the two did together is the
-- spine, and the bond on the card colours the choices, never as a label. Nothing is added that the
-- record lacks: the first steps together (both at level one or two on the first day), levels gained
-- side by side, days in a row, a first seen together, a fire after a fall or at the end of the night,
-- the companion's place in a scene ("Dahlia was with me when I spoke with Lady Sylvanas"), the party
-- words said as people ("Dahlia and I were out together again", not "was in the party again"), a
-- list of places cut to where the day went first. T.ComposeTogether works on the lines before the
-- order; T.ComposeTogetherAfter on the ordered chapter (two firsts in a row said once).
local function Esc(s) return (tostring(s or ""):gsub("[%^%$%(%)%%%.%[%]%*%+%-%?]", "%%%0")) end
function T.BondKind(person)
    local bond = person and person.bond or ""
    if CLOSE_BONDS[bond] then return "close" end
    if bond == "friend" then return "friend" end
    return "plain"
end
local RACE_START = {Scourge = "Tirisfal Glades", Human = "Elwynn Forest", Dwarf = "Dun Morogh", Gnome = "Dun Morogh", NightElf = "Teldrassil",
    Orc = "Durotar", Troll = "Durotar", Tauren = "Mulgore"}
-- Both at level one or two at the first levels of the first day: the two began the world together.
local function StartedTogether(day)
    local mine, theirs
    for _, scene in ipairs(day and day.scenes or {}) do
        for _, e in ipairs(scene.entries or {}) do
            if e.k == "level" and not theirs then theirs = tonumber(e.d) end
            if e.k == "mylevel" and not mine then mine = tonumber(e.d) end
        end
    end
    return mine and theirs and mine <= 3 and theirs <= 3
end
-- Every level of the day gained within ten minutes of the other's (three levels at least).
local function Lockstep(day)
    local mine, theirs = {}, {}
    for _, scene in ipairs(day and day.scenes or {}) do
        for _, e in ipairs(scene.entries or {}) do
            local n = tonumber(e.d)
            if n and e.t and e.k == "level" then theirs[n] = e.t end
            if n and e.t and e.k == "mylevel" then mine[n] = e.t end
        end
    end
    local shared = 0
    for n, t in pairs(mine) do
        if not theirs[n] or math.abs(theirs[n] - t) > 10 * 60 then return false end
        shared = shared + 1
    end
    for n in pairs(theirs) do if not mine[n] then return false end end
    return shared >= 3
end
-- A first told as the two's (round 10). {ours}: they began together, so the first is both of
-- theirs; else "saw it together". Returns the text unchanged when it says no first.
function T.Ours(text, we, name, ours, history)
    local N = Esc(name)
    local new = text
    -- (the clause that made her a witness goes first)
    new = new:gsub(", and " .. N .. " was there for it", ""):gsub(", and " .. N .. " was there with [%a]+", "")
        :gsub(", with " .. N .. " beside [%a]+", ""):gsub(", and " .. N .. " was with [%a]+ for it", ""):gsub(", and " .. N .. " saw it with [%a]+", "")
    local stripped = new ~= text
    if ours then
        if we then
            new = new:gsub(" were both new ground to me", " were new ground to us both")
            new = new:gsub(" new to me that day", " new to us both that day"):gsub(" new ground to me%f[%A]", " new ground to us both")
                :gsub("^It was my first time in (.-)%.$", "It was the first time either of us had been in %1.")
                :gsub("^I had never set foot in (.-) before that day%.$", "Neither of us had set foot in %1 before that day.")
                :gsub("^Until that day I had never been in (.-)%.$", "Until that day neither of us had been in %1.")
                :gsub(" where I had never set foot", " where neither of us had set foot")
                :gsub("all of it new to me", "all of it new to us both"):gsub(", my first time there", ", the first time for both of us")
                :gsub("^That was the day I first saw ", "That was the day we first saw ")
                :gsub(" well above my level", " well above us")
        else
            new = new:gsub(" were both new ground to you%f[%A]", " were new ground to you both")
            new = new:gsub(" new to you that day", " new to you both that day"):gsub(" new ground to you%f[%A]", " new ground to you both")
                :gsub("^It was your first time in (.-)%.$", "It was the first time either of you had been in %1.")
                :gsub("^You had never set foot in (.-) before that day%.$", "Neither of you had set foot in %1 before that day.")
                :gsub("^Until that day you had never been in (.-)%.$", "Until that day neither of you had been in %1.")
                :gsub(" where you had never set foot", " where neither of you had set foot")
                :gsub("all of it new to you%f[%A]", "all of it new to you both"):gsub(", your first time there", ", the first time for you both")
                :gsub("^That was the day you first saw ", "That was the day you both first saw ")
                :gsub(" well above your level", " well above you both")
            new = new:gsub("you both both", "you both")
        end
    elseif stripped or (not text:find(N) and FirstTold(PlainOf(text):lower()) and CountWords(text) <= 14 and text:find("{p:", 1, true)
        and text:sub(-1) == "." and not text:find(",", 1, true)) then
        -- (the place was new to me, and we saw it together: the record shows my first, not hers)
        -- (said three ways in turn across the book, never the same clause every time)
        local nth = 1
        if history then history.sharedFirstN = (history.sharedFirstN or 0) + 1; nth = history.sharedFirstN end
        local pair = we and (name .. " and I") or ("you and " .. name)
        local ways = {", and " .. pair .. " saw it together", ", and " .. (we and "we" or "you") .. " took it in side by side",
            ", and " .. (we and "we" or "you") .. " went there together"}
        -- (round 17: said once a book; after that the first is plainly mine)
        if nth == 1 then new = new:sub(1, -2) .. ways[1] .. "."
        else
            -- (after that a first of mine in the words of this book, never the friend's sentence)
            local at, place = new:match("()({p:[^}]+})")
            if place then
                if new:sub(math.max(1, at - 4), at - 1):lower() == "the " then place = "the " .. place end
                local forms = {(we and "I" or "You") .. " had not been in " .. place .. " before that night.",
                    Cap(place) .. " was strange country to " .. (we and "me" or "you") .. " then.",
                    (we and "I" or "You") .. " had never yet set foot in " .. place .. "."}
                new = forms[(nth - 2) % #forms + 1]
            end
        end
    end
    return new
end
-- The falls of one stretch (the same episode, each within forty minutes of the last), told once
-- (round 10): the one that matters to the two (a raise between them, a fall together, else the
-- first), the rest folded into it; never a chain of "killed me / fell too / raised me".
local function FoldDeaths(c, lines, Live)
    local teller, PB, rng, tokens = c.teller, c.PB, c.rng, c.tokens or {}
    local name = teller.base.name
    local groups, cur = {}, nil
    local deaths = {}
    for _, l in ipairs(lines) do if Live(l) and l.beat == "death" and not l.run and l.t then deaths[#deaths + 1] = l end end
    table.sort(deaths, function(a, b) return a.t < b.t end)
    -- (round 28: a stretch ends where something else was told between two falls)
    local function Between(t1, t2)
        for _, o in ipairs(lines) do
            if Live(o) and o.t and o.beat ~= "death" and o.beat ~= "rez" and o.t > t1 + 30 and o.t < t2 - 30 then return true end
        end
        return false
    end
    for _, l in ipairs(deaths) do
        if not cur or cur.ep ~= l.ep or l.t - cur.last > 40 * 60 or Between(cur.last, l.t) then cur = {ep = l.ep, last = l.t, lines = {}}; groups[#groups + 1] = cur end
        cur.lines[#cur.lines + 1] = l
        cur.last = l.t
    end
    local friend = T.BondKind(c.person) == "friend"
    local function Rank(l)
        local low = PlainOf(l.text):lower()
        if low:find("ever raised", 1, true) or low:find(" rose", 1, true) then return 4 end
        -- (round 12: a friend's book tells the friend's own falls; they come before his raising me)
        local nm = PlainOf(name):lower()
        if friend and low:find(" again", 1, true) then return 1.5 end
        if friend and (low:find("^" .. nm .. " died") or low:find("^" .. nm .. " fell") or low:find("^" .. nm .. " was killed")
            or low:find(", " .. nm .. " died", 1, true) or low:find(nm .. " died twice", 1, true) or low:find(nm .. " went down", 1, true)) then return 3.5 end
        if l.text:find(name .. " raised", 1, true) or l.text:find(name .. " brought", 1, true) or l.text:find(name .. "'s prayers", 1, true)
            or l.text:find(name .. " prayed", 1, true) or l.text:find(name .. " would not", 1, true) then return 3 end
        if l.text:find(name, 1, true) and (low:find(" with me", 1, true) or low:find(" with you", 1, true) or low:find("fell too", 1, true)
            or low:find("fell with", 1, true) or low:find(" with her", 1, true) or low:find(" with him", 1, true)) then return 2 end
        return 1
    end
    for _, g in ipairs(groups) do
        if #g.lines >= 2 then
            local keep = g.lines[1]
            for _, l in ipairs(g.lines) do if Rank(l) > Rank(keep) then keep = l end end
            -- (a friend's book keeps his raising me beside his own fall: comradeship both ways)
            local also
            if friend then for _, l in ipairs(g.lines) do if l ~= keep and Rank(l) == 3 and not also then also = l end end end
            -- (round 16: the wipe and its cost are told: beside the raise, the fall together stays)
            if not also and Rank(keep) >= 3 then for _, l in ipairs(g.lines) do if l ~= keep and Rank(l) == 2 and not also then also = l end end end
            -- (round 22: in a stretch of four falls or more, a close bond's book tells one more of hers, at its
            -- own time, so her falls are in it without a tally)
            local more
            if T.BondKind(c.person) == "close" and #g.lines >= 3 then
                for _, l in ipairs(g.lines) do
                    if l ~= keep and l ~= also and not more and l.text:find(name, 1, true) then more = l end
                end
            end
            local later = false
            -- (round 27: a bonded book never drops a line that tells the companion's own fall: her falls are
            -- counted exactly from her journal, every one or none, never an undercount)
            local bonded = T.BondKind(c.person) ~= "plain"
            local function TellsHers(l)
                local low = PlainOf(l.text):lower()
                local nm = PlainOf(name):lower()
                if not low:find(nm, 1, true) then return false end
                return low:find(nm .. " fell", 1, true) or low:find(nm .. " died", 1, true) or low:find(nm .. " was killed", 1, true)
                    or low:find(nm .. " went down", 1, true) or low:find(nm .. " with me", 1, true) or low:find(nm .. " with you", 1, true)
                    or low:find("killed " .. nm, 1, true) or false
            end
            local function TellsHersOrPronoun(l)
                if TellsHers(l) then return true end
                local low = PlainOf(l.text):lower()
                return low:find("^she went down", 1) or low:find("^he went down", 1) or low:find(" with her%.") or low:find(" with him%.") or false
            end
            for _, l in ipairs(g.lines) do
                if l ~= keep and l ~= also and l ~= more then l.drop = true; if l.t > keep.t then later = true end end
            end
            -- (round 28: in a bonded book a stretch with her falls in it is one sentence, its cause and place,
            -- its counts exact from her journal: "The Rot Hides on Fenris Isle killed Dahlia twice and me three
            -- times." A first raise keeps its own sentence, and the stretch tells what came after it.)
            local hersTold = false
            for _, l in ipairs(g.lines) do if TellsHersOrPronoun(l) then hersTold = true end end
            if bonded and hersTold then
                local raise
                for _, l in ipairs(g.lines) do if Rank(l) >= 4 then raise = l end end
                local from = raise and raise.t + 30 or g.lines[1].t - 60
                -- (round 29: the stretch runs to the next thing told, five minutes at most: a fall two minutes
                -- after the last line's is in it, and the count is exact)
                local to = g.last + 5 * 60
                for _, o in ipairs(lines) do
                    if Live(o) and o.t and o.beat ~= "death" and o.beat ~= "rez" and o.t > g.last + 30 and o.t < to then to = o.t - 1 end
                end
                for _, o in ipairs(lines) do
                    if not raise and Live(o) and o.t and o.beat ~= "death" and o.beat ~= "rez" and o.t < g.lines[1].t - 30 and o.t > from then from = o.t + 1 end
                end
                local mine, hers, zones, zoneSeen, killers, subs = 0, 0, {}, {}, {}, {}
                for _, x in ipairs((c.f and c.f.deaths) or {}) do
                    if x.t and x.t >= from and x.t <= to then
                        if x.w == "you" then
                            mine = mine + 1
                            if x.d then killers[#killers + 1] = x.d end
                        else hers = hers + 1 end
                        local z = x.z and Clean(x.z)
                        if z and not zoneSeen[z] then zoneSeen[z] = true; zones[#zones + 1] = z end
                        subs[#subs + 1] = x.sz or false
                    end
                end
                local Times = function(n) return n == 1 and "once" or n == 2 and "twice" or (Words(n) .. " times") end
                local More = function(n) return n == 1 and "once more" or n == 2 and "twice more" or (Words(n) .. " more times") end
                local function Zone(z)
                    local the = (z:find("s$") or z:find("^Barrens")) and not z:find("^%u%l+'s") and "the " or ""
                    return the .. "{p:" .. z .. "}"
                end
                if hers > 0 then
                    local place
                    if #zones == 1 then place = "in " .. Zone(zones[1])
                    elseif #zones == 2 then place = "in " .. Zone(zones[1]) .. " and " .. Zone(zones[2])
                    elseif #zones > 2 then
                        local ps = {}
                        for _, z in ipairs(zones) do ps[#ps + 1] = Zone(z) end
                        place = "on the road through " .. table.concat(ps, ", ", 1, #ps - 1) .. " and " .. ps[#ps]
                    end
                    local cause
                    -- (a cause only when one kind killed us all through it: never one foe's name on her falls)
                    if #killers >= 2 and A.FoeFamily then
                        local ok, fam = pcall(A.FoeFamily, killers, {})
                        if ok and type(fam) == "string" then cause = fam end
                    end
                    local b = teller.base
                    local me, I = b.me, b.I
                    local HT = raise and More or Times
                    local nm = name
                    local text
                    local lead = Cap((place and (place .. ", ") or ""))
                    if cause and mine > 0 then
                        text = Cap(cause) .. (place and (" " .. place) or "") .. " killed " .. nm .. " " .. HT(hers) .. " and " .. me .. " " .. Times(mine) .. "."
                    elseif mine > 0 and mine == hers and not raise and friend and place then
                        -- (a friend's book says it from the two of them first, never the close book's words)
                        text = nm .. " and " .. I .. " went down " .. Times(hers) .. " apiece " .. place .. "."
                        if hers == 1 then text = nm .. " and " .. I .. " both went down " .. place .. "." end
                    elseif mine > 0 and mine == hers and not raise then
                        text = lead .. nm .. " and " .. I .. " fell " .. Times(hers) .. " each."
                        if hers == 1 then text = lead .. nm .. " and " .. I .. " both fell." end
                    elseif mine > 0 then
                        text = lead .. nm .. " fell " .. HT(hers) .. ", and " .. I .. " " .. Times(mine) .. "."
                    else
                        text = lead .. nm .. " fell " .. HT(hers) .. "."
                    end
                    if raise then text = "Then " .. text:gsub("^%u", string.lower) end
                    -- (who raised me in it, from the record: "and Marrow's prayers brought me back")
                    local by = {}
                    -- (my own record's raises too: "by=Marrow Rotmoor")
                    local raises = {}
                    for rt, who in pairs((c.f and c.f.rezBy) or {}) do raises[#raises + 1] = {t = rt, by = who} end
                    for _, x in ipairs(c.ownJournal or {}) do if x.k == "rez" and x.by and x.t then raises[#raises + 1] = {t = x.t, by = Clean(x.by)} end end
                    for _, r in ipairs(raises) do
                        local rt, who = r.t, r.by
                        if type(rt) == "number" and rt >= from and rt <= to + 60 then
                            local first = tostring(who):match("^(%S+)")
                            -- (only one of the party: a stranger's raise has its own line)
                            local inParty = first and first:lower() == PlainOf(name):lower()
                            for _, x2 in ipairs(c.ownJournal or {}) do
                                if first and x2.k == "with" and x2.n and (Clean(x2.n):gsub("%-.*$", "")):lower() == first:lower() and (x2.t or 0) <= rt and (x2.e or x2.t or 0) >= rt then inParty = true end
                            end
                            if first and inParty and not by[first] then by[first] = true; by[#by + 1] = first end
                        end
                    end
                    if #by == 1 and by[1]:lower() == PlainOf(name):lower() and friend then
                        text = text:sub(1, -2) .. ", and " .. (teller.base.they or "they") .. " brought " .. me .. " back."
                    elseif #by == 1 and not friend then text = text .. " {n:" .. by[1] .. "} raised " .. me .. "."
                    elseif #by == 1 then text = text:sub(1, -2) .. ", and {n:" .. by[1] .. "} brought " .. me .. " back." end
                    -- (the line it stands in: the stretch's first fall, or the raise's next line)
                    local host
                    -- (told where the stretch ended: nothing in it comes before a line told earlier)
                    for _, l in ipairs(g.lines) do if l ~= raise and (not host or l.t > host.t) then host = l end end
                    for _, l in ipairs(g.lines) do if l ~= raise and l ~= host then l.drop = true end end
                    if host then host.drop = nil; host.text = c.S.Carry(host.text, text); g.stretch = host end
                end
            end
            -- (round 21: the night's worst stretch keeps the companion's falls in it: one danger sentence,
            -- "It was the worst of the night: Dahlia fell three times on that road, and I four.", no colon)
            g.mine, g.hers = 0, 0
            for _, x in ipairs((c.f and c.f.deaths) or {}) do
                if x.t and x.t >= g.lines[1].t - 60 and x.t <= g.last + 60 then
                    if x.w == "you" then g.mine = g.mine + 1 else g.hers = g.hers + 1 end
                end
            end
            g.keep = keep
            if later and PB.fallMore and keep.text:sub(-1) == "." and Rank(keep) < 3 and not g.stretch and not keep.drop then
                local clause = teller:Say("fallMore", PB.fallMore, rng, tokens)
                if clause then keep.text = c.S.Carry(keep.text, keep.text:sub(1, -2) .. clause .. ".") end
            end
        end
    end
end
T.FoldDeaths = function(c, lines, Live)
    FoldDeaths(c, lines, Live)
end
-- (round 21) After the folding: the worst stretch of the night, three falls or more with hers among
-- them, says how many of hers there were, beside the fall kept.
function T.WorstStretch(c, lines, Live)
    local f, teller = c.f or {}, c.teller
    local name = teller.base.name
    local groups, cur = {}, nil
    local ds = {}
    for _, x in ipairs(f.deaths or {}) do if x.t then ds[#ds + 1] = x end end
    table.sort(ds, function(a, b) return a.t < b.t end)
    for _, x in ipairs(ds) do
        if not cur or x.t - cur.last > 40 * 60 then cur = {t = x.t, last = x.t, mine = 0, hers = 0}; groups[#groups + 1] = cur end
        cur.last = x.t
        if x.w == "you" then cur.mine = cur.mine + 1 else cur.hers = cur.hers + 1 end
    end
    local worst
    for _, g in ipairs(groups) do if g.mine + g.hers >= 3 and g.hers >= 2 and (not worst or g.mine + g.hers > worst.mine + worst.hers) then worst = g end end
    if not worst then return end
    -- (the kept fall of that stretch: the danger sentence goes before it)
    local kept
    for _, l in ipairs(lines) do if Live(l) and l.beat == "death" and l.t and l.t >= worst.t - 60 and l.t <= worst.last + 60 then kept = kept or l end end
    for _, l in ipairs(lines) do if Live(l) and (PlainOf(l.text):find("worst of the", 1, true) or PlainOf(l.text):find(" fell %a+ times? in it")) then return end end
    if not kept then return end
    local we = teller.base.I == "I"
    local function Times(n) return n == 1 and "once" or n == 2 and "twice" or (Words(n) .. " times") end
    local history = c.history or {}
    history.worstN = (history.worstN or 0) + 1
    local heads = {"It was the worst of the " .. PartOf(Hour(worst.t)) .. ".", "That stretch went hard for us.", "Nothing came easy there."}
    local head = heads[(history.worstN - 1) % #heads + 1]
    local text = head .. " " .. name .. " fell " .. Times(worst.hers) .. " in it, and " .. (we and "I" or "you") .. " " .. Times(worst.mine) .. "."
    if worst.mine == 0 then text = head .. " " .. name .. " fell " .. Times(worst.hers) .. " in it." end
    c.S.Z[text] = c.S.Z[kept.text]
    lines[#lines + 1] = {n = kept.n - 0.5, text = text, beat = "death", t = kept.t - 1, ep = kept.ep, added = true}
end
-- The own book's told text of each day (round 15): the player's own book, told once and kept, its
-- composed lines captured as they leave the own composer. Read only: the own book is told as it
-- would be, and nothing of it is changed. Returns {dayKey = "all the day's text"} or nil.
local ownCache = {}
function T.OwnTold(charKey)
    if not (A.SelfPerson and A.SelfTale and A.SelfTale.Tell and A.JournalBook and A.SelfCompose and A.SelfCompose.Apply) then return nil end
    local me = A.SelfPerson(charKey)
    if not me then return nil end
    -- (1.43.1: the own book's days are read once per telling of a companion book, not once a chapter;
    -- T.ownKeys lives only while T.Tell runs)
    local key = T.ownKeys and T.ownKeys[charKey]
    if key and ownCache[key] then return ownCache[key] end
    local days = A.JournalBook(me)
    local last = days[#days]
    key = tostring(charKey) .. ":" .. #days .. ":" .. tostring(last and last.key) .. ":" .. tostring(#(me.journal or {}))
    if T.ownKeys then T.ownKeys[charKey] = key end
    if ownCache[key] then return ownCache[key] end
    if T.ownBusy then return nil end
    T.ownBusy = true
    local told = {}
    local Apply = A.SelfCompose.Apply
    A.SelfCompose.Apply = function(ctx)
        local r = Apply(ctx)
        if ctx and ctx.day and ctx.day.key and ctx.out then
            told[ctx.day.key] = (told[ctx.day.key] and (told[ctx.day.key] .. " ") or "") .. PlainOf(table.concat(ctx.out, " "))
        end
        return r
    end
    local ok = pcall(A.SelfTale.Tell, me, days, false, 0)
    A.SelfCompose.Apply = Apply
    T.ownBusy = false
    if not ok then return nil end
    ownCache = {[key] = told}
    return told
end
-- The words of a sentence that carry its matter (five letters or more, no names): for telling
-- whether the own book told a quest's moment.
local function MatterWords(text)
    local out, n = {}, 0
    for at, w in PlainOf(text):gmatch("()([%a']+)") do
        if #w >= 5 and w:match("^%l") then out[w] = true; n = n + 1 end
    end
    return out, n
end
-- (round 15) The spine from the own book: each quest of the companion's record that the own book
-- told that night, and this chapter does not, is told here in the companion's own words (the other
-- point-of-view line of the two, never the own book's sentence), at its time, in its episode.
function T.OwnSpine(c, lines, Live)
    local teller, S, f = c.teller, c.S, c.f or {}
    local QD = A.QuestDeeds
    if not (QD and QD.Story and QD.Moment) then return end
    local charKey = (teller.player and teller.player.charKey) or (A.Me and A.Me())
    local told = charKey and T.OwnTold(charKey)
    local own = told and c.day and told[c.day.key]
    if not own or own == "" then return end
    local ownWords = MatterWords(own)
    local here = {}
    for _, l in ipairs(lines) do if Live(l) then here[#here + 1] = l.text end end
    local hereWords = MatterWords(table.concat(here, " "))
    local b = teller.base
    local tok = {We = Cap(b.we), we = b.we, us = b.us, our = b.our, Our = Cap(b.our), I = b.I, me = b.me, my = b.my, My = Cap(b.my)}
    local added, seen = 0, {}
    -- (the work of the night while the companion was in the group: the companion's record, and the
    -- player's own record inside the companion's outings, where the companion's record kept less)
    local qs, have = {}, {}
    -- (round 16: only work done while the group was together, inside an outing; a hand-in before she
    -- joined, "the Engraved Ring at 21:33, Dahlia at 21:51", is not "we")
    local function Inside(t)
        for _, scene in ipairs(c.day and c.day.scenes or {}) do
            if scene.kind == "outing" and t and t >= (scene.t or 0) - 30 and t <= (scene.e or scene.t or 0) + 30 then return true end
        end
        return false
    end
    for _, q in ipairs(f.quests) do if Inside(q.t) then qs[#qs + 1] = q; have[QD.Key(q)] = true end end
    for _, scene in ipairs(c.day and c.day.scenes or {}) do
        if scene.kind == "outing" then
            for _, x in ipairs(c.ownJournal or {}) do
                if x.k == "quest" and x.d and x.t and x.t >= (scene.t or 0) and x.t <= (scene.e or scene.t or 0) then
                    local q = {title = x.d, qid = x.qid, t = x.t, z = x.z, ql = x.ql}
                    -- (round 29: "we" only where the companion's own record does not contradict it: when her
                    -- record holds hand-ins of its own within the half hour around mine and not this one, it was mine)
                    local hers, near = false, false
                    for _, y in ipairs(c.person and type(c.person.journal) == "table" and c.person.journal or {}) do
                        if y.k == "quest" and y.t and math.abs(y.t - x.t) <= 30 * 60 then
                            near = true
                            if (y.qid and x.qid and tonumber(y.qid) == tonumber(x.qid)) or (y.d and y.d == x.d) then hers = true end
                        end
                    end
                    if near and not hers then have[QD.Key(q)] = true end
                    if not have[QD.Key(q)] then have[QD.Key(q)] = true; qs[#qs + 1] = q end
                end
            end
        end
    end
    table.sort(qs, function(a, b2) return (a.t or 0) < (b2.t or 0) end)
    -- (the names of a moment are the ones no other quest of the night speaks of: "Nightlash", never
    -- "Lady" or "Scarlet")
    local nameCount = {}
    local function NamesOf(text)
        local out = {}
        for at, w in text:gmatch("()(%u[%a']+)") do
            if not text:sub(at + #w):match("^%s+%u") and at > 1 and not text:sub(math.max(1, at - 2), at - 1):find("[%.!?] ?$") and #w >= 5 then out[w] = true end
        end
        return out
    end
    for _, q in ipairs(qs) do
        local st = QD.Story(q)
        local seenQ = {}
        for _, v in ipairs(st and st.pov or {}) do
            for w in pairs(NamesOf(PlainOf(QD.Fill(v, tok)))) do if not seenQ[w] then seenQ[w] = true; nameCount[w] = (nameCount[w] or 0) + 1 end end
        end
    end
    for _, q in ipairs(qs) do
        local story = QD.Story(q)
        local pov = story and story.pov
        local key = QD.Key(q)
        if pov and #pov > 0 and not seen[key] and (added < 7 or (T.needs and q.qid and T.needs[q.qid])) then
            seen[key] = true
            -- (the own book told it: most of one of its two lines' matter is in the own night's text)
            local ownTold, hereTold, forceTell, useAct = false, false, false, false
            -- (round 26: the thread's set-up came on a night the companion was not in the group: the
            -- deed alone, or nothing; never Raleigh's words she never heard)
            local setupAway = false
            for _, v in ipairs(pov) do
                local w, n = MatterWords(QD.Fill(v, tok))
                local inOwn, inHere = 0, 0
                for x in pairs(w) do if ownWords[x] then inOwn = inOwn + 1 end; if hereWords[x] then inHere = inHere + 1 end end
                if n >= 4 and inOwn / n >= 0.45 then ownTold = true end
                -- (round 21: a step of a thread the two were on is told even when the own book folded it:
                -- the ichor Bethor read, the crate back to Podrig; a later line of the book uses it)
                if story.thread and T.SPINE_ALL_THREADS then ownTold = true end
                if n >= 4 and inHere / n >= 0.4 then hereTold = true end
            end
            for line, quest in pairs(S.Q or {}) do if quest == q then for _, x in ipairs(here) do if x == line then hereTold = true end end end end
            -- (round 16: or a name of its own in the own night's text: the own book told it in its words)
            local ownPlain = own
            for _, v in ipairs(pov) do
                for w in pairs(NamesOf(PlainOf(QD.Fill(v, tok)))) do
                    if nameCount[w] == 1 and ownPlain:find("%f[%a]" .. w .. "%f[%A]") then ownTold = true end
                end
            end
            -- (a name of its own, not the giver's, already in a line of work here: "destroyed the banshee
            -- Nightlash" in a list tells the Nightlash moment)
            local giver = QD.Giver and QD.Giver(story)
            local herePlain = PlainOf(table.concat(here, " "))
            for _, v in ipairs(pov) do
                local filled = PlainOf(QD.Fill(v, tok))
                -- (the last word of each run of capitalized words: "Captain Perrine" -> Perrine; titles go)
                for w in pairs(NamesOf(filled)) do
                    if nameCount[w] == 1 and not (giver and tostring(giver):find(w, 1, true))
                        and not (A.Lore and A.Lore.LorePlace and A.Lore.LorePlace(w)) and herePlain:find("%f[%a]" .. w .. "%f[%A]") then
                        -- (a place is no name of the moment: a land or town is in many lines)
                        local isPlace = false
                        for z in pairs(A.LoreZoneLevels or {}) do if z:find(w, 1, true) then isPlace = true end end
                        if not isPlace then
                            hereTold = true
                            -- (round 21: when the name is only a clause of a list line, "then killed Valdred at the
                            -- Greymane Wall", the clause leaves the list and the quest's own scene closes the thread)
                            if story.thread and T.BondKind(c.person) == "close" then
                                for _, l in ipairs(lines) do
                                    if Live(l) and not l.run and (l.beat == "quests" or l.beat == "questKey") and PlainOf(l.text):find("%f[%a]" .. w .. "%f[%A]") then
                                        local head, rest = l.text:match("^(.-), then ([^,]-" .. w .. "[^,]-)%.$")
                                        if head and rest and head:find("%a$") and (head:find("^%a*%s?[Ww]e ") or head:find("^%a*%s?[Yy]ou ")) then
                                            l.text = S.Carry(l.text, head .. ".")
                                            hereTold = false
                                            forceTell = true
                                        end
                                    end
                                end
                            end
                        end
                    end
                end
            end
            -- (round 18: the same deed in other words, "We cleared the Scourge from Balnir Farmstead" and
            -- "We cleared the haven they had made at Balnir Farmstead", is one deed)
            if ownTold and not hereTold then
                for _, v in ipairs(pov) do
                    local first = PlainOf(QD.Fill(v, tok))
                    for _, x in ipairs(here) do
                        local xp = PlainOf(x)
                        for w in first:gmatch("%u[%a']+") do
                            if #w >= 5 and xp:find("%f[%a]" .. w .. "%f[%A]") then
                                for vb in first:gmatch("%f[%a][Ww]e (%l+ed)%f[%A]") do
                                    if #vb >= 5 and xp:find("%f[%a]" .. vb .. "%f[%A]") then hereTold = true end
                                end
                            end
                        end
                    end
                end
            end
            if forceTell then ownTold, hereTold = true, false end
            -- (round 24: a small thread, three steps or fewer, whose later step the record never holds,
            -- is not opened: "Migi's lunch" collected and never delivered)
            if ownTold and not forceTell and story.thread and A.Lore and A.Lore.questStoryIDs then
                local steps, later = 0, {}
                for id, st2 in pairs(A.Lore.questStoryIDs) do
                    if st2.thread == story.thread then
                        steps = steps + 1
                        if (st2.level or 0) >= (story.level or 0) and id ~= tonumber(q.qid) then later[#later + 1] = id end
                    end
                end
                if steps <= 3 and #later > 0 then
                    local done = false
                    for _, x in ipairs(c.ownJournal or {}) do
                        if x.k == "quest" then for _, id in ipairs(later) do if tonumber(x.qid) == id then done = true end end end
                    end
                    if not done then ownTold = false end
                end
            end
            -- (round 23: a setup the book's payoffs need, chosen by the first pass)
            local needed = T.needs and q.qid and T.needs[q.qid]
            if needed and not hereTold then ownTold, forceTell = true, true end
            -- (round 22: presence per scene. The quest's authored scene tells the earlier step of its thread
            -- too, "We slipped the pendant out of the crate", "We learned that Thule still lived"; when that
            -- step was done while the companion was not in the group, the scene is not theirs)
            if ownTold and not hereTold and story.thread and c.person and type(c.person.journal) == "table" then
                local function Present(t)
                    for _, x in ipairs(c.person.journal) do
                        if x.k == "group" and x.t and t >= x.t - 60 and t <= (x.e or x.t) + 60 then return true end
                    end
                    return false
                end
                for _, x in ipairs(c.ownJournal or {}) do
                    if x.k == "quest" and x.t and q.t and x.t < q.t and x.qid ~= q.qid then
                        local st2 = QD.Story({title = x.d, qid = x.qid})
                        if st2 and st2.thread == story.thread and not Present(x.t) then
                            -- (only the step just before this one: the scene retells that step)
                            local between = false
                            for _, y in ipairs(c.ownJournal or {}) do
                                if y.k == "quest" and y.t and y.t > x.t and y.t < q.t then
                                    local st3 = QD.Story({title = y.d, qid = y.qid})
                                    if st3 and st3.thread == story.thread then between = true end
                                end
                            end
                            -- (the step told inside this scene: within the hour before, or on a night before)
                            local dayStart0 = math.huge
                            for _, sc in ipairs(c.day and c.day.scenes or {}) do if sc.t and sc.t < dayStart0 then dayStart0 = sc.t end end
                            -- (within the hour the scene is the missed step itself: left out; a step of a night
                            -- before is only its background: this night's act is told instead)
                            if not between and q.t - x.t <= 3600 then ownTold = false
                            elseif not between and x.t < dayStart0 then
                                setupAway = true
                                -- (only when the scene speaks of that step: its giver is named in it, "Bethor knew ...")
                                local g2 = QD.Giver and QD.Giver(st2)
                                local last = g2 and tostring(g2):match("(%S+)$")
                                local giver0 = QD.Giver and QD.Giver(story)
                                if last and #last >= 4 and not (giver0 and tostring(giver0):find(last, 1, true)) then
                                    for _, v in ipairs(pov) do if PlainOf(QD.Fill(v, tok)):find(last, 1, true) then useAct = true end end
                                end
                            end
                        end
                    end
                end
            end
            if ownTold and not hereTold then
                local e = {quest = q, story = story, act = QD.Act and QD.Act(q, story)}
                local text
                if false then
                else
                    -- (round 17: a friend's book too tells the work from the quest's own text, its own line of
                    -- the two; never "we saw to the work of X")
                    text = QD.Moment(e, tok, QD.Variant(key, nil, teller.deedOther), true)
                    -- (round 23: its background a night the companion missed: this night's act alone)
                    if useAct and not forceTell and e.act and e.act.act then
                        text = Cap(b.we) .. " " .. e.act.act .. "."
                        -- (round 30: the friend's book says a kill from the one who fell)
                        local k = T.BondKind(c.person) ~= "close" and e.act.act:match("^killed (.+)$")
                        if k and not k:find(" at the %u") then text = Cap(k) .. " died at " .. b.our .. " hands." end
                    end
                    if setupAway then
                        local act = e.act and e.act.act and not e.act.solo and e.act.act:gsub(" for %u[%a']+$", "")
                        -- (round 27: the record holds only the hand-in's minute, so the deed is told there, as done before it)
                        -- (round 28: "had" only for a deed done somewhere else before the hand-in in a city, "had killed
                        -- Valdred at the Greymane Wall"; a deed that is the hand-in itself stays in the simple past)
                        if act and act:find(" at the %u") and q.z and IsCity(q.z) then act = act:gsub("^(%l+ed) ", "had %1 ", 1) end
                        text = act and (Cap(b.we) .. " " .. act .. ".") or nil
                        -- (a friend's book says the same deed from the place first)
                        local deed, where
                        if act then deed, where = act:match("^(.-) at (the [%u][%a' ]+)$") end
                        if deed and T.BondKind(c.person) ~= "close" then text = "At " .. where .. ", " .. b.we .. " " .. deed .. "."
                        elseif act and T.BondKind(c.person) ~= "close" and act:find("^killed ") then
                            -- (round 30: the friend's book says a kill from the one who fell, never the close book's words)
                            text = Cap(act:gsub("^killed ", "")) .. " died at " .. b.our .. " hands."
                        end
                    end
                    -- (round 16: only work the two did; a line of mine alone, "I woke on the cold stone",
                    -- "Aramis began my training", is the own book's, not hers)
                    local low = text and (" " .. PlainOf(text):lower() .. " ") or ""
                    local shared = low:find("[%s%p]we[%s%p]") or low:find("[%s%p]us[%s%p]") or low:find("[%s%p]our[%s%p]")
                        or low:find("[%s%p]you[%s%p]")
                    if (e.act and e.act.solo) or (story.pov and story.pov.solo) or not shared or low:find("^ i ") then text = nil end
                end
                -- (round 19: an authored line that names a quarter of a city the hand-in was not in, "We learned
                -- in the Magic Quarter" told at the Sepulcher, loses the clause; the record's place stands)
                if text and q.z and not IsCity(q.z) then
                    text = text:gsub(" in the %u%a+ Quarter", ""):gsub(" in the Undercity", "")
                end
                local near
                for _, l in ipairs(lines) do if Live(l) and l.t and q.t and (not near or math.abs(l.t - q.t) < math.abs(near.t - q.t)) then near = l end end
                -- (round 17: the work of a run told with the run, at its end: "the tomes of the Searing Blade"
                -- came out of the chasm, not out of a second trip after the hearthstone)
                local runOf
                for _, d in ipairs(f.dungeons or {}) do
                    local name = d.name and Clean(d.name)
                    local low = text and PlainOf(text):lower() or ""
                    local below = A.Lore and A.Lore.dungeonStory and d.name and A.Lore.dungeonStory[d.name]
                    if name and (low:find(name:lower(), 1, true) or (low:find("went down into", 1, true) or low:find("caverns", 1, true) or low:find("chasm", 1, true))) and below then runOf = d end
                end
                if text and runOf then
                    -- (round 18: told at its hand-in, in the record's order, saying where the thing came from:
                    -- "Back in the Undercity, we handed over the spell tomes we had brought out of the caverns
                    -- beneath Orgrimmar, gifts of the Legion ...")
                    local place = q.z and A.JournalPlain((c.Place or function(z) return z end)(q.z))
                    text = text:gsub("^(%a+) went down into ([^,]-) for (the [^,]-), ", function(w, where, what)
                        return (place and ("Back in " .. place .. ", ") or "Later, ") .. w:lower() .. " handed over " .. what .. " " .. w:lower() .. " had brought out of " .. where .. ", "
                    end, 1)
                    runOf = nil
                end
                if text and near then
                    S.Z[text] = q.z or S.Z[near.text]
                    S.Q[text] = q
                    S.NoLead = S.NoLead or {}; S.NoLead[text] = true
                    -- (a thread's closing scene taken out of a list is kept whole by the spine budget)
                    if forceTell then S.Keep = S.Keep or {}; S.Keep[text] = true end
                    -- (round 26: a deed told by the place it was done, "killed Valdred at the Greymane Wall",
                    -- carries the minute the record was last there, while the two were together, not the hand-in's)
                    local deedT
                    if not runOf and q.t and c.person and type(c.person.journal) == "table" then
                        local plain = PlainOf(text)
                        local day0 = math.huge
                        for _, sc in ipairs(c.day and c.day.scenes or {}) do if sc.t and sc.t < day0 then day0 = sc.t end end
                        for _, x in ipairs(c.ownJournal or {}) do
                            -- (round 27: only a record of the deed itself, a kill of the one the line names; being at
                            -- the place is not the deed's minute)
                            if (x.k == "boss" or x.k == "kill") and x.d and x.t and x.t < q.t and x.t >= day0 and plain:find(Clean(x.d), 1, true) then
                                local with = false
                                for _, g in ipairs(c.person.journal) do if g.k == "group" and g.t and x.t >= g.t - 60 and x.t <= (g.e or g.t) + 60 then with = true end end
                                if with and (not deedT or x.t > deedT) then deedT = x.t end
                            end
                        end
                    end
                    lines[#lines + 1] = {n = #lines + 1.5, text = text, beat = "questKey", t = (runOf and near.t) or deedT or q.t or near.t, ep = near.ep, added = true,
                        run = runOf}
                    if runOf then S.R[text] = runOf end
                    if c.friendPending then
                        c.friendActs = c.friendActs or {}
                        c.friendPending.line = lines[#lines]
                        c.friendActs[near.ep] = c.friendPending
                        c.friendPending = nil
                    end
                    for x in pairs(MatterWords(text)) do hereWords[x] = true end
                    here[#here + 1] = text
                    added = added + 1
                end
            end
        end
    end
end
-- The first step of a quest chain the night holds (round 18): "In Westfall, a blistered note by a
-- burned-out fire set us on a trail of notes", so a later "the note" is never unintroduced.
function T.ChainStart(c, lines, Live)
    local chains = A.SelfWords and A.SelfWords.compose and A.SelfWords.compose.questChains
    local teller, S = c.teller, c.S
    if not chains then return end
    local times = {}
    for _, scene in ipairs(c.day and c.day.scenes or {}) do
        if scene.kind == "outing" then
            for _, x in ipairs(c.ownJournal or {}) do
                if x.k == "quest" and x.qid and x.t and x.t >= (scene.t or 0) and x.t <= (scene.e or scene.t or 0) then times[x.qid] = x end
            end
        end
    end
    for _, q in ipairs(c.f and c.f.quests or {}) do if q.qid and not times[q.qid] then times[q.qid] = q end end
    for _, ch in ipairs(chains) do
        local q = ch.qids and times[ch.qids[1]]
        if q and ch.start then
            local said = false
            for _, l in ipairs(lines) do if Live(l) and PlainOf(l.text):lower():find("trail of notes", 1, true) and l.t and l.t <= (q.t or 0) then said = true end end
            if not said then
                local clause = ch.start:gsub("^where ", ""):gsub("{us}", teller.base.us):gsub("{we}", teller.base.we)
                local place = q.z and (c.Place or function(z) return "{p:" .. Clean(z) .. "}" end)(q.z)
                local text = place and ("In " .. place .. ", " .. clause .. ".") or (Cap(clause) .. ".")
                -- (a friend's book says the same start in its own words)
                if T.BondKind(c.person) == "friend" and place then
                    text = Cap(teller.base.we) .. " picked up the trail in " .. place .. ", from a note left by a burned-out fire."
                end
                local near
                for _, l in ipairs(lines) do if Live(l) and l.t and (not near or math.abs(l.t - q.t) < math.abs(near.t - q.t)) then near = l end end
                if near then
                    S.Z[text] = q.z
                    S.NoLead = S.NoLead or {}; S.NoLead[text] = true
                    lines[#lines + 1] = {n = #lines + 1.5, text = text, beat = "questKey", t = q.t, ep = near.ep, added = true}
                end
            end
        end
    end
end
-- (round 19) How much of a line is the two of them: the share of its sentences whose subject or
-- object is "we", "us", "our" or her name; and whether it sets up something told later (a name of
-- its own met again in another line, a quest of a thread).
T.SPINE_BUDGET = {close = 24, friend = 22}
function T.BondSpine(c, lines, Live)
    local teller, S = c.teller, c.S
    local kind = T.BondKind(c.person)
    local budget = T.SPINE_BUDGET[kind]
    if not budget then return end
    local name = PlainOf(teller.base.name)
    local we = teller.base.I == "I"
    local function Sentences(text)
        local out = {}
        for sx in (PlainOf(text) .. " "):gmatch("(.-[%.!?])%s+") do out[#out + 1] = sx end
        return out
    end
    local function Ours(sx)
        local low = " " .. sx:lower() .. " "
        return low:find("[%s%p]we[%s%p]") or low:find("[%s%p]us[%s%p]") or low:find("[%s%p]our[%s%p]") or sx:find(name, 1, true)
            or (not we and low:find("[%s%p]you[%s%p]"))
    end
    local total = 0
    -- (round 27: the companion's falls, every one told, do not take the place of the work)
    for _, l in ipairs(lines) do if Live(l) and l.beat ~= "death" and l.beat ~= "rez" then total = total + #Sentences(l.text) end end
    if total <= budget then return end
    local QD = A.QuestDeeds
    local FOLDABLE = {questKey = true, quests = true, land = true, landKey = true, consequence = true, again = true, questStart = true, questOutcome = true}
    local cands = {}
    -- (a thread told in two or more lines of the chapter is a story of its own here: its lines stay)
    local threadCount, threadEnds = {}, {}
    for _, l in ipairs(lines) do
        local q = Live(l) and S.Q and S.Q[l.text]
        local st = q and QD and QD.Story and QD.Story(q)
        if st and st.thread then
            threadCount[st.thread] = (threadCount[st.thread] or 0) + 1
            local e = threadEnds[st.thread] or {}
            if not e.first or (l.t or 0) < (e.first.t or 0) then e.first = l end
            if not e.last or (l.t or 0) > (e.last.t or 0) then e.last = l end
            threadEnds[st.thread] = e
        end
    end
    for _, l in ipairs(lines) do
        if Live(l) and FOLDABLE[l.beat] and not l.run and l.n > 1 then
            local ss = Sentences(l.text)
            local ours = 0
            for _, sx in ipairs(ss) do if Ours(sx) then ours = ours + 1 end end
            local score = #ss > 0 and ours / #ss or 0
            -- (a thread's work, or a name met again in another line, sets something up: it stays)
            local q = S.Q and S.Q[l.text]
            local st = q and QD and QD.Story and QD.Story(q)
            -- (its first and last line: the middle of a long thread folds before a deed of its own)
            local ends = st and st.thread and threadEnds[st.thread]
            local keeps = st and st.thread and (threadCount[st.thread] or 0) >= 2 and ends and (ends.first == l or ends.last == l) or false
            -- (a fight is a deed: it outranks an errand)
            local low = PlainOf(l.text):lower()
            if low:find(" killed ", 1, true) or low:find(" cut down ", 1, true) or low:find(" fought ", 1, true) or low:find(" ambush", 1, true) then score = score + 0.5 end
            -- (a fight the two of us fought is a beat of ours: it stays)
            if low:find("we went in and killed", 1, true) or low:find("we killed ", 1, true) or low:find("we fought ", 1, true) then keeps = true end
            -- (a setup: the first mention of a name that a later line uses again)
            for w in PlainOf(l.text):gmatch("%u%l%l%l%l+") do
                local before, after = false, false
                for _, x in ipairs(lines) do
                    if Live(x) and x ~= l and PlainOf(x.text):find("%f[%a]" .. w .. "%f[%A]") then
                        if (x.t or 0) < (l.t or 0) then before = true else after = true end
                    end
                end
                if after and not before and not (A.LoreZoneLevels and A.LoreZoneLevels[w]) and T.SPINE_NAME_SETUPS then keeps = true end
            end
            if l.text:find(teller.base.name, 1, true) or (S.Keep and S.Keep[l.text]) then keeps = true end
            if PlainOf(l.text):lower():find("trail", 1, true) or PlainOf(l.text):lower():find("note", 1, true) then keeps = true end
            if not keeps then cands[#cands + 1] = {l = l, score = score, n = #ss, lore = (l.beat == "land" or l.beat == "landKey")} end
        end
    end
    table.sort(cands, function(a, b)
        if a.lore ~= b.lore then return a.lore end
        if a.score ~= b.score then return a.score < b.score end
        return (a.l.t or 0) > (b.l.t or 0)
    end)
    for _, cand in ipairs(cands) do
        if total <= budget then break end
        cand.l.drop = true
        total = total - cand.n
    end
end
-- Her deed from her record (round 11): her levels against yours that day, else the parts in a run.
-- Replaces the chapter's plain level line; never when the levels went side by side (said already).
function T.HerDeed(c, lines, Live, Rewrite)
    local teller, PB, rng, tokens, f = c.teller, c.PB, c.rng, c.tokens or {}, c.f or {}
    local mine, hers, myStart, herStart, firstT = {}, {}, nil, nil, nil
    for _, scene in ipairs(c.day and c.day.scenes or {}) do
        for _, e in ipairs(scene.entries or {}) do
            local n = tonumber(e.d)
            if e.k == "level" and n and e.t then hers[n] = e.t end
            if e.k == "mylevel" and n and e.t then mine[n] = e.t end
            if e.k == "group" and e.t and (not firstT or e.t < firstT) then firstT, myStart, herStart = e.t, tonumber(e.pl), tonumber(e.ol) end
        end
    end
    local levelLine
    for _, l in ipairs(lines) do
        if Live(l) and not l.run and (l.beat == "level" or l.beat == "levelMark") and not PlainOf(l.text):find("kept pace", 1, true) then levelLine = l end
    end
    for _, l in ipairs(lines) do if Live(l) and PlainOf(l.text):find("kept pace", 1, true) then return end end
    local key, n, t
    local both, ahead = 0, 0
    for lv, ht in pairs(hers) do
        if mine[lv] and math.abs(mine[lv] - ht) >= 120 then both = both + 1; if ht < mine[lv] then ahead = ahead + 1 end end
    end
    local herMax, myMax = 0, 0
    for lv in pairs(hers) do herMax = math.max(herMax, lv) end
    for lv in pairs(mine) do myMax = math.max(myMax, lv) end
    if herStart and myStart and herStart < myStart and hers[myStart] then key, n, t = "herCaughtUp", myStart, hers[myStart]
    elseif both >= 2 and ahead == both then key, t = "herLevelAhead", nil
    elseif herMax > 0 and herMax > myMax and myMax > 0 then key = "herLeftAhead"
    elseif both >= 1 then
        local best
        for lv, ht in pairs(hers) do if mine[lv] and ht < mine[lv] - 120 and (not best or lv < best) then best = lv end end
        if best then key, n, t = "herLevelOne", best, hers[best]
        else
            for lv, ht in pairs(hers) do if mine[lv] and ht > mine[lv] + 120 and (not best or lv > best) then best = lv end end
            if best then key, n, t = "herBehind", best, hers[best] end
        end
    end
    local line
    -- (round 14: no level race in the story; the levels side by side of the first day stay, the
    -- rest goes with the plain level line below)
    if not T.LEVEL_RACE then key = nil end
    if key and PB[key] then
        tokens.n = n
        line = teller:Say(key, PB[key], rng, tokens)
    end
    -- (no level story: the parts in a run, from the record's roles)
    -- (round 12: off; a role is not an act the record holds, "my own was to hold the front")
    if not line and T.HER_ROLES and PB.herRoles and A.Lore and A.Lore.Role then
        for _, d in ipairs(f.dungeons or {}) do
            local myRole, theirRole = A.Lore.Role(d.r), A.Lore.Role(d.tr)
            if not line and myRole and theirRole and PB.rolePart[myRole] and PB.rolePart[theirRole] and myRole ~= theirRole then
                tokens.myPart, tokens.theirPart = PB.rolePart[myRole], PB.rolePart[theirRole]
                line = teller:Say("herRoles", PB.herRoles, rng, tokens)
                if line then
                    for _, l in ipairs(lines) do
                        if Live(l) and l.run == d and l.beat == "dungeon" then
                            Rewrite(l, l.text .. " " .. Cap(line))
                            return
                        end
                    end
                    line = nil
                end
            end
        end
    end
    if not line then
        -- (round 11: no plain level line in a bonded book; levels only as something the two did)
        if levelLine then levelLine.drop = true end
        return
    end
    if levelLine then Rewrite(levelLine, line); levelLine.toClose = nil; return end
    -- (no level line to take: a line of its own, at the time it happened, in that episode)
    local near
    for _, l in ipairs(lines) do
        if Live(l) and l.t and t and (not near or math.abs(l.t - t) < math.abs(near.t - t)) then near = l end
    end
    near = near or lines[#lines]
    if near and near.ep then
        local l = {n = #lines + 1.5, text = line, beat = "shared", t = t or near.t, ep = near.ep, added = true}
        c.S.Z[line] = c.S.Z[near.text]
        lines[#lines + 1] = l
    end
end
function T.ComposeTogether(c, lines)
    local teller, S, PB, rng, tokens, f = c.teller, c.S, c.PB, c.rng, c.tokens or {}, c.f or {}
    local we = teller.base.I == "I"
    local name = teller.base.name
    local N = Esc(name)
    local kind = T.BondKind(c.person)
    local close = kind == "close"
    S.bonded = kind ~= "plain"
    local me, my, I = teller.base.me, teller.base.my, teller.base.I
    local history = c.history or {}
    local function Live(l) return l and not l.drop end
    local function Rewrite(l, text) if text and text ~= l.text then l.text = S.Carry(l.text, text) end end
    local function Named(except)
        for _, x in ipairs(lines) do if Live(x) and x ~= except and x.text:find(name, 1, true) then return true end end
        return false
    end
    -- 1. the party words said as people
    local pairNamed = teller.base.pairNamed
    for _, l in ipairs(lines) do
        if Live(l) and l.text:find(name, 1, true) then
            local text = l.text
            local together = close and " together" or ""
            local side = close and ("at " .. my .. " side") or ("with " .. me)
            local lead = text:find("^" .. N .. " was in the party again")
            text = text:gsub("^" .. N .. " was in the party again", Cap(pairNamed) .. " were out" .. together .. " again", 1)
            if not lead then text = text:gsub(", " .. N .. " was in the party again", ", " .. pairNamed .. " were out" .. together .. " again", 1) end
            text = text:gsub(N .. " was back in the party", name .. " was back " .. side, 1)
            -- (round 11: "your party" / "my party" said as people too)
            text = text:gsub(N .. " was back in " .. my .. " party", name .. " was back " .. side, 1)
            text = text:gsub(N .. " was in " .. my .. " party", name .. " was " .. side, 1)
            text = text:gsub(N .. " was in the party as usual", name .. " was " .. side .. " as usual", 1)
            text = text:gsub(N .. " was in the party once more", name .. " was " .. side .. " once more", 1)
            text = text:gsub(N .. " was in the party for the first time in", name .. " was " .. side .. " for the first time in", 1)
            text = text:gsub(", and " .. N .. " was in the party%.$", ", and " .. name .. " was " .. side .. ".", 1)
            text = text:gsub(" brought " .. N .. " back to the party", " brought " .. name .. " back", 1)
            -- (round 13: a close bond does not "come back" like an acquaintance; the two are together again)
            if close and l.n == 1 then
                text = text:gsub("^" .. N .. " came back ", Cap(pairNamed) .. " were together again ", 1)
                text = text:gsub("^" .. N .. " was back ", Cap(pairNamed) .. " were together again ", 1)
                text = text:gsub("^" .. N .. " joined " .. me .. " ", Cap(pairNamed) .. " set out together ", 1)
            end
            Rewrite(l, text)
        end
    end
    -- 1a'. round 20: the evening began without the companion (my own record has play well before the
    -- companion's first outing): the opening says where the companion joined, never "with Marrow along"
    -- from the start
    do
        local l1 = lines[1]
        local outing0
        for _, scene in ipairs(c.day and c.day.scenes or {}) do if scene.kind == "outing" and (not outing0 or scene.t < outing0.t) then outing0 = scene end end
        local mine0
        for _, x in ipairs(c.ownJournal or {}) do
            if x.k == "play" and x.t and outing0 and x.t < outing0.t and outing0.t - x.t <= 6 * 3600 and (not mine0 or x.t < mine0.t) then mine0 = x end
        end
        if Live(l1) and outing0 and mine0 and outing0.t - mine0.t >= 10 * 60 then
            local place = l1.text:match("began in (.-), with " .. N .. " along%.$") or l1.text:match("began in (.-), " .. N .. " at [%a]+ side%.$")
            if place then
                local joinPlace = outing0.zone and (c.Place or function(z) return "{p:" .. Clean(z) .. "}" end)(outing0.zone) or place
                Rewrite(l1, Cap(PartOf(Hour(mine0.t))) .. " came on, and " .. name .. " joined " .. teller.base.us .. " in " .. joinPlace .. ".")
            end
        end
    end
    -- (round 24: "where we had left off" only when the night before ended in that land)
    do
        local l1 = lines[1]
        if Live(l1) then
            local place = l1.text:match("in {p:([^}]+)}, where %a+ had left off")
            if place and history.lastEndZone and Clean(history.lastEndZone):gsub("^[Tt]he ", "") ~= Clean(place):gsub("^[Tt]he ", "") then
                Rewrite(l1, (l1.text:gsub(", where %a+ had left off", "", 1)))
            end
        end
    end
    -- 1b. the chapter's opening names the companion when the next lines do not ("The light was
    -- going when we set out" -> "when Dahlia and I set out"), and takes the place of a bare
    -- "That night began in X" that follows it
    local first0 = lines[1]
    if Live(first0) and first0.n == 1 and (first0.beat == "open" or first0.beat == "greeting") and not first0.text:find(name, 1, true) then
        local soon = false
        for _, x in ipairs(lines) do if Live(x) and x ~= first0 and x.n <= 3 and x.text:find(name, 1, true) then soon = true end end
        if close then soon = false end
        if not soon then
            local text = first0.text
            if we then
                text = text:gsub("^We ", Cap(pairNamed) .. " ", 1)
                if text == first0.text then text = text:gsub("%f[%a]we%f[%A]", pairNamed, 1) end
                if text == first0.text then text = text:gsub("%f[%a]us%f[%A]", (pairNamed:gsub(" and I$", " and me")), 1) end
            else
                text = text:gsub("%f[%a]you%f[%A]", "you and " .. name, 1)
                if text == first0.text then text = text:gsub("^You ", "You and " .. name .. " ", 1) end
            end
            Rewrite(first0, text)
        end
    end
    -- (a chapter that never names the companion at all: the first "we" of it does, "We carried the
    -- bundled artifacts" -> "Marrow and I carried the bundled artifacts")
    if not Named() and not teller.crowd then
        local ordered = {}
        for _, x in ipairs(lines) do if Live(x) then ordered[#ordered + 1] = x end end
        table.sort(ordered, function(a, b) return a.n < b.n end)
        for _, x in ipairs(ordered) do
            local text = x.text
            if we then
                text = text:gsub("^We ", Cap(pairNamed) .. " ", 1)
                if text == x.text then text = text:gsub("([,%.] )we ", "%1" .. pairNamed .. " ", 1) end
            else
                text = text:gsub("^You ", "You and " .. name .. " ", 1)
            end
            if text ~= x.text and not x.text:find("^You and ") then Rewrite(x, text); break end
        end
    end
    if Live(first0) and first0.n == 1 and not first0.text:find("{p:", 1, true) then
        for _, x in ipairs(lines) do
            if Live(x) and x ~= first0 and x.beat == "day" and x.n <= 3 then
                local place = (PlainOf(x.text):match("^Th[ae][t]? %a+ began in ") and x.text:match("began in (.-)%.$"))
                    or (PlainOf(x.text):match("^That %a+ [wy]o?u? ?w?e? ?were in ") and x.text:match("^That %a+ %a+ were in (.-)%.$"))
                    or x.text:match("^We were in (.-)%.$") or x.text:match("^You were in (.-)%.$")
                local ends = first0.text:find(" again%.$") or first0.text:find(" together%.$") or first0.text:find(" set out%.$")
                    or first0.text:find(" a second time%.$")
                    or first0.text:find(" side%.$") or first0.text:find(" with " .. me .. "%.$")
                if place and ends and not place:find(",", 1, true) then
                    Rewrite(first0, first0.text:sub(1, -2) .. " in " .. place .. ".")
                    x.drop = true
                end
                break
            end
        end
    end
    -- 2. the first day of two who began together; levels side by side
    local first = lines[1]
    if (history.days or 0) == 0 and StartedTogether(c.day) then history.startedTogether = true end
    if Live(first) and (history.days or 0) == 0 and StartedTogether(c.day) then
        -- (the teller's first line names the two and the land, and nothing else: "Dahlia, my wife, was at
        -- my side in Tirisfal Glades", "I set out in Tirisfal Glades with Dahlia, my wife, at my side")
        local place = first.text:find(name, 1, true) and CountWords(first.text) <= 16 and not first.text:gsub(N, ""):find("{n:", 1, true)
            and select(2, first.text:gsub("{p:", "")) == 1 and first.text:match("({p:[^}]+})")
        local pool = close and PB.startedBond or PB.startedFriend
        pool = pool and pool[we and "we" or "you"]
        -- (both of one race, in that race's first land: the race's own beginning, "rose from the
        -- grave together in Deathknell", with the bond inside the sentence)
        local race = teller.player and teller.player.race
        local home = place and Clean(place:match("{p:([^}]+)}") or "")
        if race and c.person and c.person.race == race and RACE_START[race] == home and PB.origin and PB.origin[race] then
            local bondWord = teller.base.bondWord
            local who = bondWord and (we and (name .. ", " .. bondWord .. ", and I") or ("you and " .. name .. ", " .. bondWord .. ","))
                or (we and (name .. " and I") or ("you and " .. name))
            local own = {}
            for i, line in ipairs(PB.origin[race]) do own[i] = (line:gsub("{pair}", "{pairBond}")) end
            tokens.pairBond = who
            pool = own
        end
        if place and pool then
            tokens.zoneD = place
            local key = Clean(place:match("{p:([^}]+)}") or ""):gsub("^[Tt]he ", ""):match("^(%S+)")
            if key and teller.saidPlaces then teller.saidPlaces[key] = nil end
            local line = teller:Say("started", pool, rng, tokens)
            if line then Rewrite(first, line); history.startedTogether = true end
        end
    end
    if PB.lockstep and not history.lockstepSaid and Lockstep(c.day) then
        for _, l in ipairs(lines) do
            local plain = Live(l) and (l.beat == "level" or l.beat == "levelMark") and PlainOf(l.text) or ""
            local n = plain:match("^Both of %a+ were level (%d+) by the end of it%.$") or plain:match("^By the end of it, both of %a+ were level (%d+)%.$")
            if n then
                tokens.theirs = n
                local line = teller:Say("lockstep", PB.lockstep, rng, tokens)
                if line then Rewrite(l, line); history.lockstepSaid = true end
                break
            end
        end
    end
    -- (the time out is the close's: "Dahlia and I were out for over two hours in Tirisfal Glades" ->
    -- "Dahlia and I began the evening in Tirisfal Glades")
    for _, l in ipairs(lines) do
        if Live(l) and l.beat == "day" then
            local who, place = l.text:match("^(.-) were out for [%a ]- hours? in (.-)%.$")
            if not who then who, place = l.text:match("^(.-) were out for [%a ]- minutes in (.-)%.$") end
            if who and place then Rewrite(l, who .. " began the " .. PartOf(Hour(l.t)) .. " in " .. place .. ".") end
            if not who and l.n > 1 then
                local text = l.text:gsub(" spent [%a ]- hours? together in ", " spent the " .. PartOf(Hour(l.t)) .. " in ", 1)
                    :gsub(" spent [%a ]- hours? in ", " spent the " .. PartOf(Hour(l.t)) .. " in ", 1)
                Rewrite(l, text)
            end
        end
    end
    -- 3. a list of places: where the day went first ("We found our way to Deathknell, Night
    -- Web's Hollow and Tirisfal Glades" -> "We found our way to Deathknell")
    for _, l in ipairs(lines) do
        if Live(l) and (l.beat == "shared" or l.beat == "day") then
            -- (the run of places "A, B and C" or "A and B", with nothing else between them)
            local s0, list, e0 = l.text:match("()({p:[^}]+}, [^%.]-{p:[^}]+} and {p:[^}]+})()")
            if not s0 then s0, list, e0 = l.text:match("()({p:[^}]+} and {p:[^}]+})()") end
            local low = PlainOf(l.text):lower()
            local going = low:find(" way to ", 1, true) or low:find(" came upon ", 1, true) or low:find(" came to ", 1, true)
            if list and going then
                local rest = list:gsub("{p:[^}]+}", ""):gsub("the ", ""):gsub("[,%s]", ""):gsub("and", "")
                if rest == "" then Rewrite(l, l.text:sub(1, s0 - 1) .. list:match("^({p:[^}]+})") .. l.text:sub(e0)) end
            end
        end
    end
    -- (a going to a place the opening already named: "We found our way to Deathknell" after "rose
    -- from the grave together in Deathknell")
    for _, l in ipairs(lines) do
        if Live(l) and l ~= lines[1] and Live(lines[1]) and l.beat == "shared" and CountWords(l.text) <= 12 then
            local low = PlainOf(l.text):lower()
            local only = l.text:match("^[^{]*{p:([^}]+)}[^{]*$")
            if only and (low:find(" way to ", 1, true) or low:find(" came upon ", 1, true)) and PlainOf(lines[1].text):find(only, 1, true) then l.drop = true end
        end
    end
    -- (a party of two is the two of you: "Your party went down into" -> "You and Dahlia went down into")
    if close and not we and not teller.crowd then
        for _, l in ipairs(lines) do
            if Live(l) and l.text:find("^Your party ") then Rewrite(l, (l.text:gsub("^Your party ", "You and " .. name .. " ", 1))) end
        end
    end
    -- 4. a going told twice: "We made our way from Tirisfal Glades to Silverpine Forest" after
    -- "It was my first time in Silverpine Forest" (the place is said; the going goes)
    for _, l in ipairs(lines) do
        if Live(l) and l.beat == "day" and CountWords(l.text) <= 12 and PlainOf(l.text):find(" way from ", 1, true) then
            local dest = l.text:match("{p:([^}]+)}%.$")
            for _, x in ipairs(lines) do
                if dest and Live(x) and x ~= l and x.n < l.n and x.text:find("{p:" .. dest .. "}", 1, true) then l.drop = true; break end
            end
        end
    end
    -- 5. the companion in a scene the line told as yours alone
    for _, l in ipairs(lines) do
        if Live(l) then
            local spoke = l.text:match("^" .. (we and "I" or "You") .. " spoke with (.-) during %a+ time together%.$")
            if spoke then
                -- (round 20: the meeting is mine in the record, a solo quest; "Dahlia and I stood before" was not)
                Rewrite(l, Cap(I) .. " spoke with " .. spoke .. ".")
            elseif l.text:find(" during %a+ time together%.$") then
                Rewrite(l, (l.text:gsub(" during %a+ time together%.$", ".")))
            end
        end
    end
    -- 6. the first raise: its own sentence, and for a close bond its weight
    for _, l in ipairs(lines) do
        if Live(l) and l.beat == "death" then
            local head, call, tail = l.text:match("^(.-), and (" .. (we and "I" or "you") .. " called on the Light), and " .. N .. " rose, (the first .- ever raised)%.$")
            if head then
                local they = teller.base.they
                if close then Rewrite(l, head .. ". " .. Cap(call) .. ", and " .. they .. " rose. " .. Cap(teller.base.They) .. " " .. teller.base.was .. " " .. tail .. ".")
                else Rewrite(l, head .. ". " .. Cap(call) .. ", and " .. they .. " rose, " .. tail .. ".") end
            end
        end
    end
    -- 6a. round 14: the reason for a run comes before the way in ("Thrall wanted to know ..." before
    -- "we went down into Ragefire Chasm")
    do
        local stories = A.Lore and A.Lore.dungeonStory
        for _, d in ipairs(f.dungeons or {}) do
            local why = stories and stories[d.name] and stories[d.name].why
            if why then
                local set = {}
                for _, w in ipairs(why) do set[w] = true end
                local entry, reason
                for _, l in ipairs(lines) do
                    if Live(l) and l.run == d and l.beat == "dungeon" then
                        if l.text:find(" into {p:", 1, true) and not entry then entry = l end
                        if set[l.text] then reason = l end
                    end
                end
                if entry and reason and reason.n > entry.n then
                    reason.n = entry.n - 0.5
                    entry.text = S.Carry(entry.text, (entry.text:gsub("^Then,? ", ""):gsub("^%l", string.upper)))
                end
            end
        end
    end
    -- (round 22: a run's hand-in told later says its taking as past, never as if fetched after the ask:
    -- "Varimathras told us ... We had taken them from the cultists, and he said ...")
    if kind ~= "plain" then
        for _, l in ipairs(lines) do
            local q = Live(l) and not l.run and S.Q and S.Q[l.text]
            if q and S.RQ and S.RQ[q] then
                local text = l.text:gsub("([%.!] )We took ", "%1We had taken "):gsub("([%.!] )We killed ", "%1We had killed ")
                    :gsub("([%.!] )We brought ", "%1We had brought ")
                Rewrite(l, text)
            end
        end
    end
    -- (round 22: a scene that retells a step of a prior night, "Bethor knew the maker of the ichor ... He
    -- wrote out a scroll" handed in the next evening, is told as this night's own act: "We carried
    -- Bethor's scroll back to Renferrel")
    if kind ~= "plain" then
        local QD = A.QuestDeeds
        local dayStart = math.huge
        for _, scene in ipairs(c.day and c.day.scenes or {}) do if scene.t and scene.t < dayStart then dayStart = scene.t end end
        for _, l in ipairs(lines) do
            local q = Live(l) and not l.run and S.Q and S.Q[l.text]
            local st = q and QD and QD.Story and QD.Story(q)
            if st and st.thread and not PlainOf(l.text):find("^%a*%s?[Ww]e ") then
                local prior = false
                for _, x in ipairs(c.ownJournal or {}) do
                    if x.k == "quest" and x.t and x.t < dayStart and dayStart - x.t <= 30 * 3600 and x.qid ~= q.qid then
                        local st2 = QD.Story({title = x.d, qid = x.qid})
                        if st2 and st2.thread == st.thread then prior = true end
                    end
                end
                local act = prior and QD.Act and QD.Act(q, st)
                if act and act.act and act.act:find("^learned ") then l.drop = true
                elseif act and act.act then
                    local k = T.BondKind(c.person) ~= "close" and act.act:match("^killed (.+)$")
                    if k and not k:find(" at the %u") then Rewrite(l, Cap(k) .. " died at " .. teller.base.our .. " hands.")
                    else Rewrite(l, Cap(teller.base.we) .. " " .. act.act .. ".") end
                end
            end
        end
    end
    -- 6a'. (round 17, off since round 18: a hand-in is told at its own time, in the record's order)
    if kind ~= "plain" and T.RUN_HANDIN_WITH_RUN then
        for _, d in ipairs(f.dungeons or {}) do
            local runEnd, runEp
            for _, l in ipairs(lines) do
                if Live(l) and l.run == d and l.t then
                    if not runEnd or l.t > runEnd then runEnd, runEp = l.t, l.ep end
                end
            end
            for _, l in ipairs(lines) do
                local q = S.Q and S.Q[l.text]
                if runEnd and Live(l) and not l.run and q and S.RQ and S.RQ[q] == d then
                    l.run, l.ep, l.t = d, runEp, runEnd + 1
                    S.R[l.text] = d
                    Rewrite(l, (l.text:gsub("^Later, back in [^,]+, ", ""):gsub("^Back in [^,]+, ", ""):gsub("^In [^,]+, ", ""):gsub("^%l", string.upper)))
                end
            end
        end
    end
    -- (a friend's book leaves the run's short epitaph, "The felguard beneath Orgrimmar had fallen.", to the
    -- spouse's: the kill roll already says it, and the two books do not share it)
    if kind == "friend" then
        for _, l in ipairs(lines) do
            if Live(l) and l.run and l.beat == "climax" and CountWords(l.text) <= 9 and PlainOf(l.text):find(" had fallen%.$") then l.drop = true end
        end
    end
    -- (round 20: "the one we had come for" only after a line of the run set the goal; else plain)
    for _, d in ipairs(f.dungeons or {}) do
        local goal = false
        for _, l in ipairs(lines) do
            if Live(l) and l.run == d and (PlainOf(l.text):find(" wanted ", 1, true) or PlainOf(l.text):find(" sent us", 1, true)) then goal = true end
        end
        if not goal then
            for _, l in ipairs(lines) do
                if Live(l) and l.run == d then
                    Rewrite(l, (l.text:gsub(", the one we had come for", ""):gsub(", whom we had come down for", ""):gsub(", the one you had come for", "")
                        :gsub(", whom you had come down for", "")))
                end
            end
        end
    end
    -- 6b. the first dungeon the two went into together (the first run in this book)
    if #(f.dungeons or {}) > 0 and not history.dungeonTogether then
        history.dungeonTogether = true
        if kind ~= "plain" then
            for _, l in ipairs(lines) do
                if Live(l) and l.beat == "dungeon" and l.text:find(" into {p:[^}]+}%.$") and CountWords(l.text) <= 9 then
                    -- (round 11: told from the relationship; the two who began together saw their first
                    -- dungeon at once, a friend's book says the party)
                    local tail = ", " .. teller.base.our .. " first dungeon together."
                    if T.OURS and close and (history.startedTogether or (c.person and c.person.origin == "together")) then
                        tail = (teller.crowd and "" or " side by side") .. ", the first dungeon either of " .. (we and "us" or "you") .. " had seen."
                    elseif kind == "friend" then
                        tail = ", the first dungeon " .. teller.base.we .. " took on as a party."
                    end
                    Rewrite(l, l.text:sub(1, -2) .. tail)
                    break
                end
            end
        end
    end
    -- 7. days in a row, for a close bond (the common streak keeps 7, 14, 21, 30)
    local run = (c.gap == 1) and ((history.streak or 0) + 1) or nil
    -- (round 10: off; the count of the evenings belongs to the look-back of the latest chapter)
    if T.STREAK_BOND and close and run and run % 5 == 0 and run ~= 30 and PB.streakBond and Live(first) and first.n == 1
        and (first.beat == "open" or first.beat == "greeting" or first.beat == "day") then
        local said = false
        for _, l in ipairs(lines) do
            local low = Live(l) and PlainOf(l.text):lower() or ""
            if low:find("in a row", 1, true) or low:find("running", 1, true) or low:find("straight day", 1, true) then said = true end
        end
        if not said then
            tokens.nth, tokens.count = Ordinal(run), Words(run)
            local pool = (first.text:find("together", 1, true) and PB.streakBondPlain) or PB.streakBond
            local line = teller:Say("streakBond", pool, rng, tokens)
            if line then
                if first.text:find(name, 1, true) then line = line:gsub(Esc(pairNamed), teller.base.we, 1) end
                Rewrite(first, first.text .. " " .. Cap(line))
            end
        end
    end
    -- 8. a first seen together. Round 10: for two who began together (the record's first day, or the
    -- origin on the card) every first is theirs, "new to us both", never "new to me, and Dahlia was
    -- there"; for a close bond met on the road, "saw it together"; a friend keeps the clause.
    -- (round 16: off; the record never shows a first of hers, so a first stays mine, "and Dahlia and I
    -- saw it together"; `T.OURS` brings back "new to us both")
    local ours = T.OURS and close and (history.startedTogether or (c.person and c.person.origin == "together"))
    c.ours = ours
    if close then
        for _, l in ipairs(lines) do
            if Live(l) then
                local text = T.Ours(l.text, we, name, ours, history)
                if text ~= l.text then
                    local place = l.text:match("{p:([^}]+)}")
                    if place then history.sharedFirsts = history.sharedFirsts or {}; history.sharedFirsts[#history.sharedFirsts + 1] = place end
                    Rewrite(l, text)
                end
            end
        end
    end
    local pool = (not close) and PB.firstWithFriend
    if pool and kind ~= "plain" then
        local done = false
        for _, l in ipairs(lines) do
            if Live(l) and l.text:find(name, 1, true) and FirstTold(PlainOf(l.text):lower()) then done = true end
        end
        for _, l in ipairs(lines) do
            local low = Live(l) and PlainOf(l.text):lower() or ""
            if not done and l.beat == "shared" and FirstTold(low) and not l.text:find("{n:", 1, true) and CountWords(l.text) <= 12
                and l.text:find("{p:", 1, true) and l.text:sub(-1) == "." and not low:find(",", 1, true) then
                local clause = teller:Say("firstWith", pool, rng, tokens)
                if clause then Rewrite(l, l.text:sub(1, -2) .. clause .. "."); done = true end
            end
        end
    end
    if kind ~= "plain" then
        -- 9. deaths inside the scene, one a stretch (round 10; round 29: after the own book's work is in,
        -- below, so a stretch never runs across a deed told between its falls)
        -- (round 22: no "fell N times" tally; the worst stretch keeps her falls as told falls, below)
        if T.WORST_TALLY and T.BondKind(c.person) == "close" then T.WorstStretch(c, lines, Live) end
        -- 9a. round 11: at most one fall of mine alone a chapter, and none when a fall that touched
        -- the two (together, a raise between them) is told
        do
            local name0 = teller.base.name
            local function Relational(l)
                local low = PlainOf(l.text):lower()
                return l.text:find(name0, 1, true) ~= nil or low:find("rose", 1, true) ~= nil
                    or low:find("^she ") ~= nil or low:find("^he ") ~= nil or low:find(" with her%.") ~= nil or low:find(" with him%.") ~= nil
            end
            local lone, relational = {}, false
            for _, l in ipairs(lines) do
                if Live(l) and l.beat == "death" and not l.run then
                    if Relational(l) then relational = true else lone[#lone + 1] = l end
                end
            end
            table.sort(lone, function(a, b) return (a.t or 0) < (b.t or 0) end)
            for i, l in ipairs(lone) do if relational or i > 1 then l.drop = true end end
        end
        -- (round 11: a fall of mine and the fire the two sat by after it are one moment, "A vampiric
        -- duskbat killed me, and afterwards we sat by a fire together"; a close bond only)
        if close then
            for _, d in ipairs(lines) do
                if Live(d) and d.beat == "death" and not d.run and d.t and d.text:sub(-1) == "." and not d.text:find(", and ", 1, true) then
                    for _, r in ipairs(lines) do
                        local between = false
                        for _, o in ipairs(lines) do
                            if o ~= d and o ~= r and Live(o) and o.t and r.t and o.t > d.t + 30 and o.t < r.t - 30 and o.beat ~= "rest" then between = true end
                        end
                        if Live(r) and r.beat == "rest" and r.t and r.t >= d.t and r.t - d.t <= 20 * 60 and not between then
                            Rewrite(d, d.text:sub(1, -2) .. ", and afterwards " .. teller.base.we .. " sat by a fire together.")
                            r.drop = true
                            break
                        end
                    end
                end
            end
        end
        -- (round 13: a first flight the two took together, from your own record, when the chapter
        -- does not tell it: it was a first for both of a pair who began together)
        do
            local t0, e0 = DayWindow(c.day)
            local said = false
            for _, l in ipairs(lines) do
                local low = Live(l) and PlainOf(l.text):lower() or ""
                if low:find("flight", 1, true) or low:find(" flew", 1, true) then said = true end
            end
            for _, x in ipairs(c.ownJournal or {}) do
                if not said and x.k == "first" and x.d == "flight" and x.t and x.t >= t0 and x.t <= e0 and x.z then
                    local pool = (close and c.ours and PB.firstFlightOurs) or (close and PB.firstFlightClose) or PB.firstFlightFriend
                    tokens.zoneD = (c.Place or function(z) return "{p:" .. Clean(z) .. "}" end)(x.z)
                    tokens.part = PartOf(Hour(x.t))
                    if teller.saidPlaces then teller.saidPlaces[(Clean(x.z):gsub("^[Tt]he ", ""):match("^(%S+)")) or ""] = nil end
                    local text = pool and teller:Say("firstFlight", pool, rng, tokens)
                    local near
                    for _, l in ipairs(lines) do if Live(l) and l.t and (not near or math.abs(l.t - x.t) < math.abs(near.t - x.t)) then near = l end end
                    if text and near then
                        S.Z[text] = x.z
                        lines[#lines + 1] = {n = #lines + 1.5, text = text, beat = "shared", t = x.t, ep = near.ep, added = true}
                        said = true
                    end
                end
            end
        end
        -- 9c. round 11: her deed from her record (levels: ahead, caught up, behind), or the parts in a
        -- run; it takes the place of the plain level line ("Both of us went up a level ...")
        T.HerDeed(c, lines, Live, Rewrite)
        -- 9d. one named as there who does nothing told any more goes ("Varreth was in the party as well")
        for _, l in ipairs(lines) do
            if Live(l) and l.beat == "shared" and l.n > 1 and OthersLine(l.text) then
                local any = false
                for w in l.text:gmatch("{n:([^}]+)}") do
                    if "{n:" .. w .. "}" ~= teller.base.name then
                        if T.Listed and T.Listed(w) then any = true end
                        for _, x in ipairs(lines) do if Live(x) and x ~= l and PlainOf(x.text):find(Clean(w), 1, true) then any = true end end
                    end
                end
                if not any then l.drop = true end
            end
        end
        -- (and "with Marrow along" on the opening, when the chapter no longer shows him)
        local l1 = lines[1]
        local fold = Live(l1) and l1.text:match(", with (.-) along%.$")
        if fold then
            local any = false
            for w in fold:gmatch("{n:([^}]+)}") do
                if T.Listed and T.Listed(w) then any = true end
                for _, x in ipairs(lines) do if Live(x) and x ~= l1 and PlainOf(x.text):find(Clean(w), 1, true) then any = true end end
            end
            if not any then Rewrite(l1, (l1.text:gsub(", with .- along%.$", "."))) end
        end
        -- 9e. round 11: fragments that lead nowhere go: a sighting with nothing after it ("That was the
        -- day we first saw one of the Alliance"), a question put and never answered ("we asked
        -- Magistrate Sevren about the ring's owner")
        for _, l in ipairs(lines) do
            local low = Live(l) and PlainOf(l.text):lower() or ""
            if l.beat == "shared" and low:find("first saw one of the", 1, true) then l.drop = true end
            -- (round 25: a cave said with no deed in it, "Night Web's Hollow took us underground for a while")
            if low:find("took us underground", 1, true) or low:find("took you underground", 1, true) then l.drop = true end
            if (l.beat == "questKey" or l.beat == "quests") and not l.run and CountWords(l.text) <= 18 and low:find(" asked ", 1, true)
                and not low:find("%. ") and not (low:find(" said", 1, true) or low:find(" told", 1, true) or low:find(" gave", 1, true)
                or low:find(" thanked", 1, true) or low:find(" called", 1, true)) then l.drop = true end
        end
        -- 9f. round 15: the own book's work of the night, while the companion was there
        if T.OWN_SPINE ~= false then T.OwnSpine(c, lines, Live) end
        T.ChainStart(c, lines, Live)
        FoldDeaths(c, lines, Live)
        -- 9g. round 19: a long chapter keeps to the bond's spine. Chapter I reads best because the two
        -- of them are the subject of nearly every beat; where the night's quests take over, the beats
        -- the two did together (or for each other) stay and the rest fold away, the work that sets up
        -- something later kept: lore and someone else's story go first, then the work least ours
        T.BondSpine(c, lines, Live)
        -- 9h. round 20: a person named only as whom the work was for ("killed Valdred ... for Raleigh"),
        -- never met before in this book, is not named: the tail goes
        do
            history.namesMet = history.namesMet or {}
            local met = history.namesMet
            local order = {}
            for _, l in ipairs(lines) do if Live(l) then order[#order + 1] = l end end
            table.sort(order, function(a, b) return (a.t or 0) < (b.t or 0) end)
            for _, l in ipairs(order) do
                local plain = PlainOf(l.text)
                for who in plain:gmatch(" for ((%u[%a']+)[%.,])") do end
                local text = l.text
                for tail, who in l.text:gmatch("( for ([%u][%a']+))[%.,]") do
                    local w = Clean(who)
                    if #w >= 4 and not met[w] and not plain:find(w .. " ", 1, true) and not plain:find(w .. "'", 1, true) then
                        text = text:gsub(Esc(tail) .. "([%.,])", "%1", 1)
                    end
                end
                if text ~= l.text then Rewrite(l, text) end
                for w in PlainOf(l.text):gmatch("%u[%a']+") do met[(w:gsub("'s$", ""))] = true end
            end
        end
        -- 9i. round 21: no ledger: a sentence that chains three deeds or more ("We killed ..., took ... and
        -- gathered ...") keeps its first two; the rest fold
        for _, l in ipairs(lines) do
            if Live(l) and (l.beat == "quests" or l.beat == "questKey") and not l.run then
                local text = l.text
                local head, last = text:match("^((%a+ %a+ [^%.]-), [^%.]-) and ([^%.]-)%.$")
                local plain = PlainOf(text)
                local commas = select(2, plain:match("^[^%.]*"):gsub(",", ""))
                if commas >= 1 and plain:match("^[^%.]*%.$") and plain:find(" and ", 1, true) then
                    local parts = {}
                    local body = text:sub(1, -2)
                    local lastPart = body:match("^.* and (.-)$")
                    local front = body:match("^(.*) and .-$")
                    if lastPart and front then
                        for piece in (front .. ","):gmatch("(.-),%s*") do parts[#parts + 1] = piece end
                        parts[#parts + 1] = lastPart
                    end
                    -- (only a true list of deeds: each part after the first opens on a past-tense verb)
                    local VERBS = {took = true, cut = true, found = true, brought = true, slew = true, made = true, gave = true, put = true,
                        led = true, freed = true, won = true, went = true, set = true}
                    local deeds = #parts >= 3 and parts[1]:match("^%a*%s?[Ww]e ") ~= nil
                    for i = 2, #parts do
                        local w = (parts[i]:gsub("^then ", "")):match("^(%l+)")
                        if not w or not (w:find("ed$") or VERBS[w]) then deeds = false end
                    end
                    if deeds then
                        Rewrite(l, parts[1] .. " and " .. (parts[2]:gsub("^then ", "")) .. ".")
                    end
                end
            end
        end
        -- 9b. a land called new that no told moment of the chapter is in goes ("Westfall was new to us
        -- both", with nothing done there): no place is new unless the chapter takes the two there
        for _, l in ipairs(lines) do
            local low = Live(l) and PlainOf(l.text):lower() or ""
            if l.beat == "shared" and (FirstTold(low) or low:find("neither of", 1, true)) and CountWords(l.text) <= 14 and select(2, l.text:gsub("{p:", "")) == 1
                and not low:find("zeppelin", 1, true) and not low:find("boat", 1, true) and not low:find("dungeon", 1, true) then
                local z = l.text:match("{p:([^}]+)}")
                -- (the land the night ended in is told by the close)
                local st = c.stretches or {}
                local acted = (st[#st] and st[#st].zone and Clean(st[#st].zone):gsub("^[Tt]he ", "") == Clean(z or ""):gsub("^[Tt]he ", ""))
                    or (z and IsCity(z)) or false
                for _, x in ipairs(lines) do
                    if Live(x) and x ~= l and (WORK_BEATS[x.beat] or x.run or x.beat == "road") and (S.Z[x.text] == z or x.text:find("{p:" .. z .. "}", 1, true)) then acted = true end
                end
                if z and not acted then l.drop = true end
            end
        end
        -- 10. a postcard of a land where the two did nothing the chapter tells goes ("Cairne Bloodhoof
        -- kept his lodge on the high rise", the evening's first minutes in Thunder Bluff)
        for _, l in ipairs(lines) do
            if Live(l) and (l.beat == "land" or l.beat == "landKey") and l.n > 1 then
                local z = S.Z[l.text]
                local key = z and Clean(z):gsub("^[Tt]he ", ""):match("^(%S+)")
                local acted = false
                for _, x in ipairs(lines) do
                    if Live(x) and x ~= l and (WORK_BEATS[x.beat] or x.run) and (S.Z[x.text] == z or (key and PlainOf(x.text):find(key, 1, true))) then acted = true end
                end
                if key and not acted then l.drop = true end
            end
        end
    end
end
-- Two firsts in a row said once ("I had never set foot in Westfall before that day. Until that
-- day I had never been in the Stonetalon Mountains." -> "Westfall and the Stonetalon Mountains
-- were new to me that day"); the clause that named the companion stays on.
function T.ComposeTogetherAfter(c, out, beats)
    local S, PB, teller, rng, tokens = c.S, c.PB, c.teller, c.rng, c.tokens or {}
    -- (round 10: a bridge where the record crossed the sea, flew or took the hearthstone between the
    -- line before and a line that opens on another land: "Back at the Sepulcher by hearthstone, in
    -- Silverpine Forest, Bethor knew ...", not a jump from Duskwood to Silverpine)
    local times = c.times or {}
    -- (round 27: another of the party with the two at that minute: "we", never the pair alone, so nobody
    -- who was there is left out of the flight or the hearthstone)
    local function OthersAt(t)
        if not t then return false end
        local own = c.person and c.person.key
        for _, x in ipairs(c.ownJournal or {}) do
            if x.k == "with" and x.d and x.d ~= own and Clean(x.n or "") ~= Clean(c.person and c.person.name or "") and x.t and t >= x.t - 60 and t <= (x.e or x.t) + 60 then return true end
        end
        return false
    end
    -- (a close bond's book names the party as a number, "the three of us": never the friend's bare "we")
    local function Party(t1, t2, capital)
        local own, seen, n = c.person and c.person.key, {}, 2
        for _, x in ipairs(c.ownJournal or {}) do
            for _, t in ipairs({t2 or false}) do
                if t and x.k == "with" and x.d and x.d ~= own and Clean(x.n or "") ~= Clean(c.person and c.person.name or "") and not seen[x.d] and x.t and t >= x.t - 60 and t <= (x.e or x.t) + 60 then seen[x.d] = true; n = n + 1 end
            end
        end
        local words = {"two", "two", "three", "four", "five"}
        local head = "the " .. (words[n] or "five") .. " of " .. (teller.base.I == "I" and "us" or "you")
        return capital and (head:gsub("^t", "T")) or head
    end
    -- (round 25: the moves the record holds between two times, in order: "we took our hearthstones home,
    -- flew, took the zeppelin and flew again". Never a zeppelin that was not taken.)
    local function Moves(t1, t2)
        local list = {}
        for _, x in ipairs(c.ownJournal or {}) do
            if x.t and x.t > t1 and x.t <= t2 and CARRIED[x.k] then list[#list + 1] = x end
        end
        table.sort(list, function(a, b) return a.t < b.t end)
        local words, flown = {}, false
        for _, x in ipairs(list) do
            local d = x.d or x.k
            local w
            if d == "zeppelin" then w = "took the zeppelin"
            elseif d == "boat" then w = "took the boat"
            elseif x.k == "hearth" or d == "hearth" then w = "took our hearthstones home"
            elseif x.k == "taxi" or x.k == "nightflight" or d == "flight" then w = flown and "flew again" or "flew"; flown = true end
            if w and words[#words] ~= w and not (w == "took our hearthstones home" and (words[#words] or ""):find("hearthstones", 1, true)) then words[#words + 1] = w end
        end
        if #words == 0 then return nil end
        if #words == 1 then return words[1] end
        return table.concat(words, ", ", 1, #words - 1) .. " and " .. words[#words]
    end
    T.Moves = Moves
    -- (the same moves as things, for a close bond's book: "the hearthstone, two flights and the zeppelin")
    local function MoveNouns(t1, t2)
        local hearth, flights, zep, boat = false, 0, false, false
        for _, x in ipairs(c.ownJournal or {}) do
            if x.t and x.t > t1 and x.t <= t2 and CARRIED[x.k] then
                local d = x.d or x.k
                if d == "zeppelin" then zep = true elseif d == "boat" then boat = true
                elseif x.k == "hearth" or d == "hearth" then hearth = true
                elseif x.k == "taxi" or x.k == "nightflight" or d == "flight" then flights = flights + 1 end
            end
        end
        local parts = {}
        if hearth then parts[#parts + 1] = "the hearthstone" end
        if flights == 1 then parts[#parts + 1] = "a flight" elseif flights > 1 then parts[#parts + 1] = Words(flights) .. " flights" end
        if zep then parts[#parts + 1] = "the zeppelin" end
        if boat then parts[#parts + 1] = "the boat" end
        if #parts == 0 then return nil end
        return List(parts)
    end
    for n = 2, #out do
        local line = out[n]
        local lead, place, rest = line:match("^(In )({p:[^}]+}), (.*)$")
        if not lead then lead, place, rest = line:match("^(Back in )({p:[^}]+}), (.*)$") end
        local t1, t2 = nil, times[line]
        for m = n - 1, 1, -1 do if times[out[m]] then t1 = times[out[m]]; break end end
        if lead and t1 and t2 and S.Z[out[n - 1]] ~= S.Z[line] and beats[n] ~= "death" and not S.R[line] then
            local means, inn
            for _, x in ipairs(c.ownJournal or {}) do
                if x.t and x.t > t1 and x.t <= t2 and CARRIED[x.k] then
                    local d = x.d or x.k
                    if d == "zeppelin" or d == "boat" then means = "sea"
                    elseif x.k == "hearth" or d == "hearth" then
                        means = means or "hearth"
                        -- (the inn only when the stone set you down in the land this line is in)
                        local landed
                        for _, y in ipairs(c.ownJournal or {}) do if y.k == "play" and y.t and y.t >= x.t and (not landed or y.t < landed.t) then landed = y end end
                        inn = (x.k == "hearth" and landed and landed.z == S.Z[line] and x.d) or inn
                    elseif x.k == "taxi" or x.k == "nightflight" or d == "flight" then means = means or "flight" end
                end
            end
            -- (round 12: the way there is a sentence of its own, true to who travelled: a hearthstone
            -- carries me, not us; and the line keeps "In X," only when we are its subject, never to put
            -- a speaker somewhere he was not, "In Silverpine Forest, Bethor knew ...")
            local we = teller.base.I == "I"
            local Iw, Wew = we and "I" or "You", we and "We" or "You"
            -- (round 23: a close bond's bridge names the two, the friend's says "we": never the same sentence)
            if T.BondKind(c.person) == "close" then Wew = OthersAt(t2) and Party(t1, t2, true) or Cap(teller.base.pairNamed) end
            local bridge
            if means == "sea" then bridge = Wew .. " crossed back over the sea."
            elseif means == "hearth" and inn then bridge = Wew .. " took our hearthstones back to " .. Clean(inn):gsub("^The ", "the ") .. "."
            elseif means == "hearth" then bridge = Wew .. " took our hearthstones home, and " .. (we and "we" or "you") .. " went on to " .. place .. "."
            elseif means == "flight" then bridge = Wew .. " flew to " .. place .. "." end
            if not we then bridge = bridge and bridge:gsub(" our hearthstones", " your hearthstones") end
            local first = rest:match("^(%a+)")
            local ours = first == "we" or first == "We" or first == "I" or first == "you" or first == "You" or first == "our" or first == "Our"
            if bridge then
                local body = ours and (lead .. place .. ", " .. rest) or Cap(rest)
                out[n] = S.Carry(line, bridge .. " " .. body); S.Bridge = S.Bridge or {}; S.Bridge[out[n]] = true
            elseif S.bonded and not ours then
                out[n] = S.Carry(line, Cap(rest))
            end
        end
    end
    -- (round 25: any line in another land than the line before, with recorded moves between and no bridge
    -- yet, takes its moves first: "We took our hearthstones home and flew. We brought Bethor's scroll ...")
    if S.bonded then
        for n = 2, #out do
            local line = out[n]
            local z1, z2 = S.Z[out[n - 1]], S.Z[line]
            local t1, t2 = nil, times[line]
            for m = n - 1, 1, -1 do if times[out[m]] then t1 = times[out[m]]; break end end
            local low = PlainOf(line):lower()
            if z1 and z2 and z1 ~= z2 and t1 and t2 and not (S.Bridge and S.Bridge[line]) and not S.R[line] and beats[n] ~= "road"
                and not (beats[n] == "death" and (PlainOf(line):find("away from", 1, true) or (function()
                    -- (a fall of the companion's in a land I was not in: my moves do not lead there)
                    local e = S.D and S.D[line]
                    if not e or e.w == "you" then return false end
                    for _, x in ipairs(c.ownJournal or {}) do
                        if x.k == "play" and x.z and (x.t or 0) <= (e.t or 0) and (x.e or x.t or 0) >= (e.t or 0) then return Clean(x.z) ~= Clean(e.z or "") end
                    end
                    return true
                end)()))
                and (beats[n - 1] ~= "road" or not PlainOf(out[n - 1]):lower():find("hearth", 1, true)) and not low:find("^%a+ took ") and not low:find(" flew", 1, true) and not low:find("zeppelin", 1, true) and not FirstTold(low)
                and not low:find("had not been", 1, true) and not low:find("strange country", 1, true) then
                local moves = Moves(t1, t2)
                if moves then
                    local who = (T.BondKind(c.person) == "close" and not OthersAt(t2)) and Cap(teller.base.pairNamed) or (teller.base.I == "I" and "We" or "You")
                    if T.BondKind(c.person) == "close" and OthersAt(t2) then who = Party(t1, t2, true) end
                    if teller.base.I ~= "I" then moves = moves:gsub("our hearthstones", "your hearthstones") end
                    local dest = (c.Place or function(z) return "{p:" .. Clean(z) .. "}" end)(z2)
                    -- ("took our hearthstones home" ends where home is; else the moves end in the line's land)
                    local tail = moves:find("hearthstones home$") and "" or (" to " .. dest)
                    -- (round 27: a deed done in the field, "We gathered spider blood and bear hearts", came before the
                    -- trip that took it to the hand-in: the moves go after it)
                    local plainL = PlainOf(line)
                    local verb = plainL:match("^%a+ (%l+ed) ")
                    local FIELD = {gathered = true, killed = true, collected = true, hunted = true, slew = true, cleared = true, searched = true, cut = true, destroyed = true}
                    if verb and FIELD[verb] and not plainL:find("%. ") and plainL:sub(-1) == "." and not line:find("{p:", 1, true) then
                        out[n] = S.Carry(line, line:sub(1, -2) .. ", then " .. moves:gsub("^took our", "took " .. (teller.base.I == "I" and "our" or "your")) .. tail .. ".")
                    elseif T.BondKind(c.person) == "close" and moves:find(" and ", 1, true) and MoveNouns(t1, t2) and tail ~= "" then
                        -- (a close bond's book says the same journey by its means, never the friend's words)
                        out[n] = S.Carry(line, "By " .. MoveNouns(t1, t2) .. ", " .. (who == "We" and "we" or who == "You" and "you" or who:gsub("^The ", "the ")) .. " came" .. tail .. ". " .. line)
                    else
                        out[n] = S.Carry(line, who .. " " .. moves .. tail .. ". " .. line)
                    end
                    S.Bridge = S.Bridge or {}; S.Bridge[out[n]] = true
                end
            end
        end
    end
    -- (round 20: a bare first after a crossing, a flight or the hearthstone is the arrival:
    -- "We crossed the sea and came to Westfall, new to me.", never "I had never yet set foot in Westfall.")
    if S.bonded then
        for n = 2, #out do
            local line = out[n]
            local low = PlainOf(line):lower()
            local place = line:match("({p:[^}]+})")
            if beats[n] == "shared" and place and (FirstTold(low) or low:find("had not been", 1, true) or low:find("strange country", 1, true))
                and CountWords(line) <= 14 and not line:find(",", 1, true) then
                local t1, t2 = nil, times[line]
                for m = n - 1, 1, -1 do if times[out[m]] then t1 = times[out[m]]; break end end
                local means, craft
                for _, x in ipairs(c.ownJournal or {}) do
                    if t1 and t2 and x.t and x.t > t1 and x.t <= t2 and CARRIED[x.k] then
                        local d = x.d or x.k
                        if d == "zeppelin" or d == "boat" then means = "sea"; craft = d
                        elseif x.k == "hearth" or d == "hearth" then means = means or "hearth"
                        elseif x.k == "taxi" or x.k == "nightflight" or d == "flight" then means = means or "flight" end
                    end
                end
                local at = line:find("{p:", 1, true)
                if at and line:sub(math.max(1, at - 4), at - 1):lower() == "the " then place = "the " .. place end
                local we = teller.base.I == "I"
                local Wew, me = we and "We" or "You", we and "me" or "you"
                local text
                local pair = Cap(teller.base.pairNamed)
                if OthersAt(t2) then pair = Party(t1, t2, true) end
                local close = T.BondKind(c.person) == "close"
                -- (round 25: the recorded moves in order when there were more than one)
                local moves = t1 and t2 and Moves(t1, t2)
                if moves and moves:find(" and ", 1, true) then
                    if not we then moves = moves:gsub("our hearthstones", "your hearthstones") end
                    means = "moves"
                    local nouns = MoveNouns(t1, t2)
                    text = close and nouns and (pair .. " came to " .. place .. " by " .. nouns .. ", and it was new to " .. me .. ".")
                        or (Wew .. " " .. moves .. ", and came to " .. place .. ", new to " .. me .. ".")
                end
                if means == "moves" then
                elseif means == "sea" and close then text = pair .. " took the " .. (craft or "ship") .. " across, and " .. place .. " was new to " .. me .. "."
                elseif means == "sea" then text = Wew .. " crossed the sea and came to " .. place .. ", new to " .. me .. "."
                elseif means == "flight" and close then text = pair .. " flew on, and " .. place .. " was new to " .. me .. "."
                elseif means == "flight" then text = Wew .. " flew on to " .. place .. ", new to " .. me .. "."
                elseif means == "hearth" then text = Wew .. " took " .. (we and "our" or "your") .. " hearthstones, and from there " .. (we and "we" or "you") .. " came to " .. place .. ", new to " .. me .. "." end
                if text then out[n] = S.Carry(line, text) end
            end
        end
    end
    -- (round 24: "Dahlia and I" twice a chapter at most as a sentence's subject; "we" carries the rest)
    do
        local pair = teller.base.pairNamed
        local used = 0
        for n = 1, #out do
            if beats[n] ~= "close" and beats[n] ~= "open" then
                local line = out[n]
                local newLine = line:gsub("(^)" .. Esc(Cap(pair)) .. " ", function(start)
                    used = used + 1
                    if used > 2 then return start .. (teller.base.I == "I" and "We " or "You ") end
                end)
                newLine = newLine:gsub("([%.!] )" .. Esc(Cap(pair)) .. " ", function(stop)
                    used = used + 1
                    if used > 2 then return stop .. (teller.base.I == "I" and "We " or "You ") end
                end)
                if newLine ~= line then out[n] = S.Carry(line, newLine) end
            end
        end
    end
    -- (round 25: the first flight told once: folded into the bat line beside it, "For a small fee Karos
    -- Razok put us on a bat ... It was the first flight Dahlia and I took together.")
    for n = 1, #out do
        local line = out[n]
        if line and PlainOf(line):find("my first flight", 1, true) then
            for m = n + 1, math.min(#out, n + 2) do
                local low = PlainOf(out[m]):lower()
                if low:find(" bat ", 1, true) or low:find(" bat%p") then
                    local pair = (T.BondKind(c.person) == "close") and teller.base.pairNamed or (teller.base.I == "I" and "we" or "you")
                    out[m] = S.Carry(out[m], out[m] .. " It was the first flight " .. pair .. " took together.")
                    table.remove(out, n); table.remove(beats, n)
                    break
                end
            end
        end
    end
    if not PB.firstTwo then return end
    local function Bare(line)
        local low = PlainOf(line):lower()
        if not (FirstTold(low) or low:find("neither of", 1, true)) or low:find("raise", 1, true) or low:find(" rose", 1, true) then return nil end
        -- (the part before any comma says the first itself: not "We took the zeppelin to Kalimdor, where ...")
        local head = PlainOf(line):match("^[^,]*"):lower()
        if not (FirstTold(head) or head:find("neither of", 1, true)) then return nil end
        local places = {}
        for at, p in line:gmatch("()({p:[^}]+})") do
            if line:sub(math.max(1, at - 4), at - 1):lower() == "the " then p = "the " .. p end
            places[#places + 1] = p
        end
        if #places ~= 1 or line:find("{[nq]:") or CountWords(line) > 16 then return nil end
        local body, tail = line, ""
        local at = line:find(",", 1, true)
        if at then body, tail = line:sub(1, at - 1) .. ".", line:sub(at, -2) end
        if CountWords(body) > 12 or tail:find("{p:", 1, true) then return nil end
        return places[1], tail
    end
    local n = 1
    while n < #out do
        local a, ta = Bare(out[n])
        local b, tb = Bare(out[n + 1])
        if a and b and beats[n] == "shared" and beats[n + 1] == "shared" and a ~= b then
            tokens.a, tokens.b = a, b
            local line = teller:Say("firstTwo", PB.firstTwo, rng, tokens)
            if line then
                line = line:gsub("%.$", "") .. (ta ~= "" and ta or tb) .. "."
                if c.ours then line = T.Ours(line, teller.base.I == "I", teller.base.name, true) end
                out[n] = S.Carry(out[n], line)
                table.remove(out, n + 1); table.remove(beats, n + 1)
            end
        end
        n = n + 1
    end
end
-- A fire the two sat by stays in a close bond's chapter (one a chapter): it is the companionship.
function T.KeepFire(c, l, already)
    return not already and T.BondKind(c.person) == "close" and l.t ~= nil
end
-- c: out, beats, times (line -> time), S, f, day, person, teller, PB, rng, tokens, ownJournal,
-- stretches (the companion's record as zone stays), Place, history, mainZone. Rewrites out and
-- beats in place, keeps S.EP (line -> episode index) for the paragraphs, and returns the day.
function T.Compose(c)
    local E = A.JournalEpisodes
    if T.COMPOSE == false or not (E and E.Day) or not c or #(c.out or {}) == 0 then return nil end
    local ok, D = pcall(E.Day, c.stretches or {})
    if not ok or type(D) ~= "table" or #(D.episodes or {}) == 0 then
        c.S.composeWhy = (not ok and ("day: " .. tostring(D))) or ("no episodes from " .. #(c.stretches or {}) .. " stretches")
        return nil
    end
    local out, beats, times, S, f, teller, PB, rng, tokens = c.out, c.beats, c.times, c.S, c.f, c.teller, c.PB, c.rng, c.tokens
    local Place = c.Place or function(n) return "{p:" .. Clean(n) .. "}" end
    local name = teller.base.name
    local episodes = D.episodes
    local function EpisodeAt(t)
        for _, ep in ipairs(episodes) do if t >= ep.t and t < ep.until_ then return ep end end
        if t < episodes[1].t then return episodes[1] end
        return episodes[#episodes]
    end
    -- 1. every line to its episode, by its stamp; one without a stamp stays with the line before
    local lines, lastT = {}, episodes[1].t
    for n = 1, #out do
        local line = out[n]
        local t, ep = times[line], nil
        local run = S.R[line]
        if run then
            for _, x in ipairs(episodes) do
                if x.kind == "dungeon" and x.run and Clean(x.run.dungeon) == Clean(run.name or "") then ep = x end
            end
        end
        if not t and (beats[n] == "level" or beats[n] == "levelMark") then
            local plain = PlainOf(line)
            local num = tonumber(plain:match("[Ll]evel (%d+)"))
            if num and f.myLevelT and f.myLevel == num then t = f.myLevelT
            elseif num and f.levelT and f.levels and f.levels[#f.levels] == num then t = f.levelT
            else t = f.myLevelT or f.levelT end
            if t then times[line] = t end
        end
        if not t then t = lastT end
        lastT = t
        lines[n] = {n = n, text = line, beat = beats[n] or "", t = t, ep = ep or EpisodeAt(t), run = run}
    end
    local function Kept(pred) for _, l in ipairs(lines) do if not l.drop and pred(l) then return true end end return false end
    local work = Kept(function(l) return WORK_BEATS[l.beat] or l.run end)
    local function Rewrite(l, text) if text and text ~= l.text then l.text = S.Carry(l.text, text) end end
    -- 2. the furniture
    local fireKept = false
    for _, l in ipairs(lines) do
        local low = PlainOf(l.text):lower()
        local e, me = S.D[l.text], S.ME[l.text]
        if l.n == 1 or l.run or l.beat == "close" then
        elseif l.beat == "death" and e and e.w ~= "you" then
            -- (the companion's death with nothing around it, or inside a city: not told)
            local near = false
            for _, x in ipairs(f.deaths) do if x.w == "you" and math.abs((x.t or 0) - (e.t or 0)) <= 5 * 60 then near = true end end
            -- (more than one fall at that moment is a bad moment, told: "killed twice")
            for _, x in ipairs(f.deaths) do if x ~= e and math.abs((x.t or 0) - (e.t or 0)) <= 15 * 60 then near = true end end
            for _, q in ipairs(f.quests) do if math.abs((q.t or 0) - (e.t or 0)) <= 5 * 60 then near = true end end
            for _, d in ipairs(f.dungeons) do
                for _, ev in ipairs(d.events) do if ev.k == "boss" and math.abs((ev.t or 0) - (e.t or 0)) <= 5 * 60 then near = true end end
            end
            -- (round 27: a bonded book tells every fall of the companion's own journal, alone or in a city too)
            if false then
                if l.text:find(" while %a+ were out%.$") then
                    -- (away only when the record had me in another land at that minute)
                    local here
                    for _, x in ipairs(c.ownJournal or {}) do if x.k == "play" and x.z and (x.t or 0) <= (e.t or 0) and (x.e or x.t or 0) >= (e.t or 0) then here = x.z end end
                    local away = here and e.z and Clean(here) ~= Clean(e.z)
                    Rewrite(l, (l.text:gsub(" while %a+ were out%.$", away and (", away from " .. teller.base.me .. ".") or ".")))
                end
            elseif not near or IsCity(e.z or S.Z[l.text]) then l.drop = true end
        elseif l.beat == "rest" and work and not low:find("first", 1, true) and not T.KeepFire(c, l, fireKept) then
            l.drop = true
        elseif l.beat == "rest" and work and not low:find("first", 1, true) then
            fireKept = true
        elseif me and me.k == "cave" then
            -- (a cave is a mouth unless something happened down there within ten minutes)
            local inside = false
            for _, x in ipairs(f.deaths) do if x.w == "you" and (x.t or 0) > l.t and (x.t or 0) - l.t <= 10 * 60 then inside = true end end
            for _, q in ipairs(f.quests) do if (q.t or 0) > l.t and (q.t or 0) - l.t <= 10 * 60 then inside = true end end
            -- (or the work handed in after it in the same land, with no other land between: the
            -- shackles from the worgen of North Tide's Hollow, lane C8)
            for _, q in ipairs(f.quests) do
                local qt = q.t or 0
                if not inside and qt > l.t and qt - l.t <= 40 * 60 and me.z and q.z == me.z then
                    local away = false
                    for _, x in ipairs(c.ownJournal or {}) do
                        if x.k == "play" and x.z and x.z ~= me.z and (x.t or 0) > l.t and (x.t or 0) < qt then away = true end
                    end
                    if not away then inside = true end
                end
            end
            if not inside then l.drop = true end
        elseif l.beat == "shared" and me and (me.k == "nightflight" or me.k == "voyage" or (me.k == "first" and (me.d == "flight" or me.d == "zeppelin" or me.d == "boat")))
            and not FirstTold(low) then
            -- (a going is told when it led to something told within the hour, somewhere else)
            local leads = false
            for _, x in ipairs(lines) do
                if x ~= l and not x.drop and x.t > l.t and x.t - l.t <= 60 * 60 and (WORK_BEATS[x.beat] or x.run)
                    and S.Z[x.text] and S.Z[x.text] ~= S.Z[l.text] then leads = true end
            end
            if not leads then l.drop = true end
        elseif l.beat == "day" and work then
            if low:find("quests", 1, true) or low:find("quest there", 1, true) or low:find("quest during", 1, true) then
                l.drop = true
                -- (the place it named is named by nothing before the work: "The night began in X" keeps it)
                local z = l.text:match("{p:([^}]+)}")
                local key = z and Clean(z):gsub("^[Tt]he ", ""):match("^(%S+)")
                local before = false
                for _, x in ipairs(lines) do
                    if x ~= l and not x.drop and x.n < l.n and key and x.text:find(key, 1, true) then before = true end
                end
                if key and not before and PB.beganPlain then
                    tokens.part, tokens.zoneD = PartOf(Hour(D.t or l.t)), "{p:" .. z .. "}"
                    if teller.saidPlaces then teller.saidPlaces[key] = nil end
                    local line = teller:Say("beganPlain", PB.beganPlain, rng, tokens)
                    if line then Rewrite(l, line); l.drop = false end
                end
            else
                -- ("That night you were in Silverpine Forest for about an hour": the close says how long)
                Rewrite(l, (l.text:gsub(" for [%a ]- hours?%.$", "."):gsub(" for [%a ]- minutes%.$", "."):gsub(" for a short while%.$", ".")))
            end
        end
    end
    -- 3. the opener names the companion and the place the close answers
    do
        local l = lines[1]
        local low = PlainOf(l.text):lower()
        local from = D.fromZone or (c.stretches[1] and c.stretches[1].zone) or c.mainZone
        -- ("The day took you to Stormwind City": a going with no one in it; the opener names the companion)
        local bare = l.beat == "open" and CountWords(l.text) <= 9 and not l.text:find("{n:", 1, true)
            and (low:find("^the day took ") or low:find("^the evening took ") or low:find("^the night took "))
        if (l.beat == "day" or bare) and work and not l.text:find(name, 1, true) and PB.beganIn and from then
            tokens.part, tokens.zoneD = PartOf(Hour(D.t or l.t)), Place(from)
            -- (the line it replaces named the place: not said any more)
            local key = Clean(from):gsub("^[Tt]he ", ""):match("^(%S+)")
            if key and teller.saidPlaces then teller.saidPlaces[key] = nil end
            Rewrite(l, teller:Say("beganIn", PB.beganIn, rng, tokens))
        elseif l.beat == "day" and work and (low:find(" hours", 1, true) or low:find(" hour%.") or low:find(" minutes", 1, true)) then
            -- ("You and Dahlia spent nearly four hours in Tirisfal Glades": the span is the close's)
            local part = PartOf(Hour(D.t or l.t))
            local text = l.text:gsub("^(.-) spent [%a ]- hours? together in ", "%1 began the " .. part .. " together in ", 1)
                :gsub("^(.-) spent [%a ]- hours? in ", "%1 began the " .. part .. " in ", 1)
                :gsub("^(.-) spent [%a ]- minutes together in ", "%1 began the " .. part .. " together in ", 1)
                :gsub("^(.-) spent [%a ]- minutes in ", "%1 began the " .. part .. " in ", 1)
            text = text:gsub(" for [%a ]- hours?%.$", "."):gsub(" for [%a ]- minutes%.$", ".")
            Rewrite(l, text)
        end
    end
    -- (a first meeting with next to nothing shared: what the record has, not "a short while together")
    for _, l in ipairs(lines) do
        if not l.drop and l.beat == "day" and PlainOf(l.text):lower():find("a short while", 1, true) and PB.metBrief then
            local level = f.plStart or f.plEnd
            if level then
                local h = Hour(D.t or l.t)
                tokens.clock = (h < 5 and "past midnight") or (h == 23 and "near midnight") or false
                tokens.mine = level
                local pool = (tokens.clock and PB.metBriefClock) or PB.metBrief
                Rewrite(l, teller:Say("metBrief", pool, rng, tokens))
            end
        end
    end
    -- 4. the others of the party: named only when the chapter shows them doing something
    local function Named(who, except)
        for _, x in ipairs(lines) do
            if not x.drop and x ~= except and x.text:find("{n:" .. who .. "}", 1, true) then return true end
        end
        return false
    end
    local function Forget(who)
        local said = c.history and c.history.othersSaid
        if type(said) ~= "table" then return end
        for key in pairs(said) do if (Clean(key):gsub("%-.*$", "")) == who then said[key] = nil end end
    end
    -- (round 13: in a bonded book a listed companion who was in the party is named all the same:
    -- "Marrow went with us"; strangers still only when the chapter shows them)
    local function Listed(w)
        if T.BondKind(c.person) == "plain" then return false end
        for _, p in pairs(A.db and A.db.people or {}) do
            if type(p) == "table" and p.name and (Clean(p.name):gsub("%-.*$", "")) == w then return true end
        end
        return false
    end
    T.Listed = Listed
    for _, l in ipairs(lines) do
        if not l.drop and l.n > 1 and l.beat == "shared" and OthersLine(l.text) then
            local who, shown, gone = {}, {}, {}
            for w in l.text:gmatch("{n:([^}]+)}") do
                if "{n:" .. w .. "}" ~= name then
                    who[#who + 1] = w
                    if Named(w, l) or Listed(w) then shown[#shown + 1] = w else gone[#gone + 1] = w end
                end
            end
            if #who > 0 and #shown == 0 then l.drop = true; for _, w in ipairs(gone) do Forget(w) end
            elseif #gone > 0 and #shown > 0 then
                -- (the ones the chapter shows stay: "Varreth was there too")
                local tail = l.text:match("(came along too%.)$") or l.text:match("(there too%.)$") or l.text:match("(filled out the party%.)$")
                    or l.text:match("(in the party as well%.)$")
                if tail then
                    local names = {}
                    for _, w in ipairs(shown) do names[#names + 1] = "{n:" .. w .. "}" end
                    if tail == "there too." or tail == "in the party as well." then tail = (#names > 1 and "were " or "was ") .. tail end
                    Rewrite(l, List(names) .. " " .. tail)
                    for _, w in ipairs(gone) do Forget(w) end
                end
            end
        end
    end
    -- (a first told twice: a later line that only says a place was new, once an earlier one said it)
    do
        local firstSaid = {}
        local ordered = {}
        for _, l in ipairs(lines) do if not l.drop then ordered[#ordered + 1] = l end end
        table.sort(ordered, function(a, b) if a.t ~= b.t then return a.t < b.t end return a.n < b.n end)
        for _, l in ipairs(ordered) do
            local low = PlainOf(l.text):lower()
            if (l.beat == "shared" or l.n == 1 or SETTING_BEATS[l.beat]) and FirstTold(low) and not low:find("raise", 1, true) and not low:find(" rose", 1, true) then
                local key = l.text:match("{p:([^}]+)}") or S.Z[l.text]
                key = key and Clean(key):gsub("^[Tt]he ", ""):match("^(%S+)")
                if key then
                    if firstSaid[key] and l.beat == "shared" and CountWords(l.text) <= 12 then l.drop = true else firstSaid[key] = true end
                end
            end
        end
    end
    -- (a going told last, with nothing told after it but the close: the close says where the night ended)
    for _, l in ipairs(lines) do
        local me = S.ME[l.text]
        if not l.drop and l.n > 1 and l.beat == "shared" and me and (me.k == "nightflight" or me.k == "voyage") and not FirstTold(PlainOf(l.text):lower()) then
            local after = false
            for _, x in ipairs(lines) do
                if x ~= l and not x.drop and x.t > l.t and x.beat ~= "close" and not x.toClose and not S.R[x.text] and x.beat ~= "level" then after = true end
            end
            if not after then l.drop = true end
        end
    end
    do
        local l = lines[1]
        local fold = l.text:match(", with (.-) along%.$")
        if fold then
            local any, who = false, {}
            for w in fold:gmatch("{n:([^}]+)}") do who[#who + 1] = w; if Named(w, l) or Listed(w) then any = true end end
            if not any and #who > 0 then
                Rewrite(l, (l.text:gsub(", with .- along%.$", ".")))
                for _, w in ipairs(who) do Forget(w) end
            end
        end
    end
    -- 5. a level as a clause of the deed it came with, else once before the close
    for _, l in ipairs(lines) do
        local runsLevel = false
        for _, d in ipairs(f.dungeons or {}) do
            local lastT = d.t or 0
            for _, ev in ipairs(d.events or {}) do lastT = math.max(lastT, ev.t or 0) end
            if l.t >= lastT - 60 and l.t - lastT <= 45 * 60 then runsLevel = true end
        end
        local inRun
        for _, d in ipairs(f.dungeons or {}) do
            local lastT = d.t or 0
            for _, ev in ipairs(d.events or {}) do lastT = math.max(lastT, ev.t or 0) end
            if l.t >= (d.t or 0) - 60 and l.t < lastT - 60 and #(d.events or {}) > 0 then inRun = d end
        end
        -- (a milestone under sixty is a level like any other here: never a bare line of its own)
        local isLevel = l.beat == "level" or (l.beat == "levelMark" and not PlainOf(l.text):find("60", 1, true) and not PlainOf(l.text):lower():find("sixty", 1, true))
        if not l.drop and not l.run and isLevel and inRun and not runsLevel then
            -- (the run's level, in the run's paragraph, before what the lord's fall meant)
            local plain = PlainOf(l.text)
            local theirs = l.text:find(name, 1, true) ~= nil
            local kind = (plain:find("both", 1, true) or plain:find("together", 1, true) or plain:find("pair of", 1, true)) and "both"
                or (theirs and "theirs") or "mine"
            local pool = (kind == "both" and PB.runLevelBoth) or (kind == "theirs" and PB.runLevelTheirs) or PB.runLevelMine
            local okLevel = (kind == "both" and tokens.theirs and tokens.mine and tostring(tokens.theirs) == tostring(tokens.mine))
                or (kind == "theirs" and tokens.theirs and not plain:find(" and ", 1, true))
                or (kind == "mine" and tokens.mine and not plain:find(" and ", 1, true))
            if pool and okLevel then
                local plainPool = {}
                for _, line in ipairs(pool) do if not line:find("{runPlace}", 1, true) then plainPool[#plainPool + 1] = line end end
                tokens.runPlace = Place(inRun.name)
                local line = teller:Say("runLevel", #plainPool > 0 and plainPool or pool, rng, tokens)
                if line then
                    Rewrite(l, line)
                    S.R[l.text] = inRun
                    l.run, l.runLevel = inRun, true
                    for _, x in ipairs(episodes) do
                        if x.kind == "dungeon" and x.run and Clean(x.run.dungeon) == Clean(inRun.name or "") then l.ep = x end
                    end
                end
            end
        elseif not l.drop and not l.run and isLevel and l.ep.kind ~= "dungeon" and not runsLevel and PB.levelClause and PB.levelByEnd then
            local plain = PlainOf(l.text)
            local theirs = l.text:find(name, 1, true) ~= nil
            local kind = (plain:find("both", 1, true) or plain:find("together", 1, true) or plain:find("pair of", 1, true)) and "both"
                or (theirs and "theirs") or "mine"
            local okLevel = (kind == "both" and tokens.theirs and tokens.mine and tostring(tokens.theirs) == tostring(tokens.mine))
                or (kind == "theirs" and tokens.theirs and not plain:find(" and ", 1, true))
                or (kind == "mine" and tokens.mine and not plain:find(" and ", 1, true))
            if okLevel and PB.levelClause[kind] and PB.levelByEnd[kind] then
                local deed
                for _, x in ipairs(lines) do
                    if not x.drop and not x.run and x ~= l and WORK_BEATS[x.beat] and x.t <= l.t and l.t - x.t <= 10 * 60 and (not deed or x.t > deed.t) then deed = x end
                end
                local last = deed and (deed.text:match("([^%.]+%.)$") or deed.text)
                if deed and last and deed.text:sub(-1) == "." and not last:find(", and ", 1, true) and CountWords(last) <= 30 then
                    local clause = teller:Say("levelClause", PB.levelClause[kind], rng, tokens)
                    if clause then
                        clause = clause:gsub("%.$", "")
                        if not clause:find("^{n:") and not clause:match("^I ") then clause = clause:gsub("^%u", string.lower) end
                        Rewrite(deed, deed.text:sub(1, -2) .. ", and " .. clause .. ".")
                        l.drop = true
                    end
                else
                    local line = teller:Say("levelByEnd", PB.levelByEnd[kind], rng, tokens)
                    if line then Rewrite(l, line); l.toClose = true end
                end
            end
        end
    end
    -- 5b. the road and the company (lane C8): a long walk as one paragraph; strangers as a small adventure
    T.ComposeRoad(c, lines, EpisodeAt, Place)
    T.ComposeCompany(c, lines, EpisodeAt, Place)
    T.ComposeRegister(c, lines, episodes)
    T.ComposeBond(c, lines)
    T.ComposeTogether(c, lines)
    -- 6. the order: the first line, then each episode's setting, then its lines by time; the close last
    local kept = {}
    for _, l in ipairs(lines) do if not l.drop then kept[#kept + 1] = l end end
    if #kept == 0 then return D end
    local function Slot(l)
        if l.beat == "close" then return 9 end
        if l.toClose then return 8 end
        -- (what a run left unfinished, "the nightmare had not been broken", follows the run)
        if l.beat == "again" then
            for _, d in ipairs(f.dungeons or {}) do if l.t >= (d.t or 0) then return 2 end end
        end
        -- (where the day was comes before what the place was like)
        if l.beat == "day" then return -0.5 end
        if SETTING_BEATS[l.beat] then return 0 end
        -- (round 14: in a bonded book one who joined is told where he joined, in time order)
        if l.beat == "shared" and OthersLine(l.text) and not S.bonded then return 1 end
        return 2
    end
    for _, l in ipairs(kept) do
        l.slot = Slot(l)
        l.epIndex = (l.slot >= 8) and (#episodes + 1) or l.ep.index
        l.key = l.run and (l.ep.t + l.n / 100000) or l.t
    end
    -- (the run's level stands before what the lord's fall meant, else after the run's last line)
    for _, l in ipairs(kept) do
        if l.runLevel then
            local at, last
            for _, x in ipairs(kept) do
                if x ~= l and x.run == l.run then
                    if x.beat == "consequence" and (not at or x.n < at) then at = x.n end
                    if not last or x.n > last then last = x.n end
                end
            end
            l.key = l.ep.t + ((at and (at - 0.5)) or ((last or l.n) + 0.5)) / 100000
        end
    end
    -- (the chapter's own first line stays first; a line that only came first because the opener went does not)
    if kept[1].n == 1 then kept[1].epIndex, kept[1].slot = 0, 0 end
    table.sort(kept, function(a, b)
        if a.epIndex ~= b.epIndex then return a.epIndex < b.epIndex end
        if a.slot ~= b.slot then return a.slot < b.slot end
        if a.key ~= b.key then return a.key < b.key end
        return a.n < b.n
    end)
    for n = #out, 1, -1 do out[n], beats[n] = nil, nil end
    S.EP = S.EP or {}
    for n, l in ipairs(kept) do
        out[n], beats[n] = l.text, l.beat
        -- (round 13: a line the composer added, the road's, keeps its time for what follows it)
        if times[l.text] == nil and l.t then times[l.text] = l.t end
        S.EP[l.text] = (l.slot >= 8) and (#episodes) or l.ep.index
        if l.whole then S.Whole = S.Whole or {}; S.Whole[l.text] = true; S.EP[l.text] = l.whole end
    end
    -- ("Then ..." opened the chapter once the line before it went)
    if out[1] then out[1] = S.Carry(out[1], Cap((out[1]:gsub("^Then,? ", ""):gsub("^Before long,? ", "")))) end
    -- 7. a hand-in told somewhere else than the line before says where ("In the Undercity, Varimathras
    -- told you..."; "Back in" when the chapter was there already); the places said are the kept lines'
    local said = {}
    local function Key(z) return z and Clean(z):gsub("^[Tt]he ", ""):match("^(%S+)") or nil end
    for n = 1, #out do
        local line = out[n]
        local z, prevZ = S.Z[line], S.Z[out[n - 1] or ""]
        local key = Key(z)
        if n >= 2 and beats[n] == "shared" and key and Key(prevZ) ~= key and FirstTold(PlainOf(line):lower()) and not PlainOf(line):find(key, 1, true)
            and (line:find(" there%.$") or line:find(" there before", 1, true) or line:find(" there,", 1, true)) then
            out[n] = S.Carry(line, (line:gsub(" there(%p)", " in " .. Place(z) .. "%1", 1):gsub(" there before", " in " .. Place(z) .. " before", 1)))
            line = out[n]
        end
        local w0 = line:match("^(%a+)")
        local NOLEAD = {That = true, This = true, It = true, There = true, Then = true, Nobody = true, Nothing = true, I = true, Also = true, Only = true}
        if n >= 2 and (beats[n] == "questKey" or beats[n] == "quests") and key and Key(prevZ) ~= key and not (S.NoLead and S.NoLead[line])
            and not T.PlaceLed(line) and not PlainOf(line):find(key, 1, true) and not (w0 and NOLEAD[w0])
            and not line:find("{p:", 1, true) then
            local lead = said[key] and "Back in " or "In "
            local w = line:match("^(%a+)")
            local SMALL = {}
            for word in ("You We The A An Your Our It There Then For With After Before On At In By From When While Back Once Later That This These "
                .. "Those He She They His Her Their Nobody Nothing Someone Something Each Every Both All Some One Two Three Not"):gmatch("%a+") do SMALL[word] = true end
            local rest = (w and SMALL[w]) and line:gsub("^%u", string.lower) or line
            out[n] = S.Carry(line, lead .. Place(z) .. ", " .. rest)
            line = out[n]
        end
        for place in line:gmatch("{p:([^}]+)}") do local k = Key(place); if k then said[k] = true end end
    end
    if teller.saidPlaces then
        for k in pairs(teller.saidPlaces) do teller.saidPlaces[k] = nil end
        for k in pairs(said) do teller.saidPlaces[k] = true end
    end
    T.ComposeTogetherAfter(c, out, beats)
    S.Day = D
    return D
end
-- The paragraphs of a composed chapter: one an episode (S.EP), a dungeon run kept whole as the
-- run pass grouped it, a light paragraph joined to its neighbour, a long one split at a turn
-- (a death after none, a hand-in, a change of place) nearest its middle, eight at most.
-- Returns the groups table T.Paragraphs reads (line index -> key), or the run groups alone.
-- (round 26) The record-order verifier of a companion chapter. Every told line carries its record
-- minute (times[line]); a line with none goes with the line before it. Fixed: the opening, the land,
-- the closing lines and the level said "by the end"; lines marked S.Pre (a set-up) may stand before
-- their time. T.OrderFaults lists every other line told before a line it came after (a minute's slack);
-- T.SortByRecord moves each such line back to its minute.
T.ORDER_VERIFY = true
-- (round 28) "Dahlia fell there too" after a move: "there" names the fall's own land from the record.
function T.PlaceFalls(out, beats, S)
    for n, line in ipairs(out) do
        local e = S.D and S.D[line]
        if beats[n] == "death" and e and e.z and not line:find("{p:", 1, true) then
            local new = line:gsub(" there too%.$", " too, in {p:" .. Clean(e.z) .. "}."):gsub(" there as well%.$", " as well, in {p:" .. Clean(e.z) .. "}.")
            if new ~= line then out[n] = S.Carry(line, new) end
        end
    end
end
-- (round 30) A wipe leaves nobody out: another of the party who fell in the same minute, from my own
-- record, is named beside it ("Marrow fell with us.").
function T.WipeOthers(out, beats, S, ownJournal, person, teller)
    if type(ownJournal) ~= "table" then return end
    local mine = Clean(person and person.name or ""):gsub("%-.*$", ""):lower()
    for n, line in ipairs(out) do
        local e = S.D and S.D[line]
        local lowL = PlainOf(line):lower()
        local counted = lowL:find("twice", 1, true) or lowL:find("times", 1, true) or lowL:find(" each", 1, true) or lowL:find("apiece", 1, true) or lowL:find("once", 1, true)
        if beats[n] == "death" and e and e.t and not counted and not lowL:find(" rose", 1, true) and not lowL:find("raised", 1, true) then
            local names, seen = {}, {}
            for _, x in ipairs(ownJournal) do
                if x.k == "pdeath" and x.n and x.t and math.abs(x.t - e.t) <= 90 and (not e.z or not x.z or Clean(x.z) == Clean(e.z)) then
                    local first = (Clean(x.n):gsub("%-.*$", ""))
                    if first:lower() ~= mine and not seen[first] and not PlainOf(line):find(first, 1, true) then seen[first] = true; names[#names + 1] = first end
                end
            end
            if #names == 1 and line:sub(-1) == "." then
                out[n] = S.Carry(line, line .. " {n:" .. names[1] .. "} fell with " .. (teller.base.I == "I" and "us" or "you") .. ".")
            end
        end
    end
end
-- (round 30) A list line whose clauses other lines of the chapter tell in full keeps only the clauses
-- told nowhere else ("For Allister, we took the pendants ..., put down the Ravenclaw undead in Beren's
-- Peril and culled Dalaran's watchers ..." beside the pendants' and the roads' own scenes), or goes.
function T.TrimToldClauses(out, beats, S)
    local function W(text)
        local w, n = {}, 0
        for x in PlainOf(text):lower():gmatch("[%a']+") do if #x >= 4 and not w[x] then w[x] = true; n = n + 1 end end
        return w, n
    end
    local n = 1
    while n <= #out do
        local line = out[n]
        local plain = PlainOf(line)
        local head, body = plain:match("^(.-[Ww]e )(.+)%.$")
        if not head then head, body = plain:match("^(.-[Yy]ou )(.+)%.$") end
        local qs = S.Qs and S.Qs[line]
        if (beats[n] == "questKey" or beats[n] == "quests") and head and not body:find("%. ") and qs and #qs >= 2 and not S.R[line] then
            -- (the clauses: split at commas, and at " and " before a verb of deed)
            local VERB = {took = true, brought = true, put = true, cut = true, fought = true, found = true, went = true, slew = true, made = true, gave = true, tore = true, carried = true}
            local parts = {}
            for seg in (body .. ", "):gmatch("(.-), ") do
                local rest = seg
                while true do
                    local a, v, b = rest:match("^(.-) and (%l+)( .*)$")
                    if a and (VERB[v] or v:find("ed$")) then parts[#parts + 1] = a; rest = v .. b else break end
                end
                parts[#parts + 1] = rest
            end
            if #parts == #qs then
                local keep = {}
                for _, part in ipairs(parts) do
                    local w, cnt = W(part)
                    local told = false
                    for m, other in ipairs(out) do
                        if m ~= n and cnt >= 3 then
                            local ow = W(other)
                            local hit = 0
                            for x in pairs(w) do if ow[x] then hit = hit + 1 end end
                            if hit / cnt >= 0.6 then told = true end
                        end
                    end
                    if not told then keep[#keep + 1] = part end
                end
                if #keep == 0 then
                    table.remove(out, n); table.remove(beats, n); n = n - 1
                elseif #keep < #parts then
                    local list = #keep == 1 and keep[1] or (table.concat(keep, ", ", 1, #keep - 1) .. " and " .. keep[#keep])
                    -- (the line keeps its own markup only where the words are the same: rebuilt plain)
                    out[n] = S.Carry(line, head .. list .. ".")
                end
            end
        end
        n = n + 1
    end
end
-- (round 27) The companion's falls as prose, not a roll call: a short "Marrow went down again." or
-- "Marrow fell there too." right after a fall is joined to it ("..., and he went down again"), and a bare
-- "Marrow died." says where, from the record.
function T.JoinFalls(out, beats, S, teller)
    local name = PlainOf(teller.base.name or "")
    if name == "" then return end
    local they = teller.base.they or "they"
    local n = 2
    while n <= #out do
        local line, prev = out[n], out[n - 1]
        local plain = PlainOf(line)
        local rest = plain:match("^" .. name .. " (went down again)%.$") or plain:match("^" .. name .. " (fell again)%.$")
            or plain:match("^" .. name .. " (fell there too)%.$") or plain:match("^" .. name .. " (died there as well)%.$")
            or plain:match("^" .. name .. " (went down there too)%.$")
        if rest and beats[n] == "death" and beats[n - 1] == "death" and prev:sub(-1) == "." and not S.R[line] and not S.R[prev] then
            local joint = PlainOf(prev):find(", and ", 1, true) and (" before " .. they .. " ") or (", and " .. they .. " ")
            out[n - 1] = S.Carry(prev, prev:sub(1, -2) .. joint .. rest .. ".")
            table.remove(out, n); table.remove(beats, n)
        else
            local e = S.D and S.D[line]
            if beats[n] == "death" and plain == name .. " died." and e and e.z then
                out[n] = S.Carry(line, line:sub(1, -2) .. " in {p:" .. Clean(e.z) .. "}.")
            end
            n = n + 1
        end
    end
end
local FIXED_BEAT = {open = true, day = true, land = true, close = true}
local function Fixed(line, beat, S)
    if FIXED_BEAT[beat or ""] then return true end
    if (beat == "level" or beat == "levelMark") and PlainOf(line):find("by the end", 1, true) then return true end
    return S.Pre and S.Pre[line] or false
end
-- (round 28: a line that tells several hand-ins stands at the last of them)
local function LineTime(l, times, S)
    local t = times[l]
    for _, q in ipairs(S.Qs and S.Qs[l] or {}) do if t and q.t and q.t > t then t = q.t end end
    return t
end
T.LineTime = LineTime
function T.OrderFaults(out, beats, times, S)
    local faults, last, lastLine = {}, nil, nil
    for n, l in ipairs(out) do
        local t = LineTime(l, times, S)
        if t and not Fixed(l, beats[n], S) and not (S.R and S.R[l]) then
            if last and t < last - 60 then faults[#faults + 1] = {n = n, line = l, t = t, after = lastLine, afterT = last} end
            if not last or t > last then last, lastLine = t, l end
        end
    end
    return faults
end
function T.SortByRecord(out, beats, times, S)
    for _ = 1, #out do
        local faults = T.OrderFaults(out, beats, times, S)
        local f = faults[1]
        if not f then return end
        local n, t = f.n, f.t
        -- (the line and the untimed lines after it go together)
        local stop = n
        while stop < #out and not times[out[stop + 1]] and not Fixed(out[stop + 1], beats[stop + 1], S) do stop = stop + 1 end
        -- (to before the first movable line told later than it; set-ups and a run stay with what they lead)
        local at
        for m = 1, n - 1 do
            local tm = LineTime(out[m], times, S)
            if tm and tm > t + 60 and not Fixed(out[m], beats[m], S) then at = m; break end
        end
        if not at then return end
        while at > 1 and S.R[out[at]] and S.R[out[at - 1]] == S.R[out[at]] do at = at - 1 end
        while at > 1 and S.Pre and S.Pre[out[at - 1]] do at = at - 1 end
        local moved, movedB = {}, {}
        for k = n, stop do moved[#moved + 1], movedB[#movedB + 1] = out[k], beats[k] end
        for k = stop, n, -1 do table.remove(out, k); table.remove(beats, k) end
        for k = #moved, 1, -1 do
            local line = moved[k]
            if k == 1 then
                local plain = line:gsub("^Then (%l)", function(x) return x:upper() end)
                if plain ~= line then line = S.Carry(moved[k], plain) end
            end
            table.insert(out, at, line); table.insert(beats, at, movedB[k])
        end
    end
end
function T.ComposeParagraphs(out, beats, S, runGroups)
    if not S or not S.EP or #out == 0 then return runGroups end
    local blocks, lastEp = {}, nil
    for n = 1, #out do
        local run = runGroups and runGroups[n]
        local ep = S.EP[out[n]] or lastEp or 1
        lastEp = ep
        local key = run or ep
        local b = blocks[#blocks]
        if not b or b.key ~= key then b = {key = key, run = run and true or false, lines = {}, words = 0}; blocks[#blocks + 1] = b end
        b.lines[#b.lines + 1] = n
        b.words = b.words + CountWords(out[n])
    end
    local function Merge(i, j)
        local a, b = blocks[i], blocks[j]
        for _, n in ipairs(b.lines) do a.lines[#a.lines + 1] = n end
        a.words = a.words + b.words
        table.remove(blocks, j)
    end
    local changed = true
    while changed do
        changed = false
        for i, b in ipairs(blocks) do
            if not b.run and (b.words < T.MIN_WORDS or #b.lines <= 1) then
                local nxt, prev = blocks[i + 1], blocks[i - 1]
                -- (round 11: a paragraph that opens on a journey's bridge stays its own adventure)
                local bridged = S.Bridge and S.Bridge[out[b.lines[1]]]
                local nextBridged = nxt and S.Bridge and S.Bridge[out[nxt.lines[1]]]
                if nxt and not nxt.run and (not nextBridged or i == 1) and (b.words + nxt.words <= T.MAX_WORDS or b.words < T.MIN_WORDS / 2) then Merge(i, i + 1); changed = true; break
                elseif prev and not prev.run and not bridged then Merge(i - 1, i); changed = true; break end
            end
        end
    end
    while #blocks > T.MAX_PARAGRAPHS do
        local best, bi
        for i = 1, #blocks - 1 do
            if not blocks[i].run and not blocks[i + 1].run then
                local w = blocks[i].words + blocks[i + 1].words
                if not best or w < best then best, bi = w, i end
            end
        end
        if not bi then break end
        Merge(bi, bi + 1)
    end
    local i = 1
    while i <= #blocks do
        local b = blocks[i]
        local whole = false
        for _, n in ipairs(b.lines) do if S.Whole and S.Whole[out[n]] then whole = true end end
        if not b.run and not whole and b.words > T.MAX_WORDS and #b.lines >= 4 then
            local acc, bestAt, bestDist = 0, nil, nil
            for j = 1, #b.lines - 1 do
                local n, m = b.lines[j], b.lines[j + 1]
                acc = acc + CountWords(out[n])
                local nb = beats[m] or ""
                local turn = (nb == "death" and beats[n] ~= "death") or nb == "questKey" or nb == "quests" or nb == "questStart" or nb == "dungeon"
                    or (S.Z[out[m]] and S.Z[out[n]] and Clean(S.Z[out[m]]) ~= Clean(S.Z[out[n]]))
                if turn and acc >= T.MIN_WORDS and b.words - acc >= T.MIN_WORDS then
                    local dist = math.abs(acc - b.words / 2)
                    if not bestDist or dist < bestDist then bestAt, bestDist = j, dist end
                end
            end
            if bestAt then
                local tail = {key = tostring(b.key) .. "+", run = false, lines = {}, words = 0}
                for j = bestAt + 1, #b.lines do tail.lines[#tail.lines + 1] = b.lines[j]; tail.words = tail.words + CountWords(out[b.lines[j]]) end
                for j = #b.lines, bestAt + 1, -1 do b.lines[j] = nil end
                b.words = b.words - tail.words
                table.insert(blocks, i + 1, tail)
            end
        end
        i = i + 1
    end
    -- (round 10, a bonded book: a paragraph never opens on a death; the death closes the one before)
    if S.bonded then
        for i = #blocks, 2, -1 do
            local b, prev = blocks[i], blocks[i - 1]
            if not b.run and not prev.run and #b.lines >= 2 and beats[b.lines[1]] == "death" then
                local n = table.remove(b.lines, 1)
                prev.lines[#prev.lines + 1] = n
            end
        end
    end
    local groups = {}
    for k, b in ipairs(blocks) do
        local key = (b.run and runGroups and runGroups[b.lines[1]]) or ("p" .. k)
        for _, n in ipairs(b.lines) do groups[n] = key end
    end
    return groups
end

-- The two-pass telling (round 23). A bonded companion's book is told twice. Pass 1 tells it as it
-- stands and collects every quest each chapter told. From those it chooses the setups the payoffs
-- need: an earlier step of a told quest's thread, done while the companion was in the group, within
-- three days before, that no chapter told (Bethor reading the ichor before the scroll; Podrig's order
-- before the crate comes back; the ferry before the ring). Pass 2 tells the book again with those
-- steps required: the spine takes them whatever the own book did, and the spine budget keeps them.
local TellPasses
function T.Tell(person, days, voice, player, brief)
    if T.ownKeys then return TellPasses(person, days, voice, player, brief) end
    T.ownKeys = {}
    local ok, stories = pcall(TellPasses, person, days, voice, player, brief)
    T.ownKeys = nil
    if not ok then error(stories, 0) end
    return stories
end
function TellPasses(person, days, voice, player, brief)
    if brief or T.TWO_PASS == false or T.inPass or T.BondKind(person) == "plain" then
        return T.TellOnce(person, days, voice, player, brief)
    end
    T.inPass = true
    T.collect = {}
    local ok1, first = pcall(T.TellOnce, person, days, voice, player, brief)
    local collect = T.collect
    T.collect = nil
    T.inPass = false
    if not ok1 then return T.TellOnce(person, days, voice, player, brief) end
    local QD = A.QuestDeeds
    local needs = {}
    local told = {}
    for _, list in pairs(collect) do for _, q in ipairs(list) do if q.qid then told[q.qid] = true end end end
    local function Present(t)
        for _, x in ipairs(type(person.journal) == "table" and person.journal or {}) do
            if x.k == "group" and x.t and t >= x.t - 60 and t <= (x.e or x.t) + 60 then return true end
        end
        return false
    end
    local charKey = (player and player.charKey) or (A.Me and A.Me())
    local me = A.SelfPerson and A.SelfPerson(charKey)
    local own = me and me.journal or {}
    for _, list in pairs(collect) do
        for _, q in ipairs(list) do
            local st = QD and QD.Story and QD.Story(q)
            if st and st.thread and q.t then
                -- (the step just before it in its thread: the one the told scene stands on)
                -- (read only: the record's entries are never written to)
                local prev, prevSt
                for _, x in ipairs(own) do
                    if x.k == "quest" and x.qid and x.t and x.t < q.t - 30 and q.t - x.t <= 72 * 3600 and x.qid ~= q.qid then
                        local st2 = QD.Story({title = x.d, qid = x.qid})
                        if st2 and st2.thread == st.thread and (not prev or x.t > prev.t) then prev, prevSt = x, st2 end
                    end
                end
                if prev and not told[prev.qid] and Present(prev.t) and prevSt.pov then needs[prev.qid] = true end
            end
        end
    end
    -- (1.43.1: with nothing to require, pass 2 would tell the same book again; the first pass's book
    -- is it, word for word, since the first pass only collects)
    if next(needs) == nil then return first end
    T.needs = needs
    local ok2, stories = pcall(T.TellOnce, person, days, voice, player, brief)
    T.needs = nil
    if ok2 then return stories end
    return T.TellOnce(person, days, voice, player, brief)
end
function T.TellOnce(person, days, voice, player, brief)
    player = player or T.Player()
    local teller = Teller(person, voice, player)
    -- (lane C9 round 10: a quest's two point-of-view lines go one to a close bond's book, the other
    -- to a friend's, so two companion books of one evening never share the sentence)
    teller.deedOther = T.BondKind(person) ~= "friend"
    -- (the pack's setup and outcome prose belongs to the own book; this book tells the pair's
    -- side through A.QuestDeeds below, 2026-11-07)
    local L = setmetatable({QuestStory = function() return nil end, QuestBeats = function() return {} end}, {__index = A.Lore or {}})
    local function Place(name)
        local shown = Clean(L.Display and L.Display(name) or name)
        if A.SelfTale and A.SelfTale.Place and not shown:find("^[Tt]he ") and A.SelfTale.Article and A.SelfTale.Article(shown) then
            return "the {p:" .. shown .. "}"
        end
        return "{p:" .. shown .. "}"
    end
    local function ShortRaw(name) return "{p:" .. Clean(L.Short and L.Short(name) or name) .. "}" end
    -- A foe by name: named ones as they are, common ones with "a" ("a Hillsbrad Farmer").
    local function Foe(name, article)
        if not name then return "something in the dark" end
        -- (2026-11-11: the shared rule decides, the record's flag is a hint: "a Ragefire Trogg",
        -- "a Venture Co. Geologist", but "Bishop Jericho" and "Veni Lace")
        if A.FoeNamed then
            if A.FoeNamed(name, article) then return Place(name) end
            return A.FoeName(Clean(name), article):gsub("^(%a+) ", "%1 {p:") .. "}"
        end
        if article then return Article(name):gsub("^(%a+) ", "%1 {p:") .. "}" end
        local short = L.Short and L.Short(name)
        local named = (L.Boss and L.Boss(name)) or not name:find(" ") or name:find(" the ") or name:find("'s ")
            or (short and short ~= name and not name:match("^%u%l+ %u%l+$"))
        if named then return Place(name) end
        return Article(name):gsub("^(%a+) ", "%1 {p:") .. "}"
    end
    -- Your own journal (JournalSelf.lua): the time you spent alone before
    -- grouping, by day, for the chapter's first line now and then.
    local mySelf = A.SelfPerson and A.SelfPerson((player and player.charKey) or (A.Me and A.Me()))
    local ownJournal = mySelf and type(mySelf.journal) == "table" and mySelf.journal or nil
    local function AloneBefore(startT)
        if not ownJournal or not date then return nil end
        local dayKey = date("%Y-%m-%d", Evening(startT))
        local withs = {}
        for _, e in ipairs(ownJournal) do if e.k == "with" then withs[#withs + 1] = e end end
        local byZone, total = {}, 0
        for _, e in ipairs(ownJournal) do
            if e.k == "play" and e.t and e.t < startT and date("%Y-%m-%d", Evening(e.t)) == dayKey then
                local stop = math.min(e.e or e.t, startT)
                local company = false
                for _, w in ipairs(withs) do if (w.t or 0) < stop and (w.e or startT) > e.t then company = true end end
                if not company and stop > e.t and e.z then
                    byZone[e.z] = (byZone[e.z] or 0) + (stop - e.t)
                    total = total + (stop - e.t)
                end
            end
        end
        local zone, most = nil, 0
        for z, seconds in pairs(byZone) do if seconds > most then zone, most = z, seconds end end
        return total, zone
    end
    -- What your own journal holds from the day's time together.
    local function SharedMoments(day)
        local moments, seen, regions, order = {}, {}, {}, {}
        if not ownJournal then return moments, regions end
        for _, scene in ipairs(day.scenes) do
            if scene.kind == "outing" then
                for ordinal, e in ipairs(ownJournal) do
                    if e.t and not seen[e] and e.t >= scene.t - 60 and e.t <= (scene.e or scene.t) + 60 then
                        seen[e] = true
                        moments[#moments + 1] = e
                        regions[e], order[e] = scene.zone, ordinal
                    end
                end
            end
        end
        table.sort(moments, function(a, b) if a.t ~= b.t then return a.t < b.t end return order[a] < order[b] end)
        return moments, regions
    end
    local history = {days = 0, hours = 0, lastDay = nil, gaps = {}, dungeons = {}, dungeonRuns = 0, bosses = {}, beaten = {},
        zones = {}, fires = 0, rests = 0, rez = 0, deaths = 0, streak = 0, firstDay = nil, firstZone = nil, memories = {}, zoneSetting = {},
        lordDone = {}, unfinishedLast = {}, zoneLinesSaid = {},
        seenDays = 0, lastSeen = nil, firstSeen = nil, months = {}, zoneLastT = {}, diedIn = {}, questLore = {}, questThreads = {}, questSetups = {}}
    -- (the longest gap between two outings together: the first return after it opens as one)
    local maxGap = 0
    do
        local prev
        for _, day in ipairs(days) do
            local outing = false
            for _, scene in ipairs(day.scenes or {}) do if scene.kind == "outing" then outing = true end end
            if outing then
                local n = DayNumber(day.t)
                if prev and n - prev > maxGap then maxGap = n - prev end
                prev = n
            end
        end
    end
    -- Started out together: the tale begins where your people begin.
    local startedTogether = person.origin == "together"
    local START = {Scourge = "Tirisfal Glades", Human = "Elwynn Forest", Dwarf = "Dun Morogh", Gnome = "Dun Morogh",
        NightElf = "Teldrassil", Orc = "Durotar", Troll = "Durotar", Tauren = "Mulgore", Sky = "Zephras Isle"}
    local startKey = player.race
    if L.People and L.People(player.race) == "shen'dorei" then startKey = "Sky" end
    if person.race and player.race and person.race ~= player.race then startKey = "other" end
    -- An explicitly chosen origin is backstory supplied by the player. The
    -- scenes after it still begin where capture began; never fill the gap.
    if startedTogether then history.firstZone = START[startKey or ""] end
    local stories = {}
    local chapter = 0
    -- Story Highlights keeps only these beats.
    local KEEP = {open = true, shared = true, deathLore = true, landKey = true, day = true, dungeon = true, climax = true, death = true, rez = true, levelMark = true,
        questKey = true, rest = true, milestone = true, seen = true}
    -- The next day together, for each day (hindsight is only said when true).
    local nextTogether = {}
    do
        local following
        for i = #days, 1, -1 do
            nextTogether[i] = following
            if Together(DayFacts(days[i])) then following = DayNumber(days[i].t) end
        end
    end
    -- the last recorded stage of each quest chain in the whole book (Highlights keeps
    -- it: a chain's resolution, or how far it got).
    local threadLast = {}
    if brief and A.Lore and A.Lore.QuestStory then
        for _, d in ipairs(days) do
            for _, quest in ipairs(DayFacts(d).quests) do
                local story = A.Lore.QuestStory(quest.title, quest.qid)
                if story and story.thread then threadLast[story.thread] = quest.qid or quest.title end
            end
        end
    end
    -- how many fires lie ahead of each day (hindsight is only said when true).
    local firesAhead = {}
    do
        local acc = 0
        for i = #days, 1, -1 do firesAhead[i] = acc; acc = acc + #DayFacts(days[i]).fires end
    end
    for index, day in ipairs(days) do
        teller.day, teller.named, teller.roads, teller.ownCount, teller.lastPair = index, false, 0, 0, nil
        teller.started, teller.pendingTokens = false, nil
        teller.bothSaid, teller.saidPlaces = false, {}
        teller.twoSaid, teller.partySaid = false, false
        teller.fewDays = history.days < 5
        -- (someone else of your list was in the party today: not "the two of you")
        teller.crowd = false
        if ownJournal then
            for _, scene in ipairs(day.scenes) do
                if scene.kind == "outing" then
                    for _, e in ipairs(ownJournal) do
                        if e.k == "with" and e.n and Clean(e.n) ~= Clean(person.name or "") and (e.t or 0) < (scene.e or scene.t) and (e.e or e.t or 0) > scene.t then teller.crowd = true end
                    end
                end
            end
        end
        teller.implicit, teller.youSaid = false, false
        teller.lastFirst = history.lastOpening
        teller.avoidAlso = history.prevOpening
        teller.openTwo = history.openTwo
        local rng = Rng((person.name or "") .. day.key .. (player.name or "") .. (person.retell or ""))
        -- Titles draw on their own, so a day keeps its title in every telling.
        local titleRng = Rng((person.name or "") .. day.key .. (player.name or "") .. (person.retell or "") .. "title")
        local f = DayFacts(day, person)
        -- (a raise by this companion that your own book recorded and theirs did not, 2026-11-11)
        if ownJournal then
            local mine = (Clean(person.name or ""):gsub("%-.*$", "")):lower()
            local dayStart, dayEnd
            for _, scene in ipairs(day.scenes) do
                if scene.kind == "outing" then
                    dayStart = math.min(dayStart or scene.t, scene.t)
                    dayEnd = math.max(dayEnd or (scene.e or scene.t), scene.e or scene.t)
                end
            end
            f.rezBy = f.rezBy or {}
            for _, x in ipairs(ownJournal) do
                local by = x.k == "rez" and x.w == "them" and x.by and Clean(x.by):match("^(%S+)")
                if by and x.t and dayStart and x.t >= dayStart - 60 and x.t <= dayEnd + 60 then
                    local known = false
                    for _, rt in ipairs(f.rezT) do if math.abs(rt - x.t) <= 120 then known = true end end
                    if not known then
                        -- (round 4: a raise by someone else is told too, with who; only the companion's count as theirs)
                        if by:lower() == mine then f.rez = f.rez + 1 else f.rezBy[x.t] = Clean(x.by) end
                        f.rezT[#f.rezT + 1] = x.t
                    end
                end
                -- (the first time you ever raised them, from your own book)
                if x.k == "first" and x.d == "rezother" and x.n and Clean(x.n):lower() == mine and x.t and dayStart
                    and x.t >= dayStart - 60 and x.t <= dayEnd + 60 then
                    f.rezGivenT = f.rezGivenT or {}
                    f.rezGivenT[#f.rezGivenT + 1] = x.t
                end
            end
            table.sort(f.rezT)
        end
        local moments, momentRegions = SharedMoments(day)
        local formative = Together(f) and history.days < 3
        local discovery = false
        for _, zone in ipairs(f.zones) do
            if not history.zones[zone] and (f.zoneTime[zone] or 0) >= 600 then discovery = true end
        end
        -- a quiet day together: nothing done but looking about (a sunset, herbs)
        local quietDay = #f.quests == 0 and #f.dungeons == 0 and #f.deaths == 0 and f.outings > 0
        if quietDay then
            local any = false
            for _, e in ipairs(moments) do
                if (e.k == "first" and (e.d == "sunset" or e.d == "landmark" or e.d == "snow"))
                    or e.k == "gather" or e.k == "swim" then any = true end
            end
            quietDay = any
        end
        -- Choose scenes by significance, then tell the chosen scenes in their
        -- original order. A bag of herbs must not crowd out a first landmark
        -- or the companion whom you brought back from death.
        local sceneLimit = quietDay and f.together >= 3600 and 3 or 2
        local candidates = {}
        local strongCount = 0 -- (three strong moments in one day: a rescue, a duel, a rare; all three are told)
        -- (your own firsts that fell on a day together: a first zone or continent, a first mount,
        -- raid, epic or honorable kill; caves and battlegrounds entered together)
        local firstRanks = {notable = 8, rezother = 7, landmark = 6, sunset = 6, snow = 5, rarebeast = 5, foeseen = 5,
            zone = 6, continent = 7, mount = 6, raid = 7, epic = 4, pvp = 4,
            -- (milestones lane, 2026-11-06)
            epicmount = 6, famous = 8, legendary = 8, setfull = 6, tier = 4, worldboss = 7, rare = 4}
        local SURE_FIRSTS = {zone = true, continent = true, mount = true, raid = true, epic = true, pvp = true,
            epicmount = true, famous = true, legendary = true, setfull = true, tier = true, rare = true}
        local companionShort = Clean(person.name or ""):gsub("%-.*$", "")
        local exploreRanked = false
        for i, e in ipairs(moments) do
            local rank = e.k == "first" and firstRanks[e.d] or ({voyage = 5, close = 4, swim = 3, nightflight = 3, gather = 1, cave = 3, bg = 6})[e.k]
            -- (round 30, the player: "I just briefly got close to Alterac and went away". A first in a land the
            -- day only brushed, under a quarter of an hour of my own play there, is not a moment of the book)
            if rank and not (A.BookVariant and A.BookVariant("teller") == "planned") and e.k == "first" and (e.d == "snow" or e.d == "zone" or e.d == "sunset" or e.d == "landmark") and e.z and ownJournal then
                local zone = (e.d == "zone" or e.d == "snow") and e.z or nil
                if zone then
                    -- (brief: the next stretch elsewhere began within a quarter of an hour, and nothing was done
                    -- there: no hand-in, no death, no kill in that land that day)
                    local brief, done = false, false
                    for _, x in ipairs(ownJournal) do
                        if x.k == "play" and x.z and x.z ~= zone and x.t and e.t and x.t > e.t and x.t - e.t < 15 * 60 then brief = true end
                        if (x.k == "quest" or x.k == "death" or x.k == "boss" or x.k == "dungeon") and x.z == zone and x.t and math.abs(x.t - (e.t or 0)) <= 6 * 3600 then done = true end
                    end
                    if brief and not done then rank = nil end
                end
            end
            -- (a first the book cannot be sure of, begun late, is not claimed)
            if e.k == "first" and SURE_FIRSTS[e.d] and e.u then rank = nil end
            -- (a first zone or continent only where the record places it)
            if e.k == "first" and (e.d == "zone" or e.d == "continent") and not e.z then rank = nil end
            -- (no first continent where an earlier stretch of your own book already stood, and
            -- none by hearthstone, which only ever takes you home)
            if rank and e.k == "first" and e.d == "continent" then
                local map = A.SelfTale and A.SelfTale.ZoneContinent or {}
                for _, x in ipairs(ownJournal) do
                    if x.k == "play" and x.z and (x.t or 0) < (e.t or 0) and map[x.z] == e.z then rank = nil; break end
                    if x.k == "voyage" and x.d == "hearth" and math.abs((x.t or 0) - (e.t or 0)) <= 120 then rank = nil; break end
                end
            end
            -- (more moments: a duel with this very companion ranks with a rescue)
            if e.k == "duel" and e.d then rank = Clean(e.d) == companionShort and 7 or 3
            elseif e.k == "rarekill" then rank = 6
            elseif e.k == "rank" then rank = 5
            elseif e.k == "rep" then rank = (tonumber(e.s) or 0) >= 6 and 4 or 2
            elseif e.k == "explore" and not exploreRanked then exploreRanked = true; rank = 2
            elseif e.k == "read" then rank = 2 end
            if rank then candidates[#candidates + 1] = {entry = e, rank = rank, ordinal = i} end
            if rank and rank >= 6 then strongCount = strongCount + 1 end
        end
        if strongCount >= 3 then sceneLimit = math.max(sceneLimit, 3) end
        table.sort(candidates, function(a, b)
            if a.rank ~= b.rank then return a.rank > b.rank end
            return a.ordinal < b.ordinal
        end)
        local selected, gatherChosen = {}, false
        for _, candidate in ipairs(candidates) do
            if #selected >= sceneLimit then break end
            -- (Highlights: the moments that turn a day, a first, a rescue, a rare; not the herbs)
            if (candidate.entry.k ~= "gather" or not gatherChosen) and not (brief and not quietDay and candidate.rank < 5) then
                selected[#selected + 1] = candidate
                if candidate.entry.k == "gather" then gatherChosen = true end
            end
        end
        table.sort(selected, function(a, b) return a.ordinal < b.ordinal end)
        -- (a first continent says the crossing itself: the voyage line gives way to it)
        do
            local continent = false
            for _, c in ipairs(selected) do if c.entry.k == "first" and c.entry.d == "continent" then continent = true end end
            if continent then
                for i = #selected, 1, -1 do if selected[i].entry.k == "voyage" then table.remove(selected, i) end end
            end
        end
        local sceneMoments = {}
        for _, candidate in ipairs(selected) do sceneMoments[#sceneMoments + 1] = candidate.entry end
        local out = {}
        local outBeat = {}
        -- A day's largest errand must not replace work recorded in another
        -- outing. Keep each outing's bounded selection, then tell them in time.
        local multiQuestPlan, questScenes = {}, 0
        local planned = {}
        for _, scene in ipairs(day.scenes) do
            if scene.kind == "outing" then
                -- Keep first authored stages; repeated exact IDs are already
                -- excluded by the selector, not by an arbitrary scene budget.
                local selected = L.QuestBeats(f.quests, history.questLore, #f.quests,
                    function(q) return q.scene ~= scene or planned[q.qid or q.title] end)
                if #selected > 0 then questScenes = questScenes + 1 end
                for _, choice in ipairs(selected) do
                    planned[choice.quest.qid or choice.quest.title] = true
                    multiQuestPlan[#multiQuestPlan + 1] = choice
                end
            end
        end
        -- A dungeon visit must not make its completed quests depend on a
        -- randomly selected title/count sentence later in the telling.
        if questScenes < 1 or (questScenes < 2 and not day.readerEpisode and #f.dungeons == 0) then multiQuestPlan = nil
        else table.sort(multiQuestPlan, function(a, b)
            if a.quest.t ~= b.quest.t then return a.quest.t < b.quest.t end
            return a.order < b.order
        end) end
        local temporalAnchors = {}
        -- A short name ("Bazil") only once the full one was said this chapter.
        local function Short(name)
            local said = table.concat(out, " "):gsub("{%a:([^}]*)}", "%1")
            if said:find(Clean(name), 1, true) then return ShortRaw(name) end
            return Place(name)
        end
        -- A phrase is fresh when none of its names (capitalized words) was said this chapter.
        local function Fresh(phrase)
            local said = table.concat(out, " "):gsub("{%a:([^}]*)}", "%1")
            for word in phrase:gmatch("%u[%a]+") do
                if #word >= 5 and said:find(word, 1, true) then return false end
            end
            return true
        end
        local beat = "open"
        -- The short telling (Highlights) greets only when it is news: a first
        -- meeting, a return after weeks, a long silence.
        local majorOpen = false
        -- (Highlights: a fire or an inn only when it is the first shared, or a counted one)
        local restNews = (#f.fires > 0 and (history.fires == 0 or (PB.fireCount and PB.fireCount[history.fires + #f.fires] ~= nil)))
            or (#f.rests > 0 and history.rests == 0)
        -- (the time of what a line tells, where the chapter knows it: moments from your own journal;
        -- keyed by the line, so lines moved, merged or dropped later keep or lose it safely)
        local outT, lineT = {}, nil
        -- (2026-11-09, story planner step 1: every block stamps its lines with the event's time
        -- (lineT) and zone (S.z). S.M marks the shared moments, the only lines the
        -- Chronology pass below moves; the others' stamps serve the planned telling.)
        -- (one table: T.Tell is near Lua's limit of 200 locals. S.Z: zone by line; S.M: moment lines;
        -- S.z: the zone being stamped; S.moment: the shared-moments block is writing)
        -- S.planned: the planned telling (Settings > Testing > Storyteller; Everything only for now)
        -- (step 3 hooks, read by the planned telling only: S.Q line -> quest, S.Qs line -> quests of a
        -- fold, S.SL quest setup lines, S.D line -> death entry, S.LV the level lines and S.levelMine the
        -- level of yours they told; S.setup / S.setupFor what a line points back to, for felt lines;
        -- S.ME moment line -> its event and S.peak line -> "death" / "figure" / "city", for T.PlanShape)
        local S = {Z = {}, M = {}, z = nil, moment = false, Q = {}, Qs = {}, SL = {}, D = {}, LV = {}, setup = {}, setupFor = {}, ME = {}, peak = {},
            R = {}, r = nil, RQ = {}, RQL = {}, EP = {}, NoLead = {}, Keep = {},
            planned = not brief and A.BookVariant ~= nil and A.BookVariant("teller") == "planned"}
        function S.Stamp(t, z, q) lineT, S.z, S.q = t, z, q end
        -- (a line rewritten in place keeps the stamp of what it was)
        function S.Carry(old, new)
            if old and new and old ~= new then
                if outT[new] == nil then outT[new] = outT[old] end
                if S.Z[new] == nil then S.Z[new] = S.Z[old] end
                for _, map in ipairs({S.Q, S.Qs, S.SL, S.D, S.setup, S.setupFor, S.R, S.EP, S.NoLead, S.Keep}) do if map[new] == nil then map[new] = map[old] end end
            end
            return new
        end
        -- Your deaths by killer that day: true from the second death to the same one (2026-11-11 round 2;
        -- counted when told, so the pool's {nth} is the death's number).
        S.killedBy = {}
        function S.KilledAgain(name)
            local key = Clean(name or "")
            if key == "" then return 0 end
            S.killedBy[key] = (S.killedBy[key] or 0) + 1
            return S.killedBy[key]
        end
        -- The level line that came within three quarters of an hour of a run's end (2026-11-11).
        function S.RunLevel(line)
            local t = S.LV[line] and outT[line]
            if not t then return false end
            for _, d in ipairs(f.dungeons) do
                if #d.events > 0 then
                    local lastT = d.t or 0
                    for _, ev in ipairs(d.events) do lastT = math.max(lastT, ev.t or 0) end
                    if t >= lastT and t - lastT <= 45 * 60 then return true end
                end
            end
            return false
        end
        -- A raise of yours that followed the death at t, before your next death (2026-11-11; a
        -- record without times keeps the old rule: any raise that day).
        S.rezTold = {}
        function S.RezAfter(t)
            if #f.rezT == 0 then
                if (f.rez or 0) > 0 and not S.rezTold[true] then return true end
                return nil
            end
            local nextYou
            for _, x in ipairs(f.deaths) do
                if x.w == "you" and (x.t or 0) > (t or 0) and (not nextYou or (x.t or 0) < nextYou) then nextYou = x.t or 0 end
            end
            for _, d in ipairs(f.dungeons) do
                for _, ev in ipairs(d.events) do
                    if ev.k == "death" and ev.e and ev.e.w == "you" and (ev.t or 0) > (t or 0) and (not nextYou or (ev.t or 0) < nextYou) then nextYou = ev.t or 0 end
                end
            end
            for _, rt in ipairs(f.rezT) do if rt >= (t or 0) and (not nextYou or rt <= nextYou) and not S.rezTold[rt] then return rt end end
            return nil
        end
        -- A hand-in about a dungeon run told today (2026-11-11): its point-of-view scene must not
        -- tell the descent or the kills a second time. The variant that retells least is taken,
        -- and its retelling sentences (ours, naming the place, a boss of the run or the way
        -- down) are left out; a scene that is all retelling becomes a plain hand-in.
        function S.RunQuest(e, text, tok, variant)
            local pov = e and e.story and e.story.pov
            local QD = A.QuestDeeds
            if not pov or #pov == 0 or not QD or not QD.Fill or not e.quest then return text end
            local run
            for _, d in ipairs(f.dungeons) do
                if #d.events > 0 and (e.quest.t or 0) >= (d.t or 0) then
                    local plain = A.JournalPlain and A.JournalPlain(text) or text
                    local about = plain:find(Clean(d.name), 1, true) ~= nil
                    if d.runQuests and d.runQuests[e.quest.qid or e.quest.title] then about = true end
                    for _, v in ipairs(pov) do if tostring(v):find(Clean(d.name), 1, true) then about = true end end
                    for _, ev in ipairs(d.events) do
                        if ev.k == "boss" and ev.d and plain:find(Clean(ev.d), 1, true) then about = true end
                    end
                    -- (a descent in our words, turned in within three hours of the run: the tomes "from
                    -- the caverns beneath Orgrimmar" never say "Ragefire Chasm")
                    if not about then
                        local lastT = d.t or 0
                        for _, ev in ipairs(d.events) do lastT = math.max(lastT, ev.t or 0) end
                        if (e.quest.t or 0) - lastT <= 3 * 3600 then
                            for _, v in ipairs(pov) do
                                local s = tostring(v)
                                local ours = s:find("{We}", 1, true) or s:find("{we}", 1, true) or s:find("{I}", 1, true)
                                if ours and (s:find("went down into", 1, true) or s:find("fought down", 1, true) or s:find("down through", 1, true)) then about = true end
                            end
                        end
                    end
                    if about then run = d end
                end
            end
            if not run then return text end
            -- (a fallback story's outcome, "X went on", reads as if the goal lived: after a run that killed
            -- the quest's goal it is skipped, and it never takes the lord's after line, 2026-11-11)
            if e.story.progress then
                local E = A.JournalEpisodes
                local words = E and E.QuestText and E.QuestText(e.quest) or ""
                for _, ev in ipairs(run.events) do
                    if ev.k == "boss" and ev.d and ((E and E.Names and E.Names(words, ev.d)) or words:find(Clean(ev.d), 1, true)) then return false end
                end
                return text
            end
            S.RQ[e.quest] = run
            -- (the stage's own way out, authored for a run told that day: "{We} came up into {zone} with
            -- Taragaman's heart, proof for Thrall that the cult under his city had lost its master"; it
            -- says what the lord's fall meant, so the lore's line for it goes)
            local afterRun = type(pov) == "table" and pov.afterRun
            if type(afterRun) == "table" and #afterRun > 0 then
                local zone = e.quest.z or (e.quest.scene and e.quest.scene.zone)
                local pool = {}
                for _, l in ipairs(afterRun) do if zone or not tostring(l):find("{zone}", 1, true) then pool[#pool + 1] = l end end
                if #pool > 0 then
                    local filled = {}
                    for k, v in pairs(tok or {}) do filled[k] = v end
                    filled.zone = zone and Place(zone) or ""
                    S.RQL[e.quest] = true
                    -- (a level will join this sentence as a clause: the line with the fewest clauses takes it)
                    local pick = ((variant or 1) - 1) % #pool + 1
                    -- (round 11: a close bond's book keeps its own line of the two, so the friend's book of the
                    -- same evening does not say the same sentence; the level clause joins it all the same)
                    if run.runLevel and not (T.BondKind(person) == "close") then
                        local best
                        for i, l in ipairs(pool) do
                            local n = select(2, tostring(l):gsub(", and ", ""))
                            if not best or n < best then best, pick = n, i end
                        end
                    end
                    return QD.Fill(pool[pick], filled)
                end
            end
            -- (its scene names the lord whose fall the run's lore line tells: the hand-in's own words
            -- of what came of it replace that line, never both)
            for _, ev in ipairs(run.events) do
                local lo = ev.k == "boss" and ev.d and L.Boss and L.Boss(ev.d)
                if lo and lo.after then
                    for _, v in ipairs(pov) do if tostring(v):find(Clean(ev.d), 1, true) then S.RQL[e.quest] = true end end
                end
            end
            local function Retells(sentence)
                local ours = sentence:find("{We}", 1, true) or sentence:find("{we}", 1, true) or sentence:find("{I}", 1, true)
                    or sentence:find("{us}", 1, true) or sentence:find("{our}", 1, true) or sentence:find("{Our}", 1, true)
                if not ours then return false end
                if sentence:find(Clean(run.name), 1, true) then return true end
                for _, ev in ipairs(run.events) do
                    if ev.k == "boss" and ev.d and sentence:find(Clean(ev.d), 1, true) then return true end
                end
                for _, way in ipairs({"went down", "fought down", "down into", "down through", "went into", "climbed"}) do
                    if sentence:find(way, 1, true) then return true end
                end
                return false
            end
            -- (names the place or a boss of the run without being ours: a setup line, out of place
            -- once the kills are told)
            local function Setup(sentence)
                if sentence:find(Clean(run.name), 1, true) then return true end
                for _, ev in ipairs(run.events) do
                    if ev.k == "boss" and ev.d and sentence:find(Clean(ev.d), 1, true) then return true end
                end
                return false
            end
            -- (the reward half of a retelling sentence: "..., and his heart went up to be shown to
            -- Thrall" stays, with the lord's name for its pronoun; the kill half goes)
            local povLine
            local function Reward(sentence)
                local head, tail = sentence:match("^(.*), and (.-)$")
                if not tail or Retells("{We} " .. tail) or Setup(tail) then return nil end
                local n = 0
                for _ in tail:gmatch("%S+") do n = n + 1 end
                if n < 4 then return nil end
                -- (the pronoun's owner: the boss the sentence names, else the one the scene names)
                local who
                for _, ev in ipairs(run.events) do
                    if ev.k == "boss" and ev.d and head:find(Clean(ev.d), 1, true) then who = L.Short and L.Short(ev.d) or ev.d end
                end
                if not who then
                    for _, ev in ipairs(run.events) do
                        if ev.k == "boss" and ev.d and tostring(povLine or ""):find(Clean(ev.d), 1, true) then who = L.Short and L.Short(ev.d) or ev.d end
                    end
                end
                if who then tail = tail:gsub("^[Hh]is ", who .. "'s "):gsub("^[Hh]er ", who .. "'s "):gsub("^[Ii]ts ", who .. "'s ") end
                -- (a clause that shares the kill half's subject gets it back: "brought his head back" ->
                -- "{We} brought VanCleef's head back")
                local firstWord = tail:match("^(%a+)") or ""
                local OWN = {his = true, her = true, its = true, their = true, the = true, a = true, an = true, that = true, this = true,
                    it = true, he = true, she = true, they = true, there = true, we = true, i = true, you = true}
                if firstWord:match("^%l") and not OWN[firstWord] and not tail:find("^{") then
                    if who then tail = tail:gsub(" his ", " " .. who .. "'s ", 1) end
                    tail = "{We} " .. tail
                end
                return (tail:gsub("^%l", string.upper))
            end
            local chosen = ((variant or 1) - 1) % #pov + 1
            local best, bestN, bestKept, bestFull, bestReward
            for n = 0, #pov - 1 do
                local v = (chosen - 1 + n) % #pov + 1
                local kept, dropped, full, rewards = {}, 0, 0, 0
                povLine = pov[v]
                for sentence in (tostring(pov[v]) .. " "):gmatch("(.-[%.!%?])%s+") do
                    if Retells(sentence) then
                        local reward = Reward(sentence)
                        if reward then kept[#kept + 1] = reward; rewards = rewards + 1 else dropped = dropped + 1 end
                    elseif Setup(sentence) then dropped = dropped + 1
                    else kept[#kept + 1] = sentence; full = full + 1 end
                end
                -- (fewest lines lost; on a tie the one that keeps what left the place with us)
                if not best or dropped < bestN or (dropped == bestN and rewards > bestReward) then
                    best, bestN, bestKept, bestFull, bestReward = v, dropped, kept, full, rewards
                end
            end
            if bestN == 0 and bestFull == #bestKept then
                if best == chosen then return text end
                return QD.Fill(pov[best], tok)
            end
            -- (the hand-in's own consequence sentence replaces the lore's line; a reward clause alone does not)
            if bestFull == 0 then S.RQL[e.quest] = nil end
            if #bestKept == 0 then
                return tok.We .. " finished {q:" .. tostring(e.quest.title):gsub("[{}]", "") .. "}."
            end
            return QD.Fill(table.concat(bestKept, " "), tok)
        end
        local function Add(text)
            if not text then return end
            if brief and (not KEEP[beat] and not (beat == "land" and discovery)
                or (beat == "open" and not majorOpen and not formative)
                or (beat == "rest" and not restNews)) then
                local pt = teller.pendingTokens -- a dropped line bans nothing
                if pt then pt.partUsed, pt.weekdayUsed = nil, nil end
                teller.pendingTokens = nil
                return
            end
            -- "Then ..." does not open a day.
            if #out == 0 then text = Cap((text:gsub("^Then,? ", ""):gsub("^Before long,? ", ""))) end
            teller.avoidAlso = nil -- the other chapters' openings matter only for the first sentence
            -- now the line is written: its places, time of day and weekday are said.
            for place in text:gmatch("{p:([^}]+)}") do teller.saidPlaces[place:gsub("^[Tt]he ", ""):match("^(%S+)")] = true end
            local pt = teller.pendingTokens
            if pt and pt.partUsed then pt.part, pt.partUsed = false, nil end
            if pt and pt.weekdayUsed then pt.weekday, pt.Weekday, pt.weekdayUsed = false, false, nil end
            teller.pendingTokens = nil
            teller.started = true
            text = A.JournalIslands and A.JournalIslands(text) or text
            out[#out + 1] = text
            outBeat[#out] = beat
            if lineT then outT[text] = lineT; if S.moment then S.M[text] = true; S.ME[text] = S.me end end
            if S.z then S.Z[text] = S.z end
            if S.q then S.Q[text] = S.q end
            if S.r then S.R[text] = S.r end
            if S.e then S.D[text] = S.e end
            if S.lvl then S.LV[text] = true end
            -- Named once it is written (a line the short telling drops names nobody).
            local bondWord = teller.base.bondWord
            if text:find(teller.base.name, 1, true) or (bondWord and text:lower():find(bondWord, 1, true)) then teller.named = true end
            if text:lower():find("the two of ", 1, true) or text:lower():find("the pair of ", 1, true) then teller.twoSaid = true end
            if text:lower():find("your party", 1, true) or text:lower():find("my party", 1, true) then teller.partySaid = true end
        end
        local today = DayNumber(day.t)
        local together = Together(f)
        local gap = history.lastDay and (today - history.lastDay) or nil
        local cadence, usual = Cadence(history.gaps)
        local level = f.plEnd or f.plStart
        local theirLevel = f.olLast or f.ol or f.levels[#f.levels]
        -- Older lines have no level of yours: judge the danger by theirs.
        local judged = level or theirLevel
        local stage = Stage(level or theirLevel)
        local span = history.firstDay and (today - history.firstDay) or 0
        local tier
        if history.days == 0 then tier = "first"
        elseif history.days < 5 and span >= 60 then tier = "rare"
        elseif history.days < 3 then tier = "new"
        elseif cadence == "monthly" or cadence == "rare" then tier = "rare"
        elseif history.days >= 12 and (cadence == "daily" or cadence == "often" or cadence == "weekly") then tier = "close"
        else tier = "companion" end
        if startedTogether and index > 1 then tier = (cadence == "monthly" or cadence == "rare") and "rare" or "close" end
        local people = L.People and L.People(person.race)
        local class = ClassWord(person.class)
        local who = (people and class and (people .. " " .. class)) or class or people or "fellow adventurer"
        local mainZone
        -- (a dungeon is told by its own beat: the chapter opens on the country above it when the
        -- day recorded any, "in Westfall ... Then you went down into the Deadmines", 2026-11-06)
        local aboveGround
        for _, zone in ipairs(f.zones) do if not (L.Dungeon and L.Dungeon(zone)) and (f.zoneTime[zone] or 0) >= 300 then aboveGround = true end end
        for _, zone in ipairs(f.zones) do
            if not (aboveGround and L.Dungeon and L.Dungeon(zone)) and (not mainZone or f.zoneTime[zone] > f.zoneTime[mainZone]) then mainZone = zone end
        end
        mainZone = mainZone or (f.met and f.met.zone) or (f.seen and f.seen.zone) or f.fires[1] or f.rests[1]
        local zoneInfo = L.Zone and L.Zone(mainZone)
        local function Epithet(info, allowLong)
            if not info or not info.e or rng() > (teller.persona.epithet or 0.75) then return nil end
            local options = {}
            for _, e in ipairs(info.e) do if allowLong or not e:find(",") then options[#options + 1] = e end end
            return options[1] and options[rng(#options)] or nil
        end
        local tokens = {
            zone = mainZone and Place(mainZone) or "the wilds", zoneD = mainZone and Place(mainZone) or "the wilds",
            who = who, aWho = Article(who), AWho = Cap(Article(who)),
            gap = gap and Span(gap) or "", later = gap and Later(gap, rng) or "", usual = USUAL[cadence or ""] or "often",
            length = About(f.together), Length = Cap(About(f.together)), stageWord = STAGE_WORDS[stage or ""] or "adventurer",
            weekday = day.weekday, Weekday = day.weekday,
            firstZone = history.firstZone and Place(history.firstZone) or "the road", since = Span(span),
            mine = level, theirs = theirLevel,
        }
        local crafts = A.JournalTellers and A.JournalTellers.crafts or {}
        tokens.theirCraft, tokens.myCraft = crafts[person.class or ""], crafts[player.class or ""]
        local firstOuting, lastOuting
        for _, scene in ipairs(day.scenes) do
            if scene.kind == "outing" then
                firstOuting = firstOuting or scene
                if not lastOuting or (scene.e or 0) > (lastOuting.e or 0) then lastOuting = scene end
            end
        end
        local startHour = Hour((firstOuting or day.scenes[1] or day).t or day.t)
        tokens.part = PartOf(startHour)
        tokens.zoneE = mainZone and (Epithet(zoneInfo, false) or Place(mainZone)) or "the wilds"
        tokens.zoneL = mainZone and (Epithet(zoneInfo, true) or Place(mainZone)) or "the wilds"
        tokens.zoneWas = Plural(tokens.zoneE) and "were" or "was"
        tokens.qcount, tokens.Qcount = Words(#f.quests), Cap(Words(#f.quests))
        -- (the day's work told as deeds below, from our side: then no line counts the quests,
        -- "We were out for nearly four hours and cleared seventeen quests" read as a log, 2026-11-07)
        local deedsToday = false
        if A.QuestDeeds then
            for _, quest in ipairs(f.quests) do
                local story = A.QuestDeeds.Story(quest)
                local act = story and A.QuestDeeds.Act(quest, story)
                if (act and act.act) or (story and story.pov) then deedsToday = true; break end
            end
        end
        tokens.firstDungeon = history.firstDungeonName and Place(history.firstDungeonName) or false
        -- the same zone as yesterday?
        local zoneRun = (mainZone and history.lastZone == mainZone and gap == 1) and ((history.zoneRunN or 1) + 1) or 1
        tokens.runNth = Ordinal(zoneRun)
        tokens.clock = false
        tokens.questFolded = nil
        local title, titleRank, titleKey = nil, -1, nil
        -- a kind of title used in the last three chapters gives way.
        local function Recent(key, rank)
            if not key or (rank or 0) >= 90 then return false end
            for _, k in ipairs(history.titleKeys or {}) do if k == key then return true end end
            return false
        end
        -- The chapter's title: the strongest thing that happened wins.
        local function Title(rank, text, key)
            if text and rank > titleRank and not Recent(key, rank) then title, titleRank, titleKey = text, rank, key end
        end
        local function BossTitle(rank, boss)
            local short = Clean(L.Short and L.Short(boss) or boss)
            local forms = {{"fall", "The Fall of {p:" .. short .. "}"}, {"name", "{p:" .. short .. "}"},
                {"end", "{p:" .. short .. "}" .. (short:find("s$") and "' End" or "'s End")}}
            local pick = forms[titleRng(#forms)]
            if pick[1] == history.lastBossTitle then pick = forms[(titleRng(#forms - 1) + (pick == forms[1] and 1 or 0)) % #forms + 1] end
            if rank > titleRank and not Recent("boss:" .. short, rank) then history.pendingBossTitle = pick[1] end
            Title(rank, pick[2], "boss:" .. short)
        end
        local function TitleFrom(rank, key)
            local list = PB.title[key]
            local kind = (key == "fall" or key == "water") and "death" or key
            if list and rank > titleRank and not Recent("from:" .. kind, rank) then Title(rank, teller:Pick("title" .. key, list, titleRng), "from:" .. kind) end
        end
        local mood = {grim = false, triumph = false, warm = false}
        local placeSaid, flourish, streakSaid = false, 0, nil
        -- landState: the land line said what the place is, not what you did there.
        -- blessOccasion: a race's blessing only for a lord's first fall or level 60.
        local landState, blessOccasion = false, false
        local tellsTwo = false -- this chapter also tells the day before
        -- the chapter before named the companion, and it was yesterday: a reader knows who
        -- "the two of you" are. Half the time, and never after a return, a meeting or a gap.
        local implicit = (together and gap == 1 and history.days >= 3 and history.namedDay == today - 1
            and not (PB.milestoneDays[history.days + 1] and #PB.milestoneDays[history.days + 1] > 0)
            and rng() < 0.5) or false
        -- today also tells yesterday; no greeting of its own ("that evening" would be wrong).
        local mergeToday = history.merged and not brief and gap == 1 and history.merged.zone == mainZone
        if mergeToday then implicit = false end

        -- A line of what a known country is like, not said before in this book (a return after
        -- four weeks or more draws a second sight or stake from Lore; 2026-11-06).
        local function FreshZoneLine(zone)
            local zs = L.ZoneStory and L.ZoneStory(zone)
            if not zs then return nil end
            local pool = {}
            for _, list in ipairs({zs.sight or {}, zs.stakes or {}}) do
                for _, line in ipairs(list) do
                    if not history.zoneLinesSaid[line] and not (A.SelfTale and A.SelfTale.NamesFoeTown and A.SelfTale.NamesFoeTown(line, player.faction)) then pool[#pool + 1] = line end
                end
            end
            if #pool == 0 then return nil end
            local line = pool[rng(#pool)]
            history.zoneLinesSaid[line] = true
            return line
        end
        -- 1. How the day opens. (stamped: the first outing's start, through the land and the day line)
        S.Stamp((firstOuting or day.scenes[1] or day).t or day.t, (firstOuting and firstOuting.zone) or mainZone)
        if not gap and history.firstDay then tokens.later = Later(today - history.firstDay, rng) end
        if startedTogether and index == 1 then
            majorOpen = true
            local originPool = PB.origin[startKey or ""] or PB.origin.other
            -- (lane C9: the bond inside the sentence, "Faelyn, my wife, and I started out together",
            -- never a label line after it, "Faelyn is my wife.")
            if teller.base.bondWord then
                local bonded = {}
                for i, line in ipairs(originPool) do bonded[i] = (line:gsub("{pair}", "{pairBond}")) end
                originPool = bonded
                tokens.pairBond = (voice == "we") and (teller.base.name .. ", " .. teller.base.bondWord .. ", and I")
                    or ("you and " .. teller.base.name .. ", " .. teller.base.bondWord .. ",")
            end
            local originLine = teller:Say("origin" .. (startKey or "other"), originPool, rng, tokens)
            local at = originLine and originLine:find(teller.base.name, 1, true)
            if at and teller.base.bondWord and not originLine:find(teller.base.name .. ", " .. teller.base.bondWord, 1, true) then
                local stop = at + #teller.base.name - 1
                originLine = originLine:sub(1, stop) .. ", " .. teller.base.bondWord .. "," .. originLine:sub(stop + 1)
            end
            Add(originLine)
            if not at and teller.base.bondWord then Add(teller:Say("bondLine", PB.bondLine, rng, tokens)) end
            TitleFrom(100, startKey == "Scourge" and "risen" or "origin")
            if mainZone and history.firstZone and mainZone ~= history.firstZone and PB.knownBeginning then
                for i = 1, #outBeat do outBeat[i] = "prologue" end
                Add(teller:Say("knownBeginning", PB.knownBeginning, rng, tokens))
            end
        elseif history.days == 0 and together and history.seenDays >= 3 and not f.met and not startedTogether then
            majorOpen = true
            tokens.count = Words(history.seenDays)
            tokens.span = Span(today - (history.firstSeen or today))
            Add(teller:Say("meetAfterSeen", PB.meetAfterSeen, rng, tokens))
            TitleFrom(100, "atLast")
        elseif history.days == 0 and together and history.firstDay and not f.met and not startedTogether then
            majorOpen = true
            Add(teller:Say("firstRoad", PB.firstRoad, rng, tokens))
            TitleFrom(60, "returning")
        elseif not startedTogether and (f.met or (history.days == 0 and together) or (history.days == 0 and f.added and not f.seen)) then
            majorOpen = true
            if f.met and f.met.how == "campfire" then Add(teller:Say("meetFire", PB.meetFire, rng, tokens))
            elseif f.met or together then
                if firstOuting and firstOuting.zone and ((firstOuting.e or 0) - (firstOuting.t or 0)) >= 300 then
                    tokens.zoneE, tokens.zoneD = Place(firstOuting.zone), Place(firstOuting.zone)
                end
                -- (a configured bond is said on the first day: "Mira, your wife,")
                -- (a wife or a sworn friend is not "met": she was there, 2026-11-07)
                local meetLine = (teller.base.bondWord and PB.meetBond) and teller:Say("meetBond", PB.meetBond, rng, tokens)
                    or teller:Say("meetGroup", PB.meetGroup, rng, tokens)
                if teller.base.bondWord and PB.meetBond then Add(meetLine); meetLine = nil end
                local at = meetLine and meetLine:find(teller.base.name, 1, true)
                if at and teller.base.bondWord then
                    local stop = at + #teller.base.name - 1
                    local tail = meetLine:sub(stop + 1)
                    -- ("Mira, a Forsaken warlock," becomes "Mira, your wife, a Forsaken warlock,")
                    meetLine = meetLine:sub(1, stop) .. ", " .. teller.base.bondWord .. (tail:match("^[,%.]") and "" or ",") .. tail
                end
                if meetLine then Add(meetLine) end
                if meetLine and not at and teller.base.bondWord then Add(teller:Say("bondLine", PB.bondLine, rng, tokens)) end
            else Add(teller:Say("meetAdded", PB.meetAdded, rng, tokens)) end
            TitleFrom(100, "meet")
        elseif together and gap and gap >= 4 then
            -- The interval separates recorded outings, not necessarily actual
            -- meetings. State elapsed time without inventing an absence or cadence.
            local bonded = teller.base.bondWord and PB.recordedIntervalBond
            local placeCanLead = #f.dungeons == 0 or f.dungeons[1].name == mainZone
            local intervalPool = bonded or PB.recordedInterval
            if not placeCanLead then
                local placed = {}
                for _, line in ipairs(intervalPool) do if line:find("{zoneD}", 1, true) then placed[#placed + 1] = line end end
                if #placed > 0 then intervalPool = placed end
                majorOpen = true -- This is the field location, not an optional greeting.
            end
            -- A week or more since the last outing together: the opening of a new night at
            -- the table (PB.absence, 2026-11-06). The gap in words, the place now against the
            -- place then, the hour; the level climbed in between or the fall of a lord last
            -- time as a second sentence on the long gaps (not in Highlights).
            local absence
            if gap >= 7 and PB.absence then
                local longest = gap >= 21 and gap >= maxGap and not history.longestSaid
                local bucket = (gap >= 166 or longest) and "longest" or (gap >= 21 and "long") or "short"
                if longest then history.longestSaid = true end
                history.absenceN = (history.absenceN or 0) + 1
                local n = history.absenceN
                tokens.since = SinceWords(gap, n)
                tokens.lastZone = history.lastMain and history.lastMain ~= mainZone and Place(history.lastMain) or false
                local shape = (mainZone and history.lastMain == mainZone) and "same" or "else"
                if gap >= 21 and shape == "else" and mainZone and history.firstZone == mainZone and history.days >= 2 then shape = "met" end
                if gap >= 21 and teller.base.bondWord and n % 3 == 1 and PB.absence[bucket].bond then shape = "bond" end
                local list = PB.absence[bucket][shape] or PB.absence[bucket]["else"]
                -- (the opening names the companion: a line without them would be replaced by a greeting below)
                do
                    local named = {}
                    for _, line in ipairs(list) do
                        if line:find("{pair}", 1, true) or line:find("{name}", 1, true) or line:find("{pairNamed}", 1, true) or line:find("{bondWord}", 1, true) or line:find("{Bond}", 1, true) then named[#named + 1] = line end
                    end
                    if #named > 0 then list = named end
                end
                if not tokens.lastZone then
                    local kept = {}
                    for _, line in ipairs(list) do if not line:find("{lastZone}", 1, true) then kept[#kept + 1] = line end end
                    list = kept
                end
                if not placeCanLead then
                    local placed = {}
                    for _, line in ipairs(list) do if line:find("{zoneD}", 1, true) then placed[#placed + 1] = line end end
                    if #placed > 0 then list = placed end
                end
                if #list > 0 then absence = {bucket = bucket, shape = shape, n = n, list = list} end
            end
            local function AbsenceRecap()
                if not absence or gap < 11 or not PB.absenceRecap then return end
                if gap < 21 and absence.n % 2 == 0 then return end
                local options = {}
                local lordName = history.lastLord and Place((L.Short and L.Short(history.lastLord)) or history.lastLord)
                if lordName and history.lastDungeonName then options[#options + 1] = "lord"
                elseif history.lastDungeonName then options[#options + 1] = "dungeon" end
                -- (levels: a climb of three or more, and not after every gap: accounting is not the point)
                local theirsUp = theirLevel and history.lastTheirLevel and theirLevel - history.lastTheirLevel >= 3
                local mineUp = level and history.lastMyLevel and level > history.lastMyLevel
                if theirsUp and (absence.n % 2 == 1 or absence.bucket == "longest") then
                    if mineUp and level == theirLevel then options[#options + 1] = "bothSame"
                    elseif mineUp then options[#options + 1] = "both"
                    else options[#options + 1] = "theirs" end
                end
                if #options == 0 then return end
                local pick = options[(absence.n % #options) + 1]
                tokens.theirsThen, tokens.mineThen = history.lastTheirLevel, history.lastMyLevel
                tokens.lastLord, tokens.lastDungeon = lordName or false, history.lastDungeonName and Place(history.lastDungeonName) or false
                local was = beat
                beat = "recap"
                Add(teller:Say("absenceRecap" .. pick, PB.absenceRecap[pick], rng, tokens))
                beat = was
            end
            local interval = absence and teller:Say("absence" .. absence.bucket .. absence.shape, absence.list, rng, tokens)
                or teller:Say("recordedInterval", intervalPool, rng, tokens)
            if absence and gap >= 21 then majorOpen = true end
            local sceneLed = #f.dungeons > 0
            for _, quest in ipairs(f.quests) do
                local story = L.QuestStory and L.QuestStory(quest.title, quest.qid)
                if story and story.after and not history.questLore[quest.qid or quest.title] then sceneLed = true end
            end
            -- Adjacent substantive chapters need not both open by reintroducing
            -- the pair. Dates remain on the chapters; the next scene can lead.
            -- A brief dungeon visit elsewhere cannot supply the field scene's
            -- location: keep that interval's place anchor on mixed days.
            -- A gap that is simply this pair's rhythm (a weekly companion, a week on)
            -- is said once; the chapter after it opens on the land or the work, and
            -- every third such chapter greets in the rhythm's own words instead
            -- ("Mira came along, as she did most weeks"). The dates stay on the chapters.
            -- (a monthly guest's return is news every time; only a regular's week is routine)
            local usualGap = (cadence == "weekly" and gap >= 6 and gap <= 8) or (cadence == "fortnightly" and gap >= 12 and gap <= 16)
            local rhythm = usualGap and placeCanLead and history.intervalOpen == index - 1
            if rhythm then
                history.rhythmSkips = (history.rhythmSkips or 0) + 1
                if history.rhythmSkips % 3 == 0 and PB[cadence] then
                    Add(teller:Say(cadence == "weekly" and "returnInterval" or cadence, PB[cadence], rng, tokens))
                end
                history.intervalOpen = index -- (the rhythm holds: a deviation from it is the next news)
            elseif (absence and gap >= 21) or not (sceneLed and placeCanLead and history.intervalOpen == index - 1) then
                if interval and tokens.zoneD and interval:find(tokens.zoneD, 1, true) then placeSaid = true end
                Add(interval)
                history.intervalOpen = index
                -- (the opening already counted the time: no anniversary line in the same chapter)
                if absence and gap >= 21 then history.absenceOpened = index end
                AbsenceRecap()
                -- (back in a country the book knows, four weeks on: one more thing about it, not in Highlights)
                if absence and gap >= 28 and mainZone and history.zones[mainZone] and placeCanLead then
                    local line = FreshZoneLine(mainZone)
                    if line then local was = beat; beat = "again"; Add(line); beat = was end
                end
            end
        elseif together then
            local key
            if gap and gap >= 30 and teller.base.bondWord and PB.reunionBond then
                -- (an oldest friend back: who they are to you)
                key = "reunionBond"
                majorOpen = true
                TitleFrom(60, "returning")
            elseif gap and gap >= 21 and (tier == "rare" or tier == "new" or cadence == "monthly" or cadence == "rare") then
                key = gap >= 50 and "rare" or "monthly"
                majorOpen = true
                TitleFrom(60, "returning")
            elseif history.days == 1 and not startedTogether then key = "second"
            elseif history.days < 5 and not startedTogether then key = "early"
            else key = cadence or "often" end
            -- The day's own gap speaks louder than the usual rhythm: a weekly
            -- companion back after two days is not "back as the week came round".
            local regularKeys = {daily = true, often = true, weekly = true, fortnightly = true}
            if gap and regularKeys[key] then
                local byGap = gap <= 1 and "daily" or gap <= 3 and "often" or gap <= 9 and "weekly" or gap <= 18 and "fortnightly" or "monthly"
                if byGap ~= key and not (key == "daily" and gap <= 3) then key = byGap end
                if key == "often" and gap >= 2 and rng() < 0.4 then key = "oftenGap" end
            end
            -- (the bond is said in an opening on one day in five, not one in three: a novelist does not re-announce "your wife")
            if teller.base.bondWord and key ~= "reunionBond" and rng() < (startedTogether and 0.35 or 0.2) then key = "bondOpen" end
            -- Companions from the first day are old companions from the start.
            if key == "daily" and history.days < 7 and not startedTogether then key = "often" end
            if startedTogether and (key == "often" or key == "early" or key == "second") and (gap or 9) <= 3 then key = "daily" end
            -- Busy days sometimes skip the greeting and go straight to the action.
            local busy = #f.dungeons > 0 or #f.deaths > 0
            local greeted = false
            local chance = busy and 0.2 or (key == "daily" and 0.2 or key == "often" and 0.3 or key == "weekly" and 0.35 or key == "fortnightly" and 0.6 or 1)
            if not implicit and not mergeToday and (rng() < chance or key == "rare" or key == "monthly" or key == "reunionBond") then -- no greeting
                tokens.nth = Ordinal(history.streak + 1)
                local regular = key == "daily" or key == "often" or key == "weekly" or key == "fortnightly"
                local other = regular and rng() or 1
                if other < 0.16 and PB.openPart and PB.openPart[tokens.part] then
                    local line = teller:Say("openPart" .. tokens.part, PB.openPart[tokens.part], rng, tokens)
                    tokens.partUsed = tokens.part -- this line names the hour in words
                    Add(line)
                elseif other < 0.28 and mainZone and PB.openPlace then
                    Add(teller:Say("openPlace", PB.openPlace, rng, tokens))
                    placeSaid = true
                else
                    local greetPool = PB[key]
                    if teller.crowd then
                        local named = {}
                        for _, line in ipairs(PB[key] or {}) do if line:find("{name}", 1, true) then named[#named + 1] = line end end
                        if #named > 0 then greetPool = named end
                    end
                    -- Weekly voice overrides contain literal weeks and appointments.
                    -- This greeting describes the recorded interval, not an arrangement.
                    Add(teller:Say(key == "weekly" and "returnInterval" or key, greetPool, rng, tokens))
                end
                greeted = true
            end
            local run = (gap == 1) and (history.streak + 1) or 1
            if greeted and (run == 7 or run == 14 or run == 21 or run == 30) then
                tokens.nth, tokens.count, tokens.Count = Ordinal(run), Words(run), Cap(Words(run))
                Add(teller:Say("streak", PB.streak, rng, tokens))
                streakSaid = run
            end
        end
        teller.implicit = implicit
        -- Where the two of you stand.
        beat = "stage"
        if together then
            local diff = level and theirLevel and (level - theirLevel) or 0
            local bigGap = math.abs(diff) >= 8
            local caught = history.lastGap and history.lastGap >= 3 and diff == 0 and level
            if caught and rng() < 0.8 then
                Add(teller:Say("caughtUp", PB.caughtUp, rng, tokens))
            elseif bigGap and (history.days == 0 or rng() < 0.4) then
                if diff > 0 then Add(teller:Say("mentor", PB.mentor, rng, tokens))
                else Add(teller:Say("protege", PB.protege, rng, tokens)) end
            elseif stage and not bigGap and rng() < 0.25 and (history.stageSaid ~= stage) then
                history.stageSaid = stage
                Add(teller:Say("stage" .. stage, PB.stage[stage], rng, tokens))
            end
            if level and theirLevel then history.lastGap = math.abs(diff) end
        end

        -- 2. The land (not on the first page, which already says where).
        beat = "land"
        local firstPage = titleRank >= 100
        if together and f.outings > 0 and not firstPage and not placeSaid then
            local lv = L.ZoneLevels and L.ZoneLevels(mainZone)
            -- (home: where a people begins, or its city; Westfall is human land, but no one's home)
            local AtHome = (A.SelfTale and A.SelfTale.AtHome) or L.IsHome
            local myHome = AtHome and AtHome(player.race, mainZone)
            local theirHome = AtHome and AtHome(person.race, mainZone)
            local kind = zoneInfo and zoneInfo.kind
            local said = false
            local cooldown = history.landSaid and (index - history.landSaid) <= 1
            if landState == nil then landState = false end
            if kind ~= "city" and myHome and judged and lv and judged > lv[2] + 5 and #f.deaths == 0 and #f.dungeons == 0 then
                beat = "landKey"
                Add(teller:Say("homeNostalgic", PB.homeNostalgic, rng, tokens)); said = true
                TitleFrom(50, "home"); mood.warm = true
            elseif kind ~= "city" and myHome and zoneRun == 1 and #f.deaths == 0 and rng() < 0.5
                and ((judged and lv and judged > (lv[1] + lv[2]) / 2) or (history.zones[mainZone] and history.lastZone ~= mainZone)) then
                Add(teller:Say("home", PB.home, rng, tokens)); said = true; landState = true
                TitleFrom(50, "home")
            elseif kind ~= "city" and theirHome and myHome and zoneRun == 1 and rng() < 0.45 then
                local both = PB.homeBoth
                if not (L.IsStart and L.IsStart(player.race, mainZone) and L.IsStart(person.race, mainZone)) then
                    local kept = {}
                    for _, line in ipairs(both) do if not line:find("begun", 1, true) and not line:find("started", 1, true) then kept[#kept + 1] = line end end
                    if #kept > 0 then both = kept end
                end
                Add(teller:Say("homeBoth", both, rng, tokens)); said = true; landState = true
            elseif kind ~= "city" and theirHome and not myHome and zoneRun == 1 and rng() < 0.45 then
                Add(teller:Say("theirHome", PB.theirHome, rng, tokens)); said = true; landState = true
            elseif mainZone == history.firstZone and history.lastZone and history.lastZone ~= mainZone
                and (span >= 20 or startedTogether) and not history.beganSaid and rng() < 0.8 then
                beat = "landKey"
                history.beganSaid = true
                if startedTogether then Add(teller:Say("whereStarted", PB.whereStarted, rng, tokens))
                else Add(teller:Say("whereItBegan", PB.whereItBegan, rng, tokens)) end
                said = true
                mood.warm = true
            elseif kind ~= "city" and #f.dungeons == 0 and #f.deaths == 0 and judged and lv and judged >= lv[2] + 8 and zoneRun == 1 then
                Add(teller:Say("nostalgic", PB.nostalgic, rng, tokens)); said = true
                TitleFrom(35, "nostalgic")
            elseif kind ~= "city" and judged and lv and judged < lv[1] - 1 and not cooldown and zoneRun == 1
                and not (history.perilZones or {})[mainZone] and (index - (history.perilSaid or -99)) >= 4 then
                Add(teller:Say("perilous", PB.perilous, rng, tokens)); said = true
                history.perilZones = history.perilZones or {}
                history.perilZones[mainZone], history.perilSaid = true, index
            elseif kind ~= "city" and #f.dungeons == 0 and not history.zones[mainZone] and rng() < 0.6 and not cooldown and not startedTogether then
                Add(teller:Say("explore", PB.explore, rng, tokens)); said = true
                -- A first visit together: what you saw, and now and then what was at stake.
                local zs = L.ZoneStory and L.ZoneStory(mainZone)
                -- (a land your own book knows already: no first sight of it)
                for _, x in ipairs(ownJournal or {}) do
                    if x.k == "play" and x.z == mainZone and (x.t or 0) < (day.t or f.t or 0) - 3600 then zs = nil; break end
                end
                -- (not a line that names the other side's town for this character)
                local function Ours(list)
                    local kept = {}
                    for _, line in ipairs(list or {}) do
                        if not (A.SelfTale and A.SelfTale.NamesFoeTown and A.SelfTale.NamesFoeTown(line, player.faction)) then kept[#kept + 1] = line end
                    end
                    return #kept > 0 and kept or nil
                end
                local sight, stakes = zs and Ours(zs.sight), zs and Ours(zs.stakes)
                if sight then local line = sight[rng(#sight)]; history.zoneLinesSaid[line] = true; Add(line); f.zoneLore = (f.zoneLore or 0) + 1 end
                if stakes and rng() < 0.6 then local line = stakes[rng(#stakes)]; history.zoneLinesSaid[line] = true; Add(line); f.zoneLore = (f.zoneLore or 0) + 1 end
            elseif kind ~= "city" and history.zoneLastT[mainZone] and PB.zoneReturn and not cooldown and rng() < 0.6 then
                -- Back after a long while: "for the first time since March".
                local away = today - DayNumber(history.zoneLastT[mainZone])
                if away >= 30 and away < 300 then
                    tokens.month = date and date("%B", history.zoneLastT[mainZone]) or "the spring"
                    tokens.away = Span(away)
                    Add(teller:Say("zoneReturn", PB.zoneReturn, rng, tokens)); said = true
                end
            end
            if said then history.landSaid = index end
            beat = "travel"
        end
        -- A first sustained shared visit earns one grounded piece of setting,
        -- even when the opening used the relationship or level difference.
        -- These are facts about the country, not things the party supposedly
        -- inspected. Let that first scene have texture before routine visits
        -- become shorter; never describe the same country afresh every day.
        if together and discovery and mainZone and not history.zoneSetting[mainZone] then
            local setting = L.ZoneStory and L.ZoneStory(mainZone)
            if setting and not f.zoneLore then
                local pool = {}
                for _, line in ipairs(setting.sight or setting.stakes or {}) do
                    if not (A.SelfTale and A.SelfTale.NamesFoeTown and A.SelfTale.NamesFoeTown(line, player.faction)) then pool[#pool + 1] = line end
                end
                if pool and #pool > 0 then
                    beat = "land"
                    local line = pool[rng(#pool)]
                    history.zoneLinesSaid[line] = true
                    -- (a chapter must not open on the sight alone, "Lake Lordamere's shores lay beyond the
                    -- pines" with no word of where: the place first, 2026-11-06 review)
                    if #out == 0 and not placeSaid and PB.openPlace then
                        local was = beat
                        beat = "open"
                        Add(teller:Say("openPlace", PB.openPlace, rng, tokens))
                        placeSaid = true
                        beat = was
                    end
                    Add(line)
                    f.zoneLore = 1
                    beat = "travel"
                end
            end
            history.zoneSetting[mainZone] = true
        end
        -- A return can recall an actual shared scene instead of merely saying
        -- the name of the region again. The source is an earlier captured
        -- event, never a feeling, imagined conversation, or inferred route.
        local memory = mainZone and history.memories[mainZone]
        if together and memory and today - memory.day >= 14 and history.lastZone ~= mainZone
            and (index - (history.memorySaid or -99)) >= 8 and PB.sceneMemory and PB.sceneMemory[memory.kind] then
            tokens.memoryWhen = "in " .. (date and date("%B", memory.t) or "an earlier month")
            if date and date("%Y", memory.t) ~= date("%Y", day.t) then tokens.memoryWhen = tokens.memoryWhen .. " " .. date("%Y", memory.t) end
            -- (a memory from the same month is counted in days, not "in January" on the twentieth of it)
            if date and date("%Y-%m", memory.t) == date("%Y-%m", day.t) then tokens.memoryWhen = Span(today - memory.day) .. " before" end
            tokens.memoryPlace = memory.place and Place(memory.place) or tokens.zoneD
            beat = "landKey"
            Add(teller:Say("sceneMemory" .. memory.kind, PB.sceneMemory[memory.kind], rng, tokens))
            history.memorySaid = index
            beat = "travel"
        end
        -- Your own first time in this country, or on this continent, that fell on a day together:
        -- told where it happened, at the start, when it came before the day's work (a dungeon, a
        -- hand-in, a death); it used to trail the chapter after the level and the lord's fall
        -- (2026-11-06 review). The other shared moments keep their place further down.
        local toldEarly = {}
        local function ArrivalFirstLine(e)
            if e.k ~= "first" or e.u or not e.z then return nil end
            if e.d == "zone" and PB.shared.zoneFirst then
                tokens.zoneD = Place(e.z)
                tokens.zoneDWas = Plural(tokens.zoneD) and "were" or "was"
                return teller:Say("sharedZoneFirst", PB.shared.zoneFirst, rng, tokens)
            elseif e.d == "landmark" and PB.shared.landmark then
                tokens.what = Place(e.z)
                return teller:Say("sharedLandmark", PB.shared.landmark, rng, tokens)
            elseif e.d == "continent" and PB.shared.continent then
                local how
                for _, x in ipairs(moments) do if x.k == "voyage" and x.d and math.abs((x.t or 0) - (e.t or 0)) <= 120 then how = x.d end end
                tokens.to = Place(e.z)
                local pool = (how and PB.shared.continentBy and PB.shared.continentBy[how]) or PB.shared.continent
                local line = teller:Say("sharedContinent" .. (how or ""), pool, rng, tokens)
                if line then Title(60, Place(e.z), "shared") end
                return line
            end
        end
        if together and ownJournal and PB.shared then
            local firstWork
            for _, d in ipairs(f.dungeons) do if d.t and (not firstWork or d.t < firstWork) then firstWork = d.t end end
            for _, q in ipairs(f.quests) do if q.t and (not firstWork or q.t < firstWork) then firstWork = q.t end end
            for _, x in ipairs(f.deaths) do if x.t and (not firstWork or x.t < firstWork) then firstWork = x.t end end
            -- (a shared moment told further down, the herbs, a sunset, a crossing, is the day's
            -- work too: a first that came after it keeps its recorded place behind it)
            for _, e in ipairs(sceneMoments) do
                local arrival = e.k == "first" and (e.d == "zone" or e.d == "continent" or e.d == "landmark")
                if not arrival and e.t and (not firstWork or e.t < firstWork) then firstWork = e.t end
            end
            for _, e in ipairs(sceneMoments) do
                if e.k == "first" and (e.d == "zone" or e.d == "continent" or e.d == "landmark") and e.z and not e.u
                    and (e.z == mainZone or not firstWork or (e.t or 0) <= firstWork) then
                    local was = beat
                    beat = "shared"
                    local line = ArrivalFirstLine(e)
                    local wasT, wasZ = lineT, S.z
                    S.Stamp(e.t or wasT, e.z or wasZ)
                    if line then Add(line) end
                    S.Stamp(wasT, wasZ)
                    toldEarly[e] = true
                    beat = was
                end
            end
        end
        local firstEventful
        for _, d in ipairs(f.dungeons) do if #d.events > 0 and not firstEventful then firstEventful = d end end
        local before = 0
        if firstEventful then
            for _, quest in ipairs(f.quests) do if quest.t < (firstEventful.t or 0) then before = before + 1 end end
        end
        local prelude = before >= 3 and PB.prelude and together
        -- a quiet day (no dungeon) in one flowing sentence.
        local composed, restFolded = false, false
        if together and f.outings > 0 and not prelude and #f.dungeons == 0 and PB.day and PB.dayGo
            and not (zoneInfo and zoneInfo.kind == "city") then
            local ext = {}
            local function Fill(line)
                -- A descriptive place clause ends before the outing's duration:
                -- "in Desolace, where the clans make war, for three hours".
                if ext.inZone and ext.inZone:find(",", 1, true) then
                    line = line:gsub("{inZone}( for )", "{inZone},%1")
                end
                return (line:gsub("{(%a+)}", function(tok)
                    local v = ext[tok]
                    if v == nil then v = tokens[tok] end
                    if v == nil then v = teller.base[tok] end
                    if v == nil or v == false then return "{" .. tok .. "}" end
                    return tostring(v)
                end))
            end
            local zoneKey = mainZone and Clean(L.Display and L.Display(mainZone) or mainZone):gsub("^[Tt]he ", ""):match("^(%S+)")
            local zoneSaid = zoneKey and teller.saidPlaces and teller.saidPlaces[zoneKey] -- only what was written
            -- The zone's own "where" clause is the quiet day's one touch of color: 40%, and
            -- never for the same zone twice within five chapters.
            history.clauseSaid = history.clauseSaid or {}
            local clause
            if zoneInfo and zoneInfo.e and rng() < 0.4 and (index - (history.clauseSaid[mainZone] or -99)) >= 5 then
                for _, e in ipairs(zoneInfo.e) do if e:find(",") then clause = e end end
                if clause then history.clauseSaid[mainZone] = index end
            end
            ext.inZone = zoneSaid and "there" or ("in " .. (clause or Place(mainZone)))
            -- the same zone as yesterday is a callback, not a new place.
            local runSaid = zoneRun == 2 or zoneRun == 3 or zoneRun == 5 or zoneRun == 7 or zoneRun == 10
            if not zoneSaid and runSaid and not clause then
                local list = zoneRun >= 3 and PB.inZoneRun or PB.inZoneAgain
                if list and #list > 0 then ext.inZone = Fill(teller:Pick(zoneRun >= 3 and "inZoneRun" or "inZoneAgain", list, rng)) end
            end
            -- a routine day (nothing new, nothing lost, nothing notable) is told lighter.
            local quickNotable = false
            for _, quest in ipairs(f.quests) do
                local lore = L.Quest and L.Quest(quest.title)
                local ql, kind = quest.level or (lore and lore.level), quest.kind or (lore and lore.kind)
                if (ql and (quest.pl or level) and ql - (quest.pl or level) >= 3) or kind == 1 or kind == 81 or kind == 62 then quickNotable = true end
                local story = L.QuestStory and L.QuestStory(quest.title, quest.qid)
                if story and story.after and #story.after > 0 and not history.questLore[quest.qid or quest.title] then quickNotable = true end
            end
            local routine = history.days >= 3 and not majorOpen and not quickNotable and #f.deaths == 0 and #f.levels == 0 and #f.fires == 0
                and #f.rests == 0 and mainZone and history.zones[mainZone] and #f.zones < 2
            local short = routine and PB.dayShort and (history.lastShort or -99) < index - 1 and rng() < 0.22
            local preds = {}
            local runGo, plainGo = false, false
            if multiQuestPlan and #f.zones >= 2 and PB.dayGoPlain then
                -- The individual passages establish the places in order.
                preds[#preds + 1] = Fill(teller:Pick("dayGoPlain", PB.dayGoPlain, rng))
                -- ("You were there, finished X": the place already named leaves an empty verb)
                if preds[#preds] == "were there" then preds[#preds] = "spent some time there" end
                plainGo = true
            elseif #f.zones >= 2 and PB.dayGoMany then
                ext.from, ext.to = Place(f.zones[1]), Place(f.zones[#f.zones])
                preds[#preds + 1] = Fill(teller:Pick("dayGoMany", PB.dayGoMany, rng))
            elseif PB.dayGoRun and zoneRun >= 2 and not zoneSaid and not clause and #f.quests >= 3 and #f.fires == 0 and #f.rests == 0
                and #f.deaths == 0 and not short and rng() < 0.5 then
                -- the same zone as yesterday need not be named again; the title says it.
                preds[#preds + 1] = Fill(teller:Pick("dayGoRun", PB.dayGoRun, rng, nil, nil,
                    function(line) return landState and line:find("kept at it", 1, true) and true or false, false end))
                runGo = true
            elseif PB.dayGoPlain and #f.quests >= 1 and not (f.together >= 9000 or f.together < 1800 or history.days == 0
                or (PB.milestoneDays[history.days + 1] and #PB.milestoneDays[history.days + 1] > 0)) and rng() < 0.55 then
                -- The hours are not news every day.
                preds[#preds + 1] = Fill(teller:Pick("dayGoPlain", PB.dayGoPlain, rng))
                -- ("You were there, finished X": the place already named leaves an empty verb)
                if preds[#preds] == "were there" then preds[#preds] = "spent some time there" end
                plainGo = true
            elseif quietDay and PB.dayGoQuiet and not zoneSaid then
                preds[#preds + 1] = Fill(teller:Pick("dayGoQuiet", PB.dayGoQuiet, rng))
            else
                -- Once the place is named: verbs that stand without it (PB.dayGoHere).
                local own = teller.persona.dayGo
                local common = (zoneSaid and PB.dayGoHere) or PB.dayGo
                local list = (not zoneSaid and type(own) == "table" and #own > 0 and rng() < 0.5) and own or common
                local function NoPrior(line) return landState and (line:find("kept at it", 1, true) or line:find("^stayed")) and true or false, false end
                preds[#preds + 1] = Fill(teller:Pick(list == PB.dayGo and "dayGo" or list == PB.dayGoHere and "dayGoHere" or "dayGo@", list, rng, nil, nil, NoPrior))
            end
            -- The work, unless a hard or group quest will be told on its own.
            local notableQuest, notableKind = nil, nil
            for _, quest in ipairs(f.quests) do
                local lore = L.Quest and L.Quest(quest.title)
                local ql, kind = quest.level or (lore and lore.level), quest.kind or (lore and lore.kind)
                local pl = quest.pl or level
                -- ("work meant for more seasoned adventurers" is said once in a book, for a quest
                -- four levels or more above you; "work meant for a full party" one chapter in four)
                if deedsToday then -- (the deeds below tell the work by what was done, not by its title)
                elseif ql and pl and ql - pl >= 4 and not history.hardSaid then notableQuest, notableKind = quest, "hard"
                elseif not notableQuest and (kind == 1 or kind == 81 or kind == 62) and (index - (history.eliteSaid or -99)) >= 4 then notableQuest, notableKind = quest, "elite" end
            end
            -- A documented purpose makes a better scene than a level comparison.
            -- Keep difficulty/group phrasing as the fallback for uncatalogued work.
            do
                local best = 0
                for _, quest in ipairs(f.quests) do
                    local story = L.QuestStory and L.QuestStory(quest.title, quest.qid)
                    local importance = story and story.importance or 0
                    -- A quiet authored errand is still a complete scene; otherwise
                    -- dayAlt can announce its title before the later scene does.
                    if not deedsToday and story and story.after and #story.after > 0 and importance > best and not history.questLore[quest.qid or quest.title] then
                        notableQuest, notableKind, best = quest, "scene", importance
                    end
                end
                if notableKind == "scene" and L.QuestBeats then
                    -- Keep connected work in its recorded outing. A later
                    -- hand-in elsewhere cannot be moved into this scene.
                    local focusScene = notableQuest.scene
                    f.storyBeats = multiQuestPlan or L.QuestBeats(f.quests, history.questLore, #f.quests,
                        function(q) return q.scene ~= focusScene end)
                    if f.storyBeats[1] then notableQuest = f.storyBeats[1].quest end
                end
            end
            local n = #f.quests
            if multiQuestPlan and notableQuest then
                n = 0
                for _, quest in ipairs(f.quests) do if quest.scene == notableQuest.scene then n = n + 1 end end
            end
            if notableQuest and PB.dayWork and PB.dayWork[notableKind] then
                -- The hard or group quest is the day's work: named, folded in, and the title.
                ext.quest = Q(notableQuest.title)
                ext.count = Words(n)
                local workPool = notableKind == "scene" and n == 1 and PB.dayWork.sceneOne or PB.dayWork[notableKind]
                local work = Fill(teller:Pick("dayWork" .. notableKind, workPool, rng))
                preds[#preds + 1] = work
                f.notableWork = notableKind
                if notableKind == "hard" then history.hardSaid = index elseif notableKind == "elite" then history.eliteSaid = index end
                if notableKind == "scene" then
                    -- Keep the original anchor until its supported outcome has
                    -- been placed. Then the title announcement can leave the prose
                    -- without losing the day's travel, hours or other work.
                    local represented = 0
                    for _, chosen in ipairs(f.storyBeats or {}) do
                        if not multiQuestPlan or chosen.quest.scene == notableQuest.scene then represented = represented + 1 end
                    end
                    f.questCompletionCuts = f.questCompletionCuts or {}
                    f.questCompletionCuts[#f.questCompletionCuts + 1] = {
                        quest = notableQuest, fragment = work,
                        replacement = n > 1 and represented ~= n and ("completed " .. Words(n) .. " quests") or "",
                        predicate = true}
                    if represented == n and zoneSaid and #f.zones == 1 and not plainGo and not runGo
                        and history.days > 0 and f.together >= 1800 and f.together < 6 * 3600 then
                        f.durationOnlyCut = f.questCompletionCuts[#f.questCompletionCuts]
                    end
                end
                if notableKind == "scene" then
                    local story = L.QuestStory(notableQuest.title, notableQuest.qid)
                    local prior = story.thread and history.questThreads[story.thread]
                    beat = "questKey"
                    if (not notableQuest.qid or not story.why) and prior and prior.title ~= notableQuest.title and PB.questThreadReturn
                        and index - (history.threadSaid or -99) >= 2 then
                        tokens.previousQuest, tokens.quest = Q(prior.title), ext.quest
                        tokens.threadLabel = story.threadLabel
                        Add(teller:Say("questThreadReturn", PB.questThreadReturn, rng, tokens))
                        history.threadSaid = index
                    end
                    if story.why and not history.questSetups[notableQuest.qid or notableQuest.title] then
                        -- Keep setup beside its outcome, after the outing's
                        -- travel/duration sentence has established the scene.
                        f.questSetupLines = f.questSetupLines or {}
                        f.questSetupLines[notableQuest.qid or notableQuest.title] = story.why[rng(#story.why)]
                        history.questSetups[notableQuest.qid or notableQuest.title] = true
                    end
                    f.focusQuest = notableQuest.title
                    beat = "travel"
                end
                history.workSaid = index
                tokens.questFolded = true
                Title(25, Q(notableQuest.title))
            elseif n > 0 and not notableQuest and PB.dayWork and not deedsToday then
                local key = n == 1 and "one" or n == 2 and "two" or n <= 5 and "few" or "many"
                -- on a routine day the count need not be exact every time.
                if routine and n >= 3 and rng() < 0.4 and PB.dayWork[key .. "Vague"] then key = key .. "Vague" end
                ext.quest = Q(f.quests[1].title)
                ext.questB = f.quests[2] and Q(f.quests[2].title) or nil

                if ext.questB and ext.questB:find("[!?]}$") and not ext.quest:find("[!?]}$") then ext.quest, ext.questB = ext.questB, ext.quest end
                ext.count = Words(n)
                preds[#preds + 1] = Fill(teller:Pick("dayWork" .. key, PB.dayWork[key], rng))
                history.workSaid = index
                -- a named quest is a good vanilla title for a quiet day.
                if n == 1 then Title(25, Q(f.quests[1].title)) end
            end
            -- The fire or the inn, folded in; a first one gets its own short note after.
            local note
            -- A rest is folded in only if it came before the day's death (order stays true).
            local deathT
            for _, e in ipairs(f.deaths) do deathT = math.min(deathT or e.t or 0, e.t or 0) end
            local restFirst = not deathT or ((f.fireT or f.restT or 0) < deathT)
            -- (A rest after the death is told later, by the ordinary rest beat.)
            if not multiQuestPlan and restFirst and #f.fires > 0 and PB.dayRest then
                ext.inPlace = (f.fires[1] and f.fires[1] ~= mainZone) and (" in " .. Place(f.fires[1])) or ""
                preds[#preds + 1] = Fill(teller:Pick("dayRestfire", PB.dayRest.fire, rng))
                if history.fires == 0 and not startedTogether and history.days > 0 then
                    note = (firesAhead[index] >= 3 and PB.fireFirstAhead) and "fireFirstAhead" or "fireFirstNote"
                end
                restFolded = true
                TitleFrom(45, "fire"); mood.warm = true
            elseif not multiQuestPlan and restFirst and #f.rests > 0 and PB.dayRest then
                local place = f.rests[#f.rests]
                local inCity = L.Zone and L.Zone(place) and L.Zone(place).kind == "city"
                if not inCity then
                    ext.place = Place(place)
                    -- the same inn again.
                    history.innSeen = history.innSeen or {}
                    local again = history.innSeen[place] and PB.dayRest.innAgain
                    preds[#preds + 1] = Fill(teller:Pick(again and "dayRestinnAgain" or "dayRestinn", again or PB.dayRest.inn, rng))
                    history.innSeen[place] = (history.innSeen[place] or 0) + 1
                    if history.rests == 0 and not startedTogether then note = "innFirstNote" end
                    restFolded = true
                    TitleFrom(40, "inn"); mood.warm = true
                end
            end
            -- Nothing to add but the hours, and the place already said: no sentence.
            if #preds == 1 and zoneSaid and #out >= 2 then preds = {} end
            local told
            if #preds == 1 then told = preds[1]
            elseif #preds == 2 then told = preds[1] .. (preds[1]:find(",") and ", and " or " and ") .. preds[2]
            elseif #preds > 2 then told = table.concat(preds, ", ", 1, #preds - 1) .. ", and " .. preds[#preds] end
            tokens.day = told
            beat = "day"
            -- yesterday was held back to be told with today: one sentence for both days.
            local merged = history.merged
            if merged and told and gap == 1 and merged.zone == mainZone and PB.dayTwo then
                local total = merged.n + n
                tokens.weekdayA, tokens.WeekdayA, tokens.weekdayB = merged.weekday, merged.weekday, day.weekday
                tokens.count, tokens.Count = Words(total), Cap(Words(total))
                local list = total <= 1 and PB.dayTwoNone or (merged.run >= 2 and PB.dayTwoAgain) or PB.dayTwo
                Add(teller:Say("dayTwo", list, rng, tokens))
                tokens.weekday, tokens.Weekday = false, false
                history.merged = nil
                if titleRank <= 25 then title, titleRank, titleKey = nil, -1, nil end
                Title(30, (merged.run >= 2 and "Two More Days in " or "Two Days in ") .. Place(mainZone), "two:" .. mainZone)
                tellsTwo = true
                told, short = nil, false
            end
            if short then
                -- one routine day in five or so is a single short sentence.
                told = nil
                history.lastShort = index
                -- The quest it no longer names is not its title.
                if titleRank == 25 then title, titleRank, titleKey = nil, -1, nil end
                Add(teller:Say("dayShort", zoneRun >= 2 and PB.dayShortAgain or PB.dayShort, rng, tokens))
            end
            -- the deed first, on a day of many quests with nothing else folded in.
            if told and #preds == 2 and n >= 6 and not restFolded and not notableQuest and PB.dayDeed and rng() < 0.3 then
                -- (the plain name: a "where" clause inside this sentence would need a closing comma)
                tokens.inZone = "in " .. Place(mainZone) -- plain name; the run phrase broke "for {length}"
                tokens.count, tokens.Count = Words(n), Cap(Words(n))
                Add(teller:Say("dayDeed", PB.dayDeed, rng, tokens))
                tokens.inZone = nil
                told = nil
            end
            -- the subject need not be the two of you: the quest, the place, the hours. More often when
            -- one of the last two chapters opened on the two of you or the companion.
            local pairRecent = false
            local nameLow = FirstName(person):lower()
            for _, t in ipairs(history.openTwo or {}) do
                if t:find("^you and") or t:find("^the two") or t:find("^" .. nameLow, 1) or t:find("^with " .. nameLow, 1) then pairRecent = true end
            end
            if told and PB.dayAlt and not restFolded and not notableQuest and #f.zones < 2 and not zoneSaid and not runGo
                and (history.lastAlt or -99) < index - 1 and rng() < ((implicit or pairRecent) and 0.6 or 0.35) then
                local key = n == 0 and "none" or n == 1 and "one" or n == 2 and "two" or "few"
                local list = PB.dayAlt[key .. (plainGo and "Plain" or "")]
                if key == "none" and not tokens.part then list = nil end
                if (ext.quest and ext.quest:find("[!?]}$")) or (ext.questB and ext.questB:find("[!?]}$")) then list = nil end
                -- (a quest with no name left to say: not "included ." (lane C8))
                if (key == "one" or key == "two") and (not ext.quest or A.JournalPlain(ext.quest) == "") then list = nil end
                if key == "two" and (not ext.questB or A.JournalPlain(ext.questB) == "") then list = nil end
                if list and #list > 0 then
                    tokens.count, tokens.Count = Words(n), Cap(Words(n))
                    tokens.quest, tokens.questB = ext.quest or false, ext.questB or false
                    tokens.zoneDWas = Plural(Place(mainZone)) and "were" or "was"
                    Add(teller:Say("dayAlt" .. key, list, rng, tokens))
                    history.lastAlt = index
                    told = nil
                end
            end
            -- the place first, as the chapter's opening.
            if told and #preds >= 2 and #out == 0 and not zoneSaid and zoneRun == 1 and not plainGo and PB.dayLead and rng() < 0.25
                and ext.inZone:sub(1, 3) == "in " then
                local at = told:find(" " .. ext.inZone, 1, true)
                if at then
                    told = told:sub(1, at - 1) .. told:sub(at + 1 + #ext.inZone)
                    -- Fronting the place removes the complement of "were in".
                    -- Keep a complete duration predicate, including the comma
                    -- introduced when the place carried an appositive clause.
                    told = told:gsub("^were,? for ", "stayed for "):gsub("^were together, for ", "were together for ")
                    if #preds == 2 then told = told:gsub(", and ", " and ", 1) end
                    tokens.day, tokens.lead = told, Cap(ext.inZone)
                    Add(teller:Say("dayLead", PB.dayLead, rng, tokens))
                    tokens.lead = nil
                    told = nil
                end
            end
            if told then
                -- "With Kael, you ..." only names; "On Monday ..." only opens a chapter.
                local dayList = {}
                for _, line in ipairs(PB.day) do
                    if not ((teller.named or implicit) and (line:find("{name}", 1, true) or line:find("{pairNamed}", 1, true))) and not (#out > 0 and line:find("{weekday}", 1, true)) then
                        dayList[#dayList + 1] = line
                    end
                end
                local dayLine = teller:Say("day", dayList, rng, tokens)
                -- A terse teller's bare predicate still needs its pair subject.
                local bareVerb = dayLine and dayLine:match("^(%a+) ")
                if bareVerb == "Were" or bareVerb == "Spent" or bareVerb == "Stayed" then
                    dayLine = Cap(teller.base.we) .. " " .. dayLine:gsub("^%u", string.lower)
                end
                Add(dayLine)
                if f.durationOnlyCut and #preds == 2 and not restFolded then
                    -- Once every task has its scene, this line contains only
                    -- routine elapsed hours plus the redundant completion anchor.
                    f.durationOnlyCut.fragment = dayLine
                    f.durationOnlyCut.replacement = ""
                    f.durationOnlyCut.predicate = false
                end
            end
            if note and PB[note] then beat = "rest"; Add(teller:Say(note, PB[note], rng, tokens)) end
            tokens.day = nil
            composed = true
        end
        if not composed and together and f.outings > 0 and not firstPage and not prelude then
            local kind = zoneInfo and zoneInfo.kind
            local said = placeSaid or history.landSaid == index
            if #f.zones >= 2 then
                local lastZone = f.zones[#f.zones]
                for n2 = #f.zones, 1, -1 do if (f.zoneTime[f.zones[n2]] or 0) >= 300 then lastZone = f.zones[n2]; break end end
                if lastOuting and lastOuting.zone and ((lastOuting.e or 0) - (lastOuting.t or 0)) >= 300 then lastZone = lastOuting.zone end
                tokens.from, tokens.to = Place(f.zones[1]), Place(lastZone)
                -- (not when the day ends in a dungeon: going in names it)
                local endsInDungeon = f.byDungeon[lastZone] ~= nil
                if lastZone ~= f.zones[1] and not endsInDungeon and (f.together >= 3 * 3600 or rng() < 0.5) then Add(teller:Say("travelMany", PB.travelMany, rng, tokens)) end
            elseif f.together >= 3 * 3600 then
                local duration = teller:Say("travelLong", PB.travelLong, rng, tokens)
                if history.days == 0 or #f.dungeons == 0 or f.together >= 6 * 3600 then Add(duration) end
            elseif not said and #f.dungeons == 0 and not (kind == "city" and #f.rests > 0) then
                if not deedsToday and kind ~= "city" and #f.quests >= 2 and #f.quests <= 5 and PB.travelWork and rng() < 0.45 then
                    -- The road and the work in one breath.
                    Add(teller:Say("travelWork", PB.travelWork, rng, tokens))
                    history.workSaid = index
                else
                    Add(teller:Say(kind == "city" and "city" or "travel", kind == "city" and PB.city or PB.travel, rng, tokens))
                end
            end
        end
        S.Stamp(nil, nil)

        -- the level beat as a function too.
        local levelDone = false
        local function LevelBeat()
        -- 4. Levels. (stamped: the last level of theirs that day)
        S.Stamp(f.levelT, f.levelZ)
        S.lvl = true
        beat = "level"
        local ding = f.levels[#f.levels]
        -- Yours: recorded (a level-up while you travelled together), else read from
        -- the levels your entries carry (older journals).
        local recorded = f.myLevel and f.myLevel > 0 and f.myLevel or nil
        local mine = recorded or (f.plStart and f.plEnd and f.plEnd > f.plStart and f.plEnd) or nil
        tokens.theirs, tokens.mine = ding or theirLevel, mine or level
        -- (sixty is never dropped for room)
        if ding == 60 or mine == 60 then beat = "levelMark" end
        -- (the level that came with a run is folded into the run's end, never a bare tally, 2026-11-11)
        local runPlace, runKey
        for _, d in ipairs(f.dungeons) do
            if #d.events > 0 then
                local lastT = d.t or 0
                for _, ev in ipairs(d.events) do lastT = math.max(lastT, ev.t or 0) end
                local lt = f.myLevelT or f.levelT
                if lt and lt >= lastT - 60 and lt - lastT <= 45 * 60 then runPlace, runKey = Place(d.name), Clean(d.name):gsub("^[Tt]he ", ""):match("^(%S+)") end
            end
        end
        tokens.runPlace = runPlace or false
        -- (the place once a chapter: after it was named, the lines without it)
        local function RunPool(pool)
            if not pool then return nil end
            if not (runKey and teller.saidPlaces and teller.saidPlaces[runKey]) then return pool end
            local kept = {}
            for _, line in ipairs(pool) do if not line:find("{runPlace}", 1, true) then kept[#kept + 1] = line end end
            return #kept > 0 and kept or pool
        end
        if ding and mine and (recorded or rng() < 0.7) then
            S.levelMine = mine
            if runPlace and ding == mine and PB.runLevelBoth then Add(teller:Say("runLevelBoth", RunPool(PB.runLevelBoth), rng, tokens))
            elseif runPlace and PB.runLevelBothDiff then Add(teller:Say("runLevelBothDiff", RunPool(PB.runLevelBothDiff), rng, tokens))
            elseif ding == mine and PB.bothSame then Add(teller:Say("bothSame", PB.bothSame, rng, tokens))
            else Add(teller:Say("bothLevel", PB.bothLevel, rng, tokens)) end
        else
            if ding then
                local mark = PB.theyLevelMark[ding]
                if mark then
                    beat = "levelMark"
                    Add(teller:Say("mark" .. ding, mark, rng, tokens))
                    Title(ding == 60 and 90 or 55, "Level " .. ding)
                    if ding == 60 then blessOccasion = true end
                    -- Then and now: the level they had when you met.
                    local first = history.firstTheirLevel
                    if first and ding - first >= 10 and PB.levelThen and rng() < 0.6 then
                        tokens.thenLevel = first
                        Add(teller:Say("levelThen", (startedTogether and PB.levelThenOrigin) or PB.levelThen, rng, tokens))
                    end
                elseif runPlace and PB.runLevelTheirs then
                    Add(teller:Say("runLevelTheirs", RunPool(PB.runLevelTheirs), rng, tokens))
                else
                    Add(teller:Say("theyLevel", PB.theyLevel, rng, tokens))
                end
            end
            if mine and history.myLevelTold and mine <= history.myLevelTold then mine = nil end -- (a level told already is no news)
            if mine and (mine == 60 or rng() < (recorded and 0.75 or 0.4)) then
                if runPlace and mine ~= 60 and PB.runLevelMine then Add(teller:Say("runLevelMine", RunPool(PB.runLevelMine), rng, tokens))
                else Add(teller:Say("myLevel", PB.myLevel, rng, tokens)) end
                history.myLevelTold = mine; S.levelMine = mine
            end
        end
        S.Stamp(nil, nil)
        S.lvl = false
        end
        -- the rest beat as a function, told where it happened.
        local restDone = false
        local function RestBeat()
        local beforeRest = #out
        -- 6. Rest: a fire, an inn, a city. (stamped: the first fire or rest)
        S.Stamp(f.fireT or f.restT, f.restZ)
        beat = "rest"
        if #f.fires > 0 then
            tokens.place = f.fires[1] and Place(f.fires[1]) or tokens.zone
            local key = (history.fires == 0 and not startedTogether) and "first" or (history.fires >= 3 and "close" or "new")
            if key == "first" and history.days == 0 and PB.fireMeet then key = "Meet" end
            local same = history.firstFire and f.fires[1] == history.firstFire and history.fires >= 2
                and (index - (history.fireSameSaid or -99)) > 10 and PB.fireSame and rng() < 0.5
            if same then
                history.fireSameSaid = index
                Add(teller:Say("fireSame", PB.fireSame, rng, tokens))
            elseif key == "Meet" and table.concat(out, " "):lower():find("campfire", 1, true) then
                -- (met at the campfire: the meeting said the fire already; "I met Mortinna at a campfire
                -- in Tirisfal. There was a fire, and we stopped by it." told it twice, 2026-11-07)
            else
                Add(teller:Say("fire" .. key, (key == "Meet" and PB.fireMeet) or PB.fire[key], rng, tokens))
            end
            TitleFrom(45, "fire")
            mood.warm = true
        elseif #f.rests > 0 then
            local place = f.rests[#f.rests]
            local inCity = L.Zone and L.Zone(place) and L.Zone(place).kind == "city"
            tokens.place = Place(place)
            if inCity then
                Add(teller:Say("cityRest", PB.cityRest, rng, tokens))
            else
                -- "As before" only at an inn you have both rested at before.
                history.innSeen = history.innSeen or {}
                local key = (history.rests == 0 and not startedTogether) and "innFirst" or ((history.innSeen[place] or 0) >= 1 and "innClose" or "inn")
                history.innSeen[place] = (history.innSeen[place] or 0) + 1
                Add(teller:Say(key, PB[key], rng, tokens))
                TitleFrom(40, "inn")
                mood.warm = true
            end
        end

        if #out > beforeRest then temporalAnchors[#temporalAnchors + 1] = {
            first = beforeRest + 1, last = #out, t = f.fireT or f.restT or day.t} end
        S.Stamp(nil, nil)
        end
        -- 3. Dungeons, with what happened inside, in order. A long day of work
        -- before them is told first.
        if prelude then
            -- (stamped: the first of the quests it tells)
            S.Stamp(f.quests[1] and f.quests[1].t, f.quests[1] and (f.quests[1].z or (f.quests[1].scene and f.quests[1].scene.zone)))
            beat = "travel"
            tokens.pcount, tokens.Pcount, tokens.pcountN = Words(before), Cap(Words(before)), before
            local extras = {}
            local fireEarly = f.fireT and f.fireT < (firstEventful.t or 0)
            if fireEarly then extras[#extras + 1] = "stopped once for a fire" end
            for _, d in ipairs(f.dungeons) do
                local lv = L.DungeonLevels and L.DungeonLevels(d.name)
                local danger = Danger(d.pl or judged, lv and lv[1], lv and lv[2])
                d.fled = #d.events == 0 and d.outAfter ~= nil and (danger == "daring" or danger == "reckless") and danger or nil
                if #d.events == 0 and not d.fled and (d.t or 0) < (firstEventful.t or 0) and not d.briefTold then
                    extras[#extras + 1] = "took a short look into " .. Place(d.name)
                    d.briefTold = true
                end
            end
            tokens.extras = #extras == 1 and (" and " .. extras[1]) or #extras > 1 and (", " .. List(extras)) or ""
            -- with nothing folded in, the quests themselves can open the chapter.
            local alt = tokens.extras == "" and PB.preludeAlt and #PB.preludeAlt > 0 and rng() < 0.5
            Add(teller:Say(alt and "preludeAlt" or "prelude", alt and PB.preludeAlt or PB.prelude, rng, tokens))
            -- a long day's quests, named now and then (the one done again and again, or two of them)
            if before >= 6 and PB.preludeNamed and rng() < 0.7 then
                local counts, order = {}, {}
                for _, quest in ipairs(f.quests) do
                    if quest.t < (firstEventful.t or math.huge) then
                        if not counts[quest.title] then order[#order + 1] = quest.title end
                        counts[quest.title] = (counts[quest.title] or 0) + 1
                    end
                end
                local repeated
                for _, questTitle in ipairs(order) do if counts[questTitle] >= 3 and not repeated then repeated = questTitle end end
                if repeated then
                    tokens.questA, tokens.times = Q(repeated), (counts[repeated] == 3 and "three times" or (Words(counts[repeated]) .. " times"))
                    Add(teller:Say("preludeRepeat", PB.preludeRepeat, rng, tokens))
                elseif #order >= 2 then
                    local a = rng(#order)
                    local b = a % #order + 1
                    tokens.questA, tokens.questB = Q(order[a]), Q(order[b])
                    Add(teller:Say("preludeNamed", PB.preludeNamed, rng, tokens))
                end
            end
            if fireEarly and #f.rests == 0 then restDone = true; TitleFrom(45, "fire") end
            history.preludeSaid = index
            S.Stamp(nil, nil)
        end
        -- a fire or an inn before the first real dungeon is told here.
        local early = {}
        if not restDone and f.restT and firstEventful and f.restT < (firstEventful.t or 0) then early[#early + 1] = {f.restT, function() RestBeat(); restDone = true end} end
        if f.levelT and firstEventful and f.levelT < (firstEventful.t or 0) then early[#early + 1] = {f.levelT, function() LevelBeat(); levelDone = true end} end
        table.sort(early, function(a, b) return a[1] < b[1] end)
        for _, e in ipairs(early) do e[2]() end
        local pending = {}
        local loneBoss -- (the only boss of a visit: said with what it was)
        -- What a lord's fall meant: in a companion's book, another of its versions (your own book says the first).
        -- (the epithet lives in the consequence line too: "Archaedas, the ancient stone watcher. ...
        -- The ancient stone watcher no longer barred the way": then the kill says the name alone)
        local function EpithetInAfter(lore)
            if not lore or not lore.e or not lore.after then return false end
            local core = lore.e:gsub("{%a:([^}]*)}", "%1"):gsub("^[Tt]he ", ""):lower()
            if #core < 6 then return false end
            local function Has(line) return line and line:gsub("{%a:([^}]*)}", "%1"):lower():find(core, 1, true) ~= nil end
            if Has(lore.after) then return true end
            for _, more in ipairs(lore.afterMore or {}) do if Has(more) then return true end end
            return false
        end
        local function After(lore)
            if not lore or not lore.after then return nil end
            local choice = lore.after
            if lore.afterMore and #lore.afterMore > 0 then
                local h = 0
                for c in (person.name or ""):gmatch(".") do h = (h * 31 + c:byte()) % 9973 end
                choice = lore.afterMore[h % #lore.afterMore + 1]
            end
            -- (one that says no name the chapter has said: not "Westfall was rid of Edwin VanCleef" after his kill)
            if not Fresh(choice) then
                local said = table.concat(out, " "):gsub("{%a:([^}]*)}", "%1")
                local function Repeats(phrase)
                    local n = 0
                    for word in phrase:gmatch("%u[%a]+") do if #word >= 5 and said:find(word, 1, true) then n = n + 1 end end
                    return n
                end
                local best, bestN = choice, Repeats(choice)
                for _, other in ipairs(lore.afterMore or {}) do if Repeats(other) < bestN then best, bestN = other, Repeats(other) end end
                if Repeats(lore.after) < bestN then best = lore.after end
                return best
            end
            return choice
        end
        local pendingLord -- (the lord of the place, killed before the final kill: told in the roll, not split off)
        -- (the kills that cost the companion, said after the roll that holds them, 2026-11-11 round 2)
        local function CostLines(d)
            if not (d and d.costRoll) then return end
            for _, boss in ipairs(pending) do
                if d.costRoll[boss] then
                    tokens.boss, tokens.bossShort = Place(boss), ShortRaw(boss)
                    Add(teller:Say("theyDieBossInRoll", PB.theyDieBossInRoll, rng, tokens))
                    d.costRoll[boss] = nil
                end
            end
        end
        local function Flush(required)
            if #pending == 0 then return end
            local was = beat
            beat = required and "climax" or "kills"
            -- (one boss, and it cost the companion: "Old Serra'kis took Corwin down before falling" says the kill)
            if #pending == 1 and not pendingLord and S.r and S.r.costRoll and S.r.costRoll[pending[1]] then
                CostLines(S.r)
                pending = {}
                beat = was
                return
            end
            local names = {}
            -- (a long roll is cut: the first three and how many more, as the shared shaper does)
            if #pending > 4 and not pendingLord then
                for i = 1, 3 do names[#names + 1] = Place(pending[i]) end
                tokens.bosses = List(names) .. " and " .. Words(#pending - 3) .. " more"
            else
                for _, boss in ipairs(pending) do names[#names + 1] = Place(boss) end
                tokens.bosses = List(names)
            end
            if pendingLord then
                -- The lord fell with the others, not last: one sentence, the lord with
                -- its epithet in its place ("Taragaman the Hungerer, the felguard who led
                -- the Searing Blade, and after that Jergosh the Invoker and Bazzalan").
                local lord = pendingLord
                pendingLord = nil
                local lo = L.Boss and L.Boss(lord)
                local epithet = lo and lo.e and not history.bosses[lord] and Fresh(lo.e) and not EpithetInAfter(lo) and lo.e
                local lordAt
                for i, b in ipairs(pending) do if b == lord then lordAt = i end end
                -- (the shape from the shared shaper: the ones before, cut to two and a count when four or
                -- more, the goal, the ones after)
                local shape = A.JournalEpisodes and A.JournalEpisodes.ShapeKills and A.JournalEpisodes.ShapeKills(pending,
                    function(n) return n == S.goalLord end, function(n) return n == lord end)
                local function Names(a, b)
                    local t = {}
                    if shape and a == 1 and b == lordAt - 1 and shape.more > 0 then
                        for _, n in ipairs(shape.shown) do t[#t + 1] = Place(n) end
                        return List(t) .. " and " .. Words(shape.more) .. " more"
                    end
                    for i = a, b do t[#t + 1] = Place(pending[i]) end
                    return List(t)
                end
                beat = "climax"
                if #pending == 1 then
                    tokens.boss, tokens.short, tokens.bossE = Place(lord), Short(lord), epithet or false
                    tokens.shortRaw = ShortRaw(lord) ~= Place(lord) and ShortRaw(lord) or false
                    if epithet then Add(teller:Say("killNamed", PB.killNamed, rng, tokens))
                    else Add(teller:Say("killOne", PB.killOne, rng, tokens)) end
                else
                    local lordText = Place(lord) .. (epithet and (", " .. epithet) or "")
                    local roll
                    -- (the lord as the goal, 2026-11-11: a hand-in of the day about the run names it)
                    local goal = S.goalLord == lord and lordAt > 1 and ((lordAt == #pending and PB.killRollGoalLast) or (lordAt < #pending and PB.killRollGoalMid)) or nil
                    if goal and T.BondKind(person) == "close" and not teller.crowd then
                        goal = (lordAt == #pending and PB.killRollGoalLastBond) or (lordAt < #pending and PB.killRollGoalMidBond) or goal
                    elseif goal and T.BondKind(person) == "close" then
                        goal = (lordAt == #pending and PB.killRollGoalLastParty) or (lordAt < #pending and PB.killRollGoalMidParty) or goal
                    end
                    if goal then
                        tokens.before, tokens.lordText = Names(1, lordAt - 1), lordText
                        tokens.after = lordAt < #pending and Names(lordAt + 1, #pending) or false
                        tokens.shortRaw = ShortRaw(lord)
                        Add(teller:Say(lordAt == #pending and "killRollGoalLast" or "killRollGoalMid", goal, rng, tokens))
                    else
                        if lordAt == #pending then roll = Names(1, #pending - 1) .. (#pending == 2 and ", and then " or ", and last of all ") .. lordText
                        elseif lordAt == 1 then roll = lordText .. ", and after that " .. Names(2, #pending)
                        else roll = Names(1, lordAt - 1) .. ", then " .. lordText .. ", and after that " .. Names(lordAt + 1, #pending) end
                        tokens.roll = roll
                        Add(teller:Say("killRoll", PB.killRoll, rng, tokens))
                    end
                end
                BossTitle(80, lord)
                mood.triumph = true
                CostLines(S.r)
                if not history.bosses[lord] then
                    blessOccasion = true
                    if lo and lo.after then Add(After(lo)); flourish = flourish + 1 end
                end
                pending = {}
                beat = was
                return
            end
            if #pending == 1 then
                local lore = L.Boss and L.Boss(pending[1])
                local kind = lore and lore.kind or "humanoid"
                tokens.boss, tokens.short = Place(pending[1]), Short(pending[1])
                if loneBoss == pending[1] and lore and lore.e then
                    -- ("Herod, the Scarlet Champion, fell.")
                    tokens.boss = Place(pending[1]) .. ", " .. lore.e .. ","
                    Add((teller:Say("killOne", PB.killOne, rng, tokens) or ""):gsub(",,", ","):gsub(",%.", "."))
                elseif rng() < 0.5 then Add(teller:Say("kill" .. kind, PB.kill[kind], rng, tokens))
                else Add(teller:Say("killOne", PB.killOne, rng, tokens)) end
            elseif #pending == 2 then
                Add(teller:Say("killTwo", PB.killTwo, rng, tokens))
            else
                Add(teller:Say("killMany", PB.killMany, rng, tokens))
            end
            CostLines(S.r)
            pending = {}
            beat = was
        end
        -- Who brought you back (said right after your death in a dungeon, else with the deaths).
        local rezSaid = false
        local function RezLine(rt)
            if rt then S.rezTold[rt] = true end
            local by = rt and rt ~= true and f.rezBy and f.rezBy[rt]
            if by and PB.rezOther then
                -- (round 4: a raise by someone else, with who; a stranger when no party window of
                -- your own book covers the moment)
                local inParty = false
                local first = by:match("^(%S+)") or by
                -- (the same hand three times and more in a day, lane G 2026-11-11: the clause once,
                -- then one line for the rest, never "but Faelyn brought you back" after every death)
                S.rezHands = S.rezHands or {}
                local hand = S.rezHands[first:lower()]
                if not hand then
                    hand = {total = 0, said = 0}
                    for _, b2 in pairs(f.rezBy) do if (tostring(b2):match("^(%S+)") or tostring(b2)):lower() == first:lower() then hand.total = hand.total + 1 end end
                    S.rezHands[first:lower()] = hand
                end
                hand.said = hand.said + 1
                if hand.total >= 3 and hand.said >= 2 then
                    if hand.said == hand.total and PB.rezEachTime then
                        tokens.raiser = "{n:" .. first .. "}"
                        Add(teller:Say("rezEachTime", PB.rezEachTime, rng, tokens))
                    end
                    return
                end
                -- (the companion whose book this is was in the party by definition)
                if first:lower() == tostring(FirstName(person) or ""):lower() then inParty = true end
                for _, x in ipairs(ownJournal or {}) do
                    if x.k == "with" and x.n and (Clean(x.n):gsub("%-.*$", "")):lower() == first:lower() and (x.t or 0) <= rt and (x.e or x.t or 0) >= rt then inParty = true end
                end
                tokens.raiser = "{n:" .. (inParty and first or by) .. "}"
                local prev = out[#out]
                local prevWords = 0
                for _ in (prev or ""):gmatch("%S+") do prevWords = prevWords + 1 end
                if inParty and PB.rezOtherClause and prev and outBeat[#out] == "death" and prev:sub(-1) == "." and prevWords <= 22
                    and select(2, prev:gsub(", and ", "")) <= 1 and not prev:find(", but ", 1, true) then
                    local clause = teller:Say("rezOtherClause", PB.rezOtherClause, rng, tokens)
                    if clause then
                        out[#out] = S.Carry(prev, prev:sub(1, -2) .. ", but " .. clause:gsub("%.$", ""):gsub("^%u", string.lower) .. ".")
                        return
                    end
                end
                Add(teller:Say(inParty and "rezOther" or "rezStranger", inParty and PB.rezOther or (PB.rezStranger or PB.rezOther), rng, tokens))
                return
            end
            rezSaid = true
                local key = history.rez > 0 and "close" or ((history.days == 0 and not startedTogether) and "new" or "companion")
                tokens.count = Words(history.rez + f.rez)
                tokens.countTimes = (history.rez + f.rez) == 2 and "twice" or (Words(history.rez + f.rez) .. " times")
                local byClass = PB.rezClass[person.class or ""]
                local rezTotal = history.rez + f.rez
                if PB.rezCount and PB.rezCount[rezTotal] then Add(teller:Say("rezCount" .. rezTotal, PB.rezCount[rezTotal], rng, tokens))
                elseif byClass and rng() < 0.45 then Add(teller:Say("rezClass", byClass, rng, tokens))
                else Add(teller:Say("rez" .. key, PB.rez[key], rng, tokens)) end
                mood.warm = true
        end
        -- You brought them back (said right after their death). Your own book's first-ever
        -- raise of this companion says it on that day instead.
        local rezGivenSaid = false
        for _, e in ipairs(sceneMoments) do
            if e.k == "first" and e.d == "rezother" and not e.u and e.n
                and Clean(e.n):lower() == (Clean(person.name or ""):gsub("%-.*$", "")):lower() then rezGivenSaid = true end
        end
        local function RezGivenLine()
            if rezGivenSaid or not (f.rezGiven and f.rezGiven > 0) or not PB.rezGiven then return end
            rezGivenSaid = true
            local was = beat
            beat = "rez"
            local byClass = PB.rezGivenClass and PB.rezGivenClass[player.class or ""]
            if player.class == "PRIEST" and not ({Human = true, Dwarf = true, Gnome = true})[player.race or ""] then byClass = nil end
            -- (the class's own words every other time: a counter, not a draw)
            history.rezGiven = (history.rezGiven or 0) + 1
            if byClass and history.rezGiven % 2 == 0 then Add(teller:Say("rezGivenClass", byClass, rng, tokens))
            else Add(teller:Say("rezGiven", PB.rezGiven, rng, tokens)) end
            mood.warm = true
            beat = was
        end
        -- one quest turned in before the first dungeon: said first, where it was
        if #f.dungeons > 0 and PB.preludeOne and history.preludeSaid ~= index then
            local firstD = f.dungeons[1]
            local firstBefore = {}
            for n2, quest in ipairs(f.quests) do if quest.t < (firstD.t or 0) then firstBefore[#firstBefore + 1] = n2 end end
            if #firstBefore == 1 then
                local quest = f.quests[firstBefore[1]]
                local where
                for _, scene in ipairs(day.scenes) do
                    if scene.kind == "outing" and quest.t >= scene.t - 60 and quest.t <= (scene.e or scene.t) + 60 then where = scene.zone end
                end
                if where and where ~= firstD.name then
                    tokens.quest, tokens.zoneD = Q(quest.title), Place(where)
                    S.Stamp(quest.t, quest.z or where)
                    Add(teller:Say("preludeOne", PB.preludeOne, rng, tokens))
                    S.Stamp(nil, nil)
                    table.remove(f.quests, firstBefore[1])
                end
            end
        end
        local routeSaid = false
        for di, d in ipairs(f.dungeons) do
            local beforeDungeon = #out
            -- (stamped: going in at the dungeon's time; each fight below at its own)
            S.Stamp(d.t, d.name)
            S.r = d -- (the run's lines, one paragraph)
            S.goalLord = d.goal
            do
                local bossCount, only = 0, nil
                for _, ev in ipairs(d.events) do if ev.k == "boss" then bossCount = bossCount + 1; only = ev.d end end
                loneBoss = bossCount == 1 and only or nil
            end
            beat = "dungeon"
            -- (on to where the dungeon lies, when the day's work was elsewhere)
            if not routeSaid and #d.events > 0 and PB.routeOn and history.preludeSaid == index and not d.briefTold then
                routeSaid = true
                local host, hostT
                for _, scene in ipairs(day.scenes) do
                    if scene.kind == "outing" and d.t >= scene.t - 60 and d.t <= scene.e + 60 and scene.zone ~= d.name then host, hostT = scene.zone, scene.t end
                end
                if host and host ~= mainZone and rng() < 0.85 then
                    -- the zones crossed between the day's work and the dungeon, in order
                    local via, seen, lastMain = {}, {}, 0
                    for _, scene in ipairs(day.scenes) do
                        if scene.kind == "outing" and scene.zone == mainZone then lastMain = math.max(lastMain, scene.t) end
                    end
                    for _, scene in ipairs(day.scenes) do
                        local z = scene.kind == "outing" and scene.zone
                        if z and scene.t > lastMain and scene.t < (hostT or 0) and z ~= host and z ~= mainZone and not seen[z]
                            and not (L.Dungeon and L.Dungeon(z)) then
                            seen[z] = true
                            via[#via + 1] = Place(z)
                        end
                    end
                    tokens.zoneTo = Place(host)
                    -- (named here even if said before: this is the way you went)
                    local savedPlaces = teller.saidPlaces
                    teller.saidPlaces = {}
                    if #via > 0 and PB.routeVia then
                        tokens.via = List(via)
                        Add(teller:Say("routeVia", PB.routeVia, rng, tokens))
                    else
                        Add(teller:Say("routeOn", PB.routeOn, rng, tokens))
                    end
                    teller.saidPlaces = savedPlaces
                end
            end
            local name = d.name
            local info = L.Dungeon and L.Dungeon(name)
            local lv = L.DungeonLevels and L.DungeonLevels(name)
            local danger = Danger(d.pl or judged, lv and lv[1], lv and lv[2])
            local dungeonE
            if info and info.e and rng() < 0.25 then
                local options = {}
                for _, e in ipairs(info.e) do if not e:find(",") then options[#options + 1] = e end end
                dungeonE = options[1] and options[rng(#options)]
            end
            tokens.dungeonE = dungeonE or Place(name)
            tokens.dungeonWas = Plural(tokens.dungeonE) and "were" or "was"
            local visits = history.dungeons[name] or 0
            -- The run's place in this book's history of the place (2026-11-06): the lord of the
            -- place (Lore's `last`), whether this run reached it, the run before, the last kill.
            local lordList = A.DungeonLast and A.DungeonLast(name) or nil
            local lordSet = {}
            for _, l in ipairs(lordList or {}) do lordSet[l] = true end
            local lordHere = lordList and lordList[1]
            do
                local wing = L.DungeonSight and L.DungeonSight(name, d.events)
                if wing and wing.bosses and lordSet[wing.bosses[#wing.bosses]] then lordHere = wing.bosses[#wing.bosses] end
            end
            local reached, lastKill, killCount = false, nil, 0
            for _, ev in ipairs(d.events) do
                if ev.k == "boss" then killCount = killCount + 1; lastKill = ev.d; if lordSet[ev.d] then reached = true; lordHere = ev.d end end
            end
            local left = false
            for _, scene in ipairs(day.scenes) do
                if scene.kind == "outing" and scene.zone and scene.zone ~= name and (scene.t or 0) > (d.t or 0) then left = true end
            end
            local lordBeat
            for _, ev in ipairs(d.events) do
                if (ev.k == "wipe" and lordSet[ev.d]) or (ev.k == "death" and ev.e and lordSet[ev.e.boss or ev.e.d]) then lordBeat = ev.k == "wipe" and ev.d or (ev.e.boss or ev.e.d) end
            end
            local unfinished = killCount > 0 and lordHere and not reached or false
            d.reached, d.unfinished = reached, unfinished
            local unfinishedBefore = history.unfinishedLast[name]
            local lordDoneBefore = history.lordDone[name]
            tokens.lord = lordHere and Place(lordHere) or false
            tokens.nth = Ordinal(visits + 1)
            local decorated = dungeonE ~= nil and dungeonE ~= Place(name)
            tokens.lore = (not decorated and visits == 0 and info and info.lore) and info.lore[rng(#info.lore)] or false
            local grief = history.diedIn[name]
            -- A run that avenges a lost fight says so itself ("Arugal had beaten you
            -- before"): no "where you had died" on the way in.
            local avenges = false
            for _, ev in ipairs(d.events) do if ev.k == "boss" and history.beaten[ev.d] then avenges = true end end
            -- (A brief visit may already be told with the evening's work: d.briefTold.)
            local fled = #d.events == 0 and d.outAfter and (danger == "daring" or danger == "reckless")
            local story = L.DungeonStory and L.DungeonStory(name)
            -- A first visit together is told with its lore: going in, why, then one
            -- sight inside. The why and the dungeon's epithet are not both said.
            local whyLine
            if story and story.why and visits == 0 and #d.events > 0 and not fled and not d.briefTold then
                -- (not one that names a boss the kills are about to name)
                local whys = story.why
                if L.WithoutBosses then
                    local bossesHere = {}
                    for _, ev in ipairs(d.events) do if ev.k == "boss" then bossesHere[#bossesHere + 1] = ev.d end end
                    whys = L.WithoutBosses(story.why, bossesHere) or story.why
                end
                -- (round 12, a companion book: a reason that is someone's quest, "Magatha Grimtotem wanted
                -- word of a servant", only when that person's quest was done that day; else the place's own)
                do
                    local givers = {}
                    local QD = A.QuestDeeds
                    for _, q in ipairs(f.quests) do
                        local st = QD and QD.Story and QD.Story(q)
                        local g = st and ((st.pov and st.pov.giver) or (QD.Giver and QD.Giver(st)))
                        if type(g) == "string" then givers[Clean(g)] = true end
                    end
                    local kept = {}
                    for _, w in ipairs(whys) do
                        local who = w:match("^(%u[%a']+ %u[%a']+) wanted ")
                        if not who or givers[who] then kept[#kept + 1] = w end
                    end
                    if #kept > 0 then whys = kept end
                end
                whyLine = whys[rng(#whys)]
                local own = story.whyRaceC and story.whyRaceC[player.race or ""]
                if own then whyLine = teller:Say("whyRaceC" .. name, own, rng, tokens) or whyLine end
                d.whySaid = true
                tokens.dungeonE, tokens.lore = Place(name), false
                tokens.dungeonWas = Plural(tokens.dungeonE) and "were" or "was"
            end
            local namedAlready = di == 1 and not d.briefTold
                and (#d.events > 0 or (firstOuting and firstOuting.zone == name))
                and table.concat(out, " "):gsub("{%a:([^}]*)}", "%1"):find(Clean(name), 1, true)
            local goingIn = #out
            -- (namedAlready: said; the why and the inside follow)
            if namedAlready and not fled then
                d.goneIn = true
            elseif fled and PB.dungeonFled and not d.briefTold then
                -- Too high for you, and out again at once: told as it was.
                tokens.above = danger == "reckless" and "far above" or "above"
                tokens.quick = d.outAfter <= 60 and "within a minute" or "a few minutes later"
                Add(teller:Say("dungeonFled", PB.dungeonFled, rng, tokens))
            elseif #d.events == 0 and PB.dungeonBrief and not d.briefTold and name ~= mainZone then
                -- a visit with nothing in it gets one plain clause (not in Highlights; the draw is made in both).
                local line = teller:Say("dungeonBrief", PB.dungeonBrief, rng, tokens)
                if not brief then Add(line) end
            elseif d.briefTold then
                d.briefTold = true
            elseif di > 1 and #out > 0 then
                tokens.part = PartOf(Hour(d.t))
                local h = Hour(d.t)
                tokens.clock = (h == 23 and "near midnight") or (h < 4 and "after midnight") or false
                if tokens.clock and PB.dungeonClock and rng() < 0.7 then
                    Add(teller:Say("dungeonClock", PB.dungeonClock, rng, tokens))
                else
                    Add(teller:Say("dungeonLater", PB.dungeonLater, rng, tokens))
                end
            elseif visits > 0 and grief and PB.dungeonGrief and rng() < 0.6 and not avenges then
                -- Back where one of you died the last time.
                history.diedIn[name] = nil
                Add(teller:Say("dungeonGrief" .. grief, PB.dungeonGrief[grief], rng, tokens))
            elseif visits >= 2 and PB.dungeonRegular then
                -- (the third run and after: the plain count and the familiar place take turns; a return
                -- is never told with the first-visit line)
                history.knownN = (history.knownN or 0) + 1
                local known = PB.dungeonKnown and history.knownN % 2 == 0
                Add(teller:Say(known and "dungeonKnown" or "dungeonRegular", known and PB.dungeonKnown or PB.dungeonRegular, rng, tokens))
            elseif visits > 0 then
                tokens.nth = Ordinal(visits + 1)
                Add(teller:Say("dungeonAgain", PB.dungeonAgain, rng, tokens))
            else
                Add(teller:Say("dungeon" .. danger, PB.dungeon[danger], rng, tokens))
            end
            -- (the epithet once a chapter: after the going-in line the plain name, not "the tunnels of the
            -- Deadmines" three times over, 2026-11-06 review)
            if dungeonE and #out > goingIn then tokens.dungeonE = Place(name); tokens.dungeonWas = Plural(tokens.dungeonE) and "were" or "was" end
            -- ("down into" only where it is under the ground: a spire is climbed, a city walked into)
            local under = A.SelfTale and A.SelfTale.Underground
            if under and not under[name] then
                for n2 = goingIn + 1, #out do out[n2] = S.Carry(out[n2], (out[n2]:gsub(" down into ", " into "))) end
            end
            if whyLine then Add(whyLine) end
            -- A return: what the last run left (the lord unbeaten), and now and then a line of
            -- what the place is like on a return (Lore's `again`, every other return; not in Highlights).
            if visits > 0 and killCount > 0 and not fled then
                if unfinishedBefore and reached and PB.dungeonReturnUnfinished then
                    Add(teller:Say("dungeonReturnUnfinished", PB.dungeonReturnUnfinished, rng, tokens))
                    d.atLast = true
                end
                if story and story.again then
                    history.againN = (history.againN or 0) + 1
                    if history.againN % 2 == 1 then
                        local bossesHere = {}
                        for _, ev in ipairs(d.events) do if ev.k == "boss" then bossesHere[#bossesHere + 1] = ev.d end end
                        local lines = (L.WithoutBosses and L.WithoutBosses(story.again, bossesHere)) or story.again
                        local was = beat
                        beat = "again"
                        Add(lines[rng(#lines)])
                        beat = was
                    end
                end
            end
            -- what it was like inside (a first visit): the concrete thing seen there by preference
            -- (your own book tells this dungeon this day: one lore line here, the why)
            local ownTells = false
            for _, x in ipairs(ownJournal or {}) do
                if x.k == "dungeon" and x.d == name and math.abs((x.t or 0) - (d.t or 0)) < 4 * 3600 then ownTells = true end
            end
            if d.whySaid and (story.inside or story.detail) and not ownTells then
                local sight = L.DungeonSight and L.DungeonSight(name, d.events)
                local detail, insideLines = (sight and sight.detail) or story.detail, (sight and sight.inside) or story.inside
                -- (not a line that names a boss the kills are about to name)
                local bossesHere = {}
                for _, ev in ipairs(d.events) do if ev.k == "boss" then bossesHere[#bossesHere + 1] = ev.d end end
                if L.WithoutBosses then detail = L.WithoutBosses(detail, bossesHere) end
                if L.WithoutBosses then insideLines = L.WithoutBosses(insideLines, bossesHere) or (not detail and insideLines) or nil end
                local list = (detail and (not insideLines or rng() < 0.6)) and detail or insideLines
                if list then Add(list[rng(#list)]) end
            end
            beat = "climax"
            local everFirst = false
            if ownJournal and PB.dungeonFirstEver and #d.events > 0 and di == 1 and history.dungeonRuns == 0 and mySelf and (mySelf.startLevel or 99) <= 9 then
                everFirst = true
                for _, x in ipairs(ownJournal) do if x.k == "dungeon" and (x.t or 0) < (d.t or 0) then everFirst = false end end
            end
            if everFirst and not teller.crowd then
                local both = startedTogether and PB.dungeonFirstEverBoth
                Add(teller:Say(both and "dungeonFirstEverBoth" or "dungeonFirstEver", both or PB.dungeonFirstEver, rng, tokens))
            elseif #d.events > 0 and history.dungeonRuns == 0 and di == 1 and history.days > 0 and rng() < 0.8 and not startedTogether then
                local firsts = PB.dungeonFirst
                if teller.crowd then
                    local kept = {}
                    for _, line in ipairs(firsts) do if not line:find("Neither", 1, true) and not line:find("together", 1, true) then kept[#kept + 1] = line end end
                    firsts = #kept > 0 and kept or nil
                end
                if firsts then Add(teller:Say("dungeonFirst", firsts, rng, tokens)) end
            end
            -- Inside: bosses (the lord of the place last), deaths, lost fights.
            local killedAt = {}
            for _, ev in ipairs(d.events) do
                local boss = ev.k == "boss" and L.Boss and L.Boss(ev.d)
                if ev.k == "boss" and not (boss and boss.victory) then killedAt[ev.d] = ev.t end
            end
            -- (fights lost and won later; your deaths to them)
            local wipeWon, diedTo = {}, {}
            for _, ev in ipairs(d.events) do
                if ev.k == "wipe" and killedAt[ev.d] and killedAt[ev.d] > (ev.t or 0) then wipeWon[ev.d] = true end
                if ev.k == "death" and ev.e and ev.e.w == "you" and (ev.e.boss or ev.e.d) then diedTo[ev.e.boss or ev.e.d] = true end
            end
            -- (lane G, 2026-11-11: your deaths to the place's ordinary foes, two or more in a run, are
            -- one sentence after the kills, not a line and a raise each between them)
            d.gatherYou = {}
            for _, ev in ipairs(d.events) do
                local e = ev.k == "death" and ev.e
                if e and e.w == "you" and e.d and not e.boss and not e.env and not ev.wipe and not ev.wipeOf and not wipeWon[e.d] then d.gatherYou[#d.gatherYou + 1] = ev end
            end
            if #d.gatherYou >= 2 and PB.runLosses then for _, ev in ipairs(d.gatherYou) do ev.gathered = true end else d.gatherYou = nil end
            local lastBoss, finalKill
            for _, ev in ipairs(d.events) do
                local lore = ev.k == "boss" and L.Boss and L.Boss(ev.d)
                if lore and lore.last then lastBoss = ev.d end
                if ev.k == "boss" then finalKill = ev.d end
            end
            local climax = lastBoss and lastBoss == finalKill
            -- A selected hand-in can fall between encounters. Keep individual
            -- conflict anchors so its whole quest passage stays on the right
            -- side of each recorded kill, death or wipe.
            -- (recorded work on either side of a dungeon's fights keeps them as anchors, 2026-11-07)
            local questConflicts = (multiQuestPlan or #f.quests > 0) and #d.events > 0
            -- A kill is flushed on its own only when a turn-in really falls between it and
            -- the next recorded event; otherwise the kills stay one sentence, as the own
            -- journal tells them, and the anchor of the later event carries them.
            local function TurnInBefore(evIndex)
                local ev, nextEv = d.events[evIndex], d.events[evIndex + 1]
                if not nextEv then return true end
                local a, b = ev.t or 0, nextEv.t or 0
                for _, quest in ipairs(f.quests) do if quest.t and quest.t > a and quest.t < b then return true end end
                return false
            end
            if questConflicts and #out > beforeDungeon then temporalAnchors[#temporalAnchors + 1] = {
                first = beforeDungeon + 1, last = #out, t = d.t or 0} end
            -- a clean run (no deaths, no lost fights) with three or more kills is one sentence.
            local kills, clean = {}, true
            for _, ev in ipairs(d.events) do
                if ev.k == "boss" then kills[#kills + 1] = ev.d else clean = false end
                if ev.k == "boss" and history.beaten[ev.d] then clean = false end -- a revenge is its own sentence
                local boss = ev.k == "boss" and L.Boss and L.Boss(ev.d)
                if boss and boss.victory then clean = false end -- surrender/release never joins a kill roll
            end
            local hasLord = false
            for _, b in ipairs(kills) do local lo = L.Boss and L.Boss(b); if lo and lo.last then hasLord = true end end
            local rolled = false
            -- (a hand-in among the kills splits them; none among them leaves the roll whole)
            local splitNeeded = false
            for i = 1, #d.events - 1 do if TurnInBefore(i) then splitNeeded = true end end
            local rollStart = #out
            if not (questConflicts and splitNeeded) and clean and (#kills >= 3 or (#kills == 2 and hasLord)) and PB.killRoll and #PB.killRoll > 0 then
                local lordAt
                for i, b in ipairs(kills) do
                    local lo = L.Boss and L.Boss(b)
                    if lo and lo.last then lordAt = i end
                end
                local function Names(a, b) local t = {} for i = a, b do t[#t + 1] = Place(kills[i]) end return List(t) end
                local roll
                if not lordAt then roll = Names(1, #kills)
                else
                    local lo = L.Boss(kills[lordAt])
                    -- (no epithet when the chapter already named what it says: "the felguard who led the Searing Blade")
                    local epithet = lo.e and not history.bosses[kills[lordAt]] and Fresh(lo.e) and not EpithetInAfter(lo) and lo.e
                    local lord = Place(kills[lordAt]) .. (epithet and (", " .. epithet) or "")
                    if lordAt == #kills then
                        local join = #kills == 2 and ", and then " or (rng() < 0.5 and ", and last of all " or ", and finally ")
                        roll = Names(1, #kills - 1) .. join .. lord
                    elseif lordAt == 1 then roll = lord .. ", and after that " .. Names(2, #kills)
                    else roll = Names(1, lordAt - 1) .. ", then " .. lord .. ", and after that " .. Names(lordAt + 1, #kills) end
                    BossTitle(80, kills[lordAt])
                end
                tokens.roll = roll
                beat = "climax"
                do
                    local lastT
                    for _, ev in ipairs(d.events) do if ev.t and (not lastT or ev.t > lastT) then lastT = ev.t end end
                    if lastT then S.Stamp(lastT, name) end
                end
                Add(teller:Say("killRoll", PB.killRoll, rng, tokens))
                if lordAt then
                    local lo = L.Boss(kills[lordAt])
                    if not history.bosses[kills[lordAt]] then blessOccasion = true end
                    if lo.after and not history.bosses[kills[lordAt]] then Add(After(lo)); flourish = flourish + 1 end
                end
                mood.triumph = true
                d.killed = true
                rolled = true
                -- (the whole roll stands at the last kill's moment for the hand-ins told around it)
                if questConflicts and #out > rollStart then
                    local lastT = 0
                    for _, ev in ipairs(d.events) do lastT = math.max(lastT, ev.t or 0) end
                    temporalAnchors[#temporalAnchors + 1] = {first = rollStart + 1, last = #out, t = lastT}
                end
            end
            local lastKiller
            if not rolled then for evIndex, ev in ipairs(d.events) do
                local eventStart = #out
                if ev.t and ev.t > 0 then S.Stamp(ev.t, name) end
                S.e = ev.k == "death" and ev.e or nil
                if ev.k == "boss" then
                    local lore = L.Boss and L.Boss(ev.d)
                    local kind = lore and lore.kind or "humanoid"
                    -- (a lord, final kill or not, and a kill that cost the companion stay in the roll with
                    -- the others: the run is composed, never one line per boss, 2026-11-11 round 2)
                    local named = d.lostThenWon == ev.d or history.beaten[ev.d]
                    if named then Flush() end
                    tokens.boss, tokens.short = Place(ev.d), Short(ev.d)
                    tokens.shortRaw = ShortRaw(ev.d) ~= Place(ev.d) and ShortRaw(ev.d) or false
                    tokens.bossE = (lore and lore.e and not history.bosses[ev.d] and Fresh(lore.e) and not EpithetInAfter(lore)) and lore.e or false
                    if lore and lore.victory then
                        Flush()
                        Add(teller:Say("bossVictory", lore.victory, rng, tokens))
                        if history.beatenPending then history.beatenPending[ev.d] = nil end
                        mood.triumph = true
                    elseif d.told and d.told[ev.d] then
                        -- Already told (a death avenged in the same breath).
                        mood.triumph = true
                        BossTitle(80, ev.d)
                    elseif d.lostThenWon == ev.d then
                        -- Lost, then won, the same day: the wipe line said it; just the fall (or nothing, when it said that too).
                        Flush()
                        -- (the wipe line said how it ended: "and lost the second")
                        mood.triumph = true
                    elseif history.beaten[ev.d] then
                        Flush()
                        Add(teller:Say("revenge", PB.revenge, rng, tokens))
                        mood.triumph = true
                        BossTitle(80, ev.d)
                        -- what the lord's fall meant, the first time it came
                        if lore and lore.after and not history.bosses[ev.d] then Add(After(lore)); flourish = flourish + 1 end
                    elseif (ev.cost or (d.costPending and d.costPending[ev.d])) and PB.theyDieBossInRoll then
                        -- (the kill that cost the companion: in the roll, with its sentence after it)
                        pending[#pending + 1] = ev.d
                        d.costRoll = d.costRoll or {}
                        d.costRoll[ev.d] = true
                        if lore and lore.last then pendingLord = ev.d end
                    elseif ev.cost and d.costTold and d.costTold[ev.d] then
                        Flush()
                        -- (told with the death it cost)
                    elseif ev.cost then
                        Flush()
                        Add(teller:Say("killCostly", PB.killCostly, rng, tokens))
                        if lore and lore.last then BossTitle(80, ev.d) end
                    elseif ev.d == lastBoss and climax and d.afterDeath and #pending > 0 and PB.killRollAfter and not history.bosses[ev.d] then
                        -- "After that, you killed Lord Pythas, and last of all Mutanus the Devourer."
                        local names = {}
                        for _, boss in ipairs(pending) do names[#names + 1] = Place(boss) end
                        pending = {}
                        local ep = lore and lore.e and Fresh(lore.e) and not EpithetInAfter(lore) and lore.e
                        tokens.roll = List(names) .. ", and last of all " .. Place(ev.d) .. (ep and (", " .. ep) or "")
                        beat = "climax"
                        Add(teller:Say("killRollAfter", PB.killRollAfter, rng, tokens))
                        if climax then mood.triumph = true; blessOccasion = true end
                        if climax and lore and lore.after and not history.bosses[ev.d] then Add(After(lore)); flourish = flourish + 1 end
                        BossTitle(80, ev.d)
                    elseif ev.d == lastBoss and (not climax or #pending > 0) then
                        -- (the lord joins the roll, last of all when it was the last)
                        pending[#pending + 1] = ev.d
                        pendingLord = ev.d
                    elseif ev.d == lastBoss then
                        Flush()
                        if climax then mood.triumph = true end
                        local craft = tokens.theirCraft and tokens.myCraft and rng() < 0.25
                        tokens.bossFell = craft and teller:Say("killCraft", PB.killCraft, rng, tokens)
                            or teller:Say("kill" .. kind, PB.kill[kind], rng, tokens)
                        -- A lord fallen before: no epithet, no ceremony.
                        if history.bosses[ev.d] then
                            if rng() < 0.5 then Add(teller:Say("killAgain", PB.killAgain, rng, tokens)) else Add(tokens.bossFell) end
                        elseif lore and lore.e and not climax then Add(teller:Say("killNamed", PB.killNamed, rng, tokens))
                        elseif lore and lore.e and d.killed then Add(teller:Say("killLast", PB.killLast, rng, tokens))
                        elseif lore and lore.e then Add(teller:Say("killLastOnly", PB.killLastOnly, rng, tokens))
                        else Add(tokens.bossFell) end
                        -- the lore consequence on a first kill, the generic line rarely.
                        if climax and not history.bosses[ev.d] then blessOccasion = true end
                        if climax and lore.after and not history.bosses[ev.d] then
                            Add(After(lore))
                            flourish = flourish + 1
                        elseif climax and rng() < 0.1 then
                            tokens.dungeonD = Place(name)
                            Add(teller:Say("aftermath", PB.aftermath, rng, tokens))
                            flourish = flourish + 1
                        end
                        local asides = teller.persona.asides
                        if climax and asides and (teller.ownCount or 0) == 0 and rng() < (teller.persona.aside or 0) then
                            Add(teller:Say("aside", asides, rng, tokens))
                            teller.ownCount, teller.lastOwn = 1, teller.day
                            flourish = flourish + 1
                        end
                        mood.triumph = true
                        BossTitle(80, ev.d)
                    else
                        pending[#pending + 1] = ev.d
                    end
                    d.killed = true
                elseif ev.k == "death" then
                    local e = ev.e
                    -- (their death in a boss's fight is a clause of that kill: it does not cut the roll)
                    ev.attached = ((e.w ~= "you" and e.boss and killedAt[e.boss] and killedAt[e.boss] >= (ev.t or 0) and PB.theyDieBossInRoll) or ev.gathered) and true or false
                    if not ev.attached then Flush() end
                    lastKiller = e.boss or e.d
                    tokens.place = Place(name)
                    if e.w == "you" and (e.boss or e.d) and wipeWon[e.boss or e.d] and PB.wipeThenWinDied then
                        local foe = e.boss or e.d
                        if not d.wipeDied then
                            d.wipeDied = foe
                            tokens.boss, tokens.short = Place(foe), Short(foe)
                            Add(teller:Say("wipeThenWinDied", PB.wipeThenWinDied, rng, tokens))
                            d.lostThenWon = foe
                        end
                        d.afterDeath = true
                        local savedBeat = beat
                        beat = "rez"
                        do local rt = S.RezAfter(ev.t); if rt then RezLine(rt) end end
                        beat = savedBeat
                    elseif e.w == "you" and ev.wipe and (ev.wipe.them > 0 or ev.wipe.retry) and PB.wipeTry and not (ev.wipe.retry and S.RezAfter(ev.t)) then
                        -- (a raise after the death means no walk back in: that death is told plainly, below)
                        -- The wipe (2026-11-11): one sentence at its moment, the companion's fall with
                        -- it, and the party went back down (or the run ended there).
                        d.afterDeath = true
                        local foe = e.boss or e.d
                        tokens.killer = (foe and not e.boss) and Foe(foe, e.a) or (foe and Place(foe)) or "something in the dark"
                        local key = (ev.wipe.them > 0 and ev.wipe.retry and "wipeTry") or (ev.wipe.retry and "wipeTryAlone") or "wipeEnd"
                        -- (a later death of yours in the run: never "the first try" twice, 2026-11-11 round 2)
                        d.youDeathsTold = (d.youDeathsTold or 0) + 1
                        if d.youDeathsTold >= 2 and ev.wipe.retry and PB.wipeAgain then
                            tokens.nth = Ordinal(d.youDeathsTold)
                            key = (ev.wipe.them > 0 or not PB.wipeAgainAlone) and "wipeAgain" or "wipeAgainAlone"
                        end
                        Add(teller:Say(key, PB[key] or PB.wipeTry, rng, tokens))
                        if ev.wipe.them > 0 then d.theyDied = true end
                        d.wentBack = ev.wipe.retry
                        d.wipeKiller = tokens.killer
                        local savedBeat = beat
                        beat = "rez"
                        do local rt = S.RezAfter(ev.t); if rt then RezLine(rt) end end
                        beat = savedBeat
                    elseif ev.gathered then
                        -- (said with the run's losses, after the kills)
                        d.afterDeath = true
                        d.youDeathsTold = (d.youDeathsTold or 0) + 1
                    elseif e.w == "you" then
                        d.afterDeath = true
                        d.youDeathsTold = (d.youDeathsTold or 0) + 1
                        local foe = e.boss or e.d
                        -- (a common foe inside keeps its article: "a Searing Blade Cultist", by the shared rule)
                        tokens.killer = (foe and not e.boss) and Foe(foe, e.a) or (foe and Place(foe)) or "something in the dark"
                        -- (the short name, or none when it is the whole name: "Gilnid killed you, but it did not
                        -- save Gilnid" and "as Edwin VanCleef had killed many before" are avoided, 2026-11-06)
                        tokens.killerShort = (foe and ShortRaw(foe) ~= Place(foe)) and ShortRaw(foe) or false
                        local avenged = foe and killedAt[foe] and killedAt[foe] > ev.t
                        if e.env and PB.dieEnv[e.env] then
                            -- (no "the water had looked harmless" in a dungeon's black water)
                            local envPool = {}
                            for _, l in ipairs(PB.dieEnv[e.env]) do if not l:find("harmless", 1, true) then envPool[#envPool + 1] = l end end
                            Add(teller:Say("die" .. e.env, #envPool > 0 and envPool or PB.dieEnv[e.env], rng, tokens))
                        elseif foe and S.KilledAgain(foe) >= 2 and PB.dieAgainFoe then
                            tokens.nth, tokens.Killer = Ordinal(S.killedBy[Clean(foe)]), Cap(tokens.killer)
                            Add(teller:Say("dieAgainFoe", PB.dieAgainFoe, rng, tokens))
                        elseif avenged then
                            Add(teller:Say("dieBossAvenged", PB.dieBossAvenged, rng, tokens))
                            d.told = d.told or {}
                            d.told[foe] = true
                        elseif foe and L.Boss and L.Boss(foe) and L.Boss(foe).last then
                            Add(teller:Say("dieHeroic", PB.dieHeroic, rng, tokens))
                        elseif foe then Add(teller:Say("dieBoss", PB.dieBoss, rng, tokens))
                        else Add(teller:Say("theyDie", {"{I} fell in {place}."}, rng, tokens)) end
                        local savedBeat = beat
                        beat = "rez"
                        do local rt = S.RezAfter(ev.t); if rt then RezLine(rt) end end
                        beat = savedBeat
                    elseif ev.wipeOf then
                        -- (their fall in the wipe: said with it)
                        d.afterDeath = true
                        d.theyDied = true
                    else
                        d.afterDeath = true
                        -- (their death on the way to a boss, nothing of yours beside it: told with that boss,
                        -- never a bare "Grosh died." 2026-11-11 round 2)
                        local nextBoss
                        for _, x in ipairs(d.events) do
                            if x.k == "boss" and (x.t or 0) >= (ev.t or 0) and (x.t or 0) - (ev.t or 0) <= 15 * 60 and not nextBoss then nextBoss = x end
                        end
                        local nextLore = nextBoss and L.Boss and L.Boss(nextBoss.d)
                        if nextBoss and not e.boss and PB.theyDieBefore and not (d.told and d.told[nextBoss.d]) and not history.beaten[nextBoss.d]
                            and not (nextLore and (nextLore.last or nextLore.victory)) and not nextBoss.cost then
                            tokens.boss = Place(nextBoss.d)
                            Add(teller:Say("theyDieBefore", PB.theyDieBefore, rng, tokens))
                            d.told = d.told or {}
                            d.told[nextBoss.d] = true
                            e.boss = e.boss -- (kept as recorded)
                        elseif e.boss and killedAt[e.boss] and killedAt[e.boss] >= (ev.t or 0) and PB.theyDieBossInRoll then
                            -- (told with the kill, after the roll that holds it)
                            d.costPending = d.costPending or {}
                            d.costPending[e.boss] = true
                            d.costTold = d.costTold or {}
                            d.costTold[e.boss] = true
                        elseif e.boss and killedAt[e.boss] and killedAt[e.boss] > ev.t and PB.theyDieBossCostly then
                            tokens.boss, tokens.short = Place(e.boss), Short(e.boss)
                            Add(teller:Say("theyDieBossCostly", PB.theyDieBossCostly, rng, tokens))
                            d.costTold = d.costTold or {}
                            d.costTold[e.boss] = true
                        elseif e.boss then tokens.boss = Place(e.boss); Add(teller:Say("theyDieBoss", PB.theyDieBoss, rng, tokens))
                        else Add(teller:Say("theyDie", PB.theyDie, rng, tokens)) end
                        d.theyDied = true
                        RezGivenLine()
                    end
                    mood.grim = true
                    TitleFrom(65, "death")
                elseif ev.k == "wipe" then
                    Flush()
                    tokens.boss, tokens.short = Place(ev.d), Short(ev.d)
                    if lastKiller == ev.d then tokens.boss = tokens.short end
                    local won = killedAt[ev.d] and killedAt[ev.d] > ev.t
                    if won and d.wipeDied == ev.d then
                        d.lostThenWon = ev.d -- (told with your death)
                    elseif won and diedTo[ev.d] and PB.wipeThenWinDied then
                        d.wipeDied = ev.d
                        Add(teller:Say("wipeThenWinDied", PB.wipeThenWinDied, rng, tokens))
                        d.lostThenWon = ev.d
                    elseif won then
                        Add(teller:Say("wipeThenWin", PB.wipeThenWin, rng, tokens))
                        d.lostThenWon = ev.d
                    elseif lastKiller ~= ev.d then
                        Add(teller:Say("wipe", PB.wipe, rng, tokens))
                    end
                    if not won then
                        history.beatenPending = history.beatenPending or {}
                        history.beatenPending[ev.d] = true
                        mood.grim = true
                    end
                end
                if questConflicts and (ev.k ~= "boss" or TurnInBefore(evIndex)) and not ev.attached then
                    Flush(true)
                    if #out > eventStart then temporalAnchors[#temporalAnchors + 1] = {
                        first = eventStart + 1, last = #out, t = ev.t or 0} end
                end
            end
            end -- (not told as one sentence)
            S.e = nil
            Flush()
            if d.gatherYou then
                -- (one table: T.Tell is near Lua 5.1's 200-local limit)
                local G = {foes = {}, seen = {}, raisers = {}, rseen = {}, raised = 0, names = {}}
                for _, ev in ipairs(d.gatherYou) do
                    local kind = Clean(ev.e.d)
                    if not G.seen[kind] then G.seen[kind] = 0; G.foes[#G.foes + 1] = ev.e end
                    G.seen[kind] = G.seen[kind] + 1
                    G.rt = S.RezAfter(ev.t)
                    if G.rt then
                        S.rezTold[G.rt] = true
                        G.by = G.rt ~= true and f.rezBy and f.rezBy[G.rt]
                        G.who = G.by and ("{n:" .. (G.by:match("^(%S+)") or G.by) .. "}") or teller.base.name
                        G.raised = G.raised + 1
                        if not G.rseen[G.who] then G.rseen[G.who] = true; G.raisers[#G.raisers + 1] = G.who end
                    end
                end
                for i, e in ipairs(G.foes) do
                    if i <= 2 then
                        G.one = Foe(e.d, e.a)
                        if G.seen[Clean(e.d)] == 1 then G.names[#G.names + 1] = G.one
                        else
                            G.text = G.one:gsub("^an? ", "")
                            G.inner = G.text:match("{p:(.-)}$") or G.text
                            G.plural = (G.inner:match("man$") and G.inner:gsub("man$", "men")) or ((G.inner:match("[sxz]$") or G.inner:match("[cs]h$")) and (G.inner .. "es")) or (G.inner .. "s")
                            if G.text:match("{p:.-}$") then G.text = G.text:gsub("{p:.-}$", "{p:" .. G.plural .. "}") else G.text = G.plural end
                            G.names[#G.names + 1] = G.text
                        end
                    end
                end
                if #G.foes > 2 then G.names[#G.names + 1] = "others" end
                tokens.killers = List(G.names)
                tokens.Killers = Cap(tokens.killers)
                G.Times = function(n) return n == 1 and "once" or n == 2 and "twice" or (Words(n) .. " times") end
                tokens.count = G.Times(#d.gatherYou)
                tokens.raisers, tokens.Raisers = List(G.raisers), Cap(List(G.raisers))
                tokens.rcount = G.Times(G.raised)
                Add(teller:Say("runLosses", (G.raised == 0 and PB.runLosses.walked) or (G.raised >= #d.gatherYou and PB.runLosses.raised) or PB.runLosses.some, rng, tokens))
                mood.grim = true
                TitleFrom(65, "death")
            end
            -- The run that stopped short of the lord: the lord beat you, a veteran fell short, or the
            -- run simply ended; then what still holds the deeper halls (Lore's `unfinished`).
            if unfinished and lordHere and PB.dungeonUnfinished then
                beat = "climax"
                tokens.short = Short(lordHere)
                tokens.lastKill = lastKill and Place(lastKill) or tokens.lord
                -- (the lord's own pronoun, never the companion's "{they}": that one leaked into later
                -- lines, "Bryn came along, as he did", 2026-11-06 review)
                -- (from the data, round 7 2026-11-11; none the data vouches for bans the line that needs one)
                tokens.lordThey = (A.JournalEpisodes and A.JournalEpisodes.BossPronoun and A.JournalEpisodes.BossPronoun(lordHere)) or false
                if lordBeat and PB.dungeonFellShort then
                    Add(teller:Say("dungeonFellShort", PB.dungeonFellShort, rng, tokens))
                    TitleFrom(72, "fellShort")
                elseif lordDoneBefore and PB.dungeonShortVeteran then
                    Add(teller:Say("dungeonShortVeteran", PB.dungeonShortVeteran, rng, tokens))
                    TitleFrom(70, "unfinished")
                else
                    Add(teller:Say(left and "dungeonUnfinishedLeft" or "dungeonUnfinishedEnded", left and PB.dungeonUnfinished.left or PB.dungeonUnfinished.ended, rng, tokens))
                    TitleFrom(70, "unfinished")
                end
                mood.triumph = false
                if story and story.unfinished then
                    history.unfinishedLoreN = (history.unfinishedLoreN or 0) + 1
                    if history.unfinishedLoreN % 2 == 1 then
                        local bossesHere = {}
                        for _, ev in ipairs(d.events) do if ev.k == "boss" then bossesHere[#bossesHere + 1] = ev.d end end
                        local lines = (L.WithoutBosses and L.WithoutBosses(story.unfinished, bossesHere)) or story.unfinished
                        local was = beat
                        beat = "again"
                        Add(lines[rng(#lines)])
                        beat = was
                    end
                end
            elseif d.atLast and reached and PB.lordAtLast then
                beat = "climax"
                tokens.short = Short(lordHere)
                Add(teller:Say("lordAtLast", PB.lordAtLast, rng, tokens))
            end
            local afterConflicts = #out
            -- What it was like inside (a first visit), how you split the work, and
            -- now and then a deed worth saying.
            -- (what the lord's fall meant stays last even when hand-ins anchor the kills:
            -- your part and any deed go in front of it, and the anchor keeps covering it)
            local aftersNow = {}
            for _, ev in ipairs(d.events) do
                local lo = ev.k == "boss" and L.Boss and L.Boss(ev.d)
                if lo and lo.after then aftersNow[lo.after] = true; for _, more in ipairs(lo.afterMore or {}) do aftersNow[more] = true end end
            end
            local function AddBeforeConsequence(line)
                if not line then return end
                local last = out[#out]
                local before = #out
                Add(line)
                -- (only when the line was written: Highlights drop a role line, and the swap would then
                -- put the lord's consequence before the kill)
                if #out > before and questConflicts and last and aftersNow[last] and #out >= 2 then
                    out[#out], out[#out - 1] = out[#out - 1], out[#out]
                    outBeat[#out], outBeat[#out - 1] = outBeat[#out - 1], outBeat[#out]
                    for _, anchor in ipairs(temporalAnchors) do if anchor.last == #out - 1 then anchor.last = #out end end
                end
            end
            if #d.events > 0 and PB.rolesPair then
                local firstBoss
                for _, ev in ipairs(d.events) do if ev.k == "boss" and not firstBoss then firstBoss = ev end end
                local mine = L.Role and L.Role(d.r, firstBoss and firstBoss.me)
                local theirs = L.Role and L.Role(d.tr, firstBoss and firstBoss.them)
                local pair = mine and theirs and PB.rolesPair[mine .. "+" .. theirs]
                local byClass = mine and theirs and PB.rolesPairClass and PB.rolesPairClass[mine .. "+" .. theirs]
                byClass = byClass and byClass[player.class or ""]
                if byClass and rng() < 0.5 then pair = byClass end
                -- (2026-11-11, round 2: the role as a role, never as an act the record does not hold)
                -- (round 3: a role pairing reads as an act; the chapter says who the companion was elsewhere)
                if PB.rolesPlain then pair = nil end
                -- (they died in there: not "you kept them alive")
                if pair and d.theyDied then
                    local kept = {}
                    for _, line in ipairs(pair) do
                        if not (line:find("alive", 1, true) or line:find("standing", 1, true) or line:find("on {their} feet", 1, true)
                            or line:find("on their feet", 1, true) or line:find("kept {them}", 1, true)) then kept[#kept + 1] = line end
                    end
                    pair = #kept > 0 and kept or nil
                end
                if pair then
                    -- (a line the book has said already is left out; all said, none: the reader knows your parts)
                    history.roleLines = history.roleLines or {}
                    local kept = {}
                    for _, line in ipairs(pair) do if not history.roleLines[line] then kept[#kept + 1] = line end end
                    pair = #kept > 0 and kept or nil
                end
                local roleSaid = false
                if pair and rng() < 0.6 then
                    local was = beat
                    beat = "roles" -- (its own beat: a role line never takes the day's level)
                    local line = teller:Say("roles", pair, rng, tokens)
                    local before = #out
                    AddBeforeConsequence(line)
                    roleSaid = #out > before
                    if line and teller.sayLine then history.roleLines[teller.sayLine] = true end
                    beat = was
                end
                -- (one line about your parts a chapter: the pairing or the deed, not both; and the deed
                -- never takes the day's level either, "Archaedas never got past you, and you climbed to
                -- level 39" read like a ledger: 2026-11-06 review)
                if not roleSaid and not PB.rolesPlain and (not history.boastDay or history.boastDay ~= index) then
                    local was = beat
                    beat = "roles"
                    local lastKill
                    for _, ev in ipairs(d.events) do if ev.k == "boss" then lastKill = ev end end
                    for _, ev in ipairs(d.events) do
                        local lord = L.Boss and L.Boss(ev.d) and L.Boss(ev.d).last
                        if ev.k == "boss" and ev == lastKill and (ev.n or 0) >= 3 and rng() < (lord and 0.6 or 0.25) and history.boastDay ~= index then
                            tokens.boss, tokens.weapon = Short(ev.d), L.Weapon and L.Weapon(player.class) or "strikes"
                            tokens.theirWeapon = L.Weapon and L.Weapon(person.class) or "strikes"
                            local you, them = ev.me or {}, ev.them or {}
                            local line
                            -- (the diary never praises its writer: the companion's part only)
                            if you.d == 1 and (you.ds or 0) >= 30 and mine ~= "healer" and voice ~= "we" then line = teller:Say("boastYouD", PB.boastYou.damage, rng, tokens)
                            elseif them.d == 1 and (them.ds or 0) >= 30 and theirs ~= "healer" then line = teller:Say("boastThemD", PB.boastThem.damage, rng, tokens)
                            elseif mine == "tank" and you.t == 1 and voice ~= "we" then line = teller:Say("boastYouT", PB.boastYou.tank, rng, tokens)
                            elseif theirs == "tank" and them.t == 1 then line = teller:Say("boastThemT", PB.boastThem.tank, rng, tokens) end
                            if line then AddBeforeConsequence(line); history.boastDay = index end
                        end
                    end
                    beat = was
                end
            end
            -- (what the lord's fall meant comes last, after your part and any deed)
            if #d.events > 0 and not questConflicts then
                local afters = {}
                for _, ev in ipairs(d.events) do
                    local lo = ev.k == "boss" and L.Boss and L.Boss(ev.d)
                    if lo and lo.after then afters[lo.after] = true; for _, more in ipairs(lo.afterMore or {}) do afters[more] = true end end
                end
                for n2 = #out, math.max(1, #out - 6), -1 do
                    if afters[out[n2]] then
                        local text = table.remove(out, n2)
                        table.remove(outBeat, n2)
                        out[#out + 1], outBeat[#out + 1] = text, "consequence"
                        break
                    end
                end
            end
            -- (round 4: no summary line after the beats; the run's facts were told once)
            if #d.events > 0 then Title(75, ((history.dungeons[name] or 0) > 0 and "Back to " or "Into ") .. Place(name), "dungeon:" .. name) end
            if questConflicts and #out > afterConflicts then temporalAnchors[#temporalAnchors + 1] = {
                first = afterConflicts + 1, last = #out, t = d.events[#d.events].t or 0}
            elseif not questConflicts and #out > beforeDungeon then temporalAnchors[#temporalAnchors + 1] = {
                first = beforeDungeon + 1, last = #out, t = d.t or 0} end
            S.Stamp(nil, nil)
            S.r, S.goalLord = nil, nil
        end
        -- Deaths outside dungeons (2026-11-11): told where and when they fell, in time order. A
        -- moment is the deaths of one place within a quarter of an hour of each other; theirs
        -- before yours make one sentence with yours, theirs in the minute after yours go with
        -- it, and a raise of yours is said after the death it answered. Never a count against
        -- the day.
        beat = "death"
        local deathAnchors = {}
        do
        local envSeen = {}
        local pvpSeen, pvpTold = false, 0
        local pvpAll = 0
        for _, e in ipairs(f.deaths) do if e.w == "you" and (e.pr or e.pc) and not e.env then pvpAll = pvpAll + 1 end end
        local function PlainFoe(e)
            return e and e.w == "you" and e.d and not e.env and not e.pr and not e.pc
                and not (e.d:find("Guard") or e.d:find("Grunt") or e.d:find("Bluffwatcher") or e.d:find("Sentinel")) and true or false
        end
        local function Count(n) return n == 2 and "twice" or (Words(n) .. " times") end
        -- (one moment: the same place within a quarter of an hour, or their deaths running on with
        -- nothing told between them)
        local moments = {}
        for _, e in ipairs(f.deaths) do
            local m = moments[#moments]
            local runsOn = m and e.w ~= "you" and m[#m].w ~= "you"
            -- (a death within three minutes of the last joins its moment across a zone border, lane C8)
            local cross = m and m.z ~= (e.z or mainZone) and (e.t or 0) - m.last <= 3 * 60 and e.w == "you" and m[#m].w ~= "you"
            if m and ((m.z == (e.z or mainZone) and ((e.t or 0) - m.last <= 15 * 60 or runsOn)) or cross) then
                m[#m + 1] = e; m.last = e.t or 0
                if cross then m.z = e.z or mainZone end
            else moments[#moments + 1] = {e, z = e.z or mainZone, last = e.t or 0} end
        end
        local function RaiseAfter(e)
            local rt = e.w == "you" and S.RezAfter(e.t)
            if rt then local was = beat; beat = "rez"; RezLine(rt); beat = was end
        end
        -- (a line with the place, where the chapter has not named it yet: never "died there" first)
        local function WithPlace(pool, z)
            local key = z and Clean(z):gsub("^[Tt]he ", ""):match("^(%S+)")
            if not key or (teller.saidPlaces and teller.saidPlaces[key]) then return pool end
            local kept = {}
            for _, line in ipairs(pool or {}) do if line:find("{place}", 1, true) then kept[#kept + 1] = line end end
            return #kept > 0 and kept or pool
        end
        -- (strictly between: a raise in the same second as a death answers it, it never comes first)
        local function RaisedBetween(a, b)
            for _, t in ipairs(f.rezGivenT or {}) do if t > a and t < b then return true end end
            return false
        end
        local function Anchor(e, beforeDeath)
            if #out > beforeDeath then deathAnchors[#deathAnchors + 1] = {first = beforeDeath + 1, last = #out, t = e.t or 0} end
        end
        -- (round 3: the tail word of the line before, "as well", "too", "with", not twice running)
        local lastTail
        local function Tail(text) return text and (text:find(" as well", 1, true) and "as well" or text:find(" too%p") and "too" or text:find(" with {", 1, true) and "with") or nil end
        local function NoTail(pool)
            if not lastTail or not pool then return pool end
            local kept = {}
            for _, line in ipairs(pool) do if Tail(line .. ".") ~= lastTail then kept[#kept + 1] = line end end
            return #kept > 0 and kept or pool
        end
        local function SayD(key, pool)
            local line = teller:Say(key, NoTail(pool), rng, tokens)
            lastTail = Tail(line)
            return line
        end
        -- Several deaths of yours as one sentence (reader G, 2026-11-11): from the item at i, the
        -- deaths of yours left in the moment when one killer (or one kind of killer) took them all
        -- ("Foe Reaper 4000 killed you three times more, and Faelyn brought you back each time"), or
        -- the ones between the first and the last when there are three or more of yours ("Twice more
        -- you died, once to Grimungus, and Pip fell twice"). Their falls inside it by count; a known
        -- hand's raises as a clause, a stranger's as a sentence after. A raise you gave inside it
        -- keeps the finer telling.
        local function RaiserInParty(by, rt)
            local first = by:match("^(%S+)") or by
            if first:lower() == tostring(FirstName(person) or ""):lower() then return true end
            for _, x2 in ipairs(ownJournal or {}) do
                if x2.k == "with" and x2.n and (Clean(x2.n):gsub("%-.*$", "")):lower() == first:lower() and (x2.t or 0) <= rt and (x2.e or x2.t or 0) >= rt then return true end
            end
            return false
        end
        local function GroupAt(m, i)
            if not PB.dieGroup or not A.FoeFamily then return nil end
            local yours, before = {}, false
            for j = 1, i - 1 do if m[j].w == "you" then before = true end end
            for j = i, #m do if m[j].w == "you" then yours[#yours + 1] = j end end
            if #yours < 2 then return nil end
            local names, flags = {}, {}
            for k, j in ipairs(yours) do
                if not PlainFoe(m[j]) then return nil end
                names[k], flags[k] = Clean(m[j].d), m[j].a
            end
            local fam, to = A.FoeFamily(names, flags), nil
            if fam then to = #m
            elseif before and #yours >= 3 then to = yours[#yours] - 1
            else return nil end
            -- (a stranger's raise is a sentence at its time: the group ends on the death it answered;
            -- a stranger's raise on the first death leaves it to its own line)
            for k, j in ipairs(yours) do
                if j > to then break end
                local rt = S.RezAfter(m[j].t)
                local by = rt and rt ~= true and f.rezBy and f.rezBy[rt]
                if by and not RaiserInParty(by, rt) and j < to then
                    if k == 1 then return nil end
                    to = j
                    break
                end
            end
            -- (the killers the deaths of the group share, if any)
            local kept, keptFlags = {}, {}
            for k, j in ipairs(yours) do if j <= to then kept[#kept + 1] = names[k]; keptFlags[#keptFlags + 1] = flags[k] end end
            if #kept < 2 then return nil end
            fam = A.FoeFamily(kept, keptFlags)
            if not fam and not before then return nil end
            local t0, t1 = m[i].t or 0, m[to].t or 0
            for _, t in ipairs(f.rezGivenT or {}) do if t >= t0 and t <= t1 then return nil end end
            return {from = i, to = to, fam = fam, before = before}
        end
        local function Times(n) return n == 1 and "once" or Count(n) end
        for _, m in ipairs(moments) do
        local momentStart = #out
        local grouped = false
        local i = 1
        while i <= #m do
            local e = m[i]
            local beforeDeath = #out
            S.Stamp(e.t, e.z or mainZone) -- (stamped: the death; its raise goes with it)
            S.e = e
            tokens.place = Place(e.z or mainZone or "the wilds")
            local G = GroupAt(m, i)
            if G then
                local mine, theirs = {}, 0
                for j = G.from, G.to do if m[j].w == "you" then mine[#mine + 1] = m[j] else theirs = theirs + 1 end end
                S.e = mine[1]
                tokens.more = G.before and " more" or ""
                tokens.count = Times(#mine)
                local meWord = (teller.base and teller.base.me) or "you"
                if not G.before and #mine >= 3 then
                    local minutes = math.max(1, math.floor(((m[G.to].t or 0) - (m[G.from].t or 0)) / 60 + 0.5))
                    tokens.count = tokens.count .. " in " .. ((minutes <= 5 and "a few minutes") or (minutes <= 12 and "ten minutes") or (minutes <= 20 and "a quarter of an hour") or (minutes <= 40 and "half an hour") or "an hour")
                end
                tokens.fam = G.fam and (G.fam:match("^the (.*)$") and ("the {p:" .. G.fam:match("^the (.*)$") .. "}") or ("{p:" .. G.fam .. "}")) or nil
                tokens.Fam = tokens.fam and Cap(tokens.fam) or nil
                tokens.Count = Cap(tokens.count)
                tokens.with = theirs > 0 and (", and {n:" .. FirstName(person) .. "} fell " .. Times(theirs)) or ""
                -- the raises that answered these deaths: by hand
                local hands, handOrder, strangers = {}, {}, {}
                for _, x in ipairs(mine) do
                    S.KilledAgain(x.d)
                    local rt = S.RezAfter(x.t)
                    if rt then
                        S.rezTold[rt] = true
                        local by = rt ~= true and f.rezBy and f.rezBy[rt]
                        local first, inParty = FirstName(person), true
                        if by then
                            first = by:match("^(%S+)") or by
                            inParty = first:lower() == tostring(FirstName(person) or ""):lower()
                            for _, x2 in ipairs(ownJournal or {}) do
                                if x2.k == "with" and x2.n and (Clean(x2.n):gsub("%-.*$", "")):lower() == first:lower() and (x2.t or 0) <= rt and (x2.e or x2.t or 0) >= rt then inParty = true end
                            end
                            S.rezHands = S.rezHands or {}
                            local hand = S.rezHands[first:lower()]
                            if not hand then
                                hand = {total = 0, said = 0}
                                for _, b2 in pairs(f.rezBy) do if (tostring(b2):match("^(%S+)") or tostring(b2)):lower() == first:lower() then hand.total = hand.total + 1 end end
                                S.rezHands[first:lower()] = hand
                            end
                            hand.said = hand.said + 1
                        else rezSaid = true end
                        if inParty then
                            local key = "{n:" .. first .. "}"
                            if not hands[key] then hands[key] = 0; handOrder[#handOrder + 1] = key end
                            hands[key] = hands[key] + 1
                        else strangers[#strangers + 1] = "{n:" .. by .. "}" end
                    end
                end
                tokens.raised = ""
                if #handOrder == 1 then
                    local by, n = handOrder[1], hands[handOrder[1]]
                    -- (the one who fell is the one who raised me: "Pip fell twice and raised me once")
                    local same = tokens.with ~= "" and by == "{n:" .. FirstName(person) .. "}"
                    if n == #mine then tokens.raised = (same and " and brought " or (", and " .. by .. " brought ")) .. meWord .. " back each time"
                    else tokens.raised = (same and " and raised " or (", and " .. by .. " raised ")) .. meWord .. " " .. Times(n) end
                elseif #handOrder >= 2 then
                    local n = 0
                    for _, by in ipairs(handOrder) do n = n + hands[by] end
                    tokens.raised = ", and " .. List(handOrder) .. " raised " .. meWord .. " " .. Times(n) .. " between them"
                end
                if tokens.with ~= "" and tokens.raised:find("^, and ") then tokens.raised = tokens.raised:gsub("^, and ", ", while ") end
                local pool
                if G.fam then pool = (not G.before and PB.dieGroupAll) or PB.dieGroup
                else
                    -- (one killer with a name among kinds: named here, unless the last death names it)
                    local named, namedCount, namedRaw = nil, 0, nil
                    for _, x in ipairs(mine) do if not (Foe(x.d, x.a):find("^an? ")) then namedCount = namedCount + 1; named = Foe(x.d, x.a); namedRaw = Clean(x.d) end end
                    local last = m[#m]
                    if last.w == "you" and last.d and Clean(last.d) == namedRaw then namedCount = 0 end
                    if namedCount == 1 and PB.dieGroupNamed then tokens.named = named; pool = PB.dieGroupNamed else pool = PB.dieGroupMixed end
                end
                Add(teller:Say("dieGroup", pool, rng, tokens))
                TitleFrom(65, "death")
                mood.grim = true
                for _, by in ipairs(strangers) do
                    tokens.raiser = by
                    Add(teller:Say("rezStranger", PB.rezStranger or PB.rezOther, rng, tokens))
                end
                Anchor(mine[#mine], beforeDeath)
                grouped = true
                i = G.to + 1
            elseif e.w ~= "you" then
                -- theirs, up to your next death of the moment (or a raise you gave between two of theirs)
                local n, j = 0, i
                while j <= #m and m[j].w ~= "you" do
                    if n > 0 and RaisedBetween(m[j - 1].t or 0, m[j].t or 0) then break end
                    n = n + 1; j = j + 1
                end
                local yours = m[j] and m[j].w == "you" and m[j] or nil
                -- (they fell, you raised them, they fell again: "again", not a second "died in {place}")
                local again = i > 1 and m[i - 1].w ~= "you" and RaisedBetween(m[i - 1].t or 0, e.t or 0)
                if yours and PlainFoe(yours) and (yours.t or 0) - (m[j - 1].t or 0) <= 10 * 60 and PB.momentBothOnce and PB.momentBothTimes then
                    -- theirs, then yours: one sentence (at the place you fell, its sub-zone across a border)
                    S.e = yours
                    if yours.z and yours.z ~= (e.z or mainZone) then tokens.place = Place(yours.sz or yours.z) end
                    S.KilledAgain(yours.d)
                    tokens.killer = Foe(yours.d, yours.a)
                    tokens.count = Count(n)
                    local key = (again and n == 1 and PB.momentBothAgain and "momentBothAgain") or (n == 1 and "momentBothOnce") or "momentBothTimes"
                    Add(SayD(key, PB[key]))
                    TitleFrom(65, "death")
                    mood.grim = true
                    RezGivenLine()
                    RaiseAfter(yours)
                    -- (theirs again within three minutes of yours: "fell again", never a bare line of its own; lane C8)
                    local k2, after = j + 1, 0
                    while m[k2] and m[k2].w ~= "you" and (m[k2].t or 0) - (yours.t or 0) <= 3 * 60 and (m[k2].z or mainZone) == (yours.z or mainZone)
                        and not RaisedBetween(yours.t or 0, m[k2].t or 0) do after = after + 1; k2 = k2 + 1 end
                    if after > 0 then
                        tokens.count = Count(after)
                        if after == 1 and (PB.theyFellAgain or PB.theyDieAgain) then Add(teller:Say("theyFellAgain", PB.theyFellAgain or PB.theyDieAgain, rng, tokens))
                        elseif PB.theyDieMoment then Add(teller:Say("theyDieMoment", PB.theyDieMoment, rng, tokens)) end
                        j = k2 - 1
                    end
                    Anchor(yours, beforeDeath)
                    i = j + 1
                else
                    tokens.count = Count(n)
                    if again and n == 1 and PB.theyDieAgain then Add(teller:Say("theyDieAgain", PB.theyDieAgain, rng, tokens))
                    elseif n == 1 or not PB.theyDieMoment then Add(teller:Say("theyDie", WithPlace(PB.theyDie, e.z or mainZone), rng, tokens))
                    else Add(teller:Say("theyDieMoment", WithPlace(PB.theyDieMoment, e.z or mainZone), rng, tokens)) end
                    mood.grim = true
                    RezGivenLine()
                    Anchor(e, beforeDeath)
                    i = j
                end
            elseif (function()
                local yours = {}
                for j, x in ipairs(m) do if x.w == "you" then yours[#yours + 1] = j end end
                return #yours >= 3 and i ~= yours[1] and i ~= yours[#yours] and not S.RezAfter(e.t)
            end)() then
                -- (round 4: a bad moment of three deaths of yours or more is a passage, the first and the
                -- last and the count, never a roll of every one; the middle ones are the count's)
                S.KilledAgain(e.d)
                RaiseAfter(e)
                local k = i + 1
                while m[k] and m[k].w ~= "you" and (m[k].t or 0) - (e.t or 0) <= 90 do k = k + 1 end
                i = k
            else
                -- yours; theirs within the minute and a half after go with it
                local k, withThem = i + 1, 0
                while m[k] and m[k].w ~= "you" and (m[k].t or 0) - (e.t or 0) <= 90 do withThem = withThem + 1; k = k + 1 end
                if withThem > 0 and PlainFoe(e) and PB.dieWithThem then
                    S.KilledAgain(e.d)
                    tokens.killer = Foe(e.d, e.a)
                    Add(SayD("dieWithThem", PB.dieWithThem))
                    if e.d and not tokens.killer:find("^an? ") and titleRng() < 0.6 and not Recent("from:death", 65) then Title(65, Short(e.d), "from:death")
                    else TitleFrom(65, "death") end
                    mood.grim = true
                    RezGivenLine()
                    RaiseAfter(e)
                    Anchor(e, beforeDeath)
                    i = k
                else
                if e.env and PB.dieEnv[e.env] then
                    -- the same end twice in a day
                    local again = PB.dieEnvAgain and PB.dieEnvAgain[e.env] and envSeen[e.env]
                    envSeen[e.env] = true
                    Add(teller:Say(again and ("dieAgain" .. e.env) or ("die" .. e.env), again and PB.dieEnvAgain[e.env] or PB.dieEnv[e.env], rng, tokens))
                    TitleFrom(70, e.env == "DROWNING" and "water" or "fall")
                elseif e.pr or e.pc then
                    -- one of the other side
                    local pvpRace, pvpClass = e.pr and Clean(e.pr):lower(), e.pc and Clean(e.pc):lower() or "fighter"
                    local lead = pvpRace or pvpClass
                    tokens.killer = ((lead:match("^[aeiou]") and "an " or "a ") .. (pvpRace and (pvpRace .. " ") or "") .. pvpClass)
                    local again = pvpSeen
                    pvpSeen = true
                    pvpTold = pvpTold + 1
                    -- (three or more: the first, then the count)
                    if again and pvpAll >= 3 and PB.diePvpMany then
                        if pvpTold == 2 then
                            tokens.count = Words(pvpAll)
                            Add(teller:Say("diePvpMany", PB.diePvpMany, rng, tokens))
                        end
                    else
                        -- (a race says the side: "a human warrior", not "a human warrior of the other side")
                        local line = teller:Say(again and "diePvpAgain" or "diePvp", again and PB.diePvpAgain or PB.diePvp, rng, tokens)
                        if line and pvpRace then line = line:gsub(" of the other side", "") end
                        Add(line)
                    end
                    TitleFrom(65, "death")
                    mood.grim = true
                elseif not e.d then
                    Add(teller:Say("diePlain", PB.diePlain, rng, tokens))
                    mood.grim = true
                elseif e.d:find("Guard") or e.d:find("Grunt") or e.d:find("Bluffwatcher") or e.d:find("Sentinel") then
                    for _, x in ipairs(ownJournal or {}) do
                        if x.k == "town" and x.d and (x.t or 0) <= (e.t or 0) and (e.t or 0) - (x.t or 0) < 7200 then tokens.place = Place(x.d) end
                    end
                    Add(teller:Say("dieGuard", PB.dieGuard, rng, tokens))
                else
                    tokens.killer = Foe(e.d, e.a)
                    local zl = L.ZoneLevels and L.ZoneLevels(e.z)
                    local lowly = level and zl and level >= zl[2] + 8
                    local shameful = lowly or (L.Humble and L.Humble(e.d))
                    local pool = shameful and PB.dieShameful or PB.dieFoe
                    -- (the same killer again that day: "a second time", never twice the same first telling)
                    local again = S.KilledAgain(e.d)
                    if again >= 2 and PB.dieAgainFoe then tokens.nth, tokens.Killer = Ordinal(again), Cap(tokens.killer); pool, shameful = PB.dieAgainFoe, false end
                    if shameful and not lowly then
                        -- (a farmhand at your own level: the joke, not the level)
                        local kept = {}
                        for _, line in ipairs(pool) do if not line:find("level", 1, true) then kept[#kept + 1] = line end end
                        pool = kept
                    end
                    Add(teller:Say(shameful and "dieShameful" or "dieFoe", pool, rng, tokens))
                    -- a foe everyone has a story about
                    local infamous = e.d and PB.infamous and PB.infamous[e.d]
                    if infamous then
                        local savedBeat = beat
                        beat = "deathLore"
                        Add(teller:Say("infamous" .. e.d, infamous, rng, tokens))
                        beat = savedBeat
                    end
                    -- A named killer titles the chapter ("Hogger"), as a bounty would.
                    if e.d and not tokens.killer:find("^an? ") and titleRng() < 0.6 and not Recent("from:death", 65) then Title(65, Short(e.d), "from:death")
                    else TitleFrom(65, "death") end
                    mood.grim = not shameful
                end
                -- (the raise belongs to the death it answered, inside its anchor, so a hand-in told at
                -- its own time cannot come between them: 2026-11-06 review)
                RaiseAfter(e)
                -- (theirs in the three minutes after yours, in the same place: "fell there too", never a
                -- bare line that names the place again; lane C8)
                local k2, after = i + 1, 0
                while m[k2] and m[k2].w ~= "you" and (m[k2].t or 0) - (e.t or 0) <= 3 * 60 and (m[k2].z or mainZone) == (e.z or mainZone)
                    and not RaisedBetween(e.t or 0, m[k2].t or 0) do after = after + 1; k2 = k2 + 1 end
                if after > 0 and PB.theyDieToo and PB.theyDieMoment then
                    tokens.count = Count(after)
                    if after == 1 then Add(SayD("theyDieToo", PB.theyDieToo)) else Add(SayD("theyDieMoment", PB.theyDieMoment)) end
                    i = k2 - 1
                end
                Anchor(e, beforeDeath)
                i = i + 1
                end
            end
        end
        -- (a bad moment, four deaths or more: the count once, folded on its last line; a group
        -- sentence carries its own count)
        if #m >= 4 and #out > momentStart and PB.deathsCountClause and not grouped then
            local last = out[#out]
            local theirs = 0
            for _, x in ipairs(m) do if x.w ~= "you" then theirs = theirs + 1 end end
            local minutes = math.max(1, math.floor(((m[#m].t or 0) - (m[1].t or 0)) / 60 + 0.5))
            tokens.count, tokens.span = Words(#m), (minutes <= 5 and "a few minutes") or (minutes <= 12 and "ten minutes") or (minutes <= 20 and "a quarter of an hour") or "half an hour"
            local clause = teller:Say("deathsCountClause", PB.deathsCountClause, rng, tokens)
            if clause and last:sub(-1) == "." and not last:find(", and ", 1, true) then
                out[#out] = S.Carry(last, last:sub(1, -2) .. ", " .. clause:gsub("^%u", string.lower):gsub("%.$", "") .. ".")
            end
        end
        end
        end
        if #f.rezT == 0 and f.rez > 0 and not rezSaid then RezLine(true) end
        for _, rt in ipairs(f.rezT) do if not S.rezTold[rt] and (not f.rezBy or not f.rezBy[rt] or true) then local was = beat; beat = "rez"; RezLine(rt); beat = was end end
        -- (their death went unrecorded, the raise did not: said with the day's deaths)
        if (f.rezGiven or 0) > 0 and not rezGivenSaid then RezGivenLine() end
        -- what killed you, killed in turn for a quest of its name ("Mor'Ladim", 'WANTED: "Hogger"')
        if PB.questRevenge then
            local avenged
            for _, e in ipairs(f.deaths) do
                if e.w == "you" and e.d and not avenged then
                    for _, quest in ipairs(f.quests) do
                        if Clean(quest.title):find(Clean(e.d), 1, true) and (quest.t or 0) > (e.t or 0) then
                            -- (a hand-in with an authored outcome says the kill itself: no second line for it)
                            local story = L.QuestStory and L.QuestStory(quest.title, quest.qid)
                            if not (story and story.after and not history.questLore[quest.qid or quest.title]) then avenged = e.d end
                        end
                    end
                end
            end
            if avenged then
                local was = beat
                beat = "climax"
                tokens.foe = Place(avenged)
                -- (stamped: the hand-in that avenged it)
                for _, quest in ipairs(f.quests) do
                    if Clean(quest.title):find(Clean(avenged), 1, true) then S.Stamp(quest.t, quest.z or (quest.scene and quest.scene.zone)) end
                end
                Add(teller:Say("questRevenge", PB.questRevenge, rng, tokens))
                S.Stamp(nil, nil)
                beat = was
                history.avengedQuest = avenged
                mood.triumph = true
            end
        end
        S.Stamp(nil, nil)
        S.e = nil

        if not levelDone then LevelBeat() end

        -- 5. The work: quests, the hardest one named, the mundane only now and then.
        beat = "questKey"
        -- (stamped: a quest's own time and zone; a line of several quests, the first of them)
        function S.Quest(quest) if quest then S.Stamp(quest.t, quest.z or (quest.scene and quest.scene.zone), quest) end end
        S.firstQuest = nil
        for _, quest in ipairs(f.quests) do if not S.firstQuest or (quest.t or 0) < (S.firstQuest.t or 0) then S.firstQuest = quest end end
        if #f.quests > 0 then
            S.Quest(S.firstQuest)
            -- Capital stays use a different opening from field outings. Their
            -- recorded errands still need a scene instead of disappearing
            -- behind the city description and the overnight rest.
            if not tokens.questFolded and #f.dungeons == 0 and #f.deaths == 0 and #f.wipes == 0 then
                local plan = L.QuestBeats(f.quests, history.questLore, #f.quests,
                    function(q) return not q.scene or q.scene.zone ~= mainZone end)
                if plan[1] then
                    local first = plan[1]
                    f.storyBeats = plan
                    if first.story.why and not history.questSetups[first.quest.qid or first.quest.title] then
                        f.questSetupLines = f.questSetupLines or {}
                        f.questSetupLines[first.quest.qid or first.quest.title] = first.story.why[rng(#first.story.why)]
                        history.questSetups[first.quest.qid or first.quest.title] = true
                    end
                    tokens.quest = Q(first.quest.title)
                    local completion = teller:Say("questDepth", PB.questDepth, rng, tokens)
                    S.Quest(first.quest)
                    Add(completion)
                    S.Quest(S.firstQuest)
                    do
                        f.questCompletionCuts = f.questCompletionCuts or {}
                        f.questCompletionCuts[#f.questCompletionCuts + 1] = {quest = first.quest, fragment = completion}
                    end
                    tokens.questFolded, history.workSaid = true, index
                end
            end
            local hardest, hardestDiff, elite
            local easy = 0
            for _, quest in ipairs(f.quests) do
                local lore = L.Quest and L.Quest(quest.title)
                local ql = quest.level or (lore and lore.level)
                local kind = quest.kind or (lore and lore.kind)
                local pl = quest.pl or level
                if ql and pl then
                    local diff = ql - pl
                    if not hardestDiff or diff > hardestDiff then hardest, hardestDiff = quest, diff end
                    if diff <= -8 then easy = easy + 1 end
                end
                if kind == 1 or kind == 81 or kind == 62 then elite = elite or quest end
            end
            local notable = false
            if tokens.questFolded or multiQuestPlan or deedsToday then notable = true
            elseif hardest and hardestDiff >= 4 and not history.hardSaid then
                -- (once a book: the reader knows this character takes on work above their level)
                tokens.quest = Q(hardest.title)
                S.Quest(hardest)
                Add(teller:Say("questHard", PB.questHard, rng, tokens)); notable = true
                history.hardSaid = index
            elseif elite and #f.dungeons == 0 and (index - (history.eliteSaid or -99)) >= 4 then
                tokens.quest = Q(elite.title)
                S.Quest(elite)
                Add(teller:Say("questElite", PB.questElite, rng, tokens)); notable = true
                history.eliteSaid = index
            elseif easy >= #f.quests and #f.quests > 1 and rng() < 0.6 then
                Add(teller:Say("questEasy", PB.questEasy, rng, tokens)); notable = true
            end
            tokens.count, tokens.Count = Words(#f.quests), Cap(Words(#f.quests))
            beat = "quests"
            S.Quest(S.firstQuest)
            local quiet = #out <= 2
            if history.workSaid == index or history.preludeSaid == index then notable = true end
            if history.preludeSaid == index then
                local lastD = f.dungeons[#f.dungeons] -- only quests after the last dungeon
                local after = 0
                for _, quest in ipairs(f.quests) do if quest.t > (lastD and lastD.t or 0) then after = after + 1 end end
                if after >= 3 and not deedsToday and PB.questsMore and rng() < 0.6 then
                    for _, quest in ipairs(f.quests) do if quest.t > (lastD and lastD.t or 0) then S.Quest(quest); break end end
                    tokens.count, tokens.Count = Words(after), Cap(Words(after))
                    Add(teller:Say("questsMore", PB.questsMore, rng, tokens))
                elseif after == 1 and PB.questAfterOne and rng() < 0.7 then
                    local last
                    for _, quest in ipairs(f.quests) do if quest.t > (lastD and lastD.t or 0) then last = quest end end
                    local host
                    for _, scene in ipairs(day.scenes) do
                        if scene.kind == "outing" and last and last.t >= scene.t - 60 and last.t <= scene.e + 60 then host = scene.zone end
                    end
                    tokens.quest, tokens.zoneTo = Q(last.title), host and Place(host) or Place(mainZone or "")
                    S.Quest(last)
                    Add(teller:Say("questAfterOne", PB.questAfterOne, rng, tokens))
                end
            elseif not deedsToday and #f.quests >= 6 and history.workSaid ~= index and (quiet or rng() < 0.6) then
                Add(teller:Say("questsMany", PB.questsMany, rng, tokens))
            elseif not deedsToday and #f.quests == 1 and not notable and (quiet or rng() < 0.4) then
                tokens.quest = Q(f.quests[1].title)
                Add(teller:Say("questOne", PB.questOne, rng, tokens))
            elseif not deedsToday and #f.quests >= 2 and not notable and (quiet and rng() < 0.7 or rng() < 0.3) then
                Add(teller:Say("questsFew", PB.questsFew, rng, tokens))
            end
        end
        S.Stamp(nil, nil)
        local questLoreToday = false
        -- The quests worth telling in this book (DESIGN §3.0, 2026-11-07): the pair's day, not
        -- a second copy of the own book. The same worth chooses one or two (one in Highlights),
        -- told in the stage's point of view, the variant the own book did not take, in "we" or
        -- "you"; the stage's own setup and outcome prose is never told here. With more work
        -- done side by side, one light line of short acts says what else the two of you did.
        if #f.quests > 0 and A.QuestDeeds then
            local QD = A.QuestDeeds
            local events = {}
            for _, x in ipairs(f.deaths or {}) do events[#events + 1] = x end
            local plan = QD.Plan({{quests = f.quests, events = events, zone = mainZone, with = {true}, t = f.quests[1].t}},
                {threadCount = {}, threadLast = {}, told = function(key) return history.questLore[key] == true end,
                 zonesSeen = history.questZonesSeen or {}, limit = brief and 1 or 2, floor = 7, brief = true})
            history.questZonesSeen = history.questZonesSeen or {}
            local b = teller.base
            local function Tok(solo)
                return {We = Cap(b.we), we = b.we, us = b.us, our = b.our, Our = Cap(b.our), I = b.I, me = b.me, my = b.my, My = Cap(b.my)}
            end
            local rest, told = {}, {}
            -- (the folded work is cut into runs by the moments told between them: one grouped line
            -- never joins work done before a told moment with work done after it, which read as if
            -- the hides were taken to the wind rider after the flight they were flown on)
            local runs, run = {}, {}
            local was = beat
            beat = "questKey"
            for _, e in ipairs(plan.entries) do
                -- (Highlights keeps a day whose work is a real moment, told here or named by the day's
                -- line: a stage told from our side, an exact or weighty stage, a chain's beginning or
                -- where it got to)
                if e.mention and history.questLore[QD.Key(e.quest)] == nil then
                    local s = e.story
                    local exact = e.quest.qid and A.Lore.questStoryIDs and A.Lore.questStoryIDs[tonumber(e.quest.qid)] ~= nil
                    if s and (s.pov or exact or (s.importance or 1) >= 4 or (s.thread and (threadLast[s.thread] == QD.Key(e.quest)
                        or not history.questThreads[s.thread]))) then questLoreToday = true end
                    history.questLore[QD.Key(e.quest)] = "named"
                end
                if e.mention and ((e.story and (e.story.pov or (e.act and e.act.act)))
                    or (#told == 0 and not table.concat(out, " "):find("{q:" .. tostring(e.quest.title):gsub("[{}]", "") .. "}", 1, true))) then
                    local moment = QD.Moment(e, Tok(e.act and e.act.solo), QD.Variant(QD.Key(e.quest), nil, teller.deedOther), true, nil,
                        history.questLore[QD.Key(e.quest)] == true)
                    if history.questLore[QD.Key(e.quest)] ~= true then moment = S.RunQuest(e, moment, Tok(e.act and e.act.solo), QD.Variant(QD.Key(e.quest), nil, teller.deedOther)) end
                    -- (round 7, 2026-11-11: a sentence that claims a boss's death the record never had, today or
                    -- on an earlier day, is left out; nothing left means the plain hand-in)
                    if moment and A.JournalEpisodes and A.JournalEpisodes.WithoutUnkilledClaims then
                        local function Killed(name)
                            if history.bosses[name] then return true end
                            for _, d in ipairs(f.dungeons) do
                                for _, ev in ipairs(d.events) do if ev.k == "boss" and ev.d and Clean(ev.d) == name then return true end end
                            end
                            return false
                        end
                        local kept, dropped = A.JournalEpisodes.WithoutUnkilledClaims(moment, Killed)
                        if dropped > 0 then
                            moment = kept or ((Tok(e.act and e.act.solo).We or "We") .. " saw {q:" .. tostring(e.quest.title):gsub("[{}]", "") .. "} through.")
                        end
                    end
                    -- (round 4: "He hoped to learn ..." with no one named before it: the giver's name)
                    do
                        local pro = moment and (moment:match("^(He) ") or moment:match("^(She) "))
                        local giver = pro and e.story and ((e.story.pov and e.story.pov.giver) or (QD.Giver and QD.Giver(e.story)))
                        if type(giver) == "string" and giver ~= "" then moment = giver .. moment:sub(#pro + 1) end
                    end
                    if moment then told[#told + 1] = {t = e.quest.t or 0, text = moment,
                        zone = e.quest.scene and e.quest.scene.zone, z = e.quest.z, quest = e.quest} end

                    history.questLore[QD.Key(e.quest)] = true
                elseif e.act and e.act.act and not brief then
                    rest[#rest + 1] = e
                end
            end
            if #rest >= 2 then
                -- (plan.entries is in worth order; the runs follow the record)
                local moments = {}
                for _, item in ipairs(told) do moments[#moments + 1] = item.t end
                table.sort(rest, function(x, y) return (x.quest.t or 0) < (y.quest.t or 0) end)
                for _, e in ipairs(rest) do
                    local prev = run[#run]
                    local split = false
                    for _, mt in ipairs(moments) do
                        if prev and mt > (prev.quest.t or 0) and mt < (e.quest.t or 0) then split = true end
                    end
                    if split then runs[#runs + 1] = run; run = {} end
                    run[#run + 1] = e
                end
                runs[#runs + 1] = run
                -- (still one light line: the run with the most work, the earlier on a tie)
                local pick = runs[1]
                for _, r in ipairs(runs) do if #r > #pick then pick = r end end
                local earlier = false
                for _, item in ipairs(told) do if item.t < (pick[1].quest.t or 0) then earlier = true end end
                -- (a lead, "After that", only after a moment told before it; never "also" first)
                local lines = QD.Folds({pick[1], pick[2], pick[3]}, Tok(false), earlier and 2 or 0, {}, QD.Band(pick[1].quest.pl))
                if lines[1] then told[#told + 1] = {t = lines[1].last.t or 0, text = lines[1].text,
                    stampT = pick[1].quest.t, z = pick[1].quest.z or (pick[1].quest.scene and pick[1].quest.scene.zone),
                    quests = {pick[1].quest, pick[2] and pick[2].quest, pick[3] and pick[3].quest}} end
            end
            table.sort(told, function(x, y) return x.t < y.t end)
            for _, item in ipairs(told) do
                local before = #out
                -- (work done somewhere the chapter has not named says where: "In the Barrens, ...")
                local said = A.JournalPlain(table.concat(out, " "))
                local w0 = item.text:match("^(%a+)")
                local NOLEAD = {That = true, This = true, It = true, There = true, Then = true, Nobody = true, Nothing = true}
                if item.zone and not said:find((Clean(item.zone):gsub("^The ", "")), 1, true) and not T.PlaceLed(item.text) and not (w0 and NOLEAD[w0]) then
                    item.text = (A.JournalPlaceLead and A.JournalPlaceLead(Place(item.zone), item.text, said))
                        or ("In " .. Place(item.zone) .. ", " .. item.text:gsub("^%u", string.lower))
                end
                S.Stamp(item.stampT or item.t, item.z or item.zone, item.quest)
                Add(Cap(item.text))
                if item.quests and #out > before then S.Qs[out[#out]] = item.quests end
                S.Stamp(nil, nil)
                -- (told on its own side of a death: work done before it goes before it)
                if #out == before + 1 then
                    local at = before
                    for _, list in ipairs({deathAnchors or {}, temporalAnchors or {}}) do
                        for _, death in ipairs(list) do
                            if item.t < (death.t or 0) then at = math.min(at, death.first - 1) end
                        end
                    end
                    if at < before then
                        local text, kind = table.remove(out), table.remove(outBeat)
                        table.insert(out, at + 1, text)
                        table.insert(outBeat, at + 1, kind)
                        for _, list in ipairs({deathAnchors, temporalAnchors or {}}) do
                            for _, death in ipairs(list) do
                                if death.first > at then death.first = death.first + 1 end
                                if death.last > at then death.last = death.last + 1 end
                            end
                        end
                    end
                end
            end
            beat = was
            if mainZone then history.questZonesSeen[mainZone] = true end
        end


        if not restDone and not restFolded then RestBeat() end

        -- A quest named today that has a story (Lore): what came of it, once a companionship.
        questLoreToday = questLoreToday or false
        if #f.quests > 0 and L.QuestStory then
            local said = table.concat(out, " ")
            local plan = multiQuestPlan or f.storyBeats or L.QuestBeats(f.quests, history.questLore, 1,
                function(q) return not said:find("{q:" .. q.title .. "}", 1, true) end)
            local anchors = deathAnchors
            if multiQuestPlan then
                anchors = temporalAnchors
                for _, death in ipairs(deathAnchors) do anchors[#anchors + 1] = death end
                table.sort(anchors, function(a, b) return a.t < b.t end)
            end
            -- Highlights keeps the turning points of the day's work: every exact
            -- stage (the Codex line: an exact record keeps its reviewed scene, compact
            -- where one is authored), a title-only stage that matters (importance four
            -- and up), the first stage of a chain this book meets, and where a chain
            -- got to. Lesser title-only errands stay in Everything; the day they
            -- filled is bridged. (The draws are made for a dropped scene too, and it
            -- counts as told: both editions read the same stream and plan the same
            -- later days.)
            local keep = {}
            if brief then
                local begun = {}
                for _, chosen in ipairs(plan) do
                    local quest, qs = chosen.quest, chosen.story
                    local importance = qs.importance or 1
                    local beginning = qs.thread and not history.questThreads[qs.thread] and not begun[qs.thread]
                    if qs.thread then begun[qs.thread] = true end
                    local exact = quest.qid and A.Lore.questStoryIDs and A.Lore.questStoryIDs[tonumber(quest.qid)] ~= nil
                    -- (where a chain got to: its last recorded stage in this book is kept, resolved or not)
                    local resolution = qs.thread and threadLast[qs.thread] == (quest.qid or quest.title)
                    if exact or importance >= 4 or beginning or resolution then keep[chosen] = true end
                end
            end
            local anchor, previousTitle, previousScene, previousStory
            for _, chosen in ipairs(plan) do
                local quest, qs = chosen.quest, chosen.story
                if not history.questLore[quest.qid or quest.title]
                    and (multiQuestPlan or anchor or said:find("{q:" .. quest.title .. "}", 1, true)) then
                    -- (the sentence that names it; the line goes right after it, not after a death)
                    local at = anchor
                    for n2 = 1, #out do if not at and out[n2]:find("{q:" .. quest.title .. "}", 1, true) then at = n2 end end
                    local needsName = not anchor and not at
                    if multiQuestPlan and not at then at = #out end
                    -- A death can interrupt a rite. Put the recorded stages on
                    -- their own side of that event instead of dropping the
                    -- whole chain because its opening sentence borders a death.
                    if at then
                        for _, death in ipairs(anchors) do
                            if (quest.t or 0) < death.t then at = math.min(at, death.first - 1); break
                            else at = math.max(at, death.last) end
                        end
                        while outBeat[at + 1] == "rez" or outBeat[at + 1] == "deathLore" do at = at + 1 end
                    end
                    if at then
                        local passage = {}
                        local setup = f.questSetupLines and f.questSetupLines[quest.qid or quest.title]
                        if setup then passage[#passage + 1] = setup; S.SL[setup] = true end
                        if anchor or needsName then
                            -- (Highlights: a title-only stage continuing the thread just told keeps its outcome only)
                            local continuing = brief and not quest.qid and qs.thread and previousStory and qs.thread == previousStory.thread
                            if not setup and qs.why and #qs.why > 0 then
                                local why = qs.why[rng(#qs.why)]
                                if not continuing then passage[#passage + 1] = why; S.SL[why] = true end
                            end
                            local changedPlace = multiQuestPlan and quest.scene and
                                ((previousScene and quest.scene.zone ~= previousScene.zone)
                                    or (not previousScene and quest.scene.zone ~= mainZone))
                            if needsName or quest.title ~= previousTitle or changedPlace then
                                tokens.quest = Q(quest.title)
                                local completion = teller:Say("questDepth", PB.questDepth, rng, tokens)
                                if changedPlace and quest.scene.zone and not T.PlaceLed(completion) then
                                    completion = (A.JournalPlaceLead and A.JournalPlaceLead(Place(quest.scene.zone), completion))
                                        or ("In " .. Place(quest.scene.zone) .. ", " .. completion:gsub("^%u", string.lower))
                                end
                                if changedPlace and quest.scene.zone then
                                    -- Keep the recorded place on the outcome when
                                    -- a separate completion sentence is redundant.
                                    passage.outcomePlace = quest.scene.zone
                                end
                            end
                        end
                        local outcome = QuestEnding(quest, qs, brief, rng)
                        if CompactQuest(quest, qs, brief) then
                            -- The compact passage includes its own setup. Keep
                            -- the recorded location and chronological insertion.
                            local place = passage.outcomePlace
                            passage = {outcomePlace = place}
                        end
                        if passage.outcomePlace then
                            -- (the hand-in's recorded place, on the outcome itself: "In Orgrimmar, Taragaman's heart
                            -- was taken", not a bare "You were in Orgrimmar." between the setup and what came of it;
                            -- a name keeps its capital after the comma, an article does not)
                            local articled = outcome:match("^The ") or outcome:match("^An? ") or outcome:match("^Another ") or outcome:match("^No ")
                                or outcome:match("^One ") or outcome:match("^Fewer ") or outcome:match("^More ") or outcome:match("^Word ")
                            -- (an outcome that opens on its own place, "At Aerie Peak, ...", takes no "In the Hinterlands," in front)
                            local placed = T.PlaceLed(outcome)
                            -- (the arrival goes in front of the whole scene, never between the setup and what came of
                            -- it: "A camping teacher knew someone... You had come to Tirisfal by then. A First Aid Kit
                            -- could now be made" read as an interruption, 2026-11-06 review)
                            -- (three shapes in turn, by a counter: "You had come to Tirisfal Glades by then. ... You
                            -- had come to Orgrimmar by then." twice in one chapter, 2026-11-06)
                            -- (the prefix lowers a common first word and keeps a name's capital; an outcome that
                            -- opens on speech, "Finally, said Lydon", takes the arrival in front instead)
                            local prefixed = not (articled or placed) and A.JournalPlaceLead
                                and A.JournalPlaceLead(Place(passage.outcomePlace), outcome, table.concat(passage, " ") .. " " .. table.concat(out, " "))
                            if articled or placed or not prefixed then
                                teller.arrivedN = (teller.arrivedN or 0) + 1
                                local shape = teller.arrivedN % 3
                                local arrived = shape == 1 and (Cap(teller.base.we) .. " had come to " .. Place(passage.outcomePlace) .. " by then.")
                                    or shape == 2 and ("The day went on in " .. Place(passage.outcomePlace) .. ".")
                                    or (Cap(teller.base.we) .. " were in " .. Place(passage.outcomePlace) .. " after that.")
                                table.insert(passage, 1, arrived)
                            else outcome = prefixed end
                        end
                        passage[#passage + 1] = outcome
                        if brief and not keep[chosen] then
                            -- (dropped from Highlights: the day line keeps "finished X"; the next scene goes where this one would have)
                            anchor, previousTitle, previousScene, previousStory = at, quest.title, quest.scene, qs
                            passage = {}
                            history.questLore[quest.qid or quest.title] = "dropped"
                        else
                            history.questLore[quest.qid or quest.title] = true
                        end
                        for pi, line in ipairs(passage) do
                            at = at + 1
                            table.insert(out, at, line)
                            table.insert(outBeat, at, CompactQuest(quest, qs, brief) and CompactBeat(qs, previousStory) or pi == #passage and "questOutcome" or pi == 1 and "questStart" or "questKey")
                            -- (stamped: the quest the passage tells)
                            if outT[line] == nil then outT[line] = quest.t end
                            if S.Q[line] == nil then S.Q[line] = quest end
                            if S.Z[line] == nil then S.Z[line] = quest.z or (quest.scene and quest.scene.zone) end
                            for _, death in ipairs(anchors) do
                                if death.first >= at then death.first = death.first + 1 end
                                if death.last >= at then death.last = death.last + 1 end
                            end
                        end
                        anchor, previousTitle, previousScene, previousStory = at, quest.title, quest.scene, qs
                        if #passage > 0 then questLoreToday = true end
                    end
                end
            end
        end

        do
            -- An authored consequence now carries these completions. Remove only
            -- their exact title announcements, retaining the rest of each sentence.
            -- Uncatalogued work keeps its original wording in either edition.
            for _, cut in ipairs(f.questCompletionCuts or {}) do
                local told = history.questLore[cut.quest.qid or cut.quest.title]
                -- (a scene Highlights dropped: its separate "We completed X." goes, the work folded
                -- into the day's sentence stays)
                if (told == true or told == "dropped") and cut.fragment then
                    for n2 = #out, 1, -1 do
                        local at = out[n2]:find(cut.fragment, 1, true)
                        if at and told == "dropped" and (cut.predicate ~= nil or out[n2] ~= cut.fragment) then at = nil end
                        if at then
                            if out[n2] == cut.fragment then
                                table.remove(out, n2); table.remove(outBeat, n2)
                            else
                                local before, after = out[n2]:sub(1, at - 1), out[n2]:sub(at + #cut.fragment)
                                if cut.replacement == "" and cut.predicate then
                                    -- The work was folded after travel with "and";
                                    -- the final rest may still follow this predicate.
                                    before = before:gsub(", and $", ""):gsub(" and $", ""):gsub(", $", "")
                                end
                                out[n2] = S.Carry(out[n2], before .. (cut.replacement or "") .. after)
                                -- A quest title's ! or ? may have supplied the only
                                -- terminator. Its replacement must finish the sentence.
                                if cut.predicate and not out[n2]:find("[.!?]$") then out[n2] = S.Carry(out[n2], out[n2] .. ".") end
                                -- (what is left is only "You were in the Barrens.": a place the chapter has
                                -- named already, standing between a scene's setup and its outcome, goes too)
                                local bare = out[n2]:gsub("{%a:([^}]*)}", "%1")
                                local placeOnly = bare:match("^%u[%w' ]* were in ([%w' ]+)%.$") or bare:match("^%u[%w' ]* was in ([%w' ]+)%.$")
                                    or (bare:match("^%u[%w' ]* were there%.$") and "there")
                                if placeOnly and not bare:find(",", 1, true) then
                                    local before2 = table.concat(out, " ", 1, n2 - 1):gsub("{%a:([^}]*)}", "%1")
                                    local placeName = placeOnly ~= "there" and placeOnly:gsub("^the ", "") or nil
                                    if placeOnly == "there" or (placeName and before2:find(placeName, 1, true)) then
                                        table.remove(out, n2); table.remove(outBeat, n2)
                                    end
                                end
                            end
                            break
                        end
                    end
                end
            end
        end

        -- The hour, when it tells something: past midnight, or before dawn.
        beat = "hour"
        -- (stamped: the end of the last outing)
        S.Stamp(lastOuting and lastOuting.e, lastOuting and lastOuting.zone)
        if together and lastOuting and lastOuting.e and (index - (history.hourSaid or -99)) >= 5 then
            local endHour = Hour(lastOuting.e)
            local crossed = date and date("%d", lastOuting.e) ~= date("%d", (firstOuting or lastOuting).t)
            if crossed and endHour < 5 and PB.lateNight and rng() < 0.4 and not tokens.clock then
                history.hourSaid = index
                Add(teller:Say("lateNight", PB.lateNight, rng, tokens))
            elseif startHour >= 4 and startHour < 7 and PB.earlyStart and tokens.part ~= false and rng() < 0.5 then
                history.hourSaid = index
                Add(teller:Say("earlyStart", PB.earlyStart, rng, tokens))
            end
        end
        S.Stamp(nil, nil)

        -- Moments from your own journal while you were together: a sunset, a
        -- crossing by sea, a landmark, a near thing (two at most).
        beat = "shared"
        local sharedCount = 0
        if together and ownJournal and PB.shared then
            local closeSaid = #f.deaths > 0
            -- what was gathered while together, all of it in one line
            local gathered = {}
            for _, e in ipairs(moments) do if e.k == "gather" and e.d then gathered[e.d] = (gathered[e.d] or 0) + (tonumber(e.c) or 1) end end
            local total = 0
            for _, n in pairs(gathered) do total = total + n end
            local gatherSaid = total < (quietDay and 1 or 5)
            for _, e in ipairs(sceneMoments) do
                if sharedCount >= sceneLimit then break end
                if toldEarly[e] then sharedCount = sharedCount + 1 end
                lineT = e.t
                -- (the moment's zone: sz where it is kept apart; e.z names the place only for these kinds)
                S.z = e.sz or (e.k == "first" and (e.d == "notable" or e.d == "zone" or e.d == "sunset" or e.d == "snow") and e.z)
                    or (e.k ~= "first" and e.k ~= "voyage" and e.k ~= "cave" and e.k ~= "bg" and e.z) or momentRegions[e]
                S.moment = true; S.me = e
                local line
                if toldEarly[e] then line = nil
                elseif e.k == "first" and e.d == "notable" and e.n and PB.sharedNotableSeen then
                    tokens.notable, tokens.place = "{n:" .. Clean(e.n) .. "}", Place(e.z or momentRegions[e] or mainZone or "the wilds")
                    line = teller:Say(e.interaction and "sharedNotableSpoke" or "sharedNotableSeen", e.interaction and PB.sharedNotableSpoke or PB.sharedNotableSeen, rng, tokens)
                    local lore = A.SelfWords and A.SelfWords.notableNPCs and A.SelfWords.notableNPCs[e.n]
                    history.notableSaid = history.notableSaid or {}
                    if lore and not history.notableSaid[e.n] then
                        Add(line); line = nil
                        Add(lore[rng(#lore)])
                        sharedCount = sharedCount + 1
                        history.notableSaid[e.n] = true
                    end
                    Title(62, "{n:" .. Clean(e.n) .. "}", "notable")
                elseif e.k == "first" and e.d == "sunset" and e.z then
                    tokens.what = Place(e.z)
                    local sunsets = PB.shared.sunset
                    if EAST_COASTS[e.z] then
                        -- (the sea is behind you there at sunset)
                        local kept = {}
                        for _, l in ipairs(sunsets) do if not l:find("into the sea", 1, true) and not l:find("over the sea", 1, true) and not l:find("over the water", 1, true) then kept[#kept + 1] = l end end
                        if #kept > 0 then sunsets = kept end
                    end
                    line = teller:Say("sharedSunset", sunsets, rng, tokens)
                    if line then Title(62, "The Sun Goes Down", "shared") end
                elseif e.k == "gather" and not gatherSaid and PB.shared.gather and A.JournalGatherClauses
                    and not (e.d == "fishing" and e.sz and PB.shared.fish and next(gathered, next(gathered)) == nil) then
                    gatherSaid = true
                    local clauses = A.JournalGatherClauses(gathered)
                    if #clauses > 0 then
                        tokens.work = #clauses == 1 and clauses[1] or (table.concat(clauses, ", ", 1, #clauses - 1) .. " and " .. clauses[#clauses])
                        line = teller:Say(quietDay and "sharedGatherQuiet" or "sharedGather", quietDay and PB.sharedGatherQuiet or PB.shared.gather, rng, tokens)
                    end
                elseif e.k == "voyage" and PB.shared.voyage[e.d or ""] then
                    tokens.to = e.to and Place(e.to) or "the other shore"
                    line = teller:Say("sharedVoyage" .. e.d, PB.shared.voyage[e.d], rng, tokens)
                    -- (a crossing comes early in the day's telling)
                    if line then
                        local outBefore = #out
                        Add(line)
                        if #out > outBefore then
                            -- (before the day's arrival: you crossed, then you were there)
                            local at
                            for i = 1, #out - 1 do
                                local ob = outBeat[i]
                                if not at and (ob == "land" or ob == "landKey" or ob == "travel" or ob == "day" or ob == "rest") then at = i end
                            end
                            if at then
                                local text, bt = table.remove(out), table.remove(outBeat)
                                table.insert(out, at, text); table.insert(outBeat, at, bt)
                            end
                        end
                        sharedCount = sharedCount + 1
                        line = nil
                    end
                elseif e.k == "first" and e.d == "landmark" and e.z then
                    tokens.what = Place(e.z)
                    line = teller:Say("sharedLandmark", PB.shared.landmark, rng, tokens)
                elseif e.k == "first" and e.d == "rezother" and not e.u and PB.sharedRezOther and e.n
                    and Clean(e.n):lower() == (Clean(person.name or ""):gsub("%-.*$", "")):lower() then
                    local byClass = PB.sharedRezOtherBy and PB.sharedRezOtherBy[player.class or ""]
                    -- (the Light: the priests of humans, dwarves and gnomes only)
                    if player.class == "PRIEST" and not ({Human = true, Dwarf = true, Gnome = true})[player.race or ""] then byClass = nil end
                    local pool = byClass or PB.sharedRezOther
                    -- (your own book begun late cannot know it was the first)
                    if mySelf and (mySelf.startLevel or 1) >= 11 and PB.sharedRezOtherLate then pool = PB.sharedRezOtherLate end
                    line = teller:Say("sharedRezOther", pool, rng, tokens)
                elseif e.k == "first" and e.d == "foeseen" and not e.u and PB.sharedFoeSeen then
                    local race = e.n and Clean(e.n):lower()
                    tokens.aFoe = race and (((race:match("^[aeiou]") and "an " or "a ") .. race) .. (e.c and (" " .. Clean(e.c):lower()) or "")) or "one of them"
                    tokens.side = (player.faction == "Horde" and "Alliance") or "Horde"
                    line = teller:Say("sharedFoeSeen", PB.sharedFoeSeen, rng, tokens)
                elseif e.k == "first" and e.d == "snow" and e.z and PB.shared.snow and not e.u then
                    tokens.zoneD = Place(e.z)
                    line = teller:Say("sharedSnow", PB.shared.snow, rng, tokens)
                elseif e.k == "first" and e.d == "rarebeast" and e.z and PB.shared.rareBeast then
                    tokens.what, tokens.zoneD = Place(e.z), Place(e.sz or mainZone or "")
                    line = teller:Say("sharedRare", PB.shared.rareBeast, rng, tokens)
                elseif e.k == "swim" and e.d and PB.shared.swim then
                    tokens.place = Place(e.d)
                    line = teller:Say("sharedSwim", PB.shared.swim, rng, tokens)
                elseif e.k == "nightflight" and PB.shared.nightFlight then
                    -- (where it went: the next zone of your own journal after it)
                    local to
                    local nextT
                    for _, x in ipairs(ownJournal) do
                        if x.k == "play" and x.z and (x.t or 0) > e.t and (not nextT or x.t < nextT) then to, nextT = x.z, x.t end
                    end
                    if to then tokens.to = Place(to); line = teller:Say("sharedNight", PB.shared.nightFlight, rng, tokens) end
                elseif e.k == "gather" and e.d == "fishing" and e.sz and PB.shared.fish and A.JournalGatherClauses then
                    tokens.place = Place(e.sz)
                    local clauses = A.JournalGatherClauses({fishing = tonumber(e.c) or 1})
                    tokens.work = clauses[1]
                    gatherSaid = true
                    if tokens.work then line = teller:Say("sharedFish", PB.shared.fish, rng, tokens) end
                elseif e.k == "duel" and e.d and PB.shared.duel then
                    if Clean(e.d) == companionShort and PB.shared.duelWith then
                        -- ("you and Mira duelled, and Mira won" / "Mira and I duelled, and I won")
                        tokens.winner = e.w == "won" and teller.base.I or teller.base.name
                        line = teller:Say("sharedDuelWith", PB.shared.duelWith, rng, tokens)
                    else
                        tokens.who, tokens.outcome = "{n:" .. Clean(e.d) .. "}", e.w == "won" and "won" or "lost"
                        line = teller:Say("sharedDuel", PB.shared.duel, rng, tokens)
                    end
                    if line then Title(54, "A Duel", "shared") end
                elseif e.k == "rarekill" and e.d and PB.shared.rareKilled then
                    tokens.what = Place(e.d)
                    line = teller:Say("sharedRareKilled", PB.shared.rareKilled, rng, tokens)
                    if line then Title(50, Clean(e.d), "shared") end
                elseif e.k == "rep" and e.d and PB.sharedRep and A.JournalStandingWord and PB.sharedRep[A.JournalStandingWord(e.s) or ""] then
                    local word = A.JournalStandingWord(e.s)
                    tokens.faction = (A.SelfTale and A.SelfTale.FactionName and A.SelfTale.FactionName(e.d)) or Place(e.d)
                    tokens.Faction = Cap(tokens.faction)
                    line = teller:Say("sharedRep" .. word, PB.sharedRep[word], rng, tokens)
                elseif e.k == "explore" and e.d and PB.shared.explore then
                    -- (planned: the country the chapter opens in is not news here, and a cave
                    -- that gets its own line is not listed too)
                    local names = {skip = {}}
                    if S.planned then
                        if mainZone then names.skip[mainZone] = true end
                        for _, x in ipairs(moments) do if x.k == "cave" and x.d then names.skip[x.d] = true end end
                    end
                    for _, x in ipairs(moments) do if x.k == "explore" and x.d and #names < 3 and not names.skip[x.d] then names[#names + 1] = Place(x.d) end end
                    if #names > 0 then
                        tokens.places = List(names)
                        line = teller:Say("sharedExplore", PB.shared.explore, rng, tokens)
                    end
                elseif e.k == "read" and e.d and PB.shared.read then
                    tokens.what = Q(e.d)
                    line = teller:Say("sharedRead", PB.shared.read, rng, tokens)
                elseif e.k == "first" and e.d == "zone" and e.z and not e.u and PB.shared.zoneFirst then
                    -- (your own first time ever in this country fell on a day with them)
                    tokens.zoneD = Place(e.z)
                    tokens.zoneDWas = Plural(tokens.zoneD) and "were" or "was"
                    line = teller:Say("sharedZoneFirst", PB.shared.zoneFirst, rng, tokens)
                    S.zoneFirstD = tokens.zoneD
                elseif e.k == "first" and e.d == "continent" and e.z and not e.u and PB.shared.continent then
                    local how
                    for _, x in ipairs(moments) do if x.k == "voyage" and x.d and math.abs((x.t or 0) - (e.t or 0)) <= 120 then how = x.d end end
                    tokens.to = Place(e.z)
                    local pool = (how and PB.shared.continentBy and PB.shared.continentBy[how]) or PB.shared.continent
                    line = teller:Say("sharedContinent" .. (how or ""), pool, rng, tokens)
                    if line then Title(60, Place(e.z), "shared") end
                elseif e.k == "cave" and e.d and PB.shared.cave then
                    tokens.what = Place(e.d)
                    line = teller:Say("sharedCave", PB.shared.cave, rng, tokens)
                elseif e.k == "bg" and e.d and PB.shared.bg then
                    -- (all the matches of this battleground that day, in one line, with the
                    -- results the own journal keeps; the first win ever says so)
                    teller.bgShared = teller.bgShared or {}
                    local shareKey = tostring(day.key) .. ":" .. e.d
                    if not teller.bgShared[shareKey] then
                        teller.bgShared[shareKey] = true
                        local n, wins, losses, known, firstT = 0, 0, 0, true, e.t or 0
                        for _, x in ipairs(moments) do
                            if x.k == "bg" and x.d == e.d then
                                n = n + 1
                                if x.r == "won" then wins = wins + 1 elseif x.r == "lost" then losses = losses + 1 elseif x.r ~= "draw" then known = false end
                                if (x.t or 0) < firstT then firstT = x.t end
                            end
                        end
                        local wonBefore = false
                        for _, x in ipairs(ownJournal) do if x.k == "bg" and x.r == "won" and (x.t or 0) < firstT then wonBefore = true end end
                        tokens.what = Place(e.d)
                        tokens.times = n == 2 and "twice" or (Words(n) .. " times")
                        tokens.Times = Cap(tokens.times)
                        tokens.wins = Words(wins)
                        local pool, key = PB.shared.bg, "sharedBg"
                        if known and n == 1 then
                            local r = e.r
                            pool, key = (r == "won" and PB.shared.bgWon) or (r == "lost" and PB.shared.bgLost) or PB.shared.bgDraw, "sharedBg" .. tostring(r)
                        elseif known and n >= 2 then
                            pool, key = (wins == n and PB.shared.bgSeriesAll) or (wins == 0 and PB.shared.bgSeriesNone) or PB.shared.bgSeries, "sharedBgSeries"
                        end
                        line = teller:Say(key, pool or PB.shared.bg, rng, tokens)
                        if line and known and wins > 0 and not wonBefore and PB.shared.bgFirstWin then
                            local firstLine = teller:Say("sharedBgFirstWin", PB.shared.bgFirstWin, rng, tokens)
                            if firstLine then line = line .. " " .. firstLine end
                        end
                        if line then Title(wins > 0 and not wonBefore and 62 or 56, Place(e.d), "shared") end
                    end
                elseif e.k == "first" and e.d == "mount" and not e.u and PB.shared.mount then
                    line = teller:Say("sharedMount", PB.shared.mount, rng, tokens)
                    if line then Title(58, "A First Mount", "shared") end
                elseif e.k == "first" and e.d == "raid" and not e.u and PB.shared.raid then
                    line = teller:Say("sharedRaid", PB.shared.raid, rng, tokens)
                elseif e.k == "first" and e.d == "epic" and e.z and not e.u and PB.shared.epic then
                    tokens.what = Q(e.z)
                    line = teller:Say("sharedEpic", PB.shared.epic, rng, tokens)
                elseif e.k == "first" and e.d == "pvp" and not e.u and PB.shared.pvp then
                    line = teller:Say("sharedPvp", PB.shared.pvp, rng, tokens)
                -- (milestones lane, 2026-11-06: more of your own moments reach the day together)
                elseif e.k == "first" and e.d == "epicmount" and not e.u and PB.shared.epicMount then
                    line = teller:Say("sharedEpicMount", PB.shared.epicMount, rng, tokens)
                    if line then Title(60, "A Swift Mount", "shared") end
                elseif e.k == "first" and (e.d == "famous" or e.d == "legendary") and e.z and not e.u and PB.shared.legendary and (function()
                    -- (the famous name over "legendary" for the same item)
                    if e.d == "legendary" then
                        for _, x in ipairs(moments) do if x.k == "first" and x.d == "famous" and x.z == e.z then return false end end
                    end
                    return true
                end)() then
                    tokens.what = Q(e.z)
                    line = teller:Say("sharedLegendary", PB.shared.legendary, rng, tokens)
                    if line then Title(70, Clean(e.z), "shared") end
                elseif e.k == "first" and e.d == "rare" and e.z and not e.u and PB.shared.rare then
                    tokens.what = Q(e.z)
                    line = teller:Say("sharedRare", PB.shared.rare, rng, tokens)
                elseif e.k == "first" and e.d == "tier" and e.z and not e.u and PB.shared.tier then
                    tokens.what = Q(e.z)
                    line = teller:Say("sharedTier", PB.shared.tier, rng, tokens)
                elseif e.k == "first" and e.d == "setfull" and e.z and not e.u and PB.shared.setfull then
                    tokens.what = Q(e.z)
                    line = teller:Say("sharedSetfull", PB.shared.setfull, rng, tokens)
                    if line then Title(62, "The Whole Set", "shared") end
                elseif e.k == "first" and e.d == "worldboss" and e.z and PB.shared.worldboss then
                    tokens.what = Place(e.z)
                    line = teller:Say("sharedWorldboss", PB.shared.worldboss, rng, tokens)
                    if line then Title(68, Clean(e.z), "shared") end
                elseif e.k == "rank" and e.d and PB.sharedRank then
                    tokens.rank, tokens.mySide = Clean(e.d), player.faction or "my side"
                    line = teller:Say("sharedRank", PB.sharedRank, rng, tokens)
                    if line then Title(58, Clean(e.d), "shared") end
                elseif e.k == "close" and not closeSaid then
                    closeSaid = true
                    if e.d then
                        tokens.killer = Foe(e.d)
                        line = teller:Say("sharedClose", PB.shared.close, rng, tokens)
                    elseif e.env and PB.shared[e.env] then
                        line = teller:Say("sharedClose" .. e.env, PB.shared[e.env], rng, tokens)
                    end
                end
                if line then
                    Add(line); sharedCount = sharedCount + 1
                    -- (the one you raised: right after their death)
                    if e.k == "first" and e.d == "rezother" then
                        mood.warm = true
                        local short = Clean(person.name or ""):gsub("%-.*$", "")
                        local placed = false
                        for n2 = #out - 1, 1, -1 do
                            local o = out[n2]:gsub("{%a:([^}]*)}", "%1")
                            if outBeat[n2] == "death" or (o:find(short, 1, true) and (o:find("died", 1, true) or o:find("killed", 1, true) or o:find("fell to", 1, true) or o:find("cut down", 1, true))) then
                                local text, bt = table.remove(out), table.remove(outBeat)
                                table.insert(out, n2 + 1, text); table.insert(outBeat, n2 + 1, bt)
                                placed = true
                                break
                            end
                        end
                        -- (no death said: before the level and the rest, where the day happened)
                        if not placed then
                            for n2 = 2, #out - 1 do
                                if outBeat[n2] == "level" or outBeat[n2] == "levelMark" or outBeat[n2] == "rest" then
                                    local text, bt = table.remove(out), table.remove(outBeat)
                                    table.insert(out, n2, text); table.insert(outBeat, n2, bt)
                                    break
                                end
                            end
                        end
                    end
                end
            end
        end
        lineT, S.z, S.moment = nil, nil, false

        -- Who else was in the party, from your own journal (people of your list).
        if together and ownJournal and PB.alsoThere and not history.othersSaid then history.othersSaid = {} end
        if together and ownJournal and PB.alsoThere then
            local others, seenOther = {}, {}
            teller.othersKeys, teller.othersAt = {}, {}
            for _, scene in ipairs(day.scenes) do
                if scene.kind == "outing" then
                    for _, e in ipairs(ownJournal) do
                        if e.k == "with" and e.n and e.d ~= person.key and Clean(e.n) ~= Clean(person.name or "") and (e.t or 0) < (scene.e or scene.t)
                            and (e.e or e.t or 0) > scene.t and not seenOther[e.n] then
                            seenOther[e.n] = true
                            -- (stamped: when the first of them was with you, within the outing)
                            local withT = math.max(e.t or 0, scene.t or 0)
                            if not lineT or withT < lineT then lineT, S.z = withT, scene.zone end
                            local info = A.db and A.db.people and A.db.people[e.d]
                            local otherPeople = info and L.People and L.People(info.race)
                            local classWord = info and ClassWord(info.class)
                            local otherWho = (otherPeople and classWord and (otherPeople .. " " .. classWord)) or classWord or otherPeople
                            -- (round 10: one who has a bond on his own card is introduced by it, the same
                            -- in every book: "Marrow, my friend", as his own book calls him)
                            local charKey = (player and player.charKey) or (A.Me and A.Me())
                            local otherAs = A.PersonAs and charKey and e.d and A.PersonAs(e.d, charKey)
                            local otherBond = otherAs and BONDS[otherAs.bond or ""]
                            if otherBond then otherWho = nil end
                            local short = Clean(e.n):gsub("%-.*$", "")
                            local bondIntro = otherBond and not history.othersSaid[e.n]
                                and ("{n:" .. short .. "}, " .. teller.base.my .. " " .. (otherBond[otherAs.pronouns or "they"] or otherBond.they)) or nil
                            -- (who they are, the first time this book names them)
                            if otherBond then others[#others + 1] = bondIntro or ("{n:" .. short .. "}")
                            elseif otherWho and not history.othersSaid[e.n] then others[#others + 1] = "{n:" .. short .. "}, " .. Article(otherWho)
                            else others[#others + 1] = "{n:" .. short .. "}" end
                            history.othersSaid[e.n] = true
                            teller.othersKeys[#others] = e.n
                            teller.othersAt = teller.othersAt or {}
                            -- (round 24: the joiner's own group start, from the joiner's record, when it is later)
                            local own0 = otherAs and type(otherAs.journal) == "table" and otherAs.journal
                            if own0 then
                                local first0
                                for _, x in ipairs(own0) do
                                    if x.k == "group" and x.t and x.t >= (scene.t or 0) - 60 and x.t <= (scene.e or scene.t or 0) and (not first0 or x.t < first0) then first0 = x.t end
                                end
                                if first0 and first0 > withT then withT = first0 end
                            end
                            teller.othersAt[#others] = {t = withT, z = scene.zone, before = (e.t or 0) < (scene.t or 0) - 60, late = withT - (scene.t or withT) > 10 * 60}
                        end
                    end
                end
            end
            -- (round 14: in a bonded book each one joins at his own time, in his own line, where he
            -- joined: never a list of people who were not there together)
            if #others > 0 and T.BondKind(person) ~= "plain" then
                beat = "shared"
                for n2, who in ipairs(others) do
                    local at = teller.othersAt[n2]
                    if at then lineT, S.z = at.t, at.z end
                    tokens.others = who:find(", ", 1, true) and (who .. ",") or who
                    -- (round 17: one in the group before the companion came is "already with me", never "joined")
                    local before = at and at.before and PB.alsoThereBefore
                    local joined = not before and at and at.late and PB.alsoThereJoined
                    local line = teller:Say((before and "alsoThereBefore") or (joined and "alsoThereJoined") or "alsoThere", before or joined or PB.alsoThere, rng, tokens)
                    if line then Add(line) end
                end
                others = {}
            end
            if #others > 0 then
                beat = "shared"
                if #others == 1 and others[1]:find(", ", 1, true) then others[1] = others[1] .. "," end
                -- (round 13: a list says names only; who lost an introduction to it gets one another day)
                if #others > 1 then
                    for n2 = 1, #others do
                        if others[n2]:find(", ", 1, true) and teller.othersKeys[n2] then history.othersSaid[teller.othersKeys[n2]] = nil end
                        others[n2] = others[n2]:gsub(", .*$", "")
                    end
                end
                tokens.others = #others == 1 and others[1] or (table.concat(others, ", ", 1, #others - 1) .. " and " .. others[#others])
                local line = teller:Say(#others > 1 and "alsoTherePlural" or "alsoThere", #others > 1 and PB.alsoTherePlural or PB.alsoThere, rng, tokens)
                -- (early in the chapter: right after the opening)
                if line then
                    local countBefore = #out
                    Add(line)
                    if #out > countBefore and #out > 2 then
                        local text, bt = table.remove(out), table.remove(outBeat)
                        table.insert(out, 2, text); table.insert(outBeat, 2, bt)
                    end
                end
            end
        end
        S.Stamp(nil, nil)

        -- 7. Milestones, and crossing paths.
        beat = "milestone"
        local trailing = 0
        if together and not startedTogether then
            local count = history.days + 1
            if PB.milestoneDays[count] and #PB.milestoneDays[count] > 0 and not streakSaid then
                Add(teller:Say("days" .. count, PB.milestoneDays[count], rng, tokens)); trailing = trailing + 1
                if PB.title.days and PB.title.days[count] then Title(60, PB.title.days[count]) end
            end
            local runs = history.dungeonRuns + #f.dungeons
            -- (every run the same place: "five runs through the Deadmines"; counting back to the first
            -- dungeon only when it was another place)
            local sameRuns = #f.dungeons == 1 and (history.dungeons[f.dungeons[1].name] or 0) + 1 == runs
            local firstDiffers = tokens.firstDungeon and tokens.firstDungeon ~= (f.dungeons[1] and Place(f.dungeons[1].name))
            local countList = (sameRuns and PB.dungeonCountSame and PB.dungeonCountSame[runs])
                or (firstDiffers and PB.dungeonCountBack and PB.dungeonCountBack[runs]) or PB.dungeonCount[runs]
            if sameRuns then tokens.dungeonE = Place(f.dungeons[1].name) end
            if #f.dungeons > 0 then S.Stamp(f.dungeons[#f.dungeons].t, f.dungeons[#f.dungeons].name) end
            if #f.dungeons > 0 and countList and trailing == 0 and not streakSaid then Add(teller:Say("runs" .. runs, countList, rng, tokens)); trailing = trailing + 1 end
            S.Stamp(nil, nil)
            if history.firstDay then
                for _, months in ipairs({1, 3, 6, 12}) do
                    if span >= months * 30 - 3 and span <= months * 30 + 6 and not history.months[months] and trailing == 0 and not streakSaid
                        and history.absenceOpened ~= index then
                        history.months[months] = true
                        Add(teller:Say("month" .. months, PB.anniversary[months], rng, tokens)); trailing = trailing + 1
                    end
                end
            end
        elseif together and startedTogether and PB.anniversaryOrigin and history.firstDay then
            for _, months in ipairs({1, 3, 6, 12}) do
                if span >= months * 30 - 3 and span <= months * 30 + 6 and not history.months[months] and PB.anniversaryOrigin[months]
                    and history.absenceOpened ~= index then
                    history.months[months] = true
                    Add(teller:Say("monthO" .. months, PB.anniversaryOrigin[months], rng, tokens)); trailing = trailing + 1
                end
            end
        elseif f.seen and not together then
            beat = "seen"
            S.Stamp(f.seen.t, f.seen.zone)
            tokens.place = Place(f.seen.zone or "the road")
            local seenGap = history.lastSeen and (today - history.lastSeen)
            if history.days > 0 then
                Add(teller:Say("seenCompanion", PB.seenCompanion, rng, tokens))
            elseif history.seenDays == 0 then
                Add(teller:Say("seenFirst", PB.seenFirst, rng, tokens))
            elseif seenGap and seenGap >= 21 then
                tokens.gap = Span(seenGap)
                Add(teller:Say("seenLong", PB.seenLong, rng, tokens))
            elseif history.seenDays >= 4 then
                tokens.nth = Ordinal(history.seenDays + 1)
                Add(teller:Say("seenOften", PB.seenOften, rng, tokens))
            else
                Add(teller:Say("seenAgain", PB.seenAgain, rng, tokens))
            end
            local times = tonumber(f.seen.count) or 1
            if times >= 3 and rng() < 0.5 then
                tokens.Count = Cap(Words(times))
                Add(teller:Say("seenTimes", PB.seenTimes, rng, tokens))
            end
            TitleFrom(30, "seen")
            S.Stamp(nil, nil)
        end

        -- the tenth, twenty-fifth, fiftieth fire shared.
        if together and #f.fires > 0 and PB.fireCount and trailing == 0 then
            local n = history.fires + #f.fires
            S.Stamp(f.fireT, f.restZ)
            if PB.fireCount[n] then beat = "milestone"; Add(teller:Say("fires" .. n, PB.fireCount[n], rng, tokens)); trailing = trailing + 1 end
            S.Stamp(nil, nil)
        end
        -- 8. Sometimes, a closing line that fits the day.
        beat = "close"
        local closeChance = 0.14
        local forged = (history.deaths + history.dungeonRuns + history.rez) >= 6
        if (mood.triumph or mood.grim) then closeChance = closeChance + 0.15 end
        if flourish >= 1 then closeChance = closeChance * 0.5 end
        if together and #out >= 3 and trailing == 0 and flourish < 1 and rng() < closeChance then
            local key
            -- (a day the lord fell is not a grim day, whoever died on the way)
            local lordFell = false
            for _, d in ipairs(f.dungeons) do
                for _, ev in ipairs(d.events) do if ev.k == "boss" and L.Boss and L.Boss(ev.d) and L.Boss(ev.d).last then lordFell = true end end
            end
            if mood.grim and lordFell and not mood.triumph then mood.grim = false end
            if mood.grim and not mood.triumph and not questLoreToday and not mood.warm then key = "grim"
            elseif mood.triumph then key = (tier == "close" and forged and rng() < 0.35) and "forged" or "triumph"
            elseif forged and tier == "close" and rng() < 0.4 then key = "forged"
            elseif tier == "first" then key = "first"
            else key = tier end
            if voice == "we" and key ~= "grim" then key = nil end
            -- on a won day, sometimes the faction's word instead of a closer.
            local bless = blessOccasion and voice ~= "we" and rng() < 0.3 and (PB.blessing[player.race] or PB.blessing[player.faction or ""])
            if bless then Add(bless[rng(#bless)]); flourish = flourish + 1
            elseif key and PB.close[key] then Add(teller:Say("close" .. key, PB.close[key], rng, tokens)); flourish = flourish + 1 end
        end

        -- Later shared records can establish that this first outing was not the
        -- last. Their spacing cannot establish an intervening absence.
        local ahead = nextTogether[index]
        if together and flourish == 0 and trailing == 0 and PB.closeForeshadow and index < #days and (index - (history.foreSaid or -99)) >= 10 then
            if ahead and history.days == 0 and not startedTogether and rng() < 0.3 and outBeat[#out] ~= "death" and outBeat[#out] ~= "rez"
                and not (out[#out] or ""):find("back from death", 1, true) and not (out[#out] or ""):find("raised", 1, true) and (function()
                local later = 0
                for j = index + 1, #days do if Together(DayFacts(days[j])) then later = later + 1 end end
                return later >= 3
            end)() then
                Add(teller:Say("foreLater", PB.closeForeshadow.later, rng, tokens)); history.foreSaid = index
            end
        end
        -- A chapter as long as its day: beyond the budget, the least needed
        -- beats go first.
        do
            local deaths = #f.deaths
            for _, d in ipairs(f.dungeons) do for _, ev in ipairs(d.events) do if ev.k == "death" then deaths = deaths + 1 end end end
            local eventful = 0
            for _, d in ipairs(f.dungeons) do if #d.events > 0 then eventful = eventful + 1 end end
            local budget = not together and 3 or (eventful >= 2 or (eventful == 1 and (deaths > 0 or #f.levels > 0))) and 10
                or eventful == 1 and 8 or (deaths > 0 or f.rez > 0 or #f.levels > 0) and 7 or 5
            -- a long day together has more room: one sentence more per hour, up to four
            if together then budget = budget + math.min(4, math.floor((f.together or 0) / 3600)) end
            -- (a first visit's lore, why and inside, has its own room)
            for _, d in ipairs(f.dungeons) do if d.whySaid then budget = budget + 2 end end
            budget = budget + (f.zoneLore or 0) -- (and a first visit's sight of a zone)
            budget = budget + sharedCount -- (and the moments from your own journal)
            for _, drop in ipairs({"stage", "milestone", "hour", "close", "quests", "travel", "level"}) do
                for i = #out, 2, -1 do
                    if #out <= budget then break end
                    -- (the level a run brought stays with the run, 2026-11-11)
                    if outBeat[i] == drop and not (drop == "level" and S.RunLevel(out[i])) then table.remove(out, i); table.remove(outBeat, i) end
                end
            end
        end
        if together and #out > 0 and not teller.named and not implicit and PB[history.greetKey or "often"] then
            local key = history.days == 0 and "often" or (tier == "close" and "daily" or "often")
            tokens.nth = Ordinal(history.streak + 1)
            -- (a line that names them: "{pair}" is "you" when others were there too)
            local naming = {}
            for _, line in ipairs(PB[key]) do if line:find("{name}", 1, true) then naming[#naming + 1] = line end end
            local greeting = teller:Say(key, #naming > 0 and naming or PB[key], rng, tokens)
            -- an opening that names no one gives way to it
            -- (an opening that measures the time since the last outing is kept; the greeting follows it)
            if greeting and outBeat[1] == "open" and not out[1]:find("{n:", 1, true) and history.intervalOpen ~= index then out[1] = S.Carry(out[1], greeting)
            elseif greeting and history.intervalOpen == index then table.insert(out, 2, greeting); table.insert(outBeat, 2, "open")
            elseif greeting then table.insert(out, 1, greeting); table.insert(outBeat, 1, "open") end
            -- ("back to the party. Shael made one more in the party.": the other one just came along)
            if greeting and out[2] and greeting:find("party", 1, true) and out[2]:find("in the party", 1, true) then
                out[2] = S.Carry(out[2], (out[2]:gsub(" made one more in the party%.$", " came along too."):gsub(" was in the party as well%.$", " came along too.")))
            end
        end
        -- join two short neighbours (same subject: "and"; else ", and"), twice a chapter at most.
        do
            local nameMark = teller.base.name
            local function Count(t) local n = 0 for _ in t:gsub("{%a:", ""):gmatch("%S+") do n = n + 1 end return n end
            local function Subject(t)
                if t:sub(1, #nameMark) == nameMark then return nameMark end
                return t:match("^(%a+)%s")
            end
            local personal = {You = true, We = true, I = true, He = true, She = true, They = true}
            -- Only beats that belong together: the work and the rest, a death and the rescue.
            local joinable = {["travel>quests"] = true, ["travel>questKey"] = true, ["quests>rest"] = true, ["questKey>rest"] = true,
                ["travel>rest"] = true, ["death>death"] = true, ["climax>death"] = true, ["level>rest"] = true, ["rest>level"] = true}
            -- the level a dungeon brought goes before what its lord's fall meant (that stays last)
            for k = #out - 1, 1, -1 do
                if outBeat[k] == "consequence" and (outBeat[k + 1] == "level" or outBeat[k + 1] == "levelMark") then
                    out[k], out[k + 1] = out[k + 1], out[k]
                    outBeat[k], outBeat[k + 1] = outBeat[k + 1], outBeat[k]
                end
            end
            do
                local k = 2
                while k < #out do
                    local a, b = out[k], out[k + 1]
                    -- ("Anacondra fell mostly to your arrows, and you reached level 17.")
                    if outBeat[k] == "climax" and outBeat[k + 1] == "level" and outBeat[k + 2] == "consequence" and a:sub(-1) == "."
                        and not a:find(",", 1, true) and not a:find(" and ", 1, true) and (b:match("^You ") or b:match("^I ") or b:match("^We "))
                        and not b:find(",", 1, true) and Count(a) + Count(b) <= 20 then
                        out[k] = S.Carry(a, a:sub(1, -2) .. ", and " .. ((b:match("^I ") and b) or (b:sub(1, 1):lower() .. b:sub(2))))
                        table.remove(out, k + 1); table.remove(outBeat, k + 1)
                    end
                    -- ("You killed Lord Pythas, and last of all Mutanus the Devourer.")
                    local killer = a:match("^(%a+) killed [^,]+%.$")
                    local last = b and (b:match("^Last of all, %a+ killed ([^,]+)%.$") or b:match("^%a+ killed (.+), last of all%.$"))
                    if killer and last and (killer == "You" or killer == "We" or killer == "I") and Count(a) + Count(b) <= 24 then
                        out[k] = S.Carry(a, a:sub(1, -2) .. ", and last of all " .. last .. ".")
                        table.remove(out, k + 1); table.remove(outBeat, k + 1)
                    end
                    k = k + 1
                end
            end
            -- "Bryn died. Bazil Thredd died all the same. Dextren Ward was cut down." in one:
            -- "Bryn died, but Bazil Thredd went down all the same, and then Dextren Ward."
            do
                local k = 1
                while k < #out do
                    local fallen
                    for _, verb in ipairs({" died", " was killed", " fell", " was cut down"}) do
                        fallen = fallen or out[k]:match("^({n:[^}]+})" .. verb .. "%.$") or out[k]:match("^({n:[^}]+})" .. verb .. " there%.$")
                    end
                    local boss, rest = out[k + 1]:match("^({p:[^}]+}) (.+)%.$")
                    local costly = rest == "died all the same" or rest == "still went down, in the end" or rest == "did not live out the fight"
                    if fallen and boss and costly then
                        out[k] = S.Carry(out[k], fallen .. " died, but " .. boss .. " went down all the same.")
                        table.remove(out, k + 1); table.remove(outBeat, k + 1)
                        local nextBoss, how = (out[k + 1] or ""):match("^({p:[^}]+}) (.+)%.$")
                        local fell = how == "was cut down" or how == "was slain" or how == "was defeated" or how == "barred the way, briefly"
                            or how == "fell" or how == "went down" or how == "fell too"
                        local after = out[k + 1] or ""
                        if not (nextBoss and fell) then
                            nextBoss = after:match("^You killed ({p:[^}]+})%.$") or after:match("^You dealt with ({p:[^}]+})%.$")
                                or after:match("^We killed ({p:[^}]+})%.$") or after:match("^({p:[^}]+}) fought, and lost%.$")
                            fell = nextBoss ~= nil
                        end
                        if nextBoss and fell then
                            out[k] = S.Carry(out[k], out[k]:sub(1, -2) .. ", and then " .. nextBoss .. ".")
                            table.remove(out, k + 1); table.remove(outBeat, k + 1)
                        end
                    end
                    k = k + 1
                end
            end
            -- a death and the rescue, or the rest after it, in one sentence
            do
                local k = 1
                while k < #out do
                    local a, b = out[k], out[k + 1]
                    local ba, bb = outBeat[k], outBeat[k + 1]
                    if (ba == "death" or ba == "climax") and a:sub(-1) == "." and not a:find(" and ", 1, true) and not a:find("%. ") and not b:find("%. ")
                        and not b:find(" and ", 1, true) and Count(a) + Count(b) <= 24 then
                        if bb == "rez" then
                            -- ("..., and it was Mira who raised you": the joined clause loses its capital, a name or "I" keeps it)
                            local rest = (b:match("^I ") or b:match("^{")) and b or (b:sub(1, 1):lower() .. b:sub(2))
                            out[k] = S.Carry(a, a:sub(1, -2) .. ", and " .. rest)
                            table.remove(out, k + 1); table.remove(outBeat, k + 1)
                        elseif bb == "rest" and ba == "death" and (b:match("^You ") or b:match("^We ") or b:match("^I ")) then
                            out[k] = S.Carry(a, a:sub(1, -2) .. ", and afterwards " .. b:sub(1, 1):lower() .. b:sub(2))
                            if b:match("^I ") then out[k] = S.Carry(a, a:sub(1, -2) .. ", and afterwards " .. b) end
                            table.remove(out, k + 1); table.remove(outBeat, k + 1)
                        end
                    end
                    k = k + 1
                end
            end
            local joins, i = 0, 2
            while i < #out and joins < 2 do
                local a, b = out[i], out[i + 1]
                local sa, sb = Subject(a), Subject(b)
                local ok = Count(a) <= 9 and Count(b) <= 10 and Count(a) + Count(b) <= 18 and a:sub(-1) == "."
                    and not a:find(",") and not b:find(",") and joinable[(outBeat[i] or "?") .. ">" .. (outBeat[i + 1] or "?")]
                if ok and sa and sa == sb and (personal[sa] or sa == nameMark) and a:sub(#sa + 2):match("^(%a+)") ~= b:sub(#sb + 2):match("^(%a+)") then
                    out[i] = S.Carry(a, a:sub(1, -2) .. " and " .. b:sub(#sb + 2))
                    table.remove(out, i + 1); table.remove(outBeat, i + 1); joins = joins + 1; i = i + 1
                elseif ok and sa and sb and (personal[sa] or sa == nameMark) and (personal[sb] or sb == nameMark) and sa ~= sb then
                    local rest = (sb == "I" or sb == nameMark) and b or (b:sub(1, 1):lower() .. b:sub(2))
                    out[i] = S.Carry(a, a:sub(1, -2) .. ", and " .. rest)
                    table.remove(out, i + 1); table.remove(outBeat, i + 1); joins = joins + 1; i = i + 1
                else
                    i = i + 1
                end
            end
        end
        -- a quiet day followed by another quiet day in the same zone is held back and told with it.
        if not brief and together and #out > 0 and history.days >= 3 and not majorOpen and not discovery and not quietDay and #f.quotes == 0
            and (history.lastMerge or -99) < index - 4 and days[index + 1] and PB.dayTwo then
            local function Quiet(g)
                if g.outings == 0 or #g.dungeons > 0 or #g.deaths > 0 or #g.levels > 0 or #g.fires > 0 or #g.rests > 0
                    or #g.zones ~= 1 or (g.rez or 0) > 0 or g.met or #g.quotes > 0 then return false end
                local z = L.Zone and L.Zone(g.zones[1])
                if z and z.kind == "city" then return false end
                for _, quest in ipairs(g.quests) do
                    -- (work with a story of its own is not a quiet day: it is told on its day)
                    if A.Lore and A.Lore.QuestStory and A.Lore.QuestStory(quest.title, quest.qid) then return false end
                    local lore = L.Quest and L.Quest(quest.title)
                    local ql, kind = quest.level or (lore and lore.level), quest.kind or (lore and lore.kind)
                    if (ql and quest.pl and ql - quest.pl >= 3) or kind == 1 or kind == 81 or kind == 62 then return false end
                end
                return true
            end
            local nextDay = days[index + 1]
            local g = DayFacts(nextDay)
            local onlyDay = true
            for i = 1, #out do if outBeat[i] ~= "day" and outBeat[i] ~= "open" then onlyDay = false end end
            if onlyDay and Quiet(f) and Quiet(g) and DayNumber(nextDay.t) == today + 1 and g.zones[1] == mainZone
                and not (PB.milestoneDays[history.days + 1] and #PB.milestoneDays[history.days + 1] > 0) and rng() < 0.5 then
                history.merged = {n = #f.quests, weekday = day.weekday, zone = mainZone, run = zoneRun, heldAt = index}
                history.lastMerge = index
                for i = #out, 1, -1 do out[i] = nil; outBeat[i] = nil end
                title, titleRank, titleKey = nil, -1, nil
            end
        end
        -- the short telling skips a routine day and bridges the gap.
        if brief and together and #out > 0 and history.days > 0 and not majorOpen then
            -- (a day whose work was told as a scene, or named as hard or group work, is kept;
            -- a day of plain hours, errands and an ordinary rest is bridged)
            local routine = not questLoreToday and f.notableWork ~= "hard" and f.notableWork ~= "elite"
                and not ((#f.fires > 0 and history.fires == 0) or (#f.rests > 0 and history.rests == 0))
            local plain = {day = true, open = true, rest = true, questKey = true, quests = true, travel = true}
            for i = 1, #out do if not plain[outBeat[i]] then routine = false end end
            -- (a greeting with nothing after it, a city day's in the short telling: not a chapter)
            local onlyOpen = true
            for i = 1, #out do if outBeat[i] ~= "open" then onlyOpen = false end end
            if (routine and not formative and not discovery and not quietDay) or onlyOpen then
                history.skipped = history.skipped or {n = 0, zones = {}, seen = {}}
                local sk = history.skipped
                sk.n = sk.n + 1
                if mainZone and not sk.seen[mainZone] then sk.seen[mainZone] = true; sk.zones[#sk.zones + 1] = mainZone end
                for i = #out, 1, -1 do out[i] = nil; outBeat[i] = nil end
            end
        end
        -- (Before a return after a long silence, the bridge would read as a contradiction.)
        if brief and #out > 0 and majorOpen and history.skipped then history.skipped = nil end
        if brief and (#out > 0 or index == #days) and history.skipped and history.skipped.n > 0 and PB.bridge then
            local sk = history.skipped
            local names = {}
            for i = 1, math.min(3, #sk.zones) do names[#names + 1] = Place(sk.zones[i]) end
            if #sk.zones > 3 then names[#names + 1] = "elsewhere" end
            tokens.bridgeZones = List(names)
            tokens.count, tokens.Count = Words(sk.n), Cap(Words(sk.n))
            -- The bridge is told first but written last: the chapter's places must not cut it.
            local savedPlaces = teller.saidPlaces
            teller.saidPlaces = {}
            local line = teller:Say(sk.n == 1 and "bridgeOne" or "bridge", sk.n == 1 and PB.bridgeOne or PB.bridge, rng, tokens)
            teller.saidPlaces = savedPlaces
            if line then
                if out[1] then out[1] = S.Carry(out[1], Cap((out[1]:gsub("^And so,? ", "")))) end
                table.insert(out, 1, line); table.insert(outBeat, 1, "open")
            end
            history.skipped = nil
        end
        -- the held day could not be told with this one: one line for it, first.
        if history.merged and history.merged.heldAt ~= index and #out > 0 and PB.bridgeOne then
            tokens.bridgeZones = Place(history.merged.zone)
            local savedPlaces = teller.saidPlaces
            teller.saidPlaces = {}
            local line = teller:Say("bridgeOne", PB.bridgeOne, rng, tokens)
            teller.saidPlaces = savedPlaces
            if line then table.insert(out, 1, line); table.insert(outBeat, 1, "open") end
            history.merged = nil
        end
        -- Your own day before they came: from your own journal, now and then.
        if ownJournal and #out > 0 and not brief and chapter >= 1 and PB.soloBefore and not f.met then
            local joinedAt
            for _, scene in ipairs(day.scenes) do if scene.kind == "outing" then joinedAt = scene; break end end
            local alone, soloZone
            if joinedAt then alone, soloZone = AloneBefore(joinedAt.t) end
            if alone and alone >= 3600 and soloZone and rng() < 0.6 then
                tokens.soloSpan = alone >= 3 * 3600 and "a long day" or About(alone)
                tokens.soloZone = Place(soloZone)
                -- (the place is said even if the chapter names it: it is where you were before)
                local savedPlaces = teller.saidPlaces
                teller.saidPlaces = {}
                local line = teller:Say("soloBefore", PB.soloBefore, rng, tokens)
                teller.saidPlaces = savedPlaces
                -- second, after the opening: the day's time comes first
                if line then table.insert(out, 2, line); table.insert(outBeat, 2, "travel") end
            end
        end
        if #out > 0 or #f.quotes > 0 then chapter = chapter + 1 end
        if out[1] then history.prevOpening, history.lastOpening = history.lastOpening, teller:First(out[1]) end
        -- a written chapter that named the companion lets tomorrow's leave the name out.
        if together and #out > 0 then
            history.namedDay = teller.named and today or nil
        end
        -- the first two words of the last two openings.
        if out[1] then
            local two = out[1]:gsub("{%a:", ""):gsub("[{}]", ""):match("^(%S+%s+%S+)")
            history.openTwo = {two and two:lower():gsub("[,.]", ""), (history.openTwo or {})[1]}
        end
        history.lastBossTitle, history.pendingBossTitle = history.pendingBossTitle, nil
        local chapterTitle = title or (mainZone and (
                (zoneRun == 2 and (Place(mainZone):gsub("{p:the ", "{p:The ") .. ", Again"))
                or (zoneRun == 3 and ("Still in " .. Place(mainZone)))
                or (zoneRun >= 4 and zoneRun <= 12 and (Place(mainZone):gsub("{p:the ", "{p:The ") .. ", " .. Cap(Ordinal(zoneRun)) .. " Day"))
                or (zoneRun > 12 and ("Still in " .. Place(mainZone)))
                or (Recent("zone:" .. mainZone, 0) and ("Back in " .. Place(mainZone)))
                or Place(mainZone):gsub("{p:the ", "{p:The "))) or nil
        -- (a title begins with a capital: "The Hillsbrad Foothills", not "the Hillsbrad Foothills")
        if chapterTitle then chapterTitle = chapterTitle:gsub("^the ", "The "):gsub("^{p:the ", "{p:The ") end
        -- The planned telling: every line in the order it happened (its movements and anchors are
        -- made when the text is written, below).
        if S.planned then
            T.PlanChapter({out = out, beats = outBeat, times = outT, zones = S.Z, S = S, f = f, day = day, teller = teller,
                place = Place, person = person, history = history, ownJournal = ownJournal, lastOuting = lastOuting,
                voice = voice, player = player, index = index, foe = Foe, mainZone = mainZone, zoneRun = zoneRun,
                weekday = day.weekday, firstOuting = firstOuting, startLevel = mySelf and mySelf.startLevel})
        end
        -- Chronology (2026-11-09): a moment from your own journal is told where it happened, and
        -- the hour you stopped closes the chapter. A rare seen at the start of the evening used to
        -- trail "Midnight came and went before you stopped", after the day's work.
        -- (the planned telling is in time order already: only the hour is kept last)
        do
            local firstWorkT
            for _, list in ipairs({f.quests, f.dungeons, f.deaths}) do
                for _, x in ipairs(list) do if x.t and (not firstWorkT or x.t < firstWorkT) then firstWorkT = x.t end end
            end
            -- (what a chapter says before its work: who, where, how long)
            local SETTING = {open = true, day = true, land = true, landKey = true, travel = true, stage = true,
                prologue = true, recap = true, again = true, shared = true}
            local early, kept, closing = {}, {}, {}
            for n = 1, #out do
                local t = S.M[out[n]] and outT[out[n]] -- (the shared moments only: other lines carry stamps too)
                if outBeat[n] == "shared" and t and firstWorkT and t < firstWorkT and not S.planned then early[#early + 1] = n
                elseif outBeat[n] == "hour" then closing[#closing + 1] = n
                else kept[#kept + 1] = n end
            end
            if #early > 0 or (#closing > 0 and closing[#closing] < #out) then
                local order, placed = {}, #early == 0
                for _, n in ipairs(kept) do
                    if not placed and not SETTING[outBeat[n] or ""] then
                        for _, m in ipairs(early) do order[#order + 1] = m end
                        placed = true
                    end
                    order[#order + 1] = n
                end
                if not placed then for _, m in ipairs(early) do order[#order + 1] = m end end
                for _, n in ipairs(closing) do order[#order + 1] = n end
                local newOut, newBeat = {}, {}
                for i, n in ipairs(order) do newOut[i], newBeat[i] = out[n], outBeat[n] end
                for i = 1, #out do out[i], outBeat[i] = newOut[i], newBeat[i] end
            end
        end
        -- (2026-11-11 round 2: an opening on a stay that was a small part of the evening says nothing
        -- ("That evening you went out into the Undercity"); when a first of the day, a new land or a
        -- crossing, came within the hour, that moment opens the chapter instead, and the short stay's
        -- lore line goes. The opening that names the companion is kept.)
        if not S.planned and firstOuting and (outBeat[1] == "open" or outBeat[1] == "day") and not out[1]:find("{n:", 1, true) and (f.together or 0) > 0 then
            -- (the first zone stay of the record: the companion's book keeps one scene per session)
            local first = Stretches(day, person)[1]
            local stay = first and ((first.e or first.t) - first.t) or 0
            if first and stay <= 30 * 60 and stay < 0.25 * f.together then
                -- (the moment: a first or a crossing of your own book within the hour, then its line by its stamp)
                local momentT
                for _, m in ipairs(moments or {}) do
                    local real = type(m) == "table" and ((m.k == "first" and (m.d == "continent" or m.d == "zone" or m.d == "zeppelin" or m.d == "boat" or m.d == "flight"))
                        or m.k == "voyage")
                    if real and m.t and m.t >= first.t and m.t - first.t <= 3600 and (not momentT or m.t < momentT) then momentT = m.t end
                end
                local at
                for n = 2, #out do
                    local t = outBeat[n] == "shared" and outT[out[n]]
                    if momentT and t and math.abs(t - momentT) <= 60 and not out[n]:find("^{[np]:") and not out[n]:find("^I ") then at = n; break end
                end
                if at then
                    local moment = out[at]
                    -- (lane C8: the close answers the opening, so the opener keeps the place the record began in)
                    local opener = "The " .. PartOf(Hour(first.t)) .. " began in " .. Place(first.zone) .. ", and " .. moment:gsub("^%u", string.lower)
                    -- (round 3: the party once, in the opener, "carried you and Marrow to Kalimdor ..., with
                    -- Dahlia along"; the others' line folds in, and no second first in the opening group)
                    local nm = teller.base.name
                    if not opener:find("{n:", 1, true) then
                        if teller.base.we == "we" then opener = opener:gsub(" us ", " " .. nm .. " and me ", 1)
                        else opener = opener:gsub(" you ", " you and " .. nm .. " ", 1) end
                    end
                    table.remove(out, at); table.remove(outBeat, at)
                    for n = 2, math.min(4, #out) do
                        local l = out[n]
                        if outBeat[n] == "shared" and (l:find("made a third", 1, true) or l:find("came along too", 1, true) or l:find("one more in the party", 1, true)
                            or l:find("went with", 1, true) or l:find("joined {", 1, true) or l:find("for the day", 1, true) or l:find("was there too", 1, true)
                            or l:find("along as well", 1, true) or l:find("filled out the party", 1, true) or l:find("^With {", 1) or l:find("was along", 1, true)) then
                            local names = {}
                            for who in l:gmatch("{n:[^}]+}, an? [%a' ]+") do names[#names + 1] = who .. "," end
                            if #names == 0 then for who in l:gmatch("{n:[^}]+}") do names[#names + 1] = who end end
                            if #names > 0 and opener:sub(-1) == "." then
                                opener = opener:sub(1, -2) .. ", with " .. List(names) .. " along."
                                table.remove(out, n); table.remove(outBeat, n)
                            end
                            break
                        end
                    end
                    local oldOpener = out[1]
                    out[1] = S.Carry(moment, opener)
                    for n = 2, math.min(4, #out) do
                        if outBeat[n] == "land" then table.remove(out, n); table.remove(outBeat, n); break end
                    end
                    -- (the place the old opener named is named nowhere now: the first hand-in told there says it)
                    for place in oldOpener:gmatch("{p:([^}]+)}") do
                        local key = place:gsub("^[Tt]he ", ""):match("^(%S+)")
                        local named = false
                        for n = 1, #out do if out[n]:find("{p:" .. place .. "}", 1, true) or out[n]:find(key, 1, true) then named = true end end
                        if not named then
                            for n = 2, #out do
                                local z = S.Z[out[n]]
                                if (outBeat[n] == "questKey" or outBeat[n] == "quests") and z and Clean(z):gsub("^[Tt]he ", ""):match("^(%S+)") == key and not T.PlaceLed(out[n]) then
                                    -- (a name keeps its capital after the lead)
                                    local w = out[n]:match("^(%a+)")
                                    local SMALL = {You = true, We = true, The = true, A = true, An = true, Your = true, Our = true, It = true, There = true, Then = true, I = false}
                                    local rest = (w and SMALL[w]) and out[n]:gsub("^%u", string.lower) or out[n]
                                    out[n] = S.Carry(out[n], "In {p:" .. place .. "}, " .. rest)
                                    break
                                end
                            end
                        end
                    end
                    -- (one first in the opening group: a second first within the half hour goes)
                    for n = 2, math.min(4, #out) do
                        local t = outBeat[n] == "shared" and outT[out[n]]
                        if t and momentT and t - momentT <= 30 * 60 and (out[n]:find("first", 1, true) or out[n]:find("never", 1, true) or out[n]:find("new to", 1, true)) then
                            table.remove(out, n); table.remove(outBeat, n); break
                        end
                    end
                end
            end
        end
        -- (2026-11-11: a shared moment told after a death, a run or a kill that came later in the
        -- day moves in front of the first such line; the planned telling orders by time itself)
        if not S.planned then
            local LATER = {death = true, rez = true, dungeon = true, climax = true, kills = true, consequence = true}
            local n = 1
            while n <= #out do
                local line = out[n]
                local t = outBeat[n] == "shared" and outT[line]
                local to
                if t then
                    for m = 1, n - 1 do
                        local mt = outT[out[m]]
                        if LATER[outBeat[m] or ""] and mt and mt > t then to = m; break end
                    end
                end
                if to then
                    local b = outBeat[n]
                    table.remove(out, n); table.remove(outBeat, n)
                    table.insert(out, to, line); table.insert(outBeat, to, b)
                end
                n = n + 1
            end
        end
        -- (the companion's name opening the sentence right after the opening that named them: the
        -- pronoun instead, "I met Morammon at a campfire. He was level 15 then", never "Mira, my
        -- wife, was at my side. Mira was level 16"; a "they" keeps the name, 2026-11-07)
        do
            local nm, b = teller.base.name, teller.base
            for n = 2, #out do
                local prev = out[n - 1] or ""
                if b.they ~= "they" and out[n]:sub(1, #nm + 1) == nm .. " " and outBeat[n - 1] == "open" and prev:find(nm, 1, true)
                    and not prev:gsub(nm, "", 1):find("{n:", 1, true) and not prev:find("%. ") then
                    local rest = out[n]:sub(#nm + 2)
                    out[n] = S.Carry(out[n], b.They .. " " .. rest)
                end
            end
        end
        -- (round 4: the party once, folded into the opener that names the companion: "The evening found
        -- you and Dahlia in the Undercity, with Marrow along"; the others' line with its introductions)
        if not S.planned and #out >= 2 and (outBeat[1] == "open" or outBeat[1] == "day") and out[1]:find("{n:", 1, true) and out[1]:sub(-1) == "." then
            for n = 2, math.min(4, #out) do
                local l = out[n]
                if outBeat[n] == "shared" and (l:find("made a third", 1, true) or l:find("came along too", 1, true) or l:find("one more in the party", 1, true)
                    or l:find("went with", 1, true) or l:find("joined {", 1, true) or l:find("for the day", 1, true) or l:find("was there too", 1, true)
                    or l:find("along as well", 1, true) or l:find("filled out the party", 1, true) or l:find("^With {", 1) or l:find("was along", 1, true)) then
                    local names = {}
                    for who in l:gmatch("{n:[^}]+}, an? [%a' ]+") do names[#names + 1] = who .. "," end
                    if #names == 0 then for who in l:gmatch("{n:[^}]+}") do names[#names + 1] = who end end
                    if #names > 0 and not out[1]:find(" along%.$") then
                        out[1] = S.Carry(out[1], out[1]:sub(1, -2) .. ", with " .. List(names) .. " along.")
                        table.remove(out, n); table.remove(outBeat, n)
                    end
                    break
                end
            end
        end
        -- (round 3: one first in the opening group: of two shared firsts within half an hour among the
        -- chapter's first lines, the second goes)
        if not S.planned then
            local firstAt
            for n = 1, math.min(6, #out) do
                local l = out[n]
                local isFirst = (outBeat[n] == "shared" or n == 1) and (l:find("first", 1, true) or l:find("never", 1, true) or l:find("new to", 1, true) or l:find("new ground", 1, true))
                    and not (l:find("raised", 1, true) or l:find(" rose", 1, true) or l:find("back from death", 1, true))
                    and not (n > 1 and l:find("{n:", 1, true))
                if isFirst and outT[l] then
                    if firstAt and math.abs(outT[l] - firstAt) <= 30 * 60 then table.remove(out, n); table.remove(outBeat, n); break end
                    firstAt = outT[l]
                end
            end
        end
        -- (round 3: their death and your first raise of them, one sentence: "Dahlia fell in Stranglethorn
        -- Vale, and you called on the Light, and Dahlia rose, the first you had ever raised")
        if not S.planned then
            local n = 1
            while n < #out do
                local a, b = out[n], out[n + 1]
                local ta, tb = outT[a], outT[b]
                local dead = outBeat[n] == "death" and S.D[a] and S.D[a].w ~= "you"
                local raise = outBeat[n + 1] == "shared" and (b:find("raised", 1, true) or b:find(" rose", 1, true) or b:find("back from death", 1, true))
                if dead and raise and ta and tb and tb >= ta and tb - ta <= 3 * 60 and a:sub(-1) == "." and not a:find(", and ", 1, true) and not b:find("^{n:") then
                    out[n] = S.Carry(a, a:sub(1, -2) .. ", and " .. (b:match("^I ") and b or (b:gsub("^%u", string.lower))))
                    table.remove(out, n + 1); table.remove(outBeat, n + 1)
                end
                n = n + 1
            end
        end
        -- The chapter composed (lane C8, 2026-11-12): T.Compose above, before the close is written.
        S.composeWhy = "outings " .. tostring(f.outings) .. ", planned " .. tostring(S.planned)
        if not S.planned and #out > 0 and f.outings > 0 and T.COMPOSE ~= false then
            local okC, errC = pcall(T.Compose, {out = out, beats = outBeat, times = outT, S = S, f = f, day = day, person = person, teller = teller, PB = PB,
                rng = rng, tokens = tokens, ownJournal = ownJournal, stretches = Stretches(day, person), Place = Place, history = history,
                mainZone = mainZone, gap = gap})
            if not okC and T.DebugLines then print("compose: " .. tostring(errC)) end
        end
        -- The chapter's close (2026-11-11, round 3): what the evening came to, from the day's episodes
        -- (A.JournalEpisodes.Day over the companion's record: the dungeon behind you, the work for the
        -- givers done), then where it ended, from your own book (the place, the span, the crossings, and
        -- whether the companion stopped before you did). Never a moral, never invented, never a death
        -- or an errand as the last line.
        if not S.planned and not brief and #out > 0 and PB.closeDone and A.JournalEpisodes and A.JournalEpisodes.Day and f.outings > 0 then
            local okD, dayE = pcall(A.JournalEpisodes.Day, Stretches(day, person))
            local sum = {}
            if okD and type(dayE) == "table" then
                -- (round 4: the chapter's largest thing first, the spine; the other episodes after it)
                local ordered = {}
                if dayE.spine then ordered[#ordered + 1] = dayE.spine end
                for _, ep in ipairs(dayE.episodes or {}) do if ep ~= dayE.spine then ordered[#ordered + 1] = ep end end
                for _, ep in ipairs(ordered) do
                    local o = ep.outcome
                    -- (the first clear of that place in this book: a later one has its run paragraph, never
                    -- the same closing sentence twice)
                    history.closeDone = history.closeDone or {}
                    if o and o.kind == "dungeon" and o.lordKilled and o.dungeon and #sum < 2 and not history.closeDone[o.dungeon]
                        and T.BondKind(person) == "plain" then
                        history.closeDone[o.dungeon] = true
                        tokens.Dungeon = Place(o.dungeon)
                        local line = teller:Say("closeDone", PB.closeDone, rng, tokens)
                        if line then sum[#sum + 1] = line end
                    end
                end
            end
            local givers, seenG = {}, {}
            local QD = A.QuestDeeds
            for _, q in ipairs(f.quests) do
                local story = QD and QD.Story and QD.Story(q)
                local giver = story and ((story.pov and story.pov.giver) or (QD.Giver and QD.Giver(story)))
                if type(giver) == "string" and giver ~= "" and not seenG[giver] and #givers < 3 then seenG[giver] = true; givers[#givers + 1] = giver end
            end
            -- (lane C8: not when the chapter's last line names every giver already)
            local giversTold = #givers > 0
            for _, g in ipairs(givers) do
                local first = Clean(g):match("^(%S+)")
                if not (first and #first >= 4 and A.JournalPlain((out[#out - 1] or "") .. " " .. (out[#out] or "")):find(first, 1, true)) then giversTold = false end
            end
            -- (lane C9: the close is about the two of you, not "the work for X was done"; T.CLOSE_WORK brings it back)
            if #givers > 0 and PB.closeWork and T.CLOSE_WORK and #sum == 0 and not giversTold then
                tokens.givers = List(givers)
                local line = teller:Say("closeWork", PB.closeWork, rng, tokens)
                if line then sum[#sum + 1] = line end
            end
            local t0, e0
            for _, scene in ipairs(day.scenes) do
                if scene.kind == "outing" then t0 = math.min(t0 or scene.t, scene.t); e0 = math.max(e0 or (scene.e or scene.t), scene.e or scene.t) end
            end
            local endLine, endKey
            if t0 and e0 and e0 - t0 >= 20 * 60 and ownJournal and PB.closeEndFar then
                local first = Stretches(day, person)[1]
                local from = first and first.zone
                local endZone, endT, ownEnd, crossings, boats = nil, nil, 0, 0, false
                for _, x in ipairs(ownJournal) do
                    -- (round 30: a step out of the city for a minute at logout is not where the evening ended)
                    if x.k == "play" and x.t and x.z and x.t <= e0 + 60 and (x.e or x.t) >= t0 and (not endT or x.t >= endT)
                        and (not endZone or (x.e or x.t) - x.t >= 300) then endZone, endT = x.z, x.t end
                    if x.k == "play" and x.t and x.t >= t0 and x.t <= e0 + 6 * 3600 then ownEnd = math.max(ownEnd, x.e or x.t) end
                    if x.k == "voyage" and x.t and x.t >= t0 and x.t <= e0 and x.d ~= "hearth" and x.d ~= "portal" then crossings = crossings + 1; if x.d ~= "zeppelin" then boats = true end end
                end
                if endZone then
                    local minutes = math.floor((e0 - t0) / 60)
                    local span
                    if minutes < 50 then span = "under an hour"
                    elseif minutes < 75 then span = "an hour"
                    else
                        local h, r = math.floor(minutes / 60), minutes % 60
                        span = (r < 15 and (Words(h) .. " hours")) or (r < 45 and (Words(h) .. " and a half hours")) or ("nearly " .. Words(h + 1) .. " hours")
                    end
                    local h = Hour(e0)
                    local stopped = ownEnd > e0 + 10 * 60
                    -- (lane C8: the companion stopped before you did: where the record last had the two of you)
                    if stopped then
                        -- (round 13: where the group ended, in the land the player was in at that moment;
                        -- the companion's last entry is only where its record stopped, not where we parted)
                        local here
                        for _, x in ipairs(ownJournal) do
                            if x.k == "play" and x.z and x.t and x.t <= e0 and (x.e or x.t) >= e0 - 30 and (not here or x.t > here.t)
                                and (not here or (x.e or x.t) - x.t >= 300) then here = x end
                        end
                        if here then endZone = here.z
                        else
                            local st = Stretches(day, person)
                            if st[#st] and st[#st].zone then endZone = st[#st].zone end
                        end
                    end
                    -- (no hour to say is an empty token, not a banned one: a banned token makes every line of
                    -- the pool a last resort, and the first one was always taken, lane C9)
                    tokens.clock = (h < 5 and "past midnight") or (h == 23 and "near midnight") or ""
                    tokens.span, tokens.part = span, PartOf(Hour(t0))
                    tokens.Span = Cap(span)
                    tokens.place, tokens.from = A.JournalPlain(Place(endZone)), A.JournalPlain(Place(from or endZone))
                    tokens.crossings = crossings > 0 and (Words(crossings) .. (boats and " sea crossing" or " zeppelin crossing") .. (crossings > 1 and "s" or "")) or false
                    local same = (from or endZone) == endZone
                    local key = (stopped and "closeStop" or "closeEnd") .. (same and "Same" or (crossings > 0 and "Far" or "Near"))
                    -- (lane C9: the two of you and where the night left you; the bond chooses the words:
                    -- a close bond ends the night together or parts for the night, a friend calls it a
                    -- night; with three or more in the party, or no bond, the plain close)
                    local bondKind = T.BondKind(person)
                    if bondKind ~= "plain" then
                        local shape = (same and "Same" or (crossings > 0 and "Far" or "Near"))
                        local bkey = (stopped and (bondKind == "close" and "closeParted" or "closeCalled"))
                            or (bondKind == "close" and "closeTogether" or "closeBoth")
                        if PB[bkey .. shape] then key = bkey .. shape end
                    end
                    endLine = PB[key] and teller:Say(key, PB[key], rng, tokens)
                    history.lastEndZone = endZone
                    endKey = key
                end
            elseif t0 and e0 and ownJournal and PB.closeEndShort then
                -- (lane C8: next to nothing shared, a first meeting at the end of a night: where your own
                -- book says the night ended, and how much later)
                local ownEnd, town = e0, nil
                for _, x in ipairs(ownJournal) do
                    if x.k == "play" and x.t and x.t >= t0 - 6 * 3600 and x.t <= e0 + 6 * 3600 and (x.e or x.t) > ownEnd then ownEnd = x.e or x.t end
                end
                for _, x in ipairs(ownJournal) do
                    if x.k == "town" and x.d and x.t and x.t >= e0 and x.t <= ownEnd then town = x.d end
                end
                if not town then
                    for _, x in ipairs(ownJournal) do
                        if x.k == "play" and x.z and x.t and x.t <= ownEnd and (x.e or x.t) >= e0 then town = x.z end
                    end
                end
                if town and ownEnd - e0 >= 10 * 60 then
                    tokens.part, tokens.place = PartOf(Hour(e0)), A.JournalPlain(Place(town))
                    tokens.span = About(ownEnd - e0)
                    tokens.Span = Cap(tokens.span)
                    endLine = teller:Say("closeEndShort", PB.closeEndShort, rng, tokens)
                end
            end
            -- (a closing sentence said word for word in an earlier chapter is not said again)
            history.closeSaid = history.closeSaid or {}
            local sumText
            if #sum > 0 then
                sumText = sum[1]
                for i = 2, #sum do sumText = sumText .. ", and " .. (sum[i]:gsub("^%u", string.lower)) end
                sumText = sumText:gsub("%.$", "") .. "."
                if history.closeSaid[sumText] then sumText = nil end
            end
            -- (lane C9: another line of the same pool before none at all)
            if endLine and history.closeSaid[endLine] and endKey and PB[endKey] then
                for _, template in ipairs(PB[endKey]) do
                    local alt = teller:Say(endKey, {template}, rng, tokens)
                    if alt and not history.closeSaid[alt] then endLine = alt; break end
                end
            end
            if endLine and history.closeSaid[endLine] then endLine = nil end
            -- (round 11: no fixed closer in a close bond's book; the place and hour only on the first
            -- night, the latest, or when she stopped first; else the chapter ends on its last beat)
            if endLine and T.BondKind(person) == "close" and index ~= 1 and index ~= #days and not (endKey or ""):find("Parted", 1, true)
                and (endKey or ""):find("Same", 1, true) then endLine = nil end
            -- (lane C9 round 10: the book's latest chapter looks back once over the days together, from
            -- the record: how many evenings, since where, and whether every one was spent together)
            local lookBack
            if endLine and index == #days and together and T.BondKind(person) ~= "plain" and history.days >= 2 and history.firstZone then
                local evenings = history.days + 1 - (history.emptyDays or 0)
                tokens.count, tokens.Count = Words(evenings), Cap(Words(evenings))
                tokens.first = A.JournalPlain(Place(history.firstZone))
                local every = gap == 1 and history.streak == history.days
                local key = (T.BondKind(person) == "close" and (every and "lookBackEvery" or "lookBackClose")) or (T.LOOKBACK_FRIEND and "lookBackFriend") or "none"
                lookBack = PB[key] and teller:Say(key, PB[key], rng, tokens)
            end
            if sumText or endLine then
                -- (the hour line of the old teller says the same: it goes)
                for n = #out, 1, -1 do if outBeat[n] == "hour" then table.remove(out, n); table.remove(outBeat, n) end end
                local was = beat
                beat = "close"
                if sumText then Add(sumText); history.closeSaid[sumText] = true end
                if endLine then Add(endLine); history.closeSaid[endLine] = true end
                if lookBack then Add(lookBack) end
                beat = was
            end
        end
        -- The dungeon run as one paragraph (2026-11-11): the run's lines stand together, and the
        -- level that came within three quarters of an hour of its end and the hand-ins about it
        -- follow its last line, in time order. (The planned telling orders by time itself.)
        local runGroups
        do
            for _, d in ipairs(f.dungeons) do
                local last
                for n = 1, #out do if S.R[out[n]] == d then last = n end end
                if last then
                    local lastT = d.t or 0
                    for _, ev in ipairs(d.events) do lastT = math.max(lastT, ev.t or 0) end
                    local pulled, dropAfters = {}, false
                    for n = last + 1, #out do
                        local line = out[n]
                        local t = outT[line]
                        local q = S.Q[line]
                        if not S.R[line] and t and t >= lastT and t - lastT <= 45 * 60
                            and (S.LV[line] or (q and S.RQ[q] == d)) then
                            local bare = q and (line:find(" saw {q:", 1, true) or line:find(" finished {q:", 1, true) or line:find(" completed {q:", 1, true))
                            S.R[line] = d
                            pulled[#pulled + 1] = {n = n, t = t, rank = S.LV[line] and 1 or 2, bare = bare and true or nil}
                            if q and S.RQL[q] then dropAfters = true end
                        end
                    end
                    if #pulled > 0 then
                        -- (the level first, then the hand-ins in time order: what came of it closes the run)
                        table.sort(pulled, function(a, b)
                            if a.rank ~= b.rank then return a.rank < b.rank end
                            if a.t ~= b.t then return a.t < b.t end
                            return a.n < b.n
                        end)
                        local taken = {}
                        for _, p in ipairs(pulled) do taken[p.n] = true end
                        -- (the hand-in says what the lord's fall meant: the lore's line for it goes)
                        local afters = {}
                        if dropAfters then
                            for _, ev in ipairs(d.events) do
                                local lo = ev.k == "boss" and ev.d and L.Boss and L.Boss(ev.d)
                                if lo and lo.after then afters[lo.after] = true; for _, more in ipairs(lo.afterMore or {}) do afters[more] = true end end
                            end
                        end
                        -- (the planned telling keeps its own time order: only the lore's line goes)
                        -- (the level folded into the hand-in's one sentence, "..., and level 17 came with
                        -- it": never a tally of its own after the outcome, 2026-11-11 round 2)
                        local levelAt, questAt
                        for _, p in ipairs(pulled) do
                            if p.rank == 1 and not levelAt then levelAt = p
                            elseif p.rank == 2 and not questAt and S.Q[out[p.n]] and S.RQ[S.Q[out[p.n]]] == d then questAt = p end
                        end
                        if levelAt and questAt and not S.planned then
                            local q = out[questAt.n]
                            local n = 0
                            for _ in q:gsub("{%a:", ""):gmatch("%S+") do n = n + 1 end
                            local mine, theirs = f.myLevel and f.myLevel > 0 and f.myLevel or nil, f.levels[#f.levels]
                            local levelN = mine or theirs
                            local head, lastS = q:match("^(.*%. )(.-)$")
                            if not lastS then head, lastS = "", q end
                            local m = 0
                            for _ in lastS:gsub("{%a:", ""):gmatch("%S+") do m = m + 1 end
                            local clauses = select(2, lastS:gsub(", and ", ""))
                            if levelN and m <= 30 and clauses <= 1 and lastS:sub(-1) == "." and PB.runLevelClause then
                                -- (both only when both levels came out of the run together; theirs a while later is said so, lane C8)
                                local apart = f.myLevelT and f.levelT and math.abs(f.myLevelT - f.levelT) > 5 * 60
                                local pool = (mine and theirs and theirs == mine and not apart and PB.runLevelClause.both)
                                    or (mine and theirs and theirs == mine and apart and PB.runLevelClause.bothLater)
                                    or (mine and PB.runLevelClause.mine) or PB.runLevelClause.theirs
                                tokens.mine, tokens.theirs = mine or levelN, theirs or levelN
                                local clause = pool and teller:Say("runLevelClause", pool, rng, tokens)
                                if clause then
                                    clause = clause:gsub("%.$", "")
                                    if not clause:find("^{n:") and not clause:match("^I ") then clause = clause:gsub("^%u", string.lower) end
                                    out[questAt.n] = S.Carry(q, head .. lastS:sub(1, -2) .. ", and " .. clause .. ".")
                                    taken[levelAt.n] = "folded"
                                end
                            end
                        end
                        -- (what the lord's fall meant closes the run, after the hand-in's reward)
                        local lastAfters = {}
                        local newOut, newBeat = {}, {}
                        for n = 1, #out do
                            local isAfter = S.R[out[n]] == d and (afters[out[n]] or (not S.planned and questAt and (function()
                                for _, ev in ipairs(d.events) do
                                    local lo = ev.k == "boss" and ev.d and L.Boss and L.Boss(ev.d)
                                    if lo and lo.after and (out[n] == lo.after) then return true end
                                    for _, more in ipairs(lo and lo.afterMore or {}) do if out[n] == more then return true end end
                                end
                                return false
                            end)()))
                            if isAfter and not afters[out[n]] then lastAfters[#lastAfters + 1] = n
                            elseif not (S.planned or taken[n]) and not (S.R[out[n]] == d and afters[out[n]]) then
                                newOut[#newOut + 1], newBeat[#newOut + 1] = out[n], outBeat[n]
                            elseif S.planned and not (S.R[out[n]] == d and afters[out[n]]) then
                                newOut[#newOut + 1], newBeat[#newOut + 1] = out[n], outBeat[n]
                            end
                            if n == last and not S.planned then
                                for _, p in ipairs(pulled) do
                                    if taken[p.n] ~= "folded" and not p.bare then newOut[#newOut + 1], newBeat[#newOut + 1] = out[p.n], outBeat[p.n] end
                                end
                                for _, m in ipairs(lastAfters) do newOut[#newOut + 1], newBeat[#newOut + 1] = out[m], outBeat[m] end
                            end
                        end
                        for n = 1, #out do out[n], outBeat[n] = newOut[n], newBeat[n] end
                    end
                    if not S.planned then
                        runGroups = runGroups or {}
                        for n = 1, #out do if S.R[out[n]] == d then runGroups[n] = d end end
                    end
                end
            end
        end
        -- (round 26: every told line at its record minute; an inversion the passes left is moved back)
        if not S.planned and S.bonded and T.ORDER_VERIFY then
            T.SortByRecord(out, outBeat, outT, S)
            T.PlaceFalls(out, outBeat, S)
            T.WipeOthers(out, outBeat, S, ownJournal, person, teller)
            T.TrimToldClauses(out, outBeat, S)
            -- (round 30: a hand-in in the companion's own record too is ours: "I gave the offering stone the
            -- blood" becomes "We gave ...")
            if teller.base.I == "I" and type(person.journal) == "table" then
                for n, line in ipairs(out) do
                    local q = S.Q and S.Q[line]
                    if q and q.qid and line:find("^I %l+ ") and not line:find(" my ", 1, true) then
                        local hers = false
                        for _, y in ipairs(person.journal) do if y.k == "quest" and tonumber(y.qid) == tonumber(q.qid) then hers = true end end
                        if hers then out[n] = S.Carry(line, "We " .. line:sub(3)) end
                    end
                end
            end
            -- (round 28: never two lines in a row opening on "Dahlia and I")
            local pairCap = Cap(teller.base.pairNamed or "")
            for n = 2, #out do
                if pairCap ~= "" and out[n]:sub(1, #pairCap + 1) == pairCap .. " " and out[n - 1]:sub(1, #pairCap + 1) == pairCap .. " " then
                    out[n] = S.Carry(out[n], (teller.base.I == "I" and "We" or "You") .. out[n]:sub(#pairCap + 1))
                end
            end
            if runGroups then
                runGroups = {}
                for n = 1, #out do if S.R[out[n]] then runGroups[n] = S.R[out[n]] end end
            end
        end
        if not S.planned and S.Day then runGroups = T.ComposeParagraphs(out, outBeat, S, runGroups) or runGroups end
        if T.DebugLines then T.DebugLines(day, out, outBeat, outT, S, runGroups) end
        -- (lane C9: a land the chapter never names is no title for it, "Tirisfal Glades, Fourth Day"
        -- over a chapter all in Silverpine; and a day with no main land still has one: the first
        -- place the chapter names)
        if not title and not S.planned then
            local key = mainZone and Clean(mainZone):gsub("^[Tt]he ", ""):match("^(%S+)")
            local told = false
            for i, line in ipairs(out) do if key and outBeat[i] ~= "close" and line:find("{p:[^}]*" .. key) then told = true end end
            if not told then
                for _, line in ipairs(out) do
                    local p = line:match("{p:[^}]+}")
                    if p then chapterTitle = (p:gsub("{p:the ", "{p:The "):gsub("^{p:(%l)", function(x) return "{p:" .. x:upper() end)); break end
                end
            end
        end
        -- (round 10: a bonded book's title is the two's adventure, never a death or a rest stop: "Riptear"
        -- told only as the beast that killed you, "By the Fire" -> the run, else the first land named)
        if not S.planned and T.BondKind(person) ~= "plain" and chapterTitle then
            local plainT = A.JournalPlain(chapterTitle)
            local key = tostring(titleKey or "")
            local weak = key:find("fire", 1, true) or key:find("rest", 1, true) or key:find("death", 1, true) or key:find("camp", 1, true)
            if not weak then
                local inDeath, elsewhere = false, false
                for i, line in ipairs(out) do
                    if A.JournalPlain(line):find(plainT, 1, true) then if outBeat[i] == "death" then inDeath = true else elsewhere = true end end
                end
                weak = inDeath and not elsewhere
            end
            if weak then
                history.titlesUsed = history.titlesUsed or {}
                local run = f.dungeons and f.dungeons[1]
                local new = run and run.name and Place(run.name)
                if not new then
                    -- (a place of the work or the road first, one no earlier chapter is titled by)
                    for pass = 1, 2 do
                        for i, line in ipairs(out) do
                            local b = outBeat[i]
                            local fits = (pass == 1 and (b == "questKey" or b == "quests" or b == "dungeon" or b == "road") and not (S.NoLead and S.NoLead[line]))
                                or (pass == 2 and (b == "open" or b == "day" or b == "land" or b == "landKey"))
                            if fits and not new then
                                for at, p in line:gmatch("()({p:[^}]+})") do
                                    if line:sub(math.max(1, at - 4), at - 1):lower() == "the " then p = "the " .. p end
                                    if not new and not history.titlesUsed[A.JournalPlain(p):gsub("^[Tt]he ", "The ")] and not history.titlesUsed[A.JournalPlain(p)] then new = p end
                                end
                            end
                        end
                    end
                end
                -- (nothing new to name it by: the land it opened in, again)
                if not new and mainZone then new = Place(mainZone) .. ", Again" end
                if new then chapterTitle = (new:gsub("^the ", "The "):gsub("{p:the ", "{p:The ")) end
            end
        end
        if chapterTitle then history.titlesUsed = history.titlesUsed or {}; history.titlesUsed[A.JournalPlain(chapterTitle)] = true end
        local chapterText = S.planned and T.PlanText(out, outBeat, outT, S.Z, Place, S) or T.Paragraphs(out, outBeat, runGroups)
        if A.JournalAgree then chapterText = A.JournalAgree(chapterText) end
        -- (round 12: a first meeting with nothing done is no chapter of its own in a bonded book; the
        -- next chapter, the very next day, opens on it: "Marrow and I had first met the night before")
        if not S.planned and not brief and T.BondKind(person) ~= "plain" and together and (history.days or 0) == 0 and days[index + 1]
            and not startedTogether and not history.startedTogether and person.origin ~= "together"
            and DayNumber(days[index + 1].t) - today == 1 and PB.metBefore then
            local did = false
            for i = 1, #out do if WORK_BEATS[outBeat[i] or ""] or S.R[out[i]] then did = true end end
            if not did then
                local h = Hour((day.scenes[1] and day.scenes[1].t) or day.t)
                history.metBefore = {place = mainZone and A.JournalPlain(Place(mainZone)), clock = (h < 5 and "past midnight") or (h >= 21 and "late in the evening") or ""}
                history.emptyDays = (history.emptyDays or 0) + 1
                chapterText, chapter = "", chapter - 1
                -- (who was introduced in the chapter that is not told is introduced again in the next)
                history.othersSaid = {}
            end
        elseif history.metBefore and chapterText ~= "" then
            tokens.place, tokens.clock = history.metBefore.place or "the wilds", history.metBefore.clock
            local met = teller:Say("metBefore", (teller.base.bondWord and PB.metBeforeBond) or PB.metBefore, rng, tokens)
            if met then
                local rest = chapterText:gsub("^The very next day, ", ""):gsub("^The next day, ", ""):gsub("^A day later, ", "")
                    :gsub(" went out a second time", " went out together", 1)
                    :gsub("^" .. Esc(teller.base.name) .. " and I went out together", "This time we went out together", 1)
                chapterText = met .. " " .. Cap(rest)
            end
            history.metBefore = nil
        end
        stories[day.key] = {text = OneStop(chapterText), quotes = f.quotes, chapter = chapter, two = tellsTwo or nil, title = chapterTitle}
        -- (round 23: the quests this chapter told, for the two-pass telling's first pass)
        if T.collect then
            local told = {}
            for _, line in ipairs(out) do local q = S.Q and S.Q[line]; if q then told[#told + 1] = q end end
            T.collect[day.key] = told
        end

        -- remember the last three kinds of title.
        if title then
            local k = titleKey or (mainZone and ("zone:" .. mainZone)) or title
            history.titleKeys = {k, (history.titleKeys or {})[1], (history.titleKeys or {})[2]}
        end
        -- The day joins the history.
        if together then
            if history.lastDay and today > history.lastDay then history.gaps[#history.gaps + 1] = today - history.lastDay end
            if history.lastDay ~= today then
                history.streak = (history.lastDay and today - history.lastDay == 1) and (history.streak + 1) or 1
                history.days = history.days + 1
            end
            history.lastDay = today
            history.firstDay = history.firstDay or today
            history.firstZone = history.firstZone or mainZone
            history.hours = history.hours + f.together / 3600
            -- (what the next opening after a gap may recall: the place, the levels, a dungeon, a lord)
            history.lastMain = mainZone or history.lastMain
            history.lastTheirLevel = theirLevel or history.lastTheirLevel
            history.lastMyLevel = level or history.lastMyLevel
            history.lastDungeonName, history.lastLord = nil, nil
            for _, d in ipairs(f.dungeons) do
                history.lastDungeonName = d.name
                for _, ev in ipairs(d.events) do
                    local lore = ev.k == "boss" and L.Boss and L.Boss(ev.d)
                    if lore and lore.last then history.lastLord = ev.d end
                end
            end
        elseif f.met or f.added then
            history.firstDay = history.firstDay or today
            history.firstZone = history.firstZone or mainZone
        end
        if f.seen and not together then
            history.seenDays = history.seenDays + 1
            history.lastSeen = today
            history.firstSeen = history.firstSeen or today
        end
        for _, zone in ipairs(f.zones) do history.zones[zone] = true end
        for _, quest in ipairs(f.quests) do
            local story = A.Lore and A.Lore.QuestStory and A.Lore.QuestStory(quest.title, quest.qid)
            if story and story.thread then history.questThreads[story.thread] = {title = quest.title, t = quest.t} end
        end
        for _, zone in ipairs(f.fires) do
            if zone and not history.memories[zone] then history.memories[zone] = {kind = "fire", day = today, t = f.fireT or day.t, place = zone} end
        end
        if together then
            for _, e in ipairs(sceneMoments) do
                local region = momentRegions[e]
                if region and not history.memories[region] and e.k == "first" and (e.d == "sunset" or e.d == "landmark") and e.z then
                    history.memories[region] = {kind = e.d, day = today, t = e.t, place = e.z}
                end
            end
        end
        if together then
            for _, zone in ipairs(f.zones) do history.zoneLastT[zone] = day.t end
            history.firstFire = history.firstFire or f.fires[1]
            history.firstTheirLevel = history.firstTheirLevel or theirLevel
        end
        if together and mainZone then
            local key = Clean(L.Display and L.Display(mainZone) or mainZone):gsub("^[Tt]he ", ""):match("^(%S+)")
            if brief or (key and teller.saidPlaces[key]) or history.merged then -- only a zone the chapter named
                history.lastZone = mainZone; history.zoneRunN = zoneRun
            else
                history.lastZone, history.zoneRunN = nil, nil
            end
        end
        for _, d in ipairs(f.dungeons) do if not history.firstDungeonName then history.firstDungeonName = d.name end end
        for _, d in ipairs(f.dungeons) do
            history.dungeons[d.name] = (history.dungeons[d.name] or 0) + 1
            if d.reached then history.lordDone[d.name] = true end
            history.unfinishedLast[d.name] = d.unfinished or nil
            for _, ev in ipairs(d.events) do
                if ev.k == "boss" then history.bosses[ev.d] = true; history.beaten[ev.d] = nil end
                if ev.k == "death" and ev.e then history.diedIn[d.name] = ev.e.w == "you" and "you" or "them" end
            end
        end
        -- A fight lost and not won back the same day: owed for next time.
        for boss in pairs(history.beatenPending or {}) do history.beaten[boss] = true end
        history.beatenPending = nil
        history.dungeonRuns = history.dungeonRuns + #f.dungeons
        history.fires = history.fires + #f.fires
        history.rests = history.rests + #f.rests
        history.rez = history.rez + f.rez
        history.deaths = history.deaths + #f.deaths
        for _, d in ipairs(f.dungeons) do for _, ev in ipairs(d.events) do if ev.k == "death" then history.deaths = history.deaths + 1 end end end
    end
    return stories
end

-- You: race and faction (for homecomings and the odd blessing).
function T.Player()
    local out = {}
    if UnitRace then
        local ok, _, race = pcall(UnitRace, "player")
        if ok and type(race) == "string" then out.race = race end
    end
    if UnitFactionGroup then
        local ok, faction = pcall(UnitFactionGroup, "player")
        if ok and type(faction) == "string" then out.faction = faction end
    end
    if UnitName then
        local ok, name = pcall(UnitName, "player")
        if ok and type(name) == "string" and (not issecretvalue or not issecretvalue(name)) then out.name = name end
    end
    if UnitClass then
        local ok, _, class = pcall(UnitClass, "player")
        if ok and type(class) == "string" then out.class = class end
    end
    return out
end
T.Roman = Roman
