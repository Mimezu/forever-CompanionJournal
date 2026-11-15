# The Road: a hero path for Companion Journal (proposal, 2026-11-14)

A map for every day of the book: the road you walked, where you stayed, where you fell,
who walked with you. It can be replayed like Zelda's Hero Path mode. A world overview shows
the whole adventure. Nothing here is built yet; this is the design to agree on first.

## The idea in one paragraph

The book already knows the *story* of each day: the episodes, the companions, the deaths,
the firsts. The Road gives it the *ground*: the actual line you walked, drawn in ink on the
zone's own map, laid on the book like the folded papers. Read a chapter, unfold its map,
press play, and watch the day happen again: the line crawls out of Brill, pauses at the
campfire, stops at the X where the duskbat got you, and finishes at the inn. The text and
the map point at each other. In Dahlia's book the map shows only the road you shared.

## What we take from each source

| From | We take | We leave |
|---|---|---|
| **Zelda, Hero Path** | The true path, every step. Replay from the start with a moving marker and a time scrubber. Death marks on the path. Older roads fade. | A single line with no story. Ours always knows what happened where. |
| **Social Diary** | Map art drawn inside our own frame. Stays shown as soft ink blobs. Roads thinned and smoothed in the story view. Flights dashed. Deaths and fights as marks. The folded map sheet over the book. | Splitting by level. Ours splits by day, which is how the book is written. |
| **Our book** | Days and chapters, episodes (dungeon runs, journeys, bad stretches), companions and the relationship, few words, the parchment look. | Nothing: the map serves the story. |

## What the player sees

**1. The day map.** It opens from a small map mark under each chapter's title, or by
clicking a place name in the text. A folded map sheet opens over the book, using the paper
styles we just made.
- **Zone tabs, in the day's order** ("Tirisfal → Silverpine → Undercity"), plus
  **Continent** and **World**. Each zone shows the zone's own art, tinted to sepia, with the
  road in brown ink.
- **Two views of the same day:**
  - **Hero path**: the true line, every turn, the way you really walked it. A thin ink line
    that is darker where it is recent. Mounted stretches are slightly wider.
  - **Story**: the line simplified and smoothed. Stays become ink washes, darker the longer
    you stayed: a campfire is a small blot, a two-hour questing area a broad wash. Only the
    moments the chapter tells get pins.
- **Marks:**
  - **Deaths**: a red ink X, with the time and the killer on hover ("21:42, a Ragefire
    trogg"). A ghost's run back is a faint dotted line.
  - **Levels**: a small star.
  - **Firsts**: our red rubric, e.g. the first sight of Kalimdor.
  - **Dungeon doors**: one door mark with the run's length, since positions inside
    dungeons aren't readable.
  - **Campfires and inns**: a small flame or bed.
  - **Travel**: flights as a dashed arc between flight masters, boats and zeppelins as a
    dashed sea line, a hearthstone as a puff at the start and the end.
- **Companions on the road:** the stretch walked *with* Dahlia is drawn as a doubled line,
  two inks side by side; the rest is single. You see at a glance where you were together.
  In Dahlia's book, only the shared road is drawn.
- **Hover anywhere on the line:** the time and what was happening: "22:05, with Dahlia and
  Marrow, toward Pyrewood".

**2. Replay (the Hero Path moment).**
- **Controls:** play / pause; speed ×1 ×4 ×16 (about 1 min, 15 s or 4 s for an evening); a
  scrubber with the hours of the evening.
- **What moves:** the marker is your class crest, the round one we just made. The line
  draws behind it; pins pop in as they are passed; the camera follows across zones and
  swaps the map tab by itself.
- **Sounds (optional, quiet, all from the game's own sound kits):**
  - a faint quill scratch while the ink runs
  - a muffled drum for a death
  - the level-up chime, softened
  - a door for a dungeon
  - a page turn when the zone changes

**3. The whole adventure.** An **Atlas** page in the book (a bookmark, like Settings):
- **The world map** with every road ever walked. Each day's ink ages: the last week is
  dark, older months fade.
- **Play the adventure:** a time-lapse, about one day a second, from Deathknell to today.
- **A few facts in few words:** days on the road, leagues walked, zones known, deaths.
  Click a road to open that day's chapter.

## How it is recorded

- **Sampling:** every 2 s while moving, none while standing still, in combat (the fight's
  time is added to where you are), on a taxi, or in an instance. A hidden or missing
  position is a pause, never a guess. Distances are in yards (`UnitPosition`); drawing uses
  zone coordinates (`C_Map`).
- **The true path:** a point every ~12 yd, stored packed: about 4 characters a point plus a
  time step. An evening of 3 hours is about 20-30 KB.
- **Keeping it small:**
  - The last 30 days keep their full path.
  - Older days are thinned (Douglas-Peucker, ~10 yd) to about a fifth of the size.
  - Story view data (stays, simplified roads) is computed when the map is drawn, not stored.
- **Breaks in the line:** a teleport, a loading screen or a >60 s gap ends the line, so we
  never draw a road that wasn't walked.
- **Joining events to the map:** events need no positions of their own. Every journal
  entry already has a time and a zone, and the map finds its spot on the path by time.
  This is also why old days work.
- **Days before the recorder:** they have no path, but they do have the zones and times.
  The Story view and the World overview can show them right away: blobs for each zone's
  stay, joined in order by a faint dashed line. The whole adventure has a map on day one,
  and the true path fills in from the day recording starts.

## Following the house rules

- A setting, **Record the road**, is on by default (the user's choice, 2026-11-14) and can be
  turned off in Settings > Recording.
- The UI uses few words: tabs, ▶, ×1 ×4 ×16, and hover text.
- The map art and sounds are the game's own. The paper is ours.
- **Performance:** a cap on drawn segments, as Social Diary and LoreForever do (≈450 per
  view, re-thinned per zoom). Map tiles are loaded over several frames, and there is no
  OnUpdate except during replay.
- **Forever specifics:** retail-style map ids (Kalimdor 1414, Eastern Kingdoms 1415,
  world 947). `UnitPosition` returns y first. Positions can be hidden even when the map id
  is not. City map rectangles are imprecise, so cities use their corner positions.

## Building it in steps (each one usable on its own)

1. **Recorder** (setting off by default), with a debug view. You play a few evenings and we
   check the data.
2. **Day map, static:** zone tabs, the Hero path line, death X's, pins, hovers, and the
   link from chapter to map.
3. **Replay:** marker, speeds, scrubber, sounds.
4. **Story view and the Atlas:** blobs, the world overview, ageing ink, playing the whole
   adventure; days before the recorder shown from their zones.
5. **Companions:** the doubled line for the road walked together, and only the shared road
   in their books. Clicking a place in the text highlights its stretch of road.

## Decisions for you

1. **Where the map opens:** a small mark under each chapter title (my pick), a ribbon on
   the page edge, or both?
2. **How long the full path is kept:** the last 30 days (my pick), all of it (bigger saved
   file), or 7 days?
3. **Default view:** Story first, with Hero path one click away (my pick), or Hero path
   first?
4. **Sounds in replay:** on by default, or off?
5. **Atlas:** its own bookmark (my pick), or a tab inside Settings?
