;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
;
;	assign95_02 segment stub. Retail $08282E-$082BCF.
;
;<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<

; region code
	org	$8282E

; includes for stubs to replace removed code
	include	stubinc\ports.inc	;IO_* / VDP_* ports
	include	stubinc\equals.inc	;VDP status bits
	include	stubinc\ram_addrs.inc	;RAM names

; External addresses outside $08282E-$082BCF, read from lst/nhl95.bin.
SprSort = $A8E6			;setup95_01
setpads = $AB2A			;setup95_01
chgplayer = $AB4E		;setup95_01
Setplass = $81540		;checks95_02
assexit = $8155E		;checks95_02
assreplace = $8157A		;checks95_02
EvadePC = $8158E		;checks95_02
skateto = $8162C		;checks95_02
rtsskate = $81A5C		;checks95_02
check4bench = $82790		;checks95_02
setplayer = $83960		;collide95_02
GoalieReadySPA = $8B9A8		;input95_03
SetSPA = $8BC9A			;checks95_06

; Main segment code
	include	assign95_02.asm
