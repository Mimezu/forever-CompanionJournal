# Companion Journal: design bible

Written 2026-11-02 from the addon, its history in `_classic_beta_\StorageInvestigation\`,
and the user's memory notes. Read this before changing the writing, the conditions
the storytellers react to, or the book. `CLAUDE.md` has the working instructions.

Sources are cited in brackets. `memory:` means a note in
`C:\Users\miche\.claude\projects\C--games-World-of-Warcraft--classic-beta-\memory\`.
`SI:` means `C:\games\World of Warcraft\_classic_beta_\StorageInvestigation\` (read-only archive).

---

## 1. What it is, and who it is for

Companion Journal is a World of Warcraft addon for WoW Forever (vanilla-era client,
Interface 16001, "camelot" game type). It keeps:

- **a list of people** (Companions, Acquaintances, Campfire, Rivals, NPCs) with a display
  name, a glyph icon, a note, and when and where you last saw them;
- **a journal with each companion**: what you lived through together (outings, dungeons,
  bosses, shared quests, deaths, rescues, campfires, inns, levels);
- **your own journal**, per character, written at all times, in the first person;
- **a storyteller** that turns each day into a short chapter ("Story" mode), and a plain
  record ("Simple" mode);
- **the book** (layout B): the window where all of this is read, built from the game's own art;
- **lore notes**: a reference catalogue of places, people and quests, clickable from the prose.

It is written for one player, Michel (character Alberich Noir, a Forsaken paladin), who
plays with his wife (Dahlia-Noir; they started together as Forsaken in Deathknell), and
for his other characters. It is the "real feature we come back to" [memory: forever-names-roadmap].
It split out of Forever Names on 2026-09-28 [memory: forever-names-roadmap].

The user reads the output closely, on his phone, and notices machine tells immediately
[memory: storyteller-writing-standard].

## 2. Design philosophy, in the user's terms

1. **A tabletop game master recapping your campaign, in the voice of vanilla quest text.**
   "It should read like a pen-and-paper game master telling a new story each time, with the
   tone of the vanilla quests." A little romanticized, like a nice fantasy novel, but it
   must **never feel AI-generated** [SI: journal-voice/review/BRIEF.md; memory: storyteller-writing-standard].
2. **Never invent events.** Every sentence comes from a recorded fact. Lore only says what a
   place, a foe or a quest *is*; it never claims you did, said, felt or saw something that was
   not recorded [SI: journal-voice/review/BRIEF.md; STORY_RULES.txt rules 1-2].
3. **Plainness.** Adjectives are rare ("overuse feels amateur at best; there is a thin line").
   Colour comes from one concrete noun and from consequence, not from decoration
   [memory: storyteller-writing-standard; SI: journal-voice/review/CRITIQUE.md §1.2].
4. **Plain UI copy.** Labels say what the control does ("Options", "Pin", "Retell",
   "Everything / Highlights"). No roleplay-flavoured labels. Immersion comes from the
   game's own art, not from prose in the interface [memory: ui-copy-plain-not-rp].
5. **Native art, finished edges.** Every surface ends in an art edge or sits inside window
   chrome. No cropped atlases, no floating panels, no generated art. Look at the real art
   (`/cj artboard`) before composing [memory: ui-finished-edges; SI: cj-book-layout-b/ART-CRITIQUE.md].
6. **Testing is better than theory.** When a design question has several good answers, build
   them all as A/B/C variants and try them in game. The current look stays as A
   [memory: ui-redesigns-as-abc-toggles].
7. **Every feature can be turned off**, and new features start off. Behaviour that follows
   naturally from a feature the user already turned on needs no toggle of its own
   [memory: forever-names-roadmap; README "Every feature is its own toggle and starts off"].
8. **Honesty about coverage.** "Coverage is representative, not every quest." Never claim
   that every quest, boss or chain is authored or that the catalogue is spoiler-safe
   [STORY_RULES.txt "Validation and honest coverage"; README 1.7.0-1.12.0].

## 3. The writing standard

### 3.0 The character's story first (the user's rules, 2026-11-07; they override anything below)

After playing the live realm the user found the books "overwhelming, weirdly impersonal:
too long on too many lore elements, not enough personal storytelling", and the English
"not fluid". The new rules:

1. **Point of view: always the character** (and their companion when grouped). Every quest,
   place and event is told as *my* (our) experience, never as the quest-giver's exposition.
   NPCs are people I met, worked for or fought; notable figures of Warcraft (Sylvanas,
   Thrall, Cairne, Bolvar...) matter, but still as I met or served them.
2. **The shape of a told moment:** me (or me and my companion) → the adventure (where I
   went, what I faced) → the discovery (what I found, saw, learned) → the effect on me (what
   I learned, met, felt) → my reward and where it leads me next.
3. **Not every quest.** The storyteller chooses: a worth score (a chain's ending or turning
   point, the stage's importance, a dungeon or boss, a death or rescue, a first in a new zone,
   the companion's presence, a notable figure, a named foe) decides which few quests a
   chapter tells; the rest fold into a light line or are left out. Highlights keeps one or two.
4. **Lore colours the story, it is not the story.** A clause or a few words woven into the
   character's sentences ("the Mindless Ones, Deathknell's dead still bound to the Lich
   King"), occasionally a fuller moment where the story turns. Never a run of sentences
   about NPCs. There is no lore-heavy mode.
5. **Perception and feeling, grounded.** The character may perceive and feel: what a place or
   creature truly is (a spider cave is dark and full of spiders), and a reaction that fits
   the recorded fact (a first death, a hard fight, a long road). Never invent an event, an
   outcome, another person's speech, or weather; one perceptive or felt touch per moment.
6. **The hero's journey by level.** Low levels: a fledgling, novice adventurer, things new
   and big. Middle levels: a seasoned traveller, surer. High levels and the end game: a
   strong, known figure, the last part of the hero's journey; the voice grows with them.
7. **Plain, fluid English.** Read aloud; no log-speak, no stiff or old-fashioned phrasing.

Rules 3.2-3.4 still hold where they do not conflict (no meta words, no colons or questions
in prose, plain verbs, deterministic variety).

### 3.1 The reference

Vanilla quest text (IDs below 10000). The critic measured 265 quests across every level
band plus the 112 second-person narration passages: mean sentence 12.3 words (narration
14.2), 17-21% of sentences over 20 words, 0.8 descriptive adjectives per 100 words,
colons almost never, no sentence that talks about the telling itself
[SI: journal-voice/review/CRITIQUE.md §1]. The corpus is
`SI: journal-voice/review/corpus_vanilla_quests.txt` (4,264 quests; note it also contains
Forever additions with IDs 65000+ and 9xxxx, so the file name is not era proof
[SI: cj-lore-research-20261012-world-class.md]).

### 3.2 The rules (the 24-rule guide, condensed)

Full text: `SI: journal-voice/review/CRITIQUE.md §4`. Later rounds (CRITIQUE2-8b) refined
them; `STORY_RULES.txt` in this folder adds the evidence rules of the Codex era.

**Content**
- Say what happened, in the order it happened. The fact is the sentence.
- Never state what the journal does not record: who struck the blow, what anyone said,
  thought or felt, food, beds, weather, silence, intent, or unchecked history ("as she had
  before", "the longest").
- Never narrate the telling. No journal, tale, song, verse, page, book, record, chapter,
  story in a common pool. "The road" is allowed as long as it is not overused: at most
  once a chapter, not every chapter (relaxed 2026-09-30, confirmed 2026-11-05)
  [memory: storyteller-writing-standard].
- Fit the length to the day. Length follows the recorded and authored evidence: the
  longer Codex-era chapters are the accepted length (2026-11-05), not the old 1-2 / 5-8
  sentence budget. Never add a sentence to make a chapter feel complete, and never cut
  supported scenes to hit a count.

**Sentences**
- Full sentences. One verbless fragment per chapter at most, never first.
- No colon reveals ("Level 22: Kael was getting stronger.").
- Let a sentence carry two facts that belong together (place and work, death and rescue,
  kills and the lord), joined with "and", "then", "where", "before".
- Never three short sentences in a row. Vary openings; no two consecutive sentences start
  with the same word; at most one in ten starts with "The".
- Banned shapes: "Nobody X. Nobody needed to.", "X. Not anymore.", "Not X, not Y, but Z.",
  "..., and that was that.", rule-of-three abstractions, "The kind of day that...",
  "Of course they did.", "It usually is.", chiasmus, "X did not see Y coming."

**Words**
- One descriptive adjective per sentence at most, three per chapter. Prefer a concrete noun.
- Epithets are seasoning: a zone epithet on one chapter in four at most; for a dungeon the
  epithet *or* the lore clause, never both, lore on the first visit only; a boss epithet on
  the first kill only.
- Name a place once per chapter. Plain verbs: went, killed, finished, turned in, made camp.
- Watch the crutch words: again, together, first time, the two of you, once more, as ever.

**People and voice**
- Name the companion once, early, then "you"/"we"/pronoun. "The two of you" at most once.
- Greet only when the rhythm changes (second day, a streak, a return, a long silence).
- Humour comes only from facts, with understatement, never at the reader.
- A storyteller changes diction and rhythm, never facts, and never talks about the telling.
- The diary ("I"/"we") voice never addresses a "you", never blesses, never praises the writer.

**Endings**
- Most chapters end on their last fact. Closers only on won or lost days, one chapter in
  five at most, eight words or fewer.
- Romanticize through consequence: "The Searing Blade had lost its master."

**Evidence rules added in the Codex era** [STORY_RULES.txt]
- Recorded events, configured backstory (origin, bond) and lore are three different things;
  keep them distinct.
- A completed quest permits only that quest's supported consequence. A shared title across
  chain stages must not imply the whole chain was done. Prefer exact quest IDs; a title-only
  old record gets a conservative fallback.
- Prefer a named person, visible object and consequence to "the assignment", "proof of work",
  "the official's approval". Attribute NPC opinions; never turn them into narrator fact.
- Do not append audit disclaimers ("the report was not delivered"). State the achieved fact.
- Paragraphs follow a change of purpose, place or time, not every sentence.
- Do not repeatedly announce "I finished [quest title]" when the scene already explains the work.
- Hidden identities and later outcomes belong to what the reader has actually discovered
  (the discovery system, §7.6). Public lore explains places and public roles only.

### 3.3 Targets and the scorer

| Measure | Target | Vanilla |
|---|---|---|
| Mean sentence length | 11-13 words | 12.3 |
| Sentences of 18+ words | at least 15% | 17-21% |
| Sentences of 4 words or fewer | 12% at most | 9% |
| Colons | none in narration | 0.01 per sentence |
| Descriptive adjectives | about 1 per 100 words | 0.8 |
| "the two of you" | rare, once per chapter at most | ~0 |
| "road", "journal", "tale", "song", "verse" | 0 (road: occasional) | 0.28 / 0 |

History: shipped prose started at 8.3 words per sentence and 2.4 adjectives per 100 words;
after the critic rounds it reached 11-12.8 words and 0.6-0.8 adjectives, colons 0
[SI: journal-voice/PLAN.md "Writing review"; memory: companion-journal-own-journal].

Run the scorer from the live client root (its `StorageInvestigation` copy has the corpus):

```
cd "C:\games\World of Warcraft\_forever_"
python StorageInvestigation/journal-voice/sim/score.py <samples.txt>      # one or more sim outputs
python StorageInvestigation/journal-voice/sim/score.py --corpus           # the vanilla baseline
```

It reads files with `-- Chapter` headers and one text line each (the sim output shape).
It prints sentence length, fragments, colons, adjectives, leaned-on words per 1000 words,
and recurring 4-word phrasings. Produce samples with the sims in §7.8, then score them.
Never claim a line is natural without reading it in context in the sim output
[memory: storyteller-writing-standard].

### 3.4 Good and bad, from the repo's own material

From `SI: journal-voice/review/CRITIQUE.md`:

- Do: "You and Kael spent over an hour in the Barrens and finished two quests."
  Don't: "About two hours of the Barrens, two errands, and not a wasted step."
- Do: "Kael came back after thirteen days."
  Don't: "For thirteen days the song was sung by one voice alone."
- Do: "Inside, you killed Oggleflint, then Taragaman the Hungerer, the felguard who led the
  Searing Blade, and after that Jergosh the Invoker and Bazzalan."
  Don't: "Oggleflint was cut down. Deepest in, Taragaman the Hungerer waited, the felguard
  who led the Searing Blade. Taragaman fell, and the air cleared."
- Do: "Hogger killed you. At your level, that takes some doing."
  Don't: "Hogger killed you. In Elwynn Forest. At your level. The journal will be discreet."
- Do: "Not your finest day." Don't: "Another day, another page, another reason to trust Mira."
- Do: "Shadowfang Keep was a few levels above you, and you and Kael went in anyway. You fell
  to Archmage Arugal, and Kael raised you from death."
  Don't: "You died facing Archmage Arugal, which is how the songs like it. Death, and then
  Kael's voice calling you back. Tomorrow would be better. It usually is."

From the Codex-era craft review [SI: storytelling-thirty-20261013/v2/craft-review-20261015/review.md]:

- Don't: "At the Saldeans' farm, herbs and onions waited on the last ingredient for a meat
  pie. We finished Goretusk Liver Pie. Salma accepted the ingredients..."
  (the completion label interrupts the scene).
  Do: "Salma's crust was baked and her gravy simmering; only the goretusk livers were
  missing. The livers completed Salma's preparations, and she made sure the work earned
  something to eat."
- Don't: militia need, then "We were out for nearly three hours and completed three quests",
  then militia approval (accounting in the causal middle). Put the timer first or last.
- Don't: "The gate's regiment received proof that some pressure had been taken off its
  defenses." (administrative abstraction). Name the object and the person instead.

Storyteller voices (one own line per chapter, on ordinary beats) [JournalTellers.lua header]:
chronicler (formal: "rejoined", "attained", "was slain"), bard (old heroic cadence,
inversions), veteran (a soldier's short full sentences: "fell in", "stood down"), wry (dry
jokes from the facts, never at the reader), elder (grave and slow; was "mystic", recast
because omens invented meaning). Alberich's storyteller is wry [memory: companion-journal-styles].
The user found the bard overpowering before the rewrite [memory: companion-journal-styles].

## 4. The Codex line of work (2026-10-11 to 2026-10-29): the standard to keep

The user ran Codex (OpenAI) on the storyteller while out of Claude tokens. His verdict,
recorded 2026-10-13: Codex is good at storyteller and lore, weak at UI; Claude fixes the UI
after it [memory: companion-journal-book-layout-b]. He says the result is good. The
snapshot at version 1.12.2 is `SI: cj-codex-pass-20261013-0156\`. The line continued
after that snapshot (editorial passes dated 2026-10-14, -15, -16, -29 in
`SI: storytelling-thirty-20261013\v2\`), and the live code contains all of it
(for example `LoreDiscovery.lua` and the `StoryCraft*`, `StoryEditorial*` tests are
not in the snapshot but are in the live folder).

### 4.1 What it changed (1.6.0 through 1.12.2, then editorial continuations)

Read the README entries 1.6.0 to 1.12.0 for the full list. In short:

1. **Quest scenes from the real quest text.** Each authored quest stage has `why` lines
   (the setup, from the quest's description) and `after` lines (the supported consequence,
   from the completion text), keyed by **exact quest ID**, in four content packs
   (`LoreHordeStories.lua`, `LoreAllianceStories.lua`, `LoreWorldStories.lua`,
   `LoreClassStories.lua`) registered through `A.Lore.RegisterStoryPack`. Title-only old
   records fall back to conservative shared context. 930 exact stages and 666 title
   contexts in the live build [tests/LoreNotes.lua output].
2. **Connected scenes and paragraphs.** Place changes and shifts of purpose make paragraphs
   in every page style. Highlights keeps a chain's beginning and resolution instead of
   letting intermediate referrals crowd them out; later (2026-10-16) it switched to
   reviewed short scenes for exact-matched records and keeps every recorded stage
   [README 1.8.0; SI: storytelling-thirty-20261013/v2/editorial-20261016/checkpoint.txt].
3. **Lore notes.** A sourced reference catalogue (`LoreNotes.lua`, `LorePlaces.lua`,
   `LorePeopleHistory.lua`, `LoreWorldConnections.lua`), 1,174 curated notes in the live
   build, each with provenance, aliases, related links and a Classic/Forever setting label;
   known names in the prose become links that open a parchment slip in the book
   (`LoreNotesUI.lua`). Reading a note never records a visit ("knowledge is not memory").
4. **Discovery (spoilers).** `LoreDiscovery.lua` projects the catalogue onto what the
   logged-in character has actually learned (quest presented vs turned in). Hidden
   identities (Dathrohan/Balnazzar, Moira's child) stay hidden until the exact quest
   evidence exists [SI: .../editorial-20261029/checkpoint.txt].
5. **Pages that turn, Reading view editions** (Original, Your tale, Our story, By the fire),
   the Companions/NPCs/Settings pages inside the book (`BookManagement.lua`,
   `JournalPagination.lua`, `JournalReader.lua`).
6. **Evidence discipline.** `STORY_RULES.txt`; quest IDs preserved in new records; a coverage
   tool (`tools/StoryCoverage.lua`); boss consequences bounded by evidence (Majordomo's
   surrender and Celebras's release are not kills; no "Naralex awakened" unless recorded).
7. **A frozen 30-journey study** with independent reviewer agents and SHA-sealed captures
   (`SI: storytelling-thirty-20261013\`): 30 synthetic race/class lives from level 1 to 60,
   rendered in nine modes, read in full by a reviewer, with findings separated into fixture
   defects and production defects.
8. **Heavy tests**: 11 suites before, 70 now. Many walk every pool line or render
   thousands of chapters and assert factual, chronological and grammar invariants.

### 4.2 Why it is the standard

- It fixed the real gap the blind writer test had found: **quest knowledge**. Before, a
  chapter could only name a quest; now it can say why it was asked and what came of it
  [memory: companion-journal-own-journal "blind writer test"].
- It added **people and objects** to scenes (Salma's pie, Krueg's gift for Korrin,
  Nimboya's curse) while keeping every fact sourced. The reviewer's words: "selected work
  reads as scenes instead of completion labels, cause and consequence stay together"
  [SI: .../craft-review-20261015/final-acceptance.md].
- Every claim was traceable to a quest ID and a corpus line, every batch had an independent
  review, and every pass stated honestly what it did not cover.

### 4.3 How to keep doing it the same way

- **Research first, then write.** Read the original quest text (`corpus_vanilla_quests.txt`
  by ID; `quests_corpus.txt` is the raw game-cache capture for levels 1-30). Record the
  source on the entry. Do not fill gaps from memory of retail or later expansions.
- **Author in pairs.** Each new exact stage gets two `why` and two `after` variants with
  different focus or sentence shape (the Codex contract: "at least two useful setup/outcome
  alternatives"). Since 2026-10-16, also two compact variants for Highlights where the
  stage matters.
- **Bound the consequence to the stage.** An opened cauldron is not a delivered sample;
  finding Ringo does not complete his escort [editorial-20261016 checkpoint].
- **Work in small batches (10-20 entries), review independently, keep a before/after
  backup and a report** in `StorageInvestigation` (or a new archive folder of the live
  client), then run the full suites.
- **Read the generated prose**, whole chapters in both voices and in Highlights, not only
  assertion counts. Sealed captures and byte-identical re-renders were how acceptance worked.
- **UI changes after a Codex-style content pass are Claude's job**: check sizes, margins,
  wrapped text, button edges (1.12.3 was exactly that) [memory: companion-journal-book-layout-b].

### 4.4 Weaknesses the Codex reviewers themselves left open

[SI: .../craft-review-20261015/final-acceptance.md; .../craft-continuation-review-20261015/final-acceptance.md; editorial-20261016 and -20261029 checkpoints]

- Many untouched outcomes "still sound administrative" ("received proof that some pressure
  had been taken off its defenses").
- Chapter rhythm is "conspicuously templated": repeated weekday/reunion openings, duration
  sentences, duplicated town descriptions, "My work on X continued. I completed X." runs
  (see `SI: cj-world-bands-narrator-review-20261012.txt` for the worst case, a shaman's
  "Call of Fire" chain).
- Some Highlights chapters are nearly indistinguishable from Detailed.
- Anonymous hand-ins, passive hand-ins, repeated NPC reintroductions.
- 74 of 1,290 quest events in the study still fall back to title-only context.
- Discovery policy is not global; the catalogue is not certified spoiler-safe.
- Next literary targets named: Tanaris investigation, Greenwarden follow-ups, repetitive
  reunion/date framing, level-sixty quest-count closings.

### 4.5 The overnight pass (2026-11-05, 1.13.0): what it added and learned

Brief, lane reports and coordinator log: `_forever_\StorageInvestigation\cj-overnight-20261105\`
(`BRIEF.md`, `PROGRESS.md`, one folder per lane with `before/` backups and renders).
- **Content**: exact stages 930 → about 2,260 across six packs, including a new
  `LoreForeverStories.lua` (Forever's own quests, labelled, and it skips any ID another pack
  owns). About 330 new lore notes; 70 notes behind discovery policies after a spoiler audit
  (`tests/LoreNotes3Overnight.lua` fails if a guarded term reaches a public version).
- **Engine** (see §7.3a): in-order callbacks, a per-character profile used for emphasis only,
  companion voices, companion Highlights cut, "Record more moments".
- **The lesson**: writer agents overstate outcomes ("cleared", plans told as done), slip in
  small feelings and gestures, and state NPC opinions as fact. Independent fact-checks found
  problems in about a third of new stages (213 lines fixed in the Horde/Alliance/Forever
  packs; the world/class check followed). **Every content batch needs a separate reader
  who checks each line against the quest text.** Names a writer took from memory rather
  than the text were nearly always right but must be verified.
- Coordination: give each agent exclusive files; a message to a finished agent resumes it
  (it may then edit files another lane owns); an agent that waits on its own background
  reviewers can be stopped and later re-woken, so run reviewers from the coordinator.

### 4.6 The second pass (2026-11-06, 1.14.0)

Same folder, `PROGRESS.md` "Round 2". Fable lanes built absence openings and dungeon
history (857c935), places (8b75117), battlegrounds and milestones (0cb341f), a whole-life
review (f2b3a68) and zone bands 20-60 plus end game; Opus lanes fact-checked every one
(problem rates 24% for place lines, about 50% for new quest scenes: outcomes past the
completion text, invented gestures and laughter, wrong genders, the player called a
hunter) and finished the writer's pass when Fable ran out of credits mid-edit.
Tests now include Openings, DungeonRepeat, BattlegroundSeries/Record, Milestones,
Rehearsal, PlaceLead, Band2030/3050/5060, LoreNotes4-7.

## 5. Decision log

Dates are from memory notes and archive folders. "Untested in game" means the user had
not confirmed it when the note was written; the live client (since 2026-11-02) is where
testing happens now.

| Date | Decision | Source |
|---|---|---|
| 2026-09-26 | Every new feature toggleable, default off; people data account-wide; icons are single-colour glyphs tinted to the name colour | memory: forever-names-roadmap |
| 2026-09-27 | UI copy plain, not RP ("Options" not "Habits") | memory: ui-copy-plain-not-rp |
| 2026-09-27 | New skins/layouts behind A/B/C toggles; small fixes direct; feature ideas proposed, not built | memory: ui-redesigns-as-abc-toggles |
| 2026-09-28 | Split from Forever Names: Companion Journal 1.0.0 (`/cj`, `CompanionJournalDB`) owns *who* someone is; Forever Names owns *how a name is drawn* | memory: forever-names-roadmap |
| 2026-09-28 | Kept-aside groupmate memories are baseline, no toggle ("natural with our design") | memory: forever-names-roadmap |
| 2026-09-29 | Journal "very dense"; page styles A-E and modes Everything/Highlights. Highlights = "romanticized version of truth (not inventing things)" | memory: companion-journal-styles |
| 2026-09-29 | Story mode = tabletop GM, vanilla voice; tone grows with the companionship; Simple stays available | memory: companion-journal-styles; SI: journal-voice/PLAN.md |
| 2026-09-29 | Prose "a bit too AI": the critic review, the 24 rules, score.py targets. Five critic rounds the same day, round 6-8b after | memory: storyteller-writing-standard |
| 2026-09-29 | Lists and journals per character over shared cards; recognition ON by default (gold companion, silver acquaintance, red rival, "kin" glyph); rivals red on both sides, never friends across factions; NPCs shared with "Only on <character>" | memory: companion-journal-per-character |
| 2026-09-29 | Storyteller own lines capped at one per chapter; bard was overpowering | memory: companion-journal-styles |
| 2026-09-30 | Own journal per character, first person, companions as supporting cast; quests kept by name forever; no line cap | memory: companion-journal-own-journal |
| 2026-09-30 | "The road" allowed now and then (correction of the ban) | memory: storyteller-writing-standard |
| 2026-09-30 | Meter talk in Story is gamey: deeds in-fiction and rarely; Simple states it plainly | memory: companion-journal-own-journal |
| 2026-09-30 | Caves and mines recorded (dangerous, good story material); towns told by who you are (home/ally/foreign) | memory: companion-journal-own-journal |
| 2026-10-01 | 15 simulated lives in three batches, perfected with a writer agent ("push push push") | memory: companion-journal-own-journal |
| 2026-10-02 | Play from midnight to 5 AM belongs to the evening before | memory: companion-journal-own-journal |
| 2026-10-02 | Layout B, the book, designed question by question; every open choice as a Testing variant | memory: companion-journal-book-layout-b; SI: cj-book-layout-b/DESIGN.md |
| 2026-10-02 | Forever Names / Companion Journal ownership rule (user picked this version over three others) | memory: forever-names-roadmap |
| 2026-10-04 | Bookmarks C won (labelled ribbons both sides: journals vs tools); footer cut to chapter arrows; Show/Told/Pages in Settings > Reading | SI: cj-book-layout-b/DESIGN.md |
| 2026-10-11 | Book "barebone, not carefully assembled": art critique with game assets only; skin B built behind `/cj skin b` | memory: companion-journal-book-layout-b |
| 2026-10-11 | Finished-edges rule after skin B round 1 | memory: ui-finished-edges |
| 2026-10-11 to -29 | Codex line: quest scenes, lore notes, discovery, reader editions, book management (see §4) | README; SI: storytelling-thirty-20261013 |
| 2026-10-13 | Skin B header: "title bar + title page" after two failed on-page headers. Pin = hanging `activities-ribbon`, card access = quill (cog rejected as not book-like). Journal/About/Notes tabs and card variants removed from skin B | memory: companion-journal-book-layout-b |
| 2026-10-13 | Codex's manager sheet never scaled above 1 (grows instead); notes edited in place (no right-click menu) | README 1.12.3 |
| 2026-10-23 | Live migration: CJ story starts fresh on the live realm; `people` decision pending | memory: live-migration-backup-2026-10-23 |
| 2026-11-02 | All work in `_forever_`; beta is an archive; repo `Mimezu/forever-CompanionJournal` | memory: forever-live-workspace |
| 2026-11-05 | Overnight pass toward "a unique story for each character" (1.13.0, §4.5, §7.3a); new recording behind one toggle that starts off; ancestor journals archived for a future "ancestors' diaries" feature (`Migration\ancestor-journals-20261105\`) | user, in session |
| 2026-11-05 | Codex-era chapter length accepted: "story is paramount", a fixed sentence budget makes no sense; "the road" allowed as long as it is not overused; prune the 6 beta `people`; keep skins A and B both for now | user, in session |
| 2026-11-09 | Only the book (layout A removed, 1.16.0) and one skin, the spellbook pages (skin A removed, 1.17.0) | user, in session |

### Rejected or reverted

- Lore-flavoured UI labels ("Habits", "Keepsakes", "Tear out") [memory: ui-copy-plain-not-rp].
- Loot-toast art and a transparent header for the group popup [memory: forever-names-roadmap].
- The bard's conceit as default voice; the mystic (became the elder); all storyteller
  "asides"; stage labels ("Two tested blades."); ordinary-day closers; `killCraft` (who
  struck the blow from class) [SI: journal-voice/review/CRITIQUE.md §5].
- `spellbook-Page-*-C60` pages (dark band) and `Legacy-Challenge-Cards-Ribbon` (a title
  band, not a ribbon) in skin B; a cog for card access [ART-CRITIQUE.md round 2; memory: companion-journal-book-layout-b].
- Two failed on-page journal headers in skin B [memory: companion-journal-book-layout-b].
- Scaling the Companions/NPCs page up at book sizes B/C (Codex did; reverted in 1.12.3).
- Audit disclaimers in prose ("without yet..."), replaced with bounded facts [cj-audit-1.11.0; editorial-20261016].
- Portraits from a hand-drawn frame; QuestBG-Parchment stretched [ART-CRITIQUE.md].
- An option toggle for kept-aside groupmate memories [memory: forever-names-roadmap].

## 6. Do / Don't

Each line has evidence; do not add rules without it.

**Do**
- Keep Simple (the plain record) available and factual beside Story [memory: companion-journal-styles].
- Put a brand-new skin or layout behind an A/B/C switch in the window *and* a slash
  command; keep A as the default and the backup [memory: ui-redesigns-as-abc-toggles].
- Fix misalignment and small visual problems directly, no toggle [memory: ui-redesigns-as-abc-toggles].
- Propose bigger feature ideas at the end of a reply; let the user pick [memory: ui-redesigns-as-abc-toggles].
- Make every new feature a toggle that starts off [README; memory: forever-names-roadmap].
- Use short standard WoW wording for labels [memory: ui-copy-plain-not-rp].
- End every surface in an art edge or a border; copy Blizzard's own assembly of an atlas
  (uisrc) rather than one piece alone [memory: ui-finished-edges].
- Check Camelot overrides before copying mainline geometry (close button TOPRIGHT -2, 1)
  [memory: forever-camelot-ui-overrides].
- Render the window offline (ui-mock-renderer) and check button edges before sending
  screenshots; the user notices misalignments [memory: companion-journal-book-layout-b; ui-mock-renderer].
- Keep records per character GUID/key, cards shared [memory: companion-journal-per-character].
- Source every lore or quest line to a quest ID or document; keep Classic/Forever
  chronology; label Forever custom content [STORY_RULES.txt].
- Prefer deterministic counters to new `rng()` calls for wording variety; a new rng call
  shifts the stream and can make full and short titles differ [memory: storyteller-writing-standard].
- Join a death and its rescue, a place and its work; never join a lore consequence to a
  level ("...had lost its master, and you reached level 17" is banned) [CRITIQUE.md 6.2; CRITIQUE8b §2.4].
- Tell a class first after the quest that earned it, by timestamp [CRITIQUE8b §2.2].
- Keep the company line when Highlights keeps a "we" line [CRITIQUE8b §2.5].
- Run all tests with `lua5.1` from the client root before saying something works [tests headers].
- Guard every unit read with `issecretvalue`/`Public()`; skip addon menus and the Blizzard
  ColorPicker in the gamepad interface [SI: cj-book-layout-b/DESIGN.md rules; memory: forever-names-roadmap].

**Don't**
- Don't invent events, speech, feelings, weather, food, or who struck the blow [BRIEF.md].
- Don't use meta words (journal, tale, song, verse, record, chronicle, legend, bard) in
  pools; `tests/Words.lua` fails on them [tests/Words.lua].
- Don't write colon reveals, questions, or morals in pools [tests/Words.lua].
- Don't stack adjectives or an epithet and a lore clause on the same noun [CRITIQUE.md].
- Don't address a "you" in the diary voice; no blessings there [CRITIQUE.md rule 24].
- Don't let a storyteller speak about the telling; one own line per chapter [CRITIQUE.md rule 23].
- Don't make meter/damage talk prominent in Story [memory: companion-journal-own-journal].
- Don't claim "first ever" in a book that starts at level 11 or above; "home" only in the
  race's start zone or capital; the Light only for human, dwarf and gnome priests
  [memory: companion-journal-own-journal].
- Don't hook or reparent Blizzard frames; only the addon's own frames [SI: cj-book-layout-b/DESIGN.md].
- Don't use class colours or gold as text on parchment; use a bar, icon or swatch [ART-CRITIQUE.md].
- Don't put a scrollbar on a text page; pages turn [README 1.7.0].
- Don't use generated art; game assets only [memory: companion-journal-book-layout-b].
- Don't move a settings control to a slash command when the user asked for it in the window [memory: forever-names-roadmap].
- Don't merge the user's differing settings; check SavedVariables first [memory: forever-names-roadmap].
- Don't edit `_classic_beta_` or SavedVariables while the game runs [memory: forever-live-workspace; wow-forever-beta-workspace].
- Don't claim complete quest, boss or spoiler coverage [STORY_RULES.txt].
- Don't make a story coherent by changing recorded facts or fixture data [SI: journal-voice/PLAN.md "Editorial continuation"].

## 7. How the story system works

### 7.1 Recording (facts in)

- **`Journal.lua`**: the companion journals. Entries in `db.characters[charKey].people[key].journal`
  (via the `A.People` view). Kinds read by the companion teller (`DayFacts` in
  `JournalTale.lua`): `group` (an outing, with `t`/`e`, zone, `pl`/`ol` your and their
  level), `quest` (`ql` level, `qt` tag, `t` turn-in), `dungeon`, `boss` (`cost`), `death`
  (`w` you/them, `d` killer, `env`, `boss`, `pr`/`pc` race and class of a player killer),
  `wipe`, `rez`, `campfire`, `rest`, `level`, `mylevel`, custom lines.
- **`JournalSelf.lua`**: your own journal, `db.characters[me].journal`. Kinds: `play`,
  `with`, `quest`, `dungeon`, `boss`, `wipe`, `death` (with `sz`, `walk`), `pdeath`, `rez`,
  `rest`, `campfire`, `mylevel`, `close` (HP under 12.5% then alive), `cave`, `gather`
  (`m` item names), `craft`, `town`, `voyage`, `bg`, `guild`, `home`, `hearth`, `swim`,
  `sleep`, `nightflight`, and `first` with a sub-key (zone, continent, tram, flight,
  zeppelin, boat, landmark, raid, worldboss, pvp, epic, legendary, famous, tier, setfull,
  mount, epicmount, sunset, snow, rarebeast, aucsale, foeseen, battleground, class, notable...).
  Firsts are stored once each in `mine.firsts`. Notable NPC sightings record targeting vs
  gossip separately [README 1.6.0].
- **`Characters.lua`**: per-character relationships over shared cards; recognition; import.
- **`LoreDiscovery.lua`**: what the character has learned (quest detail presented vs turned
  in), for the spoiler projection.

### 7.2 Days and scenes

`JournalBook.lua` turns entries into days (the evening rule: midnight to 5 AM belongs to the
day before, `Evening()`), merges outings (gap 20 min or less), builds scenes, Highlights
(`JournalDayHighlights`) and the plain Everything prose (`A.JournalEventText`). Its markup
`{p:place}`, `{q:quest}`, `{n:name}` is what the page styles colour and link.
`A.JournalPlain(text)` strips it (the sims use it).

### 7.3 Telling

- **`JournalTale.lua`** (+ `JournalWords.lua` pools `PB.*`, + `JournalTellers.lua` voices
  `P.*`): the companion storyteller. `T.Tell(person, days, voice, player, brief)` returns
  `stories[day.key] = {text, chapter, title, ...}`. `voice` is "you" (the GM) or "we" (the
  diary). `brief` is Highlights. It computes cadence (daily / often / weekly / fortnightly /
  monthly / rare from the median gap), familiarity, long pauses, streaks, stage and danger,
  then picks beats in time order. `T.Paragraphs` breaks on change of place or purpose.
- **`JournalSelfTale.lua`** (+ `JournalSelfWords.lua` pools `W.*`): your own storyteller,
  first person. `ST.Tell(person, days, brief, retell)`. Tone per race for towns
  (`W.towns`, home/ally/neutral/foe), caves, dungeons with company, firsts, honest-work days,
  level milestones, the level-60 look-back.
- **Pools and tokens.** A pool is a Lua table of lines; the picker is least-recently-used
  and rests lines until most of the pool is used. Tokens in braces are filled by the engine
  (`{zoneD}` plain zone name, `{zoneE}` zone or epithet, `{When}`, `{part}`, `{We}`/`{we}`,
  `{level}`, `{foe}`, `{dungeonE}`, `{lore}`, `{quest}`, `{quests}`, `{count}`, `{by}`...).
  `[a|b]` picks one option. Capitalized tokens capitalize the value. The RNG is seeded per
  person, day and `retell`, so the same journal reads the same every time until Retell.
- **Guards in the engines** (keep them): a name at most twice per chapter (`Crowded`), a
  "first" budget of 2 per chapter, word-echo guard (`Heard`), once-per-book templates
  (`oncePerBook`), joins only on a whitelist of kind pairs, no second bare "and", titles
  unique across chapters, two-word opening guard, EAST_COASTS for sunsets
  [memory: companion-journal-own-journal].
- **`Lore.lua`**: what places and foes *are*. `L.zoneStory[zone] = {sight={}, stakes={}}`,
  `L.dungeonStory[name] = {why={}, inside={}, detail={}}`, bosses (`B[name]` with kind,
  epithet, `after` consequence), `L.QuestStory(title, questID)` → `{why, after, ...}` from
  the packs, `L.QuestThread`, `L.Humble`, `L.WithoutBosses`, `L.DungeonSight`, race homes
  and starts (`L.IsHome`, `L.IsStart`). `LoreData.lua` is generated metadata (zone/dungeon
  level ranges, quest title → level and kind) from `SI: journal-voice/make_lore_data.py`.

### 7.3a Added in 1.13.0 (overnight pass)

Details and API evidence: `SI: cj-overnight-20261105\moments\DESIGN-moments.md`.
- **Record more moments** (`db.moreMoments`, `A.MoreMomentsOn()`, default off; Settings >
  Recording and Options > Journal). `JournalSelf.lua` registers its extra events only while
  on, in a `MoreEvent` dispatcher (the main OnEvent closure is near Lua 5.1's 60-upvalue
  limit). New own-journal kinds: `read`, `explore`, `taxi`, `learn`, `rep`, `duel`, `skill`,
  `hk`, `rarekill`. `Journal.lua` records `rez` with `w = "you"` in a companion's journal when
  your resurrection lands on them (dead target only). Reputation and skill ranks compare only
  with values seen this session (first look seeds).
- **Memory of the road** (`JournalSelfTale.lua`, in time order, never hindsight): a foe that
  killed you before, a boss beaten after it killed you, a return to where you died, companion
  day milestones, tallies, a thread taken up again after a week, no false first-continent.
- **`ST.Profile`**: gatherer, fisher, crafter, dungeon regular, explorer, night player, caver,
  duelist, fighter, paired, computed from the whole record. Used only to choose emphasis
  (what Highlights keeps, which true fact gets the line); never stated as a trait.
- **Companion voices** (`PB.voice.we` / `PB.voice.you` in `JournalWords.lua`): the diary as a
  shared record, the game master recapping your party; rationed per chapter and per book.
  `SharedMoments` brings your own firsts on a day together into their book.
- **Companion Highlights cut** (`brief` in `T.Tell`): keeps exact-ID stages, importance 4+,
  a chain's first and last; drops minor errands, fires, herbs, brief visits, greeting-only
  days (draws still made, so both editions read the same stream).
- **Openings**: chapters a week or less apart open on the place or company; a regular
  companion's rhythm is said once. Role lines unique per book. Place-led outcomes get "You had
  come to X by then." instead of a doubled place prefix.
- **Links**: `commonNames` in `LoreNotes.lua` never auto-link; a name any of the user's
  characters or listed players carries never links to an NPC (`A.MarkKnownLore`).

### 7.4 Pages

`JournalStyles.lua` (styles B Chronicle, C Margins, D Diary with drop cap, E Ledger; A is
the original page), `JournalUI.lua` (reading choices, ways into a journal), `JournalBookUI.lua` (the
book, the only window since 1.16.0; variants through `A.BookVariant(key)` and `db.bookVariants`; one skin, the spellbook pages, since 1.17.0),
`BookManagement.lua` (Companions, NPCs, Settings pages), `JournalPagination.lua`,
`JournalReader.lua` (Reading view editions), `LoreNotesUI.lua` (the parchment slip).

### 7.5 Where to add a new condition or narrated moment

1. **Record it.** Add the event in `JournalSelf.lua` (own journal) or `Journal.lua`
   (companion journal) with a new `k` (or a new `first` sub-key). Keep entries small and
   factual; store what the sentence will need (names, place, who). Guard every API read.
   Add a test in `tests/Self.lua` or `tests/Journal.lua`.
2. **Read it.** Add the kind to the facts step: `Facts(day)` in `JournalSelfTale.lua`,
   `DayFacts(day)` in `JournalTale.lua`. Decide whether it is STANDALONE (its own sentence)
   or joinable, whether it is a "first" (budget), and where it goes in time order.
3. **Write it.** Add a pool in `JournalSelfWords.lua` (`W.name`) or `JournalWords.lua`
   (`PB.name`), two to five lines, following §3. If a storyteller should have its own line
   for it, add it under that teller in `JournalTellers.lua`.
4. **Share it.** If the own journal saw it during an outing, the companion chapter can tell
   it too: see the `PB.shared*` pools in `JournalWords.lua` (`PB.sharedFoeSeen` and the
   others) and how sunset/voyage/landmark/close/gather are passed in `JournalTale.lua`.
5. **Simulate and score.** Add the event to a scenario in `SI: journal-voice/sim/` (or the
   30-journey fixtures) and read the chapters; run `score.py`.
6. **Test.** `tests/Words.lua` walks every pool automatically. Add a telling check in
   `tests/SelfStories.lua` or `tests/Tale.lua` (every retell 0-7).

Ideas the user has already listed for new moments [memory: companion-journal-own-journal;
SI: journal-voice/PLAN.md]:
- an "honest work" chapter on heavy gathering days (partly done: `W.honestDay`);
- first time in each capital, level milestones (done), a boat trip there and back (not done);
- holidays (not done: Forever dates unknown);
- **Hardcore mode** telling: graver wording for danger and close calls, a wary voice
  ("on our guard"), a death that is final, never "brought back". Detect from the game if
  Forever exposes it, else a per-character option. **Not built** (no "hardcore" in the code);
- a role line not yet used in the book; a raise placed where it happened; `W.levelBoth`
  (needs the companion's level recorded);
- feasts (Well Fed) if auras are readable; filtering a journal by which of your characters
  was there (`entry.by`);
- noted NPCs mentioned in stories with lore when seen or talked to (partly: notable leaders);
- **Looks**: Wardrobe Time Capsule integration (a `look` entry kind, portraits, "as
  remembered"), planned in `SI: looks-in-companion-journal/PLAN.md`, not built; today's
  portraits only read `WardrobeTimeCapsuleDB` for your own character.

### 7.6 Where to add quest scenes and lore

- **A quest stage**: in the matching pack (`LoreHordeStories.lua` `Q(...)`,
  `LoreWorldStories.lua` `q(id, title, zone, level, thread, importance, why1, why2, after1, after2, shared)`),
  with the exact ID, two `why` and two `after` variants, a `source`. Shared titles across
  stages get a conservative `fallback(...)`. New modules may call
  `A.Lore.RegisterStoryPack(id, pack)` after `Lore.lua` (contract in `STORY_RULES.txt`).
  Check coverage with `lua5.1 Interface/AddOns/CompanionJournal/tools/StoryCoverage.lua [full]`.
- **A zone or dungeon**: `L.zoneStory` / `L.dungeonStory` in `Lore.lua` (sight, stakes;
  why, inside, detail). Lore lines never say I/you/we (`tests/Words.lua` checks).
- **A town**: `W.towns` in `JournalSelfWords.lua` (side, home, lore, homeLines).
- **A lore note**: `Curated(id, title, kind, body, sources, names, related, setting, autoLink, explicitAliases)`
  in `LoreNotes.lua` (see the Silverpine example just before the `place:sepulcher` entry). Reference
  notes use present tense for the Classic-era present and past tense for earlier history;
  they must stand alone and never assume the reader did a quest. If the note carries a
  secret, add a discovery policy (`A.RegisterLoreDiscovery`) with an explicit public version.
- **A notable NPC**: `W.notableNPCs` plus the recorder's list in `JournalSelf.lua`.

### 7.7 Settings the reader sees

Book (layout B): Settings > Reading (Everything/Highlights, Simple/Story, page style A-E,
book size A/B/C or drag, One/Two pages, extras: Today so far, Names open their journal,
Reading view, Timeline, New chapter notice, portraits), Settings > Testing (bookmarks
A/B/C, adding, unread ribbons, portraits when/where/frame), People in the
world, Adding people, Recording. Reading view editions: Original, Your tale, Our story,
By the fire. (Layout A, the list window, was removed in 1.16.0.)

### 7.8 Simulators (offline, lua5.1, run from the live client root)

```
cd "C:\games\World of Warcraft\_forever_"
lua5.1 StorageInvestigation/journal-voice/sim/run.lua [scenario] [you|we]          # companion scenarios
lua5.1 StorageInvestigation/journal-voice/sim/lives.lua <batch1|2|3> [life|all] [retell] [you|we] [brief]
STATS=1 lua5.1 StorageInvestigation/journal-voice/sim/lives.lua batch1 all 0       # words per sentence
lua5.1 StorageInvestigation/journal-voice/sim/dahlia_print.lua [character]         # the real Dahlia journal (beta SavedVariables)
lua5.1 StorageInvestigation/storytelling-thirty-20261013/run.lua <new-folder>      # the 30 frozen journeys (refuses to overwrite)
```

These load `Interface/AddOns/CompanionJournal/...` relative to the current directory, so
run them from `_forever_` (the live code); from the beta root they would load the old beta
copy. `dahlia_print.lua` reads `WTF/Account/118944884#4/...`, which exists only in the beta;
the real beta journals are now archived and rendered in
`Migration\ancestor-journals-20261105\`. The storytelling-thirty study is synthetic and
never reads SavedVariables.

## 8. Known limits

- The README's "Files" section is older than the Lore* and Book* files; the changelog is current.
- Portraits cover only your own journal; companion portraits need the Looks plan.
- Holidays, a round-trip boat, Hardcore telling, `W.levelBoth`, talents, flights as
  first-visit arrivals: not built.
- "Record more moments" has never run in the real client (offline stubs only); the two
  global-string patterns (ERR_ZONE_EXPLORED*, DUEL_WINNER_*) and the Skyborne race token
  need an in-game check. Factions under a collapsed reputation header are not seen.
- Riverglades, Shen'dralas and Mount Hyjal (launched 2026-11-04) have zone/dungeon lines
  and notes but no quest scenes: their quest text was not captured yet.
- Coverage: 74 of 1,290 quest events in the study still use title-only fallback; later
  outdoor regions and custom Forever foes have gaps (`SI: cj-lore-coverage-20261012.txt`).
- Text widths in the offline mock renderer are estimates; fonts, drop caps and the
  middle dot need in-game checks [memory: companion-journal-styles].
- Any Lua 5.1 upvalue-limit split (a second `do` block works around it).

## 9. Open questions and contradictions

Settled 2026-11-05 (see the decision log): chapter length follows the Codex era, and
"the road" is allowed when not overused.

1. **Highlights.** Designed as "one entry a day, romanticized truth" (2026-09-29); since
   2026-10-16 it "retains every recorded stage rather than applying a scene cap", and a
   reviewer noted it is sometimes indistinguishable from Detailed. 1.13.0 cuts minor
   errands, fires, herbs, gathering/crafting (unless it is the character's kind of work) and
   greeting-only days, but **every exact-ID quest stage stays** because three Codex-era suites
   (CompanionOutings, StorySceneContinuity, StoryHighlightsScenes) assert it. Fewer quest
   scenes per day in Highlights needs the user's decision and those tests renegotiated.
2. **Why the user liked the Codex pass** is recorded only as "good at storyteller/lore".
   §4.2 is inferred from the reviews; ask if a change would undo one of those qualities.
3. **The `score.py` targets** predate the Codex era and were not re-run on its output in the
   archive. Its LEANS list still counts "road"; that is useful as an overuse check, not a ban.
4. **The live realm move** (~2026-11-05) changes the CJ character key again; the user wants
   the story fresh. Beta `people` pruned (2026-11-05): the live save keeps only Dahlia's card;
   the four acquaintances and the one NPC card (Shari Stilwell) are gone. Backup:
   `Migration\CompanionJournal.lua.before-people-clear-20261105`
   [memory: live-migration-backup-2026-10-23].
5. **Research artefacts** (settled 2026-11-05): `_forever_\StorageInvestigation\`, the live
   client's own copy of the archive (for example `cj-overnight-20261105\`).
6. **Skin and layout** (settled 2026-11-09): skin B and layout B won; skin A was removed
   in 1.17.0 and layout A in 1.16.0. Bookmarks C is the other variant recorded as having
   won. The "Companion card" variant (no effect since skin B) was removed in 1.18.0: the
   card lives on the Companions page, opened from the pin ribbon's cog.
