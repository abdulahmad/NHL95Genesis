	include	macros\genesis.mac	;String (main95.asm includes it in the full build)
;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
;
;	input95_02 segment stub. Retail $08A056-$08A3FD.
;
;<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<

; region code
	org	$8A056

; includes for stubs to replace removed code
	include	stubinc\ports.inc	;IO_* / VDP_* ports
	include	stubinc\equals.inc	;VDP status bits
	include	ram95.asm		;RAM map

; External addresses outside $08A056-$08A3FD, read from lst/nhl95.bin.
ZeroLong = $69A			;main95
dobitmap = $79A3C		;video95_01
Framer = $7A270			;video95_02
printz = $7C810			;video95_03
print = $7C822			;video95_03
eraser = $7C8CC			;video95_03
loadTeamStruct = $7CAF0		;video95_03
PrintSmallListItem = $7CB38	;video95_03
PrintScores1 = $7D776		;video95_03
SetPersonel = $836CC		;collide95_02
priolist = $83E16		;collide95_02
linelist = $8A02C		;data95_02
doplayeracc = $8BCFA		;checks95_06
box = $8C694			;checks95_06
EnergyBarMap = $14C4C8		;graphics95_01

; Main segment code
	include	input95_02.asm
