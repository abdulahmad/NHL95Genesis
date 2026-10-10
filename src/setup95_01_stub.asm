;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
;
;	setup95_01 segment stub. Retail $00A656-$00AF43.
;
;<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<

; region code
	org	$A656

; includes for stubs to replace removed code
	include	stubinc\ports.inc	;IO_* / VDP_* ports
	include	stubinc\equals.inc	;VDP status bits
	include	ram95.asm		;RAM map

; External addresses outside $00A656-$00AF43, read from lst/nhl95.bin: jsr / jmp (x).l and movea.l / movea.w #x carry the address.
ReadJoy1 = $7A4B0		;video95_02
ReadJoy2 = $7A4C8		;video95_02
ReadJoy3 = $7A4E0		;video95_02
ReadJoy4 = $7A50C		;video95_02
doinput = $83EB2		;collide95_02
doassignment = $7FD84		;95 only: run a3's assignment (94 updateplayers does the asstab call in line). (checks95_01)
checkcoll = $7A7B4		;collide95_01
chkcheckstart = $8D39A		;95 only: may change d1 to SPAcheckstart. (replay95_02)
SetSPA = $8BC9A			;checks95_06
getpde = $7CAD0			;video95_03
setpde = $7DBCA			;video95_03
dirtab = $8B9D6			;checks95_06
Sweepcheck = $7B08A		;collide95_01
LoadTeamLines = $8A622		;95 only: the line sets of team struct a2 (save RAM or the team data). (checks95_05)
TeamList = $772			;teamdata95
; frames95 SPA tables (frames95.asm defines them in the full build)
SPAskate = $2
SPAskatewp = $738
SPAHold = $E10
SPAhook = $E74
SPAburst = $11AE

; Main segment code
	include	setup95_01.asm
