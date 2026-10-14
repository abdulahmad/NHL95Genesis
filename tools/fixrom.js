// fixrom.js: post-build fix for a ROM that may have grown past the retail 2 MB.
//   1. pad with $FF to the next size the cartridge hardware accepts (1, 1.5, 2 or 4 MB),
//   2. write the header ROM end ($1A4) as that size - 1,
//   3. write the boot checksum (tools/patchchecksum.js).
// The stock build stays 2 MB and byte-identical. Usage: node tools/fixrom.js output/modified_nhl95.bin
// See docs/EXPANDING_THE_ROM.md.

const fs = require('fs');
const { patchChecksum } = require('./patchchecksum');

const SIZES = [0x100000, 0x180000, 0x200000, 0x400000];
const ROM_END = 0x1a4;
const BACKUP_RAM = 0x200000;

const file = process.argv[2];
if (!file) {
    console.error('usage: node tools/fixrom.js <bin>');
    process.exit(1);
}
let bin = fs.readFileSync(file);
const size = SIZES.find((s) => bin.length <= s);
if (!size) {
    console.error(`fixrom: ROM is ${bin.length} bytes; larger than 4 MB needs a mapper (docs/EXPANDING_THE_ROM.md)`);
    process.exit(1);
}
if (size > BACKUP_RAM) console.warn('fixrom: warning: the ROM overlaps the backup RAM window at $200000 (docs/EXPANDING_THE_ROM.md)');
if (bin.length < size) bin = Buffer.concat([bin, Buffer.alloc(size - bin.length, 0xff)]);
bin.writeUInt32BE(size - 1, ROM_END);
const { oldSum, sum } = patchChecksum(bin);
fs.writeFileSync(file, bin);
const hex = (n) => n.toString(16).padStart(8, '0');
console.log(`size ${hex(size)} (header end ${hex(size - 1)}), checksum ${hex(oldSum)} -> ${hex(sum)}`);
