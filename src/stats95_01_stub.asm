;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
;
;	stats95_01 segment stub. Retail $0925AE-$0962ED.
;
;<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<

; region code
	org	$925AE

; includes for stubs to replace removed code
	include	stubinc\ports.inc	;IO_* / VDP_* ports
	include	stubinc\equals.inc	;VDP status bits
	include	ram95.asm		;RAM map

; External addresses outside $0925AE-$0962ED, read from lst/nhl95.bin.
TeamList = $772			;main95
WriteSRAM = $98E6		;sram95
MakeSRAMChecksum = $9908	;sram95
ReadSRAM = $9952		;sram95
BuildLeaderList = $9972		;sram95
BuildLeaderListSum = $99AE	;sram95
BuildLeaderListPct = $9A04	;sram95
Opening2 = $9ADA		;hockey95
song = $678C2			;sound95_01
DoFill = $79902			;sound95_01
setvram = $79936		;video95_01
Vmaddr = $79A22			;video95_01
dobitmap = $79A3C		;video95_01
SetScroll2 = $79CCA		;video95_01
forceblack = $7A02A		;display95_02
Framer = $7A270			;video95_02
orjoy4way = $7A456		;video95_02
nodiag = $7A488			;video95_02
ReadJoy1 = $7A4B0		;video95_02
ReadJoy2 = $7A4C8		;video95_02
ReadJoy3 = $7A4E0		;video95_02
ReadJoy4 = $7A50C		;video95_02
ReadMenuJoy = $7A6AA		;video95_02
ProcessInputWithRepeat = $7A762	;video95_02
WaitVSyncAndReadInput = $7A79C	;collide95_01
vcountwait = $7C6BE		;video95_03
printz2 = $7C6D4		;video95_03
printsmall = $7C6E6		;video95_03
printz = $7C810			;video95_03
print = $7C822			;video95_03
eraser = $7C8CC			;video95_03
PrintListItem = $7CB2E		;video95_03
PrintSmallListItem = $7CB38	;video95_03
ReadAttributeNibble = $7CB4E	;video95_03
ReadAttributeNibbleD7 = $7CB60	;video95_03
GetForwards = $7CC12		;video95_03
getname = $7CC90		;video95_03
FormatPlayerNameD7 = $7CD82	;video95_03
FormatPlayerName = $7CDC2	;video95_03
FormatPlayerNameShort = $7CE16	;video95_03
FormatLastNameAlt = $7CE76	;video95_03
PushNumberWidth = $7D154	;video95_03
PushNumberWidthZero = $7D1B0	;video95_03
appendz = $7D20C		;video95_03
appstring = $7D214		;video95_03
PutTeamBlock = $7D268		;video95_03
TeamLogoBitmaps = $7D3F8	;video95_03
GetPeriodTime = $7D4CA		;video95_03
printbigz = $7D8D2		;video95_03
printbig = $7D916		;video95_03
seta2 = $7E4D6			;sound95_02
GetPlayerCount = $838F2		;collide95_02
GetPlayerCountD7 = $83904	;collide95_02
ExitAttributeScreen2 = $8546E	;data95_01
getNameandAttrib = $8547A	;data95_01
PAttribColumns = $8581E		;data95_01
linelist = $8A02C		;data95_02
LoadTeamLines = $8A622		;checks95_05
DrawTeamScreen2 = $8ACEC	;checks95_05
DrawTeamScreen3 = $8AE80	;checks95_05
DrawTeamScreen4NoSetup = $8B014	;checks95_05
DrawTeamScreen4 = $8B01C	;checks95_05
DrawTeamScreen5 = $8B1AC	;checks95_05
DrawTeamScreen6 = $8B32A	;checks95_05
Goal = $8C304			;checks95_06
ReadSeasonHeader = $8E228	;season95
BuildSeasonTeamList = $8E2AC	;season95
SkipToGameDay = $8E3FC		;season95
DayHasGames = $8E416		;season95
PrevSeasonDay = $8E492		;season95
MakeDateString = $8F16A		;season95
ReadStandings = $8F332		;season95
GamesTodayGfx = $90360		;season95
StandingsGfx = $91936		;season95
GetHighlightSlot = $962EE	;trade95
HighlightsHelp = $96350	;trade95
GetRosterId = $96454		;trade95
GetRosterName = $9649E		;trade95
TickTeamInjuries = $9F192	;checks95_07
Teamblocksmap = $142906		;graphics95_01
ControllerBgMap = $164AC8	;graphics95_01
PlayerStatsBgMap = $16B50A	;graphics95_01
PlayerStatsTitleMap = $16C438	;graphics95_01
PeriodStatsMap = $16C776	;graphics95_01
HighlightsBgMap = $16C9FC	;graphics95_01
LineEditorBgMap = $16EAB4	;graphics95_01
PlayerSelectMap2 = $16F7D2	;graphics95_01
PlayerSelectMap1 = $16FA70	;graphics95_01
TeamLogoPalettes = $1A169A	;graphics95_01

; Main segment code
	include	stats95_01.asm
