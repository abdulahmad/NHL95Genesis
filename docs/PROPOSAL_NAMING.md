# Proposal 2: name the pieces `name95_subject.asm`

Goal: keep today's files and their ranges, but replace the numbers with a word that says what the piece is. `checks95_03.asm` becomes `checks95_faceoff.asm`.

No file is joined or split (one optional split below), so this is only renames: 48 files stay 48.

## Rules

1. A file that is one of several pieces of a 94 file is named `<94 name>95_<subject>.asm`. The 94 name stays first, so the pieces of one 94 file sort together and still map to their 94 file at a glance.
2. The subject is one lower case word (two run together at most) for the main job of the piece: what most of its bytes do, not every routine in it.
3. A file that is the only piece of its 94 file keeps its plain name (`hockey95`, `menu95`, `penalty95`, ...), as in 94. So do the 95-only files (`season95`, `trade95`, ...).
4. The stub follows the file: `checks95_faceoff_stub.asm`, `npm run seg:checks95_faceoff`. The build scripts take any name; long names already work (`collide95_01_stub.asm` is not 8.3).
5. Each file header keeps saying which 94 file each part came from, and `docs/FILE_ORIGINS.md` lists every routine.

## Renames

| Now | Proposed | Range | Bytes | What it holds |
| --- | --- | --- | --- | --- |
| `setup95_01` | `setup95_sprites` | $00A656-$00AF43 | 2286 | defaultsprites, SprSort, pad assignment (holdplayer, burst, chgplayer, setc1player-setc4player), team setup |
| `sound95_01` | `sound95_driver` | $00AF44-$079901 | 453054 | the 95 sound driver, its Z80 program and sound bank, the sound calls, the unused 94 driver and samples |
| `video95_01` | `video95_vdp` | $079902-$07A761 | 3680 | VDP / DMA, palettes, sprite frames, rink scroll, decompressor, vblank, pad reads |
| `collide95_01` | `collide95_contact` | $07A762-$07C511 | 7600 | player, wall, puck and goal collisions, checks and fights |
| `video95_02` | `video95_text` | $07C512-$07DE9F | 6542 | math, text printing, player and team name formatting, numbers and times, team blocks |
| `sound95_02` | `sound95_z80` | $07E0E0-$07E36B | 652 | the 94 Z80 program (unused in 95) |
| `checks95_01` | `checks95_assign` | $07F97E-$082BCF | 12882 | pause menu items, goalie, the player assignments (asstab), puck handling, skateto |
| `checks95_02` | `checks95_goalie` | $082FC2-$0836AB | 1770 | assshoot, assgoaliectrl, assdefdchase, assscore, ChkGoalies, CPgoalie |
| `collide95_02` | `collide95_lineup` | $0836AC-$083EB1 | 2054 | SetPersonel, setplayer, attributes, bench, hot / cold table |
| `input95_01` | `input95_shoot` | $083EB2-$084FE5 | 4404 | doinput: passes, one-timer passes, shots |
| `setup95_02` | `setup95_playoffs` | $087BA2-$088045 | 1188 | PlayoffScreen and the bracket |
| `checks95_03` | `checks95_faceoff` | $088046-$088F05 | 3776 | playoff tree setup, the scoreboard, faceoffs |
| `input95_02` | `input95_lines` | $08A056-$08A3FD | 936 | the line change input |
| `checks95_04` | `checks95_lines` + `checks95_skate` (see below) | $08A3FE-$08D399 | 12188 | computer line changes, saved lines, team screens; goalie and skater movement, the goal, the controller setup screen |
| `stats95_01` | `stats95_players` | $0925AE-$0962ED | 15680 | player stats, the 95 season stats, League Leaders, period stats, line editor, highlights |
| `cards95_01` | `cards95_names` | $09ACE6-$09B6F3 | 2574 | NameEntryScreen and the letter grid |
| `cards95_02` | `cards95_records` | $09C01A-$09C6EF | 1750 | UpdateRecords, the team / crowd / player record I/O, SetupScreen |
| `checks95_05` | `checks95_penshot` | $09E5F0-$09F58F | 4000 | shootout and penalty shot play, injuries, the power play box |
| `setup95_03` | `setup95_scout` | $0A00D6-$0A0B3D | 2664 | scouting text, hot / cold lists, users lists, GetPlayerPicture |
| `stats95_02` | `stats95_summary` | $0A0B3E-$0A12A9 | 1900 | crowd meter, scoring and penalty summaries |
| `title95_01` | `title95_screen` | $0A12AA-$0A1A59 | 1968 | title screen, credits, high scores, Stanley Cup |
| `graphics95_01` | `graphics95_main` | $0A1A5A-$1A1699 | 1047616 | player pictures, rink, sprites, fonts, screen maps, logos |
| `title95_02` | `title95_palettes` | $1A169A-$1A1A19 | 896 | team logo palettes |
| `graphics95_02` | `graphics95_arena` | $1A1A1A-$1A6C27 | 21006 | ArenaGfxBank, the home team graphics |

That is 24 renames. The other 24 files keep their names: `main95`, `teamdata95`, `frames95`, `schedule95`, `sram95`, `hockey95`, `display95`, `fourway95`, `menu95`, `onetimer95`, `optsetup95`, `penalty95`, `data95`, `replay95`, `season95`, `period95`, `trade95`, `create95`, `records95`, `awards95`, `shootout95`, `scout95`, `credits95`, `checksum95`.

### The one optional split

`checks95_04` has no single subject: it is line changes and the 95 team line screens ($8A3FE-$8B4DF), then goalie and skater movement, the goal and the controller setup screen ($8B4E0-$8D399). Splitting it at `goalieacc` ($8B4E0) gives two pieces that each have a name:

| Proposed | Range | Bytes | What it holds |
| --- | --- | --- | --- |
| `checks95_lines` | $08A3FE-$08B4DF | 4322 | CompLine, AutoLineChange, the 95 saved lines, DrawTeamScreen2-6; also the moved in EASportsScreen, chkatop, updatePPTeamTime, ChkShotStat |
| `checks95_skate` | $08B4E0-$08D399 | 7866 | goalieacc, doinput_cbut, dostop, playeracc, SetSPA, Goal, clock, period / game over, the controller setup screen |

With the split there are 49 files. Without it, the closest single name is `checks95_play`.

## Sorted listing

With these names, a directory listing groups the pieces of each 94 file and says what each is:

```
checks95_assign.asm    checks95_faceoff.asm   checks95_goalie.asm
checks95_lines.asm     checks95_penshot.asm   checks95_skate.asm
collide95_contact.asm  collide95_lineup.asm
input95_lines.asm      input95_shoot.asm
setup95_playoffs.asm   setup95_scout.asm      setup95_sprites.asm
sound95_driver.asm     sound95_z80.asm
stats95_players.asm    stats95_summary.asm
video95_text.asm       video95_vdp.asm
```

The ROM order is no longer in the names. It stays in `src/nhl95.asm` (one include per file, with its address) and in the SEGMENT_AGENT.md ROM map.

## What each file came from

How much of each file is new in 95 and how much was adapted from 94, from `docs/function_origins.csv` (written by `tools/file_origins.py`). Files are in ROM order, under their proposed names.

- **Functions** counts every labelled routine and table, code and data. Labels with no bytes of their own are left out.
- **New in 95** and **Adapted from 94** are shares of that count. Adapted means 94 has the same routine, found by name, by header or by fingerprint (the rules are in `docs/FILE_ORIGINS.md`). It does not say how much the routine changed; a copy with one changed line counts the same as an exact copy.
- **New, by bytes** and **Top 94 files, by bytes** are shares of the file's length. Up to two 94 files are shown, largest first, so a row adds up to 100% only when no third 94 file contributes.
- `main95` includes its `sega/` include files (SegaIDTable95, SegaInit).
- **Resolved** is yes when every function in the file is new in 95, or every function was adapted from 94 (from one 94 file or several). A file with any mix is not resolved. The test uses the counts, not the rounded percentages, so 98% new is not resolved.

| File | Now | Functions | New in 95 | Adapted from 94 | New, by bytes | Top 94 files, by bytes | Resolved |
| --- | --- | --- | --- | --- | --- | --- | --- |
| `main95` |  | 43 | 26% | 74% | 66% | sega/SegaInit 18%, hockey94 14% | no |
| `teamdata95` |  | 28 | 0% | 100% | 0% | teamdata94 100% | yes |
| `frames95` |  | 80 | 0% | 100% | 0% | frames94 84%, graphics94 16% | yes |
| `schedule95` |  | 2 | 100% | 0% | 100% | - | yes |
| `sram95` |  | 11 | 27% | 73% | 37% | sram94 63% | no |
| `hockey95` |  | 8 | 12% | 88% | 30% | hockey94 44%, setup94 25% | no |
| `display95` |  | 10 | 0% | 100% | 0% | display94 74%, replay94 26% | yes |
| `setup95_sprites` | `setup95_01` | 19 | 26% | 74% | 11% | setup94 45%, title94 23% | no |
| `sound95_driver` | `sound95_01` | 76 | 43% | 57% | 84% | sound94 16%, title94 <1% | no |
| `video95_vdp` | `video95_01` | 76 | 5% | 95% | 7% | video94 55%, display94 26% | no |
| `collide95_contact` | `collide95_01` | 32 | 6% | 94% | <1% | collide94 95%, crowd94 3% | no |
| `video95_text` | `video95_02` | 123 | 28% | 72% | 26% | video94 25%, setup94 9% | no |
| `fourway95` |  | 15 | 27% | 73% | 16% | fourway94 38%, title94 25% | no |
| `sound95_z80` | `sound95_02` | 1 | 0% | 100% | 0% | sound94 100% | yes |
| `menu95` |  | 46 | 70% | 30% | 74% | menu94 18%, hockey94 8% | no |
| `checks95_assign` | `checks95_01` | 62 | 10% | 90% | 5% | checks94 69%, assign94 19% | no |
| `onetimer95` |  | 6 | 0% | 100% | 0% | onetimer94 92%, title94 8% | yes |
| `checks95_goalie` | `checks95_02` | 11 | 9% | 91% | 27% | checks94 41%, assign94 28% | no |
| `collide95_lineup` | `collide95_02` | 19 | 21% | 79% | 9% | collide94 72%, crowd94 7% | no |
| `input95_shoot` | `input95_01` | 24 | 0% | 100% | 0% | input94 85%, onetimer94 13% | yes |
| `optsetup95` |  | 96 | 16% | 84% | 10% | optsetup94 47%, data94 25% | no |
| `setup95_playoffs` | `setup95_02` | 10 | 0% | 100% | 0% | setup94 100% | yes |
| `checks95_faceoff` | `checks95_03` | 20 | 5% | 95% | 5% | checks94 59%, data94 10% | no |
| `penalty95` |  | 23 | 0% | 100% | 0% | penalty94 93%, title94 6% | yes |
| `data95` |  | 11 | 0% | 100% | 0% | data94 51%, checks94 28% | yes |
| `input95_lines` | `input95_02` | 12 | 0% | 100% | 0% | input94 78%, penalty94 22% | yes |
| `checks95_lines` + `checks95_skate` | `checks95_04` | 84 | 52% | 48% | 47% | checks94 27%, input94 6% | no |
| &nbsp;&nbsp;`checks95_lines` | split | 22 | 68% | 32% | 78% | checks94 9%, penalty94 8% | no |
| &nbsp;&nbsp;`checks95_skate` | split | 62 | 47% | 53% | 30% | checks94 37%, input94 9% | no |
| `replay95` |  | 18 | 11% | 89% | 15% | replay94 85% | no |
| `season95` |  | 181 | 98% | 2% | >99% | hockey94 <1% | no |
| `period95` |  | 11 | 0% | 100% | 0% | period94 100% | yes |
| `stats95_players` | `stats95_01` | 150 | 57% | 43% | 51% | stats94 31%, period94 12% | no |
| `trade95` |  | 45 | 100% | 0% | 100% | - | yes |
| `create95` |  | 181 | 98% | 2% | 98% | cards94 2% | no |
| `cards95_names` | `cards95_01` | 23 | 0% | 100% | 0% | cards94 100% | yes |
| `records95` |  | 26 | 19% | 81% | 9% | records94 85%, title94 3% | no |
| `cards95_records` | `cards95_02` | 18 | 11% | 89% | 14% | cards94 68%, stats94 18% | no |
| `awards95` |  | 67 | 99% | 1% | >99% | cards94 <1% | no |
| `shootout95` |  | 37 | 0% | 100% | 0% | shootout94 62%, title94 21% | yes |
| `checks95_penshot` | `checks95_05` | 28 | 32% | 68% | 12% | checks94 47%, penalty94 14% | no |
| `scout95` |  | 29 | 0% | 100% | 0% | scout94 92%, crowd94 8% | yes |
| `setup95_scout` | `setup95_03` | 27 | 22% | 78% | 5% | setup94 28%, graphics94 26% | no |
| `stats95_summary` | `stats95_02` | 24 | 4% | 96% | 5% | stats94 75%, display94 15% | no |
| `title95_screen` | `title95_01` | 15 | 53% | 47% | 34% | title94 66% | no |
| `graphics95_main` | `graphics95_01` | 282 | 0% | 100% | 0% | graphics94 >99%, cards94 <1% | yes |
| `title95_palettes` | `title95_02` | 1 | 0% | 100% | 0% | title94 100% | yes |
| `graphics95_arena` | `graphics95_02` | 1 | 0% | 100% | 0% | graphics94 100% | yes |
| `credits95` |  | 2 | 0% | 100% | 0% | teamdata94 100% | yes |
| `checksum95` |  | 1 | 0% | 100% | 0% | checksum94 100% | yes |

Across the ROM, 788 of 2115 functions (37%) are new in 95, and 614 of the 1397 code routines (44%). By bytes, new code and data is 26% of the ROM, held down by the graphics, which are almost all from 94.

21 of the 48 files are resolved: 2 are all new (`schedule95`, `trade95`) and 19 are all from 94. The other 27 mix new and 94 routines; with the optional split, `checks95_lines` and `checks95_skate` are both still mixed.

A few rows say more than the file name does:
- `credits95` is all teamdata94, because 94 keeps `Credits` and `CreditsList` in `teamdata94.asm`.
- `sound95_driver` is 43% new by count but 84% by bytes: the new 95 driver and sound bank are large, and the kept 94 routines are small.
- Of the two halves of the optional `checks95_04` split, `checks95_lines` is mostly new (the 95 saved lines and team line screens); `checks95_skate` is mostly 94 movement code.

## Doing it

1. `git mv` each module and stub (through temporary names, since some old and new names overlap).
2. Replace the old names everywhere in one pass: stubs (the `;module` comment on each equate), comments, `src/nhl95.asm`, `package.json`, `docs/name_map.csv`, SEGMENT_AGENT.md, README, PROMPT.md. Then rerun `tools/file_origins.py`.
3. For the optional split: cut `checks95_04` at `goalieacc`, give each half a header and a stub (equates from the build listing).
4. Build the full ROM and every segment.

No byte changes. Labels do not change.

## For and against

For:
- The file name says what is in it; no need to remember that `checks95_03` is faceoffs.
- Nothing is regrouped, so the risk is a rename only.
- The pieces of one 94 file still sort together and keep the 94 name.

Against:
- Still 48 (or 49) files, against 33 in 94.
- The ROM order is not visible from the names.
- A subject is a summary. Mixed files (`checks95_assign`, `stats95_players`, `video95_text`) hold more than their subject says.
- 93 and 94 use numbers for pieces (`hockey93_01` ... `hockey93_11`), so this departs from them.

## Combined with proposal 1

Proposal 1 (grouping) cuts the files to 35 and leaves 5 names with pieces. Naming only those pieces with this scheme gives `sound95_driver` / `sound95_z80`, `video95_vdp` / `video95_text`, `collide95_contact` / `collide95_lineup`, `checks95_assign` / `checks95_faceoff` / `checks95_skate`, and `stats95_players` / `stats95_summary`.
