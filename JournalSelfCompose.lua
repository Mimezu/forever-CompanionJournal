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
C.MAX_WORDS_ADVENTURE = 200  -- an adventure (lane O8) is one paragraph: the place and the want, the fight, its cost, what came of it
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
-- A death line as a clause: no cleft ("It was X that killed me"), no ledger tail ("as well,
-- before the day was out"), no full stop, lower case unless it opens on "I" or a name.
local function DeathClause(text)
    local clause = text:gsub("%.$", "")
    clause = clause:gsub("^It was (.-) that killed me$", "%1 killed me")
    clause = clause:gsub(" as well, before the day was out$", ""):gsub(", before the day was out$", ""):gsub(" as well$", ""):gsub(" too$", ""):gsub(" as well,", ",")
    clause = clause:gsub("^[Ll]ater that %a+, ", ""):gsub("^[Ll]ater, ", ""):gsub("^Before the day was out, ", "")
    -- (round 17, reader S: "got me too, my second death of the day" is a ledger; a clause says the death)
    clause = clause:gsub(" too, my %a+ death of the day", ""):gsub(", my %a+ death of the day", ""):gsub(" too,", ",")
    -- (lane O8: "Dahlia fell twice before a refugee killed me" as a clause is "... and a refugee killed me")
    clause = clause:gsub(" before (.-) killed me", " and %1 killed me"):gsub(" before (.-) finished me", " and %1 finished me")
    return Lower(clause)
end
local function PartOfDay(t)
    local h = tonumber(date and date("%H", t or 0)) or 12
    return (h >= 5 and h < 12 and "morning") or (h >= 12 and h < 18 and "afternoon") or (h >= 18 and h < 22 and "evening") or "night"
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
local function Select(ctx, lines, inRun, episodes, D)
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
    -- (what the chapter's other lines say: a name they hold needs no promised step)
    do
        local known = {}
        for _, l in ipairs(lines) do
            if not l.drop and (l.cls ~= "quest" or inRun[l]) and l.cls ~= "close" then known[#known + 1] = Plain(l.text) end
        end
        sel.knownText = table.concat(known, " ")
    end
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
    -- (lane S: the names the next days' work carries, from the record's own quests; a dropped
    -- step that first names one is told after all, Sel.Promised, so a later chapter's "the
    -- ring" has its ring)
    do
        local later, givers = {}, {}
        local lim = (D and D.e or 0) + 3 * 86400
        if ctx.person and type(ctx.person.journal) == "table" and QD.Story then
            for _, e in ipairs(ctx.person.journal) do
                if e.k == "quest" and e.t and e.t > (D and D.e or 0) and e.t <= lim then
                    local ok, story = pcall(QD.Story, {title = e.d, qid = e.qid})
                    if ok and type(story) == "table" and type(story.pov) == "table" then
                        local texts, giver = {}, Plain(tostring(story.pov.giver or ""))
                        for _, x in ipairs(story.pov) do if type(x) == "string" then texts[#texts + 1] = x end end
                        if type(story.pov.act) == "string" then texts[#texts + 1] = story.pov.act end
                        for word in giver:gmatch("%a+") do givers[word] = true end
                        for _, x in ipairs(texts) do
                            for name in pairs(C.BareNames(Plain(x), true)) do
                                later[name] = true
                                if C.Debug then C.Debug(("promised %s <- %s"):format(name, Plain(x):sub(1, 90))) end
                            end
                        end
                    end
                end
            end
        end
        -- (whoever gives work later is introduced by that work; a place of the record is no person)
        for name in pairs(givers) do later[name] = nil end
        for _, e in ipairs(ctx.person and type(ctx.person.journal) == "table" and ctx.person.journal or {}) do
            for _, field in ipairs({e.sz, e.z, (e.k == "town" or e.k == "rest" or e.k == "cave" or e.k == "first") and e.d or nil}) do
                if type(field) == "string" then for word in field:gmatch("%a+") do later[word] = nil end end
            end
        end
        sel.promised = later
    end
    Sel.Peaks(sel)
    Sel.Choose(sel)
    Sel.Persons(sel)
    -- (lane O8, the player on Pyrewood: a stay of quest work in one place with deaths inside it and a
    -- fight-type quest, an ambush, a council, a named group fought beside, is an ADVENTURE: the fight
    -- is told in its full account at its own time whatever the budget, and the composer tells the
    -- episode as one paragraph, the place and the want, the fight, its cost, what came of it)
    for _, u in ipairs(sel.units or {}) do
        if u.kind == "act" and not u.promote then
            local ep = EpisodeAt(u.t or 0, episodes)
            if (ep.kind == "field" or ep.kind == "deaths") and #ep.quests >= 2 and (ep.mine >= 1 or ep.theirs >= 2) then
                local full = Sel.Account(sel, u)
                if full and C.FightAccount(full, u.plain) then
                    u.promote, u.mode, u.must = u.variant or 1, "full", true
                    local it = u.it
                    it.chosen = it.chosen or {}
                    it.chosen[u.act.i] = true
                    it.pick, it.keep = true, true
                    ep.adventure = ep.adventure or {t = u.t, unit = u}
                end
            end
        end
    end
    -- (lane O8, the player on Stonetalon: a land the chapter names as new, with work recorded there,
    -- gets its work told, the best piece at least, so its name never stands alone over dropped work)
    for _, ep in ipairs(episodes) do
        local isNew = false
        for _, f in ipairs(ep.firsts or {}) do if f.what == "zone" then isNew = true end end
        -- (round 10, reader J: tell the quests that move a story, never count them: any stay whose
        -- work the selection left wholly untold gets its best authored piece, a new land or not)
        if (isNew or C.TELL_EVERY_STAY ~= false) and ep.kind ~= "dungeon" and #ep.quests >= 1 then
            local told, best = false, nil
            for _, u in ipairs(sel.units or {}) do
                if (u.t or 0) >= ep.t and (u.t or 0) < (ep.until_ or ep.e or ep.t) then
                    if u.mode then told = true end
                    if u.kind == "act" and not u.fallback and u.act and (not best or (u.score or 0) > (best.score or 0)) then best = u end
                end
            end
            if not told and best then
                -- (round 18, reader T: the opening that says where a thing came from, when short)
                local lead = Sel.Lead and Sel.Lead(sel, best)
                if lead and Words(lead) <= 32 and not best.kin and not Any(lead:lower(), {" went to fetch", " went to find", " wanted%.$", " set out to"}) then
                    best.mode, best.tell, best.promote = "lead", lead, best.promote or best.variant
                else
                    best.mode = "act"
                end
                local it = best.it
                it.chosen = it.chosen or {}
                it.chosen[best.act.i] = true
                it.pick, it.keep = true, true
            end
        end
    end
    -- (round 16, reader R rule 1: an errand to another land with work in it is a leg of the night:
    -- its best piece is told, and the composer gives it its road there and back)
    for _, ep in ipairs(episodes) do
        for _, sc in ipairs(ep.errands or {}) do
            local best, told
            for _, u in ipairs(sel.units or {}) do
                if (u.t or 0) >= (sc.t or 0) and (u.t or 0) <= (sc.e or sc.t or 0) + 60 then
                    if u.mode then told = true end
                    if u.kind == "act" and not u.fallback and u.act and (not best or (u.score or 0) > (best.score or 0)) then best = u end
                end
            end
            if best and not told then
                best.mode = "act"
                local it = best.it
                it.chosen = it.chosen or {}
                it.chosen[best.act.i] = true
                it.pick, it.keep = true, true
                sc.errandTold = true
            end
        end
    end
    -- (lane O8 round 11, reader K rule 1: a completed quest with a named kill, or one that ends a
    -- thread the chapter told (the same people as a told step before it), or the first work of a new
    -- land (why we came), is never dropped; plain errands go first. Told as its bare act.)
    local function Tell(u, kill)
        if u.kind == "scene" then
            -- (round 16: a kill's scene is told whole when it is short, with who wanted it and why)
            -- (only when it brings in who wanted it: a giver the chapter's told work has not named)
            local giverWord = u.giver and tostring(u.giver):match("(%S+)$")
            local newGiver = giverWord ~= nil
            for _, o in ipairs(sel.units or {}) do
                if giverWord and o ~= u and o.mode and (o.t or 0) < (u.t or 0) then
                    local text_ = (o.plain or "") .. " " .. tostring(o.giver or "") .. " " .. tostring((Sel.Account and Sel.Account(sel, o)) or "")
                    if text_:find(giverWord, 1, true) then newGiver = false end
                end
            end
            if kill and newGiver and (u.words or 99) <= 55 then
                u.mode = "full"
                for _, line in ipairs(u.items or {}) do line.keep = true end
                return
            end
            -- (a scene told short: its act as one sentence, the scene's first line)
            if not u.short then return end
            u.mode = "short"
            for i, line in ipairs(u.items or {}) do
                if i == 1 then line.keep, line.text, line.plain, line.short = true, u.short, Plain(u.short), true else line.keep = false end
            end
            return
        end
        -- (round 12, reader M rule 7: the variant that carries the why, the account's opening, when it
        -- is short; the bare act otherwise)
        local lead = Sel.Lead and Sel.Lead(sel, u)
        -- (a kill keeps its deed: the opening is used only when it tells the kill too)
        if kill and lead and not Any(lead:lower(), {"killed", "destroyed", "slew", "beheaded", "put down", "cut down"}) then lead = nil end
        if lead and Any(lead:lower(), {" went to fetch", " went to find", " wanted%.$", " set out to"}) then lead = nil end
        -- (round 16: a kill told with who wanted it, the account's short telling when it holds both)
        local full = kill and Sel.Account and Sel.Account(sel, u)
        if full and Words(full) <= 55 and Any(full:lower(), {"killed", "destroyed", "slew", "after "}) and u.giver and full:find((tostring(u.giver):match("(%S+)$") or "~"), 1, true) then
            u.mode, u.tell, u.promote = "full", full, u.promote or u.variant
        elseif lead and Words(lead) <= 32 and not u.kin then
            u.mode, u.tell, u.promote = "lead", lead, u.promote or u.variant
        else
            u.mode = "act"
        end
        local it = u.it
        it.chosen = it.chosen or {}
        it.chosen[u.act.i] = true
        it.pick, it.keep = true, true
    end
    local firstOf = {}
    for _, ep in ipairs(episodes) do
        local isNew = false
        for _, f in ipairs(ep.firsts or {}) do if f.what == "zone" then isNew = true end end
        if isNew and ep.kind ~= "dungeon" then
            for _, u in ipairs(sel.units or {}) do
                if (u.t or 0) >= ep.t and (u.t or 0) < (ep.until_ or ep.e or ep.t) and (not firstOf[ep] or (u.t or 0) < (firstOf[ep].t or 0)) then firstOf[ep] = u end
            end
        end
    end
    local firstUnit = {}
    for _, u in pairs(firstOf) do firstUnit[u] = true end
    for _, u in ipairs(sel.units or {}) do
        if not u.mode and ((u.kind == "act" and not u.fallback and u.act) or (u.kind == "scene" and u.short)) and EpisodeAt(u.t or 0, episodes).kind ~= "dungeon" then
            local act = u.entry and u.entry.act and u.entry.act.act
            -- (one named foe: "Ivar the Foul", "Besseleth", "until Nightlash came out"; never a band,
            -- "Moonrage Whitescalps", "Rot Hides")
            local kill = false
            if type(act) == "string" then
                for _, v in ipairs({"killed", "slew", "destroyed", "put down", "executed", "hunted down", "beheaded", "until"}) do
                    local text_ = (act .. " x"):gsub("%f[%a](" .. v .. ") the %l+ (%u)", "%1 %2")
                    for n_ in text_:gmatch("%f[%a]" .. v .. " (%u[%w']+[^,]-)%s+[a-z,]") do
                        local name = n_:gsub(" in$", ""):gsub(" at$", "")
                        if not name:match("s$") and not name:match("^The ") and (not A.FoeNamed or A.FoeNamed(name)) then kill = true end
                    end
                end
            end
            -- (a thread's last step the same day, when an earlier step of it was told)
            local ends = false
            if u.own and u.own ~= "class" then
                local later, toldBefore = false, false
                for _, o in ipairs(sel.units or {}) do
                    if o ~= u and o.own == u.own then
                        if (o.t or 0) > (u.t or 0) then later = true end
                        if o.mode and (o.t or 0) < (u.t or 0) then toldBefore = true end
                    end
                end
                ends = toldBefore and not later
            end
            -- (round 12, reader M: the spine. A step that names someone the chapter tells of elsewhere,
            -- not as the one who gives work ("Thule" in Rot Hide Origins, told by his deaths and his
            -- keep), sets that up and is told)
            local spine = false
            local known = sel.knownText or ""
            for name in pairs(u.names or {}) do
                if #name >= 4 and not (sel.folk or {})[name] and not (sel.zoneWords or {})[name] and known:find("%f[%a]" .. name .. "%f[%A]") then
                    -- (named only outside the work told: Thule in his deaths and his keep, not Aramis in his lessons)
                    local inWork = false
                    for _, o in ipairs(sel.units or {}) do if o.mode and o ~= u and (o.plain or ""):find("%f[%a]" .. name .. "%f[%A]") then inWork = true end end
                    if not inWork then spine = true end
                end
            end
            if kill or ends or firstUnit[u] or spine then Tell(u, kill) end
        end
    end
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
        for _, u in ipairs(sel.units or {}) do C.Debug(("sel %-5s mode=%-5s score=%s rank=%s must=%s own=%s %s%s %s"):format(u.kind, tostring(u.mode), tostring(u.score), tostring(u.rank), tostring(u.must), tostring(u.own), u.paired and "P" or "", u.pulled and "p" or "", (u.plain or ""):sub(1, 50) .. (" [kin=%s skip=%s fb=%s full=%s w=%s%s]"):format(tostring(u.kin), tostring(u.skip), tostring(u.fallback), u.full and #u.full or "nil", tostring(u.words), u.promised and (" PROMISED " .. tostring(u.promisedName)) or ""))) end
        C.Debug(("sel cap=%d fixed=%d room=%s used=%s steps=%s"):format(sel.cap or 0, fixed + craft, tostring(sel.room), tostring(sel.used), table.concat(sel.steps or {}, ",")))
    end
    -- (lane O8 round 9, reader I rule 2: the selection may leave minor work out, but never
    -- silently: what a stay handed in and the chapter does not tell is one plain clause, by giver
    -- or by place, "We saw to two more tasks for Faranell besides"; C.Coverage keeps the count)
    local cover = {recorded = 0, told = 0, folded = 0}
    local W_ = ctx.W and ctx.W.compose or {}
    local COUNT = {"one", "two", "three", "four", "five", "six", "seven", "eight", "nine", "ten", "eleven", "twelve", "thirteen", "fourteen",
        "fifteen", "sixteen", "seventeen", "eighteen", "nineteen", "twenty"}
    local rest = {n = 0, zones = {}, seen = {}}
    for _, ep in ipairs(episodes) do
        if ep.kind ~= "dungeon" and #ep.quests > 0 then
            local told, givers, seenGiver, lastT = 0, {}, {}, nil
            for _, u in ipairs(sel.units or {}) do
                if (u.t or 0) >= ep.t and (u.t or 0) < (ep.until_ or ep.e or ep.t) then
                    local n = (u.kind == "fixed" and u.it.fold and #u.it.fold.entries) or 1
                    if u.mode then told = told + n
                    elseif u.giver and type(u.giver) == "string" then
                        local g = Clean(u.giver)
                        if not seenGiver[g] then seenGiver[g] = true; givers[#givers + 1] = g end
                    end
                end
            end
            told = math.min(told, #ep.quests)
            local untold = #ep.quests - told
            cover.recorded, cover.told = cover.recorded + #ep.quests, cover.told + told
            for _, q in ipairs(ep.quests) do lastT = math.max(lastT or 0, q.t or 0) end
            if C.FOLD_COUNTS and untold > 0 and told == 0 then
                -- (a stay that did nothing the chapter tells: its own clause, so its place is never empty)
                local party = #ep.party > 0
                local tokens = {We = party and "We" or "I", we = party and "we" or "I", count = COUNT[untold] or "many", tasks = untold == 1 and "task" or "tasks",
                    givers = List({givers[1], givers[2]}), place = ctx.Place and ctx.Place(ep.zone) or ep.zone}
                local pool = (#givers > 0 and #givers <= 2 and W_.foldGiversOnly) or W_.foldPlaceOnly
                if pool and pool[1] then
                    lines[#lines + 1] = {n = #ctx.out + 650 + ep.index, cls = "what", t = lastT, ep = ep, text = Fill(pool[Hash(seed .. ":fold:" .. ep.index) % #pool + 1], tokens),
                        major = false, kind = "fold", meta = {t = lastT, compose = "fold", count = untold, foldCount = tokens.count, foldTasks = tokens.tasks}}
                    cover.folded = cover.folded + untold
                end
            elseif untold > 0 then
                rest.n = rest.n + untold
                if not rest.seen[Clean(ep.zone or "")] then rest.seen[Clean(ep.zone or "")] = true; rest.zones[#rest.zones + 1] = ep.zone end
                rest.ep, rest.t = ep, lastT
            end
        end
    end
    -- (the rest of the chapter's work: one plain clause, in the last stay it came from)
    if C.FOLD_COUNTS and rest.n > 0 and rest.ep and W_.foldChapter then
        local party = #rest.ep.party > 0
        local places = {}
        for _, z in ipairs(rest.zones) do places[#places + 1] = ctx.Place and ctx.Place(z) or z end
        local tokens = {We = party and "We" or "I", we = party and "we" or "I", count = COUNT[rest.n] or "many", tasks = rest.n == 1 and "task" or "tasks",
            were = rest.n == 1 and "was" or "were", them = rest.n == 1 and "it" or "them", where = (#places <= 2 and (" in " .. List(places))) or ""}
        local pool = W_.foldChapter
        lines[#lines + 1] = {n = #ctx.out + 660, cls = "what", t = rest.t, ep = rest.ep, text = Fill(pool[Hash(seed .. ":foldChapter") % #pool + 1], tokens),
            major = false, kind = "fold", meta = {t = rest.t, compose = "fold", count = rest.n, chapter = true}}
        cover.folded = cover.folded + rest.n
    end
    C.Coverage = C.Coverage or {}
    C.Coverage[tostring(ctx.day and ctx.day.key or "")] = cover
    return sel
end

-- A fight-type account (lane O8): an ambush, a council, a group fought beside, a stand held.
local FIGHT = {"ambush", "%f[%a]council%f[%A]", "fought beside", "fought alongside", "fought with", "stood with", "stood beside",
    "held the line", "%f[%a]battle%f[%A]", "stormed", "drove off", "drove back", "beat back"}
function C.FightAccount(full, act)
    -- (the fight is the character's own sentence, "{We} fought beside her", "{We} helped lay an
    -- ambush", not a giver's talk of an assault to come)
    for sentence in (tostring(full or "") .. " "):gmatch("[^%.!%?]+[%.!%?]") do
        local low = sentence:lower()
        if (low:find("{we}", 1, true) or low:find("{i}", 1, true)) and Any(Plain(low), FIGHT) then return true end
    end
    local act_ = Plain(act or ""):lower()
    return act_:find("ambush", 1, true) ~= nil or act_:find("^fought ") ~= nil
end

-- The feeling a great figure earns (lane S): the planned telling's figureNamed line, asked
-- the same way (JournalSelfPlan P.Apply): the figure was named before in the book or earlier
-- in the chapter, the stage's pool (the race's own for Sylvanas before a Forsaken), no line
-- said before in the book, not within three chapters of the last such feeling, every name in
-- the line already said, a "promised" line only after a promise. Returns a line or nil.
function C.FigureFelt(ctx, name, short, fig, kept, chapterPlain)
    local F, Tale, Sel = A.JournalFeel, A.JournalTale or {}, A.SelfPlan and A.SelfPlan.Sel
    local history = ctx.history
    if not F or not F.figureNamed or not history or not Sel or not Sel.NamesFigure then return nil end
    history.plan = history.plan or {said = {}, kind = {}, text = ""}
    local hp = history.plan
    hp.said, hp.kind = hp.said or {}, hp.kind or {}
    local index = ctx.index or 0
    if hp.kind.figureNamed and index - hp.kind.figureNamed <= 3 then return nil end
    local level = tonumber(ctx.level)
    local stage = level and (level < 20 and "fledgling" or level < 45 and "seasoned" or "known") or nil
    if not stage then return nil end
    -- (what the book said before this moment: earlier chapters, and the chapter's lines before the figure)
    local before = {hp.text or ""}
    for _, l in ipairs(kept) do if l == fig then break end; if not l.drop then before[#before + 1] = Plain(l.text) end end
    before = table.concat(before, " ")
    local sel = {Tale = Tale}
    if not Sel.NamesFigure(sel, before, name) then return nil end
    local key = (Tale.FigureKeys and Tale.FigureKeys[name]) or name
    local race = ctx.race or ""
    local pools = {F.figureNamed[key] and F.figureNamed[key][race], F.figureNamed}
    local promiser = Sel.Promiser and Sel.Promiser(before) or nil
    local tokens = {figure = short, setupName = promiser or ""}
    local seed = tostring(ctx.seed or "me") .. ":" .. tostring(ctx.day and ctx.day.key or index) .. ":figure"
    local said = before .. " " .. Plain(fig.text)
    for _, pool in ipairs(pools) do
        local lines = pool and pool[stage] and pool[stage].i
        local usable = {}
        for _, line in ipairs(lines or {}) do
            local filled = Fill(line, tokens)
            local ok = not filled:find("{", 1, true) and not hp.said[line] and not (line:find("promis", 1, true) and not said:find("promis", 1, true))
            if ok and line:find("{setupName}", 1, true) and not promiser then ok = false end
            if ok then
                local plain, firstWord = Plain(filled), true
                for word in plain:gmatch("%a[%a']*") do
                    if not firstWord and word:find("^%u") and word ~= "I" and #word >= 3 and not said:find(word, 1, true) then ok = false end
                    firstWord = false
                end
            end
            if ok then usable[#usable + 1] = {line = line, text = filled} end
        end
        if #usable > 0 then
            local choice = usable[Hash(seed) % #usable + 1]
            hp.said[choice.line], hp.kind.figureNamed = true, index
            return {cls = "what", t = fig.t, ep = fig.ep, text = choice.text, major = false, kind = "feel", s = fig.s, slot = fig.slot,
                meta = {t = fig.t, felt = "figureNamed", compose = "felt"}, n = fig.n + 0.25}
        end
    end
    return nil
end

-- The names a text uses bare (lane S): a capitalised word of four letters or more with no
-- title or other name beside it ("found Deliah", not "High Executor Hadrec", "Rot Hide",
-- "the abomination Gordo") and no description after it (", a beggar"). Such a name assumes
-- the reader knows it; the one that first names it must be told.
local BARE_SKIP = {}
for word in ("The This That Then There Here After Before When While With From Into Over Under Among Along Past Only Just Still Once Both Each Every "
    .. "Scarlet Scourge Forsaken Deathguard Deathguards Executor Captain Light Crusade Alliance Horde Magistrate Apothecary Novice Shadow Priest Father "
    .. "Doctor Lady Lord Dark Cult Damned Argent Dawn Keep Mills Hollow Vale Farmstead Lake Rest Tower Camp Village Glades Quarter Watch Graves Haunt "
    .. "Bridge Farm Mass Trade Magic Undercity Brill Sepulcher Orgrimmar Kalimdor Eastern Kingdoms Silverpine Tirisfal Forest Isle Hill Ridge"):gmatch("%S+") do BARE_SKIP[word] = true end
function C.BareNames(text, strict)
    local words, opens = {}, {}
    for before, w in text:gmatch("(%p?)%s*([%a'][%a']*)") do words[#words + 1] = w; opens[#words] = (before == "." or before == "!" or before == "?") end
    local names = {}
    for i, w in ipairs(words) do
        local name = w:gsub("'s$", ""):gsub("'$", "")
        -- (strict, for the later text: a possessive, "Varimathras's advance", points at someone known)
        if #name >= 4 and name:match("^%u") and not BARE_SKIP[name] and i > 1 and not opens[i] and not (strict and w:find("'s$")) then
            local before, before2, after = words[i - 1], words[i - 2], words[i + 1]
            -- (a name after "the" is a thing or a place, not a person)
            local titled = before and (before:match("^%u") or before:lower() == "the")
            -- (a place preposition before the name, with or without one plain word between: "in ruined Shadowvale")
            local PLACE = {at = true, ["in"] = true, of = true, from = true, near = true, beneath = true, below = true, around = true, into = true, through = true, across = true, past = true, beyond = true, inside = true, outside = true}
            if strict and before and (PLACE[before:lower()] or (before:match("^%l") and before2 and PLACE[before2:lower()])) then titled = true end
            local described = before2 and before2:lower() == "the" and before and before:match("^%l")
            local tail = text:find(name .. ", an? ") or text:find(name .. ", the ") or text:find(name .. "'s? of the ")
            local named = after and after:match("^%u") and after ~= "I"
            if not titled and not described and not tail and not named then names[name] = true end
        end
    end
    return names
end

-- One chapter -------------------------------------------------------------------------------
-- Lane O8 (2026-11-12): the adventure's company and foes, and the journey told as one road.
--
-- The record may say how many travelled together and that the foes were elite (lane REC8:
-- `party` spans on the stays, `partySize`, `partyMax`, `partyKinds` on the episode, `elites`;
-- later perhaps `significant`, `eliteSeconds`, `dangerous`, named elites). The player: a group
-- held ten minutes or more counts even when its members are not in the list ("a troll hunter
-- and two others joined us for it"); a few elites are not worth a word unless named, a long
-- time spent killing them is a dangerous place, told subtly and never as numbers.
C.SIGNIFICANT = 10 * 60      -- a member counts after ten minutes together (the player's threshold)
C.DANGEROUS_SECONDS = 10 * 60 -- elite fighting this long makes the place dangerous
C.DANGEROUS_COUNT = 5         -- without the time, this many elite foes
local RACE_WORD = {Scourge = "Forsaken", NightElf = "night elf", BloodElf = "blood elf", Orc = "orc", Troll = "troll",
    Tauren = "tauren", Human = "human", Dwarf = "dwarf", Gnome = "gnome", Goblin = "goblin", Draenei = "draenei"}
local COUNT_WORD = {"one", "two", "three", "four", "five", "six", "seven", "eight", "nine", "ten"}
local TIMES_WORD = {"once", "twice", "three times", "four times", "five times", "six times"}
-- "Troll HUNTER" (or {race =, class =, guild =}) as words: "a troll hunter", "a guildmate".
local function KindWords(kind)
    if type(kind) == "table" then
        if kind.guild then return "a guildmate" end
        local race, class = kind.race or kind.r, kind.class or kind.c
        if type(race) ~= "string" or type(class) ~= "string" or race == "" or class == "" then return nil end
        local r = RACE_WORD[race] or RACE_WORD[(race:gsub("%s", ""))] or race:lower()
        local words = r .. " " .. class:lower()
        return (words:match("^[aeiouAEIOU]") and "an " or "a ") .. words
    end
    if type(kind) ~= "string" then return nil end
    if kind:find("GUILD", 1, true) then return "a guildmate" end
    local race, class = kind:match("^(%S+)%s+(%u+)$")
    if not race or not class then return nil end
    local r = RACE_WORD[race] or race:gsub("(%l)(%u)", "%1 %2"):lower()
    local words = r .. " " .. class:lower()
    return (words:match("^[aeiouAEIOU]") and "an " or "a ") .. words
end
function C.AdventureFacts(ep)
    local f = {named = {}}
    local companions = #(ep.party or {})
    -- the strangers who stayed long enough to count
    local sig = ep.significant
    local kinds = ep.partyKinds
    if type(ep.members) == "table" then
        -- (the record's members: the significant ones not in the list; a guildmate as a guildmate)
        local list = {}
        for _, m in ipairs(ep.members) do
            if m.significant and not m.circle then list[#list + 1] = {race = m.race, class = m.class, guild = m.guild and true or nil, t = m.t, e = m.e} end
        end
        if #list > 0 then
            f.strangers, f.kinds = #list, {}
            for _, m in ipairs(list) do
                local w = KindWords(m)
                if w then f.kinds[#f.kinds + 1] = w end
                f.from = math.min(f.from or m.t or ep.t, m.t or ep.t)
                f.to = math.max(f.to or 0, m.e or ep.e or ep.t)
            end
        end
    elseif type(sig) == "table" then
        if #sig > 0 then f.strangers = #sig; kinds = sig end
    elseif type(sig) == "number" then
        if sig > 0 then f.strangers = sig end
    elseif type(ep.partySeconds) == "table" then
        local secs, most = 0, 0
        for n, s in pairs(ep.partySeconds) do
            if tonumber(n) and n > companions + 1 then secs = secs + s; if n > most then most = n end end
        end
        if secs >= C.SIGNIFICANT and most > companions + 1 then f.strangers = most - companions - 1 end
    end
    if f.strangers and not f.kinds then
        f.kinds = {}
        for _, k in ipairs(type(kinds) == "table" and kinds or {}) do
            local w = KindWords(k)
            if w then f.kinds[#f.kinds + 1] = w end
        end
        -- (the span the strangers were with us: its last end, for the parting)
        for _, sc in ipairs(ep.scenes or {}) do
            for _, span in ipairs(sc.party or {}) do
                if tonumber(span.n) and span.n > companions + 1 and span.e and span.t and span.e > ep.t and span.t < (ep.e or ep.t) then
                    f.from = math.min(f.from or span.t, span.t)
                    f.to = math.max(f.to or 0, span.e)
                end
            end
        end
    end
    -- the foes: a named elite by name; a long time spent fighting elites is a dangerous place
    for _, list in ipairs({ep.eliteNames, ep.namedElites, ep.elitesNamed}) do
        if type(list) == "table" then
            for _, x in ipairs(list) do
                local name = type(x) == "table" and (x.name or x.d) or x
                if type(name) == "string" and name ~= "" and name ~= "?" then f.named[#f.named + 1] = name end
            end
        end
    end
    if ep.dangerous == true or (tonumber(ep.eliteSeconds) or 0) >= C.DANGEROUS_SECONDS
        or (ep.eliteSeconds == nil and ep.dangerous == nil and (tonumber(ep.elites) or 0) >= C.DANGEROUS_COUNT) then f.dangerous = true end
    if not f.strangers and not f.dangerous and #f.named == 0 then return nil end
    return f
end
-- The company line: by who they were, or as strangers; the choice is the day's, so a retell keeps it.
function C.CompanyWords(f, seed)
    if not f or not f.strangers then return nil end
    local n = f.strangers
    local byKind = #f.kinds > 0 and seed % 2 == 0
    if byKind then
        local first = f.kinds[1]
        if n == 1 then return first, false end
        if #f.kinds >= n and n <= 3 then
            local list = {}
            for i = 1, n do list[i] = f.kinds[i] end
            return List(list), true
        end
        local rest = n - 1
        return first .. " and " .. (rest == 1 and "one other" or ((COUNT_WORD[rest] or tostring(rest)) .. " others")), true
    end
    if n == 1 then return "a stranger", false end
    return (COUNT_WORD[n] or tostring(n)) .. " strangers", true
end

-- DANGER as a register (lane O8, the player: "danger should change some words and verbs in the
-- other sentences"): 0 safe, 1 tense, 2 dangerous, 3 deadly, from the record only: the gap from
-- my level to the land's (Lore's zone levels), work far above the level, my deaths and the
-- company's, a dangerous stretch of elites (the recorder's `dangerous`), a wipe. It picks the
-- words of the episode's sentences; at most one sentence says the danger outright.
function C.DangerOf(f)
    local gap, mine, theirs = f.gap or 0, f.mine or 0, f.theirs or 0
    local r = 0
    if gap >= 4 or mine >= 1 or theirs >= 2 then r = 1 end
    if gap >= 8 or mine >= 2 or f.above or f.dangerous or (f.wipes or 0) >= 1 then r = 2 end
    if ((gap >= 8 or f.dangerous or f.above) and mine >= 3) or (f.wipes or 0) >= 2 then r = 3 end
    return r
end
function C.LevelGap(zone, level)
    local L = A.Lore
    local range = L and L.ZoneLevels and L.ZoneLevels(Clean(zone or ""))
    if type(range) ~= "table" or not tonumber(range[1]) or not tonumber(level) then return 0 end
    return tonumber(range[1]) - tonumber(level)
end
function C.EpisodeLevel(ep)
    for _, sc in ipairs(ep.scenes or {}) do
        for _, list in ipairs({sc.entries or {}, sc.events or {}}) do
            for _, e in ipairs(list) do if tonumber(e.pl) and (e.t or 0) >= ep.t then return tonumber(e.pl) end end
        end
    end
    return nil
end
-- A quest's level and mine when it was handed in, from the record's own line.
function C.QuestLevel(ep, q)
    local quest = q.quest or q
    if tonumber(quest.ql) then return tonumber(quest.ql), tonumber(quest.pl) end
    for _, sc in ipairs(ep.scenes or {}) do
        for _, e in ipairs(sc.entries or {}) do
            if e.k == "quest" and ((quest.qid and e.qid == quest.qid) or (quest.title and e.d == quest.title)) then return tonumber(e.ql), tonumber(e.pl or e.ol) end
        end
    end
    return nil
end
function C.EpisodeDanger(ep)
    local level = C.EpisodeLevel(ep)
    local gap, above = 0, false
    for _, sc in ipairs(ep.scenes or {}) do gap = math.max(gap, C.LevelGap(sc.zone, level)) end
    for _, q in ipairs(ep.quests or {}) do
        local ql = C.QuestLevel(ep, q)
        if ql and level and ql >= level + 8 then above = true end
    end
    local wipes = ep.run and type(ep.run.wipes) == "table" and #ep.run.wipes or (ep.run and tonumber(ep.run.wipes)) or 0
    return C.DangerOf({gap = gap, mine = ep.mine, theirs = ep.theirs, above = above, dangerous = ep.dangerous == true, wipes = wipes})
end
-- The register's words in a told line: the same sentence, its verbs chosen by the danger.
-- (a kill is reworded only before a name or "the"/"a": "We killed him" stays as it is)
local KILL2 = {{"^We killed ([%u{])", "We cut down %1"}, {"^We killed (the )", "We cut down %1"}, {"^We killed (an? )", "We cut down %1"},
    {"^I killed ([%u{])", "I cut down %1"}, {"^I killed (the )", "I cut down %1"}, {"^I killed (an? )", "I cut down %1"}}
local KILL3 = {{"^We killed ([%u{])", "It took all we had to bring down %1"}, {"^We killed (the )", "It took all we had to bring down %1"},
    {"^We killed (an? )", "It took all we had to bring down %1"}, {"^I killed ([%u{])", "It took all I had to bring down %1"},
    {"^I killed (the )", "It took all I had to bring down %1"}, {"^I killed (an? )", "It took all I had to bring down %1"}}
local MOVE = {{"^We went on to ", "We pressed on to "}, {"^I went on to ", "I pressed on to "}, {"^From there we went to ", "From there we pressed on to "}}
local function Rules(...)
    local out = {}
    for _, list in ipairs({...}) do for _, rule in ipairs(list) do out[#out + 1] = rule end end
    return out
end
C.REGISTER = {
    [1] = Rules(MOVE, {{"^We fought beside ", "We fought hard beside "}}),
    [2] = Rules(MOVE, {{" came into ", " came at last into "}, {"^We fought beside ", "We fought hard beside "}, {"^We crossed ", "We pressed across "},
        {"^Inside, we brought down ", "Inside, we cut our way through to "}}, KILL2),
    [3] = Rules(MOVE, {{" came into ", " came at last into "}, {"^We fought beside ", "We fought hard beside "}, {"^We crossed ", "We slipped across "},
        {"^Inside, we brought down ", "Inside, we cut our way through to "}}, KILL3),
}
function C.Register(text, r)
    local rules = C.REGISTER[r or 0]
    if not rules or type(text) ~= "string" then return text end
    -- (a rule for a sentence's start holds at every sentence's start: one change a line)
    for _, rule in ipairs(rules) do
        local out, n = text:gsub(rule[1], rule[2], 1)
        if n == 0 and rule[1]:sub(1, 1) == "^" then
            local shifted = rule[2]:gsub("%%(%d)", function(d) return "%" .. (tonumber(d) + 1) end)
            out, n = text:gsub("([%.!] )" .. rule[1]:sub(2), "%1" .. shifted, 1)
        end
        if n > 0 then return out end
    end
    return text
end

-- (round 9, reader I rule 5: a paragraph is never only the day's sums, level, time and the fold of
-- small work: a split leaves a story line in the tail)
local function HasStory(list, from)
    for j = from, #list do
        local l = list[j]
        if not l.toClose and l.cls ~= "close" and l.cls ~= "level" and l.cls ~= "milestone" and l.kind ~= "fold" then return true end
    end
    return false
end
-- DEATHS AS ONE SENTENCE (lane O8 round 9, reader I rule 4): a stretch of deaths is told by its
-- consequence, not counted out: the first killer by place, the others after, the company's falls
-- as one clause, never one by one, and who raised me. evs: the record's death, pdeath and rez
-- events in time order ({e =, t =}); k: {Place, killedMe, party = {name = true}, road = bool}.
function C.DeathEvents(eps, from)
    local evs = {}
    for _, ep in ipairs(eps) do
        for _, sc in ipairs(ep.scenes or {}) do
            for _, e in ipairs(sc.events or {}) do
                local t = e.t or 0
                if t >= ep.t and t < (ep.until_ or ep.e or t) + 1 and t >= (from or 0)
                    and ((e.k == "death" and not e.boss and not e.pr and not e.pc) or (e.k == "pdeath" and e.n and not e.boss) or (e.k == "rez" and e.w == "them" and e.by)) then
                    evs[#evs + 1] = {e = e, t = t, ep = ep}
                end
            end
        end
    end
    table.sort(evs, function(a, b) return a.t < b.t end)
    return evs
end
local function FoeWords(e, Place)
    if e.env == "FALLING" then return "a fall", true end
    if e.env == "DROWNING" then return "the water", true end
    if e.env or not e.d then return nil end
    local name = Clean(e.d)
    if A.FoeNamed and A.FoeNamed(name) then return Place(name) end
    local foe = A.FoeName and A.FoeName(name) or name
    if not foe:match("^[Aa]n? ") and not foe:match("^[Tt]he ") then foe = ((foe:match("^[aeiouAEIOU]") and "an ") or "a ") .. foe end
    return foe
end
-- (round 10, reader J: no death counts, no comparisons; a group of deaths in time order as one moment:
-- who killed me where, who fell with me, who raised me. "Mountaineer Rharen killed me at Dun Algaz in
-- Loch Modan, and Marrow and Dahlia fell with me." Everything said is true of this group alone.)
-- (round 13, reader O rule 2: three deaths or more in one stretch are one sentence about the danger
-- of the place: where, what killed us, who fell beside me, who brought me back. "At Fenris Isle the
-- Rot Hides cut me down again and again, with Dahlia and Varreth falling beside me, and Ralph
-- Cuthbridge and Varreth brought me back." The kind is the words the killers share, "Rot Hide".)
local function KindOf(names)
    if #names == 0 then return nil end
    local best
    local first = {}
    for w in names[1]:gmatch("%S+") do first[#first + 1] = w end
    for i = 1, #first do
        for j = #first, i, -1 do
            local phrase = table.concat(first, " ", i, j)
            local all = true
            for _, n in ipairs(names) do if not (" " .. n .. " "):find(" " .. phrase .. " ", 1, true) then all = false end end
            if all and (not best or #phrase > #best) then best = phrase end
        end
    end
    return best
end
function C.DangerSentence(evs, k)
    local Place = k.Place
    local own, killers, fell, seenF, raisers, seenR = {}, {}, {}, {}, {}, {}
    for _, x in ipairs(evs) do
        if x.e.k == "death" then
            own[#own + 1] = x
            if x.e.d and not x.e.env then killers[#killers + 1] = Clean(x.e.d) end
        elseif x.e.k == "pdeath" then
            local n = (Clean(x.e.n):gsub("%-.*$", ""))
            if not seenF[n] then seenF[n] = true; fell[#fell + 1] = n end
        elseif x.e.k == "rez" and x.e.by then
            local by = (tostring(x.e.by):gsub("%-.*$", ""))
            local short = by:gsub(" .*$", "")
            local name = (k.party or {})[short] and short or by
            if not seenR[name] then seenR[name] = true; raisers[#raisers + 1] = name end
        end
    end
    if #own < 2 then return nil end
    local kind = KindOf(killers)
    local who
    if kind and #kind >= 3 then
        local plural = kind:match("s$") and kind or (kind .. "s")
        who = (A.FoeNamed and A.FoeNamed(kind)) and Place(kind) or ("the " .. plural)
    else
        local list, seen = {}, {}
        for _, n in ipairs(killers) do
            local w = FoeWords({d = n}, Place)
            if w and not seen[w] then seen[w] = true; list[#list + 1] = w end
        end
        who = #list > 0 and List(list) or "the foes there"
    end
    local x1 = own[1]
    local zone, sub = x1.e.z or x1.ep.zone, x1.e.sz
    local where = (sub and Clean(sub) ~= Clean(zone or "")) and Place(sub) or Place(zone)
    local verb = (k.killedMe == "cut me down") and "cut me down" or "killed me"
    local named_ = who:find("{", 1, true) and not who:find("^the ")
    local s = ((sub and Clean(sub) ~= Clean(zone or "")) and "At " or "In ") .. where .. " " .. who .. " " .. verb .. " " .. ((#own >= 3 and "again and again") or (named_ and "in turn") or "more than once")
    -- (round 18, reader T: no list of who fell; the company falls in "us")
    if #fell > 0 then s = s:gsub(" me down ", " us down "):gsub(" killed me ", " killed us ") end
    if #raisers > 0 then s = s .. ", and " .. List(raisers) .. " brought me back" end
    if k.lead then s = k.lead .. s:gsub("^At ", "at ") end
    return Cap(s) .. "."
end
function C.DeathGroup(evs, k)
    local Place = k.Place
    local own, order, seen, raisers = {}, {}, {}, {}
    for _, x in ipairs(evs) do if x.e.k == "death" then own[#own + 1] = x end end
    for _, x in ipairs(evs) do
        if x.e.k == "pdeath" then
            local n = (Clean(x.e.n):gsub("%-.*$", ""))
            -- (round 11: "with me" only for a fall within a minute of one of mine)
            local near = not k.exact or #own == 0
            for _, o in ipairs(own) do if math.abs(o.t - x.t) <= 60 then near = true end end
            if near and not seen[n] then seen[n] = true; order[#order + 1] = n end
        elseif x.e.k == "rez" and #own > 0 then
            local by = (tostring(x.e.by):gsub("%-.*$", ""))
            if not raisers[by] then raisers[by] = true; raisers[#raisers + 1] = by end
        end
    end
    if #own == 0 and (#order == 0 or k.exact) then return nil end
    local said = k.said or ""
    local function Where(x)
        local zone, sub = x.e.z or x.ep.zone, x.e.sz
        if sub and said:find((Plain(sub):gsub("^[Tt]he ", "")), 1, true) then return "there" end
        if not sub and said:find((Plain(zone or ""):gsub("^[Tt]he ", "")), 1, true) then return "there" end
        if sub and Clean(sub) ~= Clean(zone or "") then return "at " .. Place(sub) .. ((k.stay and "") or (" in " .. Place(zone))) end
        -- (in a stay the land is the paragraph's own: not named again)
        if k.stay then return "" end
        return "in " .. Place(zone)
    end
    -- (round 12, reader M: in a stay's stretch, each death in its turn with its own company and its
    -- own raiser: "A Raging Rot Hide killed Dahlia and me there, and Ralph Cuthbridge stopped to raise
    -- me; then a Rot Hide savage killed me, and Varreth brought me back; then a Raging Rot Hide killed
    -- Dahlia, Varreth and me." One sentence, time order, nothing lost.)
    if k.exact and #own >= 2 then
        local party = k.party or {}
        local clauses, seenFoe = {}, {}
        for i, o in ipairs(own) do
            local nextT = own[i + 1] and own[i + 1].t or math.huge
            local with, seenW = {}, {}
            for _, x in ipairs(evs) do
                if x.e.k == "pdeath" and math.abs(x.t - o.t) <= 150 and x.t < nextT - 60 then
                    local n = (Clean(x.e.n):gsub("%-.*$", ""))
                    if not seenW[n] then seenW[n] = true; with[#with + 1] = n end
                end
            end
            local raiser
            for _, x in ipairs(evs) do
                if x.e.k == "rez" and x.t >= o.t and x.t < nextT and not raiser then raiser = (tostring(x.e.by):gsub("%-.*$", "")) end
            end
            local foe, plainVerb = FoeWords(o.e, Place)
            local cut = not plainVerb and k.killedMe == "cut me down"
            local verb = cut and "cut" or "killed"
            local all = {}
            local raiserShort = raiser and (tostring(raiser):gsub("%-.*$", ""):gsub(" .*$", ""))
            for _, n in ipairs(with) do if n ~= raiserShort then all[#all + 1] = n end end
            all[#all + 1] = "me"
            local whom = List(all) .. (cut and " down" or "")
            local again = foe and seenFoe[foe] and " again" or ""
            if foe then seenFoe[foe] = true end
            local c = foe and (foe .. " " .. verb .. " " .. whom .. again) or ("I died" .. again)
            if i == 1 then local w = Where(o); if w ~= "" then c = c .. " " .. w end end
            if raiser then
                local short = raiser:gsub(" .*$", "")
                c = c .. (party[short] and (", and " .. short .. " brought me back") or (", and " .. raiser .. " stopped to raise me"))
            end
            clauses[#clauses + 1] = (i > 1 and "then " or "") .. c
        end
        local s_ = table.concat(clauses, "; ")
        if k.lead then s_ = k.lead .. s_ end
        return Cap(s_) .. "."
    end
    -- (round 14, reader P: "X cut me down, and Y fell with me" at most once a chapter; one death in
    -- its place names all who fell with it: "A fall killed Dahlia, Marrow and me in the Wetlands.")
    if k.exact and #own == 1 then
        local o = own[1]
        local raiser
        for _, x in ipairs(evs) do if x.e.k == "rez" and x.t >= o.t and not raiser then raiser = (tostring(x.e.by):gsub("%-.*$", "")) end end
        local raiserShort = raiser and raiser:gsub(" .*$", "")
        local all = {}
        for _, n in ipairs(order) do if n ~= raiserShort then all[#all + 1] = n end end
        all[#all + 1] = "me"
        -- (round 18: three or more of us at once is "us all", never a roll call)
        if #all >= 4 and not o.e.env then all = {"us all"} end
        local foe, plainVerb = FoeWords(o.e, Place)
        local cut = not plainVerb and k.killedMe == "cut me down"
        local w = Where(o)
        local c
        if plainVerb and #all > 1 then
            -- (a fall or the water is mine alone: the others fell there too, cause unrecorded)
            table.remove(all)
            c = foe .. " killed me" .. (w ~= "" and (" " .. w) or "") .. ", and " .. List(all) .. " fell there too"
        else
            -- (round 17, reader S: the shapes take turns through the book, never the same roll call)
            local shape = k.Shape and k.Shape() or 1
            local others = {}
            for i = 1, #all - 1 do others[i] = all[i] end
            local where_ = (w ~= "" and (" " .. w) or "")
            if not foe then c = "I died" .. where_
            elseif shape % 3 == 2 and #others > 0 then
                c = List(others) .. " and I fell to " .. foe .. where_
            elseif shape % 3 == 0 and w ~= "" then
                c = Cap(w) .. ", " .. foe .. " " .. (cut and "cut down " or "killed ") .. List(all)
            else
                c = foe .. " " .. (cut and "cut " or "killed ") .. List(all) .. (cut and " down" or "") .. where_
            end
        end
        if raiser then
            local party = k.party or {}
            c = c .. (party[raiserShort] and (", and " .. raiserShort .. " brought me back") or (", and " .. raiser .. " stopped to raise me"))
        end
        if k.lead then c = k.lead .. c end
        return Cap(c) .. "."
    end
    local s
    if #own == 1 then
        local foe, plain = FoeWords(own[1].e, Place)
        s = foe and (foe .. " " .. ((plain or not k.killedMe) and "killed me" or k.killedMe) .. " " .. Where(own[1])) or ("I died " .. Where(own[1]))
        s = s:gsub("%s+$", "")
    elseif #own >= 2 then
        local parts, seenF, places = {}, {}, {}
        for _, x in ipairs(own) do
            local foe = FoeWords(x.e, Place)
            if foe and not seenF[foe] then seenF[foe] = true; parts[#parts + 1] = foe end
            local w = Where(x)
            if not places[w] then places[w] = true; places[#places + 1] = w end
        end
        -- (one place for the group: told after the foes, or with each foe when they differ)
        -- (one place for the group when they all fell in one; else each foe with its place)
        if #places == 1 or k.exact then parts.where = places[1]
        else
            parts = {}; seenF = {}
            for _, x in ipairs(own) do
                local foe = FoeWords(x.e, Place)
                if foe and not seenF[foe] then seenF[foe] = true; parts[#parts + 1] = foe .. " " .. Where(x) end
            end
        end
        s = #parts > 0 and (List(parts) .. " killed me" .. (parts.where and (" " .. parts.where) or "")) or "I died there again and again"
    end
    if #order > 0 then
        if s then s = s .. ", and " .. List(order) .. " fell with me"
        else s = List(order) .. " fell " .. Where(evs[1]) end
    end
    local party = k.party or {}
    local friends, strangers = {}, {}
    for _, by in ipairs(raisers) do
        local short = by:gsub(" .*$", "")
        if party[short] then friends[#friends + 1] = short else strangers[#strangers + 1] = by end
    end
    if #friends > 0 then s = s .. ", though " .. List(friends) .. " brought me back" end
    -- (not called strangers: the book may have met them before; StoryLint's stranger-known)
    if #strangers >= 1 then s = s .. ", and " .. List(strangers) .. " stopped to raise me" end
    if k.lead then s = k.lead .. s end
    return Cap(s) .. "."
end
function C.DeathSummary(evs, k)
    local Place = k.Place
    local own, names, order, raisers, total = {}, {}, {}, {}, 0
    for _, x in ipairs(evs) do
        if x.e.k == "death" then own[#own + 1] = x
        elseif x.e.k == "pdeath" then
            local n = (Clean(x.e.n):gsub("%-.*$", ""))
            if not names[n] then order[#order + 1] = n end
            names[n] = (names[n] or 0) + 1
            total = total + 1
        elseif x.e.k == "rez" and #own > 0 then
            local by = (tostring(x.e.by):gsub("%-.*$", ""))
            local short = by:gsub(" .*$", "")
            if not raisers[by] then raisers[#raisers + 1] = by end
            raisers[by] = (raisers[by] or 0) + 1
            raisers[by .. ":short"] = short
        end
    end
    if #own == 0 and total == 0 then return nil end
    local said = k.said or ""
    local function Where(x)
        local zone, sub = x.e.z or x.ep.zone, x.e.sz
        -- (a place the sentence before named is not named again)
        if sub and said:find((Plain(sub):gsub("^[Tt]he ", "")), 1, true) then return "" end
        if sub and Clean(sub) ~= Clean(zone or "") then return "at " .. Place(sub) .. " in " .. Place(zone) end
        if said:find((Plain(zone or ""):gsub("^[Tt]he ", "")), 1, true) then return "" end
        return "in " .. Place(zone)
    end
    local s
    if #own == 1 then
        local foe, plainVerb = FoeWords(own[1].e, Place)
        s = foe and (Cap(foe) .. " " .. (plainVerb and "killed me" or k.killedMe or "killed me") .. " " .. Where(own[1])) or ("I died " .. Where(own[1]))
        s = s:gsub(" $", "")
    elseif #own >= 2 then
        local first = FoeWords(own[1].e, Place)
        -- (a count of this stretch, never of the day: "Five times I died there")
        s = Cap(TIMES_WORD[#own] or "many times") .. " I died " .. (k.road and "on that road" or "there")
        if first then s = (s .. ", first to " .. first .. " " .. Where(own[1])):gsub(" $", "") end
        local rest, seen = {}, {[first or ""] = true}
        local firstZone = Clean(own[1].e.z or own[1].ep.zone or "")
        for i = 2, #own do
            local foe = FoeWords(own[i].e, Place)
            if foe and not seen[foe] then
                seen[foe] = true
                local z = Clean(own[i].e.z or own[i].ep.zone or "")
                rest[#rest + 1] = foe .. (z ~= firstZone and (" " .. Where(own[i])) or "")
            end
        end
        if #rest > 0 then s = s .. ", then to " .. List(rest) end
    end
    if total > 0 then
        local who = List(order)
        if not s then
            s = (who .. " went down " .. ((total > #order) and "more than once " or "") .. Where(evs[1])):gsub(" $", "")
        elseif total > #own and total >= 3 then s = s .. ", and " .. who .. " went down more often still"
        elseif total >= 2 then s = s .. ", and " .. who .. " went down beside me"
        else s = s .. ", and " .. who .. " went down too" end
    end
    -- (who raised me: a stranger's kindness and a companion's, one more sentence, never a list of deaths)
    local party = k.party or {}
    local strangers, friends = {}, {}
    for _, by in ipairs(raisers) do
        local short = raisers[by .. ":short"]
        if party[short] then friends[#friends + 1] = short .. " brought me back" .. ((#own > 1 and raisers[by] == 1) and " once" or "")
        else strangers[#strangers + 1] = by end
    end
    local raised = {}
    -- (several strangers in one clause: "Tamsin and Tobias, strangers both, stopped to raise me")
    if #strangers == 1 then raised[1] = strangers[1] .. ", a stranger, stopped to raise me"
    elseif #strangers == 2 then raised[1] = List(strangers) .. ", strangers both, stopped to raise me"
    elseif #strangers > 2 then raised[1] = List(strangers) .. ", all of them strangers, stopped to raise me" end
    for _, x in ipairs(friends) do raised[#raised + 1] = x end
    if #raised == 1 and #friends == 1 and #own == 1 then return s .. ", though " .. friends[1] .. "." end
    if #raised > 0 then return s .. ". " .. Cap(table.concat(raised, ", and ")) .. "." end
    return s .. "."
end
-- (a quest's want for the journey's opening: the giver's work, else its title as the record has it)
function C.QuestGoal(q)
    local quest = q.quest or q
    local QD = A.QuestDeeds
    if QD and QD.Story then
        local ok, story = pcall(QD.Story, {title = quest.title, qid = quest.qid})
        local giver = ok and type(story) == "table" and type(story.pov) == "table" and story.pov.giver
        if type(giver) == "string" and giver ~= "" then return "the work " .. giver .. " had for {us}" end
    end
    -- (round 11, reader K: never "the task called <Title>"; without a giver the goal is the land itself)
    return nil
end

-- (round 15, reader Q rule 3: a chain of quests is one named goal. W.compose.questChains holds
-- chains the authored story tables do not, each step's words taken from its quest's own text.)
function C.ChainOf(qid, P)
    for _, chain in ipairs((P and P.questChains) or {}) do
        for _, id in ipairs(chain.qids or {}) do if id == tonumber(qid) then return chain end end
    end
    return nil
end

-- A JOURNEY (expedition): a run of short stays that is mostly movement, several lands crossed,
-- little work, told as one road: setting out and for where, the lands (firsts folded), the
-- dangers by place as beats of the road, how far and how long, the return. A hard road (deaths
-- on it, work far above the level, a dangerous place) is told as such; an easy one lighter.
C.EXPEDITION = true
C.EXPEDITION_STAY = 30 * 60     -- a stay this short is a stop on the road
C.EXPEDITION_LANDS = 3          -- at least this many lands beyond the start
C.EXPEDITION_LONG = 4 * 3600    -- a longer run is a day of travel, not one road
local function ZonesOf(ep)
    local list = {}
    for _, sc in ipairs(ep.scenes or {}) do
        local z = sc.zone
        if z and (not list[#list] or Clean(list[#list]) ~= Clean(z)) then list[#list + 1] = z end
    end
    if #list == 0 and ep.zone then list[1] = ep.zone end
    return list
end
function C.FindExpeditions(episodes)
    local runs = {}
    local function Moving(ep)
        -- (a stay of nothing but the going, however long, is road too)
        return ep.kind ~= "dungeon" and not ep.adventure and (ep.kind == "journey" or ((ep.e or ep.t) - ep.t) <= C.EXPEDITION_STAY) and #ep.quests <= 2
            and not IsTown(ep.zone)
    end
    local i = 1
    while i <= #episodes do
        if Moving(episodes[i]) then
            local j = i
            -- (a crossing or the hearthstone ends the road: the stay it happens in is the last)
            while episodes[j + 1] and Moving(episodes[j + 1]) and #(episodes[j].voyages or {}) == 0 and not episodes[j].hearth do j = j + 1 end
            local eps = {}
            for k = i, j do eps[#eps + 1] = episodes[k] end
            -- (the stay before, when nothing cut the road from it, is where it set out from)
            local before = episodes[i - 1]
            if before and (before.kind == "dungeon" or #(before.voyages or {}) > 0 or before.hearth) then before = nil end
            local path = {}
            if before then local zs = ZonesOf(before); path[1] = zs[#zs] end
            for _, ep in ipairs(eps) do
                for _, z in ipairs(ZonesOf(ep)) do
                    if not path[#path] or Clean(path[#path]) ~= Clean(z) then path[#path + 1] = z end
                end
            end
            local start = path[1]
            local seen, far, back = {[Clean(start or "")] = true}, nil, false
            local lands = {}
            for k = 2, #path do
                local z = path[k]
                if seen[Clean(z)] then back = Clean(path[#path]) == Clean(start or ""); break end
                seen[Clean(z)] = true
                if far then lands[#lands + 1] = far end
                far = z
            end
            local quests = 0
            for _, ep in ipairs(eps) do quests = quests + #ep.quests end
            local road = before and 1 or 2
            local span = (eps[#eps].e or eps[#eps].t) - (eps[road] and eps[road].t or eps[1].t)
            local stops = 0
            for _, ep in ipairs(eps) do stops = stops + math.max(1, #(ep.scenes or {})) end
            if eps[road] and stops >= 3 and far and #lands + 1 >= C.EXPEDITION_LANDS and quests <= #eps and span <= C.EXPEDITION_LONG then
                local run = {eps = eps, start = start, far = far, lands = lands, back = back, before = before, road = road, setOut = eps[road].t}
                for _, ep in ipairs(eps) do ep.expedition = run end
                runs[#runs + 1] = run
                i = j + 1
            else
                i = i + 1
            end
        else
            i = i + 1
        end
    end
    return runs
end
-- The road's lines (cls "what", kind "journey"), each at its own time in its own stay.
function C.TellExpedition(run, k)
    local P, Pick, Place, level = k.P, k.Pick, k.Place, k.level
    local eps, first, last = run.eps, run.eps[1], run.eps[#run.eps]
    local out = {}
    local function Add(ep, t, text, key)
        if text then out[#out + 1] = {cls = "what", t = t, ep = ep, text = text, major = false, kind = "journey", meta = {t = t, compose = "journey", key = key}} end
    end
    local road = run.road or 2
    local setOut = eps[road].t
    first = run.before or first
    local party = k.With(setOut)
    local we = {We = party and "We" or "I", we = party and "we" or "I", us = party and "us" or "me", our = party and "our" or "my", Our = party and "Our" or "My"}
    local function T(extra) local t = {} for a, b in pairs(we) do t[a] = b end for a, b in pairs(extra or {}) do t[a] = b end return t end
    -- the firsts on the road
    local new = {}
    for _, ep in ipairs(eps) do
        for _, f in ipairs(ep.firsts or {}) do if f.what == "zone" then new[Clean(f.z or ep.zone or "")] = true end end
    end
    local allNew = new[Clean(run.far)] and true or false
    for _, z in ipairs(run.lands) do if not new[Clean(z)] then allNew = false end end
    -- the deaths after setting out, mine (a fall too) and the company's, and the raises, in time order
    local evs = {}
    for i = road, #eps do
        local ep = eps[i]
        for _, sc in ipairs(ep.scenes or {}) do
            for _, e in ipairs(sc.events or {}) do
                local t = e.t or 0
                if t >= ep.t and t < (ep.until_ or ep.e or t) + 1 and t >= setOut
                    and ((e.k == "death" and not e.boss and not e.pr and not e.pc) or (e.k == "pdeath" and e.n) or (e.k == "rez" and e.w == "them" and e.by)) then
                    evs[#evs + 1] = {e = e, t = t, ep = ep, i = i}
                end
            end
        end
    end
    table.sort(evs, function(a, b) return a.t < b.t end)
    local mine, theirs, top = 0, 0, nil
    for _, x in ipairs(evs) do
        if x.e.k == "death" then mine = mine + 1 elseif x.e.k == "pdeath" then theirs = theirs + 1 end
    end
    for i = road, #eps do
        for _, q in ipairs(eps[i].quests) do
            local ql, pl = C.QuestLevel(eps[i], q)
            if ql and (not top or ql > top.ql) then top = {ql = ql, pl = pl or level, t = q.t, ep = eps[i], zone = q.scene and q.scene.zone or eps[i].zone} end
        end
    end
    local lv = (top and tonumber(top.pl)) or C.EpisodeLevel(eps[road]) or level
    local above = top and lv and top.ql >= lv + 8
    local facts
    for i = road, #eps do
        local f = C.AdventureFacts(eps[i])
        if f and f.dangerous then facts = f end
    end
    local gap = 0
    for _, z in ipairs(run.lands) do gap = math.max(gap, C.LevelGap(z, lv)) end
    gap = math.max(gap, C.LevelGap(run.far, lv))
    -- (the register: how dangerous the road was, from the record only; it chooses the words)
    local r = C.DangerOf({gap = gap, mine = mine, theirs = theirs, above = above, dangerous = facts and facts.dangerous})
    run.danger, run.hard = r, r >= 2
    local function Reg(name) for x = r, 0, -1 do if P[name .. x] then return P[name .. x], name .. x end end return P[name] end
    -- where it set out from: the town of the start, else its land
    local from
    for _, sc in ipairs(first.scenes or {}) do
        for _, e in ipairs(sc.events or {}) do
            if not from and e.k == "town" and e.d and IsTown(e.d) then from = e.d end
        end
    end
    local lands = {}
    for _, z in ipairs(run.lands) do lands[#lands + 1] = Place(z) end
    -- (round 9 rule 3: the road opens with its goal, the work handed in at its far point)
    local goal, goalQ
    for i = road, #eps do
        for _, q in ipairs(eps[i].quests) do
            if Clean(q.scene and q.scene.zone or eps[i].zone or "") == Clean(run.far) and not goalQ then goalQ = {ep = eps[i], t = q.t, q = q} end
        end
    end
    goal = goalQ and C.QuestGoal(goalQ.q)
    run.goalQ = goalQ
    -- (round 12, reader M: the lands where the road's work was handed in are all its goals, the far
    -- point and any other, "for Loch Modan and the Arathi Highlands"; each is answered where it was done)
    local goals, seenG = {}, {}
    for i = road, #eps do
        for _, q in ipairs(eps[i].quests) do
            local z = q.scene and q.scene.zone or eps[i].zone
            if z and not seenG[Clean(z)] then seenG[Clean(z)] = true; goals[#goals + 1] = {zone = z, ep = eps[i], t = q.t} end
        end
    end
    run.goals = goals
    local goalNames = {}
    for _, g in ipairs(goals) do goalNames[#goalNames + 1] = Place(g.zone) end
    -- (round 14, reader P: the far goal in the setting out and the lands in the order we crossed them;
    -- the other goals are answered where they were done)
    local farGoal = Place(run.far) .. (goal and (" and " .. Fill(goal, we)) or "")
    local chain
    for _, g in ipairs(goals) do
        for _, q in ipairs(g.ep.quests) do chain = chain or C.ChainOf(q.quest and q.quest.qid, P) end
    end
    run.chain = chain
    if chain and chain.road then farGoal = Place(run.far) .. ", " .. Fill(chain.road, we) end
    local tokens = T({from = Place(from or run.start), far = farGoal, lands = List(lands)})
    if #lands == 0 then tokens.lands = Place(run.far) end
    if above and not goal then tokens.far = tokens.far .. ", on work meant for travellers far stronger than " .. we.us end
    local pool, key = Reg(allNew and "journeyOutNew" or "journeyOut")
    Add(eps[road], setOut, Pick(key or "journeyOut", pool, tokens), "out")
    -- the deaths on the road (round 10): in time order, as moments, never counted: those on the way
    -- out and at the far point, then those on the way back, each group one sentence at its first death
    local partySet = {}
    for _, ep in ipairs(eps) do for _, n in ipairs(ep.party or {}) do partySet[n] = true end end
    local killedMe = (P.journeyKilled and (P.journeyKilled[r] or P.journeyKilled[0])) or "killed me"
    local farEnd
    for _, ep in ipairs(eps) do
        for _, sc in ipairs(ep.scenes or {}) do if Clean(sc.zone or "") == Clean(run.far) then farEnd = math.max(farEnd or 0, sc.e or sc.t or 0) end end
    end
    -- (round 13, reader O rule 1: one group a place; a companion's fall within two and a half
    -- minutes of mine goes with my death there)
    local placeGroups = {}
    for _, x in ipairs(evs) do
        if x.e.k == "death" then
            local z = Clean(x.e.z or x.ep.zone or "")
            local g = placeGroups[#placeGroups]
            if not g or g.zone ~= z then g = {zone = z}; placeGroups[#placeGroups + 1] = g end
            g[#g + 1] = x
        end
    end
    for _, x in ipairs(evs) do
        if x.e.k ~= "death" then
            local best, bestD
            for _, g in ipairs(placeGroups) do
                for _, o in ipairs(g) do
                    if o.e.k == "death" and math.abs(o.t - x.t) <= 150 and (not bestD or math.abs(o.t - x.t) < bestD) then best, bestD = g, math.abs(o.t - x.t) end
                end
            end
            if best then best[#best + 1] = x end
        end
    end
    for _, g in ipairs(placeGroups) do table.sort(g, function(a_, b_) return a_.t < b_.t end) end
    local lastBeat
    local saidBack = false
    for gi, group in ipairs(placeGroups) do
        -- (the way back is "the way back" only when no goal lay on it)
        local goalAfter = false
        for _, g in ipairs(run.goals or {}) do if group[1] and g.t > group[1].t and Clean(g.zone) ~= Clean(run.far) then goalAfter = true end end
        local backNow = farEnd and group[1] and group[1].t > farEnd and not saidBack
        if backNow then saidBack = true end
        local text = C.DeathGroup(group, {Place = Place, killedMe = killedMe, party = partySet, exact = true, road = true, Shape = k.Shape,
            lead = (backNow and "on the road back, " or nil)})
        if text and #group > 0 then
            Add(group[1].ep, group[1].t, Fill(text, we), "beat")
            lastBeat = {ep = group[#group].ep, t = group[#group].t}
        end
    end
    -- the goal seen through, at its hand-in: named in the opening, its deed here
    -- (round 13, reader O rule 7: work with no authored words is not padded with "there was work";
    -- a road whose goal has a giver says it was done, one without says nothing more)
    -- (round 14, reader P: every land's work is closed where it was done; without authored words,
    -- plainly: "In Loch Modan we saw that work done." / "Back in the Arathi Highlands we saw the rest done.")
    for gi, g in ipairs(run.goals or {}) do
        -- (a chain's step in its own words, "In Loch Modan we found the next stash, high on the mountainside")
        local step
        for _, q in ipairs(g.ep.quests) do
            local qid = q.quest and tonumber(q.quest.qid)
            if not step and chain and chain.steps and qid and chain.steps[qid] then step = chain.steps[qid] end
        end
        if step then Add(g.ep, g.t, Fill(step, T({zone = Place(g.zone)})), "done")
        else
            local pool = (gi == 1 and P.journeyDonePlain) or P.journeyDoneRest
            if pool then Add(g.ep, g.t, Pick(gi == 1 and "journeyDonePlain" or "journeyDoneRest", pool, T({zone = Place(g.zone)})), "done") end
        end
    end
    -- one sentence that says the danger outright at most: a feeling earned on a hard road with others,
    -- never last; else, when only the foes' strength says it, that
    if r >= 2 and lastBeat and mine >= 2 and party and P.journeyHardFelt then
        Add(lastBeat.ep, lastBeat.t + 1, Pick("journeyHardFelt", P.journeyHardFelt, T()), "felt")
    elseif facts and P.journeyDangerous then
        Add(eps[#eps], (eps[#eps].e or eps[#eps].t) - 2, Pick("journeyDangerous", P.journeyDangerous, T()), "danger")
    end
    -- how far and how long
    local endT = (last.hearth and last.hearth.t) or last.e or last.t
    local minutes = math.floor((endT - setOut) / 60)
    local span = (minutes < 50 and "less than an hour") or (minutes < 80 and "little more than an hour") or (minutes < 120 and "under two hours")
        or (minutes < 170 and "under three hours") or "a few hours"
    -- (round 9: "and back" only when the road itself came back; the hearthstone is its own return)
    local back = run.back and not last.hearth
    local endPool, endKey = Reg((back and "journeyBack") or (last.hearth and "journeyHome") or "journeyFar")
    -- (round 10: the hearthstone is cast where the road ended, "as far as Loch Modan and back into
    -- the Arathi Highlands, and the hearthstone brought us home")
    local lastZones = ZonesOf(last)
    local lastZone = lastZones[#lastZones]
    local farText = Place(run.far)
    if not back and last.hearth and lastZone and Clean(lastZone) ~= Clean(run.far) then farText = farText .. " and back into " .. Place(lastZone) end
    -- (round 13: the end is where the hearthstone was cast and how long the road took, not a recap)
    if not back and last.hearth and lastZone and P.journeyHomeFrom then
        endPool, endKey = P.journeyHomeFrom, "journeyHomeFrom"
        farText = Place(lastZone)
    end
    Add(last, endT - 1, Pick(endKey or "journeyEnd", endPool, T({far = farText, span = span})), "end")
    return out
end

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
    local function Pick(key, pool, tokens, quiet)
        if type(pool) ~= "table" or #pool == 0 then return nil end
        -- (lane O8: a quiet pick draws nothing from the teller, so the chapters after keep their words)
        local line = quiet and pool[Hash(tostring(ctx.day and ctx.day.key or "") .. ":" .. key) % #pool + 1]
            or (teller and teller.Say and teller:Say("compose:" .. key, pool, tokens)) or pool[1]
        return line and Fill(line, tokens or {}) or nil
    end
    local out, majors, kinds, times, scenes, metas = ctx.out, ctx.majors, ctx.kinds, ctx.times, ctx.scenes, ctx.metas
    local stretches = ctx.stretches or {}
    local chapterPlain = Plain(table.concat(out, " "))
    local function DeathShape()
        local h = ctx.history or {}
        h.o8DeathShape = (h.o8DeathShape or 0) + 1
        return h.o8DeathShape
    end

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
    local sel = Select(ctx, lines, inRun, episodes, D)
    -- (lane O8: an adventure's record may carry who went with us and how strong the foes were,
    -- C.AdventureFacts. Strangers who stayed ten minutes and more, with work told in their time,
    -- or a named elite fought, make the stay an adventure even without a fight-type quest; the
    -- company is told by who they were or as strangers, the parting after, the foes subtly)
    for _, ep in ipairs(episodes) do
        local f = ep.kind ~= "dungeon" and C.AdventureFacts(ep) or nil
        if f then
            local first
            for _, l in ipairs(lines) do
                if l.ep == ep and not l.drop and not inRun[l] and l.cls == "quest" and (not f.from or (l.t >= f.from - 60 and l.t <= (f.to or l.t) + 60))
                    and (not first or l.t < first.t) then first = l end
            end
            if not ep.adventure and ((first and (f.strangers or f.dangerous)) or #f.named > 0) then ep.adventure = {t = first and first.t or ep.t} end
            if ep.adventure then
                local at = ep.adventure.t or ep.t
                local party = #ep.party > 0
                local tk = {We = party and "We" or "I", we = party and "we" or "I", us = party and "us" or "me"}
                local function Line(t, key, pool, extra)
                    for a, b in pairs(extra or {}) do tk[a] = b end
                    local text = pool and Pick(key, pool, tk, true)
                    if text then lines[#lines + 1] = {n = #lines + 1, cls = "what", t = t, ep = ep, text = text, s = nil, major = false, kind = nil, meta = {t = t, compose = "adventure"}} end
                end
                local company, many = C.CompanyWords(f, Hash(tostring(ctx.day and ctx.day.key or "") .. ":company:" .. tostring(ep.index) .. ":" .. tostring(ctx.person and ctx.person.retell or 0)))
                if company then
                    Line(math.max(ep.t, (first and first.t or at) - 1), "adventureCompany", P.adventureCompany, {company = company, Company = Cap(company)})
                    if f.to and f.to < (D.e or ep.e or f.to) - 60 then
                        local them = (many and "the others") or (company == "a guildmate" and "my guildmate") or "the stranger"
                        Line(math.min(f.to, (ep.e or f.to)), "adventureParted", P.adventureParted, {them = them, their = "their"})
                    end
                end
                if #f.named > 0 then
                    local names = {}
                    for _, n in ipairs(f.named) do names[#names + 1] = Place(n) end
                    Line(at + 2, "adventureNamed", P.adventureNamed, {names = List(names), Names = List(names)})
                end
                local peril = false
                for _, l in ipairs(lines) do if l.ep == ep and not l.drop and l.kind == "peril" then peril = true end end
                if f.dangerous and not peril then Line(at + 1, "adventureDanger", P.adventureDanger) end
            end
        end
    end
    -- (lane O8 round 9, reader I rule 1: a quest's deed is told where the record puts us at the
    -- place it names. "We went south to the Greymane Wall after Valdred" is told at the Greymane
    -- Wall, where we were before the flight; the hand-in's outcome stays at the hand-in.)
    do
        local moments = {}
        for _, sc in ipairs(ctx.day and ctx.day.scenes or {}) do
            for _, e in ipairs(sc.events or {}) do
                local name = (type(e.sz) == "string" and e.sz) or (e.k == "cave" and type(e.d) == "string" and e.d) or nil
                if name and #name >= 6 and e.t then moments[#moments + 1] = {name = (Plain(name):gsub("^[Tt]he ", "")), t = e.t} end
            end
        end
        for _, l in ipairs(lines) do
            if not l.drop and not inRun[l] and l.cls == "quest" and l.ep.kind ~= "dungeon" then
                local first, rest = l.text:match("^(.-[%.!])%s+([%u{].*)$")
                if not first and l.meta and l.meta.entry then
                    for _, o in ipairs(lines) do
                        if o ~= l and not o.drop and o.meta and o.meta.entry == l.meta.entry and o.t >= l.t then first = l.text end
                    end
                end
                if first then
                    local plainFirst = Plain(first)
                    local at
                    for _, m in ipairs(moments) do
                        if m.t < l.t - 300 and plainFirst:find(m.name, 1, true) then
                            local mep = EpisodeAt(m.t, episodes)
                            if mep ~= l.ep and Clean(mep.zone or "") ~= Clean(l.ep.zone or "") and mep.kind ~= "dungeon" and (not at or m.t < at.t) then at = {t = m.t, ep = mep} end
                        end
                    end
                    if at then
                        -- (round 11, reader K rule 5: the deed before its hand-in, told as the deed itself)
                        local act = l.meta and l.meta.entry and l.meta.entry.act and l.meta.entry.act.act
                        if type(act) == "string" and act ~= "" and rest then
                            first = ((l.text:match("^I ") and "I ") or "We ") .. act .. "."
                        end
                        local meta = {}
                        for k_, v in pairs(l.meta or {}) do meta[k_] = v end
                        -- (we were there before what befell us there: the deed a few minutes before the record's moment)
                        at.t = at.t - 240
                        meta.t, meta.deedMoved = at.t - 1, true
                        if rest then
                            lines[#lines + 1] = {n = l.n - 0.05, cls = "quest", t = at.t - 1, ep = at.ep, text = first, s = l.s, major = l.major, kind = l.kind, meta = meta}
                            -- (round 14: what the deed took is named at the hand-in, "the hands" -> "Valdred's hands")
                            local victim = type(act) == "string" and act:match("killed (%u[%w']+)")
                            if victim then
                                rest = rest:gsub(" the (hands)", " " .. victim .. "'s %1", 1):gsub(" the (head)", " " .. victim .. "'s %1", 1):gsub(" the (heart)", " " .. victim .. "'s %1", 1)
                            end
                            l.text = rest
                        else
                            l.t, l.ep, l.meta = at.t - 1, at.ep, meta
                        end
                    end
                end
            end
        end
    end
    -- (round 13, reader O rule 5: two steps of one thread never both tell the same find. A told step
    -- whose opening sentence retells things an earlier told step found ("we slipped the pendant out of
    -- the Dalaran crate" after "inside one we found ... a pendant") opens on its own act instead, "We
    -- took the maps and pendant to Shadow Priest Allister.")
    do
        local STOP = {which = true, there = true, their = true, would = true, could = true, about = true, after = true, again = true, where = true, these = true, those = true, other = true}
        local order = {}
        for _, l in ipairs(lines) do if not l.drop and not inRun[l] and l.cls == "quest" then order[#order + 1] = l end end
        Sorted(order, function(a, b) if a.t ~= b.t then return a.t < b.t end return a.n < b.n end)
        -- (within one thread only: the same story thread, or the same giver)
        local seenWords = {}
        local function Key(l)
            local e = l.meta and l.meta.entry
            local th = e and e.story and e.story.thread
            local giver = e and e.act and e.act.giver
            -- (the class's own thread is a calling, not one errand chain)
            if type(th) == "string" and th:find("^class") then return nil end
            return (type(th) == "string" and th) or (type(giver) == "string" and giver) or nil
        end
        for _, l in ipairs(order) do
            local key = Key(l)
            local first, rest = l.text:match("^(.-[%.!])%s+([%u{].*)$")
            local act = l.meta and l.meta.entry and l.meta.entry.act and l.meta.entry.act.act
            if key and first and rest and type(act) == "string" and act ~= "" and seenWords[key] then
                local shared = 0
                for w in Plain(first):lower():gmatch("%a+") do if #w >= 5 and not STOP[w] and seenWords[key][w] then shared = shared + 1 end end
                local low_ = Plain(first):lower()
                if shared >= 2 and low_:find("^we ") and Any(low_, {"found", "slipped", "took", "carried", "brought", "opened", "inside"}) then l.text = "We " .. act .. ". " .. rest end
            end
            if key then
                seenWords[key] = seenWords[key] or {}
                for w in Plain(l.text):lower():gmatch("%a+") do if #w >= 5 then seenWords[key][w] = true end end
            end
        end
    end
    -- (lane O8: the danger register picks the words of an adventure's and a dungeon run's sentences)
    for _, ep in ipairs(episodes) do
        if ep.adventure or ep.kind == "dungeon" then
            local r = C.EpisodeDanger(ep)
            ep.danger = r
            if r >= 1 then
                for _, l in ipairs(lines) do
                    if l.ep == ep and not l.drop and (l.cls == "quest" or l.cls == "what" or l.cls == "move" or l.cls == "arrive" or inRun[l]) then
                        l.text = C.Register(l.text, r)
                    end
                end
            end
        end
    end
    -- (round 16: the told errand's road there and back, from the record)
    for _, ep in ipairs(episodes) do
        for _, sc in ipairs(ep.errands or {}) do
            if sc.errandTold and P.errandOut then
                local party = #ep.party > 0
                local how, hearth
                for _, s_ in ipairs(ep.scenes or {}) do
                    for _, e in ipairs(s_.events or {}) do
                        local t = e.t or 0
                        if (e.k == "nightflight" or e.k == "taxi") and t >= (sc.t or 0) - 600 and t <= (sc.t or 0) + 60 then how = "flew" end
                        if e.k == "hearth" and e.d and t >= (sc.t or 0) and t <= (sc.e or sc.t or 0) + 120 then hearth = e.d end
                    end
                end
                for _, e in ipairs(sc.events or {}) do if e.k == "hearth" and e.d then hearth = hearth or e.d end end
                local tk = {We = party and "We" or "I", we = party and "we" or "I", us = party and "us" or "me", Our = party and "Our" or "My", zone = Place(sc.zone), place = hearth and Place(hearth) or ""}
                local t0 = (sc.t or 0)
                lines[#lines + 1] = {cls = "what", t = t0, ep = ep, text = Fill(how and P.errandFlew[1] or P.errandOut[1], tk), major = false, kind = "errand", meta = {t = t0, compose = "errand"}, n = #out + 820 + ep.index}
                if hearth and P.errandBack then
                    local t1 = (sc.e or sc.t or 0)
                    lines[#lines + 1] = {cls = "what", t = t1, ep = ep, text = Fill(P.errandBack[1], tk), major = false, kind = "errand", meta = {t = t1, compose = "errand"}, n = #out + 821 + ep.index}
                end
            end
        end
    end
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
            elseif l.kind == "first" and ((l.meta.e and l.meta.e.k == "first" and l.meta.e.d == "rare") or Any(Plain(l.text):lower(), {"crossed my path", "few people ever see", "a rare sight", "seldom seen"})) then
                -- (a rare creature only seen is no event of the day: a kill is told, a sighting is not)
                l.drop = true
            elseif l.kind == "learn" and Plain(l.text):find("the trainer", 1, true) then
                -- (lane S: "I learned Devotion Aura and Judgement from the trainer" is the game's note, not the day's)
                l.drop = true
            elseif l.kind == "deathRun" and (Plain(l.text):lower():match("^%a+ deaths in ") or Plain(l.text):lower():match("^i died %a+ times in ")) then
                -- (lane S: a run of deaths is told as its fights, never as a tally at the end)
                -- (a rare creature only seen is no event of the day: a kill is told, a sighting is not)
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
                -- (a quest with no words of its own is never named by its title: left out, lane S)
                l.drop = true
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
        -- (lane P7: a tally is never a sentence of its own in the body, and stands in the close
        -- only when the work was the day's point: a chapter that tells any errand, death or run
        -- keeps no tally)
        local story = false
        for _, l in ipairs(lines) do
            if not l.drop and (inRun[l] or l.cls == "quest" or l.cls == "death") then story = true end
        end
        if story then
            for _, l in ipairs(lines) do if l.cls == "craft" and not inRun[l] then l.drop = true end end
            best = nil
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
    -- a place is told for what was done there (lane S): a lore line naming a place the chapter
    -- never goes near is dropped, and so is a zone's "stakes" line, which says what the land is
    -- about and nothing the character saw
    do
        local L = A.Lore
        local keptText, subs = {}, {}
        for _, l in ipairs(lines) do
            if not l.drop and l.kind ~= "lore" and l.cls ~= "close" then keptText[#keptText + 1] = Plain(l.text) end
        end
        keptText = table.concat(keptText, " ")
        for _, s in ipairs(stretches) do
            for _, e in ipairs(s.events or {}) do
                if e.sz then subs[#subs + 1] = Clean(e.sz) end
                if (e.k == "town" or e.k == "rest" or e.k == "cave") and e.d then subs[#subs + 1] = Clean(e.d) end
            end
            for _, q in ipairs(s.quests or {}) do if E.QuestText then keptText = keptText .. " " .. E.QuestText(q) end end
        end
        local SMALL = {The = true, In = true, Lake = true, Forest = true, Horde = true, Alliance = true, Scourge = true, Forsaken = true, Light = true}
        for _, l in ipairs(lines) do
            if not l.drop and not inRun[l] and l.kind == "lore" and l.cls == "place" then
                local plain = Plain(l.text)
                local zone = Clean(l.ep.zone or "")
                local zoneWords = {}
                for w in zone:gmatch("%a+") do zoneWords[w] = true end
                local zs = L and L.ZoneStory and zone ~= "" and L.ZoneStory(zone)
                for _, line in ipairs(zs and zs.stakes or {}) do if Plain(line) == plain then l.drop = true end end
                if not l.drop then
                    local names, any, near = {}, false, false
                    for word in plain:gmatch("%u[%a']+") do
                        word = word:gsub("'s$", "")
                        -- (the sentence's first word is no name unless it stands elsewhere too)
                        local opens = plain:find("^" .. Esc(word)) and not plain:find(" " .. Esc(word))
                        if #word >= 4 and not SMALL[word] and not zoneWords[word] and not opens then names[word], any = true, true end
                    end
                    for word in pairs(names) do
                        if keptText:find(word, 1, true) then near = true end
                        for _, sub in ipairs(subs) do if sub:find(word, 1, true) then near = true end end
                    end
                    if any and not near then l.drop = true end
                end
            end
        end
    end
    -- transit carries the reader to the next thing told (lane S): of two transits in a row only
    -- the last stays, none that lands where the reader already was, none after the chapter's
    -- last thing (the close says where the night ended)
    do
        local TRANSIT = {move = true, arrive = true, voyage = true, night = true}
        -- (a glimpse of a new place on the way, "the Barrens, which was new to me", is a thing seen, not a transit)
        local function Transit(l) return TRANSIT[l.cls] and l.kind ~= "first" and not Any(Plain(l.text):lower(), FIRST) end
        local seq = {}
        for _, l in ipairs(lines) do
            if not l.drop and not inRun[l] and l.cls ~= "close" and l.cls ~= "craft" and l.cls ~= "level" and l.cls ~= "milestone" and l.cls ~= "who" and l.cls ~= "rest" then seq[#seq + 1] = l end
        end
        Sorted(seq, function(a, b) if a.t ~= b.t then return a.t < b.t end return a.n < b.n end)
        local ZC = A.SelfTale and A.SelfTale.ZoneContinent or {}
        -- (lane O8: an opener that is itself the crossing, "my hearthstone took me back to the Sepulcher",
        -- is the arrival; the move line into the place it landed in says nothing more)
        local opener = lines[1]
        if opener and not opener.drop and opener.cls == "open" and opener.meta.e and opener.meta.e.k == "voyage" then
            local land = EpisodeAt((opener.meta.e.t or 0) + 1, episodes)
            for _, l in ipairs(seq) do
                if l ~= opener and TRANSIT[l.cls] and l.ep == land and l.t <= land.t + 300 then l.drop = true end
            end
        end
        local i = 1
        while i <= #seq do
            if Transit(seq[i]) and not seq[i].drop then
                local j = i
                while seq[j + 1] and Transit(seq[j + 1]) do j = j + 1 end
                for k = i, j - 1 do seq[k].drop = true end
                local last, before, after = seq[j], seq[i - 1], seq[j + 1]
                -- (lane O8 round 11, reader K rule 6: several legs between two told stops are one sentence
                -- from the record, the hearthstone and the ways we went: "My hearthstone took us back to the
                -- Sepulcher, and by flight and zeppelin we came on to the Stonetalon Mountains, new to us.")
                if after and before and P.roadLegs and Clean(after.ep.zone or "") ~= Clean(before.ep.zone or "") then
                    local legs, hearth = {}, nil
                    for _, st in ipairs(stretches) do
                        for _, e in ipairs(st.events or {}) do
                            local t = e.t or 0
                            if t >= math.max(before.t, seq[i].t - 3600) and t <= after.t then
                                if e.k == "hearth" and e.d then hearth = hearth or {t = t, place = e.d, z = e.z}
                                elseif e.k == "voyage" and e.d and e.d ~= "hearth" and e.d ~= "portal" then legs[#legs + 1] = {t = t, w = (e.d == "boat" and "ship") or e.d, to = e.to}
                                elseif e.k == "nightflight" or e.k == "taxi" then legs[#legs + 1] = {t = t, w = "flight"} end
                            end
                        end
                    end
                    Sorted(legs, function(a, b) return a.t < b.t end)
                    -- (round 16, reader R rule 1: every leg in order, with where it took us)
                    local words, seenW = {}, {}
                    for _, g in ipairs(legs) do
                        if not hearth or g.t > hearth.t then
                            -- (where the leg took us: a crossing names its continent, a flight the next stay)
                            local land
                            if g.to then land = g.to
                            else
                                for _, ep_ in ipairs(episodes) do if ep_.t > g.t and not land then land = ep_.zone end end
                            end
                            local key = g.w .. ":" .. tostring(land)
                            if land and Clean(land) ~= Clean(after.ep.zone or "") and not seenW[key] then
                                seenW[key] = true
                                words[#words + 1] = ((g.w == "flight" and "a flight") or ("the " .. g.w)) .. " to " .. Place(land)
                            end
                        end
                    end
                    if #words > 0 and hearth then
                        local party = #(after.ep.party or {}) > 0
                        local isNew = false
                        for _, f in ipairs(after.ep.firsts or {}) do if f.what == "zone" then isNew = true end end
                        local tk = {we = party and "we" or "I", We = party and "We" or "I", us = party and "us" or "me", modes = List(words),
                            our = party and "our" or "my", Our = party and "Our" or "My",
                            place = hearth and Place(hearth.place) or "", dest = Place(after.ep.zone), new = isNew and (", new to " .. (party and "us" or "me")) or ""}
                        local pool = hearth and P.roadLegsHearth or P.roadLegs
                        -- (round 13, reader O rule 6: a first visit is never dropped; the land the
                        -- hearthstone was cast from, new to us and told nowhere else, is said here)
                        if hearth and P.roadLegsHearthFrom then hearth.z = hearth.z or EpisodeAt(hearth.t, episodes).zone end
                        if hearth and hearth.z and P.roadLegsHearthFrom and Clean(hearth.z) ~= Clean(before.ep.zone or "") then
                            local hep = EpisodeAt(hearth.t, episodes)
                            local firstHere = false
                            for _, f in ipairs(hep.firsts or {}) do if f.what == "zone" and Clean(f.z or hep.zone or "") == Clean(hearth.z) then firstHere = true end end
                            if firstHere then tk.origin, pool = Place(hearth.z), P.roadLegsHearthFrom end
                        end
                        local text = pool and Pick("roadLegs", pool, tk, true)
                        if text then last.text, last.cls, last.legs = text, "voyage", true; after.ep.roadTold = true end
                    end
                end
                if not after then last.drop = true
                elseif j > i and before and Clean(before.ep.zone or "") == Clean(after.ep.zone or "") then last.drop = true end
                -- (lane O8: a crossing that lands on the continent the reader was already on is the
                -- return of a round trip the chapter does not tell)
                if not last.drop and not last.legs and last.cls == "voyage" and last.meta.e and last.meta.e.to then
                    local fromZone = before and before.ep.zone or (episodes[1] and episodes[1].zone)
                    if fromZone and ZC[fromZone] and Clean(ZC[fromZone]) == Clean(last.meta.e.to) then last.drop = true end
                end
                i = j + 1
            else
                i = i + 1
            end
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
    -- (round 13, reader O rule 4: a companion is with us from the record's first sign of them; a
    -- line that brings them in earlier than that waits for it: "Varreth caught up with me" at 00:50)
    do
        local firstSign = {}
        for _, st in ipairs(stretches) do
            for _, e in ipairs(st.events or {}) do
                local n = (e.k == "pdeath" and e.n) or (e.k == "rez" and e.by) or nil
                if n then
                    n = (Clean(n):gsub("%-.*$", ""):gsub(" .*$", ""))
                    if not firstSign[n] or (e.t or 0) < firstSign[n] then firstSign[n] = e.t or 0 end
                end
            end
        end
        for _, l in ipairs(lines) do
            if not l.drop and (l.cls == "who" or (l.cls == "what" and Plain(l.text):find(", was with us by then", 1, true))) and not inRun[l] then
                local plain = Plain(l.text)
                local name = plain:match("^(%u[%a']+) caught up") or plain:match("^(%u[%a']+), [^,]+, was with us") or plain:match("^(%u[%a']+) joined")
                    or plain:match("^(%u[%a']+), [^,]+, was with me")
                local at = name and firstSign[name]
                if at and at > l.t + 300 then
                    -- (only within the same evening's stay: never across a crossing)
                    local ep = EpisodeAt(at, episodes)
                    if ep == l.ep or Clean(ep.zone or "") == Clean(l.ep.zone or "") then
                        l.t = at - 120; l.meta.t = l.t; l.ep = ep; l.signMoved = true
                    end
                end
            end
        end
    end
    -- (round 15, reader Q rule 1: everyone the record puts in the group for ten minutes or more is
    -- named the first time they are there; a companion the chapter never names gets a line at the
    -- start of their time with us, "Marrow, a Forsaken priest, joined us")
    if P.joinedPlain then
        local said_ = {}
        for _, l in ipairs(lines) do if not l.drop and not inRun[l] then said_[#said_ + 1] = Plain(l.text) end end
        said_ = table.concat(said_, " ")
        for name, spans in pairs(windows) do
            local total, first = 0, nil
            for _, sp in ipairs(spans) do total = total + (sp[2] - sp[1]); first = first and math.min(first, sp[1]) or sp[1] end
            if total >= 600 and first and not said_:find("%f[%a]" .. Esc(name) .. "%f[%A]") then
                local ep = EpisodeAt(first, episodes)
                if ep.kind ~= "dungeon" then
                    local text = Fill(P.joinedPlain[1], {name = "{n:" .. name .. "}", us = "us"})
                    local l = {cls = "who", t = first, ep = ep, text = text, major = false, kind = nil, meta = {t = first, compose = "joined"}, n = #out + 400 + ep.index, signMoved = first > ep.t + 300 or nil}
                    lines[#lines + 1] = l
                end
            end
        end
    end
    -- (round 14, reader P rule 2: a companion the book has not named before is introduced at the line
    -- that first names them, with who they are: "Varreth, a Forsaken paladin, caught up with me")
    do
        local bookBefore = (ctx.history and ctx.history.plan and ctx.history.plan.text) or ""
        local keyOf = {}
        for _, st in ipairs(stretches) do
            for _, w in ipairs(st.with or {}) do
                local name = (Clean(w.name):gsub("%-.*$", ""))
                if w.key and not keyOf[name] then keyOf[name] = w.key end
            end
        end
        local function Role(name)
            local key = keyOf[name]
            local info = key and ((ctx.Companion and ctx.Companion(key)) or (A.db and A.db.people and A.db.people[key])) or nil
            if not info then return nil end
            local people = A.Lore and A.Lore.People and A.Lore.People(info.race)
            local classWord = info.class and ((LOCALIZED_CLASS_NAMES_MALE and LOCALIZED_CLASS_NAMES_MALE[info.class]) or info.class):lower()
            local who = (people and classWord and (people .. " " .. classWord)) or classWord or people
            return who and ((who:match("^[aeiou]") and "an " or "a ") .. who) or nil
        end
        local order = {}
        -- (the teller's death lines are rewritten later; the first naming is the company's own line)
        for _, l in ipairs(lines) do if not l.drop and not inRun[l] and l.cls ~= "death" then order[#order + 1] = l end end
        Sorted(order, function(a, b) if a.t ~= b.t then return a.t < b.t end return a.n < b.n end)
        local named = {}
        for _, l in ipairs(order) do
            local plain = Plain(l.text)
            for name in pairs(keyOf) do
                if not named[name] and plain:find("%f[%a]" .. Esc(name) .. "%f[%A]") then
                    named[name] = true
                    if l.cls == "who" and not bookBefore:find("%f[%a]" .. Esc(name) .. "%f[%A]") and not plain:find(Esc(name) .. ", an? ") and not plain:find("my wife") and not plain:find("my friend") then
                        local role = Role(name)
                        -- (no card to say who they are: a newcomer, who "joined" rather than "caught up")
                        if not role then
                            role = "a newcomer"
                            l.text = l.text:gsub(" caught up with me", " joined us"):gsub(" caught up with us", " joined us")
                        end
                        if role then l.text = l.text:gsub("({n:" .. Esc(name) .. "})", "%1, " .. role .. ",", 1); if not l.text:find(role, 1, true) then l.text = l.text:gsub("%f[%a](" .. Esc(name) .. ")%f[%A]", "%1, " .. role .. ",", 1) end end
                        l.text = l.text:gsub(",, ", ", "):gsub(",%.", ".")
                    end
                end
            end
        end
        -- (round 14, reader P rule 1: setting the hearthstone is bookkeeping, not a moment)
        for _, l in ipairs(lines) do
            local low = Plain(l.text):lower()
            if not l.drop and not inRun[l] and (low:find("set my hearthstone") or low:find("stone in my pack pointed") or low:find("by my own count")) then l.drop = true end
        end
    end
    -- (lane O8: "There, Marrow joined me." while Dahlia was already with me is "joined us")
    for _, l in ipairs(lines) do
        if not l.drop and l.cls == "who" and l.text:find(" joined me", 1, true) then
            local plain = Plain(l.text)
            for name, spans in pairs(windows) do
                if not plain:find("%f[%a]" .. Esc(name) .. "%f[%A]") then
                    for _, sp in ipairs(spans) do
                        if sp[1] <= l.t - 60 and sp[2] >= l.t then l.text = l.text:gsub(" joined me([%s%.,])", " joined us%1"); break end
                    end
                end
            end
        end
    end
    if C.SOLO_FIX and anyWindow then
        local PERSONAL = {learn = true, craft = true, gather = true, level = true, origin = true, open = true, mood = true}
        for _, l in ipairs(lines) do
            if not inRun[l] and not l.drop and l.ep.kind ~= "dungeon" and l.cls ~= "who" and l.cls ~= "death" and l.cls ~= "close" and l.cls ~= "open" and not PERSONAL[l.kind or ""] then
                local together = WithAtDay(windows, l.t)
                local low = Plain(l.text):lower()
                local personal = low:find("hearthstone") or (l.meta.e and l.meta.e.d == "rezother") or low:find("my first death") or low:find("the first i ever")
                    or low:find("not died") or low:find("walked back as a spirit") or low:find("found my body") or low:find("my own feet") or low:find("as a ghost")
                    or low:find("as a spirit") or low:find("my body") or low:find("where i fell")
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

    -- (lane O8, reader round 10: a place with no told work is not narrated unless it is a first worth
    -- one clause, and the firsts of a crossing run fold into one sentence: "By way of the Hillsbrad
    -- Foothills and the Arathi Highlands, we came into the Wetlands, all of it new to us", or
    -- "Westfall and the Stonetalon Mountains were new to me" when a crossing or the hearthstone cut
    -- the road, or the chapter ended there. The rest of such a place's lines, the road into it,
    -- its lore, the crossings out of it, go; the company's comings and goings and the levels stay.)
    -- (lane O8, the player on the road to Loch Modan and back: a run of short stays that is mostly
    -- movement is a JOURNEY, told as one road, C.TellExpedition. Its stops' own road lines, firsts,
    -- lore and deaths give way to it; the company's comings and goings, the work and the levels stay.)
    if C.EXPEDITION and P.journeyOut0 and P.journeyBack0 then
        for _, run in ipairs(C.FindExpeditions(episodes)) do
            local told = C.TellExpedition(run, {P = P, Place = Place, level = tonumber(ctx.level), Shape = DeathShape,
                Pick = function(key, pool, tokens) return Pick(key, pool, tokens, true) end,
                With = function(t) return WithAtDay(windows, t) end})
            local endT = told[#told] and told[#told].t or 0
            local setOut = run.setOut
            for i, ep in ipairs(run.eps) do
                for _, x in ipairs(byEp[ep]) do
                    if not x.drop and not x.toClose and not inRun[x] then
                        local low = Plain(x.text):lower()
                        local road = x.cls == "arrive" or x.cls == "move" or x.cls == "town" or x.cls == "cave" or x.cls == "rest" or x.cls == "night"
                            or x.cls == "place" or x.cls == "death" or x.kind == "peril" or x.kind == "first"
                            or (x.cls == "what" and (Any(low, FIRST) or low:find("killed me") or low:find("my body"))) or (x.cls == "voyage" and x.t < endT - 120)
                        -- (the start keeps how the reader came there and what fell before the road)
                        if road and (i > 1 or x.t >= setOut - 60) then x.drop = true end
                    end
                end
            end
            -- (the work the road went for is its goal, told in its opening: not folded again)
            if run.goalQ then
                for _, x in ipairs(byEp[run.goalQ.ep]) do
                    if x.meta and x.meta.compose == "fold" and x.meta.count == 1 then x.drop = true end
                end
            end
            for _, l in ipairs(told) do l.n = #out + 700 + l.ep.index; lines[#lines + 1] = l; byEp[l.ep][#byEp[l.ep] + 1] = l end
        end
    end
    -- (lane O8 round 9, reader I rule 4: deaths collapse into their consequence. A stay with three
    -- deaths or more, or two death lines, tells them in one sentence after the last of them: the
    -- first killer by place, the others, the company's falls as one clause, who raised me. A first
    -- (my first death, the first I raised) keeps its own line, and then the stay is left as it is.)
    -- (lane O8 round 11, reader K rules 2-3: a stretch where I died three times or more is told among
    -- its work by time: the deaths between two told steps are one moment, who killed me, who fell
    -- with me within a minute of it, who raised me; never counted, never batched before or after.)
    if C.DEATHS_INTERLEAVE ~= false then
        for _, ep in ipairs(episodes) do
            if ep.kind ~= "dungeon" and not ep.expedition then
                local evs = C.DeathEvents({ep})
                local own = 0
                for _, x in ipairs(evs) do if x.e.k == "death" then own = own + 1 end end
                local kept, firstLine, raisedOther, lead = {}, false, false, nil
                for _, x in ipairs(byEp[ep]) do
                    if not x.drop and not inRun[x] then
                        local low = Plain(x.text):lower()
                        if (x.meta and x.meta.e and x.meta.e.d == "rezother") or (Any(low, {"the first i", "my first", "for the first time"}) and Any(low, {"from death", "rose", "raised", "brought back"})) then raisedOther = true end
                        if x.cls == "death" then
                            if Any(low, {"my first", "first death", "the first i", "first time", "since i rose"}) then firstLine = true
                            elseif Any(low, {"killed", "got me", " fell", "went down", "took ", "finished", "raised", "brought me back", "died", "the end of me", "prayers"}) then kept[#kept + 1] = x
                            elseif not lead then lead = x end
                        end
                    end
                end
                local total = 0
                for _, x in ipairs(evs) do if x.e.k ~= "rez" then total = total + 1 end end
                -- (round 13: three deaths of mine, or two among four falls and more, are a stretch)
                if (own >= 3 or (own >= 2 and total >= 4)) and #kept >= 1 and not firstLine and not raisedOther then
                    local told = {}
                    for _, x in ipairs(byEp[ep]) do if not x.drop and not inRun[x] and x.cls == "quest" then told[#told + 1] = x.t end end
                    -- (round 13: a named killer's death is its own moment, at its time, "Thule Ravenclaw
                    -- cut Dahlia, Saint, Varreth and me down"; the rest of the stretch is one sentence
                    -- about the danger of the place, at its first death)
                    local named, rest_ = {}, {}
                    -- (only the stretch's last death, at a named killer's hand, is its own moment)
                    local lastOwn
                    for _, x in ipairs(evs) do if x.e.k == "death" then lastOwn = x end end
                    if own >= 4 and lastOwn and lastOwn.e.d and not lastOwn.e.env and A.FoeNamed and A.FoeNamed(Clean(lastOwn.e.d)) then named[1] = lastOwn end
                    local namedSet = {}
                    for _, x in ipairs(named) do namedSet[x] = true end
                    local namedGroups = {}
                    for _, nx in ipairs(named) do
                        local g = {nx}
                        for _, x in ipairs(evs) do
                            if x ~= nx and x.e.k ~= "death" and math.abs(x.t - nx.t) <= 150 then g[#g + 1] = x; namedSet[x] = true end
                        end
                        table.sort(g, function(a_, b_) return a_.t < b_.t end)
                        namedGroups[#namedGroups + 1] = g
                    end
                    for _, x in ipairs(evs) do if not namedSet[x] then rest_[#rest_ + 1] = x end end
                    local partySet = {}
                    for _, n in ipairs(ep.party or {}) do partySet[n] = true end
                    local r = C.EpisodeDanger(ep)
                    local killedMe = (P.journeyKilled and P.journeyKilled[r]) or "killed me"
                    local made = {}
                    local restOwn = 0
                    for _, x in ipairs(rest_) do if x.e.k == "death" then restOwn = restOwn + 1 end end
                    if restOwn >= 2 then
                        local text = C.DangerSentence(rest_, {Place = Place, killedMe = killedMe, party = partySet})
                        if text then
                            local at = rest_[#rest_].t
                            made[#made + 1] = {cls = "death", t = at, ep = ep, text = text, major = false, kind = "deathGroup", meta = {t = at, compose = "deaths"}, n = #out + 750 + ep.index}
                        end
                    elseif restOwn == 1 then
                        local text = C.DeathGroup(rest_, {Place = Place, killedMe = killedMe, party = partySet, exact = true, stay = true, Shape = DeathShape})
                        if text then
                            local at = rest_[1].t
                            for _, x in ipairs(rest_) do if x.e.k == "death" then at = x.t; break end end
                            made[#made + 1] = {cls = "death", t = at, ep = ep, text = text, major = false, kind = "deathGroup", meta = {t = at, compose = "deaths"}, n = #out + 750 + ep.index}
                        end
                    end
                    for gi, g in ipairs(namedGroups) do
                        local text = C.DeathGroup(g, {Place = Place, killedMe = killedMe, party = partySet, exact = true, stay = true, Shape = DeathShape})
                        if text then
                            made[#made + 1] = {cls = "death", t = g[1].t, ep = ep, text = text, major = false, kind = "deathGroup", meta = {t = g[1].t, compose = "deaths"}, n = #out + 760 + ep.index + gi / 10}
                        end
                    end
                    if #made > 0 then
                        for _, x in ipairs(kept) do x.drop = true end
                        if lead then
                            local first_ = made[1].text:gsub("^At [^,]-%} ", function(m) return Plain(lead.text):find(Plain(m:sub(4, -2)):gsub("^the ", ""), 1, true) and "" or m end)
                            first_ = first_:gsub("^At [%w' ]- (the %u)", function(m, rest) return rest end)
                            made[1].text = lead.text:gsub("%s*$", "") .. " " .. Cap(first_)
                            lead.drop = true
                        end
                        for _, l in ipairs(made) do lines[#lines + 1] = l; byEp[ep][#byEp[ep] + 1] = l end
                    end
                end
            end
        end
    end
    if C.DEATHS_ONE == true then
        for _, ep in ipairs(episodes) do
            if ep.kind ~= "dungeon" and not ep.expedition then
                local evs = C.DeathEvents({ep})
                local deaths, kept, firstLine = 0, {}, false
                for _, x in ipairs(evs) do if x.e.k ~= "rez" then deaths = deaths + 1 end end
                for _, x in ipairs(byEp[ep]) do
                    if not x.drop and not inRun[x] and x.cls == "death" then
                        local low = Plain(x.text):lower()
                        if Any(low, {"my first", "first death", "the first i", "first time", "since i rose"}) or (x.meta and x.meta.e and x.meta.e.d == "rezother") then
                            if not (x.meta and x.meta.e and x.meta.e.d == "rezother") then firstLine = true end
                        elseif Any(low, {"killed", "got me", " fell", "went down", "took ", "finished", "raised", "brought me back", "died", "the end of me", "prayers"}) then
                            kept[#kept + 1] = x
                        end
                    end
                end
                local raisedOther = false
                for _, x in ipairs(byEp[ep]) do
                    local low = Plain(x.text):lower()
                    if not x.drop and ((x.meta and x.meta.e and x.meta.e.d == "rezother") or (Any(low, {"the first i", "my first", "for the first time"}) and Any(low, {"from death", "rose", "raised", "brought back"}))) then raisedOther = true end
                end
                if not firstLine and not raisedOther and #kept >= 1 and (deaths >= 3 or #kept >= 2) then
                    local partySet = {}
                    for _, n in ipairs(ep.party or {}) do partySet[n] = true end
                    local r = C.EpisodeDanger(ep)
                    local text = C.DeathSummary(evs, {Place = Place, killedMe = (P.journeyKilled and P.journeyKilled[r]) or "killed me", party = partySet})
                    if text then
                        for _, x in ipairs(kept) do x.drop = true end
                        -- (the stretch's own lead, "It went badly at Fenris Isle.", takes the sentence after it)
                        local lead
                        for _, x in ipairs(byEp[ep]) do if not x.drop and not inRun[x] and x.cls == "death" and x.kind ~= "deathSum" and not lead then lead = x end end
                        if lead then text = C.DeathSummary(evs, {Place = Place, killedMe = (P.journeyKilled and P.journeyKilled[r]) or "killed me", party = partySet, said = Plain(lead.text)}) end
                        -- (at the stretch's middle, as the teller's passage was: the work done inside it before)
                        local times_ = {}
                        for _, x in ipairs(evs) do if x.e.k ~= "rez" then times_[#times_ + 1] = x.t end end
                        local at = times_[math.floor((#times_ + 1) / 2)] or evs[1].t
                        if lead and text then lead.text = lead.text:gsub("%s*$", "") .. " " .. text
                        elseif text then
                            local l = {cls = "death", t = at, ep = ep, text = text, major = false, kind = "deathSum", meta = {t = at, compose = "deaths"}, n = #out + 750 + ep.index}
                            lines[#lines + 1] = l; byEp[ep][#byEp[ep] + 1] = l
                        end
                    end
                end
            end
        end
    end
    if P.crossRun and P.crossRunNew and P.crossOnly then
        local function Substance(ep)
            if ep.kind == "dungeon" or ep.expedition then return true end
            -- (round 9: the fold of a stay's untold work is not what names it)
            for _, x in ipairs(byEp[ep]) do
                if not x.drop and (inRun[x] or x.cls == "quest" or x.cls == "death" or x.cls == "milestone" or x.cls == "open"
                    or (x.cls == "what" and x.kind ~= "first" and x.kind ~= "peril" and x.kind ~= "fold" and not Any(Plain(x.text):lower(), FIRST))) then return true end
            end
            return false
        end
        local function IsFirst(ep)
            for _, f in ipairs(ep.firsts or {}) do
                if f.what == "zone" and (not f.z or Clean(f.z) == Clean(ep.zone or "")) then return true end
            end
            return false
        end
        local function Cut(ep) return #(ep.voyages or {}) > 0 or ep.hearth ~= nil end
        local DROP = {arrive = true, move = true, voyage = true, night = true, place = true, town = true, cave = true, rest = true}
        local function Silence(ep, keep)
            for _, x in ipairs(byEp[ep]) do
                -- (round 10: the hearthstone home before the crossing that carried us on is a leg of the road)
                local leg = keep and x.meta and x.meta.hearth and x.t < keep.t
                if x ~= keep and not leg and not x.drop and not x.toClose and (DROP[x.cls] or x.kind == "peril" or x.kind == "first"
                    or (x.cls == "what" and Any(Plain(x.text):lower(), FIRST))) then x.drop = true end
            end
        end
        local function Names(eps)
            local list, seen = {}, {}
            for _, ep in ipairs(eps) do
                for _, f in ipairs(ep.firsts or {}) do
                    local zone = f.what == "zone" and (f.z or ep.zone) or nil
                    if zone and not seen[Clean(zone)] then seen[Clean(zone)] = true; list[#list + 1] = Place(zone) end
                end
            end
            return list
        end
        -- (a road told as a journey, the day's last or a long one with a town on it, keeps its
        -- own paragraph: "We stopped a while in the Crossroads ... We came up to Thunder Bluff")
        local function Road(ep)
            if ep.kind ~= "journey" then return false end
            if ep.index == #episodes then return true end
            if (ep.e or ep.t) - ep.t < 30 * 60 then return false end
            for _, x in ipairs(byEp[ep]) do if not x.drop and x.cls == "town" then return true end end
            return false
        end
        local i = 2
        while i <= #episodes do
            if not Substance(episodes[i]) and not Road(episodes[i]) then
                local j = i
                while episodes[j + 1] and not Substance(episodes[j + 1]) and not Road(episodes[j + 1]) do j = j + 1 end
                local D = episodes[j + 1]
                -- (the tail: the places walked through, no crossing between them and the next stop)
                local tailFrom = j + 1
                for k = j, i, -1 do if Cut(episodes[k]) then break end tailFrom = k end
                local head, tail = {}, {}
                for k = i, tailFrom - 1 do head[#head + 1] = episodes[k] end
                for k = tailFrom, j do tail[#tail + 1] = episodes[k] end
                local headNames, tailNames = Names(head), Names(tail)
                if not D and #tailNames > 0 then
                    for _, name in ipairs(tailNames) do headNames[#headNames + 1] = name end
                    tailNames = {}
                end
                -- (the crossing or the flight that carried the reader to the next told stop stays)
                local carry
                if D then
                    for k = i, j do
                        for _, x in ipairs(byEp[episodes[k]]) do
                            if not x.drop and (x.cls == "voyage" or x.cls == "night") and (not carry or x.t > carry.t) then carry = x end
                        end
                    end
                end
                for k = i, j do Silence(episodes[k], carry) end
                -- (round 17: the arrival lines made for a first land after this are kept)
                -- (round 13, reader O rule 6: a first visit is said in one clause on the road out of it,
                -- "From Westfall, new to us, my hearthstone took us back to the Sepulcher, ...")
                if #headNames == 1 and not C.NAME_EMPTY_LANDS then
                    for _, x in ipairs(lines) do
                        if not x.drop and x.legs and x.t >= head[1].t and (not D or x.t <= D.t) and (x.text:find("^My hearthstone") or x.text:find("^Our hearthstones")) then
                            local party = WithAtDay(windows, x.t)
                            local why = ""
                            for _, h in ipairs(head) do
                                for _, q in ipairs(h.quests or {}) do
                                    local chain = C.ChainOf(q.quest and q.quest.qid, P)
                                    if chain and chain.start and why == "" then why = ", " .. Fill(chain.start, {we = party and "we" or "I", us = party and "us" or "me"}) end
                                end
                            end
                            -- (round 17, reader S: no teleport. The crossings that brought us there are told at the
                            -- arrival, "The zeppelin took us across to Kalimdor and back, and we came to Westfall,
                            -- new to us, ...", and the leaving starts "From Westfall, ...")
                            local legs_ = {}
                            local landEp
                            for _, h in ipairs(head) do
                                for _, f in ipairs(h.firsts or {}) do if f.what == "zone" and not landEp then landEp = h end end
                            end
                            for _, h in ipairs(head) do
                                for _, sc in ipairs(h.scenes or {}) do
                                    for _, e in ipairs(sc.events or {}) do
                                        if e.k == "voyage" and e.d and e.d ~= "hearth" and e.d ~= "portal" and landEp and (e.t or 0) <= landEp.t + 60 then legs_[#legs_ + 1] = e end
                                    end
                                end
                            end
                            table.sort(legs_, function(a_, b_) return (a_.t or 0) < (b_.t or 0) end)
                            if landEp and #legs_ > 0 and P.arriveBy then
                                local how
                                local a1, a2 = legs_[1], legs_[2]
                                if a2 and a1.d == a2.d and a1.from and a2.to and Clean(a1.from) == Clean(a2.to) then how = "the " .. a1.d .. " took " .. (party and "us" or "me") .. " across to " .. Clean(a1.to or "") .. " and back"
                                else how = "the " .. legs_[#legs_].d .. " took " .. (party and "us" or "me") .. " to " .. Clean(legs_[#legs_].to or "") end
                                local text = Fill(P.arriveBy[1], {how = how, land = headNames[1], us = party and "us" or "me", we = party and "we" or "I", why = why})
                                local l = {cls = "what", t = landEp.t, ep = landEp, text = Cap(text), major = false, kind = "first", meta = {t = landEp.t, compose = "arrive"}, n = #out + 610 + landEp.index}
                                lines[#lines + 1] = l; byEp[landEp][#byEp[landEp] + 1] = l
                                x.text = "From " .. headNames[1] .. ", " .. x.text:gsub("^%u", string.lower)
                            else
                                x.text = "From " .. headNames[1] .. ", new to " .. (party and "us" or "me") .. why .. ", " .. x.text:gsub("^%u", string.lower)
                            end
                        end
                    end
                end
                if #headNames > 0 and C.NAME_EMPTY_LANDS then
                    local ep = head[#head] or tail[#tail]
                    -- (lane O8: said where the first of those lands was reached, not in a later stop)
                    for _, h in ipairs(head) do if IsFirst(h) then ep = h; break end end
                    local party = WithAtDay(windows, ep.t)
                    -- (round 10: every new land has a road; the crossing that brought us, when one did)
                    local how
                    for _, h in ipairs(head) do
                        for _, sc in ipairs(h.scenes or {}) do
                            for _, e in ipairs(sc.events or {}) do
                                if e.k == "voyage" and e.d and e.d ~= "hearth" and e.d ~= "portal" and (e.t or 0) <= ep.t + 60 and (e.t or 0) >= ep.t - 1800 then how = e.d end
                            end
                        end
                    end
                    local text = how and P.crossOnlyBy and Pick("crossOnlyBy", P.crossOnlyBy, {Places = List(headNames), how = how, us = party and "us" or "me",
                        were = (#headNames > 1 or Plural(headNames[1])) and "were" or "was"}, true)
                    text = text or Pick("crossOnly", P.crossOnly, {Places = Cap(List(headNames)), us = party and "us" or "me",
                        were = (#headNames > 1 or Plural(headNames[1])) and "were" or "was"}, true)
                    -- (round 9: a land named only as new takes the clause of its folded work, "Westfall was new
                    -- to us, and we saw to one task there", never two stub sentences)
                    for _, h in ipairs(head) do
                        for _, x in ipairs(byEp[h]) do
                            if text and not x.drop and x.kind == "fold" and not (x.meta and x.meta.chapter) and #headNames == 1 and P.crossFold then
                                text = text:gsub("%.$", "") .. Fill(P.crossFold[1], {we = party and "we" or "I", count = x.meta.foldCount or "", tasks = x.meta.foldTasks or "tasks"})
                                x.drop = true
                            end
                        end
                    end
                    if text then
                        local l = {cls = "what", t = ep.t, ep = ep, text = text, major = false, kind = "first", meta = {t = ep.t, compose = "cross"}, n = #out + 600 + ep.index}
                        lines[#lines + 1] = l; byEp[ep][#byEp[ep] + 1] = l
                    end
                end
                if D and #tailNames > 0 then
                    -- (the next stop's own road line and plain "first time" line give way to the fold)
                    local newToo = IsFirst(D)
                    for _, x in ipairs(byEp[D]) do
                        if not x.drop then
                            local low = Plain(x.text):lower()
                            if x.cls == "arrive" or x.cls == "move" then x.drop = true
                            elseif newToo and (x.cls == "what" or x.cls == "who" or x.cls == "place") and Any(low, FIRST) and D.zone and low:find(Clean(D.zone):lower(), 1, true)
                                and not Any(low, {"level", "young", "early", "late", "below", "dangerous", "inexperienced"}) then x.drop = true end
                        end
                    end
                    local party = WithAtDay(windows, D.t)
                    local tokens = {places = List(tailNames), zoneD = Place(D.zone), We = party and "We" or "I", we = party and "we" or "I", us = party and "us" or "me"}
                    local text = Pick(newToo and "crossRunNew" or "crossRun", newToo and P.crossRunNew or P.crossRun, tokens, true)
                    if text then
                        local l = {cls = "arrive", t = D.t, ep = D, text = text, major = false, kind = "move", meta = {t = D.t, compose = "cross"}, n = #out + 600 + D.index}
                        lines[#lines + 1] = l; byEp[D][#byEp[D] + 1] = l
                    end
                end
                i = j + 1
            else
                i = i + 1
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
    local function LevelLine(level, ep, at, quiet)
        local tokens = {level = tostring(level)}
        -- the deed just before it, the town it came at, or the zone
        local deed
        for _, x in ipairs(byEp[ep]) do
            if not x.drop and (x.cls == "quest" or x.cls == "what") and x.t <= at and at - x.t <= 300 and (not deed or x.t > deed.t) then deed = x end
        end
        -- (a hand-in the chapter left out between the deed and the level: the level was not the deed's;
        -- lane O8: one handed in within two minutes of the deed is of the same burst of hand-ins, and
        -- the level is the burst's)
        if deed then
            for _, sc in ipairs(ep.scenes) do
                for _, q in ipairs(sc.quests or {}) do if (q.t or 0) > deed.t + 120 and (q.t or 0) <= at then deed = nil end end
            end
        end
        if deed and W.levelWithIt then
            local head, lastSentence = deed.text:match("^(.*%. )([^%.]+%.)$")
            if head and (lastSentence:find(" and ", 1, true) or Words(lastSentence) > 20) then
                -- (lane O8: a level that came at a burst of told hand-ins, when the last cannot take the
                -- clause, is told after the burst in a sentence of its own: "By then I was level 18.")
                local burst = 0
                for _, x in ipairs(byEp[ep]) do
                    if not x.drop and x.cls == "quest" and x.t <= at and at - x.t <= 180 then burst = burst + 1 end
                end
                if burst >= 2 and P.levelBurst then return Pick("levelBurst", P.levelBurst, tokens, quiet), deed, "burst" end
                -- ("with it" after a second sentence points at nothing: the place, or "not long after")
                if deed.text:find("{p:", 1, true) and W.levelThere then return Pick("levelThere", W.levelThere, tokens, quiet), deed end
                if P.levelSoon then return Pick("levelSoon", P.levelSoon, tokens, quiet), deed end
            end
            return Pick("levelWith", W.levelWithIt, tokens, quiet), deed, "with"
        end
        local near
        for _, x in ipairs(byEp[ep]) do
            if not x.drop and (x.cls == "quest" or x.cls == "what") and x.t <= at and at - x.t <= 20 * 60 and (not near or x.t > near.t) then near = x end
        end
        if near and P.levelSoon then return Pick("levelSoon", P.levelSoon, tokens, quiet), near end
        local town
        for _, s in ipairs(ep.scenes) do
            for _, e in ipairs(s.events or {}) do
                if (e.k == "rest" or e.k == "town" or e.k == "home") and e.d and math.abs((e.t or 0) - at) <= 120 and IsTown(e.d) then town = e.d end
            end
        end
        if town and P.levelAt then tokens.place = Place(town); return Pick("levelAt", P.levelAt, tokens, quiet), nil end
        if ep.zone and P.levelIn then tokens.zone = Place(ep.zone); return Pick("levelIn", P.levelIn, tokens, quiet), nil end
        return nil
    end
    local added = {}
    -- (the day's last level, by the record: the only one the composer gives a line of its own)
    local lastLevel, lastLevelT
    for _, s in ipairs(stretches) do
        for _, e in ipairs(s.events or {}) do
            if e.k == "mylevel" and e.d and e.t and (not lastLevelT or e.t > lastLevelT) then lastLevel, lastLevelT = tostring(tonumber(e.d) or e.d), e.t end
        end
    end
    for _, l in ipairs(lines) do
        if l.cls == "level" and not inRun[l] then
            local plain = Plain(l.text)
            -- (the day's last level, whatever shape the teller gave the line: a span tells its top)
            local num
            for n in pairs(LevelsSaid(plain)) do if not num or tonumber(n) > tonumber(num) then num = n end end
            local at = (l.meta.levelEarly and l.meta.t) or l.t
            -- (the record's own time for that level, when it has one: the teller says it at the stay's end)
            for _, s in ipairs(stretches) do
                for _, e in ipairs(s.events or {}) do if e.k == "mylevel" and tostring(e.d) == tostring(num) and e.t then at = e.t end end
            end
            local ep = EpisodeAt(at, episodes)
            if ep.kind == "dungeon" then
                -- (a level of the run is the run's to tell; said by the dungeon writer)
                l.ep = ep
            else
                l.ep, l.t = ep, at
                -- (lane S: a level is told where it came, never as bookkeeping at the close)
                -- (the teller's line for the day's last level, whatever its shape, unless it is an early
                -- level's own line with its feeling)
                if num and (not lastLevel or num == lastLevel) and (plain:match("^I reached level %d+ there%.$") or plain:match("^Level %d+ came there%.$") or (not l.meta.levelEarly and Words(plain) <= 12
                    and (plain:match("^I reached level ") or plain:match("^Level %d+ came") or plain:match(" with it%.$") or plain:find("from level ") or plain:find("level %d+ to %d+")
                    or plain:match("^By the end of the day") or plain:match("^I started the day at level") or plain:match(" when I stopped%.$")))) then
                    local text, deed = LevelLine(num, ep, at)
                    if text then l.text = text; l.after = deed; l.meta.compose = "level" end
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
    -- (lane S: the span "from level 1 to 7" is gone; the day's last level is told where it came)
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
                local text, deed, how = LevelLine(num, ep, lv.t)
                if text then
                    levelNums[num] = true
                    added[#added + 1] = {cls = "level", t = lv.t, ep = ep, text = text, after = deed, major = false, kind = "level", meta = {t = lv.t, compose = "level", burst = how == "burst" or nil}, n = #out + #added + 1}
                end
            end
        elseif lv.t and not levelNums[num] then
            -- (lane O8: an earlier level of the day is told where it came, as a clause of the told deed it
            -- came with or after the burst of hand-ins it came at; one that came away from any told deed
            -- is not told, the close has the day's last)
            local ep = EpisodeAt(lv.t, episodes)
            if ep.kind ~= "dungeon" then
                local text, deed, how = LevelLine(num, ep, lv.t, true)
                if text and deed and (how == "with" or how == "burst") then
                    levelNums[num] = true
                    added[#added + 1] = {cls = "level", t = lv.t, ep = ep, text = text, after = deed, major = false, kind = "level", meta = {t = lv.t, compose = "level", burst = how == "burst" or nil}, n = #out + #added + 1}
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
                -- (lane S: two who left at once leave in one sentence)
                local gone, leftAt = {}, ep.t
                for name in pairs(windows) do
                    if PresentIn(name, before) and not PresentIn(name, ep) and (minutes[name] or 0) >= 1800 and chapterPlain:find(name, 1, true) then
                        gone[#gone + 1] = name
                        for _, sp in ipairs(windows[name] or {}) do if sp[2] <= ep.t and sp[2] > leftAt - 3600 then leftAt = sp[2] end end
                    end
                end
                -- (lane O8: the leaving is told only before something the chapter tells without them;
                -- "Marrow fell. Marrow was gone by then." at the end of a day says nothing)
                if #gone > 0 then
                    local after = false
                    for _, l in ipairs(lines) do
                        if not l.drop and not l.toClose and l.t >= leftAt and (l.cls == "quest" or l.cls == "death" or l.cls == "place" or l.cls == "town"
                            or (l.cls == "what" and l.kind ~= "level") or inRun[l]) then after = true end
                    end
                    if not after and C.LEAVE_NEEDS_AFTER ~= false then gone = {} end
                end
                if #gone > 0 then
                    table.sort(gone)
                    local names = {}
                    for _, name in ipairs(gone) do names[#names + 1] = "{n:" .. name .. "}" end
                    local text = Pick("left", P.left, {name = List(names), was = #names > 1 and "were" or "was"})
                    if text then added[#added + 1] = {cls = "who", t = leftAt, ep = ep, text = text, major = false, kind = nil, meta = {t = leftAt, compose = "left"}, n = #out + #added + 1} end
                end
            end
        end
        -- (lane S: someone the chapter names, in a death or a raise, whose joining it never told
        -- is told joining at the time the record has them)
        if P.joinedLate then
            local deathText, otherText = {}, {}
            for _, l in ipairs(lines) do
                if not l.drop and not inRun[l] then
                    if l.cls == "death" then deathText[#deathText + 1] = Plain(l.text) else otherText[#otherText + 1] = Plain(l.text) end
                end
            end
            for _, l in ipairs(added) do if l.cls == "who" then otherText[#otherText + 1] = Plain(l.text) end end
            deathText, otherText = table.concat(deathText, " "), table.concat(otherText, " ")
            -- (a party death of someone with no window that day: the record still has them, at that time)
            local firstFall, keyOf = {}, {}
            for _, s in ipairs(stretches) do
                for _, w in ipairs(s.with or {}) do
                    local name = (Clean(w.name):gsub("%-.*$", ""))
                    if w.key and not keyOf[name] then keyOf[name] = w.key end
                end
                for _, e in ipairs(s.events or {}) do
                    if e.k == "pdeath" and e.n and e.t then
                        local name = (Clean(e.n):gsub("%-.*$", ""))
                        if not keyOf[name] then keyOf[name] = Clean(e.n):lower() end
                        if not windows[name] and (not firstFall[name] or e.t < firstFall[name]) then firstFall[name] = e.t end
                    end
                end
            end
            -- (lane P7: a person enters the book once, with who they are: the card's race and
            -- class, "Saint, a Forsaken paladin", else "a newcomer"; a name the book's earlier
            -- chapters told needs no entry)
            local bookBefore = (ctx.history and ctx.history.plan and ctx.history.plan.text) or ""
            local function KnownBefore(name) return bookBefore:find("%f[%a]" .. Esc(name) .. "%f[%A]") ~= nil end
            local function Role(name)
                local key = keyOf[name]
                local info = key and ((ctx.Companion and ctx.Companion(key)) or (A.db and A.db.people and A.db.people[key])) or nil
                if not info then return nil end
                local people = A.Lore and A.Lore.People and A.Lore.People(info.race)
                local classWord = info.class and ((LOCALIZED_CLASS_NAMES_MALE and LOCALIZED_CLASS_NAMES_MALE[info.class]) or info.class):lower()
                local who = (people and classWord and (people .. " " .. classWord)) or classWord or people
                return who and ((who:match("^[aeiou]") and "an " or "a ") .. who) or nil
            end
            local candidates = {}
            for name, spans in pairs(windows) do candidates[name] = (minutes[name] or 0) >= 600 and spans[1] and spans[1][1] or nil end
            for name, t in pairs(firstFall) do candidates[name] = t end
            for name, first in pairs(candidates) do
                if first and deathText:find("%f[%a]" .. Esc(name) .. "%f[%A]") and not otherText:find("%f[%a]" .. Esc(name) .. "%f[%A]") and not deathText:find("named " .. name, 1, true) then
                    local ep = EpisodeAt(first, episodes)
                    if ep.kind ~= "dungeon" then
                        local who = (not KnownBefore(name)) and (Role(name) or "a newcomer") or nil
                        local joined = false
                        if who then
                            -- (the join told in the same stretch takes the name with it: "I fell in with
                            -- Varreth, a Forsaken paladin, and Saint, a Forsaken paladin")
                            for _, x in ipairs(byEp[ep]) do
                                if not joined and not x.drop and x.cls == "who" and x.n <= #out and math.abs(x.t - first) <= 20 * 60 then
                                    local head = x.text:match("^(.-I fell in with .-, an? [%a' ]+)%.$")
                                    local tail = "."
                                    if not head then
                                        head = x.text:match("^(.-I met .-, an? [%a' ]+), and we went on together%.$")
                                        if head then tail = ", and we went on together." end
                                    end
                                    if not head then
                                        -- ("Varreth, a Forsaken paladin, fell in beside me." / ", joined me." / ", came along with me.")
                                        head, tail = x.text:match("^(.-, an? [%a' ]+)(, %l[%l ]+ me%.)$")
                                    end
                                    if head then x.text = head .. ", and {n:" .. name .. "}, " .. who .. tail; joined = true end
                                end
                            end
                        end
                        if not joined then
                            local text = (who and P.joinedLateNew and Pick("joinedLateNew", P.joinedLateNew, {name = "{n:" .. name .. "}", who = who}))
                                or Pick("joinedLate", P.joinedLate, {name = "{n:" .. name .. "}"})
                            -- (round 13: told at the record's first sign of them, not at the stay's start)
                            if text then added[#added + 1] = {cls = "who", t = first - 120, ep = ep, text = text, major = false, kind = nil, meta = {t = first - 120, compose = "joined"}, n = #out + #added + 1, signMoved = first > ep.t + 300 or nil} end
                        end
                    end
                end
            end
        end
    end
    -- (lane O8, reader H: a companion named in a join and a leave and nowhere else that day, while
    -- another of the company covers every told moment of their time, is not named that day; a join
    -- alone stays, it is the record's event at its own time)
    do
        local who, rest = {}, {}
        for _, l in ipairs(lines) do if not l.drop and not inRun[l] and l.cls == "who" then who[#who + 1] = l end end
        for _, l in ipairs(added) do if l.cls == "who" then who[#who + 1] = l end end
        for _, l in ipairs(lines) do if not l.drop and l.cls ~= "who" and l.cls ~= "close" then rest[#rest + 1] = l end end
        for _, l in ipairs(added) do if l.cls ~= "who" then rest[#rest + 1] = l end end
        for name, spans in pairs(windows) do
            local elsewhere, mine = false, {}
            for _, l in ipairs(rest) do if Plain(l.text):find("%f[%a]" .. Esc(name) .. "%f[%A]") then elsewhere = true end end
            for _, l in ipairs(who) do if Plain(l.text):find("%f[%a]" .. Esc(name) .. "%f[%A]") then mine[#mine + 1] = l end end
            if not elsewhere and #mine >= 2 then
                local covered = true
                for _, l in ipairs(rest) do
                    local inside = false
                    for _, sp in ipairs(spans) do if l.t >= sp[1] and l.t <= sp[2] then inside = true end end
                    if inside then
                        local other = false
                        for otherName, otherSpans in pairs(windows) do
                            if otherName ~= name then
                                for _, sp in ipairs(otherSpans) do if l.t >= sp[1] and l.t <= sp[2] then other = true end end
                            end
                        end
                        if not other then covered = false end
                    end
                end
                -- (round 15, reader Q rule 1: everyone the record puts in the group is named; this hiding is off)
                if covered and C.HIDE_COVERED then
                    for _, l in ipairs(mine) do
                        -- (a line that names others too keeps them: only the lone name's line goes)
                        local others = 0
                        for otherName in pairs(windows) do if otherName ~= name and Plain(l.text):find("%f[%a]" .. Esc(otherName) .. "%f[%A]") then others = others + 1 end end
                        if others == 0 then l.drop = true end
                    end
                end
            end
        end
    end
    for _, l in ipairs(added) do if not l.drop then lines[#lines + 1] = l; byEp[l.ep][#byEp[l.ep] + 1] = l end end
    -- e. counts go to the close: a level span and the quest count sit before the close lines
    for _, l in ipairs(lines) do
        if not l.drop and not inRun[l] and l.ep.kind ~= "dungeon" then
            if l.cls == "milestone" then l.toClose, l.closeRank = true, 2 end
        end
    end
    -- (one count a chapter, in the close: the quest count over the craft tally)
    do
        local milestone = false
        for _, l in ipairs(lines) do if not l.drop and l.toClose and l.cls == "milestone" then milestone = true end end
        if milestone then for _, l in ipairs(lines) do if l.toClose and l.cls == "craft" then l.drop = true end end end
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
        if l.cls == "who" and l.signMoved then return SLOT_WHAT end
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
                    if at and at < i then
                        -- (after the deed's whole scene: its outcome lines share its entry)
                        local entry = l.after.meta and l.after.meta.entry
                        while entry and kept[at + 1] and kept[at + 1] ~= l and kept[at + 1].meta and kept[at + 1].meta.entry == entry do at = at + 1 end
                        table.remove(kept, i); table.insert(kept, at + 1, l)
                    end
                end
            end
        end
        -- (a lone death is told inside the deed it interrupted (lane S): a clause of the line
        -- before it when that line can take one, "where" when the line ends on the place it
        -- happened in; else one sentence with what the death was ("..., my first death since I
        -- rose"); else a clause before the deed that followed it ("After I fell to a son of
        -- Arugal, we carried..."). It never stands as a bare entry between two errands.)
        if ep.kind ~= "dungeon" then
            for i = 1, #kept do
                local l, prev, nxt = kept[i], kept[i - 1], kept[i + 1]
                if l and l.cls == "death" and not l.drop and not l.inPassage and l.kind == "death" and Words(l.text) <= 14 and not Plain(l.text):find("%. ") then
                    local clause = DeathClause(l.text)
                    local joined = false
                    if prev and not prev.drop and not prev.merged and (prev.cls == "quest" or prev.cls == "open" or prev.cls == "arrive") and l.t - prev.t <= (prev.cls == "quest" and 15 or 30) * 60 and l.t >= prev.t - 60 then
                        local head, lastSentence = prev.text:match("^(.*%. )([^%.]+%.)$")
                        if not head then head, lastSentence = "", prev.text end
                        -- (not onto reported speech: "..., he said, and a buzzard killed me" hangs the death on his words)
                        if lastSentence and not lastSentence:find(" and ", 1, true) and lastSentence:match("%.$") and Words(lastSentence) <= 22
                            and not lastSentence:find(" said") and not lastSentence:find(" told ") and not lastSentence:find(" asked") then
                            local zone = l.s and l.s.zone and Clean(l.s.zone) or ""
                            local there = zone ~= "" and lastSentence:find("%a+ {p:" .. Esc(zone) .. "}%.$")
                            -- (round 10: "at the Greymane Wall" is not said twice in one sentence)
                            local at = clause:match(" at (the %b{})$") or clause:match(" at (%b{})$") or clause:match(" at ([^,{}]+)$")
                            if at and Plain(lastSentence):lower():find((Plain(at):lower():gsub("^the ", "")), 1, true) then clause = clause:sub(1, #clause - #at - 4) end
                            prev.text = head .. lastSentence:gsub("%.$", "") .. (there and ", where " or ", and ") .. clause .. "."
                            prev.merged, l.drop, joined = true, true, true
                        end
                    end
                    if not joined and nxt and not nxt.drop and nxt.cls == "what" and math.abs(nxt.t - l.t) <= 120 then
                        local tail = nxt.text:match("^It was (my [^%.]+%.)$")
                        if tail then
                            l.text = l.text:gsub("%.$", "") .. ", " .. tail
                            l.merged, nxt.drop, joined = true, true, true
                        end
                    end
                    if not joined and nxt and not nxt.drop and nxt.cls == "quest" and nxt.t >= l.t and nxt.t - l.t <= 30 * 60 and not nxt.text:find("^After ") then
                        local first, rest = nxt.text:match("^(.-%.)(.*)$")
                        if first and Words(first) <= 22 and (first:match("^We ") or first:match("^I ")) then
                            nxt.text = "After " .. clause .. ", " .. Lower(first) .. rest
                            nxt.merged, l.drop, joined = true, true, true
                        end
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
                    -- (lane S: "sent me" is followed by "I spoke with", not "we spoke with")
                    if starts[1] then
                        local sp = " " .. Plain(starts[1].text) .. " "
                        local mine = (sp:find("%Ame%A") or sp:find("%AI%A") or sp:find("%Amy%A")) and not (sp:find("%Awe%A") or sp:find("%AWe%A") or sp:find("%Aus%A") or sp:find("%Aour%A"))
                        if mine then
                            fig.text = Solo(fig.text)
                            for _, o in ipairs(outcomes) do o.text = Solo(o.text) end
                        end
                    end
                    for _, l in ipairs(starts) do block[#block + 1] = l end
                    block[#block + 1] = fig
                    if lore then block[#block + 1] = lore end
                    -- (lane S: the feeling a figure met earns when the book named them before,
                    -- JournalFeel.figureNamed, as the planned telling gives it: once a chapter, not
                    -- within three chapters of the last, every name in it said before, no line twice)
                    local felt = C.FigureFelt(ctx, name, short, fig, kept, chapterPlain)
                    if felt then block[#block + 1] = felt end
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
        if ep.kind ~= "dungeon" and ep.index > 1 and #kept > 0 and not (ep.expedition and (ep.expedition.eps[1] ~= ep or ep.expedition.before)) and not ep.roadTold then
            local prevEp = episodes[ep.index - 1]
            local opens = false
            local placeName = Clean(ep.zone or "")
            for j, l in ipairs(kept) do
                -- (lane O8: lore about the place, "Saws and water wheels interrupted the wooded slopes", does not say where we were)
                if l.cls == "open" or l.cls == "arrive" or (l.cls == "place" and (l.kind ~= "lore" or Plain(l.text):find(placeName, 1, true))) or (l.cls == "voyage" and l.slot ~= 9) then opens = true end
                if j <= 3 and placeName ~= "" and l.kind ~= "fold" and Plain(l.text):find(placeName, 1, true) then opens = true end
            end
            -- (lane O8: the crossing or the hearthstone told at the end of the stay before is the arrival)
            for _, l in ipairs(byEp[prevEp] or {}) do
                if not l.drop and (l.cls == "voyage" or l.cls == "night") and l.t >= (prevEp.e or prevEp.t) - 300 then opens = true end
            end
            local substance = false
            for _, l in ipairs(kept) do if l.cls == "quest" or l.cls == "what" or l.cls == "death" or l.cls == "place" or l.cls == "town" then substance = true end end
            if not opens and substance and prevEp and Clean(prevEp.zone or "") ~= Clean(ep.zone or "") then
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
                -- (lane O8: a land new to us, when no kept line says so, is new in the move itself)
                local newLand = false
                for _, f in ipairs(ep.firsts or {}) do if f.what == "zone" and Clean(f.z or ep.zone or "") == Clean(ep.zone or "") then newLand = true end end
                for _, x in ipairs(kept) do if Any(Plain(x.text):lower(), FIRST) then newLand = false end end
                local pool = (how == "flew" and P.moveFlew) or (how == "voyage" and P.moveVoyage) or (how == "hearth" and P.moveHearth)
                    or (newLand and P.moveWentNew) or P.moveWent
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
            local kind = (ep.expedition and "expedition") or (ep.adventure and "adventure") or ep.kind
            -- (lane O8: the stays of one road are one paragraph)
            local prevP = paragraphs[#paragraphs]
            if ep.expedition and prevP and prevP.ep.expedition == ep.expedition then
                for _, l in ipairs(kept) do prevP.lines[#prevP.lines + 1] = l end
                prevP.words, prevP.weight = prevP.words + words, prevP.weight + ep.weight
            else
                paragraphs[#paragraphs + 1] = {ep = ep, lines = kept, words = words, kind = kind, weight = ep.weight}
            end
        end
    end
    if #paragraphs == 0 then return false end
    -- (lane O8: a dungeon run, an adventure and a journey are paragraphs of their own)
    local function Solid(kind) return kind == "dungeon" or kind == "adventure" or kind == "expedition" end

    -- 5. Paragraphs: a light one joins the next (or the last joins the one before), two bad
    -- stretches side by side are one, never more than C.MAX_PARAGRAPHS, a long one splits at a turn.
    local function Join(a, b)
        for _, l in ipairs(b.lines) do a.lines[#a.lines + 1] = l end
        a.words, a.weight = a.words + b.words, a.weight + b.weight
        if Solid(b.kind) or (b.kind == "deaths" and not Solid(a.kind)) then a.kind = b.kind end
        if b.ep.night then a.ep = b.ep end
    end
    local i = 1
    while i <= #paragraphs do
        local p = paragraphs[i]
        local nxt, prev = paragraphs[i + 1], paragraphs[i - 1]
        if (p.words < C.MIN_WORDS or #p.lines <= 2) and nxt and nxt.kind ~= "dungeon" and nxt.kind ~= "expedition" and (nxt.kind ~= "adventure" or p.words + nxt.words <= C.MAX_WORDS_ADVENTURE or p.words < C.MIN_WORDS) then
            Join(p, nxt); table.remove(paragraphs, i + 1)
        elseif p.words < C.MIN_WORDS and nxt and nxt.kind == "expedition" and prev and not Solid(prev.kind) and not Solid(p.kind) and prev.words + p.words <= C.MAX_WORDS then
            -- (lane O8: a short stop before a journey is a clause of what came before it, not of the road)
            Join(prev, p); table.remove(paragraphs, i)
        elseif nxt and not Solid(nxt.kind) and not Solid(p.kind) and p.kind ~= "deaths" and (p.ep.e - p.ep.t) < 10 * 60 and p.words + nxt.words <= C.MAX_WORDS then
            -- (a stop of a few minutes is a clause of what it led to)
            Join(p, nxt); table.remove(paragraphs, i + 1)
        elseif p.words < C.MIN_WORDS and nxt and nxt.kind == "dungeon" and not Solid(p.kind) and p.words + nxt.words <= C.MAX_WORDS then
            Join(p, nxt); table.remove(paragraphs, i + 1)
        elseif not nxt and prev and (function()
                for _, l in ipairs(p.lines) do if l.cls ~= "level" and l.cls ~= "close" and l.kind ~= "level" then return false end end
                return true end)() then
            -- (lane O8 round 9: level and time are a trailing clause of the last story, never a paragraph)
            Join(prev, p); table.remove(paragraphs, i); prev.closeJoined = true
        elseif (p.words < C.MIN_WORDS or #p.lines <= 2) and not nxt and prev and not Solid(prev.kind) then
            Join(prev, p); table.remove(paragraphs, i)
        elseif p.kind == "deaths" and nxt and nxt.kind == "deaths" and p.words + nxt.words <= C.MAX_WORDS then
            Join(p, nxt); table.remove(paragraphs, i + 1)
        elseif #p.lines <= 1 and prev and not Solid(prev.kind) and not Solid(p.kind) then
            Join(prev, p); table.remove(paragraphs, i)
        else
            i = i + 1
        end
    end
    while #paragraphs > C.MAX_PARAGRAPHS do
        local best, bestAt
        for j = 1, #paragraphs - 1 do
            local a, b = paragraphs[j], paragraphs[j + 1]
            if not Solid(a.kind) and not Solid(b.kind) then
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
    -- (lane S: a transit at the end of a paragraph carries the reader into the next one, as its
    -- first sentence; the level a deed brought is a clause of the deed's sentence when it can take one)
    for pi = 1, #paragraphs - 1 do
        local p, nxt = paragraphs[pi], paragraphs[pi + 1]
        local last = p.lines[#p.lines]
        if last and #p.lines >= 2 and (last.cls == "voyage" or last.cls == "night" or last.cls == "arrive") and not inRun[last] and nxt.kind ~= "dungeon" and not last.toClose then
            table.remove(p.lines)
            p.words = p.words - Words(last.text)
            table.insert(nxt.lines, 1, last)
            nxt.words = nxt.words + Words(last.text)
        end
    end
    for _, p in ipairs(paragraphs) do
        for i = 2, #p.lines do
            local l, prev = p.lines[i], p.lines[i - 1]
            if l.cls == "level" and l.after and (prev == l.after or (prev.meta.entry and prev.meta.entry == l.after.meta.entry)) and P.levelClause and not inRun[l] and not prev.merged then
                local head, lastSentence = prev.text:match("^(.*%. )([^%.]+%.)$")
                if not head then head, lastSentence = "", prev.text end
                local num = Plain(l.text):match("[Ll]evel (%d+)")
                -- (lane O8: never on reported speech, "he allowed, and level 9 came with it")
                local speech = Any(lastSentence:lower(), {" said", " told ", " asked", " allowed", " admitted", " hoped", " wanted", " called", ", he ", ", she ", ", they "})
                if num and lastSentence and not speech and not lastSentence:find(" and ", 1, true) and lastSentence:match("%.$") and Words(lastSentence) <= 20 then
                    local clause = Pick("levelClause", P.levelClause, {level = num})
                    if clause then
                        prev.text = head .. lastSentence:gsub("%.$", "") .. ", " .. Lower(clause) .. "."
                        prev.merged, l.drop = true, true
                    end
                end
            end
        end
        local kept2 = {}
        for _, l in ipairs(p.lines) do if not l.drop then kept2[#kept2 + 1] = l end end
        p.lines = kept2
    end
    -- (lane P7: a level is told where it came only as a clause of its deed; a level sentence of
    -- its own, the teller's or the composer's, goes once into the close, unless it is a
    -- milestone (ten, twenty, ... sixty), an early level's own line with its mark, or the run's)
    do
        local last = paragraphs[#paragraphs]
        local keptText = {}
        local keptMilestone, movedTop = false, nil
        for _, p in ipairs(paragraphs) do
            for i = #p.lines, 1, -1 do
                local l = p.lines[i]
                if l.cls == "level" and not inRun[l] and not l.toClose and not l.meta.burst then
                    -- (a milestone is the line's own number in the teller's own words: "Level fifty came
                    -- that day, with ten left to climb"; a rewrite of the composer's is a bare sentence)
                    local milestone = false
                    local nums = LevelsSaid(Plain(l.text))
                    if l.n <= #out and l.meta.compose ~= "level" then
                        for n in pairs(nums) do if tonumber(n) >= 10 and tonumber(n) % 10 == 0 then milestone = true end end
                    end
                    if milestone then keptMilestone = true
                    elseif l.ep.kind ~= "dungeon" then
                        for n in pairs(nums) do if not movedTop or tonumber(n) > movedTop then movedTop = tonumber(n) end end
                        table.remove(p.lines, i); p.words = p.words - Words(l.text)
                    end
                end
            end
            for _, l in ipairs(p.lines) do keptText[#keptText + 1] = Plain(l.text) end
        end
        local said = LevelsSaid(table.concat(keptText, " "))
        -- (the milestone's own line is the chapter's one level sentence; the top is told after it only
        -- when it is the milestone itself)
        local top = (topLevel and topLevel.t and topLevel.level) or movedTop
        if top and not said[tostring(top)] and not keptMilestone and (P.closeLevel or P.closeLevels) then
            local NUM_WORDS = {"one", "two", "three", "four", "five", "six", "seven", "eight", "nine", "ten", "eleven", "twelve"}
            -- (the count only when the record has every step: never a number the record does not hold)
            local steps = (topLevel and topLevel.t) and #dayLevels or 1
            for i = 2, #dayLevels do if tonumber(dayLevels[i].level) ~= (tonumber(dayLevels[i - 1].level) or -9) + 1 then steps = 1 end end
            local level = tostring(top)
            local text
            if steps >= 2 and P.closeLevels and NUM_WORDS[steps] then
                text = Pick("closeLevels", P.closeLevels, {Count = Cap(NUM_WORDS[steps]), count = NUM_WORDS[steps], level = level})
            elseif P.closeLevel then
                text = Pick("closeLevel", P.closeLevel, {level = level})
            end
            if text then
                local l = {cls = "level", t = D.e or 0, ep = last.ep, text = text, major = false, kind = "level", toClose = true, closeRank = 3,
                    meta = {t = D.e, compose = "level"}, n = #out + #added + 900}
                last.lines[#last.lines + 1] = l
                last.words = last.words + Words(text)
            end
        end
    end
    -- (a tally never follows the day's true last beat: a told story's outcome closes the story)
    do
        local last = paragraphs[#paragraphs]
        local lastBeat
        for i = #last.lines, 1, -1 do
            local l = last.lines[i]
            if not l.toClose and l.cls ~= "close" and l.kind ~= "fold" then lastBeat = l; break end
        end
        if lastBeat and lastBeat.cls == "quest" and lastBeat.meta.entry and lastBeat.meta.entry.story and lastBeat.kind ~= "quests" then
            last.trueEnd = true
            for i = #last.lines, 1, -1 do
                local l = last.lines[i]
                if l.toClose and l.cls == "craft" then table.remove(last.lines, i); last.words = last.words - Words(l.text) end
            end
        end
    end
    -- (lane O8 round 9: the chapter's fold of its smaller work is said once, at the end of the last
    -- story paragraph, before level and time: it sums the day, it belongs to no one stay)
    for pi, p in ipairs(paragraphs) do
        for li = #p.lines, 1, -1 do
            local l = p.lines[li]
            if l.meta and l.meta.chapter and l.kind == "fold" and pi < #paragraphs then
                table.remove(p.lines, li); p.words = p.words - Words(l.text)
                local last = paragraphs[#paragraphs]
                local at = #last.lines + 1
                for j, x in ipairs(last.lines) do if (x.toClose or x.cls == "close" or x.cls == "level" or x.cls == "milestone") and j < at then at = j end end
                table.insert(last.lines, at, l); last.words = last.words + Words(l.text)
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
                -- (lane S: "was behind us" belongs to the paragraph that came up with the heart; an
                -- hour later and a continent away it is stale)
                if o.lordKilled and P.closeDungeonDone and (D.e or 0) - (ep.e or ep.t) <= 3600 then
                    phrases[#phrases + 1] = Fill(P.closeDungeonDone[1], {dungeon = Place(o.dungeon), us = epParty and "us" or "me"})
                end
            elseif o and o.kind == "deaths" and ep.mine >= 2 and o.place and Clean(o.place) ~= Clean(ep.zone or "") and not IsTown(o.place) and (D.e or 0) - (ep.e or ep.t) <= 3600 then
                local named = A.FoeNamed and A.FoeNamed(o.foe) or (A.SelfTale and A.SelfTale.CommonFoe and not A.SelfTale.CommonFoe(o.foe))
                local killedAfter = false
                for _, s in ipairs(stretches) do
                    for _, e in ipairs(s.events or {}) do if (e.k == "boss" or e.k == "kill") and e.d and Clean(e.d) == Clean(o.foe) and (e.t or 0) > o.t then killedAfter = true end end
                end
                if named and not killedAfter and P.closeFoeHeld then
                    phrases[#phrases + 1] = Fill(P.closeFoeHeld[1], {foe = Place(o.foe), place = Place(o.place)})
                end
            elseif dayPlan and (ep.kind == "field" or ep.kind == "deaths") and (D.e or 0) - (ep.e or ep.t) <= 3600 then
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
            -- (lane O8: the crossings count in the close only when the chapter told each of them, and in words)
            local toldCrossings = 0
            for _, p in ipairs(paragraphs) do
                for _, l in ipairs(p.lines) do
                    if Any(Plain(l.text):lower(), {"zeppelin", "across the sea", "over the sea", "sailed to", "took the boat", "ship carried", "took ship", "a portal took"}) then toldCrossings = toldCrossings + 1 end
                end
            end
            if toldCrossings < crossings then crossings = 0 end
            local CROSS = {[1] = "one sea crossing", [2] = "two sea crossings", [3] = "three sea crossings", [4] = "four sea crossings",
                [5] = "five sea crossings", [6] = "six sea crossings", [7] = "seven sea crossings", [8] = "eight sea crossings", [9] = "nine sea crossings"}
            local hour = tonumber(date and date("%H", D.e or 0) or 22) or 22
            local part = (hour >= 20 or hour < 5) and "night" or hour >= 17 and "evening" or hour >= 12 and "afternoon" or "day"
            local from = D.from or D.fromZone
            local fromName = from and Place(from) or nil
            local inn = A.SelfTale and A.SelfTale.InnName and from and A.SelfTale.InnName(from)
            if inn then fromName = inn end
            -- (lane S: the chapter closes where it opened: the place the night began is one the
            -- chapter told, else the first episode's zone when that was told, else no place)
            local function Told(place)
                if not place then return false end
                local name = (Clean(place):gsub("^[Tt]he ", ""))
                if keptPlain:find(name, 1, true) then return true end
                -- (lane O8: "Silverpine" for Silverpine Forest, as the teller's short form says it)
                local short = name:match("^(%u[%l']+) Forest$") or name:match("^(%u[%l']+) Glades$") or name:match("^(%u[%l']+) Vale$")
                    or name:match("^(%u[%l']+) Mountains$") or name:match("^(%u[%l']+) Foothills$") or name:match("^(%u[%l']+) Highlands$")
                return short ~= nil and keptPlain:find("%f[%a]" .. Esc(short) .. "%f[%A]") ~= nil
            end
            -- (round 18, reader T: the night began where the record's first event was, a hearthstone
            -- cast in Tirisfal before the road to Silverpine, a minute in the Undercity before Brill)
            local firstEv
            for _, sc in ipairs(ctx.day and ctx.day.scenes or {}) do
                for _, e in ipairs(sc.entries or {}) do
                    if e.t and e.z and e.k ~= "play" and (not firstEv or e.t < firstEv.t) then firstEv = e end
                end
            end
            local firstZoneRec = firstEv and firstEv.z
            -- (a start the chapter never names is not named in the close either)
            if from and not (Told(from) or (inn and keptPlain:find(Plain(inn), 1, true))) then
                local firstZone = (firstZoneRec and Told(firstZoneRec) and firstZoneRec) or (episodes[1] and Told(episodes[1].zone) and episodes[1].zone) or nil
                if firstZone then from, fromName, inn = firstZone, Place(firstZone), nil
                else from, fromName, inn = nil, nil, nil end
            elseif firstZoneRec and Told(firstZoneRec) and from and not IsTown(from) and not inn and Clean(from) ~= Clean(firstZoneRec) then
                from, fromName = firstZoneRec, Place(firstZoneRec)
            end
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
            if endName and not fromName and not same and not gapped then pool = D.sleep and P.closeSleepShort or P.closeEndShort end
            if endName and (fromName or same or gapped or pool == P.closeSleepShort or pool == P.closeEndShort) then
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
                    if j > 1 and l.cut and not inRun[l] and acc >= C.MIN_WORDS and rest.words - acc >= C.MIN_WORDS and HasStory(rest.lines, j) then at = j; break end
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
        local ceiling = ((rest.kind == "adventure" or rest.kind == "expedition") and C.MAX_WORDS_ADVENTURE) or (rest.kind == "deaths" or rest.kind == "journey") and C.MAX_WORDS_DEATHS or C.MAX_WORDS
        -- (round 9: the day's sums at the end, level, time and the fold, do not count against a road's or an adventure's ceiling)
        local function StoryWords(list)
            local n = 0
            for _, l in ipairs(list) do if not (l.toClose or l.cls == "close" or l.cls == "level" or l.kind == "fold") then n = n + Words(l.text) end end
            return n
        end
        while ((rest.kind == "expedition" or rest.kind == "adventure") and StoryWords(rest.lines) or rest.words) > ceiling and #rest.lines >= 2 do
            if C.Debug then C.Debug(("split: %d words, %d lines, ceiling %d"):format(rest.words, #rest.lines, ceiling)) end
            -- (the head: the most that fits under the ceiling and ends at a turn, a new story
            -- moment first, a grouped line or a death next; the tail is split again in its turn)
            local acc, bestAt, bestScore = 0, nil, nil
            for j = 1, #rest.lines - 1 do
                acc = acc + Words(rest.lines[j].text)
                local nxt = rest.lines[j + 1]
                -- (lane S: a level never opens a paragraph; it belongs to the deed before it)
                local turn = nxt.cls == "quest" or (nxt.cls == "death" and nxt.inPassage) or nxt.cls == "move" or nxt.cls == "voyage" or nxt.cls == "night" or nxt.cls == "who"
                local prevCls = rest.lines[j].cls
                local inside = (rest.lines[j].meta.entry and nxt.meta.entry and rest.lines[j].meta.entry == nxt.meta.entry)
                    or (prevCls == "death" and nxt.cls == "death") or (rest.lines[j].inPassage and nxt.inPassage)
                    or (inRun[rest.lines[j]] and inRun[nxt])
                    or prevCls == "arrive" or prevCls == "move" or prevCls == "open" or prevCls == "who"
                    or (rest.lines[j].ep == nxt.ep and nxt.ep.kind == "journey")
                if turn and not inside and acc >= C.MIN_WORDS and acc <= ceiling and rest.words - acc >= C.MIN_WORDS and j >= 3 and #rest.lines - j >= 3 and HasStory(rest.lines, j + 1) then
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
                        or nxt.cls == "level" or nxt.toClose or nxt.cls == "close" or (rest.lines[j].ep == nxt.ep and nxt.ep.kind == "journey")
                    if not inside and acc >= C.MIN_WORDS and acc <= ceiling and rest.words - acc >= C.MIN_WORDS and j >= 3 and #rest.lines - j >= 3 and HasStory(rest.lines, j + 1) then bestAt = j end
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
    -- (lane S: a place named in the two lines before is not named again at the head of the next:
    -- "In the Undercity, we spoke" after "We went on to the Undercity")
    for _, p in ipairs(paragraphs) do
        for i = 2, #p.lines do
            local l = p.lines[i]
            local place, rest = l.text:match("^In ({p:[^}]+}), (.*)$")
            if place and not inRun[l] then
                local before = ""
                for j = math.max(1, i - 2), i - 1 do before = before .. " " .. Plain(p.lines[j].text) end
                if before:find(Plain(place), 1, true) then l.text = Cap(rest) end
            end
        end
    end
    -- (lane S: a day played in two sittings says so where the second begins: "That evening,
    -- Dahlia joined me." an hour or more after the line before it)
    do
        local prev
        for _, p in ipairs(paragraphs) do
            for _, l in ipairs(p.lines) do
                if prev and not inRun[l] and not inRun[prev] and (l.cls == "who" or l.cls == "quest" or l.cls == "what") and not l.toClose
                    and prev.cls ~= "close" and prev.cls ~= "craft" and prev.cls ~= "level" and prev.cls ~= "milestone" and not prev.toClose
                    and l.t - prev.t >= 3600 and not l.text:find("^That ") and not l.text:find("^Later") and not l.text:find("^The %a+ ") then
                    -- (the time between the two lines that no stay covers: a sitting's gap, not a long stay)
                    local played = 0
                    for _, s in ipairs(stretches) do
                        local a, b = math.max(prev.t, s.t or 0), math.min(l.t, s.e or s.t or 0)
                        if b > a then played = played + (b - a) end
                    end
                    if (l.t - prev.t) - played >= 3600 then
                        local part, partBefore = PartOfDay(l.t), PartOfDay(prev.t)
                        local lead = part == partBefore and "Later" or ("That " .. part)
                        if l.text:match("^I ") or l.text:match("^We ") or l.text:match("^{n:") then l.text = lead .. ", " .. Lower(l.text) end
                    end
                end
                if not l.toClose and l.cls ~= "close" then prev = l end
            end
        end
    end
    -- (lane S: a feeling never ends a paragraph)
    for _, p in ipairs(paragraphs) do
        local last = p.lines[#p.lines]
        if last and last.meta.felt and last.meta.compose == "felt" and #p.lines >= 2 then table.remove(p.lines); p.words = p.words - Words(last.text) end
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
    -- (round 17, reader S rule 1: one adventure a paragraph. A paragraph that holds the work of three
    -- givers or more splits where the giver changes, nearest its middle, each half a story of its own)
    do
        local function GiverOf(l)
            local m = l.meta or {}
            local g = (m.entry and m.entry.act and m.entry.act.giver) or (m.sel and m.sel.unit and m.sel.unit.giver)
                or (m.fold and m.fold.entries and m.fold.entries[1] and m.fold.entries[1].act and m.fold.entries[1].act.giver)
            return type(g) == "string" and Clean(g) or nil
        end
        local function Split(p_)
            if p_.kind == "dungeon" or p_.kind == "expedition" or p_.kind == "adventure" or p_.words < 2 * C.MIN_WORDS + 10 then return {p_} end
            -- (a quest line with no giver on record is a story of its own)
            local function Key(l) if l.cls ~= "quest" then return nil end return GiverOf(l) or ("~" .. tostring(l.n)) end
            local givers, seenG = 0, {}
            for _, l in ipairs(p_.lines) do
                local g = Key(l)
                if g and not seenG[g] then seenG[g] = true; givers = givers + 1 end
            end
            -- (a first sight counts as a story too)
            for _, l in ipairs(p_.lines) do if l.cls == "what" and Any(Plain(l.text):lower(), FIRST) then givers = givers + 1 end end
            if givers < 4 then return {p_} end
            local acc, best, bestD, lastG = 0, nil, nil, nil
            for j, l in ipairs(p_.lines) do
                local g = Key(l)
                -- (a first sight of a place opens a story too: "We rode the lift down into the Undercity for the first time")
                local firstSight = l.cls == "what" and Any(Plain(l.text):lower(), FIRST) and lastG ~= nil
                if j > 1 and (firstSight or (g and lastG and g ~= lastG)) and acc >= C.MIN_WORDS and p_.words - acc >= C.MIN_WORDS and HasStory(p_.lines, j)
                    and not (l.meta and p_.lines[j - 1].meta and l.meta.entry and l.meta.entry == p_.lines[j - 1].meta.entry) then
                    -- (a move or lift line just before the new giver goes with the new story)
                    local at = j
                    local prev = p_.lines[j - 1]
                    if prev and (prev.cls == "move" or prev.cls == "arrive" or prev.cls == "voyage") then at = j - 1 end
                    local d = math.abs(acc - p_.words / 2)
                    if not bestD or d < bestD then best, bestD = at, d end
                end
                if g then lastG = g elseif firstSight then lastG = "~first" .. j end
                acc = acc + Words(l.text)
            end
            if not best then return {p_} end
            local a_ = {ep = p_.ep, lines = {}, words = 0, kind = p_.kind, weight = p_.weight}
            local b_ = {ep = p_.ep, lines = {}, words = 0, kind = p_.kind, weight = p_.weight}
            for j, l in ipairs(p_.lines) do
                local t_ = j < best and a_ or b_
                t_.lines[#t_.lines + 1] = l; t_.words = t_.words + Words(l.text)
            end
            local out_ = Split(a_)
            for _, x in ipairs(Split(b_)) do out_[#out_ + 1] = x end
            return out_
        end
        local split = {}
        for _, p_ in ipairs(paragraphs) do for _, x in ipairs(Split(p_)) do split[#split + 1] = x end end
        if #split <= C.MAX_PARAGRAPHS + 2 then paragraphs = split end
    end
    -- (round 14: "a newcomer named Borox" after Borox was already named is just "Borox")
    do
        local said_ = ""
        for _, p_ in ipairs(paragraphs) do
            for _, l in ipairs(p_.lines) do
                local text = l.text
                for name in Plain(text):gmatch("a newcomer named (%u[%a']+)") do
                    if said_:find("%f[%a]" .. Esc(name) .. "%f[%A]") then
                        text = text:gsub("a newcomer named ({n:" .. Esc(name) .. "})", "%1"):gsub("a newcomer named (" .. Esc(name) .. ")", "%1")
                    end
                end
                l.text = text
                said_ = said_ .. " " .. Plain(text)
            end
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
