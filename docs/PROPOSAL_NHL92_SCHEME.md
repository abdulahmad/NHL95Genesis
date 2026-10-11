# Proposal 3 (C): group the routines by the NHL92 file names

Goal: put every routine in the file that NHL92 (or, for later code, NHL93 / NHL94) would have put it in, wherever it sits in the 95 ROM. All the logic code goes in `logic95.asm`, all the text and math helpers in `middle95.asm`, and so on. Files that are new in 95 stay as they are.

This is a documentation pass: nothing in `src/` changes. A scratch build of the layout (described under "Tested") shows it can be built bit-perfect.

The placement of every routine is in `docs/proposal_nhl92_map.csv` (address, size, label, file now, 94 file, proposed file, basis).

## The NHL92 scheme

[NHL92Genesis](https://github.com/abdulahmad/NHL92Genesis) has 9 game code files, plus `ram.asm` (equates), `EALogo.asm`, `sega/` and `sound/`:

- `hockey.asm`: the root. It includes `main`, `teamdata`, `frames` and `ram`, holds Begin and the game flow, and includes `logic`, `middle` and `penalty` partway through, then `video` and `checksum` further on.
- `logic.asm`: the player AI and the controls.
- `middle.asm`: math, text and number helpers.
- `penalty.asm`: penalties, the referee, the scoreboard.
- `video.asm`: vblank, sprites, DMA, scroll, the clock display.
- `frames.asm`, `teamdata.asm`, `main.asm`, `checksum.asm`, `sound/`, `sega/`.

NHL93 keeps these names and splits each into numbered pieces where the includes interleave (`hockey93_01` ... `hockey93_11`, `logic93_1` ... `logic93_5`, `middle93_1-2`, `penalty93_1-2`, `video93_1-2`), and adds `stats`, `menu`, `sram` and `graphics`. NHL94 renames and splits further (`checks94`, `assign94`, `input94`, `video94`, `display94`, ...), so 95's names come from 94, not 92.

## Rules

1. Use the NHL92 file names where NHL92 had the code: `main`, `hockey`, `logic`, `middle`, `penalty`, `video`, `frames`, `teamdata`, `sound`, `checksum`.
2. For code NHL92 did not have, use the NHL93 name if 93 added it (`stats`, `menu`, `sram`, `graphics`), else the NHL94 name (`title`, `cards`, `records`, `scout`, `shootout`, `optsetup`, `onetimer`, `crowd`, `fourway`, `goalie`, `attract`).
3. The 95-only files stay: `season95`, `trade95`, `create95`, `awards95`, `schedule95`.
4. Each file is `<name>95.asm`. `sega/` stays as it is, included from `main95`.
5. A routine is placed by, in order:
    - its label in NHL92 (907 labels): the 92 file that defines it;
    - else its label in NHL93: the 93 file, without the `93_N` piece number;
    - else the 94 file it came from (`docs/function_origins.csv`), through the bridge below;
    - a routine new in 95 inside a mixed file goes where its 95 file maps: the 95 pause menu stays in `menu95`, the new sound driver in `sound95`, the region lock in `main95`, the new line code in `checks95_04` goes to `logic95`.
6. Two exceptions: everything from `graphics94` stays in `graphics95` (as 93 did; NHL92 kept some graphics in `hockey.asm`), and short generic labels (`rts...`) are not matched by name.

### The bridge from 94 files to 92 names

Counted from the labels each 94 file shares with NHL92 and NHL93:

| 94 file | 92 / 93 name | Labels found in 92 / 93 |
| --- | --- | --- |
| `checks94`, `assign94`, `input94` | `logic` | 50 + 14 + 27 in 92 logic, 11 in 93 logic |
| `hockey94`, `collide94`, `replay94`, `setup94`, `data94` | `hockey` | 87 in 92 hockey, 70 in 93 hockey; data94 also has 3 penalty, 1 logic, 1 middle labels |
| `video94` | `middle` | 38 in 92 middle, 37 in 93 middle |
| `display94` | `video` | 22 in 92 video, 4 in 93 video |
| `penalty94`, `frames94`, `teamdata94`, `sound94`, `main94`, `checksum94` | same name | |
| `stats94`, `period94` | `stats` | 96 in 93 stats |
| `menu94`, `sram94`, `graphics94` | `menu`, `sram`, `graphics` | |
| `title94`, `cards94`, `records94`, `scout94`, `shootout94`, `optsetup94`, `onetimer94`, `crowd94`, `fourway94`, `goalie94`, `attract94` | keep the 94 name | none in 92 or 93 |

## Proposed layout

30 files (now 48; 94 has 33). "ROM runs" is the number of separate ROM ranges the file is made of. Bytes are exact (each run runs to the next run). Functions count labelled routines and tables; `main95` counts the `sega/` files it includes.

| File | Name from | Bytes | ROM runs | Functions | New in 95 | Drawn from today | What it holds |
| --- | --- | --- | --- | --- | --- | --- | --- |
| `main95` | 92 | 1690 | 1 | 37 | 30% | `main95` | vectors, cartridge header, the sega/ includes, the 95 region lock |
| `hockey95` | 92 | 28978 | 66 | 207 | 10% | `collide95_01`, `optsetup95`, `replay95`, `checks95_04` and 21 more | the exception handlers, Begin, game flow (Opening, StartGame, Gameloop), sprite setup and pad assignment, collisions, checks and the puck, player names, Pausemode entry, SetPersonel and the bench, options and passwords, the playoffs (MakeTree, PlayoffScreen), Goal, the clock and game over, replay, team attributes, ScoutingReport, penalty shot setup |
| `logic95` | 92 | 33740 | 34 | 198 | 31% | `checks95_01`, `checks95_04`, `input95_01`, `checks95_03` and 7 more | the player AI and assignments (asstab), puck handling, skateto, doinput (passes, shots), goalie control, line changes and the 95 saved lines, player movement |
| `middle95` | 92 | 5864 | 28 | 120 | 32% | `video95_02`, `video95_01`, `sound95_01`, `collide95_01` and 1 more | math, text printing, name and number formatting, team blocks (94 video94 = 92 middle) |
| `penalty95` | 92 | 5348 | 21 | 43 | 0% | `penalty95`, `data95`, `checks95_05`, `checks95_04` and 4 more | penalties and the penalty list, the referee, the scoreboard (UpdateScores, SetScore), line energy (linelist, AvgCline), penalty shot checks, the power play |
| `video95` | 92 | 2820 | 16 | 33 | 0% | `display95`, `video95_01`, `video95_02`, `checks95_03` and 4 more | VBlank, setvideo, setsortcords, uppads, sprite dumps, DMA lists, scroll, the clock display, SetSframe and the faceoff check, the crowd display (94 display94 = 92 video) |
| `frames95` | 92 | 11106 | 1 | 79 | 0% | `frames95` | SPA tables, revframetbl |
| `teamdata95` | 92 | 22878 | 3 | 31 | 0% | `teamdata95`, `credits95`, `main95` | TeamList and the team blocks, the credits text, ZeroLong |
| `sound95` | 92 | 453256 | 9 | 78 | 42% | `sound95_01`, `sound95_02`, `video95_01` | the 95 sound driver and bank, the sound calls, the 94 Z80 program and samples |
| `checksum95` | 92 | 80 | 1 | 1 | 0% | `checksum95` | ValidationRoutine |
| `graphics95` | 93 | 1070788 | 5 | 284 | 0% | `graphics95_01`, `graphics95_02`, `frames95`, `setup95_03` | all graphics incbins: pictures, rink, sprites, fonts, maps, logos, arena |
| `stats95` | 93 | 20368 | 21 | 205 | 42% | `stats95_01`, `optsetup95`, `stats95_02`, `period95` and 9 more | game statistics, player and team stats, the 95 season stats, League Leaders, period stats, line editor, highlights, summaries |
| `menu95` | 93 | 5192 | 3 | 39 | 82% | `menu95`, `video95_02` | Pausemode and the 95 pause menu |
| `sram95` | 93 | 924 | 2 | 10 | 30% | `sram95` | save RAM and leader list builders |
| `title95` | 94 | 5902 | 18 | 56 | 14% | `title95_01`, `title95_02`, `shootout95`, `setup95_01` and 12 more | title screen and credits, team songs, the shootout paths, LoadHomeTeamGfx, line data read / write and other helpers 94 kept in title94 |
| `cards95` | 94 | 5542 | 11 | 57 | 4% | `cards95_01`, `cards95_02`, `graphics95_01`, `video95_02` and 5 more | name entry and the name log, record updates, CalcAttrib and the attribute weights, name and number append helpers |
| `records95` | 94 | 2546 | 3 | 24 | 21% | `records95`, `shootout95` | user name entry, record holders, the playoff stats and round screens |
| `scout95` | 94 | 1672 | 4 | 31 | 0% | `scout95`, `setup95_03`, `video95_02` | matchups, team logo / arena / nickname lookups |
| `shootout95` | 94 | 1850 | 3 | 20 | 0% | `shootout95` | the shootout |
| `optsetup95` | 94 | 6300 | 10 | 46 | 33% | `optsetup95`, `video95_02` | team roster screen, the game setup screen, playoff structures, line data |
| `onetimer95` | 94 | 1520 | 4 | 11 | 0% | `onetimer95`, `input95_01` | one-timers |
| `crowd95` | 94 | 1022 | 8 | 15 | 0% | `setup95_03`, `scout95`, `collide95_01`, `collide95_02` and 1 more | AttributeCalc, the hot / cold table and lists, two corner collision checks (as in crowd94) |
| `fourway95` | 94 | 308 | 1 | 9 | 44% | `fourway95` | the four-player adaptor |
| `goalie95` | 94 | 232 | 1 | 1 | 0% | `checks95_01` | ManualGoalieMenu |
| `attract95` | 94 | 420 | 3 | 4 | 0% | `optsetup95`, `checks95_04` | DrawMatchupBitmaps, DrawTeamBitmap, SetPojoyMode, EASportsScreen |
| `season95` | 95 | 16772 | 1 | 181 | 98% | `season95` | season mode |
| `trade95` | 95 | 6502 | 1 | 45 | 100% | `trade95` | rosters and trades |
| `create95` | 95 | 12434 | 1 | 181 | 98% | `create95` | Create Player, free agents |
| `awards95` | 95 | 4960 | 1 | 67 | 99% | `awards95` | season awards, the playoff tree screen |
| `schedule95` | 95 | 2378 | 1 | 2 | 100% | `schedule95` | the season schedule |

Total: 282 runs, 1,733,392 bytes ($000000-$1A730F), as in the ROM.

### Where the label rule moves code across 94 lines

NHL92 names win over the 94 file, so a few routines go to a different file than their 94 file maps to:

- `Goal`, `ScoutingReport`, `StatsText`, `setoptions`, `updatescroll`, `p_initialZ80`, `p_music_vblank`, `VBlank_SetOptions` go to `hockey95` (NHL92 has them in `hockey.asm`).
- `PenaltyList`, `linelist`, `PerLabels` go to `penalty95`; `asstab` to `logic95`; `bfasciicon` to `middle95`; `VBcount`, `sizetab` to `video95`.

## Why it needs sections

A file in this layout is not one ROM range: `hockey95` is 66 ranges taken from 25 of today's files, `logic95` 34, `middle95` 28. The ROM order cannot change, so the 93 way (one numbered file per range) would give 282 files.

SNASM68K can do it with sections. `nhl95.asm` declares one group at org 0 and one section per run, in ROM order. Each run in a file starts with its `section` line. The assembler writes the sections in the declared order, whatever file or order the text is in:

```
rom	group	org(0)
	section	s000,rom	; $000000 main95
	section	s001,rom	; $00069A teamdata95 (ZeroLong)
	...
	section	s281,rom	; $1A72C0 checksum95
	section	s000
	include	main95.asm
	include	frames95.asm
	include	hockey95.asm
	...
```

and in `logic95.asm`:

```
	section	s129	; $07FC04 PauseScores, from checks95_01
...routines...
	section	s135	; $082FC2 assshoot, from checks95_02
...routines...
```

No addresses are hardcoded. The only numbers are `org(0)` and the 2 MB ROM size, as in today's `nhl95.asm`. Where a section lands follows from the sizes of the sections declared before it, so a routine that grows or shrinks moves everything after it, as it does now. The `$...` on the section lines above are comments.

## Tested (scratch copy, not committed)

Two builds were made in a copy of the tree outside the repo:

1. **The current files with a `section` line at each of the 282 run starts.** The raw output was the same as today's build, byte for byte. The current source already writes every branch and address size, so nothing changes size when a reference crosses a section.
2. **The proposed 30 files**, made by moving each run's text into its file. After the fixes below: 0 errors, the raw output was the same as today's, and after `fixopcodes.js` (628 patches, as now) `verifyRom.js` printed MATCH with SHA-1 `09e87b076aa4cd6f057a1d65bb50fd889b509b44`.

What had to change to get there (all source only, no byte changes):

| Problem | Fix |
| --- | --- |
| `String` and `PLAYER` in `macros/genesis.mac` use `*` and `org` to write the length back; SNASM refuses `org` after a section, and `if *&1` does not evaluate in one | Write the length from a forward label difference and pad with `even`: `.sb\@` / `dc.w .se\@-.sb\@` / the bytes / `even` / `.se\@`. The labels must use `.` (this build's local label character) and `\@` so each use is unique |
| `dcb.b $200000-*,$FF` (the fill at the ROM end) uses `*` | `dcb.b $200000-groupsize(rom),$FF`: the group's size is where the code ends |
| The `SPA...` equates in `frames95` are `=` (redefinable) symbols; SNASM will not forward reference them, and `hockey95` used them before `frames95` was included | Include `frames95` before `hockey95` (or make them `equ`) |
| An `opt oaq-,osq-,oz-` line sat in a file header and moved away from the sound driver it covers; `addi.l #1,d5` became `addq` and the ROM was 76 bytes short | Each `opt` pair goes inside the run it covers (there are four: sound driver, sram, two in video95_02) |
| The listing shows addresses relative to each section, and `fixopcodes.js` patches by listing address | `nhl95.asm` prints each section's size at the end of the build (`inform 0,"section s000 %h",sectsize(s000)`, one line per section). A section starts where the sizes before it add up to; add that to the listing address. Tested by rewriting the listing this way (the sizes add up to $1A7310), then running the normal `fixopcodes.js` |

Not tested, and needed before it could replace the current layout:

- **Segment builds.** Today each stub carries an `org` and `Name = $ADDR` equates for what is outside its file. A stub for a file here would need an address for each of its runs (one group with `org` per run), so 30 stubs would hold 282 run addresses, and `verifySegment.js` would have to check a list of ranges. Two groups whose ranges overlap overwrite each other with no error. The other way, with no run addresses, is to check each file's runs inside the full build, using the same section sizes as `fixopcodes.js`; that checks the bytes but does not assemble the file on its own.
- **The tools** that read the file list or the listing: `package.json` scripts, `tools/file_origins.py`, `scan_cleanup.py`, the SEGMENT_AGENT.md ROM map, `docs/name_map.csv`.
- **New code** must keep writing explicit sizes (`bra.w`, `.l` addresses). In the small test an unsized `bra` to another section came out as `bra.w` and a label address as absolute long, where in one section SNASM would have used the short forms.

## Doing it

1. Fix the macros, the end fill, the include order and the `opt` lines in the current files, and teach `fixopcodes.js` about sections. Build: it must still match.
2. Add the section declarations to `nhl95.asm` and a `section` line at each run start. Build.
3. Move the text of each run to its file, in ROM order, each with its section line. Build.
4. Rework the stubs, `verifySegment.js` and the tools; build every segment.

Steps 1 and 2 change no file names and could be done first on their own.

## For and against

For:
- Each routine is in the file its family has had since NHL92: the AI in `logic95`, helpers in `middle95`, penalties in `penalty95`. Comparing with 92 / 93 / 94 is file to file.
- 30 files, the closest to 94's 33 of the three proposals, with no numbered pieces.
- Code that 94 split over several files is together again (`checks94`, `assign94`, `input94` are all `logic95`).
- The 95-only files are untouched.

Against:
- The ROM order is gone from the source. To read the ROM in order you follow 282 section lines across 30 files; `nhl95.asm` and the CSV are the map.
- Some files become grab bags: `hockey95` is 66 runs from 25 files. The small 94 files keep what 94 put in them (`crowd95` holds the hot / cold lists, `title95` the team songs and shootout paths).
- The build gets more complex: sections, a section-aware `fixopcodes.js`, multi-range segment stubs, and the include order and `opt` rules above.
- It is the largest change of the three, and it differs from how 93 (numbered pieces) and 94 (renamed pieces) handled the same problem.

## Compared with proposals 1 and 2

- Proposal 1 (grouping) and 2 (naming) keep each file one ROM range, so the build stays as it is. This proposal is the only one that groups by function rather than by position.
- They can be mixed: steps 1 and 2 above (sections, no moves) are safe on any layout, and the names here could replace the numbered names of proposal 1 for the files that are one range anyway.
