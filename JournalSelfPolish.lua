local _, A = ...
-- The last read of a chapter of your own book (2026-11-24, a reading of Alberich's whole book):
-- general rules for the shapes the teller and the composer leave behind, sentence by
-- sentence. Each rule only joins, drops or re-words what the chapter already says; none
-- adds a fact.
--   1. An opening that only says where you still were, followed by leaving that place, is one
--      sentence: "Monday evening, I left the Undercity for the Arathi Highlands, ...".
--   2. A road travelled before anyone joined is yours alone: "We left X for Y, where Dahlia
--      joined me." says "I left".
--   3. A foe whose name is only what it is (the Relic Guardian, an Arcane Anomaly) takes "the";
--      "X killed me. X fell." is one sentence.
--   4. A place named again in the very next sentence is "there".
--   5. A level is a clause of your own deed, never of someone else's words.
--   6. A place name with a colon ("Excavation Site: Wetlands") reads as prose.
local P = {}
A.SelfPolish = P

local function Plain(text) return (tostring(text or ""):gsub("{%a:([^}]*)}", "%1")) end
local function Esc(text) return (text:gsub("[%^%$%(%)%%%.%[%]%*%+%-%?]", "%%%0")) end

-- Sentences of a paragraph (a stop, then a space and a capital or a markup brace). Quoted
-- speech keeps its own stops inside.
function P.Sentences(paragraph)
    local list, start, i, n = {}, 1, 1, #paragraph
    while i <= n do
        local c = paragraph:sub(i, i)
        if (c == "." or c == "!" or c == "?") and paragraph:sub(i + 1, i + 1) == " " and paragraph:sub(i + 2, i + 2):match("[%u{]") then
            list[#list + 1] = paragraph:sub(start, i)
            start = i + 2
            i = i + 2
        else
            i = i + 1
        end
    end
    if start <= n then list[#list + 1] = paragraph:sub(start) end
    return list
end

-- 1. The opening that only says where you were ----------------------------------------------
local STILL = {"was still in ", "stayed on in ", "picked up where I had left off, in ", "spent more time in ", "set out again in "}
function P.FoldOpening(s1, s2)
    local when, place
    for _, verb in ipairs(STILL) do
        when, place = s1:match("^(.-),? I " .. Esc(verb) .. "(.+)%.$")
        if when then break end
    end
    if not when then when, place = s1:match("^I spent (.-) in (.+) as well%.$") end
    if not when or when == "" or when:find("%.") or #when > 40 then return nil end
    local plain = Plain(place)
    local rest = s2:match("^We left (.+)$") or s2:match("^I left (.+)$")
    if rest and Plain(rest):sub(1, #plain) == plain then
        rest = rest:gsub("%f[%a]our%f[%A]", "my"):gsub("%f[%a]us%f[%A]", "me")
        return when .. ", I left " .. rest
    end
    local to = s2:match("^From .-, we went on to (.+)$") or s2:match("^From .-, I went on to (.+)$")
    local from = s2:match("^From (.-), ")
    if to and from and Plain(from) == plain then
        return when .. ", I left " .. place .. " for " .. to
    end
    return nil
end

-- 2. Alone until someone joined ---------------------------------------------------------------
local TRAVEL = {"left", "went", "came", "flew", "rode", "took", "crossed", "made", "headed", "set"}
local function JoinedMe(text) return text:find(" joined me") or text:find(" caught up with me") end
function P.Alone(sentence, nextSentence)
    local verb = sentence:match("^We (%a+) ")
    if not verb then return nil end
    local travel = false
    for _, v in ipairs(TRAVEL) do if v == verb then travel = true end end
    if not travel then return nil end
    local selfJoin = sentence:find(", where .- joined me") or sentence:find(", where .- caught up with me")
    local nextJoin = nextSentence and (nextSentence:match("^There, .- joined me%.$") or nextSentence:match("^.- joined me there%.$")
        or nextSentence:match("^There, .- caught up with me%.$") or nextSentence:match("^.- caught up with me there%.$"))
    if not (selfJoin or nextJoin) then return nil end
    -- (anyone with me already, said in the sentence itself: it stays "we")
    if sentence:find(" with ") then return nil end
    return (("I" .. sentence:sub(3)):gsub("%f[%a]our%f[%A]", "my"):gsub("%f[%a]us%f[%A]", "me"))
end

-- 3. Foes by what they are ----------------------------------------------------------------------
local TITLE = {}
for w in ("Lord Lady King Queen Prince Princess Baron Baroness Captain Commander General Archmage Arch High Grand Overlord "
    .. "Chief Chieftain Warchief Highlord Count Duke Magister Magistrate Master Mistress Elder Old Young Sir Brother Sister "
    .. "Father Mother Bishop Inquisitor Interrogator Houndmaster Bloodmage Arcanist Herod Scarlet"):gmatch("%a+") do TITLE[w] = true end
local KINDS = {}
for w in ("guardian anomaly exile elemental ancient devourer construct sentinel automaton golem spirit wraith phantom specter "
    .. "abomination horror colossus behemoth lasher treant watcher keeper warden defender protector sentry ooze slime "
    .. "geist ghoul gargoyle shade banshee elemental revenant servitor"):gmatch("%a+") do KINDS[w] = true end
local OF_KINDS = {}
for w in ("shade avatar herald spirit echo servant druid champion keeper guardian voice wrath fury heart eye hand"):gmatch("%a+") do OF_KINDS[w] = true end
function P.Generic(name)
    local plain = Plain(name)
    -- ("Shade of the Archmage", "Druid of the Fang": a kind of someone or something)
    local head = plain:match("^(%u%l+) of the %u")
    if head and OF_KINDS[head:lower()] then return true end
    if plain == "" or plain:find(" the ") or plain:find(" of ") or plain:find("'s ") or plain:find("^The ") then return false end
    local first = plain:match("^(%a+)")
    if not first or TITLE[first] then return false end
    local last = plain:match("(%a+)$")
    if not last or not KINDS[last:lower()] then return false end
    -- (every word a plain word: a capital first, no apostrophe or hyphen of a made-up name)
    for word in plain:gmatch("%S+") do
        if not word:match("^%u%l+$") then return false end
    end
    return true
end
-- "Arcane Anomaly killed me." -> "The Arcane Anomaly killed me."; within a sentence "the".
function P.Articles(text, names)
    for _, name in ipairs(names) do
        for _, form in ipairs({"{p:" .. name .. "}", "{n:" .. name .. "}", name}) do
            local source = text
            local braced = form:sub(1, 1) == "{"
            local pattern = "()" .. (braced and "" or "%f[%w]") .. "(" .. Esc(form) .. ")" .. (braced and "" or "%f[^%w']")
            text = source:gsub(pattern, function(at, found)
                local before = source:sub(math.max(1, at - 5), at - 1):lower()
                if before:find("the $") or before:find("%f[%a]a $") or before:find("%f[%a]an $") or before:find("of $") or before:find("{%a:$") then return nil end
                local startOfSentence = at == 1 or source:sub(math.max(1, at - 2), at - 1):match("[%.!?] $")
                return (startOfSentence and "The " or "the ") .. found
            end)
        end
    end
    -- "The X killed me. The X fell." -> "The X killed me, but it fell in the end."
    text = text:gsub("(The ({?%a?:?[%a ]+}?) killed me)%. The (.-) fell%.", function(head, a, b)
        if a == b then return head .. ", but it fell in the end." end
    end)
    return text
end

-- 4. A place again in the next sentence ---------------------------------------------------------
local function LastPlace(sentence)
    local last
    for p in sentence:gmatch("{p:([^}]+)}") do last = p end
    return last
end
-- (the place said in the sentence before: marked, or the same words plain)
function P.There(prev, sentence)
    -- ("From the Wailing Caverns, we went on ..." right after a sentence there)
    local from = sentence:match("^From the {p:([^}]+)}, ") or sentence:match("^From {p:([^}]+)}, ")
    if from and Plain(prev):find(from, 1, true) then
        return "From there, " .. sentence:match("^From .-}, (.+)$")
    end
    local place = LastPlace(prev)
    if not place then return sentence end
    -- ("We were home again in Brill, with its tavern." after arriving in Brill: nothing new)
    if (sentence:find("^We were home again in ") or sentence:find("^I was home again in ")) and Plain(sentence):find(place, 1, true) then
        return ""
    end
    -- ("From the Wailing Caverns, we went on ..." after a sentence there)
    for _, form in ipairs({"{p:" .. place .. "}", place}) do
        for _, art in ipairs({"the ", ""}) do
            local head = "From " .. art .. form .. ", "
            if sentence:sub(1, #head) == head then return "From there, " .. sentence:sub(#head + 1) end
        end
    end
    local count = select(2, Plain(sentence):gsub(Esc(place), ""))
    if count ~= 1 then return sentence end
    for _, form in ipairs({"{p:" .. place .. "}", place}) do
        -- ("into" is a way in, not a place: "We went into X" stays)
        for _, prep in ipairs({"from", "in", "at"}) do
            for _, art in ipairs({"the ", ""}) do
                local phrase = " " .. prep .. " " .. art .. form
                local x, y = sentence:find(phrase, 1, true)
                -- (not as the sentence's own opening: "In Brill, ..." keeps the name; a name that
                -- goes on, "the Vile Reef Tower", is another place)
                if x and x > 1 and not sentence:sub(y + 1, y + 2):match("^ %u") then
                    return sentence:sub(1, x - 1) .. " there" .. sentence:sub(y + 1)
                end
            end
        end
    end
    return sentence
end
-- "We went on to X." when X is where the chapter already is (the last place it named).
function P.Already(sentence, lastPlace)
    local place = sentence:match("^We went on to (.-)%.$") or sentence:match("^I went on to (.-)%.$")
    local mark = place and place:match("{p:([^}]+)}")
    if mark and mark == lastPlace then return "" end
    return sentence
end

-- After a pastime told in a place of its own ("I spent two hours fishing at Tarren Mill"), a
-- join "there" would put the companion at the fishing spot: the join keeps no place.
local PASTIME = {"^I spent .- fishing at ", "^I fished at ", "^I spent .- mining in ", "^I mined in ", "^I spent .- picking herbs in ",
    "^I gathered herbs in ", "^I spent .- skinning in ", "^I skinned beasts in "}
function P.AfterPastime(prev, sentence)
    local pastime = false
    for _, p in ipairs(PASTIME) do if prev:find(p) then pastime = true end end
    if not pastime then return sentence end
    if sentence:find(" joined me there%.$") or sentence:find(" caught up with me there%.$") or sentence:find(" joined us there%.$") then
        return (sentence:gsub(" there%.$", "."))
    end
    local who = sentence:match("^There, (.- joined me)%.$") or sentence:match("^There, (.- caught up with me)%.$")
    if who then return who:gsub("^%l", string.upper) .. "." end
    return sentence
end

-- 5. A level on someone else's words --------------------------------------------------------------
local SPEECH = {"pleaded", "said", "asked", "told", "begged", "called", "thought", "hoped", "wanted", "admitted", "warned", "promised", "saying"}
function P.LevelClause(sentence)
    local body, level = sentence:match("^(.-), and level (%w+) came with it%.$")
    if not body then return sentence end
    local lead = body:match("^(%a+)")
    if lead == "We" or lead == "I" or lead == "Then" then return sentence end
    local speech = false
    for _, verb in ipairs(SPEECH) do if body:find("%f[%a]" .. verb .. "%f[%A]") then speech = true end end
    if not speech then return sentence end
    return body .. ". I reached level " .. level .. "."
end

-- 6. Names with a colon -------------------------------------------------------------------------------
-- ("Excavation Site: Wetlands" -> "the Wetlands Excavation Site"; prose has no colons, so a
-- capital phrase, a colon and a capital word is a name)
function P.Colons(text)
    local source = text
    text = source:gsub("(){p:([^}:]+): ([^}]+)}", function(at, head, tail)
        local before = source:sub(math.max(1, at - 4), at - 1):lower()
        local the = before:find("the $") and "" or (source:sub(math.max(1, at - 2), at - 1):match("[%.!?] $") or at == 1) and "The " or "the "
        return the .. "{p:" .. tail .. " " .. head .. "}"
    end)
    text = text:gsub("(%a*)( ?)(%u[%a']* %u[%a']*): (%u[%a']*)", function(word, space, head, tail)
        if word:lower() == "the" then return word .. space .. tail .. " " .. head end
        local the = (word == "" and space == "") and "The " or "the "
        return word .. space .. the .. tail .. " " .. head
    end)
    return text
end

-- The chapter, paragraph by paragraph. `names`: the day's foes and bosses (plain names).
-- "We went to the Alterac Mountains on an errand." with no one named, and the next sentence
-- takes us there: the bare errand says nothing the road does not.
function P.BareErrand(sentence, nextSentence)
    local place = sentence:match("^We %a+ to (.-) on an errand%.$") or sentence:match("^I %a+ to (.-) on an errand%.$")
    if not place or not nextSentence then return sentence end
    local plain = Plain(place):gsub("^the ", "")
    if Plain(nextSentence):find(plain, 1, true) then return "" end
    return sentence
end

-- (the last place said, not counting the foes, who are marked as names too)
local function LastPlaceOf(sentence, foes)
    local last
    for p in sentence:gmatch("{p:([^}]+)}") do if not foes[p] then last = p end end
    return last
end

-- The chapter, paragraph by paragraph. `names`: the day's foes and bosses (plain names).
function P.Apply(text, names)
    if type(text) ~= "string" or text == "" then return text end
    local generic, foes = {}, {}
    for _, name in ipairs(names or {}) do
        foes[name] = true
        if P.Generic(name) and not generic[name] then generic[name] = true; generic[#generic + 1] = name end
    end
    table.sort(generic, function(a, b) return #a > #b end)
    text = P.Colons(text)
    local all = {}
    for paragraph in (text .. "\n\n"):gmatch("(.-)\n\n") do
        if paragraph ~= "" then all[#all + 1] = P.Sentences(paragraph) end
    end
    local paragraphs, lastPlace, lastSentence = {}, nil, nil
    for pi, s in ipairs(all) do
        local out = {}
        local i = 1
        while i <= #s do
            local sentence = s[i]
            if i == 1 and #paragraphs == 0 and s[2] then
                local folded = P.FoldOpening(sentence, s[2])
                if folded then sentence = folded; i = i + 1 end
            end
            local nextSentence = s[i + 1] or (all[pi + 1] and all[pi + 1][1])
            sentence = P.Alone(sentence, s[i + 1]) or sentence
            sentence = P.BareErrand(sentence, nextSentence)
            if sentence ~= "" and lastSentence then sentence = P.AfterPastime(lastSentence, sentence) end
            if sentence ~= "" and #out > 0 then sentence = P.There(out[#out], sentence) end
            if sentence ~= "" then sentence = P.Already(sentence, lastPlace) end
            if sentence ~= "" then
                out[#out + 1] = P.LevelClause(sentence)
                lastSentence = sentence
                lastPlace = LastPlaceOf(sentence, foes) or lastPlace
            end
            i = i + 1
        end
        local joined = table.concat(out, " ")
        if #generic > 0 then joined = P.Articles(joined, generic) end
        if joined ~= "" then paragraphs[#paragraphs + 1] = joined end
    end
    return table.concat(paragraphs, "\n\n")
end
