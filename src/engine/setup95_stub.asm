	include	macros\genesis.mac	;String
;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
;
;	Segment stub.
;
;<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<

; region code
	org	$84FE6

; includes for stubs to replace removed code
	include	stubinc\ports.inc	;IO_* / VDP_* ports
	include	stubinc\equals.inc	;VDP status bits
	include	ram95.asm		;RAM map

; External addresses outside, read from lst/nhl95.bin.
ZeroLong = $69A
TeamList = $772
playoffseats = $5834
WriteSRAM = $98E6
MakeSRAMChecksum = $9908
ReadSRAM = $9952
setVram = $79936
Vmaddr = $79A22
dobitmap = $79A3C
DoDMA_clearCallbackPointer = $79AC0
SetScroll2 = $79CCA
forceblack = $7A02A
DecompressGraphicsWithCallback = $7A264
VBlank_SetOptions = $7A418
orjoy = $7A448
nodiag = $7A488
ReadJoy1 = $7A4B0
ReadJoy2 = $7A4C8
ReadJoy3 = $7A4E0
ReadJoy4 = $7A50C
ReadMenuJoy = $7A6AA
ProcessInputWithRepeat = $7A762
randomd0 = $7C63A
vcountwait = $7C6BE
printsmallz = $7C6D4
printsmall = $7C6E6
printz = $7C810
print = $7C822
eraser = $7C8CC
PrintSmallListItem = $7CB38
AdvanceStringPtr = $7CB42
ReadAttributeNibble = $7CB4E
GetDefenseStart = $7CBC8
getname = $7CC90
ConverByteToDigits = $7CEF6
CalcAttrib = $7CF16
PushTime = $7D0BC
PushNumber = $7D120
PushNumberWidth = $7D154
appstring = $7D214
AttribAdjust = $7D258
PrintTeamData = $7D268
setupTeamBlocksMap = $7D2AE
GetTeamLogo = $7D3EA
TeamLogoBitmaps = $7D3F8
DrawTeamLogo = $7D468
UnpackPicture = $7DA78
SeasonPlayerOut = $7DBD8
DrawMenuScreen = $7E536
GetPlayerCount = $838F2
RandomSetupTeams = $8DFF8
ReadSeasonHeader = $8E228
BuildSeasonTeamList = $8E2AC
NextSeasonTeam = $8E556
PrevSeasonTeam = $8E5A2
GetRosterName = $9649E
ReadCreatedPlayers = $988E4
CheckCreateSlots = $98C64
ClearShootout = $9DA50
GetInjuryGames = $9F232
GetPlayerPicture = $A0A30
PicturePalette = $A1A5A
RosterFont = $1383C6
RosterBitmap = $14000A
Teamblocksmap = $142906
SetupFont = $151760
SetupBgMap2 = $1524CE
SetupBgMap1 = $1588FC
TeamBitmaps = $15974A
TeamLogoPalettes = $1A169A

; Main segment code
	include	engine\setup95.asm
