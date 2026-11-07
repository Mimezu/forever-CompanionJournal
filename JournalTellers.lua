local _, A = ...
-- The storytellers: every character of yours has their own. The same journal
-- reads differently on each of your characters, and stays the same on each.
-- A storyteller is a voice (words and rhythm), never a gimmick: it changes how
-- a fact is said, never the facts, and never talks about the telling.
--   chronicler  formal: full names, "rejoined", "attained", "was slain"
--   bard        old heroic cadence: inversions, "deeds", "glory"
--   veteran     a soldier's short, full sentences: "fell in", "stood down"
--   wry         dry jokes that come from the facts, never at the reader
--   elder       grave and slow: "walked with", "took your life"
-- Each has lines of its own for the ordinary beats (travel, quests, levels,
-- the kills, deaths, rests) and for greetings and a won or lost day, mixed
-- with the common phrasebook: at most one of its own lines a chapter.
-- Keys match JournalTale's phrase keys; same tokens, same rules.
local P = {}
A.JournalTellers = P

-- Order matters: a character's storyteller is picked by position.
P.order = {"chronicler", "bard", "veteran", "wry", "elder"}
-- Keys where a storyteller's own lines are more likely.
P.strong = {daily = true, often = true, weekly = true, fortnightly = true, monthly = true, rare = true, early = true,
    pauseClose = true, pauseFar = true, closetriumph = true, closegrim = true, prelude = true, killRoll = true}

P.chronicler = {
    mix = 0.3, strong = 0.5, epithet = 0.2,
    meetGroup = {"On {weekday}, {name}, {aWho}, joined {my} party in {zoneE}.", "{name}, {aWho}, first joined {my} party in {zoneE}, on a {weekday}."},
    early = {"{name} rejoined {me} {later}."},
    daily = {"On {weekday} {name} rejoined {me}.", "On {weekday} {part}, {pair} resumed {our} travels.", "{name} was once again in {my} party on {weekday}."},
    often = {"{name} rejoined {me} on {weekday}.", "On {weekday}, {name} was in {my} party."},
    weekly = {"{name} rejoined {me} {later}, on {weekday}.", "A week having passed, {name} rejoined {me} on {weekday}."},
    fortnightly = {"After {gap}, {name} rejoined {me}."},
    monthly = {"{name} rejoined {me} after an absence of {gap}."},
    rare = {"{name} rejoined {me} after an absence of {gap}.", "It had been {gap} since {name} last travelled with {me}."},
    pauseClose = {"After an absence of {gap}, {name} returned."},
    travel = {"{pair} passed {length} in {zoneD}.", "The day's business took {pairObj} to {zoneD} for {length}."},
    travelWork = {"{pair} spent {length} at work in {zoneD}."},
    questsMany = {"{we} worked through a long list of quests that day."},
    questsFew = {"{we} saw a few quests through."},
    questOne = {"{we} completed {quest}."},
    theyLevel = {"{name} attained level {theirs}."},
    dungeonfair = {"{pair} entered {dungeonE}, {lore}."},
    killRoll = {"In order, {we} slew {roll}."},
    killLast = {"Last came {boss}, {bossE}. {bossFell}", "{boss}, {bossE}, was slain last."},
    revenge = {"{short}, who had defeated {us} before, was slain."},
    dieFALLING = {"{I} died in a fall."},
    dieFoe = {"{I} died in {place}, slain by {killer}."},
    firenew = {"{we} made camp in {place}."},
    inn = {"{we} took {our} rest at the inn at {place}."},
    dayGo = {"passed {length} {inZone}"},
    prelude = {"{pair} completed {pcount} quests around {zoneD}{extras}."},
}

P.bard = {
    mix = 0.3, strong = 0.5, epithet = 0.3,
    meetGroup = {"It began in {zoneE}, on the day {aWho} named {name} joined {my} party.", "In {zoneE} it began, the day {aWho} named {name} joined {my} party.",
        "{name}, {aWho}, first stood beside {me} in {zoneE}.", "In {zoneE} {I} first took {name}, {aWho}, into {my} company."},
    early = {"And {later}, {name} returned."},
    daily = {"Out {pair} went, that {weekday} {part}.", "Again {name} stood beside {me}.", "That {part}, as on most days, {name} was at {my} side."},
    often = {"{name} stood beside {me} that {part}, as {they} so often did.", "Again that {weekday}, out {pair} went."},
    weekly = {"A week passed, and {name} returned."},
    monthly = {"{gap} passed, and {name} returned."},
    rare = {"Long had {name} been away, {gap} in all, and yet {they} returned."},
    pauseClose = {"For {gap} {name} was gone from {my} side, and then {they} returned."},
    travel = {"Through {zoneD} {pair} went, {length} in all."},
    theyLevel = {"{name} rose to level {theirs}."},
    dungeonfair = {"{pair} went down into {dungeonE}, {lore}."},
    killRoll = {"Down went {roll}."},
    killLast = {"And at the last came {boss}, {bossE}. {bossFell}"},
    revenge = {"Once {short} had beaten {us}. This time {we} won."},
    dieFALLING = {"{I} fell, and it was a long way down."},
    dieFoe = {"{killer} laid {me} low in {place}."},
    firenew = {"By firelight in {place}, {we} rested."},
    inn = {"At the inn at {place}, {we} rested at last."},
    closetriumph = {"There was glory in that day.", "It was glory enough for one day."},
    closegrim = {"There was no glory in it."},
    day = {"And so {pair} {day}."},
    prelude = {"First {pair} worked through {pcount} quests around {zoneD}{extras}."},
}

P.veteran = {
    mix = 0.3, strong = 0.5, epithet = 0.1,
    meetGroup = {"Picked up {name}, {aWho}, in {zoneE}."},
    early = {"{name} reported back {later}."},
    daily = {"{name} fell in beside {me}.", "Moved out with {name} that {part}.", "{name} was in the party, which was good."},
    often = {"{name} reported in again that {part}."},
    weekly = {"{name} reported in {later}, on schedule."},
    monthly = {"{name} turned up after {gap}, still in one piece."},
    rare = {"{name} turned up after {gap}. Good to see {them}."},
    pauseClose = {"{name} was gone {gap}. Then {they} reported back in."},
    travel = {"Worked {zoneD} for {length}."},
    travelWork = {"Worked {zoneD} for {length}, {qcount} jobs done."},
    questsMany = {"Cleared {count} jobs."},
    questsFew = {"Handled {count} jobs."},
    questOne = {"Took care of {quest}."},
    killRoll = {"Took down {roll}."},
    killLast = {"{boss} came last, {bossE}. {bossFell}"},
    revenge = {"{short} beat {us} once. Not twice."},
    dieFALLING = {"{I} fell and died. Watch the edges."},
    dieDROWNING = {"{I} drowned. Mind the breath next time."},
    dieFoe = {"{killer} got {me} in {place}."},
    firenew = {"Made camp in {place}."},
    inn = {"Stood down at the inn at {place}."},
    closetriumph = {"It was clean work, mostly."},
    closegrim = {"Bad day. They happen."},
    day = {"{day}."},
    prelude = {"Cleared {pcount} jobs around {zoneD}{extras}."},
}

P.wry = {
    mix = 0.3, strong = 0.5, epithet = 0.2,
    meetGroup = {"In {zoneE}, {aWho} named {name} joined {my} party."},
    early = {"{name} came back {later}."},
    daily = {"{name} was in the party again, which surprised no one.", "{Weekday} came, and {name} with it.",
        "{name} was back at {my} side, as usual."},
    often = {"{name} turned up again, as {they} tended to."},
    weekly = {"A week on, {name} was back, right on schedule."},
    monthly = {"{name} was back after {gap}, as if {they} had never been away."},
    rare = {"After {gap}, there was {name} again."},
    travel = {"{pair} spent {length} in {zoneD} and saw a good deal of it."},
    questsMany = {"There was no shortage of people wanting help that day."},
    questsFew = {"{we} saw to a few errands, because someone always needed something fetched."},
    revenge = {"{short} had won the first round. {short} did not enjoy the second."},
    dieFALLING = {"{I} fell to {my} death. In {my} defence, it was a very convincing ledge.", "{I} discovered the ground. Hard."},
    dieDROWNING = {"{I} drowned. Swimming is harder than it looks."},
    dieShameful = {"{killer} killed {me} in {place}, at {my} level, and that is all anyone needs to know."},
    firenew = {"A campfire in {place}, and nothing caught fire that should not have."},
    inn = {"{pair} stopped at the inn at {place}. The beds, as ever, were a matter of opinion."},
    closetriumph = {"It was a good day's work."},
    closegrim = {"Well. That could have gone better."},
    prelude = {"{pair} warmed up with {pcount} quests around {zoneD}{extras}."},
}

P.elder = {
    mix = 0.3, strong = 0.5, epithet = 0.3,
    meetGroup = {"In {zoneE}, {aWho} named {name} first walked with {me}."},
    daily = {"That {part} {name} walked with {me}.", "Again {name} walked at {my} side, as on most days."},
    often = {"That {part}, {name} walked with {me} once more."},
    weekly = {"A week turned, and {name} came back to {my} side."},
    monthly = {"{gap} went by before {name} walked with {me} again."},
    pauseClose = {"For {gap} {name} was away. Then {they} came back."},
    travel = {"{pair} spent {length} together in {zoneD}."},
    nostalgic = {"{pair} walked {zoneD}, and nothing there could harm {us} now."},
    questsFew = {"{we} answered a few calls for help."},
    theyLevel = {"{name} grew to level {theirs}."},
    dungeonfair = {"{pair} came to {dungeonE}, {lore}."},
    killRoll = {"{we} put an end to {roll}."},
    revenge = {"{short} had beaten {us} once, and did not live to do it again."},
    dieFALLING = {"{I} fell, and the ground did the rest."},
    dieFoe = {"{killer} took {my} life in {place}."},
    firenew = {"{we} made a fire in {place} and rested by it."},
    dayGo = {"spent {length} together {inZone}"},
    prelude = {"{pair} answered {pcount} calls for help around {zoneD}{extras}."},
}

-- The one for a character: seeded by their name, so it stays theirs.
function P.For(player)
    local name = player and player.name or ""
    local h = 5381
    for i = 1, #name do h = (h * 33 + name:byte(i)) % 2147483647 end
    local key = P.order[h % #P.order + 1]
    return P[key], key
end

-- Recurring scenes give each voice something concrete to remember. These
-- variations recall a captured fire, without assigning nostalgia or dialogue
-- to either adventurer.
P.chronicler.sceneMemoryfire = {
    "During an earlier visit to {zoneD}, {memoryWhen}, {we} had shared a fire.",
    "{we} had made camp together in {zoneD} {memoryWhen}.",
}
P.bard.sceneMemoryfire = {
    "{memoryWhen}, there had been a fire in {zoneD}, and {we} had shared it.",
    "Before this visit came the fire {we} had shared in {zoneD}, {memoryWhen}.",
}
P.veteran.sceneMemoryfire = {
    "{we} had made camp in {zoneD} {memoryWhen}.",
    "{zoneD} was where {we} had shared a fire {memoryWhen}.",
}
P.wry.sceneMemoryfire = {
    "{we} had been here by a fire {memoryWhen}. This visit brought {us} back to {zoneD}.",
}
P.elder.sceneMemoryfire = {
    "{memoryWhen}, {we} had shared firelight in {zoneD}.",
    "There had been a fire together in {zoneD} {memoryWhen}, on an earlier day.",
}
-- Level alone cannot establish immunity or an adventurer's private feelings.
P.elder.nostalgic = {"{pair} travelled in {zoneD}, with more experience than its usual dangers called for."}
P.wry.early = {"{name} came back {later}."}
P.wry.meetGroup = {"{aWho} named {name} joined {my} party in {zoneE}."}
P.wry.revenge = {"{short} had won the earlier fight. This time {we} won."}
P.wry.firenew = {"{we} made a campfire in {place}."}
P.wry.inn = {"{pair} rested at the inn at {place}."}

-- No class crafts: who struck the blow is not recorded.
P.crafts = {}

-- Round 14 (the writer): the veteran, rewritten whole; every line has its subject.
if P.veteran then
local v = P.veteran
v.meetGroup = {"{I} fell in with {name}, {aWho}, in {zoneE}."}
v.early = {"{name} reported back {later}."}
v.daily = {"{name} fell in beside {me}.", "{I} moved out with {name} that {part}.", "{name} was in the party again."}
v.often = {"{name} reported in again that {part}."}
v.weekly = {"{name} reported in {later}, on schedule."}
v.monthly = {"{name} turned up after {gap}."}
v.rare = {"{name} turned up after {gap}."}
v.pauseClose = {"{name} was gone {gap}. Then {they} reported back in."}
v.travel = {"{pair} worked {zoneD} for {length}."}
v.travelWork = {"{pair} worked {zoneD} for {length}, one job after another."}
v.questsMany = {"{we} cleared a long list of jobs."}
v.questsFew = {"{we} handled a few jobs."}
v.questOne = {"{we} took care of {quest}."}
v.killRoll = {"{we} took down {roll}."}
v.killLast = {"{we} put down {boss}, {bossE}, last of all."}
v.revenge = {"{short} had beaten {us} once. Not twice."}
v.dieFoe = {"{killer} got {me} in {place}."}
v.firenew = {"{we} made camp in {place}."}
v.inn = {"{we} stood down at the inn at {place}."}
v.closetriumph = {"It was clean work, mostly.", "The job was done."}
v.closegrim = {"It was a bad day."}
v.prelude = {"{pair} cleared {pcount} jobs around {zoneD}{extras}."}
end
