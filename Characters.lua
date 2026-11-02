local _, A = ...
-- Your characters, each with their own people. A person has one card for the
-- whole account (name, display name, icon, color, note, pronouns, class, race,
-- last seen: CompanionJournalDB.people) and, for each of your characters who
-- knows them, a relationship (their circle, how it began, the bond, when you
-- met, the journal: CompanionJournalDB.characters[you].people). NPCs are
-- notes, not relationships: shared by all your characters unless marked
-- "this character only".
-- In play, A.People[key] is a person as the current character knows them: a
-- view that reads and writes the card or the relationship, whichever holds
-- the field. Other characters' people are recognized in the world (their icon
-- and name, rivals only on the side they were made from) and can be imported.
local function Public(value) return not issecretvalue or not issecretvalue(value) end
local function Text(value) return Public(value) and type(value) == "string" and value ~= "" and value or nil end
local function Now() return time and time() or 0 end

-- What belongs to a character's relationship (the rest is the shared card).
local REL = {circle = true, journal = true, met = true, metZone = true, metHow = true, added = true,
    origin = true, bond = true, retell = true}
A.RelationshipFields = REL

-- Other characters' people show in the world with a chain link (not their
-- own icon): gold for companions, silver for acquaintances, red for rivals
-- (on either side: an old rival met on a new character of their side), so you
-- can tell them apart and decide whether to add them here. Campfire: nothing.
A.defaults.peopleRecognize = true
A.defaults.colors.recognizedCompanion = {1, 0.78, 0.25}
A.defaults.colors.recognizedAcquaintance = {0.78, 0.8, 0.86}
A.defaults.colors.recognizedRival = {0.9, 0.22, 0.16}

-- You -------------------------------------------------------------------------------
local me
-- Early in loading the game still calls you "Unknown": never a character.
local function Unknown(name) return name == UNKNOWNOBJECT or name == UNKNOWN or name == "Unknown" end
function A.Me()
    if me then return me end
    local ok, name = pcall(UnitName, "player")
    name = ok and Text(name)
    if not name or Unknown(name) or not A.PersonKey then return nil end
    me = (A.PersonKey(name))
    return me
end
local function Characters(create)
    local db = A.db
    if type(db.characters) ~= "table" then
        if not create then return nil end
        db.characters = {}
    end
    return db.characters
end
-- Before the first login of 1.3 (and in tests): one list for everyone.
local function Shared() return type(A.db.characters) ~= "table" or not A.Me() end
-- This character's record: {name, faction, class, race, people = {key = relationship}}.
function A.MyCharacter(create)
    local key = A.Me()
    local all = key and Characters(create)
    if not all then return nil end
    local mine = all[key]
    if type(mine) ~= "table" then
        if not create then return nil end
        mine = {people = {}}
        all[key] = mine
    end
    mine.people = type(mine.people) == "table" and mine.people or {}
    return mine
end
local function MyRelations(create)
    local mine = A.MyCharacter(create)
    return mine and mine.people
end
-- An NPC marked for one character only is hidden on the others.
local function NPCHere(card) return not card.only or card.only == A.Me() end

-- The view of a person for this character ----------------------------------------------
local views = {}
local function View(key)
    local card = A.db.people[key]
    if type(card) ~= "table" then return nil end
    if Shared() then return card end
    local rel
    if card.npc then
        if not NPCHere(card) then return nil end
    else
        local relations = MyRelations()
        rel = relations and relations[key]
        if type(rel) ~= "table" then return nil end
    end
    local view = views[key]
    if view and view.__card == card and view.__rel == rel then return view end
    view = setmetatable({}, {
        __index = function(_, field)
            if field == "__card" then return card end
            if field == "__rel" then return rel end
            if field == "__key" then return key end
            if rel and REL[field] then return rel[field] end
            return card[field]
        end,
        __newindex = function(_, field, value)
            if rel and REL[field] then rel[field] = value else card[field] = value end
        end,
    })
    views[key] = view
    return view
end
-- A.People[key]: this character's person (or a shared NPC). Assigning a table
-- adds them (its fields split into card and relationship); assigning nil
-- removes them from this character (the card stays while anyone knows them).
A.People = setmetatable({}, {
    __index = function(_, key) return View(key) end,
    __newindex = function(_, key, value)
        local cards = A.db.people
        if Shared() then cards[key] = value; return end
        if value == nil then
            local card = cards[key]
            if type(card) == "table" and card.npc then
                cards[key] = nil
            else
                local relations = MyRelations()
                if relations then relations[key] = nil end
                if not A.AnyoneKnows(key) then cards[key] = nil end
            end
            return
        end
        local card = type(cards[key]) == "table" and cards[key] or {}
        cards[key] = card
        local rel
        if not value.npc then
            local relations = MyRelations(true)
            rel = type(relations[key]) == "table" and relations[key] or {}
            relations[key] = rel
        end
        for field, item in pairs(value) do
            if rel and REL[field] then rel[field] = item else card[field] = item end
        end
    end,
})
-- Someone new to this character. Their card's fields (name, icon...) apply
-- only to a new card: someone your other characters know keeps theirs.
function A.NewPerson(key, fields)
    local card = A.db.people[key]
    if type(card) == "table" and not fields.npc and not Shared() then
        local rel = {}
        for field, value in pairs(fields) do if REL[field] then rel[field] = value end end
        for field, value in pairs(fields) do if not REL[field] and card[field] == nil then card[field] = value end end
        A.People[key] = rel
    else
        A.People[key] = fields
    end
    return A.People[key]
end
-- Every person this character knows (and the NPCs shown here): key, view.
function A.EachPerson()
    local keys = {}
    local shared = Shared()
    for key, card in pairs(A.db.people) do
        if shared or type(card) == "table" and card.npc then keys[#keys + 1] = key end
    end
    if not shared then
        for key in pairs(MyRelations() or {}) do keys[#keys + 1] = key end
    end
    local i = 0
    return function()
        while true do
            i = i + 1
            local key = keys[i]
            if not key then return nil end
            local view = View(key)
            if view then return key, view end
        end
    end
end
function A.HasPeople() return A.EachPerson()() ~= nil end
function A.AnyoneKnows(key)
    for _, character in pairs(Characters() or {}) do
        if type(character) == "table" and type(character.people) == "table" and character.people[key] then return true end
    end
    return false
end
-- NPCs: "this character only" (a class trainer) or everyone's.
function A.SetNPCOnlyHere(person, on)
    if not person or not person.npc then return end
    person.only = on and A.Me() or nil
    A.Refresh()
end

-- Your other characters' people ------------------------------------------------------------
local function CharacterName(charKey, character)
    -- (players waiting for your next character of their side; older data says "(from before)")
    if type(character) == "table" and character.earlier then return "Next " .. (character.faction or "other side") .. " character" end
    if type(character) == "table" and character.name then return character.name end
    return (charKey:gsub("%-.*$", ""):gsub("^%l", string.upper))
end
A.CharacterName = function(charKey) return CharacterName(charKey, (Characters() or {})[charKey]) end
-- Your other characters: sorted {key, name, faction, class, count}.
function A.OtherCharacters()
    local out = {}
    for charKey, character in pairs(Characters() or {}) do
        if charKey ~= A.Me() and type(character) == "table" and type(character.people) == "table" then
            local count = 0
            for key in pairs(character.people) do
                if type(A.db.people[key]) == "table" then count = count + 1 end
            end
            if count > 0 then
                out[#out + 1] = {key = charKey, name = CharacterName(charKey, character), faction = character.faction,
                    class = character.class, count = count, earlier = character.earlier}
            end
        end
    end
    table.sort(out, function(a, b)
        if (a.earlier and 1 or 0) ~= (b.earlier and 1 or 0) then return not a.earlier end
        return a.name < b.name
    end)
    return out
end
-- Who else knows them: sorted {key, name, faction, rel} (not this character).
function A.OtherKnowers(key)
    local out = {}
    local mine = A.Me()
    for charKey, character in pairs(Characters() or {}) do
        local rel = charKey ~= mine and type(character) == "table" and type(character.people) == "table" and character.people[key]
        if type(rel) == "table" then
            out[#out + 1] = {key = charKey, name = CharacterName(charKey, character), faction = character.faction, rel = rel,
                earlier = character.earlier}
        end
    end
    table.sort(out, function(a, b) return a.name < b.name end)
    return out
end
-- Who carries over from another character: companions, acquaintances and
-- rivals. Campfire people stay with their character. Returns a rank (the
-- strongest wins when your characters disagree: gold, red, then silver).
local RANK = {companion = 3, rival = 2, acquaintance = 1}
local function Carries(knower)
    return RANK[knower.rel.circle or "companion"]
end
A.CarriesOver = Carries
-- Recognized in the world: someone another character of yours knows, while
-- "recognize" is on. A view with that character's circle; their journal and
-- story fields stay theirs (nothing is written to them from here).
local recognized = {}
function A.Recognize(key)
    local db = A.db
    if not db.peopleRecognize or Shared() or type(db.people[key]) ~= "table" or db.people[key].npc then return nil end
    local best
    local bestRank = 0
    for _, knower in ipairs(A.OtherKnowers(key)) do
        -- Gold over red over silver: a companion anywhere wins, then a rival, then an acquaintance.
        local rank = Carries(knower)
        if rank and rank > bestRank then best, bestRank = knower, rank end
    end
    if not best then return nil end
    local card = db.people[key]
    local cached = recognized[key]
    if cached and cached.__card == card and cached.__rel == best.rel then return cached end
    local rel, by = best.rel, best.name
    local view = setmetatable({}, {
        __index = function(_, field)
            if field == "__card" then return card end
            if field == "__rel" then return rel end
            if field == "__key" then return key end
            if field == "recognizedBy" then return by end
            if field == "circle" then return rel.circle end
            if REL[field] then return nil end
            -- A chain link, not their own icon: gold for companions, silver for acquaintances.
            if field == "glyph" then return "kin" end
            if field == "color" then
                local colors = A.db.colors
                if rel.circle == "acquaintance" then return colors.recognizedAcquaintance end
                if rel.circle == "rival" then return colors.recognizedRival end
                return colors.recognizedCompanion
            end
            if field == "colorMode" or field == "iconSize" or field == "iconSide" then return nil end
            return card[field]
        end,
        __newindex = function(_, field, value) if not REL[field] then card[field] = value end end,
    })
    recognized[key] = view
    return view
end
-- Can this character take them from that one? Players of your side, and
-- rivals from either side (on theirs, you may want to meet them).
local function Usable(card, knower)
    if knower.rel.circle == "rival" then return true end
    local faction = A.PlayerFaction()
    return card.faction == nil or faction == nil or card.faction == faction
end
-- People your other characters know and this one does not (one character's,
-- or everyone's): sorted rows {key, card, rel, from, knowers, usable}, from
-- the character who can best give them (your side first, companions first).
function A.OthersPeople(charKey)
    local rows, seen = {}, {}
    local mine = MyRelations() or {}
    for otherKey, character in pairs(Characters() or {}) do
        if otherKey ~= A.Me() and (not charKey or otherKey == charKey) and type(character) == "table" and type(character.people) == "table" then
            for key in pairs(character.people) do
                local card = A.db.people[key]
                if not seen[key] and not mine[key] and type(card) == "table" and not card.npc then
                    seen[key] = true
                    local knowers = A.OtherKnowers(key)
                    local best
                    for _, knower in ipairs(knowers) do
                        if (not charKey or knower.key == charKey) and Carries(knower) then
                            local usable = Usable(card, knower)
                            local rank = (usable and 0 or 10) + (knower.rel.circle and 1 or 0)
                            if not best or rank < best.rank then best = {knower = knower, usable = usable, rank = rank} end
                        end
                    end
                    if best then
                        rows[#rows + 1] = {key = key, card = card, rel = best.knower.rel, from = best.knower.key,
                            knowers = knowers, usable = best.usable}
                    end
                end
            end
        end
    end
    local order = {companion = 1, acquaintance = 2, campfire = 3, rival = 4}
    table.sort(rows, function(a, b)
        if a.usable ~= b.usable then return a.usable end
        local ca, cb = order[a.rel.circle or "companion"] or 5, order[b.rel.circle or "companion"] or 5
        if ca ~= cb then return ca < cb end
        return (a.card.display or a.card.name or a.key):lower() < (b.card.display or b.card.name or b.key):lower()
    end)
    return rows
end
-- The circle someone takes on this character: the other character's, except
-- that an old rival of your own side comes in as an acquaintance, and the
-- other side's players are rivals here.
local function CircleHere(card, circle)
    local faction = A.PlayerFaction()
    if card.faction and faction then
        if card.faction == faction and circle == "rival" then return "acquaintance" end
        if card.faction ~= faction then return "rival" end
    end
    return circle
end
-- Import someone into this character: their card is shared (icon, name,
-- note), the circle comes along, the journal starts fresh here.
function A.ImportPerson(key, fromCharKey)
    local card = A.db.people[key]
    if type(card) ~= "table" or card.npc or Shared() then return nil end
    local relations = MyRelations(true)
    if relations[key] then return View(key) end
    local source
    for _, knower in ipairs(A.OtherKnowers(key)) do
        if knower.key == fromCharKey or not source then source = knower end
    end
    relations[key] = {circle = CircleHere(card, source and source.rel.circle), added = Now()}
    if A.db.peopleBlocked then A.db.peopleBlocked[key] = nil end
    if A.JournalAdopt then A.JournalAdopt(View(key), key) end
    if A.Refresh then A.Refresh() end
    return View(key)
end
-- A character's companions (or all your characters'), all at once;
-- everyone = every circle (still only your side).
function A.ImportFrom(charKey, everyone)
    local count = 0
    for _, row in ipairs(A.OthersPeople(charKey)) do
        local circle = row.rel.circle or "companion"
        if row.usable and (everyone or circle == "companion") then
            if A.ImportPerson(row.key, row.from) then count = count + 1 end
        end
    end
    return count
end
-- Journals your other characters keep with someone: knowers with lines.
function A.OtherJournals(key)
    local out = {}
    for _, knower in ipairs(A.OtherKnowers(key)) do
        if type(knower.rel.journal) == "table" and #knower.rel.journal > 0 then out[#out + 1] = knower end
    end
    return out
end
-- Another character's person, read-only (their journal in the journal window).
function A.PersonAs(key, charKey)
    local card = A.db.people[key]
    local character = (Characters() or {})[charKey]
    local rel = type(character) == "table" and type(character.people) == "table" and character.people[key]
    if type(card) ~= "table" or type(rel) ~= "table" then return nil end
    return setmetatable({}, {
        __index = function(_, field)
            if field == "readOnly" then return true end
            if field == "__card" then return card end
            if field == "__rel" then return rel end
            if field == "__key" then return key end
            if REL[field] then return rel[field] end
            return card[field]
        end,
        __newindex = function() end,
    })
end
-- Who "you" are in another character's journal (the storyteller's hero).
-- Another character's record (their own journal, read only).
function A.CharacterRecord(charKey)
    local character = (Characters() or {})[charKey]
    return type(character) == "table" and character or nil
end
function A.CharacterPlayer(charKey)
    local character = (Characters() or {})[charKey]
    if type(character) ~= "table" then return nil end
    return {name = CharacterName(charKey, character), race = character.race, faction = character.faction, class = character.class,
        charKey = charKey}
end

-- Moving in ---------------------------------------------------------------------------------
-- Holders for people of the other side found in the list from before 1.3:
-- shown with your other characters, ready to import on that side.
local function Earlier(all, faction)
    local key = "~" .. faction:lower()
    local holder = all[key]
    if type(holder) ~= "table" then
        holder = {faction = faction, earlier = true, people = {}}
        all[key] = holder
    end
    return holder
end
-- Cards still holding relationship fields (the list from before 1.3, or
-- people copied from Forever Names) move to this character. Journal lines
-- already marked with another character of yours go to that one; players of
-- the other side (except rivals) wait for your first character of that side.
local function MoveIn(mine, key)
    local db = A.db
    local all = Characters(true)
    local faction = mine.faction
    local moved = 0
    for personKey, card in pairs(db.people or {}) do
        if type(card) == "table" and not card.npc then
            local rel, legacy = {}, false
            for field in pairs(REL) do
                if card[field] ~= nil then legacy = true end
                rel[field] = card[field]
                card[field] = nil
            end
            if legacy or not A.AnyoneKnows(personKey) then
                moved = moved + 1
                if type(rel.journal) == "table" then
                    local stay, others = {}, {}
                    for _, entry in ipairs(rel.journal) do
                        local by = entry.by and A.PersonKey(entry.by)
                        if by and by ~= key then
                            others[by] = others[by] or {}
                            table.insert(others[by], entry)
                        else
                            stay[#stay + 1] = entry
                        end
                        entry.by = nil
                    end
                    rel.journal = #stay > 0 and stay or nil
                    for byKey, entries in pairs(others) do
                        local other = type(all[byKey]) == "table" and all[byKey] or {people = {}}
                        all[byKey] = other
                        other.people = type(other.people) == "table" and other.people or {}
                        local theirs = other.people[personKey] or {circle = rel.circle, met = rel.met, metZone = rel.metZone}
                        other.people[personKey] = theirs
                        theirs.journal = entries
                    end
                end
                local otherSide = faction and card.faction and card.faction ~= faction and rel.circle ~= "rival"
                if otherSide then
                    Earlier(all, card.faction).people[personKey] = rel
                elseif not mine.people[personKey] then
                    mine.people[personKey] = rel
                end
            end
        end
    end
    return moved
end
-- Someone's relationship from another list joins this one: kept as it is when
-- they are new here, else their journal lines are added (in time order).
local function Join(mine, personKey, rel)
    local have = mine.people[personKey]
    if type(have) ~= "table" then mine.people[personKey] = rel; return end
    for field, value in pairs(rel) do
        if field ~= "journal" and have[field] == nil then have[field] = value end
    end
    if type(rel.journal) == "table" and #rel.journal > 0 then
        have.journal = type(have.journal) == "table" and have.journal or {}
        for _, entry in ipairs(rel.journal) do table.insert(have.journal, entry) end
        table.sort(have.journal, function(a, b) return (tonumber(a.t) or 0) < (tonumber(b.t) or 0) end)
    end
end
-- 1.3.0 could file the first login under "Unknown" (the name was not known
-- yet). A list there that carries this character's name and realm is theirs.
local function Reclaim(all, key, mine)
    local realm = key:match("%-(.+)$")
    local moved = 0
    for otherKey, other in pairs(all) do
        if otherKey ~= key and type(other) == "table" and otherKey:match("^unknown%-") and otherKey:match("%-(.+)$") == realm
            and other.name and mine.name and other.name:lower() == mine.name:lower() then
            for personKey, rel in pairs(type(other.people) == "table" and other.people or {}) do
                Join(mine, personKey, rel); moved = moved + 1
            end
            for field in pairs({faction = true, class = true, race = true}) do mine[field] = mine[field] or other[field] end
            for _, card in pairs(A.db.people or {}) do
                if type(card) == "table" and card.only == otherKey then card.only = key end
            end
            if A.db.charactersFirst == otherKey then A.db.charactersFirst = key end
            all[otherKey] = nil
        end
    end
    return moved
end
-- The first character of a side to log in takes that side's players who were
-- waiting (journals included).
local function Claim(all, mine)
    local holderKey = mine.faction and ("~" .. mine.faction:lower())
    local holder = holderKey and all[holderKey]
    if type(holder) ~= "table" then return 0 end
    local moved = 0
    for personKey, rel in pairs(type(holder.people) == "table" and holder.people or {}) do
        Join(mine, personKey, rel); moved = moved + 1
    end
    all[holderKey] = nil
    return moved
end
-- A player's side when it was never recorded (people from before sides were
-- kept): you only group with your own side, so it is the side of every
-- character of yours who knows them (not as a rival), when they all agree.
local function InferredFaction(all, key)
    local found
    for _, character in pairs(all) do
        local rel = type(character) == "table" and type(character.people) == "table" and character.people[key]
        if type(rel) == "table" and rel.circle ~= "rival" and character.faction then
            if found and found ~= character.faction then return nil end
            found = character.faction
        end
    end
    return found
end
local function FillFactions(all)
    for key, card in pairs(A.db.people or {}) do
        if type(card) == "table" and not card.npc and not card.faction then card.faction = InferredFaction(all, key) end
    end
end
-- Each login: this character's name, faction, class and race (for the other
-- characters' tabs and their storyteller), then anything to move in.
function A.InitCharacters()
    local db = A.db
    local key = A.Me()
    if not key then return end
    local first = type(db.characters) ~= "table"
    local mine = A.MyCharacter(true)
    local okName, name = pcall(UnitName, "player")
    mine.name = okName and Text(name) or mine.name
    mine.faction = A.PlayerFaction() or mine.faction
    local okClass, _, class = pcall(UnitClass, "player")
    mine.class = okClass and Text(class) or mine.class
    local okRace, _, race = pcall(UnitRace, "player")
    mine.race = okRace and Text(race) or mine.race
    local all = Characters(true)
    Reclaim(all, key, mine)
    local moved = MoveIn(mine, key)
    A.claimedWaiting = Claim(all, mine)
    if A.claimedWaiting == 0 then A.claimedWaiting = nil end
    FillFactions(all)
    if first then
        db.charactersSince = Now()
        -- Where the list from before went (it can be moved: My characters).
        if moved > 0 then db.charactersFirst, A.movedToCharacter = key, true end
    end
    return moved
end
-- The list from before landed on the wrong character: move it here. Only
-- what this character does not have yet; nothing is merged or lost.
function A.MoveListHere(charKey)
    local all = Characters()
    local from = all and all[charKey]
    local mine = A.MyCharacter(true)
    if type(from) ~= "table" or type(from.people) ~= "table" or not mine or charKey == A.Me() then return 0 end
    local moved = 0
    for personKey, rel in pairs(from.people) do
        if not mine.people[personKey] then
            mine.people[personKey] = rel
            from.people[personKey] = nil
            moved = moved + 1
        end
    end
    if A.db.charactersFirst == charKey then A.db.charactersFirst = A.Me() end
    if A.Refresh then A.Refresh() end
    return moved
end
