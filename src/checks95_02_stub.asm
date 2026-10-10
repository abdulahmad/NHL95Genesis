;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
;
;	checks95_02 segment stub. Retail $080BEA-$08282D.
;
;<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<

; region code
	org	$80BEA

; includes for stubs to replace removed code
	include	stubinc\ports.inc	;IO_* / VDP_* ports
	include	stubinc\equals.inc	;VDP status bits
	include	stubinc\ram_addrs.inc	;RAM names

; External addresses outside $080BEA-$08282D, read from lst/nhl95.bin.
Acheck = $AA46			;setup95_01
burstchk = $AA7A		;setup95_01
sfx = $677AC			;sound95_01
Sweepcheck = $7B08A		;collide95_01
checkpuckcoll = $7B51A		;collide95_01
vtoa = $7C586			;video95_03
randomd0s = $7C62E		;video95_03
randomd0 = $7C63A		;video95_03
GetHot = $7C672			;video95_03
ReadGoaliePulled = $7CB0A	;video95_03
chkpk = $7D884			;video95_03
chkpk2 = $7D894			;video95_03
assgoaliecpu = $7FDA4		;checks95_01
rtss21 = $809FC			;assign95_01
PuckOnAttackHalf = $82E88	;onetimer95
a2offsides = $83152		;checks95_03
PuckcIsGoalie = $836AC		;95 only: eq when the puck carrier is a goalie (collide95_02)
dopass = $844F8			;input95_01
compshoot = $84FB6		;input95_01
AddPenalty = $89140		;penalty95
AddPenalty2 = $8916E		;penalty95
puckIChk = $89ADA		;data95_02
ChkOffsides = $89B3A		;data95_02
checkob = $89F5C		;data95_02
AutoLineChange = $8A4FC		;checks95_05
SetSPA = $8BC9A			;checks95_06
doplayeracc = $8BCFA		;checks95_06
CanCheckStart = $8D452		;95 only: ne when a joystick player may start a check (replay95)
SkatePath = $9DC18		;title95_01
ShootoutShootCheck = $9DCA0	;title95_01
UpdatePenaltyShotEnd = $9EC5E	;checks95_07

; Main segment code
	include	checks95_02.asm
