-- Run from the client root with Lua 5.1. Exercises real catalog and policy data.
local root = "Interface/AddOns/CompanionJournal/"
local count, frames, selected, shownQuest = 0, {}, "Neige", nil
local now, completed, queries = 12345, {}, 0
local A = {db = {characters = {Neige = {level = 2, journal = {}}, Veteran = {level = 60, journal = {}}}}}
function A.Me() return selected end
local function Check(value, label) count = count + 1; assert(value, label) end
local function Load(name) assert(loadfile(root .. name))("CompanionJournal", A) end
function CreateFrame()
    local f = {events = {}, scripts = {}}
    function f:RegisterEvent(e) self.events[e] = true end
    function f:SetScript(e, callback) self.scripts[e] = callback end
    frames[#frames + 1] = f
    return f
end
function GetQuestID() return shownQuest end
function time() return now end
C_QuestLog = {IsQuestFlaggedCompleted = function(qid) queries = queries + 1; return completed[qid] == true end}
local function Event(e, qid)
    for _, f in ipairs(frames) do if f.events[e] then f.scripts.OnEvent(f, e, qid) end end
end
for _, file in ipairs({"LoreData.lua", "Lore.lua", "LoreHordeStories.lua", "LoreAllianceStories.lua", "LoreWorldStories.lua",
    "LoreClassStories.lua", "LoreNotes.lua", "LorePlaces.lua", "LorePeopleHistory.lua", "LoreWorldConnections.lua",
    "LoreDiscovery.lua", "LoreDiscoveryData.lua"}) do Load(file) end
local function Reset()
    selected = "Neige"
    A.db.characters.Neige = {level = 2, journal = {}}
    shownQuest, completed, queries = nil, {}, 0
end
local function Present(qid) shownQuest = qid; Event("QUEST_DETAIL") end
local function Finish(qid) Event("QUEST_TURNED_IN", qid) end
local function Contains(note, text) return note.body:lower():find(text:lower(), 1, true) end
local function Related(note, id)
    for _, v in ipairs(note.related or {}) do if id == v then return true end end
    return false
end
local function PublicCourt()
    for _, id in ipairs({"npc:bolvar", "npc:windsor", "npc:katrana-prestor"}) do
        local note = A.GetKnownLoreNote(id)
        Check(note and #note.body > 180, "public identity retains useful context: " .. id)
        for _, word in ipairs({"onyxia", "mortally", "medallion", "dragonspawn"}) do
            Check(not Contains(note, word), "court public prose hides " .. word .. ": " .. id)
            for _, source in ipairs(note.sources or {}) do Check(not source:lower():find(word, 1, true), "public source hides " .. word) end
        end
        Check(not Related(note, "npc:onyxia"), "public court relationship does not imply disguise")
        Check(not Related(note, "event:great-masquerade"), "public court does not point to future resolution")
    end
end
local canonical = A.GetLoreNote("npc:bolvar").body
Check(canonical:find("secretly Onyxia", 1, true), "raw source audit still retains full lore")
local city = A.GetKnownLoreNote(A.LoreNoteResolve("p", "Stormwind"))
Check(city and Related(city, "npc:bolvar"), "reported Stormwind to Bolvar path exists")
PublicCourt()
Check(A.db.characters.Neige.loreDiscoveries == nil and queries == 0, "opening lore neither writes knowledge nor queries live history")
for _, name in ipairs({"Lady Katrana Prestor", "Lady Prestor", "Katrana Prestor"}) do
    for _, kind in ipairs({"n", "p"}) do Check(A.LoreNoteResolve(kind, name) == "npc:katrana-prestor", "public alias " .. name) end
    local marked = A.MarkKnownLore(name)
    local kind, label = marked:match("{([np]):([^}]+)}")
    Check(kind and label == name and A.LoreNoteResolve(kind, label) == "npc:katrana-prestor", "public autolink " .. name)
end
Check(not A.MarkKnownLore("Lady Katrana Prestor"):find("npc:onyxia", 1, true), "substring linking does not expose hidden identity")
local publicAmulet = A.GetKnownLoreNote("relic:drakefire-amulet")
Check(not Related(publicAmulet, "npc:drakkisath"), "public artifact does not disclose recipe via link")
for _, id in ipairs({"npc:onyxia", "dungeon:onyxia", "relic:head-onyxia", "relic:drakefire-amulet", "event:great-masquerade"}) do
    local note = A.GetKnownLoreNote(id)
    Check(not Contains(note, "Prestor") and not Contains(note, "mortally") and not Contains(note, "shatter"), "direct IDs remain projected: " .. id)
end
A.db.characters.Neige.level = 60
PublicCourt()
Present(6402); Finish(6402)
PublicCourt()
Check(next(A.LoreKnowledge()) == nil, "rendezvous does not reveal identity")
Present(6403)
local facts = A.LoreKnowledge()
Check(facts.prestor_identity and facts.bolvar_control and not facts.masquerade_aftermath and not facts.bolvar_medallion,
    "quest description identity is separate from future outcome")
local bolvar = A.GetKnownLoreNote("npc:bolvar")
Check(Contains(bolvar, "same being") and Related(bolvar, "npc:onyxia"), "discovered relationship becomes readable")
Check(not Contains(bolvar, "mortally") and not Contains(bolvar, "medallion"), "presented description does not expose ending")
Check(A.db.characters.Neige.loreDiscoveries.presented[6403].at == now, "actual presentation timestamp captured")
Finish(6403)
facts = A.LoreKnowledge()
Check(facts.masquerade_aftermath and facts.bolvar_medallion and not facts.dragons_eye_mission, "completion grants own outcome, no later mission")
bolvar = A.GetKnownLoreNote("npc:bolvar")
Check(Contains(bolvar, "mortally") and Contains(bolvar, "shattered medallion"), "ending becomes available after turn-in")
Check(not Contains(bolvar, "has held") and not Contains(bolvar, "offers a fragment"), "past control block suppressed; next mission remains unknown")
Present(6501)
Check(Contains(A.GetKnownLoreNote("npc:bolvar"), "offers a fragment"), "next mission appears when presented")
Check(A.GetLoreNote("npc:bolvar").body == canonical, "canonical prose never mutated")

Reset(); Present(6566)
Check(next(A.LoreKnowledge()) == nil, "listen-to-Thrall quest description contains no report")
Finish(6566)
facts = A.LoreKnowledge()
Check(facts.horde_court_report and facts.bolvar_control and not facts.prestor_identity and not facts.masquerade_aftermath,
    "Horde report does not infer unseen Alliance revelation")
local onyxia = A.GetKnownLoreNote("npc:onyxia")
Check(Contains(onyxia, "Thrall's intelligence") and not Contains(onyxia, "Prestor") and not Contains(onyxia, "Windsor"), "Horde report stays within observed dialogue")
Check(not Related(onyxia, "npc:katrana-prestor"), "Horde report does not reveal unnamed disguise via related link")
for _, qid in ipairs({6502, 6601, 6602, 7490, 7491, 7496}) do
    Reset(); Finish(qid)
    PublicCourt()
    Check(not A.LoreKnowledge().prestor_identity, "later/faction quest cannot grant prerequisite: " .. qid)
end
Reset(); Finish(7495)
bolvar = A.GetKnownLoreNote("npc:bolvar")
Check(Contains(bolvar, "has held") and not Contains(bolvar, "is held"), "trophy completion uses prior control tense")
Check(not A.LoreKnowledge().prestor_identity and not A.LoreKnowledge().masquerade_aftermath, "trophy reveals only its own recollection")

Reset()
A.db.characters.Veteran.journal = {{k = "quest", qid = 6403}}
PublicCourt()
selected = "Veteran"
Check(A.LoreKnowledge().masquerade_aftermath, "current character exact saved completion recovers")
selected = "Neige"
PublicCourt()
for _, record in ipairs({{k = "quest", q = "The Great Masquerade"}, {k = "quest", qid = "6403"},
    {k = "quest", qid = 6403, imported = true}, {k = "quest", qid = 6403, seeded = true},
    {k = "quest", qid = 6403, s = true}, {k = "visit", qid = 6403}, {k = "quest", qid = math.huge}}) do
    A.db.characters.Neige.journal = {record}
    Check(next(A.LoreKnowledge()) == nil, "only own exact non-seeded quest records qualify")
end
A.db.characters.Neige.journal = {{k = "quest", qid = 6403}}
Check(A.LoreKnowledge().masquerade_aftermath, "own exact completion qualifies")
A.db.characters.Neige.journal[1].qid = 6402
Check(not A.LoreKnowledge().masquerade_aftermath, "same-length history correction cannot leave stale knowledge")

Reset()
A.db.characters.Neige.loreDiscoveries = {completed = {[6403] = false}, presented = {[6403] = {origin = "game-history"}}}
Check(next(A.LoreKnowledge()) == nil, "false and wrong-stage saved evidence rejected")
A.db.characters.Neige.loreDiscoveries.completed[6403] = {origin = "quest-detail"}
Check(next(A.LoreKnowledge()) == nil, "description cannot masquerade as completion")
completed[6403] = true; Event("PLAYER_ENTERING_WORLD")
Check(A.LoreKnowledge().masquerade_aftermath, "positive game history repairs wrong-stage evidence")
local recovered = A.db.characters.Neige.loreDiscoveries.completed[6403]
Check(recovered.origin == "game-history" and recovered.at == nil, "recovery invents no historical date")
local revision = A.db.characters.Neige.loreDiscoveries.revision
Event("QUEST_LOG_UPDATE")
Check(A.db.characters.Neige.loreDiscoveries.revision == revision, "recovery is idempotent")
completed = {}; Event("QUEST_LOG_UPDATE")
Check(A.LoreKnowledge().masquerade_aftermath, "temporary negative API does not revoke known history")
Reset(); A.db.characters.Neige.loreDiscoveries = {presented = {[6403] = {origin = "game-history"}}}
Present(6403)
Check(A.LoreKnowledge().prestor_identity and A.db.characters.Neige.loreDiscoveries.presented[6403].origin == "quest-detail",
    "valid presentation repairs malformed presented evidence")
Reset(); Finish("6403"); Finish(math.huge); Finish(6403.5)
Check(next(A.LoreKnowledge()) == nil, "malformed event quest IDs ignored")

-- Both title-generated and exact-ID references use the same safe policy, even
-- if another module's raw setup includes the concealed identity or outcome.
-- Some base Lore.lua titles are not imported into the current compendium. A
-- later pack must not reintroduce the leak through either generated route.
local fixturePack = {sources = {"discovery test source"}, quests = {}, questIDs = {}}
for _, data in ipairs({{6403, "The Great Masquerade"}, {6501, "The Dragon's Eye"}, {6502, "Drakefire Amulet"},
    {6566, "What the Wind Carries"}, {7495, "Victory for the Alliance"}}) do
    fixturePack.quests[data[2]] = {why = {"Prestor secretly controls the court. SECRET ENDING."}}
    fixturePack.questIDs[data[1]] = {title = data[2], why = {"Prestor secretly controls the court. SECRET ENDING."}}
end
A.Lore.RegisterStoryPack("discovery-test-surfaces", fixturePack)
for _, data in ipairs({{6403, "The Great Masquerade"}, {6501, "The Dragon's Eye"}, {6502, "Drakefire Amulet"},
    {6566, "What the Wind Carries"}, {7495, "Victory for the Alliance"}}) do
    for _, context in ipairs({{}, {qid = data[1]}}) do
        local id = A.LoreNoteResolve("q", data[2], context)
        Check(id, "generated quest reference exists")
        if id then
            local note = A.GetKnownLoreNote(id)
            Check(not Contains(note, "Prestor") and not Contains(note, "mortally") and not Contains(note, "control"), "quest projection " .. id)
        end
    end
end
Finish(6403)
local qid = A.LoreNoteResolve("q", "The Great Masquerade")
Check(qid and Contains(A.GetKnownLoreNote(qid), "mortally"), "quest note gains known ending too: " .. tostring(qid))
local known = A.GetKnownLoreNote("npc:bolvar")
known.related[1] = "BAD"; known.sources[1] = "BAD"; known.body = "BAD"
Check(A.GetKnownLoreNote("npc:bolvar").related[1] ~= "BAD" and A.GetLoreNote("npc:bolvar").body == canonical, "returned tables do not mutate catalog or policy")
local snapshot = A.LoreKnowledge(); snapshot.masquerade_aftermath = false
Check(A.LoreKnowledge().masquerade_aftermath, "returned knowledge is read-only by separation")
Reset()
Present(6601)
local drakkisath = A.GetKnownLoreNote("npc:drakkisath")
Check(not Contains(drakkisath, "blood") and not Contains(A.GetKnownLoreNote("npc:rexxar"), "blood"), "6601 related recipe consumers cannot reveal6602")
Present(6602)
Check(Contains(A.GetKnownLoreNote("npc:drakkisath"), "blood") and Contains(A.GetKnownLoreNote("npc:rexxar"), "blood"), "6602 recipe reaches its named participants")
Reset(); Finish(4322)
Check(Contains(A.GetKnownLoreNote("npc:windsor"), "escaping") and Contains(A.GetKnownLoreNote("place:morgans-vigil"), "escaping"), "prison escape unlocks a separate intermediate stage")
Check(not Contains(A.GetKnownLoreNote("npc:windsor"), "Onyxia"), "escape stage does not grant disguised identity")
Reset()
for _, text in ipairs(A.Lore.dungeonStory["Onyxia's Lair"].why) do
    Check(not text:find("Prestor", 1, true), "unconditional dungeon context cannot reveal disguise")
end
Check(not pcall(A.RegisterLoreDiscovery, {notes = {["npc:bolvar"] = {public = false}}}), "duplicate policy rejected")
Check(not pcall(A.RegisterLoreDiscovery, {notes = {["npc:test"] = {public = false, visibleRequires = {"missing_fact"}}}}), "unknown fact reference rejected")
print("LoreDiscovery: " .. count .. " assertions passed")
