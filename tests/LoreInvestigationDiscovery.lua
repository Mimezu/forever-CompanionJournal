-- Integrated disclosure regressions. Run from the client root with Lua 5.1.
local root = "Interface/AddOns/CompanionJournal/"
local count, frames, selected, shown = 0, {}, "Reader", nil
local A = {db = {characters = {Reader = {journal = {}}, Alt = {journal = {}}}}}
function A.Me() return selected end
function time() return 1792000000 end
function GetQuestID() return shown end
function CreateFrame()
    local f = {events = {}}
    function f:RegisterEvent(event) self.events[event] = true end
    function f:SetScript(_, callback) self.callback = callback end
    frames[#frames + 1] = f
    return f
end
for _, name in ipairs({"LoreData.lua", "Lore.lua", "LoreHordeStories.lua", "LoreAllianceStories.lua", "LoreWorldStories.lua",
    "LoreClassStories.lua", "LoreNotes.lua", "LorePlaces.lua", "LorePeopleHistory.lua", "LoreWorldConnections.lua",
    "LoreDiscovery.lua", "LoreDiscoveryData.lua"}) do assert(loadfile(root .. name))("CompanionJournal", A) end
local function Check(ok, why) count = count + 1; assert(ok, why) end
local function Has(text, part) return text:lower():find(part:lower(), 1, true) ~= nil end
local function Reset()
    selected, shown = "Reader", nil
    A.db.characters.Reader = {level = 2, journal = {}}
end
local function Event(event, qid)
    shown = qid
    for _, f in ipairs(frames) do if f.events[event] then f.callback(f, event, qid) end end
end
local function Note(id) return assert(A.GetKnownLoreNote(id), "missing projected entry " .. id) end
local function Body(id) return Note(id).body end
local function Relation(id, target)
    for _, v in ipairs(Note(id).related or {}) do if v == target then return true end end
    return false
end
local function No(text, phrases, label)
    local found
    for _, phrase in ipairs(phrases) do if Has(text, phrase) then found = phrase; break end end
    Check(not found, label .. ": unexpected " .. tostring(found))
end
local S, N = "npc:stalvan", "npc:neeru-fireblade"
local public = {"region:4f726772696d6d6172", "npc:thrall", N, "faction:burning-blade", "group:searing-blade",
    "dungeon:ragefire", "npc:jergosh", "npc:bazzalan", "npc:taragaman", S, "place:moonbrook", "place:darkshire", "region:4475736b776f6f64"}
local raw = {}
Reset()
for _, id in ipairs(public) do
    raw[id] = A.GetLoreNote(id).body
    local note = Note(id)
    Check(#note.body > 100 and #note.sources > 0, "useful public body and provenance " .. id)
    No(note.title .. " " .. note.body .. " " .. table.concat(note.sources, " "),
        {"secret leader", "Neeru as the Burning Blade's leader", "discreet dealings", "Stalvan's death", "murderous obsession", "Tilloa", "bloodstained", "execution"}, "fresh reader " .. id)
    for _, target in ipairs(note.related) do Check(A.GetKnownLoreNote(target), "public related target resolves " .. target) end
end
Check(Has(Body("place:darkshire"), "Night Watch") and Has(Body("place:moonbrook"), "miners"), "civic and mining history remains public")
Check(not Relation("place:moonbrook", S) and not Relation("place:darkshire", S), "public geography does not introduce suspect")
Check(not Relation(N, "faction:burning-blade"), "public profession does not disclose allegiance")
Check(A.db.characters.Reader.loreDiscoveries == nil, "reading and related lookup never discover facts")

-- Isolated exposures, not a sequential chain that might mask inherited facts.
local stalvan = {
    {66, "granddaughter", "granddaughter"}, {67, "Schoolhouse", "Schoolhouse"},
    {68, "inquiry", "unsent letter"}, {69, "Lion's Pride", "Lion's Pride"},
    {70, "messenger", "messenger"}, {72, "massacre", "massacre"},
    {74, "torn journal page", "torn journal page"}, {75, "failing sight", "failing sight"},
    {78, "Haggard recommends", "Smitts recognizes"}, {79, "proof of Stalvan's guilt", "proof of Stalvan's guilt"},
    {80, "requests a comparison", "Daltry confirms"}, {97, "Daltry confirms", "Daltry confirms"},
    {98, "orders his execution", "confirms Stalvan's death"},
}
for _, row in ipairs(stalvan) do
    for stage = 1, 2 do
        Reset(); Event(stage == 1 and "QUEST_DETAIL" or "QUEST_TURNED_IN", row[1])
        local body = Body(S)
        Check(Has(body, row[stage + 1]), "Stalvan exposure " .. row[1] .. "/" .. stage)
        No(body, {"schoolmaster", "Tilloa", "Giles", "obsession"}, "item text is not implied by quest " .. row[1])
        if row[1] ~= 98 or stage == 1 then No(body, {"confirms Stalvan's death", "end of his killings"}, "execution is completion only") end
        if row[1] < 79 then No(body, {"guilt", "execute", "execution"}, "early inquiry cannot solve case " .. row[1]) end
        if row[1] ~= 98 then
            Check(not Has(table.concat(Note(S).sources, " "), "quest 98"), "earlier source captions do not reveal final-stage provenance")
        end
        local id = A.LoreNoteResolve("q", "The Legend of Stalvan", {qid = row[1]})
        Check(id == "quest:" .. row[1] and Note(id), "actual exact Stalvan catalog reference " .. row[1])
    end
end
Reset(); Event("QUEST_DETAIL", 78)
Check(not Has(Body(S), "Smitts recognizes"), "referral is not handwriting recognition")
Reset(); Event("QUEST_DETAIL", 80)
Check(not Has(Body(S), "Daltry confirms"), "comparison order is not confirmed match")
Reset(); Event("QUEST_TURNED_IN", 98)
No(Body(S), {"Moonbrook", "handwriting", "massacre", "granddaughter"}, "final outcome cannot backfill earlier records")
local title = A.LoreNoteResolve("q", "The Legend of Stalvan")
No(Body(title), {"execution", "guilt", "death", "handwriting"}, "title reference stays inquiry with known final stage")

local neeru = {
    {829, N, "collars", "collars"}, {832, N, "voice threatening", "takes the pendant"},
    {5726, "npc:thrall", "insignia", "insignia"},
    {5727, N, "Burning Blade's leader", "Burning Blade's leader"},
    {5728, "npc:jergosh", "Thrall names", "reported slain"},
    {5729, N, "discreet dealings", "angrily acknowledges"},
    {5730, N, "new agenda", "new agenda"},
    {5725, "dungeon:ragefire", "sect of the Shadow Council", "sect of the Shadow Council"},
    {5761, "npc:taragaman", "Neeru calls Taragaman", "receives Taragaman's heart"},
}
for _, row in ipairs(neeru) do
    for stage = 1, 2 do
        Reset(); Event(stage == 1 and "QUEST_DETAIL" or "QUEST_TURNED_IN", row[1])
        Check(Has(Body(row[2]), row[stage + 2]), "Neeru exposure " .. row[1] .. "/" .. stage)
        if row[1] ~= 5727 then Check(not Has(Body(N), "Burning Blade's leader"), "no leadership prerequisite inference " .. row[1]) end
        if row[1] ~= 5730 then No(Body(N), {"new agenda"}, "no later regional agenda " .. row[1]) end
        if row[1] ~= 5728 and row[1] ~= 5729 or stage == 1 then
            No(Body("npc:jergosh"), {"reported slain"}, "no unrelated/presented boss outcome " .. row[1])
        end
    end
end
for _, qid in ipairs({5728, 5729, 5730}) do
    Reset(); Event("QUEST_DETAIL", qid)
    No(Body("faction:burning-blade"), {"Neeru"}, "faction adjacency respects isolated later stage " .. qid)
end
Reset(); Event("QUEST_DETAIL", 5730)
Check(not Has(Body("npc:thrall"), "spies will investigate"), "regional report is not Thrall response")
Event("QUEST_TURNED_IN", 5730)
Check(Has(Body("npc:thrall"), "spies will investigate"), "response becomes available after turn-in")
for _, qid in ipairs({5726, 5727, 5728, 5729, 5730}) do
    Reset()
    Check(A.LoreNoteResolve("q", "Hidden Enemies", {qid = qid}) == "quest:" .. qid, "exact Hidden Enemies note imported " .. qid)
end

-- Automatic name linking resolves into projected identities and source labels.
Reset()
for _, name in ipairs({"Stalvan", "Stalvan Mistmantle", "Neeru Fireblade", "Burning Blade", "Searing Blade"}) do
    local kind, label = A.MarkKnownLore(name):match("{([np]):([^}]+)}")
    local id = kind and A.LoreNoteResolve(kind, label)
    Check(id and A.GetKnownLoreNote(id), "automatic hover target " .. name)
    local n = Note(id)
    No(n.body .. " " .. table.concat(n.sources, " "), {"secret leader", "murderous obsession", "Stalvan's death", "execution"}, "hover projection " .. name)
end
A.db.characters.Alt.journal = {{k = "quest", qid = 98}, {k = "quest", qid = 5727}}
for _, record in ipairs({{k = "quest", d = "The Legend of Stalvan"}, {k = "quest", d = "Hidden Enemies"},
    {k = "visit", qid = 98}, {k = "boss", d = "Bazzalan"}, {k = "quest", qid = 98, imported = true},
    {k = "quest", qid = 5727, seeded = true}, {k = "quest", qid = 98, s = true}}) do
    A.db.characters.Reader = {level = 60, journal = {record}}
    Check(next(A.LoreKnowledge()) == nil, "level, location, titles, alt and imported records do not discover")
end
A.db.characters.Reader = {journal = {}, loreDiscoveries = {completed = {[98] = {origin = "quest-detail"}}, presented = {[5727] = {origin = "game-history"}}}}
Check(next(A.LoreKnowledge()) == nil, "wrong-stage evidence does not disclose")
selected = "Alt"
Check(Has(Body(S), "Stalvan's death") and Has(Body(N), "Burning Blade's leader"), "reader's own exact history discloses")
Reset()
No(Body(S) .. Body(N), {"Stalvan's death", "Burning Blade's leader"}, "reader switch recomputes stale navigation targets")
for _, id in ipairs(public) do Check(A.GetLoreNote(id).body == raw[id], "canonical remains available unchanged " .. id) end
print("LoreInvestigationDiscovery: " .. count .. " assertions passed")
