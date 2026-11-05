local _, A = ...
-- Your own journal, told: one chapter a day, in your own words (first person,
-- past tense, plain like the quest texts). The facts come from the book
-- (JournalBook for your own journal: stretches of play with what happened in
-- them); the words from JournalSelfWords.lua; what places are like from Lore.
-- Seeded by the day and your retellings, so a page reads the same until you
-- ask for new words. The short telling (Highlights) keeps the notable beats.
local ST = {}
A.SelfTale = ST

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

local function Hash(text)
    local h = 5381
    for i = 1, #text do h = (h * 33 + text:byte(i)) % 2147483647 end
    return h
end
local function Rng(seed)
    local x = Hash(seed) % 2147483646 + 1
    return function(n)
        x = (x * 16807) % 2147483647
        local r = (x - 1) / 2147483646
        if n then return math.floor(r * n) + 1 end
        return r
    end
end
local NUMBERS = {"one", "two", "three", "four", "five", "six", "seven", "eight", "nine", "ten", "eleven", "twelve", "thirteen",
    "fourteen", "fifteen", "sixteen", "seventeen", "eighteen", "nineteen", "twenty"}
local TENS = {[20] = "twenty", [30] = "thirty", [40] = "forty", [50] = "fifty", [60] = "sixty", [70] = "seventy", [80] = "eighty", [90] = "ninety"}
local function Words(n)
    n = math.floor(tonumber(n) or 0)
    if NUMBERS[n] then return NUMBERS[n] end
    if n < 100 and TENS[n - n % 10] then return TENS[n - n % 10] .. (n % 10 > 0 and ("-" .. NUMBERS[n % 10]) or "") end
    return tostring(n)
end
local function List(items)
    if #items <= 1 then return items[1] or "" end
    return table.concat(items, ", ", 1, #items - 1) .. " and " .. items[#items]
end
-- Capitalize the first letter, markup or not ("{p:the Barrens}" is not the case: the article stays outside).
-- Where each race begins and its capital: the only places "home" (Duskwood is human
-- land, but no human's home).
local START_HOME = {Human = {["Elwynn Forest"] = true, ["Stormwind City"] = true}, Dwarf = {["Dun Morogh"] = true, ["Ironforge"] = true},
    Gnome = {["Dun Morogh"] = true, ["Ironforge"] = true}, NightElf = {["Teldrassil"] = true, ["Darnassus"] = true},
    Orc = {["Durotar"] = true, ["Orgrimmar"] = true}, Troll = {["Durotar"] = true, ["Orgrimmar"] = true},
    Tauren = {["Mulgore"] = true, ["Thunder Bluff"] = true}, Scourge = {["Tirisfal Glades"] = true, ["Undercity"] = true},
    Skyborne = {["Zephras Isle"] = true}}
local function AtHome(race, zone) return zone ~= nil and START_HOME[race or ""] ~= nil and START_HOME[race][zone] == true end
ST.AtHome = AtHome
-- The races whose priests call on the Light.
local LIGHT_RACES = {Human = true, Dwarf = true, Gnome = true}
local function Cap(text)
    if text:match("^{%a:") then return text:sub(1, 3) .. text:sub(4):gsub("^%l", string.upper) end
    return (text:gsub("^%l", string.upper))
end
local function Clean(text) return (tostring(text or ""):gsub("[{}]", "")) end
-- A place's name in a sentence: "the {p:Barrens}", "{p:Durotar}", "the {p:Arathi Highlands}".
local ARTICLE = {["Eastern Kingdoms"] = true, ["Arathi Highlands"] = true, ["Eastern Plaguelands"] = true, ["Western Plaguelands"] = true,
    ["Badlands"] = true, ["Blasted Lands"] = true, ["Burning Steppes"] = true, ["Searing Gorge"] = true, ["Wetlands"] = true,
    ["Redridge Mountains"] = true, ["Stonetalon Mountains"] = true, ["Swamp of Sorrows"] = true, ["Alterac Mountains"] = true,
    ["Hillsbrad Foothills"] = true, ["Undercity"] = true, ["Valley of Trials"] = true, ["Savage Coast"] = true, ["Echo Isles"] = true,
    ["Molten Core"] = true, ["Scarlet Monastery"] = true, ["Wailing Caverns"] = true, ["Bay of Storms"] = true, ["Ruins of Lordaeron"] = true}
local function Place(name)
    name = Clean(name)
    local rest = name:match("^The (.+)$")
    if rest then return "the {p:" .. rest .. "}" end
    if ARTICLE[name] then return "the {p:" .. name .. "}" end
    return "{p:" .. name .. "}"
end
ST.Place = Place
function ST.Article(name) return ARTICLE[name] and true or false end
-- A faction's name in a sentence: "the Argent Dawn", "Orgrimmar", "the Darkspear Trolls".
local FACTION_THE = {"Dawn", "Brotherhood", "Circle", "Cartel", "Tribe", "Brood", "Faire", "Clan", "Guard", "League", "Shen'dralar",
    "Undercity", "Exiles", "Trolls", "Buccaneers", "Trainers", "Waterlords", "Outriders", "Sentinels", "Defilers", "Centaur", "Expedition"}
local function FactionName(name)
    name = Clean(name)
    if name:find("^[Tt]he ") then return "the {p:" .. name:sub(5) .. "}" end
    for _, word in ipairs(FACTION_THE) do
        if name:find("%f[%a]" .. word .. "%f[%A]") then return "the {p:" .. name .. "}" end
    end
    return "{p:" .. name .. "}"
end
ST.FactionName = FactionName
-- What famous things are (after the line that says they were yours).
local ITEM_LORE = {
    ["Benediction"] = {"It was a staff of the Light, and Anathema slept inside it, for the days when the Light was not enough."},
    ["Anathema"] = {"It was a staff of shadow, and Benediction slept inside it, for the days when the dark was not enough."},
    ["Thunderfury, Blessed Blade of the Windseeker"] = {"The wind itself was bound in the blade, and it hummed when I drew it."},
    ["Sulfuras, Hand of Ragnaros"] = {"It had been the Firelord's own hammer, and it was still warm."},
    ["Quel'Serrar"] = {"It was an old blade of the Highborne, and it had been tempered in a dragon's breath."},
    ["Atiesh, Greatstaff of the Guardian"] = {"It had been Medivh's staff, and it was whole again, in my hands."},
    ["Rhok'delar, Longbow of the Ancient Keepers"] = {"The Ancients had given the wood for it, and I had earned it."},
    ["Lok'delar, Stave of the Ancient Keepers"] = {"The Ancients had given the wood for it, and I had earned it."},
}
-- Where a life begins, by race (for the look back at level sixty).
-- Each capital, and the land around it.
local CITY_ZONE = {["Orgrimmar"] = "Durotar", ["Darnassus"] = "Teldrassil", ["Thunder Bluff"] = "Mulgore", ["Ironforge"] = "Dun Morogh",
    ["Stormwind City"] = "Elwynn Forest", ["Undercity"] = "Tirisfal Glades"}
-- Dungeons you go down into.
local UNDERGROUND = {["Ragefire Chasm"] = true, ["Wailing Caverns"] = true, ["The Deadmines"] = true, ["Blackfathom Deeps"] = true,
    ["Gnomeregan"] = true, ["Razorfen Downs"] = true, ["Uldaman"] = true, ["Maraudon"] = true, ["Blackrock Depths"] = true,
    ["Scholomance"] = true, ["Molten Core"] = true, ["The Temple of Atal'Hakkar"] = true}
ST.Underground = UNDERGROUND
-- Coasts that face east (the sea is behind you at sunset).
local EAST_COASTS = {["Ratchet"] = true, ["Sen'jin Village"] = true, ["Echo Isles"] = true, ["Jaguero Isle"] = true, ["The Merchant Coast"] = true}
-- Which continent a zone lies on: a "first time on this continent" recorded late
-- is no first when an earlier chapter already stood there.
local ZONE_CONTINENT = {}
for _, zone in ipairs({"Elwynn Forest", "Westfall", "Redridge Mountains", "Duskwood", "Stranglethorn Vale", "Wetlands", "Loch Modan", "Dun Morogh",
    "Badlands", "Searing Gorge", "Burning Steppes", "Blasted Lands", "Swamp of Sorrows", "Deadwind Pass", "Arathi Highlands", "Hillsbrad Foothills",
    "Alterac Mountains", "Silverpine Forest", "Tirisfal Glades", "Western Plaguelands", "Eastern Plaguelands", "Stormwind City", "Ironforge",
    "Undercity", "Deeprun Tram", "Ruins of Lordaeron"}) do ZONE_CONTINENT[zone] = "Eastern Kingdoms" end
for _, zone in ipairs({"Durotar", "The Barrens", "Mulgore", "Teldrassil", "Darkshore", "Ashenvale", "Stonetalon Mountains", "Desolace",
    "Thousand Needles", "Dustwallow Marsh", "Feralas", "Tanaris", "Un'Goro Crater", "Silithus", "Azshara", "Felwood", "Winterspring", "Moonglade",
    "Orgrimmar", "Thunder Bluff", "Darnassus", "Hyjal"}) do ZONE_CONTINENT[zone] = "Kalimdor" end
ST.ZoneContinent = ZONE_CONTINENT
-- Who someone is to you, from their card (bond, pronouns).
local BOND_WORDS = {spouse = {she = "my wife", he = "my husband", they = "my spouse"},
    partner = {she = "my partner", he = "my partner", they = "my partner"},
    friend = {she = "my friend", he = "my friend", they = "my friend"}, family = {she = "my sister", he = "my brother", they = "my kin"}}
local ORIGIN_PLACE = {Scourge = "Deathknell", Orc = "Valley of Trials", Troll = "Valley of Trials", Tauren = "Camp Narache",
    Human = "Northshire Abbey", Dwarf = "Coldridge Valley", Gnome = "Coldridge Valley", NightElf = "Shadowglen",
    Skyborne = "Thendal Village"} -- (LoreForever npc:rorian-the-dayseeker, quest:92460: the Skyborne start in Thendal Village on Zephras Isle)
local function Q(title) return "{q:" .. Clean(title) .. "}" end
local function N(name) return "{n:" .. Clean(name):gsub("%-.*$", "") .. "}" end
local function Span(seconds)
    local minutes = math.floor((seconds or 0) / 60 + 0.5)
    if minutes < 55 then return (minutes <= 1 and "a minute" or (Words(minutes) .. " minutes")) end
    local hours = minutes / 60
    local whole = math.floor(hours + 0.5)
    if math.abs(hours - whole) < 0.15 then return whole == 1 and "an hour" or ("about " .. Words(whole) .. " hours") end
    if hours < whole then return "nearly " .. (whole == 1 and "an hour" or (Words(whole) .. " hours")) end
    return "over " .. (whole == 1 and "an hour" or (Words(whole) .. " hours"))
end
local function PartOfDay(t)
    local h = tonumber(date and date("%H", t or 0) or 12) or 12
    if h < 5 then return "night" elseif h < 12 then return "morning" elseif h < 18 then return "afternoon" elseif h < 22 then return "evening" end
    return "night"
end
local function Hour(t) return tonumber(date and date("%H", t or 0) or 12) or 12 end
local function Danger(level, lo, hi)
    if not level or not lo then return "fair" end
    if level >= hi + 10 then return "revisit" end
    if level > hi + 2 then return "easy" end
    if level >= lo - 1 then return "fair" end
    if level >= lo - 5 then return "daring" end
    return "reckless"
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
    local d = date and date("*t", Evening(t or 0))
    if type(d) ~= "table" then return math.floor((t or 0) / DAY) end
    return math.floor(((os and os.time) or time)({year = d.year, month = d.month, day = d.day, hour = 12}) / DAY)
end

-- The teller: picks lines, fresh ones first, and fills their tokens.
-- Lines that are a joke: each one once in a book.
local JOKES = {"short way down", "takes some doing", "hot as it looked", "better ways to go", "better deaths", "if the first one counts", "less said about that", "Of all things", "best of us", "graceful", "no one to blame"}
-- Words a sentence may share with the one before.
local ECHO_SHORT = {way = true, fell = true, bear = true, dark = true, fire = true}
local ECHO_OK = {there = true, their = true, these = true, those = true, which = true, ["while"] = true, where = true, about = true,
    would = true, could = true, after = true, before = true, again = true, still = true, every = true, first = true, level = true}
local function Teller(seed)
    local teller = {rng = Rng(seed), recent = {}, jokes = {}, onceUsed = {}}
    -- the words of the last sentence said (Tell sets it)
    function teller:Heard(text)
        self.echo = {}
        for word in (text or ""):gsub("{%a:[^}]*}", ""):gmatch("%f[%a]%l[%l']+%f[%A]") do if #word >= 5 or ECHO_SHORT[word] then self.echo[word] = true end end
    end
    function teller:Pick(key, list)
        if type(list) ~= "table" or #list == 0 then return nil end
        local recent = self.recent[key] or {}
        self.recent[key] = recent
        local fresh = {}
        for i = 1, #list do
            local used = false
            for _, r in ipairs(recent) do if r == i then used = true end end
            if not used then fresh[#fresh + 1] = i end
        end
        if #fresh == 0 then fresh = {}; for i = 1, #list do fresh[i] = i end end
        local i = fresh[self.rng(#fresh)]
        recent[#recent + 1] = i
        while #recent > math.max(1, #list - 1) do table.remove(recent, 1) end
        return list[i]
    end
    function teller:Say(key, list, tokens)
        -- (not the same first two words as the last three sentences)
        if self.lastTwos and type(list) == "table" and #list > 1 then
            local kept = {}
            for _, l in ipairs(list) do
                local two = l:gsub("[{}]", ""):lower():match("^(%S+%s+%S+)")
                if not self.lastTwos[two or ""] then kept[#kept + 1] = l end
            end
            if #kept > 0 and #kept < #list then list = kept end
        end
        if self.lastEnds and type(list) == "table" and #list > 1 then
            local kept = {}
            for _, l in ipairs(list) do
                local ending = l:gsub("[{}]", ""):lower():match("(%S+%s+%S+)%.$")
                if not (ending and self.lastEnds[ending]) then kept[#kept + 1] = l end
            end
            if #kept > 0 and #kept < #list then list = kept end
        end
        -- (a joke, or a line a reader remembers, is told once in a book)
        local once = self.once
        if not once then
            once = {}
            for _, template in ipairs((A.SelfWords and A.SelfWords.oncePerBook) or {}) do once[template] = true end
            self.once = once
        end
        if type(list) == "table" and #list > 1 then
            local kept = {}
            for _, l in ipairs(list) do
                local used = self.onceUsed[l] or false
                for _, joke in ipairs(JOKES) do if self.jokes[joke] and l:find(joke, 1, true) then used = true end end
                if not used then kept[#kept + 1] = l end
            end
            if #kept > 0 and #kept < #list then list = kept end
        end
        -- (no word of five letters or more from the sentence before, names aside: "fell ... fell")
        if self.echo and type(list) == "table" and #list > 1 then
            local kept = {}
            for _, l in ipairs(list) do
                local clash = false
                for word in l:gsub("{[^}]*}", ""):gmatch("%f[%a]%l[%l']+%f[%A]") do
                    if (#word >= 5 or ECHO_SHORT[word]) and self.echo[word] and not ECHO_OK[word] then clash = true end
                end
                if not clash then kept[#kept + 1] = l end
            end
            if #kept > 0 and #kept < #list then list = kept end
        end
        local line = self:Pick(key, list)
        if not line then return nil end
        for _, joke in ipairs(JOKES) do if line:find(joke, 1, true) then self.jokes[joke] = true end end
        if once[line] then self.onceUsed[line] = true end
        local text = line:gsub("{(%a+)}", function(token)
            local value = tokens and tokens[token]
            if value == nil and token:match("^%u") then
                local lower = tokens and tokens[token:sub(1, 1):lower() .. token:sub(2)]
                if lower ~= nil then return Cap(tostring(lower)) end
            end
            if value == nil then return "{" .. token .. "}" end
            return tostring(value)
        end)
        text = Cap(text)
        self.starts = self.starts or {}
        table.insert(self.starts, (text:gsub("{%a:", ""):gsub("[{}]", ""):lower():match("^(%S+%s+%S+)")) or "")
        while #self.starts > 3 do table.remove(self.starts, 1) end
        self.lastTwos = {}
        for _, x in ipairs(self.starts) do if x ~= "" then self.lastTwos[x] = true end end
        -- (the template's own ending, before tokens: "was mine.")
        local ending = line:gsub("[{}]", ""):lower():match("(%S+%s+%S+)%.$")
        self.endings = self.endings or {}
        table.insert(self.endings, ending or "")
        while #self.endings > 3 do table.remove(self.endings, 1) end
        self.lastEnds = {}
        for _, x in ipairs(self.endings) do if x ~= "" then self.lastEnds[x] = true end end
        return text
    end
    return teller
end

-- Towns --------------------------------------------------------------------------
local function Town(name)
    local W = A.SelfWords
    return name and W and W.towns and W.towns[name] or nil
end
ST.Town = Town
local function Tone(town, race, faction)
    for _, home in ipairs(town.home or {}) do if home == race then return "home" end end
    if town.side == "neutral" then return "neutral" end
    if faction and town.side == faction then return "ally" end
    if faction and town.side ~= faction then return "foe" end
    return "neutral"
end
ST.Tone = Tone

-- What a day holds, in the order it happened.
local function Facts(day)
    local f = {stretches = {}, quotes = {}, levels = {}, together = 0, quests = 0, gather = 0, crafts = 0, dungeons = 0}
    for _, scene in ipairs(day.scenes) do
        if scene.kind == "outing" then
            local s = {zone = scene.zone, t = scene.t, e = scene.e, with = scene.with or {}, events = scene.events or {},
                quests = scene.quests or {}, questCount = scene.questCount or 0, gather = scene.gather or {}, gatherNames = scene.gatherNames,
                gatherPlace = scene.gatherPlace or {},
                craft = scene.craft or {}, explored = scene.explored or {}, hk = scene.hk or 0,
                bosses = scene.bosses or {}, open = scene.open, entries = scene.entries or {}}
            -- Rendering marks events as consumed. Those marks belong to this
            -- telling, never to the cached book or recorded entries.
            s.events = {}
            for _, event in ipairs(scene.events or {}) do
                local copy = {}
                for key, value in pairs(event) do copy[key] = value end
                s.events[#s.events + 1] = copy
            end
            for _, entry in ipairs(scene.entries or {}) do
                if entry.pl then s.level = s.level or tonumber(entry.pl) end
                if entry.s then s.seeded = true end
            end
            table.sort(s.events, function(a, b) return (a.t or 0) < (b.t or 0) end)
            f.stretches[#f.stretches + 1] = s
            f.together = f.together + (scene.e - scene.t)
            f.quests = f.quests + s.questCount
            for _, n in pairs(s.gather) do f.gather = f.gather + n end
            for _, line in pairs(s.craft) do f.crafts = f.crafts + (line.count or 0) end
            for _, event in ipairs(s.events) do
                if event.k == "mylevel" then f.levels[#f.levels + 1] = tonumber(event.d); f.levelT = math.max(f.levelT or 0, event.t or 0) end
                if event.k == "dungeon" then f.dungeons = f.dungeons + 1 end
            end
        elseif scene.kind == "custom" and scene.text then
            f.quotes[#f.quotes + 1] = {text = scene.text, entries = scene.entries}
        elseif scene.kind == "mylevel" then
            f.levels[#f.levels + 1] = tonumber(scene.text)
        end
    end
    return f
end
-- A stretch worth a line: some time, or something in it.
local function Worth(s)
    return (s.e - s.t) >= 300 or #s.events > 0 or s.questCount > 0 or next(s.gather) ~= nil or next(s.craft) ~= nil
end

-- The picture of a character, from the whole record: how they play, in counts.
-- It is used to choose emphasis among true facts (which moment a short telling
-- keeps, which pool is likelier), never to state a trait the record does not
-- support, and never for hindsight inside a chapter (that is history's job).
function ST.Profile(days)
    local p = {gather = 0, craft = 0, fish = 0, caves = 0, dungeons = 0, deaths = 0, closes = 0, explored = 0, reads = 0, duels = 0, hk = 0,
        bgs = 0, nights = 0, stretches = 0, play = 0, with = 0, quests = 0, companions = {}}
    for _, day in ipairs(days or {}) do
        for _, scene in ipairs(day.scenes or {}) do
            if scene.kind == "outing" then
                p.stretches = p.stretches + 1
                local span = math.max(0, (scene.e or scene.t or 0) - (scene.t or 0))
                p.play = p.play + span
                local h = Hour(scene.t)
                if h >= 22 or h < 5 then p.nights = p.nights + 1 end
                for _, w in ipairs(scene.with or {}) do
                    p.with = p.with + (w.seconds or 0)
                    p.companions[w.name] = (p.companions[w.name] or 0) + (w.seconds or 0)
                end
                for kind, n in pairs(scene.gather or {}) do
                    if kind == "fishing" then p.fish = p.fish + n else p.gather = p.gather + n end
                end
                for _, line in pairs(scene.craft or {}) do p.craft = p.craft + (line.count or 0) end
                p.explored = p.explored + #(scene.explored or {})
                p.hk = p.hk + (scene.hk or 0)
                p.quests = p.quests + (scene.questCount or 0)
                for _, e in ipairs(scene.events or {}) do
                    if e.k == "cave" then p.caves = p.caves + 1
                    elseif e.k == "dungeon" then p.dungeons = p.dungeons + 1
                    elseif e.k == "death" then p.deaths = p.deaths + 1
                    elseif e.k == "close" then p.closes = p.closes + 1
                    elseif e.k == "read" then p.reads = p.reads + 1
                    elseif e.k == "duel" then p.duels = p.duels + 1
                    elseif e.k == "bg" then p.bgs = p.bgs + 1 end
                end
            end
        end
    end
    local hours = math.max(1, p.play / 3600)
    local enough = p.stretches >= 8
    p.gatherer = enough and p.gather >= 60 and p.gather / hours >= 4 or false
    p.crafter = enough and p.craft >= 30 or false
    p.fisher = enough and p.fish >= 30 or false
    p.explorer = enough and p.explored >= 25 and p.explored / hours >= 1.5 or false
    p.caver = enough and p.caves >= 8 or false
    p.dungeoneer = enough and p.dungeons >= 6 or false
    p.duelist = p.duels >= 5
    p.fighter = enough and (p.hk >= 10 or p.bgs >= 6) or false
    p.night = enough and p.nights / p.stretches >= 0.5 or false
    p.reckless = enough and p.deaths / hours >= 0.5 or false
    p.careful = enough and hours >= 10 and p.deaths / hours <= 0.1 or false
    p.solo = enough and p.with / math.max(1, p.play) <= 0.1 or false
    local best, bestTime
    for name, secs in pairs(p.companions) do if not bestTime or secs > bestTime then best, bestTime = name, secs end end
    p.paired = (enough and best and bestTime / math.max(1, p.play) >= 0.5) and best or nil
    return p
end

-- Telling a whole book ------------------------------------------------------------
-- stories[day.key] = {text, title, chapter, quotes}
local TownLine -- (set per chapter in Tell)
-- A line about the land that names the other side's town (Camp Mojache for an
-- Alliance character, Feathermoon for the Horde) is not what this character saw.
-- The towns' sides come from W.towns, with a few outposts the pools do not list.
local FOE_TOWNS = {["Camp Mojache"] = "Horde", ["Feathermoon"] = "Alliance", ["Camp Taurajo"] = "Horde", ["Theramore"] = "Alliance",
    ["Refuge Pointe"] = "Alliance", ["Hammerfall"] = "Horde", ["Southshore"] = "Alliance", ["Tarren Mill"] = "Horde", ["Menethil"] = "Alliance",
    ["Grom'gol"] = "Horde", ["Nijel's Point"] = "Alliance", ["Shadowprey"] = "Horde", ["Brackenwall"] = "Horde", ["Astranaar"] = "Alliance",
    ["Splintertree"] = "Horde", ["Sun Rock Retreat"] = "Horde", ["Stonetalon Peak"] = "Alliance", ["Zoram'gar"] = "Horde", ["Freewind Post"] = "Horde",
    ["Kargath"] = "Horde", ["Stonard"] = "Horde", ["Nethergarde"] = "Alliance", ["Talrendis"] = "Alliance", ["Valormok"] = "Horde",
    ["Revantusk"] = "Horde", ["Aerie Peak"] = "Alliance", ["Chillwind"] = "Alliance", ["Thalanaar"] = "Alliance", ["Auberdine"] = "Alliance",
    ["Sentinel Hill"] = "Alliance", ["Lakeshire"] = "Alliance", ["Darkshire"] = "Alliance", ["Thelsamar"] = "Alliance", ["Crossroads"] = "Horde",
    ["Razor Hill"] = "Horde", ["Bloodhoof"] = "Horde", ["Brill"] = "Horde", ["Sepulcher"] = "Horde"}
local function NamesFoeTown(line, faction)
    if not line or (faction ~= "Horde" and faction ~= "Alliance") then return false end
    for name, side in pairs(FOE_TOWNS) do
        if side ~= faction and line:find(name, 1, true) then return true end
    end
    local towns = A.SelfWords and A.SelfWords.towns
    for name, town in pairs(towns or {}) do
        if type(town) == "table" and town.side and town.side ~= "neutral" and town.side ~= faction and line:find(name, 1, true) then return true end
    end
    return false
end
ST.NamesFoeTown = NamesFoeTown
-- A first visit to a zone: what you saw, and (usually) what was at stake.
local function ZoneSight(Say, teller, zone, Pick, avoid, short, brief, faction)
    local L = A.Lore
    local zs = L and L.ZoneStory and L.ZoneStory(zone)
    if not zs then return end
    local function One(list)
        local kept = {}
        for _, line in ipairs(list) do
            local repeatsTown = false
            for _, town in ipairs(avoid or {}) do if line:find(town, 1, true) then repeatsTown = true end end
            if not repeatsTown and not NamesFoeTown(line, faction) then kept[#kept + 1] = line end
        end
        if #kept == 0 then return nil end
        if Pick then return Pick(kept, avoid) end
        return kept[teller.rng(#kept)]
    end
    if zs.sight then Say(One(zs.sight), true, "lore") end
    -- (a dungeon follows the same day: one line for the land, the dungeon has its own)
    -- (the draw is made as before; the short telling keeps the sight and leaves the stakes out)
    if zs.stakes and not short and teller.rng() < 0.7 and not brief then Say(One(zs.stakes), true, "lore") end
end
function ST.Tell(person, days, brief, retell)
    local W = A.SelfWords or {}
    local L = A.Lore
    local race, faction = person.race, person.faction
    -- (Forever's sky elves: Lore.lua accepts any token with "Sky" or "Shen"; the tables here are keyed "Skyborne")
    if type(race) == "string" and not START_HOME[race] and (race:find("Sky") or race:find("Shen")) then race = "Skyborne" end
    -- Names, class and pronouns live on the shared card; bond and origin belong
    -- to the character whose journal this is, even when another character reads it.
    local function Companion(key)
        if not key or not A.db then return nil end
        if type(A.db.characters) == "table" then
            local owner = person.charKey or (A.Me and A.Me())
            return owner and A.PersonAs and A.PersonAs(key, owner) or nil
        end
        return A.db.people and A.db.people[key] -- before per-character migration
    end
    -- Keep recorded names as identities for history and reunions, but show the
    -- current display name in prose. A settings edit never rewrites the events.
    local displayNames = {}
    for _, day in ipairs(days) do
        for _, scene in ipairs(day.scenes) do
            for _, companion in ipairs(scene.with or {}) do
                local info = Companion(companion.key)
                if info and info.display and info.display ~= "" then displayNames[companion.name] = info.display end
            end
        end
    end
    local recordedName = N
    local function N(name)
        local display = displayNames[Clean(name):gsub("%-.*$", "")]
        return display and ("{n:" .. Clean(display) .. "}") or recordedName(name)
    end
    local stories = {}
    local history = {zones = {}, towns = {}, bosses = {}, perils = {}, chapter = 0, lastDay = nil, lastZone = nil, companions = {},
        continents = {}, killers = {}, zoneMemory = {}, companionDays = {}, tallySaid = {}, avenged = {}, memorySaid = {},
        dungeonVisits = {}, dungeonsEver = 0, roleSaid = {}, titles = {}, questLore = {}, storyThreads = {}, describedZones = {}, infamous = {}, companionLast = {}, companionTime = {}, quests = 0, deaths = 0}
    local teller = Teller((person.charKey or person.name or "me") .. ":" .. tostring(retell or person.retell or 0))
    local profile = ST.Profile(days)
    -- (all the deaths in the book: hindsight is said only when true)
    local totalDeaths = 0
    for _, day in ipairs(days) do
        for _, scene in ipairs(day.scenes) do for _, e in ipairs(scene.events or {}) do if e.k == "death" then totalDeaths = totalDeaths + 1 end end end
    end
    for index, day in ipairs(days) do
        local f = Facts(day)
        if index == 1 then
            local beginning = f.stretches[1]
            history.earlyCoverage = beginning and not beginning.seeded and beginning.level and beginning.level <= 5
                and person.startLevel and person.startLevel <= 5
        end
        local out, majors = {}, {}
        -- Keep the scene attached to its prose. Importance alone cannot tell
        -- whether a sentence supplies the place, work, or quiet end of a scene.
        local scenes, sceneAt = {}, 1
        -- A list without the phrases the chapter has said already ("first time", "new to me"...).
        local SIGNATURES = {"first time", "new to me", "had never", "never been", "at last", "was mine"}
        local function Fresh(list)
            if not list then return list end
            local said = table.concat(out, " "):lower()
            -- (two "first" claims a chapter; after that, the lines without the word)
            local firsts = 0
            for _ in said:gmatch("%f[%a]first%f[%A]") do firsts = firsts + 1 end
            local kept = {}
            for _, line in ipairs(list) do
                local low, clash = line:lower(), false
                for _, phrase in ipairs(SIGNATURES) do if said:find(phrase, 1, true) and low:find(phrase, 1, true) then clash = true end end
                if firsts >= 2 and low:find("%f[%a]first%f[%A]") then clash = true end
                if not clash then kept[#kept + 1] = line end
            end
            return #kept > 0 and kept or list
        end
        -- (prefix: the opening's "On Tuesday" carried onto the next sentence; kind "lore" never takes it)
        local prefix
        local kinds = {}
        -- Names said so far this chapter ("Searing Blade", "Deathknell"): a lore line
        -- that would say one of them a third time is left out.
        local function Names(text)
            local names = {}
            local plain = text:gsub("{%a:([^}]*)}", "%1")
            local run = {}
            local function Flush()
                local name = table.concat(run, " "):gsub("^The ", "")
                if #name >= 5 and name ~= "The" then names[#names + 1] = name end
                run = {}
            end
            for word, gap in plain:gmatch("([%a']+)([^%a']*)") do
                if word:match("^%u") and word ~= "I" then run[#run + 1] = word else Flush() end
                if gap:find("[,%.;!]") then Flush() end
            end
            Flush()
            return names
        end
        local function Crowded(text)
            local said = table.concat(out, " "):gsub("{%a:([^}]*)}", "%1")
            for _, name in ipairs(Names(text)) do
                local n, at = 0, 1
                while true do
                    local i = said:find(name, at, true)
                    if not i then break end
                    n, at = n + 1, i + #name
                end
                if n >= 2 then return true end
            end
            return false
        end
        -- The lines of a pool that name nothing said already this chapter (all of
        -- them, when none is clear): "the boats leave for Teldrassil" not after
        -- "the first time I had left Teldrassil". (A line's first word is not a name.)
        local function Sparing(list)
            if not list then return list end
            local said = table.concat(out, " "):gsub("{%a:([^}]*)}", "%1")
            local kept = {}
            for _, line in ipairs(list) do
                local clash = false
                local opening = line:gsub("{%a:([^}]*)}", "%1"):match("^([%a']+)")
                for _, name in ipairs(Names(line)) do
                    if name ~= opening and said:find(name, 1, true) then clash = true end
                end
                if not clash then kept[#kept + 1] = line end
            end
            return #kept > 0 and kept or list
        end
        -- A lore line from a pool: the one that repeats the fewest names said
        -- already (a name in the sentence just before counts double); none, when
        -- every line would say a name a third time.
        local function PickLore(list, avoid)
            if type(list) ~= "table" or #list == 0 then return nil end
            local said = table.concat(out, " "):gsub("{%a:([^}]*)}", "%1")
            local last = (out[#out] or ""):gsub("{%a:([^}]*)}", "%1")
            local best, bestScore = {}, math.huge
            for _, line in ipairs(list) do
                local score = 0
                for _, name in ipairs(Names(line)) do
                    if said:find(name, 1, true) then score = score + 1 end
                    if last:find(name, 1, true) then score = score + 1 end
                end
                for _, name in ipairs(avoid or {}) do if line:find(name, 1, true) then score = score + 2 end end
                if score < bestScore then best, bestScore = {line}, score elseif score == bestScore then best[#best + 1] = line end
            end
            local line = best[teller.rng(#best)]
            if line and Crowded(line) then return nil end
            return line
        end
        local function DescribeZone(SayLine, zone, avoid, short)
            if history.describedZones[zone or "?"] then return end
            history.describedZones[zone or "?"] = true
            ZoneSight(SayLine, teller, zone, PickLore, avoid, short, brief, faction)
        end
        -- The lines of a pool that do not name the zone ({zoneD}), when it was just said.
        -- (right after the water, "There" would put it in the lake)
        local function NotThere(list, avoid)
            if not avoid or not list then return list end
            local kept = {}
            for _, line in ipairs(list) do if not line:find("^There") then kept[#kept + 1] = line end end
            return #kept > 0 and kept or list
        end
        -- A role line the book has not said yet (all of them said: any)
        local function RoleLine(role, list, st)
            history.roleLines = history.roleLines or {}
            local kept = {}
            for _, line in ipairs(list or {}) do if not history.roleLines[line] then kept[#kept + 1] = line end end
            local line = teller:Say("role" .. role, #kept > 0 and kept or list, st)
            if line then history.roleLines[line] = true end
            return line
        end
        local function Unnamed(list, said)
            if not said or not list then return list end
            local kept = {}
            for _, line in ipairs(list) do if not line:find("{zoneD}", 1, true) then kept[#kept + 1] = line end end
            return #kept > 0 and kept or list
        end
        local moodQueue = {}
        local times = {}
        local sayTime
        local function Say(text, major, kind, required)
            if not text then return end
            -- (a mood line waits until the line that carries the "when" is said)
            if prefix and kind == "mood" then moodQueue[#moodQueue + 1] = {text, major}; return end
            -- (a plural place takes "were": "the Hillsbrad Foothills were new to me")
            text = text:gsub("({p:[^}]*[^s]?s}) was ", function(place)
                if place:find("Barrens}") or place:find("Foothills}") or place:find("lands}") or place:find("Mountains}") or place:find("Steppes}")
                    or place:find("Glades}") or place:find("Highlands}") or place:find("Isles}") then return place .. " were " end
                return place .. " was "
            end)
            if kind == "lore" and not required and Crowded(text) then return end
            -- (a title that ends in "!" or "?" ends the sentence too)
            text = text:gsub("([!?])(}?)%.", "%1%2")
            if prefix and kind ~= "lore" then
                -- (lower the first word, unless it is "I" or a marked name)
                if not text:match("^I ") and not text:match("^{") then text = text:gsub("^%u", string.lower) end
                text = prefix .. ", " .. text
                prefix = nil
            end
            text = A.JournalIslands and A.JournalIslands(text) or text
            out[#out + 1] = text
            scenes[#out] = sceneAt
            majors[#out] = major or false
            kinds[#out] = kind
            if kind == "quests" or kind == "level" then
                times[#out] = sayTime
                sayTime = nil
            end
            teller:Heard(text)
            if not prefix and #moodQueue > 0 then
                local queued = moodQueue
                moodQueue = {}
                for _, m in ipairs(queued) do out[#out + 1] = m[1]; majors[#out] = m[2] or false; kinds[#out] = "mood"; scenes[#out] = sceneAt end
            end
        end
        local stretches = {}
        for _, s in ipairs(f.stretches) do if Worth(s) then stretches[#stretches + 1] = s end end
        -- Titles: the best of the day, and not one an earlier chapter already had.
        local titles = {}
        local function Title(rank, text) if text and text ~= "" then titles[#titles + 1] = {rank = rank, text = text} end end
        if #stretches > 0 then
            local first = stretches[1]
            local dayNumber = DayNumber(day.t)
            local gap = history.lastDay and (dayNumber - history.lastDay) or nil
            local part = PartOfDay(first.t)
            local weekday = date and date("%A", Evening(first.t)) or "that day"
            local When
            if not gap then When = nil
            elseif gap <= 0 then When = teller:Pick("whenSameDay", {"Later", "Later that day", "After that"})
            elseif gap <= 1 then When = teller:Pick("when1", {"The next day", "A day later", weekday .. " " .. part, "The day after", "The following " .. part})
            elseif gap < 7 then When = teller:Pick("when2", {Cap(Words(gap)) .. " days later", "On " .. weekday .. " " .. part, "On " .. weekday})
            elseif gap < 14 then When = teller:Pick("when3", {Cap(Words(gap)) .. " days later", "On " .. weekday})
            elseif gap < 28 then When = teller:Pick("when4", {Cap(Words(gap)) .. " days later", "On " .. weekday})
            else When = Cap(gap >= 60 and (Words(math.floor(gap / 30 + 0.5)) .. " months") or (Words(math.floor(gap / 7 + 0.5)) .. " weeks")) .. " later" end -- elapsed time, never evidence of inactivity
            local function ZoneE(zone)
                local lore = L and L.Zone and L.Zone(zone)
                if lore and lore.e and teller.rng() < 0.3 then
                    local short = {}
                    -- (not the ones that read wrong after "in": "in the coast of Azshara")
                    for _, e in ipairs(lore.e) do
                        if not e:find(",") and not e:find("^the coast") and not e:find("^the mesas") and not e:find("^the red rock")
                            and not e:find("^the broken earth") then short[#short + 1] = e end
                    end
                    if #short > 0 then return short[teller.rng(#short)] end
                end
                return Place(zone)
            end
            local function ZoneLore(zone)
                local lore = L and L.Zone and L.Zone(zone)
                if lore and lore.e then
                    for _, e in ipairs(lore.e) do if e:find(",") then return e end end
                end
                return Place(zone)
            end
            local function Lower(phrase)
                if not phrase then return phrase end
                if phrase:match("^On ") then return "on " .. phrase:sub(4) end
                if date and phrase:find(date("%A", Evening(first.t)), 1, true) == 1 then return phrase end
                return (phrase:gsub("^%u", string.lower))
            end
            local tokens = {zoneE = ZoneE(first.zone), zoneD = Place(first.zone), zoneLore = ZoneLore(first.zone), when = Lower(When) or "the day",
                When = When, WhenBare = When and (When:gsub("^On ", ""))}
            local function Bare(list)
                if not When or not (When:find("^On ") or When:find("later$") or When:find("^After")) then return list end
                local kept = {}
                for _, line in ipairs(list or {}) do if not line:find("{when}", 1, true) then kept[#kept + 1] = line end end
                return #kept > 0 and kept or list
            end
            local firstTowns = {}
            for _, x in ipairs(first.events) do if x.k == "town" and x.d then firstTowns[#firstTowns + 1] = (Clean(x.d):gsub(" City$", "")) end end
            local firstVisit = false
            for _, event in ipairs(first.events) do if event.k == "first" and event.d == "zone" and not event.u and not first.seeded then firstVisit = true end end
            -- (the book has been there before: a first recorded late is no first)
            if firstVisit and history.zones[first.zone or "?"] then firstVisit = false end
            -- 1. The opening.
            local startWith = {}
            local companionsReopen = {} -- (new people among those you set out with: introduced in the stretch)
            -- The first zone beyond home (where your people begin, and their capital): once a book.
            local function LeftHome(zone)
                if history.leftHome or not W.leaveHomeFirst or not W.leaveHomeFirst[race] or (person.startLevel or 99) > 10 then return end
                local start = L and L.starts and L.starts[race]
                if not start or zone == start or CITY_ZONE[zone] or (CITY_ZONE[zone] == nil and false) then return end
                for city, around in pairs(CITY_ZONE) do if city == zone and around == start then return end end
                history.leftHome = true
                Say(teller:Say("leaveHomeFirst", Fresh(W.leaveHomeFirst[race]), {}), true)
            end
            -- (one person new to the book, there from the start: the opening can say who they are)
            local openNew, openNewSaid
            do
                local news = {}
                for _, w in ipairs(first.with) do
                    local info = not history.companions[w.name] and Companion(w.key)
                    if info and w.seconds >= (first.e - first.t) * 0.5 and not info.bond then
                        local people = L and L.People and L.People(info.race)
                        local classWord = info.class and ((LOCALIZED_CLASS_NAMES_MALE and LOCALIZED_CLASS_NAMES_MALE[info.class]) or info.class):lower()
                        local who = people and classWord and (people .. " " .. classWord) or classWord or people
                        if who then news[#news + 1] = N(w.name) .. ", " .. ((who:match("^[aeiou]") and "an " or "a ") .. who) end
                    end
                end
                if #news == 1 and #first.with == 1 then openNew = news[1] end
            end
            for _, w in ipairs(first.with) do
                local known = history.companions[w.name] or not Companion(w.key)
                if w.seconds >= (first.e - first.t) * 0.5 and known then startWith[#startWith + 1] = N(w.name) end
            end
            local beganWith, bondAllDay
            for _, w in ipairs(first.with) do
                local info = Companion(w.key)
                if info and info.bond and w.seconds >= (first.e - first.t) * 0.75 then
                    bondAllDay = w
                    if info.origin == "together" then beganWith = {w = w, info = info} end
                end
            end
            local lastSeen = history.zones[first.zone]
            local crossing
            for _, e in ipairs(first.events) do if e.k == "voyage" and e.d and W.voyageOpen and W.voyageOpen[e.d] then crossing = e end end
            if crossing then
                for _, e in ipairs(first.events) do if e.k == "first" and e.d == crossing.d and not e.u then crossing = nil; break end end
            end
            -- someone of your list, back after a long while
            local reunion
            for _, w in ipairs(first.with) do
                local last = history.companionLast[w.name]
                -- After a reunion-led chapter, let the next setting or deed
                -- establish the scene instead of repeating the same greeting.
                if last and dayNumber - last >= 21 and history.reunionChapter ~= index - 1
                    and w.seconds >= (first.e - first.t) * 0.5 then reunion = w end
            end
            local function Ago(n)
                if n >= 60 then return Words(math.floor(n / 30 + 0.5)) .. " months" end
                return Words(math.floor(n / 7 + 0.5)) .. " weeks"
            end
            -- the day begins in a dungeon, or in a town (its own line opens the day)
            local dungeonOpen, townOpen
            if L and L.Dungeon and L.Dungeon(first.zone) then
                for _, e in ipairs(first.events) do if e.k == "dungeon" and e.d == first.zone and not dungeonOpen then dungeonOpen = e end end
            end
            if Town(first.zone) and not firstVisit and not (W.origin and W.origin[race] and person.startLevel and person.startLevel <= 2 and not When) then
                local seen = history.towns[first.zone]
                for _, e in ipairs(first.events) do
                    if e.k == "town" and e.d == first.zone and not (seen and index - seen < 10) then townOpen = e end
                end
            end
            local raidOpen = false
            for _, e in ipairs(first.events) do if e.k == "first" and e.d == "raid" and e.z == first.zone then raidOpen = true end end
            -- a world boss that was the whole day opens it
            local bossOpen = #stretches == 1 and When ~= nil
            local anyBoss = false
            for _, e in ipairs(first.events) do
                if e.k == "first" and e.d == "worldboss" then anyBoss = true
                elseif e.k ~= "death" and e.k ~= "rez" then bossOpen = false end
            end
            bossOpen = bossOpen and anyBoss
            local bgOpen = false
            for _, e in ipairs(first.events) do if (e.k == "bg" or (e.k == "first" and e.d == "battleground")) and (e.d == first.zone or e.z == first.zone) then bgOpen = When ~= nil end end
            local origin = not When and person.startLevel and person.startLevel <= 2 and (first.level or 1) <= 3 and W.origin and W.origin[race]
            local together0 = origin and beganWith and W.originTogether and W.originTogether[race]
            local originGap = origin and first.zone ~= (L and L.starts and L.starts[race]) and first.zone ~= ORIGIN_PLACE[race]
            if originGap then sceneAt = 0 end
            if together0 then
                -- (a life begun side by side: the book opens as theirs)
                local info = beganWith.info
                tokens.names = N(beganWith.w.name)
                tokens.bond = BOND_WORDS[info.bond] and BOND_WORDS[info.bond][info.pronouns or "they"] or "my friend"
                local togetherLine = teller:Say("originTogether", together0, tokens)
                Say(togetherLine, true, "origin")
                history.companions[beganWith.w.name] = true
                history.introduced = history.introduced or {}
                history.introduced[N(beganWith.w.name)] = index
                history.originTown = W.originTowns and W.originTowns[race]
                Title(40, teller:Pick("tOrigin", W.titles.origin))
            elseif origin then
                Say(teller:Say("origin", origin, tokens), true, "origin")
                history.originTown = W.originTowns and W.originTowns[race]
                Title(40, teller:Pick("tOrigin", W.titles.origin))
            elseif reunion and When and W.reunion then
                tokens.names, tokens.ago = N(reunion.name), Ago(dayNumber - history.companionLast[reunion.name])
                tokens.When = "On " .. weekday
                local info = Companion(reunion.key)
                local bondWord = info and info.bond and BOND_WORDS[info.bond] and BOND_WORDS[info.bond][info.pronouns or "they"]
                if bondWord and W.reunionBond then
                    tokens.bond = bondWord
                    local key = dungeonOpen and W.reunionDungeonBond and "reunionDungeonBond" or "reunionBond"
                    Say(teller:Say(key, W[key], tokens), true)
                else
                    local key = dungeonOpen and W.reunionDungeon and "reunionDungeon" or "reunion"
                    Say(teller:Say(key, W[key], tokens), true)
                end
                Title(64, (teller:Pick("tReunion", W.titles.reunion) or ""):gsub("{names}", (Clean(reunion.name):gsub("%-.*$", ""))))
                reunion.told = true
                history.reunionChapter = index
                -- This opener already places the company inside this dungeon.
                if dungeonOpen then dungeonOpen.introduced = true end
            elseif bossOpen and not crossing then
                prefix = When .. ", in " .. Place(first.zone)
            elseif dungeonOpen and not crossing and raidOpen then
                -- (the first raid's own line opens the day)
                prefix = When
            elseif dungeonOpen and not crossing and W.openDungeon then
                tokens.dungeonD = Place(first.zone)
                local inWith = {}
                for _, w in ipairs(first.with) do if history.companions[w.name] and w.seconds >= (first.e - first.t) * 0.5 then inWith[#inWith + 1] = N(w.name) end end
                if When and #inWith > 0 and W.openDungeonWith then
                    -- ("The next day, Kesh, Ula and I went back into the Scarlet Monastery.")
                    tokens.names = table.concat(inWith, ", ") -- ("Kesh, Ula and I")
                    local again = history.dungeonVisits[first.zone] and W.openDungeonWithAgain
                    Say(teller:Say(again and "openDungeonWithAgain" or "openDungeonWith", again or W.openDungeonWith, tokens), true)
                    history.introduced = history.introduced or {}
                    for _, name in ipairs(inWith) do history.introduced[name] = index end
                else
                    Say(teller:Say(When and "openDungeon" or "openDungeonFirst", When and W.openDungeon or W.openDungeonFirst, tokens), true)
                end
                dungeonOpen.introduced = true
            elseif (townOpen or bgOpen) and not crossing and (When or (person.startLevel or 1) < 10) then
                -- (the town's line, told in the first stretch, takes the "when"; a first chapter starts with it)
                prefix = When
            elseif crossing and When then
                tokens.to = crossing.to and Place(crossing.to) or "the other shore"
                Say(teller:Say("voyageOpen" .. crossing.d, W.voyageOpen[crossing.d], tokens), true)
                crossing.told = true
                if crossing.d == "zeppelin" or crossing.d == "boat" then Title(58, teller:Pick("tVoyage", W.titles.voyage)) end
            elseif not When and townOpen and not crossing and (person.startLevel or 1) < 10 then
                -- (a first chapter that begins in a town: the town's own line opens it)
                prefix = nil
            elseif not When then
                -- ("I began in ..." is a birthplace: only for a journal begun at the start)
                local firstLines = W.openFirst
                if (person.startLevel or 1) > 2 then
                    local kept = {}
                    for _, line in ipairs(W.openFirst) do if not line:find("^I began") then kept[#kept + 1] = line end end
                    if #kept > 0 then firstLines = kept end
                end
                local atHome = AtHome(race, first.zone)
                local late = (person.startLevel or 1) >= 10 and W.openFirstLate
                if late then
                    tokens.level = tostring(first.level or person.startLevel)
                    Say(teller:Say("openFirstLate", (atHome and W.openFirstLate.home) or W.openFirstLate[race] or W.openFirstLate.other, tokens), true, "open")
                else
                    Say(teller:Say("openFirst", firstLines, tokens), true, "open")
                end
                -- (described here: the stretch below must not describe it a second time)
                if firstVisit then DescribeZone(Say, first.zone, firstTowns, f.dungeons > 0) end
            elseif bondAllDay and #startWith > 0 and W.openWith and teller.rng() < 0.75 then
                tokens.names = List(startWith)
                Say(teller:Say("openWith", W.openWith, tokens), false, "open")
            elseif first.zone == history.lastZone then
                -- (still there: a gap of three days or less; with work to do, the work)
                if gap and gap > 3 and W.openSame then Say(teller:Say("openSame", W.openSame, tokens), false, "open")
                elseif first.questCount > 0 and f.quests >= 2 and W.openStillWork and teller.rng() < 0.5 then Say(teller:Say("openStillWork", W.openStillWork, tokens), false, "open")
                else Say(teller:Say("openStill", Bare(W.openStill), tokens), false, "open") end
            elseif firstVisit then
                Say(teller:Say("openNew", W.openNew, tokens), true, "open")
                LeftHome(first.zone)
                DescribeZone(Say, first.zone, firstTowns, f.dungeons > 0)
                Title(35, Clean(first.zone))
            elseif lastSeen and dayNumber - lastSeen >= 14 and not (gap and gap >= 28) then
                tokens.When = "On " .. weekday
                tokens.ago = Words(math.floor((dayNumber - lastSeen) / 7 + 0.5)) .. " weeks"
                if dayNumber - lastSeen >= 60 then tokens.ago = Words(math.floor((dayNumber - lastSeen) / 30 + 0.5)) .. " months" end
                -- (back where a foe killed you: the place remembers, once a zone)
                local memory = history.zoneMemory[first.zone or "?"]
                if memory and memory.foe and W.openBackMemory and not history.memorySaid[first.zone] and dayNumber - memory.day >= 14 then
                    history.memorySaid[first.zone] = true
                    tokens.foe = memory.foe
                    tokens.Foe = Cap(memory.foe)
                    tokens.ago = Ago(dayNumber - memory.day)
                    Say(teller:Say("openBackMemory", W.openBackMemory, tokens), true, "open")
                else
                    Say(teller:Say("openBack", W.openBack, tokens), true, "open")
                end
            elseif #startWith == 0 and openNew and W.openWithNew then
                tokens.names = openNew
                Say(teller:Say("openWithNew", W.openWithNew, tokens), true, "open")
                openNewSaid = true
            elseif #startWith > 0 then
                tokens.names = List(startWith)
                Say(teller:Say("openWith", W.openWith, tokens), false, "open")
                -- (someone new among them is introduced in the stretch, below)
                for _, w in ipairs(first.with) do if not history.companions[w.name] and Companion(w.key) then companionsReopen[N(w.name)] = true end end
            else
                local range = L and L.ZoneLevels and L.ZoneLevels(first.zone)
                local danger = Danger(first.level, range and range[1], range and range[2])
                if (danger == "daring" or danger == "reckless") and not history.perils[first.zone] and teller.rng() < 0.7 then
                    history.perils[first.zone] = true
                    Say(teller:Say("openPeril", W.openPeril, tokens), false, "open")
                else
                    Say(teller:Say("open", Bare(W.open), tokens), false, "open")
                end
            end
            if originGap then
                -- A chosen origin is backstory, not evidence of the missing
                -- journey. Establish where the captured adventure picks up.
                sceneAt = 1
                Say(teller:Say("originBridge", W.originBridge, {zoneD = Place(first.zone), We = together0 and "We" or "I", we = together0 and "we" or "I", were = together0 and "were" or "was"}), true, "open")
            end
            -- Back after weeks where a foe killed you, when the opening did not say so (once a zone).
            do
                local memory = history.zoneMemory[first.zone or "?"]
                if memory and memory.foe and W.backMemory and lastSeen and dayNumber - lastSeen >= 14 and dayNumber - memory.day >= 14
                    and not history.memorySaid[first.zone] and not firstVisit and not origin then
                    history.memorySaid[first.zone] = true
                    Say(teller:Say("backMemory", W.backMemory, {foe = memory.foe, Foe = Cap(memory.foe), ago = Ago(dayNumber - memory.day), zoneD = Place(first.zone)}), true, "open")
                end
            end
            -- Missing chapters do not establish time away from adventuring.
            -- A day of honest work (mostly gathering or crafting).
            local deathsToday, closeToday = 0, false
            local sunsetToday, newPlaces, envToday, fights = false, 0, 0, 0
            for _, s in ipairs(stretches) do
                for _, e in ipairs(s.events) do
                    if e.k == "death" then deathsToday = deathsToday + 1 end
                    if (e.k == "death" or e.k == "close") and e.env then envToday = envToday + 1 end
                    if e.k == "first" and e.d == "sunset" then sunsetToday = true end
                    if e.k == "first" and (e.d == "zone" or e.d == "landmark") then newPlaces = newPlaces + 1 end
                    if e.k == "boss" or e.k == "wipe" or (e.k == "close" and e.d) then fights = fights + 1 end
                end
            end
            local quiet = f.quests <= 1 and f.dungeons == 0 and deathsToday == 0 and fights == 0
                and (sunsetToday or (f.gather > 0 and newPlaces > 0))
            -- (the land itself was the danger: falls, the water, again and again)
            local clumsy = envToday >= 2
            -- (a day with a crossing, a new land or a capital's first sight is not a quiet one)
            local bigDay = false
            for _, s in ipairs(stretches) do
                for _, e in ipairs(s.events) do
                    if e.k == "voyage" or (e.k == "first" and (e.d == "continent" or e.d == "zeppelin" or e.d == "boat")) then bigDay = true end
                    if e.k == "town" and W.capitalFirst and W.capitalFirst[e.d] and not history.towns[e.d] and (person.startLevel or 99) < 10 then bigDay = true end
                end
            end
            if bigDay then quiet = false end
            local companyToday, companyNames = false, {}
            for _, w in ipairs(first.with) do if history.companions[w.name] then companyToday = true; companyNames[#companyNames + 1] = w.name end end
            local honest = not quiet and not bigDay and (f.gather >= 15 or f.crafts >= 10) and f.quests <= 3 and f.dungeons == 0
            if honest then Say(teller:Say("honestDay", W.honestDay, tokens), true, "mood"); Title(50, teller:Pick("tHonest", W.titles.honest)) end
            if quiet and W.quietDay then
                local pool = (f.quests == 1 and W.quietDayOne) or W.quietDay
                if companyToday then
                    pool = (f.quests == 1 and W.quietDayOneWe) or W.quietDayWe or pool
                    -- (the "we" lines name who "we" were: no "I travelled with" after)
                    local named = {}
                    for _, w in ipairs(companyNames) do named[#named + 1] = N(w) end
                    tokens.with = List(named)
                    tokens.With = tokens.with
                    local opened = table.concat(out, " ")
                    if named[1] and opened:find(named[1], 1, true) then
                        pool = (f.quests == 1 and W.quietDayOneWeBare) or W.quietDayWeBare or pool
                    else
                        history.weNamedDay = index
                    end
                end
                Say(teller:Say(f.quests == 1 and "quietDayOne" or "quietDay", pool, tokens), true, "mood")
                history.quietDay = index
                Title(52, teller:Pick("tQuiet", W.titles.quiet))
            end
            local sunsetLater, wandered
            local currentStretch -- {zone, st}: for the milestones told from outside the loop
            local flewTo -- a flight told with where it went
            local Milestone, FirstDeath, GatherLine
            -- (a mount bought with the level the day brought: told after that level)
            local afterLevel, levelsSaid = {}, false
            local consequenceAt -- (the line of what a lord's fall meant: the day's level goes before it)
            local companionsSaid = {}
            -- (named by the book's opening; or a wife, a friend there every day, said at most one chapter in four)
            for name, at in pairs(history.introduced or {}) do if at == index then companionsSaid[name] = true end end
            if bondAllDay then
                local bondName = N(bondAllDay.w and bondAllDay.w.name or bondAllDay.name)
                if history.bondSaid and history.chapter - history.bondSaid < 4 then companionsSaid[bondName] = true
                else history.bondSaid = history.chapter end
            end
            if tokens.names then for _, name in ipairs(startWith) do if not companionsReopen[name] then companionsSaid[name] = true end end end
            if reunion and reunion.told then companionsSaid[N(reunion.name)] = true end
            -- A town, told by who you are (home, your side, neutral ground, the other side).
            function TownLine(e, s, st)
                st["town:" .. e.d] = true
                local town = Town(e.d)
                if not town then return end
                if origin and e.d == history.originTown then return end
                -- (the opening named it: "I set out from Ironforge at level 22.")
                if kinds[1] == "open" and #out <= 2 and (out[1] or ""):find("{p:" .. Clean(e.d) .. "}", 1, true) then
                    if not history.towns[e.d] and town.lore then
                        local detail = PickLore(town.lore)
                        if detail then Say(teller:Say("townBackdrop", W.townBackdrop, {town = town.name, lore = detail}), true, "lore") end
                    end
                    history.towns[e.d] = index
                    return
                end
                local tone = Tone(town, race, faction)
                -- (home only where your people begin, or their city)
                if tone == "home" and not AtHome(race, s.zone) and not AtHome(race, e.d) then tone = faction and town.side == faction and "ally" or "neutral" end
                local seen = history.towns[e.d]
                if seen and index - seen < 10 then return end
                history.towns[e.d] = index
                local tt = {town = town.name, lore = town.lore and (PickLore(town.lore) or town.lore[teller.rng(#town.lore)]) or "", side = town.side}
                local company = st.We == "We"
                local knownFirst = false
                for _, x in ipairs(s.events) do if x.k == "first" and x.d == "zone" and not x.u and not s.seeded and (x.z == e.d or s.zone == e.d) and not history.zones[e.d] then knownFirst = true end end
                local capital = (W.capitalFirstRace and W.capitalFirstRace[race] and W.capitalFirstRace[race][e.d]) or (W.capitalFirst and W.capitalFirst[e.d])
                if capital and tone ~= "foe" and not seen and not history.zones[e.d] and (knownFirst or history.earlyCoverage)
                    and not (tone == "home" and (s.level or 0) > 20) then
                    Say(teller:Say("capital:" .. e.d, Sparing(Fresh(capital)), tt), true, "first")
                    Title(58, ((teller:Pick("tCapital", W.titles.capital) or ""):gsub("{city}", (Clean(town.name):gsub("^the ", ""):gsub("^p:", "")))))
                elseif knownFirst and tone ~= "home" and tone ~= "foe" then
                    Say(teller:Say("townFirst", W.townFirst, tt), true)
                elseif tone == "home" and not seen and ((person.startLevel or 1) <= 10 or history.chapter == 0) then
                    -- (B: in company, "we" came to it)
                    if town.homeFirst and not company and teller.rng() < 0.7 and (person.startLevel or 1) <= 10 then Say(teller:Say("homeFirst:" .. e.d, Sparing(town.homeFirst), tt), true)
                    else Say(teller:Say("townHomeFirst", (company and W.townHomeFirstWe) or W.townHomeFirst, tt), true) end
                elseif tone == "home" then
                    Say(teller:Say("home:" .. e.d, Sparing((town.homeLines and teller.rng() < 0.7) and town.homeLines or W.townHome), tt), true)
                    if index > 1 then Title(20, (teller:Pick("tHome", W.titles.home):gsub("{zoneD}", (Clean(town.name):gsub("^the ", ""):gsub("^p:", ""))))) end
                elseif tone == "foe" then
                    Say(teller:Say("townFoe", W.townFoe, tt))
                elseif tone == "neutral" then
                    Say(teller:Say("townNeutral", (company and W.townNeutralWe) or W.townNeutral, tt), not seen, "town")
                else
                    Say(teller:Say("townAlly", (company and W.townAllyWe) or W.townAlly, tt), not seen, "town")
                end
            end
            -- 2. Each stretch in order.
            local previous
            for si, s in ipairs(stretches) do
                sceneAt = si
                local st = {zoneD = Place(s.zone), zoneE = ZoneE(s.zone)}
                currentStretch = {zone = s.zone, st = st}
                local together = #s.with > 0
                for _, e in ipairs(s.events) do if e.k == "boss" and (tonumber(e.n) or 0) >= 3 then together = true end end
                st.We, st.we, st.us, st.our = together and "We" or "I", together and "we" or "I", together and "us" or "me", together and "our" or "my"
                st.were = together and "were" or "was"
                local isDungeon = false
                for _, e in ipairs(s.events) do if e.k == "dungeon" and e.d == s.zone then isDungeon = true end end
                local visitFirst, arrives = false, false
                for _, e in ipairs(s.events) do
                    if e.k == "first" and e.d == "zone" and not e.u and not s.seeded and not history.zones[s.zone or "?"] then visitFirst = true end
                    if e.k == "first" and e.d == "tram" then arrives = true end
                    if e.k == "voyage" then arrives = true end
                    if e.k == "town" and e.d == s.zone then arrives = true end
                end
                st.zoneSaid = si == 1
                for _, e in ipairs(s.events) do
                    if e.k == "town" and e.d == s.zone and not st.arrived then
                        st.arrived = e
                    end
                end
                -- Moving on (a dungeon, a city or the tram says so itself).
                -- (the hearthstone at the end of the stretch before brought you here)
                local hearthed
                for _, e in ipairs(previous and previous.events or {}) do if e.k == "hearth" then hearthed = e end end
                if hearthed then
                    for _, e in ipairs(previous.events) do if (e.t or 0) > (hearthed.t or 0) and e.k ~= "hearth" then hearthed = nil; break end end
                end
                if si > 1 and previous and s.zone ~= previous.zone and not isDungeon and not arrives and hearthed and W.hearthMove then
                    st.zoneSaid = true
                    history.hearthSaid = index
                    Say(teller:Say("hearthMove", W.hearthMove, st))
                elseif si > 1 and previous and s.zone ~= previous.zone and L and L.Dungeon and L.Dungeon(previous.zone) and W.leaveDungeon and not isDungeon then
                    st.zoneSaid = true
                    Say(teller:Say("leaveDungeon", W.leaveDungeon, st), false, "move")
                elseif si > 1 and previous and s.zone ~= previous.zone and CITY_ZONE[previous.zone] == s.zone and W.leaveCity and W.leaveCity[previous.zone] then
                    -- (out of a capital into the land around it: not a journey)
                    st.zoneSaid = true
                    Say(teller:Say("leaveCity", W.leaveCity[previous.zone], st), false, "move")
                elseif si > 1 and previous and s.zone ~= previous.zone and flewTo == s.zone then
                    -- (the flight there was told)
                    st.zoneSaid, flewTo = true, nil
                elseif si > 1 and previous and s.zone ~= previous.zone and not isDungeon and not arrives then
                    st.zoneSaid = true
                    local teleport
                    for _, x in ipairs(s.events) do if x.k == "first" and x.d == "class" and x.z == "moonglade" and not x.u then teleport = x end end
                    if visitFirst and teleport and W.classFirst and W.classFirst.moonglade then
                        teleport.skip = true
                        Say(teller:Say("class:moonglade", W.classFirst.moonglade, st), true, "first")
                        Title(64, teller:Pick("tClassmoonglade", (W.titles.classBy and W.titles.classBy.moonglade) or W.titles.class))
                        DescribeZone(Say, s.zone, nil, f.dungeons > 0)
                    elseif visitFirst then
                        st.zoneLore = ZoneLore(s.zone)
                        -- (the plain line: the zone's own words follow)
                        Say(teller:Say("firstZone", Fresh(W.firstZone), st), true, "first")
                        LeftHome(s.zone)
                        -- (not the town this stretch comes to: its own line names it)
                        local towns = {}
                        for _, x in ipairs(s.events) do if x.k == "town" and x.d then towns[#towns + 1] = (Clean(x.d):gsub(" City$", "")) end end
                        DescribeZone(Say, s.zone, towns, f.dungeons > 0)
                        Title(35, s.zone and Clean(s.zone):gsub("^The ", "the "):gsub("^%l", string.upper))
                    elseif (s.e - s.t) < 600 and s.questCount == 0 and #s.events == 0 then
                        Say(teller:Say("moveShort", W.moveShort, st), false, "move")
                    elseif W.moveRoad and (not history.road or index - history.road >= 5) and teller.rng() < 0.3 then
                        history.road = index
                        Say(teller:Say("moveRoad", W.moveRoad, st), false, "move")
                    else
                        st.from = Place(previous.zone)
                        Say(teller:Say("move", W.moveBetween or W.move, st), false, "move")
                    end
                end
                -- Missing early history must not erase the setting of the
                -- adventure we do have. Describe a recorded place once without
                -- claiming this was the character's first visit there.
                if not isDungeon and not CITY_ZONE[s.zone] and s.questCount > 0 and not history.zones[s.zone]
                    and not (origin and not originGap and si == 1) then
                    local towns = {}
                    for _, event in ipairs(s.events) do if event.k == "town" and event.d then towns[#towns + 1] = Clean(event.d):gsub(" City$", "") end end
                    DescribeZone(Say, s.zone, towns, true)
                end
                -- Above your level.
                local range = L and L.ZoneLevels and L.ZoneLevels(s.zone)
                local zoneDanger = Danger(s.level, range and range[1], range and range[2])
                local dungeonToday = false
                for _, s2 in ipairs(stretches) do for _, x in ipairs(s2.events) do if x.k == "dungeon" then dungeonToday = true end end end
                -- (not on a day told as quiet: two moods at odds)
                if not isDungeon and not dungeonToday and history.quietDay ~= index and (zoneDanger == "daring" or zoneDanger == "reckless") and not history.perils[s.zone] then
                    history.perils[s.zone] = true
                    local justNamed = (out[#out] or ""):find(Clean(s.zone):gsub("^The ", ""), 1, true)
                    Say(teller:Say("perilous", (si == 1 and justNamed and W.perilousHere) or W.perilous, st))
                end
                if st.arrived then TownLine(st.arrived, s, st); st.zoneSaid = true end
                currentStretch.zoneSaid = st.zoneSaid
                -- Company that joined along the way.
                local joined = {}
                local back
                local newcomers, bonded = {}, {}
                for _, w in ipairs(s.with) do
                    local name = N(w.name)
                    local last = history.companionLast[w.name]
                    if not companionsSaid[name] and last and dayNumber - last >= 21 and history.reunionChapter ~= index - 1 and not back and not isDungeon then
                        companionsSaid[name] = true
                        back = w
                        history.reunionChapter = index
                        st.names, st.ago = name, Ago(dayNumber - last)
                        Say(teller:Say("reunionJoined", W.reunionJoined, st), true)
                        Title(64, (teller:Pick("tReunion", W.titles.reunion) or ""):gsub("{names}", (Clean(w.name):gsub("%-.*$", ""))))
                    end
                    if not companionsSaid[name] then
                        companionsSaid[name] = true
                        -- (the first time in the book: who they are, "Tarok, a tauren warrior")
                        local info = not history.companions[w.name] and Companion(w.key)
                        local people = info and L and L.People and L.People(info.race)
                        local classWord = info and info.class and ((LOCALIZED_CLASS_NAMES_MALE and LOCALIZED_CLASS_NAMES_MALE[info.class]) or info.class):lower()
                        local who = people and classWord and (people .. " " .. classWord) or classWord or people
                        -- (a bond says it better: "Ragh, my wife")
                        local bondWord = info and info.bond and BOND_WORDS[info.bond] and BOND_WORDS[info.bond][info.pronouns or "they"]
                        if bondWord then
                            bonded[#bonded + 1] = {name = name, word = bondWord}
                        elseif who then
                            newcomers[#newcomers + 1] = name .. ", " .. ((who:match("^[aeiou]") and "an " or "a ") .. who) .. ","
                        end
                        joined[#joined + 1] = name
                    end
                    if not history.companions[w.name] then history.companions[w.name] = true; Title(30, (teller:Pick("tWith", W.titles.with) or ""):gsub("{names}", w.name)) end
                end
                -- someone close (a wife, a friend): who they are to you
                if #bonded > 0 and W.joinedBond then
                    st.names, st.bond = bonded[1].name, bonded[1].word
                    Say(teller:Say("joinedBond", W.joinedBond, st), true)
                    local rest = {}
                    for _, n3 in ipairs(joined) do if n3 ~= bonded[1].name then rest[#rest + 1] = n3 end end
                    joined = rest
                end
                -- someone met for the first time: who they are, in their own sentence
                if openNewSaid and si == 1 then newcomers = {}; joined = {} end
                if #newcomers > 0 and W.joinedNew and not isDungeon then
                    st.names = #newcomers == 1 and newcomers[1]:gsub(",$", "") or List(newcomers):gsub(",$", "")
                    st.newOnes = #newcomers
                    local known = {}
                    for _, n3 in ipairs(joined) do
                        local isNew = false
                        for _, nc in ipairs(newcomers) do if nc:find(n3, 1, true) == 1 then isNew = true end end
                        if not isNew then known[#known + 1] = n3 end
                    end
                    if #known > 0 and W.joinedNewUs then
                        -- (someone new among friends: one sentence for all of them)
                        st.known = List(known)
                        local us = W.joinedNewUs
                        if #newcomers > 1 then us = {us[1], us[2]} end
                        Say(teller:Say("joinedNewUs", us, st), true)
                        known = {}
                    else
                        Say(teller:Say(#newcomers > 1 and "joinedNewMany" or "joinedNew", (#newcomers > 1 and W.joinedNewMany) or W.joinedNew, st), true)
                    end
                    joined = known
                end
                if #joined > 0 and isDungeon then
                    -- (told with going in, below)
                    st.names = List(joined)
                    st.joinedDungeon = true
                elseif #joined > 0 then
                    st.names = List(joined)
                    local most = s.with[1] and s.with[1].seconds >= (s.e - s.t) * 0.75
                    -- (the quiet-day line named them already)
                    if most and si == 1 then
                        if history.weNamedDay ~= index then Say(teller:Say(#joined > 1 and "withMostPlural" or "withMost", #joined > 1 and W.withMostPlural or W.withMost, st), true) end
                    elseif st.zoneSaid then
                        Say(teller:Say("joinedThere", W.joinedThere, st), true)
                        if kinds[#out - 1] == "move" then majors[#out - 1] = true end
                    else Say(teller:Say("joined", W.joined, st), true); st.zoneSaid = true end
                end
                function GatherLine()
                    if st.gatherDone then return end
                    st.gatherDone = true
                    local work = A.JournalGatherClauses and A.JournalGatherClauses(s.gather) or {}
                    if #work > 0 then
                        st.work = List(work)
                        local names = {}
                        local mostKind, most = nil, 0
                        for _, kind in ipairs({"herbs", "mining", "skinning"}) do
                            if (s.gather[kind] or 0) > most and (s.gatherNames or {})[kind] then mostKind, most = kind, s.gather[kind] end
                        end
                        for _, name in ipairs(mostKind and s.gatherNames[mostKind] or {}) do if #names < 2 then names[#names + 1] = Q(name) end end
                        st.names = #names > 0 and List(names) or nil
                        local fishingOnly = s.gather.fishing and not s.gather.herbs and not s.gather.mining and not s.gather.skinning
                        local dock = s.gatherPlace.fishing
                        if dock and not (Town(dock) or dock:find("Harbor") or dock:find("Dock") or dock:find("Pier") or dock:find("Port") or dock:find("Bay")) then dock = nil end
                        if fishingOnly and dock and W.fishAt and teller.rng() < 0.7 then
                            wandered = true
                            st.place = Place(dock)
                            -- (the dock named in the sentence before: "there")
                            local before = (out[#out] or ""):gsub("{%a:([^}]*)}", "%1")
                            if W.fishAtHere and before:find(Clean(dock), 1, true) then Say(teller:Say("fishAtHere", W.fishAtHere, st), quiet)
                            else Say(teller:Say("fishAt", W.fishAt, st), quiet) end
                        elseif quiet and not wandered and fishingOnly and W.quietFish then
                            wandered = true
                            Say(teller:Say("quietFish", W.quietFish, st), true)
                            -- the fish by name ("Raw Longjaw Mud Snapper": the fish, not the raw)
                            local fish = {}
                            for _, name in ipairs((s.gatherNames or {}).fishing or {}) do
                                if #fish < 2 then fish[#fish + 1] = Q((Clean(name):gsub("^Raw ", ""))) end
                            end
                            if #fish > 0 and W.fishNames and teller.rng() < 0.8 then Say(teller:Say("fishNames", W.fishNames, {names = List(fish)}), true) end
                        elseif quiet and not wandered and W.quietWander then
                            wandered = true
                            Say(teller:Say("quietWander", W.quietWander, st), true)
                            -- (hides are what a skinner takes, not the beasts: "most of it Thick Leather")
                            local namesPool = (mostKind == "skinning" and W.gatherNamesHides) or W.gatherNames
                            if st.names and namesPool and teller.rng() < 0.8 then Say(teller:Say("gatherNames", namesPool, st), true, "lore") end
                        elseif st.names and W.gatherNamed and teller.rng() < (profile.gatherer and 0.85 or 0.6) then
                            Say(teller:Say("gatherNamed", (mostKind == "skinning" and W.gatherNamedHides) or W.gatherNamed, st), honest or quiet)
                        else
                            -- ("There," only after the town or the zone was said)
                            local lead = W.gatherLead
                            local lastKind = kinds[#out] or ""
                            if lastKind ~= "town" and lastKind ~= "move" and lastKind ~= "open" then
                                lead = {}
                                for _, line in ipairs(W.gatherLead) do if not line:find("^There") then lead[#lead + 1] = line end end
                            end
                            Say(teller:Say("gather", lead, st), honest or quiet or profile.gatherer)
                        end
                    end
                end
                local townFirst = false
                for _, e in ipairs(s.events) do if e.k == "town" then townFirst = true end end
                if quiet and not townFirst then GatherLine() end
                -- What happened, in order.
                local bosses, pendingKills = {}, {}
                local function FlushKills()
                    if #pendingKills == 0 then return end
                    if #pendingKills == 1 then
                        st.boss = pendingKills[1]
                        -- (the only one of the visit: with what it was, "Herod, the Scarlet Champion")
                        local only = #s.bosses == 1 and L and L.Boss and L.Boss(s.bosses[1].name)
                        local epithet = only and only.e and not st.boss:find(",", 1, true)
                        if epithet then st.boss = st.boss .. ", " .. only.e end
                        local line = teller:Say("killOne", W.killOne, st)
                        -- Close an interrupting subject epithet before its verb;
                        -- an object epithet already ends at the sentence's period.
                        if epithet and line and line:sub(1, #st.boss + 1) == st.boss .. " " then
                            line = st.boss .. "," .. line:sub(#st.boss + 1)
                        end
                        Say(line, true, "kill")
                    else
                        st.bosses = List(pendingKills)
                        local manyPool = W.killMany
                        if st.killSaid then
                            manyPool = {}
                            for _, line in ipairs(W.killMany) do if not line:find("^Inside") then manyPool[#manyPool + 1] = line end end
                        end
                        Say(teller:Say("killMany", manyPool, st), true, "kill")
                    end
                    st.killSaid = true
                    pendingKills = {}
                    -- your part, with the fighting
                    local dn = st.dungeonNow
                    if dn and not dn.roleTold then
                        dn.roleTold = true
                        local role = dn.role
                        if role and W.role[role] and not history.roleSaid[dn.name] and teller.rng() < (role == "damage" and 0.3 or 0.6) then
                            history.roleSaid[dn.name] = true
                            local byClass = W.roleBy and W.roleBy[person.class or ""] and W.roleBy[person.class or ""][role]
                            Say(RoleLine(role, (byClass and teller.rng() < 0.6) and byClass or W.role[role], st), false, "role")
                            st.roleNow = true
                        end
                    end
                end
                local deathsHere = 0
                for _, e in ipairs(s.events) do if e.k == "death" then deathsHere = deathsHere + 1 end end
                -- (counts every death; the first of a life, in a journal from before level ten, is said)
                function FirstDeath(where, death)
                    if history.deaths == 0 and (person.startLevel or 99) <= 9 and W.firstDeath and not st.firstSaid then
                        -- (someone brought you back: no corpse run to tell)
                        local rezzed = false
                        for _, x in ipairs(s.events) do
                            if death and x.k == "rez" and (x.t or 0) >= (death.t or 0) and (x.t or 0) - (death.t or 0) <= 1200 then rezzed = true end
                        end
                        local pool = race == "Scourge" and W.firstDeathScourge or W.firstDeath
                        if rezzed and W.firstDeathRez then pool = W.firstDeathRez end
                        -- (at level 20 and more, not the new soul's grey world)
                        if (s.level or 0) >= 20 and W.firstDeathLate then
                            pool = W.firstDeathLate
                            local kept = {}
                            for _, line in ipairs(pool) do if not line:find("{foe}", 1, true) then kept[#kept + 1] = line end end
                            if #kept > 0 then pool = kept end
                        end
                        -- ("and not my last" only when a later death is in the book)
                        if history.deaths + 1 >= totalDeaths then
                            local kept = {}
                            for _, line in ipairs(pool) do if not line:find("not my last", 1, true) then kept[#kept + 1] = line end end
                            if #kept > 0 then pool = kept end
                        end
                        Say(teller:Say("firstDeath", pool, where), true)
                        Title(62, teller:Pick("tFirstDeath", W.titles.firstDeath))
                    end
                    history.deaths = history.deaths + 1
                end
                for _, e in ipairs(s.events) do if e.k == "death" and e.told then e.counted = true end end
                -- one line per thing won: the famous name over "legendary" over "epic"
                local ITEM_RANK = {famous = 3, legendary = 2, epic = 1}
                for _, e in ipairs(s.events) do
                    if e.k == "first" and ITEM_RANK[e.d] and e.z then
                        for _, x in ipairs(s.events) do
                            if x ~= e and x.k == "first" and ITEM_RANK[x.d] and x.z == e.z and ITEM_RANK[x.d] < ITEM_RANK[e.d] then x.skip = true end
                        end
                    end
                    -- a battleground's first time says it all
                if e.k == "first" and e.d == "battleground" and e.z and not e.u then
                    for _, x in ipairs(s.events) do if x.k == "bg" and x.d == e.z then x.skip = true end end
                end
                -- a class mount (warhorse, felsteed) is the first mount, said once
                if e.k == "first" and (e.d == "mount" or e.d == "epicmount") then
                    for _, x in ipairs(s.events) do
                        if x.k == "first" and x.d == "class" and (x.z == "warhorse" or x.z == "felsteed" or x.z == "charger" or x.z == "dreadsteed") then e.skip = true end
                    end
                end
                -- a first raid is told as you go in
                    if e.k == "first" and e.d == "raid" and e.z then
                        for _, x in ipairs(s.events) do if x.k == "dungeon" and x.d == e.z and not x.raidFirst then x.raidFirst = e; e.skip = true end end
                    end
                end
                -- (an earlier chapter already stood on that continent: no "first time" there)
                for _, e in ipairs(s.events) do
                    if e.k == "first" and e.d == "continent" and e.z and history.continents[e.z] then e.u = true end
                end
                -- (a rare you killed: the sighting goes without saying; of a trade's marks in one day, the highest)
                for _, e in ipairs(s.events) do
                    if e.k == "rarekill" and e.d then
                        for _, x in ipairs(s.events) do if x.k == "first" and x.d == "rarebeast" and x.z == e.d then x.skip = true end end
                    elseif e.k == "skill" and e.d then
                        for _, x in ipairs(s.events) do if x.k == "skill" and x.d == e.d and (x.c or 0) < (e.c or 0) then x.skip = true end end
                    end
                end
                -- the same bad end twice or more (falls, the water)
                local sameEnv = {}
                for _, e in ipairs(s.events) do if e.k == "death" and e.env and not e.d then sameEnv[e.env] = (sameEnv[e.env] or 0) + 1 end end
                function Milestone(e)
                    if e.d == "notable" and e.n then
                        local lore = W.notableNPCs and W.notableNPCs[e.n]
                        local nt = {name = N(e.n), place = Place(e.z or s.zone)}
                        Say(teller:Say(e.interaction and "notableSpoke" or "notableSeen", e.interaction and W.notableSpoke or W.notableSeen, nt), true, "first")
                        history.notableNPC = history.notableNPC or {}
                        if lore and not history.notableNPC[e.n] then Say(teller:Say("notableLore:" .. e.n, lore, nt), true, "lore") end
                        history.notableNPC[e.n] = true
                        Title(62, Clean(e.n))
                        return
                    end
                    if (e.d == "mount" or e.d == "epicmount") and not e.u and #f.levels > 0 and not levelsSaid and not e.afterLevel then
                        e.afterLevel = true
                        afterLevel[#afterLevel + 1] = e
                        return
                    end
                    if e.u then
                        -- unsure: the moment without the claim (or nothing, for the everyday ones)
                        local line = A.JournalUnsureFirst and A.JournalUnsureFirst(e)
                        -- (the zone said already: "there")
                        if line and e.d == "pvp" and e.z and table.concat(out, " "):gsub("{%a:([^}]*)}", "%1"):find(Clean(e.z), 1, true) then
                            line = line:gsub(" in [^,]+, and one", " there, and one")
                        end
                        local loot = e.d == "epic" or e.d == "legendary" or e.d == "famous" or e.d == "tier" or e.d == "setfull" or e.d == "rare"
                        if line then Say(line, true, loot and "loot" or "first") end
                        -- (a raid or a world boss still names the day)
                        if line and (e.d == "raid" or e.d == "worldboss") and e.z then Title(70, Clean(e.z)) end
                        return
                    end
                    local name = e.z and Clean(e.z) or ""
                    local what = (e.d == "epic" or e.d == "legendary" or e.d == "famous" or e.d == "tier" or e.d == "setfull") and Q(name) or Place(name)
                    local pool = (e.d == "landmark" and W.landmarkLore and W.landmarkLore[name]) or W.milestone2[e.d]
                    -- (an east-facing coast: the sun goes down behind you)
                    if e.d == "sunset" and EAST_COASTS[name] and W.milestone2.sunsetEast then pool = W.milestone2.sunsetEast end
                    -- (a sunset watched together: "Ragh and I")
                    local mt = {what = what}
                    if e.d == "sunset" and #s.with > 0 and W.milestone2.sunsetWe then
                        local names = {}
                        for _, w in ipairs(s.with) do names[#names + 1] = N(w.name) end
                        mt.names = List(names)
                        pool = (EAST_COASTS[name] and W.milestone2.sunsetEastWe) or W.milestone2.sunsetWe
                    end
                    -- (the first mount by its kind, when the recorder read it)
                    if e.d == "mount" and e.n and W.mountFirstKind and W.mountFirstKind[e.n] then pool = W.mountFirstKind[e.n] end
                    if e.d == "epicmount" and e.n and W.epicMountKind and W.epicMountKind[e.n] then pool = W.epicMountKind[e.n] end
                    pool = Fresh(pool)
                    if e.d == "pvp" and W.milestone2.pvpHere and currentStretch and currentStretch.zone == e.z and currentStretch.zoneSaid then pool = W.milestone2.pvpHere end
                    local loot = e.d == "epic" or e.d == "legendary" or e.d == "famous" or e.d == "tier" or e.d == "setfull" or e.d == "rare"
                    local mline = teller:Say("m:" .. e.d, pool, mt)
                    -- (loot from a dungeon's fights: after your part in them)
                    if loot and st.dungeonNow then st.lootAfter = st.lootAfter or {}; table.insert(st.lootAfter, mline)
                    else Say(mline, true, loot and "loot" or "first") end
                    if (e.d == "famous" or e.d == "legendary") and ITEM_LORE[name] then Say(ITEM_LORE[name][teller.rng(#ITEM_LORE[name])], true, "lore") end
                    local rank = ({raid = 88, famous = 92, legendary = 92, worldboss = 86, setfull = 84, epicmount = 83, mount = 80,
                        tier = 78, epic = 76, landmark = 74, pvp = 72, sunset = quiet and 66 or 55})[e.d] or 60
                    local t = teller:Pick("t:" .. e.d, W.titles[e.d] or {"{what}"})
                    Title(rank, t and (t:gsub("{what}", (name:gsub("%%", "")))))
                    -- (the other titles of the pool, a little lower: one an earlier chapter has not used)
                    for _, other in ipairs(W.titles[e.d] or {}) do Title(rank - 0.5, (other:gsub("{what}", (name:gsub("%%", ""))))) end
                end
                local questAnchors = {}
                for _, e in ipairs(s.events) do
                    if e.k ~= "boss" then FlushKills() end
                    local eventStart = #out
                    if e.skip then
                        e.skip = nil
                    elseif e.k == "first" and e.d == "sunset" and quiet and not sunsetLater then
                        -- (a quiet day ends on it)
                        sunsetLater = e
                    elseif e.k == "first" and e.d == "worldboss" and e.z and W.worldbossDied then
                        local died
                        for _, x in ipairs(s.events) do if x.k == "death" and x.d == e.z and not x.told then died = x end end
                        if died then
                            died.told = true
                            Say(teller:Say("worldbossDied", W.worldbossDied, {what = Place(e.z), kind = e.z == "Lord Kazzak" and "demon" or "dragon"}), true, "first")
                            local t = teller:Pick("t:worldboss", W.titles.worldboss or {"{what}"})
                            Title(86, t and (t:gsub("{what}", (Clean(e.z):gsub("%%", "")))))
                        else
                            Milestone(e)
                        end
                    elseif e.k == "first" and not e.u and e.d == "foeseen" and W.foeSeen then
                        local ft = {zoneD = Place(e.z or s.zone), side = faction == "Horde" and "Alliance" or "Horde",
                            aRace = e.n and ((Clean(e.n):match("^[AEIOUaeiou]") and "an " or "a ") .. Clean(e.n):lower()) or "one of them",
                            class = e.c and Clean(e.c):lower() or ""}
                        ft.ARace = Cap(ft.aRace)
                        local here = (e.z or s.zone) == s.zone and st.zoneSaid and W.foeSeenHere
                        local placeLines = W.foeSeenPlace and W.foeSeenPlace[e.z or s.zone]
                        local line = teller:Say(placeLines and "foeSeenPlace" or here and "foeSeenHere" or "foeSeen", placeLines or Fresh(here or W.foeSeen), ft)
                        Say((line:gsub(" %.", "."):gsub(" ,", ",")), true)
                        Title(48, teller:Pick("tFoeSeen", W.titles.foeSeen))
                    elseif e.k == "first" and not e.u and e.d == "battleground" and e.z and W.battleground then
                        Say(teller:Say("battleground", Fresh(W.battleground), {what = Place(e.z), mySide = faction or "my side"}), true, "first")
                        Title(68, Clean(e.z))
                    elseif e.k == "first" and not e.u and e.d == "class" and e.z and W.classFirst and W.classFirst[e.z] then
                        local pool = (W.classFirstRace and W.classFirstRace[race] and W.classFirstRace[race][e.z]) or W.classFirst[e.z]
                        if e.z == "pet" and not e.n then pool = W.classFirst.petPlain end
                        if e.z == "aquatic" then history.swimDay = index end
                        local classLine = teller:Say("class:" .. e.z, Fresh(pool), {family = e.n and Clean(e.n):lower() or ""})
                        -- (a quest turned in before it, or with it, earned it: said after the quests)
                        local questAfter = false
                        for _, q in ipairs(s.quests) do
                            local qs = L and L.QuestStory and L.QuestStory(q.title, q.qid)
                            if (q.t or 0) <= (e.t or 0) + 60 or (qs and qs.covers == e.z) then questAfter = true end
                        end
                        if questAfter then st.classAfter = st.classAfter or {}; table.insert(st.classAfter, {line = classLine, z = e.z})
                        else Say(classLine, true, "first") end
                        Title(64, teller:Pick("tClass" .. e.z, (W.titles.classBy and W.titles.classBy[e.z]) or W.titles.class))
                    elseif e.k == "first" and not e.u and e.d == "rezother" and W.rezOther then
                        local byClass = e.n and W.rezOtherBy and W.rezOtherBy[person.class or ""]
                        -- (the Light is for the priests of humans, dwarves and gnomes; others by their race)
                        if person.class == "PRIEST" and not LIGHT_RACES[race] then byClass = e.n and W.rezOtherByRace and W.rezOtherByRace[race] end
                        local pool = byClass or (e.n and W.rezOther) or W.rezOtherPlain
                        -- (a book begun late cannot know it was the first)
                        if (person.startLevel or 1) >= 11 and e.n and W.rezOtherLate then pool = W.rezOtherLate end
                        Say(teller:Say("rezOther", Fresh(pool), {who = e.n and N(e.n) or ""}), true, "first")
                        local rezTitles = W.titles.rezOther
                        if (person.startLevel or 1) >= 11 then
                            rezTitles = {}
                            for _, t in ipairs(W.titles.rezOther) do if not t:find("First", 1, true) then rezTitles[#rezTitles + 1] = t end end
                        end
                        Title(57, teller:Pick(#rezTitles < #W.titles.rezOther and "tRezOtherLate" or "tRezOther", rezTitles))
                    elseif e.k == "first" and not e.u and e.d == "rare" and e.z and W.rare then
                        Say(teller:Say("rare", Fresh(W.rare), {what = Q(e.z)}), true, "first")
                        Title(36, teller:Pick("tRare", W.titles.rare))
                    elseif e.k == "first" and not e.u and e.d == "snow" and e.z and W.snowFirst then
                        Say(teller:Say("snowFirst", Fresh(Unnamed(W.snowFirst, e.z == s.zone and st.zoneSaid)), {zoneD = Place(e.z)}), true, "first")
                        Title(56, teller:Pick("tSnow", W.titles.snow))
                    elseif e.k == "first" and not e.u and e.d == "rarebeast" and e.z and W.rareBeastKilled and (function()
                        for _, x in ipairs(s.events) do
                            if x.k == "death" and x.d and Clean(x.d) == Clean(e.z) and (x.t or 0) >= (e.t or 0) and not x.told then return true end
                        end
                    end)() then
                        for _, x in ipairs(s.events) do
                            if x.k == "death" and x.d and Clean(x.d) == Clean(e.z) and (x.t or 0) >= (e.t or 0) then x.told = true end
                        end
                        Say(teller:Say("rareBeastKilled", W.rareBeastKilled, {what = Place(e.z), zoneD = Place(e.sz or s.zone)}), true, "death")
                        Title(42, Clean(e.z))
                    elseif e.k == "first" and not e.u and e.d == "rarebeast" and e.z and W.rareBeast then
                        Say(teller:Say("rareBeast", Fresh(NotThere(Unnamed(W.rareBeast, (e.sz or s.zone) == s.zone and st.zoneSaid), (st.watered and kinds[#out] ~= "town") or kinds[#out] == "town" or (out[#out] or ""):find("{p:[^}]*}, "))), {what = Place(e.z), zoneD = Place(e.sz or s.zone)}), true, "first")
                        Title(42, Clean(e.z))
                    elseif e.k == "first" and not e.u and e.d == "aucsale" and e.z and W.aucSale then
                        local madeHere = false
                        for _, line in pairs(s.craft) do for _, m in ipairs(line.made or {}) do if Clean(m) == Clean(e.z) then madeHere = true end end end
                        -- (a book begun late cannot know it was the first sale)
                        local salePool = W.aucSale
                        if (person.startLevel or 1) >= 11 then
                            salePool = {}
                            for _, line in ipairs(W.aucSale) do if not line:find("first", 1, true) then salePool[#salePool + 1] = line end end
                            if #salePool == 0 then salePool = W.aucSale end
                        end
                        local sale = teller:Say("aucSale", salePool, {what = Q(e.z)})
                        if madeHere then st.afterCraft = st.afterCraft or {}; table.insert(st.afterCraft, sale)
                        else Say(sale, true, "first") end
                        Title(34, teller:Pick("tAuction", W.titles.auction))
                    elseif e.k == "swim" and e.d and W.swim and not st.swum then
                        st.swum = true
                        local swimPool = W.swim
                        local nearly
                        for _, x in ipairs(s.events) do
                            if (x.k == "close" or x.k == "death") and x.env == "DROWNING" then
                                local kept = {}
                                for _, l in ipairs(W.swim) do if not l:find("drown", 1, true) then kept[#kept + 1] = l end end
                                if #kept > 0 then swimPool = kept end
                                if x.k == "close" and (x.t or 0) >= (e.t or 0) and not nearly then nearly = x end
                            end
                        end
                        if nearly and W.swimNearly then
                            -- (the swim and the near drowning, one sentence)
                            nearly.told = true
                            closeToday = true
                            Say(teller:Say("swimNearly", W.swimNearly, {place = Place(e.d)}), true)
                            st.watered = true
                        elseif teller.rng() < 0.8 then
                            Say(teller:Say("swim", swimPool, {place = Place(e.d)}))
                            st.watered = true
                        end
                    elseif e.k == "read" and e.d and W.read and not e.told then
                        -- the stretch's reading: books in one line (three names at most), each stone its own
                        local books, stones = {}, {}
                        for _, x in ipairs(s.events) do
                            if x.k == "read" and x.d and not x.told then
                                x.told = true
                                local stone = x.m == "stone" or x.m == "bronze" or x.m == "marble"
                                if stone then stones[#stones + 1] = x else books[#books + 1] = x end
                            end
                        end
                        history.read = history.read or {}
                        local fresh, again = {}, {}
                        for _, x in ipairs(books) do
                            if history.read[x.d] then again[#again + 1] = x else fresh[#fresh + 1] = x end
                            history.read[x.d] = true
                        end
                        if #fresh == 1 then
                            Say(teller:Say("read", W.read, {what = Q(fresh[1].d)}), true, "read")
                            Title(38, Clean(fresh[1].d))
                        elseif #fresh > 1 then
                            local names = {}
                            for n2 = 1, math.min(3, #fresh) do names[n2] = Q(fresh[n2].d) end
                            Say(teller:Say("readMany", W.readMany, {whats = List(names)}), true, "read")
                        end
                        if #again > 0 and W.readAgain then Say(teller:Say("readAgain", W.readAgain, {what = Q(again[1].d)}), false, "read") end
                        for _, x in ipairs(stones) do
                            Say(teller:Say("readStone", W.readStone, {what = Q(x.d)}), not history.read[x.d], "read")
                            history.read[x.d] = true
                        end
                    elseif e.k == "explore" and e.d and W.explore and not st.exploreSaid then
                        st.exploreSaid = true
                        local names = s.explored
                        if #names == 0 then names = {e.d} end
                        local shown = {}
                        for n2 = 1, math.min(3, #names) do shown[n2] = Place(names[n2]) end
                        local rest = #names - #shown
                        local et = {places = List(shown), rest = Words(rest)}
                        local pool = rest > 0 and W.exploreMore or (#names == 1 and W.exploreOne or W.explore)
                        local before = history.explored or 0
                        history.explored = before + #names
                        Say(teller:Say("explore", pool, et), (profile.explorer and #names >= 2) or #names >= 4, "explore")
                        if #names >= 2 then Title(32, teller:Pick("tExplore", W.titles.explore)) end
                        for mark, lines in pairs(W.exploreTally or {}) do
                            if before < mark and history.explored >= mark then
                                Say(teller:Say("exploreTally", lines, {origin = history.originPlace or Place(first.zone)}), true, "explore")
                            end
                        end
                    elseif e.k == "taxi" and e.d and W.taxi then
                        local said = table.concat(out, " "):gsub("{%a:([^}]*)}", "%1"):find(Clean(e.d), 1, true)
                        Say(teller:Say("taxi", (said and W.taxiHere) or W.taxi, {place = Place(e.d)}), false, "taxi")
                    elseif e.k == "learn" and (e.c or 0) > 0 and W.learn then
                        local names = {}
                        for _, n2 in ipairs(e.m or {}) do names[#names + 1] = Q(n2) end -- (a thing's name, like an item's)
                        if #names > 0 then
                            local rest = (e.c or 0) - #names
                            Say(teller:Say("learn", rest > 0 and W.learnMore or W.learn, {names = List(names), rest = Words(rest)}), false, "learn")
                        end
                    elseif e.k == "rep" and e.d and W.rep and A.JournalStandingWord and A.JournalStandingWord(e.s) and W.rep[A.JournalStandingWord(e.s)] then
                        local word = A.JournalStandingWord(e.s)
                        local ft = {faction = FactionName(e.d)}
                        ft.Faction = Cap(ft.faction)
                        Say(teller:Say("rep" .. word, W.rep[word], ft), (tonumber(e.s) or 0) >= 6, "first")
                        if (tonumber(e.s) or 0) >= 7 then
                            Title(e.s == 8 and 62 or 52, ((teller:Pick("tRep", W.titles.rep) or ""):gsub("{Faction}", (Clean(e.d):gsub("^[Tt]he ", "")))))
                        end
                    elseif e.k == "duel" and e.d and W.duelWon and not e.told then
                        -- every duel with the same person that stretch, in one line
                        local same, wins = {}, 0
                        for _, x in ipairs(s.events) do
                            if x.k == "duel" and x.d == e.d and not x.told then
                                x.told = true
                                same[#same + 1] = x
                                if x.w == "won" then wins = wins + 1 end
                            end
                        end
                        local dt = {who = N(e.d)}
                        dt.Who = dt.who
                        history.duels = history.duels or {}
                        local record = history.duels[e.d] or {w = 0, l = 0}
                        history.duels[e.d] = record
                        if #same >= 2 then
                            dt.count, dt.wins = Words(#same), (wins == 0 and "none") or (wins == #same and "all") or Words(wins)
                            Say(teller:Say("duelSeries", W.duelSeries, dt), true, "first")
                        else
                            local pool = (e.w == "won" and ((e.fled and W.duelWonFled) or W.duelWon)) or ((e.fled and W.duelLostFled) or W.duelLost)
                            Say(teller:Say("duel", pool, dt), true, "first")
                        end
                        record.w, record.l = record.w + wins, record.l + (#same - wins)
                        if record.w + record.l >= 3 and W.duelRecord and (index - (history.duelRecordSaid or -99)) >= 5 then
                            history.duelRecordSaid = index
                            dt.wins, dt.losses = Words(record.w), Words(record.l)
                            Say(teller:Say("duelRecord", W.duelRecord, dt), false, "first")
                        end
                        Title(54, teller:Pick("tDuel", W.titles.duel))
                    elseif e.k == "skill" and e.d and e.c and W.skill and W.skill[e.c] then
                        local trade = Clean(e.d):lower()
                        Say(teller:Say("skill" .. e.c, W.skill[e.c], {trade = trade}), e.c == 300, "first")
                        if e.c == 300 then Title(56, ((teller:Pick("tSkill", W.titles.skill) or ""):gsub("{Trade}", Clean(e.d)))) end
                    elseif e.k == "rarekill" and e.d and W.rareKilled then
                        Say(teller:Say("rareKilled", W.rareKilled, {what = Place(e.d)}), true, "first")
                        Title(50, Clean(e.d))
                    elseif e.k == "hk" and (s.hk or 0) > 0 and W.hk then
                        -- (said at the end of the stretch, after the fighting; the first win says itself)
                        local firstPvp = false
                        for _, x in ipairs(s.events) do if x.k == "first" and x.d == "pvp" and not x.u then firstPvp = true end end
                        local n = s.hk
                        local ht = {count = Words(n), side = faction == "Horde" and "Alliance" or "Horde", zoneD = Place(s.zone)}
                        ht.Count, ht.Side = Cap(ht.count), ht.side
                        if firstPvp then
                            if n >= 2 then st.hkLine = {teller:Say("hkAfterFirst", W.hkAfterFirst, ht), n >= 3} end
                        else
                            st.hkLine = {teller:Say(n == 1 and "hkOne" or "hk", n == 1 and W.hkOne or W.hk, ht), n >= 3}
                        end
                        history.honorKills = (history.honorKills or 0) + n
                        if n >= 3 then Title(50, ((teller:Pick("tHk", W.titles.hk) or ""):gsub("{Side}", ht.side))) end
                    elseif e.k == "nightflight" and W.nightFlight and (index - (history.nightFlight or -99)) >= 5 then
                        -- (where the flight took you: the next stretch)
                        local nextZone
                        for n2 = 1, #stretches do if stretches[n2] == s and stretches[n2 + 1] then nextZone = stretches[n2 + 1].zone end end
                        if nextZone then
                            history.nightFlight = index
                            flewTo = nextZone
                            st.nightLine = teller:Say("nightFlight", W.nightFlight, {to = Place(nextZone)})
                        end
                    elseif e.k == "guild" and e.d and W.guild then
                        local gt = {guild = (Clean(e.d):gsub("^The ", "the "))}
                        local guildLines = {}
                        for _, line in ipairs(W.guild) do
                            if not line:find("tabard", 1, true) and not (line:find("one of {guild}", 1, true) and not Clean(e.d):find("^The ")) then guildLines[#guildLines + 1] = line end
                        end
                        Say(teller:Say("guild", guildLines, gt), true, "first")
                        Title(58, ((teller:Pick("tGuild", W.titles.guild) or ""):gsub("{guild}", Clean(e.d))))
                    elseif e.k == "home" and e.d and W.home then
                        local named = not brief and table.concat(out, " "):find(Clean(e.d), 1, true)
                        Say(teller:Say("home", (named and W.homeHere) or W.home, {place = Place(e.d)}), true, "first")
                        Title(44, teller:Pick("tHome2", W.titles.newHome))
                    elseif e.k == "bg" and e.d and W.bgAgain and not (history.bgDay == index and history.bgToday[e.d]) then
                        if history.bgDay ~= index then history.bgDay, history.bgToday = index, {} end
                        history.bgToday[e.d] = true
                        history.bgSeen = history.bgSeen or {}
                        local n = 0
                        for _, s2 in ipairs(stretches) do for _, x in ipairs(s2.events) do if x.k == "bg" and x.d == e.d then n = n + 1 end end end
                        local bt = {what = Place(e.d), mySide = faction or "my side", times = n == 2 and "twice" or (Words(n) .. " times")}
                        local seen = history.bgSeen[e.d]
                        history.bgSeen[e.d] = true
                        if n >= 2 and W.bgTimes then Say(teller:Say(seen and "bgTimesAgain" or "bgTimes", (seen and W.bgTimesAgain) or W.bgTimes, bt), true)
                        elseif not seen and W.bgOnce then Say(teller:Say("bgOnce", W.bgOnce, bt), true)
                        else Say(teller:Say("bgAgain", W.bgAgain, bt)) end
                        Title(52, Clean(e.d))
                    elseif e.k == "first" and e.d == "notable" then
                        Milestone(e)
                    elseif e.k == "first" and e.u and e.d == "class" and e.z and W.classAgain and W.classAgain[e.z] then
                        Say(teller:Say("classAgain" .. e.z, W.classAgain[e.z], {}), true)
                    elseif e.k == "first" and e.u then
                        Milestone(e)
                    elseif e.k == "voyage" and e.d and e.told then
                        e.told = nil
                    elseif e.k == "voyage" and e.d and (function()
                        -- (the first landing says the crossing too)
                        for _, x in ipairs(s.events) do if x.k == "first" and x.d == e.d and not x.u and W.voyageFirstLand and W.voyageFirstLand[e.d] then
                            for _, y in ipairs(s.events) do if y.k == "first" and y.d == "continent" and not y.u then return true end end
                        end end
                    end)() then
                        e.told = nil
                    elseif e.k == "voyage" and e.d then
                        local vt = {to = e.to and Place(e.to) or "the other shore"}
                        Say(teller:Say("voyage" .. e.d, W.voyage[e.d] or W.voyage.boat, vt), e.d == "zeppelin" or e.d == "boat")
                        if e.d == "zeppelin" or e.d == "boat" then Title(58, teller:Pick("tVoyage", W.titles.voyage)) end
                    elseif e.k == "first" and (e.d == "zeppelin" or e.d == "boat") and W.voyageFirstLand and W.voyageFirstLand[e.d]
                        and (function() for _, x in ipairs(s.events) do if x.k == "first" and x.d == "continent" and x.z and not x.u then return true end end end)() then
                        -- (the ride and the land, together)
                        local land
                        for _, x in ipairs(s.events) do if x.k == "first" and x.d == "continent" and x.z and not x.u then land = x end end
                        land.skip = true
                        Say(teller:Say("voyageFirstLand" .. e.d, W.voyageFirstLand[e.d], {to = Place(land.z)}), true, "first")
                        Title(66, ((teller:Pick("tContinent", W.titles.continent) or ""):gsub("{to}", Clean(land.z))))
                    elseif e.k == "first" and (e.d == "zeppelin" or e.d == "boat") then
                        Say(teller:Say("voyageFirst" .. e.d, Fresh(W.voyageFirst[e.d]), st), true, "first")
                        Title(65, teller:Pick("tVoyage", W.titles.voyage))
                    elseif e.k == "first" and e.d == "continent" and e.z then
                        local ct = {to = Place(e.z)}
                        Say(teller:Say("continentFirst", Fresh(W.continentFirst), ct), true, "first")
                        Title(66, ((teller:Pick("tContinent", W.titles.continent) or ""):gsub("{to}", Clean(e.z))))
                    elseif e.k == "first" and W.milestone2 and W.milestone2[e.d] then
                        -- a milestone of a life
                        Milestone(e)
                    elseif e.k == "first" and e.d == "tram" then
                        Say(teller:Say("tram", (W.tramRace and W.tramRace[race]) or Fresh(W.tram), st), true, "first"); Title(60, teller:Pick("tTram", W.titles.tram))
                    elseif e.k == "first" and e.d == "flight" then
                        Say(teller:Say("flight", Fresh(W.flight), st), true, "first"); Title(55, teller:Pick("tFlight", W.titles.flight))
                    elseif (e.k == "town" or e.k == "rest") and e.d and Town(e.d) and not st["town:" .. e.d] then
                        TownLine(e, s, st)
                        if quiet then GatherLine() end
                    elseif e.k == "rest" and not (e.d and st["town:" .. e.d]) then
                        -- (a rest in a town already told is left to the town's line)
                        st.place = Place(e.d or s.zone or "the inn")
                        Say(teller:Say("inn", W.inn, st), false, "rest")
                    elseif e.k == "campfire" then
                        local fire = together and teller:Say("campfireWe", W.campfireWe, st) or teller:Say("campfire", W.campfire, st)
                        local lastQuest = 0
                        for _, q in ipairs(s.quests) do lastQuest = math.max(lastQuest, q.t or 0) end
                        if lastQuest > (e.t or 0) then
                            Say(fire, false, "rest")
                            times[#out] = e.t
                        else
                            st.restAfter = st.restAfter or {}
                            table.insert(st.restAfter, fire)
                        end
                    elseif e.k == "cave" and e.d then
                        st.cave = Place(e.d)
                        -- (a death or a close call down there is told with it)
                        local inCave
                        for _, x in ipairs(s.events) do
                            if (x.k == "death" or (x.k == "close" and deathsToday == 0)) and x.sz == e.d and x.d and not inCave then inCave = x end
                        end
                        if inCave then
                            st.foe = (inCave.a and ((Clean(inCave.d):match("^[AEIOUaeiou]") and "an " or "a ")) or "") .. Place(inCave.d)
                            st.Foe = Cap(st.foe)
                            local cavePool = inCave.k == "death" and ((together and W.caveDeathWe) or W.caveDeath) or W.caveClose
                            Say(teller:Say(inCave.k == "death" and "caveDeath" or "caveClose", cavePool, st), true)
                            inCave.told = true
                            inCave.counted = true
                            if inCave.k == "death" then Title(45, teller:Pick("tDeath", W.titles.death)); FirstDeath(st, inCave)
                            else closeToday = true; Title(40, teller:Pick("tClose", W.titles.close)) end
                        else
                            Say(teller:Say("cave", teller.rng() < 0.3 and W.caveDark or W.cave, st), true)
                            history.caves = (history.caves or 0) + 1
                            if W.caveTally and W.caveTally[history.caves] and profile.caver and not history.tallySaid["c" .. history.caves] then
                                history.tallySaid["c" .. history.caves] = true
                                Say(teller:Say("caveTally", W.caveTally[history.caves], st), false, "first")
                            end
                        end
                    elseif e.k == "dungeon" and e.d then
                        local info = L and L.Dungeon and L.Dungeon(e.d)
                        st.dungeonE, st.dungeonD = Place(e.d), Place(e.d)
                        if info and info.e and teller.rng() < 0.3 then
                            local short = {}
                            for _, x in ipairs(info.e) do if not x:find(",") then short[#short + 1] = x end end
                            if #short > 0 then st.dungeonE = short[teller.rng(#short)] end
                        end
                        local lv = L and L.DungeonLevels and L.DungeonLevels(e.d)
                        -- (your level when you went in: the dungeon's own line keeps it)
                        local level = s.level
                        for _, x in ipairs(s.entries) do if x.k == "dungeon" and (x.d == e.d or x.z == e.d) and x.pl then level = tonumber(x.pl) end end
                        local danger = Danger(level, lv and lv[1], lv and lv[2])
                        if danger ~= "fair" and danger ~= "revisit" then st.dungeonE = Place(e.d) end
                        -- In and out: nothing fought inside, and the next thing recorded was outside it within five minutes.
                        local inside, outAfter = false, nil
                        for _, b in ipairs(s.bosses) do if b.where == e.d then inside = true end end
                        for _, x in ipairs(s.entries) do
                            if (x.t or 0) > (e.t or 0) and x.z and x.z ~= e.d and (not outAfter or x.t - e.t < outAfter) then outAfter = x.t - e.t end
                        end
                        if isDungeon then outAfter = (s.e - s.t) end
                        local fled = not inside and outAfter and outAfter <= 300 and (danger == "daring" or danger == "reckless")
                        local visits = history.dungeonVisits[e.d] or 0
                        local story = L and L.DungeonStory and L.DungeonStory(e.d)
                        -- (the first dungeon of your life: only when the journal began before dungeons do)
                        local firstEver = history.dungeonsEver == 0 and inside and history.earlyCoverage and not s.seeded
                        st.dungeonSaid = not isDungeon
                        -- An entry is still a visit when no boss fight was recorded.
                        -- Sparse earlier visits must rule out a later first-ever claim.
                        history.dungeonsEver = history.dungeonsEver + 1
                        if inside then
                            -- Keep the first substantive setting introduction
                            -- available after a sparse entry with no fights recorded.
                            history.dungeonVisits[e.d] = visits + 1
                            st.dungeonNow = {name = e.d, r = e.r, first = firstEver, story = story, visits = visits}
                            -- (what it was like inside: said with the first fight; one line, the detail by preference)
                            st.dungeonNow.insideNext = visits == 0 and story and (story.inside or story.detail)
                        end
                        if fled then
                            if st.joinedDungeon then st.joinedDungeon = nil; Say(teller:Say("joinedPlain", W.joinedPlain, st), true) end
                            Say(teller:Say("dungeonFled", W.dungeonFled, st), true)
                        elseif e.raidFirst then
                            if st.joinedDungeon then st.joinedDungeon = nil; Say(teller:Say("joinedPlain", W.joinedPlain, st), true) end
                            Milestone(e.raidFirst)
                            e.raidFirst = nil
                        elseif e.introduced then
                            e.introduced = nil
                            if st.joinedDungeon then st.joinedDungeon = nil; Say(teller:Say("joinedPlain", W.joinedPlain, st), true) end
                        else
                            local pool = W.dungeon[danger == "revisit" and "easy" or danger] or W.dungeon.fair
                            if (danger == "fair" or danger == "revisit") and UNDERGROUND[e.d] and W.dungeonDown and teller.rng() < 0.5 then pool = W.dungeonDown end
                            if visits == 1 and W.dungeonAgain and not st.joinedDungeon and teller.rng() < 0.6 then
                                Say(teller:Say("dungeonAgain", W.dungeonAgain, st), true)
                            elseif visits >= 2 and W.dungeonRegular and not st.joinedDungeon and teller.rng() < (profile.dungeoneer and 0.7 or 0.4) then
                                Say(teller:Say("dungeonRegular", W.dungeonRegular, st), true)
                            elseif st.joinedDungeon and W.dungeonWith and W.dungeonWith[danger] then
                                st.joinedDungeon = nil
                                Say(teller:Say("dungeonWith" .. danger, W.dungeonWith[danger], st), true)
                            else
                                if st.joinedDungeon then
                                    st.joinedDungeon = nil
                                    Say(teller:Say("joinedPlain", W.joinedPlain, st), true)
                                end
                                Say(teller:Say("dungeon" .. danger, pool, st), true)
                            end
                        end
                        -- A first visit: why you went, right after going in.
                        local classWhy = story and story.whyClass and story.whyClass[person.class or ""]
                        if person.class == "PRIEST" and not LIGHT_RACES[race] then classWhy = nil end
                        local why = story and ((story.whyRace and story.whyRace[race]) or classWhy or story.why)
                        if why and L.WithoutBosses and why == story.why then
                            local bossesHere = {}
                            for _, b in ipairs(s.bosses) do bossesHere[#bossesHere + 1] = b.name end
                            why = L.WithoutBosses(why, bossesHere) or why
                        end
                        if not fled and inside and why and visits == 0 then
                            Say(PickLore(why), true, "lore")
                            -- (one line of your own people a visit)
                            if story.whyRace and story.whyRace[race] and why == story.whyRace[race] then st.raceSaid = true end
                        end

                    elseif e.k == "boss" and e.d then
                        local dn = st.dungeonNow
                        if dn and dn.insideNext then
                            dn.insideNext = nil
                            -- the concrete thing seen there, or what the place was like
                            local sight = L and L.DungeonSight and L.DungeonSight(dn.name, s.bosses)
                            local detail, insideLines = (sight and sight.detail) or dn.story.detail, (sight and sight.inside) or dn.story.inside
                            if not st.raceSaid and dn.story.detailRace and dn.story.detailRace[race] then detail = dn.story.detailRace[race] end
                            if not st.raceSaid and dn.story.insideRace and dn.story.insideRace[race] then insideLines = dn.story.insideRace[race]; detail = nil end
                            -- (not a line that names a boss the kills are about to name)
                            local bossesHere = {}
                            for _, b in ipairs(s.bosses) do bossesHere[#bossesHere + 1] = b.name end
                            if L.WithoutBosses then detail = L.WithoutBosses(detail, bossesHere) end
                            if L.WithoutBosses then insideLines = L.WithoutBosses(insideLines, bossesHere) or (not detail and insideLines) or nil end
                            local list = (detail and (not insideLines or teller.rng() < 0.6)) and detail or insideLines
                            -- (your own people's line, on a first visit, is the one to say)
                            local raceLine = not st.raceSaid and ((dn.story.insideRace and dn.story.insideRace[race]) or (dn.story.detailRace and dn.story.detailRace[race]))
                            if raceLine and (dn.visits or 0) == 0 then list = raceLine end
                            if list then Say(PickLore(list), (dn.visits or 0) == 0, "lore") end
                        end
                        if dn and not dn.roleTried then
                            dn.roleTried = true
                            dn.role = L and L.Role and L.Role(dn.r, e.me)
                        end
                        local dead = st.partyDead and st.partyDead[e.d]
                        local outcome = L and L.Boss and L.Boss(e.d)
                        if outcome and outcome.victory then
                            FlushKills()
                            if dead then
                                st.names, st.foe, st.Foe = List(dead), Place(e.d), Place(e.d)
                                Say(teller:Say("partyDeathFoe", W.partyDeath.foe, st), true, "death")
                            end
                            Say(PickLore(outcome.victory), true, "kill")
                            if st.partyDead then st.partyDead[e.d] = nil end
                        elseif st.wonAfterWipe and st.wonAfterWipe[e.d] then
                            -- (already told with the lost fight)
                            st.wonAfterWipe[e.d] = nil
                        elseif dead then
                            FlushKills()
                            st.names, st.foe, st.Foe = List(dead), Place(e.d), Place(e.d)
                            Say(teller:Say("partyDeathCostly", W.partyDeath.foeCostly, st), true, "death")
                            st.partyDead[e.d] = nil
                        elseif (history.killers[e.d] or 0) > 0 and W.bossRevengeLater and not history.avenged[e.d] and not (function()
                            for _, x in ipairs(s.events) do if x.k == "wipe" and x.d == e.d then return true end end
                        end)() then
                            -- (it killed you on an earlier day; today it fell)
                            FlushKills()
                            history.avenged[e.d] = true
                            st.boss = Place((L and L.Short and L.Short(e.d)) or e.d)
                            st.Boss = st.boss
                            Say(teller:Say("bossRevengeLater", W.bossRevengeLater, st), true, "kill")
                            Title(66, (L and L.Short and L.Short(e.d)) or Clean(e.d))
                        else
                            pendingKills[#pendingKills + 1] = Place(e.d)
                        end
                        bosses[#bosses + 1] = e.d
                    elseif e.k == "wipe" and e.d and W.wipeThenWin and (function()
                        local boss = L and L.Boss and L.Boss(e.d)
                        if boss and boss.victory then return false end
                        for _, x in ipairs(s.events) do if x.k == "boss" and x.d == e.d and (x.t or 0) > (e.t or 0) then return true end end
                    end)() then
                        -- (the same boss fell later: "beat us the first time, and fell the second"; the kill roll leaves it out)
                        FlushKills()
                        st.boss = Place(e.d)
                        Say(teller:Say("wipeThenWin", W.wipeThenWin, st), true)
                        st.wonAfterWipe = st.wonAfterWipe or {}
                        st.wonAfterWipe[e.d] = true
                    elseif e.k == "wipe" and e.d then
                        st.boss = Place(e.d)
                        Say(teller:Say("wipe", W.wipe, st), true)
                    elseif e.k == "pdeath" and e.n and W.partyDeath and not e.boss then
                        -- someone of your party died, no boss to tell it with (those who died with them, in one line)
                        if not e.told then
                            FlushKills()
                            local dead = {}
                            for _, x in ipairs(s.events) do
                                if x.k == "pdeath" and x.n and not x.boss and not x.told and math.abs((x.t or 0) - (e.t or 0)) <= 120 then
                                    x.told = true
                                    dead[#dead + 1] = N(x.n)
                                end
                            end
                            -- (your first raise of that one comes next, and says the death: no line here)
                            local raised = false
                            for _, x in ipairs(s.events) do
                                if x.k == "first" and x.d == "rezother" and x.n and #dead == 1 and (x.t or 0) >= (e.t or 0)
                                    and Clean(x.n):gsub("%-.*$", "") == Clean(e.n):gsub("%-.*$", "") then raised = true end
                            end
                            -- (the same companion again, later in the stretch: one line with the count)
                            local again = 0
                            if #dead == 1 then
                                for _, x in ipairs(s.events) do
                                    if x.k == "pdeath" and x.n and not x.boss and not x.told and Clean(x.n) == Clean(e.n) then x.told = true; again = again + 1 end
                                end
                            end
                            st.names = List(dead)
                            local pool = raised and {} or W.partyDeath.plain
                            if again > 0 and W.partyDeath.twice and not raised then
                                st.count = again == 1 and "twice" or (Words(again + 1) .. " times")
                                pool = W.partyDeath.twice
                            end
                            if #dead > 1 then
                                -- ("was killed" for one name only)
                                pool = {}
                                for _, line in ipairs(W.partyDeath.plain) do if not line:find(" was ", 1, true) then pool[#pool + 1] = line end end
                            end
                            if #pool > 0 then Say(teller:Say("partyDeathPlain", pool, st), true, "death") end
                        end
                    elseif e.k == "pdeath" and e.n and W.partyDeath then
                        -- someone of your party died: with the boss that killed them, when it fell after
                        FlushKills()
                        st.partyDead = st.partyDead or {}
                        local key = e.boss or "?"
                        st.partyDead[key] = st.partyDead[key] or {}
                        table.insert(st.partyDead[key], N(e.n))
                    elseif e.k == "death" and e.env and not e.d and (sameEnv[e.env] or 0) >= 2 and W.deathsSame and W.deathsSame[e.env] then
                        -- the same end again and again: told once, with the count
                        if not st["same:" .. e.env] then
                            st["same:" .. e.env] = true
                            local n = sameEnv[e.env]
                            st.count = n == 2 and "twice" or (Words(n) .. " times")
                            Say(teller:Say("same" .. e.env, W.deathsSame[e.env], st), true, "death")
                            if clumsy and not history.clumsyDay and W.misadventure then
                                history.clumsyDay = index
                                Say(teller:Say("misadventure", W.misadventure, st), false, "death")
                                Title(47, teller:Pick("tClumsy", W.titles.misadventure))
                            end
                            Title(46, e.env == "FALLING" and teller:Pick("tFall", W.titles.fall) or teller:Pick("tDeath", W.titles.death))
                        end
                        if e.env == "FALLING" then history.falls = (history.falls or 0) + 1 end
                        history.deaths = history.deaths + 1
                    elseif e.k == "death" and (e.pr or e.pc) and st.pvpDied and ((st.pvpDeaths or 0) >= 2 or (function()
                        -- (three or more in the stretch: the first, then the count; no "again")
                        local n = 0
                        for _, x in ipairs(s.events) do if x.k == "death" and (x.pr or x.pc) then n = n + 1 end end
                        return n >= 3 and W.deathPvpMany ~= nil
                    end)()) then
                        -- (the third and more: counted below)
                        st.pvpDeaths = st.pvpDeaths + 1
                        history.deaths = history.deaths + 1
                    elseif e.k == "death" and (e.pr or e.pc) and W.deathPvp and not e.told then
                        st.pvpDeaths = (st.pvpDeaths or 0) + 1
                        local side = faction == "Horde" and "Alliance" or "Horde"
                        local theirRace = e.pr and Clean(e.pr):lower()
                        local theirClass = e.pc and Clean(e.pc):lower() or "fighter"
                        -- "an undead rogue"; with no race known, "a rogue"
                        local lead = theirRace or theirClass
                        local pt = {side = side, aRace = (lead:match("^[aeiou]") and "an" or "a") .. (theirRace and (" " .. theirRace) or ""), class = theirClass}
                        pt.ARace = Cap(pt.aRace)
                        local again = st.pvpDied and W.deathPvpAgain
                        local line = teller:Say(again and "deathPvpAgain" or "deathPvp", again or W.deathPvp, pt)
                        -- (a race only one side has needs no "of the Alliance")
                        if theirRace then line = line:gsub(", one of the " .. side, ""):gsub(" of the " .. side, "") end
                        Say((line:gsub(" %.", "."):gsub("  ", " ")), true, "death")
                        st.pvpDied = true
                        -- ("Caught Alone" only when you were)
                        local pvpTitles = W.titles.pvpDeath
                        if together then
                            pvpTitles = {}
                            for _, t in ipairs(W.titles.pvpDeath) do if not t:find("Alone", 1, true) then pvpTitles[#pvpTitles + 1] = t end end
                        end
                        Title(55, teller:Pick(together and "tPvpDeathWe" or "tPvpDeath", pvpTitles))
                        FirstDeath(st, e)
                    elseif e.k == "death" and e.d and W.guardDeath and not e.told and (Clean(e.d):find("Guard") or Clean(e.d):find("Grunt")
                        or Clean(e.d):find("Bluffwatcher") or Clean(e.d):find("Sentinel")) then
                        -- (the guards of the last town named in the stretch, else the zone)
                        local guardTown
                        for _, x in ipairs(s.events) do if x.k == "town" and (x.t or 0) <= (e.t or 0) then guardTown = x.d end end
                        Say(teller:Say("guardDeath", W.guardDeath, {place = Place(guardTown or e.z or s.zone)}), true, "death")
                        Title(50, teller:Pick("tGuard", W.titles.guard))
                        FirstDeath(st, e)
                    elseif e.k == "death" and e.boss and not e.told and (function()
                        for _, x in ipairs(s.events) do if x.k == "wipe" and x.d == e.boss then return true end end
                    end)() then
                        -- (the lost fight was told: you were one of those who fell)
                        history.deaths = history.deaths + 1
                    elseif e.k == "death" and deathsHere <= 2 and not e.told then
                        local foe = e.d and ((e.a and ((Clean(e.d):match("^[AEIOUaeiou]") and "an " or "a ")) or "") .. Place(e.d))
                        st.foe, st.sub = foe, e.sz and Place(e.sz)
                        local pool = foe and W.death.foe or W.death[e.env or ""] or W.death.plain
                        if e.env == "FALLING" and history.swimDay == index and W.deathFallIrony and not history.fallIrony then
                            history.fallIrony = true
                            pool = W.deathFallIrony
                        end
                        if foe and e.sz and A.SelfUnderground and A.SelfUnderground(e.sz) then pool = W.deathIn end
                        -- far below your level: the one place for a joke
                        local zl = L and L.ZoneLevels and L.ZoneLevels(e.z or s.zone)
                        if foe and W.deathShameful and not (L.Boss and L.Boss(e.d)) and ((zl and s.level and s.level >= zl[2] + 8) or (L.Humble and L.Humble(Clean(e.d)))) then
                            pool = W.deathShameful
                            if not (zl and s.level and s.level >= zl[2] + 8) then
                                local kept = {}
                                for _, line in ipairs(pool) do if not line:find("level", 1, true) then kept[#kept + 1] = line end end
                                pool = kept
                            end
                            st.inZone = st.zoneSaid and "there" or ("in " .. Place(e.z or s.zone))
                        end
                        local cause = e.d and Clean(e.d) or e.env or "?"
                        if foe and history.deathDay == index and history.deathCause and history.deathCause ~= cause and W.deathAgainDay then
                            st.Foe = Cap(foe)
                            pool = W.deathAgainDay
                        elseif foe and (history.killers[cause] or 0) >= 1 and W.deathAgainFoe and not (e.a and (history.killers[cause] or 0) < 2) then
                            -- (a named foe that killed you before, on an earlier day)
                            st.Foe = Cap(foe)
                            local n = history.killers[cause] + 1
                            st.nth = ({"first", "second", "third", "fourth", "fifth", "sixth", "seventh", "eighth", "ninth", "tenth"})[n] or (tostring(n) .. "th")
                            st.count = Words(n)
                            pool = (n >= 3 and W.deathAgainFoeMany) or W.deathAgainFoe
                        end
                        history.deathDay, history.deathCause = index, cause
                        local sinceDeath = history.lastDeathDay and (dayNumber - history.lastDeathDay) or nil
                        Say(teller:Say("death", pool, st), true, "death")
                        if sinceDeath and sinceDeath >= 21 and W.deathAfterLong and (index - (history.longRunSaid or -99)) >= 5 and pool ~= W.deathShameful then
                            history.longRunSaid = index
                            Say(teller:Say("deathAfterLong", W.deathAfterLong, {span = Ago(sinceDeath)}), false, "death")
                        end
                        Title(45, e.env == "FALLING" and teller:Pick("tFall", W.titles.fall) or teller:Pick("tDeath", W.titles.death))
                        if e.env == "FALLING" then
                            history.falls = (history.falls or 0) + 1
                            if history.falls >= 3 and W.fallCount and not history.fallCounted then
                                history.fallCounted = true
                                local nth = ({"first", "second", "third", "fourth", "fifth", "sixth", "seventh", "eighth", "ninth", "tenth"})[history.falls]
                                if nth then Say(teller:Say("fallCount", W.fallCount, {nth = nth}), true) end
                            end
                        end
                        -- a foe everyone has a story about
                        local infamous = e.d and W.infamous and W.infamous[Clean(e.d)]
                        local infamousLine = infamous and not history.infamous[Clean(e.d)] and infamous[teller.rng(#infamous)]
                        if infamousLine then history.infamous[Clean(e.d)] = true end
                        if infamousLine then Say(infamousLine, true, "lore"); Title(60, Clean(e.d)) end
                        if infamousLine and infamousLine:find("first", 1, true) then st.firstSaid = true end
                        local firstOne = history.deaths == 0 and (person.startLevel or 99) <= 9
                        FirstDeath(st, e)
                        if not firstOne and e.walk and e.walk >= 180 and W.ghostWalk and teller.rng() < 0.6 then
                            Say(teller:Say("ghostWalk", W.ghostWalk, {span = Span(e.walk)}), true)
                        end
                    elseif e.k == "death" and not e.counted then
                        history.deaths = history.deaths + 1
                    elseif e.k == "rez" and e.by and (function()
                        for _, x in ipairs(s.events) do if x.k == "death" and (x.t or 0) <= (e.t or 0) then return true end end
                    end)() then
                        st.by = N(e.by)
                        -- someone never travelled with: a stranger's kindness
                        local known = false
                        for name in pairs(history.companionTime) do
                            if Clean(name):gsub("%-.*$", ""):lower() == Clean(e.by):gsub("%-.*$", ""):lower() then known = true end
                        end
                        for _, w in ipairs(s.with) do if Clean(w.name):gsub("%-.*$", ""):lower() == Clean(e.by):lower() then known = true end end
                        -- a friend's rez told by their class (the spirits, the Light), from the people list
                        local byClass
                        if known and W.rezBy and A.db and A.db.people then
                            local short = Clean(e.by):gsub("%-.*$", ""):lower()
                            for _, info in pairs(A.db.people) do
                                if info.name and Clean(info.name):gsub("%-.*$", ""):lower() == short then byClass = W.rezBy[info.class or ""] end
                            end
                        end
                        if byClass and teller.rng() < 0.7 then Say(teller:Say("rezBy", byClass, st), true, "rez")
                        else Say(teller:Say(known and "rez" or "rezStranger", (known or not W.rezStranger) and W.rez or W.rezStranger, st), true, "rez") end
                    elseif e.k == "close" and (deathsToday == 0 or (clumsy and e.env)) and not closeToday and not e.told then
                        closeToday = true
                        local foe = e.d and ((e.a and ((Clean(e.d):match("^[AEIOUaeiou]") and "an " or "a ")) or "") .. Place(e.d))
                        if (e.pr or e.pc) and not e.d then
                            -- one of the other side: what they were, not their name
                            local theirRace, theirClass = e.pr and Clean(e.pr):lower(), e.pc and Clean(e.pc):lower() or "fighter"
                            local lead = theirRace or theirClass
                            foe = (lead:match("^[aeiou]") and "an " or "a ") .. (theirRace and (theirRace .. " ") or "") .. theirClass
                                .. (theirRace and "" or (" of the " .. (faction == "Horde" and "Alliance" or "Horde")))
                        end
                        st.foe, st.sub = foe, e.sz and Place(e.sz)
                        local pool = foe and W.close.foe or W.close[e.env or ""] or W.close.plain
                        if foe and e.sz and A.SelfUnderground and A.SelfUnderground(e.sz) then pool = W.closeIn end
                        Say(teller:Say("close", pool, st), true, "death")
                        Title(40, teller:Pick("tClose", W.titles.close))
                    end
                    if s.questCount > 0 then
                        -- Keep a quest hand-in between two encounters from
                        -- being enclosed by one combined kill sentence; kills
                        -- with nothing turned in between them stay one sentence.
                        local nextEvent
                        for n2 = 1, #s.events do if s.events[n2] == e then nextEvent = s.events[n2 + 1] end end
                        local handInBetween = false
                        if e.k == "boss" and nextEvent and nextEvent.k == "boss" then
                            for _, q in ipairs(s.quests) do
                                if (q.t or 0) > (e.t or 0) and (q.t or 0) < (nextEvent.t or 0) then handInBetween = true end
                            end
                        end
                        if not (e.k == "boss" and nextEvent and nextEvent.k == "boss") or handInBetween then FlushKills() end
                        if #out > eventStart and (e.k == "death" or e.k == "wipe" or e.k == "boss" or e.k == "dungeon") then
                            questAnchors[#questAnchors + 1] = {first = eventStart + 1, last = #out, t = e.t or 0, kind = e.k, zone = e.d}
                        end
                    end
                end
                FlushKills()
                if st.hkLine then Say(st.hkLine[1], st.hkLine[2], "death"); st.hkLine = nil end
                if (st.pvpDeaths or 0) >= 2 and W.deathPvpMany and (function()
                    local n = 0
                    for _, x in ipairs(s.events) do if x.k == "death" and (x.pr or x.pc) then n = n + 1 end end
                    return n >= 3
                end)() then
                    st.count, st.side = Words(st.pvpDeaths), faction == "Horde" and "Alliance" or "Horde"
                    Say(teller:Say("deathPvpMany", W.deathPvpMany, st), true, "death")
                elseif deathsHere > 2 then st.count = Words(deathsHere); Say(teller:Say("deaths", W.deaths, st), true); Title(45, teller:Pick("tDeath", W.titles.death)) end
                -- a clumsy day, said once
                if clumsy and not history.clumsyDay and W.misadventure then
                    local envHere = 0
                    for _, e in ipairs(s.events) do if (e.k == "death" or e.k == "close") and e.env then envHere = envHere + 1 end end
                    if envHere >= 2 and teller.rng() < 0.8 then
                        history.clumsyDay = index
                        Say(teller:Say("misadventure", W.misadventure, st))
                        Title(47, teller:Pick("tClumsy", W.titles.misadventure))
                    end
                end
                -- After the fights: your part, a deed worth saying, then what the lord's
                -- fall meant (always last), or for the first dungeon of your life a last word.
                local dn = st.dungeonNow
                local consequence = false
                if dn then
                    local firstBoss
                    for _, x in ipairs(s.events) do if x.k == "boss" and not firstBoss then firstBoss = x end end
                    local role = dn.role or (L and L.Role and L.Role(dn.r, firstBoss and firstBoss.me))
                    if not dn.roleTold and role and W.role[role] and not history.roleSaid[dn.name] and teller.rng() < (role == "damage" and 0.3 or 0.6) then
                        history.roleSaid[dn.name] = true
                        local byClass = W.roleBy and W.roleBy[person.class or ""] and W.roleBy[person.class or ""][role]
                        if byClass and deathsHere > 0 then byClass = nil end
                        Say(RoleLine(role, (byClass and teller.rng() < 0.6) and byClass or W.role[role], st), false, "role")
                        st.roleNow = true
                    end
                    if history.boastDay ~= index then
                        local lastKill
                        for _, x in ipairs(s.events) do if x.k == "boss" then lastKill = x end end
                        for _, x in ipairs(s.events) do
                            local me = x == lastKill and x.me
                            local lord = x.k == "boss" and L and L.Boss and L.Boss(x.d) and L.Boss(x.d).last
                            if me and (x.n or 0) >= 3 and history.boastDay ~= index and teller.rng() < (lord and 0.6 or 0.25) then
                                local bt = {boss = Place((L.Short and L.Short(x.d)) or x.d), weapon = L.Weapon and L.Weapon(person.class) or "strikes"}
                                local line
                                if role == "tank" and me.t == 1 then line = teller:Say("boastT", W.boast.tank, bt)
                                elseif me.d == 1 and (me.ds or 0) >= 30 and role ~= "healer" then line = teller:Say("boastD", W.boast.damage, bt)
                                elseif role == "healer" and me.h == 1 and deathsHere == 0 and not st.roleNow then line = teller:Say("boastH", W.boast.healer, bt) end
                                -- (the boss just named by the kill line: "We killed Mekgineer Thermaplugg, and my spells did most of the work.")
                                local before = (out[#out] or ""):gsub("{%a:([^}]*)}", "%1")
                                if line and W.boastHereTank and role == "tank" and me.t == 1 and before:find(Clean(x.d) .. "%.$") and not before:find(" and ", 1, true) then
                                    -- ("We brought down Baron Rivendare, and I took the blows the whole fight.")
                                    local tail = teller:Say("boastHereTank", W.boastHereTank, bt) or ""
                                    if not tail:match("^I ") then tail = tail:gsub("^%u", string.lower) end
                                    out[#out] = out[#out]:gsub("%.$", "") .. ", and " .. tail
                                    majors[#out] = true
                                    history.boastDay = index
                                    line = nil
                                end
                                if line and W.boastHere and me.d == 1 and role ~= "tank" and role ~= "healer" and before:find(Clean(x.d) .. "%.$")
                                    and not before:find(" and ", 1, true) then
                                    local tail = (teller:Say("boastHere", W.boastHere, bt) or ""):gsub("^%u", string.lower)
                                    out[#out] = out[#out]:gsub("%.$", "") .. ", and " .. tail
                                    majors[#out] = true
                                    history.boastDay = index
                                    line = nil
                                end
                                if line then Say(line, true, "role"); history.boastDay = index end
                            end
                        end
                    end
                end
                for _, line in ipairs(st.lootAfter or {}) do Say(line, true, "loot") end
                st.lootAfter = nil
                -- A lord's fall, first time only: what it meant (Lore).
                for _, b in ipairs(bosses) do
                    local lore = L and L.Boss and L.Boss(b)
                    if lore and lore.last then Title(70, (L.Short and L.Short(b)) or b) end
                    if lore and lore.after and not history.bosses[b] then
                        local countBefore = #out
                        Say((not st.raceSaid and lore.afterRace and lore.afterRace[race]) or lore.after, true, "lore")
                        if #out > countBefore then consequenceAt = #out end
                        consequence = true
                    end
                    history.bosses[b] = true
                end
                if dn then
                    if dn.first then
                        if deathsHere == 0 and not consequence then Say(teller:Say("firstDungeonEnd", W.firstDungeonEnd, st), true) end
                        Title(78, teller:Pick("tFirstDungeon", W.titles.firstDungeon))
                    end
                    st.dungeonNow = nil
                end
                -- The quests ("there" would point at a dungeon just told).
                local function Here(list)
                    local lastLine = out[#out] or ""
                    if not (st.dungeonSaid or lastLine:find(" there", 1, true)) or not list then return list end
                    local kept = {}
                    for _, line in ipairs(list) do if not line:find(" there", 1, true) then kept[#kept + 1] = line end end
                    return #kept > 0 and kept or list
                end
                -- A quest with a story (Lore): why it was asked, or what came of it, once a life.
                local loreQuest, loreStory, loreWhy, loreCallback
                local questBeats, narratedQuests = {}, {}
                local selectedQuests = {}
                local questPlaces = {}
                local function AnchorQuestPlace(start, quest, at)
                    if not quest or not out[start + 1] then return end
                    local zone = s.zone
                    for _, entry in ipairs(s.entries) do
                        if entry.k == "quest" and entry.t == quest.t
                            and ((quest.qid and entry.qid == quest.qid) or (not quest.qid and entry.d == quest.title)) then
                            zone = entry.z or zone
                            break
                        end
                    end
                    local dungeon
                    for _, event in ipairs(questAnchors) do
                        if event.kind == "dungeon" and event.t <= (quest.t or 0) and event.first <= at
                            and (not dungeon or event.t >= dungeon.t) then dungeon = event end
                    end
                    if not dungeon or not zone or dungeon.zone == zone or questPlaces[dungeon] == zone then return end
                    -- The record places this work outside the just-narrated
                    -- dungeon. Establish that fact, without inventing a return.
                    local line = out[start + 1]
                    local lowerLead = {The = "the", A = "a", An = "an", We = "we", Our = "our", It = "it", Other = "other", Reports = "reports", Four = "four", Seeking = "seeking", Beyond = "beyond",
                        There = "there", This = "this", That = "that", They = "they", Their = "their",
                        At = "at", In = "in", Before = "before", After = "after", With = "with", From = "from"}
                    -- ("In Silverpine Forest, Maps..." : a word the chapter or the quest's own lines also
                    -- use in lower case is a common noun; a name keeps its capital)
                    local story = L and L.QuestStory and L.QuestStory(quest.title, quest.qid)
                    local corpus = table.concat(out, " ")
                    for _, list in ipairs({story and story.why or {}, story and story.after or {}, story and story.highlight or {}}) do
                        corpus = corpus .. " " .. table.concat(list, " ")
                    end
                    corpus = corpus:gsub("{%a:([^}]*)}", "%1")
                    line = line:gsub("^(%a+) ", function(word)
                        if lowerLead[word] then return lowerLead[word] .. " " end
                        local low = word:lower()
                        if low ~= word and corpus:find("%f[%a]" .. low .. "%f[%A]") then return low .. " " end
                        return word .. " "
                    end)
                    out[start + 1] = "In " .. Place(zone) .. ", " .. line
                    questPlaces[dungeon] = zone
                end
                local function PlaceQuestPassage(start, quest)
                    local stop, at = #out, start
                    for _, event in ipairs(questAnchors) do
                        if (quest.t or 0) < event.t then at = math.min(at, event.first - 1); break end
                    end
                    AnchorQuestPlace(start, quest, at)
                    if at >= start or stop <= start then return end
                    local count = stop - start
                    -- Move the complete setup/action/outcome, with its metadata.
                    -- The original journal and the book's scene are untouched.
                    for _, arr in ipairs({out, majors, kinds, times, scenes}) do
                        local saved = {}
                        for n = 1, count do saved[n] = arr[start + n] end
                        for n = start, at + 1, -1 do arr[n + count] = arr[n] end
                        for n = 1, count do arr[at + n] = saved[n] end
                    end
                    for _, event in ipairs(questAnchors) do
                        if event.first > at then event.first = event.first + count end
                        if event.last > at then event.last = event.last + count end
                    end
                end
                local function OtherQuestsBefore(nextQuest)
                    -- Uncurated work belongs at its recorded position, not in
                    -- a tail list after a later authored chain resolution.
                    -- Batch neighboring fallbacks, but never across a selected
                    -- quest or a recorded conflict between their completions.
                    local group = {}
                    local function FlushOtherQuests()
                        if #group == 0 then return end
                        local names = {}
                        for _, q in ipairs(group) do names[#names + 1] = Q(q.title) end
                        local start = #out
                        sayTime = group[#group].t
                        if #group == 1 then
                            st.quest = names[1]
                            Say(teller:Say("questOne", Here(W.questOne), st), true, "questStart")
                        else
                            st.quests = List(names)
                            local few = Here(W.questsFew)
                            if #group ~= 2 then
                                local kept = {}
                                for _, line in ipairs(few) do if not line:find("^Between") then kept[#kept + 1] = line end end
                                if #kept > 0 then few = kept end
                            end
                            Say(teller:Say("questsFew", few, st), true, "questStart")
                        end
                        PlaceQuestPassage(start, group[1])
                        group = {}
                    end
                    for _, q in ipairs(s.quests) do
                        if q == nextQuest then break end
                        if not selectedQuests[q] and not narratedQuests[q] then
                            local previous = group[#group]
                            if previous then
                                for _, event in ipairs(questAnchors) do
                                    if event.t > (previous.t or 0) and event.t <= (q.t or 0) then FlushOtherQuests(); break end
                                end
                            end
                            narratedQuests[q] = true
                            group[#group + 1] = q
                        elseif selectedQuests[q] then
                            FlushOtherQuests()
                        end
                    end
                    FlushOtherQuests()
                end
                local loreStart
                local revengeDay = false
                if L and L.QuestStory then
                    local excluded = {}
                    for _, q in ipairs(s.quests) do
                        local foeQuest = false
                        for _, x in ipairs(s.events) do
                            if (x.k == "death" or x.k == "wipe") and x.d and Clean(q.title):find(Clean(x.d), 1, true) and (x.t or 0) < (q.t or 0) then foeQuest = true end
                        end
                        if foeQuest then revengeDay = true end
                        if foeQuest then excluded[q] = true end
                    end
                    if not revengeDay then
                        -- First recorded authored stages carry distinct work;
                        -- seen exact IDs still compress repeats without a slot cap.
                        questBeats = L.QuestBeats(s.quests, history.questLore, #s.quests, function(q) return excluded[q] end)
                        for _, choice in ipairs(questBeats) do selectedQuests[choice.quest] = true end
                        if questBeats[1] then loreQuest, loreStory = questBeats[1].quest, questBeats[1].story end
                    end
                    if loreQuest then
                        OtherQuestsBefore(loreQuest)
                        loreStart = #out
                        narratedQuests[loreQuest] = true
                        history.questLore[loreQuest.qid or loreQuest.title] = true
                        local previousThread = loreStory.thread and history.storyThreads[loreStory.thread]
                        if (not loreQuest.qid or not loreStory.why) and previousThread and previousThread.day < index and loreStory.threadLabel and history.threadCallback ~= index then
                            local since = previousThread.first and (dayNumber - previousThread.first) or 0
                            if since >= 7 and W.threadSince and not previousThread.sinceSaid then
                                -- (taken up again after a week or more: since when, not "the work continued")
                                previousThread.sinceSaid = true
                                local span = Ago(since)
                                Say(teller:Say("threadSince", W.threadSince, {thread = loreStory.threadLabel, span = span, Span = Cap(span)}), true, "lore")
                            else
                                Say(teller:Say("questReturn", W.questReturn, {thread = loreStory.threadLabel, We = st.We, we = st.we, us = st.us, Our = Cap(st.our)}), true, "lore")
                            end
                            history.threadCallback = index
                            loreCallback = true
                        end
                        if loreStory.thread then
                            history.storyThreads[loreStory.thread] = {day = index, title = loreQuest.title, first = previousThread and previousThread.first or dayNumber,
                                sinceSaid = previousThread and previousThread.sinceSaid}
                        end
                        -- Establish a new assignment through its actual context,
                        -- rather than substituting a vague label for its purpose.
                        -- Each new exact stage still needs its concrete assignment.
                        -- Consume the old choice so unrelated retell draws stay stable.
                        if loreStory.why and previousThread then teller.rng() end
                        loreWhy = loreStory.why and #loreStory.why > 0
                        -- A concrete assignment is required even when its town
                        -- has already appeared in the opener and arrival.
                        if loreWhy then
                            local setup = loreStory.why[teller.rng(#loreStory.why)]
                            if not CompactQuest(loreQuest, loreStory, brief) then Say(setup, true, "lore", true) end
                        end
                    else
                        loreQuest = nil
                    end
                end
                for _, q in ipairs(s.quests) do sayTime = math.max(sayTime or 0, q.t or 0) end
                local killerNamed, revenge = false, nil
                for _, x in ipairs(s.events) do
                    if (x.k == "death" or x.k == "wipe") and x.d then
                        for _, q in ipairs(s.quests) do
                            -- (the quest is the foe's: "Mor'Ladim", 'WANTED: "Hogger"')
                            local same = Clean(q.title) == Clean(x.d)
                            if same or Clean(q.title):find(Clean(x.d), 1, true) then
                                if same then killerNamed = true end
                                -- (the death or the lost fight first, the quest that killed it after: the revenge)
                                if (x.t or 0) < (q.t or 0) then revenge = x.d end
                            end
                        end
                    end
                end
                local savedQuests, savedCount
                if revenge and #s.quests >= 2 and W.questRevenge then
                    savedQuests, savedCount = s.quests, s.questCount
                    local kept, dropped = {}, 0
                    for _, q in ipairs(s.quests) do
                        if Clean(q.title) == Clean(revenge) then dropped = dropped + (q.count or 1) else kept[#kept + 1] = q end
                    end
                    s.quests, s.questCount = kept, s.questCount - dropped
                end
                local questLineAt
                if loreQuest and W.questThread then
                    -- Both editions let an authored outcome carry the completed
                    -- work. Keep the draw for stable subsequent retell choices;
                    -- unknown work still uses the title fallbacks below.
                    st.quest = Q(loreQuest.title)
                    st.thread = not loreCallback and loreStory.threadLabel or nil
                    local completion = teller:Say("questThread", W.questThread, st)
                elseif s.questCount >= 4 and (s.level or person.startLevel or 60) <= 20 and W.questsChapter then
                    -- Early work establishes the character's path. Keep a small
                    -- sequence of names, not a random errand from the whole day.
                    local names, represented = {}, 0
                    for qi, q in ipairs(s.quests) do
                        if qi <= 2 or q == loreQuest or (qi == 3 and (not loreQuest or loreQuest == s.quests[1] or loreQuest == s.quests[2])) then
                            names[#names + 1] = Q(q.title); represented = represented + (q.count or 1)
                        end
                    end
                    st.quests = List(names)
                    local remaining = math.max(0, s.questCount - represented)
                    st.remaining = Words(remaining) .. (remaining == 1 and " other quest" or " other quests")
                    local pool = s.questCount > represented and W.questsChapter or W.questsFew
                    Say(teller:Say("questsChapter", Here(pool), st), false, "quests")
                elseif s.questCount >= 4 then
                    st.count, st.Count = Words(s.questCount), Cap(Words(s.questCount))
                    local notable
                    for _, q in ipairs(s.quests) do if q.count and q.count > 1 then notable = q end end
                    notable = loreQuest or notable or s.quests[teller.rng(#s.quests)]
                    if killerNamed then notable = nil end
                    if notable and notable.count and notable.count > 1 and W.questsMoreRepeat and teller.rng() < 0.6 then
                        st.quest = Q(notable.title)
                        Say(teller:Say("questsMoreRepeat", Here(W.questsMoreRepeat), st), false, "quests")
                    elseif notable and not killerNamed and (loreQuest or teller.rng() < 0.6) then
                        st.quest = Q(notable.title)
                        Say(teller:Say("questsMore", Here(W.questsMore), st), false, "quests")
                    else
                        Say(teller:Say("questsMany", Here(W.questsMany), st), false, "quests")
                    end
                elseif s.questCount >= 2 then
                    local names = {}
                    for _, q in ipairs(s.quests) do names[#names + 1] = Q(q.title) end
                    st.quests = List(names)
                    local few = Here(W.questsFew)
                    if #names ~= 2 then
                        local kept = {}
                        for _, line in ipairs(few) do if not line:find("^Between") then kept[#kept + 1] = line end end
                        if #kept > 0 then few = kept end
                    end
                    Say(teller:Say("questsFew", few, st), false, "quests")
                elseif s.questCount == 1 and s.quests[1] then
                    st.quest = Q(s.quests[1].title)
                    Say(teller:Say("questOne", Here(W.questOne), st), false, "quests")
                elseif #s.events == 0 and not next(s.gather) and not next(s.craft) and (s.e - s.t) >= 1200 and si > 1
                    and not (stretches[si + 1] and L and L.Dungeon and L.Dungeon(stretches[si + 1].zone)) then
                    st.span, st.Span = Span(s.e - s.t), Cap(Span(s.e - s.t))
                    Say(teller:Say("idle", W.idle, st))
                end
                if savedQuests then s.quests, s.questCount = savedQuests, savedCount end
                questLineAt = kinds[#out] == "quests" and #out or nil
                if not loreQuest and questLineAt then AnchorQuestPlace(questLineAt - 1, s.quests[1], questLineAt - 1) end
                if consequenceAt and questLineAt == consequenceAt + 1 and scenes[questLineAt] == scenes[consequenceAt] then
                    -- The quest is the recorded resolution of this same scene;
                    -- let the reflection on the victory close the passage.
                    for _, arr in ipairs({out, majors, kinds, times, scenes}) do arr[consequenceAt], arr[questLineAt] = arr[questLineAt], arr[consequenceAt] end
                    consequenceAt, questLineAt = questLineAt, consequenceAt
                end
                if revenge and W.questRevenge then
                    local line = teller:Say("questRevenge", W.questRevenge, {foe = Place(revenge), Foe = Place(revenge)})
                    -- ("We finished The Legend of Stalvan, and this time it was Mor'Ladim who died.")
                    if savedQuests and line and questLineAt == #out and not out[#out]:find(" and ", 1, true) then
                        out[#out] = out[#out]:gsub("%.$", "") .. ", and " .. line:gsub("^%u", string.lower)
                        majors[#out] = true
                        kinds[#out] = "lore" -- (whole: nothing joins to it)
                    elseif W.questRevengeBare and questLineAt == #out and not out[#out]:find(" and ", 1, true) then
                        -- (the quest says the name: 'We finished WANTED: "Hogger", and this time it went the other way.')
                        local bare = teller:Say("questRevengeBare", W.questRevengeBare, {})
                        out[#out] = out[#out]:gsub("%.$", "") .. ", and " .. bare:gsub("^%u", string.lower)
                        majors[#out] = true
                        kinds[#out] = "lore"
                    else
                        Say(line, true)
                    end
                    Title(66, Clean(revenge))
                end
                if loreQuest and loreStory.after and not (revenge and Clean(loreQuest.title):find(Clean(revenge), 1, true)) then
                    -- A repeated place name can trim optional scenery, never
                    -- the supported consequence of the quest just narrated.
                    Say(QuestEnding(loreQuest, loreStory, brief, teller.rng), true, CompactQuest(loreQuest, loreStory, brief) and "questStart" or "questOutcome", true)
                    -- (a quest's ending that says what the class first says: "the trainer taught the taming of any beast")
                    if loreStory.covers then st.covered = loreStory.covers end
                end
                if loreStart then PlaceQuestPassage(loreStart, loreQuest) end
                -- Connected rites and local work deserve their recorded steps,
                -- not just a title in a list beneath the day's largest victory.
                local previousTitle, previousStory = loreQuest and loreQuest.title, loreStory
                for qi = 2, #questBeats do
                    local chosen = questBeats[qi]
                    local q, qs = chosen.quest, chosen.story
                    OtherQuestsBefore(q)
                    local start = #out
                    narratedQuests[q] = true
                    history.questLore[q.qid or q.title] = true
                    if qs.thread then
                        local before = history.storyThreads[qs.thread]
                        history.storyThreads[qs.thread] = {day = index, title = q.title, first = before and before.first or dayNumber, sinceSaid = before and before.sinceSaid}
                    end
                    sayTime = math.max(sayTime or 0, q.t or 0)
                    local hasSetup = qs.why and #qs.why > 0
                    if hasSetup then
                        local setup = qs.why[teller.rng(#qs.why)]
                        -- (Highlights: an old title-only stage that continues the thread just told keeps its
                        -- outcome and drops the setup; the thread's beginning above already gave the context)
                        local continuing = brief and not q.qid and qs.thread and previousStory and qs.thread == previousStory.thread
                        if not CompactQuest(q, qs, brief) and not continuing then Say(setup, true, "questStart", true) end
                    end
                    if q.title ~= previousTitle then
                        st.quest = Q(q.title)
                        local completion = teller:Say("questThread", W.questThread, st)
                    end
                    Say(QuestEnding(q, qs, brief, teller.rng), true, CompactQuest(q, qs, brief) and CompactBeat(qs, previousStory) or "questOutcome", true)
                    PlaceQuestPassage(start, q)
                    if qs.covers then st.covered = qs.covers end
                    previousTitle, previousStory = q.title, qs
                end
                if loreQuest then OtherQuestsBefore(nil) end
                if brief and loreQuest and W.questOthers then
                    -- Selecting one source-backed scene must not erase the other
                    -- completed work from this stretch. Keep its names after the
                    -- focal outcome so they do not interrupt cause and consequence.
                    local names, seen, meaningful = {}, {}, false
                    for q in pairs(narratedQuests) do seen[q.title] = true end
                    for _, q in ipairs(s.quests) do
                        if not narratedQuests[q] and q.title ~= loreQuest.title and not seen[q.title] then
                            seen[q.title] = true
                            names[#names + 1] = Q(q.title)
                            local qs = L and L.QuestStory and L.QuestStory(q.title, q.qid)
                            if (qs and (qs.importance or 1) >= 4) or (s.level or person.startLevel or 60) <= 20 then meaningful = true end
                        end
                    end
                    if #names > 0 then
                        st.quests = List(names)
                        Say(teller:Say("questOthers", W.questOthers, st), meaningful, "quests")
                    end
                end
                -- Honest work.
                GatherLine()
                local trades = {}
                for trade in pairs(s.craft) do trades[#trades + 1] = trade end
                table.sort(trades)
                for _, trade in ipairs(trades) do
                    local line = s.craft[trade]
                    local made = {}
                    for _, m in ipairs(line.made or {}) do made[#made + 1] = Q(m) end
                    st.trade, st.count, st.made = trade == "crafting" and "trade" or trade:lower(), Words(line.count or 0), List(made)
                    if trade == "Mining" and W.smelt then
                        local metals = {}
                        for _, m in ipairs(line.made or {}) do metals[#metals + 1] = (Clean(m):gsub(" Bar$", ""):lower()) end
                        st.made = #metals > 0 and List(metals) or "metal"
                        Say(teller:Say("smelt", W.smelt, st), honest)
                    elseif (line.count or 0) == 1 and #made == 1 then Say(teller:Say("craftOne", W.craftOne, st), honest)
                    elseif #made > 0 and W.craftBy and W.craftBy[trade] then Say(teller:Say("craftBy" .. trade, W.craftBy[trade], st), honest)
                    elseif #made > 0 then Say(teller:Say("craftMade", W.craftMade, st), honest)
                    elseif (line.count or 0) > 0 then Say(teller:Say("craftPlain", W.craftPlain, st), honest) end
                end
                for _, line in ipairs(st.afterCraft or {}) do Say(line, true, "first") end
                st.afterCraft = nil
                for _, c in ipairs(st.classAfter or {}) do if c.z ~= st.covered then Say(c.line, true, "first") end end
                for _, line in ipairs(st.restAfter or {}) do Say(line, false, "rest") end
                st.restAfter = nil
                st.classAfter = nil
                if st.nightLine then Say(st.nightLine, true); st.nightLine = nil end
                previous = s
                -- Tallies of a life, said once each where they fall (the record so far, never hindsight).
                local questsBefore = history.quests
                history.quests = history.quests + (s.questCount or 0)
                for mark, lines in pairs(W.questTally or {}) do
                    if questsBefore < mark and history.quests >= mark and not history.tallySaid["q" .. mark] then
                        history.tallySaid["q" .. mark] = true
                        Say(teller:Say("questTally", lines, st), mark >= 250, "first")
                    end
                end
                local dungeonsHere = 0
                for _, e in ipairs(s.events) do if e.k == "dungeon" then dungeonsHere = dungeonsHere + 1 end end
                if dungeonsHere > 0 then
                    for mark, lines in pairs(W.dungeonTally or {}) do
                        if history.dungeonsEver >= mark and history.dungeonsEver - dungeonsHere < mark and not history.tallySaid["d" .. mark] then
                            history.tallySaid["d" .. mark] = true
                            Say(teller:Say("dungeonTally", lines, st), false, "first")
                        end
                    end
                end
                if deathsHere > 0 then
                    for mark, lines in pairs(W.deathTally or {}) do
                        if history.deaths >= mark and history.deaths - deathsHere < mark and not history.tallySaid["x" .. mark] then
                            history.tallySaid["x" .. mark] = true
                            Say(teller:Say("deathTally", lines, st), false, "first")
                        end
                    end
                    history.lastDeathDay = dayNumber
                end
                -- Who killed you, and where: the next chapters may look back on it.
                for _, e in ipairs(s.events) do
                    if e.k == "death" then
                        local foe = e.boss or e.d
                        if foe then
                            local name = Clean(foe)
                            history.killers[name] = (history.killers[name] or 0) + 1
                            if e.d and not e.boss then
                                local said = (e.a and ((name:match("^[AEIOUaeiou]") and "an " or "a ")) or "") .. Place(e.d)
                                history.zoneMemory[s.zone or "?"] = {foe = said, day = dayNumber}
                            end
                        end
                    end
                end
                -- The continents the record has stood on.
                if ZONE_CONTINENT[s.zone or "?"] then history.continents[ZONE_CONTINENT[s.zone]] = true end
                for _, e in ipairs(s.events) do if e.k == "voyage" and e.to then history.continents[e.to] = true end end
                history.zones[s.zone or "?"] = dayNumber
                for _, entry in ipairs(s.entries) do
                    if entry.z and (entry.k == "quest" or entry.k == "play" or entry.k == "rest") then history.zones[entry.z] = dayNumber end
                end
                history.playTime = (history.playTime or 0) + (s.e - s.t)
                for _, w in ipairs(s.with) do
                    history.companionLast[w.name] = dayNumber
                    history.companionTime[w.name] = (history.companionTime[w.name] or 0) + (w.seconds or 0)
                end
            end
            local levelsDone = false
            local LevelsLineNow
            local function LevelsLine()
                local countBefore = #out
                LevelsLineNow()
                -- (said right after a lord's consequence: the level goes before it, the consequence stays last)
                if consequenceAt and consequenceAt == countBefore and #out > countBefore then
                    local last, k = #out, #out - countBefore
                    for _, arr in ipairs({out, majors, kinds, times, scenes}) do
                        local consequenceLine = arr[countBefore]
                        for i = 1, k do arr[countBefore - 1 + i] = arr[countBefore + i] end
                        arr[last] = consequenceLine
                    end
                    consequenceAt = nil
                end
                levelsSaid = true
                for _, e in ipairs(afterLevel) do Milestone(e) end
                afterLevel = {}
            end
            function LevelsLineNow()
                levelsDone = true
                -- 3. Levels, at the end of the day.
                table.sort(f.levels)
            sayTime = f.levelT
                if #f.levels > 0 then
                    local top = f.levels[#f.levels]
                    local lt = {level = top, from = math.min(f.levels[1] - 1, first.level or 99)}
                    local mark
                    for _, level in ipairs(f.levels) do if W.milestone and W.milestone[level] then mark = level end end
                    local lastQuestT, questStretch, levelStretch = 0, 0, nil
                    for n, s in ipairs(stretches) do
                        for _, q in ipairs(s.quests) do if (q.t or 0) >= lastQuestT then lastQuestT, questStretch = q.t or 0, n end end
                        for _, x in ipairs(s.events) do if x.k == "mylevel" and x.t == f.levelT then levelStretch = n end end
                    end
                    -- (a level from an earlier part of the day, or half an hour and more before the last turn-in)
                    local early = W.levelEarly and f.levelT and lastQuestT > f.levelT + 300
                        and ((levelStretch and levelStretch < questStretch) or lastQuestT - f.levelT >= 1800)
                    local earlyPool
                    local whereLevel = early and levelStretch and levelStretch < questStretch and stretches[levelStretch].zone
                    if whereLevel and stretches[questStretch].zone ~= whereLevel then
                        local dungeon = L and L.Dungeon and L.Dungeon(whereLevel)
                        local pool = dungeon and W.levelEarlyDungeon or W.levelEarlyIn
                        if pool then lt.where = Place(whereLevel); earlyPool = pool end
                    end
                    if early then
                        lt.level = Words(top) == tostring(top) and tostring(top) or (top >= 10 and top % 10 == 0 and Words(top) or tostring(top))
                        Say(teller:Say("levelEarly", earlyPool or W.levelEarly, lt), mark ~= nil, "level")
                        if mark then Title(mark == 60 and 90 or 50, (teller:Pick("tLevel", W.titles.level) or ""):gsub("{level}", tostring(mark))) end
                    elseif mark then
                        Say(teller:Say("milestone" .. mark, W.milestone[mark], lt), true, "level")
                        Title(mark == 60 and 90 or 50, (teller:Pick("tLevel", W.titles.level) or ""):gsub("{level}", tostring(mark)))
                        if mark == 60 and W.lookBackLate and (person.startLevel or 0) >= 50 and history.firstDay and history.originPlace then
                            -- (a short book: where it began, and when)
                            local span = dayNumber - history.firstDay
                            local lb = {since = (span < 11 and "a week") or (span < 60 and (Words(math.floor(span / 7 + 0.5)) .. " weeks")) or (Words(math.floor(span / 30 + 0.5)) .. " months"),
                                fromLevel = tostring(person.startLevel), origin = history.originPlace}
                            local line = teller:Say("lookBackLate", W.lookBackLate, lb)
                            if line then Say(Cap(line), true) end
                        end
                        if mark == 60 and W.lookBack and (person.startLevel or 99) <= 20 and history.firstDay and history.quests >= 20 then
                            local span = dayNumber - history.firstDay
                            local lb = {since = span >= 60 and (Words(math.floor(span / 30 + 0.5)) .. " months") or (span < 11 and "a week") or (Words(math.floor(span / 7 + 0.5)) .. " weeks"),
                                origin = history.originPlace or "the start"}
                            Say(teller:Say("lookBack", W.lookBack, lb), true)
                            local best, bestTime
                            -- (the one you spent most time with, if it was a real part of the way)
                            local enough = math.max(3600, 0.2 * (history.playTime or 0))
                            for name, secs in pairs(history.companionTime) do if secs >= enough and (not bestTime or secs > bestTime) then best, bestTime = name, secs end end
                            if best and W.lookBackPeople then Say(teller:Say("lookBackPeople", W.lookBackPeople, {names = N(best)}), true) end
                        end
                    elseif W.levelsFast and (lt.from or 0) >= 20 and top - (lt.from or top) >= 3 then
                        -- (three levels and more in one day: the speed is the news)
                        Say(teller:Say("levelsFast", W.levelsFast, lt), true, "level")
                    elseif #out >= 8 or (consequenceAt and consequenceAt == #out) or kinds[#out] == "lore" then
                        -- (an everyday level is not news in a full chapter, or after a lord's fall or a story line)
                        history.levelsUnsaid = (history.levelsUnsaid or 0) + 1
                    elseif #f.levels > 1 then
                        Say(teller:Say("levels", W.levels, lt), false, "level")
                    else
                        Say(teller:Say("level", W.level, lt), false, "level")
                    end
                    -- (eight levels and more in a week, once a book: the pace, said once)
                    history.levelStarts = history.levelStarts or {}
                    history.levelStarts[#history.levelStarts + 1] = {day = dayNumber, from = lt.from}
                    if W.paceTally and not history.paceSaid then
                        for _, at in ipairs(history.levelStarts) do
                            if dayNumber - at.day <= 4 and dayNumber - at.day >= 2 and (at.from or 0) >= 20 and top - at.from >= 8 and not history.paceSaid then
                                history.paceSaid = true
                                local spanDays = dayNumber - at.day + 1
                                Say(teller:Say("paceTally", W.paceTally, {from = tostring(at.from), level = tostring(top), span = Words(spanDays) .. " days"}), true)
                            end
                        end
                    end
                end
            end
            -- A quiet day ends on its sunset (the level comes first).
            if sunsetLater then
                LevelsLine()
                local z = sunsetLater.z and Clean(sunsetLater.z)
                sunsetLater.skip = nil
                local e = sunsetLater
                Milestone(e)
                local after = W.sunsetAfter and ((z and W.sunsetAfter[z]) or W.sunsetAfter.plain)
                if after and z and EAST_COASTS[z] and not W.sunsetAfter[z] then after = nil end
                -- (a night at the inn follows: nothing about moving on)
                local sleeps = false
                for _, s2 in ipairs(stretches) do for _, x in ipairs(s2.events) do if x.k == "sleep" then sleeps = true end end end
                local function Staying(list)
                    if not (sleeps and list) then return list end
                    local kept = {}
                    for _, line in ipairs(list) do
                        if not (line:find("moved on", 1, true) or line:find(" left", 1, true) or line:find("hurry away", 1, true)) then kept[#kept + 1] = line end
                    end
                    return #kept > 0 and kept or nil
                end
                after = Staying(after)
                if after and teller.rng() < 0.6 then Say(teller:Say("sunsetAfter", after, {}), true, "lore")
                elseif W.quietClose and Staying(W.quietClose) and teller.rng() < 0.8 then
                    -- (a sunset watched together closes as "we")
                    local together1 = false
                    for _, s2 in ipairs(stretches) do for _, x in ipairs(s2.events) do if x == sunsetLater and #s2.with > 0 then together1 = true end end end
                    local closePool = (together1 and W.quietCloseWe and Staying(W.quietCloseWe)) or Staying(W.quietClose)
                    Say(teller:Say(together1 and "quietCloseWe" or "quietClose", closePool, {}), true)
                end
            end
            if not levelsDone then LevelsLine() end
            -- The tenth, twenty-fifth and fiftieth day out with the same companion (recorded days, once each).
            if W.companionDays then
                for _, w in ipairs(first.with) do
                    if history.companions[w.name] and w.seconds >= (first.e - first.t) * 0.5 then
                        local set = history.companionDays[w.name] or {n = 0}
                        history.companionDays[w.name] = set
                        if not set[dayNumber] then
                            set[dayNumber] = true
                            set.n = set.n + 1
                            local lines = W.companionDays[set.n]
                            if lines and #lines > 0 then
                                Say(teller:Say("companionDays", lines, {names = N(w.name)}), true, "first")
                                if W.titles.companionDays and W.titles.companionDays[set.n] then Title(60, W.titles.companionDays[set.n]) end
                            end
                        end
                    end
                end
            end
            -- Do not forecast an absence from the next recorded date.
            -- 4. A closing line, now and then.
            local last = stretches[#stretches]
            local h = Hour(last.e)
            -- the hearthstone home, when nothing else happened after it
            local hearth, after = nil, false
            for _, s in ipairs(stretches) do
                for _, e in ipairs(s.events) do
                    if e.k == "hearth" then hearth, after = e, false
                    elseif hearth and (e.k == "quest" or e.k == "boss" or e.k == "death" or e.k == "dungeon") then after = true end
                end
                if hearth and (s.questCount or 0) > 0 and (s.t or 0) > (hearth.t or 0) then after = true end
            end
            local sleep
            for _, e in ipairs(last.events) do if e.k == "sleep" and e.d then sleep = e end end
            local nextDay = days[index + 1]
            -- (the next time you played: the first scene of the next day)
            local nextStart = nextDay and nextDay.scenes and nextDay.scenes[1] and nextDay.scenes[1].t or (nextDay and nextDay.t)
            if sleep and nextStart and nextStart - (sleep.t or 0) < 6 * 3600 then sleep = nil end
            if sleep and not nextDay then sleep = nil end
            if sleep and W.sleepInn and (index - (history.sleepSaid or -99)) >= 3 then
                history.sleepSaid = index
                local saidPlace = table.concat(out, " "):find(Clean(sleep.d), 1, true)
                Say(teller:Say("sleepInn", (saidPlace and W.sleepInnHere) or W.sleepInn, {place = Place(sleep.d)}), false, "rest")
            elseif hearth and hearth.d and not after and W.hearthHome and not sunsetLater and history.hearthSaid ~= index
                and (index - (history.hearthSaid or -99)) >= 4 and teller.rng() < 0.6 then
                history.hearthSaid = index
                Say(teller:Say("hearthHome", W.hearthHome, {place = Place(hearth.d)}))
            elseif h < 4 and not last.open and not (day.readerEpisode and nextDay and nextDay.sourceDay == day.sourceDay) and teller.rng() < (profile.night and 0.25 or 0.6) then
                -- (a night player's late hours are not news every chapter)
                Say(teller:Say("late", W.late, {}))
            elseif f.together >= 4 * 3600 and not (day.readerEpisode and nextDay and nextDay.sourceDay == day.sourceDay) and teller.rng() < 0.4 then
                Say(teller:Say("long", W.long, {span = Span(f.together)}))
            end
            history.lastDay = dayNumber
            history.lastZone = last.zone
            history.firstDay = history.firstDay or dayNumber
            history.originPlace = history.originPlace or (origin and ORIGIN_PLACE[race] and Place(ORIGIN_PLACE[race])) or Place(first.zone)
            Title(1, Clean(first.zone))
        end
        -- "There" for a place once in two sentences: "There I came across Rak'shiri.
        -- I finished Winterfall Activity there. There, I skinned thirty beasts." keeps the first.
        do
            local function Locative(text)
                local plain = text:gsub("{%a:([^}]*)}", "%1")
                for at in plain:gmatch("()%f[%a][Tt]here%f[%A]") do
                    local after = plain:sub(at + 5, at + 10)
                    if not (after:match("^ was") or after:match("^ were") or after:match("^ is") or after:match("^ had")) then return true end
                end
                return false
            end
            for n = 2, #out do
                if kinds[n] ~= "lore" and Locative(out[n - 1]) then
                    local text = out[n]
                    if text:match("^There, %a") then text = text:gsub("^There, (%a)", function(c) return c:upper() end)
                    elseif text:match("^There I ") then text = text:gsub("^There I ", "I ")
                    elseif text:match(" there%.$") and not text:find("%. ") then text = text:gsub(" there%.$", ".") end
                    out[n] = text
                end
            end
        end
        -- Highlights keep a scene's bearings, its work, and one quiet beat.
        -- Major events remain intact; repetition is cut within a scene, never
        -- by throwing away all the connective tissue or an uneventful day.
        if brief then
            local counts, keep = {}, {}
            for n = 1, #out do
                local scene = scenes[n] or 1
                counts[scene] = counts[scene] or {}
                local c, kind = counts[scene], kinds[n] or "detail"
                c[kind] = (c[kind] or 0) + 1
                local anchor = (kind == "open" or kind == "move" or kind == "town") and c[kind] == 1
                local work = kind == "quests" or kind == "level" or kind == "rest"
                keep[n] = n == 1 or majors[n] or anchor or (work and c[kind] == 1)
                -- An untagged sentence may be the only account of gathering,
                -- crafting, or a recorded pause. Retain one per scene.
                if kind == "detail" and c[kind] == 1 then keep[n] = true end
                if keep[n] then c.kept = true end
            end
            local filtered, fm, fk, ft, fs = {}, {}, {}, {}, {}
            for n = 1, #out do
                local scene = scenes[n] or 1
                if keep[n] or not counts[scene].kept then
                    local at = #filtered + 1
                    filtered[at], fm[at], fk[at], ft[at], fs[at] = out[n], majors[n], kinds[n], times[n], scene
                    counts[scene].kept = true
                end
            end
            out, majors, kinds, times, scenes = filtered, fm, fk, ft, fs
        end
        -- Two short sentences of yours in a row become one, now and then
        -- ("I turned in Kodo Roundup, and I made level 6.").
        local joinedOut, joinedMajors, joinedScenes, joinedKinds = {}, {}, {}, {}
        local i = 1
        local function Words2(x) local n = 0; for _ in x:gsub("{%a:", ""):gmatch("%S+") do n = n + 1 end; return n end
        -- (lines that stand on their own: the first page, the mood of the day, your part, a find)
        local STANDALONE = {origin = true, mood = true, role = true, first = true, loot = true}
        local LEVEL_ING = {reached = "reaching", made = "making", climbed = "climbing", went = "going"}
        -- "I ..." (or "On Tuesday, I ...") and "I ...": one sentence, the second "I" dropped
        local function Mine(x)
            return x:match("^I ") or x:match("^[%w' ]+, I ") or x:match("^Later I ") or x:match("^Then I ") or x:match("^From there I ")
                or x:match("^After that, I ")
        end
        -- (only pairs that belong together; never a "first" line)
        local PAIRS = {["open>quests"] = true, ["move>quests"] = true, ["town>quests"] = true, ["quests>level"] = true, ["quests>rest"] = true,
            ["open>town"] = true, ["move>town"] = true, ["town>rest"] = true, ["open>level"] = true, ["town>level"] = true}
        local function Belongs(at)
            local a, b = kinds[at] or "", kinds[at + 1] or ""
            if PAIRS[a .. ">" .. b] then return true end
            -- untagged lines of yours may join a tagged one, but never a first, a lore or a death
            return (a == "" or b == "") and a ~= "lore" and b ~= "lore" and a ~= "death" and b ~= "death" and a ~= "first" and b ~= "first"
                and not (out[at] or ""):lower():find("first time", 1, true) and not (out[at + 1] or ""):lower():find("first time", 1, true)
                and not (out[at] or ""):find("had never", 1, true) and not (out[at + 1] or ""):find("had never", 1, true)
        end
        while i <= #out do
            local source = i
            local a, b = out[i], out[i + 1]
            if scenes[i] ~= scenes[i + 1] then b = nil end
            local wa, wb = a and Words2(a) or 0, b and Words2(b) or 0
            local plain = b and kinds[i] ~= "lore" and kinds[i + 1] ~= "lore" and a:match("%.$") and not a:find(" and ", 1, true)
                and not b:find(" and ", 1, true) and not a:find("%. ") and not b:find("%. ")
                and not STANDALONE[kinds[i] or ""] and not STANDALONE[kinds[i + 1] or ""]
            -- (a lead and the quests that have an "and" of their own: "I went on to the Barrens, then turned in A and B.")
            local thenJoin = b and kinds[i + 1] == "quests" and (kinds[i] == "move" or kinds[i] == "town" or kinds[i] == "open")
                and a:match("%.$") and not a:find(" and ", 1, true) and not a:find("%. ") and not b:find("%. ") and b:find(" and ", 1, true)
                and Mine(a) and b:match("^[IW]e? ") and wa + wb <= 26
            if plain and kinds[i] == "death" and kinds[i + 1] == "rez" and wa + wb <= 24 then
                joinedOut[#joinedOut + 1] = a:gsub("%.$", "") .. ", but " .. b
                joinedMajors[#joinedOut] = majors[i] or majors[i + 1]
                i = i + 2
            elseif b and kinds[i] == "kill" and kinds[i + 1] == "loot" and a:match("%.$") and not a:find(" and ", 1, true)
                and not b:find(" and ", 1, true) and not b:find("%. ") and wa + wb <= 22 then
                -- ("We brought down Garr, and the Robe of Volatile Power was mine.")
                local rest = b:match("^The ") and ("the " .. b:sub(5)) or b:match("^My ") and ("my " .. b:sub(4)) or b
                joinedOut[#joinedOut + 1] = a:gsub("%.$", "") .. ", and " .. rest
                joinedMajors[#joinedOut] = majors[i] or majors[i + 1]
                i = i + 2
            elseif b and kinds[i] == "quests" and kinds[i + 1] == "level" and a:match("%.$") and not a:find("%. ") and wa + wb <= 26
                and (a:match("^I ") or a:match("^We ")) and (times[i + 1] or 0) >= (times[i] or 0)
                and b:match("^I (%a+) ") and LEVEL_ING[b:match("^I (%a+) ")] and (a:find(" and ", 1, true) or teller.rng() < 0.5) then
                -- ("I turned in A and B, reaching level 4.")
                local verb = b:match("^I (%a+) ")
                joinedOut[#joinedOut + 1] = a:gsub("%.$", "") .. ", " .. LEVEL_ING[verb] .. b:sub(#verb + 3)
                joinedMajors[#joinedOut] = majors[i] or majors[i + 1]
                i = i + 2
            elseif b and (kinds[i] == "kill" or kinds[i] == "role") and kinds[i + 1] == "level" and a:match("%.$") and not a:find("%. ")
                and not a:find(" and ", 1, true) and b:match("^I ") and not b:find(",", 1, true) and wa + wb <= 22 then
                -- ("VanCleef never got past me, and I went up to level 18.")
                joinedOut[#joinedOut + 1] = a:gsub("%.$", "") .. ", and " .. b
                joinedMajors[#joinedOut] = majors[i] or majors[i + 1]
                i = i + 2
            elseif b and kinds[i] == "move" and a:match("%.$") and not a:find("%. ") and not a:find(", where", 1, true)
                and (b:match("^.- joined [mu][es] there%.$") or b:match("^.- caught up with [mu][es] there%.$")
                    or b:match("^{n:[^}]+} joined me%.$") or b:match("^{n:[^}]+} caught up with me%.$")
                    or b:match("^There, .- joined me%.$")) and wa + wb <= 22 then
                -- ("Later I went on to Silverpine Forest, where Grak joined me.")
                joinedOut[#joinedOut + 1] = a:gsub("%.$", "") .. ", where " .. b:gsub("^There, ", ""):gsub(" there%.$", ".")
                joinedMajors[#joinedOut] = majors[i] or majors[i + 1]
                i = i + 2
            elseif b and a:find("one of them fell%.$") and (b:match("^I died to .+%.$") or b:match("^I fell to .+%.$")) and not b:find("%. ") and wa + wb <= 24 then
                -- ("I fought the other side there, and one of them fell, but a human paladin killed me.")
                local foe = b:match("^I died to (.+)%.$") or b:match("^I fell to (.+)%.$")
                joinedOut[#joinedOut + 1] = a:gsub("%.$", "") .. ", but " .. foe .. " killed me."
                joinedMajors[#joinedOut] = majors[i] or majors[i + 1]
                i = i + 2
            elseif b and ((kinds[i] == "rest" and kinds[i + 1] == "quests") or (kinds[i] == "quests" and kinds[i + 1] == "rest")) and a:match("%.$") and not a:find("[,%.] ") and not a:find(" and ", 1, true)
                and not b:find(" and ", 1, true) and not b:find("%. ") and wa + wb <= 20
                and ((a:match("^We ") and b:match("^We ")) or (a:match("^I ") and b:match("^I "))) then
                -- ("We rested by a campfire and finished The Zhevra.")
                joinedOut[#joinedOut + 1] = a:gsub("%.$", "") .. " and " .. b:gsub("^%a+ ", "")
                joinedMajors[#joinedOut] = majors[i] or majors[i + 1]
                i = i + 2
            elseif thenJoin and teller.rng() < 0.6 then
                joinedOut[#joinedOut + 1] = a:gsub("%.$", "") .. ", then " .. b:gsub("^[IW]e? ", "")
                joinedMajors[#joinedOut] = majors[i] or majors[i + 1]
                i = i + 2
            elseif plain and kinds[i] ~= "death" and Belongs(i) and Mine(a) and b:match("^I ") and not b:match("^I had ") and wa + wb <= 26 and wa <= 16
                and teller.rng() < 0.75 then
                -- (no comma when both halves are short)
                joinedOut[#joinedOut + 1] = a:gsub("%.$", "") .. ((wa < 10 and wb < 10 and not a:find(",", 1, true)) and " and " or ", and ") .. b:sub(3)
                joinedMajors[#joinedOut] = majors[i] or majors[i + 1]
                i = i + 2
            elseif plain and kinds[i] ~= "death" and Belongs(i) and i > 1 and not Mine(a) and b:match("^I ") and not b:match("^I had ") and wa <= 8 and wa + wb <= 20
                and teller.rng() < 0.6 then
                -- ("Five quests kept me busy, and I made level 6.")
                joinedOut[#joinedOut + 1] = a:gsub("%.$", "") .. ", and " .. b
                joinedMajors[#joinedOut] = majors[i] or majors[i + 1]
                i = i + 2
            else
                joinedOut[#joinedOut + 1] = a
                joinedMajors[#joinedOut] = majors[i]
                i = i + 1
            end
            joinedScenes[#joinedOut], joinedKinds[#joinedOut] = scenes[source], kinds[source]
        end
        out, majors = joinedOut, joinedMajors
        -- Place changes form paragraphs. A long stay can also turn from its
        -- setting to conflict or from conflict to work and rest.
        local paragraphs, paragraph, paragraphWords = {}, {}, 0
        for n, sentence in ipairs(out) do
            local kind = joinedKinds[n]
            -- A new purpose is a useful paragraph boundary, even when the
            -- character stayed in one region all evening. Keep the completed
            -- action and its consequence together; never break after every line.
            local turn = kind == "questTurn" or n < #out and ((kind == "questStart" and paragraphWords >= 45)
                or (paragraphWords >= 55 and (kind == "death" or kind == "kill" or kind == "rest" or kind == "town" or kind == "move")))
            if #paragraph > 0 and (joinedScenes[n] ~= joinedScenes[n - 1] or turn) then
                paragraphs[#paragraphs + 1] = table.concat(paragraph, " ")
                paragraph, paragraphWords = {}, 0
            end
            paragraph[#paragraph + 1] = sentence
            paragraphWords = paragraphWords + Words2(sentence)
        end
        if #paragraph > 0 then paragraphs[#paragraphs + 1] = table.concat(paragraph, " ") end
        local text = table.concat(paragraphs, "\n\n")
        -- the title: the best of the day that no earlier chapter had
        table.sort(titles, function(x, y) return x.rank > y.rank end)
        local title
        for _, t in ipairs(titles) do if not history.titles[t.text] then title = t.text; break end end
        title = title or (titles[1] and titles[1].text)
        -- Reused personal labels give way to the recorded setting.
        if title and history.titles[title] then
            local zone = f.stretches[1] and Clean(f.stretches[1].zone or "")
            if zone and title == zone and not history.titles["Back in " .. zone] then title = "Back in " .. zone:gsub("^The ", "the ")
            elseif zone and zone ~= "" then
                title = zone
                -- Prefer this day's recorded work to another reunion suffix.
                for _, stretch in ipairs(f.stretches) do
                    for _, quest in ipairs(stretch.quests) do
                        local work = Clean(quest.title)
                        if history.titles[title] and not history.titles[work] then title = work end
                    end
                end
                if history.titles[title] then
                    title = zone .. " — " .. (date and date("%d %B %Y", day.t) or day.key)
                end
            end
        end
        if title then history.titles[title] = true end
        if text ~= "" or #f.quotes > 0 then
            history.chapter = history.chapter + 1
            stories[day.key] = {text = text, title = title and title:gsub("^%l", string.upper) or nil, chapter = history.chapter, quotes = f.quotes}
        else
            stories[day.key] = {text = "", title = nil, chapter = history.chapter, quotes = {}}
        end
    end
    return stories
end
