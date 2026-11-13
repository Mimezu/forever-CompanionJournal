-- Companion Journal: episodes, the units of a story that span scenes (2026-11-11).
-- Pure data, no wording: both storytellers read the same unit and tell it their way.
--
-- A.JournalEpisodes.DungeonRuns(scenes, opts) returns the dungeon runs of a day from
-- JournalBook's `day.scenes` (outings in time order; stretches built from them work too,
-- as long as they keep `kind`, `zone`, `t`, `e`, `entries`, `events`, `with`, `bosses`
-- and `quests`). A run is one visit to one dungeon, from going in to coming out for
-- good. A ghost run out through the zone and the town after a wipe, and the walk back
-- in, are inside the run; the second try is an attempt of the same run, never a new one.
--
-- Each run: {dungeon, entered, left, scenes (the dungeon stays), between (the stays
-- outside it, inside the run), attempts = {{entered, left, bosses, deaths, raises, wipe}},
-- party = {names, count, roles = {me, them}}, bosses (true order, with times), deaths
-- (mine and the party's), raises, quests (whose deeds are about the dungeon or its
-- bosses, turned in inside it or within an hour after leaving), level (reached inside
-- the run or with those turn-ins), wipes (the count)}.
--
-- opts (all optional): isDungeon(zone) in place of Lore's; questText(quest) in place of
-- the title plus the stage's lines; bosses(dungeon) for the names of its bosses when the
-- record killed none (Lore's lord by default).
local _, A = ...
local E = {}
A.JournalEpisodes = E

E.OUT_STAY = 10 * 60      -- a stay outside the dungeon this short can be part of a ghost run
E.OUT_TOTAL = 20 * 60     -- ...and the way out and back takes this long at most
E.QUEST_AFTER = 60 * 60   -- a turn-in about the run this long after leaving still belongs to it
E.LEVEL_AFTER = 10 * 60   -- a level this long after leaving, with no turn-in, still belongs to it
-- What may happen outside between two tries: resting, passing a town, companions dying on the way.
local QUIET = {town = true, rest = true, sleep = true, cave = true, home = true, pdeath = true, death = true, rez = true}

local function Clean(text) return (tostring(text or ""):gsub("[{}]", "")) end
local function Sort(list) table.sort(list, function(a, b) return (a.t or 0) < (b.t or 0) end); return list end

local function DungeonOf(scene, opts)
    if not scene or (scene.kind and scene.kind ~= "outing") or not scene.zone then return nil end
    for _, e in ipairs(scene.events or {}) do if e.k == "dungeon" and e.d == scene.zone then return e.d end end
    local known = (opts and opts.isDungeon) or (A.Lore and A.Lore.Dungeon)
    if known and known(scene.zone) then return scene.zone end
    return nil
end
local function Quiet(scene)
    if (scene.kind and scene.kind ~= "outing") or scene.open then return false end
    if (scene.questCount or 0) > 0 or #(scene.bosses or {}) > 0 then return false end
    if next(scene.gather or {}) ~= nil or next(scene.craft or {}) ~= nil then return false end
    if (scene.e or 0) - (scene.t or 0) > E.OUT_STAY then return false end
    for _, e in ipairs(scene.events or {}) do if not QUIET[e.k] then return false end end
    return true
end
-- The words of a quest, to tell what it is about: the title and the stage's lines.
local function QuestText(q, opts)
    if opts and opts.questText then return Clean(opts.questText(q)) end
    local parts = {Clean(q.title)}
    local L = A.Lore
    local story = L and L.QuestStory and L.QuestStory(q.title, q.qid)
    if story then
        for _, key in ipairs({"why", "after", "highlight"}) do
            if type(story[key]) == "table" then for _, line in ipairs(story[key]) do parts[#parts + 1] = Clean(line) end end
        end
        if type(story.pov) == "table" then
            for _, line in ipairs(story.pov) do parts[#parts + 1] = Clean(line) end
            if story.pov.act then parts[#parts + 1] = Clean(story.pov.act) end
        end
    end
    local W = A.SelfWords
    local over = W and W.pov and q.qid and W.pov[tonumber(q.qid)]
    if type(over) == "table" then
        for _, line in ipairs(over) do parts[#parts + 1] = Clean(line) end
        if over.act then parts[#parts + 1] = Clean(over.act) end
    end
    return table.concat(parts, " ")
end
-- Does the text name this (a full name, or Lore's short form of it as a whole word)?
local function Names(text, name)
    name = Clean(name)
    if name == "" then return false end
    if text:find(name, 1, true) then return true end
    local L = A.Lore
    local short = L and L.Short and L.Short(name)
    if short and short ~= name and #short >= 4 then
        return text:find("%f[%w']" .. short:gsub("%p", "%%%0") .. "%f[^%w']") ~= nil
    end
    return false
end
E.QuestText, E.Names = QuestText, Names

local function Fill(run, scenes, opts)
    local first, last = run.scenes[1], run.scenes[#run.scenes]
    run.entered, run.left = first.t, last.e
    -- Everything that happened inside the run, in time order (the ghost run's deaths too).
    local inside = {}
    for _, scene in ipairs(run.scenes) do inside[#inside + 1] = scene end
    for _, scene in ipairs(run.between) do inside[#inside + 1] = scene end
    local events = {}
    for _, scene in ipairs(inside) do for _, e in ipairs(scene.events or {}) do events[#events + 1] = e end end
    Sort(events)
    run.bosses, run.deaths, run.raises = {}, {}, {}
    for _, e in ipairs(events) do
        if e.k == "boss" and e.d then
            run.bosses[#run.bosses + 1] = {name = e.d, t = e.t or 0, n = tonumber(e.n), me = e.me, them = e.them, event = e}
        elseif e.k == "death" then
            run.deaths[#run.deaths + 1] = {t = e.t or 0, mine = true, foe = e.d, boss = e.boss, place = e.sz, event = e}
        elseif e.k == "pdeath" and e.n then
            run.deaths[#run.deaths + 1] = {t = e.t or 0, name = (Clean(e.n):gsub("%-.*$", "")), boss = e.boss, event = e}
        elseif e.k == "rez" then
            run.raises[#run.raises + 1] = {t = e.t or 0, by = e.by, mine = true, event = e}
        elseif e.k == "first" and e.d == "rezother" and e.n then
            run.raises[#run.raises + 1] = {t = e.t or 0, name = Clean(e.n), byMe = true, event = e}
        end
    end
    -- The attempts: every walk in (the record's `dungeon` entries), the first of them the run's start.
    local starts = {}
    for _, scene in ipairs(run.scenes) do
        for _, x in ipairs(scene.entries or {}) do
            if x.k == "dungeon" and (x.d or x.z) == run.dungeon then
                starts[#starts + 1] = {t = x.t or scene.t, r = x.r, tr = x.tr}
                run.playerLevel = run.playerLevel or tonumber(x.pl)
            end
        end
    end
    Sort(starts)
    local attempts = {}
    for _, x in ipairs(starts) do
        local prev = attempts[#attempts]
        if not prev or x.t - prev.entered > 60 then attempts[#attempts + 1] = {entered = x.t, r = x.r, tr = x.tr} end
    end
    if #attempts == 0 then attempts[1] = {entered = run.entered} end
    for a, at in ipairs(attempts) do
        at.left = attempts[a + 1] and attempts[a + 1].entered or run.left
        at.bosses, at.deaths, at.raises = {}, {}, {}
        for _, b in ipairs(run.bosses) do if b.t >= at.entered and b.t < at.left then at.bosses[#at.bosses + 1] = b end end
        for _, d in ipairs(run.deaths) do if d.t >= at.entered and d.t < at.left then at.deaths[#at.deaths + 1] = d end end
        for _, r in ipairs(run.raises) do if r.t >= at.entered and r.t < at.left then at.raises[#at.raises + 1] = r end end
        -- (a wipe: the attempt ended on deaths, with no boss killed after the last of them)
        local lastDeath = at.deaths[#at.deaths]
        at.wipe = lastDeath ~= nil and not (at.bosses[#at.bosses] and at.bosses[#at.bosses].t > lastDeath.t)
    end
    run.attempts = attempts
    run.wipes = 0
    for _, at in ipairs(attempts) do if at.wipe then run.wipes = run.wipes + 1 end end
    -- The party: the companions the record knows, the count from the fights, my role.
    local names, seen = {}, {}
    for _, scene in ipairs(inside) do
        for _, w in ipairs(scene.with or {}) do
            local name = Clean(w.name):gsub("%-.*$", "")
            if name ~= "" and not seen[name] then seen[name] = true; names[#names + 1] = name end
        end
    end
    -- (someone who died in the run was in it, even when the list does not know them)
    for _, d in ipairs(run.deaths) do
        if d.name and d.name ~= "" and not seen[d.name] then seen[d.name] = true; names[#names + 1] = d.name end
    end
    local count = 0
    for _, b in ipairs(run.bosses) do if b.n and b.n > count then count = b.n end end
    if count < 1 then count = #names + 1 end
    if count < #names + 1 then count = #names + 1 end
    local roles = {}
    for _, at in ipairs(attempts) do roles.me = roles.me or at.r; roles.them = roles.them or at.tr end
    run.party = {names = names, count = count, roles = roles}
    -- The quests about it: inside the run, or turned in within an hour of leaving.
    local bossNames = {}
    for _, b in ipairs(run.bosses) do bossNames[#bossNames + 1] = b.name end
    local more = opts and opts.bosses and opts.bosses(run.dungeon)
    if more then for _, b in ipairs(more) do bossNames[#bossNames + 1] = b end end
    local story = A.Lore and A.Lore.DungeonStory and A.Lore.DungeonStory(run.dungeon)
    if story and story.last then bossNames[#bossNames + 1] = story.last end
    local place = Clean(run.dungeon):gsub("^The ", "")
    run.quests = {}
    local lastTurnIn = nil
    for _, scene in ipairs(scenes) do
        if scene.kind == "outing" or scene.kind == "quest" then
            for _, q in ipairs(scene.quests or {}) do
                local t = q.t or scene.t or 0
                if t >= run.entered and t <= run.left + E.QUEST_AFTER then
                    local text = QuestText(q, opts)
                    local about = Names(text, place)
                    for _, b in ipairs(bossNames) do if not about and Names(text, b) then about = true end end
                    if about then
                        -- (the quest's level, from the record's entry, for the odds at the entry)
                        local ql
                        for _, x in ipairs(scene.entries or {}) do
                            if x.k == "quest" and x.d == q.title and (not q.qid or x.qid == q.qid) then ql = ql or tonumber(x.ql) end
                        end
                        run.quests[#run.quests + 1] = {quest = q, scene = scene, t = t, level = ql}
                        if not lastTurnIn or t > lastTurnIn then lastTurnIn = t end
                    end
                end
            end
        end
    end
    Sort(run.quests)
    -- A level inside the run, or with its turn-ins: the last one reached inside the run (the
    -- level the run came to, told at the kill it came with; round 7, 2026-11-11), else the first
    -- with its turn-ins. `levels` holds them all, in time order.
    local until_ = math.max(run.left + E.LEVEL_AFTER, (lastTurnIn or 0) + 60)
    run.levels = {}
    local function Level(level, t)
        if t < run.entered or t > until_ then return end
        run.levels[#run.levels + 1] = {level = level, t = t}
        local inside = t <= run.left
        local had = run.level
        if not had or (inside and (had.t > run.left or t > had.t)) then run.level = {level = level, t = t} end
    end
    for _, scene in ipairs(scenes) do
        for _, e in ipairs(scene.events or {}) do
            if e.k == "mylevel" then Level(tonumber(e.d) or e.d, e.t or 0) end
        end
        if scene.kind == "mylevel" then Level(tonumber(scene.text) or scene.text, scene.t or 0) end
    end
    Sort(run.levels)
    return run
end

-- The shape of a run's kills around the boss that mattered (shared by both books, round 3,
-- 2026-11-11): `names` in kill order; `isGoal(name)` true for the boss a quest of the day is
-- about, `isLord(name)` for the lord of the place. Returns nil when none of them is there
-- (a plain roll), else {key, at, goal (a quest's boss, not only the lord), before, after,
-- shown (the ones before, the first two when four or more), more (how many the shown leave
-- out)}. The telling makes beats of it: the ones before fell first, then came the goal, who he
-- is and why he matters, and the kill; the ones after are a tail.
-- A boss's pronoun, for both books, from data and never from a hand list (round 7,
-- 2026-11-11; the list it replaces called Whitemane "him"): a title in the name or a gendered
-- word in the lore's epithet settles it ("Lady", "Princess", "the quilboar matriarch"); else
-- the texts the addon holds about the boss (the boss's own lines, the reference note, the
-- dungeon's story, the quest stories) are read for the pronouns their sentences use of the
-- name ("Whitemane ... her top lieutenants", "Amnennar ... his mind"); a beast, an aberration
-- or an elemental with no such word is "it". A boss nobody has written of gets no pronoun:
-- returns nil, and the telling uses the name or the title (E.BossTitle) instead of a guess.
-- Returns subject, object, possessive. `lore` is L.Boss(name) (optional).
local FEMALE_WORDS = {lady = true, princess = true, mother = true, mistress = true, sister = true, baroness = true, priestess = true,
    widow = true, queen = true, empress = true, matriarch = true, daughter = true, broodmother = true}
local MALE_WORDS = {lord = true, prince = true, father = true, brother = true, baron = true, king = true, emperor = true, patriarch = true,
    son = true, mr = true}
local SHE, HE = {she = true, her = true, hers = true, herself = true}, {he = true, him = true, his = true, himself = true}
local pronounCache = {}
local function GenderWords(text)
    local f, m = 0, 0
    for word in text:lower():gmatch("%a+") do
        if FEMALE_WORDS[word] then f = f + 1 elseif MALE_WORDS[word] then m = m + 1 end
    end
    return f, m
end
-- Sentences of a text that name the boss (the full name, or its last word when it is a name of
-- its own, "Whitemane"), and the pronouns they use.
local function PronounsAbout(text, name, short)
    local f, m = 0, 0
    text = Clean(text):gsub("{%a:([^}]*)}", "%1")
    for sentence in (text .. "."):gmatch("[^%.!?]+[%.!?]") do
        local names = sentence:find(name, 1, true) or (short and sentence:find("%f[%w']" .. short:gsub("%p", "%%%0") .. "%f[^%w']"))
        if names then
            for word in sentence:lower():gmatch("%a+") do
                if SHE[word] then f = f + 1 elseif HE[word] then m = m + 1 end
            end
        end
    end
    return f, m
end
local function Texts(t, value)
    if type(value) == "string" then t[#t + 1] = value
    elseif type(value) == "table" then for _, v in pairs(value) do Texts(t, v) end end
end
function E.BossGender(name, lore)
    name = Clean(name)
    if pronounCache[name] ~= nil then return pronounCache[name] or nil end
    local L = A.Lore
    lore = lore or (L and L.Boss and L.Boss(name))
    local result
    -- (the name's own title, then the epithet's noun)
    local f, m = GenderWords((name:gsub("'s$", "")))
    if f == 0 and m == 0 and lore and lore.e then f, m = GenderWords(lore.e) end
    if f > 0 and m == 0 then result = "she" elseif m > 0 and f == 0 then result = "he" end
    if not result then
        local short = L and L.Short and L.Short(name)
        if short == name or (short and short:find(" ", 1, true)) then short = nil end
        local texts = {}
        if lore then Texts(texts, {lore.after, lore.afterMore, lore.afterRace}) end
        local id = A.LoreNoteResolve and A.LoreNoteResolve("n", name)
        local note = id and A.GetLoreNote and A.GetLoreNote(id)
        if note and note.body then texts[#texts + 1] = note.body end
        for _, story in pairs((L and L.dungeonStory) or {}) do
            if type(story) == "table" then Texts(texts, {story.why, story.inside, story.detail, story.unfinished, story.again, story.after}) end
        end
        for _, q in pairs((L and L.questStoryIDs) or {}) do
            if type(q) == "table" then Texts(texts, {q.why, q.pov, q.after, q.highlight}) end
        end
        local sf, sm = 0, 0
        for _, text in ipairs(texts) do
            local a, b = PronounsAbout(text, name, short)
            sf, sm = sf + a, sm + b
        end
        if sf > sm then result = "she" elseif sm > sf then result = "he" end
    end
    if not result then
        local kind = lore and lore.kind
        if kind == "beast" or kind == "aberration" or kind == "elemental" then result = "it" end
    end
    pronounCache[name] = result or false
    return result
end
function E.BossPronoun(name, lore)
    local g = E.BossGender(name, lore)
    if g == "she" then return "she", "her", "her" end
    if g == "he" then return "he", "him", "his" end
    if g == "it" then return "it", "it", "its" end
    return nil
end
-- What stands in for a pronoun nobody can vouch for: the boss's title in lower case ("the
-- high inquisitor", "the shade" of "Shade of Eranikus"), else the short name.
function E.BossTitle(name)
    name = Clean(name)
    local L = A.Lore
    local title = L and L.Title and L.Title(name)
    if title then return title end
    local head = name:match("^(%u%l+) of %u")
    if head then return "the " .. head:lower() end
    return (L and L.Short and L.Short(name)) or name
end
-- A sentence that claims a boss's death or defeat (round 7, 2026-11-11): the name (or its short
-- form) with a kill or death verb about it, and nothing in the sentence that says it still
-- stands or that someone only wanted it dead. Both books and StoryLint read the same rule, so
-- "Amnennar was destroyed" is never printed after a run that stopped at the first boss.
local CLAIM_AFTER = {" was destroyed", " was dead", " were dead", " was killed", " were killed", " was slain", " were slain", " lay dead",
    " lies dead", " fell", " died", " was no more", " was finished", " was gone", " did not live", " did not outlive", " was beaten", " was overcome",
    " was defeated", " had died", " had fallen", " had been killed", " had been destroyed", " was finally dead", " no longer lived",
    "'s head", "'s heart", "'s skull", "'s death", "'s fall", "'s corpse", "'s body"}
local CLAIM_BEFORE = {"killed ", "slew ", "slain ", "destroyed ", "brought down ", "cut down ", "put an end to ", "laid waste to ", "ended ",
    "beheaded ", "finished ", "dealt with ", "defeated ", "overcame ", "struck down ", "put down ", "the death of ", "the fall of ", "the end of ",
    "an end to ", "rid of "}
local CLAIM_NOT = {"wanted", "would ", "could ", "to kill", "unbeaten", "still ", "had not", "not yet", "left ", "where ", " stood", "if ",
    "before ", "until ", "to end ", "to destroy", "to slay", "to put", "to bring", "to finish", "asked ", "sent ", "meant to", "hoped", "must ",
    "should ", "whether", "orders", "ordered", "wants", "no time", "to see ", "to be ", "the time before", "earlier", "once ", "had lost ",
    "against", "beat ", "first time", "the first", "the second"}
function E.ClaimsDeath(sentence, name)
    local plain = Clean(sentence):gsub("{%a:([^}]*)}", "%1")
    local L = A.Lore
    local short = L and L.Short and L.Short(name)
    local forms = {Clean(name)}
    -- (a short form that is a name of its own: never "The" of "The Unforgiven")
    if short and short ~= Clean(name) and not short:find(" ", 1, true) and #short >= 4 and short:lower() ~= "the" then forms[#forms + 1] = short end
    -- (1.43.1: a sentence that holds none of the forms anywhere claims nothing; the clauses below are
    -- pieces of the same text, so the full check only runs when one is there. A form with a comma or a
    -- semicolon could span two joined clauses, and always takes the full check.)
    local lowPlain, present = plain:lower(), false
    for _, form in ipairs(forms) do
        if form:find("[,;]") or lowPlain:find(form:lower(), 1, true) then present = true; break end
    end
    if not present then return false end
    -- (the clause that names the boss: a claim of it never leans on the clauses around it)
    local clauses = {}
    for piece in (plain .. "; "):gmatch("(.-)[;,] ") do
        local last = clauses[#clauses]
        local joins = piece:match("^(and) ") or piece:match("^(but) ") or piece:match("^(though) ") or piece:match("^(for) ") or piece:match("^(so) ") or piece:match("^(while) ")
        if last and not joins then
            clauses[#clauses] = last .. ", " .. piece
        else
            clauses[#clauses + 1] = joins and piece:sub(#joins + 2) or piece
        end
    end
    for _, clause in ipairs(clauses) do
        local low = clause:lower()
        local at, after
        for _, form in ipairs(forms) do
            local s, e = low:find("%f[%w']" .. form:lower():gsub("%p", "%%%0") .. "%f[^%w]")
            -- (lane O8 round 12: a possessive is no claim, "the foreman Arugal's magic had tainted")
            if s and low:sub(e + 1, e + 2) == "'s" then
                -- (but "VanCleef's head" is one: a part of the body taken)
                local noun = low:sub(e + 3):match("^%s*(%a+)") or ""
                local BODY = {head = true, heart = true, skull = true, corpse = true, body = true, remains = true, ashes = true, scalp = true, hide = true, blood = true, bones = true, hands = true, eye = true, eyes = true, tusk = true, fang = true, claw = true}
                if not BODY[noun] then s = nil end
            end
            if s and (not at or s < at) then at, after = s, e end
        end
        if at then
            local blocked = false
            for _, w in ipairs(CLAIM_NOT) do if low:find(w, 1, true) then blocked = true end end
            if low:find("%f[%a]me%f[%A]") and (low:find("killed me") or low:find("got me") or low:find("fell to ")) then blocked = true end
            if not blocked then
                -- (a list after the name, "Whitemane, Mograine, Herod and Loksey were dead")
                local tail = clause:sub(after + 1)
                local n = 1
                while n > 0 do tail, n = tail:gsub("^,? ?and %u[%w']*", ""); if n == 0 then tail, n = tail:gsub("^, %u[%w']*", "") end end
                tail = tail:lower()
                for _, w in ipairs(CLAIM_AFTER) do if tail:sub(1, #w) == w then return true end end
                local head = low:sub(1, at - 1)
                for _, w in ipairs(CLAIM_BEFORE) do
                    local p = head:find(w, 1, true)
                    -- (lane G8: "killed by a son of Arugal" is Arugal's son killing, not Arugal dying)
                    if p and #head - (p + #w) < 40 and not head:sub(p + #w):find("%f[%a]by%f[%A]") then return true end
                end
            end
        end
    end
    return false
end
-- The sentences of a text that claim a death the kills do not support are removed: `killed(name)`
-- says whether a boss was killed (today or before). Returns the text that is left (nil when
-- none is) and how many sentences went.
-- (1.43.1) The lower-case forms of a boss name E.ClaimsDeath looks for, kept per name (they hang on
-- Lore.Short alone); a sentence without any of them anywhere cannot claim that boss's death.
local formsMemo, formsShort = {}, nil
-- (and per sentence, the names of a list it mentions at all, in the list's order)
local mentionMemo, mentionList, mentionCount = {}, nil, 0
local function LowForms(name)
    local L = A.Lore
    local Short = L and L.Short
    if Short ~= formsShort then formsMemo, formsShort, mentionList = {}, Short, nil end
    local forms = formsMemo[name]
    if forms then return forms end
    local short = Short and Short(name)
    forms = {Clean(name):lower()}
    if short and short ~= Clean(name) and not short:find(" ", 1, true) and #short >= 4 and short:lower() ~= "the" then forms[#forms + 1] = short:lower() end
    for _, form in ipairs(forms) do if form:find("[,;]") then forms.always = true end end
    if type(name) == "string" then formsMemo[name] = forms end
    return forms
end
local function Mentions(low, name)
    local forms = LowForms(name)
    if forms.always then return true end
    for _, form in ipairs(forms) do if low:find(form, 1, true) then return true end end
    return false
end
function E.WithoutUnkilledClaims(text, killed, names)
    if not text or text == "" then return text, 0 end
    local L = A.Lore
    names = names or (L and L.BossNames and L.BossNames()) or {}
    local kept, dropped = {}, 0
    for sentence in (tostring(text) .. " "):gmatch("(.-[%.!?]['\"]?)%s") do
        local bad = false
        local low = Clean(sentence):gsub("{%a:([^}]*)}", "%1"):lower()
        LowForms(names[1] or "")
        if names ~= mentionList then mentionMemo, mentionList, mentionCount = {}, names, 0 end
        local named = mentionMemo[low]
        if not named then
            named = {}
            for _, name in ipairs(names) do if Mentions(low, name) then named[#named + 1] = name end end
            if mentionCount >= 4000 then mentionMemo, mentionCount = {}, 0 end
            mentionMemo[low], mentionCount = named, mentionCount + 1
        end
        for _, name in ipairs(named) do
            if not killed(name) and E.ClaimsDeath(sentence, name) then bad = true; break end
        end
        if bad then dropped = dropped + 1 else kept[#kept + 1] = sentence end
    end
    if dropped == 0 then return text, 0 end
    if #kept == 0 then return nil, dropped end
    return table.concat(kept, " "), dropped
end

function E.ShapeKills(names, isGoal, isLord)
    local keyAt, goal
    for i, n in ipairs(names) do if isGoal and isGoal(n) then keyAt = i; goal = true end end
    if not keyAt then
        for i, n in ipairs(names) do if isLord and isLord(n) then keyAt = i end end
    end
    if not keyAt then return nil end
    local before, after = {}, {}
    for i = 1, keyAt - 1 do before[#before + 1] = names[i] end
    for i = keyAt + 1, #names do after[#after + 1] = names[i] end
    local shown, more = before, 0
    -- (lane G8: the record has names; up to five are said, "more" only beyond that)
    if #before > 5 then shown = {before[1], before[2], before[3]}; more = #before - 3 end
    return {key = names[keyAt], at = keyAt, goal = goal or false, before = before, after = after, shown = shown, more = more}
end

function E.DungeonRuns(scenes, opts)
    local runs = {}
    local outings = {}
    for _, scene in ipairs(scenes or {}) do if not scene.kind or scene.kind == "outing" then outings[#outings + 1] = scene end end
    local i = 1
    while i <= #outings do
        local name = DungeonOf(outings[i], opts)
        if name then
            local run = {dungeon = name, scenes = {outings[i]}, between = {}}
            local left = outings[i].e or outings[i].t or 0
            local j = i + 1
            -- Out and back in: quiet stays outside, then the same dungeon within the limit.
            while true do
                local k = j
                while outings[k] and not DungeonOf(outings[k], opts) and Quiet(outings[k]) and (outings[k].e or 0) - left <= E.OUT_TOTAL do k = k + 1 end
                local back = outings[k]
                if back and DungeonOf(back, opts) == name and (back.t or 0) - left <= E.OUT_TOTAL then
                    for m = j, k - 1 do run.between[#run.between + 1] = outings[m] end
                    run.scenes[#run.scenes + 1] = back
                    left = back.e or left
                    j = k + 1
                else
                    break
                end
            end
            runs[#runs + 1] = Fill(run, scenes, opts)
            i = j
        else
            i = i + 1
        end
    end
    return runs
end


-- The episodes of a day (2026-11-11, lane E): the units a chapter is told in, one paragraph
-- each. E.Day(scenes, opts) reads JournalBook's `day.scenes` (outings in time order, after the
-- flicker and transit folds) and returns {episodes, spine}. The episodes partition the day's
-- time: every record time falls in exactly one of them (`t` to the next one's `t`), so a told
-- line with a time finds its episode. Each episode: {kind, t, e, zone, scenes, errands,
-- run (a dungeon run from E.DungeonRuns), deaths (my deaths and the party's, in order),
-- quests, levels, firsts, voyages, sleep, night (the last stay), party (names present),
-- weight, outcome (the facts the close can use)}; and, when the record has them (lane REC8,
-- 2026-11-12; nil on older journals):
--   members   everyone in the group in this part of the day, in your list or not, first come
--             first: {name, full, class, race, level, circle ("companion", "acquaintance", ...
--             when in your list), guild, friend, bnet, t, e (first and last moment inside the
--             episode), seconds, spans = {{from, to}}, significant (together ten minutes or
--             more: A.JournalMemberSignificant)}. (ep.party stays the list's names, as before.)
--   partySize the size that held longest, me among them; partyMax the most at once
--   elites, eliteSeconds, eliteNames  elite foes fought in the open (how many, seconds in
--             combat with them, the named ones); dangerous = A.JournalDangerous (six elites,
--             or ten minutes fighting them). Kinds:
--   dungeon  one run of E.DungeonRuns, from the first way in to the last way out
--   deaths   a bad stretch: two or more deaths of mine, or one of mine with three of the
--            party's, within E.DEATH_GAP of each other in one stay; the stay's work after
--            the last death stays with it (what was still carried out)
--   field    quests, kills, firsts in the open, with a lone death at most
--   journey  a stay with nothing but the going itself, towns, rests, gathering and crafting;
--            neighbouring journeys are one episode
-- An errand (a stay under E.ERRAND in another zone that comes back to the zone it left, with
-- no death, boss or first visit in it) is a clause of the episode it left from: that episode
-- keeps the errand's time, and the hand-in right after the return (within E.ERRAND_BACK).
-- The spine is the episode the record weighs most (a dungeon, a bad stretch, a chain).
E.ERRAND = 20 * 60
E.ERRAND_BACK = 3 * 60
E.DEATH_GAP = 20 * 60
E.DEATH_TAIL = 15 * 60   -- work this long after a bad stretch's last death still belongs to it

local function OwnDeath(e) return e.k == "death" and not e.boss and not e.pr and not e.pc and not e.env end
local function PartyDeath(e) return e.k == "pdeath" and e.n and not e.boss end
local function Events(scene) return scene.events or {} end
local function Duration(scene) return (scene.e or scene.t or 0) - (scene.t or 0) end

-- A stay with nothing in it but the going: no quest, no boss, no death, no dungeon.
local function IsJourney(scene)
    if (scene.questCount or 0) > 0 or #(scene.bosses or {}) > 0 then return false end
    for _, e in ipairs(Events(scene)) do
        if OwnDeath(e) or PartyDeath(e) or e.k == "boss" or e.k == "dungeon" or e.k == "bg" then return false end
    end
    return true
end
local function IsErrand(scene, before, after)
    if not before or not after or not scene.zone then return false end
    if before.zone ~= after.zone or scene.zone == before.zone then return false end
    if Duration(scene) >= E.ERRAND then return false end
    for _, e in ipairs(Events(scene)) do
        if OwnDeath(e) or PartyDeath(e) or e.k == "boss" or e.k == "dungeon" then return false end
        if e.k == "first" and (e.d == "zone" or e.d == "continent" or e.d == "dungeon") then return false end
    end
    return true
end
-- The bad stretches of one stay: clusters of deaths (mine and the party's) joined within
-- E.DEATH_GAP; a cluster counts when it holds two of mine, or one of mine and three of theirs.
local function DeathClusters(scene)
    local items = {}
    for _, e in ipairs(Events(scene)) do
        if OwnDeath(e) or PartyDeath(e) then items[#items + 1] = e end
    end
    Sort(items)
    local clusters, cur = {}, nil
    for _, e in ipairs(items) do
        if cur and (e.t or 0) - (cur.last or 0) <= E.DEATH_GAP then cur.items[#cur.items + 1] = e; cur.last = e.t or 0
        else cur = {items = {e}, first = e.t or 0, last = e.t or 0}; clusters[#clusters + 1] = cur end
    end
    local kept = {}
    for _, c in ipairs(clusters) do
        local mine, theirs = 0, 0
        for _, e in ipairs(c.items) do if OwnDeath(e) then mine = mine + 1 else theirs = theirs + 1 end end
        c.mine, c.theirs = mine, theirs
        if mine >= 2 or (mine >= 1 and theirs >= 3) then kept[#kept + 1] = c end
    end
    return kept
end

local function NewEpisode(kind, t, zone)
    return {kind = kind, t = t, e = t, zone = zone, scenes = {}, errands = {}, deaths = {}, quests = {}, levels = {}, firsts = {}, voyages = {},
        party = {}, weight = 0}
end
-- A member's time in an episode, added to the one already there (by full name).
local function AddMember(ep, m, spans)
    ep.members = ep.members or {}
    local known
    for _, other in ipairs(ep.members) do if other.full == m.full then known = other end end
    if not known then
        known = {name = m.name, full = m.full, seconds = 0, spans = {}}
        ep.members[#ep.members + 1] = known
    end
    known.class, known.race, known.level = m.class or known.class, m.race or known.race, m.level or known.level
    known.circle = m.circle or known.circle
    known.guild, known.friend, known.bnet = m.guild or known.guild, m.friend or known.friend, m.bnet or known.bnet
    for _, sp in ipairs(spans) do
        known.spans[#known.spans + 1] = {sp[1], sp[2]}
        known.seconds = known.seconds + (sp[2] - sp[1])
        known.t = math.min(known.t or sp[1], sp[1])
        known.e = math.max(known.e or sp[2], sp[2])
    end
end
local function AddElites(ep, count, seconds, names)
    ep.elites = (ep.elites or 0) + count
    ep.eliteSeconds = (ep.eliteSeconds or 0) + seconds
    for _, name in ipairs(names or {}) do
        ep.eliteNames = ep.eliteNames or {}
        local known = false
        for _, other in ipairs(ep.eliteNames) do if other == name then known = true end end
        if not known and type(name) == "string" then ep.eliteNames[#ep.eliteNames + 1] = name end
    end
end
-- What of a stay falls inside an episode's time (the episode may hold a part of a stay).
local function Gather(ep, scene, from, to)
    local seen = {}
    for _, w in ipairs(ep.party) do seen[w] = true end
    for _, w in ipairs(scene.with or {}) do
        local name = (Clean(w.name):gsub("%-.*$", ""))
        for _, span in ipairs(w.spans or {{scene.t, scene.e}}) do
            if span[1] < to and span[2] > from and name ~= "" and not seen[name] then seen[name] = true; ep.party[#ep.party + 1] = name end
        end
    end
    -- (everyone in the group in this part of the stay, and the elite foes fought: JournalBook's
    -- members and elites on the stay; the record's elites line goes where it began)
    for _, m in ipairs(scene.members or {}) do
        local clipped = {}
        for _, sp in ipairs(m.spans or {}) do
            local a, b = math.max(sp[1], from), math.min(sp[2], to)
            if b > a then clipped[#clipped + 1] = {a, b} end
        end
        if #clipped > 0 then AddMember(ep, m, clipped) end
    end
    for _, x in ipairs(scene.entries or {}) do
        if x.k == "elites" then
            local t = x.t or scene.t or 0
            if t >= from and t < to then
                AddElites(ep, tonumber(x.c) or 1, tonumber(x.s) or 0, type(x.x) == "table" and x.x or nil)
            end
        end
    end
    for _, e in ipairs(Events(scene)) do
        local t = e.t or scene.t or 0
        if t >= from and t < to then
            if OwnDeath(e) then ep.deaths[#ep.deaths + 1] = {t = t, mine = true, foe = e.d, place = e.sz, event = e}
            elseif PartyDeath(e) then ep.deaths[#ep.deaths + 1] = {t = t, name = (Clean(e.n):gsub("%-.*$", "")), event = e}
            elseif e.k == "mylevel" then ep.levels[#ep.levels + 1] = {level = tonumber(e.d) or e.d, t = t, zone = e.z}
            elseif e.k == "first" and e.d then ep.firsts[#ep.firsts + 1] = {what = e.d, t = t, z = e.z, event = e}
            elseif e.k == "voyage" then ep.voyages[#ep.voyages + 1] = {t = t, how = e.d, to = e.to}
            elseif e.k == "sleep" then ep.sleep = {t = t, place = e.d, zone = e.z or scene.zone}
            elseif e.k == "hearth" then ep.hearth = {t = t, place = e.d}
            end
        end
    end
    for _, q in ipairs(scene.quests or {}) do
        local t = q.t or scene.t or 0
        if t >= from and t < to then ep.quests[#ep.quests + 1] = {quest = q, t = t, scene = scene} end
    end
end
local function Finish(ep)
    Sort(ep.deaths); Sort(ep.quests); Sort(ep.levels); Sort(ep.firsts)
    ep.mine, ep.theirs = 0, 0
    for _, d in ipairs(ep.deaths) do if d.mine then ep.mine = ep.mine + 1 else ep.theirs = ep.theirs + 1 end end
    ep.lastDeath = ep.deaths[#ep.deaths] and ep.deaths[#ep.deaths].t or nil
    -- everyone in the group: the size that held longest (alone counted for the time no
    -- member covers), the most at once, who stayed long enough to matter
    if ep.members then
        table.sort(ep.members, function(a, b) if a.t ~= b.t then return a.t < b.t end return a.full < b.full end)
        local all = {}
        for _, m in ipairs(ep.members) do
            m.significant = m.seconds >= (A.JournalMemberSignificant or 600)
            for _, sp in ipairs(m.spans) do all[#all + 1] = sp end
        end
        if A.JournalPartySize then ep.partySize, ep.partyMax = A.JournalPartySize(all, ep.t, math.max(ep.e, ep.t)) end
    end
    if ep.elites then
        ep.dangerous = A.JournalDangerous and A.JournalDangerous(ep.elites, ep.eliteSeconds) or false
    end
    -- the weight the record gives it: what the evening was about
    local w = 0
    if ep.kind == "dungeon" then w = 100 + 5 * #(ep.run and ep.run.bosses or {}) + 10 * ep.mine
    elseif ep.kind == "deaths" then w = 30 + 10 * ep.mine + 3 * ep.theirs + 3 * #ep.quests
    elseif ep.kind == "field" then w = 10 + 4 * #ep.quests + 8 * ep.mine
    else w = 2 end
    for _, f in ipairs(ep.firsts) do
        if f.what == "continent" then w = w + 15 elseif f.what == "zone" then w = w + 6 elseif f.what == "dungeon" then w = w + 10 end
    end
    for _, q in ipairs(ep.quests) do w = w + math.min(3, (tonumber(q.quest.ql) or 0) / 10) end
    ep.weight = w
    -- the facts a close can use
    if ep.kind == "dungeon" and ep.run then
        local story = A.Lore and A.Lore.DungeonStory and A.Lore.DungeonStory(ep.run.dungeon)
        local lords = story and story.last
        if type(lords) == "string" then lords = {lords} elseif type(lords) ~= "table" then lords = {} end
        local killed, lord = false, lords[#lords]
        for _, b in ipairs(ep.run.bosses) do
            for _, name in ipairs(lords) do if Clean(b.name) == Clean(name) then killed, lord = true, name end end
        end
        ep.outcome = {kind = "dungeon", dungeon = ep.run.dungeon, lord = lord, lordKilled = killed, bosses = #ep.run.bosses}
    elseif ep.kind == "deaths" then
        local last
        for i = #ep.deaths, 1, -1 do if ep.deaths[i].mine then last = ep.deaths[i]; break end end
        if last and last.foe then ep.outcome = {kind = "deaths", foe = last.foe, place = last.place, t = last.t} end
    end
    return ep
end

function E.Day(scenes, opts)
    local outings = {}
    for _, scene in ipairs(scenes or {}) do if (not scene.kind or scene.kind == "outing") and scene.zone then outings[#outings + 1] = scene end end
    local runs = E.DungeonRuns(scenes, opts)
    local runOf = {}
    for _, run in ipairs(runs) do
        for _, s in ipairs(run.scenes) do runOf[s] = run end
        for _, s in ipairs(run.between) do runOf[s] = run end
    end
    local episodes = {}
    local i = 1
    while i <= #outings do
        local scene = outings[i]
        if runOf[scene] then
            local run = runOf[scene]
            local ep = NewEpisode("dungeon", run.entered, run.dungeon)
            ep.run = run
            local j = i
            while outings[j] and runOf[outings[j]] == run do
                ep.scenes[#ep.scenes + 1] = outings[j]
                Gather(ep, outings[j], outings[j].t or 0, (outings[j].e or outings[j].t or 0) + 1)
                j = j + 1
            end
            ep.e = run.left
            episodes[#episodes + 1] = Finish(ep)
            i = j
        elseif i > 1 and IsErrand(scene, outings[i - 1], outings[i + 1]) and episodes[#episodes] and episodes[#episodes].kind ~= "dungeon"
            and not runOf[outings[i + 1]] then
            -- an errand: a clause of the episode it left from, with the hand-in on the way back
            local ep = episodes[#episodes]
            ep.errands[#ep.errands + 1] = scene
            Gather(ep, scene, scene.t or 0, (scene.e or scene.t or 0) + 1)
            local back = outings[i + 1]
            local until_ = back.t or 0
            for _, q in ipairs(back.quests or {}) do
                if (q.t or 0) - (back.t or 0) <= E.ERRAND_BACK and (q.t or 0) >= until_ then until_ = (q.t or 0) + 1 end
            end
            if until_ > (back.t or 0) then Gather(ep, back, back.t or 0, until_); ep.backUntil = until_ end
            ep.e = math.max(ep.e, until_, scene.e or 0)
            Finish(ep)
            i = i + 1
        else
            local from = scene.t or 0
            local prev = episodes[#episodes]
            if prev and prev.backUntil and prev.backUntil > from then from = prev.backUntil end
            local stop = (scene.e or scene.t or 0) + 1
            local clusters = DeathClusters(scene)
            -- the stay, cut at its bad stretches
            local cursor = from
            for _, c in ipairs(clusters) do
                local start = cursor
                if c.first > cursor then
                    -- (what came before the deaths: its own episode only when it holds work;
                    -- a few minutes of arriving belong to the deaths)
                    local head = NewEpisode(IsJourney(scene) and "journey" or "field", cursor, scene.zone)
                    head.scenes = {scene}
                    Gather(head, scene, cursor, c.first)
                    head.e = c.first
                    if #head.quests > 0 or (c.first - cursor) >= 15 * 60 then episodes[#episodes + 1] = Finish(head); start = c.first end
                end
                local tail = math.min(stop, c.last + E.DEATH_TAIL)
                -- (work after the deaths stays with them up to the tail; a longer stay goes on as field work)
                local ep = NewEpisode("deaths", start, scene.zone)
                ep.scenes = {scene}
                Gather(ep, scene, start, tail)
                ep.e = tail
                ep.firstDeath = c.first
                episodes[#episodes + 1] = Finish(ep)
                cursor = tail
            end
            if cursor < stop and (#clusters == 0 or cursor < stop - 1) then
                local ep = NewEpisode(IsJourney(scene) and "journey" or "field", cursor, scene.zone)
                ep.scenes = {scene}
                Gather(ep, scene, cursor, stop)
                ep.e = scene.e or scene.t or 0
                if #clusters == 0 or #ep.quests > 0 or #ep.firsts > 0 or (stop - cursor) >= 15 * 60 then episodes[#episodes + 1] = Finish(ep)
                else
                    -- (a few quiet minutes after the deaths: theirs)
                    local last = episodes[#episodes]
                    if last then Gather(last, scene, cursor, stop); last.e = ep.e; Finish(last) end
                end
            end
            i = i + 1
        end
    end
    -- a run's own turn-ins and level, handed in after it, are the run's (JournalEpisodes.DungeonRuns)
    for _, ep in ipairs(episodes) do
        if ep.kind == "dungeon" and ep.run then
            local own = {}
            for _, rq in ipairs(ep.run.quests or {}) do own[rq.quest] = true end
            for _, other in ipairs(episodes) do
                if other ~= ep and other.t >= ep.t then
                    local kept = {}
                    for _, q in ipairs(other.quests) do
                        if own[q.quest] then ep.quests[#ep.quests + 1] = q else kept[#kept + 1] = q end
                    end
                    other.quests = kept
                    kept = {}
                    for _, lv in ipairs(other.levels) do
                        if ep.run.level and lv.t == ep.run.level.t then ep.levels[#ep.levels + 1] = lv else kept[#kept + 1] = lv end
                    end
                    other.levels = kept
                end
            end
            Finish(ep)
        end
    end
    for _, ep in ipairs(episodes) do Finish(ep) end
    -- (a stay whose only work was the run's hand-in is a stop on the way, not field work)
    for _, ep in ipairs(episodes) do
        if ep.kind == "field" and #ep.quests == 0 and ep.mine == 0 and ep.theirs == 0 then ep.kind = "journey" end
    end
    -- neighbouring journeys are one episode
    local merged = {}
    for _, ep in ipairs(episodes) do
        local last = merged[#merged]
        if last and last.kind == "journey" and ep.kind == "journey" then
            for _, s in ipairs(ep.scenes) do last.scenes[#last.scenes + 1] = s end
            for _, s in ipairs(ep.errands) do last.errands[#last.errands + 1] = s end
            for _, key in ipairs({"deaths", "quests", "levels", "firsts", "voyages"}) do
                for _, x in ipairs(ep[key]) do last[key][#last[key] + 1] = x end
            end
            local seen = {}
            for _, w in ipairs(last.party) do seen[w] = true end
            for _, w in ipairs(ep.party) do if not seen[w] then seen[w] = true; last.party[#last.party + 1] = w end end
            last.sleep, last.hearth = ep.sleep or last.sleep, ep.hearth or last.hearth
            for _, m in ipairs(ep.members or {}) do AddMember(last, m, m.spans) end
            if ep.elites then AddElites(last, ep.elites, ep.eliteSeconds or 0, ep.eliteNames) end
            last.e = ep.e
            Finish(last)
        else
            merged[#merged + 1] = ep
        end
    end
    episodes = merged
    -- the partition: each episode runs to the next one's start
    for n, ep in ipairs(episodes) do
        ep.index = n
        ep.until_ = episodes[n + 1] and episodes[n + 1].t or math.huge
        ep.night = n == #episodes
    end
    local spine
    for _, ep in ipairs(episodes) do if not spine or ep.weight > spine.weight then spine = ep end end
    -- the day's bearings for the close
    local first, last = outings[1], outings[#outings]
    local day = {episodes = episodes, spine = spine, t = first and first.t, e = last and (last.e or last.t), voyages = 0}
    if first then
        local at
        for _, e in ipairs(Events(first)) do
            if (e.k == "town" or e.k == "rest" or e.k == "hearth" or e.k == "home") and e.d and (not at or (e.t or 0) < at) then day.from, at = e.d, e.t or 0 end
        end
        day.fromZone = (first.entries and first.entries[1] and first.entries[1].z) or first.zone
    end
    for _, scene in ipairs(outings) do
        for _, e in ipairs(Events(scene)) do if e.k == "voyage" and e.d ~= "hearth" and e.d ~= "portal" then day.voyages = day.voyages + 1 end end
    end
    if last then
        day.endZone = last.zone
        -- (lane G8: a short stay after the last one, folded into it as a zone only crossed, is
        -- where the night ended: the stay's own time ends before the scene does. Open ground,
        -- never a dungeon or its mouth.)
        local ownEnd = 0
        for _, entry in ipairs(last.entries or {}) do
            if (entry.k == "play" or entry.k == "group") and (entry.e or 0) > ownEnd then ownEnd = entry.e end
        end
        -- (lane O8 round 31: a minute or two on the road out of the last stay is transit, not a stay; the
        -- night ended in the last outing's own zone unless the crossing held five minutes or more)
        if ownEnd > 0 and (last.e or 0) >= ownEnd + 300 then
            local known = (opts and opts.isDungeon) or (A.Lore and A.Lore.Dungeon)
            for _, z in ipairs(last.crossed or {}) do
                local plain, here = Clean(z), Clean(last.zone)
                local mouth = (known and known(plain)) or (A.SelfUnderground and A.SelfUnderground(plain))
                    or plain:find(here, 1, true) or here:find(plain, 1, true)
                if not mouth then day.endZone = z; day.endCrossed = true end
            end
        end
        for _, e in ipairs(Events(last)) do
            if e.k == "sleep" and e.d then day.sleep = {place = e.d, zone = e.z or last.zone, t = e.t} end
            -- (a town of the stay the night did not end in is not where it ended)
            if e.k == "town" and e.d and not day.endCrossed then day.endTown = e.d end
        end
    end
    return day
end

return E
