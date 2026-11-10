local _, A = ...
-- The style pass of the planned telling of your own book (Settings > Testing > Storyteller:
-- Planned). JournalSelfPlan.lua decides WHAT is told and in what order and hands over `seq`,
-- one entry a sentence group; this file decides HOW it reads: where a paragraph ends, how a
-- sentence opens, how long it runs, what air a peak gets. It states no new fact and drops
-- none: it moves a sentence's own words, splits a long sentence where both halves stand,
-- shortens a place named a moment ago, and chooses where paragraphs end. A change is made
-- only where its pattern is certain; a sentence that does not fit one is left as written.
-- No random draw (a choice is by a hash of env.seed).
--
-- seq entry: text, sit (sitting number), kind (the line's kind: "questStart", "questOutcome",
-- "quests", "death", "rest", "move", "first", "lore", "gather", "craft", "level", "open", "" ...),
-- it (the planner's item: it.m meta tags, it.t time, it.scene, it.fold ...), and flags:
-- turn (the purpose turns here), glue (stays with the line before), felt (a feeling, its
-- kind), work (a line of routine work), clock (opens on the hour), scene, level, chain (the
-- key of the chain a step belongs to), and from the planner's ranking: peak (the kind of
-- peak), setup, side, close.
-- An entry marked dropped = true is not printed. Returns the list of paragraphs.
--
-- The rules, in the order they run:
--   S5  nothing twice: a line the chapter already told, the hour aside, is dropped;
--   S6  a feeling never follows another feeling and never ends the chapter;
--   S3  a sentence over 24 words is split at ", then", ", and" or a semicolon;
--   S1  paragraphs by sense: 2 to 4 sentences, 25 to 55 words, a peak alone with its own lines;
--   S7  a feeling closes its paragraph, peak or not;
--   S8  one's own level line (flag level, or kind "level") never stands with a peak, a death
--       or a feeling: it opens or joins the next plain paragraph. With none before the next peak it ends
--       the after-word of its own scene (the lines told after that scene's feeling), or
--       stands alone (the companion's level straight after a death stays);
--   S9  entries of one `chain` stay in one paragraph while 60 words and 4 sentences allow;
--   S12 one sentence alone only for a death, a peak or the close: a plain one joins a
--       neighbour, borrows the last line of the paragraph before, or leads into the peak after;
--   S2  openers: under one sentence in three on bare "We"/"I", never three alike in a row;
--   S11 a person's title once a chapter ("Executor Zygand", then "Zygand");
--   S4, S10  a place's full name once a chapter, then "the keep", "the tavern", "the city".
local S = {}
A.SelfStyle = S

local function Plain(text) return (tostring(text or ""):gsub("{%a:([^}]*)}", "%1")) end
local function WordCount(text) local n = 0; for _ in Plain(text):gmatch("%S+") do n = n + 1 end; return n end
local function Hash(text)
    local h = 5381
    for i = 1, #text do h = (h * 33 + text:byte(i)) % 2147483647 end
    return h
end
local function Set(words) local t = {}; for word in words:gmatch("%S+") do t[word] = true end; return t end
-- Markup keeps its spaces out of reach while words move: "{p:Gallows' End Tavern}" is one token.
local function Guard(text) return (text:gsub("{%a:[^}]*}", function(mark) return (mark:gsub(" ", "\1")) end)) end
local function Unguard(text) return (text:gsub("\1", " ")) end
local function Tokens(text) local list = {}; for token in text:gmatch("%S+") do list[#list + 1] = token end; return list end
-- (a token as read: markup off, its inner spaces back)
local function Read(token) return Unguard(Plain(token)) end
local function Cap(text)
    if text:find("^{%a:") then return text end
    return (text:gsub("^%l", string.upper))
end
local function Quoted(text) return text:find('"', 1, true) ~= nil or text:find("\226\128\156", 1, true) ~= nil end

-- The sentences of a line. A line that quotes speech is left whole.
local ABBREV = Set("Mr Mrs Ms Dr St Sgt Lt Capt Col Gen Jr Sr")
local function Sentences(text)
    if Quoted(text) then return {text} end
    local list, from, pos = {}, 1, 1
    while true do
        local s, e = text:find("[%.!]%s+", pos)
        if not s then break end
        local after = text:sub(e + 1, e + 1)
        local before = text:sub(from, s - 1):match("([%w']+)$") or ""
        local initial = before:find("^%u$") and before ~= "I"
        if (after:find("[%u%d]") or after == "{") and not ABBREV[before] and not initial then
            list[#list + 1] = text:sub(from, s)
            from = e + 1
        end
        pos = e + 1
    end
    if from <= #text then list[#list + 1] = text:sub(from) end
    return list
end
S.Sentences = Sentences

-- What a sentence says, for telling a repeat: plain, the hour it opens on aside.
local function Told(sentence, clock)
    local plain = Plain(sentence):gsub("[%.!]+%s*$", "")
    if clock then
        local lead, rest = plain:match("^([^,]+), (.+)$")
        if lead and WordCount(lead) <= 5 then plain = rest end
    end
    return (plain:gsub("^%u", string.lower))
end

-- S5. Nothing twice: an entry whose every sentence the chapter has told already is dropped.
-- A death is a fact each time and stays, and so does a peak.
local function DropRepeats(seq)
    local told = {}
    for _, entry in ipairs(seq) do
        if not entry.dropped then
            local keys, fresh = {}, false
            for i, sentence in ipairs(Sentences(entry.text)) do
                keys[i] = Told(sentence, entry.clock and i == 1)
                if not told[keys[i]] then fresh = true end
            end
            if not fresh and #keys > 0 and entry.kind ~= "death" and not entry.peak then
                entry.dropped = true
            else
                for _, key in ipairs(keys) do told[key] = true end
            end
        end
    end
end

-- S6. A feeling never follows another feeling, and never ends the chapter. The line of a
-- first death is half fact ("It was my first death since I rose, ...") and is kept.
local function PlaceFeelings(seq)
    local last
    for _, entry in ipairs(seq) do
        if not entry.dropped then
            if entry.felt and last and last.felt then
                if entry.felt == "deathFirst" and last.felt ~= "deathFirst" then last.dropped = true else entry.dropped = true end
            end
            if not entry.dropped then last = entry end
        end
    end
    for i = #seq, 1, -1 do
        local entry = seq[i]
        if not entry.dropped then
            if entry.felt and entry.felt ~= "deathFirst" then entry.dropped = true else break end
        end
    end
end

-- Words the rules lean on. A verb form the lists do not know is "not certain", and the
-- sentence is left as written.
local PAST = Set("went came took brought found fought slew met left gave made rode ran saw heard sat slept ate drank "
    .. "bought sold cut dug fed led lit lost paid put read sent set stood stole swam taught told threw won wrote burnt "
    .. "built kept caught drove fell flew got held hid laid spoke spent struck swept tore woke did had was were began "
    .. "broke chose drew felt grew hung knelt knew lay rose sang sank shot shut slid stuck swore thought wore wept")
local NOTVERB = Set("red bed hundred sacred wicked naked rugged ragged crooked wretched aged blessed indeed need seed "
    .. "speed breed deed weed steed creed shed sled")
local function PastVerb(word)
    word = (word or ""):gsub("%p+$", "")
    if PAST[word] then return true end
    return word:find("^%l%l+ed$") ~= nil and not NOTVERB[word]
end
local PRONOUN = Set("I we he she they it")
-- (a clause that leans on another, or reports what someone said or thought: its halves do
-- not stand alone as plain statements)
local LEANS = Set("that who whom whose which where when while because until unless though although if whether since "
    .. "as so before after once said told asked warned claimed believed thought swore promised hoped feared wanted "
    .. "wished expected explained wondered says tells asks wants hopes")
local function Leans(tokens, from, to)
    for i = from, to do
        local word = Read(tokens[i]):gsub("%p+$", ""):lower()
        if LEANS[word] then return true end
    end
    return false
end
local function Join(tokens, from, to) return table.concat(tokens, " ", from, to) end
local function FirstWord(sentence) return (Read(sentence):match("^[%w']+")) or "" end
S.FirstWord = FirstWord

-- The subject a sentence stands on when it opens "We ..." / "I ...", or on a short lead and
-- a comma ("Past midnight, I ...", "For Sarvis, we ..."): returns "we" or "I", else nil.
local function OpenSubject(tokens)
    local first = Read(tokens[1])
    if first == "We" then return "we" elseif first == "I" then return "I" end
    for i = 1, math.min(6, #tokens - 1) do
        if tokens[i]:find(",$") then
            local nextWord = Read(tokens[i + 1])
            if nextWord == "we" or nextWord == "I" then return nextWord end
            return nil
        end
    end
    return nil
end

-- S3. One split of a sentence at ", then", at ", and" or at a semicolon, where both halves
-- stand as sentences. Returns the two halves, the second marked `thenSplit` when it now
-- opens on "Then"; nil when no join is certain. `allowThen` is false when a sentence
-- nearby already opens on "Then" (once a paragraph); `thenOnly` takes no other join.
local MINHALF = 4
local function SplitOnce(sentence, allowThen, thenOnly)
    local tokens = Tokens(sentence)
    local n = #tokens
    local best, bestGap
    for i = MINHALF, n - MINHALF do
        local token = tokens[i]
        local nextWord, after = Read(tokens[i + 1]), Read(tokens[i + 2] or "")
        local first, second, isThen
        if token:find(",$") and nextWord == "then" and allowThen then
            -- "We did A, then did B." -> "We did A. Then we did B."
            local subject = OpenSubject(tokens)
            if subject and PastVerb(after) and n - (i + 1) >= MINHALF - 1 and not Leans(tokens, 1, i) then
                first = Join(tokens, 1, i):gsub(",$", ".")
                second, isThen = "Then " .. subject .. " " .. Join(tokens, i + 2, n), true
            end
        elseif not thenOnly and ((token:find(",$") and nextWord == "and") or token:find(";$")) then
            -- "..., and she sent me on." -> "... She sent me on."
            local s = token:find(";$") and i + 1 or i + 2
            local subject, verb = Read(tokens[s] or ""), Read(tokens[s + 1] or "")
            local opens = Read(tokens[1])
            if PRONOUN[subject] and PastVerb(verb) and n - s + 1 >= MINHALF and not Leans(tokens, 1, i)
                and (PRONOUN[opens:lower()] or opens == "The" or opens == "A" or opens == "An") and not tokens[s]:find("^{") then
                first = Join(tokens, 1, i):gsub("[,;]$", ".")
                second = Cap(Join(tokens, s, n))
            end
        end
        if first then
            -- (the join nearest the middle)
            local gap = math.abs(i - (n - i))
            if not best or gap < bestGap then best, bestGap = {first, second, isThen}, gap end
        end
    end
    if best then return best[1], best[2], best[3] end
    return nil
end

-- (S3 over a list of sentence records: a sentence over 24 words is split, and a half still
-- over 24 once more)
local LONG = 24
local function SplitLong(list)
    local out, lastThen = {}, -10
    local function Add(record)
        out[#out + 1] = record
        if FirstWord(record.text) == "Then" then lastThen = #out end
    end
    local function Try(record, depth)
        if record.fixed or WordCount(record.text) <= LONG or depth > 2 then Add(record); return end
        local first, second = SplitOnce(record.text, #out + 1 - lastThen >= 5)
        if not first then Add(record); return end
        Try({text = first, entry = record.entry, fixed = record.fixed}, depth + 1)
        Try({text = second, entry = record.entry, fixed = record.fixed, made = true}, depth + 1)
    end
    for _, record in ipairs(list) do Try(record, 1) end
    return out
end

-- S1. Paragraphs by sense.
local PARA_MAX, PARA_MIN, PARA_FULL, SENT_MAX = 60, 25, 55, 4
-- (a level line: one the planner set into the telling, or the chapter's own at its end. It is
-- never a peak, whatever it was drawn from)
local function Level(entry) return entry.level or entry.kind == "level" or nil end
local function Peak(entry)
    if Level(entry) then return nil end
    return entry.peak or (entry.it and entry.it.peak) or entry.felt or nil
end
local function Close(entry) return entry.close or (entry.it and entry.it.m and entry.it.m.close) or nil end
-- (a line that points back at the one before it, and cannot open a paragraph)
local BACK = Set("There Then It He She They His Her Their That This These Those One")
local function Bound(entry)
    if Level(entry) then return true end
    local plain = Plain(entry.text)
    return BACK[plain:match("^[%a']+") or ""] or plain:find(" there%.$") ~= nil
end
local KILLER = Set("He She They It His Her Their Its")
-- (two lines drawn from the same thing that happened)
local function SameEvent(a, b)
    local x, y = a.it, b.it
    if not x or not y then return false end
    if x == y then return true end
    return x.m ~= nil and y.m ~= nil and x.m.e ~= nil and x.m.e == y.m.e
end
-- (a level line about the companion alone: "Dahlia made level 13 a minute later.")
local OWN = Set("I We we me us my My our Our")
local function Companions(entry)
    for word in Plain(entry.text):gmatch("[%a']+") do
        if OWN[word] then return false end
    end
    return true
end
local function Measure(entry)
    local words = 0
    for _, record in ipairs(entry.recs) do words = words + WordCount(record.text) end
    return words, #entry.recs
end

-- (the lines that stand together: a line and the `glue` lines after it. S7: a feeling closes
-- its group, so nothing is told after it; a line of the same scene that leans back on it
-- ("He was only a scorpid, ...") is set before the feeling instead. S8: one's own level line
-- never stands with a peak, a death or a feeling: it waits as a group of its own for the
-- next plain paragraph. A peak keeps its own lines only, three sentences at most.)
local function Groups(kept)
    local groups, current, waiting = {}, nil, nil
    local function Open(entry, level)
        current = {entries = {}, sit = entry.sit, clock = entry.clock, turn = entry.turn, words = 0, sents = 0,
            close = Close(entry) and true or nil, chain = entry.chain, level = level}
        groups[#groups + 1] = current
    end
    local function Add(group, entry, at)
        local words, sents = Measure(entry)
        if at then table.insert(group.entries, at, entry) else group.entries[#group.entries + 1] = entry end
        group.words, group.sents = group.words + words, group.sents + sents
        if entry.kind == "death" and not Level(entry) then group.death = true end
        if not Level(entry) then group.level = nil end
    end
    -- (a level line that stepped aside is told once the scene it met is over)
    local function Settle()
        if waiting then
            local list = waiting
            waiting = nil
            Open(list[1], true)
            for _, entry in ipairs(list) do Add(current, entry) end
        end
    end
    local function Wait(entry)
        waiting = waiting or {}
        waiting[#waiting + 1] = entry
    end
    for index, entry in ipairs(kept) do
        local nextEntry = kept[index + 1]
        local words, sents = Measure(entry)
        local level = Level(entry)
        local peak = Peak(entry)
            or (not level and nextEntry and nextEntry.felt and nextEntry.sit == entry.sit) or nil
        local same = current ~= nil and current.sit == entry.sit and not current.close
        local last = current and current.entries[#current.entries]
        if same and current.felt then
            -- S7. Only a line of this same scene that cannot stand without it goes before the feeling.
            local killer = current.death and entry.kind == "lore" and KILLER[Plain(entry.text):match("^%a+") or ""]
            local scene = killer or (entry.it ~= nil and SameEvent(entry, current.entries[1]))
            local leans = (entry.kind == "lore" or Bound(entry)) and not level and not entry.work and not entry.felt
            if level then
                Wait(entry)
            elseif scene and leans and not Close(entry) and current.sents + sents <= SENT_MAX
                and current.words + words <= PARA_MAX then
                Add(current, entry, #current.entries)
            else
                Settle()
                Open(entry, level and true or nil)
                Add(current, entry)
                if peak then current.peak = true end
                if entry.felt then current.felt = true end
            end
        elseif same and entry.felt then
            -- (a feeling never answers a level line: that line steps aside and follows it)
            if Level(last) and #current.entries > 1 and not (current.death and Companions(last)) then
                local moved = table.remove(current.entries)
                local w, s = Measure(moved)
                current.words, current.sents = current.words - w, current.sents - s
                Wait(moved)
            end
            Add(current, entry)
            current.peak, current.felt = true, true
        elseif same and level then
            -- S8. (the companion's level straight after a death is part of that death)
            if current.death and last.kind == "death" and not Level(last) and Companions(entry) then
                Add(current, entry)
            elseif current.peak or current.death then
                Wait(entry)
            elseif current.level or not entry.glue then
                Settle()
                Open(entry, true)
                Add(current, entry)
            else
                Add(current, entry)
            end
        else
            local attach = same
            if attach then
                local own = entry.it ~= nil and entry.it == last.it
                -- ("He was only a scorpid, ...": a word on the killer stays with the death)
                local killer = current.death and entry.kind == "lore" and KILLER[Plain(entry.text):match("^%a+") or ""]
                -- ("The Dark Lady ruled the Forsaken, ...": what is known of the one just met, the
                -- place just reached, stays with the meeting or the arrival it was drawn for)
                local known = entry.kind == "lore" and SameEvent(entry, last)
                if current.level then attach = false
                elseif (killer or known) and current.sents + sents <= SENT_MAX then attach = true
                elseif Close(entry) or not entry.glue then attach = false
                elseif own or Bound(entry) then attach = true
                elseif current.peak or peak then attach = current.sents + sents <= 3
                else attach = current.words + words <= PARA_MAX and current.sents + sents <= SENT_MAX end
            end
            if not attach then
                Settle()
                Open(entry)
            end
            Add(current, entry)
            if peak then current.peak = true end
            if entry.felt then current.felt = true end
        end
    end
    Settle()
    return groups
end

local function Recount(para)
    local words, sents, peak, close, level = 0, 0, nil, nil, true
    for _, group in ipairs(para.groups) do
        words, sents = words + group.words, sents + group.sents
        peak, close = peak or group.peak, close or group.close
        if not group.level then level = nil end
    end
    local first, last = para.groups[1], para.groups[#para.groups]
    para.words, para.sents, para.peak, para.close, para.level = words, sents, peak, close, level
    para.sit, para.clock, para.turn, para.felt = first.sit, first.clock, first.turn, last.felt
    para.death = first.death
    return para
end
local function Fits(a, b, sentMax)
    return a.sit == b.sit and a.words + b.words <= PARA_MAX and a.sents + b.sents <= (sentMax or SENT_MAX)
end
local function Absorb(into, from, front)
    for i, group in ipairs(from.groups) do
        if front then table.insert(into.groups, i, group) else into.groups[#into.groups + 1] = group end
    end
    Recount(into)
end
-- (S9: two groups of one chain, as the planner marked them)
local function Chained(a, b) return a ~= nil and b ~= nil and a.chain ~= nil and a.chain == b.chain end

-- (the paragraphs: a new one for a new sitting, a new purpose, a told hour and every peak,
-- and always after a feeling; the steps of one chain stay together while the size allows;
-- then a paragraph too small to stand joins a neighbour of the same sitting)
local function Paragraphs(groups)
    local paras, current = {}, nil
    local function Start(list)
        current = Recount({groups = list})
        paras[#paras + 1] = current
    end
    for _, group in ipairs(groups) do
        local last = current and current.groups[#current.groups]
        local new
        if not current or current.sit ~= group.sit then new = true
        elseif current.felt then new = true
        elseif group.level and current.peak then new = true
        elseif Chained(last, group) and not current.death and not group.death then
            new = not Fits(current, group)
            if new then
                -- (no room: the break falls before this chain's first step, not inside the chain)
                local from = #current.groups
                while from > 1 and Chained(current.groups[from - 1], group) do from = from - 1 end
                local run = {groups = {}}
                for k = from, #current.groups do run.groups[#run.groups + 1] = current.groups[k] end
                Recount(run)
                if from > 1 and Fits(run, group) then
                    for _ = from, #current.groups do table.remove(current.groups) end
                    Recount(current)
                    Start(run.groups)
                    new = false
                end
            end
        elseif group.peak or current.peak then new = true
        elseif not Fits(current, group) then new = true
        elseif group.close then new = false
        elseif group.clock then new = current.words >= 20 or current.sents >= 2
        elseif group.turn then new = current.words >= PARA_MIN and current.sents >= 2
        else new = current.words + group.words > PARA_FULL and current.words >= PARA_MIN end
        if new then
            Start({group})
        else
            current.groups[#current.groups + 1] = group
            Recount(current)
        end
    end
    -- too small to stand: one sentence, or under 25 words. (S12: a death, a peak and the close
    -- may stand as one sentence; any other joins a neighbour.)
    local function Small(para) return not para.peak and (para.sents < 2 or para.words < PARA_MIN) end
    local function Plainly(para) return para and not para.peak end
    local changed = true
    while changed do
        changed = false
        for i, para in ipairs(paras) do
            if Small(para) and not (para.close and para.sents == 1 and paras[i - 1] and paras[i - 1].peak) then
                local before, after = paras[i - 1], paras[i + 1]
                local back = Plainly(before) and not before.felt and not before.close and Fits(before, para)
                local forward = Plainly(after) and (para.level or not after.close) and Fits(para, after)
                local first, final = para.groups[1], para.groups[#para.groups]
                local chainBack = back and Chained(before.groups[#before.groups], first)
                local chainOn = forward and Chained(final, after.groups[1])
                -- (a step goes to the rest of its chain; a turn or a told hour opens what
                -- follows; anything else closes what came before)
                if chainBack and not chainOn then
                    Absorb(before, para); table.remove(paras, i); changed = true; break
                elseif chainOn and not chainBack then
                    Absorb(after, para, true); table.remove(paras, i); changed = true; break
                elseif forward and (para.turn or para.clock or para.level or not back) and not after.clock then
                    Absorb(after, para, true); table.remove(paras, i); changed = true; break
                elseif back and not para.clock then
                    Absorb(before, para); table.remove(paras, i); changed = true; break
                elseif forward then
                    Absorb(after, para, true); table.remove(paras, i); changed = true; break
                elseif back then
                    Absorb(before, para); table.remove(paras, i); changed = true; break
                end
                local lent = Plainly(before) and before.sit == para.sit and not before.felt and not para.clock
                    and para.sents < 2 and #before.groups >= 2 and before.groups[#before.groups]
                if lent and not Bound(lent.entries[1]) and before.sents - lent.sents >= 2 and before.words - lent.words >= PARA_MIN and not lent.close
                    and para.words + lent.words <= PARA_MAX and para.sents + lent.sents <= SENT_MAX
                    and (Chained(lent, first) or not Chained(before.groups[#before.groups - 1], lent)) then
                    -- (no neighbour can take it whole: the paragraph before lends its last line)
                    table.remove(before.groups)
                    table.insert(para.groups, 1, lent)
                    Recount(before); Recount(para)
                    changed = true; break
                end
                -- (S12, the last way out for one plain sentence shut in before a peak: it leads
                -- into that scene, a death too. Never a level line.)
                if para.sents == 1 and not para.level and not para.close and after and after.peak
                    and Fits(para, after) then
                    Absorb(after, para, true); table.remove(paras, i); changed = true; break
                end
                -- (S8 meets S12: a level line shut in between two peaks. When the paragraph
                -- before is only the after-word of the scene the level came from, the lines
                -- told after that scene's feeling, the level line ends it. Otherwise it
                -- stands alone.)
                local scene = paras[i - 2]
                if para.level and para.sents == 1 and before and before.peak and not before.felt and not before.death
                    and scene and scene.felt and Fits(before, para)
                    and SameEvent(first.entries[1], before.groups[1].entries[1])
                    and SameEvent(before.groups[1].entries[1], scene.groups[#scene.groups].entries[1]) then
                    Absorb(before, para); table.remove(paras, i); changed = true; break
                end
            end
        end
    end
    return paras
end

-- S2. Openers. A sentence may open on its own closing place ("We fought the Scarlet
-- warriors at the tower." -> "At the tower we fought the Scarlet warriors."), or on "There"
-- when the sentence before named that place. Only one shape of sentence is certain enough
-- to turn round: "We/I" + a verb of plain doing + what was done + where, one clause, no
-- comma and no joined second act. Verbs of going and carrying are left out: with them the
-- closing place is where one went, not where the thing was done.
local DOING = Set("killed slew fought destroyed burned cut hunted cleared thinned freed rescued healed found met "
    .. "gathered collected picked mined fished cooked skinned searched defeated stole fed learned buried culled "
    .. "slaughtered cleansed tamed caught trained practised practiced helped saved avenged tested smashed broke "
    .. "lit doused planted harvested looted robbed ambushed felled routed scattered")
local PLACEPREP = Set("in at by near outside inside past beyond among under along on around behind below above")
-- (before a bare name only these are plainly "where": "in Brill", "at Deathknell")
local NAMEPREP = Set("in at near outside inside past beyond")
local PLACENOUN = Set("tower farm farmstead mill mills village town city cellar camp keep tavern inn road hills hill "
    .. "chapel crypt gate gates lake island isle isles mine cave caves forest woods bridge ruins waystation forge "
    .. "graveyard cemetery church fields field orchard shore coast river crossroads valley pass camps farms towers "
    .. "barracks docks harbor harbour bank square quarter market stables bulwark monastery abbey garden gardens "
    .. "swamp marsh beach cliffs canyon oasis outpost post hold fort fortress castle temple shrine den lair hollow "
    .. "glade grove well windmill sewers tunnels mountains mountain farmlands")
local BLOCK = Set("and then but or who whom whose which that where when while as because until before after so if "
    .. "for not never only also still again how what why")
-- ("to" may lead to a person or a thing, "to a captive zealot", never to a verb)
local AFTER_TO = Set("a an the his her their our my its")
local TIMES = {"that night", "that evening", "that morning", "that afternoon", "that day", "at dawn", "at dusk",
    "at noon", "at midnight", "at nightfall", "before dawn", "after dark", "past midnight", "by nightfall", "by morning"}

local function Word(token) return (Read(token):gsub("%p+$", "")) end
local function Capital(token) return Read(token):find("^%u") ~= nil end

-- Where the closing place phrase of a sentence starts and ends: one or two "where" phrases
-- ("at the tower past the Solliden Farmstead"), seven words at most, then nothing but an
-- optional "for <Name>". Returns from, to (token indexes), or nil.
local function PlaceTail(tokens)
    local n = #tokens
    local stop = n
    -- (an optional "for Zygand" behind the place)
    for i = n - 1, math.max(n - 3, 5), -1 do
        if Read(tokens[i]) == "for" then
            local names = true
            for k = i + 1, n do if not Capital(tokens[k]) then names = false end end
            if names then stop = i - 1 end
            break
        end
    end
    for from = 4, stop - 1 do
        if PLACEPREP[Read(tokens[from])] then
            local ok, words, i, parts = true, 0, from, 0
            while i <= stop and ok do
                -- one phrase: the preposition, "the", then words up to the next preposition or the end
                local prep = Read(tokens[i])
                local k = i + 1
                if tokens[k] and k <= stop and Read(tokens[k]) == "the" then k = k + 1 end
                local first, last, named = k, k, true
                while last <= stop and not PLACEPREP[Read(tokens[last])] do
                    local word = Read(tokens[last])
                    if not Capital(tokens[last]) then named = false end
                    if BLOCK[word:lower()] then ok = false end
                    if last < stop and word:find("%p$") then ok = false end
                    for _ in word:gmatch("%S+") do words = words + 1 end
                    last = last + 1
                end
                last = last - 1
                if last < first then ok = false; break end
                local head = Word(tokens[last]):lower()
                if not (PLACENOUN[head] or (named and NAMEPREP[prep])) then ok = false end
                words, parts, i = words + (k - i), parts + 1, last + 1
            end
            if ok and parts <= 2 and words <= 7 then return from, stop end
            return nil
        end
    end
    return nil
end

-- (the one certain shape: "We/I" + doing verb + what was done, no comma, no second clause)
local function Simple(tokens, upto)
    local subject = Read(tokens[1])
    if subject ~= "We" and subject ~= "I" then return nil end
    if not DOING[Read(tokens[2])] or upto < 3 then return nil end
    for i = 2, upto do
        local word = Read(tokens[i])
        if BLOCK[word:lower()] or word:find("[,;:]") then return nil end
        if word == "to" and not (i < upto and (AFTER_TO[Read(tokens[i + 1])] or Capital(tokens[i + 1]))) then return nil end
    end
    return subject == "We" and "we" or "I"
end
local function EndStop(tokens, n) return tokens[n]:match("[%.!]$") or "." end
local function Strip(token) return (token:gsub("[%.!]$", "")) end

-- "We fought the Scarlet warriors at the tower for Zygand." -> "At the tower we fought the
-- Scarlet warriors for Zygand." Returns the new sentence, or nil when the shape is not certain.
local function Front(sentence)
    local tokens = Tokens(sentence)
    local n = #tokens
    if n < 5 or n > LONG then return nil end
    -- a closing time ("... that night.")
    local plain = Read(sentence):lower()
    for _, phrase in ipairs(TIMES) do
        local count = WordCount(phrase)
        if plain:sub(-#phrase - 2, -2) == " " .. phrase and n - count >= 3 then
            local subject = Simple(tokens, n - count)
            if not subject then return nil end
            return Cap(phrase) .. " " .. subject .. " " .. Join(tokens, 2, n - count) .. EndStop(tokens, n)
        end
    end
    local from, to = PlaceTail(tokens)
    if not from then return nil end
    local subject = Simple(tokens, from - 1)
    if not subject then return nil end
    local stop = EndStop(tokens, n)
    tokens[n] = Strip(tokens[n])
    local out = Cap(Join(tokens, from, to)) .. " " .. subject .. " " .. Join(tokens, 2, from - 1)
    if to < n then out = out .. " " .. Join(tokens, to + 1, n) end
    return out .. stop
end
-- (for the tests: the same on a sentence as written, markup and all)
local function Whole(turn)
    return function(sentence, before)
        local out = turn(Guard(sentence), before and Guard(before))
        return out and Unguard(out)
    end
end
S.Front = Whole(Front)

-- "We came to Brill. We stole pumpkins in Brill." -> "... There we stole pumpkins." Only
-- when the closing place is one bare name and the sentence before holds that very name.
local function ThereOpen(sentence, before)
    local tokens = Tokens(sentence)
    local n = #tokens
    if n < 5 or not before then return nil end
    local from, to = PlaceTail(tokens)
    if not from or to ~= n then return nil end
    local prep = Read(tokens[from])
    if prep ~= "in" and prep ~= "at" then return nil end
    local k = from + 1
    if Read(tokens[k]) == "the" then k = k + 1 end
    for i = k, n do if not Capital(tokens[i]) then return nil end end
    local name = Strip(Read(Join(tokens, k, n)))
    if #name < 3 or not Read(before):find(name, 1, true) then return nil end
    local subject = Simple(tokens, from - 1)
    if not subject then return nil end
    return "There " .. subject .. " " .. Join(tokens, 2, from - 1) .. EndStop(tokens, n)
end
S.ThereOpen = Whole(ThereOpen)

-- "I rode the lift down into the Undercity for the first time, and found ..." -> "For the
-- first time, I rode the lift down into the Undercity, and found ...". The phrase closes the
-- first clause and says how long or how new; it moves to the front as it stands.
local LEADS = {{"for", "the", "first", "time"}, {"for", "a", "while"}, {"for", "a", "time"}}
local function Lead(sentence)
    local tokens = Tokens(sentence)
    local n = #tokens
    local subject = Read(tokens[1])
    if subject ~= "We" and subject ~= "I" then return nil end
    for k = 3, n do
        if k > 3 and tokens[k - 1]:find("[,;:]$") then return nil end
        for _, phrase in ipairs(LEADS) do
            local last = k + #phrase - 1
            local match = last <= n
            for w = 1, #phrase do
                if match and Read(tokens[k + w - 1]):gsub("[%.,!]$", "") ~= phrase[w] then match = false end
            end
            local stop = match and tokens[last]:match("[%.,!]$")
            if stop then
                local out = "For " .. Join(phrase, 2, #phrase) .. (phrase[3] == "first" and ", " or " ")
                    .. (subject == "We" and "we" or "I") .. " " .. Join(tokens, 2, k - 1) .. stop
                if last < n then out = out .. " " .. Join(tokens, last + 1, n) end
                return out
            end
        end
    end
    return nil
end
S.Lead = Whole(Lead)

local function Bare(record) local word = FirstWord(record.text); return word == "We" or word == "I" end
-- (lines whose wording is the point are never reshaped: an authored scene, a feeling, the
-- level, the first line of the book, the close, anything quoted, a half made by a split)
local function Free(record)
    local entry = record.entry
    return not (record.fixed or record.made or record.turned or entry.scene or entry.felt or entry.level
        or entry.kind == "origin" or Close(entry))
end
local function Same(a, b) return a and b and a.para == b.para end

-- One sentence opens another way: on "There", on its own closing place, on its own "for a
-- while". One a paragraph, and never onto the word a neighbour opens on.
local function Turn(list, i, state)
    local record = list[i]
    if not record or not Free(record) or state.turned[record.para] then return false end
    local before, after = list[i - 1], list[i + 1]
    local near = Same(before, record) and before or nil
    local new = near and FirstWord(near.text) ~= "There" and ThereOpen(record.text, near.text)
    new = new or Front(record.text) or Lead(record.text)
    if not new then return false end
    local first = FirstWord(new)
    if (before and FirstWord(before.text) == first) or (after and FirstWord(after.text) == first) then return false end
    record.text, record.turned = new, true
    state.turned[record.para] = true
    return true
end

-- "We did A, then did B." becomes "We did A. Then we did B.": "Then" from a join the line
-- already held, once a paragraph and three times a chapter at most, and only while the
-- paragraph stays at four sentences.
local THEN_MAX = 3
local function ThenSplit(list, i, state)
    local record = list[i]
    if not record or not Free(record) or state.thenIn[record.para] or (state.sents[record.para] or 0) >= SENT_MAX
        or state.thens >= THEN_MAX then
        return false
    end
    local first, second, isThen = SplitOnce(record.text, true, true)
    if not isThen then return false end
    record.text = first
    table.insert(list, i + 1, {text = second, entry = record.entry, para = record.para, made = true})
    state.thenIn[record.para] = true
    state.sents[record.para] = state.sents[record.para] + 1
    state.thens = state.thens + 1
    return true
end

-- (S2 over the chapter: `list` is every sentence in order, each with its paragraph number)
local function Openers(list, seed, paras)
    local state = {turned = {}, thenIn = {}, sents = {}, thens = 0}
    for _, record in ipairs(list) do
        state.sents[record.para] = (state.sents[record.para] or 0) + 1
        if FirstWord(record.text) == "Then" then state.thenIn[record.para], state.thens = true, state.thens + 1 end
    end
    local function Opens(i) return list[i] and FirstWord(list[i].text) or "" end
    -- a paragraph of one sentence that is no peak and no close: two sentences where it holds a ", then"
    for index = #list, 1, -1 do
        local para = paras[list[index].para]
        if state.sents[list[index].para] == 1 and not para.peak and not para.close then ThenSplit(list, index, state) end
    end
    -- never three in a row on the same word
    local i = 3
    while list[i] do
        local word = Opens(i)
        if word ~= "" and word == Opens(i - 1) and word == Opens(i - 2) then
            local _ = Turn(list, i - 1, state) or Turn(list, i, state) or Turn(list, i - 2, state)
                or ThenSplit(list, i - 1, state) or ThenSplit(list, i - 2, state)
        end
        i = i + 1
    end
    -- two in a row on "We" or on "I" inside a paragraph
    i = 2
    while list[i] do
        if Bare(list[i]) and Same(list[i - 1], list[i]) and Opens(i) == Opens(i - 1) then
            local _ = Turn(list, i, state) or Turn(list, i - 1, state) or ThenSplit(list, i - 1, state)
        end
        i = i + 1
    end
    -- under one in three on bare "We"/"I", in an order drawn from the seed
    local function Over()
        local bare = 0
        for _, record in ipairs(list) do if Bare(record) then bare = bare + 1 end end
        return bare * 3 >= #list
    end
    if not Over() then return end
    local order = {}
    for index, record in ipairs(list) do
        if Bare(record) then order[#order + 1] = {record = record, at = index, rank = Hash(seed .. ":" .. index)} end
    end
    table.sort(order, function(a, b) if a.rank ~= b.rank then return a.rank < b.rank end; return a.at < b.at end)
    for _, pick in ipairs(order) do
        local at
        for index, record in ipairs(list) do if record == pick.record then at = index end end
        if (Turn(list, at, state) or ThenSplit(list, at, state)) and not Over() then return end
    end
end

-- S4. Second mention. A place already named is "the keep", "the tavern", "the city" the next
-- time. Only names that end on one of these kinds, and the capital cities; never a person.
local KIND = {Keep = "keep", Tavern = "tavern", Inn = "inn", Tower = "tower", Farm = "farm", Farmstead = "farmstead",
    Mill = "mill", Mills = "mills", Camp = "camp", City = "city", Village = "village"}
local CAPITALS = {Undercity = true, Orgrimmar = true, Stormwind = true, Ironforge = true, Darnassus = true,
    ["Thunder Bluff"] = true}
local LEAD = Set("The A An At In On By Near Past For From To We I Then There Outside Inside Beyond That Of And")

-- (the place names in a sentence: token span, the name, its kind word, what trails it)
local function Mentions(tokens)
    local found = {}
    for j, token in ipairs(tokens) do
        local read = Read(token)
        local punct = read:match("[%.,;:!]+$") or ""
        local core = read:sub(1, #read - #punct)
        local poss = core:match("'s$") or ""
        core = core:sub(1, #core - #poss)
        -- (a quest or a person that carries a place's name is not the place)
        local other = token:find("^{[^p]:") ~= nil
        local kind = not other and core:find("^%u") and KIND[core:match("(%a+)$") or ""] or nil
        if other then core = "" end
        local i, name = j, nil
        if kind then
            while i > 1 and Capital(tokens[i - 1]) and not tokens[i - 1]:find("^{") and not Read(tokens[i - 1]):find("[%.,;:!]$")
                and not LEAD[Read(tokens[i - 1])] do
                i = i - 1
            end
            name = i < j and (Read(Join(tokens, i, j - 1)) .. " " .. core) or core
            if not name:find(" ", 1, true) then name = nil end
        elseif CAPITALS[core] then
            name, kind = core, "city"
        elseif core == "Bluff" and j > 1 and Read(tokens[j - 1]) == "Thunder" then
            i, name, kind = j - 1, "Thunder Bluff", "city"
        end
        if name then
            found[#found + 1] = {i = i, j = j, key = (name:lower():gsub(" city$", "")), kind = kind, tail = poss .. punct}
        end
    end
    return found
end
S.Mentions = Mentions

-- (a word without what trails it: the stop, the possessive)
local function Core(word) return (word:gsub("[%.,;:!%?]+$", ""):gsub("'s$", ""):gsub("'$", "")) end
-- S10. A place gets its full name once a chapter: a later mention, in any paragraph, is "the
-- tavern" when the name was told in an earlier sentence, it is the only place of its kind
-- named in the chapter so far, and the bare word ("a Scarlet tower", "the ruined tower") is
-- not in use for anything else. "The tavern" written out after the name was told is taken
-- for that same place. A quoted line is read but never changed.
local function Shorten(list)
    local marks, first = {}, {}
    for s, record in ipairs(list) do
        marks[s] = Mentions(Tokens(record.text))
        for _, mark in ipairs(marks[s]) do first[mark.kind] = first[mark.kind] or s end
    end
    local blocked = {}
    for s, record in ipairs(list) do
        local words = Tokens(Read(record.text))
        for k, word in ipairs(words) do
            local kind = Core(word)
            if first[kind] then
                local before = k > 1 and words[k - 1]:lower() or ""
                if not (s > first[kind] and before == "the") then blocked[kind] = true end
            end
        end
    end
    local told, names, count = {}, {}, {}
    for s, record in ipairs(list) do
        for _, mark in ipairs(marks[s]) do
            if not names[mark.kind .. ":" .. mark.key] then
                names[mark.kind .. ":" .. mark.key] = true
                count[mark.kind] = (count[mark.kind] or 0) + 1
            end
        end
        if not record.fixed then
            -- (one name a sentence, the first that was told before)
            for _, mark in ipairs(marks[s]) do
                if told[mark.key] and count[mark.kind] == 1 and not blocked[mark.kind] then
                    local tokens = Tokens(record.text)
                    local before = mark.i > 1 and Read(tokens[mark.i - 1]):lower() or nil
                    local short = mark.kind .. mark.tail
                    if before ~= "the" then short = (mark.i == 1 and "The " or "the ") .. short end
                    local out = {}
                    for k = 1, mark.i - 1 do out[#out + 1] = tokens[k] end
                    out[#out + 1] = short
                    for k = mark.j + 1, #tokens do out[#out + 1] = tokens[k] end
                    record.text = table.concat(out, " ")
                    break
                end
            end
        end
        for _, mark in ipairs(marks[s]) do told[mark.key] = true end
    end
end

-- S11. A person's title once a chapter: after the first mention with it ("Executor Zygand")
-- a later one is the bare name ("Zygand"). Only a title word standing in the text is taken
-- out. Left alone: markup and quoted lines, a title used as a describing word ("the fallen
-- Deathguard Falgan"), and any name that two people of the chapter may share (two titles for
-- one name, or the name after another capital word).
local TITLE = Set("Executor Magistrate Deathguard Apothecary Priest Priestess Captain Sergeant Lieutenant Commander "
    .. "Marshal Corporal Lord Lady King Queen Prince Princess Father Brother Sister Magister Archmage "
    .. "Innkeeper Deathstalker Overseer Foreman Deputy Mayor Doctor Professor Sir Baron Duke Chieftain Warchief "
    .. "Farseer Bishop Archbishop Abbot Inquisitor Interrogator Admiral Deacon Constable Councilman")
local TITLEPRE = Set("Shadow High Grand Dark Royal Junior Senior Chief Master Field")
local NOTNAME = Set("Society Order Guild Corps Quarter Council Hall House Square Row Road Street Bridge Gate Pass "
    .. "Point Rock Hold Post Watch Landing Crossing Terrace Court Brigade Legion Guard Company Trainer Goods Store "
    .. "Supplies Staff Orders Of The And")
local DETERMINER = Set("the a an this that these those my our his her their its one no every each some any")
local OPENING = Set("The A An At In On By Near Past For From To We I Then There Outside Inside Beyond That Of And With "
    .. "After Before When But So Later Soon Here Still Yet Once While Through Under Over Without Against Both")

-- (the words of a sentence, each with the token it came from; a word inside markup is locked)
local function Words(record)
    local words = {}
    for k, token in ipairs(Tokens(record.text)) do
        if token:find("{", 1, true) then
            for word in Read(token):gmatch("%S+") do words[#words + 1] = {text = word, token = k, locked = true} end
        else
            words[#words + 1] = {text = token, token = k, locked = record.fixed}
        end
    end
    return words
end

-- (the titled names of a sentence: where the title starts, where the name stands)
local function Titled(words)
    local found = {}
    local k = 1
    while k <= #words do
        local a, b = k, nil
        if TITLE[words[k].text] then b = k + 1
        elseif TITLEPRE[words[k].text] and words[k + 1] and TITLE[words[k + 1].text] then b = k + 2 end
        local name = b and words[b] and Core(words[b].text)
        if name and name:find("^%u%l") and not TITLE[name] and not TITLEPRE[name] and not NOTNAME[name]
            and not KIND[name] and not KIND[Core(words[b + 1] and words[b + 1].text or "")] then
            local title = {}
            for j = a, b - 1 do title[#title + 1] = words[j].text end
            found[#found + 1] = {a = a, b = b, key = name, title = table.concat(title, " ")}
            k = b
        end
        k = k + 1
    end
    return found
end
S.Titled = function(sentence) return Titled(Words({text = Guard(sentence)})) end

local function Titles(list)
    local words, marks, titles, shared = {}, {}, {}, {}
    for s, record in ipairs(list) do
        words[s] = Words(record)
        marks[s] = Titled(words[s])
        for _, mark in ipairs(marks[s]) do
            if titles[mark.key] and titles[mark.key] ~= mark.title then shared[mark.key] = true end
            titles[mark.key] = titles[mark.key] or mark.title
        end
    end
    -- (the same name after some other capital word: "Calvin Morris" beside "Deathguard Morris")
    for s in ipairs(list) do
        local inTitle = {}
        for _, mark in ipairs(marks[s]) do inTitle[mark.b] = true end
        for k, word in ipairs(words[s]) do
            local name = Core(word.text)
            if titles[name] and not inTitle[k] and k > 1 then
                local before = words[s][k - 1].text
                if before:find("^%u") and not before:find("[%.,;:!%?]$") and not OPENING[before] then shared[name] = true end
            end
        end
    end
    local told = {}
    for s, record in ipairs(list) do
        local drop
        for _, mark in ipairs(marks[s]) do
            local row = words[s]
            local locked = false
            for j = mark.a, mark.b do locked = locked or row[j].locked end
            local one = mark.a > 1 and row[mark.a - 1].text or ""
            local two = mark.a > 2 and row[mark.a - 2].text or ""
            local describes = DETERMINER[one:lower()] or (one:find("^%l+$") and DETERMINER[two:lower()])
            if told[mark.key] and not shared[mark.key] and not locked and not describes then
                drop = drop or {}
                for j = mark.a, mark.b - 1 do drop[row[j].token] = true end
            end
            told[mark.key] = true
        end
        if drop then
            local out = {}
            for k, token in ipairs(Tokens(record.text)) do
                if not drop[k] then out[#out + 1] = token end
            end
            record.text = table.concat(out, " ")
        end
    end
end

-- The style pass. Returns the paragraphs; each kept entry gets its final `text`, its `words`
-- and the number of its paragraph (`para`); an entry not printed has `dropped = true`.
function S.Apply(seq, env)
    env = env or {}
    local seed = tostring(env.seed or "") .. ":" .. tostring(env.index or "")
    DropRepeats(seq)
    PlaceFeelings(seq)
    local kept, flat = {}, {}
    for _, entry in ipairs(seq) do
        if not entry.dropped then
            kept[#kept + 1] = entry
            entry.recs = {}
            local fixed = Quoted(entry.text)
            for _, sentence in ipairs(Sentences(entry.text)) do
                flat[#flat + 1] = {text = Guard(sentence), entry = entry, fixed = fixed}
            end
        end
    end
    for _, record in ipairs(SplitLong(flat)) do
        local recs = record.entry.recs
        recs[#recs + 1] = record
    end
    local paras = Paragraphs(Groups(kept))
    local list = {}
    for p, para in ipairs(paras) do
        for _, group in ipairs(para.groups) do
            for _, entry in ipairs(group.entries) do
                entry.para = p
                for _, record in ipairs(entry.recs) do
                    record.para = p
                    list[#list + 1] = record
                end
                entry.recs = {}
            end
        end
    end
    Openers(list, seed, paras)
    local byPara = {}
    for p = 1, #paras do byPara[p] = {} end
    for _, record in ipairs(list) do
        local records = byPara[record.para]
        records[#records + 1] = record
    end
    Titles(list)
    Shorten(list)
    local texts = {}
    for p, records in ipairs(byPara) do
        local parts = {}
        for i, record in ipairs(records) do
            parts[i] = Unguard(record.text)
            local recs = record.entry.recs
            recs[#recs + 1] = parts[i]
        end
        texts[p] = table.concat(parts, " ")
    end
    for _, entry in ipairs(kept) do
        entry.text = table.concat(entry.recs, " ")
        entry.words = WordCount(entry.text)
        entry.recs = nil
    end
    return texts
end

return S
