# NHL 95 Genesis

Bitwise rebuild of NHL 95 for the Sega Genesis. Every segment is matched: the full build is byte for byte the retail ROM (SHA-1 `09e87b076aa4cd6f057a1d65bb50fd889b509b44`), and each segment also builds and verifies on its own.

The reference ROM is `lst/nhl95.bin` (2 MB). It is what every build is compared with. Do not use a different ROM. The listing it was transcribed from is `lst/nhl95.bin.lst`, an IDA LST in ASM68K / MRI mode with no address column (`loc_` / `sub_` names are the address).

The source follows [NHL94Genesis](https://github.com/abdulahmad/NHL94Genesis): its file names, routine names, RAM names and comments, with [NHLPA93Genesis](https://github.com/abdulahmad/NHLPA93Genesis) where 94 does not have the routine. A comment `;95: ...` marks a 94 routine 95 changed; `95 only.` marks a routine 94 does not have.

## Layout

| Path | What it is |
| --- | --- |
| `src/nhl95.asm` | Top level of the full build: the equates, `org 0`, then every file in ROM order with its start address. |
| `src/<file>95.asm` | Code and data, one file per NHL94Genesis file (`hockey94.asm` -> `hockey95.asm`), all in `src/` as in 94. A 94 file that 95 splits into pieces separated by other files is numbered `_01`, `_02`, ... in ROM order. A short run of one 94 file between pieces of another is part of the file around it, after a banner naming its 94 file. 95-only systems have their own file (`season95`, `trade95`, `create95`, `awards95`, `schedule95`); the 95 sound driver is the head of `sound95_01`. `docs/FILE_ORIGINS.md` gives the 94 file of every routine. |
| `src/sega/` | Sega's cartridge header (`SegaIDTable95.asm`, $100-$1FF) and power-on code (`SegaInit.asm`, $200-$2F9), included by `main95.asm`. |
| `src/ram95.asm` | The RAM map, Z80 RAM and the save RAM offsets (`SR...`). Equates only. |
| `src/stubinc/` | `ports.inc` (IO and VDP ports) and `equals.inc` (VDP status bits). Equates only. |
| `src/macros/genesis.mac` | The `VmInc`, `String`, `HEX2`, `Player` and `PIX` macros. |
| `src/<file>_stub.asm` | One per segment: the segment org, the equates, equates for the outside addresses the segment uses, then `include <file>.asm`. A stub builds and verifies one segment by itself. |
| `docs/name_map.csv` | Every label: address, current name, the IDA name, the old name if it was renamed, and the file. |
| `docs/WHY_95_MOVED.md` | Why 95 reordered 94's routines (SNES banking, locality and re-filing weighed against the code), and the subsystem files the 95 source probably had. |

Files included by `nhl95.asm` have no `org`. Assembler paths are relative to `src/` (`incbin ..\Extracted\...`). Graphics and sound are incbins of `Extracted/`.

## Build

The graphics and sound are not in the repo. Extract them from the reference ROM first:

    npm run extractassets

That writes `Extracted/` from `lst/nhl95.bin` with `extractAssets95.js`.

Full ROM builds assemble `src/nhl95.asm` with `build95.bat`. The listing is `output/nhl95 .lst`. The opcode-corrected output is `output/modified_nhl95.bin`.

| Script | Flags | Result |
| --- | --- | --- |
| `npm run build:retail` | `rev=0`, `checksum=1` | Retail, then a byte compare to `lst/nhl95.bin`. |
| `npm run build:dev` | `rev=0`, `checksum=0` | No validation and no retail verify. Use this while editing. |

`build:dev` (`checksum=0`): `RegionOK` skips `jsr ValidationRoutine` (3 `nop`s instead) and the header checksum is 0, so changed code still boots. With `checksum=1` the validation routine sums the ROM, and any change turns the screen red.

Segment builds: `npm run seg:<file>` runs `buildseg.bat <file>` (assembles `src/<file>_stub.asm`), `fixopcodes.js`, then `verifySegment.js <file> <org> lst/nhl95.bin`, which overlays the segment on the reference ROM and compares. A MATCH of 0 bytes is a failure.

`fixopcodes.js` is needed after every build: EA's compiler emitted `cmp #imm` as `CMP` where SNASM emits `CMPI`, and the script patches those opcodes from the listing.

The batch files run `assembler\Assembler.exe` (SNASM68K) on Windows. Under Linux the same command line runs with Wine from `src/` (see `tools/build_ref.sh` for the command).

## Tools

- `tools/scan_cleanup.py` counts what is left: disassembler noise in comments, raw RAM / hardware / save RAM / ROM addresses in code, raw struct displacements, and IDA names. `--list` prints each hit.
- `tools/strip_noise.py` removes disassembler noise from comments (never code) and records each removed IDA name in `docs/name_map.csv`.
- `tools/file_origins.py --ref94 <NHL94Genesis> --ref93 <NHLPA93Genesis>` writes `docs/FILE_ORIGINS.md` and `docs/function_origins.csv`: for every 95 file and every label in it, the 94 file it came from (or new in 95). Run a full build first; it reads `output/nhl95 .lst`.
- `tools/fingerprint_map.py`, `verify_segmap.py`, `apply_segmap.py`, `segmap95.json` and `SEGMAP95.md` made the first split of the ROM into 94 files, before any segment was transcribed. They are kept for history. Their output (placeholder files, provisional orgs) is out of date: the include list in `src/nhl95.asm` and `SEGMENT_AGENT.md` are current.

## Segment notes

`SEGMENT_AGENT.md` has the rules the segments were transcribed by and the ROM map: one row per segment with its range, its 94 file and what is in it. `PROMPT.md` is the prompt that was used for each segment session.
