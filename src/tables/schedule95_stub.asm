;	Segment build for schedule95.asm: sets its origin and the outside routines and data it uses,
;	then includes schedule95.asm on its own for checking against the ROM.

	include	macros\genesis.mac	;Day
; External addresses outside: none. Every byte is a count or a team number.
; region code
	org	$8DD8

; includes for stubs to replace removed code
	include	stubinc\ports.inc	;IO_* / VDP_* ports
	include	stubinc\equals.inc	;VDP status bits
	include	ram95.asm		;RAM map

; Main segment code
	include	tables\schedule95.asm
