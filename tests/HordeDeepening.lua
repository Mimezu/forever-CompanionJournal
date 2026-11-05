-- Run from client root: lua5.1 Interface/AddOns/CompanionJournal/tests/HordeDeepening.lua [print]
-- Overnight 2026-11-05 Horde pass: new exact stages render as connected days for
-- every Horde start (Forsaken, orc/troll, tauren), in both voices, Everything and
-- Highlights, several retells. "print" writes the retell-0 chapters for reading.
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
local function Joined(s, field) return table.concat(s[field] or {}, " ") end
local function After(title, id) return Joined(assert(A.Lore.QuestStory(title, id)), "after") end
local function Story(id) return assert(pack.questIDs[id], "missing exact stage " .. id) end

-- The stages added tonight, by region.
local added = {
    tirisfal = {492, 3901, 3902, 6395, 381, 8, 590, 404, 5481, 5482, 99142, 358, 359, 360, 356, 99156, 374, 365, 407, 398,
        361, 362, 354, 355, 426, 408, 405, 357, 366, 409, 411, 375, 97558, 95314, 86784, 96656},
    camping = {96652, 96659, 96638},
    durotar = {787, 97279, 4402, 96821, 96822, 96876, 785, 99048, 99049, 99051, 99052, 96825},
    mulgore = {3376, 1656, 770, 99079, 99081, 99101, 99080, 99082, 98430, 98424, 98427, 98435},
    silverpine = {445, 3221, 6321, 6323, 6322, 6324, 477, 478, 481, 482, 479, 95981, 480, 98299},
    barrens = {5041, 3281, 1358, 4021, 6541, 6542, 6543, 878, 5052, 879, 906, 893, 3261, 883, 884, 885, 897},
}
local all = {}
for _, ids in pairs(added) do for _, id in ipairs(ids) do all[#all + 1] = id end end
local BANNED = {"%f[%a]journal", "%f[%a]tale%f[%A]", "%f[%a]story%f[%A]", "%f[%a]song", "%f[%a]verse%f[%A]",
    "%f[%a]record%f[%A]", "chronicle", "%f[%a]legend", "%f[%a]bard%f[%A]", "%f[%a]page%f[%A]", "%f[%a]chapter",
    "%f[%a]thread%f[%A]", "%f[%a]you%f[%A]", "%f[%a]we%f[%A]", "<name>", "<class>", "<race>"}
for _, id in ipairs(all) do
    local s = Story(id)
    Check(#s.why >= 2 and #s.after >= 2, "two variants: " .. id)
    Check(s.source and s.source[1]:find("#" .. id, 1, true), "source names the ID: " .. id)
    local lines = {}
    for _, field in ipairs({"why", "after", "highlight"}) do
        for _, line in ipairs(s[field] or {}) do lines[#lines + 1] = line end
    end
    for _, line in ipairs(lines) do
        local low = line:lower()
        for _, bad in ipairs(BANNED) do Check(not low:find(bad), "banned word " .. bad .. " in " .. id .. ": " .. line) end
        Check(not line:find(":", 1, true), "no colon in " .. id .. ": " .. line)
        Check(not line:find("?", 1, true), "no question in " .. id)
        Check(line:match("[%.!]$"), "full sentence in " .. id .. ": " .. line)
    end
    if s.highlight then Check(#s.highlight >= 2 and s.highlight[1] ~= s.highlight[2], "two compact variants: " .. id) end
end

-- Bounded consequences: a stage never claims what a later stage achieves.
Check(not After("A New Plague", 369):find("killed", 1, true), "venom stage does not test the plague")
Check(not After("A New Plague", 492):lower():find("died", 1, true), "the mountaineer's drink is not his death")
Check(not After("A Rogue's Deal", 8):find("coin", 1, true) or After("A Rogue's Deal", 8):find("spend", 1, true), "delivery is not payment")
Check(not After("A Rogue's Deal"):find("Renee", 1, true), "title-only rogue's deal names no recipient")
Check(not After("Gordo's Task", 5481):find("paid", 1, true), "gloom weed earns no doom weed reward")
Check(not After("Fields of Grief", 365):find("zealot", 1, true), "pumpkin theft does not feed the zealot")
Check(not After("Fields of Grief"):find("zealot", 1, true), "title-only pumpkins do not reach the cellar")
Check(not After("Rear Guard Patrol"):find("heart", 1, true), "title-only patrol does not kill the abomination")
Check(not After("Rear Guard Patrol", 356):find("abomination", 1, true), "first patrol is not the abomination hunt")
Check(not After("Forsaken Duties", 359):find("Sevren", 1, true), "Linnea's report has not reached Sevren yet")
for _, id in ipairs({405, 357, 366, 409}) do
    Check(not After(Story(id).title, id):find("join", 1, true), "Gunther has not joined before the Nether Gem: " .. id)
end
Check(After("The Prodigal Lich Returns", 411):find("join", 1, true), "the Nether Gem stage carries Gunther's decision")
Check(not After("Speak with Sevren", 355):find("Dargol", 1, true), "the referral does not take the crypt")
Check(not After("The Adventurer"):find("Eleanor", 1, true) and not After("The Adventurer"):find("Kaga", 1, true),
    "title-only adventurer chooses no start zone")
Check(not A.Lore.QuestStory("The Adventurer").zone, "title-only adventurer has no zone")
Check(not After("Longwalker Malah", 99079):find("centaur", 1, true), "finding Malah does not yet identify her killers")
Check(not After("Grim Tidings", 99081):find("not stand", 1, true), "Wildrunner's alarm is not Baine's answer")
Check(not After("Our Ancient Enemy", 99101):lower():find("victory", 1, true), "Baine's answer is not the battle")
Check(not After("Fizsprocket's Notes", 98424):find("stopped", 1, true), "the notes do not stop the shredder")
Check(not After("Threat from Below", 99049):find("giant", 1, true), "the evidence stage does not kill the sea giant")
Check(not After("Threat from Below", 99051):find("giant", 1, true), "the naga scouts are not the sea giant")
Check(not After("Threat from Below"):find("Razor Hill", 1, true), "title-only threat chooses no settlement")
Check(not After("A Missing Hand", 99048):find("naga", 1, true), "Heglan's body does not yet name the naga")
for _, id in ipairs({477, 478, 481}) do
    Check(not After(Story(id).title, id):find("ley", 1, true), "the ley node is not known before Dalar remembers it: " .. id)
end
Check(not After("Ambermill Investigations", 479):find("dormant", 1, true), "taking pendants does not stop the weaving")
Check(not After("Supplying the Sepulcher", 6321):find("Podrig received", 1, true), "the order is not the delivery")
Check(not After("Michael Garrett", 6322):find("Podrig", 1, true), "the bat master is not the Sepulcher")
Check(not After("Betrayal from Within", 879):find("Thork", 1, true), "the kills are not the report to Thork")
Check(not After("Betrayal from Within"):find("Thork", 1, true) and not After("Betrayal from Within"):find("Orcbane", 1, true),
    "title-only betrayal names no stage")
Check(not After("Tribes at War", 878):find("Orcbane", 1, true), "the Bristleback stage does not reveal the raid leaders")

-- Connected days for each Horde start. Each day is one outing in one zone.
local BASE = os.time({year = 2026, month = 9, day = 1, hour = 18})
local journeys = {
    {name = "Deathknell to Brill", race = "Scourge", class = "PALADIN", days = {
        {"Tirisfal Glades", {363, 364, 3901, 3902}}, {"Tirisfal Glades", {376, 6395, 381, 382, 8}},
        {"Tirisfal Glades", {383, 590, 404, 5481, 5482, 365, 407}},
        {"Tirisfal Glades", {367, 358, 359, 360, 374, 398}}, {"Tirisfal Glades", {368, 369, 492, 356, 99142, 99156}}}},
    {name = "Valley to the coast", race = "Orc", class = "WARRIOR", days = {
        {"Durotar", {787, 4641, 97279, 788, 4402, 789}}, {"Durotar", {96821, 96876, 96825, 96822, 785}},
        {"Durotar", {99048, 99049, 99051, 99052}}}},
    {name = "Bloodhoof and the Galak", race = "Tauren", class = "HUNTER", days = {
        {"Mulgore", {747, 3376, 1656, 750}}, {"Mulgore", {98430, 99079, 99081, 99101, 99080}},
        {"Thunder Bluff", {99082, 98435}}, {"Mulgore", {765, 98424, 98427, 770}}}},
    {name = "The Sepulcher and Ambermill", race = "Scourge", class = "PRIEST", days = {
        {"Silverpine Forest", {445, 6321, 421, 6323, 6322, 6324}}, {"Silverpine Forest", {477, 478, 481, 482, 479}},
        {"Silverpine Forest", {95981, 98298, 98299, 480}}}},
    {name = "Crossroads to Taurajo", race = "Troll", class = "HUNTER", days = {
        {"The Barrens", {854, 5041, 869, 3281, 1358}}, {"The Barrens", {913, 3261, 878, 5052, 893}},
        {"The Barrens", {883, 884, 879, 906, 897, 885}}, {"The Barrens", {4021, 6541, 6543}}}},
    {name = "Agamand and the lich", race = "Scourge", class = "MAGE", days = {
        {"Tirisfal Glades", {96656, 86784, 375, 426, 361, 362}}, {"Tirisfal Glades", {354, 355, 405, 357, 366}},
        {"Tirisfal Glades", {409, 411, 408, 97558, 95314}}}},
}
local function Render(p, brief, retell, voice)
    p.retell = retell
    local days = A.JournalBook(p)
    local stories = p.self and A.SelfTale.Tell(p, days, brief, retell)
        or A.JournalTale.Tell(p, days, voice or "we", {name = "Writer", race = p.race, faction = "Horde", class = p.class}, brief)
    local out = {}
    for _, d in ipairs(days) do out[#out + 1] = stories[d.key] and stories[d.key].text or "" end
    return A.JournalPlain(table.concat(out, "\n\n"))
end
local wanted = arg and arg[1] == "print"
local only = arg and arg[2]
for _, journey in ipairs(journeys) do
    for _, own in ipairs({false, true}) do
        local p = {self = own or nil, charKey = "horde-overnight", name = "Listener", race = journey.race,
            class = journey.class, faction = "Horde", startLevel = 1, pronouns = "they", bond = "friend", journal = {}}
        for day, entry in ipairs(journey.days) do
            local t = BASE + (day - 1) * 86400
            local first = Story(entry[2][1]) or {}
            p.journal[#p.journal + 1] = {k = own and "play" or "group", t = t, e = t + 5400,
                z = entry[1], pl = first.level or 1, ol = first.level or 1}
            for i, id in ipairs(entry[2]) do
                local s = A.Lore.questStoryIDs[id]
                p.journal[#p.journal + 1] = {k = "quest", d = s.title, qid = id, t = t + i * 300,
                    z = entry[1], pl = s.level, ol = s.level}
            end
        end
        local count = #p.journal
        for _, voice in ipairs(own and {"self"} or {"we", "you"}) do
            for _, brief in ipairs({false, true}) do
                for retell = 0, 3 do
                    local text = Render(p, brief, retell, voice ~= "self" and voice or nil)
                    Check(#text > 200, "journey produces prose: " .. journey.name)
                    Check(Render(p, brief, retell, voice ~= "self" and voice or nil) == text, "deterministic: " .. journey.name)
                    Check(#p.journal == count, "rendering leaves history intact")
                    Check(not text:find("{%a+:"), "markup resolved: " .. journey.name)
                    Check(not text:find("  ", 1, true), "no double spaces: " .. journey.name)
                    if wanted and retell == 0 and (not only or journey.name:find(only, 1, true)) then
                        print("=== " .. journey.name .. " / " .. (own and "PERSONAL" or ("COMPANION " .. voice)) ..
                            (brief and " HIGHLIGHTS" or " EVERYTHING") .. "\n" .. text .. "\n")
                    end
                end
            end
        end
    end
end
print(("HordeDeepening: %d checks; %d stages added tonight; %d journeys"):format(checks, #all, #journeys))
