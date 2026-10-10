;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
;
;	replay95_01 segment stub. Retail $00A536-$00A655.
;
;<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<

; region code
	org	$A536

; includes for stubs to replace removed code
	include	stubinc\ports.inc	;IO_* / VDP_* ports
	include	stubinc\equals.inc	;VDP status bits
	include	ram95.asm		;RAM map

; External addresses outside $00A536-$00A655 (frames95.asm defines them in the full build).
SPAlist = $5A34
SPAfallback = $109C
SPAinjuryfall = $2454

; Main segment code
	include	replay95_01.asm
