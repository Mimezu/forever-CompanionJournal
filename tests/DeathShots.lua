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

-- 1. The picture is asked only with the setting on and Frame Gambit there.
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
print("DeathShots: " .. checks .. " checks passed")
