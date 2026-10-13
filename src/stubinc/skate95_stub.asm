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
SPAgskate = $22BA
SPAgdive = $1D4E
SPAgglover = $1C86
SPAgglovel = $1CB8
SPAgstackr = $205E
SPAgstackl = $200C
SPAgstickr = $1CEA
SPAgstickl = $1D1C
SPAgready = $1B7A
SPAgready2 = $1C54
SPAglide = $B5C
SPAglidewp = $B8E
SPAglideback = $2564
SPAstop = $D08
SPAstopwp = $D5A
SPAturnl = $BC0
SPAturnr = $C12
SPAturnlwp = $C64
SPAturnrwp = $CB6
SPAskate = $2
SPAskate2 = $426
SPAskatewp = $738
SPAskateback = $19D2
SPAskateturn = $314
SPAboardtop = $20B0
SPAboardright = $2122
SPAboardbot = $219C
SPAboardleft = $220E
SPAboardmidl = $26C8
SPAboardmidr = $276A
sfx = $677AC
sroot = $7C512
vtoa = $7C586
getpde = $7CAD0
setpde = $7DBCA
AdjustFacingDirection = $80426
goaliesave = $80478

; Main segment code
	include	engine\skate95.asm
