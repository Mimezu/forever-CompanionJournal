local _, A = ...
-- The storyteller's phrasebook (Story mode): every line the chapters are made
-- of, by moment. JournalTale.lua is the engine that picks them. Written to the
-- style guide of the writing review (StorageInvestigation/journal-voice/review/
-- CRITIQUE.md), in the voice of the vanilla quests:
--   * say what happened, in order, in full sentences; never what was not
--     recorded (who struck, what was said or felt, food, weather);
--   * never narrate the telling (no journal, tale, song, verse, record, page,
--     and no "road" unless there is one); no colon reveals, no aphorisms;
--   * one adjective per sentence at most; name a place once; romanticize
--     through consequence ("The Searing Blade had lost its master.").
-- Tokens: {name} {pair} (a subject: "you and Kael", then mostly "you") {I}
-- {me} {my} {we} {us} {our} ("you"/"your", or I/we in the diary voice)
-- {Iwas} {they} {them} {their} {was}; the day's {zoneE} {zoneD} {length}
-- {later} {gap} {part} {weekday} {qcount}; the moment's {quest} {dungeonE}
-- {lore} {boss} {short} {bossE} {bossFell} {roll} {killer} {place} {theirs}
-- {mine}... A line whose pool is empty drops its beat.
local T = A.JournalTale
local PB = T and T.phrases
if not PB then return end
PB.close, PB.stage, PB.dungeon, PB.kill, PB.rez, PB.fire = PB.close or {}, PB.stage or {}, PB.dungeon or {}, PB.kill or {}, PB.rez or {}, PB.fire or {}
PB.dieEnv, PB.rezClass, PB.title, PB.origin = PB.dieEnv or {}, PB.rezClass or {}, PB.title or {}, PB.origin or {}

---------------------------------------------------------------------------
-- 1. FIRST DAYS: meetings, origins, the bond
---------------------------------------------------------------------------

-- PB.meetGroup: the companion's introduction. Plain is right here: who, what, where.
PB.meetGroup = {
    "{I} met {name}, {aWho}, in {zoneE}.",
    "{name}, {aWho}, joined {my} party in {zoneE}.",
    "In {zoneE} a party formed, and {aWho} named {name} was in it.",
    "{I} first grouped with {name}, {aWho}, in {zoneE}.",
    "That {part}, in {zoneE}, {I} fell in with {aWho} named {name}.",
    "{I} fell in with {name}, {aWho}, in {zoneE}.",
    "It was in {zoneE} that {I} first went out with {name}, {aWho}.",
}

-- PB.meetFire
PB.meetFire = {
    "{I} met {name}, {aWho}, at a campfire in {zoneE}.",
    "It started at a campfire in {zoneE}, where {aWho} named {name} was sitting.",
    "A campfire in {zoneE} was where {I} met {name}, {aWho}.",
}

-- PB.meetAdded (the player wrote them in by hand: "journal" is literal here, once)
PB.meetAdded = {
    "{name}, {aWho}, went into the journal that day.",
    "{I} wrote down the name of {name}, {aWho}, that day.",
}

-- PB.meetAfterSeen
PB.meetAfterSeen = {
    "After seeing {name} about {count} times, {I} finally grouped with {them}.",
    "{name} had been a familiar face for {span}. That day {they} joined {my} party.",
    "For {span} {I} had only passed {name} by. That day {pair} grouped at last.",
}

-- PB.firstRoad (a meeting written on its own day, then the first outing)
PB.firstRoad = {
    "{later}, {pair} went out together for the first time.",
    "The first real outing with {name} came {later}.",
}

-- PB.origin: started together. The Scourge lines open the player's own book (Mira).
PB.origin = {
    Scourge = {
        "{pair} rose from the grave together in Deathknell and walked out into the grey light of Tirisfal.",
        "It began in Deathknell, where {pair} rose from the grave and took up arms side by side.",
        "{pair} woke in the crypts of Deathknell and went out into Tirisfal together.",
    },
    Human = {"{pair} set out together from Northshire Abbey.", "It began at Northshire Abbey, where {pair} took up arms side by side."},
    Dwarf = {"{pair} set out together from Coldridge Valley, into the snow.", "It began in Coldridge Valley, where {pair} took up arms side by side."},
    Gnome = {"{pair} set out together from Coldridge Valley, into the snow.", "It began in Coldridge Valley, where {pair} took up arms side by side."},
    NightElf = {"{pair} began together in Shadowglen, beneath the World Tree.", "It began in Shadowglen, where {pair} took up arms side by side."},
    Orc = {"{pair} began together in the Valley of Trials.", "It began in the Valley of Trials, where {pair} were tested side by side."},
    Troll = {"{pair} began together in the Valley of Trials.", "It began in the Valley of Trials, where {pair} were tested side by side."},
    Tauren = {"{pair} set out together from Camp Narache, on the plains of Mulgore.", "It began at Camp Narache, where {pair} first walked the plains of Mulgore."},
    Sky = {"{pair} set out together from Zephras Isle.", "It began on Zephras Isle, where {pair} first rode the winds together."},
    other = {"{pair} set out together from the very first day.", "{pair} started out together, on the first day of all."},
}

-- PB.bondLine (origin day only). Say the bond once, plainly. No "then and now", no "this book".
-- One line on purpose: it is said once per book, and the origin line already says "together".
PB.bondLine = {
    "{name} is {bondWord}.",
}

-- PB.bondOpen: the engine uses it for 30-45% of a bonded companion's openings. Too often:
-- a novelist does not re-announce "your wife" every chapter (see CRITIQUE 6.1). When it
-- is used, let the bond word sit inside an ordinary sentence.
PB.bondOpen = {
    "That {part} {I} set out with {bondWord}, {name}.",
    "{Bond} was with {me} that {part}.",
    "{pair} set out that {part}.",
    "{Bond} came along that {part}.",
    "{name}, {bondWord}, was there when the {part} began.",
}

---------------------------------------------------------------------------
-- 2. OPENING A DAY: the rhythm of meeting
-- Tell the rhythm when it changes (second day, a return, a streak, a long
-- absence). Otherwise open with the action. The engine should greet a daily
-- companion on one day in four, not three in five (CRITIQUE 6.1). These lines
-- are short on purpose, so they can sit in front of the day's first real line.
---------------------------------------------------------------------------

-- PB.second
PB.second = {
    "{name} came back {later}.",
    "{later}, {name} was in the party again.",
    "{later}, {pair} went out a second time.",
}

-- PB.early (days three to five)
PB.early = {
    "{name} joined {me} {later}.",
    "{later}, {pair} set out together.",
    "{name} was back {later}.",
    "{later}, {name} was in the party again.",
}

-- PB.daily (a companion met almost every day). 12 lines; with the greeting at 25% that is plenty.
PB.daily = {
    "{name} was with {me} that {part}.",
    "That {part} {pair} set out together.",
    "{name} fell in beside {me}, as {they} did most days now.",
    "{Weekday} {part}, and {name} was in the party as usual.",
    "{name} joined {me} that {weekday}.",
    "On {weekday}, as on most days, {pair} went out together.",
    "{name} came along that {part}, as usual.",
}

-- PB.often (several times a week)
PB.often = {
    "{name} joined {me} that {part}.",
    "{pair} were out on {weekday}.",
    "{Weekday} brought {name} back to the party.",
    "{name} was back in the party on {weekday}.",
    "{name} came along, as {they} did a few times a week.",
    "{pair} went out that {weekday} {part}.",
    "{name} turned up that {part}.",
    "That {part}, {name} was in the party once more.",
}

-- PB.oftenGap (every few days, gap of two or more)
PB.oftenGap = {
    "{later}, {name} was back.",
    "{name} came back {later}, as {they} usually did.",
    "{pair} went out together {later}.",
    "{name} turned up {later}, as {they} did every few days.",
}

-- PB.weekly
PB.weekly = {
    "{name} was back {later}.",
    "{name} joined {me} that {weekday} {part}.",
    "It was {weekday}, and {name} was in the party.",
    "{name} came along, as {they} did most weeks.",
    "{pair} were out together that {part}.",
    "{later}, {name} was in the party again.",
    "After {gap}, {name} joined {me}.",
}

-- PB.fortnightly
PB.fortnightly = {
    "{name} came back after {gap}, about as long as {they} usually stayed away.",
    "After {gap} apart, {pair} set out together.",
    "{name} was back {later}.",
    "It had been {gap}. That {part}, {name} joined {me}.",
    "{name} turned up after {gap}, as {they} did every couple of weeks.",
}

-- PB.monthly
PB.monthly = {
    "{name} came back after {gap}.",
    "It had been {gap} since {pair} last went out together.",
    "After {gap}, {name} was back in the party.",
    "{name} turned up after {gap}, as {they} did about once a month.",
    "{gap} had gone by. Then {name} was back.",
}

-- PB.rare
PB.rare = {
    "{name} came back after {gap}.",
    "It had been {gap} since {pair} last travelled together.",
    "{name} was in the party for the first time in {gap}.",
    "{name}, first met in {firstZone}, joined {me} again after {gap}.",
}

-- PB.pauseClose (a long silence from someone who used to be there all the time)
PB.pauseClose = {
    "For {gap} {name} did not join {me}. Then {they} came back.",
    "{gap} went by without {name}, a long time for someone who had been there {usual}.",
    "{name} had been gone {gap}. That {part} {they} {was} back in the party.",
    "After {gap} apart, {pair} set out together.",
    "After {gap}, {name} was back, and {our} travels together resumed.",
}

-- PB.pauseFar
PB.pauseFar = {
    "{name} came back after {gap}, longer than usual.",
    "It had been {gap}, longer than {name} usually stayed away.",
    "After {gap}, {name} was back in the party.",
}

-- PB.openPart (the hour you set out)
PB.openPart = {
    morning = {"{pair} set out in the morning.", "It was still morning when {name} joined {me}.", "{name} joined {me} that morning."},
    afternoon = {"{pair} set out after noon.", "It was past noon when {name} joined {me}.", "{name} joined {me} that afternoon."},
    evening = {"It was evening when {pair} set out.", "{name} joined {me} that evening.", "The light was going when {pair} set out."},
    night = {"It was late when {name} joined {me}.", "Night had fallen by the time {pair} set out.", "{pair} set out late that night."},
}

-- PB.openPlace (the day opens on the place; the land beat then stays quiet)
PB.openPlace = {
    "That {part} {pair} went out into {zoneE}.",
    "The day took {pairObj} to {zoneD}.",
    "{pair} headed into {zoneD} that {part}.",
}

-- PB.streak. Say it at 7, 14, 21 and 30 days, not at 3 and 5 (CRITIQUE 6.9).
PB.streak = {
    "That made {count} days in a row.",
    "It was the {nth} day running.",
}

---------------------------------------------------------------------------
-- 3. WHERE YOU STAND (levels)
---------------------------------------------------------------------------

-- PB.stage.*: DROP THE BEAT. "Two tested blades.", "Blooded now, the two of you.",
-- "Heroes, by any measure, whose names were starting to travel ahead of them.", "Young
-- blades, both of you." are verbless labels for a level the player can already see.
PB.stage.fledgling, PB.stage.young, PB.stage.blooded, PB.stage.seasoned = {}, {}, {}, {}
PB.stage.veteran, PB.stage.hero, PB.stage.legend = {}, {}, {}

-- PB.mentor / PB.protege / PB.caughtUp: keep; these carry information.
PB.mentor = {
    "{Iwas} level {mine}, {name} only {theirs}.",
    "{Iwas} level {mine} then, while {name} was level {theirs}.",
    "{name} was level {theirs}, a long way behind {me} at {mine}.",
}
PB.protege = {
    "{name} was level {theirs}, well ahead of {me} at {mine}.",
    "{name} was level {theirs} then, while {Iwas} level {mine}.",
}
PB.caughtUp = {
    "{name} had caught up with {me} at level {theirs}.",
    "{pair} were the same level now, {theirs}.",
}

---------------------------------------------------------------------------
-- 4. THE LAND
-- Most lines use the plain name {zoneD}. {zoneE} (the epithet) is in a few.
-- Set persona.epithet to 0.2 (below) so an epithet shows about one day in five.
---------------------------------------------------------------------------

-- PB.travel (high traffic)
PB.travel = {
    "{pair} spent {length} in {zoneD}.",
    "{pair} were out in {zoneD} for {length}.",
    "{Length} went by in {zoneE}.",
    "{pair} spent {length} together in {zoneE}.",
    "{zoneD} took up {length} of the day.",
    "{pair} were together in {zoneD} for {length}.",
    "{pair} were in {zoneE} for {length}.",
}

-- PB.travelWork (the place and the quests in one sentence: the default when both exist)
PB.travelWork = {
    "{pair} spent {length} in {zoneD} and finished {qcount} quests.",
    "In {zoneD}, {pair} turned in {qcount} quests in {length}.",
    "The work that day was in {zoneD}, {qcount} quests in {length}.",
    "{Length} in {zoneE} brought {pairObj} {qcount} quests.",
    "{Qcount} quests were finished during {our} {length} in {zoneD}.",
    "{pair} were in {zoneD} for {length} and finished {qcount} quests there.",
}

-- The quiet day in one flowing sentence. The engine builds {day} from verb
-- phrases in this order: where and how long (PB.dayGo, or PB.dayGoHere once a
-- land line named the place), the quests (PB.dayWork: by name when one or two,
-- a hard or group quest named with its reason), the fire or inn (PB.dayRest),
-- joined as "A and B" or "A, B, and C". {inZone} is "in Silverpine Forest" or,
-- two quiet days in five, the zone's own clause ("in Silverpine Forest, where
-- the worgen howl"). A first fire or inn is folded in, then gets its own note.
-- All subjects are plural: the assembled {day} can start with "were".
-- (Engine: a named lead only while the companion is unnamed in the chapter; "On {weekday} ..."
-- only as the chapter's first sentence; a {part} line is skipped when "that evening" was already said.)
PB.day = {
    "{pair} {day}.",
    "That {part} {pair} {day}.",
    "{pairNamed} {day}.",
    "On {weekday} {pair} {day}.",
    "{pair} {day}.",
}
PB.dayGo = {
    "spent {length} {inZone}",
    "were {inZone} for {length}",
    "spent {length} together {inZone}",
    "were out for {length} {inZone}",
}
-- the same, once the place was named this chapter (a land line said it).
-- Verbs that stand without a place; "there" in one line only ("for over an hour there" was
-- the new tic, 8.8 per 1,000 words, before this split).
PB.dayGoHere = {
    "stayed {length}",
    "were out for {length}",
    "spent {length} together",
    "were together for {length}",
    "spent {length} there",
}
-- A day of no quests, no fights: sightseeing, herbs, a sunset (your own journal says so).
PB.dayGoQuiet = {
    "spent {length} {inZone}",
    "were together {inZone} for {length}",
    "spent {length} together {inZone}",
}
PB.dayGoMany = {
    "went from {from} to {to}, {length} all told",
    "made {our} way from {from} to {to}",
}
PB.dayWork = {
    one = {"turned in {quest}", "finished {quest}"},
    two = {"turned in {quest} and {questB}", "finished {quest} and {questB}"},
    few = {"turned in {count} quests", "finished {count} quests", "saw {count} quests through"},
    many = {"worked through {count} quests", "turned in {count} quests"},
    -- A hard or group quest is the day's work, named, and the chapter's title (engine R2-1b).
    hard = {"finished {quest}, which was above {our} level", "turned in {quest}, work meant for more seasoned adventurers"},
    elite = {"finished {quest}, work meant for a full party", "turned in {quest}, a job for a whole party"},
}
PB.dayRest = {
    fire = {"made camp{inPlace}", "stopped for a fire{inPlace}", "sat by a fire{inPlace} a while"},
    inn = {"rested at the inn at {place}", "stopped at the inn at {place}"},
}
-- The short sentence after a first fire or inn. "Ahead" only when 3+ fires follow
-- (the engine knows the whole book; hindsight is said only when true).
-- (Only one line in each opens on "It": "It was ..." had become 11% of all sentence openings.
-- The note follows a sentence that opens on "You"/"We", so the opening guard steers it away
-- from "{we} ..." lines: each pool needs a third opening, "That was ...".)
PB.fireFirstNote = {"{we} had never shared a fire before.", "It was the first fire {we} had shared.", "That was {our} first campfire together."}
-- (PB.fireFirstAhead and PB.closeForeshadow.later were hindsight, "far from the last", "It would not be the
-- last time you went out together": removed 2026-11-06. A first fire gets its note; a chapter ends on its day.)
PB.innFirstNote = {"{we} had not rested under one roof before.", "That was the first inn {we} had shared.", "It was the first inn {we} had stopped at together."}

-- PB.travelMany
PB.travelMany = {
    "{pair} went from {from} to {to}, {length} in all.",
    "The day started in {from} and ended in {to}.",
    "From {from}, {pair} went on to {to}, {length} all told.",
}

-- PB.travelLong (three hours and more)
PB.travelLong = {
    "It was a long day, {length} from start to finish.",
    "{pair} were out for {length}.",
    "The day ran to {length}.",
    "{pair} put in {length} that day.",
    "{Length} went by before {pair} stopped.",
    "It was {length} before {pair} called it a day.",
}

-- PB.home / homeNostalgic / homeBoth / theirHome
PB.home = {
    "{pair} were on {my} home ground, {zoneD}.",
    "{zoneD} was the homeland of {my} people.",
}
PB.homeNostalgic = {
    "{pair} were in {zoneD}, the homeland of {my} people, above its usual dangers now.",
    "{zoneD} was the homeland of {my} people, and {pair} had outgrown its dangers.",
}
PB.homeBoth = {
    "{zoneD} was home to both of {us}.",
    "{pair} were on home ground in {zoneD}, where both of {us} had begun.",
}
PB.theirHome = {
    "{zoneD} was {name}'s home ground.",
    "{pair} were in {zoneD}, {name}'s homeland.",
}

-- PB.nostalgic (far above the zone's level)
PB.nostalgic = {
    "{pair} travelled through {zoneD}, with more experience than its usual dangers called for.",
    "{pair} had outgrown {zoneD}.",
    "{zoneD} was country for younger adventurers than {us}.",
    "{zoneD} held little danger for {us} any more.",
}

-- PB.perilous (below the zone's level)
PB.perilous = {
    "{pair} entered {zoneE}, country for more seasoned adventurers.",
    "{zoneD} was a few levels above {us}, and {pair} went in anyway.",
    "{pair} were in {zoneD} early, with its dangers still above {us}.",
    "{zoneD} was hard country at {our} level.",
}

-- PB.explore (first time in the zone together)
PB.explore = {
    "{pair} went into {zoneE} together.",
    "The day's travels brought {pairObj} to {zoneD}.",
    "{pair} had not been in {zoneD} together before.",
}

-- PB.zoneReturn (back after months)
PB.zoneReturn = {
    "{pair} came back to {zoneD} after a long time away.",
    "{pair} were back in {zoneD}.",
}


-- PB.whereItBegan / whereStarted
PB.whereItBegan = {
    "{pair} were back in {zoneD}, where {we} had first met.",
    "{pair} were back in {zoneD}, {since} after meeting there.",
}
PB.whereStarted = {
    "{pair} were back in {zoneD}, where {we} had started out.",
    "The day led back to {zoneD}, where it had all started.",
}

-- PB.city / PB.cityRest
PB.city = {
    "{pair} passed through {zoneD}.",
    "{pair} spent some time in {zoneD}.",
    "{pair} stopped in {zoneD} for a while.",
}
PB.cityRest = {
    "{pair} rested in {place}.",
    "{pair} took a rest in {place}.",
    "{pair} rested for a while in {place}.",
}

---------------------------------------------------------------------------
-- 5. THE WORK (quests)
-- Say "finished" or "turned in": the journal records turn-ins, so it is exact.
-- Never "X: done." Never "seen through" more than once in a book.
---------------------------------------------------------------------------

-- PB.questsMany (six and more)
PB.questsMany = {
    "{we} finished {count} quests.",
    "{Count} quests were turned in before the day was out.",
    "{Count} quests were among the day's finished work.",
    "{we} worked through {count} quests, one after another.",
    "By the end of the day {we} had turned in {count} quests.",
    "{Count} quests were finished that day.",
    "{we} turned in {count} quests in all.",
    "All told, {count} quests were done.",
}

-- PB.questsFew (two to five)
PB.questsFew = {
    "{we} turned in {count} quests as well.",
    "There were {count} quests to hand in as well.",
    "{Count} quests were turned in besides.",
    "{we} finished {count} quests along the way.",
    "{we} also saw {count} quests through.",
}

-- PB.questOne
PB.questOne = {
    "{we} also finished {quest}.",
    "{we} turned in {quest} as well.",
    "{we} finished {quest} besides.",
}

-- PB.questHard
PB.questHard = {
    "{we} finished {quest}, work usually left to more seasoned adventurers.",
    "{quest} called for more experience than {we} had, but it was finished.",
    "The work on {quest} called for a seasoned hand, and {we} saw it through.",
}

-- PB.questElite
PB.questElite = {
    "{quest} was work for a full party, and {we} finished it.",
    "{we} finished {quest}, a job for a whole party.",
    "{quest} called for a full party, and {we} saw it through.",
}

-- PB.questEasy
PB.questEasy = {
    "The day's errands called for less experience than {we} had gained.",
    "{we} completed work usually left to less seasoned adventurers.",
}

-- PB.prelude (three or more quests before the first dungeon)
PB.prelude = {
    "{pair} turned in {pcount} quests around {zoneD}{extras}.",
    "{pair} started the {part} with {pcount} quests around {zoneD}{extras}.",
    "The {part} began around {zoneD}, where {pair} turned in {pcount} quests{extras}.",
    "First {pair} turned in {pcount} quests around {zoneD}{extras}.",
}
-- A long day's quests, named: two of them, or the one done again and again.
PB.preludeNamed = {"Among them were {questA} and {questB}.", "{questA} and {questB} were among them."}
PB.preludeRepeat = {"{questA} took {us} back {times}.", "{questA} alone took {us} back {times}."}
-- On to the dungeon's zone, when it is not where the day's work was ({zoneTo}).
PB.routeOn = {"Later {pair} made {our} way to {zoneTo}.", "From there {pair} went on to {zoneTo}.", "Then {pair} crossed to {zoneTo}."}
-- The detour on the way ({via}: the zones crossed, in order).
PB.routeVia = {"Later {pair} went through {via}, and on to {zoneTo}.", "From there {pair} passed through {via} on the way to {zoneTo}.",
    "The way to {zoneTo} took {us} through {via}."}
-- The one quest turned in after the dungeon ({quest}; {zoneTo} where).
PB.questAfterOne = {"Afterwards, {we} turned in {quest}.", "Then {we} turned in {quest}."}
-- PB.questsMore. Truth: the engine counts quests after the FIRST dungeon but says it after
-- the LAST one (Mira: "nine more quests after that" were done before Ragefire). CRITIQUE 6.4.
PB.questsMore = {
    "{we} finished {count} more quests afterwards.",
    "There were {count} more quests after that.",
}

---------------------------------------------------------------------------
-- 6. DUNGEONS
-- One description at most: the epithet OR the lore clause, not both. The
-- engine picks a dungeon epithet 70% of the time; make it 25% (CRITIQUE 6.5).
---------------------------------------------------------------------------

-- PB.dungeon.fair (high traffic)
PB.dungeon.fair = {
    "{pair} went down into {dungeonE}, {lore}.",
    "That {part} {pair} went into {dungeonE}.",
    "Then {pair} went down into {dungeonE}.",
    "{pair} took on {dungeonE}, {lore}.",
    "{pair} made for {dungeonE}, {lore}.",
    "{pair} went into {dungeonE}.",
    "{pair} entered {dungeonE}, {lore}.",
    "That {part} {pair} headed down into {dungeonE}.",
    "Before long {pair} were in {dungeonE}, {lore}.",
}

-- PB.dungeon.daring
PB.dungeon.daring = {
    "{pair} entered {dungeonE}, {lore}. Its dangers called for more experienced adventurers.",
    "{dungeonE} {dungeonWas} a hard venture for {us}. {pair} went inside.",
    "{pair} went into {dungeonE}, a place meant for stronger adventurers.",
    "{dungeonE} {dungeonWas} a few levels above {us}, and {pair} went in anyway.",
    "{pair} went into {dungeonE}, {lore}, with its dangers still above {us}.",
}

-- PB.dungeon.reckless
PB.dungeon.reckless = {
    "{dungeonE} {dungeonWas} meant for adventurers far stronger than {us}. {pair} went in anyway.",
    "The dangers inside {dungeonE} far outmatched {our} experience.",
    "{pair} entered {dungeonE}, {lore}, before {our} strength matched its dangers.",
    "{dungeonE} {dungeonWas} well above {our} level, and {pair} went in all the same.",
}

-- PB.dungeon.easy (four near-duplicates of "made short work of")
PB.dungeon.easy = {
    "{dungeonE} gave {us} little trouble.",
    "{pair} went through {dungeonE} without much trouble.",
    "{dungeonE} {dungeonWas} well within {our} reach.",
}

-- PB.dungeon.revisit (ten levels and more above it)
PB.dungeon.revisit = {
    "{dungeonE} held nothing that could threaten {us} anymore.",
    "{pair} walked through {dungeonE}, which had once been dangerous.",
    "{pair} walked through {dungeonE} like it owed {us} money.",
}

-- PB.dungeonAgain / PB.dungeonRegular
PB.dungeonAgain = {
    "{pair} went back to {dungeonE}.",
    "{pair} went into {dungeonE} for the {nth} time.",
    "{pair} returned to {dungeonE}, a place {we} had seen before.",
    "{pair} knew {dungeonE} from an earlier visit.",
}
PB.dungeonRegular = {
    "{pair} were in {dungeonE} for the {nth} time.",
    "{pair} were back in {dungeonE}. By now {we} knew the way.",
}

-- PB.dungeonFirst
PB.dungeonFirst = {
    "It was {our} first dungeon together.",
    "{we} had never been in a dungeon together before.",
    "Neither of {us} had gone into a dungeon with the other before.",
}

-- PB.dungeonLater (a second dungeon the same day)
PB.dungeonLater = {
    "Later that {part}, {we} went down into {dungeonE}.",
    "Later that {part} came {dungeonE}.",
    "After that, {we} headed into {dungeonE}.",
    "{dungeonE} came later that {part}.",
    "Before the {part} was out, {we} were in {dungeonE}.",
}

-- PB.dungeonClock, for a later dungeon entered near or after midnight.
-- {clock} = "near midnight" (23:00-23:59) or "after midnight" (00:00-03:59). The engine
-- prefers it over PB.dungeonLater when the clock is known, and then the hour beat
-- ("It was past midnight when you stopped") stays quiet.
PB.dungeonClock = {
    "It was {clock} when {we} went down into {dungeonE}.",
    "{clock}, {we} went down into {dungeonE}.",
    "{dungeonE} came {clock}.",
}

-- PB.dungeonGrief
PB.dungeonGrief = {
    you = {
        "{pair} went back into {dungeonE}, where {I} had died the time before.",
        "{pair} were back in {dungeonE}, where {I} had fallen the last time.",
    },
    them = {
        "{pair} went back into {dungeonE}, where {they} had died the time before.",
        "{name} had died in {dungeonE} the last time. {pair} went back in.",
    },
}

-- PB.dungeonBrief. A dungeon with no bosses, deaths or lost fights
-- (Mira's two-minute Shadowfang Keep) should get this, never daring/reckless rhetoric.
-- PB.dungeonFled. The same empty visit, above your level, and the next thing
-- recorded was outside it within minutes: {above} "far above" or "above",
-- {quick} "within a minute" or "a few minutes later". Only what was recorded.
PB.dungeonFled = {
    "{pair} looked into {dungeonE}, with dangers {above} {our} experience, and were back out {quick}.",
    "The demands of {dungeonE} were {above} {our} experience. {pair} went in, and came back out {quick}.",
    "{pair} tried {dungeonE}, a place {above} {our} experience, and were outside again {quick}.",
}
PB.dungeonBrief = {
    "There was a short visit to {dungeonE} as well.",
    "{pair} looked in at {dungeonE}, too.",
}
---------------------------------------------------------------------------
-- The same dungeon again (2026-11-06): each run told by its place in the
-- book's history of it. Tokens: {dungeonE} {lord} {short} (the lord of the
-- place, from Lore, and its short name), {lastKill} (the last boss killed this
-- run), {nth}. Facts only: never why anyone left.
---------------------------------------------------------------------------
PB.dungeonReturnUnfinished = {
    "The last run there had stopped short of {lord}.",
    "The time before, {we} had come out with {lord} unbeaten.",
    "{lord} had been left standing the time before.",
    "The first run had not gone as deep as {lord}.",
}
PB.lordAtLast = {
    "This time the run reached {short}.",
    "What the earlier run had left standing, this one finished.",
    "{short} did not outlast the second visit.",
    "The place had kept {short} from {us} once, and did not again.",
}
PB.dungeonKnown = {
    "{pair} went into {dungeonE} for the {nth} time.",
    "It was {our} {nth} run through {dungeonE}.",
    "By the {nth} run, {dungeonE} {dungeonWas} familiar ground to {pairObj}.",
    "{pair} went down into {dungeonE} again, the {nth} time.",
}
PB.dungeonUnfinished = {
    left = {
        "{lord} was still down there when {pair} came back out.",
        "{we} came back out with {lord} unbeaten.",
        "{lastKill} was as far as {pair} got, and {we} came out again.",
        "Past {lastKill}, {we} went no further, and left {lord} where {lordThey} stood.",
    },
    ended = {
        "{we} did not go as deep as {lord} that time.",
        "The run ended before {lord}.",
        "{lastKill} was as far as {pair} got.",
        "Past {lastKill}, {we} went no further that day.",
    },
}
PB.dungeonShortVeteran = {
    "{pair} had been to the bottom of {dungeonE} before. This time the run ended at {lastKill}.",
    "It was the first time {pair} had left {dungeonE} without {short}'s fall.",
    "{we} had reached {lord} in {dungeonE} before, and this time {we} stopped at {lastKill}.",
    "For once {dungeonE} kept {short} from {us}.",
}
PB.dungeonFellShort = {
    "{short} beat {us}, and the run ended there.",
    "{short} stopped {us}, and {we} went no further.",
    "{short} held the end of {dungeonE} against {us}.",
    "{short} was the end of the run, and {we} were the ones beaten.",
}
PB.title.unfinished = {"Short of the Bottom", "Not All the Way", "Half Done"}
PB.title.fellShort = {"Beaten at the Last", "The Last Door", "Stopped Short"}

---------------------------------------------------------------------------
-- 7. BOSSES
-- Active voice is allowed and is the vanilla way: completion texts tell the
-- player plainly that they killed the foe. Kill lines use {we} ("you" / "we"), never {pair}.
---------------------------------------------------------------------------

-- PB.kill.<kind> (also used as {bossFell})
PB.kill.undead = {"{we} put {short} back in the grave.", "{short} died a second time.", "{short} was laid to rest, for good this time.", "{short} was destroyed."}
PB.kill.demon = {"{short} died, and went back to the Nether.", "{we} sent {short} back to the Nether.", "{short} was slain and sent back to the Nether."}
PB.kill.beast = {"{we} brought {short} down.", "{short} was put down.", "{short} was hunted down."}
PB.kill.dragon = {"{short} was slain.", "{we} slew {short}.", "{short} died, dragon or not."}
PB.kill.elemental = {"{short} was broken apart.", "{short} was unmade.", "{we} broke {short} apart."}
PB.kill.giant = {"{short} came down hard.", "{we} brought {short} down."}
PB.kill.construct = {"{short} was smashed to scrap.", "{we} took {short} apart.", "{short} was broken for good."}
PB.kill.aberration = {"{short} was destroyed.", "{we} destroyed {short}.", "{short} was unmade."}
PB.kill.humanoid = {"{we} killed {short}.", "{short} was cut down.", "{short} fought, and lost.", "{short} was slain.", "{short} died there.", "{short} was defeated."}

-- PB.killOne (one earlier boss)
PB.killOne = {"{we} killed {boss}.", "{boss} went down.", "{boss} barred the way, briefly.", "{boss} fell.", "{we} dealt with {boss}."}

-- PB.killTwo
PB.killTwo = {"{we} killed {bosses}.", "{bosses} both fell.", "{bosses} fell, one after the other.", "{bosses} were dealt with in turn."}

-- PB.killMany
PB.killMany = {"{we} killed {bosses}.", "{bosses} all fell.", "One after another, {bosses} went down.", "On the way through, {we} killed {bosses}."}

-- PB.killLast (the lord of the place, after others)
PB.killLast = {
    "Last of all, {we} killed {boss}, {bossE}.",
    "The last of them, {boss}, {bossE}, fell too.",
    "Deepest in, {we} killed {boss}, {bossE}.",
    "{we} killed {boss}, {bossE}, last of all.",
}

-- PB.killLastOnly (the lord, with no other kills that day)
PB.killLastOnly = {
    "It came down to {boss}, {bossE}, and {shortRaw} fell.",
    "{boss}, {bossE}, was waiting, and {shortRaw} fell.",
    "{we} killed {boss}, {bossE}.",
    "Inside waited {boss}, {bossE}. {bossFell}",
}

-- PB.killNamed (a named boss that is not the last)
PB.killNamed = {
    "{we} killed {boss}, {bossE}.",
    "{boss} was there too, {bossE}. {bossFell}",
    "{boss}, {bossE}, stood in the way. {bossFell}",
}

-- PB.killRoll. A clean run (no deaths, no lost fights) with three or more
-- kills told in ONE sentence, in order, the lord with its epithet on the first kill only:
-- {roll} = "Oggleflint, then Taragaman the Hungerer, the felguard who led the Searing Blade,
-- and after that Jergosh the Invoker and Bazzalan". This is where the 20-word sentences come from.
PB.killRoll = {
    "{we} killed {roll}.",
    "Inside, {we} killed {roll}.",
}

-- PB.killCostly
PB.killCostly = {"{short} died all the same.", "{short} still went down, in the end.", "{short} did not live out the fight."}

-- PB.killCraft: DROP. "Taragaman met Mira's curses and your hammer" says who did what in
-- the fight, which the journal does not know. Also empty P.crafts below.
PB.killCraft = {}

-- PB.killAgain
PB.killAgain = {"{we} killed {boss} again.", "{boss} fell to {us} once more."}

-- PB.revenge
PB.revenge = {"{short} had beaten {us} before. Not this time.", "This time {short} stayed down.", "{we} came back for {short}, and this time {we} won."}

-- PB.wipe / PB.wipeThenWin
PB.wipe = {"{boss} beat {us} that time.", "The fight with {boss} was lost.", "{short} won that fight.", "{boss} was too much for {us}, that time."}
PB.wipeThenWin = {
    "{boss} won the first fight, and lost the second.",
    "{boss} beat {us} once, and fell the second time.",
    "The first fight with {boss} went against {us}, and the second did not.",
}

-- PB.aftermath: shrink to one generic line and give the lords their own consequence
-- (L.bosses[...].after below, NEW engine hook). CRITIQUE 6.6.
PB.aftermath = {"{dungeonD} would be quieter for a while."}

---------------------------------------------------------------------------
-- 8. DEATHS AND RESCUES
-- State the death plainly. Comment only on silly deaths, and dryly.
---------------------------------------------------------------------------

-- PB.dieHeroic (killed by the lord of the place)
PB.dieHeroic = {"{killer} killed {me}.", "{I} fell to {killer}.", "{I} died fighting {killer}.", "{I} died fighting {killer}, like many before {me}."}

-- PB.dieBoss
PB.dieBoss = {"{killer} cut {me} down.", "{I} fell before {killer}.", "{killer} was too much for {me}.", "{killer} killed {me}."}

-- PB.dieBossAvenged
PB.dieBossAvenged = {"{killer} killed {me}, but it did not save {killerShort}.", "{killer} killed {me}, but did not live out the day."}

-- PB.dieFoe (outside dungeons)
PB.dieFoe = {"{killer} killed {me} in {place}.", "{Iwas} killed by {killer} in {place}.", "{killer} got the better of {me}.", "{I} fell to {killer}."}

-- PB.dieShameful (killed far below your level: the one place for a joke)
PB.dieShameful = {
    "{killer} killed {me}. At {my} level, that takes some doing.",
    "{killer} killed {me} in {place}. The less said about that, the better.",
    "Of all things, it was {killer} that killed {me}.",
    "{I} died to {killer}, at {my} level.",
}

-- PB.dieEnv
PB.dieEnv.FALLING = {"{I} fell to {my} death.", "A fall killed {me}.", "{I} misjudged a drop and died.", "{I} fell to {my} death. The drop was further than it looked.",
    "{I} took the short way down, and died of it."}
PB.dieEnv.DROWNING = {"{I} drowned.", "{I} drowned in {place}.", "{I} stayed under too long and drowned.", "{I} drowned. The water had looked harmless."}
-- Named foes everyone has a story about, after they kill you ({I}, {me}).
PB.infamous = {
    ["Hogger"] = {"Half of Elwynn had tangled with him at one time or another, and now {I} had too."},
    ["Stitches"] = {"He came down the road into Darkshire, and {I} had been in his way."},
    ["Mor'Ladim"] = {"He still walked the graveyard on Raven Hill, as the people of Darkshire said."},
    -- ("{I} was no luckier" would read "you was" in the "you" voice.)
    ["Bhag'thera"] = {"She had long eluded Nesingwary's whole party."},
    ["Old Murk-Eye"] = {"He was older and meaner than any other murloc on that coast."},
    ["King Bangalash"] = {"He had sent Nesingwary himself back to camp more than once."},
    ["Sin'Dall"] = {"Nesingwary's camp had tracked her for weeks."},
    ["Sharptalon"] = {"It had preyed on the peons of Splintertree for a long time."},
    ["Tethis"] = {"Even Nesingwary had failed to kill it."},
    ["Mazzranache"] = {"It had been killing on the plains of Mulgore, and the tauren wanted it dead."},
    ["Gath'Ilzogg"] = {"Lakeshire had a price on his head, and {I} understood why."},
}
-- Killed by one of the other side ({killer}: "a human warrior"), and again.
PB.diePvp = {"{killer} of the other side killed {me}.", "{I} died to {killer} of the other side.", "{killer} of the other side caught {me} and cut {me} down."}
-- Three or more deaths to the other side in one day: the count ({count}: "three").
PB.diePvpMany = {"In all, the other side killed {me} {count} times that day.", "The other side kept coming back, and {I} died {count} times before it was over."}
PB.diePvpAgain = {"When {I} came back for {my} body, they were waiting, and {I} died again.", "{I} died to them again, not long after."}
-- A death the record knows nothing about.
PB.diePlain = {"{I} died.", "{I} did not survive it."}
-- The guards of a town ({place}).
PB.dieGuard = {"The guards of {place} cut {me} down.", "{I} went too near the guards of {place}, and they made short work of {me}."}
-- Someone else of your party that day, from your own journal ({others}: "Tarok, a tauren warrior").
PB.alsoThere = {
    "{others} came along too.",
    "{others} went with {pairObj}.",
    "{others} made one more in the party.",
    "{others} was along as well.",
    "{others} was there too.",
    "{others} joined {pairObj} for the day.",
    "{others} made a third.",
    "With {pairObj} went {others}.",
}
PB.alsoTherePlural = {
    "{others} came along too.",
    "{others} went with {pairObj}.",
    "{others} were in the party as well.",
    "{others} were there too.",
    "{others} filled out the party.",
    "With {pairObj} went {others}.",
}
-- The first of the other side you ever saw, while together ({aFoe}: "an orc shaman", {side}).
PB.sharedFoeSeen = {
    "{I} saw one of the {side} for the first time that day, {aFoe}.",
    "That was the day {I} first saw one of the {side}, {aFoe}.",
}
-- The first one you ever brought back from death, while together ({name}, {I}).
PB.sharedRezOther = {
    "{I} brought {them} back from death, the first {I} had ever raised.",
    "{I} raised {them}, the first {I} had ever brought back from death.",
}
-- The same end a second time in one day.
PB.dieEnvAgain = {
    FALLING = {
        "{I} fell to {my} death a second time that day.",
        "Later {I} fell to {my} death again.",
        "Later that day {I} made the same mistake and fell again.",
        "The ground got {me} a second time before the day was out.",
    },
    DROWNING = {
        "Later {I} drowned again.",
        "The water took {me} a second time.",
        "{I} drowned a second time before the day was out.",
    },
}
PB.dieEnv.FATIGUE = {"{I} swam too far out and died of exhaustion.", "Fatigue killed {me} far from shore."}
PB.dieEnv.LAVA = {"{I} died in the lava.", "The lava was exactly as dangerous as it looked."}
PB.dieEnv.FIRE = {"Fire killed {me}.", "{I} burned to death."}
PB.dieEnv.SLIME = {"{I} died in the slime.", "Slime killed {me}. There are better deaths."}

-- PB.theyDie / PB.theyDieBoss
PB.theyDie = {"{name} died in {place}.", "{name} was killed in {place}.", "{name} died there."}
-- (the same companion, twice or more in a day, no boss to blame: {count})
PB.theyDieTimes = {"{name} died {count} that day.", "{name} died {count} in {place}.", "{count} that day, {name} was killed."}
PB.theyDieBoss = {"{boss} killed {name}.", "{name} died fighting {boss}.", "{name} fell to {boss}.", "{name} was cut down by {boss}."}

-- PB.rez. Truth: the engine picks "close" when the tier is close even if nobody was ever
-- raised before, so "as {they} had before" can be false. Pick "close" only when
-- history.rez > 0 (CRITIQUE 6.7).
PB.rez.new = {"{name} raised {me} from death, a stranger's kindness.", "{name}, barely more than a stranger, brought {me} back from death."}
PB.rez.companion = {"{name} brought {me} back from death.", "{name} raised {me} from death.", "{name} was there to bring {me} back."}
PB.rez.close = {
    "{name} brought {me} back, {countTimes} now.",
    "{name} raised {me}, as {they} had before.",
    "Death did not keep {me}, with {name} there.",
}
PB.rezClass.PRIEST = {"{name} prayed {me} back from death.", "{name}'s prayers brought {me} back."}
PB.rezClass.PALADIN = {"{name} called on the Light, and {I} rose.", "The Light answered {name}, and brought {me} back."}
PB.rezClass.SHAMAN = {"{name} called {my} spirit back.", "The spirits heard {name}, and let {me} go."}
PB.rezClass.DRUID = {"{name} brought {me} back to life.", "{name} would not let death keep {me}."}

---------------------------------------------------------------------------
-- 9. LEVELS
-- No colons, no "grew stronger". A level is a fact; say it once.
---------------------------------------------------------------------------

-- ("was level N by the end of the day" is wrong once levels are told where they happened.)
PB.theyLevel = {"{name} reached level {theirs}.", "{name} made level {theirs}.", "{name} climbed to level {theirs}.", "{name} went up to level {theirs}."}
PB.theyLevelMark = {
    [10] = {"{name} reached level 10."},
    [20] = {"{name} reached level 20."},
    [30] = {"{name} reached level 30, halfway to the top."},
    [40] = {"{name} reached level 40, the level for a first mount."},
    [50] = {"{name} reached level 50, with ten levels left to climb."},
    [60] = {"{name} reached level 60, as high as any adventurer climbs."},
}
PB.bothLevel = {"{name} reached level {theirs}, and {I} reached {mine}.", "Both of {us} went up a level, {name} to {theirs} and {me} to {mine}."}
-- Roles in a dungeon, you and them ("tank+healer": you tanked, they healed).
PB.rolesPair = {
    ["tank+healer"] = {"{I} took the blows, and {name} kept {me} standing.", "{I} stood in front while {name} healed."},
    ["healer+tank"] = {"{name} took the blows, and {I} kept {them} standing.", "{name} stood in front while {I} healed."},
    ["damage+healer"] = {"{name} kept {us} alive while {I} fought.", "{name} healed, and {I} fought."},
    ["healer+damage"] = {"{I} kept {name} alive while {they} fought.", "{I} healed, and {name} fought."},
    ["tank+damage"] = {"{I} held the enemies while {name} cut them down."},
    ["damage+tank"] = {"{name} held the enemies while {I} cut them down."},
}
-- Earned, now and then: yours, or theirs ({boss}, {weapon}, {theirWeapon}).
PB.boastYou = {
    damage = {"Most of the blows that brought {boss} down were {yours}.", "{boss} fell mostly to {my} {weapon}."},
    healer = {"Nobody fell while {I} watched over them."},
    tank = {"{boss} never got past {me}."},
}
PB.boastThem = {
    damage = {"Most of the blows that brought {boss} down were {name}'s.", "{boss} fell mostly to {name}'s {theirWeapon}."},
    healer = {"Nobody fell while {name} watched over {us}."},
    tank = {"{boss} never got past {name}."},
}
-- PB.soloBefore: from your own journal, the hours you spent alone that day
-- before they joined you ({soloSpan} "about two hours" or "a long day",
-- {soloZone} where). Never on the day you met.
PB.soloBefore = {
    "Before that, {I} had spent {soloSpan} alone in {soloZone}.",
    "{I} had already spent {soloSpan} alone in {soloZone} by then.",
    "Earlier, {I} had spent {soloSpan} alone in {soloZone}.",
}
-- Moments from your own journal while you were together ({pair}, {what}, {to}, {killer}).
PB.shared = {
    sunset = {
        "{pair} were at {what} when the sun went down.",
        "{pair} were at {what} as the sun went down.",
        "The sun went down on {pairObj} at {what}.",
    },
    voyage = {
        zeppelin = {
            "{pair} took the zeppelin across the sea to {to}.",
            "{pair} rode the zeppelin over the water to {to}.",
            "{pair} crossed to {to} by zeppelin.",
            "{pair} went over the sea to {to} on the zeppelin.",
        },
        boat = {
            "{pair} took the boat across to {to}.",
            "{pair} sailed for {to}.",
            "{pair} crossed to {to} by ship.",
            "{pair} went aboard a ship and crossed the sea to {to}.",
        },
    },
    landmark = {
        "{pair} came to {what} together.",
        "Before the day was out, {pair} stood at {what}.",
        "That day brought {pairObj} to {what}.",
    },
    -- ("along the way" had become the book's tic; one line keeps it.)
    gather = {
        "{I} {work} along the way.",
        "{I} {work} as {we} went.",
        "On the way, {I} {work}.",
        "In between, {I} {work}.",
    },
    close = {
        "{killer} nearly got {me}.",
        "{I} barely got away from {killer}.",
        "{killer} nearly killed {me}.",
        "{killer} came close to killing {me}.",
        "{I} got away from {killer} with very little life left.",
    },
    FALLING = {
        "{I} nearly fell to {my} death.",
        "{I} almost took the short way down.",
        "A fall very nearly killed {me}.",
        "{I} fell a long way and only just lived.",
    },
    DROWNING = {
        "{I} nearly drowned.",
        "{I} came up for air just in time.",
        "{I} stayed under too long, and only just came up in time.",
        "The water very nearly had {me}.",
    },
    -- NEW KEYS (engine hook: the same own-journal events, shared while together;
    -- tokens as the own journal passes them, plus {pair} {I} {we}).
    snow = {
        "{pair} walked through snow in {zoneD}, and {I} had never seen snow before.",
        "It was the first snow {I} had ever seen, and {pair} left tracks through it.",
    },
    fish = {
        "{pair} spent a while at {place}, and {I} {work}.",
        "At {place}, {I} put a line in the water and {work}.",
    },
    rareBeast = {
        "{pair} came across {what}, a beast most people only hear of.",
        "{what} crossed {our} path in {zoneD}, and not many people ever see it.",
    },
    swim = {
        "{pair} swam across {place} rather than walk around it.",
        "{pair} took to the water in {place} and swam a long way.",
    },
    nightFlight = {
        "{pair} flew to {to} after dark.",
        "It was night when {pair} flew to {to}.",
    },
}
-- PB.bothSame: the same level, reached together.
PB.bothSame = {"{pair} both reached level {theirs}.", "{pair} reached level {theirs} together."}
PB.myLevel = {"{I} reached level {mine}.", "{I} made level {mine} along the way.", "{I} climbed to level {mine}."}
PB.levelThen = {
    "{They} had been level {thenLevel} in {firstZone}, the day {we} met.",
    "{They} had been level {thenLevel} when {we} first met.",
}

---------------------------------------------------------------------------
-- 10. REST
-- A fire or an inn is often the right last sentence. Leave it plain.
-- Never "the day ended at ..." unless the rest is the day's last event (CRITIQUE 6.7).
---------------------------------------------------------------------------

PB.fire.first = {
    "{we} made camp in {place} and shared a fire for the first time.",
    "{we} sat by a fire together in {place} for the first time.",
    "{we} shared {our} first campfire in {place}.",
}
PB.fire.new = {
    "{we} made camp in {place}.",
    "{we} rested by a fire in {place}.",
    "{we} stopped for a fire in {place}.",
    "There was a fire in {place}, and {we} sat by it a while.",
}
PB.fire.close = {
    "{we} made camp in {place}, as {we} had many times before.",
    "{we} stopped for a fire in {place}, as {we} often did.",
    "{we} made another camp in {place}.",
}
PB.fireSame = {
    "{we} made camp in {place} again, where {we} had shared {our} first fire.",
    "{we} stopped for a fire in {place}, where the first one had been.",
}

PB.inn = {
    "{we} rested at the inn at {place}.",
    "At the inn at {place}, {we} rested a while.",
    "{place} had an inn, and {we} rested there.",
}
PB.innFirst = {"{we} rested at the inn at {place}, the first inn {we} had shared."}
PB.innClose = {"{we} rested at the inn at {place}, as {we} had before.", "{we} stopped at the inn at {place} again."}

-- PB.lateNight / PB.earlyStart
PB.lateNight = {"It was past midnight when {we} stopped.", "Midnight came and went before {we} stopped.", "{we} were still out well past midnight."}
PB.earlyStart = {"{pair} were out before the sun was properly up.", "It was barely dawn when {pair} set out."}

---------------------------------------------------------------------------
-- 11. TALLIES (one per chapter at most; CRITIQUE 6.9)
---------------------------------------------------------------------------
PB.milestoneDays = {
    [5] = {},
    [10] = {"It was {our} tenth day out together."},
    [25] = {"That made twenty-five days together, counting from the first in {firstZone}."},
    [50] = {"That made fifty days together, counting from the first in {firstZone}."},
    [100] = {"It was {our} hundredth day together, counting from the first in {firstZone}."},
}
PB.anniversary = {
    [1] = {"It had been a month since the day {I} met {name} in {firstZone}.", "A month had passed since {firstZone}, where {name} first joined {my} party."},
    [3] = {"It had been three months since the day {I} met {name} in {firstZone}.", "Three months had passed since {firstZone}, where {name} first joined {my} party."},
    [6] = {"It had been half a year since {firstZone}, where {name} first joined {my} party."},
    [12] = {"It had been a year since {firstZone}, where {name} first joined {my} party."},
}
PB.dungeonCount = {
    [5] = {"That made five dungeons together."},
    [10] = {"That made ten dungeons together."},
    [25] = {"That made twenty-five dungeons together."},
}

---------------------------------------------------------------------------
-- 12. CROSSING PATHS ONLY (one sentence is the whole chapter)
---------------------------------------------------------------------------
PB.seenFirst = {"{I} crossed paths with {name}, {aWho}, in {place}.", "{I} saw {name}, {aWho}, in {place}.", "{AWho} named {name} passed {me} in {place}."}
PB.seenAgain = {"{I} saw {name} again in {place}.", "{name} was in {place} as well.", "{pair} crossed paths in {place}.", "{name} was about in {place}, going {their} own way."}
PB.seenOften = {"{name} was in {place}, as {they} often {was}.", "{I} saw {name} in {place}, the {nth} time now.", "{I} saw {name} in {place}, though the two of {us} had still never grouped."}
PB.seenLong = {
    "{I} saw {name} in {place} again.",
    "In {place}, {I} saw {name} again.",
}
PB.seenTimes = {"{Count} times that day, {name} crossed {my} path."}
PB.seenCompanion = {"No outing together that day, only a glimpse of {name} in {place}.", "{I} saw {name} in {place}, but there was no outing together that day."}

---------------------------------------------------------------------------
-- 13. CLOSERS
-- Drop them on ordinary days. A chapter may end on its last fact; vanilla
-- completions end on a plain statement four times in ten and on a blessing
-- one time in forty. Keep a few for a won or a lost day, and make the engine
-- use them on at most one chapter in five (CRITIQUE 6.6).
---------------------------------------------------------------------------
PB.close.first, PB.close.new, PB.close.companion, PB.close.close, PB.close.rare, PB.close.forged = {}, {}, {}, {}, {}, {}
PB.close.grim = {"Not {our} finest day.", "It was not a good day."}
-- ("Well done." is the most vanilla line of all, but in the diary voice it is self-praise. Give it to
-- the "you" voice only once the engine can tell the voices apart.)
PB.close.triumph = {"It had been a good day's work.", "Few days went better than that one."}

-- PB.closeForeshadow (a first outing closed on what came later: "It would not be the last time
-- you went out together") was hindsight and a stock ending: removed 2026-11-06. The engine's
-- hook stays and is skipped while the pool is absent.
PB.closeForeshadow = nil

-- PB.blessing. These are added raw (no tokens), so the diary voice currently gets
-- "Dark Lady watch over you both." Every line below works in both voices (no "you").
PB.blessing = {
    Horde = {"For the Horde.", "Lok'tar."},
    Alliance = {"For the Alliance.", "Light be praised."},
    Scourge = {"For the Dark Lady."},
    Tauren = {"Earthmother be thanked."},
    Dwarf = {"Aye, a fine day's work."},
}

---------------------------------------------------------------------------
-- 14. TITLES (static lists; see CRITIQUE 6.10 for the dynamic ones)
---------------------------------------------------------------------------
PB.title = {
    meet = {"First Meeting", "How It Began", "The First Day"},
    atLast = {"At Last", "Crossed Paths"},
    risen = {"Risen Together", "Deathknell", "From the Grave"},
    origin = {"Where It Began", "The First Day"},
    pause = {"The Return", "Back Again", "Together Again"},
    returning = {"A Familiar Face", "Welcome Back"},
    death = {"A Hard Day", "A Bad Day"},
    fall = {"A Long Way Down", "A Long Fall"},
    water = {"Drowned", "Too Deep"},
    fire = {"By the Fire", "The Campfire"},
    inn = {"At the Inn", "Under One Roof"},
    home = {"Home Ground", "Home"},
    nostalgic = {"Old Ground", "Old Haunts"},
    seen = {"A Face in the Crowd", "Passing By", "In Passing"},
}
-- Rotating returning and fire titles.
PB.title.returning = {"A Familiar Face", "Welcome Back", "Old Company"}
PB.title.fire = {"By the Fire", "The Campfire", "Firelight"}

-- Memory, lighter routine days, and warmth that is true ------------------------------
-- (Pools that extend the tables above: they come after them.)
PB.dayRest, PB.dayWork = PB.dayRest or {}, PB.dayWork or {}
PB.bridge = {
    "{Count} more days together followed, in {bridgeZones}.",
    "The next {count} outings together went to {bridgeZones}.",
    "{Count} more days together took {us} to {bridgeZones}.",
}
PB.bridgeOne = {
    "Another day together followed, in {bridgeZones}.",
    "A day in {bridgeZones} came next.",
}
-- the same zone as the day before. {runNth} = "second", "third"...
-- (Not "again": the callbacks alone pushed "again" to 3.8 per 1,000 words.)
PB.inZoneAgain = {"back in {zoneD}", "in {zoneD}, where {we} had left off", "in {zoneD} for a second day",
    "in {zoneD}, where {we} had been the day before"}
-- ("yet again" read weary three times in the 60-day book; "for a {runNth} straight day" gave "for a
-- eighth straight day".) The engine says the run on days 3, 5, 7 and 10 only (R3-12).
PB.inZoneRun = {"in {zoneD}, the {runNth} day running", "in {zoneD} for the {runNth} day in a row", "in {zoneD} for the {runNth} straight day"}
-- a routine day without the hours (only when the outing ran 90+ minutes).
-- ("were out there" reads as slang; "spent the night there" says you slept there.)
PB.dayGoPlain = {"were {inZone}", "spent some time {inZone}"}
-- on a routine day the count need not be exact every time.
PB.dayWork.fewVague = {"turned in a few quests", "saw to a handful of quests"}
PB.dayWork.manyVague = {"turned in a good many quests", "got through a long list of quests"}
-- PB.dayWork.many: "worked for over two hours ... and worked through eight quests" (the verb twice).
PB.dayWork.many = {"turned in {count} quests", "cleared {count} quests", "got through {count} quests"}
-- one routine day in five or so is one short sentence, never two in a row.
PB.dayShort = {
    "{pair} spent another day in {zoneD}.",
    "{pair} kept to {zoneD} that {part}.",
    "{pair} worked through another day in {zoneD}.",
}
PB.dayShortAgain = {
    "{pair} stayed on in {zoneD}.",
    "{pair} stayed on in {zoneD} for another day.",
    "{pair} gave {zoneD} another day.",
    "Another day went to {zoneD}.",
    "The next day found {pairObj} still in {zoneD}.",
}
-- the chapter's point of entry. {lead} = "In Silverpine Forest" or "In Silverpine
-- Forest, where the worgen howl" (then {day} no longer names the place). Only as a chapter's first
-- sentence, one quiet day in four.
PB.dayLead = {"{lead}, {pair} {day}."}
-- the deed first, on a day of six quests or more (and no fire or inn folded in).
PB.dayDeed = {
    "{Length} together {inZone} came to {count} quests.",
    "{pair} spent {length} {inZone} and turned in {count} quests.",
}
-- the same inn again (the engine counts visits per inn).
PB.dayRest.innAgain = {
    "rested at the inn at {place}, as {we} had before",
    "went back to the inn at {place}",
    "stopped at the familiar inn at {place}",
}
-- anniversaries for companions who started together (the spouse). The
-- engine said nothing at a month, three, six or twelve for them before.
PB.anniversaryOrigin = {
    [1] = {"It had been a month since {pair} first set out together."},
    [3] = {"Three months had passed since {pair} first set out together from {firstZone}."},
    [6] = {"It had been half a year since {pair} started out together, and {name} was still at {my} side."},
    [12] = {"It had been a year since {pair} started out together, and {name} was still at {my} side."},
}
-- PB.dungeonCountBack, the dungeon counts that remember the first dungeon
-- ({firstDungeon} = the first recorded dungeon visit). The engine prefers it over
-- PB.dungeonCount ("That made ten dungeons together.") once {firstDungeon} is known.
-- (every run so far the same place: {dungeonE})
PB.dungeonCountSame = {
    [5] = {"That made five runs through {dungeonE} together."},
    [10] = {"That made ten runs through {dungeonE} together."},
    [25] = {"That made twenty-five runs through {dungeonE} together."},
}
PB.dungeonCountBack = {
    [5] = {"That made five dungeons together, counting from {firstDungeon}."},
    [10] = {"That made ten dungeons together. The first had been {firstDungeon}."},
    [25] = {"That made twenty-five dungeons together, counting from {firstDungeon}."},
}
-- shared fires, counted.
PB.fireCount = {
    [10] = {"It was the tenth fire {we} had shared."},
    [25] = {"That made twenty-five fires shared."},
    [50] = {"It was the fiftieth fire {we} had shared."},
}
-- These count recorded shared days, not the interval since a previous entry.
PB.title.days = {[10] = "Ten Days Together", [25] = "Twenty-Five Days Together", [50] = "Fifty Days Together", [100] = "A Hundred Days Together"}
-- a companion who keeps bringing you back, counted at five and ten.
PB.rezCount = {
    [5] = {"{name} brought {me} back from death, the fifth time {they} had done it."},
    [10] = {"{name} brought {me} back from death for the tenth time."},
}
-- the same callback for a companion who started out with you ("the day you
-- met" is false for a wife who rose from the grave beside you).
PB.levelThenOrigin = {
    "{They} had been level {thenLevel} in {firstZone}, on the day {we} started out together.",
    "{They} had been level {thenLevel} when {we} started out together.",
}

-- Openings that vary, and quiet days told together ----------------------------------
-- the day with another subject. The quest, the place, the hours or the count
--    opens the sentence; the two of you are in it or understood. "Plain" = the hours are not told.
--    (Only one "kept" per key: the first draft had "kept" in six lines, and the 60-day book went from
--    4 to 11 uses of the word.)
--    (A "none" line needs the time of day; the engine skips it once {part} was said.)
PB.dayAlt = {
    none = {"{Length} went to {zoneD}.", "{zoneD} took {length} of {our} {part}."},
    nonePlain = {"The {part} went to {zoneD}."},
    one = {"{Length} together in {zoneD} went to {quest}.", "{we} spent {length} in {zoneD} and finished {quest} there."},
    onePlain = {"The {part} in {zoneD} included {quest}.", "{we} completed {quest} during {our} time in {zoneD}."},
    two = {"{Length} in {zoneD} went to {quest} and {questB}.", "{we} spent {length} together in {zoneD} and completed {quest} and {questB}."},
    twoPlain = {"The {part} in {zoneD} included {quest} and {questB}.", "{we} finished {quest} and {questB} during {our} time in {zoneD}."},
    few = {"{Length} together in {zoneD} came to {count} quests.", "{we} spent {length} in {zoneD} and completed {count} quests there."},
    fewPlain = {"{we} completed {count} quests in {zoneD} that {part}.", "The {part} in {zoneD} included {count} completed quests.",
        "{Count} quests were completed during {our} time in {zoneD}."},
}
-- the same zone as yesterday, not named again (the title says "Still in ...").
-- (Only on a day of three or more quests with no fire or inn, so the chapter's title is the run title.)
PB.dayGoRun = {"kept at it", "carried on"}
-- two quiet days in one zone, told as one chapter.
-- (The merged chapter has no greeting of its own, so every line names the two of you.)
PB.dayTwo = {
    "{pair} spent {weekdayA} and {weekdayB} in {zoneD} and turned in {count} quests.",
    "{WeekdayA} and {weekdayB} both took {pairObj} to {zoneD}, {count} quests in all.",
    "Two days in {zoneD}, {weekdayA} and {weekdayB}, came to {count} quests for {pairObj}.",
}
PB.dayTwoAgain = {
    "{pair} stayed on in {zoneD} through {weekdayA} and {weekdayB} and turned in {count} quests.",
    "{WeekdayA} and {weekdayB} found {pairObj} still in {zoneD}, {count} quests in all.",
    "{pair} were in {zoneD} for {weekdayA} and {weekdayB} too, {count} quests in all.",
}
PB.dayTwoNone = {"{pair} spent {weekdayA} and {weekdayB} in {zoneD}.", "{WeekdayA} and {weekdayB} both took {pairObj} to {zoneD}."}
-- the work before a dungeon, with the quests as the subject (only when no fire
--    or short dungeon visit is folded in: {extras} needs a subject that does things).
PB.preludeAlt = {"{Pcount} quests around {zoneD} came first.", "The {part} started with {pcount} quests around {zoneD}."}

-- Round 7: the writer pools, new ones and sub-pools set after their tables.
PB.oncePerBook = {
    "{I} took the short way down, and died of it.",
    "{killer} killed {me}. At {my} level, that takes some doing.",
    "Of all things, it was {killer} that killed {me}.",
    "{killer} killed {me} in {place}. The less said about that, the better.",
    "{I} fell to {my} death. The drop was further than it looked.",
    "{I} drowned. The water had looked harmless.",
}

-- Round 8: the writer pools.
PB.fireMeet = {
    "{we} made camp in {place} before the day was out.",
    "{we} sat by a fire in {place} a while.",
    "There was a fire in {place}, and {we} stopped by it.",
}
PB.boastYou.damage = {"{I} did more than anyone to bring {boss} down.", "{boss} fell mostly to {my} {weapon}."}
PB.boastThem.damage = {"{name} did more than anyone to bring {boss} down.", "{boss} fell mostly to {name}'s {theirWeapon}."}
PB.rolesPair["tank+damage"] = {"{I} held the enemies, and {name} brought them down.", "{I} took the blows while {name} did the killing."}
PB.rolesPair["damage+tank"] = {"{name} held the enemies, and {I} brought them down.", "{name} took the blows while {I} did the killing."}
PB.rolesPairClass = {
    ["healer+tank"] = {
        PRIEST = {"{name} stood in front, and {I} kept {them} standing with the Light."},
        PALADIN = {"{name} took the blows, and {I} kept {them} standing with the Light."},
        DRUID = {"{name} took the blows, and {I} kept {them} alive with the druids' healing."},
    },
    ["tank+damage"] = {
        PALADIN = {"{I} took the blows and called on the Light, and {name} brought the enemies down."},
        DRUID = {"{I} took the shape of the bear and held the enemies, and {name} brought them down."},
    },
    ["damage+tank"] = {
        HUNTER = {"{name} held the enemies, and {my} arrows did the rest."},
    },
}
PB.sharedRezOtherBy = {
    PRIEST = {"{I} prayed {them} back from death, the first {I} had ever raised."},
    PALADIN = {"{I} called on the Light, and {name} rose, the first {I} had ever raised."},
    SHAMAN = {"{I} called {their} spirit back, the first {I} had ever raised."},
}
PB.theyDieBossCostly = {
    "{boss} killed {name}, and died all the same.",
    "{boss} killed {name}, but did not live out the fight.",
}
PB.killRollAfter = {
    "After that, {we} killed {roll}.",
    "{we} went on and killed {roll}.",
    "From there {we} killed {roll}.",
}
PB.wipeThenWinDied = {
    "{boss} won the first fight and killed {me}, but not the second.",
    "{boss} killed {me} the first time, and died the second.",
}
PB.dungeonFirstEver = {
    "It was the first dungeon {I} had ever gone into.",
    "{I} had never been inside a dungeon before.",
}
PB.preludeOne = {
    "In {zoneD}, {pair} turned in {quest} first.",
    "First {pair} turned in {quest} in {zoneD}.",
}

-- Round 8 (the writer).
do
    local function Extend(pool, list) for _, line in ipairs(list) do pool[#pool + 1] = line end end
Extend(PB.oncePerBook, {
    "{others} made one more in the party.",
})
end

-- Round 8b (the writer).
-- PB.rezClass.SHAMAN  ({name} {my} {me} {I}). "The spirits heard Grosh, and let you go." read as "released you".
PB.rezClass.SHAMAN = {"{name} called {my} spirit back.", "{name} called on the spirits, and {I} came back."}

-- PB.dayWork.hard  ({quest} {our}). "took on Lost in Battle, well above your level": "took on" reads as
-- "accepted", and the record is a turn-in.
PB.dayWork.hard = {"finished {quest}, work meant for more seasoned adventurers", "turned in {quest}, which was above {our} level"}

-- Round 8c (writer).
-- PB.infamous["Bhag'thera"]  (chapter tokens; {Iwas} is "you were" / "I was"). One sentence of twelve
-- words in place of a seven-word stub between the death and the rescue.
PB.infamous["Bhag'thera"] = {"She had long eluded Nesingwary's whole party, and {Iwas} no luckier."}

-- PB.killTwo  ({we} {bosses}). DELETE "{bosses} were dealt with in turn." (a clerk's phrase, flagged in
-- CRITIQUE6 and still ending Elisabeth I, telling 3).
PB.killTwo = {"{we} killed {bosses}.", "{bosses} both fell.", "{bosses} fell, one after the other.", "{we} killed {bosses}, one after the other."}

-- Origin is deliberate backstory; the next captured scene may be much later.
PB.knownBeginning = {
    "Later travels brought {pairObj} to {zoneD}.",
    "By then, {pair} were travelling together in {zoneD}.",
    "In {zoneD}, {pair} were travelling together still.",
}
-- Contextual callbacks refer only to an actual earlier scene in this region.
PB.sceneMemory = {
    fire = {
        "In {zoneD}, {we} had shared a fire {memoryWhen}.",
        "An earlier visit to {zoneD} had included a fire together, {memoryWhen}.",
        "{zoneD} had been a place of shared firelight {memoryWhen}.",
    },
    sunset = {
        "{memoryWhen}, {we} had been together at {memoryPlace} as the sun went down.",
        "On an earlier visit, {memoryWhen}, the sun had gone down with {us} at {memoryPlace}.",
    },
    landmark = {
        "{memoryWhen}, {pair} had reached {memoryPlace} together in this country.",
        "An earlier day in this country had brought {pairObj} to {memoryPlace}, {memoryWhen}.",
    },
}
-- A known quest becomes a scene with a problem and an outcome. Lesser jobs
-- can be counted without taking over the paragraph with three unrelated names.
PB.dayWork.scene = {
    "finished {quest} among {count} quests",
    "completed {count} quests, including {quest}",
    "turned in {quest} as part of {count} quests",
}
PB.dayWork.sceneOne = {"finished {quest}", "completed {quest}", "turned in {quest}"}
PB.questDepth = {"{we} completed {quest}.", "{we} finished {quest}."}
PB.questThreadReturn = {
    "There was more to {threadLabel} after {previousQuest}.",
    "{previousQuest} had not been the end of {threadLabel}.",
    "{we} took up {threadLabel} where {previousQuest} had left off.",
}
PB.sharedNotableSeen = {
    "While travelling with {name}, {I} saw {notable} in {place}.",
    "{I} saw {notable} in {place} during {our} travels together.",
}
PB.sharedNotableSpoke = {
    "While travelling with {name}, {I} spoke with {notable} in {place}.",
    "{I} spoke with {notable} in {place} during {our} time together.",
}
PB.sharedGatherQuiet = {
    "{I} {work} while {we} were out.",
    "{I} {work} on the side.",
    "{I} also {work}.",
}

-- Dates establish elapsed time, not what happened between recorded outings.
PB.recordedInterval = {
    "{gap} later, {pair} travelled together again.",
    "{gap} later, {name} joined {me} in {zoneD}.",
    "{name} was back after {gap}, and {we} set out in {zoneD}.",
    "{pair} next went out {later}, in {zoneD}.",
    "{gap} on, {pair} were out together, in {zoneD}.",
}
PB.recordedIntervalBond = {
    "{gap} later, {name}, {bondWord}, was beside {me} in {zoneD}.",
    "{gap} later, {pair} were together again in {zoneD}.",
    "{name}, {bondWord}, was back at {my} side {later}, in {zoneD}.",
    "{later}, {pair} took to {zoneD}.",
    "{gap} on, {pair} were out together, in {zoneD}.",
}

---------------------------------------------------------------------------
-- A chapter a week or more after the last outing together (2026-11-06): how a
-- game master opens a new night at the table. The gap in words ({since}: "a
-- week", "two months", "half a year"), the place now ({zoneD}) against the
-- place then ({lastZone}), the hour and the weekday, and on the long gaps one
-- sentence of what the last outing recorded (their level then and now, a lord's
-- fall, a dungeon). Elapsed time between recorded outings only: nothing here
-- says what either of you did in between, nor why. Buckets: short (a week to
-- under three weeks), long (three weeks to five months), longest (about half a
-- year or more, or the longest gap of the book). Shapes: same (the zone of the
-- last outing), else (another zone), met (back where the companion first
-- joined), bond (a spouse, sibling or oldest friend, one time in three).
---------------------------------------------------------------------------
PB.absence = {
    short = {
        same = {
            "{since} later, {pair} were back in {zoneD}.",
            "{since} on, {pair} were in {zoneD} again, that {weekday} {part}.",
            "It was {since} before {pairNamed} were back in {zoneD}.",
            "{name} was back {since} later, and {zoneD} again was where {we} went.",
            "{since} passed before {pair} went out together again, and {zoneD} was where {we} did.",
            "{since} after the last time, {pair} were in {zoneD} once more.",
        },
        ["else"] = {
            "{since} after {lastZone}, {pair} were out in {zoneD}.",
            "{since} on from {lastZone}, {name} was back in {my} party, in {zoneD}.",
            "The next time {pair} went out, {since} later, it was in {zoneD}.",
            "{since} had passed since {lastZone}. That {weekday} {part}, {pair} set out in {zoneD}.",
            "{name} joined {me} again {since} later, in {zoneD} this time.",
            "{lastZone} had been the last place. {since} later, {pair} were in {zoneD}.",
        },
    },
    long = {
        same = {
            "{since} had gone by when {pair} were next out together, in {zoneD} again.",
            "{since} later, on {weekday} {part}, {name} was back in {my} party, and {zoneD} was the place again.",
            "It had been {since} since {pair} had last gone out, and that too had been in {zoneD}.",
            "{pair} were back in {zoneD} after {since}.",
            "After {since}, {pairNamed} were in {zoneD} once more, that {weekday} {part}.",
            "{since} had passed. {pair} were in {zoneD} again, the same ground as the last time.",
        },
        ["else"] = {
            "{since} had passed since {lastZone}. {pair} set out again in {zoneD}.",
            "When {pair} next went out, {since} later, it was in {zoneD}.",
            "{since} after {lastZone}, {name} was in {my} party again, this time in {zoneD}.",
            "{lastZone} had been the last place. {since} later {pair} were in {zoneD}.",
            "{since} on from {lastZone}, {pair} went out into {zoneD} on {weekday} {part}.",
            "It had been {since}. {name} was back beside {me}, and the place was {zoneD}.",
            "{since} lay between {lastZone} and that {weekday} {part} in {zoneD}.",
        },
        met = {
            "{since} later, {pair} were back in {zoneD}, where {name} had first joined {my} party.",
            "{since} on, it was {zoneD} again, where {pair} had first met.",
            "After {since}, {pair} were in {zoneD} once more, the place where it had begun.",
        },
        bond = {
            "{Bond} was back at {my} side after {since}, in {zoneD}.",
            "{since} had passed. Then {name}, {bondWord}, was in {my} party again, in {zoneD}.",
            "After {since}, {name}, {bondWord}, was with {me} again in {zoneD}.",
            "{since} on, {bondWord} was with {me} in {zoneD} once more.",
        },
    },
    longest = {
        same = {
            "{since} had passed since {pair} had last been out together, and {zoneD} was where {we} met again.",
            "{since} later, {name} was back at {my} side, in {zoneD} as before.",
            "{since} went by. Then, on {weekday} {part}, {pair} were in {zoneD} again.",
            "It had been {since}, and the place was the same, {zoneD}, with {name} beside {me}.",
        },
        ["else"] = {
            "{since} had gone by since {pair} had last been out together, in {lastZone}. On {weekday} {part}, {we} set out again in {zoneD}.",
            "After {since}, {name} was in {my} party again. The last time had been {lastZone}, and this time it was {zoneD}.",
            "{since} lay between {lastZone} and that {weekday} {part} in {zoneD}.",
            "{since} had passed since {lastZone}. {pair} went out again, in {zoneD}.",
            "{since} later, {pair} were out together again, in {zoneD}. The last time had been {lastZone}.",
        },
        met = {
            "{since} later, {pair} were back in {zoneD}, where {name} had first joined {my} party.",
            "After {since}, it was {zoneD} again, where it had all begun.",
        },
        bond = {
            "{since} had passed. Then {name}, {bondWord}, was at {my} side again, in {zoneD}.",
            "After {since}, {name}, {bondWord}, was with {me} again, in {zoneD}.",
            "{since} later, on {weekday} {part}, {bondWord} was back in {my} party, in {zoneD}.",
        },
    },
}
-- The second sentence of such an opening, from what the last outing recorded
-- ({theirs} {theirsThen} {mine} {mineThen} {lastLord} {lastDungeon}). Told on
-- the long gaps, not in Highlights.
PB.absenceRecap = {
    theirs = {
        "{name} was level {theirs} by then, up from {theirsThen}.",
        "{name} had been level {theirsThen} the last time, and was {theirs} now.",
        "Since then {name} had gone from level {theirsThen} to {theirs}.",
    },
    both = {
        "{name} was level {theirs} by then, up from {theirsThen}, and {Iwas} level {mine}.",
        "Since then {name} had gone from level {theirsThen} to {theirs}, and {I} from {mineThen} to {mine}.",
        "Both of {us} had climbed in the meantime, {name} to level {theirs} and {me} to {mine}.",
    },
    bothSame = {
        "Both of {us} were level {theirs} by then.",
        "{pairNamed} were both level {theirs} by then, up from {theirsThen}.",
        "Since then both of {us} had climbed to level {theirs}.",
    },
    lord = {
        "The last time out had ended with {lastLord} dead in {lastDungeon}.",
        "{lastLord} had fallen to {us} in {lastDungeon} the last time.",
        "The time before, {lastDungeon} had been the end of the day, and {lastLord} with it.",
    },
    dungeon = {
        "The last time out had taken {pairObj} into {lastDungeon}.",
        "{lastDungeon} had been the last place {we} went down into together.",
    },
}

-- More moments shared with a companion (your own journal saw them while you
-- were together; 2026-11-05). Tokens: {I} {me} {my} {we} {our} {pair} {name} and
-- the moment's own ({who} {outcome} {what} {places} {faction} {standing}).
PB.shared.duelWith = {
    "{pair} duelled, and {winner} won.",
    "{pair} tried each other in a duel, and {winner} won it.",
    "There was a duel between the two of {us}, and {winner} won.",
}
PB.shared.duel = {
    "{I} duelled {who} while {we} were together, and {outcome}.",
    "{who} and {I} duelled that day, and {I} {outcome}.",
}
PB.shared.rareKilled = {
    "{I} killed {what} while {we} travelled together, a creature few ever see.",
    "{what} crossed {our} path, and {I} killed it.",
}
PB.sharedRep = {
    friendly = {"{Faction} counted {me} a friend by then.", "By then {I} stood in good standing with {faction}."},
    honored = {"{Faction} held {me} in honor by then.", "By then {faction} honored {my} name."},
    revered = {"{Faction} revered {me} by then.", "By then {I} was revered among {faction}."},
    exalted = {"{I} stood as high with {faction} as anyone could.", "There was no higher standing with {faction} than the one {I} held now."},
}
PB.shared.explore = {
    "{I} found {my} way to {places} while {we} were out.",
    "On the way, {I} came upon {places}, new ground to {me}.",
}
PB.shared.read = {
    "Along the way {I} stopped to read {what}.",
    "{I} read {what} while {we} were there.",
}

-- Shared moments from your own journal that fell on a day together (2026-11-05,
-- editor2): your own first time in a country or on a continent, a first mount,
-- raid, epic or honorable kill; a cave or a battleground entered together.
-- Tokens: {I} {me} {my} {we} {our} {pair} {name} and the moment's own.
PB.shared.zoneFirst = {
    "{I} had never set foot in {zoneD} before that day.",
    "{zoneD} {zoneDWas} new to {me} that day.",
    "{zoneD} {zoneDWas} new ground to {me}, and {name} was there for it.",
    "Until that day {I} had never been in {zoneD}.",
    "It was {my} first time in {zoneD}.",
}
PB.shared.continent = {
    "It was the first time {I} had stood on {to}, and {name} was there for it.",
    "{to} was new to {me}, and {name} had come across with {me}.",
}
PB.shared.continentBy = {
    zeppelin = {"{pair} took the zeppelin to {to}, where {I} had never set foot.", "The zeppelin carried {pairObj} to {to}, {my} first time there."},
    boat = {"{pair} took the boat to {to}, where {I} had never set foot.", "The ship carried {pairObj} to {to}, {my} first time there."},
    portal = {"A portal took {pairObj} to {to}, where {I} had never set foot."},
    hearth = {"{my} hearthstone took {me} to {to}, where {I} had never set foot."},
}
PB.shared.cave = {
    "{pair} went down into {what} together.",
    "{what} took {pairObj} underground for a while.",
}
PB.shared.bg = {
    "{pair} went into {what} together.",
    "{pair} were in {what} together that day.",
}
PB.shared.mount = {
    "{I} rode {my} first mount that day, with {name} along.",
    "That was the day {I} first rode a mount of {my} own.",
}
PB.shared.raid = {
    "It was the first raid {I} had ever been in, and {name} was there.",
    "{I} had never been in a raid before that day.",
}
PB.shared.epic = {
    "{what} came to {me} that day, the first epic {I} had ever held.",
    "{I} came away with {what}, {my} first epic.",
}
PB.shared.pvp = {
    "{I} took {my} first honorable kill that day, with {name} in the party.",
    "That was the day of {my} first honorable kill, with {name} there.",
}
-- More of your own moments on a day together (milestones lane, 2026-11-06): the
-- swift mount, a legendary, the first blue, a set piece and the whole set, a
-- world boss, a PvP rank. Gold and the talent point stay in your own book.
PB.shared.epicMount = {
    "{I} rode a swift mount for the first time that day, with {name} along.",
    "That was the day {my} swift mount first came when {I} called.",
}
PB.shared.legendary = {
    "{what} came to {me} that day, and {name} was there to see it.",
    "{I} came away with {what}, one of a handful in the world, and {name} had been there.",
}
PB.shared.rare = {
    "{what} came to {me} that day, the first thing of any worth {I} had owned.",
    "{I} came away with {what}, the first thing {I} had found worth keeping.",
}
PB.shared.tier = {
    "The first piece of {what} was {mine} that day.",
    "{I} put on the first piece of {what} while {we} were there.",
}
PB.shared.setfull = {
    "With the last piece, {I} wore the whole of {what}, and {name} saw it.",
    "{I} wore all of {what} for the first time that day.",
}
PB.shared.worldboss = {
    "{what} fell that day, and {pair} were both in the crowd under it.",
    "{pair} were there when {what} came down.",
}
PB.sharedRank = {
    "{I} was {rank} now, in the {mySide}'s own reckoning.",
    "The {mySide} gave {me} the rank of {rank} that day.",
}
-- You brought them back from death (recorded with "Record more moments" on).
PB.rezGiven = {
    "{I} brought {name} back from death.",
    "{I} raised {name}.",
    "{I} brought {them} back.",
}
PB.rezGivenClass = {
    PRIEST = {"{I} prayed {name} back from death.", "{my} prayers brought {name} back."},
    PALADIN = {"{I} called on the Light, and {name} rose.", "The Light answered {me}, and {name} came back."},
    SHAMAN = {"{I} called {name}'s spirit back.", "{I} called on the spirits, and {name} came back."},
    DRUID = {"{I} brought {name} back to life.", "{I} would not let death keep {name}."},
}

---------------------------------------------------------------------------
-- 15. TWO VOICES (2026-11-05, editor2)
-- The diary ("we") is one of the two writing down what both lived through:
-- "Mira and I", "the two of us", "between us", our firsts, our returns, who
-- carried whom. The game master ("you") recaps a campaign: "your party", "the
-- pair of you", what the run came to. The engine (teller:Say) merges these
-- behind the common lines by Say key and prefers them every other time.
-- Facts only: nothing here says who struck, what was said or felt. The diary
-- lines never say "you"; the game master's never praise the writer either.
---------------------------------------------------------------------------
PB.voice = {we = {}, you = {}}
do
    local we, you = PB.voice.we, PB.voice.you
    -- Openings: the rhythm of meeting.
    we.daily = {"That {part}, {name} was beside me.", "Most days now, {name} came out with me, and that {part} was one of them.", "{name} and I went out together, as we did most days."}
    you.daily = {"{name} was at {my} side that {part}.", "{my} party that {part} was the usual one, {me} and {name}.", "Most days now, {name} was in {my} party, and that {part} was no different."}
    we.often = {"{name} came out with me that {part}.", "That {weekday}, {name} and I set out."}
    you.often = {"{name} was back in {my} party that {weekday}.", "That {part}, {my} party was {me} and {name}."}
    we.oftenGap = {"{later}, {name} and I went out.", "{name} and I took up {our} travels {later}."}
    you.oftenGap = {"{later}, {name} was back in {my} party.", "{my} party was whole again {later}, {name} and {me}."}
    we.returnInterval = {"{name} and I set out that {weekday}.", "That {weekday}, {name} was with me."}
    you.returnInterval = {"{name} was back in {my} party that {weekday}.", "That {weekday}, {my} party was {me} and {name}."}
    we.fortnightly = {"After {gap}, {name} was back at my side."}
    you.fortnightly = {"After {gap}, {name} was back in {my} party."}
    we.monthly = {"After {gap}, {name} and I set out.", "It had been {gap}. Then {name} was with me in the field."}
    you.monthly = {"{gap} had passed. {name} was back in {my} party.", "After {gap}, {my} party was {me} and {name}."}
    we.rare = {"{gap} had passed before {name} came out with me."}
    you.rare = {"{name} was back in {my} party after {gap}."}
    we.second = {"{later}, {name} and I went out a second time."}
    you.second = {"{later}, {name} was in {my} party a second time."}
    we.early = {"{later}, {name} and I went out."}
    you.early = {"{later}, {name} was back in {my} party."}
    we.bondOpen = {"{bondWord} and I set out that {part}.", "That {part}, {bondWord} was with me."}
    you.bondOpen = {"{Bond} was with {me} that {part}.", "{name}, {bondWord}, was in {my} party that {part}."}
    we.recordedInterval = {"{gap} later, {name} and I were out in {zoneD}.", "After {gap}, {name} and I took to {zoneD}."}
    you.recordedInterval = {"{gap} later, {name} was back in {my} party, in {zoneD}.", "{gap} on, {name} joined {me} in {zoneD}."}
    we.reunionBond = {"After {gap}, {bondWord} was at my side again.", "{gap} had passed before {name} and I set out."}
    you.reunionBond = {"After {gap}, {bondWord} was back at {my} side.", "{gap} had passed. Then {name}, {bondWord}, was back in {my} party."}
    we.openPlace = {"{name} and I went out into {zoneD} that {part}.", "That {part} took {name} and me to {zoneD}."}
    you.openPlace = {"That {part} {my} party went into {zoneD}.", "The {part} found {me} and {name} in {zoneD}."}
    -- After a week or more apart (PB.absence; the keys are absence + bucket + shape).
    we.absenceshortsame = {"{since} later, {name} and I were back in {zoneD}.", "{name} and I were in {zoneD} again {since} on."}
    you.absenceshortsame = {"{since} later, {name} was back in {my} party, in {zoneD} as before.", "{since} on, {pairNamed} were back in {zoneD}."}
    we.absenceshortelse = {"{since} after {lastZone}, {name} and I were out in {zoneD}.", "{name} and I next went out {since} later, in {zoneD}."}
    you.absenceshortelse = {"{since} after {lastZone}, {pairNamed} were in {zoneD}.", "{since} later, {name} was with {me} in {zoneD}."}
    we.absencelongsame = {"{since} had passed when {name} and I were next in {zoneD}.", "After {since}, {name} and I were back in {zoneD}."}
    you.absencelongsame = {"{since} had passed when you and {name} were next in {zoneD}.", "After {since}, {name} was with {me} in {zoneD} again."}
    we.absencelongelse = {"{since} had passed since {lastZone}. {name} and I set out in {zoneD}.", "After {since}, {name} and I were out in {zoneD}."}
    you.absencelongelse = {"{since} had passed since {lastZone}. You and {name} set out in {zoneD}.", "After {since}, {name} was back in {my} party, this time in {zoneD}."}
    we.absencelongestelse = {"{since} had gone by since {lastZone}. {name} and I set out in {zoneD}, on {weekday} {part}."}
    you.absencelongestelse = {"{since} had gone by since {lastZone}. On {weekday} {part}, {name} was back in {my} party, in {zoneD}."}
    we.absencelongestsame = {"{since} had passed, and {zoneD} was where {name} and I met again."}
    we.absencelongbond = {"{since} on, {bondWord} and I were out in {zoneD}."}
    you.absencelongbond = {"After {since}, you and {bondWord} set out together in {zoneD}."}
    we.absencelongestbond = {"After {since}, {bondWord} and I set out into {zoneD}."}
    you.absencelongestbond = {"{since} had passed before you and {bondWord} were out in {zoneD}."}
    you.absencelongestsame = {"{since} had passed, and {zoneD} was where you and {name} met again."}
    -- The land, and returns.
    we.explore = {"{name} and I went into {zoneD} together for the first time.", "It was the first time {pair} had been in {zoneD} together."}
    we.zoneReturn = {"{name} and I were back in {zoneD}."}
    you.zoneReturn = {"{my} party was back in {zoneD}.", "The pair of {us} returned to {zoneD}."}
    we.whereStarted = {"{name} and I were back in {zoneD}, where we had begun together."}
    you.whereStarted = {"{my} party was back in {zoneD}, where {me} and {name} had begun."}
    we.whereItBegan = {"{name} and I were back in {zoneD}, where we had first met."}
    you.whereItBegan = {"{my} party was back in {zoneD}, where {name} had first joined {me}."}
    we.travel = {"{name} and I spent {length} in {zoneD}."}
    you.travel = {"{my} party spent {length} in {zoneD}.", "The pair of {us} were in {zoneD} for {length}."}
    we.travelWork = {"{name} and I spent {length} in {zoneD} and finished {qcount} quests between us."}
    you.travelWork = {"{my} party spent {length} in {zoneD} and turned in {qcount} quests."}
    we.travelLong = {"{name} and I were out for {length} that day."}
    you.travelLong = {"{my} party was out for {length} that day.", "The pair of {us} put in {length} before stopping."}
    we.travelMany = {"{name} and I went from {from} to {to}, {length} in all."}
    you.travelMany = {"{my} party went from {from} to {to}, {length} in all."}
    you.day = {"The pair of {us} {day}."}
    -- Dungeons.
    we.dungeonfair = {"{name} and I went down into {dungeonE}.", "Down into {dungeonE} {pair} went, {lore}."}
    you.dungeonfair = {"{my} party went down into {dungeonE}.", "The pair of {us} went into {dungeonE}, {lore}."}
    we.dungeondaring = {"{dungeonE} {dungeonWas} a hard venture for two of {our} experience, and {name} and I went in.", "{dungeonE} {dungeonWas} a few levels above {name} and me, and we went in anyway."}
    you.dungeondaring = {"{dungeonE} {dungeonWas} a hard venture for a party of {our} experience. {pair} went in.", "{dungeonE} {dungeonWas} a few levels above {my} party, and {pair} went in anyway."}
    we.dungeonreckless = {"{dungeonE} {dungeonWas} meant for far stronger adventurers than {name} and me. {we} went in."}
    you.dungeonreckless = {"{dungeonE} {dungeonWas} meant for a far stronger party than {me} and {name}. {we} went in."}
    we.dungeonAgain = {"{name} and I went back into {dungeonE}.", "The two of us went back to {dungeonE}."}
    you.dungeonAgain = {"{my} party went back into {dungeonE}.", "The pair of {us} returned to {dungeonE}."}
    we.dungeonRegular = {"{name} and I were back in {dungeonE}, for the {nth} time."}
    you.dungeonRegular = {"{my} party was back in {dungeonE} for the {nth} time."}
    we.dungeonFirst = {"It was the first dungeon {name} and I had been in together.", "That was {our} first dungeon together, {name}'s and mine."}
    you.dungeonFirst = {"It was the first dungeon {my} party had run together.", "{pairNamed} had never been in a dungeon together before that."}
    we.dungeonLater = {"Later that {part}, {name} and I went down into {dungeonE}."}
    you.dungeonLater = {"Later that {part}, {my} party went down into {dungeonE}."}
    -- Bosses.
    we.killRoll = {"Between {us}, {we} killed {roll}.", "{name} and I killed {roll}."}
    you.killRoll = {"{my} party killed {roll}.", "The pair of {us} killed {roll}."}
    we.killOne = {"{name} and I killed {boss}.", "{boss} fell to the two of us."}
    you.killOne = {"{my} party killed {boss}.", "{boss} fell to the pair of {us}."}
    we.killTwo = {"{name} and I killed {bosses}.", "{bosses} fell to the two of us."}
    you.killTwo = {"{my} party killed {bosses}.", "{bosses} fell to the pair of {us}."}
    we.killMany = {"{name} and I killed {bosses}.", "Between {us}, {we} killed {bosses}."}
    you.killMany = {"{my} party killed {bosses}.", "{bosses} fell to the pair of {us}."}
    we.killLast = {"Last of all, {name} and I killed {boss}, {bossE}."}
    you.killLast = {"Last of all, {my} party killed {boss}, {bossE}."}
    we.killLastOnly = {"{name} and I killed {boss}, {bossE}.", "It came down to {boss}, {bossE}, and the two of us, and {shortRaw} fell."}
    you.killLastOnly = {"{my} party killed {boss}, {bossE}.", "It came down to {boss}, {bossE}, and the pair of {us}, and {shortRaw} fell."}
    we.killNamed = {"{name} and I killed {boss}, {bossE}."}
    you.killNamed = {"{my} party killed {boss}, {bossE}."}
    we.revenge = {"{short} had beaten {name} and me before. This time {we} won."}
    you.revenge = {"{short} had beaten {my} party before. This time {we} won."}
    we.wipe = {"{boss} beat the two of us that time."}
    you.wipe = {"{boss} beat {my} party that time."}
    -- Deaths, and who carried whom.
    we.dieBoss = {"{killer} cut me down, with {name} there.", "{killer} cut me down."}
    you.dieBoss = {"{killer} cut {me} down, with {name} there.", "{killer} got {me}."}
    we.dieHeroic = {"{killer} killed me, as {killerShort} had killed many before.", "I died fighting {killer}, with {name} there."}
    you.dieHeroic = {"{killer} killed {me}. Many have gone the same way.", "{I} fell to {killer}, with {name} there."}
    we.dieFoe = {"{killer} killed me in {place}, with {name} there.", "{killer} got the better of me in {place}."}
    you.dieFoe = {"{killer} killed {me} in {place}, with {name} there.", "{killer} got the better of {me} in {place}."}
    we.theyDie = {"{name} died in {place} while {pair} were out.", "In {place}, {name} died."}
    you.theyDie = {"{my} party lost {name} in {place}.", "In {place}, {name} died."}
    we.theyDieBoss = {"{boss} killed {name}, with me there.", "{boss} took {name} down, with me there."}
    you.theyDieBoss = {"{boss} killed {name}, with {me} there.", "{my} party lost {name} to {boss}."}
    we.theyDieTimes = {"{name} was killed {count} that day, with me there."}
    you.theyDieTimes = {"{my} party lost {name} {count} that day."}
    we.theyDieBossCostly = {"{boss} killed {name}, and died all the same."}
    you.theyDieBossCostly = {"{boss} killed {name} before it fell to {my} party."}
    we.rezcompanion = {"It was {name} who brought me back.", "{name} had me on my feet again."}
    you.rezcompanion = {"{name} had {me} back on {my} feet.", "It was {name} who raised {me}.", "{name} brought {me} back, and the party was whole again."}
    we.rezclose = {"{name} brought me back, as {they} had so often before.", "It was {name} who raised me, as before."}
    you.rezclose = {"{name} brought {me} back, as {they} had so often before.", "{name} had {me} back on {my} feet, as before."}
    we.rezGiven = {"This time I was the one who brought {name} back.", "I had {name} on {their} feet again."}
    you.rezGiven = {"This time it was {I} who raised {name}.", "{I} had {name} back on {their} feet."}
    we.sharedZoneFirst = {"It was my first time in {zoneD}, and {name} was with me for it."}
    you.sharedZoneFirst = {"{I} had never seen {zoneD} before, and {name} was with {me} for the first look at it."}
    we.sharedCave = {"{name} and I went down into {what}."}
    you.sharedCave = {"{my} party went down into {what}."}
    we.sharedBg = {"{name} and I went into {what} together."}
    you.sharedBg = {"{my} party went into {what}."}
    -- Rest.
    we.firenew = {"{name} and I made camp in {place}.", "The two of us sat by a fire in {place} a while."}
    you.firenew = {"{my} party made camp in {place}.", "The pair of {us} sat by a fire in {place} a while."}
    we.fireclose = {"{name} and I made camp in {place}, as we had many times.", "Another fire for the two of us, in {place}."}
    you.fireclose = {"{my} party made camp in {place}, as it had many times.", "Another fire for the pair of {us}, in {place}."}
    we.firefirst = {"{name} and I shared {our} first fire, in {place}."}
    you.firefirst = {"{my} party shared its first fire, in {place}."}
    we.inn = {"{name} and I rested at the inn at {place}.", "The two of us stopped at the inn at {place}."}
    you.inn = {"{my} party rested at the inn at {place}.", "The pair of {us} stopped at the inn at {place}."}
    we.innClose = {"{name} and I rested at the inn at {place} again."}
    you.innClose = {"{my} party rested at the inn at {place} again."}
    we.cityRest = {"{name} and I rested in {place}."}
    you.cityRest = {"{my} party rested in {place}."}
    -- Levels.
    we.theyLevel = {"{name} went up to level {theirs} while {pair} were out.", "{name} made level {theirs} at my side."}
    you.theyLevel = {"{name} made level {theirs} while in {my} party.", "{name} went up to level {theirs} at {my} side."}
    we.bothLevel = {"{name} went up to level {theirs} and I to {mine}, the same day."}
    you.bothLevel = {"{name} went up to level {theirs} and {I} to {mine}, the same day."}
    we.bothSame = {"{name} and I both made level {theirs} that day."}
    you.bothSame = {"The pair of {us} made level {theirs} the same day."}
    we.myLevel = {"I made level {mine} with {name} beside me."}
    you.myLevel = {"{I} made level {mine} with {name} in {my} party."}
    -- Moments shared.
    we.sharedSunset = {"{name} and I were at {what} as the sun went down."}
    you.sharedSunset = {"The sun went down at {what} with {name} and {me} there to see it."}
    we.sharedLandmark = {"{name} and I came to {what} together."}
    you.sharedLandmark = {"{my} party reached {what} that day."}
    we.sharedSnow = {"{name} and I walked through snow in {zoneD}, the first I had ever seen."}
    you.sharedSnow = {"In {zoneD}, {pairNamed} walked through snow, the first {I} had ever seen."}
    we.sharedVoyagezeppelin = {"{name} and I took the zeppelin across the sea to {to}."}
    you.sharedVoyagezeppelin = {"{my} party took the zeppelin across the sea to {to}."}
    we.sharedVoyageboat = {"{name} and I took the boat across to {to}."}
    you.sharedVoyageboat = {"{my} party took the boat across to {to}."}
    -- Milestones.
    -- (lines a reader remembers: once in a book)
    for _, line in ipairs({"{my} party that {part} was the usual one, {me} and {name}.", "{my} party was whole again {later}, {name} and {me}.",
        "{dungeonE} {dungeonWas} a hard venture for a party of {our} experience. {pair} went in.", "{dungeonE} {dungeonWas} a hard venture for {us}. {pair} went inside.",
        "{dungeonE} {dungeonWas} a hard venture for two of {our} experience, and {name} and I went in.",
        "{dungeonE} {dungeonWas} meant for adventurers far stronger than {us}. {pair} went in anyway.",
        "{name} and I went out together, as we did most days.", "It came down to {boss}, {bossE}, and the two of us, and {shortRaw} fell.",
        "It came down to {boss}, {bossE}, and the pair of {us}, and {shortRaw} fell."}) do
        PB.oncePerBook[#PB.oncePerBook + 1] = line
    end
    we.days10 = {"That was the tenth day {name} and I had been out together."}
    you.days10 = {"That made ten days in the field for {my} party, {me} and {name}."}
    we.fires10 = {"It was the tenth fire {name} and I had shared."}
    you.fires10 = {"It was the tenth fire {my} party had shared."}
end

-- Battlegrounds together, with the result the own journal keeps (2026-11-06,
-- battlegrounds lane): one line for all the matches of one battleground that
-- day. Tokens: {pair} {I} {my} {name} and {what}, {times}, {wins}, {part}.
PB.shared.bgWon = {"{pair} went into {what} together, and won.", "{pair} fought in {what} together that {part}, and the match was won."}
PB.shared.bgLost = {"{pair} went into {what} together, and lost.", "{pair} fought in {what} together that {part}, and the other side won."}
PB.shared.bgDraw = {"{pair} fought in {what} together, and neither side won."}
PB.shared.bgSeries = {"{pair} fought {times} in {what} that {part} and won {wins} of them.", "{Times} {pair} went into {what} together, and {wins} of those were won."}
PB.shared.bgSeriesAll = {"{pair} fought {times} in {what} that {part} and won every one.", "{pair} went into {what} {times} together, and won each time."}
PB.shared.bgSeriesNone = {"{pair} fought {times} in {what} that {part}, and lost every one."}
PB.shared.bgFirstWin = {"It was the first battleground {I} had won, and {name} was in it.", "{name} was there for {my} first win in a battleground."}

-- The first day with someone close, said as company, not as a meeting ("Dahlia, my wife,
-- was at my side in Tirisfal Glades.", 2026-11-07).
if A.JournalTale and A.JournalTale.phrases then
    A.JournalTale.phrases.meetBond = {
        "{name}, {bondWord}, was at {my} side in {zoneE}.",
        "{I} set out in {zoneE} with {name}, {bondWord}, at {my} side.",
    }
end
