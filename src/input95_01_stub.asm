;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
;
;	input95_01 segment stub. Retail $083EB2-$084FE5.
;
;<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<

; region code
	org	$83EB2

; includes for stubs to replace removed code
	include	stubinc\ports.inc	;IO_* / VDP_* ports
	include	stubinc\equals.inc	;VDP status bits
	include	stubinc\ram_addrs.inc	;RAM names

; External addresses outside $083EB2-$084FE5, read from lst/nhl95.bin.
holdplayer = $AA18		;setup95_01
burstchk = $AA7A		;setup95_01
setpads = $AB2A			;setup95_01
chgplayer = $AB4E		;setup95_01
setc1player = $AD80		;setup95_01
setc2player = $AD8A		;setup95_01
setc3player = $AD96		;setup95_01
setc4player = $ADA2		;setup95_01
sfx = $677AC			;sound95_01
sroot = $7C512			;video95_03
vtoa = $7C586			;video95_03
randomd0s = $7C62E		;video95_03
randomd0 = $7C63A		;video95_03
GetHot = $7C672			;video95_03
makepde = $7CAA6		;video95_03
loadTeamStruct = $7CAF0		;video95_03
ReadGoaliePulled = $7CB0A	;video95_03
startpause1 = $7E7F8		;menu95
startpause2 = $7E7FE		;menu95
startpause3 = $7E806		;menu95
startpause4 = $7E80E		;menu95
puckflip = $81336		;checks95_02
assinsert = $81570		;checks95_02
assreplace = $8157A		;checks95_02
PuckOnAttackHalf = $82E88	;onetimer95
checkob = $89F5C		;data95_02
SetLCmode = $8A056		;input95_02
lineinput = $8A202		;input95_02
doinput_goaliedive = $8B6F8	;94 doinput .33: the goalie dive on A (checks95_05)
FindGoalie = $8B974		;input95_03
dirtab = $8B9D6			;checks95_06
SetSPA = $8BC9A			;checks95_06
doplayeracc = $8BCFA		;checks95_06
PSandSOpassdir = $9DAD0		;title95_01
ShortenMsgTimer = $9EFE4	;checks95_07

; Main segment code
	include	input95_01.asm
