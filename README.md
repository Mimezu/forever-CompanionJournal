# Companion Journal (Forever 16001)

The players and NPCs you want to remember, and a journal of what you lived
through together. It came out of Forever Names 1.10: the People list, the
journal, the group popup and the campfire now live here, in their own window.

## 1.13.0: a story of your own

- **Battlegrounds as a story.** With "Record more moments" on, the end screen of a
  battleground is kept: won or lost, how long it ran, your flags, bases, towers and
  graveyards, whether you had the most killing blows on your side, and which of your
  people were in the match (with you or on the same side). Your chapter tells an
  evening of matches as one passage in order (the defeats, the first win you ever
  had, a win after defeats, the long one, the company), says what Warsong Gulch,
  Arathi Basin or Alterac Valley is the first time you are there, and counts a streak
  across evenings. Queue stops between matches are no longer told as travel. The
  companion book tells the matches you fought together with their result. Without
  the setting, only "fought in" is kept, as before.
- **More of your road is told.** Exact quest scenes, written from each quest's own
  text with two setups and two outcomes, went from 930 to about 2,260: every race's
  starting areas, the shared zones from 10 to 60 for both factions, dungeon chains
  (Deadmines to Blackrock Depths), class quests, and Forever's own content (Zephras
  Isle, the Ruins of Lordaeron, the Hall of Thanes, the Forsaken paladins, Crystal
  Lake, Alba Fairmoon and more). Every new scene was checked against the quest text
  by a separate reader; outcomes stop at what the quest itself says.
- **Your book remembers.** A foe that killed you before, a boss you finally beat, a
  return to where you died, the tenth or fiftieth day out with the same companion, a
  chain picked up again after weeks. How you play (gathering, fishing, crafting,
  dungeons, exploring, duels, night play) shifts what the book dwells on; it never
  calls you anything.
- **Companion books are a shared history.** The diary voice reads as two people's
  record ("Dahlia and I", "between us"); the game-master voice recaps your party.
  Your own firsts on a day together (a new zone, a continent, a first mount) reach
  their book too. Highlights now make a real cut.
- **Record more moments** (Settings > Recording, off by default): books and plaques
  read, areas discovered, flight paths, trainer spells, reputation standings, duels,
  trade-skill ranks, open-world honorable kills, rare creatures killed, and raising a
  companion from death. Also, with it on: the first gold piece, the first hundred and
  the first thousand gold, the first talent point (in the level-ten line), PvP ranks,
  and the first epic you craft yourself.
- **The big moments of a life, told as moments.** Level ten to sixty each say what the
  level changes; the first mount ends forty levels of walking; the swift mount names
  its thousand gold when both fall on one day; the first epic, the first set piece
  (and which raid holds the rest), the whole set with the weeks and visits it took, a
  world boss with its epithet, the first raid, a raid lord's first fall (Ragnaros,
  Onyxia, Nefarian, Hakkar, Ossirian, C'Thun, Kel'Thuzad) in its own sentence, a trade
  at three hundred by its own noun, exalted with the factions that give something for
  it, the first dungeon even when it killed you, the first of the other side to kill
  you, and the level-sixty look-back names the first thing that ever killed you. The
  dungeon set, the Ahn'Qiraj and Naxxramas sets count as set pieces. A companion's
  book now shares your swift mount, legendary, first blue, set pieces, world boss and
  rank when they were there.
- **Fewer machine tells.** Chapters a few days apart open on the place, not the date;
  a weekly companion's rhythm is said once; role lines never repeat; level sixty is
  told once; kills in one run make one sentence; place lines and articles fixed ("on
  Zephras Isle", "the Ruins of Lordaeron").
- **Lore notes:** about 330 new notes (every race's start, Forever's new zones and
  bosses, the people the new scenes name). A spoiler audit put 70 notes behind the
  quests that reveal them (Nathanos, Athrikus, Tirion and Taelan, the Missing
  Diplomat, Darrowshire and others). Common first names, and any name one of your
  characters or listed players carries, never link to an NPC.

## 1.12.5: the People list's menu is the addon's own

- **Right-click on a person in the People list opens Companion Journal's own menu**
  (Add Friend, Whisper, Invite to Group, Open journal) on a leather panel instead of
  Blizzard's context menu. Blizzard's menus opened from addon code taint the gamepad
  interface (A and B dead until /reload). The mouse or the gamepad cursor clicks the
  rows; Escape, or a click anywhere else, closes it. It now opens in the gamepad
  interface too; Whisper stays off there (it would focus the chat box from addon code).
- The "Add to Companion Journal" entry on Blizzard's unit menu is unchanged (there is no
  other way onto that menu); its code is now guarded so an error can never reach the menu.

## 1.12.4: review for the live client (build 70707)

- **The open book redraws only for its own journal.** A line written into another
  journal (a crossed path on a nameplate, a gathering count) no longer lays the whole
  book out again. Settings changes still redraw everything.
- **Your own journal listens to your casts only.** Spell and pet events are
  registered for the player unit, not for every unit in sight.
- **Lore notes in combat:** the slip no longer calls a protected keyboard function
  while you fight. Escape may then close the book too; nothing else changes.
- **The classic page groups a day's quests and bosses by the same evening rule as its
  chapter headings** (play after midnight stays with the evening before).

## 1.12.3: the book's pages keep their size

- **Companions and NPCs pages** are no longer magnified at book sizes B and C.
  Buttons, fields and text keep their size; the page gains room instead: wider
  fields, more people per page, and the actions at the foot of the page. The
  card's Read journal and Pin buttons sit at its right edge at every size.
- **Margins** keep the lists and buttons clear of the pages' printed corners.
- **Settings > Adding people:** Preview sits at the end of the Group prompt
  row, the same height as its choices, instead of over the heading.
- **Settings notes** no longer run into the next setting when they wrap.
- **Your notes are edited where they are written:** click a note in a journal and it
  becomes a text field on the page. Enter (or clicking elsewhere) keeps the change,
  Esc cancels, and clearing the text asks before removing the note. No more
  right-click menu.
- **Skin B: no header over the pages.** The window's title names the journal
  ("Alberich's journal"), and the journal's first page is its title page: the
  name in large lettering, who they are (and, for a companion, when you met), the
  quest log's flourish, then the portrait and the first chapter. Its top margin
  grows with the book's size.
- **Last names:** click the name on the title page to give it a last name
  ("Alberich Noir"). Yours is kept with your character, a companion's with their
  card.
- **Skin B, a companion's journal:** Pin is a cloth bookmark hanging from the top
  of the left page (full length when pinned, a faded stub when not); the quill
  beside it opens their card on the Companions page. The Journal / About / Notes
  tabs and the card's Edit and Card buttons are no longer on the pages (skin A
  keeps them). The Companions ribbon opens at the companion you are reading.

## 1.12.0: a connected world of lore notes

Added 334 sourced world entries: settlements, city districts, landmarks,
major quest characters, factions, historical figures, wars, battlegrounds,
and world events. The catalogue now contains 854 world notes, separately from
the 878 exact quest-stage contexts and 660 conservative quest-title contexts.
Most additions cite quest text; historical and travel notes also cite reviewed
Blizzard sources. Custom Forever places retain their setting label.

Every named zone, dungeon/raid key, boss and town currently used by the addon
resolves to a note. The coverage test also checks every fixed place/person tag
in the storyteller templates, canonical titles, aliases and related links.
Canonical one-word places and reviewed character names can now become links
in plain prose, while ambiguous names and ordinary words remain conservative.
Companion links keep priority over world characters with the same name.

This is coverage of the current catalogue and audited story vocabulary, not a
claim to have inventoried every name in every Forever quest. Unknown entities
still require verified sources; notes never invent a character's participation.
No recorded history or saved companion settings are changed. Use `/reload`.

## 1.11.0: journeys from the first roads to the level-60 raids

Added 249 quest-stage contexts across the requested leveling bands and endgame,
bringing the four story packs to 878 exact stages. The additions include early
Alliance and Horde journeys, shaman trials, later class quests, connected regional
investigations, dungeon errands, attunements and raid trophies. Both personal and
companion tellers use these contexts, in full stories and Highlights. Historical
title-only records retain conservative fallbacks when a chain's stage is unknown.

Added 354 curated lore notes, bringing the catalogue to 476. An independently
reviewed roster checks 328 named encounters across 29 dungeon/raid locations and
seven outdoor foes. All 335 are recognized by the storyteller and have clickable
lore context. Optional, rare and invasion encounters remain identified as such;
these entries do not claim that a character encountered them. Forever-specific
Lordaeron and Hall of Thanes context uses captured custom quest text.

Majordomo's surrender and Celebras's release now receive nonlethal victory prose.
Several older boss conclusions no longer imply an unrecorded rescue, worldwide
cure, or later trophy display. Dungeon aliases resolve their written context, and
lore-name matching uses an index to keep the larger catalogue inexpensive to read.

The companion selection highlight now contains both lines of the row, and
unpinned companions no longer return automatically as right-hand bookmarks.
Icon and colour pickers remain mutually exclusive and preserve cancellation.

This is a coverage pass, not a claim that every quest or every custom Forever
encounter is authored. Source ledgers and remaining gaps are recorded under
`StorageInvestigation/*20261012*`; no missing history is manufactured. Reload the
UI to load the new content. Existing events can be retold with the expanded prose.

## 1.10.1: compact companion cards on parchment

The Companions bookmark now uses visible category buttons, seven compact roster
rows per page, and a complete card on the facing page without scrolling. Icon,
colour swatch and size controls sit together; story settings, history and list
actions have separate groups. Native WoW buttons and existing parchment art keep
the book's appearance. Both pages scale together to fit the chosen book size.

Icon and colour pickers follow the window that opened them, fixing their hidden
parent in Layout B. The decorative wooden strip above the pages has been removed
throughout Layout B. The companion view also uses the former heading space for
its pages; journal character headings remain visible.

## 1.10.0: companion management and settings in the book

Layout B now has a permanent **Companions** bookmark. Search and turn through
your people on the left; read their journal or edit their card on the right.
The page includes categories, relationship and pronoun settings, icons, pins,
notes, removal, blocked names, and importing people from your other characters.
Returning from a journal preserves the list's search, page and selection.

**Settings** now contains Reading, Testing, People in the world, Adding people,
and Recording. These edit the same saved preferences as Layout A, directly in
the book. The old settings-popup link is gone. Journal buttons, commands and
external addon links respect the selected layout. Other-character journals
stay read-only and use their own narrator and relationship records in B.

Reload the UI to load the new module. Layout A remains selectable.

## 1.9.2: minimap placement

The minimap button follows the actual map radius instead of a fixed 80-pixel
orbit, including live minimap resizing. Its saved angle and drag placement remain.

## 1.9.1: a steady, lighter reader

The reading window now keeps a fixed size across short pages, long chapters and
edition changes (660 by 740 at normal screen sizes, reduced to fit smaller screens).
Its title, edition tabs and chapter selector have separate rows. A thin muted
border and plain close control replace the heavy Blizzard window frame; dragging,
Escape, lore notes and returning to the main journal still work.

## 1.9.0: reading experiments

Reading view now has four choices along its top edge:

- **Original:** the existing journal on a larger page, using your current style,
  voice and detail settings. This remains the default for comparison.
- **Your tale:** full story prose arranged into chronological chapters for
  recorded places and expeditions. Adjacent sessions in the same place can
  continue one chapter; a later return stays in its recorded order.
- **Our story:** the same chapter treatment for a companion's recorded shared
  history, in the first-person plural voice. From your own journal, the companion
  selector prefers a spouse and cycles through people with shared records.
- **By the fire:** the shorter storytelling selection, keeping each place/session
  as a separate episode. This is an initial reading experiment, not a new source
  of invented dialogue or memories.

The main book hides while reading and returns to its page on close. Top arrows
jump chapters or episodes; bottom arrows and the wheel turn physical pages.
Each edition remembers its page during the session. The edition preference is
saved, while journals, personal notes and Retell seeds are untouched. Lore links
remain available. New editions use the Chronicle typography with quieter dates.

These prototypes reuse the lore-aware storytellers. They introduce chapter
composition and a relationship perspective, not a fully rewritten novel engine.

## 1.8.0: connected adventures and more readable pages

- Added 207 sourced quest stages: 629 exact stages across the four content packs.
  Crossroads and Ratchet work, the Defias investigation, dwarven deliveries,
  Raene's search, Darrowshire and the Fordring family now have more connected
  steps. Coverage remains representative; the inventory lists its scope.
- The storytellers can retain several meaningful recorded stages in a scene.
  Highlights preserves a chain's beginning and important resolution, rather
  than letting intermediate referrals crowd out the final delivery.
  Companion chapters also retain work across distinct outings and capitals,
  in order around recorded deaths, dungeon visits and rests.
- Paragraphs turn with a change of purpose, place or time. A quest's supported
  outcome stays with its action. All five narrative styles use modest paragraph
  spacing; page breaks avoid isolated first/final lines where space permits.
  Layout references: [Butterick on paragraph spacing](https://practicaltypography.com/space-between-paragraphs.html)
  and [line spacing](https://practicaltypography.com/line-spacing.html).
- Lore slips have a full opaque parchment background and stay clear of the
  header. Clicking either mouse button on the book dismisses the slip without
  activating the control underneath. Right-clicking inside the slip also closes
  it; its left-click navigation still works. The same behavior applies in Reading view.
- Added 70 sourced lore notes (120 curated references in total). The catalogue
  includes Fenris Isle and Fenris Keep, additional
  Silverpine people and places, and settlements across both factions. Known
  names link to sourced context; uncertain or ambiguous names stay unlinked.
  Exact full names can gain links when pages are rendered, including names
  already in older prose. Saved journal text and quoted player notes are intact.

Reload once to load the update. Tests use synthetic journals or read-only copies
of saved history; they do not rewrite your adventures. Native font rendering and
art still need an in-game check after reload.

## 1.7.0: a wider world, real pages, and lore notes

- **All beginnings and classes.** Four sourced content packs add 422 precise
  quest stages and 276 title contexts across Horde, Alliance, later regions,
  and the nine classes. Forever material includes Zephras and supported class
  variants. A tauren shaman now has authored Mulgore work, rites and individual
  totem stages; this expansion is not restricted to Alberich's history.
- **Evidence before atmosphere.** New quest records retain IDs. Exact stages
  get their own consequences; ambiguous old titles use conservative context.
  Race and class do not invent a first hunt, learned spell or completed trial.
  The source inventory and writing rules live in `STORY_RULES.txt` and the
  content packs. Run `lua5.1 Interface/AddOns/CompanionJournal/tools/StoryCoverage.lua`
  from the client root for current coverage (`full` also lists exact stages).
- **Pages turn.** Long chapters continue onto additional pages in the book
  and Reading view. The mouse wheel and arrows turn pages; text pages have no
  scrollbars. Breaks use measured text lines and prefer paragraph boundaries.
  Navigation reuses the current telling instead of rebuilding the whole book.
- **Parchment lore notes.** Known world names open short reference notes inside
  the book or reader. Related notes, Back, Sources and Escape preserve the
  reading context. Longer notes also use pages. Companion names retain their
  violet links to their own journals. Unknown names remain ordinary emphasis.
  The initial catalogue has 50 curated notes, 44 regional notes and sourced
  quest contexts, for 792 entries. It includes the standard Classic dungeons
  and raids, with boss notes added only where supported by source material.
- **Knowledge is not memory.** Reading a note never records a visit or meeting.
  Quest notes contain setup context, not completed outcomes. Source perspectives
  stay attributed; future expansion lore is not imported into Classic/Forever.

Coverage is representative, not every quest, chain or boss. Sparse old records
cannot recover adventures that were never recorded. The existing language
engine remains local and deterministic; this addon does not call an AI service.
Reload the game UI once after this update.

## 1.6.0: stories with room for the adventure

- **Highlights keeps connected scenes.** First shared outings, sustained visits
  to new places, town stops, quest progression, and a recorded quiet moment can
  survive alongside the victories. Personal chapters retain their travel
  connections; companion chapters summarize repeated routine days, including
  a routine stretch at the end of the book.
- **Prose has scenes and memory.** Place changes and meaningful shifts create
  paragraphs in every page style. First recorded regions get grounded setting;
  separate places can carry separate quest context. Companion returns can
  recall an earlier recorded campfire, sunset, or landmark. Retell varies the
  language while keeping the history intact.
- **Origins and missing history.** A configured shared origin remains part of
  the story, with a transition when surviving records begin somewhere else.
  Earlier unrecorded quests, visits, and conversations are not reconstructed.
  A later capital visit is not introduced as the first if the story already
  visited that city.
- **Notable NPCs, going forward.** The personal journal records targeting a
  known classic leader (including Lady Sylvanas Windrunner), and distinguishes
  that sighting from opening their gossip or quest dialogue. Repeated targeting
  does not produce repeated entries. These encounters use the game's English
  NPC names; entering a city alone never counts as meeting its leader.
- **Current companion settings shape the telling.** Display names, pronouns,
  bonds, and shared origins refresh open journals and Reading view immediately.
  Spouse uses wife, husband, or spouse for she, he, or they respectively.
- **Book polish.** Names and subtitles have space below the title border, long
  display names leave room for the card controls, the wooden strip and scroll
  rail are quieter, and the footer fits the smallest supported book size.
  Scene paragraphs stay separate in Diary as well as the other page styles.
- **Reading view.** Larger type, an opening capital, a running title, and a
  quieter page frame give the text room. Short entries use a compact window;
  long chapters continue across pages in 1.7. The current-day status sits in the footer.
- **Companion links.** Clickable names use distinct violet ink and a tooltip
  explaining where they lead. Multiword names and decorative initials retain
  their link in every page style. World-name highlights remain emphasis.

After updating the addon, reload the game UI once to load the new code. Existing
recorded adventures are retold automatically; the recorder can only add new NPC
encounters from that point onward. Everything remains local to the addon.

## 1.3.0: a list per character

- **Each character has their own list and journals.** A person's card (name,
  display name, icon, note, last seen) is shared by all your characters; the
  relationship (Companion, Acquaintance, Campfire, Rival, how it began, the
  bond, when you met, the journal) belongs to each character.
- **Recognized on your other characters** (on by default: *Show their people
  on this character too*, under People > My characters): a chain link beside
  their name, not their own icon: **gold** for another character's companion,
  **silver** for an acquaintance, **red** for a rival (on either side: meet
  your old Horde rival on a new Alliance character). When your characters
  disagree, gold wins over red, red over silver. Campfire people: nothing.
  Their tooltip says whose they are ("Alberich's companion"). Click a link in
  the legend to change its color.
- **People > My characters:** everyone your other characters know that this
  one does not. Add someone (their icon, name and note come along; this
  character's journal with them starts fresh), or **Add all companions** at
  once. Players of the other side stay with the characters of that side
  (greyed); an old rival of your side comes in as an acquaintance.
  Double-click someone to read their journal.
- **Kept by** (in the journal): when several of your characters keep a
  journal with someone, switch between them. Another character's journal is
  read only, and told by that character's storyteller.
- **NPCs** are shared by all your characters, unless you tick *Only on
  (this character)* on their card (a class trainer, say).
- **Moving in:** the first character you log in with gets your list and
  journals (chat says so). Players of the other side (not rivals) wait under
  My characters as "Alliance (from before)" or "Horde (from before)". Wrong
  character? Log in with the right one and type `/cj movelist`. Nothing is
  deleted.
- **Writing: Simple or Story** is now also under Options > Journal (same
  switch as the journal's header). Simple is the plain record, no
  storytelling.
- **The storyteller, rewritten after a writing review** (a vanilla-quest
  writer's critique, measured against 4,264 vanilla quests): plain, flowing
  sentences in the voice of the old quest texts, and never a word about the
  telling (no songs, verses, journal or "the road"). Nothing that was not
  recorded: no speech, feelings, meals or who struck the blow. The day is told
  in the order it happened; a clean dungeon run is one sentence; a lord's fall
  says what it meant ("The Searing Blade had lost its master."). Places and
  foes get a description once, not every time. Chapters are as long as their
  day. The storytellers (chronicler, bard, veteran, wry, elder) change the
  words and rhythm, never the facts.
- **Chapters open in more ways:** not always on "You and Vex". The quest, the
  place or the hours may lead ("Four quests took you and Vex over three hours
  in Thousand Needles."), a chapter may leave your companion unnamed when the
  one before named them, and two quiet days in the same place are told as one
  chapter ("Monday and Tuesday found you and Vex still in Stonetalon
  Mountains").

## 1.5.1: the book's skin B, and tidier pages

- **Book skin B** (Settings > Testing, or `/cj skin b`; `/cj skin a` goes back). The
  book is built again with the game's own art:
  - the spellbook's pages, meeting at the fold;
  - cloth ribbons for the journals (blue for yours), the window's leather plate
    for the tools, with the class icon at the ribbon's tip;
  - names in ink with a thin class-colour bar; the quest log's highlight bars;
  - On/Off settings as checkboxes, the other choices written on the page;
  - a slim brown scroll bar; the spellbook's page-turn arrows;
  - one footer row (the X closes the book);
  - the Reading view as one spellbook page with wide margins.
- **Both skins**
  - Scroll bars hide when a page has nothing to scroll.
  - Settings: a new section opens at its top, and notes no longer run into the
    next setting.
  - The contents page's add buttons wear the window's plate.

## 1.5.0: the book (layout B)

A new window where the journals come first, built to be tried in game. It is
**layout B**: `/cj layout b` makes `/cj` open it, and `/cj layout a` brings back
the list window as it was. `/cj book` opens the book either way.

- **The book**
  - The contents on the left page: your journal, then your people by list.
  - The open journal on the right, one page at a time, or two pages side
    by side (One page / Two pages).
  - Turn pages with the arrows or mouse wheel. Everything/Highlights,
    Simple/Story and One/Two pages are in Settings > Reading.
- **Bookmarks on the right edge**
  - Your journal, the list's sections, the companions you pin (Pin, next to
    their name).
  - NPCs and Settings below, smaller.
- **Settings is a page of the book**
  - Reading: what the pages show, the page style A to E, the book's size, and
    the extras below.
  - Testing: the variants to try (see below).
  - People and the world: the list window's settings.
- **Opening the book**
  - Your target, when they are in your list.
  - Else the first chapter you have not read.
  - Else your latest.
- **Unread chapters** get a red ribbon on the page and on the contents.
  - A notice when today's chapter is new and you rest (off by default).
  - A minimap button with a red dot (layout B only).
- **Extras**, each with its own switch under Settings > Reading:
  - **Today, so far:** today's chapter of your own journal.
  - **Names open their journal:** click a companion's name in a chapter to open
    their journal at that day.
  - **Reading view:** one chapter, large, with no window around it.
  - **Timeline:** under a companion's page, their chapters as marks (deaths,
    dungeons, levels); click one to turn to it.
- **Portraits**
  - You as you were, from the looks Wardrobe Time Capsule saves at each level;
    otherwise as you are now.
  - Off by default.
- **Gamepad**
  - D-pad left/right: the contents or the page; up/down: move or scroll.
  - A opens, B goes back, LB/RB turn chapters, LT/RT the card and the journal.
  - Y adds someone, X opens Settings.

**Testing (Settings > Testing).** Every open design choice can be switched in
game:

- **Bookmarks:**
  - A: sections and pins.
  - B: pins only.
  - C (the default since the first tests): labelled ribbons on both sides: the journals (yours, pinned, then
    companions) on one, the book's tools (Add someone, Reading view, NPCs,
    Settings) on the other. "Bookmarks C: the tools' side" swaps them.
- **Companion card:**
  - A: Edit opens the card on the left page.
  - B: tabs, Journal / About / Notes.
  - C: Card flips the page.
- **Adding someone:**
  - A: a smart button ("Add Vex" / "Open Vex").
  - B: three steps (who, list and bond, name).
  - C: today's flow.
- **Unread ribbons:**
  - A: on every unread chapter.
  - B: the newest, with small marks on the rest.
  - C: the first unread.
- **Portraits:**
  - When: off, the book's start, every ten levels, each level.
  - Where: a plate above the chapter, the facing page (two pages), a cameo,
    the contents page, the margin.
  - Frame: painted, cameo, scrapbook, plain.

## 1.4.1: one owner for each setting

- With Forever Names installed, your people's icon is placed among its other
  icons, and that place is set there (Position: "Set in Forever Names").
  Without it, Before and After stay here, for the icon this addon draws itself.
- The footer has a **Names | Journal** switch when Forever Names is installed.
- After midnight, play belongs to the evening before ("Thursday night", under
  Thursday's date), and a first visit recorded late is no longer told as one.

## 1.4.0: the storyteller, deeper

- **A life's big moments, kept**: your first sight of the other side, your
  first battleground, joining a guild, a new home for your hearthstone, the
  first one you bring back from death, your first blue item, class
  milestones (a felsteed or warhorse, bear form, a first pet, a voidwalker,
  a first portal...), the Darkmoon Faire, the Great Lift and other
  landmarks, fishing, and the hearthstone home at the end of a day. Deaths
  to the other side keep their race and class, not their name.
- **Small wonders**: the first snow you ever walk in, a rare creature
  crossing your path, a long swim, a flight by night, a night at the inn
  (logging out there and sleeping on it), the long walk back as a ghost,
  fishing from a dock, your first sale at the auction house.
- **Ninety famous quests** carry their story: why they were asked, or what
  came of them (Mankrik's wife, Deliah's ring, Hogger, the Defias...).
- **Your own storyteller** tells whole lives:
  - a first page by where your people begin (Deathknell, the Valley of Trials,
    Northshire...), and the first sight of each capital;
  - your first death (a Forsaken sees it differently), Hogger and the other
    names everyone has a story about, and the stranger who brought you back;
  - reunions with someone you had not seen for weeks;
  - clumsy days ("I fell to my death twice...");
  - quiet days of herbs, fishing and sightseeing that end on the sunset;
  - raid nights, Benediction and the other famous things, told as they are;
  - level sixty, looking back at where it began.
- **Longer, smoother sentences**, and fewer repeated openings, endings and "first time"s.
- **Your companion chapters** now tell what your own journal saw while you
  were together: a sunset watched together, a crossing by sea, a landmark,
  a near thing, the herbs picked along the way.
- **Dungeon and zone lore**, rechecked against the quest texts: three or
  four lines each, and one concrete thing seen inside each dungeon.
- **Fifteen whole lives, read and rewritten** (young and old, alone and in
  pairs, healers, gankers, crafters, wanderers, the clumsy and the fast):
  - a rematch is told as one ("We finished The Legend of Stalvan, and this
    time it was Mor'Ladim who died.");
  - a couple who began together, or an oldest friend back after months, are
    told as what they are to you;
  - a battleground evening, three deaths to the other side, a level-60 look
    back for a late book, a speed leveller's pace, a third fall;
  - your mount by its kind (a raptor, a great kodo), read from the mount;
  - "home" only where your people begin, or their city;
  - a book started at a later level makes no "first ever" claims;
  - priests of the Light are humans, dwarves and gnomes;
  - everyday levels left out of chapters that have better endings.

## 1.3.0: your own journal

- **My journal** (button beside "People", or `/cj me`): what this character
  lives through, always, alone or with others, in the first person. Zone by
  zone, every quest by name (kept forever), dungeons and bosses, deaths and
  close calls ("A Kobold Tunneler nearly got me.", "I almost fell to my
  death."), caves and mines you go down into, level-ups, inns and campfires,
  who brought you back, and who from your list was with you. Honest work
  too: veins mined, herbs picked, beasts skinned, things crafted ("I made
  nine things at Tailoring, among them a Linen Cloak."). And firsts: the
  Deeprun Tram, your first flight, your first time in a zone. And voyages:
  crossing to another continent by zeppelin or boat (or by hearthstone
  or portal), with the first zeppelin, the first sea crossing and the
  first time on each continent kept as firsts. It starts with
  what your journals with people already knew. All five styles, Simple or
  Story. Your other characters' journals are read only.
- **Your own storyteller** (Story): a chapter a day, in your own words.
  Cities and villages are told by who you are: Brill is home to a
  Forsaken, a Horde stop to an orc, and an enemy town to a human
  (about sixty towns). It tells honest-work days, close calls, caves,
  firsts, lords and what their fall meant, and who joined you.
- **Your journals cross over**: a chapter with a companion can say where
  you were before they joined you ("Before that, you had spent a long day
  alone in Desolace.").
- **Your level-ups** are now kept in the journals of the people you travel
  with too ("Dahlia and I both reached level 16.").
- **Journals are kept whole**: no limit on days or lines.

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

- `/cj`: open the window (at your target when they are in your list).
- `/cj journal [name]`: a journal (or your target's).
- `/cj tag [note]`: add your target.
- `/cj testleave [count|me]`: preview the group popup.
- `/cj movelist`: move the list from before to this character (when the
  first login was the wrong character; only while this one has nobody yet).

## Files

`Core.lua` (settings, the one-time copy, slash commands), `Glyphs.lua`,
`People.lua` (the list, adding people, tooltip, menus), `Characters.lua` (each
character's own list over the shared cards, recognizing, importing, moving
in), `GroupPrompt.lua`,
`Journal.lua` (recording), `JournalBook.lua` (days and scenes, the prose and
the highlights), `JournalTale.lua` (the storyteller), `JournalWords.lua` (its larger
phrasebook) and `JournalTellers.lua` (the five storytellers), `Lore.lua` and
`LoreData.lua` (places, dungeons, bosses, quest levels; the data file is
generated by `StorageInvestigation/journal-voice/make_lore_data.py`),
`JournalStyles.lua` (page styles B-E) and `JournalUI.lua` (the window),
`Plates.lua` (the icon beside Blizzard's
names), `API.lua`, `Options.lua` (the window), plus the shared skin and color
palette (`OptionsSkin.lua`, `ColorPicker.lua`, copies of Forever Names').

The ornaments (`Media/Ornaments`) and the skull and chain-link glyphs come from `tools/make_ornaments.py`.

Tests: run each Lua file under `Interface/AddOns/CompanionJournal/tests` with
`lua5.1`, including `SelfScenes.lua`, `CompanionNarrative.lua`, and
`SelfRelationships.lua` for narrative continuity, deterministic retelling, and
live companion settings.
from the client root. Forever Names' `tests/Smoke.lua` runs both addons together.
