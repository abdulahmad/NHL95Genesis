	include	macros\genesis.mac	;String
;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
;
;	Segment stub.
;
;<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<

; region code
	org	$87BA2

; includes for stubs to replace removed code
	include	stubinc\ports.inc	;IO_* / VDP_* ports
	include	stubinc\equals.inc	;VDP status bits
	include	ram95.asm		;RAM map

; External addresses outside, read from lst/nhl95.bin.
ZeroLong = $69A
song = $678C2
setVram = $79936
Vmaddr = $79A22
dobitmap = $79A3C
DoDMA_clearCallbackPointer = $79AC0
cramfade = $79B54
rtss2 = $79CC8		;asstab entry 0, the shared rts
DoDMA = $79CE6
DecompressGraphicsWithCallback = $7A264
p_music_vblank = $7A3E6
ReadJoy1 = $7A4B0
ReadJoy2 = $7A4C8
ReadJoy3 = $7A4E0
ReadJoy4 = $7A50C
printsmallz = $7C6D4
printz = $7C810
print = $7C822
eraser = $7C8CC
AdvanceStringPtr = $7CB42
printbig = $7D916
rtsLineData = $87BA0
SmallFontMap = $139094
Teamblocksmap = $142906
BigFontMap2 = $15F46C
Arrowsmap = $1835D6
ScoutMap = $18394C
PlayoffSprite = $1842DA

; Main segment code
	include	engine\playoff95.asm
