local _, A = ...
-- Felt lines (DESIGN §3.0 rule 5, 2026-11-09): the character's own reaction to a recorded
-- moment, told only when the book set it up (an earlier death, a figure named before, a
-- thread begun earlier) and rarely. Drafted with Astra (Codex), curated here.
-- Keys follow the planner's hooks (JournalTale S.setup kinds). Each pool is by stage
-- (fledgling 1-19, seasoned 20-44, known 45-60) and voice: you (the companion book), i (your
-- own book and the companion diary's "I"). A missing stage tells nothing: a level-50 hero is
-- not wide-eyed, and no line is better than a wrong one.
-- Identity pools (race, class, faction) are used only at identity moments, never otherwise.
-- Tokens: {foe} {figure} {setupName} (the person the setup named), {mate} (the companion's
-- name, in F.rezLearned only). A line whose token is not given is left out by the tellers.
local F = {}
A.JournalFeel = F

-- A death after an earlier death (this chapter or the one before).
F.deathAgain = {
    fledgling = {
        you = {"Dying had not grown any easier since the last time.",
            "You had hoped one death would be enough to learn from.",
            "Until {foe} killed you, dying had seemed much further away."},
        i = {"Dying had not grown any easier since the last time.",
            "I had hoped one death would be enough to learn from.",
            "Until {foe} killed me, dying had seemed much further away."},
    },
    seasoned = {
        you = {"You had died before, and knew the cold road back by now.",
            "It stung more to die to {foe} than to anything before it."},
        i = {"I had died before, and knew the cold road back by now.",
            "It stung more to die to {foe} than to anything before it."},
    },
    known = {
        you = {"Death was an old acquaintance by then, and no kinder for it."},
        i = {"Death was an old acquaintance by then, and no kinder for it."},
    },
    -- (identity: the Forsaken already died once)
    Scourge = {
        fledgling = {
            you = {"Somehow, you had thought a corpse would be harder to kill.",
                "You remembered dying, and that made it worse."},
            i = {"Somehow, I had thought a corpse would be harder to kill.",
                "I remembered dying, and that made it worse."},
        },
    },
    -- (identity: what each people holds about dying; a line that names the Earth Mother is told only when the book named her)
    Orc = {
        fledgling = {
            you = {"An orc is meant to die fighting, but not this often."},
            i = {"An orc is meant to die fighting, but not this often."},
        },
    },
    Troll = {
        fledgling = {
            you = {"The spirits kept sending you back, and you did not ask why."},
            i = {"The spirits kept sending me back, and I did not ask why."},
        },
    },
    Tauren = {
        fledgling = {
            you = {"The Earth Mother was not ready for you yet, it seemed."},
            i = {"The Earth Mother was not ready for me yet, it seemed."},
        },
    },
    Dwarf = {
        fledgling = {
            you = {"A dwarf is supposed to be harder to put down than that."},
            i = {"A dwarf is supposed to be harder to put down than that."},
        },
    },
    NightElf = {
        fledgling = {
            you = {"Your people were deathless once, and you were making up for it."},
            i = {"My people were deathless once, and I was making up for it."},
        },
    },
    -- (identity by class)
    WARLOCK = {
        fledgling = {
            you = {"Nothing you had bargained with lifted a finger for you."},
            i = {"Nothing I had bargained with lifted a finger for me."},
        },
    },
}

-- A figure met after the book named them earlier that day (the setup).
F.figureNamed = {
    fledgling = {
        you = {"{setupName} had promised {figure} would hear of it, and here {figure} was.",
            "You scarcely knew what to do with yourself before {figure}.",
            "Until then {figure} had been a name other people spoke."},
        i = {"{setupName} had promised {figure} would hear of it, and here {figure} was.",
            "I scarcely knew what to do with myself before {figure}.",
            "Until then {figure} had been a name other people spoke."},
    },
    seasoned = {
        you = {"You had heard {figure}'s name that day, and now you stood before {figure}."},
        i = {"I had heard {figure}'s name that day, and now I stood before {figure}."},
    },
    -- (identity: a Forsaken before the Dark Lady; only for Sylvanas)
    Sylvanas = {
        Scourge = {
            fledgling = {
                you = {"Here was your queen, and you hardly knew where to look.",
                    "Before Sylvanas, you wanted to be more than another corpse.",
                    "Bethor had promised the Dark Lady would hear of it, and now you stood before her yourself."},
                i = {"Here was my queen, and I hardly knew where to look.",
                    "Before Sylvanas, I wanted to be more than another corpse.",
                    "Bethor had promised the Dark Lady would hear of it, and now I stood before her myself."},
            },
            seasoned = {
                you = {"You could stand before your queen now without shrinking."},
                i = {"I could stand before my queen now without shrinking."},
            },
        },
    },
    -- (identity: an orc before the Warchief, a tauren before the High Chieftain; the teller
    -- needs the figure keys "Thrall" and "Cairne" for these to be asked)
    Thrall = {
        Orc = {
            fledgling = {
                you = {"This was the orc who walked your people out of the camps."},
                i = {"This was the orc who walked us out of the camps."},
            },
        },
    },
    Cairne = {
        Tauren = {
            fledgling = {
                you = {"This was the chief who had ended your people's wandering."},
                i = {"This was the chief who had ended my people's wandering."},
            },
        },
    },
}

F.figureNamed["Cairne Bloodhoof"] = F.figureNamed.Cairne

-- A thread begun earlier that day and paid off (the setup line is in the chapter).
F.thread = {
    fledgling = {
        you = {"You had carried {setupName}'s name with you, and now it had a face.",
            "Earlier that day it had been only a name to you."},
        i = {"I had carried {setupName}'s name with me, and now it had a face.",
            "Earlier that day it had been only a name to me."},
    },
    -- (a reunion across death, for the dead who lost friends to the plague)
    reunion = {
        fledgling = {
            you = {"You had not thought friendship could survive so much dying."},
            i = {"I had not thought friendship could survive so much dying."},
        },
    },
}

-- Pass 2 (2026-11-09). Each kind names the setup the planner must have tested before it asks.
-- A line here is one sentence (the planner reads a capital inside a line as a name, and wants
-- that name told before), six to twelve words, and true for anyone who meets the setup.

-- The first home is set (at an innkeeper), and the book told where the character began.
-- {place}: the home (no line needs it yet).
F.homeFirst = {
    fledgling = {
        you = {"You had not had anywhere to go back to until then.",
            "Until then you had only been passing through.",
            "After that there was a way back from wherever you went."},
        i = {"I had not had anywhere to go back to until then.",
            "Until then I had only been passing through.",
            "Wherever I went after that, there was a way back."},
    },
    -- (identity: the Forsaken woke in a crypt, and had a home in life)
    Scourge = {
        fledgling = {
            you = {"You had woken in a crypt, and now you had a bed.",
                "You had a home again, if an inn counts."},
            i = {"I had woken in a crypt, and now I had a bed.",
                "I had a home again, if an inn counts."},
        },
    },
    -- (identity: every gnome is an exile; told only when the book named Gnomeregan)
    Gnome = {
        fledgling = {
            you = {"It was not Gnomeregan, but it would do."},
            i = {"It was not Gnomeregan, but it would do."},
        },
    },
}

-- The first of the other faction is seen. Identity by the character's race, then the race
-- seen, then the stage: F.foeSeenFirst[race][foeRace][stage]. The race seen stands under the
-- client's token and under its display name ("Scourge" and "Undead", "NightElf" and "Night Elf").
-- No line says what either of them did next: a fight may follow in the record.
F.foeSeenFirst = {
    fledgling = {
        you = {"You had heard of them, and seeing one was not the same.",
            "You looked longer than you meant to."},
        i = {"Hearing of them had not been the same as seeing one.",
            "I looked longer than I meant to."},
    },
    seasoned = {
        you = {"You had come a long way without ever seeing one of them."},
        i = {"I had come a long way without ever seeing one of them."},
    },
    -- (identity: the Forsaken were human before the plague, and Lordaeron stood with Ironforge)
    Scourge = {
        Human = {
            fledgling = {
                you = {"You had been one of them once."},
                i = {"I had been one of them once."},
            },
            seasoned = {
                you = {"You had been one of them once."},
                i = {"I had been one of them once."},
            },
        },
        Dwarf = {
            fledgling = {
                you = {"In life you would have counted a dwarf a friend."},
                i = {"In life I would have counted a dwarf a friend."},
            },
            seasoned = {
                you = {"In life you would have counted a dwarf a friend."},
                i = {"In life I would have counted a dwarf a friend."},
            },
        },
    },
    -- (identity: the Forsaken were human; the orcs burned Stormwind (told only when the book named the city))
    Human = {
        Scourge = {
            fledgling = {
                you = {"It had been one of your people once."},
                i = {"It had been one of us once."},
            },
        },
        Orc = {
            fledgling = {
                you = {"You had grown up on what the orcs did to Stormwind."},
                i = {"I had grown up on what the orcs did to Stormwind."},
            },
        },
    },
    -- (identity: the camps)
    Orc = {
        Human = {
            fledgling = {
                you = {"Your people wore their chains not so long ago."},
                i = {"My people wore their chains not so long ago."},
            },
        },
    },
    -- (identity: the largest people meets the smallest)
    Tauren = {
        Gnome = {
            fledgling = {
                you = {"You had not known a people could be so small."},
                i = {"I had not known a people could be so small."},
            },
        },
    },
    -- (identity: the Warsong in Ashenvale)
    NightElf = {
        Orc = {
            fledgling = {
                you = {"Their axes had been in your forests."},
                i = {"Their axes had been in our forests."},
            },
        },
    },
}
F.foeSeenFirst.Human.Undead = F.foeSeenFirst.Human.Scourge

-- The first step into the capital of the character's own people. {place}: the city (no line
-- needs it yet). The race lines hold for that race's own city only (a troll in Orgrimmar, a
-- gnome in Ironforge, a Forsaken in the Undercity).
F.capitalOwn = {
    fledgling = {
        you = {"You had not known there were so many of your own.",
            "You had pictured a smaller place."},
        i = {"I had not known there were so many of us.",
            "I had pictured a smaller place."},
    },
    Scourge = {
        fledgling = {
            you = {"No one down there looked twice at what you were.",
                "The faces down there were mostly as dead as yours."},
            i = {"No one down there looked twice at what I was.",
                "Most faces down there were as dead as mine."},
        },
    },
    Orc = {
        fledgling = {
            you = {"The whole city was younger than you were."},
            i = {"The whole city was younger than I was."},
        },
    },
    Troll = {
        fledgling = {
            you = {"It was an orc city, and it had room for your people."},
            i = {"It was an orc city, and it had room for us."},
        },
    },
    Tauren = {
        fledgling = {
            you = {"Your people had never had a city until this one."},
            i = {"My people had never had a city until this one."},
        },
    },
    Human = {
        fledgling = {
            you = {"It had burned once, and you could find no mark of it."},
            i = {"It had burned once, and I could find no mark of it."},
        },
    },
    Dwarf = {
        fledgling = {
            you = {"The mountain had never been taken, and you could see why."},
            i = {"The mountain had never been taken, and I could see why."},
        },
    },
    Gnome = {
        fledgling = {
            you = {"It was a home, and it was not yours."},
            i = {"It was a home, and it was not ours."},
        },
    },
    NightElf = {
        fledgling = {
            you = {"You were older than the tree it stood on."},
            i = {"I was older than the tree it stood on."},
        },
    },
}

-- The class learns to bring back the dead, and the book told a death of the character before.
-- {mate}: the companion's name, only when the companion is in the party. F.rezLearned.mate is
-- the pool to ask first when {mate} is given; its first line stands in the general pool too.
F.rezLearned = {
    fledgling = {
        you = {"You had died yourself by then, and knew what it was worth.",
            "You had been dead yourself, and did not take it lightly.",
            "You hoped you would never need it for {mate}."},
        i = {"I had died myself by then, and knew what it was worth.",
            "I had been dead myself, and did not take it lightly.",
            "I hoped I would never need it for {mate}."},
    },
    seasoned = {
        you = {"You had died yourself by then, and knew what it was worth.",
            "You hoped you would never need it for {mate}."},
        i = {"I had died myself by then, and knew what it was worth.",
            "I hoped I would never need it for {mate}."},
    },
    mate = {
        fledgling = {
            you = {"You hoped you would never need it for {mate}.",
                "{mate} was beside you, and you hoped you would never need it."},
            i = {"I hoped I would never need it for {mate}.",
                "{mate} was beside me, and I hoped I would never need it."},
        },
        seasoned = {
            you = {"You hoped you would never need it for {mate}.",
                "{mate} was beside you, and you hoped you would never need it."},
            i = {"I hoped I would never need it for {mate}.",
                "{mate} was beside me, and I hoped I would never need it."},
        },
    },
    -- (identity: the Forsaken were raised once themselves)
    Scourge = {
        fledgling = {
            you = {"You knew something of being brought back.",
                "You had been raised once yourself, and nobody had asked you."},
            i = {"I knew something of being brought back.",
                "I had been raised once myself, and nobody had asked me."},
        },
    },
    -- (identity by class: what each calls on (the Light line is told only when the book named the Light))
    PALADIN = {
        fledgling = {
            you = {"You had not known the Light would trust you with so much."},
            i = {"I had not known the Light would trust me with so much."},
        },
    },
    PRIEST = {
        fledgling = {
            you = {"It was more than you had thought prayer could do."},
            i = {"It was more than I had thought prayer could do."},
        },
    },
    SHAMAN = {
        fledgling = {
            you = {"The spirits would listen now when you asked them for a life."},
            i = {"The spirits would listen now when I asked them for a life."},
        },
    },
    DRUID = {
        fledgling = {
            you = {"The land raises its dead every spring, and now so could you."},
            i = {"The land raises its dead every spring, and now so could I."},
        },
        seasoned = {
            you = {"The land raises its dead every spring, and now so could you."},
            i = {"The land raises its dead every spring, and now so could I."},
        },
    },
}

-- A death in a stretch without the companion, when every earlier death was beside her. {foe}
-- (no line needs it yet).
F.deathAlone = {
    fledgling = {
        you = {"You had not died alone before.",
            "There was nobody with you to see it.",
            "You had gone out alone, and that was all it took."},
        i = {"I had not died alone before.",
            "Nobody was with me to see it.",
            "I had gone out alone, and that was all it took."},
    },
    seasoned = {
        you = {"In all that time you had not once died alone."},
        i = {"In all that time I had not once died alone."},
    },
    known = {
        you = {"After so long, dying alone was new to you."},
        i = {"After so long, dying alone was new to me."},
    },
}

-- A task done where the character died earlier in the book, and has not died since. {foe}
-- {place} (no line needs them: the clause W.plan.backDeath names both, and these lines follow
-- it or stand without it).
F.backDeath = {
    fledgling = {
        you = {"You knew the ground better than you wanted to.",
            "You had not forgotten where you fell.",
            "This time you walked out of it."},
        i = {"I knew the ground better than I wanted to.",
            "I had not forgotten where I fell.",
            "This time I walked out of it."},
    },
    seasoned = {
        you = {"You knew that ground better than you cared to.",
            "This time you walked out of it."},
        i = {"I knew that ground better than I cared to.",
            "This time I walked out of it."},
    },
}

return F
