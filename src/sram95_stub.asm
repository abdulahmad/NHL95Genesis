	include	macros\genesis.mac	;String

;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
;
;	Segment stub.
;
;<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<

; region code
	org	$9722

; includes for stubs to replace removed code
	include	stubinc\ports.inc	;IO_* / VDP_* ports
	include	stubinc\equals.inc	;VDP status bits
	include	ram95.asm		;RAM map

; External addresses outside, read from lst/nhl95.bin: jsr (x).l carries the address.
ReadJoy1 = $7A4B0
vcountwait = $7C6BE
DefaultRosters = $96390
DefaultLineData = $8A5D8
ClearCreatedPlayers = $98C88
NullSaveClear = $A0A2E

; Main segment code
	include	sram95.asm
