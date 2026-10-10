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
	include	stubinc\ram_addrs.inc	;RAM names

; External addresses outside $08DF5A-$0920DD, read from lst/nhl95.bin.
SeasonSchedule = $8DD8		;frames95
SeasonScheduleEnd = $9721	;sram95
WriteSRAM = $98E6		;sram95
MakeSRAMChecksum = $9908	;sram95
ReadSRAM = $9952		;sram95
Opening2 = $9ADA		;hockey95
setvram = $79936		;video95_01
dobitmap = $79A3C		;video95_01
DoDMA_clearCallbackPointer = $79AC0	;video95_01
forceblack = $7A02A		;display95_02
DecompressGraphicsWithCallback = $7A264	;video95_02
Framer = $7A270			;video95_02
VBlank_SetOptions = $7A418	;video95_02
orjoy = $7A448			;video95_02
orjoy4way = $7A456		;video95_02
ReadJoy1 = $7A4B0		;video95_02
ReadJoy2 = $7A4C8		;video95_02
ReadJoy3 = $7A4E0		;video95_02
ReadJoy4 = $7A50C		;video95_02
ProcessInputWithRepeat = $7A762	;video95_02
randomd0s = $7C62E		;video95_03
randomd0 = $7C63A		;video95_03
printz2 = $7C6D4		;video95_03
printsmall = $7C6E6		;video95_03
printz = $7C810			;video95_03
print = $7C822			;video95_03
eraser = $7C8CC			;video95_03
PrintListItem = $7CB2E		;video95_03
ReadAttributeNibbleD7 = $7CB60	;video95_03
PushNumberWidth = $7D154	;video95_03
appstring = $7D214		;video95_03
printbigz = $7D8D2		;video95_03
startpause1 = $7E7F8		;menu95
startpause2 = $7E7FE		;menu95
startpause3 = $7E806		;menu95
startpause4 = $7E80E		;menu95
GetPlayerCountD7 = $83904	;collide95_02
GameSetUp = $85A9E		;data95_01
ExitToOpening = $8CD02		;checks95_06
InitSeasonStats = $92BEC	;stats95_01
SaveSimGame = $92CAE		;stats95_01
SeasonPlayerStats = $9348A	;stats95_01
SeasonTeamStats = $93BD2	;stats95_01
LeagueLeadersScreen = $94110	;stats95_01
HighlightsScreen = $95D28	;stats95_01
SeasonAwards = $9C766		;awards95
InitPlayoffs = $9D4CE		;awards95
SetupPlayoffs = $9D662		;awards95
NextPlayoffRound = $9D748	;awards95
PlayoffRoundDone = $9D7C0	;awards95
ReadPlayoffSchedule = $9D8AE	;awards95
RecordPlayoffGame = $9D8D2	;awards95
PlayoffTreeScreen = $9D9CE	;title95_01
StanleyCupScreen = $A17B8	;title95_02
SmallFontMap = $139094		;graphics95_01
Teamblocksmap = $142906		;graphics95_01
Framermap = $14C148		;graphics95_01
BigFontMap2 = $15F46C		;graphics95_01
ControllerBgMap = $164AC8	;graphics95_01
GamesTodayLogoMap = $165A36	;graphics95_01
GamesTodayMap1 = $167524	;graphics95_01
GamesTodayMap2 = $16767E	;graphics95_01
GamesTodayMap3 = $16781E	;graphics95_01
CalendarBgMap = $167A44		;graphics95_01
CalOpponentMap = $168E72	;graphics95_01
CalDayMap = $1696DC		;graphics95_01
CalMonthMap = $169CE6		;graphics95_01
CalCheckMap = $16A814		;graphics95_01
CalResultMap = $16A8BC		;graphics95_01
WaitBoxMap = $16CC82		;graphics95_01

; Main segment code
	include	season95.asm
