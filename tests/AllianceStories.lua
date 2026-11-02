-- Run from client root: lua5.1 Interface/AddOns/CompanionJournal/tests/AllianceStories.lua [print]
local root = "Interface/AddOns/CompanionJournal/"
function time(t) return t and os.time(t) or 1790000000 end
function date(fmt, t) return os.date(fmt, t) end
function CreateFrame() return setmetatable({}, {__index = function() return function() end end}) end
C_Timer = {After = function() end}
local A = {defaults = {colors = {}}, db = {people = {}}}
for _, file in ipairs({"LoreData.lua", "Lore.lua", "LoreAllianceStories.lua", "People.lua", "Characters.lua", "Journal.lua", "JournalBook.lua", "JournalTellers.lua", "JournalTale.lua", "JournalWords.lua", "JournalSelfWords.lua", "JournalSelfTale.lua"}) do
    assert(loadfile(root .. file))("CompanionJournal", A)
end
local checks = 0
local function check(ok, why) checks = checks + 1; assert(ok, why) end
local pack = A.Lore.storyPacks["alliance-starters"]
local function count(t) local n = 0; for _ in pairs(t) do n = n + 1 end; return n end
check(count(pack.questIDs) >= 141, "broad individually curated ID coverage")
local source = assert(io.open("StorageInvestigation/journal-voice/review/corpus_vanilla_quests.txt", "r"))
local corpus = source:read("*a"); source:close()
local titles, multiplicity = {}, {}
for title, id in corpus:gmatch("### ([^\r\n]+)  %(id (%d+), level %d+%)") do
    titles[tonumber(id)] = title
    multiplicity[title] = (multiplicity[title] or 0) + 1
end
for id, entry in pairs(pack.questIDs) do
    check(titles[id] == entry.title, "source title for " .. id)
    check(entry.source[1]:find(tostring(id), 1, true), "provenance ID " .. id)
    check(pack.threads[entry.thread] == entry.threadLabel, "registered continuity " .. id)
    local resolved = A.Lore.QuestStory(entry.title, id)
    check(resolved.after == entry.after, "exact outcome lookup " .. id)
    for _, kind in ipairs({"why", "after"}) do
        check(#entry[kind] >= 2 and entry[kind][1] ~= entry[kind][2], "distinct variants " .. id .. kind)
        for _, line in ipairs(entry[kind]) do
            check(not line:find("%f[%a][Yy]ou%f[%A]") and not line:find("%f[%a][Oo]ur%f[%A]") and not line:find("%f[%a][Ww]e%f[%A]"), "shared context has no player pronoun: " .. line)
            check(not line:find("<") and not line:find("%[Quest%]"), "no raw source placeholder " .. id)
        end
    end
    if multiplicity[entry.title] > 1 then
        local fallback = pack.quests[entry.title]
        check(not fallback or fallback.after ~= entry.after, "ambiguous title must not select precise consequence: " .. entry.title)
    end
end
local function after(title, id) return table.concat(A.Lore.QuestStory(title, id).after, " "):lower() end
check(not after("Iverron's Antidote"):find("drank", 1, true), "old antidote title cannot imply administering medicine")
check(not after("Iverron's Antidote", 3521):find("drank", 1, true), "ingredient quest cannot heal Iverron")
check(after("Iverron's Antidote", 3522):find("drank", 1, true), "delivery permits treatment")
check(not after("The People's Militia", 12):find("induction", 1, true), "first militia stage cannot confer membership")
check(after("The People's Militia", 14):find("induction", 1, true), "final militia stage supports membership")
check(not after("Bashal'Aran"):find("freed the prisoner", 1, true), "title fallback cannot free prisoner")
check(not after("Bashal'Aran", 956):find("freed the prisoner", 1, true), "retrieving seal cannot free prisoner")
check(after("Bashal'Aran", 957):find("freed the prisoner", 1, true), "burning seal supports freedom")
check(after("Operation Recombobulation", 412):find("yet to be demonstrated", 1, true), "parts do not cure gnomes")
check(after("The Public Servant", 433):find("still lay ahead", 1, true), "quarry combat does not rebuild infrastructure")
check(after("The Collector", 123):find("remained unknown", 1, true), "schedule does not expose Collector's employer")
check(after("Crown of the Earth", 98065):find("tyrande", 1, true), "Forever final water delivery retained")
check(not after("Crown of the Earth"):find("tyrande", 1, true), "old crown title cannot assume Tyrande stage")
check(A.Lore.QuestStory("Crown of the Earth", 3522).after == A.Lore.QuestStory("Crown of the Earth").after, "mismatched ID cannot borrow another quest outcome")
check(not after("The Defias Brotherhood"):find("death", 1, true), "old Defias title cannot kill VanCleef")
check(not after("The Defias Brotherhood", 141):find("confirmed", 1, true), "Shaw's account does not supply final proof")
check(after("The Defias Brotherhood", 142):find("remained to be found", 1, true), "messenger papers do not reveal hideout")
check(after("The Defias Brotherhood", 155):find("still ahead", 1, true), "escort does not kill VanCleef")
check(after("The Defias Brotherhood", 166):find("death", 1, true), "final Defias turn-in supports death")
check(not after("The Escape"):find("maybell", 1, true), "shared escape title cannot choose Alliance story")
check(after("The Escape", 114):find("still to come", 1, true), "liquor delivery does not witness lovers' reunion")
check(after("Note to the Mayor", 160):find("unresolved", 1, true), "letter delivery does not decode or reveal hermit's purpose")
check(after("The Sleeping Druid", 2541):find("still bound", 1, true), "charm collection does not free druid")
check(after("Druid of the Claw", 2561):find("freed", 1, true), "body and charm stage frees druid")
check(after("The Red Crystal", 4811):find("without explaining", 1, true), "first scouting does not explain crystal")
check(not after("As Water Cascades", 4812):find("council", 1, true), "crystal experiment cannot report to council")
check(after("The Fragments Within", 4813):find("unanswered", 1, true), "final crystal report preserves mystery")

local function snapshot(value)
    if type(value) ~= "table" then return tostring(value) end
    local keys, out = {}, {}
    for key in pairs(value) do keys[#keys + 1] = key end
    table.sort(keys, function(a, b) return tostring(a) < tostring(b) end)
    for _, key in ipairs(keys) do out[#out + 1] = tostring(key) .. "=" .. snapshot(value[key]) end
    return "{" .. table.concat(out, ",") .. "}"
end
local BASE = os.time({year = 2026, month = 9, day = 3, hour = 18})
local examples = {
    {"Human", "WARRIOR", 783, 3904, 61},
    {"Dwarf", "PALADIN", 179, 420, 301},
    {"Gnome", "MAGE", 179, 400, 412},
    {"NightElf", "DRUID", 456, 3521, 98065},
    {"Human", "ROGUE", 65, 132, 135, 141, 142, 155, 166},
    {"Human", "MAGE", 106, 111, 107, 112, 114},
    {"Human", "WARRIOR", 165, 148, 149, 154, 157, 158, 156, 159, 133, 134, 160},
    {"Human", "PALADIN", 125, 129, 130, 131, 3741},
    {"Dwarf", "HUNTER", 218, 319, 320, 315, 418, 455, 279},
    {"NightElf", "PRIEST", 2541, 2561, 1141, 4811, 4812, 4813},
}
for _, example in ipairs(examples) do
    for _, historical in ipairs({false, true}) do
        for _, companion in ipairs({false, true}) do
            local person = {name = "Aster", race = example[1], class = example[2], faction = "Alliance", pronouns = "they", bond = "friend", startLevel = 1, journal = {}}
            if not companion then person.self = true; person.charKey = example[1] end
            for day = 1, #example - 2 do
                local id = example[day + 2]
                local q = pack.questIDs[id]
                local t = BASE + day * 86400
                person.journal[#person.journal + 1] = {k = companion and "group" or "play", t = t, e = t + 3600, z = q.zone, pl = day == 1 and 1 or q.level, ol = q.level}
                person.journal[#person.journal + 1] = {k = "quest", t = t + 600, d = q.title, qid = not historical and id or nil, z = q.zone, pl = q.level, ol = q.level}
            end
            local before = snapshot(person.journal)
            for _, brief in ipairs({false, true}) do
                for retell = 0, 7 do
                    person.retell = retell
                    local days = A.JournalBook(person)
                    local function tell()
                        if companion then return A.JournalTale.Tell(person, days, "we", {name = "Rowan", race = example[1], class = example[2], faction = "Alliance"}, brief) end
                        return A.SelfTale.Tell(person, days, brief, retell)
                    end
                    local stories = tell()
                    check(snapshot(stories) == snapshot(tell()), "deterministic telling")
                    local texts = {}
                    for _, day in ipairs(days) do
                        local s = stories[day.key]
                        if s and s.text ~= "" then texts[#texts + 1] = A.JournalPlain(s.text) end
                    end
                    local joined = table.concat(texts, "\n")
                    check(#joined > 0, "rendered representative racial journey")
                    check(not joined:find("{p:", 1, true), "resolved place markup")
                    if not companion then check(not joined:find("I were", 1, true), "personal agreement") end
                    if example[1] == "NightElf" then check(not joined:find("Iverron drank", 1, true), "ingredient-only journal does not claim antidote delivered") end
                    if arg and arg[1] == "print" and retell == 0 and not historical then
                        print(example[1] .. " " .. example[2] .. (companion and " companion" or " personal") .. (brief and " Highlights" or " full") .. "\n" .. joined .. "\n")
                    end
                end
            end
            check(snapshot(person.journal) == before, "rendering leaves recorded history unchanged")
        end
    end
end
print("AllianceStories: " .. checks .. " checks; " .. count(pack.questIDs) .. " exact IDs, " .. count(pack.quests) .. " titles, " .. count(pack.zones) .. " regions")

