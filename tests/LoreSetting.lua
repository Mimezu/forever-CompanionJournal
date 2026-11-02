-- Era provenance must survive world/quest imports without guessing from IDs.
-- Run from the client root. No UI or SavedVariables are loaded.
local A, root, checks = {}, "Interface/AddOns/CompanionJournal/", 0
local function Load(file) assert(loadfile(root .. file))("CompanionJournal", A) end
local function Check(value, why) checks = checks + 1; assert(value, why) end
for _, file in ipairs({"LoreData.lua", "Lore.lua", "LoreHordeStories.lua", "LoreAllianceStories.lua",
    "LoreWorldStories.lua", "LoreClassStories.lua", "LoreNotes.lua"}) do Load(file) end
local function Note(kind, title, context)
    local note = A.GetLoreNote(A.LoreNoteResolve(kind, title, context))
    Check(note ~= nil, "missing note " .. title)
    return note
end
Check(Note("p", "Zephras Isle").setting == "Forever", "Zephras mislabeled as Classic")
Check(Note("p", "Zephras").setting == "Forever", "Zephras alias lost era")
for id, entry in pairs(A.Lore.storyPacks["horde-and-zephras"].questIDs) do
    if entry.zone == "Zephras Isle" then
        Check(Note("q", entry.title, {qid = id}).setting == "Forever", "Zephras quest lost region setting: " .. id)
    end
end
Check(Note("p", "Mulgore").setting == "Classic / Forever", "mixed pack changed Classic region")
Check(Note("q", "A Humble Task", {qid = 752}).setting == "Classic / Forever", "mixed pack changed Classic quest")
local source = {"Synthetic setting fixture; not production lore"}
A.Lore.RegisterStoryPack("setting-test", {
    sources = source, setting = "Forever",
    zones = {['Era Test Region'] = {noteSummary = "Fixture region."}},
    quests = {['Era Test Title'] = {why = {"Fixture title."}}},
    questIDs = {
        [9100001] = {title = "Era Test Exact", why = {"Fixture exact."}},
        [9100002] = {title = "Era Test Override", setting = "Classic / Forever", why = {"Fixture override."}},
    },
})
Check(Note("p", "Era Test Region").setting == "Forever", "region did not inherit pack setting")
Check(Note("q", "Era Test Title").setting == "Forever", "title did not inherit pack setting")
Check(Note("q", "Era Test Exact", {qid = 9100001}).setting == "Forever", "exact did not inherit pack setting")
Check(Note("q", "Era Test Override", {qid = 9100002}).setting == "Classic / Forever", "explicit era lost precedence")
A.Lore.RegisterStoryPack("setting-region-test", {
    sources = source, zones = {['Era Test Region Two'] = {setting = "Forever", noteSummary = "Region fixture."}},
    quests = {['Era Region Title'] = {zone = "Era Test Region Two", why = {"Region title."}}},
    questIDs = {[9100003] = {title = "Era No Guess", why = {"High ID alone proves nothing."}}},
})
Check(Note("q", "Era Region Title").setting == "Forever", "title did not inherit region setting")
Check(Note("q", "Era No Guess", {qid = 9100003}).setting == "Classic / Forever", "era guessed from ID range")
print("LoreSetting: " .. checks .. " checks passed")
