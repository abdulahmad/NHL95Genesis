	include	macros\genesis.mac	;String (main95.asm includes it in the full build)
;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
;
;	fourway95 segment stub. Retail $07DEA0-$07E0DF.
;
;<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<

; region code
	org	$7DEA0

; includes for stubs to replace removed code
	include	stubinc\ports.inc	;IO_* / VDP_* ports
	include	stubinc\equals.inc	;VDP status bits
	include	stubinc\ram_addrs.inc	;RAM names

; External addresses outside $07DEA0-$07E0DF, read from lst/nhl95.bin.
dobitmap = $79A3C		;video95_01
DoDMA_clearCallbackPointer = $79AC0	;video95_01
ReadJoy = $7A52A		;video95_02
printz = $7C810			;video95_03
print = $7C822			;video95_03
PrintSmallListItem = $7CB38	;video95_03
PushTime = $7D0BC		;video95_03
EASNmap = $180B4E		;graphics95_01
ArenaGfxBank = $1A1A1A		;dc.l x+(TeamGfxList rows; graphics95_02)

; Main segment code
	include	fourway95.asm
