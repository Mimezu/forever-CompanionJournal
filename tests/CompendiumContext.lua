-- Targeted context-first references must remain independent of remembered events.
-- Run from client root: lua Interface/AddOns/CompanionJournal/tests/CompendiumContext.lua
local root, A, checks = "Interface/AddOns/CompanionJournal/", {db = {sentinel = true}}, 0
local function Check(value, why) checks = checks + 1; assert(value, why) end
local function Load(file) assert(loadfile(root .. file))("CompanionJournal", A) end
Load("LoreData.lua"); Load("Lore.lua"); Load("LoreHordeStories.lua")
local pack = A.Lore.storyPacks["horde-and-zephras"]
local ids = {447, 450, 451, 422, 423, 424, 99}
local remembered = {}
for _, id in ipairs(ids) do
    local s = A.Lore.QuestStory(pack.questIDs[id].title, id)
    remembered[id] = table.concat(s.why, "\n") .. "\n" .. table.concat(s.after, "\n")
end
Load("LoreNotes.lua")
local function Note(title, id)
    return A.GetLoreNote(A.LoreNoteResolve("q", title, id and {qid = id} or nil))
end
for _, id in ipairs(ids) do
    local s = pack.questIDs[id]
    local note = Note(s.title, id)
    Check(note.id == "quest:" .. id and note.body == s.noteSummary, "authored exact summary: " .. id)
    Check(note.body ~= s.why[1] and note.body:find("\n\n", 1, true), "context and stage paragraphs: " .. id)
    Check(note.sources[1] == s.noteSources[1] and note.sources[1] ~= s.source[1], "cross-quest context provenance: " .. id)
    local story = A.Lore.QuestStory(s.title, id)
    Check(remembered[id] == table.concat(story.why, "\n") .. "\n" .. table.concat(story.after, "\n"), "opening reference cannot alter narration: " .. id)
end
for _, title in ipairs({"A Recipe For Death", "Arugal's Folly"}) do
    local note, s = Note(title), pack.quests[title]
    Check(note.coverage == "questTitle" and note.body == s.noteSummary, "no-ID title context: " .. title)
    Check(Note(title, 999999).id == note.id, "unknown ID title fallback: " .. title)
    local mismatch = title == "Arugal's Folly" and 447 or 422
    Check(Note(title, mismatch).id == note.id, "mismatched ID title fallback: " .. title)
    Check(note.sources[1] == s.noteSources[1], "title context provenance: " .. title)
end
local forever = Note("Arugal's Folly", 98298)
Check(forever.id == "quest:98298" and forever.body == pack.questIDs[98298].why[1], "Forever exact stage retains its own fallback")
Check(forever.body:find("bound worgen rather than creating them", 1, true), "Forever conclusion remains in its exact stage")
for _, id in ipairs({422, 423, 424, 99}) do
    local body = Note("Arugal's Folly", id).body
    Check(not body:find("bound worgen rather than creating", 1, true) and not body:find("Greymane Wall", 1, true), "original stage cannot inherit Forever conclusion: " .. id)
end
Check(not Note("Arugal's Folly", 423).body:find("sufficient", 1, true), "shackle receipt uncertainty is completion-only")
Check(not Note("A Recipe For Death", 447).body:find("Berard", 1, true), "first sample stage does not inherit journal stage")
Check(not Note("A Recipe For Death", 450).body:find("hardened tumor", 1, true), "journal request does not inherit later specimens")
for _, name in ipairs({"Brill", "Deathknell", "Sepulcher", "Shadowfang Keep", "The Undercity"}) do
    local note = A.GetLoreNote(A.LoreNoteResolve("p", name))
    Check(note and note.body:find("\n\n", 1, true), "world context and distinctive details: " .. name)
    for _, target in ipairs(note.related or {}) do
        Check(A.GetLoreNote(target) ~= nil, "preserved/new related identity: " .. target)
    end
end
-- Prove dedicated provenance wins while old entries retain their source path.
A.Lore.RegisterStoryPack("compendium-source-fixture", {sources = {"pack source"}, quests = {
    ["Summary fixture"] = {why = {"Remembered event."}, noteSummary = "Reference present.", source = {"story source"}, noteSources = {"note source"}},
    ["Fallback fixture"] = {why = {"Existing fallback."}, source = {"existing source"}},
}, questIDs = {[9100423] = {title = "Exact fixture", why = {"Exact remembered event."}, noteSummary = "Exact reference present.", source = {"exact story source"}, noteSources = {"exact note source"}}}})
Check(Note("Summary fixture").sources[1] == "note source", "title dedicated source preferred")
Check(Note("Exact fixture", 9100423).sources[1] == "exact note source", "exact dedicated source preferred")
Check(Note("Fallback fixture").sources[1] == "existing source", "legacy source fallback preserved")
Check(A.db.sentinel and next(A.db, "sentinel") == nil, "reference import writes no saved state")
print("CompendiumContext: " .. checks .. " checks passed")
