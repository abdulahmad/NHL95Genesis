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
TeamList = $772
WriteSRAM = $98E6
MakeSRAMChecksum = $9908
ReadSRAM = $9952
BuildLeaderList = $9972
BuildLeaderListSum = $99AE
BuildLeaderListPct = $9A04
Opening2 = $9ADA
song = $678C2
DoFill = $79902
setvram = $79936
Vmaddr = $79A22
dobitmap = $79A3C
SetScroll2 = $79CCA
forceblack = $7A02A
Framer = $7A270
orjoy4way = $7A456
nodiag = $7A488
ReadJoy1 = $7A4B0
ReadJoy2 = $7A4C8
ReadJoy3 = $7A4E0
ReadJoy4 = $7A50C
ReadMenuJoy = $7A6AA
ProcessInputWithRepeat = $7A762
WaitVSyncAndReadInput = $7A79C
vcountwait = $7C6BE
printsmallz = $7C6D4
printsmall = $7C6E6
printz = $7C810
print = $7C822
eraser = $7C8CC
PrintListItem = $7CB2E
PrintSmallListItem = $7CB38
ReadAttributeNibble = $7CB4E
ReadAttributeNibbleD7 = $7CB60
GetForwards = $7CC12
getname = $7CC90
FormatPlayerNameD7 = $7CD82
FormatPlayerName = $7CDC2
FormatPlayerNameShort = $7CE16
FormatLastNameAlt = $7CE76
PushTime = $7D0BC
PushNumber = $7D120
PushNumberWidth = $7D154
PushNumberWidthZero = $7D1B0
appendz = $7D20C
appstring = $7D214
PrintTeamData = $7D268
TeamLogoBitmaps = $7D3F8
GetPeriodTime = $7D4CA
printbigz = $7D8D2
printbig = $7D916
seta2 = $7E4D6		;z80old95
GetPlayerCount = $838F2
GetPlayerCountD7 = $83904
ExitAttributeScreen2 = $8546E
GetNameandAttrib = $8547A
PAttribColumns = $8581E
linelist = $8A02C
LoadTeamLines = $8A622
DrawTeamScreen2 = $8ACEC
DrawTeamScreen3 = $8AE80
DrawTeamScreen4NoSetup = $8B014
DrawTeamScreen4 = $8B01C
DrawTeamScreen5 = $8B1AC
DrawTeamScreen6 = $8B32A
ReadSeasonHeader = $8E228
BuildSeasonTeamList = $8E2AC
SkipToGameDay = $8E3FC
DayHasGames = $8E416
PrevSeasonDay = $8E492
MakeDateString = $8F16A
ReadStandings = $8F332
GamesTodayGfx = $90360
StandingsGfx = $91936
GetHighlightSlot = $962EE
HighlightsHelp = $96350
GetRosterId = $96454
GetRosterName = $9649E		;a1 = name String of player d0 of team d7 (season roster aware)
TickTeamInjuries = $9F192
Teamblocksmap = $142906
ControllerBgMap = $164AC8
PlayerStatsBgMap = $16B50A
PlayerStatsTitleMap = $16C438
PeriodStatsMap = $16C776
HighlightsBgMap = $16C9FC
LineEditorBgMap = $16EAB4
PlayerSelectMap2 = $16F7D2
PlayerSelectMap1 = $16FA70
TeamLogoPalettes = $1A169A

; Main segment code
	include	front\stats95.asm
