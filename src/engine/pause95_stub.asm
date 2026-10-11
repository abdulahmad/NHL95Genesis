	include	macros\genesis.mac	;String (main95.asm includes it in the full build)
;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
;
;	pause95 segment stub. Retail $07E36C-$07FCFB.
;
;<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<

; region code
	org	$7E36C

; includes for stubs to replace removed code
	include	stubinc\ports.inc	;IO_* / VDP_* ports
	include	stubinc\equals.inc	;VDP status bits
	include	ram95.asm		;RAM map

; External addresses outside $07E36C-$07FCFB, read from lst/nhl95.bin.
ZeroLong = $69A		;main95
Opening2 = $9ADA		;hockey95
setvideo = $A204		;display95
SprSort = $A8E6		;display95
setc1player = $AD80		;control95
setc2player = $AD8A		;control95
setplayercolors = $AF1A		;control95
Z80Program = $BD86		;sound95
SoundBanks = $D8EC		;sound95
SoundCmd = $676D8		;sound95
play_new_song = $67938		;sound95
KillCrowd = $67988		;sound95
SoundOff = $679B2		;sound95
DoFill = $79902		;video95
setVram_0 = $7994C		;video95
Vmaddr = $79A22		;video95
dobitmap = $79A3C		;video95
DoDMA_clearCallbackPointer = $79AC0		;video95
SetScroll2 = $79CCA		;video95
forceblack = $7A02A		;video95
DecompressGraphicsWithCallback = $7A264		;video95
AddFramer2 = $7A310		;video95
VBlank = $7A332		;video95
ReadMenuJoy = $7A6AA		;video95
ProcessInputWithRepeat = $7A762		;video95
WaitVSyncAndReadInput = $7A79C		;video95
vcountwait = $7C6BE		;middle95
printsmallz = $7C6D4		;middle95
printsmall = $7C6E6		;middle95
printz = $7C810		;middle95
print = $7C822		;middle95
eraser = $7C8CC		;middle95
showclock = $7C90A		;middle95
ReadAttributeNibble = $7CB4E		;middle95
GetPlayerNameWithAttrib = $7CCD2		;middle95
FormatPlayerNameWithAttrib = $7CD38		;middle95
ConverByteToDigits = $7CEF6		;middle95
PushTime = $7D0BC		;middle95
PrintTeamData = $7D268		;middle95
setupTeamBlocksMap = $7D2AE		;middle95
setupIceRinkMap = $7D6F0		;middle95
waitx = $7D706		;middle95
printscores1 = $7D776		;middle95
AddFonts = $7D858		;middle95
RestoreTeamEnergy = $7DB7C		;middle95
LoadHomeTeamGfx = $7DEA0		;middle95
setupEASNmap = $7DF6A		;middle95
AnyPadAssigned = $7DFAC		;fourway95
setpersonel = $836CC		;players95
TeamRosterScreen = $84FE8		;Pause menu TEAM ROSTER (setup95)
DrawFaceoffWindow = $88E42		;95: the face off window (faceoff95)
Penaltylist = $89C2E		;penalty95
PracticeGoalies = $8CADE		;goal95
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
Rinktilelist = $C4A7C		;Rink map (graphics95)
PauseBgBitmap = $13AC70		;graphics95
PeriodNumberBitmap = $13E09E		;graphics95
TabBitmap = $13E21C		;graphics95
PauseFontMap = $13EEAA		;graphics95
ClockDigitsBitmap = $13FC18		;graphics95
PauseTeamBlocksMap = $146D24		;graphics95
FaceoffTiles = $149E32		;graphics95
FaceoffTiles2 = $14A490		;graphics95
EnergyBarMap = $14C4C8		;graphics95
RefTiles = $14EB04		;graphics95
RefTilesHor = $14FBA2		;graphics95
CrowdFrameList = $18B628		;graphics95

; Main segment code
	include	engine\pause95.asm
