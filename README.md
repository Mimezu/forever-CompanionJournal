# Companion Journal

Remember the players you meet, and read your days together as a book.

## Install

Put the `CompanionJournal` folder in `World of Warcraft\_forever_\Interface\AddOns\`.
Restart the game after an update that adds files.

## Use

| Command | Opens |
|---|---|
| `/cj` | The book (your target's journal if listed) |
| `/cj me` | Your own journal |
| `/cj journal [name]` | Someone's journal |
| `/cj tag [note]` | Adds your target |
| `/cj movelist` | Moves the list to this character |

- Add people: target + key binding "Add target to Companion Journal", or right-click their name.
- Groupmates are offered when the group ends.
- Settings are in the book. Reading: Everything or Highlights, Simple or Story.
- Story mode tells each day as a chapter. Retell gives new words, same facts.
- Click a note to edit it. Right-click a line to remove it.
- Works alone or with Forever Names.

## Data

`WTF\Account\<account>\SavedVariables\CompanionJournal.lua`. Close the game before editing it.

## Tests

From the `_forever_` folder:

```
for f in Interface/AddOns/CompanionJournal/tests/*.lua; do lua5.1 "$f" | tail -1; done
```

## More

- [Changes](docs/CHANGELOG.md)
- [Details](docs/DETAILS.md)
- [Design](DESIGN.md)
