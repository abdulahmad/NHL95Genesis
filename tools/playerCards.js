// playerCards.js: which player has which player card picture, read from the source (no ROM needed).
// playerCards() -> one entry per Player row of src/teamdata95.asm, in file order (the order of the ids P001 ...):
//   { team: 'BOS', slot: 17, card: 'Card002' or null }
// GetPlayerPicture looks a player up in the first six entries of line 1 of his team (the .ls table of the team record, player numbers, 1 =
// the first Player row); position k there has the picture FeaturedPictures[FeaturedPicIdx[team][k]] (src/graphics95.asm). All-Star players
// have pictures of their own.
const fs = require('fs');
const path = require('path');
const read = (f) => fs.readFileSync(path.join(__dirname, '..', 'src', f), 'latin1').split(/\r?\n/);

function playerCards() {
    const td = read('teamdata95.asm');
    const abbr = {};                                          // team record label -> abbreviation, from the TeamList comments
    for (const l of td) {
        const m = /^\s*dc\.l\s+(\w+)\s*;\d+ (\w+)/.exec(l);
        if (m) abbr[m[1]] = m[2];
    }
    const rows = [], starters = {};                           // starters: abbreviation -> the six roster indexes of line 1
    let team = null, slot = 0, afterLs = false;
    for (const l of td) {
        const m = /^(\w+)/.exec(l);
        if (m && abbr[m[1]]) { team = abbr[m[1]]; slot = 0; afterLs = false; continue; }
        if (/^\.ls\b/.test(l)) { afterLs = true; continue; }
        if (afterLs) {
            const d = /^\s*dc\.b\s+([\d, ]+)/.exec(l);
            if (d) { starters[team] = d[1].split(',').slice(0, 6).map((x) => Number(x) - 1); afterLs = false; }
            continue;
        }
        if (/^\s*Player\s/.test(l)) rows.push({ team, slot: slot++, card: null });
    }
    const g = read('graphics95.asm');
    const idx = {}, pictures = [];
    let mode = null;
    for (const l of g) {
        if (/^FeaturedPicIdx\b/.test(l)) { mode = 'idx'; continue; }
        if (/^FeaturedPictures\b/.test(l)) { mode = 'pics'; continue; }
        if (mode === 'idx') {
            const m = /^\s*dc\.b\s+([\d, ]+?)\s*;(\w+)/.exec(l);
            if (m) idx[m[2]] = m[1].split(',').map(Number);
            else if (/^\S/.test(l)) mode = null;
        } else if (mode === 'pics') {
            const m = /^\s*dc\.l\s+([\w, ]+)/.exec(l);
            if (m) pictures.push(...m[1].split(',').map((x) => x.trim()));
            else if (/^\S/.test(l)) mode = null;
        }
    }
    const bySlot = {};
    for (const [ab, six] of Object.entries(starters)) {
        bySlot[ab] = {};
        six.forEach((s, k) => { const pic = pictures[(idx[ab] || [])[k]]; if (/^Card\d+$/.test(pic || '')) bySlot[ab][s] = pic; });
    }
    for (const r of rows) r.card = (bySlot[r.team] || {})[r.slot] || null;
    return rows;
}
module.exports = { playerCards };
