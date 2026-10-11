; $07FCFC  Adapted from checks94.asm, assign94.asm and onetimer94.asm: the player AI
;	6 parts in ROM order, each under its banner below.
;	EA's compiler emits cmp #imm,Dn as CMP (Bxxx), SNASM emits CMPI (0Cxx). The source has the real cmp / cmpi; fixopcodes.js patches the
;	cmp encoding after assembly.

;------------------------------------------------------------------------------------------------------------------------
; $07FCFC  From checks94.asm: asstab, doassignment, the goalie assignments
;	The 95 asstab (95 order, 34 entries; 94 kept it) and doassignment (94 updateplayers did the asstab call in line), then
;	the first part of 94 checks94: assgoaliecpu ... ClampYPosition, AdjustFacingDirection, goaliesave and its animation list,
;	assgoalietopuck. pause95 (the pause menu items) is just before it.
;$07FDA4-$080425 and $080742-$0807EB as dc.b; they are code here, read from the retail bytes. lost the btst Dn,#imm
;	lines of AdjustFacingDirection and the dead lines in goaliesave.
;	95 moves most goalie y limits 3 further out ($E4 to $E7, $104 to $107, $108 to $10B ...); the comments give the 94 values.

asstab	;Jump table of the player logic assignments (92 / 93 / 94 asstab). 95 keeps it here, in a new order: the
	;assignment numbers in asslist and in assinsert d0 are 95 numbers. The comment gives the 95 number, then the 94 one
	dc.l	rtss2		;0 (94 0)
	dc.l	pucknorm	;1 (94 $18)
	dc.l	puckshadow	;2 (94 $19)
	dc.l	puckfaceoff	;3 (94 $1B)
	dc.l	puckfaceoff2	;4 (94 $1C)
	dc.l	puckunflip	;5 (94 $1A)
	dc.l	assgoaliecpu	;6 (94 $E)
	dc.l	assdefd		;7 (94 2)
	dc.l	asswingd	;8 (94 3)
	dc.l	asswingo	;9 (94 4)
	dc.l	asscenterd	;$A (94 5)
	dc.l	asscentero	;$B (94 6)
	dc.l	assdefo		;$C (94 1)
	dc.l	asspassrec	;$D (94 $13)
	dc.l	assnearest	;$E (94 $11)
	dc.l	asspuckc	;$F (94 $10)
	dc.l	assfaceoff	;$10 (94 $16)
	dc.l	assfaceoffpl	;$11 (94 $17)
	dc.l	assbench	;$12 (94 $B)
	dc.l	asseben		;$13 (94 9)
	dc.l	assgoalietopuck	;$14 (94 $F)
	dc.l	asspenalty	;$15 (94 $C)
	dc.l	assepen		;$16 (94 $A)
	dc.l	assdopen	;$17 (94 $D)
	dc.l	assonetimer	;$18 (94 $23)
	dc.l	assfight	;$19 (94 $14)
	dc.l	assshoot	;$1A (94 $12)
	dc.l	assgoaliectrl	;$1B (94 $1D)
	dc.l	assscore	;$1C (94 7)
	dc.l	assgoaliebreakwait	;$1D (94 $20)
	dc.l	chkpuckc	;$1E (94 $21)
	dc.l	puckshootout	;$1F (94 $1E)
	dc.l	puckpenshot	;$20 (94 $1F)
	dc.l	assbreakaway	;$21 (94 $22)

doassignment	;Run the current assignment of player a3 (asslist entry assnum, asstab) with a2 / a1 = its team / the
	;other team (loadTeamStruct). Called from updatepadinput; 94 did this in line there
	move.w	assnum(a3),d0
	clr.w	d1
	move.b	asslist(a3,d0.w),d1
	asl.w	#2,d1
	movea.l	#asstab,a0
	movea.l	(a0,d1.w),a0
	jsr	(loadTeamStruct).l
	jsr	(a0)
	rts

; a3 = goalie
assgoaliecpu	;asstab entry 6. Also branched to from the bench and penalty assignments below
	btst	#3,pflags(a3)	;is goalie joystick controlled?
	bne.w	assgoaliectrl	;branch if so
checkanim	;A local of assgoaliecpu in 94; global here: assgoaliectrl branches to it
	move.w	(puckx).w,(TmpPuckX).w
	btst	#0,(sflags4).w	;test bit 0
	beq.w	.assstart
	btst	#1,pflags2(a3)	;check if animation in progress
	bne.w	.assstart	;branch if so
	btst	#1,(sflags4).w	;test bit 1
	beq.w	.0	;branch if 0
	btst	#3,(sflags4).w	;test bit 3
	bne.w	.assstart	;branch if set
	bra.w	.assstart	;95: always. 94 played the slam sound at two frames here; the next 4 lines are dead
	bset	#3,(sflags4).w	;set bit 3
	move.w	#SFXcheck,-(sp)	;SFX
	jsr	(sfx).l
	bra.w	.assstart	;set bit 3
.0
	movem.w	d0-d1,-(sp)
	move.w	(pucky).w,d0	;pucky to d0
	move.w	Ypos(a3),d1	;move Ypos to d1
	eor.w	d1,d0	;XOR d1 to d0
	movem.w	(sp)+,d0-d1
	bmi.w	.assstart	;branch if d0 is negative
	cmpi.w	#0,facedir(a3)	;95: by facedir (94: Xpos within $14): face up for 7, 0, 1, down for 3, 4, 5
	beq.w	.up
	cmpi.w	#1,facedir(a3)
	beq.w	.up
	cmpi.w	#7,facedir(a3)
	beq.w	.up
	cmpi.w	#4,facedir(a3)
	beq.w	.down
	cmpi.w	#5,facedir(a3)
	beq.w	.down
	cmpi.w	#3,facedir(a3)
	bne.w	.assstart
.down
	move.w	#4,facedir(a3)
	bra.w	.slam
.up
	move.w	#0,facedir(a3)
.slam
	bset	#1,(sflags4).w	;set bit 1
	bclr	#3,(sflags4).w	;clear bit 3
	move.w	#$2A82,d1	;95 goalie celebration SPA; $2B38 one time in 10 (94: SPAgslamtop / SPAgslambot by net)
	move.w	d0,-(sp)
	move.w	#$64,d0
	jsr	(randomd0).l
	cmp.w	#$A,d0
	move.w	(sp)+,d0
	blt.w	.1
	move.w	#$2B38,d1
.1
	jsr	(SetSPA).l
	bset	#1,pflags2(a3)	;set anim in progress
.assstart
	btst	#5,pflags(a3)	;check if locked in animation
	bne.w	rtsskate	;exit if so
	bsr.w	check4bench
	bclr	#1,pflags(a3)	;clear new assignment
	beq.w	.nna	;jump if it was cleared already
	clr.w	temp1(a3)	;clear temp1
	move.w	#8,temp2(a3)	;move 8 into temp2
	st	temp4(a3)	;set temp5 (FFFF)
.nna
	cmpi.w	#$34,(a3)	;'4' ; compare 34 hex with Xpos
	bgt.w	.nna2	;branch if greater
	cmpi.w	#$FFCC,(a3)	;compare -34 hex with Xpos
	blt.w	.nna2	;branch if less than
	cmpi.w	#$111,Ypos(a3)	;compare 111 with Ypos (94 $10E)
	bgt.w	.nna2
	cmpi.w	#$FEEF,Ypos(a3)
	blt.w	.nna2
	cmpi.w	#$D5,Ypos(a3)	;94 $D2
	bgt.w	.noskate
	cmpi.w	#$FF2B,Ypos(a3)
	blt.w	.noskate
.nna2
	lea	rtsskate(pc),a0	;goalie will skate back to middle position
	moveq	#4,d0
	tst.w	(a3)	;test Xpos
	bpl.w	.2	;branch if positive
	neg.w	d0
.2
	move.w	#$E7,d1	;94 $E4
	btst	#7,pflags(a3)	;check what goal shooting at
	beq.w	skateto	;branch if bottom
	neg.w	d1
	bra.w	skateto
.noskate
	btst	#1,pflags2(a3)	;check if anim in progress
	bne.w	rtsskate	;exit if so
	btst	#0,(sflags4).w	;check bit 0
	beq.w	.noskate3	;branch if not set (95: the next line either way; 94 set facedir by the alice frame)
.noskate3
	jsr	(GoalieReadySPA).l	;95: ready SPA by the puck distance (94: 2 = SPAgready)
	jsr	(SetSPA).l
	btst	#2,(BA_PS_flags).w	;check bit 2
	bne.w	.noskate4	;branch if set
	btst	#0,(gmode).w	;check if clock
	bne.w	rtsskate	;exit if clock stopped
.noskate4
	tst.w	temp5(a3)	;temp5
	bmi.w	.nofo	;branch if minus
	move.w	SCnum(a3),d0	;move SCnum to d0
	cmp.w	(puckc).w,d0	;check if puckc
	beq.w	.mbfo	;branch if so
	st	temp5(a3)	;set temp5 to FFFF
	bra.w	.nofo
.mbfo
	sub.w	d7,temp5(a3)	;subtract frames from temp5
	bpl.w	.nofo	;branch if positive
	btst	#2,(BA_PS_flags).w	;check if bit 2 set
	beq.w	.mbfo2	;branch if not
	bset	#4,(BA_PS_flags).w	;set bit 4
	bra.w	.nofo
.mbfo2
	move.l	#8,d0	;PenGhold
	jsr	(AddPenalty2).l	;blow whistle for FO
.nofo
	sub.b	d7,temp1(a3)	;sub d7 from temp1
	bpl.w	.nodec	;branch if still positive
	move.b	aidef(a3),d0	;move aidef into d0 (DfA)
	beq.w	.nofo2	;branch if 0
	btst	#6,(sflags7).w	;check if crowd meter broken
	beq.w	.nofo2	;branch if not
	subq.b	#1,d0	;sub from d0
.nofo2
	lsr.b	#2,d0	;divide by 4
	move.b	d0,temp1(a3)	;move d0 into temp1
	btst	#3,pflags(a3)	;check if joy controlled
	beq.w	.nocontrol	;branch if not
	btst	#pf3gctrl,pflags3(a3)	;check bit 2
	bne.w	.nocontrol	;branch if set
	moveq	#$1B,d0	;assignment assgoaliectrl (94 $1D)
	bra.w	assinsert
.nocontrol
	move.w	(pucky).w,d0	;move pucky into d0
	move.w	Ypos(a3),d1	;move Ypos into d1
	eor.w	d0,d1	;XOR
	bpl.w	.3	;branch if positive
	clr.w	d0
	move.w	#$F7,d2	;94 $F4
	btst	#7,pflags(a3)	;check which net shooting at
	beq.w	.de5	;branch if bottom
	neg.w	d2
	bra.w	.de5
.3
	subq.w	#1,temp4(a3)	;sub 1 from temp4
	bpl.w	.4	;branch if positive
	move.w	#$FFFF,temp4(a3)	;move -1 into temp4
.4
	move.w	SCnum(a3),d0	;SCnum into d0
	cmp.w	(puckc).w,d0	;check if puckc
	bne.w	.notpuckc	;branch if not
	tst.w	temp5(a3)	;check temp5
	bpl.w	.5	;branch if positive
	move.w	#$5A,temp5(a3)	;'Z' ; move 5A into temp5
.5
	st	temp4(a3)	;FFFF into temp4
	cmpi.w	#$5A,temp5(a3)	;'Z' ; compare to temp5
	bgt.w	.de1	;branch if greater
	move.w	(VDP_CNTR).l,d0
	andi.w	#3,d0	;pass first 2 bits
	bne.w	.de1	;branch if not 0
	moveq	#5,d0
	movea.w	#(SortCords-M68K_RAM),a0
	btst	#6,pflags(a3)	;check home or away
	bne.w	.opploop	;branch if away
	adda.w	#$300,a0
.opploop
	btst	#2,pflags2(a0)	;check if player unavailable
	bne.w	.opploop2	;branch if so
	move.w	(pucky).w,d1	;pucky into d1
	sub.w	Ypos(a0),d1	;sub Ypos a0 from d1
	cmp.w	#$1C,d1	;compare 1C to difference
	bgt.w	.opploop2	;branch if greater
	cmp.w	#$FFE4,d1	;compare -1C
	blt.w	.opploop2	;branch if less than
	move.w	(puckx).w,d1	;puckx into d1
	sub.w	(a0),d1	;sub Xpos a0 from d1
	cmp.w	#$19,d1	;compare 19 to difference
	bgt.w	.opploop2	;branch if greater
	cmp.w	#$FFE7,d1	;compare -19 to diff
	bgt.w	.de1	;branch if greater
.opploop2
	adda.w	#SCstruct,a0	;move to next struct
	dbf	d0,.opploop
	move.w	#1,(threat).w	;dir of threat on puck handler
	bsr.w	chk4pass
	bra.w	.de1
.notpuckc
	tst.w	temp4(a3)	;check temp4
	bne.w	.de1	;branch if not 0
	tst.w	(puckc).w	;check puckc
	bpl.w	.de1	;branch if there is a puckc
	move.w	(puckx).w,d0
	sub.w	(a3),d0	;sub Xpos
	cmp.w	#$A,d0	;94 $14
	bgt.w	.de1	;branch if greater
	cmp.w	#$FFF6,d0
	blt.w	.de1	;branch if less
	move.w	(pucky).w,d1
	cmp.w	#$10B,d1	;check goalline
	bgt.w	.de1	;branch if past goalline
	cmp.w	#$FEF5,d1	;check other goalline
	blt.w	.de1	;branch if past
	sub.w	Ypos(a3),d1	;sub Ypos from d1
	cmp.w	#$F,d1	;94 $1E
	bgt.w	.de1	;branch if greater
	cmp.w	#$FFF1,d1
	blt.w	.de1	;branch if less
	movem.w	d0-d1,-(sp)
	move.w	(puckvx).w,d0
	bpl.w	.6
	neg.w	d0
.6
	move.w	(puckvy).w,d1
	bpl.w	.7
	neg.w	d1
.7
	add.w	d1,d0	;add puckvx and vy
	cmp.w	#$1000,d0	;compare to 1000
	movem.w	(sp)+,d0-d1
	bgt.w	.de1	;branch if greater
	jsr	(vtoa).l
	move.w	d0,facedir(a3)	;d0 into facedir. Goalie will face puck
	move.b	#8,nopuck(a3)	;move 8 to nopuck collision
	move.w	#$1D4E,d1	;goalie dive anim (94 $2F4)
	jsr	(SetSPA).l	;set animation
	bset	#1,pflags2(a3)	;set anim in progress
	addi.w	#$96,(crowdlevel).w
	rts
.de1
	movea.w	#(puckcross-M68K_RAM),a0	;puckcross = xcord/frames top to bottom for goalies to react to
	move.w	#$107,d3
	btst	#7,pflags(a3)	;check what net shooting at
	beq.w	.8	;branch if bottom
	addq.w	#4,a0
	neg.w	d3
.8
	cmpi.w	#$107,Ypos(a3)
	bgt.w	.9
	cmpi.w	#$FEF9,Ypos(a3)
	bgt.w	.10
.9
	clr.w	d2
	clr.w	d0
	cmpi.w	#$2C,(a3)
	bgt.w	.de5
	cmpi.w	#$FFD4,(a3)
	blt.w	.de5
	move.w	#$98,d0	;94 $88
	tst.w	(a3)
	bpl.w	.de5
	neg.w	d0
	bra.w	.de5
.10
	tst.w	(puckc).w
	bmi.w	.11
	move.w	SCnum(a3),d0
	cmp.w	(puckc).w,d0
	beq.w	.11
	move.l	a0,-(sp)
	movea.l	#SortCords,a0
	move.w	(puckc).w,d0
	asl.w	#7,d0
	adda.w	d0,a0
	move.w	(puckx).w,d0
	sub.w	(a0),d0
	asr.w	#1,d0
	add.w	(a0),d0
	move.w	d0,(TmpPuckX).w
	movea.l	(sp)+,a0
.11
	move.w	(TmpPuckX).w,d0
	move.w	(pucky).w,d1
	bsr.w	ClampYPosition
	jsr	(vtoa).l
	bsr.w	AdjustFacingDirection
	move.w	(gameclock).w,d0
	andi.w	#7,d0
	asl.w	#4,d0
	addi.w	#$A0,d0
	cmpi.w	#$DE,(pucky).w
	bgt.w	.12
	cmpi.w	#$FF22,(pucky).w
	bgt.w	.13
.12
	subi.w	#$40,d0
.13
	move.w	d0,d1
	muls.w	(puckvx).w,d0
	swap	d0
	add.w	(TmpPuckX).w,d0
	muls.w	(puckvy).w,d1
	swap	d1
	add.w	(pucky).w,d1
	bsr.w	ClampYPosition
	movem.w	d0-d1,-(sp)
	muls.w	d0,d0
	muls.w	d1,d1
	add.l	d1,d0
	cmp.l	#$384,d0
	bhi.w	.14
	movem.w	(sp)+,d0-d1
	bra.w	.16
.14
	jsr	(sroot).l
	moveq	#1,d2
	add.w	d0,d2
	moveq	#$12,d4
	btst	#3,(sflags).w
	beq.w	.15
	addq.w	#8,d4
.15
	movem.w	(sp)+,d0-d1
	muls.w	d4,d1
	addq.w	#8,d4
	muls.w	d4,d0
	divs.w	d2,d0
	divs.w	d2,d1
.16
	add.w	d3,d1
	move.w	d1,d2
	btst	#0,(gmode2).w
	bne.w	.18
	btst	#2,(BA_PS_flags).w
	bne.w	.18
	btst	#3,(sflags).w
	bra.w	.18	;95: always (94 beq). The lines to .18 are dead
	cmpi.w	#$D0,(pucky).w
	bgt.w	.17
	cmpi.w	#$FF30,(pucky).w
	blt.w	.17
	bra.w	.18
.17
	cmpi.w	#$14,(a3)
	bgt.w	.18
	cmpi.w	#$FFEC,(a3)
	blt.w	.18
	btst	#3,(gameclock+1).w	;94 bit 1, bne
	beq.w	.18
	bra.w	.19
.18
	cmpi.w	#$22,2(a0)
	bhi.w	.de5
	cmpi.w	#$18,(a0)
	bgt.w	.22
	cmpi.w	#$FFE8,(a0)
	blt.w	.22
	cmpi.w	#$D,2(a0)
	bhi.w	.20
.19
	cmpi.w	#$10B,(pucky).w
	bgt.w	.20
	cmpi.w	#$FEF5,(pucky).w
	blt.w	.20
	bset	#1,pflags2(a3)
	bne.w	.20
	jsr	(goaliesave).l
.20
	move.w	(a0),d0
	cmpi.w	#$FF,(pucky).w
	bgt.w	.21
	cmpi.w	#$FF01,(pucky).w
	bgt.w	.de5
.21
	moveq	#$18,d0
	tst.w	(TmpPuckX).w
	bpl.w	.de5
	neg.w	d0
.de5
	move.w	d2,d1
	movem.w	d0-d1,-(sp)
	move.b	Xvel(a3),d0
	ext.w	d0
	neg.w	d0
	add.w	(sp)+,d0
	sub.w	(a3),d0
	move.b	Yvel(a3),d1
	ext.w	d1
	neg.w	d1
	add.w	(sp)+,d1
	sub.w	Ypos(a3),d1
	cmp.w	#4,d0
	bgt.w	.vt
	cmp.w	#$FFFC,d0
	blt.w	.vt
	cmp.w	#4,d1
	bgt.w	.vt
	cmp.w	#$FFFC,d1
	blt.w	.vt
	clr.w	d0
	clr.w	d1
.vt
	btst	#3,pflags(a3)	;95: half the y step unless joystick controlled
	bne.w	.vt2
	asr.w	#1,d1
.vt2
	jsr	(vtoa).l
	move.b	d0,temp2+1(a3)	;move d0 into temp2+1
.nodec
	move.b	temp2+1(a3),d2	;temp2+1
	ext.w	d2
	cmp.w	#7,d2
	ble.w	.pa
	jmp	(stopna).l	;95 jmp: both are far now (94 bra)
.pa
	jmp	(playeracc).l
.22
	tst.w	(puckc).w
	bpl.s	.de5
	btst	#2,(iflags).w
	bne.w	.de5
	movea.w	#(tmstruct-M68K_RAM),a1
	lea	tmsize(a1),a2
	btst	#6,pflags(a3)
	beq.w	.23
	exg	a1,a2
.23
	cmpi.l	#$1324,$2A(a1)
	blt.w	.de5
	cmpi.l	#$9C4,Yvel(a2)
	blt.w	.de5
	cmpi.w	#$E3,(pucky).w
	bgt.w	.24
	cmpi.w	#$FF1D,(pucky).w
	bgt.w	.de5
.24
	tst.w	(puckvy).w
	btst	#7,pflags(a3)
	beq.w	.25
	eori	#8,ccr
.25
	bmi.w	.de5
	move.w	(puckvx).w,d0
	bpl.w	.26
	neg.w	d0
.26
	move.w	(puckvy).w,d1
	bpl.w	.27
	neg.w	d1
.27
	cmp.w	d0,d1
	blt.w	.de5
	moveq	#$14,d0	;assignment assgoalietopuck (94 $F)
	bra.w	assinsert
ClampYPosition	;d1 = y clamped to +-$106 (94 $103), minus goal line d3. d0 = 0 if a3 has the puck
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
AdjustFacingDirection	;Turn facedir one step toward direction d0. show btst Dn,#imm, so it lost the
	;three btst lines and the.t /.set targets; written from the retail bytes as 93. Also called from goalieacc
	move.w	facedir(a3),d1		;facedir
	sub.w	d1,d0
	beq.w	rtsskate	;94 rtss2
	neg.w	d0
	andi.w	#4,d0
	lsr.w	#1,d0
	subq.w	#1,d0			;d0 = +1/-1
	btst	#3,pflags(a3)		;pfjoycon
	bne.w	.add
	btst	d1,#$42			;facing 1 or 6
	beq.w	.add
	add.w	d0,d1
	btst	#pfgoal,pflags(a3)		;pfgoal
	bne.w	.dn
	btst	d1,#$83			;0, 1 or 7
	bra.w	.t
.dn	btst	d1,#$38	;3, 4 or 5
.t	beq.w	.set
	neg.w	d0
	add.w	d0,d1
.add	add.w	d0,d1
.set	andi.w	#7,d1
	move.w	d1,facedir(a3)		;facedir
	rts
; set save animation for goalie depending on puck location
; a3 = goalie
; a0 = puckcross
; d3 = goalline of goalie
goaliesave	;95 first aims the goalie: Xvel from where the puck crosses his y (puckvx / puckvy), and the
	;save side from that, then picks the save from saveanim as 94; 95 adds the dive saves (a top shelf shot with sflags bit 3) and the
	;stack saves ($2AE4 / $2B0E by side and hand when puckz is 3 or more). Also called from doinput_cbut
	move.w	(a0),d0	;puckcross x frames into d0
	sub.w	(a3),d0	;sub goalie Xpos from d0
	move.w	d3,d1	;move goalline into d1
	sub.w	Ypos(a3),d1	;sub goalie Ypos from d1
	jsr	(vtoa).l
	sub.w	facedir(a3),d0	;sub facedir from d0
	andi.w	#7,d0	;pass first 3 bits of d0
	move.w	d0,d3	;direction to the crossing, for the glove check
	movem.l	d1-d4,-(sp)	;95: frames until the puck reaches the goalie y
	move.w	Ypos(a3),d1
	sub.w	(pucky).w,d1
	ext.l	d1
	tst.w	(puckvy).w
	bne.w	.0
	moveq	#1,d1
	bra.w	.1
.0
	divs.w	(puckvy).w,d1
.1
	move.w	d1,-(sp)	;puck x then, minus goalie Xpos
	move.w	(puckvx).w,d2
	muls.w	d2,d1
	add.w	(puckx).w,d1
	sub.w	(a3),d1
	move.w	(sp)+,d2
	bne.w	.2
	move.w	#1,d2
.2
	move.w	d1,d3
	ext.l	d3
	divs.w	d2,d3
	asl.w	#8,d3
	move.w	d3,Xvel(a3)	;Xvel to get there
	btst	#7,pflags(a3)
	bne.w	.3
	neg.w	d1
.3
	move.w	#0,d0	;save side: 0 or 4 by the side the puck passes
	tst.w	d1
	bpl.w	.4
	move.w	#4,d0
.4
	movem.l	(sp)+,d1-d4
	lsr.w	#2,d0	;divide d0 by 4
	btst	#3,4(a3)
	beq.w	.5
	eori.w	#1,d0
.5
	cmpi.w	#8,(puckz).w	;high shot: shoulder saves
	bgt.w	.6
	cmpi.w	#$800,(puckvz).w
	bgt.w	.6
	bra.w	.8
.6
	movem.l	d0,-(sp)
	move.w	(a3),d0
	sub.w	(a0),d0
	cmp.w	#$10,d0
	bgt.w	.7
	cmp.w	#$FFF0,d0
	blt.w	.7
	movem.l	(sp)+,d0
	addq.w	#6,d0
	bra.w	.18
.7
	movem.l	(sp)+,d0
	bra.w	.18
.8
	addq.w	#4,d0
	cmpi.w	#8,2(a0)	;puckcross frames
	bls.w	.15
	cmpi.w	#2,facedir(a3)
	beq.w	.18
	cmpi.w	#6,facedir(a3)
	beq.w	.18
	tst.w	(puckc).w
	bmi.w	.18
	subq.w	#2,d0
	bsr.w	.9
	bra.w	.18
.9	;pad stack: slide the goalie 6 toward the middle, d0 by net and hand
	move.w	d1,-(sp)
	move.w	#$1000,d1
	move.w	d1,Xvel(a3)
	ori.w	#1,d0
	btst	#7,pflags(a3)
	bne.w	.10
	eori.w	#1,d0
.10
	move.w	#$FFFA,d1
	tst.w	Xvel(a3)
	bmi.w	.11
	neg.w	Xvel(a3)
.11
	tst.w	(a3)
	bpl.w	.13
	tst.w	Xvel(a3)
	bpl.w	.12
	neg.w	Xvel(a3)
.12
	move.w	#6,d1
	eori.w	#1,d0
.13
	add.w	d1,(a3)
	btst	#0,handed(a3)	;check hand of goalie
	beq.w	.14
	eori.w	#1,d0
.14
	move.w	(sp)+,d1
	rts
.15
	movem.l	d0,-(sp)
	move.w	(a3),d0
	sub.w	(a0),d0
	cmp.w	#$10,d0
	ble.w	.16
	movem.l	(sp)+,d0
	bra.w	.17
.16
	cmp.w	#$FFF0,d0
	movem.l	(sp)+,d0
	bgt.w	.18
.17
	addq.w	#4,d0
.18
	add.w	d0,d0
	lea	saveanim(pc),a1
	move.w	(a1,d0.w),d1	;SPA of the save
	cmp.w	#$1CB8,d1
	bne.w	.19
	andi.w	#3,d3
	beq.w	.19
	cmpi.b	#$B,aggress(a3)	;73 = Glove Left
	blt.w	.19	;95 dropped the reach out glove save line; the branch stays
.19
	cmp.w	#$205E,d1	;95: a pad stack facing up or down, with sflags bit 3: dive ($23E8, or $23BE 40 times in 100)
	beq.w	.20
	cmp.w	#$200C,d1
	bne.w	.24
.20
	tst.w	facedir(a3)
	beq.w	.21
	cmpi.w	#4,facedir(a3)
	bne.w	.24
.21
	btst	#3,(sflags).w
	beq.w	.24
	movem.w	d0,-(sp)
	move.w	#$23E8,d1
	move.w	#$64,d0
	jsr	(randomd0).l
	cmp.w	#$3C,d0
	bgt.w	.22
	bra.w	.23
.22
	move.w	#$23BE,d1
	bra.w	.23
	move.w	#2,d0	;dead: never reached
	bsr.w	.9
	add.w	d0,d0
	lea	saveanim(pc),a1
	move.w	0(a1,d0.w),d1
	bra.w	.23
.23
	movem.w	(sp)+,d0
.24
	cmpi.w	#3,(puckz).w	;95: a raised puck facing up or down: stack save $2AE4 / $2B0E by side and hand
	blt.w	.31
	cmpi.w	#0,facedir(a3)
	beq.w	.25
	cmpi.w	#4,facedir(a3)
	bne.w	.31
.25
	btst	#7,pflags(a3)
	beq.w	.29
	movem.w	d0,-(sp)
	move.w	(a3),d0
	sub.w	(a0),d0
	cmp.w	#$12,d0
	bgt.w	.26
	cmp.w	#$FFEE,d0
	bgt.w	.30
	bra.w	.28
.26
	move.w	#$2B0E,d1
	btst	#0,handed(a3)
	beq.w	.27
	move.w	#$2AE4,d1
.27
	bra.w	.30
.28
	move.w	#$2AE4,d1
	btst	#0,handed(a3)
	beq.w	.30
	move.w	#$2B0E,d1
	bra.w	.30
.29
	movem.w	d0,-(sp)
	move.w	(a3),d0
	sub.w	(a0),d0
	cmp.w	#$12,d0
	bgt.s	.28
	cmp.w	#$FFEE,d0
	blt.s	.26
.30
	movem.w	(sp)+,d0
.31
	jsr	(SetSPA).l
	addi.w	#$96,(crowdlevel).w
	addi.w	#$A,(CwdExciteLvl).w
	asr.w	Xvel(a3)
	asr.w	Xvel(a3)
	asr.w	Yvel(a3)
	asr.w	Yvel(a3)
	btst	#3,(sflags).w	;95: no Xvel with sflags bit 3
	beq.w	.32
	clr.w	Xvel(a3)
.32
	rts

saveanim	;94 _saveanim (93 GoalieSaveList): SPA per save type, 95 SPA values (10 words; 94: blocker, glove, pad stack right /
	;left, kick, butterfly, high shoulder right / left, stick right / left)
	dc.w	$1C86,$1CB8,$205E,$200C,$1CEA,$1D1C,$1C86,$1CB8,$1CEA,$1D1C

; assignment to have goalie skate to the puck when it is loose
assgoalietopuck	;asstab entry $14. The same as 94
	btst	#3,pflags(a3)
	bne.w	assexit	;exit if joystick controlled
	btst	#0,(gmode).w
	bne.w	assexit	;exit if clock stopped
	bsr.w	check4bench
	bclr	#1,pflags(a3)	;new assignment
	beq.w	.0
	clr.w	temp1(a3)
.0
	sub.b	d7,temp1(a3)
	bpl.w	.go
	move.b	aidef(a3),d0	;aidef
	beq.w	.1
	btst	#6,(sflags7).w
	beq.w	.1
	subq.b	#1,d0
.1
	lsr.b	#2,d0
	move.b	d0,temp1(a3)
	tst.w	(puckc).w
	bpl.w	assexit
	tst.w	(puckvy).w
	btst	#7,pflags(a3)
	beq.w	.dir
	eori	#8,ccr
.dir
	bmi.w	assexit
	movea.w	#(tmstruct-M68K_RAM),a1	;load home team struct into a1
	lea	tmsize(a1),a2	;load away team struct into a2
	btst	#6,pflags(a3)	;check if player is home or away
	beq.w	.t0	;branch if home
	exg	a1,a2	;swap if away
.t0
	cmpi.l	#$E10,$2A(a1)
	blt.w	assexit
	cmpi.l	#$640,Yvel(a2)
	blt.w	assexit
.go
	bra.w	skatetopuck

;------------------------------------------------------------------------------------------------------------------------
; $0807EC  From assign94.asm: the defense assignments
;	94 assdefd, rtss21 and asswingd (the defense assignments of the defensemen and the wingers).
;the whole range as dc.b (saveanim runs to $081335); it is code here, read from the retail bytes.
;	95 changes: assdefd also checks for a puck carrier of the other team before the timer (assdefo, now asstab $C), halves aidef for the
;	timer, and with the team defense mode (HmDefMode / AwDefMode) at 1 leaves for assdefdchase when the other team has the puck; asswingd
;	then covers the carrier with its own 95 code (.cover). Some y limits move by 2 or 3 ($58 to $56, $9E to $9C, $108 to $10B ...); the
;	comments give the 94 values.

; player a3 is defensive player on defense
assdefd	;asstab entry 7
	btst	#5,pflags(a3)	;check if locked in animiation
	bne.w	rtss21	;exit if so (94 rtss6)
	btst	#0,(gmode).w	;check if clock running
	bne.w	donothing	;assnothing if no clock
	bsr.w	check4bench	;check if going to bench
	btst	#3,pflags(a3)	;check if joystick controlled
	bne.w	rtss21	;exit if so
	bclr	#1,pflags(a3)	;clear new assignment bit
	beq.w	.nna	;branch if no new assignment
	clr.w	temp1(a3)	;clear temp1
	move.w	#8,temp2(a3)	;move 8 into temp2
.nna
	move.w	(puckc).w,d1	;95: the other team's carrier check, every frame
	bmi.w	.t
	bsr.w	chkpk	;check if theres a PK
	beq.w	.t	;branch if on PK
	moveq	#$C,d0	;assdefo into d0 (94 1)
	subq.w	#6,d1	;sub 6 from d1
	move.w	SCnum(a3),d2	;move SCnum into d2
	subq.w	#6,d2	;sub 6 from d2
	eor.w	d2,d1	;EOR d2 and d1
	bpl.w	assreplace	;assreplace if puckc on same team
.t
	sub.b	d7,temp1(a3)	;sub frames elapsed from temp1
	bpl.w	.nodec	;branch if not 0
	clr.w	d1
	move.b	aidef(a3),d1	;DfA / 2 into temp1 (94 DfA)
	asr.w	#1,d1
	move.b	d1,temp1(a3)
	btst	#6,(sflags7).w	;check if crowd meter currently broken
	beq.w	.noboost	;branch if not
	tst.b	temp1(a3)	;check if temp1 is 0
	beq.w	.noboost	;branch if so
	subq.b	#1,temp1(a3)	;sub 1 from temp1
.noboost
	move.w	(pucky).w,d1	;move pucky into d1
	move.w	(puckvy).w,d3	;move puckvy into d3
	asr.w	#6,d3	;divide by 64
	btst	#7,pflags(a3)	;check which net shooting on
	bne.w	.de00	;branch if top
	neg.w	d1	;negate d1 and d3 if bottom
	neg.w	d3
.de00
	tst.w	d3	;check if d3 is zero
	bpl.w	.de000	;branch if positive
	clr.w	d3	;clear d3
.de000
	add.w	d1,d3	;add d1 to d3
	cmp.w	#$56,d3	;compare top blueline to d3 (94 $58)
	blt.w	.de0
	btst	#4,tmflags(a2)	;check if team is offsides
	bne.w	.de0	;branch if offsides
	move.w	(puckc).w,d1	;move puckc into d1
	bmi.w	.de0	;branch if no puckc
	bsr.w	chkpk	;check if theres a PK
	beq.w	.de0	;branch if on PK
	moveq	#$C,d0	;assdefo into d0 (94 1)
	subq.w	#6,d1	;sub 6 from d1
	move.w	SCnum(a3),d2	;move SCnum into d2
	subq.w	#6,d2	;sub 6 from d2
	eor.w	d2,d1	;EOR d2 and d1
	bpl.w	assreplace	;assreplace if puckc on same team
.de0
	move.w	(puckc).w,d1	;95: the other team has the puck and the team defense mode is 1: assdefdchase
	bmi.w	assdefdchase
	move.w	SCnum(a3),d2
	subq.w	#6,d1
	subq.w	#6,d2
	eor.w	d1,d2
	bpl.w	.de01	;branch if puckc on same team
	move.w	(HmDefMode).w,d0
	cmpa.l	#tmstruct,a2
	beq.w	.de02
	move.w	(AwDefMode).w,d0
.de02
	cmp.w	#1,d0
	beq.w	assdefdchase
.de01
	bclr	#7,pflags3(a3)	;95: assdefdchase sets it
	move.w	#$41,temp3(a3)	;'A' ; move 65 dec into temp3
	cmpi.w	#2,position(a3)	;compare if player is RD
	beq.w	.de1	;branch if RD
	neg.w	temp3(a3)	;negate temp3 if LD
.de1
	movea.w	#(SortCords-M68K_RAM),a0	;move SC struct start into a0
	cmpi.w	#6,SCnum(a3)	;compare 6 with player SCnum
	bge.w	.de2	;branch if away team
	adda.w	#6*SCstruct,a0	;add 300 to a0 (start at away SC Struct)
.de2
	moveq	#5,d2	;move 5 into d2
	move.w	#$FC18,d0	;move -1000 dec into d0
	btst	#7,pflags(a3)	;check what net shooting at
	beq.w	.gdwn	;branch if bottom net
	neg.w	d0	;negate d0
.gup
	btst	#2,pflags2(a0)	;check if a0 player unavailable
	bne.w	.gu0	;branch if so
	tst.w	position(a0)	;check a0 position
	bmi.w	.gu0	;branch if empty position
	move.w	Yvel(a0),d1	;move Yvel of a0 into d1
	bmi.w	.gu2	;branch if Yvel was negative
	clr.w	d1	;clear d1
.gu2
	asr.w	#4,d1	;divide d1 by 16
	add.w	Ypos(a0),d1	;add Ypos of a0 player to d1
	cmp.w	d0,d1	;compare d0 to d1
	bgt.w	.gu0	;branch if d1 is greater
	move.w	d1,d0	;move d1 into d0
.gu0
	adda.w	#SCstruct,a0	;add 80 (offset to next player struct) to a0
	dbf	d2,.gup	;loop
	subi.w	#$32,d0	;'2'   ; sub $32 (50 dec) from d0
	cmp.w	#$FF42,d0	;compare to $FF42 (-190 dec)
	bgt.w	.gu1	;branch if greater than
	move.w	#$FF24,d0	;move -220 dec into d0
.gu1
	move.w	d0,temp4(a3)	;move d0 into temp4
	move.w	(puckx).w,d0	;move puckx into d0
	move.w	temp3(a3),d1	;move temp3 into d1
	eor.w	d0,d1	;EOR d0 and d1
	bpl.w	.nodec	;branch if puck on same side
	clr.w	temp3(a3)	;clear temp3 if not
	bra.w	.nodec
.gdwn
	btst	#2,pflags2(a0)	;check if player a0 unavail
	bne.w	.gd0	;branch if so
	tst.w	position(a0)	;check a0 position
	bmi.w	.gd0	;branch if empty (goalie)
	move.w	Yvel(a0),d1	;move Yvel of a0 into d1
	bpl.w	.gd2	;branch if positive
	clr.w	d1	;clear d1
.gd2
	asr.w	#4,d1	;divide d1 by 16
	add.w	Ypos(a0),d1	;add Ypos of a0 to d1
	cmp.w	d0,d1	;compare d0 to d1
	blt.w	.gd0	;branch if less than d0
	move.w	d1,d0	;move d1 into d0
.gd0
	adda.w	#SCstruct,a0	;add offset to next player struct
	dbf	d2,.gdwn	;loop
	addi.w	#$32,d0	;'2'   ; add 32 to d0
	cmp.w	#$BE,d0	;compare 190 dec to d0
	blt.w	.gd1	;branch if d0 less than
	move.w	#$DC,d0	;move 220 dec into d0
.gd1
	move.w	d0,temp4(a3)	;move d0 into temp4
	neg.w	temp3(a3)	;negate temp3
	move.w	(puckx).w,d0	;move puckx into d0
	move.w	temp3(a3),d1	;move temp3 into d1
	eor.w	d0,d1	;EOR d0 and d1
	bpl.w	.nodec	;branch if puck on same side
	clr.w	temp3(a3)	;clear temp3 if not
.nodec
	move.w	temp3(a3),d0	;move temp3 to d0
	move.w	temp4(a3),d1	;move temp4 to d1
	movea.l	#EvadePC,a0	;EvadePC to a0
	bsr.w	skateto
	bra.w	check4check
rtss21	;Shared rts of assdefd and asswingd
	rts

; player a3 is winger on defense
asswingd	;asstab entry 8
	btst	#5,pflags(a3)	;check if locked in animation
	bne.s	rtss21	;exit if so
	btst	#0,(gmode).w	;check if clock is running
	bne.w	donothing	;assnothing if its stopped
	bsr.w	check4bench	;check if going to bench
	btst	#3,pflags(a3)	;check if joystick controlled
	bne.s	rtss21	;exit if so
	bclr	#1,pflags(a3)	;clear new assignment bit
	beq.w	.nna	;branch if cleared already (no new assignment)
	clr.w	temp1(a3)	;clear temp1
	move.w	#8,temp2(a3)	;move 8 into temp2
.nna
	sub.b	d7,temp1(a3)	;sub frames elapsed from temp1
	bpl.w	.nodec	;branch if not 0
	move.b	aidef(a3),temp1(a3)	;move DfA into temp1
	btst	#6,(sflags7).w	;check if crowd meter currently broken
	beq.w	.noboost	;branch if not
	tst.b	temp1(a3)	;check if temp1 is 0
	beq.w	.noboost	;branch if 0
	subq.b	#1,temp1(a3)	;sub 1 from temp1
.noboost
	move.w	(puckc).w,d1	;move puckc into d1
	bmi.w	.nodec	;branch if no puck carrier
	moveq	#9,d0	;asswingo into d0 (94 4)
	subq.w	#6,d1	;sub 6 from d1
	move.w	SCnum(a3),d2	;move SCnum into d2
	subq.w	#6,d2	;sub 6 from d2
	eor.w	d2,d1	;EOR d2 with d1. Checks if player on same team
	bpl.w	assreplace	;branch if team has puck
.nodec
	tst.w	(puckc).w	;95: with a carrier and the team defense mode at 1: .cover
	bmi.w	.2
	move.w	(HmDefMode).w,d0
	cmpa.l	#tmstruct,a2
	beq.w	.3
	move.w	(AwDefMode).w,d0
.3
	cmp.w	#1,d0
	beq.w	.cover
.2
	moveq	#$64,d0	;'d'   ; move 64 (100 dec) into d0
	cmpi.w	#5,position(a3)	;check if player is RW
	bne.w	.1	;branch if not
	neg.w	d0	;make d0 negative
.1
	move.l	#$9C,d1	;move $9C into d1 (94 $9E)
	btst	#7,pflags(a3)	;check which goal shooting at
	beq.w	.0	;branch if bottom goal
	neg.w	d0	;negate d0
	neg.w	d1	;negate d1
	moveq	#-$4C,d2	;slightly above bottom blue line (94 -$4E)
	btst	#4,tmflags(a2)	;check bit 4 of offset 30 (currently offside)
	bne.w	.dg11	;branch if set
	cmp.w	(pucky).w,d2	;compare pucky to d2
	bgt.w	.ug1	;branch if puck in defensive zone
	move.w	(pucky).w,d1	;move pucky into d1
	bra.w	.z1
.ug1
	move.w	#$FEF5,d2	;move bottom goal line into d2 (94 $FEF8)
	cmp.w	(pucky).w,d2	;compare pucky to d2
	blt.w	.z1	;branch if puck in defensive zone
	move.w	d2,d1	;move d2 into d1 if puck behind goal line
	bra.w	.z1
.0
	moveq	#$4C,d2	;slightly below top blue line (94 $4E)
	btst	#4,tmflags(a2)	;check bit 4 of offset 30
	bne.w	.dg11	;branch if set
	cmp.w	(pucky).w,d2	;compare pucky to d2
	blt.w	.dg1	;branch if puck in defensive zone
	move.w	(pucky).w,d1	;move pucky into d1
	bra.w	.z1
.dg1
	move.w	#$10B,d2	;move top goal line into d2 (94 $108)
	cmp.w	(pucky).w,d2	;compare pucky to d2
	bgt.w	.z1	;branch if puck in between goal line and blue line
.dg11
	move.w	d2,d1	;move d2 into d1 if puck behind goal line
.z1
	lea	rtss21(pc),a0
	move.w	(puckx).w,d2	;move puckx into d2
	eor.w	d0,d2	;EOR d0 and d2
	bmi.w	skateto	;branch if minus - skate to d0/d1, no extra routine
	move.w	(puckx).w,d0	;move puckx into d0
	bra.w	skateto	;skate to d0/d1 no extra routine
.cover	;The right wing takes the carrier when the puck is on his side (x past $16 / -$16), else holds near the far post side
	;($64, -$B2 / -$64, $B2); the left wing the same mirrored. Checks (check4check) when the target is not puckx
	cmpi.w	#5,position(a3)	;check if player is RW
	bne.w	.lw
	btst	#7,pflags(a3)	;check which goal shooting at
	beq.w	.rwdn
	move.w	(puckx).w,d1
	cmp.w	#$16,d1
	bgt.w	.carrier
	move.w	#$FF4E,d1
	move.w	#$64,d0
	bra.w	.go
.carrier	;skate at the carrier: puckx, and pucky (or $64 toward his goal from it when the carrier is the goalie)
	move.w	(puckc).w,d0
	asl.w	#7,d0
	movea.l	#SortCords,a0
	adda.w	d0,a0
	tst.w	position(a0)
	bne.w	.c2	;branch if not the goalie
	move.w	(pucky).w,d1
	tst.w	d1
	bmi.w	.c1
	subi.w	#$64,d1
	bra.w	.c3
.c1
	addi.w	#$64,d1
	bra.w	.c3
.c2
	move.w	(pucky).w,d1
.c3
	move.w	(puckx).w,d0
	bra.w	.go
.rwdn
	move.w	(puckx).w,d1
	cmp.w	#$FFEA,d1
	blt.s	.carrier
	move.w	#$B2,d1
	move.w	#$FF9C,d0
	bra.w	.go
.go
	lea	rtss21(pc),a0
	move.w	d0,-(sp)
	bsr.w	skateto
	move.w	(sp)+,d0
	cmp.w	(puckx).w,d0
	beq.w	.x	;no check when skating at the carrier
	bsr.w	check4check
.x
	rts
.lw
	btst	#7,pflags(a3)	;check which goal shooting at
	beq.w	.lwdn
	move.w	(puckx).w,d1
	cmp.w	#$FFEA,d1
	blt.s	.carrier
	move.w	#$FF6E,d1
	move.w	#$FF9C,d0
	bra.s	.go
.lwdn
	move.w	(puckx).w,d1
	cmp.w	#$16,d1
	bgt.w	.carrier
	move.w	#$92,d1
	move.w	#$64,d0
	bra.s	.go

;------------------------------------------------------------------------------------------------------------------------
; $080BEA  From checks94.asm: offense assignments, puck handling, skateto
;	94 asswingo, asscenterd, asscentero, assdefo and assnothing (moved in), pucknorm, puckunflip, puckflip
;	puckshadow, findpc, a2touchpuck, Setplass (moved in), assexit / assinsert / assreplace, EvadePC, skateto
;	check4check (and the 95 check4check2), asspassrec / SkateToTempTarget, assbreakaway, assnearest, skatetopuckinit, skatetopuck,
;	avdgoal, breakaway / BreakawayOffsidesFlagSet, chkpuckc, asspuckc, chk4shot, chk4pass, then check4bench (moved in).
;nearly the whole range as dc.b (saveanim to $81335, $8158E-$81A5B, $81A5E-$82E87); it is code here, read from the retail
;bytes with the 94 source as the guide. puckflip, Setplass, assexit / assinsert / assreplace.
;	95 changes, besides the moves: the 95 asstab numbers (assreplace / assinsert d0, .alist, the asslist compares; the comments give the
;	94 number), jsr / jmp .l to the routines 95 moved out of range, the y limits moved 2 or 3 out (blue line $58 to $56, goal line $108
;	to $10B; the comments give the 94 values), the team defense mode code (HmDefMode / AwDefMode: asscenterd .cover), Practice Mode
;	(sflags9 bit 7) shortcuts, the 95 checking start for joystick players (check4check), and the shared rts labels rtss6 / rtsskate /
;	rtsskateto in place of rtss2.

asswingo	;asstab entry 9. Winger on offense: a random spot in the puck zone (.dedata). 95: a new spot each time with sflags2 bit 7, and then y at most $4C, else $1E further up
	btst	#pfalock,pflags(a3)	;check if locked in animation
	bne.w	rtss21	;exit if so
	btst	#gmclock,(gmode).w	;check game clock
	bne.w	donothing	;assnothing if stopped
	bsr.w	check4bench	;check if player going to bench
	btst	#pfjoycon,pflags(a3)	;check if joystick controlled
	bne.w	rtss21	;exit if so
	bclr	#pfna,pflags(a3)	;clear new assignment bit
	beq.w	.nna	;branch if it was already cleared
	st	temp5(a3)	;set old zone # (temp5)
	clr.w	temp1(a3)	;clear temp1
	move.w	#8,temp2(a3)	;move 8 into temp2
.nna
	sub.b	d7,temp1(a3)	;subtract frames elapsed from temp1
	bpl.w	.nodec	;branch if positive
	move.b	aidef(a3),temp1(a3)	;move DfA into temp1
	btst	#6,(sflags7).w	;check if crowd meter currently broken
	beq.w	.noboost
	tst.b	temp1(a3)	;check if temp1 is 0
	beq.w	.noboost
	subq.b	#1,temp1(a3)	;subtract 1 from temp1
.noboost
	moveq	#8,d0	;asswingd (94 3)
	move.w	(puckc).w,d1	;move puckc SCnum into d1
	bmi.w	.de0	;branch if no puckc
	subq.w	#6,d1	;sub 6 from d1
	move.w	SCnum(a3),d2	;move SCnum into d2
	subq.w	#6,d2	;sub 6 from d2
	eor.w	d2,d1	;EOR d2 with d1. Checks if puckc on same team
	bmi.w	assreplace	;if not, branch to assreplace
.de0
	move.w	(pucky).w,d0	;pucky into d0
	move.w	(puckvy).w,d3	;puckvy into d3
	asr.w	#6,d3	;divide d3 by 64
	add.w	d0,d3	;add d0 to d3
	btst	#pfgoal,pflags(a3)	;check which goal shooting on
	bne.w	.de1	;branch if top goal
	neg.w	d0	;negate d0
	neg.w	d3	;negate d3
.de1
	clr.w	d2	;clear zone number
	cmp.w	#$FFAA,d3	;compare bottom blue line with d3 (94 $FFA8)
	blt.w	.de2	;branch if in defensive zone
	addq.w	#8,d2	;add 8 to d2 (d2 = 8)
	cmp.w	#$56,d0	;compare top blue line with d0 (94 $58)
	blt.w	.de2	;branch if in neutral zone
	btst	#4,tmflags(a2)	;check bit 4 of offset 30 (currently offside)
	;(C6FE Home, CA62 Away)
	bne.w	.de2	;branch if set
	addq.w	#8,d2	;add 8 to d2 (d2 = $10)
	cmp.w	#$10B,d3	;compare top goal line with d3 (94 $108)
	blt.w	.de2	;branch if in offensive zone
	addq.w	#8,d2	;add 8 to d2 (d2 = $18)
.de2
	cmp.w	temp5(a3),d2	;compare temp5 with d2
	bne.w	.de3	;branch if different zone
	btst	#7,(sflags2).w	;95: a new spot every time with sflags2 bit 7
	bne.w	.de3	;branch if different zone
	move.w	(VDP_CNTR).l,d0	;move frame counter into d0
	andi.w	#$7F,d0	;pass first 7 bits
	bne.w	.nodec	;branch if not equal to 0 - this allows random movement in zone while waiting
.de3
	move.w	d2,temp5(a3)	;move d2 into temp5
	lea	.dedata(pc),a0	;move zonedata address into a0
	move.w	2(a0,d2.w),d0	;move X Coord into d0
	jsr	(randomd0s).l	;RNG d0
	add.w	0(a0,d2.w),d0	;add X Coord offset to d0
	move.w	d0,temp3(a3)	;move d0 into temp3
	move.w	6(a0,d2.w),d0	;move Y Coord into d0
	jsr	(randomd0s).l	;RNG d0
	add.w	4(a0,d2.w),d0	;add Y Coord offset into d0
	btst	#7,(sflags2).w	;95: with sflags2 bit 7 at most $4C, else $1E further up
	beq.w	.de4
	cmp.w	#$4C,d0
	blt.w	.de4
	move.w	#$4C,d0
.de4
	btst	#7,(sflags2).w
	bne.w	.de5
	addi.w	#$1E,d0
.de5
	move.w	d0,temp4(a3)	;move d0 into temp4
	bra.w	.nodec
.dedata
	dc.w	$50	;Skating zones:
	;Defensive zone
	dc.w	$14
	dc.w	$FFBA
	dc.w	$A
	dc.w	$64	;neutral zone
	dc.w	$14
	dc.w	$38	;94 $3A
	dc.w	5
	dc.w	$50	;offensive zone (94 $3C)
	dc.w	$32
	dc.w	$CD	;94 $E6
	dc.w	$14
	dc.w	$50	;past goalline
	dc.w	$1E
	dc.w	$FA
	dc.w	$14
.nodec
	move.w	temp3(a3),d0	;move temp3 into d0
	cmpi.w	#5,position(a3)	;compare 5 (RW) to position
	beq.w	.1	;branch if RW
	neg.w	d0	;negate d0
.1
	move.w	temp4(a3),d1	;move temp4 into d1
	btst	#7,pflags(a3)	;check if shooting up or down
	bne.w	.0	;branch if shooting up
	neg.w	d0	;negate d0
	neg.w	d1	;negate d1
.0
	lea	EvadePC(pc),a0	;add EvadePC as aux routine
	bra.w	skateto	;skate to d0/d1 position
rtss11	;Shared rts of asswingo / asscenterd
	rts
; player a3 is center on defense
; d7 = elapsed frames

asscenterd	;asstab entry $A. Center on defense. 95: with the team defense mode at 1 and a carrier, .cover
	btst	#5,pflags(a3)	;pfalock - locked animation
	bne.s	rtss11	;exit if locked
	btst	#0,(gmode).w	;gmclock - check if clock is running
	bne.w	donothing	;exit if stoppage
	bsr.w	check4bench
	btst	#3,pflags(a3)	;pfjoycon - check if joystick controlled
	bne.s	rtss11	;exit if joystick controlled
	bclr	#1,pflags(a3)	;pfna - new assignment
	beq.w	.nna	;branch if no new assignment
	clr.w	temp1(a3)	;clear temp1
	move.w	#8,temp2(a3)	;move 8 into temp2
.nna
	sub.b	d7,temp1(a3)	;subtract d7 from temp1
	bpl.w	.nodec
	move.b	aidef(a3),temp1(a3)	;move aidef into temp1
	btst	#6,(sflags7).w	;check for crowd record flag
	beq.w	.puckcarrier	;jump if not set
	tst.b	temp1(a3)	;check if 0
	beq.w	.puckcarrier
	subq.b	#1,temp1(a3)	;subtract 1 from temp1
.puckcarrier
	move.w	(puckc).w,d1	;move puck carrier SCnum into d1
	bmi.w	.nodec
	moveq	#$B,d0	;asscentero (94 6)
	subq.w	#6,d1	;subtract 6 from d1
	move.w	SCnum(a3),d2	;move player's SCnum into d2
	subq.w	#6,d2	;subtract 6 from d2
	eor.w	d2,d1	;compare d2 and d1
	bpl.w	assreplace	;if team has puck, replace assignment with acentero
.nodec
	tst.w	(puckc).w	;95: with a carrier and the team defense mode at 1: .cover
	bmi.w	.2
	move.w	(HmDefMode).w,d0
	cmpa.l	#tmstruct,a2
	beq.w	.3
	move.w	(AwDefMode).w,d0
.3
	cmp.w	#1,d0
	beq.w	.cover
.2
	move.w	(puckx).w,d0	;Xpos of puck
	asr.w	#1,d0	;divide by 2
	move.w	(pucky).w,d2	;Ypos of puck
	btst	#7,pflags(a3)	;pfgoal - check which net to shoot on
	bne.w	.1	;branch if top net
	neg.w	d2	;negate d2 if shooting on bottom net
.1
	moveq	#-$7E,d1	;own high slot (94 -$80)
	cmp.w	#$FFAA,d2	;own blue line (94 $FFA8)
	blt.w	.chkgoal	;branch if puck in defensive zone
	add.w	(pucky).w,d1	;add pucky position to d1
	asr.w	#1,d1	;divide by 2
.chkgoal
	btst	#7,pflags(a3)	;pfgoal - check which net to shoot at
	bne.w	.z1	;branch if top net
	neg.w	d1	;shooting at bottom net
.z1
	lea	rtss11(pc),a0	;no extra collision routine
	bra.w	skateto	;d0/d1 - x/y coord for skating to
.cover	;Puck in the defensive zone ($56 from the blue line): within $47 of the middle, skate at the puck y in the slot (x 0) and
	;check (check4check), else skate at the puck; y kept off the goal (.clamp). Puck further out: hold the slot at y $B0 at most
	move.w	#$56,d0
	add.w	(pucky).w,d0
	btst	#7,pflags(a3)
	bne.w	.c1
	move.w	#$56,d0
	sub.w	(pucky).w,d0
.c1
	tst.w	d0
	bmi.w	.c4
	move.w	(puckx).w,d0
	bpl.w	.c2
	neg.w	d0
.c2
	cmp.w	#$47,d0
	blt.w	.c3
	move.w	(pucky).w,d1
	bsr.w	.clamp
	move.w	#0,d0
	lea	rtss21(pc),a0
	jsr	(skateto).l
	bra.w	check4check
.c3
	move.w	(puckx).w,d0
	move.w	(pucky).w,d1
	bsr.w	.clamp
	lea	rtss21(pc),a0
	jmp	(skateto).l
.c4
	clr.w	d0
	move.w	(pucky).w,d1
	cmp.w	#$B0,d1
	blt.w	.c5
	move.w	#$B0,d1
.c5
	btst	#7,pflags(a3)
	beq.w	.c6
	clr.w	d0
	move.w	(pucky).w,d1
	cmp.w	#$FF50,d1
	bgt.w	.c6
	move.w	#$FF50,d1
.c6
	lea	rtss21(pc),a0
	bsr.w	skateto
	bra.w	check4check
.clamp	;d1 at most $65 from the own goal line side: -$65 / $65 by net
	btst	#7,pflags(a3)
	bne.w	.cl1
	cmp.w	#$FF9B,d1
	bgt.w	.cl2
	move.w	#$FF9B,d1
	bra.w	.cl2
.cl1
	cmp.w	#$65,d1
	blt.w	.cl2
	move.w	#$65,d1
.cl2
	rts

asscentero	;asstab entry $B. Center on offense: a random spot in the puck zone
	btst	#5,pflags(a3)	;pfalock
	bne.w	rtss11	;exit if anim locked
	btst	#0,(gmode).w	;#gmclock
	bne.w	donothing	;do nothing
	bsr.w	check4bench
	btst	#3,pflags(a3)	;pfjoycon - check if joystick controlled
	bne.w	rtss11	;exit if controlled
	bclr	#1,pflags(a3)	;clear pfna
	beq.w	.nna
	st	temp5(a3)	;old zone number - temp5
	clr.w	temp1(a3)	;clear temp1
	move.w	#8,temp2(a3)	;move 8 into temp2
.nna
	sub.b	d7,temp1(a3)	;subtract d7 from temp1 (d7 = elapsed frames)
	bpl.w	.nodec	;branch if temp1 not zero or neg
	move.b	aidef(a3),temp1(a3)	;move aidef into temp1
	btst	#6,(sflags7).w	;check if crowd record broken
	beq.w	.noboost
	tst.b	temp1(a3)	;check if temp1 is 0
	beq.w	.noboost
	subq.b	#1,temp1(a3)	;sub 1 from temp1
.noboost
	move.w	(puckc).w,d1	;move puck carrier SCnum into d1
	bmi.w	.de0
	moveq	#$A,d0	;asscenterd (94 5)
	subq.w	#6,d1
	move.w	SCnum(a3),d2	;move SCnum into d2
	subq.w	#6,d2
	eor.w	d2,d1	;checks to see if puck carrier is on team
	bmi.w	assreplace	;if not switch to acenterd
.de0
	move.w	(pucky).w,d0	;pucky in d0
	btst	#7,pflags(a3)	;#pfgoal - check what goal shooting on
	bne.w	.de1	;branch if top
	neg.w	d0	;negate if bottom net
.de1
	clr.w	d2	;d2 = zone number
	cmp.w	#$FFAA,d0	;check if own blue line (94 $FFA8)
	blt.w	.de2	;branch if in def zone
	addq.w	#8,d2	;set zone to 8
	cmp.w	#$56,d0	;check opponents blue line (94 $58)
	blt.w	.de2	;branch if in neutral zone
	btst	#4,tmflags(a2)	;Checks if currently offside
	;C6FE - Home
	;CA62 - Away
	bne.w	.de2	;branch if offside
	addq.w	#8,d2
	cmp.w	#$10B,d0	;check opponents goal line (94 $108)
	blt.w	.de2	;branch if in offensive zone
	addq.w	#8,d2	;add if past goal line
.de2
	cmp.w	temp5(a3),d2	;compare temp5 to d2
	bne.w	.de3
	move.w	(VDP_CNTR).l,d0	;move frame counter into d0.
	;This allows a chance for random movement in zone when waiting
	andi.w	#$7F,d0	;pass bottom 7 bits
	bne.w	.nodec
.de3
	move.w	d2,temp5(a3)	;move zone into temp5
	lea	.dedata(pc),a0
	move.w	2(a0,d2.w),d0	;move zone into d0
	jsr	(randomd0s).l	;randomize d0
	add.w	0(a0,d2.w),d0	;add to d0
	move.w	d0,temp3(a3)	;move into temp3 (X coord)
	move.w	6(a0,d2.w),d0	;move into d0
	jsr	(randomd0s).l	;randomize d0
	add.w	4(a0,d2.w),d0	;add into d0
	move.w	d0,temp4(a3)	;move into temp4 (Y coord)
	bra.w	.nodec
.dedata
	dc.w	0	;Skating Zones
	;puck location = defensive zone
	dc.w	$3C
	dc.w	$FFBA
	dc.w	$A
	dc.w	0	;neutral zone
	dc.w	$3C
	dc.w	$3C
	dc.w	$A
	dc.w	0	;offensive zone
	dc.w	$28
	dc.w	$AA
	dc.w	$1E
	dc.w	0	;below offensive goal line
	dc.w	$50
	dc.w	$AA
	dc.w	$14
.nodec
	move.w	temp3(a3),d0	;move temp3 into d0 (x coord to skate to)
	move.w	temp4(a3),d1	;move temp4 into d1 (y coord to skate to)
	btst	#7,pflags(a3)	;pfgoal
	bne.w	.0	;branch if top
	neg.w	d1	;negate if bottom
.0
	lea	EvadePC(pc),a0
	bra.w	skateto
; joypad controlled goalie control
; a3 = goalie

assdefo	;asstab entry $C. assdefo (moved in). Defenseman on offense. 95: back to assdefd at once when the other team has the puck (or nobody), no blue line test; holds no deeper than the other forwards (.lim), and at -$C0 when the other goalie has the puck (PuckcIsGoalie)
	bclr	#7,pflags3(a3)	;95: assdefdchase sets it
	btst	#5,pflags(a3)
	bne.w	rtsskate
	btst	#0,(gmode).w	;#gmclock
	bne.w	donothing	;Whistle blown, do nothing
	bsr.w	check4bench	;check if player should go to bench
	btst	#3,pflags(a3)	;#pfjoycon - is player joystick controlled
	bne.w	rtsskate	;yes, then exit
	bclr	#1,pflags(a3)	;#pfna - checks if theres a new assignment
	beq.w	.nna
	clr.w	temp1(a3)	;clears temp1 if new assignment
	move.w	#8,temp2(a3)	;moves 8 into temp2 if new assignment
.nna
	move.w	#7,d0	;95: back to assdefd (94 2) when the other team has the puck, or nobody
	move.w	(puckc).w,d1
	bmi.w	.ass
	subq.w	#6,d1
	move.w	SCnum(a3),d2
	subq.w	#6,d2
	eor.w	d2,d1
.ass
	bmi.w	assreplace
	sub.b	d7,temp1(a3)	;subtract frames elapsed since last call from temp1
	bpl.w	.nodec	;temp1 not zero or negative
	move.b	aioff(a3),temp1(a3)	;Loads aioff into temp1
	jsr	(ReadGoaliePulled).l
	bmi.w	.boost	;branch if goalie is pulled
	btst	#6,(sflags7).w	;check if crowd meter broken
	beq.w	.noboost	;branch if not
	tst.b	temp1(a3)	;check if temp1 is 0
	beq.w	.noboost	;branch if so
.boost
	subq.b	#1,temp1(a3)	;sub 1 from temp1
.noboost
	moveq	#7,d0	;assdefd (94 2)
	btst	#4,tmflags(a2)	;check if team is offsides
	bne.w	assreplace	;if so, assreplace (assdefd)
	move.w	(pucky).w,d1	;move pucky into d1
	btst	#7,pflags(a3)	;#pfgoal - check which net to score on
	bne.w	.de1	;branch if top
	neg.w	d1	;Negates d1- shooting on bottom net
.de1
	move.w	(puckc).w,d1	;puck carrier (SCnum) into d1
	bmi.w	.nodec	;branch if no puckc
	subq.w	#6,d1	;sub 6 from d1
	move.w	SCnum(a3),d2	;move SCnum into d2
	subq.w	#6,d2	;sub 6 from d2
	eor.w	d2,d1	;EOR d2 with d1
	bmi.w	assreplace	;ass replace if puckc not on same team
.nodec
	lea	EvadePC(pc),a0	;EvadePC, extra collision routine for skateto
	move.w	#$50,d0	;move 80 dec into d0
	cmpi.w	#2,position(a3)	;position(a3) - checks that player is RD
	beq.w	.1	;branch if RD
	neg.w	d0	;player is LD, so negates d0
.1
	move.w	#$74,d1	;inside of blueline (94 $62)
	btst	#7,pflags(a3)	;#pfgoal
	bne.w	.0	;branch if top net shooting
	neg.w	d0	;shooting on bottom net, so negate d0 and d1
	neg.w	d1
.0
	move.w	(puckx).w,d2	;move puckx into d2
	eor.w	d0,d2	;XOR d0 with d2
	bmi.w	.2	;branch if puck on the other side of X center
	move.w	(puckx).w,d0	;move puckx to d0
	bsr.w	.lim
	bsr.w	PuckcIsGoalie	;95: y -$C0 (by net) when the other goalie has the puck
	bne.w	.3
	move.w	#$FF40,d1
	btst	#7,pflags(a3)
	bne.w	.3
	neg.w	d1
.3
	jmp	(skateto).l	;d0/d1 are x/y positions, a0 is extra collision routine
.2
	move.w	(puckx).w,d2	;move puckx into d2
	asr.w	#1,d2	;divide by 2
	add.w	d2,d0	;add d2 to d0
	bsr.w	.lim
	bsr.w	PuckcIsGoalie
	bne.w	.4
	move.w	#$FF40,d1
	btst	#7,pflags(a3)
	bne.w	.4
	neg.w	d1
.4
	jmp	(skateto).l	;skateto routine
.lim	;Keep y d1 no deeper than the deepest of the other team's forwards (position 3 and up, available), at most $74 out
	move.l	a2,-(sp)
	clr.w	(recwins).w
	move.w	#$FF8C,(TempLegSpd).w
	btst	#7,pflags(a3)
	beq.w	.l0
	neg.w	(TempLegSpd).w
.l0
	movea.l	#SortCords,a2
	btst	#6,pflags(a3)
	beq.w	.l1
	movea.l	#SortCords+(6*SCstruct),a2
.l1
	move.w	#5,d2
.l2
	cmpi.w	#3,position(a2)
	blt.w	.l4
	btst	#2,pflags2(a2)
	bne.w	.l4
	move.w	Ypos(a2),d3
	btst	#7,pflags(a3)
	beq.w	.l3
	cmp.w	(TempLegSpd).w,d3
	bgt.w	.l4
	move.w	Ypos(a2),(TempLegSpd).w
	bra.w	.l4
.l3
	cmp.w	(TempLegSpd).w,d3
	blt.w	.l4
	move.w	Ypos(a2),(TempLegSpd).w
.l4
	adda.w	#SCstruct,a2
	dbf	d2,.l2
	btst	#7,pflags(a3)
	bne.w	.l5
	cmp.w	(TempLegSpd).w,d1
	bgt.w	.l6
	move.w	(TempLegSpd).w,d1
	bra.w	.l6
.l5
	cmp.w	(TempLegSpd).w,d1
	blt.w	.l6
	move.w	(TempLegSpd).w,d1
.l6
	movea.l	(sp)+,a2
	rts
; player a3 is defensive player on defense

donothing	;assnothing (moved in): no assignment, just skate (doplayeracc 8)
	btst	#5,pflags(a3)	;#pfalock
	bne.w	rtss21
	btst	#3,pflags(a3)	;#pfjoycon
	bne.w	rtss21
	moveq	#8,d0
	jmp	(doplayeracc).l
assfight	;asstab entry $19: an rts (94 assfight and assfwatch are rts only)
	rts	;assfight - possible location where fighting logic used to be

pucknorm	;asstab entry 1. The puck: follow the carrier, icing / offsides checks, a stoppage when it sits still
	btst	#2,(BA_PS_flags).w	;check if flag is clear (normal play)
	beq.w	.normalplay
	jsr	(UpdatePenaltyShotEnd).l
.normalplay
	bclr	#pfna,pflags(a3)	;#pfna clear
	beq.w	.nna
	clr.w	temp1(a3)	;temp1
	move.w	#$78,temp2(a3)	;'x' ; temp2
.nna
	movea.w	#(puckcross-M68K_RAM),a1	;table for puck crossing lines
	sub.w	d7,2(a1)	;sub elapse frames from time til crossing
	sub.w	d7,6(a1)
	sub.w	d7,temp1(a3)	;temp1
	bpl.w	.0
	addq.w	#5,temp1(a3)
	bsr.w	findpc
.0
	move.w	(puckc).w,d0
	bmi.w	.nothandled
	asl.w	#7,d0	;#scsize
	movea.w	#(SortCords-M68K_RAM),a2
	adda.w	d0,a2
	bsr.w	a2touchpuck
	move.l	a2,-(sp)
	jsr	(GetHot).l
	add.w	(a2),d0	;Xpos - bungie the puck towards the hot spot on player a2
	sub.w	(a3),d0
	asr.w	#2,d0
	add.w	d0,(a3)
	add.w	Ypos(a2),d1	;Ypos
	sub.w	Ypos(a3),d1
	asr.w	#2,d1
	add.w	d1,Ypos(a3)
	move.w	Xvel(a2),Xvel(a3)	;Xvel
	move.w	Yvel(a2),Yvel(a3)	;Yvel
.nothandled
	jsr	(puckIChk).l
	jsr	(ChkOffsides).l
	btst	#0,(gmode).w	;check for play stoppage
	bne.w	.end
	tst.w	(puckc).w
	bpl.w	.resetstilltimer
	move.w	(a3),d0	;Xpos
	cmp.w	OldXpos(a3),d0	;oldXpos
	bne.w	.resetstilltimer
	move.w	Ypos(a3),d0	;Ypos
	cmp.w	OldYpos(a3),d0	;oldYpos
	bne.w	.resetstilltimer
	move.l	#6,d0
	subq.w	#1,temp2(a3)	;temp3
.maybepenalty
	bpl.w	.stillpuckdone
	jsr	(AddPenalty2).l
.stillpuckdone
	bra.w	.end
.resetstilltimer
	move.w	#$78,temp2(a3)	;'x' ; move 78 hex into temp2
.end
	tst.b	Zvel(a3)	;Zvel
	bne.w	.coll
	tst.w	Zpos(a3)	;Zpos
	bne.w	.coll
	jsr	(puckunflip).l
.coll
	jmp	(checkpuckcoll).l

puckunflip	;asstab entry 5. Stop the spinning puck
	cmpi.w	#8,SPAnum(a3)
	blt.w	.k
	cmpi.w	#$18,SPAnum(a3)
	bge.w	.k
	eori.w	#2,facedir(a3)	;facedir
.k
	ori.w	#4,facedir(a3)
	clr.w	SPAnum(a3)	;SPAnum
	st	SPAcnt(a3)	;SPAcnt
	rts
; start puck spinning
; a3 = puck

puckflip	;Flip the puck (95 SPA $12C0)
	andi.w	#1,d0
	eor.w	d0,facedir(a3)	;facedir
	andi.w	#3,facedir(a3)
	st	SPAcnt(a3)	;SPAcnt
	move.w	#$12C0,d1	;#SPApflip (95 SPA; 94 $46A)
	jmp	(SetSPA).l

; assignment for puck shadow
; a3 = puck shadow
puckshadow	;asstab entry 2. The puck shadow, a siren on goals (95: no horizontal mode)
	cmpi.w	#$1B3,frame(a3)	;#SPFpuck, frame (94 $18A)
	bne.w	.siren	;shadow turns into siren on goals
	move.w	Xpos-SCstruct(a3),(a3)	;Xpos-SCstruct, Xpos
	move.w	Ypos-SCstruct(a3),Ypos(a3)	;Ypos-SCstruct, Ypos
	clr.w	Zpos(a3)	;Zpos
	moveq	#Ypos,d0	;Ypos (95 has no horizontal mode check)
	addq.w	#1,0(a3,d0.w)
	rts
.siren
	tst.w	frame(a3)	;frame
	beq.w	.s0	;94 rtss2
	clr.w	(a3)	;Xpos
	move.w	#$13C,Ypos(a3)	;Ypos (94 $12C)
	move.w	#$E,Zpos(a3)	;Zpos
	tst.w	Ypos-SCstruct(a3)	;Ypos-SCstruct
	bpl.w	.s0
	move.w	#$8000,attribute(a3)	;attribute
	neg.w	Ypos(a3)	;Ypos
	subq.w	#1,Zpos(a3)	;Zpos
.s0
	rts

findpc	;Where and when the puck crosses each goal line (puckcross). 95: 4 frames earlier
	movem.l	d0-d4/a1-a2,-(sp)
	movea.w	#(puckcross-M68K_RAM),a1
	move.w	#$98,d1	;sideline (94 $88) - distance from center to side boards
	move.w	#$10B,d4	;goaline (94 $108)
	bsr.w	.calc
	neg.w	d4	;make d4 negative to check bottom goal line
	bsr.w	.calc
	movem.l	(sp)+,d0-d4/a1-a2
	rts
.calc
	move.w	d4,d0	;move goaline into d0
	sub.w	(pucky).w,d0	;sub pucky from d0
	tst.w	(puckvy).w	;check puckvy
	beq.w	.nocross	;branch if 0
	move.w	d0,d2	;move d0 into d2
	swap	d2	;swap upper and lower word of d2
	clr.w	d2	;clear bottom word of d2
	asr.l	#4,d2	;shift 4 bits right (divide by 16)
	divs.w	(puckvy).w,d2	;divide puckvy into d2
	bmi.w	.nocross	;branch if negative
	cmp.w	#4,d2	;95: 4 frames earlier, when more than 4
	ble.w	.t
	subq.w	#4,d2
.t
	move.w	d2,2(a1)	;time until crossing in frames (puckcross y)
	muls.w	(puckvx).w,d0	;mult puckvx with d0
	divs.w	(puckvy).w,d0	;divide puckvy into d0
	bvs.w	.nocross	;branch if overflow set
	add.w	(puckx).w,d0	;add puckx to d0
	cmp.w	d1,d0	;compare d1 (sideline) to d0
	blt.w	.o1	;branch if less than (in play)
	neg.w	d0	;negate d0
	add.w	d1,d0	;add d1 3 times to d0
	add.w	d1,d0
	add.w	d1,d0
.o1
	neg.w	d1	;negate d1
	cmp.w	d1,d0	;compare d1 (other sideline) to d0
	bgt.w	.o2	;branch if greater than (in play)
	neg.w	d0	;negate d0
	add.w	d1,d0	;add d1 to d0 3 times
	add.w	d1,d0
	add.w	d1,d0
.o2
	neg.w	d1	;negate d1
	move.w	d0,(a1)	;move d0 into puckcross
	bra.w	.next
.nocross
	move.w	#$FFFF,2(a1)	;move -1 into puckcross y
.next
	addq.w	#4,a1	;add 4 to puckcross (to move to the other goal line)
	rts

a2touchpuck	;Player a2 touched the puck: last touch, scorer / assist slots, offsides, icing. 95: no icing in Practice Mode
	move.w	(a2),(ltx).w	;move Xpos to last touch X
	move.w	Ypos(a2),(lty).w	;move Ypos to last touch Y
	move.w	SCnum(a2),(ltplayer).w	;move SCnum to last touch player
	movea.w	#(tmstruct-M68K_RAM),a0	;move Home Shots into a0
	btst	#pfteam,pflags(a2)	;check if home or away
	beq.w	.t	;branch if home
	lea	tmsize(a0),a0	;add to a0 if away
.t
	clr.w	d0
	move.b	pnum(a2),d0	;move pnum into d0
	btst	#pf3onetimer,pflags3(a2)	;check if one timer
	beq.w	.checklast	;branch if not
	bset	#7,(sflags8).w	;set if one timer
.checklast
	cmp.w	$18(a0),d0	;compare value in C6E6 (home) to d0
	beq.w	.same	;branch if equal
	bclr	#3,tmflags(a0)	;clear bit 3
	bne.w	.st	;branch if not cleared before
	move.w	$1A(a0),$1C(a0)	;move current player to assist slot
	move.w	$18(a0),$1A(a0)	;move current player to last player slot
.st
	move.w	d0,$18(a0)	;move pnum into current player
	cmp.w	$1C(a0),d0	;compare if same player as assist slot
	bne.w	.same	;branch if not
	st	$1C(a0)	;set FFFF to assist slot
.same
	bclr	#sf2shot,(sflags2).w	;clear shot taken
	bsr.w	a2offsides
	btst	#2,(iflags).w	;check if icing
	beq.w	.notice	;branch if not
	btst	#0,(iflags).w	;test if crossed goalline
	beq.w	.notice	;branch if not
	tst.w	position(a2)	;check if goalie
	beq.w	.notice	;branch if so
	btst	#1,(iflags).w	;check if must cross top line
	bne.w	.up	;branch if so
	btst	#pfgoal,pflags(a2)	;check if top or bottom shooting goal
	beq.w	.notice	;branch if bottom
.icing
	clr.w	d0
	move.b	(icingPlayer).w,d0	;move iflags+1 into d0
	asl.w	#7,d0
	move.l	a3,-(sp)	;push on stack
	movea.w	#(SortCords-M68K_RAM),a3
	adda.w	d0,a3	;a3 now player struct
	move.w	#$C,d0	;#PenIcing
	jsr	(AddPenalty).l
	movea.l	(sp)+,a3
	rts
.up
	btst	#pfgoal,pflags(a2)	;check top or bottom shooting goal
	beq.s	.icing	;branch if bottom
.notice
	clr.b	(iflags).w
	move.b	SCnum+1(a2),(icingPlayer).w	;move SCnum+1 into icingPlayer
	move.w	(pucky).w,d0	;move pucky into d0
	btst	#pfgoal,pflags(a2)	;check if shooting up or down
	beq.w	.0	;branch if down
	bset	#1,(iflags).w	;set icing direction up
	neg.w	d0	;negate d0
.0
	bmi.w	.x	;exit if minus
	move.w	(tmstruct+tmap).w,d0	;(tmap).w
	sub.w	(AwShots+tmap).w,d0	;(tmsize).w
	btst	#pfteam,pflags(a2)	;check home or away
	beq.w	.1	;branch if home
	neg.w	d0	;negate d0
.1
	bmi.w	.x	;exit if minus
	btst	#7,(sflags9).w	;95: no icing in Practice Mode
	bne.w	.x
	bset	#2,(iflags).w	;set icing flag
.x
	rts

Setplass	;Set player a3's first assignment by position (95 numbers). 94: set players (a3) initial assignment from.alist by position
	move.w	position(a3),d0
	bmi.w	.x
	lea	.alist(pc),a0
	move.b	0(a0,d0.w),d0
	bra.w	assreplace
.x
	rts
.alist	;95 assignment numbers by position
	dc.b	6	;assgoaliecpu (94 $E)
	dc.b	7	;assdefd (94 2)
	dc.b	7	;assdefd
	dc.b	8	;asswingd (94 3)
	dc.b	$A	;asscenterd (94 5)
	dc.b	8	;asswingd
	dc.b	$A	;95: asscenterd
	dc.b	$FF

assexit	;Exit the current assignment of player a3
	addq.w	#1,assnum(a3)	;add 1 to current assignment index
	andi.w	#7,assnum(a3)	;mask passing first 3 bits
	bset	#pfna,pflags(a3)	;signal next assignment
	rts
; insert new assignment on player a3
assinsert	;Insert assignment d0 on player a3
	subq.w	#1,assnum(a3)	;$36 = assnum
	andi.w	#7,assnum(a3)
; replace current assignment on player a3
assreplace	;Replace the current assignment of player a3 with d0
	move.l	d1,-(sp)	;push on stack
	move.w	assnum(a3),d1	;$36 = assnum
	move.b	d0,asslist(a3,d1.w)	;replace current assignment with d0 on asslist
	bset	#pfna,pflags(a3)	;set flag to start new assignment
	move.l	(sp)+,d1	;pop on stack
	rts
; d0/d1 are x/y distances which are converted into direction 0-7 and returned in d0

EvadePC	;skateto extra routine: steer around the puck carrier
	tst.w	(puckc).w
	bmi.w	.ex	;no puck carrier
	move.b	Xvel(a3),d2	;Xvel
	sub.b	(puckvx).w,d2	;sub puckvx from Xvel
	ext.w	d2
	add.w	(a3),d2	;add Xpos
	sub.w	(puckx).w,d2	;Sub puckx
	cmp.w	#$28,d2	;'('   ; compare to 40 decimal
	bgt.w	.ex	;exit if greater than 40
	cmp.w	#$FFD8,d2	;compare to -40
	blt.w	.ex	;exit if less than -40
	move.b	Yvel(a3),d1	;Yvel
	sub.b	(puckvy).w,d1	;sub puckvy from Yvel
	ext.w	d1
	add.w	Ypos(a3),d1	;add Ypos to d1
	sub.w	(pucky).w,d1	;Sub pucky
	cmp.w	#$28,d1	;'('   ; compare to 40 dec
	bgt.w	.ex	;exit if greater than
	cmp.w	#$FFD8,d1	;compare to -40 dec
	blt.w	.ex	;exit if less than
	move.w	(a3),d0	;Xpos
	sub.w	(puckx).w,d0	;Sub puckx from Xpos
	move.w	Ypos(a3),d1	;Ypos
	sub.w	(pucky).w,d1	;Sub pucky from Ypos
	jsr	(vtoa).l	;find direction and convert to 0-7
	btst	#5,(gmode).w	;check if offsides is on
	beq.w	.ex	;exit if not
	move.w	Ypos(a3),d1	;Ypos
	btst	#7,pflags(a3)	;check what net shooting at
	bne.w	.0	;branch if top
	neg.w	d1	;negate d1 (Ypos)
.0
	subi.w	#$56,d1	;sub the top blue line from Ypos (94 $58)
	cmp.w	#$A,d1	;compare to 10 decimal
	bgt.w	.ex	;exit if greater
	cmp.w	#$FFCE,d1	;compare to -50
	blt.w	.ex	;branch if less than
	moveq	#2,d0
	move.w	(a3),d1	;Xpos
	cmp.w	(puckx).w,d1	;compare puckx with Ypos difference
	bgt.w	.ex	;exit if greater
	moveq	#6,d0
.ex
	rts
rtsskateto	;95: skateto's exit
	rts

skateto	;Skate a3 to d0 / d1, a0 = extra routine. 95: nothing while locked in an animation
	btst	#5,pflags(a3)	;95: nothing while locked in an animation
	bne.s	rtsskateto
	sub.b	d7,temp2(a3)	;sub d7 from temp2
	bpl.w	.ex	;exit if not 0 or less
	addi.b	#$C,temp2(a3)	;add 12 - only execute every 12 frames
	bsr.w	avdgoal	;avoid the goal nets
	movem.w	d0-d1,-(sp)
	move.w	Xvel(a3),d0	;Xvel
	asr.w	#8,d0	;divide by 256
	neg.w	d0	;make negative
	add.w	(sp)+,d0	;add new x coord from stack
	sub.w	(a3),d0	;sub Xpos
	move.w	Yvel(a3),d1	;Yvel
	asr.w	#8,d1	;divide by 256
	neg.w	d1	;make negative
	add.w	(sp)+,d1	;add new y coord from stack
	sub.w	Ypos(a3),d1	;sub Ypos
	cmp.w	#$C,d0	;compare 12 to d0
	bgt.w	.vt
	cmp.w	#$FFF4,d0	;cmp -12
	blt.w	.vt
	cmp.w	#$C,d1	;compare 12 to d1
	bgt.w	.vt
	cmp.w	#$FFF4,d1	;cmp -12
	blt.w	.vt
	moveq	#9,d0
	bra.w	.nvt
.vt
	jsr	(vtoa).l
.nvt
	jsr	(a0)	;extra collision routine
	move.b	d0,temp2+1(a3)	;move d0 into temp2+1
	cmp.w	#7,d0	;compare to 7
	ble.w	.ex
	move.w	Xvel(a3),d0	;Xvel
	or.w	Yvel(a3),d0	;Yvel
	bne.w	.ex
	move.w	(puckx).w,d0	;move puckx into d0
	move.w	(pucky).w,d1	;move pucky into d1
	btst	#pf2fight,(puck_pflags2).w	;#pf2fight, puckx+pflags2
	beq.w	.nf
	move.w	(xc1).w,d0	;scroll lock x coord
	move.w	(yc1).w,d1	;scroll lock y coord
.nf
	sub.w	(a3),d0	;Xpos
	sub.w	Ypos(a3),d1	;Ypos - face towards puck
	jsr	(vtoa).l
	sub.w	facedir(a3),d0	;facedir
	beq.w	.ex
	neg.w	d0
	andi.w	#4,d0
	lsr.w	#1,d0	;divide by 2
	subq.w	#1,d0
	add.w	facedir(a3),d0	;facedir
	andi.w	#7,d0
	move.w	d0,facedir(a3)	;facedir
.ex
	clr.w	d0
	move.b	temp2+1(a3),d0	;temp2+1
	jmp	(doplayeracc).l

check4check	;Check an opponent in front of a3. 95: a joystick player blocks the shot (CanBlock, SPAblock); sflags10 bit 7 always looks; burstchk / Acheck
	tst.w	position(a3)	;check if goalie
	bne.w	.player	;branch if not
	rts
.player
	btst	#3,pflags(a3)	;95: a joystick player blocks the shot when CanBlock allows
	bne.w	.cpu
	jsr	(CanBlock).l
	beq.w	.cpu
	move.w	#$1E6C,d1	;SPAblock
	bset	#2,(GameFlags).w
	jsr	(SetSPA).l
	bset	#5,pflags(a3)	;lock the animation
	rts
.cpu
	btst	#7,(sflags10).w	;95: always look with sflags10 bit 7
	bne.w	.look
	move.w	#$28,d0	;'('   ; start with 28 hex (40 decimal)
	sub.b	checking(a3),d0	;subtract Chk from d0 (Chk max is 1E or 30 decimal)
	tst.w	(OptPen).w	;check for penalties option
	beq.w	.nopen	;branch if not on
	asl.w	#1,d0	;mult by 2
.nopen
	jsr	(randomd0).l	;RNG d0
	cmp.w	#6,d0	;compare 6 to d0
	bhi.w	.x	;exit if d0 higher than 6
.look
	moveq	#5,d2	;move 5 into d2
	movea.w	#(SortCords-M68K_RAM),a0
	cmpi.w	#6,SCnum(a3)	;check if player on home team
	bge.w	.0	;branch if away
	adda.w	#6*SCstruct,a0	;add if home (checks opposite team in loop)
.0
	tst.w	position(a0)	;check if goalie
	beq.w	.next	;branch if goalie
	btst	#pfalock,pflags(a0)	;check if locked in anim
	bne.w	.next	;branch if locked
	btst	#pf2fight,pflags2(a0)	;check if fighting
	bne.w	.next	;branch if fighting
	move.w	(a0),d0	;move Xpos into d0
	sub.w	(a3),d0	;sub a3 from a0
	cmp.w	#$1E,d0	;compare to 30 decimal
	bgt.w	.next	;branch if more than 30 decimal
	cmp.w	#$FFE2,d0	;compare to -30 decimal
	blt.w	.next	;branch if less than -30
	move.w	Ypos(a0),d1	;Ypos
	sub.w	Ypos(a3),d1	;subtract checker Ypos from d1
	cmp.w	#$1E,d1	;compare to 30 decimal
	bgt.w	.next	;branch if more
	cmp.w	#$FFE2,d1	;check with -30 decimal
	blt.w	.next	;branch if less
	jsr	(vtoa).l	;determine direction
	cmp.w	facedir(a3),d0	;compare facedir with vtoa result
	bne.w	.next	;branch if not facing in that direction
	tst.w	d1	;95: within $1E in y (always here): the check (burstchk)
	bpl.w	.1
	neg.w	d1
.1
	cmp.w	#$1E,d1
	bgt.w	.2
.burst
	jmp	(burstchk).l
.2
	tst.w	d1
	bpl.w	.3
	neg.w	d1
.3
	cmp.w	#$1E,d1
	bgt.s	.burst
	btst	#5,(sflags6).w	;check if puckc in slot
	bne.w	.check	;branch if in slot
	move.w	(VDP_CNTR).l,d0	;move HVcounter into d0
	andi.w	#3,d0	;pass first 2 bits
	bne.s	.burst	;throw check
.check
	jmp	(Acheck).l
.next
	adda.w	#SCstruct,a0	;move to next SCstruct
	dbf	d2,.0
.x
	rts

check4check2	;check4check with a puck y test before the check (burstchk) or Acheck
	;(or $A beyond it), else on vcount bit 8. Called from assdefdchase
	tst.w	position(a3)	;check if goalie
	bne.w	.player	;branch if not
	rts
.player
	btst	#3,pflags(a3)
	bne.w	.cpu
	jsr	(CanBlock).l
	beq.w	.cpu
	move.w	#$1E6C,d1	;SPAblock
	bset	#2,(GameFlags).w
	jsr	(SetSPA).l
	bset	#5,pflags(a3)
	rts
.cpu
	btst	#7,(sflags10).w
	bne.w	.look
	move.w	#$28,d0
	sub.b	checking(a3),d0
	tst.w	(OptPen).w
	beq.w	.nopen
	asl.w	#1,d0
.nopen
	jsr	(randomd0).l
	cmp.w	#6,d0
	bhi.w	.x
.look
	moveq	#5,d2
	movea.w	#(SortCords-M68K_RAM),a0
	cmpi.w	#6,SCnum(a3)
	bge.w	.0
	adda.w	#6*SCstruct,a0
.0
	tst.w	position(a0)
	beq.w	.next
	btst	#pfalock,pflags(a0)
	bne.w	.next
	btst	#pf2fight,pflags2(a0)
	bne.w	.next
	move.w	(a0),d0
	sub.w	(a3),d0
	cmp.w	#$1E,d0
	bgt.w	.next
	cmp.w	#$FFE2,d0
	blt.w	.next
	move.w	Ypos(a0),d1
	sub.w	Ypos(a3),d1
	cmp.w	#$1E,d1
	bgt.w	.next
	cmp.w	#$FFE2,d1
	blt.w	.next
	jsr	(vtoa).l
	cmp.w	facedir(a3),d0
	bne.w	.next
	tst.w	d1
	bpl.w	.1
	neg.w	d1
.1
	cmp.w	#$1E,d1
	bgt.w	.2
.side
	move.w	(pucky).w,d0	;check when the puck is past a3 in y, or $A past it toward his goal
	move.w	Ypos(a3),d1
	eor.w	d1,d0
	bmi.w	.burst
	move.w	#$FFF6,d0
	btst	#7,pflags(a3)
	bne.w	.4
	move.w	#$A,d0
.4
	move.w	(pucky).w,d1
	eor.w	d1,d0
	bmi.w	.burst
	move.w	(vcount).w,d0	;else a check on vcount bit 8
	andi.w	#$100,d0
	beq.w	.check
.burst
	jmp	(burstchk).l
.2
	tst.w	d1
	bpl.w	.3
	neg.w	d1
.3
	cmp.w	#$1E,d1
	bgt.s	.side
	btst	#5,(sflags6).w
	bne.w	.check
	move.w	(VDP_CNTR).l,d0
	andi.w	#3,d0
	bne.s	.side
.check
	jmp	(Acheck).l
.next
	adda.w	#SCstruct,a0
	dbf	d2,.0
.x
	rts

asspassrec	;asstab entry $D. Catch a pass; a one timer (assonetimer) for a computer player in the zone
	btst	#pfalock,pflags(a3)	;pfalock - animation lock
	bne.w	rtss6	;exit if locked
	btst	#gmclock,(gmode).w	;gmclock - check if clock running
	bne.w	donothing	;exit if clock stopped
	btst	#pfjoycon,pflags(a3)	;pfjoycon - joystick controlled?
	bne.w	assexit	;exit if controlled
	bclr	#pfna,pflags(a3)	;#pfna - clear new assignment
	beq.w	.nna
	bset	#pfdoff,pflags(a3)	;#pfdoff - set decceleration off
	move.b	#8,temp2+1(a3)	;move into temp2+1
	clr.b	temp2(a3)	;clear temp2 byte
	move.w	#$FFFE,temp4(a3)	;move into temp4
.nna
	tst.w	(puckc).w	;check if there is a puck carrier
	bpl.w	.exit	;exit if puck still in possession
	addq.w	#1,temp4(a3)	;add to temp4
	beq.w	.0	;branch if temp4 is zero
	bpl.w	.ex2	;branch if temp4 is positive
.0
	tst.w	(onetimerplayer).w
	bpl.w	.ex2
	tst.w	position(a3)	;test if goalie
	beq.w	.ex2	;exit if goalie
	move.w	d0,-(sp)	;push d0 on stack
	clr.w	temp4(a3)	;clear temp4
	move.w	#1,d0
	btst	#6,pflags(a3)	;check if home or away
	beq.w	.1
	move.w	#2,d0	;away team
.1
	cmp.w	(cont1team).w,d0	;check if player on cont 1 team
	beq.w	.pop	;branch if so
	cmp.w	(cont2team).w,d0	;check if player on cont 2 team
	beq.w	.pop	;branch if so
	jsr	(PuckOnAttackHalf).l
	beq.w	.pop
	move.w	Ypos(a3),d0	;Ypos
	btst	#7,pflags(a3)	;pfgoal
	bne.w	.chkpos	;branch if shooting at top
	neg.w	d0
.chkpos
	cmp.w	#$56,d0	;blueline (94 $58)
	blt.w	.nozone
	cmp.w	#$10B,d0	;goalline (94 $108)
	bgt.w	.nozone
	bra.w	.atkzone
.nozone
	move.w	#8,d0	;outside of attack zone
	jsr	(randomd0).l
	tst.w	d0	;check if d0 is zero
	bne.w	.pop
.atkzone
	move.w	(sp)+,d0
	move.w	#$FFFF,(inputjoy).w
	move.w	#$18,d0	;assonetimer (94 $23)
	jmp	(assreplace).l
.pop
	move.w	(sp)+,d0
.ex2
	sub.b	d7,temp1(a3)
	bpl.w	rtss6
.exit
	bclr	#pfdoff,pflags(a3)
	jmp	(assexit).l
SkateToTempTarget	;Skate to temp3 / temp4
	move.w	temp3(a3),d0		;temp3
	move.w	temp4(a3),d1		;temp4
	lea	rtss6(pc),a0
	jmp	(skateto).l
rtss6	;the SkateToTempTarget exit, also asspassrec's and assdefo's (94 rtss6 is before assdefo)
	rts
rtsskate	;95: a second rts. assgoaliecpu, AdjustFacingDirection, assdefo and others branch here
	rts

assbreakaway	;asstab entry $21. Breakaway; falls into assnearest
	move.w	SCnum(a3),d0	;Move SCnum into d0
	cmp.w	(puckc).w,d0	;compare puck carrier SCnum with d0
	beq.w	.puckc	;branch if puck carrier
.notpuckc
	bclr	#pf3break,pflags3(a3)	;clear breakaway bit
	move.w	#$E,d0	;assnearest (94 $11)
	bsr.w	assreplace
	bra.w	assnearest
.puckc
	jsr	(breakaway).l
	bmi.s	.notpuckc

assnearest	;asstab entry $E. The player nearest the puck without it. 95: skates at the future puck spot, no crowd meter boost
	bclr	#2,(sflags5).w
	bne.w	.chkpuck
	bclr	#pf3break,pflags3(a3)	;clear breakaway bit
.chkpuck
	move.w	SCnum(a3),d0	;move SCnum into d0
	cmp.w	(puckc).w,d0	;compare with puck carrier SCnum
	bne.w	.chkbreak	;jump if not puck carrier
	btst	#pf3break,pflags3(a3)	;check breakaway bit
	bne.w	.chkbreak	;jump if set
	btst	#2,(BA_PS_flags).w	;check if bit 2 set (cleared on Faceoffs)
	bne.w	.chkbreak	;jump if set
	jsr	(BreakawayOffsidesFlagSet).l
	beq.w	.chkbreak
	move.w	#$21,d0	;assbreakaway if flag set (94 $22)
	bsr.w	assreplace	;assreplace with assbreakaway
	bra.w	*+4
.chkbreak
	bclr	#1,pflags(a3)	;pfna - clear new assignment
	beq.w	.nna
	btst	#pf3break,pflags3(a3)	;check if breakaway
	beq.w	.chkbreak2	;jump if not
	move.w	#SFXbeep1,-(sp)	;ding SFX
	jsr	(sfx).l
.chkbreak2
	btst	#pf3break,pflags3(a3)	;check if breakaway
	beq.w	.nobreak	;jump if not
	movem.l	a2,-(sp)	;push a2 to stack
	movea.l	#tmstruct,a2	;put Home Team Struct into a2
	btst	#6,pflags(a3)	;pfteam - check home or away
	beq.w	.addcrowd	;jump if home
	movea.l	#AwShots,a2	;put Away Team Struct into a2
.addcrowd
	addq.w	#1,$35A(a2)	;add to breakaway attempt (94 $358)
	addi.w	#$14,(CwdExciteLvl).w	;add to excite level
	addi.w	#$C8,(crowdlevel).w	;add to crowd level
	movem.l	(sp)+,a2	;pop off stack into a2
.nobreak
	clr.w	temp3(a3)	;clear temp3
	move.w	#8,temp2(a3)	;move 8 into temp2
	clr.w	temp1(a3)	;clear temp1
.nna
	move.w	SCnum(a3),d1	;checks if puck carrier
	cmp.w	(puckc).w,d1
	bne.w	.nopc	;jumps if not
	tst.w	position(a3)	;check if goalie
	beq.w	assgoaliecpu	;branch if goalie
	moveq	#$F,d0	;asspuckc (94 $10)
	btst	#pfjoycon,pflags(a3)	;pfjoycon - check if controlled
	beq.w	assinsert	;jump if not
	rts
.nopc
	sub.b	d7,temp1(a3)	;subtract d7 (elapsed frames) from temp1
	bpl.w	.nodec	;jump if positive
	move.b	aioff(a3),temp1(a3)	;move aioff into temp1
	jsr	(ReadGoaliePulled).l	;check if goalie is pulled
	bmi.w	.bonus
	btst	#6,(sflags7).w	;check if crowd meter currently broken
	beq.w	.nopc2	;jump if not broken
	tst.b	temp1(a3)	;check if temp1 is 0
	beq.w	.nopc2	;jump if so
.bonus
	subq.b	#1,temp1(a3)	;subtract 1 from temp1
.nopc2
	btst	#5,(sflags6).w	;check if slot bit is set (puckc in slot)
	beq.w	.nopc3	;branch if not set
	move.w	(puckc).w,d1	;move puck carrier SCnum
	cmp.w	#5,d1	;check if its home (5 or less) or away (6-11)
	bgt.w	.pcaway	;jump if away
	btst	#6,pflags(a3)	;pfteam
	beq.w	.nopc3	;jump if home
.tmnopc
	move.b	temp1(a3),d1	;temp1 into d1
	ext.w	d1	;extend d1
	asr.w	#1,d1	;divide by 2
	move.b	d1,temp1(a3)	;move d1 into temp1 - cutting the timer in half
	bne.w	.nopc3	;jump if not zero
	move.b	#1,temp1(a3)	;move 1 into temp1
	bra.w	.nopc3
.pcaway
	btst	#6,pflags(a3)	;pfteam - 0 home, 1 away
	beq.s	.tmnopc	;jump if home
.nopc3
	clr.l	Yvel(a2)	;Calculated future Ypos of the player closest to the puck
	move.w	(puckc).w,d1	;move puck carrier SCnum into d1
	bmi.w	.np	;branch if no puck carrier
	asl.w	#7,d1	;scsize
	movea.w	#(SortCords-M68K_RAM),a1	;Move SortCords into a1
	adda.w	d1,a1	;use d1 as offset
	move.b	pflags(a1),d0	;pflags of puck carrier
	move.b	pflags(a3),d1	;pflags of current player
	eor.b	d0,d1	;XOR pflags
	btst	#pfteam,d1	;check pfteam
	beq.w	.switch	;branch if on same team
.np
	moveq	#-1,d2	;-1
	moveq	#5,d4	;5 = # of players on team
	movea.w	tmsort(a2),a0	;SortCord start value for team
.de0
	tst.w	position(a0)	;check if goalie
	ble.w	.next	;branch if goalie
	tst.b	nopuck(a0)	;check if nopuck (cant touch puck)
	bne.w	.next	;branch if nopuck timer not 0
	btst	#2,pflags2(a0)	;pf2unav - unavailable
	bne.w	.next	;branch if unavailable
	move.w	assnum(a0),d0	;assnum - current assignment
	cmpi.b	#$D,asslist(a0,d0.w)	;check if current assignment is asspassrec (94 $13)
	beq.w	.next	;branch if a0 is going to receive puck
	move.l	a0,-(sp)	;push onto stack
	jsr	(GetHot).l	;get hot spot
	add.w	(a0),d0	;Xpos to d0
	sub.w	(puckx).w,d0	;sub puck Xpos
	add.w	Ypos(a0),d1	;add Ypos to d1
	sub.w	(pucky).w,d1	;sub puck Ypos
	move.w	(puckvx).w,d3	;puckvx into d3
	asr.w	#6,d3	;divide by 64
	sub.w	d3,d0	;sub d3 from d0 (X distance between player and puck)
	move.w	(puckvy).w,d3	;puckvy into d3
	asr.w	#6,d3	;divide by 64
	sub.w	d3,d1	;sub d3 from d1 (Y distance between player and puck)
	muls.w	d0,d0	;square d0
	muls.w	d1,d1	;square d1
	add.l	d1,d0	;add d1 to d0
	cmp.l	d2,d0	;compare d2 to d0
	bhi.w	.next	;branch if d0 higher than d2 (0 or a positive # first run)
	move.l	d0,d2	;move d0 into d2
	movea.w	a0,a1	;move a0 address into a1
.next
	adda.w	#SCstruct,a0	;SCstruct size
	dbf	d4,.de0	;iterate through loop
	tst.l	d2	;check if 0
	bmi.w	.de1	;branch if less (no one near puck)
	move.l	d2,Yvel(a2)	;moves d2 into $2A(a2)
.switch
	cmpa.w	a1,a3	;a1 = closest to the puck, or puckc (if on same team)
	beq.w	.de1	;branch if same
	btst	#gmclock,(gmode).w	;gmclock - 1 if stopped
	bne.w	.de1	;jump if stopped
	btst	#2,pflags2(a1)	;pf2unav
	bne.w	.de1	;jump if unavailable
	btst	#pf3onetimer,pflags3(a1)	;shooting one timer
	bne.w	.de1	;jump if shooting
	btst	#7,pflags3(a1)	;95: with bit 7 (assdefdchase) only when a1 has the puck, and clear it
	beq.w	.x1
	movem.w	d0,-(sp)
	move.w	SCnum(a1),d0
	cmp.w	(puckc).w,d0
	movem.w	(sp)+,d0
	bne.w	.de1
	bclr	#7,pflags3(a1)
.x1
	exg	a1,a3	;swap addresses
	bclr	#pfdoff,pflags(a3)	;clear pfdoff
	moveq	#$E,d0	;assnearest (94 $11)
	bsr.w	assinsert
	exg	a1,a3
	bra.w	assexit
.de1
	btst	#pfalock,pflags(a3)	;pfalock - check if locked in animation
	bne.w	rtsskate	;exit if locked
	moveq	#2,d1	;move 2 into d1
	cmp.w	#$190,d2	;compare $190 (20^2) to d2. d2 = distance to puck^2
	bhi.w	.nfar	;branch if d2 higher
	subq.w	#2,d1
	cmpi.w	#2,position(a3)	;compare if position is F or D (1 and 2 are D)
	bls.w	.nodec	;jump if D
.nfar
	btst	#sf2pwrplay,(sflags2).w	;sf2pwrplay - check if PP
	beq.w	.x	;branch if no PP
	subq.w	#2,d1	;sub 2 from d1
	bsr.w	chkpk2
	bne.w	.x	;branch if on PK
	addq.w	#4,d1	;add 4 to d1
.x
	move.w	#$28,d0	;'('   ; move $28 into d0 (40 dec)
	sub.b	checking(a3),d0	;sub checking from d0
	asl.w	d1,d0	;shift d0 by value of d1
	jsr	(randomd0).l	;RNG
	cmp.w	#2,d0	;compare 2 to d0
	bhi.w	.nodec	;branch if d0 more than 2
	move.w	#$F0,temp3(a3)	;move 240 dec into temp3
.nodec
	btst	#pfalock,pflags(a3)	;pfalock - check if anim lock
	bne.w	rtsskate	;exit if locked
	btst	#2,(BA_PS_flags).w	;check bit 2
	beq.w	.gmclock	;jump if not set
	btst	#5,(BA_PS_flags).w	;check bit 5
	beq.w	.nodec2	;jump if not set
.gmclock	;(a 92 equate name; local so it does not split assnearest or clash with the equate)
	btst	#0,(gmode).w	;check if clock running
	bne.w	donothing	;branch if not
.nodec2
	btst	#pfjoycon,pflags(a3)	;pfjoycon - check if controlled
	bne.w	rtsskate	;jump if controlled
	btst	#2,tmflags(a2)	;check bit 2 of $30(a2)
	bne.w	.nodec22
	tst.w	(puckc).w	;check if theres a puck carrier
	bmi.w	.topuck	;jump if no puck carrier
	sub.w	d7,temp3(a3)	;subtract frames from temp3
	bpl.w	.topuck	;jump if positive
	clr.w	temp3(a3)	;clear temp3
.nodec22
	bsr.w	skatetopuckinit	;95: the future puck spot itself (94 took the middle of it and the goal)
	btst	#2,tmflags(a2)	;?? - doesn't seem to be set anywhere
	beq.w	.spdboost
	btst	#pfgoal,pflags(a3)	;pfgoal
	beq.w	.botshoot	;branch if bottom
	cmp.w	#$51,d1	;check if y pos of puck near blue line (94 $53)
	blt.w	.spdboost	;branch if in neutral zone or D zone
	move.w	#$42,d1	;94 $44
	bra.w	.spdboost
.botshoot
	cmp.w	#$FFAF,d1	;check if pucky near bottom blue line (94 $FFAD)
	bgt.w	.spdboost	;branch if in neutral zone or D zone
	move.w	#$FFBE,d1	;94 $FFBC
.spdboost
	btst	#5,(sflags6).w	;check if puckc is in the slot
	beq.w	.noslot	;branch if not
	move.b	legspd(a3),(TempLegSpd).w	;legspd into TempLegSpd
	addq.b	#6,legspd(a3)	;add 6 to legspd (95: no crowd meter boost)
	cmpi.b	#$1E,legspd(a3)	;check speed limit
	ble.w	.cont
	move.b	#$1E,legspd(a3)	;limit legspd to $1E (30 decimal)
.cont
	lea	rtsskate(pc),a0
	bsr.w	skateto
	move.b	(TempLegSpd).w,legspd(a3)	;move original legpsd back into player
	bra.w	.chkslot
.noslot
	lea	rtsskate(pc),a0
	bsr.w	skateto
.chkslot
	btst	#5,(sflags6).w
	beq.w	.chkcont
	move.w	(pucky).w,d0
	move.w	Ypos(a3),d2	;Ypos into d2
	tst.w	d0	;check if d0 is 0
	bpl.w	.pospuck	;branch if positive
	neg.w	d0	;make d0 negative
	neg.w	d2	;make d2 negative
.pospuck
	sub.w	d0,d2	;sub d0 from d2 (equals how far puck is from player Ypos)
	cmp.w	#$A,d2	;check difference with A (10 decimal)
	blt.w	.exit
	move.w	(a3),d0	;Xpos of player (gets here if player is between net and puck carrier)
	sub.w	(puckx).w,d0	;sub puckx from Xpos
	bpl.w	.chkx	;branch if positive difference
	neg.w	d0	;make d0 negative
.chkx
	cmp.w	#$F,d0	;compare F (15 dec) with Xpos difference
	blt.w	.chkcont	;branch if less than (within 15 pix in X direction)
.exit
	rts
.chkcont
	btst	#5,(sflags6).w	;check if puckc is in the slot
	beq.w	check4check	;branch if not in slot
	move.b	checking(a3),d0	;move Chk into d0
	ext.w	d0	;clear top byte of d0
	movem.l	d0/a3,-(sp)	;push to stack
	add.b	d0,d0	;add d0 to itself
	cmp.b	#$1E,d0	;compare max Chk to d0
	blt.w	.chkcont2	;branch if less
	move.b	#$1E,d0	;move 1E into d0
.chkcont2
	move.b	d0,checking(a3)	;move d0 into Chk
	bsr.w	check4check
	movem.l	(sp)+,d0/a3	;pop off stack
	move.b	d0,checking(a3)	;move original Chk into player
	rts
.topuck
	bsr.w	skatetopuck

skatetopuckinit	;d0 / d1 = puck x / y half a step ahead
	move.b	(puckvx).w,d0
	asr.b	#1,d0
	ext.w	d0
	add.w	(puckx).w,d0
	move.b	(puckvy).w,d1
	asr.b	#1,d1
	ext.w	d1
	add.w	(pucky).w,d1
	rts

skatetopuck	;Skate a3 to the puck; a sweep check (Sweepcheck) close up. assgoalietopuck (above) enters here
	bsr.s	skatetopuckinit
	sub.b	d7,temp2(a3)	;temp2
	bpl.w	.ex
	addi.b	#$A,temp2(a3)	;temp2
	bsr.w	avdgoal
	movem.w	d0-d1,-(sp)
	move.l	a3,-(sp)
	jsr	(GetHot).l
	neg.b	d0
	neg.b	d1
	sub.b	Xvel(a3),d0	;Xvel
	ext.w	d0
	add.w	(sp)+,d0
	sub.w	(a3),d0	;Xpos
	sub.b	Yvel(a3),d1	;Yvel
	ext.w	d1
	add.w	(sp)+,d1
	sub.w	Ypos(a3),d1	;Ypos
	jsr	(vtoa).l
	move.b	d0,temp2+1(a3)	;temp2 lower byte
	tst.w	position(a3)
	beq.w	.ex
	move.w	(puckvx).w,d0
	move.w	(puckvy).w,d1
	jsr	(vtoa).l
	eori.w	#4,d0
	cmp.w	facedir(a3),d0	;facedir
	beq.w	.ex
	move.w	(puckx).w,d0
	sub.w	(a3),d0	;Xpos
	move.w	(pucky).w,d1
	sub.w	Ypos(a3),d1	;Ypos
	movem.w	d0-d1,-(sp)
	jsr	(vtoa).l
	cmp.w	facedir(a3),d0	;$54 = facedir
	movem.w	(sp)+,d0-d1
	bne.w	.ex
	muls.w	d0,d0
	muls.w	d1,d1
	add.l	d1,d0
	cmp.l	#$384,d0	;#30^2
	bls.w	.ex
	cmp.l	#$5A4,d0	;#38^2
	bls.w	.sweep
.ex
	move.b	temp2+1(a3),d0
	jmp	(doplayeracc).l
.sweep
	jmp	(Sweepcheck).l

avdgoal	;Do not skate through the goal: correct d0 / d1. 95 goal line $101 (94 $FE)
	clr.w	(deltax).w
	clr.w	(deltay).w
	tst.w	position(a3)	;goalie? If so, quit
	beq.w	rtsskate	;94 rtss2
	move.w	(a3),d2	;Xpos
	eor.w	d0,d2
	bpl.w	.chbar
	move.w	d1,d2
	sub.w	Ypos(a3),d2	;Ypos
	move.w	(a3),d3	;Xpos
	muls.w	d3,d2
	sub.w	d0,d3
	divs.w	d3,d2
	add.w	Ypos(a3),d2	;Ypos
	cmp.w	#$124,d2	;gl+.yr (95 .gl $101; 94 $FE)
	bgt.w	.chbar
	cmp.w	#$DE,d2	;gl-.yr
	blt.w	.lower
	move.w	#$147,d3	;gl+.yr+.ye
	cmp.w	#$101,d2	;gl
	bgt.w	.2
	blt.w	.1
	cmpi.w	#$101,Ypos(a3)	;gl, Ypos
	bgt.w	.2
.1
	move.w	#$BB,d3	;gl-.yr-.ye
.2
	sub.w	d2,d3
	move.w	d3,(deltay).w
	bra.w	.chbar
.lower
	cmp.w	#$FF22,d2	;-.gl+.yr
	bgt.w	.chbar
	cmp.w	#$FEDC,d2	;-.gl-.yr
	blt.w	.chbar
	move.w	#$FF45,d3	;-.gl+.yr+.ye
	cmp.w	#$FEFF,d2	;-.gl
	bgt.w	.4
	blt.w	.3
	cmpi.w	#$FEFF,Ypos(a3)	;-.gl, Ypos
	bgt.w	.4
.3
	move.w	#$FEB9,d3	;-.gl-.yr-.ye
.4
	sub.w	d2,d3
	move.w	d3,(deltay).w
.chbar
	move.w	d1,d3
	subi.w	#$101,d3
	move.w	Ypos(a3),d2
	subi.w	#$101,d2
	bsr.w	.ch1
	move.w	d1,d3
	addi.w	#$101,d3
	move.w	Ypos(a3),d2
	addi.w	#$101,d2
	bsr.w	.ch1
	add.w	(deltax).w,d0
	add.w	(deltay).w,d1
	rts
.ch1
	move.w	d3,d4
	eor.w	d2,d4
	bpl.w	rtsskate	;94 rtss2
	move.w	d0,d4
	sub.w	(a3),d4	;Xpos
	muls.w	d2,d4
	sub.w	d3,d2
	divs.w	d2,d4
	add.w	(a3),d4	;Xpos
	cmp.w	#$50,d4	;'P'   ; #.xr
	bgt.w	rtsskate
	cmp.w	#$FFB0,d4	;#-.xr
	blt.w	rtsskate
	moveq	#$50,d3	;'P'   ; #.xr
	tst.w	d4
	bne.w	.ch2
	tst.w	(a3)	;Xpos
.ch2
	bpl.w	.ch3
	neg.w	d3
.ch3
	sub.w	d4,d3
	move.w	d3,(deltax).w
	rts

breakaway	;Breakaway for the carrier
	bset	#2,(sflags5).w
	bclr	#1,pflags(a3)	;pfna - clear new assignment
	beq.w	.nna	;jump if no new assignment
	move.w	#SFXbeep1,-(sp)	;ding SFX
	jsr	(sfx).l
	movem.l	a2,-(sp)	;push a2 on stack
	movea.l	#tmstruct,a2	;move Home Team Struct into a2
	btst	#6,pflags(a3)	;pfteam - check if home or away
	beq.w	.c0	;jump if home
	movea.l	#AwShots,a2	;move Away Team Struct into a2
.c0
	addq.w	#1,$35A(a2)	;add one to breakaway attempt (94 $358)
	addi.w	#$14,(CwdExciteLvl).w	;add to CwdExcite
	addi.w	#$C8,(crowdlevel).w	;add to crowdlevel
	movem.l	(sp)+,a2
.nna
	movem.w	d1,-(sp)	;push d1 on stack
	move.w	Ypos(a3),d0	;move Ypos into d0
	move.w	Yvel(a3),d1	;move Yvel into d1
	beq.w	.yvel0	;jump if Yvel = 0
	eor.w	d1,d0	;EOR d1 with d0. d0 will be negative if skating opposite direction of net
.exit
	movem.w	(sp)+,d1	;pop d1 off stack
	rts
.yvel0
	move.w	#$FFFF,d1
	bra.s	.exit
BreakawayOffsidesFlagSet	;the breakaway / offsides flags of a3 ($64 bits 1 and 0)
	btst	#1,pflags(a3)	;check for new assignment
	beq.w	.loadYpos	;branch if no new assignment
	bclr	#pf3oside,pflags3(a3)	;clear player offsides flag
	bclr	#pf3break,pflags3(a3)	;clear player breakaway flag
.loadYpos
	movem.w	d0-d1/a0,-(sp)
	move.w	#$10B,d0	;top goal line Y pos (94 $108)
	move.w	Ypos(a3),d1	;Ypos
	bpl.w	.cmpgoalline	;branch if Ypos is positive
	neg.w	d1	;negate d1
.cmpgoalline
	cmp.w	d0,d1	;compare position to top goal line
	bge.w	.nogood	;Branch if above it
	move.w	#$56,d0	;top blue line Y pos (94 $58)
	move.w	Ypos(a3),d1	;Ypos
	btst	#7,pflags(a3)	;check goal to shoot on (0=bottom, 1=top)
	bne.w	.top	;branch if top goal
	neg.w	d0	;bottom goal, so negate d0
	cmp.w	d1,d0	;compare Ypos to blue line Y
	blt.w	.setoffside	;branch if not in attack zone
	bra.w	.offzone	;branch if in attack zone
.top
	cmp.w	d1,d0	;compare Ypos to blue line Y
	blt.w	.offzone	;branch if in offensive zone
.setoffside
	bset	#pf3oside,pflags3(a3)	;set offsides flag
	bra.w	.nogood
.offzone
	bclr	#pf3oside,pflags3(a3)	;clear offside bit
	beq.w	.nogood	;branch if on the blue line
	movea.l	#SortCords+(11*SCstruct),a0	;loads last SCScruct player struct (Away pos #6)
	move.w	#$B,d0	;B = # of player structs to check (12)
	tst.w	d1	;checks if d1 is negative (determines what zone to check)
	bmi.w	.checkYpos
.checkYpos2
	cmp.w	Ypos(a0),d1	;compare Ypos of a0 player to d1 (Ypos puckc)
	bge.w	.substruct2	;branch if d1 greater than or equal
	tst.w	position(a0)	;check if goalie
	beq.w	.substruct2	;branch if goalie
	bra.w	.nogood
.substruct2
	suba.w	#SCstruct,a0
	dbf	d0,.checkYpos2
.setBAbit
	bset	#pf3break,pflags3(a3)	;set breakaway bit
	move.w	#1,d0	;moves 1 into d0 (used by returned subroutine)
.exit
	movem.w	(sp)+,d0-d1/a0
	rts
.nogood
	move.w	#0,d0	;move 0 into d0 (used on return to subroutine)
	bra.s	.exit
.checkYpos
	cmp.w	Ypos(a0),d1	;check Ypos with d1 (d1 = blue line Y)
	ble.w	.substruct
	tst.w	position(a0)	;checks if goalie (who would be below blue line)
	beq.w	.substruct
	bra.s	.nogood
.substruct
	suba.w	#SCstruct,a0	;back one sort object
	dbf	d0,.checkYpos
	bra.s	.setBAbit

chkpuckc	;asstab entry $1E. Breakaway carrier check, then asspuckc
	btst	#0,(gmode2).w
	bne.w	.0
	btst	#2,(BA_PS_flags).w
	bne.w	.0
	bsr.w	breakaway
	bpl.w	asspuckc	;currently skating towards net in Y
.0
	bclr	#pf3break,pflags3(a3)	;clear breakaway bit
	move.w	#$F,d0	;asspuckc (94 $10)
	bsr.w	assreplace

asspuckc	;asstab entry $F. The puck carrier. 95: a penalty shot SPA while a message is up, Practice Mode breakaways
	bclr	#2,(sflags5).w
	bne.w	.0
	bclr	#pf3break,pflags3(a3)
.0
	move.w	(puckc).w,d0
	cmp.w	SCnum(a3),d0
	bne.w	assexit
	btst	#2,(BA_PS_flags).w
	beq.w	.1
	cmpi.w	#1,(msgtimer).w
	ble.w	.1
	move.w	#$B5C,d1	;95: in a penalty shot with a message up, this SPA
	jsr	(SetSPA).l
	bra.w	.x
.1
	btst	#pf3break,pflags3(a3)
	bne.w	.2
	btst	#2,(BA_PS_flags).w
	bne.w	.2
	btst	#7,(sflags9).w	;95: always a breakaway in Practice Mode
	bne.w	.br
	jsr	(BreakawayOffsidesFlagSet).l
	beq.w	.2	;branch if breakaway flag not set
.br
	move.w	#$1E,d0	;chkpuckc assignment (94 $21)
	bsr.w	assreplace
	bra.w	*+4
.2
	btst	#5,pflags(a3)
	bne.w	rtsskate	;94 rtss2
	btst	#2,(BA_PS_flags).w
	bne.w	.3
	btst	#0,(gmode).w
	bne.w	donothing
.3
	btst	#3,pflags(a3)
	bne.w	assexit
	bclr	#1,pflags(a3)
	beq.w	.7
	btst	#pf3break,pflags3(a3)
	beq.w	.4
	move.w	#SFXbeep1,-(sp)
	jsr	(sfx).l
.4
	btst	#pf3break,pflags3(a3)
	beq.w	.6
	movem.l	a2,-(sp)
	movea.l	#tmstruct,a2
	btst	#6,pflags(a3)
	beq.w	.5
	movea.l	#AwShots,a2
.5
	addq.w	#1,$35A(a2)	;94 $358
	addi.w	#$14,(CwdExciteLvl).w
	addi.w	#$C8,(crowdlevel).w
	movem.l	(sp)+,a2
.6
	clr.w	temp1(a3)
	move.w	#8,temp2(a3)
	move.w	(VDP_CNTR).l,d0
	andi.w	#3,d0
	move.w	d0,temp3(a3)
.7
	sub.b	d7,temp1(a3)
	bpl.w	.nodec
	move.b	aioff(a3),temp1(a3)
	jsr	(ReadGoaliePulled).l
	bmi.w	.8
	btst	#6,(sflags7).w
	beq.w	.9
	tst.b	temp1(a3)
	beq.w	.9
.8
	subq.b	#1,temp1(a3)
.9
	btst	#2,(BA_PS_flags).w
	bne.w	.12
	btst	#0,(gmode2).w
	bne.w	.12
	jsr	(checkob).l
	jsr	(chk4lc).l
	btst	#0,(gmode2).w
	bne.w	.12
	btst	#2,(BA_PS_flags).w
	bne.w	.12
	btst	#pf3break,pflags3(a3)
	bne.w	.11
	move.w	#1,d0
	btst	#6,pflags(a3)
	beq.w	.10
	move.w	#2,d0
.10
	cmp.w	(cont1team).w,d0
	beq.w	.11
	cmp.w	(cont2team).w,d0
	beq.w	.11
	btst	#1,(vcount+1).w
	bne.w	.13
.11
	bsr.w	chk4shot
	bra.w	.13
.12
	jsr	(ShootoutShootCheck).l
	bne.w	.nodec
	jsr	(compshoot).l
.13
	bsr.w	chk4pass
.nodec
	moveq	#6,d0
	add.w	temp3(a3),d0	;add temp3 to d0
	lea	.postab2(pc),a0
	btst	#sf2offsig,(sflags2).w	;#sf2offsig
	beq.w	.nd1
	move.w	position(a3),d0	;position
.nd1
	asl.w	#2,d0
	move.w	2(a0,d0.w),d1
	move.w	0(a0,d0.w),d0
	btst	#2,(BA_PS_flags).w
	bne.w	.14
	btst	#0,(gmode2).w
	beq.w	.15
.14
	jsr	(SkatePath).l
	cmpi.b	#$80,(sopathx).w
	beq.w	.x
.15
	btst	#7,pflags(a3)	;pfgoal - 0 for bottom 1 for top
	bne.w	.nd0
	neg.w	d0
	neg.w	d1
.nd0
	lea	.chkdir(pc),a0
	btst	#2,(BA_PS_flags).w
	bne.w	.16
	btst	#0,(gmode2).w
	beq.w	.17
.16
	lea	.x(pc),a0
.17
	bra.w	skateto
.chkdir
	ext.w	d0
	move.b	Xvel(a3),d2	;Xvel
	ext.w	d2
	add.w	(puckx).w,d2
	move.b	Yvel(a3),d3	;Yvel
	ext.w	d3
	add.w	(pucky).w,d3
	clr.w	(threat).w
	moveq	#5,d4
	movea.w	#(SortCords-M68K_RAM),a0
	cmpi.w	#6,SCnum(a3)
	bge.w	.loop
	adda.w	#6*SCstruct,a0	;away team SCstruct start
.loop
	move.b	Xvel(a0),d1	;Xvel
	ext.w	d1
	add.w	(a0),d1	;Xpos
	sub.w	d2,d1
	cmp.w	#$14,d1
	bgt.w	.next
	cmp.w	#$FFEC,d1
	blt.w	.next
	move.b	Yvel(a0),d1	;Yvel
	ext.w	d1
	add.w	Ypos(a0),d1	;Ypos
	sub.w	d3,d1
	cmp.w	#$14,d1
	bgt.w	.next
	cmp.w	#$FFEC,d1
	blt.w	.next
	addq.w	#1,(threat).w
	move.w	(a3),d0	;Xpos
	sub.w	(a0),d0
	move.w	Ypos(a3),d1	;Ypos
	sub.w	Ypos(a0),d1
	jsr	(vtoa).l
	move.w	facedir(a3),d1	;facedir
	eori.w	#4,d1
	cmp.w	d0,d1
	bne.w	.next
	move.w	(VDP_CNTR).l,d1
	andi.w	#1,d1
	add.w	d1,d0
	andi.w	#7,d0
.next
	adda.w	#SCstruct,a0	;SCstruct size
	dbf	d4,.loop
.x
	rts
.postab2	dc.w	$FF9C
	dc.w	$FFEC
	dc.w	$64
	dc.w	$FFEC
	dc.w	$FF88
	dc.w	$28
	dc.w	$14
	dc.w	$28
	dc.w	$78
	dc.w	$28
	dc.w	$FFEC
	dc.w	$28
	dc.w	$FFD8
	dc.w	$F3	;94 $F0
	dc.w	0
	dc.w	$DF	;94 $DC
	dc.w	$14
	dc.w	$E9	;94 $E6
	dc.w	$1E
	dc.w	$E9	;94 $E6

chk4shot	;Shoot or clear the puck; compshoot is in input95. 95: the breakaway deke always in Practice Mode
	jsr	(chkpk).l
	bne.w	.pkill	;killing penalty
	tst.w	(threat).w
	beq.w	.pkill	;no threat
	move.w	(VDP_CNTR).l,d0
	andi.w	#3,d0
	bne.w	.pkill
	move.w	#$56,d0	;top blue line Y position (94 $58)
	btst	#7,pflags(a3)
	beq.w	.cmphome
	move.w	#$FFAA,d0	;bottom blue line Y pos (94 $FFA8)
	cmp.w	Ypos(a3),d0
	bge.w	.0
.clear
	jmp	(compshoot).l	;clear puck
.cmphome
	cmp.w	Ypos(a3),d0
	bgt.s	.clear	;clear puck
.0
	bset	#3,(sflags5).w
	jmp	(dopass).l
.pkill
	btst	#7,(sflags9).w	;95: the breakaway deke always in Practice Mode
	bne.w	.dk
	btst	#pf3break,pflags3(a3)
	beq.w	.npk
.dk
	move.w	#$1E,d0
	jsr	(randomd0).l
	addi.w	#$82,d0
	cmp.w	(pucky).w,d0
	blt.w	.1
	neg.w	d0
	cmp.w	(pucky).w,d0
	bgt.w	.1
	bra.w	.npk
.1
	move.w	#2,d0
	jsr	(randomd0s).l
	add.w	facedir(a3),d0
	andi.w	#7,d0
	move.w	d0,facedir(a3)
	bra.w	compshoot
.npk
	moveq	#$20,d4
	clr.w	d1
	move.b	spodds(a3),d1
	lsr.w	#1,d1
	sub.b	d1,d4
	asl.w	#4,d4
	move.w	#$10B,d1	;top goal line Y (94 $108)
	btst	#7,pflags(a3)
	bne.w	.c0
	neg.w	d1
.c0
	sub.w	(pucky).w,d1
	move.w	(puckx).w,d0
	neg.w	d0
	movem.w	d0-d1,-(sp)
	muls.w	d0,d0
	muls.w	d1,d1
	add.l	d0,d1
	cmp.l	#$2710,d1
	movem.w	(sp)+,d0-d1
	bhi.w	.no1
	lsr.w	#4,d4
	jsr	(vtoa).l
	move.w	d0,d5
	moveq	#5,d3
	movea.w	#(SortCords-M68K_RAM),a1
	cmpi.w	#6,SCnum(a3)
	bge.w	.loop
	adda.w	#6*SCstruct,a1
.loop
	tst.w	position(a1)
	beq.w	.2
	move.w	(a1),d0
	sub.w	(puckx).w,d0
	move.w	Ypos(a1),d1
	sub.w	(pucky).w,d1
	jsr	(vtoa).l
	cmp.w	d5,d0
	bne.w	.co1
	asl.w	#1,d4
	bra.w	.co1
.2
	btst	#1,pflags2(a1)
	beq.w	.g0
	bra.w	.g1
.g0
	bra.w	.co1	;95: the goalie position checks after this are dead
	cmpi.w	#$1A,(a1)
	bgt.w	.g1
	cmpi.w	#$FFE6,(a1)
	blt.w	.g1
	cmpi.w	#$10B,Ypos(a1)
	bgt.w	.g1
	cmpi.w	#$FEF5,Ypos(a1)
	blt.w	.g1
	cmpi.w	#$CF,Ypos(a1)
	bgt.w	.co1
	cmpi.w	#$FF31,Ypos(a1)
	blt.w	.co1
.g1
	clr.w	d3
	move.w	#1,d4
.co1
	adda.w	#SCstruct,a1
	dbf	d3,.loop
.no1
	move.w	d4,d0
	jsr	(randomd0).l
	btst	#0,spodds(a3)
	beq.w	.3
	cmp.w	#7,d0
	bgt.w	rtsskate
	bra.w	.4
.3
	cmp.w	#8,d0
	bgt.w	rtsskate
.4
	move.w	(pucky).w,d0
	btst	#7,pflags(a3)
	bne.w	.ds0
	neg.w	d0
.ds0
	tst.w	d0
	bmi.w	rtsskate
	move.w	#$10B,d1	;94 $108
	sub.w	d0,d1
	bmi.w	rtsskate
	btst	#sf2offsig,(sflags2).w
	bne.w	rtsskate
	jmp	(compshoot).l

chk4pass	;Pass to a free teammate (dopass)
	tst.w	(threat).w
	bne.w	.dp0
	moveq	#$10,d0
	add.b	spodds(a3),d0
	jsr	(randomd0).l
	cmp.w	#$C,d0
	bgt.w	rtsskate
.dp0
	moveq	#6,d0
	jsr	(randomd0).l
	cmpi.w	#6,SCnum(a3)
	blt.w	.0
	addq.w	#6,d0
.0
	tst.w	position(a3)
	beq.w	.1
	cmpi.w	#$28,(puckx).w
	bgt.w	.1
	cmpi.w	#$FFD8,(puckx).w
	blt.w	.1
	cmpi.w	#$CF,(pucky).w
	bgt.w	rtsskate
	cmpi.w	#$FF31,(pucky).w
	blt.w	rtsskate
.1
	cmp.w	SCnum(a3),d0
	beq.w	rtsskate
	asl.w	#7,d0
	movea.w	#(SortCords-M68K_RAM),a0
	adda.w	d0,a0
	tst.w	position(a0)
	ble.w	rtsskate
	btst	#2,pflags2(a0)
	bne.w	rtsskate
	btst	#pfalock,pflags(a0)
	bne.w	rtsskate
	move.w	Ypos(a0),d0
	move.w	Ypos(a3),d1
	btst	#7,pflags(a3)
	bne.w	.f0
	neg.w	d0
	neg.w	d1
.f0
	btst	#gmoffs,(gmode).w
	beq.w	.oko
	movem.w	d0-d1,-(sp)
	subi.w	#$56,d0	;blue line (94 $58)
	subi.w	#$56,d1
	eor.w	d0,d1
	movem.w	(sp)+,d0-d1
	bmi.w	rtsskate
.oko
	cmp.w	#$56,d0	;94 $58
	bgt.w	.ok
	sub.w	d1,d0
	cmp.w	#$FFF1,d0
	blt.w	rtsskate
.ok
	move.w	(a0),d0
	sub.w	(puckx).w,d0
	move.w	Ypos(a0),d1
	sub.w	(pucky).w,d1
	movem.w	d0-d1,-(sp)
	jsr	(vtoa).l
	move.w	d0,(passdir).w
	movem.w	(sp)+,d1-d2
	muls.w	d1,d1
	muls.w	d2,d2
	add.l	d1,d2
	moveq	#5,d3
	movea.w	#(SortCords-M68K_RAM),a1
	cmpi.w	#6,SCnum(a3)
	bge.w	.co0
	adda.w	#6*SCstruct,a1
.co0
	move.w	(a1),d0
	sub.w	(puckx).w,d0
	move.w	Ypos(a1),d1
	sub.w	(pucky).w,d1
	movem.w	d0-d1,-(sp)
	muls.w	d0,d0
	muls.w	d1,d1
	add.l	d0,d1
	cmp.l	d2,d1
	movem.w	(sp)+,d0-d1
	bhi.w	.co1
	jsr	(vtoa).l
	cmp.w	(passdir).w,d0
	beq.w	rtsskate
.co1
	adda.w	#SCstruct,a1
	dbf	d3,.co0
	bsr.w	dopass
	tst.w	position(a3)
	beq.w	rtsskate
	addq.w	#4,sp
	bra.w	assexit

check4bench	;check4bench (moved in): go to the bench for a line change, or take the new position
	btst	#2,(BA_PS_flags).w
	bne.w	rtsskate
	btst	#3,pflags(a3)
	bne.w	rtsskate
	btst	#4,pflags2(a3)
	bne.w	rtsskate
	tst.b	newpos(a3)
	bpl.w	.0
	tst.b	newpnum(a3)
	bmi.w	rtsskate
.0
	move.b	newpnum(a3),d0
	cmp.b	pnum(a3),d0
	beq.w	.samepl
	move.w	assnum(a3),d0
	cmpi.b	#$12,asslist(a3,d0.w)	;assbench (94 $B)
	beq.w	rtsskate
	move.w	SCnum(a3),d0
	cmp.w	(puckc).w,d0
	beq.w	rtsskate
	addq.w	#4,sp
	bset	#2,pflags2(a3)	;set player unavailable (pf2unav)
	clr.w	temp1(a3)
	moveq	#$12,d0	;assbench (94 $B)
	bra.w	assreplace
.samepl
	addq.w	#4,sp
	bclr	#2,pflags2(a3)
	bclr	#pfnc,pflags(a3)
	st	newpnum(a3)
	st	newpos(a3)
	move.w	position(a3),d0
	tst.b	newpos(a3)
	bpl.w	.1
	jmp	(Setplass).l
.1
	move.b	newpos(a3),d0
	ext.w	d0
	move.w	d0,position(a3)
	jmp	(Setplass).l

;------------------------------------------------------------------------------------------------------------------------
; $08282E  From assign94.asm: the bench and penalty assignments
;	94 assbench and rtss4, asspenalty, assdopen, assepen (94 asseben, between rtss4 and asspenalty, is in in 95).
;the whole range as dc.b (it runs from $81A5E to PuckOnAttackHalf); it is code here, read from the retail bytes.
;	95 changes: the 95 asstab numbers (assdopen $17; 94 $D), the 95 SPA values (the comments give the 94 ones), the bench and box
;	x $98 / $96 (94 $88 / $86), the goalie bench ready animation from GoalieReadySPA, jsr / jmp .l to the routines 95 moved out of
;	range, the shared rtsskate (above) in place of rtss3 / rtss4 / rtss2, asspenalty .clrplayer for pads 3 and 4, and the
;	attribute byte kept over the penalty box (penboxattr).

assbench	;asstab entry $12. Player a3 goes to the bench: skate to the bench door, hop over (SPA), then setplayer the new player
	btst	#pfalock,pflags(a3)
	bne.w	rtsskate	;94 rtss3
	cmpi.w	#$64,temp1(a3)
	beq.w	.done
	bsr.w	check4bench
	btst	#4,pflags2(a3)
	bne.w	assexit
	bclr	#pfna,pflags(a3)
	beq.w	.nna
	move.w	#8,temp2(a3)
	moveq	#$50,d0
	btst	#pfteam,pflags(a3)
	bne.w	.0
	neg.w	d0
.0
	move.w	d0,temp4(a3)
	move.w	#$98,temp3(a3)	;sideline (94 $88)
	neg.w	temp3(a3)
	subq.w	#8,temp3(a3)
	clr.w	temp1(a3)
.nna
	move.b	newpnum(a3),d0
	cmp.b	pnum(a3),d0
	beq.w	.nobench
	sub.w	d7,temp1(a3)
	bpl.w	.nodec
	addq.w	#8,temp1(a3)
	move.w	Ypos(a3),d0
	sub.w	temp4(a3),d0
	cmp.w	#$28,d0
	bgt.w	.nodec
	cmp.w	#$FFD8,d0
	blt.w	.nodec
	move.w	(a3),d0
	sub.w	temp3(a3),d0
	cmp.w	#$20,d0
	bgt.w	.nodec
	move.w	#$B5C,d1	;95 SPA (94 $50C)
	tst.w	position(a3)
	bne.w	.gli
	jsr	(GoalieReadySPA).l	;95 (94: 2, SPAgready)
.gli
	jsr	(SetSPA).l
	bset	#pfnc,pflags(a3)
	cmpi.w	#4,facedir(a3)
	beq.w	.ok
	addq.w	#1,facedir(a3)
	andi.w	#7,facedir(a3)
.ok
	clr.w	Yvel(a3)
	move.w	#$F800,Xvel(a3)
	cmp.w	#$10,d0
	bgt.w	.x
	clr.w	Xvel(a3)
	cmpi.w	#4,facedir(a3)
	bne.w	.x
	move.w	#$F800,Xvel(a3)
	move.w	#2,facedir(a3)
	move.w	#$1E2A,d1	;95 SPA (94 $FAC)
	jsr	(SetSPA).l
	bset	#pfalock,pflags(a3)
	move.w	#$64,temp1(a3)
.x
	rts
.done
	clr.w	frame(a3)
	clr.w	d0
	move.b	pnum(a3),d0
	add.w	d0,d0
	movea.l	#tmstruct,a0
	btst	#6,pflags(a3)
	beq.w	.t0
	adda.w	#tmsize,a0
.t0
	move.w	#$FFFE,tmpdst(a0,d0.w)
	move.b	newpnum(a3),d3
	bsr.w	.nobench2
	jmp	(setplayer).l
.nodec
	btst	#pfnc,pflags(a3)
	bne.s	.x
	move.w	temp3(a3),d0
	move.w	temp4(a3),d1
	movea.l	#EvadePC,a0
	bra.w	skateto
.nobench
	bclr	#2,pflags2(a3)
.nobench2
	move.b	newpos(a3),d0
	ext.w	d0
	move.w	d0,position(a3)
	jsr	(Setplass).l
	st	newpnum(a3)
	st	newpos(a3)
rtss4	;The end of assbench (95 branches go to rtsskate)
	rts

asspenalty	;asstab entry $15. Player a3 goes to the penalty box and hops in, then assdopen
	btst	#5,pflags(a3)
	bne.w	rtsskate	;94 rtss4
	bclr	#1,pflags(a3)
	beq.w	.nna
	bset	#2,pflags2(a3)	;set player unavailable (pf2unav)
	bsr.w	.clrplayer
	moveq	#-2,d4	;move -2 into d4
	jsr	(setpads).l	;moves player number into a temp value so graphics know who it is
	move.w	#8,temp2(a3)	;move 8 into temp2
	moveq	#$B,d0	;move 11 dec into d0
	move.b	(PBnum).w,d1	;gets number of players in PB. 00HV (H=Home, V=Visitors)
	btst	#6,pflags(a3)	;checks if player is home or away
	bne.w	.0	;branch if away
	lsr.w	#4,d1	;shift 4 bits to get Home players in PB
	neg.w	d0	;make d0 negative (different box)
.0
	andi.w	#$F,d1	;pass the first 4 bits of d1 (the team's player total in PB)
	cmp.w	#2,d1	;compare to 2
	bls.w	.1	;branch if less than (1 player in box or less)
	moveq	#2,d1	;add 2 if more than 1 player in box
.1
	addq.w	#3,d1	;add 3 to d1
	muls.w	d0,d1	;mult d0 with d1, store result in d1
	move.w	d1,temp4(a3)	;move d1 into temp4 (skateto YPos)
	move.w	#$98,temp3(a3)	;sideline: skateto XPos (94 $88)
	clr.w	temp1(a3)	;clear temp1
	bset	#5,pflags2(a3)	;set bit for no player collision
	clr.w	Wallcos(a3)	;clear wallCos (angle of last collision)
	clr.w	Wallsin(a3)	;clear wallSin (angle of last collision)
.nna
	move.w	Ypos(a3),d0	;Current Ypos of player
	sub.w	temp4(a3),d0	;sub temp4 (Y pos to skate to) from Ypos
	cmp.w	#$C,d0	;compare to 13 decimal
	bgt.w	.st	;branch if greater than (still skateto)
	;If its within 13 decimal, it will start the animation for hopping over the board
	cmp.w	#$FFF4,d0
	blt.w	.st
	move.w	(a3),d0
	sub.w	temp3(a3),d0
	cmp.w	#$FFE8,d0
	blt.w	.st
	sub.w	d7,temp1(a3)
	bpl.w	rtsskate
	addq.w	#8,temp1(a3)
	bset	#pfnc,pflags(a3)
	move.w	#$B5C,d1	;95 SPA (94 $50C)
	jsr	(SetSPA).l
	moveq	#6,d2
	tst.b	handed(a3)
	beq.w	.left
	moveq	#2,d2
.left
	cmp.w	facedir(a3),d2
	beq.w	.ok
	addq.w	#1,facedir(a3)
	andi.w	#7,facedir(a3)
.ok
	clr.w	Yvel(a3)
	move.w	#$1000,Xvel(a3)
	cmp.w	#$FFF8,d0
	blt.w	rtsskate
	clr.w	Xvel(a3)
	cmp.w	facedir(a3),d2
	bne.w	rtsskate
	bset	#5,pflags(a3)
	move.w	#2,facedir(a3)
	move.b	attribute(a3),(penboxattr).w	;95: keep the attribute, without bit 3, for assdopen
	bclr	#3,attribute(a3)
	move.w	#$1DE0,d1	;95 SPA (94 $F6E)
	jsr	(SetSPA).l
	bclr	#4,pflags2(a3)
	moveq	#$17,d0	;assdopen (94 $D)
	bra.w	assreplace
.st
	move.w	temp3(a3),d0
	move.w	temp4(a3),d1
	movea.l	#rtsskate,a0	;94 rtss2
	bra.w	skateto
.clrplayer	;take the joystick off player a3 (92 asspenalty .clrplayer, 93 global clrplayer)
	btst	#3,pflags(a3)
	beq.w	rtsskate
	clr.w	d4
	move.w	SCnum(a3),d0
	cmp.w	(c1playernum).w,d0
	beq.w	.chg
	moveq	#2,d4
	cmp.w	(c2playernum).w,d0	;95: pads 3 and 4 too
	beq.w	.chg
	move.w	#4,d4
	cmp.w	(c3playernum).w,d0
	beq.w	.chg
	move.w	#6,d4
.chg
	jmp	(chgplayer).l	;94 changeplayer

assdopen	;asstab entry $17. Add player a3 to the penalty box (PBnum)
	btst	#5,pflags(a3)
	bne.w	rtsskate	;94 rtss4
	tst.w	position(a3)	;95: only once, and give the attribute back
	bmi.w	rtsskate
	move.b	(penboxattr).w,attribute(a3)
	moveq	#$10,d0
	btst	#6,pflags(a3)
	beq.w	.1
	moveq	#1,d0
.1
	add.b	d0,(PBnum).w
	st	position(a3)
	clr.w	frame(a3)
	rts

assepen	;asstab entry $16. Player a3 leaves the penalty box
	btst	#5,pflags(a3)
	bne.w	rtsskate	;94 rtss4
	bclr	#1,pflags(a3)
	beq.w	.nna
	bset	#pfnc,pflags(a3)	;set player in no collision mode
	bset	#2,pflags2(a3)	;set player unavailable
	moveq	#$10,d0
	moveq	#$FFFFFFC4,d1
	btst	#6,pflags(a3)
	beq.w	.0
	moveq	#1,d0
	neg.w	d1
.0
	sub.b	d0,(PBnum).w
	move.w	d1,Ypos(a3)
	clr.w	Xvel(a3)
	clr.w	Yvel(a3)
	move.w	#$96,(a3)	;94 $86
	move.w	#2,facedir(a3)
	bset	#5,pflags(a3)
	move.w	#$1E2A,d1	;95 SPA (94 $FAC)
	jsr	(SetSPA).l
	jmp	(SprSort).l
.nna
	move.w	#4,facedir(a3)
	st	newpnum(a3)
	st	newpos(a3)
	bclr	#pfjoycon,pflags(a3)
	bclr	#pfnc,pflags(a3)
	bclr	#5,pflags2(a3)
	bclr	#2,pflags2(a3)
	move.w	#$F000,Xvel(a3)
	bra.w	assexit

;------------------------------------------------------------------------------------------------------------------------
; $082BD0  From onetimer94.asm: one-timers
;	94 assonetimer, setonetimeranim, PuckOnAttackHalf, onetimershot, then EndOneTimer (moved in) and the 95
;	CheckOneTimerFacing. assshoot follows, at the head of logic95.
;	94 puckvzadj, OneTimerPass, OneTimerTarget and its tables are elsewhere in 95.
;$082BD0-$082E87 and $082EFE-$082F5F as dc.b; they are code here, read from the retail bytes. PuckOnAttackHalf
;	(PuckOnAttackHalf), EndOneTimer; CheckOneTimerFacing ($082FB2) is dc.b again.
;	95 changes: each pad takes the one-timer shooter itself (setc1player ... setc4player by inputjoy; 94 swapped pads 3 / 4 into 1 / 2),
;	the 95 SPA values and goal line $10B (the comments give the 94 values), the PAL speed $18 (94 $16), the one-timer count at $35E of
;	the team struct (94 $35C), and CheckOneTimerFacing now calls Findhittype.


assonetimer	;asstab entry $18 (94 $23). 94 Player a3 shooting a one-timer: the passer's pad (inputjoy) takes
	;control of him (setc1player ... setc4player), start the animation (setonetimeranim), then shoot when the puck arrives (EndOneTimer)
	bclr	#1,pflags(a3)	;pfna - clear new assignment
	beq.w	.checkxpos	;branch if not new assignment
	bset	#pf3onetimer,pflags3(a3)	;set one timer bit
	bne.w	.checkxpos	;branch if already set
	bclr	#0,(onetimerflags).w
	bclr	#5,(sflags8).w
	clr.w	(onetimerflags).w
	clr.w	(onetimerclock).w
	st	(passplayer).w
	movem.l	d0-d7/a0-a6,-(sp)
	move.w	SCnum(a3),d0	;move a3 SCnum into d0
	move.w	d0,(onetimerplayer).w	;move d0
	btst	#3,pflags(a3)	;check if joystick controlled
	bne.w	.setanim	;branch if so
	tst.w	(inputjoy).w	;check input controller (95: the pad number 0 / 2 / 4 / 6 of the passer)
	bmi.w	.setanim	;branch if minus (no control)
	beq.w	.p1	;pad 1
	cmpi.w	#2,(inputjoy).w
	beq.w	.p2
	cmpi.w	#4,(inputjoy).w
	beq.w	.p3
	jsr	(setc4player).l	;95: each pad takes the shooter itself (94 swapped pads 3 / 4 into 1 / 2)
	bra.w	.setanim
.p1
	jsr	(setc1player).l
	bra.w	.setanim
.p2
	jsr	(setc2player).l
	bra.w	.setanim
.p3
	jsr	(setc3player).l
	bra.w	.setanim	;*+4
.setanim
	move.w	d0,-(sp)
	bsr.w	setonetimeranim	;sets the one timer animation
	clr.w	SPAnum(a3)	;clear SPAnum
	jsr	(SetSPA).l
	bset	#5,pflags(a3)	;lock animation
	bset	#1,pflags2(a3)	;set anim in progress
	move.w	(sp)+,d0
	movem.l	(sp)+,d0-d7/a0-a6
	bra.w	.ex
.checkxpos
	btst	#0,(onetimerflags).w	;check if shot initiated
	bne.w	.chkcarrier	;branch if set
	movem.w	d0-d1,-(sp)	;push to stack
	move.w	(puckx).w,d0	;move puckx to d0
	sub.w	(a3),d0	;sub Xpos from d0
	cmp.w	#$3C,d0	;'<'   ; compare diff to 3C (60 pixels)
	bgt.w	.chkxvel	;branch if greater than
	cmp.w	#$FFC4,d0	;compare to -60 pixels
	bgt.w	.chkypos	;branch if greater than
.chkxvel
	move.w	(puckvx).w,d1	;move puckvx into d1
	eor.w	d1,d0	;EOR d1 with d0
	bmi.w	.chkypos	;branch if minus
.notcoming
	movem.w	(sp)+,d0-d1	;pop from stack d0 and d1
	bra.w	.cancel
.chkypos
	move.w	(pucky).w,d0	;move pucky into d0
	sub.w	Ypos(a3),d0	;sub Ypos from d0
	cmp.w	#$3C,d0	;'<'   ; compare diff to 60 pix
	bgt.w	.chkyvel	;branch if greater than
	cmp.w	#$FFC4,d0	;check with -60 pix
	bgt.w	.coming	;branch if greater than
.chkyvel
	move.w	(puckvy).w,d1	;move puckvy into d0
	eor.w	d1,d0	;EOR d1 with d0
	bpl.s	.notcoming	;branch if positive
.coming
	movem.w	(sp)+,d0-d1	;pop d0 and d1 from stack
.chkcarrier
	tst.w	(puckc).w	;check if puck carrier
	bmi.w	.loose	;branch if no puck carrier
.cancel
	bclr	#7,(sflags8).w	;clear bit 7
	bra.w	.shoot
.loose
	btst	#0,(gmode).w	;check if game clock
	bne.w	.shoot	;branch if clock stopped
	movem.l	d0-d1,-(sp)	;push to stack
	cmpi.w	#$10,SPAnum(a3)	;compare 10 to SPAnum
	bge.w	.windup	;branch if greater than or equal
	btst	#2,(onetimerflags).w	;check bit 2
	bne.w	.windup	;branch if set
	move.w	(a3),d0	;move Xpos into d0
	move.w	(puckx).w,d1	;move puckx into d1
	sub.w	d1,d0	;sub d1 from d0
	bpl.w	.dy	;branch if positive
	neg.w	d0	;negate d0
.dy
	move.w	Ypos(a3),d1	;move Ypos into d1
	move.w	(pucky).w,d2	;move pucky into d2
	sub.w	d2,d1	;sub d2 from d1
	bpl.w	.vel	;branch if positive
	neg.w	d1	;negate d1
.vel
	move.w	(puckvx).w,d2	;move puckvx into d2
	beq.w	.usey	;branch if d2 is 0
	cmp.w	d0,d1	;compare d0 to d1
	ble.w	.frames	;branch if less than or equal
.usey
	move.w	(puckvy).w,d2
	move.w	d1,d0
.frames
	swap	d0
	andi.l	#$FFFF0000,d0
	tst.w	d2
	bpl.w	.speed
	neg.w	d2
.speed
	move.w	#$11,d1
	tst.w	(music_global_tick_counter).w
	beq.w	.chkzero
	move.w	#$18,d1	;PAL (94 $16)
.chkzero
	tst.w	d2
	bne.w	.div
	move.w	#1,d2
.div
	divu.w	d2,d0
	andi.l	#$FFFF,d0
	divu.w	d1,d0
	move.w	SPAnum(a3),d2
	lsr.w	#2,d2
	subq.w	#6,d2
	neg.w	d2
	asl.w	#2,d2
	cmp.w	d2,d0
	bgt.w	.wait
	neg.w	SPAnum(a3)
	addi.w	#$18,SPAnum(a3)
	bra.w	.chkanim
.wait
	add.w	d7,(onetimerclock).w
	bra.w	.chkhold
.windup
	bset	#2,(onetimerflags).w
	btst	#1,(onetimerflags).w
	bne.w	.chkhold
	cmpi.w	#$18,SPAnum(a3)
	bne.w	.chkhold
	addi.w	#$30,SPAcnt(a3)
	bset	#1,(onetimerflags).w
.chkhold
	btst	#1,(onetimerflags).w
	beq.w	.chkshot
	cmpi.w	#$18,SPAnum(a3)
	ble.w	.chkshot
	btst	#0,(onetimerflags).w
	bne.w	.chkshot
	movem.l	(sp)+,d0-d1
	bra.w	.shoot
.chkshot
	btst	#0,(onetimerflags).w
	beq.w	.chkanim
	cmpi.w	#$18,SPAnum(a3)
	bne.w	.chkanim
	cmpi.w	#1,SPAcnt(a3)
	ble.w	.chkanim
	move.w	#1,SPAcnt(a3)
.chkanim
	btst	#1,pflags2(a3)
	bne.w	.animon
	movem.l	(sp)+,d0-d1
	bra.w	.chkdone
.animon
	move.w	SPAnum(a3),d0
	movem.l	(sp)+,d0-d1
	btst	#0,(onetimerflags).w
	beq.w	.nop
	bclr	#5,pflags(a3)
	bra.w	.chkdone
.nop
	nop
.chkdone
	btst	#1,pflags2(a3)
	bne.w	.ex
.shoot
	jsr	(EndOneTimer).l
.ex
	rts

setonetimeranim	;94 The one-timer animation: d1 = $150A or $176E (94 $7FC / $92E) from the angle to the goal
	;(vtoa, CheckOneTimerFacing)
	move.w	#$150A,d1	;95 SPA (94 $7FC)
	movem.w	d0-d1,-(sp)	;push to stack d0 and d1
	move.w	(a3),d0	;move XPos of a3 into d0
	neg.w	d0	;negate d0
	move.w	#$10B,d1	;move top goal line into d1 (94 $108)
	btst	#7,pflags(a3)	;check which goal shooting at
	bne.w	.top	;branch if top
	neg.w	d1	;negate d1
.top
	sub.w	Ypos(a3),d1	;sub Ypos from d1
	jsr	(vtoa).l
	jsr	(CheckOneTimerFacing).l	;95: Z from Findhittype
	movem.w	(sp)+,d0-d1	;pop from stack d0 and d1
	beq.w	.ex
	move.w	#$176E,d1	;95 SPA (94 $92E)
.ex
	rts

PuckOnAttackHalf	;d0 = 1 when the puck is on the half of the goal player a3 shoots at, else 0 (the code after the bra is
	;never used). Called from doinput and asspassrec
	movem.w	d0-d1,-(sp)
	move.w	(pucky).w,d0
	btst	#7,pflags(a3)	;pfgoal - check which goal shooting at
	bne.w	.cont	;branch if top goal
	neg.w	d0
.cont
	tst.w	d0	;check if d0 is 0
	bpl.w	.plus	;branch if higher
	bra.w	.0
	move.w	(passdir).w,d0	;code never used from here up to _0
	addq.w	#4,d0
	andi.w	#7,d0
	move.w	facedir(a3),d1
	cmp.w	d0,d1
	bra.w	.plus
	beq.w	.plus
	addq.w	#1,d1
	andi.w	#7,d1
	cmp.w	d0,d1
	beq.w	.plus
	addq.w	#1,d1
	andi.w	#7,d1
	cmp.w	d0,d1
	beq.w	.plus
	subq.w	#3,d1
	andi.w	#7,d1
	cmp.w	d0,d1
	beq.w	.plus
	subq.w	#1,d1
	andi.w	#7,d1
	beq.w	.plus
.0
	move.w	#0,d0
	bra.w	.ex
.plus
	move.w	#1,d0
.ex
	movem.w	(sp)+,d0-d1
	rts

onetimershot	;94 Do the one-timer shot (doshot), credit the last two passers as the assists, add to crowdlevel /
	;CwdExciteLvl and to the one-timer attempts ($35E of the team struct; 94 $35C). Called from puckstick
	move.w	#4,(passdir).w
	jsr	(doshot).l
	movem.l	d0/a0,-(sp)
	movea.l	#tmstruct,a0	;Home Stats
	btst	#6,pflags(a3)	;check if home or away
	beq.w	.home	;branch if home
	lea	tmsize(a0),a0	;add if away
.home
	clr.w	d0
	move.b	pnum(a3),d0	;player offset in roster
	move.w	$1A(a0),$1C(a0)	;move assist 1 player to assist 2
	move.w	$18(a0),$1A(a0)	;move last player to touch puck to assist 1
	move.w	d0,$18(a0)	;move d0 into player touching puck
	bset	#7,(sflags8).w	;set bit 7
	addi.w	#$96,(crowdlevel).w	;add to crowdlevel
	addi.w	#$A,(CwdExciteLvl).w	;add to Excite Level
	addq.w	#1,$35E(a0)	;add to one timer attempt (94 $35C)
	movem.l	(sp)+,d0/a0
	bset	#0,(onetimerflags).w	;set bit 0
	bset	#1,pflags2(a3)	;set animation in progress (95: no sflags6 bit 1)
	rts

EndOneTimer	;End a one-timer for a3: bits cleared, onetimerplayer = -1, SetSPA $B5C (94 $50C)
	;then assexit (goalie) or Setplass. Called from assonetimer and from $8C606
	movem.l	d0/a0,-(sp)
	bclr	#pf3onetimer,pflags3(a3)
	bclr	#5,pflags(a3)
	bclr	#1,pflags2(a3)
	clr.w	(onetimerflags).w
	st	(onetimerplayer).w
	move.w	d1,-(sp)
	move.w	#$B5C,d1	;95 SPA (94 $50C)
	jsr	(SetSPA).l
	tst.w	position(a3)
	bpl.w	.0
	jsr	(assexit).l
	bra.w	.1
.0
	jsr	(Setplass).l
.1
	clr.w	SPAnum(a3)
	st	SPAcnt(a3)
	move.w	(sp)+,d1
	movem.l	(sp)+,d0/a0
	rts

CheckOneTimerFacing	;95: Findhittype on direction d0 (the angle to the goal), d0 kept. The Z flag
	;picks the one-timer animation in setonetimeranim (94 did nothing here)
	movem.w	d0,-(sp)
	jsr	(Findhittype).l
	movem.w	(sp)+,d0
	rts

;------------------------------------------------------------------------------------------------------------------------
; $082FC2  From checks94.asm and assign94.asm: assshoot, the goalie assignments, ChkGoalies
;	94 assshoot, assgoaliectrl, a2offsides, asseben (moved in), the 95 assdefdchase, setSlotBit (moved
;	in), assscore and assgoaliebreakwait (moved in), then ChkGoalies, ReturnGoalies, CPgoalie. 94 assgoaliecpu is in
;	the first part of this file. CPgoalie runs to $0836AB, past the mapped end $08369D (inside CPgoalie): starts at $0836AC.
;most of the range as dc.b (assshoot too); it is code here, read from the retail bytes. setSlotBit
;	ChkGoalies, ReturnGoalies and CPgoalie.
;	95 changes: the 95 asstab numbers, SPA values and limits (the comments give the 94 values), jsr / jmp .l to the routines 95 moved out
;	of range (SetShotMode, ShotMode, ...), the shared rtsskate in place of rtss2 / rtss4, the team defense mode
;	(assdefdchase), the scorer's celebration in assscore.


; assignment for computer shooting
assshoot	;asstab entry $1A. assshoot
	btst	#pfalock,pflags(a3)	;pfalock - animation locked
	bne.w	rtsskate	;94 rtss2
	bclr	#pfna,pflags(a3)	;clear pfna
	beq.w	.nna
	jmp	(SetShotMode).l	;95 jmp (94 bra)
.nna
	btst	#sfssdir,(sflags).w	;#sfssdir
	beq.w	assexit
	clr.w	d2
	sub.w	d7,temp2(a3)
	bpl.w	.sm	;95: the bra.w ShotMode is now a shared jmp
	bset	#5,d2	;#cbut
.sm
	jmp	(ShotMode).l

assgoaliectrl	;asstab entry $1B (94 $1D). The joystick goalie: a stoppage when he leaves his area, else
	;checkanim when out of the screen box. 95: rtsskate in place of rtss2
	btst	#3,pflags(a3)	;is player joystick controlled?
	bne.w	.goaliectrl	;branch is so
	bra.w	assexit
.goaliectrl
	btst	#1,pflags(a3)	;check if new assignment
	bne.w	.na	;branch if new assignment
	movem.w	d0-d1,-(sp)	;push to stack
	move.w	(a3),d0	;Xpos
	move.w	Ypos(a3),d1	;Ypos
	cmp.w	#$AA,d1	;compare $AA to Ypos
	bgt.w	.cont
	cmp.w	#$FF56,d1	;check -$AA to Ypos
	blt.w	.cont	;branch if less than
	btst	#0,(gmode).w	;check if clock stopped
	bne.w	.cont	;branch if so
	move.w	d0,-(sp)	;push to stack
	move.w	#8,d0	;clock stoppage due to goalie out of range
	jsr	(AddPenalty2).l
	move.w	(sp)+,d0	;pop from stack
.cont
	sub.w	(Hpos).w,d0	;sub ice rink horiz position from Xpos
	sub.w	(Vpos).w,d1	;sub ice rink vert position from Ypos
	bclr	#pf3gctrl,pflags3(a3)	;clear goalie control bit?
	cmp.w	#$74,d0	;'t'   ; compare $74 to Xpos diff
	blt.w	.0	;branch if less than
	bset	#pf3gctrl,pflags3(a3)	;set goalie control bit?
	bra.w	.cont2
.0
	cmp.w	#$FF8C,d0	;compare -$74 to Xpos diff
	bgt.w	.1	;branch if greater than
	bset	#pf3gctrl,pflags3(a3)	;set goalie control bit?
	bra.w	.cont2
.1
	cmp.w	#$64,d1	;'d'   ; compare $64 to Ypos diff
	blt.w	.2	;branch if less than
	bset	#pf3gctrl,pflags3(a3)	;set goalie control bit?
	bra.w	.cont2
.2
	cmp.w	#$FF9C,d1	;compare -$64 to Ypos diff
	bgt.w	.cont2	;branch if greater than
	bset	#pf3gctrl,pflags3(a3)	;set goalie control bit?
.cont2
	movem.w	(sp)+,d0-d1	;pop from stack
	btst	#pf3gctrl,pflags3(a3)	;check goalie ctrl bit
	bne.w	checkanim	;branch if set
.na
	btst	#5,pflags(a3)	;check if anim lock
	bne.w	rtsskate	;exit if so
	bsr.w	check4bench
	bclr	#1,pflags(a3)	;clear new assignment bit
	beq.w	.nna	;branch if already cleared
	clr.w	temp1(a3)	;clear temp1
	move.w	#8,temp2(a3)	;move 8 into temp2
	st	temp4(a3)	;FFFF to temp4
.nna
	btst	#1,pflags2(a3)	;check if anim in progress
	bne.w	rtsskate	;exit if so
	btst	#0,(gmode).w	;check if clock stopped
	bne.w	rtsskate	;exit if so
	tst.w	temp5(a3)	;test temp5
	bmi.w	.nofo	;branch if less than 0
	move.w	SCnum(a3),d0	;move SCnum into d0
	cmp.w	(puckc).w,d0	;check if puckc is goalie
	beq.w	.mbfo	;branch if equal
	st	temp5(a3)	;set temp5 to -1
	bra.w	.nofo
.mbfo
	sub.w	d7,temp5(a3)	;subtract d7(frames elapsed) from temp5
	bpl.w	.nofo	;branch if more than 0
	btst	#2,(BA_PS_flags).w	;check bit 2
	beq.w	.stoppage	;branch if not set
	bset	#4,(BA_PS_flags).w
	bra.w	.nofo
.stoppage
	move.l	#8,d0
	jsr	(AddPenalty2).l
.nofo
	sub.b	d7,temp1(a3)	;sub d7(frames elapsed) from temp1
	bpl.w	.ex	;branch if positive
	move.b	aidef(a3),d0	;DfA into d0
	beq.w	.3	;branch if value was 0
	btst	#6,(sflags7).w	;check if crowd meter broken
	beq.w	.3	;jump if not
	subq.b	#1,d0	;sub 1 from d0
.3
	lsr.b	#2,d0	;divide by 4
	move.b	d0,temp1(a3)	;move d0 into temp1
	move.w	SCnum(a3),d0	;move SCnum into d0
	cmp.w	(puckc).w,d0	;compare puckc to d0
	beq.w	*+4	;jump to assgoaliecpu if the same
.ex
	rts
; a3 = goalie

a2offsides	;Offsides on a2 (AddPenalty $10) when his team is offside and the puck is past the blue line ($6A;
	;94 $68). Called from a2touchpuck
	btst	#gmoffs,(gmode).w
	beq.w	.x
	move.w	(pucky).w,d0
	btst	#pfgoal,pflags(a2)
	bne.w	.0
	neg.w	d0
.0
	cmp.w	#$6A,d0	;94 $68
	blt.w	.x
	movea.w	#(tmstruct-M68K_RAM),a0
	btst	#pfteam,pflags(a2)
	beq.w	.1
	adda.w	#tmsize,a0
.1
	btst	#4,tmflags(a0)
	beq.w	.x
	btst	#gmhl,(gmode).w
	bne.w	.x
	exg	a2,a3
	move.l	#$10,d0
	jsr	(AddPenalty).l
	exg	a2,a3
.x
	rts

asseben	;asstab entry $13 (94 9). asseben (moved in; assben). Player a3 should exit the bench area.
	;95: x $98 (94 $88), facedir 7 (94 2), SPA $1E2A (94 $F6E)
	btst	#5,pflags(a3)
	bne.w	.x	;94 rtss4
	bclr	#1,pflags(a3)
	beq.w	.1
	clr.w	Xvel(a3)
	clr.w	Yvel(a3)
	move.w	SCnum(a3),d0
	subq.w	#6,d0
	bmi.w	.0
	addq.w	#1,d0
.0
	muls.w	#$E,d0
	move.w	d0,Ypos(a3)
	move.w	#$98,(a3)	;94 $88
	neg.w	(a3)
	move.w	#7,facedir(a3)	;94 2
	bset	#5,pflags(a3)
	move.w	#$1E2A,d1	;95 SPA (94 $F6E)
	jmp	(SetSPA).l
.1
	move.w	#4,facedir(a3)
	bclr	#pfnc,pflags(a3)
	bclr	#5,pflags2(a3)
	bclr	#2,pflags2(a3)
	clr.w	SPA(a3)
	move.w	#$1000,Xvel(a3)
	bra.w	assexit
.x
	rts

assdefdchase	;assdefd with the team defense mode at 1 and the other team on the puck: set $64 bit 7
	;(assnearest takes that). Within $1E of the puck with the carrier in the slot (sflags6 bit 5): skate at the carrier (or the loose
	;puck) half a step ahead. Puck in the defensive zone: the right defenseman takes the slot ($D9 out), the left one the middle between
	;the puck and the goal line. Else hold $26 off the middle at $C8 from the puck toward his goal, no deeper than the other forwards
	;(.lim). Then skateto and check4check2 with sflags10 bit 7 set
	bset	#7,pflags3(a3)
	move.w	(puckx).w,d0
	sub.w	(a3),d0
	bpl.w	.0
	neg.w	d0
.0
	cmp.w	#$1E,d0
	bgt.w	.far
	move.w	(pucky).w,d0
	sub.w	Ypos(a3),d0
	bpl.w	.1
	neg.w	d0
.1
	cmp.w	#$1E,d0
	bgt.w	.far
	btst	#5,(sflags6).w	;puck carrier in the slot
	beq.w	.far
	move.l	a2,-(sp)
	movea.l	#SortCords,a2
	move.w	(puckc).w,d0
	bpl.w	.2
	adda.l	#$E*SCstruct,a2	;no carrier: the puck
	bra.w	.3
.2
	asl.w	#7,d0
	adda.w	d0,a2
.3
	move.b	Xvel(a2),d0	;half a step ahead of it
	asr.b	#1,d0
	ext.w	d0
	add.w	(a2),d0
	move.b	Yvel(a2),d1
	asr.b	#1,d1
	ext.w	d1
	add.w	Ypos(a2),d1
	movea.l	(sp)+,a2
	move.w	#0,temp2(a3)
	bra.w	.go
.far
	move.w	#$56,d0	;puck inside the own blue line?
	add.w	(pucky).w,d0
	btst	#7,pflags(a3)
	beq.w	.4
	move.w	#$56,d0
	sub.w	(pucky).w,d0
.4
	tst.w	d0
	bmi.w	.out
	subq.b	#5,temp1(a3)
	cmpi.w	#2,position(a3)
	beq.w	.rd
	move.w	#$10B,d1	;left defenseman: halfway between the puck and the goal line
	sub.w	(pucky).w,d1
	btst	#7,pflags(a3)
	beq.w	.5
	move.w	#$FEF5,d1
	sub.w	(pucky).w,d1
.5
	asr.w	#1,d1
	add.w	(pucky).w,d1
	move.w	(puckx).w,d0
	asr.w	#1,d0
	bra.w	.go
.rd
	move.w	#$D9,d1	;right defenseman: the slot
	clr.w	d0
	btst	#7,pflags(a3)
	beq.w	.6
	neg.w	d1
.6
	bra.w	.go
	dc.w	0,-1,-1,-1,-1,1,1,1	;unused
.out
	move.w	#$26,d0
	cmpi.w	#2,position(a3)
	beq.w	.7
	neg.w	d0
.7
	move.w	#$FF38,d1
	tst.w	(pucky).w
	bpl.w	.8
	neg.w	d0
	neg.w	d1
.8
	add.w	(pucky).w,d1
	bsr.w	.lim
	bra.w	.go
.go
	lea	rtss21(pc),a0
	move.w	d0,temp3(a3)
	move.w	d1,temp4(a3)
	bsr.w	skateto
	bset	#7,(sflags10).w
	bsr.w	check4check2
	bclr	#7,(sflags10).w
	rts
	lea	rtss21(pc),a0	;unused
	move.w	d0,temp3(a3)
	move.w	d1,temp4(a3)
	bra.w	skateto
.lim	;d1 no deeper than $32 past the deepest available player of the other team (by net)
	move.w	d2,-(sp)
	move.w	d1,d3
	move.w	#5,d4
	btst	#7,pflags(a3)
	bne.w	.dn
	movea.l	#SortCords,a0
	btst	#6,pflags(a3)
	bne.w	.l0
	adda.w	#6*SCstruct,a0
.l0
	btst	#pfnc,pflags(a0)
	bne.w	.l1
	move.w	Ypos(a0),d2
	addi.w	#$32,d2
	cmp.w	d2,d3
	bgt.w	.l1
	move.w	d2,d3
.l1
	adda.w	#SCstruct,a0
	dbf	d4,.l0
	bra.w	.lx
.dn
	movea.l	#SortCords,a0
	btst	#6,pflags(a3)
	bne.w	.l2
	adda.w	#6*SCstruct,a0
.l2
	btst	#pfnc,pflags(a0)
	bne.w	.l3
	move.w	Ypos(a0),d2
	subi.w	#$32,d2
	cmp.w	d2,d3
	blt.w	.l3
	move.w	d2,d3
.l3
	adda.w	#SCstruct,a0
	dbf	d4,.l2
.lx
	move.w	d3,d1
	move.w	(sp)+,d2
	rts

setSlotBit	;sflags6 bit 5 (the slot) = the puck carrier is in the slot
	;in front of the goal (blue line $56; 94 $58). Called from DoGameFrame
	bclr	#5,(sflags6).w	;clears Slot Bit
	tst.w	(puckc).w
	bmi.w	.ex	;exit if no puckc
	movem.l	d0/a0,-(sp)
	movea.l	#SortCords,a0	;start of SCStructs
	move.w	(puckc).w,d0	;move puckc SCnum into d0
	asl.w	#7,d0	;mult by 128 decimal
	adda.w	d0,a0	;move to start of puckc SCstruct
	move.w	Ypos(a0),d0	;Ypos
	btst	#7,pflags(a0)	;pfgoal - which goal shooting at
	bne.w	.checkpos	;jump if top goal
	neg.w	d0	;negative d0
.checkpos
	cmp.w	#$56,d0	;compare to blueline (94 $58)
	blt.w	.restore	;branch if not in off zone
	cmpi.w	#$47,(a0)	;'G' ; compare X position to $47
	bgt.w	.restore	;branch if greater than 47
	cmpi.w	#$FFB9,(a0)	;compare X position to -$47
	blt.w	.restore	;branch if less than -47
	bset	#5,(sflags6).w	;set bit
.restore
	movem.l	(sp)+,d0/a0
.ex
	rts

assscore	;asstab entry $1C (94 7). assscore (moved in). Players after a goal: skate to the scoring end
	;celebrate. 95: the scorer, still skating fast ($5000 or more), does the celebration SPA $28DE at once; the scorer's pump is one of
	;two SPAs (.pumps)
	btst	#5,pflags(a3)
	bne.w	.x	;94 assfwatch
	bclr	#1,pflags(a3)
	beq.w	.nna
	bsr.w	.1
	move.w	#8,temp2(a3)
	move.w	#$5A,temp3(a3)
	tst.w	(Hpos).w
	bpl.w	.0
	neg.w	temp3(a3)
.0
	move.w	(Vpos).w,temp4(a3)
	move.w	(shotplayer).w,d0	;95: the scorer at speed
	cmp.w	SCnum(a3),d0
	bne.w	.nna
	move.w	Xvel(a3),d1
	bpl.w	.5
	neg.w	d1
.5
	move.w	Yvel(a3),d0
	bpl.w	.6
	neg.w	d0
.6
	add.w	d0,d1
	cmp.w	#$5000,d1
	blt.w	.nna
	move.w	#$78,temp1(a3)
	bset	#5,pflags(a3)
	move.w	#$28DE,d1
	jsr	(SetSPA).l
.nna
	movea.l	#.x,a0	;94 rtss2
	move.w	temp3(a3),d0
	move.w	temp4(a3),d1
	btst	#0,(gmode2).w	;start of code not in 92
	beq.w	.4
	tst.w	(shootoutdelay).w
	beq.w	.2
	subq.w	#1,(shootoutdelay).w
	bne.w	.2
	bset	#2,(sflags2).w
.2
	cmpi.w	#$98,(a3)	;94 $88
	bgt.w	.3
	cmpi.w	#$FF68,(a3)	;94 $FF78
	bgt.w	.4
.3
	clr.w	d1	;end of code not in 92
.4
	sub.w	d7,temp1(a3)
	bpl.w	.ckcon
	bset	#5,pflags(a3)
	move.w	#$234C,d1	;95 SPA (94 $E8A)
	move.w	(shotplayer).w,d0
	cmp.w	SCnum(a3),d0
	bne.w	.nopump
	move.w	#2,d0	;95: the scorer's pump, one of two (94 $EFC)
	jsr	(randomd0).l
	add.w	d0,d0
	movem.l	a0,-(sp)
	movea.l	#.pumps,a0
	move.w	0(a0,d0.w),d1
	movem.l	(sp)+,a0
.nopump
	jsr	(SetSPA).l
.1
	moveq	#$78,d0
	jsr	(randomd0).l
	move.w	d0,temp1(a3)
	rts
.ckcon
	btst	#3,pflags(a3)
	beq.w	skateto
.x
	rts
.pumps	;95 SPAs
	dc.w	$29B0,$280C,$29B0,$280C

assgoaliebreakwait	;asstab entry $1D (94 $20). assgoaliebreakwait (moved in)
	btst	#5,pflags(a3)	;check if animation locked
	bne.w	.exit	;exit if so
	btst	#2,(BA_PS_flags).w	;check if pen shot
	bne.w	.1	;branch if so
	btst	#0,(gmode2).w	;check for shootout
	bne.w	.1	;branch if so
	nop
	bra.w	assexit
.1
	clr.w	Xvel(a3)	;clear Xvel
	clr.w	Yvel(a3)	;clear Yvel
	movem.l	d0/a0,-(sp)	;push d0 and a0 on stack
	movea.l	#SortCords,a0	;Home SC Sctruct start
	move.w	(BA_Goalie_SCnum).w,d0	;move Goalie SCNum into d0
	asl.w	#7,d0	;shift d0 7 bits left
	adda.w	d0,a0	;add d0 to address a0
	move.w	#$191,Ypos(a3)	;move 401 decimal into Ypos
	btst	#7,pflags(a0)	;check if shooting up or down (a0 is goalie being shot on)
	bne.w	.popstack	;branch if shooting up
	move.w	#$FE6F,Ypos(a3)	;move -191 decimal into Ypos (goalie not being shot on)
.popstack
	movem.l	(sp)+,d0/a0
.exit
	rts
; players do nothing until faceoff is over

ChkGoalies	;A computer team down with its goalie in: pull him on a delayed penalty, else CPgoalie. Called from DoGameFrame
	btst	#gmclock,(gmode).w	;check if clock running
	bne.w	rtsskate
	movea.w	#(tmstruct-M68K_RAM),a2
	lea	tmsize(a2),a1
	moveq	#1,d0
	bsr.w	.chkgoalie
	moveq	#2,d0
	exg	a1,a2
.chkgoalie
	tst.w	tmgoalie(a2)	;check for goalie
	bmi.w	rtsskate	;no goalie, exit
	move.w	(puckc).w,d1	;move puck carrier SCnum into d1
	bmi.w	rtsskate
	subq.w	#6,d1
	cmpa.w	#(tmstruct-M68K_RAM),a2
	beq.w	.chkpen
	not.w	d1	;makes d1 negative if away team
.chkpen
	tst.w	d1
	bpl.w	rtsskate
	btst	#gmpendel,(gmode).w	;#gmpendel - delayed penalty called
	beq.w	.nopen
	st	tmgoalie(a2)	;sets to FFFF (no goalie)
	bra.w	setpersonel
.nopen
	cmp.w	(cont1team).w,d0
	beq.w	rtsskate	;exit if team is joy controlled
	cmp.w	(cont2team).w,d0
	beq.w	rtsskate	;exit if team is joy controlled
	move.w	(pucky).w,d1
	bra.w	CPgoalie

ReturnGoalies	;If the computer pulled its goalie, see if it should return him (CPgoalie on foy)
	movea.w	#(tmstruct-M68K_RAM),a2
	lea	tmsize(a2),a1
	moveq	#1,d0
	bsr.w	.r
	moveq	#2,d0
	exg	a1,a2
.r
	cmpi.w	#$FFFF,tmgoalie(a2)
	beq.w	rtsskate	;still no goalie
	clr.b	tmgoalie(a2)	;clear for goalie return
	cmp.w	(cont1team).w,d0
	beq.w	rtsskate	;exit if team is joy controlled
	cmp.w	(cont2team).w,d0
	beq.w	rtsskate	;exit if team is joy controlled
	move.w	(foy).w,d1

CPgoalie	;See if the computer should pull its goalie: third period, behind by 2, a minute left, the faceoff in the other
	;zone (d1 = faceoff y). CPgoalie.0 is where was mapped; the routine ends at $0836AB
	cmpi.w	#2,(gsp).w	;check if 3rd period
	bne.w	rtsskate	;exit if not
	move.w	tmscore(a1),d0	;tmscore
	sub.w	tmscore(a2),d0
	bmi.w	rtsskate	;exit if leading in the game
	cmp.w	#2,d0
	bne.w	rtsskate	;exit if behind by more than 2
	cmpi.w	#$3C,(gameclock).w	;'<' ; #60
	bgt.w	rtsskate	;exit if more than 1 min left
	move.l	a0,-(sp)
	movea.w	tmsort(a2),a0	;moves a player struct address into a0
	btst	#pfgoal,pflags(a0)	;#pfgoal
	movea.l	(sp)+,a0
	bne.w	.0
	neg.w	d1	;if shooting on bottom goal, make d1 negative
.0
	tst.w	d1
	bmi.w	rtsskate	;exit if d1 negative (faceoff in own zone)
	st	tmgoalie(a2)	;set to FFFF (no goalie)
	bra.w	setpersonel
