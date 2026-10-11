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
TeamList = $772		;teamdata95
WriteSRAM = $98E6		;sram95
MakeSRAMChecksum = $9908		;sram95
ReadSRAM = $9952		;sram95
Vmaddr = $79A22		;video95
dobitmap = $79A3C		;video95
DoDMA_clearCallbackPointer = $79AC0		;video95
SetScroll2 = $79CCA		;video95
forceblack = $7A02A		;video95
DecompressGraphicsWithCallback = $7A264		;video95
ReadJoy1 = $7A4B0		;video95
ReadJoy2 = $7A4C8		;video95
ReadJoy3 = $7A4E0		;video95
ReadJoy4 = $7A50C		;video95
ReadMenuJoy = $7A6AA		;video95
ProcessInputWithRepeat = $7A762		;video95
vcountwait = $7C6BE		;middle95
printsmallz = $7C6D4		;middle95
printsmall = $7C6E6		;middle95
printz = $7C810		;middle95
print = $7C822		;middle95
eraser = $7C8CC		;middle95
ReadAttributeNibble = $7CB4E		;middle95
PushNumberWidth = $7D154		;middle95
appstring = $7D214		;middle95
TeamLogoBitmaps = $7D3F8		;middle95
printbigz = $7D8D2		;middle95
AppendTeamName = $7DC36		;middle95
StartText = $7DC62		;middle95
AppendUserName = $7DC76		;middle95
GetPlayerCount = $838F2		;players95
ExitAttributeScreen2 = $8546E		;setup95
ReadTeamStats = $877AC		;setup95
DisplayAttributeScreen = $925B2		;stats95
NameEntryFramer = $986B6		;create95
CreateRatingsGfx = $98AFE		;create95
GetTeamUser = $9C6F0		;awards95
SmallFontMap = $139094		;graphics95
BigFontMap2 = $15F46C		;graphics95
ControllerBgMap = $164AC8		;graphics95
NameEntryBgMap = $1834F4		;graphics95
TeamLogoPalettes = $1A169A		;graphics95

; Main segment code
	include	front\records95.asm
