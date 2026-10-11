	include	macros\genesis.mac	;String
;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
;
;	Segment stub.
;
;<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<

; region code
	org	$7E36C

; includes for stubs to replace removed code
	include	stubinc\ports.inc	;IO_* / VDP_* ports
	include	stubinc\equals.inc	;VDP status bits
	include	ram95.asm		;RAM map

; External addresses outside, read from lst/nhl95.bin.
ZeroLong = $69A
Opening2 = $9ADA
setvideo = $A204
SprSort = $A8E6
setc1player = $AD80
setc2player = $AD8A
setplayercolors = $AF1A
Z80Program = $BD86
SoundBanks = $D8EC
SoundCmd = $676D8
play_new_song = $67938
KillCrowd = $67988
SoundOff = $679B2
DoFill = $79902
setVram_0 = $7994C
Vmaddr = $79A22
dobitmap = $79A3C
DoDMA_clearCallbackPointer = $79AC0
SetScroll2 = $79CCA
forceblack = $7A02A
DecompressGraphicsWithCallback = $7A264
AddFramer2 = $7A310
VBlank = $7A332
ReadMenuJoy = $7A6AA
ProcessInputWithRepeat = $7A762
WaitVSyncAndReadInput = $7A79C
vcountwait = $7C6BE
printsmallz = $7C6D4
printsmall = $7C6E6
printz = $7C810
print = $7C822
eraser = $7C8CC
showclock = $7C90A
GetGoalieCount = $7CB4E
GetPlayerNumInitial = $7CCD2
FormatPlayerNumInitial = $7CD38
ConverByteToDigits = $7CEF6
PushTime = $7D0BC
PrintTeamData = $7D268
setupTeamBlocksMap = $7D2AE
setupIceRinkMap = $7D6F0
waitx = $7D706
printscores1 = $7D776
AddFonts = $7D858
RestoreTeamEnergy = $7DB7C
LoadHomeTeamGfx = $7DEA0
setupEASNmap = $7DF6A
AnyPadAssigned = $7DFAC
setpersonel = $836CC
TeamRosterScreen = $84FE8		;Pause menu TEAM ROSTER
DrawFaceoffWindow = $88E42		;the face off window
Penaltylist = $89C2E
PracticeGoalies = $8CADE
ReplayMode = $8D668		;Pause menu INSTANT REPLAY
GameStatisticsScreen = $920DE		;Pause menu GAME STATS
PlayerStatsScreen = $925B0		;Pause menu PLAYER STATS
SeasonPlayersScreen = $934CC		;Pause menu SEASON PLAYERS
SeasonTeamsScreen = $93C14		;Pause menu SEASON TEAMS
PeriodStatsScreen = $94ED2		;Pause menu PERIOD STATS
LineEditor = $95220		;Pause menu EDIT LINES
GetRosterName = $9649E		;a1 = name String of player d0 of team d7 (season roster aware)
GetJerseyNumber = $965A8		;jerseynum = the jersey number byte of player d0 of team d7
PlayoffStatsScreen = $9B8D6		;Pause menu PLAYOFF STATS
RecordHoldersScreen = $9B90E		;Pause menu RECORD HOLDERS
ShootoutShooters = $9E058		;Pause menu SHOOTOUT SETUP
ScoringSummaryScreen = $A0D1A		;Pause menu SCORING SUMMARY
PenaltySummaryScreen = $A1022		;Pause menu PENALTY SUMMARY
Rinktilelist = $C4A7C		;Rink map
PauseBgBitmap = $13AC70
PeriodNumberBitmap = $13E09E
TabBitmap = $13E21C
PauseFontMap = $13EEAA
ClockDigitsBitmap = $13FC18
PauseTeamBlocksMap = $146D24
FaceoffTiles = $149E32
FaceoffTiles2 = $14A490
EnergyBarMap = $14C4C8
RefTiles = $14EB04
RefTilesHor = $14FBA2
CrowdFrameList = $18B628

; Main segment code
	include	engine\pause95.asm
