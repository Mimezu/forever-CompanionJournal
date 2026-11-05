-- Run from the client root; optional argument "full" lists every precise stage.
local root, A = "Interface/AddOns/CompanionJournal/", {}
for _, file in ipairs({"LoreData.lua", "Lore.lua", "LoreHordeStories.lua", "LoreAllianceStories.lua", "LoreWorldStories.lua", "LoreClassStories.lua", "LoreForeverStories.lua", "LoreNotes.lua"}) do
    assert(loadfile(root .. file))("CompanionJournal", A)
end
local function count(t) local n=0; for _ in pairs(t or {}) do n=n+1 end; return n end
local function keys(t) local k={}; for key in pairs(t or {}) do k[#k+1]=key end; table.sort(k); return k end
print("Companion Journal 1.8 - authored story coverage")
print("Representative contexts, not an exhaustive quest or boss encyclopedia.")
for _, key in ipairs(keys(A.Lore.storyPacks)) do
    local p=A.Lore.storyPacks[key]
    print(string.format("%s: %d precise quest stages, %d title contexts, %d regional additions, %d threads", key,count(p.questIDs),count(p.quests),count(p.zones),count(p.threads)))
    if next(p.zones or {}) then print("  Regions: "..table.concat(keys(p.zones),", ")) end
    if arg and arg[1]=="full" then
        for _, id in ipairs(keys(p.questIDs)) do
            local q=p.questIDs[id]
            print(string.format("  %d | %s | %s",id,q.title,q.zone or "varies by stage"))
        end
    end
end
print("Total precise quest stages: "..count(A.Lore.questStoryIDs))
local n=A.LoreNoteCoverage()
print(string.format("Lore notes: %d authored references, %d regional references, %d conservative quest titles, %d exact quest stages",n.curated,n.regional,n.questTitle,n.questID))
print("Unrecorded early adventures remain unknown. Title-only old records do not identify a chain stage.")
