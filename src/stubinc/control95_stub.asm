;	Segment build for control95.asm: sets its origin and the outside routines and data it uses,
;	then includes control95.asm on its own for checking against the ROM.

	include	macros\genesis.mac	;String
; region code
	org	$A95C

; includes for stubs to replace removed code
	include	stubinc\ports.inc	;IO_* / VDP_* ports
	include	stubinc\equals.inc	;VDP status bits
	include	ram95.asm		;RAM map

; External addresses outside, read from lst/nhl95.bin.
SPAskateburst = $2
SPAskatewp = $738
TeamList = $772
SPAHold = $E10
SPAhook = $E74
SPAburst2 = $11AE
ReadJoy1 = $7A4B0
ReadJoy2 = $7A4C8
ReadJoy3 = $7A4E0
ReadJoy4 = $7A50C
checkcoll = $7A7B4
Sweepcheck = $7B08A
getpde = $7CAD0
setpde = $7DBCA
doassignment = $7FD84		;run a3's assignment.
doinput = $83EB2
LoadTeamLines = $8A622
dirtab = $8B9D6
SetSPA = $8BC9A
chkblock = $8D39A		;may change d1 to SPAblock.

; Main segment code
	include	control95.asm
