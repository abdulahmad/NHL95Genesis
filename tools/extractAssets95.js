// NHL 95 asset extractor.
// Usage: node tools/extractAssets95.js lst/nhl95.bin
// Add a slice only after the listing label and the retail range are confirmed.
// It also writes Extracted/PlayerNames.txt and Extracted/TeamNicknames.txt: the real NHLPA player names and NHL team nicknames, one
// per line in the order of the rows of src/teamdata95.asm, which holds placeholders; tools/prebuild.js (writeNames) puts them
// back into the copies of the source that are assembled.
const fs = require('fs');
const path = require('path');
const ROOT = path.join(__dirname, '..');
// No argument (or an id: retail): the ROM in the repo folder, found by its SHA-1 and size (tools/roms.js).
const romArg = process.argv[2];
const romPath = romArg && fs.existsSync(romArg) ? romArg : (require('./roms').romPath(romArg || 'retail') || romArg || path.join(ROOT, 'nhl95retail.bin'));
if (!fs.existsSync(romPath)) {
  console.error('Missing ' + romPath + '. Put the retail ROM in the repo folder first (any file name).');
  process.exit(1);
}

// Known retail ROMs. NHL 95 had one retail release (1994.JUL, GM T-50856 -00); slices are
// at its addresses. A new version goes here with its SHA-1 and a map from retail address to its own.
const VERSIONS = [
  { id: 'retail', label: 'NHL 95 retail (1994.JUL, GM T-50856 -00)', file: 'lst/nhl95.bin',
    sha1: '09e87b076aa4cd6f057a1d65bb50fd889b509b44', size: 0x200000, serial: 'GM T-50856 -00',
    map: (a) => a },
];

// Find the version of a ROM by SHA-1. Size and header are only used to explain a refusal.
function detectVersion(data) {
  const sha1 = require('crypto').createHash('sha1').update(data).digest('hex');
  const v = VERSIONS.find((x) => x.sha1 === sha1);
  if (v) return v;
  const date = data.subarray(0x118, 0x120).toString('latin1');
  const serial = data.subarray(0x180, 0x18E).toString('latin1');
  const near = VERSIONS.find((x) => x.size === data.length && x.serial === serial);
  let msg = `Unknown ROM ${romPath}: SHA-1 ${sha1}, ${data.length} bytes, header date '${date}', serial '${serial}'.\n`;
  if (near) msg += `Header matches ${near.label}, but the SHA-1 does not (bad dump, hack, or byte-swapped/interleaved file?).\n`;
  msg += 'Supported ROMs:\n' + VERSIONS.map((x) => `  ${x.label}: SHA-1 ${x.sha1} (${x.file})`).join('\n');
  console.error(msg + '\nAborting extraction.');
  process.exit(1);
}
// Slices: name, folder under Extracted, start, end (exclusive).
const assets = [
    // NHL 95 team palettes, src/teamdata95.asm .pad of each team block (block + $C): home then visitor, 32 bytes each, in ROM order.
    // Every one differs from 94, so each is the 94 file stem (93 stem for MIN / LI / NY / TBY) with 95 added.
    { name: 'ASEh95.pal', folder: 'NHL95/Graphics/Pals', start: 0x000007EE, end: 0x0000080E }, // ASE home
    { name: 'ASEv95.pal', folder: 'NHL95/Graphics/Pals', start: 0x0000080E, end: 0x0000082E }, // ASE visitor
    { name: 'ASWh95.pal', folder: 'NHL95/Graphics/Pals', start: 0x00000ABE, end: 0x00000ADE }, // ASW home
    { name: 'ASWv95.pal', folder: 'NHL95/Graphics/Pals', start: 0x00000ADE, end: 0x00000AFE }, // ASW visitor
    { name: 'ANHh95.pal', folder: 'NHL95/Graphics/Pals', start: 0x00000D72, end: 0x00000D92 }, // ANH home
    { name: 'ANHv95.pal', folder: 'NHL95/Graphics/Pals', start: 0x00000D92, end: 0x00000DB2 }, // ANH visitor
    { name: 'BOSh95.pal', folder: 'NHL95/Graphics/Pals', start: 0x00001036, end: 0x00001056 }, // BOS home
    { name: 'BOSv95.pal', folder: 'NHL95/Graphics/Pals', start: 0x00001056, end: 0x00001076 }, // BOS visitor
    { name: 'BUFh95.pal', folder: 'NHL95/Graphics/Pals', start: 0x00001310, end: 0x00001330 }, // BUF home
    { name: 'BUFv95.pal', folder: 'NHL95/Graphics/Pals', start: 0x00001330, end: 0x00001350 }, // BUF visitor
    { name: 'CGYh95.pal', folder: 'NHL95/Graphics/Pals', start: 0x000015EC, end: 0x0000160C }, // CGY home
    { name: 'CGYv95.pal', folder: 'NHL95/Graphics/Pals', start: 0x0000160C, end: 0x0000162C }, // CGY visitor
    { name: 'CHIh95.pal', folder: 'NHL95/Graphics/Pals', start: 0x000018CA, end: 0x000018EA }, // CHI home
    { name: 'CHIv95.pal', folder: 'NHL95/Graphics/Pals', start: 0x000018EA, end: 0x0000190A }, // CHI visitor
    { name: 'DETh95.pal', folder: 'NHL95/Graphics/Pals', start: 0x00001BAA, end: 0x00001BCA }, // DET home
    { name: 'DETv95.pal', folder: 'NHL95/Graphics/Pals', start: 0x00001BCA, end: 0x00001BEA }, // DET visitor
    { name: 'EDMh95.pal', folder: 'NHL95/Graphics/Pals', start: 0x00001EA8, end: 0x00001EC8 }, // EDM home
    { name: 'EDMv95.pal', folder: 'NHL95/Graphics/Pals', start: 0x00001EC8, end: 0x00001EE8 }, // EDM visitor
    { name: 'FLAh95.pal', folder: 'NHL95/Graphics/Pals', start: 0x0000219A, end: 0x000021BA }, // FLA home
    { name: 'FLAv95.pal', folder: 'NHL95/Graphics/Pals', start: 0x000021BA, end: 0x000021DA }, // FLA visitor
    { name: 'HFDh95.pal', folder: 'NHL95/Graphics/Pals', start: 0x0000247A, end: 0x0000249A }, // HFD home
    { name: 'HFDv95.pal', folder: 'NHL95/Graphics/Pals', start: 0x0000249A, end: 0x000024BA }, // HFD visitor
    { name: 'LAh95.pal', folder: 'NHL95/Graphics/Pals', start: 0x0000276E, end: 0x0000278E }, // LA home
    { name: 'LAv95.pal', folder: 'NHL95/Graphics/Pals', start: 0x0000278E, end: 0x000027AE }, // LA visitor
    { name: 'DALh95.pal', folder: 'NHL95/Graphics/Pals', start: 0x00002A30, end: 0x00002A50 }, // DAL home
    { name: 'DALv95.pal', folder: 'NHL95/Graphics/Pals', start: 0x00002A50, end: 0x00002A70 }, // DAL visitor
    { name: 'MTLh95.pal', folder: 'NHL95/Graphics/Pals', start: 0x00002D04, end: 0x00002D24 }, // MTL home
    { name: 'MTLv95.pal', folder: 'NHL95/Graphics/Pals', start: 0x00002D24, end: 0x00002D44 }, // MTL visitor
    { name: 'NJh95.pal', folder: 'NHL95/Graphics/Pals', start: 0x00002FF4, end: 0x00003014 }, // NJ home
    { name: 'NJv95.pal', folder: 'NHL95/Graphics/Pals', start: 0x00003014, end: 0x00003034 }, // NJ visitor
    { name: 'NYIh95.pal', folder: 'NHL95/Graphics/Pals', start: 0x000032E6, end: 0x00003306 }, // NYI home
    { name: 'NYIv95.pal', folder: 'NHL95/Graphics/Pals', start: 0x00003306, end: 0x00003326 }, // NYI visitor
    { name: 'NYRh95.pal', folder: 'NHL95/Graphics/Pals', start: 0x000035D2, end: 0x000035F2 }, // NYR home
    { name: 'NYRv95.pal', folder: 'NHL95/Graphics/Pals', start: 0x000035F2, end: 0x00003612 }, // NYR visitor
    { name: 'OTWh95.pal', folder: 'NHL95/Graphics/Pals', start: 0x000038B4, end: 0x000038D4 }, // OTW home
    { name: 'OTWv95.pal', folder: 'NHL95/Graphics/Pals', start: 0x000038D4, end: 0x000038F4 }, // OTW visitor
    { name: 'PHIh95.pal', folder: 'NHL95/Graphics/Pals', start: 0x00003BAA, end: 0x00003BCA }, // PHI home
    { name: 'PHIv95.pal', folder: 'NHL95/Graphics/Pals', start: 0x00003BCA, end: 0x00003BEA }, // PHI visitor
    { name: 'PITh95.pal', folder: 'NHL95/Graphics/Pals', start: 0x00003E88, end: 0x00003EA8 }, // PIT home
    { name: 'PITv95.pal', folder: 'NHL95/Graphics/Pals', start: 0x00003EA8, end: 0x00003EC8 }, // PIT visitor
    { name: 'QUEh95.pal', folder: 'NHL95/Graphics/Pals', start: 0x00004178, end: 0x00004198 }, // QUE home
    { name: 'QUEv95.pal', folder: 'NHL95/Graphics/Pals', start: 0x00004198, end: 0x000041B8 }, // QUE visitor
    { name: 'SJh95.pal', folder: 'NHL95/Graphics/Pals', start: 0x0000445E, end: 0x0000447E }, // SJ home
    { name: 'SJv95.pal', folder: 'NHL95/Graphics/Pals', start: 0x0000447E, end: 0x0000449E }, // SJ visitor
    { name: 'STLh95.pal', folder: 'NHL95/Graphics/Pals', start: 0x00004722, end: 0x00004742 }, // STL home
    { name: 'STLv95.pal', folder: 'NHL95/Graphics/Pals', start: 0x00004742, end: 0x00004762 }, // STL visitor
    { name: 'TBh95.pal', folder: 'NHL95/Graphics/Pals', start: 0x00004A0A, end: 0x00004A2A }, // TB home
    { name: 'TBv95.pal', folder: 'NHL95/Graphics/Pals', start: 0x00004A2A, end: 0x00004A4A }, // TB visitor
    { name: 'TORh95.pal', folder: 'NHL95/Graphics/Pals', start: 0x00004CC2, end: 0x00004CE2 }, // TOR home
    { name: 'TORv95.pal', folder: 'NHL95/Graphics/Pals', start: 0x00004CE2, end: 0x00004D02 }, // TOR visitor
    { name: 'VANh95.pal', folder: 'NHL95/Graphics/Pals', start: 0x00004FB4, end: 0x00004FD4 }, // VAN home
    { name: 'VANv95.pal', folder: 'NHL95/Graphics/Pals', start: 0x00004FD4, end: 0x00004FF4 }, // VAN visitor
    { name: 'WPGh95.pal', folder: 'NHL95/Graphics/Pals', start: 0x0000529A, end: 0x000052BA }, // WPG home
    { name: 'WPGv95.pal', folder: 'NHL95/Graphics/Pals', start: 0x000052BA, end: 0x000052DA }, // WPG visitor
    { name: 'WSHh95.pal', folder: 'NHL95/Graphics/Pals', start: 0x00005562, end: 0x00005582 }, // WSH home
    { name: 'WSHv95.pal', folder: 'NHL95/Graphics/Pals', start: 0x00005582, end: 0x000055A2 }, // WSH visitor
    // NHL 95 revframetbl, src/frames95.asm after the SPA tables: one word per sprite frame (1057), the frame RestoreReplayFrame shows for a reverse angle replay.
    // 94 kept it at the end of graphics94 (NHL94/Graphics/revframetbl.bin, 880 words).
    { name: 'revframetbl.bin', folder: 'NHL95/Graphics', start: 0x00008596, end: 0x00008DD8 }, // revframetbl
    // NHL 95 ScoutTextScript (scout95): the scouting text lines, each ended by $D, $FF after the last (94: NHL94/Text/ScoutTextScript.bin)
    { name: 'ScoutTextScript.bin', folder: 'NHL95/Text', start: 0x000A0718, end: 0x000A08DC }, // ScoutTextScript
    // NHL 95 NewYorkITxt / NewYorkRTxt (setup95): the full names of the two New York teams, each a String ($14 bytes: length word, 'New York ', the
    // nickname, the Rangers one padded with two spaces). They hold licensed nicknames, so setup95.asm incbins them from here.
    { name: 'NewYorkIFull.bin', folder: 'NHL95/Text', start: 0x00086578, end: 0x0008658C }, // NewYorkITxt
    { name: 'NewYorkRFull.bin', folder: 'NHL95/Text', start: 0x0008658C, end: 0x000865A0 }, // NewYorkRTxt
    // NHL 95 sound driver data, src/sound/sound95.asm: the Z80 program ($BD86, $1B63 bytes loaded by SndLoadZ80, plus its last byte $FF),
    // then the items of the sound bank at $D8EC (SoundBanks) in bank order, named by item type and id.
    { name: 'z80_snd_drv95.bin', folder: 'NHL95/Sound', start: 0x0000BD86, end: 0x0000D8EA }, // Z80Program
    { name: 'snd95_patch_00.bin', folder: 'NHL95/Sound/Bank', start: 0x0000DB22, end: 0x0000DB27 }, // patch 0
    { name: 'snd95_patch_01.bin', folder: 'NHL95/Sound/Bank', start: 0x0000DB27, end: 0x0000DB2C }, // patch 1
    { name: 'snd95_patch_02.bin', folder: 'NHL95/Sound/Bank', start: 0x0000DB2C, end: 0x0000DB31 }, // patch 2
    { name: 'snd95_patch_03.bin', folder: 'NHL95/Sound/Bank', start: 0x0000DB31, end: 0x0000DB36 }, // patch 3
    { name: 'snd95_patch_04.bin', folder: 'NHL95/Sound/Bank', start: 0x0000DB36, end: 0x0000DB3B }, // patch 4
    { name: 'snd95_patch_05.bin', folder: 'NHL95/Sound/Bank', start: 0x0000DB3B, end: 0x0000DB40 }, // patch 5
    { name: 'snd95_patch_06.bin', folder: 'NHL95/Sound/Bank', start: 0x0000DB40, end: 0x0000DB45 }, // patch 6
    { name: 'snd95_patch_07.bin', folder: 'NHL95/Sound/Bank', start: 0x0000DB45, end: 0x0000DB4A }, // patch 7
    { name: 'snd95_patch_08.bin', folder: 'NHL95/Sound/Bank', start: 0x0000DB4A, end: 0x0000DB4F }, // patch 8
    { name: 'snd95_patch_09.bin', folder: 'NHL95/Sound/Bank', start: 0x0000DB4F, end: 0x0000DB54 }, // patch 9
    { name: 'snd95_patch_0A.bin', folder: 'NHL95/Sound/Bank', start: 0x0000DB54, end: 0x0000DB59 }, // patch 10
    { name: 'snd95_patch_0B.bin', folder: 'NHL95/Sound/Bank', start: 0x0000DB59, end: 0x0000DB80 }, // patch 11
    { name: 'snd95_patch_0C.bin', folder: 'NHL95/Sound/Bank', start: 0x0000DB80, end: 0x0000DB85 }, // patch 12
    { name: 'snd95_patch_0D.bin', folder: 'NHL95/Sound/Bank', start: 0x0000DB85, end: 0x0000DBAC }, // patch 13
    { name: 'snd95_patch_0E.bin', folder: 'NHL95/Sound/Bank', start: 0x0000DBAC, end: 0x0000DBD3 }, // patch 14
    { name: 'snd95_patch_11.bin', folder: 'NHL95/Sound/Bank', start: 0x0000DBD3, end: 0x0000DBFA }, // patch 17
    { name: 'snd95_patch_13.bin', folder: 'NHL95/Sound/Bank', start: 0x0000DBFA, end: 0x0000DC0A }, // patch 19
    { name: 'snd95_patch_14.bin', folder: 'NHL95/Sound/Bank', start: 0x0000DC0A, end: 0x0000DC1A }, // patch 20
    { name: 'snd95_patch_15.bin', folder: 'NHL95/Sound/Bank', start: 0x0000DC1A, end: 0x0000DC41 }, // patch 21
    { name: 'snd95_patch_16.bin', folder: 'NHL95/Sound/Bank', start: 0x0000DC41, end: 0x0000DC68 }, // patch 22
    { name: 'snd95_patch_18.bin', folder: 'NHL95/Sound/Bank', start: 0x0000DC68, end: 0x0000DC8F }, // patch 24
    { name: 'snd95_patch_19.bin', folder: 'NHL95/Sound/Bank', start: 0x0000DC8F, end: 0x0000DCB6 }, // patch 25
    { name: 'snd95_patch_1B.bin', folder: 'NHL95/Sound/Bank', start: 0x0000DCB6, end: 0x0000DCDD }, // patch 27
    { name: 'snd95_patch_1C.bin', folder: 'NHL95/Sound/Bank', start: 0x0000DCDD, end: 0x0000DD04 }, // patch 28
    { name: 'snd95_patch_1D.bin', folder: 'NHL95/Sound/Bank', start: 0x0000DD04, end: 0x0000DD2B }, // patch 29
    { name: 'snd95_patch_33.bin', folder: 'NHL95/Sound/Bank', start: 0x0000DD2B, end: 0x0000DD30 }, // patch 51
    { name: 'snd95_patch_36.bin', folder: 'NHL95/Sound/Bank', start: 0x0000DD30, end: 0x0000DD35 }, // patch 54
    { name: 'snd95_patch_38.bin', folder: 'NHL95/Sound/Bank', start: 0x0000DD35, end: 0x0000DD3A }, // patch 56
    { name: 'snd95_patch_39.bin', folder: 'NHL95/Sound/Bank', start: 0x0000DD3A, end: 0x0000DD3F }, // patch 57
    { name: 'snd95_patch_3B.bin', folder: 'NHL95/Sound/Bank', start: 0x0000DD3F, end: 0x0000DD44 }, // patch 59
    { name: 'snd95_patch_3D.bin', folder: 'NHL95/Sound/Bank', start: 0x0000DD44, end: 0x0000DD49 }, // patch 61
    { name: 'snd95_patch_3E.bin', folder: 'NHL95/Sound/Bank', start: 0x0000DD49, end: 0x0000DD70 }, // patch 62
    { name: 'snd95_patch_3F.bin', folder: 'NHL95/Sound/Bank', start: 0x0000DD70, end: 0x0000DD97 }, // patch 63
    { name: 'snd95_patch_40.bin', folder: 'NHL95/Sound/Bank', start: 0x0000DD97, end: 0x0000DDBE }, // patch 64
    { name: 'snd95_patch_41.bin', folder: 'NHL95/Sound/Bank', start: 0x0000DDBE, end: 0x0000DDC3 }, // patch 65
    { name: 'snd95_patch_42.bin', folder: 'NHL95/Sound/Bank', start: 0x0000DDC3, end: 0x0000DDC8 }, // patch 66
    { name: 'snd95_patch_43.bin', folder: 'NHL95/Sound/Bank', start: 0x0000DDC8, end: 0x0000DDCD }, // patch 67
    { name: 'snd95_patch_44.bin', folder: 'NHL95/Sound/Bank', start: 0x0000DDCD, end: 0x0000DDD2 }, // patch 68
    { name: 'snd95_patch_45.bin', folder: 'NHL95/Sound/Bank', start: 0x0000DDD2, end: 0x0000DDF9 }, // patch 69
    { name: 'snd95_patch_46.bin', folder: 'NHL95/Sound/Bank', start: 0x0000DDF9, end: 0x0000DDFE }, // patch 70
    { name: 'snd95_patch_47.bin', folder: 'NHL95/Sound/Bank', start: 0x0000DDFE, end: 0x0000DE25 }, // patch 71
    { name: 'snd95_patch_48.bin', folder: 'NHL95/Sound/Bank', start: 0x0000DE25, end: 0x0000DE2A }, // patch 72
    { name: 'snd95_patch_49.bin', folder: 'NHL95/Sound/Bank', start: 0x0000DE2A, end: 0x0000DE51 }, // patch 73
    { name: 'snd95_sample_00.bin', folder: 'NHL95/Sound/Bank', start: 0x0000DE51, end: 0x0000FF94 }, // sample 0
    { name: 'snd95_sample_01.bin', folder: 'NHL95/Sound/Bank', start: 0x0000FF94, end: 0x000101BB }, // sample 1
    { name: 'snd95_sample_02.bin', folder: 'NHL95/Sound/Bank', start: 0x000101BB, end: 0x00012286 }, // sample 2
    { name: 'snd95_sample_03.bin', folder: 'NHL95/Sound/Bank', start: 0x00012286, end: 0x00012AE9 }, // sample 3
    { name: 'snd95_sample_04.bin', folder: 'NHL95/Sound/Bank', start: 0x00012AE9, end: 0x000134EC }, // sample 4
    { name: 'snd95_sample_05.bin', folder: 'NHL95/Sound/Bank', start: 0x000134EC, end: 0x000143F5 }, // sample 5
    { name: 'snd95_sample_06.bin', folder: 'NHL95/Sound/Bank', start: 0x000143F5, end: 0x00015318 }, // sample 6
    { name: 'snd95_sample_07.bin', folder: 'NHL95/Sound/Bank', start: 0x00015318, end: 0x000161DB }, // sample 7
    { name: 'snd95_sample_08.bin', folder: 'NHL95/Sound/Bank', start: 0x000161DB, end: 0x000172AE }, // sample 8
    { name: 'snd95_sample_09.bin', folder: 'NHL95/Sound/Bank', start: 0x000172AE, end: 0x000175DD }, // sample 9
    { name: 'snd95_sample_0A.bin', folder: 'NHL95/Sound/Bank', start: 0x000175DD, end: 0x00017930 }, // sample 10
    { name: 'snd95_sample_0B.bin', folder: 'NHL95/Sound/Bank', start: 0x00017930, end: 0x00018EF2 }, // sample 11
    { name: 'snd95_sample_0C.bin', folder: 'NHL95/Sound/Bank', start: 0x00018EF2, end: 0x00019F37 }, // sample 12
    { name: 'snd95_sample_0E.bin', folder: 'NHL95/Sound/Bank', start: 0x00019F37, end: 0x00023AFA }, // sample 14
    { name: 'snd95_sample_10.bin', folder: 'NHL95/Sound/Bank', start: 0x00023AFA, end: 0x00032723 }, // sample 16
    { name: 'snd95_sample_11.bin', folder: 'NHL95/Sound/Bank', start: 0x00032723, end: 0x00034C4B }, // sample 17
    { name: 'snd95_sample_13.bin', folder: 'NHL95/Sound/Bank', start: 0x00034C4B, end: 0x0003A419 }, // sample 19
    { name: 'snd95_sample_15.bin', folder: 'NHL95/Sound/Bank', start: 0x0003A419, end: 0x0003C2E2 }, // sample 21
    { name: 'snd95_sample_16.bin', folder: 'NHL95/Sound/Bank', start: 0x0003C2E2, end: 0x00049365 }, // sample 22
    { name: 'snd95_sample_17.bin', folder: 'NHL95/Sound/Bank', start: 0x00049365, end: 0x0004DB35 }, // sample 23
    { name: 'snd95_sample_18.bin', folder: 'NHL95/Sound/Bank', start: 0x0004DB35, end: 0x0004F038 }, // sample 24
    { name: 'snd95_sample_19.bin', folder: 'NHL95/Sound/Bank', start: 0x0004F038, end: 0x00050B7B }, // sample 25
    { name: 'snd95_sample_1B.bin', folder: 'NHL95/Sound/Bank', start: 0x00050B7B, end: 0x0005239D }, // sample 27
    { name: 'snd95_sample_1D.bin', folder: 'NHL95/Sound/Bank', start: 0x0005239D, end: 0x000525CF }, // sample 29
    { name: 'snd95_song_00.bin', folder: 'NHL95/Sound/Bank', start: 0x000525CF, end: 0x00056CCA }, // song 0
    { name: 'snd95_song_01.bin', folder: 'NHL95/Sound/Bank', start: 0x00056CCA, end: 0x0005984C }, // song 1
    { name: 'snd95_song_02.bin', folder: 'NHL95/Sound/Bank', start: 0x0005984C, end: 0x0005CDD3 }, // song 2
    { name: 'snd95_song_03.bin', folder: 'NHL95/Sound/Bank', start: 0x0005CDD3, end: 0x00060D06 }, // song 3
    { name: 'snd95_song_04.bin', folder: 'NHL95/Sound/Bank', start: 0x00060D06, end: 0x00060D12 }, // song 4
    { name: 'snd95_song_05.bin', folder: 'NHL95/Sound/Bank', start: 0x00060D12, end: 0x00060D1E }, // song 5
    { name: 'snd95_song_06.bin', folder: 'NHL95/Sound/Bank', start: 0x00060D1E, end: 0x00060D2A }, // song 6
    { name: 'snd95_song_07.bin', folder: 'NHL95/Sound/Bank', start: 0x00060D2A, end: 0x00060D36 }, // song 7
    { name: 'snd95_song_08.bin', folder: 'NHL95/Sound/Bank', start: 0x00060D36, end: 0x00060D42 }, // song 8
    { name: 'snd95_song_09.bin', folder: 'NHL95/Sound/Bank', start: 0x00060D42, end: 0x00060D4E }, // song 9
    { name: 'snd95_song_0A.bin', folder: 'NHL95/Sound/Bank', start: 0x00060D4E, end: 0x00060D5A }, // song 10
    { name: 'snd95_song_0B.bin', folder: 'NHL95/Sound/Bank', start: 0x00060D5A, end: 0x00060D66 }, // song 11
    { name: 'snd95_song_0E.bin', folder: 'NHL95/Sound/Bank', start: 0x00060D66, end: 0x00060D74 }, // song 14
    { name: 'snd95_song_10.bin', folder: 'NHL95/Sound/Bank', start: 0x00060D74, end: 0x00060D82 }, // song 16
    { name: 'snd95_song_11.bin', folder: 'NHL95/Sound/Bank', start: 0x00060D82, end: 0x00060D8E }, // song 17
    { name: 'snd95_song_13.bin', folder: 'NHL95/Sound/Bank', start: 0x00060D8E, end: 0x00060D9A }, // song 19
    { name: 'snd95_song_15.bin', folder: 'NHL95/Sound/Bank', start: 0x00060D9A, end: 0x00060DA6 }, // song 21
    { name: 'snd95_song_16.bin', folder: 'NHL95/Sound/Bank', start: 0x00060DA6, end: 0x00060E0A }, // song 22
    { name: 'snd95_song_17.bin', folder: 'NHL95/Sound/Bank', start: 0x00060E0A, end: 0x00060E5E }, // song 23
    { name: 'snd95_song_18.bin', folder: 'NHL95/Sound/Bank', start: 0x00060E5E, end: 0x00060E6A }, // song 24
    { name: 'snd95_song_19.bin', folder: 'NHL95/Sound/Bank', start: 0x00060E6A, end: 0x00060E76 }, // song 25
    { name: 'snd95_song_1A.bin', folder: 'NHL95/Sound/Bank', start: 0x00060E76, end: 0x00060E82 }, // song 26
    { name: 'snd95_song_1B.bin', folder: 'NHL95/Sound/Bank', start: 0x00060E82, end: 0x00060E8E }, // song 27
    { name: 'snd95_song_1C.bin', folder: 'NHL95/Sound/Bank', start: 0x00060E8E, end: 0x00060E9A }, // song 28
    { name: 'snd95_song_1D.bin', folder: 'NHL95/Sound/Bank', start: 0x00060E9A, end: 0x00060EA6 }, // song 29
    { name: 'snd95_song_1E.bin', folder: 'NHL95/Sound/Bank', start: 0x00060EA6, end: 0x00060EB4 }, // song 30
    { name: 'snd95_song_20.bin', folder: 'NHL95/Sound/Bank', start: 0x00060EB4, end: 0x00060EC0 }, // song 32
    { name: 'snd95_song_21.bin', folder: 'NHL95/Sound/Bank', start: 0x00060EC0, end: 0x00060ECC }, // song 33
    { name: 'snd95_song_22.bin', folder: 'NHL95/Sound/Bank', start: 0x00060ECC, end: 0x00060ED8 }, // song 34
    { name: 'snd95_song_23.bin', folder: 'NHL95/Sound/Bank', start: 0x00060ED8, end: 0x00060EE4 }, // song 35
    { name: 'snd95_song_24.bin', folder: 'NHL95/Sound/Bank', start: 0x00060EE4, end: 0x00060EF0 }, // song 36
    { name: 'snd95_song_25.bin', folder: 'NHL95/Sound/Bank', start: 0x00060EF0, end: 0x00060EFC }, // song 37
    { name: 'snd95_song_26.bin', folder: 'NHL95/Sound/Bank', start: 0x00060EFC, end: 0x00061217 }, // song 38
    { name: 'snd95_song_27.bin', folder: 'NHL95/Sound/Bank', start: 0x00061217, end: 0x0006122B }, // song 39
    { name: 'snd95_song_28.bin', folder: 'NHL95/Sound/Bank', start: 0x0006122B, end: 0x0006123F }, // song 40
    { name: 'snd95_song_29.bin', folder: 'NHL95/Sound/Bank', start: 0x0006123F, end: 0x0006124B }, // song 41
    { name: 'snd95_song_32.bin', folder: 'NHL95/Sound/Bank', start: 0x0006124B, end: 0x0006143D }, // song 50
    { name: 'snd95_song_33.bin', folder: 'NHL95/Sound/Bank', start: 0x0006143D, end: 0x00061921 }, // song 51
    { name: 'snd95_song_34.bin', folder: 'NHL95/Sound/Bank', start: 0x00061921, end: 0x00061B75 }, // song 52
    { name: 'snd95_song_35.bin', folder: 'NHL95/Sound/Bank', start: 0x00061B75, end: 0x00061E23 }, // song 53
    { name: 'snd95_song_36.bin', folder: 'NHL95/Sound/Bank', start: 0x00061E23, end: 0x0006213F }, // song 54
    { name: 'snd95_song_37.bin', folder: 'NHL95/Sound/Bank', start: 0x0006213F, end: 0x000623E7 }, // song 55
    { name: 'snd95_song_38.bin', folder: 'NHL95/Sound/Bank', start: 0x000623E7, end: 0x00062683 }, // song 56
    { name: 'snd95_song_39.bin', folder: 'NHL95/Sound/Bank', start: 0x00062683, end: 0x0006282F }, // song 57
    { name: 'snd95_song_3A.bin', folder: 'NHL95/Sound/Bank', start: 0x0006282F, end: 0x00062C13 }, // song 58
    { name: 'snd95_song_3B.bin', folder: 'NHL95/Sound/Bank', start: 0x00062C13, end: 0x00062E57 }, // song 59
    { name: 'snd95_song_3C.bin', folder: 'NHL95/Sound/Bank', start: 0x00062E57, end: 0x00062E87 }, // song 60
    { name: 'snd95_song_3D.bin', folder: 'NHL95/Sound/Bank', start: 0x00062E87, end: 0x0006328B }, // song 61
    { name: 'snd95_song_3E.bin', folder: 'NHL95/Sound/Bank', start: 0x0006328B, end: 0x000635CC }, // song 62
    { name: 'snd95_song_3F.bin', folder: 'NHL95/Sound/Bank', start: 0x000635CC, end: 0x000637D4 }, // song 63
    { name: 'snd95_song_40.bin', folder: 'NHL95/Sound/Bank', start: 0x000637D4, end: 0x00063A52 }, // song 64
    { name: 'snd95_song_41.bin', folder: 'NHL95/Sound/Bank', start: 0x00063A52, end: 0x00063DAA }, // song 65
    { name: 'snd95_song_42.bin', folder: 'NHL95/Sound/Bank', start: 0x00063DAA, end: 0x00063ED6 }, // song 66
    { name: 'snd95_song_43.bin', folder: 'NHL95/Sound/Bank', start: 0x00063ED6, end: 0x0006429A }, // song 67
    { name: 'snd95_song_44.bin', folder: 'NHL95/Sound/Bank', start: 0x0006429A, end: 0x000644A6 }, // song 68
    { name: 'snd95_song_45.bin', folder: 'NHL95/Sound/Bank', start: 0x000644A6, end: 0x0006471A }, // song 69
    { name: 'snd95_song_46.bin', folder: 'NHL95/Sound/Bank', start: 0x0006471A, end: 0x00064872 }, // song 70
    { name: 'snd95_song_47.bin', folder: 'NHL95/Sound/Bank', start: 0x00064872, end: 0x00064C2E }, // song 71
    { name: 'snd95_song_48.bin', folder: 'NHL95/Sound/Bank', start: 0x00064C2E, end: 0x00065052 }, // song 72
    { name: 'snd95_song_49.bin', folder: 'NHL95/Sound/Bank', start: 0x00065052, end: 0x00065452 }, // song 73
    { name: 'snd95_song_4A.bin', folder: 'NHL95/Sound/Bank', start: 0x00065452, end: 0x00065767 }, // song 74
    { name: 'snd95_song_4B.bin', folder: 'NHL95/Sound/Bank', start: 0x00065767, end: 0x00065ACC }, // song 75
    { name: 'snd95_song_4C.bin', folder: 'NHL95/Sound/Bank', start: 0x00065ACC, end: 0x00065E2F }, // song 76
    { name: 'snd95_song_4D.bin', folder: 'NHL95/Sound/Bank', start: 0x00065E2F, end: 0x000660F8 }, // song 77
    { name: 'snd95_song_4E.bin', folder: 'NHL95/Sound/Bank', start: 0x000660F8, end: 0x00066514 }, // song 78
    { name: 'snd95_song_4F.bin', folder: 'NHL95/Sound/Bank', start: 0x00066514, end: 0x000669A0 }, // song 79
    { name: 'snd95_song_50.bin', folder: 'NHL95/Sound/Bank', start: 0x000669A0, end: 0x00066BF5 }, // song 80
    { name: 'snd95_song_51.bin', folder: 'NHL95/Sound/Bank', start: 0x00066BF5, end: 0x00066E1F }, // song 81
    { name: 'snd95_song_52.bin', folder: 'NHL95/Sound/Bank', start: 0x00066E1F, end: 0x00066F0F }, // song 82
    { name: 'snd95_song_53.bin', folder: 'NHL95/Sound/Bank', start: 0x00066F0F, end: 0x00067183 }, // song 83
    { name: 'snd95_song_54.bin', folder: 'NHL95/Sound/Bank', start: 0x00067183, end: 0x00067257 }, // song 84
    { name: 'snd95_song_55.bin', folder: 'NHL95/Sound/Bank', start: 0x00067257, end: 0x00067680 }, // song 85
    { name: 'snd95_list_00.bin', folder: 'NHL95/Sound/Bank', start: 0x00067680, end: 0x00067699 }, // list 0
    { name: 'snd95_list_01.bin', folder: 'NHL95/Sound/Bank', start: 0x00067699, end: 0x000676D8 }, // list 1
    // NHL 95 sound95: the 94 PCM samples and FM patches (same bytes as the 94 files, 94 address + $4D2BA).
    { name: 'sfx_shotbh_pcm.bin', folder: 'NHL95/Sound', start: 0x0006834E, end: 0x00068542 }, // 94 file, same bytes (94 $1B094)
    { name: 'sfx_pass_pcm.bin', folder: 'NHL95/Sound', start: 0x00068542, end: 0x0006926F }, // 94 file, same bytes (94 $1B288)
    { name: 'sfx_oooh_pcm.bin', folder: 'NHL95/Sound', start: 0x00069270, end: 0x0006C4B4 }, // 94 file, same bytes (94 $1BFB6)
    { name: 'sfx_crowdboo_pcm.bin', folder: 'NHL95/Sound', start: 0x0006C4B4, end: 0x0006EA01 }, // 94 file, same bytes (94 $1F1FA)
    { name: 'sfx_check_pcm.bin', folder: 'NHL95/Sound', start: 0x0006EA02, end: 0x00070954 }, // 94 file, same bytes (94 $21748)
    { name: 'sfx_crowdcheer_pcm.bin', folder: 'NHL95/Sound', start: 0x00070954, end: 0x00073834 }, // 94 file, same bytes (94 $2369A)
    { name: 'sfx_bglass_pcm.bin', folder: 'NHL95/Sound', start: 0x00073834, end: 0x000772B3 }, // 94 file, same bytes (94 $2657A)
    { name: 'sfx_playerwall_pcm.bin', folder: 'NHL95/Sound', start: 0x000772B4, end: 0x00077764 }, // 94 file, same bytes (94 $29FFA)
    { name: 'sfx_check2_pcm.bin', folder: 'NHL95/Sound', start: 0x00077764, end: 0x00078193 }, // 94 file, same bytes (94 $2A4AA)
    { name: 'sfx_hithigh_pcm.bin', folder: 'NHL95/Sound', start: 0x00078194, end: 0x000786EA }, // 94 file, same bytes (94 $2AEDA)
    { name: 'sfx_shotfh_pcm.bin', folder: 'NHL95/Sound', start: 0x000786EA, end: 0x000792A2 }, // 94 file, same bytes (94 $2B430)
    { name: 'sfx_puckget_pcm.bin', folder: 'NHL95/Sound', start: 0x000792A2, end: 0x00079502 }, // 94 file, same bytes (94 $2BFE8)
    { name: 'fm_instrument_patches.bin', folder: 'NHL95/Sound', start: 0x00079502, end: 0x00079902 }, // 94 file, same bytes (94 $2C248)
    { name: 'z80_snd_drv93.bin', folder: 'NHL95/Sound', start: 0x0007E0E0, end: 0x0007E36B }, // z80old95: the old (93 / 94) Z80 driver, 651 bytes; tools/buildZ80.js checks the asm80 build of src/sound/z80_snd_drv93.asm against it
    // NHL 95 graphics95 ($A1A5A-$1A1699): the player pictures, the rink, the sprites, the fonts and screen maps, the team logos.
    // One slice per asset the code references (its label in src/graphics95.asm), one per FeaturedPictures picture (PlayerCards).
    { name: 'NoPlayerPicture.map.jim', folder: 'NHL95/Graphics', start: 0x000A1A5A, end: 0x000A1E90 }, // NoPlayerPicture
    { name: 'NoPicSkater2.bin', folder: 'NHL95/Graphics', start: 0x000A1E90, end: 0x000A21FA }, // NoPicSkater2
    { name: 'NoPicSkater1.bin', folder: 'NHL95/Graphics', start: 0x000A21FA, end: 0x000A2564 }, // NoPicSkater1
    { name: 'NoPicGoalie2.bin', folder: 'NHL95/Graphics', start: 0x000A2564, end: 0x000A28CE }, // NoPicGoalie2
    { name: 'NoPicGoalie1.bin', folder: 'NHL95/Graphics', start: 0x000A28CE, end: 0x000A2C38 }, // NoPicGoalie1
    { name: 'Card001.bin', folder: 'NHL95/Graphics/PlayerCards', start: 0x000A2C38, end: 0x000A2FA2 }, // Card001
    { name: 'Card002.bin', folder: 'NHL95/Graphics/PlayerCards', start: 0x000A2FA2, end: 0x000A330C }, // Card002
    { name: 'Card003.bin', folder: 'NHL95/Graphics/PlayerCards', start: 0x000A330C, end: 0x000A3676 }, // Card003
    { name: 'Card004.bin', folder: 'NHL95/Graphics/PlayerCards', start: 0x000A3676, end: 0x000A39E0 }, // Card004
    { name: 'Card005.bin', folder: 'NHL95/Graphics/PlayerCards', start: 0x000A39E0, end: 0x000A3D4A }, // Card005
    { name: 'Card006.bin', folder: 'NHL95/Graphics/PlayerCards', start: 0x000A3D4A, end: 0x000A40B4 }, // Card006
    { name: 'Card007.bin', folder: 'NHL95/Graphics/PlayerCards', start: 0x000A40B4, end: 0x000A441E }, // Card007
    { name: 'Card008.bin', folder: 'NHL95/Graphics/PlayerCards', start: 0x000A441E, end: 0x000A4788 }, // Card008
    { name: 'Card009.bin', folder: 'NHL95/Graphics/PlayerCards', start: 0x000A4788, end: 0x000A4AF2 }, // Card009
    { name: 'Card010.bin', folder: 'NHL95/Graphics/PlayerCards', start: 0x000A4AF2, end: 0x000A4E5C }, // Card010
    { name: 'Card011.bin', folder: 'NHL95/Graphics/PlayerCards', start: 0x000A4E5C, end: 0x000A51C6 }, // Card011
    { name: 'Card012.bin', folder: 'NHL95/Graphics/PlayerCards', start: 0x000A51C6, end: 0x000A5530 }, // Card012
    { name: 'Card013.bin', folder: 'NHL95/Graphics/PlayerCards', start: 0x000A5530, end: 0x000A589A }, // Card013
    { name: 'Card014.bin', folder: 'NHL95/Graphics/PlayerCards', start: 0x000A589A, end: 0x000A5C04 }, // Card014
    { name: 'Card015.bin', folder: 'NHL95/Graphics/PlayerCards', start: 0x000A5C04, end: 0x000A5F6E }, // Card015
    { name: 'Card016.bin', folder: 'NHL95/Graphics/PlayerCards', start: 0x000A5F6E, end: 0x000A62D8 }, // Card016
    { name: 'Card017.bin', folder: 'NHL95/Graphics/PlayerCards', start: 0x000A62D8, end: 0x000A6642 }, // Card017
    { name: 'Card018.bin', folder: 'NHL95/Graphics/PlayerCards', start: 0x000A6642, end: 0x000A69AC }, // Card018
    { name: 'Card019.bin', folder: 'NHL95/Graphics/PlayerCards', start: 0x000A69AC, end: 0x000A6D16 }, // Card019
    { name: 'Card020.bin', folder: 'NHL95/Graphics/PlayerCards', start: 0x000A6D16, end: 0x000A7080 }, // Card020
    { name: 'Card021.bin', folder: 'NHL95/Graphics/PlayerCards', start: 0x000A7080, end: 0x000A73EA }, // Card021
    { name: 'Card022.bin', folder: 'NHL95/Graphics/PlayerCards', start: 0x000A73EA, end: 0x000A7754 }, // Card022
    { name: 'Card023.bin', folder: 'NHL95/Graphics/PlayerCards', start: 0x000A7754, end: 0x000A7ABE }, // Card023
    { name: 'Card024.bin', folder: 'NHL95/Graphics/PlayerCards', start: 0x000A7ABE, end: 0x000A7E28 }, // Card024
    { name: 'Card025.bin', folder: 'NHL95/Graphics/PlayerCards', start: 0x000A7E28, end: 0x000A8192 }, // Card025
    { name: 'Card026.bin', folder: 'NHL95/Graphics/PlayerCards', start: 0x000A8192, end: 0x000A84FC }, // Card026
    { name: 'Card027.bin', folder: 'NHL95/Graphics/PlayerCards', start: 0x000A84FC, end: 0x000A8866 }, // Card027
    { name: 'Card028.bin', folder: 'NHL95/Graphics/PlayerCards', start: 0x000A8866, end: 0x000A8BD0 }, // Card028
    { name: 'Card029.bin', folder: 'NHL95/Graphics/PlayerCards', start: 0x000A8BD0, end: 0x000A8F3A }, // Card029
    { name: 'Card030.bin', folder: 'NHL95/Graphics/PlayerCards', start: 0x000A8F3A, end: 0x000A92A4 }, // Card030
    { name: 'Card031.bin', folder: 'NHL95/Graphics/PlayerCards', start: 0x000A92A4, end: 0x000A960E }, // Card031
    { name: 'Card032.bin', folder: 'NHL95/Graphics/PlayerCards', start: 0x000A960E, end: 0x000A9978 }, // Card032
    { name: 'Card033.bin', folder: 'NHL95/Graphics/PlayerCards', start: 0x000A9978, end: 0x000A9CE2 }, // Card033
    { name: 'Card034.bin', folder: 'NHL95/Graphics/PlayerCards', start: 0x000A9CE2, end: 0x000AA04C }, // Card034
    { name: 'Card035.bin', folder: 'NHL95/Graphics/PlayerCards', start: 0x000AA04C, end: 0x000AA3B6 }, // Card035
    { name: 'Card036.bin', folder: 'NHL95/Graphics/PlayerCards', start: 0x000AA3B6, end: 0x000AA720 }, // Card036
    { name: 'Card037.bin', folder: 'NHL95/Graphics/PlayerCards', start: 0x000AA720, end: 0x000AAA8A }, // Card037
    { name: 'Card038.bin', folder: 'NHL95/Graphics/PlayerCards', start: 0x000AAA8A, end: 0x000AADF4 }, // Card038
    { name: 'Card039.bin', folder: 'NHL95/Graphics/PlayerCards', start: 0x000AADF4, end: 0x000AB15E }, // Card039
    { name: 'Card040.bin', folder: 'NHL95/Graphics/PlayerCards', start: 0x000AB15E, end: 0x000AB4C8 }, // Card040
    { name: 'Card041.bin', folder: 'NHL95/Graphics/PlayerCards', start: 0x000AB4C8, end: 0x000AB832 }, // Card041
    { name: 'Card042.bin', folder: 'NHL95/Graphics/PlayerCards', start: 0x000AB832, end: 0x000ABB9C }, // Card042
    { name: 'Card043.bin', folder: 'NHL95/Graphics/PlayerCards', start: 0x000ABB9C, end: 0x000ABF06 }, // Card043
    { name: 'Card044.bin', folder: 'NHL95/Graphics/PlayerCards', start: 0x000ABF06, end: 0x000AC30C }, // Card044
    { name: 'Card045.bin', folder: 'NHL95/Graphics/PlayerCards', start: 0x000AC30C, end: 0x000AC676 }, // Card045
    { name: 'Card046.bin', folder: 'NHL95/Graphics/PlayerCards', start: 0x000AC676, end: 0x000ACA7C }, // Card046
    { name: 'Card047.bin', folder: 'NHL95/Graphics/PlayerCards', start: 0x000ACA7C, end: 0x000ACDE6 }, // Card047
    { name: 'Card048.bin', folder: 'NHL95/Graphics/PlayerCards', start: 0x000ACDE6, end: 0x000AD150 }, // Card048
    { name: 'Card049.bin', folder: 'NHL95/Graphics/PlayerCards', start: 0x000AD150, end: 0x000AD4BA }, // Card049
    { name: 'Card050.bin', folder: 'NHL95/Graphics/PlayerCards', start: 0x000AD4BA, end: 0x000AD824 }, // Card050
    { name: 'Card051.bin', folder: 'NHL95/Graphics/PlayerCards', start: 0x000AD824, end: 0x000ADB8E }, // Card051
    { name: 'Card052.bin', folder: 'NHL95/Graphics/PlayerCards', start: 0x000ADB8E, end: 0x000ADFAC }, // Card052
    { name: 'Card053.bin', folder: 'NHL95/Graphics/PlayerCards', start: 0x000ADFAC, end: 0x000AE316 }, // Card053
    { name: 'Card054.bin', folder: 'NHL95/Graphics/PlayerCards', start: 0x000AE316, end: 0x000AE680 }, // Card054
    { name: 'Card055.bin', folder: 'NHL95/Graphics/PlayerCards', start: 0x000AE680, end: 0x000AE9EA }, // Card055
    { name: 'Card056.bin', folder: 'NHL95/Graphics/PlayerCards', start: 0x000AE9EA, end: 0x000AED54 }, // Card056
    { name: 'Card057.bin', folder: 'NHL95/Graphics/PlayerCards', start: 0x000AED54, end: 0x000AF0BE }, // Card057
    { name: 'Card058.bin', folder: 'NHL95/Graphics/PlayerCards', start: 0x000AF0BE, end: 0x000AF428 }, // Card058
    { name: 'Card059.bin', folder: 'NHL95/Graphics/PlayerCards', start: 0x000AF428, end: 0x000AF792 }, // Card059
    { name: 'Card060.bin', folder: 'NHL95/Graphics/PlayerCards', start: 0x000AF792, end: 0x000AFAFC }, // Card060
    { name: 'Card061.bin', folder: 'NHL95/Graphics/PlayerCards', start: 0x000AFAFC, end: 0x000AFEEA }, // Card061
    { name: 'Card062.bin', folder: 'NHL95/Graphics/PlayerCards', start: 0x000AFEEA, end: 0x000B0254 }, // Card062
    { name: 'Card063.bin', folder: 'NHL95/Graphics/PlayerCards', start: 0x000B0254, end: 0x000B05BE }, // Card063
    { name: 'Card064.bin', folder: 'NHL95/Graphics/PlayerCards', start: 0x000B05BE, end: 0x000B0928 }, // Card064
    { name: 'Card065.bin', folder: 'NHL95/Graphics/PlayerCards', start: 0x000B0928, end: 0x000B0C92 }, // Card065
    { name: 'Card066.bin', folder: 'NHL95/Graphics/PlayerCards', start: 0x000B0C92, end: 0x000B0FFC }, // Card066
    { name: 'Card067.bin', folder: 'NHL95/Graphics/PlayerCards', start: 0x000B0FFC, end: 0x000B1366 }, // Card067
    { name: 'Card068.bin', folder: 'NHL95/Graphics/PlayerCards', start: 0x000B1366, end: 0x000B16D0 }, // Card068
    { name: 'Card069.bin', folder: 'NHL95/Graphics/PlayerCards', start: 0x000B16D0, end: 0x000B1A3A }, // Card069
    { name: 'Card070.bin', folder: 'NHL95/Graphics/PlayerCards', start: 0x000B1A3A, end: 0x000B1DA4 }, // Card070
    { name: 'Card071.bin', folder: 'NHL95/Graphics/PlayerCards', start: 0x000B1DA4, end: 0x000B210E }, // Card071
    { name: 'Card072.bin', folder: 'NHL95/Graphics/PlayerCards', start: 0x000B210E, end: 0x000B24E4 }, // Card072
    { name: 'Card073.bin', folder: 'NHL95/Graphics/PlayerCards', start: 0x000B24E4, end: 0x000B284E }, // Card073
    { name: 'Card074.bin', folder: 'NHL95/Graphics/PlayerCards', start: 0x000B284E, end: 0x000B2BB8 }, // Card074
    { name: 'Card075.bin', folder: 'NHL95/Graphics/PlayerCards', start: 0x000B2BB8, end: 0x000B2F22 }, // Card075
    { name: 'Card076.bin', folder: 'NHL95/Graphics/PlayerCards', start: 0x000B2F22, end: 0x000B328C }, // Card076
    { name: 'Card077.bin', folder: 'NHL95/Graphics/PlayerCards', start: 0x000B328C, end: 0x000B35F6 }, // Card077
    { name: 'Card078.bin', folder: 'NHL95/Graphics/PlayerCards', start: 0x000B35F6, end: 0x000B3960 }, // Card078
    { name: 'Card079.bin', folder: 'NHL95/Graphics/PlayerCards', start: 0x000B3960, end: 0x000B3D36 }, // Card079
    { name: 'Card080.bin', folder: 'NHL95/Graphics/PlayerCards', start: 0x000B3D36, end: 0x000B40A0 }, // Card080
    { name: 'Card081.bin', folder: 'NHL95/Graphics/PlayerCards', start: 0x000B40A0, end: 0x000B440A }, // Card081
    { name: 'Card082.bin', folder: 'NHL95/Graphics/PlayerCards', start: 0x000B440A, end: 0x000B4774 }, // Card082
    { name: 'Card083.bin', folder: 'NHL95/Graphics/PlayerCards', start: 0x000B4774, end: 0x000B4B7A }, // Card083
    { name: 'Card084.bin', folder: 'NHL95/Graphics/PlayerCards', start: 0x000B4B7A, end: 0x000B4EE4 }, // Card084
    { name: 'Card085.bin', folder: 'NHL95/Graphics/PlayerCards', start: 0x000B4EE4, end: 0x000B524E }, // Card085
    { name: 'Card086.bin', folder: 'NHL95/Graphics/PlayerCards', start: 0x000B524E, end: 0x000B55B8 }, // Card086
    { name: 'Card087.bin', folder: 'NHL95/Graphics/PlayerCards', start: 0x000B55B8, end: 0x000B59D6 }, // Card087
    { name: 'Card088.bin', folder: 'NHL95/Graphics/PlayerCards', start: 0x000B59D6, end: 0x000B5D40 }, // Card088
    { name: 'Card089.bin', folder: 'NHL95/Graphics/PlayerCards', start: 0x000B5D40, end: 0x000B60AA }, // Card089
    { name: 'Card090.bin', folder: 'NHL95/Graphics/PlayerCards', start: 0x000B60AA, end: 0x000B6414 }, // Card090
    { name: 'Card091.bin', folder: 'NHL95/Graphics/PlayerCards', start: 0x000B6414, end: 0x000B677E }, // Card091
    { name: 'Card092.bin', folder: 'NHL95/Graphics/PlayerCards', start: 0x000B677E, end: 0x000B6AE8 }, // Card092
    { name: 'Card093.bin', folder: 'NHL95/Graphics/PlayerCards', start: 0x000B6AE8, end: 0x000B6E52 }, // Card093
    { name: 'Card094.bin', folder: 'NHL95/Graphics/PlayerCards', start: 0x000B6E52, end: 0x000B71BC }, // Card094
    { name: 'Card095.bin', folder: 'NHL95/Graphics/PlayerCards', start: 0x000B71BC, end: 0x000B7526 }, // Card095
    { name: 'Card096.bin', folder: 'NHL95/Graphics/PlayerCards', start: 0x000B7526, end: 0x000B7890 }, // Card096
    { name: 'Card097.bin', folder: 'NHL95/Graphics/PlayerCards', start: 0x000B7890, end: 0x000B7BFA }, // Card097
    { name: 'Card098.bin', folder: 'NHL95/Graphics/PlayerCards', start: 0x000B7BFA, end: 0x000B7F64 }, // Card098
    { name: 'Card099.bin', folder: 'NHL95/Graphics/PlayerCards', start: 0x000B7F64, end: 0x000B82CE }, // Card099
    { name: 'Card100.bin', folder: 'NHL95/Graphics/PlayerCards', start: 0x000B82CE, end: 0x000B8638 }, // Card100
    { name: 'Card101.bin', folder: 'NHL95/Graphics/PlayerCards', start: 0x000B8638, end: 0x000B89A2 }, // Card101
    { name: 'Card102.bin', folder: 'NHL95/Graphics/PlayerCards', start: 0x000B89A2, end: 0x000B8D0C }, // Card102
    { name: 'Card103.bin', folder: 'NHL95/Graphics/PlayerCards', start: 0x000B8D0C, end: 0x000B9076 }, // Card103
    { name: 'Card104.bin', folder: 'NHL95/Graphics/PlayerCards', start: 0x000B9076, end: 0x000B93E0 }, // Card104
    { name: 'Card105.bin', folder: 'NHL95/Graphics/PlayerCards', start: 0x000B93E0, end: 0x000B974A }, // Card105
    { name: 'Card106.bin', folder: 'NHL95/Graphics/PlayerCards', start: 0x000B974A, end: 0x000B9AB4 }, // Card106
    { name: 'Card107.bin', folder: 'NHL95/Graphics/PlayerCards', start: 0x000B9AB4, end: 0x000B9E1E }, // Card107
    { name: 'Card108.bin', folder: 'NHL95/Graphics/PlayerCards', start: 0x000B9E1E, end: 0x000BA188 }, // Card108
    { name: 'Card109.bin', folder: 'NHL95/Graphics/PlayerCards', start: 0x000BA188, end: 0x000BA4F2 }, // Card109
    { name: 'Card110.bin', folder: 'NHL95/Graphics/PlayerCards', start: 0x000BA4F2, end: 0x000BA85C }, // Card110
    { name: 'Card111.bin', folder: 'NHL95/Graphics/PlayerCards', start: 0x000BA85C, end: 0x000BABC6 }, // Card111
    { name: 'Card112.bin', folder: 'NHL95/Graphics/PlayerCards', start: 0x000BABC6, end: 0x000BAF30 }, // Card112
    { name: 'Card113.bin', folder: 'NHL95/Graphics/PlayerCards', start: 0x000BAF30, end: 0x000BB29A }, // Card113
    { name: 'Card114.bin', folder: 'NHL95/Graphics/PlayerCards', start: 0x000BB29A, end: 0x000BB604 }, // Card114
    { name: 'Card115.bin', folder: 'NHL95/Graphics/PlayerCards', start: 0x000BB604, end: 0x000BB96E }, // Card115
    { name: 'Card116.bin', folder: 'NHL95/Graphics/PlayerCards', start: 0x000BB96E, end: 0x000BBCD8 }, // Card116
    { name: 'Card117.bin', folder: 'NHL95/Graphics/PlayerCards', start: 0x000BBCD8, end: 0x000BC042 }, // Card117
    { name: 'Card118.bin', folder: 'NHL95/Graphics/PlayerCards', start: 0x000BC042, end: 0x000BC3AC }, // Card118
    { name: 'Card119.bin', folder: 'NHL95/Graphics/PlayerCards', start: 0x000BC3AC, end: 0x000BC716 }, // Card119
    { name: 'Card120.bin', folder: 'NHL95/Graphics/PlayerCards', start: 0x000BC716, end: 0x000BCA80 }, // Card120
    { name: 'Card121.bin', folder: 'NHL95/Graphics/PlayerCards', start: 0x000BCA80, end: 0x000BCDEA }, // Card121
    { name: 'Card122.bin', folder: 'NHL95/Graphics/PlayerCards', start: 0x000BCDEA, end: 0x000BD154 }, // Card122
    { name: 'Card123.bin', folder: 'NHL95/Graphics/PlayerCards', start: 0x000BD154, end: 0x000BD4BE }, // Card123
    { name: 'Card124.bin', folder: 'NHL95/Graphics/PlayerCards', start: 0x000BD4BE, end: 0x000BD828 }, // Card124
    { name: 'Card125.bin', folder: 'NHL95/Graphics/PlayerCards', start: 0x000BD828, end: 0x000BDB92 }, // Card125
    { name: 'Card126.bin', folder: 'NHL95/Graphics/PlayerCards', start: 0x000BDB92, end: 0x000BDEFC }, // Card126
    { name: 'Card127.bin', folder: 'NHL95/Graphics/PlayerCards', start: 0x000BDEFC, end: 0x000BE266 }, // Card127
    { name: 'Card128.bin', folder: 'NHL95/Graphics/PlayerCards', start: 0x000BE266, end: 0x000BE5D0 }, // Card128
    { name: 'Card129.bin', folder: 'NHL95/Graphics/PlayerCards', start: 0x000BE5D0, end: 0x000BE93A }, // Card129
    { name: 'Card130.bin', folder: 'NHL95/Graphics/PlayerCards', start: 0x000BE93A, end: 0x000BECA4 }, // Card130
    { name: 'Card131.bin', folder: 'NHL95/Graphics/PlayerCards', start: 0x000BECA4, end: 0x000BF00E }, // Card131
    { name: 'Card132.bin', folder: 'NHL95/Graphics/PlayerCards', start: 0x000BF00E, end: 0x000BF378 }, // Card132
    { name: 'Card133.bin', folder: 'NHL95/Graphics/PlayerCards', start: 0x000BF378, end: 0x000BF6E2 }, // Card133
    { name: 'Card134.bin', folder: 'NHL95/Graphics/PlayerCards', start: 0x000BF6E2, end: 0x000BFA4C }, // Card134
    { name: 'Card135.bin', folder: 'NHL95/Graphics/PlayerCards', start: 0x000BFA4C, end: 0x000BFDB6 }, // Card135
    { name: 'Card136.bin', folder: 'NHL95/Graphics/PlayerCards', start: 0x000BFDB6, end: 0x000C01BC }, // Card136
    { name: 'Card137.bin', folder: 'NHL95/Graphics/PlayerCards', start: 0x000C01BC, end: 0x000C0526 }, // Card137
    { name: 'Card138.bin', folder: 'NHL95/Graphics/PlayerCards', start: 0x000C0526, end: 0x000C0890 }, // Card138
    { name: 'Card139.bin', folder: 'NHL95/Graphics/PlayerCards', start: 0x000C0890, end: 0x000C0BFA }, // Card139
    { name: 'Card140.bin', folder: 'NHL95/Graphics/PlayerCards', start: 0x000C0BFA, end: 0x000C0F64 }, // Card140
    { name: 'Card141.bin', folder: 'NHL95/Graphics/PlayerCards', start: 0x000C0F64, end: 0x000C12CE }, // Card141
    { name: 'Card142.bin', folder: 'NHL95/Graphics/PlayerCards', start: 0x000C12CE, end: 0x000C1638 }, // Card142
    { name: 'Card143.bin', folder: 'NHL95/Graphics/PlayerCards', start: 0x000C1638, end: 0x000C19A2 }, // Card143
    { name: 'Card144.bin', folder: 'NHL95/Graphics/PlayerCards', start: 0x000C19A2, end: 0x000C1D0C }, // Card144
    { name: 'Card145.bin', folder: 'NHL95/Graphics/PlayerCards', start: 0x000C1D0C, end: 0x000C2076 }, // Card145
    { name: 'Card146.bin', folder: 'NHL95/Graphics/PlayerCards', start: 0x000C2076, end: 0x000C23E0 }, // Card146
    { name: 'Card147.bin', folder: 'NHL95/Graphics/PlayerCards', start: 0x000C23E0, end: 0x000C274A }, // Card147
    { name: 'Card148.bin', folder: 'NHL95/Graphics/PlayerCards', start: 0x000C274A, end: 0x000C2AB4 }, // Card148
    { name: 'Card149.bin', folder: 'NHL95/Graphics/PlayerCards', start: 0x000C2AB4, end: 0x000C2E1E }, // Card149
    { name: 'Card150.bin', folder: 'NHL95/Graphics/PlayerCards', start: 0x000C2E1E, end: 0x000C3188 }, // Card150
    { name: 'Card151.bin', folder: 'NHL95/Graphics/PlayerCards', start: 0x000C3188, end: 0x000C34F2 }, // Card151
    { name: 'Card152.bin', folder: 'NHL95/Graphics/PlayerCards', start: 0x000C34F2, end: 0x000C385C }, // Card152
    { name: 'Card153.bin', folder: 'NHL95/Graphics/PlayerCards', start: 0x000C385C, end: 0x000C3C62 }, // Card153
    { name: 'Card154.bin', folder: 'NHL95/Graphics/PlayerCards', start: 0x000C3C62, end: 0x000C3FCC }, // Card154
    { name: 'Card155.bin', folder: 'NHL95/Graphics/PlayerCards', start: 0x000C3FCC, end: 0x000C43EA }, // Card155
    { name: 'Card156.bin', folder: 'NHL95/Graphics/PlayerCards', start: 0x000C43EA, end: 0x000C4754 }, // Card156
    { name: 'Rinktilelist.map.jim', folder: 'NHL95/Graphics', start: 0x000C4A7C, end: 0x000CA56A }, // Rinktilelist
    { name: 'Sprites.bin', folder: 'NHL95/Graphics', start: 0x000CA56A, end: 0x000CA574 }, // Sprites
    { name: 'Spritetiles.bin', folder: 'NHL95/Graphics', start: 0x000CA574, end: 0x001318F4 }, // Spritetiles
    { name: 'frameSprData.bin', folder: 'NHL95/Graphics', start: 0x001318F4, end: 0x00137B66 }, // frameSprData
    { name: 'HotSpotList.bin', folder: 'NHL95/Graphics', start: 0x00137B66, end: 0x001383C6 }, // HotSpotList
    { name: 'RosterFont.bin', folder: 'NHL95/Graphics', start: 0x001383C6, end: 0x00139094 }, // RosterFont
    { name: 'SmallFontMap.map.jim', folder: 'NHL95/Graphics', start: 0x00139094, end: 0x00139E02 }, // SmallFontMap
    { name: 'SmallFontMap2.map.jim', folder: 'NHL95/Graphics', start: 0x00139E02, end: 0x0013AC70 }, // SmallFontMap2
    { name: 'PauseBgBitmap.map.jim', folder: 'NHL95/Graphics', start: 0x0013AC70, end: 0x0013E09E }, // PauseBgBitmap
    { name: 'PeriodNumberBitmap.map.jim', folder: 'NHL95/Graphics', start: 0x0013E09E, end: 0x0013E21C }, // PeriodNumberBitmap
    { name: 'TabBitmap.map.jim', folder: 'NHL95/Graphics', start: 0x0013E21C, end: 0x0013EEAA }, // TabBitmap
    { name: 'PauseFontMap.map.jim', folder: 'NHL95/Graphics', start: 0x0013EEAA, end: 0x0013FC18 }, // PauseFontMap
    { name: 'ClockDigitsBitmap.map.jim', folder: 'NHL95/Graphics', start: 0x0013FC18, end: 0x0014000A }, // ClockDigitsBitmap
    { name: 'RosterBitmap.map.jim', folder: 'NHL95/Graphics', start: 0x0014000A, end: 0x00142906 }, // RosterBitmap
    { name: 'Teamblocksmap.map.jim', folder: 'NHL95/Graphics', start: 0x00142906, end: 0x00146D24 }, // Teamblocksmap
    { name: 'PauseTeamBlocksMap.map.jim', folder: 'NHL95/Graphics', start: 0x00146D24, end: 0x00149E32 }, // PauseTeamBlocksMap
    { name: 'FaceOffMap.map.jim', folder: 'NHL95/Graphics', start: 0x00149E32, end: 0x0014A490 }, // FaceOffMap
    { name: 'FaceOffSprites.map.jim', folder: 'NHL95/Graphics', start: 0x0014A490, end: 0x0014C148 }, // FaceOffSprites
    { name: 'Framermap.map.jim', folder: 'NHL95/Graphics', start: 0x0014C148, end: 0x0014C308 }, // Framermap
    { name: 'Framermap2.map.jim', folder: 'NHL95/Graphics', start: 0x0014C308, end: 0x0014C4C8 }, // Framermap2
    { name: 'EnergyBarMap.map.jim', folder: 'NHL95/Graphics', start: 0x0014C4C8, end: 0x0014C796 }, // EnergyBarMap
    { name: 'EASportsMap.map.jim', folder: 'NHL95/Graphics', start: 0x0014C796, end: 0x0014EB04 }, // EASportsMap
    { name: 'RefTiles.map.jim', folder: 'NHL95/Graphics', start: 0x0014EB04, end: 0x0014FBA2 }, // RefTiles
    { name: 'RefTilesHor.map.jim', folder: 'NHL95/Graphics', start: 0x0014FBA2, end: 0x00151760 }, // RefTilesHor
    { name: 'SetupFont.map.jim', folder: 'NHL95/Graphics', start: 0x00151760, end: 0x001524CE }, // SetupFont
    { name: 'SetupBgMap2.map.jim', folder: 'NHL95/Graphics', start: 0x001524CE, end: 0x001588FC }, // SetupBgMap2
    { name: 'SetupBgMap1.map.jim', folder: 'NHL95/Graphics', start: 0x001588FC, end: 0x0015974A }, // SetupBgMap1
    { name: 'TeamBitmaps.map.jim', folder: 'NHL95/Graphics', start: 0x0015974A, end: 0x0015CE68 }, // TeamBitmaps
    { name: 'BigFontMap3.map.jim', folder: 'NHL95/Graphics', start: 0x0015CE68, end: 0x0015E18A }, // BigFontMap3
    { name: 'BigFontMap.map.jim', folder: 'NHL95/Graphics', start: 0x0015E18A, end: 0x0015F46C }, // BigFontMap
    { name: 'BigFontMap2.map.jim', folder: 'NHL95/Graphics', start: 0x0015F46C, end: 0x0016060E }, // BigFontMap2
    { name: 'RevRinkTilelist.bin', folder: 'NHL95/Graphics', start: 0x0016060E, end: 0x001625F2 }, // RevRinkTilelist
    { name: 'ReplayMap.map.jim', folder: 'NHL95/Graphics', start: 0x001625F2, end: 0x00162D18 }, // ReplayMap
    { name: 'ReplayIconMap.map.jim', folder: 'NHL95/Graphics', start: 0x00162D18, end: 0x0016334A }, // ReplayIconMap
    { name: 'HiScoreBgMap.map.jim', folder: 'NHL95/Graphics', start: 0x0016334A, end: 0x0016430A }, // HiScoreBgMap
    { name: 'HiScoreImg.map.jim', folder: 'NHL95/Graphics', start: 0x0016430A, end: 0x00164AC8 }, // HiScoreImg
    { name: 'ControllerBgMap.map.jim', folder: 'NHL95/Graphics', start: 0x00164AC8, end: 0x00165A36 }, // ControllerBgMap
    { name: 'GamesTodayLogoMap.map.jim', folder: 'NHL95/Graphics', start: 0x00165A36, end: 0x00167524 }, // GamesTodayLogoMap
    { name: 'GamesTodayMap1.map.jim', folder: 'NHL95/Graphics', start: 0x00167524, end: 0x0016767E }, // GamesTodayMap1
    { name: 'GamesTodayMap2.map.jim', folder: 'NHL95/Graphics', start: 0x0016767E, end: 0x0016781E }, // GamesTodayMap2
    { name: 'GamesTodayMap3.map.jim', folder: 'NHL95/Graphics', start: 0x0016781E, end: 0x00167A44 }, // GamesTodayMap3
    { name: 'CalendarBgMap.map.jim', folder: 'NHL95/Graphics', start: 0x00167A44, end: 0x00168E72 }, // CalendarBgMap
    { name: 'CalOpponentMap.map.jim', folder: 'NHL95/Graphics', start: 0x00168E72, end: 0x001696DC }, // CalOpponentMap
    { name: 'CalDayMap.map.jim', folder: 'NHL95/Graphics', start: 0x001696DC, end: 0x00169CE6 }, // CalDayMap
    { name: 'CalMonthMap.map.jim', folder: 'NHL95/Graphics', start: 0x00169CE6, end: 0x0016A814 }, // CalMonthMap
    { name: 'CalCheckMap.bin', folder: 'NHL95/Graphics', start: 0x0016A814, end: 0x0016A8BC }, // CalCheckMap
    { name: 'CalResultMap.map.jim', folder: 'NHL95/Graphics', start: 0x0016A8BC, end: 0x0016AA7C }, // CalResultMap
    { name: 'ControllerTitleMap.map.jim', folder: 'NHL95/Graphics', start: 0x0016AA7C, end: 0x0016AD5A }, // ControllerTitleMap
    { name: 'PadCursorMap.map.jim', folder: 'NHL95/Graphics', start: 0x0016AD5A, end: 0x0016B0B2 }, // PadCursorMap
    { name: 'PadIconMap1.map.jim', folder: 'NHL95/Graphics', start: 0x0016B0B2, end: 0x0016B1C8 }, // PadIconMap1
    { name: 'PadIconMap2.map.jim', folder: 'NHL95/Graphics', start: 0x0016B1C8, end: 0x0016B2DE }, // PadIconMap2
    { name: 'PadIconMap3.map.jim', folder: 'NHL95/Graphics', start: 0x0016B2DE, end: 0x0016B3F4 }, // PadIconMap3
    { name: 'PadIconMap4.map.jim', folder: 'NHL95/Graphics', start: 0x0016B3F4, end: 0x0016B50A }, // PadIconMap4
    { name: 'PlayerStatsBgMap.map.jim', folder: 'NHL95/Graphics', start: 0x0016B50A, end: 0x0016C438 }, // PlayerStatsBgMap
    { name: 'PlayerStatsTitleMap.map.jim', folder: 'NHL95/Graphics', start: 0x0016C438, end: 0x0016C776 }, // PlayerStatsTitleMap
    { name: 'PeriodStatsMap.map.jim', folder: 'NHL95/Graphics', start: 0x0016C776, end: 0x0016C9FC }, // PeriodStatsMap
    { name: 'HighlightsBgMap.map.jim', folder: 'NHL95/Graphics', start: 0x0016C9FC, end: 0x0016CC82 }, // HighlightsBgMap
    { name: 'WaitBoxMap.map.jim', folder: 'NHL95/Graphics', start: 0x0016CC82, end: 0x0016EAB4 }, // WaitBoxMap
    { name: 'LineEditorBgMap.map.jim', folder: 'NHL95/Graphics', start: 0x0016EAB4, end: 0x0016F7D2 }, // LineEditorBgMap
    { name: 'PlayerSelectMap2.map.jim', folder: 'NHL95/Graphics', start: 0x0016F7D2, end: 0x0016FA70 }, // PlayerSelectMap2
    { name: 'PlayerSelectMap1.map.jim', folder: 'NHL95/Graphics', start: 0x0016FA70, end: 0x001703FE }, // PlayerSelectMap1
    { name: 'CreateBgMap.map.jim', folder: 'NHL95/Graphics', start: 0x001703FE, end: 0x00172CCC }, // CreateBgMap
    { name: 'TradeBgMap.map.jim', folder: 'NHL95/Graphics', start: 0x00172CCC, end: 0x0017409A }, // TradeBgMap
    { name: 'AwardsBgMap.map.jim', folder: 'NHL95/Graphics', start: 0x0017409A, end: 0x001787C8 }, // AwardsBgMap
    { name: 'FinalistsPanelMap.map.jim', folder: 'NHL95/Graphics', start: 0x001787C8, end: 0x00178B12 }, // FinalistsPanelMap
    { name: 'WinnerPanelMap.map.jim', folder: 'NHL95/Graphics', start: 0x00178B12, end: 0x00178EC6 }, // WinnerPanelMap
    { name: 'HartPic.map.jim', folder: 'NHL95/Graphics', start: 0x00178EC6, end: 0x00179690 }, // HartPic
    { name: 'NorrisPic.map.jim', folder: 'NHL95/Graphics', start: 0x00179690, end: 0x0017A94A }, // NorrisPic
    { name: 'VezinaPic.map.jim', folder: 'NHL95/Graphics', start: 0x0017A94A, end: 0x0017B2E8 }, // VezinaPic
    { name: 'ArtRossPic.map.jim', folder: 'NHL95/Graphics', start: 0x0017B2E8, end: 0x0017BF00 }, // ArtRossPic
    { name: 'SelkePic.map.jim', folder: 'NHL95/Graphics', start: 0x0017BF00, end: 0x0017E0D6 }, // SelkePic
    { name: 'JenningsPic.map.jim', folder: 'NHL95/Graphics', start: 0x0017E0D6, end: 0x0017EE8E }, // JenningsPic
    { name: 'PresidentsPic.map.jim', folder: 'NHL95/Graphics', start: 0x0017EE8E, end: 0x0017F76C }, // PresidentsPic
    { name: 'ConnSmythePic.map.jim', folder: 'NHL95/Graphics', start: 0x0017F76C, end: 0x0018022A }, // ConnSmythePic
    { name: 'PearsonPic.map.jim', folder: 'NHL95/Graphics', start: 0x0018022A, end: 0x00180B4E }, // PearsonPic
    { name: 'EASNmap.map.jim', folder: 'NHL95/Graphics', start: 0x00180B4E, end: 0x00180D54 }, // EASNmap
    { name: 'GMDecisionMap.map.jim', folder: 'NHL95/Graphics', start: 0x00180D54, end: 0x00181078 }, // GMDecisionMap
    { name: 'FreeAgentMap2.map.jim', folder: 'NHL95/Graphics', start: 0x00181078, end: 0x00181486 }, // FreeAgentMap2
    { name: 'FreeAgentMap1.map.jim', folder: 'NHL95/Graphics', start: 0x00181486, end: 0x00181B04 }, // FreeAgentMap1
    { name: 'TradeAdvantageMap2.map.jim', folder: 'NHL95/Graphics', start: 0x00181B04, end: 0x0018277C }, // TradeAdvantageMap2
    { name: 'TradeAdvantageMap1.map.jim', folder: 'NHL95/Graphics', start: 0x0018277C, end: 0x001834F4 }, // TradeAdvantageMap1
    { name: 'NameEntryBgMap.map.jim', folder: 'NHL95/Graphics', start: 0x001834F4, end: 0x001835D6 }, // NameEntryBgMap
    { name: 'Arrowsmap.map.jim', folder: 'NHL95/Graphics', start: 0x001835D6, end: 0x0018394C }, // Arrowsmap
    { name: 'ScoutMap.map.jim', folder: 'NHL95/Graphics', start: 0x0018394C, end: 0x001842DA }, // ScoutMap
    { name: 'PlayoffSprite.map.jim', folder: 'NHL95/Graphics', start: 0x001842DA, end: 0x001891F8 }, // PlayoffSprite
    { name: 'ScoutReportMap.map.jim', folder: 'NHL95/Graphics', start: 0x001891F8, end: 0x0018A5C6 }, // ScoutReportMap
    { name: 'HotIconMap.map.jim', folder: 'NHL95/Graphics', start: 0x0018A5C6, end: 0x0018A78C }, // HotIconMap
    { name: 'ColdIconMap.map.jim', folder: 'NHL95/Graphics', start: 0x0018A78C, end: 0x0018A9B2 }, // ColdIconMap
    { name: 'RonBarrMap.map.jim', folder: 'NHL95/Graphics', start: 0x0018A9B2, end: 0x0018B628 }, // RonBarrMap
    { name: 'CrowdFrameList.map.jim', folder: 'NHL95/Graphics', start: 0x0018B628, end: 0x0018DAA8 }, // CrowdFrameList
    { name: 'TitleScreenImg.map.jim', folder: 'NHL95/Graphics', start: 0x0018DAA8, end: 0x001960D6 }, // TitleScreenImg
    { name: 'TitleImg.map.jim', folder: 'NHL95/Graphics', start: 0x001960D6, end: 0x00196C4C }, // TitleImg
    { name: 'StanleyCupImg.map.jim', folder: 'NHL95/Graphics', start: 0x00196C4C, end: 0x0019A0FA }, // StanleyCupImg
    { name: 'CupSprites.map.jim', folder: 'NHL95/Graphics', start: 0x0019A0FA, end: 0x0019A992 }, // CupSprites
    { name: 'logoANA.map.jim', folder: 'NHL95/Graphics', start: 0x0019A992, end: 0x0019AE28 }, // logoANH
    { name: 'logoBOS.map.jim', folder: 'NHL95/Graphics', start: 0x0019AE28, end: 0x0019B17E }, // logoBOS
    { name: 'logoBUF.map.jim', folder: 'NHL95/Graphics', start: 0x0019B17E, end: 0x0019B4D4 }, // logoBUF
    { name: 'logoCGY.map.jim', folder: 'NHL95/Graphics', start: 0x0019B4D4, end: 0x0019B96A }, // logoCGY
    { name: 'logoCHI.map.jim', folder: 'NHL95/Graphics', start: 0x0019B96A, end: 0x0019BDA0 }, // logoCHI
    { name: 'logoDET.map.jim', folder: 'NHL95/Graphics', start: 0x0019BDA0, end: 0x0019C0F6 }, // logoDET
    { name: 'logoEDM.map.jim', folder: 'NHL95/Graphics', start: 0x0019C0F6, end: 0x0019C4EC }, // logoEDM
    { name: 'logoFLA.map.jim', folder: 'NHL95/Graphics', start: 0x0019C4EC, end: 0x0019C8A2 }, // logoFLA
    { name: 'logoHFD.map.jim', folder: 'NHL95/Graphics', start: 0x0019C8A2, end: 0x0019CB38 }, // logoHFD
    { name: 'logoNYI.map.jim', folder: 'NHL95/Graphics', start: 0x0019CB38, end: 0x0019CF8E }, // logoNYI
    { name: 'logoLA.map.jim', folder: 'NHL95/Graphics', start: 0x0019CF8E, end: 0x0019D304 }, // logoLA
    { name: 'logoDAL.map.jim', folder: 'NHL95/Graphics', start: 0x0019D304, end: 0x0019D71A }, // logoDAL
    { name: 'logoMTL.map.jim', folder: 'NHL95/Graphics', start: 0x0019D71A, end: 0x0019DA90 }, // logoMTL
    { name: 'logoNJ.map.jim', folder: 'NHL95/Graphics', start: 0x0019DA90, end: 0x0019DF46 }, // logoNJ
    { name: 'logoNYR.map.jim', folder: 'NHL95/Graphics', start: 0x0019DF46, end: 0x0019E41C }, // logoNYR
    { name: 'logoOTW.map.jim', folder: 'NHL95/Graphics', start: 0x0019E41C, end: 0x0019E832 }, // logoOTW
    { name: 'logoPHI.map.jim', folder: 'NHL95/Graphics', start: 0x0019E832, end: 0x0019EBE8 }, // logoPHI
    { name: 'logoPIT.map.jim', folder: 'NHL95/Graphics', start: 0x0019EBE8, end: 0x0019EF5E }, // logoPIT
    { name: 'logoQUE.map.jim', folder: 'NHL95/Graphics', start: 0x0019EF5E, end: 0x0019F2B4 }, // logoQUE
    { name: 'logoSJ.map.jim', folder: 'NHL95/Graphics', start: 0x0019F2B4, end: 0x0019F6EA }, // logoSJ
    { name: 'logoSTL.map.jim', folder: 'NHL95/Graphics', start: 0x0019F6EA, end: 0x0019FAC0 }, // logoSTL
    { name: 'logoTB.map.jim', folder: 'NHL95/Graphics', start: 0x0019FAC0, end: 0x0019FED6 }, // logoTB
    { name: 'logoTOR.map.jim', folder: 'NHL95/Graphics', start: 0x0019FED6, end: 0x001A022C }, // logoTOR
    { name: 'logoVAN.map.jim', folder: 'NHL95/Graphics', start: 0x001A022C, end: 0x001A0642 }, // logoVAN
    { name: 'logoWSH.map.jim', folder: 'NHL95/Graphics', start: 0x001A0642, end: 0x001A08B8 }, // logoWSH
    { name: 'logoWPG.map.jim', folder: 'NHL95/Graphics', start: 0x001A08B8, end: 0x001A0D2E }, // logoWPG
    { name: 'logoASE.map.jim', folder: 'NHL95/Graphics', start: 0x001A0D2E, end: 0x001A11E4 }, // logoASE
    { name: 'logoASW.map.jim', folder: 'NHL95/Graphics', start: 0x001A11E4, end: 0x001A169A }, // logoASW
    // NHL 95 graphics95 TeamLogoPalettes ($1A169A): one 32 byte palette per team; 25 are the same bytes as the 94 files (94 names), DAL / ASE / ASW differ.
    { name: 'MatchupPalANHA.pal', folder: 'NHL95/Graphics/Pals', start: 0x001A169A, end: 0x001A16BA }, // ANH TeamLogoPalettes, 94 file, same bytes
    { name: 'TeamLogoPalBOS.pal', folder: 'NHL95/Graphics/Pals', start: 0x001A16BA, end: 0x001A16DA }, // BOS TeamLogoPalettes, 94 file, same bytes
    { name: 'MatchupPalBUFA.pal', folder: 'NHL95/Graphics/Pals', start: 0x001A16DA, end: 0x001A16FA }, // BUF TeamLogoPalettes, 94 file, same bytes
    { name: 'MatchupPalCGYA.pal', folder: 'NHL95/Graphics/Pals', start: 0x001A16FA, end: 0x001A171A }, // CGY TeamLogoPalettes, 94 file, same bytes
    { name: 'MatchupPalCHIA.pal', folder: 'NHL95/Graphics/Pals', start: 0x001A171A, end: 0x001A173A }, // CHI TeamLogoPalettes, 94 file, same bytes
    { name: 'MatchupPalDALA95.pal', folder: 'NHL95/Graphics/Pals', start: 0x001A173A, end: 0x001A175A }, // DAL TeamLogoPalettes, differs from 94 MatchupPalDALA.pal
    { name: 'MatchupPalDETA.pal', folder: 'NHL95/Graphics/Pals', start: 0x001A175A, end: 0x001A177A }, // DET TeamLogoPalettes, 94 file, same bytes
    { name: 'MatchupPalEDMA.pal', folder: 'NHL95/Graphics/Pals', start: 0x001A177A, end: 0x001A179A }, // EDM TeamLogoPalettes, 94 file, same bytes
    { name: 'TeamLogoPalFLA.pal', folder: 'NHL95/Graphics/Pals', start: 0x001A179A, end: 0x001A17BA }, // FLA TeamLogoPalettes, 94 file, same bytes
    { name: 'TeamLogoPalHFD.pal', folder: 'NHL95/Graphics/Pals', start: 0x001A17BA, end: 0x001A17DA }, // HFD TeamLogoPalettes, 94 file, same bytes
    { name: 'MatchupPalLAA.pal', folder: 'NHL95/Graphics/Pals', start: 0x001A17DA, end: 0x001A17FA }, // LA TeamLogoPalettes, 94 file, same bytes
    { name: 'MatchupPalMTLA.pal', folder: 'NHL95/Graphics/Pals', start: 0x001A17FA, end: 0x001A181A }, // MTL TeamLogoPalettes, 94 file, same bytes
    { name: 'MatchupPalNJA.pal', folder: 'NHL95/Graphics/Pals', start: 0x001A181A, end: 0x001A183A }, // NJ TeamLogoPalettes, 94 file, same bytes
    { name: 'MatchupPalNYIA.pal', folder: 'NHL95/Graphics/Pals', start: 0x001A183A, end: 0x001A185A }, // NYI TeamLogoPalettes, 94 file, same bytes
    { name: 'MatchupPalNYRA.pal', folder: 'NHL95/Graphics/Pals', start: 0x001A185A, end: 0x001A187A }, // NYR TeamLogoPalettes, 94 file, same bytes
    { name: 'MatchupPalOTWA.pal', folder: 'NHL95/Graphics/Pals', start: 0x001A187A, end: 0x001A189A }, // OTW TeamLogoPalettes, 94 file, same bytes
    { name: 'MatchupPalPHIA.pal', folder: 'NHL95/Graphics/Pals', start: 0x001A189A, end: 0x001A18BA }, // PHI TeamLogoPalettes, 94 file, same bytes
    { name: 'MatchupPalPITA.pal', folder: 'NHL95/Graphics/Pals', start: 0x001A18BA, end: 0x001A18DA }, // PIT TeamLogoPalettes, 94 file, same bytes
    { name: 'MatchupPalQUEA.pal', folder: 'NHL95/Graphics/Pals', start: 0x001A18DA, end: 0x001A18FA }, // QUE TeamLogoPalettes, 94 file, same bytes
    { name: 'TeamLogoPalSJ.pal', folder: 'NHL95/Graphics/Pals', start: 0x001A18FA, end: 0x001A191A }, // SJ TeamLogoPalettes, 94 file, same bytes
    { name: 'MatchupPalSTLA.pal', folder: 'NHL95/Graphics/Pals', start: 0x001A191A, end: 0x001A193A }, // STL TeamLogoPalettes, 94 file, same bytes
    { name: 'MatchupPalTBA.pal', folder: 'NHL95/Graphics/Pals', start: 0x001A193A, end: 0x001A195A }, // TB TeamLogoPalettes, 94 file, same bytes
    { name: 'MatchupPalTORA.pal', folder: 'NHL95/Graphics/Pals', start: 0x001A195A, end: 0x001A197A }, // TOR TeamLogoPalettes, 94 file, same bytes
    { name: 'MatchupPalVANA.pal', folder: 'NHL95/Graphics/Pals', start: 0x001A197A, end: 0x001A199A }, // VAN TeamLogoPalettes, 94 file, same bytes
    { name: 'MatchupPalWSHA.pal', folder: 'NHL95/Graphics/Pals', start: 0x001A199A, end: 0x001A19BA }, // WSH TeamLogoPalettes, 94 file, same bytes
    { name: 'MatchupPalWPGA.pal', folder: 'NHL95/Graphics/Pals', start: 0x001A19BA, end: 0x001A19DA }, // WPG TeamLogoPalettes, 94 file, same bytes
    { name: 'MatchupPalASEA95.pal', folder: 'NHL95/Graphics/Pals', start: 0x001A19DA, end: 0x001A19FA }, // ASE TeamLogoPalettes, differs from 94 MatchupPalASEA.pal
    { name: 'MatchupPalASWA95.pal', folder: 'NHL95/Graphics/Pals', start: 0x001A19FA, end: 0x001A1A1A }, // ASW TeamLogoPalettes, differs from 94 MatchupPalASWA.pal
    // NHL 95 graphics95 ArenaGfxBank ($1A1A1A): the home team graphics, $30A bytes per team in bank order (TeamGfxList, middle95).
    { name: 'ArenaGfxANH.bin', folder: 'NHL95/Graphics/ArenaGfx', start: 0x001A1A1A, end: 0x001A1D24 }, // ArenaGfxBank+$0, ANH
    { name: 'ArenaGfxBUF.bin', folder: 'NHL95/Graphics/ArenaGfx', start: 0x001A1D24, end: 0x001A202E }, // ArenaGfxBank+$30A, BUF
    { name: 'ArenaGfxCGY.bin', folder: 'NHL95/Graphics/ArenaGfx', start: 0x001A202E, end: 0x001A2338 }, // ArenaGfxBank+$614, CGY
    { name: 'ArenaGfxCHI.bin', folder: 'NHL95/Graphics/ArenaGfx', start: 0x001A2338, end: 0x001A2642 }, // ArenaGfxBank+$91E, CHI
    { name: 'ArenaGfxDAL.bin', folder: 'NHL95/Graphics/ArenaGfx', start: 0x001A2642, end: 0x001A294C }, // ArenaGfxBank+$C28, DAL
    { name: 'ArenaGfxDET.bin', folder: 'NHL95/Graphics/ArenaGfx', start: 0x001A294C, end: 0x001A2C56 }, // ArenaGfxBank+$F32, DET
    { name: 'ArenaGfxEDM.bin', folder: 'NHL95/Graphics/ArenaGfx', start: 0x001A2C56, end: 0x001A2F60 }, // ArenaGfxBank+$123C, EDM
    { name: 'ArenaGfxFLA.bin', folder: 'NHL95/Graphics/ArenaGfx', start: 0x001A2F60, end: 0x001A326A }, // ArenaGfxBank+$1546, FLA
    { name: 'ArenaGfxHFD.bin', folder: 'NHL95/Graphics/ArenaGfx', start: 0x001A326A, end: 0x001A3574 }, // ArenaGfxBank+$1850, HFD
    { name: 'ArenaGfxLA.bin', folder: 'NHL95/Graphics/ArenaGfx', start: 0x001A3574, end: 0x001A387E }, // ArenaGfxBank+$1B5A, LA
    { name: 'ArenaGfxMTL.bin', folder: 'NHL95/Graphics/ArenaGfx', start: 0x001A387E, end: 0x001A3B88 }, // ArenaGfxBank+$1E64, MTL
    { name: 'ArenaGfxNJ.bin', folder: 'NHL95/Graphics/ArenaGfx', start: 0x001A3B88, end: 0x001A3E92 }, // ArenaGfxBank+$216E, NJ
    { name: 'ArenaGfxNYI.bin', folder: 'NHL95/Graphics/ArenaGfx', start: 0x001A3E92, end: 0x001A419C }, // ArenaGfxBank+$2478, NYI
    { name: 'ArenaGfxNYR.bin', folder: 'NHL95/Graphics/ArenaGfx', start: 0x001A419C, end: 0x001A44A6 }, // ArenaGfxBank+$2782, NYR
    { name: 'ArenaGfxOTW.bin', folder: 'NHL95/Graphics/ArenaGfx', start: 0x001A44A6, end: 0x001A47B0 }, // ArenaGfxBank+$2A8C, OTW
    { name: 'ArenaGfxPHI.bin', folder: 'NHL95/Graphics/ArenaGfx', start: 0x001A47B0, end: 0x001A4ABA }, // ArenaGfxBank+$2D96, PHI
    { name: 'ArenaGfxPIT.bin', folder: 'NHL95/Graphics/ArenaGfx', start: 0x001A4ABA, end: 0x001A4DC4 }, // ArenaGfxBank+$30A0, PIT
    { name: 'ArenaGfxQUE.bin', folder: 'NHL95/Graphics/ArenaGfx', start: 0x001A4DC4, end: 0x001A50CE }, // ArenaGfxBank+$33AA, QUE
    { name: 'ArenaGfxSJ.bin', folder: 'NHL95/Graphics/ArenaGfx', start: 0x001A50CE, end: 0x001A53D8 }, // ArenaGfxBank+$36B4, SJ
    { name: 'ArenaGfxSTL.bin', folder: 'NHL95/Graphics/ArenaGfx', start: 0x001A53D8, end: 0x001A56E2 }, // ArenaGfxBank+$39BE, STL
    { name: 'ArenaGfxTB.bin', folder: 'NHL95/Graphics/ArenaGfx', start: 0x001A56E2, end: 0x001A59EC }, // ArenaGfxBank+$3CC8, TB
    { name: 'ArenaGfxTOR.bin', folder: 'NHL95/Graphics/ArenaGfx', start: 0x001A59EC, end: 0x001A5CF6 }, // ArenaGfxBank+$3FD2, TOR
    { name: 'ArenaGfxVAN.bin', folder: 'NHL95/Graphics/ArenaGfx', start: 0x001A5CF6, end: 0x001A6000 }, // ArenaGfxBank+$42DC, VAN
    { name: 'ArenaGfxWSH.bin', folder: 'NHL95/Graphics/ArenaGfx', start: 0x001A6000, end: 0x001A630A }, // ArenaGfxBank+$45E6, WSH
    { name: 'ArenaGfxWPG.bin', folder: 'NHL95/Graphics/ArenaGfx', start: 0x001A630A, end: 0x001A6614 }, // ArenaGfxBank+$48F0, WPG
    { name: 'ArenaGfxBOS.bin', folder: 'NHL95/Graphics/ArenaGfx', start: 0x001A6614, end: 0x001A691E }, // ArenaGfxBank+$4BFA, BOS
    { name: 'ArenaGfxASEASW.bin', folder: 'NHL95/Graphics/ArenaGfx', start: 0x001A691E, end: 0x001A6C28 }, // ArenaGfxBank+$4F04, ASE / ASW
];
// The licensed names of the ROM, in the order of the rows of src/teamdata95.asm (the team records in ROM order): the player names
// (the Player rows) and the team nicknames (the .tm String of each team; the All-Star teams have a generic one that stays in the
// source). TeamList ($772) holds 28 long pointers to the team records. A record starts with six word offsets, the first leads to
// the players: each is a row prefix word that counts itself, the name (padded to an even length with $00) and 8 rating bytes; the
// word 2 (an empty String) ends them. Then come four Strings (a length word that counts itself, then the text): city,
// abbreviation, nickname, arena.
const TEAM_LIST = 0x772;
function readTeamNames(romData) {
  const records = [];
  for (let i = 0; i < 28; i++) records.push(romData.readUInt32BE(TEAM_LIST + i * 4));
  records.sort((a, b) => a - b);
  const players = [], nicknames = [];
  for (const rec of records) {
    let pos = rec + romData.readUInt16BE(rec);
    for (let len = romData.readUInt16BE(pos); len > 2; len = romData.readUInt16BE(pos)) {
      players.push(romData.toString('latin1', pos + 2, pos + len).replace(/\0/g, ''));
      pos += len + 8;
    }
    pos += 2;                                            // the empty String that ends the players
    pos += romData.readUInt16BE(pos);                    // city
    pos += romData.readUInt16BE(pos);                    // abbreviation
    const len = romData.readUInt16BE(pos);               // nickname
    const nick = len > 2 ? romData.toString('latin1', pos + 2, pos + len).replace(/\0/g, '') : '';
    if (nick && !nick.startsWith('All Stars')) nicknames.push(nick);
  }
  return { players, nicknames };
}
const outRoot = path.join(ROOT, 'Extracted');
const rom = fs.readFileSync(romPath);
const version = detectVersion(rom);
console.log('ROM: ' + version.label);
// The completion marker is written last; remove it first so a broken run leaves none.
const markerPath = path.join(outRoot, '.extract-complete.json');
fs.rmSync(markerPath, { force: true });
const written = [];
for (const asset of assets) {
  const dir = path.join(outRoot, asset.folder);
  fs.mkdirSync(dir, { recursive: true });
  const data = rom.subarray(version.map(asset.start), version.map(asset.end - 1) + 1);
  fs.writeFileSync(path.join(dir, asset.name), data);
  written.push({ path: path.posix.join(asset.folder.replace(/\\/g, '/'), asset.name), size: data.length });
}
// The licensed names (see readTeamNames).
const { players, nicknames } = readTeamNames(rom);
for (const [file, lines] of [['PlayerNames.txt', players], ['TeamNicknames.txt', nicknames]]) {
  const text = lines.join('\n') + '\n';
  fs.writeFileSync(path.join(outRoot, file), text, 'latin1');
  written.push({ path: file, size: text.length });
}
// Completion marker for tools/prebuild.js: ROM, extractor version and every file written.
const sha1 = (b) => require('crypto').createHash('sha1').update(b).digest('hex');
fs.writeFileSync(markerPath, JSON.stringify({ rom: version.id, romSha1: sha1(rom), extractor: path.basename(__filename),
  extractorSha1: sha1(fs.readFileSync(__filename)), files: written }, null, 1) + '\n');
console.log('Extracted ' + assets.length + ' slices and ' + players.length + ' player names to ' + outRoot + '.');
