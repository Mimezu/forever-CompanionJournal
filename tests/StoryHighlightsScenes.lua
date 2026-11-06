-- Highlights uses complete authored compact scenes without dropping recorded stages.
local root, A = "Interface/AddOns/CompanionJournal/", {defaults = {colors = {}}}
function time(t) return t and os.time(t) or 1790000000 end
function date(fmt, t) return os.date(fmt, t) end
for _, file in ipairs({"LoreData.lua", "Lore.lua", "LoreHordeStories.lua", "LoreAllianceStories.lua", "LoreWorldStories.lua", "LoreClassStories.lua",
    "JournalBook.lua", "JournalTellers.lua", "JournalTale.lua", "JournalWords.lua", "JournalSelfWords.lua", "JournalSelfTale.lua"}) do
    assert(loadfile(root .. file))("CompanionJournal", A)
end
local checks = 0
local function check(ok, why) checks = checks + 1; assert(ok, why) end
local BASE = os.time({year = 2026, month = 10, day = 3, hour = 18})
local function person(companion)
    return {self = not companion, name = companion and "Dahlia" or "Writer", charKey = "detail", race = "Tauren", class = "SHAMAN",
        faction = "Horde", startLevel = 1, pronouns = "they", bond = "spouse", origin = "together", journal = {}}
end
local function outing(p, offset, zone, ids, extra)
    local t = BASE + offset
    p.journal[#p.journal + 1] = {k = p.self and "play" or "group", t = t, e = t + 3600, z = zone, pl = 4, ol = 4}
    for i, id in ipairs(ids) do
        local q = A.Lore.questStoryIDs[id]
        p.journal[#p.journal + 1] = {k = "quest", d = q.title, qid = id, t = t + i * 300, z = zone, pl = 4, ol = 4}
    end
    if extra then
        p.journal[#p.journal + 1] = {k = "quest", d = extra, qid = 999999, t = t + 1500, z = zone, pl = 4, ol = 4}
    end
end
local player = person(false)
local function tell(p, brief, retell, voice)
    p.retell = retell
    local days = A.JournalBook(p)
    local stories = p.self and A.SelfTale.Tell(p, days, brief, retell)
        or A.JournalTale.Tell(p, days, voice or "we", player, brief)
    local out = {}
    for _, day in ipairs(days) do if stories[day.key] then out[#out + 1] = A.JournalPlain(stories[day.key].text) end end
    return table.concat(out, "\n\n")
end
local function lineAt(text, lines)
    for _, line in ipairs(lines or {}) do
        local at = text:find(A.JournalPlain(line), 1, true)
        if at then return at, A.JournalPlain(line) end
    end
end
local function outcomeAt(text, id) return lineAt(text, A.Lore.questStoryIDs[id].after) end
local function noSeams(text)
    check(not text:find("{%a+}"), "no unresolved tokens: " .. text)
    check(not text:find("and %.") and not text:find(",%s*,") and not text:find("  ", 1, true), "no removed-predicate seam: " .. text)
end

-- Test-only authored stages, deliberately longer in Detailed. Each short scene
-- has an actor, supported work, and a consequence; all five must survive.
local ids = {}
for i = 1, 5 do
    local id = 990100 + i
    ids[i] = id
    A.Lore.questStoryIDs[id] = {
        title = "The Courier's Ledger " .. i, zone = "Elwynn Forest", importance = 4,
        why = {"Courier " .. i .. " needed a sealed ledger recovered from the abandoned storehouse.",
            "A ledger left in the storehouse was missing from courier " .. i .. "'s records."},
        after = {"Ledger " .. i .. " reached its courier, who could resume the interrupted deliveries.",
            "Courier " .. i .. " received the recovered ledger and resumed the waiting deliveries."},
        highlight = {"Courier " .. i .. " recovered the missing ledger and resumed deliveries.",
            "With ledger " .. i .. " recovered, the courier resumed deliveries."},
    }
end
local function stageAt(text, i, brief)
    local q = A.Lore.questStoryIDs[ids[i]]
    return lineAt(text, brief and q.highlight or q.after)
end
local Study = dofile("StorageInvestigation/storytelling-thirty-20261013/v2/study-lib.lua")
local authoredBefore = {}
for _, id in ipairs(ids) do authoredBefore[id] = Study.json(A.Lore.questStoryIDs[id]) end
local variantsSeen = {}
for retell = 0, 15 do for _, companion in ipairs({false, true}) do
    local p = person(companion); p.race, p.faction, p.origin = "Human", "Alliance", nil
    outing(p, 0, "Elwynn Forest", ids)
    p.journal[#p.journal + 1] = {k="death", w="you", d="Ledger Thief", t=BASE+750, z="Elwynn Forest", pl=10, ol=10}
    p.journal[#p.journal + 1] = {k="quest", qid=999995, d="Uncatalogued Dispatch", t=BASE+1050, z="Elwynn Forest", pl=10, ol=10}
    for _, brief in ipairs({false, true}) do for _, voice in ipairs({"we", "you"}) do
        local text = tell(p, brief, retell, voice)
        local previous = 0
        for i = 1, 5 do
            local at = stageAt(text, i, brief)
            check(at and at > previous, "all exact stages retain chronological outcomes: " .. text)
            previous = at
            if brief then
                check(not lineAt(text, A.Lore.questStoryIDs[ids[i]].why), "compact scene replaces, not duplicates, setup")
                local _, line = lineAt(text, A.Lore.questStoryIDs[ids[i]].highlight)
                variantsSeen[line] = true
            end
        end
        local death = text:find("Ledger Thief",1,true)
        check(death and stageAt(text,2,brief)<death and death<stageAt(text,3,brief), "death retains its place among stages")
        local unknown = text:find("Uncatalogued Dispatch",1,true)
        check(unknown or (companion and text:find("six quests",1,true)), "unknown work remains named or honestly counted: " .. text)
        if not companion then
            check(stageAt(text,3,brief)<unknown and unknown<stageAt(text,4,brief), "unknown work stays between recorded authored stages")
        end
        check(text == tell(p,brief,retell,voice), "replay is deterministic")
        noSeams(text)
    end end
    local short, full = tell(p,true,retell,"we"), tell(p,false,retell,"we")
    check(#short < #full, "reviewed compact scenes produce a genuinely shorter chapter")
end end
for _, id in ipairs(ids) do
    check(authoredBefore[id] == Study.json(A.Lore.questStoryIDs[id]), "render does not mutate authored stage data")
    for _, line in ipairs(A.Lore.questStoryIDs[id].highlight) do check(variantsSeen[line], "both compact alternatives are exercised") end
end
-- A similarly titled historical record cannot authorize exact-stage short prose.
local exact = A.Lore.questStoryIDs[ids[1]]
A.Lore.questStory[exact.title] = {why={"A courier awaited a report."}, after={"The courier received the report."},
    highlight={"FORBIDDEN EXACT STAGE"}, zone="Elwynn Forest", importance=4}
for _, companion in ipairs({false,true}) do
    local p=person(companion); p.origin=nil
    p.journal={{k=companion and "group" or "play",t=BASE,e=BASE+3600,z="Elwynn Forest",pl=10,ol=10},
        {k="quest",d=exact.title,t=BASE+300,z="Elwynn Forest",pl=10,ol=10}}
    local text=tell(p,true,0,"we")
    check(not text:find("FORBIDDEN",1,true), "title-only record never receives exact-stage compact context")
    check(text:find("courier received the report",1,true), "conservative historical consequence remains")
    p.journal[2].qid = ids[2]
    text = tell(p,true,0,"we")
    check(not text:find("FORBIDDEN",1,true) and not lineAt(text, A.Lore.questStoryIDs[ids[2]].highlight),
        "mismatched exact ID and title cannot authorize either compact stage")
end
local rows = Study.materialize(dofile("StorageInvestigation/storytelling-thirty-20261013/v2/fixtures.lua"),
    Study.questCatalog("StorageInvestigation/journal-voice/review/corpus_vanilla_quests.txt"))
local function chapters(row, companion, brief, retell, voice)
    local p = Study.clone(companion and row.sharedPerson or row.person)
    local player = Study.clone(row.person)
    if companion then
        local c = row.spec.companion
        p.name, p.race, p.class, p.faction, p.pronouns, p.bond = c.name, c.race, c.class, c.faction, c.pronouns, c.bond
        p.self, p.origin, p.retell = nil, nil, retell
        p.journal = Study.clone(row.sharedJournal)
    end
    A.SelfPerson = function() return player end
    local saved = Study.json({p, player})
    local days = A.JournalBook(p)
    local stories = companion and A.JournalTale.Tell(p, days, voice or "we", player, brief) or A.SelfTale.Tell(p, days, brief, retell)
    check(saved == Study.json({p, player}), "render preserves raw evidence and identity")
    local out = {}
    for _, day in ipairs(days) do if stories[day.key] then out[day.key] = A.JournalPlain(stories[day.key].text) end end
    return out
end

local byName = {}
for _, row in ipairs(rows) do byName[row.spec.name] = row end
local actual = {
    {"Gromm","2024-04-09",{1061,1062,1058,1483,1093},{"Seereth","Jin'Zil","elves","Ziz","Gerenzo","Venture Co. Logger"}},
    {"Gromm","2024-06-30",{584,588,596},{"Yenniku","Nimboya","Kin'weelay"}},
    {"Cera","2024-11-02",{5542,5543,5544,5241,5211},{"Tirion","winter","Pamela","rabbits","berry jam","Carlin"}},
    {"Durn","2024-07-30",{2866,2867,2869},{"warm","glyphs","Shandris","Latronicus"}},
}
local function actualAt(text,id,brief)
    local q=A.Lore.questStoryIDs[id]
    for _,line in ipairs(brief and q.highlight or q.after) do
        local plain=A.JournalPlain(line)
        local at=text:find(plain,1,true) or text:find(plain:gsub("^%u",string.lower),1,true)
        if at then return at end
    end
end
for retell=0,7 do for _,companion in ipairs({false,true}) do for _,brief in ipairs({false,true}) do
    for _,voice in ipairs({"we","you"}) do
        for _,case in ipairs(actual) do
            local out=chapters(byName[case[1]],companion,brief,retell,voice)
            local text=assert(out[case[2]])
            local previous=0
            for _,id in ipairs(case[3]) do
                local at=actualAt(text,id,brief)
                check(at and at>previous,"actual chapter preserves ordered stage "..id..": "..text)
                previous=at
            end
            if brief then
                for _,word in ipairs(case[4]) do check(text:find(word,1,true),"short chapter preserves meaning: "..word.." "..text) end
                if case[1]=="Cera" then
                    local food=actualAt(text,5544,true)
                    local memory=actualAt(text,5241,true)
                    check(text:sub(food,memory):find("\n\n",1,true),"food and Darrowshire form separate purposes")
                elseif case[2]=="2024-04-09" then
                    local jin,ziz=actualAt(text,1058,true),actualAt(text,1483,true)
                    check(text:sub(jin,ziz):find("\n\n",1,true),"Jin'Zil and Ziz have distinct scene paragraphs")
                end
            end
        end
    end
end end end
for retell=0,7 do
    local full=chapters(byName.Elandra,false,false,retell)
    local short=chapters(byName.Elandra,false,true,retell)
    check(short["2024-01-02"]==full["2024-01-02"],"unauthored compact beginning retains full formative scenes")
    local moon=assert(short["2024-01-11"])
    for _,word in ipairs({"Tenaron","Nordrassil","Hyjal","Elune","Well of Eternity","Tallonkai","dreamcatcher"}) do
        check(moon:find(word,1,true),"formative chapter retains cultural and quiet detail: "..word)
    end
    local g=chapters(byName.Gromm,false,true,retell)
    check(g["2024-12-21"]:find("Gehennas",1,true),"raid defeat survives shorter edition")
    check(short["2025-01-14"]:find("campfire",1,true) or short["2025-01-14"]:find("fire",1,true),"quiet rest survives shorter edition")
end
local travelSeen = false
for retell=0,15 do for _,voice in ipairs({"we","you"}) do
    local text=assert(chapters(byName.Talla,true,true,retell,voice)["2024-04-09"])
    check(not text:find("Mountains was the country",1,true),"plural place fits companion exploration opening")
    -- (since 2026-11-06 a return after three weeks opens on the elapsed time and the place; the plural place is still the point)
    if text:find("travelled together through the Stonetalon Mountains",1,true) or (text:find("three weeks",1,true) and text:find("in the Stonetalon Mountains",1,true)) then travelSeen=true end
end end
check(travelSeen,"actual Talla retells exercise the revised travel opening")
local inversionSeen = false
for retell=0,31 do for _,brief in ipairs({false,true}) do for _,voice in ipairs({"we","you"}) do
    for _,case in ipairs({{"Durn","2024-03-16"},{"Fenn","2024-06-01"}}) do
        local text=assert(chapters(byName[case[1]],true,brief,retell,voice)[case[2]])
        check(not text:find("were,? for ") and not text:find("were together, for ",1,true), "fronted place leaves a complete duration predicate: "..text)
        -- (since 2026-11-06 these returns open on the elapsed time; the fronted duration is then not needed)
        if text:find("stayed for ",1,true) or text:find("three weeks",1,true) or text:find("month",1,true) then inversionSeen=true end
    end
end end end
check(inversionSeen,"actual retells exercise corrected place-fronted duration")
for retell=0,7 do
    local text=assert(chapters(byName.Elandra,false,false,retell)["2024-08-30"])
    check(not text:find("In Desolace, Beyond",1,true),"Beyond is lowercase after field prefix")
end
print("StoryHighlightsScenes: " .. checks .. " checks passed")
