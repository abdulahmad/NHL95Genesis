	include	macros\genesis.mac	;String, SndItem (main95.asm includes it in the full build)
;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
;
;	sound95 segment stub. Retail $00AF44-$079901.
;
;<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<

; region code
	org	$AF44

; includes for stubs to replace removed code
	include	stubinc\ports.inc	;IO_* / VDP_* ports
	include	stubinc\equals.inc	;VDP status bits
	include	ram95.asm		;RAM map

; External addresses outside $00AF44-$079901:
randomd0 = $7C63A
Z80_Program_Code = $7E0E0	;The 94 Z80 program, still loaded by p_initialZ80 (z80old95)

; Main segment code
	include	sound\sound95.asm
