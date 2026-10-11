;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
;
;	display95 segment stub. Retail $00A204-$00A655.
;
;<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<

; region code
	org	$A204

; includes for stubs to replace removed code
	include	stubinc\ports.inc	;IO_* / VDP_* ports
	include	stubinc\equals.inc	;VDP status bits
	include	ram95.asm		;RAM map

; External addresses outside $00A204-$00A655:
updatescroll = $79F64		;video95_01
checkfo = $88D52		;checks95_03
showclock = $7C90A		;video95_02
showcrowd = $A0BF8		;stats95_02
showref = $89A2E		;data95
addframe = $79D80		;video95_01
jdtab = $7A54A			;video95_01
addframe2 = $79DA8		;video95_01
SmallFontMap = $139094		;graphics95_01
SPAlist = $5A34
SPAfallback = $109C
SPAinjuryfall = $2454

; Main segment code
	include	display95.asm
