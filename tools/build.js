#!/usr/bin/env node
// build.js: the whole NHL 95 build, one line per step, on Windows and Linux (wine).
//   node tools/build.js [retail|dev] [--verbose]   full ROM -> output/modified_nhl95.bin
//   node tools/build.js --clean                    delete output/ and Extracted/
// --no-color (or NO_COLOR) turns the colors off; they are also off when the output is not a terminal.
// retail: CHECKSUM=1 and verified against the retail ROM (found in the repo folder by its SHA-1 and size, any file name: tools/roms.js).
// dev: CHECKSUM=0, not verified. The checksum environment variable (set checksum=0 on Windows, checksum=0 node ... on Linux) overrides the default.
// The segment builds (npm run seg:<name>, buildseg.bat) are separate.
const fs = require('fs');
const path = require('path');
const { spawn } = require('child_process');

const ROOT = path.join(__dirname, '..');
const OUT = path.join(ROOT, 'output');
const { romPath } = require('./roms');
const WIN = process.platform === 'win32';

const args = process.argv.slice(2);
const verbose = args.includes('--verbose');
// ANSI colors: off when stdout is not a terminal, NO_COLOR is set, or --no-color. Windows 10+ cmd and
// PowerShell take ANSI codes from Node directly.
const color = process.stdout.isTTY && !('NO_COLOR' in process.env) && !args.includes('--no-color');
const sgr = (code) => (t) => (color ? `\x1b[${code}m${t}\x1b[0m` : String(t));
const c = { dim: sgr('2'), cyan: sgr('36'), green: sgr('32'), yellow: sgr('33'), red: sgr('31'), bold: sgr('1') };
// Values (numbers, $hex, output paths) bold; OK / MATCH green; warnings yellow.
const paint = (t) => t
    .replace(/(output\/\S+|\$[0-9A-F]+|\b\d+(?:\.\d+)?s?\b)/g, (m) => c.bold(m))
    .replace(/\b(MATCH|OK)\b/g, (m) => c.green(m))
    .replace(/\b([1-9]\d*)(\x1b\[0m)? (warnings|skipped)/g, (m) => c.yellow(m))
    .replace(/not verified \([^)]*\)/, (m) => c.yellow(m));
const mode = args.find((a) => a === 'retail' || a === 'dev') || 'retail';
const env = (k) => process.env[k] ?? process.env[k.toUpperCase()] ?? process.env[k.toLowerCase()];
const checksum = env('checksum') !== undefined ? (env('checksum') === '0' ? 0 : 1) : (mode === 'dev' ? 0 : 1);

let steps = 5;
let n = 0;
// Each step is two lines: "[n/6] <step>  <description>", then the result under the description.
// In a colour terminal the step line shows a spinner and a yellow step name while it runs, and is
// redrawn with a green check or a red cross when it ends (cut to the terminal width so it never
// wraps). Otherwise both lines are printed once, after the step.
const ABOUT = {
    prebuild: 'check the retail ROM; extract graphics/sound assets and the licensed names into Extracted/, build the Z80 driver',
    assemble: 'SNASM68k turns src/nhl95.asm into a raw ROM image',
    fixopcodes: "patch the instructions where SNASM picks a different encoding than EA's original assembler",
    fixrom: 'pad to a valid ROM size, write the header end address and the checksum',
    verify: 'compare byte-for-byte with the retail ROM',
    output: 'delete built ROMs and intermediates in output/',
    Extracted: 'delete extracted graphics/sound assets (rebuilt by the next build)',
};
const live = color;
// Braille spinner and check marks need a UTF-8 terminal; old Windows consoles get ASCII.
const utf8 = WIN ? Boolean(process.env.WT_SESSION || process.env.TERM_PROGRAM || process.env.ConEmuANSI)
    : /utf-?8/i.test(process.env.LC_ALL || process.env.LC_CTYPE || process.env.LANG || '');
const SPIN = utf8 ? ['⠋', '⠙', '⠹', '⠸', '⠼', '⠴', '⠦', '⠧', '⠇', '⠏'] : ['|', '/', '-', '\\'];
const OK = utf8 ? '✓' : 'OK';
const BAD = utf8 ? '✗' : 'X';
const MARK = Math.max(OK.length, BAD.length, 1);
const INDENT = ' '.repeat(`[0/0] ${live ? ' '.repeat(MARK + 1) : ''}${''.padEnd(10)} `.length);
let current = null;
let dirty = false;
let timer = null;
let frame = 0;
function header(name, paintName, mark) {
    const head = `[${n}/${steps}] ${live ? `${mark.padEnd(MARK)} ` : ''}${name.padEnd(10)} `;
    let desc = ABOUT[name] || '';
    const width = live ? (process.stdout.columns || 80) - 1 : Infinity;
    if (head.length + desc.length > width) desc = desc.slice(0, Math.max(0, width - head.length - 1)) + (width > head.length ? '…'.slice(0, utf8 ? 1 : 0) : '');
    const markPart = live ? `${paintName(mark.padEnd(MARK))} ` : '';
    return `${c.cyan(`[${n}/${steps}]`)} ${markPart}${paintName(name.padEnd(10))} ${c.dim(desc)}`;
}
const draw = (text) => process.stdout.write(`\r\x1b[2K${text}`);
function stopSpin() { if (timer) { clearInterval(timer); timer = null; } }
function begin(name) {
    n++;
    current = name;
    dirty = false;
    if (!live) return;
    frame = 0;
    draw(header(name, c.yellow, SPIN[0]));
    timer = setInterval(() => { frame = (frame + 1) % SPIN.length; draw(header(name, c.yellow, SPIN[frame])); }, 80);
}
function finish(name, paintName, mark) {
    if (current !== name) begin(name);
    stopSpin();
    if (!live) console.log(header(name, (t) => t, ''));
    else if (!dirty) draw(`${header(name, paintName, mark)}\n`);
    else console.log(header(name, paintName, mark));
    current = null;
}
const step = (name, text) => { finish(name, c.green, OK); console.log(INDENT + paint(text)); };
function detail(text) {
    if (!verbose || !text.trim()) return;
    if (live && current && !dirty) { stopSpin(); process.stdout.write('\n'); }
    dirty = true;
    console.log(text.replace(/\s+$/, '').replace(/^/gm, INDENT));
}
function fail(name, text, log, label = 'FAILED') {
    finish(name, c.red, BAD);
    console.log(`${INDENT}${c.red(label)}: ${text}`);
    if (log) console.log(log.replace(/\s+$/, '').replace(/^/gm, INDENT));
    console.log(c.red(`BUILD FAILED at ${name}`));
    process.exit(1);
}
// Child processes run async (spawn) so the spinner keeps turning while the assembler works.
function run(cmd, argv, opts = {}) {
    return new Promise((resolve) => {
        const chunks = [];
        let p;
        try { p = spawn(cmd, argv, { cwd: ROOT, ...opts }); } catch (e) { resolve({ status: -1, out: String(e) }); return; }
        p.stdout.on('data', (d) => chunks.push(d));
        p.stderr.on('data', (d) => chunks.push(d));
        p.on('error', (e) => resolve({ status: -1, out: Buffer.concat(chunks).toString('latin1') + String(e) }));
        p.on('close', (code) => resolve({ status: code, out: Buffer.concat(chunks).toString('latin1') }));
    });
}
const node = (script, argv) => run(process.execPath, [path.join(__dirname, script), ...argv]);

const rel = (p) => path.relative(ROOT, p).split(path.sep).join('/');

(async () => {
    if (args.includes('--clean')) {
        steps = 2;
        const walk = (d) => fs.readdirSync(d, { withFileTypes: true }).reduce((a, e) => {
            const f = path.join(d, e.name);
            if (e.isDirectory()) { const r = walk(f); return [a[0] + r[0], a[1] + r[1]]; }
            return [a[0] + 1, a[1] + fs.statSync(f).size];
        }, [0, 0]);
        for (const dir of ['output', 'Extracted']) {
            begin(dir);
            const full = path.join(ROOT, dir);
            if (!fs.existsSync(full)) { step(dir, 'already clean'); continue; }
            const [files, bytes] = walk(full);
            try { fs.rmSync(full, { recursive: true, force: true }); } catch (e) { fail(dir, e.message); }
            step(dir, `removed ${files} files, ${(bytes / 1048576).toFixed(1)} MB`);
        }
        console.log(c.green('CLEAN'));
        return;
    }

const name = 'nhl95';
const bin = path.join(OUT, `${name}.bin`);
const lst = path.join(OUT, `${name} .lst`);
const mod = path.join(OUT, `modified_${name}.bin`);
const logPath = path.join(OUT, 'Build95.log');

// 1. prebuild: ROM check, Extracted/ assets, the names, team counts, the Z80 driver.
{
    begin('prebuild');
    const r = await node('prebuild.js', ['retail']);
    if (r.status !== 0) fail('prebuild', 'ROM or asset extraction', r.out);
    let count = '?';
    try { count = JSON.parse(fs.readFileSync(path.join(ROOT, 'Extracted', '.extract-complete.json'), 'utf8')).files.length; } catch (e) { /* keep ? */ }
    step('prebuild', `ROM OK, ${count} assets extracted`);
    detail(r.out);
}

// 2. assemble: SNASM68k, directly on Windows, under wine elsewhere. Its console output is the log.
{
    begin('assemble');
    fs.mkdirSync(OUT, { recursive: true });
    for (const f of [bin, mod]) fs.rmSync(f, { force: true });
    const o = `..\\output\\${name}`;
    const asmArgs = ['/p', '/m', '/g', '/o', 'd-', '/o', 's-', '/o', 'r+', '/o', 'l+', '/o', 'l.', '/o', 'ow+', '/o', 'op-',
        '/o', 'os+', '/o', 'oz+', '/o', 'omq-', '/o', 'oaq+', '/o', 'osq+',
        '/e', `CHECKSUM=${checksum}`, `${name}.asm,${o}.bin,${o},${o}`];
    const exe = path.join(ROOT, 'assembler', 'Assembler.exe');
    const r = await (WIN ? run(exe, asmArgs, { cwd: path.join(ROOT, 'src') })
        : run('wine', [exe, ...asmArgs], { cwd: path.join(ROOT, 'src'), env: { ...process.env, WINEDEBUG: '-all' } }));
    fs.writeFileSync(logPath, r.out, 'latin1');
    const lines = r.out.split(/\r\n|\n|\r/);
    const sum = r.out.match(/(\d+) error\(s\) from (\d+) lines in ([\d.]+) seconds/);
    const warnings = lines.filter((l) => /warning/i.test(l)).length;
    const short = lines.filter((l) => /SHORTCALL /.test(l));
    if (short.length) {
        fail('assemble', 'a routine called with a short jsr/jmp (x).w moved past $7FFF',
            short.join('\n') + '\nPut the added data after the 2MB fill, or use the long form.\nSee docs/EXPANDING_THE_ROM.md.');
    }
    if (!sum) fail('assemble', `no assembler summary in ${rel(logPath)} (exit ${r.status})`, lines.slice(-20).join('\n'));
    const errors = Number(sum[1]);
    if (errors > 0 || !fs.existsSync(bin)) {
        const bad = lines.filter((l) => /\.(asm|inc|mac)\(\d+|error|fatal|not recognised|undefined/i.test(l) && !/error\(s\) from/.test(l)).slice(0, 40);
        fail('assemble', `${errors} error(s), see ${rel(logPath)}`, bad.join('\n'));
    }
    step('assemble', `${errors} errors, ${warnings} warnings, ${sum[2]} lines in ${sum[3]}s (CHECKSUM=${checksum}) -> ${rel(bin)}`);
    detail(r.out);
}

// 3. fixopcodes: rewrite the EA cmp / exg encodings SNASM picks differently; writes output/modified_nhl95.bin.
{
    begin('fixopcodes');
    const r = await node('fixopcodes.js', [lst, bin]);
    const m = r.out.match(/Modified (\d+) instructions/);
    if (r.status !== 0 || !m || !fs.existsSync(mod)) fail('fixopcodes', 'did not write the fixed binary', r.out);
    const skipped = (r.out.match(/Skipping/g) || []).length;
    step('fixopcodes', `${m[1]} opcodes fixed${skipped ? `, ${skipped} skipped` : ''} -> ${rel(mod)}`);
    detail(r.out);
}

// 4. fixrom: pad to the cartridge size, header ROM end, boot checksum.
{
    begin('fixrom');
    const r = await node('fixrom.js', [mod]);
    const m = r.out.match(/size (\w+) \(header end (\w+)\), checksum (\w+) -> (\w+)/);
    if (r.status !== 0 || !m) fail('fixrom', 'size or checksum', r.out);
    step('fixrom', `size $${m[1].toUpperCase()}, header end $${m[2].toUpperCase()}, checksum $${m[4].toUpperCase()}${m[3] !== m[4] ? ` (was $${m[3].toUpperCase()})` : ''}`);
    detail(r.out);
}

// 5. verify against the retail ROM.
if (mode === 'dev') {
    step('verify', `${rel(mod)} not verified (dev build)`);
} else {
    begin('verify');
    const ref = romPath('retail');
    const r = await node('verifyRom.js', [mod, ref]);
    const first = r.out.split(/\r?\n/).find((l) => l.trim()) || '';
    if (r.status !== 0 || !/^MATCH/.test(first)) fail('verify', rel(mod), r.out, 'MISMATCH');
    step('verify', `MATCH ${rel(mod)} == ${rel(ref)}`);
    detail(r.out);
}
})();
