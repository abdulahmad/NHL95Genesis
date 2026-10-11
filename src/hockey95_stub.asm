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
KillCrowd = $67988		;sound95
newTitleScreen = $A12AA		;title95
play_new_song = $67938		;Stop the song in progress. (sound95)
SoundCmd = $676D8		;sound95
song = $678C2			;sound95
Z80Program = $BD86		;sound95
SoundBanks = $D8EC		;sound95
GameSetUp = $85A9E		;The main menu. (setup95)
PracticeGoalies = $8CADE	;95 only. (goal95)
SeasonMain = $8E06E		;95 only. (season95)
TradePlayers = $96C14		;95 only. (trade95)
CreatePlayer = $97D9A		;95 only. (create95)
SignFreeAgents = $99E8C		;95 only. (create95)
ReleasePlayers = $9A5C8		;95 only. (create95)
SetContTeams = $8CD3C		;95 only: set cont1team-cont4team. (goal95)
UserNameEntry = $9B6F4		;records95
PlayoffScreen = $87BA2		;playoff95
vb2 = $7A3F6			;video95
ReadJoy1 = $7A4B0		;video95
ClearShotData = $883B8		;faceoff95
clearTeamStats = $AE48		;control95
ResetTeamEnergy = $7DBA2	;95 only: a2 team, energy $1000, -3 slots to -2. (middle95)
Create_HotCold_Table = $83E88	;players95
ScoutingReport = $9F590		;scout95
restoreteams = $83D3E		;players95
setupice = $7DD06		;middle95
ResetClock = $7D4A0		;middle95
SoundOff = $679B2		;sound95
UpdateScores = $8827C		;faceoff95
AddPOStats = $87714		;setup95
GameOver = $8CCE6		;goal95
assreplace = $8157A		;logic95
ChooseSong = $679C4		;sound95
demoread = $8DF5A		;season95
Pausemode = $7E36C		;pause95
CheckNewCarrier = $7D8B2	;95 only: clear GameFlags bits 0-1 when puckc changes. (middle95)
PenaltyManager = $891FE		;penalty95
updatecrowdf = $A0B3E		;crowd95
updatesound = $67710		;sound95
clockcont = $8CD08		;goal95
ChkGoalies = $835C6		;logic95
UpdateCwdExcite = $676E8	;sound95
CheckPeriodEnd = $6776A		;sound95
UpdateLineChange = $7DB40	;middle95
CheckInjury = $9F282		;injury95
updatepwrplay = $9F45E		;injury95
checkwindow = $8C900		;goal95
setSlotBit = $833FE		;logic95
SprSort = $A8E6			;display95
updatereplay = $8D55E		;replay95
setvideo = $A204		;display95
UpdateRecords = $9C01A		;records95
SetupTeamForIntermission = $8A572	;lines95
PlaceBoardFall = $8C1FA		;skate95
updateanim = $A536		;display95
loadTeamStruct = $7CAF0		;middle95
updatevel = $8BB6C		;95 only: the velocity update 94 updateplayers does in line. (skate95)
setpads = $AB2A			;control95
updatepadinput = $A95C		;95 only: the pad input 94 updateplayers does in line (.tp2). (control95)
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
