;	Segment build for collide95.asm: sets its origin and the outside routines and data it uses,
;	then includes collide95.asm on its own for checking against the ROM.

	include	macros\genesis.mac	;String
; region code
	org	$7A7B4

; includes for stubs to replace removed code
	include	stubinc\ports.inc	;IO_* / VDP_* ports
	include	stubinc\equals.inc	;VDP status bits
	include	ram95.asm		;RAM map

; External addresses outside, read from lst/nhl95.bin.
setc1player = $AD80
setc2player = $AD8A
setc3player = $AD96
setc4player = $ADA2
sfx = $677AC
song = $678C2
newcheck = $682B0
rtss2 = $79CC8		;asstab entry 0, the shared rts
sroot = $7C512
vtoa = $7C586
randomd0s = $7C62E
randomd0 = $7C63A
GetHot = $7C672
makepde = $7CAA6
puckflip = $81336
a2touchpuck = $8142C
onetimershot = $82EFE
Stop4Pen = $8901C
AddPenalty = $89140
AddPenalty2 = $8916E
checkagr = $8996E
ChkShotStat = $8ABDA
SetSPA = $8BC9A
Goal = $8C304
LockScroll = $8C8EC
PenShotChk = $9EEC4
setInjuryType = $9F012

; Main segment code
	include	engine\collide95.asm
