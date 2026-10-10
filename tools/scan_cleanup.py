#!/usr/bin/env python3
"""Count what the cleanup pass still has to do under src/.

noise comments  comments strip_noise.py would still change
raw addresses   in code: RAM ($FFFFxxxx, or a word $8000-$FFFF taken as an address by
                movea / cmpa / lea / adda / suba, or subtracted from a pointer copied
                to a data register), hardware ($A0xxxx-$A1xxxx, $C000xx),
                save RAM ($20xxxx, or a long immediate equal to a save RAM offset from the
                SR names in ram95.asm) and ROM pointers (#$xxxx taken as an address, jsr / jmp $x,
                dc.l $x); plus raw struct displacements $x(a0-a4), reported separately
generic labels  IDA auto names (loc_, sub_, byte_, word_, unk_, off_, ...) in code, and in comments

Usage: python3 tools/scan_cleanup.py [src_dir] [--list]
"""
import os
import re
import sys
from collections import Counter

sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
import strip_noise  # noqa: E402

GENERIC = re.compile(r'\b(?:loc|sub|locret|byte|word|dword|unk|off|nullsub|asc|stru)_[0-9A-Fa-f]+\b')
ADDROP = r'(?:movea|cmpa|lea|pea|adda|suba)(?:\.[wl])?'
PTRSUB = re.compile(r'^\s*move\.[wl]\s+a\d\s*,\s*(d\d)\s*$')  # a pointer copied to a data register
PTRDIFF = r'^\s*subi?\.w\s+#\$[89A-Fa-f][0-9A-Fa-f]{3}\s*,\s*%s\b'
RAM = re.compile(r'#\$FFFF(?!FF)[0-9A-Fa-f]{4}\b(?<!FFFF0000)|\(\$FF[0-9A-Fa-f]{4}\)'
                 r'|^\s*' + ADDROP + r'\s+#\$[89A-Fa-f][0-9A-Fa-f]{3}\s*,\s*a\d', re.I)
SRAM = re.compile(r'\$20[0-9A-Fa-f]{4}\b')
SROFF = re.compile(r'^\s*(?:move|addi?)\.l\s+#\$([0-9A-Fa-f]{3,4})\s*,\s*d\d', re.I)
STRUCT = re.compile(r'(?<![\w$)])-?\$[0-9A-Fa-f]+\(a[0-4][,)]')
HW = re.compile(r'\$(?:00)?(?:A0[0-9A-Fa-f]{4}|A1[0-9A-Fa-f]{4}|C000[0-9A-Fa-f]{2})\b', re.I)
ROMPTR = re.compile(r'^\s*(?:jsr|jmp|lea|pea)\s+\(?\$[0-9A-Fa-f]{3,6}\)?(?:\.[wl])?\s*$'
                    r'|^\s*(?:movea\.[wl]|cmpa\.[wl]|lea|pea)\s+#\$[0-7]?[0-9A-Fa-f]{3,5}\s*,'
                    r'|^\s*dc\.l\s+\$(?:00)?[0-9A-Fa-f]{3,6}\b', re.I)


def scan(src, listing=False):
    counts = Counter()
    hits = {k: [] for k in ('noise', 'ram', 'hw', 'sram', 'rom', 'struct', 'generic')}
    files = sorted(fn for fn in os.listdir(src) if fn.endswith('.asm'))
    with open(os.path.join(src, 'ram95.asm'), encoding='latin-1') as f:
        sroffs = {int(m.group(1), 16) for m in re.finditer(r'^SR\w+\s+equ\s+\$([0-9A-Fa-f]+)', f.read(), re.M)}
    files += [os.path.join('sega', fn) for fn in sorted(os.listdir(os.path.join(src, 'sega'))) if fn.endswith('.asm')]
    files += [os.path.join('stubinc', fn) for fn in sorted(os.listdir(os.path.join(src, 'stubinc')))]
    for fn in files:
        stub = fn.endswith('_stub.asm')
        with open(os.path.join(src, fn), encoding='latin-1') as f:
            prev = None
            for no, line in enumerate(f, 1):
                where = '%s:%d: %s' % (fn, no, line.rstrip()[:160])
                if strip_noise.clean_line(line, stub, lambda a, b: None) != line:
                    counts['noise'] += 1
                    hits['noise'].append(where)
                code = strip_noise.split_comment(line)[0]
                if re.match(r'^\s*\w+\s*(=|equ\b)', code, re.I):
                    continue  # an equate is where a name is defined, not a use
                comment = strip_noise.split_comment(line)[1]
                n = len(GENERIC.findall(comment))
                if n:
                    counts['generic_comment'] += n
                    hits.setdefault('generic_comment', []).append(where)
                if stub:
                    continue  # stub equates and includes only
                for key, rx in (('ram', RAM), ('hw', HW), ('sram', SRAM), ('struct', STRUCT), ('generic', GENERIC)):
                    if key == 'sram' and re.match(r'^\s*dcb\.', code, re.I):
                        continue  # the fill to the ROM end
                    n = len(rx.findall(code))
                    if n:
                        counts[key] += n
                        hits[key].append(where)
                if prev and re.match(PTRDIFF % prev, code, re.I):
                    counts['ram'] += 1
                    hits['ram'].append(where)
                pm = PTRSUB.match(code)
                prev = pm.group(1) if pm else None
                m = SROFF.match(code)
                if m and int(m.group(1), 16) in sroffs:
                    counts['sram'] += 1
                    hits['sram'].append(where)
                if ROMPTR.search(code) and not RAM.search(code) and not HW.search(code) and not SRAM.search(code):
                    counts['rom'] += 1
                    hits['rom'].append(where)
    if listing:
        for key, lines in hits.items():
            for line in lines:
                print(key, line)
    return counts


def main():
    args = [a for a in sys.argv[1:] if not a.startswith('--')]
    src = args[0] if args else os.path.join(strip_noise.ROOT, 'src')
    c = scan(src, '--list' in sys.argv)
    print('noise comments: %d' % c['noise'])
    print('raw RAM addresses: %d' % c['ram'])
    print('raw hardware addresses: %d' % c['hw'])
    print('raw save RAM addresses: %d' % c['sram'])
    print('raw ROM pointers: %d' % c['rom'])
    print('raw struct displacements $x(a0-a4): %d' % c['struct'])
    print('generic auto labels in code: %d' % c['generic'])
    print('generic auto names in comments: %d' % c['generic_comment'])


if __name__ == '__main__':
    main()
