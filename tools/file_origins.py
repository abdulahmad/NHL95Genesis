#!/usr/bin/env python3
"""Map every label in the NHL 95 source to the NHL94Genesis file it came from.

  python3 tools/file_origins.py --ref94 ../NHL94Genesis --ref93 ../NHLPA93Genesis

Needs a full build first (npm run build:retail): the label addresses come from its listing,
output/nhl95 .lst. Writes docs/function_origins.csv (one row per label) and docs/FILE_ORIGINS.md
(per 95 file, per 94 file, and the routines of each 95 file grouped by origin).

A label is assigned by the first rule that applies:
  name         a global label of that name in an NHL94Genesis file (not the shared rts labels)
  header       the header says '95 only' / 'new in 95', or names the 94 file or the 94 routine
  fingerprint  tools/segmap95.json matched the bytes to a 94 routine (similarity >= 0.5 over
               at least half of the label)
  name (93)    a global label of that name in an NHLPA93Genesis file only
  follows      a table, shared rts or entry point with no evidence takes the label before it
  file         the rest of a file that is new in 95 is new in 95
"""
import argparse
import csv
import json
import os
import re
from collections import Counter, OrderedDict, defaultdict

ROOT = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
ROM_END = 0x1A7310
NEW95 = {'season95', 'trade95', 'create95', 'awards95', 'schedule95'}
REGION_LOCK = {'CHECK_VDP', 'RegionPrint', 'RegionSystems', 'DevelopedTxt', 'AndTxt', 'SystemsTxt',
               'NtscMegaDriveTxt', 'NtscGenesisTxt', 'PalMegaDriveTxt', 'RegionFont', 'RegionOK'}

LAB = re.compile(r'^([A-Za-z_]\w*)(?=\s|;|$|:)')
EQU = re.compile(r'^\w+\s*(=|equ\b|rs\b|set\b|macro\b)', re.I)
CODE = re.compile(r'^\s+(move|movem|moveq|movea|lea|jsr|jmp|bsr|bra|b[a-z]{2}|tst|cmp|cmpi|cmpa|clr|add|sub|'
                  r'and|or|eor|lsl|lsr|asl|asr|rol|ror|swap|ext|btst|bset|bclr|bchg|rts|rte|link|unlk|pea|'
                  r'mulu|muls|divu|divs|neg|not|exg|db[a-z]{1,2}|s[a-z]{1,2}|trap|nop|stop|addq|subq|addi|'
                  r'subi|andi|ori|eori|adda|suba|tas|chk)\b', re.I)
NEW_HDR = re.compile(r'95 only|new in 95', re.I)


def labels_in(path):
    """(name, 'code' or 'data', header text) for each global label of an asm file."""
    out = []
    lines = open(path, encoding='latin-1').read().split('\n')
    for i, line in enumerate(lines):
        m = LAB.match(line)
        if not m or EQU.match(line):
            continue
        kind = 'data'
        for s in lines[i + 1:]:
            if s.strip() == '' or s.strip().startswith(';') or LAB.match(s) or s.startswith('.'):
                continue
            if CODE.match(s):
                kind = 'code'
            break
        hdr = []
        k = i - 1
        while k >= 0 and lines[k].strip().startswith(';'):
            hdr.insert(0, lines[k])
            k -= 1
        if ';' in line:
            hdr.append(line.split(';', 1)[1])
        out.append((m.group(1), kind, ' '.join(hdr)))
    return out


def ref_labels(src, strip_num):
    """lower-case label -> reference file (sega files as sega/<name>)."""
    d = {}
    for sub in ('', 'sega'):
        root = os.path.join(src, sub)
        for fn in sorted(os.listdir(root)):
            if not fn.endswith('.asm') or fn.endswith('_stub.asm') or fn.startswith(('nhl9', 'ram9')):
                continue
            mod = re.sub(r'_\d+$', '', fn[:-4]) if strip_num else fn[:-4]
            if sub:
                mod = sub + '/' + mod
            for name, _, _ in labels_in(os.path.join(root, fn)):
                d.setdefault(name.lower(), mod)
    return d


def rom_labels(lst):
    """label -> address from the SNASM listing."""
    addr = {}
    for line in open(lst, encoding='latin-1'):
        if len(line) < 37 or not re.match(r'^[0-9A-F]{8} ', line) or 'M' in line[34:36]:
            continue
        src = line[36:].rstrip('\n')
        m = LAB.match(src)
        if m and not EQU.match(src):
            addr.setdefault(m.group(1), int(line[:8], 16))
    return addr


def header_94(h, l94):
    mods = set(l94.values())
    m = re.search(r'\b([a-z]+94)\b', h)
    if m and m.group(1) in mods:
        return m.group(1), 'header names ' + m.group(1)
    for m in re.finditer(r'\b94 (\w+)', h):
        if m.group(1).lower() in l94:
            return l94[m.group(1).lower()], 'header names 94 ' + m.group(1)
    return None


def include_lines(path):
    """The files an include list names with their start address ('; $ADDR'), in order."""
    out = []
    for line in open(os.path.join(ROOT, 'src', path)):
        m = re.match(r'^\s+include\s+(\S+\.asm)\s*;\s+\$[0-9A-F]+', line)
        if m:
            out.append(m.group(1).replace('\\', '/'))
    return out


def source_order(path='nhl95.asm'):
    """The source files in ROM order: nhl95.asm and the include lists it names (engine95.asm, front95.asm) are
    expanded, main95.asm is followed by its sega\\ files."""
    files = []
    for f in include_lines(path):
        if f != 'main95.asm' and include_lines(f):
            files += source_order(f)
            continue
        files.append(f)
        if f == 'main95.asm':
            for l2 in open(os.path.join(ROOT, 'src', 'main95.asm')):
                m2 = re.match(r'^\s+include\s+(sega\\\S+\.asm)', l2)
                if m2:
                    files.append(m2.group(1).replace('\\', '/'))
    return files


def classify(ref94, ref93):
    l94 = ref_labels(os.path.join(ref94, 'src'), False)
    l93 = ref_labels(os.path.join(ref93, 'src'), True)
    addr = rom_labels(os.path.join(ROOT, 'output', 'nhl95 .lst'))
    units = []
    for s in json.load(open(os.path.join(ROOT, 'tools', 'segmap95.json')))['segments']:
        for u in s.get('units', []):
            units.append((int(u[3][1:], 16), int(u[4][1:], 16), u[0], u[1], u[5]))
    order = source_order()
    rows = []
    for f in order:
        for name, kind, hdr in labels_in(os.path.join(ROOT, 'src', f)):
            if name in addr:
                rows.append(dict(file=f, name=name, kind=kind, addr=addr[name], hdr=hdr))
    rows.sort(key=lambda r: r['addr'])
    for i, r in enumerate(rows):
        r['end'] = rows[i + 1]['addr'] if i + 1 < len(rows) else ROM_END
        r['size'] = r['end'] - r['addr']

    prev = None
    for r in rows:
        mod = os.path.basename(r['file'])[:-4]
        n = r['name'].lower()
        cov, rname = Counter(), {}
        for a, b, rf, rn, sim in units:
            o = min(b, r['end']) - max(a, r['addr'])
            if o > 0 and sim >= 0.5:
                cov[rf] += o
                rname.setdefault(rf, rn)
        fp, fpb = cov.most_common(1)[0] if cov else (None, 0)
        if fpb * 2 < max(1, r['size']):
            fp = None
        new_hdr = NEW_HDR.search(r['hdr'])
        if r['name'] in REGION_LOCK and mod == 'main95':
            res = ('new in 95', 'the 95 region lock')
        elif r['file'].startswith('sega/'):
            res = ('sega/' + mod.replace('95', '94'), 'Sega code')
        elif n in l94 and not n.startswith('rts'):
            res = (l94[n], 'name')
        elif new_hdr:
            res = ('new in 95', 'header')
        elif header_94(r['hdr'], l94):
            res = header_94(r['hdr'], l94)
        elif fp:
            res = (fp, 'fingerprint ' + rname[fp])
        elif n in l93:
            res = (l93[n] + ' (93 only)', 'name')
        elif prev and prev['file'] == r['file'] and (r['kind'] == 'data' or n.startswith('rts')
                                                      or prev['origin'] != 'new in 95'):
            res = (prev['origin'], 'follows ' + prev['name'])
        elif re.sub(r'_\d+$', '', mod) in NEW95 or r['kind'] == 'code':
            res = ('new in 95', 'file' if re.sub(r'_\d+$', '', mod) in NEW95 else 'no 94 match')
        else:
            res = ('?', '')
        r['origin'], r['basis'] = res
        prev = r
    return order, rows


def write(order, rows, ref94):
    with open(os.path.join(ROOT, 'docs', 'function_origins.csv'), 'w', newline='') as f:
        w = csv.writer(f, lineterminator='\n')
        w.writerow(['file', 'address', 'size', 'label', 'kind', 'from', 'basis'])
        for r in rows:
            w.writerow([r['file'], '$%06X' % r['addr'], r['size'], r['name'], r['kind'], r['origin'], r['basis']])

    byfile = OrderedDict((f, []) for f in order)
    for r in rows:
        byfile[r['file']].append(r)

    def pct(v, tot):
        p = round(100 * v / tot)
        return '%d%%' % p if p >= 1 else '<1%'

    out = ['# Where the NHL 95 code came from', '',
           'Each 95 source file, in ROM order, with the NHL94Genesis file each of its routines and tables came from. '
           'Generated by `tools/file_origins.py` from the full build listing; every label with its address, size '
           'and the evidence is in `function_origins.csv`.', '',
           'A label is assigned by the first rule that applies:', '',
           '1. **name**: a global label of that name in an NHL94Genesis file (the shared `rts` labels excepted).',
           '2. **header**: the header says `95 only` (new in 95), or names the 94 file or 94 routine.',
           '3. **fingerprint**: `tools/segmap95.json` matched the bytes to a 94 routine.',
           '4. **name (93)**: a label only NHLPA93Genesis has.',
           '5. **follows**: a table, shared `rts` or entry point with no evidence of its own takes the label before it.',
           '6. **file**: the rest of a file that is new in 95 (season95, trade95, create95, awards95, '
           'schedule95) is new in 95.', '',
           'Sizes run from a label to the next one, so the vectors ($0-$FF) and the header before CountryCode are not '
           'counted. Percentages are by bytes. "new in 95" means 94 has no routine like it.', '',
           '## By 95 file', '', '| 95 file | Range | Bytes | Came from (by bytes) |', '| --- | --- | --- | --- |']
    for f, rs in byfile.items():
        if not rs:
            continue
        tot = sum(r['size'] for r in rs)
        c = Counter()
        for r in rs:
            c[r['origin']] += r['size']
        mix = ', '.join('%s %s' % (k, pct(v, tot)) for k, v in c.most_common())
        out.append('| `%s` | $%06X-$%06X | %d | %s |' % (f[:-4], rs[0]['addr'], rs[-1]['end'] - 1, tot, mix))

    out += ['', '## By 94 file', '',
            'Where the routines and tables of each 94 file ended up in 95: bytes, then the label count in brackets.', '',
            '| 94 file | 95 files |', '| --- | --- |']
    by94, cnt94 = defaultdict(Counter), defaultdict(Counter)
    for r in rows:
        by94[r['origin']][r['file'][:-4]] += r['size']
        cnt94[r['origin']][r['file'][:-4]] += 1
    ref_order = ['sega/SegaIDTable94', 'sega/SegaInit']
    for line in open(os.path.join(ref94, 'src', 'nhl94.asm')):
        m = re.match(r'^\s+include\s+(\w+)\.asm', line)
        if m:
            ref_order.append(m.group(1))
    keys = [k for k in ref_order if k in by94] + sorted(k for k in by94 if k not in ref_order)
    for k in keys:
        out.append('| %s | %s |' % (k, ', '.join('`%s` %d (%d)' % (f, b, cnt94[k][f]) for f, b in by94[k].most_common())))

    out += ['', '## Routines in each 95 file', '',
            'Consecutive labels from the same 94 file are one line, in ROM order. Tables and shared `rts` labels are '
            'counted in the bytes but not listed; they are in the CSV.']
    for f, rs in byfile.items():
        if not rs:
            continue
        out += ['', '### ' + f[:-4], '']
        runs = []
        for r in rs:
            if not runs or runs[-1][0] != r['origin']:
                runs.append([r['origin'], [], 0])
            runs[-1][2] += r['size']
            if r['kind'] == 'code' and not r['name'].lower().startswith('rts'):
                runs[-1][1].append(r['name'])
        for o, names, size in runs:
            out.append('- **%s** (%d bytes): %s' % (o, size, ', '.join(names) or '(tables only)'))
    with open(os.path.join(ROOT, 'docs', 'FILE_ORIGINS.md'), 'w') as f:
        f.write('\n'.join(out) + '\n')


def main():
    ap = argparse.ArgumentParser(description=__doc__, formatter_class=argparse.RawDescriptionHelpFormatter)
    ap.add_argument('--ref94', default='/tmp/NHL94Genesis', help='NHL94Genesis checkout')
    ap.add_argument('--ref93', default='/tmp/NHLPA93Genesis', help='NHLPA93Genesis checkout')
    a = ap.parse_args()
    order, rows = classify(a.ref94, a.ref93)
    write(order, rows, a.ref94)
    c = Counter(r['basis'].split()[0] if r['basis'] else '?' for r in rows)
    print('%d labels: %s' % (len(rows), ', '.join('%s %d' % kv for kv in c.most_common())))


if __name__ == '__main__':
    main()
