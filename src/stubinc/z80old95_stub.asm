;	Segment build for the old Z80 program at $07E0E0: includes sound95.asm with Z80OLD_SEG set
;	(only the Z80OldProgram macro) and expands the macro on its own for checking against the ROM.

;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
;
;	z80old95 segment stub.
;
;<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<

; region code
	org	$7E0E0

; includes for stubs to replace removed code
	include	stubinc\ports.inc	;IO_* / VDP_* ports
	include	stubinc\equals.inc	;VDP status bits
	include	ram95.asm		;RAM map

; External addresses outside, read from lst/nhl95.bin.
fm_instrument_patches = $79502	;the Z80 ld bc / ld a bytes

; Main segment code
Z80OLD_SEG	equ	1		;sound95.asm: macro only
	include	sound95.asm
	Z80OldProgram
