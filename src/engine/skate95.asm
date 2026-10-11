; $08B4E0  Adapted from checks94.asm and input94.asm: goalie and skater movement
;	checks94 goalieacc, the input94 goalie dive, doinput_cbut ... getGoalieSCnum, the 95 GoalieReadySPA, checks94 dirtab
;	(and the 95 dirtab2), MaxSpeed ... stopna, the 95 updatevel, SetSPA, crowd94 stopna2, checks94 doplayeracc ... playeracc,
;	title94 PlaceBoardFall. Each routine comment names its 94 file or says 95 only. goal95 follows at $08C304.
;	EA's compiler emits cmp #imm,Dn as CMP (Bxxx), SNASM emits CMPI (0Cxx). The source has the real cmp / cmpi; fixopcodes.js patches the
;	cmp encoding after assembly.

goalieacc	;(checks94) Goalie movement: a pad goalie near his crease faces the puck and gets the ready SPA (GoalieReadySPA),
	;turning (AdjustFacingDirection); stopna2 deep in the crease; then playeracc. A computer goalie keeps or turns its facing
	btst	#3,pflags(a3)
	beq.w	.9
	movem.w	d0,-(sp)
	move.w	(puckc).w,d0
	cmp.w	SCnum(a3),d0
	movem.w	(sp)+,d0
	beq.w	.9
	cmpi.w	#$30,(a3)
	bgt.w	.9
	cmpi.w	#$FFD0,(a3)
	blt.w	.9
	cmpi.w	#$FF40,Ypos(a3)
	bgt.w	.0
	cmpi.w	#$FEFA,Ypos(a3)
	blt.w	.9
	bra.w	.1
.0
	cmpi.w	#$C0,Ypos(a3)
	blt.w	.9
	cmpi.w	#$106,Ypos(a3)
	bgt.w	.9
.1
	movem.w	d0-d1,-(sp)
	move.w	(puckx).w,d0
	sub.w	(a3),d0
	move.w	(pucky).w,d1
	sub.w	Ypos(a3),d1
	cmp.w	#$10,d0
	bgt.w	.2
	cmp.w	#$FFF0,d0
	blt.w	.2
	cmp.w	#$10,d1
	bgt.w	.2
	cmp.w	#$FFF0,d1
	blt.w	.2
	move.w	facedir(a3),d0
	bra.w	.3
.2
	jsr	(vtoa).l
.3
	btst	#0,(sflags4).w
	bne.w	.4
	jsr	(AdjustFacingDirection).l
	movem.w	(sp)+,d0-d1
	bra.w	.5
.4
	movem.w	(sp)+,d0-d1
	cmp.w	#8,d0
	beq.w	.5
	movem.w	d0-d1,-(sp)
	jsr	(AdjustFacingDirection).l
	movem.w	(sp)+,d0-d1
.5
	bsr.w	GoalieReadySPA
	btst	#1,pflags2(a3)
	bne.w	.15
	jsr	(SetSPA).l
	cmp.w	#8,d0
	bne.w	.8
	tst.w	position(a3)
	bne.w	.8
	btst	#3,pflags(a3)
	beq.w	.8
	move.w	d0,-(sp)
	move.w	Ypos(a3),d0
	btst	#7,pflags(a3)
	beq.w	.6
	neg.w	d0
.6
	cmp.w	#$D8,d0
	blt.w	.7
	move.w	(a3),d0
	cmp.w	#$20,d0
	bgt.w	.7
	cmp.w	#$FFE0,d0
	blt.w	.7
	move.w	(sp)+,d0
	jsr	(stopna2).l
	bra.w	.8
.7
	jsr	(stopna2).l
	move.w	(sp)+,d0
.8
	move.w	d0,d2
	jmp	playeracc
.9
	bsr.w	GoalieReadySPA
	btst	#3,pflags(a3)
	beq.w	.13
	btst	#2,pflags(a3)
	bne.w	.14
	cmp.w	#8,d0
	bne.w	.12
	tst.w	position(a3)
	bne.w	.14
	move.w	d0,-(sp)
	move.w	Ypos(a3),d0
	btst	#7,pflags(a3)
	beq.w	.10
	neg.w	d0
.10
	cmp.w	#$D8,d0
	blt.w	.11
	move.w	(a3),d0
	cmp.w	#$20,d0
	bgt.w	.11
	cmp.w	#$FFE0,d0
	blt.w	.11
	move.w	(sp)+,d0
	jsr	(stopna).l
	bra.w	.14
.11
	move.w	(sp)+,d0
	bra.w	.14
.12
	bra.w	.17
.13
	andi.w	#$F,d0
	cmp.w	#7,d0
	ble.w	.17
	cmp.w	#9,d0
	bne.w	.14
	move.w	Xvel(a3),d0
	or.w	Yvel(a3),d0
	beq.w	.14
	jmp	stopna2
.14
	btst	#1,pflags2(a3)
	beq.w	.16
.15
	rts
.16
	jmp	SetSPA
.17
	sub.w	facedir(a3),d0
	beq.w	.18
	neg.w	d0
	andi.w	#4,d0
	lsr.w	#1,d0
	subq.w	#1,d0
	add.w	facedir(a3),d0
	andi.w	#7,d0
	move.w	d0,facedir(a3)
.18
	move.w	#$22BA,d1
	jsr	(SetSPA).l
	move.w	facedir(a3),d2
	jmp	playeracc
	rts	;unused

doinput_goaliedive	;(input94 doinput .33) The goalie dive on button A (bit 6): face TempWord1, nopuck 8, the dive SPA $1D4E, crowd
	;+$96. Jumped to from doinput (input95)
	btst	#6,d1
	beq.w	doinput_cbut
	move.w	(TempWord1).w,d0
	cmp.b	#8,d0
	beq.w	doinput_cbut
	move.w	d0,facedir(a3)
	move.b	#8,nopuck(a3)
	move.w	#$1D4E,d1
	jsr	(SetSPA).l
	bset	#1,pflags2(a3)
	bset	#5,pflags(a3)
	addi.w	#$96,(crowdlevel).w

rtss15	;The rts of doinput_goaliedive
	rts

;------------------------------------------------------------------------------------------------------------------------
; $08B734  From input94.asm: doinput_cbut, ClampTargetY, doinput_chkanim, getGoalieSCnum
;	94 input94 doinput_cbut, ClampTargetY (with the 10 SPA offsets after it), doinput_chkanim and getGoalieSCnum (95 getGoalieSCnum).
;doinput_onetimer / doinput_ispc are not in 95 here; doinput_islocked is in input95.
;	95 changes: the y limits $106 / $FEFA, the goalie box in doinput_chkanim, the 95 SPA values.


doinput_cbut	;(input94) Global: doinput branches here across the global rtss15. Button C (bit 5): new press: face the puck
	;(vtoa) and go on below; held: hold the SPA frame (SPAcnt $A) at the end of a frame list (SPAlist)
	btst	#5,d1
	bne.w	.2
	btst	#5,d3
	bne.w	.0
	bra.w	doinput_chkanim
.0
	movem.l	d0-d3/a0-a3,-(sp)
	movea.l	#SPAlist,a0
	adda.w	SPA(a3),a0
	move.w	facedir(a3),d0
	btst	#3,attribute(a3)
	beq.w	.1
	neg.w	d0
	addq.w	#8,d0
	andi.w	#7,d0
.1
	asl.w	#1,d0
	adda.w	(a0,d0.w),a0
	tst.b	SPAnum+1(a3)
	movem.l	(sp)+,d0-d3/a0-a3
	bpl.s	rtss15
	move.w	#$A,SPAcnt(a3)
	rts
.2
	btst	#5,pflags(a3)
	bne.w	doinput_chkanim
	movem.w	d0-d1,-(sp)
	move.w	(puckx).w,d0
	sub.w	(a3),d0
	move.w	(pucky).w,d1
	sub.w	Ypos(a3),d1
	jsr	(vtoa).l
	move.w	d0,facedir(a3)
	movem.w	(sp)+,d0-d1
	move.w	(TempWord1).w,d0
	bclr	#0,(BA_PS_flags).w
	move.w	(gameclock).w,d0
	andi.w	#7,d0
	asl.w	#4,d0
	addi.w	#$A0,d0
	cmpi.w	#$DE,(pucky).w
	bgt.w	.3
	cmpi.w	#$FF22,(pucky).w
	bgt.w	.4
.3
	subi.w	#$40,d0
.4
	move.w	d0,d1
	muls.w	(puckvx).w,d0
	swap	d0
	add.w	(puckx).w,d0
	muls.w	(puckvy).w,d1
	swap	d1
	add.w	(pucky).w,d1
	bsr.w	ClampTargetY
	movem.w	d0-d1,-(sp)
	muls.w	d0,d0
	muls.w	d1,d1
	add.l	d1,d0
	cmp.l	#$384,d0
	bhi.w	.5
	movem.w	(sp)+,d0-d1
	bra.w	.7
.5
	jsr	(sroot).l
	moveq	#1,d2
	add.w	d0,d2
	moveq	#$12,d4
	btst	#3,(sflags).w
	beq.w	.6
	addq.w	#8,d4
.6
	movem.w	(sp)+,d0-d1
	muls.w	d4,d1
	addq.w	#8,d4
	muls.w	d4,d0
	divs.w	d2,d0
	divs.w	d2,d1
.7
	add.w	d3,d1
	move.w	d1,d2
	cmpi.w	#$22,2(a0)
	cmpi.w	#$18,(a0)
	cmpi.w	#$FFE8,(a0)
	cmpi.w	#$C,2(a0)
	cmpi.w	#$10B,(pucky).w
	cmpi.w	#$FEF5,(pucky).w
	bset	#1,pflags2(a3)
	bne.w	doinput_chkanim
	movem.l	d0-d7/a0-a6,-(sp)
	movea.l	#puckcross,a0
	move.w	#$10B,d3
	btst	#7,pflags(a3)
	beq.w	.8	;branch if bottom net
	neg.w	d3	;negate d3 (-108 hex)
	addq.w	#4,a0	;puckcross+4 (for bottom goalie)
.8
	jsr	(goaliesave).l
	movem.l	(sp)+,d0-d7/a0-a6
	rts

ClampTargetY	;(input94) Clamp target y d1 to $106 / $FEFA (94 $103 / $FEFD), then d1 - d3; d0 = 0 for the puck carrier.
	;10 SPA offsets follow
	move.w	(puckc).w,d2
	cmp.w	SCnum(a3),d2
	bne.w	.0
	clr.w	d0
.0
	cmp.w	#$106,d1
	blt.w	.1
	move.w	#$106,d1
.1
	cmp.w	#$FEFA,d1
	bgt.w	.2
	move.w	#$FEFA,d1
.2
	sub.w	d3,d1
	rts
	;10 SPA offsets, no reference in the listing (94 the same table): SPAgglover, SPAgglovel, SPAgstackr, SPAgstackl, SPAgstickr,
	;SPAgstickl, then SPAgglover, SPAgglovel, SPAgstickr, SPAgstickl where 94 has SPAghighr, SPAghighl, SPAgstick2r, SPAgstick2l
	dc.w	$1C86,$1CB8,$205E,$200C,$1CEA,$1D1C,$1C86,$1CB8,$1CEA,$1D1C

doinput_chkanim	;(input94) Global: doinput branches here across ClampTargetY. Animation in progress (pflags2 bit 1): rts. A
	;goalie (position 0) is held inside x $24 / y $E7 of his net (BA_PS_flags bit 1), then playeracc with TempWord1
	btst	#1,pflags2(a3)
	beq.w	.0
	rts
.0
	tst.w	position(a3)
	bne.w	doplayeracc
	bclr	#1,(BA_PS_flags).w
	cmpi.w	#$24,(a3)
	ble.w	.1
	tst.w	Xvel(a3)
	bmi.w	.1
	beq.w	.1
	bset	#1,(BA_PS_flags).w
	clr.w	Xvel(a3)
.1
	cmpi.w	#$FFDC,(a3)
	bge.w	.2
	tst.w	Xvel(a3)
	bpl.w	.2
	bset	#1,(BA_PS_flags).w
	clr.w	Xvel(a3)
.2
	cmpi.w	#$E7,Ypos(a3)
	bgt.w	.4
	cmpi.w	#$FF19,Ypos(a3)
	ble.w	.4
	bra.w	*+4	;to the next instruction
.3
	movem.w	d0-d1,-(sp)
	move.w	Ypos(a3),d0
	move.w	Yvel(a3),d1
	eor.w	d1,d0
	movem.w	(sp)+,d0-d1
	bpl.w	.4
	tst.w	Yvel(a3)
	beq.w	.4
	bset	#1,(BA_PS_flags).w
	clr.w	Yvel(a3)
.4
	btst	#1,(BA_PS_flags).w
	bne.w	rtss15
	move.w	(TempWord1).w,d0
	jmp	doplayeracc

getGoalieSCnum	;(input94 getGoalieSCnum) 95: d0 = SCnum of the goalie of the team of player d0 (the first position 0 going down
	;from player d0), -1 none
	movem.l	d1/a0,-(sp)
	movea.l	#SortCords,a0
	asl.w	#7,d0
	adda.w	d0,a0
	move.w	#5,d1
.0
	tst.w	position(a0)
	beq.w	.1
	suba.w	#SCstruct,a0
	dbf	d1,.0
	move.w	#$FFFF,d0
	bra.w	.2
.1
	move.w	SCnum(a0),d0
.2
	movem.l	(sp)+,d1/a0
	rts

;------------------------------------------------------------------------------------------------------------------------
; $08B9A8  From checks94.asm: player movement, SetSPA, the goal, the controller setup screen
;	checks94 dirtab, MaxSpeed, dostop, stopna, SetSPA, doplayeracc, noturn0, noturn, playeracc and the goal code, with moved in: crowd94
;	stopna2, penalty94 PenGoalStuff, data94 box / DisplayPlayerAttributeMenu / GoalBigTxt / PPGoalBigTxt, title94 PrintPlayerAssists /
;	PrintPlayerGoals / PrintParenNumber, replay94 checkwindow, setup94 PeriodOver / GameOver / ExitToOpening, hockey94 clockcont_0 /
;	clockcont; and the 95 controller setup screen (SetContTeams ... ReadAllPads).
;SetGoaliesCtl and PeriodOver as dc.b and the last four routines as wrong code; they and the tables are read from the
;retail bytes. printz Strings and DecompressGraphicsWithCallback remap bytes as instructions; they are String / dc.b here.


GoalieReadySPA	;95 only. d1 = the goalie ready SPA: $1B7A near the puck (within $56 in y) or in a shootout, else $1C54
	move.w	d0,-(sp)
	move.w	#$1C54,d1
	btst	#0,(gmode).w
	bne.w	.1
	move.w	(pucky).w,d0
	sub.w	Ypos(a3),d0
	bpl.w	.0
	neg.w	d0
.0
	cmp.w	#$56,d0
	bgt.w	.2
.1
	move.w	#$1B7A,d1
.2
	move.w	(sp)+,d0
	rts

dirtab	;(checks94) X / Y acc speed for each direction 0-7. 95 runspeed $F0 ($A9 = runspeed / sqrt(2); 94 $C8 / $8D)
	dc.w	0,$F0,$A9,$A9,$F0,0,$A9,$FF57
	dc.w	0,$FF10,$FF57,$FF57,$FF10,0,$FF57,$A9
	dc.w	0,0

dirtab2	;95 only: the same with runspeed $E4 / $A1
	dc.w	0,$E4,$A1,$A1,$E4,0,$A1,$FF5F
	dc.w	0,$FF1C,$FF5F,$FF5F,$FF1C,0,$FF5F,$A1
	dc.w	0,0

MaxSpeed	;(checks94) Max speed values for each rating level 0-$F: ((n+20)*325)^2 (94 275)
	dc.l	((0+20)*325)*((0+20)*325)
	dc.l	((1+20)*325)*((1+20)*325)
	dc.l	((2+20)*325)*((2+20)*325)
	dc.l	((3+20)*325)*((3+20)*325)
	dc.l	((4+20)*325)*((4+20)*325)
	dc.l	((5+20)*325)*((5+20)*325)
	dc.l	((6+20)*325)*((6+20)*325)
	dc.l	((7+20)*325)*((7+20)*325)
	dc.l	((8+20)*325)*((8+20)*325)
	dc.l	((9+20)*325)*((9+20)*325)
	dc.l	((10+20)*325)*((10+20)*325)
	dc.l	((11+20)*325)*((11+20)*325)
	dc.l	((12+20)*325)*((12+20)*325)
	dc.l	((13+20)*325)*((13+20)*325)
	dc.l	((14+20)*325)*((14+20)*325)
	dc.l	((15+20)*325)*((15+20)*325)

dostop	;(checks94) Stop player a3: under $1000 speed in x and y the velocities are cleared, else slowed
	cmpi.w	#$1000,Xvel(a3)
	bgt.w	.0
	cmpi.w	#$F000,Xvel(a3)
	blt.w	.0
	cmpi.w	#$1000,Yvel(a3)
	bgt.w	.0
	cmpi.w	#$F000,Yvel(a3)
	blt.w	.0
	bra.w	stopna
.0
	move.w	SCnum(a3),d1
	cmp.w	(puckc).w,d1
	beq.w	.1
	move.w	#$B5C,d1
	bra.w	.2
.1
	move.w	#$B8E,d1
.2
	btst	#4,pflags(a3)
	bne.w	.6
	move.w	#$D08,d1
	movem.w	d1,-(sp)
	move.w	SCnum(a3),d1
	cmp.w	(puckc).w,d1
	movem.w	(sp)+,d1
	bne.w	.3
	move.w	#$D5A,d1
.3
	bsr.w	SetSPA
	movem.w	d0,-(sp)
	move.w	Xvel(a3),d0
	bpl.w	.4
	neg.w	d0
.4
	move.w	d0,-(sp)
	move.w	Yvel(a3),d0
	bpl.w	.5
	neg.w	d0
.5
	add.w	(sp)+,d0
	cmp.w	#$2000,d0
	movem.w	(sp)+,d0
	ble.w	.6
	bset	#1,pflags2(a3)
	move.w	#$D08,d1
	movem.w	d1,-(sp)
	move.w	SCnum(a3),d1
	cmp.w	(puckc).w,d1
	movem.w	(sp)+,d1
	bne.w	.6
	move.w	#$D5A,d1
.6
	bsr.w	SetSPA

stopna	;(checks94) Slow player a3 by $96 in x and y toward 0, no animation change
	tst.w	Xvel(a3)
	beq.w	.1
	bpl.w	.0
	addi.w	#$96,Xvel(a3)
	bmi.w	.1
	clr.w	Xvel(a3)
.0
	subi.w	#$96,Xvel(a3)
	bpl.w	.1
	clr.w	Xvel(a3)
.1
	tst.w	Yvel(a3)
	beq.w	.3
	bpl.w	.2
	addi.w	#$96,Yvel(a3)
	bmi.w	.3
	clr.w	Yvel(a3)
.2
	subi.w	#$96,Yvel(a3)
	bpl.w	.3
	clr.w	Yvel(a3)
.3
	rts

updatevel	;95 only. The velocity update 94 updateplayers does in line
	cmpi.w	#$E,SCnum(a3)
	bne.w	.1
	cmpi.w	#$150,Ypos(a3)
	bgt.w	.0
	cmpi.w	#$FEB0,Ypos(a3)
	blt.w	.0
	cmpi.w	#$CA,(a3)
	bgt.w	.0
	cmpi.w	#$FF36,(a3)
	bge.w	.1
.0
	clr.w	Xvel(a3)
	clr.w	Yvel(a3)
	st	Zpos(a3)
.1
	tst.w	Zpos(a3)
	bne.w	.7
	moveq	#5,d2
	btst	#0,pflags(a3)
	beq.w	.2
	moveq	#9,d2
	cmpi.w	#$E,SCnum(a3)
	bne.w	.2
	move.w	#7,d2
.2
	move.w	Xvel(a3),d0
	beq.w	.5
	tst.w	position(a3)
	bne.w	.3
	cmpi.w	#$E,SCnum(a3)
	beq.w	.3
	tst.w	d2
	beq.w	.3
	cmpi.w	#$22BA,SPA(a3)
	beq.w	.3
	subq.w	#1,d2
.3
	asr.w	d2,d0
	bne.w	.4
	moveq	#1,d0
.4
	sub.w	d0,Xvel(a3)
.5
	move.w	Yvel(a3),d0
	beq.w	.7
	asr.w	d2,d0
	bne.w	.6
	moveq	#1,d0
.6
	sub.w	d0,Yvel(a3)
.7
	move.w	Xvel(a3),d0
	beq.w	.8
	muls.w	d4,d0
	move.l	d0,-(sp)
	asr.l	#5,d0
	add.l	(sp)+,d0
	add.l	d0,(a3)
.8
	move.w	Yvel(a3),d0
	beq.w	.9
	muls.w	d4,d0
	move.l	d0,-(sp)
	asr.l	#5,d0
	add.l	(sp)+,d0
	add.l	d0,Ypos(a3)
.9
	tst.w	Zpos(a3)
	bmi.w	.12
	bne.w	.10
	tst.w	Zvel(a3)
	beq.w	.12
.10
	asl.w	#1,d4
	sub.w	d4,Zvel(a3)
	asl.w	#1,d4
	sub.w	d4,Zvel(a3)
	lsr.w	#2,d4
	move.w	Zvel(a3),d0
	muls.w	d4,d0
	add.l	d0,Zpos(a3)
	bpl.w	.12
	clr.l	Zpos(a3)
	neg.w	Zvel(a3)
	asr	Zvel(a3)
	moveq	#5,d0
	sub.b	Zvel(a3),d0
	bpl.w	.11
	clr.w	d0
.11
	cmp.w	#3,d0
	bhi.w	.12
	move.w	#$2C,d0
	move.w	d0,-(sp)
	jsr	(sfx).l
.12
	rts

SetSPA	;(checks94) Set animation d1 for player a3 unless it is already running
	cmp.w	SPA(a3),d1
	beq.w	.0
	clr.w	SPAnum(a3)
	move.w	d1,SPA(a3)
	st	SPAcnt(a3)	;restart animation
.0
	rts

stopna2	;(crowd94) Stop, keeping the animation (goalies)
	tst.w	Xvel(a3)
	bpl.w	.0
	addi.w	#$7D0,Xvel(a3)
	bmi.w	.1
	clr.w	Xvel(a3)
.0
	subi.w	#$7D0,Xvel(a3)
	bpl.w	.1
	clr.w	Xvel(a3)
.1
	tst.w	Yvel(a3)
	bpl.w	.2
	addi.w	#$7D0,Yvel(a3)
	bmi.w	.3
	clr.w	Yvel(a3)
.2
	subi.w	#$7D0,Yvel(a3)
	bpl.w	.3
	clr.w	Yvel(a3)
.3
	rts

doplayeracc	;(checks94) Player acceleration toward direction d0 by his speed rating (dirtab, MaxSpeed, TempRawSpd / TempMaxSpd),
	;with the turning (turnstep) and the skating animations
	tst.w	position(a3)
	bne.w	.0
	jmp	goalieacc
.0
	move.w	d0,(TempWord1).w
	move.w	SCnum(a3),d1
	cmp.w	(puckc).w,d1
	beq.w	.1
	move.w	#$B5C,d1
	bra.w	.2
.1
	move.w	#$B8E,d1
.2
	btst	#4,pflags(a3)
	beq.w	.3
	move.w	#$2564,d1
.3
	andi.w	#$F,d0	;pass first 4 bits of d0
	cmp.w	#7,d0	;compare to 7
	ble.w	.7
	cmp.w	#9,d0	;compare to 9
	bne.w	.4
	move.w	Xvel(a3),d0
	or.w	Yvel(a3),d0	;OR Yvel with Xvel
	bne.w	.5
.4
	btst	#1,pflags2(a3)
	beq.w	.6
	rts
.5
	jmp	dostop
.6
	jmp	SetSPA
.7
	movem.w	d0-d1,-(sp)
	move.w	d0,d2
	move.w	SCnum(a3),d0	;move SCnum into d0
	move.w	SCnum(a3),d0
	cmp.w	(puckc).w,d0	;check if puckc
	beq.w	.11
	move.w	(puckx).w,d0	;puckx into d0
	sub.w	(a3),d0	;sub Xpos
	move.w	Ypos(a3),d3	;Ypos into d3
	move.b	(puckvy).w,d1	;puckvy into d1
	ext.w	d1
	add.w	(pucky).w,d1	;add pucky to d1
	sub.w	d3,d1	;sub Ypos from d1
	btst	#7,pflags(a3)
	bne.w	.8
	neg.w	d0
	neg.w	d1
	neg.w	d3
	eori.w	#4,d2
.8
	btst	#4,pflags(a3)
	tst.w	d3
	bpl.w	.11
	cmp.w	#4,d2
	bne.w	.11
	jsr	(vtoa).l
	addq.w	#1,d0
	andi.w	#7,d0
	cmp.w	#2,d0
	bhi.w	.11
	bra.w	.9
	subq.w	#3,d2
	andi.w	#7,d2
	cmp.w	#2,d2
	bhi.w	.11
	jsr	(vtoa).l
	addq.w	#2,d0
	andi.w	#7,d0
	cmp.w	#4,d0
	bhi.w	.11
.9
	btst	#4,pflags(a3)
	bne.w	.12
	move.w	Xvel(a3),d0	;move Xvel into d0
	or.w	Yvel(a3),d0	;or with Yvel
	beq.w	.10
	move.w	Xvel(a3),d0	;move Xvel into d0
	move.w	Yvel(a3),d1	;Yvel to d1
	jsr	(vtoa).l
	sub.w	(sp),d0
	addq.w	#1,d0
	andi.w	#7,d0
	cmp.w	#2,d0
	bhi.w	.12
.10
	bset	#4,pflags(a3)
	bra.w	.12
.11
	bclr	#4,pflags(a3)
	beq.w	.12
	clr.w	Xvel(a3)
	clr.w	Yvel(a3)
.12
	movem.w	(sp)+,d0-d1
	move.w	facedir(a3),d2	;facedir into d2
	sub.w	d2,d0
	andi.w	#7,d0
	movea.l	#.23,a0
	asl.w	#1,d0
	move.w	(a0,d0.w),(turnstep).w
	tst.w	(turnstep).w
	bne.w	.14
	cmp.w	#8,d0
	beq.w	.14
.13
	move.b	(turnstep+1).w,$77(a3)
	bra.w	noturn0
.14
	cmp.w	#8,d0
	bne.w	.16
	bra.s	.13
	btst	#3,pflags(a3)
	bne.s	.13
	move.w	(VDP_CNTR).l,d4
	btst	#1,d4
	beq.s	.13
	tst.b	$77(a3)
	bne.w	.15
	move.w	#$10,d4
	move.w	d4,(turnstep).w
	bra.w	.16
.15
	move.b	$77(a3),d4
	ext.w	d4
	move.w	d4,(turnstep).w
.16
	move.w	Xvel(a3),d4
	move.w	d4,d3
	asr.w	#6,d4
	sub.w	d4,Xvel(a3)
	move.w	Yvel(a3),d4
	move.w	d4,d3
	asr.w	#6,d4
	sub.w	d4,Yvel(a3)
	move.w	Xvel(a3),d4	;Xvel to d4
	muls.w	d4,d4	;square d4
	move.w	Yvel(a3),d3	;Yvel to d3
	muls.w	d3,d3	;square d3
	add.l	d4,d3	;add d4 and d3
	swap	d3	;swap upper and lower words
	move.w	#$300,d4
	cmp.w	#$180,d4	;compare to d4
	bge.w	.17
	move.w	#$180,d4
.17
	muls.w	(turnstep).w,d4
	btst	#4,pflags(a3)
	beq.w	.18
	neg.l	d4
.18
	add.l	d4,facedir(a3)	;add d4 to facedir
	andi.w	#7,facedir(a3)	;pass the first 3 bits to facedir
	move.w	facedir(a3),d2	;move facedir to d2
	movem.w	d0,-(sp)
	move.w	facedir(a3),d0
	cmp.w	(TempWord1).w,d0
	movem.w	(sp)+,d0
	beq.w	.22
	cmp.w	#$14,d3
	bls.w	.22
	clr.w	d1
	tst.w	(turnstep).w
	bpl.w	.19
	eori.w	#$FFAE,d1
.19
	btst	#3,4(a3)
	beq.w	.20
	eori.w	#$FFAE,d1
.20
	addi.w	#$C12,d1
	movem.w	d1,-(sp)
	move.w	SCnum(a3),d1
	cmp.w	(puckc).w,d1
	movem.w	(sp)+,d1
	bne.w	.21
	addi.w	#$A4,d1
.21
	bset	#1,pflags2(a3)
.22
	jsr	(SetSPA).l
	move.b	(turnstep+1).w,$77(a3)
	cmp.w	#2,d3
	bhi.w	noturn
	rts
.23
	dc.w	0,$10,$10,$10,0,$FFF0,$FFF0,$FFF0
	rts;unused

noturn0	;(checks94) doplayeracc: no turn
	moveq	#2,d4
	btst	#4,pflags(a3)
	beq.w	.0
	addq.w	#4,d4
	eori.w	#8,d0
.0
	tst.w	d0
	beq.w	.5
	move.w	Xvel(a3),d0
	move.w	Yvel(a3),d1
	jsr	(vtoa).l
	btst	#3,d0
	bne.w	.1
	sub.w	facedir(a3),d0
	add.w	d4,d0
	andi.w	#7,d0
	cmp.w	#4,d0
	blt.w	dostop
.1
	addq.w	#1,facedir(a3)
	btst	#3,4(a3)
	beq.w	.2
	subq.w	#2,facedir(a3)
.2
	andi.w	#7,facedir(a3)
	move.w	SCnum(a3),d1
	cmp.w	(puckc).w,d1
	beq.w	.3
	move.w	#$B5C,d1
	bra.w	.4
.3
	move.w	#$B8E,d1
.4
	bra.w	SetSPA
.5
	move.w	#$19D2,d1
	btst	#4,pflags(a3)
	bne.w	.9
	move.w	#2,d1
	btst	#7,(sflags).w
	beq.w	.6
	move.w	#$426,d1
.6
	movem.w	d1,-(sp)
	move.w	SCnum(a3),d1
	cmp.w	(puckc).w,d1
	movem.w	(sp)+,d1
	bne.w	.7
	move.w	#$738,d1
.7
	cmpi.w	#$BC0,SPA(a3)
	beq.w	.8
	cmpi.w	#$C12,SPA(a3)
	beq.w	.8
	cmpi.w	#$C64,SPA(a3)
	beq.w	.8
	cmpi.w	#$CB6,SPA(a3)
	bne.w	.9
.8
	move.w	#$314,d1
.9
	btst	#1,pflags2(a3)
	bne.w	noturn
	bsr.w	SetSPA

noturn	;(checks94) doplayeracc: no turn, d2 = facedir
	btst	#4,pflags(a3)
	beq.w	playeracc
	eori.w	#4,d2

playeracc	;(checks94) Player acceleration with facing d2 (doplayeracc entry used by the goalie and input code)
	asl.w	#2,d2
	lea	dirtab(pc),a0
	move.w	2(a0,d2.w),d1	;Y Inc
	move.w	(a0,d2.w),d0
	move.w	Wallsin(a3),d2	;check acc dir and dont push wall
	beq.w	.0
	eor.w	d0,d2
	bpl.w	.0
	clr.w	d0
.0
	move.w	Wallcos(a3),d2
	beq.w	.1
	eor.w	d1,d2
	bmi.w	.1
	clr.w	d1
.1
	clr.w	d2	;clear d2
	move.b	weight(a3),d2	;move wgt of player into d2
	lsr.w	#2,d2	;divide d2 by 2
	neg.w	d2	;make it negative
	addi.w	#$60,d2
	add.b	legstr(a3),d2	;add agl (legstr) of player to d2
	asr.w	#1,d2	;divide by 2
	muls.w	d2,d0	;x
	muls.w	d2,d1	;y
	asr.l	#5,d0	;divide by 32
	asr.l	#5,d1
	muls.w	d7,d0	;mult d0 with frames elapsed (d7)
	muls.w	d7,d1	;mult d1 by frames elapsed (d7)
	tst.w	position(a3)
	bne.w	.2
	btst	#3,pflags(a3)
	bne.w	.2
	cmpi.w	#$22BA,SPA(a3)
	beq.w	.2
	asr.l	#1,d0
	asr.l	#1,d1
.2
	add.w	Xvel(a3),d0
	add.w	Yvel(a3),d1
	move.w	d0,d2	;move d0 into d2
	move.w	d1,d3	;move d1 into d3
	muls.w	d2,d2	;square d2
	muls.w	d3,d3	;square d3
	add.l	d2,d3	;add together
	movem.w	d0-d1,-(sp)	;push d0 and d1 to stack
	clr.l	d0
	jsr	(getpde).l
	btst	#4,(sflags7).w
	beq.w	.3
	move.w	#$1000,d0	;d0 = energy, move 1000 hex into d0
.3
	clr.w	d2	;clear d2
	move.b	legspd(a3),d2
	move.w	d2,(TempRawSpd).w	;hold spd value
	lsr.w	#1,d2	;divide by 2
	mulu.w	d0,d2	;multiply energy with spd
	asl.l	#4,d2	;mult by 16
	swap	d2	;swap d2 words (this math is to adjust for energy. Line Changes off, d2 = Spd value / 2)
	asl.w	#2,d2	;mult by 4 (No Line changes result from above = Spd value * 2)
	andi.w	#$3F,d2	;'?'   ; pass first 6 bits. Limits d2 to $3F (63 decimal)
	lea	MaxSpeed(pc),a2	;move Maxspeed table address into a2
	move.w	d2,(rosterscroll).w
	move.l	(a2,d2.w),d2
	move.l	d2,(TempMaxSpd).w	;hold MaxSpeed value
	cmpi.w	#$3C,(rosterscroll).w
	bge.w	.4
	btst	#0,(TempRawSpd+1).w	;check if TempRawSpd is odd
	beq.w	.4
	move.w	(rosterscroll).w,d2
	addq.w	#4,d2	;add 4 to d2
	move.l	(a2,d2.w),d2
	sub.l	(TempMaxSpd).w,d2	;sub TempMaxSpd from d2
	asr.l	#1,d2	;divide by 2
	add.l	(TempMaxSpd).w,d2	;add TempMaxSpd to d2 (so halves the difference between the 2 Speed steps)
.4
	btst	#6,pflags2(a3)	;check if injured during fight
	beq.w	.5
	lsr.l	#3,d2	;divide d2 by 8
.5
	tst.w	position(a3)
	bne.w	.6
	move.w	(puckc).w,d0	;puck carrier SCnum
	cmp.w	SCnum(a3),d0
	bne.w	.6
	asr.l	#1,d2	;divide d2 by 2
.6
	movem.w	(sp)+,d0-d1	;pop from stack
	cmp.l	d2,d3	;Compare d3 to d2 (max speed check)
	bhi.w	.7
	move.w	d0,Xvel(a3)	;move new Xvel into Xvel
	move.w	d1,Yvel(a3)	;move new Yvel into Yvel
.7
	tst.w	(OptLine).w
	bne.w	.9
	move.w	(VDP_CNTR).l,d0
	andi.w	#$7F,d0
	bne.w	.9
	jsr	(getpde).l
	subi.w	#$21,d0
	cmp.w	#$C00,d0
	blt.w	.8
	move.b	endurance(a3),d2
	ext.w	d2
	lsr.w	#1,d2
	add.w	d2,d0
	jsr	(setpde).l
	btst	#0,endurance(a3)
	beq.w	.9
	btst	#0,(vcount+1).w
	beq.w	.9
	addq.w	#1,d0
.8
	jmp	setpde
.9
	rts

PlaceBoardFall	;95 only. Board fall animations (SPA $26C8, $276A, $220E ...): place player a3 against the boards
	cmpi.w	#$26C8,SPA(a3)
	beq.w	.12
	cmpi.w	#$276A,SPA(a3)
	beq.w	.8
	cmpi.w	#$220E,SPA(a3)
	beq.w	.10
	cmpi.w	#$2122,SPA(a3)
	beq.w	.6
	cmpi.w	#$20B0,SPA(a3)
	beq.w	.0
	cmpi.w	#$219C,SPA(a3)
	beq.w	.3
	bra.w	.14
.0
	move.w	#$124,d0
	cmpi.w	#$56,(FallXPos).w
	bgt.w	.1
	cmpi.w	#$FFAA,(FallXPos).w
	bgt.w	.2
.1
	move.w	#$116,d0
.2
	sub.w	Ypos(a3),d0
	bmi.w	.14
	asr.w	#1,d0
	add.w	d0,Ypos(a3)
	bra.w	.14
.3
	move.w	#$FEDC,d0
	cmpi.w	#$56,(FallXPos).w
	bgt.w	.4
	cmpi.w	#$FFAA,(FallXPos).w
	bgt.w	.5
.4
	move.w	#$FEEA,d0
.5
	sub.w	Ypos(a3),d0
	bpl.w	.14
	asr.w	#1,d0
	add.w	d0,Ypos(a3)
	bra.w	.14
.6
	move.w	#$92,d0
	btst	#3,4(a3)
	beq.w	.7
	move.w	#$FF6E,d0
.7
	sub.w	(a3),d0
	asr.w	#1,d0
	add.w	d0,(a3)
	bra.w	.14
.8
	move.w	#$98,d0
	btst	#3,4(a3)
	beq.w	.9
	move.w	#$FF68,d0
.9
	sub.w	(a3),d0
	asr.w	#1,d0
	add.w	d0,(a3)
	bra.w	.14
.10
	move.w	#$FF6E,d0
	btst	#3,4(a3)
	beq.w	.11
	move.w	#$92,d0
.11
	sub.w	(a3),d0
	asr.w	#1,d0
	add.w	d0,(a3)
	bra.w	.14
.12
	move.w	#$FF68,d0
	btst	#3,4(a3)
	beq.w	.13
	move.w	#$98,d0
.13
	sub.w	(a3),d0
	asr.w	#1,d0
	add.w	d0,(a3)
.14
	rts
