-- Deaths remembered with a picture (DeathShots.lua): the clean screenshot asked at the
-- moment, the helper's thumbnail found by time, the chapter's link to the death's card.
local root = "Interface/AddOns/CompanionJournal/"
local checks = 0
local function check(ok, label) checks = checks + 1; assert(ok, label) end
local clock = 1794700000
function time() return clock end
date = os.date
local A = {defaults = {}, db = {}}
assert(loadfile(root .. "DeathShots.lua"))("CompanionJournal", A)

-- 1. The picture is asked only with the setting on, Frame Gambit and WoW Helper there.
WowHelperShots = {}
local shots = 0
check(A.DeathShot() == nil, "no Frame Gambit: no picture")
FrameGambit_CleanScreenshot = function() shots = shots + 1 end
A.db.deathShots = true
check(A.DeathShot() == clock and shots == 1, "with Frame Gambit: its clean screenshot, the request's time returned")
A.db.deathShots = false
check(A.DeathShot() == nil and shots == 1, "off: nothing taken")

-- 2. The helper's thumbnails: the nearest to the request within ten seconds.
WowHelperShots = {[clock - 30] = "old", [clock + 3] = "this", [clock + 8] = "later"}
check(A.ShotPath(clock) == "this", "the picture nearest the request")
check(A.ShotPath(clock + 100) == nil, "none near: no picture")
check(A.ShotPath(nil) == nil, "no request: no picture")

-- 3. Links: each death of the day links the first free mention of its killer, in order;
-- text in a name's markup or an existing link is left alone.
local day = {scenes = {{entries = {
    {k = "death", w = "you", d = "Vampiric Duskbat", t = 100},
    {k = "death", w = "you", d = "Vampiric Duskbat", t = 200},
    {k = "death", w = "them", d = "Kobold", t = 150},
}}}}
local text = "{n:Vampiric Duskbat} watched. A vampiric duskbat was the end of me; later a vampiric duskbat again."
local linked = A.DeathLinks(text, day)
local first = linked:find("|Hcjdeath:100|h", 1, true)
local second = linked:find("|Hcjdeath:200|h", 1, true)
check(first and second and first < second, "two deaths, two links, in order")
check(linked:find("{n:Vampiric Duskbat}", 1, true), "the name's markup is left alone")
check(not linked:find("cjdeath:150", 1, true), "a companion's death is not yours to link")
check(A.DeathLinks("Nothing to see.", day) == "Nothing to see.", "no mention: the text unchanged")
-- 4. Levels: a level with a picture links its "level N" (not "level 2" inside "level 21");
-- one without a picture links nothing.
local levels = {scenes = {{entries = {
    {k = "mylevel", d = 2, t = 300, shot = 300},
    {k = "mylevel", d = 3, t = 400},
}}}}
local told = A.DeathLinks("At level 21 once. Then I was level 2 again, and soon level 3.", levels)
check(told:find("|Hcjdeath:300|h|cff7d1c0alevel 2|r|h again", 1, true), "the level's own mention is linked")
check(not told:find("|Hcjdeath:300|h|cff7d1c0alevel 2|r|h1", 1, true), "level 21 is not level 2")
check(not told:find("cjdeath:400", 1, true), "no picture: no link")
-- Without WoW Helper (no list at all) the pictures leave no trace: no links, no screenshot.
local saved = WowHelperShots
WowHelperShots = nil
check(not A.DeathLinks("Then I was level 2 again.", levels):find("cjdeath", 1, true), "no helper: no level link")
check(not A.DeathLinks(text, day):find("cjdeath", 1, true), "no helper: no death link")
A.db.deathShots = true
check(A.MomentShot() == nil and shots == 1, "no helper: no screenshot taken")
WowHelperShots = saved
-- 5. The photo: a moment's picture by its time, from your journal.
A.SelfPerson = function() return {journal = {{k = "mylevel", d = 2, t = clock, shot = clock}}} end
WowHelperShots = {[clock + 1] = "level-two"}
check(A.MomentPicture(clock) == "level-two", "a level's picture by its time")
check(A.MomentPicture(clock + 500) == nil, "no moment then: no picture")
-- 6. The large copy for the card: the nearest within ten seconds, with the part it fills.
WowHelperShotsLarge = {[clock + 2] = {"big", 0.888671875, 1}, [clock + 40] = {"far", 1, 1}}
local big, u, v = A.ShotLarge(clock)
check(big == "big" and u == 0.888671875 and v == 1, "the large copy and its texcoords")
check(A.ShotLarge(clock + 100) == nil, "none near: no large copy")
WowHelperShotsLarge = {[clock] = "not a table"}
check(A.ShotLarge(clock) == nil, "a broken entry is no picture")
WowHelperShotsLarge = nil
check(A.ShotLarge(clock) == nil, "an older helper: no large copies")
print("DeathShots: " .. checks .. " checks passed")
