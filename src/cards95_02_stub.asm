;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
;
;	cards95_02 segment stub. Retail $09C01A-$09C6EF.
;
;<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<

; region code
	org	$9C01A

; includes for stubs to replace removed code
	include	stubinc\ports.inc	;IO_* / VDP_* ports
	include	stubinc\equals.inc	;VDP status bits
	include	stubinc\ram_addrs.inc	;RAM names

; External addresses outside $09C01A-$09C6EF, read from lst/nhl95.bin.
WriteSRAM = $98E6		;sram95
MakeSRAMChecksum = $9908	;sram95
ReadSRAM = $9952		;sram95
Vmaddr = $79A22			;video95_01
dobitmap = $79A3C		;video95_01
DoDMA_clearCallbackPointer = $79AC0	;video95_01
SetScroll2 = $79CCA		;video95_01
forceblack = $7A02A		;display95_02
DecompressGraphicsWithCallback = $7A264	;video95_02
printz = $7C810			;video95_03
eraser = $7C8CC			;video95_03
ReadAttributeNibble = $7CB4E	;video95_03
GetPlayerCount = $838F2		;collide95_02
GetTeamUser = $9C6F0		;awards95
SmallFontMap = $139094		;graphics95_01
BigFontMap2 = $15F46C		;graphics95_01
ControllerBgMap = $164AC8	;graphics95_01

; Main segment code
	include	cards95_02.asm
