local root, A = "Interface/AddOns/CompanionJournal/", {defaults = {colors = {}}}
local baseOutcome
function time(t) return t and os.time(t) or 1792000000 end
function date(f, t) return os.date(f, t) end
for _, name in ipairs({"LoreData", "Lore", "LoreHordeStories", "LoreAllianceStories", "LoreWorldStories", "LoreClassStories",
    "JournalBook", "JournalTellers", "JournalTale", "JournalWords", "JournalSelfWords", "JournalSelfTale", "LoreNotes"}) do
    assert(loadfile(root .. name .. ".lua"))("CompanionJournal", A)
    if name == "Lore" then baseOutcome = table.concat(A.Lore.QuestStory("The Legend of Stalvan", 66).after, " ") end
end
local count, title = 0, "The Legend of Stalvan"
local function Check(ok, why) count = count + 1; assert(ok, why) end
Check(baseOutcome and not baseOutcome:find("blood thirst", 1, true) and not baseOutcome:find("dead", 1, true), "base fallback must be safe even without regional packs")
local function Story(qid, brief, retell, companion)
    local t = time({year = 2026, month = 4, day = 9, hour = 18})
    local p = {name = "Arlen", charKey = "stalvan", self = not companion, race = "Human", class = "WARRIOR", faction = "Alliance",
        origin = "together", startLevel = 28, retell = retell, journal = {
            {k = companion and "group" or "play", t = t, e = t + 7200, z = "Duskwood", pl = 28, ol = 28},
            {k = "quest", d = title, qid = qid, t = t + 1200, z = "Duskwood", pl = 28, ol = 28}}}
    local days, text = A.JournalBook(p), {}
    local tales = companion and A.JournalTale.Tell(p, days, "we", {name = "Mira", race = "Human", class = "PRIEST", faction = "Alliance"}, brief)
        or A.SelfTale.Tell(p, days, brief, retell)
    for _, day in ipairs(days) do if tales[day.key] then text[#text + 1] = A.JournalPlain(tales[day.key].text) end end
    Check(#p.journal == 2 and p.journal[2].qid == qid, "rendering changed recorded evidence")
    return table.concat(text, "\n")
end
for _, qid in ipairs({66, 67, false, 98}) do
    local finalSeen = false
    for _, companion in ipairs({false, true}) do for _, brief in ipairs({false, true}) do for retell = 0, 7 do
        local text = Story(qid or nil, brief, retell, companion)
        if qid ~= 98 then
            for _, bad in ipairs({"blood thirst", "Stalvan was dead", "killing days", "family ring", "execution", "killings"}) do
                Check(not text:find(bad, 1, true), "early/title-only stage invents ending: " .. text)
            end
            if qid == 66 then Check(not text:find("cottage", 1, true), "first referral invents later location") end
        else
            finalSeen = finalSeen or text:find("Stalvan was dead", 1, true) or text:find("killing days", 1, true)
        end
        Check(text == Story(qid or nil, brief, retell, companion), "retell is nondeterministic")
    end end end
    if qid == 98 then Check(finalSeen, "exact execution no longer retains its real outcome") end
end
for _, context in ipairs({{}, {qid = 66}, {qid = 98}, {qid = 67}}) do
    local id = A.LoreNoteResolve("q", title, context)
    local note = id and A.GetLoreNote(id)
    Check(note and note.body:find("town hall", 1, true) and note.body:find("Darkshire", 1, true), "reference retains understandable inquiry context")
    Check(not note.body:find("execution", 1, true) and not note.body:find("dead", 1, true), "reference never borrows final outcome")
end
print("StalvanStages: " .. count .. " assertions passed")
print(Story(66, false, 0, false))
print(Story(98, false, 0, false))
