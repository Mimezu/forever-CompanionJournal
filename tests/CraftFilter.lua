-- Run from the client root: lua5.1 Interface/AddOns/CompanionJournal/tests/CraftFilter.lua
-- Opening a profession window ("Smelting") and turning on a tracking spell ("Find Minerals")
-- are not things made: such a record tells nothing; a real recipe is still told.
local root = "Interface/AddOns/CompanionJournal/"
function time(t) if type(t) == "table" then return os.time(t) end return 1794031000 end
function date(fmt, t) return os.date(fmt, t) end
local A = {defaults = {colors = {}}}
for _, file in ipairs({"LoreData.lua", "Lore.lua", "JournalBook.lua"}) do assert(loadfile(root .. file))("CompanionJournal", A) end
local checks = 0
local function check(ok, why) checks = checks + 1; assert(ok, why) end
local T = 1794031000
local function Book(journal)
    local person = {self = true, name = "Reed", journal = journal}
    local crafts = {}
    for _, day in ipairs(A.JournalBook(person)) do
        for _, scene in ipairs(day.scenes or {}) do
            for trade, line in pairs(scene.craft or {}) do crafts[#crafts + 1] = {trade = trade, line = line} end
        end
    end
    return crafts
end
local play = {k = "play", t = T, e = T + 3600, z = "Tirisfal Glades", pl = 5}
local bad = Book({play, {k = "craft", t = T + 60, e = T + 62, z = "Tirisfal Glades", d = "Mining", c = 2, m = {"Smelting", "Find Minerals"}}})
check(#bad == 0, "opening Smelting and Find Minerals tell no craft")
local good = Book({play, {k = "craft", t = T + 60, e = T + 62, z = "Tirisfal Glades", d = "Mining", c = 3, m = {"Smelting", "Smelt Copper"}}})
check(#good == 1 and good[1].line.count == 2 and #good[1].line.made == 1 and good[1].line.made[1] == "Smelt Copper", "a real recipe keeps its count and name")
check(A.CraftNotMade["Find Herbs"] and A.CraftNotMade["Smelting"], "the list covers window and tracking spells")
print("CraftFilter: " .. checks .. " checks passed")
