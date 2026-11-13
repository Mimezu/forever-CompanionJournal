local _, A = ...
-- Your own journal's storyteller: the words. First person, past tense, plain
-- like the old quest texts; places and foes carry the journal's markup
-- ({p:...}, quests {q:...}, people {n:...}). Tokens in braces are filled by
-- JournalSelfTale.lua. No colons, no words about the telling itself.
local W = {}
A.SelfWords = W
W.originBridge = {
    "Later, {we} {were} in {zoneD}.",
    "Later came {zoneD}. That was where this part of the journey began.",
    "After that came {zoneD}, where this part of the journey began.",
}
W.townBackdrop = {"{Town} was {lore}."}
W.questReturn = {
    "{We} returned to {thread}.",
    "{Our} work on {thread} continued.",
    "There was more to {thread}.",
}
W.questThread = {
    "{We} completed {quest}.",
    "{We} finished {quest}.",
}
W.questOthers = {
    "{We} also completed {quests}.",
    "Other work included {quests}.",
}

-- These encounters are observed by the recorder. The lore explains who was
-- there; it never invents a conversation, assignment, or reaction.
W.notableSeen = {"I saw {name} in {place}.", "In {place}, I saw {name}.", "{name} was there in {place}."}
W.notableSpoke = {"I spoke with {name} in {place}.", "In {place}, I spoke with {name}."}
W.notableNPCs = {
    ["Lady Sylvanas Windrunner"] = {"The Dark Lady ruled the Forsaken, free of the Lich King's will.", "Once the ranger-general of Quel'Thalas, she now led the Forsaken from beneath Lordaeron."},
    ["Thrall"] = {"The warchief led the Horde from Orgrimmar.", "The son of Durotan was both shaman and warchief of the Horde."},
    ["Cairne Bloodhoof"] = {"The high chieftain led the tauren from Thunder Bluff.", "The Bloodhoof chieftain had brought his people to a home on the heights of Mulgore."},
    ["Vol'jin"] = {"The Darkspear leader stood with Thrall's Horde.", "Sen'jin's son led the Darkspear trolls."},
    ["King Magni Bronzebeard"] = {"The eldest Bronzebeard brother ruled Ironforge.", "Magni held the throne beneath the mountain, king of the dwarves of Ironforge."},
    ["High Tinker Mekkatorque"] = {"The high tinker led the gnomes in exile after the fall of Gnomeregan."},
    ["Tyrande Whisperwind"] = {"The high priestess of Elune led the night elves from Darnassus."},
    ["Arch Druid Fandral Staghelm"] = {"The archdruid had led the planting of Teldrassil, the great tree that held Darnassus."},
    ["Lady Jaina Proudmoore"] = {"The ruler of Theramore had led her people across the sea to Kalimdor."},
    ["Highlord Bolvar Fordragon"] = {"The highlord guarded Stormwind and served as its regent in the king's absence."},
    ["King Anduin Wrynn"] = {"The young king held Stormwind's throne while his father was missing."},
}

-- Opening a chapter --------------------------------------------------------------
-- {When}: "The next day", "Three days later", "On Tuesday"; {part}: evening...
-- {zoneE}: the zone, sometimes described; {zoneD}: its plain name.
-- The first stretch is above your level.
W.openPeril = {
    "{When}, I was in {zoneD}, dangerous country for someone of my experience.",
    "{When}, my journey took me into {zoneD}, where the dangers outmatched me.",
}
-- A mine or cave, and what nearly killed or killed you there ({cave}, {foe}).
W.caveClose = {
    "I went down into {cave}, where {foe} nearly got me.",
    "In {cave}, {foe} nearly killed me.",
}
W.caveDeath = {
    "I went down into {cave}, and {foe} killed me there.",
    "{Foe} killed me deep in {cave}.",
}
W.openFirst = {
    "It began in {zoneE}.",
    "I began in {zoneE}.",
    "My first stop was {zoneE}.",
    "I started out in {zoneE}.",
    "That first day, I was in {zoneE}.",
    "I set out from {zoneE}.", -- (no first)
}
-- The day begins in a dungeon or raid ({dungeonD}; its story follows).
W.openDungeon = {
    "{When}, I made for {dungeonD}.",
    "{When}, I set out for {dungeonD}.",
    "{When}, the day's work lay in {dungeonD}.",
}
W.openDungeonFirst = {"It began with {dungeonD}.", "My first stop was {dungeonD}."}
-- A life's first page, by where your people begin (a journal from level 1).
W.origin = {
    Scourge = {
        "My second life began at {p:Deathknell}, among the Forsaken and the graves of Tirisfal.",
        "My second life began at {p:Deathknell}, where the crypts stood beneath the grey sky of Tirisfal.",
        "I began among the Forsaken at {p:Deathknell}, where undertakers tended the graves.",
        "My second life began in the grey light of {p:Deathknell}, in a land of graves and ruined homes.",
        "My second life began at {p:Deathknell}, among the graves, with the Forsaken waiting to put me to work.",
    },
    Orc = {
        "My road began in the {p:Valley of Trials}, under the red rocks of Durotar, where the young of the Horde prove themselves.",
        "I began in the {p:Valley of Trials}, where the Horde sends its young to be tested.",
        "I began at the Den in the {p:Valley of Trials}, where Gornek set the young orcs their first tasks.",
        "My road began in the {p:Valley of Trials}, where boars and scorpids roamed beneath the red cliffs.",
    },
    Troll = {
        "My road began in the {p:Valley of Trials}, where the Darkspear and the orcs train their young together.",
        -- (fixed: the Echo Isles cannot be seen from the valley)
        "I began in the {p:Valley of Trials}, with the Echo Isles of my people off the coast, not far to the east.",
        "The Darkspear had come to Durotar with Thrall, so I began where the orcs begin, in the {p:Valley of Trials}.",
        "I began in the {p:Valley of Trials}, a Darkspear among orcs, with boars and scorpids in the surrounding scrub.",
    },
    Tauren = {
        "I began at {p:Camp Narache}, high on the plains of Mulgore, where the young tauren go on their first hunt.",
        "My road began at {p:Camp Narache}, under a wide sky, with the plains of Mulgore below me.",
        "I began at {p:Camp Narache}, with plainstriders roaming the grass below.",
        "I began at {p:Camp Narache}, where Chief Hawkwind sets the young their first tasks.",
    },
    Human = {
        "I began at {p:Northshire Abbey}, where Stormwind trains its recruits.",
        "My road began at {p:Northshire Abbey}, in the green valley north of Goldshire.",
        "I began at {p:Northshire Abbey}, with kobold camps in the woods to the north.",
        "I began at {p:Northshire Abbey}, with the vineyards below and the wolves in the woods.",
    },
    Dwarf = {
        "I began in {p:Coldridge Valley}, in the snows below Ironforge, with the troggs at the door.",
        "My road began at {p:Anvilmar}, in the cold of {p:Coldridge Valley}.",
        "I began at {p:Anvilmar}, where the troggs had come up out of the ground and the Frostmane trolls held the hills.",
        "I began in {p:Coldridge Valley}, in the snow, a long walk through the tunnel from Kharanos.",
    },
    Gnome = {
        "I began in {p:Coldridge Valley}, far from lost Gnomeregan, among the dwarves who took my people in.",
        "My road began at {p:Anvilmar}, in the snow, with Gnomeregan lost behind me.",
        "My people had lost Gnomeregan, and I began where the dwarves took us in, in {p:Coldridge Valley}.",
        "I began at {p:Anvilmar}, a gnome in a dwarf's valley, with troggs in the hills and snow over everything.",
    },
    NightElf = {
        -- (fixed: "woke" belongs to the Forsaken)
        "I began in {p:Shadowglen}, at the foot of Aldrassil, high on the World Tree.",
        "My road began in {p:Shadowglen}, among the roots of Teldrassil.",
        "I began in {p:Shadowglen}, with young nightsabers in the forest and grells beyond the grove.",
    },
}
-- The origin town is named in the line above: its town line is left out.
W.originTowns = {Scourge = "Deathknell", Human = "Northshire Abbey"}
-- Forever's sky elves (LoreForever quest:92460 Coming of Age, npc:rorian-the-dayseeker; Lore.lua zoneStory Zephras Isle).
W.origin.Skyborne = {
    "My life began in Thendal Village, on Zephras Isle, where the Skyborne come of age.",
    "I began among the Skyborne of Thendal Village, on Zephras Isle, high above the world.",
}
W.open = {
    "{When}, I was in {zoneE}.",
    "{When}, I set out in {zoneE}.",
    "{When}, I went out into {zoneE}.",
    "{When}, I headed into {zoneE}.",
    "{When}, I made my way to {zoneE}.",
    "{When}, I went to {zoneE}.",
    "I spent {when} in {zoneD}.",
}
W.openStill = {
    "{When}, I was still in {zoneD}.",
    "{When}, I stayed on in {zoneD}.",
    "{When}, I picked up where I had left off, in {zoneD}.",
    "{When} I set out again in {zoneD}.",
    "{When}, I spent more time in {zoneD}.",
    "I spent {when} in {zoneD} as well.",
}
-- The first stretch of the day is a first visit.
W.openNew = {
    "{When}, for the first time, I saw {zoneLore}.",
    "{When}, I came to {zoneD} for the first time.",
    "{When}, I went somewhere new, {zoneLore}.",
}
W.openBack = {
    "{When}, I was back in {zoneD}.",
    "{When}, I returned to {zoneD}.",
}
-- Someone of your list, not seen for a long while ({names}, {ago}).
W.reunion = {
    "{When}, {names} and I were together again in {zoneD}.",
    "{When}, in {zoneD}, I travelled with {names} again.",
}
W.reunionJoined = {
    "In {zoneD}, {names} joined me again.",
    "In {zoneD}, I travelled with {names} again.",
}
-- With someone of your list from the start ({names}).
W.openWith = {
    "{When}, {names} and I set out in {zoneE}.",
    "{When}, I was in {zoneE} with {names}.",
    "{When}, I set out with {names} in {zoneE}.",
}
-- The same openings without the time phrase (2026-11-05). The chapter header
-- carries the date; after a chapter that opened on the day, the next one opens
-- on the place or the company. {part}: morning, afternoon, evening, night.
W.openBare = {
    "I was out in {zoneE}.",
    "I went out into {zoneE}.",
    "I spent the {part} in {zoneD}.",
    "{ZoneD} had me for the {part}.",
    "I took myself out to {zoneE}.",
}
W.openStillBare = {
    "I was still in {zoneD}.",
    "I had not finished with {zoneD}.",
    "{ZoneD} still had work for me.",
    "I stayed on in {zoneD}.",
    "I spent the {part} in {zoneD} as well.",
}
W.openStillWorkBare = {
    "There was more work for me in {zoneD}.",
    "I went back to work in {zoneD}.",
    "I picked up the work in {zoneD} where I had left it.",
}
W.openSameBare = {
    "I went back to {zoneD}, where I had left off.",
    "I was back in {zoneD}.",
    "{ZoneD} again, and I took up where I had left off.",
}
W.openNewBare = {
    "I came to {zoneD} for the first time.",
    "For the first time, I saw {zoneLore}.",
    "{ZoneD} was new to me.",
}
W.openBackBare = {
    "I was back in {zoneD}.",
    "I returned to {zoneD}.",
}
W.openWithBare = {
    "{names} and I set out in {zoneE}.",
    "I was in {zoneE} with {names}.",
    "{names} and I set out into {zoneE}.",
    "I set out with {names} in {zoneE}.",
    "{names} came along, and {zoneE} was where we went.",
    "{names} and I were out in {zoneE}.",
    "The {part} had me in {zoneE}, with {names}.",
}
W.openPerilBare = {
    "I was in {zoneD}, dangerous country for someone of my experience.",
    "My way took me into {zoneD}, where the dangers outmatched me.",
}
W.openDungeonBare = {
    "I made for {dungeonD}.",
    "The {part}'s work lay in {dungeonD}.",
    "I set out for {dungeonD}.",
}

-- Company -------------------------------------------------------------------------
W.joined = {
    "In {zoneD}, {names} joined me.",
    "{names} joined me in {zoneD}.",
    "{names} caught up with me in {zoneD}.",
}
-- Joining you on the way into a dungeon, in the same sentence ({names}).
W.dungeonWith = {
    fair = {"{names} joined me, and we went into {dungeonE}.", "With {names} beside me, I went into {dungeonE}."},
    daring = {"{names} joined me, and we tried {dungeonE}, a dangerous place for us.",
        "With {names} beside me, I went into {dungeonE}, where the foes outmatched us."},
    reckless = {"{names} joined me, and we went into {dungeonE}, far beyond our strength.",
        "With {names} beside me, I went into {dungeonE}, though its dangers far exceeded our experience."},
}
-- Before going into a dungeon together (the dungeon is named next).
W.joinedPlain = {
    "{names} joined me.",
    "{names} came along.",
    "{names} caught up with me.",
}
-- The zone was just named.
W.joinedThere = {
    "There, {names} joined me.",
    "{names} joined me there.",
    "{names} caught up with me there.",
}
W.withMost = {
    "{names} was with me.",
    "I travelled with {names}.",
    "{names} kept me company.",
}
W.withMostPlural = {
    "{names} were with me.",
    "I travelled with {names}.",
}

-- Moving on -----------------------------------------------------------------------
W.move = {
    "From there I went on to {zoneD}.",
    "Then I made my way to {zoneD}.",
    "Later I went on to {zoneD}.",
    "After that, I went on to {zoneD}.",
    "I moved on to {zoneD}.",
    "I left for {zoneD} after that.",
    "In time I went on to {zoneD}.",
}
-- Now and then (once in several chapters): the road.
W.moveRoad = {
    "After that, I took the road to {zoneD}.",
    "The road took me on to {zoneD}.",
    "From there the road led on to {zoneD}.",
    "I set out on the road to {zoneD}.",
}
W.moveShort = {
    "I passed through {zoneD}.",
    "I crossed {zoneD}.",
    "I went on through {zoneD} without stopping.",
}
-- New ground only crossed, nothing done in it (lane G, 2026-11-11): named, never described.
W.firstZoneGlimpse = {
    "I crossed {zoneD}, which was new to me.",
    "{zoneD} was new to me, and I did no more than cross it.",
    "My way took me across {zoneD}, where I had never been.",
    "I went on through {zoneD}, which I had never seen before.",
}
W.firstZone = {
    "I had never been to {zoneD} before.",
    "It was my first time in {zoneD}.",
    "I saw {zoneD} for the first time.",
    "From there I went on to {zoneD}, where I had never been.",
    "Then I came to {zoneD}, which I had never seen before.",
    "{zoneD} was new to me.",
}
W.firstZoneLore = {
    "It was my first time in {zoneLore}.",
    "I had never seen {zoneLore} before.",
}
W.perilous = {
    "{zoneD} was dangerous country for someone of my experience.",
    "The dangers of {zoneD} outmatched me then.",
    "I was still inexperienced for a place like {zoneD}.",
}
-- The same, when the zone was named just before.
W.perilousHere = {
    "It was dangerous country for someone of my experience.",
    "The dangers there outmatched me then.",
    "I was still inexperienced for such a place.",
}

-- The work of the day ------------------------------------------------------------
-- {count}: "eleven"; {Count}: "Eleven"; {quest}: one quest by name.
W.questsMany = {
    "{We} finished {count} quests there.",
    "{Count} quests kept {us} busy.",
    "{We} turned in {count} quests.",
    "{We} worked through {count} quests, one after another.",
    "{We} had {count} quests finished by then.",
    "The day's finished work included {count} quests.",
}
W.questsMore = {
    "{We} finished {count} quests there, {quest} among them.",
    "{We} turned in {count} quests, {quest} among them.",
    "{We} finished {count} quests, among them {quest}.",
    "{quest} was one of {count} quests {we} turned in.",
    "{We} turned in {count} quests, and {quest} was one of them.",
    "{quest} was among the {count} quests {we} finished.",
}
-- A formative stretch of work: the recorded sequence supplies the names;
-- only the remaining errands are compressed into a count.
W.questsChapter = {
    "{We} completed {quests}, along with {remaining}.",
    "The work included {quests}; {we} finished {remaining} as well.",
    "{We} finished {quests}, and {remaining} besides.",
}
-- Both endpoints are recorded adjacent stretches, so the connection does not
-- invent a road, mode of travel, or reason for leaving.
W.moveBetween = {
    "From {from}, {we} went on to {zoneD}.",
    "After {from} came {zoneD}.",
    "{We} left {from} for {zoneD}.",
}
W.questsFew = {
    "{We} finished {quests}.",
    "{We} turned in {quests}.",
    "{We} saw to {quests}.",
    "{We} took care of {quests}.",
    "{We} turned in {quests} while {we} {were} there.",
    "{We} finished {quests} there.",
    "{We} finished {quests}, one after the other.",
    "{quests} were among the work {we} finished.",
}
W.questOne = {
    "{We} finished {quest}.",
    "{We} turned in {quest}.",
    "{We} saw {quest} through.",
    "{We} took care of {quest} while {we} {were} there.",
    "{We} finished {quest} there.",
    "{quest} was done by then.",
}
W.idle = {
    "I spent {span} there.",
    "{Span} went by there.",
    "I stayed {span}.",
}

-- Honest work: mining, herbs, skinning, crafting --------------------------------
W.honestDay = {
    "Most of the day went to honest work.",
    "It was a day of honest work.",
    "I spent the day at my trades.",
}
W.gatherLead = {
    "I {work}.",
    "There, I {work}.",
}
-- Herbs, ores and hides by name ({names}: "Kingsblood and Liferoot"; {work}).
W.gatherNamed = {
    "I {work}, most of them {names}.",
    "I {work}, {names} for the most part.",
    "I {work}, and {names} made up most of the haul.",
    "I {work}, mostly {names}.",
}
-- Two kinds of work in one sentence: the names go with their kind ({kindNoun}: "veins", "herbs", "hides").
W.gatherNamedMixed = {
    "I {work}, and the {kindNoun} were mostly {names}.",
    "I {work}. The {kindNoun} were {names}, for the most part.",
}
-- What was gathered, by name, after the line that says how much ({names}).
W.gatherNames = {"Most of them were {names}.", "They were {names}, mostly.", "Most were {names}.", "{names} made up most of the haul."}
-- The end of a day: the hearthstone home ({place}: where it is bound).
W.hearthHome = {
    "At the end of it, I used my hearthstone and went back to {place}.",
    "When it was done, my hearthstone took me back to {place}.",
    "I used my hearthstone, and was back in {place} before the day was out.",
    "When the day was done, my hearthstone took me home to {place}.",
    "My hearthstone brought me back to {place} at the end of it.",
}
-- Moving on by hearthstone ({zoneD}: where it took you).
W.hearthMove = {
    "Then I used my hearthstone, and went back to {zoneD}.",
    "At the end of it, my hearthstone took me back to {zoneD}.",
    "My hearthstone took me back to {zoneD} after that.",
    "I used my hearthstone, and was in {zoneD} a moment later.",
    "From there my hearthstone brought me to {zoneD}.",
}
-- The fish, by name ({names}).
W.fishNames = {
    "Most of them were {names}.",
    "There were {names} among them.",
    "They were {names}, mostly.",
}
-- Fishing on a quiet day ({work}: "caught twelve fish").
W.quietFish = {
    "I stood by the water with a line out, and {work}.",
    "I spent a long while fishing, and {work}.",
    "I did nothing but fish for a while, and {work}.",
    "I found a place by the water, put a line in, and {work}.",
}
-- A day with no quests and no fights: the pace of it.
W.quietDay = {
    "It was a quiet stretch of the journey.",
    "The day passed quietly.",
    "It was a day without errands.",
}
-- Walking off the road with the gathering ({work}, {zoneShort}).
W.quietWander = {
    "Along the way, I {work}.",
    "I {work} while I was there.",
    "Part of my time went to gathering; I {work}.",
}
-- After the sunset, to close a quiet day.
W.quietClose = {
    "Nothing tried to kill me all day, and I stayed until the stars came out.",
    "I stayed until the light was gone, and for a while after.",
    "It was dark before I moved on.",
    "I did not hurry away.",
    "The first stars were out by the time I left.",
}
-- A sunset, by where it was watched (a line to follow the sunset).
W.sunsetAfter = {
    ["The Savage Coast"] = {"Behind me, the jungle went quiet, one bird at a time."},
    ["Booty Bay"] = {"The lamps came on in {p:Booty Bay}, one by one, behind me."},
    ["Jaguero Isle"] = {"The island went dark around me, and the sea stayed red a while longer."},
    ["Echo Isles"] = {"Across the water, the fires of the Echo Isles came on."},
    ["Sen'jin Village"] = {"The fires of {p:Sen'jin Village} came on behind me."},
    ["Ratchet"] = {"The goblins of {p:Ratchet} went on shouting on the docks, and the sea went dark."},
    plain = {"The sea went red, then grey, then dark.", "The light went out of the sky slowly, and I did not hurry it."},
}
W.craftMade = {
    "I worked at my {trade} and made {count} things, {made} among them.",
    "I sat down to my {trade} and made {count} things, among them {made}.",
}
W.craftOne = {
    "I made {made} at my {trade}.",
    "At my {trade}, I made {made}.",
}
W.craftPlain = {
    "I worked at my {trade} and made {count} things.",
    "I spent a while at my {trade}, and made {count} things.",
}

-- Underground ---------------------------------------------------------------------
-- {cave}: the mine or cave; {kind}: "mine" or "cave".
W.cave = {
    "I went down into {cave}.",
    "I made my way into {cave}.",
    "I went into {cave}.",
    "I went underground, into {cave}.",
    "I found my way into {cave}.",
    "I followed the tunnels into {cave}.",
}
W.caveDark = {
    "I went down into {cave} and spent a while in the dark.",
    "I spent a while underground, in {cave}.",
}

-- Dungeons ------------------------------------------------------------------------
-- {dungeonE}: named, sometimes described; {we}: "I" or "we".
W.dungeon = {
    fair = {
        "{We} went into {dungeonE}.",
        "{We} made for {dungeonE}.",
        "Then {we} went down into {dungeonE}.",
    },
    daring = {
        "{dungeonE} held foes stronger than {us}, and {we} went in anyway.",
        "{We} tried {dungeonE}, a dangerous place for {us}.",
    },
    reckless = {
        "{dungeonE} was far beyond {our} strength, and {we} went in all the same.",
        "{We} went into {dungeonE}, where the dangers far exceeded {our} experience.",
    },
    easy = {
        "{We} went into {dungeonE}, its dangers well within {our} strength by then.",
        "{dungeonE} held little danger for {us} any more.",
    },
}
W.dungeonFled = {
    "{We} went into {dungeonE}, beyond {our} strength, and {were} back outside soon after.",
    "The visit to {dungeonD} was brief. Its dangers were beyond {us} then.",
    "{We} went into {dungeonE} and came back out shortly afterward.",
}
-- Going back ({We}, {dungeonE}).
W.dungeonAgain = {
    "{We} went back into {dungeonE}.",
    "{We} {were} back in {dungeonE}.",
    "{We} went down into {dungeonE} a second time.",
    "{DungeonE} again, and {we} went in.",
}
-- A companion joined, and it was not the first run ({names} {nth}).
W.dungeonWithAgain = {
    "{names} and I went back into {dungeonE}, {our} {nth} run.",
    "With {names}, I went down into {dungeonE} for the {nth} time.",
    "{names} joined me, and we went back into {dungeonE}.",
}
W.dungeonRegular = {
    "Back {we} went into {dungeonE}, {our} {nth} time there.",
    "{We} went into {dungeonE} once more, the {nth} time.",
    "Once more {we} went into {dungeonE}, {our} {nth} run.",
}
-- The very first dungeon of your life, after it.
W.firstDungeonEnd = {
    "{dungeonD} was the first dungeon of my life, and I walked out of it on my feet.",
    "I had never been inside such a place before, and I came out again.",
    "It was my first time under a dungeon's roof, and I came out with the others.",
}
-- The first dungeon of your life, said with going in ("...into the Deadmines, the first dungeon of my life.").
W.firstDungeonEntry = {"the first dungeon of my life", "my first dungeon", "the first dungeon I had ever been in"}
-- The first dungeon of your life, when it killed you ({dungeonD}).
W.firstDungeonDied = {
    "{dungeonD} was my first dungeon, and it killed me once before we were done.",
    "It was the first dungeon of my life. It cost me a death, and I came out all the same.",
}
---------------------------------------------------------------------------
-- The same dungeon again (2026-11-06): each run told by its place in the
-- book's history of it. Tokens: {dungeonE} {DungeonE} {lord} {Lord} (the lord
-- of the place, from Lore), {lastKill} (the last boss killed this run),
-- {nth}, and {We} {we} {us} {our} {were}. Facts only: the record says which
-- bosses fell, who died and when the run ended; never why anyone left.
---------------------------------------------------------------------------
-- A return after a run that stopped short of the lord (said after the entry line).
W.dungeonReturnUnfinished = {
    "The last run there had stopped short of {lord}.",
    "The time before, {we} had come out with {lord} unbeaten.",
    "{Lord} had been left standing the time before.",
    "The first run had not gone as deep as {lord}.",
}
-- Then the lord fell (said after the kills and their consequence).
W.lordAtLast = {
    "This time the run reached {short}.",
    "What the earlier run had left standing, this one finished.",
    "{Short} did not outlast the second visit.",
    "The place had kept {short} from {us} once, and did not again.",
}
-- Back in a place where the last run killed me (after the entry line).
W.dungeonDiedBefore = {
    "I had died in there the time before.",
    "The last run through it had cost me a death.",
}
-- A place known well (the third run and after; alternates with W.dungeonRegular).
W.dungeonKnown = {
    "{We} went into {dungeonE} for the {nth} time.",
    "It was {our} {nth} run through {dungeonE}.",
    "{We} went down into {dungeonE} again, {our} {nth} time there.",
    "{We} knew the way through {dungeonE} by the {nth} run.",
}
-- The run ended before the lord: left (something was recorded outside it afterwards) or ended (the day ended there).
W.dungeonUnfinished = {
    left = {
        "{Lord} was still down there, and {we} were not.",
        "{We} left {lord} unbeaten at the bottom of it.",
        "{LastKill} was as far as {we} got that time.",
        "Past {lastKill}, {we} went no further, and left {lord} where {they} stood.",
    },
    ended = {
        "{We} did not go as deep as {lord} that time.",
        "The run ended before {lord}.",
        "{LastKill} was as far as {we} got.",
        "Past {lastKill}, {we} went no further that day.",
    },
}
-- A veteran of the place falling short of its lord.
W.dungeonShortVeteran = {
    "{We} had been to the bottom of {dungeonE} before. This time the run ended at {lastKill}.",
    "It was the first time {we} had left {dungeonE} without {short}'s fall.",
    "{We} had reached {lord} in {dungeonE} before, and this time {we} stopped at {lastKill}.",
    "For once {dungeonE} kept {short} from {us}.",
}
-- The lord beat us, and the run ended there.
W.dungeonFellShort = {
    "{Short} beat {us}, and the run ended there.",
    "{Short} stopped {us}, and {we} went no further.",
    "{Short} held the end of {dungeonE} against {us}.",
    "{Short} was the end of the run, and {we} were the ones beaten.",
}
-- Your part in it, once per visit.
W.role = {
    tank = {"I went in first and took the blows, so the others did not have to.", "I stood in front, where the blows fell."},
    healer = {"I stayed at the back and kept the others on their feet.", "My place was behind the others, keeping them alive."},
    damage = {"My part was to strike, and I struck.", "I left the healing to others and fought."},
}
-- Earned, now and then ({boss}, {weapon}: blade, spells, arrows...).
W.boast = {
    damage = {"Most of the blows that brought {boss} down were mine.", "{boss} fell mostly to my {weapon}.", "My {weapon} did most of the work on {boss}."},
    healer = {"Nobody fell while I watched over them.", "Not one of us died while I kept watch."},
    tank = {"{boss} never got past me.", "{boss} spent the whole fight on me, and never reached the others."},
}
W.killOne = {"{We} killed {boss}.", "{boss} fell.", "{We} brought down {boss}."}
W.killMany = {"{We} killed {bosses}.", "Inside, {we} brought down {bosses}.", "{bosses} fell, one after the other."}
-- Two bosses and more, told as beats around the one that mattered (round 3, 2026-11-11; the
-- shape from JournalEpisodes.ShapeKills): the ones before fell first ({Before}: "Rhahk'Zor,
-- Sneed and three more"; the Next pools when a kill was told already in the run), then came the
-- goal ({boss} with its epithet, who he is; the Goal pools say why he matters: a quest's boss;
-- the Lord pools for the lord of the place with no quest about him), and the kill; the ones
-- after are a tail ({after}, {him}/{her}).
-- (round 4: no "down" in these, the entry and the retry have it)
W.bossLeadOne = {"{Before} fell first.", "{Before} came first, and fell."}
W.bossLeadMany = {"{Before} fell first, one after another.", "{Before} came first, and fell one after another."}
W.bossLeadOneNext = {"{Before} fell next.", "Next came {before}, and fell."}
-- (lane G8: after a death or a wipe was told, the ones before the goal: neither "first" nor "next")
W.bossLeadOneAfter = {"{Before} fell.", "{We} fought past {before}."}
W.bossLeadManyAfter = {"{Before} fell, one after another.", "{We} fought past {before}, one after another."}
W.bossLeadManyNext = {"{Before} fell next, one after another.", "Next {we} fought past {before}."}
W.bossGoal = {
    "Then came {boss}, the one {we} had come for, and {we} killed {him}.",
    "Then came {boss}, the one {we} had come for. {We} killed {him}.",
}
W.bossGoalFirst = {
    "{We} came to {boss} first, the one {we} had come for, and killed {him}.",
    "{We} came straight to {boss}, the one {we} had come for, and killed {him}.",
}
W.bossLord = {
    "Then came {boss}, and {we} killed {him}.",
    "Then came {boss}. {We} killed {him}.",
}
W.bossLordFirst = {
    "{We} came to {boss} first, and killed {him}.",
    "{Boss} came first, and {we} killed {him}.",
}
W.bossTail = {"After {him}, {we} killed {after} as well.", "{After} fell after {him}."}
-- (the same beats for a boss the data gives no pronoun for, round 7: no "him" and no guess;
-- the tail's {him} is then the boss's title or short name)
W.bossGoalPlain = {
    "Then came {boss}, the one {we} had come for, and fell.",
    "Then came {boss}, the one {we} had come for. That fight {we} won.",
}
W.bossGoalFirstPlain = {
    "{We} came to {boss} first, the one {we} had come for, and won that fight.",
    "{We} came straight to {boss}, the one {we} had come for, and won.",
}
W.bossLordPlain = {
    "Then came {boss}, and fell.",
    "Then came {boss}. That fight {we} won.",
}
W.bossLordFirstPlain = {
    "{We} came to {boss} first, and won that fight.",
    "{Boss} came first, and fell.",
}
-- Going in with the company named ({names}: the ones the record knows; {count} when more went).
-- ({namesI}: "Bryn, Grak and I"; {names}: "Bryn and Grak", or "Bryn, Grak and one more" when the
-- record counted more than it named: never a count the names contradict, round 4)
W.dungeonNames = {
    "{namesI} went into {dungeonE}.",
    "I went into {dungeonE} with {names}.",
    "With {names}, I went into {dungeonE}.",
}
W.dungeonNamesDown = {
    "{namesI} went down into {dungeonE}.",
    "I went down into {dungeonE} with {names}.",
    "With {names}, I went down into {dungeonE}.",
}
-- The first dungeon of my life, as its own sentence after the entry (the second pool when
-- the chapter has said "first" twice already).
W.firstDungeonLine = {"It was my first dungeon.", "It was the first dungeon of my life."}
-- (folded into the entry after the place, round 4: "...into Ragefire Chasm, my first dungeon, a lava cave...")
W.firstDungeonFold = {"my first dungeon", "the first dungeon of my life"}
-- After the run, when earned (once a book each, never the last line of a chapter).
W.runEarned = {
    secondTry = {"It had taken {us} two tries, and {we} had done it.", "The first try had cost {us}, and the second paid for it.",
        "{We} had been beaten once down there, and not the second time."},
    firstClean = {"I walked out of it on my feet.", "I came out of it standing, with everything I had gone in with."},
}
-- The run's losses that were not at a boss, in one sentence after the bosses that led to the
-- goal (lane G, 2026-11-11). {foes}: "Deviate shamblers" / "a Deviate shambler and a Deviate
-- guardian"; {count}: "once", "four times"; {raisers}: "Mirelle and Faelyn"; {rcount}; {names}
-- and {tally} for the party ("Tarok twice", "once each", "four times between them").
W.runLosses = {
    meWalked = {"{Foes} got me {count} between the fights, and each time I walked back as a ghost.",
        "{Foes} killed me {count} along the way, and I came back from the graveyard on my own feet each time."},
    meRaised = {"{Foes} got me {count} between the fights, and {raisers} brought me back each time.",
        "{Foes} killed me {count} along the way, and each time {raisers} raised me."},
    meRaisedSome = {"{Foes} got me {count} between the fights. {Raisers} raised me {rcount}, and the rest of the time I walked back as a ghost.",
        "{Foes} killed me {count} along the way. {Raisers} picked me up {rcount}, and otherwise I walked back as a ghost."},
    party = {"{Names} fell {tally} along the way.", "{Names} went down {tally} between the fights."},
    partyToo = {"{Names} fell {tally} as well.", "{Names} went down {tally} too."},
    -- (lane G8: said after the kill, so as a step back: "We killed him. He had taken Faelyn down first.")
    costly = {"{Boss} had taken {names} down first.", "{Names} had fallen to {boss} first.", "{He} had taken {names} down first."},
    -- (for a boss the data gives no pronoun for)
    costlyNamed = {"{Names} had fallen to {boss} first.", "{Boss} had taken {names} down first."},
    costlyMany = {"{Names} had fallen to {bosses} in turn before they fell.", "{Bosses} had each taken {names} down first."},
}
-- A level reached in the run or with its turn-ins, folded into the run's end ({level}).
W.runLevel = {"I came out of it at level {level}.", "The run took me to level {level}.", "Level {level} came out of it with me."}
-- A level reached inside the run, at the kill it came with (round 5; {boss}, {level}).
W.runLevelAt = {"Level {level} came with {boss}.", "{Boss} took me to level {level}.", "I reached level {level} on {boss}."}
-- The odds, once at the entry (round 5): the quest about the run against my level ({n} levels).
W.runOdds = {
    above = {"The work was {n} levels above {us}.", "It was a task meant for someone {n} levels above {me}."},
    below = {"{We} {were} well past it by then.", "It was work {we} had outgrown."},
}
-- (the same as a clause on the line before it, round 4: "..., and the run took me to level 17.")
W.runLevelClause = {"the run took me to level {level}", "I came out of it level {level}", "I was level {level} by then"}
-- Going in with company: the count from the record ({count}: "five").
W.dungeonParty = {
    "The {count} of us went into {dungeonE}.",
    "Then the {count} of us went into {dungeonE}.",
    "There were {count} of us going into {dungeonE}.",
}
W.dungeonPartyDown = {
    "The {count} of us went down into {dungeonE}.",
    "Then the {count} of us went down into {dungeonE}.",
    "There were {count} of us going down into {dungeonE}.",
}
-- The run's second try, after a wipe (the deaths were just told): a beat of the story
-- ({try}: "second", "third"; the Well pools when nobody died after it).
W.dungeonBackDown = {
    "{We} went back down for a {try} try.",
    "Then {we} picked {ourselves} up and went back down.",
    "{We} went back down and tried again.",
}
W.dungeonBackDownWell = {
    "{We} went back down, and the {try} try went better.",
    "Back down {we} went, and this time nobody fell.",
    "{We} picked {ourselves} up and went back down, and the {try} try held.",
}
W.dungeonBackIn = {
    "{We} went back in for a {try} try.",
    "Then {we} picked {ourselves} up and went back in.",
    "{We} went back in and tried again.",
}
W.dungeonBackInWell = {
    "{We} went back in, and the {try} try went better.",
    "Back in {we} went, and this time nobody fell.",
}
W.wipe = {"{boss} was too much for {us}.", "{boss} beat {us}.", "{We} lost the fight against {boss}."}

-- Danger ---------------------------------------------------------------------------
-- {foe}: "a Kobold Tunneler" or a name; {Foe}: capitalized.
W.death = {
    foe = {
        "{Foe} killed me.",
        "I fell to {foe}.",
        "{Foe} was the end of me.",
        "{Foe} got the better of me.",
        "I died fighting {foe}.",
        "It was {foe} that killed me.",
    },
    FALLING = {
        "I fell to my death.",
        "A fall killed me.",
        "I fell, and it was a long way down.",
        "I misjudged a drop and died of it.",
        "I took a fall I did not survive.",
    },
    DROWNING = {
        "I drowned.",
        "The water took me.",
        "I stayed under too long, and drowned.",
        "I ran out of breath under the water.",
    },
    LAVA = {"I died in the lava.", "The lava took me.", "The lava killed me. It was as hot as it looked."},
    FIRE = {"I burned to death.", "The fire killed me.", "I stayed in the fire too long, and it killed me."},
    FATIGUE = {"I swam too far out and never made it back.", "I swam out further than I could swim back, and died in the water."},
    SLIME = {"The slime killed me.", "I died in the slime. There are better ways to go."},
    plain = {"I died.", "I did not survive it.", "I was killed."},
}
W.deathIn = {"{Foe} killed me {inSub}.", "I died {inSub}, at the hands of {foe}."}
-- (the killer fell later in the same run: no second mention in the kill roll)
W.deathInAvenged = {"{Foe} killed me {inSub}, and died for it before the run was over.", "{Foe} killed me {inSub}, and did not outlive the run."}
W.deaths = {"I died {count} times.", "I died {count} times before it was done."}
-- The same bad end twice in one day ({count}: "twice", "three times").
W.deathsSame = {
    FALLING = {
        "I fell to my death {count}, and the second time I should have known better.",
        "{Count}, I misjudged a drop and paid for it with my life.",
        "I fell to my death {count} before the day was out.",
    },
    DROWNING = {
        "I drowned {count} before the day was out.",
        "{Count}, I stayed under too long and drowned.",
    },
}
-- The world itself was the danger ({funny}: said after the misadventures).
W.misadventure = {
    "Nothing with a sword had anything to do with it.",
    "It was not my most graceful day.",
    "The land did more harm to me that day than any enemy.",
    "{zoneD} did not need monsters to kill me.",
    "None of it was an enemy's doing.",
}
-- The first death of your life (a journal from before level 10).
W.firstDeath = {
    "It was the first time I died. I walked back from the graveyard as a spirit, and found my body where it fell.",
    "It was my first death. The world went grey, and I walked back through it to find my body.",
    "It was the first time I died, and the first time I saw the grey world that waits after it.",
    "I had not died before that day. I walked back as a spirit, through a world gone grey, and found my body.",
}
W.firstDeathRez = {
    "It was the first time I died.",
    "It was the first time I died, and I did not have to walk back.",
    "I had never died before.",
}
W.firstDeathScourge = {
    "It was my first death since I rose.",
    "I had died once before, long ago. This time I walked back from the graveyard.",
    "It was my first death since I rose. I walked back from the graveyard and found my body where it fell.",
    "I had been dead before, in Lordaeron. This time it only lasted as long as the walk back.",
}
-- A world boss you died to, and saw fall ({what}).
W.worldbossDied = {
    "{what} killed me before the fight was over, but I was there when the {kind} fell.",
    "{what} fell. I was lying dead by then, but I was there to see it.",
    "{what} killed me, and fell soon after to the others.",
}
W.rez = {"{by} brought me back.", "{by} raised me.", "{by} brought me back from death."}
W.close = {
    foe = {
        "{Foe} nearly got me.",
        "{Foe} nearly killed me.",
        "I barely got away from {foe}.",
        "{Foe} came close to killing me.",
        "I got away from {foe} with very little life left.",
        "{Foe} had me near death before it was over.",
    },
    FALLING = {
        "I almost fell to my death.",
        "A fall nearly killed me.",
        "I fell a long way and only just lived.",
        "I landed badly, and very nearly did not get up.",
    },
    DROWNING = {
        "I nearly drowned.",
        "I came up for air just in time.",
        "I stayed under too long and only just made it up.",
        "The water very nearly had me.",
    },
    LAVA = {"I got out of the lava just in time.", "The lava very nearly killed me."},
    FATIGUE = {"I swam out too far and only just made it back.", "I swam until I was nearly spent, and only just reached the shore."},
    plain = {
        "I nearly died.",
        "I came close to dying.",
        "I was very nearly killed.",
        "I came within a breath of dying.",
    },
}
W.closeIn = {"In {sub}, {foe} nearly got me.", "{Foe} nearly killed me in {sub}."}

-- Firsts -----------------------------------------------------------------------------
W.tram = {
    "I rode the {p:Deeprun Tram} for the first time.",
    "I rode the {p:Deeprun Tram} under the mountain, a first for me.",
    "The {p:Deeprun Tram} carried me under the earth, which was new to me.",
    "For the first time, I took the {p:Deeprun Tram} under the mountain.",
    "I took the {p:Deeprun Tram} for the first time, deep under the earth.",
}
W.flight = {
    "I took my first flight.",
    "I took a flight, my first.",
    "For the first time, I flew.",
    "I flew for the first time, over the country I had walked.",
}

-- Voyages: crossing to another continent ({to}: Kalimdor, the Eastern Kingdoms...).
W.voyage = {
    zeppelin = {"I took the zeppelin across the sea to {to}.", "The zeppelin carried me over the sea to {to}.", "I rode a zeppelin to {to}."},
    boat = {"I took the boat across the sea to {to}.", "I sailed to {to}.", "A ship carried me across the sea to {to}."},
    portal = {"A portal took me to {to}.", "I stepped through a portal to {to}."},
    hearth = {"My hearthstone took me back to {to}.", "I used my hearthstone, and was back in {to}."},
}
-- A day that begins with the crossing ({When}).
W.voyageOpen = {
    zeppelin = {"{When}, the zeppelin carried me over the sea to {to}.", "{When}, I rode the zeppelin across the sea to {to}."},
    boat = {"{When}, I took the boat across the sea to {to}.", "{When}, a ship carried me over the sea to {to}."},
    portal = {"{When}, a portal took me to {to}."},
    hearth = {"{When}, my hearthstone took me back to {to}."},
}
-- The very first time: a zeppelin, a sea crossing, a continent.
W.voyageFirst = {
    zeppelin = {
        "It was my first time on a zeppelin.",
        "I had never ridden a zeppelin before.",
        "The zeppelin was new to me, and so was the sea below it.",
        "It was my first time aboard a goblin zeppelin.",
        "The zeppelin was goblin-made, and it got me there all the same.",
    },
    boat = {
        "It was my first time on a ship.",
        "I had never been aboard a ship before.",
        "The ship was new to me, and so was the open sea around it.",
        "It was my first voyage by ship.",
        "I stood on the deck of a ship for the first time.",
    },
}
W.continentFirst = {
    "I set foot in {to} for the first time.",
    "It was my first time in {to}.",
    "All of {to} was new to me.",
    "I had not set foot in {to} before.",
}

-- Milestones of a life ({what}: a place, a raid, a boss, an item or a set).
W.milestone2 = {
    landmark = {
        "For the first time, I came to {what}.",
        "I stood at {what} for the first time.",
        "I reached {what} for the first time.",
        "I saw {what} for the first time, and stopped to look.",
    },
    -- ENGINE: when the day OPENS on this raid, skip openDungeonFirst and let this line open
    -- (round 6 named Molten Core three times in three sentences).
    raid = {
        "For the first time, I went into {what} with a great company of adventurers.",
        "I joined my first raid, and we went into {what}.",
        "{what} was my first raid, and there were many of us.",
        "My first raid took me into {what}, one of a whole company.",
    },
    worldboss = {
        "I was one of the many who brought down {what}.",
        "{what} fell, and I was there to see it.",
        "{what} fell to a crowd of us, and I was in the crowd.",
        "I was there when {what} came down, one of many.",
    },
    -- An honorable kill means you fought and one of them died, not that you won alone.
    pvp = {
        "In {what}, I fought the other side for the first time, and one of them fell.",
        "My first victory against the other side came in {what}.",
        "In {what}, one of the other side fell in a fight I was part of, the first time that had happened.",
    },
    epic = {
        "{what} was mine, the finest thing I had ever carried.",
        "I took the {what} from the spoils, the best I had ever owned.",
        "{what} came into my hands, finer than anything I had carried before.",
        "I had the {what} now, and nothing else I owned came close to it.",
    },
    legendary = {
        "{what} was mine. There are few like it in the world.",
        "{what} was mine, one of a handful in all the world.",
        "I held {what} in my own hands.",
    },
    -- DELETE "After all of it, {what} was mine." It read as raid loot when Benediction is a quest item.
    famous = {
        "{what} was mine at last.",
        "I had {what} at last.",
        "{what} was in my hands at last.",
    },
    tier = {
        "I put on my first piece of {what}.",
        "The first piece of {what} was mine.",
        "I had the first piece of {what}.",
        "I wore my first piece of {what}.",
    },
    setfull = {
        "The last piece of {what} was mine, and I wore all of it.",
        "For the first time, I wore the whole of {what}.",
        "With the last piece, I wore all of {what} at once.",
    },
    mount = {
        "For the first time, I rode my own mount.",
        "I had a mount of my own at last.",
        "I rode my own mount for the first time, and the country went by faster.",
    },
    epicmount = {
        "My new mount was faster than anything I had ever ridden.",
        "I rode my new mount for the first time, and it left my old one behind.",
        "I rode out on my new mount, faster than any I had owned.",
    },
    sunset = {
        "I watched the sun go down over the sea at {what}.",
        "At {what}, I stopped to watch the sun go down.",
        "At {what}, I sat down on the sand and watched the sun go into the sea.",
        "I was at {what} when the sun went down, and I stayed to watch it.",
        "The sun went down over the water at {what}, and I watched it go.",
    },
}
-- Blackrock Mountain the first time, told with what it is.
W.landmarkLore = {
    ["Blackrock Mountain"] = {"For the first time, I came to {p:Blackrock Mountain}, where the Dark Irons and the black dragons make their home."},
    ["The Dark Portal"] = {"I stood before the {p:Dark Portal} for the first time.",
        "For the first time, I stood before the {p:Dark Portal}, where the orcs first came into this world."},
    ["Darkmoon Faire"] = {"For the first time, I walked into the {p:Darkmoon Faire}, all tents and lights and strange games.",
        "The {p:Darkmoon Faire} had come, and I went in for the first time, among the tents and the music."},
    ["Gurubashi Arena"] = {"I stood in the {p:Gurubashi Arena} for the first time, where the old trolls once made men fight.",
        "For the first time, I came to the {p:Gurubashi Arena}, and looked down into its pit."},
    ["The Great Lift"] = {"For the first time, I rode the {p:Great Lift} down from the Barrens into Thousand Needles.",
        "The {p:Great Lift} carried me down the cliff for the first time, and Thousand Needles opened below me."},
    ["Mirage Raceway"] = {"I came to the {p:Mirage Raceway} for the first time, where the goblins and gnomes race across the salt flats."},
    ["Nesingwary's Expedition"] = {"For the first time, I came to {p:Nesingwary's Expedition}, the hunters' camp in the jungle.",
        "I found {p:Nesingwary's Expedition}, where old Hemet and his hunters kept their trophies."},
}

-- Levels -----------------------------------------------------------------------------
W.level = {
    "I reached level {level}.",
    "I made level {level}.",
    "I climbed to level {level}.",
    "I went up to level {level}.",
    "By the end of the day I was level {level}.",
    "Somewhere along the way I reached level {level}.",
}
W.levels = {
    "I went from level {from} to {level}.",
    "I climbed from level {from} to {level}.",
    "I started the day at level {from} and ended it at {level}.",
    "By the end of the day I had gone from level {from} to {level}.",
    "I was level {from} when I set out and level {level} when I stopped.",
}
W.milestone = {
    [10] = {"I reached level ten that day, and the first roads were behind me.",
        "Level ten came that day. The trainers had more to teach me now.",
        "I made level ten, the first number of any weight."},
    [20] = {"I reached level twenty, a third of the way to the top.",
        "Level twenty came that day, and with it the roads of the middle country.",
        "I made level twenty. The middle country was open to me now."},
    [30] = {"I reached level thirty, halfway to the top.",
        "Level thirty came that day, and half the climb was done.",
        "I made level thirty. The second half of the climb began."},
    [40] = {"I reached level forty, the level at which an adventurer may ride.",
        "Level forty came that day, and with it the right to a mount of my own.",
        "I made level forty. From there, the road is ridden.",
        -- (the day the mount itself is told, the level leaves riding to it)
        "I reached level forty, with twenty levels left to climb.",
        "Level forty came that day, two thirds of the way to the top."},
    [50] = {"I reached level fifty. Ten more stood between me and the top.",
        "Level fifty came that day, with ten left to climb.",
        "I made level fifty. The top came into sight."},
    [60] = {"I reached level sixty, as high as any adventurer climbs.",
        "I reached level sixty. There was no sixty-one to climb to.",
        "That day I reached level sixty, the last level there is."},
}
-- Level sixty, looking back to the recorded beginning. The quest and death
-- scenes already tell the intervening work; a second tally obscures that ending.
W.lookBack = {
    "I had begun in {origin}, {since} earlier.",
    "{since} before, I had been in {origin}.",
    "I had started from {origin}, {since} earlier.",
    "It had been {since} since I set out from {origin}.",
}
W.lookBackPeople = {"{names} had been with me for much of it.", "I had not done it alone. {names} had been there for much of the way."}

-- Rest ---------------------------------------------------------------------------------
W.inn = {
    "{We} rested at the inn in {place}.",
    "{We} stopped for the night in {place}.",
    "{We} took a room in {place}.",
    "{We} rested a while at the inn in {place}.",
    "{We} found the inn in {place} and rested there.",
    "The inn in {place} gave {us} a place to rest a while.",
}
W.campfire = {
    "I stopped by a campfire.",
    "I sat by a campfire for a while.",
    "I rested by a campfire.",
    "I found a campfire and sat by it a while.",
    "I sat down by a campfire and rested.",
    "There was a campfire, and I sat by it for a while.",
}
W.campfireWe = {
    "We stopped by a campfire.",
    "We sat by a campfire for a while.",
    "We rested by a campfire.",
    "We found a campfire and sat by it a while.",
    "We sat down by a campfire and rested.",
    "There was a campfire, and we sat by it for a while.",
}

-- Closing lines ------------------------------------------------------------------------
W.late = {"It was past midnight when I stopped.", "I stopped well after midnight.", "Midnight had come and gone when I stopped."}
W.long = {"All told, it was {span}.", "It came to {span}, all told."}

-- Moments of a life (the research list) ---------------------------------------------
-- The first of the other side you saw ({side}: "Alliance"; {aRace}: "a night elf";
-- {class}: "rogue"; {zoneD}).
W.foeSeen = {
    "In {zoneD}, I saw one of the {side} for the first time, {aRace} {class}.",
    "It was in {zoneD} that I first saw one of the {side}, {aRace} {class}.",
    "My first sight of the {side} came in {zoneD}, {aRace} {class}.",
    "In {zoneD} I crossed paths with one of the {side} for the first time, {aRace} {class}.",
    "In {zoneD} I saw {aRace} {class} of the {side}, the first of them I had ever seen.",
}
W.foeSeenHere = {
    "There I saw one of the {side} for the first time, {aRace} {class}.",
    "It was there that I first saw one of the {side}, {aRace} {class}.",
    "One of the {side} was there, {aRace} {class}, the first I had seen.",
}
-- Killed by one of the other side ({aRace}, {class}, {side}); again the same day.
W.deathPvp = {
    "{ARace} {class} of the {side} killed me.",
    "One of the {side}, {aRace} {class}, caught me and killed me.",
    "I died to {aRace} {class} of the {side}.",
    "{ARace} {class} of the {side} got the better of me.",
    "I fell to {aRace} {class}, one of the {side}.",
}
W.deathPvpAgain = {
    "When I came back to my body, the {side} were still there, and I died again.",
    "I went back for my body, and the {side} killed me again.",
    "The {side} killed me a second time that day.",
    "I came back to my body, and died again before I could get away.",
}
-- Killed by something far below your level ({foe}, {Foe}, {inZone}: "in Durotar" or "there").
W.deathShameful = {
    "{Foe} killed me {inZone}. At my level, that takes some doing.",
    "{Foe} killed me, and the less said about that, the better.",
    "Of all things, it was {foe} that killed me.",
    "{Foe} killed me {inZone}, and I would rather not say more.",
    "I died to {foe} {inZone}, at my level.",
}
-- Killed by the guards of a town ({place}).
W.guardDeath = {
    "I went too near the guards of {place}, and they made short work of me.",
    "The guards of {place} killed me, as guards will.",
    "The guards of {place} cut me down.",
    "The guards at {place} did their job, and I died of it.",
}
-- A rez from someone not of your list ({by}).
W.rezStranger = {
    "{by}, a stranger, brought me back.",
    "A stranger named {by} brought me back.",
    "{by} brought me back, though we had never met.",
    "{by}, whom I had never met, brought me back from death.",
    "{by} stopped to bring me back, though we had never met.",
}
-- Named foes everyone has a story about: said after they kill you or nearly do.
W.infamous = {
    ["Hogger"] = {
        "Half of Elwynn had tangled with him at one time or another, and now I had too.",
        "Marshal Dughan had put a price on his head long before.",
    },
    ["Stitches"] = {"He came down the road into Darkshire, and I was in his way."},
    ["Mor'Ladim"] = {"He still walked the graveyard on Raven Hill, as the people of Darkshire said."},
    ["Bhag'thera"] = {"She had long eluded Nesingwary's whole party, and I was no luckier."},
    ["Old Murk-Eye"] = {"He was older and meaner than any other murloc on that coast."},
    -- ENGINE: only when this is the first death of the book ("the first thing to beat me").
    ["Sarkoth"] = {"He was only a scorpid, but he was the first thing to beat me."},
    ["King Bangalash"] = {"He had sent Nesingwary himself back to camp more than once."},
    ["Sin'Dall"] = {"Nesingwary's camp had tracked her for weeks."},
    ["Sharptalon"] = {"It had preyed on the peons of Splintertree for a long time."},
    ["Tethis"] = {"Even Nesingwary had failed to kill it."},
    ["Mazzranache"] = {"It had been killing on the plains of Mulgore, and the tauren wanted it dead."},
    ["Gath'Ilzogg"] = {"Lakeshire had a price on his head, and I understood why."},
}
-- A battleground, the first time ({what}; {mySide}).
W.battleground = {
    "I fought in {what} for the first time, with the {mySide} around me.",
    "For the first time, I answered the call to {what}.",
    "I went into {what} for the first time, and fought for the {mySide}.",
    "I answered the call to {what} and fought beside the {mySide}.", -- (no first)
}
W.bgAgain = {"I fought in {what} again.", "Back to {what}, with the {mySide}."}
-- Class milestones ({family}: a hunter's first pet, "boar").
W.classFirst = {
    felsteed = {"I called my felsteed for the first time, a horse of shadow and fire.", "For the first time, a felsteed of my own came when I called.",
        "My felsteed came when I called, a horse of shadow and fire."},
    dreadsteed = {"I called my dreadsteed for the first time. Few warlocks ever earn one.", "The dreadsteed was mine, and it came when I called."},
    warhorse = {"For the first time, I called my warhorse, the Light's gift to those who serve it.", "I rode my own warhorse for the first time.",
        "My warhorse came when I called, the Light's gift to those who serve it."},
    charger = {"I called my charger for the first time. It had taken a long time to earn.", "The charger was mine at last."},
    tame = {"I learned to tame the beasts of the wild.", "The hunters taught me how to tame a beast.", "I learned how a hunter makes a beast its own."},
    pet = {"I tamed my first beast, a {family}, and it followed me from then on.", "A {family} became my first companion of the wild.",
        "I tamed a {family}, and it came with me."},
    petPlain = {"I tamed my first beast, and it followed me from then on.", "I tamed a beast, and it came with me."},
    bear = {"The druids taught me to take the shape of a bear.", "For the first time, I took the shape of a bear.", "I learned the shape of the bear."},
    aquatic = {"I learned the form of the sea lion, and swam as fast as any fish.", "The druids taught me to swim as the sea lions do.",
        "I learned to take the form of a sea lion."},
    travel = {"I learned the form of the cheetah, and the ground went by quicker after that.", "For the first time, I ran as a cheetah.",
        "I learned to run as a cheetah runs."},
    cat = {"I learned to take the form of a cat.", "For the first time, I hunted as a cat hunts.", "The druids taught me the shape of the cat."},
    ghostwolf = {"The spirits taught me to run as a ghost wolf.", "For the first time, I ran as a ghost wolf.", "I learned to take the form of a ghost wolf."},
    defensive = {"I learned to fight behind my shield, in the defensive stance.", "I learned the defensive stance.", "My trainer taught me the defensive stance."},
    berserker = {"I learned the berserker stance.", "I learned to fight as a berserker, with no thought for my own guard.", "My trainer taught me the berserker stance."},
    poisons = {"I learned the use of poisons.", "I learned how to make poisons, and how to use them.", "I learned to coat my blades with poison."},
    voidwalker = {"I bound my first voidwalker, and it did as I told it.", "For the first time, a voidwalker answered my call.",
        "I bound a voidwalker to my service."},
    succubus = {"I bound a succubus to my service.", "For the first time, I summoned a succubus.", "A succubus answered my call."},
    felhunter = {"I bound a felhunter, a hound that feeds on magic.", "For the first time, I summoned a felhunter.", "A felhunter answered my call."},
    summon = {"I learned the ritual of summoning.", "I learned to call others to my side by ritual."},
    portal = {"I opened my first portal, and others could follow me through it.", "I learned to open portals to the great cities."},
    teleport = {"I learned to take myself home by magic.", "For the first time, I went home by magic, in the space of a breath.",
        "I learned to go home by magic, in the space of a breath."},
}
-- The first time you brought someone back ({who}).
W.rezOther = {
    "For the first time, I brought someone back from death. It was {who}.",
    "I raised {who} from death, the first I ever brought back.",
    "I brought {who} back from death, the first time I had raised anyone.",
}
W.rezOtherPlain = {"For the first time, I brought someone back from death."}
-- The first thing worth keeping ({what}: a blue item).
W.rare = {
    "{what} was the first thing I found worth keeping.",
    "I found {what}, the first thing of any worth I had owned.",
    "{what} was mine, the first thing I owned that was not plain.",
    "I came by {what}, and kept it.", -- (no first)
}
-- A guild ({guild}: its name, in angle brackets).
W.guild = {
    "I joined a guild, {guild}.",
    "{guild} took me in.",
    "I joined {guild}, and its name went under mine.",
    "I became one of {guild}.",
    "I took the tabard of {guild}.", -- ENGINE: only when a guild tabard was equipped
}
-- A new home, where your hearthstone takes you ({place}).
W.home = {
    "I made the inn at {place} my home.",
    "I made {place} my home, and set my hearthstone there.",
    "From then on, my hearthstone took me back to {place}.",
    "I bound my hearthstone at the inn in {place}.",
}
-- The first sight of a capital (by city; your side or neutral ground).
W.capitalFirst = {
    ["Orgrimmar"] = {
        "For the first time, I walked through the gates of {p:Orgrimmar}, into the red canyon where Thrall built his city.",
        "I saw {p:Orgrimmar} for the first time. The drums were beating, and the Horde was everywhere.",
        "I came into {p:Orgrimmar} through the great gate, and the Valley of Strength opened up in front of me.",
        "I walked into {p:Orgrimmar} past the spiked walls and the grunts at the gate.", -- (no first)
    },
    ["Undercity"] = {
        "For the first time, I went down into the {p:Undercity}, a city of the dead under the ruins of the old capital.",
        "I rode the lift down into the {p:Undercity} for the first time, and the green light of the canals came up to meet me.",
        "I walked through the ruined throne room of Lordaeron and rode the lift down into the {p:Undercity}.", -- (no first)
        "I went down into the {p:Undercity}, where the Forsaken had made a city of the old crypts.", -- (no first)
    },
    ["Thunder Bluff"] = {
        "For the first time, I rode the lift up to {p:Thunder Bluff}, and saw all of Mulgore below me.",
        "I came to {p:Thunder Bluff} for the first time. The wind never stopped up there, and the totems stood taller than the tents.",
        "I rode the lift up to {p:Thunder Bluff}, and all of Mulgore lay below me.", -- (no first)
        "I came up to {p:Thunder Bluff}, where the tauren had built on the tops of the mesas and joined them with rope bridges.", -- (no first)
    },
    ["Stormwind City"] = {
        "For the first time, I crossed the bridge into {p:Stormwind}, under its white walls.",
        "I saw {p:Stormwind} for the first time, its canals and its towers, and the cathedral over them all.",
        "I came through the gate of {p:Stormwind} and down the Valley of Heroes, between the statues.", -- (no first)
        "I crossed the bridge into {p:Stormwind}, under its white walls, and into the Valley of Heroes.", -- (no first)
    },
    ["Ironforge"] = {
        "For the first time, I went into {p:Ironforge}, and heard the Great Forge before I saw it.",
        "I came to {p:Ironforge} for the first time, a city cut into the heart of the mountain.",
        "I went into {p:Ironforge}, a city cut into the heart of the mountain, with the Great Forge at its centre.", -- (no first)
        "I walked through the great gate of {p:Ironforge}, out of the snow and into the mountain.", -- (no first)
    },
    ["Darnassus"] = {
        "For the first time, I came to {p:Darnassus}, high in the branches of Teldrassil.",
        "I came up into {p:Darnassus}, high in the branches of Teldrassil, where the night elves keep their temple.", -- (no first)
        "I came to {p:Darnassus}, on the great tree the druids had planted after the war.", -- (no first)
    },
}

-- Titles ----------------------------------------------------------------------------
W.titles = {
    honest = {"Honest Work", "At My Trades", "A Working Day"},
    death = {"A Hard Day", "Hard Lessons", "A Bad Day", "Back on My Feet"},
    fall = {"A Bad Fall", "A Long Way Down"},
    close = {"A Near Thing", "A Narrow Escape"},
    firstDeath = {"The First Death", "Death and Back"},
    origin = {"The Beginning", "Where It Began", "First Steps"},
    reunion = {"{names} Again", "An Old Friend"},
    quiet = {"A Quiet Day", "No Hurry"},
    misadventure = {"A Clumsy Day", "Misadventures", "A Long Way Down"},
    tram = {"The Tram"},
    raid = {"The First Raid", "{what}"},
    worldboss = {"{what}"},
    pvp = {"First Blood", "The Other Side"},
    epic = {"{what}", "Spoils"},
    legendary = {"{what}"},
    famous = {"{what}"},
    tier = {"{what}"},
    setfull = {"{what}", "The Whole Set"},
    mount = {"My Own Mount", "In the Saddle"},
    epicmount = {"A Faster Mount", "In the Saddle"},
    sunset = {"Sunset", "The Sun Goes Down"},
    landmark = {"{what}"},
    firstDungeon = {"Into the Dark", "The First Descent"},
    voyage = {"Across the Sea", "Over the Water", "The Crossing"},
    continent = {"{to}", "A New Land"},
    flight = {"First Flight", "Wings"},
    firstZone = {"{zoneD}", "New Country"},
    home = {"Home", "{zoneD}"},
    with = {"With {names}", "{names}"},
    level = {"Level {level}"},
    foeSeen = {"The Other Side", "The Enemy"},
    pvpDeath = {"Ambushed", "Caught Alone"},
    guard = {"The Guards"},
    battleground = {"{what}"},
    class = {"A New Power", "Something New"},
    rezOther = {"Back from Death", "The First I Raised"},
    rare = {"Something Worth Keeping", "A First Find"},
    guild = {"{guild}", "A Guild"},
    newHome = {"A New Home", "Hearth and Home"},
    capital = {"{city}"},
}

-- Towns and cities ----------------------------------------------------------------------
-- side: whose town it is ("Horde", "Alliance", or "neutral"); home: the races
-- it is home to; lore: what the place is (after its name); homeLines: how
-- someone from there sees it. The tone follows who you are: home, the same
-- side, neutral ground, or the other side.
W.towns = {
    -- Horde
    ["Orgrimmar"] = {side = "Horde", home = {"Orc", "Troll"}, name = "{p:Orgrimmar}",
        lore = {"the city Thrall built in the red canyon", "the orc capital"},
        homeLines = {"I walked the Valley of Strength in {p:Orgrimmar} again.", "I came home to {p:Orgrimmar}, and the drums were beating."}},
    ["Razor Hill"] = {side = "Horde", home = {"Orc", "Troll"}, name = "{p:Razor Hill}",
        lore = {"the orc town in Durotar"},
        homeLines = {"I passed the barracks at {p:Razor Hill}, as I had many times."}},
    ["Sen'jin Village"] = {side = "Horde", home = {"Troll"}, name = "{p:Sen'jin Village}",
        lore = {"where the Darkspear keep their huts by the sea"},
        homeLines = {"The huts of {p:Sen'jin Village} stood by the sea, as always."}},
    ["Undercity"] = {side = "Horde", home = {"Scourge"}, name = "the {p:Undercity}",
        lore = {"beneath the ruins of Lordaeron", "where the Banshee Queen held court"},
        homeLines = {"I went down into the {p:Undercity}, among my own.", "I went home to the {p:Undercity}, under the ruins of Lordaeron."}},
    ["Brill"] = {side = "Horde", home = {"Scourge"}, name = "{p:Brill}",
        lore = {"the Forsaken town in the glades", "with its Gallows' End Tavern"},
        homeLines = {"{p:Brill} was quiet, as the dead are.", "I stopped at the Gallows' End Tavern in {p:Brill}."}},
    ["Deathknell"] = {side = "Horde", home = {"Scourge"}, name = "{p:Deathknell}",
        lore = {"where the Forsaken rise from their graves"},
        homeLines = {"I walked through {p:Deathknell}, where I had first risen."}},
    ["The Sepulcher"] = {side = "Horde", home = {"Scourge"}, name = "the {p:Sepulcher}",
        lore = {"the Forsaken outpost in the pines"}},
    ["Tarren Mill"] = {side = "Horde", home = {"Scourge"}, name = "{p:Tarren Mill}",
        lore = {"the Forsaken hold above {p:Southshore}"}},
    ["Thunder Bluff"] = {side = "Horde", home = {"Tauren"}, name = "{p:Thunder Bluff}",
        lore = {"on its mesas above the plains", "where the tauren raise their totems"},
        homeLines = {"I rode the lifts up to {p:Thunder Bluff}.", "The wind was up on the mesas of {p:Thunder Bluff}, as it always is."}},
    ["Bloodhoof Village"] = {side = "Horde", home = {"Tauren"}, name = "{p:Bloodhoof Village}",
        lore = {"where the tauren of Mulgore gather"},
        homeLines = {"{p:Bloodhoof Village} was as I had left it."}},
    ["The Crossroads"] = {side = "Horde", name = "the {p:Crossroads}",
        lore = {"the Horde fort at the heart of the Barrens"}},
    ["Camp Taurajo"] = {side = "Horde", home = {"Tauren"}, name = "{p:Camp Taurajo}",
        lore = {"the tauren camp in the southern Barrens"}},
    ["Sun Rock Retreat"] = {side = "Horde", name = "{p:Sun Rock Retreat}", lore = {"high in the Stonetalon peaks"}},
    ["Splintertree Post"] = {side = "Horde", name = "{p:Splintertree Post}", lore = {"the Horde camp among the Ashenvale woodcutters"}},
    ["Freewind Post"] = {side = "Horde", name = "{p:Freewind Post}", lore = {"on its mesa above Thousand Needles"}},
    ["Shadowprey Village"] = {side = "Horde", name = "{p:Shadowprey Village}", lore = {"on the Desolace coast"}},
    ["Camp Mojache"] = {side = "Horde", name = "{p:Camp Mojache}", lore = {"the tauren camp in Feralas"}},
    ["Hammerfall"] = {side = "Horde", home = {"Orc"}, name = "{p:Hammerfall}", lore = {"the orc hold in the Arathi Highlands", "where the orcs keep watch on the eastern hills"}},
    ["Kargath"] = {side = "Horde", name = "{p:Kargath}", lore = {"the Horde outpost in the Badlands"}},
    ["Grom'gol Base Camp"] = {side = "Horde", name = "{p:Grom'gol}", lore = {"the Horde camp on the jungle coast"}},
    ["Stonard"] = {side = "Horde", name = "{p:Stonard}", lore = {"the orc fortress in the Swamp of Sorrows"}},
    ["Revantusk Village"] = {side = "Horde", home = {"Troll"}, name = "{p:Revantusk Village}", lore = {"where the Revantusk trolls watch the coast"}},
    ["Brackenwall Village"] = {side = "Horde", name = "{p:Brackenwall Village}", lore = {"in the marsh of Dustwallow"}},
    ["Bloodvenom Post"] = {side = "Horde", name = "{p:Bloodvenom Post}", lore = {"the Horde camp in the fel-sick woods"}},
    ["Valormok"] = {side = "Horde", name = "{p:Valormok}", lore = {"the Horde camp in Azshara"}},
    -- Alliance
    ["Stormwind City"] = {side = "Alliance", home = {"Human"}, name = "{p:Stormwind}",
        lore = {"behind its white walls", "the human capital"},
        homeLines = {"I crossed the canals of {p:Stormwind} again.", "I came home to {p:Stormwind}, bells and all."}},
    ["Goldshire"] = {side = "Alliance", home = {"Human"}, name = "{p:Goldshire}",
        lore = {"with its Lion's Pride Inn", "the village outside Stormwind"},
        homeLines = {"I stopped at the Lion's Pride in {p:Goldshire}, as I often had.", "{p:Goldshire} was busy, as it always is."}},
    ["Northshire Abbey"] = {side = "Alliance", home = {"Human"}, name = "{p:Northshire}",
        lore = {"where new recruits of Stormwind train"},
        homeLines = {"I walked past {p:Northshire Abbey}, where I had begun."}},
    ["Sentinel Hill"] = {side = "Alliance", name = "{p:Sentinel Hill}", lore = {"where the People's Militia kept watch over Westfall"}},
    ["Lakeshire"] = {side = "Alliance", home = {"Human"}, name = "{p:Lakeshire}", lore = {"by the lake in Redridge"}},
    ["Darkshire"] = {side = "Alliance", home = {"Human"}, name = "{p:Darkshire}", lore = {"the town of the Night Watch in Duskwood"}},
    ["Southshore"] = {side = "Alliance", home = {"Human"}, name = "{p:Southshore}", lore = {"the town on the Hillsbrad coast"}},
    ["Refuge Pointe"] = {side = "Alliance", name = "{p:Refuge Pointe}", lore = {"the last Alliance hold in Arathi"}},
    ["Menethil Harbor"] = {side = "Alliance", name = "{p:Menethil Harbor}", lore = {"the port on the Wetlands coast"}},
    ["Ironforge"] = {side = "Alliance", home = {"Dwarf", "Gnome"}, name = "{p:Ironforge}",
        lore = {"the dwarven city inside the mountain", "where the Great Forge burned"},
        homeLines = {"The Great Forge was burning in {p:Ironforge}, as it always is.", "I was back inside the mountain, in {p:Ironforge}."}},
    ["Kharanos"] = {side = "Alliance", home = {"Dwarf", "Gnome"}, name = "{p:Kharanos}",
        lore = {"with its Thunderbrew Distillery"},
        homeLines = {"I stopped at the Thunderbrew Distillery in {p:Kharanos}."}},
    ["Thelsamar"] = {side = "Alliance", home = {"Dwarf"}, name = "{p:Thelsamar}", lore = {"the dwarf town in Loch Modan"}},
    ["Darnassus"] = {side = "Alliance", home = {"NightElf"}, name = "{p:Darnassus}",
        lore = {"high in the boughs of Teldrassil", "the night elf capital"},
        homeLines = {"I walked under the trees of {p:Darnassus} again."}},
    ["Dolanaar"] = {side = "Alliance", home = {"NightElf"}, name = "{p:Dolanaar}", lore = {"the night elf village on Teldrassil"}},
    ["Auberdine"] = {side = "Alliance", home = {"NightElf"}, name = "{p:Auberdine}", lore = {"the night elf port on Darkshore"}},
    ["Astranaar"] = {side = "Alliance", home = {"NightElf"}, name = "{p:Astranaar}", lore = {"on its island in the Ashenvale lake"}},
    ["Stonetalon Peak"] = {side = "Alliance", name = "{p:Stonetalon Peak}", lore = {"the druid hold high in Stonetalon"}},
    ["Nijel's Point"] = {side = "Alliance", name = "{p:Nijel's Point}", lore = {"the Alliance camp in the Desolace hills"}},
    ["Feathermoon Stronghold"] = {side = "Alliance", name = "{p:Feathermoon}", lore = {"the night elf fortress off the Feralas coast"}},
    ["Theramore Isle"] = {side = "Alliance", name = "{p:Theramore}", lore = {"Jaina Proudmoore's city on the marsh"}},
    ["Aerie Peak"] = {side = "Alliance", name = "{p:Aerie Peak}", lore = {"where the Wildhammer keep their gryphons"}},
    ["Morgan's Vigil"] = {side = "Alliance", name = "{p:Morgan's Vigil}", lore = {"the Alliance camp in the Burning Steppes"}},
    ["Chillwind Camp"] = {side = "Alliance", name = "{p:Chillwind Camp}", lore = {"the Alliance camp in the Western Plaguelands"}},
    ["Talonbranch Glade"] = {side = "Alliance", name = "{p:Talonbranch Glade}", lore = {"the night elf camp in Felwood"}},
    -- Neutral ground
    ["Booty Bay"] = {side = "neutral", name = "{p:Booty Bay}", lore = {"where the goblins take everyone's coin", "the goblin port behind the jaws of a great shark",
        "the Steamwheedle port at the southern tip of Stranglethorn", "where the ships put in from Ratchet"}},
    ["Ratchet"] = {side = "neutral", name = "{p:Ratchet}", lore = {"the goblin port on the Barrens coast", "where the ship from Booty Bay puts in", "the Steamwheedle town on the Merchant Coast"}},
    ["Gadgetzan"] = {side = "neutral", name = "{p:Gadgetzan}", lore = {"the goblin town in the Tanaris sands"}},
    ["Everlook"] = {side = "neutral", name = "{p:Everlook}", lore = {"the goblin town in the snows of Winterspring"}},
    ["Cenarion Hold"] = {side = "neutral", name = "{p:Cenarion Hold}", lore = {"the druids' fort against the silithid"}},
    ["Light's Hope Chapel"] = {side = "neutral", name = "{p:Light's Hope Chapel}", lore = {"where the Argent Dawn held out against the Scourge"}},
    ["Thorium Point"] = {side = "neutral", name = "{p:Thorium Point}", lore = {"where the Thorium Brotherhood kept its camp"}},
    ["Marshal's Refuge"] = {side = "neutral", name = "{p:Marshal's Refuge}", lore = {"the camp at the heart of Un'Goro"}},
}
-- How a town is seen: {town} its name, {lore} what it is.
W.townHome = {"I was back in {town}, {lore}.", "I was home again in {town}, {lore}."}
-- Home ground, but the first time the journal sees it.
W.townHomeFirst = {
    "I stopped in {town}, {lore}.",
    "I came to {town}, {lore}.",
    "I reached {town}, {lore}.",
    "I stopped a while in {town}, {lore}.",
    "I made my way to {town}, {lore}.",
}
W.townAlly = {
    "I stopped in {town}, {lore}.",
    "I passed through {town}, {lore}.",
    "I came through {town}, {lore}.",
    "My way took me through {town}, {lore}.",
    "I stopped a while in {town}, {lore}.",
    "I looked in at {town}, {lore}.",
}
W.townNeutral = {
    "I stopped in {town}, {lore}.",
    "I made my way to {town}, {lore}.",
    "I came into {town}, {lore}.",
    "I spent a while in {town}, {lore}.",
    "Horde and Alliance alike passed through {town}, {lore}, and so did I.",
    "I came down into {town}, {lore}.",
    "I looked in at {town}, {lore}.",
}
W.townFoe = {
    "I kept clear of {town}, a town of the {side}.","I passed through {town}, a town of the {side}.", "{Town} belonged to the {side}."}
W.townFirst = {"For the first time, I came to {town}, {lore}.", "I saw {town} for the first time, {lore}."}

-- Round 6: the writer pools, new ones and sub-pools set after their tables.
W.openStillWork = {
    "{When}, I went back to work in {zoneD}.",
    "{When}, {zoneD} had more work for me.",
    "{When}, there was still work for me in {zoneD}.",
    "{When}, the work in {zoneD} went on.",
}
W.openSame = {
    "{When}, I went back to {zoneD}, where I had left off.",
    "{When}, I was back in {zoneD}.",
    "{When}, I returned to {zoneD}.",
}
W.townAllyWe = {
    "We stopped in {town}, {lore}.",
    "We passed through {town}, {lore}.",
    "We came through {town}, {lore}.",
    "We stopped a while in {town}, {lore}.",
}
W.townNeutralWe = {
    "We stopped in {town}, {lore}.",
    "We made our way to {town}, {lore}.",
    "We spent a while in {town}, {lore}.",
    "Horde and Alliance alike passed through {town}, {lore}, and so did we.",
    "We came into {town}, {lore}.",
}
W.questsMoreRepeat = {
    "{We} turned in {count} quests, {quest} more than once.",
    "{We} finished {count} quests, and went back to {quest} more than once.",
    "{quest} brought {us} back more than once, among {count} quests in all.",
}
W.quietDayOne = {
    "One errand marked an otherwise quiet day.",
    "I finished a single quest that day.",
    "One quest was all I turned in that day.",
}
W.sunsetAfter.plain = {
    "The sea went red, then grey, then dark.",
    "The light went out of the sky slowly, and I did not hurry it.",
    "The waves kept coming in after the light was gone.",
    "Out on the water, the light stayed longest.",
    "The first stars came out over the water.",
    "The water went gold, and then it went dark.",
}
W.sunsetAfter["Menethil Harbor"] = W.sunsetAfter["Menethil Harbor"] or {"The ships at anchor in {p:Menethil Harbor} went dark one by one."}
W.sunsetAfter["Auberdine"] = {"The lamps came on along the shore behind me, one by one."}
W.sunsetAfter["Southshore"] = W.sunsetAfter["Southshore"] or {"The lights of {p:Southshore} came on down by the water."}
W.boast.healer = {
    "More of the healing came from me than from anyone else there.",
    "I did more of the healing than anyone else in the company.",
}
W.titles.firstDungeon = {"The First Dungeon", "Past the Gate"}
W.titles.unfinished = {"Short of the Bottom", "Not All the Way", "Half Done"}
W.titles.fellShort = {"Beaten at the Last", "The Last Door", "Stopped Short"}
W.voyageFirstLand = {
    zeppelin = {
        "For the first time, I rode a zeppelin, and it carried me over the sea to {to}, where I had never been.",
        "The zeppelin carried me over the sea to {to}. I had never ridden one before, and I had never seen {to}.",
        "I took the zeppelin across the sea to {to}, my first time on a zeppelin and my first sight of that land.",
    },
    boat = {
        "For the first time, I went aboard a ship, and it carried me across the sea to {to}, where I had never been.",
        "A ship carried me across the sea to {to}. I had never sailed before, and I had never seen {to}.",
        "I took the boat across the sea to {to}, my first time on a ship and my first sight of that land.",
    },
}

-- Round 6: the writer pools, new ones and sub-pools set after their tables.
W.milestone2.pvpHere = {
    "There I fought the other side for the first time, and one of them fell.",
    "My first victory against the other side came there.",
}

-- Small wonders (CRITIQUE6 section 6) ------------------------------------------------
-- The first snow ({zoneD}); not for dwarves and gnomes, who were born to it.
W.snowFirst = {
    "Snow lay on the ground in {zoneD}, the first I had ever seen.",
    "I left tracks in the snow of {zoneD}, the first snow I had ever walked in.",
    "It was the first time I had walked in snow.",
    "I had never seen snow before.",
    "I walked through snow that day, and left tracks behind me.", -- (no first)
}
-- A rare creature seen ({what}, {zoneD}).
W.rareBeast = {
    "In {zoneD} I came on {what}, which few people ever see.",
    "{what} crossed my path in {zoneD}, a rare sight.",
    "There I came on {what}, which few people ever see.",
    "I saw {what} in {zoneD}, and few people have.",
    "{what} crossed my path that day, seldom seen by anyone.", -- (no first, no place)
}
-- The first sale at the auction house ({what}).
W.aucSale = {
    "Somebody bought my {what} at the auction house. I never learned who.",
    "My {what} sold at the auction house, the first thing I ever sold there.",
    "I sold {what} at the auction house, my first sale there.",
    "The auction house sold my {what}, and the coin came to me by mail.", -- (no first)
}
-- A long swim ({place}).
W.swim = {
    "I swam across {place} rather than walk around it.",
    "It was a long swim in {place}, and I made it without drowning.",
    "I swam a long way in the waters of {place}.",
    "I took to the water in {place} and swam a long way.",
    "I swam a long way out into {place}.",
}
-- A flight by night ({to}).
W.nightFlight = {
    "I flew to {to} after dark, with the lights of the towns below me.",
    "It was night when I took the flight to {to}, and the land went by dark beneath me.",
    "I flew to {to} by night, and saw little of the way.",
    "I took the flight to {to} at night, and came down in the dark.",
    "It was dark when I flew to {to}.",
}
-- A night at the inn: the day's last word, when the next day began after a long sleep ({place}).
W.sleepInn = {
    "That night I took a room at the inn in {place} and slept there.",
    "The innkeeper at {place} had a bed for me that night.",
    "I slept at the inn in {place}.",
    "I spent the night at the inn in {place}.",
    "I ended the day at the inn in {place}, and slept there.",
}
-- The long walk back as a ghost ({span}).
W.ghostWalk = {
    "It was a long walk back from the graveyard, and I made all of it as a spirit.",
    "My spirit walked {span} to get back to my body.",
    "The graveyard was a long way from where I fell, and I walked every step of it as a ghost.",
    "It took {span} to walk back to my body.",
    "I spent {span} as a spirit, walking back to where I fell.",
}
-- Fishing from a dock ({place}, {work}: "caught twelve fish").
W.fishAt = {
    "I fished from the dock at {place}, and {work}.",
    "I cast a line at {place}, and {work}.",
    "I spent a while fishing at {place}, and {work}.",
    "I stood on the dock at {place} with a line in the water, and {work}.",
    "At {place}, I put a line in the water for a while, and {work}.",
}
W.titles.snow = {"First Snow", "Snow"}
W.titles.auction = {"The Auction House", "A First Sale"}

-- Round 7: the writer pools, new ones and sub-pools set after their tables.
W.oncePerBook = {
    "Horde and Alliance alike passed through {town}, {lore}, and so did I.",
    "Horde and Alliance alike passed through {town}, {lore}, and so did we.",
    "I came to {town}, {lore}, and my own people were there.",
    "Between {quests}, {we} had enough to do.",
    "{We} finished {quests}, one after the other.",
    "Somebody bought my {what} at the auction house. I never learned who.",
    "It was a long swim in {place}, and I made it without drowning.",
    "The guards of {place} killed me, as guards will.",
    "Of all things, it was {foe} that killed me.",
    "{Foe} killed me {inZone}. At my level, that takes some doing.",
    "The lava killed me. It was as hot as it looked.",
    "I died in the slime. There are better ways to go.",
    "It was my second death, if the first one counts.",
    "The zeppelin was goblin-made, and it got me there all the same.",
    "{We} took care of {quest} while {we} {were} there.",
}
W.dungeon.fair = {
    "{We} went into {dungeonE}.",
    "{We} made for {dungeonE}.",
    "Then {we} went into {dungeonE}.",
    "{We} set out for {dungeonE}.",
}
W.dungeonDown = {
    "{We} went down into {dungeonE}.",
    "Then {we} went down into {dungeonE}.",
    "{We} made {our} way down into {dungeonE}.",
}
W.homeHere = {
    "I made the inn there my home.",
    "I bound my hearthstone at the inn there.",
    "From then on, my hearthstone took me back there.",
}
W.firstDeathLate = {
    "I had come a long way without dying once, and {foe} ended that.",
    "It was my first death, after all that way.",
    "I had never died before, not once in all those levels.",
}
W.milestone2.sunset = {
    "I watched the sun go down over the sea at {what}.",
    "At {what}, I stopped to watch the sun go down.",
    "At {what}, I sat down on the sand and watched the sun go into the sea.",
    "I was at {what} when the sun went down, and I stayed to watch it.",
    "The sun went down over the water at {what}, and I watched it go.",
}
W.milestone2.sunsetEast = {
    "At {what}, I watched the light go off the water as the sun went down behind me.",
    "I was at {what} when the sun went down behind the land, and the sea in front of me went grey.",
    "At {what}, I stopped to watch the evening come in over the sea.",
}

-- Round 8 engine hooks (first drafts) ------------------------------------------------
-- Someone met for the first time ({names}: "Tarok, a tauren warrior").
W.joinedNew = {
    "{names}, joined me.",
    "I fell in with {names}.",
    "{names}, came along with me.",
    "I met {names}, and we went on together.",
}
W.joinedNewMany = {
    "{names}, joined me.",
    "I fell in with {names}.",
    "I met {names}, and we went on together.",
}
-- Back out of a dungeon into its zone ({zoneD}, {We}).
W.leaveDungeon = {
    "{We} came back out into {zoneD}.",
    "{We} came out of the dark into {zoneD} again.",
    "Then {we} {were} back out in {zoneD}.",
}
-- Ore smelted at the forge ({count}, {made}).
W.smelt = W.smelt or {
    "I smelted the ore into {count} bars of {made}.",
    "At the forge, I smelted {count} bars of {made}.",
}
W.titles.classBy = W.titles.classBy or {
    pet = {"A Beast of My Own", "The Hunter's Companion"},
    tame = {"Taming the Wild"},
    bear = {"The Bear's Shape", "Lunaclaw"},
    aquatic = {"The Sea Lion's Shape"},
    travel = {"The Cheetah's Shape"},
    cat = {"The Cat's Shape"},
    warhorse = {"The Warhorse"},
    charger = {"The Charger"},
    felsteed = {"The Felsteed"},
    dreadsteed = {"The Dreadsteed"},
    voidwalker = {"The Voidwalker"},
    ghostwolf = {"The Ghost Wolf"},
}
-- Someone close, the first time the book names them ({names}, {bond}: "my wife").
W.joinedBond = W.joinedBond or {
    "{names}, {bond}, was with me.",
    "I had {names}, {bond}, at my side.",
}
-- Killed again and again by the other side ({count}, {side}).
W.deathPvpMany = W.deathPvpMany or {
    "The {side} kept coming back, and I died {count} times before it was over.",
    "In all, the {side} killed me {count} times that day.",
}
-- A night at the inn, when the place was just said.
W.sleepInnHere = W.sleepInnHere or {
    "I took a room there for the night.",
    "I slept at the inn there that night.",
}
-- Back after a month or more away from the road ({ago}: "four months").

W.titles.returned = W.titles.returned or {"Back on the Road", "After Long Away"}

-- Round 8: the writer pools.
W.origin.Troll = {
    "I began in the {p:Valley of Trials}, where the Darkspear and the orcs train their young together.",
    "The witch doctor Zalazane held the Echo Isles, the old home of my people, so I began on the mainland, in the {p:Valley of Trials}.",
    "The Darkspear had come to Durotar with Thrall, so I began where the orcs begin, in the {p:Valley of Trials}.",
    "I began in the {p:Valley of Trials}, a Darkspear among orcs, with boars and scorpids in the surrounding scrub.",
}
W.origin.Tauren = {
    "I began at {p:Camp Narache}, high on the plains of Mulgore, where the young tauren go on their first hunt.",
    "I began at {p:Camp Narache}, where the young tauren start on the Rites of the Earthmother.",
    "I began at {p:Camp Narache}, with plainstriders roaming the grass below.",
    "I began at {p:Camp Narache}, where Chief Hawkwind sets the young their first tasks.",
    "I began at {p:Camp Narache}, under a wide sky, with the plains of Mulgore below me.",
}
W.origin.Gnome = {
    "My people had lost Gnomeregan, and I began where the dwarves took us in, in {p:Coldridge Valley}.",
    "I began in {p:Coldridge Valley}, far from lost Gnomeregan, among the dwarves who took my people in.",
    "I began at {p:Anvilmar}, a gnome in a dwarf's valley, with troggs in the hills and snow over everything.",
    "The troggs and the poison had taken Gnomeregan, so I began among the dwarves, at {p:Anvilmar}.",
    "I began at {p:Anvilmar}, in the snow, with Gnomeregan lost behind me.",
}
W.origin.NightElf = {
    "I began in {p:Shadowglen}, at the foot of Aldrassil, high on the World Tree.",
    "I began in {p:Shadowglen}, among the roots of Teldrassil.",
    "I began in {p:Shadowglen}, with young nightsabers in the forest and grells beyond the grove.",
    "I began in {p:Shadowglen}, where Conservator Ilthalaine kept the balance of the forest and gave the young their first tasks.",
    "I began in {p:Shadowglen}, on the new World Tree the druids had grown out of the sea.",
}
W.origin.Dwarf = {
    "I began in {p:Coldridge Valley}, in the snows below Ironforge, with the troggs at the door.",
    "I began at {p:Anvilmar}, in the cold of {p:Coldridge Valley}.",
    "I began at {p:Anvilmar}, where the troggs had come up out of the ground and the Frostmane trolls held the hills.",
    "I began in {p:Coldridge Valley}, in the snow, a long walk through the tunnel from Kharanos.",
}
W.openFirstLate = {
    Dwarf = {"I was level {level}, and a long way from Ironforge, when I set out from {zoneE}.",
        "I set out from {zoneE} at level {level}, with Ironforge far behind me."},
    Gnome = {"I was level {level}, and a long way from Ironforge and lost Gnomeregan, when I set out from {zoneE}."},
    Human = {"I was level {level}, and a long way from Stormwind, when I set out from {zoneE}."},
    NightElf = {"I was level {level}, and far from Teldrassil, when I set out from {zoneE}."},
    Orc = {"I was level {level}, and a long way from Orgrimmar, when I set out from {zoneE}."},
    Troll = {"I was level {level}, and far from the huts of Sen'jin, when I set out from {zoneE}."},
    Tauren = {"I was level {level}, and a long way from Mulgore, when I set out from {zoneE}."},
    Scourge = {"I was level {level}, and a long way from the graves of Deathknell, when I set out from {zoneE}."},
    other = {"I was already level {level} when I set out from {zoneE}.", "I set out from {zoneE} at level {level}."},
}
W.openWithNew = {
    "{When}, I fell in with {names}, in {zoneD}.",
    "{When}, in {zoneD}, I fell in with {names}.",
    "{When}, I set out in {zoneE} with {names}, whom I had not met before.",
    "{When}, {names}, joined me in {zoneD}.",
}
W.joinedNewUs = {
    "{names}, joined {known} and me.",
    "{known} and I fell in with {names}.",
    "{names}, made one more in our party.",
}
W.partyDeath = {
    foe = {
        "{Foe} killed {names}.",
        "{names} died fighting {foe}.",
    },
    -- (the killer was then killed in the same fight: one sentence)
    foeCostly = {
        "{Foe} killed {names}, and died all the same.",
        "{Foe} killed {names}, but did not live out the fight.",
    },
    plain = {"{names} died there.", "{We} lost {names} there."},
}
W.quietDayOneWe = {
    "{With} and I saw to one errand on an otherwise quiet day.",
    "{With} and I finished a single quest that day.",
    "There was one errand amid the quieter hours I shared with {with}.",
}
W.quietDayWe = {
    "I shared a quiet stretch with {with}.",
    "It was a quiet day in the company of {with}.",
    "{With} and I had a quieter part of the journey together.",
}
W.capitalFirstRace = {
    Gnome = {
        ["Ironforge"] = {
            "For the first time, I went into {p:Ironforge}, and down into Tinker Town, where my people had made a home inside the dwarves' mountain.",
            "I came into {p:Ironforge}, a dwarf city, and in Tinker Town I found my own people.",
            "I went into {p:Ironforge} for the first time, and found Tinker Town, where the High Tinker kept the gnomes together after Gnomeregan.",
        },
    },
    Dwarf = {
        ["Ironforge"] = {
            "I walked through the great gate of {p:Ironforge}, into the city of my people, and heard the Great Forge before I saw it.",
            "For the first time, I went into {p:Ironforge}, where King Magni Bronzebeard held the High Seat and the Great Forge burned below.",
        },
    },
    Troll = {
        ["Orgrimmar"] = {
            "I came into {p:Orgrimmar} through the great gate, and found trolls of the Darkspear in the Valley of Spirits.",
            "For the first time, I walked into {p:Orgrimmar}, the city of the Horde my people had joined.",
        },
    },
    Orc = {
        ["Orgrimmar"] = {
            "For the first time, I walked through the gates of {p:Orgrimmar}, the city Thrall built for my people.",
        },
    },
    NightElf = {
        ["Darnassus"] = {
            "For the first time, I came to {p:Darnassus}, the city my people had built on the new World Tree.",
            "I came up into {p:Darnassus} for the first time, and saw the Temple of the Moon, where the priestesses of Elune keep watch.",
        },
    },
    Tauren = {
        ["Thunder Bluff"] = {
            "For the first time, I rode the lift up to {p:Thunder Bluff}, where Cairne Bloodhoof and the elders of my people keep their lodges.",
            "I came up to {p:Thunder Bluff} for the first time, the high city of my people, with all of Mulgore below.",
        },
    },
    Human = {
        ["Stormwind City"] = {
            "For the first time, I crossed the bridge into {p:Stormwind}, the city of my people, under its white walls.",
        },
    },
    Scourge = {
        ["Undercity"] = {
            "I rode the lift down into the {p:Undercity} for the first time, and found the Forsaken had made a city of the old crypts.",
        },
    },
}
W.leaveCity = {
    ["Orgrimmar"] = {"I went back out through the great gate into {zoneD}.", "{We} left the city by the great gate, back into {zoneD}."},
    ["Darnassus"] = {"I came down out of the city, back into the forest of {zoneD}.", "{We} left {p:Darnassus} and went back down into the forest."},
    ["Thunder Bluff"] = {"I rode the lift back down to the plains of {zoneD}.", "{We} took the lift down into {zoneD}."},
    ["Ironforge"] = {"I went back out through the gate of {p:Ironforge}, into the snow of {zoneD}.", "{We} left the mountain and went back out into {zoneD}."},
    ["Stormwind City"] = {"I went out over the bridge into {zoneD}.", "{We} left the city walls behind and went out into {zoneD}."},
    ["Undercity"] = {"I rode the lift back up into the grey light of {zoneD}.", "{We} came up out of the city into {zoneD}."},
}
W.leaveHomeFirst = {
    NightElf = {"It was the first time I had left Teldrassil.", "Teldrassil was behind me now, across the water."},
    Troll = {"It was the first time I had gone beyond Durotar.", "Durotar and the huts of Sen'jin were behind me now."},
    Orc = {"It was the first time I had gone beyond Durotar.", "Durotar was behind me now."},
    Tauren = {"It was the first time I had gone beyond Mulgore.", "Mulgore and its mesas were behind me now."},
    Dwarf = {"It was the first time I had gone beyond Dun Morogh.", "The snows of Dun Morogh were behind me now."},
    Gnome = {"It was the first time I had gone beyond Dun Morogh.", "The snows of Dun Morogh were behind me now."},
    Human = {"It was the first time I had gone beyond Elwynn.", "Elwynn was behind me now."},
    Scourge = {"It was the first time I had gone beyond Tirisfal.", "The grey glades of Tirisfal were behind me now."},
}
W.tramRace = {
    Gnome = {"The {p:Deeprun Tram} was gnome work, and it carried me under the mountains to Stormwind."},
    Dwarf = {"I rode the {p:Deeprun Tram} for the first time, from Ironforge to Stormwind, deep under the mountains."},
}
W.classFirstRace = {
    Dwarf = {
        warhorse = {"My warhorse came when I called, the Light's gift. Most dwarves ride rams, but the Light sent me a horse."},
    },
}
W.petName = {
    "I named my {family} {pet}.",
    "My {family} had a name now, {pet}.",
}
W.petWith = {
    "{Pet} went everywhere I went.",
    "{Pet} fought beside me all the way.",
    "{Pet} was at my side, as always.",
}
W.petRevive = {
    "{Pet} was killed, and I called it back to life, as hunters can.",
    "{Pet} died, and I brought it back.",
}
W.petDungeon = {
    "{Pet} came down into the dark with {us}.",
    "{Pet} went in with {us}, too.",
}
W.druidForm = {
    "I fought most of that day in the shape of the {form}.",
    "Most of my fighting that day I did as a {form}.",
}
W.deathFallIrony = {
    "I had learned to swim like a sea lion that day, and then a fall killed me on dry land.",
}
W.rezOtherBy = {
    PRIEST = {"I prayed {who} back from death, the first I ever raised.",
        "The Light answered me over {who}, the first I ever brought back from death."},
    PALADIN = {"I called on the Light, and {who} rose, the first I ever brought back from death."},
    SHAMAN = {"I called the spirit of {who} back, the first I ever raised."},
    DRUID = {"I brought {who} back with Rebirth, the first I ever raised."},
}
W.roleBy = {
    PALADIN = {
        tank = {"I went in first and took the blows, and the Light kept me standing.",
            "I stood in front, and called on the Light when the blows came too fast."}, -- (the second only when the meter shows your own healing)
        healer = {"I stayed behind the others and kept them standing with the Light."},
    },
    PRIEST = {
        healer = {"I stayed at the back, and the Light kept the others on their feet.",
            "I stayed at the back and prayed the others through it."},
    },
    DRUID = {
        tank = {"I took the shape of the bear and went in first, and the blows fell on me."},
        healer = {"I stayed at the back and kept the others alive, as the druids had taught me."},
    },
    HUNTER = {
        damage = {"I kept my distance, and my arrows did the rest."},
    },
}
W.boast.damage = {
    "I did more than anyone to bring {boss} down.",
    "{boss} fell mostly to my {weapon}.",
    "My {weapon} did most of the work on {boss}.",
}
W.wipeThenWin = {
    "{boss} beat {us} the first time, and fell the second.",
    "The first fight with {boss} went against {us}, and the second did not.",
}
W.killAfter = {
    "After {short}, {we} killed {bosses}.",
    "{We} went on and killed {bosses}.",
}
W.foeSeenPlace = {
    ["Ashenvale"] = {
        "It was there that I first saw one of the {side}, {aRace} {class}, in the forest where Grom Hellscream had killed Cenarius.",
        "In {zoneD}, where Grom Hellscream had killed Cenarius, I saw one of the {side} for the first time, {aRace} {class}.",
    },
}
W.rezSelf = {
    soulstone = {"I came back on {by}'s soulstone.", "{by}'s soulstone brought me back."},
    reincarnation = {"I rose again by my own ankh, as shamans can.", "I came back by Reincarnation, as shamans can."},
}

-- Round 8 (the writer): extensions, towns, class lines.
local function Extend(pool, list) for _, line in ipairs(list) do pool[#pool + 1] = line end end
Extend(W.oncePerBook, {
    "I had learned to swim like a sea lion that day, and then a fall killed me on dry land.",
    "My warhorse came when I called, the Light's gift. Most dwarves ride rams, but the Light sent me a horse.",
    "The {p:Deeprun Tram} was gnome work, and it carried me under the mountains to Stormwind.",
    "I came to {p:Sen'jin Village}, where my people kept their huts by the sea, and the Echo Isles lay out across the water.",
    "Apart from one small errand, the day was our own.",
})
for i = #W.oncePerBook, 1, -1 do
    if W.oncePerBook[i] == "I came to {town}, {lore}, and my own people were there." then table.remove(W.oncePerBook, i) end
end
if W.towns["Razor Hill"] then W.towns["Razor Hill"].home = {"Orc"} end
local function Town(name, homeFirst, homeLines)
    local town = W.towns[name]
    if not town then return end
    town.homeFirst = homeFirst
    if homeLines then town.homeLines = town.homeLines or {}; Extend(town.homeLines, homeLines) end
end
-- Troll
Town("Sen'jin Village", {
    "I came to {p:Sen'jin Village}, where my people kept their huts by the sea, and the Echo Isles lay out across the water.",
    "I came to {p:Sen'jin Village}, named for the old chief of the Darkspear, and found my own people there.",
    "The huts of {p:Sen'jin Village} stood on the shore, and from there I could see the Echo Isles, where Zalazane ruled.",
}, {"I passed through {p:Sen'jin Village}, among my own people.", "The fires of {p:Sen'jin Village} were burning by the sea."})
-- Orc (Razor Hill is now the orcs' alone; Orgnil Soulscar kept its barracks)
Town("Razor Hill", {
    "I came to {p:Razor Hill}, where Orgnil Soulscar kept the barracks and the watch on the coast.", -- (check on Forever)
    "I came to {p:Razor Hill}, the first orc town past the Valley of Trials.",
}, {"I stopped at {p:Razor Hill}, where the grunts watched the coast."})
-- Night elf
Town("Dolanaar", {
    "I came to {p:Dolanaar}, a village of my own people under the boughs of Teldrassil.",
    "I came down the path to {p:Dolanaar}, where the Sentinels kept watch on the road to Darnassus.",
}, {"I passed through {p:Dolanaar} again, under the boughs."})
Town("Auberdine", {
    "I came to {p:Auberdine}, where the boats leave for Teldrassil and the lands beyond.",
    "I came to {p:Auberdine}, the only town of my people on that long coast.",
}, {"The boats were in at {p:Auberdine}, as they always were."})
Town("Astranaar", {
    "I came to {p:Astranaar}, where the Sentinels held the lake against the Horde in the woods.",
    "I crossed the bridge to {p:Astranaar}, on its island in the lake, among my own people.",
})
Town("Darnassus", nil, {"I came back up into {p:Darnassus}, among my own people.",
    "The priestesses of the Temple of the Moon were at their prayers in {p:Darnassus}, as always."})
-- Tauren (corpus, "Rites of the Earthmother", 763: Baine Bloodhoof, son of Cairne, chief of the village)
Town("Bloodhoof Village", {
    "I came down the road to {p:Bloodhoof Village}, where Baine Bloodhoof, son of Cairne, was chief.",
    "I came to {p:Bloodhoof Village}, among the tents and the kodos of my people.",
}, {"I passed through {p:Bloodhoof Village}, among my own people."})
Town("Camp Taurajo", {
    "I came to {p:Camp Taurajo}, where my people kept watch over the southern Barrens.",
    "I came to {p:Camp Taurajo}, the last of my people's camps before the south.",
})
Town("Thunder Bluff", nil, {"I rode the lift up to {p:Thunder Bluff}, where the elders keep their lodges on the high mesas."})
-- Dwarf and gnome (Kharanos is both: the dwarves' brewery town, and the gnomes' trainers kept
-- shop there after Gnomeregan; the lines below hold for either race)
Town("Kharanos", {
    "I came to {p:Kharanos}, where the Thunderbrews brewed their ale and the mountaineers kept watch on the road.",
    "I came to {p:Kharanos}, the town on the road between the valley and Ironforge.",
}, {"I stopped at the Thunderbrew Distillery in {p:Kharanos}, as I often had."})
Town("Thelsamar", {
    "I came to {p:Thelsamar}, where the mountaineers of Ironforge kept the road through Loch Modan.",
    "I came to {p:Thelsamar}, a town of my own people under the hills of the loch.",
}, {"I stopped at the Stoutlager Inn in {p:Thelsamar} again."}) -- (check on Forever: the inn's name)
Town("Ironforge", nil, {"I went back into {p:Ironforge}, out of the snow.", "The forges were loud in {p:Ironforge}, as they always are."})
Town("Orgrimmar", nil, {"I walked through the great gate of {p:Orgrimmar} again."})
Extend(W.capitalFirst["Ironforge"], {
    "I went into {p:Ironforge}, where the Explorers' League keeps its maps and its finds in the Hall of Explorers.", -- (no first)
})
Extend(W.classFirst.pet, {
    "For the first time, a beast of the wild answered to me, a {family}.",
    "I tamed a {family}, and from then on I did not hunt alone.", -- ENGINE: only when the pet stayed (it is seen in a later chapter)
})
-- The Great Bear Spirit teaches the bear (corpus, "Body and Heart"). Said AFTER the quest line.
Extend(W.classFirst.bear, {
    "The Great Bear Spirit had taught me its way, and I took the shape of the bear.",
})
Extend(W.classFirst.aquatic, {
    "I learned to take the shape of a sea lion, and the water was mine to go where I liked.",
})
-- NEW KEY (engine hook: Teleport: Moonglade learned or first cast, spell 18960; it carries the
-- arrival, so the next "Then I came to Moonglade" line is skipped). No tokens.
W.classFirst.moonglade = {
    "For the first time, I went to Moonglade the druids' way, by my own magic.",
    "I learned the way to Moonglade, and could go there by magic whenever I was called.",
    "I spoke the words the druids had taught me, and I was in Moonglade.",
}
W.titles.classBy = W.titles.classBy or {}
W.titles.classBy.moonglade = {"Moonglade", "The Druids' Way"}

-- Round 8b (the writer).
W.leaveCity = W.leaveCity or {}
W.leaveCity["Darnassus"] = {
    "I came down out of the city, back into the forest of {zoneD}.",
    "{We} left the city and went back down into the forest.",
}

-- W.foeSeenPlace.Ashenvale  ({side} {aRace} {ARace} {class} {zoneD}). The {zoneD} line named Ashenvale
-- again in the chapter that opens on it ("I came to Ashenvale ... In Ashenvale, where..."). No zone now.
W.foeSeenPlace = W.foeSeenPlace or {}
W.foeSeenPlace["Ashenvale"] = {
    "It was there that I first saw one of the {side}, {aRace} {class}, in the forest where Grom Hellscream had killed Cenarius.",
    "Where Grom Hellscream had killed Cenarius, I saw one of the {side} for the first time, {aRace} {class}.",
}

-- W.joinedNewUs  (st + {names} {known}). DELETE "{names}, made one more in our party.": it says "our"
-- without saying who ("Tarok, a tauren warrior, made one more in our party." and Morwen unnamed).
W.joinedNewUs = {
    "{names}, joined {known} and me.",
    "{known} and I fell in with {names}.",
}

-- W.deathFallIrony  (no tokens). "I learned to take the form of a sea lion. I had learned to swim like a
-- sea lion that day, and then..." said the form twice. The form line is said just before; this one
-- leans on it.
W.deathFallIrony = {
    "Later that day a fall killed me, on dry land.",
    "Before the day was out, I fell to my death, and not in the water.",
}
for i = #W.oncePerBook, 1, -1 do
    if W.oncePerBook[i] == "I had learned to swim like a sea lion that day, and then a fall killed me on dry land." then table.remove(W.oncePerBook, i) end
end
W.oncePerBook[#W.oncePerBook + 1] = "Later that day a fall killed me, on dry land."
W.oncePerBook[#W.oncePerBook + 1] = "Before the day was out, I fell to my death, and not in the water."
-- back." ("back" twice). The new line says the same with what was not seen.
W.firstDeathRez = {
    "It was the first time I died.",
    "It was the first time I died, and I never saw the graveyard.",
    "I had never died before.",
}

-- NEW POOL (engine hook: W.rez, by the class of the one who raised you, from the roster; before W.rez).
-- Tokens {by}. The own journal said "Grosh brought me back." where his book said the spirits.
W.rezBy = {
    SHAMAN = {"{by} called my spirit back.", "{by} called on the spirits, and I came back."},
    PRIEST = {"{by} prayed me back from death.", "{by}'s prayers brought me back."},
    PALADIN = {"{by} called on the Light, and I rose.", "The Light answered {by}, and I rose."},
    DRUID = {"{by} brought me back with Rebirth.", "{by} would not let death keep me."},
}
-- A level reached earlier in a day whose work went on after it ({level}).
W.levelEarly = W.levelEarly or {
    "I had reached level {level} earlier in the day.",
    "Level {level} had come earlier that day.",
    "Somewhere in all of it, I had reached level {level}.",
}

-- A second way to say each town, without its zone's name (said already, as often as not).
for name, extra in pairs({
    ["Astranaar"] = "the night elf town on its island in the lake",
    ["Auberdine"] = "the only town of the night elves on that long coast",
    ["Bloodhoof Village"] = "Cairne's village below the bluffs",
    ["Brackenwall Village"] = "where the Darkspear and the orcs keep a camp in the marsh",
    ["Camp Mojache"] = "where the tauren keep their camp among the great trees",
    ["Camp Taurajo"] = "the last of the tauren camps before the south",
    ["Darkshire"] = "where the Night Watch keeps its lamps lit",
    ["Dolanaar"] = "the village under the great tree",
    ["Everlook"] = "the goblin town at the end of the snow road",
    ["Gadgetzan"] = "the goblin town in the desert",
    ["Grom'gol Base Camp"] = "the Horde camp among the jungle trolls",
    ["Kargath"] = "the orc outpost carved into the canyon",
    ["Lakeshire"] = "the town by the lake and its long bridge",
    ["Menethil Harbor"] = "the dwarf port where the ships come in",
    ["Morgan's Vigil"] = "the Alliance camp in sight of Blackrock Mountain",
    ["Nijel's Point"] = "the Alliance camp in the hills",
    ["Razor Hill"] = "the orc town on the road south",
    ["Refuge Pointe"] = "the last Alliance hold on the highlands",
    ["Sen'jin Village"] = "where the Darkspear keep their huts",
    ["Sentinel Hill"] = "where the People's Militia keeps watch",
    ["Shadowprey Village"] = "the troll fishing village by the sea",
    ["Southshore"] = "the town by the water, under the hills",
    ["Splintertree Post"] = "the Horde camp in the night elf woods",
    ["Stonard"] = "the orc fortress in the swamp",
    ["Stonetalon Peak"] = "the druid hold high on the mountain",
    ["Sun Rock Retreat"] = "the tauren hold high in the peaks",
    ["Talonbranch Glade"] = "the night elf camp in the poisoned woods",
    ["Thelsamar"] = "the dwarf town by the lake",
    ["The Crossroads"] = "the Horde fort where the roads meet",
    ["The Sepulcher"] = "the Forsaken outpost among the graves",
    ["Valormok"] = "the Horde camp on the edge of the old elf ruins",
}) do
    local town = W.towns and W.towns[name]
    if town and town.lore and #town.lore == 1 then town.lore[2] = extra end
end

-- Round 8c (writer).
-- W.partyDeath.plain  (st + {names}). DELETE "{We} lost {names} there." (mine, REWRITES8): it reads as
-- for good, and two sentences later "Grosh called my spirit back." (Nahiri 4).
W.partyDeath = W.partyDeath or {}
W.partyDeath.plain = {"{names} died there.", "{names} was killed there."} -- ENGINE: the second for one name only

-- W.townFoe  ({town} {Town} {side} {lore}). DELETE "{Town} belonged to the {side}." (a stub: "Kargath
-- belonged to the Horde.") and "I passed through {town}, a town of the {side}." (an Alliance pair does not
-- walk through Kargath; the guards would kill them).
W.townFoe = {
    "I kept clear of {town}, a town of the {side}.",
    "I went wide of {town}, which belonged to the {side}.",
}

-- NEW POOL (engine hook: W.fishAt when {place} was named in the sentence before). Tokens st + {work}.
-- Fixes "We spent a while in Ratchet, the Steamwheedle town ... I cast a line at Ratchet" (Nahiri 5).
W.fishAtHere = {
    "I cast a line off the dock there, and {work}.",
    "I put a line in the water there, and {work}.",
}

-- Round 9 (the writer): batch 2 (the ganker, the couple, Duskwood, the crafter, the healer).
do
local PB = A.JournalTale and A.JournalTale.phrases
local L = A.Lore
local P = A.JournalTellers
if L then
---------------------------------------------------------------------------
-- 1. MY OWN ERROR FROM 8c, AND DATA THAT IS FALSE
---------------------------------------------------------------------------

-- W.townFoe  ({town} {Town} {side} {lore}). 8c was WRONG: a "town" event means you were IN the
-- town. "I went wide of Southshore, which belonged to the Alliance. The guards of Southshore killed
-- me" (Vesk 2) is the result. Say you went in; the guards line that may follow then makes sense.
W.townFoe = {
    "I passed through {town}, a town of the {side}.",
    "I went into {town}, though it belonged to the {side}.",
    "I came into {town}, where the {side} held the streets.",
}

-- Second town lore (round 9's table). Menethil Harbor was built by the humans of Lordaeron and named
-- for their royal house; "the dwarf port" is false. Bloodhoof Village is the Bloodhoof tribe's
-- village, and Baine, not Cairne, is its chief.
if W.towns["Menethil Harbor"] and W.towns["Menethil Harbor"].lore then
    W.towns["Menethil Harbor"].lore[2] = "the harbor where the ships come in from Kalimdor"
end
if W.towns["Bloodhoof Village"] and W.towns["Bloodhoof Village"].lore then
    for i, l in ipairs(W.towns["Bloodhoof Village"].lore) do
        if l == "Cairne's village below the bluffs" then W.towns["Bloodhoof Village"].lore[i] = "the Bloodhoof tribe's village below the bluffs" end
    end
end

-- L.dungeonStory["Ragefire Chasm"].why: "led by a Felguard" (a kind of demon, not a name).
for i, l in ipairs(L.dungeonStory["Ragefire Chasm"].why or {}) do
    L.dungeonStory["Ragefire Chasm"].why[i] = (l:gsub("a Felguard", "a felguard"))
end

-- W.sunsetAfter["Echo Isles"]  (no tokens). "At the Echo Isles, I watched the light go off the water
-- ... Across the water, the fires of the Echo Isles came on." (Durka 3, telling 3): she was ON the isles.
W.sunsetAfter["Echo Isles"] = {"The water around the isles went dark, and then the sky."}

-- L.zones["Durotar"].e[3]. Mine, REWRITES8: "in Durotar, on the eastern coast of Kalimdor" (Ragh I)
-- reads as a geography lesson on home ground.
L.zones["Durotar"].e[3] = "{p:Durotar}, among the red rocks"

---------------------------------------------------------------------------
-- 2. THE WRY STORYTELLER'S ASIDES (JournalTellers.lua). An empty teller pool falls back to the
-- common one. Each of these was an aside or a false mood:
--   "Poor soul." after meeting Gorm (who did not die) and Corwin (whose death had not happened yet);
--   "The beds, as ever, were a matter of opinion." (beds: not recorded; a wink at the reader);
--   "Well. That could have gone better." on two days the dungeon was cleared and its lord killed.
---------------------------------------------------------------------------
if P and P.wry then
    P.wry.meetGroup = {}
    P.wry.inn = {}
    P.wry.closegrim = {}
end

---------------------------------------------------------------------------
-- 3. A COUPLE WHO BEGAN TOGETHER (Durka and Ragh)
---------------------------------------------------------------------------

-- NEW POOL (engine hook: the first chapter of a book whose companion began with you, origin =
-- "together", keyed by race; in place of W.origin + W.joinedBond). Tokens {names} {bond} ("Ragh",
-- "my wife"). The book opened "My first task in the Valley of Trials was to thin out the boars...
-- Ragh, my wife, was with me." for a life the two of them began side by side.
W.originTogether = {
    Orc = {"{names}, {bond}, and I began together in the {p:Valley of Trials}, where the Horde sends its young to be tested.",
        "{names}, {bond}, and I came of age together in the {p:Valley of Trials}."},
    Troll = {"{names}, {bond}, and I began together in the {p:Valley of Trials}, two Darkspear among the orcs."},
    Tauren = {"{names}, {bond}, and I began together at {p:Camp Narache}, on the plains of Mulgore."},
    Scourge = {"{names}, {bond}, and I rose together at {p:Deathknell}."},
    Human = {"{names}, {bond}, and I began together at {p:Northshire Abbey}."},
    Dwarf = {"{names}, {bond}, and I began together at {p:Anvilmar}, in the snow."},
    Gnome = {"{names}, {bond}, and I began together at {p:Anvilmar}, far from lost Gnomeregan."},
    NightElf = {"{names}, {bond}, and I began together in {p:Shadowglen}, under Aldrassil."},
}
-- NEW POOLS (engine hook: the day's sunset while a companion was with you; the "we" form of
-- W.milestone2.sunset / sunsetEast). Tokens {what} {names}. "I was at the Echo Isles when the sun
-- went down" was told as one person's, on the warmest evening of the couple's book.
W.milestone2.sunsetWe = {
    "{names} and I watched the sun go down over the sea at {what}.",
    "At {what}, {names} and I stopped to watch the sun go down.",
}
W.milestone2.sunsetEastWe = {
    "At {what}, {names} and I watched the light go off the water as the sun went down behind us.",
    "{names} and I were at {what} when the sun went down behind the land, and the sea in front of us went grey.",
}
-- NEW POOL (engine hook: W.caveDeath when someone was with you). Tokens {cave} {foe} {Foe}.
-- "Ragh was with me ... I went down into Dustwind Cave, and a Burning Blade Thug killed me there."
W.caveDeathWe = {
    "We went down into {cave}, and {foe} killed me there.",
    "{Foe} killed me deep in {cave}, with the others beside me.",
}
-- NEW POOL (engine hook: PB.dungeonFirstEver when the companion began with you, so it was the first
-- for both). Tokens {us}. "You had never been inside a dungeon before." told to a couple.
if PB then
PB.dungeonFirstEverBoth = {
    "Neither of {us} had ever been inside a dungeon before.",
    "It was the first dungeon either of {us} had ever gone into.",
}
end

---------------------------------------------------------------------------
-- 4. RACE AND CLASS
---------------------------------------------------------------------------

-- NEW POOL (engine hook: W.rezOtherBy for a PRIEST of a race whose priests do not call on the Light,
-- keyed by race; before W.rezOtherBy). Tokens {who}. "The Light answered me over Bruk" was said by
-- a troll; night elf priests pray to Elune. Use the Light lines for Human, Dwarf and Gnome priests.
-- ENGINE: the same gate for L.dungeonStory["Scarlet Monastery"].whyClass.PRIEST ("the same Light I did").
W.rezOtherByRace = {
    Troll = {"I prayed {who} back from death."},
    NightElf = {"Elune answered me over {who}, and death let go."},
    Scourge = {"I raised {who} from death with the old prayers."},
    Tauren = {"I prayed {who} back from death."},
}
-- NEW POOLS: the life-first raise in a book begun late (level 11 or above). "the first I ever raised"
-- cannot be known at level 34 (Kahlu 1, and Bruk I). Tokens {who} / companion {I} {them}.
W.rezOtherLate = {
    "I prayed {who} back from death.",
    "I brought {who} back from death.",
}
if PB then
PB.sharedRezOtherLate = {
    "{I} prayed {them} back from death.",
    "{I} brought {them} back from death before the fight was cold.",
}
end

-- W.roleBy -- EXTEND (st). The classes of batch 2.
W.roleBy = W.roleBy or {}
W.roleBy.SHAMAN = {healer = {"I stayed behind the others and kept them on their feet, as the spirits had taught me."}}
W.roleBy.ROGUE = {damage = {"I struck from behind while the others held their attention."}}
W.roleBy.MAGE = {damage = {"I kept back, and my spells did the work."}}
W.roleBy.WARLOCK = {damage = {"I kept back, and my spells and my demon did the work."}}
W.roleBy.PRIEST = W.roleBy.PRIEST or {}
W.roleBy.PRIEST.healer = {"My place was behind the others, keeping them alive.", "I stayed at the back and prayed the others through it."}

-- NEW FIELD L.dungeonStory[...].whyRace -- the races of batch 2.
L.dungeonStory["Zul'Farrak"].whyRace = {
    Troll = {"The Sandfury were trolls, but no kin of the Darkspear, and they had no welcome for us."},
}
L.dungeonStory["Shadowfang Keep"].whyRace = {
    Scourge = {"The Forsaken could not hold Silverpine for the Dark Lady while Arugal lived in the keep."},
}
-- NEW FIELD (engine hook: Gnomeregan's race lines in a companion book; {my} is "your"/"my").
L.dungeonStory["Gnomeregan"].whyRaceC = {
    Gnome = {"Gnomeregan had been {my} people's city, and the troggs and the traitor Thermaplugg held it now."},
}

-- Lords' consequences. Arugal was named in the boast just before ("Arugal fell mostly to your
-- spells... Silverpine was rid of Arugal, for now." in Grak III).
if L.bosses["Archmage Arugal"] then
    L.bosses["Archmage Arugal"].after = "The worgen of Silverpine had lost their master, for now."
    L.bosses["Archmage Arugal"].afterMore = {"Silverpine was free of the worgen's master, for now."}
end
-- NEW FIELD L.bosses[...].afterRace (engine hook: in place of after, for that race, own journal).
if L.bosses["Mekgineer Thermaplugg"] then
    L.bosses["Mekgineer Thermaplugg"].afterRace = {Gnome = "The traitor who had poisoned my people's city was dead."}
end

-- NEW POOL (engine hook: the first mount, keyed by its kind, from the summon spell's name: Raptor,
-- Wolf, Kodo, Horse/Stallion/Mare/Pinto/Palomino, Ram, Mechanostrider, Saber, Skeletal). No tokens.
-- "For the first time, I rode my own mount." said of a troll; a Darkspear rides a raptor.
-- ({zoneD}: the day's country; forty levels of walking is what a first mount ends)
W.mountFirstKind = {
    raptor = {"For the first time, I rode a raptor of my own, and {zoneD} went by faster than my feet had ever managed.",
        "A raptor of my own came when I called. Forty levels of walking ended that day.",
        "I had a raptor of my own at last, and the long walks were over."},
    wolf = {"For the first time, I rode a wolf of my own, and {zoneD} went by faster than my feet had ever managed.",
        "A wolf of my own came when I called. Forty levels of walking ended that day.",
        "I had a wolf of my own at last, and the long walks were over."},
    kodo = {"For the first time, I rode a kodo of my own, slow to start and hard to stop.",
        "A kodo of my own came when I called. Forty levels of walking ended that day.",
        "I had a kodo of my own at last, and {zoneD} went by under its feet instead of mine."},
    horse = {"For the first time, I rode a horse of my own, and {zoneD} went by faster than my feet had ever managed.",
        "A horse of my own came when I called. Forty levels of walking ended that day.",
        "I had a horse of my own at last, and the long walks were over."},
    ram = {"For the first time, I rode a ram of my own, and {zoneD} went by faster than my feet had ever managed.",
        "A ram of my own came when I called. Forty levels of walking ended that day.",
        "I had a ram of my own at last, and the long walks were over."},
    mechanostrider = {"For the first time, I rode a mechanostrider of my own, and {zoneD} went by faster than my feet had ever managed.",
        "A mechanostrider of my own came when I called. Forty levels of walking ended that day.",
        "I had a mechanostrider of my own at last, and it clanked the whole way."},
    saber = {"For the first time, I rode a nightsaber of my own, and {zoneD} went by faster than my feet had ever managed.",
        "A nightsaber of my own came when I called. Forty levels of walking ended that day.",
        "I had a nightsaber of my own at last, and the long walks were over."},
    skeletal = {"For the first time, I rode a skeletal horse of my own, and {zoneD} went by faster than my feet had ever managed.",
        "A skeletal horse of my own came when I called. Forty levels of walking ended that day.",
        "I had a skeletal horse of my own at last, and the long walks were over."},
}

-- NEW POOL (engine hook: W.craftMade / craftPlain by trade, before them). Tokens {count} {made}.
-- "I sat down to my tailoring and made fourteen things" (Tinka 1): "things" for a tailor's work.
W.craftBy = {
    Tailoring = {"I sat down with needle and thread and made {count} pieces, among them {made}.", "I sewed {count} pieces, {made} among them."},
    Leatherworking = {"I worked {count} pieces of leather, {made} among them."},
    Blacksmithing = {"I worked at the anvil and made {count} pieces, {made} among them."},
    Engineering = {"I built {count} contraptions, {made} among them."},
    Alchemy = {"I mixed {count} potions and elixirs, {made} among them."},
    Cooking = {"I cooked {count} dishes, {made} among them."},
    Enchanting = {"I made {count} enchanted things, {made} among them."},
    FirstAid = {"I made {count} bandages, {made} among them."},
    -- (pass 3: "I worked at my fishing and made three things" read as a craft bench)
    Fishing = {"I put together {made} for my fishing.", "I made {made} for my fishing as well."},
}

-- W.milestone[20] / [30]  (no tokens). "Level twenty." and "Level thirty." closed three chapters of
-- batch 2 as two-word fragments.
-- (milestones lane, 2026-11-06: the lines of W.milestone above, with the fact each level changes)
W.milestone[20] = {"I reached level twenty, a third of the way to the top.", "By the end of it I was level twenty, a third of the way to the top.",
    "Level twenty came that day, and with it the roads of the middle country.", "I made level twenty. The middle country was open to me now."}
W.milestone[30] = {"I reached level thirty, halfway to the top.", "By the end of it I was level thirty, halfway to the top.",
    "Level thirty came that day, and half the climb was done.", "I made level thirty. The second half of the climb began."}

-- PB.rolesPair["healer+damage"]  ({I} {name} {they}). "High Inquisitor Whitemane killed Nyx...
-- You kept Nyx alive while she fought." (Nyx I). No line here claims they lived.
if PB then
PB.rolesPair["healer+damage"] = {"{I} healed, and {name} fought.", "{name} fought, and {I} did the healing."}
end
end
end

-- A day in a battleground ({what}, {mySide}, {times}: "twice", "three times").
W.bgOnce = {"I fought in {what}, with the {mySide}.", "I went into {what} to fight for the {mySide}."}
W.bgTimes = {"I fought in {what} {times}, with the {mySide}.", "I went into {what} {times} to fight for the {mySide}."}
W.bgTimesAgain = {"I was back in {what}, and fought there {times}.", "I fought in {what} again, {times} over."}

-- Your part, joined to the kill that just named the boss ({weapon}): "We killed X, and ...".
W.boastHere = {"my {weapon} did most of the work.", "most of the damage was mine."}

-- The quest named for what had killed you, turned in after it did ({foe}).
W.questRevenge = {"This time it was {foe} who died.", "{foe} did not get the better of me a second time."}

-- The quiet "we" lines when the opening already named who "we" were.
W.quietDayOneWeBare = {
    "One errand marked an otherwise quiet day.",
    "We finished a single quest that day.",
    "One quest was all we turned in that day.",
}
W.quietDayWeBare = {
    "It was a quiet stretch of our journey.",
    "The day passed quietly.",
    "It was a day without errands.",
}

-- A book begun late, at home ({level}, {zoneE}).
W.openFirstLate.home = {"I was level {level}, and in {zoneE}, among my own people.", "At level {level}, I was at home in {zoneE}."}

-- A level reached in an earlier part of the day ({level}, {where}).
W.levelEarlyDungeon = {"I had reached level {level} down in {where}.", "Level {level} had come in {where}, earlier that day."}
W.levelEarlyIn = {"I had reached level {level} in {where}, earlier that day.", "Level {level} had come in {where}, earlier that day."}
-- (pass 3, 2026-11-11: a level from earlier in the day is told where it came, right after the
-- last line of that stretch: "with it" when that line's deed came within two minutes of it)
W.levelWithIt = {"Level {level} came with it.", "I reached level {level} with it."}
W.levelThere = {"I reached level {level} there.", "Level {level} came there."}

-- A long swim that nearly drowned you ({place}).
W.swimNearly = {"I swam a long way in the waters of {place}, and very nearly drowned.", "I swam out into {place} and came up for air just in time."}

-- What a skinner took, by name ({names}: "Thick Leather"; {work}).
W.gatherNamesHides = {"Most of it was {names}.", "Most of what I took was {names}."}
W.gatherNamedHides = {"I {work}, and took mostly {names}.", "I {work}, for {names} for the most part."}

-- Round 10 (the writer): batch 2, second pass.
do
local PB = A.JournalTale and A.JournalTale.phrases
local L = A.Lore
if L then
-- W.questRevenge  ({foe} {Foe}). DELETE "{foe} did not get the better of me a second time.": Aldric 5
-- says it right after "Mor'Ladim was the end of me", the second time Mor'Ladim had killed him. The
-- lines below hold whatever the count.
-- ENGINE: when the quest's title is the foe's own name ("Mor'Ladim"), leave the title out of the quest
-- list and join: "We finished The Legend of Stalvan, and this time it was Mor'Ladim who died."
W.questRevenge = {
    "This time it was {foe} who died.",
    "In the end it was {foe} who went down.",
}

-- Menethil Harbor's second lore (mine, REWRITES9): "Menethil Harbor, the harbor where the ships come in".
if W.towns["Menethil Harbor"] and W.towns["Menethil Harbor"].lore then
    for i, l in ipairs(W.towns["Menethil Harbor"].lore) do
        if l == "the harbor where the ships come in from Kalimdor" then W.towns["Menethil Harbor"].lore[i] = "the port where the ships come in from Kalimdor" end
    end
end

-- Shadowfang Keep, whyRace (mine, REWRITES9): "...while Arugal lived in the keep. The keep was cold, ..."
L.dungeonStory["Shadowfang Keep"].whyRace = {
    Scourge = {"The Forsaken could not hold Silverpine for the Dark Lady while Arugal lived."},
}

-- PB.sharedRezOtherLate  ({I} {them}). DELETE "...before the fight was cold." (mine): a flourish, and
-- "fight" twice after "did not live out the fight".
if PB then
PB.sharedRezOtherLate = {
    "{I} prayed {them} back from death.",
    "{I} brought {them} back from death.",
}
end

-- W.voyageFirstLand.boat / .zeppelin  ({to}). DELETE the two-sentence line "A ship carried me across the
-- sea to {to}. I had never sailed before, and I had never seen {to}.": it names {to} twice and, with the
-- first-zone line after it, made three firsts in a row (Sylwen 7: "...I had never seen the Eastern
-- Kingdoms. I saw the Wetlands for the first time.").
W.voyageFirstLand.boat = {
    "For the first time, I went aboard a ship, and it carried me across the sea to {to}, where I had never been.",
    "I took the boat across the sea to {to}, my first time on a ship and my first sight of that land.",
    "A ship carried me across the sea to {to}, where I had never been.",
}
W.voyageFirstLand.zeppelin = {
    "For the first time, I rode a zeppelin, and it carried me over the sea to {to}, where I had never been.",
    "I took the zeppelin across the sea to {to}, my first time on a zeppelin and my first sight of that land.",
    "A zeppelin carried me over the sea to {to}, where I had never been.",
}

-- W.aucSale  ({what}). "I sold Blue Linen Vest at the auction house" reads without its article. ENGINE:
-- in a book begun at level 11 or above, only the line marked (no first): "my first sale there" cannot be
-- known for a crafter of 22 (Tinka 1), the same rule as the raise in round 9.
W.aucSale = {
    "Somebody bought my {what} at the auction house. I never learned who.",
    "My {what} sold at the auction house, the first thing I ever sold there.",
    "I sold my {what} at the auction house, my first sale there.",
    "The auction house sold my {what}, and the coin came to me by mail.", -- (no first)
}

-- NEW POOL (engine hook: W.quietClose after a sunset shared with company; the companion is named in
-- the sunset line just before). Tokens st. "At the Echo Isles, Ragh and I watched ... I did not hurry
-- away." (Durka 3) and "Grosh and I watched ... The first stars were out by the time I left." (Nahiri 5).
W.quietCloseWe = {
    "We did not hurry away.",
    "The first stars were out by the time we left.",
    "We stayed until the light was gone, and for a while after.",
}

-- NEW POOL (engine hook: W.townHomeFirst when st.We == "We"). Tokens {town} {lore}.
-- "Ragh and I set out in Durotar. I came to Razor Hill..." (Durka 2).
W.townHomeFirstWe = {
    "We came to {town}, {lore}.",
    "We stopped in {town}, {lore}.",
    "We stopped a while in {town}, {lore}.",
}

-- NEW POOL (engine hook: you and the companion reached the same level the same day; in place of
-- W.level). Tokens {names} {level}. The couple's book says "You both reached level 20" in Ragh's
-- journal and only "I reached level twenty." in Durka's own.
W.levelBoth = {
    "{names} and I both reached level {level}.",
    "{names} and I reached level {level} together.",
}
end
end

-- Darkshire's second lore without the Night Watch (the zone's own lines name it).
if W.towns["Darkshire"] and W.towns["Darkshire"].lore then
    for i, l in ipairs(W.towns["Darkshire"].lore) do
        if l == "where the Night Watch keeps its lamps lit" then W.towns["Darkshire"].lore[i] = "the one lit town in those dark woods" end
    end
end

-- The revenge when the quest's own title names the foe (no name again).
W.questRevengeBare = {"this time it went the other way.", "this time I was the one still standing."}

-- Round 11 (the writer): batch 3.
do
local PB = A.JournalTale and A.JournalTale.phrases
local L = A.Lore
local P = A.JournalTellers
if L then
-- 1. THE WRY TELLER'S FALL JOKES. "You discovered the ground. Hard." (Tobias III) is a fragment and a
-- wink; "In your defence, it was a very convincing ledge." speaks to the reader. The common FALLING pool
-- already has the dry line ("The drop was further than it looked."), once per book.
---------------------------------------------------------------------------
if P and P.wry then P.wry.dieFALLING = {} end

---------------------------------------------------------------------------
-- 2. THE RETURNER (Liriel)
---------------------------------------------------------------------------

-- W.reunion  ({When} {names} {ago} {zoneD}). DELETE "...and we took the road together again." (the road
-- as a metaphor; CRITIQUE6 rewrote it, and it is back: "Ithil turned up in Ashenvale after four months,
-- and we took the road together again." Liriel 4).
W.reunion = {
    "I was in {zoneD} with {names}.",
    "{names} and I travelled together in {zoneD}.",
}
-- An entry event supports entering the dungeon, rather than another greeting.
-- Chapter dates carry the chronology; none of these lines implies an absence.
W.reunionDungeon = {
    "{names} and I went into {zoneD} together.",
    "With {names}, I entered {zoneD}.",
}
-- NEW POOL (engine hook: W.reunion for a bonded companion; before it). Tokens {When} {names} {bond}
-- {ago} {zoneD}. Her oldest friend after four months was told like any acquaintance.
W.reunionBond = {
    "{names}, {bond}, was beside me in {zoneD}.",
    "I was in {zoneD} with {names}, {bond}.",
}
W.reunionDungeonBond = {
    "{names}, {bond}, went into {zoneD} with me.",
    "I entered {zoneD} with {names}, {bond}.",
}
-- W.returned  ({ago}). DELETE "...and it took a while to remember the way of things." (a feeling, invented).

-- W.titles.returned. "Back on the Road" is the road metaphor; "After Long Away" is not English.
W.titles.returned = {"The Return", "Back Again"}
-- NEW POOL (engine hook: the last chapter before a gap of 30 days or more; said last, hindsight the
-- engine has). Tokens {ago}. Liriel's sunset at Auberdine was her last evening for four months.

-- NEW POOL (companion; engine hook: a bonded companion back after 30 days or more, in place of
-- PB.rare / PB.pauseFar). Tokens {name} {bondWord} {gap} {pair}. "Ithil was in the party for the first
-- time in four months." (Ithil III).
if PB then
    PB.reunionBond = {
        "{name}, {bondWord}, came back after {gap}, and {pair} went out together as before.",
        "After {gap}, {name}, {bondWord}, was back at {my} side.",
    }
end

---------------------------------------------------------------------------
-- 3. NAMES SAID TWICE OR THRICE (data)
---------------------------------------------------------------------------
-- "The last of them, Emperor Dagran Thaurissan, the Dark Iron emperor, fell too. The Dark Iron empire
-- had lost its emperor." (Shael I, Vor I): "emperor" three times. Shadowforge City is the Dark Irons'
-- city in Blackrock Depths.
if L.bosses["Emperor Dagran Thaurissan"] then L.bosses["Emperor Dagran Thaurissan"].e = "the master of Shadowforge City" end
-- "Baron Rivendare, the Scourge's baron ... Stratholme had lost its baron." (Shael II).
if L.bosses["Baron Rivendare"] then L.bosses["Baron Rivendare"].e = "the Lich King's man in Stratholme" end
-- Feralas: "The ruins of Dire Maul stood deep in the forest ... Gordunni ogres held the ruins".
for i, l in ipairs(L.zoneStory["Feralas"].stakes or {}) do
    L.zoneStory["Feralas"].stakes[i] = (l:gsub("Gordunni ogres held the ruins", "Gordunni ogres held the old city"))
end
-- Duskwood: "...and the Night Watch kept Darkshire lit. I stopped a while in Darkshire, the one lit town".
for i, l in ipairs(L.zoneStory["Duskwood"].stakes or {}) do
    if l == "The dead walked in its woods, and the Night Watch kept Darkshire lit." then
        L.zoneStory["Duskwood"].stakes[i] = "The dead walked in its woods, and only the Night Watch stood against them."
    end
end

---------------------------------------------------------------------------
-- 4. RACE: the dungeons of batch 3
---------------------------------------------------------------------------
L.dungeonStory["Blackfathom Deeps"].whyRace = {
    NightElf = {"Blackfathom had been a temple of my people, to Elune, until something from below fouled its moonwell."},
}
L.dungeonStory["Scarlet Monastery"].whyRace = {
    Scourge = {"The Crusade burned every undead it found, and I was one."},
}

---------------------------------------------------------------------------
-- 5. NEW POOLS FOR THE PERSONAS
---------------------------------------------------------------------------
-- (engine hook: a rare beast seen, then killed you; one sentence, in place of rareBeast + death).
-- Tokens {what} {zoneD}. "King Mosh was about that day, and our paths crossed. It was King Mosh that
-- killed me." (Bram 3).
W.rareBeastKilled = {
    "I came across {what}, which few ever see, and it killed me.",
    "{what} was about that day, and it killed me.",
}
-- (engine hook: an unsure class first for a class past its level, a hunter's tame at 50; told without
-- "first"). No tokens. Bram's new pet in Azshara was dropped.
W.classAgain = {
    tame = {"I tamed a new beast that day.", "I tamed a new companion of the wild."},
    teleport = {"I learned to take myself home by magic."},
}
-- (engine hook: three levels or more in one day; in place of W.levels). Tokens {from} {level}.
W.levelsFast = {
    "I went from level {from} to {level} in a single evening.",
    "In one evening I went from level {from} to {level}.",
}
-- (engine hook: eight levels or more in seven days or fewer, once per book, last in its chapter).
-- Tokens {from} {level} {span} ("four days"). Morv is a speed leveller, and his book never says so.
W.paceTally = {
    "I had gone from level {from} to {level} in {span}.",
    "In {span}, I had gone from level {from} to {level}.",
}
-- (engine hook: level 60 in a book begun at 50 or above, after the milestone line; the look back for a
-- short book). Tokens {fromLevel} {origin} {since}. Garrum's sixty was one line.
W.lookBackLate = {
    "{since} before, I had been level {fromLevel} in {origin}.",
    "It had been {since} since I set out from {origin} at level {fromLevel}.",
}
-- (engine hook: the first epic mount, by the kind of its summon aura; in place of milestone2.epicmount).
-- No tokens. "I rode my new mount for the first time" said of a tauren's great kodo.
W.epicMountKind = {
    kodo = {"My great kodo came when I called, and it left my old one behind.",
        "A great kodo of my own came when I called. The old one would carry packs now."},
    raptor = {"My swift raptor came when I called, and it left my old one behind.",
        "A swift raptor of my own came when I called. Nothing I had ridden before came close to it."},
    wolf = {"My swift wolf came when I called, and it left my old one behind.",
        "A swift wolf of my own came when I called. Nothing I had ridden before came close to it."},
    horse = {"My swift horse came when I called, and it left my old one behind.",
        "A swift horse of my own came when I called. Nothing I had ridden before came close to it."},
    ram = {"My swift ram came when I called, and it left my old one behind.",
        "A swift ram of my own came when I called. Nothing I had ridden before came close to it."},
    mechanostrider = {"My swift mechanostrider came when I called, and it left my old one behind."},
    saber = {"My swift saber came when I called, and it left my old one behind."},
    skeletal = {"My skeletal warhorse came when I called, and it left my old one behind."},
}
-- (engine hook: the third FALLING death in a book or more, once per book; after the death line).
-- Tokens {nth} ("third"). Wenna is the clumsy one; the count is the joke, and the engine has it.
W.fallCount = {
    "It was the {nth} time I had fallen to my death.",
}
-- (engine hook: a second death in one day by a different cause; in place of the plain death line).
-- Tokens {foe} {Foe}. "I stayed under too long, and drowned ... A Defias Bandit killed me." (Wenna 1).
-- (no ledger connective, "as well, before the day was out": reader F, 2026-11-11)
W.deathAgainDay = {
    "{Foe} got me too, my second death of the day.",
    "{Foe} killed me as well, the second time that day.",
}
-- Companion revenge (engine hook: the same fold as W.questRevenge). Tokens {foe}. Bryn II and
-- Tobias I tell the death and the quest, but not that the foe died.
if PB then
    PB.questRevenge = {
        "This time it was {foe} who died.",
        "In the end it was {foe} who went down.",
    }
end
end
end

-- A dungeon day that begins with the company going in ({When} {names} {dungeonD}).
W.openDungeonWith = {"{When}, {names} and I made for {dungeonD}.", "{When}, {names} and I set out for {dungeonD}."}
W.openDungeonWithAgain = {"{When}, {names} and I went back into {dungeonD}.", "{When}, {names} and I were back in {dungeonD}."}

-- Back after a long time, said in the opening sentence ({ago}).

-- Round 12 (the writer).
W.gatherNamedHides = {
    "I {work}, and took mostly {names}.",
    "I {work}, and most of the hides were {names}.",
}
W.classAgain = W.classAgain or {}
W.classAgain.teleport = {"I went home by magic, in the space of a breath.", "I took myself home by magic that day."}
do
    local P = A.JournalTellers
    if P and P.wry then P.wry.closetriumph = {} end
end
-- The tank's part, joined to the kill that named the boss.
W.boastHereTank = {"I took the blows the whole fight.", "nothing got past me the whole fight."}

-- Round 13 (the writer): the fifteen-life recheck.
do
local PB = A.JournalTale and A.JournalTale.phrases
local L = A.Lore
local P = A.JournalTellers
if L then

---------------------------------------------------------------------------
-- 1. FALSE OR BROKEN
---------------------------------------------------------------------------

-- PB.rolesPairClass["healer+tank"].PRIEST (mine, REWRITES8). "Bruk stood in front, and you kept him standing
-- with the Light." (Kahlu: Bruk III and IV, telling 5) is said of a troll priest. The own journal gates the
-- Light by race; this line had no gate. "prayed" holds for every priest.
if PB and PB.rolesPairClass and PB.rolesPairClass["healer+tank"] then
    PB.rolesPairClass["healer+tank"].PRIEST = {"{name} stood in front, and {I} prayed {them} through it."}
end

-- L.dungeonStory.Uldaman.whyRace (mine, REWRITES8b). With the rule "one race line per visit", the reworded
-- why ("...looking for where the dwarves came from") now takes the slot and blocks the detail that says
-- "how the earthen became my people". Thorgrim, a dwarf, lost his line in Uldaman. Emptied: the race line
-- is the detail.
L.dungeonStory["Uldaman"].whyRace = {}

-- The veteran storyteller's death lines (JournalTellers.lua). "You drowned. Mind the breath next time."
-- (Ithil IV, telling 5) and "...Watch the edges." give the reader advice. Emptied; the common pools tell
-- the death plainly.
if P and P.veteran then P.veteran.dieDROWNING = {}; P.veteran.dieFALLING = {} end

-- Sunsets after a sunset watched with company. "Ithil and I watched the sun go down over the sea at
-- Auberdine. The lamps came on along the shore behind me" (Liriel 2, telling 5). The image lines take no
-- pronoun now, so they hold for one or for two.
W.sunsetAfter["Auberdine"] = {"The lamps of the town came on along the shore, one by one."}
W.sunsetAfter["Booty Bay"] = {"The lamps came on in {p:Booty Bay}, one by one."}
W.sunsetAfter["Sen'jin Village"] = {"The fires of {p:Sen'jin Village} came on along the shore."}
W.sunsetAfter["The Savage Coast"] = {"Back from the beach, the jungle went quiet, one bird at a time."}
W.sunsetAfter.plain = {
    "The sea went red, then grey, then dark.",
    "The waves kept coming in after the light was gone.",
    "Out on the water, the light stayed longest.",
    "The first stars came out over the water.",
    "The water went gold, and then it went dark.",
}

-- Ironforge's first lore. "I was back in Ironforge, the dwarven city inside the mountain." (Thorgrim 6)
-- tells a dwarf what his own city is.
if W.towns["Ironforge"] then W.towns["Ironforge"].lore[1] = "the city cut into the mountain" end

---------------------------------------------------------------------------
-- 2. THE SAME LINES IN MANY BOOKS
---------------------------------------------------------------------------

-- W.openFirstLate -- EXTEND. "I was level N, and a long way from X, when I set out from Y." opens eight of
-- the fifteen books, the same sentence in every telling of a life. Each race gets two more shapes, and
-- "other" two more. Tokens {zoneE} {zoneD} {level}.
local late = {
    Dwarf = {"Ironforge was far behind me, and I was level {level} when I set out from {zoneE}.",
        "At level {level}, I set out from {zoneE}, a long way from the mountain."},
    Gnome = {"Ironforge was far behind me, and I was level {level} when I set out from {zoneE}.",
        "At level {level}, I set out from {zoneE}, far from the snows where my people had found a home."},
    Human = {"Stormwind was far behind me, and I was level {level} when I set out from {zoneE}.",
        "At level {level}, I set out from {zoneE}."},
    NightElf = {"Teldrassil was far behind me, and I was level {level} when I set out from {zoneE}.",
        "At level {level}, I set out from {zoneE}, a long way from the World Tree."},
    Orc = {"Orgrimmar was far behind me, and I was level {level} when I set out from {zoneE}.",
        "At level {level}, I set out from {zoneE}, a long way from the red rocks of Durotar."},
    Troll = {"The huts of Sen'jin were far behind me, and I was level {level} when I set out from {zoneE}.",
        "At level {level}, I set out from {zoneE}, a long way from the sea at Sen'jin."},
    Tauren = {"Mulgore was far behind me, and I was level {level} when I set out from {zoneE}.",
        "At level {level}, I set out from {zoneE}, a long way from the plains of Mulgore."},
    Scourge = {"The graves of Deathknell were far behind me, and I was level {level} when I set out from {zoneE}.",
        "At level {level}, I set out from {zoneE}, a long way from the glades of Tirisfal."},
    other = {"At level {level}, I set out from {zoneE}.", "My first stop, at level {level}, was {zoneE}."},
}
for race, lines in pairs(late) do
    W.openFirstLate[race] = W.openFirstLate[race] or {}
    Extend(W.openFirstLate[race], lines)
end

-- First visits told by what the record holds (editor2, 2026-11-05): who came with you, your
-- level against the country's, and where you came from. The engine turns through the shapes
-- that apply (a counter, not a draw), the plain line taking its turn among them.
W.openNewWith = {"{When}, {names} and I came to {zoneD}, my first time there.", "{When}, I came to {zoneD} for the first time, with {names}."}
W.openNewWithBare = {"{names} and I came to {zoneD}, my first time there.", "I came to {zoneD} for the first time, with {names}."}
W.openNewYoung = {"{When}, I came to {zoneD} at level {level}, young for the place.", "{When}, I came to {zoneD} early, at level {level}."}
W.openNewYoungBare = {"I came to {zoneD} at level {level}, young for the place.", "I came to {zoneD} early, at level {level}."}
W.openNewLate = {"{When}, I came late to {zoneD}, at level {level}, with its dangers below me.",
    "{When}, at level {level}, I saw {zoneD} for the first time, long after it could have troubled me."}
W.openNewLateBare = {"I came late to {zoneD}, at level {level}, with its dangers below me.",
    "At level {level}, I saw {zoneD} for the first time, long after it could have troubled me."}
W.firstZoneWith = {"{names} and I came into {zoneD}, where I had never been.", "It was my first time in {zoneD}, and {names} {were} with me."}
W.firstZoneYoung = {"I came into {zoneD} at level {level}, young for the place.", "{zoneD} was new to me, and at level {level} I was early for it."}
-- (the same, once the chapter has told the level already: the number is not said twice)
W.firstZoneYoungBare = {"I came into {zoneD} young for the place.", "{zoneD} was new to me, and I was early for it."}
W.firstZoneLate = {"I came late to {zoneD}, at level {level}, with its dangers below me.",
    "At level {level}, I saw {zoneD} for the first time, long after it could have troubled me."}
W.firstZoneFrom = {"After {from} came {zoneD}, new to me.", "{from} gave way to {zoneD}, where I had never been."}
-- The home left behind, when the sea lies between (a crossing the same day).
W.leaveHomeFirstSea = {
    Scourge = {"The sea lay between me and Tirisfal now."},
    Human = {"Elwynn was across the sea now."},
    Orc = {"The sea lay between me and Durotar now."},
    Troll = {"Durotar and the huts of Sen'jin were across the sea now."},
    Tauren = {"Mulgore was across the sea now."},
    Dwarf = {"The snows of Dun Morogh were across the sea now."},
    Gnome = {"The snows of Dun Morogh were across the sea now."},
    NightElf = {"Teldrassil was across the water now."},
}
Extend(W.leaveHomeFirst.Scourge, {"Tirisfal and its graves were behind me now."})
Extend(W.leaveHomeFirst.Human, {"The farms of Elwynn were behind me now."})
Extend(W.leaveHomeFirst.Orc, {"The red rocks of Durotar were behind me now."})
Extend(W.leaveHomeFirst.Troll, {"Sen'jin and its shore were behind me now."})
Extend(W.leaveHomeFirst.Tauren, {"The plains of Mulgore were behind me now."})
Extend(W.leaveHomeFirst.Dwarf, {"Dun Morogh and its snows were behind me now."})
Extend(W.leaveHomeFirst.Gnome, {"Dun Morogh and its snows were behind me now."})
Extend(W.leaveHomeFirst.NightElf, {"The great tree was behind me now."})
-- A book that begins in the middle of a life: with whom, where, and how high.
W.openFirstLateBond = {"{names}, {bond}, was with me when I set out from {zoneE} at level {level}.",
    "I was level {level}, with {names}, {bond}, at my side, when I set out from {zoneE}."}
W.openFirstLateWith = {"I was level {level} when {names} and I set out from {zoneE}.", "{names} and I set out from {zoneE}, I at level {level}."}
W.openFirstLateCity = {"I was level {level}, and in {zoneD}, when I set out.", "At level {level}, {zoneD} was where I set out from."}
W.openFirstLateSixty = {"I was level sixty when I set out from {zoneE}, with nothing left to climb.", "At level sixty, I set out from {zoneE}."}
-- A character who plays mostly with one companion: a day on their own, now and then, is news ({names}, {part}).
W.aloneDay = {"I was on my own that {part}.", "For once, I was out alone.", "{names} was not with me that day."}

-- W.killMany -- EXTEND (st + {bosses}). "...fell, one after the other." is in eleven of the fifteen books,
-- twenty-six times. Two more shapes.
Extend(W.killMany, {"{We} put an end to {bosses}.", "{bosses} went down in turn."})

-- W.joinedNew / W.joinedNewMany -- EXTEND (st + {names}). "I met X, and we went on together." is in seven
-- books.
Extend(W.joinedNew, {"{names}, fell in beside me.", "I was joined by {names}."})
Extend(W.joinedNewMany, {"I was joined by {names}."})

-- W.oncePerBook -- EXTEND. "Somewhere along the way I reached level {level}." is in fourteen of the
-- fifteen books and ends twenty-two chapters across the three tellings. Once a book is enough for it.
Extend(W.oncePerBook, {"Somewhere along the way I reached level {level}."})

-- PB.myLevel -- EXTEND ({I} {mine}). "You made level N along the way." is in eleven of the fifteen books.
if PB and PB.myLevel then
    Extend(PB.myLevel, {"{I} went up to level {mine}.", "By the end of it, {Iwas} level {mine}."})
end
end
end

-- More moments ("Record more moments", 2026-11-05): books and plaques read, areas
-- found, flight paths, spells from a trainer, standings, duels, trade marks,
-- honorable kills, a rare creature killed. Tokens as JournalSelfTale fills them.
W.read = {
    "I stopped to read {what}.",
    "I read {what}.",
    "I came across {what} and read it.",
    "I found {what} and read it through.",
}
W.readMany = {
    "I read {whats}.",
    "I stopped to read {whats}.",
    "There was time to read {whats}.",
}
W.readStone = {
    "I read the words cut into {what}.",
    "I stopped at {what} and read what was written on it.",
    "I read the inscription on {what}.",
}
W.readAgain = {
    "I read {what} again.",
    "I came across {what} again, and read it once more.",
}
-- ({places}: one to three names; {rest}: how many more)
W.exploreOne = {
    "I found my way to {places}.",
    "{Places} was new ground to me.",
    "I came upon {places}, which I had not seen before.",
}
W.explore = {
    "I found my way to {places}.",
    "{Places} were new ground to me.",
    "I came upon {places} for the first time.",
    "My way took me through {places}, which I had not seen before.",
}
W.exploreMore = {
    "I found my way to {places} and {rest} other places I had not seen before.",
    "{Places} were new to me, and so were {rest} more places that day.",
    "I came upon {places}, and {rest} other places I had never set foot in.",
}
W.exploreTally = {
    [50] = {"That made fifty places I had found for myself, counting from {origin}.", "Fifty places had been new ground to me by then."},
    [100] = {"That made a hundred places I had found for myself.", "A hundred places had been new to me by then, one after another."},
    [200] = {"Two hundred places had been new ground to me by then."},
}
W.taxi = {
    "I learned the flight path at {place}.",
    "The flight master at {place} would carry me from then on.",
    "From then on I could fly out of {place}.",
}
-- (the town was named a sentence or two earlier: no "there", which would point at the last place said)
W.taxiHere = {
    "I learned the flight path while I was in town.",
    "The flight master in town would carry me from then on.",
}
-- ({names}: one to three spells; {rest}: how many more)
W.learn = {
    "The trainer taught me {names}.",
    "I learned {names} from the trainer.",
    "At the trainer, I paid for {names}.",
}
W.learnMore = {
    "The trainer taught me {names}, among other things.",
    "I learned {names} and more from the trainer.",
    "At the trainer, I paid for {names} and {rest} more.",
}
-- ({faction} with its article where one belongs: "the Argent Dawn", "Orgrimmar")
W.rep = {
    friendly = {"{Faction} counted me a friend by then.", "I was in good standing with {faction} now.", "By then {faction} called me a friend."},
    honored = {"{Faction} held me in honor by then.", "By then {faction} honored my name.", "I had earned honor with {faction}."},
    revered = {"{Faction} revered me by then.", "I was revered among {faction}.", "By then {faction} revered my name."},
    exalted = {"There was no higher standing with {faction} than the one I held now.", "{Faction} held me in the highest standing they gave.",
        "I stood as high with {faction} as anyone could."},
}
-- ({who}: the other duellist; {count} {wins} for a series)
W.duelWon = {"I duelled {who} and won.", "I beat {who} in a duel.", "A duel with {who} went my way.", "{Who} and I duelled, and I won."}
W.duelLost = {"I duelled {who} and lost.", "{Who} beat me in a duel.", "A duel with {who} did not go my way.", "{Who} and I duelled, and I came off worse."}
W.duelWonFled = {"{Who} and I duelled, and {who} left the ring before it was done.", "I duelled {who}, who stepped out of bounds before the end."}
W.duelLostFled = {"I duelled {who}, and left the ring before it was done.", "{Who} and I duelled, and I was the one who stepped out of bounds."}
W.duelSeries = {"{Who} and I duelled {count} times, and I won {wins} of them.", "I duelled {who} {count} times that day and won {wins}."}
W.duelRecord = {"That made {wins} to {losses} between {who} and me.", "Between {who} and me the count stood at {wins} to {losses}."}
-- ({trade}: "cooking", "first aid")
W.skill = {
    [75] = {"My {trade} had come as far as an apprentice's can.", "I had learned all an apprentice could of {trade}."},
    [150] = {"I could call myself a journeyman at {trade} by then.", "My {trade} had reached a journeyman's."},
    [225] = {"I was an expert at {trade} by then, as the trainers reckon it.", "My {trade} had reached an expert's."},
    [300] = {"There was nothing more anyone could teach me of {trade}.", "No trainer had anything left to teach me of {trade}."},
}
-- ({count} {side} {zoneD})
W.hk = {"{Count} of the {side} fell to me in {zoneD}.", "I killed {count} of the {side} that day.", "{Count} of the {side} died by my hand there."}
W.hkOne = {"One of the {side} fell to me in {zoneD}.", "I killed one of the {side} there.", "One of the {side} died by my hand in {zoneD}."}
W.hkAfterFirst = {"{Count} of them fell to me before the day was out.", "By the end of the day, {count} of them had died by my hand."}
W.rareKilled = {"I killed {what}, a creature few ever see.", "{What} crossed my path, and I killed it, rare as it was.", "I brought down {what}, and not many can say that."}
W.titles.read = {"{what}"}
W.titles.explore = {"New Ground", "Unmapped Ground"}
W.titles.duel = {"A Duel", "A Challenge"}
W.titles.rep = {"{Faction}"}
W.titles.skill = {"{Trade}"}
W.titles.hk = {"Against the {Side}"}
W.titles.rareKilled = {"{what}"}

-- Continuity (2026-11-05): what the earlier chapters of the same book hold.
-- ({foe} {Foe}: a foe that killed you on an earlier day; {nth} {count} from the third time on)
W.deathAgainFoe = {
    "{Foe} killed me again.",
    "It was {foe} again, and again I died.",
    "{Foe} had killed me before, and did it again.",
    "For the second time, {foe} killed me.",
}
W.deathAgainFoeMany = {
    "{Foe} killed me for the {nth} time.",
    "That made {count} deaths to {foe}.",
}
-- ({boss}: a boss that killed you on an earlier day, fallen today)
W.bossRevengeLater = {
    "{Boss} had killed me once. This time it was {boss} who fell.",
    "{Boss} had beaten me before. Not this time.",
    "I had died to {boss} before, and this time {boss} died.",
}
-- ({When} {zoneD} {foe} {ago}: back where a foe killed you)
W.openBackMemory = {
    "{When}, I was back in {zoneD}, where {foe} had killed me {ago} before.",
    "{When}, I returned to {zoneD}. {Foe} had killed me there {ago} earlier.",
}
-- ({foe} {ago}: the same, said after an opening of its own)
W.backMemory = {
    "{Foe} had killed me there {ago} before.",
    "It was there that {foe} had killed me, {ago} earlier.",
    "The last time, {ago} before, {foe} had killed me there.",
}
-- ({span}: the time since the last death)
W.deathAfterLong = {
    "It was my first death in {span}.",
    "I had not died in {span}.",
}

---------------------------------------------------------------------------
-- A chapter after days apart from the last recorded one (2026-11-06): how a
-- game master opens a new night at the table. Keyed to the real gap, built
-- from what the book recorded last (the place, who was there, a dungeon, a
-- lord's fall, the level) and what is true now (the place, the hour, the
-- weekday). Elapsed time only: nothing here says what the writer did in
-- between, nor why. Buckets: short (a week to under three weeks), long (three
-- weeks to five months), longest (half a year or more, or the longest gap of
-- the book). Shapes: same (the same zone as the last chapter), else (another
-- zone the book knows), new (a first visit). Tokens: {since} ("a week", "two
-- months"), {zoneD}, {lastZone}, {part}, {weekday}.
---------------------------------------------------------------------------
W.absence = {
    short = {
        same = {
            "{Since} later, I was back in {zoneD}.",
            "{Since} went by. Then, on {weekday} {part}, I was in {zoneD} again.",
            "I came back to {zoneD} after {since}, on a {weekday} {part}.",
            "On {weekday} {part}, {since} on, I took up {zoneD} where I had left it.",
            "I saw {zoneD} again {since} later.",
            "{Since} had passed when I was next in {zoneD}.",
        },
        ["else"] = {
            "{Since} after {lastZone}, I was in {zoneD}.",
            "{Since} had passed since {lastZone}. On {weekday} {part} I set out in {zoneD}.",
            "When I next set out, {since} later, it was in {zoneD}.",
            "The next time out, {since} on, was in {zoneD}.",
            "{Since} on from {lastZone}, I went out into {zoneD}.",
            "I had been in {lastZone} the last time. {Since} later it was {zoneD}, on {weekday} {part}.",
        },
        new = {
            "{Since} after {lastZone}, I came to {zoneD} for the first time.",
            "When I next set out, {since} later, it was into {zoneD}, where I had never been.",
            "{Since} on, I went somewhere new, {zoneD}.",
        },
        with = {
            "{Since} later, {names} and I were out in {zoneD}.",
            "{Since} on, I set out with {names} in {zoneD}, on {weekday} {part}.",
            "{names} and I went out into {zoneD}, {since} after the last time.",
        },
    },
    long = {
        same = {
            "{Since} had passed, and {zoneD} was where I began again.",
            "{Since} later, on {weekday} {part}, I was back in {zoneD}, where I had left off.",
            "I had last been in {zoneD} {since} before. On {weekday} {part} I was there again.",
            "{Since} had gone by when I next set out, and {zoneD} was where I did.",
            "It had been {since}. I was in {zoneD} again.",
            "The {weekday} {part} that brought me back to {zoneD} came {since} after the last.",
            "After {since}, {zoneD} had me again.",
        },
        ["else"] = {
            "{Since} after {lastZone}, I set out in {zoneD}.",
            "{Since} had passed since {lastZone}. Now it was {zoneD}, on {weekday} {part}.",
            "When I next went out, {since} later, it was in {zoneD}, with {lastZone} behind me.",
            "{Since} on from {lastZone}, I was in {zoneD}.",
            "It had been {since} since {lastZone}. I went out into {zoneD} that {weekday} {part}.",
            "I had been in {lastZone} the last time out. {Since} later I was in {zoneD}.",
            "{Since} lay between {lastZone} and this {weekday} {part} in {zoneD}.",
        },
        new = {
            "{Since} after {lastZone}, I came to {zoneD} for the first time.",
            "It had been {since}. I set out somewhere new, {zoneD}.",
            "When I next set out, {since} on, it was into {zoneD}, where I had never been.",
            "{Since} later, {zoneD} was new ground for me.",
        },
        with = {
            "{Since} had passed when {names} and I set out in {zoneD}.",
            "After {since}, {names} and I were out together in {zoneD}.",
            "{Since} later, {names} and I set out in {zoneD}.",
            "It had been {since} when {names} and I set out in {zoneD}, on {weekday} {part}.",
        },
    },
    longest = {
        same = {
            "{Since} had passed since I had last been in {zoneD}. On {weekday} {part}, I was there again.",
            "{Since} went by. Then, on {weekday} {part}, I was back in {zoneD}.",
            "It was {since} later that I stood in {zoneD} once more, on a {weekday} {part}.",
            "{Since} after the last time, {zoneD} was where I began again.",
        },
        ["else"] = {
            "{Since} had passed since {lastZone}. I set out again in {zoneD}, on {weekday} {part}.",
            "{Since} after {lastZone}, I set out in {zoneD}.",
            "It had been {since} since {lastZone}, and {zoneD} was where I went out next.",
            "{Since} lay between {lastZone} and that {weekday} {part} in {zoneD}.",
            "{Since} later, on {weekday} {part}, I was out in {zoneD}. The last place had been {lastZone}.",
        },
        new = {
            "{Since} after {lastZone}, I saw {zoneD} for the first time.",
            "After {since}, I came somewhere new, {zoneD}.",
            "{Since} had passed since {lastZone}. {ZoneD} was new to me.",
        },
        with = {
            "{Since} had gone by when {names} and I set out in {zoneD}, on {weekday} {part}.",
            "After {since}, I was out again, with {names}, in {zoneD}.",
            "{Since} later, {names} and I were in {zoneD}.",
        },
    },
}
-- The second sentence of such an opening, from what the last chapter recorded
-- ({lastZone} {names} {lastDungeon} {lastLord} {level} {lastLevel} {up}). Told
-- on the long gaps, not in Highlights.
W.absenceRecap = {
    company = {
        "The last time out, {names} had been with me, in {lastZone}.",
        "{names} had been with me that last time.",
        "{lastZone} had been the last place, with {names}.",
    },
    lord = {
        "The last time out had ended with {lastLord} dead in {lastDungeon}.",
        "{lastLord} had fallen in {lastDungeon} the last time out.",
        "The time before, {lastDungeon} had been the end of the day, and {lastLord} with it.",
    },
    dungeon = {
        "The last time out had taken me into {lastDungeon}.",
        "{lastDungeon} had been the last place I went down into.",
    },
    levelUp = {
        "I was level {level} by then, up from {lastLevel}.",
        "Since then I had gone from level {lastLevel} to {level}.",
        "I had been level {lastLevel} the last time, and was {level} now.",
    },
    levelSame = {
        "I was still level {level}.",
        "I was level {level}, as I had been.",
    },
}
-- ({thread} {span}: a thread taken up again after a week or more)
W.threadSince = {
    "It was {span} since I had first taken up {thread}.",
    "{Span} had passed since {thread} first came my way.",
    "{Thread} had been waiting {span}.",
}
-- ({names}: the tenth, twenty-fifth and fiftieth recorded day out with the same companion)
W.companionDays = {
    [10] = {"That made ten days {names} and I had been out together.", "It was the tenth day {names} and I had spent out together."},
    [25] = {"That made twenty-five days out with {names}.", "Twenty-five days {names} and I had been out together by then."},
    [50] = {"{names} and I had been out together on fifty days by then.", "That made fifty days out with {names}."},
    [100] = {"{names} and I had been out together on a hundred days by then."},
}
W.titles.companionDays = {[10] = "Ten Days Together", [25] = "Twenty-Five Days Together", [50] = "Fifty Days Together", [100] = "A Hundred Days Together"}
-- Tallies of a life, once each.
W.questTally = {
    [100] = {"A hundred quests lay behind me by then.", "That made a hundred quests, by my own count."},
    [250] = {"Two hundred and fifty quests lay behind me by then."},
    [500] = {"Five hundred quests lay behind me by then, and the askers had not run out."},
}
W.dungeonTally = {
    [10] = {"That was my tenth dungeon.", "That made ten dungeons since my first."},
    [25] = {"That made twenty-five dungeons."},
    [50] = {"Fifty dungeons lay behind me by then."},
}
W.deathTally = {
    [10] = {"That was the tenth time I had died.", "Ten deaths, by then."},
    [25] = {"That made twenty-five deaths."},
    [50] = {"Fifty times I had died by then."},
}
W.caveTally = {
    [10] = {"That was the tenth cave or mine I had gone down into.", "Ten caves and mines now, by my own count."},
    [25] = {"That made twenty-five caves and mines."},
}
-- ({names} {count}: a companion who died twice or more in one stretch)
W.partyDeath.twice = {
    "{names} died there, {count}.",
    "{names} died {count} that day.",
}

---------------------------------------------------------------------------
-- The important moments of a life (milestones lane, 2026-11-06): each told
-- once, through its consequence and a concrete noun. Tokens as noted.
---------------------------------------------------------------------------
-- The first mount without its kind ({zoneD})
W.milestone2.mount = {
    "For the first time, I rode a mount of my own, and {zoneD} went by faster than my feet had ever managed.",
    "A mount of my own came when I called. Forty levels of walking ended that day.",
    "I had a mount of my own at last, and the long walks were over.",
}
W.milestone2.epicmount = {
    "My new mount came when I called, and it left my old one behind.",
    "I rode out on my new mount, and nothing I had ridden before came close to it.",
}
-- (the thousand gold fell the same day: {kind})
W.epicMountPrice = {
    "A thousand gold went for it, and a swift {kind} came when I called.",
    "The thousand gold I had saved went for a swift {kind}, and it left my old one behind.",
}
-- Gold (first:gold, c = 1 | 100 | 1000)
W.gold = {
    [1] = {"For the first time, I had a whole gold piece to my name.",
        "A gold piece was mine that day, the first I had ever held whole.",
        "My purse held its first whole gold piece that day."},
    [100] = {"My purse held a hundred gold for the first time.",
        "A hundred gold was mine, more than I had ever carried.",
        "For the first time, there was a hundred gold in my purse."},
    [1000] = {"A thousand gold lay in my purse for the first time, the kind of sum a swift mount costs.",
        "For the first time, I had a thousand gold to my name.",
        "My purse held a thousand gold, more than it had ever held."},
}
W.milestone2.gold = {"For the first time, I had gold of my own in my purse."}
W.titlesGold = {[1] = {"The First Gold Piece"}, [100] = {"A Hundred Gold"}, [1000] = {"A Thousand Gold"}}
-- Level ten with the first talent point ({class}: "hunter")
W.milestoneTalent = {
    "I reached level ten, and had my first talent point to spend.",
    "Level ten came that day, and with it the first point to spend on what kind of {class} I would be.",
    "I made level ten, and a talent point waited to be spent for the first time.",
}
W.milestone2.talent = {"I had my first talent point to spend."}
-- The sixty look-back, a third sentence ({killer}, {Killer}: the first named foe that killed me in the book)
W.lookBackKiller = {
    "The first thing to kill me had been {killer}.",
    "At the start, {killer} had been enough to kill me.",
    "{Killer} had killed me once, near the beginning. It would not now.",
}
-- Epic, legendary
W.milestone2.epic = {
    "{what} was mine, the finest thing I had ever carried.",
    "I took {what} from the spoils, the first of its kind I had ever held.",
    "{what} came into my hands, and nothing else I owned came close to it.",
    "{what} was mine. Everything else on my back looked plain beside it.",
}
W.milestone2.legendary = {
    "{what} was mine. There are few like it in the world.",
    "{what} was mine, one of a handful in all the world.",
    "Few hands in the world had held {what}, and now mine had.",
}
-- Tier: the first piece ({what}; {where} the raid it comes from; the dungeon set says so)
W.milestone2.tier = {
    "I put on the first piece of {what}.",
    "The first piece of {what} was mine.",
    "I wore the first piece of {what}, with seven to find.",
}
W.tierWhere = {
    "I put on the first piece of {what}. The rest of it was still in {where}.",
    "The first piece of {what} was mine. {Where} held the other seven.",
}
W.tierDungeon = {
    "I put on the first piece of {what}, the set the dungeons give out a piece at a time.",
    "The first piece of {what} was mine, one of the eight the dungeons hand out.",
}
-- The whole set ({span} since the first piece and {visits} to its home, when the record has both)
W.milestone2.setfull = {
    "The last piece of {what} was mine, and I wore all of it.",
    "For the first time, I wore the whole of {what}.",
    "With the last piece, I wore all of {what} at once.",
}
W.setfullSpan = {
    "With the last piece, I wore the whole of {what}. It had taken {span} and {visits} to gather.",
    "The last piece of {what} was mine, {span} and {visits} after the first.",
}
-- A world boss ({what}, {epithet} from Lore, {zoneD})
W.milestone2.worldboss = {
    "{what}, {epithet}, fell in {zoneD}, and I had a hand in it.",
    "I was one of the many who brought down {what} in {zoneD}.",
    "{what} came down in {zoneD}. I had been one of the crowd under it.",
    "{what} fell to a crowd of us, and I was in the crowd.",
}
-- The first raid ({what}, {lore} from the dungeon's own lines)
W.milestone2.raid = {
    "For the first time, I went into {what} with a company larger than any I had fought beside.",
    "My first raid took me into {what}, {lore}.",
    "{what} was my first raid. There were more of us than I had ever stood among.",
    "I joined my first raid, and we went into {what}.",
}
-- A raid's lord, the first time it falls in the book ({boss}, {epithet}); its Lore after line follows
W.lordFell = {
    "{boss}, {epithet}, fell to us for the first time.",
    "For the first time, we brought down {boss}, {epithet}.",
    "{boss}, {epithet}, fell for the first time with me there to see it.",
}
-- Trades at three hundred, by their noun
W.skillTop = {
    Tailoring = {"No trainer in the world had a stitch left to teach me.", "My tailoring had reached three hundred, as far as the needle goes."},
    Blacksmithing = {"No smith anywhere had a stroke left to teach me at the anvil.", "My blacksmithing had reached three hundred, as far as the hammer goes."},
    Alchemy = {"No trainer had a recipe left to teach me at the vials.", "My alchemy had reached three hundred, as far as the trade goes."},
    Enchanting = {"No enchanter had a formula left to teach me.", "My enchanting had reached three hundred, as far as the rod goes."},
    Engineering = {"No tinker anywhere had a schematic left to teach me.", "My engineering had reached three hundred, as far as the wrench goes."},
    Leatherworking = {"No trainer had a pattern left to teach me at the awl.", "My leatherworking had reached three hundred, as far as the trade goes."},
    Mining = {"No trainer had anything left to teach me about the pick.", "My mining had reached three hundred, as far as the pick goes."},
    Herbalism = {"No trainer had a plant left to teach me.", "My herbalism had reached three hundred, as far as the trade goes."},
    Skinning = {"No trainer had anything left to teach me about the knife.", "My skinning had reached three hundred, as far as the knife goes."},
    Cooking = {"No cook anywhere had a recipe left to teach me.", "My cooking had reached three hundred, as far as the pot goes."},
    ["First Aid"] = {"No trainer had a bandage left to teach me.", "My first aid had reached three hundred, as far as the trade goes."},
    Fishing = {"No trainer had a cast left to teach me.", "My fishing had reached three hundred, as far as the line goes."},
}
-- (the second main trade at three hundred: {trade})
W.skillTopBoth = {
    "With that, both my trades stood at three hundred.",
    "My {trade} had reached three hundred too, and both my trades were as far as they go.",
}
-- The first epic made by my own hands ({what}, {trade} lower case, {tool})
W.craftTools = {Blacksmithing = "anvil", Tailoring = "loom", Engineering = "bench", Alchemy = "vials", Enchanting = "rod", Leatherworking = "awl",
    Cooking = "pot"}
W.craftEpic = {
    "{what} came off my own {tool}, the first epic thing I ever made.",
    "I made {what} myself, the first epic to come from my {trade}.",
    "{what} was my own work, and the finest thing my {trade} had ever made.",
}
W.milestone2.craftepic = {"I made {what} myself, the first epic thing to come from my own hands."}
-- (the crafting line of the day has named it already: "It")
W.craftEpicIt = {
    "It came off my own {tool}, the first epic thing I ever made.",
    "It was my own work, and the finest thing my {trade} had ever made.",
    "It was the first epic to come from my {trade}.",
}
-- A PvP rank ({rank}: the title; {mySide}; {side} the enemy; {kills} lifetime honorable kills)
W.rank = {
    "The {mySide} gave me the rank of {rank}.",
    "I was {rank} now, in the {mySide}'s own reckoning.",
    "The rank of {rank} came that day.",
}
W.rankKills = {
    "The {mySide} gave me the rank of {rank}. {Kills} of the {side} had fallen to me by then.",
    "I was {rank} now, with {kills} honorable kills behind the title.",
}
-- Exalted, by faction (a concrete consequence where there is one)
W.exaltedBy = {
    ["Timbermaw Hold"] = {"The Timbermaw held me as high as any outsider, and their tunnels were open to me.",
        "There was no higher standing with the Timbermaw than the one I held now, and their guards let me pass."},
    ["Wintersaber Trainers"] = {"The Wintersaber Trainers held me as one of their own, and the frostsabers of Winterspring were open to me."},
    ["Argent Dawn"] = {"The Argent Dawn held me in the highest standing it gives."},
    ["Cenarion Circle"] = {"The Cenarion Circle held me in the highest standing it gives."},
    ["Thorium Brotherhood"] = {"The Thorium Brotherhood held me as high as it holds anyone, and its forges had no secrets from me."},
}
-- The first of the other side ever to kill me (once a book, a book kept from the start)
W.deathPvpFirst = {
    "{ARace} {class} of the {side} killed me, the first of them ever to do it.",
    "It was {aRace} {class} who killed me, the first of the {side} to manage it.",
    "I had died to beasts and bandits before that day. {ARace} {class} of the {side} was the first of them to kill me.",
}
-- A warlock's first demon
W.classFirst.imp = {"An imp answered my first summons, and it followed me from then on.", "I bound my first demon, an imp, and it came when I called."}
if W.titles.classBy then W.titles.classBy.imp = {"The Imp"} end
-- One more shape each: a blue, a stranger's rez, a guild, a hearth, a flight
W.rare[#W.rare + 1] = "{what} came out of the fight, and it was better than anything on my back."
W.rezStranger[#W.rezStranger + 1] = "I owed the rest of that day to {by}, a stranger who stopped for me."
W.guild[#W.guild + 1] = "I joined {guild}, and its name stood under mine from then on."
W.home[#W.home + 1] = "From that night, the stone in my pack pointed to {place}."
W.flight[#W.flight + 1] = "I took my first flight, and the country I had walked went by under me in minutes."
W.titles.rank = {"{what}"}
W.titles.craftepic = {"{what}", "My Own Work"}
W.titles.epicmount = {"A Swift Mount", "In the Saddle"}
W.titles.gold = {"A Full Purse"}
W.titles.talent = {"Level Ten"}

-- Battlegrounds (2026-11-06, battlegrounds lane): one passage per battleground
-- per day, from the match results the recorder keeps ("Record more moments").
-- Tokens: {what} the place, {mySide}/{foeSide} ("the Horde"/"the Alliance"),
-- {n}/{N} a count in words, {times} ("twice", "six times"), {ordinal} ("third"),
-- {ordinals} ("third and fourth", "next three"), {length} ("about forty
-- minutes"), {names}, {part} (evening), {wins}/{losses}, {k} (matches together).
-- What the place is, the first time (Everything only). Sources: the game's own
-- battlemaster descriptions; LorePlaces.lua battleground:darkspear-islands.
W.bgPlace = {
    ["Warsong Gulch"] = {
        "The Silverwing Sentinels and the Warsong Outriders fought there over the timber of Ashenvale, and each side carried the other's flag home to score.",
        "Two keeps faced each other across a cut of Ashenvale forest, the Warsong Outriders in one and the Silverwing Sentinels in the other, and the flag was the whole fight.",
    },
    ["Arathi Basin"] = {
        "The League of Arathor and the Forsaken Defilers fought over the farm, the mine, the mill, the stables and the smithy of the basin, and the side that held more of them longer won.",
        "Five bases lay around the basin, and whichever army held more of them drew more from the land until the other gave out.",
    },
    ["Alterac Valley"] = {
        "The Stormpike dwarves and the Frostwolf orcs had fought over the valley for years, from Dun Baldar in the north to Frostwolf Keep in the south.",
        "The valley ran the length of a day's march, bunkers, towers and graveyards between the two keeps, and a battle there could last for hours.",
    },
    -- (the Darkspear Islands have their own zone lines in Lore.lua)
}
-- The first battleground ever, one match: its result after W.battleground.
W.bgResultWon = {"We won it.", "The {mySide} won it.", "It ended with the {mySide} ahead."}
W.bgResultLost = {"The {foeSide} won it.", "We lost it.", "It ended with the {foeSide} ahead."}
W.bgResultDraw = {"Neither side won it."}
-- Every match won, and none won before that day.
W.bgFirstWinSweep = {"I had not won a single one before that {part}.", "Before that {part} I had never won one."}
-- A known battleground, one match.
W.bgWon = {
    "I went into {what} that {part}, and the {mySide} won it.",
    "The {mySide} won in {what} that {part}, and I was part of it.",
    "One match in {what}, and we won it.",
    "We held {what} that {part}.",
}
W.bgLost = {
    "I went into {what} that {part}, and the {foeSide} won it.",
    "The {foeSide} took {what} from us that {part}.",
    "One match in {what}, and we lost it.",
    "{What} went to the {foeSide} that {part}.",
}
W.bgDraw = {"I fought in {what} that {part}, and neither side won.", "The match in {what} ended with neither side ahead."}
W.bgWonAgain = {"Back in {what}, we won.", "{What} again, and this time the {mySide} won."}
W.bgLostAgain = {"Back in {what}, the {foeSide} won.", "{What} again, and again the {foeSide} had it."}
-- A match left before it ended (no result recorded).
W.bgLeft = {"I went into {what} that {part}.", "I answered the call to {what} that {part}."}
-- Several matches in one day: the opening.
W.bgSeries = {
    "I went into {what} {times} that {part}.",
    "{Times} that {part} the gates of {what} opened for me.",
    "The {part} went to {what}, {times} over.",
    "I answered the call to {what} {times} before the {part} was done.",
    "I went into {what} {times}.",
    "{Times} the gates of {what} opened for me.",
}
W.bgSeriesBack = {
    "Back in {what}, {n} matches.",
    "{What} again that {part}, {times}.",
    "I went back into {what} {times} that {part}.",
}
-- (the first time ever, several matches: after W.battleground and the place line; {times} is the rest)
W.bgSeriesFirst = {
    "I stayed for {n} matches.",
    "{N} matches followed, one after another.",
    "Before the {part} ended I had fought {n} matches there.",
}
W.bgAllWon = {"We won every one of them.", "The {mySide} won all {n}.", "All {n} were ours."}
W.bgAllLost = {"The {foeSide} won every one of them.", "All {n} went to the {foeSide}.", "We lost all {n}."}
W.bgBothWon = {"We won both.", "Both were ours."}
W.bgBothLost = {"We lost both.", "Both went to the {foeSide}."}
-- Runs of one result, by their place in the series.
W.bgRunOpenLost = {"The {foeSide} took the {ordinals}.", "The {ordinals} went to the {foeSide}.", "We lost the {ordinals}."}
W.bgRunOpenWon = {"We won the {ordinals}.", "The {ordinals} {were} ours.", "The {mySide} took the {ordinals}."}
W.bgRunWon = {"the {ordinals} we won", "then we won the {ordinals}", "the {mySide} took the {ordinals} back"}
W.bgRunLost = {"the {ordinals} went to the {foeSide}", "then the {foeSide} took the {ordinals}", "we lost the {ordinals}"}
W.bgRunCloseWon = {"The last we won.", "We took the {ordinals} to finish.", "The {ordinals} {were} ours, and the {part} ended on that."}
W.bgRunCloseLost = {"The last went to the {foeSide}.", "The {foeSide} took the {ordinals} to finish.", "We lost the {ordinals}, and the {part} ended on that."}
-- (the wins that followed the first win, or the turn)
W.bgRunMore = {"We won the {ordinals} as well.", "The {ordinals} followed it.", "The {ordinals} {were} ours too."}
-- (two matches, one each way)
W.bgTwoWonLost = {"We won the first and lost the second.", "The first was ours, and the second went to the {foeSide}."}
W.bgTwoLostWon = {"We lost the first and won the second.", "The first went to the {foeSide}, and the second was ours."}
-- (Highlights: the first win in a series)
W.bgFirstWinBrief = {"The {ordinal} was the first battleground I had won.", "The {ordinal} was my first win."}
W.bgTally = {"We won {wins} of them and lost {losses}.", "{Wins} of the {n} were ours, and {losses} went to the {foeSide}.", "It came to {wins} won and {losses} lost."}
-- Highlights: the count and the result in one line.
W.bgBrief = {"I went into {what} {times} that {part} and won {wins} of them.", "{Times} in {what} that {part}, {wins} of them won.", "I went into {what} {times} and won {wins} of them."}
W.bgBriefAll = {"I went into {what} {times} that {part}, and we won every one.", "I went into {what} {times}, and we won every one."}
W.bgBriefNone = {"I went into {what} {times} that {part}, and the {foeSide} won every one.", "I went into {what} {times}, and the {foeSide} won every one."}
-- The first win ever.
W.bgFirstWin = {
    "It was the first battleground I had won.",
    "Of all the matches so far, that was the first the {mySide} won with me in it.",
    "I had lost before. This one we won.",
    "My first win in a battleground came in {what}.",
}
W.bgRunFirstWin = {
    "The {ordinal} we won, the first I had ever won.",
    "Then came the {ordinal}, and the {mySide} won it, my first.",
    "The {ordinal} was the first battleground I had won.",
}
W.bgFirstLoss = {"The {foeSide} won that first one.", "My first match went to the {foeSide}."}
-- A win after two or more defeats in a row.
W.bgTurn = {
    "After {losses} defeats, the {ordinal} was ours.",
    "The {ordinal} turned it, and the {mySide} won.",
    "{Losses} losses, then the {ordinal}, which we won.",
}
-- Streaks across days (once per threshold).
W.bgStreakWon = {"That made {n} wins in a row.", "The {mySide} had won {n} in a row with me in them."}
W.bgStreakLost = {"That made {n} defeats in a row.", "The {foeSide} had taken {n} in a row from us."}
-- Length.
W.bgLong = {"The {ordinal} ran for {length}.", "One of them, the {ordinal}, went on for {length}."}
W.bgLongOne = {"It ran for {length}.", "The match went on for {length}."}
W.bgLongest = {"It was the longest I had fought in."}
W.bgQuick = {"The {ordinal} was over in {length}.", "The {ordinal} lasted {length} and no more."}
W.bgQuickOne = {"It was over in {length}.", "The whole match took {length}."}
-- A personal mark.
W.bgFlags = {"I carried the flag home {times}.", "{Times} I took their flag across the field.", "The flag crossed the field in my hands {times}."}
W.bgFlag = {"I carried the flag home once.", "Once I took their flag across the field."}
W.bgReturns = {"I returned our flag {times}.", "{Times} I brought our own flag back."}
W.bgReturn = {"I returned our flag once.", "Once I brought our own flag back."}
W.bgTopOne = {"No one on our side had more killing blows than I did.", "I had the most killing blows on our side.", "I struck more killing blows in that match than anyone else on our side."}
W.bgTop = {"In the {ordinal}, no one on our side had more killing blows than I did.", "The {ordinal} left me with the most killing blows on our side.", "I struck more killing blows in the {ordinal} than anyone else on our side."}
W.bgBases = {"I took {n} of the bases myself.", "{N} of the bases fell to me."}
W.bgBase = {"I took one of the bases myself.", "One of the bases fell to me."}
W.bgTowers = {"I took {n} towers.", "{N} of their towers fell to me."}
W.bgTower = {"I took one of their towers."}
W.bgGraveyards = {"I took {n} graveyards.", "{N} of the graveyards fell to me."}
W.bgGraveyard = {"I took one of the graveyards."}
-- Company ({names}; {k} of the matches).
W.bgWith = {"{Names} was in it with me.", "{Names} fought on our side.", "{Names} was there for it."}
W.bgWithSeries = {"{Names} was with me for {k} of them.", "{Names} fought beside me in {k} of them.", "For {k} of them, {names} was on our side."}
W.bgWithBond = {"{Names}, {bond}, was in it with me.", "{Names}, {bond}, fought on our side."}
W.bgWithBondSeries = {"{Names}, {bond}, was with me for {k} of them.", "{Names}, {bond}, fought beside me in {k} of them."}
W.titles.bgFirstWin = {"A First Victory", "The First Win"}
W.titles.bgSwept = {"Every Match", "All of Them"}
W.titles.bgSeries = {"A Night in {what}", "{What}, {Times}"}

-- The character's side of stages whose pack this file does not own, by exact quest ID
-- (DESIGN §3.0; format in JournalBook.lua, QD.Story). `title` must match the record.
-- Forever's risen paladins of Tirisfal (LoreForeverStories.lua stages) and #380, which no
-- pack covers yet (Executor Arren's spider cull in Night Web's Hollow, written from the
-- classic quest; its text is not in the captured corpus, so check it in game).
W.pov = {
    [98601] = {title = "A Difficult Path", solo = true, act = "took a scroll of the Light to Aramis Hammerhand",
        "Shadow Priest Sarvis handed {me} a scroll that reeked of the Light and wanted it read far from him. Aramis Hammerhand began {my} training as a paladin, and warned that the Light would hurt now.",
        "A scroll for a risen paladin had come to the village, and it was for {me}. Aramis Hammerhand began {my} training, and told {me} the pain of the Light was a crucible."},
    [90902] = {title = "Rediscovering the Light", solo = true, act = "healed the injured Deathguards, and the Light burned as it went",
        "{I} healed the injured Deathguards by the chapel, and the Light burned as it went, as Aramis had warned. He called the pain a badge of honor.",
        "Aramis set {me} to heal the wounded Deathguards near the chapel. It hurt as he had said it would, and he called the pain proof that {I} still served the Light."},
    [91208] = {title = "Coming to Terms", solo = true, act = "followed a frightened paladin into the hills and could not bring her back",
        "A newly risen paladin had fled into the hills west of the chapel, unable to bear what she had become. {I} went after her, but she could not be brought back, and Aramis prayed to the Light for her.",
        "{I} went after a risen paladin who had fled into the hills in fear. There was no bringing her back, and Aramis called her end a clean one."},
    [98389] = {title = "A Light in the Darkness", act = "cut the newly risen out of the webs in Night Web's Hollow", giver = "Aramis Hammerhand",
        "{We} went down into Night Web's Hollow, dark and thick with spiders, and cut the newly risen out of the webs. Aramis hoped it would show the others what paladins were for.",
        "In the dark of Night Web's Hollow, spiders had webbed freshly raised Forsaken. {We} freed them, as Aramis Hammerhand wanted, to show that the paladins lived to protect their people."},
    [91209] = {title = "Continue Your Training", solo = true, act = "went on to Shari Stilwell in Brill",
        "Aramis sent {me} on to Shari Stilwell in Brill for the rest of {my} training. He warned that many in the Dark Lady's service distrusted those close to the Light.",
        "{My} training passed from Aramis to Shari Stilwell in Brill, who had work for any paladin willing."},
    [380] = {title = "Night Web's Hollow", act = "thinned the spiders of Night Web's Hollow", giver = "Executor Arren", importance = 3,
        "Executor Arren wanted the spiders of Night Web's Hollow thinned. {We} went into the dark among them, where their legs scratched over the stone, and came out with far fewer left.",
        "{We} thinned the spiders of Night Web's Hollow for Executor Arren, in a cave so dark that {we} heard them before {we} saw them."},
    [99134] = {title = "Discipline", act = "punished the Deathguards on Executor Zygand's ledger",
        "Executor Zygand kept a ledger of Deathguards who had disappointed him, and since {we} had not yet, he had {us} punish them. Pain, he said, was one of the few delights left to the dead.",
        "{We} punished the Deathguards on Executor Zygand's ledger. It pleased him, and so, he said, it pleased the Dark Lady."},
    [99144] = {title = "Seeking Refuge", act = "freed Bareth Dawnstone from the zealots who held him",
        "{We} freed Bareth Dawnstone, a risen paladin, from zealots who wielded the Light with hatred. His order at Bandarion Keep welcomed any who sought the Light.",
        "{We} got Bareth Dawnstone away from the zealots who had caught him on his way from Bandarion Keep to Shari Stilwell in Brill. His order thanked {us} for saving one so promising."},
    -- (#96607, corpus_vanilla_quests.txt; no pack stage yet)
    [96607] = {title = "The Great Outdoors", act = "sat by Eleanor Shackleton's fire to learn how to rest in the wilds", giver = "Eleanor Shackleton", importance = 3,
        "Eleanor Shackleton sat {us} by her fire and walked {us} through the basics of living in the wilds. Then she sent {us} to the trainers in the village to learn a trade.",
        "By Eleanor's fire {we} learned how to rest and prepare out in the wilds, as an adventurer must."},
}
-- An inn that has a name of its own ({place} = "the Gallows' End Tavern"), 2026-11-07.
W.innNamed = {"{We} rested at {place}.", "{We} took a room at {place}.", "{We} stopped at {place} to rest."}
W.homeNamed = {"I made {place} my home.", "I set my hearthstone at {place}.", "From then on, my hearthstone took me back to {place}."}
W.homeNamedHere = {"I set my hearthstone there.", "I made it my home."}
W.sleepInnNamed = {"That night I slept at {place}.", "I slept at {place} that night."}

-- The hero's journey by level in the engine's own lines (DESIGN §3.0 rule 6, 2026-11-07): the
-- level lines, and the first page of a book begun late, by the stage of the climb. A novice
-- (under 20) finds it all new, a seasoned traveller (20-44) is surer, a known figure (45 and up)
-- has most of the climb behind them. Plain lines stay in each pool, so the voice is heard, not
-- hammered. One felt touch at most; never a claim about the past.
W.levelBand = {
    novice = {
        "I reached level {level} that day.",
        "I made level {level}, still learning as I went.",
        "I reached level {level}.",
        "I climbed to level {level}.",
        "By the end of the day I was level {level}.",
    },
    seasoned = {
        "I reached level {level}.",
        "I made level {level} somewhere along the way.",
        "I went up to level {level}, more at home on the road by now.",
        "I climbed to level {level} and took it in my stride.",
    },
    known = {
        "I reached level {level}, with the top of the climb in sight.",
        "I made level {level}, another step near the end of the climb.",
        "I reached level {level}.",
        "By the end of the day I was level {level}, well up the climb.",
    },
}
W.levelsBand = {
    novice = {
        "I went from level {from} to {level} that day.",
        "I climbed from level {from} to {level}, learning as I went.",
        "I went from level {from} to {level}.",
    },
    seasoned = {
        "I went from level {from} to {level}.",
        "I climbed from level {from} to {level}, steadily now.",
        "By the end of the day I had gone from level {from} to {level}.",
    },
    known = {
        "I went from level {from} to {level}, closer to the top.",
        "I climbed from level {from} to {level}, and the end of the climb was nearer.",
        "I went from level {from} to {level}.",
    },
}
-- The first page of a book begun after level ten: where the character stood on the climb. The
-- engine takes these one book in two (the race's own lines the other), by the stage.
W.openFirstLateBand = {
    novice = {
        "Still new to all of it at level {level}, I had come as far as {zoneE}.",
        "I was still finding my feet at level {level}, out in {zoneE}.",
    },
    seasoned = {
        "By level {level} I knew how to look after myself, and my travels had brought me to {zoneE}.",
        "At level {level}, no longer new to any of this, I was in {zoneE}.",
    },
    known = {
        "At level {level}, with most of the climb behind me, I was in {zoneE}.",
        "Most of the climb lay behind me at level {level}, and my travels had brought me to {zoneE}.",
    },
}
-- The first chapter's title, by the people a life begins among (2026-11-07).
W.titles.originRace = {
    Scourge = {"A Second Life", "The Waking"},
}

-- The planned telling of your own book (JournalSelfPlan.lua, Settings > Testing > Storyteller).
-- Each line states a recorded fact: the day had two sittings, the hearthstone was used and a
-- death followed within minutes, ore was mined and smelted, a level came, the hour you stopped.
W.plan = {
    short = {"{When} I was out only a short while."},
    hearthDeath = {"My hearthstone took me back to {town}, and {foe} killed me within minutes."},
    joined = {"{When}, {names} joined me in {zone}."},
    killed = {"{foe} killed me{where}."},
    forge = {"At the forge I smelted what I had mined and worked a while at the anvil.", "I smelted my ore at the forge, then took a turn at the anvil."},
    smelt = {"At the forge I smelted what I had mined."},
    -- (leads the day's gathering tally, which the teller places at the end: "Along the way I mined sixteen veins.")
    along = {"Along the way"},
    trade = {
        Blacksmithing = {"I worked a while at the anvil."},
        Cooking = {"I cooked what I had been carrying."},
        ["First Aid"] = {"I made up bandages from the cloth I had."},
        Tailoring = {"I sat a while with needle and cloth."},
        Leatherworking = {"I worked the hides I had into leather goods."},
        Alchemy = {"I mixed what potions my herbs allowed."},
        Engineering = {"I spent a while over my tools."},
        Enchanting = {"I worked a while at my enchanting."},
        crafting = {"I spent a while at my trade."},
    },
    level = {"By then I had reached level {level}."},
    levelCame = {"That brought me to level {level}."},
    levelHour = {"Within the hour I reached level {level}."},
    levelSoon = {"Soon after, I reached level {level}."},
    levelWith = {", and that brought me to level {level}"},
    stopped = {"I stopped {clock}."},
    -- Pass 2 (2026-11-09). A stretch without the companion ({When}: "Sunday afternoon").
    alone = {"{When} I went out alone.", "{When} I was out on my own."},
    -- (levels shared with the companion; {gap}: "a minute later", "soon after")
    bothLevel = {"We had both made level {level} by then.", "By then we were both level {level}."},
    mateLevel = {"{name} made level {level} {gap}.", "{name} reached level {level} {gap}."},
    -- (the close, on place or company with the hour; {place} a town or a land, {clock}: "a little after one")
    closeWePlace = {"We stopped in {place} {clock}.", "We ended the day in {place} {clock}."},
    closeIPlace = {"I stopped in {place} {clock}.", "I ended the day in {place} {clock}."},
    closeWe = {"We stopped {clock}.", "We left it there {clock}."},
    closeI = {"I stopped {clock}.", "I left it there {clock}."},
    -- The close that carries the day's last level (kept out of a peak, death or feeling paragraph).
    closeLevelWe = {"By the time we stopped, {clock}, I was level {level}.", "When we stopped, {clock}, I had reached level {level}."},
    closeLevelI = {"By the time I stopped, {clock}, I was level {level}.", "When I stopped, {clock}, I had reached level {level}."},
    closeLevelBoth = {"By the time we stopped, {clock}, we were both level {level}."},
    -- (callbacks the record proves. backDeath is a clause set into the task's own sentence;
    -- {when}: "that evening", "the night before". backFoe: {foe} is the kind, in the plural.)
    backDeath = {", where {foe} had killed me {when}"},
    backFoe = {"They were the same {foe} that had killed me {when}.", "Here were the {foe} that had killed me {when}."},
    backPlace = {"It stood where {name} had said it would.", "This was the place {name} had told me of."},
    -- (the first sentence of a book begun beside someone close; {mate}: "wife". The list is for
    -- any people; a people's own opening stands under its key. originTail joins a W.origin head.)
    origin = {"I began at {place}, with my {mate} {name} beside me.",
        Scourge = {"My second life began at {place}, with my {mate} {name} beside me."},
    },
    originTail = {", with my {mate} {name} beside me."},
}

---------------------------------------------------------------------------
-- A run of deaths told as one passage (2026-11-11, DESIGN §3.0): a lost fight or a bad
-- hour in the order it happened, not a line per zone (ST.DeathRuns, DeathPassage in
-- JournalSelfTale.lua). Tokens: {foe} {Foe} (the killer, "a Rot Hide Brute" or "Bishop
-- Jericho"), {names} (the party who fell, each name once), {count} ("twice", "three times
-- between them"), {all} ("three", for "all three of us"), {us} {our} {Our} {we} {We},
-- {zoneD} {ZoneD}, {sub} {Sub} (the place inside the zone where it began), {mins} {Mins}.
---------------------------------------------------------------------------
W.deathRun = {
    -- the lost first fight in a dungeon the day went back into
    firstTry = {"The first try went badly.", "{Our} first try went badly.", "The first time in, it went badly."},
    -- the signal, once a chapter: more than one fight lost (the zone lines only when it was not just named)
    open = {"It went badly from there.", "The next while went badly for {us}.", "{ZoneD} nearly finished {us}."},
    openSub = {"{Sub} was another matter.", "{Sub} nearly finished {us}.", "It went badly at {sub}."},
    -- a second bad stretch the same day
    openAgain = {"{ZoneD} was no kinder.", "It was no kinder there.", "{ZoneD} was no better."},
    -- one lost fight, all of us ({names} the party who fell)
    wipeMeFirst = {"{Foe} killed me, and {names} fell with me.", "{Foe} killed me, and {names} went down after me."},
    wipePartyFirst = {"{names} fell, and {foe} killed me after.", "{names} went down first, and {foe} finished me."},
    -- the first fight of a bad stretch
    firstMe = {"{Foe} killed me first.", "{Foe} got me first.", "The first to kill me was {foe}."},
    firstMeParty = {"{Foe} killed me first, and {names} with me.", "{Foe} took {names} and me together."},
    firstPartyMe = {"{names} fell first, and then {foe} killed me.", "{names} went down first, and {foe} finished me."},
    firstParty = {"{names} fell first.", "{names} went down first."},
    -- (the same fights when the day's record had a death before or after them: no "first", no "last")
    plainMe = {"{Foe} killed me.", "{Foe} got me."},
    plainMeParty = {"{Foe} took {names} and me together.", "{Foe} killed me, {names} with me."},
    plainPartyMe = {"{names} fell, and then {foe} killed me.", "{names} went down, and {foe} finished me."},
    partyEarly = {"{names} fell within minutes of {our} coming.", "{names} went down within minutes of {our} coming."},
    -- a companion who fell more than once in the fight that killed me ({count})
    partyCountThenMe = {"{names} fell {count} before {foe} killed me.", "{names} went down {count} before {foe} finished me."},
    meThenPartyCount = {"{Foe} killed me, and {names} fell {count} after.", "{Foe} killed me, and {names} went down {count} before it was over."},
    -- no killer in the record
    meAndPartyPlain = {"I died, and {names} with me.", "{names} and I all went down."},
    -- the fights in the middle that someone ended with a raise ({by}: "Varreth" or "Ralph Cuthbridge, a stranger,")
    midRez = {"{By} raised me after {foe} got me.", "{Foe} got me, and {by} raised me."},
    midRezParty = {"{Foe} took {names} and me together, and {by} raised me.", "{Foe} killed me, {names} with me, and {by} raised me."},
    midParty = {"{Foe} took {names} and me together.", "{Foe} killed me, {names} with me."},
    -- several raises in the middle, folded ({raisers}: "Pip and Faelyn", {count}: "three times")
    midRezMany = {"{Raisers} raised me {count} between them.", "{Raisers} picked me up {count} between them."},
    midRezSame = {"{Raisers} raised me {count} more.", "{Raisers} picked me up {count} after that."},
    -- the party alone, in the middle or at the end
    party = {"{names} fell.", "{names} went down."},
    partyCount = {"{names} fell {count}.", "{names} went down {count}."},
    lastParty = {"{names} fell last.", "Last of all, {names} fell."},
    -- (lane O8: two of the party by name when "between them" was said once already in the chapter)
    partyEach = {"{first} fell {firstTimes}, and {second} {secondTimes}.", "{first} went down {firstTimes}, {second} {secondTimes}."},
    -- the deaths nobody raised me from ({count}: "twice", "three times")
    walked = {"{Count} more I died and walked back as a ghost.", "{Count} more I died, and came back from the graveyard on my own feet."},
    diedMore = {"{Count} more I died before it was over.", "{Count} more deaths came between."},
    -- the last fight: a named foe, a kind of foe, with or without the party
    lastNamed = {"{Foe} ended it.", "{Foe} finished it."},
    lastNamedParty = {"{Foe} ended it, and {names} went down after me.", "{Foe} ended it, and {names} fell after me."},
    lastMe = {"The last of it was {foe}.", "{Foe} killed me a last time.", "{Foe} ended it."},
    lastMeParty = {"{Foe} ended it, and {names} fell with me.", "{Foe} killed me a last time, and {names} after me."},
    lastPartyMe = {"{names} fell, and {foe} finished me.", "{names} went down, and {foe} ended it."},
    lastPartyAgainMe = {"{names} went down again, and {foe} finished me.", "{names} fell a second time, and then {foe} killed me."},
    -- someone who raised me and is not of my list ({by})
    rezStranger = {"{by}, a stranger, stopped to raise me.", "{by}, whom I had never met, stopped and raised me."},
    -- someone of the party who is of no list, the first time they are named ({name})
    newcomer = {"a newcomer named {name}", "{name}, who had joined {us} for it,"},
    -- several fights as one sentence (reader G, 2026-11-11): one killer or one kind of killer named
    -- once ({fam}: "the Rot Hides", "Foe Reaper 4000", "the Mountain buzzards"; {count}: "three
    -- times", "five times in half an hour"; {more}: " more" after a first fight told on its own;
    -- {with}: ", Dahlia with me twice and Varreth once" or nothing; {raised}: ", and each time
    -- Varreth raised me" or nothing)
    group = {"{Fam} killed me {count}{more}{with}{raised}.", "{Count}{more} {fam} killed me{with}{raised}."},
    -- the whole stretch in one sentence ({count}: "three times in half an hour")
    groupAll = {"{Fam} killed me {count}{with}{raised}."},
    -- one fight in the middle, its killer named
    groupOne = {"{Fam} got me{with}{raised}.", "{Fam} killed me{with}{raised}."},
    -- killers of every kind: the count, and the one with a name among them ({named})
    groupMixed = {"{Count}{more} I died{with}{raised}.", "{Count}{more} I went down{with}{raised}."},
    groupNamed = {"{Count}{more} I died, once to {named}{with}{raised}."},
    -- (the count at the end is gone: the group sentence carries it)
    count = {"{Count} deaths in {span}, and {tally} besides.", "{Count} deaths in {span}, and {tally} as well."},
    countAlone = {"{Count} deaths in {span}.", "I died {count} times in {span}."},
    -- a felt line, once a book: the first raise, pointing back to the one who taught it ({teacher},
    -- from an earlier chapter)
    feltTaught = {"It was what {teacher} had taught me for.", "It was for this that {teacher} had taught me."},
}

-- The composer's own lines (JournalSelfCompose.lua, 2026-11-11): a level put where it came, a
-- companion gone before a bad stretch, and the chapter's close built from the record (what the
-- evening came to, then where it ended). {place}, {from}, {dungeon}, {lord}, {foe} are places and
-- names; {span} is the day's length in words, {crossings} the sea crossings, {part} the part of
-- the day the record began in.
W.compose = {
    levelSoon = {"Level {level} came not long after.", "Level {level} came soon after."},
    levelAt = {"Level {level} came at {place}.", "At {place}, level {level} came."},
    levelIn = {"Level {level} came in {zone}.", "Somewhere in {zone}, level {level} came."},
    -- (lane S: the level as a clause of the deed it came with, when that sentence can take one)
    levelClause = {"and level {level} came with it", "and that took me to level {level}"},
    left = {"{name} had left us by then.", "{name} {was} gone by then."},
    -- (lane S: someone named later in the chapter whose joining the teller never said)
    joinedLate = {"{name} had joined us by then.", "{name} was with us by then."},
    -- (lane P7: the same, for someone the book never named before: who they are, "a Forsaken paladin")
    joinedLateNew = {"{name}, {who}, had joined us by then.", "{name}, {who}, was with us by then."},
    -- (lane P7: the level in the close, when its deed could not take it as a clause)
    closeLevel = {"I was level {level} by the end of it.", "By the end of it I was level {level}."},
    closeLevels = {"{Count} levels had come by the end of it, and I was level {level}.", "I was level {level} by the end of it, {count} levels on."},
    byWay = {"{We} went on by way of {stops}.", "The road took {us} on by way of {stops}."},
    moveFlew = {"{We} flew to {place}.", "A flight took {us} to {place}."},
    moveVoyage = {"{We} took the {how} to {place}."},
    moveHearth = {"My hearthstone took me back to {place}."},
    -- (lane O8: the firsts of a crossing run in one sentence, and a place with no told work named
    -- only as a first; a level that came at a burst of hand-ins)
    crossRun = {"By way of {places}, new to {us}, {we} came into {zoneD}."},
    crossRunNew = {"By way of {places}, {we} came into {zoneD}, all of it new to {us}."},
    -- (round 11: the legs of a road between told stops, from the record)
    roadLegs = {"By {modes}, {we} came on to {dest}{new}."},
    roadLegsHearthFrom = {"From {origin}, new to {us}, {our} hearthstones took {us} back to {place}. By {modes}, {we} came on to {dest}{new}."},
    roadLegsHearth = {"{Our} hearthstones took {us} back to {place}. By {modes}, {we} came on to {dest}{new}."},
    -- (round 16: an errand's road there and back)
    errandOut = {"{We} went to {zone}."},
    -- (round 23: threads the record leaves open, said to stay open when the next step never came:
    -- Meal Appeal (97246) is followed by the lunch for Migi (97249))
    openThreads = {
        [97246] = {next = 97249, text = "The lunch itself would wait for another day."},
    },
    -- (round 22: an errand whose work the book does not tell, from the record's trip and hand-in)
    errandBare = {"{We} flew to {zone} on {errand}{back}.", "{We} went to {zone} on {errand}{back}."},
    -- (round 22: an outing with no work recorded, told as what it was)
    roamOnly = {"{We} had no errand there, only new country to see.", "{We} had no errand there, only new country to see, far beyond {our} level."},
    errandFlew = {"{We} flew to {zone}."},
    errandBack = {"{Our} hearthstones brought {us} back to {place}."},
    crossOnly = {"{Places} {were} new to {us}."},
    levelBurst = {"By then I was level {level}."},
    -- (lane O8: an adventure's record may say how many went in and that the foes were strong; told
    -- in passing, never as a count of elites)
    -- (the company of an adventure, by who they were or as strangers, and their parting; the
    -- foes, told in passing, never as a count of elites; a named one by name)
    adventureCompany = {"There {we} made common cause with {company}.", "{Company} joined {us} there."},
    adventureParted = {"After that, {them} went {their} own way.", "Then the company broke up, and {them} went {their} own way."},
    adventureDanger = {"Nothing there died easily.", "What {we} fought there took a lot of killing.", "It was hard fighting, and it went on a long while."},
    adventureNamed = {"{We} fought {names} there.", "{Names} stood against {us} there."},
    -- (lane O8: a journey told as one road. The setting out, hard or easy, with the lands crossed
    -- and, when all of it was new, that; the work far above the level; the dangers by place; one
    -- earned feeling on a hard road with others; how far and how long)
    -- (by the danger register, 0 safe to 3 deadly: the same setting out in other words)
    journeyOut0 = {"From {from}, {we} went by way of {lands} to {far}.", "{We} left {from} for {far}, through {lands}."},
    journeyOutNew0 = {"From {from}, {we} went by way of {lands} to {far}, none of it known to {us}.", "{We} left {from} for {far}, through {lands}, all of it new to {us}."},
    journeyOut1 = {"From {from}, {we} took the road to {far} and kept to it through {lands}.", "{We} left {from} for {far} and kept to the roads through {lands}."},
    journeyOutNew1 = {"From {from}, {we} took the road to {far} and kept to it through {lands}, none of it known to {us}.",
        "{We} left {from} for {far} and kept to the roads through {lands}, all of it new to {us}."},
    journeyOut2 = {"From {from}, {we} set out on the long road to {far}, and pressed on through {lands}.", "{We} left {from} for {far}, a long road, and pressed on through {lands}."},
    journeyOutNew2 = {"From {from}, {we} set out on the long road to {far}, and pressed on through {lands}, none of it known to {us}.",
        "{We} left {from} for {far}, a long road, and pressed on through {lands}, all of it new to {us}."},
    journeyOut3 = {"From {from}, {we} set out for {far}, and slipped through {lands} as best {we} could.", "{We} left {from} for {far}, and made {our} way through {lands} as best {we} could."},
    journeyOutNew3 = {"From {from}, {we} set out for {far}, and slipped through {lands}, none of it known to {us}, as best {we} could.",
        "{We} left {from} for {far}, and made {our} way through {lands}, all of it strange to {us}, as best {we} could."},
    -- (the goal named in the opening, seen through at its hand-in; far above the level, said so)
    -- (round 9: the work a chapter does not tell, folded into one plain clause by giver or place)
    foldChapter = {"Besides all this, {we} saw to {count} smaller {tasks}{where}.", "That day there {were} also {count} smaller {tasks}{where}, and {we} saw to {them}."},
    crossFold = {", and {we} saw to {count} {tasks} there."},
    foldGiversOnly = {"{We} saw to {count} {tasks} for {givers} there.", "There {we} saw to {count} {tasks} for {givers}."},
    foldPlaceOnly = {"In {place}, {we} saw to {count} {tasks}.", "{We} saw to {count} {tasks} in {place}."},
    journeyDoneToo = {"In {zone} {we} finished the rest of what {we} had come for."},
    journeyDone = {"In {far} {we} found the work {we} had come for, and saw it done."},
    journeyDoneAbove = {"In {far} there was work meant for travellers far stronger than {us}, and {we} saw it through all the same."},
    journeyKilled = {[0] = "killed me", [1] = "killed me", [2] = "cut me down", [3] = "cut me down"},
    journeyHardFelt = {"It was a hard road, and I was glad not to walk it alone.", "It was a hard road, and I was glad of the company on it."},
    journeyDangerous = {"Nothing on that road died easily.", "What lived along that road took a lot of killing."},
    journeyBack0 = {"In {span}, {we} had gone to {far} and back.", "{We} had been to {far} and back in {span}."},
    journeyBack1 = {"In {span}, {we} had been to {far} and back.", "{We} had been to {far} and back in {span}."},
    journeyBack2 = {"In {span}, {we} had made it to {far} and back.", "{We} had made it to {far} and back in {span}."},
    journeyBack3 = {"In {span}, {we} had fought {our} way to {far} and back.", "{We} had fought {our} way to {far} and back in {span}."},
    journeyFar0 = {"In {span}, {we} had come as far as {far}."},
    journeyHomeFrom = {"From {far} {our} hearthstones brought {us} home, {span} after {we} had set out."},
    -- (round 17: the arrival in a first land, with the crossings that brought us there)
    arriveBy = {"{how}, and {we} came to {land}, new to {us}{why}."},
    -- (round 23: a main companion away for a while inside the night, and back)
    partedWhile = {"{name} went another way for a while."},
    rejoined = {"{name} was with me again."},
    -- (round 15: a companion the record puts with us, not otherwise named that day)
    joinedPlain = {"{name} joined {us}."},
    -- (round 15: quest chains the authored story tables do not hold, in their quests' own words:
    -- the Forever note trail, a blistered note by a burned-out fire in Westfall (79007), a cozy spot
    -- in the mountains between the Barrens and Desolace (79192), a stash a hundred paces north
    -- (79980), the eagle's nest on a mountainside (79974), a barricade camp left in a hurry (79975),
    -- and the writer's pack (79976))
    questChains = {
        {qids = {79007, 79008, 79192, 79980, 79974, 79975, 79976},
            start = "where a blistered note by a burned-out fire set {us} on a trail of notes",
            road = "where the trail of notes led",
            steps = {
                [79974] = "In {zone} {we} found the next hiding place, the eagle's nest on the mountainside.",
                [79975] = "In {zone} the trail ended at an old barricade, its fire newly fed and its keeper gone, and {we} took the pack left there.",
                [79976] = "In {zone} the trail ended at an old barricade, its fire newly fed and its keeper gone, and {we} took the pack left there.",
            }},
    },
    journeyDonePlain = {"In {zone} {we} saw that work done."},
    journeyDoneRest = {"In {zone} {we} saw the rest of it done."},
    journeyHome0 = {"In {span}, {we} had gone as far as {far}, and the hearthstone brought {us} home."},
    journeyHome2 = {"In {span}, {we} had made it as far as {far}, and the hearthstone brought {us} home."},
    journeyHome3 = {"In {span}, {we} had fought {our} way as far as {far}, and the hearthstone brought {us} home."},
    journeyFar2 = {"In {span}, {we} had made it as far as {far}."},
    journeyFar3 = {"In {span}, {we} had fought {our} way as far as {far}."},
    moveWent = {"{We} went on to {place}.", "From there {we} went to {place}."},
    moveWentNew = {"{We} went on to {place}, new to {us}.", "From there {we} went to {place}, where {we} had never been."},
    runLevels = {"The run took me from level {from} to {level}."},
    closeDungeonDone = {"{dungeon} was behind {us}"},
    closeFoeHeld = {"{foe} still held {place}"},
    closeWork = {"the work for {givers} was done"},
    closeSleepFar = {"Then {I} slept {at} {place}, {span} and {crossings} from {from}.", "{I} slept {at} {place} that night, {span} and {crossings} from {from}."},
    closeSleepNear = {"Then {I} slept {at} {place}, {span} after the {part} began {atFrom} {from}.", "{I} slept {at} {place}, {span} after the {part} had begun {atFrom} {from}."},
    closeSleepSame = {"Then {I} slept {at} {place}, {span} after the {part} began there."},
    closeSleepShort = {"Then {I} slept {at} {place}.", "{I} slept {at} {place} that {part}."},
    closeEndShort = {"The {part} ended {at} {place}."},
    closeEndFar = {"The {part} ended {at} {place}, {span} and {crossings} from {from}."},
    closeEndNear = {"The {part} ended {at} {place}, {span} after it began {atFrom} {from}.", "{span} after the {part} began {atFrom} {from}, it ended {at} {place}."},
    closeEndSame = {"The {part} ended {at} {place}, {span} after it began there."},
}
