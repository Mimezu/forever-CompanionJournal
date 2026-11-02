-- Real self/companion tellers: exact investigation stages and ambient visits.
-- Run from the client root with Lua 5.1; optional "print" shows selected samples.
local root = "Interface/AddOns/CompanionJournal/"
function time(t) return type(t) == "table" and os.time(t) or 1792000000 end
function date(fmt, t) return os.date(fmt, t) end
local A, count = {defaults = {colors = {}}}, 0
for _, name in ipairs({"LoreData.lua", "Lore.lua", "LoreHordeStories.lua", "LoreAllianceStories.lua", "LoreWorldStories.lua",
    "LoreClassStories.lua", "JournalBook.lua", "JournalTellers.lua", "JournalTale.lua", "JournalWords.lua", "JournalSelfWords.lua", "JournalSelfTale.lua"}) do
    assert(loadfile(root .. name))("CompanionJournal", A)
end
local function Check(ok, why) count = count + 1; assert(ok, why) end
local function Has(text, part) return text:lower():find(part:lower(), 1, true) ~= nil end
local function None(text, parts)
    for _, part in ipairs(parts) do if Has(text, part) then return false, part end end
    return true
end
local function Snapshot(value)
    if type(value) ~= "table" then return type(value) .. ":" .. tostring(value) end
    local keys, out = {}, {}
    for k in pairs(value) do keys[#keys + 1] = k end
    table.sort(keys, function(a,b) return tostring(a) < tostring(b) end)
    for _, k in ipairs(keys) do out[#out + 1] = Snapshot(k) .. "=" .. Snapshot(value[k]) end
    return "{" .. table.concat(out, ",") .. "}"
end
local BASE = os.time({year = 2026, month = 10, day = 2, hour = 18})
local player = {name = "Reader", race = "Human", class = "WARRIOR", faction = "Alliance"}
local function Person(zone, events, companion, horde)
    local p = {name = "Investigator", charKey = "investigation-test", race = horde and "Orc" or "Human", class = "WARRIOR",
        faction = horde and "Horde" or "Alliance", self = not companion, startLevel = 20, pronouns = "they", bond = "friend", journal = {}}
    p.journal[1] = {k = companion and "group" or "play", t = BASE, e = BASE + 3600, z = zone, pl = 28, ol = 28}
    for i, event in ipairs(events) do
        local e = {t = BASE + 120 * i, z = zone, pl = 28, ol = 28}
        for k, v in pairs(event) do e[k] = v end
        p.journal[#p.journal + 1] = e
    end
    return p
end
local function Render(p, companion, brief, retell)
    p.retell = retell
    local days = A.JournalBook(p)
    local stories = companion and A.JournalTale.Tell(p, days, "we", player, brief) or A.SelfTale.Tell(p, days, brief, retell)
    local out = {}
    for _, day in ipairs(days) do if stories[day.key] then out[#out + 1] = A.JournalPlain(stories[day.key].text) end end
    return table.concat(out, "\n")
end
local stalvan = "The Legend of Stalvan"
local hidden = "Hidden Enemies"
-- Each expected noun/action distinguishes the actual completed step from the
-- shared title. Negative endings are checked across every rendered retell.
local cases = {
    {66, stalvan, "clerk"}, {67, stalvan, "footlocker"}, {68, stalvan, "Daltry"},
    {69, stalvan, "Farley"}, {70, stalvan, "Folsom"}, {72, stalvan, "crate"},
    {74, stalvan, "Haggard"}, {75, stalvan, "page"}, {78, stalvan, "handwriting"},
    {79, stalvan, "Ebonlocke"}, {80, stalvan, "match"}, {97, stalvan, "confirmation"},
    {98, stalvan, "Madame Eva"},
    {5726, hidden, "insignia"}, {5727, hidden, "Thrall"}, {5728, hidden, "slain"},
    {5729, hidden, "Neeru"}, {5730, hidden, "investigat"},
}
for _, row in ipairs(cases) do
    local id, title = row[1], row[2]
    local q = assert(A.Lore.QuestStory(title, id), "missing exact context " .. id)
    Check(q.title == title and q ~= A.Lore.QuestStory(title), "exact stage is selected instead of title " .. id)
    Check(Has(table.concat(q.after, " "), row[3]), "supported stage outcome " .. id)
    local forbidden = {"Tilloa", "Giles", "murderous obsession"}
    if title == stalvan and id ~= 98 then
        forbidden[#forbidden + 1] = "Stalvan was dead"
        forbidden[#forbidden + 1] = "killing days were over"
        forbidden[#forbidden + 1] = "Stalvan's family ring"
    elseif title == hidden and id ~= 5730 then
        forbidden[#forbidden + 1] = "Ashenvale"
    end
    if title == hidden and id < 5728 then
        forbidden[#forbidden + 1] = "Bazzalan and Jergosh were slain"
        forbidden[#forbidden + 1] = "leaders' deaths"
    end
    if title == hidden and id == 5726 then forbidden[#forbidden + 1] = "Neeru" end
    if title == stalvan and id < 79 then forbidden[#forbidden + 1] = "guilt" end
    if title == stalvan and id < 72 then forbidden[#forbidden + 1] = "massacre" end
    for _, companion in ipairs({false, true}) do
        local p = Person(q.zone, {{k = "quest", d = title, qid = id}}, companion, title == hidden)
        local before = Snapshot(p.journal)
        local fullText = {}
        for _, brief in ipairs({false, true}) do
            local rendered = {}
            for retell = 0, 5 do
                local out = Render(p, companion, brief, retell)
                rendered[#rendered + 1] = out
                if not brief then fullText[#fullText + 1] = out end
            end
            local joined = table.concat(rendered, "\n")
            Check(#joined > 0 and None(joined, forbidden), "rendered stage stays within evidence " .. id .. "/" .. tostring(companion) .. "/" .. tostring(brief))
        end
        Check(Has(table.concat(fullText, "\n"), row[3]), "actual teller retains stage result " .. id .. "/" .. tostring(companion))
        Check(before == Snapshot(p.journal), "teller keeps history read-only " .. id)
        Check(Render(p, companion, false, 0) == Render(p, companion, false, 0), "deterministic stage telling " .. id)
        if arg and arg[1] == "print" and not companion and (id == 66 or id == 78 or id == 98 or id == 5726 or id == 5728 or id == 5730) then
            print(id .. "\n" .. Render(p, companion, false, 0) .. "\n")
        end
    end
end

for _, title in ipairs({stalvan, hidden}) do
    local titleContext = A.Lore.QuestStory(title)
    local bad = title == stalvan and {"execution", "Stalvan was dead", "family ring", "handwriting matched"}
        or {"Neeru", "Bazzalan", "Jergosh", "Ashenvale"}
    Check(None(table.concat(titleContext.why, " ") .. " " .. table.concat(titleContext.after, " "), bad), "conservative title storyteller context " .. title)
    for _, companion in ipairs({false, true}) do
        local p = Person(title == stalvan and "Duskwood" or "Orgrimmar", {{k = "quest", d = title}}, companion, title == hidden)
        local results = {}
        for _, brief in ipairs({false, true}) do for retell = 0, 7 do results[#results + 1] = Render(p, companion, brief, retell) end end
        Check(None(table.concat(results, "\n"), bad), "title-only actual teller cannot select final stage " .. title)
    end
    local wrong = A.Lore.QuestStory(title, title == stalvan and 5730 or 98)
    Check(wrong == titleContext, "mismatched quest ID falls back safely " .. title)
end

-- Visits and a single observed boss victory do not imply an optional quest,
-- a different creature's death, or the discovery of Maur's corpse.
for _, boss in ipairs({false, "Oggleflint", "Taragaman the Hungerer"}) do
    for _, companion in ipairs({false, true}) do
        local events = {{k = "dungeon", d = "Ragefire Chasm"}}
        if boss then events[#events + 1] = {k = "boss", d = boss, n = 5} end
        local p = Person("Ragefire Chasm", events, companion, true)
        local results = {}
        for _, brief in ipairs({false, true}) do for retell = 0, 15 do results[#results + 1] = Render(p, companion, brief, retell) end end
        Check(None(table.concat(results, "\n"), {"Neeru", "Shadow Council", "Dark Lady", "spell books", "Maur", "Jergosh were slain", "Bazzalan were slain", "Ashenvale"}),
            "Ragefire ambient narrative cannot grant commissions or discoveries " .. tostring(boss) .. "/" .. tostring(companion))
    end
end
print("InvestigationStories: " .. count .. " assertions passed")
