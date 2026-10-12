;	Segment build for frames95.asm: sets its origin and the outside routines and data it uses,
;	then includes frames95.asm on its own for checking against the ROM.

; External addresses outside: none. Every word is a direction offset inside its own table
; a flag, or a frame / time pair; revframetbl is an incbin.
; region code
	org	$5A34

; includes for stubs to replace removed code
	include	stubinc\ports.inc	;IO_* / VDP_* ports
	include	stubinc\equals.inc	;VDP status bits
	include	ram95.asm		;RAM map

; Main segment code
	include	frames95.asm
