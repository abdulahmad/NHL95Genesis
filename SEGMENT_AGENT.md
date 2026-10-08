# NHL 95 segment agent

This file is the queue. Do not rewrite it as a whole file. Edit the current row in place. Do not append a history entry.

## Current segment

`main95`. Start label `Trap3` (the vector table at `$000000`). The confirmed org is `$0`. Confirm every org against `lst/nhl95.bin.lst` before the first verify. The 94 addresses are not 95 addresses.

RAM (`ram95`) is skipped by the segment queue. The queue processes ROM segments only. RAM names come from the code segments as they are transcribed, not as a separate first pass. After ROM segments are matched, RAM will be organized as a final consolidation pass.

The files in `src/nhl95.asm` are a starting map, not a confirmed split. Use https://github.com/abdulahmad/NHL94Genesis to decide where a segment starts and ends. Find the 94 routine that matches the 95 listing, then take the 95 range from the 95 listing, not from the 94 org. Split a placeholder when the 94 files are separate ranges here. Add a file when 95 has a system 94 does not have. Drop a placeholder when 95 has no matching code, and remove its include. Keep the includes in ROM order.

## Sources

- Listing: `lst/nhl95.bin.lst`. Open it. Do not disassemble `lst/nhl95.bin`. Do not write a disassembler.
- The listing is an IDA LST in ASM68K / MRI mode. It has no address column. A `loc_`, `sub_`, or `unk_` name is the address.
- Style source: the matching file in https://github.com/abdulahmad/NHL94Genesis. Use https://github.com/abdulahmad/NHLPA93Genesis only when 94 does not have the routine. A 94 name wins when the body is the same routine.
- Reference ROM: `lst/nhl95.bin`. It is 2 MB. Bytes and branch displacements come from it.
- `src/nhl95.asm` is the include list, in the 94 file order. Put the confirmed org on the include line in the session that matches the file.
- Stub includes: `src/stubinc/ports.inc`, `equals.inc`, `ram_addrs.inc`.

## Teams

Provisional until the listing confirms it. NHL 95 is the 1994-95 season, still 26 teams. Quebec is still the Nordiques. Winnipeg is still the Jets. Colorado and Phoenix are NHL 96. A 94 team index is not a 95 index until the listing confirms the order.

## Build

`buildseg.bat <name>` assembles `src/<name>_stub.asm`. The stub carries the org. A file included by `nhl95.asm` has no org.

`npm run seg:<name>` runs buildseg, then `fixopcodes.js` on `output/<name> .lst` and `output/<name>.bin`, then `verifySegment.js`. The assembler listing name has a space before `.lst`.

A MATCH of 0 bytes is a failure. The byte count must be the confirmed range.

After every matched segment, delete `output/nhl95.bin` and `output/modified_nhl95.bin`, run `npm run build:retail`, and compare `output/modified_nhl95.bin` to `lst/nhl95.bin`. The full build assembles `src/nhl95.asm`, so the listing stays `output/nhl95 .lst`. An old output can look like a pass. Only a compare made this session counts.

## Rules

- Write real `cmp`, `cmpi`, and `exg`. `fixopcodes.js` rewrites an EA `cmp.l` only. A real `cmpi.l #imm,d0` stays `0C80`. Do not write a compare as `dc.w`.
- Retail pad bytes win over the listing.
- A `printz` string can hide the next instruction. Write the instruction. Do not label a byte inside a string.
- If IDA splits one instruction into `dc.b` and `ori.b`, write the instruction.
- A 94 name is the field even when the 95 value differs. The equate gets the 95 value. The comment records the 94 value.
- Bit names replace the number. Keep the flag word the retail bytes use.
- `jsr name` only when SNASM emits the same opcode. `jsr (name).l` is `4EB9`. `jsr (name).w` is `4EB8`. `bsr.w` stays `bsr.w`.
- A global label ends local-label scope. A local that another routine or another file calls stays global. SNASM cannot reference another routine's local.
- SNASM symbols are case-insensitive. `setVram` and `setvram` are the same symbol.
- Keep each comment line under 200 characters. A longer line makes SNASM write an empty bin, and verify can then print MATCH for 0 bytes.
- Do not delete an asm file. Edit it in place.
- Data goes in the segment of the code that owns it. Sound data follows the sound driver. Graphics are incbins from `extractAssets95.js`, named for the asset, never for an IDA address. A map reference is `Label+8`. Team palettes are `.pal` incbins.
- A new ROM map row gets its include in `src/nhl95.asm` in ROM order in the same session.
- Do not copy a 94 name onto a 95 address because the low 16 bits match. Do not copy a 94 org.
- RAM names go in `stubinc/ram_addrs.inc` as you transcribe code segments. Add each new RAM name to that file when you first encounter it. Do not wait for a RAM consolidation pass.

## Naming

Name it in the session that transcribes it. Do not leave a cleanup pass.

- Match a function to the 94 routine when the body is the same. Keep the 94 name. Put the IDA name in one `;IDA:` comment on the definition, not on every line.
- If 94 already uses that name for a different routine, do not steal it. Name the new routine from what it does.
- A structure field is an expression (`SortCords+OldXpos`), not a new global.
- Do not leave `loc_`, `sub_`, `unk_`, `word_`, `byte_`, or `dword_` in code or in `ram_addrs.inc`.
- Bring over the 94 comment when the routine matches. If there is no comment, add one that says what it does.

## ROM map

The first unmatched ROM segment is the current segment. NHL95 is 2MB (vs 94's 1MB). Complete tiling with no gaps - see `SEGMENT_MAP_FINAL.md` for details.

**Mapping Status**: Conservative map based on confirmed anchor points. Grouped segments need function analysis to split properly.

| File | Status | Org / Range | Confidence | Note |
|---|---|---|---|---|
| main95 | not matched | $0-$6DB (1,756B) | **HIGH** | Start label `Trap3`. Vectors, header, Reset, SegaInit. |
| teamdata95 | not matched | $6DC-$9721 (36,934B) | **HIGH** | Teams, palettes, SPAlist. May include frames95. |
| frames95 | not matched | (in teamdata95?) | **LOW** | Boundary uncertain. May be merged. |
| ram95 | skipped | no org (equates only) | N/A | Equates only. RAM names added to `stubinc/ram_addrs.inc`. |
| hockey95 | not matched | $9722-? | **MEDIUM** | Start label `sub_9722`. End TBD. |
| menu95 | not matched | TBD (~$BE00+) | **LOW** | After hockey95. Boundary TBD. |
| stats95 | not matched | TBD | **LOW** | Boundary TBD. |
| replay95 | not matched | TBD | **LOW** | Boundary TBD. |
| input95 | not matched | TBD | **LOW** | Boundary TBD. |
| assign95 | not matched | TBD | **LOW** | Boundary TBD. |
| checks95 | not matched | TBD | **LOW** | Boundary TBD. |
| video95 | not matched | TBD | **LOW** | Boundary TBD. |
| penalty95 | not matched | TBD | **LOW** | Boundary TBD. |
| collide95 | not matched | TBD | **LOW** | Boundary TBD. |
| display95 | not matched | TBD | **LOW** | Boundary TBD. |
| setup95 | not matched | TBD | **LOW** | Boundary TBD. |
| attract95 | not matched | TBD | **LOW** | Boundary TBD. |
| data95 | not matched | $1A264-$4B5BF (201,052B) | **MEDIUM** | Large data block. May include sram95. |
| sram95 | not matched | (in data95?) | **LOW** | Boundary uncertain. May be merged. |
| sound95 | not matched | $4B5C0-$676D7 (117,016B) | **MEDIUM** | Sound samples/streams. Or split into sound_driver95. |
| sound_driver95 | not matched | $676D8-$79FFF (79,912B) | **HIGH** | Start label `sub_676D8`. 68K sound driver. Distinct from samples. |
| graphics95 | not matched | $7A000-$1A72BF (~1.06MB) | **MEDIUM** | Graphics data. Will be incbin. May contain late code segments. |
| onetimer95 | not matched | TBD (in graphics range?) | **LOW** | Boundary TBD. |
| fourway95 | not matched | TBD | **LOW** | Boundary TBD. |
| crowd95 | not matched | TBD | **LOW** | Boundary TBD. |
| optsetup95 | not matched | TBD | **LOW** | Boundary TBD. |
| cards95 | not matched | TBD | **LOW** | Boundary TBD. |
| records95 | not matched | TBD | **LOW** | Boundary TBD. |
| shootout95 | not matched | TBD | **LOW** | Boundary TBD. |
| scout95 | not matched | TBD | **LOW** | Boundary TBD. |
| period95 | not matched | TBD | **LOW** | Boundary TBD. |
| goalie95 | not matched | TBD | **LOW** | Boundary TBD. |
| title95 | not matched | TBD | **LOW** | Boundary TBD. |
| checksum95 | not matched | $1A72C0-$1FFFFF (364,352B) | **MEDIUM** | Start label `sub_1A72C0`. Validation, checksum, fill.

**Confirmed ranges**: main95, teamdata95, data95, sound95/sound_driver95, checksum95. **Uncertain boundaries**: Most middle code segments (menu95 through title95) have TBD boundaries. Conservative groupings in `SEGMENT_MAP_FINAL.md` show ~59KB for menu-input group, ~513KB for checks-title group. Function-level matching needed to split properly. **Strategy**: Transcribe HIGH/MEDIUM confidence segments first; boundaries for LOW segments will emerge during transcription.

## New in 95

- Additional sound driver features (95 has more complex audio)
- Expanded graphics (2MB vs 1MB allows inline data vs 94's compression)
- Possible new menu/option screens (TBD during transcription)

Add new segments here as discovered during transcription. Do not add before confirming in listing.
