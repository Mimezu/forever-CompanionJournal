local _, A = ...
-- The journal as a book: days made of scenes, and the prose the journal
-- window's styles lay out. Two modes:
--   "all"        every adventure, one paragraph per scene;
--   "highlights" one short paragraph per day with its notable feats, told
--                more warmly but never beyond what was recorded.
-- A scene is a stretch of travel together in one place (consecutive outings
-- there are merged), with the quests, bosses, dungeons, campfires and levels
-- that happened during it; or a single moment outside any outing (a sighting,
-- a quest credited later, a line you wrote). A scene that continues one from
-- the evening before stays on that day, so a night's run is not cut in two.
-- Text carries light markup for the styles to color: {p:place or foe},
-- {q:quest title}, {n:their name}.

local MERGE_GAP = 20 * 60      -- two outings in the same zone this close are one scene
local CONTINUE_GAP = 10 * 60   -- an outing starting this soon after another continues it

-- Words ------------------------------------------------------------------------
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
    return tostring(n)
end
A.JournalWords = Words
local function Count(n, singular, plural) return Words(n) .. " " .. (n == 1 and singular or plural) end
local function Times(n) return n == 2 and "twice" or n == 3 and "three times" or (Words(n) .. " times") end
local function List(items)
    if #items <= 1 then return items[1] or "" end
    return table.concat(items, ", ", 1, #items - 1) .. " and " .. items[#items]
end
local function Clean(text) return (tostring(text or ""):gsub("[{}]", "")) end
local function P(text) return "{p:" .. Clean(text) .. "}" end
local function Q(text) return "{q:" .. Clean(text) .. "}" end
local function N(text) return "{n:" .. Clean(text) .. "}" end
-- Exact length: "thirty-three minutes", "an hour and eighteen minutes".
local function Exact(seconds)
    local minutes = math.max(1, math.floor((seconds or 0) / 60 + 0.5))
    if minutes < 60 then return Count(minutes, "minute", "minutes") end
    local hours, rest = math.floor(minutes / 60), minutes % 60
    local head = hours == 1 and "an hour" or (Words(hours) .. " hours")
    return rest > 0 and (head .. " and " .. Count(rest, "minute", "minutes")) or head
end
-- Approximate length, for the highlights: "about forty minutes", "nearly four hours".
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
A.JournalAbout = About -- (the storytellers: a battleground match's length)
local function Hour(t) return tonumber(date and date("%H", t or 0) or 12) or 12 end
local function PartOfDay(t)
    local h = Hour(t)
    if h >= 5 and h < 12 then return "morning" end
    if h >= 12 and h < 17 then return "afternoon" end
    if h >= 17 and h < 22 then return "evening" end
    return "night"
end
-- Play after midnight, before five in the morning, belongs to the evening before
-- ("On Thursday night", under Thursday's date), as a player thinks of it.
local function Evening(t)
    local h = tonumber(date and t and date("%H", t) or 12) or 12
    if t and h < 5 then return t - 5 * 3600 end
    return t
end
A.JournalEvening = Evening
local function DayKey(t) return date and date("%Y-%m-%d", Evening(t or 0)) or "?" end
local function FirstName(person) return person.display or (person.name or ""):match("^[^%-]+") or "They" end
-- A stable choice among phrasings, so a day reads the same every time.
local function Pick(seed, options)
    local sum = 0
    for i = 1, #seed do sum = (sum * 31 + seed:byte(i)) % 1000003 end
    return options[sum % #options + 1]
end

-- Voices: the book speaks to you ("you travelled"), the diary style speaks as
-- you ("we travelled").
local VOICES = {
    you = {you = "you", You = "You", your = "your", Your = "Your", I = "you", Ime = "you"},
    we = {you = "we", You = "We", your = "our", Your = "Our", I = "I", Ime = "me"},
    me = {you = "I", You = "I", your = "my", Your = "My", I = "I", Ime = "me"},
}

-- The book ---------------------------------------------------------------------
local function NewScene(kind, t)
    return {kind = kind, t = t, entries = {}, events = {}, quests = {}, questCount = 0, dungeons = {}, bosses = {}, levels = {}}
end
local function Add(scene, entry)
    scene.entries[#scene.entries + 1] = entry
    local k = entry.k
    if k == "quest" and entry.d then
        scene.questCount = scene.questCount + 1
        local found
        for _, quest in ipairs(scene.quests) do if quest.title == entry.d and quest.qid == entry.qid then found = quest end end
        -- (t: the last turn-in, for what came before or after it)
        if found then found.count = found.count + 1; found.t = math.max(found.t or 0, entry.t or 0)
        else scene.quests[#scene.quests + 1] = {title = entry.d, qid = entry.qid, count = 1, t = entry.t} end
    elseif k == "boss" and entry.d then
        scene.bosses[#scene.bosses + 1] = {name = entry.d, where = entry.z}
        scene.events[#scene.events + 1] = {k = "boss", t = entry.t, d = entry.d, z = entry.z, me = entry.me, them = entry.them, n = entry.n,
            cost = entry.cost}
    elseif k == "dungeon" then
        local name = entry.d or entry.z
        local seen = false
        for _, d in ipairs(scene.dungeons) do if d == name then seen = true end end
        if name and not seen then
            scene.dungeons[#scene.dungeons + 1] = name
            scene.events[#scene.events + 1] = {k = "dungeon", t = entry.t, d = name, r = entry.r, tr = entry.tr}
        end
    elseif k == "level" then
        scene.levels[#scene.levels + 1] = tonumber(entry.d) or entry.d
        scene.events[#scene.events + 1] = {k = "level", t = entry.t, d = entry.d}
    elseif k == "mylevel" then
        scene.events[#scene.events + 1] = {k = "mylevel", t = entry.t, d = entry.d}
    elseif k == "campfire" then
        if not scene.campfire then scene.events[#scene.events + 1] = {k = "campfire", t = entry.t, z = entry.z} end
        scene.campfire = true
    elseif k == "voyage" and entry.d then
        scene.events[#scene.events + 1] = {k = "voyage", t = entry.t, d = entry.d, from = entry.from, to = entry.to}
    elseif k == "town" and entry.d then
        scene.events[#scene.events + 1] = {k = "town", t = entry.t, d = entry.d}
    elseif k == "first" and entry.d then
        scene.events[#scene.events + 1] = {k = "first", t = entry.t, d = entry.d, z = entry.z, u = entry.u, n = entry.n, c = entry.c, sz = entry.sz,
            interaction = entry.interaction}
    elseif (k == "sleep" or k == "swim" or k == "nightflight") then
        scene.events[#scene.events + 1] = {k = k, t = entry.t, d = entry.d}
    elseif k == "pdeath" and entry.n then
        scene.events[#scene.events + 1] = {k = "pdeath", t = entry.t, n = entry.n, boss = entry.boss}
    elseif (k == "guild" or k == "home" or k == "bg" or k == "hearth") and (entry.d or k == "hearth") then
        scene.events[#scene.events + 1] = {k = k, t = entry.t, d = entry.d,
            -- (a battleground match's end: result, length, score line, marks, the most blows, listed people)
            r = entry.r, dur = entry.dur, kb = entry.kb, hk = entry.hk, dt = entry.dt, hon = entry.hon, m = entry.m, top = entry.top, c = entry.c}
    elseif k == "craft" and entry.d then
        scene.craft = scene.craft or {}
        local line = scene.craft[entry.d] or {count = 0, made = {}}
        scene.craft[entry.d] = line
        line.count = line.count + (tonumber(entry.c) or 0)
        for _, name in ipairs(type(entry.m) == "table" and entry.m or {}) do
            if #line.made < 3 then line.made[#line.made + 1] = name end
        end
    elseif k == "gather" and entry.d then
        scene.gather = scene.gather or {}
        scene.gather[entry.d] = (scene.gather[entry.d] or 0) + (tonumber(entry.c) or 1)
        if entry.sz then scene.gatherPlace = scene.gatherPlace or {}; scene.gatherPlace[entry.d] = scene.gatherPlace[entry.d] or entry.sz end
        -- what was gathered, by name (most first; up to three)
        if type(entry.m) == "table" then
            scene.gatherNames = scene.gatherNames or {}
            local names = scene.gatherNames[entry.d] or {}
            scene.gatherNames[entry.d] = names
            for _, name in ipairs(entry.m) do
                local have = false
                for _, n in ipairs(names) do if n == name then have = true end end
                if not have and #names < 3 then names[#names + 1] = name end
            end
        end
    elseif k == "cave" and entry.d then
        scene.events[#scene.events + 1] = {k = "cave", t = entry.t, d = entry.d}
    -- More moments (JournalSelf.lua, "Record more moments").
    elseif k == "read" and entry.d then
        scene.events[#scene.events + 1] = {k = "read", t = entry.t, d = entry.d, m = entry.m}
    elseif k == "explore" and entry.d then
        scene.explored = scene.explored or {}
        local known = false
        for _, name in ipairs(scene.explored) do if name == entry.d then known = true end end
        if not known then
            scene.explored[#scene.explored + 1] = entry.d
            scene.events[#scene.events + 1] = {k = "explore", t = entry.t, d = entry.d}
        end
    elseif (k == "taxi" or k == "rep" or k == "skill" or k == "duel" or k == "rarekill" or k == "rank") and entry.d then
        scene.events[#scene.events + 1] = {k = k, t = entry.t, d = entry.d, s = entry.s, c = entry.c, w = entry.w, fled = entry.fled, sz = entry.sz,
            n = k == "rank" and tonumber(entry.n) or nil}
    elseif k == "learn" then
        scene.events[#scene.events + 1] = {k = "learn", t = entry.t, c = tonumber(entry.c) or 0, m = type(entry.m) == "table" and entry.m or {}}
    elseif k == "hk" then
        local n = tonumber(entry.c) or 1
        if not scene.hk then scene.events[#scene.events + 1] = {k = "hk", t = entry.t} end
        scene.hk = (scene.hk or 0) + n
    elseif k == "death" or k == "wipe" or k == "rez" or k == "rest" or k == "close" then
        scene.events[#scene.events + 1] = {k = k, t = entry.t, d = entry.d, z = entry.z, w = entry.w, env = entry.env, boss = entry.boss,
            by = entry.by, a = entry.a, sz = entry.sz, pr = entry.pr, pc = entry.pc, walk = entry.walk}
    end
end

-- Days (oldest first), each with its scenes in order.
function A.JournalBook(person)
    local entries = {}
    if person.met then
        entries[#entries + 1] = {k = "met", t = person.met, z = person.metZone,
            how = person.metHow == "campfire" and "campfire" or "group", synthetic = true}
    elseif person.added then
        entries[#entries + 1] = {k = "added", t = person.added, synthetic = true}
    end
    for _, entry in ipairs(type(person.journal) == "table" and person.journal or {}) do entries[#entries + 1] = entry end
    local order = {}
    for index, entry in ipairs(entries) do order[entry] = index end
    table.sort(entries, function(a, b)
        if (a.t or 0) ~= (b.t or 0) then return (a.t or 0) < (b.t or 0) end
        return order[a] < order[b]
    end)
    local now = time and time() or 0
    -- Outings, merged when they follow each other in the same place.
    local outings, last = {}, nil
    local withs = {}
    for _, entry in ipairs(entries) do
        if entry.k == "with" then withs[#withs + 1] = entry end
        if entry.k == "group" or entry.k == "play" then
            local stop = entry.e or math.max(entry.t or 0, now)
            if last and last.zone == entry.z and (entry.t or 0) - last.e <= MERGE_GAP then
                last.e = math.max(last.e, stop)
                last.open = entry.e == nil
                last.entries[#last.entries + 1] = entry
            else
                last = NewScene("outing", entry.t or 0)
                last.zone, last.e, last.open = entry.z, stop, entry.e == nil
                last.entries[1] = entry
                outings[#outings + 1] = last
            end
        end
    end
    -- Your own journal: who of your list was with you, stretch by stretch
    -- (a companion for at least five minutes of it).
    for _, w in ipairs(withs) do
        local wEnd = w.e or now
        for _, outing in ipairs(outings) do
            local overlap = math.min(wEnd, outing.e) - math.max(w.t or 0, outing.t)
            if overlap >= 300 and w.n then
                outing.with = outing.with or {}
                local name = (w.n:gsub("%-.*$", ""))
                local known
                for _, other in ipairs(outing.with) do if other.name == name then known = other end end
                if known then known.seconds = known.seconds + overlap
                else outing.with[#outing.with + 1] = {name = name, key = w.d, seconds = overlap} end
            end
        end
    end
    -- Everything else goes into the outing it happened in, or is a moment.
    local scenes = {}
    for _, outing in ipairs(outings) do scenes[#scenes + 1] = outing end
    local lastMoment
    for _, entry in ipairs(entries) do
        if entry.k ~= "group" and entry.k ~= "play" and entry.k ~= "with" then
            -- The outing it happened in: one that holds its time (and its zone, when
            -- two touch); failing that, one within a minute of it. A companion's death
            -- a minute before a hearthstone belongs where it happened, not where you landed.
            local home, loose
            for i = #outings, 1, -1 do
                local o = outings[i]
                local t = entry.t or 0
                if t >= o.t and t <= o.e then
                    if not home or (entry.z and o.zone == entry.z and home.zone ~= entry.z) then home = o end
                elseif not loose and t >= o.t - 60 and t <= o.e + 60 then loose = o end
            end
            home = home or loose
            local own = entry.k == "custom" or entry.k == "met" or entry.k == "added" or entry.k == "seen"
            if home and not own then
                Add(home, entry)
                lastMoment = nil
            else
                -- Moments of the same kind in a row read as one (quests, bosses, levels).
                local mergeable = entry.k == "quest" or entry.k == "boss" or entry.k == "level"
                if mergeable and lastMoment and lastMoment.kind == entry.k and DayKey(lastMoment.t) == DayKey(entry.t) then
                    Add(lastMoment, entry)
                else
                    local scene = NewScene(entry.k, entry.t or 0)
                    scene.zone, scene.home = entry.z, home
                    scene.text, scene.count, scene.how = entry.d, entry.c, entry.how
                    if entry.synthetic then scene.synthetic = true else Add(scene, entry) end
                    if not (entry.k == "quest" or entry.k == "boss" or entry.k == "level" or entry.k == "campfire" or entry.k == "dungeon") then
                        scene.entries = entry.synthetic and {} or {entry}
                    end
                    scenes[#scenes + 1] = scene
                    lastMoment = mergeable and scene or nil
                end
            end
        end
    end
    local sceneOrder = {}
    for i, scene in ipairs(scenes) do sceneOrder[scene] = i end
    table.sort(scenes, function(a, b)
        if a.t ~= b.t then return a.t < b.t end
        return sceneOrder[a] < sceneOrder[b]
    end)
    -- Days: a continuing outing (and what happened inside it) stays on its chain's day.
    local days, byKey, previousOuting = {}, {}, nil
    for _, scene in ipairs(scenes) do
        if scene.kind == "outing" then
            if previousOuting and scene.t - previousOuting.e <= CONTINUE_GAP then
                scene.continues = previousOuting
                scene.dayT = previousOuting.dayT
            else
                scene.dayT = scene.t
            end
            scene.gap = previousOuting and (scene.t - previousOuting.e) or nil
            scene.previous = previousOuting
            previousOuting = scene
        else
            scene.dayT = scene.home and scene.home.dayT or scene.t
        end
        local key = DayKey(scene.dayT)
        local day = byKey[key]
        if not day then
            local eve = Evening(scene.dayT)
            day = {key = key, t = scene.dayT, scenes = {},
                weekday = date and date("%A", eve) or "", dayNumber = tonumber(date and date("%d", eve) or 0),
                month = date and date("%B", eve) or "", year = date and date("%Y", eve) or "",
                title = date and date("%A, %d %B %Y", eve) or key}
            day.dayNumber = day.dayNumber or 0
            byKey[key] = day
            days[#days + 1] = day
        end
        day.scenes[#day.scenes + 1] = scene
    end
    for _, day in ipairs(days) do
        local seenZones = {}
        for _, scene in ipairs(day.scenes) do
            if scene.kind == "outing" then
                scene.again = seenZones[scene.zone or ""] and true or nil
                seenZones[scene.zone or ""] = true
            end
        end
    end
    return days
end

-- Islands take "on", not "in" ("on Zephras Isle", "on the Echo Isles"): applied to
-- finished sentences, whatever pool they came from.
local ISLANDS = {"Zephras Isle", "Echo Isles", "Fenris Isle", "Jaguero Isle", "Alcaz Island", "Theramore Isle", "Darkspear Islands", "Bloodmyst Isle"}
function A.JournalIslands(text)
    if type(text) ~= "string" or not text:find("Isl", 1, true) then return text end
    for _, island in ipairs(ISLANDS) do
        for _, form in ipairs({"the {p:" .. island .. "}", "{p:" .. island .. "}"}) do
            local escaped = form:gsub("([%(%)%.%+%-%*%?%[%]%^%$])", "%%%1")
            text = text:gsub("%f[%a]In (" .. escaped .. ")", "On %1"):gsub("%f[%a]in (" .. escaped .. ")", "on %1")
        end
    end
    return text
end

-- "In <place>, " in front of a sentence that does not open on a place (both storytellers, when
-- the work moved). The sentence's first word goes to lower case unless it is a name ("I", a
-- person, a place): "In the Barrens, Whatever Sputtervalve..." kept a capital it should not
-- have. A sentence that opens on speech ("Finally, said Lydon, ...", "Well done, Kryten said")
-- takes no prefix at all: nil, and the caller says the place on its own (2026-11-06).
-- corpus (optional): other prose of the scene; a word seen there in lower case is a common word.
local LEAD_LOWER = {}
for word in ([[The A An It Its Our Your My His Her Their They We You He She This That These Those There Here Other Others
    Another Some Most Many Few Every Each All No None Nothing Something Someone Somebody Anyone Everyone Whatever Whoever
    Whichever Whether When While Where Once Only Even Still Finally Soon Later Then Now So Yet But And Or If Though Although
    Since Until Because As At In On Before After With Without From Beyond Within Inside Word News Reports Seeking One Two Three
    Four Five Six Both Half Several Enough More Fewer Less Such What Which Who Whose]]):gmatch("%S+") do
    LEAD_LOWER[word] = true
end
function A.JournalSpeechLead(line)
    if type(line) ~= "string" then return false end
    local plain = line:gsub("{%a:([^}]*)}", "%1")
    if plain:match("^[\"']") then return true end
    local head = plain:match("^[^%.%?]*") or plain
    local rest = head:match("^[^,!]+[,!]%s+(.*)$")
    if not rest then return false end
    rest = rest:lower()
    for _, shape in ipairs({"^said ", "^asked ", "^%S+ said", "^%S+ %S+ said", "^%S+ asked", "^%S+ %S+ asked"}) do
        if rest:match(shape) then return true end
    end
    return false
end
function A.JournalPlaceLead(place, line, corpus)
    if type(line) ~= "string" or line == "" or not place then return nil end
    if A.JournalSpeechLead(line) then return nil end
    local prefix = "In " .. place .. ", "
    local word, tail = line:match("^(%a+)(.*)$")
    -- (a marked lead, "{n:Dalar} ...", a capital run, "I": as written)
    if not word or word == "I" or word:match("^%u%u") or word:lower() == word then return prefix .. line end
    local low = word:lower()
    local lower = LEAD_LOWER[word] or (#word >= 6 and word:match("ly$") ~= nil)
    if not lower and corpus then
        lower = (corpus:gsub("{%a:([^}]*)}", "%1")):find("%f[%a]" .. low .. "%f[%A]") ~= nil
    end
    -- (a place or a dungeon of that name keeps its capital)
    local L = A.Lore
    if lower and not LEAD_LOWER[word] and L and ((L.Zone and L.Zone(word)) or (L.Dungeon and L.Dungeon(word))) then lower = false end
    return prefix .. (lower and low or word) .. tail
end

-- Everything: one paragraph per scene -------------------------------------------
local function QuestList(scene)
    local titles = {}
    for _, quest in ipairs(scene.quests) do
        titles[#titles + 1] = Q(quest.title) .. (quest.count > 1 and (" (" .. Times(quest.count) .. ")") or "")
    end
    return List(titles)
end
-- Simple mode stays plain, with a little variety: each scene picks its words
-- from its own start time, so a page reads the same every time it is opened.
local function SceneSeed(scene, slot) return tostring(math.floor(tonumber(scene.t) or 0)) .. slot end
local function QuestSentence(scene, v, together)
    if scene.questCount == 0 then return nil end
    local seed = SceneSeed(scene, "quests")
    if scene.questCount == 1 then
        return Pick(seed, {
            (together and ("Together " .. v.you) or v.You) .. " completed " .. QuestList(scene) .. ".",
            v.You .. " turned in " .. QuestList(scene) .. ".",
            v.You .. " finished " .. QuestList(scene) .. ".",
        })
    end
    local count = Words(scene.questCount)
    return Pick(seed, {
        v.You .. " completed " .. count .. " quests" .. (together and " together" or "") .. ": " .. QuestList(scene) .. ".",
        v.You .. " turned in " .. count .. " quests: " .. QuestList(scene) .. ".",
        v.You .. " finished " .. count .. " quests: " .. QuestList(scene) .. ".",
    })
end
-- Deaths, lost fights, rescues and rests, plainly.
local function Cap(text) return (text:gsub("^%l", string.upper)) end
local DEATHS = {FALLING = "fell to your death", DROWNING = "drowned", FATIGUE = "swam too far and drowned",
    LAVA = "died in the lava", FIRE = "burned to death", SLIME = "died in the slime"}
-- A close call ("A Kobold Tunneler nearly got me."), in your own journal.
local function CloseText(event)
    local seed = tostring(math.floor(tonumber(event.t) or 0)) .. "close"
    if event.d then
        local article = event.a and (Clean(event.d):match("^[AEIOUaeiou]") and "an " or "a ") or ""
        local foe = article .. P(event.d)
        local cap = (article:gsub("^%l", string.upper)) .. P(event.d)
        return Pick(seed, {cap .. " nearly got me.", cap .. " nearly killed me.", "I barely got away from " .. foe .. "."})
    elseif event.env == "DROWNING" then
        return Pick(seed, {"I nearly drowned.", "I came up for air just in time."})
    elseif event.env == "FALLING" then
        return Pick(seed, {"I almost fell to my death.", "A fall nearly killed me."})
    end
    return "I nearly died."
end
-- A crossing to another continent, plainly.
local function VoyageText(event, seed)
    local to = event.to and P(event.to) or "the other continent"
    seed = seed or tostring(math.floor(tonumber(event.t) or 0))
    if event.d == "zeppelin" then return Pick(seed, {"I took the zeppelin to " .. to .. ".", "I rode the zeppelin across the sea to " .. to .. "."})
    elseif event.d == "boat" then return Pick(seed, {"I took the boat to " .. to .. ".", "I sailed across the sea to " .. to .. "."})
    elseif event.d == "portal" then return "A portal took me to " .. to .. "."
    elseif event.d == "hearth" then return "My hearthstone took me back to " .. to .. "."
    end
    return "I crossed to " .. to .. "."
end
A.JournalVoyageText = VoyageText
-- An unsure first (the journal began after it was possible): the moment, without "first".
-- (places with their article when the own storyteller is loaded: "the Hillsbrad Foothills")
local function PA(name) return ((A.SelfTale and A.SelfTale.Place) or P)(name) end
local UNSURE = {
    tram = function() return "I rode the " .. P("Deeprun Tram") .. " under the mountain." end,
    landmark = function(e) return e.z and ("I came to " .. PA(e.z) .. ".") end,
    raid = function(e) return e.z and ("I went into " .. ((A.SelfTale and A.SelfTale.Place) or P)(e.z) .. " with a great company of adventurers.") end,
    worldboss = function(e) return e.z and ("I was there when " .. PA(e.z) .. " fell.") end,
    pvp = function(e) return "I fought the other side" .. (e.z and (" in " .. PA(e.z)) or "") .. ", and one of them fell." end,
    epic = function(e) return e.z and (Q(e.z) .. " was mine.") end,
    legendary = function(e) return e.z and (Q(e.z) .. " was mine.") end,
    famous = function(e) return e.z and (Q(e.z) .. " was mine at last.") end,
    tier = function(e) return e.z and ("I put on a piece of " .. Q(e.z) .. ".") end,
    setfull = function(e) return e.z and ("I wore the whole of " .. Q(e.z) .. ".") end,
    gold = function(e) return e.c and ("I had " .. (({[1] = "a gold piece", [100] = "a hundred gold", [1000] = "a thousand gold"})[tonumber(e.c)] or "gold") .. " to my name.") end,
    craftepic = function(e) return e.z and ("I made " .. Q(e.z) .. " myself.") end,
}
A.JournalUnsureFirst = function(event) local f = UNSURE[event.d]; return f and f(event) or nil end
-- Class milestones, plainly.
local CLASS_FIRSTS = {felsteed = "I called my felsteed for the first time", dreadsteed = "I called my dreadsteed for the first time",
    warhorse = "I called my warhorse for the first time", charger = "I called my charger for the first time",
    tame = "I learned to tame beasts", pet = "I tamed my first pet", bear = "I learned bear form", aquatic = "I learned aquatic form",
    travel = "I learned travel form", cat = "I learned cat form", ghostwolf = "I learned ghost wolf", defensive = "I learned defensive stance",
    berserker = "I learned berserker stance", poisons = "I learned poisons", voidwalker = "I summoned my first voidwalker",
    succubus = "I summoned my first succubus", felhunter = "I summoned my first felhunter", summon = "I learned the ritual of summoning",
    portal = "I opened my first portal", teleport = "I learned to teleport"}
-- Firsts, in your own journal.
local function FirstText(event, seed)
    if event.d == "notable" and event.n then
        return (event.interaction and "I spoke with " or "I saw ") .. N(event.n)
            .. (event.z and (" in " .. P(event.z)) or "") .. "."
    end
    if event.u then local f = UNSURE[event.d]; return f and f(event) or nil end
    seed = seed or tostring(math.floor(tonumber(event.t) or 0))
    if event.d == "continent" and event.z then
        return Pick(seed, {"It was my first time on " .. P(event.z) .. ".", "I set foot on " .. P(event.z) .. " for the first time."})
    elseif event.d == "landmark" and event.z then
        return "I came to " .. P(event.z) .. " for the first time."
    elseif event.d == "raid" and event.z then
        return "I went into my first raid, " .. P(event.z) .. "."
    elseif event.d == "worldboss" and event.z then
        return "I was there when " .. P(event.z) .. " fell, my first world boss."
    elseif event.d == "pvp" then
        return "I won my first fight against the other side" .. (event.z and (" in " .. P(event.z)) or "") .. "."
    elseif event.d == "epic" and event.z then
        return "My first epic item: " .. Q(event.z) .. "."
    elseif event.d == "legendary" and event.z then
        return "A legendary item was mine: " .. Q(event.z) .. "."
    elseif event.d == "famous" and event.z then
        return Q(event.z) .. " was mine at last."
    elseif event.d == "tier" and event.z then
        return "I put on my first piece of " .. Q(event.z) .. "."
    elseif event.d == "setfull" and event.z then
        return "I wore the whole " .. Q(event.z) .. " for the first time."
    elseif event.d == "mount" then
        return "I rode my own mount for the first time."
    elseif event.d == "epicmount" then
        return "I rode my first epic mount."
    elseif event.d == "gold" and event.c then
        return ({[1] = "My purse held its first gold piece.", [100] = "I had a hundred gold for the first time.", [1000] = "I had a thousand gold for the first time."})[tonumber(event.c)]
    elseif event.d == "talent" then
        return "I had my first talent point to spend."
    elseif event.d == "craftepic" and event.z then
        return "I made " .. Q(event.z) .. ", my first epic."
    elseif event.d == "sunset" and event.z then
        return "I watched the sun go down at " .. P(event.z) .. "."
    elseif event.d == "zeppelin" then
        return Pick(seed, {"It was my first time on a zeppelin.", "I had never ridden a zeppelin before."})
    elseif event.d == "boat" then
        return Pick(seed, {"It was my first time crossing the sea.", "I had never sailed before."})
    end
    if event.d == "tram" then
        return Pick(seed, {"I rode the " .. P("Deeprun Tram") .. " for the first time.", "For the first time, I took the " .. P("Deeprun Tram") .. "."})
    elseif event.d == "flight" then
        return Pick(seed, {"I took my first flight.", "For the first time, I flew."})
    elseif event.d == "zone" and event.z then
        return Pick(seed, {"It was my first time in " .. P(event.z) .. ".", "I had never been to " .. P(event.z) .. " before."})
    elseif event.d == "foeseen" then
        local what = event.n and (((event.n:match("^[AEIOUaeiou]") and "an " or "a ") .. event.n:lower()) .. (event.c and (" " .. event.c:lower()) or "")) or nil
        return "I saw one of the other side for the first time" .. (what and (", " .. what) or "") .. (event.z and (", in " .. P(event.z)) or "") .. "."
    elseif event.d == "battleground" and event.z then
        return "I fought in " .. P(event.z) .. " for the first time."
    elseif event.d == "class" and event.z then
        return CLASS_FIRSTS[event.z] and (CLASS_FIRSTS[event.z] .. ".") or nil
    elseif event.d == "rezother" then
        return event.n and ("For the first time, I brought someone back from death, " .. N(event.n) .. ".") or "For the first time, I brought someone back from death."
    elseif event.d == "rare" and event.z then
        return "My first rare find, " .. Q(event.z) .. "."
    elseif event.d == "snow" and event.z then
        return "I saw snow for the first time, in " .. P(event.z) .. "."
    elseif event.d == "rarebeast" and event.z then
        return "I came across " .. P(event.z) .. ", a rare creature" .. (event.sz and (", in " .. P(event.sz)) or "") .. "."
    elseif event.d == "aucsale" and event.z then
        return "My first sale at the auction house, " .. Q(event.z) .. "."
    end
    return nil
end
-- The standings of the reputation window, as words.
local STANDING_WORDS = {[5] = "friendly", [6] = "honored", [7] = "revered", [8] = "exalted"}
A.JournalStandingWord = function(s) return STANDING_WORDS[tonumber(s) or 0] end
-- Close calls are told now and then, not every time (seeded, so a page stays the same).
local function TellClose(event) return tonumber(tostring(math.floor(tonumber(event.t) or 0)):sub(-2)) % 5 < 3 end
function A.JournalEventText(name, event, v)
    v = v or VOICES.you
    local k = event.k
    if k == "close" then return CloseText(event) end
    if k == "death" then
        if event.w == "you" then
            if event.env and DEATHS[event.env] then
                local verb = DEATHS[event.env]
                if v.I == "I" then verb = verb:gsub("your", "my") end
                return Cap(v.I) .. " " .. verb .. "."
            end
            local foe = event.boss or event.d
            return Cap(v.I) .. (foe and (" fell to " .. P(foe)) or " fell") .. (event.z and (" in " .. P(event.z)) or "") .. "."
        end
        return N(name) .. (event.boss and (" fell before " .. P(event.boss)) or " fell") .. (event.z and not event.boss and (" in " .. P(event.z)) or "") .. "."
    elseif k == "wipe" then
        return "The fight against " .. P(event.d or "the foe") .. " was lost."
    elseif k == "rez" then
        -- (w = "you": your spell brought them back)
        if event.w == "you" then return v.You .. " brought " .. N(name) .. " back from death." end
        return N(event.by or name) .. " brought " .. v.Ime .. " back from death."
    elseif k == "rest" then
        return v.You .. (v.You == "I" and " rested at " or " rested together at ") .. P(event.d or event.z or "an inn") .. "."
    end
    return nil
end

-- The deeds of a scene in the order they happened: "You shared a campfire and
-- ventured into Shadowfang Keep." Their own level-ups are their own sentence.
local function Deeds(scene, name, v, inside)
    local sentences, clauses = {}, {}
    local lastDungeon, exploreSaid
    local function Flush()
        if #clauses > 0 then sentences[#sentences + 1] = v.You .. " " .. List(clauses) .. "." end
        clauses = {}
    end
    local i = 1
    local events = scene.events
    table.sort(events, function(a, b) return (a.t or 0) < (b.t or 0) end)
    while i <= #events do
        local event = events[i]
        local seed = tostring(math.floor(tonumber(event.t) or 0)) .. event.k
        if event.k == "voyage" then
            Flush()
            sentences[#sentences + 1] = VoyageText(event, seed)
        elseif event.k == "first" and FirstText(event, seed) then
            Flush()
            sentences[#sentences + 1] = FirstText(event, seed)
        elseif event.k == "guild" and event.d then
            Flush()
            sentences[#sentences + 1] = "I joined the guild <" .. event.d .. ">."
        elseif event.k == "home" and event.d then
            Flush()
            sentences[#sentences + 1] = "I set my hearthstone in " .. P(event.d) .. "."
        elseif event.k == "bg" and event.d then
            local result = (event.r == "won" and " and won") or (event.r == "lost" and " and lost") or (event.r == "draw" and ", and neither side won") or ""
            clauses[#clauses + 1] = "fought in " .. P(event.d) .. result
        elseif event.k == "swim" and event.d then
            clauses[#clauses + 1] = "swam a long way in " .. P(event.d)
        elseif event.k == "nightflight" then
            clauses[#clauses + 1] = "flew by night"
        elseif event.k == "cave" then
            clauses[#clauses + 1] = Pick(seed, {"went down into ", "went into ", "made my way into "}) .. P(event.d)
        elseif event.k == "read" and event.d then
            local stone = event.m and (event.m == "stone" or event.m == "bronze" or event.m == "marble")
            clauses[#clauses + 1] = (stone and "read the words on " or "read ") .. Q(event.d)
        elseif event.k == "explore" and event.d and not exploreSaid then
            -- (all of the stretch's discoveries in one clause)
            exploreSaid = true
            local names = {}
            for _, area in ipairs(scene.explored or {event.d}) do names[#names + 1] = P(area) end
            clauses[#clauses + 1] = Pick(seed, {"found my way to ", "came upon ", "discovered "}) .. List(names)
        elseif event.k == "taxi" and event.d then
            clauses[#clauses + 1] = "learned the flight path at " .. P(event.d)
        elseif event.k == "learn" and (event.c or 0) > 0 then
            local names = {}
            for _, spell in ipairs(event.m or {}) do names[#names + 1] = spell end
            local what = event.c == 1 and "one spell" or (Words(event.c) .. " spells")
            -- ("among them" only when the names are a part of the count)
            clauses[#clauses + 1] = "learned " .. what .. " from the trainer" .. (#names > 0 and ((event.c > #names and ", among them " or ", ") .. List(names)) or "")
        elseif event.k == "rep" and event.d then
            Flush()
            sentences[#sentences + 1] = "I became " .. (STANDING_WORDS[tonumber(event.s) or 0] or "known") .. " with " .. P(event.d) .. "."
        elseif event.k == "duel" and event.d then
            Flush()
            sentences[#sentences + 1] = event.w == "won" and ("I won a duel against " .. N(event.d) .. ".") or ("I lost a duel to " .. N(event.d) .. ".")
        elseif event.k == "skill" and event.d then
            Flush()
            sentences[#sentences + 1] = "My " .. event.d .. " reached " .. tostring(event.c) .. "."
        elseif event.k == "rank" and event.d then
            Flush()
            sentences[#sentences + 1] = "I reached the rank of " .. event.d .. "."
        elseif event.k == "rarekill" and event.d then
            Flush()
            sentences[#sentences + 1] = "I killed " .. P(event.d) .. ", a rare creature" .. (event.sz and (", in " .. PA(event.sz)) or "") .. "."
        elseif event.k == "hk" and scene.hk then
            local n = scene.hk
            clauses[#clauses + 1] = "killed " .. (n == 1 and "one" or Words(n)) .. " of the other side"
        elseif event.k == "campfire" then
            clauses[#clauses + 1] = v.You == "I" and Pick(seed, {"sat by a campfire", "stopped at a campfire", "rested by a campfire"})
                or Pick(seed, {"shared a campfire", "sat by a campfire", "stopped at a campfire"})
        elseif event.k == "dungeon" then
            -- (a stretch spent inside it already says so)
            local as = event.r and (" as the " .. event.r:gsub("^damage$", "damage dealer")) or ""
            if event.d ~= inside then clauses[#clauses + 1] = Pick(seed, {"ventured into ", "went into ", "headed into "}) .. P(event.d) .. as end
            lastDungeon = event.d
        elseif event.k == "boss" then
            local names = {P(event.d)}
            local where = event.z
            while events[i + 1] and events[i + 1].k == "boss" and events[i + 1].z == where do
                i = i + 1
                names[#names + 1] = P(events[i].d)
            end
            clauses[#clauses + 1] = Pick(seed, {"defeated ", "took down ", "defeated "}) .. List(names)
                .. ((where and where ~= lastDungeon) and (" in " .. P(where)) or "")
            -- The meter, plainly (the fight's top damage or healing, when it was you or them).
            local stats = events[i]
            local meterSaid = false
            local function Meter(who, subject)
                if meterSaid or type(who) ~= "table" or (stats.n or 0) < 3 then return end
                if who.d == 1 then meterSaid = true; return subject .. " did the most damage in that fight." end
                if who.h == 1 and (who.hs or 0) >= 50 then meterSaid = true; return subject .. " did the most healing in that fight." end
            end
            local line = Meter(stats.me, Cap(v.I)) or Meter(stats.them, N(name))
            if line then Flush(); sentences[#sentences + 1] = line end
        elseif event.k == "level" or event.k == "mylevel" then
            Flush()
            -- Theirs and yours within ten minutes: one sentence ("Dahlia and I both reached level 16.").
            local other = events[i + 1]
            local paired = other and (other.k == "level" or other.k == "mylevel") and other.k ~= event.k
                and (other.t or 0) - (event.t or 0) <= 600
            if paired then
                local theirs = event.k == "level" and event or other
                local yours = event.k == "mylevel" and event or other
                if tostring(theirs.d) == tostring(yours.d) then
                    sentences[#sentences + 1] = (v.I == "I" and (N(name) .. " and I") or ("You and " .. N(name)))
                        .. " both reached level " .. tostring(theirs.d) .. "."
                else
                    sentences[#sentences + 1] = N(name) .. " reached level " .. tostring(theirs.d) .. ", and "
                        .. v.I .. " reached level " .. tostring(yours.d) .. "."
                end
                i = i + 1
            elseif event.k == "level" then
                sentences[#sentences + 1] = N(name) .. Pick(seed, {" reached level ", " made it to level ", " grew to level "})
                    .. tostring(event.d) .. "."
            else
                sentences[#sentences + 1] = Cap(v.I) .. Pick(seed, {" reached level ", " made it to level ", " grew to level "})
                    .. tostring(event.d) .. "."
            end
        elseif event.k == "death" or event.k == "wipe" or event.k == "rez" or event.k == "rest" then
            Flush()
            sentences[#sentences + 1] = A.JournalEventText(name, event, v)
        elseif event.k == "close" and TellClose(event) then
            Flush()
            sentences[#sentences + 1] = CloseText(event)
        end
        i = i + 1
    end
    Flush()
    return sentences
end
-- One scene as a paragraph (Everything). Returns the text, and a lead (the
-- first sentence) for styles that set it apart.
-- Gathering, in plain words: "I mined twelve veins and skinned five beasts."
local GATHER_ORDER = {"mining", "herbs", "skinning", "fishing"}
local function GatherClauses(gather)
    local clauses = {}
    for _, kind in ipairs(GATHER_ORDER) do
        local n = gather and gather[kind]
        if n and n > 0 then
            local count = Words(n)
            clauses[#clauses + 1] = kind == "mining" and ("mined " .. (n == 1 and "a vein" or (count .. " veins")))
                or kind == "herbs" and ("picked " .. (n == 1 and "an herb" or (count .. " herbs")))
                or kind == "fishing" and ("caught " .. (n == 1 and "a fish" or (count .. " fish")))
                or ("skinned " .. (n == 1 and "a beast" or (count .. " beasts")))
        end
    end
    return clauses
end
A.JournalGatherClauses = GatherClauses
-- Crafting: "I made nine things at Tailoring, among them a Linen Cloak."
local function CraftSentences(craft)
    local out = {}
    local names = {}
    for profession in pairs(craft or {}) do names[#names + 1] = profession end
    table.sort(names)
    for _, profession in ipairs(names) do
        local line = craft[profession]
        if line.count > 0 then
            local what = line.count == 1 and "one thing" or (Words(line.count) .. " things")
            local at = profession == "crafting" and "" or (" at " .. profession)
            local made = {}
            for _, name in ipairs(line.made) do made[#made + 1] = Q(name) end
            local among = #made > 0 and ((line.count == 1 and ", " or ", among them ") .. List(made)) or ""
            if line.count == 1 and #made == 1 then out[#out + 1] = "I made " .. made[1] .. at .. "."
            else out[#out + 1] = "I made " .. what .. at .. among .. "." end
        end
    end
    return out
end
A.JournalCraftSentences = CraftSentences

-- Your own journal: a stretch of play, in your words ------------------------------------
local function WithSentence(scene, seed)
    local with = scene.with
    if not with or #with == 0 then return nil end
    local names, most = {}, true
    for _, w in ipairs(with) do
        names[#names + 1] = N(w.name)
        if w.seconds < (scene.e - scene.t) * 0.75 then most = false end
    end
    local who = List(names)
    if most then
        return Pick(seed, {who .. (#names == 1 and " was" or " were") .. " with me.", "I travelled with " .. who .. ".",
            who .. (#names == 1 and " was" or " were") .. " at my side."})
    end
    return who .. " joined me for " .. Exact(with[1].seconds) .. "."
end
local function SelfSceneText(person, scene)
    local v = VOICES.me
    local k = scene.kind
    if k == "outing" then
        local length = scene.e - scene.t
        -- A few minutes passing through, with nothing in them: not worth a line.
        if length < 300 and #scene.entries <= 1 and scene.questCount == 0 and #scene.events == 0 then return nil end
        local place = scene.zone and P(scene.zone) or "the wilds"
        local seed, span = SceneSeed(scene, "self"), Exact(length)
        -- A stretch inside a dungeon: going in is the news.
        local inside
        for _, d in ipairs(scene.dungeons) do if d == scene.zone then inside = d end end
        local lead
        if inside then
            local as
            for _, e in ipairs(scene.events) do if e.k == "dungeon" and e.r then as = " as the " .. (e.r == "damage" and "damage dealer" or e.r) end end
            lead = Pick(seed, {(scene.continues and "Then I went into " or "I went into ") .. place .. (as or "") .. " for " .. span .. ".",
                "I spent " .. span .. " inside " .. place .. (as or "") .. "."})
        elseif scene.continues then
            lead = Pick(seed, {"Then I moved on to " .. place .. " for " .. span .. ".", "After that, I spent " .. span .. " in " .. place .. ".",
                "From there I went on to " .. place .. ", for " .. span .. "."})
        elseif scene.previous and scene.gap and DayKey(scene.previous.dayT) == DayKey(scene.dayT) then
            local part = PartOfDay(scene.t)
            local when = PartOfDay(scene.previous.e) == part and ("Later that " .. part) or ("That " .. part)
            lead = scene.again and Pick(seed, {when .. ", I was back in " .. place .. " for " .. span .. ".",
                    when .. ", I returned to " .. place .. " for " .. span .. "."})
                or Pick(seed, {when .. ", I spent " .. span .. " in " .. place .. ".", when .. ", I was in " .. place .. " for " .. span .. "."})
        else
            lead = Pick(seed, {"I spent " .. span .. " in " .. place .. ".", "In " .. place .. ", I spent " .. span .. ".",
                "I was in " .. place .. " for " .. span .. "."})
        end
        if scene.open then lead = lead:gsub("%.$", " so far.") end
        local rest = {}
        local with = WithSentence(scene, SceneSeed(scene, "with"))
        if with then rest[#rest + 1] = with end
        for _, sentence in ipairs(Deeds(scene, person.name, v, inside)) do rest[#rest + 1] = sentence end
        local gather = GatherClauses(scene.gather)
        if #gather > 0 then rest[#rest + 1] = "I " .. List(gather) .. "." end
        for _, sentence in ipairs(CraftSentences(scene.craft)) do rest[#rest + 1] = sentence end
        local quests = QuestSentence(scene, v, false)
        if quests then rest[#rest + 1] = quests end
        return A.JournalIslands(lead .. (#rest > 0 and (" " .. table.concat(rest, " ")) or "")), A.JournalIslands(lead)
    elseif k == "quest" then
        return QuestSentence(scene, v, false)
    elseif k == "boss" then
        local names = {}
        for _, boss in ipairs(scene.bosses) do names[#names + 1] = P(boss.name) end
        return "I defeated " .. List(names) .. (scene.zone and (" in " .. P(scene.zone)) or "") .. "."
    elseif k == "mylevel" then
        return "I reached level " .. tostring(scene.text) .. "."
    elseif k == "campfire" then
        return "I sat by a campfire" .. (scene.zone and (" in " .. P(scene.zone)) or "") .. "."
    elseif k == "dungeon" then
        return "I went into " .. P(scene.text or scene.zone or "a dungeon") .. "."
    elseif k == "custom" then
        return scene.text
    end
    local sentences = Deeds(scene, person.name, v)
    return #sentences > 0 and table.concat(sentences, " ") or nil
end
function A.JournalSceneText(person, scene, voice)
    if person.self then return SelfSceneText(person, scene) end
    local v = VOICES[voice or "you"] or VOICES.you
    local name = FirstName(person)
    local k = scene.kind
    if k == "outing" then
        local place = scene.zone and P(scene.zone) or "the wilds"
        local length = scene.e - scene.t
        local lead
        local seed, span = SceneSeed(scene, "lead"), Exact(length)
        if scene.continues then
            lead = Pick(seed, {
                "Then, in " .. place .. ", " .. v.you .. " spent another " .. span .. " together.",
                "Then " .. v.you .. " moved on to " .. place .. " for another " .. span .. ".",
                "After that, " .. v.you .. " spent " .. span .. " more in " .. place .. ".",
            })
        elseif scene.previous and scene.gap and DayKey(scene.previous.dayT) == DayKey(scene.dayT) then
            local part = PartOfDay(scene.t)
            local when = PartOfDay(scene.previous.e) == part and ("Later that " .. part) or ("That " .. part)
            lead = Pick(seed, {
                when .. ", in " .. place .. (scene.again and " again" or "") .. ", " .. v.you .. " travelled together for " .. span .. ".",
                when .. ", " .. v.you .. " grouped up again in " .. place .. " for " .. span .. ".",
                when .. ", " .. v.you .. " spent " .. span .. " together in " .. place .. (scene.again and " once more" or "") .. ".",
            })
        else
            lead = Pick(seed, {
                "In " .. place .. ", " .. v.you .. " travelled together for " .. span .. ".",
                v.You .. " spent " .. span .. " together in " .. place .. ".",
                v.You .. " grouped up in " .. place .. " for " .. span .. ".",
            })
        end
        if scene.open then lead = lead:gsub("%.$", " so far.") end
        local rest = Deeds(scene, name, v)
        -- (the opening says "together", or "grouped up": the quests need not)
        local quests = QuestSentence(scene, v, false)
        if quests then rest[#rest + 1] = quests end
        return lead .. (#rest > 0 and (" " .. table.concat(rest, " ")) or ""), lead
    elseif k == "quest" then
        return QuestSentence(scene, v, true)
    elseif k == "boss" then
        local names = {}
        for _, boss in ipairs(scene.bosses) do names[#names + 1] = P(boss.name) end
        return "Together " .. v.you .. " defeated " .. List(names) .. (scene.zone and (" in " .. P(scene.zone)) or "") .. "."
    elseif k == "level" then
        return N(name) .. " had grown to level " .. tostring(scene.levels[#scene.levels] or scene.text) .. "."
    elseif k == "mylevel" then
        return Cap(v.I) .. " reached level " .. tostring(scene.text) .. "."
    elseif k == "campfire" then
        return v.You .. " shared a campfire with " .. N(name) .. (scene.zone and (" in " .. P(scene.zone)) or "") .. "."
    elseif k == "dungeon" then
        return v.You .. " ventured into " .. P(scene.text or scene.zone or "a dungeon") .. " side by side."
    elseif k == "seen" then
        local count = tonumber(scene.count) or 1
        return v.You .. " crossed paths with " .. N(name) .. (scene.zone and (" in " .. P(scene.zone)) or "")
            .. (count > 1 and (", " .. Times(count)) or "") .. "."
    elseif k == "met" then
        local how = scene.how == "campfire" and " by a campfire" or scene.how == "group" and " while grouped" or ""
        return v.You == "We" and ("I first met " .. N(name) .. (scene.zone and (" in " .. P(scene.zone)) or "") .. how .. ".")
            or ("You first met " .. N(name) .. (scene.zone and (" in " .. P(scene.zone)) or "") .. how .. ".")
    elseif k == "added" then
        return (v.You == "We" and "I wrote " or "You wrote ") .. N(name) .. " into this journal."
    elseif k == "custom" then
        return scene.text or ""
    elseif k == "death" or k == "wipe" or k == "rez" or k == "rest" then
        local event = scene.events[1] or {k = k, d = scene.text, z = scene.zone}
        return A.JournalEventText(name, event, v)
    end
    return nil
end

-- Highlights: one paragraph per day ---------------------------------------------
-- The day's facts, then a few sentences from the most notable: how you met,
-- dungeons and the foes you defeated there, their level, a campfire, and how
-- long you travelled and how many quests you saw through. Lines you wrote
-- yourself are kept as they are (returned separately).
local function SelfDayHighlights(person, day)
    local seed = day.key .. "self"
    local bgs, bgOrder, bgFirst = {}, {}, {} -- battleground matches by name: count, wins, losses; the first ever
    local minutes, zones, zoneSeen, quests, dungeons, bosses, levels, deaths, with, withSeen, quotes = 0, {}, {}, 0, {}, {}, {}, {}, {}, {}, {}
    local closes, caves, gather, craft, firsts = {}, {}, {}, {}, {}
    for _, scene in ipairs(day.scenes) do
        if scene.kind == "outing" then
            minutes = minutes + (scene.e - scene.t)
            if scene.zone and not zoneSeen[scene.zone] and scene.e - scene.t >= 300 then zoneSeen[scene.zone] = true; zones[#zones + 1] = scene.zone end
            for _, w in ipairs(scene.with or {}) do
                if not withSeen[w.name] then withSeen[w.name] = {name = w.name, seconds = 0}; with[#with + 1] = withSeen[w.name] end
                withSeen[w.name].seconds = withSeen[w.name].seconds + w.seconds
            end
        elseif scene.kind == "custom" and scene.text then
            quotes[#quotes + 1] = {text = scene.text, entries = scene.entries}
        end
        quests = quests + scene.questCount
        for kind, n in pairs(scene.gather or {}) do gather[kind] = (gather[kind] or 0) + n end
        for profession, line in pairs(scene.craft or {}) do
            local total = craft[profession] or {count = 0, made = {}}
            craft[profession] = total
            total.count = total.count + line.count
            for _, name in ipairs(line.made) do if #total.made < 3 then total.made[#total.made + 1] = name end end
        end
        for _, d in ipairs(scene.dungeons) do dungeons[#dungeons + 1] = P(d) end
        for _, b in ipairs(scene.bosses) do bosses[#bosses + 1] = P(b.name) end
        for _, event in ipairs(scene.events) do
            if event.k == "mylevel" then levels[#levels + 1] = tonumber(event.d) end
            if event.k == "death" and event.w == "you" then deaths[#deaths + 1] = event end
            if event.k == "close" and TellClose(event) then closes[#closes + 1] = event end
            if event.k == "cave" then caves[#caves + 1] = P(event.d) end
            if event.k == "first" and FirstText(event) then firsts[#firsts + 1] = FirstText(event) end
            if event.k == "voyage" then firsts[#firsts + 1] = VoyageText(event) end
            -- (more moments: the ones worth a short day's line)
            if event.k == "duel" and event.d then
                firsts[#firsts + 1] = event.w == "won" and ("I won a duel against " .. N(event.d) .. ".") or ("I lost a duel to " .. N(event.d) .. ".")
            elseif event.k == "rep" and event.d and (tonumber(event.s) or 0) >= 6 then
                firsts[#firsts + 1] = "I became " .. (STANDING_WORDS[tonumber(event.s)] or "known") .. " with " .. P(event.d) .. "."
            elseif event.k == "skill" and event.d and tonumber(event.c) == 300 then
                firsts[#firsts + 1] = "My " .. event.d .. " reached 300."
            elseif event.k == "rank" and event.d then
                firsts[#firsts + 1] = "I reached the rank of " .. event.d .. "."
            elseif event.k == "rarekill" and event.d then
                firsts[#firsts + 1] = "I killed " .. P(event.d) .. ", a rare creature."
            elseif event.k == "bg" and event.d then
                local tally = bgs[event.d]
                if not tally then tally = {n = 0, won = 0, lost = 0}; bgs[event.d] = tally; bgOrder[#bgOrder + 1] = event.d end
                tally.n = tally.n + 1
                if event.r == "won" then tally.won = tally.won + 1 elseif event.r == "lost" then tally.lost = tally.lost + 1 end
            end
            -- (the first battleground ever and its matches: one sentence, below)
            if event.k == "first" and event.d == "battleground" and event.z then bgFirst[event.z] = FirstText(event) end
        end
        if scene.explored and #scene.explored >= 3 then
            firsts[#firsts + 1] = "I discovered " .. Words(#scene.explored) .. " new places" .. (scene.zone and (" in " .. P(scene.zone)) or "") .. "."
        end
    end
    local out = {}
    local function Say(text) out[#out + 1] = text end
    if minutes >= 60 then
        local where = #zones > 3 and (" from " .. P(zones[1]) .. " to " .. P(zones[#zones]))
            or (#zones > 0 and (" in " .. List((function() local t = {} for _, z in ipairs(zones) do t[#t + 1] = P(z) end return t end)())) or "")
        local done = quests >= 2 and (", and finished " .. Words(quests) .. " quests") or quests == 1 and ", and finished one quest" or ""
        local withDone = quests >= 2 and (", with " .. Words(quests) .. " quests done") or quests == 1 and ", with one quest done" or ""
        Say(Pick(seed, {"I spent " .. About(minutes) .. where .. done .. ".",
            (About(minutes):gsub("^%l", string.upper)) .. where .. withDone .. "."}))
    end
    if #with > 0 then
        local names = {}
        for _, w in ipairs(with) do names[#names + 1] = N(w.name) end
        local most = with[1].seconds >= minutes * 0.6
        Say(most and (List(names) .. (#names == 1 and " was" or " were") .. " with me for most of it.")
            or (List(names) .. " joined me for " .. About(with[1].seconds) .. "."))
    end
    for _, first in ipairs(firsts) do
        local merged = false
        for _, text in pairs(bgFirst) do if text == first then merged = true end end
        if not merged then Say(first) end
    end
    for _, name in ipairs(bgOrder) do
        local tally = bgs[name]
        local result = ""
        if tally.won + tally.lost == tally.n and tally.n > 0 then
            if tally.n == 1 then result = tally.won == 1 and " and won" or " and lost"
            elseif tally.won == tally.n then result = " and won every one"
            elseif tally.won == 0 then result = " and lost every one"
            else result = " and won " .. Words(tally.won) end
        end
        local count = tally.n == 2 and " twice" or tally.n > 2 and (" " .. Words(tally.n) .. " times") or ""
        if bgFirst[name] then
            Say("I fought in " .. P(name) .. " for the first time" .. (tally.n >= 2 and (", " .. Words(tally.n) .. " matches,") or "") .. result .. ".")
        else
            Say("I fought in " .. P(name) .. count .. result .. ".")
        end
    end
    if #dungeons > 0 then Say("I went into " .. List(dungeons) .. ".") end
    if #caves > 0 then Say("I went down into " .. List(caves) .. ".") end
    local gathered = GatherClauses(gather)
    if #gathered > 0 then Say("I " .. List(gathered) .. ".") end
    for _, sentence in ipairs(CraftSentences(craft)) do Say(sentence) end
    if #bosses > 0 then
        Say(#bosses <= 4 and ("I defeated " .. List(bosses) .. ".") or ("I defeated " .. bosses[#bosses] .. " and " .. Words(#bosses - 1) .. " others."))
    end
    if #levels > 0 then
        table.sort(levels)
        Say(#levels == 1 and ("I reached level " .. levels[1] .. ".") or ("I went from level " .. (levels[1] - 1) .. " to " .. levels[#levels] .. "."))
    end
    if #deaths == 1 then
        Say(A.JournalEventText(person.name, deaths[1], VOICES.me))
    elseif #deaths > 1 then
        Say("I died " .. Words(#deaths) .. " times.")
    elseif #closes > 0 then
        Say(CloseText(closes[1]))
    end
    return A.JournalIslands(table.concat(out, " ")), quotes
end
function A.JournalDayHighlights(person, day, voice)
    if person.self then return SelfDayHighlights(person, day) end
    local v = VOICES[voice or "you"] or VOICES.you
    local name = FirstName(person)
    local seed = day.key .. (person.name or "")
    local facts = {together = 0, zones = {}, dungeons = {}, bossesIn = {}, quests = 0, questTitles = {}, levels = {}, myLevels = {},
        campfire = nil, met = nil, added = false, seen = 0, seenZone = nil, quotes = {}, firstT = nil, lateT = nil}
    local function Zone(z)
        if not z then return end
        for _, known in ipairs(facts.zones) do if known == z then return end end
        facts.zones[#facts.zones + 1] = z
    end
    for _, scene in ipairs(day.scenes) do
        if scene.kind == "outing" then
            facts.together = facts.together + (scene.e - scene.t)
            Zone(scene.zone)
        end
        if scene.kind == "met" then facts.met = scene end
        if scene.kind == "added" then facts.added = true end
        if scene.kind == "seen" then facts.seen = facts.seen + (tonumber(scene.count) or 1); facts.seenZone = facts.seenZone or scene.zone end
        if scene.kind == "custom" and scene.text then facts.quotes[#facts.quotes + 1] = {text = scene.text, entries = scene.entries} end
        -- Dungeons and foes, with the time they happened (for "that night").
        for _, event in ipairs(scene.events) do
            local where = event.k == "dungeon" and event.d or event.k == "boss" and (event.z or "?") or nil
            if where and not facts.bossesIn[where] then
                facts.dungeons[#facts.dungeons + 1] = {name = where, t = event.t or scene.t}
                facts.bossesIn[where] = {}
            end
            if event.k == "boss" then table.insert(facts.bossesIn[where], event.d) end
        end
        facts.quests = facts.quests + scene.questCount
        for _, quest in ipairs(scene.quests) do facts.questTitles[#facts.questTitles + 1] = quest.title end
        for _, event in ipairs(scene.events) do
            if event.k == "level" then facts.levels[#facts.levels + 1] = {t = event.t, d = event.d} end
            if event.k == "mylevel" then facts.myLevels[#facts.myLevels + 1] = {t = event.t, d = event.d} end
            if event.k == "campfire" then facts.campfireT = facts.campfireT or event.t end
        end
        if scene.kind == "level" and #scene.events == 0 then
            for _, level in ipairs(scene.levels) do facts.levels[#facts.levels + 1] = {t = scene.t, d = level} end
        end
        if scene.campfire or scene.kind == "campfire" then
            facts.campfire = facts.campfire or scene.zone or (scene.events[1] and scene.events[1].z)
            facts.campfireT = facts.campfireT or scene.t
        end
    end
    local sentences = {}
    local function Say(text) if text then sentences[#sentences + 1] = text end end
    -- 1. How it began.
    if facts.met then
        local zone = facts.met.zone and P(facts.met.zone)
        local by = facts.met.how == "campfire" and " by a campfire" or ""
        Say(zone and Pick(seed, {
            "It began in " .. zone .. ", where " .. v.I .. " first met " .. N(name) .. by .. ".",
            "This is where it started: " .. zone .. ", the day " .. v.I .. " first met " .. N(name) .. by .. ".",
        }) or ("It began the day " .. v.I .. " first met " .. N(name) .. by .. "."))
    elseif facts.added then
        Say("This was the day " .. N(name) .. " entered " .. v.your .. " journal.")
    end
    -- 2. The day in one line: time on the road, where, how many quests.
    local where = ""
    if #facts.zones >= 2 then where = ", from " .. P(facts.zones[1]) .. " to " .. P(facts.zones[#facts.zones])
    elseif facts.zones[1] then where = ", in " .. P(facts.zones[1]) end
    local quests = facts.quests >= 2 and (Words(facts.quests) .. " quests seen through")
        or facts.quests == 1 and (Q(facts.questTitles[1]) .. " seen through") or nil
    local feats = #facts.dungeons + (facts.campfire and 1 or 0) + #facts.levels
    if facts.together >= 20 * 60 or (facts.together > 0 and feats == 0) then
        local opener = facts.together >= 2 * 3600 and "A long day on the road: " or (feats > 0 and "On the road together: " or nil)
        if opener then
            Say(opener .. About(facts.together) .. " together" .. where .. (quests and (", with " .. quests) or "") .. ".")
        else
            Say(v.You .. " spent " .. About(facts.together) .. " together" .. where
                .. (facts.quests >= 2 and (", and saw " .. Words(facts.quests) .. " quests through")
                    or facts.quests == 1 and (", and saw " .. Q(facts.questTitles[1]) .. " through") or "") .. ".")
        end
        quests = nil
    end
    -- 3. The feats, in the order they happened.
    local moments = {}
    for _, dungeon in ipairs(facts.dungeons) do moments[#moments + 1] = {k = "dungeon", t = dungeon.t, d = dungeon.name} end
    for _, level in ipairs(facts.levels) do moments[#moments + 1] = {k = "level", t = level.t, d = level.d} end
    for _, level in ipairs(facts.myLevels) do moments[#moments + 1] = {k = "mylevel", t = level.t, d = level.d} end
    if facts.campfire then moments[#moments + 1] = {k = "campfire", t = facts.campfireT or 0, d = facts.campfire} end
    table.sort(moments, function(a, b) return (a.t or 0) < (b.t or 0) end)
    local previousT, previousPart
    local i = 1
    while i <= #moments do
        local m = moments[i]
        local part = PartOfDay(m.t)
        local lead = ""
        if previousT then
            if (m.t or 0) - previousT > 20 * 60 then
                lead = (part == previousPart) and ("Later that " .. part .. ", ") or ((part == "night" or part == "evening") and ("That " .. part .. ", ") or "Later, ")
            else
                lead = "Then "
            end
        elseif part == "night" then
            lead = "That night, "
        end
        local function Lead(text) return lead == "" and (text:sub(1, 1):upper() .. text:sub(2)) or (lead .. text) end
        if m.k == "campfire" and not (facts.met and facts.met.how == "campfire") then
            Say(Lead(Pick(seed .. "fire", {
                v.you .. " shared a campfire in " .. P(m.d) .. ".",
                "there was a campfire in " .. P(m.d) .. ", and " .. v.you .. " sat by it together.",
            })))
        elseif m.k == "dungeon" then
            local foes = facts.bossesIn[m.d] or {}
            local text
            if #foes > 0 then
                local named = {}
                for _, foe in ipairs(foes) do named[#named + 1] = P(foe) end
                text = Pick(seed .. m.d, {
                    "in " .. P(m.d) .. ", " .. v.you .. " brought down " .. List(named) .. " together.",
                    "in " .. P(m.d) .. ", " .. v.you .. " stood together against " .. List(named) .. ", and prevailed.",
                })
            else
                text = Pick(seed .. m.d, {
                    v.you .. " ventured into " .. P(m.d) .. " side by side.",
                    v.you .. " went down into " .. P(m.d) .. " together.",
                })
            end
            -- A level reached right after: the same sentence.
            local nextM = moments[i + 1]
            if nextM and nextM.k == "level" and (nextM.t or 0) - (m.t or 0) <= 15 * 60 then
                text = text:gsub("%.$", ", and " .. N(name) .. " grew to level " .. tostring(nextM.d) .. ".")
                i = i + 1
            end
            Say(Lead(text))
        elseif m.k == "level" or m.k == "mylevel" then
            -- Theirs and yours close together: one sentence.
            local other = moments[i + 1]
            if other and (other.k == "level" or other.k == "mylevel") and other.k ~= m.k and (other.t or 0) - (m.t or 0) <= 15 * 60 then
                local theirs = m.k == "level" and m or other
                local yours = m.k == "mylevel" and m or other
                if tostring(theirs.d) == tostring(yours.d) then
                    Say(Lead((v.I == "I" and (N(name) .. " and I") or ("you and " .. N(name))) .. " both reached level " .. tostring(theirs.d) .. "."))
                else
                    Say(Lead(N(name) .. " grew to level " .. tostring(theirs.d) .. ", and " .. v.I .. " to level " .. tostring(yours.d) .. "."))
                end
                i = i + 1
            elseif m.k == "level" then
                Say(Lead(N(name) .. " grew to level " .. tostring(m.d) .. "."))
            else
                Say(Lead(v.I .. " reached level " .. tostring(m.d) .. "."))
            end
        end
        previousT, previousPart = m.t, part
        i = i + 1
    end
    if quests then
        Say(facts.quests == 1 and ("Together " .. v.you .. " saw " .. Q(facts.questTitles[1]) .. " through.")
            or (v.You .. " saw " .. Words(facts.quests) .. " quests through together."))
    end
    if #sentences == 0 and facts.seen > 0 then
        Say(v.Your .. " paths crossed" .. (facts.seenZone and (" in " .. P(facts.seenZone)) or "") .. (facts.seen > 1 and (", " .. Times(facts.seen)) or "") .. ".")
    end
    return table.concat(sentences, " "), facts.quotes
end

-- Short forms (the Margins and Ledger styles) ------------------------------------
-- A scene's deeds as short items {glyph, text}, in the order they happened,
-- quests last: "Shared a campfire", "Shadowfang Keep", "Defeated X and Y",
-- "Dahlia reached level 16", "Six quests: ...".
local MOMENT_GLYPHS = {met = "heart", added = "heart", seen = "person", level = "star", mylevel = "star", campfire = "fire",
    quest = "note", boss = "swords", dungeon = "shield", custom = "note", death = "skull", wipe = "swords", rez = "sun", rest = "moon"}
function A.JournalSceneGlyph(scene) return MOMENT_GLYPHS[scene.kind] or "dot" end
function A.JournalSceneItems(person, scene)
    local name = FirstName(person)
    local items = {}
    local events = scene.events
    table.sort(events, function(a, b) return (a.t or 0) < (b.t or 0) end)
    local i = 1
    while i <= #events do
        local event = events[i]
        if event.k == "cave" then
            items[#items + 1] = {glyph = "shield", text = P(event.d)}
        elseif event.k == "campfire" then
            items[#items + 1] = {glyph = "fire", text = person.self and "Sat by a campfire" or "Shared a campfire"}
        elseif event.k == "dungeon" then
            items[#items + 1] = {glyph = "shield", text = P(event.d)}
        elseif event.k == "boss" then
            local names, where = {P(event.d)}, event.z
            while events[i + 1] and events[i + 1].k == "boss" and events[i + 1].z == where do
                i = i + 1
                names[#names + 1] = P(events[i].d)
            end
            items[#items + 1] = {glyph = "swords", text = "Defeated " .. List(names)}
        elseif event.k == "level" then
            items[#items + 1] = {glyph = "star", text = N(name) .. " reached level " .. tostring(event.d)}
        elseif event.k == "mylevel" then
            items[#items + 1] = {glyph = "star", text = (person.self and "I" or "You") .. " reached level " .. tostring(event.d)}
        elseif event.k == "death" or event.k == "wipe" or event.k == "rez" or event.k == "rest" then
            local glyphs = {death = "skull", wipe = "swords", rez = "sun", rest = "moon"}
            items[#items + 1] = {glyph = glyphs[event.k], text = (A.JournalEventText(name, event):gsub("%.$", ""))}
        elseif event.k == "close" and TellClose(event) then
            items[#items + 1] = {glyph = "skull", text = (CloseText(event):gsub("%.$", ""))}
        elseif event.k == "first" and FirstText(event) then
            items[#items + 1] = {glyph = "sparkle", text = (FirstText(event):gsub("%.$", ""))}
        elseif event.k == "voyage" then
            items[#items + 1] = {glyph = "flag", text = (VoyageText(event):gsub("%.$", ""))}
        elseif event.k == "guild" and event.d then
            items[#items + 1] = {glyph = "flag", text = "Joined <" .. event.d .. ">"}
        elseif event.k == "home" and event.d then
            items[#items + 1] = {glyph = "moon", text = "Hearthstone set in " .. P(event.d)}
        elseif event.k == "bg" and event.d then
            local verb = (event.r == "won" and "Won in ") or (event.r == "lost" and "Lost in ") or "Fought in "
            items[#items + 1] = {glyph = "swords", text = verb .. P(event.d)}
        end
        i = i + 1
    end
    for _, clause in ipairs(person.self and GatherClauses(scene.gather) or {}) do
        items[#items + 1] = {glyph = "leaf", text = (clause:gsub("^%l", string.upper))}
    end
    for _, sentence in ipairs(person.self and CraftSentences(scene.craft) or {}) do
        items[#items + 1] = {glyph = "note", text = (sentence:gsub("%.$", ""))}
    end
    if person.self and scene.with and #scene.with > 0 then
        local names = {}
        for _, w in ipairs(scene.with) do names[#names + 1] = N(w.name) end
        table.insert(items, 1, {glyph = "person", text = "With " .. List(names)})
    end
    if scene.questCount > 0 then
        local count = Words(scene.questCount)
        items[#items + 1] = {glyph = "note", text = count:sub(1, 1):upper() .. count:sub(2)
            .. (scene.questCount == 1 and " quest: " or " quests: ") .. QuestList(scene)}
    end
    return items
end
-- A day in numbers: minutes together, quests, foes, and the first place.
function A.JournalDayTotals(day)
    local totals = {minutes = 0, quests = 0, foes = 0}
    for _, scene in ipairs(day.scenes) do
        if scene.kind == "outing" then
            totals.minutes = totals.minutes + math.floor((scene.e - scene.t) / 60 + 0.5)
            totals.zone = totals.zone or scene.zone
        end
        totals.quests = totals.quests + scene.questCount
        totals.foes = totals.foes + #scene.bosses
    end
    if not totals.zone then
        for _, scene in ipairs(day.scenes) do totals.zone = totals.zone or scene.zone end
    end
    return totals
end

-- Markup to plain text (and to colored text for the window).
function A.JournalPlain(text)
    return (tostring(text or ""):gsub("{[pqn]:([^}]*)}", "%1"))
end
local function Hex(value) return math.floor(math.max(0, math.min(1, value)) * 255 + 0.5) end
-- Companion links use a distinct ink, separate from the red world names.
A.JournalLinkColor = {0.23, 0.22, 0.44}
function A.JournalNameTarget(kind, value)
    if not A.bookLinks then return nil end
    local key = kind == "n" and A.bookLinks[value:lower()]
    if key then return "cjperson:" .. key end
    local qid = kind == "q" and A.bookLoreQuests and A.bookLoreQuests[value]
    local id = A.LoreNoteResolve and A.LoreNoteResolve(kind, value, qid and {qid = qid} or nil)
    return id and ("cjlore:" .. id) or nil
end
function A.JournalTextLink(text, target)
    if not target or text == "" then return text end
    local ink = target:match("^cjperson:") and "3b3870" or "7d1c0a"
    return "|H" .. target .. "|h|cff" .. ink .. text .. "|r|h"
end
function A.JournalPersonLink(text, key)
    return A.JournalTextLink(text, key and ("cjperson:" .. key))
end
function A.JournalColored(text, colors)
    -- (the book: a name of your list is a link to their journal, A.bookLinks)
    text = tostring(text or "")
    if A.bookLinks and A.MarkKnownLore then text = A.MarkKnownLore(text) end
    return (text:gsub("{([pqn]):([^}]*)}", function(kind, value)
        local target = A.JournalNameTarget(kind, value)
        if target then return A.JournalTextLink(value, target) end
        local color = colors and colors[kind]
        local shown = color and string.format("|cff%02x%02x%02x%s|r", Hex(color[1]), Hex(color[2]), Hex(color[3]), value) or value
        return shown
    end))
end

-- The final boss of a dungeon, as a list (a place with wings has one per wing): from
-- Lore's `last` field, or the lord among its bosses when a pack has none (2026-11-06).
function A.DungeonLast(name)
    local L = A.Lore
    if not L or not name then return nil end
    local story = L.DungeonStory and L.DungeonStory(name)
    local info = L.Dungeon and L.Dungeon(name)
    local last = (story and story.last) or (info and info.last)
    if type(last) == "string" then return {last} end
    if type(last) == "table" and #last > 0 then return last end
    return nil
end
