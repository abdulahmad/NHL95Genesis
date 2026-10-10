#!/usr/bin/env python3
"""Strip disassembler noise from the comments under src/.

Noise is what IDA or the segment tooling wrote, not a person: address echoes
(";$7A79C."), bare hex values, "IDA: sub_xxxx", "no IDA label", "IDA dc.b",
"retail $x-$y (n bytes)" ranges and the stub "used at $x" xref lists.
Code and data are never touched: only the text after the first ';' that is
outside a quoted string changes, and a comment left empty is removed.

The IDA name each label had is written to docs/name_map.csv first, with the
address from the full build listing (output/nhl95 .lst), so nothing is lost.

Usage: python3 tools/strip_noise.py [--dry-run]
"""
import csv
import os
import re
import sys
from collections import Counter

ROOT = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
SRC = os.path.join(ROOT, 'src')
LISTING = os.path.join(ROOT, 'output', 'nhl95 .lst')
IDA_LST = os.path.join(ROOT, 'lst', 'nhl95.bin.lst')
NAME_MAP = os.path.join(ROOT, 'docs', 'name_map.csv')

IDA_NAME = r'(?:sub|loc|locret|unk|byte|word|dword|off|nullsub)_[0-9A-Fa-f]+'
HEX = r'\$[0-9A-Fa-f]+'
LABEL_LINE = re.compile(r'^([A-Za-z_.@][\w.@]*)')


def split_comment(line):
    """Return (code, comment) where comment starts with ';' or is ''."""
    quote = None
    for i, ch in enumerate(line):
        if quote:
            if ch == quote:
                quote = None
        elif ch in '\'"':
            quote = ch
        elif ch == ';':
            return line[:i], line[i:]
    return line, ''


def clean_text(s, label_line, stub_equate, record):
    s = s.strip()
    if re.fullmatch(r'\$[0-9A-Fa-f]{4,}', s):
        return ''
    if label_line:
        s = re.sub(r'^\$[0-9A-Fa-f]{3,}(?=[.,\s]|$)[.,]?\s*', '', s)
        s = re.sub(r'^(?:retail\s+)?' + HEX + r'(?:-' + HEX + r')?\s*\(\d+ bytes\)[.,]?\s*', '', s)
        s = re.sub(r'^retail\s+' + HEX + r'[.,]\s*', '', s)
    changed = True
    while changed:
        before = s
        m = re.match(r'^IDA:\s*(' + IDA_NAME + r')\b[.,]?\s*', s)
        if m:
            record(m.group(1))
            s = s[m.end():]
        s = re.sub(r'^IDA:\s*no label(?:\s*\([^)]*\))?[.,]?\s*', '', s)
        if label_line:
            s = re.sub(r'^IDA:\s*wrong code[.,]\s*', '', s)
            m = re.match(r'^IDA:?\s*(94\s+)?([A-Za-z_]\w*)\??(?:\s*\(([^)]*)\))?[.,]\s*', s)
            if m and m.group(2) not in ('left', 'hid', 'code', 'read', 'dc'):
                record(m.group(2))
                note = m.group(3) or ''
                if m.group(1):
                    prefix = '94 name. '
                elif re.fullmatch(r'\d\d(?: name)?', note):
                    prefix = note[:2] + ' name. '
                elif not note or re.fullmatch(HEX, note):
                    prefix = ''
                else:
                    prefix = '(' + note + ') '
                s = prefix + s[m.end():]
        s = re.sub(r'^IDA name(?: and comment)?[.,]?\s*', '', s)
        s = re.sub(r'^no IDA label(?:\s*\((?:IDA dc\.b|inside ' + IDA_NAME + r')\))?[.,]?\s*', '', s, flags=re.I)
        s = re.sub(r'^no label[.,]\s*', '', s)
        s = re.sub(r'^IDA dc\.b, no xref( in the listing)?', r'No xref\1', s)
        s = re.sub(r'^IDA dc\.b, no caller', 'No caller', s)
        s = re.sub(r'^IDA dc\.b and code', 'Data and code', s)
        s = re.sub(r'^IDA dc\.b(?=\s*\()\s*', '', s)
        s = re.sub(r'^IDA dc\.b[.,]?\s*', '', s)
        changed = s != before
    s = s.replace('. IDA dc.b, no xref in the listing.', '. No xref in the listing.')
    if label_line:
        s = re.sub(r'\. IDA dc\.b\.(?= |$)', '.', s)
    if stub_equate:
        # "used at $x, $y and 3 more (file)", "jsr (x).l at $x (file)", "asstab entry $x, used at $x (file)"
        hexes = HEX + r'(?:,\s*' + HEX + r')*(?:\s+and \d+ more)?\s*'
        s = re.sub(r'(?:asstab entry ' + HEX + r', )?used at ' + hexes, '', s)
        s = re.sub(r'\b[a-z]+(?:\.[lwbs])?(?:\s+(?:\(x\)\.[lw]|#x(?:\+\d+)?|x))?\s+at\s+' + hexes, '', s)
        s = re.sub(r'(?:#x(?:\+\d+)?|x)\s+at\s+' + hexes, '', s)
        s = re.sub(r'\(([^()]*)\)\s*\(([a-z0-9_]+)\)$', r'\1 (\2)', s)
        s = re.sub(r'^\(([a-z0-9_]+)\)$', r'\1', s)
        s = re.sub(r',\s*\(', ' (', s)
        s = re.sub(r'^:\s*', '', s)
    s = re.sub(r'^[.,]\s*', '', s)
    return s.strip()


def clean_line(line, stub, record):
    code, comment = split_comment(line.rstrip('\r\n'))
    if not comment:
        return line
    eol = line[len(line.rstrip('\r\n')):]
    label = LABEL_LINE.match(code)
    label_line = bool(label)
    stub_equate = stub and bool(re.match(r'^\w+\s*(=|equ\b)', code, re.I))
    body = comment[1:]
    lead = body[:len(body) - len(body.lstrip())]
    text = clean_text(body, label_line, stub_equate,
                      lambda ida: record(label.group(1) if label else None, ida))
    if text == body.strip():
        return line
    if not text:
        return code.rstrip() + eol
    return code + ';' + lead + text + eol


def build_addresses():
    """Global label -> address from the full build listing."""
    addrs = {}
    if not os.path.exists(LISTING):
        sys.exit('Run the full build first: ' + LISTING + ' is missing')
    with open(LISTING, encoding='latin-1') as f:
        for raw in f:
            m = re.match(r'^([0-9A-F]{8}) .{27}([A-Za-z_][\w]*)(?=[\s:;=]|$)', raw)
            if m and not raw[36:37].isspace():
                name = m.group(2)
                rest = raw[36 + len(name):].lstrip()
                if rest.lower().startswith(('=', 'equ', 'macro', 'rs', 'set')):
                    continue
                addrs.setdefault(name.lower(), (name, int(m.group(1), 16)))
    return addrs


def ida_names_by_address():
    by_addr = {}
    with open(IDA_LST, encoding='latin-1') as f:
        for name in set(re.findall(r'^(' + IDA_NAME + r')\b', f.read(), re.M)):
            if not name.startswith('nullsub'):
                by_addr.setdefault(int(name.split('_')[1], 16), name)
    return by_addr


def module_ranges():
    """(org, module) from each stub, so a build address maps to its file."""
    ranges = []
    for fn in os.listdir(SRC):
        if fn.endswith('_stub.asm'):
            text = open(os.path.join(SRC, fn), encoding='latin-1').read()
            m = re.search(r'^\s+org\s+\$?([0-9A-Fa-f]+)', text, re.M)
            ranges.append((int(m.group(1), 16), fn[:-len('_stub.asm')]))
    return sorted(ranges)


def main():
    dry = '--dry-run' in sys.argv
    recorded = {}
    changes = Counter()
    examples = {}
    files = sorted(fn for fn in os.listdir(SRC) if fn.endswith('.asm'))
    files += [os.path.join('sega', fn) for fn in sorted(os.listdir(os.path.join(SRC, 'sega'))) if fn.endswith('.asm')]
    files += [os.path.join('stubinc', fn) for fn in sorted(os.listdir(os.path.join(SRC, 'stubinc')))]
    files += [os.path.join('macros', fn) for fn in sorted(os.listdir(os.path.join(SRC, 'macros')))]
    for fn in files:
        path = os.path.join(SRC, fn)
        stub = fn.endswith('_stub.asm')
        with open(path, encoding='latin-1', newline='') as f:
            lines = f.readlines()

        def record(label, ida):
            if label and not stub and not label.startswith(('.', '@')):
                recorded.setdefault(label.lower(), (label, ida))

        out = []
        for line in lines:
            new = clean_line(line, stub, record)
            if new != line:
                changes[fn] += 1
                key = re.sub(HEX, '$X', re.sub(IDA_NAME, 'IDA_X', split_comment(line)[1].strip()))
                examples.setdefault(key, (line.rstrip(), new.rstrip()))
            out.append(new)
        if not dry and out != lines:
            with open(path, 'w', encoding='latin-1', newline='') as f:
                f.writelines(out)

    addrs = build_addresses()
    ida_at = ida_names_by_address()
    ranges = module_ranges()
    rows = []
    for key, (name, addr) in addrs.items():
        module = None
        for org, mod in ranges:
            if org <= addr:
                module = mod
        ida = recorded.get(key, (name, ''))[1] or ida_at.get(addr, '')
        rows.append((addr, name, ida, module))
    rows.sort()
    if not dry:
        os.makedirs(os.path.dirname(NAME_MAP), exist_ok=True)
        with open(NAME_MAP, 'w', newline='') as f:
            w = csv.writer(f, lineterminator='\n')
            w.writerow(['address', 'name', 'ida_name', 'old_name', 'module'])
            for addr, name, ida, module in rows:
                w.writerow(['$%06X' % addr, name, ida, '', module])
    for fn, n in sorted(changes.items()):
        print('%5d  %s' % (n, fn))
    print('%d lines changed, %d labels in the name map' % (sum(changes.values()), len(rows)))
    if dry:
        for before, after in examples.values():
            print('-', before[:180])
            print('+', after[:180])


if __name__ == '__main__':
    main()
