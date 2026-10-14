// patchchecksum.js: write the ROM sum over the cmpi.l immediate in ValidationRoutine.
// Sum every long below that routine, skip the header long at $18C, and leave the
// header checksum word alone. The source keeps the retail immediate, so a segment
// build is not patched. Usage: node tools/patchchecksum.js output/modified_nhl95.bin

const fs = require('fs');

function patchChecksum(bin) {
let routine = -1;
for (let i = 0; i + 10 <= bin.length; i++) {
    if (bin[i] !== 0x70 || bin[i + 1] !== 0x00 || bin[i + 2] !== 0x91 || bin[i + 3] !== 0xC8) continue;
    if (bin[i + 4] !== 0x22 || bin[i + 5] !== 0x3C) continue;
    const count = bin.readUInt32BE(i + 6);
    if (count === (i >>> 2)) {
        routine = i;
        break;
    }
}
if (routine < 0) {
    throw new Error('patchchecksum: ValidationRoutine not found');
}

let sum = 0;
for (let a = 0; a + 4 <= routine; a += 4) {
    if (a === 0x18C) continue;
    sum = (sum + bin.readUInt32BE(a)) >>> 0;
}

let cmp = -1;
const limit = Math.min(bin.length - 6, routine + 48);
for (let i = routine; i <= limit; i++) {
    if (bin[i] === 0x0C && bin[i + 1] === 0x80) {
        cmp = i;
        break;
    }
}
if (cmp < 0) {
    throw new Error('patchchecksum: cmpi.l not found');
}

const oldSum = bin.readUInt32BE(cmp + 2);
bin.writeUInt32BE(sum, cmp + 2);
return { oldSum, sum };
}

function main() {
const file = process.argv[2];
if (!file) {
    console.error('usage: node tools/patchchecksum.js <bin>');
    process.exit(1);
}
const bin = fs.readFileSync(file);
const { oldSum, sum } = patchChecksum(bin);
fs.writeFileSync(file, bin);

const hex = (n) => n.toString(16).padStart(8, '0');
console.log(`checksum ${hex(oldSum)} -> ${hex(sum)}`);
const headerEnd = bin.readUInt32BE(0x1A4);
console.log(`header end $${headerEnd.toString(16).padStart(8, '0').toUpperCase()}`);
}

module.exports = { patchChecksum };

if (require.main === module) main();
