	include	macros\genesis.mac	;String (main95.asm includes it in the full build)
;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
;
;	playoff95 segment stub. Retail $087BA2-$08827B.
;
;<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<

; region code
	org	$87BA2

; includes for stubs to replace removed code
	include	stubinc\ports.inc	;IO_* / VDP_* ports
	include	stubinc\equals.inc	;VDP status bits
	include	ram95.asm		;RAM map

; External addresses outside $087BA2-$08827B, read from lst/nhl95.bin.
ZeroLong = $69A		;main95
song = $678C2		;sound95
setvram = $79936		;video95
Vmaddr = $79A22		;video95
dobitmap = $79A3C		;video95
DoDMA_clearCallbackPointer = $79AC0		;video95
cramfade = $79B54		;video95
rtss2 = $79CC8		;asstab entry 0, the shared rts (video95)
DoDMA = $79CE6		;video95
DecompressGraphicsWithCallback = $7A264		;video95
p_music_vblank = $7A3E6		;video95
ReadJoy1 = $7A4B0		;video95
ReadJoy2 = $7A4C8		;video95
ReadJoy3 = $7A4E0		;video95
ReadJoy4 = $7A50C		;video95
printsmallz = $7C6D4		;middle95
printz = $7C810		;middle95
print = $7C822		;middle95
eraser = $7C8CC		;middle95
AdvanceStringPtr = $7CB42		;middle95
printbig = $7D916		;middle95
rtsLineData = $87BA0		;setup95
SmallFontMap = $139094		;graphics95
Teamblocksmap = $142906		;graphics95
BigFontMap2 = $15F46C		;graphics95
Arrowsmap = $1835D6		;graphics95
ScoutMap = $18394C		;graphics95
PlayoffSprite = $1842DA		;graphics95

; Main segment code
	include	engine\playoff95.asm
