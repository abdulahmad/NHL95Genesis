;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
;
;	checks95_02 segment stub. Retail $082FC2-$0836AB.
;
;<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<

; region code
	org	$82FC2

; includes for stubs to replace removed code
	include	stubinc\ports.inc	;IO_* / VDP_* ports
	include	stubinc\equals.inc	;VDP status bits
	include	ram95.asm		;RAM map

; External addresses outside $082FC2-$0836AB, read from lst/nhl95.bin.
randomd0 = $7C63A		;video95_02
checkanim = $7FDAE		;checks95_01
rtss21 = $809FC			;checks95_01
assexit = $8155E		;checks95_01
skateto = $8162C		;checks95_01
check4check2 = $8180E		;checks95_01
rtsskate = $81A5C		;checks95_01
check4bench = $82790		;checks95_01
SetPersonel = $836CC		;collide95_02
SetShotMode = $84A36		;input95_01
ShotMode = $84AD0		;input95_01
AddPenalty = $89140		;penalty95
AddPenalty2 = $8916E		;penalty95
SetSPA = $8BC9A			;checks95_04

; Main segment code
	include	checks95_02.asm
