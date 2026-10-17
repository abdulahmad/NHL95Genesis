;	Segment build for graphics95.asm: sets its origin and the outside routines and data it uses,
;	then includes graphics95.asm on its own for checking against the ROM.

; region code
	org	$A1A5A

; includes for stubs to replace removed code
	include	stubinc\ports.inc		;IO_* / VDP_* ports
	include	stubinc\equals.inc		;VDP status bits
	include	ram95.asm				;RAM map

; External addresses outside, read from lst/nhl95.bin.


; Main segment code
	include	graphics95.asm
