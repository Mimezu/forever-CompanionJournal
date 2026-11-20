-- Run from client root: lua5.1 Interface/AddOns/CompanionJournal/tests/BookSpeed.lua
-- 1.54.0: the faster lore marking, death links and boss pronouns give exactly what the old
-- ones gave, on every story text the addon knows and on made-up texts full of markup.
local root = "Interface/AddOns/CompanionJournal/"
function time(t) if type(t) == "table" then return os.time(t) end return 1795000000 end
function date(fmt, t) return os.date(fmt, t) end
local function Stub() return setmetatable({}, {__index = function() return function() end end}) end
function CreateFrame() return Stub() end
C_Timer = {After = function() end}
UIParent = Stub()
SlashCmdList = {}
local A = {defaults = {colors = {}}}
for _, file in ipairs({"Core.lua", "People.lua", "Characters.lua", "LoreData.lua", "Lore.lua", "LoreHordeStories.lua",
    "LoreAllianceStories.lua", "LoreWorldStories.lua", "LoreClassStories.lua", "LoreForeverStories.lua", "LoreNotes.lua",
    "LorePlaces.lua", "LorePeopleHistory.lua", "LoreWorldConnections.lua", "LoreDiscovery.lua", "LoreDiscoveryData.lua",
    "JournalEpisodes.lua", "DeathShots.lua"}) do
    local ok, err = pcall(assert(loadfile(root .. file)), "CompanionJournal", A)
    if not ok then io.stderr:write("load " .. file .. ": " .. tostring(err) .. "\n") end
end
A.db = {characters = {["alberich-forever"] = {}}, people = {["dahlia-noir"] = {name = "Dahlia-Noir"}, ["thrall-x"] = {name = "Thrall-X"}}}
local count = 0
local function Check(value, message) count = count + 1; assert(value, message) end

-- Every story text the lore holds.
local texts = {}
local function Collect(v, depth)
    if type(v) == "string" then if #v > 3 then texts[#texts + 1] = v end
    elseif type(v) == "table" and depth < 6 then for _, x in pairs(v) do Collect(x, depth + 1) end end
end
Collect(A.Lore.dungeonStory, 0)
Collect(A.Lore.questStoryIDs, 0)
for _, note in ipairs(A.LoreNoteCatalog and A.LoreNoteCatalog() or {}) do if type(note.body) == "string" then texts[#texts + 1] = note.body end end
table.sort(texts)
Check(#texts > 5000, "enough texts: " .. #texts)

-- Made-up texts with markup, links and names next to each other.
local seed = 11
local function R(n) seed = (seed * 1103515245 + 12345) % 2147483648; return (seed % n) + 1 end
local bits = {"Thrall", "Sylvanas", "Arugal", "Dahlia", "Alberich", "the Scarlet Monastery", "{n:Thrall}", "{p:Brill}", "|Hcjlore:x|hArugal|h",
    "|Hcjperson:a|h|cff3b3870Dahlia|r|h", "{", "}", "|H", "|h", "|r|h", "|h|r|h", " ", ", ", ". ", "Tirisfal Glades", "Brill", "Undercity",
    "a vampiric duskbat", "Vampiric Duskbat", "Hogger", "hogger", "Van Cleef", "Edwin VanCleef", "_", "x", "'s", "Stormwind", "\n\n"}
for _ = 1, 3000 do
    local parts = {}
    for i = 1, R(30) do parts[i] = bits[R(#bits)] end
    texts[#texts + 1] = table.concat(parts)
end

-- (as the book reads: links on, chapter-long texts)
A.bookLinks = {dahlia = "dahlia-noir"}
local long = {}
for i = 1, #texts - 40, 40 do long[#long + 1] = table.concat(texts, " ", i, i + 39) end
local t0 = os.clock()
for _, text in ipairs(long) do A.MarkKnownLore(text) end
local fastTime = os.clock() - t0
t0 = os.clock()
for _, text in ipairs(long) do A.MarkKnownLoreSlow(text) end
local slowTime = os.clock() - t0
Check(fastTime < slowTime, "faster")
A.bookLinks = nil
io.stderr:write(("lore marking: %d chapter-long texts, %.0f ms (old %.0f ms)\n"):format(#long, fastTime * 1000, slowTime * 1000))
-- Lore marking: the same text with and without the book's links.
for _, links in ipairs({false, {dahlia = "dahlia-noir"}, {thrall = "thrall-x", dahlia = "dahlia-noir"}}) do
    A.bookLinks = links or nil
    for i, text in ipairs(texts) do
      if i % 5 == 0 or i > #texts - 3000 then
        local fast = A.MarkKnownLore(text)
        Check(fast == A.MarkKnownLoreSlow(text), "lore marking differs on text " .. i .. ": " .. text:sub(1, 120))
        Check(A.MarkKnownLore(text) == fast, "kept marking")
      end
    end
end
A.bookLinks = nil

-- Death links: the old code, kept here to compare.
local function OldDeathLinks(text, day)
    if type(text) ~= "string" or not day then return text end
    local deaths = {}
    for _, scene in ipairs(day.scenes or {}) do
        for _, e in ipairs(scene.entries or {}) do
            if e.k == "death" and (e.w == nil or e.w == "you") and type(e.d) == "string" and e.d ~= "" and e.t then
                deaths[#deaths + 1] = e
            end
        end
    end
    table.sort(deaths, function(a, b) return a.t < b.t end)
    local from = 1
    for _, e in ipairs(deaths) do
        local lower, name = text:lower(), e.d:lower()
        local at = lower:find(name, from, true)
        while at do
            local before = text:sub(1, at - 1)
            local open = before:match(".*()%{") or 0
            local shut = before:match(".*()%}") or 0
            local hopen = before:match(".*()|H") or 0
            local hshut = before:match(".*()|h|r|h") or before:match(".*()|r|h") or 0
            if open <= shut and hopen <= hshut then break end
            at = lower:find(name, at + 1, true)
        end
        if at then
            local stop = at + #name - 1
            local link = "|Hcjdeath:" .. e.t .. "|h|cff7d1c0a" .. text:sub(at, stop) .. "|r|h"
            text = text:sub(1, at - 1) .. link .. text:sub(stop + 1)
            from = at + #link
        end
    end
    return text
end
local killers = {"Arugal", "Hogger", "a vampiric duskbat", "Vampiric Duskbat", "Thrall", "Dahlia", "Brill", "x"}
for i, text in ipairs(texts) do
    if i % 3 == 0 or i > #texts - 3000 then
        local entries = {}
        for j = 1, R(4) - 1 do
            entries[#entries + 1] = {k = "death", t = 1000 + R(50), d = killers[R(#killers)], w = R(3) == 1 and "them" or nil}
        end
        local day = {scenes = {{entries = entries}, {entries = {{k = "death", t = 999, d = killers[R(#killers)]}}}}}
        Check(A.DeathLinks(text, day) == OldDeathLinks(text, day), "death links differ on text " .. i .. ": " .. text:sub(1, 120))
        Check(A.DeathLinks(text, day) == OldDeathLinks(text, day), "kept death links")
    end
end
Check(A.DeathLinks(nil, {}) == nil and A.DeathLinks("x", nil) == "x", "death links pass through")

-- Claims of a boss's death: the names a sentence mentions, by the index and by asking every name.
do
    local E = A.JournalEpisodes
    local names = A.Lore.BossNames()
    local copy = {}
    for i, n in ipairs(names) do copy[i] = n end
    local function Killed(name) return #name % 3 == 0 end
    local claims = {"Arugal was slain.", "We killed Hogger at last.", "Edwin VanCleef fell, and the Defias with him.", "Mutanus died there."}
    for i, text in ipairs(texts) do
        if i % 4 == 0 then
            local sample = text .. " " .. claims[i % #claims + 1]
            E.MENTION_INDEX = true
            local a, n1 = E.WithoutUnkilledClaims(sample, Killed, names)
            E.MENTION_INDEX = false
            local b, n2 = E.WithoutUnkilledClaims(sample, Killed, copy)
            Check(a == b and n1 == n2, "death claims differ on text " .. i .. ": " .. sample:sub(1, 120))
        end
    end
    E.MENTION_INDEX = true
end

-- Boss pronouns: the index against the old scan, on a sample (the old scan takes ~0.1 s a name).
local E = A.JournalEpisodes
local names = {}
for name in pairs(A.Lore.bosses or {}) do names[#names + 1] = name end
table.sort(names)
local sample = {"Arugal", "Lady Sylvanas Windrunner", "Thrall", "Whitemane", "Scarlet Commander Mograine", "Hogger", "Edwin VanCleef",
    "Mutanus the Devourer", "Bazzalan", "Taragaman the Hungerer", "Nobody At All", "Mr. Smite", "Archmage Arugal"}
for i = 1, #names, 60 do sample[#sample + 1] = names[i] end
local fast = {}
for _, name in ipairs(sample) do fast[name] = E.BossGender(name) or false end
-- (a fresh copy of the episodes file, with the old scan)
local B = {Lore = A.Lore, LoreNoteResolve = A.LoreNoteResolve, GetLoreNote = A.GetLoreNote}
assert(loadfile(root .. "JournalEpisodes.lua"))("CompanionJournal", B)
B.JournalEpisodes.BOSS_INDEX = false
for _, name in ipairs(sample) do
    Check((B.JournalEpisodes.BossGender(name) or false) == fast[name], "boss pronoun differs for " .. name)
end
print(count .. " checks passed")
