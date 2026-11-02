-- Run from the client root: lua5.1 Interface/AddOns/CompanionJournal/tests/Words.lua
-- Every line of every pool, not only the ones a fixture happens to reach: no
-- meta words, no colons, no morals, balanced markup, alphabetic tokens; and
-- the lore (dungeons, zones, quests, bosses) never speaks of the player.
local root = "Interface/AddOns/CompanionJournal/"
local assertions = 0
local failures = {}
local function check(value, message) assertions = assertions + 1; if not value then failures[#failures + 1] = message end end

function time() return os.time() end
function date(fmt, t) return os.date(fmt, t) end
function CreateFrame() return setmetatable({}, {__index = function() return function() end end}) end
C_Timer = {After = function() end}
local A = {defaults = {colors = {}}}
for _, file in ipairs({"LoreData.lua", "Lore.lua", "JournalBook.lua", "JournalTellers.lua", "JournalTale.lua", "JournalWords.lua",
    "JournalSelfWords.lua", "JournalSelfTale.lua"}) do
    assert(loadfile(root .. file))("CompanionJournal", A)
end

local META = {"journal", "tale", "story", "stories", "song", "songs", "verse", "record", "chronicle", "legend", "bard"}
local MORALS = {"the telling", "deed.*glory", "would not trade", "worth the telling", "ends in glory", "hear how"}
local function Walk(value, path, visit)
    if type(value) == "string" then visit(value, path)
    elseif type(value) == "table" then
        for key, v in pairs(value) do Walk(v, path .. "." .. tostring(key), visit) end
    end
end
local function Line(line, path)
    local plain = line:gsub("{%a:[^}]*}", "X")
    local low = plain:lower()
    -- (a name written in by hand: "went into the journal" is literal there)
    for _, word in ipairs(path:find("meetAdded", 1, true) and {} or META) do
        check(not low:find("%f[%a]" .. word .. "%f[%A]"), "no meta word '" .. word .. "' in " .. path .. ": " .. line)
    end
    for _, moral in ipairs(MORALS) do check(not low:find(moral), "no moral in " .. path .. ": " .. line) end
    check(not plain:find(":", 1, true) or path:find("SI", 1, true), "no colon in " .. path .. ": " .. line)
    check(not plain:find("?", 1, true), "no question in " .. path .. ": " .. line)
    local open, close = 0, 0
    for _ in line:gmatch("{") do open = open + 1 end
    for _ in line:gmatch("}") do close = close + 1 end
    check(open == close, "balanced braces in " .. path .. ": " .. line)
    for token in line:gmatch("{([^}]*)}") do
        check(token:match("^%a+$") or token:match("^%a:"), "a plain token in " .. path .. ": {" .. token .. "}")
    end
end
-- (the pools: settings such as mix = 0.3 are numbers and are skipped by Walk)
Walk(A.SelfWords, "W", Line)
Walk(A.JournalTale.phrases, "PB", Line)
for key, persona in pairs(A.JournalTellers) do if type(persona) == "table" and key ~= "order" then Walk(persona, "teller." .. tostring(key), Line) end end
-- The lore is about the world, never the player.
local function Lore(line, path)
    Line(line, path)
    local plain = line:gsub("{%a:[^}]*}", "X")
    check(not plain:find("%f[%a][Yy]ou%f[%A]") and not plain:find("%f[%a][Yy]our%f[%A]"), "no 'you' in lore " .. path .. ": " .. line)
    check(not plain:find("^I ") and not plain:find(" I ") and not plain:find("%f[%a]me%f[%A]") and not plain:find("%f[%a]my%f[%A]"),
        "no 'I' in lore " .. path .. ": " .. line)
    check(not plain:find("%f[%a][Ww]e%f[%A]") and not plain:find("%f[%a]us%f[%A]"), "no 'we' in lore " .. path .. ": " .. line)
end
local L = A.Lore
for name, story in pairs(L.dungeonStory) do
    for key, value in pairs(story) do
        -- (the race and class versions are your own journal's: they may say "I")
        if key:find("Race$") or key:find("Class$") or key:find("RaceC$") then Walk(value, "dungeonStory." .. name .. "." .. key, Line)
        elseif key ~= "wings" and key ~= "source" and key ~= "setting" then Walk(value, "dungeonStory." .. name .. "." .. key, Lore) end
    end
    for _, wing in ipairs(story.wings or {}) do Walk(wing.inside, "wing.inside", Lore); Walk(wing.detail, "wing.detail", Lore) end
end
for name, story in pairs(L.zoneStory) do Walk(story, "zoneStory." .. name, Lore) end
for name, story in pairs(L.questStory) do
    Walk(story.why, "questStory." .. name .. ".why", Lore)
    Walk(story.after, "questStory." .. name .. ".after", Lore)
end
for name, boss in pairs(L.bosses) do
    if type(boss) == "table" then
        if boss.after then Lore(boss.after, "boss." .. name .. ".after") end
        if type(boss.e) == "string" then Lore(boss.e, "boss." .. name .. ".e") end
    end
end

if #failures > 0 then error(#failures .. " failures:\n" .. table.concat(failures, "\n")) end
io.write("PASS: " .. assertions .. " word assertions\n")
