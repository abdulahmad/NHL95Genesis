# HANDOFF: comment and name cleanup (NHL95)

## Purpose
Make this bit-perfect 68000 SNASM disassembly read like clean original source: accurate names that follow the
NHL92 Genesis (EA original) lineage, and comments without disassembler or porting artifacts. Code, data and
bytes never change: every build must still MATCH the retail ROM.

## Setup
ROMs (gitignored, never commit): lst/nhl95.bin.
Windows: `npm run build:retail` (tools/prebuild.js, build95.bat, fixopcodes, verify);
segments: `npm run seg:<name>` (all keys in package.json `seg:*`).
Linux (wine): `apt install wine wine32` (dpkg --add-architecture i386), `export WINEDEBUG=-all`, then
1. `node tools/prebuild.js retail` (checks the ROM, extracts into Extracted/ if missing or incomplete; same as `node tools/extractAssets95.js lst/nhl95.bin`), then `export NHL_PREBUILD_DONE=1` so the .bat files skip their own pre-step (no node under wine). Accepts the one retail ROM (SHA-1 09e87b07...); other ROMs are refused.
2. `wine cmd /c "set rev=0&& set checksum=1&& build95.bat"`
3. `node tools/fixopcodes.js "output/nhl95 .lst" output/nhl95.bin`
4. `node tools/verifyRom.js output/modified_nhl95.bin <reference ROM>` must print MATCH
5. Segments: run each package.json `seg:*` chain the same way (`wine cmd /c "buildseg.bat <seg>"`, then its node steps); tools/verifySegment.js must MATCH.
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
no "(was: X)" history, no hardcoded ROM addresses (keep VRAM/RAM values, RAM equate address
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
- Restructure: tables95.asm inlined into nhl95.asm; teamdata95, frames95, schedule95 (and stubs) moved from src/tables/ to src/. MATCH (ROM + all segments).
- Restructure: sound95 (and stub) moved from src/sound/ to src/; z80old95.asm inlined into sound95.asm as the Z80OldProgram macro (engine95.asm expands it at $07E0E0; segment z80old95 = src/z80old95_stub.asm with Z80OLD_SEG). src/sound/ removed. MATCH.
- Restructure: root .js tools (extractAssets95, fixopcodes, verifyRom, verifySegment) moved to tools/; run them from the repo root as node tools/<name>.js (default ROM / Extracted / output paths are resolved from the repo root). Fresh extract + ROM + all segments MATCH.
- Boundary moves (Task D, routine names/headers only): PuckcIsGoalie players95 -> logic95 (assignment helper);
  limitfo penalty95 -> faceoff95 (faceoff spot); linelist penalty95 -> lines95 (line change text);
  GetHighlightSlot + HighlightsHelp trade95 -> stats95 (highlights screen); GetTeamUser awards95 -> records95
  (user names). Stub orgs/equates, package.json, list comments, ROM map, csv records updated. MATCH.
  FILE_ORIGINS.md ranges updated; its origin percentages were not regenerated.
- Header rewrite 2 (story-style file headers, model 93G hockey93/main93/menu93): all 95G modules done. MATCH.
- Segment stubs moved to src/stubinc/ (buildseg.bat <name> assembles stubinc\<name>_stub.asm; seg:* scripts take the bare name). MATCH.
- Undone: the z80old95 inlining. src/sound/z80old95.asm restored (engine95.asm includes sound\z80old95.asm at $07E0E0); Z80OldProgram macro and Z80OLD_SEG removed from sound95.asm; stubinc/z80old95_stub.asm back to its normal form. sound95 stays in src/. MATCH (ROM + all segments).
- Extractor takes any known retail ROM: SHA-1 detection (one retail version, 1994.JUL -00), per-version offset map, clear refusal of unknown ROMs. verify_all.sh extracts fresh first. Fresh extract + ROM + all segments MATCH.
- Build pre-step: every entry point (npm build:*/seg:* scripts and the .bat files) runs tools/prebuild.js first. It checks the ROM (path, SHA-1, size; stops with a message naming the exact file and version if it is missing or wrong, ROMs are not in the repo) and re-runs the extractor when Extracted/ is missing or incomplete. The extractor writes Extracted/.extract-complete.json last (ROM SHA-1, extractor SHA-1, every file and size). npm scripts set NHL_PREBUILD_DONE=1 so the .bat does not repeat it; verify_all.sh runs it with Linux node. Tested with Windows npm/cmd under wine: fresh build auto-extracts and MATCHes; missing ROM stops with the message. MATCH.
- Cleanup run (Oct 2026), three tasks in order:
  1. Section banners inside src .asm: DONE. Routine-name lists, ROM addresses and per-version weeds replaced by short
     plain English dividers (15 files). Kept as-is: teamdata95 data layout banners, SegaInit (Sega's own banners), stubs.
  2. Include line address maps: DONE (nhl95, main95, engine95, front95; plain descriptions kept). Rule above updated: no ROM addresses on include lines.
  3. NHLPA93SNES src/routines/** routine headers: DONE (all 448 files, one commit per folder; see its docs/HANDOFF.md).
- frames95 symbols: raw animation offsets and sprite-frame immediates take the frames95 names. Counts are immediates replaced. A new equate is recorded below and in name_map.csv. Unsure stays numeric.
  - replay95: 6 (SPAblock x2, SPFpuck, SPFfaceoff+6 one past the last frame, SPFbglass, SPFPen). The compare against frame 1 stays 1.
  - goal95: 1 (SPAsiren on the struct after the goal). Scroll clamp #$FFCE on yleader stays.
  - players95: 1 (resetplstuff SetSPA SPAglide).
  - shootout95: 2 (SetSPA SPAglide, SPFpuck on the shadow). Path and coordinate words stay numeric.
  - faceoff95: 4 (SPFpuck on the shadow, SPAglide, SPAfaceoff, SPAfaceoffr). The faceoff-window $A800 word stays.
  - input95: 13 (SPAfaceoff, SPAfaceoffr, SPAgswing, SPApassf, SPApassf2, SPApassb, SPApassb2, SPAshotf, SPAfakeshotf, SPAshotb, SPAfakeshotb, SPAglidewp, SPAshotb compare). OneTimerGoalieTbl $FFCE stays.
  - skate95: 46. The turn is eori #SPAturnl-SPAturnr, addi #SPAturnr, addi #SPAturnrwp-SPAturnr. noturn0 move.w #2,d1 is #SPAskate. Goalie ready, dive, glide, stop, skate, board and the 10-word save list. moveq #2,d4 stays.
  - logic95: 42 (slam, dive, glove and stack compares, the four extra loads, saveanim's 10 words, SPApflip, SPFpuck, SPAblock x2, SPAglide x4, wall left x3 and right, SPAshotf, SPAshotb, SPAstanley, SPAcelebrate, the 4 pump words). The Y compare is #-50. The team-struct #$E10 and the pump random #2 stay.
  - collide95: 77 (SPAbglass, hold/hook/sweep/burst, both checking lists, flail and the hold pair, fall and injury compares and loads, the board check and board list, flip, goalie ready and the pad stacks, SPAglidewp, SPAgdive, SPAcatch, the bounce anims). Reach tables, SPAnum #$18, and the save-attribute words stay.
  - display95: 26 (SPFarrow, SPFarrow+3, SPFarrow34, SPFarrow34+3, the six pad and replay frames, five home SPFglide, five away SPFglide+4, SPFGoalie, SPFGoalie+4, SPFgoal, SPFgoal+1, SPFpuck+1, SPFpuck). The $FFCE coordinates stay.
  - setup95: 0. The $E10 wait stays.
  - New equate: SPFarrow34 = SPFreplay+1 (frame $73), joypad 3 and 4 arrows; pad 4 is +3. Frames 115-120 are those arrows.
  - Unsure: none yet.
