# Adding a team

The retail image is 28 teams: ANH 0 through WPG 25, then ASE 26 and ASW 27. `NumTeams` is `ASW+1`. `NumPlayoffTeams` is `ASE` (26). One extra team that leaves `NumPlayoffTeams` at 26 still fits in save RAM. Raising `NumPlayoffTeams` to 27 moves the save checksum and the assemble stops. More than 32 playoff teams stops the assemble. There is no 1.5 MB or 3 MB ROM.

Give the new team a number in `src/stubinc/equals.inc`, in `TeamList` order. `NumTeams` and `NumPlayoffTeams` follow from `ASW` and `ASE`. Put the team record in `src/teamdata95.asm`, which is included before the engine, so the engine's PC-relative branches move together.

## Tables the assemble checks

Each of these is one entry per team. The assemble stops when the length is wrong.

- `TeamList` in `src/teamdata95.asm`: one `dc.l` per team.
- `TeamLogoBitmaps` and `TeamGfxList` in `src/engine/middle95.asm`: one long each. ASE and ASW share one ice-logo block. The list still has one long per team.
- `TeamLogoPalettes` in `src/graphics95.asm`: 32 bytes.
- `FeaturedPicIdx` in `src/graphics95.asm`: 6 bytes. `FeaturedPictures` is the picture list, not one entry per team.
- `TeamSongs` in `src/sound95.asm`: 6 bytes.
- `TeamRatings` and `TeamRatingsLine` in `src/front/scout95.asm`: one byte per team, then two unused bytes. The check is `NumTeams+2`. Insert the new byte at the team's index. The unused bytes stay at the end.

These are one entry per playoff team. They do not grow when only `NumTeams` grows.

- `SimGoalsHome`, `SimGoalsAwayDef`, `SimGoalsAway`, `SimGoalsHomeDef` in `src/front/season95.asm`: 10 bytes per playoff team.
- `SimTieTbl`: 3 bytes per playoff team.

`playoffseats` is 32 rows of 16 team numbers. It is not one entry per team.

Do not change speeds, coordinates, sprite heights, or the 26 roster slots. `src/front/create95.asm` `move.w #$1A,d7` and `ReadStatBlock`'s `#$19` are roster slots. Leave them.

## Banner maps

`Teamblocksmap` and `TeamBitmaps` are two rows, 11 tiles wide. `PauseTeamBlocksMap` is two rows, 12 tiles wide. `tools/prebuild.js` measures all three and writes `output/teamcounts.inc`. The assemble checks the width and that the row count is two per team.

Insert the new team's two rows at that team's index. Appending them leaves the new index showing the old art. Copy the rows from the team whose art you are reusing, and raise the map height by two.

## Save RAM

`src/ram95.asm` maps $8000 bytes. Each block stays at its retail address while the block before it still ends on that address. A larger league starts that block at the previous end, in address order.

Crowd records are `NumTeams` blocks of 16 and end on the team-records block. Player stats, standings, team stats, the second and third saved line blocks, and the second team-stat block are `NumPlayoffTeams` long. Rosters, lines, the first saved line block, jerseys, and injuries are `NumTeams` long. Team records, the name log, game results, created players, and the free-agent list stay a fixed size. The free-agent list stays 26 slots.

One extra team that leaves `NumPlayoffTeams` at 26 still fits, and `SRChecksum` stays put. Raising `NumPlayoffTeams` to 27 moves `SRChecksum`, and the assemble stops.

Work RAM that mirrors a save block (`RosterTable`, `CreatedList`, `RosterRatings`) stays at the retail address. `LeaderTeamTbls` offsets follow `NumPlayoffTeams`, but that work RAM does not grow.

## Pad and checksum

`src/nhl95.asm` pads with $FF to 2 MB, or to 4 MB when the image no longer fits. The header ROM end in `src/sega/SegaIDTable95.asm` is `RomEnd`, the last byte of that pad. The stock image keeps end $001FFFFF. Past 4 MB the assemble stops. The header backup-RAM window stays $200001-$20FFFF. Content past $200000 overlaps it: the assemble warns and still builds.

`tools/patchchecksum.js` runs after `fixopcodes` on `output/modified_nhl95.bin`. It sums every long below `ValidationRoutine`, skips the header long at $18C, and writes that sum over the `cmpi.l` immediate. The source keeps $366A73F5, so the checksum segment is not patched. On the stock ROM the line is `checksum 366a73f5 -> 366a73f5`. The compare is a real CMPI (0C80). `fixopcodes` does not rewrite it. The header word stays $3C61.

## Startup branch

`src/main95.asm` keeps `bra.w Begin` while `LONGBRA=0`, which `build95.bat` and `buildseg.bat` pass. If the assemble log says the branch is out of range, `build95.bat` runs once more with `LONGBRA=1` and a long jump. The segment stub passes the same symbol. `Begin` sits before the team data, so growing `TeamList` does not push that branch out of range.

## Build

```
export WINEDEBUG=-all
node tools/prebuild.js retail
export NHL_PREBUILD_DONE=1
wine cmd /c "set rev=0&& set checksum=1&& build95.bat"
node tools/fixopcodes.js "output/nhl95 .lst" output/nhl95.bin
node tools/patchchecksum.js output/modified_nhl95.bin
```

`tools/verify_all.sh` does the retail image and every segment, and prints `ALL MATCH` when they all match. Wine `cmd` treats `||` as a failed command, so the batch files check `errorlevel` instead.
