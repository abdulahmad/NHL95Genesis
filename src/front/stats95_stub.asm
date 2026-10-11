	include	macros\genesis.mac	;String (main95.asm includes it in the full build)
;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
;
;	stats95 segment stub. Retail $0920DE-$0962ED.
;
;<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<

; region code
	org	$920DE

; includes for stubs to replace removed code
	include	stubinc\ports.inc	;IO_* / VDP_* ports
	include	stubinc\equals.inc	;VDP status bits
	include	ram95.asm		;RAM map

; External addresses outside $0920DE-$0962ED, read from lst/nhl95.bin.
ZeroLong = $69A		;main95
TeamList = $772		;teamdata95
WriteSRAM = $98E6		;sram95
MakeSRAMChecksum = $9908		;sram95
ReadSRAM = $9952		;sram95
BuildLeaderList = $9972		;sram95
BuildLeaderListSum = $99AE		;sram95
BuildLeaderListPct = $9A04		;sram95
Opening2 = $9ADA		;hockey95
song = $678C2		;sound95
DoFill = $79902		;video95
setvram = $79936		;video95
Vmaddr = $79A22		;video95
dobitmap = $79A3C		;video95
SetScroll2 = $79CCA		;video95
forceblack = $7A02A		;video95
Framer = $7A270		;video95
orjoy4way = $7A456		;video95
nodiag = $7A488		;video95
ReadJoy1 = $7A4B0		;video95
ReadJoy2 = $7A4C8		;video95
ReadJoy3 = $7A4E0		;video95
ReadJoy4 = $7A50C		;video95
ReadMenuJoy = $7A6AA		;video95
ProcessInputWithRepeat = $7A762		;video95
WaitVSyncAndReadInput = $7A79C		;video95
vcountwait = $7C6BE		;middle95
printsmallz = $7C6D4		;middle95
printsmall = $7C6E6		;middle95
printz = $7C810		;middle95
print = $7C822		;middle95
eraser = $7C8CC		;middle95
PrintListItem = $7CB2E		;middle95
PrintSmallListItem = $7CB38		;middle95
ReadAttributeNibble = $7CB4E		;middle95
ReadAttributeNibbleD7 = $7CB60		;middle95
GetForwards = $7CC12		;middle95
getname = $7CC90		;middle95
FormatPlayerNameD7 = $7CD82		;middle95
FormatPlayerName = $7CDC2		;middle95
FormatPlayerNameShort = $7CE16		;middle95
FormatLastNameAlt = $7CE76		;middle95
PushTime = $7D0BC		;middle95
PushNumber = $7D120		;middle95
PushNumberWidth = $7D154		;middle95
PushNumberWidthZero = $7D1B0		;middle95
appendz = $7D20C		;middle95
appstring = $7D214		;middle95
PrintTeamData = $7D268		;middle95
TeamLogoBitmaps = $7D3F8		;middle95
GetPeriodTime = $7D4CA		;middle95
printbigz = $7D8D2		;middle95
printbig = $7D916		;middle95
seta2 = $7E4D6		;z80old95
GetPlayerCount = $838F2		;players95
GetPlayerCountD7 = $83904		;players95
ExitAttributeScreen2 = $8546E		;setup95
GetNameandAttrib = $8547A		;setup95
PAttribColumns = $8581E		;setup95
linelist = $8A02C		;penalty95
LoadTeamLines = $8A622		;lines95
DrawTeamScreen2 = $8ACEC		;lines95
DrawTeamScreen3 = $8AE80		;lines95
DrawTeamScreen4NoSetup = $8B014		;lines95
DrawTeamScreen4 = $8B01C		;lines95
DrawTeamScreen5 = $8B1AC		;lines95
DrawTeamScreen6 = $8B32A		;lines95
ReadSeasonHeader = $8E228		;season95
BuildSeasonTeamList = $8E2AC		;season95
SkipToGameDay = $8E3FC		;season95
DayHasGames = $8E416		;season95
PrevSeasonDay = $8E492		;season95
MakeDateString = $8F16A		;season95
ReadStandings = $8F332		;season95
GamesTodayGfx = $90360		;season95
StandingsGfx = $91936		;season95
GetHighlightSlot = $962EE		;trade95
HighlightsHelp = $96350		;trade95
GetRosterId = $96454		;trade95
GetRosterName = $9649E		;a1 = name String of player d0 of team d7 (season roster aware)
TickTeamInjuries = $9F192		;injury95
Teamblocksmap = $142906		;graphics95
ControllerBgMap = $164AC8		;graphics95
PlayerStatsBgMap = $16B50A		;graphics95
PlayerStatsTitleMap = $16C438		;graphics95
PeriodStatsMap = $16C776		;graphics95
HighlightsBgMap = $16C9FC		;graphics95
LineEditorBgMap = $16EAB4		;graphics95
PlayerSelectMap2 = $16F7D2		;graphics95
PlayerSelectMap1 = $16FA70		;graphics95
TeamLogoPalettes = $1A169A		;graphics95

; Main segment code
	include	front\stats95.asm
