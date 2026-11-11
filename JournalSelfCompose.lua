-- Companion Journal: the composer of the own book's Current teller (2026-11-11, lane E).
--
-- The teller writes the day's lines stretch by stretch, in record order. This pass reads
-- them once more as a writer would: it splits the day into episodes (JournalEpisodes.Day),
-- gives every line to its episode, orders the lines inside an episode by what they are
-- (who went, the place, what happened, what it cost, what came of it, the way out), drops
-- the furniture (inns, campfires, cave mouths, bat rides inside an evening), keeps one craft
-- sentence and the heaviest firsts, puts each level where it came, makes one paragraph per
-- episode (merging the light ones, splitting the long ones at a turn) and closes the chapter
-- on what the evening came to, from the record only.
--
-- A.SelfCompose.Apply(ctx) rewrites ctx.out/majors/kinds/times/scenes/metas in place and
-- returns true when it composed the chapter (false leaves the teller's order). ctx: day,
-- stretches, out, majors, kinds, times, scenes (stretch index per line), metas (the planned
-- telling's notes per line: t, e, s, entry, joined, close, trade, count, hearth ...),
-- levels (the day's levels), teller, W (SelfWords), Place, person, history, index.
-- A dungeon run's lines are never reordered or cut here: the run is told by its own writer.
local _, A = ...
local C = {}
A.SelfCompose = C

C.MIN_WORDS = 40      -- a paragraph lighter than this joins its neighbour
C.MAX_WORDS = 110     -- a paragraph heavier than this splits at a turn
C.MAX_WORDS_DEATHS = 170  -- a bad stretch told inside its errand may run longer before it splits
C.MAX_PARAGRAPHS = 8
C.SOLO_FIX = true     -- "we" in a quest line said while nobody was in the party becomes "I"

local function Clean(text) return (tostring(text or ""):gsub("[{}]", "")) end
local function Plain(text)
    if A.JournalPlain then return A.JournalPlain(text) end
    return (tostring(text or ""):gsub("{%a:([^}]*)}", "%1"))
end
local function Words(text) local n = 0; for _ in Plain(text):gmatch("%S+") do n = n + 1 end; return n end
local function Esc(text) return (tostring(text):gsub("[%^%$%(%)%%%.%[%]%*%+%-%?]", "%%%0")) end
local function Cap(text) return (tostring(text or ""):gsub("^%l", string.upper)) end
local function Lower(text)
    if text:match("^I ") or text:match("^{") then return text end
    return (text:gsub("^%u", string.lower))
end
local function Any(text, list) for _, p in ipairs(list) do if text:find(p) then return true end end return false end
-- A town the teller knows (its own table first, then Lore's).
local function IsTown(name)
    if not name or name == "" then return false end
    if A.SelfTale and A.SelfTale.Town then return A.SelfTale.Town(Clean(name)) and true or false end
    return (A.Lore and A.Lore.Town and A.Lore.Town(Clean(name))) and true or false
end
-- (a clock for the debug hook only; the game has no os, so it uses its own date)
local function Clock(t) return (date and date("%H:%M", t or 0)) or tostring(t) end
local function Has(list, item) for _, x in ipairs(list) do if x == item then return true end end return false end
local function Sorted(list, less) table.sort(list, less); return list end
local function Plural(name)
    local n = Clean(name)
    return n:find("Barrens$") or n:find("Foothills$") or n:find("lands$") or n:find("Mountains$") or n:find("Steppes$")
        or n:find("Glades$") or n:find("Highlands$") or n:find("Isles$") or n:find("Needles$") or n:find("Wetlands$")
end
local function Fill(line, tokens)
    return (line:gsub("{(%a+)}", function(key) return tokens[key] ~= nil and tostring(tokens[key]) or ("{" .. key .. "}") end))
end
local function List(items)
    if #items == 0 then return "" elseif #items == 1 then return items[1] end
    return table.concat(items, ", ", 1, #items - 1) .. " and " .. items[#items]
end

-- Text that only moves or rests the character (for untagged lines).
local MOVE = {"rode the lift", "zeppelin", "came up out of", "went on through", "went on to ", "took me on to", "took me to", "hearthstone took me",
    "hearthstone brought me", "flew to", "went into ", "came into ", "came to ", "^after [%w' ]+ came ", "^from [%w' ]+, we went", "^from [%w' ]+, i went",
    "went down into", "went back to", "my way took me", "the road took me", "a moment later", "passed through", "came through", "walked into",
    "headed into", "went out into", "made my way", "made our way", "carried me over", "carried us over", "carried me to", "carried us to",
    "carried me across", "carried us across", "took the flight", "came back out into", "came out of the dark into", "found my way into",
    "stayed on in", "came down in the dark", "ship carried", "boat carried", "a bat carried", "rode a bat", "without stopping", "gave way to",
    "sailed to", "took the boat", "was behind me now", "was across the sea now", "set out on the road", "i went back to", "went home to",
    "rode a zeppelin", "took the zeppelin", "took ship", "the lift carried", "i left [%w' ]+ for ", "we left [%w' ]+ for "}
local FURNITURE = {"stopped at ", "stopped in ", "stopped a while", "took a room", "rested at", "rested a while", "slept at", "a place to rest",
    "to rest%.", "for the night", "campfire", "sat by a fire", "sat by the fire", "by the fire", "made camp", "we stopped by"}
local NIGHT = {"after dark", "by night", "at night", "was night when", "was dark when", "in the dark%.", "lights of the towns"}
local FIRST = {"first time", "my first", "the first ", "for the first", "had never", "never been", "new to me", "new country", "first dungeon",
    "first flight", "first sight"}
local FIRST_WEIGHT = {continent = 6, dungeon = 5, rezother = 4, zeppelin = 3, boat = 3, tram = 3, flight = 2, zone = 1}

-- The kinds of a line, as the composer sees them.
local function Classify(n, ctx, ep)
    local kind, meta, text = ctx.kinds[n], ctx.metas[n] or {}, ctx.out[n]
    local low = Plain(text):lower()
    local e = meta.e
    if e and e.k == "voyage" and n == 1 then return "voyage" end
    if n == 1 or kind == "origin" or kind == "open" or kind == "mood" or kind == "recap" then return "open" end
    if meta.close then return "close" end
    if meta.joined or Any(low, {"joined me", "joined us", "caught up with", "fell in beside", "was with me%.", "were with me%.", "came along",
        "was there too", "were there too", "was along", "joined my party", "joined the party", "at my side", "beside me", "went on together",
        "^i met %u", "^i fell in with", "^we fell in with", "my friend,", "in my party", "in the party", "came with me", "had left us", "was gone by then",
        "had gone by then"}) then return "who" end
    if kind == "level" or meta.levelEarly then return "level" end
    if kind == "craft" or kind == "gather" or meta.trade or meta.gather then return "craft" end
    if kind == "lore" then return "place" end
    if e and e.k == "voyage" then return "voyage" end
    if kind == "first" and Any(low, {"zeppelin", "ship carried", "boat carried", "took the boat", "carried me over", "carried me across", "took ship", "rode the lift", "flew", "flight"}) then return "what" end
    if kind == "first" and e and (e.d == "zone" or e.d == "continent") then return "place" end
    if kind == "first" and Any(low, {"was new to me", "had never been", "my first time there", "were new to me", "for the first time", "new country", "first time in"}) then return "place" end
    if kind == "town" then return "town" end
    if kind == "rest" or (not kind and Any(low, FURNITURE)) then return "rest" end
    if e and e.k == "cave" then return "cave" end
    if kind == "death" or kind == "deathRun" or kind == "rez" then return "death" end
    if e and e.k == "voyage" then return "voyage" end
    if meta.hearth then return "arrive" end
    if not kind and Any(low, NIGHT) and Any(low, {"fl[ei][wg]"}) then return "night" end
    if kind == "move" or kind == "taxi" or (not kind and Any(low, MOVE) and not Any(low, FIRST)) then return "move" end
    if Any(low, {"quests lay behind", "quests, by my own count", "hundred quests"}) then return "milestone" end
    if kind == "quests" or kind == "questStart" or kind == "questOutcome" then return "quest" end
    return "what"
end

-- The time behind a line: its note's, else its stretch's start.
local function TimeOf(n, ctx)
    local meta = ctx.metas[n] or {}
    local s = ctx.stretches[ctx.scenes[n] or 0]
    return meta.t or ctx.times[n] or (s and s.t) or 0
end
local function EpisodeAt(t, episodes)
    for _, ep in ipairs(episodes) do if t >= ep.t and t < ep.until_ then return ep end end
    if t < episodes[1].t then return episodes[1] end
    return episodes[#episodes]
end
-- Is anyone of the stretch's party with me at this time? (nil when the stretch has no party)
local function WithAt(s, t)
    if not s or #(s.with or {}) == 0 then return nil end
    for _, w in ipairs(s.with) do
        for _, span in ipairs(w.spans or {{s.t, s.e}}) do if t >= span[1] and t <= span[2] then return true end end
    end
    return false
end
-- The day's party windows by name, from every stay's spans, joined across a short gap.
local function DayWindows(stretches)
    local by = {}
    for _, s in ipairs(stretches) do
        for _, w in ipairs(s.with or {}) do
            local name = (Clean(w.name):gsub("%-.*$", ""))
            by[name] = by[name] or {}
            for _, span in ipairs(w.spans or {{s.t, s.e}}) do by[name][#by[name] + 1] = {span[1], span[2]} end
        end
    end
    local windows, any = {}, false
    for name, spans in pairs(by) do
        Sorted(spans, function(a, b) return a[1] < b[1] end)
        local merged = {}
        for _, sp in ipairs(spans) do
            local last = merged[#merged]
            if last and sp[1] - last[2] <= 600 then last[2] = math.max(last[2], sp[2]) else merged[#merged + 1] = {sp[1], sp[2]} end
        end
        windows[name] = merged
        any = true
    end
    return windows, any
end
local function WithAtDay(windows, t)
    for _, spans in pairs(windows) do
        for _, sp in ipairs(spans) do if t >= sp[1] and t <= sp[2] then return true end end
    end
    return false
end
-- "I" to "we" for a line said while the party was with me (the subject only; a first stays mine).
local function Together(text, travel)
    text = text:gsub("^I ", "We "):gsub(", and I ", ", and we "):gsub(" and I ", " and we "):gsub("^([^,%.]+, )I ", "%1we "):gsub("%. I ", ". We ")
        :gsub("([,;] )I ", "%1we ")
    text = text:gsub("^We was ", "We were "):gsub(" we was ", " we were "):gsub("^We am ", "We are ")
    if travel then
        text = text:gsub(" me%.$", " us."):gsub(" me,", " us,"):gsub("below me", "below us"):gsub("around me", "around us")
            :gsub("carried me ", "carried us "):gsub("took me ", "took us "):gsub("brought me ", "brought us "):gsub("set me down", "set us down")
    end
    return text
end
local function Solo(text)
    text = text:gsub("^We ", "I "):gsub(" we ", " I "):gsub(", we ", ", I "):gsub("%f[%a]us%f[%A]", "me"):gsub("%f[%a]our%f[%A]", "my")
        :gsub("%f[%a]Our%f[%A]", "My"):gsub("ourselves", "myself")
    return text
end

-- Selection (lane U, 2026-11-11): the planned telling's budget inside the composer. The
-- composer's quest lines outside the dungeon runs become the planned telling's units
-- (JournalSelfPlan.lua, A.SelfPlan.Sel): a scene with its outcome line, or one act of a grouped
-- line. Sel.Choose decides what each is told as (its full authored account, the account's
-- opening, a bare act, or nothing: two bare acts a chapter at most, a setup kept with its
-- payoff, the step that first names a person told in words that hold the name, what leads
-- nowhere dropped first) inside a budget of about a hundred words an hour less what the
-- chapter's other lines take. A kept act comes back as a line of its own at the act's own
-- time, so the episodes order it; a scene told short keeps its first line as the act; what
-- is left out is dropped. The composer's own order, drops, paragraphs and close are unchanged.
-- Off with C.SELECT = false, or the book variant `select` = "off" (like `compose`).
C.SELECT = true
C.SELECT_FLOOR = 120   -- the work keeps this many words whatever the rest of the chapter takes
local function Hash(text)
    local h = 5381
    text = tostring(text or "")
    for i = 1, #text do h = (h * 33 + text:byte(i)) % 2147483647 end
    return h
end
local function Select(ctx, lines, inRun, episodes)
    local P = A.SelfPlan
    local Sel = P and P.Sel
    local W = ctx.W or {}
    local PW, QD, Tale = W.plan, A.QuestDeeds, A.JournalTale or {}
    if C.SELECT == false or ctx.brief or not Sel or not Sel.Work or not Sel.Persons or not PW or not (QD and QD.JoinActs) or not ctx.history then return nil end
    if A.BookVariant and A.BookVariant("select") == "off" then return nil end
    local stretches, sceneOf = ctx.stretches or {}, ctx.scenes or {}
    local history = ctx.history
    history.plan = history.plan or {said = {}, kind = {}, text = ""}
    local hp = history.plan
    local index = ctx.index or 0
    local seed = tostring(ctx.seed or "me") .. ":" .. tostring(ctx.day and ctx.day.key or index)
    local function Pick(pool, key)
        if type(pool) == "string" then return pool end
        if type(pool) ~= "table" or #pool == 0 then return nil end
        return pool[Hash(seed .. ":" .. key) % #pool + 1]
    end
    -- 1. The quest lines outside the runs, as the planned telling's items: a scene (its lines
    -- share one entry), a grouped line with its acts, or a grouped line rewritten after it was
    -- said (kept whole).
    local items = {}
    for _, l in ipairs(lines) do
        local m = l.meta or {}
        if not l.drop and not inRun[l] and l.ep.kind ~= "dungeon" and l.cls == "quest" and l.n <= #ctx.out then
            local fold = m.fold
            if type(fold) == "table" and not (type(fold.acts) == "table" and type(fold.entries) == "table" and #fold.acts == #fold.entries) then fold = nil end
            if (m.entry or fold) and not l.text:find("{q:", 1, true) then
                local it = {n = l.n, line = l, text = l.text, plain = Plain(l.text), kind = l.kind or "", major = l.major, m = m,
                    s = sceneOf[l.n] or 1, t = l.t, keep = true}
                if m.entry then it.scene, it.thread = true, m.entry.story and m.entry.story.thread
                else it.fold, it.fixed = fold, m.said ~= l.text end
                items[#items + 1] = it
            end
        end
    end
    if #items < 3 then return nil end
    local sel = Sel.Start({items = items, stretches = stretches, hp = hp, index = index, out = ctx.out,
        ctx = {race = ctx.race, class = ctx.class, Place = ctx.Place, Companion = ctx.Companion, level = ctx.level},
        PW = PW, F = A.JournalFeel or {}, Tale = Tale, QD = QD, Pick = Pick, Clock = function() return nil end, whoShape = 0})
    local zoneWords = {}
    for _, s in ipairs(stretches) do for word in Plain(s.zone or ""):gmatch("%a+") do zoneWords[word] = true end end
    sel.zoneWords, sel.titleWords = zoneWords, ctx.titleWords or {}
    local scenes = {}
    for _, it in ipairs(items) do if it.scene then scenes[#scenes + 1] = it end end
    Sel.Acts(sel, scenes)
    -- (a great figure met: the scene handed in to the figure within three minutes is a peak)
    local figureScene, figureLine = {}, {}
    for _, l in ipairs(lines) do
        if not l.drop and not inRun[l] and l.meta and l.meta.figure then
            local figure = Plain(l.meta.figure)
            local scene
            for _, other in ipairs(scenes) do
                if not scene and other.t and l.t and math.abs(other.t - l.t) <= 180 and Sel.NamesFigure(sel, other.plain, figure) then scene = other end
            end
            if scene then figureScene[scene] = figure else figureLine[{n = l.n}] = figure end
        end
    end
    sel.figureScene, sel.figureLine = figureScene, figureLine
    -- (what the chapter's other lines take; the furniture the composer drops is not counted)
    local fixed, craft = 0, 0
    for _, l in ipairs(lines) do
        if not l.drop and not inRun[l] and (l.cls ~= "quest" or l.ep.kind == "dungeon") and l.cls ~= "rest" and l.cls ~= "town"
            and l.cls ~= "cave" and l.cls ~= "move" and l.cls ~= "close" then
            if l.cls == "craft" then craft = math.max(craft, Words(l.text)) else fixed = fixed + Words(l.text) end
        end
    end
    -- (the composer's lines count half: its deaths, firsts and lore are its strength, and the
    -- budget is here to trim the work, not them)
    sel.fixedExtra, sel.roomFloor, sel.pairs = math.floor((fixed + craft) / 2), C.SELECT_FLOOR, true
    Sel.Units(sel)
    -- (the chapter that tells where the life began opens on its first scene)
    for _, l in ipairs(lines) do
        if l.meta and l.meta.origin then
            for _, u in ipairs(sel.units) do if u.kind == "scene" then u.first = true; break end end
            break
        end
    end
    Sel.Peaks(sel)
    Sel.Choose(sel)
    Sel.Persons(sel)
    -- 2. What was decided, back on the lines. A grouped line's kept acts are lines of their own
    -- (Sel.Work: a sentence a piece, or two under one giver; an act told in its account comes
    -- in those words), each at its act's time; a scene told short keeps its act; the rest goes.
    local said, lastText, added = hp.text or "", nil, {}
    for _, it in ipairs(items) do
        local l = it.line
        if it.chosen then
            local work = Sel.Work(sel, it, nil, lastText)
            for i, w in ipairs(work) do
                local opts = w.opts or {}
                local u = opts.unit
                local t = opts.t or it.t
                local text = A.JournalIslands and A.JournalIslands(w.text) or w.text
                text = Sel.Shorten(sel, text, said)
                local solo = u and (u.class or (u.entry and u.entry.act and u.entry.act.solo)) and true or nil
                added[#added + 1] = {n = it.n + (i - 1) / 10, cls = "quest", t = t, ep = EpisodeAt(t, episodes), text = text, s = l.s,
                    major = l.major, kind = opts.turn and "questStart" or "quests",
                    meta = {s = it.m.s, t = t, e = it.m.e, fold = it.m.fold, said = it.m.said, sel = opts, solo = solo, entry = opts.turn and u and u.entry or nil}}
                lastText = Plain(text)
                said = said .. " " .. lastText
            end
            l.drop = true
        elseif not it.keep then
            l.drop = true
        else
            if it.text ~= l.text then l.text = it.text end
            l.meta.sel = {unit = it.unit, short = it.short, side = it.side, setup = it.setup, peak = it.peak}
            lastText = Plain(l.text)
            said = said .. " " .. lastText
        end
    end
    for _, nl in ipairs(added) do lines[#lines + 1] = nl end
    if C.Debug then
        for _, u in ipairs(sel.units or {}) do C.Debug(("sel %-5s mode=%-5s score=%s rank=%s must=%s own=%s %s%s %s"):format(u.kind, tostring(u.mode), tostring(u.score), tostring(u.rank), tostring(u.must), tostring(u.own), u.paired and "P" or "", u.pulled and "p" or "", (u.plain or ""):sub(1, 50) .. (" [kin=%s skip=%s fb=%s full=%s w=%s]"):format(tostring(u.kin), tostring(u.skip), tostring(u.fallback), u.full and #u.full or "nil", tostring(u.words)))) end
        C.Debug(("sel cap=%d fixed=%d room=%s used=%s steps=%s"):format(sel.cap or 0, fixed + craft, tostring(sel.room), tostring(sel.used), table.concat(sel.steps or {}, ",")))
    end
    return sel
end

-- One chapter -------------------------------------------------------------------------------
function C.Apply(ctx)
    local E = A.JournalEpisodes
    if C.enabled == false then return false end
    if not E or not E.Day or not ctx or not ctx.day or #(ctx.out or {}) == 0 then return false end
    local ok, D = pcall(E.Day, ctx.day.scenes)
    if not ok or not D or #D.episodes == 0 then return false end
    local episodes = D.episodes
    local W = ctx.W or {}
    local P = W.compose or {}
    local teller = ctx.teller
    local Place = ctx.Place or function(name) return "{p:" .. Clean(name) .. "}" end
    local function Pick(key, pool, tokens)
        if type(pool) ~= "table" or #pool == 0 then return nil end
        local line = teller and teller.Say and teller:Say("compose:" .. key, pool, tokens) or pool[1]
        return line and Fill(line, tokens or {}) or nil
    end
    local out, majors, kinds, times, scenes, metas = ctx.out, ctx.majors, ctx.kinds, ctx.times, ctx.scenes, ctx.metas
    local stretches = ctx.stretches or {}
    local chapterPlain = Plain(table.concat(out, " "))

    -- 1. Every line to its episode, with its class and time.
    local lines = {}
    for n = 1, #out do
        local s = stretches[scenes[n] or 0]
        local cls = Classify(n, ctx)
        local t = TimeOf(n, ctx)
        local ep
        if s and s.run then
            for _, x in ipairs(episodes) do if x.kind == "dungeon" and x.run and x.run.dungeon == s.run.dungeon and x.t <= (s.e or x.t) and x.e >= (s.t or x.e) then ep = x; break end end
        end
        if not ep then
            if cls == "night" or cls == "voyage" then
                -- (said at the end of the stay it left from: at its own event's time)
                local meta = metas[n] or {}
                local at = meta.e and meta.e.t
                if not at and cls == "night" then
                    for _, e in ipairs(s and s.events or {}) do if e.k == "nightflight" then at = e.t end end
                end
                at = at or (s and s.e and s.e - 1) or t
                t = at
                ep = EpisodeAt(at, episodes)
            elseif cls == "craft" then
                -- (honest work at its own time; the teller tells it at the stay's end)
                local meta = metas[n] or {}
                local at
                local kind = ctx.kinds[n]
                -- (the record's own gather and craft entries carry the times; the stay's events do not)
                for _, e in ipairs(s and s.entries or {}) do
                    if meta.trade and e.k == "craft" and e.d and Clean(e.d):lower() == tostring(meta.trade):lower() then at = e.t
                    elseif not meta.trade and e.k == (kind == "gather" and "gather" or "craft") and (not at or (e.t or 0) > at) then at = e.t end
                end
                t = at or (s and s.e and s.e - 1) or t
                ep = EpisodeAt(t, episodes)
            elseif cls == "who" then
                -- (a join is an event at the companion's own time, not the stay's)
                local at = t
                if s then
                    local earliest
                    for _, w in ipairs(s.with or {}) do
                        if Plain(out[n]):find(Clean(w.name):gsub("%-.*$", ""), 1, true) then
                            for _, span in ipairs(w.spans or {}) do if not earliest or span[1] < earliest then earliest = span[1] end end
                        end
                    end
                    if earliest and earliest > at then at = earliest end
                end
                t = at
                ep = EpisodeAt(at, episodes)
            elseif cls == "milestone" then
                -- (the count came with the record's Nth hand-in, not where the teller said it)
                local low = Plain(out[n]):lower()
                local count = (low:find("two hundred and fifty") and 250) or (low:find("five hundred") and 500) or (low:find("hundred") and 100) or nil
                local at = t
                if count and ctx.person and type(ctx.person.journal) == "table" then
                    local quests = {}
                    for _, e in ipairs(ctx.person.journal) do if e.k == "quest" and e.t then quests[#quests + 1] = e.t end end
                    table.sort(quests)
                    if quests[count] and quests[count] >= (D.t or 0) and quests[count] <= (D.e or math.huge) then at = quests[count] end
                end
                t = at
                ep = EpisodeAt(at, episodes)
            elseif cls == "open" and n == 1 then
                ep = episodes[1]
            else
                ep = EpisodeAt(t, episodes)
            end
        end
        lines[n] = {n = n, cls = cls, t = t, ep = ep, text = out[n], s = s, major = majors[n], kind = kinds[n], meta = metas[n] or {}}
    end
    if C.Debug then
        for _, l in ipairs(lines) do C.Debug(("%s ep%d %-8s k=%-12s %s"):format(Clock(l.t), l.ep.index, l.cls, tostring(l.kind), Plain(l.text):sub(1, 70))) end
    end
    -- (a line said in a stretch that belongs to a dungeon run stays with the run, in its order)
    local inRun = {}
    for _, l in ipairs(lines) do if l.s and l.s.run and l.ep.kind == "dungeon" then inRun[l] = true end end

    -- 2. Drops: furniture, cave mouths, lone companion deaths in a city, the teller's own close.
    local nightSaid = false
    local function EventsNear(s, t, span, kinds_)
        for _, e in ipairs(s and s.events or {}) do
            if kinds_[e.k] and (e.t or 0) > t and (e.t or 0) - t <= span then return true end
        end
        for _, q in ipairs(s and s.quests or {}) do if kinds_.quest and (q.t or 0) > t and (q.t or 0) - t <= span then return true end end
        return false
    end
    -- (lane U: the planned telling's selection of the work, before the episodes take their lines)
    local sel = Select(ctx, lines, inRun, episodes)
    local byEp = {}
    for _, ep in ipairs(episodes) do byEp[ep] = {} end
    for _, l in ipairs(lines) do byEp[l.ep][#byEp[l.ep] + 1] = l end
    for _, l in ipairs(lines) do
        if not inRun[l] then
            local ep = l.ep
            if l.cls == "rest" then
                -- (a rest is furniture, unless the stay was nothing but that)
                local other = false
                for _, x in ipairs(byEp[ep]) do if x ~= l and x.cls ~= "rest" and x.cls ~= "craft" and x.cls ~= "close" then other = true end end
                l.drop = other
            elseif l.cls == "town" then
                -- (a town is a beat of a journey; in an episode of work or deaths it is furniture)
                l.drop = ep.kind ~= "journey"
            elseif l.cls == "cave" then
                -- (a cave is a mouth unless something happened in it: a death down there, a boss, or
                -- a quest whose words name it within ten minutes)
                local cave = Clean(l.meta.e.d or "")
                local inside = false
                for _, e in ipairs(l.s and l.s.events or {}) do
                    if (e.t or 0) > l.t and (e.t or 0) - l.t <= 10 * 60 and (e.k == "boss" or (e.k == "death" and e.sz and Clean(e.sz) == cave)) then inside = true end
                end
                for _, q in ipairs(l.s and l.s.quests or {}) do
                    if (q.t or 0) > l.t and (q.t or 0) - l.t <= 10 * 60 and E.QuestText and E.QuestText(q):find(cave, 1, true) then inside = true end
                end
                l.drop = not inside
            elseif l.cls == "close" then
                l.drop = true
            elseif l.cls == "night" then
                if nightSaid then l.drop = true end
                nightSaid = true
            elseif l.cls == "move" then
                -- (an arrival opens an episode; the rest of the going inside one is furniture)
                local first = true
                for _, x in ipairs(byEp[ep]) do
                    if x ~= l and (x.cls == "open" or x.cls == "place" or x.cls == "arrive") then first = false end
                    if x ~= l and x.t < l.t and x.cls ~= "who" and x.cls ~= "craft" then first = false end
                end
                l.drop = not first
                if not l.drop then l.cls = "arrive" end
            elseif l.cls == "quest" and l.text:find("{q:", 1, true) then
                -- (a quest with no words of its own is never named by its title; it is folded or left out)
                local other = false
                for _, x in ipairs(byEp[ep]) do if x ~= l and (x.cls == "quest" or x.cls == "what" or x.cls == "death") then other = true end end
                l.drop = other
            elseif l.cls == "death" and l.meta.e and l.meta.e.k == "pdeath" and not l.meta.deathRun then
                -- (a companion's death with nothing around it, or inside a city: not told)
                local near = false
                for _, e in ipairs(l.s and l.s.events or {}) do
                    if (e.k == "death" or e.k == "boss") and math.abs((e.t or 0) - l.t) <= 300 then near = true end
                end
                for _, q in ipairs(l.s and l.s.quests or {}) do if math.abs((q.t or 0) - l.t) <= 300 then near = true end end
                local city = l.s and l.s.zone and IsTown(l.s.zone)
                l.drop = not near or city
            end
        end
    end
    -- a sea line is true of the move or dropped: the crossing must have left the home continent
    do
        local homeZone, homeDay
        for zone, dayNo in pairs((ctx.history and ctx.history.zones) or {}) do
            if type(dayNo) == "number" and (not homeDay or dayNo < homeDay) then homeZone, homeDay = zone, dayNo end
        end
        homeZone = homeZone or (stretches[1] and stretches[1].zone)
        local ZC = A.SelfTale and A.SelfTale.ZoneContinent or {}
        local homeContinent = homeZone and ZC[homeZone]
        for _, l in ipairs(lines) do
            if not l.drop and not inRun[l] then
                local low = Plain(l.text):lower()
                if Any(low, {"sea lay between", "across the sea now", "the sea between"}) then
                    local here = l.ep.zone and ZC[l.ep.zone]
                    if not homeContinent or not here or here == homeContinent then l.drop = true end
                end
            end
        end
    end
    -- a first told twice: a line that only says the first beside a line that names the place with it
    for _, l in ipairs(lines) do
        if not l.drop and not inRun[l] and l.kind == "first" and Words(l.text) <= 10 and Any(Plain(l.text):lower(), FIRST) then
            local place = l.text:match("{p:([^}]+)}")
            if place then
                for _, x in ipairs(byEp[l.ep]) do
                    if x ~= l and not x.drop and math.abs(x.t - l.t) <= 300 and x.text:find("{p:" .. Esc(place) .. "}", 1) and Any(Plain(x.text):lower(), FIRST) and Words(x.text) > Words(l.text) then
                        l.drop = true
                        break
                    end
                end
            end
        end
    end
    -- one moment, two records: the first flight and the quest whose words are that ride are one sentence
    for _, l in ipairs(lines) do
        if not l.drop and l.kind == "first" and l.meta.e and l.meta.e.d == "flight" then
            for _, x in ipairs(byEp[l.ep]) do
                if not x.drop and x.cls == "quest" and math.abs(x.t - l.t) <= 300 and Plain(x.text):match("^[WI][e]? ?%l* ?[rtf][oal][dok][ek]? ") then
                    local first, rest = x.text:match("^(.-)%.(.*)$")
                    if first and not Any(Plain(x.text):lower(), FIRST) then
                        x.text = first .. ", my first flight." .. rest
                        l.drop = true
                        break
                    end
                end
            end
        end
    end
    -- (the same for a night flight that was the first flight: one sentence)
    for _, l in ipairs(lines) do
        if not l.drop and l.kind == "first" and l.meta.e and l.meta.e.d == "flight" then
            for _, x in ipairs(byEp[l.ep]) do
                if not x.drop and x.cls == "night" and math.abs(x.t - l.t) <= 300 and not Any(Plain(x.text):lower(), FIRST) then
                    local first, rest = x.text:match("^(.-)%.(.*)$")
                    if first then
                        if first:find(", ", 1, true) then
                            x.text = first:gsub(", ", ", my first flight, ", 1) .. "." .. rest
                        else
                            x.text = first .. ", my first flight." .. rest
                        end
                        l.drop = true
                        break
                    end
                end
            end
        end
    end
    -- the craft sentence of the chapter: the night's end's when it is a real batch, else the largest
    do
        local best, second
        local function Count(l)
            if l.meta.count then return l.meta.count end
            local n = 0
            for _, v in pairs(l.meta.gather or {}) do if type(v) == "number" and v > n then n = v end end
            if n == 0 then n = tonumber(Plain(l.text):match("(%d+)")) or 0 end
            return n
        end
        for _, l in ipairs(lines) do
            if l.cls == "craft" and not inRun[l] then
                local c = Count(l)
                local floor = l.meta.gather and 10 or 5
                l.craftCount = c
                if c < floor then l.drop = true
                elseif not best or (l.ep.night and not best.ep.night and c >= 10) or (c > best.craftCount and not (best.ep.night and c < 10)) then best = l end
            end
        end
        if best then
            for _, l in ipairs(lines) do
                if l.cls == "craft" and not inRun[l] and l ~= best and not l.drop then l.drop = true end
            end
            -- (the one tally goes before the night-end line, never inside a scene)
            if not inRun[best] then best.toClose, best.closeRank = true, 1 end
        end
    end
    -- the budget of grouped lines (STUDY §3.2 step 3): three an episode and one more for every
    -- hour and a half of it, the fullest kept; a line that sets up a told story is never cut
    local storyNames = {}
    for _, l in ipairs(lines) do
        if not l.drop and l.kind ~= "quests" and (l.cls == "quest" or l.cls == "what") then
            for word in Plain(l.text):gmatch("%f[%a](%u%l%l%l%l+)") do storyNames[word] = true end
        end
    end
    for _, ep in ipairs(episodes) do
        local folds = {}
        for _, l in ipairs(byEp[ep]) do if not l.drop and not inRun[l] and l.kind == "quests" and not l.meta.sel then folds[#folds + 1] = l end end
        local budget = 3 + math.floor(((ep.e or ep.t) - ep.t) / 5400)
        if #folds > budget then
            local names = storyNames
            local STOP = {Executor = true, Magistrate = true, Apothecary = true, Deathguard = true, Captain = true, Master = true, Lady = true, Lord = true, Light = true, Scarlet = true, Forsaken = true, Horde = true, Alliance = true, Undercity = true, Brill = true}
            local function Protected(l)
                for word in Plain(l.text):gmatch("%f[%a](%u%l%l%l%l+)") do if names[word] and not STOP[word] then return true end end
                return false
            end
            Sorted(folds, function(a, b)
                local pa, pb = Protected(a) and 1 or 0, Protected(b) and 1 or 0
                if pa ~= pb then return pa > pb end
                local wa, wb = Words(a.text), Words(b.text) if wa ~= wb then return wa > wb end return a.n < b.n
            end)
            for i = budget + 1, #folds do folds[i].drop = true end
        end
    end
    -- a quest line that narrates the road into the episode's own zone, after the arrival was told
    for _, l in ipairs(lines) do
        if l.cls == "quest" and not inRun[l] and l.ep.zone then
            local zone = Clean(l.ep.zone)
            local plain = Plain(l.text)
            local arrived = false
            for _, x in ipairs(byEp[l.ep]) do if (x.cls == "open" or x.cls == "place" or x.cls == "arrive") and Plain(x.text):find(zone, 1, true) then arrived = true end end
            -- (the clause may end the line's first sentence, not the line)
            if arrived and plain:match(", and [wI][e]? [^,%.]-into " .. Esc(zone) .. "%.") then
                l.text = l.text:gsub(", and [^,%.]-into [^%.]-%.", ".", 1)
            end
        end
    end
    -- "I spent the evening in X" when X held a few minutes of it
    do
        local l = lines[1]
        local plain = Plain(l.text)
        local part, place = plain:match("^I spent the (%a+) in (.+)%.$")
        if part and ctx.day and ctx.day.scenes then
            local total = (D.e or 0) - (D.t or 0)
            local first = episodes[1]
            if total > 0 and (first.e - first.t) < total / 3 then
                l.text = l.text:gsub("^I spent the %a+ in ", "The " .. part .. " began in ")
            end
        end
    end
    -- an opener that only names the place (no day, no company) gives way to the first real thing
    do
        local l = lines[1]
        local plain = Plain(l.text)
        local low = plain:lower()
        local shortStay = (D.e or 0) > (D.t or 0) and (episodes[1].e - episodes[1].t) < ((D.e or 0) - (D.t or 0)) / 3
        local hadMe = low:match("had me for the %a+%.$") or low:match("^i spent the %a+ in ")
        if l.kind == "open" and Words(plain) <= 10 and ((hadMe and shortStay) or not Any(low, {"day", "night", "evening", "morning", "afternoon", "later", "week", "with ", " and i ", "again", "monday", "tuesday", "wednesday", "thursday", "friday", "saturday", "sunday"})) then
            local others = 0
            for _, x in ipairs(byEp[l.ep]) do if x ~= l and not x.drop and (x.cls == "quest" or x.cls == "what" or x.cls == "place") then others = others + 1 end end
            if others >= 1 then l.drop = true end
        end
    end
    -- a city quarter named in a line told outside any city (the stay contradicts it)
    for _, l in ipairs(lines) do
        if l.cls == "quest" and not inRun[l] and l.text:find(" in the %u%l+ Quarter ") then
            local city = false
            for _, sc in ipairs(l.ep.scenes) do
                for _, e in ipairs(sc.events or {}) do if e.k == "town" and e.d and sc.zone and Clean(e.d) == Clean(sc.zone) then city = true end end
            end
            if not city then l.text = l.text:gsub(" in the %u%l+ Quarter ", " ", 1) end
        end
    end
    -- no "also" / "after that" stitching: the order is the composer's now
    for _, l in ipairs(lines) do
        if not l.drop and not inRun[l] and l.cls == "quest" then
            l.text = l.text:gsub("^We also ", "We "):gsub("^I also ", "I "):gsub("^After that, (%l)", function(c) return c:upper() end):gsub("^After this, (%l)", function(c) return c:upper() end)
        end
    end
    -- the subject follows the party window at the line's own time: "we" with company, "I" alone
    local windows, anyWindow = DayWindows(stretches)
    if C.SOLO_FIX and anyWindow then
        local PERSONAL = {learn = true, craft = true, gather = true, level = true, origin = true, open = true, mood = true}
        for _, l in ipairs(lines) do
            if not inRun[l] and not l.drop and l.ep.kind ~= "dungeon" and l.cls ~= "who" and l.cls ~= "death" and l.cls ~= "close" and l.cls ~= "open" and not PERSONAL[l.kind or ""] then
                local together = WithAtDay(windows, l.t)
                local low = Plain(l.text):lower()
                local personal = low:find("hearthstone") or (l.meta.e and l.meta.e.d == "rezother") or low:find("my first death") or low:find("the first i ever")
                if together and not personal and not l.meta.solo and (l.text:match("^I ") or l.text:match("^[^,%.]+, I ") or l.text:find("%. I ") or l.text:find(", I ")
                    or (l.cls ~= "quest" and (l.text:find("carried me ") or l.text:find("took me ") or l.text:find("brought me ")))) then
                    l.text = Together(l.text, l.cls ~= "quest")
                elseif not together and l.cls == "quest" and (l.text:match("^We ") or l.text:find("%f[%a]us%f[%A]") or l.text:find("%f[%a]our%f[%A]")) then
                    l.text = Solo(l.text)
                end
            end
        end
    end
    -- a join said as a flag takes the place it happened at, when the record has one
    for _, l in ipairs(lines) do
        if l.cls == "who" and not l.drop and (l.text:match(" was with me%.$") or l.text:match("^I had .- at my side%.$")) and l.s then
            local town
            for _, e in ipairs(l.s.events or {}) do
                if (e.k == "town" or e.k == "rest") and e.d and (e.t or 0) <= l.t and l.t - (e.t or 0) <= 15 * 60 and IsTown(e.d) then town = e.d end
            end
            if town then
                l.text = l.text:gsub(" was with me%.$", " caught up with us at " .. Place(town) .. ".")
                l.text = l.text:gsub("^I had (.-),? at my side%.$", function(who)
                    if who:find(",", 1, true) and not who:match(",$") then who = who .. "," end
                    return who .. " caught up with us at " .. Place(town) .. "."
                end)
            end
        end
    end

    -- 3. Levels where they came (the teller tells the day's last level at the end; the others not at all).
    local NUMBER = {one = 1, two = 2, three = 3, four = 4, five = 5, six = 6, seven = 7, eight = 8, nine = 9, ten = 10, eleven = 11, twelve = 12,
        thirteen = 13, fourteen = 14, fifteen = 15, sixteen = 16, seventeen = 17, eighteen = 18, nineteen = 19, twenty = 20, thirty = 30, forty = 40,
        fifty = 50, sixty = 60}
    local function Num(word)
        word = tostring(word or ""):lower()
        if tonumber(word) then return tostring(tonumber(word)) end
        if NUMBER[word] then return tostring(NUMBER[word]) end
        local tens, ones = word:match("^(%a+)%-(%a+)$")
        if tens and NUMBER[tens] and NUMBER[ones] then return tostring(NUMBER[tens] + NUMBER[ones]) end
        return nil
    end
    local function LevelsSaid(plain, into)
        into = into or {}
        for word in plain:gmatch("[Ll]evel ([%w%-]+)") do local n = Num(word); if n then into[n] = true end end
        for a, b in plain:gmatch("[Ll]evel ([%w%-]+) to ([%w%-]+)") do local n = Num(b); if n then into[n] = true end end
        for a, b in plain:gmatch("from ([%w%-]+) to ([%w%-]+)") do local n1, n2 = Num(a), Num(b); if n1 then into[n1] = true end; if n2 then into[n2] = true end end
        for b in plain:gmatch("[Ll]evel [%w%-]+ to ([%w%-]+)") do local n = Num(b); if n then into[n] = true end end
        for b in plain:gmatch("ended it at ([%w%-]+)") do local n = Num(b); if n then into[n] = true end end
        for b in plain:gmatch("[Ll]evel ([%w%-]+) when I stopped") do local n = Num(b); if n then into[n] = true end end
        return into
    end
    C.LevelsSaid = C.LevelsSaid or function(plain) return LevelsSaid(plain) end
    local levelNums = LevelsSaid(chapterPlain)
    local function LevelLine(level, ep, at)
        local tokens = {level = tostring(level)}
        -- the deed just before it, the town it came at, or the zone
        local deed
        for _, x in ipairs(byEp[ep]) do
            if not x.drop and (x.cls == "quest" or x.cls == "what") and x.t <= at and at - x.t <= 300 and (not deed or x.t > deed.t) then deed = x end
        end
        if deed and W.levelWithIt then return Pick("levelWith", W.levelWithIt, tokens), deed end
        local near
        for _, x in ipairs(byEp[ep]) do
            if not x.drop and (x.cls == "quest" or x.cls == "what") and x.t <= at and at - x.t <= 20 * 60 and (not near or x.t > near.t) then near = x end
        end
        if near and P.levelSoon then return Pick("levelSoon", P.levelSoon, tokens), near end
        local town
        for _, s in ipairs(ep.scenes) do
            for _, e in ipairs(s.events or {}) do
                if (e.k == "rest" or e.k == "town" or e.k == "home") and e.d and math.abs((e.t or 0) - at) <= 120 and IsTown(e.d) then town = e.d end
            end
        end
        if town and P.levelAt then tokens.place = Place(town); return Pick("levelAt", P.levelAt, tokens), nil end
        if ep.zone and P.levelIn then tokens.zone = Place(ep.zone); return Pick("levelIn", P.levelIn, tokens), nil end
        return nil
    end
    local added = {}
    for _, l in ipairs(lines) do
        if l.cls == "level" and not inRun[l] then
            local plain = Plain(l.text)
            local num = Num(plain:match("[Ll]evel ([%w%-]+)"))
            local at = (l.meta.levelEarly and l.meta.t) or l.t
            local ep = EpisodeAt(at, episodes)
            if ep.kind == "dungeon" then
                -- (a level of the run is the run's to tell; said by the dungeon writer)
                l.ep = ep
            else
                l.ep, l.t = ep, at
                if num and (plain:match("^I reached level %d+ there%.$") or plain:match("^Level %d+ came there%.$")) then
                    local text, deed = LevelLine(num, ep, at)
                    if text then l.text = text; l.after = deed end
                end
            end
        end
    end
    local dayLevels = {}
    for _, s in ipairs(stretches) do
        for _, e in ipairs(s.events or {}) do if e.k == "mylevel" and e.d then dayLevels[#dayLevels + 1] = {level = tonumber(e.d) or e.d, t = e.t} end end
    end
    Sorted(dayLevels, function(a, b) return (a.t or 0) < (b.t or 0) end)
    local topLevel = dayLevels[#dayLevels]
    local topSaid = topLevel and levelNums[tostring(topLevel.level)]
    local spanFrom = #dayLevels >= 2 and tonumber(dayLevels[1].level) and (tonumber(dayLevels[1].level) - 1) or nil
    -- (several levels and the teller's own line for the last of them: that line becomes the span,
    -- where it stands, so no level is skipped in silence)
    if topLevel and topSaid and spanFrom and spanFrom >= 1 and W.levels then
        for _, l in ipairs(lines) do
            if l.cls == "level" and not inRun[l] and not l.drop and l.ep.kind ~= "dungeon" and LevelsSaid(Plain(l.text))[tostring(topLevel.level)] then
                local text = Pick("levels", W.levels, {from = tostring(spanFrom), level = tostring(topLevel.level)})
                if text then l.text = text; l.meta.compose = "level" end
                break
            end
        end
    end
    for _, lv in ipairs(dayLevels) do
        local num = tostring(lv.level)
        -- (only the day's last level gets a line of its own, a span when several came)
        if lv == topLevel and not topSaid and lv.t then
            local ep = EpisodeAt(lv.t, episodes)
            -- (a level the run claimed, with its hand-in after it, is the run's)
            for _, x in ipairs(episodes) do
                if x.kind == "dungeon" then for _, xl in ipairs(x.levels) do if xl.t == lv.t then ep = x end end end
            end
            if ep.kind == "dungeon" then
                local runSaid = false
                for _, x in ipairs(byEp[ep]) do if not x.drop and x.cls == "level" then runSaid = true end end
                if W.runLevel and not runSaid then
                    local text = spanFrom and P.runLevels and Pick("runLevels", P.runLevels, {from = tostring(spanFrom), level = num}) or Pick("runLevel", W.runLevel, {level = num})
                    if text then
                        levelNums[num] = true
                        -- (after the run's own lines: its time is the run's end)
                        added[#added + 1] = {cls = "level", t = ep.e, ep = ep, text = text, major = false, kind = "level", meta = {t = ep.e, compose = "level"}, n = #out + #added + 1}
                    end
                end
            else
                local text, deed = LevelLine(num, ep, lv.t)
                if spanFrom and W.levels then text = Pick("levels", W.levels, {from = tostring(spanFrom), level = num}) end
                if text then
                    levelNums[num] = true
                    added[#added + 1] = {cls = "level", t = lv.t, ep = ep, text = text, after = deed, major = false, kind = "level", meta = {t = lv.t, compose = "level"}, n = #out + #added + 1}
                end
            end
        end
    end
    -- h. a companion who left is told leaving, before whatever came next without them
    do
        local minutes = {}
        for name, spans in pairs(windows) do
            local n = 0
            for _, sp in ipairs(spans) do n = n + (sp[2] - sp[1]) end
            minutes[name] = n
        end
        local function PresentIn(name, ep)
            for _, sp in ipairs(windows[name] or {}) do if sp[1] <= (ep.e or ep.t) and sp[2] >= ep.t then return true end end
            return false
        end
        for i, ep in ipairs(episodes) do
            local before = episodes[i - 1]
            if before and P.left then
                for name in pairs(windows) do
                    if PresentIn(name, before) and not PresentIn(name, ep) and (minutes[name] or 0) >= 1800 and chapterPlain:find(name, 1, true) then
                        local text = Pick("left", P.left, {name = "{n:" .. name .. "}"})
                        local leftAt = ep.t
                        for _, sp in ipairs(windows[name] or {}) do if sp[2] <= ep.t and sp[2] > leftAt - 3600 then leftAt = sp[2] end end
                        if text then added[#added + 1] = {cls = "who", t = leftAt, ep = ep, text = text, major = false, kind = nil, meta = {t = leftAt, compose = "left"}, n = #out + #added + 1} end
                    end
                end
            end
        end
    end
    for _, l in ipairs(added) do lines[#lines + 1] = l; byEp[l.ep][#byEp[l.ep] + 1] = l end
    -- e. counts go to the close: a level span and the quest count sit before the close lines
    for _, l in ipairs(lines) do
        if not l.drop and not inRun[l] and l.ep.kind ~= "dungeon" then
            if l.cls == "milestone" then l.toClose, l.closeRank = true, 2 end
            if l.cls == "level" and l.meta.compose == "level" and not Plain(l.text):match("^Level %d+ came") and not Plain(l.text):match("^I reached level %d+ with it") then l.toClose, l.closeRank = true, 3 end
        end
    end
    for _, l in ipairs(lines) do
        if l.toClose and l.ep ~= episodes[#episodes] and episodes[#episodes].kind ~= "dungeon" then
            local from = byEp[l.ep]
            for i = #from, 1, -1 do if from[i] == l then table.remove(from, i) end end
            l.ep = episodes[#episodes]
            byEp[l.ep][#byEp[l.ep] + 1] = l
        end
    end

    -- 4. Inside each episode, the order of a told moment.
    local PRIORITY = {open = 1, arrive = 2, who = 3, place = 4, town = 5}
    local SLOT_WHAT = 6
    local function Slot(l, ep, firstWhat, lastWhat, passage)
        if l.toClose then return 9 end
        if ep.kind == "journey" and l.cls ~= "open" and l.cls ~= "close" and not (l.cls == "who" and l.t <= ep.t + 300) then return SLOT_WHAT end
        if l.cls == "who" and ep.kind ~= "deaths" and l.t > ep.t + 10 * 60 and l.t > (firstWhat or math.huge) + 300 then l.cut = true; return SLOT_WHAT end
        if PRIORITY[l.cls] then return PRIORITY[l.cls] end
        if l.cls == "level" or l.cls == "milestone" then return SLOT_WHAT end
        if (l.cls == "voyage" or l.cls == "night") and lastWhat and l.t < lastWhat then return SLOT_WHAT end
        if l.cls == "voyage" or l.cls == "night" or l.cls == "move" then return 9 end
        if l.cls == "close" then return 10 end
        -- (a bad stretch: the death passage is one unit, placed at the middle of its deaths, so
        -- the errand it happened inside keeps its own order around it)
        if ep.kind == "deaths" and passage and l.n >= passage[1] and l.n <= passage[2] then l.t = passage.t or l.t; l.inPassage = true end
        return SLOT_WHAT
    end
    local TIE = {quest = 0, who = 0, death = 1, what = 2, place = 2, town = 2, craft = 3}
    local paragraphs = {}
    for _, ep in ipairs(episodes) do
        local kept = {}
        for _, l in ipairs(byEp[ep]) do if not l.drop then kept[#kept + 1] = l end end
        if ep.kind == "dungeon" then
            -- (the run's lines in their writer's order; a line from elsewhere before or after them)
            Sorted(kept, function(a, b)
                local ra, rb = inRun[a] and 1 or (a.t < ep.t and 0 or 2), inRun[b] and 1 or (b.t < ep.t and 0 or 2)
                if ra ~= rb then return ra < rb end
                if ra == 1 then return a.n < b.n end
                if a.t ~= b.t then return a.t < b.t end
                return a.n < b.n
            end)
        else
            local firstWhat, lastWhat, passage
            for _, l in ipairs(kept) do
                if l.cls == "quest" or l.cls == "what" or l.cls == "death" then
                    if not firstWhat or l.t < firstWhat then firstWhat = l.t end
                    if not lastWhat or l.t > lastWhat then lastWhat = l.t end
                end
                if l.cls == "death" and l.n <= #out then
                    passage = passage or {l.n, l.n}
                    if l.n < passage[1] then passage[1] = l.n end
                    if l.n > passage[2] then passage[2] = l.n end
                end
            end
            if passage and ep.kind == "deaths" then
                local mine = {}
                for _, d in ipairs(ep.deaths) do if d.mine then mine[#mine + 1] = d.t end end
                if #mine == 0 then for _, d in ipairs(ep.deaths) do mine[#mine + 1] = d.t end end
                passage.t = mine[math.max(1, math.ceil(#mine / 2))]
            end
            for _, l in ipairs(kept) do l.slot = Slot(l, ep, firstWhat, lastWhat, passage) end
            Sorted(kept, function(a, b)
                if a.slot ~= b.slot then return a.slot < b.slot end
                if a.slot == SLOT_WHAT or a.slot == 8 then
                    if a.t ~= b.t then return a.t < b.t end
                    if a.inPassage and b.inPassage then return a.n < b.n end
                    local ta, tb = TIE[a.cls] or 1, TIE[b.cls] or 1
                    if ta ~= tb then return ta < tb end
                end
                if a.slot == 3 then
                    if a.t ~= b.t then return a.t < b.t end
                end
                if a.slot == 9 then
                    if (a.toClose and 1 or 0) ~= (b.toClose and 1 or 0) then return (a.toClose and 1 or 0) < (b.toClose and 1 or 0) end
                    if a.toClose and b.toClose and (a.closeRank or 9) ~= (b.closeRank or 9) then return (a.closeRank or 9) < (b.closeRank or 9) end
                end
                return a.n < b.n
            end)
            -- (a level goes right after the deed it came with)
            for i = #kept, 1, -1 do
                local l = kept[i]
                if l.cls == "level" and l.after and not l.toClose then
                    local at
                    for j, x in ipairs(kept) do if x == l.after then at = j end end
                    if at and at < i then table.remove(kept, i); table.insert(kept, at + 1, l) end
                end
            end
        end
        -- (a lone death is told inside the deed it interrupted: joined to the quest line before it
        -- when that line can take a clause, so it never stands alone between errands)
        if ep.kind ~= "dungeon" then
            for i = 2, #kept do
                local l, prev = kept[i], kept[i - 1]
                if l and prev and l.cls == "death" and not l.inPassage and l.kind == "death" and prev.cls == "quest" and l.t - prev.t <= 15 * 60 and l.t >= prev.t
                    and Words(l.text) <= 14 and not Plain(l.text):find("%. ") then
                    local head, lastSentence = prev.text:match("^(.*%. )([^%.]+%.)$")
                    if not head then head, lastSentence = "", prev.text end
                    if lastSentence and not lastSentence:find(", and ", 1, true) and not lastSentence:find(" and ", 1, true) and lastSentence:match("%.$") and Words(lastSentence) <= 22 then
                        local clause = l.text
                        if not clause:match("^I ") and not clause:match("^{") then clause = clause:gsub("^%u", string.lower) end
                        prev.text = head .. lastSentence:gsub("%.$", "") .. ", and " .. clause
                        prev.merged = true
                        l.drop = true
                    end
                end
            end
            local kept2 = {}
            for _, l in ipairs(kept) do if not l.drop then kept2[#kept2 + 1] = l end end
            kept = kept2
        end
        -- (the chapter's figure: the quest that sent me to them is told before the meeting, the
        -- meeting and its lore next, the quest's outcome after; the block is its own paragraph)
        if ep.kind ~= "dungeon" then
            local figureAt
            for i, l in ipairs(kept) do if l.meta.figure and not figureAt then figureAt = i end end
            if figureAt then
                local fig = kept[figureAt]
                local name = Clean(fig.meta.figure)
                local short = (A.Lore and A.Lore.Short and A.Lore.Short(name)) or name:match("(%S+)$") or name
                if short == name then short = name:match("^(%S+)") or name end
                local entry
                for _, l in ipairs(kept) do
                    if l ~= fig and l.cls == "quest" and l.meta.entry and (Plain(l.text):find(name, 1, true) or Plain(l.text):find("%f[%a]" .. Esc(short) .. "%f[%A]")) then entry = l.meta.entry; break end
                end
                if entry then
                    local block, rest = {}, {}
                    local starts, outcomes = {}, {}
                    -- (a line whose first sentence is the sending and whose later ones are the audience splits there)
                    for i = #kept, 1, -1 do
                        local l = kept[i]
                        if l.cls == "quest" and l.meta.entry == entry and l.kind ~= "questOutcome" and not l.meta.outcome then
                            local first, tail = l.text:match("^(.-%.) (.+)$")
                            if first and tail and not (Plain(first):find(name, 1, true) or Plain(first):find("%f[%a]" .. Esc(short) .. "%f[%A]")) then
                                local t2 = {}
                                for k, v in pairs(l) do t2[k] = v end
                                t2.text, t2.kind, t2.n = tail, "questOutcome", l.n + 0.5
                                t2.meta = {}
                                for k, v in pairs(l.meta) do t2.meta[k] = v end
                                t2.meta.outcome = true
                                l.text = first
                                table.insert(kept, i + 1, t2)
                            end
                        end
                    end
                    for _, l in ipairs(kept) do
                        if l.cls == "quest" and l.meta.entry == entry then
                            if l.kind == "questOutcome" or l.meta.outcome then outcomes[#outcomes + 1] = l else starts[#starts + 1] = l end
                        end
                    end
                    local lore
                    for _, l in ipairs(kept) do if l ~= fig and l.kind == "lore" and math.abs(l.t - fig.t) <= 120 and Plain(l.text):find(short, 1, true) then lore = l end end
                    for _, l in ipairs(starts) do block[#block + 1] = l end
                    block[#block + 1] = fig
                    if lore then block[#block + 1] = lore end
                    for _, l in ipairs(outcomes) do block[#block + 1] = l end
                    local inBlock = {}
                    for _, l in ipairs(block) do inBlock[l] = true end
                    local at
                    for i, l in ipairs(kept) do if inBlock[l] and not at then at = i end end
                    for _, l in ipairs(kept) do if not inBlock[l] then rest[#rest + 1] = l end end
                    local merged = {}
                    local placed = false
                    for i, l in ipairs(rest) do
                        if not placed and (i >= at or l.slot >= 9) then
                            for _, b in ipairs(block) do merged[#merged + 1] = b end
                            placed = true
                        end
                        merged[#merged + 1] = l
                    end
                    if not placed then for _, b in ipairs(block) do merged[#merged + 1] = b end end
                    block[1].cut = true
                    if #merged > 0 then
                        local after
                        for i, l in ipairs(merged) do if l == block[#block] then after = merged[i + 1] end end
                        if after and after.slot and after.slot < 9 then after.cut = true end
                    end
                    kept = merged
                end
            end
        end
        -- (an episode in another place than the one before opens with the move between them)
        if ep.kind ~= "dungeon" and ep.index > 1 and #kept > 0 then
            local prevEp = episodes[ep.index - 1]
            local opens = false
            local placeName = Clean(ep.zone or "")
            for j, l in ipairs(kept) do
                if l.cls == "open" or l.cls == "arrive" or l.cls == "place" or (l.cls == "voyage" and l.slot ~= 9) then opens = true end
                if j <= 3 and placeName ~= "" and Plain(l.text):find(placeName, 1, true) then opens = true end
            end
            if not opens and prevEp and Clean(prevEp.zone or "") ~= Clean(ep.zone or "") then
                local how, voyageHow, howT
                for _, s in ipairs(stretches) do
                    for _, e in ipairs(s.events or {}) do
                        local t = e.t or 0
                        -- (the last transit record before the episode is the one that brought us)
                        if t >= (prevEp.e or prevEp.t) - 300 and t <= ep.t + 60 and (not howT or t >= howT) then
                            if e.k == "nightflight" or e.k == "taxi" then how, howT = "flew", t
                            elseif e.k == "voyage" and e.d ~= "hearth" and e.d ~= "portal" then how, voyageHow, howT = "voyage", e.d, t
                            elseif e.k == "hearth" then how, howT = "hearth", t end
                        end
                    end
                end
                local town
                for _, s in ipairs(ep.scenes) do
                    for _, e in ipairs(s.events or {}) do
                        if e.k == "town" and e.d and (e.t or 0) >= ep.t and (e.t or 0) - ep.t <= 300 and IsTown(e.d) and not town then town = e.d end
                    end
                end
                local party = WithAtDay(windows, ep.t)
                local tokens = {We = party and "We" or "I", we = party and "we" or "I", us = party and "us" or "me", place = Place(town or ep.zone), how = voyageHow or "boat"}
                local pool = (how == "flew" and P.moveFlew) or (how == "voyage" and P.moveVoyage) or (how == "hearth" and P.moveHearth) or P.moveWent
                local text = pool and Pick("move:" .. tostring(how), pool, tokens)
                if text then
                    local l = {cls = "arrive", t = ep.t, ep = ep, text = text, major = false, kind = "move", meta = {t = ep.t, compose = "move"}, n = #out + 500 + ep.index, slot = 2}
                    table.insert(kept, 1, l)
                    -- (after the opener or a join, if any)
                    local at = 1
                    for j, x in ipairs(kept) do if x ~= l and (x.cls == "open" or x.cls == "who") and x.slot and x.slot <= 3 then at = j end end
                    if at > 1 then table.remove(kept, 1); table.insert(kept, at, l) end
                end
            end
        end
        -- (a journey names where it led; the stops after the first fold into one clause)
        if ep.kind == "journey" and P.byWay then
            local towns, firstTown = {}, nil
            for _, l in ipairs(kept) do
                if l.cls == "town" then
                    if not firstTown then firstTown = l
                    elseif l.meta.e and l.meta.e.d then towns[#towns + 1] = l end
                end
            end
            if #towns >= 1 and firstTown then
                local names = {}
                for _, l in ipairs(towns) do names[#names + 1] = Place(l.meta.e.d); l.drop = true end
                local we = #ep.party > 0 and "We" or "I"
                towns[1].drop = false
                towns[1].text = Pick("byWay", P.byWay, {We = we, us = #ep.party > 0 and "us" or "me", stops = List(names)})
                towns[1].cls = "what"
                local kept2 = {}
                for _, l in ipairs(kept) do if not l.drop then kept2[#kept2 + 1] = l end end
                kept = kept2
            end
        end
        if #kept > 0 then
            local words = 0
            for _, l in ipairs(kept) do words = words + Words(l.text) end
            paragraphs[#paragraphs + 1] = {ep = ep, lines = kept, words = words, kind = ep.kind, weight = ep.weight}
        end
    end
    if #paragraphs == 0 then return false end

    -- 5. Paragraphs: a light one joins the next (or the last joins the one before), two bad
    -- stretches side by side are one, never more than C.MAX_PARAGRAPHS, a long one splits at a turn.
    local function Join(a, b)
        for _, l in ipairs(b.lines) do a.lines[#a.lines + 1] = l end
        a.words, a.weight = a.words + b.words, a.weight + b.weight
        if b.kind == "dungeon" or (b.kind == "deaths" and a.kind ~= "dungeon") then a.kind = b.kind end
        if b.ep.night then a.ep = b.ep end
    end
    local i = 1
    while i <= #paragraphs do
        local p = paragraphs[i]
        local nxt, prev = paragraphs[i + 1], paragraphs[i - 1]
        if (p.words < C.MIN_WORDS or #p.lines <= 2) and nxt and nxt.kind ~= "dungeon" then
            Join(p, nxt); table.remove(paragraphs, i + 1)
        elseif nxt and nxt.kind ~= "dungeon" and p.kind ~= "dungeon" and p.kind ~= "deaths" and (p.ep.e - p.ep.t) < 10 * 60 and p.words + nxt.words <= C.MAX_WORDS then
            -- (a stop of a few minutes is a clause of what it led to)
            Join(p, nxt); table.remove(paragraphs, i + 1)
        elseif p.words < C.MIN_WORDS and nxt and nxt.kind == "dungeon" and p.kind ~= "dungeon" and p.words + nxt.words <= C.MAX_WORDS then
            Join(p, nxt); table.remove(paragraphs, i + 1)
        elseif (p.words < C.MIN_WORDS or #p.lines <= 2) and not nxt and prev and prev.kind ~= "dungeon" then
            Join(prev, p); table.remove(paragraphs, i)
        elseif p.kind == "deaths" and nxt and nxt.kind == "deaths" and p.words + nxt.words <= C.MAX_WORDS then
            Join(p, nxt); table.remove(paragraphs, i + 1)
        elseif #p.lines <= 1 and prev and prev.kind ~= "dungeon" and p.kind ~= "dungeon" then
            Join(prev, p); table.remove(paragraphs, i)
        else
            i = i + 1
        end
    end
    while #paragraphs > C.MAX_PARAGRAPHS do
        local best, bestAt
        for j = 1, #paragraphs - 1 do
            local a, b = paragraphs[j], paragraphs[j + 1]
            if a.kind ~= "dungeon" and b.kind ~= "dungeon" then
                local w = a.words + b.words
                if not best or w < best then best, bestAt = w, j end
            end
        end
        if not bestAt then break end
        Join(paragraphs[bestAt], paragraphs[bestAt + 1]); table.remove(paragraphs, bestAt + 1)
    end
    if C.Debug then
        for pi, p in ipairs(paragraphs) do
            C.Debug(("para %d ep%d %s words=%d span=%s-%s"):format(pi, p.ep.index, p.kind, p.words, Clock(p.ep.t), Clock(p.ep.e)))
            for _, l in ipairs(p.lines) do C.Debug(("   %s slot=%s %-7s %s"):format(Clock(l.t), tostring(l.slot), l.cls, Plain(l.text):sub(1, 60))) end
        end
    end
    -- (a tally never follows the day's true last beat: a told story's outcome closes the story)
    do
        local last = paragraphs[#paragraphs]
        local lastBeat
        for i = #last.lines, 1, -1 do
            local l = last.lines[i]
            if not l.toClose and l.cls ~= "close" then lastBeat = l; break end
        end
        if lastBeat and lastBeat.cls == "quest" and lastBeat.meta.entry and lastBeat.meta.entry.story and lastBeat.kind ~= "quests" then
            last.trueEnd = true
            for i = #last.lines, 1, -1 do
                local l = last.lines[i]
                if l.toClose and l.cls == "craft" then table.remove(last.lines, i); last.words = last.words - Words(l.text) end
            end
        end
    end
    -- 6. The close: what the evening came to, then where it ended, from the record only.
    do
        local last = paragraphs[#paragraphs]
        local lastLine = last.lines[#last.lines]
        local lastPlain = Plain(lastLine.text):lower()
        local party = false
        for _, ep in ipairs(episodes) do if #ep.party > 0 then party = true end end
        local we, us = party and "we" or "I", party and "us" or "me"
        local phrases = {}
        local ranked = {}
        for _, ep in ipairs(episodes) do ranked[#ranked + 1] = ep end
        Sorted(ranked, function(a, b) if a.weight ~= b.weight then return a.weight > b.weight end return a.t < b.t end)
        local dayPlan = ctx.dayPlan
        local saidGivers, giverPhrases = {}, {}
        local keptPlain = {}
        for _, p in ipairs(paragraphs) do for _, l in ipairs(p.lines) do keptPlain[#keptPlain + 1] = Plain(l.text) end end
        keptPlain = table.concat(keptPlain, " ")
        for _, ep in ipairs(ranked) do
            if #phrases >= 1 then break end
            local o = ep.outcome
            local epParty = #ep.party > 0
            if o and o.kind == "dungeon" and o.bosses > 0 then
                if o.lordKilled and P.closeDungeonDone then
                    phrases[#phrases + 1] = Fill(P.closeDungeonDone[1], {dungeon = Place(o.dungeon), us = epParty and "us" or "me"})
                end
            elseif o and o.kind == "deaths" and ep.mine >= 2 and o.place and Clean(o.place) ~= Clean(ep.zone or "") and not IsTown(o.place) then
                local named = A.FoeNamed and A.FoeNamed(o.foe) or (A.SelfTale and A.SelfTale.CommonFoe and not A.SelfTale.CommonFoe(o.foe))
                local killedAfter = false
                for _, s in ipairs(stretches) do
                    for _, e in ipairs(s.events or {}) do if (e.k == "boss" or e.k == "kill") and e.d and Clean(e.d) == Clean(o.foe) and (e.t or 0) > o.t then killedAfter = true end end
                end
                if named and not killedAfter and P.closeFoeHeld then
                    phrases[#phrases + 1] = Fill(P.closeFoeHeld[1], {foe = Place(o.foe), place = Place(o.place)})
                end
            elseif dayPlan and (ep.kind == "field" or ep.kind == "deaths") then
                -- the told quest the chapter weighed most in this episode, by the one who asked
                local best
                for _, e in ipairs(dayPlan.entries or {}) do
                    if e.mention and e.quest and e.story then
                        for _, q in ipairs(ep.quests) do
                            if q.quest == e.quest and (not best or (e.worth or 0) > (best.worth or 0)) then best = e end
                        end
                    end
                end
                local giver = best and ((best.act and best.act.giver) or (best.story and best.story.pov and best.story.pov.giver))
                if giver and not saidGivers[giver] and #giverPhrases < 2 and keptPlain:find(Clean(giver):match("(%S+)$") or "", 1, true) then
                    saidGivers[giver] = true
                    giverPhrases[#giverPhrases + 1] = Clean(giver)
                    phrases[#phrases + 1] = false -- (placed once, below)
                end
            end
        end
        local sum = {}
        for _, ph in ipairs(phrases) do if ph then sum[#sum + 1] = ph end end
        -- (the chapter's largest thing closes it; the work-for line only when it has no outcome)
        if #sum == 0 and #giverPhrases > 0 and P.closeWork and not last.trueEnd then sum[#sum + 1] = Fill(P.closeWork[1], {givers = List(giverPhrases[1] and {giverPhrases[1]} or {}), was = "was"}) end
        local closeLines = {}
        if #sum > 0 then
            local text
            if #sum == 1 then text = Cap(sum[1]) .. "."
            elseif #sum == 2 then text = Cap(sum[1]) .. ", and " .. sum[2] .. "."
            else text = Cap(sum[1]) .. ", " .. sum[2] .. " and " .. sum[3] .. "." end
            closeLines[#closeLines + 1] = text
        end
        -- where the night ended
        local total, wall = 0, (D.e or 0) - (D.t or 0)
        for _, sc in ipairs(ctx.day.scenes or {}) do
            if (not sc.kind or sc.kind == "outing") and sc.zone then total = total + ((sc.e or sc.t or 0) - (sc.t or 0)) end
        end
        if total <= 0 then total = wall end
        local gapped = wall - total > 3600
        local hearthHome = Any(lastPlain, {"hearthstone took me home", "hearthstone brought me home", "went home to"})
        if total >= 3600 and not hearthHome then
            local hours = total / 3600
            local whole = math.floor(hours)
            local frac = hours - whole
            local span
            local WORDS = {[1] = "an hour", [2] = "two hours", [3] = "three hours", [4] = "four hours", [5] = "five hours", [6] = "six hours", [7] = "seven hours",
                [8] = "eight hours", [9] = "nine hours", [10] = "ten hours", [11] = "eleven hours", [12] = "twelve hours"}
            if frac >= 0.6 then span = "nearly " .. (WORDS[whole + 1] or ((whole + 1) .. " hours"))
            elseif frac >= 0.3 then span = "over " .. (WORDS[whole] or (whole .. " hours"))
            else span = WORDS[whole] or (whole .. " hours") end
            if whole == 1 and frac < 0.3 then span = "an hour" end
            local crossings = D.voyages
            local CROSS = {[1] = "one sea crossing", [2] = "two sea crossings", [3] = "three sea crossings", [4] = "four sea crossings"}
            local hour = tonumber(date and date("%H", D.e or 0) or 22) or 22
            local part = (hour >= 20 or hour < 5) and "night" or hour >= 17 and "evening" or hour >= 12 and "afternoon" or "day"
            local from = D.from or D.fromZone
            local fromName = from and Place(from) or nil
            local inn = A.SelfTale and A.SelfTale.InnName and from and A.SelfTale.InnName(from)
            if inn then fromName = inn end
            local endPlace = (D.sleep and D.sleep.place) or D.endTown or D.endZone
            local endZone = (D.sleep and D.sleep.zone) or D.endZone
            -- (a corner of a city, "Trade Quarter" or "Canals", is told as the city)
            if endPlace and not IsTown(endPlace) and not (A.SelfTale and A.SelfTale.InnName and A.SelfTale.InnName(endPlace)) and endZone then endPlace = endZone end
            local endInn = A.SelfTale and A.SelfTale.InnName and endPlace and A.SelfTale.InnName(endPlace)
            local endName = endInn or (endPlace and Place(endPlace)) or nil
            local same = from and endPlace and Clean(from) == Clean(endPlace)
            local tokens = {I = party and "we" or "I", place = endName, at = endInn and "at" or "in", atFrom = inn and "at" or "in", span = span, from = fromName, part = part,
                crossings = CROSS[crossings] or (crossings .. " sea crossings")}
            local pool
            if gapped then
                -- (a day played in two sittings hours apart: where it ended, without a span)
                pool = D.sleep and P.closeSleepShort or P.closeEndShort
            elseif D.sleep then
                pool = same and P.closeSleepSame or (crossings > 0 and P.closeSleepFar) or P.closeSleepNear
            else
                pool = same and P.closeEndSame or (crossings > 0 and P.closeEndFar) or P.closeEndNear
            end
            if endName and (fromName or same or gapped) then
                local text = Pick("closeEnd", pool, tokens)
                if text then closeLines[#closeLines + 1] = Cap(text) end
            end
        end
        for _, text in ipairs(closeLines) do
            local l = {cls = "close", t = D.e or 0, ep = last.ep, text = text, major = true, kind = "close", meta = {t = D.e, compose = "close"}, n = #out + #added + #last.lines + 1}
            last.lines[#last.lines + 1] = l
            last.words = last.words + Words(text)
        end
    end

    -- a companion who joined late in a long stay opens a new paragraph there
    do
        local cutList = {}
        for _, p in ipairs(paragraphs) do
            local rest = p
            while true do
                local at
                local acc = 0
                for j, l in ipairs(rest.lines) do
                    if j > 1 and l.cut and not inRun[l] and acc >= C.MIN_WORDS and rest.words - acc >= C.MIN_WORDS then at = j; break end
                    acc = acc + Words(l.text)
                end
                if not at then break end
                local head = {ep = rest.ep, lines = {}, words = 0, kind = rest.kind, weight = rest.weight}
                for j = 1, at - 1 do head.lines[#head.lines + 1] = rest.lines[j]; head.words = head.words + Words(rest.lines[j].text) end
                local tail = {ep = rest.ep, lines = {}, words = 0, kind = rest.kind, weight = rest.weight}
                for j = at, #rest.lines do tail.lines[#tail.lines + 1] = rest.lines[j]; tail.words = tail.words + Words(rest.lines[j].text) end
                cutList[#cutList + 1] = head
                rest = tail
            end
            cutList[#cutList + 1] = rest
        end
        paragraphs = cutList
    end
    -- the split of a long paragraph: at a new quest, the first death, a move or a level, near the middle
    local pieces = {}
    for _, p in ipairs(paragraphs) do
        local rest = p
        local ceiling = (rest.kind == "deaths") and C.MAX_WORDS_DEATHS or C.MAX_WORDS
        while rest.words > ceiling and #rest.lines >= 2 do
            -- (the head: the most that fits under the ceiling and ends at a turn, a new story
            -- moment first, a grouped line or a death next; the tail is split again in its turn)
            local acc, bestAt, bestScore = 0, nil, nil
            for j = 1, #rest.lines - 1 do
                acc = acc + Words(rest.lines[j].text)
                local nxt = rest.lines[j + 1]
                local turn = nxt.cls == "quest" or (nxt.cls == "death" and nxt.inPassage) or nxt.cls == "move" or nxt.cls == "voyage" or nxt.cls == "night" or nxt.cls == "level" or nxt.cls == "who"
                local prevCls = rest.lines[j].cls
                local inside = (rest.lines[j].meta.entry and nxt.meta.entry and rest.lines[j].meta.entry == nxt.meta.entry)
                    or (prevCls == "death" and nxt.cls == "death") or (rest.lines[j].inPassage and nxt.inPassage)
                    or (inRun[rest.lines[j]] and inRun[nxt])
                    or prevCls == "arrive" or prevCls == "move" or prevCls == "open" or prevCls == "who"
                if turn and not inside and acc >= C.MIN_WORDS and acc <= ceiling and rest.words - acc >= C.MIN_WORDS and j >= 3 and #rest.lines - j >= 3 then
                    local score = acc + ((nxt.kind == "questStart" and nxt.meta.entry) and 15 or 0) + (nxt.cls == "death" and 10 or 0)
                    if not bestScore or score > bestScore then bestScore, bestAt = score, j end
                end
            end
            if not bestAt then
                -- (no turn under the ceiling: the last line boundary under it that is not inside one moment)
                acc = 0
                for j = 1, #rest.lines - 1 do
                    acc = acc + Words(rest.lines[j].text)
                    local nxt = rest.lines[j + 1]
                    local inside = (rest.lines[j].meta.entry and nxt.meta.entry and rest.lines[j].meta.entry == nxt.meta.entry) or (inRun[rest.lines[j]] and inRun[nxt])
                        or (rest.lines[j].inPassage and nxt.inPassage) or rest.lines[j].cls == "arrive" or rest.lines[j].cls == "move" or rest.lines[j].cls == "open" or rest.lines[j].cls == "who"
                    if not inside and acc >= C.MIN_WORDS and acc <= ceiling and rest.words - acc >= C.MIN_WORDS and j >= 3 and #rest.lines - j >= 3 then bestAt = j end
                end
            end
            if not bestAt then break end
            local head = {ep = rest.ep, lines = {}, words = 0, kind = rest.kind, weight = rest.weight}
            for j = 1, bestAt do head.lines[#head.lines + 1] = rest.lines[j]; head.words = head.words + Words(rest.lines[j].text) end
            local tail = {ep = rest.ep, lines = {}, words = 0, kind = rest.kind, weight = rest.weight}
            for j = bestAt + 1, #rest.lines do tail.lines[#tail.lines + 1] = rest.lines[j]; tail.words = tail.words + Words(rest.lines[j].text) end
            pieces[#pieces + 1] = head
            rest = tail
        end
        pieces[#pieces + 1] = rest
    end
    paragraphs = pieces

    -- (a connective that leaned on the line before it does not open a paragraph, nor follow an
    -- arrival, an opener or a join that was not there when the teller wrote it)
    for _, p in ipairs(paragraphs) do
        for i, l in ipairs(p.lines) do
            local prev = p.lines[i - 1]
            if not inRun[l] and (l.cls == "quest" or l.cls == "what") and (i == 1 or prev.cls == "arrive" or prev.cls == "open" or prev.cls == "who" or prev.cls == "place") then
                local cut = l.text:match("^After that, (.*)$") or l.text:match("^After this, (.*)$") or l.text:match("^Then (.*)$") or l.text:match("^From there (.*)$")
                if cut and not cut:match("^%u%l+ %u") then l.text = Cap(cut) end
            end
        end
    end
    -- ("There" points at the line before: after a death, a join or a level it points at nothing)
    for _, p in ipairs(paragraphs) do
        for i = 2, #p.lines do
            local l, prev = p.lines[i], p.lines[i - 1]
            if not inRun[l] and (prev.cls == "death" or prev.cls == "who" or prev.cls == "level") then
                if l.text:match("^There I ") then l.text = l.text:gsub("^There I ", "I ")
                elseif l.text:match("^There, %a") then l.text = l.text:gsub("^There, (%a)", function(c) return c:upper() end) end
            end
        end
    end
    -- (two sentences in a row opening on "We" or "I": a grouped line after one takes "Then", once in a row)
    for _, p in ipairs(paragraphs) do
        for i = 2, #p.lines do
            local l, prev = p.lines[i], p.lines[i - 1]
            local word = l.text:match("^(%u%l*) ")
            if not inRun[l] and l.kind == "quests" and not l.meta.sel and word and (word == "We" or word == "I") and prev.text:match("^" .. word .. " ") and not prev.text:match("^Then ")
                and not l.text:find("^[WI][e]? also") then
                l.text = "Then " .. (word == "I" and "I" or "we") .. l.text:sub(#word + 1)
            end
        end
    end
    -- (the hearthstone set "there" names its place; the line before it may not)
    for _, p in ipairs(paragraphs) do
        for i, l in ipairs(p.lines) do
            if l.meta.e and l.meta.e.k == "home" and l.meta.e.d and l.text:match(" there%.$") then
                local prev = p.lines[i - 1]
                local named = prev and Plain(prev.text):find(Clean(l.meta.e.d), 1, true)
                if not named then
                    local inn = A.SelfTale and A.SelfTale.InnName and A.SelfTale.InnName(l.meta.e.d)
                    l.text = l.text:gsub(" there%.$", (inn and (" at " .. inn) or (" in " .. Place(l.meta.e.d))) .. ".")
                end
            end
        end
    end
    -- (a tally never ends a paragraph: it steps back one line)
    for _, p in ipairs(paragraphs) do
        if #p.lines >= 2 and p.lines[#p.lines].cls == "craft" and not p.lines[#p.lines].toClose then
            local tally = table.remove(p.lines)
            table.insert(p.lines, #p.lines, tally)
        end
    end
    -- 7. Write back, one paragraph id per scene.
    -- (a level number is said once a chapter: a line of the composer's that repeats one goes)
    do
        local seen = {}
        for _, p in ipairs(paragraphs) do
            for i = #p.lines, 1, -1 do
                local l = p.lines[i]
                if l.meta.compose == "level" then
                    local said = LevelsSaid(Plain(l.text))
                    local dup = false
                    for _, q in ipairs(paragraphs) do
                        for _, x in ipairs(q.lines) do
                            if x ~= l then for n in pairs(LevelsSaid(Plain(x.text))) do if said[n] then dup = true end end end
                        end
                    end
                    if dup then table.remove(p.lines, i); p.words = p.words - Words(l.text) end
                end
            end
        end
    end
    -- (the selection's people: the full name where the chapter first says it, the short name after)
    if sel and A.SelfPlan.Sel.Titles then
        local seq = {}
        for _, p in ipairs(paragraphs) do for _, l in ipairs(p.lines) do seq[#seq + 1] = l end end
        A.SelfPlan.Sel.Titles(sel, seq)
    end
    local nOut, nMajors, nKinds, nTimes, nScenes, nMetas = {}, {}, {}, {}, {}, {}
    for pi, p in ipairs(paragraphs) do
        for _, l in ipairs(p.lines) do
            local at = #nOut + 1
            nOut[at], nMajors[at], nKinds[at], nScenes[at] = l.text, l.major or false, l.kind, 1000 + pi
            nTimes[at] = l.n <= #out and times[l.n] or l.t
            nMetas[at] = l.meta
            nMetas[at].paragraph = pi
        end
    end
    for n = 1, math.max(#out, #nOut) do
        out[n], majors[n], kinds[n], times[n], scenes[n], metas[n] = nOut[n], nMajors[n], nKinds[n], nTimes[n], nScenes[n], nMetas[n]
    end
    ctx.episodes, ctx.paragraphs = episodes, paragraphs
    -- (what the book now holds, for the selection of the chapters to come: a name told once)
    if ctx.history and ctx.history.plan then ctx.history.plan.text = (ctx.history.plan.text or "") .. " " .. Plain(table.concat(nOut, " ")) end
    return true
end

return C
