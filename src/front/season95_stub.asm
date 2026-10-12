;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
;
;	Segment stub.
;
;<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<

; region code
	org	$8DF5A

; includes for stubs to replace removed code
	include	stubinc\ports.inc	;IO_* / VDP_* ports
	include	stubinc\equals.inc	;VDP status bits
	include	ram95.asm		;RAM map

; External addresses outside, read from lst/nhl95.bin.
ZeroLong = $69A
SeasonSchedule = $8DD8
SeasonScheduleEnd = $9721
WriteSRAM = $98E6
MakeSRAMChecksum = $9908
ReadSRAM = $9952
Opening2 = $9ADA
setVram = $79936
dobitmap = $79A3C
DecompressGraphicsPlain = $79AC0
forceblack = $7A02A
DecompressGraphicsWithCallback = $7A264
Framer = $7A270
VBlank_SetOptions = $7A418
orjoy = $7A448
orjoy4way = $7A456
ReadJoy1 = $7A4B0
ReadJoy2 = $7A4C8
ReadJoy3 = $7A4E0
ReadJoy4 = $7A50C
ProcessInputWithRepeat = $7A762
randomd0s = $7C62E
randomd0 = $7C63A
printsmallz = $7C6D4
printsmall = $7C6E6
printz = $7C810
print = $7C822
eraser = $7C8CC
PrintListItem = $7CB2E
GetGoalieCountD7 = $7CB60
PushNumberWidth = $7D154
appstring = $7D214
printbigz = $7D8D2
startpause1 = $7E7F8
startpause2 = $7E7FE
startpause3 = $7E806
startpause4 = $7E80E
GetPlayerCountD7 = $83904
GameSetUp = $85A9E
ExitToOpening = $8CD02
InitSeasonStats = $92BEC
SaveSimGame = $92CAE
SeasonPlayerStats = $9348A
SeasonTeamStats = $93BD2
LeagueLeadersScreen = $94110
HighlightsScreen = $95D28
SeasonAwards = $9C766
InitPlayoffs = $9D4CE
SetupPlayoffs = $9D662
NextPlayoffRound = $9D748
BuildPlayoffDayGames = $9D7C0
ReadPlayoffSchedule = $9D8AE
RecordPlayoffGame = $9D8D2
PlayoffTreeScreen = $9D9CE
StanleyCupScreen = $A17B8
SmallFontMap = $139094
Teamblocksmap = $142906
Framermap = $14C148
BigFontMap2 = $15F46C
ControllerBgMap = $164AC8
GamesTodayLogoMap = $165A36
GamesTodayMap1 = $167524
GamesTodayMap2 = $16767E
GamesTodayMap3 = $16781E
CalendarBgMap = $167A44
CalOpponentMap = $168E72
CalDayMap = $1696DC
CalMonthMap = $169CE6
CalCheckMap = $16A814
CalResultMap = $16A8BC
WaitBoxMap = $16CC82

; Main segment code
	include	front\season95.asm
