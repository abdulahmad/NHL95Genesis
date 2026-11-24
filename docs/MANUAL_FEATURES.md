# NHL 95 Genesis: the manual's features and where they are in the code

Pages are the page of the archive.org scan (SEGAGenesisMegaDriveManuals), PDF p.N; other copies may be a page off.
"Open" means the code has not been located. Written 2026-11-24.

## New features for 95 (PDF p.2)

The manual lists these as new in NHL '95:

| Manual line | Code |
| --- | --- |
| 1993-94 rosters and ratings | src/teamdata95.asm |
| Season play | src/front/season95.asm |
| Practice mode | `PracticePlayersTbl`, `PullPracticePlayers` |
| Player creation | src/front/create95.asm |
| League leaders | `LeagueLeaders` (stats95.asm) |
| Player trades | src/front/trade95.asm |
| Drop passes | `dopass` (src/engine/input95.asm) |
| Fake shots | `SPAfake` (input95.asm) |
| Block shots | `chkblock` (control95.asm), `SPAblock` |
| Erasable seasons | src/sram95.asm |

The page also says that holding A, C and START and pressing RESET erases every record on the cartridge.

## Modes and options

- Practice Mode: "up to two skaters (plus goalie) per side" (PDF p.8). That is the 0-2 of `PracticePlayersTbl`. The
  box calls it 2 on 2 "Jam".
- Shootout: "Choose teams and go one-on-one with the goalie" (PDF p.8): src/front/shootout95.asm.
- New Season erases the saved season (PDF p.8).
- Goalie control Manual or Automatic (PDF p.7, p.12): `OptGoalie` (src/ram95.asm, setup95.asm).
- 4 Way Play for three or four players, with the adapter plugged in before reset (PDF p.5-6): `Detect4WayPlay`
  (src/engine/fourway95.asm).
- User records are saved (PDF p.22): `UpdateUserRecord` (src/front/records95.asm).

## Moves

- Fake shot: "When in the offensive zone, tap A to fake a shot" (PDF p.12).
- Blocking defenders: "When in the defensive zone, press A to drop a defenseman to the ice while an opponent is
  shooting: he may be able to block the shot" (PDF p.13).
- Penalty shots are awarded for a penalty on a breakaway puck carrier (PDF p.14): `PenShotChk` (src/engine/penalty95.asm).
- Credits: programmer Mark Lesser (PDF p.2).
