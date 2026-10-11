	include	macros\genesis.mac	;String (main95.asm includes it in the full build)
;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
;
;	records95 segment stub. Retail $09ACE6-$09C6EF.
;
;<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<

; region code
	org	$9ACE6

; includes for stubs to replace removed code
	include	stubinc\ports.inc	;IO_* / VDP_* ports
	include	stubinc\equals.inc	;VDP status bits
	include	ram95.asm		;RAM map

; External addresses outside $09ACE6-$09C6EF, read from lst/nhl95.bin.
TeamList = $772
WriteSRAM = $98E6
MakeSRAMChecksum = $9908
ReadSRAM = $9952
Vmaddr = $79A22
dobitmap = $79A3C
DoDMA_clearCallbackPointer = $79AC0
SetScroll2 = $79CCA
forceblack = $7A02A
DecompressGraphicsWithCallback = $7A264
ReadJoy1 = $7A4B0
ReadJoy2 = $7A4C8
ReadJoy3 = $7A4E0
ReadJoy4 = $7A50C
ReadMenuJoy = $7A6AA
ProcessInputWithRepeat = $7A762
vcountwait = $7C6BE
printsmallz = $7C6D4
printsmall = $7C6E6
printz = $7C810
print = $7C822
eraser = $7C8CC
ReadAttributeNibble = $7CB4E
PushNumberWidth = $7D154
appstring = $7D214
TeamLogoBitmaps = $7D3F8
printbigz = $7D8D2
AppendTeamName = $7DC36
StartText = $7DC62
AppendUserName = $7DC76
GetPlayerCount = $838F2
ExitAttributeScreen2 = $8546E
ReadTeamStats = $877AC
DisplayAttributeScreen = $925B2
NameEntryFramer = $986B6
CreateRatingsGfx = $98AFE
GetTeamUser = $9C6F0
SmallFontMap = $139094
BigFontMap2 = $15F46C
ControllerBgMap = $164AC8
NameEntryBgMap = $1834F4
TeamLogoPalettes = $1A169A

; Main segment code
	include	front\records95.asm
