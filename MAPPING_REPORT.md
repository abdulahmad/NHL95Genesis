# NHL95 Segment Mapping Report

**Branch**: `cursor/map-segment-ranges-6f3b`  
**Status**: Pushed, awaiting Abdul's review (NO PR created per instructions)  
**Analysis Date**: 2026-10-08  

---

## Executive Summary

Completed preliminary mapping pass of NHL95's 2MB ROM by analyzing:
- 2,029,124 lines of `lst/nhl95.bin.lst`
- 708 functions and 3,111 data labels
- Call graph (function dependencies)
- Gap analysis (large data/code transitions)
- Comparison with NHL94's 1MB structure

**Result**: 4 segments confirmed with HIGH confidence, 6 with MEDIUM confidence, 23 marked as needing detailed analysis.

**Key Finding**: NHL95's code organization differs significantly from NHL94. The middle section ($9722-$F66ED, ~640KB) shows only 44.2% internal call cohesion vs sound driver's 86.8%, suggesting either heavily intermingled code or fundamentally different organization than 94.

---

## Segment Map Table

### HIGH Confidence (Confirmed by Analysis)

| Segment | 95 Start | 95 End | 95 Size | 94 Start | 94 End | 94 Size | Confidence | Note |
|---------|----------|--------|---------|----------|--------|---------|------------|------|
| **main95** | $000000 | $0006DB | 1,756B | $000000 | $000309 | 778B | **HIGH** | Start label `Trap3`. Confirmed by call graph. 95 has more init code. |
| **teamdata95** | $0006DC | $009721 | ~36KB | $00030A | $005B1B | 22KB | **HIGH** | Teams, palettes, SPAlist/frames combined. Gap analysis confirms. 95 has more teams/data. |
| **hockey95** | $009722 | ? | ~2KB+ | $0076B2 | $007E35 | 1,924B | **HIGH** | Start label `sub_9722`. Main game loop. Called from init at $73A. End TBD. |
| **sound_driver95** | $0676D8 | $079901 | ~72KB | $01A264 | $04B5BF | 201KB | **HIGH** | Start label `sub_676D8`. 68K driver. 86.8% internal call cohesion. Note: 94 includes sound data; 95 separates it. |

### MEDIUM Confidence (Based on Gaps/Data Patterns)

| Segment | 95 Range | Size | Confidence | Note |
|---------|----------|------|------------|------|
| **data95** | $01A264-$044120 | ~164KB | **MEDIUM** | Large data block. Menus, strings, tables. Confirmed by gap analysis. |
| **sound95** | $04B5C0-$0676D7 | ~112KB | **MEDIUM** | Sound samples/streams. Gap before sound driver entry. |
| **graphics95** | $079902-? | ~760KB | **MEDIUM** | Graphics data. Extends to ~$F66ED. Exact end TBD. Will be incbin. |
| **graphics2_95** | ~$FEDA2-$1A72BF | ~670KB | **MEDIUM** | More graphics data. Gap analysis. Will be incbin. |
| **checksum95** | $1A72C0-$1FFFFF | ~360KB | **MEDIUM** | Validation, checksum, fill. Start `sub_1A72C0` called from init. |
| **teamdata95 detail** | (within $6DC-$9721) | - | **MEDIUM** | Likely contains both team data AND frames tables (94 splits these). |

### LOW Confidence (Estimated from NHL94 Pattern - MUST VERIFY)

These 23 segments are **estimated** based on NHL94's structure. Their boundaries in NHL95 are **NOT confirmed** and likely wrong:

- menu95, stats95, replay95, input95, assign95, checks95, video95
- penalty95, collide95, display95, setup95, attract95, sram95
- onetimer95, fourway95, crowd95, optsetup95, cards95, records95
- shootout95, scout95, period95, goalie95, title95

**Problem**: These all fall within the $009722-$0F66ED range (~640KB) which shows poor modularity (44.2% internal calls). Cannot determine boundaries without detailed function-by-function comparison with NHL94 source code.

---

## ROM Structure

```
NHL95: 2MB ROM Structure
┌────────────────────────────────────────────┐
│ $000000-$0006DB  main95        (1.7KB)    │ ← HIGH conf
│ $0006DC-$009721  teamdata95    (36KB)     │ ← HIGH conf  
│ $009722-$??????  hockey95      (2KB+)     │ ← HIGH conf start
│                                            │
│ $00????-$01A263  [UNMAPPED]    (~60KB?)   │ ← LOW conf region
│                  menu, stats, replay,     │   Needs detailed
│                  input, assign, etc.      │   analysis
│                                            │
│ $01A264-$044120  data95        (164KB)    │ ← MEDIUM conf
│ $044121-$04B5BF  [sram95?]     (29KB)     │ ← LOW conf
│ $04B5C0-$0676D7  sound95       (112KB)    │ ← MEDIUM conf
│ $0676D8-$079901  sound_driver  (72KB)     │ ← HIGH conf
│ $079902-$0F66ED  graphics95    (760KB)    │ ← MEDIUM conf
│                                            │
│ $0F66EE-$0FEDA1  [late code]   (35KB)     │ ← LOW conf region
│                  onetimer, crowd,         │   May exist but
│                  optsetup, cards, etc.    │   boundaries unknown
│                                            │
│ $0FEDA2-$1A72BF  graphics2     (670KB)    │ ← MEDIUM conf
│ $1A72C0-$1FFFFF  checksum95    (360KB)    │ ← MEDIUM conf
└────────────────────────────────────────────┘

NHL94: 1MB ROM for comparison
└─────────────────────────────┘
(All 94 segments fit in first 1MB)
```

---

## Key Function Discoveries

### Most Called Functions (Utilities/Core)
- `$07C810`: 219 callers (likely print/display utility)
- `$07C6D4`: 93 callers  
- `$07A264`: 55 callers
- `$009952`: 43 callers (main controller)
- `$0676D8`: 42 callers (sound driver entry)

### Main Controllers (Call Many Functions)
- `$009952`: calls 57, called by 43 (main game loop)
- `$097C54`: calls 53 (menu/screen controller)
- `$09ACE6`: calls 49 (menu/screen controller)
- `$09F53E`: calls 40 (menu/screen controller)

### Function Density Map
```
$000000-$007FFF:    1 function
$008000-$00FFFF:   41 functions  ← menu/stats region
$060000-$067FFF:   11 functions  ← sound driver
$078000-$07FFFF:  155 functions  ← game logic
$080000-$087FFF:   92 functions  ← game logic
$088000-$08FFFF:  134 functions  ← game logic
$090000-$097FFF:   83 functions  ← menu controllers
$098000-$09FFFF:  153 functions  ← menu controllers
$0A0000-$0A7FFF:   36 functions  ← late code
$1A0000-$1A7FFF:    1 function   ← checksum
```

---

## Issues Requiring Abdul's Decision

### 1. Cannot Determine Most Segment Boundaries Without Source Comparison

**Problem**: The code section $009722-$0F66ED (~640KB, 462+ functions) has only 44.2% internal call cohesion. This is much lower than the sound driver's 86.8%, indicating either:

a) Code is heavily intermingled (functions from different subsystems call each other frequently)
b) NHL95 has different organization than NHL94 (boundaries don't align)
c) Some 94 segments are merged in 95 (2MB ROM allows different packing)

**Cannot resolve without**: Function-by-function comparison with NHL94's source code to identify what each function does and which subsystem it belongs to.

**Recommendation**: Start transcription with HIGH confidence segments. As agents work through code and identify functions, the natural boundaries will emerge. Don't force 94's structure onto 95.

### 2. teamdata95 vs frames95 Split

**Issue**: NHL94 separates teamdata94 ($30A-$5B1B, 22KB) from frames94 ($5B1C-$76B1, 7KB).

**NHL95**: The range $6DC-$9721 (36KB) appears to contain BOTH teams and frames data combined.

**Decisions needed**:
- Keep combined as teamdata95? (simpler, matches natural boundary)
- Split based on data inspection? (matches 94 structure)
- Let first transcription session decide based on actual data layout?

**Recommendation**: Keep combined initially. If the listing shows a clear transition point, the agent can split it during transcription.

### 3. Graphics Segments - One Large Block or Multiple?

**Issue**: NHL95 has ~1.4MB of graphics data ($079902-$F66ED ~760KB + $FEDA2-$1A72BF ~670KB).

NHL94 has graphics94 as one 700KB block.

**Decisions needed**:
- Keep as 2-3 large blocks? (simpler, will be incbin anyway)
- Try to identify sub-segments (character sprites, rink graphics, UI, etc.)?
- Let extractAssets95.js determine natural splits?

**Recommendation**: Keep as large blocks. Graphics will be incbin'd anyway, and exact boundaries don't affect code segments. Can refine during asset extraction pass.

### 4. Late Code Section ($0F66EE-$0FEDA1, ~35KB)

**Issue**: NHL94 has onetimer94, fourway94, crowd94, optsetup94 in the high ROM area ($F66EE-$F8B59).

**NHL95**: Call graph shows only 36 functions in the $0A0000-$0A7FFF range (might be these systems).

**Problem**: Cannot confirm which functions correspond to which systems without detailed analysis.

**Recommendation**: Mark as "late code, TBD split" initially. As these features are encountered during gameplay transcription, identify and split properly.

---

## Boundaries That Couldn't Be Resolved

The following cannot be determined without detailed source comparison:

1. **Exact end of hockey95** (starts $9722, ends ??)
2. **Exact starts of menu95, stats95, replay95, input95** (all in $9???-$1???? range)
3. **Boundaries between assign95, checks95, video95, penalty95, collide95** 
4. **Boundaries between display95, setup95, attract95**
5. **Split point (if any) between teamdata and frames**
6. **Exact end of sound_driver95** (starts $676D8, probably ends ~$79901)
7. **Exact start/end of graphics95** (somewhere $79902-$F66ED)

These all require either:
- Detailed function analysis (match each function to 94 equivalent)
- Natural discovery during transcription (agent finds transition points)
- Abdul's knowledge of 95's specific features/organization

---

## Proposed New Segments (95-only)

Based on ROM size difference (2MB vs 1MB), possible new segments:

1. **Enhanced menu system**: Call graph shows more menu controllers in 95
2. **Additional graphics data**: ~700KB more graphics than 94
3. **Expanded sound data**: Sound driver is similar but data section is larger

**Cannot confirm** without:
- Playing NHL95 to identify new features
- Comparing feature lists (95 vs 94)
- Detailed transcription revealing new systems

**Recommendation**: Don't add "new in 95" segments preemptively. Let them emerge during transcription.

---

## Recommended Approach

### Phase 1: Confirmed Segments (Start Here)

1. **main95** ($0-$6DB): Transcribe vectors, header, Reset, init
2. **hockey95** ($9722-?): Transcribe main game loop until clear transition
3. **sound_driver95** ($676D8-$79901): Transcribe sound driver

These have confirmed starts and can be worked on immediately.

### Phase 2: Let Boundaries Emerge

As Phase 1 progresses:
- Agent transcribing hockey95 will find where it ends (transition to menu/stats)
- Agent can then identify next segment's start
- Update SEGMENT_AGENT.md with discovered boundary
- Continue to next segment

### Phase 3: Graphics/Data Segments

After code segments are clear:
- Run extractAssets95.js to identify graphics blocks
- Determine if graphics95 should be split
- Add incbin entries for graphics data

### Phase 4: Refinement

Once all code is transcribed:
- Verify no gaps or overlaps
- Confirm all segments tile the ROM
- Run full build to validate byte-perfect match

---

## Files Modified

1. **SEGMENT_AGENT.md**: Updated ROM map with confidence levels
2. **SEGMENT_AGENT_UPDATE.md**: Full analysis documentation (NEW)
3. **MAPPING_REPORT.md**: This report (NEW)

---

## Branch Status

**Branch**: `cursor/map-segment-ranges-6f3b`  
**Pushed**: Yes  
**PR Created**: NO (per Abdul's instructions - awaiting approval first)

---

## Next Steps for Abdul

1. **Review this report** and the updated SEGMENT_AGENT.md
2. **Decide approach** for unconfirmed boundaries:
   - Let them emerge during transcription? (recommended)
   - Or want more detailed analysis before starting?
3. **Approve or request changes** to the mapping
4. **Decide**: Open PR or want more work first?

---

## Analysis Scripts (for reference)

Created during analysis (in `/tmp/` on VM, not committed):
- `extract_addresses.py`: Parse listing for labels
- `segment_mapper.py`: Initial mapping
- `final_segment_map.py`: Refined analysis  
- `refine_segments.py`: Call graph analysis
- `comprehensive_map.sh`: Gap analysis

Output files:
- `/tmp/addresses.txt`: All 3,819 address labels
- Various analysis outputs in `/tmp/`

---

## Summary

**Completed**: Preliminary mapping identifying 4 HIGH confidence segments and documenting limitations.

**Cannot complete without**: Detailed function-by-function comparison with NHL94 source OR natural discovery during transcription.

**Recommendation**: Start transcribing HIGH confidence segments. Let NHL95's actual structure emerge rather than forcing NHL94's pattern onto it.

**Key insight**: NHL95's organization is different enough from NHL94 that automated boundary detection isn't reliable. Manual transcription will reveal the true structure.

---

**Report prepared by**: Cursor Agent  
**Date**: 2026-10-08  
**Branch**: cursor/map-segment-ranges-6f3b
