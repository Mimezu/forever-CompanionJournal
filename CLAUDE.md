# Companion Journal: working instructions

Read `DESIGN.md` first. It holds the design rules, the writing standard, the decisions
and the open questions. This file is only how to work.

## Where things are

- **Live code (edit here):** `C:\games\World of Warcraft\_forever_\Interface\AddOns\CompanionJournal\`
  Client 1.60.1 (build 70707 on 2026-11-02), TOC Interface 16001, account folder
  `WTF\Account\118944884#1`. SavedVariables: `...\SavedVariables\CompanionJournal.lua`.
- **Never edit** `C:\games\World of Warcraft\_classic_beta_\` (the beta, an archive since 2026-11-02).
  Its `StorageInvestigation\` folder is the research archive, read-only: the writing reviews
  (`journal-voice\review\CRITIQUE*.md`, `REWRITES*.lua`), the vanilla quest corpus
  (`journal-voice\review\corpus_vanilla_quests.txt`), the simulators (`journal-voice\sim\`),
  the 30-journey study (`storytelling-thirty-20261013\`), the Codex snapshot
  (`cj-codex-pass-20261013-0156\`), the book design (`cj-book-layout-b\`), the offline
  window renderer (`ui-mock-renderer\`).
- **Memory notes:** `C:\Users\miche\.claude\projects\C--games-World-of-Warcraft--classic-beta-\memory\`
  (start with `MEMORY.md`; the `companion-journal-*`, `storyteller-writing-standard`,
  `ui-*` notes matter most).
- **Related addons** in the same AddOns folder: ForeverNames (reads `CompanionJournalAPI`),
  WardrobeTimeCapsule (portrait looks), FrameGambit (lists `CompanionJournalOptions` in its
  SuiteWindows). Keep `API.lua` stable.
- Blizzard UI source for Forever: Gethe/wow-ui-source, branch `forever`.

## Rules of the house

- Plain English everywhere: code comments, README, UI labels, replies. No fluff.
- Writing changes follow `DESIGN.md` §3 and `STORY_RULES.txt`. Never invent events.
- New skins or layouts go behind an A/B/C switch; small fixes go in directly; bigger
  features are proposed first, not built.
- Every new feature has a toggle that starts off.
- Game art only, finished edges; check `/cj artboard` in game before composing.
- Do not read or write the user's SavedVariables while the game runs; the client overwrites
  them on logout. Tests and sims must never modify SavedVariables.
- Other sessions may edit this folder at the same time: re-read a file before editing it
  and use exact-text replacements.
- Bump `## Version` in the TOC and add a README entry at the top for each user-visible change.

## Tests

Run from the live client root with Lua 5.1 (plain `lua` is 5.4 and `unpack` is nil there;
`lua5.1` is `C:\Users\miche\AppData\Local\Programs\Lua51Aliases\lua5.1.exe`).

```
cd "C:\games\World of Warcraft\_forever_"
lua5.1 Interface/AddOns/CompanionJournal/tests/Tale.lua          # one suite
for f in Interface/AddOns/CompanionJournal/tests/*.lua; do printf '%s: ' "$(basename $f)"; lua5.1 "$f" 2>&1 | tail -1; done
lua5.1 Interface/AddOns/ForeverNames/tests/Smoke.lua             # loads both addons together
lua5.1 Interface/AddOns/CompanionJournal/tools/StoryCoverage.lua [full]   # authored quest coverage
```

70 suites, about two minutes in all. A passing suite ends with `PASS` or `N checks passed`
(a few print a sample chapter as their last line; that is a pass too). A failing one ends
with a traceback (`[C]: ?`).

Some suites read files under `StorageInvestigation/` (the quest corpus, `study-lib.lua`,
`cj-story-ui-checks/*.txt`). Since 2026-11-02 the live client has its own copy of that
folder (`_forever_\StorageInvestigation\`, a real folder, not a link), so all suites pass
from the `_forever_` root; any traceback is a real failure. New research artefacts go there
too.

Lint (optional): luacheck under Lua 5.4 with
`LUA_PATH="C:/Users/miche/AppData/Roaming/luarocks/share/lua/5.4/?.lua;.../?/init.lua;;"`
and `LUA_CPATH="C:/Users/miche/AppData/Roaming/luarocks/lib/lua/5.4/?.dll;;"`, args
`--std lua51 --allow-defined-top --no-max-line-length --no-global --codes *.lua`. Also scan
once without `--no-global`: a use-before-definition (`local CARD_W` after `Build()`) once
broke the book in game while the mock render hid it. Single-backslash texture paths are a
known trap (Lua 5.1 drops the backslash).

## Checking the writing

1. Generate chapters with the simulators (they load the addon relative to the current
   directory, so run them from the live root to simulate the live code):
   ```
   cd "C:\games\World of Warcraft\_forever_"
   lua5.1 StorageInvestigation/journal-voice/sim/run.lua daily you
   lua5.1 StorageInvestigation/journal-voice/sim/lives.lua batch1 all 0 you
   STATS=1 lua5.1 StorageInvestigation/journal-voice/sim/lives.lua batch2 all 0 we brief
   ```
2. Score the output: `python StorageInvestigation/journal-voice/sim/score.py sim/out/<file>.txt`
   (targets in `DESIGN.md` §3.3: ~12 words per sentence, ~0.8 adjectives per 100 words,
   colons 0, meta words 0). `--corpus` prints the vanilla baseline.
3. Read whole chapters in both voices (you/we), Everything and Highlights, several retells.
   `tests/Words.lua` walks every pool line for meta words, colons, questions and morals;
   `tests/Tale.lua` and `tests/SelfStories.lua` check every telling 0-7.
4. For a content batch (quest stages, lore notes): read the original quest text by ID in
   the corpus, author two setup and two outcome variants, record the source, keep a
   before/after backup and a short report, get an independent read, then run the suites.
   Only then say it is done. Never claim complete coverage.

## In-game checks

The user tests in game; nothing counts as verified until he has. Give him a short checklist.

- `/reload` after any change. Slash commands (`Core.lua`): `/cj` (open; at your target if
  listed), `/cj journal [name]`, `/cj me` (your own journal), `/cj book` (the book),
  `/cj skin a|b` (book art), `/cj artboard`
  (candidate atlases with names and sizes), `/cj tag [note]` (add target),
  `/cj testleave [n|me]` (preview the group popup), `/cj movelist` (move the list from the
  first login character; only while this character has nobody).
- Book: Settings > Reading (Everything/Highlights, Simple/Story, style A-E, size, pages,
  extras), Settings > Testing (variants), Companions / NPCs pages, Retell at the bottom of a
  Story chapter, click a note to edit it, click the title name to set a last name.
- Gamepad: D-pad moves, A opens, B back, LB/RB chapters, LT/RT card/journal, Y add, X settings.
  Addon menus, the Blizzard ColorPicker and chat focus taint the gamepad UI: keep the
  `A.GamepadUI()` guards (`People.lua`).
- Unit names, GUIDs and health can be secret values on Forever; read them through the
  `Public()` / `issecretvalue` guards the files already use, never compare them raw.
- Offline preview of the window (wireframe, no art judgement):
  `StorageInvestigation\ui-mock-renderer\drive_cj_book.lua`, `drive_cj_manage.lua`,
  `drive_cj_views.lua` (luajit, from that folder; see `memory: ui-mock-renderer`).

## Git

- Repo: this folder is a git repository, branch `main`, remote
  `https://github.com/Mimezu/forever-CompanionJournal.git` (private, description
  "forever - CompanionJournal"). First commit 2026-11-02 "Forever beta final".
- Commit when a change is complete and tested offline; write the message in plain English
  saying what changed for the player. **Push only when the user asks.**
- Do not commit SavedVariables, screenshots or research dumps here; research artefacts go
  in an archive folder outside the addon (ask where, see `DESIGN.md` §9.5).
- Before committing, check `git status`: another session may have uncommitted work in the
  same files.

## When resuming

1. Read `DESIGN.md`, then the README's top entries, then `git log` and `git status`.
2. Ask the user what he saw in game since the last version; untested items are listed as
   such in the memory notes.
3. Keep the A/B/C habit: current look stays A, new looks are switchable, settings shared.
