// buildZ80.js: assemble the old Z80 sound driver (src/sound/z80_snd_drv93.asm, the 93 / 94 driver that
// p_initialZ80 would load) with asm80 (npm devDependency, pinned) into output/z80_snd_drv93.bin, which
// src/sound/z80old95.asm includes, and check it against the ROM bytes extracted to
// Extracted/NHL95/Sound/z80_snd_drv93.bin (ROM $7E0E0-$7E36A). Z80 $278-$27C, the FM patch address operands
// that z80old95.asm writes from fm_instrument_patches, are not compared.
// tools/prebuild.js runs it before every build (npm scripts, and tools/verify_all.sh with Linux node).
// Usage: node tools/buildZ80.js   (exit 1 on an asm80 error or a mismatch)
const fs = require('fs');
const path = require('path');
const { spawnSync } = require('child_process');

const ROOT = path.join(__dirname, '..');
const SRC = path.join(ROOT, 'src', 'sound', 'z80_snd_drv93.asm');
const OUT = path.join(ROOT, 'output', 'z80_snd_drv93.bin');
const REF = path.join(ROOT, 'Extracted', 'NHL95', 'Sound', 'z80_snd_drv93.bin');
const PATCH_FROM = 0x278, PATCH_TO = 0x27C;

function buildZ80() {
    let asm80;
    try { asm80 = require.resolve('asm80/asm80.js'); } catch (e) {
        return { ok: false, msg: 'asm80 is not installed, run npm i' };
    }
    fs.mkdirSync(path.dirname(OUT), { recursive: true });
    fs.rmSync(OUT, { force: true });
    const r = spawnSync(process.execPath, [asm80, '-m', 'Z80', '-t', 'bin', '-o', path.relative(path.dirname(SRC), OUT), path.relative(ROOT, SRC)],
        { cwd: ROOT, encoding: 'utf8' });
    const out = (r.stdout || '') + (r.stderr || '');
    fs.writeFileSync(path.join(ROOT, 'output', 'Build_z80_snd_drv93.log'), out);
    if (r.status !== 0 || !fs.existsSync(OUT) || /ERROR/.test(out)) return { ok: false, msg: 'asm80 failed, see output/Build_z80_snd_drv93.log\n' + out.split(/\r?\n/).slice(-12).join('\n') };
    const built = fs.readFileSync(OUT);
    const ref = fs.readFileSync(REF);
    let i = 0;
    while (i < built.length && i < ref.length && (built[i] === ref[i] || (i >= PATCH_FROM && i <= PATCH_TO))) i++;
    if (built.length !== ref.length || i < built.length)
        return { ok: false, msg: `output/z80_snd_drv93.bin (${built.length} bytes) differs from the ROM bytes (${ref.length} bytes) at Z80 $${i.toString(16).toUpperCase()}` };
    return { ok: true, msg: `z80: MATCH ${built.length} bytes (except the FM patch address at $278-$27C) == ROM $7E0E0-$7E36A -> output/z80_snd_drv93.bin` };
}
module.exports = buildZ80;
if (require.main === module) {
    const r = buildZ80();
    (r.ok ? console.log : console.error)(r.msg);
    process.exit(r.ok ? 0 : 1);
}
