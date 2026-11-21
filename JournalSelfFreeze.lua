local _, A = ...
-- Finished chapters kept (2026-11-20). Your own book was told from its first day after every new
-- line: half a second of work for a long journal, in the background but in pieces long enough to
-- stutter. A day whose chapter can no longer change (the record went on three days past it: the
-- composer reads that far ahead) is told once: its chapter is kept with the storyteller's memory
-- at its end, and the next telling starts from the day after.
--
-- Kept for this session only, and only for tellings in the background (JournalTellCache.lua): a
-- reload (an update of the addon) tells the whole book again. Anything else the words depend on
-- (your settings, your companions, Retell) tells it again too; so does any change to a kept day.
-- A kept chapter is not told again when later days arrive: the story so far stays as it was.
local F = {}
A.SelfFreeze = F
F.ON = true
F.SETTLE = 3 * 86400  -- seconds of record after a day before its chapter is kept
F.ALWAYS = false      -- (tests: keep days outside the background job too)
F.MAX = 3             -- books kept at once
F.kept, F.order = {}, {}
F.resumed, F.told = 0, 0

local function Put(buf, v) A.TellCache.Put(buf, v, 1) end
local function Sorted(t)
    local keys = {}
    for k in pairs(t) do keys[#keys + 1] = k end
    table.sort(keys, function(x, y) return tostring(x) < tostring(y) end)
    return keys
end

-- Everything besides the days the words depend on: the person, the telling's arguments, the
-- saved settings and people. What changes as you play is left out: a kept chapter is the story
-- as it was told, and later days do not change it (2026-11-20: a companion's "last seen" stamp,
-- written every time they are near, told the whole book again after every line).
--   SKIP_PERSON: the person's own changing state; SKIP: in the saved data, by place ("*": any key).
local SKIP_PERSON = {level = true}
local SKIP = {
    journalQuests = true,
    people = {["*"] = {seen = true, zone = true, level = true}},
    characters = {["*"] = {journal = true, firsts = true, loreDiscoveries = true, rep = true, skills = true,
        continent = true, people = {["*"] = {journal = true}}}},
}
local function PutSkip(buf, v, skip)
    if type(v) ~= "table" or type(skip) ~= "table" then Put(buf, v); return end
    buf[#buf + 1] = "{"
    for _, k in ipairs(Sorted(v)) do
        local s = skip[k]
        if s == nil then s = skip["*"] end
        if s ~= true then
            Put(buf, k); buf[#buf + 1] = "="
            PutSkip(buf, v[k], s)
        end
    end
    buf[#buf + 1] = "}"
end
F.SKIP_PERSON, F.SKIP = SKIP_PERSON, SKIP
function F.Ident(person, brief, retell, planned)
    local buf = {"self|", tostring(brief), "|", tostring(retell), "|", tostring(planned), "|"}
    for _, k in ipairs(Sorted(person)) do
        local v = person[k]
        if type(v) ~= "table" and not SKIP_PERSON[k] then Put(buf, k); buf[#buf + 1] = "="; Put(buf, v) end
    end
    buf[#buf + 1] = "|"
    local db = A.db
    if type(db) == "table" then
        local skip = A.TellCache.SKIP or {}
        for _, k in ipairs(Sorted(db)) do
            if not skip[k] and SKIP[k] ~= true then
                if A.TellStep then A.TellStep() end
                Put(buf, k); buf[#buf + 1] = "="
                PutSkip(buf, db[k], SKIP[k])
            end
        end
    end
    return table.concat(buf)
end

-- A day as the teller reads it: its scenes and their lines.
local function DayPrint(day)
    local buf = {tostring(day.key), ":", tostring(day.t)}
    for _, s in ipairs(day.scenes or {}) do
        buf[#buf + 1] = "|" .. tostring(s.t) .. "," .. tostring(s.e) .. "," .. tostring(s.zone) .. "," .. tostring(s.kind) .. "," .. tostring(s.open)
        for _, e in ipairs(s.entries or {}) do buf[#buf + 1] = ";"; Put(buf, e) end
    end
    return table.concat(buf)
end
local function DayEnd(day)
    local scenes = day.scenes or {}
    local last = scenes[#scenes]
    return last and (last.e or last.t) or day.t or 0
end

-- Where each table under the days sits ({1, "scenes", 3, ...}), so the kept memory can point at
-- the same place in a later telling's days.
local function Paths(days)
    local paths, queue, head = {[days] = {}}, {days}, 1
    while queue[head] do
        local t = queue[head]; head = head + 1
        if A.TellStep and head % 64 == 0 then A.TellStep() end
        local base = paths[t]
        for k, v in pairs(t) do
            if type(v) == "table" and paths[v] == nil and (type(k) == "string" or type(k) == "number") then
                local p = {}
                for i = 1, #base do p[i] = base[i] end
                p[#p + 1] = k
                paths[v] = p
                queue[#queue + 1] = v
            end
        end
    end
    return paths
end
local function Resolve(days, path)
    local t = days
    for _, k in ipairs(path) do
        if type(t) ~= "table" then return nil end
        t = t[k]
    end
    return type(t) == "table" and t or nil
end
-- A copy of the teller's memory. Tables of the days (or the book's data) are not copied: `swap`
-- gives what stands in their place, `keep` those kept as they are.
local function Copy(v, swap, keep, seen)
    if type(v) ~= "table" then return v end
    local s = swap[v]
    if s then return s end
    if keep[v] then return v end
    local c = seen[v]
    if c then return c end
    c = {}
    seen[v] = c
    if A.TellStep then A.TellStep() end
    for k, x in pairs(v) do c[Copy(k, swap, keep, seen)] = Copy(x, swap, keep, seen) end
    local mt = getmetatable(v)
    if mt then setmetatable(c, mt) end
    return c
end

-- At the start of a telling: what can be kept, and the kept telling to go on from (nil: tell
-- from the first day). `dayDone(i)` is the teller's own test of a finished day.
function F.Begin(person, days, brief, retell, capture, planned)
    if not F.ON or capture or type(days) ~= "table" or #days < 2 or not A.TellCache or not A.TellCache.Put then return nil end
    if not F.ALWAYS and not (A.TellCache.InJob and A.TellCache.InJob()) then return nil end
    local recordEnd = DayEnd(days[#days])
    local freezeAt = 0
    for i = #days - 1, 1, -1 do
        if DayEnd(days[i]) + F.SETTLE <= recordEnd then freezeAt = i; break end
    end
    if freezeAt == 0 then return nil end
    local fz = {ident = F.Ident(person, brief, retell, planned), freezeAt = freezeAt, days = days}
    local rec = F.kept[fz.ident]
    if rec and rec.upto <= #days - 1 then
        local same = true
        for i = 1, rec.upto do
            if A.TellStep and i % 4 == 0 then A.TellStep() end
            if DayPrint(days[i]) ~= rec.prints[i] then same = false; break end
        end
        if same then
            -- (the memory, pointed at this telling's days)
            local swap = {}
            for old, path in pairs(rec.refs) do swap[old] = Resolve(days, path) or old end
            local copy = Copy({history = rec.history, teller = rec.teller}, swap, rec.keep, {})
            local stories = {}
            for k, v in pairs(rec.stories) do stories[k] = v end
            fz.resume = {upto = rec.upto, history = copy.history, teller = copy.teller, stories = stories}
            F.resumed = F.resumed + 1
        else
            F.kept[fz.ident] = nil
        end
    end
    F.told = F.told + 1
    return fz
end

-- At the end of day `index` when it is the last one that can be kept: the chapters so far and the
-- teller's memory.
function F.Keep(fz, index, stories, history, teller)
    if not fz or index ~= fz.freezeAt then return end
    local old = F.kept[fz.ident]
    if old and old.upto >= index and fz.resume and fz.resume.upto >= index then return end
    local days = fz.days
    local paths = Paths(days)
    -- (the days' tables, the journal's lines and the book's data are pointed at, never copied)
    local keep, refs = {}, {}
    local swap = setmetatable({}, {__index = function(_, t)
        local p = paths[t]
        if p then refs[t] = p; keep[t] = true end
        return nil
    end})
    local copy = Copy({history = history, teller = teller}, swap, keep, {})
    local prints = {}
    for i = 1, index do
        if A.TellStep and i % 4 == 0 then A.TellStep() end
        prints[i] = DayPrint(days[i])
    end
    local kept = {}
    for i = 1, index do
        local key = days[i].key
        if stories[key] ~= nil then kept[key] = stories[key] end
    end
    if not F.kept[fz.ident] then F.order[#F.order + 1] = fz.ident end
    F.kept[fz.ident] = {upto = index, prints = prints, stories = kept, history = copy.history, teller = copy.teller, refs = refs, keep = keep}
    while #F.order > F.MAX do
        local gone = table.remove(F.order, 1)
        if gone ~= fz.ident then F.kept[gone] = nil end
    end
end

function F.Clear() F.kept, F.order = {}, {} end
