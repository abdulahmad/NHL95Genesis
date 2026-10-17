;	Segment build for injury95.asm: sets its origin and the outside routines and data it uses,
;	then includes injury95.asm on its own for checking against the ROM.

	include	macros\genesis.mac		;String
; region code
	org	$9F012

; includes for stubs to replace removed code
	include	stubinc\ports.inc		;IO_* / VDP_* ports
	include	stubinc\equals.inc		;VDP status bits
	include	ram95.asm				;RAM map

; External addresses outside, read from lst/nhl95.bin.
MakeSRAMChecksum = $9908
sfx = $677AC
Framer = $7A270
randomd0 = $7C63A
printz = $7C810
print = $7C822
GetPlayerNumInitial = $7CCD2
PushTime = $7D0BC
PushNumberWidth = $7D154
appendz = $7D20C
appstring = $7D214
EASNLogo = $7DF32

; Main segment code
	include	front\injury95.asm
