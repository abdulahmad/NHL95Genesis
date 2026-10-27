// prebuild.js: run before every build (npm run build:*, seg:*, build95.bat, buildseg.bat).
// Usage: node tools/prebuild.js [retail]
// The ROM must be present (and the right version); then makes sure Extracted/ is complete, and runs
// the extractor if it is not. If the ROM is missing or wrong, stops with the path, file name, SHA-1
// and size it must have.
// The batch files skip this step when NHL_PREBUILD_DONE is set (the npm scripts set it after
// running it; tools/verify_all.sh runs it with Linux node, since there is no node under wine).

const GAME = 'NHL 95 (Sega Genesis)';
const EXTRACTOR = 'tools/extractAssets95.js';
const { ROMS, findRom, sha1Of } = require('./roms');
const TARGETS = { retail: ['retail'] };
// ---------------------------------------------------------------------------------------------
const fs = require('fs');
const path = require('path');
const { spawnSync } = require('child_process');

const ROOT = path.join(__dirname, '..');
const EXTRACTED = path.join(ROOT, 'Extracted');
const MARKER = path.join(EXTRACTED, '.extract-complete.json');

// 3. The old Z80 driver: asm80 builds src/sound/z80_snd_drv93.asm and checks it (tools/buildZ80.js).
function z80() {
    const r = require('./buildZ80')();
    if (!r.ok) { console.error(r.msg); console.error('*** BUILD STOPPED: Z80 driver ***'); process.exit(1); }
    console.log('prebuild: ' + r.msg);
}

const sizeText = (n) => `${n} bytes (0x${n.toString(16).toUpperCase()}, ${n / 0x100000 >= 1 ? n / 0x100000 + ' MB' : n / 1024 + ' KB'})`;

// Check one ROM: a file in the repo folder with this SHA-1 and size, whatever its name (tools/roms.js).
const checkRom = findRom;

function romBlock(rom) {
    return [
        `  ${rom.label}`,
        `    Put it in:  ${ROOT}`,
        `                (any file name: it is found by its SHA-1 and size; ${rom.file} is the usual name)`,
        `    SHA-1:      ${rom.sha1}`,
        `    Size:       ${sizeText(rom.size)}`,
    ].join('\n');
}

function stop(lines) {
    console.error('');
    console.error('*** BUILD STOPPED: ROM file needed ***');
    console.error(lines.join('\n'));
    console.error('');
    console.error(`ROMs are not included in the repo. Use your own dump of the ${GAME} cartridge,`);
    console.error('in the repo folder (any file name), then run the build again. The assets in Extracted/');
    console.error('are then extracted from it automatically.');
    console.error('');
    process.exit(1);
}

// Is Extracted/ complete? The extractor writes the marker last, listing every file it wrote, the
// ROM it read and its own SHA-1. Any missing or resized file, an unknown ROM or a changed extractor
// means the folder has to be extracted again.
function extractedState() {
    if (!fs.existsSync(EXTRACTED)) return 'Extracted/ is missing';
    if (!fs.existsSync(MARKER)) return 'Extracted/ is incomplete (no .extract-complete.json marker)';
    let m;
    try { m = JSON.parse(fs.readFileSync(MARKER, 'utf8')); } catch (e) { return 'the Extracted/ marker is unreadable'; }
    if (m.extractorSha1 !== sha1Of(fs.readFileSync(path.join(ROOT, EXTRACTOR)))) return `${EXTRACTOR} changed since the last extraction`;
    if (!Object.values(ROMS).some((r) => r.sha1 === m.romSha1)) return 'Extracted/ came from an unknown ROM';
    if (!Array.isArray(m.files) || m.files.length === 0) return 'the Extracted/ marker lists no files';
    for (const f of m.files) {
        const p = path.join(EXTRACTED, f.path);
        if (!fs.existsSync(p)) return `Extracted/${f.path} is missing`;
        if (fs.statSync(p).size !== f.size) return `Extracted/${f.path} has the wrong size`;
    }
    return null;
}

// Width and height of a banner map. The long at +4 is the offset of the map header
// (word width, word height). Two rows of tiles are one team.
function mapGeometry(relPath) {
    const buf = fs.readFileSync(path.join(EXTRACTED, relPath));
    const hdr = buf.readUInt32BE(4);
    return { width: buf.readUInt16BE(hdr), height: buf.readUInt16BE(hdr + 2) };
}

// The licensed names: src/teamdata95.asm and src/engine/setup95.asm hold placeholders instead of the NHLPA player names and the
// NHL team nicknames. The extractor writes the real ones to Extracted/PlayerNames.txt and Extracted/TeamNicknames.txt (one per
// line, in source order); this copies the two files to output/names/ with each placeholder replaced, and nhl95.asm and the
// teamdata95 / setup95 segment stubs include the copies. A name must have the length of its placeholder (the Player macro
// writes the row length). Player rows are replaced in order; a nickname placeholder is 'N' + its two-digit number in
// TeamNicknames.txt, padded with '_' (setup95.asm uses two of them for the full names of the New York teams).
function writeNames() {
    const read = (f) => { const l = fs.readFileSync(path.join(EXTRACTED, f), 'latin1').split('\n'); if (l[l.length - 1] === '') l.pop(); return l; };
    const players = read('PlayerNames.txt'), nicks = read('TeamNicknames.txt');
    const fail = (msg) => { console.error('names: ' + msg); console.error('*** BUILD STOPPED: the player names could not be put back ***'); process.exit(1); };
    let p = 0;
    const outDir = path.join(ROOT, 'output', 'names');
    fs.mkdirSync(outDir, { recursive: true });
    for (const f of ['teamdata95.asm', path.join('engine', 'setup95.asm')]) {
        const out = fs.readFileSync(path.join(ROOT, 'src', f), 'latin1')
            .replace(/^([ \t]*Player[ \t]+')((?:[^']|'')*)(')/gm, (m, a, ph, z) => {
                const real = players[p++];
                if (real === undefined) fail(`src/${f} has more Player rows than PlayerNames.txt has names (${players.length})`);
                const want = ph.replace(/''/g, "'").length;
                if (real.length !== want) fail(`Player row ${p}: the name '${real}' has ${real.length} characters, its placeholder '${ph}' has ${want}`);
                return a + real.replace(/'/g, "''") + z;
            })
            .replace(/'(N(\d\d)_*)'/g, (m, ph, id) => {
                const real = nicks[Number(id) - 1];
                if (real === undefined) fail(`src/${f}: nickname placeholder '${ph}' has no entry in TeamNicknames.txt (${nicks.length})`);
                if (real.length !== ph.length) fail(`nickname ${id}: '${real}' has ${real.length} characters, its placeholder '${ph}' has ${ph.length}`);
                return "'" + real.replace(/'/g, "''") + "'";
            });
        fs.writeFileSync(path.join(outDir, path.basename(f)), out, 'latin1');
    }
    if (p !== players.length) fail(`PlayerNames.txt has ${players.length} names, src/teamdata95.asm has ${p} Player rows`);
    console.log(`prebuild: ${p} player names, ${nicks.length} team nicknames -> output/names/`);
}

function writeTeamCounts() {
    const maps = [
        ['Teamblocks', 'NHL95/Graphics/Teamblocksmap.map.jim'],
        ['PauseTeamBlocks', 'NHL95/Graphics/PauseTeamBlocksMap.map.jim'],
        ['TeamBitmaps', 'NHL95/Graphics/TeamBitmaps.map.jim'],
    ];
    const lines = ['; Two rows per team, measured from the banner maps.', ''];
    for (const [name, rel] of maps) {
        const { width, height } = mapGeometry(rel);
        lines.push(`${name}Wide equ ${width}`);
        lines.push(`${name}Rows equ ${height}`);
    }
    lines.push('');
    const outDir = path.join(ROOT, 'output');
    fs.mkdirSync(outDir, { recursive: true });
    fs.writeFileSync(path.join(outDir, 'teamcounts.inc'), lines.join('\n'));
}

const target = process.argv[2] || 'retail';
if (!TARGETS[target]) {
    console.error(`prebuild: unknown target '${target}'. Use one of: ${Object.keys(TARGETS).join(', ')}`);
    process.exit(1);
}

// 1. The ROM this build needs (for 'any', the first known ROM present).
const candidates = TARGETS[target].map((id) => ROMS[id]);
let romPath = null;
const problems = [];
for (const rom of candidates) {
    const r = checkRom(rom);
    if (r.ok) { romPath = r.path; break; }
    problems.push({ rom, r });
}
if (!romPath) {
    const lines = [];
    const wrong = problems.filter((x) => x.r.reason === 'wrong');
    for (const { rom, r } of wrong) {
        lines.push(`Found ${r.path}, but it is not the right ROM:`);
        lines.push(`    its SHA-1 is ${r.sha1}, size ${sizeText(r.size)}.`);
        lines.push('    (a bad dump, a hack, another revision, or a byte-swapped / interleaved file)');
    }
    lines.push(candidates.length > 1
        ? `This build needs one of these ROMs, each exactly the version shown:`
        : `This build needs this ROM, exactly the version shown:`);
    for (const rom of candidates) lines.push(romBlock(rom));
    stop(lines);
}

// 2. Extracted/ assets: extract again if missing or incomplete.
const why = extractedState();
if (!why) {
    writeTeamCounts();
    writeNames();
    console.log('prebuild: ROM OK, Extracted/ assets complete.');
    z80();
    process.exit(0);
}
console.log(`prebuild: ${why}; extracting assets from ${path.relative(ROOT, romPath)} ...`);
const res = spawnSync(process.execPath, [path.join(ROOT, EXTRACTOR), romPath], { cwd: ROOT, encoding: 'utf8', maxBuffer: 64 * 1024 * 1024 });
const out = (res.stdout || '') + (res.stderr || '');
const after = res.status === 0 ? extractedState() : 'the extractor failed';
if (after) {
    console.error(out);
    console.error(`*** BUILD STOPPED: asset extraction failed (${after}) ***`);
    process.exit(1);
}
const summary = out.split(/\r?\n/).filter((l) => /^ROM:|^Extracted \d+ (assets|slices)/.test(l));
for (const l of summary) console.log('prebuild: ' + l);
writeTeamCounts();
writeNames();
console.log('prebuild: Extracted/ assets complete.');
z80();
