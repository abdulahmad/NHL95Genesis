;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
;
;	season95 segment stub. Retail $08DF5A-$0920DD.
;
;<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<

; region code
	org	$8DF5A

; includes for stubs to replace removed code
	include	stubinc\ports.inc	;IO_* / VDP_* ports
	include	stubinc\equals.inc	;VDP status bits
	include	ram95.asm		;RAM map

; External addresses outside $08DF5A-$0920DD, read from lst/nhl95.bin.
ZeroLong = $69A			;main95
SeasonSchedule = $8DD8		;frames95
SeasonScheduleEnd = $9721	;sram95
WriteSRAM = $98E6		;sram95
MakeSRAMChecksum = $9908	;sram95
ReadSRAM = $9952		;sram95
Opening2 = $9ADA		;hockey95
setvram = $79936		;video95
dobitmap = $79A3C		;video95
DoDMA_clearCallbackPointer = $79AC0	;video95
forceblack = $7A02A		;video95
DecompressGraphicsWithCallback = $7A264	;video95
Framer = $7A270			;video95
VBlank_SetOptions = $7A418	;video95
orjoy = $7A448			;video95
orjoy4way = $7A456		;video95
ReadJoy1 = $7A4B0		;video95
ReadJoy2 = $7A4C8		;video95
ReadJoy3 = $7A4E0		;video95
ReadJoy4 = $7A50C		;video95
ProcessInputWithRepeat = $7A762	;video95
randomd0s = $7C62E		;middle95
randomd0 = $7C63A		;middle95
printz2 = $7C6D4		;middle95
printsmall = $7C6E6		;middle95
printz = $7C810			;middle95
print = $7C822			;middle95
eraser = $7C8CC			;middle95
PrintListItem = $7CB2E		;middle95
ReadAttributeNibbleD7 = $7CB60	;middle95
PushNumberWidth = $7D154	;middle95
appstring = $7D214		;middle95
printbigz = $7D8D2		;middle95
startpause1 = $7E7F8		;pause95
startpause2 = $7E7FE		;pause95
startpause3 = $7E806		;pause95
startpause4 = $7E80E		;pause95
GetPlayerCountD7 = $83904	;players95
GameSetUp = $85A9E		;setup95
ExitToOpening = $8CD02		;goal95
InitSeasonStats = $92BEC	;stats95
SaveSimGame = $92CAE		;stats95
SeasonPlayerStats = $9348A	;stats95
SeasonTeamStats = $93BD2	;stats95
LeagueLeadersScreen = $94110	;stats95
HighlightsScreen = $95D28	;stats95
SeasonAwards = $9C766		;awards95
InitPlayoffs = $9D4CE		;awards95
SetupPlayoffs = $9D662		;awards95
NextPlayoffRound = $9D748	;awards95
PlayoffRoundDone = $9D7C0	;awards95
ReadPlayoffSchedule = $9D8AE	;awards95
RecordPlayoffGame = $9D8D2	;awards95
PlayoffTreeScreen = $9D9CE	;shootout95
StanleyCupScreen = $A17B8	;title95
SmallFontMap = $139094		;graphics95
Teamblocksmap = $142906		;graphics95
Framermap = $14C148		;graphics95
BigFontMap2 = $15F46C		;graphics95
ControllerBgMap = $164AC8	;graphics95
GamesTodayLogoMap = $165A36	;graphics95
GamesTodayMap1 = $167524	;graphics95
GamesTodayMap2 = $16767E	;graphics95
GamesTodayMap3 = $16781E	;graphics95
CalendarBgMap = $167A44		;graphics95
CalOpponentMap = $168E72	;graphics95
CalDayMap = $1696DC		;graphics95
CalMonthMap = $169CE6		;graphics95
CalCheckMap = $16A814		;graphics95
CalResultMap = $16A8BC		;graphics95
WaitBoxMap = $16CC82		;graphics95

; Main segment code
	include	front\season95.asm
