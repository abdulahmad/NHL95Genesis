# Why NHL95 moved its routines around

NHL95 keeps most of NHL94's code but puts it in a completely different order. 94's files are cut into pieces and mixed together, so the 95 source (named after the 94 files) looks scrambled. This note looks at why that happened and what Mark Lesser's 95 source probably looked like.

It is analysis only: nothing in `src/` changes. The numbers come from the full build listing (`output/nhl95 .lst`), the NHL94Genesis listing, the NHLPA93 SNES disassembly (its `docs/file_map.md` bank blocks) and the NHL95 PC map (`name_map_94.csv`).

## Short answer

- The reorder is not SNES-style banking. The Genesis 68000 has a flat address space and gains nothing from bank placement. Also, the 95 Genesis order does not follow the 93 SNES bank layout, and the 95 ROM has no bank padding or alignment.
- It is not for speed or branch range either. Callers sit further from what they call in 95 than in 94. About two thirds of 95's calls are `jsr`, against under a quarter in 94.
- What fits the evidence is a hand re-filing of the 94 source into subsystem files, done routine by routine by the same programmer. The 95 ROM order is the include order of files like "video", "collision", "helpers", "pause menu", "AI", "input", "setup screens", "rules", "lines", "skating" and "replay". Each of those is tidy. They only look like a wreck through 94's file names, because each 95 subsystem pulled routines out of several 94 files.
- An SNES connection is still possible at the source level. Visual Concepts wrote NHL95 SNES under the same High Score Productions umbrella (Michael Brook), with the same artists and designers. Splitting the code into subsystems would make it easier to hand over. The 93 SNES layout can't confirm or rule this out, because 95 SNES is a different code base by a different team. The test that would settle it is under "How to test the SNES idea".

## Who wrote what

| Game | Programmer | Notes |
| --- | --- | --- |
| NHL92 / NHLPA93 Genesis | Jim Simmons | One programmer. |
| NHL94 Genesis | Mark Lesser (MBL Research, EA contractor) | Rewrote and extended Simmons's code. |
| NHL94 SNES | EA Canada (Amory Wong) | A port of Lesser's Genesis code. |
| NHL95 Genesis | Mark Lesser | Released Sept 1994. Credited to High Score Productions / Double Diamond Sports. |
| NHL95 SNES | Visual Concepts (Jason G. Andersen, Jonah Stich) | Released Nov 1994. Design by Kevin Hogan and Michael Brook. Amory Wong was not involved. No shootout, playoff mode, fake shots or drop passes. |

Michael Brook left EA after 94 and, in the oral history, "was the developer of NHL '95". The art and sound credits (Doug Wike, Lori Champney, Cynthia Hamilton, Terry Falls, Ian House, Kendra Lammas, Alyson Markell) are shared by the two 95 versions. Lesser describes 95 as disrupted by EA politics and Brook leaving, with a rushed push for a faster game and many outside suggestions, written by "a single programmer, one guy, doing everything". So the 95 Genesis code was reorganized by the same person who wrote 94, under pressure, while a separate team built the SNES version from the same design.

## What the code says

### 95 order versus 94, 93 SNES and PC

These are rank correlations (Spearman) of routine order, using routines whose labels appear in each pair of games:

| Compared | Routines | Correlation |
| --- | --- | --- |
| 95 with 94 | 261 (in 95, 94 and 93 SNES) | -0.074 |
| 95 with 93 SNES | 261 | 0.148 |
| 94 with 93 SNES | 261 | 0.055 |
| 95 with 95 PC | 149 | 0.244 |
| 94 with 95 PC | 149 | 0.348 |

The 95 order has no relation to 94's. It follows the 93 SNES order only weakly. Neighbouring routines in the 95 Genesis order share a 93 SNES bank block 22% of the time, against 28% for 94, so 95 is further from the SNES grouping than 94 was. The 131 routines in 93 SNES bank $80 (the per-frame game engine) are spread over the whole 95 code range ($9F22-$A0B3E), not gathered in one place. The PC order explains 95 even less than it explains 94.

### Locality got worse

These are call distances, comparing 95 code at $79900-$A1000 with 94 code at $0-$1A000:

| | 95 | 94 |
| --- | --- | --- |
| Calls | 3592 | 1383 |
| Median caller to callee distance | $8A1E bytes | $1F48 bytes |
| Callee within 32K (`bsr.w` range) | 48% | 80% |
| Median distance in labels | 302 | 66 |
| `bsr.w` / `bsr.s` | 1114 / 16 | 1027 / 7 |
| `jsr.l` (of which within 32K) | 2334 (544) | 310 (75) |

If routines had been moved to sit near their callers, these numbers would improve. They got worse instead.

### `bsr` became `jsr`, never the reverse

For calls that exist in both games (the same calling routine calls the same routine):

| 94 | 95 | Count |
| --- | --- | --- |
| `bsr` | `bsr` | 332 |
| `bsr` | `jsr`, callee now out of `bsr.w` range | 234 |
| `bsr` | `jsr`, callee still within range | 116 |
| `jsr` | `jsr` | 245 |
| `jsr` | `bsr` | 0 |

This is what someone moving code by hand leaves behind. Each move breaks some `bsr.w` calls, the assembler reports them out of range, and they get changed to `jsr`. Nothing is ever changed back. The 116 calls that are `jsr` but within range mean those routines were further apart at some point during development than they are in the final ROM. So the code moved more than once, or whole routines had their calls switched to `jsr` at once.

### 94's code moved in small intact blocks

1130 labels are in both 94 and 95. Of neighbouring pairs in the 95 order, 57% were also neighbours in 94. That gives 492 runs that stayed together. The median run is 242 bytes, a routine or two; the largest are the sound and graphics data. From one run to the next, the jump in the 94 order goes forward 260 times out of 491, so the direction is random. The code wasn't shuffled in big sections or sorted mechanically. It was cut and pasted a routine or two at a time.

New 95 routines sit directly next to the 94 routine they came from: `getnameD7` next to `getname`, `FormatPlayerNameD7` next to `FormatPlayerName`, `PutClockDigit` next to `showclock`. So the programmer edited the files the code ended up in. The ROM order is his source order, not something a tool produced afterwards.

### One engine assembly, self-contained front-end files

A PC-relative branch (`bsr.w`, `bra.w`, `bcc.w`, `x(pc)`) needs caller and target to be in the same assembly. Merging the spans of every such branch shows which code must have been assembled together:

| Range | Bytes | Contents |
| --- | --- | --- |
| $79948-$8DEE8 | 83,360 | The game engine: VDP, collisions, helpers, pause menu, AI, input, setup screens, playoffs, faceoffs, penalties, lines, skating, replay |
| $8E0C0-$95D62 | 31,906 | Season, period and stats screens |
| $96C1A-$9ACE4 | 16,586 | Trade and create player |
| ... | | 29 smaller pieces up to $A0FFA |

In 94, which is one assembly with includes, PC-relative branches cross 16 of its 17 file boundaries. In 95, the engine is one block where branches cross every internal boundary. The front-end files (season, trade, create, awards, records, scout, shootout, title) barely branch into each other: the hard boundaries fall at or near their starts, for example the season95 start at $8DF5A. That looks like an engine whose files were cross-edited all the time, followed by front-end modules each written or rewritten as a unit.

## Ideas, weighed

1. **SNES co-development (bank-driven).** On the SNES, code in the same bank calls with a fast `JSR` and data in the bank is cheap to reach, so 93 SNES grouped the per-frame engine in bank $80. If Lesser had laid out the Genesis code to mirror the SNES banks, the 95 order would follow a bank structure. It doesn't follow 93's. The 83 KB engine block is bigger than a 32K LoROM bank and mixes per-frame code with setup screens and the pause menu. There is no padding or bank alignment anywhere in the 95 code. The 68000 gets no speed from any of this. As a performance reason for the Genesis layout, this doesn't hold up.
2. **SNES co-development (source sharing).** A softer version: the source was re-filed into clean subsystems because a second team (Visual Concepts) needed to read it, or because Brook's group wanted one design layout across both versions. This fits the timing, the shared design and art credits, and the subsystem order. It can't be tested without 95 SNES. See below.
3. **Re-filing by subsystem.** 94's files grew by accretion: `checks94` has AI, faceoffs, lines and shootout code; `hockey94` has game flow and the pause menu; `video94` has hardware code and text helpers. A programmer coming back for a fast, rushed rewrite would move each routine into the file for the subsystem he was working on. The engine order below is a clean subsystem order. This is the best fit.
4. **Rework order.** Within the engine, the subsystems come roughly in the order of a game frame: hardware and vblank, collisions, helpers, pause, AI, input, then the setup and rules screens, lines, skating and the clock, and replay. Routines may have been pulled into new files as Lesser reworked each part for the faster 95 game. The new variants next to the old routines support this.
5. **Iterative moves under schedule pressure.** The one-way `bsr` to `jsr` change and the in-range `jsr` calls show code moved several times. Neither locality nor tidiness was the goal for each move; fixing range errors was the cost of moving.
6. **Placement of the sound and data blocks.** The new 95 sound driver and its 453 KB of sound data sit right after the low code (`main`, `teamdata`, `frames`, `schedule`, `sram`, `hockey`, `display`, the sprite setup), before the engine. That start keeps 94's order. The only bank-like constraint on the Genesis is the Z80's 32K window onto 68000 memory for sound data, and it affects data placement, not 68000 code. It doesn't explain the code order.

Rejected: locality or branch range (the numbers got worse), the PC version's order (weaker than 94's), a toolchain change (92, 94 and 95 all need the same `cmp` opcode patches from EA's assembler), and mechanical sorting (the runs are small and the jumps between them random).

## How the source was probably organized

The assembler writes code in source order, so the ROM is a direct picture of Lesser's files. Only the boundaries between files are unknown. Read by subsystem, the ROM becomes a short, orderly include list. The current file names on `main` are given for each:

| Order | Probable 95 file | Address | Contents | Files on `main` |
| --- | --- | --- | --- | --- |
| 1 | `main` | $000000 | Vectors, header, init, region lock | main95 |
| 2 | `teamdata`, `frames`, `schedule` | $000772 | Team blocks, sprite frames, season schedule | teamdata95, frames95, schedule95 |
| 3 | `sram` | $009722 | Save RAM | sram95 |
| 4 | `hockey` | $009AC8 | Game flow, frame setup, sprite setup | hockey95, display95, setup95_01 |
| 5 | `sound` | $00AF44 | 95 sound driver, sound bank, sound calls | sound95_01 |
| 6 | `video` | $079902 | VDP, DMA, sprites, scroll, decompressor, vblank, pads | video95_01 |
| 7 | `collide` | $07A762 | Collisions | collide95_01 |
| 8 | `middle` | $07C512 | Math, random, text, clock, names, numbers, team blocks (NHL92's `middle.asm`) | video95_02 |
| 9 | `fourway`, Z80 program | $07DEA0 | Team graphics, four-way adaptor, the Z80 program | fourway95, sound95_02 |
| 10 | `pause` | $07E36C | Pause menu and its items | menu95 |
| 11 | `logic` (AI) | $07F97E | Assignments (asstab ... skateto), one-timer, shooting, CP goalie, lineup | checks95_01, onetimer95, checks95_02, collide95_02 |
| 12 | `input` | $083EB2 | Pass and shoot controls | input95_01 |
| 13 | `setup` | $084FE6 | Roster, attributes, game setup, password, line data | optsetup95 |
| 14 | `rules` | $087BA2 | Playoff screen, scores, faceoffs, penalties, offsides | setup95_02, checks95_03, penalty95, data95 |
| 15 | `lines` | $08A056 | Line changes | input95_02, checks95_04 up to $8B4DF |
| 16 | `skate` | $08B4E0 | Skating, goals, clock, period over, controller setup | checks95_04 from $8B4E0 |
| 17 | `replay` | $08D39A | Instant replay | replay95 |
| 18 | front end | $08DF5A | season, period, stats, trade, create, cards, records, awards, shootout and penalty shot, scout, summaries, title. Each is its own module | season95 ... title95_01 |
| 19 | data | $0A1A5A | Graphics, logo palettes, arena graphics, credits, checksum | graphics95_01 ... checksum95 |

Items 6-17 are the single engine assembly. The front-end modules each stand alone. NHL92 had the same shape: a root `hockey.asm` including `main`, `teamdata`, `frames` and `ram`, then the game flow, then `logic`, `middle`, `penalty` and `video`. 95 looks like Lesser going back to that idea with finer subsystems, rather than keeping 94's accreted files.

`docs/PROPOSAL_D_SUBSYSTEMS.md` turns this table into a file layout with guessed names, folders and nested include lists.

This is close to the subject names in `docs/PROPOSAL_NAMING.md` (`video95_vdp`, `video95_text`, `checks95_lines`, `checks95_skate`, ...). The difference is that those names keep the 94 file as a prefix, while the table above names the 95 subsystem alone.

## How to test the SNES idea

Disassemble NHL95 SNES (Visual Concepts, Nov 1994) far enough to name its routines against the 95 Genesis labels. Then rerun the comparisons above against its bank map:

- the correlation of the 95 Genesis order with the 95 SNES order;
- how often 95 Genesis neighbours share a 95 SNES bank, compared with 94 Genesis neighbours;
- whether the engine block ($79948-$8DEE8) matches one group of SNES banks, and each front-end module a bank of its own.

If 95 Genesis tracks 95 SNES much more closely than 94 does, the two were organized together. If not, the re-filing was Lesser's own.
