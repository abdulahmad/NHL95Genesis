	include	macros\genesis.mac	;String (main95.asm includes it in the full build)
;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
;
;	optsetup95 segment stub. Retail $084FE6-$087BA1.
;
;<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<

; region code
	org	$84FE6

; includes for stubs to replace removed code
	include	stubinc\ports.inc	;IO_* / VDP_* ports
	include	stubinc\equals.inc	;VDP status bits
	include	ram95.asm		;RAM map

; External addresses outside $084FE6-$087BA1, read from lst/nhl95.bin.
ZeroLong = $69A			;main95
TeamList = $772			;teamdata95
playoffseats = $5834		;teamdata95
WriteSRAM = $98E6		;sram95
MakeSRAMChecksum = $9908	;sram95
ReadSRAM = $9952		;sram95
setvram = $79936		;video95_01
Vmaddr = $79A22			;video95_01
dobitmap = $79A3C		;video95_01
DoDMA_clearCallbackPointer = $79AC0	;video95_01
SetScroll2 = $79CCA		;video95_01
forceblack = $7A02A		;video95_01
DecompressGraphicsWithCallback = $7A264	;video95_01
VBlank_SetOptions = $7A418	;video95_01
orjoy = $7A448			;video95_01
nodiag = $7A488			;video95_01
ReadJoy1 = $7A4B0		;video95_01
ReadJoy2 = $7A4C8		;video95_01
ReadJoy3 = $7A4E0		;video95_01
ReadJoy4 = $7A50C		;video95_01
ReadMenuJoy = $7A6AA		;video95_01
ProcessInputWithRepeat = $7A762	;video95_01
randomd0 = $7C63A		;video95_02
vcountwait = $7C6BE		;video95_02
printz2 = $7C6D4		;video95_02
printsmall = $7C6E6		;video95_02
printz = $7C810			;video95_02
print = $7C822			;video95_02
eraser = $7C8CC			;video95_02
PrintSmallListItem = $7CB38	;video95_02
SkipStrings = $7CB42		;video95_02
ReadAttributeNibble = $7CB4E	;video95_02
GetDefenseStart = $7CBC8	;video95_02
getname = $7CC90		;video95_02
d0toascii = $7CEF6		;video95_02
CalcAttrib = $7CF16		;video95_02
PushTime = $7D0BC		;video95_02
PushNumber = $7D120		;video95_02
PushNumberWidth = $7D154	;video95_02
appstring = $7D214		;video95_02
ScaleAttrib = $7D258		;video95_02
PutTeamBlock = $7D268		;video95_02
setupTeamBlocksMap = $7D2AE	;video95_02
GetTeamLogo = $7D3EA		;video95_02
TeamLogoBitmaps = $7D3F8	;video95_02
DrawTeamLogo = $7D468		;video95_02
UnpackPicture = $7DA78		;video95_02
SeasonPlayerOut = $7DBD8	;video95_02
DrawMenuScreen = $7E536		;menu95
GetPlayerCount = $838F2		;collide95_02
RandomSetupTeams = $8DFF8	;season95
ReadSeasonHeader = $8E228	;season95
BuildSeasonTeamList = $8E2AC	;season95
NextSeasonTeam = $8E556		;season95
PrevSeasonTeam = $8E5A2		;season95
GetRosterName = $9649E		;trade95
ReadCreatedPlayers = $988E4	;create95
CheckCreateSlots = $98C64	;create95
ClearShootout = $9DA50		;shootout95
GetInjuryGames = $9F232		;checks95_05
GetPlayerPicture = $A0A30	;setup95_03
PicturePalette = $A1A5A	;title95_01
RosterFont = $1383C6		;graphics95_01
RosterBitmap = $14000A		;graphics95_01
Teamblocksmap = $142906	;graphics95_01
SetupFont = $151760		;graphics95_01
SetupBgMap2 = $1524CE		;graphics95_01
SetupBgMap1 = $1588FC		;graphics95_01
TeamBitmaps = $15974A		;graphics95_01
TeamLogoPalettes = $1A169A	;graphics95_01

; Main segment code
	include	optsetup95.asm
