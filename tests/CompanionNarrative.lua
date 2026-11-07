-- Run from the client root: lua5.1 Interface/AddOns/CompanionJournal/tests/CompanionNarrative.lua
-- Retention is about adventure and relationships, not just boss victories.
local root = "Interface/AddOns/CompanionJournal/"
function time() return os.time() end
function date(fmt, t) return os.date(fmt, t) end
function CreateFrame() return setmetatable({}, {__index = function() return function() end end}) end
C_Timer = {After = function() end}
local A = {defaults = {colors = {}}, db = {people = {}}}
for _, file in ipairs({"LoreData.lua", "Lore.lua", "People.lua", "Characters.lua", "Journal.lua", "JournalBook.lua", "JournalTellers.lua", "JournalTale.lua", "JournalWords.lua", "JournalSelfWords.lua"}) do
    assert(loadfile(root .. file))("CompanionJournal", A)
end
local checks, examples = 0, {}
local function Check(ok, why) checks = checks + 1; assert(ok, why) end
local BASE = os.time({year = 2026, month = 3, day = 2, hour = 18})
local function At(day) return BASE + day * 86400 end
local function Person() return {name = "Dahlia-Forever", race = "Scourge", class = "MAGE", pronouns = "they", bond = "spouse", journal = {}} end
local function Group(p, day, zone, events)
    local t = At(day)
    p.journal[#p.journal + 1] = {k = "group", t = t, e = t + 5400, z = zone, pl = 24, ol = 23}
    for i, event in ipairs(events or {}) do
        p.journal[#p.journal + 1] = {k = event[1], d = event[2], t = t + i * 300, z = zone, pl = 24, ol = 23}
    end
end
local function Stories(p, retell, voice, player, brief)
    p.retell = retell
    local days = A.JournalBook(p)
    return A.JournalTale.Tell(p, days, voice, player, brief), days
end
local function Text(stories, day) return A.JournalPlain(stories[date("%Y-%m-%d", At(day))].text) end
local players = {}
for _, title in ipairs({"Arugal's Folly", "Prove Your Worth", "Border Crossings", "Maps and Runes", "The Decrepit Ferry", "Michael Garrett"}) do
    local scene = A.Lore.QuestStory(title)
    Check(scene and #scene.why >= 2 and #scene.after >= 2 and scene.thread and scene.importance, "early quests have distinct setup, outcome, and continuity context")
end
Check(A.Lore.QuestThread("Maps and Runes") == A.Lore.QuestThread("Border Crossings"), "Ambermill work shares a verified narrative thread")
Check(A.Lore.QuestThread("Arugal's Folly") ~= A.Lore.QuestThread("Maps and Runes"), "the two wizard plots remain distinct")
for i = 1, 300 do
    local player = {name = "Writer" .. i, race = "Scourge", faction = "Horde", class = "PRIEST"}
    local _, key = A.JournalTellers.For(player)
    players[key] = players[key] or player
end

for _, player in pairs(players) do
    for retell = 0, 7 do
        for _, voice in ipairs({"you", "we"}) do
            local p = Person()
            p.origin = "together"
            -- Intentional origin backstory precedes the captured Silverpine
            -- scenes; no early quests or level gains are invented to fill it.
            for day = 0, 19 do Group(p, day, "Silverpine Forest", {{"quest", "Maps and Runes"}}) end
            Group(p, 20, "Ashenvale", {{"quest", "Raene's Cleansing"}})
            Group(p, 21, "Ashenvale", {{"quest", "Raene's Cleansing"}})
            Group(p, 22, "Ashenvale", {{"quest", "Raene's Cleansing"}})
            local full = Stories(p, retell, voice, player, false)
            local brief, days = Stories(p, retell, voice, player, true)
            local first = Text(full, 0)
            if player == players.elder and retell == 0 and voice == "we" then examples.origin = first end
            Check(first:find("Deathknell", 1, true) and first:find("Silverpine", 1, true), "configured origin and real captured scene both present: " .. first)
            Check(full[days[1].key].text:find("\n\n", 1, true), "late start has a separate origin prologue")
            Check(not first:find("wife", 1, true) and not first:find("husband", 1, true), "neutral spouse pronouns")
            Check(not first:find("level 1", 1, true) and not first:find("level 10", 1, true), "no missing early levels fabricated")
            for day = 0, 2 do Check(#Text(brief, day) > 0, "formative session retained") end
            Check(#Text(brief, 20) > 0, "first sustained shared visit retained")
            Check(#Text(brief, 22) > 0, "trailing chores compressed into a closing bridge")
            local shortLength, longLength, omitted = 0, 0, 0
            for _, day in ipairs(days) do
                shortLength = shortLength + #brief[day.key].text
                longLength = longLength + #full[day.key].text
                if brief[day.key].text == "" then omitted = omitted + 1 end
                Check(not brief[day.key].text:find("{%a+}"), "no unresolved tokens")
            end
            Check(shortLength < longLength * 0.7 and omitted >= 8, "repeated chores compressed while adventure connections survive")
            local again = Stories(p, retell, voice, player, true)
            for _, day in ipairs(days) do Check(again[day.key].text == brief[day.key].text, "stable retelling") end
        end
    end
end

local own = {journal = {}}
A.SelfPerson = function() return own end
for retell = 0, 7 do
    local p = Person()
    Group(p, 0, "Silverpine Forest", {{"campfire"}})
    for day = 1, 8 do Group(p, day, "The Barrens", {{"quest", "Raptor Thieves"}}) end
    Group(p, 25, "Silverpine Forest", {{"quest", "Maps and Runes"}})
    local stories = Stories(p, retell, "we", players.elder, true)
    local returned = Text(stories, 25)
    if retell == 0 then examples.returned = returned end
    -- (a memory from the same month is counted in days, 2026-11-06 review: March 2 to 27)
    Check(returned:find("fire", 1, true) and returned:lower():find("four weeks before", 1, true), "return recalls the actual earlier shared scene: " .. returned)
    Check(not returned:find("remembered", 1, true) and not returned:find("missed", 1, true), "callback does not assign feelings")
    -- (from another month it names the month: March 2 to April 6)
    p = Person()
    Group(p, 0, "Silverpine Forest", {{"campfire"}})
    for day = 1, 8 do Group(p, day, "The Barrens", {{"quest", "Raptor Thieves"}}) end
    Group(p, 35, "Silverpine Forest", {{"quest", "Maps and Runes"}})
    returned = Text(Stories(p, retell, "we", players.elder, true), 35)
    Check(returned:find("fire", 1, true) and returned:find("in March", 1, true), "a return from another month names the month: " .. returned)

    p = Person()
    for day = 0, 3 do Group(p, day, "Stranglethorn Vale", {{"quest", "Raptor Mastery"}}) end
    Group(p, 4, "Stranglethorn Vale")
    own.journal = {
        {k = "gather", d = "herbs", c = 2, t = At(4) + 600},
        {k = "first", d = "landmark", z = "Gurubashi Arena", t = At(4) + 1200},
        {k = "first", d = "sunset", z = "The Savage Coast", t = At(4) + 3000},
    }
    local brief = Stories(p, retell, "you", players.wry, true)
    local quiet = Text(brief, 4)
    if retell == 0 then examples.quiet = quiet end
    local herbs, landmark, sunset = quiet:find("herbs", 1, true), quiet:find("Gurubashi Arena", 1, true), quiet:find("sun went down", 1, true)
    Check(herbs and landmark and sunset, "quiet relationship day keeps gathering and discoveries: " .. quiet)
    Check(herbs < landmark and landmark < sunset, "shared quiet scenes retain recorded order")
    Check(not quiet:find("no hurry", 1, true) and not quiet:find("nowhere to be", 1, true), "absence of quests does not invent a motive")
    own.journal = {}
end

for retell = 0, 7 do
    local p = Person()
    Group(p, 0, "Silverpine Forest", {{"quest", "Border Crossings"}, {"quest", "Prove Your Worth"}, {"quest", "Arugal's Folly"}})
    Group(p, 2, "Silverpine Forest", {{"quest", "Maps and Runes"}, {"quest", "Dalar's Analysis"}})
    Group(p, 4, "Silverpine Forest", {{"quest", "Dalaran's Intentions"}})
    Group(p, 6, "Silverpine Forest", {{"quest", "Ambermill Investigations"}})
    Group(p, 8, "Silverpine Forest", {{"quest", "The Weaver"}})
    local stories = Stories(p, retell, "we", players.chronicler, true)
    local opening = Text(stories, 0)
    local enquiry = Text(stories, 2)
    local outcome = Text(stories, 8)
    Check(A.QuestDeeds.Shows(opening, nil, "Border Crossings") or A.QuestDeeds.Shows(opening, nil, "Prove Your Worth")
        or A.QuestDeeds.Shows(opening, nil, "Arugal's Folly"), "the first day's work is told: " .. opening)
    -- (2026-11-07, DESIGN §3.0: the companion book no longer retells the stage's pack exposition, so
    -- the thread callback and the authored outcome belong to the own book; here each day's work is
    -- still told, from its own stages)
    Check(A.QuestDeeds.Shows(enquiry, nil, "Maps and Runes") or A.QuestDeeds.Shows(enquiry, nil, "Dalar's Analysis"), "the next recorded work is told: " .. enquiry)
    -- (Highlights may bridge a quiet day of work; Everything tells it)
    local outcomeFull = Text((Stories(p, retell, "we", players.chronicler, false)), 8)
    Check(A.QuestDeeds.Shows(outcomeFull, nil, "The Weaver"), "the terminal quest is told: " .. outcomeFull)
    Check(not opening:find("Arugal's head", 1, true) and not opening:find("Arugal died", 1, true), "ambiguous chain title never invents the final victory")
    if retell == 0 then examples.quest = opening .. "\n\n" .. enquiry .. "\n\n" .. outcome end

    -- A personal observation during a group interval is not a conversation
    -- shared by both adventurers. Outside that interval it is not shared at all.
    p = Person()
    Group(p, 0, "Undercity")
    own.journal = {{k = "first", d = "notable", n = "Lady Sylvanas Windrunner", z = "Undercity", t = At(0) + 300}}
    stories = Stories(p, retell, "we", players.chronicler, true)
    local encounter = Text(stories, 0)
    Check(encounter:find("I saw Lady Sylvanas", 1, true), "personal sighting remains personal within companion travels")
    Check(encounter:find("Forsaken", 1, true) or encounter:find("Lordaeron", 1, true), "sighting explains the actual notable figure")
    Check(not encounter:find("spoke", 1, true) and not encounter:find("we saw", 1, true), "sighting does not invent dialogue or companion observation")
    own.journal[1].interaction = true
    stories = Stories(p, retell, "we", players.chronicler, true)
    Check(Text(stories, 0):find("I spoke with Lady Sylvanas", 1, true), "an actual personal interaction may be stated")
    own.journal[1].t = At(0) - 7200
    stories = Stories(p, retell, "we", players.chronicler, true)
    -- (the Undercity's own scene may name its ruler, 8b75117; the sighting and its lore may not)
    local outside = Text(stories, 0)
    Check(not outside:find("saw Lady Sylvanas", 1, true) and not outside:find("spoke with Lady Sylvanas", 1, true), "observation outside group time is not included: " .. outside)
    for _, line in ipairs(A.SelfWords.notableNPCs["Lady Sylvanas Windrunner"]) do
        Check(not outside:find(line, 1, true), "a sighting outside group time brings no lore line: " .. outside)
    end
    own.journal = {}
end

local lines = {
    "You and Dahlia travelled through the hills for an hour, with the ruins above the valley and the forest stretching away below. Four quests were completed before you reached the keep at the edge of the forest.",
    "You entered Shadowfang Keep. Arugal won the first fight.",
    "Dahlia brought you back from death.",
    "Later you rested at the inn.",
}
local paragraphs = A.JournalTale.Paragraphs(lines, {"day", "dungeon", "rez", "rest"})
Check(paragraphs:find("\n\nYou entered", 1, true), "substantial setting separates from conflict")
Check(paragraphs:find("fight. Dahlia brought", 1, true), "rescue stays with its conflict")
Check(paragraphs:gsub("\n\n", " ") == table.concat(lines, " "), "paragraphs preserve every sentence and its order")
Check(not A.JournalTale.Paragraphs({"You travelled together.", "You rested."}, {"day", "rest"}):find("\n", 1, true), "short chapter remains compact")
io.write("PASS: " .. checks .. " companion narrative assertions\n")
if arg and arg[1] == "--examples" then
    for _, key in ipairs({"origin", "quiet", "returned", "quest"}) do io.write("\n" .. key .. "\n" .. (examples[key] or "") .. "\n") end
end
