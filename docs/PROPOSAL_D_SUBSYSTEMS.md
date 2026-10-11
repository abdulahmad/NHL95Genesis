# Proposal D: name the files for the 95 subsystems, in folders

Goal: give the source the file names Mark Lesser probably used for NHL95. Each file is named for the 95 subsystem it holds, not the 94 file its routines came from. The files go in a few folders with nested include lists, as NHL92 does with `sega\` and `sound\`.

No sections. Every file stays one contiguous ROM range and the include order is the ROM order, as on `main` today. Files are only joined, split at a routine label, renamed and moved into folders. This is a documentation pass: nothing in `src/` changes. A scratch build of the whole layout (under "Tested") is bit-perfect, and every file builds and verifies on its own.

`docs/WHY_95_MOVED.md` explains why 95's order follows subsystems rather than 94's files. This proposal turns that reading into a file list.

Implemented on the branch `cursor/subsystems-75f7` (not merged to `main`); see "Implemented on branch" below.

## What the real names probably were

No 95 file names survive. The ROM has no file name strings, and the 93 and 94 names (`checks94`, `assign94`, `collide94` ...) were chosen by those disassembly projects. Only NHL92's names are real: Jim Simmons's source has `hockey.asm` (the root and the game flow), `main.asm`, `teamdata.asm`, `frames.asm` (`Frames.Asm`), `ram.asm`, `logic.asm`, `middle.asm`, `penalty.asm`, `video.asm`, `checksum.asm`, `sound\sound.asm` and `EALogo.asm`. All are short lowercase words that fit DOS 8.3. Lesser took over that source for 94, so his files most likely kept those names. In 95 he re-filed the code by subsystem (`docs/WHY_95_MOVED.md`), so new subsystems would have new short names in the same style.

The best guess, in ROM order, with how sure each name is:

| Guessed file | Holds | Basis |
| --- | --- | --- |
| `hockey.asm` | root, game flow | 92 name, same role |
| `main.asm`, `teamdata.asm`, `frames.asm`, `ram.asm` | startup and tables | 92 names, same role |
| `schedule.asm` | season schedule | new 95 subsystem |
| `sram.asm` | save RAM | likely (94 added battery save) |
| `display.asm`, `control.asm` | sprite list, pad-to-player assignment | invented for re-filed pieces |
| `sound\sound.asm` | sound driver, bank, calls | 92 name and folder |
| `video.asm` | VDP, DMA, vblank, pads | 92 name, same role |
| `collide.asm` | collisions | likely (92 had them in `hockey.asm`) |
| `middle.asm` | math, text, numbers | 92 name, same role |
| `fourway.asm` | four-player adaptor | likely (94 hardware add-on) |
| `pause.asm` | pause menu | invented |
| `logic.asm` | player AI | 92 name, same role |
| `players.asm` | who is on the ice, attributes | invented |
| `input.asm` | pass and shoot controls | likely (92 had them in `logic.asm`) |
| `setup.asm` | roster and game setup screens | likely |
| `playoff.asm`, `faceoff.asm` | playoff screen, scoreboard and faceoffs | invented |
| `penalty.asm` | penalties, referee, offsides | 92 name, same role |
| `lines.asm`, `skate.asm`, `goal.asm` | line changes, skating, goal and clock | invented |
| `replay.asm` | instant replay | likely (92 had it in `hockey.asm`) |
| `season.asm`, `trade.asm`, `create.asm`, `awards.asm` | 95 front end | new 95 subsystems |
| `stats.asm`, `records.asm`, `scout.asm`, `shootout.asm`, `title.asm` | front end | likely |
| `injury.asm`, `crowd.asm`, `summary.asm` | small front-end pieces | invented |
| `graphics.asm` | graphics data | likely (92 had the incbins at the end of `hockey.asm`) |
| `checksum.asm` | ROM check | 92 name, same role |

"92 name, same role" are close to certain. "Likely" names are the obvious word for a subsystem that already stood alone in 94. "Invented" names stand for pieces Lesser clearly kept together, but the word is a guess. Even the 92 names moved a little: in 92, `middle.asm` had DoDMA and the pad reads and `hockey.asm` had collisions, the goal, the pause menu and the replay. 95 puts those in `video`, `collide`, `goal`, `pause` and `replay`.

## Rules

1. One file per 95 subsystem, named for the subsystem with a short word in the 92 style. Use the 92 name where 92 had the subsystem (`hockey`, `main`, `teamdata`, `frames`, `ram`, `video`, `middle`, `logic`, `penalty`, `sound`, `checksum`).
2. Add `95` to every name, as in the 93 and 94 projects (`logic95.asm`), so files are never mixed up with those repos. No `_01` / `_02` pieces: every name is used once.
3. A file is one contiguous ROM range. A boundary moves only to a routine's global label, so no local label is cut off from its routine.
4. Folders by part of the game: `tables\` (team, frame and schedule data), `sound\`, `engine\` (the code that must be one assembly, `docs/WHY_95_MOVED.md`), `front\` (the menus and screens around the game), `art\` (graphics data). The trunk files stay in `src\`: `nhl95.asm`, `main95`, `sram95`, `hockey95`, `display95`, `control95`, `checksum95`, `ram95`. `sega\`, `macros\` and `stubinc\` are unchanged.
5. Includes nest two deep. `nhl95.asm` includes the trunk files and one include list per folder: `tables95.asm`, `engine95.asm`, `front95.asm` and `art95.asm`, each a list of its folder's files in ROM order. A file lives in the folder of its subsystem but is included where its bytes are. That is why the unused 94 Z80 program, `sound\z80old95.asm`, is in the engine list.
6. Every file has its stub next to it (`engine\logic95_stub.asm`), with the org and the outside addresses, as now. Files and include lists have no org. Include and `incbin` paths stay relative to `src\` (`include engine\logic95.asm`, `incbin ..\Extracted\...`).
7. A joined file keeps each part's old header as a `;----` banner with its address and 94 file, as merged files do now. `docs/FILE_ORIGINS.md` still gives the 94 file of every routine.

## Proposed layout

```
src\
  nhl95.asm            top: equates, org 0, the includes below, the 2 MB fill
  main95.asm           (includes sega\ and macros\, as now)
  tables95.asm         -> tables\teamdata95, frames95, schedule95
  sram95.asm
  hockey95.asm
  display95.asm
  control95.asm
  sound\sound95.asm
  engine95.asm         -> engine\video95 ... engine\replay95, and sound\z80old95 in its place
  front95.asm          -> front\season95 ... front\title95
  art95.asm            -> art\graphics95, logopals95, arena95, credits95
  checksum95.asm
  ram95.asm            equates only (included by nhl95.asm and the stubs)
```

| # | File | Range | Bytes | Made from (files on `main`) | What it holds |
| --- | --- | --- | --- | --- | --- |
| 1 | `main95` | $000000-$000771 | 1906 | main95 | vectors, cartridge header, SegaInit, region lock, Begin |
| 2 | `tables\teamdata95` | $000772-$005A33 | 21186 | teamdata95 | TeamList, the team blocks |
| 3 | `tables\frames95` | $005A34-$008DD7 | 13220 | frames95 | SPA tables, revframetbl |
| 4 | `tables\schedule95` | $008DD8-$009721 | 2378 | schedule95 | the season schedule |
| 5 | `sram95` | $009722-$009AC7 | 934 | sram95 | save RAM, leader lists |
| 6 | `hockey95` | $009AC8-$00A203 | 1852 | hockey95 | game flow: Opening, StartGame, StartPer, DoGameFrame, IntermissionMenu |
| 7 | `display95` | $00A204-$00A95B | 1880 | display95, setup95_01 up to SprSort | setvideo, setsortcords, updateanim, defaultsprites, SprSort |
| 8 | `control95` | $00A95C-$00AF43 | 1512 | setup95_01 from updatepadinput | which pad controls which player (holdplayer, burst, setpads, chgplayer, setcplayer), team setup (InitTeamSructure) |
| 9 | `sound\sound95` | $00AF44-$079901 | 453054 | sound95_01 | 95 sound driver, Z80 program, sound bank, sound calls, the unused 94 driver and samples |
| 10 | `engine\video95` | $079902-$07A7B3 | 3762 | video95_01, collide95_01 up to WaitVSyncAndReadInput | VDP, DMA, sprite frames, scroll, decompressor, vblank, pad reads, ProcessInputWithRepeat |
| 11 | `engine\collide95` | $07A7B4-$07C511 | 7518 | collide95_01 from checkcoll | checks, falls, wall, puck and goal collisions |
| 12 | `engine\middle95` | $07C512-$07DFAB | 6810 | video95_02, fourway95 up to PeriodLabelTable | math, random, text, clock digits, names, numbers, team blocks, team graphics, EASN logo |
| 13 | `engine\fourway95` | $07DFAC-$07E0DF | 308 | fourway95 from AnyPadAssigned | four-player adaptor |
| 14 | `sound\z80old95` | $07E0E0-$07E36B | 652 | sound95_02 | the 94 Z80 program, unused |
| 15 | `engine\pause95` | $07E36C-$07FCFB | 6544 | menu95, checks95_01 up to padteams | Pausemode, the pause menu, its goalie / timeout / scores items |
| 16 | `engine\logic95` | $07FCFC-$0836AB | 14768 | checks95_01 from asstab, onetimer95, checks95_02 | the player AI: asstab, assignments, puck handling, skateto, one-timers, shooting, goalie AI |
| 17 | `engine\players95` | $0836AC-$083EB1 | 2054 | collide95_02 | SetPersonel, setplayer, attributes, the bench, hot / cold table |
| 18 | `engine\input95` | $083EB2-$084FE5 | 4404 | input95_01 | doinput: passes, one-timers, shots |
| 19 | `engine\setup95` | $084FE6-$087BA1 | 11196 | optsetup95 | team roster, game setup and options screens, playoff structures, line data |
| 20 | `engine\playoff95` | $087BA2-$08827B | 1754 | setup95_02, checks95_03 up to SetSframe | PlayoffScreen, PlayoffTreeSetup, DrawPlayoffSprite |
| 21 | `engine\faceoff95` | $08827C-$088F05 | 3210 | checks95_03 from UpdateScores | the scoreboard after a goal (UpdateScores), faceoffs |
| 22 | `engine\penalty95` | $088F06-$08A055 | 4432 | penalty95, data95 | penalties, the referee, PenaltyList, icing and offsides |
| 23 | `engine\lines95` | $08A056-$08B4DF | 5258 | input95_02, checks95_04 up to DrawTeamScreen6 | line changes, computer lines, saved lines, team line screens |
| 24 | `engine\skate95` | $08B4E0-$08C303 | 3620 | checks95_04 goalieacc ... PlaceBoardFall | goalie and skater movement: goalieacc, goalie dive, MaxSpeed, updatevel, playeracc |
| 25 | `engine\goal95` | $08C304-$08D399 | 4246 | checks95_04 from Goal | the goal, period over, game over, the clock, the controller setup screen |
| 26 | `engine\replay95` | $08D39A-$08DF59 | 3008 | replay95 | instant replay (after two 95 check-start helpers) |
| 27 | `front\season95` | $08DF5A-$0920DD | 16772 | season95 | season mode |
| 28 | `front\stats95` | $0920DE-$0962ED | 16912 | period95, stats95_01 | game, player and season stats, League Leaders, line editor, highlights |
| 29 | `front\trade95` | $0962EE-$097C53 | 6502 | trade95 | rosters and trades |
| 30 | `front\create95` | $097C54-$09ACE5 | 12434 | create95 | Create Player, free agents |
| 31 | `front\records95` | $09ACE6-$09C6EF | 6666 | cards95_01, records95, cards95_02 | name entry, user names, record holders, record updates |
| 32 | `front\awards95` | $09C6F0-$09DA4F | 4960 | awards95 | season awards, playoff tree screen |
| 33 | `front\shootout95` | $09DA50-$09F011 | 5570 | shootout95, checks95_05 up to ShortenMsgTimer | shootout and penalty shot |
| 34 | `front\injury95` | $09F012-$09F58F | 1406 | checks95_05 from setInjuryType | injuries, then the power play box (the last 306 bytes) |
| 35 | `front\scout95` | $09F590-$0A0B3D | 5550 | scout95, setup95_03 | matchups, scouting report and its text, hot / cold lists |
| 36 | `front\crowd95` | $0A0B3E-$0A0D19 | 476 | stats95_02 up to rtsShowCrowd | the crowd meter |
| 37 | `front\summary95` | $0A0D1A-$0A12A9 | 1424 | stats95_02 from ScoringSummaryScreen | scoring and penalty summaries |
| 38 | `front\title95` | $0A12AA-$0A1A59 | 1968 | title95_01 | title screen, high scores, Stanley Cup |
| 39 | `art\graphics95` | $0A1A5A-$1A1699 | 1047616 | graphics95_01 | pictures, rink, sprites, fonts, screen maps |
| 40 | `art\logopals95` | $1A169A-$1A1A19 | 896 | title95_02 | team logo palettes |
| 41 | `art\arena95` | $1A1A1A-$1A6C27 | 21006 | graphics95_02 | ArenaGfxBank |
| 42 | `art\credits95` | $1A6C28-$1A72BF | 1688 | credits95 | the credits text |
| 43 | `checksum95` | $1A72C0-$1A730F | 80 | checksum95 | ValidationRoutine |

Items 10-26 (with item 14 in its place) are the engine block that PC-relative branches tie into one assembly. Items 27-38 are the front-end modules, which mostly stand alone.

### The nine new boundaries

Each one is at a routine's global label, so it changes no byte:

| Label | Address | Splits | Why |
| --- | --- | --- | --- |
| `updatepadinput` | $00A95C | setup95_01 | sprite setup above, pad-to-player assignment below |
| `checkcoll` | $07A7B4 | collide95_01 | the two pad / vsync helpers at its head belong with the pad reads in video |
| `AnyPadAssigned` | $07DFAC | fourway95 | team graphics, EASN logo and clock text above go with the helpers; the adaptor code below |
| `asstab` | $07FCFC | checks95_01 | the pause menu items above, the AI from the assignment table on |
| `UpdateScores` | $08827C | checks95_03 | playoff tree and its sprite (`SetSframe`'s only caller is DrawPlayoffSprite) above, scoreboard and faceoffs below |
| `goalieacc` | $08B4E0 | checks95_04 | line changes above, movement below (the split already on the proposal 2 branch) |
| `Goal` | $08C304 | checks95_04 | movement above; goal, period, clock and controller setup below |
| `setInjuryType` | $09F012 | checks95_05 | penalty shot above, injuries below |
| `ScoringSummaryScreen` | $0A0D1A | stats95_02 | crowd meter above, summaries below |

### Choices that could go either way

- `onetimer95` joins `logic95` because its routines are AI assignments (`assonetimer`). It could stay its own file at $082BD0-$082FC1.
- `injury95` ends with 306 bytes of power play box code (updatepwrplay ... GetLowestPen). The alternative is to keep it in `shootout95`, as proposal 1 does.
- The two 95 check-start helpers (chkcheckstart, CanCheckStart) at the head of `replay95` belong to neither neighbour, so the boundary stays where it is.
- `crowd95` is small (476 bytes). It could join `summary95` as one file.
- `sound\sound95` stays one file, as asked for when the driver and the sound data were merged. Splitting it into driver, bank, calls and the unused 94 driver would fit the folder but undo that merge.

### Not done the 92 way

In 92, `hockey.asm` is both the root and the game flow: its code includes `logic`, `middle` and `penalty` partway through. Here `hockey95.asm` stays a normal file and `nhl95.asm` is the root. A file that includes other files can't be built alone: its stub would pull in everything after it. Guarding the includes with `if ~def(SEGMENT)` would make it work, but adds a rule for a small gain.

## Tested (scratch copy, not committed)

The layout was built in a scratch copy of `main` (c069d4d) by cutting today's files at the labels above and writing them to the new paths, without changing any line. Then the four include lists and `nhl95.asm` were written, and a stub was generated next to every file from the full build listing. `main95` kept its current stub.

- Full build: MATCH, 2097152 bytes, SHA-1 `09e87b076aa4cd6f057a1d65bb50fd889b509b44`, 0 errors.
- Every file built from its stub and verified against `lst/nhl95.bin`: 43 / 43 MATCH, no warnings.
- Includes from `src\` reach files two folders deep (`engine95.asm` -> `engine\logic95.asm`). `incbin ..\Extracted\...` inside `art\` files still resolves, because SNASM resolves paths from the working directory (`src\`), not from the including file. A stub inside a folder (`engine\logic95_stub.asm`) builds with `src\` as the working directory.

No new address is hardcoded. Files and include lists have no org, and the stubs carry an org and outside addresses as they do now.

## Doing it

1. Cut, join and move the files as in the table (a script, as for the earlier merges). Turn the old file headers inside joined files into banners and write a header for each new file.
2. Write `tables95.asm`, `engine95.asm`, `front95.asm`, `art95.asm` and the new `nhl95.asm` include list with the start address on each line.
3. Write the stubs next to their files. `package.json` `seg:` scripts and `buildseg.bat` take the stub path (`engine\logic95`) and name the outputs by the file name alone.
4. Update the tools for folders: `tools/file_origins.py`, `tools/strip_noise.py` (the `module` column of `docs/name_map.csv` becomes the path), `tools/segmap95.json` / `SEGMAP95.md`. Then regenerate `docs/FILE_ORIGINS.md` and `docs/function_origins.csv`.
5. Fix comments that name a file (`(collide95_01)`, `called from checks95_04`) to the new names.
6. Update README, SEGMENT_AGENT.md (the ROM map table and the file rules) and PROMPT.md.
7. Full build and all 43 segments after each step.

## Implemented on branch `cursor/subsystems-75f7`

The layout above is implemented on the branch `cursor/subsystems-75f7`, not on `main`. Full build MATCH (SHA-1 `09e87b076aa4cd6f057a1d65bb50fd889b509b44`) and 43 / 43 segments MATCH after every commit. No code or data byte changed.

- The 43 files, the four include lists and the stubs are as in the table. The old flat files are deleted.
- Joined files keep each old header as a banner; split files got a header for each part, and the headers and banners name only what is in their own part. The `N parts` line of a header counts its banners.
- Comments that named an old file name the new one (`(collide95_02)` -> `(players95)`); where a split file was named, the caller or callee decided which new file it is. `extractAssets95.js` names the new paths.
- Merged files include `macros\genesis.mac` once.
- `tools/file_origins.py` expands the include lists; `tools/strip_noise.py` and `tools/scan_cleanup.py` read the five folders. `docs/FILE_ORIGINS.md` and `docs/function_origins.csv` were regenerated: every label keeps its origin and evidence, only the file names changed. The `module` column of `docs/name_map.csv` is the path (`engine/logic95`), set by address from the stubs; `old_name` is kept.
- `tools/segmap95.json`, `SEGMAP95.md` and `segmap95_overrides.json` are not changed: they are the first fingerprint split, kept for history, and their segment names are the old flat names.
- README, `SEGMENT_AGENT.md` (layout rules, build, and a 43-row ROM map plus `ram95`) and a note in `PROMPT.md` describe the new layout.

## For and against

For:
- The names say what each file holds in 95, and every name is used once: no `_01` / `_02`, no 94 name over code that 94 kept somewhere else.
- The folders show the structure of the game: tables, sound, the engine assembly, the front end, art.
- It probably matches how Lesser's source was organized, and 11 of the names are NHL92's (counting `ram95`).
- No sections: ROM order equals include order, as now, and every file builds alone.

Against:
- It drops the link to the 93 and 94 repos' file names. Finding where a 94 routine went takes `docs/FILE_ORIGINS.md` or a search, not the file name.
- Twelve of the names (`display`, `control`, `pause`, `players`, `playoff`, `faceoff`, `lines`, `skate`, `goal`, `injury`, `crowd`, `summary`) are guesses with no source behind them.
- Files sit in four folders, and the 94 tools and agent docs assume a flat `src\`.
- Some files are still mixtures where 95 put an odd routine between two subsystems (EASportsScreen in `lines95`, the check-start helpers in `replay95`).

## Compared with proposals 1, 2 and 3

| | Files | Names from | Pieces | Folders | Sections |
| --- | --- | --- | --- | --- | --- |
| main today | 48 | 94 files | 10 names numbered | no | no |
| 1: grouping | 35 | 94 files | 5 names numbered | no | no |
| 2: `name95_subject` | 48 (49 with the split) | 94 file + subject | none | no | no |
| 3: NHL92 scheme | 30 | 92 / 93 / 94 files | none | no | yes |
| D: subsystems | 43 | the 95 subsystem, 92 names where they fit | none | yes | no |

D joins neighbours as proposal 1 does, but splits more often and names by subsystem rather than by 94 file. It reads like proposal 3 (one name per job, 92 names first) without needing sections, because it follows 95's own order instead of pulling routines back to 92's files.
