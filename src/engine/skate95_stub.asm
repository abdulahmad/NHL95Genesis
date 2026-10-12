;	Segment build for skate95.asm: sets its origin and the outside routines and data it uses,
;	then includes skate95.asm on its own for checking against the ROM.

	include	macros\genesis.mac	;String
; region code
	org	$8B4E0

; includes for stubs to replace removed code
	include	stubinc\ports.inc	;IO_* / VDP_* ports
	include	stubinc\equals.inc	;VDP status bits
	include	ram95.asm		;RAM map

; External addresses outside, read from lst/nhl95.bin.
SPAlist = $5A34
sfx = $677AC
sroot = $7C512
vtoa = $7C586
getpde = $7CAD0
setpde = $7DBCA
AdjustFacingDirection = $80426
goaliesave = $80478

; Main segment code
	include	engine\skate95.asm
