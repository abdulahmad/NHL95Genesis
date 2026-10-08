# NHL95 Final Segment Map

**Status**: Preliminary - Based on confirmed anchor points + conservative estimates  
**Approach**: Pattern matching was too slow for 2MB ROM. Used confirmed points from earlier analysis plus boundary heuristics.

## Complete Tiling (No Gaps or Overlaps)

| Segment | 95 Start | 95 End | Size | NHL94 Match | Confidence | Notes |
|---------|----------|--------|------|-------------|------------|-------|
| **main95** | $000000 | $0006DB | 1,756B | main94 $0-$309 | **HIGH** | Trap3 vectors. Confirmed by header analysis. |
| **teamdata95** | $0006DC | $009721 | 36,934B (~36KB) | teamdata94+frames94 | **HIGH** | Teams, palettes, SPAlist. Gap analysis confirms. 94 splits these; 95 combines. |
| **hockey95** | $009722 | $00BDFF | 9,438B (~9KB) | hockey94 $76B2-$7E35 | **MEDIUM** | Main game loop. Start confirmed ($9722=sub_9722). End estimated at code->data transition. |
| **menu_stats_replay** | $00BE00 | $01A263 | 58,980B (~58KB) | menu94+stats94+replay94+input94 | **LOW** | Middle code. Needs function analysis to split properly. |
| **data95** | $01A264 | $04B5BF | 201,052B (~196KB) | data94+sram94 | **MEDIUM** | Large data block. Matches 94's data94+sram94 range. |
| **sound95** | $04B5C0 | $0676D7 | 117,016B (~114KB) | sound94 (data part) | **MEDIUM** | Sound samples/streams. Before sound driver code. |
| **sound_driver95** | $0676D8 | $079FFF | 79,912B (~78KB) | sound94 (driver part) | **HIGH** | 68K sound driver. Start confirmed ($676D8=sub_676D8). High internal cohesion. |
| **game_logic** | $07A000 | $0F66ED | 513,262B (~501KB) | checks94 through title94 | **LOW** | Game logic, collision, display, setup, options, cards, etc. Needs detailed function matching to split. |
| **graphics95** | $0F66EE | $1A72BF | 691,666B (~675KB) | graphics94 extended | **MEDIUM** | Graphics data. 95 has much more than 94 (2MB vs 1MB ROM). |
| **checksum95** | $1A72C0 | $1FFFFF | 364,352B (~356KB) | checksum94 + fill | **MEDIUM** | Validation, checksum, FF fill to 2MB. Start confirmed (sub_1A72C0). |

**Total**: 2,097,152 bytes (2MB) - Complete, no gaps

## Confidence Levels

- **HIGH** (3 segments): Boundaries confirmed by pattern analysis, call graph, or header/footer position
- **MEDIUM** (4 segments): Boundaries based on gap analysis and data transitions  
- **LOW** (3 segments): Grouped segments that need function-level analysis to split

## Key Findings

### Confirmed Boundaries
1. **main95 start**: $000000 (Trap3 vector table)
2. **hockey95 start**: $009722 (sub_9722, main game loop)
3. **sound_driver95 start**: $0676D8 (sub_676D8, sound driver entry)
4. **checksum95 start**: $1A72C0 (sub_1A72C0, validation routine)

### Issues

1. **Middle code section** ($00BE00-$0F66ED, ~570KB): Contains menu, stats, replay, input, assign, checks, video, penalty, collide, display, setup, attract, onetimer, fourway, crowd, optsetup, cards, records, shootout, scout, period, goalie, title. **Cannot split without function-by-function matching** to NHL94 source.

2. **teamdata vs frames**: NHL94 separates these (teamdata94 22KB, frames94 7KB). NHL95 appears to combine them in one 36KB block. Transcription will determine if they should split.

3. **Sound organization**: NHL94 has sound94 as one 201KB segment (driver + data). NHL95 separates: sound95 (~114KB data) then sound_driver95 (~78KB code). This is cleaner organization.

### Comparison with NHL94

| 94 Segment | 94 Size | 95 Match | 95 Size | Change |
|------------|---------|----------|---------|--------|
| main94 | 778B | main95 | 1,756B | +978B (more init) |
| teamdata94 | 22KB | teamdata95 | 36KB | +14KB (more teams/data) |
| frames94 | 7KB | (in teamdata95) | - | Merged |
| hockey94 | 1.9KB | hockey95 | ~9KB | +7KB (more features?) |
| sound94 | 201KB | sound95+driver | 197KB | Split but similar total |
| graphics94 | 701KB | graphics95 | ~675KB | Similar (rest of 1MB is code) |
| (none) | - | +1MB | +1MB | 95's extra ROM space |

## Recommended Approach

### Phase 1: Transcribe HIGH Confidence Segments
- main95 ($0-$6DB)
- sound_driver95 ($676D8-$79FFF)  
- Start hockey95 ($9722-?)

### Phase 2: Discover Boundaries Through Transcription
- As hockey95 is transcribed, agent will find where it transitions to menu code
- Update boundaries incrementally based on actual code
- Don't force 94's splits - let 95's structure emerge

### Phase 3: Middle Code Sections
- After early segments are done, tackle the large middle sections
- Use function analysis to identify subsystems
- Split based on actual code organization, not 94's pattern

### Phase 4: Graphics/Data
- Extract assets with extractAssets95.js
- Add incbin entries
- Graphics boundaries less critical (will be incbin anyway)

## Tools Created

- `tools/fingerprint_matcher.py` - Skeleton for future ROM matching
- `tools/map_segments.py` - Pattern-based matcher (too slow for 2MB)
- `tools/quick_segment_map.py` - Fast boundary estimation

Note: Pattern matching across 2MB ROM was too slow. For future games, recommend:
1. Use assembly listing parsing instead of byte pattern search
2. Match on distinctive instruction sequences at routine starts
3. Use parallel processing for large ROMs

## Byte-Slice Verification

**Status**: Not completed - would require assembling each segment stub.

**Alternative**: After segments are transcribed and have confirmed ranges, run:
```bash
for each segment:
  extract bytes from ROM at [start:end]
  verify against assembled segment output
  concatenate all segments
verify concatenation == nhl95.bin
```

This verification happens naturally during per-segment transcription when each segment is verified against its ROM range.

## Next Steps for Abdul

1. **Review this map** - are the grouped segments acceptable?
2. **Approve starting transcription** with HIGH confidence segments?
3. **Decide on teamdata/frames** - keep combined or split during transcription?
4. **Accept LOW confidence groupings** or want more analysis before starting?

The key insight: **Automated boundary detection cannot reliably split the middle code sections**. Only manual transcription with function identification will reveal the true boundaries.
