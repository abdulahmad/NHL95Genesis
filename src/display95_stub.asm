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
SPAfallback = $109C		;teamdata95
SPAinjuryfall = $2454		;teamdata95
SPAlist = $5A34		;frames95
addframe = $79D80		;video95
addframe2 = $79DA8		;video95
updatescroll = $79F64		;video95
jdtab = $7A54A		;video95
showclock = $7C90A		;middle95
checkfo = $88D52		;faceoff95
showref = $89A2E		;penalty95
showcrowd = $A0BF8		;crowd95
SmallFontMap = $139094		;graphics95

; Main segment code
	include	display95.asm
