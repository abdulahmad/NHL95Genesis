	include	macros\genesis.mac	;String

;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
;
;	Segment stub.
;
;<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<

; region code
	org	$9AC8

; includes for stubs to replace removed code
	include	stubinc\ports.inc	;IO_* / VDP_* ports
	include	stubinc\equals.inc	;VDP status bits
	include	ram95.asm		;RAM map

; External addresses outside, read from lst/nhl95.bin: jsr / jmp (x).l and movea.l / move.l #x carry the address
; bsr.w is the displacement word address + displacement. 94 names where the 95 body is the 94 routine.
KillCrowd = $67988
newTitleScreen = $A12AA
play_new_song = $67938		;Stop the song in progress.
SoundCmd = $676D8
song = $678C2
Z80Program = $BD86
SoundBanks = $D8EC
GameSetUp = $85A9E		;The main menu.
PracticeGoalies = $8CADE
SeasonMain = $8E06E
TradePlayers = $96C14
CreatePlayer = $97D9A
SignFreeAgents = $99E8C
ReleasePlayers = $9A5C8
SetContTeams = $8CD3C		;set cont1team-cont4team.
UserNameEntry = $9B6F4
PlayoffScreen = $87BA2
vb2 = $7A3F6
ReadJoy1 = $7A4B0
ClearShotData = $883B8
clearTeamStats = $AE48
reenergizeteam = $7DBA2	;a2 team, energy $1000, -3 slots to -2.
Create_HotCold_Table = $83E88
ScoutingReport = $9F590
restoreteams = $83D3E
setupice = $7DD06
ResetClock = $7D4A0
SoundOff = $679B2
UpdateScores = $8827C
DisplayTeamStatsForPlayoffs = $87714
GameOver = $8CCE6
assreplace = $8157A
ChooseSong = $679C4
demoread = $8DF5A
Pausemode = $7E36C
CheckNewCarrier = $7D8B2	;clear GameFlags bits 0-1 when puckc changes.
PenaltyManager = $891FE
updatecrowdf = $A0B3E
updatesound = $67710
clockcont = $8CD08
ChkGoalies = $835C6
UpdateCwdExcite = $676E8
CheckPeriodEnd = $6776A
UpdateLineChange = $7DB40
CheckInjury = $9F282
updatepwrplay = $9F45E
checkwindow = $8C900
setSlotBit = $833FE
SprSort = $A8E6
updatereplay = $8D55E
setvideo = $A204
UpdateRecords = $9C01A
SetupTeamForIntermission = $8A572
PlaceBoardFall = $8C1FA
updateanim = $A536
loadTeamStruct = $7CAF0
updatevel = $8BB6C		;the velocity update the 94 version does in line.
setpads = $AB2A
updatepadinput = $A95C		;the pad input the 94 version does in line (.tp2).
; SPA tables
SPAboardtop = $20B0
SPAboardright = $2122
SPAboardbot = $219C
SPAboardleft = $220E
SPAinjuryfall = $2454
SPAinjury1 = $2496
SPAinjury2 = $24D8
SPAboardmidl = $26C8
SPAboardmidr = $276A

; Main segment code
	include	hockey95.asm
