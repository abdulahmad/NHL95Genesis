;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
;
;	Segment stub.
;
;<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<

; region code
	org	$83EB2

; includes for stubs to replace removed code
	include	stubinc\ports.inc	;IO_* / VDP_* ports
	include	stubinc\equals.inc	;VDP status bits
	include	ram95.asm		;RAM map

; External addresses outside, read from lst/nhl95.bin.
holdplayer = $AA18
burstchk = $AA7A
setpads = $AB2A
chgplayer = $AB4E
setc1player = $AD80
setc2player = $AD8A
setc3player = $AD96
setc4player = $ADA2
sfx = $677AC
sroot = $7C512
vtoa = $7C586
randomd0s = $7C62E
randomd0 = $7C63A
GetHot = $7C672
makepde = $7CAA6
loadTeamStruct = $7CAF0
ReadGoaliePulled = $7CB0A
startpause1 = $7E7F8
startpause2 = $7E7FE
startpause3 = $7E806
startpause4 = $7E80E
puckflip = $81336
assinsert = $81570
assreplace = $8157A
PuckOnAttackHalf = $82E88
checkob = $89F5C
SetLCmode = $8A056
lineinput = $8A202
doinput_goaliedive = $8B6F8	;94 doinput.33: the goalie dive on A
getGoalieSCnum = $8B974
dirtab = $8B9D6
SetSPA = $8BC9A
doplayeracc = $8BCFA
PSandSOpassdir = $9DAD0
ShortenMsgTimer = $9EFE4

; Main segment code
	include	engine\input95.asm
