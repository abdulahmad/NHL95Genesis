;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
;
;	checks95_03 segment stub. Retail $082FFA-$0836AB.
;
;<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<

; region code
	org	$82FFA

; includes for stubs to replace removed code
	include	stubinc\ports.inc	;IO_* / VDP_* ports
	include	stubinc\equals.inc	;VDP status bits
	include	ram95.asm		;RAM map

; External addresses outside $082FFA-$0836AB, read from lst/nhl95.bin.
randomd0 = $7C63A		;video95_03
checkanim = $7FDAE		;checks95_01
rtss21 = $809FC			;assign95_01
assexit = $8155E		;checks95_02
skateto = $8162C		;checks95_02
check4check2 = $8180E		;checks95_02
rtsskate = $81A5C		;checks95_02
check4bench = $82790		;checks95_02
SetPersonel = $836CC		;collide95_02
AddPenalty = $89140		;penalty95
AddPenalty2 = $8916E		;penalty95
SetSPA = $8BC9A			;checks95_06

; Main segment code
	include	checks95_03.asm
