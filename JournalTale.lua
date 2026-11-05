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
-- "The dunes of Tanaris were", "the green hell of Stranglethorn was".
-- Names that are plural too: "the Wailing Caverns were", "Blackfathom Deeps were".
local PLURAL_NAMES = {Caverns = true, Deeps = true, Downs = true, Deadmines = true, Barrens = true, Wetlands = true,
    Badlands = true, Hinterlands = true, Steppes = true, Plaguelands = true, Lands = true}
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
    friend = {they = "oldest friend", he = "oldest friend", she = "oldest friend"},
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
            text = text:gsub(" around {p:([^}]+)}", function(place)
                local k = place:gsub("^[Tt]he ", ""):match("^(%S+)")
                if self.saidPlaces[k] then return "" end
            end)
            text = text:gsub("(%a*) in {p:([^}]+)}", function(before, place)
                local k = place:gsub("^[Tt]he ", ""):match("^(%S+)")
                if not self.saidPlaces[k] then return nil end
                if before == "was" or before == "were" then return before .. " there" end
                return before
            end)
        end
        text = text:gsub(",,", ","):gsub(" ,", ",")
        -- places are marked as said when the line is written (Add).
        text = Cap(text):gsub("([%.!%?]%s+)(%l)", function(stop, letter) return stop .. letter:upper() end)
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

-- One day's facts.
local function DayFacts(day)
    local f = {zones = {}, zoneTime = {}, together = 0, outings = 0, quests = {}, dungeons = {}, byDungeon = {},
        deaths = {}, wipes = {}, rez = 0, levels = {}, fires = {}, rests = {}, seen = nil, met = nil, added = false,
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
                f.quests[#f.quests + 1] = {title = entry.d, qid = entry.qid, level = entry.ql, kind = entry.qt, pl = entry.pl, t = entry.t or 0, scene = scene}
            elseif k == "dungeon" then
                local name = entry.d or entry.z
                if name then
                    local d = Dungeon(name, entry.t, entry.pl)
                    d.r, d.tr = d.r or entry.r, d.tr or entry.tr
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
                f.rez = f.rez + 1
            elseif k == "level" then
                f.levels[#f.levels + 1] = tonumber(entry.d)
                f.levelT = entry.t
            elseif k == "mylevel" then
                f.myLevel = math.max(f.myLevel or 0, tonumber(entry.d) or 0)
            elseif k == "campfire" then
                f.fires[#f.fires + 1] = entry.z
                f.restT = f.restT or entry.t
                f.fireT = f.fireT or entry.t
            elseif k == "rest" then
                f.rests[#f.rests + 1] = entry.d or entry.z
                f.restT = f.restT or entry.t
            end
        end
        if scene.kind == "level" and #scene.entries == 0 then
            for _, level in ipairs(scene.levels) do f.levels[#f.levels + 1] = tonumber(level) end
        end
        if scene.kind == "campfire" and #scene.entries == 0 then f.fires[#f.fires + 1] = scene.zone end
    end
    for _, d in ipairs(f.dungeons) do table.sort(d.events, function(a, b) return a.t < b.t end) end
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

-- A chapter has scenes, not one unbroken roll of sentences. Keep a fight and
-- its immediate rescue together; give the setting and aftermath their own
-- space when there is enough prose to warrant it. This changes no ordering.
function T.Paragraphs(lines, beats)
    local paragraphs, current, words, previous = {}, {}, 0, nil
    local function Phase(beat)
        if beat == "prologue" then return "prologue" end
        if beat == "dungeon" or beat == "kills" or beat == "climax" or beat == "roles" or beat == "death" or beat == "rez" or beat == "deathLore" then return "conflict" end
        if beat == "rest" or beat == "milestone" or beat == "close" or beat == "consequence" then return "aftermath" end
        return "setting"
    end
    local function Flush()
        if #current > 0 then paragraphs[#paragraphs + 1] = table.concat(current, " ") end
        current, words = {}, 0
    end
    for i, line in ipairs(lines) do
        local phase = Phase(beats[i])
        local linked = beats[i] == "questOutcome"
            or ((beats[i] == "rez" or beats[i] == "deathLore" or beats[i] == "consequence") and previous == "conflict")
        if #current > 0 and not linked and ((phase ~= previous and (words >= 34 or previous == "prologue"))
            or beats[i] == "questTurn" or (beats[i] == "questStart" and words >= 45) or words >= 95) then Flush() end
        current[#current + 1] = line
        for _ in line:gsub("{%a:", ""):gmatch("%S+") do words = words + 1 end
        previous = phase
    end
    Flush()
    return table.concat(paragraphs, "\n\n")
end

-- The book ---------------------------------------------------------------------------------
-- brief: Highlights in Story mode (the notable beats only).
function T.Tell(person, days, voice, player, brief)
    player = player or T.Player()
    local teller = Teller(person, voice, player)
    local L = A.Lore or {}
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
        seenDays = 0, lastSeen = nil, firstSeen = nil, months = {}, zoneLastT = {}, diedIn = {}, questLore = {}, questThreads = {}, questSetups = {}}
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
        local f = DayFacts(day)
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
        local firstRanks = {notable = 8, rezother = 7, landmark = 6, sunset = 6, snow = 5, rarebeast = 5, foeseen = 5}
        local companionShort = Clean(person.name or ""):gsub("%-.*$", "")
        local exploreRanked = false
        for i, e in ipairs(moments) do
            local rank = e.k == "first" and firstRanks[e.d] or ({voyage = 5, close = 4, swim = 3, nightflight = 3, gather = 1})[e.k]
            -- (more moments: a duel with this very companion ranks with a rescue)
            if e.k == "duel" and e.d then rank = Clean(e.d) == companionShort and 7 or 3
            elseif e.k == "rarekill" then rank = 6
            elseif e.k == "rep" then rank = (tonumber(e.s) or 0) >= 6 and 4 or 2
            elseif e.k == "explore" and not exploreRanked then exploreRanked = true; rank = 2
            elseif e.k == "read" then rank = 2 end
            if rank then candidates[#candidates + 1] = {entry = e, rank = rank, ordinal = i} end
        end
        table.sort(candidates, function(a, b)
            if a.rank ~= b.rank then return a.rank > b.rank end
            return a.ordinal < b.ordinal
        end)
        local selected, gatherChosen = {}, false
        for _, candidate in ipairs(candidates) do
            if #selected >= sceneLimit then break end
            if candidate.entry.k ~= "gather" or not gatherChosen then
                selected[#selected + 1] = candidate
                if candidate.entry.k == "gather" then gatherChosen = true end
            end
        end
        table.sort(selected, function(a, b) return a.ordinal < b.ordinal end)
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
        local function Add(text)
            if not text then return end
            if brief and (not KEEP[beat] and not (beat == "land" and discovery)
                or (beat == "open" and not majorOpen and not formative)) then
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
            -- Named once it is written (a line the short telling drops names nobody).
            local bondWord = teller.base.bondWord
            if text:find(teller.base.name, 1, true) or (bondWord and text:lower():find(bondWord, 1, true)) then teller.named = true end
        end
        local today = DayNumber(day.t)
        local together = Together(f)
        local gap = history.lastDay and (today - history.lastDay) or nil
        local cadence, usual = Cadence(history.gaps)
        local level = f.plEnd or f.plStart
        local theirLevel = f.ol or f.levels[#f.levels]
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
        for _, zone in ipairs(f.zones) do if not mainZone or f.zoneTime[zone] > f.zoneTime[mainZone] then mainZone = zone end end
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

        -- 1. How the day opens.
        if not gap and history.firstDay then tokens.later = Later(today - history.firstDay, rng) end
        if startedTogether and index == 1 then
            majorOpen = true
            local originLine = teller:Say("origin" .. (startKey or "other"), PB.origin[startKey or ""] or PB.origin.other, rng, tokens)
            local at = originLine and originLine:find(teller.base.name, 1, true)
            if at and teller.base.bondWord then
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
                Add(teller:Say("meetGroup", PB.meetGroup, rng, tokens))
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
            local interval = teller:Say("recordedInterval", intervalPool, rng, tokens)
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
            elseif not (sceneLed and placeCanLead and history.intervalOpen == index - 1) then
                if interval and tokens.zoneD and interval:find(tokens.zoneD, 1, true) then placeSaid = true end
                Add(interval)
                history.intervalOpen = index
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
                if sight then Add(sight[rng(#sight)]); f.zoneLore = (f.zoneLore or 0) + 1 end
                if stakes and rng() < 0.6 then Add(stakes[rng(#stakes)]); f.zoneLore = (f.zoneLore or 0) + 1 end
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
                    Add(pool[rng(#pool)])
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
            tokens.memoryPlace = memory.place and Place(memory.place) or tokens.zoneD
            beat = "landKey"
            Add(teller:Say("sceneMemory" .. memory.kind, PB.sceneMemory[memory.kind], rng, tokens))
            history.memorySaid = index
            beat = "travel"
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
                if ql and pl and ql - pl >= 4 and not history.hardSaid then notableQuest, notableKind = quest, "hard"
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
                    if story and story.after and #story.after > 0 and importance > best and not history.questLore[quest.qid or quest.title] then
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
            elseif n > 0 and not notableQuest and PB.dayWork then
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
                    if not ((teller.named or implicit) and line:find("{name}", 1, true)) and not (#out > 0 and line:find("{weekday}", 1, true)) then
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
                if kind ~= "city" and #f.quests >= 2 and #f.quests <= 5 and PB.travelWork and rng() < 0.45 then
                    -- The road and the work in one breath.
                    Add(teller:Say("travelWork", PB.travelWork, rng, tokens))
                    history.workSaid = index
                else
                    Add(teller:Say(kind == "city" and "city" or "travel", kind == "city" and PB.city or PB.travel, rng, tokens))
                end
            end
        end

        -- the level beat as a function too.
        local levelDone = false
        local function LevelBeat()
        -- 4. Levels.
        beat = "level"
        local ding = f.levels[#f.levels]
        -- Yours: recorded (a level-up while you travelled together), else read from
        -- the levels your entries carry (older journals).
        local recorded = f.myLevel and f.myLevel > 0 and f.myLevel or nil
        local mine = recorded or (f.plStart and f.plEnd and f.plEnd > f.plStart and f.plEnd) or nil
        tokens.theirs, tokens.mine = ding or theirLevel, mine or level
        -- (sixty is never dropped for room)
        if ding == 60 or mine == 60 then beat = "levelMark" end
        if ding and mine and (recorded or rng() < 0.7) then
            if ding == mine and PB.bothSame then Add(teller:Say("bothSame", PB.bothSame, rng, tokens))
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
                else
                    Add(teller:Say("theyLevel", PB.theyLevel, rng, tokens))
                end
            end
            if mine and history.myLevelTold and mine <= history.myLevelTold then mine = nil end -- (a level told already is no news)
            if mine and (mine == 60 or rng() < (recorded and 0.75 or 0.4)) then Add(teller:Say("myLevel", PB.myLevel, rng, tokens)); history.myLevelTold = mine end
        end

        end
        -- the rest beat as a function, told where it happened.
        local restDone = false
        local function RestBeat()
        local beforeRest = #out
        -- 6. Rest: a fire, an inn, a city.
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
        end
        -- 3. Dungeons, with what happened inside, in order. A long day of work
        -- before them is told first.
        if prelude then
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
        local function Flush(required)
            if #pending == 0 then return end
            local was = beat
            beat = required and "climax" or "kills"
            local names = {}
            for _, boss in ipairs(pending) do names[#names + 1] = Place(boss) end
            tokens.bosses = List(names)
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
            pending = {}
            beat = was
        end
        -- Who brought you back (said right after your death in a dungeon, else with the deaths).
        local rezSaid = false
        local function RezLine()
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
                    Add(teller:Say("preludeOne", PB.preludeOne, rng, tokens))
                    table.remove(f.quests, firstBefore[1])
                end
            end
        end
        local routeSaid = false
        for di, d in ipairs(f.dungeons) do
            local beforeDungeon = #out
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
                -- a visit with nothing in it gets one plain clause.
                Add(teller:Say("dungeonBrief", PB.dungeonBrief, rng, tokens))
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
            elseif visits >= 2 and PB.dungeonRegular and rng() < 0.4 then
                tokens.nth = Ordinal(visits + 1)
                Add(teller:Say("dungeonRegular", PB.dungeonRegular, rng, tokens))
            elseif visits > 0 and danger ~= "revisit" and rng() < 0.6 then
                tokens.nth = Ordinal(visits + 1)
                Add(teller:Say("dungeonAgain", PB.dungeonAgain, rng, tokens))
            else
                Add(teller:Say("dungeon" .. danger, PB.dungeon[danger], rng, tokens))
            end
            -- ("down into" only where it is under the ground: a spire is climbed, a city walked into)
            local under = A.SelfTale and A.SelfTale.Underground
            if under and not under[name] then
                for n2 = goingIn + 1, #out do out[n2] = out[n2]:gsub(" down into ", " into ") end
            end
            if whyLine then Add(whyLine) end
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
            local questConflicts = multiQuestPlan and #d.events > 0
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
                    local epithet = lo.e and not history.bosses[kills[lordAt]] and Fresh(lo.e) and lo.e
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
                if ev.k == "boss" then
                    local lore = L.Boss and L.Boss(ev.d)
                    local kind = lore and lore.kind or "humanoid"
                    local named = d.lostThenWon == ev.d or history.beaten[ev.d] or ev.cost or ev.d == lastBoss
                    if named then Flush() end
                    tokens.boss, tokens.short = Place(ev.d), Short(ev.d)
                    tokens.bossE = (lore and lore.e and not history.bosses[ev.d] and Fresh(lore.e)) and lore.e or false
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
                    elseif ev.cost and d.costTold and d.costTold[ev.d] then
                        Flush()
                        -- (told with the death it cost)
                    elseif ev.cost then
                        Flush()
                        Add(teller:Say("killCostly", PB.killCostly, rng, tokens))
                        if lore and lore.last then BossTitle(80, ev.d) end
                    elseif ev.d == lastBoss and d.afterDeath and #pending > 0 and PB.killRollAfter and not history.bosses[ev.d] then
                        -- "After that, you killed Lord Pythas, and last of all Mutanus the Devourer."
                        local names = {}
                        for _, boss in ipairs(pending) do names[#names + 1] = Place(boss) end
                        pending = {}
                        local ep = lore and lore.e and Fresh(lore.e) and lore.e
                        tokens.roll = List(names) .. ", and last of all " .. Place(ev.d) .. (ep and (", " .. ep) or "")
                        beat = "climax"
                        Add(teller:Say("killRollAfter", PB.killRollAfter, rng, tokens))
                        if climax then mood.triumph = true; blessOccasion = true end
                        if climax and lore and lore.after then Add(After(lore)); flourish = flourish + 1 end
                        BossTitle(80, ev.d)
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
                    Flush()
                    local e = ev.e
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
                        if f.rez > 0 and not rezSaid then RezLine() end
                        beat = savedBeat
                    elseif e.w == "you" then
                        d.afterDeath = true
                        local foe = e.boss or e.d
                        tokens.killer, tokens.killerShort = foe and Place(foe) or "something in the dark", foe and Short(foe) or "it"
                        local avenged = foe and killedAt[foe] and killedAt[foe] > ev.t
                        if e.env and PB.dieEnv[e.env] then
                            -- (no "the water had looked harmless" in a dungeon's black water)
                            local envPool = {}
                            for _, l in ipairs(PB.dieEnv[e.env]) do if not l:find("harmless", 1, true) then envPool[#envPool + 1] = l end end
                            Add(teller:Say("die" .. e.env, #envPool > 0 and envPool or PB.dieEnv[e.env], rng, tokens))
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
                        if f.rez > 0 and not rezSaid then RezLine() end
                        beat = savedBeat
                    else
                        d.afterDeath = true
                        if e.boss and killedAt[e.boss] and killedAt[e.boss] > ev.t and PB.theyDieBossCostly then
                            tokens.boss, tokens.short = Place(e.boss), Short(e.boss)
                            Add(teller:Say("theyDieBossCostly", PB.theyDieBossCostly, rng, tokens))
                            d.costTold = d.costTold or {}
                            d.costTold[e.boss] = true
                        elseif e.boss then tokens.boss = Place(e.boss); Add(teller:Say("theyDieBoss", PB.theyDieBoss, rng, tokens))
                        else Add(teller:Say("theyDie", PB.theyDie, rng, tokens)) end
                        d.theyDied = true
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
                if questConflicts and (ev.k ~= "boss" or TurnInBefore(evIndex)) then
                    Flush(true)
                    if #out > eventStart then temporalAnchors[#temporalAnchors + 1] = {
                        first = eventStart + 1, last = #out, t = ev.t or 0} end
                end
            end
            end -- (not told as one sentence)
            Flush()
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
                Add(line)
                if questConflicts and last and aftersNow[last] and #out >= 2 then
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
                if pair and rng() < 0.6 then
                    local was = beat
                    beat = "roles" -- (its own beat: a role line never takes the day's level)
                    local line = teller:Say("roles", pair, rng, tokens)
                    AddBeforeConsequence(line)
                    if line and teller.sayLine then history.roleLines[teller.sayLine] = true end
                    beat = was
                end
                if not history.boastDay or history.boastDay ~= index then
                    local lastKill
                    for _, ev in ipairs(d.events) do if ev.k == "boss" then lastKill = ev end end
                    for _, ev in ipairs(d.events) do
                        local lord = L.Boss and L.Boss(ev.d) and L.Boss(ev.d).last
                        if ev.k == "boss" and ev == lastKill and (ev.n or 0) >= 3 and rng() < (lord and 0.6 or 0.25) and history.boastDay ~= index then
                            tokens.boss, tokens.weapon = Short(ev.d), L.Weapon and L.Weapon(player.class) or "strikes"
                            tokens.theirWeapon = L.Weapon and L.Weapon(person.class) or "strikes"
                            local you, them = ev.me or {}, ev.them or {}
                            local line
                            if you.d == 1 and (you.ds or 0) >= 30 and mine ~= "healer" then line = teller:Say("boastYouD", PB.boastYou.damage, rng, tokens)
                            elseif them.d == 1 and (them.ds or 0) >= 30 and theirs ~= "healer" then line = teller:Say("boastThemD", PB.boastThem.damage, rng, tokens)
                            elseif mine == "tank" and you.t == 1 then line = teller:Say("boastYouT", PB.boastYou.tank, rng, tokens)
                            elseif theirs == "tank" and them.t == 1 then line = teller:Say("boastThemT", PB.boastThem.tank, rng, tokens) end
                            if line then AddBeforeConsequence(line); history.boastDay = index end
                        end
                    end
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
            if #d.events > 0 then Title(75, ((history.dungeons[name] or 0) > 0 and "Back to " or "Into ") .. Place(name), "dungeon:" .. name) end
            if questConflicts and #out > afterConflicts then temporalAnchors[#temporalAnchors + 1] = {
                first = afterConflicts + 1, last = #out, t = d.events[#d.events].t or 0}
            elseif not questConflicts and #out > beforeDungeon then temporalAnchors[#temporalAnchors + 1] = {
                first = beforeDungeon + 1, last = #out, t = d.t or 0} end
        end
        -- Deaths outside dungeons.
        beat = "death"
        local envSeen = {}
        local pvpSeen, pvpTold = false, 0
        local pvpAll = 0
        local deathAnchors = {}
        for _, e in ipairs(f.deaths) do if e.w == "you" and (e.pr or e.pc) and not e.env then pvpAll = pvpAll + 1 end end
        -- (their deaths with no boss to tell them with: twice or more in a day is one line with the count)
        local theirPlain, theirPlainTold = 0, false
        for _, e in ipairs(f.deaths) do if e.w ~= "you" and not e.boss then theirPlain = theirPlain + 1 end end
        for _, e in ipairs(f.deaths) do
            local beforeDeath = #out
            tokens.place = Place(e.z or mainZone or "the wilds")
            if e.w ~= "you" and not e.boss and theirPlain >= 2 and PB.theyDieTimes then
                if not theirPlainTold then
                    theirPlainTold = true
                    tokens.count = theirPlain == 2 and "twice" or (Words(theirPlain) .. " times")
                    Add(teller:Say("theyDieTimes", PB.theyDieTimes, rng, tokens))
                    mood.grim = true
                end
            elseif e.w == "you" then
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
            else
                Add(teller:Say("theyDie", PB.theyDie, rng, tokens))
                mood.grim = true
            end
            if #out > beforeDeath then deathAnchors[#deathAnchors + 1] = {first = beforeDeath + 1, last = #out, t = e.t or 0} end
        end
        if f.rez > 0 and not rezSaid then RezLine() end
        -- what killed you, killed in turn for a quest of its name ("Mor'Ladim", 'WANTED: "Hogger"')
        if PB.questRevenge then
            local avenged
            for _, e in ipairs(f.deaths) do
                if e.w == "you" and e.d and not avenged then
                    for _, quest in ipairs(f.quests) do
                        if Clean(quest.title):find(Clean(e.d), 1, true) and (quest.t or 0) > (e.t or 0) then avenged = e.d end
                    end
                end
            end
            if avenged then
                local was = beat
                beat = "climax"
                tokens.foe = Place(avenged)
                Add(teller:Say("questRevenge", PB.questRevenge, rng, tokens))
                beat = was
                history.avengedQuest = avenged
                mood.triumph = true
            end
        end

        if not levelDone then LevelBeat() end

        -- 5. The work: quests, the hardest one named, the mundane only now and then.
        beat = "questKey"
        if #f.quests > 0 then
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
                    Add(completion)
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
            if tokens.questFolded or multiQuestPlan then notable = true
            elseif hardest and hardestDiff >= 4 and not history.hardSaid then
                -- (once a book: the reader knows this character takes on work above their level)
                tokens.quest = Q(hardest.title)
                Add(teller:Say("questHard", PB.questHard, rng, tokens)); notable = true
                history.hardSaid = index
            elseif elite and #f.dungeons == 0 and (index - (history.eliteSaid or -99)) >= 4 then
                tokens.quest = Q(elite.title)
                Add(teller:Say("questElite", PB.questElite, rng, tokens)); notable = true
                history.eliteSaid = index
            elseif easy >= #f.quests and #f.quests > 1 and rng() < 0.6 then
                Add(teller:Say("questEasy", PB.questEasy, rng, tokens)); notable = true
            end
            tokens.count, tokens.Count = Words(#f.quests), Cap(Words(#f.quests))
            beat = "quests"
            local quiet = #out <= 2
            if history.workSaid == index or history.preludeSaid == index then notable = true end
            if history.preludeSaid == index then
                local lastD = f.dungeons[#f.dungeons] -- only quests after the last dungeon
                local after = 0
                for _, quest in ipairs(f.quests) do if quest.t > (lastD and lastD.t or 0) then after = after + 1 end end
                if after >= 3 and PB.questsMore and rng() < 0.6 then
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
                    Add(teller:Say("questAfterOne", PB.questAfterOne, rng, tokens))
                end
            elseif #f.quests >= 6 and history.workSaid ~= index and (quiet or rng() < 0.6) then
                Add(teller:Say("questsMany", PB.questsMany, rng, tokens))
            elseif #f.quests == 1 and not notable and (quiet or rng() < 0.4) then
                tokens.quest = Q(f.quests[1].title)
                Add(teller:Say("questOne", PB.questOne, rng, tokens))
            elseif #f.quests >= 2 and not notable and (quiet and rng() < 0.7 or rng() < 0.3) then
                Add(teller:Say("questsFew", PB.questsFew, rng, tokens))
            end
        end

        if not restDone and not restFolded then RestBeat() end

        -- A quest named today that has a story (Lore): what came of it, once a companionship.
        local questLoreToday = false
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
                        if setup then passage[#passage + 1] = setup end
                        if anchor or needsName then
                            -- (Highlights: a title-only stage continuing the thread just told keeps its outcome only)
                            local continuing = brief and not quest.qid and qs.thread and previousStory and qs.thread == previousStory.thread
                            if not setup and qs.why and #qs.why > 0 then
                                local why = qs.why[rng(#qs.why)]
                                if not continuing then passage[#passage + 1] = why end
                            end
                            local changedPlace = multiQuestPlan and quest.scene and
                                ((previousScene and quest.scene.zone ~= previousScene.zone)
                                    or (not previousScene and quest.scene.zone ~= mainZone))
                            if needsName or quest.title ~= previousTitle or changedPlace then
                                tokens.quest = Q(quest.title)
                                local completion = teller:Say("questDepth", PB.questDepth, rng, tokens)
                                if changedPlace and quest.scene.zone then
                                    completion = "In " .. Place(quest.scene.zone) .. ", " .. completion:gsub("^%u", string.lower)
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
                            if articled then outcome = Cap(teller.base.we) .. " had come to " .. Place(passage.outcomePlace) .. " by then. " .. outcome
                            else outcome = "In " .. Place(passage.outcomePlace) .. ", " .. outcome end
                        end
                        passage[#passage + 1] = outcome
                        history.questLore[quest.qid or quest.title] = true
                        for pi, line in ipairs(passage) do
                            at = at + 1
                            table.insert(out, at, line)
                            table.insert(outBeat, at, CompactQuest(quest, qs, brief) and CompactBeat(qs, previousStory) or pi == #passage and "questOutcome" or pi == 1 and "questStart" or "questKey")
                            for _, death in ipairs(anchors) do
                                if death.first >= at then death.first = death.first + 1 end
                                if death.last >= at then death.last = death.last + 1 end
                            end
                        end
                        anchor, previousTitle, previousScene, previousStory = at, quest.title, quest.scene, qs
                        questLoreToday = true
                    end
                end
            end
        end

        do
            -- An authored consequence now carries these completions. Remove only
            -- their exact title announcements, retaining the rest of each sentence.
            -- Uncatalogued work keeps its original wording in either edition.
            for _, cut in ipairs(f.questCompletionCuts or {}) do
                if history.questLore[cut.quest.qid or cut.quest.title] and cut.fragment then
                    for n2 = #out, 1, -1 do
                        local at = out[n2]:find(cut.fragment, 1, true)
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
                                out[n2] = before .. (cut.replacement or "") .. after
                                -- A quest title's ! or ? may have supplied the only
                                -- terminator. Its replacement must finish the sentence.
                                if cut.predicate and not out[n2]:find("[.!?]$") then out[n2] = out[n2] .. "." end
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
                local line
                if e.k == "first" and e.d == "notable" and e.n and PB.sharedNotableSeen then
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
                        -- ("you and Dahlia duelled, and Dahlia won" / "Dahlia and I duelled, and I won")
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
                    local names = {}
                    for _, x in ipairs(moments) do if x.k == "explore" and x.d and #names < 3 then names[#names + 1] = Place(x.d) end end
                    tokens.places = List(names)
                    line = teller:Say("sharedExplore", PB.shared.explore, rng, tokens)
                elseif e.k == "read" and e.d and PB.shared.read then
                    tokens.what = Q(e.d)
                    line = teller:Say("sharedRead", PB.shared.read, rng, tokens)
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

        -- Who else was in the party, from your own journal (people of your list).
        if together and ownJournal and PB.alsoThere and not history.othersSaid then history.othersSaid = {} end
        if together and ownJournal and PB.alsoThere then
            local others, seenOther = {}, {}
            for _, scene in ipairs(day.scenes) do
                if scene.kind == "outing" then
                    for _, e in ipairs(ownJournal) do
                        if e.k == "with" and e.n and e.d ~= person.key and Clean(e.n) ~= Clean(person.name or "") and (e.t or 0) < (scene.e or scene.t)
                            and (e.e or e.t or 0) > scene.t and not seenOther[e.n] then
                            seenOther[e.n] = true
                            local info = A.db and A.db.people and A.db.people[e.d]
                            local otherPeople = info and L.People and L.People(info.race)
                            local classWord = info and ClassWord(info.class)
                            local otherWho = (otherPeople and classWord and (otherPeople .. " " .. classWord)) or classWord or otherPeople
                            local short = Clean(e.n):gsub("%-.*$", "")
                            -- (who they are, the first time this book names them)
                            if otherWho and not history.othersSaid[e.n] then others[#others + 1] = "{n:" .. short .. "}, " .. Article(otherWho)
                            else others[#others + 1] = "{n:" .. short .. "}" end
                            history.othersSaid[e.n] = true
                        end
                    end
                end
            end
            if #others > 0 then
                beat = "shared"
                if #others == 1 and others[1]:find(", ", 1, true) then others[1] = others[1] .. "," end
                if #others > 1 then for n2 = 1, #others do others[n2] = others[n2]:gsub(", .*$", "") end end
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
            local countList = (tokens.firstDungeon and PB.dungeonCountBack and PB.dungeonCountBack[runs]) or PB.dungeonCount[runs]
            if #f.dungeons > 0 and countList and trailing == 0 and not streakSaid then Add(teller:Say("runs" .. runs, countList, rng, tokens)); trailing = trailing + 1 end
            if history.firstDay then
                for _, months in ipairs({1, 3, 6, 12}) do
                    if span >= months * 30 - 3 and span <= months * 30 + 6 and not history.months[months] and trailing == 0 and not streakSaid then
                        history.months[months] = true
                        Add(teller:Say("month" .. months, PB.anniversary[months], rng, tokens)); trailing = trailing + 1
                    end
                end
            end
        elseif together and startedTogether and PB.anniversaryOrigin and history.firstDay then
            for _, months in ipairs({1, 3, 6, 12}) do
                if span >= months * 30 - 3 and span <= months * 30 + 6 and not history.months[months] and PB.anniversaryOrigin[months] then
                    history.months[months] = true
                    Add(teller:Say("monthO" .. months, PB.anniversaryOrigin[months], rng, tokens)); trailing = trailing + 1
                end
            end
        elseif f.seen and not together then
            beat = "seen"
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
        end

        -- the tenth, twenty-fifth, fiftieth fire shared.
        if together and #f.fires > 0 and PB.fireCount and trailing == 0 then
            local n = history.fires + #f.fires
            if PB.fireCount[n] then beat = "milestone"; Add(teller:Say("fires" .. n, PB.fireCount[n], rng, tokens)); trailing = trailing + 1 end
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
                    if outBeat[i] == drop then table.remove(out, i); table.remove(outBeat, i) end
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
            if greeting and outBeat[1] == "open" and not out[1]:find("{n:", 1, true) then out[1] = greeting
            elseif greeting then table.insert(out, 1, greeting); table.insert(outBeat, 1, "open") end
            -- ("back to the party. Shael made one more in the party.": the other one just came along)
            if greeting and out[2] and greeting:find("party", 1, true) and out[2]:find("in the party", 1, true) then
                out[2] = out[2]:gsub(" made one more in the party%.$", " came along too."):gsub(" was in the party as well%.$", " came along too.")
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
                        out[k] = a:sub(1, -2) .. ", and " .. ((b:match("^I ") and b) or (b:sub(1, 1):lower() .. b:sub(2)))
                        table.remove(out, k + 1); table.remove(outBeat, k + 1)
                    end
                    -- ("You killed Lord Pythas, and last of all Mutanus the Devourer.")
                    local killer = a:match("^(%a+) killed [^,]+%.$")
                    local last = b and (b:match("^Last of all, %a+ killed ([^,]+)%.$") or b:match("^%a+ killed (.+), last of all%.$"))
                    if killer and last and (killer == "You" or killer == "We" or killer == "I") and Count(a) + Count(b) <= 24 then
                        out[k] = a:sub(1, -2) .. ", and last of all " .. last .. "."
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
                        out[k] = fallen .. " died, but " .. boss .. " went down all the same."
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
                            out[k] = out[k]:sub(1, -2) .. ", and then " .. nextBoss .. "."
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
                            local rest = b:match("^The ") and ("the " .. b:sub(5)) or b
                            out[k] = a:sub(1, -2) .. ", and " .. rest
                            table.remove(out, k + 1); table.remove(outBeat, k + 1)
                        elseif bb == "rest" and ba == "death" and (b:match("^You ") or b:match("^We ") or b:match("^I ")) then
                            out[k] = a:sub(1, -2) .. ", and afterwards " .. b:sub(1, 1):lower() .. b:sub(2)
                            if b:match("^I ") then out[k] = a:sub(1, -2) .. ", and afterwards " .. b end
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
                if ok and sa and sa == sb and (personal[sa] or sa == nameMark) then
                    out[i] = a:sub(1, -2) .. " and " .. b:sub(#sb + 2)
                    table.remove(out, i + 1); table.remove(outBeat, i + 1); joins = joins + 1; i = i + 1
                elseif ok and sa and sb and (personal[sa] or sa == nameMark) and (personal[sb] or sb == nameMark) and sa ~= sb then
                    local rest = (sb == "I" or sb == nameMark) and b or (b:sub(1, 1):lower() .. b:sub(2))
                    out[i] = a:sub(1, -2) .. ", and " .. rest
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
            local routine = not tokens.questFolded
                and not ((#f.fires > 0 and history.fires == 0) or (#f.rests > 0 and history.rests == 0))
            for i = 1, #out do if outBeat[i] ~= "day" and outBeat[i] ~= "open" and outBeat[i] ~= "rest" then routine = false end end
            if routine and not formative and not discovery and not quietDay then
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
                if out[1] then out[1] = Cap((out[1]:gsub("^And so,? ", ""))) end
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
        stories[day.key] = {text = T.Paragraphs(out, outBeat), quotes = f.quotes, chapter = chapter, two = tellsTwo or nil, title = chapterTitle}

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
            local story = L.QuestStory and L.QuestStory(quest.title, quest.qid)
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
