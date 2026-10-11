	include	macros\genesis.mac	;String (main95.asm includes it in the full build)
;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
;
;	logic95 segment stub. Retail $07FCFC-$0836AB.
;
;<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<

; region code
	org	$7FCFC

; includes for stubs to replace removed code
	include	stubinc\ports.inc	;IO_* / VDP_* ports
	include	stubinc\equals.inc	;VDP status bits
	include	ram95.asm		;RAM map

; External addresses outside $07FCFC-$0836AB, read from lst/nhl95.bin.
SprSort = $A8E6		;display95
Acheck = $AA46		;control95
burstchk = $AA7A		;control95
setpads = $AB2A		;control95
chgplayer = $AB4E		;control95
setc1player = $AD80		;control95
setc2player = $AD8A		;control95
setc3player = $AD96		;control95
setc4player = $ADA2		;control95
sfx = $677AC		;sound95
rtss2 = $79CC8		;asstab entry 0, the shared rts (video95)
Sweepcheck = $7B08A		;collide95
checkpuckcoll = $7B51A		;collide95
sroot = $7C512		;middle95
vtoa = $7C586		;middle95
randomd0s = $7C62E		;middle95
randomd0 = $7C63A		;middle95
GetHot = $7C672		;middle95
loadTeamStruct = $7CAF0		;middle95
ReadGoaliePulled = $7CB0A		;middle95
chkpk = $7D884		;middle95
chkpk2 = $7D894		;middle95
PuckcIsGoalie = $836AC		;95 only: eq when the puck carrier is a goalie (players95)
setpersonel = $836CC		;players95
setplayer = $83960		;players95
dopass = $844F8		;input95
Findhittype = $84A16		;input95
SetShotMode = $84A36		;input95
ShotMode = $84AD0		;input95
doshot = $84B6E		;input95
compshoot = $84FB6		;input95
puckfaceoff = $883C8		;asstab entry 3 (faceoff95)
puckfaceoff2 = $886AE		;asstab entry 4 (faceoff95)
assfaceoff = $88AF6		;faceoff95
assfaceoffp1 = $88B0C		;faceoff95
AddPenalty = $89140		;penalty95
AddPenalty2 = $8916E		;penalty95
puckIChk = $89ADA		;penalty95
ChkOffsides = $89B3A		;penalty95
checkob = $89F5C		;penalty95
AutoLineChange = $8A4FC		;lines95
GoalieReadySPA = $8B9A8		;95 only: d1 = the goalie ready animation by the puck distance (skate95)
stopna = $8BB1A		;skate95
SetSPA = $8BC9A		;skate95
doplayeracc = $8BCFA		;skate95
playeracc = $8C086		;skate95
CanBlock = $8D452		;95 only: ne when a joystick player may block the shot (replay95)
SkatePath = $9DC18		;shootout95
ShootoutShootCheck = $9DCA0		;shootout95
puckshootout = $9E5F0		;shootout95
puckpenshot = $9E8E0		;shootout95
UpdatePenaltyShotEnd = $9EC5E		;shootout95

; Main segment code
	include	engine\logic95.asm
