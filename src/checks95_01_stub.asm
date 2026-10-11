	include	macros\genesis.mac	;String (main95.asm includes it in the full build)

;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
;
;	checks95_01 segment stub. Retail $07F97E-$082BCF.
;
;<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<

; region code
	org	$7F97E

; includes for stubs to replace removed code
	include	stubinc\ports.inc	;IO_* / VDP_* ports
	include	stubinc\equals.inc	;VDP status bits
	include	ram95.asm		;RAM map

; External addresses outside $07F97E-$082BCF:
ZeroLong = $69A			;main95
setc1player = $AD80		;setup95_01
setc2player = $AD8A		;setup95_01
sfx = $677AC			;sound95_01
dobitmap = $79A3C		;video95_01
rtss2 = $79CC8			;asstab entry 0, the shared rts (video95_01)
WaitVSyncAndReadInput = $7A79C	;collide95_01
sroot = $7C512			;video95_02
vtoa = $7C586			;video95_02
randomd0 = $7C63A		;video95_02
printz2 = $7C6D4		;video95_02
printsmall = $7C6E6		;video95_02
printz = $7C810			;video95_02
loadTeamStruct = $7CAF0		;video95_02
ReadAttributeNibble = $7CB4E	;video95_02
GetTempPlayerNameAttrib = $7CCD2	;video95_02
waitx = $7D706			;video95_02
RestoreTeamEnergy = $7DB7C	;video95_02
RedrawMenu = $7E540		;DrawMenuScreen after the draw routine: print the items and fade in (menu95)
ClearMenuBox = $7F020		;menu95
assonetimer = $82BD0		;onetimer95
assshoot = $82FC2		;checks95_02
assgoaliectrl = $82FFA		;checks95_02
asseben = $831AC		;checks95_02
assscore = $83452		;checks95_02
assgoaliebreakwait = $8356C	;checks95_02
SetPersonel = $836CC		;checks95_02
puckfaceoff = $883C8		;asstab entry 3 (checks95_03)
puckfaceoff2 = $886AE		;asstab entry 4 (checks95_03)
assfaceoff = $88AF6		;checks95_03
assfaceoffp1 = $88B0C		;checks95_03
AddPenalty2 = $8916E		;penalty95
GoalieReadySPA = $8B9A8	;95 only: d1 = the goalie ready animation by the puck distance (checks95_04)
stopna = $8BB1A			;checks95_04
SetSPA = $8BC9A			;checks95_04
playeracc = $8C086		;checks95_04
puckshootout = $9E5F0		;checks95_05
puckpenshot = $9E8E0		;checks95_05
ClockDigitsBitmap = $13FC18	;graphics95_01
chkpk = $7D884			;video95_02
assdefdchase = $83220		;95 only: sets bit 7 of $64(a3), then plays the carrier when near the puck (checks95_02)
Acheck = $AA46			;setup95_01
burstchk = $AA7A		;setup95_01
Sweepcheck = $7B08A		;collide95_01
checkpuckcoll = $7B51A		;collide95_01
randomd0s = $7C62E		;video95_02
GetHot = $7C672			;video95_02
ReadGoaliePulled = $7CB0A	;video95_02
chkpk2 = $7D894			;video95_02
PuckOnAttackHalf = $82E88	;onetimer95
a2offsides = $83152		;checks95_02
PuckcIsGoalie = $836AC		;95 only: eq when the puck carrier is a goalie (collide95_02)
dopass = $844F8			;input95_01
compshoot = $84FB6		;input95_01
AddPenalty = $89140		;penalty95
puckIChk = $89ADA		;data95
ChkOffsides = $89B3A		;data95
checkob = $89F5C		;data95
AutoLineChange = $8A4FC		;checks95_04
doplayeracc = $8BCFA		;checks95_04
CanCheckStart = $8D452		;95 only: ne when a joystick player may start a check (replay95)
SkatePath = $9DC18		;shootout95
ShootoutShootCheck = $9DCA0	;shootout95
UpdatePenaltyShotEnd = $9EC5E	;checks95_05
SprSort = $A8E6			;setup95_01
setpads = $AB2A			;setup95_01
chgplayer = $AB4E		;setup95_01
setplayer = $83960		;collide95_02

; Main segment code
	include	checks95_01.asm
