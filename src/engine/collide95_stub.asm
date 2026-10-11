	include	macros\genesis.mac	;String (main95.asm includes it in the full build)
;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
;
;	collide95 segment stub. Retail $07A7B4-$07C511.
;
;<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<

; region code
	org	$7A7B4

; includes for stubs to replace removed code
	include	stubinc\ports.inc	;IO_* / VDP_* ports
	include	stubinc\equals.inc	;VDP status bits
	include	ram95.asm		;RAM map

; External addresses outside $07A7B4-$07C511, read from lst/nhl95.bin.
setc1player = $AD80		;control95
setc2player = $AD8A		;control95
setc3player = $AD96		;control95
setc4player = $ADA2		;control95
sfx = $677AC		;sound95
song = $678C2		;sound95
newcheck = $682B0		;sound95
rtss2 = $79CC8		;asstab entry 0, the shared rts (video95)
sroot = $7C512		;middle95
vtoa = $7C586		;middle95
randomd0s = $7C62E		;middle95
randomd0 = $7C63A		;middle95
GetHot = $7C672		;middle95
makepde = $7CAA6		;middle95
puckflip = $81336		;logic95
a2touchpuck = $8142C		;logic95
onetimershot = $82EFE		;logic95
Stop4Pen = $8901C		;penalty95
AddPenalty = $89140		;penalty95
AddPenalty2 = $8916E		;penalty95
checkagr = $8996E		;penalty95
ChkShotStat = $8ABDA		;lines95
SetSPA = $8BC9A		;skate95
Goal = $8C304		;goal95
LockScroll = $8C8EC		;goal95
PenShotChk = $9EEC4		;shootout95
setInjuryType = $9F012		;injury95

; Main segment code
	include	engine\collide95.asm
