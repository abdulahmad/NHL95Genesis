;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
;
;	sound95_02 segment stub. Retail $07E0E0-$07E36B.
;
;<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<

; region code
	org	$7E0E0

; includes for stubs to replace removed code
	include	stubinc\ports.inc	;IO_* / VDP_* ports
	include	stubinc\equals.inc	;VDP status bits
	include	ram95.asm		;RAM map

; External addresses outside $07E0E0-$07E36B, read from lst/nhl95.bin.
fm_instrument_patches = $79502	;the Z80 ld bc / ld a bytes (sound95_01)

; Main segment code
	include	data\sound95_02.asm
