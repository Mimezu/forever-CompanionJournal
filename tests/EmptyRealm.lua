-- Run from the client root: lua5.1 Interface/AddOns/CompanionJournal/tests/EmptyRealm.lua
-- The game gave an empty realm name (Forever, 2026-11-20): the journal opened an empty
-- "alberich" record beside the real "alberich-realm" one. Now the record holds the
-- character's unique first + last name (Forever gives the last name in the realm's place),
-- the last realm is kept, and the stray record is folded back.
local root = "Interface/AddOns/CompanionJournal/"
local assertions = 0
local function check(value, message) assertions = assertions + 1; assert(value, message) end

local function Stub() return setmetatable({}, {__index = function() return function() end end}) end
function CreateFrame() return Stub() end
UIParent = Stub()
function time() return 2000 end
local realm, last, class, race = "", "Noir", "PALADIN", "Scourge"
function GetNormalizedRealmName() return realm end
function GetRealmName() return realm end
function UnitName() return "Alberich" end
function UnitFullName() return "Alberich", last end
function UnitClass() return "Paladin", class end
function UnitRace() return "Undead", race end

local A
local function Load(db)
    A = {defaults = {colors = {}}, db = db}
    for _, file in ipairs({"People.lua", "Characters.lua"}) do
        assert(loadfile(root .. file))("CompanionJournal", A)
    end
end
local function Today()
    return {
        characters = {
            ["alberich-myrealm"] = {name = "Alberich", class = "PALADIN", race = "Scourge",
                people = {anna = "companion"}, firsts = {flight = 5},
                journal = {{t = 100, k = "play"}, {t = 200, k = "rest"}}},
            ["alberich-classicbetapve"] = {name = "Alberich", people = {}, journal = {{t = 50, k = "play"}}},
            alberich = {name = "Alberich", class = "PALADIN", race = "Scourge",
                people = {bob = "companion"}, firsts = {flight = 300, ["zone:X"] = 310},
                journal = {{t = 300, k = "play"}, {t = 310, k = "sleep"}}},
        },
        road = {alberich = {["d2"] = {"R:2"}}, ["alberich-myrealm"] = {["d1"] = {"R:1"}, ["d2"] = {"R:0"}}},
        bookRead = {["self:alberich"] = {}, ["self:alberich-myrealm"] = {}},
    }
end

-- Empty realm, none kept: the real record is found, stamped and gets the stray one back.
local db = Today()
Load(db)
check(A.Me() == "alberich-myrealm", "empty realm: the real record's key, got " .. tostring(A.Me()))
local c = db.characters
local mine = c["alberich-myrealm"]
check(mine.uniqueName == "alberich-noir", "the record holds the unique name")
check(db.homeRealm == "myrealm", "the realm is kept")
check(c.alberich == nil, "the stray record is gone")
check(#mine.journal == 4 and mine.journal[3].t == 300 and mine.journal[4].t == 310, "its entries follow, in time order")
check(mine.people.bob == "companion" and mine.people.anna == "companion", "people merged")
check(mine.firsts.flight == 5 and mine.firsts["zone:X"] == 310, "earlier firsts kept, new ones added")
check(db.road.alberich == nil and #db.road["alberich-myrealm"].d2 == 2 and db.road["alberich-myrealm"].d2[2] == "R:2", "road days merged")
check(db.bookRead["self:alberich"] == nil and db.bookRead["self:alberich-myrealm"], "stray read marks dropped")
check(A.PersonKey("Bob") == "bob-myrealm", "other people get the kept realm too")
realm = "Other Realm"
check(A.PersonKey("Bob") == "bob-otherrealm" and db.homeRealm == "Other Realm", "a realm from the game wins")

-- Next login, the realm reads anything at all: the unique name finds the record.
realm = "Something Else"
Load(db)
check(A.Me() == "alberich-myrealm", "found by the unique name whatever the realm")

-- Another Alberich (another last name, same realm): a record of his own, the first one untouched.
realm, last, class, race = "", "Smith", "WARRIOR", "Orc"
db.homeRealm = "myrealm"
Load(db)
check(A.Me() == "alberich-smith", "another Alberich: his own key, got " .. tostring(A.Me()))
local his = A.MyCharacter(true)
check(his.uniqueName == "alberich-smith" and his ~= mine and #mine.journal == 4, "his record is new, the first one untouched")

-- Another Alberich whose realm key is free of a unique name but holds another class: not taken.
local db2 = Today()
db2.characters.alberich = nil
db2.homeRealm = "myrealm"
Load(db2)
check(A.Me() == "alberich-smith" and db2.characters["alberich-myrealm"].uniqueName == nil, "a record of another class is not claimed")

print(assertions .. " checks passed")
