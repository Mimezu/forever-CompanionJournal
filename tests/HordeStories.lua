-- Run from client root: lua5.1 Interface/AddOns/CompanionJournal/tests/HordeStories.lua [print]
local root = "Interface/AddOns/CompanionJournal/"
function time() return 1790000000 end
function date(fmt, t) return os.date(fmt, t) end
local A = {defaults = {colors = {}}}
for _, file in ipairs({"LoreData.lua", "Lore.lua", "LoreHordeStories.lua", "JournalBook.lua",
    "JournalTellers.lua", "JournalTale.lua", "JournalWords.lua", "JournalSelfWords.lua", "JournalSelfTale.lua"}) do
    assert(loadfile(root .. file))("CompanionJournal", A)
end
local checks = 0
local function Check(value, message) checks = checks + 1; assert(value, message) end
local pack = A.Lore.storyPacks["horde-and-zephras"]
local function Count(t) local n = 0 for _ in pairs(t) do n = n + 1 end return n end
local function Joined(s, field) return table.concat(s[field] or {}, " ") end
local function After(title, id) return Joined(assert(A.Lore.QuestStory(title, id)), "after") end

-- Every authored ID is supported by an exact title in its cited capture.
-- No network, game session or SavedVariables files are needed for these checks.
local sources = {}
for _, path in ipairs(pack.sources) do
    local file = assert(io.open(path, "rb")); sources[path] = file:read("*a"); file:close()
end
for id, s in pairs(pack.questIDs) do
    Check(#s.why >= 2 and #s.after >= 2, "two useful variants for " .. id)
    Check(s.why[1] ~= s.why[2] and s.after[1] ~= s.after[2], "distinct alternatives for " .. id)
    Check(s.source and #s.source > 0, "provenance for " .. id)
    Check(pack.threads[s.thread] == s.threadLabel, "thread label for " .. id)
    local ref = s.source[1]:match("^(.-) #")
    local source = assert(sources[ref], "source file not declared: " .. id)
    local header = ref:find("part1_corpus", 1, true)
        and ("### " .. id .. " " .. s.title .. " (lvl ")
        or ("### " .. s.title .. "  (id " .. id .. ", level ")
    Check(source:find(header, 1, true), "exact title/ID absent in cited source: " .. id .. " " .. s.title)
    for _, field in ipairs({"why", "after"}) do
        for _, line in ipairs(s[field]) do
            Check(not line:lower():find("%f[%a]you%f[%A]"), "no player address in shared context: " .. id)
            Check(not line:lower():find("%f[%a]we%f[%A]"), "no shared player pronoun: " .. id)
            Check(not line:find("<name>", 1, true), "no raw captured player token: " .. id)
        end
    end
end

-- Repeated titles must never award the final chain outcome on an early ID.
local conservative = {"A Humble Task", "Rites of the Earthmother", "Rite of Vision", "Sarkoth",
    "The Ravaged Caravan", "At War With The Scarlet Crusade", "A New Plague", "A Recipe For Death",
    "Call of Earth", "Call of Fire", "Call of Water", "The Broken Construct",
    "The Admiral's Orders", "The Missing Shipment", "Samophlange", "The Escape", "Journey to the Crossroads"}
for _, title in ipairs(conservative) do
    local s = A.Lore.QuestStory(title)
    Check(s and not s.covers, "old title has no inherited completion suppression: " .. title)
    Check(not Joined(s, "after"):lower():find("totem", 1, true), "title-only history cannot award a totem: " .. title)
    Check(A.Lore.QuestStory(title, 999999) == s, "unknown ID retains conservative fallback: " .. title)
end
for _, id in ipairs({1516, 1517, 1519, 1520, 92466, 92467, 94373, 94374}) do
    Check(not After("Call of Earth", id):lower():find("totem", 1, true), "pre-reward earth stage: " .. id)
end
for _, id in ipairs({1522, 1523, 1524, 1525, 1526, 2984, 94449, 94465, 94466, 94467, 97243, 97244, 97245}) do
    Check(not After("Call of Fire", id):lower():find("totem", 1, true), "pre-reward fire stage: " .. id)
end
for _, id in ipairs({1528, 1529, 2986, 1530, 1535, 1536, 1534, 220, 63, 100, 1103,
    94495, 94497, 94499, 94500, 94501, 94502, 94503}) do
    Check(not After("Call of Water", id):lower():find("totem", 1, true), "pre-reward water stage: " .. id)
end
Check(After("Call of Earth", 1521):find("Ravenfeather", 1, true), "tauren earth reward keeps its teacher")
Check(After("Call of Earth", 94375):find("Teo", 1, true), "Forever dwarf reward keeps its teacher")
Check(After("Call of Fire", 97257):find("Valanaar", 1, true), "sky elf fire ritual keeps its location")
Check(not After("Call of Earth", 1521):find("Canaga", 1, true), "no orc trainer substituted for tauren")
Check(not After("Rite of Vision", 771):find("passed", 1, true), "ingredients are not a completed vision")
Check(not After("Sarkoth", 790):find("Gornek", 1, true), "kill stage does not dispatch Gornek's aid")
Check(not After("At War With The Scarlet Crusade", 370):find("Vachon", 1, true), "Perrine does not kill Vachon")
Check(not After("At War With The Scarlet Crusade", 370):find("Melrache", 1, true), "Perrine does not kill Melrache")
Check(not After("The Broken Construct", 93735):find("repaired", 1, true), "finding construct is not repairing it")
Check(not After("The Fate of Zephras", 94369):find("saved", 1, true), "report does not rescue the island")
Check(A.Lore.QuestStory("Call of Earth", 1527) == A.Lore.QuestStory("Call of Earth"), "mismatched title does not borrow a fire outcome")
Check(not After("The Admiral's Orders", 830):find("Nazgrel", 1, true), "Razor Hill report is not the capital report")
Check(not After("The Admiral's Orders"):find("Nazgrel", 1, true), "old orders do not choose their recipient")
Check(not After("The Missing Shipment", 890):find("pirates", 1, true), "ledger handoff does not conclude the inquiry")
Check(not After("Samophlange", 894):find("delivered", 1, true), "console discovery is not device delivery")
Check(not After("Samophlange", 900):find("unlocked", 1, true), "valve closure is not key acquisition")
Check(not After("Samophlange", 901):find("Undermine", 1, true), "unlocking console does not send device onward")
Check(not After("The Escape"):find("shredder", 1, true), "shared escape title does not select Barrens plot")
Check(not A.Lore.QuestStory("The Escape").zone and not A.Lore.QuestStory("The Escape").thread,
    "shared escape title does not choose geography or thread")
Check(not Joined(A.Lore.QuestStory("Journey to the Crossroads"), "why"):find("elemental", 1, true),
    "old Crossroads referral does not invent a Forever origin")
Check(not After("Ignition", 858):find("wreck", 1, true), "key handoff is not the escape")
Check(not After("Altered Beings", 880):find("discovered", 1, true), "shell gathering is not a completed study")
Check(not After("Meats to Orgrimmar", 6365):find("received the fine cuts", 1, true), "transport request is not inn delivery")

-- Both storytellers, both lengths, eight retells. Single-stage samples make
-- accidental chain-completion claims visible even when historical data is thin.
local BASE = os.time({year = 2026, month = 9, day = 1, hour = 18})
local fixtures = {
    {"Tauren", "SHAMAN", "Mulgore", 747},
    {"Orc", "WARRIOR", "Durotar", 4641},
    {"Troll", "HUNTER", "Durotar", 4641},
    {"Scourge", "MAGE", "Tirisfal Glades", 363},
    {"SkyElf", "SHAMAN", "Zephras Isle", 92460},
    {"Tauren", "SHAMAN", "Mulgore", 1519},
    {"Tauren", "SHAMAN", "Mulgore", 1521},
    {"Dwarf", "SHAMAN", "Dun Morogh", 94373},
    {"Dwarf", "SHAMAN", "Dun Morogh", 94375},
    {"SkyElf", "SHAMAN", "Zephras Isle", 92466},
    {"SkyElf", "SHAMAN", "Zephras Isle", 97257},
    {"Scourge", "MAGE", "Tirisfal Glades", 370},
    {"SkyElf", "MAGE", "Zephras Isle", 93926},
    {"Tauren", "SHAMAN", "Mulgore", 771},
}
local function Person(f, own, titleOnly)
    local s = pack.questIDs[f[4]]
    local p = {self = own or nil, charKey = "sample", name = "Listener", race = f[1], class = f[2],
        faction = f[1] == "Dwarf" and "Alliance" or "Horde", startLevel = s.level, pronouns = "they", bond = "friend", journal = {}}
    p.journal[1] = {k = own and "play" or "group", t = BASE, e = BASE + 3600, z = f[3], pl = s.level, ol = s.level}
    p.journal[2] = {k = "quest", d = s.title, qid = not titleOnly and f[4] or nil, t = BASE + 120, z = f[3], pl = s.level, ol = s.level}
    return p
end
local function Render(p, brief, retell, voice)
    p.retell = retell
    local days = A.JournalBook(p)
    local stories = p.self and A.SelfTale.Tell(p, days, brief, retell)
        or A.JournalTale.Tell(p, days, voice or "we", {name = "Writer", race = p.race, faction = p.faction, class = p.class}, brief)
    local out = {}
    for _, d in ipairs(days) do out[#out + 1] = stories[d.key] and stories[d.key].text or "" end
    return A.JournalPlain(table.concat(out, "\n"))
end
for _, f in ipairs(fixtures) do
    for _, own in ipairs({false, true}) do
        for _, brief in ipairs({false, true}) do
            for retell = 0, 7 do
                local p = Person(f, own)
                local text = Render(p, brief, retell)
                Check(#text > 0, "single recorded milestone survives: " .. f[4])
                Check(not text:find("{%a+:"), "no unresolved markup: " .. f[4])
                Check(Render(p, brief, retell) == text, "deterministic render: " .. f[4])
                Check(p.journal[2].qid == f[4] and #p.journal == 2, "render preserves the recorded stage")
                if f[4] == 1519 or f[4] == 94373 or f[4] == 92466 then
                    Check(not text:lower():find("granted the earth totem", 1, true), "ingredient prose never awards earth totem")
                end
                if f[4] == 370 then
                    Check(not text:find("Vachon", 1, true) and not text:find("Melrache", 1, true), "render does not merge Scarlet kills")
                end
                if arg and arg[1] == "print" and retell == 0 and not brief then
                    print((own and "PERSONAL " or "COMPANION ") .. f[1] .. " #" .. f[4] .. "\n" .. text .. "\n")
                end
            end
        end
    end
end
for _, own in ipairs({false, true}) do
    local p = Person({"Tauren", "SHAMAN", "Mulgore", 1519}, own, true)
    for retell = 0, 7 do
        local text = Render(p, false, retell)
        Check(not text:find("Ravenfeather", 1, true), "title-only record does not invent a teacher")
        Check(not text:lower():find("granted the earth totem", 1, true), "title-only render cannot complete the chain")
    end
    p.journal[2] = nil
    local text = Render(p, false, 0)
    Check(not text:find("sapta", 1, true) and not text:find("earth totem", 1, true), "race/class alone do not invent a rite")
end
-- Connected days expose transitions between ordinary work, the capital and
-- later local dangers. Read these generated examples with the depth argument.
local journeys = {
    {name = "Valley to Ratchet", race = "Orc", class = "WARRIOR", days = {
        {5441, 6394, 2161}, {830, 831, 6384}, {894, 900, 901, 902}}},
    {name = "Mulgore to the oases", race = "Tauren", class = "SHAMAN", days = {
        {1519, 1520, 1521}, {6361, 6362, 6363, 6364}, {886, 870, 877, 880}}},
    {name = "Crossroads to the coast", race = "Troll", class = "HUNTER", days = {
        {860, 903, 881}, {871, 872, 867}, {887, 890, 892, 888, 895}}},
}
for _, journey in ipairs(journeys) do
    for _, own in ipairs({false, true}) do
        local p = {self = own or nil, charKey = "horde-depth", name = "Listener", race = journey.race,
            class = journey.class, faction = "Horde", startLevel = 1, pronouns = "they", bond = "friend", journal = {}}
        for day, ids in ipairs(journey.days) do
            local t = BASE + (day - 1) * 86400
            local first = pack.questIDs[ids[1]]
            p.journal[#p.journal + 1] = {k = own and "play" or "group", t = t, e = t + 3600,
                z = first.zone, pl = first.level, ol = first.level}
            for i, id in ipairs(ids) do
                local s = pack.questIDs[id]
                p.journal[#p.journal + 1] = {k = "quest", d = s.title, qid = id, t = t + i * 120,
                    z = s.zone, pl = s.level, ol = s.level}
            end
        end
        local count = #p.journal
        for _, brief in ipairs({false, true}) do
            for retell = 0, 3 do
                local text = Render(p, brief, retell)
                Check(#text > 150, "connected journey produces prose: " .. journey.name)
                Check(Render(p, brief, retell) == text, "connected journey deterministic")
                Check(#p.journal == count, "connected rendering leaves raw history intact")
                Check(not text:find("{%a+:"), "connected journey resolves markup")
                if arg and arg[1] == "depth" and retell == 0 then
                    print(journey.name .. " / " .. (own and "PERSONAL" or "COMPANION") ..
                        (brief and " HIGHLIGHTS" or " FULL") .. "\n" .. text .. "\n")
                end
            end
        end
    end
end
print(("HordeStories: %d checks; %d precise IDs, %d title contexts, %d regions, %d threads"):format(
    checks, Count(pack.questIDs), Count(pack.quests), Count(pack.zones), Count(pack.threads)))
