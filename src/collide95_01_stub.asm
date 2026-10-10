;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
;
;	collide95_01 segment stub. Retail $07A762-$07C511.
;
;<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<

; region code
	org	$7A762

; includes for stubs to replace removed code
	include	stubinc\ports.inc	;IO_* / VDP_* ports
	include	stubinc\equals.inc	;VDP status bits
	include	stubinc\ram_addrs.inc	;RAM names

; External addresses outside $07A762-$07C511, read from lst/nhl95.bin.
setc1player = $AD80		;setup95_01
setc2player = $AD8A		;setup95_01
setc3player = $AD96		;setup95_01
setc4player = $ADA2		;setup95_01
sfx = $677AC			;sound95_01
song = $678C2			;sound95_01
newcheck = $682B0		;sound95_01
rtss2 = $79CC8			;An rts (video95_01)
nodiag = $7A488			;video95_02
ReadMenuJoy = $7A6AA		;video95_02
sroot = $7C512			;video95_03
vtoa = $7C586			;video95_03
randomd0s = $7C62E		;video95_03
randomd0 = $7C63A		;video95_03
GetHot = $7C672			;video95_03
makepde = $7CAA6		;video95_03
puckflip = $81336
a2touchpuck = $8142C
onetimershot = $82EFE
Stop4Pen = $8901C
AddPenalty = $89140
AddPenalty2 = $8916E
checkagr = $8996E		;data95_02
ChkShotStat = $8ABDA
SetSPA = $8BC9A
Goal = $8C304			;checkgoal .goal in 94
LockScroll = $8C8EC		;95 only: xc1 / yc1 = Hpos / Vpos, sfslock
PenShotChk = $9EEC4
setInjuryType = $9F012

; Main segment code
	include	collide95_01.asm
