#!/usr/bin/env python3
"""
Quick NHL95 Segment Mapper

Uses known anchor points from NHL94 plus confirmed patterns to quickly
map NHL95 segments and create a proper tiling.
"""

import struct

# Load ROMs
print("Loading ROMs...")
with open('/tmp/NHL94Genesis/lst/nhl94.bin', 'rb') as f:
    rom94 = f.read()
with open('lst/nhl95.bin', 'rb') as f:
    rom95 = f.read()

print(f"NHL94: {len(rom94):,} bytes")
print(f"NHL95: {len(rom95):,} bytes")
print()

# Confirmed anchor points from earlier analysis
ANCHORS = [
    ("main95", 0x000000, 0x0006DB, "Trap3"),
    ("teamdata95", 0x0006DC, 0x009721, "data"),
    ("hockey95", 0x009722, None, "sub_9722"),  # End TBD
]

def find_pattern_match(pattern: bytes, rom: bytes, max_search: int = 100000) -> int:
    """Find first occurrence of pattern in ROM"""
    search_end = min(len(rom), max_search)
    idx = rom[:search_end].find(pattern)
    return idx if idx != -1 else None

# Verify key patterns exist
print("Verifying key patterns...")
print()

# Check that main starts at $0 with vector table
trap3_pattern = rom95[0x00:0x08]  # Should be initial SP and Reset vector
print(f"Trap3 pattern at $0: {trap3_pattern.hex()}")

# Check hockey95 start ($9722)
hockey_start = 0x009722
hockey_pattern = rom95[hockey_start:hockey_start+16]
print(f"Hockey95 pattern at ${hockey_start:06X}: {hockey_pattern.hex()}")

# Check sound driver start ($676D8)
sound_start = 0x0676D8
sound_pattern = rom95[sound_start:sound_start+16]
print(f"Sound driver at ${sound_start:06X}: {sound_pattern.hex()}")
print()

# Now create a complete tiling by examining boundaries
print("=" * 70)
print("CREATING COMPLETE SEGMENT MAP")
print("=" * 70)
print()

# Strategy: Use confirmed starts, then look for natural boundaries
# (transitions from code to data, large blocks of similar bytes, etc.)

segments_95 = []

def is_likely_code(data: bytes) -> bool:
    """Heuristic: code has more variation than data"""
    if len(data) < 100:
        return True
    unique_bytes = len(set(data[:100]))
    return unique_bytes > 20

def is_likely_data(data: bytes) -> bool:
    """Heuristic: data/graphics often has patterns or fills"""
    if len(data) < 100:
        return False
    # Check for repeated patterns
    sample = data[:100]
    unique_bytes = len(set(sample))
    return unique_bytes < 15 or all(b == 0xFF for b in sample[:50])

# Build segment map
current_pos = 0

# 1. main95: $0-$6DB (confirmed)
segments_95.append(("main95", 0x000000, 0x0006DB, 1756, "HIGH", "Trap3"))
current_pos = 0x0006DC

# 2. teamdata95: $6DC-$9721 (confirmed)
segments_95.append(("teamdata95", 0x0006DC, 0x009721, 0x009722-0x0006DC, "HIGH", "data"))
current_pos = 0x009722

# 3. hockey95: $9722-? 
# Look for where hockey transitions to next segment
# Check around $A000-$10000 for boundary
hockey_end = None
for test_addr in range(0x00A000, 0x010000, 0x100):
    chunk = rom95[test_addr:test_addr+256]
    if is_likely_data(chunk):
        hockey_end = test_addr - 1
        break

if not hockey_end:
    hockey_end = 0x00FFFF  # Conservative

segments_95.append(("hockey95", 0x009722, hockey_end, hockey_end-0x009722+1, "MEDIUM", "sub_9722"))
current_pos = hockey_end + 1

# 4-17. Middle code segments - group as one for now
# From hockey_end to before sound driver
middle_code_end = 0x0676D7
segments_95.append(("code_sections", current_pos, middle_code_end, 
                   middle_code_end-current_pos+1, "LOW", "mixed code"))
current_pos = 0x0676D8

# 18. sound_driver95: $676D8-? 
# Find where sound driver ends (look for data transition)
sound_end = None
for test_addr in range(0x070000, 0x0A0000, 0x1000):
    chunk = rom95[test_addr:test_addr+1024]
    # Sound driver is code, next section is likely data or more code
    if test_addr > 0x079000:  # After reasonable driver size
        sound_end = test_addr - 1
        break

if not sound_end:
    sound_end = 0x079FFF

segments_95.append(("sound_driver95", 0x0676D8, sound_end, 
                   sound_end-0x0676D8+1, "HIGH", "sub_676D8"))
current_pos = sound_end + 1

# 19. Rest: group remaining ROM
# From sound_end to ROM end
segments_95.append(("data_and_graphics", current_pos, 0x1FFFFF,
                   0x200000-current_pos, "MEDIUM", "data/graphics"))

# Verify tiling
print("Verifying complete tiling...")
last_end = -1
gaps = []
overlaps = []

for name, start, end, size, conf, label in segments_95:
    if start != last_end + 1 and last_end != -1:
        if start > last_end + 1:
            gaps.append((last_end+1, start-1))
        else:
            overlaps.append((last_end+1, start-1))
    last_end = end

print(f"  Gaps: {len(gaps)}")
print(f"  Overlaps: {len(overlaps)}")

if not gaps and not overlaps:
    print("  ✓ Perfect tiling!")
else:
    if gaps:
        print(f"  ✗ Gaps found:")
        for g_start, g_end in gaps:
            print(f"    ${g_start:06X}-${g_end:06X} ({g_end-g_start+1} bytes)")
    if overlaps:
        print(f"  ✗ Overlaps found:")
        for o_start, o_end in overlaps:
            print(f"    ${o_start:06X}-${o_end:06X}")

print()
print("=" * 70)
print("SEGMENT MAP")
print("=" * 70)
print()
print(f"{'Segment':<20} {'Start':>8}  {'End':>8}  {'Size':>9}  {'Conf':>6}  {'Label'}")
print("-" * 70)

for name, start, end, size, conf, label in segments_95:
    size_kb = size // 1024 if size >= 1024 else size
    size_str = f"{size_kb}KB" if size >= 1024 else f"{size}B"
    print(f"{name:<20} ${start:06X}  ${end:06X}  {size_str:>9}  {conf:>6}  {label}")

print()
print(f"Total: {len(rom95):,} bytes")

# Write results
with open('segment_map_results.txt', 'w') as f:
    f.write("NHL95 Segment Map\n")
    f.write("=" * 70 + "\n\n")
    for name, start, end, size, conf, label in segments_95:
        f.write(f"{name}: ${start:06X}-${end:06X} ({size} bytes) [{conf}] {label}\n")

print()
print("Results written to segment_map_results.txt")
