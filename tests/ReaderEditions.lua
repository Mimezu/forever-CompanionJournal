local root, A = "Interface/AddOns/CompanionJournal/", {defaults = {colors = {}}}
time, date = os.time, os.date
for _, file in ipairs({"LoreData.lua", "Lore.lua", "LoreHordeStories.lua", "LoreAllianceStories.lua", "LoreWorldStories.lua", "LoreClassStories.lua",
    "JournalBook.lua", "JournalTellers.lua", "JournalTale.lua", "JournalWords.lua", "JournalSelfWords.lua", "JournalSelfTale.lua", "JournalReader.lua"}) do
    assert(loadfile(root .. file))("CompanionJournal", A)
end
local R, checks = A.JournalReader, 0
local function check(ok, message) checks = checks + 1; assert(ok, message) end
local base = os.time({year = 2026, month = 10, day = 1, hour = 15})
local function journal(companion)
    local p = {self = not companion, charKey = "nara", name = companion and "Aster" or "Nara", race = "Tauren", class = "SHAMAN",
        faction = "Horde", pronouns = "they", bond = "spouse", origin = "together", startLevel = 1, journal = {}}
    for i, pair in ipairs({{"Mulgore", 1519}, {"Mulgore", 1520}, {"Thunder Bluff", 6362}, {"Mulgore", 1521}}) do
        local t = base + (i - 1) * 86400
        p.journal[#p.journal + 1] = {k = companion and "group" or "play", t = t, e = t + 3600, z = pair[1], pl = 4, ol = 4}
        p.journal[#p.journal + 1] = {k = "quest", t = t + 600, d = A.Lore.questStoryIDs[pair[2]].title, qid = pair[2], z = pair[1]}
    end
    return p
end
local function serialize(t)
    if type(t) ~= "table" then return tostring(t) end
    local keys, out = {}, {}; for key in pairs(t) do keys[#keys + 1] = key end
    table.sort(keys, function(a,b) return tostring(a) < tostring(b) end)
    for _, key in ipairs(keys) do out[#out + 1] = tostring(key) .. "=" .. serialize(t[key]) end
    return "{" .. table.concat(out, ",") .. "}"
end
local function outcome(text, id)
    for _, line in ipairs(A.Lore.questStoryIDs[id].after) do if text:find(line, 1, true) then return true end end
end
for _, companion in ipairs({false, true}) do
    local p = journal(companion)
    local before = serialize(p)
    for _, edition in ipairs({"tale", "ours", "fire"}) do
        local chapters, story = R.Build(p, edition, journal(false))
        local text, last = {}, 0
        check(#chapters >= 3, "distinct places form chapters")
        for _, chapter in ipairs(chapters) do
            check(chapter.day.t >= last, "chapters remain chronological")
            last = chapter.day.t
            check(chapter.day.sourceDay ~= nil, "source day available for links")
            text[#text + 1] = story(chapter.day).text
        end
        text = table.concat(text, "\n\n")
        -- (2026-11-07, DESIGN §3.0: every edition tells the rite, in its stages' own words or by name;
        -- not necessarily each stage's authored outcome)
        check(A.QuestDeeds.Shows(text, 1519) or A.QuestDeeds.Shows(text, 1520) or A.QuestDeeds.Shows(text, 1521), "recorded rite told in every edition")
        check(not text:find("{%a+}"), "no unresolved tokens")
        if companion then check(not text:find("wife", 1, true) and not text:find("husband", 1, true), "neutral relationship preserved") end
        if edition == "fire" then check(#chapters == 4, "fireside keeps individual sessions")
        else check(#chapters == 3, "adjacent sessions in one place can become one chapter") end
        check(serialize(p) == before, "reading never mutates journal/person")
        local again, repeated = R.Build(p, edition, journal(false))
        check(story(chapters[1].day).text == repeated(again[1].day).text, "switching editions does not reroll")
    end
    table.remove(p.journal); table.remove(p.journal)
    local chapters, story = R.Build(p, "tale", journal(false))
    local text = {}; for _, chapter in ipairs(chapters) do text[#text + 1] = story(chapter.day).text end
    check(not outcome(table.concat(text, " "), 1521), "missing final rite remains unknown")
end
local p = journal(false)
-- Several chapters from one evening must not manufacture extra days.
for _, companion in ipairs({false, true}) do
    local sameDay = journal(companion)
    for i, entry in ipairs(sameDay.journal) do
        local outing = math.floor((i - 1) / 2)
        entry.t = base + outing * 4000 + (i % 2 == 0 and 600 or 0)
        if entry.e then entry.e = entry.t + 3600 end
    end
    for retell = 0, 9 do
        sameDay.retell = retell
        local chapters, story = R.Build(sameDay, "tale", journal(false))
        local text = {}; for _, chapter in ipairs(chapters) do text[#text + 1] = story(chapter.day).text end
        text = table.concat(text, " "):lower()
        check(not text:find("the next day", 1, true) and not text:find("a day later", 1, true), "chapter break is not a new day")
    end
end
p.journal = {}; check(#(R.Build(p, "fire")) == 0, "empty history stays empty")
local source = {{key = "one", t = base, scenes = {{zone = "Mulgore", t = base}, {zone = "Thunder Bluff", t = base + 1}, {zone = "Mulgore", t = base + 2}}}}
local episodes = R.Episodes(source)
check(#episodes == 3 and episodes[3].region == "Mulgore", "return visit is not moved before departure")
check(episodes[1].key ~= episodes[3].key, "same-day episodes have unique IDs")
local alt, current = journal(true), journal(true)
alt.name, current.name = "Alt's companion", "Current companion"
A.db = {characters = {alt = {people = {altfriend = {}}}, current = {people = {currentfriend = {}}}}}
A.Me = function() return "current" end
A.PersonAs = function(key, owner) return owner == "alt" and key == "altfriend" and alt or current end
local choices = R.Companions({self = true, charKey = "alt"})
check(#choices == 1 and choices[1].person == alt, "Our story belongs to the journal's owner")
check(#R.Companions({self = true, charKey = "missing"}) == 0, "missing character does not borrow current companions")
check(R.Valid("bad") == "original", "invalid preference falls back safely")
print("ReaderEditions: " .. checks .. " checks passed")
