-- Run from the client root: lua Interface/AddOns/CompanionJournal/tests/Journal.lua
-- Journal: nothing recorded while off; outings, dungeons, bosses, quests done
-- together (not every quest turned in while grouped), crossing paths, levels,
-- your own lines; groupmates kept aside until you add them (or forgotten); the
-- chronicle text; faction/class.
local root = "Interface/AddOns/CompanionJournal/"
local assertions = 0
local function check(value, message) assertions = assertions + 1; assert(value, message) end

local methods = {}
local function Object()
    local object = {scripts = {}, events = {}}
    return setmetatable(object, {__index = function(_, key)
        if methods[key] then return methods[key] end
        if type(key) == "string" and key:match("^[A-Z]") then return function(self) return self end end
    end})
end
function methods:SetScript(key, fn) self.scripts[key] = fn end
function methods:RegisterEvent(event) self.events[event] = true end
function methods:UnregisterEvent(event) self.events[event] = nil end
local frames = {}
function CreateFrame() local f = Object(); frames[#frames + 1] = f; return f end
UIParent = Object()
local clock = 1000000
function time() return clock end
function GetTime() return clock end
function date(fmt, t) return os.date(fmt, t or clock) end
local zone = "Elwynn Forest"
function GetRealZoneText() return zone end
function GetNormalizedRealmName() return "Forever" end
function GetRealmName() return "Forever" end
C_Timer = {After = function(_, fn) fn() end}
local inInstance, instanceName = false, nil
function IsInInstance() return inInstance, inInstance and "party" or "none" end
function GetInstanceInfo() return instanceName end
print = function() end

local members, inGroup = {}, false
function IsInGroup() return inGroup end
function IsInRaid() return false end
function GetNumGroupMembers() return inGroup and (#members + 1) or 0 end
function GetNumSubgroupMembers() return inGroup and #members or 0 end
function UnitIsUnit() return false end
function UnitIsPlayer() return true end
function UnitGUID(unit) return unit == "player" and "Player-1-00000001" or nil end
local units = {}
local function Member(unit) return units[unit] or members[tonumber(unit:match("%d+") or 0)] end
function UnitFullName(unit) local m = Member(unit); if m then return m[1], "Forever" end end
function UnitClass(unit) local m = Member(unit); if m then return m[2], m[2] end end
function UnitLevel(unit) local m = Member(unit); return m and m[3] or 0 end
function UnitFactionGroup(unit)
    if unit == "player" then return "Horde" end
    local m = Member(unit); return m and m[4] or nil
end

-- Your quest log (after a header), which quests are done, and who has them.
local titles = {[7] = "The Defias Brotherhood", [8] = "Camping 101", [9] = "Hidden Enemies", [10] = "Vile Familiars", [11] = "A Letter"}
local questLog, complete, onQuest = {}, {}, {}
C_QuestLog = {
    GetTitleForQuestID = function(id) return titles[id] end,
    GetNumQuestLogEntries = function() return #questLog + 1, #questLog end,
    GetInfo = function(i)
        if i == 1 then return {title = "Elwynn Forest", isHeader = true} end
        return questLog[i - 1] and {questID = questLog[i - 1], isHeader = false} or nil
    end,
    IsComplete = function(id) return complete[id] == true end,
    IsUnitOnQuest = function(unit, id)
        local m = Member(unit)
        return m ~= nil and onQuest[m[1]] ~= nil and onQuest[m[1]][id] == true
    end,
}

local A = {defaults = {colors = {}}}
for _, file in ipairs({"People.lua", "Characters.lua", "GroupPrompt.lua", "Journal.lua"}) do
    assert(loadfile(root .. file))("ForeverNames", A)
end
A.Refresh = function() end
local db = {enabled = true, colors = {people = {1, 1, 1}, groupmate = {0.5, 0.8, 1}}}
for key, value in pairs(A.defaults) do if db[key] == nil then db[key] = value end end
A.db = db
A.InitPeople()
-- The newest journal event frame (a simulated /reload makes a second one).
local function Events()
    for i = #frames, 1, -1 do if frames[i].events.ENCOUNTER_END then return frames[i] end end
end
local function Kinds(journal)
    local kinds = {}
    for _, entry in ipairs(journal or {}) do kinds[#kinds + 1] = entry.k end
    return table.concat(kinds, ",")
end
local function Aside(key) return db.journalAside and db.journalAside[key] end

-- People in the list; a stranger who is not.
local aeryn = A.AddPerson("Aeryn")
local brom = A.AddPerson("Brom")
check(aeryn.faction == "Horde", "people you add yourself get your faction")
members = {{"Aeryn", "MAGE", 20, "Horde"}, {"Brom", "WARRIOR", 21, "Horde"}, {"Stranger", "ROGUE", 19, "Horde"}}

-- 1. Off: nothing is recorded or kept aside, and no events are registered.
inGroup = true
A.UpdatePeopleHooks()
check(Events() == nil or not Events().events.ENCOUNTER_END, "no journal events while off")
A.JournalGroupChanged(); A.JournalBoss("Hogger"); A.JournalQuest(7)
check(aeryn.journal == nil and db.journalAside == nil, "nothing recorded while off")

-- 2. On: an outing starts for known people (with class and level); the
-- stranger's is kept aside, not added to your list.
db.peopleJournal = true
A.UpdatePeopleHooks()
local journalFrame = Events()
local function Fire(event, ...) journalFrame.scripts.OnEvent(journalFrame, event, ...) end
local function TurnIn(id)
    Fire("QUEST_TURNED_IN", id, 0, 0); Fire("QUEST_REMOVED", id, false)
    for i = #questLog, 1, -1 do if questLog[i] == id then table.remove(questLog, i) end end
    complete[id] = nil
end
check(journalFrame and journalFrame.events.QUEST_TURNED_IN and journalFrame.events.UNIT_QUEST_LOG_CHANGED, "journal events registered while on")
check(aeryn.journal and aeryn.journal[1].k == "group", "outing opened")
check(aeryn.class == "MAGE" and aeryn.level == 20 and aeryn.faction == "Horde", "class, level and faction from the group")
check(db.people["stranger-forever"] == nil, "strangers are not added by the journal")
check(Aside("stranger-forever") and Kinds(Aside("stranger-forever").journal) == "group", "a stranger's outing is kept aside")

-- 3. Dungeon (once), bosses; quests only with those who had them too.
inInstance, instanceName, zone = true, "The Deadmines", "The Deadmines"
A.JournalInstanceCheck(); A.JournalInstanceCheck()
A.JournalBoss("Rhahk'Zor"); A.JournalBoss("Sneed")
-- 7: Aeryn and the stranger have it too. 8: yours alone. 9: Aeryn's too, turned in later.
questLog = {7, 8, 9}
onQuest = {Aeryn = {[7] = true, [9] = true}, Stranger = {[7] = true}}
Fire("QUEST_ACCEPTED", 8)
Fire("UNIT_QUEST_LOG_CHANGED", "party1")
complete[7], complete[8], complete[9] = true, true, true
Fire("UNIT_QUEST_LOG_CHANGED", "player")
TurnIn(7); TurnIn(8)
check(Kinds(aeryn.journal) == "group,dungeon,boss,boss,quest", "dungeon once, two bosses, one quest: " .. Kinds(aeryn.journal))
check(aeryn.journal[5].d == "The Defias Brotherhood", "the quest Aeryn had too, not yours alone")
check(aeryn.journal[5].qid == 7, "shared quest records preserve exact quest IDs")
check(Kinds(brom.journal) == "group,dungeon,boss,boss", "Brom had neither quest: " .. Kinds(brom.journal))
check(Kinds(Aside("stranger-forever").journal) == "group,dungeon,boss,boss,quest", "kept aside the same way")
-- Your own level-up while together: in everyone's journal, as yours (not theirs).
Fire("PLAYER_LEVEL_UP", 21)
for _, holder in ipairs({aeryn, brom, Aside("stranger-forever")}) do
    local last = holder.journal[#holder.journal]
    check(last.k == "mylevel" and last.d == 21, "your level-up is kept with " .. tostring(holder.name))
    table.remove(holder.journal) -- (the checks below count the entries)
end

-- 3b. A /reload inside: the outings go on, the dungeon is not written twice,
-- and quest 9 (done together) is still remembered.
Fire("PLAYER_LOGOUT")
assert(loadfile(root .. "Journal.lua"))("ForeverNames", A)
A.UpdateJournalEvents()
journalFrame = Events()
check(aeryn.journal[1].e == nil and Kinds(aeryn.journal) == "group,dungeon,boss,boss,quest", "same outing after a reload: " .. Kinds(aeryn.journal))
check(Kinds(Aside("stranger-forever").journal) == "group,dungeon,boss,boss,quest", "the kept-aside outing goes on too")

-- 4. Crossing paths is skipped while you travel together.
A.JournalSeen(aeryn)
check(#aeryn.journal == 5, "no crossed-paths line during an outing")

-- 5. Leaving closes the outing with its length. Quest 9 was done while Aeryn
-- was with you: it is hers too when you turn it in after she left.
clock = clock + 5400
inInstance, zone = false, "Westfall"
members = {{"Brom", "WARRIOR", 21, "Horde"}}
A.JournalGroupChanged()
check(aeryn.journal[1].e == clock and brom.journal[1].e == nil, "Aeryn's outing closed; Brom still travelling")
check(Aside("stranger-forever").left == clock, "the stranger's memories wait for your choice")
zone = "Orgrimmar"
TurnIn(9)
check(Kinds(aeryn.journal) == "group,dungeon,boss,boss,quest,quest" and aeryn.journal[6].d == "Hidden Enemies", "done together, turned in after she left: " .. Kinds(aeryn.journal))
check(Kinds(brom.journal) == "group,dungeon,boss,boss", "Brom never had it")
zone = "Westfall"

-- 6. Crossing paths later: one line per zone, merged within hours.
clock = clock + 600
A.JournalSeen(aeryn)
check(aeryn.journal[#aeryn.journal].k == "seen", "crossed paths recorded")
clock = clock + 600
A.JournalSeen(aeryn)
check(aeryn.journal[#aeryn.journal].c == 2 and #aeryn.journal == 7, "second sighting merges into the same line")

-- 7. Levels you witness.
units.nameplate1 = {"Aeryn", "MAGE", 22, "Horde"}
clock = clock + 400
A.UpdatePersonFromUnit(aeryn, "nameplate1", true)
check(aeryn.level == 22 and aeryn.journal[#aeryn.journal].k == "level" and aeryn.journal[#aeryn.journal].d == 22, "level-up noted")

-- 8. Your own lines, and removing a line.
local line = A.JournalWrite(aeryn, "  She saved me from the Defias.  ")
check(line and line.d == "She saved me from the Defias.", "custom line trimmed")
check(A.JournalWrite(aeryn, "   ") == nil, "empty line ignored")
local before = #aeryn.journal
A.JournalRemove(aeryn, line)
check(#aeryn.journal == before - 1, "line removed")

-- 9. The chronicle: consecutive bosses and quests read as one sentence.
local function Chronicle(person)
    local text = {}
    for _, day in ipairs(A.JournalChapters(person)) do
        for _, item in ipairs(day.lines) do text[#text + 1] = item.text end
    end
    return text
end
local all = table.concat(Chronicle(aeryn), "\n")
check(all:find("You wrote Aeryn into this journal.", 1, true), "journal opens with how they entered it")
check(all:find("for 1 hour 30 minutes", 1, true), "outing length in words")
check(all:find("You ventured into The Deadmines side by side.", 1, true), "dungeon sentence")
check(all:find("Together you defeated Rhahk'Zor and Sneed in The Deadmines.", 1, true), "bosses merged")
check(all:find("The Defias Brotherhood", 1, true) and all:find("Hidden Enemies", 1, true), "quests done together")
check(not all:find("Camping 101", 1, true), "not a quest only you had")
check(all:find("(2 times)", 1, true), "merged sightings counted")
check(all:find("Aeryn had grown to level 22.", 1, true), "level sentence")

-- 10. Adding the stranger (after the group): what was kept aside starts
-- their journal, and you met when you first grouped.
local stranger = A.AddPerson("Stranger")
check(Aside("stranger-forever") == nil, "nothing left aside once added")
check(Kinds(stranger.journal) == "group,dungeon,boss,boss,quest", "their journal starts with the outing: " .. Kinds(stranger.journal))
check(stranger.met == stranger.journal[1].t and stranger.metZone == "Elwynn Forest" and stranger.metHow == nil, "met when you first grouped")
local opening = Chronicle(stranger)[1]
check(opening == "You first met Stranger in Elwynn Forest while grouped.", "their chronicle opens with how you met: " .. tostring(opening))

-- 11. Not added: forgotten when you say so, or an hour after you part (kept
-- while the group prompt still asks about them).
members = {{"Brom", "WARRIOR", 21, "Horde"}, {"Passerby", "PRIEST", 18, "Horde"}, {"Wanderer", "HUNTER", 18, "Horde"}}
A.JournalGroupChanged()
check(Aside("passerby-forever") and Aside("wanderer-forever"), "new groupmates kept aside")
members = {{"Brom", "WARRIOR", 21, "Horde"}}
A.JournalGroupChanged()
A.JournalForget("passerby-forever")
check(Aside("passerby-forever") == nil and Aside("wanderer-forever") ~= nil, "don't add: forgotten at once; undecided: kept")
clock = clock + 3700
local realQueued = A.GroupPromptQueued
A.GroupPromptQueued = function(key) return key == "wanderer-forever" end
A.JournalGroupChanged()
check(Aside("wanderer-forever") ~= nil, "still in the group prompt: kept")
A.GroupPromptQueued = realQueued
A.JournalGroupChanged()
check(Aside("wanderer-forever") == nil and db.journalAside == nil, "undecided: forgotten an hour after parting")

-- 12. A quest you finished alone stays yours, even if a companion has it
-- when you turn it in.
inGroup, members = false, {}
A.JournalGroupChanged()
questLog, complete[10] = {10}, true
onQuest = {Aeryn = {[10] = true}}
inGroup, members = true, {{"Aeryn", "MAGE", 22, "Horde"}}
A.JournalGroupChanged()
local count = #aeryn.journal
TurnIn(10)
check(#aeryn.journal == count, "finished alone: not written as together")

-- 13. Done the moment you take it (a letter you both carry): a companion who
-- takes it moments later counts.
questLog, complete[11] = {11}, true
Fire("QUEST_ACCEPTED", 11)
Fire("UNIT_QUEST_LOG_CHANGED", "player")
onQuest.Aeryn[11] = true
clock = clock + 5
Fire("UNIT_QUEST_LOG_CHANGED", "party1")
TurnIn(11)
check(aeryn.journal[#aeryn.journal].k == "quest" and aeryn.journal[#aeryn.journal].d == "A Letter", "a letter you both carried")

-- 14. Always on with the journal: no setting of its own.
check(A.defaults.journalGroupmates == nil, "kept-aside memories have no option")
members = {{"Aeryn", "MAGE", 22, "Horde"}, {"Newcomer", "PALADIN", 20, "Horde"}}
A.JournalGroupChanged()
check(Aside("newcomer-forever") ~= nil, "a new groupmate is kept aside")

-- 15. Turning it off closes open outings, stops listening, keeps nothing aside.
local outing
for i = #aeryn.journal, 1, -1 do if aeryn.journal[i].k == "group" then outing = aeryn.journal[i]; break end end
db.peopleJournal = false
A.UpdatePeopleHooks()
check(outing.e ~= nil and not journalFrame.events.ENCOUNTER_END, "off closes outings and unregisters")
check(db.journalAside == nil and db.journalQuests == nil, "nothing kept aside or watched while off")

io.write("PASS: " .. assertions .. " journal assertions\n")
