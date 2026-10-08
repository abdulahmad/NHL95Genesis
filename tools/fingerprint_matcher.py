#!/usr/bin/env python3
"""
NHL ROM Fingerprint Matcher

Matches routines between NHL94 and NHL95 by creating relocation-insensitive
fingerprints of code sequences and data structures.

Usage: python3 fingerprint_matcher.py <nhl94_rom> <nhl94_listing> <nhl95_rom> <nhl95_listing>
"""

import sys
import re
import struct
from collections import defaultdict
from typing import List, Tuple, Dict, Set

class Routine:
    """Represents a routine from a ROM"""
    def __init__(self, name: str, addr: int, segment: str):
        self.name = name
        self.addr = addr
        self.segment = segment
        self.bytes = b''
        self.fingerprint = []
        self.match_addr = None
        self.match_quality = 0.0
        
class Fingerprinter:
    """Creates relocation-insensitive fingerprints of M68K code"""
    
    # Opcodes that contain absolute addresses we need to mask
    ADDR_OPCODES = {
        0x4EB9,  # jsr (xxx).l
        0x4EF9,  # jmp (xxx).l
        0x23FC,  # move.l #imm,(xxx).l
        0x33FC,  # move.w #imm,(xxx).w
        # Add more as needed
    }
    
    def __init__(self, rom_data: bytes):
        self.rom = rom_data
        
    def extract_routine(self, addr: int, end_addr: int) -> bytes:
        """Extract bytes for a routine"""
        if addr >= len(self.rom) or end_addr > len(self.rom):
            return b''
        return self.rom[addr:end_addr]
    
    def create_fingerprint(self, code_bytes: bytes) -> List[int]:
        """
        Create a relocation-insensitive fingerprint from code bytes.
        Masks out absolute addresses while preserving opcode structure.
        """
        fingerprint = []
        i = 0
        
        while i < len(code_bytes) - 1:
            # Read potential opcode (big-endian)
            if i + 1 < len(code_bytes):
                opcode = (code_bytes[i] << 8) | code_bytes[i+1]
                
                # For instructions with absolute addresses, mask the address
                if self._is_absolute_addr_insn(opcode, code_bytes, i):
                    fingerprint.append(opcode)  # Keep opcode
                    fingerprint.append(0xFFFF)   # Mask address word 1
                    if i + 5 < len(code_bytes):
                        fingerprint.append(0xFFFF)   # Mask address word 2 if long
                    i += 6
                else:
                    # Keep as-is for other instructions
                    fingerprint.append(opcode)
                    i += 2
            else:
                break
                
        return fingerprint
    
    def _is_absolute_addr_insn(self, opcode: int, code_bytes: bytes, pos: int) -> bool:
        """Check if instruction uses absolute addressing"""
        # Simplified check - expand based on actual 68K instruction set
        if opcode in self.ADDR_OPCODES:
            return True
        
        # Check for move.l/move.w with absolute addressing
        if (opcode & 0xF000) in (0x1000, 0x2000, 0x3000):  # move instructions
            ea_mode = (opcode >> 3) & 0x7
            if ea_mode == 0x7:  # Absolute addressing
                return True
                
        return False
    
    def similarity(self, fp1: List[int], fp2: List[int]) -> float:
        """Calculate similarity between two fingerprints"""
        if not fp1 or not fp2:
            return 0.0
        
        # Simple n-gram similarity
        matches = sum(1 for a, b in zip(fp1, fp2) if a == b)
        return matches / max(len(fp1), len(fp2))

def parse_94_listing(listing_path: str) -> Dict[str, List[Routine]]:
    """Parse NHL94 listing to extract routines per segment"""
    print(f"Parsing {listing_path}...")
    
    # NHL94 segment boundaries from earlier analysis
    segments_94 = {
        "main94": (0x000000, 0x000309),
        "teamdata94": (0x00030A, 0x005B1B),
        "frames94": (0x005B1C, 0x0076B1),
        "hockey94": (0x0076B2, 0x007E35),
        "menu94": (0x007E36, 0x0080D3),
        "stats94": (0x0080D4, 0x009FCF),
        "replay94": (0x009FD0, 0x00B0E7),
        "input94": (0x00B0E8, 0x00C70F),
        "assign94": (0x00C710, 0x00D09B),
        "checks94": (0x00D09C, 0x010EDF),
        "video94": (0x010EE0, 0x011F2B),
        "penalty94": (0x011F2C, 0x0138AB),
        "collide94": (0x0138AC, 0x015D99),
        "display94": (0x015D9A, 0x0169F9),
        "setup94": (0x0169FA, 0x017A17),
        "attract94": (0x017A18, 0x017C71),
        "data94": (0x017C72, 0x01A04F),
        "sram94": (0x01A050, 0x01A263),
    }
    
    routines_by_segment = defaultdict(list)
    
    # Parse listing for routine labels
    with open(listing_path, 'r', errors='ignore') as f:
        for line in f:
            # Match function definitions
            match = re.match(r'^([A-Za-z_][A-Za-z0-9_]*):\s', line)
            if match:
                name = match.group(1)
                # Skip local labels
                if name.startswith('loc_') or name.startswith('locret_'):
                    continue
                    
                # Determine which segment this belongs to based on address
                # (would need to track addresses from listing)
                # For now, simplified extraction
                
    return routines_by_segment

def main():
    if len(sys.argv) != 5:
        print(__doc__)
        sys.exit(1)
    
    nhl94_rom = sys.argv[1]
    nhl94_lst = sys.argv[2]
    nhl95_rom = sys.argv[3]
    nhl95_lst = sys.argv[4]
    
    print("NHL ROM Fingerprint Matcher")
    print("=" * 70)
    print()
    
    # Load ROMs
    print(f"Loading {nhl94_rom}...")
    with open(nhl94_rom, 'rb') as f:
        rom94 = f.read()
    print(f"  NHL94 ROM: {len(rom94)} bytes")
    
    print(f"Loading {nhl95_rom}...")
    with open(nhl95_rom, 'rb') as f:
        rom95 = f.read()
    print(f"  NHL95 ROM: {len(rom95)} bytes")
    print()
    
    # Parse listings
    routines_94 = parse_94_listing(nhl94_lst)
    
    print(f"Found {sum(len(v) for v in routines_94.values())} routines in NHL94")
    
    # Create fingerprinter
    fp94 = Fingerprinter(rom94)
    fp95 = Fingerprinter(rom95)
    
    # TODO: Build fingerprints and match
    
    print("\nMatching complete!")

if __name__ == '__main__':
    main()

