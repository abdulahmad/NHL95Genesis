;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
;
;	assign95_01 segment stub. Retail $0807EC-$080BE9.
;
;<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<

; region code
	org	$807EC

; includes for stubs to replace removed code
	include	stubinc\ports.inc	;IO_* / VDP_* ports
	include	stubinc\equals.inc	;VDP status bits
	include	ram95.asm		;RAM map

; External addresses outside $0807EC-$080BE9, read from lst/nhl95.bin.
chkpk = $7D884			;video95_03
assnothing = $81202		;checks95_02
assreplace = $8157A		;checks95_02
EvadePC = $8158E		;checks95_02
skateto = $8162C		;checks95_02
check4check = $816FA		;checks95_02
check4bench = $82790		;checks95_02
assdefdchase = $83220		;95 only: sets bit 7 of $64(a3), then plays the carrier when near the puck (checks95_03)

; Main segment code
	include	assign95_01.asm
