# NHL 95 Genesis

> **Making a mod, hack, port or other derivative work from this repo? You must credit me (abdulahmad) and everyone credited in this repo, clearly, in your own repo and in every release. See [Credits and derivative works](#credits-and-derivative-works).**

See [CONTRIBUTING.md](CONTRIBUTING.md) for how changes are made (names, comments, layout, verification).

> **Work in progress:** this disassembly is unfinished and unpolished, and is being actively worked on. Expect labels, file layout and docs to change.

## 🚧 Current Status

- The file split is more mature, and very different from 93 and 94.
- Remaining: label cleanup, a pass over the team data and frame lists, and another check of the split.

Bitwise rebuild of NHL 95 for the Sega Genesis. Every segment is matched: the full build is byte for byte the retail ROM (SHA-1 `09e87b076aa4cd6f057a1d65bb50fd889b509b44`), and each segment also builds and verifies on its own.

The reference ROM is `lst/nhl95.bin` (2 MB). It is what every build is compared with. Do not use a different ROM. The listing it was transcribed from is `lst/nhl95.bin.lst`, an IDA LST in ASM68K / MRI mode with no address column (`loc_` / `sub_` names are the address).
## Supported ROMs
NHL 95 had one retail release; `tools/extractAssets95.js` accepts only that ROM, found by SHA-1, and refuses any other (bad dump, hack, prototype) with its SHA-1, size and header. The slices are kept as a per-version map from retail address, so a new version only needs a row with its SHA-1 and offsets.

| Version | Header | File | Size | SHA-1 |
| --- | --- | --- | --- | --- |
| Retail | `1994.JUL`, `GM T-50856 -00` | `lst/nhl95.bin` | 2 MB | `09e87b076aa4cd6f057a1d65bb50fd889b509b44` |


The source follows [NHL94Genesis](https://github.com/abdulahmad/NHL94Genesis): its file names, routine names, RAM names and comments, with [NHLPA93Genesis](https://github.com/abdulahmad/NHLPA93Genesis) where 94 does not have the routine. A comment `;95: ...` marks a 94 routine 95 changed; `95 only.` marks a routine 94 does not have.

## Layout

| Path | What it is |
| --- | --- |
| `src/nhl95.asm` | Top level of the full build: the equates, `org 0`, then in ROM order the trunk files and the two include lists, each with its start address. |
| `src/engine95.asm`, `front95.asm` | Include lists: the files of `engine\` and `front\` in ROM order, each with its start address. No code and no `org`. `engine95.asm` is one assembly (PC-relative branches cross every file in it). `sound\z80old95.asm` sits between `fourway95` and `pause95` in the ROM, so `engine95.asm` includes it. |
| `src/<file>95.asm` | The trunk, in `src/` itself: `main95` (vectors, header, region lock), `teamdata95` (team data), `frames95` (sprite frame tables), `schedule95` (the season schedule), `sram95`, `hockey95` (game flow), `display95`, `control95`, `graphics95` (the player pictures, rink, sprites, fonts, screen maps, team logo palettes and arena graphics, $0A1A5A-$1A6C27), `credits95` and `checksum95`. |
| `src/sound/` | `sound95` (the 95 sound driver, its Z80 program and banks, the sound calls; in the trunk's include order, as in NHL 92), `z80old95` (the unused 94 Z80 program) and `z80_snd_drv93.asm`, its Z80 source (the 93 / 94 driver, names as in NHL 92's driver). `tools/prebuild.js` assembles it with asm80 (`npm i`) into `output/z80_snd_drv93.bin` and checks it against the ROM (`tools/buildZ80.js`). The new 95 driver (`Z80Program`, `z80_snd_drv95.bin`) is still an incbin. |
| `src/engine/` | The game engine, $079902-$08DF59, one file per subsystem: `video95`, `collide95`, `middle95`, `fourway95`, `pause95`, `logic95` (the player AI), `players95`, `input95`, `setup95`, `playoff95`, `faceoff95`, `penalty95`, `lines95`, `skate95`, `goal95`, `replay95`. |
| `src/front/` | The menus and screens around the game: `season95`, `stats95`, `trade95`, `create95`, `records95`, `awards95`, `shootout95`, `injury95`, `scout95`, `crowd95`, `summary95`, `title95`. |
| (each code file) | One file per 95 subsystem, named for what it does. Each file is one contiguous range of the ROM. The header says which 94 files it was adapted from; where it takes code from more than one 94 file, a banner before each run names the 94 file. `docs/FILE_ORIGINS.md` gives the 94 file of every routine. |
| `src/sega/` | Sega's cartridge header (`SegaIDTable95.asm`, $100-$1FF) and power-on code (`SegaInit.asm`, $200-$2F9), included by `main95.asm`. |
| `src/ram95.asm` | The RAM map, Z80 RAM and the save RAM offsets (`SR...`). Equates only. |
| `src/stubinc/` | `ports.inc` (IO and VDP ports) and `equals.inc` (VDP status bits). Equates only. |
| `src/macros/genesis.mac` | The `VmInc`, `String`, `HEX2`, `Player` and `PIX` macros. |
| `<file>_stub.asm` | One per code file, all in `src/stubinc/` (`src/stubinc/logic95_stub.asm`): the segment org, the equates, equates for the outside addresses the segment uses, then `include <path>.asm`. A stub builds and verifies one segment by itself. |
| `docs/name_map.csv` | Every label: address, current name, the IDA name, the old name if it was renamed, and the file. |
| `docs/WHY_95_MOVED.md` | Why 95 reordered 94's routines (SNES banking, locality and re-filing weighed against the code), and the subsystem files the 95 source probably had. |

Files included by `nhl95.asm` or an include list have no `org`. Assembler paths are relative to `src/`, also in the subfolders (`include engine\logic95.asm`, `incbin ..\Extracted\...`). Graphics and sound are incbins of `Extracted/`.

## Build

The graphics and sound are not in the repo. Extract them from the reference ROM first:

    npm run extractassets

That writes `Extracted/` from `lst/nhl95.bin` with `tools/extractAssets95.js`.

Full ROM builds assemble `src/nhl95.asm` with `build95.bat`. The listing is `output/nhl95 .lst`. The opcode-corrected output is `output/modified_nhl95.bin`.

| Script | Flags | Result |
| --- | --- | --- |
| `npm run build:retail` | `checksum=1` | Retail, then a byte compare to `lst/nhl95.bin`. |
| `npm run build:dev` | `checksum=0` | No validation and no retail verify. Use this while editing. |

`build:dev` (`checksum=0`): `RegionOK` skips `jsr ValidationRoutine` (3 `nop`s instead) and the header checksum is 0, so changed code still boots. With `checksum=1` the validation routine sums the ROM, and any change turns the screen red.

Segment builds: `npm run seg:<file>` (`seg:logic95`) runs `buildseg.bat <name>` (`buildseg.bat logic95` assembles `src/stubinc/logic95_stub.asm` to `output/logic95.bin`), `tools/fixopcodes.js`, then `tools/verifySegment.js <file> <org> lst/nhl95.bin`, which overlays the segment on the reference ROM and compares. A MATCH of 0 bytes is a failure.

## Build pre-step: ROM check and automatic asset extraction
Every build entry point (`npm run build:*`, `npm run seg:*`, and the batch files run directly) first runs `node tools/prebuild.js`. It:

1. checks that the ROM the build needs is in place and is exactly the right version (SHA-1 and size);
2. checks that `Extracted/` is complete: the extractor writes `Extracted/.extract-complete.json` last, listing every file it wrote (with its size), the ROM it read and the extractor's own SHA-1;
3. runs the extractor if `Extracted/` is missing, incomplete (no marker, a missing or resized file) or was written by an older extractor.

If the ROM is missing (or is a different dump), the build stops with the full path and file name to put it at, its SHA-1 and size, and a reminder that ROMs are not included in the repo:

| Build | ROM needed | SHA-1 | Size |
| --- | --- | --- | --- |
| every build and segment | `lst/nhl95.bin` | `09e87b076aa4cd6f057a1d65bb50fd889b509b44` | 2097152 bytes |

`npm run assets` runs only this step. `npm run extractassets` still forces a fresh extraction. The npm scripts set `NHL_PREBUILD_DONE=1` after the step so the batch file does not repeat it; `tools/verify_all.sh` runs the step with Linux node and sets the same variable for wine (there is no node under wine).

`tools/fixopcodes.js` is needed after every build: EA's compiler emitted `cmp #imm` as `CMP` where SNASM emits `CMPI`, and the script patches those opcodes from the listing.

The batch files run `assembler\Assembler.exe` (SNASM68K) on Windows. Under Linux the same command line runs with Wine from `src/` (see `tools/build_ref.sh` for the command).

## Tools

- `tools/scan_cleanup.py` counts what is left: disassembler noise in comments, raw RAM / hardware / save RAM / ROM addresses in code, raw struct displacements, and IDA names. `--list` prints each hit.
- `tools/strip_noise.py` removes disassembler noise from comments (never code) and records each removed IDA name in `docs/name_map.csv`.
- `tools/file_origins.py --ref94 <NHL94Genesis> --ref93 <NHLPA93Genesis>` writes `docs/FILE_ORIGINS.md` and `docs/function_origins.csv`: for every 95 file and every label in it, the 94 file it came from (or new in 95). Run a full build first; it reads `output/nhl95 .lst`.
- `tools/fingerprint_map.py`, `verify_segmap.py`, `apply_segmap.py`, `segmap95.json` and `SEGMAP95.md` made the first split of the ROM into 94 files, before any segment was transcribed. They are kept for history. Their output (placeholder files, provisional orgs, the flat `_01` / `_02` file names) is out of date: the include lists in `src/` and `SEGMENT_AGENT.md` are current. `docs/name_map.csv` keeps those old names only in `old_name` where a label was renamed; its `module` column is the current path (`engine/logic95`).

## Segment notes

`SEGMENT_AGENT.md` has the rules the segments were transcribed by and the ROM map: one row per segment with its range, its 94 file and what is in it. `PROMPT.md` is the prompt that was used for each segment session.

## AI assistance

This project is AI-assisted. The work is directed by a strict ruleset and curated by hand, with the aim of producing correctly labelled and commented code that matches the spirit of what the original source code would have been. We can't guarantee it's perfect, and ultimately this will always be a work in progress. If you see something that needs fixing, raise an issue, or even better, raise a PR.

## Credits and derivative works

Thanks to chaos, StaticEck, McMarkis and Drezz for their help with the disassembly.

Special thanks to smozoma and kingraph, whose past contributions to the NHL modding community made this work easier.

This project is the result of my work (abdulahmad) and the work of the people credited above. If you build anything from it, including mods, ROM or EXE hacks, ports, released forks, tools, or any other derivative work, you must credit us:

- Put the credit in your repo's README, near the top and not buried in a footer, and in the notes of every release you publish, including any text file shipped inside a release archive.
- Name me (abdulahmad) and link to this repository.
- Name everyone credited here: chaos, StaticEck, McMarkis (Mhopkinsinc) and Drezz, with special thanks to smozoma and kingraph.
- If you only use part of this repo (docs, a tool, labels, a file format description), the credit still applies.
- If you are unsure, over-credit.

Credit is the condition for using this work. Please do not release a derivative without it.
