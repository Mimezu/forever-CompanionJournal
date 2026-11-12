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
-- A title that ends in a full stop ("Reagents for Reclaimers Inc.") takes no second one.
local function OneStop(text)
    text = tostring(text or ""):gsub("%.(})%.", ".%1"):gsub("([^%.])%.%.([^%.])", "%1.%2"):gsub("([^%.])%.%.$", "%1.")
    return text
end
local function Clean(text) return (tostring(text or ""):gsub("[{}]", "")) end
-- Words that stand before a name as a rank or office: the short form of "Executor Zygand" is "Zygand".
local TITLE_WORDS = {}
for w in ("Executor Novice Apothecary Deathguard Priest Captain Magistrate Commander Lieutenant Sergeant Marshal Guard Mayor "
    .. "Farmer Lord Lady King Queen Prince Princess Archmage Brother Sister Father Mother High Overlord Warlord Chief Elder Keeper "
    .. "Ranger Scout Sentinel Watcher Warden Grunt Shaman Seer Mystic Trainer Baron Duke Count Admiral General Major Private Officer "
    .. "Foreman Overseer Supervisor Master Grand Apprentice Junior Senior Initiate Acolyte Bishop Abbot Deputy Sheriff Constable "
    .. "Thane Mountaineer Rifleman Huntsman Tracker Ambassador Emissary Envoy Herald Inquisitor Dark Shadow Arch"):gmatch("%a+") do TITLE_WORDS[w] = true end
-- A killer that was never the target has no "one of a kind of creature" flag in the record
-- ("I died fighting Dark Enforcer", 2026-11-08). Its name still says so when it ends in the
-- word for a creature or a calling: "a Dark Enforcer", "a Scarlet Zealot". A one-word name, a
-- name with an apostrophe or "the", and anyone the lore knows as a boss stay as they are.
local KIND_NOUNS = {}
for w in ("Enforcer Neophyte Cultist Warrior Zealot Gnoll Murloc Spider Duskbat Darkhound Wolf Bear Boar Zombie Skeleton Ghoul "
    .. "Horror Spirit Bandit Mage Warlock Hunter Rogue Acolyte Initiate Missionary Friar Monk Medic Soldier Footman Sentry "
    .. "Invader Defender Conjurer Sorcerer Necromancer Adept Thug Brigand Poacher Outrunner Raider Marauder Pillager Reaver "
    .. "Geomancer Bodyguard Peon Miner Digger Worker Laborer Looter Trapper Smuggler Pirate Sailor Swashbuckler Crab Crocolisk "
    .. "Raptor Scorpid Scorpion Tiger Panther Lion Lioness Stalker Prowler Hyena Vulture Buzzard Condor Bat Rat Snake Serpent "
    .. "Adder Lurker Crawler Creeper Recluse Tarantula Kobold Trogg Ogre Elemental Imp Felhound Felhunter Satyr Harpy Centaur "
    .. "Quilboar Furbolg Treant Golem Abomination Wraith Ghost Banshee Shade Gargoyle Hound Mastiff Worg Yeti Gorilla Basilisk "
    .. "Turtle Snapper Thresher Oracle Tidehunter Coastrunner Mongrel Ravager Brute Mauler Butcher Assassin Infiltrator Spy "
    .. "Peasant Deserter Recruit Trainee Squire Knight Crusader Gryphon Wyvern Drake Whelp Ooze Slime Sludge Worm Grub Beetle "
    .. "Moth Wasp Plainstrider Strider Kodo Zhevra Stag Owl Hawk Eagle Wizard Tracker Scavenger Vermin Cook Magus Summoner "
    .. "Torturer Chaplain Preserver Diviner Evoker Pyromancer Gallant Protector Guardsman Henchman Lackey Minion Rager "
    .. "Destroyer Shadowcaster Shadowmage Warder Overseer Taskmaster Slaver Enchanter Plaguehound Plaguebat Carrion"):gmatch("%a+") do KIND_NOUNS[w] = true end
local function OfAKind(e, name)
    if not e then return false end
    -- (SHARED FOE NAME, 2026-11-11: the companion book's rule in JournalWords.lua, A.FoeNamed,
    -- decides for every teller, with the record's flag as its hint; missing kind nouns go in
    -- A.FoeKinds there. The nouns below stand in only when that file is not loaded.)
    if A.FoeNamed then return not A.FoeNamed(Clean(name or e.d), e.a) end
    if e.a ~= nil then return e.a and true or false end
    name = Clean(name or e.d)
    if not name:find(" ", 1, true) or name:find("'", 1, true) or name:match("^The ") then return false end
    if A.Lore and A.Lore.Boss and A.Lore.Boss(name) then return false end
    return KIND_NOUNS[name:match("(%a+)$") or ""] or false
end
-- A place's name in a sentence: "the {p:Barrens}", "{p:Durotar}", "the {p:Arathi Highlands}".
local ARTICLE = {["Eastern Kingdoms"] = true, ["Arathi Highlands"] = true, ["Eastern Plaguelands"] = true, ["Western Plaguelands"] = true,
    ["Badlands"] = true, ["Blasted Lands"] = true, ["Burning Steppes"] = true, ["Searing Gorge"] = true, ["Wetlands"] = true,
    ["Redridge Mountains"] = true, ["Stonetalon Mountains"] = true, ["Swamp of Sorrows"] = true, ["Alterac Mountains"] = true,
    ["Hillsbrad Foothills"] = true, ["Undercity"] = true, ["Valley of Trials"] = true, ["Savage Coast"] = true, ["Echo Isles"] = true,
    ["Molten Core"] = true, ["Scarlet Monastery"] = true, ["Wailing Caverns"] = true, ["Bay of Storms"] = true, ["Ruins of Lordaeron"] = true,
    ["Riverglades"] = true, ["Darkspear Islands"] = true, ["Barrow Deeps"] = true}
local function Place(name)
    name = Clean(name)
    local rest = name:match("^The (.+)$")
    if rest then return "the {p:" .. rest .. "}" end
    if ARTICLE[name] then return "the {p:" .. name .. "}" end
    return "{p:" .. name .. "}"
end
ST.Place = Place
-- An inn with a name of its own ("the Gallows' End Tavern", "the Pig and Whistle Tavern"): the
-- place itself, with its article, never "the inn in" it. Nil for a town.
local function InnName(name)
    local plain = Clean(name)
    if plain:find("Tavern$") or plain:find(" Inn$") or plain:find("Lodge$") or plain:find("Alehouse$") then
        local rest = plain:match("^The (.+)$") or plain
        return "the {p:" .. rest .. "}"
    end
    return nil
end
ST.InnName = InnName
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
-- "first", "second"... "twelfth", then "13th".
local ORDINALS = {"first", "second", "third", "fourth", "fifth", "sixth", "seventh", "eighth", "ninth", "tenth", "eleventh", "twelfth"}
local function Ordinal(n) return ORDINALS[n] or (tostring(n) .. "th") end
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
        local function Fill(line)
            local text = line:gsub("{(%a+)}", function(token)
                local value = tokens and tokens[token]
                if value == nil and token:match("^%u") then
                    local lower = tokens and tokens[token:sub(1, 1):lower() .. token:sub(2)]
                    if lower ~= nil then return Cap(tostring(lower)) end
                end
                if value == nil then return "{" .. token .. "}" end
                return tostring(value)
            end)
            return Cap(text)
        end
        local line = self:Pick(key, list)
        if not line then return nil end
        local text = Fill(line)
        -- (a sentence said word for word earlier in the book is not said again while the pool
        -- has another: a long book never repeats a shape, 2026-11-06)
        self.saidTexts = self.saidTexts or {}
        if self.saidTexts[text] and type(list) == "table" and #list > 1 then
            for _ = 1, math.min(4, #list) do
                local other = self:Pick(key, list)
                local otherText = other and Fill(other)
                if otherText and not self.saidTexts[otherText] then line, text = other, otherText; break end
            end
        end
        self.saidTexts[text] = true
        for _, joke in ipairs(JOKES) do if line:find(joke, 1, true) then self.jokes[joke] = true end end
        if once[line] then self.onceUsed[line] = true end
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
-- A killer whose name is a kind of creature, not a person: "Vampiric Duskbat", "Rattlecage
-- Skeleton", "Scarlet Zealot" (the last word names the kind). A person or a named beast
-- ("Samuel Fipps", "Gorefang") is not one.
local FOE_KINDS = {}
for w in ("bat duskbat spider wolf worg boar bear zombie skeleton ghoul zealot crusader murloc kobold gnoll raptor crocolisk "
    .. "scorpid harpy centaur quilboar trogg troll ogre elemental spirit ghost wraith abomination cultist acolyte bandit thug "
    .. "footpad thief pirate satyr furbolg treant lasher ooze slime wasp stinger beetle scarab crab naga siren kodo plainstrider "
    .. "prowler lion cat panther tiger stalker hyena vulture buzzard gorilla ape yeti owl wildkin drake whelp dragonkin golem "
    .. "shredder guard warrior mage priest warlock apprentice sentry scout watcher patroller ravager horror fiend imp felhound "
    .. "felguard voidwalker succubus shade banshee ghast geist gargoyle mummy bonecaster wretch darkhound mangler lurker crawler "
    .. "tunneler miner digger taskmaster slaver overseer brute bruiser mauler shaman mystic seer oracle hunter trapper warder "
    .. "defender protector sentinel warden myrmidon invoker deathguard boar tallstrider basilisk serpent snake cobra adder lizard "
    .. "thunderhawk hawk eagle gryphon wyvern hippogryph nightsaber frostsaber mongrel hound jackal coyote rat vermin moth "
    .. "fly mosquito leech worm silithid tunneler grunt peon brave"):gmatch("%a+") do FOE_KINDS[w] = true end
function ST.CommonFoe(name)
    local plain = Clean(name)
    if plain:find("^The ") or plain:find("'s ") then return false end
    local last = plain:match("(%a+)s?$")
    last = last and last:lower()
    if not last then return false end
    if FOE_KINDS[last] or FOE_KINDS[last:gsub("s$", "")] then return true end
    for kind in pairs(FOE_KINDS) do if #kind >= 3 and last:sub(-#kind) == kind and plain:find(" ") then return true end end
    return false
end
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
                -- (a foe not targeted when it struck is still "a Vampiric Duskbat" when its name is a kind)
                if (copy.k == "death" or copy.k == "close") and copy.d and not copy.a and not copy.boss and ST.CommonFoe(copy.d) then copy.a = true end
                s.events[#s.events + 1] = copy
            end
            for _, entry in ipairs(scene.entries or {}) do
                if entry.pl then s.level = s.level or tonumber(entry.pl) end
                if entry.s then s.seeded = true end
            end
            table.sort(s.events, function(a, b) return (a.t or 0) < (b.t or 0) end)
            s.scene = scene
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
-- A battleground stretch (a `bg` event in its own zone), and the queue: a short
-- stop with nothing in it, in the zone you queued from, between two matches of
-- the same battleground. The queue is not travel; it is left out of the telling.
local function BattlegroundOf(s)
    for _, e in ipairs(s.events or {}) do if e.k == "bg" and e.d and (e.d == s.zone or e.z == s.zone) then return e.d end end
    return nil
end
-- A dungeon run over several stays (2026-11-11; the runs come from JournalEpisodes): the
-- stays of one run (the dungeon, the ghost run out and back, the dungeon again) become one
-- stretch, so the run is told as one story in time order. The deaths of the stays between
-- come along; their town and rest lines do not. Each later try of the run gets a `dungeon`
-- event marked `retry` (`wipe` when the try before ended on deaths), told as "we went back
-- down", never as a new entry with the lore of the place again.
local RUN_KEEP = {pdeath = true, death = true, rez = true}
function ST.JoinDungeonRuns(stretches, runs)
    for _, run in ipairs(runs or {}) do
        local member = {}
        for _, scene in ipairs(run.scenes or {}) do member[scene] = "run" end
        for _, scene in ipairs(run.between or {}) do member[scene] = "between" end
        local first, i = nil, 1
        while i <= #stretches do
            local s = stretches[i]
            local kind = s.scene and member[s.scene]
            if kind == "run" and not first then
                first, i = s, i + 1
            elseif kind and first then
                for _, e in ipairs(s.events) do if kind == "run" or RUN_KEEP[e.k] then first.events[#first.events + 1] = e end end
                for _, x in ipairs(s.entries) do first.entries[#first.entries + 1] = x end
                if kind == "run" then
                    for _, b in ipairs(s.bosses) do first.bosses[#first.bosses + 1] = b end
                    for _, q in ipairs(s.quests) do first.quests[#first.quests + 1] = q end
                    first.questCount = first.questCount + s.questCount
                    for k, n in pairs(s.gather) do first.gather[k] = (first.gather[k] or 0) + n end
                    for k, line in pairs(s.craft) do first.craft[k] = first.craft[k] or line end
                    first.hk = (first.hk or 0) + (s.hk or 0)
                end
                for _, w in ipairs(s.with) do
                    local known
                    for _, mine in ipairs(first.with) do if mine.name == w.name then known = mine end end
                    if known then known.seconds = (known.seconds or 0) + (w.seconds or 0) else first.with[#first.with + 1] = w end
                end
                first.e, first.open = math.max(first.e, s.e), s.open
                table.remove(stretches, i)
            else
                i = i + 1
            end
        end
        if first then
            for a = 2, #(run.attempts or {}) do
                local at = run.attempts[a]
                local wipe = run.attempts[a - 1].wipe and true or false
                local known = false
                for _, e in ipairs(first.events) do
                    if e.k == "dungeon" and e.d == run.dungeon and e.t == at.entered then known = true; e.retry, e.wipe = true, wipe end
                end
                if not known then first.events[#first.events + 1] = {k = "dungeon", d = run.dungeon, t = at.entered, r = at.r, retry = true, wipe = wipe} end
            end
            table.sort(first.events, function(a, b) return (a.t or 0) < (b.t or 0) end)
            first.run = run
        end
    end
    return stretches
end
function ST.DropQueues(stretches)
    local kept = {}
    for i, s in ipairs(stretches) do
        local before, after = stretches[i - 1], stretches[i + 1]
        -- (a short empty stop next to a match, before the first, between two or after the last)
        local nextTo = (before and BattlegroundOf(before)) or (after and BattlegroundOf(after))
        local queue = nextTo and not BattlegroundOf(s) and (s.e - s.t) < 900 and #s.events == 0 and s.questCount == 0
            and next(s.gather) == nil and next(s.craft) == nil
        if not queue then kept[#kept + 1] = s end
    end
    return kept
end

-- A run of deaths (2026-11-11): the character's deaths, the party's deaths and the raises
-- that fall close together are one passage, in the order they happened, not a line per
-- zone. The same fight: within 150 seconds of each other, whatever the zone (a wipe's
-- deaths are logged as the ghosts run out through other zones). The same bad stretch:
-- within twenty minutes, in one zone. A run needs two deaths; a lone death, or a death and
-- the raise that answered it, keep their own lines. Every event of a run is told, and the
-- first event carries the run (e.deathRun): its beats (one a fight; my second death, a gap
-- or a raise ends a fight), run.wipe when I fell with others, and for a fight lost in a
-- dungeon the day went back into, run.firstTry and run.dungeon, so the dungeon telling
-- can place "the first try" where it belongs. Falls, the water, the other side's players
-- and a death a boss line tells are not run material.
-- Who taught the character to raise the dead, from a chapter's plain text: the sentence that
-- says "taught me" and names the art (redemption, rebirth, "bring back"...), and the first
-- name of the person in it or in the sentence before ("Danitha Morr judged me ready. She ...
-- taught me redemption" gives "Danitha"). Nil when no chapter said so.
function ST.RaiseTeacher(text)
    local prev
    for sentence in tostring(text or ""):gmatch("[^%.]+%.") do
        local low = sentence:lower()
        if low:find("taught me", 1, true) and (low:find("redemption", 1, true) or low:find("bring back", 1, true) or low:find("raise", 1, true)
            or low:find("resurrect", 1, true) or low:find("rebirth", 1, true) or low:find("ancestral spirit", 1, true) or low:find("from the dead", 1, true)
            or low:find("back from death", 1, true) or low:find("spirit back", 1, true)) then
            -- (the first name of the person: after a title, the second word; never a sentence's first word)
            local STOP = {The = true, Then = true, When = true, After = true, Before = true, That = true, This = true, With = true, From = true,
                There = true, She = true, Her = true, His = true, Our = true, Later = true, Once = true}
            for _, where in ipairs({sentence, prev or ""}) do
                for a, b in where:gmatch("%f[%a](%u%l%l+) (%u%l%l+)%f[%A]") do
                    if TITLE_WORDS[a] then return b end
                    if not STOP[a] and not STOP[b] and not TITLE_WORDS[b] then return a end
                end
            end
        end
        prev = sentence
    end
    return nil
end

function ST.DeathRuns(stretches)
    local items = {}
    for si, s in ipairs(stretches) do
        for ei, e in ipairs(s.events) do
            local kind
            if e.told or e.skip then kind = nil
            elseif e.k == "death" and not e.boss and not e.pr and not e.pc and not e.env then kind = "me"
            elseif e.k == "pdeath" and e.n and not e.boss then
                kind = "party"
                -- (a companion of the list whose time with me does not cover it was not in that fight)
                local short = (Clean(e.n):match("^[^%s%-]+") or ""):lower()
                for _, w in ipairs(s.with or {}) do
                    if (Clean(w.name):match("^[^%s%-]+") or ""):lower() == short and type(w.spans) == "table" and #w.spans > 0 then
                        local covered = false
                        for _, span in ipairs(w.spans) do
                            if (e.t or 0) >= (span[1] or 0) - 300 and (e.t or 0) <= (span[2] or 0) + 300 then covered = true end
                        end
                        if not covered then kind = nil; e.told = true end
                    end
                end
            elseif e.k == "rez" and e.by and not Clean(e.by):lower():find("spirit healer", 1, true) and not Clean(e.by):match("^%l") then kind = "rez"
            elseif e.k == "first" and e.d == "rezother" and not e.u then kind = "raise"
            end
            if kind then items[#items + 1] = {k = kind, e = e, s = s, si = si, ei = ei, t = e.t or 0} end
        end
    end
    table.sort(items, function(a, b)
        if a.t ~= b.t then return a.t < b.t end
        if a.si ~= b.si then return a.si < b.si end
        return a.ei < b.ei
    end)
    local runs, run = {}, nil
    for _, it in ipairs(items) do
        local prev = run and run.items[#run.items]
        local gap = prev and (it.t - prev.t) or 0
        local join = prev and (gap <= 150 or (gap <= 1200 and it.s.zone == prev.s.zone))
        -- (the one who brought me back, up to twenty minutes after, wherever my body lay)
        if prev and it.k == "rez" and gap <= 1200 and run.hasMe then join = true end
        if join then run.items[#run.items + 1] = it
        else run = {items = {it}}; runs[#runs + 1] = run end
        if it.k == "me" then run.hasMe = true end
    end
    local kept = {}
    for _, r in ipairs(runs) do
        local deaths = 0
        for _, it in ipairs(r.items) do if it.k == "me" or it.k == "party" then deaths = deaths + 1 end end
        if deaths >= 2 then
            r.beats = {}
            local beat
            for _, it in ipairs(r.items) do
                local last = beat and beat.items[#beat.items]
                local new = not beat or beat.closed or (it.t - last.t > 150) or (it.k == "me" and beat.me ~= nil)
                if it.k == "rez" and beat and beat.me and not beat.rez then new = false end
                if new then beat = {items = {}, party = {}, t = it.t}; r.beats[#r.beats + 1] = beat end
                beat.items[#beat.items + 1] = it
                beat.last = it.t
                if it.k == "me" then beat.me = it
                elseif it.k == "party" then beat.party[#beat.party + 1] = it
                elseif it.k == "rez" then beat.rez = it; beat.closed = true
                elseif it.k == "raise" then beat.raise = it; beat.closed = true end
                it.e.told = true
            end
            for _, b in ipairs(r.beats) do if b.me and #b.party > 0 then r.wipe = true end end
            -- (no death of mine, nobody raised: the party's losses, one sentence with the counts)
            r.partyOnly = true
            for _, it in ipairs(r.items) do if it.k ~= "party" then r.partyOnly = false end end
            local lead, last = r.items[1], r.items[#r.items]
            -- (the first try at a dungeon: its bosses fell after the lost fight, none before it,
            -- in the same stay or a later one)
            local dungeon
            for _, e in ipairs(lead.s.events) do if e.k == "dungeon" and e.d and (e.t or 0) <= lead.t then dungeon = e.d end end
            if dungeon and #r.beats == 1 and r.wipe then
                local before, after = 0, 0
                for _, s in ipairs(stretches) do
                    local there = s.zone == dungeon
                    for _, e in ipairs(s.events) do if e.k == "dungeon" and e.d == dungeon then there = true end end
                    if there then
                        for _, e in ipairs(s.events) do
                            if e.k == "boss" then
                                if (e.t or 0) > last.t then after = after + 1 else before = before + 1 end
                            end
                        end
                    end
                end
                if after > 0 and before == 0 then r.firstTry, r.dungeon = true, dungeon end
            end
            lead.e.deathRun = r
            kept[#kept + 1] = r
        end
    end
    return kept
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
            -- (a sight that says the epithet over again, "Tanaris, all sand and sun. Sand and sun covered
            -- the land": two of the epithet's words in the line, and it waits for another day)
            local echoes = 0
            for word in pairs(teller.epithetWords or {}) do if line:lower():find("%f[%a]" .. word .. "%f[%A]") then echoes = echoes + 1 end end
            if not repeatsTown and echoes < 2 and not NamesFoeTown(line, faction) then kept[#kept + 1] = line end
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
        dungeonVisits = {}, dungeonsEver = 0, dungeonLordDone = {}, dungeonUnfinishedLast = {}, dungeonDiedLast = {}, roleSaid = {}, titles = {}, questLore = {}, storyThreads = {}, describedZones = {}, infamous = {}, companionLast = {}, companionTime = {}, quests = 0, deaths = 0}
    local teller = Teller((person.charKey or person.name or "me") .. ":" .. tostring(retell or person.retell or 0))
    -- (the planned telling, JournalSelfPlan.lua: what earlier chapters told, for the feelings it has earned)
    local planned = A.SelfPlan and not brief and A.BookVariant and A.BookVariant("teller") == "planned" or false
    history.plan = {said = {}, kind = {}, text = ""}
    local profile = ST.Profile(days)
    -- (the longest gap between two recorded days: the first return after it opens as one)
    local maxGap = 0
    do
        local prev
        for _, day in ipairs(days) do
            local n = DayNumber(day.t)
            if prev and n - prev > maxGap then maxGap = n - prev end
            prev = n
        end
    end
    -- (all the deaths in the book: hindsight is said only when true)
    local totalDeaths = 0
    for _, day in ipairs(days) do
        for _, scene in ipairs(day.scenes) do for _, e in ipairs(scene.events or {}) do if e.k == "death" then totalDeaths = totalDeaths + 1 end end end
    end
    -- (the chains in the book: how many stages of each, and its last recorded one, for the
    -- worth of a finale; DESIGN §3.0 rule 3)
    local threadCount, threadLast = {}, {}
    if A.QuestDeeds then
        for _, day in ipairs(days) do
            for _, scene in ipairs(day.scenes) do
                for _, q in ipairs(scene.quests or {}) do
                    local story = A.QuestDeeds.Story(q)
                    if story and story.thread then
                        threadCount[story.thread] = (threadCount[story.thread] or 0) + 1
                        threadLast[story.thread] = q
                    end
                end
            end
        end
    end
    history.questZones = {}
    for index, day in ipairs(days) do
        local f = Facts(day)
        if index == 1 then
            local beginning = f.stretches[1]
            history.earlyCoverage = beginning and not beginning.seeded and beginning.level and beginning.level <= 5
                and person.startLevel and person.startLevel <= 5
        end
        local out, majors = {}, {}
        local chapterWhen -- (the day phrase this chapter was given, if any)
        -- Keep the scene attached to its prose. Importance alone cannot tell
        -- whether a sentence supplies the place, work, or quiet end of a scene.
        local scenes, sceneAt = {}, 1
        local levelNums = {} -- (pass 3: level numbers said in this chapter)
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
                -- (not the opening word of the sentence before: "Past Sneed... Past the foundry...")
                local lastWord, firstWord = last:match("^(%a+)"), line:gsub("{%a:", ""):match("^(%a+)")
                if lastWord and firstWord and lastWord:lower() == firstWord:lower() then score = score + 1 end
                -- (nor a word of five letters or more the sentence before used: "all sand and sun. Sand and sun covered")
                local lowLine = line:lower()
                for word in last:lower():gmatch("%f[%a]%l%l%l%l%l+%f[%A]") do
                    if not ECHO_OK[word] and lowLine:find("%f[%a]" .. word .. "%f[%A]") then score = score + 1; break end
                end
                if score < bestScore then best, bestScore = {line}, score elseif score == bestScore then best[#best + 1] = line end
            end
            local line = best[teller.rng(#best)]
            if line and Crowded(line) then return nil end
            return line
        end
        local function DescribeZone(SayLine, zone, avoid, short)
            if history.describedZones[zone or "?"] then return end
            history.describedZones[zone or "?"] = true
            -- (the lines said are remembered: a return after weeks draws another)
            history.zoneLinesSaid = history.zoneLinesSaid or {}
            local saidSoFar = table.concat(out, " "):gsub("{%a:([^}]*)}", "%1")
            teller.epithetWords = {}
            for phrase, words in pairs(teller.epithetPhrases or {}) do
                if saidSoFar:find(phrase, 1, true) then for word in pairs(words) do teller.epithetWords[word] = true end end
            end
            ZoneSight(function(text, ...)
                if text then history.zoneLinesSaid[text] = true end
                return SayLine(text, ...)
            end, teller, zone, PickLore, avoid, short, brief, faction)
        end
        -- The lines of a pool that do not name the zone ({zoneD}), when it was just said.
        -- (right after the water, "There" would put it in the lake)
        local function NotThere(list, avoid)
            if not avoid or not list then return list end
            local kept = {}
            for _, line in ipairs(list) do if not line:find("^There") then kept[#kept + 1] = line end end
            return #kept > 0 and kept or list
        end
        -- A role line the book has not said yet. When every line is used, none:
        -- the reader knows your part by then. Never in two chapters running (2026-11-05).
        local function RoleLine(role, list, st)
            history.roleLines = history.roleLines or {}
            if history.roleChapter and index - history.roleChapter < 2 then return nil end
            local kept = {}
            for _, line in ipairs(list or {}) do if not history.roleLines[line] then kept[#kept + 1] = line end end
            if #kept == 0 then return nil end
            local line = teller:Say("role" .. role, kept, st)
            if line then history.roleLines[line] = true; history.roleChapter = index end
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
        -- (the planned telling's notes: for every line, the event or work behind it, its time and
        -- its stretch; nothing here changes what is said)
        local plan = {metas = {}}
        -- The dungeon runs of the day (2026-11-11): by stretch, for the one-paragraph telling
        -- (the way out and the turn-ins about the run join it), and the bosses the runs have
        -- told, so a quest's turn-in says only what came of the kill.
        local DR = {runs = {}, bosses = {}, scenes = {}}
        local function Say(text, major, kind, required)
            local meta = plan.meta or {}
            plan.meta = nil
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
            -- (pass 3: a level number is said once a chapter. A later line that only mentions it in
            -- passing loses the mention: "at level 26, young for the place" -> "young for the place")
            if kind ~= "level" then
                for num in text:gmatch("level (%d+)") do
                    if levelNums[num] then
                        local n = num
                        text = text:gsub("^At level " .. n .. ", (%l)", string.upper)
                            :gsub(", and at level " .. n .. " I was ", ", and I was ")
                            :gsub(", and I was level " .. n .. " when ", " when ")
                            :gsub(" at level " .. n .. ", young", " young")
                            :gsub(" early, at level " .. n .. "%.", " early.")
                            :gsub(", at level " .. n .. ", ", ", ")
                            :gsub(" at level " .. n .. "%.", ".")
                    end
                end
            end
            -- (a climb from a level the chapter already gave: "I climbed from level 41 to 43" -> "I climbed to level 43")
            text = text:gsub("from level (%d+) to (%d+)", function(a1, b1) if levelNums[a1] then return "to level " .. b1 end end)
            for num in text:gmatch("level (%d+)") do levelNums[num] = true end
            for num in text:gmatch("from (%d+) to") do levelNums[num] = true end
            out[#out + 1] = text
            scenes[#out] = sceneAt
            majors[#out] = major or false
            kinds[#out] = kind
            meta.e, meta.s = meta.e or plan.event, plan.stretch
            meta.t = meta.t or (plan.event and plan.event.t)
                or ((kind == "quests" or kind == "questStart" or kind == "questOutcome" or kind == "level") and sayTime) or plan.stretchT
            meta.said = text
            plan.metas[#out] = meta
            if kind == "quests" or kind == "level" then
                times[#out] = sayTime
                sayTime = nil
            end
            teller:Heard(text)
            if not prefix and #moodQueue > 0 then
                local queued = moodQueue
                moodQueue = {}
                for _, m in ipairs(queued) do
                    out[#out + 1] = m[1]; majors[#out] = m[2] or false; kinds[#out] = "mood"; scenes[#out] = sceneAt
                    plan.metas[#out] = {s = plan.stretch, t = meta.t}
                end
            end
        end
        local stretches = {}
        for _, s in ipairs(f.stretches) do if Worth(s) then stretches[#stretches + 1] = s end end
        stretches = ST.DropQueues(stretches)
        -- The dungeon runs of the day (JournalEpisodes, 2026-11-11): each one stretch, one story.
        stretches = ST.JoinDungeonRuns(stretches, A.JournalEpisodes and A.JournalEpisodes.DungeonRuns(day.scenes) or {})
        for si, s in ipairs(stretches) do if s.run then DR.runs[si] = {name = s.run.dungeon, s = s, run = s.run} end end
        -- (someone who raised you is no stranger when they are of your list, travelled with you on
        -- any recorded day or were in your party that day: "Marrow Rotmoor" is Marrow-Rotmoor, by
        -- first name, 2026-11-11)
        local Lane = {}
        function Lane.FirstName(name) return ((Clean(name):match("^[^%s%-]+") or ""):lower()) end
        function Lane.Known(name)
            local short = Lane.FirstName(name)
            if short == "" then return false end
            for other in pairs(history.companionTime) do if Lane.FirstName(other) == short then return true end end
            for _, s in ipairs(stretches) do for _, w in ipairs(s.with or {}) do if Lane.FirstName(w.name) == short then return true end end end
            for key, info in pairs((A.db and A.db.people) or {}) do
                if type(info) == "table" and ((info.name and Lane.FirstName(info.name) == short) or Lane.FirstName(key) == short) then return true end
            end
            return false
        end
        function Lane.ClassOf(name)
            local short = Lane.FirstName(name)
            for key, info in pairs((A.db and A.db.people) or {}) do
                if type(info) == "table" and ((info.name and Lane.FirstName(info.name) == short) or Lane.FirstName(key) == short) then return info.class end
            end
            return nil
        end
        -- The killer in a sentence: a named foe bare ("Thule Ravenclaw"), a kind of foe with its article
        -- and its kind word lowered ("a Venture Co. geologist"; a species word keeps its capital, "a
        -- Raging Rot Hide"). One text for the death, close-call and memory lines.
        function Lane.Foe(e, name)
            local plain = Clean(name or e.d)
            if not OfAKind(e, plain) then return Place(plain) end
            -- (one rule for both books: the shared helper, "a vampiric duskbat", "a Venture Co. geologist")
            if A.FoeName then
                local named = A.FoeName(plain)
                local art, rest = named:match("^(an?) (.+)$")
                if art then return art .. " " .. Place(rest) end
            end
            local last = plain:match("(%a+)$") or ""
            if last ~= "" and not (A.FoeKindsProper and A.FoeKindsProper[last]) and not plain:find(" of ", 1, true) then
                plain = plain:sub(1, #plain - #last) .. last:lower()
            end
            return (plain:match("^[AEIOUaeiou]") and "an " or "a ") .. Place(plain)
        end
        -- (a companion's death in a city, or with no death, fight or quest of ours within five
        -- minutes of it, is not told: reader D4, 2026-11-11)
        function Lane.StrayDeath(e, s)
            if CITY_ZONE[s.zone or ""] then return true end
            local t = e.t or 0
            for _, x in ipairs(s.events) do
                if x ~= e and (x.k == "death" or x.k == "boss" or x.k == "wipe" or x.k == "pdeath" or x.k == "close") and math.abs((x.t or 0) - t) <= 300 then return false end
            end
            for _, q in ipairs(s.quests or {}) do if math.abs((q.t or 0) - t) <= 300 then return false end end
            return true
        end
        -- (who taught me to raise the dead, when an earlier chapter said so: "taught me redemption";
        -- the first name of the person in that sentence or the one before it)
        function Lane.Teacher()
            if history.raiseTeacher ~= nil then return history.raiseTeacher or nil end
            history.raiseTeacher = false
            for i = 1, index - 1 do
                local story = days[i] and stories[days[i].key]
                local text = story and story.text and (A.JournalPlain and A.JournalPlain(story.text) or Clean(story.text)) or ""
                -- (the reader's own notes under a chapter count as told)
                for _, quote in ipairs(story and story.quotes or {}) do if type(quote) == "table" and quote.text then text = text .. " " .. Clean(quote.text) end end
                local name = ST.RaiseTeacher(text)
                if name then history.raiseTeacher = name; return name end
            end
            return nil
        end
        -- A stay with nothing in it but the going (lane G, 2026-11-11): no quest, fight, death,
        -- rest, work or first other than the ground itself and the crossing. Such a place is
        -- named, never described: a place is entered for a reason or only named, and its lines
        -- join the next stop's paragraph so a journey is a sentence or two, not a paragraph a zone.
        local BARE_FIRSTS = {zone = true, flight = true, continent = true, zeppelin = true, boat = true, tram = true, landmark = true}
        local BARE_KINDS = {play = true, town = true, voyage = true, taxi = true, nightflight = true, hearth = true, with = true, cave = true, swim = true}
        function Lane.Bare(s)
            if (s.questCount or 0) > 0 or next(s.gather or {}) ~= nil or next(s.craft or {}) ~= nil then return false end
            for _, e in ipairs(s.events) do
                if e.k == "first" then
                    if not BARE_FIRSTS[e.d] then return false end
                elseif not BARE_KINDS[e.k] then return false end
            end
            return true
        end
        -- (the plain raise line after level ten: a druid or a shaman does not pray anyone back)
        function Lane.LateRaisePool()
            if person.class == "PRIEST" or person.class == "PALADIN" then return W.rezOtherLate end
            local kept = {}
            for _, line in ipairs(W.rezOtherLate) do if not line:find("pray", 1, true) and not line:find("Light", 1, true) then kept[#kept + 1] = line end end
            return #kept > 0 and kept or W.rezOtherLate
        end
        ST.DeathRuns(stretches)
        -- Which few quests this chapter tells (DESIGN §3.0 rule 3): the top three by worth in
        -- Everything, one (two when the second is a real turn) in Highlights; the rest fold
        -- into light grouped lines, or in Highlights are left out.
        local dayPlan = A.QuestDeeds and A.QuestDeeds.Plan(stretches, {threadCount = threadCount, threadLast = threadLast,
            told = function(key) return history.questLore[key] and true or false end, zonesSeen = history.questZones,
            limit = brief and 2 or 3, floor = brief and 9 or 5, brief = brief}) or {byQuest = {}, entries = {}}
        -- Does a quest of the day, one the chapter tells, name this boss? (The run's kill line is
        -- shaped around it, and the lord's consequence line gives way to the turn-in's own telling.)
        function DR.QuestText(e)
            local parts = {tostring(e.quest and e.quest.title or "")}
            if e.act and e.act.act then parts[#parts + 1] = tostring(e.act.act) end
            local pov = e.story and e.story.pov
            if type(pov) == "table" then for _, line in ipairs(pov) do parts[#parts + 1] = tostring(line) end end
            return A.JournalPlain(table.concat(parts, " "))
        end
        function DR.NamesIn(text, name)
            local plain = Clean(name)
            if plain == "" then return false end
            if text:find(plain, 1, true) then return true end
            local short = L and L.Short and L.Short(plain)
            return (short and short ~= plain and text:find("%f[%w']" .. short:gsub("%p", "%%%0") .. "%f[^%w']")) and true or false
        end
        function DR.QuestNamesBoss(name)
            for _, e in ipairs(dayPlan.entries or {}) do
                -- (a fallback quest's progress lines never stand for the kill: the lord's own line closes the run)
                if e.mention and not (e.story and e.story.progress) and DR.NamesIn(DR.QuestText(e), name) then return true end
            end
            return false
        end
        -- A quest about a run: one of the run's own (JournalEpisodes), or failing that one whose
        -- words name the dungeon or a boss killed in it.
        function DR.QuestAboutRun(e, run)
            if run.run and run.run.quests then
                for _, rq in ipairs(run.run.quests) do if rq.quest == e.quest then return true end end
                return false
            end
            local text = DR.QuestText(e)
            if DR.NamesIn(text, (Clean(run.name):gsub("^The ", ""))) then return true end
            for _, b in ipairs(run.s.bosses or {}) do if DR.NamesIn(text, b.name) then return true end end
            return false
        end
        -- What it is like inside a dungeon, once (the concrete thing seen there, or the place):
        -- said with the opening of the run.
        function DR.SayInside(dn, s, st)
            dn.insideNext = nil
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
        -- The entry line's pool with the company in it (round 2, 2026-11-11): named when the record
        -- knows them and they are few, counted when more went; once a chapter.
        function DR.EntryPool(e, s, st, pool)
            if DR.partySaid then return pool end
            local party = 0
            for _, x in ipairs(s.events) do if x.k == "boss" and tonumber(x.n) then party = math.max(party, tonumber(x.n)) end end
            if party < 2 then party = #s.with + 1 end
            local names = {}
            if s.run and s.run.party then
                party = s.run.party.count or party
                for _, name in ipairs(s.run.party.names or {}) do names[#names + 1] = N(name) end
            else
                for _, w in ipairs(s.with) do names[#names + 1] = N(w.name) end
            end
            local down = UNDERGROUND[e.d]
            if #names >= 1 and #names <= 3 and W.dungeonNames then
                DR.partySaid = true
                -- (more went than the record names: "Dahlia, Marrow, Borox and one more", never a count the names contradict)
                local more = party > #names + 1
                if more then names[#names + 1] = Words(party - #names - 1) .. " more" end
                st.names, st.count = List(names), Words(party)
                st.namesI = (#names >= 2 and table.concat(names, ", ") or names[1]) .. " and I"
                local pool = (down and W.dungeonNamesDown) or W.dungeonNames
                -- ("Dahlia, Marrow, Borox, one more and I" reads badly: with a count, the "with" lines; and a
                -- place with a lore clause to take wants a line that ends on it)
                local info = L and L.Dungeon and L.Dungeon(e.d)
                local wantsEnd = info and type(info.lore) == "table" and #info.lore > 0
                local kept = {}
                for _, line in ipairs(pool) do
                    if not (more and line:find("{namesI}", 1, true)) and not (wantsEnd and not line:find("{dungeonE}%.$")) then kept[#kept + 1] = line end
                end
                if #kept > 0 then pool = kept end
                return pool
            elseif party >= 3 and party <= 10 and W.dungeonParty then
                DR.partySaid = true
                st.count = Words(party)
                return (down and W.dungeonPartyDown) or W.dungeonParty
            end
            return pool
        end
        -- The run's reason, chosen before the entry (round 6): from the quest that sent us (its setup
        -- lines) and the dungeon's own reasons, the line in which someone wants something, one
        -- sentence, naming neither the place (the entry names it) nor the goal (its identity is kept
        -- for the climax); then the nearest shape to that.
        function DR.Reason(e, s, story, visits, inside, fled, st)
            if fled or not inside or visits ~= 0 then return nil end
            local lines = {}
            local sent = s.run and s.run.quests and s.run.quests[1]
            local sentStory = sent and L and L.QuestStory and L.QuestStory(sent.quest.title, sent.quest.qid)
            if sentStory and type(sentStory.why) == "table" and #sentStory.why > 0 and not history.questLore[A.QuestDeeds.Key(sent.quest)] then
                for _, line in ipairs(sentStory.why) do lines[#lines + 1] = line end
                st.sentQuest = sent
                DR.sentQuests = DR.sentQuests or {}
                DR.sentQuests[A.QuestDeeds.Key(sent.quest)] = true
            end
            local classWhy = story and story.whyClass and story.whyClass[person.class or ""]
            if person.class == "PRIEST" and not LIGHT_RACES[race] then classWhy = nil end
            local own = story and ((story.whyRace and story.whyRace[race]) or classWhy or story.why)
            for _, line in ipairs(own or {}) do lines[#lines + 1] = line end
            if #lines == 0 then return nil end
            local bossNames = {}
            for _, b in ipairs(s.bosses) do bossNames[#bossNames + 1] = Clean(b.name) end
            if story and story.last then bossNames[#bossNames + 1] = Clean(story.last) end
            local function NamesBoss(line)
                local plain = A.JournalPlain(line)
                for _, name in ipairs(bossNames) do
                    if plain:find(name, 1, true) then return true end
                    local short = L and L.Short and L.Short(name)
                    if short and short ~= name and plain:find(short, 1, true) then return true end
                end
                return false
            end
            local function Want(line)
                local plain = A.JournalPlain(line)
                return plain:find("%u[%a']+ wanted") or plain:find("%u[%a']+ needed") or plain:find("%u[%a']+ asked") or plain:find("%u[%a']+ sent")
                    or plain:find("%u[%a']+ sought") or plain:find("%u[%a']+ wished") or plain:find("%u[%a']+ called for") or plain:find("%u[%a']+ hoped")
            end
            local function One(line) return not line:find("%. ") end
            local function NamesPlace(line) return A.JournalPlain(line):find(Clean(e.d), 1, true) end
            -- (a want first of all; the reason may name the goal, its identity stays for the climax)
            local tiers = {
                function(l) return Want(l) and One(l) and not NamesBoss(l) and not NamesPlace(l) end,
                function(l) return Want(l) and One(l) and not NamesPlace(l) end,
                function(l) return Want(l) and One(l) end,
                function(l) return One(l) and not NamesBoss(l) and not NamesPlace(l) end,
                function(l) return One(l) and not NamesPlace(l) end,
                function(l) return One(l) end,
                function() return true end,
            }
            for _, fits in ipairs(tiers) do
                local kept = {}
                for _, line in ipairs(lines) do if fits(line) then kept[#kept + 1] = line end end
                if #kept > 0 then return PickLore(kept) end
            end
            return nil
        end
        -- The lore of the place, once, folded into the entry line when it ends on the place and no
        -- epithet named it; the inside line then stays unsaid. Not a clause that repeats the reason's
        -- words or the lord's identity (round 6: the place and the cult once, the identity at the climax).
        function DR.LoreClause(e, info, st)
            if not (info and type(info.lore) == "table" and #info.lore > 0 and st.dungeonE == Place(e.d)) then return end
            if not (out[#out] or ""):find(Clean(e.d) .. "}?%.$") then return end
            local avoid = (st.reason and A.JournalPlain(st.reason) or ""):lower()
            local lordStory = L and L.DungeonStory and L.DungeonStory(e.d)
            local lordLore = lordStory and lordStory.last and L.Boss and L.Boss(lordStory.last)
            if lordLore and lordLore.e then avoid = avoid .. " " .. lordLore.e:lower() end
            local kept = {}
            for _, line in ipairs(info.lore) do
                local clash = false
                for word in line:lower():gmatch("%a%a%a%a%a+") do
                    if avoid:find(word:gsub("s$", ""), 1, true) then clash = true end
                end
                if not clash then kept[#kept + 1] = line end
            end
            if #kept == 0 then return end
            local clause = kept[teller.rng(#kept)]
            out[#out] = out[#out]:gsub("%.$", "") .. ", " .. clause .. "."
            st.loreClause = clause
            if st.dungeonNow then st.dungeonNow.insideNext = nil end
        end
        -- The first dungeon of my life (round 4): folded into the entry right after the place
        -- ("...into Ragefire Chasm, my first dungeon, a lava cave crawling with troggs."); when the
        -- entry line does not name the place plainly, its own short sentence after the opening.
        function DR.FirstDungeonLine(st, e)
            if not W.firstDungeonLine then return end
            local place = Clean(e.d)
            local line = out[#out] or ""
            local at, stop = line:find(place, 1, true)
            if at and W.firstDungeonFold then
                if line:sub(stop + 1, stop + 1) == "}" then stop = stop + 1 end
                local rest = line:sub(stop + 1)
                local fold = (teller:Say("firstDungeonFold", W.firstDungeonFold, st) or "my first dungeon"):gsub("^%u", string.lower)
                if rest:match("^[%.,]") then out[#out] = line:sub(1, stop) .. ", " .. fold .. rest
                else out[#out] = line:sub(1, stop) .. ", " .. fold .. "," .. rest end
                out[#out] = out[#out]:gsub(",,", ",")
            else
                st.firstDungeonPending = true
            end
            st.dungeonNow.firstSaid = true
        end
        -- The reason joins the entry line said just before it ("..., so with ... I went down into ..."),
        -- or the two swap places when the joined sentence would run long.
        function DR.ReasonFirst()
            local n = #out
            if n < 2 or kinds[n] ~= "lore" or plan.metas[n - 1] == nil then return end
            local entry, why = out[n - 1], out[n]
            if not (entry:match("%.$") and why:match("%.$")) or entry:find("%. ") then return end
            local words = 0
            for _ in (entry .. " " .. why):gmatch("%S+") do words = words + 1 end
            local lead = entry:gsub("^Then ", "")
            if not lead:match("^I ") and not lead:match("^{") then lead = lead:gsub("^%u", string.lower) end
            -- (a plain entry joins: "I went", "we went", "with X, I went"; one that opens on the place, "Maraudon
            -- held foes stronger than us", or on a companion's joining, comes second instead)
            local plainEntry = lead:match("^[Ii] ") or lead:match("^[Ww]e ") or lead:match("^[Ww]ith ") or lead:match("^[Tt]he %a+ of us")
                or lead:match("^[Tt]here were") or (lead:match("^{n:") and lead:find(" went ", 1, true))
            if words <= 40 and not why:find(", ", 1, true) and not why:find("%. ") and plainEntry then
                out[n - 1] = why:gsub("%.$", "") .. ", so " .. lead
                DR.RemoveLine(n)
            else
                out[n - 1], out[n] = why, entry
                majors[n - 1], majors[n] = majors[n], majors[n - 1]
                kinds[n - 1], kinds[n] = kinds[n], kinds[n - 1]
                plan.metas[n - 1], plan.metas[n] = plan.metas[n], plan.metas[n - 1]
            end
        end
        -- A level reached inside the run is told at the kill it came with (round 5): right after the
        -- line that told that kill. The level line said elsewhere for it is dropped from the run.
        function DR.LevelAtKill(names, s, st)
            local run = s.run
            if not (run and run.level and W.runLevelAt) or DR.levelToldAt == run.level.t then return end
            local levelT = run.level.t
            if levelT < (run.entered or 0) or levelT > (run.left or 0) then return end
            local at
            for _, b in ipairs(run.bosses or {}) do if b.t <= levelT + 60 and (not at or b.t > at.t) then at = b end end
            if not at then return end
            local told = false
            for _, name in ipairs(names) do if name == at.name then told = true end end
            if not told then return end
            DR.levelToldAt = levelT
            local number = tostring(run.level.level)
            local last = out[#out] or ""
            if last:find(Clean(at.name):gsub("%p", "%%%0") .. "}?%.$") and not last:find("%. ") then
                -- ("We brought down Ghamoo-ra, and level 23 came with it.")
                out[#out] = last:gsub("%.$", "") .. ", and level " .. number .. " came with it."
                return
            end
            plan.meta = {runLevel = true}
            Say(teller:Say("runLevelAt", W.runLevelAt, {level = number, boss = Place((L and L.Short and L.Short(at.name)) or at.name),
                Boss = Place((L and L.Short and L.Short(at.name)) or at.name)}), true, "level")
        end
        -- A line of the chapter removed, every parallel array shifted (kinds and times are sparse:
        -- table.remove cannot shift them).
        function DR.RemoveLine(i)
            local len = #out
            for _, arr in ipairs({out, majors, kinds, times, scenes, plan.metas}) do
                for j = i, len - 1 do arr[j] = arr[j + 1] end
                arr[len] = nil
            end
        end
        -- The run's closure (round 4), from the lines moved up after it: the way out gives way to a
        -- turn-in line that names the place ("We came up into Orgrimmar with Taragaman's heart, proof
        -- for Thrall ..."); a level folds into the line before it as a clause ("..., and the run took
        -- me to level 17."), else stands as its own sentence.
        function DR.Closure(from, to, after)
            local Remove = DR.RemoveLine
            local moveAt, questAt, levelAt
            for i = from, to do
                if kinds[i] == "move" and not moveAt then moveAt = i
                elseif (kinds[i] == "questStart" or kinds[i] == "questOutcome") and not questAt then questAt = i
                elseif kinds[i] == "level" then levelAt = i end
            end
            if moveAt and questAt and questAt > moveAt and after and after.zone
                and A.JournalPlain(out[questAt]):find(A.JournalPlain(Place(after.zone)), 1, true) then
                Remove(moveAt)
                questAt, to = questAt - 1, to - 1
                if levelAt then levelAt = levelAt - 1 end
            end
            if levelAt and levelAt < to and (moveAt or questAt) then
                for _, arr in ipairs({out, majors, kinds, times, scenes, plan.metas}) do
                    local moved = arr[levelAt]
                    for i = levelAt, to - 1 do arr[i] = arr[i + 1] end
                    arr[to] = moved
                end
                levelAt = to
            end
            if levelAt then
                -- (the level reached: the last number the line gives, "from level 16 to 18" is 18)
                local number
                for n in A.JournalPlain(out[levelAt]):gmatch("[Ll]evel (%w+)") do number = n end
                for n in A.JournalPlain(out[levelAt]):gmatch("to (%d+)") do number = n end
                local prev = levelAt > from and out[levelAt - 1] or nil
                local words = 0
                for _ in (prev or ""):gmatch("%S+") do words = words + 1 end
                if number and prev and words <= 30 and prev:match("%.$") and not prev:find("%. ") and W.runLevelClause then
                    local pool = W.runLevelClause
                    if prev:find("came", 1, true) then
                        pool = {}
                        for _, line in ipairs(W.runLevelClause) do if not line:find("came", 1, true) then pool[#pool + 1] = line end end
                    end
                    local clause = teller:Say("runLevelClause", pool, {level = number})
                    if clause then
                        if not clause:match("^I ") then clause = clause:gsub("^%u", string.lower) end
                        out[levelAt - 1] = prev:gsub("%.$", "") .. ", and " .. clause .. "."
                        majors[levelAt - 1] = majors[levelAt - 1] or majors[levelAt]
                        Remove(levelAt)
                    end
                elseif number and W.runLevel then
                    out[levelAt] = teller:Say("runLevel", W.runLevel, {level = number}) or out[levelAt]
                end
            end
        end
        -- The lines of a lore pool that do not repeat a word of the entry's lore clause.
        function DR.WithoutClause(lines, clause)
            local kept = {}
            for _, line in ipairs(lines) do
                local clash = false
                for word in clause:lower():gmatch("%a%a%a%a%a+") do
                    if line:lower():find(word:gsub("s$", ""), 1, true) then clash = true end
                end
                if not clash then kept[#kept + 1] = line end
            end
            return #kept > 0 and kept or lines
        end
        -- The run's second try as a beat: which try, and "went better" when nobody fell after it.
        function DR.BackDownPool(e, s, st, together)
            local tries, quiet = 2, true
            for _, x in ipairs(s.events) do
                if x.k == "dungeon" and x.retry and (x.t or 0) < (e.t or 0) then tries = tries + 1 end
                if (x.k == "death" or x.k == "pdeath") and (x.t or 0) > (e.t or 0) then quiet = false end
            end
            st.try = Ordinal(tries)
            st.ourselves = together and "ourselves" or "myself"
            local down = UNDERGROUND[e.d]
            -- (word echo, round 4: "down" at most twice in the run's lines)
            local downs = 0
            for n = 1, #out do if scenes[n] == plan.stretch then for _ in out[n]:lower():gmatch("%f[%a]down%f[%A]") do downs = downs + 1 end end end
            if downs >= 2 then down = false end
            return (quiet and ((down and W.dungeonBackDownWell) or W.dungeonBackInWell)) or (down and W.dungeonBackDown) or W.dungeonBackIn or W.dungeonBackDown
        end
        -- The turn-in of a quest whose boss a run told already today: only what came of it, the
        -- stage's own `afterRun` line, else its outcome, else the plain turn.
        function DR.AfterRun(line, own, from, e, variant, tokens, S, q, zoneD, si)
            local sent = DR.sentQuests and DR.sentQuests[A.QuestDeeds.Key(q)]
            if not line or not (sent or (own and next(DR.bosses))) then return line, own, from end
            local plainLine = A.JournalPlain(line)
            local told = sent and true or false
            for raw in pairs(DR.bosses) do if DR.NamesIn(plainLine, raw) then told = true end end
            if not told then return line, own, from end
            -- (a fallback quest's "went on" / "a step forward" line is never the outcome of a run that killed
            -- its goal: the turn-in says nothing, the run's own ending closes it)
            if e.story and e.story.progress then return nil, own, from end
            local pov = e.story and e.story.pov
            local after = type(pov) == "table" and pov.afterRun
            if type(after) == "table" and #after > 0 then
                -- ({zone}: where the turn-in was; a line that names it only right after the run, where the way out joins)
                tokens.zone = zoneD
                local rightAfter = si and DR.runs[si - 1] ~= nil
                local pool = {}
                for _, l in ipairs(after) do if rightAfter or not l:find("{zone}", 1, true) then pool[#pool + 1] = l end end
                if #pool == 0 then pool = after end
                return A.QuestDeeds.Fill(pool[((variant or 1) - 1) % #pool + 1], tokens), own, from
            elseif e.story and type(e.story.after) == "table" and #e.story.after > 0 then
                return A.QuestDeeds.NoSemicolon(e.story.after[((variant or 1) - 1) % #e.story.after + 1]), false, "after"
            end
            return S .. " saw " .. Q(q.title) .. " through.", own, from
        end
        -- Inside a dungeon run (lane G, 2026-11-11), the deaths that were not at a boss (mine to
        -- the place's ordinary foes, the party's) and the raises after them are not told one by
        -- one between the kills: they are gathered and said in one sentence after the bosses that
        -- led to the goal, so the run reads as a progression and no death is told ahead of a boss
        -- the record puts before it. A lost fight that took me with the party, the first try at a
        -- dungeon and my first raise of someone keep their own passage. A boss that killed someone
        -- before it fell stays in the progression, and the loss is said with the others. A level
        -- inside the run is told at the kill it came with, so it does not break the kills either.
        function DR.Quiet(e)
            if not DR.gathered then return false end
            if e.lossGathered or e.skip or e.k == "mylevel" then return true end
            if e.told and (e.k == "death" or e.k == "pdeath" or e.k == "rez") then return true end
            if e.k == "pdeath" and e.boss then return true end -- (said with that boss's kill)
            return false
        end
        function DR.GatherLosses(s)
            DR.gathered, DR.losses, DR.costly, DR.lossesSaid = nil, nil, {}, nil
            if not (s.run and W.runLosses) then return end
            if history.deaths == 0 and (person.startLevel or 99) <= 9 then return end
            local G = {me = 0, foes = {}, foeOrder = {}, raisers = {}, raiserOrder = {}, raised = 0, party = {}, partyOrder = {}}
            local function Take(e)
                e.lossGathered, e.told = true, true
                if e.k == "death" then
                    G.me = G.me + 1
                    local kind = Clean(e.d)
                    if not G.foes[kind] then G.foes[kind] = 0; G.foeOrder[#G.foeOrder + 1] = e end
                    G.foes[kind] = G.foes[kind] + 1
                elseif e.k == "pdeath" then
                    local key = Lane.FirstName(e.n)
                    if not G.party[key] then G.party[key] = 0; G.partyOrder[#G.partyOrder + 1] = e.n end
                    G.party[key] = G.party[key] + 1
                elseif e.k == "rez" then
                    local by = Lane.Known(e.by) and (Clean(e.by):match("^[^%s%-]+") or Clean(e.by)) or Clean(e.by)
                    if not G.raisers[by] then G.raisers[by] = true; G.raiserOrder[#G.raiserOrder + 1] = by end
                    G.raised = G.raised + 1
                end
            end
            -- (a death that ended a try, with the walk back in after it, is the wipe's own passage)
            local function WipeDeath(e)
                for _, at in ipairs(s.run.attempts or {}) do
                    if at.wipe and (e.t or 0) >= (at.entered or 0) and (e.t or 0) < (at.left or 0) then
                        local lastBoss = 0
                        for _, b in ipairs(at.bosses or {}) do if b.t > lastBoss then lastBoss = b.t end end
                        -- (a death logged the same second as a kill fell with that boss, not after it)
                        if (e.t or 0) > lastBoss then return true end
                    end
                end
                return false
            end
            local any = false
            for _, e in ipairs(s.events) do
                local r = e.deathRun
                if r then
                    local keep = r.firstTry or r.wipe
                    for _, it in ipairs(r.items) do if it.k == "raise" or WipeDeath(it.e) then keep = true end end
                    if not keep then
                        e.deathRun = nil
                        for _, it in ipairs(r.items) do Take(it.e) end
                        any = true
                    end
                elseif not e.told and not e.skip and not WipeDeath(e) then
                    if e.k == "death" and e.d and not e.boss and not e.env and not e.pr and not e.pc then Take(e); any = true
                    elseif e.k == "pdeath" and e.n and not e.boss then Take(e); any = true
                    elseif e.k == "rez" and e.by and not Clean(e.by):lower():find("spirit healer", 1, true) and not Clean(e.by):match("^%l") then
                        local mine = false
                        for _, x in ipairs(s.events) do
                            if x.k == "death" and x.lossGathered and (x.t or 0) <= (e.t or 0) and (e.t or 0) - (x.t or 0) <= 1200 then mine = true end
                        end
                        if mine then Take(e) end
                    end
                end
            end
            -- (a run is told this way even with no loss to gather: a boss that killed someone, a told
            -- passage or a level never breaks the kills into a list)
            DR.gathered = true
            if not any then return end
            history.deaths = history.deaths + G.me
            if G.me > 0 then history.deathDay = index end
            DR.losses = G
        end
        function DR.SayLosses(s, st)
            local G = DR.losses
            if not G then return end
            local function Times(n) return n == 1 and "once" or n == 2 and "twice" or (Words(n) .. " times") end
            local function Plural(e)
                local text = Lane.Foe(e):gsub("^an? ", "")
                if not OfAKind(e) then return text end
                if text:match("man$") then return (text:gsub("man$", "men")) end
                if text:match("[sxz]$") or text:match("[cs]h$") then return text .. "es" end
                return text .. "s"
            end
            local t = {us = st.us, our = st.our, we = st.we, We = st.We}
            local lines = {}
            if not DR.lossesSaid then
                DR.lossesSaid = true
                if G.me > 0 then
                    local foes = {}
                    for i, e in ipairs(G.foeOrder) do
                        if i <= 2 then foes[#foes + 1] = (G.foes[Clean(e.d)] == 1) and Lane.Foe(e) or Plural(e) end
                    end
                    if #G.foeOrder > 2 then foes[#foes + 1] = "others" end
                    t.foes = List(foes)
                    t.Foes = Cap(t.foes)
                    t.count = Times(G.me)
                    local raisers = {}
                    for _, by in ipairs(G.raiserOrder) do raisers[#raisers + 1] = N(by) end
                    t.raisers, t.Raisers = List(raisers), Cap(List(raisers))
                    t.rcount = Times(G.raised)
                    local pool = (G.raised == 0 and W.runLosses.meWalked) or (G.raised >= G.me and W.runLosses.meRaised) or W.runLosses.meRaisedSome
                    local line = teller:Say("runLosses", pool, t)
                    if line and G.me == 1 then line = line:gsub(" each time", ""):gsub("each time ", "") end
                    lines[#lines + 1] = line
                end
                if #G.partyOrder > 0 then
                    local names, total, allOnce = {}, 0, true
                    for _, full in ipairs(G.partyOrder) do
                        names[#names + 1] = N(full)
                        local n = G.party[Lane.FirstName(full)]
                        total = total + n
                        if n > 1 then allOnce = false end
                    end
                    t.names = List(names)
                    t.Names = t.names
                    t.tally = (#names == 1 and Times(total)) or (allOnce and "once each") or (Words(total) .. " times between them")
                    local pool = (G.me > 0 and W.runLosses.partyToo) or W.runLosses.party
                    -- ("between them between the fights": the other line)
                    if t.tally:find("between them", 1, true) then
                        local kept = {}
                        for _, line in ipairs(pool) do if not line:find("between the fights", 1, true) then kept[#kept + 1] = line end end
                        if #kept > 0 then pool = kept end
                    end
                    lines[#lines + 1] = teller:Say("runLossesParty", pool, t)
                end
            end
            for _, line in ipairs(lines) do Say(line, true, "death") end
        end
        -- The one a boss killed before it fell, said right after the line that told that kill
        -- (names: the bosses that line told; nil: whatever is left).
        function DR.SayCostly(names)
            local left = {}
            -- (the same companion down to several of these bosses: one line, the bosses in turn)
            local byNames, groups = {}, {}
            for _, c in ipairs(DR.costly or {}) do
                local told = names == nil
                for _, n in ipairs(names or {}) do if n == c.boss then told = true end end
                if told then
                    local key = List(c.names)
                    if not byNames[key] then byNames[key] = {}; groups[#groups + 1] = key end
                    table.insert(byNames[key], c)
                end
            end
            for _, key in ipairs(groups) do
                if #byNames[key] >= 2 and W.runLosses.costlyMany then
                    local bosses = {}
                    for _, c in ipairs(byNames[key]) do bosses[#bosses + 1] = Place(c.boss); c.folded = true end
                    Say(teller:Say("runLossesCostlyMany", W.runLosses.costlyMany, {names = key, Names = key, bosses = List(bosses), Bosses = List(bosses)}), true, "death")
                end
            end
            for _, c in ipairs(DR.costly or {}) do
                local told = names == nil
                for _, n in ipairs(names or {}) do if n == c.boss then told = true end end
                if c.folded then
                    -- (said above)
                elseif told then
                    local lore = L and L.Boss and L.Boss(c.boss)
                    local E = A.JournalEpisodes
                    local he = (E and E.BossPronoun and E.BossPronoun(c.boss, lore)) or "he"
                    -- (the line before named the boss: the one it killed leads, "Pip fell to Grubbis before he did")
                    local pool = W.runLosses.costly
                    if (out[#out] or ""):find(Clean(c.boss), 1, true) then
                        local kept = {}
                        for _, line in ipairs(pool) do if line:find("^{Names}") then kept[#kept + 1] = line end end
                        if #kept > 0 then pool = kept end
                    end
                    Say(teller:Say("runLossesCostly", pool, {Boss = Place(c.boss), boss = Place(c.boss), names = List(c.names), Names = List(c.names), he = he}), true, "death")
                else left[#left + 1] = c end
            end
            DR.costly = left
        end
        -- The zone a run came out into when that stay was only crossed and folded into the run's
        -- stay: the first crossed zone that is open ground, never the cave mouth or another dungeon.
        function DR.OutZone(s)
            for _, z in ipairs((s.scene and s.scene.crossed) or {}) do
                local plain, here = Clean(z), Clean(s.zone or "")
                local mouth = (L and L.Dungeon and L.Dungeon(plain)) or (A.SelfUnderground and A.SelfUnderground(plain))
                    or (here ~= "" and (plain:find(here, 1, true) or here:find(plain, 1, true)))
                if not mouth and not CITY_ZONE[plain] then return z end
            end
            return nil
        end
        -- Does a boss of the stretch still come after the event being told?
        function DR.MoreBosses(s)
            local now = (plan.event and plan.event.t) or 0
            for _, x in ipairs(s.events) do if x.k == "boss" and (x.t or 0) > now then return true end end
            return false
        end
        local foldShape, giversNamed, momentsSaid, restSaid = 0, {}, 0, {}
        -- (what the day's quests say: a cave, a book or a place that belongs to the work is told by
        -- the work, not again on its own: "I read Scarlet Crusade Documents" was a quest item)
        local workText
        local function WorkText()
            if workText then return workText end
            local parts = {}
            for _, e in ipairs(dayPlan.entries or {}) do
                parts[#parts + 1] = tostring(e.quest.title)
                if e.act and e.act.act then parts[#parts + 1] = e.act.act end
                for _, field in ipairs({"pov", "why", "after", "highlight"}) do
                    for _, l in ipairs(e.story and e.story[field] or {}) do parts[#parts + 1] = l end
                end
            end
            workText = A.JournalPlain(table.concat(parts, " "))
            return workText
        end
        local function OfTheWork(name)
            local plain = Clean(name):gsub("^The ", "")
            if WorkText():find(plain, 1, true) then return true end
            -- (two names in common with a quest's title: "Scarlet Crusade Documents", "The Scarlet Crusade")
            for _, e in ipairs(dayPlan.entries or {}) do
                local title, shared = A.JournalPlain(tostring(e.quest.title)), 0
                for w in plain:gmatch("%u%a%a%a+") do if title:find(w, 1, true) then shared = shared + 1 end end
                if shared >= 2 then return true end
            end
            return false
        end
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
            chapterWhen = When
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
                When = When, WhenBare = When and (When:gsub("^On ", "")), part = part}
            -- (the epithet's own words, for the sight lines to steer clear of once the opening has said it)
            teller.epithetWords, teller.epithetPhrases = {}, {}
            do
                local STOP = {the = true, ["and"] = true, all = true, of = true, where = true, its = true, old = true, among = true}
                -- (the opening may say either form: "Tanaris, all sand and sun" came from {zoneLore}, 2026-11-06)
                for _, form in ipairs({tokens.zoneE, tokens.zoneLore}) do
                    if form and form ~= tokens.zoneD then
                        local phrase = form:gsub("{%a:([^}]*)}", "%1")
                        local words = {}
                        for word in phrase:lower():gmatch("%a%a%a+") do if not STOP[word] then words[word] = true end end
                        teller.epithetPhrases[phrase] = words
                    end
                end
            end
            -- The chapter header carries the date. After a chapter that opened on
            -- the day ("On Thursday, I..."), a chapter a week or less later opens on
            -- the place or the company instead; every fourth such chapter keeps the
            -- day, so the two shapes do not simply alternate. (Deterministic.)
            local plainOpen = When ~= nil and gap ~= nil and gap >= 1 and gap <= 7 and history.whenLedAt == index - 1
                and (history.plainOpens or 0) % 4 ~= 3
            if plainOpen then history.plainOpens = (history.plainOpens or 0) + 1 end
            local function OpenPool(key, pool)
                if plainOpen and W[key .. "Bare"] then return key .. "Bare", W[key .. "Bare"] end
                return key, pool
            end
            -- (the opening line from a pool, or its bare twin: both values of OpenPool, which a call in
            -- argument position would truncate to the first)
            local function SayOpen(key, pool)
                local k, list = OpenPool(key, pool)
                return teller:Say(k, list, tokens)
            end
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
            local function LeftHome(zone, crossed)
                if history.leftHome or not W.leaveHomeFirst or not W.leaveHomeFirst[race] or (person.startLevel or 99) > 10 then return end
                local start = L and L.starts and L.starts[race]
                if not start or zone == start or CITY_ZONE[zone] or (CITY_ZONE[zone] == nil and false) then return end
                for city, around in pairs(CITY_ZONE) do if city == zone and around == start then return end end
                -- (only a home the book has stood in, or opened from: a tauren whose record begins in
                -- Durotar at level six never "left Mulgore behind")
                if not history.zones[start] and not history.originSaid then return end
                history.leftHome = true
                -- (a crossing the same day: the sea lies between)
                local pool = (crossed and W.leaveHomeFirstSea and W.leaveHomeFirstSea[race]) or Fresh(W.leaveHomeFirst[race])
                -- ("Silverpine Forest, where I had never been. It was the first time I had gone beyond Tirisfal."
                -- says the first twice: after such a line, the home is what lies behind)
                local before = (out[#out] or ""):lower()
                if before:find("never been", 1, true) or before:find("first time", 1, true) or before:find("new to me", 1, true) or before:find("never seen", 1, true) then
                    local kept = {}
                    for _, line in ipairs(pool) do if not line:find("first time", 1, true) then kept[#kept + 1] = line end end
                    if #kept > 0 then pool = kept end
                end
                Say(teller:Say("leaveHomeFirst", pool, {}), true)
            end
            -- A first visit, told by what the record holds: who came with you, your level against the
            -- country's, where you came from. The shapes that apply take turns with the plain line
            -- (a counter, not a draw). Returns the shape, or nil for the plain line.
            local function FirstVisitShape(s, withNames, fromZone)
                local shapes = {}
                if withNames then shapes[#shapes + 1] = "with" end
                local range = L and L.ZoneLevels and L.ZoneLevels(s.zone)
                local danger = Danger(s.level, range and range[1], range and range[2])
                if danger == "daring" or danger == "reckless" then shapes[#shapes + 1] = "young"
                elseif danger == "easy" or danger == "revisit" then shapes[#shapes + 1] = "late" end
                if fromZone then shapes[#shapes + 1] = "from" end
                history.firstVisitN = (history.firstVisitN or 0) + 1
                if #shapes == 0 then return nil end
                local pick = history.firstVisitN % (#shapes + 1)
                if pick == 0 then return nil end
                return shapes[pick]
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
                -- (never "one weeks" or "zero weeks": ten days is a week, five days is days)
                if n < 7 then return n <= 1 and "a day" or (Words(n) .. " days") end
                local weeks = math.floor(n / 7 + 0.5)
                return weeks <= 1 and "a week" or (Words(weeks) .. " weeks")
            end
            -- A chapter a week or more after the last recorded one opens as a game master
            -- opens a new night at the table (W.absence, 2026-11-06): the gap in words, the
            -- place now against the place then, the hour, and on the long gaps one sentence
            -- of what the book recorded last. Elapsed time only, never what happened between.
            local absence
            if gap and gap >= 7 and W.absence and history.lastDay then
                local longest = gap >= 21 and gap >= maxGap and not history.longestSaid
                local bucket = (gap >= 166 or longest) and "longest" or (gap >= 21 and "long") or "short"
                if longest then history.longestSaid = true end
                history.absenceN = (history.absenceN or 0) + 1
                absence = {bucket = bucket, n = history.absenceN}
                tokens.since = SinceWords(gap, absence.n)
                tokens.weekday = weekday
                tokens.lastZone = history.lastZone and history.lastZone ~= first.zone and Place(history.lastZone) or nil
            end
            -- (the second sentence: what the last chapter recorded, on the long gaps, every other
            -- time under three weeks; Highlights leave it out)
            local function AbsenceRecap(namesToday)
                if not absence or gap < 11 or not W.absenceRecap then return end
                if gap < 21 and absence.n % 2 == 0 then return end
                local options = {}
                local lordName = history.lastLord and Place((L and L.Short and L.Short(history.lastLord)) or history.lastLord)
                if lordName and history.lastDungeon then options[#options + 1] = "lord"
                elseif history.lastDungeon then options[#options + 1] = "dungeon" end
                local others = {}
                for _, name in ipairs(history.lastWith or {}) do
                    if not (namesToday and namesToday:find(name, 1, true)) then others[#others + 1] = name end
                end
                if #others > 0 and tokens.lastZone then options[#options + 1] = "company" end
                local levelNow = first.level or person.startLevel
                -- (levels: a climb of three or more, and not after every gap; the thirty-journey study opened every
                -- monthly chapter with "I had been level 28 the last time, and was 31 now", 2026-11-06 review)
                if levelNow and history.lastLevel and levelNow - history.lastLevel >= 3 and (absence.n % 2 == 1 or absence.bucket == "longest") then options[#options + 1] = "levelUp" end
                -- (an unchanged level is said only when nothing else is there to say, after six weeks or more)
                if #options == 0 and levelNow and history.lastLevel and levelNow == history.lastLevel and gap >= 46 then options[1] = "levelSame" end
                if #options == 0 then return end
                local pick = options[(absence.n % #options) + 1]
                local rt = {lastZone = tokens.lastZone, lastLord = lordName, lastDungeon = history.lastDungeon and Place(history.lastDungeon),
                    names = List(others), level = tostring(levelNow), lastLevel = tostring(history.lastLevel)}
                Say(teller:Say("absenceRecap" .. pick, W.absenceRecap[pick], rt), false, "recap")
            end
            -- The opening line itself, by shape: same (the zone of the last chapter), else (another
            -- zone), new (a first visit), with (someone of your list from the start, {names}).
            -- (a country the book has described: one more thing about it, not said before, on a
            -- return after four weeks or more; Highlights leave it out)
            local function FreshZoneLine(zone)
                local zs = L and L.ZoneStory and L.ZoneStory(zone)
                if not zs then return nil end
                history.zoneLinesSaid = history.zoneLinesSaid or {}
                local said = table.concat(out, " ")
                local pool = {}
                for _, list in ipairs({zs.sight or {}, zs.stakes or {}}) do
                    for _, line in ipairs(list) do
                        if not history.zoneLinesSaid[line] and not said:find(line, 1, true) and not NamesFoeTown(line, faction) then pool[#pool + 1] = line end
                    end
                end
                if #pool == 0 then return nil end
                local line = PickLore(pool)
                if line then history.zoneLinesSaid[line] = true end
                return line
            end
            local function AbsenceOpen(shape, names)
                if not absence then return false end
                local list = W.absence[absence.bucket] and W.absence[absence.bucket][shape]
                if not list then return false end
                if not tokens.lastZone then
                    local kept = {}
                    for _, line in ipairs(list) do if not line:find("{lastZone}", 1, true) then kept[#kept + 1] = line end end
                    list = kept
                end
                if #list == 0 then return false end
                tokens.names = names
                Say(teller:Say("absence" .. absence.bucket .. shape, list, tokens), true, "open")
                absence.said = true
                AbsenceRecap(names)
                if gap >= 28 and shape ~= "new" and history.describedZones[first.zone or "?"] then
                    local line = FreshZoneLine(first.zone)
                    if line then Say(line, false, "lore") end
                end
                return true
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
            for _, e in ipairs(first.events) do if (e.k == "bg" or (e.k == "first" and e.d == "battleground")) and (e.d == first.zone or e.z == first.zone) then bgOpen = true end end
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
                history.originSaid = true
                history.companions[beganWith.w.name] = true
                history.introduced = history.introduced or {}
                history.introduced[N(beganWith.w.name)] = index
                history.originTown = W.originTowns and W.originTowns[race]
                Title(64, teller:Pick("tOrigin", (W.titles.originRace and W.titles.originRace[race]) or W.titles.origin))
            elseif origin then
                Say(teller:Say("origin", origin, tokens), true, "origin")
                history.originSaid = true
                history.originTown = W.originTowns and W.originTowns[race]
                Title(64, teller:Pick("tOrigin", (W.titles.originRace and W.titles.originRace[race]) or W.titles.origin))
            elseif reunion and When and W.reunion and (not absence or dungeonOpen) then
                tokens.names, tokens.ago = N(reunion.name), Ago(dayNumber - history.companionLast[reunion.name])
                tokens.When = "On " .. weekday
                local info = Companion(reunion.key)
                local bondWord = info and info.bond and BOND_WORDS[info.bond] and BOND_WORDS[info.bond][info.pronouns or "they"]
                -- (a reunion that goes straight into a dungeon after a week or more: the time in front,
                -- "Three months later, Mira, my wife, went into Blackwing Lair with me.")
                local function Timed(line)
                    if not absence or not line then return line end
                    absence.said = true
                    if not line:match("^I ") and not line:match("^{") then line = line:gsub("^%u", string.lower) end
                    return Cap(tokens.since) .. " later, " .. line
                end
                if bondWord and W.reunionBond then
                    tokens.bond = bondWord
                    local key = dungeonOpen and W.reunionDungeonBond and "reunionDungeonBond" or "reunionBond"
                    Say(Timed(teller:Say(key, W[key], tokens)), true)
                else
                    local key = dungeonOpen and W.reunionDungeon and "reunionDungeon" or "reunion"
                    Say(Timed(teller:Say(key, W[key], tokens)), true)
                end
                if absence then AbsenceRecap(tokens.names) end
                Title(64, (teller:Pick("tReunion", W.titles.reunion) or ""):gsub("{names}", (Clean(reunion.name):gsub("%-.*$", ""))))
                reunion.told = true
                history.reunionChapter = index
                -- This opener already places the company inside this dungeon.
                if dungeonOpen then dungeonOpen.introduced = true end
            elseif bossOpen and not crossing then
                prefix = When .. ", in " .. Place(first.zone)
            elseif dungeonOpen and not crossing and raidOpen then
                -- (the first raid's own line opens the day)
                prefix = not plainOpen and When or nil
            elseif dungeonOpen and not crossing and W.openDungeon then
                tokens.dungeonD = Place(first.zone)
                local inWith = {}
                for _, w in ipairs(first.with) do if history.companions[w.name] and w.seconds >= (first.e - first.t) * 0.5 then inWith[#inWith + 1] = N(w.name) end end
                if When and #inWith > 0 and W.openDungeonWith then
                    -- ("The next day, Kesh, Ula and I went back into the Scarlet Monastery.")
                    tokens.names = table.concat(inWith, ", ") -- ("Kesh, Ula and I")
                    local again = history.dungeonVisits[first.zone] and W.openDungeonWithAgain
                    local line = teller:Say(again and "openDungeonWithAgain" or "openDungeonWith", again or W.openDungeonWith, tokens)
                    -- (a plain opening: the same line without its day)
                    if plainOpen and line and When then line = Cap((line:gsub("^" .. When:gsub("%p", "%%%0") .. ", ", ""))) end
                    Say(line, true)
                    history.introduced = history.introduced or {}
                    for _, name in ipairs(inWith) do history.introduced[name] = index end
                else
                    local key, pool = "openDungeon", W.openDungeon
                    if not When then key, pool = "openDungeonFirst", W.openDungeonFirst else key, pool = OpenPool(key, pool) end
                    Say(teller:Say(key, pool, tokens), true)
                end
                dungeonOpen.introduced = true
            elseif (townOpen or bgOpen) and not crossing and (When or (person.startLevel or 1) < 10) then
                -- (the town's line, told in the first stretch, takes the "when"; a first chapter starts with it)
                prefix = not plainOpen and When or nil
            elseif crossing and When and not absence then
                tokens.to = crossing.to and Place(crossing.to) or "the other shore"
                Say(teller:Say("voyageOpen" .. crossing.d, W.voyageOpen[crossing.d], tokens), true)
                crossing.told = true
                if crossing.d == "zeppelin" or crossing.d == "boat" then Title(58, teller:Pick("tVoyage", W.titles.voyage)) end
            elseif not When and townOpen and not crossing and (person.startLevel or 1) < 10 then
                -- (a first chapter that begins in a town: the town's own line opens it)
                prefix = nil
            elseif not When and not bgOpen then
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
                    -- (by what the record holds: who was there from the start, a city, the top of the climb)
                    local key, pool = "openFirstLate", (atHome and W.openFirstLate.home) or W.openFirstLate[race] or W.openFirstLate.other
                    local bondInfo = bondAllDay and Companion(bondAllDay.key)
                    if bondInfo and W.openFirstLateBond then
                        tokens.names = N(bondAllDay.name)
                        tokens.bond = BOND_WORDS[bondInfo.bond] and BOND_WORDS[bondInfo.bond][bondInfo.pronouns or "they"] or "my friend"
                        key, pool = "openFirstLateBond", W.openFirstLateBond
                        history.companions[bondAllDay.name] = true
                        history.introduced = history.introduced or {}
                        history.introduced[N(bondAllDay.name)] = index
                    elseif #startWith > 0 and W.openFirstLateWith then
                        tokens.names = List(startWith)
                        key, pool = "openFirstLateWith", W.openFirstLateWith
                    elseif (first.level or person.startLevel or 0) >= 60 and W.openFirstLateSixty then
                        key, pool = "openFirstLateSixty", W.openFirstLateSixty
                    elseif CITY_ZONE[first.zone] and not atHome and W.openFirstLateCity then
                        key, pool = "openFirstLateCity", W.openFirstLateCity
                    elseif not atHome and W.openFirstLateBand and Hash(person.charKey or person.name or "") % 2 == 0 then
                        -- (one book in two opens on where the character stood on the climb, 2026-11-07)
                        local band = A.QuestDeeds and A.QuestDeeds.Band(first.level or person.startLevel)
                        if band and W.openFirstLateBand[band] then key, pool = "openFirstLateBand", W.openFirstLateBand[band] end
                    end
                    Say(teller:Say(key, pool, tokens), true, "open")
                else
                    Say(teller:Say("openFirst", firstLines, tokens), true, "open")
                end
                -- (described here: the stretch below must not describe it a second time)
                if firstVisit and not Lane.Bare(first) then DescribeZone(Say, first.zone, firstTowns, f.dungeons > 0) end
            elseif absence and #startWith > 0 and AbsenceOpen("with", (function()
                -- (one of your list back with you after three weeks or more: who they are to you)
                local names = {}
                for _, name in ipairs(startWith) do
                    local who = name
                    if gap >= 21 and #startWith == 1 then
                        for _, w in ipairs(first.with) do
                            local info = N(w.name) == name and Companion(w.key)
                            local bondWord = info and info.bond and BOND_WORDS[info.bond] and BOND_WORDS[info.bond][info.pronouns or "they"]
                            if bondWord then who = name .. ", " .. bondWord .. "," end
                        end
                    end
                    names[#names + 1] = who
                end
                local joined = List(names)
                return (joined:gsub(",, ", ", "):gsub(",,", ","))
            end)()) then
                -- (said: the names of the opening are introduced)
                history.introduced = history.introduced or {}
                for _, name in ipairs(startWith) do history.introduced[name] = index end
                for _, w in ipairs(first.with) do if not history.companions[w.name] and Companion(w.key) then companionsReopen[N(w.name)] = true end end
                if reunion then reunion.told = true; history.reunionChapter = index end
            elseif absence and first.zone == history.lastZone and not firstVisit and AbsenceOpen("same") then
                -- (the same ground, a week or more on)
            elseif absence and firstVisit and AbsenceOpen("new") then
                local crossed = crossing ~= nil
                for _, e in ipairs(first.events) do if e.k == "voyage" and e.d ~= "hearth" and e.d ~= "portal" then crossed = true end end
                LeftHome(first.zone, crossed)
                if not Lane.Bare(first) then DescribeZone(Say, first.zone, firstTowns, f.dungeons > 0); Title(35, Clean(first.zone)) end
            elseif absence and #startWith == 0 and AbsenceOpen("else") then
                -- (another place the book knows, or one it has not named)
            elseif bondAllDay and #startWith > 0 and W.openWith and teller.rng() < 0.75 then
                tokens.names = List(startWith)
                Say(SayOpen("openWith", W.openWith), false, "open")
            elseif first.zone == history.lastZone then
                -- (still there: a gap of three days or less; with work to do, the work)
                if gap and gap > 3 and W.openSame then Say(SayOpen("openSame", W.openSame), false, "open")
                elseif first.questCount > 0 and f.quests >= 2 and W.openStillWork and teller.rng() < 0.5 then Say(SayOpen("openStillWork", W.openStillWork), false, "open")
                else
                    local key, pool = OpenPool("openStill", W.openStill)
                    Say(teller:Say(key, key == "openStill" and Bare(pool) or pool, tokens), false, "open")
                end
            elseif firstVisit then
                local names = (#startWith > 0 and List(startWith)) or openNew or nil
                local shape = FirstVisitShape(first, names, nil)
                if shape == "with" and W.openNewWith then
                    -- ("Brannoc, a dwarf warrior, and I": an introduction closes its comma before "and")
                    tokens.names = names:find(", ", 1, true) and (names .. ",") or names
                    local line = SayOpen("openNewWith", W.openNewWith)
                    if line then line = line:gsub(",,", ","):gsub(",%.", ".") end
                    Say(line, true, "open")
                    if names == openNew then openNewSaid = true end
                elseif (shape == "young" and W.openNewYoung) or (shape == "late" and W.openNewLate) then
                    tokens.level = tostring(first.level or person.startLevel or "")
                    if shape == "young" then history.perils[first.zone] = true end
                    Say(SayOpen(shape == "young" and "openNewYoung" or "openNewLate", shape == "young" and W.openNewYoung or W.openNewLate), true, "open")
                else
                    Say(SayOpen("openNew", W.openNew), true, "open")
                end
                local crossed = crossing ~= nil
                for _, e in ipairs(first.events) do if e.k == "voyage" and e.d ~= "hearth" and e.d ~= "portal" then crossed = true end end
                LeftHome(first.zone, crossed)
                if not Lane.Bare(first) then DescribeZone(Say, first.zone, firstTowns, f.dungeons > 0); Title(35, Clean(first.zone)) end
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
                    Say(SayOpen("openBack", W.openBack), true, "open")
                end
            elseif #startWith == 0 and openNew and W.openWithNew then
                tokens.names = openNew
                Say(teller:Say("openWithNew", W.openWithNew, tokens), true, "open")
                openNewSaid = true
            elseif #startWith > 0 then
                tokens.names = List(startWith)
                Say(SayOpen("openWith", W.openWith), false, "open")
                -- (someone new among them is introduced in the stretch, below)
                for _, w in ipairs(first.with) do if not history.companions[w.name] and Companion(w.key) then companionsReopen[N(w.name)] = true end end
            else
                local range = L and L.ZoneLevels and L.ZoneLevels(first.zone)
                local danger = Danger(first.level, range and range[1], range and range[2])
                if (danger == "daring" or danger == "reckless") and not history.perils[first.zone] and teller.rng() < 0.7 then
                    history.perils[first.zone] = true
                    Say(SayOpen("openPeril", W.openPeril), false, "open")
                else
                    local key, pool = OpenPool("open", W.open)
                    Say(teller:Say(key, key == "open" and Bare(pool) or pool, tokens), false, "open")
                end
            end
            if absence and not absence.said and gap >= 21 then AbsenceRecap(List(startWith)) end
            if originGap then
                -- A chosen origin is backstory, not evidence of the missing
                -- journey. Establish where the captured adventure picks up.
                sceneAt = 1
                Say(teller:Say("originBridge", W.originBridge, {zoneD = Place(first.zone), We = together0 and "We" or "I", we = together0 and "we" or "I", were = together0 and "were" or "was"}), true, "open")
            end
            -- A character who plays mostly with one companion (ST.Profile, emphasis only): a day on
            -- their own right after days together is news, now and then.
            if profile.paired and W.aloneDay and (index - (history.aloneSaid or -99)) >= 8 and history.companionLast[profile.paired]
                and dayNumber - history.companionLast[profile.paired] <= 3 and (first.e - first.t) >= 3600 then
                local anyWith = false
                for _, s2 in ipairs(stretches) do if #s2.with > 0 then anyWith = true end end
                if not anyWith then
                    history.aloneSaid = index
                    tokens.names = N(profile.paired)
                    Say(teller:Say("aloneDay", W.aloneDay, tokens), false, "open")
                end
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
            -- (a day with a level, a first of any kind but the sunset, a near thing, a rare met or a
            -- heavy bag of ore is not "an otherwise quiet day": the line fired on most single-quest
            -- days, 2026-11-06 review; and the one-errand line rests four chapters between uses)
            if quiet then
                if #f.levels > 0 then quiet = false end
                local LOUD = {mount = true, epicmount = true, epic = true, legendary = true, famous = true, raid = true, pvp = true,
                    continent = true, worldboss = true, setfull = true, tier = true, class = true, battleground = true}
                for _, s in ipairs(stretches) do
                    for _, e in ipairs(s.events) do
                        if (e.k == "first" and LOUD[e.d or ""]) or e.k == "close" or e.k == "rarekill" or e.k == "rank"
                            or e.k == "duel" or e.k == "bg" then quiet = false end
                    end
                end
                if quiet and f.quests == 1 and history.quietOneAt and index - history.quietOneAt < 5 then quiet = false end
            end
            -- (a day with no fight in it ends on its sunset, quiet or not: the hand-ins and the ore go before)
            local sunsetEnds = quiet or (f.dungeons == 0 and deathsToday == 0 and fights == 0)
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
            -- (the mood line one chapter in three at most: "honest work" headed three chapters of seven, 2026-11-06)
            if honest and index - (history.honestSaidAt or -9) >= 3 then
                Say(teller:Say("honestDay", W.honestDay, tokens), true, "mood"); Title(50, teller:Pick("tHonest", W.titles.honest))
                history.honestSaidAt = index
            end
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
                if f.quests == 1 then history.quietOneAt = index end
                Title(52, teller:Pick("tQuiet", W.titles.quiet))
            end
            local sunsetLater, wandered
            local currentStretch -- {zone, st}: for the milestones told from outside the loop
            local flewTo -- a flight told with where it went
            local Milestone, FirstDeath, GatherLine
            -- (a mount bought with the level the day brought: told after that level)
            local afterLevel, levelsSaid, talentToday = {}, false, false
            local consequenceAt -- (the line of what a lord's fall meant: the day's level goes before it)
            local companionsSaid = {}
            -- (named by the book's opening; or a wife, a friend there every day, said at most one chapter in four)
            for name, at in pairs(history.introduced or {}) do if at == index then companionsSaid[name] = true end end
            -- A battleground day: one passage per battleground, its matches in time order.
            -- The results as runs ("The Alliance took the first and second, and the third we
            -- won"), the first win ever, a win after defeats, streaks across days, one length,
            -- one personal mark (flags, the most killing blows, bases), the company; a match
            -- without a recorded result keeps the plain count. `opened` means the first-time
            -- line (W.battleground) was just said. Counters only; no new draws.
            local function BattlegroundPassage(e, s, opened)
                local name = e.d or e.z
                if not name then return end
                if history.bgDay ~= index then history.bgDay, history.bgToday = index, {} end
                if history.bgToday[name] then return end
                history.bgToday[name] = true
                history.bg = history.bg or {seen = {}, placeSaid = {}, matches = 0, wins = 0, losses = 0, streakN = 0, longest = 0, streakSaid = {}}
                local hb = history.bg
                local matches = {}
                for _, s2 in ipairs(stretches) do
                    for _, x in ipairs(s2.events) do if x.k == "bg" and x.d == name then matches[#matches + 1] = {e = x, s = s2} end end
                end
                table.sort(matches, function(a, b) return (a.e.t or 0) < (b.e.t or 0) end)
                local n = #matches
                if n == 0 then return end
                local mySide = (faction == "Alliance" or faction == "Horde") and faction or nil
                local foeSide = mySide == "Alliance" and "Horde" or mySide == "Horde" and "Alliance" or nil
                local function Times(k) return k == 1 and "once" or k == 2 and "twice" or (Words(k) .. " times") end
                local bt = {what = Place(name), mySide = mySide or "my side", foeSide = foeSide or "the other side",
                    part = PartOfDay(matches[1].e.t or s.t), n = Words(n), times = Times(n)}
                local visits = hb.seen[name] or 0
                hb.seen[name] = visits + 1
                local function T(extra)
                    local tokens = {}
                    for k2, v in pairs(bt) do tokens[k2] = v end
                    for k2, v in pairs(extra or {}) do tokens[k2] = v end
                    return tokens
                end
                local function S(key, pool, extra, major, kind)
                    if type(pool) ~= "table" or #pool == 0 then return end
                    -- (the chapter's "when" opens this line: no "that evening" on top of it)
                    if prefix then
                        local kept = {}
                        for _, l in ipairs(pool) do if not l:find("{part}", 1, true) then kept[#kept + 1] = l end end
                        if #kept > 0 then pool = kept end
                    end
                    Say(teller:Say(key, pool, T(extra)), major, kind or "bg")
                end
                -- what the place is, the first visit to it (Everything only): right after the
                -- line that names it (W.battleground, or the opener below)
                local placePending = not brief and W.bgPlace and W.bgPlace[name] and not hb.placeSaid[name]
                local function PlaceLine()
                    if not placePending then return end
                    placePending, hb.placeSaid[name] = false, true
                    S("bgPlace" .. name, W.bgPlace[name], nil, false, "lore")
                end
                if opened then PlaceLine() end
                local results, known = {}, true
                for i, m in ipairs(matches) do results[i] = m.e.r; if not m.e.r then known = false end end
                if not known then
                    -- (no result recorded: the count, as before)
                    if opened then
                        if n >= 2 and W.bgSeriesFirst then S("bgSeriesFirst", W.bgSeriesFirst, {times = Times(n - 1)}, true) end
                    elseif n >= 2 then
                        S(visits > 0 and "bgTimesAgain" or "bgTimes", (visits > 0 and W.bgTimesAgain) or W.bgTimes, nil, true)
                    elseif visits == 0 then S("bgOnce", W.bgOnce or W.bgLeft, nil, true)
                    else S("bgLeft", W.bgLeft or W.bgAgain, nil, true) end
                    if not opened then Title(52, Clean(name)) end
                    hb.matches = hb.matches + n
                    return
                end
                -- the runs, the counts, the first win ever, a turn after defeats, the streak
                local runs, wins, losses = {}, 0, 0
                local firstWinAt, turnAt, turnLosses
                local streak, streakN = hb.streak, hb.streakN
                local reached = {}
                for i, r in ipairs(results) do
                    local last = runs[#runs]
                    if last and last.kind == r then last.to = i else runs[#runs + 1] = {kind = r, from = i, to = i} end
                    if r == "won" then
                        if hb.wins + wins == 0 then firstWinAt = i end
                        if streak == "lost" and streakN >= 2 and not turnAt then turnAt, turnLosses = i, streakN end
                        wins = wins + 1
                    elseif r == "lost" then losses = losses + 1 end
                    if r == "won" or r == "lost" then
                        if streak == r then streakN = streakN + 1 else streak, streakN = r, 1 end
                        if (streakN == 3 or streakN == 5) and not hb.streakSaid[r .. streakN] then reached[#reached + 1] = {kind = r, n = streakN} end
                    end
                end
                bt.wins, bt.losses = Words(wins), Words(losses)
                local function Ords(from, to)
                    local len = to - from + 1
                    if len == 1 then return Ordinal(from) end
                    if len == 2 then return Ordinal(from) .. " and " .. Ordinal(to) end
                    if to == n then return "last " .. Words(len) end
                    return "next " .. Words(len)
                end
                local firstWinSaid = false
                if n == 1 then
                    local r = results[1]
                    if opened then
                        local pool = (r == "won" and W.bgResultWon) or (r == "lost" and W.bgResultLost) or W.bgResultDraw
                        if r == "lost" and hb.matches == 0 and W.bgFirstLoss then pool = W.bgFirstLoss end
                        S("bgResult" .. r, pool, nil, true)
                    else
                        local again = visits == 1
                        local pool = (r == "won" and ((again and W.bgWonAgain) or W.bgWon)) or (r == "lost" and ((again and W.bgLostAgain) or W.bgLost)) or W.bgDraw
                        S("bg" .. r .. (again and "Again" or ""), pool, nil, true)
                        PlaceLine()
                    end
                    if firstWinAt and not opened and W.bgFirstWin then S("bgFirstWin", W.bgFirstWin, nil, true); firstWinSaid = true end
                elseif brief then
                    -- Highlights: the count and the result in one line
                    if opened then
                        S("bgSeriesFirst", W.bgSeriesFirst, {times = Times(n - 1)}, true)
                        S(wins == n and "bgAllWon" or losses == n and "bgAllLost" or "bgTally", (wins == n and W.bgAllWon) or (losses == n and W.bgAllLost) or W.bgTally, nil, true)
                    else
                        S(wins == n and "bgBriefAll" or losses == n and "bgBriefNone" or "bgBrief", (wins == n and W.bgBriefAll) or (losses == n and W.bgBriefNone) or W.bgBrief, nil, true)
                    end
                    if firstWinAt and W.bgFirstWinBrief and wins < n then S("bgFirstWinBrief", W.bgFirstWinBrief, {ordinal = Ordinal(firstWinAt)}, true); firstWinSaid = true end
                else
                    if opened then S("bgSeriesFirst", W.bgSeriesFirst, {times = Times(n - 1)}, true)
                    else S(visits > 0 and "bgSeriesBack" or "bgSeries", (visits > 0 and W.bgSeriesBack) or W.bgSeries, nil, true) end
                    PlaceLine()
                    if wins == n or losses == n then
                        local pool = wins == n and ((n == 2 and W.bgBothWon) or W.bgAllWon) or ((n == 2 and W.bgBothLost) or W.bgAllLost)
                        S(wins == n and "bgAllWon" or "bgAllLost", pool, nil, true)
                        if firstWinAt and W.bgFirstWinSweep then S("bgFirstWinSweep", W.bgFirstWinSweep, nil, true); firstWinSaid = true end
                    else
                        -- the runs, two or three to a sentence; five runs or more fall back to the tally
                        local told = runs
                        if #runs >= 5 then
                            S("bgTally", W.bgTally, nil, true)
                            told = {runs[1], runs[#runs]}
                        end
                        local pending, pendingJoined = nil, false
                        local function Flush() if pending then Say(pending, true, "bg") end; pending, pendingJoined = nil, false end
                        local function Lower(text) if text:match("^I ") or text:match("^{") then return text end return (text:gsub("^%u", string.lower)) end
                        if n == 2 and (W.bgTwoWonLost or W.bgTwoLostWon) then
                            -- (two matches, one each way: one sentence)
                            local wonFirst = results[1] == "won"
                            pending = teller:Say(wonFirst and "bgTwoWonLost" or "bgTwoLostWon", wonFirst and W.bgTwoWonLost or W.bgTwoLostWon, T({}))
                            if firstWinAt and W.bgFirstWin then Flush(); pending = teller:Say("bgFirstWin", W.bgFirstWin, T({})); firstWinSaid = true end
                            told = {}
                        end
                        for ri, run in ipairs(told) do
                            local isFirst, isLast = run == runs[1], run == runs[#runs]
                            local len = run.to - run.from + 1
                            local extra = {ordinals = Ords(run.from, run.to), ordinal = Ordinal(run.from), were = len == 1 and "was" or "were"}
                            local sentence, clause, more
                            local rest = nil
                            if run.kind == "won" and firstWinAt and firstWinAt >= run.from and firstWinAt <= run.to and not firstWinSaid and W.bgRunFirstWin then
                                firstWinSaid = true
                                extra.ordinal = Ordinal(firstWinAt)
                                sentence = teller:Say("bgRunFirstWin", W.bgRunFirstWin, T(extra))
                                if run.to > firstWinAt then rest = {firstWinAt + 1, run.to} end
                            elseif run.kind == "won" and turnAt == run.from and W.bgTurn then
                                extra.losses = Words(turnLosses)
                                sentence = teller:Say("bgTurn", W.bgTurn, T(extra))
                                if run.to > run.from then rest = {run.from + 1, run.to} end
                            elseif isFirst then
                                sentence = teller:Say(run.kind == "won" and "bgRunOpenWon" or "bgRunOpenLost", run.kind == "won" and W.bgRunOpenWon or W.bgRunOpenLost, T(extra))
                            elseif isLast then
                                sentence = teller:Say(run.kind == "won" and "bgRunCloseWon" or "bgRunCloseLost", run.kind == "won" and W.bgRunCloseWon or W.bgRunCloseLost, T(extra))
                            else
                                clause = teller:Say(run.kind == "won" and "bgRunWon" or "bgRunLost", run.kind == "won" and W.bgRunWon or W.bgRunLost, T(extra))
                            end
                            -- (the wins after the first win, or after the turn: their own short sentence)
                            if sentence and rest and W.bgRunMore then
                                local restLen = rest[2] - rest[1] + 1
                                more = teller:Say("bgRunMore", W.bgRunMore, T({ordinals = Ords(rest[1], rest[2]), were = restLen == 1 and "was" or "were"}))
                            end
                            if clause and pending and not pendingJoined then
                                pending, pendingJoined = pending:gsub("%.$", "") .. ", and " .. Lower(clause) .. ".", true
                            elseif clause then
                                Flush()
                                pending = Cap(clause) .. "."
                            else
                                Flush()
                                pending = sentence
                                if more then Flush(); pending = more end
                            end
                        end
                        Flush()
                    end
                end
                do
                    -- the company: who of the list was in the matches, said once (Highlights keep it)
                    local company, order = {}, {}
                    for _, m in ipairs(matches) do
                        local seen = {}
                        for _, w in ipairs(m.s.with or {}) do
                            if w.seconds >= (m.s.e - m.s.t) * 0.5 and not seen[w.name] then
                                seen[w.name] = true
                                if not company[w.name] then company[w.name] = {k = 0, key = w.key}; order[#order + 1] = w.name end
                                company[w.name].k = company[w.name].k + 1
                            end
                        end
                        for _, who in ipairs(m.e.c or {}) do
                            if not seen[who] then
                                seen[who] = true
                                if not company[who] then company[who] = {k = 0}; order[#order + 1] = who end
                                company[who].k = company[who].k + 1
                            end
                        end
                    end
                    local said = 0
                    for _, who in ipairs(order) do
                        local marked = N(who)
                        if said < 2 and not companionsSaid[marked] then
                            companionsSaid[marked] = true
                            local entry = company[who]
                            local info = not history.companions[who] and entry.key and Companion(entry.key)
                            local bond = info and info.bond and BOND_WORDS[info.bond] and BOND_WORDS[info.bond][info.pronouns or "they"]
                            history.companions[who] = true
                            local k = entry.k >= n and "all" or Words(entry.k)
                            local series = n >= 2
                            local pool = (bond and ((series and W.bgWithBondSeries) or W.bgWithBond)) or ((series and W.bgWithSeries) or W.bgWith)
                            S(bond and "bgWithBond" or "bgWith", pool, {names = marked, k = k, bond = bond}, brief)
                            said = said + 1
                        end
                    end
                end
                if not brief then
                    -- a personal mark: one, or two on a long evening (four matches or more)
                    local marks = {fc = 0, fr = 0, ba = 0, ta = 0, ga = 0}
                    local top
                    for i, m in ipairs(matches) do
                        for key, v in pairs(m.e.m or {}) do if marks[key] then marks[key] = marks[key] + (tonumber(v) or 0) end end
                        if m.e.top and not top then top = i end
                    end
                    local lines = {}
                    if marks.fc > 0 then lines[#lines + 1] = {"bgFlags", marks.fc == 1 and W.bgFlag or W.bgFlags, {times = Times(marks.fc)}} end
                    if top then lines[#lines + 1] = {"bgTop", (n >= 2 and W.bgTop) or W.bgTopOne or W.bgTop, {ordinal = Ordinal(top)}} end
                    if marks.ba > 0 then lines[#lines + 1] = {"bgBases", marks.ba == 1 and W.bgBase or W.bgBases, {n = Words(marks.ba)}} end
                    if marks.ta > 0 then lines[#lines + 1] = {"bgTowers", marks.ta == 1 and W.bgTower or W.bgTowers, {n = Words(marks.ta)}} end
                    if marks.ga > 0 then lines[#lines + 1] = {"bgGraveyards", marks.ga == 1 and W.bgGraveyard or W.bgGraveyards, {n = Words(marks.ga)}} end
                    if marks.fr > 0 then lines[#lines + 1] = {"bgReturns", marks.fr == 1 and W.bgReturn or W.bgReturns, {times = Times(marks.fr)}} end
                    for i = 1, math.min(#lines, n >= 4 and 2 or 1) do S(lines[i][1], lines[i][2], lines[i][3]) end
                    -- one length: the longest, when it was long; else a quick one
                    local longI, longD, quickI, quickD
                    for i, m in ipairs(matches) do
                        local d = tonumber(m.e.dur)
                        if d and (not longD or d > longD) then longI, longD = i, d end
                        if d and (not quickD or d < quickD) then quickI, quickD = i, d end
                    end
                    local about = A.JournalAbout
                    if longD and longD >= 2100 and about then
                        S("bgLong", n >= 2 and W.bgLong or W.bgLongOne, {ordinal = Ordinal(longI), length = about(longD)})
                        if hb.longest > 0 and longD > hb.longest and W.bgLongest then S("bgLongest", W.bgLongest) end
                    elseif quickD and quickD <= 480 and about then
                        S("bgQuick", n >= 2 and W.bgQuick or W.bgQuickOne, {ordinal = Ordinal(quickI), length = about(quickD)})
                    end
                    for _, r in ipairs(reached) do
                        hb.streakSaid[r.kind .. r.n] = true
                        S("bgStreak" .. r.kind, r.kind == "won" and W.bgStreakWon or W.bgStreakLost, {n = Words(r.n)})
                    end
                    if longD then hb.longest = math.max(hb.longest, longD) end
                end
                -- titles
                if firstWinAt and W.titles.bgFirstWin then Title(66, teller:Pick("tBgFirstWin", W.titles.bgFirstWin))
                elseif wins == n and n >= 2 and W.titles.bgSwept then Title(60, teller:Pick("tBgSwept", W.titles.bgSwept))
                elseif n >= 3 and W.titles.bgSeries then
                    local t = teller:Pick("tBgSeries", W.titles.bgSeries)
                    if t then Title(58, (t:gsub("{what}", Clean(name)):gsub("{What}", Clean(name)):gsub("{Times}", Cap(Times(n))))) end
                elseif not opened then Title(52, Clean(name)) end
                hb.matches, hb.wins, hb.losses = hb.matches + n, hb.wins + wins, hb.losses + losses
                hb.streak, hb.streakN = streak, streakN
            end
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
                    plan.meta = {capital = e.d} -- (a note for the planned telling: a capital seen for the first time)
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
                -- (a place only crossed: its lines go with the next stop's paragraph)
                if si > 1 and si < #stretches and Lane.Bare(s) and not CITY_ZONE[s.zone or ""] and not DR.runs[si + 1] and not BattlegroundOf(s) then sceneAt = si + 1 end
                plan.stretch, plan.stretchT, plan.event = si, s.t, nil
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
                    -- (not a voyage carried in from a crossing folded into this stay: it left from here)
                    if e.k == "first" and e.d == "tram" and not e.carried then arrives = true end
                    if e.k == "voyage" and not e.carried then arrives = true end
                    if e.k == "town" and e.d == s.zone then arrives = true end
                    if e.k == "bg" then arrives = true end -- (a battleground is not a road stop: its own passage opens it)
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
                if si > 1 and DR.leftSaid then
                    -- (the way out of the run was said with the run)
                    st.zoneSaid, DR.leftSaid = true, nil
                elseif si > 1 and previous and s.zone ~= previous.zone and not isDungeon and not arrives and hearthed and W.hearthMove then
                    st.zoneSaid = true
                    history.hearthSaid = index
                    plan.meta = {hearth = hearthed}
                    Say(teller:Say("hearthMove", W.hearthMove, st))
                elseif si > 1 and previous and s.zone ~= previous.zone and L and L.Dungeon and L.Dungeon(previous.zone) and W.leaveDungeon and not isDungeon then
                    st.zoneSaid = true
                    -- (the way out names the zone the run opened on, even when that stay was only crossed and folded)
                    local outZone = DR.OutZone(previous)
                    local ot = outZone and {zoneD = Place(outZone), zoneE = ZoneE(outZone), We = st.We, we = st.we, us = st.us, our = st.our, were = st.were} or st
                    Say(teller:Say("leaveDungeon", W.leaveDungeon, ot), false, "move")
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
                    elseif visitFirst and Lane.Bare(s) and W.firstZoneGlimpse then
                        -- (new ground only crossed: named as new, not described)
                        Say(teller:Say("firstZoneGlimpse", W.firstZoneGlimpse, st), false, "move")
                    elseif visitFirst then
                        st.zoneLore = ZoneLore(s.zone)
                        -- (the company that came in with you, when the book knows them already)
                        local withNames, allKnown = {}, true
                        for _, w in ipairs(s.with) do
                            if w.seconds >= (s.e - s.t) * 0.5 then
                                if history.companions[w.name] then withNames[#withNames + 1] = N(w.name) else allKnown = false end
                            end
                        end
                        local names = (allKnown and #withNames > 0) and List(withNames) or nil
                        local shape = FirstVisitShape(s, names, previous and previous.zone ~= s.zone and previous.zone or nil)
                        if shape == "with" and W.firstZoneWith then
                            st.names, st.were = names, #withNames > 1 and "were" or "was"
                            Say(teller:Say("firstZoneWith", W.firstZoneWith, st), true, "first")
                            for _, n3 in ipairs(withNames) do companionsSaid[n3] = true end
                        elseif (shape == "young" and W.firstZoneYoung) or (shape == "late" and W.firstZoneLate) then
                            st.level = tostring(s.level or "")
                            if shape == "young" then history.perils[s.zone] = true end
                            -- (a level reached earlier this day is told where it came: the number is not said again)
                            local youngPool = W.firstZoneYoung
                            if shape == "young" and W.firstZoneYoungBare and f.levelT and f.levelT < (s.t or 0) then youngPool = W.firstZoneYoungBare end
                            Say(teller:Say(shape == "young" and "firstZoneYoung" or "firstZoneLate", shape == "young" and youngPool or W.firstZoneLate, st), true, "first")
                        elseif shape == "from" and W.firstZoneFrom then
                            st.from = Place(previous.zone)
                            Say(teller:Say("firstZoneFrom", W.firstZoneFrom, st), true, "first")
                        else
                            -- (the plain line: the zone's own words follow)
                            Say(teller:Say("firstZone", Fresh(W.firstZone), st), true, "first")
                        end
                        local crossed = false
                        for _, list in ipairs({s.events, previous and previous.events or {}}) do
                            for _, e in ipairs(list) do if e.k == "voyage" and e.d ~= "hearth" and e.d ~= "portal" then crossed = true end end
                        end
                        LeftHome(s.zone, crossed)
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
                if not isDungeon and not dungeonToday and history.quietDay ~= index and (zoneDanger == "daring" or zoneDanger == "reckless") and not history.perils[s.zone] and not Lane.Bare(s) then
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
                    -- (the life began with them: one sentence, "My second life began at Deathknell, with
                    -- Mira, my wife, at my side.", 2026-11-07; the lore clause of the origin gives way)
                    local head = kinds[#out] == "origin" and #out <= 2 and out[#out]:match("^(.-), ")
                    if head and not head:find(",", 1, true) then
                        out[#out] = head .. ", with " .. st.names .. ", " .. st.bond .. ", at my side."
                        -- (a note for the planned telling, which says "with my wife Mira beside me")
                        if plan.metas[#out] then plan.metas[#out].origin = {head = head, name = st.names, mate = st.bond, one = #bonded == 1} end
                    else
                        Say(teller:Say("joinedBond", W.joinedBond, st), true)
                    end
                    local rest = {}
                    for _, n3 in ipairs(joined) do if n3 ~= bonded[1].name then rest[#rest + 1] = n3 end end
                    joined = rest
                end
                -- someone met for the first time: who they are, in their own sentence
                if openNewSaid and si == 1 then newcomers = {}; joined = {} end
                if #newcomers > 0 and W.joinedNew and not isDungeon then
                    -- (pass 3: each "name, a race class," loses its closing comma inside a list: no ",,")
                    local bare = {}
                    for i2, nc in ipairs(newcomers) do bare[i2] = (nc:gsub(",$", "")) end
                    st.names = #newcomers == 1 and newcomers[1]:gsub(",$", "") or List(bare)
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
                        plan.meta = {joined = st.names}
                        Say(teller:Say("joinedThere", W.joinedThere, st), true)
                        if kinds[#out - 1] == "move" then majors[#out - 1] = true end
                    else plan.meta = {joined = st.names, zone = st.zoneD}; Say(teller:Say("joined", W.joined, st), true); st.zoneSaid = true end
                end
                function GatherLine()
                    if st.gatherDone then return end
                    st.gatherDone = true
                    local work = A.JournalGatherClauses and A.JournalGatherClauses(s.gather) or {}
                    if #work > 0 then
                        plan.meta = {gather = s.gather}
                        st.work = List(work)
                        local names = {}
                        local mostKind, most = nil, 0
                        for _, kind in ipairs({"herbs", "mining", "skinning"}) do
                            if (s.gather[kind] or 0) > most and (s.gatherNames or {})[kind] then mostKind, most = kind, s.gather[kind] end
                        end
                        for _, name in ipairs(mostKind and s.gatherNames[mostKind] or {}) do if #names < 2 then names[#names + 1] = Q(name) end end
                        -- (two herbs are not "Peacebloom for the most part": names from five on)
                        st.names = #names > 0 and most >= 5 and List(names) or nil
                        st.kindNoun = mostKind == "mining" and "veins" or mostKind == "skinning" and "hides" or "herbs"
                        local fishingOnly = s.gather.fishing and not s.gather.herbs and not s.gather.mining and not s.gather.skinning
                        local dock = s.gatherPlace.fishing
                        if dock and not (Town(dock) or dock:find("Harbor") or dock:find("Dock") or dock:find("Pier") or dock:find("Port") or dock:find("Bay")) then dock = nil end
                        -- What the short telling keeps of the day's gathering: a quiet or honest
                        -- day's, this character's kind of work (the picture: a gatherer's herbs
                        -- and ore, a fisher's catch), or a big haul. Everything keeps it all.
                        local haul = 0
                        for _, n in pairs(s.gather) do haul = haul + n end
                        local gatherMajor = honest or quiet or profile.gatherer or haul >= 20
                        local fishMajor = honest or quiet or profile.fisher or (s.gather.fishing or 0) >= 15
                        if fishingOnly and dock and W.fishAt and teller.rng() < 0.7 then
                            wandered = true
                            st.place = Place(dock)
                            -- (the dock named in the sentence before: "there")
                            local before = (out[#out] or ""):gsub("{%a:([^}]*)}", "%1")
                            if W.fishAtHere and before:find(Clean(dock), 1, true) then Say(teller:Say("fishAtHere", W.fishAtHere, st), fishMajor, "gather")
                            else Say(teller:Say("fishAt", W.fishAt, st), fishMajor, "gather") end
                        elseif quiet and not wandered and fishingOnly and W.quietFish then
                            wandered = true
                            Say(teller:Say("quietFish", W.quietFish, st), true, "gather")
                            -- the fish by name ("Raw Longjaw Mud Snapper": the fish, not the raw)
                            local fish = {}
                            for _, name in ipairs((s.gatherNames or {}).fishing or {}) do
                                if #fish < 2 then fish[#fish + 1] = Q((Clean(name):gsub("^Raw ", ""))) end
                            end
                            if #fish > 0 and W.fishNames and teller.rng() < 0.8 then Say(teller:Say("fishNames", W.fishNames, {names = List(fish)}), profile.fisher or false, "gather") end
                        elseif quiet and not wandered and W.quietWander then
                            wandered = true
                            Say(teller:Say("quietWander", W.quietWander, st), true, "gather")
                            -- (hides are what a skinner takes, not the beasts: "most of it Thick Leather")
                            local namesPool = (mostKind == "skinning" and W.gatherNamesHides) or W.gatherNames
                            if st.names and namesPool and teller.rng() < 0.8 then Say(teller:Say("gatherNames", namesPool, st), profile.gatherer or false, "lore") end
                        elseif st.names and W.gatherNamed and teller.rng() < (profile.gatherer and 0.85 or 0.6) then
                            -- (two kinds of work in the sentence: the names go with their kind, "the veins were mostly Copper Ore")
                            local pool = (#work > 1 and W.gatherNamedMixed) or (mostKind == "skinning" and W.gatherNamedHides) or W.gatherNamed
                            Say(teller:Say("gatherNamed", pool, st), gatherMajor, "gather")
                        else
                            -- ("There," only after the town or the zone was said)
                            local lead = W.gatherLead
                            local lastKind = kinds[#out] or ""
                            if lastKind ~= "town" and lastKind ~= "move" and lastKind ~= "open" then
                                lead = {}
                                for _, line in ipairs(W.gatherLead) do if not line:find("^There") then lead[#lead + 1] = line end end
                            end
                            Say(teller:Say("gather", lead, st), fishingOnly and fishMajor or gatherMajor, "gather")
                        end
                    end
                end
                local townFirst = false
                for _, e in ipairs(s.events) do if e.k == "town" then townFirst = true end end
                if quiet and not townFirst then GatherLine() end
                -- What happened, in order.
                local bosses, pendingKills = {}, {}
                DR.pendingRaw = {}
                -- Two bosses and more, told around the one that mattered (2026-11-11): the one a
                -- quest of the day is about, else the lord of the place. The ones killed on the way
                -- to it are "fought past", the ones after it come "after him"; never a roll call and
                -- a summary line. Its epithet on the first kill only. Once a run.
                function DR.ShapedKills()
                    if #DR.pendingRaw < 2 or #DR.pendingRaw ~= #pendingKills or st.killShaped or not W.bossGoal then return false end
                    local E = A.JournalEpisodes
                    if not (E and E.ShapeKills) then return false end
                    local shape = E.ShapeKills(DR.pendingRaw, DR.QuestNamesBoss, function(name)
                        local lore = L and L.Boss and L.Boss(name)
                        return lore and lore.last
                    end)
                    if not shape then return false end
                    local raw = shape.key
                    local lore = L and L.Boss and L.Boss(raw)
                    local _, object = E.BossPronoun(raw, lore)
                    local kt = {We = st.We, we = st.we, us = st.us, our = st.our, him = object}
                    kt.boss = Place(raw)
                    -- (who he is, at the climax: the epithet on the first kill, not when the line or two before
                    -- carried its noun, nor one that names the place the run just went into)
                    if lore and lore.e and not history.bosses[raw] and not kt.boss:find(",", 1, true) then
                        local recent = {}
                        for n = 1, #out do if scenes[n] == plan.stretch then recent[#recent + 1] = A.JournalPlain(out[n]) end end
                        recent = table.concat(recent, " "):lower()
                        local echo = false
                        for word in lore.e:lower():gmatch("%a%a%a%a%a+") do
                            if recent:find(word:gsub("s$", ""), 1, true) then echo = true end
                        end
                        if st.dungeonNow and lore.e:find(Clean(st.dungeonNow.name), 1, true) then echo = true end
                        if not echo then kt.boss = kt.boss .. ", " .. lore.e .. "," end
                    end
                    kt.Boss = kt.boss
                    local shown, after = {}, {}
                    for _, name in ipairs(shape.shown) do shown[#shown + 1] = Place(name) end
                    if shape.more > 0 then shown[#shown + 1] = Words(shape.more) .. " more" end
                    for _, name in ipairs(shape.after) do after[#after + 1] = Place(name) end
                    kt.before, kt.after = List(shown), List(after)
                    kt.Before, kt.After = kt.before, kt.after
                    local function Clean2(line) return line and (line:gsub(",,", ","):gsub(",%.", ".")) or nil end
                    -- (the beats: the ones before, the goal's arrival and the kill, the tail)
                    if #shape.before > 0 then
                        local one = #shape.before == 1
                        local key = (one and "bossLeadOne" or "bossLeadMany") .. (st.killSaid and "Next" or "")
                        Say(Clean2(teller:Say(key, W[key] or (one and W.bossLeadOne) or W.bossLeadMany, kt)), true, "kill")
                        if DR.gathered then DR.SayCostly(shape.before) end
                        -- (a level that came with one of them is told here, not after the goal)
                        DR.LevelAtKill(shape.before, s, st)
                        -- (the run's losses, between the ones before and the goal)
                        if DR.gathered then DR.SayLosses(s, st) end
                    end
                    -- ("came to X first" only when no kill of the run was told before it)
                    local key = (shape.goal and "bossGoal" or "bossLord") .. ((#shape.before == 0 and not st.killSaid) and "First" or "")
                    Say(Clean2(teller:Say(key, W[key] or W.bossLord, kt)), true, "kill")
                    if DR.gathered then DR.SayCostly({shape.key}) end
                    DR.LevelAtKill({shape.key}, s, st)
                    if #shape.after > 0 and W.bossTail then Say(Clean2(teller:Say("bossTail", W.bossTail, kt)), true, "kill") end
                    if DR.gathered then DR.SayCostly(shape.after) end
                    st.killShaped = true
                    return true
                end
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
                    elseif DR.ShapedKills() then
                        -- (said around the boss that mattered)
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
                    if DR.gathered then DR.SayCostly(DR.pendingRaw) end
                    DR.LevelAtKill(DR.pendingRaw, s, st)
                    pendingKills, DR.pendingRaw = {}, {}
                    -- (the run's losses after its last kill, when the beats did not place them)
                    if DR.gathered and not DR.MoreBosses(s) then DR.SayLosses(s, st) end
                    -- your part, with the fighting
                    local dn = st.dungeonNow
                    -- (a death still to come in the run: my part is said after the fights, not before the wipe)
                    local deathLater = false
                    for _, x in ipairs(s.events) do
                        if (x.k == "death" or x.k == "pdeath") and (x.t or 0) > ((plan.event and plan.event.t) or 0) then deathLater = true end
                    end
                    if dn and not dn.roleTold and not deathLater then
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
                DR.GatherLosses(s)
                local deathsHere = 0
                for _, e in ipairs(s.events) do if e.k == "death" then deathsHere = deathsHere + 1 end end
                -- (the ones a run of deaths does not tell: each on its own line up to two, else counted)
                local DP = {loose = 0}
                for _, e in ipairs(s.events) do if e.k == "death" and not e.told then DP.loose = DP.loose + 1 end end
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
                -- A run of deaths as one passage (ST.DeathRuns): a lost fight or a bad hour, in the
                -- order it happened. One sentence a fight, a raise or a rescue with the fight it ended,
                -- an opening line when more than one fight was lost or the first try at a dungeon was,
                -- a felt line at most once in the passage and never its last line.
                function DP.FoeText(e) return Lane.Foe(e) end
                function DP.RaiseLine(e)
                    local byClass = e.n and W.rezOtherBy and W.rezOtherBy[person.class or ""]
                    if person.class == "PRIEST" and not LIGHT_RACES[race] then byClass = e.n and W.rezOtherByRace and W.rezOtherByRace[race] end
                    local pool = byClass or (e.n and W.rezOther) or W.rezOtherPlain
                    if (person.startLevel or 1) >= 11 and e.n and W.rezOtherLate then pool = Lane.LateRaisePool() end
                    return teller:Say("rezOther", Fresh(pool), {who = e.n and N(e.n) or ""})
                end
                function DP.RezLine(e)
                    local known = Lane.Known(e.by)
                    local rt = {by = known and N((Clean(e.by):match("^[^%s%-]+") or e.by)) or N(e.by)}
                    local byClass = known and W.rezBy and W.rezBy[Lane.ClassOf(e.by) or ""]
                    if byClass and teller.rng() < 0.7 then return teller:Say("rezBy", byClass, rt) end
                    return teller:Say(known and "rez" or "rezStranger", (known or not W.rezStranger) and W.rez or W.rezStranger, rt)
                end
                function DP.DeathPassage(run)
                    -- One movement (reader D1, 2026-11-11): the signal once a chapter, the first fight
                    -- with its killer, the raises with who, the deaths nobody raised me from as a count,
                    -- the last fight, the count once at the end; no clock words, no judgment.
                    local DR = W.deathRun
                    local beats = run.beats
                    local company = together
                    for _, it in ipairs(run.items) do if it.k == "party" then company = true end end
                    local tokens = {us = company and "us" or "me", our = company and "our" or "my", we = company and "we" or "I",
                        We = company and "We" or "I", zoneD = st.zoneD}
                    -- (the passage is one unit with its own span, for the composer to place: every line of
                    -- it carries the run in its notes, t0 to t1)
                    local unit = {firstTry = run.firstTry or false, dungeon = run.dungeon, beats = #beats, wipe = run.wipe or false,
                        t0 = run.items[1].t, t1 = run.items[#run.items].t, zone = s.zone}
                    local function Mark() plan.meta = {deathRun = unit, t = unit.t0} end
                    Mark()
                    local kind, pendingTally = "death", nil
                    local function SayRun(line, major, lineKind)
                        if not line then return end
                        Mark()
                        Say(line, major, lineKind or kind)
                        kind = "deathRun"
                        if pendingTally then Mark(); Say(pendingTally, false, "deathRun"); pendingTally = nil end
                    end
                    -- (1) first and last are the day's: my deaths and each companion's, in the whole record
                    local dayMe, dayParty = {}, {}
                    for _, ds in ipairs(stretches) do
                        for _, x in ipairs(ds.events) do
                            if x.k == "death" then dayMe[#dayMe + 1] = x.t or 0
                            elseif x.k == "pdeath" and x.n then
                                local key = Lane.FirstName(x.n)
                                dayParty[key] = dayParty[key] or {}
                                table.insert(dayParty[key], x.t or 0)
                            end
                        end
                    end
                    table.sort(dayMe)
                    local function DayFirstMe(it) return it and dayMe[1] == it.t end
                    local function DayLastMe(it) return it and dayMe[#dayMe] == it.t end
                    local function PartyFirst(beat)
                        for _, it in ipairs(beat.party) do
                            local times = dayParty[Lane.FirstName(it.e.n)] or {}
                            for _, t in ipairs(times) do if t < it.t then return false end end
                        end
                        return #beat.party > 0
                    end
                    local function PartyLast(beat)
                        for _, it in ipairs(beat.party) do
                            local times = dayParty[Lane.FirstName(it.e.n)] or {}
                            for _, t in ipairs(times) do if t > it.t then return false end end
                        end
                        return #beat.party > 0
                    end
                    -- (my deaths counted as they are told; the tally at ten, twenty-five or fifty goes right after)
                    local function Count(it)
                        FirstDeath(st, it.e)
                        history.deathDay, history.deathCause = index, Clean(it.e.d or it.e.env or "?")
                        for mark, lines in pairs(W.deathTally or {}) do
                            if history.deaths == mark and not history.tallySaid["x" .. mark] then
                                history.tallySaid["x" .. mark] = true
                                pendingTally = teller:Say("deathTally", lines, st)
                            end
                        end
                    end
                    local function Times(n) return n == 1 and "once" or n == 2 and "twice" or (Words(n) .. " times") end
                    -- the party who fell among some items: each once, in order, with their counts
                    local function PartyCounts(items)
                        local counts, order, full = {}, {}, {}
                        for _, it in ipairs(items) do
                            if it.k == "party" then
                                local key = Lane.FirstName(it.e.n)
                                if not counts[key] then counts[key] = 0; order[#order + 1] = key; full[key] = it.e.n end
                                counts[key] = counts[key] + 1
                            end
                        end
                        return counts, order, full
                    end
                    -- (someone of no list is introduced the first time the book names them)
                    history.introduced = history.introduced or {}
                    local function NameList(order, full)
                        local list, newcomers = {}, {}
                        for _, key in ipairs(order) do
                            if not Lane.Known(full[key]) and not history.introduced[key] and DR.newcomer then
                                history.introduced[key] = true
                                newcomers[#newcomers + 1] = (teller:Pick("deathRunNewcomer", DR.newcomer):gsub("{name}", N(full[key])):gsub("{us}", tokens.us))
                            else list[#list + 1] = N(full[key]) end
                        end
                        for _, x in ipairs(newcomers) do list[#list + 1] = x end
                        return List(list)
                    end
                    local function CountText(counts, order)
                        local total, repeats = 0, false
                        for _, key in ipairs(order) do total = total + counts[key]; if counts[key] > 1 then repeats = true end end
                        if not repeats then return nil end
                        if #order == 1 then return Times(total) end
                        return Words(total) .. " times between them"
                    end
                    -- the party's losses alone: one sentence
                    if run.partyOnly then
                        local counts, order, full = PartyCounts(run.items)
                        local bt = {names = NameList(order, full), us = tokens.us, our = tokens.our, count = CountText(counts, order)}
                        SayRun(teller:Say("deathRunParty", bt.count and DR.partyCount or DR.party, bt), true)
                        history.deathRunDay = index
                        return
                    end
                    -- the signal, once a chapter ("no kinder" for a second stretch, nothing for a third)
                    local runsToday = history.deathRunDay == index and (history.deathRunCount or 0) or 0
                    history.deathRunDay, history.deathRunCount = index, runsToday + (run.firstTry and 0 or 1)
                    if run.firstTry and DR.firstTry then
                        SayRun(teller:Say("deathRunFirstTry", DR.firstTry, tokens), true)
                    elseif #beats >= 2 and runsToday == 1 and DR.openAgain then
                        local said = (table.concat(out, " ", math.max(1, #out - 2)):gsub("{%a:([^}]*)}", "%1"))
                        local zoneNamed = s.zone and said:find(Clean(s.zone), 1, true)
                        local pool = {}
                        for _, line in ipairs(DR.openAgain) do
                            if not ((line:find("{zoneD}", 1, true) or line:find("{ZoneD}", 1, true)) and zoneNamed) then pool[#pool + 1] = line end
                        end
                        SayRun(teller:Say("deathRunOpenAgain", pool, tokens), true)
                    elseif #beats >= 2 and runsToday == 0 then
                        local said = (table.concat(out, " ", math.max(1, #out - 2)):gsub("{%a:([^}]*)}", "%1"))
                        local zoneNamed = s.zone and said:find(Clean(s.zone), 1, true)
                        local lead = run.items[1]
                        local sub = lead.k == "me" and lead.e.sz and Clean(lead.e.sz) ~= Clean(s.zone or "") and Place(lead.e.sz) or nil
                        if sub and DR.openSub and teller.rng() < 0.6 then
                            tokens.sub = sub
                            SayRun(teller:Say("deathRunOpenSub", DR.openSub, tokens), true)
                        else
                            local pool = {}
                            for _, line in ipairs(DR.open or {}) do
                                if not ((line:find("{zoneD}", 1, true) or line:find("{ZoneD}", 1, true)) and zoneNamed) then pool[#pool + 1] = line end
                            end
                            if #pool > 0 then SayRun(teller:Say("deathRunOpen", pool, tokens), true) end
                        end
                    end
                    local myDeaths, rezzes, walked, fellBefore = 0, 0, 0, {}
                    for _, it in ipairs(run.items) do if it.k == "me" then myDeaths = myDeaths + 1 elseif it.k == "rez" then rezzes = rezzes + 1 end end
                    -- the tokens of one fight
                    local function Fight(beat)
                        local counts, order, full = PartyCounts(beat.items)
                        local bt = {us = tokens.us, our = tokens.our, we = tokens.we, We = tokens.We, names = NameList(order, full), count = CountText(counts, order)}
                        bt.party = #order
                        bt.again = #order > 0
                        for _, key in ipairs(order) do
                            local earlier = fellBefore[key]
                            for _, t in ipairs(dayParty[key] or {}) do if t < beat.t then earlier = true end end
                            if not earlier then bt.again = false end
                        end
                        for _, key in ipairs(order) do fellBefore[key] = true end
                        local me = beat.me
                        if me then
                            bt.foe = me.e.d and Lane.Foe(me.e) or nil
                            bt.Foe = bt.foe and Cap(bt.foe) or nil
                            bt.named = me.e.d and not OfAKind(me.e) or false
                            bt.meFirst = #order == 0 or me.t <= beat.party[1].t
                        end
                        if beat.rez then
                            local by = beat.rez.e.by
                            local known = Lane.Known(by)
                            bt.known = known
                            bt.byName = known and N((Clean(by):match("^[^%s%-]+") or by)) or N(by)
                            bt.by = known and bt.byName or (bt.byName .. ", a stranger,")
                            bt.By = bt.by
                        end
                        return bt
                    end
                    local function RezLines(beat, bt)
                        if beat.raise then
                            Mark()
                            Say(DP.RaiseLine(beat.raise.e), true, "first")
                            kind = "deathRun"
                            local rezTitles = W.titles.rezOther
                            if (person.startLevel or 1) >= 11 then
                                rezTitles = {}
                                for _, t in ipairs(W.titles.rezOther) do if not t:find("First", 1, true) then rezTitles[#rezTitles + 1] = t end end
                            end
                            Title(57, teller:Pick(#rezTitles < #W.titles.rezOther and "tRezOtherLate" or "tRezOther", rezTitles))
                        end
                        if beat.rez then
                            local rt = {by = bt.byName}
                            local byClass = bt.known and W.rezBy and W.rezBy[Lane.ClassOf(beat.rez.e.by) or ""]
                            local line
                            if not bt.known and DR.rezStranger then line = teller:Say("deathRunRezStranger", DR.rezStranger, rt)
                            elseif byClass and teller.rng() < 0.7 then line = teller:Say("rezBy", byClass, rt)
                            else line = teller:Say("rez", W.rez, rt) end
                            Mark()
                            Say(line, true, "rez")
                            kind = "deathRun"
                        end
                    end
                    -- the first fight
                    local first = beats[1]
                    local bt = Fight(first)
                    local pool
                    if #beats == 1 then
                        pool = (not bt.foe and DR.meAndPartyPlain) or (bt.count and (bt.meFirst and DR.meThenPartyCount or DR.partyCountThenMe))
                            or (bt.meFirst and DR.wipeMeFirst or DR.wipePartyFirst)
                    elseif first.me then
                        local dayFirst = DayFirstMe(first.me)
                        pool = (not bt.foe and (bt.party > 0 and DR.meAndPartyPlain or W.death.plain))
                            or (bt.count and (bt.meFirst and DR.meThenPartyCount or DR.partyCountThenMe))
                            or (bt.party == 0 and (dayFirst and DR.firstMe or DR.plainMe))
                            or (bt.meFirst and (dayFirst and DR.firstMeParty or DR.plainMeParty) or (dayFirst and DR.firstPartyMe or DR.plainPartyMe))
                    else
                        local early = (first.t - (s.t or first.t)) <= 300 and DR.partyEarly
                        pool = (bt.count and DR.partyCount) or early or (PartyFirst(first) and DR.firstParty or DR.party)
                    end
                    SayRun(teller:Say("deathRunFirst", pool, bt), true)
                    if first.me then Count(first.me) end
                    RezLines(first, bt)
                    -- (the first raise of my life points back to the one who taught it, when the book told that)
                    local felt = false
                    history.deathFeltAt = history.deathFeltAt or {}
                    local function Taught(beat)
                        if felt or not beat.raise or beat == beats[#beats] or history.deathFeltAt.taught or not DR.feltTaught then return end
                        local teacher = Lane.Teacher()
                        if not teacher then return end
                        felt, history.deathFeltAt.taught = true, true
                        SayRun(teller:Say("deathRunFeltTaught", DR.feltTaught, {teacher = "{n:" .. teacher .. "}"}), false)
                    end
                    Taught(first)
                    -- the fights between: a named killer told, the raises with who (one told, more folded
                    -- by who raised me), the rest a count
                    local folded = {}
                    for bi = 2, #beats - 1 do
                        local beat = beats[bi]
                        local ft = Fight(beat)
                        if beat.me and beat.rez and ft.foe and (ft.named or (not ft.known and ft.party > 0)) then
                            if not ft.known and ft.party > 0 and DR.midParty then
                                SayRun(teller:Say("deathRunMidParty", DR.midParty, ft), true)
                                RezLines(beat, ft)
                            else
                                SayRun(teller:Say("deathRunMid", ft.party > 0 and DR.midRezParty or DR.midRez, ft), true)
                            end
                            Count(beat.me)
                        elseif beat.me and beat.rez and ft.foe then
                            folded[#folded + 1] = ft
                            Count(beat.me)
                        elseif beat.raise then
                            if ft.party > 0 then SayRun(teller:Say("deathRunMidParty", ft.count and DR.partyCount or DR.party, ft), true) end
                            if beat.me then walked = walked + 1; Count(beat.me) end
                            RezLines(beat, ft)
                            Taught(beat)
                        elseif beat.me then
                            walked = walked + 1
                            Count(beat.me)
                            if beat.rez then RezLines(beat, ft) end
                        end
                    end
                    -- (each raise told while they are two by different hands; three or more, or the same
                    -- hand twice, fold into one sentence)
                    local raisers, seen = {}, {}
                    for _, ft in ipairs(folded) do
                        if not seen[ft.byName] then seen[ft.byName] = true; raisers[#raisers + 1] = ft.byName end
                    end
                    if #folded >= 3 or (#folded == 2 and #raisers == 1) then
                        SayRun(teller:Say("deathRunMidMany", #raisers == 1 and DR.midRezSame or DR.midRezMany, {raisers = List(raisers), count = Times(#folded)}), true)
                    else
                        for _, ft in ipairs(folded) do SayRun(teller:Say("deathRunMid", ft.party > 0 and DR.midRezParty or DR.midRez, ft), true) end
                    end
                    if walked > 0 and #beats > 2 then
                        local ghost = true
                        for bi = 2, #beats - 1 do
                            local b = beats[bi]
                            if b.me and not b.rez and not (b.me.e.walk and b.me.e.walk > 0) then ghost = false end
                        end
                        SayRun(teller:Say("deathRunWalked", (ghost and DR.walked) or DR.diedMore or DR.walked, {count = Times(walked)}), true)
                    end
                    -- the last fight
                    if #beats >= 2 then
                        local last = beats[#beats]
                        local lt = Fight(last)
                        local dayLast = DayLastMe(last.me)
                        if last.me and not dayLast then
                            if not lt.foe then pool = lt.party > 0 and DR.meAndPartyPlain or W.death.plain
                            elseif lt.party == 0 then pool = DR.plainMe
                            elseif lt.meFirst then pool = DR.plainMeParty
                            else pool = lt.again and DR.lastPartyAgainMe or DR.plainPartyMe end
                        elseif last.me then
                            if not lt.foe then pool = lt.party > 0 and DR.meAndPartyPlain or W.death.plain
                            elseif lt.party == 0 then pool = lt.named and DR.lastNamed or DR.lastMe
                            elseif lt.meFirst then pool = lt.named and DR.lastNamedParty or DR.lastMeParty
                            else pool = lt.again and DR.lastPartyAgainMe or DR.lastPartyMe end
                        else
                            pool = lt.count and DR.partyCount or (PartyLast(last) and DR.lastParty or DR.party)
                        end
                        SayRun(teller:Say("deathRunLast", pool, lt), true)
                        if last.me then Count(last.me) end
                        RezLines(last, lt)
                    end
                    -- the count, once, when three or more of my deaths include some told only as a count
                    local foldedAway = walked > 0 or #folded >= 3 or (#folded == 2 and #raisers == 1)
                    if myDeaths >= 3 and foldedAway then
                        local counts, order, full = PartyCounts(run.items)
                        local parts = {}
                        -- (a companion who fell more than once; one fall was told where it happened)
                        for _, key in ipairs(order) do if counts[key] >= 2 then parts[#parts + 1] = N(full[key]) .. " " .. Times(counts[key]) end end
                        local seconds = run.items[#run.items].t - run.items[1].t
                        local minutes = seconds / 60
                        local span = minutes < 8 and "a few minutes" or minutes < 20 and "a quarter of an hour" or minutes < 40 and "half an hour"
                            or minutes < 75 and "an hour" or Span(seconds)
                        local ct = {count = Words(myDeaths), span = span, tally = #parts > 0 and List(parts) or nil}
                        SayRun(teller:Say("deathRunCount", (#parts > 0 and DR.count) or DR.countAlone, ct), true)
                    end
                    if pendingTally then Say(pendingTally, false, "deathRun"); pendingTally = nil end
                    Title(45, teller:Pick("tDeath", W.titles.death))
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
                -- (milestones lane, 2026-11-06: a world boss's first fall replaces its kill line; the
                -- thousand gold and the swift mount of one day make one sentence; the first talent
                -- point rides in the level-ten line)
                for _, e in ipairs(s.events) do
                    if e.k == "first" and e.d == "worldboss" and e.z then
                        for _, x in ipairs(s.events) do if x.k == "boss" and x.d and Clean(x.d) == Clean(e.z) then x.skip = true end end
                    elseif e.k == "first" and e.d == "epicmount" and not e.u then
                        for _, x in ipairs(s.events) do
                            if x.k == "first" and x.d == "gold" and tonumber(x.c) == 1000 and not x.u and W.epicMountPrice then x.skip = true; e.price = true end
                        end
                    elseif e.k == "first" and e.d == "talent" and not e.u and W.milestoneTalent then
                        for _, level in ipairs(f.levels) do if level == 10 then e.skip = true; talentToday = true end end
                    end
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
                        plan.meta = {figure = e.n, e = e, t = e.t}
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
                    -- (milestones lane, 2026-11-06: the moment's own tokens, and the pool that fits what the record holds)
                    mt.zoneD = Place(s.zone or "")
                    if e.d == "epicmount" and e.price then pool = W.epicMountPrice; mt.kind = e.n or "mount" end
                    if e.d == "gold" and W.gold and W.gold[tonumber(e.c)] then pool = W.gold[tonumber(e.c)] end
                    if e.d == "worldboss" then
                        local lord = L and L.Boss and L.Boss(name)
                        mt.epithet = lord and lord.e or nil
                        mt.zoneD = Place(e.sz or s.zone or "")
                    elseif e.d == "raid" then
                        local dl = L and L.Dungeon and L.Dungeon(name)
                        mt.lore = dl and type(dl.lore) == "table" and dl.lore[1] or nil
                    elseif e.d == "tier" then
                        local TIER_HOME = {[1] = "Molten Core", [2] = "Blackwing Lair", [2.5] = "Temple of Ahn'Qiraj", [3] = "Naxxramas"}
                        local home = TIER_HOME[tonumber(e.c)]
                        if tonumber(e.c) == 0 and W.tierDungeon then pool = W.tierDungeon
                        elseif home and W.tierWhere then pool = W.tierWhere; mt.where = Place(home); mt.Where = Cap(mt.where) end
                        history.tierFirstDay, history.tierHome = history.tierFirstDay or {}, history.tierHome or {}
                        history.tierFirstDay[name], history.tierHome[name] = dayNumber, home
                    elseif e.d == "setfull" then
                        local firstDay = history.tierFirstDay and history.tierFirstDay[name]
                        local home = history.tierHome and history.tierHome[name]
                        local visits = home and tonumber(history.dungeonVisits[home])
                        if firstDay and dayNumber - firstDay >= 1 and visits and visits >= 2 and W.setfullSpan then
                            pool = W.setfullSpan
                            local span = dayNumber - firstDay
                            mt.span = span < 7 and (Words(span) .. " days") or Ago(span)
                            mt.visits = Words(visits) .. " visits to " .. Place(home)
                        end
                    elseif e.d == "craftepic" then
                        local trade = e.n and Clean(e.n) or nil
                        mt.trade = trade and trade:lower() or "trade"
                        mt.tool = trade and W.craftTools and W.craftTools[trade] or nil
                        if W.craftEpic then pool = W.craftEpic end
                        -- (the day's crafting line names it already: "It came off my own bench"; Highlights
                        -- drops the crafting line, so there the name stays)
                        if not brief then
                            for _, line in pairs(s.craft or {}) do
                                for _, m in ipairs(line.made or {}) do if Clean(m) == name and W.craftEpicIt then pool = W.craftEpicIt end end
                            end
                        end
                    end
                    -- (a line whose token the record cannot fill is left out)
                    do
                        local kept = {}
                        for _, line in ipairs(pool or {}) do
                            local ok = true
                            for tok in line:gmatch("{(%a+)}") do if tok ~= "what" and mt[tok] == nil then ok = false end end
                            if ok then kept[#kept + 1] = line end
                        end
                        if #kept > 0 then pool = kept end
                    end
                    pool = Fresh(pool)
                    if e.d == "pvp" and W.milestone2.pvpHere and currentStretch and currentStretch.zone == e.z and currentStretch.zoneSaid then pool = W.milestone2.pvpHere end
                    local loot = e.d == "epic" or e.d == "legendary" or e.d == "famous" or e.d == "tier" or e.d == "setfull" or e.d == "rare"
                    local mline = teller:Say("m:" .. e.d, pool, mt)
                    -- (loot from a dungeon's fights: after your part in them)
                    local itemLore = (e.d == "famous" or e.d == "legendary") and ITEM_LORE[name] and ITEM_LORE[name][teller.rng(#ITEM_LORE[name])]
                    if loot and st.dungeonNow then
                        st.lootAfter = st.lootAfter or {}
                        table.insert(st.lootAfter, mline)
                        -- (what the item is, right after the item, not before it)
                        if itemLore then table.insert(st.lootAfter, itemLore) end
                    elseif e.d == "craftepic" and next(s.craft or {}) then
                        -- (made at the bench: after the day's crafting line)
                        st.afterCraft = st.afterCraft or {}
                        table.insert(st.afterCraft, mline)
                    else
                        Say(mline, true, loot and "loot" or "first")
                        if itemLore then Say(itemLore, true, "lore") end
                    end
                    local rank = ({raid = 88, famous = 92, legendary = 92, worldboss = 86, setfull = 84, epicmount = 83, mount = 80,
                        tier = 78, epic = 76, landmark = 74, pvp = 72, sunset = quiet and 66 or 55, gold = e.c == 1000 and 70 or 50, craftepic = 72})[e.d] or 60
                    local titlePool = (e.d == "gold" and W.titlesGold and W.titlesGold[tonumber(e.c)]) or W.titles[e.d] or {"{what}"}
                    local t = teller:Pick("t:" .. e.d, titlePool)
                    Title(rank, t and (t:gsub("{what}", (name:gsub("%%", "")))))
                    -- (the other titles of the pool, a little lower: one an earlier chapter has not used)
                    for _, other in ipairs(W.titles[e.d] or {}) do Title(rank - 0.5, (other:gsub("{what}", (name:gsub("%%", ""))))) end
                end
                local questAnchors = {}
                for _, e in ipairs(s.events) do
                    if e.k ~= "boss" and not DR.Quiet(e) then FlushKills() end
                    plan.event = e
                    -- (a line carried in from a crossing folded into this stay, the zeppelin or the
                    -- hearthstone that took you on: said at the end of the stay, where it happened)
                    local Say = Say
                    if e.carried then
                        Say = function(text, major, kind)
                            if not text then return end
                            st.goAfter = st.goAfter or {}
                            st.goAfter[#st.goAfter + 1] = {text, major, kind, e = e, t = e.t}
                        end
                    end
                    local eventStart = #out
                    if e.skip then
                        e.skip = nil
                    elseif e.k == "first" and e.d == "sunset" and sunsetEnds and not sunsetLater then
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
                        BattlegroundPassage({d = e.z, t = e.t}, s, true)
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
                    elseif e.k == "first" and not e.u and e.d == "rezother" and W.rezOther and not e.told then
                        local byClass = e.n and W.rezOtherBy and W.rezOtherBy[person.class or ""]
                        -- (the Light is for the priests of humans, dwarves and gnomes; others by their race)
                        if person.class == "PRIEST" and not LIGHT_RACES[race] then byClass = e.n and W.rezOtherByRace and W.rezOtherByRace[race] end
                        local pool = byClass or (e.n and W.rezOther) or W.rezOtherPlain
                        -- (a book begun late cannot know it was the first)
                        if (person.startLevel or 1) >= 11 and e.n and W.rezOtherLate then pool = Lane.LateRaisePool() end
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
                            if OfTheWork(x.d) then
                                -- (a quest's own papers: the work tells them)
                            elseif history.read[x.d] then again[#again + 1] = x else fresh[#fresh + 1] = x end
                            history.read[x.d] = true
                        end
                        if #fresh == 1 then
                            Say(teller:Say("read", W.read, {what = Q(fresh[1].d)}), false, "read")
                            Title(38, Clean(fresh[1].d))
                        elseif #fresh > 1 then
                            local names = {}
                            for n2 = 1, math.min(3, #fresh) do names[n2] = Q(fresh[n2].d) end
                            Say(teller:Say("readMany", W.readMany, {whats = List(names)}), false, "read")
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
                        -- (no counter, 2026-11-07: up to three places the chapter and its work do not
                        -- name, never the zone itself or a town told by its own line; none at all on the
                        -- first day of a life, when every place is new)
                        local said = A.JournalPlain(table.concat(out, " "))
                        local picked = {}
                        for _, n2 in ipairs(names) do
                            if #picked < 3 and n2 ~= s.zone and not Town(n2) and not said:find(Clean(n2), 1, true) and not OfTheWork(n2) then picked[#picked + 1] = n2 end
                        end
                        if history.chapter == 0 and history.earlyCoverage then picked = {} end
                        local shown = {}
                        for n2 = 1, #picked do shown[n2] = Place(picked[n2]) end
                        local rest = 0
                        local et = {places = List(shown), rest = Words(rest)}
                        local pool = #shown == 1 and W.exploreOne or W.explore
                        if #shown == 0 then pool = nil end
                        local before = history.explored or 0
                        history.explored = before + #names
                        if pool then Say(teller:Say("explore", pool, et), (profile.explorer and #shown >= 2), "explore") end
                        if #names >= 2 then Title(32, teller:Pick("tExplore", W.titles.explore)) end
                        for mark, lines in pairs(W.exploreTally or {}) do
                            if before < mark and history.explored >= mark then
                                Say(teller:Say("exploreTally", lines, {origin = history.originPlace or Place(first.zone)}), true, "explore")
                            end
                        end
                    elseif e.k == "taxi" and e.d and W.taxi then
                        -- ("there" only when one of the last three sentences names the place; "in town" when the
                        -- chapter named it earlier than that; the name itself otherwise)
                        local recent = table.concat(out, " ", math.max(1, #out - 2)):gsub("{%a:([^}]*)}", "%1"):find(Clean(e.d), 1, true)
                        local earlier = not recent and table.concat(out, " "):gsub("{%a:([^}]*)}", "%1"):find(Clean(e.d), 1, true)
                        local pool = W.taxi
                        if recent then pool = W.taxiHere
                        elseif earlier and W.taxiHere then
                            local town = {}
                            for _, line in ipairs(W.taxiHere) do if line:find("in town", 1, true) then town[#town + 1] = line end end
                            if #town > 0 then pool = town end
                        end
                        Say(teller:Say("taxi", pool, {place = Place(e.d)}), false, "taxi")
                    elseif e.k == "learn" and (e.c or 0) > 0 and W.learn then
                        local names = {}
                        -- (a spell once, without its rank: "Devotion Aura (Rank 1)" and "Devotion Aura" are
                        -- one; no count of the rest, 2026-11-07)
                        local seenSpell = {}
                        for _, n2 in ipairs(e.m or {}) do
                            local bare = (Clean(n2):gsub("%s*%(Rank %d+%)$", ""))
                            if not seenSpell[bare] then seenSpell[bare] = true; names[#names + 1] = Q(bare) end
                        end
                        if #names > 0 then
                            Say(teller:Say("learn", W.learn, {names = List(names)}), false, "learn")
                        end
                    elseif e.k == "rep" and e.d and W.rep and A.JournalStandingWord and A.JournalStandingWord(e.s) and W.rep[A.JournalStandingWord(e.s)] then
                        local word = A.JournalStandingWord(e.s)
                        local ft = {faction = FactionName(e.d)}
                        ft.Faction = Cap(ft.faction)
                        -- (exalted with a faction that gives something for it: the thing, not the standing)
                        local repPool = (word == "exalted" and W.exaltedBy and W.exaltedBy[Clean(e.d)]) or W.rep[word]
                        Say(teller:Say("rep" .. word, repPool, ft), (tonumber(e.s) or 0) >= 6, "first")
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
                        if record.w + record.l >= 3 and W.duelRecord and (index - (history.duelRecordSaid or -99)) >= (profile.duelist and 3 or 5) then
                            history.duelRecordSaid = index
                            dt.wins, dt.losses = Words(record.w), Words(record.l)
                            Say(teller:Say("duelRecord", W.duelRecord, dt), false, "first")
                        end
                        Title(54, teller:Pick("tDuel", W.titles.duel))
                    elseif e.k == "skill" and e.d and e.c and W.skill and W.skill[e.c] then
                        local trade = Clean(e.d):lower()
                        local skillPool = W.skill[e.c]
                        if e.c == 300 then
                            -- (three hundred by the trade's own noun; the second main trade there says "both")
                            local MAIN = {Alchemy = true, Blacksmithing = true, Enchanting = true, Engineering = true, Herbalism = true,
                                Leatherworking = true, Mining = true, Skinning = true, Tailoring = true}
                            if MAIN[Clean(e.d)] then history.topTrades = (history.topTrades or 0) + 1 end
                            if MAIN[Clean(e.d)] and history.topTrades == 2 and W.skillTopBoth then skillPool = W.skillTopBoth
                            elseif W.skillTop and W.skillTop[Clean(e.d)] then skillPool = W.skillTop[Clean(e.d)] end
                        end
                        Say(teller:Say("skill" .. e.c, skillPool, {trade = trade}), e.c == 300, "first")
                        if e.c == 300 then Title(56, ((teller:Pick("tSkill", W.titles.skill) or ""):gsub("{Trade}", Clean(e.d)))) end
                    elseif e.k == "rank" and e.d and W.rank then
                        -- (a PvP rank: the title, and the kills behind it when the record has them)
                        local rt = {rank = Clean(e.d), mySide = faction or "my side", side = faction == "Horde" and "Alliance" or "Horde"}
                        local kills = tonumber(e.n)
                        if kills and kills >= 2 then rt.kills = Words(kills); rt.Kills = Cap(rt.kills) end
                        Say(teller:Say("rank", (rt.kills and W.rankKills) or W.rank, rt), true, "first")
                        Title(70, Clean(e.d))
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
                            if n >= 2 then st.hkLine = {teller:Say("hkAfterFirst", W.hkAfterFirst, ht), n >= 3 or profile.fighter or false} end
                        else
                            st.hkLine = {teller:Say(n == 1 and "hkOne" or "hk", n == 1 and W.hkOne or W.hk, ht), n >= 3 or (profile.fighter and n >= 2) or false}
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
                        -- (an inn with a name of its own, "the Gallows' End Tavern": never "the inn at" it)
                        local inn = InnName(e.d)
                        local pool = inn and ((named and W.homeNamedHere) or W.homeNamed) or (named and W.homeHere) or W.home
                        Say(teller:Say(inn and "homeNamed" or "home", pool, {place = inn or Place(e.d)}), true, "first")
                        Title(44, teller:Pick("tHome2", W.titles.newHome))
                    elseif e.k == "bg" and e.d and not (history.bgDay == index and history.bgToday[e.d]) then
                        BattlegroundPassage(e, s)
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
                        local inn = e.d and InnName(e.d)
                        if not restSaid[e.d or "?"] then
                            restSaid[e.d or "?"] = true
                            -- (pass 3: a corner of a city, "Sewers" or "Canals", is told as the city)
                            local where = e.d
                            if not inn and where and not Town(where) and s.zone and Town(s.zone) then where = s.zone end
                            st.place = inn or Place(where or s.zone or "the inn")
                            Say(teller:Say(inn and "innNamed" or "inn", inn and W.innNamed or W.inn, st), false, "rest")
                        end
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
                            if (x.k == "death" or (x.k == "close" and deathsToday == 0)) and x.sz == e.d and x.d and not x.told and not inCave then inCave = x end
                        end
                        if inCave then
                            st.foe = Lane.Foe(inCave)
                            st.Foe = Cap(st.foe)
                            local cavePool = inCave.k == "death" and ((together and W.caveDeathWe) or W.caveDeath) or W.caveClose
                            Say(teller:Say(inCave.k == "death" and "caveDeath" or "caveClose", cavePool, st), true)
                            inCave.told = true
                            inCave.counted = true
                            if inCave.k == "death" then Title(45, teller:Pick("tDeath", W.titles.death)); FirstDeath(st, inCave)
                            else closeToday = true; Title(40, teller:Pick("tClose", W.titles.close)) end
                        elseif not OfTheWork(e.d) then
                            -- ("spent a while in the dark" only when the stay around it was not short itself)
                            Say(teller:Say("cave", (teller.rng() < 0.3 and (s.e or s.t) - s.t >= 10 * 60) and W.caveDark or W.cave, st), true)
                            history.caves = (history.caves or 0) + 1
                            if W.caveTally and W.caveTally[history.caves] and profile.caver and not history.tallySaid["c" .. history.caves] then
                                history.tallySaid["c" .. history.caves] = true
                                Say(teller:Say("caveTally", W.caveTally[history.caves], st), false, "first")
                            end
                        end
                    elseif e.k == "dungeon" and e.d and e.retry then
                        -- (the run's second try, after a wipe: back down, and the run goes on; no new entry, no lore
                        -- again; a walk out and back with nobody dead says nothing)
                        FlushKills()
                        -- (two wipes told as one passage take one "back down", not two in a row)
                        if e.wipe ~= false and not (plan.metas[#out] and plan.metas[#out].retry)
                            and not (st.wipeToldAt and (e.t or 0) - st.wipeToldAt <= 900) then
                            plan.meta = {retry = true}
                            Say(teller:Say("dungeonBackDown", DR.BackDownPool(e, s, st, together), st), true)
                        end
                    elseif e.k == "dungeon" and e.d then
                        local info = L and L.Dungeon and L.Dungeon(e.d)
                        DR.runs[si] = DR.runs[si] or {name = e.d, s = s}
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
                        -- The run's place in this book's history of the place (2026-11-06): the lord of the
                        -- place (Lore's `last`; a wing's own lord where the bosses point to a wing), whether
                        -- this run reached it, the run before, a death here the last time.
                        local lordList = A.DungeonLast and A.DungeonLast(e.d) or nil
                        local lordSet = {}
                        for _, l in ipairs(lordList or {}) do lordSet[l] = true end
                        local lordHere = lordList and lordList[1]
                        do
                            local wing = L and L.DungeonSight and L.DungeonSight(e.d, s.bosses)
                            if wing and wing.bosses and lordSet[wing.bosses[#wing.bosses]] then lordHere = wing.bosses[#wing.bosses] end
                        end
                        local reached, lastKill = false, nil
                        for _, b in ipairs(s.bosses) do if b.where == e.d then lastKill = b.name; if lordSet[b.name] then reached = true; lordHere = b.name end end end
                        local left = false
                        for _, s2 in ipairs(stretches) do
                            for _, x in ipairs(s2.entries) do if (x.t or 0) > (e.t or 0) and x.z and x.z ~= e.d then left = true end end
                        end
                        local lordBeat
                        for _, x in ipairs(s.events) do
                            if (x.k == "wipe" and lordSet[x.d]) or (x.k == "death" and lordSet[x.boss or x.d]) then lordBeat = x.boss or x.d end
                        end
                        local unfinished = inside and lordHere and not reached and not fled or false
                        local unfinishedBefore = history.dungeonUnfinishedLast[e.d]
                        local lordDoneBefore = history.dungeonLordDone[e.d]
                        local diedLast = history.dungeonDiedLast[e.d]
                        st.lord = lordHere and Place((L.Short and L.Short(lordHere)) or lordHere) or nil
                        st.Lord = st.lord
                        st.short = st.lord
                        st.Short = st.lord
                        st.nth = Ordinal(visits + 1)
                        st.they = (lordHere and L.Boss and L.Boss(lordHere) and L.Boss(lordHere).she) and "she" or "he"
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
                            -- (roleTold from the start, round 4: the record has a role, never the act; boasts from the
                            -- fight's own numbers stay)
                            history.boastDay = index -- (round 5: no stat boast in a run, "Taragaman never got past me")
                            st.dungeonNow = {name = e.d, r = e.r, first = firstEver, story = story, visits = visits, roleTold = true,
                                unfinished = unfinished, reached = reached, lord = lordHere, lastKill = lastKill, lordBeat = lordBeat, left = left,
                                lordDoneBefore = lordDoneBefore, unfinishedBefore = unfinishedBefore}
                            -- (what it was like inside: said with the first fight; one line, the detail by preference)
                            st.dungeonNow.insideNext = visits == 0 and story and (story.inside or story.detail)
                        end
                        st.reason = DR.Reason(e, s, story, visits, inside, fled, st)
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
                            -- (a return is never told with the first-visit line: the second run says so, the
                            -- third and after count themselves or call the place familiar, by turns)
                            -- (the company named on the second run too; the third and after count themselves,
                            -- so a book of many runs with the same company never repeats an entry line)
                            if visits >= 1 and (st.joinedDungeon or (visits == 1 and s.run and s.run.party and #(s.run.party.names or {}) >= 1
                                and #s.run.party.names <= 3 and not DR.partySaid)) and W.dungeonWithAgain then
                                if not st.joinedDungeon then
                                    local names = {}
                                    for _, name in ipairs(s.run.party.names) do names[#names + 1] = N(name) end
                                    st.names = List(names)
                                    DR.partySaid = true
                                end
                                st.joinedDungeon = nil
                                Say(teller:Say("dungeonWithAgain", W.dungeonWithAgain, st), true)
                            elseif visits == 1 and W.dungeonAgain then
                                Say(teller:Say("dungeonAgain", W.dungeonAgain, st), true)
                            elseif visits >= 2 and W.dungeonRegular then
                                history.dungeonKnownN = (history.dungeonKnownN or 0) + 1
                                local known = W.dungeonKnown and history.dungeonKnownN % 2 == 0
                                Say(teller:Say(known and "dungeonKnown" or "dungeonRegular", known and W.dungeonKnown or W.dungeonRegular, st), true)
                            elseif st.joinedDungeon and W.dungeonWith and W.dungeonWith[danger] then
                                st.joinedDungeon = nil
                                Say(teller:Say("dungeonWith" .. danger, W.dungeonWith[danger], st), true)
                            else
                                if st.joinedDungeon then
                                    st.joinedDungeon = nil
                                    Say(teller:Say("joinedPlain", W.joinedPlain, st), true)
                                end
                                -- (who went, at the entry (round 2, 2026-11-11): the company named when the record
                                -- knows them and they are few, counted when more went; once a chapter)
                                if together and (danger == "fair" or danger == "revisit") then pool = DR.EntryPool(e, s, st, pool) end
                                Say(teller:Say("dungeon" .. danger, pool, st), true)
                                -- (the lore of the place, once, folded into the entry: "...into Ragefire Chasm, where the
                                -- Searing Blade hid beneath Orgrimmar." on a first visit, when the line ends on the place
                                -- and no epithet named it; the inside line then stays unsaid, the why line follows)
                                if inside and visits == 0 then DR.LoreClause(e, info, st) end
                                -- (the first dungeon of my life: its own sentence at the entry, round 2; without the
                                -- word when the chapter has said "first" twice already)
                                if firstEver and st.dungeonNow then DR.FirstDungeonLine(st, e); Title(78, teller:Pick("tFirstDungeon", W.titles.firstDungeon)) end
                            end
                        end
                        -- (the entry line is its own kind, round 4: the joiner never hangs a kill on it, "I made for
                        -- Shadowfang Keep, where Arugal held court, and killed Rethilgore")
                        if #out > 0 and kinds[#out] == nil and (out[#out] or ""):find(Clean(e.d), 1, true) then kinds[#out] = "enter" end
                        -- A return: what the last run left (the lord unbeaten, a death), and now and then
                        -- a line of what the place is like on a return (Lore's `again`, every other return).
                        if inside and not fled and visits >= 1 then
                            if unfinishedBefore and reached and W.dungeonReturnUnfinished then
                                Say(teller:Say("dungeonReturnUnfinished", W.dungeonReturnUnfinished, st), true)
                                st.dungeonNow.atLast = true
                            elseif diedLast and W.dungeonDiedBefore and not (function()
                                for _, b in ipairs(s.bosses) do if (history.killers[b.name] or 0) > 0 and not history.avenged[b.name] then return true end end
                            end)() then
                                Say(teller:Say("dungeonDiedBefore", W.dungeonDiedBefore, st), true)
                            end
                            if story and story.again then
                                history.againN = (history.againN or 0) + 1
                                if history.againN % 2 == 1 then
                                    local bossesHere = {}
                                    for _, b in ipairs(s.bosses) do bossesHere[#bossesHere + 1] = b.name end
                                    local lines = (L.WithoutBosses and L.WithoutBosses(story.again, bossesHere)) or story.again
                                    Say(PickLore(lines), false, "lore")
                                end
                            end
                        end
                        -- A first visit: why you went, right after going in.
                        local classWhy = story and story.whyClass and story.whyClass[person.class or ""]
                        if person.class == "PRIEST" and not LIGHT_RACES[race] then classWhy = nil end
                        local why = story and ((story.whyRace and story.whyRace[race]) or classWhy or story.why)
                        -- (round 5: what we went in for, when a quest about the run was done: its own setup line
                        -- is the reason; the dungeon's reason only when no quest sent us)
                        -- (the reason itself was chosen before the entry, DR.Reason, round 6)
                        if why and L.WithoutBosses and why == story.why then
                            local bossesHere = {}
                            for _, b in ipairs(s.bosses) do bossesHere[#bossesHere + 1] = b.name end
                            why = L.WithoutBosses(why, bossesHere) or why
                        end
                        if not fled and inside and why and visits == 0 then
                            -- (not a reason that repeats the entry's lore clause: "crawling with troggs" / "Troggs and cultists")
                            if st.loreClause then why = DR.WithoutClause(why, st.loreClause) end
                            Say(st.reason or PickLore(why), true, "lore")
                            -- (purpose before arrival, round 4: the reason joins the entry, "Thrall wanted to know ..., so
                            -- with Dahlia ... I went down into Ragefire Chasm", or comes first when the two run long)
                            DR.ReasonFirst()
                            -- (the odds, once, round 5: the quest's level against mine, when the entry line did not say
                            -- the place was beyond us or beneath us)
                            if st.sentQuest and st.sentQuest.level and s.run.playerLevel and W.runOdds and (danger == "fair" or danger == "revisit") then
                                local diff = st.sentQuest.level - s.run.playerLevel
                                if diff >= 3 then
                                    st.n = Words(diff)
                                    Say(teller:Say("runOddsAbove", W.runOdds.above, st), false, "lore")
                                elseif diff <= -5 and W.runOdds.below then
                                    Say(teller:Say("runOddsBelow", W.runOdds.below, st), false, "lore")
                                end
                            end
                            -- (one line of your own people a visit)
                            if story.whyRace and story.whyRace[race] and why == story.whyRace[race] then st.raceSaid = true end
                            -- (the opening is the entry's clause and the reason: the inside line is not a third)
                            if st.dungeonNow then st.dungeonNow.insideNext = nil end
                        end
                        -- (with no reason authored, what it is like inside opens the run instead, not the first fight)
                        if st.dungeonNow and st.dungeonNow.insideNext then DR.SayInside(st.dungeonNow, s, st) end
                        if st.firstDungeonPending then
                            st.firstDungeonPending = nil
                            Say(teller:Say("firstDungeonLine", W.firstDungeonLine, st), true, "first")
                        end

                    elseif e.k == "boss" and e.d then
                        local dn = st.dungeonNow
                        if dn and dn.insideNext then DR.SayInside(dn, s, st) end
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
                        elseif dead and not DR.gathered then
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
                        elseif (function()
                            -- (milestones lane, 2026-11-06: a raid's lord, the first time it falls in the book)
                            local RAIDS = {["Molten Core"] = true, ["Onyxia's Lair"] = true, ["Blackwing Lair"] = true, ["Zul'Gurub"] = true,
                                ["Ruins of Ahn'Qiraj"] = true, ["Temple of Ahn'Qiraj"] = true, ["Ahn'Qiraj Temple"] = true, ["Naxxramas"] = true,
                                ["Barrow Deeps"] = true, ["Hyjal Summit"] = true, ["The Hall of Thanes"] = true}
                            local lord = L and L.Boss and L.Boss(e.d)
                            history.lordFell = history.lordFell or {}
                            return lord and lord.last and lord.e and W.lordFell and RAIDS[Clean(e.z or s.zone or "")] and not history.lordFell[Clean(e.d)]
                        end)() then
                            FlushKills()
                            history.lordFell[Clean(e.d)] = true
                            history.lordFellDay = history.lordFellDay or {}
                            history.lordFellDay[Clean(e.d)] = index
                            local lord = L.Boss(e.d)
                            Say(teller:Say("lordFell", W.lordFell, {boss = Place((L.Short and L.Short(e.d)) or e.d), epithet = lord.e}), true, "kill")
                            Title(89, (L.Short and L.Short(e.d)) or Clean(e.d))
                        elseif st.avengedHere and st.avengedHere[e.d] then
                            st.avengedHere[e.d] = nil -- (told with the death it cost)
                        else
                            pendingKills[#pendingKills + 1] = Place(e.d)
                            DR.pendingRaw[#DR.pendingRaw + 1] = e.d
                            -- (in a gathered run, the one it killed is said with the run's losses)
                            if dead then DR.costly[#DR.costly + 1] = {boss = e.d, names = dead}; st.partyDead[e.d] = nil end
                        end
                        bosses[#bosses + 1] = e.d
                        DR.bosses[Clean(e.d)] = true
                        -- (a kill told on its own line, not in the roll: a level that came with it is told here)
                        if DR.pendingRaw[#DR.pendingRaw] ~= e.d then DR.LevelAtKill({e.d}, s, st) end
                    elseif e.k == "wipe" and e.d and W.wipeThenWin and (function()
                        local boss = L and L.Boss and L.Boss(e.d)
                        if boss and boss.victory then return false end
                        for _, x in ipairs(s.events) do if x.k == "boss" and x.d == e.d and (x.t or 0) > (e.t or 0) then return true end end
                    end)() then
                        -- (the same boss fell later: "beat us the first time, and fell the second"; the kill roll leaves it out)
                        FlushKills()
                        st.boss = Place(e.d)
                        Say(teller:Say("wipeThenWin", W.wipeThenWin, st), true)
                        st.killSaid = true -- (a kill of the run was told: the next lead says "next", not "first")
                        st.wipeToldAt = e.t or 0 -- (the retry line stays unsaid for it, round 5: one sentence for one wipe)
                        DR.LevelAtKill({e.d}, s, st)
                        st.wonAfterWipe = st.wonAfterWipe or {}
                        st.wonAfterWipe[e.d] = true
                    elseif e.k == "wipe" and e.d then
                        st.boss = Place(e.d)
                        Say(teller:Say("wipe", W.wipe, st), true)
                    elseif e.deathRun and W.deathRun then
                        -- a run of deaths, told as one passage
                        DP.DeathPassage(e.deathRun)
                    elseif e.k == "pdeath" and e.n and not e.boss and not e.told and Lane.StrayDeath(e, s) then
                        -- (a companion's death with nothing around it, or in a city: not told)
                        e.told = true
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
                        if not DR.gathered then FlushKills() end
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
                        -- (the first of the other side ever to kill me, in a book kept from the start)
                        local firstPvp = not again and (history.pvpDeaths or 0) == 0 and (person.startLevel or 99) <= 9 and W.deathPvpFirst or nil
                        history.pvpDeaths = (history.pvpDeaths or 0) + 1
                        local line = teller:Say((firstPvp and "deathPvpFirst") or (again and "deathPvpAgain") or "deathPvp", firstPvp or again or W.deathPvp, pt)
                        -- (a race only one side has needs no "of the Alliance")
                        if theirRace and not firstPvp then line = line:gsub(", one of the " .. side, ""):gsub(" of the " .. side, "") end
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
                    elseif e.k == "death" and DP.loose <= 2 and not e.told then
                        local foe = e.d and Lane.Foe(e)
                        st.foe, st.sub = foe, e.sz and Place(e.sz)
                        st.inSub = st.sub and ("in " .. st.sub) or nil
                        local pool = foe and W.death.foe or W.death[e.env or ""] or W.death.plain
                        if e.env == "FALLING" and history.swimDay == index and W.deathFallIrony and not history.fallIrony then
                            history.fallIrony = true
                            pool = W.deathFallIrony
                        end
                        if foe and e.sz and A.SelfUnderground and A.SelfUnderground(e.sz) then
                            pool = W.deathIn
                            -- (the place just told: "there", not "in the Deadmines" over again)
                            local saidText = table.concat(out, " "):gsub("{%a:([^}]*)}", "%1"):lower()
                            if saidText:find(Clean(e.sz):lower(), 1, true) then st.inSub = "there" end
                            -- (the killer fell later in the same run: said with the death, and left out of the kill roll
                            -- that followed it, "Mr. Smite killed me in the Deadmines. Mr. Smite, Captain Greenskin and
                            -- Edwin VanCleef fell": 2026-11-06 review)
                            if W.deathInAvenged and not (L.Boss and L.Boss(e.d) and L.Boss(e.d).last) then
                                for _, x in ipairs(s.events) do
                                    if x.k == "boss" and x.d == e.d and (x.t or 0) > (e.t or 0) then
                                        pool = W.deathInAvenged
                                        st.avengedHere = st.avengedHere or {}
                                        st.avengedHere[e.d] = true
                                    end
                                end
                            end
                        end
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
                        elseif foe and (history.killers[cause] or 0) >= 1 and W.deathAgainFoe and not (OfAKind(e) and (history.killers[cause] or 0) < 2) then
                            -- (a named foe that killed you before, on an earlier day)
                            st.Foe = Cap(foe)
                            local n = history.killers[cause] + 1
                            st.nth = ({"first", "second", "third", "fourth", "fifth", "sixth", "seventh", "eighth", "ninth", "tenth"})[n] or (tostring(n) .. "th")
                            st.count = Words(n)
                            pool = (n >= 3 and W.deathAgainFoeMany) or W.deathAgainFoe
                        end
                        history.deathDay, history.deathCause = index, cause
                        local sinceDeath = history.lastDeathDay and (dayNumber - history.lastDeathDay) or nil
                        if pool == W.death.foe or pool == W.deathAgainDay or pool == W.deathAgainFoe then
                            plan.meta = {simpleDeath = {foe = foe, sub = st.sub, again = pool ~= W.death.foe, sameDay = pool == W.deathAgainDay}}
                        end
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
                    elseif e.k == "rez" and e.by and not e.told and (function()
                        -- (a spirit healer or an unnamed "someone" is not a stranger named so: the walk back says it)
                        local by = Clean(e.by)
                        if by:lower():find("spirit healer", 1, true) or by:match("^%l") then return false end
                        for _, x in ipairs(s.events) do if x.k == "death" and (x.t or 0) <= (e.t or 0) then return true end end
                    end)() then
                        -- (a friend by first name, "Marrow" for "Marrow Rotmoor"; a stranger by the name given)
                        local known = Lane.Known(e.by)
                        st.by = known and N((Clean(e.by):match("^[^%s%-]+") or e.by)) or N(e.by)
                        -- a friend's rez told by their class (the spirits, the Light), from the people list
                        local byClass = known and W.rezBy and W.rezBy[Lane.ClassOf(e.by) or ""]
                        if byClass and teller.rng() < 0.7 then Say(teller:Say("rezBy", byClass, st), true, "rez")
                        else Say(teller:Say(known and "rez" or "rezStranger", (known or not W.rezStranger) and W.rez or W.rezStranger, st), true, "rez") end
                    elseif e.k == "close" and (deathsToday == 0 or (clumsy and e.env)) and not closeToday and not e.told then
                        closeToday = true
                        local foe = e.d and Lane.Foe(e)
                        if (e.pr or e.pc) and not e.d then
                            -- one of the other side: what they were, not their name
                            local theirRace, theirClass = e.pr and Clean(e.pr):lower(), e.pc and Clean(e.pc):lower() or "fighter"
                            local lead = theirRace or theirClass
                            foe = (lead:match("^[aeiou]") and "an " or "a ") .. (theirRace and (theirRace .. " ") or "") .. theirClass
                                .. (theirRace and "" or (" of the " .. (faction == "Horde" and "Alliance" or "Horde")))
                        end
                        st.foe, st.sub = foe, e.sz and Place(e.sz)
                        st.inSub = st.sub and ("in " .. st.sub) or nil
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
                        for n2 = 1, #s.events do
                            if s.events[n2] == e then
                                local n3 = n2 + 1
                                while s.events[n3] and DR.Quiet(s.events[n3]) do n3 = n3 + 1 end
                                nextEvent = s.events[n3]
                            end
                        end
                        local handInBetween = false
                        if e.k == "boss" and nextEvent and nextEvent.k == "boss" then
                            for _, q in ipairs(s.quests) do
                                if (q.t or 0) > (e.t or 0) and (q.t or 0) < (nextEvent.t or 0) then handInBetween = true end
                            end
                        end
                        if not (e.k == "boss" and nextEvent and nextEvent.k == "boss") or handInBetween then FlushKills() end
                        -- (a rest, a new home or a trainer visit is an anchor too: work done before it is
                        -- told before it, so the day reads in the order it happened, 2026-11-07)
                        if #out > eventStart and (e.k == "death" or e.k == "wipe" or e.k == "boss" or e.k == "dungeon" or e.deathRun
                            or (eventStart >= 1 and (e.k == "campfire" or e.k == "rest" or e.k == "home" or e.k == "learn"))) then
                            questAnchors[#questAnchors + 1] = {first = eventStart + 1, last = #out, t = e.t or 0, kind = e.k, zone = e.d}
                        end
                    end
                end
                FlushKills()
                if DR.gathered then DR.SayLosses(s, st); DR.SayCostly(nil) end
                plan.event = nil
                if st.hkLine then Say(st.hkLine[1], st.hkLine[2], "death"); st.hkLine = nil end
                if (st.pvpDeaths or 0) >= 2 and W.deathPvpMany and (function()
                    local n = 0
                    for _, x in ipairs(s.events) do if x.k == "death" and (x.pr or x.pc) then n = n + 1 end end
                    return n >= 3
                end)() then
                    st.count, st.side = Words(st.pvpDeaths), faction == "Horde" and "Alliance" or "Horde"
                    Say(teller:Say("deathPvpMany", W.deathPvpMany, st), true, "death")
                elseif DP.loose > 2 then st.count = Words(DP.loose); Say(teller:Say("deaths", W.deaths, st), true); Title(45, teller:Pick("tDeath", W.titles.death)) end
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
                            -- (round 4: the boast is about the lord when the run killed it, else the last kill)
                            local lordKill
                            for _, y in ipairs(s.events) do if y.k == "boss" and L and L.Boss and L.Boss(y.d) and L.Boss(y.d).last and y.me then lordKill = y end end
                            local me = x == (lordKill or lastKill) and x.me
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
                    -- (the lord's own sentence carried its epithet today: an after line that repeats
                    -- the epithet's noun, "the swarm's general", is not said twice)
                    local epithetSaid = history.lordFellDay and history.lordFellDay[Clean(b)] == index and lore and lore.e and lore.after
                    if epithetSaid then
                        epithetSaid = false
                        for word in lore.e:lower():gmatch("%a%a%a%a%a+") do
                            if lore.after:lower():find(word:gsub("s$", ""), 1, true) then epithetSaid = true end
                        end
                    end
                    -- (Kel'Thuzad's "Naxxramas had lost its master" after "the lich lord of Naxxramas": one of the
                    -- other consequence lines says it without the echo, 2026-11-06 review)
                    local afterLine = lore and lore.after
                    if epithetSaid and lore.afterMore then
                        for _, more in ipairs(lore.afterMore) do
                            local clash = false
                            for word in lore.e:lower():gmatch("%a%a%a%a%a+") do
                                if more:lower():find(word:gsub("s$", ""), 1, true) then clash = true end
                            end
                            if not clash then afterLine = more; epithetSaid = false; break end
                        end
                    end
                    if lore and afterLine and not history.bosses[b] and not epithetSaid and not DR.QuestNamesBoss(b) then
                        local countBefore = #out
                        -- (with no turn-in to close the run, this line is its closure: one of the lord's lines that
                        -- does not crowd a name said twice already, else this one, said all the same, round 2)
                        local closing = (not st.raceSaid and lore.afterRace and lore.afterRace[race]) or afterLine
                        if Crowded(closing) then
                            for _, more in ipairs(lore.afterMore or {}) do if not Crowded(more) then closing = more; break end end
                        end
                        Say(closing, true, "lore", not (DR.runs[si] and DR.runs[si].run and #DR.runs[si].run.quests > 0))
                        if #out > countBefore then consequenceAt = #out end
                        consequence = true
                    end
                    history.bosses[b] = true
                end
                if dn then
                    if dn.first and dn.firstSaid then
                        Title(78, teller:Pick("tFirstDungeon", W.titles.firstDungeon))
                    elseif dn.first then
                        st.dungeonD = Place(dn.name)
                        if deathsHere == 0 and not consequence then Say(teller:Say("firstDungeonEnd", W.firstDungeonEnd, st), true)
                        elseif deathsHere > 0 and W.firstDungeonDied then Say(teller:Say("firstDungeonDied", W.firstDungeonDied, st), true) end
                        Title(78, teller:Pick("tFirstDungeon", W.titles.firstDungeon))
                    end
                    -- The run that stopped short of the lord: the lord beat us, a veteran fell short, or the
                    -- run simply ended; then what still holds the deeper halls (Lore's `unfinished`).
                    if dn.unfinished and dn.lord and W.dungeonUnfinished then
                        local ut = {lord = st.lord, Lord = st.lord, short = st.short, Short = st.short, dungeonE = Place(dn.name), they = st.they,
                            lastKill = dn.lastKill and Place(dn.lastKill) or st.lord, we = st.we, We = st.We, us = st.us, our = st.our, were = st.were}
                        ut.LastKill = ut.lastKill
                        if dn.lordBeat and W.dungeonFellShort then
                            Say(teller:Say("dungeonFellShort", W.dungeonFellShort, ut), true)
                            Title(72, teller:Pick("tFellShort", W.titles.fellShort))
                        elseif dn.lordDoneBefore and W.dungeonShortVeteran and dn.lastKill then
                            Say(teller:Say("dungeonShortVeteran", W.dungeonShortVeteran, ut), true)
                            Title(70, teller:Pick("tUnfinished", W.titles.unfinished))
                        else
                            local pool = (dn.left and W.dungeonUnfinished.left) or W.dungeonUnfinished.ended
                            if not dn.lastKill then
                                local kept = {}
                                for _, line in ipairs(pool) do if not line:find("{lastKill}", 1, true) and not line:find("{LastKill}", 1, true) then kept[#kept + 1] = line end end
                                pool = #kept > 0 and kept or pool
                            end
                            Say(teller:Say(dn.left and "dungeonUnfinishedLeft" or "dungeonUnfinishedEnded", pool, ut), true)
                            Title(70, teller:Pick("tUnfinished", W.titles.unfinished))
                        end
                        if dn.story and dn.story.unfinished then
                            history.unfinishedLoreN = (history.unfinishedLoreN or 0) + 1
                            if history.unfinishedLoreN % 2 == 1 then
                                local lines = (L.WithoutBosses and L.WithoutBosses(dn.story.unfinished, bosses)) or dn.story.unfinished
                                -- (not two sentences running that open on the same word, "Past Garr... Past the halls")
                                local prevWord = (out[#out] or ""):gsub("{%a:([^}]*)}", "%1"):match("^(%a+)")
                                local kept = {}
                                for _, line in ipairs(lines) do
                                    if line:gsub("{%a:([^}]*)}", "%1"):match("^(%a+)") ~= prevWord then kept[#kept + 1] = line end
                                end
                                if #kept > 0 then Say(PickLore(kept), false, "lore") end
                            end
                        end
                    elseif dn.atLast and dn.reached and W.lordAtLast
                        and not (history.lordFellDay and dn.lord and history.lordFellDay[Clean(dn.lord)] == index) then
                        Say(teller:Say("lordAtLast", W.lordAtLast, {short = st.short, Short = st.short, us = st.us, we = st.we}), true)
                    end
                    -- When earned, a line of what it took (round 2): a run that needed a second try, a first
                    -- dungeon walked out of without a death. Once a book each, now and then, never the last
                    -- line of a chapter (the way out and the turn-ins follow it).
                    if W.runEarned and not dn.unfinished and #s.bosses > 0 and si < #stretches then
                        local retried = false
                        for _, x in ipairs(s.events) do if x.k == "dungeon" and x.retry and x.wipe then retried = true end end
                        local kind = (retried and "secondTry") or (dn.first and deathsHere == 0 and "firstClean") or nil
                        history.runEarned = history.runEarned or {}
                        -- (not right after my part in it: one reflective line, not two)
                        if kind and W.runEarned[kind] and not history.runEarned[kind] and kinds[#out] ~= "role" and teller.rng() < 0.7 then
                            history.runEarned[kind] = true
                            Say(teller:Say("runEarned" .. kind, W.runEarned[kind], st), false, "role")
                        end
                    end
                    if dn.reached then history.dungeonLordDone[dn.name] = true end
                    history.dungeonUnfinishedLast[dn.name] = dn.unfinished or nil
                    history.dungeonDiedLast[dn.name] = (deathsHere > 0) or nil
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
                    -- (a setup that itself names the dungeon just left takes no place in front of it: "In
                    -- Orgrimmar, the Searing Blade made its home in Ragefire Chasm" put two places in one
                    -- sentence. The return is said on its own instead, 2026-11-06 review)
                    do
                        local firstSentence = (out[start + 1] or ""):gsub("{%a:([^}]*)}", "%1"):match("^[^%.]*")
                        local dungeonName = dungeon.zone and Clean(dungeon.zone)
                        if dungeonName and firstSentence:find(dungeonName, 1, true) then
                            local subject = (st and st.We) or "I"
                            out[start + 1] = subject .. " " .. (subject == "We" and "were" or "was") .. " back in " .. Place(zone) .. " by then. " .. out[start + 1]
                            questPlaces[dungeon] = zone
                            return
                        end
                    end
                    -- The record places this work outside the just-narrated
                    -- dungeon. Establish that fact, without inventing a return.
                    local line = out[start + 1]
                    -- (a line that opens on its own place, "At Aerie Peak, ...", takes no second place in front:
                    -- the arrival is said first, then the line as written)
                    if A.JournalTale and A.JournalTale.PlaceLed and A.JournalTale.PlaceLed(line) then
                        out[start + 1] = ((st and st.We) or "I") .. " had come to " .. Place(zone) .. " by then. " .. line
                        questPlaces[dungeon] = zone
                        return
                    end
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
                    -- (the shared rule, A.JournalPlaceLead: a common first word goes to lower case, a name
                    -- keeps its capital, and a line that opens on speech, "Finally, said Lydon", takes the
                    -- arrival on its own in front instead of "In X, Finally, said")
                    local prefixed = A.JournalPlaceLead and A.JournalPlaceLead(Place(zone), line, corpus)
                    if not prefixed and A.JournalPlaceLead then
                        out[start + 1] = ((st and st.We) or "I") .. " had come to " .. Place(zone) .. " by then. " .. line
                        questPlaces[dungeon] = zone
                        return
                    end
                    out[start + 1] = prefixed or ("In " .. Place(zone) .. ", " .. line:gsub("^(%a+) ", function(word)
                        if lowerLead[word] then return lowerLead[word] .. " " end
                        local low = word:lower()
                        if low ~= word and corpus:find("%f[%a]" .. low .. "%f[%A]") then return low .. " " end
                        return word .. " "
                    end))
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
                    for _, arr in ipairs({out, majors, kinds, times, scenes, plan.metas}) do
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
                -- The quests, told from my side (DESIGN §3.0, 2026-11-07). The chapter's plan
                -- (dayPlan, QD.Plan) chose the few worth telling; each is one moment in the
                -- character's words (the stage's `pov`, or a player-led line made from it), in
                -- recorded order. The other work of the stretch folds between them into light
                -- grouped lines of short acts (Everything only, two lines a stretch at most);
                -- work with nothing to say for itself is left out. A fallback moment (no `pov`)
                -- may keep one outcome sentence of the stage's own text, once a chapter, never
                -- two pack sentences in a row.
                local QD = A.QuestDeeds
                local run, foldLines = {}, 0
                local band = QD and QD.Band(s.level or person.startLevel)
                local function Tokens(solo)
                    local we = solo and "I" or st.we
                    return {We = solo and "I" or st.We, we = we, us = solo and "me" or st.us, our = solo and "my" or st.our,
                        Our = Cap(solo and "my" or st.our), I = "I", me = "me", my = "my", My = "My"}
                end
                -- A grouped line names people and towns the chapter has named already by their short
                -- form: "Executor Zygand" is "Zygand" the second time, "Eleanor Shackleton" "Eleanor",
                -- and "in Brill" is dropped when one of the last two sentences said Brill
                -- ("...from Eleanor Shackleton... to Eleanor Shackleton's camp", 2026-11-07).
                local function ShortNames(text)
                    local said = A.JournalPlain(table.concat(out, " "))
                    local recent = A.JournalPlain(table.concat(out, " ", math.max(1, #out - 1)))
                    local givers = {}
                    for _, e in ipairs(dayPlan.entries or {}) do
                        local g = (e.act and e.act.giver) or (e.story and e.story.pov and e.story.pov.giver)
                        if g then givers[g] = true end
                    end
                    for _, e in ipairs(dayPlan.entries or {}) do
                        local act = e.act and e.act.act
                        for full in tostring(act or ""):gmatch("%u[%a']+ %u[%a']+") do givers[full] = givers[full] or "act" end
                    end
                    for full in pairs(givers) do
                        local first, last = full:match("^(%u[%a']+) .- ?(%u[%a']+)$")
                        if first and said:find(full, 1, true) and text:find(full, 1, true) then
                            local short = TITLE_WORDS[first] and last or (givers[full] == true and first) or nil
                            if short and not text:find(full .. " " .. "%u") then
                                local at = text:find(full, 1, true)
                                text = text:sub(1, at - 1) .. short .. text:sub(at + #full)
                            end
                        end
                    end
                    text = text:gsub(" in (%u[%a']+)([%.,])", function(town, stop)
                        if Town(town) and recent:find(town, 1, true) then return stop end
                    end)
                    return text
                end
                local function FlushRun()
                    if #run == 0 then return end
                    local pending = run
                    run = {}
                    if brief or not QD then return end
                    local lines
                    lines, foldShape = QD.Folds(pending, Tokens(false), foldShape, giversNamed, band)
                    for _, line in ipairs(lines) do
                        if foldLines >= 6 or _ > 4 then break end
                        dayPlan.npcLast = false
                        foldLines = foldLines + 1
                        local start = #out
                        sayTime = line.last.t
                        plan.meta = {fold = line, short = ShortNames}
                        Say(ShortNames(line.text), false, "quests")
                        PlaceQuestPassage(start, line.quest)
                    end
                end
                local revengeSaid, lastSegment = false, nil
                for _, q in ipairs(s.quests) do
                    local e = dayPlan.byQuest[q]
                    -- (a new sitting gets its own lines: the cap counts per sitting)
                    if e and e.segment ~= lastSegment then FlushRun(); foldLines = 0; lastSegment = e.segment end
                    if e and e.mention and QD then
                        FlushRun()
                        local start = #out
                        sayTime = q.t
                        local solo = e.act and e.act.solo or (e.story and e.story.pov and e.story.pov.solo)
                        momentsSaid = momentsSaid + 1
                        -- (a chain taken up again after a week or more says since when, once)
                        local thread = e.story and e.story.thread
                        local before = thread and history.storyThreads[thread]
                        if before and before.day < index and e.story.threadLabel and W.threadSince and not before.sinceSaid
                            and (dayNumber - (before.first or dayNumber)) >= 7 then
                            before.sinceSaid = true
                            local span = Ago(dayNumber - before.first)
                            Say(teller:Say("threadSince", W.threadSince, {thread = e.story.threadLabel, span = span, Span = Cap(span)}), true, "lore")
                        end
                        -- (the variant by the quest, fixed per book so the
                        -- companion book always takes the other one)
                        local variant = QD.Variant(QD.Key(q))
                        -- (never two of a stage's own outcome lines in a row: the second is told plainly)
                        -- (work told before in this book is said plainly the second time, never its scene again)
                        local line, own, from = QD.Moment(e, Tokens(solo), variant, dayPlan.npcLast or history.questLore[QD.Key(q)] == true, brief,
                            history.questLore[QD.Key(q)] == true)
                        -- (the run told the kill already today: the turn-in says only what came of it, 2026-11-11)
                        line, own, from = DR.AfterRun(line, own, from, e, variant, Tokens(solo), solo and "I" or st.We, q, st.zoneD, si)
                        dayPlan.npcLast = from == "after"
                        plan.meta = {entry = e}
                        Say(line, true, from == "after" and "questOutcome" or "questStart", true)
                        if e.act and e.act.giver then giversNamed[(e.act.giver:match("(%S+)$"))] = true end
                        if not own and from ~= "after" and not brief and not dayPlan.outcomeSaid then
                            local outcome = QD.Outcome(e, teller.rng())
                            if outcome then dayPlan.outcomeSaid = true; plan.meta = {entry = e, outcome = true}; Say(outcome, true, "questOutcome", true) end
                        end
                        if e.foe and W.questRevenge and not revengeSaid then
                            revengeSaid = true
                            Say(teller:Say("questRevenge", W.questRevenge, {foe = Place(e.foe), Foe = Place(e.foe)}), true)
                            Title(66, Clean(e.foe))
                        end
                        PlaceQuestPassage(start, q)
                        if e.story and e.story.covers then st.covered = e.story.covers end
                        history.questLore[QD.Key(q)] = true
                    elseif e and e.act and e.act.act then
                        -- (a death or a dungeon between two pieces of work ends the line: each side
                        -- of it is told on its own side)
                        local last = run[#run]
                        if last then
                            for _, ev in ipairs(questAnchors) do
                                if ev.t > (last.quest.t or 0) and ev.t <= (q.t or 0) then FlushRun(); break end
                            end
                        end
                        run[#run + 1] = e
                        history.questLore[QD.Key(q)] = history.questLore[QD.Key(q)] or "folded"
                    end
                    history.questZones[s.zone or "?"] = true
                    local thread = e and e.story and e.story.thread
                    if thread then
                        local before = history.storyThreads[thread]
                        history.storyThreads[thread] = {day = index, title = q.title, first = before and before.first or dayNumber, sinceSaid = before and before.sinceSaid}
                    end
                end
                FlushRun()
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
                    -- (the short telling keeps a crafter's work, an honest day's, or a big batch)
                    local craftMajor = honest or profile.crafter or (line.count or 0) >= 10
                    plan.meta = {trade = trade, count = line.count or 0}
                    if trade == "Mining" and W.smelt then
                        local metals = {}
                        -- (the record keeps the spell's name: "Smelt Copper" is copper)
                        for _, m in ipairs(line.made or {}) do metals[#metals + 1] = (Clean(m):gsub("^Smelt ", ""):gsub(" Bar$", ""):lower()) end
                        st.made = #metals > 0 and List(metals) or "metal"
                        Say(teller:Say("smelt", W.smelt, st), craftMajor, "craft")
                    elseif (line.count or 0) == 1 and #made == 1 then Say(teller:Say("craftOne", W.craftOne, st), craftMajor, "craft")
                    elseif #made > 0 and W.craftBy and W.craftBy[trade] then Say(teller:Say("craftBy" .. trade, W.craftBy[trade], st), craftMajor, "craft")
                    elseif #made > 0 then Say(teller:Say("craftMade", W.craftMade, st), craftMajor, "craft")
                    elseif (line.count or 0) > 0 then Say(teller:Say("craftPlain", W.craftPlain, st), craftMajor, "craft") end
                    plan.meta = nil
                end
                for _, line in ipairs(st.afterCraft or {}) do Say(line, true, "first") end
                st.afterCraft = nil
                for _, c in ipairs(st.classAfter or {}) do if c.z ~= st.covered then Say(c.line, true, "first") end end
                for _, line in ipairs(st.restAfter or {}) do Say(line, false, "rest") end
                st.restAfter = nil
                st.classAfter = nil
                if st.nightLine then Say(st.nightLine, true); st.nightLine = nil end
                -- (lane G: out of a dungeon by a zone only crossed, then the crossing carried out of it,
                -- in that order: "Then we were back out in the Badlands. The zeppelin carried me...")
                local nxt = stretches[si + 1]
                if DR.runs[si] and st.goAfter and #st.goAfter > 0 and nxt and nxt.zone ~= s.zone and not DR.runs[si + 1] and W.leaveDungeon
                    and L and L.Dungeon and L.Dungeon(s.zone) and not (function() for _, x in ipairs(s.events) do if x.k == "hearth" then return true end end end)() then
                    local outZone = DR.OutZone(s) or nxt.zone
                    Say(teller:Say("leaveDungeon", W.leaveDungeon, {zoneD = Place(outZone), zoneE = ZoneE(outZone), We = st.We, we = st.we, us = st.us, our = st.our, were = st.were}), false, "move")
                    DR.leftSaid = true
                end
                for _, go in ipairs(st.goAfter or {}) do plan.meta = {e = go.e, t = go.t}; Say(go[1], go[2], go[3]) end
                st.goAfter = nil
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
                -- (a death count never inside a dungeon run's paragraph, round 2: it would be a stray line there)
                if deathsHere > 0 and not s.run then
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
                            if not history.firstKiller then
                                history.firstKiller = (e.d and not e.boss) and Lane.Foe(e) or Place(foe)
                            end
                            if e.d and not e.boss then
                                local said = Lane.Foe(e)
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
            local levelMoved = false
            local LevelsLineNow
            -- (a full day by its record: six turn-ins and more; the same in both editions)
            local function BusyDay()
                local n = 0
                for _, s in ipairs(stretches) do n = n + (s.questCount or #(s.quests or {})) end
                return n >= 6
            end
            local function LevelsLine()
                local countBefore = #out
                LevelsLineNow()
                -- (said right after a lord's consequence: the level goes before it, the consequence stays last)
                -- (one level sentence goes before the lord's consequence; the sixty look-back, several
                -- sentences, ends the chapter instead, and the consequence keeps to its kills: 2026-11-06)
                if not levelMoved and consequenceAt and consequenceAt == countBefore and #out > countBefore and #out - countBefore == 1 then
                    local last, k = #out, #out - countBefore
                    for _, arr in ipairs({out, majors, kinds, times, scenes, plan.metas}) do
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
                -- (a level the book has told already, or a lower one from a stale entry, is no news)
                if #f.levels > 0 and history.levelTold and f.levels[#f.levels] <= history.levelTold then f.levels = {} end
                if #f.levels > 0 then
                    local top = f.levels[#f.levels]
                    history.levelTold = top
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
                        and not (mark == 10 and talentToday) -- (level ten with the talent point keeps its own line)
                    local earlyPool
                    local whereLevel = early and levelStretch and levelStretch < questStretch and stretches[levelStretch].zone
                    if whereLevel and stretches[questStretch].zone ~= whereLevel then
                        local dungeon = L and L.Dungeon and L.Dungeon(whereLevel)
                        local pool = dungeon and W.levelEarlyDungeon or W.levelEarlyIn
                        if pool then lt.where = Place(whereLevel); earlyPool = pool end
                    end
                    -- (pass 3: the line of that stretch the level goes after: the last one told at or
                    -- before the level, or two minutes after it at most)
                    local levelAfter, levelNear
                    if early and levelStretch and W.levelThere then
                        for i = 1, #out do
                            local mt = plan.metas[i]
                            if scenes[i] == levelStretch and mt and kinds[i] ~= "level" and (mt.t or 0) <= f.levelT + 120 then
                                levelAfter, levelNear = i, mt.t and math.abs(mt.t - f.levelT) <= 120
                            end
                        end
                        if levelAfter and levelAfter >= #out then levelAfter = nil end
                    end
                    if early then
                        lt.level = Words(top) == tostring(top) and tostring(top) or (top >= 10 and top % 10 == 0 and Words(top) or tostring(top))
                        plan.meta = {levelEarly = top, t = f.levelT, mark = mark}
                        if levelAfter then
                            -- (said where it came, then moved there: the line after its stretch's deed)
                            local key = (levelNear and W.levelWithIt) and "levelWithIt" or "levelThere"
                            Say(teller:Say(key, W[key], lt), mark ~= nil, "level")
                            local n = #out
                            for _, arr in ipairs({out, majors, kinds, times, scenes, plan.metas}) do
                                local moved = arr[n]
                                for i = n, levelAfter + 2, -1 do arr[i] = arr[i - 1] end
                                arr[levelAfter + 1] = moved
                            end
                            scenes[levelAfter + 1] = levelStretch
                            levelMoved = true
                        else
                            Say(teller:Say("levelEarly", earlyPool or W.levelEarly, lt), mark ~= nil, "level")
                        end
                        if mark then Title(mark == 60 and 90 or 50, (teller:Pick("tLevel", W.titles.level) or ""):gsub("{level}", tostring(mark))) end
                    elseif mark then
                        -- (level ten with the first talent point, when the record has it)
                        local markPool = (mark == 10 and talentToday and W.milestoneTalent) or W.milestone[mark]
                        lt.class = (person.class or "adventurer"):lower()
                        -- (forty on the day the mount itself is told: the level line leaves riding to the mount)
                        if mark == 40 then
                            local mountToday = false
                            for _, s2 in ipairs(stretches) do
                                for _, x in ipairs(s2.events) do
                                    if x.k == "first" and (x.d == "mount" or (x.d == "class" and (x.z == "warhorse" or x.z == "felsteed"))) then mountToday = true end
                                end
                            end
                            if mountToday then
                                local kept = {}
                                for _, line in ipairs(markPool) do
                                    if not line:find("mount", 1, true) and not line:find("ridden", 1, true) and not line:find("ride", 1, true) then kept[#kept + 1] = line end
                                end
                                if #kept > 0 then markPool = kept end
                            end
                        end
                        Say(teller:Say("milestone" .. mark, markPool, lt), true, "level")
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
                            -- (the first thing that killed me, by name: how far the climb went)
                            if history.firstKiller and W.lookBackKiller then
                                Say(teller:Say("lookBackKiller", W.lookBackKiller, {killer = history.firstKiller, Killer = Cap(history.firstKiller)}), true)
                            end
                        end
                    elseif W.levelsFast and (lt.from or 0) >= 20 and top - (lt.from or top) >= 3 then
                        -- (three levels and more in one day: the speed is the news)
                        Say(teller:Say("levelsFast", W.levelsFast, lt), true, "level")
                    elseif BusyDay() then
                        -- (an everyday level is not news on a full day. Judged by the day's record, never by
                        -- how long this edition's chapter came out: Everything and Highlights say the same
                        -- level line, so Everything never drops one Highlights tells (2026-11-07). After a
                        -- lord's fall the line goes before the consequence, LevelsLine above.)
                        history.levelsUnsaid = (history.levelsUnsaid or 0) + 1
                    elseif #f.levels > 1 then
                        local band = A.QuestDeeds and A.QuestDeeds.Band(top)
                        Say(teller:Say("levels", (band and W.levelsBand and W.levelsBand[band]) or W.levels, lt), false, "level")
                    else
                        local band = A.QuestDeeds and A.QuestDeeds.Band(top)
                        Say(teller:Say("level", (band and W.levelBand and W.levelBand[band]) or W.level, lt), false, "level")
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
                -- ("there" only right after the place was named, never pointing at a field
                -- three sentences back)
                local saidPlace = ((out[#out - 1] or "") .. " " .. (out[#out] or "")):find(Clean(sleep.d), 1, true)
                local inn = InnName(sleep.d)
                -- (pass 3: a corner of a city, "Canals", is told as the city)
                local sleepAt = sleep.d
                if not inn and sleepAt and not Town(sleepAt) and sleep.z and Town(sleep.z) then sleepAt = sleep.z end
                plan.meta = {close = "sleep", place = inn or Place(sleepAt)}
                Say(teller:Say("sleepInn", (saidPlace and W.sleepInnHere) or (inn and W.sleepInnNamed) or W.sleepInn, {place = inn or Place(sleepAt)}), false, "rest")
            elseif hearth and hearth.d and not after and W.hearthHome and not sunsetLater and history.hearthSaid ~= index
                and (index - (history.hearthSaid or -99)) >= 4 and teller.rng() < 0.6 then
                history.hearthSaid = index
                Say(teller:Say("hearthHome", W.hearthHome, {place = Place(hearth.d)}))
            elseif h < 4 and not last.open and not (day.readerEpisode and nextDay and nextDay.sourceDay == day.sourceDay) and teller.rng() < (profile.night and 0.25 or 0.6) then
                -- (a night player's late hours are not news every chapter)
                plan.meta = {close = "late", t = last.e}
                Say(teller:Say("late", W.late, {}))
            elseif f.together >= 4 * 3600 and not (day.readerEpisode and nextDay and nextDay.sourceDay == day.sourceDay) and teller.rng() < 0.4 then
                plan.meta = {close = "long", t = last.e}
                Say(teller:Say("long", W.long, {span = Span(f.together)}))
            end
            history.lastDay = dayNumber
            history.lastZone = last.zone
            -- (what the next opening after a gap may recall: the level, the company, a dungeon, a lord)
            history.lastLevel = f.levels[#f.levels] or last.level or first.level or history.lastLevel
            history.lastWith, history.lastDungeon, history.lastLord = {}, nil, nil
            do
                local seen = {}
                for _, s in ipairs(stretches) do
                    for _, w in ipairs(s.with) do
                        if (w.seconds or 0) >= 600 and not seen[w.name] then seen[w.name] = true; history.lastWith[#history.lastWith + 1] = N(w.name) end
                    end
                    for _, e in ipairs(s.events) do if e.k == "dungeon" and e.d then history.lastDungeon = e.d end end
                    for _, b in ipairs(s.bosses) do
                        local lore = L and L.Boss and L.Boss(b.name)
                        if lore and lore.last then history.lastLord = b.name end
                    end
                end
            end
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
            -- (a line that opens on the place the sentence before just named drops it: "We came to
            -- Brill, the Forsaken town. In Brill, we handed..." reads "...We handed...", 2026-11-07)
            for n = 2, #out do
                local place, rest = out[n]:match("^In ([^,]+), (%l.*)$")
                if place and kinds[n] ~= "lore" and A.JournalPlain(out[n - 1]):find(A.JournalPlain(place), 1, true)
                    and (rest:match("^we ") or rest:match("^i ") or rest:match("^my ") or rest:match("^our ")) then
                    out[n] = Cap(rest)
                end
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
        -- A dungeon run is one paragraph (2026-11-11): the way out of it, the turn-ins of the
        -- quests about it and a level reached with them, told in the stretch after, move up to
        -- the end of the run's lines and take its scene; the paragraph splitter leaves a run whole.
        do
            local runList = {}
            for si in pairs(DR.runs) do runList[#runList + 1] = si end
            table.sort(runList)
            for _, si in ipairs(runList) do
                local run = DR.runs[si]
                local s, after = run.s, stretches[si + 1]
                DR.scenes[si] = true
                -- (a death count is never a line of the run's paragraph, round 4: "Ten deaths, by then.")
                do
                    local tally = {}
                    for _, lines in pairs(W.deathTally or {}) do for _, line in ipairs(lines) do tally[line] = true end end
                    local n = 1
                    while n <= #out do
                        local m = plan.metas[n]
                        local levelTwice = false
                        if kinds[n] == "level" and DR.levelToldAt and run.run and run.run.level and not (m and m.runLevel) then
                            local plainLevel = A.JournalPlain(out[n]):lower()
                            local number = tonumber(run.run.level.level)
                            if number and (plainLevel:find("level " .. number, 1, true) or plainLevel:find("level " .. Words(number), 1, true)) then levelTwice = true end
                        end
                        if (scenes[n] == si and tally[out[n]]) or levelTwice then
                            DR.RemoveLine(n)
                        else
                            n = n + 1
                        end
                    end
                end
                if after and not DR.runs[si + 1] and (after.t or 0) - (s.e or 0) <= 900 then
                    local last
                    for n = 1, #out do if scenes[n] == si then last = n end end
                    if last then
                        local picked, firstOfNext = {}, nil
                        for n = last + 1, #out do
                            if scenes[n] == si + 1 then
                                local m = plan.metas[n] or {}
                                local take = false
                                if not firstOfNext then
                                    firstOfNext = n
                                    take = kinds[n] == "move"
                                elseif (kinds[n] == "questStart" or kinds[n] == "questOutcome") and m.entry then
                                    take = DR.QuestAboutRun(m.entry, run)
                                elseif kinds[n] == "level" and (picked[#picked] == n - 1 or (run.run and run.run.level and m.t == run.run.level.t)) then
                                    take = true
                                end
                                if take then picked[#picked + 1] = n end
                            end
                        end
                        -- (a level reached at the end of the run, told inside its scene, goes to the end of the
                        -- run's lines and folds into the closure, round 5)
                        local inLevel
                        for n = 1, last do
                            local m = plan.metas[n]
                            if scenes[n] == si and kinds[n] == "level" and not (m and m.runLevel) then inLevel = n end
                        end
                        if inLevel and inLevel < last then
                            for _, arr in ipairs({out, majors, kinds, times, scenes, plan.metas}) do
                                local moved = arr[inLevel]
                                for i = inLevel, last - 1 do arr[i] = arr[i + 1] end
                                arr[last] = moved
                            end
                            inLevel = last
                        end
                        local from = last + 1
                        for _, n in ipairs(picked) do
                            -- (the lines moved before this one sit at last+1 and up, below n: n is unchanged)
                            local at = last + 1
                            if n > at then
                                for _, arr in ipairs({out, majors, kinds, times, scenes, plan.metas}) do
                                    local moved = arr[n]
                                    for i = n, at + 1, -1 do arr[i] = arr[i - 1] end
                                    arr[at] = moved
                                end
                            end
                            scenes[at] = si
                            last = at
                        end
                        if #picked > 0 then DR.Closure(inLevel or from, last, after) end
                    end
                end
            end
        end
        -- Highlights keep a scene's bearings, its work, and one quiet beat.
        -- Major events remain intact; repetition is cut within a scene, never
        -- by throwing away all the connective tissue or an uneventful day.
        -- The composer (JournalSelfCompose.lua, 2026-11-11): the day in episodes, each line in its
        -- episode's slot, the furniture out, one paragraph an episode, the chapter closed on what
        -- the evening came to. Settings > Testing > compose: off keeps the teller's own order.
        function plan.Compose()
            if not (A.SelfCompose and A.SelfCompose.Apply) or (A.BookVariant and A.BookVariant("compose") == "off") then return end
            plan.composed = A.SelfCompose.Apply({day = day, stretches = stretches, out = out, majors = majors, kinds = kinds, times = times,
                scenes = scenes, metas = plan.metas, dayPlan = dayPlan, teller = teller, W = W, Place = Place, person = person,
                history = history, index = index, brief = brief,
                -- (for the selection of the work, JournalSelfPlan's Sel through the composer: lane U)
                race = race, class = person.class, titleWords = TITLE_WORDS, Companion = Companion,
                level = stretches[#stretches] and stretches[#stretches].level or person.level,
                seed = (person.charKey or person.name or "me") .. ":" .. tostring(retell or person.retell or 0)}) or nil
        end
        if not planned then plan.Compose() end
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
        if ST.Trace then ST.Trace(day, out, kinds, scenes, times, majors, stretches, plan.metas) end -- (offline printers only)
        -- The planned telling goes over the day's lines once more (Settings > Testing > Storyteller).
        -- A failure there leaves the chapter as the current teller wrote it.
        if planned then
            local ctx = {day = day, out = out, kinds = kinds, majors = majors, metas = plan.metas, stretches = stretches, history = history,
                index = index, W = W, race = race, level = stretches[#stretches] and stretches[#stretches].level or person.level,
                seed = (person.charKey or person.name or "me") .. ":" .. tostring(retell or person.retell or 0),
                Place = Place, Cap = Cap, Evening = Evening, titleWords = TITLE_WORDS,
                -- (for the selection: the companion's own record, the character's class and side)
                Companion = Companion, class = person.class, faction = person.faction}
            if ST.PlanStrict then plan.text = A.SelfPlan.Apply(ctx)
            else
                local ok, result = pcall(A.SelfPlan.Apply, ctx)
                plan.text = ok and result or nil
            end
            -- (a day the planned telling leaves to the current teller is composed like any other)
            if not plan.text then plan.Compose() end
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
            ["open>town"] = true, ["move>town"] = true, ["town>rest"] = true, ["open>level"] = true, ["town>level"] = true,
            -- (the day's gathering and crafting join the place or the work before and after them, as they did untagged)
            ["open>gather"] = true, ["move>gather"] = true, ["town>gather"] = true, ["quests>gather"] = true, ["gather>quests"] = true,
            ["gather>level"] = true, ["gather>rest"] = true, ["gather>craft"] = true, ["craft>level"] = true, ["craft>rest"] = true,
            ["town>craft"] = true, ["open>craft"] = true, ["quests>craft"] = true}
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
            -- (three short sentences in a row: the first two always join when they may)
            local nextShort = b and out[i + 2] and scenes[i + 2] == scenes[i] and wa <= 9 and wb <= 9 and Words2(out[i + 2]) <= 9
            local plain = b and kinds[i] ~= "lore" and kinds[i + 1] ~= "lore" and a:match("%.$") and not a:find(" and ", 1, true)
                and not b:find(" and ", 1, true) and not a:find("%. ") and not b:find("%. ")
                and not STANDALONE[kinds[i] or ""] and not STANDALONE[kinds[i + 1] or ""]
            -- (a lead and the quests that have an "and" of their own: "I went on to the Barrens, then turned in A and B.")
            local thenJoin = b and kinds[i + 1] == "quests" and (kinds[i] == "move" or kinds[i] == "town" or kinds[i] == "open")
                and a:match("%.$") and not a:find(" and ", 1, true) and not a:find("%. ") and not b:find("%. ") and b:find(" and ", 1, true)
                and Mine(a) and b:match("^[IW]e? ") and wa + wb <= 26
            if b and kinds[i] == "open" and kinds[i + 1] == "mood" and b:match("^It was a day of ") and wa <= 9 and nextShort
                and a:match("%.$") and not a:find(" and ", 1, true) and not a:find("%. ") then
                -- ("I was still in Darkshore, and it was a day of honest work." instead of three short sentences)
                joinedOut[#joinedOut + 1] = a:gsub("%.$", "") .. ", and it was " .. b:sub(8)
                joinedMajors[#joinedOut] = majors[i] or majors[i + 1]
                i = i + 2
            elseif plain and (kinds[i] == "death" or kinds[i] == "deathRun") and kinds[i + 1] == "rez" and wa + wb <= 24 then
                -- ("..., but a stranger named Gorna brought me back": an article loses its capital after the join)
                joinedOut[#joinedOut + 1] = a:gsub("%.$", "") .. ", but " .. (b:match("^An? ") and (b:sub(1, 1):lower() .. b:sub(2)) or b)
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
                and b:match("^I (%a+) ") and LEVEL_ING[b:match("^I (%a+) ")] and not b:find("[,%.] ") and (a:find(" and ", 1, true) or teller.rng() < 0.5) then
                -- ("I turned in A and B, reaching level 4.")
                local verb = b:match("^I (%a+) ")
                joinedOut[#joinedOut + 1] = a:gsub("%.$", "") .. ", " .. LEVEL_ING[verb] .. b:sub(#verb + 3)
                joinedMajors[#joinedOut] = majors[i] or majors[i + 1]
                i = i + 2
            elseif b and kinds[i] == "kill" and kinds[i + 1] == "level" and a:match("%.$") and not a:find("%. ") and not a:find(",", 1, true)
                and not a:find(" and ", 1, true) and b:match("^I ") and not b:find(",", 1, true) and wa + wb <= 22 then
                -- ("VanCleef never got past me, and I went up to level 18." A role line never takes the level:
                -- "My place was behind the others, keeping them alive, and I reached level forty" is accounting.)
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
                and (teller.rng() < 0.75 or nextShort) then
                -- (no comma when both halves are short)
                joinedOut[#joinedOut + 1] = a:gsub("%.$", "") .. ((wa < 10 and wb < 10 and not a:find(",", 1, true)) and " and " or ", and ") .. b:sub(3)
                joinedMajors[#joinedOut] = majors[i] or majors[i + 1]
                i = i + 2
            elseif plain and kinds[i] ~= "death" and Belongs(i) and i > 1 and not Mine(a) and b:match("^I ") and not b:match("^I had ") and wa <= 8 and wa + wb <= 20
                and (teller.rng() < 0.6 or nextShort) then
                -- ("Five quests kept me busy, and I made level 6.")
                joinedOut[#joinedOut + 1] = a:gsub("%.$", "") .. ", and " .. b
                joinedMajors[#joinedOut] = majors[i] or majors[i + 1]
                i = i + 2
            elseif b and kinds[i] == "rest" and kinds[i + 1] == "rest" and a:match("%.$") and not a:find("[,%.] ") and not b:find("%. ")
                and not a:find(" and ", 1, true) and not b:find(" and ", 1, true) and wa + wb <= 22
                and ((a:match("^We ") and b:match("^We ")) or (a:match("^I ") and b:match("^I "))) then
                -- (two rests in a row, one sentence: "We sat by a campfire for a while, then stopped at
                -- the Gallows' End Tavern to rest." instead of two sentences opening on "We", 2026-11-07)
                joinedOut[#joinedOut + 1] = a:gsub("%.$", "") .. ", then " .. b:gsub("^%a+ ", "")
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
            local turn = not plan.composed and (kind == "questTurn" or n < #out and ((kind == "questStart" and paragraphWords >= 45)
                or (paragraphWords >= 55 and (kind == "death" or kind == "kill" or kind == "rest" or kind == "town" or kind == "move"))))
            -- (a dungeon run stays one paragraph)
            if turn and DR.scenes[joinedScenes[n]] and joinedScenes[n] == joinedScenes[n - 1] then turn = false end
            if #paragraph > 0 and (joinedScenes[n] ~= joinedScenes[n - 1] or turn) then
                paragraphs[#paragraphs + 1] = table.concat(paragraph, " ")
                paragraph, paragraphWords = {}, 0
            end
            paragraph[#paragraph + 1] = sentence
            paragraphWords = paragraphWords + Words2(sentence)
        end
        if #paragraph > 0 then paragraphs[#paragraphs + 1] = table.concat(paragraph, " ") end
        local text = plan.text or table.concat(paragraphs, "\n\n")
        if planned then history.plan.text = history.plan.text .. " " .. (A.JournalPlain and A.JournalPlain(text) or text) end
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
        -- (did the day lead this chapter? the next one, a week or less on, opens on the place or the company)
        if chapterWhen and out[1] and out[1]:find(chapterWhen, 1, true) == 1 then history.whenLedAt = index end
        if text ~= "" or #f.quotes > 0 then
            history.chapter = history.chapter + 1
            stories[day.key] = {text = OneStop(text), title = title and title:gsub("^%l", string.upper) or nil, chapter = history.chapter, quotes = f.quotes}
        else
            stories[day.key] = {text = "", title = nil, chapter = history.chapter, quotes = {}}
        end
    end
    return stories
end
