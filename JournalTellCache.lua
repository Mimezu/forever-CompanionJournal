-- Companion Journal: told books kept for the session (1.43.1; in the background 1.54.0).
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
--
-- The book (1.54.0) never tells, gathers the days or builds a key while you wait: C.Book hands
-- back the last telling of that book with the days it was told from, at once, and checks in the
-- background, a few milliseconds a frame, whether it still holds. When it does not, the book is
-- told again there and the page turns to it when it is ready. A book never told this session
-- shows a short "being written" page for the second or two that takes.
local _, A = ...
local C = {}
A.TellCache = C

C.ON = true
C.OPEN_STEP = 300
C.MAX = 12                  -- books kept at once (the oldest goes first)
-- (saved settings the tellers never read and the book changes as you read or move it)
C.SKIP = {bookRead = true, bookPins = true, bookSize = true, bookSpread = true, bookWidth = true, bookHeight = true,
    bookMinimapAngle = true, bookMinimap = true, groupPromptPoint = true, bookNotice = true, bookNoticed = true,
    -- (the Road's points: read by the maps only, and they grow every evening)
    road = true, roadRecord = true, roadDefaultOn = true, roadSounds = true, deathShots = true}
C.hits, C.misses = 0, 0

local store, order, daysOf = {}, {}, {}
local job -- the background telling running now (below)
local queue = {} -- the ones waiting, the book's own first
local failed = {} -- (a book whose telling failed: when, so the book does not ask again every frame)

-- Whether the code running now is the background job (or a protected call inside it).
local function InJob()
    local co = coroutine.running()
    return job ~= nil and co ~= nil and job.cos[co] == true
end

-- A value as text: tables by their pairs (an unchanged table walks in the same order; a changed
-- one at worst misses), strings with their length so no two values read the same.
-- The whole saved journal as text takes ~30 ms; a background job that builds its own key
-- (job.keyYield) pauses here between entries, so that never lands in one frame.
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
        if job and job.keyYield and depth <= 5 and InJob() then A.TellStep() end
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

-- The key of one telling. `kind` names the teller ("self", "tale"), `args` the
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

-- The newest telling kept for one book (its teller, person and arguments, whatever the saved
-- data): handed back while a fresh telling runs in the background.
local latest = {}
local function Identity(kind, person, args)
    local buf = {kind, ":", tostring(A.Me and A.Me() or ""), ":"}
    if type(person) == "table" then buf[#buf + 1] = tostring(person.charKey or rawget(person, "__key") or person.__key or person.name) end
    buf[#buf + 1] = "|"
    Put(buf, args or {}, 1)
    return table.concat(buf)
end
C.Identity = Identity
local function Remember(key, stories, ident, days)
    if ident then latest[ident] = key end
    if not store[key] then order[#order + 1] = key end
    store[key] = stories
    if days then daysOf[key] = days end
    while #order > C.MAX do
        local gone = table.remove(order, 1)
        store[gone], daysOf[gone] = nil, nil
    end
end

-- Told once per key: `tell()` gives the book (a table of chapters by day key), which is kept and
-- handed back on every later call with the same key. The book handed back is shared: read it,
-- never write to it.
-- opts.background: when this book was told before, hand back that telling at once and tell
-- it afresh in the background (opts.ready() is called when the fresh one is kept).
function C.Told(kind, person, days, args, tell, opts)
    if not C.ON then return tell() end
    local key = C.Key(kind, person, days, args)
    local stories = store[key]
    if stories then C.hits = C.hits + 1; return stories end
    local ident = Identity(kind, person, args)
    if opts and opts.background and C.Background then
        local stale = latest[ident] and store[latest[ident]]
        if stale then
            C.Background(key, ident, tell, opts.ready)
            return stale, true
        end
    end
    C.misses = C.misses + 1
    stories = tell()
    -- (a telling that changed the saved variables would never match its key again: keep it only
    -- when the key still holds)
    if type(stories) == "table" and C.Key(kind, person, days, args) == key then Remember(key, stories, ident) end
    return stories
end

-- The own book, as SelfTale.Tell(person, days, brief, retell) tells it.
function C.Self(person, days, brief, retell, opts)
    return C.Told("self", person, days, {brief = brief and true or false, retell = retell or false}, function()
        return A.SelfTale.Tell(person, days, brief, retell)
    end, opts)
end
-- A companion's book, as JournalTale.Tell(person, days, voice, player, brief) tells it.
function C.Tale(person, days, voice, player, brief)
    return C.Told("tale", person, days, {voice = voice or false, player = player or false, brief = brief and true or false}, function()
        return A.JournalTale.Tell(person, days, voice, player, brief)
    end)
end

-- In the background (1.51.3; a queue 1.54.0): a telling runs in a coroutine, a few milliseconds
-- a frame, pausing between days (A.TellStep, called by the tellers); the book stays smooth
-- meanwhile. One at a time, each to its end: a telling stopped halfway would leave a teller's
-- own state half set. A newer request for a book already waiting replaces it; the book's own
-- request goes first. A protected call inside a telling goes through A.TellPcall, which lets
-- the pause through.
C.BUDGET = 6 -- milliseconds a frame
local function Clock() return debugprofilestop and debugprofilestop() or 0 end
function A.TellStep()
    if job and InJob() and Clock() - job.slice > C.BUDGET then coroutine.yield() end
end
local function Pack(...) return {n = select("#", ...), ...} end
-- pcall, for code that may run inside the background job: there it runs `f` in a coroutine of its
-- own and passes each pause up to the job, so a telling can pause inside a protected call.
function A.TellPcall(f, ...)
    if not InJob() then return pcall(f, ...) end
    local inner = coroutine.create(f)
    local cos = job.cos
    cos[inner] = true
    local res = Pack(coroutine.resume(inner, ...))
    while true do
        if not res[1] then cos[inner] = nil; return false, res[2] end
        if coroutine.status(inner) == "dead" then cos[inner] = nil; return unpack(res, 1, res.n) end
        coroutine.yield()
        res = Pack(coroutine.resume(inner))
    end
end

local driver
local Run
local function Start()
    if job or #queue == 0 then return end
    local request = table.remove(queue, 1)
    job = {key = request.key, ident = request.ident, ready = request.ready, slice = Clock(), cos = {}}
    job.co = coroutine.create(request.fn)
    job.cos[job.co] = true
end
local function Finish(current, result)
    job = nil
    -- (asked for again while it ran: check once more, with the newest request; queued before the
    -- ready callbacks, so a request they make merges with it instead of checking the book twice)
    if current.again then
        table.insert(queue, 1, current.again)
    end
    local fire = false
    if type(result) == "table" and current.key then
        Remember(current.key, result, current.ident, current.days)
        if current.post then Remember(current.post, result, current.ident, current.days) end
        fire = true
    elseif current.changed then
        fire = true
    end
    if fire then for _, ready in ipairs(current.ready) do pcall(ready) end end
end
function Run()
    if not job then Start() end
    local current = job
    if not current then if driver then driver:SetScript("OnUpdate", nil) end; return end
    current.slice = Clock()
    local ok, result = coroutine.resume(current.co)
    if not ok then
        -- (the error goes where WoW shows errors; the book shows what it has and asks again later)
        job = nil
        if current.ident then failed[current.ident] = Clock() end
        local handler = geterrorhandler and geterrorhandler()
        if handler then pcall(handler, result) elseif C.SYNC then error(result, 0) end
        for _, ready in ipairs(current.ready) do pcall(ready) end
        return
    end
    if coroutine.status(current.co) == "dead" then Finish(current, result) end
end
local function Drive()
    if not driver and CreateFrame then driver = CreateFrame("Frame") end
    if driver and driver.SetScript and not C.SYNC then
        driver:SetScript("OnUpdate", Run)
    else
        -- (no frames: at once, to the end)
        C.Drain()
    end
end
-- Run every waiting telling to its end, now (tests, and a game without frames).
function C.Drain()
    local guard = 0
    while (job or #queue > 0) and guard < 1000000 do Run(); guard = guard + 1 end
end
-- Ask for a telling. `request` = {ident, fn, ready = {...}, key}; `first`: before the others.
local function Enqueue(request, first)
    if job and job.ident == request.ident then
        -- (the one running: it finishes, then checks again with this request)
        local again = job.again or {ident = request.ident, ready = {}}
        again.fn, again.key = request.fn, request.key
        for _, ready in ipairs(request.ready) do again.ready[#again.ready + 1] = ready end
        job.again = again
        return
    end
    for i, waiting in ipairs(queue) do
        if waiting.ident == request.ident then
            for _, ready in ipairs(waiting.ready) do request.ready[#request.ready + 1] = ready end
            table.remove(queue, i)
            break
        end
    end
    if first then table.insert(queue, 1, request) else queue[#queue + 1] = request end
    Drive()
end
-- (the old way in: a telling under a known key; key nil: the job builds its own key)
function C.Background(key, ident, tell, ready)
    if key ~= nil and job and job.key == key then
        if ready then job.ready[#job.ready + 1] = ready end
        return
    end
    Enqueue({key = key, ident = ident, fn = tell, ready = {ready}}, true)
end
function C.Busy() return job ~= nil or #queue > 0 end

-- The job that checks one book and tells it when needed: the days, then the key (pausing
-- between entries), then, when no telling is kept under that key, the telling. When a telling
-- changed the saved data (a line marked told), its key moved: the next check tells it once more,
-- as the book always did; a second move keeps it under the new key too, so it never loops.
local retold = {}
local function Checker(kind, person, args, ident, gather, tell)
    return function()
        local me = job
        -- (the indexes the tellers read, built here the first time, where the job may pause)
        if A.JournalEpisodes and A.JournalEpisodes.WarmIndexes then A.JournalEpisodes.WarmIndexes() end
        local days = gather
        if type(days) == "function" then days = days(); A.TellStep() end
        me.keyYield = true
        local key = C.Key(kind, person, days, args)
        me.keyYield = nil
        if store[key] then
            if not daysOf[key] then daysOf[key] = days end
            if latest[ident] ~= key then latest[ident] = key; me.changed = true end
            return nil
        end
        C.misses = C.misses + 1
        me.key, me.days = key, days
        local stories = tell(days)
        if type(stories) ~= "table" then return nil end
        me.keyYield = true
        local post = C.Key(kind, person, days, args)
        me.keyYield = nil
        if post ~= key then
            retold[ident] = (retold[ident] or 0) + 1
            if retold[ident] >= 2 then me.post = post; retold[ident] = nil end
        else
            retold[ident] = nil
        end
        return stories
    end
end
local function Tellers(kind, args)
    if kind == "self" then
        return function(person) return function(days) return A.SelfTale.Tell(person, days, args.brief, args.retell or nil) end end
    end
    return function(person) return function(days) return A.JournalTale.Tell(person, days, args.voice or nil, args.player or nil, args.brief) end end
end
-- The book's way in: the last telling of this book and the days it was told from, at once (nil
-- when it was never told), and a check in the background; `ready()` when a fresh telling is kept.
-- `gather()` gives the days. args: self {brief, retell}; tale {voice, player, brief}.
function C.Book(kind, person, args, gather, ready)
    local ident = Identity(kind, person, args)
    if not C.ON then
        local days = gather()
        return Tellers(kind, args)(person)(days), days
    end
    local key = latest[ident]
    if failed[ident] and Clock() - failed[ident] < 30000 then
        return key and store[key] or {}, key and daysOf[key] or {}
    end
    failed[ident] = nil
    Enqueue({ident = ident, fn = Checker(kind, person, args, ident, gather, Tellers(kind, args)(person)), ready = {ready}}, true)
    key = latest[ident]
    local stories = key and store[key]
    if stories then C.hits = C.hits + 1; return stories, daysOf[key] end
    return nil, nil
end
-- The own book told ahead, in the background, so the book opens on it at once (while you play,
-- after a new entry; at login). Nothing is told when it is already kept. `days` may be a function
-- giving the days: the job gathers them in its first frame, builds the key over the next frames
-- and only then tells.
function C.WarmSelf(person, days, brief)
    if not C.ON then return end
    local args = {brief = brief and true or false, retell = false}
    local ident = Identity("self", person, args)
    Enqueue({ident = ident, fn = Checker("self", person, args, ident, days, Tellers("self", args)(person)), ready = {}}, false)
end

function C.Clear()
    store, order, latest, daysOf, retold, failed = {}, {}, {}, {}, {}, {}
    -- (a telling running now goes on to its end, so no teller is left half way; it is kept)
end
