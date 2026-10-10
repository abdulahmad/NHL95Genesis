	include	macros\genesis.mac	;String (main95.asm includes it in the full build)
;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
;
;	setup95_02 segment stub. Retail $087BA2-$088045.
;
;<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<

; region code
	org	$87BA2

; includes for stubs to replace removed code
	include	stubinc\ports.inc	;IO_* / VDP_* ports
	include	stubinc\equals.inc	;VDP status bits
	include	ram95.asm		;RAM map

; External addresses outside $087BA2-$088045, read from lst/nhl95.bin.
ZeroLong = $69A			;main95
song = $678C2			;sound95_01
setvram = $79936		;video95_01
Vmaddr = $79A22			;video95_01
dobitmap = $79A3C		;video95_01
DoDMA_clearCallbackPointer = $79AC0	;video95_01
cramfade = $79B54		;video95_01
rtss2 = $79CC8			;video95_01
DoDMA = $79CE6			;video95_01
DecompressGraphicsWithCallback = $7A264	;video95_02
p_music_vblank = $7A3E6		;video95_02
ReadJoy1 = $7A4B0		;video95_02
ReadJoy2 = $7A4C8		;video95_02
ReadJoy3 = $7A4E0		;video95_02
ReadJoy4 = $7A50C		;video95_02
printz2 = $7C6D4		;video95_03
printz = $7C810			;video95_03
print = $7C822			;video95_03
eraser = $7C8CC			;video95_03
SkipStrings = $7CB42		;video95_03
printbig = $7D916		;video95_03
rtsLineData = $87BA0		;data95_01
PlayoffTreeSetup = $88046	;checks95_04
DrawPlayoffSprite = $881B0	;checks95_04
SmallFontMap = $139094		;graphics95_01
Teamblocksmap = $142906		;graphics95_01
BigFontMap2 = $15F46C		;graphics95_01
Arrowsmap = $1835D6		;graphics95_01
ScoutMap = $18394C		;graphics95_01
PlayoffSprite = $1842DA		;graphics95_01

; Main segment code
	include	setup95_02.asm
