-- Companion Journal: told books kept for the session (1.43.1).
--
-- Telling a whole book takes a fraction of a second (the own book and a companion's run the
-- composer over every chapter), and the book used to tell it again on every open and every
-- redraw. A telling depends only on what is saved (the journal, the cards, the settings), the
-- teller's arguments and, for a journal with an outing still open, the clock. So the told
-- chapters are kept in memory, under a key made of all of that, and told again only when the
-- key changes: a new entry, an edited note, a renamed companion, Retell, another voice or mode
-- or storyteller. Nothing is written to the saved variables.
--
-- The key: the saved variables as text (without the book's own page state, which changes as
-- you read and never reaches a teller), the person, the arguments, and the clock in steps of
-- C.OPEN_STEP seconds while one of the journal's outings is still open (the open day ends
-- "now", so its told text can move with the clock; a closed journal never does).
local _, A = ...
local C = {}
A.TellCache = C

C.ON = true
C.OPEN_STEP = 300
C.MAX = 12                  -- books kept at once (the oldest goes first)
-- (saved settings the tellers never read and the book changes as you read or move it)
C.SKIP = {bookRead = true, bookPins = true, bookSize = true, bookSpread = true, bookWidth = true, bookHeight = true,
    bookMinimapAngle = true, bookMinimap = true, groupPromptPoint = true, bookNotice = true, bookNoticed = true}
C.hits, C.misses = 0, 0

local store, order = {}, {}

-- A value as text: tables by their pairs (an unchanged table walks in the same order; a changed
-- one at worst misses), strings with their length so no two values read the same.
local function Put(buf, v, depth)
    local t = type(v)
    if t == "string" then
        buf[#buf + 1] = "s" .. #v .. ":" .. v
    elseif t == "number" then
        buf[#buf + 1] = "n" .. string.format("%.17g", v)
    elseif t == "boolean" then
        buf[#buf + 1] = v and "T" or "F"
    elseif t == "table" then
        if depth > 16 then buf[#buf + 1] = "^"; return end
        buf[#buf + 1] = "{"
        for k, x in pairs(v) do
            Put(buf, k, depth + 1)
            buf[#buf + 1] = "="
            Put(buf, x, depth + 1)
        end
        buf[#buf + 1] = "}"
    else
        buf[#buf + 1] = "?" .. t
    end
end
C.Put = Put

-- Whether the journal has an outing (or a companion's company) still open: its end is "now".
local OPEN_KINDS = {group = true, play = true, with = true, member = true}
function C.Open(person)
    local journal = person and person.journal
    if type(journal) ~= "table" then return false end
    for _, e in ipairs(journal) do
        if OPEN_KINDS[e.k] and e.e == nil then return true end
    end
    return false
end

-- The key of one telling. `kind` names the teller ("self", "tale", "reader:..."), `args` the
-- arguments it was given after the days.
function C.Key(kind, person, days, args)
    local buf = {kind, ":", tostring(A.Me and A.Me() or ""), ":"}
    -- (the person as the teller sees it: a card read through another character is a view of the
    -- saved card and relation, which the saved variables below already hold, and its key)
    if type(person) == "table" then
        for k, v in pairs(person) do
            if type(v) ~= "table" then Put(buf, k, 1); buf[#buf + 1] = "="; Put(buf, v, 1) end
        end
        local proxyKey = rawget(person, "__key") == nil and person.__key or nil
        if proxyKey then buf[#buf + 1] = "@"; Put(buf, proxyKey, 1) end
        buf[#buf + 1] = person.readOnly and "R" or "W"
        Put(buf, person.retell, 1)
        Put(buf, person.level, 1)
    end
    buf[#buf + 1] = "|"
    Put(buf, args or {}, 1)
    buf[#buf + 1] = "|"
    buf[#buf + 1] = tostring(type(days) == "table" and #days or 0)
    local last = type(days) == "table" and days[#days]
    buf[#buf + 1] = tostring(last and last.key)
    if C.Open(person) then
        local now = time and time() or 0
        buf[#buf + 1] = "|open:" .. math.floor(now / C.OPEN_STEP)
    end
    buf[#buf + 1] = "|"
    local db = A.db
    if type(db) == "table" then
        -- (the settings in a fixed order: a setting saved for the first time moves the others)
        local keys = {}
        for k in pairs(db) do if not C.SKIP[k] then keys[#keys + 1] = k end end
        table.sort(keys, function(x, y) return tostring(x) < tostring(y) end)
        for _, k in ipairs(keys) do Put(buf, k, 1); buf[#buf + 1] = "="; Put(buf, db[k], 1) end
    end
    return table.concat(buf)
end

local function Remember(key, stories)
    if not store[key] then order[#order + 1] = key end
    store[key] = stories
    while #order > C.MAX do
        store[table.remove(order, 1)] = nil
    end
end

-- Told once per key: `tell()` gives the book (a table of chapters by day key), which is kept and
-- handed back on every later call with the same key. The book handed back is shared: read it,
-- never write to it.
function C.Told(kind, person, days, args, tell)
    if not C.ON then return tell() end
    local key = C.Key(kind, person, days, args)
    local stories = store[key]
    if stories then C.hits = C.hits + 1; return stories end
    C.misses = C.misses + 1
    stories = tell()
    -- (a telling that changed the saved variables would never match its key again: keep it only
    -- when the key still holds)
    if type(stories) == "table" and C.Key(kind, person, days, args) == key then Remember(key, stories) end
    return stories
end

-- The own book, as SelfTale.Tell(person, days, brief, retell) tells it.
function C.Self(person, days, brief, retell)
    return C.Told("self", person, days, {brief = brief and true or false, retell = retell or false}, function()
        return A.SelfTale.Tell(person, days, brief, retell)
    end)
end
-- A companion's book, as JournalTale.Tell(person, days, voice, player, brief) tells it.
function C.Tale(person, days, voice, player, brief)
    return C.Told("tale", person, days, {voice = voice or false, player = player or false, brief = brief and true or false}, function()
        return A.JournalTale.Tell(person, days, voice, player, brief)
    end)
end

function C.Clear()
    store, order = {}, {}
end
