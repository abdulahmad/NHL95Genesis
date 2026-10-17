;	Segment build for display95.asm: sets its origin and the outside routines and data it uses,
;	then includes display95.asm on its own for checking against the ROM.

	include	macros\genesis.mac		;String
; region code
	org	$A204

; includes for stubs to replace removed code
	include	stubinc\ports.inc		;IO_* / VDP_* ports
	include	stubinc\equals.inc		;VDP status bits
	include	ram95.asm				;RAM map

; External addresses outside, read from lst/nhl95.bin.
SPAfallback = $109C
SPAinjuryfall = $2454
SPAlist = $5A34
SPFarrow = $69
SPFarrow34 = $73
SPFpad = $6F
SPFpad34 = $79
SPFreplay = $72
SPFglide = $41
SPFGoalie = $25E
SPFgoal = $1BE
SPFpuck = $1B3
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
