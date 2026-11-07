-- Run from the client root: lua5.1 Interface/AddOns/CompanionJournal/tests/ForeverStories.lua
-- Forever's own quest stages (LoreForeverStories.lua): evidence identity against
-- the captured quest text, prose rules, shared-title boundaries, the Forever
-- label, start-zone logic, and every stage rendered in both narrators, full and
-- Highlights. PRINT=1 prints the rendered chapters for reading in context.
-- Synthetic and offline: never reads or writes SavedVariables.
local root = "Interface/AddOns/CompanionJournal/"
local A = {defaults = {colors = {}}}
function time(t) return type(t) == "table" and os.time(t) or 1792000000 end
function date(f, t) return os.date(f, t) end
for _, name in ipairs({"LoreData", "Lore", "LoreHordeStories", "LoreAllianceStories", "LoreWorldStories",
    "LoreClassStories", "LoreForeverStories", "JournalBook", "JournalTellers", "JournalTale", "JournalWords",
    "JournalSelfWords", "JournalSelfTale"}) do
    assert(loadfile(root .. name .. ".lua"))("CompanionJournal", A)
end
local L, checks = A.Lore, 0
local function check(value, message) checks = checks + 1; assert(value, message) end
local function has(s, part) return s:find(part, 1, true) ~= nil end
local P = assert(L.storyPacks.forever_content, "forever pack not registered")
check(P.setting == "Forever", "pack must be labelled Forever")

-- Evidence: every exact stage exists in the corpus with the same title and level.
local corpus = assert(io.open("StorageInvestigation/journal-voice/review/corpus_vanilla_quests.txt", "rb"))
local source = corpus:read("*a"); corpus:close()
local evidence = {}
for title, id, level in source:gmatch("### ([^\r\n]+)  %(id (%d+), level (%d+)%)") do
    evidence[tonumber(id)] = {title = title, level = tonumber(level)}
end
-- A few Forever stages exist only in the part1 capture (no completion text there).
local part1 = assert(io.open("StorageInvestigation/journal-voice/part1_corpus.txt", "rb"))
for id, title, level in part1:read("*a"):gmatch("### (%d+) ([^\r\n]-) %(lvl (%d+),") do
    id = tonumber(id)
    if not evidence[id] then evidence[id] = {title = title, level = tonumber(level), part1 = true} end
end
part1:close()
local META = {"journal", "tale", "story", "stories", "song", "songs", "verse", "record", "chronicle", "legend", "bard",
    "page", "book", "chapter"}
local pronouns = {i = true, me = true, my = true, mine = true, we = true, us = true, our = true, ours = true,
    you = true, your = true, yours = true}
local function prose(lines, label, single)
    check(type(lines) == "table" and #lines >= (single and 1 or 2), label .. " requires alternatives")
    if not single then check(lines[1] ~= lines[2], label .. " repeated variant") end
    for _, line in ipairs(lines) do
        local plain = line:gsub("{%a:([^}]*)}", "%1")
        check(plain:match("[%.!]$") ~= nil, label .. " incomplete sentence: " .. line)
        check(not plain:find(":", 1, true) and not plain:find("?", 1, true), label .. " colon or question: " .. line)
        check(not line:find("<", 1, true) and not line:find("$", 1, true), label .. " raw quest markup: " .. line)
        -- (a marked place such as {p:Fargodeep Mine} is a name, not a pronoun)
        for word in line:gsub("{p:[^}]*}", ""):gsub("{%a:([^}]*)}", "%1"):lower():gmatch("%a+") do
            check(not pronouns[word], label .. " player/narrator pronoun '" .. word .. "': " .. line)
        end
        for _, word in ipairs(META) do
            check(not plain:lower():find("%f[%a]" .. word .. "%f[%A]"), label .. " meta word '" .. word .. "': " .. line)
        end
        check(not plain:find("Not .-, but "), label .. " banned shape: " .. line)
    end
end
local count, ids = 0, {}
for id, entry in pairs(P.questIDs) do
    count = count + 1; ids[#ids + 1] = id
    check(id >= 65000, "not a Forever quest ID " .. id)
    check(evidence[id] and evidence[id].title == entry.title, "source ID/title mismatch " .. id)
    check(evidence[id].level == entry.level, "source level mismatch " .. id)
    check(entry.source[1]:find(tostring(id), 1, true), "missing source ID " .. id)
    check(not evidence[id].part1 or entry.source[1]:find("part1_corpus", 1, true), "part1-only stage must cite part1 " .. id)
    check(entry.setting == "Forever", "stage not labelled Forever " .. id)
    -- (own fv_ threads, or the Zephras threads shared with LoreHordeStories.lua)
    check(L.storyThreads[entry.thread] ~= nil and (P.threads[entry.thread] ~= nil or entry.thread:find("^forever_")), "missing thread " .. id)
    check(L.QuestStory(entry.title, id).pack == "forever_content", "unresolved ID " .. id)
    prose(entry.why, id .. " why"); prose(entry.after, id .. " after")
    if entry.highlight then prose(entry.highlight, id .. " highlight") end
    for _, ref in ipairs(entry.source) do
        check(not ref:find("LoreForever", 1, true) or ref:find("%(wiki: [^)]+%)"), "LoreForever citation needs its wiki article " .. id)
    end
end
table.sort(ids)
for title, entry in pairs(P.quests) do
    prose(entry.why, title .. " title why"); prose(entry.after, title .. " title after")
end
-- Another pack owning an ID wins; the skipped list says which (never silently both).
for _, id in ipairs(P.skipped or {}) do
    check(L.questStoryIDs[id] and L.questStoryIDs[id].pack ~= "forever_content", "skipped ID not owned elsewhere " .. id)
end

-- Shared titles: the bare title never finishes the chain or takes a later stage's result.
local function text(title, id, field) return table.concat(assert(L.QuestStory(title, id))[field or "after"], " ") end
if P.questIDs[97292] then
    check(has(text("Unending Torment", 97292), "simmer"), "final Othmar stage lost its result")
    check(not has(text("Unending Torment", 97288), "Othmar"), "first head stage spoke a name revealed later")
    check(not has(text("Unending Torment", nil), "simmer") and not has(text("Unending Torment", nil), "Othmar"),
        "bare title finished the Othmar chain")
end
if P.questIDs[95161] then
    check(has(text("Remember That I Love You", 95161), "Avette"), "letter stage lost Avette")
    check(not has(text("Remember That I Love You", 92415), "Avette took"), "orphanage stage took the delivery")
    check(not has(text("Remember That I Love You", nil), "Avette"), "bare title delivered the letter")
end
if P.questIDs[95204] and P.questIDs[95189] then
    check(has(text("Crest of Lordaeron", 95204), "Oran") and not has(text("Crest of Lordaeron", 95204), "Kennedy"), "Horde crest went to Stormwind")
    check(has(text("Crest of Lordaeron", 95189), "Kennedy") and not has(text("Crest of Lordaeron", 95189), "Oran"), "Alliance crest went to the Undercity")
end
if P.questIDs[92401] then
    check(not has(text("A Frightened Request", 92401, "after"), "Jeremy"), "Horde wife learned of the Alliance orphan")
end

-- Start zones and homes: the Skyborne begin on Zephras; the Darkspear Islands are a battleground.
check(L.IsStart("Skyborne", "Zephras Isle") and L.IsStart("SkyElf", "Zephras Isle"), "Skyborne start zone")
check(not L.IsStart("Skyborne", "Durotar"), "Skyborne do not start in Durotar")
check(L.IsStart("Troll", "Durotar") and not L.IsStart("Troll", "Darkspear Islands"), "troll start zone")
check(not L.IsHome("Troll", "Darkspear Islands"), "a battleground is no one's home")
check(L.IsHome("Skyborne", "Zephras Isle"), "Zephras is the Skyborne home")
for _, zone in ipairs({"Riverglades", "Shen'dralas", "Mount Hyjal", "Darkspear Islands", "Zephras Isle"}) do
    local z = L.ZoneStory(zone)
    check(z and #z.sight >= 2 and #z.stakes >= 2, "Forever zone story " .. zone)
    prose(z.sight, zone .. " sight"); prose(z.stakes, zone .. " stakes")
end
for _, name in ipairs({"Ruins of Lordaeron", "The Hall of Thanes", "Krol'dok Stronghold", "Barrow Deeps", "Hyjal Summit"}) do
    local d = L.DungeonStory(name)
    check(d and d.setting == "Forever" and d.source, "Forever dungeon story " .. name)
    prose(d.why, name .. " why", true); prose(d.inside, name .. " inside", true); prose(d.detail, name .. " detail", true)
end
check(A.LoreZoneLevels["Riverglades"] and A.LoreDungeonLevels["Krol'dok Stronghold"], "Forever levels in LoreData")
check(A.LoreZoneLevels["Shen'dralas"] == nil, "Shen'dralas has no published level range")

-- Render every stage, both narrators, Everything and Highlights.
local HORDE_RACE = {["Zephras Isle"] = "Skyborne"}
local ALLIANCE = {}
for _, id in ipairs(P.alliance or {}) do ALLIANCE[id] = true end
local function render(id, companion, brief, retell)
    local q, t = L.questStoryIDs[id], os.time({year = 2026, month = 1, day = 2, hour = 18})
    local faction = ALLIANCE[id] and "Alliance" or "Horde"
    local race = faction == "Alliance" and (q.zone == "Zephras Isle" and "Skyborne" or "Human") or (HORDE_RACE[q.zone] or "Scourge")
    local p = {self = not companion, name = "Forever reader", charKey = "forever-reader", class = "WARRIOR", race = race,
        faction = faction, startLevel = q.level, pronouns = "they", retell = retell, journal = {
            {k = companion and "group" or "play", t = t, e = t + 7200, z = q.zone, pl = q.level, ol = q.level},
            {k = "quest", qid = id, d = q.title, t = t + 600, z = q.zone, pl = q.level, ol = q.level}}}
    local days = A.JournalBook(p)
    local stories = companion and A.JournalTale.Tell(p, days, "we", {name = "Recorder", race = race, class = "WARRIOR", faction = faction}, brief)
        or A.SelfTale.Tell(p, days, brief, retell)
    local out = {}
    for _, d in ipairs(days) do if stories[d.key] then out[#out + 1] = A.JournalPlain(stories[d.key].text) end end
    return table.concat(out, "\n")
end
local printing = os.getenv("PRINT")
local function Plain(s) return A.JournalPlain(s) end
for _, id in ipairs(ids) do
    local q = L.questStoryIDs[id]
    for _, companion in ipairs({false, true}) do for _, brief in ipairs({false, true}) do for retell = 0, 1 do
        local s = render(id, companion, brief, retell)
        check(s == render(id, companion, brief, retell), "unstable Forever scene " .. id)
        check(not has(s, "{p:") and not has(s, "{name}") and not has(s, "<name>"), "unresolved token " .. id .. ": " .. s)
        -- (2026-11-07, DESIGN §3.0: the stage is told in its own words, its point of view, act,
        -- outcome or name, no longer necessarily by its authored outcome line)
        check(A.QuestDeeds.Shows(s, id), "exact stage not told " .. id .. ": " .. s)
        if printing and retell == 0 then
            print(("-- Chapter %d %s [%s, %s]"):format(id, q.title, companion and "we" or "I", brief and "Highlights" or "Everything"))
            print(s)
        end
    end end end
end
print(("ForeverStories: %d checks passed; %d Forever stages, %d skipped as owned elsewhere"):format(checks, count, #(P.skipped or {})))
