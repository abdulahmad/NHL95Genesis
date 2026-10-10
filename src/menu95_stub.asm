	include	macros\genesis.mac	;String (main95.asm includes it in the full build)
;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
;
;	menu95 segment stub. Retail $07E4D6-$07F97D.
;
;<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<

; region code
	org	$7E4D6

; includes for stubs to replace removed code
	include	stubinc\ports.inc	;IO_* / VDP_* ports
	include	stubinc\equals.inc	;VDP status bits
	include	ram95.asm		;RAM map

; External addresses outside $07E4D6-$07F97D, read from lst/nhl95.bin.
ZeroLong = $69A			;main95
Opening2 = $9ADA		;hockey95
SprSort = $A8E6			;setup95_01
setplayercolors = $AF1A		;setup95_01
DoFill = $79902			;video95_01
setVram_0 = $7994C		;video95_01
Vmaddr = $79A22			;video95_01
dobitmap = $79A3C		;video95_01
DoDMA_clearCallbackPointer = $79AC0	;video95_01
SetScroll2 = $79CCA		;video95_01
DecompressGraphicsWithCallback = $7A264	;video95_02
AddFramer2 = $7A310		;video95_02
VBlank = $7A332			;video95_02
printz2 = $7C6D4		;video95_03
printsmall = $7C6E6		;video95_03
printz = $7C810			;video95_03
print = $7C822			;video95_03
eraser = $7C8CC			;video95_03
showclock = $7C90A		;video95_03
FormatPlayerNameWithAttrib = $7CD38	;video95_03
d0toascii = $7CEF6		;video95_03
PushTime = $7D0BC		;video95_03
PutTeamBlock = $7D268		;video95_03
setupTeamBlocksMap = $7D2AE	;video95_03
SetRinkPalette = $7D6F0		;video95_03
PrintScores1 = $7D776		;video95_03
AddFonts = $7D858		;video95_03
LoadHomeTeamGfx = $7DEA0	;fourway95
setupEASNmap = $7DF6A		;fourway95
ManualGoalieMenu = $7F97E	;Pause menu MANUAL GOALIE (checks95_01)
SelectGoalieMenu = $7FA66	;Pause menu CHANGE GOALIE (checks95_01)
TimeoutMenu = $7FB94		;Pause menu TIMEOUT (checks95_01)
PauseScores = $7FC04		;95: both team scores in big digits on the pause screen (checks95_01)
SetMenuPadSide = $7FCBA	;95 only: sflags bit 1 = the team of pad menupadnum is above 1 (checks95_01)
TeamRosterScreen = $84FE8	;Pause menu TEAM ROSTER (data95_01)
DrawFaceoffWindow = $88E42	;95: the face off window (checks95_04)
PenaltyNames = $89C2E		;Penalty name Strings by penalty number (ShowPenaltyMessages)
ReplayMode = $8D668		;Pause menu INSTANT REPLAY
GameStatisticsScreen = $920DE	;Pause menu GAME STATS
PlayerStatsScreen = $925B0	;Pause menu PLAYER STATS
SeasonPlayersScreen = $934CC	;Pause menu SEASON PLAYERS
SeasonTeamsScreen = $93C14	;Pause menu SEASON TEAMS
PeriodStatsScreen = $94ED2	;Pause menu PERIOD STATS
LineEditor = $95220		;Pause menu EDIT LINES
GetRosterName = $9649E
GetJerseyNumber = $965A8
PlayoffStatsScreen = $9B8D6	;Pause menu PLAYOFF STATS
RecordHoldersScreen = $9B90E	;Pause menu RECORD HOLDERS
ShootoutSetup = $9E058		;Pause menu SHOOTOUT SETUP
ScoringSummaryScreen = $A0D1A	;Pause menu SCORING SUMMARY
PenaltySummaryScreen = $A1022	;Pause menu PENALTY SUMMARY
Rinktilelist = $C4A7C		;graphics95_01
PauseBgBitmap = $13AC70		;graphics95_01
PeriodNumberBitmap = $13E09E	;graphics95_01
TabBitmap = $13E21C		;graphics95_01
PauseFontMap = $13EEAA		;graphics95_01
ClockDigitsBitmap = $13FC18	;graphics95_01
PauseTeamBlocksMap = $146D24	;graphics95_01
FaceoffTiles = $149E32		;graphics95_01
FaceoffTiles2 = $14A490		;graphics95_01
EnergyBarMap = $14C4C8		;graphics95_01
RefTiles = $14EB04		;graphics95_01
RefTilesHor = $14FBA2		;graphics95_01
CrowdFrameList = $18B628	;graphics95_01

; Main segment code
	include	menu95.asm
