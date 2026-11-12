# Companion Journal: details

## What it does

- **Your list:** Companions, Acquaintances (from groups), Campfire, NPCs and
  Rivals. Each person can have a display name, their own icon (glyph, color,
  size), a note, and when and where you last saw them.
- **In the world:** a small icon beside Blizzard's names for the people in
  your list, and your note and "last seen" on their tooltip. With Forever Names
  installed, their display names and icons are drawn on its labels instead
  (never both).
- **Adding people:** Add my target, a typed name, `/cj tag [note]`, the key
  binding "Add target to Companion Journal", the right-click menu entry,
  everyone you group with (or a popup when they leave), and people who sit at a
  campfire with you (experimental).
- **The journal:** time grouped, dungeons, bosses, quests you both had,
  campfires and levels, plus lines you write yourself. Groupmates you add when
  the group ends keep what you did together. Double-click someone in the list
  to open theirs.
- **Simple or Story:** a switch beside the page styles. *Simple* is the plain
  record. *Story* tells your days together as a tale, one chapter a day, in the
  plain voice of the old quest givers (with *Highlights*: a condensed adventure). The telling
  follows the companionship: a first meeting, the familiar face you kept
  crossing before you ever grouped, how often you meet (every day, several
  times a week, weekly, every couple of weeks, monthly, rarely), a long
  silence and the return, streaks, anniversaries. It weighs levels (fledglings
  to legends, the old hand and the green one), danger (a dungeon above your
  station or an old haunt), the land (home, old roads, perilous country), and
  what happened: bosses and their lore, a fight lost then won, deaths heroic
  or silly, a rescue, a campfire, an inn. It never invents events: places,
  foes, levels and counts come from the journal; Lore.lua only says what a
  place or a foe is. On each person's card (People): *they* (default), *he*
  or *she*; **How it began**: *On the road* (you met in the game) or
  *Together* (you started your characters together: the tale begins where
  your people begin, rising in Deathknell, Northshire Abbey...); **They are**:
  spouse, partner, friend or family ("your wife", "your oldest friend").
- **Storytellers:** each of your characters has their own (chronicler, bard,
  veteran, wry, elder): the same facts in their own words and rhythm. The
  same journal reads differently on each of your characters, and the same on
  each every time. **Retell** (Story mode, bottom of the journal) tells it
  again in new words: same days, same facts.
- **Recorded too:** your level and theirs, a quest's level and kind, deaths
  (the cause from the death recap: a foe, a fall, drowning...), fights lost,
  who brought you back, rests at an inn or in a city.
- **Reading it:** switches in the journal's header. *Everything* shows
  every adventure. In Story, *Highlights* condenses repetition while keeping
  the places, discoveries, companionship, and important events connected.
  In Simple it keeps the shorter daily record of notable moments. Both use
  what was recorded. Five page styles, A to E: A is the original page; B Chronicle
  (chapter-like dates, book paragraphs), C Margins (the date in a margin,
  glyph lists), D Diary (your own voice, the book font, a drop cap), E Ledger
  (a band per day with its numbers, aligned rows). Right-click a scene or a
  line to remove it.

Every feature is its own toggle and starts off.

## With Forever Names

The two work alone or together. Together they are two linked windows: each has
a button that opens the other. Forever Names asks us who someone is through
`CompanionJournalAPI` (version 1), and tells us which plates it labels through
`ForeverNamesAPI`, so the icon goes on its label or beside Blizzard's name,
never both.

## Moving from Forever Names 1.9

The first time Companion Journal loads, it copies your people, their journals,
your never-add list and the People options from Forever Names' saved settings,
and tells you so in chat. Nothing is removed from Forever Names' saved
settings. People you already have here are kept; only missing ones are copied.
The "Add target to People" key binding keeps its name, so a key you bound still
works.

## Commands

- `/cj`: open the book (at your target's journal when they are in your list).
- `/cj me`: your own journal. `/cj book`: the book.
- `/cj journal [name]`: a journal (or your target's).
- `/cj tag [note]`: add your target.
- `/cj testleave [count|me]`: preview the group popup.
- `/cj movelist`: move the list from before to this character (when the
  first login was the wrong character; only while this one has nobody yet).

## Files

`Core.lua` (settings, the one-time copy, slash commands), `Glyphs.lua`,
`People.lua` (the list, adding people, tooltip, the player menu entry), `Characters.lua` (each
character's own list over the shared cards, recognizing, importing, moving
in), `GroupPrompt.lua`,
`Journal.lua` (recording), `JournalBook.lua` (days and scenes, the prose and
the highlights), `JournalTale.lua` (the storyteller), `JournalWords.lua` (its larger
phrasebook) and `JournalTellers.lua` (the five storytellers), `Lore.lua` and
`LoreData.lua` (places, dungeons, bosses, quest levels; the data file is
generated by `StorageInvestigation/journal-voice/make_lore_data.py`),
`JournalStyles.lua` (page styles B-E), `JournalUI.lua` (reading choices and the
ways into a journal), `JournalBookUI.lua` and `BookManagement.lua` (the book, the
window), `Plates.lua` (the icon beside Blizzard's
names), `API.lua`, plus the shared skin and color
palette (`OptionsSkin.lua`, `ColorPicker.lua`, copies of Forever Names').

The ornaments (`Media/Ornaments`) and the skull and chain-link glyphs come from `tools/make_ornaments.py`.

Tests: run each Lua file under `Interface/AddOns/CompanionJournal/tests` with
`lua5.1`, including `SelfScenes.lua`, `CompanionNarrative.lua`, and
`SelfRelationships.lua` for narrative continuity, deterministic retelling, and
live companion settings.
from the client root. Forever Names' `tests/Smoke.lua` runs both addons together.
