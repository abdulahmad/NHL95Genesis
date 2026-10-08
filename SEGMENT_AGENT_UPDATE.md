# NHL 95 Segment Mapping - Analysis Results

## Confirmed Segments (HIGH Confidence)

Based on call graph analysis, gap analysis, and comparison with NHL94:

1. **main95**: `$000000-$0006DB` (1,756 bytes)
   - Start label: `Trap3`
   - Vectors, header, Reset, SegaInit
   - vs NHL94: 778 bytes (95 is larger due to additional initialization)

2. **teamdata95**: `$0006DC-$009721` (37,666 bytes, ~36KB)
   - Teams, palettes, SPAlist/frames tables  
   - vs NHL94: 28KB (teamdata + frames combined, 95 has more data)

3. **hockey95**: `$009722-$009FD1` (~2.1KB)
   - Start label: `sub_9722` (main game loop controller)
   - Called from ROM initialization at `$0000073A`
   - Calls 57 functions, called by 43 functions
   - vs NHL94: ~1.9KB

4. **sound_driver95**: `$0676D8-$079901` (~72KB)
   - Start label: `sub_676D8`
   - 68K sound driver code
   - 86.8% internal call cohesion (highly modular)
   - vs NHL94: similar size/structure

## Graphics/Data Blocks (MEDIUM Confidence)

Large data sections confirmed by gap analysis:

- **data95**: `$01A264-$044120` (~164KB) - Menus, strings, tables
- **sound95**: `$04B5C0-$0676D7` (~112KB) - Sound samples/streams
- **graphics95**: `$079902-$0F66ED` (~760KB) - Graphics data
- **graphics2_95**: `$0FEDA2-$1A72BF` (~670KB) - More graphics
- **checksum95**: `$1A72C0-$1FFFFF` (~360KB) - Validation, fill

## Unconfirmed Segments (LOW Confidence - NEEDS ANALYSIS)

The following segments from NHL94 likely exist in 95 but their exact boundaries are NOT confirmed:

- menu95, stats95, replay95, input95, assign95, checks95, video95
- penalty95, collide95, display95, setup95, attract95, sram95
- onetimer95, fourway95, crowd95, optsetup95, cards95, records95
- shootout95, scout95, period95, goalie95, title95

**Issue**: The code section `$009FD2-$0F66ED` contains ~640KB of mixed code/data but
internal analysis shows only 44.2% call cohesion (vs 86.8% for sound driver). This
suggests the code is heavily intermingled or the 94 segment boundaries don't apply
cleanly to 95's structure.

## ROM Structure Summary

- **Total ROM**: 2MB (`$000000-$1FFFFF`)
- **Code-heavy**: `$000000-$0FFFFF` (first 1MB) - 708 functions found
- **Data-heavy**: `$100000-$1FFFFF` (second 1MB) - mostly graphics
- **vs NHL94**: 94 is 1MB total, 95 is 2x size (mostly graphics expansion)

## Function Density

```
$000000-$007FFF:    1 function
$008000-$00FFFF:   41 functions
$060000-$067FFF:   11 functions (sound driver start)
$078000-$07FFFF:  155 functions
$080000-$087FFF:   92 functions
$088000-$08FFFF:  134 functions
$090000-$097FFF:   83 functions
$098000-$09FFFF:  153 functions
$0A0000-$0A7FFF:   36 functions
$1A0000-$1A7FFF:    1 function (checksum)
```

## Key Functions Identified

**Most Called (likely utility/core functions)**:
- `$07C810`: 219 callers (print/display utility)
- `$07C6D4`: 93 callers
- `$07A264`: 55 callers
- `$0676D8`: 42 callers (sound driver entry)
- `$009952`: 43 callers (main controller)

**Controllers (call many functions)**:
- `$009952`: calls 57 (main game loop)
- `$097C54`: calls 53 (menu/screen controller)
- `$09ACE6`: calls 49 (menu/screen controller)
- `$09F53E`: calls 40 (menu/screen controller)

## Recommendations

### For SEGMENT_AGENT.md Update:

1. **Confirm only HIGH confidence segments**:
   - main95: `$0` with end TBD (conservative: to `$6DB`)
   - teamdata95: start `$6DC`, end TBD
   - hockey95: start `$9722`, end TBD
   - sound_driver95: start `$676D8`, end TBD

2. **Leave other segments as "org not confirmed"** with note:
   "Requires function-by-function analysis. See mapping analysis for details."

3. **Graphics segments**:
   - Mark as data blocks, not code segments initially
   - Will be incbin anyway, exact boundaries less critical

### For Workflow:

1. Start transcribing confirmed segments (main95, hockey95, sound_driver95)
2. As agents work through code, they'll naturally discover where segments end
3. Update boundaries incrementally based on actual code structure
4. Don't force 94's structure onto 95 - let 95's natural boundaries emerge

## Analysis Limitations

- **Cannot determine exact boundaries** for intermingled code sections without
  detailed function-by-function comparison with NHL94 source
- **95 may have different organization** than 94 (2MB allows different packing)
- **Some 94 segments may be merged or split** in 95
- **Graphics expansion** (1MB+ more) suggests major data layout changes

## Files for Reference

Analysis scripts and detailed output saved in:
- `/tmp/extract_addresses.py`
- `/tmp/segment_mapper.py`
- `/tmp/final_segment_map.py`
- `/tmp/refine_segments.py`

Raw address list: `/tmp/addresses.txt`
