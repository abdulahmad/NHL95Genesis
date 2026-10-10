;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
;
;	display95_01 segment stub. Retail $00A204-$00A535.
;
;<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<

; region code
	org	$A204

; includes for stubs to replace removed code
	include	stubinc\ports.inc	;IO_* / VDP_* ports
	include	stubinc\equals.inc	;VDP status bits
	include	stubinc\ram_addrs.inc	;RAM names

; External addresses outside $00A204-$00A535, read from lst/nhl95.bin: jsr / jmp (x).l and movea.l #x carry the address.
updatescroll = $79F64		;display95_02
checkfo = $88D52		;checks95_04
showclock = $7C90A		;video95_03
showcrowd = $A0BF8		;stats95_02
showref = $89A2E		;data95_02
addframe = $79D80		;display95_02
jdtab = $7A54A			;video95_02
addframe2 = $79DA8		;display95_02
SmallFontMap = $139094		;graphics95_01

; Main segment code
	include	display95_01.asm
