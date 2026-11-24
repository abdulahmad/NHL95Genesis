# NHL 95 Genesis: the manual's features and the code behind them

The manual is a lead; the code is what shows the feature is there. Pages are the archive.org scan
(SEGAGenesisMegaDriveManuals), PDF p.N; other copies may be a page off. Written 2026-11-24.

## New features for 95 (PDF p.2)

| Manual line | Code |
| --- | --- |
| 1993-94 rosters and ratings | src/teamdata95.asm |
| Season play | `SeasonMain` (src/front/season95.asm) |
| Practice mode | `PracticePlayersTbl`, `PullPracticePlayers` (src/engine/goal95.asm) |
| Player creation | `CreatePlayer` (src/front/create95.asm) |
| League leaders | `MenuLeagueLeaders` (season95.asm), `BuildLeaderList` (src/sram95.asm) |
| Player trades | `ExecuteTrade` (src/front/trade95.asm) |
| Drop passes | `dopass` (src/engine/input95.asm) |
| Fake shots | `SPAfakeshotf` / `b` (src/frames95.asm), `SetShotMode` (input95.asm) |
| Block shots | `CanBlock`, `chkblock` (src/engine/replay95.asm), `SPAblock` |
| Erasable seasons | `ClearSeasonData` (season95.asm): a new season clears the saved one |

Holding A, C and START at power-on erases every record (PDF p.2). Code: `InitSaveRAM` (src/sram95.asm) runs a save-RAM
test on Start+A+C that writes every byte.

## Modes and options

- Practice: "up to two skaters (plus goalie) per side" (PDF p.8). Code: the 0-2 of `PracticePlayersTbl`.
- Shootout (PDF p.8): `ClearShootout`, `StartShootoutPath` (src/front/shootout95.asm).
- Goalie control, Manual or Automatic (PDF p.7, p.12): `OptGoalie` (src/ram95.asm).
- 4 Way Play for three or four players (PDF p.5-6): `Detect4WayPlay` (src/engine/fourway95.asm).
- User records (PDF p.22): `UpdateUserRecord` (src/front/records95.asm).

## Moves

- Fake shot: "tap A" in the offensive zone (PDF p.12). Code: `doinput` (input95.asm) sets the fake-shot flag in
  `GameFlags` when A is released in the attacking zone.
- Shot block: press A in the defensive zone while an opponent shoots (PDF p.13). Code: `CanBlock` (replay95.asm), for a
  joystick player, once per shot, with position and direction tests; the defensive-zone rule as such: not
  confirmed in code.
- Penalty shots for a penalty on a breakaway puck carrier (PDF p.14): `PenShotChk` (src/front/shootout95.asm).
- Credits: programmer Mark Lesser (PDF p.2).
