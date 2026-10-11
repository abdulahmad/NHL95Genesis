;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
;
;	input95 segment stub. Retail $083EB2-$084FE5.
;
;<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<

; region code
	org	$83EB2

; includes for stubs to replace removed code
	include	stubinc\ports.inc	;IO_* / VDP_* ports
	include	stubinc\equals.inc	;VDP status bits
	include	ram95.asm		;RAM map

; External addresses outside $083EB2-$084FE5, read from lst/nhl95.bin.
holdplayer = $AA18		;control95
burstchk = $AA7A		;control95
setpads = $AB2A			;control95
chgplayer = $AB4E		;control95
setc1player = $AD80		;control95
setc2player = $AD8A		;control95
setc3player = $AD96		;control95
setc4player = $ADA2		;control95
sfx = $677AC			;sound95
sroot = $7C512			;middle95
vtoa = $7C586			;middle95
randomd0s = $7C62E		;middle95
randomd0 = $7C63A		;middle95
GetHot = $7C672			;middle95
makepde = $7CAA6		;middle95
loadTeamStruct = $7CAF0		;middle95
ReadGoaliePulled = $7CB0A	;middle95
startpause1 = $7E7F8		;pause95
startpause2 = $7E7FE		;pause95
startpause3 = $7E806		;pause95
startpause4 = $7E80E		;pause95
puckflip = $81336		;logic95
assinsert = $81570		;logic95
assreplace = $8157A		;logic95
PuckOnAttackHalf = $82E88	;logic95
checkob = $89F5C		;penalty95
SetLCmode = $8A056		;lines95
lineinput = $8A202		;lines95
doinput_goaliedive = $8B6F8	;94 doinput .33: the goalie dive on A (skate95)
getGoalieSCnum = $8B974		;skate95
dirtab = $8B9D6			;skate95
SetSPA = $8BC9A			;skate95
doplayeracc = $8BCFA		;skate95
PSandSOpassdir = $9DAD0		;shootout95
ShortenMsgTimer = $9EFE4	;shootout95

; Main segment code
	include	engine\input95.asm
