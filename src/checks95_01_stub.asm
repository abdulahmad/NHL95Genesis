	include	macros\genesis.mac	;String (main95.asm includes it in the full build)
;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
;
;	checks95_01 segment stub. Retail $07F97E-$0807EB.
;
;<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<

; region code
	org	$7F97E

; includes for stubs to replace removed code
	include	stubinc\ports.inc	;IO_* / VDP_* ports
	include	stubinc\equals.inc	;VDP status bits
	include	stubinc\ram_addrs.inc	;RAM names

; External addresses outside $07F97E-$0807EB, read from lst/nhl95.bin.
setc1player = $AD80		;setup95_01
setc2player = $AD8A		;setup95_01
sfx = $677AC			;sound95_01
dobitmap = $79A3C		;video95_01
rtss2 = $79CC8			;asstab entry 0, the shared rts (video95_01)
WaitVSyncAndReadInput = $7A79C	;collide95_01
sroot = $7C512			;video95_03
vtoa = $7C586			;video95_03
randomd0 = $7C63A		;video95_03
printz2 = $7C6D4		;video95_03
printsmall = $7C6E6		;video95_03
printz = $7C810			;video95_03
loadTeamStruct = $7CAF0		;video95_03
ReadAttributeNibble = $7CB4E	;video95_03
GetTempPlayerNameAttrib = $7CCD2	;video95_03
waitx = $7D706			;video95_03
RestoreTeamEnergy = $7DB7C	;video95_03
RedrawMenu = $7E540		;DrawMenuScreen after the draw routine: print the items and fade in (menu95)
ClearMenuBox = $7F020		;menu95
assdefd = $807EC		;asstab entry 7 (assign95_01)
asswingd = $809FE		;asstab entry 8 (assign95_01)
asswingo = $80BEA		;asstab entry 9 (checks95_02)
asscenterd = $80D64		;checks95_02
asscentero = $80EF2		;checks95_02
assdefo = $81024		;95 starts with bclr #7,$64a3 (checks95_02)
assfight = $8121E		;An rts 94 assfight and assfwatch are rts only (checks95_02)
pucknorm = $81220		;asstab entry 1 (checks95_02)
puckunflip = $8130C		;asstab entry 5 (checks95_02)
puckshadow = $81352		;asstab entry 2 (checks95_02)
assexit = $8155E		;checks95_02
assinsert = $81570		;checks95_02
skateto = $8162C		;checks95_02
asspassrec = $81958		;checks95_02
rtsskate = $81A5C		;The second rts after SkateToTempTarget; 94 branched to rtss2 here (checks95_02)
assbreakaway = $81A5E		;checks95_02
assnearest = $81A84		;checks95_02
skatetopuck = $81E5E		;checks95_02
chkpuckc = $8213C		;checks95_02
asspuckc = $82166		;checks95_02
chk4pass = $82638		;checks95_02
check4bench = $82790		;checks95_02
assbench = $8282E		;assign95_02
asspenalty = $829A6		;assign95_02
assdopen = $82B0A		;assign95_02
assepen = $82B3E		;assign95_02
assonetimer = $82BD0		;onetimer95
assshoot = $82FC2		;checks95_03
assgoaliectrl = $82FFA		;checks95_03
asseben = $831AC		;checks95_03
assscore = $83452		;checks95_03
assgoaliebreakwait = $8356C	;checks95_03
SetPersonel = $836CC		;checks95_03
puckfaceoff = $883C8		;asstab entry 3 (checks95_04)
puckfaceoff2 = $886AE		;asstab entry 4 (checks95_04)
assfaceoff = $88AF6		;checks95_04
assfaceoffp1 = $88B0C		;checks95_04
AddPenalty2 = $8916E		;penalty95
GoalieReadySPA = $8B9A8	;95 only: d1 = the goalie ready animation by the puck distance (input95_03)
stopna = $8BB1A			;checks95_06
SetSPA = $8BC9A			;checks95_06
playeracc = $8C086		;checks95_06
puckshootout = $9E5F0		;checks95_07
puckpenshot = $9E8E0		;checks95_07
ClockDigitsBitmap = $13FC18	;graphics95_01

; Main segment code
	include	checks95_01.asm
