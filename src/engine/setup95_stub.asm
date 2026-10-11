	include	macros\genesis.mac	;String (main95.asm includes it in the full build)
;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
;
;	setup95 segment stub. Retail $084FE6-$087BA1.
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
setvram = $79936		;video95
Vmaddr = $79A22			;video95
dobitmap = $79A3C		;video95
DoDMA_clearCallbackPointer = $79AC0	;video95
SetScroll2 = $79CCA		;video95
forceblack = $7A02A		;video95
DecompressGraphicsWithCallback = $7A264	;video95
VBlank_SetOptions = $7A418	;video95
orjoy = $7A448			;video95
nodiag = $7A488			;video95
ReadJoy1 = $7A4B0		;video95
ReadJoy2 = $7A4C8		;video95
ReadJoy3 = $7A4E0		;video95
ReadJoy4 = $7A50C		;video95
ReadMenuJoy = $7A6AA		;video95
ProcessInputWithRepeat = $7A762	;video95
randomd0 = $7C63A		;middle95
vcountwait = $7C6BE		;middle95
printsmallz = $7C6D4		;middle95
printsmall = $7C6E6		;middle95
printz = $7C810			;middle95
print = $7C822			;middle95
eraser = $7C8CC			;middle95
PrintSmallListItem = $7CB38	;middle95
AdvanceStringPtr = $7CB42		;middle95
ReadAttributeNibble = $7CB4E	;middle95
GetDefenseStart = $7CBC8	;middle95
getname = $7CC90		;middle95
ConverByteToDigits = $7CEF6		;middle95
CalcAttrib = $7CF16		;middle95
PushTime = $7D0BC		;middle95
PushNumber = $7D120		;middle95
PushNumberWidth = $7D154	;middle95
appstring = $7D214		;middle95
AttribAdjust = $7D258		;middle95
PrintTeamData = $7D268		;middle95
setupTeamBlocksMap = $7D2AE	;middle95
GetTeamLogo = $7D3EA		;middle95
TeamLogoBitmaps = $7D3F8	;middle95
DrawTeamLogo = $7D468		;middle95
UnpackPicture = $7DA78		;middle95
SeasonPlayerOut = $7DBD8	;middle95
DrawMenuScreen = $7E536		;pause95
GetPlayerCount = $838F2		;players95
RandomSetupTeams = $8DFF8	;season95
ReadSeasonHeader = $8E228	;season95
BuildSeasonTeamList = $8E2AC	;season95
NextSeasonTeam = $8E556		;season95
PrevSeasonTeam = $8E5A2		;season95
GetRosterName = $9649E		;trade95
ReadCreatedPlayers = $988E4	;create95
CheckCreateSlots = $98C64	;create95
ClearShootout = $9DA50		;shootout95
GetInjuryGames = $9F232		;injury95
GetPlayerPicture = $A0A30	;scout95
PicturePalette = $A1A5A	;title95
RosterFont = $1383C6		;graphics95
RosterBitmap = $14000A		;graphics95
Teamblocksmap = $142906	;graphics95
SetupFont = $151760		;graphics95
SetupBgMap2 = $1524CE		;graphics95
SetupBgMap1 = $1588FC		;graphics95
TeamBitmaps = $15974A		;graphics95
TeamLogoPalettes = $1A169A	;graphics95

; Main segment code
	include	engine\setup95.asm
