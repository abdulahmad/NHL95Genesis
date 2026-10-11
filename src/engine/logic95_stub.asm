	include	macros\genesis.mac	;String
;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
;
;	Segment stub.
;
;<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<

; region code
	org	$7FCFC

; includes for stubs to replace removed code
	include	stubinc\ports.inc	;IO_* / VDP_* ports
	include	stubinc\equals.inc	;VDP status bits
	include	ram95.asm		;RAM map

; External addresses outside, read from lst/nhl95.bin.
SprSort = $A8E6
Acheck = $AA46
burstchk = $AA7A
setpads = $AB2A
chgplayer = $AB4E
setc1player = $AD80
setc2player = $AD8A
setc3player = $AD96
setc4player = $ADA2
sfx = $677AC
rtss2 = $79CC8		;asstab entry 0, the shared rts
Sweepcheck = $7B08A
checkpuckcoll = $7B51A
sroot = $7C512
vtoa = $7C586
randomd0s = $7C62E
randomd0 = $7C63A
GetHot = $7C672
loadTeamStruct = $7CAF0
ReadGoaliePulled = $7CB0A
chkpk = $7D884
chkpk2 = $7D894
PuckcIsGoalie = $836AC		;eq when the puck carrier is a goalie
setpersonel = $836CC
setplayer = $83960
dopass = $844F8
Findhittype = $84A16
SetShotMode = $84A36
ShotMode = $84AD0
doshot = $84B6E
CompShoot = $84FB6
puckfaceoff = $883C8		;asstab entry 3
puckfaceoff2 = $886AE		;asstab entry 4
assfaceoff = $88AF6
assfaceoffpl = $88B0C
AddPenalty = $89140
AddPenalty2 = $8916E
puckIChk = $89ADA
ChkOffsides = $89B3A
checkob = $89F5C
chk4lc = $8A4FC
GoalieReadySPA = $8B9A8		;d1 = the goalie ready animation by the puck distance
stopna = $8BB1A
SetSPA = $8BC9A
doplayeracc = $8BCFA
playeracc = $8C086
CanBlock = $8D452		;ne when a joystick player may block the shot
SkatePath = $9DC18
ShootoutShootCheck = $9DCA0
puckshootout = $9E5F0
puckpenshot = $9E8E0
UpdatePenaltyShotEnd = $9EC5E

; Main segment code
	include	engine\logic95.asm
