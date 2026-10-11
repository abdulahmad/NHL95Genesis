	include	macros\genesis.mac	;String (main95.asm includes it in the full build)
;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
;
;	display95 segment stub. Retail $00A204-$00A95B.
;
;<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<

; region code
	org	$A204

; includes for stubs to replace removed code
	include	stubinc\ports.inc	;IO_* / VDP_* ports
	include	stubinc\equals.inc	;VDP status bits
	include	ram95.asm		;RAM map

; External addresses outside $00A204-$00A95B, read from lst/nhl95.bin.
SPAfallback = $109C
SPAinjuryfall = $2454
SPAlist = $5A34
addframe = $79D80
addframe2 = $79DA8
updatescroll = $79F64
jdtab = $7A54A
showclock = $7C90A
checkfo = $88D52
showref = $89A2E
showcrowd = $A0BF8
SmallFontMap = $139094

; Main segment code
	include	display95.asm
