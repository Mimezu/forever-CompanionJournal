local _, A = ...
-- Canonical lore remains available to source audits. Player-facing references
-- use a separate projection of what the logged-in reader has actually learned.
local facts, policies, questPolicies, tracked = {}, {}, {}, {}

local function Public(value) return not issecretvalue or not issecretvalue(value) end
local function QuestID(value)
    if not Public(value) or type(value) ~= "number" or value <= 0 or value == math.huge or value ~= math.floor(value) then return nil end
    return value
end
local function Copy(value)
    if type(value) ~= "table" then return value end
    local out = {}
    for key, item in pairs(value) do out[key] = Copy(item) end
    return out
end
local function Character()
    local key = A.Me and A.Me()
    local characters = A.db and A.db.characters
    local record = key and type(characters) == "table" and characters[key]
    return type(record) == "table" and record or nil, key
end
local function HasAll(knowledge, required)
    for _, fact in ipairs(required or {}) do
        if not knowledge[fact] then return false end
    end
    return true
end
local function HasAny(knowledge, required)
    for _, fact in ipairs(required or {}) do if knowledge[fact] then return true end end
    return false
end
local function Evidence(value, stage)
    if type(value) ~= "table" then return false end
    if stage == "presented" then return value.origin == "quest-detail" end
    return stage == "completed" and (value.origin == "quest-turn-in" or value.origin == "game-history")
end
local function ValidateRequirements(required, available)
    for _, key in ipairs(required or {}) do assert(available[key], "Unknown discovery fact: " .. tostring(key)) end
end
function A.RegisterLoreDiscovery(policy)
    assert(type(policy) == "table", "Discovery policy required")
    local available = Copy(facts)
    for key, fact in pairs(policy.facts or {}) do
        assert(not available[key], "Duplicate discovery fact: " .. key)
        available[key] = fact
        for _, stage in ipairs({"presented", "completed"}) do
            for _, qid in ipairs(fact[stage] or {}) do assert(QuestID(qid), "Exact discovery quest ID required") end
        end
    end
    for index, group in ipairs({policy.notes or {}, policy.quests or {}}) do
        for key, rule in pairs(group) do
            assert(not (index == 1 and policies[key] or index == 2 and questPolicies[key]), "Duplicate discovery policy: " .. key)
            assert(rule.public == false or (type(rule.public) == "table" and type(rule.public.body) == "string"
                and type(rule.public.sources) == "table" and type(rule.public.related) == "table"), "Explicit public projection required")
            ValidateRequirements(rule.visibleRequires, available)
            ValidateRequirements(rule.canonicalRequires, available)
            for _, block in ipairs(rule.blocks or {}) do
                ValidateRequirements(block.requires, available)
                ValidateRequirements(block.unless, available)
            end
        end
    end
    for key, fact in pairs(policy.facts or {}) do
        facts[key] = Copy(fact)
        for _, stage in ipairs({"presented", "completed"}) do
            for _, qid in ipairs(fact[stage] or {}) do
                tracked[qid] = tracked[qid] or {}
                tracked[qid][stage] = true
                -- Completion supports a description only where the author
                -- explicitly mapped it. No inferred chain-wide inheritance.
            end
        end
    end
    for id, rule in pairs(policy.notes or {}) do assert(not policies[id]); policies[id] = Copy(rule) end
    for title, rule in pairs(policy.quests or {}) do assert(not questPolicies[title]); questPolicies[title] = Copy(rule) end
end

-- Read-only recovery from this character's own exact completion records. No
-- title guessing, alt journals, shared NPC cards or companion histories.
function A.LoreKnowledge()
    local character = Character()
    local journal = character and character.journal
    local ledger = character and character.loreDiscoveries
    -- Journal repair can replace records without changing its length. Build a
    -- small knowledge snapshot per reference read rather than cache stale facts.
    local completed, presented = {}, {}
    if type(ledger) == "table" then
        for qid, evidence in pairs(type(ledger.completed) == "table" and ledger.completed or {}) do
            if QuestID(qid) and Evidence(evidence, "completed") then completed[qid] = true end
        end
        for qid, evidence in pairs(type(ledger.presented) == "table" and ledger.presented or {}) do
            if QuestID(qid) and Evidence(evidence, "presented") then presented[qid] = true end
        end
    end
    for _, event in ipairs(type(journal) == "table" and journal or {}) do
        if type(event) == "table" and event.k == "quest" and QuestID(event.qid) and not event.imported and not event.seeded and not event.s then
            completed[event.qid] = true
        end
    end
    local knowledge = {}
    for key, fact in pairs(facts) do
        for _, qid in ipairs(fact.presented or {}) do if presented[qid] then knowledge[key] = true end end
        for _, qid in ipairs(fact.completed or {}) do if completed[qid] then knowledge[key] = true end end
    end
    return knowledge
end
local function Changed()
    if A.RefreshOpenLoreNote then A.RefreshOpenLoreNote() end
end
local function Record(stage, value, origin)
    local qid = QuestID(value)
    if not qid or not tracked[qid] or not tracked[qid][stage] then return false end
    local character = Character()
    if not character then return false end
    if type(character.loreDiscoveries) ~= "table" then character.loreDiscoveries = {version = 1, revision = 0} end
    local ledger = character.loreDiscoveries
    if type(ledger[stage]) ~= "table" then ledger[stage] = {} end
    if Evidence(ledger[stage][qid], stage) then return false end
    local evidence = {origin = origin}
    if origin ~= "game-history" then evidence.at = time and time() or nil end
    ledger[stage][qid] = evidence
    ledger.revision = (tonumber(ledger.revision) or 0) + 1
    Changed()
    return true
end
-- Explicit recovery runs on game events, never while opening or hovering a
-- reference. Only positive current-character answers are stored; no fabricated
-- historical timestamps and no forgetting when a client API is unavailable.
function A.RecoverLoreDiscoveries()
    local query = C_QuestLog and C_QuestLog.IsQuestFlaggedCompleted or IsQuestFlaggedCompleted
    if type(query) ~= "function" then return end
    for qid, stages in pairs(tracked) do
        if stages.completed then
            local ok, complete = pcall(query, qid)
            if ok and Public(complete) and complete == true then Record("completed", qid, "game-history") end
        end
    end
end

local function MergeUnique(first, second)
    local out, seen = {}, {}
    for _, list in ipairs({first or {}, second or {}}) do
        for _, value in ipairs(list) do if not seen[value] then out[#out + 1] = value; seen[value] = true end end
    end
    return out
end
local function Reference(entry)
    -- Do not let the UI retain raw aliases, claim metadata or shared tables.
    local out = {}
    for _, field in ipairs({"id", "title", "kind", "body", "sources", "related", "setting", "contextLabel", "zone"}) do
        out[field] = Copy(entry[field])
    end
    return out
end
function A.GetKnownLoreNote(id, knowledge)
    local entry = A.GetLoreNote and A.GetLoreNote(id)
    if not entry then return nil end
    knowledge = knowledge or A.LoreKnowledge()
    local rule = policies[id] or (entry.kind == "Quest" and questPolicies[entry.title])
    if not rule then return Reference(entry) end
    if rule.visibleRequires and not HasAll(knowledge, rule.visibleRequires) then return nil end
    if rule.canonicalRequires and HasAll(knowledge, rule.canonicalRequires) then return Reference(entry) end
    if rule.public == false then return nil end
    local out = {id = id, title = rule.public.title or entry.title, kind = entry.kind, setting = entry.setting}
    for _, field in ipairs({"body", "sources", "related", "contextLabel", "zone"}) do out[field] = Copy(rule.public[field]) end
    for _, block in ipairs(rule.blocks or {}) do
        if HasAll(knowledge, block.requires) and not HasAny(knowledge, block.unless) then
            if block.body and block.body ~= "" then out.body = out.body .. "\n\n" .. block.body end
            out.sources = MergeUnique(out.sources, block.sources)
            -- Newly learned associations take precedence over the three public
            -- footer slots without letting an unrevealed raw edge slip through.
            out.related = MergeUnique(block.related, out.related)
        end
    end
    return out
end

if CreateFrame then
    local frame = CreateFrame("Frame")
    for _, event in ipairs({"QUEST_DETAIL", "QUEST_TURNED_IN", "PLAYER_ENTERING_WORLD", "QUEST_LOG_UPDATE"}) do
        pcall(frame.RegisterEvent, frame, event)
    end
    frame:SetScript("OnEvent", function(_, event, qid)
        if event == "QUEST_DETAIL" then
            if type(GetQuestID) == "function" then
                local ok, id = pcall(GetQuestID)
                if ok then Record("presented", id, "quest-detail") end
            end
        elseif event == "QUEST_TURNED_IN" then Record("completed", qid, "quest-turn-in")
        else A.RecoverLoreDiscoveries() end
    end)
end
