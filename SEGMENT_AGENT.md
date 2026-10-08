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

The first unmatched ROM segment is the current segment. NHL95 is 2MB (vs 94's 1MB). Ranges marked with confidence level: **HIGH** = confirmed by analysis, **MEDIUM** = likely based on gaps, **LOW** = estimated from 94 pattern.

**Mapping Status**: Preliminary pass complete. HIGH confidence segments have confirmed orgs. Others need detailed function analysis to determine exact boundaries. See `SEGMENT_AGENT_UPDATE.md` for full analysis.

| File | Status | Org / Range | Confidence | Note |
|---|---|---|---|---|
| main95 | not matched | $0-$6DB (1,756 bytes) | **HIGH** | Start label `Trap3`. Vectors, header, Reset, SegaInit. Confirmed by call graph. |
| teamdata95 | not matched | $6DC-$9721 (~36KB) | **HIGH** | Teams, palettes, SPAlist/frames. Larger than 94 (28KB) due to more data. Confirmed by gap analysis. |
| ram95 | skipped | no org (equates only) | N/A | Equates only, no ROM bytes. Skipped by segment queue. RAM names added to `stubinc/ram_addrs.inc` as transcribed. Final consolidation pass after ROM segments complete. |
| hockey95 | not matched | $9722-? | **HIGH** | Start label `sub_9722` (main game loop). Called from init at $73A. End TBD - find where it transitions to next segment. |
| menu95 | not matched | org not confirmed | **LOW** | Estimated from 94. Needs function analysis to find actual boundary. |
| stats95 | not matched | org not confirmed | **LOW** | Estimated from 94. Needs function analysis. |
| replay95 | not matched | org not confirmed | **LOW** | Estimated from 94. Needs function analysis. |
| input95 | not matched | org not confirmed | **LOW** | Estimated from 94. Needs function analysis. |
| assign95 | not matched | org not confirmed | **LOW** | Estimated from 94. Needs function analysis. |
| checks95 | not matched | org not confirmed | **LOW** | Estimated from 94. Needs function analysis. |
| video95 | not matched | org not confirmed | **LOW** | Estimated from 94. Needs function analysis. |
| penalty95 | not matched | org not confirmed | **LOW** | Estimated from 94. Needs function analysis. |
| collide95 | not matched | org not confirmed | **LOW** | Estimated from 94. Needs function analysis. |
| display95 | not matched | org not confirmed | **LOW** | Estimated from 94. Needs function analysis. |
| setup95 | not matched | org not confirmed | **LOW** | Estimated from 94. Needs function analysis. |
| attract95 | not matched | org not confirmed | **LOW** | Estimated from 94. Needs function analysis. |
| data95 | not matched | $1A264-$44120 (~164KB) | **MEDIUM** | Large data block. Menus, strings, tables. Gap analysis. |
| sram95 | not matched | org not confirmed | **LOW** | Estimated from 94. Needs function analysis. |
| sound95 | not matched | $4B5C0-$676D7 (~112KB) | **MEDIUM** | Sound samples and streams. Gap before sound driver. |
| sound_driver95 | not matched | $676D8-$79901 (~72KB) | **HIGH** | Start label `sub_676D8`. 68K sound driver. 86.8% internal call cohesion. Confirmed by call graph. |
| graphics95 | not matched | $79902-? (large) | **MEDIUM** | Graphics data block. Exact end TBD (extends to ~$F66ED or beyond). Will be incbin. |
| onetimer95 | not matched | org not confirmed | **LOW** | Estimated from 94. Likely in late code section. |
| fourway95 | not matched | org not confirmed | **LOW** | Estimated from 94. Likely in late code section. |
| crowd95 | not matched | org not confirmed | **LOW** | Estimated from 94. Likely in late code section. |
| optsetup95 | not matched | org not confirmed | **LOW** | Estimated from 94. Likely in late code section. |
| cards95 | not matched | org not confirmed | **LOW** | Estimated from 94. Likely in late code section. |
| records95 | not matched | org not confirmed | **LOW** | Estimated from 94. Likely in late code section. |
| shootout95 | not matched | org not confirmed | **LOW** | Estimated from 94. Likely in late code section. |
| scout95 | not matched | org not confirmed | **LOW** | Estimated from 94. Likely in late code section. |
| period95 | not matched | org not confirmed | **LOW** | Estimated from 94. Likely in late code section. |
| goalie95 | not matched | org not confirmed | **LOW** | Estimated from 94. Likely in late code section. |
| title95 | not matched | org not confirmed | **LOW** | Estimated from 94. Likely in late code section. |
| graphics2_95 | not matched | ~$FEDA2-$1A72BF (~670KB) | **MEDIUM** | More graphics data. Gap analysis. Will be incbin. |
| checksum95 | not matched | $1A72C0-$1FFFFF (~360KB) | **MEDIUM** | Validation, checksum, fill. Start label `sub_1A72C0` called from init. |

**Note**: 95's code section ($9722-$F66ED, ~640KB) shows only 44.2% internal call cohesion vs sound driver's 86.8%. This suggests either heavily intermingled code or different organization than 94. Exact segment boundaries within this range need per-function analysis as transcription proceeds.

## New in 95

- Additional sound driver features (95 has more complex audio)
- Expanded graphics (2MB vs 1MB allows inline data vs 94's compression)
- Possible new menu/option screens (TBD during transcription)

Add new segments here as discovered during transcription. Do not add before confirming in listing.
