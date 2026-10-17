;	Segment build for fourway95.asm: sets its origin and the outside routines and data it uses,
;	then includes fourway95.asm on its own for checking against the ROM.

	include	macros\genesis.mac		;String
; region code
	org	$7DFAC

; includes for stubs to replace removed code
	include	stubinc\ports.inc		;IO_* / VDP_* ports
	include	stubinc\equals.inc		;VDP status bits
	include	ram95.asm				;RAM map

; External addresses outside, read from lst/nhl95.bin.
ReadJoy = $7A52A

; Main segment code
	include	engine\fourway95.asm
