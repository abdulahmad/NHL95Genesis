;	Segment build for crowd95.asm: sets its origin and the outside routines and data it uses,
;	then includes crowd95.asm on its own for checking against the ROM.

	include	macros\genesis.mac		;String
; region code
	org	$A0B3E

; includes for stubs to replace removed code
	include	stubinc\ports.inc		;IO_* / VDP_* ports
	include	stubinc\equals.inc		;VDP status bits
	include	ram95.asm				;RAM map

; External addresses outside, read from lst/nhl95.bin.
CrowdFrameList = $18B628

; Main segment code
	include	front\crowd95.asm
