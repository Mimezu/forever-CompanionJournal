local _, A = ...
-- Felt lines (DESIGN §3.0 rule 5, 2026-11-09): the character's own reaction to a recorded
-- moment, told only when the book set it up (an earlier death, a figure named before, a
-- thread begun earlier) and rarely. Drafted with Astra (Codex), curated here.
-- Keys follow the planner's hooks (JournalTale S.setup kinds). Each pool is by stage
-- (fledgling 1-19, seasoned 20-44, known 45-60) and voice: you (the companion book), i (your
-- own book and the companion diary's "I"). A missing stage tells nothing: a level-50 hero is
-- not wide-eyed, and no line is better than a wrong one.
-- Identity pools (race, class, faction) are used only at identity moments, never otherwise.
-- Tokens: {foe} {figure} {setupName} (the person the setup named).
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
        you = {"You had died before, and you knew the cold road back by now.",
            "It stung more to die to {foe} than to anything before it."},
        i = {"I had died before, and I knew the cold road back by now.",
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
}

-- A figure met after the book named them earlier that day (the setup).
F.figureNamed = {
    fledgling = {
        you = {"{setupName} had promised {figure} would hear of it, and here {figure} was.",
            "You scarcely knew what to do with yourself before {figure}."},
        i = {"{setupName} had promised {figure} would hear of it, and here {figure} was.",
            "I scarcely knew what to do with myself before {figure}."},
    },
    seasoned = {
        you = {"You had heard {figure}'s name all evening, and now you stood before {figure}."},
        i = {"I had heard {figure}'s name all evening, and now I stood before {figure}."},
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
}

-- A thread begun earlier that day and paid off (the setup line is in the chapter).
F.thread = {
    fledgling = {
        you = {"You had carried {setupName}'s name since earlier that evening, and now it had a face.",
            "Earlier that evening it had been only a name to you."},
        i = {"I had carried {setupName}'s name since earlier that evening, and now it had a face.",
            "Earlier that evening it had been only a name to me."},
    },
    -- (a reunion across death, for the dead who lost friends to the plague)
    reunion = {
        fledgling = {
            you = {"You had not thought friendship could survive so much dying."},
            i = {"I had not thought friendship could survive so much dying."},
        },
    },
}

return F
