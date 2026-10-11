# Proposal 1: group the files by subsystem

Goal: fewer, larger files, each one a single job, close to the 33 files of NHL94Genesis. Today there are 48.

The bytes cannot move, so a file is always one contiguous ROM range. Grouping can only join neighbours, or move a boundary to a different label. This proposal does both: 16 joins and 2 moved boundaries, which gives 35 files.

## Rules

1. Join neighbouring files that do the same job (the pause screen, the AI, the line changes, the records screens, the scouting report).
2. Move a boundary when the current one cuts a job in half. Two moves: the playoff tree goes with the playoff screen, and the line change code is split from the skating code.
3. Name a file after the 94 file most of it came from. Use a new name only when no 94 file fits; the only one is `lines95`, because 94 spreads that code over input94, checks94 and penalty94.
4. Number the pieces of one name `_01`, `_02`, ... in ROM order, as now and as in 93. With the joins, 5 names still have pieces: sound, video, collide, checks and stats.
5. Inside a joined file, each part keeps a `;----` banner with its address and 94 file, as the merged files already do. `docs/FILE_ORIGINS.md` still gives the 94 file of every routine.

## Proposed layout

| # | File | Range | Bytes | Made from | What it holds |
| --- | --- | --- | --- | --- | --- |
| 1 | `main95` | $000000-$000771 | 1906 | main95 | vectors, cartridge header, SegaInit, the 95 region lock, Begin |
| 2 | `teamdata95` | $000772-$005A33 | 21186 | teamdata95 | TeamList, the team blocks |
| 3 | `frames95` | $005A34-$008DD7 | 13220 | frames95 | SPA tables, revframetbl |
| 4 | `schedule95` | $008DD8-$009721 | 2378 | schedule95 | the season schedule (95 only) |
| 5 | `sram95` | $009722-$009AC7 | 934 | sram95 | save RAM, leader list builders |
| 6 | `hockey95` | $009AC8-$00AF43 | 5244 | hockey95, display95, setup95_01 | game flow and the game frame: Opening, StartGame, Gameloop, setvideo, updateanim, sprite setup, pad assignment, team setup |
| 7 | `sound95_01` | $00AF44-$079901 | 453054 | sound95_01 | the 95 sound driver and bank, sound calls, the unused 94 driver and samples |
| 8 | `video95_01` | $079902-$07A761 | 3680 | video95_01 | VDP / DMA, sprite frames, rink scroll, decompressor, vblank, pad reads |
| 9 | `collide95_01` | $07A762-$07C511 | 7600 | collide95_01 | player, wall, puck and goal collisions |
| 10 | `video95_02` | $07C512-$07E0DF | 7118 | video95_02, fourway95 | math, text, name and number formatting, home team graphics, EASN logo, four-player adaptor |
| 11 | `sound95_02` | $07E0E0-$07E36B | 652 | sound95_02 | the 94 Z80 program (unused) |
| 12 | `menu95` | $07E36C-$07F97D | 5650 | menu95 | Pausemode and the 95 pause menu |
| 13 | `checks95_01` | $07F97E-$0836AB | 15662 | checks95_01, onetimer95, checks95_02 | the player AI: pause menu items, goalie, assignments, puck handling, skateto, one-timers, goalie control |
| 14 | `collide95_02` | $0836AC-$083EB1 | 2054 | collide95_02 | SetPersonel, setplayer, attributes, bench, hot / cold table |
| 15 | `input95` | $083EB2-$084FE5 | 4404 | input95_01 | doinput: passes, one-timers, shots |
| 16 | `optsetup95` | $084FE6-$087BA1 | 11196 | optsetup95 | team roster, the game setup screen, playoff structures, line data |
| 17 | `setup95` | $087BA2-$088219 | 1656 | setup95_02, head of checks95_03 | PlayoffScreen, PlayoffTreeSetup, DrawPlayoffSprite |
| 18 | `checks95_02` | $08821A-$088F05 | 3308 | rest of checks95_03 | SetSframe, the scoreboard (UpdateScores, SetScore), faceoffs |
| 19 | `penalty95` | $088F06-$08A055 | 4432 | penalty95, data95 | penalties, the referee, PenaltyList, icing and offsides checks |
| 20 | `lines95` | $08A056-$08B4DF | 5258 | input95_02, head of checks95_04 | line changes: the line change input, computer line changes, the 95 saved lines, the team line screens; also the moved in EASportsScreen, chkatop, updatePPTeamTime, ChkShotStat |
| 21 | `checks95_03` | $08B4E0-$08D399 | 7866 | rest of checks95_04 | goalie and skater movement (goalieacc, doinput_cbut, dostop, playeracc), SetSPA, the goal, clock, period / game over, the controller setup screen |
| 22 | `replay95` | $08D39A-$08DF59 | 3008 | replay95 | instant replay |
| 23 | `season95` | $08DF5A-$0920DD | 16772 | season95 | season mode (95 only) |
| 24 | `stats95_01` | $0920DE-$0962ED | 16912 | period95, stats95_01 | game statistics, player stats, season stats, League Leaders, period stats, line editor, highlights |
| 25 | `trade95` | $0962EE-$097C53 | 6502 | trade95 | rosters and trades (95 only) |
| 26 | `create95` | $097C54-$09ACE5 | 12434 | create95 | Create Player, free agents (95 only) |
| 27 | `cards95` | $09ACE6-$09C6EF | 6666 | cards95_01, records95, cards95_02 | name entry, user name entry, record holders, record updates |
| 28 | `awards95` | $09C6F0-$09DA4F | 4960 | awards95 | season awards, playoff tree screen (95 only) |
| 29 | `shootout95` | $09DA50-$09F58F | 6976 | shootout95, checks95_05 | shootout, penalty shot, then injuries and the power play box |
| 30 | `scout95` | $09F590-$0A0B3D | 5550 | scout95, setup95_03 | matchups, scouting report and its text, hot / cold lists |
| 31 | `stats95_02` | $0A0B3E-$0A12A9 | 1900 | stats95_02 | crowd meter, scoring and penalty summaries |
| 32 | `title95` | $0A12AA-$0A1A59 | 1968 | title95_01 | title screen, credits, high scores, Stanley Cup |
| 33 | `graphics95` | $0A1A5A-$1A6C27 | 1069518 | graphics95_01, title95_02, graphics95_02 | all graphics incbins: pictures, rink, sprites, fonts, maps, logos, logo palettes, arena graphics |
| 34 | `credits95` | $1A6C28-$1A72BF | 1688 | credits95 | the credits text |
| 35 | `checksum95` | $1A72C0-$1A730F | 80 | checksum95 | ValidationRoutine |

### The two moved boundaries

- **$8821A (SetSframe):** today `checks95_03` opens with the playoff tree (PlayoffTreeSetup tables, DrawPlayoffSprite) before the scoreboard and faceoff code. Those 468 bytes go to the end of the playoff screen file (`setup95`), so the faceoff file starts at SetSframe.
- **$8B4E0 (goalieacc):** today `checks95_04` is line changes and team screens, then goalie and skater movement. The first part joins the line change input (`input95_02`) as `lines95`; the second part is `checks95_03`.

### Joins that put two 94 names in one file

- `cards95` holds records94 (UserNameEntry ... ClearWinRecords) between two cards94 runs.
- `graphics95` holds the title94 logo palettes, because they sit between the two graphics94 runs.
- `shootout95` holds checks94 puckshootout / penalty shot and the 95 injuries.
- `stats95_01` holds period94 GameStatisticsScreen at its head.

## What changes

| Before | After |
| --- | --- |
| 48 files | 35 files (94: 33) |
| 10 names with numbered pieces | 5 (sound, video, collide, checks, stats) |
| Smallest code file 576 bytes (fourway95) | Smallest code file 934 bytes (sram95), apart from checksum95 |
| Largest code file 16772 bytes (season95) | Largest code file 16912 bytes (stats95_01) |

Files that disappear as names: `display95`, `setup95_01`, `fourway95`, `onetimer95`, `input95_02`, `data95`, `period95`, `records95`, `setup95_03`, `title95_02`, `graphics95_02`.

## Doing it

The same steps as the last merge:

1. Join or split the module files; give each joined file one header and a banner per part.
2. Write the stubs: org = first part, equates = the union of the parts' outside addresses, minus any label now inside the file. A moved boundary gets its equates from the build listing.
3. Update `src/nhl95.asm`, `package.json` (seg scripts), `docs/name_map.csv` (file column), the SEGMENT_AGENT.md ROM map, README and the comments that name a file, then rerun `tools/file_origins.py`.
4. Build the full ROM and every segment; every segment must cover its whole range.

No byte changes. Labels do not change.

## For and against

For:
- The file count is close to 94's, and each file is one job you can name in a few words.
- The tiny code files go away (fourway95 576 bytes, input95_02 936, display95 1106). The only small file left besides checksum95 is sound95_02, a block of data between two code files.
- Line changes are in one place instead of three.

Against:
- More files hold several 94 files. The file name tells you less about where a routine came from (the banners and FILE_ORIGINS.md still do).
- Two more files pass 15 KB (checks95_01, stats95_01), next to season95.
- `lines95` is a name 94 does not have.

## Combined with proposal 2

The two proposals work together: group first, then give the 5 remaining numbered names a subname (proposal 2's style). With this layout that is `sound95_driver` / `sound95_z80`, `video95_vdp` / `video95_text`, `collide95_contact` / `collide95_lineup`, `checks95_assign` / `checks95_faceoff` / `checks95_skate`, and `stats95_players` / `stats95_summary`.
