	include	macros\genesis.mac	;String (main95.asm includes it in the full build)

;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
;
;	hockey95 segment stub. Retail $009AC8-$00A203.
;
;<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<

; region code
	org	$9AC8

; includes for stubs to replace removed code
	include	stubinc\ports.inc	;IO_* / VDP_* ports
	include	stubinc\equals.inc	;VDP status bits
	include	ram95.asm		;RAM map

; External addresses outside $009AC8-$00A203, read from lst/nhl95.bin: jsr / jmp (x).l and movea.l / move.l #x carry the address;
; bsr.w is the displacement word address + displacement. 94 names where the 95 body is the 94 routine.
KillCrowd = $67988		;sound95_01
newTitleScreen = $A12AA		;title95_02
play_new_song = $67938		;Stop the song in progress. (sound95_01)
SoundCmd = $676D8		;sound95_01
song = $678C2			;sound95_01
Z80Program = $BD86		;sounddrv95
SoundBanks = $D8EC		;sounddrv95
GameSetUp = $85A9E		;The main menu. (data95_01)
PracticeGoalies = $8CADE	;95 only. (checks95_06)
SeasonMain = $8E06E		;95 only. (season95)
TradePlayers = $96C14		;95 only. (trade95)
CreatePlayer = $97D9A		;95 only. (create95)
SignFreeAgents = $99E8C		;95 only. (create95)
ReleasePlayers = $9A5C8		;95 only. (create95)
SetContTeams = $8CD3C		;95 only: set cont1team-cont4team. (checks95_06)
UserNameEntry = $9B6F4		;cards95_01
PlayoffScreen = $87BA2		;setup95_02
vb2 = $7A3F6			;video95_02
ReadJoy1 = $7A4B0		;video95_02
ClearShotData = $883B8		;checks95_04
clearTeamStats = $AE48		;setup95_01
ResetTeamEnergy = $7DBA2	;95 only: a2 team, energy $1000, -3 slots to -2. (video95_03)
Create_HotCold_Table = $83E88	;collide95_02
ScoutingReport = $9F590		;scout95
restoreteams = $83D3E		;collide95_02
setupice = $7DD06		;video95_03
ResetClock = $7D4A0		;video95_03
SoundOff = $679B2		;sound95_01
UpdateScores = $8827C		;checks95_04
AddPOStats = $87714		;data95_01
GameOver = $8CCE6		;checks95_06
assreplace = $8157A		;checks95_02
ChooseSong = $679C4		;sound95_01
demoread = $8DF5A		;season95
Pausemode = $7E36C		;hockey95_02
CheckNewCarrier = $7D8B2	;95 only: clear GameFlags bits 0-1 when puckc changes. (video95_03)
PenaltyManager = $891FE		;penalty95
updatecrowdf = $A0B3E		;stats95_02
updatesound = $67710		;sound95_01
clockcont = $8CD08		;checks95_06
ChkGoalies = $835C6		;checks95_03
UpdateCwdExcite = $676E8	;sound95_01
CheckPeriodEnd = $6776A		;sound95_01
UpdateLineChange = $7DB40	;video95_03
CheckInjury = $9F282		;checks95_07
updatepwrplay = $9F45E		;checks95_07
checkwindow = $8C900		;checks95_06
setSlotBit = $833FE		;checks95_03
SprSort = $A8E6			;setup95_01
updatereplay = $8D55E		;replay95
setvideo = $A204		;display95_01
UpdateRecords = $9C01A		;cards95_02
SetupTeamForIntermission = $8A572	;checks95_05
PlaceBoardFall = $8C1FA		;checks95_06
updateanim = $A536		;display95_01
loadTeamStruct = $7CAF0		;video95_03
updatevel = $8BB6C		;95 only: the velocity update 94 updateplayers does in line. (checks95_06)
setpads = $AB2A			;setup95_01
updatepadinput = $A95C		;95 only: the pad input 94 updateplayers does in line (.tp2). (setup95_01)
; frames95 SPA tables (frames95.asm defines them in the full build)
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
