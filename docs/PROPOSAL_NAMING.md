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
