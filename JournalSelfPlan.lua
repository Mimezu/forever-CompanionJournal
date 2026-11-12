local _, A = ...
-- The planned telling of your own book (DESIGN §3.0, Settings > Testing > Storyteller: Planned).
-- One editing pass over the day's finished lines, the way a writer goes over a draft:
--   * the day's scenes are ranked (Sel, below): the spine is told in full (the class chain,
--     a thread with weight that day, what leads to a peak), the best few errands are told
--     short and the rest left out, inside a budget of about 100 words an hour, 340 at most;
--   * a peak keeps its setup: what leads to a great figure met or a class spell taught is
--     never dropped;
--   * a day told in two sittings says so ("Sunday afternoon was short.", "That evening, ...");
--   * the hour is told where the evening turns (a death, the first work past midnight);
--   * tallies of ore and bandages become one plain sentence;
--   * a feeling is told only where the book set it up: every candidate is collected and
--     the best two or three by rank are kept;
--   * each kept line carries what it is for the style pass: peak, setup, side, close.
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

-- Selection (pass 2, 2026-11-09): what a chapter tells. The day's quest work is ranked. The
-- spine (the class's own chain, the heaviest specific thread, a scene of importance 5 or
-- more, whatever leads to a peak) is told in full; the best few of the other errands are
-- told short; the rest is left out. A chapter runs to about 100 words an hour of play, 340
-- at most. All of it lives in these helpers: P.Apply is close to Lua's limit of locals.
local Sel = {}
P.Sel = Sel -- (open to the tests)
local OWN_CAPITAL = {Scourge = "Undercity", Orc = "Orgrimmar", Troll = "Orgrimmar", Tauren = "Thunder Bluff",
    Human = "Stormwind", Dwarf = "Ironforge", Gnome = "Ironforge", NightElf = "Darnassus"}
-- The feelings, best first: a chapter keeps the best two or three.
local FELT_RANK = {rezLearned = 1, figureNamed = 2, deathFirst = 3, backDeath = 4, capitalOwn = 5, homeFirst = 6,
    foeSeenFirst = 7, deathAlone = 8, deathAgain = 9}
-- A class scene that teaches how to bring back the dead says so in its own words.
local REZ_WORDS = {"redemption", "resurrect", "ancestral spirit", "rebirth", "bring back", "back to life"}

-- The day's company, its length and its budget; the peaks a line carries by itself; the
-- deaths, kept for the chapters to come. Called before the pass decides anything.
function Sel.Start(sel)
    local items, stretches, hp, index = sel.items, sel.stretches, sel.hp, sel.index
    -- (the companion of the day: whoever was there longest)
    local seconds, mate = {}, nil
    for _, s in ipairs(stretches) do
        for _, w in ipairs(s.with or {}) do
            if w.name then
                seconds[w.name] = (seconds[w.name] or 0) + (w.seconds or 0)
                if not mate or seconds[w.name] > seconds[mate.name] then mate = w end
            end
        end
    end
    sel.mateIn = {}
    if mate then
        for si, s in ipairs(stretches) do
            for _, w in ipairs(s.with or {}) do if w.name == mate.name then sel.mateIn[si] = true end end
        end
        sel.mate = {name = mate.name, key = mate.key}
    end
    local played, current = 0, 0
    for _, s in ipairs(stretches) do played = played + math.max(0, (s.e or s.t or 0) - (s.t or 0)) end
    for _, line in ipairs(sel.out) do current = current + WordCount(line) end
    sel.hours = played / 3600
    sel.cap = math.min(340, math.max(120, math.floor(played / 36 + 0.5)), math.max(current, 40))
    -- (peaks that are a line of their own)
    local own = OWN_CAPITAL[sel.ctx.race or ""]
    for n, it in ipairs(items) do
        local m, e = it.m, it.m.e
        local nextIt = items[n + 1]
        if it.kind == "death" and m.simpleDeath then
            sel.deathCount = (sel.deathCount or 0) + 1
            if nextIt and nextIt.kind == "" and nextIt.m.e and nextIt.m.e.k == "death" then it.peak = "deathFirst"
            elseif (hp.mate or sel.mate) and not sel.mateIn[it.s] then it.peak = "death" end
        elseif it.kind == "death" and nextIt and nextIt.kind == "" and nextIt.m.e and nextIt.m.e.k == "death" then
            -- (a first death by a fall, by water or by fire is a first death all the same)
            it.peak = "deathFirst"
        elseif m.figure then it.peak = "figure"
        elseif m.capital then
            if own and tostring(m.capital):find(own, 1, true) then it.peak = "capital" end
        elseif e and e.k == "home" and it.kind == "first" then it.peak = "home"
        elseif e and e.k == "first" and e.d == "foeseen" and it.kind ~= "lore" then it.peak = "foe" end
    end
    -- (the book's deaths: where, by what, and whether the companion was there)
    hp.deaths, hp.deathDays = hp.deaths or {}, hp.deathDays or {}
    if not hp.deathDays[index] then
        hp.deathDays[index] = true
        for _, it in ipairs(items) do
            local d = it.kind == "death" and it.m.simpleDeath
            if d then
                hp.deaths[#hp.deaths + 1] = {index = index, t = it.t or 0, foe = d.foe and Plain(d.foe), sub = d.sub and Plain(d.sub),
                    with = sel.mateIn[it.s] and true or false}
            end
        end
    end
    if mate then hp.mate = hp.mate or mate.name end
    -- (the first sentence of the book, begun beside one person: "...with my wife Mira beside me.")
    local PW = sel.PW
    for _, it in ipairs(items) do
        local o = it.m.origin
        if it.kind == "origin" or o then hp.origin = hp.origin or index end
        local tail = o and o.one and o.head and o.name and o.mate and PW.originTail
        tail = type(tail) == "table" and tail[1] or tail
        if type(tail) == "string" and it.text == o.head .. ", with " .. o.name .. ", " .. tostring(o.mate) .. ", at my side." then
            it.text = o.head .. Fill(tail, {mate = (tostring(o.mate):gsub("^my ", "")), name = o.name})
            it.plain = Plain(it.text)
        end
    end
    return sel
end

-- The day's quest work as units: a scene (with the outcome line that follows it), one act of
-- a folded line, or a folded line that was rewritten and stays whole.
function Sel.Units(sel)
    local units, byEntry = {}, {}
    local function Note(u, entry)
        local story = entry and entry.story or {}
        u.entry = u.entry or entry
        u.imp = math.max(u.imp or 0, tonumber(story.importance) or 0)
        u.worth = math.max(u.worth or 0, tonumber(entry and entry.worth) or 0)
        if not u.thread and type(story.thread) == "string" then u.thread = story.thread end
        if story.class or (u.thread and u.thread:find("^class_")) then u.class = true end
        if not u.giver then u.giver = entry and entry.act and entry.act.giver end
    end
    for _, it in ipairs(sel.items) do
        if it.keep then
            local m = it.m
            if m.entry then
                local u = byEntry[m.entry]
                if not u then
                    u = {kind = "scene", it = it, items = {}, t = it.t, plain = ""}
                    Note(u, m.entry)
                    byEntry[m.entry] = u
                    units[#units + 1] = u
                end
                u.items[#u.items + 1] = it
                u.plain = u.plain == "" and it.plain or (u.plain .. " " .. it.plain)
                it.unit = u
            elseif it.acts then
                for _, act in ipairs(it.acts) do
                    local u = {kind = "act", it = it, act = act, t = act.t or it.t, plain = Plain(act.text)}
                    Note(u, it.fold.entries[act.i])
                    act.unit = u
                    units[#units + 1] = u
                end
            elseif it.fold then
                local u = {kind = "fixed", it = it, t = it.t, plain = it.plain}
                for _, entry in ipairs(it.fold.entries) do Note(u, entry) end
                it.unit = u
                units[#units + 1] = u
            end
        end
    end
    for i, u in ipairs(units) do
        u.i, u.words, u.names = i, WordCount(u.plain), Names(u.plain, sel.zoneWords)
        u.score = u.worth + u.imp
    end
    sel.units = units
    return units
end

-- (a figure by its name or one of its other names)
function Sel.NamesFigure(sel, text, figure)
    if text:find(figure, 1, true) then return true end
    for _, alias in ipairs((sel.Tale.FigureAliases or {})[figure] or {}) do if text:find(alias, 1, true) then return true end end
    return false
end
-- Round 2 (F1). Who was there at a line's own time: the party spans of the stretch, where the
-- book kept them (JournalBook.lua), else the stretch as a whole.
function Sel.There(sel, t, s, name)
    for _, w in ipairs((sel.stretches[s] or {}).with or {}) do
        if not name or w.name == name then
            if type(w.spans) ~= "table" or not t then return true end
            for _, span in ipairs(w.spans) do if t >= span[1] - 60 and t <= span[2] + 60 then return true end end
        end
    end
    return false
end
function Sel.MateAt(sel, it)
    return (sel.mate ~= nil and sel.mateIn[it.s] and Sel.There(sel, it.t, it.s, sel.mate.name)) and true or false
end
-- (text as sentences)
function Sel.Sentences(text)
    local list = {}
    for sentence in (text .. " "):gmatch("(.-[%.%!])%s+") do list[#list + 1] = sentence end
    return list
end
-- Round 2 (B1, B4). The fuller account of a folded piece of work: the telling this book
-- would give it, or the other one when only that one names the character's own class.
-- An account in which the character does nothing (told to, sent, shown) is lore.
function Sel.Account(sel, u)
    if u.kind ~= "act" or u.full ~= nil then return u.full or nil end
    u.full = false
    local pov = u.entry and u.entry.story and u.entry.story.pov
    if type(pov) ~= "table" or type(pov[1]) ~= "string" then return nil end
    local QD = sel.QD
    local own = u.promote or (QD.Variant and QD.Key and u.entry.quest and ((QD.Variant(QD.Key(u.entry.quest)) - 1) % #pov + 1)) or 1
    if type(pov[own]) ~= "string" then own = 1 end
    local class = tostring(sel.ctx.class or ""):lower()
    local function Kin(text) return class ~= "" and select(2, text:lower():gsub(class, "")) or 0 end
    if not u.promote and not u.class and Kin(pov[own]) == 0 then
        for v, line in ipairs(pov) do if type(line) == "string" and Kin(line) > 0 then own = v; break end end
    end
    u.variant, u.full = own, pov[own]
    u.kin = not u.class and Kin(u.full) > 0
    u.lore = not (u.full:find("{I}", 1, true) or u.full:find("{We}", 1, true) or u.full:find("{we}", 1, true))
    -- (the other telling, when it is the shorter one by some words and the character acts in it)
    for v, line in ipairs(pov) do
        if v ~= own and type(line) == "string" and WordCount(line) + 4 <= WordCount(u.full) and (not u.kin or Kin(line) > 0)
            and (line:find("{I}", 1, true) or line:find("{We}", 1, true) or line:find("{we}", 1, true))
            and (not u.alt or WordCount(line) < WordCount(u.alt)) then
            u.alt, u.altv = line, v
        end
    end
    return u.full
end
-- (the account's opening, up to the first sentence the character acts in and the name the
-- chapter needs from it: a deed in one or two authored sentences. Nil when that is all of it.)
function Sel.Lead(sel, u)
    local full = Sel.Account(sel, u)
    if not full then return nil end
    local list, lead = Sel.Sentences(full), ""
    -- (being sent is not yet the deed, unless the account holds no more than that)
    local passive = not (full:find("{I}", 1, true) or full:find("{We}", 1, true) or full:find("{we}", 1, true))
    for i, sentence in ipairs(list) do
        lead = lead == "" and sentence or (lead .. " " .. sentence)
        local acts = lead:find("{I}", 1, true) or lead:find("{We}", 1, true) or lead:find("{we}", 1, true)
            or (passive and (lead:find("{me}", 1, true) or lead:find("{us}", 1, true)))
        if acts and (not u.need or lead:find(u.need, 1, true)) then return i < #list and lead or nil end
    end
    return nil
end

-- Round 2 (B1 to B5). The budget. Fewer deeds, each with its reason: a piece of work is told
-- in its full account, or in the account's opening, before it is told as a bare act. A chapter
-- holds two bare acts at most, and none beside a scene of the same people or the same chain:
-- such a step is left out instead. A peak, the chapter's first scene, the first step of a chain
-- that ends in a peak and its steps of weight are always told. The step that first names a
-- person the chapter goes on to speak of is never a bare act (B3). What leads nowhere goes
-- first (B5). A piece nobody wrote an act or an account for is not told (C2).
function Sel.Budget(sel)
    local units, items, Shares = sel.units, sel.items, sel.Shares
    local fixed = 0
    for _, it in ipairs(items) do if it.keep and not it.unit and not it.acts then fixed = fixed + WordCount(it.text) end end
    -- (the composer counts its own fixed lines, and keeps a floor for the work: lane U, 2026-11-11)
    fixed = fixed + (sel.fixedExtra or 0)
    -- (what the fixed lines and a feeling on each of two peaks leave; Sel.Finish holds the cap)
    local room = sel.cap - 3 - fixed - 9 * math.min(2, sel.peaks or 0)
    if sel.roomFloor and room < sel.roomFloor then room = sel.roomFloor end
    local used, errands = 0, 0
    local function Cost(u, mode)
        if not mode then return 0 end
        if u.kind == "scene" then return (mode == "short" and u.short) and WordCount(u.short) or u.words end
        if u.kind == "act" and mode == "full" then return WordCount(Sel.Account(sel, u)) end
        if u.kind == "act" and mode == "alt" then return WordCount(u.alt) end
        if u.kind == "act" and mode == "lead" then return WordCount(Sel.Lead(sel, u)) end
        return u.words + (u.kind == "act" and (u.callback and 8 or 2) or 0)
    end
    local function Bare(u, mode)
        mode = mode or u.mode
        return (u.kind == "scene" and mode == "short") or (u.kind == "act" and mode == "act")
    end
    local function Set(u, mode)
        if Bare(u) and not u.callback then errands = errands - 1 end
        used = used - Cost(u, u.mode) + Cost(u, mode)
        u.mode = mode
        if Bare(u) and not u.callback then errands = errands + 1 end
    end
    local function Forms(u)
        if u.kind == "fixed" then return {"full"} end
        -- (a scene of weight is told whole or not at all)
        if u.kind == "scene" then return {"full", (u.short and u.imp <= 3) and "short" or nil} end
        local forms = {}
        if Sel.Account(sel, u) then forms[#forms + 1] = "full" end
        if u.alt and not u.turned then forms[#forms + 1] = "alt" end
        -- (B4: what touches the character's own class is told in full or not at all)
        if not u.kin and Sel.Lead(sel, u) then forms[#forms + 1] = "lead" end
        if not u.kin and not u.fallback then forms[#forms + 1] = "act" end
        return forms
    end
    local function Linked(u, o)
        return o ~= u and ((u.own and u.own == o.own) or Shares(u, o) or Shares(o, u))
    end
    local function InScene(u)
        for _, o in ipairs(units) do if o.mode and o.kind ~= "fixed" and not Bare(o) and Linked(u, o) then return true end end
        return false
    end
    -- (two bare acts at most where the day has scenes to tell; four on a day of plain work)
    local scenes = 0
    for _, u in ipairs(units) do if u.kind == "scene" or (u.kind == "act" and Sel.Account(sel, u)) then scenes = scenes + 1 end end
    local limit = scenes >= 3 and 2 or 4
    local function Try(u, from)
        for f, mode in ipairs(Forms(u)) do
            local ok = f >= (from or 1) and used - Cost(u, u.mode) + Cost(u, mode) <= room
            if ok and Bare(u, mode) and not u.callback and (errands >= limit or u.mid or u.nowhere or InScene(u)) then ok = false end
            if ok then Set(u, mode) return true end
        end
        return false
    end
    for _, u in ipairs(units) do
        u.turned = u.promote and true or false
        u.fallback = u.kind == "act" and not (u.entry and u.entry.act and type(u.entry.act.act) == "string" and u.entry.act.act ~= "")
    end
    -- (what is always told, in its richest words)
    local musts = {}
    for _, u in ipairs(units) do
        u.must = (u.peak or u.first or u.callback or u.head or (u.setup and (u.imp >= 5 or (u.promote and not u.second)))) and true or false
        if u.must then
            local forms = Forms(u)
            if u.callback then Set(u, "act") elseif forms[1] then Set(u, forms[1]) end
            if u.mode and not u.peak and not u.first and not u.callback and u.kind == "act" then musts[#musts + 1] = u end
        end
    end
    sel.steps = {used}
    -- (B5: it leads nowhere when nobody and nothing in it comes back that day, and neither a
    -- scene or a sure step of the chapter nor two more accounts are of its people)
    for _, u in ipairs(units) do
        if not u.must and u.kind ~= "fixed" then
            u.nowhere = true
            local kin = 0
            for _, o in ipairs(units) do
                if o ~= u and u.nowhere then
                    if Linked(u, o) and (o.must or o.kind == "scene") then u.nowhere = false end
                    if Linked(u, o) and Sel.Account(sel, o) then kin = kin + 1 end
                    for name in pairs(u.names) do if o.plain:find(name, 1, true) then u.nowhere = false end end
                end
            end
            if kin >= 2 then u.nowhere = false end
        end
    end
    table.sort(musts, function(x, y) if x.score ~= y.score then return x.score < y.score end return x.i > y.i end)
    for _, u in ipairs(musts) do
        if used > room and u.mode == "full" and not u.kin and Sel.Lead(sel, u) then Set(u, "lead") end
    end
    -- (the rest, best first: the spine before the errands, and what follows a told step of
    -- the same people before a new matter)
    local sides = 0
    -- (the step that comes of a chain's first step is told with it)
    for _, u in ipairs(units) do
        if u.head then
            local nxt
            for _, o in ipairs(units) do
                if o ~= u and not o.peak and o.thread == u.thread and (o.t or 0) >= (u.t or 0) and (not nxt or (o.t or 0) < (nxt.t or 0)) then nxt = o end
            end
            if nxt then nxt.after = true end
        end
    end
    local function Greedy()
      while true do
        local best, bestScore
        for _, u in ipairs(units) do
            if not u.mode and not u.must and not u.skip then
                local score = u.score + (u.kind == "scene" and 2 or 0) - (u.nowhere and 3 or 0) + (u.after and 3 or 0)
                    + ((u.imp >= 4 and (u.spine or u.kind == "scene") or (u.spine and u.setup)) and 4 or (u.spine and 1) or 0) + (u.own and 2 or 0)
                -- (a thread that already holds three told steps needs a further one less)
                local same = 0
                for _, o in ipairs(units) do if o ~= u and o.mode and u.own and o.own == u.own then same = same + 1 end end
                if same >= 3 and not u.after then score = score - 2 end
                -- (what is begun is finished: the next step of a told one, most of all of an
                -- errand's, when the telling names the same people; one more piece of work for
                -- the same giver counts for little. And a step the day goes on from.)
                local follow, on = 0, 0
                for _, o in ipairs(units) do
                    local named = Shares(u, o, true) or Shares(o, u, true)
                    if o.mode and named then follow = math.max(follow, (o.i > u.i and 2) or (o.side and 4) or 3)
                    elseif o.mode and o.i < u.i and o.chain == u.chain and Shares(u, o) then follow = math.max(follow, 1) end
                    if u.side and o.i > u.i and not o.nowhere and named then on = 2 end
                end
                score = score + follow + on
                u.rank = score
                if not best or score > bestScore then best, bestScore = u, score end
            end
        end
        if not best then break end
        if (best.side and sides >= 4) or not Try(best) then best.skip = true
        elseif best.side then sides = sides + 1 end
      end
    end
    -- (the names the sure steps need come first, then the rest, then the names of the rest)
    Sel.Introduce(sel, Set, Cost)
    Greedy()
    sel.steps[2] = used
    Sel.Introduce(sel, Set, Cost)
    sel.steps[3] = used
    -- (what the names cost is taken from the plainest of the rest)
    while used > room do
        local worst
        for _, u in ipairs(units) do
            if u.mode and not u.must and not u.peak and (not worst or (u.side and not worst.side)
                or (u.side == worst.side and u.score <= worst.score)) then worst = u end
        end
        if not worst then break end
        Set(worst, nil)
        worst.skip = true
    end
    -- (and what still fits in the room that made is told)
    Greedy()
    -- (a bare act beside a scene of the same people: told better, or not at all)
    for _, u in ipairs(units) do
        if u.mode and Bare(u) and not u.callback and not u.must and InScene(u) then
            local was = u.mode
            Set(u, nil)
            for f, mode in ipairs(Forms(u)) do
                if not u.mode and not Bare(u, mode) and used + Cost(u, mode) <= room then Set(u, mode) end
            end
            if not u.mode then u.dropped = was end
        end
    end
    -- (room to spare: an opening sentence gets the rest of its account, a short scene its lines)
    local rich = {}
    for _, u in ipairs(units) do rich[#rich + 1] = u end
    table.sort(rich, function(x, y) if x.score ~= y.score then return x.score > y.score end return x.i < y.i end)
    for _, u in ipairs(rich) do
        if (u.mode == "lead" or u.mode == "alt" or (u.mode == "short" and not u.callback)) and used - Cost(u, u.mode) + Cost(u, "full") <= room then Set(u, "full") end
    end
    for _, u in ipairs(units) do
        if u.kind == "act" and u.mode == "alt" then
            u.tell, u.promote = u.alt, u.altv
        elseif u.kind == "act" and (u.mode == "full" or u.mode == "lead") then
            u.tell = u.mode == "full" and u.full or Sel.Lead(sel, u)
            u.promote = u.promote or u.variant
        end
    end
    sel.steps[4], sel.steps[5] = used, room
    sel.used, sel.room, sel.errands = used + fixed, room + fixed, errands
end

-- Round 2 (B3). The step that first names a person the chapter goes on to speak of is told in
-- words that hold the name, never as a bare act, and is told at all when it is of one chain
-- with the step that uses the name.
function Sel.Introduce(sel, Set, Cost)
    local units = sel.units
    local order, names = {}, {}
    for _, u in ipairs(units) do order[#order + 1] = u end
    table.sort(order, function(x, y)
        if (x.t or 0) ~= (y.t or 0) then return (x.t or 0) < (y.t or 0) end
        return x.i < y.i
    end)
    local known = sel.hp and sel.hp.text or ""
    for name in pairs(sel.folk) do
        if (sel.count[name] or 0) <= 4 and not known:find(name, 1, true) then names[#names + 1] = name end
    end
    table.sort(names)
    local function Told(u)
        if not u.mode then return "" end
        if u.kind == "act" then return (u.mode == "full" and u.full) or (u.mode == "alt" and u.alt) or (u.mode == "lead" and Sel.Lead(sel, u)) or u.plain end
        return (u.mode == "short" and u.short) or u.plain
    end
    for _, name in ipairs(names) do
        local first, user
        for _, u in ipairs(order) do
            local fullest = (u.kind == "act" and Sel.Account(sel, u)) or u.plain
            if not first and (fullest:find(name, 1, true) or u.plain:find(name, 1, true)) then first = u end
            if first and u ~= first and not user and u.mode and Told(u):find(name, 1, true) then user = u end
        end
        local bare = first and ((first.kind == "scene" and first.mode == "short") or (first.kind == "act" and first.mode == "act"))
        local near = first and user and ((first.own and first.own == user.own) or sel.Shares(first, user) or sel.Shares(user, first))
        if first and user and not first.callback and first.kind ~= "fixed" and (bare or (not first.mode and user.must and near)
            or (first.mode == "lead" and not Sel.Lead(sel, first):find(name, 1, true))) then
            if first.kind == "scene" then
                Set(first, "full")
            elseif Sel.Account(sel, first) and first.full:find(name, 1, true) then
                first.need = name
                Set(first, (not first.kin and Sel.Lead(sel, first)) and "lead" or "full")
            end
            if first.mode == "full" or first.mode == "lead" then first.must = true end
        end
    end
end

-- (the words a piece of work is told in, for the one who did it)
function Sel.Tokens(subject)
    if subject == "We" then return {We = "We", we = "we", us = "us", our = "our", Our = "Our", I = "I", me = "me", my = "my", My = "My"} end
    return {We = "I", we = "I", us = "me", our = "my", Our = "My", I = "I", me = "me", my = "my", My = "My"}
end
-- (who did a scene: alone by its own note, else as its sentences say, else as the company was)
function Sel.Subject(sel, u)
    local e = u.entry or {}
    local pov = e.story and e.story.pov
    if (e.act and e.act.solo) or (type(pov) == "table" and pov.solo) or u.class then return "I" end
    if u.kind ~= "scene" then return u.it.fold.subject or "I" end
    local p = " " .. u.plain .. " "
    if p:find("%AWe%A") or p:find("%Awe%A") or p:find("%Aus%A") or p:find("%Aour%A") then return "We" end
    if p:find("%AI%A") or p:find("%Ame%A") or p:find("%Amy%A") then return "I" end
    return #((sel.stretches[u.it.s] or {}).with or {}) > 0 and "We" or "I"
end

-- The peaks among the work (a great figure met, the class's spell or blessing taught) and,
-- for every peak, its setup: the earlier work of the same chain, and whoever named the figure.
-- A folded piece whose own account names the figure is told in that account.
function Sel.Peaks(sel)
    local units, items = sel.units, sel.items
    local best
    for _, u in ipairs(units) do
        if u.kind == "scene" and sel.figureScene[u.it] then
            u.peak, u.figure = "figure", sel.figureScene[u.it]
        elseif u.kind == "scene" and u.class and u.imp >= 5 then
            local low = u.plain:lower()
            if (low:find("taught", 1, true) or low:find("learned", 1, true) or low:find("blessing", 1, true) or low:find("gift of", 1, true))
                and (not best or u.imp >= best.imp) then best = u end
        end
    end
    if best then best.peak = "spell" end
    -- (the figures of the day, each with the line it enters at)
    local figures = {}
    for _, u in ipairs(units) do if u.figure then figures[#figures + 1] = {figure = u.figure, n = u.it.n} end end
    for it, figure in pairs(sel.figureLine) do figures[#figures + 1] = {figure = figure, n = it.n} end
    table.sort(figures, function(x, y) return x.n < y.n end)
    -- (round 2, B1 and B2: the chain that ends in a peak tells its first step and its steps of
    -- weight; a step between them is a scene of its own or is left out, never a bare act)
    for _, u in ipairs(units) do
        if u.peak then
            local chain = u.thread and (Specific(u.thread) or u.class)
            local head
            for b = 1, u.i - 1 do
                local o = units[b]
                if chain and not o.peak and o.thread == u.thread then
                    o.mid = true
                    if o.imp >= 5 then o.setup = true end
                    if o.imp >= 3 and (not head or (o.t or 0) < (head.t or 0)) then head = o end
                end
            end
            if head then head.setup, head.head = true, true end
        end
    end
    for _, f in ipairs(figures) do
        -- (a piece of work whose fuller account names the figure: the weightiest one is told
        -- in that account, the nearest when two weigh the same)
        local best, bestV
        local named = false
        for _, o in ipairs(units) do
            if o.it.n < f.n and not o.peak and o.entry then
                if Sel.NamesFigure(sel, o.plain, f.figure) then
                    o.setup, named = true, true
                elseif o.kind == "act" and not o.promote then
                    local pov = o.entry.story and o.entry.story.pov
                    pov = type(pov) == "table" and pov or {}
                    -- (the account this book tells, when it names the figure; else the other one)
                    local QD = sel.QD
                    local own = #pov > 0 and QD.Variant and QD.Key and o.entry.quest and ((QD.Variant(QD.Key(o.entry.quest)) - 1) % #pov + 1)
                    local found
                    if own and type(pov[own]) == "string" and Sel.NamesFigure(sel, Plain(pov[own]), f.figure) then found = own end
                    for v, line in ipairs(pov) do
                        if type(line) == "string" and not found and Sel.NamesFigure(sel, Plain(line), f.figure) then found = v end
                    end
                    if found and (not best or o.imp >= best.imp) then best, bestV = o, found end
                end
            end
        end
        -- (not when a line as it stands already names the figure)
        if best and not named then best.setup, best.promote = true, bestV end
    end
    -- (peaks that are a line of their own count too)
    local peaks = 0
    for _, it in ipairs(items) do if it.keep and it.peak then peaks = peaks + 1 end end
    for _, u in ipairs(units) do if u.peak then peaks = peaks + 1 end end
    sel.peaks = peaks
end

-- (the own names an entry stands on: its text, its giver, the people its sources name)
function Sel.Link(sel, u)
    local link = {}
    local function Add(text) for name in pairs(Names(Plain(text or ""), sel.zoneWords)) do link[name] = true end end
    for name in pairs(u.names) do link[name] = true end
    for _, e in ipairs(u.kind == "fixed" and u.it.fold.entries or {u.entry}) do
        local story = e.story or {}
        Add(e.act and e.act.giver)
        Add(e.act and e.act.act)
        if type(story.pov) == "table" then Add(story.pov.giver) end
        for _, src in ipairs(type(story.source) == "table" and story.source or {}) do
            for inner in tostring(src):gmatch("%((.-)%)") do Add(inner) end
        end
    end
    u.raw = link
end

-- Furniture. A chapter with two peaks or more has no room for the rare beast, the forge, the
-- campfire, the trainer's list or a plain move. In any chapter: a fire goes when an inn follows
-- within the half hour, an arrival goes when the next sentence names the town, and the one
-- trade beat never stands inside a chain.
function Sel.Furniture(sel)
    local items = sel.items
    local busy = (sel.peaks or 0) >= 2
    local function NextKept(n) for a = n + 1, #items do if items[a].keep then return items[a] end end end
    for n, it in ipairs(items) do
        if it.keep and not it.peak and not it.m.close then
            local e = it.m.e or {}
            local after = NextKept(n)
            if busy and ((e.k == "first" and e.d == "rarebeast") or it.kind == "craft" or (it.kind == "rest" and e.k == "campfire")
                or e.k == "learn" or it.kind == "learn" or (it.kind == "move" and not it.major and not it.m.joined)) then
                -- (a stop that the home line stands on stays)
                if not (it.kind == "rest" and after and after.m.e and after.m.e.k == "home") then it.keep = false end
            elseif it.kind == "rest" and e.k == "campfire" and after and after.kind == "rest" and (after.m.e or {}).k ~= "campfire"
                and after.t and it.t and after.t - it.t <= 1800 then
                it.keep = false
            elseif (it.kind == "town" or e.k == "town") and e.d and after and (after.t or 0) - (it.t or 0) <= 600
                and after.plain:find((Plain(tostring(e.d)):gsub(" City$", "")), 1, true) and not after.plain:find("^There[ ,]") then
                it.keep = false
            elseif it.kind == "craft" and it.beat then
                local before
                for b = n - 1, 1, -1 do if items[b].keep then before = items[b]; break end end
                local ub = before and (before.unit or (before.acts and before.acts[#before.acts].unit))
                local ua = after and (after.unit or (after.acts and after.acts[1].unit))
                if ub and ua and ((ub.class and ua.class) or (ub.thread and ub.thread == ua.thread and Specific(ub.thread))) then it.keep = false end
            end
        end
    end
end

-- A1. The spine and the errands. Chains are found by thread, by the class, and by the people
-- the work names (a giver, a name in the act, a name in the sources): the catch-all threads
-- hold several chains each. Whatever a peak's setup stands on is protected as well.
function Sel.Choose(sel)
    local units, items = sel.units, sel.items
    -- (the people of the day: who gave the work. A place, a thing or a banner in two acts
    -- is no chain.)
    local folk, count = {}, {}
    local function Folk(text) for name in pairs(Names(Plain(text or ""), sel.zoneWords)) do folk[name] = true end end
    for _, u in ipairs(units) do
        Sel.Link(sel, u)
        for _, e in ipairs(u.kind == "fixed" and u.it.fold.entries or {u.entry}) do
            local story = e.story or {}
            Folk(e.act and e.act.giver)
            if type(story.pov) == "table" then Folk(story.pov.giver) end
        end
    end
    for _, u in ipairs(units) do
        u.link = {}
        for name in pairs(u.raw) do
            if folk[name] then u.link[name], count[name] = true, (count[name] or 0) + 1 end
        end
    end
    -- (a name on five pieces or more is a town's quest giver, not a chain)
    local function Shares(a, b, own)
        for name in pairs(own and a.names or a.link) do if b.link[name] and count[name] <= 4 then return true end end
        return false
    end
    local direct = {}
    for _, u in ipairs(units) do if u.setup then direct[#direct + 1] = u end end
    for _, s in ipairs(direct) do
        for b = 1, s.i - 1 do
            local o = units[b]
            if not o.peak and not o.setup and Shares(o, s, true) then o.setup, o.second = true, true end
        end
    end
    -- (chains, and the heaviest of them)
    local parent = {}
    for i = 1, #units do parent[i] = i end
    local function Find(i) while parent[i] ~= i do i = parent[i] end return i end
    for i, u in ipairs(units) do
        for b = 1, i - 1 do
            local o = units[b]
            if (u.class and o.class) or (u.thread and u.thread == o.thread and Specific(u.thread)) or Shares(u, o) then parent[Find(i)] = Find(b) end
        end
    end
    local weight, top = {}, nil
    for i, u in ipairs(units) do
        local r = Find(i)
        u.chain = r
        weight[r] = (weight[r] or 0) + u.imp * ((u.class or Specific(u.thread)) and 1.5 or 1)
    end
    for i = 1, #units do
        if units[i].chain == i and weight[i] >= 8 and (not top or weight[i] > weight[top]) then top = i end
    end
    -- (a thread of its own with weight that day is spine too, whatever the heaviest chain is)
    local own = {}
    for _, u in ipairs(units) do
        u.own = (u.class and "class") or (Specific(u.thread) and u.thread) or nil
        if u.own then own[u.own] = (own[u.own] or 0) + u.imp end
    end
    -- (the chapter that tells where the life began opens on its first scene)
    local opening = false
    for _, it in ipairs(items) do if it.keep and it.m.origin then opening = true end end
    for _, u in ipairs(units) do
        if opening and u.kind == "scene" then u.first, opening = true, false end
        -- (a bare walk to the next giver is no event: told only when it leads to a peak)
        u.move = u.kind == "act" and u.words <= 8 and u.plain:find("^went on to %u") ~= nil
        if u.move then u.score = u.score - 3 end
        u.spine = (u.peak or u.setup or (not u.move and (u.class or u.first or u.imp >= 5
            or (u.imp >= 3 and (u.chain == top or (u.own and own[u.own] >= 8)))))) and true or false
        u.side = not u.spine
        if u.kind == "scene" then
            local act = u.entry.act and u.entry.act.act
            if type(act) == "string" and act ~= "" then u.short = Sel.Subject(sel, u) .. " " .. act .. "." end
        end
    end
    Sel.Furniture(sel)

    -- The budget (round 2: Sel.Budget). The return to a place of death is found first, so
    -- that its piece of work is told, and told as the act the clause hangs on.
    sel.Shares, sel.folk, sel.count = Shares, folk, count
    Sel.Callback(sel, true)
    Sel.Budget(sel)
    if sel.pairs then Sel.Pairs(sel) end
    if sel.promised then Sel.Promised(sel) end
    Sel.Callback(sel)

    -- What was decided, on the lines.
    for _, u in ipairs(units) do
        local it = u.it
        if u.kind == "act" then
            if u.mode then
                it.chosen = it.chosen or {}
                it.chosen[u.act.i] = true
                it.pick = true
            end
        elseif not u.mode then
            for _, line in ipairs(u.items or {it}) do line.keep = false end
        else
            it.side, it.setup = u.side, u.setup
            if u.kind == "scene" then
                it.peak = it.peak or u.peak
                if u.mode == "short" then
                    for i, line in ipairs(u.items) do
                        if i == 1 then line.text, line.plain, line.short = u.short, Plain(u.short), true else line.keep = false end
                    end
                end
            end
        end
    end
    for _, it in ipairs(items) do if it.acts and not it.chosen then it.keep = false end end
end

-- A5. One callback a chapter: a piece of work told at the place of an earlier death, the same
-- day or the day before, when the character has not died there again since.
function Sel.Callback(sel, early)
    local hp = sel.hp
    local back = sel.Pick(sel.PW.backDeath, "backDeath")
    if not back then return end
    for _, u in ipairs(sel.units) do
        local ok
        if early then ok = u.kind == "act" and not u.promote and u.entry and u.entry.act and u.entry.act.act
        else ok = u.mode and not u.promote and ((u.kind == "act" and u.mode == "act") or u.mode == "short") end
        if not sel.callback and ok then
            local text = u.kind == "act" and u.act.text or u.short
            local bare = Plain(text):gsub("%.$", "")
            for d = #hp.deaths, 1, -1 do
                local death = hp.deaths[d]
                local before = (death.index == sel.index and death.t < (u.t or 0)) or death.index == sel.index - 1
                if before and death.foe and death.sub and not sel.callback and bare:sub(-#death.sub - 4) == " in " .. death.sub then
                    local again = false
                    for a = d + 1, #hp.deaths do
                        local later = hp.deaths[a]
                        if later.sub == death.sub and (later.index < sel.index or later.t < (u.t or 0)) then again = true end
                    end
                    if not again then
                        local part = PartOfDay(death.t)
                        local when = (death.index ~= sel.index and ((part == "night" or part == "evening") and "the night before" or "the day before"))
                            or (part == PartOfDay(u.t or 0) and ("earlier that " .. part) or ("that " .. part))
                        local clause = Fill(back, {foe = death.foe, when = when})
                        if u.kind == "act" then u.act.text = text .. clause else u.short = text:gsub("%.$", "") .. clause .. "." end
                        u.callback, sel.callback = true, u
                    end
                end
            end
        end
    end
end

-- A4. A line of work, as sentences. Two acts share a sentence only under one giver or in one
-- chain, when neither holds a comma and the sentence stays at 18 words or fewer. The giver is
-- named when the acts do not name him and the sentence before did not ("For Zygand we ...";
-- "... for Zygand." only after a short act). An errand is the act alone.
function Sel.Work(sel, it, opening, lastText)
    local QD, fold = sel.QD, it.fold
    local groups = {}
    -- (round 2, B6: in the order it happened, whatever order the line was folded in)
    local chosen = {}
    for _, act in ipairs(it.acts) do if it.chosen[act.i] then chosen[#chosen + 1] = act end end
    table.sort(chosen, function(x, y)
        local tx, ty = x.t or it.t or 0, y.t or it.t or 0
        if tx ~= ty then return tx < ty end
        return x.i < y.i
    end)
    for _, act in ipairs(chosen) do
        do
            local u, entry = act.unit, fold.entries[act.i]
            local pov = entry.story and entry.story.pov
            -- (F4: the class's own work is the character's alone. F1: so is work done after
            -- the company had left.)
            local solo = (entry.act and entry.act.solo) or (type(pov) == "table" and pov.solo) or u.class
            local subject = solo and "I" or (fold.subject or "I")
            if subject == "We" and #((sel.stretches[it.s] or {}).with or {}) > 0 and not Sel.There(sel, act.t, it.s) then subject = "I" end
            local piece = {text = act.text, giver = entry.act and entry.act.giver, subject = subject,
                u = u, chain = (u.class and "class") or (Specific(u.thread) and u.thread) or nil}
            local last = groups[#groups]
            local a = last and #last == 1 and last[1]
            if a and not a.u.promote and not u.promote and not a.text:find(",", 1, true) and not piece.text:find(",", 1, true)
                and a.u.side == u.side and a.subject == piece.subject
                and ((a.giver and a.giver == piece.giver) or (a.chain and a.chain == piece.chain))
                and WordCount(a.text) + WordCount(piece.text) + 3 <= 18
                and not QD.JoinActs({a.text, piece.text}):find(", then ", 1, true) then
                last[2] = piece
            else groups[#groups + 1] = {piece} end
        end
    end
    local lines = {}
    for i, group in ipairs(groups) do
        local a, b = group[1], group[2]
        local subject = a.subject
        local mid = subject == "We" and "we" or subject
        local open = i == 1 and opening or nil
        local text
        if a.u.promote then
            text = QD.Fill(a.u.tell or a.u.entry.story.pov[a.u.promote], Sel.Tokens(subject))
            -- (the hour stands before a sentence that opens on its subject, or is left out)
            if open and text:find("^We ") then text = open .. ", w" .. text:sub(2)
            elseif open and text:find("^I ") then text = open .. ", " .. text
            else open = nil end
        else
            local joined = b and QD.JoinActs({a.text, b.text}) or a.text
            local who = not a.u.side and a.giver and (not b or b.giver == a.giver) and Plain(a.giver) or nil
            if who then
                local short = (sel.persons and sel.persons[who]) or who:match("(%S+)$") or who
                if joined:find(short, 1, true) or (lastText and lastText:find(short, 1, true)) then who = nil end
            end
            local words = WordCount(joined)
            if open then text = open .. ", " .. mid .. " " .. joined .. ((who and words <= 8) and (" for " .. who) or "") .. "."
            elseif who and words <= 8 and sel.whoShape % 2 == 1 then text = subject .. " " .. joined .. " for " .. who .. "."
            elseif who and words + WordCount(who) + 2 <= 18 then text = "For " .. who .. " " .. mid .. " " .. joined .. "."
            else text, who = subject .. " " .. joined .. ".", nil end
            if who then sel.whoShape = sel.whoShape + 1 end
        end
        lastText = Plain(text)
        local score = math.min(a.u.score, b and b.u.score or a.u.score)
        lines[#lines + 1] = {text = text, opts = {work = true, side = a.u.side or nil, setup = (a.u.setup or (b and b.u.setup)) and true or nil,
            peak = (a.u.callback or (b and b.u.callback)) and "payoff" or nil, score = score, turn = a.u.promote and true or nil,
            clock = (i == 1 and it.clock ~= nil and open == it.clock) or nil, opened = open,
            unit = a.u, t = a.u.t, errand = (not a.u.promote and not a.u.callback) or nil, must = (a.u.must or (b and b.u.must)) and true or nil}}
    end
    return lines
end

-- A7. The feeling a peak may carry, when the book set it up: its kind, the pools to ask (the
-- company's, the people's, the class's, then anyone's), what fills them, and which of the
-- pools speak of what the character is. A missing pool tells nothing.
function Sel.FeltFor(sel, it)
    local F, hp, ctx = sel.F, sel.hp, sel.ctx
    local race, class = ctx.race or "", ctx.class or ""
    local peak = it.peak
    local mate = (sel.mate and sel.mate.name) or hp.mate
    if peak == "home" and F.homeFirst then
        -- (the book told where the life began)
        if hp.origin then return "homeFirst", {F.homeFirst[race], F.homeFirst}, {}, {true} end
    elseif peak == "capital" and F.capitalOwn then
        return "capitalOwn", {F.capitalOwn[race], F.capitalOwn}, {}, {true}
    elseif peak == "foe" and F.foeSeenFirst then
        local seen = tostring(it.m.e and it.m.e.n or "")
        local byRace = F.foeSeenFirst[race]
        return "foeSeenFirst", {byRace and (byRace[seen] or byRace[(seen:gsub("%s", ""))]), F.foeSeenFirst}, {}, {true}
    elseif peak == "death" and F.deathAlone then
        -- (every death before this one was beside the companion)
        local before = 0
        for _, d in ipairs(hp.deaths or {}) do
            if d.index < sel.index or (d.index == sel.index and d.t < (it.t or 0)) then
                if not d.with then return nil end
                before = before + 1
            end
        end
        if before > 0 then return "deathAlone", {F.deathAlone}, {}, {} end
    elseif peak == "spell" and F.rezLearned then
        -- (the scene says in its own words that it brings back the dead, and the character has died)
        local low, rez = it.plain:lower(), false
        for _, word in ipairs(REZ_WORDS) do if low:find(word, 1, true) then rez = true end end
        local died = false
        for _, d in ipairs(hp.deaths or {}) do if d.index < sel.index or d.t < (it.t or 0) then died = true end end
        if rez and died then
            -- (round 2, F1: she is beside the character only while she is in the party at that
            -- very time; after she has left, the line that needs no presence)
            local first = false
            if mate and Sel.MateAt(sel, it) then first = F.rezLearned.mate
            elseif mate and F.rezLearned.mate then
                first = {}
                for stage, voices in pairs(F.rezLearned.mate) do
                    first[stage] = {}
                    for voice, lines in pairs(voices) do
                        first[stage][voice] = {}
                        for _, line in ipairs(lines) do
                            if not line:find("beside", 1, true) then table.insert(first[stage][voice], line) end
                        end
                    end
                end
            end
            return "rezLearned", {first, F.rezLearned[race], F.rezLearned[class], F.rezLearned},
                {mate = mate}, {false, true, true}
        end
    elseif peak == "payoff" and F.backDeath then
        return "backDeath", {F.backDeath}, {}, {}
    end
    return nil
end

-- Round 2. Not two feelings of one sentence shape close together ("I had ...", "..., and I
-- ..."), where the pool has another line. Called with a line, it notes the line's shape.
local function Shape(text)
    text = Plain(text)
    if text:find("^I had ") or text:find("^You had ") then return "had" end
    if text:find(", and I ", 1, true) or text:find(", and you ", 1, true) then return "and" end
    local a, b = text:match("^(%S+)%s+(%S+)")
    return a and (a .. " " .. b):lower() or text
end
function Sel.Shapes(sel, usable, said)
    sel.shapes = sel.shapes or {}
    if said then sel.shapes[Shape(said)] = sel.at or 0 return end
    local fresh = {}
    for _, choice in ipairs(usable) do
        local at = sel.shapes[Shape(choice.text)]
        if not at or (sel.at or 0) - at >= 8 then fresh[#fresh + 1] = choice end
    end
    return #fresh > 0 and fresh or usable
end

-- A6. The companion's level beside the character's: the same level inside the half hour is
-- one line for both; her level inside two minutes after a death or a peak is told with it.
function Sel.MateLevels(sel)
    if sel.levels then return sel.levels end
    sel.levels = {}
    local person = sel.mate and sel.mate.key and sel.ctx.Companion and sel.ctx.Companion(sel.mate.key)
    for _, e in ipairs(type(person) == "table" and type(person.journal) == "table" and person.journal or {}) do
        if type(e) == "table" and e.k == "level" and tonumber(e.d) and tonumber(e.t) then sel.levels[#sel.levels + 1] = {level = tonumber(e.d), t = e.t} end
    end
    return sel.levels
end
function Sel.BothLevel(sel, level, t)
    local pool = sel.Pick(sel.PW.bothLevel, "bothLevel")
    if not pool or not t then return nil end
    for _, e in ipairs(Sel.MateLevels(sel)) do
        if e.level == tonumber(level) and math.abs(e.t - t) <= 1800 then
            sel.shared = e.level
            return Fill(pool, {level = tostring(level)})
        end
    end
    return nil
end
function Sel.MateLevel(sel, it)
    local pool = sel.Pick(sel.PW.mateLevel, "mateLevel")
    if not pool or not it.t or sel.mateTold or not Sel.MateAt(sel, it) then return nil end
    for _, e in ipairs(Sel.MateLevels(sel)) do
        local gap = e.t - it.t
        if gap >= 0 and gap <= 120 and e.level ~= sel.shared then
            sel.mateTold = true
            return Fill(pool, {name = sel.mate.name, level = tostring(e.level), gap = gap <= 75 and "a minute later" or "soon after"})
        end
    end
    return nil
end

-- A9. The close stands on the place or the company with the hour, never on the clock alone,
-- and there is none when the hour was told within the last four sentences.
function Sel.Close(sel, it, seq, any, yield)
    local m, PW = it.m, sel.PW
    local h = it.t and date and tonumber(date("%H", it.t))
    local clock = h and (any or h >= 22 or h < 5) and MidClock(sel.Clock(it.t))
    if m.close == "sleep" or not clock then return it.text end
    -- (round 2, C4 and C7: two hours never stand that close. A chapter that would end on its
    -- level or on a feeling takes the hour from the death or the line of work just before.)
    local near = {}
    for b = #seq, math.max(1, #seq - 3), -1 do
        local entry = seq[b]
        if entry.clock then
            local told = entry.it and entry.it.clock
            if not (yield and told and entry.text:sub(1, #told + 2) == told .. ", ") then return nil end
            near[#near + 1] = entry
        end
    end
    local s = sel.stretches[it.s] or {}
    -- (round 2, F2: "we" only when somebody was still there at the last moment)
    local we = Sel.There(sel, it.t, it.s)
    local place = s.zone and sel.ctx.Place and sel.ctx.Place(s.zone)
    local pool = place and sel.Pick(we and PW.closeWePlace or PW.closeIPlace, "close") or (we and sel.Pick(PW.closeWe, "close"))
    if not pool then return nil end
    for _, entry in ipairs(near) do
        entry.text = (entry.text:sub(#entry.it.clock + 3):gsub("^%l", string.upper))
        entry.clock = nil
    end
    local text = Fill(pool, {place = place, clock = clock})
    sel.closing = {it = it, clock = clock, we = we, t = it.t, s = it.s}
    return text
end

-- Round 2 (B6, B10, F3). The chapter as blocks: a line and what is glued to it. The close is
-- a block of its own.
local function When(entry) return entry.t or (entry.it and entry.it.t) or nil end
local function UnitOf(entry) return entry.unit or (entry.it and entry.it.unit) or nil end
function Sel.Linked(sel, u, o)
    if not u or not o or u == o or not u.link or not o.link then return false end
    return ((u.own and u.own == o.own) or sel.Shares(u, o) or sel.Shares(o, u)) and true or false
end
function Sel.Blocks(seq)
    local blocks = {}
    for _, entry in ipairs(seq) do
        if #blocks == 0 or not entry.glue or entry.close then blocks[#blocks + 1] = {} end
        local block = blocks[#blocks]
        block[#block + 1] = entry
    end
    for b, block in ipairs(blocks) do
        local head = block[1]
        block.was, block.t, block.sit = b, When(head), head.sit
        -- (the day's own level line is said at the end of the day, whenever the level came)
        if head.kind == "level" and not head.mate then block.t = nil end
        -- (a line of work folded out of several has a time of its own, and may not stand
        -- where the order of the fold put it)
        block.work = (head.work and head.unit and head.unit.kind == "act" and block.t and not head.close) and true or false
        for i = 2, #block do
            if block[i].it ~= head.it then block.work = false end
        end
        -- (so has a scene told for a piece of work, when nothing hangs on where it stands)
        block.free = (UnitOf(head) and block.t and not head.close and not head.opened and not head.clock and b > 1) and true or false
        for _, entry in ipairs(block) do
            if entry.peak or entry.felt or entry.kind == "death" or entry.close then block.free = false end
        end
    end
    return blocks
end

-- Round 2 (B6, F3). The order it happened: a line of work stands at its own time among the
-- lines of its sitting. The one swap allowed after that: a step moves down to stand with the
-- next step of its chain when no more than ten minutes of other things lie between them, and
-- none of those is a death, a told hour, a move or another sitting. An hour that a line of
-- work opened on goes to the line that now stands first.
function Sel.Order(sel, seq)
    local blocks = Sel.Blocks(seq)
    local moved = true
    while moved do
        moved = false
        for b = 1, #blocks - 1 do
            local x, y = blocks[b], blocks[b + 1]
            local loose = x.work or y.work or ((x.free or y.free) and not x[1].opened and not y[1].opened and x.was > 1 and y.was > 1)
            if x.t and y.t and x.t > y.t and x.sit == y.sit and loose and not x[1].close and not y[1].close then
                blocks[b], blocks[b + 1] = y, x
                moved = true
            end
        end
    end
    for b = 2, #blocks do
        local x = blocks[b]
        local head = x[1]
        if x.work and head.opened then
            local first = b
            while first > 1 and blocks[first - 1].work and blocks[first - 1].was > x.was and blocks[first - 1].sit == x.sit do first = first - 1 end
            local to = first < b and blocks[first][1]
            local prefix = head.opened .. ", "
            if to and not to.opened and head.text:sub(1, #prefix) == prefix and (to.text:find("^We ") or to.text:find("^I ")) then
                head.text = (head.text:sub(#prefix + 1):gsub("^%l", string.upper))
                to.text = prefix .. (to.text:find("^We ") and ("w" .. to.text:sub(2)) or to.text)
                to.opened, to.clock, head.opened, head.clock = head.opened, head.clock, nil, nil
            end
        end
    end
    for b = #blocks - 2, 2, -1 do
        local x = blocks[b]
        local head = x[1]
        local u = UnitOf(head)
        local free = u and x.t and blocks[b - 1].sit == x.sit and not head.opened and not head.clock and not (head.it and head.it.open)
        for _, entry in ipairs(x) do if entry.peak or entry.felt or entry.kind == "death" then free = false end end
        local to
        if free then
            for c = b + 1, #blocks do
                local y = blocks[c]
                if y.sit ~= x.sit or y[1].close or not y.t or y.t - x.t > 600 then break end
                if Sel.Linked(sel, u, UnitOf(y[1])) then
                    if c > b + 1 then to = c end
                    break
                end
                local bar = y[1].clock or y[1].opened or y[1].kind == "move"
                for _, entry in ipairs(y) do if entry.kind == "death" or entry.clock then bar = true end end
                if bar then break end
            end
        end
        if to then table.insert(blocks, to - 1, table.remove(blocks, b)) end
    end
    for i = #seq, 1, -1 do seq[i] = nil end
    for _, block in ipairs(blocks) do
        for _, entry in ipairs(block) do seq[#seq + 1] = entry end
    end
end

-- Round 2 (B10). For the paragraphs: lines that stand side by side and belong together (one
-- piece of work, or two that share a thread, a giver or their people) carry the same
-- `chain`, and what is glued to such a line carries it too. The style pass never breaks a
-- paragraph between two lines of one chain. A level line of the character carries none.
function Sel.Chains(sel, seq)
    local key, last, chain, at = 0, nil, nil, nil
    for _, entry in ipairs(seq) do
        local u = UnitOf(entry)
        if entry.close then
            entry.chain = nil
        elseif Sel.OwnLevel(entry) then
            entry.chain = nil
        elseif u then
            -- (one piece of work, or two of one chain told within ten minutes of each other)
            local near = last and at and When(entry) and math.abs(When(entry) - at) <= 600
            if not (last and (u == last or (near and Sel.Linked(sel, u, last)))) then key = key + 1 end
            last, chain, at = u, "c" .. key, When(entry) or at
            entry.chain = chain
        elseif entry.glue and chain then
            entry.chain = chain
        else
            entry.chain, last, chain = nil, nil, nil
        end
    end
end

-- Round 2 (B7, C4). The level of the character. The last level of the day goes into the
-- close when the chapter has one with its hour ("By the time we stopped, a little after one,
-- I was level 14."). Any other level line stands at a plain seam: not in or right after a
-- block that holds a peak, a death or a feeling, not right before a peak, and never between
-- two lines of one scene or one chain. It looks for such a seam further on, then up to ten
-- minutes back, and is left out when the chapter has none.
function Sel.OwnLevel(entry)
    if entry.close or entry.mate then return false end
    if entry.level then return true end
    return (entry.kind == "level" and entry.it ~= nil and not entry.it.major) and true or false
end
function Sel.LevelNumber(entry)
    return entry.levelN or tonumber(Plain(entry.text):match(".*%f[%d](%d+)"))
end
function Sel.Levels(sel, seq)
    local PW = sel.PW
    local last, closing = seq[#seq], sel.closing
    if last and last.close and closing and closing.it == last.it and not last.levelIn then
        local at, top
        for i, entry in ipairs(seq) do
            local n = Sel.OwnLevel(entry) and Sel.LevelNumber(entry)
            if n and (not top or n >= top) then at, top = i, n end
        end
        if at then
            local there = sel.mate and Sel.There(sel, closing.t, closing.s, sel.mate.name)
            local pool = (seq[at].both and there and PW.closeLevelBoth) or (closing.we and PW.closeLevelWe) or PW.closeLevelI
            local line = pool and sel.Pick(pool, "closeLevel")
            closing.pool, closing.level = pool, top
            if line then
                last.text, last.levelIn = Fill(line, {clock = closing.clock, level = tostring(top)}), top
                table.remove(seq, at)
            end
        end
    end
    local function PlainBlock(i)
        local b = i
        while b > 1 and seq[b].glue and not seq[b].close do b = b - 1 end
        for j = b, i do
            local entry = seq[j]
            if entry.peak or entry.felt or entry.kind == "death" or entry.level or Sel.OwnLevel(entry) then return false end
        end
        return true
    end
    local function Seam(k)
        local prev, nextEntry = seq[k - 1], seq[k]
        if not prev or prev.close or not When(prev) or not PlainBlock(k - 1) then return false end
        if nextEntry then
            if nextEntry.glue and not nextEntry.close then return false end
            if nextEntry.peak and nextEntry.peak ~= "payoff" then return false end
            if prev.chain and prev.chain == nextEntry.chain then return false end
            if prev.it and prev.it == nextEntry.it and not nextEntry.close then return false end
        end
        return true
    end
    local own = {}
    for _, entry in ipairs(seq) do if Sel.OwnLevel(entry) then own[#own + 1] = entry end end
    for _, entry in ipairs(own) do
        local i
        for b, other in ipairs(seq) do if other == entry then i = b end end
        table.remove(seq, i)
        local n = Sel.LevelNumber(entry)
        local plain = n and not entry.both and PW.level and Fill(sel.Pick(PW.level, "level"), {level = tostring(n)})
        local at = Seam(i) and i or nil
        if at then
            -- (a level line that says how it felt is a feeling: never the chapter's last word)
            local tail = Plain(entry.text):find("level%s+%d+[, ]")
            if tail and plain and at > #seq then entry.text = plain end
        else
            for k = i + 1, #seq + 1 do
                if Seam(k) then at = k break end
            end
            if not at then
                for k = i - 1, 2, -1 do
                    local t = When(seq[k])
                    local came = entry.levelT or When(entry)
                    if seq[k].sit ~= entry.sit or (came and t and t < came - 600) then break end
                    if Seam(k) then at = k break end
                end
            end
            if at and plain then entry.text = plain end
            -- (nothing else can end the chapter: it stays where it was)
            if not at and i > #seq and seq[#seq] and seq[#seq].felt and seq[#seq].felt ~= "deathFirst" then at = i end
        end
        if at then
            entry.sit, entry.glue, entry.chain = seq[at - 1] and seq[at - 1].sit or entry.sit, true, nil
            table.insert(seq, at, entry)
        end
    end
end

-- Round 2 (B9). In a chapter the title of a person, or the full name, stands on the first
-- mention: "Zygand" before "Executor Zygand" is turned round, and a title the chapter gives
-- again later is taken off. Words are only moved or removed, never added.
function Sel.Titles(sel, seq)
    local persons, people = sel.persons or {}, {}
    for full in pairs(persons) do people[#people + 1] = full end
    table.sort(people, function(x, y) if #x ~= #y then return #x > #y end return x < y end)
    for _, full in ipairs(people) do
        local short = persons[full]
        local word = "%f[%a]" .. Esc(short) .. "%f[%A]"
        local firstShort, firstFull
        for i, entry in ipairs(seq) do
            local has = entry.text:find(full, 1, true)
            if has and not firstFull then firstFull = i end
            if not has and not firstShort and entry.text:find(word) then firstShort = i end
        end
        if firstFull then
            local titled = full:sub(1, #short) ~= short
            local put = full:gsub("%%", "%%%%")
            if firstShort and firstShort < firstFull then
                seq[firstShort].text = seq[firstShort].text:gsub(word, put, 1)
                for i = firstFull, #seq do seq[i].text = seq[i].text:gsub(Esc(full), short) end
            elseif titled then
                for i = firstFull + 1, #seq do seq[i].text = seq[i].text:gsub(Esc(full), short) end
            end
        end
    end
end

-- Round 2 (C6). An authored line that ends on what the character made of it is the feeling:
-- no line from a pool of feelings stands after it. The test: the last clause of the last
-- sentence is the character's own ("..., and I ...", "..., but I ...", or the sentence opens
-- on "I") and holds a denial or a word of the heart ("no luckier", "could not", "glad").
local JUDGING = {"no", "not", "never", "nor", "hardly", "glad", "sorry", "proud", "ashamed", "afraid"}
function Sel.Judged(text)
    local list = Sel.Sentences(Plain(text))
    local last = (list[#list] or ""):lower():gsub("[%.!]+$", "")
    local clause
    for _, who in ipairs({"i", "you"}) do
        for _, joint in ipairs({", and ", ", but "}) do
            local from = 1
            while true do
                local a, b = last:find(joint .. who .. " ", from, true)
                if not a then break end
                clause, from = last:sub(b), b
            end
        end
        if not clause and last:sub(1, #who + 1) == who .. " " then clause = last:sub(#who + 1) end
        if clause then break end
    end
    if not clause then return false end
    clause = clause .. " "
    for _, word in ipairs(JUDGING) do
        if clause:find(" " .. word .. " ", 1, true) then return true end
    end
    return false
end

-- Round 2 (C2). A piece of work nobody wrote a line for is not told as work: the bare
-- "saw <title> through" goes. What was glued to it stands on its own.
function Sel.Untold(sel, seq)
    for i = #seq, 1, -1 do
        local entry = seq[i]
        local before = entry.text:match("^(.-)[IWw]e? saw {q:[^}]*} through%.$")
        if before and not entry.peak and not entry.close and not before:find(" and ", 1, true) then
            table.remove(seq, i)
            while seq[i] and seq[i].felt and seq[i].glue do table.remove(seq, i) end
            -- (a note on the same piece of work; a line that points further back stays glued)
            local after = seq[i]
            local same = after and after.it and entry.it and (after.it == entry.it or after.it.kind == "lore"
                or (after.it.m and entry.it.m and after.it.m.entry ~= nil and after.it.m.entry == entry.it.m.entry))
            if after and after.glue and not after.close and not entry.glue and same then after.glue = nil end
        end
    end
end

-- Round 2 (C3). "My hearthstone took me back there" stands right after the line that names
-- the place, whatever was told in between.
function Sel.Home(sel, seq)
    for i = 2, #seq do
        local entry = seq[i]
        local e = entry.it and entry.it.m and entry.it.m.e
        local place = e and e.k == "home" and e.d and Plain(tostring(e.d))
        if place and not entry.felt and not entry.close and Plain(entry.text):find("%f[%a]there%f[%A]")
            and not Plain(entry.text):find(place, 1, true) then
            local at
            for b = i - 1, 1, -1 do
                if seq[b].sit ~= entry.sit then break end
                if Plain(seq[b].text):find(place, 1, true) then at = b break end
            end
            if at and at < i - 1 then
                local run = {table.remove(seq, i)}
                while seq[i] and seq[i].glue and seq[i].it == entry.it and not seq[i].close do run[#run + 1] = table.remove(seq, i) end
                -- (what was glued to the home line and stays behind stands with the line before it)
                for k, moved in ipairs(run) do
                    moved.glue = true
                    table.insert(seq, at + k, moved)
                end
            end
        end
    end
end

-- Round 2 (C1). A line that names a foe who has a name stands after that foe's kill of the
-- character, never before it: told before, it would say the foe was dead already.
function Sel.Foes(sel, seq)
    local blocks = Sel.Blocks(seq)
    local turns, moved = 0, true
    while moved and turns < 20 do
        moved, turns = false, turns + 1
        for d = 2, #blocks do
            local death = blocks[d][1]
            local dm = death.kind == "death" and not death.felt and death.it and death.it.m and death.it.m.simpleDeath
            local foe = dm and dm.foe and Plain(dm.foe)
            if foe and foe:find("^%u") and not moved then
                local word = "%f[%a]" .. Esc(foe) .. "%f[%A]"
                for b = d - 1, 1, -1 do
                    local block = blocks[b]
                    local head = block[1]
                    if block.sit ~= blocks[d].sit then break end
                    local names = false
                    for _, entry in ipairs(block) do
                        if Plain(entry.text):find(word) then names = true end
                        if entry.peak or entry.kind == "death" or entry.clock or entry.close then names = false break end
                    end
                    if names and b > 1 and not head.opened and UnitOf(head) then
                        table.insert(blocks, d, table.remove(blocks, b))
                        moved = true
                        break
                    end
                end
            end
        end
    end
    for i = #seq, 1, -1 do seq[i] = nil end
    for _, block in ipairs(blocks) do
        for _, entry in ipairs(block) do seq[#seq + 1] = entry end
    end
end

-- Round 2 (C5). One fact told twice by two lines side by side, one of them a note on the
-- place or a first: when three or more words of weight are shared and they are half or more
-- of the shorter line's, one line goes. The plain errand goes before the other; otherwise
-- the line that says less.
local SMALL = {the = true, ["and"] = true, had = true, was = true, were = true, its = true, his = true, her = true,
    ["for"] = true, from = true, with = true, that = true, this = true, into = true, out = true, all = true,
    ["not"] = true, but = true, who = true, they = true, them = true, there = true, ["then"] = true, their = true,
    our = true, you = true, your = true, has = true, have = true, been = true, over = true, under = true}
local function Weighty(text)
    local set, n = {}, 0
    for word in Plain(text):lower():gmatch("[%a']+") do
        if #word >= 3 and not SMALL[word] and not set[word] then set[word], n = true, n + 1 end
    end
    return set, n
end
function Sel.Doubles(sel, seq)
    local function Note(entry)
        local kind = entry.it and entry.it.kind
        return kind == "lore" or kind == "first"
    end
    local function Held(entry) return entry.peak or entry.must or entry.setup or entry.felt or entry.close or entry.level end
    for i = #seq, 2, -1 do
        local a, b = seq[i - 1], seq[i]
        if a and b and (Note(a) or Note(b)) and not a.felt and not b.felt and not a.close and not b.close and a.sit == b.sit then
            local wa, na = Weighty(a.text)
            local wb, nb = Weighty(b.text)
            local shared = 0
            for word in pairs(wa) do if wb[word] then shared = shared + 1 end end
            if shared >= 3 and shared * 2 >= math.min(na, nb) then
                local drop
                if a.side and not b.side and not Held(a) then drop = i - 1
                elseif b.side and not a.side and not Held(b) then drop = i
                elseif na < nb and not Held(a) then drop = i - 1
                elseif not Held(b) then drop = i
                elseif not Held(a) then drop = i - 1 end
                if drop then
                    local gone = table.remove(seq, drop)
                    if seq[drop] and seq[drop].glue and not seq[drop].close and not gone.glue and drop == 1 then seq[drop].glue = nil end
                end
            end
        end
    end
end

-- Round 2 (C7). A death gets the hour only when no hour was told in the eighty words before
-- it (about two paragraphs). A death with nothing said on it is no scene of its own: it
-- joins the paragraph it falls in.
function Sel.Deaths(sel, seq)
    for i, entry in ipairs(seq) do
        if entry.kind == "death" and not entry.felt and not entry.close and not entry.level and not entry.mate then
            local clock = entry.clock and entry.it and entry.it.clock
            if clock and entry.text:sub(1, #clock + 2) == clock .. ", " then
                local words, told = 0, false
                for b = i - 1, 1, -1 do
                    if seq[b].clock then told = true break end
                    words = words + WordCount(seq[b].text)
                    if words > 80 then break end
                end
                if told then
                    entry.text = (entry.text:sub(#clock + 3):gsub("^%l", string.upper))
                    entry.clock = nil
                end
            end
            local nextEntry = seq[i + 1]
            local alone = not (nextEntry and nextEntry.glue and not nextEntry.close)
            if alone and entry.peak == "death" then
                entry.peak = nil
                if not entry.clock and i > 1 and seq[i - 1].sit == entry.sit then entry.glue = true end
            end
        end
    end
end

-- Round 2 (B5). A bare errand never stands straight after a line where somebody reacts: it
-- is left out.
function Sel.AfterFelt(sel, seq)
    for i = #seq, 2, -1 do
        local entry = seq[i]
        if entry.errand and not entry.must and not entry.peak and not entry.setup and seq[i - 1].felt then
            table.remove(seq, i)
        end
    end
end

-- The last look at the chapter before it is set in paragraphs: the best two or three
-- feelings stay (A7), the level never stands before a peak (A3), nothing is told twice, the
-- companion is named once at the opening (A6), and the chapter keeps to its budget (A1).
function Sel.Finish(sel, seq)
    local function Remove(test)
        for i = #seq, 1, -1 do if test(seq[i], i) then table.remove(seq, i) end end
    end
    -- (feelings: the callback takes one of the places)
    -- (C6: the line before it has said it already)
    for i = 2, #seq do
        local entry = seq[i]
        if entry.felt and entry.felt ~= "deathFirst" and entry.glue and not seq[i - 1].felt and Sel.Judged(seq[i - 1].text) then entry.cut = true end
    end
    local felt = {}
    for _, entry in ipairs(seq) do if entry.felt and not entry.cut then felt[#felt + 1] = entry end end
    table.sort(felt, function(x, y) return (FELT_RANK[x.felt] or 10) < (FELT_RANK[y.felt] or 10) end)
    local room = sel.cap >= 280 and 3 or 2
    local back = false
    for _, entry in ipairs(seq) do if entry.peak == "payoff" then back = true end end
    local kept = 0
    for _, entry in ipairs(felt) do
        if back and (FELT_RANK[entry.felt] or 10) > FELT_RANK.backDeath then kept, back = kept + 1, false end
        if kept < room or entry.felt == "deathFirst" then kept = kept + 1 else entry.cut = true end
    end
    Remove(function(entry) return entry.cut end)
    -- (round 2: what is not told, the order it happened, and which lines belong together)
    Sel.Untold(sel, seq)
    Sel.Home(sel, seq)
    Sel.Order(sel, seq)
    Sel.Foes(sel, seq)
    Sel.Doubles(sel, seq)
    Sel.AfterFelt(sel, seq)
    Sel.Chains(sel, seq)
    -- (a feeling never ends the chapter, and neither does the level: where the day has no
    -- close of its own, the place and the hour the last sitting ended at close it)
    local last, si = seq[#seq], #sel.stretches
    local s = sel.stretches[si]
    local lone = last and ((Sel.OwnLevel(last) and Sel.LevelNumber(last)) or (last.kind == "level" and not last.mate and not last.close)) and true or nil
    -- (a chapter that ends on a feeling and has its level still to tell: the close takes it)
    if last and last.felt and not lone then
        for _, entry in ipairs(seq) do if Sel.OwnLevel(entry) and Sel.LevelNumber(entry) then lone = true end end
    end
    if last and ((last.felt and last.felt ~= "deathFirst") or lone) and last.it and last.it.s == si and s and s.e then
        local it = {m = {close = "late"}, t = s.e, s = si, sit = last.sit, n = (last.it.n or 0) + 1, kind = "", plain = ""}
        local text = Sel.Close(sel, it, seq, lone, true)
        if text then seq[#seq + 1] = {text = text, sit = last.sit, kind = "", it = it, close = true, glue = true} end
    end
    -- (the level: into the close, or at a plain seam)
    Sel.Levels(sel, seq)
    Sel.Deaths(sel, seq)
    -- (a told hour opens a paragraph: one line of work right before a peak would stand alone
    -- there, so it gives up its hour and stays with what came before)
    for i, entry in ipairs(seq) do
        local nextEntry, clock = seq[i + 1], entry.clock and entry.work and entry.it and entry.it.clock
        if clock and i > 1 and nextEntry and nextEntry.peak and nextEntry.peak ~= "payoff" and not nextEntry.glue
            and entry.text:sub(1, #clock + 2) == clock .. ", " then
            entry.text = (entry.text:sub(#clock + 3):gsub("^%l", string.upper))
            entry.clock = nil
        end
    end
    -- (nothing twice)
    Remove(function(entry, i)
        for b = 1, i - 1 do if seq[b].text == entry.text and not entry.peak then return true end end
        return false
    end)
    -- (her name, once, where the chapter first says "we")
    local name = sel.mate and sel.mate.name
    if name then
        for i = 1, math.min(#seq, 6) do
            local entry = seq[i]
            if Plain(entry.text):find(name, 1, true) then break end
            if entry.text:find("^We ") and entry.it and sel.mateIn[entry.it.s] and (not When(entry) or Sel.There(sel, When(entry), entry.it.s, name)) then
                entry.text = name .. " and I " .. entry.text:sub(4)
                break
            end
        end
    end
    -- (the budget: the plainest errands go until the chapter fits)
    local function Words() local n = 0; for _, entry in ipairs(seq) do n = n + WordCount(entry.text) end return n end
    -- (the style pass may add a word or two where it opens a sentence)
    local limit = sel.cap - 3
    local total = Words()
    -- (round 2: first the piece of work the budget ranked lowest, never one that must be told)
    while total > limit do
        local worst, low
        for i, entry in ipairs(seq) do
            local u = entry.unit
            local rank = u and not entry.must and not entry.peak and not u.must and (u.rank or u.score) or nil
            if rank and (not low or rank < low) then worst, low = i, rank end
        end
        if not worst then break end
        table.remove(seq, worst)
        total = Words()
    end
    while total > limit do
        local worst
        for i, entry in ipairs(seq) do
            if entry.side and not entry.must and not entry.peak and not entry.setup and (not worst or (entry.score or 0) <= (seq[worst].score or 0)) then worst = i end
        end
        if not worst then break end
        table.remove(seq, worst)
        total = Words()
    end
    -- (still too long: the plainest work that is no peak and no setup)
    while total > limit do
        local worst
        for i, entry in ipairs(seq) do
            if entry.work and not entry.must and not entry.peak and not entry.setup and (not worst or (entry.score or 0) <= (seq[worst].score or 0)) then worst = i end
        end
        if not worst then break end
        table.remove(seq, worst)
        total = Words()
    end
    -- (a small day that is still over what the plain telling takes: the trade line goes,
    -- then the feeling of the lowest rank, never the one on the first death)
    while total > limit do
        local worst
        for i, entry in ipairs(seq) do
            local trade = entry.kind == "gather" or entry.kind == "craft"
            if trade and not entry.peak and not entry.setup and not entry.glue and not entry.level then worst = i end
        end
        if not worst then
            for i, entry in ipairs(seq) do
                if entry.felt and entry.felt ~= "deathFirst"
                    and (not worst or (FELT_RANK[entry.felt] or 10) >= (FELT_RANK[seq[worst].felt] or 10)) then worst = i end
            end
        end
        if not worst then break end
        table.remove(seq, worst)
        total = Words()
    end
    Sel.Chains(sel, seq)
    Sel.Levels(sel, seq)
    Sel.Titles(sel, seq)
    -- (a close with the level in it that takes the chapter over its size: the shortest wording)
    local closing = sel.closing
    local last = seq[#seq]
    if Words() > limit and last and last.close and last.levelIn and closing and closing.pool then
        local best
        for _, line in ipairs(closing.pool) do if not best or WordCount(line) < WordCount(best) then best = line end end
        last.text = Fill(best, {clock = closing.clock, level = tostring(closing.level)})
    end
    sel.words = Words()
end

-- A10. The day's opener folds into the first event: "Saturday night I set out again in
-- Tirisfal Glades. We hunted ..." becomes "Saturday night in Tirisfal Glades, we hunted ...".
-- Only when the opener says nothing but the day and the land, and the work was done there.
local DAY_PARTS = {morning = true, afternoon = true, evening = true, night = true}
function Sel.Opener(sel)
    local items = sel.items
    local first = items[1]
    if not first or not first.keep or first.kind ~= "open" or first.major or first.m.origin then return end
    local day, part, rest = first.plain:match("^(%a+day) (%a+),? (.+)%.$")
    local zone = (sel.stretches[first.s] or {}).zone
    local place = zone and sel.ctx.Place and Plain(sel.ctx.Place(zone))
    if not day or not DAY_PARTS[part] or not place or place == "" then return end
    local tail = " in " .. place
    if rest:sub(-#tail) ~= tail then return end
    local middle = rest:sub(1, #rest - #tail)
    if WordCount(middle) > 5 or middle:find("%u[%a']+", 2) or middle:find(",", 1, true) then return end
    local nextIt
    for n = 2, #items do if items[n].keep then nextIt = items[n] break end end
    if not nextIt or nextIt.clock or nextIt.sit ~= first.sit or (sel.stretches[nextIt.s] or {}).zone ~= zone then return end
    if not (nextIt.chosen or nextIt.short) or nextIt.plain:lower():find("%f[%a]there%f[%A]") then return end
    nextIt.open = day .. " " .. part .. tail
    first.keep = false
end

-- (who promised, in the words already told: "Zygand promised ..." gives Zygand)
function Sel.Promiser(text)
    local name = text:match("(%u[%a']+) promised") or text:match("(%u[%a']+) had promised")
    if name and not ({He = true, She = true, They = true, We = true, I = true, It = true, You = true})[name] then return name end
    return nil
end

-- Routine work as acts (P.Apply step 4, shared with the composer since lane U, 2026-11-11).
-- Every piece gets a score: its worth, two more when a scene of the day names the same person
-- or place (or shares its thread), one more for a turning point.
function Sel.Acts(sel, scenes)
    local items, zoneWords = sel.items, sel.zoneWords
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
end

-- People named by the day's work (shared with the composer since lane U, 2026-11-11): the
-- full name once, the short name after. Sel.Persons fills sel.persons (full name to short) and
-- sel.people (the full names, longest first); Sel.Shorten shortens a line's names that were
-- said before, and a two-word name said twice in one line.
function Sel.Persons(sel)
    local items, titleWords = sel.items, sel.titleWords or {}
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
    sel.persons = persons
    for full in pairs(persons) do people[#people + 1] = full end
    table.sort(people, function(x, y) if #x ~= #y then return #x > #y end return x < y end)
    sel.people = people
end
function Sel.Shorten(sel, line, saidBefore)
    local people, persons, titleWords = sel.people or {}, sel.persons or {}, sel.titleWords or {}
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

-- Lane U (2026-11-11, the composer only, sel.pairs). Setups and payoffs kept together: a told
-- step of a chain of its own (the class's, or a specific thread) pulls in the step before it
-- and the step after it when they are untold and have words of their own (a scene, or an act
-- with an authored account). The room comes from the plainest told errands that stand in no
-- pair and need not be told; a payoff whose setup finds no room is left out instead, unless it
-- must be told. A pulled step pulls nothing further.
function Sel.Pairs(sel)
    local units, steps = sel.units, sel.steps or {}
    local used, room = steps[4] or 0, steps[5] or 0
    local function Cost(u, mode)
        if not mode then return 0 end
        if u.kind == "scene" then return (mode == "short" and u.short) and WordCount(u.short) or u.words end
        if u.kind == "act" and mode == "full" then return WordCount(Sel.Account(sel, u)) end
        if u.kind == "act" and mode == "alt" then return WordCount(u.alt) end
        if u.kind == "act" and mode == "lead" then return WordCount(Sel.Lead(sel, u)) end
        return u.words + (u.kind == "act" and (u.callback and 8 or 2) or 0)
    end
    local function Rich(u) return u.kind == "scene" or (u.kind == "act" and Sel.Account(sel, u) ~= nil) end
    local function Untell(w) used = used - Cost(w, w.mode); w.mode, w.skip = nil, true end
    local function Tell(o)
        used = used + Cost(o, "full")
        o.mode, o.paired, o.pulled = "full", true, true
        if o.kind == "act" then o.tell, o.promote = o.full, o.promote or o.variant end
    end
    local order = {}
    for _, u in ipairs(units) do order[#order + 1] = u end
    table.sort(order, function(x, y) if (x.t or 0) ~= (y.t or 0) then return (x.t or 0) < (y.t or 0) end return x.i < y.i end)
    -- (the nearest step of the same people or chain, before or after: told already, nothing is
    -- needed; untold and bare, the walk goes on; untold with words of its own, it is pulled)
    local function Neighbour(i, step)
        local j = i + step
        while order[j] do
            local o = order[j]
            if Sel.Linked(sel, order[i], o) then
                if o.mode then return nil end
                if Rich(o) then return o end
            end
            j = j + step
        end
        return nil
    end
    -- (the told steps, best first: a pair is worth its told step, so the room for it comes from
    -- told steps of lower rank, a pulled step of lower rank among them)
    local at = {}
    for i, u in ipairs(order) do at[u] = i end
    local anchors = {}
    for _, u in ipairs(units) do if u.mode and u.kind ~= "fixed" then anchors[#anchors + 1] = u end end
    local function Rank(u) return u.rank or u.score or 0 end
    table.sort(anchors, function(x, y) if Rank(x) ~= Rank(y) then return Rank(x) > Rank(y) end return at[x] < at[y] end)
    for _, u in ipairs(anchors) do
        if u.mode and not u.pulled then
            local i = at[u]
            local prev, nxt = Neighbour(i, -1), Neighbour(i, 1)
            for _, o in ipairs({prev, nxt}) do
                if u.mode and o and not o.mode and Rich(o) then
                    local cost = Cost(o, "full")
                    while used + cost > room do
                        local worst
                        for _, w in ipairs(units) do
                            if w.mode and w ~= u and w ~= o and not w.must and not w.peak and not w.setup and not w.first and not w.callback
                                and Rank(w) < Rank(u) and (not w.paired or w.pulled)
                                and (not worst or Rank(w) < Rank(worst)) then worst = w end
                        end
                        if not worst then break end
                        Untell(worst)
                    end
                    if used + cost <= room then Tell(o); u.paired = true
                    elseif o == prev and not u.must then Untell(u) end
                end
            end
        end
    end
    -- (a bare act beside a told scene of the same people, now that the pairs are in: left out)
    for _, w in ipairs(units) do
        local bare = (w.kind == "scene" and w.mode == "short") or (w.kind == "act" and w.mode == "act")
        if bare and not w.callback and not w.must then
            for _, o in ipairs(units) do
                if o.mode and o ~= w and o.kind ~= "fixed" and not ((o.kind == "scene" and o.mode == "short") or (o.kind == "act" and o.mode == "act"))
                    and Sel.Linked(sel, w, o) then Untell(w); break end
            end
        end
    end
    sel.used = (sel.used or 0) - (steps[4] or 0) + used
    steps[4] = used
end

-- Lane S (2026-11-11). A step dropped today that first names someone or something the next
-- days' work goes on to speak of is told after all, in its account's opening at least, so a
-- later chapter's "the ring" has its ring. sel.promised holds the names the later records
-- carry (the composer collects them from the record's next days); a name the book or the
-- day's told work already holds needs nothing; two such steps a chapter at most, the best first.
function Sel.Promised(sel)
    local units, promised = sel.units, sel.promised
    local known = ((sel.hp and sel.hp.text) or "") .. " " .. (sel.knownText or "")
    local Bare = A.SelfCompose and A.SelfCompose.BareNames or function(text) return Names(text, sel.zoneWords) end
    local told = ""
    for _, u in ipairs(units) do
        if u.mode then
            local text = (u.kind == "act" and ((u.mode == "full" and u.full) or (u.mode == "alt" and u.alt) or (u.mode == "lead" and Sel.Lead(sel, u)) or u.plain))
                or (u.mode == "short" and u.short) or u.plain
            told = told .. " " .. Plain(text or "")
        end
    end
    local order = {}
    for _, u in ipairs(units) do order[#order + 1] = u end
    table.sort(order, function(x, y) if (x.t or 0) ~= (y.t or 0) then return (x.t or 0) < (y.t or 0) end return x.i < y.i end)
    local candidates = {}
    for _, u in ipairs(order) do
        if not u.mode and u.kind ~= "fixed" and (u.kind == "scene" or Sel.Account(sel, u)) then
            local text = u.plain .. " " .. Plain((u.kind == "act" and u.full) or "")
            for name in pairs(Bare(text)) do
                if promised[name] and not (sel.zoneWords or {})[name] and not known:find(name, 1, true) and not told:find(name, 1, true) then
                    u.promisedName = name
                    candidates[#candidates + 1] = u
                    break
                end
            end
        end
    end
    table.sort(candidates, function(x, y) if (x.score or 0) ~= (y.score or 0) then return (x.score or 0) > (y.score or 0) end return x.i < y.i end)
    local n = 0
    for _, u in ipairs(candidates) do
        if n >= 2 then break end
        if not told:find(u.promisedName, 1, true) then
            if u.kind == "scene" then u.mode = "full"
            else
                u.need = u.promisedName
                local lead = not u.kin and Sel.Lead(sel, u)
                u.mode = (lead and lead:find(u.promisedName, 1, true)) and "lead" or "full"
                u.tell, u.promote = (u.mode == "lead" and lead) or u.full, u.promote or u.variant
            end
            u.must, u.promised = true, true
            told = told .. " " .. u.plain .. " " .. Plain(u.full or "")
            n = n + 1
        end
    end
end

-- (selection helpers end)

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
    local sel = Sel.Start({items = items, stretches = stretches, hp = hp, index = index, out = out, ctx = ctx, PW = PW, F = F,
        Tale = Tale, QD = QD, Pick = Pick, Clock = Clock, whoShape = 0})
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
                        -- (out without the companion of the day, and with nobody else: told as alone)
                        local alone = sel.mate and not sel.mateIn[it.s] and #((stretches[it.s] or {}).with or {}) == 0 and Pick(PW.alone, "alone")
                        it.text = Fill(alone or Pick(PW.short, "short"), {When = when})
                        it.opener = true
                    end
                elseif it.m.hearth then
                    local death = nextIt and nextIt.m.simpleDeath and nextIt
                    local town
                    for _, e in ipairs((stretches[it.s] or {}).events or {}) do if e.k == "town" and e.d and not town then town = e.d end end
                    town = town or (stretches[it.s] or {}).zone
                    if death and town and death.t and it.m.hearth.t and death.t - it.m.hearth.t <= 600 and death.m.simpleDeath.foe then
                        it.text = Fill(Pick(PW.hearthDeath, "hearthDeath"), {town = Place(town), foe = death.m.simpleDeath.foe})
                        it.kind, it.major, it.peak = "death", true, death.peak
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
    sel.zoneWords = zoneWords
    Sel.Acts(sel, scenes)

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

    -- What is told (A1 to A5): the spine in full, the best errands short, the rest left out.
    sel.zoneWords, sel.sittings, sel.figureScene, sel.figureLine = zoneWords, sittings, figureScene, figureLine
    Sel.Units(sel)
    Sel.Peaks(sel)
    Sel.Choose(sel)

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
        -- (a scene or a death told after that work and still before the level carries it instead)
        local late
        for _, it in ipairs(items) do
            local timed = it.kind == "questStart" or it.kind == "questOutcome" or it.kind == "death"
            if it.keep and timed and it.t and it.t <= levelT + 60 and not (sittings[it.sit] or {}).short then late = it end
        end
        if late and (not anchor or late.n > anchor.n) then
            anchor = late
            do
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
            anchor.levelAfter, anchor.levelMode, anchor.levelT = levelLine.m.levelEarly, mode, levelT
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
            -- (a dropped stop at a named place gives its place to the line: "At the tavern, ...";
            -- never to a first sighting of the other side, which the record does not put there:
            -- that one is told with no place)
            local sighting = items[n].m.e and items[n].m.e.d == "foeseen"
            local place = not sighting and items[n - 1].kind == "rest" and items[n - 1].plain:match("^%a+ rested at (.+)%.$")
            local bare = sighting and items[n].text:match("^There,? (.+)$")
            if bare then
                items[n].text = Cap(bare)
                items[n].plain = Plain(items[n].text)
            elseif place and items[n].text:find("^There[ ,]") then
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
    sel.titleWords = titleWords
    Sel.Persons(sel)
    local function ShortenPeople(line, saidBefore) return Sel.Shorten(sel, line, saidBefore) end

    -- Felt lines (JournalFeel.lua): the identity pool first, then the stage's own.
    local stage, race = Stage(ctx.level), ctx.race
    local feltCount = 0
    local feltKinds = {} -- (one felt line of a kind in a chapter: a second death is not felt again)
    local function Felt(kind, pools, tokens, saidText, nextText, own)
        if not stage or feltKinds[kind] then return nil end
        if hp.kind[kind] and index - hp.kind[kind] <= 3 then return nil end
        -- (own: the pools that speak of what the character is. One such line a chapter, and a
        -- hash of the day lets the plain pool go first now and then. Every candidate is
        -- collected; Sel.Finish keeps the best two or three.)
        own = own or {true}
        local order = {}
        for p = 1, 4 do if pools[p] and not (own[p] and sel.identity) then order[#order + 1] = p end end
        if #order > 1 and own[order[1]] and Hash(seed .. ":own:" .. kind) % 3 == 0 then order[#order + 1] = table.remove(order, 1) end
        for _, p in ipairs(order) do
            local pool = pools[p]
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
                usable = Sel.Shapes(sel, usable)
                local choice = usable[Hash(seed .. ":" .. kind .. p) % #usable + 1]
                feltKinds[kind] = true
                if own[p] then sel.identity = true end
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
        sel.at = #seq
        if entry.felt then Sel.Shapes(sel, nil, text) end
        return entry
    end
    local earlier = hp.text or ""
    local deathBefore = hp.lastDeath and index - hp.lastDeath <= 1
    -- (the feeling a peak carries, and the companion's level beside it)
    local function PeakFelt(it)
        local kind, pools, tokens, own = Sel.FeltFor(sel, it)
        local text, line
        if kind and not it.feltDone then text, line = Felt(kind, pools, tokens, earlier .. said, nil, own) end
        if text then
            Push(text, it, {glue = true, felt = kind, line = line})
            it.feltDone = true
        end
        return text ~= nil
    end
    local function BesideHer(it)
        local text = Sel.MateLevel(sel, it)
        if text then Push(text, it, {glue = true, level = true, mate = true}) end
    end
    Sel.Opener(sel)
    for n, it in ipairs(items) do
        if it.keep then
            local m = it.m
            local leadSit = it.sit > 1 and (not seq[#seq] or seq[#seq].sit ~= it.sit) and date
            local lead
            if leadSit then
                local part, before = PartOfDay(sittings[it.sit].t), PartOfDay(sittings[it.sit - 1].t)
                lead = part == before and "Later" or ("That " .. part)
            end
            if it.levelAfter and it.both == nil then it.both = Sel.BothLevel(sel, it.levelAfter, it.levelT) or false end
            if it.chosen then
                -- a line of work, rebuilt from the pieces kept: a sentence a piece, or two under one giver
                local lines = Sel.Work(sel, it, it.clock or it.open or lead, seq[#seq] and Plain(seq[#seq].text))
                -- (round 2, B8: the return to a place of death ends its unit; nothing is hung on it)
                for i, line in ipairs(lines) do
                    local text = ShortenPeople(line.text, earlier .. said)
                    -- (the level that came with this very work)
                    if i == #lines and it.levelAfter and not it.both and it.levelMode == "with" and PW.levelWith and WordCount(text) <= 16
                        and not text:find(",", 1, true) then
                        text = text:gsub("%.$", "") .. Fill(Pick(PW.levelWith, "levelWith"), {level = tostring(it.levelAfter)}) .. "."
                        it.levelAfter = nil
                    end
                    Push(text, it, line.opts)
                    if line.opts.peak == "payoff" and F.backDeath then
                        local text2, felt = Felt("backDeath", {F.backDeath}, {}, earlier .. said, nil, {})
                        if text2 then Push(text2, it, {glue = true, felt = "backDeath", line = felt}) end
                    end
                end
            elseif it.kind == "death" and m.simpleDeath and it.text == m.said then
                local d = m.simpleDeath
                local text = it.text
                if it.clock or d.sameDay then
                    local foe = d.foe
                    if not it.clock then foe = Cap(foe) end
                    text = (it.clock and (it.clock .. ", ") or "") .. Fill(Pick(PW.killed, "killed" .. n), {foe = foe, where = d.sub and (" in " .. d.sub) or ""})
                end
                -- (a death stands alone, unless the day was one death after another)
                Push(text, it, {clock = it.clock ~= nil, peak = it.peak or ((sel.deathCount or 0) <= 2 and "death") or nil})
                -- (a death after a death: told once the book has the first one)
                local again = deathBefore
                for b = 1, n - 1 do if items[b].kind == "death" then again = true end end
                local nextIt = items[n + 1]
                local firstDeathLine = nextIt and nextIt.kind == "" and nextIt.m.e and nextIt.m.e.k == "death"
                -- (what the book knows of the killer stands right after the death, before any feeling)
                if nextIt and nextIt.keep and nextIt.kind == "lore" and nextIt.m.e == m.e and m.e then
                    Push(nextIt.text, it, {glue = true})
                    nextIt.keep = false
                end
                if PeakFelt(it) then
                    -- (dying alone for the first time says more than dying again)
                elseif again and not firstDeathLine and F.deathAgain then
                    local text2, line = Felt("deathAgain", {F.deathAgain[race or ""], F.deathAgain[ctx.class or ""], F.deathAgain}, {foe = Plain(d.foe)},
                        earlier .. said, nil, {true, true})
                    if text2 then Push(text2, it, {glue = true, felt = "deathAgain", line = line}); feltCount = feltCount + 1 end
                end
                if not firstDeathLine then BesideHer(it) end
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
                    text2, line = Felt("figureNamed", {byFigure, F.figureNamed}, {figure = short, setupName = Sel.Promiser(said)},
                        earlier .. said .. " " .. it.plain, two and Plain(b) or nil)
                end
                if text2 and two then
                    Push(a, it, {turn = true, scene = true, peak = "figure"})
                    Push(text2, it, {glue = true, felt = "figureNamed", line = line})
                    Push(b, it, {glue = true})
                    feltCount = feltCount + 1
                else
                    Push(it.text, it, {turn = true, scene = true, peak = "figure"})
                    if text2 then Push(text2, it, {glue = true, felt = "figureNamed", line = line}); feltCount = feltCount + 1 end
                end
                BesideHer(it)
            else
                local text = it.text
                local opts = {}
                if m.joined and m.zone and lead and PW.joined then
                    text = Fill(Pick(PW.joined, "joined"), {When = lead, names = m.joined, zone = m.zone})
                elseif (lead or it.open) and (it.plain:find("^I ") or it.plain:find("^We ")) and (it.short or not it.scene) then
                    text = (it.open or lead) .. ", " .. (it.plain:find("^We ") and ("w" .. text:sub(2)) or text)
                    opts.opened = it.open or lead
                end
                if it.short then text = ShortenPeople(text, earlier .. said) end
                -- (A9: the close, on place or company with the hour)
                if m.close then text, opts.glue, opts.close = Sel.Close(sel, it, seq), true, true end
                opts.peak, opts.setup, opts.side = it.peak, it.setup, it.side
                if it.short then opts.work, opts.score = true, it.unit and it.unit.score
                elseif it.scene and it.kind == "questStart" then opts.turn, opts.scene = true, true end
                if it.scene and it.kind == "questOutcome" and items[n - 1] and items[n - 1].m.entry == m.entry then opts.glue = true end
                if it.kind == "move" or it.kind == "open" or it.kind == "town" or (m.e and m.e.k == "town") or m.joined then opts.turn = true end
                -- (a line that points back at the one before it stays with it)
                if it.plain:find("^There[ ,]") or it.plain:find(" there%.$") or it.plain:find("^One, ") or it.plain:find("^Then ") then opts.glue = true end
                if it.peak == "foe" and it.plain:find(" there[ ,%.]") then opts.glue = true end
                if it.kind == "" and m.e and m.e.k == "death" and items[n - 1] and items[n - 1].kind == "death" then
                    opts.glue, opts.felt = true, "deathFirst"
                    feltCount = feltCount + 1
                end
                if m.e and m.e.k == "home" then opts.glue = true end
                -- (the stop and the home made there are one sentence; two stops are never welded)
                local last = seq[#seq]
                local prevIt = last and last.it
                -- (a death right after the line that opens the day is told with it)
                if it.kind == "death" and prevIt and prevIt.opener and prevIt.sit == it.sit then opts.glue = true end
                if text and m.e and m.e.k == "home" and prevIt and prevIt.kind == "rest" and last.text == prevIt.text and prevIt.sit == it.sit
                    and it.plain:find("^I ") and it.plain:find(" there%.$") and not last.text:find(",", 1, true) then
                    last.text = last.text:gsub("%.$", "") .. ", and " .. text
                    last.peak = it.peak
                    said = said .. " " .. Plain(text)
                    text = nil
                end
                if text then Push(text, it, opts) end
                PeakFelt(it)
                if it.peak == "spell" then BesideHer(it) end
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
                Push(it.both or Fill(Pick(pool, "level"), {level = tostring(it.levelAfter)}), it,
                    {glue = true, level = true, levelN = it.levelAfter, levelT = it.levelT, both = it.both and true or nil})
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
    sel.earlier = earlier
    Sel.Finish(sel, seq)
    if #seq == 0 then return nil end
    -- How the kept lines read (JournalSelfStyle.lua): openers, paragraphs, air round a
    -- peak, the close. Without that file, one paragraph a sitting.
    local Style = A.SelfStyle
    local texts = Style and Style.Apply and Style.Apply(seq, {seed = seed, index = index, earlier = earlier, ctx = ctx,
        hp = hp, sittings = sittings, PW = PW, F = F})
    if not texts then
        while seq[#seq] and seq[#seq].felt and seq[#seq].felt ~= "deathFirst" do seq[#seq] = nil end
        texts = {}
        local sit
        for _, entry in ipairs(seq) do
            if entry.sit ~= sit then texts[#texts + 1], sit = entry.text, entry.sit
            else texts[#texts] = texts[#texts] .. " " .. entry.text end
        end
    end
    if #texts == 0 then return nil end

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
