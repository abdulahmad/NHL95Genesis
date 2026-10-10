#!/usr/bin/env python3
"""Count what the cleanup pass still has to do under src/.

noise comments  comments strip_noise.py would still change
raw addresses   hex RAM ($FFxxxx / $FFFFxxxx), hardware ($A0xxxx-$A1xxxx, $C000xx)
                and ROM pointer operands (jsr / jmp / lea / pea / dc.l / movea.l #) in code
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
RAM = re.compile(r'\$(?:FFFF[0-9A-Fa-f]{4}|FF[0-9A-Fa-f]{4})\b')
HW = re.compile(r'\$(?:00)?(?:A0[0-9A-Fa-f]{4}|A1[0-9A-Fa-f]{4}|C000[0-9A-Fa-f]{2})\b')
ROMPTR = re.compile(r'^\s*(?:jsr|jmp|lea|pea|movea?\.l)\s+\(?\$[0-9A-Fa-f]{3,6}\)?(?:\.[wl])?\b'
                    r'|^\s*(?:movea?\.l)\s+#\$[0-9A-Fa-f]{4,6}\s*,\s*a\d'
                    r'|^\s*dc\.l\s+\$[0-9A-Fa-f]{4,6}\b', re.I)


def scan(src, listing=False):
    counts = Counter()
    hits = {k: [] for k in ('noise', 'ram', 'hw', 'rom', 'generic')}
    files = sorted(fn for fn in os.listdir(src) if fn.endswith('.asm'))
    files += [os.path.join('stubinc', fn) for fn in sorted(os.listdir(os.path.join(src, 'stubinc')))]
    for fn in files:
        stub = fn.endswith('_stub.asm')
        with open(os.path.join(src, fn), encoding='latin-1') as f:
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
                for key, rx in (('ram', RAM), ('hw', HW), ('generic', GENERIC)):
                    n = len(rx.findall(code))
                    if n:
                        counts[key] += n
                        hits[key].append(where)
                if ROMPTR.search(code) and not RAM.search(code) and not HW.search(code):
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
    print('raw ROM pointers: %d' % c['rom'])
    print('generic auto labels in code: %d' % c['generic'])
    print('generic auto names in comments: %d' % c['generic_comment'])


if __name__ == '__main__':
    main()
