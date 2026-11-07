-- The balanced telling (DESIGN §3.0, 2026-11-07): the character's story first, a few quests
-- worth telling, lore as colour. Fixture: a first evening shaped like the user's live one
-- (a Forsaken paladin and his wife Dahlia, Deathknell to Brill, a death to a Vampiric
-- Duskbat, a campfire, the tavern made home), in memory only; never reads SavedVariables.
--   lua5.1 Interface/AddOns/CompanionJournal/tests/BalancedTelling.lua [print]
local root = "Interface/AddOns/CompanionJournal/"
function time(t) return type(t) == "table" and os.time(t) or 1794023010 end
function date(f, t) return os.date(f, t) end
LOCALIZED_CLASS_NAMES_MALE = {PALADIN = "Paladin", MAGE = "Mage"}
local A = {defaults = {colors = {}}}
for _, f in ipairs({"LoreData", "Lore", "LoreHordeStories", "LoreAllianceStories", "LoreWorldStories", "LoreClassStories",
    "LoreForeverStories", "JournalBook", "JournalTellers", "JournalTale", "JournalWords", "JournalSelfWords", "JournalSelfTale"}) do
    assert(loadfile(root .. f .. ".lua"))("CompanionJournal", A)
end
local checks = 0
local function check(ok, why) checks = checks + 1; assert(ok, why) end
local function has(s, part) return s:find(part, 1, true) ~= nil end
local T = 1794023010
local OWN = {
    {e = T+11182, k = "play", ol = 1, pl = 1, t = T+0, u = T+11182, z = "Tirisfal Glades"},
    {d = "zone", k = "first", ol = 1, pl = 1, t = T+0, z = "Tirisfal Glades"},
    {d = "dahlia-noir", e = T+11182, k = "with", n = "Dahlia-Noir", ol = 1, pl = 1, t = T+1462, z = "Tirisfal Glades"},
    {d = "Deathknell", k = "town", ol = 1, pl = 1, t = T+2807, z = "Tirisfal Glades"},
    {d = "Deathknell", k = "explore", ol = 1, pl = 1, t = T+2809, z = "Tirisfal Glades"},
    {d = "Rude Awakening", k = "quest", ol = 1, pl = 1, qid = 363, ql = 1, t = T+3435, z = "Tirisfal Glades"},
    {d = 2, k = "mylevel", ol = 1, pl = 1, t = T+4666, z = "Tirisfal Glades"},
    {d = "The Mindless Ones", k = "quest", ol = 2, pl = 2, qid = 364, t = T+4742, z = "Tirisfal Glades"},
    {d = "A Difficult Path", k = "quest", ol = 2, pl = 2, qid = 98601, ql = 1, t = T+4950, z = "Tirisfal Glades"},
    {c = 13, e = T+9984, k = "learn", m = {"Devotion Aura (Rank 1)", "Devotion Aura", "Judgement"}, ol = 2, pl = 2, t = T+5000, z = "Tirisfal Glades"},
    {d = 3, k = "mylevel", ol = 2, pl = 2, t = T+5361, z = "Tirisfal Glades"},
    {d = "The Damned", k = "quest", ol = 3, pl = 3, qid = 376, ql = 2, t = T+5745, z = "Tirisfal Glades"},
    {d = "Rattling the Rattlecages", k = "quest", ol = 3, pl = 3, qid = 3901, ql = 3, t = T+5800, z = "Tirisfal Glades"},
    {d = "Scavenging Deathknell", k = "quest", ol = 3, pl = 3, qid = 3902, ql = 3, t = T+6313, z = "Tirisfal Glades"},
    {d = 4, k = "mylevel", ol = 3, pl = 3, t = T+6349, z = "Tirisfal Glades"},
    {d = "Rediscovering the Light", k = "quest", ol = 4, pl = 4, qid = 90902, t = T+6349, z = "Tirisfal Glades"},
    {d = "Night Web's Hollow", k = "cave", ol = 4, pl = 4, t = T+6428, z = "Tirisfal Glades"},
    {d = "Night Web's Hollow", k = "explore", ol = 4, pl = 4, t = T+6428, z = "Tirisfal Glades"},
    {d = "Coming to Terms", k = "quest", ol = 4, pl = 4, qid = 91208, ql = 4, t = T+6893, z = "Tirisfal Glades"},
    {d = "A Light in the Darkness", k = "quest", ol = 4, pl = 4, qid = 98389, ql = 4, t = T+6903, z = "Tirisfal Glades"},
    {d = "Night Web's Hollow", k = "quest", ol = 4, pl = 4, qid = 380, t = T+6921, z = "Tirisfal Glades"},
    {d = 5, k = "mylevel", ol = 4, pl = 4, t = T+7298, z = "Tirisfal Glades"},
    {d = "The Scarlet Crusade", k = "quest", ol = 5, pl = 5, qid = 381, ql = 4, t = T+7534, z = "Tirisfal Glades"},
    {d = "Marla's Last Wish", k = "quest", ol = 5, pl = 5, qid = 6395, t = T+7636, z = "Tirisfal Glades"},
    {d = "Scarlet Crusade Documents", k = "read", ol = 5, pl = 5, t = T+7876, z = "Tirisfal Glades"},
    {d = "The Red Messenger", k = "quest", ol = 5, pl = 5, qid = 382, t = T+7959, z = "Tirisfal Glades"},
    {d = "Tirisfal Glades", k = "explore", ol = 5, pl = 5, t = T+8084, z = "Tirisfal Glades"},
    {d = "Solliden Farmstead", k = "explore", ol = 5, pl = 5, t = T+8151, z = "Tirisfal Glades"},
    {d = "Cold Hearth Manor", k = "explore", ol = 5, pl = 5, t = T+8804, z = "Tirisfal Glades"},
    {d = "Stillwater Pond", k = "explore", ol = 5, pl = 5, t = T+8872, z = "Tirisfal Glades"},
    {c = 2, d = "Mining", e = T+8935, k = "craft", m = {"Smelting", "Find Minerals"}, ol = 5, pl = 5, t = T+8933, z = "Tirisfal Glades"},
    {d = "Nightmare Vale", k = "explore", ol = 5, pl = 5, t = T+9058, z = "Tirisfal Glades"},
    {d = 6, k = "mylevel", ol = 5, pl = 5, t = T+9088, z = "Tirisfal Glades"},
    {d = "Vampiric Duskbat", k = "death", ol = 6, pl = 6, t = T+9114, w = "you", z = "Tirisfal Glades"},
    {d = "Brill", k = "town", ol = 6, pl = 6, t = T+9124, z = "Tirisfal Glades"},
    {d = "Brill", k = "explore", ol = 6, pl = 6, t = T+9361, z = "Tirisfal Glades"},
    {d = "Fields of Grief", k = "quest", ol = 6, pl = 6, qid = 365, ql = 7, t = T+9428, z = "Tirisfal Glades"},
    {d = "Vital Intelligence", k = "quest", ol = 6, pl = 6, qid = 383, ql = 5, t = T+9575, z = "Tirisfal Glades"},
    {k = "campfire", ol = 6, pl = 6, t = T+9678, z = "Tirisfal Glades"},
    {d = "Gallows' End Tavern", k = "explore", ol = 6, pl = 6, t = T+9816, z = "Tirisfal Glades"},
    {d = "Gallows' End Tavern", k = "rest", ol = 6, pl = 6, t = T+9818, z = "Tirisfal Glades"},
    {d = "Gallows' End Tavern", k = "home", ol = 6, pl = 6, t = T+9825, z = "Tirisfal Glades"},
    {d = "Fields of Grief", k = "quest", ol = 6, pl = 6, qid = 407, ql = 7, t = T+9874, z = "Tirisfal Glades"},
    {d = "Continue Your Training", k = "quest", ol = 6, pl = 6, qid = 91209, ql = 4, t = T+9927, z = "Tirisfal Glades"},
    {d = "dahlia-noir", e = T+15475, k = "with", n = "Dahlia-Noir", ol = 6, pl = 6, t = T+11186, z = "Tirisfal Glades"},
    {e = T+15475, k = "play", ol = 6, pl = 6, t = T+11186, u = T+15475, z = "Tirisfal Glades"},
    {d = "Brill", k = "town", ol = 6, pl = 6, t = T+11188, z = "Tirisfal Glades"},
    {d = "The Adventurer", k = "quest", ol = 6, pl = 6, qid = 96656, ql = 6, t = T+11585, z = "Tirisfal Glades"},
    {d = "The Great Outdoors", k = "quest", ol = 6, pl = 6, qid = 96607, ql = 6, t = T+11703, z = "Tirisfal Glades"},
    {d = "Discipline", k = "quest", ol = 6, pl = 6, qid = 99134, ql = 6, t = T+11765, z = "Tirisfal Glades"},
    {d = "Gordo's Task", k = "quest", ol = 6, pl = 6, qid = 5481, ql = 5, t = T+11952, z = "Tirisfal Glades"},
    {d = 7, k = "mylevel", ol = 6, pl = 6, t = T+12430, z = "Tirisfal Glades"},
    {d = "Sticks and Bones", k = "quest", ol = 7, pl = 7, qid = 86784, t = T+12430, z = "Tirisfal Glades"},
    {d = "Seeking Refuge", k = "quest", ol = 7, pl = 7, qid = 99144, ql = 7, t = T+13701, z = "Tirisfal Glades"},
    {d = "At War With The Scarlet Crusade", k = "quest", ol = 7, pl = 7, qid = 427, ql = 8, t = T+13711, z = "Tirisfal Glades"},
    {d = "Gallows' End Tavern", k = "rest", ol = 7, pl = 7, t = T+13819, z = "Tirisfal Glades"},
    {d = "Gallows' End Tavern", k = "sleep", ol = 7, pl = 7, t = T+15427, z = "Tirisfal Glades"},
}
local DAHLIA = {
    {c = 3, e = T+1379, k = "seen", ol = 16, pl = 1, t = T+280, z = "Tirisfal Glades"},
    {e = T+15427, k = "group", ol = 16, pl = 1, t = T+1462, z = "Tirisfal Glades"},
    {d = 2, k = "mylevel", ol = 1, pl = 1, t = T+4666, z = "Tirisfal Glades"},
    {d = 2, k = "level", ol = 1, pl = 2, t = T+4667, z = "Tirisfal Glades"},
    {d = "The Mindless Ones", k = "quest", ol = 2, pl = 2, qid = 364, ql = 2, t = T+4742, z = "Tirisfal Glades"},
    {d = 3, k = "mylevel", ol = 2, pl = 2, t = T+5361, z = "Tirisfal Glades"},
    {d = 3, k = "level", ol = 2, pl = 3, t = T+5362, z = "Tirisfal Glades"},
    {d = "The Damned", k = "quest", ol = 3, pl = 3, qid = 376, ql = 2, t = T+5745, z = "Tirisfal Glades"},
    {d = "Rattling the Rattlecages", k = "quest", ol = 3, pl = 3, qid = 3901, ql = 3, t = T+5800, z = "Tirisfal Glades"},
    {d = "Scavenging Deathknell", k = "quest", ol = 3, pl = 3, qid = 3902, ql = 3, t = T+6313, z = "Tirisfal Glades"},
    {d = 4, k = "mylevel", ol = 3, pl = 3, t = T+6349, z = "Tirisfal Glades"},
    {d = 4, k = "level", ol = 3, pl = 4, t = T+6509, z = "Tirisfal Glades"},
    {d = "A Light in the Darkness", k = "quest", ol = 4, pl = 4, qid = 98389, ql = 4, t = T+6903, z = "Tirisfal Glades"},
    {d = "Night Web's Hollow", k = "quest", ol = 4, pl = 4, qid = 380, ql = 4, t = T+6921, z = "Tirisfal Glades"},
    {d = 5, k = "mylevel", ol = 4, pl = 4, t = T+7298, z = "Tirisfal Glades"},
    {d = 5, k = "level", ol = 4, pl = 5, t = T+7379, z = "Tirisfal Glades"},
    {d = "The Scarlet Crusade", k = "quest", ol = 5, pl = 5, qid = 381, ql = 4, t = T+7534, z = "Tirisfal Glades"},
    {d = "Marla's Last Wish", k = "quest", ol = 5, pl = 5, qid = 6395, ql = 5, t = T+7636, z = "Tirisfal Glades"},
    {d = "The Red Messenger", k = "quest", ol = 5, pl = 5, qid = 382, ql = 5, t = T+7959, z = "Tirisfal Glades"},
    {d = 6, k = "mylevel", ol = 5, pl = 5, t = T+9088, z = "Tirisfal Glades"},
    {d = "Vampiric Duskbat", k = "death", ol = 5, pl = 6, t = T+9114, w = "you", z = "Tirisfal Glades"},
    {d = 6, k = "level", ol = 5, pl = 6, t = T+9399, z = "Tirisfal Glades"},
    {d = "Fields of Grief", k = "quest", ol = 6, pl = 6, qid = 365, ql = 7, t = T+9428, z = "Tirisfal Glades"},
    {d = "Vital Intelligence", k = "quest", ol = 6, pl = 6, qid = 383, ql = 5, t = T+9575, z = "Tirisfal Glades"},
    {k = "campfire", ol = 6, pl = 6, t = T+9705, z = "Tirisfal Glades"},
    {d = "Fields of Grief", k = "quest", ol = 6, pl = 6, qid = 407, ql = 7, t = T+9874, z = "Tirisfal Glades"},
    {d = "The Adventurer", k = "quest", ol = 6, pl = 6, qid = 96656, ql = 6, t = T+11585, z = "Tirisfal Glades"},
    {d = "Discipline", k = "quest", ol = 6, pl = 6, qid = 99134, ql = 6, t = T+11765, z = "Tirisfal Glades"},
    {d = "Gordo's Task", k = "quest", ol = 6, pl = 6, qid = 5481, ql = 5, t = T+11952, z = "Tirisfal Glades"},
    {d = 7, k = "level", ol = 6, pl = 6, t = T+12308, z = "Tirisfal Glades"},
    {d = 7, k = "mylevel", ol = 7, pl = 6, t = T+12430, z = "Tirisfal Glades"},
    {d = "Seeking Refuge", k = "quest", ol = 7, pl = 7, qid = 99144, ql = 7, t = T+13701, z = "Tirisfal Glades"},
    {d = "At War With The Scarlet Crusade", k = "quest", ol = 7, pl = 7, qid = 427, ql = 8, t = T+13711, z = "Tirisfal Glades"},
    {e = T+15475, k = "group", ol = 7, pl = 7, t = T+15432, z = "Tirisfal Glades"},
}
A.db = {people = {["dahlia-noir"] = {name = "Dahlia-Noir", race = "Scourge", class = "MAGE", pronouns = "she", bond = "spouse"}}}
local QD = A.QuestDeeds
local function Sentences(text)
    local list = {}
    for s in (text .. " "):gmatch("(.-[%.!])%s+") do list[#list + 1] = (s:gsub("^%s+", "")) end
    return list
end
local function Own(brief, retell)
    local p = {self = true, charKey = "balanced-evening", name = "Alberich", race = "Scourge", faction = "Horde", class = "PALADIN",
        startLevel = 1, journal = OWN, retell = retell}
    local days = A.JournalBook(p)
    local st = A.SelfTale.Tell(p, days, brief, retell)
    return A.JournalPlain(st[days[1].key].text), days
end
local function Companion(voice, brief, retell)
    local p = {name = "Dahlia-Noir", race = "Scourge", class = "MAGE", pronouns = "she", bond = "spouse", journal = DAHLIA, retell = retell}
    local days = A.JournalBook(p)
    local st = A.JournalTale.Tell(p, days, voice, {name = "Alberich", race = "Scourge", class = "PALADIN", faction = "Horde"}, brief)
    return A.JournalPlain(st[days[1].key].text)
end
-- Every sentence the packs authored for the evening's stages (setup, outcome, short scene).
local packSentences = {}
for _, e in ipairs(OWN) do
    if e.k == "quest" then
        local story = A.Lore.QuestStory(e.d, e.qid)
        for _, field in ipairs({"why", "after", "highlight"}) do
            for _, line in ipairs(story and story[field] or {}) do
                for _, s in ipairs(Sentences(QD.NoSemicolon(A.JournalPlain(line)))) do if #s > 12 then packSentences[s] = true end end
            end
        end
    end
end
local function PackShare(text)
    local n, pack, run, maxRun = 0, 0, 0, 0
    for _, s in ipairs(Sentences(text)) do
        n = n + 1
        if packSentences[s] then pack, run = pack + 1, run + 1; if run > maxRun then maxRun = run end else run = 0 end
    end
    return pack, n, maxRun
end
local function PlayerLed(s)
    return s:find("^I ") or s:find("^We ") or s:find("^My ") or s:find("^Dahlia and I") or s:find(", I ") or s:find(", we ")
        or s:find(" I ") or s:find(" we ") or s:find(" me[ ,%.]") or s:find(" us[ ,%.]") or s:find(" my ")
end
local DEFECTS = {"(Rank", "and more from the trainer", "more places", "read Scarlet Crusade Documents", "turned in Night Web's Hollow",
    "Night's Web Hollow", "nothing new to me", "the inn in Gallows' End", "inn at Gallows' End", "much work ahead", "Their thief",
    "lay with Shari", "was with me from the first", "beside me from the first", ". Vampiric Duskbat killed me", "I met Dahlia, my wife",
    "You met Dahlia, your wife"}
local printing = arg and arg[1] == "print"
for retell = 0, 7 do
    for _, brief in ipairs({false, true}) do
        local text = Own(brief, retell)
        check(text == Own(brief, retell), "own book deterministic")
        if printing and retell == 0 then print("== own " .. (brief and "Highlights" or "Everything") .. "\n" .. text .. "\n") end
        for _, bad in ipairs(DEFECTS) do check(not has(text, bad), "defect '" .. bad .. "' in own book: " .. text) end
        check(has(text, "with Dahlia, my wife, at my side"), "the life begins with Dahlia at my side: " .. text)
        check(text:find("[Aa] Vampiric Duskbat") ~= nil, "the killer is a kind, with its article: " .. text)
        local _, deathknell = text:gsub("Deathknell", "")
        check(deathknell <= 2, "Deathknell named at most twice: " .. deathknell)
        check(not text:find(":", 1, true) and not text:find("?", 1, true), "no colon or question: " .. text)
        -- Lore budget: the stage's own sentences are seasoning, never a run of more than two.
        local pack, n, run = PackShare(text)
        check(run <= 2, "no run of three pack sentences: " .. text)
        check(pack <= (brief and 2 or 4), "lore budget, pack sentences " .. pack .. ": " .. text)
        -- The character leads.
        local led = 0
        for _, s in ipairs(Sentences(text)) do if PlayerLed(s) then led = led + 1 end end
        check(led / n >= 0.6, ("player-led share %d of %d: %s"):format(led, n, text))
        -- Dahlia is present through the chapter: "we" in many sentences, not a name once.
        local _, we = text:gsub("%f[%a][Ww]e%f[%A]", "")
        check(we >= (brief and 3 or 8), "the companion present through the chapter (" .. we .. " we): " .. text)
        if not brief then
            -- A few quests told as moments, the rest grouped: some line carries several acts.
            check(text:find("[%a], [%a' ]+ and [%a]") ~= nil, "grouped acts: " .. text)
            local told = 0
            for _, e in ipairs(OWN) do
                if e.k == "quest" then
                    local story = QD.Story({title = e.d, qid = e.qid})
                    for _, line in ipairs(story and story.pov or {}) do
                        local plain = QD.Fill(line, {We = "We", we = "we", us = "us", our = "our", Our = "Our", I = "I", me = "me", my = "my", My = "My"})
                        if has(text, plain) then told = told + 1 end
                    end
                end
            end
            check(told >= 2 and told <= 8, "a few quests told as moments: " .. told)
            check(#Sentences(text) <= 40, "Everything stays a chapter, not a ledger: " .. #Sentences(text))
        else
            local full = Own(false, retell)
            check(#text < #full * 0.6, "Highlights is a real cut: " .. #text .. " of " .. #full)
            check(#Sentences(text) <= 10, "Highlights is a short paragraph or two: " .. #Sentences(text) .. " " .. text)
            check(has(text, "Duskbat") and has(text, "Brill"), "Highlights keeps the death and the evening's end: " .. text)
        end
        -- The companion book: the pair's evening, no second copy of the own book's lines.
        for _, voice in ipairs({"we", "you"}) do
            local ctext = Companion(voice, brief, retell)
            check(ctext == Companion(voice, brief, retell), "companion book deterministic")
            if printing and retell == 0 then print("== Dahlia " .. voice .. " " .. (brief and "Highlights" or "Everything") .. "\n" .. ctext .. "\n") end
            for _, bad in ipairs(DEFECTS) do check(not has(ctext, bad), "defect '" .. bad .. "' in companion book: " .. ctext) end
            check(not ctext:find(";", 1, true), "no semicolon in the companion book: " .. ctext)
            local own = Own(brief, retell)
            for _, s in ipairs(Sentences(ctext)) do
                check(not packSentences[s], "the companion book retells no pack sentence: " .. s)
                if voice == "we" and #s > 40 then check(not has(own, s), "no long sentence shared with the own book: " .. s) end
            end
            if voice == "we" then check(not ctext:find("%f[%a][Yy]ou%f[%A]"), "the diary never says you: " .. ctext) end
            check(has(ctext, "Dahlia, " .. (voice == "we" and "my" or "your") .. " wife"), "Dahlia, as she is to me: " .. ctext)
        end
    end
end
-- The `pov` field: format, tokens, words.
local TOKENS = {We = true, we = true, us = true, our = true, Our = true, I = true, me = true, my = true, My = true}
-- (whole words, with their plurals: "talents" and "pages of a ledger" are not "tale" and "page", 2026-11-07)
local META = {"journals?", "chronicles?", "legends?", "tales?", "songs?", "verses?", "bards?", "chapters?", "story", "pages?", "books?"}
local povs = 0
local function Pov(id, pov)
    povs = povs + 1
    check(type(pov.act) == "string" and pov.act:match("^%l") ~= nil, "pov " .. id .. " has a lower-case act")
    check(#pov >= 2 and pov[1] ~= pov[2], "pov " .. id .. " has two distinct lines")
    for _, line in ipairs(pov) do
        for token in line:gmatch("{(%a+)}") do check(TOKENS[token], "pov " .. id .. " uses only person tokens: " .. token) end
        check(line:match("^[%u{]") and line:match("%.$"), "pov " .. id .. " is a sentence: " .. line)
        check(not line:find(":", 1, true) and not line:find("?", 1, true) and not line:find(";", 1, true), "pov " .. id .. " has no colon, question or semicolon")
        local low = " " .. line:lower()
        for _, word in ipairs(META) do check(not low:find("%f[%a]" .. word .. "%f[%A]"), "pov " .. id .. " uses meta word " .. word .. ": " .. line) end
        check(line:find("{%a+}") ~= nil, "pov " .. id .. " is told from the character's side: " .. line)
        check(not line:find("{I} was ", 1, true) and not line:find("{we} were ", 1, true) and not line:find("{We} were ", 1, true),
            "pov " .. id .. " avoids I/we verb agreement")
    end
end
for id, story in pairs(A.Lore.questStoryIDs) do if story.pov then Pov(id, story.pov) end end
for id, pov in pairs(A.SelfWords.pov) do
    check(type(pov.title) == "string", "overlay pov " .. id .. " names its exact title")
    local stage = A.Lore.questStoryIDs[id]
    check(not stage or stage.title == pov.title, "overlay pov " .. id .. " matches its stage")
    check(not (stage and stage.pov), "overlay pov " .. id .. " does not shadow a pack pov")
    Pov(id, pov)
end
-- A title-only record never takes an exact stage's point of view.
local s = QD.Story({title = "Marla's Last Wish"})
check(not (s and s.pov), "title-only record takes no pov")
check(QD.Story({title = "Marla's Last Wish", qid = 6395}).pov ~= nil, "exact record takes its pov")
-- A chain's finale is only near the chain's authored top level (no hindsight).
check(QD.ThreadTop("horde_scarlet") >= 12, "the Scarlet chain runs on past the evening")
-- Places and papers of the work are told by the work.
local full = Own(false, 0)
check(not has(full, "I spent a while underground"), "the cave is told by its work: " .. full)
-- The journey's voice: grouped lines use the connective of the character's stage.
check(QD.Band(5) == "novice" and QD.Band(30) == "seasoned" and QD.Band(58) == "known", "journey bands by level")
print(("BalancedTelling: %d checks passed; %d pov entries"):format(checks, povs))
