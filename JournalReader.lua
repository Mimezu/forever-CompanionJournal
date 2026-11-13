local _, A = ...
-- Reading experiments are disposable compositions of recorded scenes. They
-- never rewrite journals, change Retell seeds, or invent missing episodes.
A.defaults.readerEdition = "original"
local R = {}
A.JournalReader = R
R.choices = {
    {"original", "Original", "The current journal, on a larger page."},
    {"tale", "Your tale", "A continuous telling, with chapters for places and expeditions."},
    {"ours", "Our story", "A companion's shared history, told in our voice."},
    {"fire", "By the fire", "A shorter telling of one recorded episode at a time."},
}
function R.Valid(key)
    for _, choice in ipairs(R.choices) do if choice[1] == key then return key end end
    return "original"
end
local function Copy(t)
    local out = {}; for k, v in pairs(t) do out[k] = v end; return out
end
local function Name(p) return p.display or (p.name or "Companion"):gsub("%-.*$", "") end
local function Stamp(day)
    return day.month and day.month ~= "" and (tostring(day.dayNumber) .. " " .. day.month .. " " .. day.year) or day.sourceDay
end
-- Personal journals select only people recorded by that character, including
-- when reading an alt's book. Prefer a spouse; never silently borrow our own.
function R.Companions(person)
    if not person.self then return {{key = person.__key or person.name, person = person, name = Name(person)}} end
    local owner = person.charKey or (A.Me and A.Me())
    local character = A.db.characters and A.db.characters[owner]
    local out = {}
    for key in pairs(character and character.people or {}) do
        local p = A.PersonAs and A.PersonAs(key, owner)
        if p and not p.npc and type(p.journal) == "table" and #p.journal > 0 then
            out[#out + 1] = {key = key, person = p, name = Name(p)}
        end
    end
    table.sort(out, function(a, b)
        if (a.person.bond == "spouse") ~= (b.person.bond == "spouse") then return a.person.bond == "spouse" end
        if a.name ~= b.name then return a.name < b.name end
        return a.key < b.key
    end)
    return out
end
-- Split at recorded changes of place, never reorder by topic. A return to a
-- place is a later episode, not a pretext to move its quests into an earlier one.
function R.Episodes(days)
    local result = {}
    for _, day in ipairs(days) do
        local current
        for _, scene in ipairs(day.scenes or {}) do
            local zone = scene.zone
            if not current or (zone and current.region and zone ~= current.region) then
                current = Copy(day)
                current.key = day.key .. ":reading:" .. (#result + 1)
                current.sourceDay, current.scenes = day.key, {}
                current.readerEpisode = true
                current.t = scene.t or day.t
                current.region = zone
                result[#result + 1] = current
            end
            current.region = current.region or zone
            current.scenes[#current.scenes + 1] = scene
            current.lastT = math.max(current.lastT or current.t, scene.e or scene.t or current.t)
        end
    end
    return result
end
function R.Build(person, edition, player)
    local episodes = R.Episodes(A.JournalBook(person))
    local Kept = A.TellCache
    local stories = person.self and (Kept and Kept.Told("reader:self", person, episodes, {fire = edition == "fire"}, function()
            return A.SelfTale.Tell(person, episodes, edition == "fire") end) or A.SelfTale.Tell(person, episodes, edition == "fire"))
        or (Kept and Kept.Told("reader:tale", person, episodes, {fire = edition == "fire", player = player or false}, function()
            return A.JournalTale.Tell(person, episodes, "we", player, edition == "fire") end) or A.JournalTale.Tell(person, episodes, "we", player, edition == "fire"))
    local chapters, byKey = {}, {}
    for _, episode in ipairs(episodes) do
        local story = stories[episode.key]
        if story and (story.text ~= "" or #(story.quotes or {}) > 0) then
            local previous = chapters[#chapters]
            -- Longer editions can continue a place across adjacent sessions.
            -- Each source episode was told separately, so dates/rests stay true.
            local join = edition ~= "fire" and previous and episode.region
                and previous.day.region == episode.region
                and episode.t - previous.day.lastT < 7 * 86400
            if join then
                local day, text = previous.day, byKey[previous.day.key]
                if story.text ~= "" then text.text = text.text .. (text.text ~= "" and "\n\n" or "") .. story.text end
                for _, quote in ipairs(story.quotes or {}) do text.quotes[#text.quotes + 1] = quote end
                for _, scene in ipairs(episode.scenes) do day.scenes[#day.scenes + 1] = scene end
                day.lastT, day.lastSourceDay = episode.lastT, episode.sourceDay
                day.readerDate = Stamp(day) .. (day.sourceDay ~= day.lastSourceDay and ("  /  " .. Stamp(episode)) or "")
            else
                local day = Copy(episode)
                day.scenes = {}; for _, scene in ipairs(episode.scenes) do day.scenes[#day.scenes + 1] = scene end
                day.readerDate, day.lastSourceDay = Stamp(episode), episode.sourceDay
                day.readerTitle = episode.region or story.title or "A remembered moment"
                day.readerEdition = edition
                local entry = {text = story.text, title = day.readerTitle, chapter = #chapters + 1, quotes = {}}
                for _, quote in ipairs(story.quotes or {}) do entry.quotes[#entry.quotes + 1] = quote end
                byKey[day.key] = entry
                chapters[#chapters + 1] = {day = day}
            end
        end
    end
    return chapters, function(day) return byKey[day.key] end
end
