# HANDOFF: comment and name cleanup (NHL95)

## Purpose
Make this bit-perfect 68000 SNASM disassembly read like clean original source: accurate names that follow the
NHL92 Genesis (EA original) lineage, and comments without disassembler or porting artifacts. Code, data and
bytes never change: every build must still MATCH the retail ROM.

## Setup
ROMs (gitignored, never commit): lst/nhl95.bin.
Windows: `npm run build:retail` (extractassets, build95.bat, fixopcodes, verify);
segments: `npm run seg:<name>` (all keys in package.json `seg:*`).
Linux (wine): `apt install wine wine32` (dpkg --add-architecture i386), `export WINEDEBUG=-all`, then
1. `node extractAssets95.js lst/nhl95.bin` (once, fills Extracted/)
2. `wine cmd /c "set rev=0&& set checksum=1&& build95.bat"`
3. `node fixopcodes.js "output/nhl95 .lst" output/nhl95.bin`
4. `node verifyRom.js output/modified_nhl95.bin <reference ROM>` must print MATCH
5. Segments: run each package.json `seg:*` chain the same way (`wine cmd /c "buildseg.bat <seg>"`, then its node steps); verifySegment.js must MATCH.
Failed-assembly detection: delete output/*.bin first, then check the bin exists and is fresh and that output/Build*.log has no
`^[1-9][0-9]* error` line. tools/verify_all.sh does all of this (top ROM + every segment).

## Naming lineage
- 92G (abdulahmad/NHL92Genesis, EA source) is the root. 93 -> 92; 94 -> 93 -> 92; 95 -> 94 -> 93 -> 92.
- Use the earliest game's name for the same routine/variable. 92 names are kept as-is, typos included.
- A name not from 92 that is inaccurate (checked against the routine body / usage) gets fixed, and the fix is propagated
  forward: 93 -> 94 -> 95, and to abdulahmad/NHLPA93SNES for 93 names that exist there.
- Clash rule: never reuse a name already used for a different item; pick a descriptive name instead.
- Teams: 93 (unlicensed) uses city names only; 94/95 use NYIslanders/NYRangers (NYI/NYR) style names.

## Comment rules
No other games' names or "X name" notes, no source-file/segment names, no IDA references (IDA, loc_, sub_, unk_),
no "(was: X)" history, no hardcoded ROM addresses (keep VRAM/RAM values, include address maps, RAM equate address
comments), no "only in 9x" tags ("New in 94/95:" allowed in file/section headers). Keep real explanations and
value-difference notes like "(94 $58)" / "92 used bit 6". Every routine has a header comment. Concise.

## Records
- docs/name_map.csv: every rename (old -> new, source/reason). History lives here, not in comments.
- docs/name_review_9x.md: name-accuracy checklist (name, verdict) per module.

## Conventions
Small commits per module; builds MATCH before every push; `git pull --rebase origin main` then push to main.
No force-push, no PRs, never commit ROMs, Extracted/ or output/.

## Local label style
Follow 92G (EA source): ~31% of its locals are number-only (.0, .1 ...), the rest short lowercase words
(.loop, .next, .top, .done, .ex/.exit, .ok, .wait, .skip, plus abbreviations like .nna, .nodec, .sr).
- Give a word where the branch has a clear meaning; keep numbers for trivial jumps and for locals
  inherited from a matching parent routine. A routine matching a parent (92/93/94) uses the parent's names.
- Data tables indexed by number stay numeric, as in 92.
- Renames are scope-aware (routine scope, code part only); diff-review every commit.
  Tools on the box: /workspace/tools_ll/ll.py, prop.py (copy parent local names), newnum.py, commit.sh.

## Current state / Next
- Comment review: done in 93, 94, 95 and NHLPA93SNES.
- Name pass (full body read), records in docs/name_review_93.md / _94.md / _95.md:
  - Phase A (93): DONE, all modules. Renames propagated to 94/95/NHLPA93SNES.
  - Phase B (94): DONE (all src modules, RAM names, equates; docs/name_review_94.md).
  - Phase C (95): DONE (all modules, ram95, graphics95, frames95, sound95; docs/name_review_95.md).
- Local label pass (95): 94 local names propagated (prop.py, align.py, consist.py hand-align). Open items of the
  94->95 consistency check are listed in docs/name_review_95.md (last "Local labels" row). New-in-95 done:
  video, summary, replay, display, control, main, crowd, hockey, playoff, shootout, players, logic, injury,
  input, skate.
  94->95 consistency items and the 10 differently named routines: DONE (docs/name_review_95.md).
  New-in-95 locals: backward branch targets were first auto-named .loop/.loopN and single rts exits .exit
  (tools_ll/autoloop.py); that was not a name review.
  Full body read of new-in-95 routines (names, headers, locals) DONE: penalty, collide, faceoff, records, scout, title, setup, goal, middle, lines, pause, awards, sound, trade, stats, create, season.
  TODO (full body read still needed): none.
  Data labels / equates usage check DONE.
  Next: NHLPA93SNES names and locals (93G names first, then 92G, then behavior).
- Day macro (schedule record) now lives in src/macros/genesis.mac with the other macros; schedule95_stub includes it. MATCH.
- Header rewrite (file header comments, 92 style): 93G and 94G done; 95G top level, lists, main, ram, macros, sega, stubinc, hockey, checksum, sram, credits, control, display, graphics, engine\, front\, tables\, sound\ and all stubs done. Header rewrite complete in 93G, 94G and 95G.
