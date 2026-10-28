# Expanding the ROM

`main` is a faithful disassembly of the retail cartridge: a stock build matches the retail 2 MB image. It keeps only changes that emit the same bytes (equates, labels, assemble-time checks, build tools). Fixes that a bigger ROM or a bigger league needs are described here and belong on a mod branch, not on `main`.

## What main already does for you

- `tools/fixrom.js` runs after `fixopcodes`. It pads the image with $FF to the next size of 1, 1.5, 2 or 4 MB, writes the header ROM end ($1A4), then writes the boot checksum through `tools/patchchecksum.js` (the `cmpi.l` immediate in `ValidationRoutine`). The stock image stays 2 MB and byte-identical.
- `src/nhl95.asm` fills to 2 MB. Includes placed after that fill start at $200000.
- `src/shortcalls.inc` (included last, emits nothing) stops the build if `Begin` moves out of reach of the startup `bra.w`; `build95.bat` then prints the fix.
- `NumTeams` / `NumPlayoffTeams` drive the team tables, the save RAM blocks and their length checks (below).
- `CHECKSUM=0` skips the boot check (`build:dev`). There is a single revision.

## Short jumps

95 has no absolute short `jsr`/`jmp (x).w` calls into ROM. The one short-range reference is `bra.w Begin` at the end of the startup code in `main95.asm`. `Begin` sits before the team data, so growing `TeamList` does not move it. If something before `Begin` grows past its reach, put the new data elsewhere or change that branch to `jmp (Begin).l` on your mod branch.

The engine (`engine95.asm`) is one assembly whose PC-relative branches cross files; data inserted inside it can push a `bra.w`/`bsr.w` out of range. Put new data after the 2 MB fill.

## Past 2 MB: backup RAM and bank switching

The retail image is already 2 MB, so any growth means a 4 MB image whose second half overlaps the backup RAM window ($200001-$20FFFF). With ROM there, the console reads ROM instead of the save chip. A cartridge (or emulator) with the Sega mapper exposes the chip only while bit 0 of $A130F1 is set, so every save access in the save routines needs `move.b #1,($A130F1).l` before it and `clr.b ($A130F1).l` after it. That is a mod-branch change. Past 4 MB you need SSF2-style bank switching ($A130F3-$A130FF). `tools/fixrom.js` warns past 2 MB and refuses images over 4 MB.

## Team checklist


The retail image is 28 teams: ANH 0 through WPG 25, then ASE 26 and ASW 27. `NumTeams` is `ASW+1`. `NumPlayoffTeams` is `ASE` (26). One extra team that leaves `NumPlayoffTeams` at 26 still fits in save RAM. Raising `NumPlayoffTeams` to 27 moves the save checksum and the assemble stops. More than 32 playoff teams stops the assemble. 

Give the new team a number in `src/stubinc/equals.inc`, in `TeamList` order. `NumTeams` and `NumPlayoffTeams` follow from `ASW` and `ASE`. Put the team record in `src/teamdata95.asm`, which is included before the engine, so the engine's PC-relative branches move together.

## Tables the assemble checks

Each of these is one entry per team. The assemble stops when the length is wrong.

- `TeamList` in `src/teamdata95.asm`: one `dc.l` per team.
- `TeamLogoBitmaps` and `TeamGfxList` in `src/engine/middle95.asm`: one long each. ASE and ASW share one ice-logo block. The list still has one long per team.
- `TeamLogoPalettes` in `src/graphics95.asm`: 32 bytes.
- `FeaturedPicIdx` in `src/graphics95.asm`: 6 bytes. `FeaturedPictures` is the picture list, not one entry per team.
- `TeamSongs` in `src/sound/sound95.asm`: 6 bytes.
- `TeamRatings` and `TeamRatingsLine` in `src/front/scout95.asm`: one byte per team, then two unused bytes. The check is `NumTeams+2`. Insert the new byte at the team's index. The unused bytes stay at the end.

These are one entry per playoff team. They do not grow when only `NumTeams` grows.

- `SimGoalsHome`, `SimGoalsAwayDef`, `SimGoalsAway`, `SimGoalsHomeDef` in `src/front/season95.asm`: 10 bytes per playoff team.
- `SimTieTbl`: 3 bytes per playoff team.

`playoffseats` is 32 rows of 16 team numbers. It is not one entry per team.

Do not change speeds, coordinates, sprite heights, or the 26 roster slots. `src/front/create95.asm` `move.w #$1A,d7` and `ReadStatBlock`'s `#$19` are roster slots. Leave them.

## Banner maps

`Teamblocksmap` and `TeamBitmaps` are two rows, 11 tiles wide. `PauseTeamBlocksMap` is two rows, 12 tiles wide. Their sizes are equates in `src/graphics95.asm` (`TeamblocksWide`, `TeamblocksRows` and so on). The assemble checks the width and that the row count is two per team.

Insert the new team's two rows at that team's index. Appending them leaves the new index showing the old art. Copy the rows from the team whose art you are reusing, and raise the map height by two.

## Save RAM

`src/ram95.asm` maps $8000 bytes. Each block stays at its retail address while the block before it still ends on that address. A larger league starts that block at the previous end, in address order.

Crowd records are `NumTeams` blocks of 16 and end on the team-records block. Player stats, standings, team stats, the second and third saved line blocks, and the second team-stat block are `NumPlayoffTeams` long. Rosters, lines, the first saved line block, jerseys, and injuries are `NumTeams` long. Team records, the name log, game results, created players, and the free-agent list stay a fixed size. The free-agent list stays 26 slots.

One extra team that leaves `NumPlayoffTeams` at 26 still fits, and `SRChecksum` stays put. Raising `NumPlayoffTeams` to 27 moves `SRChecksum`, and the assemble stops.

Work RAM that mirrors a save block (`RosterTable`, `CreatedList`, `RosterRatings`) stays at the retail address. `LeaderTeamTbls` offsets follow `NumPlayoffTeams`, but that work RAM does not grow.

## Build

```
export WINEDEBUG=-all
node tools/prebuild.js retail
export NHL_PREBUILD_DONE=1
wine cmd /c "set checksum=1&& build95.bat"
node tools/fixopcodes.js "output/nhl95 .lst" output/nhl95.bin
node tools/fixrom.js output/modified_nhl95.bin
```

`tools/verify_all.sh` does the retail image and every segment, and prints `ALL MATCH` when they all match. A modded ROM will not match and must not be committed to `main`. Wine `cmd` treats `||` as a failed command, so the batch files check `errorlevel` instead.
