;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
;
;	cards95_01 segment stub. Retail $09ACE6-$09B6F3.
;
;<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<

; region code
	org	$9ACE6

; includes for stubs to replace removed code
	include	stubinc\ports.inc	;IO_* / VDP_* ports
	include	stubinc\equals.inc	;VDP status bits
	include	ram95.asm		;RAM map

; External addresses outside $09ACE6-$09B6F3, read from lst/nhl95.bin.
TeamList = $772			;main95
WriteSRAM = $98E6		;sram95
MakeSRAMChecksum = $9908	;sram95
ReadSRAM = $9952		;sram95
dobitmap = $79A3C		;video95_01
DoDMA_clearCallbackPointer = $79AC0	;video95_01
ReadJoy1 = $7A4B0		;video95_02
ReadJoy2 = $7A4C8		;video95_02
ReadJoy3 = $7A4E0		;video95_02
ReadJoy4 = $7A50C		;video95_02
printz2 = $7C6D4		;video95_03
printsmall = $7C6E6		;video95_03
printz = $7C810			;video95_03
print = $7C822			;video95_03
eraser = $7C8CC			;video95_03
TeamLogoBitmaps = $7D3F8	;video95_03
printbigz = $7D8D2		;video95_03
NameEntryFramer = $986B6	;create95
CreateRatingsGfx = $98AFE	;create95
NameInUse = $9B7EA		;records95
WriteNameLog = $9B86C		;records95
ReadNameLog = $9B876		;records95
ClearNameHelp = $9B8B2		;records95
BigFontMap2 = $15F46C		;graphics95_01
NameEntryBgMap = $1834F4	;graphics95_01
TeamLogoPalettes = $1A169A	;graphics95_01

; Main segment code
	include	cards95_01.asm
