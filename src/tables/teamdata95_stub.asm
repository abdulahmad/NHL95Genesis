;	Segment build for teamdata95.asm: sets its origin and the outside routines and data it uses,
;	then includes teamdata95.asm on its own for checking against the ROM.

	include	macros\genesis.mac	;String, Player

; External addresses outside: none. TeamList and the team block offsets point inside the segment.
; region code
	org	$772

; includes for stubs to replace removed code
	include	stubinc\ports.inc	;IO_* / VDP_* ports
	include	stubinc\equals.inc	;VDP status bits
	include	ram95.asm		;RAM map

; Main segment code
	include	tables\teamdata95.asm
