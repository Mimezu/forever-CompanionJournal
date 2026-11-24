-- The last read of a chapter of your own book (JournalSelfPolish.lua), rule by rule, on the
-- sentences of Alberich's book that read wrong on 2026-11-24.
-- Run from the client root: lua5.1 Interface/AddOns/CompanionJournal/tests/Polish.lua
local root = "Interface/AddOns/CompanionJournal/"
local A = {}
assert(loadfile(root .. "JournalSelfPolish.lua"))("CompanionJournal", A)
local P = A.SelfPolish
local checks = 0
local function same(got, want, label)
    checks = checks + 1
    if got ~= want then error(label .. "\n  got:  " .. tostring(got) .. "\n  want: " .. tostring(want), 2) end
end

-- 1. An opening that only says where you were, then leaving it: one sentence, yours.
same(P.Apply("Monday evening I set out again in the {p:Undercity}. We left the {p:Undercity} for the {p:Arathi Highlands}, where {n:Dahlia} caught up with me."),
    "Monday evening, I left the {p:Undercity} for the {p:Arathi Highlands}, where {n:Dahlia} caught up with me.", "opening folded")
same(P.Apply("The next day, I was still in {p:Orgrimmar}. I spoke with Thrall."),
    "The next day, I was still in {p:Orgrimmar}. I spoke with Thrall.", "an opening with work there stays")

-- 2. Alone until someone joined.
same(P.Apply("We left {p:Thunder Bluff} for {p:Thousand Needles}, where {n:Dahlia} joined me."),
    "I left {p:Thunder Bluff} for {p:Thousand Needles}, where {n:Dahlia} joined me.", "we before the join")
same(P.Apply("We left {p:Brill} with {n:Marrow} for the {p:Undercity}, where {n:Dahlia} joined me."),
    "We left {p:Brill} with {n:Marrow} for the {p:Undercity}, where {n:Dahlia} joined me.", "someone already with me: we")

-- 3. Foes by what they are.
same(P.Apply("{p:Arcane Anomaly} killed me. {p:Arcane Anomaly} fell. We killed Relic Guardian.", {"Arcane Anomaly", "Relic Guardian"}),
    "The {p:Arcane Anomaly} killed me, but it fell in the end. We killed the Relic Guardian.", "the generic foe")
same(P.Apply("{p:Mutanus the Devourer} fell. {p:Lord Cobrahn} fell.", {"Mutanus the Devourer", "Lord Cobrahn"}),
    "{p:Mutanus the Devourer} fell. {p:Lord Cobrahn} fell.", "a name of its own keeps no article")
same(P.Apply("A {p:Rumbling Exile} ran.", {"Rumbling Exile"}), "A {p:Rumbling Exile} ran.", "an article already there")
same(P.Generic("Shade of the Archmage"), true, "a kind of someone")
same(P.Generic("Lyn the Ignored"), false, "an epithet")

-- 4. A place again in the next sentence.
same(P.Apply("We swam a long way out into the {p:Vile Reef}. We took a shard of Gri'lek's tablet from the Vile Reef."),
    "We swam a long way out into the {p:Vile Reef}. We took a shard of Gri'lek's tablet there.", "there")
same(P.Apply("Our hearthstones carried us back to {p:Brill}. We were home again in {p:Brill}, with its tavern. Next came the {p:Hillsbrad Foothills}."),
    "Our hearthstones carried us back to {p:Brill}. Next came the {p:Hillsbrad Foothills}.", "home again, said once")
same(P.Apply("We thinned the deviate spawn in the Wailing Caverns. From the {p:Wailing Caverns}, we went on to the {p:Barrens}."),
    "We thinned the deviate spawn in the Wailing Caverns. From there, we went on to the {p:Barrens}.", "from there")

-- 5. A level on someone else's words.
same(P.Apply("A woman inside pleaded with us to spare her, and level 36 came with it."),
    "A woman inside pleaded with us to spare her. I reached level 36.", "the level apart")
same(P.Apply("We brought down {p:Ghamoo-ra}, and level 23 came with it."),
    "We brought down {p:Ghamoo-ra}, and level 23 came with it.", "a deed keeps its level")

-- 6. A name with a colon.
same(P.Apply("We left {p:Tarren Mill} for {p:Excavation Site: Wetlands}. We went into Excavation Site: Wetlands."),
    "We left {p:Tarren Mill} for the {p:Wetlands Excavation Site}. We went into the Wetlands Excavation Site.", "colon names")

-- After a pastime, a join keeps no place; a bare errand to where the next sentence goes is dropped.
same(P.Apply("I fished at {p:Tarren Mill} for two hours, and caught over a hundred fish.\n\n{n:Marrow} caught up with me there."),
    "I fished at {p:Tarren Mill} for two hours, and caught over a hundred fish.\n\n{n:Marrow} caught up with me.", "join after a pastime")
same(P.Apply("We went to the {p:Alterac Mountains} on an errand.\n\nWe left the {p:Hillsbrad Foothills} for the {p:Alterac Mountains}."),
    "We left the {p:Hillsbrad Foothills} for the {p:Alterac Mountains}.", "bare errand")

print("Polish: " .. checks .. " checks passed")
