	include	macros\genesis.mac	;String (main95.asm includes it in the full build)

;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
;
;	sram95 segment stub. Retail $009722-$009AC7.
;
;<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<

; region code
	org	$9722

; includes for stubs to replace removed code
	include	stubinc\ports.inc	;IO_* / VDP_* ports
	include	stubinc\equals.inc	;VDP status bits
	include	stubinc\ram_addrs.inc	;RAM names

; External addresses outside $009722-$009AC7, read from lst/nhl95.bin: jsr (x).l carries the address.
ReadJoy1 = $7A4B0		;video95_02
vcountwait = $7C6BE		;video95_03
DefaultRosters = $96390		;trade95
DefaultLineData = $8A5D8	;checks95_05
ClearCreatedPlayers = $98C88	;create95
NullSaveClear = $A0A2E		;setup95_03

; Main segment code
	include	sram95.asm
