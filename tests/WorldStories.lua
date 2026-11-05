-- Run from the client root: lua5.1 Interface/AddOns/CompanionJournal/tests/WorldStories.lua
local root = "Interface/AddOns/CompanionJournal/"
local A = {}
for _, file in ipairs({"LoreData.lua", "Lore.lua", "LoreWorldStories.lua"}) do
    assert(loadfile(root .. file))("CompanionJournal", A)
end
local L, checks = A.Lore, 0
local function check(value, message)
    checks = checks + 1
    assert(value, message)
end
local P = assert(L.storyPacks.world_journeys)
local function text(title, id, field)
    return table.concat(assert(L.QuestStory(title, id))[field or "after"], " ")
end
local function has(title, id, fragment)
    check(text(title, id):find(fragment, 1, true), title .. " " .. tostring(id) .. " missing " .. fragment)
end
local function lacks(title, id, fragment)
    check(not text(title, id):find(fragment, 1, true), title .. " " .. tostring(id) .. " falsely included " .. fragment)
end

-- Validate authored coverage and evidence identity, not invented execution history.
local corpus = assert(io.open("StorageInvestigation/journal-voice/review/corpus_vanilla_quests.txt", "rb"))
local source = corpus:read("*a"); corpus:close()
local evidence = {}
for title, id, level in source:gmatch("### ([^\r\n]+)  %(id (%d+), level (%d+)%)") do
    evidence[tonumber(id)] = {title = title, level = tonumber(level)}
end
local count, zones = 0, 0
local pronouns = {i=true, me=true, my=true, mine=true, we=true, us=true, our=true, ours=true, you=true, your=true, yours=true}
local function prose(lines, label)
    check(type(lines) == "table" and #lines >= 2, label .. " requires alternatives")
    check(lines[1] ~= lines[2], label .. " repeated variant")
    for _, line in ipairs(lines) do
        check(line:match("[%.!?]$") ~= nil, label .. " incomplete sentence")
        for word in line:lower():gmatch("%a+") do
            check(not pronouns[word], label .. " contains player/narrator pronoun " .. word)
        end
        check(not line:find("<name>", 1, true), label .. " contains raw quest markup")
    end
end
for id, entry in pairs(P.questIDs) do
    count = count + 1
    check(evidence[id] and evidence[id].title == entry.title, "source ID/title mismatch " .. id)
    check(evidence[id].level == entry.level, "source level mismatch " .. id)
    check(entry.source[1]:find(tostring(id), 1, true), "missing source ID " .. id)
    check(P.threads[entry.thread] ~= nil, "missing thread " .. id)
    check(L.QuestStory(entry.title, id).pack == "world_journeys", "unresolved ID " .. id)
    prose(entry.why, id .. " why"); prose(entry.after, id .. " after")
end
for title, entry in pairs(P.quests) do
    prose(entry.why, title .. " fallback why"); prose(entry.after, title .. " fallback after")
end
for zone, entry in pairs(P.zones) do
    zones = zones + 1
    prose(entry.sight, zone .. " sight"); prose(entry.stakes, zone .. " stakes")
end
check(count == 465, "curated ID coverage changed; inspect inventory") -- 309 exact stages since the 1.12.x world additions; 465 after the 2026-11-05 world pass (tests/WorldOvernight.lua)
check(zones == 26, "regional setting inventory changed")

-- Identical titles must not consume a later stage's consequence.
-- (fragments follow the current wording of the stages; the intent is the stage's own consequence, never a later one)
has("The Sacred Flame", 1195, "entrusted to the next journey")
has("The Sacred Flame", 1196, "breach the relic's protective flame")
has("The Sacred Flame", 1197, "Cloven Hoof reached Rau")
lacks("The Sacred Flame", nil, "Cloven Hoof reached Rau")
has("Are We There, Yeti?", 3783, "horns and demonstration were still ahead")
has("Are We There, Yeti?", 977, "attached the recovered horns")
has("Are We There, Yeti?", 5163, "all three friends startled")
lacks("Are We There, Yeti?", 977, "all three friends startled")
lacks("Are We There, Yeti?", nil, "all three friends startled")
has("Prayer to Elune", 3377, "prayer itself still needed recovery")
has("Prayer to Elune", 3378, "Astarii received the prayer")
lacks("Prayer to Elune", nil, "Astarii received the prayer")
has("Seal of Ascension", 4742, "final forging remained")
has("Seal of Ascension", 4743, "was complete")
lacks("Seal of Ascension", nil, "final protective invocation")
has("Of Love and Family", 5846, "portrait itself remained")
has("Of Love and Family", 5848, "portrait was returned to Tirion")
lacks("Of Love and Family", nil, "portrait was returned to Tirion")
has("Moonglade", 5921, "mastery of the bear still lay ahead")
has("Moonglade", 94913, "existing mastery")
has("Moonglade", 94914, "already accomplished")
lacks("Moonglade", nil, "mastery of the bear still lay ahead")
check(text("The Sacred Flame", 5163) == text("The Sacred Flame", nil), "mismatched ID leaked another title's outcome")
check(text("Seal of Ascension", 999999) == text("Seal of Ascension", nil), "unknown ID did not use conservative title context")
has("The Scourge Cauldrons", 5215, "access to the cauldrons remained")
has("All Along the Watchtowers", 5097, "attack they prepared was still to come")
has("The Missing Diplomat", 1324, "search for the king remained open")
has("Deadly Desert Venom", 8277, "recovery was not yet assured")
has("Kurzen's Mystery", 207, "look for a link")
has("The Princess Trapped", 642, "still far from free")
has("The Corruption of the Jadefire", 4421, "without cleansing the forest")
has("Legends of Maraudon", 7044, "might one day be cleansed")
has("Attunement to the Core", 7487, "attuned the traveler to the rift")
lacks("Attunement to the Core", 7487, "Ragnaros fell")
has("Blackhand's Command", 7761, "Mark of Drakkisath")
lacks("Blackhand's Command", 7761, "Nefarian fell")
has("In Dreams", 5944, "Taelan died")
has("The Battle of Darrowshire", 5721, "spirit was saved")

-- Connected stages retain their own limits even when their titles repeat.
has("Raene's Cleansing",991,"Teronis was found dead")
has("Raene's Cleansing",1027,"repairing the rod")
lacks("Raene's Cleansing",1027,"re-enchanted")
has("Raene's Cleansing",1028,"shrine re-enchanted")
has("Raene's Cleansing",1030,"described exile")
has("Raene's Cleansing",1045,"remained tainted")
lacks("Raene's Cleansing",nil,"Ran Bloodtooth was slain")
lacks("Raene's Cleansing",999999,"Teronis was found dead")
has("Trol'kalar",645,"delivery to Zengu still remained")
has("Trol'kalar",646,"promised to send it")
lacks("Trol'kalar",nil,"Zengu received the sword")
has("Stones of Binding",651,"restraints loosen")
has("Summoning the Princess",656,"trapping her beneath Arathi once more")
has("Raising Spirits",672,"yet to receive it")
has("Raising Spirits",674,"did not overcome his despair")
has("Raising Spirits",675,"amulet had failed")
lacks("Raising Spirits",nil,"Gor'mul dismissed")
has("The Black Shield",1320,"as a guess")
has("The Black Shield",1322,"inscription's meaning was still ahead")
has("The Black Shield",1323,"leaving the mystery open")
lacks("The Black Shield",nil,"Mosarn")
has("Insect Part Analysis",110,"identity he did not know")
has("Insect Part Analysis",113,"agreed to make a copy")
lacks("Insect Part Analysis",nil,"Fizzledowser accepted")
has("The Final Piece",5123,"could not decipher")
has("Lost!",4492,"found Ringo alive at the volcano")
has("A Little Help From My Friends",4491,"still in poor shape")
has("Return to Chromie",5941,"still had to be faced")
has("Scarlet Subterfuge",5862,"sank to one knee")
has("The Scepter of Celebras",7046,"his uncle's fate still required attention")

-- Representative variants: inspect the actual lines returned by the runtime
-- resolver, including quieter errands and the limit of a major raid attunement.
for _, sample in ipairs({{"Pamela's Doll",5149},{"Expedition Salvation",3881},{"Are We There, Yeti?",3783},{"Attunement to the Core",7487},{"Moonglade",94913}}) do
    local v = L.QuestStory(sample[1], sample[2])
    print(sample[1] .. " [" .. sample[2] .. "]: " .. v.why[1] .. " " .. v.after[1])
end
print("WorldStories: " .. checks .. " checks passed; " .. count .. " curated quest IDs, " .. zones .. " regional setting pools.")
