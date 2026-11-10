local _, A = ...
-- The planned telling of your own book (DESIGN §3.0, Settings > Testing > Storyteller: Planned).
-- One editing pass over the day's finished lines, the way a writer goes over a draft:
--   * every scene stays; routine work is cut down to about one line an hour, and the line
--     that follows a scene keeps only what belongs to that scene;
--   * a day told in two sittings says so ("Sunday afternoon was short.", "That evening, ...");
--   * the hour is told where the evening turns (a death, the first work past midnight);
--   * tallies of ore and bandages become one plain sentence;
--   * a feeling is told only where the book set it up, twice a chapter at most.
-- The pass invents nothing: it drops, shortens and reorders nothing but what is listed here,
-- and every new sentence states a recorded fact. It makes no random draw (a choice between
-- two lines is by a hash of the day), so the Current telling is untouched.
local P = {}
A.SelfPlan = P

-- Words with a capital that are no person's or place's own name.
local STOP = {}
for word in ("Scarlet Scourge Forsaken Deathguard Deathguards Executor Captain Light Crusade Alliance Horde Magistrate "
    .. "Apothecary Novice Shadow Priest Father Doctor Lady Lord Dark Cult Damned Argent Dawn Keep Mills Hollow Vale "
    .. "Farmstead Lake Rest Tower Camp Village Glades Quarter Watch Graves Haunt Bridge Farm Mass Then After There"):gmatch("%S+") do
    STOP[word] = true
end
local HOURS = {"one", "two", "three", "four", "five", "six", "seven", "eight", "nine", "ten", "eleven", "twelve"}

local function Plain(text) return (tostring(text or ""):gsub("{%a:([^}]*)}", "%1")) end
local function WordCount(text) local n = 0; for _ in Plain(text):gmatch("%S+") do n = n + 1 end; return n end
local function Hash(text)
    local h = 5381
    for i = 1, #text do h = (h * 33 + text:byte(i)) % 2147483647 end
    return h
end
local function Esc(text) return (text:gsub("[%^%$%(%)%%%.%[%]%*%+%-%?]", "%%%0")) end
local function Fill(line, tokens)
    return (line:gsub("{(%a+)}", function(key) return tokens[key] end))
end
local function List(parts)
    if #parts <= 1 then return parts[1] or "" end
    if #parts == 2 then return parts[1] .. " and " .. parts[2] end
    return table.concat(parts, ", ", 1, #parts - 1) .. " and " .. parts[#parts]
end
-- "morning", "afternoon", "evening", "night" by the hour.
local function PartOfDay(t)
    local h = tonumber(date("%H", t)) or 12
    return (h >= 5 and h < 12 and "morning") or (h >= 12 and h < 18 and "afternoon") or (h >= 18 and h < 22 and "evening") or "night"
end
-- (the hour in words, lower case, for the middle of a sentence)
local function MidClock(phrase) return phrase and (phrase:gsub("^%u", string.lower)) or nil end
-- A stage of life, as the felt lines are keyed (JournalFeel.lua).
local function Stage(level)
    level = tonumber(level)
    if not level then return nil end
    return level < 20 and "fledgling" or level < 45 and "seasoned" or "known"
end
-- The own names in a piece of work: capitalised words of four letters or more that are not
-- a rank, a faction or a kind of place.
local function Names(text, skip)
    local names = {}
    for word in text:gmatch("%u[%a']+") do
        word = word:gsub("'s$", ""):gsub("'$", "")
        if #word >= 4 and not STOP[word] and not (skip and skip[word]) then names[word] = true end
    end
    return names
end
local function Specific(thread)
    return thread and not (thread:find("^horde_") or thread:find("^alliance_") or thread:find("^world_"))
end

function P.Apply(ctx)
    local out, kinds, majors, metas, stretches = ctx.out, ctx.kinds, ctx.majors, ctx.metas or {}, ctx.stretches or {}
    local W, history, index = ctx.W or {}, ctx.history, ctx.index or 0
    local PW, F, QD, Tale = W.plan, A.JournalFeel or {}, A.QuestDeeds, A.JournalTale or {}
    if not PW or not history or not out or #out == 0 or #stretches == 0 or not (QD and QD.JoinActs) then return nil end
    history.plan = history.plan or {said = {}, kind = {}, text = ""}
    local hp = history.plan
    local Cap, Place = ctx.Cap, ctx.Place
    local titleWords = ctx.titleWords or {}
    local seed = tostring(ctx.seed or "") .. ":" .. tostring(ctx.day and ctx.day.key or index)
    local function Pick(pool, key)
        if type(pool) == "string" then return pool end
        if type(pool) ~= "table" or #pool == 0 then return nil end
        return pool[Hash(seed .. ":" .. key) % #pool + 1]
    end
    local function Islands(text) return A.JournalIslands and A.JournalIslands(text) or text end
    local Clock = date and Tale.ClockPhrase or function() return nil end

    -- 0. A great figure met is told at its own time: after the hand-ins of the same outing that
    -- came before it, with the line of lore that belongs to it. (Copies: the teller's own lists
    -- stay as they were.)
    do
        local order = {}
        for n = 1, #out do order[n] = n end
        local pos, moved = 1, false
        while pos <= #order do
            local n = order[pos]
            local m = metas[n] or {}
            if m.figure and m.t then
                local span = 1
                local after = order[pos + 1]
                if after and kinds[after] == "lore" and (metas[after] or {}).e == m.e then span = 2 end
                local to = pos + span - 1
                while order[to + 1] do
                    local q = order[to + 1]
                    local mq = metas[q] or {}
                    if (kinds[q] == "questStart" or kinds[q] == "questOutcome") and mq.s == m.s and mq.t and mq.t <= m.t then to = to + 1 else break end
                end
                if to > pos + span - 1 then
                    local lines = {}
                    for _ = 1, span do lines[#lines + 1] = table.remove(order, pos) end
                    for i, idx in ipairs(lines) do table.insert(order, to - span + i, idx) end
                    moved = true
                    pos = to + 1
                else pos = pos + span end
            else pos = pos + 1 end
        end
        if moved then
            local o, k, mj, mt = {}, {}, {}, {}
            for i, idx in ipairs(order) do o[i], k[i], mj[i], mt[i] = out[idx], kinds[idx], majors[idx], metas[idx] end
            out, kinds, majors, metas = o, k, mj, mt
        end
    end

    -- The lines, each with its notes.
    local items = {}
    for n = 1, #out do
        local m = metas[n] or {}
        items[n] = {n = n, text = out[n], plain = Plain(out[n]), kind = kinds[n] or "", major = majors[n], m = m, s = m.s, t = m.t, keep = true}
    end
    for n = #items, 1, -1 do if not items[n].s then items[n].s = items[n + 1] and items[n + 1].s or 1 end end
    -- (only a day of work is planned: a quiet day keeps its own shape)
    local work = 0
    for _, it in ipairs(items) do
        if it.kind == "questStart" or it.kind == "questOutcome" or it.kind == "quests" or it.kind == "kill" or it.kind == "death" then work = work + 1 end
    end
    if work < 3 then return nil end
    -- (a dungeon has its own order, boss after boss: such a day keeps its shape too)
    for _, s in ipairs(stretches) do
        for _, e in ipairs(s.events or {}) do if e.k == "dungeon" then return nil end end
    end

    -- Sittings: the day's play with three quarters of an hour or more between two stretches.
    local sittings, sitOf = {}, {}
    for si, s in ipairs(stretches) do
        local last = sittings[#sittings]
        if not last or (s.t or 0) - last.e >= 2700 then
            last = {t = s.t or 0, e = s.e or s.t or 0, items = {}}
            sittings[#sittings + 1] = last
        end
        if (s.e or 0) > last.e then last.e = s.e end
        sitOf[si] = #sittings
    end
    for _, it in ipairs(items) do
        it.sit = sitOf[it.s] or #sittings
        local sit = sittings[it.sit]
        sit.items[#sit.items + 1] = it
    end
    local zoneWords = {}
    for _, s in ipairs(stretches) do for word in Plain(s.zone or ""):gmatch("%a+") do zoneWords[word] = true end end

    for _, it in ipairs(items) do
        local m = it.m
        if m.entry then
            it.scene, it.thread = true, m.entry.story and m.entry.story.thread
        elseif m.fold and type(m.fold.acts) == "table" and type(m.fold.entries) == "table" and #m.fold.acts == #m.fold.entries then
            it.fold = m.fold
            it.fixed = m.said ~= it.text -- (rewritten after it was said: kept whole)
        end
    end

    -- 1. A short first sitting is one sentence and what mattered in it.
    local first = sittings[1]
    if #sittings > 1 and date and first.e - first.t < 2700 and items[1].kind == "open" and not items[1].major and items[1].sit == 1 then
        local busy, mattered = false, false
        for _, it in ipairs(first.items) do
            if it.scene or it.fold or it.kind == "kill" or it.kind == "quests" or it.kind == "questStart" or it.kind == "questOutcome" then busy = true end
            if it.n > 1 and it.major and it.kind ~= "rest" and it.kind ~= "move" and it.kind ~= "open" then mattered = true end
        end
        if not busy then
            first.short = true
            for i, it in ipairs(first.items) do
                local nextIt = first.items[i + 1]
                if it.n == 1 then
                    if mattered then
                        local when = date("%A", ctx.Evening and ctx.Evening(first.t) or first.t) .. " " .. PartOfDay(first.t)
                        it.text = Fill(Pick(PW.short, "short"), {When = when})
                    end
                elseif it.m.hearth then
                    local death = nextIt and nextIt.m.simpleDeath and nextIt
                    local town
                    for _, e in ipairs((stretches[it.s] or {}).events or {}) do if e.k == "town" and e.d and not town then town = e.d end end
                    town = town or (stretches[it.s] or {}).zone
                    if death and town and death.t and it.m.hearth.t and death.t - it.m.hearth.t <= 600 and death.m.simpleDeath.foe then
                        it.text = Fill(Pick(PW.hearthDeath, "hearthDeath"), {town = Place(town), foe = death.m.simpleDeath.foe})
                        it.kind, it.major = "death", true
                        death.keep = false
                    else
                        it.keep = false
                    end
                elseif it.kind == "rest" or it.kind == "move" or it.kind == "open" or not it.major then
                    it.keep = false
                end
            end
        end
    end

    -- 2. The trades: one sentence without the count, where most of the work was done.
    local crafts, gathers = {}, {}
    for _, it in ipairs(items) do
        if it.keep and it.kind == "craft" and it.m.trade then crafts[#crafts + 1] = it end
        if it.keep and it.kind == "gather" and it.m.gather then gathers[#gathers + 1] = it end
    end
    local minedSaid = false
    if #crafts >= 2 and PW.trade then
        local byStretch, counts, bestS = {}, {}, nil
        for _, it in ipairs(crafts) do
            byStretch[it.s] = (byStretch[it.s] or 0) + (it.m.count or 0)
            counts[it.m.trade] = (counts[it.m.trade] or 0) + (it.m.count or 0)
        end
        for s, c in pairs(byStretch) do if not bestS or c > byStretch[bestS] or (c == byStretch[bestS] and s < bestS) then bestS = s end end
        local mined = false
        for _, it in ipairs(gathers) do if (it.m.gather.mining or 0) > 0 then mined = true end end
        local top, topCount
        for trade, c in pairs(counts) do
            if trade ~= "Mining" and PW.trade[trade] and (not top or c > topCount or (c == topCount and trade < top)) then top, topCount = trade, c end
        end
        local beat
        if counts.Mining and mined and top == "Blacksmithing" then beat = Pick(PW.forge, "forge"); minedSaid = true
        elseif counts.Mining and mined and not top then beat = Pick(PW.smelt, "smelt"); minedSaid = true
        elseif top then beat = Pick(PW.trade[top], "trade") end
        if beat then
            local placed = false
            for _, it in ipairs(crafts) do
                if it.s == bestS and not placed then it.text, it.beat, placed = beat, true, true else it.keep = false end
            end
        end
    end
    -- (ore that went into the forge sentence is told there; several tallies become one total)
    local loose = {}
    for _, it in ipairs(gathers) do
        local g = it.m.gather
        local onlyMining = (g.mining or 0) > 0 and not (g.herbs or g.skinning or g.fishing)
        if minedSaid and onlyMining then it.keep = false else loose[#loose + 1] = it end
    end
    if #loose >= 2 and A.JournalGatherClauses then
        local total = {}
        for _, it in ipairs(loose) do for kind, n in pairs(it.m.gather) do if type(n) == "number" then total[kind] = (total[kind] or 0) + n end end end
        local clauses = A.JournalGatherClauses(total) or {}
        if #clauses > 0 then
            for i, it in ipairs(loose) do
                if i < #loose then it.keep = false else it.text = "I " .. List(clauses) .. "." end
            end
        end
    end
    -- (the day's tally was not the last thing done: it says so, "Along the way I mined ...")
    local tally = loose[#loose]
    local along = tally and tally.keep and Pick(PW.along, "along")
    if along and (tally.text:find("^I ") or tally.text:find("^We ")) then
        tally.text = along .. " " .. (tally.text:find("^We ") and ("w" .. tally.text:sub(2)) or tally.text)
    end

    -- 3. Rest: the first fire of the day, and a stop that the next line stands on.
    local fireKept = false
    for i, it in ipairs(items) do
        if it.keep and it.kind == "rest" and not it.m.close then
            local nextIt = items[i + 1]
            local needed = nextIt and nextIt.m.e and nextIt.m.e.k == "home"
            if it.m.e and it.m.e.k == "campfire" and not fireKept then fireKept, needed = true, true end
            if not needed then it.keep = false end
        end
    end

    -- 4. Routine work. Every piece gets a score: its worth, two more when a scene of the day
    -- names the same person or place (or shares its thread), one more for a turning point.
    local scenes = {}
    for _, it in ipairs(items) do if it.scene then scenes[#scenes + 1] = it end end
    local function LinkedTo(act, scene)
        for name in pairs(act.names) do if scene.plain:find(name, 1, true) then return true end end
        return act.thread ~= nil and act.thread == scene.thread and Specific(act.thread)
    end
    for _, it in ipairs(items) do
        if it.fold and not it.fixed then
            it.acts = {}
            local whoNames = it.fold.who and Names(it.fold.who, zoneWords) or {}
            for i, entry in ipairs(it.fold.entries) do
                local text = tostring(it.fold.acts[i])
                local act = {i = i, text = text, worth = entry.worth or 0, thread = entry.story and entry.story.thread,
                    t = entry.quest and entry.quest.t, names = Names(text, zoneWords)}
                for name in pairs(whoNames) do act.names[name] = true end
                act.score = act.worth + ((entry.story and (entry.story.importance or 0) >= 5) and 1 or 0)
                for _, scene in ipairs(scenes) do if LinkedTo(act, scene) then act.score = act.score + 2; break end end
                it.acts[i] = act
            end
            it.top = 0
            for _, act in ipairs(it.acts) do if act.score > it.top then it.top = act.score end end
        end
    end
    -- (the line that follows a scene keeps what belongs to that scene, two pieces at most)
    for n, it in ipairs(items) do
        if it.acts then
            local scene
            for b = n - 1, 1, -1 do
                local prev = items[b]
                if prev.scene then scene = prev; break end
                if not (prev.kind == "rest" or prev.kind == "move" or prev.kind == "craft" or prev.kind == "gather") then break end
            end
            if scene then
                local best
                for _, act in ipairs(it.acts) do if LinkedTo(act, scene) and (not best or act.score > best.score) then best = act end end
                if best then
                    local second
                    for _, act in ipairs(it.acts) do
                        if act ~= best and LinkedTo(act, scene) and act.score >= best.score - 1 and (not second or act.score > second.score) then second = act end
                    end
                    it.extra, it.chosen = true, {[best.i] = true}
                    if second then it.chosen[second.i] = true end
                end
            end
        end
    end
    -- (the rest: about one line for each hour of the sitting, the best of its share)
    for _, sit in ipairs(sittings) do
        local folds = {}
        for _, it in ipairs(sit.items) do if it.keep and (it.acts or it.fixed) then folds[#folds + 1] = it end end
        local n = #folds
        if n > 0 then
            local groups = math.max(1, math.floor((sit.e - sit.t) / 3600 + 0.5))
            if groups > n then groups = n end
            local size, more, at = math.floor(n / groups), n % groups, 1
            for g = 1, groups do
                local count = size + (g <= more and 1 or 0)
                local hasExtra, best, bestScore = false, nil, nil
                for i = at, at + count - 1 do if folds[i].extra or folds[i].fixed then hasExtra = true end end
                for i = at, at + count - 1 do
                    local it = folds[i]
                    if it.acts and not it.extra then
                        local prev = items[it.n - 1]
                        local after = prev and (prev.chosen or prev.fixed) and true or false
                        local score = it.top - (after and 1 or 0)
                        if score >= ((hasExtra or after) and 8 or 0) and (not bestScore or score > bestScore) then best, bestScore = it, score end
                    end
                end
                if best then
                    local top
                    for _, act in ipairs(best.acts) do if not top or act.score > top.score then top = act end end
                    local second
                    for _, i in ipairs({top.i - 1, top.i + 1}) do
                        local act = best.acts[i]
                        if act and act.score >= top.score - 2 and (not second or act.score > second.score) then second = act end
                    end
                    if not second then
                        for _, act in ipairs(best.acts) do
                            if act ~= top and act.score >= top.score - 2 and (not second or act.score > second.score) then second = act end
                        end
                    end
                    best.pick, best.chosen = true, {[top.i] = true}
                    if second then best.chosen[second.i] = true end
                end
                at = at + count
            end
        end
    end
    for _, it in ipairs(items) do if it.acts and not it.chosen then it.keep = false end end

    -- 5. A great figure met: the scene tells it, the bare meeting line goes.
    local aliasesOf = Tale.FigureAliases or {}
    local function FigureWords(figure)
        local words = {figure}
        for _, alias in ipairs(aliasesOf[figure] or {}) do words[#words + 1] = alias end
        return words
    end
    local function NamesFigure(text, figure)
        for _, word in ipairs(FigureWords(figure)) do if text:find(word, 1, true) then return true end end
        return false
    end
    local figureScene, figureLine = {}, {}
    for _, it in ipairs(items) do
        if it.keep and it.m.figure then
            local figure = Plain(it.m.figure)
            local scene
            -- (the scene handed in to the figure, within three minutes of the meeting: a scene
            -- that only speaks of the figure is not the meeting)
            for _, other in ipairs(scenes) do
                if other.sit == it.sit and other.keep and not scene and NamesFigure(other.plain, figure)
                    and other.t and it.t and math.abs(other.t - it.t) <= 180 then scene = other end
            end
            if scene then
                it.keep = false
                figureScene[scene] = figure
                local lore = items[it.n + 1]
                if lore and lore.kind == "lore" and lore.m.e == it.m.e then lore.keep = false end
            else figureLine[it] = figure end
        end
    end

    -- 6. A level reached earlier in the day is told where it came.
    local levelLine
    for _, it in ipairs(items) do if it.keep and it.m.levelEarly and it.m.t then levelLine = it end end
    if levelLine and PW.level then
        local levelT = levelLine.m.t
        -- (a kept line of work in the quarter hour before it carries the level)
        local anchor, mode
        for _, it in ipairs(items) do
            if it.keep and it.chosen and not sittings[it.sit].short then
                local near, close = false, false
                for _, act in ipairs(it.acts) do
                    if it.chosen[act.i] and act.t and act.t >= levelT - 900 and act.t <= levelT + 90 then
                        close = true
                        if math.abs(act.t - levelT) <= 90 then near = true end
                    end
                end
                if close then anchor, mode = it, near and "with" or "hour" end
            end
        end
        if not anchor then
            for _, it in ipairs(items) do
                local timed = it.kind == "questStart" or it.kind == "questOutcome" or it.kind == "death"
                if it.keep and timed and it.t and it.t <= levelT + 60 and not (sittings[it.sit] or {}).short then anchor = it end
            end
            if anchor then
                -- (never between a scene and its consequence)
                -- (the level came after this line: with it inside a minute and a half, soon
                -- after inside a quarter hour; "by then" only when the next thing told is later)
                local gap = levelT - anchor.t
                local n = anchor.n
                while items[n + 1] and items[n + 1].keep and (items[n + 1].extra or (anchor.scene and items[n + 1].m.entry == anchor.m.entry)) do n = n + 1 end
                mode = (gap <= 90 and anchor.kind ~= "death" and "with") or (gap <= 900 and "soon") or "then"
                anchor = items[n]
            end
        end
        if anchor then
            levelLine.keep = false
            anchor.levelAfter, anchor.levelMode = levelLine.m.levelEarly, mode
        end
    end

    -- 7. A move that ends its sitting leads nowhere.
    for _, sit in ipairs(sittings) do
        for i = #sit.items, 1, -1 do
            local it = sit.items[i]
            if it.keep and not it.m.close then
                if it.kind == "move" and not it.major then it.keep = false else break end
            end
        end
    end
    -- (a line that begins "There" stands on the line before it)
    for n = 2, #items do
        if items[n].keep and items[n].plain:find("^There[ ,]") and not items[n - 1].keep then
            -- (a dropped stop at a named place gives its place to the line: "At the tavern, ...")
            local place = items[n - 1].kind == "rest" and items[n - 1].plain:match("^%a+ rested at (.+)%.$")
            if place and items[n].text:find("^There[ ,]") then
                items[n].text = "At " .. place .. items[n].text:sub(6)
            else
                items[n - 1].keep, items[n - 1].text = true, out[n - 1]
                items[n - 1].acts, items[n - 1].chosen, items[n - 1].beat = nil, nil, nil
            end
        end
    end

    -- 8. The hour: on a death (two a chapter at most), and on one or two pieces of work late
    -- in a sitting. Never two within the hour.
    local clocks = {}
    local function ClockFree(t, gap)
        for _, other in ipairs(clocks) do if math.abs(other - t) < gap then return false end end
        return true
    end
    local deathClocks = 0
    for _, it in ipairs(items) do
        local d = it.keep and it.kind == "death" and it.m.simpleDeath
        if d and d.foe and it.t and not sittings[it.sit].short and it.text == it.m.said and (d.sameDay or not d.again)
            and deathClocks < 2 and Clock(it.t) and ClockFree(it.t, 3600) then
            it.clock = Clock(it.t)
            clocks[#clocks + 1] = it.t
            deathClocks = deathClocks + 1
        end
    end
    local workClocks, lastWorkClock = 0, nil
    for _, it in ipairs(items) do
        if it.keep and it.pick and workClocks < 2 then
            local t
            for _, act in ipairs(it.acts) do if it.chosen[act.i] and act.t and (not t or act.t < t) then t = act.t end end
            local prev = items[it.n - 1]
            if t and t - sittings[it.sit].t >= 4500 and Clock(t) and ClockFree(t, 3600) and (not lastWorkClock or t - lastWorkClock >= 4500)
                and not (prev and prev.keep and prev.scene) then
                it.clock = Clock(t)
                clocks[#clocks + 1] = t
                workClocks, lastWorkClock = workClocks + 1, t
            end
        end
    end

    -- People named by the day's work: the full name once, the short name after.
    local persons = {}
    local function Person(name)
        name = name and Plain(name)
        if not name or not name:find(" ", 1, true) then return end
        local short
        for word in name:gmatch("%S+") do if not titleWords[word] and not short then short = word end end
        short = short or name:match("(%S+)$")
        if short ~= name then persons[name] = short end
    end
    for _, it in ipairs(items) do
        if it.fold then
            Person(it.fold.who)
            for _, entry in ipairs(it.fold.entries) do Person(entry.act and entry.act.giver) end
        elseif it.m.entry then
            local entry = it.m.entry
            Person(entry.act and entry.act.giver)
            Person(entry.story and entry.story.pov and entry.story.pov.giver)
        end
    end
    local people = {}
    for full in pairs(persons) do people[#people + 1] = full end
    table.sort(people, function(x, y) if #x ~= #y then return #x > #y end return x < y end)
    local function ShortenPeople(line, saidBefore)
        for _, full in ipairs(people) do
            local short = persons[full]
            local at = line:find(full, 1, true)
            if at then
                local pattern = Esc(full)
                if saidBefore:find(full, 1, true) then line = line:gsub(pattern, short)
                else line = line:sub(1, at + #full - 1) .. line:sub(at + #full):gsub(pattern, short) end
            end
        end
        -- (a two-word name twice in one line, whoever it is)
        for a, b in line:gmatch("(%u%l+) (%u%l+)") do
            if not STOP[a] and not STOP[b] and not titleWords[a] then
                local full = a .. " " .. b
                local at = line:find(full, 1, true)
                if at and line:find(full, at + #full, true) then
                    line = line:sub(1, at + #full - 1) .. line:sub(at + #full):gsub(Esc(full), a)
                end
            end
        end
        return line
    end

    -- Felt lines (JournalFeel.lua): the identity pool first, then the stage's own.
    local stage, race = Stage(ctx.level), ctx.race
    local feltCount = 0
    local feltKinds = {} -- (one felt line of a kind in a chapter: a second death is not felt again)
    local function Felt(kind, pools, tokens, saidText, nextText)
        if feltCount >= 2 or not stage or feltKinds[kind] then return nil end
        if hp.kind[kind] and index - hp.kind[kind] <= 3 then return nil end
        for p, pool in ipairs(pools) do
            local lines = pool and pool[stage] and pool[stage].i
            local usable = {}
            for _, line in ipairs(lines or {}) do
                local filled = Fill(line, tokens)
                local ok = not filled:find("{", 1, true) and not hp.said[line]
                -- (every name in the line was told before it; a promise needs its promise)
                if ok and line:find("promis", 1, true) and not saidText:find("promis", 1, true) then ok = false end
                if ok then
                    local plain, firstWord = Plain(filled), true
                    for word in plain:gmatch("%a[%a']*") do
                        if not firstWord and word:find("^%u") and word ~= "I" and #word >= 3 and not saidText:find(word, 1, true) then ok = false end
                        if word:find("^%u") and #word >= 5 and nextText and nextText:find("^%W*" .. Esc(word)) then ok = false end
                        firstWord = false
                    end
                end
                if ok then usable[#usable + 1] = {line = line, text = filled} end
            end
            if #usable > 0 then
                local choice = usable[Hash(seed .. ":" .. kind .. p) % #usable + 1]
                feltKinds[kind] = true
                return choice.text, choice.line
            end
        end
        return nil
    end

    -- Compose, in order.
    local seq, said = {}, ""
    local function Push(text, it, opts)
        text = Islands(text)
        local entry = {text = text, sit = it.sit, kind = it.kind, it = it}
        for key, value in pairs(opts or {}) do entry[key] = value end
        seq[#seq + 1] = entry
        said = said .. " " .. Plain(text)
        return entry
    end
    local earlier = hp.text or ""
    local deathBefore = hp.lastDeath and index - hp.lastDeath <= 1
    local whoShape = 0
    for n, it in ipairs(items) do
        if it.keep then
            local m = it.m
            local leadSit = it.sit > 1 and (not seq[#seq] or seq[#seq].sit ~= it.sit) and date
            local lead
            if leadSit then
                local part, before = PartOfDay(sittings[it.sit].t), PartOfDay(sittings[it.sit - 1].t)
                lead = part == before and "Later" or ("That " .. part)
            end
            if it.chosen then
                -- a line of work, rebuilt from the pieces kept
                local acts = {}
                for _, act in ipairs(it.acts) do if it.chosen[act.i] then acts[#acts + 1] = act.text end end
                local subject = it.fold.subject or "I"
                local mid = subject == "We" and "we" or subject
                local joined, who = QD.JoinActs(acts), it.fold.who
                local opening = it.clock or lead
                local text
                if who and not opening and whoShape % 2 == 0 then text = "For " .. who .. ", " .. mid .. " " .. joined .. "."
                elseif opening then text = opening .. ", " .. mid .. " " .. joined .. (who and (" for " .. who) or "") .. "."
                else text = Cap(subject) .. " " .. joined .. (who and (" for " .. who) or "") .. "." end
                if who then whoShape = whoShape + 1 end
                text = ShortenPeople(text, earlier .. said)
                -- (the level that came with this very work)
                if it.levelAfter and it.levelMode == "with" and PW.levelWith and WordCount(text) <= 16 and not text:find(", then ", 1, true) then
                    text = text:gsub("%.$", "") .. Fill(Pick(PW.levelWith, "levelWith"), {level = tostring(it.levelAfter)}) .. "."
                    it.levelAfter = nil
                end
                Push(text, it, {work = true, clock = it.clock ~= nil, glue = it.extra and not it.clock})
            elseif it.kind == "death" and m.simpleDeath and it.text == m.said then
                local d = m.simpleDeath
                local text = it.text
                if it.clock or d.sameDay then
                    local foe = d.foe
                    if not it.clock then foe = Cap(foe) end
                    text = (it.clock and (it.clock .. ", ") or "") .. Fill(Pick(PW.killed, "killed" .. n), {foe = foe, where = d.sub and (" in " .. d.sub) or ""})
                end
                Push(text, it, {clock = it.clock ~= nil})
                -- (a death after a death: told once the book has the first one)
                local again = deathBefore
                for b = 1, n - 1 do if items[b].kind == "death" then again = true end end
                local nextIt = items[n + 1]
                local firstDeathLine = nextIt and nextIt.kind == "" and nextIt.m.e and nextIt.m.e.k == "death"
                if again and not firstDeathLine and F.deathAgain then
                    local text2, line = Felt("deathAgain", {F.deathAgain[race or ""], F.deathAgain}, {foe = Plain(d.foe)}, earlier .. said, nil)
                    if text2 then Push(text2, it, {glue = true, felt = "deathAgain", line = line}); feltCount = feltCount + 1 end
                end
            elseif it.scene and figureScene[it] then
                -- the scene with a great figure in it: the feeling goes where the figure enters
                local figure = figureScene[it]
                local key = (Tale.FigureKeys and Tale.FigureKeys[figure]) or figure
                local short = (aliasesOf[figure] and aliasesOf[figure][1]) or figure
                local a, b = it.text:match("^(.-%.)%s+(%S.+)$")
                local two = a and not b:find("%.%s+%S") and WordCount(a) >= 6 and NamesFigure(Plain(b), figure)
                local known = NamesFigure(earlier, figure) or NamesFigure(said, figure)
                local text2, line
                if known and F.figureNamed then
                    local byFigure = F.figureNamed[key] and F.figureNamed[key][race or ""]
                    text2, line = Felt("figureNamed", {byFigure, F.figureNamed}, {figure = short}, earlier .. said .. " " .. it.plain, two and Plain(b) or nil)
                end
                if text2 and two then
                    Push(a, it, {turn = true, scene = true})
                    Push(text2, it, {glue = true, felt = "figureNamed", line = line})
                    Push(b, it, {glue = true})
                    feltCount = feltCount + 1
                else
                    Push(it.text, it, {turn = true, scene = true})
                    if text2 then Push(text2, it, {glue = true, felt = "figureNamed", line = line}); feltCount = feltCount + 1 end
                end
            else
                local text = it.text
                local opts = {}
                if m.joined and m.zone and lead and PW.joined then
                    text = Fill(Pick(PW.joined, "joined"), {When = lead, names = m.joined, zone = m.zone})
                elseif lead and (it.plain:find("^I ") or it.plain:find("^We ")) and not it.scene then
                    text = lead .. ", " .. (it.plain:find("^We ") and ("w" .. text:sub(2)) or text)
                end
                if m.close and it.t and PW.stopped then
                    local h = date and tonumber(date("%H", it.t))
                    local night = h and (h >= 22 or h < 5)
                    local clock = night and MidClock(Clock(it.t))
                    if clock and (m.close == "long" or (m.close == "late" and said:lower():find("midnight", 1, true))) then
                        text = Fill(Pick(PW.stopped, "stopped"), {clock = clock})
                    end
                end
                if m.close then opts.glue = true end
                if it.scene and it.kind == "questStart" then opts.turn, opts.scene = true, true end
                if it.scene and it.kind == "questOutcome" and items[n - 1] and items[n - 1].m.entry == m.entry then opts.glue = true end
                if it.kind == "move" or it.kind == "open" or it.kind == "town" or (m.e and m.e.k == "town") or m.joined then opts.turn = true end
                -- (a line that points back at the one before it stays with it)
                if it.plain:find("^There[ ,]") or it.plain:find(" there%.$") or it.plain:find("^One, ") or it.plain:find("^Then ") then opts.glue = true end
                if it.kind == "" and m.e and m.e.k == "death" and items[n - 1] and items[n - 1].kind == "death" then
                    opts.glue, opts.felt = true, "deathFirst"
                    feltCount = feltCount + 1
                end
                if m.e and m.e.k == "home" then opts.glue = true end
                -- (two stops in a row are one sentence)
                local last = seq[#seq]
                local prevIt = last and last.it
                if it.kind == "rest" and prevIt and prevIt.kind == "rest" and last.text == prevIt.text and prevIt.sit == it.sit then
                    local subject = it.plain:match("^(We) ") or it.plain:match("^(I) ")
                    if subject and prevIt.plain:find("^" .. subject .. " ") then
                        local joinedText = last.text:gsub("%.$", "") .. ", then " .. text:sub(#subject + 2)
                        said = said .. " " .. Plain(text)
                        last.text, last.it, text = joinedText, it, nil
                    end
                end
                if text then Push(text, it, opts) end
                if figureLine[it] and F.figureNamed then
                    local figure = figureLine[it]
                    local key = (Tale.FigureKeys and Tale.FigureKeys[figure]) or figure
                    local short = (aliasesOf[figure] and aliasesOf[figure][1]) or figure
                    local lore = items[n + 1]
                    local known = it.figureKnown or NamesFigure(earlier, figure) or NamesFigure(said:sub(1, math.max(0, #said - #it.plain)), figure)
                    if known and not it.figureKnown and lore and lore.keep and lore.kind == "lore" and lore.m.e == m.e then
                        -- (what is known of the figure first, then the feeling)
                        figureLine[lore], lore.figureKnown = figure, true
                    elseif known then
                        local byFigure = F.figureNamed[key] and F.figureNamed[key][race or ""]
                        local text2, line = Felt("figureNamed", {byFigure, F.figureNamed}, {figure = short}, earlier .. said, nil)
                        if text2 then Push(text2, it, {glue = true, felt = "figureNamed", line = line}); feltCount = feltCount + 1 end
                    end
                end
            end
            if it.levelAfter and PW.level then
                local pool = (it.levelMode == "with" and PW.levelCame) or (it.levelMode == "hour" and PW.levelHour) or (it.levelMode == "soon" and PW.levelSoon) or PW.level
                Push(Fill(Pick(pool, "level"), {level = tostring(it.levelAfter)}), it, {glue = true, level = true})
            end
        end
    end
    if #seq == 0 then return nil end
    -- (the day's tally does not follow a great figure or a feeling: it closes the movement before)
    for i = #seq, 2, -1 do
        if seq[i].it == tally and seq[i].kind == "gather" then
            local climax = false
            for b = i - 1, 2, -1 do
                local entry = seq[b]
                if entry.sit ~= seq[i].sit then break end
                if entry.felt or figureScene[entry.it] or figureLine[entry.it] then climax = true end
                if entry.turn then
                    if climax and seq[b - 1].sit == entry.sit then table.insert(seq, b, table.remove(seq, i)) end
                    break
                end
            end
            break
        end
    end
    -- (a person's full name belongs to the first mention: "Sevren" before "Magistrate Sevren" is turned round)
    for _, full in ipairs(people) do
        local short = persons[full]
        local word = "%f[%a]" .. Esc(short) .. "%f[%A]"
        local firstShort, firstFull
        for i, entry in ipairs(seq) do
            local has = entry.text:find(full, 1, true)
            if has and not firstFull then firstFull = i end
            if not has and not firstShort and entry.text:find(word) then firstShort = i end
        end
        if firstShort and firstFull and firstShort < firstFull and seq[firstShort].work and not earlier:find(full, 1, true)
            and not full:find("%%") then
            seq[firstShort].text = seq[firstShort].text:gsub(word, (full:gsub("%%", "%%%%")), 1)
            for i = firstFull, #seq do seq[i].text = seq[i].text:gsub(Esc(full), short) end
        end
    end
    -- (a feeling never ends the chapter)
    while seq[#seq] and seq[#seq].felt and seq[#seq].felt ~= "deathFirst" do seq[#seq] = nil end

    -- Paragraphs: a new one for a new sitting, for a told hour, and where the purpose turns
    -- once the paragraph has some length. A scene and what follows from it stay together.
    for _, entry in ipairs(seq) do entry.words = WordCount(entry.text) end
    local left = {}
    for i = #seq, 1, -1 do
        local nextEntry = seq[i + 1]
        left[i] = seq[i].words + ((nextEntry and nextEntry.sit == seq[i].sit) and left[i + 1] or 0)
    end
    local paragraphs, current = {}, nil
    for i, entry in ipairs(seq) do
        local start = not current or entry.sit ~= current.sit
        if not start and not entry.glue then
            if entry.clock and current.words >= 12 then start = true
            elseif entry.turn and current.words >= 45 and left[i] >= 25 then start = true
            elseif (entry.work or entry.kind == "first") and current.words >= 90 and left[i] >= 25 then start = true end
        end
        if start then
            current = {sit = entry.sit, words = 0, lines = {}}
            paragraphs[#paragraphs + 1] = current
        end
        -- (one feeling to a paragraph)
        if entry.felt and current.felt and entry.felt ~= "deathFirst" then
            entry.dropped = true
        else
            if entry.felt then current.felt = true end
            current.lines[#current.lines + 1] = entry.text
            current.words = current.words + entry.words
        end
    end
    -- (a paragraph of a line or two joins its neighbour in the same sitting)
    local merged = {}
    for i, paragraph in ipairs(paragraphs) do
        local prev = merged[#merged]
        if prev and prev.sit == paragraph.sit and (paragraph.words < 25 or prev.words < 25) and not (prev.felt and paragraph.felt) then
            for _, line in ipairs(paragraph.lines) do prev.lines[#prev.lines + 1] = line end
            prev.words, prev.felt = prev.words + paragraph.words, prev.felt or paragraph.felt
        else
            merged[#merged + 1] = paragraph
        end
    end
    local texts = {}
    for _, paragraph in ipairs(merged) do texts[#texts + 1] = table.concat(paragraph.lines, " ") end

    -- What the book now holds, for the chapters to come.
    for _, entry in ipairs(seq) do
        if entry.felt and not entry.dropped then
            hp.kind[entry.felt] = index
            if entry.line then hp.said[entry.line] = true end
        end
    end
    for _, it in ipairs(items) do if it.kind == "death" then hp.lastDeath = index end end
    return table.concat(texts, "\n\n")
end

return P
