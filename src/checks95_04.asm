; $08A3FE  Adapted from checks94.asm: computer line changes, saved lines, team screens, doinput_cbut, player movement, the goal
;	Three runs in ROM order: checks94 CompLine ... goalieacc with the 95 saved line and team screen code ($8A3FE), the input94
;	doinput_cbut ... getGoalieSCnum ($8B734), checks94 dirtab ... the 95 controller setup screen ($8B9A8). Each routine comment names
;	its 94 file or says 95 only.
;	checks94 CompLine, AutoLineChange and goalieacc, the input94 goalie dive, with moved in: penalty94 SetupTeamForIntermission, chkatop
;	and ChkShotStat, attract94 EASportsScreen, period94 updatePPTeamTime; and 95 only code: the saved line set routines
;	(DefaultLineData, LoadTeamLines, CheckTeamLines ...) and six DrawTeamScreen variants.
;	IDA left CompLine, AutoLineChange, ReadTeamSRAM, FixSavedLines, the LineSlotFixTbl handlers and the DrawTeamScreen variants as dc.b
;	or as wrong code; they are read from the retail bytes. IDA hid printz Strings and DecompressGraphicsWithCallback remap bytes as
;	instructions; they are String / dc.b here. Local labels are numbered; the IDA local names are not kept.
;	EA's compiler emits cmp #imm,Dn as CMP (Bxxx), SNASM emits CMPI (0Cxx). The source has the real cmp / cmpi; fixopcodes.js patches the
;	cmp encoding after assembly.


CompLine	;(checks94) The computer picks a line for team a2 (a1 = other team): on a power play or penalty kill the better
	;of lines 3 / 4 or 5 / 6 by energy (getlinee); else from the tables by the other team's line and the score in period 3
	;(gsp 2), the first with energy above $C00
	movem.l	d0-d2/a0,-(sp)
	moveq	#3,d0
	move.w	tmap(a2),d1
	sub.w	tmap(a1),d1
	beq.w	.3
	bpl.w	.0
	addq.w	#2,d0
.0
	move.w	d0,-(sp)	;find pk/pp line
	bsr.w	getlinee
	move.w	d0,d1
	move.w	(sp),d0
	addq.w	#1,d0
	bsr.w	getlinee
	cmp.w	d0,d1
	bge.w	.1
	addq.w	#1,(sp)
.1
	move.w	(sp)+,tmline(a2)
.2
	movem.l	(sp)+,d0-d2/a0
	rts
.3
	cmpa.w	#(HmShots-M68K_RAM),a2
	bne.w	.6
	moveq	#2,d1
	lea	.5(pc),a0
	cmpi.w	#2,(gsp).w
	bne.w	.4
	move.w	tmscore(a2),d2
	cmp.w	tmscore(a1),d2
	beq.w	.4
	adda.w	#$E,a0
	bgt.w	.4
	adda.w	#$E,a0
.4
	move.w	tmline(a1),d1
	asl.w	#1,d1
	move.w	(a0,d1.w),d0
	bsr.w	getlinee
	cmp.w	#$C00,d0
	bls.w	.6
	move.w	(a0,d1.w),tmline(a2)
	bra.s	.2
.5
	dc.w	0,1,2,0,1,0,1
	dc.w	2,0,1,2,0,2,0
	dc.w	0,1,0,0,1,0,1
.6
	moveq	#2,d1
	lea	.8(pc),a0
	cmpi.w	#2,(gsp).w
	bne.w	.7
	move.w	tmscore(a2),d2
	cmp.w	tmscore(a1),d2
	beq.w	.7
	addq.w	#6,a0
	bgt.w	.7
	addq.w	#6,a0
.7
	move.w	(a0)+,d0
	bsr.w	getlinee
	cmp.w	#$C00,d0
	dbhi	d1,.7
	move.w	-(a0),tmline(a2)
	bra.w	.2
.8
	dc.w	0,1,2
	dc.w	0,2,1
	dc.w	0,1,0

AutoLineChange	;(checks94) Computer line change on the fly: puck in the player's own end (pucky 0-$56, 94 $58), one frame in 4,
	;not in line change mode, and the line tired (AvgCline $C00 or less): CompLine, SetPersonel, PrintScores1, then compshoot
	btst	#4,(sflags7).w
	bne.w	rtslc
	move.w	(pucky).w,d0
	btst	#7,pflags(a3)
	bne.w	.0
	neg.w	d0
.0
	tst.w	d0
	bmi.w	rtslc
	cmp.w	#$56,d0
	bgt.w	rtslc
	move.w	(VDP_CNTR).l,d0
	andi.w	#3,d0
	bne.w	rtslc
	btst	#3,pflags2(a3)
	bne.w	rtslc
	movea.w	#(HmShots-M68K_RAM),a2
	lea	tmsize(a2),a1
	btst	#6,pflags(a3)
	beq.w	.1
	exg	a2,a1
.1
	bsr.w	AvgCline
	cmp.w	#$C00,d0
	bhi.w	rtslc
	bsr.w	CompLine
	jsr	(SetPersonel).l
	jsr	(PrintScores1).l
	jmp	compshoot

SetupTeamForIntermission	;(penalty94) 93 name. Reset the bench (ResetBench), then for each team SetupTeamLine. Called from hockey95
	bsr.w	ResetBench
	movea.w	#(HmShots-M68K_RAM),a2
	lea	tmsize(a2),a3
	bsr.w	SetupTeamLine
	exg	a2,a3	;falls in for the other team

SetupTeamLine	;95 only. Team a3 (a2 = other team): ResetTeamEnergy, line 0, and with line changes on the power play line 3
	;or penalty kill line 5 when the players on ice (tmap) differ
	jsr	(ResetTeamEnergy).l
	clr.w	tmline(a3)
	tst.w	(OptLine).w
	bne.w	.0
	move.w	tmap(a3),d0
	sub.w	tmap(a2),d0
	beq.w	.0
	move.w	#3,tmline(a3)
	tst.w	d0
	bpl.w	.0
	move.w	#5,tmline(a3)
.0
	rts

ReadTeamSRAM	;95 only, no xref. Read $39 bytes of team d7 (0-$1B) from save RAM offset d0 to a0
	movem.l	d0/d7/a0,-(sp)
	cmp.w	#$1B,d7
	bgt.w	.0
	ext.l	d0
	mulu.w	#$39,d7
	add.l	d7,d0
	moveq	#$39,d1
	jsr	(ReadSRAM).l
.0
	movem.l	(sp)+,d0/d7/a0
	rts

DefaultLineData	;95 only. Copy the default line sets of the 28 teams (TeamList + 6, 8 x 8 bytes, then $64) to M68K_RAM+SRLines, the RAM copy of the save RAM lines.
	;Called from sram95
	movem.l	d0-d7/a0-a6,-(sp)
	movea.l	#M68K_RAM+SRLines,a0
	movea.l	#TeamList,a3
	move.w	#$1B,d1
	clr.w	d7
.0
	move.w	d7,d0
	asl.w	#2,d0
	movea.l	(a3,d0.w),a1
	adda.w	6(a1),a1
	move.w	#7,d2
.1
	move.b	(a1)+,(a0)+
	move.b	(a1)+,(a0)+
	move.b	(a1)+,(a0)+
	move.b	(a1)+,(a0)+
	move.b	(a1)+,(a0)+
	move.b	(a1)+,(a0)+
	move.b	(a1)+,(a0)+
	move.b	(a1)+,(a0)+
	dbf	d2,.1
	move.b	#$64,(a0)+
	addq.w	#1,d7
	dbf	d1,.0
	movem.l	(sp)+,d0-d7/a0-a6
	rts

LoadTeamLines	;95 only. The line sets of team struct a2 ($16C): from save RAM (SRLines + team * $41) when there is save RAM and
	;line changes are on, else from the team data. Jumped to from setup95_01
	tst.w	(OptLine).w
	beq.w	.3
	tst.w	(ValidSRAM).w
	bmi.w	.0
	movem.l	d0-d2,-(sp)
	move.l	#SRLines,d0
	move.w	$28(a2),d2
	mulu.w	#$41,d2
	add.l	d2,d0
	moveq	#$41,d1
	movea.l	#ThreeStars,a0
	jsr	(ReadSRAM).l
	movem.l	(sp)+,d0-d2
	btst	#6,(sflags11).w
	bne.w	.0
	bra.w	.1
.0
	movea.l	$1E(a2),a0
	adda.w	6(a0),a0
.1
	lea	$16C(a2),a1
	move.l	(a0)+,(a1)+
	move.l	(a0)+,(a1)+
	addq.w	#8,a0
	move.w	#$B,d0
.2
	move.l	(a0)+,(a1)+
	dbf	d0,.2
	rts
.3
	tst.w	(ValidSRAM).w
	bmi.w	.4
	movem.l	d0-d2,-(sp)
	move.l	#SRLines,d0
	move.w	$28(a2),d2
	mulu.w	#$41,d2
	add.l	d2,d0
	moveq	#$41,d1
	movea.l	#ThreeStars,a0
	jsr	(ReadSRAM).l
	movem.l	(sp)+,d0-d2
	bra.w	.5
.4
	movea.l	$1E(a2),a0
	adda.w	6(a0),a0
.5
	moveq	#$D,d0
	addq.w	#8,a0
	lea	$16C(a2),a1
.6
	move.l	(a0)+,(a1)+
	dbf	d0,.6
	rts

FixSavedLines	;95 only, no xref. Clamp the saved line slots of team d7 in the 4 TeamRecordSRAM records into the goalie /
	;defense / forward ranges (ReadAttributeNibbleD7, GetDefenseStartD7, GetPlayerCountD7) and write them back
	movem.l	d0-d7/a0-a6,-(sp)
	jsr	(ReadAttributeNibbleD7).l
	move.w	d0,d3
	jsr	(GetDefenseStartD7).l
	move.w	d0,d4
	jsr	(GetPlayerCountD7).l
	move.w	d0,d5
	move.w	#3,d6
.0
	movea.l	#TeamRecordSRAM,a0
	move.w	d6,d0
	asl.w	#3,d0
	move.l	4(a0,d0.w),d1
	move.l	(a0,d0.w),d0
	move.w	d7,d2
	mulu.w	d1,d2
	add.l	d2,d0
	movea.l	#ThreeStars,a0
	jsr	(ReadSRAM).l
	cmpi.b	#$64,-1(a0,d1.w)
	bne.w	.2
	movem.l	d0-d1/a0,-(sp)
	lsr.w	#3,d1
	subq.w	#1,d1
.1
	bsr.w	.3
	bsr.w	.5
	bsr.w	.5
	bsr.w	.7
	bsr.w	.7
	bsr.w	.7
	bsr.w	.9
	addq.w	#1,a0
	dbf	d1,.1
	movem.l	(sp)+,d0-d1/a0
	jsr	(WriteSRAM).l
.2
	dbf	d6,.0
	jsr	(MakeSRAMChecksum).l
	movem.l	(sp)+,d0-d7/a0-a6
	rts
.3
	cmp.b	(a0),d3
	bge.w	.4
	subq.b	#1,(a0)
	bra.s	.3
.4
	addq.w	#1,a0
	rts
.5
	cmp.b	(a0),d5
	bge.w	.6
	subq.b	#1,(a0)
	bra.s	.5
.6
	cmp.b	(a0),d4
	blt.s	.4
	addq.b	#1,(a0)
	bra.s	.6
.7
	cmp.b	(a0),d4
	bge.w	.8
	subq.b	#1,(a0)
	bra.s	.7
.8
	cmp.b	(a0),d3
	blt.s	.4
	addq.b	#1,(a0)
	bra.s	.8
.9
	cmp.b	(a0),d5
	bge.s	.4
	subq.b	#1,(a0)
	bra.s	.9

CheckSavedLines	;95 only. CheckTeamLines for tradeteam1 and tradeteam2. Called from the trade code
	movem.l	d0-d7/a0-a6,-(sp)
	move.w	(tradeteam1).w,d7
	bsr.w	CheckTeamLines
	move.w	(tradeteam2).w,d7
	bsr.w	CheckTeamLines
	movem.l	(sp)+,d0-d7/a0-a6
	rts

CheckTeamLines	;95 only. Check the saved lines of team d7 in the 4 TeamRecordSRAM records ($64 marks a valid one): each slot
	;with bit 7 set is refilled by LineSlotFixTbl (slot & 7), then written back (WriteSRAM, MakeSRAMChecksum)
	movem.l	d0-d7/a0-a6,-(sp)
	move.w	#3,d6
.0
	movea.l	#TeamRecordSRAM,a0
	move.w	d6,d2
	asl.w	#3,d2
	move.l	(a0,d2.w),d0
	move.l	4(a0,d2.w),d1
	move.w	d1,(gameclock).w
	move.w	d7,d2
	mulu.w	d1,d2
	add.l	d2,d0
	movea.l	#ThreeStars,a0
	movem.l	d0-d1/a0,-(sp)
	jsr	(ReadSRAM).l
	cmpi.b	#$64,-1(a0,d1.w)
	bne.w	.4
	clr.w	d5
	subq.w	#2,d1
.1
	tst.b	(a0,d5.w)
	bpl.w	.2
	move.w	d5,d4
	andi.w	#7,d4
	asl.w	#2,d4
	movea.l	#LineSlotFixTbl,a2
	movea.l	(a2,d4.w),a2
	jsr	(a2)
.2
	addq.w	#1,d5
	dbf	d1,.1
	movem.l	(sp)+,d0-d1/a0
	jsr	(WriteSRAM).l
.3
	dbf	d6,.0
	jsr	(MakeSRAMChecksum).l
	movem.l	(sp)+,d0-d7/a0-a6
	rts
.4
	movem.l	(sp)+,d0-d1/a0
	bra.s	.3

LineSlotFixTbl	;95 only. CheckTeamLines slot handlers by slot & 7: goalie (the best one), defense, defense, forward, forward,
	;forward, extra, none
	dc.l	.0,.4,.4,.20,.20,.20,.33,.3
.0
	movem.l	d0-d7/a3,-(sp)
	jsr	(ReadAttributeNibbleD7).l
	subq.w	#1,d0
	move.w	d0,d1
	clr.w	d0
	clr.w	d6
	move.b	#$FF,d4
.1
	jsr	(GetRosterName).l
	adda.w	(a1),a1
	move.b	1(a1),d3
	andi.w	#$F,d3
	cmp.b	d4,d3
	ble.w	.2
	move.w	d0,d6
	move.b	d3,d4
.2
	addq.w	#1,d0
	dbf	d1,.1
	addq.w	#1,d6
	move.b	d6,(a0,d5.w)
	movem.l	(sp)+,d0-d7/a3
	rts
.3
	clr.b	(a0,d5.w)
	rts
.4
	movem.l	d0-d7/a0-a6,-(sp)
	bclr	#6,(sflags6).w
	jsr	(GetPlayerCountD7).l
	move.w	d0,d2
	jsr	(GetDefenseStartD7).l
	clr.w	d1
	movea.l	#linemarkbuf,a1
.5
	cmp.w	d0,d2
	ble.w	.8
	btst	#6,(sflags6).w
	bne.w	.6
	bsr.w	.17
	beq.w	.7
.6
	move.b	d0,(a1)+
	addq.w	#1,d1
.7
	addq.w	#1,d0
	bra.s	.5
.8
	tst.w	d1
	bne.w	.9
	bset	#6,(sflags6).w
	bra.w	.12
.9
	movea.l	#linemarkbuf,a1
	subq.w	#1,d1
	bmi.w	.12
	clr.w	d4
	move.b	#$FF,d3
.10
	move.b	(a1,d1.w),d0
	ext.w	d0
	movem.l	d6/a1,-(sp)
	jsr	(GetRosterName).l
	adda.w	(a1),a1
	move.b	1(a1),d2
	andi.w	#$F,d2
	move.b	2(a1),d6
	lsr.b	#4,d6
	andi.b	#$F,d6
	add.b	d6,d2
	move.b	3(a1),d6
	lsr.b	#4,d6
	andi.b	#$F,d6
	add.b	d6,d2
	move.b	4(a1),d6
	lsr.b	#4,d6
	andi.b	#$F,d6
	add.b	d6,d2
	movem.l	(sp)+,d6/a1
	cmp.b	d3,d2
	ble.w	.11
	move.w	d0,d4
	move.b	d2,d3
.11
	dbf	d1,.10
	addq.b	#1,d4
	move.b	d4,(a0,d5.w)
	bra.w	.16
.12
	jsr	(GetDefenseStartD7).l
.13
	addq.w	#1,d0
	movem.w	d1/d5,-(sp)
	andi.w	#$FFF8,d5
	move.w	#7,d1
.14
	cmp.b	(a0,d5.w),d0
	beq.w	.15
	addq.w	#1,d5
	dbf	d1,.14
.15
	tst.w	d1
	movem.w	(sp)+,d1/d5
	bpl.s	.13
	move.b	d0,(a0,d5.w)
.16
	movem.l	(sp)+,d0-d7/a0-a6
	rts
.17
	movem.l	d0-d2/a0,-(sp)
	move.w	(gameclock).w,d1
	subq.w	#2,d1
	addq.b	#1,d0
.18
	cmp.b	(a0,d1.w),d0
	beq.w	.19
	dbf	d1,.18
	move.w	#1,d0
.19
	movem.l	(sp)+,d0-d2/a0
	rts
.20
	movem.l	d0-d7/a0-a6,-(sp)
	bclr	#6,(sflags6).w
	jsr	(GetDefenseStartD7).l
	move.w	d0,d2
	jsr	(ReadAttributeNibbleD7).l
	clr.w	d1
	movea.l	#linemarkbuf,a1
.21
	cmp.w	d0,d2
	ble.w	.24
	btst	#6,(sflags6).w
	bne.w	.22
	bsr.s	.17
	beq.w	.23
.22
	move.b	d0,(a1)+
	addq.w	#1,d1
.23
	addq.w	#1,d0
	bra.s	.21
.24
	tst.w	d1
	bne.w	.25
	bset	#6,(sflags6).w
	bra.w	.28
.25
	movea.l	#linemarkbuf,a1
	subq.w	#1,d1
	bmi.w	.28
	clr.w	d4
	move.b	#$FF,d3
.26
	move.b	(a1,d1.w),d0
	ext.w	d0
	movem.l	d6/a1,-(sp)
	jsr	(GetRosterName).l
	adda.w	(a1),a1
	move.b	1(a1),d2
	andi.w	#$F,d2
	move.b	2(a1),d6
	andi.b	#$F,d6
	add.b	d6,d2
	move.b	2(a1),d6
	lsr.b	#4,d6
	andi.b	#$F,d6
	move.b	5(a1),d6
	andi.b	#$F,d6
	add.b	d6,d2
	move.b	5(a1),d6
	lsr.b	#4,d6
	andi.b	#$F,d6
	add.b	d6,d2
	movem.l	(sp)+,d6/a1
	cmp.b	d3,d2
	ble.w	.27
	move.w	d0,d4
	move.b	d2,d3
.27
	dbf	d1,.26
	addq.b	#1,d4
	move.b	d4,(a0,d5.w)
	bra.w	.32
.28
	jsr	(ReadAttributeNibbleD7).l
.29
	addq.w	#1,d0
	movem.w	d1/d5,-(sp)
	andi.w	#$FFF8,d5
	move.w	#7,d1
.30
	cmp.b	(a0,d5.w),d0
	beq.w	.31
	addq.w	#1,d5
	dbf	d1,.30
.31
	tst.w	d1
	movem.w	(sp)+,d1/d5
	bpl.s	.29
	move.b	d0,(a0,d5.w)
.32
	movem.l	(sp)+,d0-d7/a0-a6
	rts
.33
	movem.l	d0-d7/a0-a6,-(sp)
	jsr	(ReadAttributeNibbleD7).l
.34
	bsr.w	.17
	bne.w	.35
	addq.w	#1,d0
	bra.s	.34
.35
	addq.w	#1,d0
	move.b	d0,(a0,d5.w)
	movem.l	(sp)+,d0-d7/a0-a6
	rts

EASportsScreen	;(attract94) Called from Begin (main95). Show the EA Sports screen (EASportsMap) until a button, or $50 x 4
	;frames
	move.l	#vb2,(vbint).w	;vblank handler
	bclr	#1,(disflags).w
	move.w	#5,(Map3col1).w
	move.w	#$A000,(VmMap2).w
	move.w	#7,(Map2col1).w
	move.w	#$C000,(VmMap1).w
	move.w	#7,(Map1col1).w
	move.w	#$F000,(VmMap3).w
	move.w	#$F800,(VSPRITES).w
	move.w	#$FC00,(VSCRLPM).w
	movea.w	#(palfadenew-M68K_RAM),a0
	moveq	#$1F,d1	;32 longs: all 64 colours black
.0
	clr.l	(a0)+
	dbf	d1,.0
	jsr	(CopyPaletteToCRAM).l
	jsr	(setVram_0).l
	jsr	(printz).l
	String	$FE,0,0,0
	movea.l	#EASportsMap,a2
	movea.l	a2,a0
	movea.l	a2,a1
	adda.l	(a2)+,a0
	adda.l	(a2)+,a1
	clr.w	d0
	clr.w	d1
	move.w	(a1),d2
	move.w	2(a1),d3
	move.w	#1,d4
	moveq	#$F,d5
	jsr	(dobitmap).l
	move.w	#$18,(palcount).w	;fade in
	move	#$2500,sr	;vblank on
	move.w	#$50,(RNGseed).w	;frame count down in the random seed word
.1
	moveq	#4,d0
	jsr	(waitx).l
	tst.w	d1
	bne.w	.2
	subq.w	#1,(RNGseed).w
	bpl.s	.1
.2
	move	#$2700,sr
	jsr	(forceblack).l
	rts

chkatop	;(penalty94) Attack time of possession stat update. Called once a second from updatepentime
	moveq	#0,d1
	move.w	(pucky).w,d0
	cmp.w	#$56,d0
	bgt.w	.0
	move.l	#tmsize,d1
	neg.w	d0
	cmp.w	#$56,d0
	blt.w	.2
.0
	btst	#1,(gmode).w
	beq.w	.1
	eori.w	#tmsize,d1
.1
	movea.w	#(HmShots-M68K_RAM),a2
	addq.w	#1,tmATOP(a2,d1.w)	;attack time
.2
	rts

updatePPTeamTime	;(period94) Power play time of the teams, once a second. Called from updatepentime
	btst	#5,(sflags2).w	;check if PP
	beq.w	.1
	movea.l	#HmShots,a2	;move home team struct into a2
	btst	#6,(sflags2).w	;check who's on PP
	beq.w	.0	;branch if home (team 1)
	movea.l	#AwShots,a2	;move away team struct into a2
.0
	addq.w	#1,$354(a2)
.1
	rts

ChkShotStat	;(penalty94) Determine if a shot was taken and add it to the stats (crowd, team, shooter and goalie)
	btst	#0,(gmode).w	;gmclock: clock stopped
	bne.w	.10
	btst	#4,(gmode).w	;gmhl: highlight
	bne.w	.10
	bclr	#4,(sflags2).w	;sf2shot: shot taken
	bne.w	.4
	btst	#0,(sflags4).w
	beq.w	.10
	bclr	#3,(sflags8).w
	bne.w	.0
	bset	#3,(sflags8).w
	bra.w	.10
.0
	movem.l	d0-d1/a1-a3,-(sp)
	move.l	a4,-(sp)
	movea.l	#ChkCnt,a4
	adda.w	(ScoreSumbytes).w,a4
	movea.l	#HmShots,a2	;home team
	btst	#7,2(a4)	;entry flag: visitors
	beq.w	.1
	adda.w	#tmsize,a2
.1
	clr.w	d0
	move.b	3(a4),d0	;pnum (roster offset)
	movea.l	(sp)+,a4
	movea.w	tmsort(a2),a2
	move.w	#5,d1
.2
	cmp.b	$66(a2),d0	;pnum
	beq.w	.3
	adda.w	#SCstruct,a2
	dbf	d1,.2
	bra.w	.9
.3
	move.w	$52(a2),d0	;SCnum
	bra.w	.5
.4
	movem.l	d0-d1/a1-a3,-(sp)
	addi.w	#$64,(crowdlevel).w	;100
	addi.w	#$A,(CwdExciteLvl).w
	move.w	(shotplayer).w,d0
.5
	asl.w	#7,d0	;scsize
	movea.w	#(SortCords-M68K_RAM),a3
	adda.w	d0,a3
	jsr	(loadTeamStruct).l
	addq.w	#1,(a2)	;tmshots
	btst	#5,(sflags2).w	;sf2pwrplay
	beq.w	.8
	btst	#6,(sflags2).w	;sf2pwrtm: 0 home, 1 visitors
	bne.w	.7
	btst	#6,pflags(a3)
	bne.w	.8
.6
	addq.w	#1,$356(a2)
	bra.w	.8
.7
	btst	#6,pflags(a3)
	bne.s	.6
.8
	move.l	a2,-(sp)
	move.w	(gsp).w,d0	;period
	add.w	d0,d0
	adda.w	d0,a2
	addq.w	#1,$34C(a2)
	movea.l	(sp)+,a2
	clr.w	d0
	move.b	pnum(a3),d0
	addi.w	#$EA,d0
	addq.b	#1,(a2,d0.w)
	move.w	$26(a1),d0
	bmi.w	.9
	addi.w	#$EA,d0
	addq.b	#1,(a1,d0.w)
.9
	movem.l	(sp)+,d0-d1/a1-a3
.10
	rts

DrawTeamScreen2	;95 only. A DrawTeamScreen (optsetup95) for the season / stats screens: screenarg is the background bitmap; the
	;team block tiles (setupTeamBlocksMap), RosterFont at smallfontchars ... smallfont4chars with four remaps, BigFontMap2. d0 / d1 =
	;first row / row count of the bitmap
	movem.l	d0-d1/a2,-(sp)
	jsr	(forceblack).l
.0
	btst	#0,(disflags).w
	bne.s	.0
	clr.w	(Hscroll).w
	clr.w	(Vscroll).w
	jsr	(SetScroll2).l
	move.w	(disflags).w,-(sp)
	bset	#2,(disflags).w
	movea.l	#VDP_DATA,a0
	move.w	#$9100,4(a0)
	move.w	#$921C,4(a0)
	move.w	(VSPRITES).w,d0
	jsr	(Vmaddr).l
	move.l	#0,(a0)
	move.w	#$8C81,4(a0)
	move.w	#6,(Map3col1).w
	move.w	#$8D00,4(a0)
	clr.w	d0
	jsr	(Vmaddr).l
	move.l	#0,(a0)
	move.w	(sp)+,(disflags).w
	bclr	#1,(disflags).w
	moveq	#1,d4
	movem.l	a0-a6,-(sp)
	move.l	#Teamblocksmap,(teamblocksmapptr).l
	jsr	(setupTeamBlocksMap).l
	movem.l	(sp)+,a0-a6
	jsr	(printz).l
	String	$BD,0,0,0
	movea.l	(screenarg).w,a1
	adda.l	4(a1),a1
	movea.w	#ZeroLong,a2
	clr.w	d0
	clr.w	d1
	move.w	(a1),d2
	move.w	2(a1),d3
	moveq	#0,d5
	jsr	(dobitmap).l
	jsr	(printz).l
	String	$FD,0,0,0
	movem.l	(sp),d0-d1/a2
	add.w	d0,(printy).w
	movea.l	(screenarg).w,a0
	movea.l	a0,a1
	movea.l	a0,a2
	adda.l	(a2)+,a0
	adda.l	(a2)+,a1
	move.w	d1,d3
	sub.w	d0,d3
	move.w	d0,d1
	clr.w	d0
	moveq	#$28,d2
	moveq	#$F,d5
	jsr	(dobitmap).l
	move.w	d4,(smallfontchars).w
	move.l	#RosterFont,(smallfontptr).l
	movea.l	(smallfontptr).w,a2
	addq.w	#8,a2
	jsr	(DecompressGraphicsWithCallback).l
	dc.b	$04,$83,$45,$67,$89,$AB,$CD,$EF;remap table
	move.w	d4,(smallfont2chars).w
	movea.l	#RosterFont+8,a2
	jsr	(DecompressGraphicsWithCallback).l
	dc.b	$0C,$83,$45,$67,$89,$AB,$CD,$EF;remap table
	move.w	d4,(smallfont3chars).w
	movea.l	#RosterFont+8,a2
	jsr	(DecompressGraphicsWithCallback).l
	dc.b	$06,$83,$45,$67,$89,$AB,$CD,$EF;remap table
	move.w	d4,(smallfont4chars).w
	movea.l	#RosterFont+8,a2
	jsr	(DecompressGraphicsWithCallback).l
	dc.b	$16,$83,$45,$67,$89,$AB,$CD,$EF;remap table
	move.w	d4,(BigFontChars).w
	movea.l	#BigFontMap2+8,a2
	jsr	(DecompressGraphicsWithCallback).l
	dc.b	$81,$23,$45,$67,$89,$AB,$CD,$EF;remap table
	jsr	(printz).l
	String	$FE,0,0,0
	moveq	#$40,d0
	moveq	#$20,d1
	move.w	#$7FF,d2
	jsr	(eraser).l
	move.w	#$18,(palcount).w
	movem.l	(sp)+,d0-d1/a2
	rts

DrawTeamScreen3	;95 only. The same with SmallFontMap
	movem.l	d0-d1/a2,-(sp)
	jsr	(forceblack).l
.0
	btst	#0,(disflags).w
	bne.s	.0
	clr.w	(Hscroll).w
	clr.w	(Vscroll).w
	jsr	(SetScroll2).l
	move.w	(disflags).w,-(sp)
	bset	#2,(disflags).w
	movea.l	#VDP_DATA,a0
	move.w	#$9100,4(a0)
	move.w	#$921C,4(a0)
	move.w	(VSPRITES).w,d0
	jsr	(Vmaddr).l
	move.l	#0,(a0)
	move.w	#$8C81,4(a0)
	move.w	#6,(Map3col1).w
	move.w	#$8D00,4(a0)
	clr.w	d0
	jsr	(Vmaddr).l
	move.l	#0,(a0)
	move.w	(sp)+,(disflags).w
	bclr	#1,(disflags).w
	moveq	#1,d4
	movem.l	a0-a6,-(sp)
	move.l	#Teamblocksmap,(teamblocksmapptr).l
	jsr	(setupTeamBlocksMap).l
	movem.l	(sp)+,a0-a6
	jsr	(printz).l
	String	$BD,0,0,0
	movea.l	(screenarg).w,a1
	adda.l	4(a1),a1
	movea.w	#ZeroLong,a2
	clr.w	d0
	clr.w	d1
	move.w	(a1),d2
	move.w	2(a1),d3
	moveq	#0,d5
	jsr	(dobitmap).l
	jsr	(printz).l
	String	$FD,0,0,0
	movem.l	(sp),d0-d1/a2
	add.w	d0,(printy).w
	movea.l	(screenarg).w,a0
	movea.l	a0,a1
	movea.l	a0,a2
	adda.l	(a2)+,a0
	adda.l	(a2)+,a1
	move.w	d1,d3
	sub.w	d0,d3
	move.w	d0,d1
	clr.w	d0
	moveq	#$28,d2
	moveq	#$F,d5
	jsr	(dobitmap).l
	move.w	d4,(smallfontchars).w
	move.l	#SmallFontMap,(smallfontptr).l
	movea.l	#SmallFontMap+8,a2
	jsr	(DecompressGraphicsWithCallback).l
	dc.b	$0B,$83,$44,$67,$89,$AB,$CD,$EF;remap table
	move.w	d4,(smallfont2chars).w
	movea.l	#SmallFontMap+8,a2
	jsr	(DecompressGraphicsWithCallback).l
	dc.b	$8B,$83,$44,$67,$89,$AB,$CD,$EF;remap table
	move.w	d4,(smallfont3chars).w
	movea.l	#SmallFontMap+8,a2
	jsr	(DecompressGraphicsWithCallback).l
	dc.b	$0B,$83,$4C,$67,$89,$AB,$CD,$EF;remap table
	move.w	d4,(smallfont4chars).w
	movea.l	#SmallFontMap+8,a2
	jsr	(DecompressGraphicsWithCallback).l
	dc.b	$1B,$83,$4C,$67,$89,$AB,$CD,$EF;remap table
	move.w	d4,(BigFontChars).w
	movea.l	#BigFontMap2+8,a2
	jsr	(DecompressGraphicsWithCallback).l
	dc.b	$81,$23,$45,$67,$89,$AB,$CD,$EF;remap table
	jsr	(printz).l
	String	$FE,0,0,0
	moveq	#$40,d0
	moveq	#$20,d1
	move.w	#$7FF,d2
	jsr	(eraser).l
	move.w	#$18,(palcount).w
	movem.l	(sp)+,d0-d1/a2
	rts

DrawTeamScreen4NoSetup	;95 only. DrawTeamScreen4 without the screen setup (forceblack, scroll, vdp registers)
	movem.l	d0-d1/a2,-(sp)
	bra.w	DrawTeamScreen4Body

DrawTeamScreen4	;95 only. The same as DrawTeamScreen3, the team block tiles with dma (Teamblocksmap+8)
	movem.l	d0-d1/a2,-(sp)
	jsr	(forceblack).l
.0
	btst	#0,(disflags).w
	bne.s	.0
	clr.w	(Hscroll).w
	clr.w	(Vscroll).w
	jsr	(SetScroll2).l
	move.w	(disflags).w,-(sp)
	bset	#2,(disflags).w
	movea.l	#VDP_DATA,a0
	move.w	#$9100,4(a0)
	move.w	#$921C,4(a0)
	move.w	(VSPRITES).w,d0
	jsr	(Vmaddr).l
	move.l	#0,(a0)
	move.w	#$8C81,4(a0)
	move.w	#6,(Map3col1).w
	move.w	#$8D00,4(a0)
	clr.w	d0
	jsr	(Vmaddr).l
	move.l	#0,(a0)
	move.w	(sp)+,(disflags).w
	bclr	#1,(disflags).w

DrawTeamScreen4Body	;DrawTeamScreen4 after the screen setup; DrawTeamScreen4NoSetup branches here
	moveq	#1,d4
	movem.l	a0-a6,-(sp)
	movea.l	#Teamblocksmap+8,a2
	jsr	(DoDMA_clearCallbackPointer).l
	movem.l	(sp)+,a0-a6
	jsr	(printz).l
	String	$BD,0,0,0
	movea.l	(screenarg).w,a1
	adda.l	4(a1),a1
	movea.w	#ZeroLong,a2
	clr.w	d0
	clr.w	d1
	move.w	(a1),d2
	move.w	2(a1),d3
	moveq	#0,d5
	jsr	(dobitmap).l
	jsr	(printz).l
	String	$FD,0,0,0
	movem.l	(sp),d0-d1/a2
	add.w	d0,(printy).w
	movea.l	(screenarg).w,a0
	movea.l	a0,a1
	movea.l	a0,a2
	adda.l	(a2)+,a0
	adda.l	(a2)+,a1
	move.w	d1,d3
	sub.w	d0,d3
	move.w	d0,d1
	clr.w	d0
	moveq	#$28,d2
	moveq	#$F,d5
	jsr	(dobitmap).l
	move.w	d4,(smallfontchars).w
	move.l	#SmallFontMap,(smallfontptr).l
	movea.l	#SmallFontMap+8,a2
	jsr	(DecompressGraphicsWithCallback).l
	dc.b	$0B,$83,$44,$67,$89,$AB,$CD,$EF;remap table
	move.w	d4,(smallfont2chars).w
	movea.l	#SmallFontMap+8,a2
	jsr	(DecompressGraphicsWithCallback).l
	dc.b	$8B,$83,$44,$67,$89,$AB,$CD,$EF;remap table
	move.w	d4,(smallfont3chars).w
	movea.l	#SmallFontMap+8,a2
	jsr	(DecompressGraphicsWithCallback).l
	dc.b	$0B,$83,$4C,$67,$89,$AB,$CD,$EF;remap table
	move.w	d4,(smallfont4chars).w
	movea.l	#SmallFontMap+8,a2
	jsr	(DecompressGraphicsWithCallback).l
	dc.b	$1B,$83,$4C,$67,$89,$AB,$CD,$EF;remap table
	move.w	d4,(BigFontChars).w
	movea.l	#BigFontMap2+8,a2
	jsr	(DecompressGraphicsWithCallback).l
	dc.b	$81,$23,$45,$67,$89,$AB,$CD,$EF;remap table
	jsr	(printz).l
	String	$FE,0,0,0
	moveq	#$40,d0
	moveq	#$20,d1
	move.w	#$7FF,d2
	jsr	(eraser).l
	move.w	#$18,(palcount).w
	movem.l	(sp)+,d0-d1/a2
	rts

DrawTeamScreen5	;95 only. DrawTeamScreen4 with three small fonts and palette word $A00
	movem.l	d0-d1/a2,-(sp)
	jsr	(forceblack).l
.0
	btst	#0,(disflags).w
	bne.s	.0
	clr.w	(Hscroll).w
	clr.w	(Vscroll).w
	jsr	(SetScroll2).l
	move.w	(disflags).w,-(sp)
	bset	#2,(disflags).w
	movea.l	#VDP_DATA,a0
	move.w	#$9100,4(a0)
	move.w	#$921C,4(a0)
	move.w	(VSPRITES).w,d0
	jsr	(Vmaddr).l
	move.l	#0,(a0)
	move.w	#$8C81,4(a0)
	move.w	#6,(Map3col1).w
	move.w	#$8D00,4(a0)
	clr.w	d0
	jsr	(Vmaddr).l
	move.l	#0,(a0)
	move.w	(sp)+,(disflags).w
	bclr	#1,(disflags).w
	moveq	#1,d4
	movem.l	a0-a6,-(sp)
	movea.l	#Teamblocksmap+8,a2
	jsr	(DoDMA_clearCallbackPointer).l
	movem.l	(sp)+,a0-a6
	jsr	(printz).l
	String	$BD,0,0,0
	movea.l	(screenarg).w,a1
	adda.l	4(a1),a1
	movea.w	#ZeroLong,a2
	clr.w	d0
	clr.w	d1
	move.w	(a1),d2
	move.w	2(a1),d3
	moveq	#0,d5
	jsr	(dobitmap).l
	jsr	(printz).l
	String	$FD,0,0,0
	movem.l	(sp),d0-d1/a2
	add.w	d0,(printy).w
	movea.l	(screenarg).w,a0
	movea.l	a0,a1
	movea.l	a0,a2
	adda.l	(a2)+,a0
	adda.l	(a2)+,a1
	move.w	d1,d3
	sub.w	d0,d3
	move.w	d0,d1
	clr.w	d0
	moveq	#$28,d2
	moveq	#$F,d5
	jsr	(dobitmap).l
	move.w	d4,(smallfontchars).w
	move.l	#SmallFontMap,(smallfontptr).l
	movea.l	#SmallFontMap+8,a2
	jsr	(DecompressGraphicsWithCallback).l
	dc.b	$0B,$83,$44,$67,$89,$AB,$CD,$EF;remap table
	move.w	d4,(smallfont2chars).w
	movea.l	#SmallFontMap+8,a2
	jsr	(DecompressGraphicsWithCallback).l
	dc.b	$0B,$83,$4C,$67,$89,$AB,$CD,$EF;remap table
	move.w	d4,(smallfont3chars).w
	movea.l	#SmallFontMap+8,a2
	jsr	(DecompressGraphicsWithCallback).l
	dc.b	$E1,$23,$46,$67,$89,$AB,$CD,$EF;remap table
	move.w	d4,(BigFontChars).w
	movea.l	#BigFontMap2+8,a2
	jsr	(DecompressGraphicsWithCallback).l
	dc.b	$01,$23,$45,$67,$89,$AB,$CD,$EF;remap table
	jsr	(printz).l
	String	$FE,0,0,0
	moveq	#$40,d0
	moveq	#$20,d1
	move.w	#$7FF,d2
	jsr	(eraser).l
	move.w	#$A00,(palfadenew).w
	move.w	#$18,(palcount).w
	movem.l	(sp)+,d0-d1/a2
	rts

DrawTeamScreen6	;95 only. The team blocks (screen6chars1), the bitmap, Screen6Tiles1 / 2 (screen6chars2 / 3), three small fonts,
	;the big font and the framer (Framermap)
	movem.l	d0-d1/a2,-(sp)
	jsr	(forceblack).l
.0
	btst	#0,(disflags).w
	bne.s	.0
	clr.w	(Hscroll).w
	clr.w	(Vscroll).w
	jsr	(SetScroll2).l
	move.w	(disflags).w,-(sp)
	bset	#2,(disflags).w
	movea.l	#VDP_DATA,a0
	move.w	#$9100,4(a0)
	move.w	#$921C,4(a0)
	move.w	(VSPRITES).w,d0
	jsr	(Vmaddr).l
	move.l	#0,(a0)
	move.w	#$8C81,4(a0)
	move.w	#6,(Map3col1).w
	move.w	#$8D00,4(a0)
	clr.w	d0
	jsr	(Vmaddr).l
	move.l	#0,(a0)
	move.w	(sp)+,(disflags).w
	bclr	#1,(disflags).w
	moveq	#1,d4
	moveq	#1,d4
	movem.l	a0-a6,-(sp)
	move.l	#Teamblocksmap,(teamblocksmapptr).l
	jsr	(setupTeamBlocksMap).l
	movem.l	(sp)+,a0-a6
	move.w	d4,(screen6chars1).w
	jsr	(printz).l
	String	$BD,0,0,0
	movea.l	(screenarg).w,a1
	adda.l	4(a1),a1
	movea.w	#ZeroLong,a2
	clr.w	d0
	clr.w	d1
	move.w	(a1),d2
	move.w	2(a1),d3
	moveq	#0,d5
	jsr	(dobitmap).l
	jsr	(printz).l
	String	$FD,0,0,0
	movem.l	(sp),d0-d1/a2
	add.w	d0,(printy).w
	movea.l	(screenarg).w,a0
	movea.l	a0,a1
	movea.l	a0,a2
	adda.l	(a2)+,a0
	adda.l	(a2)+,a1
	move.w	d1,d3
	sub.w	d0,d3
	move.w	d0,d1
	clr.w	d0
	moveq	#$28,d2
	moveq	#0,d5
	jsr	(dobitmap).l
	move.w	d4,(screen6chars2).w
	movea.l	#Screen6Tiles1,a2
	jsr	(DoDMA_clearCallbackPointer).l
	move.w	d4,(screen6chars3).w
	movea.l	#Screen6Tiles2,a2
	jsr	(DoDMA_clearCallbackPointer).l
	move.w	d4,(smallfontchars).w
	move.l	#SmallFontMap,(smallfontptr).l
	movea.l	#SmallFontMap+8,a2
	jsr	(DecompressGraphicsWithCallback).l
	dc.b	$01,$23,$45,$67,$89,$AB,$CD,$EF;remap table
	move.w	d4,(smallfont2chars).w
	movea.l	#SmallFontMap+8,a2
	jsr	(DecompressGraphicsWithCallback).l
	dc.b	$01,$23,$46,$67,$89,$AB,$CD,$EF;remap table
	move.w	d4,(smallfont3chars).w
	movea.l	#SmallFontMap+8,a2
	jsr	(DecompressGraphicsWithCallback).l
	dc.b	$B1,$23,$46,$67,$89,$AB,$CD,$EF;remap table
	move.w	d4,(BigFontChars).w
	movea.l	#BigFontMap2+8,a2
	jsr	(DoDMA_clearCallbackPointer).l
	movea.l	#Framermap+8,a2
	move.l	#Framermap,(framermapptr).l
	move.w	d4,(framercset).w
	jsr	(DecompressGraphicsWithCallback).l
	dc.b	$07,$89,$A5,$6B,$89,$AB,$CD,$EF;remap table
	jsr	(printz).l
	String	$FE,0,0,0
	moveq	#$40,d0
	moveq	#$20,d1
	move.w	#$7FF,d2
	jsr	(eraser).l
	movem.l	(sp)+,d0-d1/a2
	rts

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
	;+$96. Jumped to from doinput (input95_01)
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

rtss15	;94 name. The rts of doinput_goaliedive
	rts

;------------------------------------------------------------------------------------------------------------------------
; $08B734  From input94.asm: doinput_cbut, ClampTargetY, doinput_chkanim, getGoalieSCnum
;	94 input94 doinput_cbut, ClampTargetY (with the 10 SPA offsets after it), doinput_chkanim and getGoalieSCnum (95 getGoalieSCnum).
;	doinput_onetimer / doinput_ispc are not in 95 here; doinput_islocked is in input95_01. IDA code.
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
;	IDA left SetGoaliesCtl and PeriodOver as dc.b and the last four routines as wrong code; they and the tables are read from the
;	retail bytes. IDA hid printz Strings and DecompressGraphicsWithCallback remap bytes as instructions; they are String / dc.b here.


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

Goal	;(checks94 checkgoal .goal) A goal: the shootout count (shootoutteam, sohomegoals / soawaygoals), EndPenaltyShotPlay, the
	;score summary (ScoreSum), the assignments of both teams (AssignTeam), PenGoalStuff
	btst	#2,(BA_PS_flags).w
	beq.w	.6
	btst	#0,(gmode2).w
	bne.w	.0
	movem.l	d0/a0,-(sp)
	move.w	(BA_Sktr_SCnum).w,d0
	asl.w	#7,d0
	movea.l	#SortCords,a0
	adda.w	d0,a0
	btst	#7,pflags(a0)
	movem.l	(sp)+,d0/a0
	bne.w	.1
	bra.w	.2
.0
	tst.w	(shootoutteam).w
	bne.w	.2
.1
	tst.w	(pucky).w
	bmi.w	rtsgoal
	bra.w	.3
.2
	tst.w	(pucky).w
	bpl.w	rtsgoal
.3
	bset	#5,(sflags4).w
	tst.w	(shootoutteam).w
	beq.w	.4
	addq.w	#1,(soawaygoals).w
	bra.w	.5
.4
	addq.w	#1,(sohomegoals).w
.5
	bset	#0,(sflags8).w
	jsr	(EndPenaltyShotPlay).l
	bra.w	.7
.6
	btst	#0,(gmode).w
	bne.w	rtsgoal
.7
	bset	#0,(sflags4).w
	bclr	#3,(sflags8).w
	bsr.w	ChkShotStat
	jsr	(play_new_song).l
	move.w	d0,-(sp)
	move.w	(vcount).w,d0
.8
	cmp.w	(vcount).w,d0
	beq.s	.8
	move.w	(sp)+,d0
	move.w	#0,-(sp)
	jsr	(sfx).l
	jsr	(LockScroll).l
	addi.w	#$1F4,(crowdlevel).w
	movea.w	#(HmShots-M68K_RAM),a2
	lea	tmsize(a2),a1
	tst.w	Ypos(a3)
	bpl.w	.9
	exg	a2,a1
.9
	btst	#1,(gmode).w
	beq.w	.10
	exg	a2,a1
.10
	addq.w	#1,tmscore(a2)
	btst	#5,(sflags4).w
	beq.w	.11
	btst	#0,(gmode2).w
	bne.w	.11
	addq.w	#1,$364(a2)
.11
	bclr	#4,(gmode2).w
	beq.w	.12
	addq.w	#1,$35C(a2)
.12
	btst	#5,(sflags2).w
	beq.w	.15
	btst	#6,(sflags2).w
	bne.w	.14
	cmpa.l	#AwShots,a2
	bne.w	.15
.13
	addq.w	#1,$358(a2)
	bra.w	.15
.14
	cmpa.l	#HmShots,a2
	beq.s	.13
.15
	movem.l	d0/a2,-(sp)
	move.w	(gsp).w,d0
	add.w	d0,d0
	adda.w	d0,a2
	addq.w	#1,$344(a2)
	movem.l	(sp)+,d0/a2
	bclr	#7,(sflags8).w
	beq.w	.16
	addq.w	#1,$360(a2)
.16
	cmpa.w	#(HmShots-M68K_RAM),a2
	bne.w	.17
	move.w	(HomeTeam).w,(HmTeam).w
	move.w	#3,(SongIndex).w
	jsr	(ChooseSong).l
	move.w	#$100,(songdelay).w
	move.w	(SongNum).w,-(sp)
	move.w	(sp)+,(delayedsong).w
.17
	cmpi.w	#$168,(ScoreSumbytes).w
	bne.w	.18
	subq.w	#6,(ScoreSumbytes).w
.18
	movea.w	#(ScoreSum-M68K_RAM),a0
	adda.w	(ScoreSumbytes).w,a0
	addq.w	#6,(ScoreSumbytes).w
	jsr	(GetPeriodTimeRemaining).l
	move.w	d0,(a0)+
	moveq	#2,d0
	add.w	tmap(a2),d0
	sub.w	$24(a1),d0
	move.b	d0,(a0)+
	addi.w	#$1E,(CwdExciteLvl).w
	cmpa.w	#(HmShots-M68K_RAM),a2
	beq.w	.19
	subi.w	#$14,(CwdExciteLvl).w
	bset	#7,-1(a0)
.19
	move.w	$18(a2),d0
	move.b	d0,(a0)+
	move.w	#$FFFF,(a0)
	addi.w	#$B6,d0
	movem.l	d0-d2,-(sp)
	move.w	$18(a2),d1
	jsr	(ReadAttributeNibble).l
	cmp.w	d0,d1
	movem.l	(sp)+,d0-d2
	blt.w	.20
	addq.b	#1,(a2,d0.w)
.20
	move.w	$1A(a2),d0
	bmi.w	.21
	cmp.w	$18(a2),d0
	beq.w	.21
	move.b	d0,(a0)+
	addi.w	#$D0,d0
	addq.b	#1,(a2,d0.w)
	move.w	$1C(a2),d0
	bmi.w	.21
	cmp.w	$18(a2),d0
	beq.w	.21
	move.b	d0,(a0)
	addi.w	#$D0,d0
	addq.b	#1,(a2,d0.w)
.21
	move.w	$26(a1),d0
	bmi.w	.22
	addi.w	#$B6,d0
	addq.b	#1,(a1,d0.w)
.22
	bsr.w	ChkShotStat
	btst	#2,(BA_PS_flags).w
	bne.w	.23
	bsr.w	PenGoalStuff
.23
	bclr	#3,(BA_PS_flags).w
	jsr	(PrintScores1).l
	move.w	#$2710,(crowdnoisedelay).w
	btst	#0,(gmode2).w
	beq.w	.24
	bra.w	.25
.24
	moveq	#$1C,d0
	bsr.w	AssignTeam
.25
	clr.w	(collflag).w
	clr.w	Xvel(a3)
	clr.w	Yvel(a3)
	moveq	#6,d0
	tst.w	(a3)
	bpl.w	.26
	neg.w	d0
.26
	move.w	d0,(a3)
	move.w	#$113,d0
	tst.w	Ypos(a3)
	bpl.w	.27
	neg.w	d0
.27
	move.w	d0,Ypos(a3)
	move.w	#$600,Zvel(a3)
	clr.w	Zpos(a3)
	st	(puckcross2).w
	st	(puckcross6).w
	bset	#2,pflags(a3)
	move.w	#5,d0
	jsr	(assreplace).l
	move.l	a3,-(sp)
	adda.w	#SCstruct,a3
	move.w	#$1F1E,d1
	bsr.w	SetSPA
	movea.w	$22(a1),a3
	moveq	#$E,d0
	bsr.w	AddPenalty2
	movea.l	(sp)+,a3
	rts

AssignTeam	;95 only. Give assignment d0 to every player of team a2 on the ice (assinsert)
	move.l	a3,-(sp)
	movea.w	tmsort(a2),a3
	moveq	#5,d3
.0
	tst.w	position(a3)
	ble.w	.2
	btst	#0,pflags2(a3)
	bne.w	.2
	bclr	#2,pflags(a3)
	bclr	#3,$64(a3)
	beq.w	.1
	jsr	(EndOneTimer).l
.1
	jsr	(assinsert).l
.2
	adda.w	#SCstruct,a3
	dbf	d3,.0
	movea.l	(sp)+,a3

rtsgoal	;The shared rts of Goal and AssignTeam
	rts

PenGoalStuff	;(penalty94) 93 name. Do this stuff after a goal: a1 = scored on team, a2 = scoring team. Clears PenBuf, lets the
	;first penalized player of the scored on team out (RemovePlayerFromList), erases the message box (box)
	movem.l	d0-d2/a0,-(sp)
	cmpi.w	#3,(gsp).w
	bne.w	.0
	bclr	#3,(gmode).w
	jsr	(ClearPenaltyBuffer).l
	bra.w	.1
.0
	cmpi.w	#6,$24(a1)
	bne.w	.1
	jsr	(ClearPenaltyBuffer).l
.1
	move.w	$24(a2),d2
	cmp.w	$24(a1),d2
	ble.w	.3
	lea	$9C(a1),a0
.2
	clr.w	d2
	move.b	(a0)+,d2
	bmi.w	.3
	btst	#6,$68(a1,d2.w)
	bne.s	.2
	clr.w	$68(a1,d2.w)
	bsr.w	RemovePlayerFromList
	bset	#0,(sflags9).w
	addq.w	#1,$24(a1)
	addq.w	#1,2(a2)
	bset	#0,(HmShots+tmflags).w	;home tmflags: tmflcc
	bset	#0,(AwShots+tmflags).w	;visitors tmflags: tmflcc
.3
	movem.l	(sp)+,d0-d2/a0
	rts

box	;(data94) Fill a $13 x 8 rectangle at printz position $FF,$B,2 with char $7FF (eraser)
	jsr	(printz).l
	String	$FF,$B,2,0
	moveq	#$13,d0
	moveq	#8,d1
	move.l	#$7FF,d2
	jmp	eraser

DisplayPlayerAttributeMenu	;(data94) 93 name. Goal box: close both line change boxes (lcfound2), then the scorer and the assists from
	;ScoreSum (PrintPlayerGoals / PrintPlayerAssists), the goalie counts (CountGoalies)
	movem.l	d0-d2/a0-a4,-(sp)
	btst	#2,(BA_PS_flags).w
	beq.w	.0
	bset	#2,(sflags2).w
.0
	movea.w	#(HmShots-M68K_RAM),a2
	jsr	(lcfound2).l	;close lc box
	adda.w	#tmsize,a2
	jsr	(lcfound2).l
	movea.w	#(ChkCnt-M68K_RAM),a4	;+ ScoreSumbytes = last goal entry
	adda.w	(ScoreSumbytes).w,a4
	jsr	(printz).l
	String	$BF,$B,2,0
	moveq	#$13,d0
	move.w	#5,d1	;5 rows: no assist
	tst.b	4(a4)
	bmi.w	.1
	addq.w	#2,d1	;7: one assist
	tst.b	5(a4)
	bmi.w	.1
	addq.w	#1,d1	;8: two assists
.1
	jsr	(Framer).l
	jsr	(CountGoalies).l
	movea.w	#(HmShots-M68K_RAM),a2
	move.w	(homegoalies).w,(recwins).w
	btst	#7,2(a4)
	beq.w	.2
	adda.w	#tmsize,a2
	move.w	(awaygoalies).w,(recwins).w
.2
	lea	GoalBigTxt(pc),a1
	bclr	#0,(sflags9).w
	beq.w	.3
	lea	PPGoalBigTxt(pc),a1
.3
	clr.w	d0
	move.b	3(a4),d0	;scorer
	addi.w	#$B6,d0
	cmpi.b	#3,(a2,d0.w)
	bne.w	.5
	movem.w	d1,-(sp)
	clr.w	d1
	move.b	3(a4),d1
	cmp.w	(recwins).w,d1
	movem.w	(sp)+,d1
	blt.w	.5
	adda.w	(a1),a1	;HAT TRICK!
	move.w	d0,-(sp)
	move.w	$28(a2),d0
	cmp.w	(HomeTeam).w,d0
	bne.w	.4
	move.w	#0,d0
.4
	move.w	(sp)+,d0
.5
	jsr	(printbig1).l
	clr.w	d0
	move.b	3(a4),d0
	move.w	d0,-(sp)
	move.w	#$C,(printx).w
	jsr	(FormatPlayerName).l
	jsr	(print).l
	move.w	(sp)+,d0
	movem.w	d1,-(sp)
	clr.w	d1
	move.b	3(a4),d1
	cmp.w	(recwins).w,d1
	movem.w	(sp)+,d1
	blt.w	.6
	jsr	(PrintPlayerGoals).l
.6
	clr.w	d0
	move.b	4(a4),d0	;first assist
	bmi.w	.7
	bclr	#5,(sflags4).w
	bne.w	.7
	jsr	(printz).l
	String	$BF,$E,6,'Assist by:',$BF,$C,7
	move.w	d0,-(sp)
	jsr	(FormatPlayerName).l
	jsr	(print).l
	move.w	(sp)+,d0
	jsr	(PrintPlayerAssists).l
	clr.w	d0
	move.b	5(a4),d0	;second assist
	bmi.w	.7
	jsr	(printz).l
	String	$BF,$C,8,0
	move.w	d0,-(sp)
	jsr	(FormatPlayerName).l
	jsr	(print).l
	move.w	(sp)+,d0
	jsr	(PrintPlayerAssists).l
.7
	bclr	#5,(sflags4).w
	movem.l	(sp)+,d0-d2/a0-a4
	rts

GoalBigTxt	;(data94) printbig Strings for DisplayPlayerAttributeMenu: GOAL!, then HAT TRICK!
	String	$BF,$F,3,'GOAL!',$BF,$C,5
	String	$BF,$C,3,'HAT TRICK!',$BF,$C,5

PPGoalBigTxt	;(data94) The same after a power play: PP GOAL!, then HAT TRICK!
	String	$BF,$D,3,'PP GOAL!',$BF,$C,5
	String	$BF,$C,3,'HAT TRICK!',$BF,$C,5

PrintPlayerAssists	;(title94) Print " (" and the assists of player d0 of team a2 (PrintParenNumber)
	movem.l	d0/a2,-(sp)
	jsr	(printz).l
	String	' ('
	adda.w	#$D0,a2
	bra.w	PrintParenNumber

PrintPlayerGoals	;(title94) Print " (" and the goals of player d0 of team a2
	movem.l	d0/a2,-(sp)
	jsr	(printz).l
	String	' ('
	adda.w	#$B6,a2

PrintParenNumber	;(title94) Print the number at d0 of a2 (1 to 3 digits) and ")"
	move.b	(a2,d0.w),d0
	ext.w	d0
	move.w	#1,d1
	cmp.w	#9,d0
	ble.w	.0
	move.w	#2,d1
	cmp.w	#$63,d0
	ble.w	.0
	move.w	#3,d1
.0
	jsr	(PushNumberWidth).l
	jsr	(print).l
	jsr	(printz).l
	String	')'
	addq.w	#1,(printy).w
	move.w	#$E,(printx).w
	movem.l	(sp)+,d0/a2
	rts

LockScroll	;95 only. xc1 / yc1 = Hpos / Vpos, sfslock
	move.w	(Vpos).w,(yc1).w
	move.w	(Hpos).w,(xc1).w
	bset	#6,(sflags).w
	rts

checkwindow	;(replay94) Scroll the window one step toward xc1 / yc1 (sflags bit 6) or the puck
	movem.l	d0-d3/a3,-(sp)
	move.w	(yc1).w,d2
	move.w	(xc1).w,d3
	btst	#6,(sflags).w
	bne.w	.2
	movea.l	#puckx,a3
	move.w	(puckc).w,d0
	bmi.w	.1
	asl.w	#7,d0
	movea.l	#SortCords,a3
	adda.w	d0,a3
	move.w	d7,d0
	add.w	d0,d0
	btst	#7,pflags(a3)
	beq.w	.0
	add.w	d0,(yleader).w
	cmpi.w	#$32,(yleader).w
	blt.w	.1
	move.w	#$32,(yleader).w
	bra.w	.1
.0
	sub.w	d0,(yleader).w
	cmpi.w	#$FFCE,(yleader).w
	bgt.w	.1
	move.w	#$FFCE,(yleader).w
.1
	move.w	Yvel(a3),d2
	asr.w	#7,d2
	add.w	Ypos(a3),d2
	add.w	(yleader).w,d2
	move.w	(a3),d3
.2
	move.w	d2,d0
	sub.w	(Vpos).w,d0
	cmp.w	#$FFF6,d0
	bge.w	.3
	move.w	d2,d1
	subi.w	#$FFF6,d1
	cmp.w	#$FF2E,d1
	bgt.w	.4
	move.w	#$FF2E,d1
	bra.w	.4
.3
	cmp.w	#$A,d0
	ble.w	.6
	move.w	d2,d1
	subi.w	#$A,d1
	cmp.w	#$F0,d1
	blt.w	.4
	move.w	#$F0,d1
.4
	sub.w	(Vpos).w,d1
	beq.w	.6
	asr.w	#4,d1
	bne.w	.5
	addq.w	#1,d1
.5
	move.w	(Vpos).w,d0
	add.w	d1,(Vpos).w
	move.w	(Vpos).w,d1
	eor.w	d1,d0
	bpl.w	.6
	clr.w	(SortCords+(12*SCstruct)+oldframe).w
	clr.w	(SortCords+(13*SCstruct)+oldframe).w
.6
	move.w	d3,d0
	sub.w	(Hpos).w,d0
	cmp.w	#$FFD8,d0
	bge.w	.7
	move.w	d3,d1
	subi.w	#$FFD8,d1
	cmp.w	#$FFCC,d1
	bge.w	.8
	move.w	#$FFCC,d1
	bra.w	.8
.7
	cmp.w	#$34,d0
	ble.w	.10
	move.w	d3,d1
	subi.w	#$28,d1
	cmp.w	#$34,d1
	ble.w	.8
	move.w	#$34,d1
.8
	sub.w	(Hpos).w,d1
	beq.w	.10
	asr.w	#4,d1
	bne.w	.9
	addq.w	#1,d1
.9
	add.w	d1,(Hpos).w
.10
	movem.l	(sp)+,d0-d3/a3
	rts

SetGoaliesCtl	;95 only. Practice Mode: pull the goalies the home / away goalie control (homegoaliectl / awaygoaliectl)
	;does not allow (GoalieCtlLimits by position): position -1, assignment $19
	movem.l	d0-d7/a0-a6,-(sp)
	movea.l	#SortCords,a0
	move.w	(homegoaliectl).w,d0
	bsr.w	.0
	movea.l	#SortCords+(6*SCstruct),a0
	move.w	(awaygoaliectl).w,d0
	bsr.w	.0
	movem.l	(sp)+,d0-d7/a0-a6
	rts
.0
	move.w	#5,d1
	movea.l	#GoalieCtlLimits,a1
.1
	move.w	d1,d2
	asl.w	#7,d2
	move.w	position(a0,d2.w),d3
	bmi.w	.3
	move.b	(a1,d3.w),d3
	andi.w	#$FF,d3
	cmp.w	d0,d3
	bgt.w	.3
.2
	dbf	d1,.1
	rts
.3
	move.w	#$FFFF,position(a0,d2.w)
	bset	#2,pflags2(a0,d2.w)
	bset	#2,pflags(a0,d2.w)
	move.w	#$FFFF,Zpos(a0,d2.w)
	movem.l	d0/a3,-(sp)
	move.w	#$19,d0
	lea	(a0,d2.w),a3
	jsr	(assreplace).l
	movem.l	(sp)+,d0/a3
	bra.s	.2

GoalieCtlLimits	;95 only. Goalie control value needed per position
	dc.b	0,4,5,2,1,3

GetGoalieCtl	;95 only. Test the goalie control of team d0 (1 home, else away)
	movem.l	a0,-(sp)
	movea.l	#homegoaliectl,a0
	cmp.w	#1,d0
	beq.w	.0
	movea.l	#awaygoaliectl,a0
.0
	tst.w	(a0)
	movem.l	(sp)+,a0
	rts

PracticeGoalies	;95 only. Practice Mode goalie setup (GetGoalieCtl)
	movem.l	d0-d1,-(sp)
	cmpi.w	#1,(cont1team).w
	beq.w	.0
	cmpi.w	#1,(cont2team).w
	beq.w	.0
	cmpi.w	#1,(cont3team).w
	beq.w	.0
	cmpi.w	#1,(cont4team).w
	bne.w	.1
.0
	move.w	#1,d0
	bsr.s	GetGoalieCtl
	bne.w	.1
	move.w	#0,(goaliemode1).w
.1
	cmpi.w	#2,(cont1team).w
	beq.w	.2
	cmpi.w	#2,(cont2team).w
	beq.w	.2
	cmpi.w	#2,(cont3team).w
	beq.w	.2
	cmpi.w	#2,(cont4team).w
	bne.w	.3
.2
	move.w	#2,d0
	bsr.w	GetGoalieCtl
	bne.w	.3
	move.w	#0,(goaliemode2).w
.3
	movem.l	(sp)+,d0-d1
	rts

PeriodOver	;(setup94) What to do if the period is over: next period, overtime or game over (gsp 4); Practice Mode
	;(sflags9 bit 7) ends the game; a season game with season flag bit 5 plays on in overtime. Then forceblack and IntermissionStart
	btst	#7,(sflags9).w
	bne.w	.2
	addq.w	#1,(gsp).w
	bchg	#1,(gmode).w
	cmpi.w	#3,(gsp).w
	blt.w	.3
	beq.w	.1
	move.w	#3,(gsp).w
	tst.w	(OptPlayMode).w
	bne.w	.1
	btst	#3,(GameFlags).w
	beq.w	.0
	btst	#5,(SeasonDay+1).w
	bne.w	.1
.0
	move.w	#4,(gsp).w
.1
	move.w	(HmGoals).w,d0
	sub.w	(AwGoals).w,d0
	beq.w	.3
.2
	move.w	#4,(gsp).w
.3
	jsr	(forceblack).l
	jmp	IntermissionStart

clockcont_0	;(hockey94) The clock ran out in overtime / the game: game over handling, the Stanley Cup (sflags13 bit 2, cupwinner)
	movea.w	#(puckx-M68K_RAM),a3
	moveq	#1,d0
	jsr	(assinsert).l
	cmpi.w	#2,(gsp).w	;periods 1-2 just end the period
	blt.w	.9
	moveq	#$1C,d0
	movea.w	#(SortCords-M68K_RAM),a3
	cmpi.w	#3,(gamelevel).w	;playoffs?
	bne.w	.5
	cmpi.w	#7,(bosgames).w
	beq.w	.2
	moveq	#$10,d3	;gssize
	mulu.w	(gamenum).w,d3
	movea.w	#(gsstruct-M68K_RAM),a0	;game structs (games stored for playoffs and box scores)
	adda.w	d3,a0
	clr.w	d3
	btst	#0,$E(a0)	;gsftf, gsflags(a0): teams are flipped
	beq.w	.0
	eori.w	#2,d3	;gspobwins-gspotwins
.0
	move.w	(HmGoals).w,d1
	sub.w	(AwGoals).w,d1
	bpl.w	.1
	eori.w	#2,d3
.1
	cmpi.w	#3,4(a0,d3.w)
	bne.w	.5
.2
	bset	#2,(sflags13).w
	move.w	(HmShots+$28).w,(cupwinner).w
	move.w	(HmGoals).w,d2
	cmp.w	(AwGoals).w,d2
	bgt.w	.3
	move.w	(AwShots+$28).w,(cupwinner).w
.3
	moveq	#$B,d2
.4
	bclr	#3,pflags(a3)
	adda.w	#SCstruct,a3
	dbf	d2,.4
	movea.w	#(SortCords-M68K_RAM),a3
.5
	moveq	#5,d2
	move.w	(HmGoals).w,d1
	sub.w	(AwGoals).w,d1
	beq.w	.9
	bpl.w	.6
	adda.w	#$300,a3
.6
	tst.w	position(a3)
	ble.w	.7
	jsr	(assinsert).l	;first skater gets d0, the rest get score
	moveq	#$1C,d0
.7
	adda.w	#SCstruct,a3
	dbf	d2,.6
.8
	jsr	(ClearPenaltyBuffer).l
	addi.w	#$3E8,(crowdlevel).w	;1000
	bset	#0,(gmode).w	;gmclock: stop clock
	bset	#6,(gmode).w	;set at end of game
	jsr	(ClearPenalties).l
	move.w	#4,d0	;PenEOG
	jmp	AddPenalty2
.9
	btst	#7,(sflags9).w
	bne.s	.8
	cmpi.w	#3,(gsp).w
	bne.w	.11
	btst	#3,(GameFlags).w
	beq.w	.10
	btst	#5,(SeasonDay+1).w
	bne.w	.11
.10
	tst.w	(OptPlayMode).w
	beq.s	.8
.11
	move.w	#2,d0
	jmp	AddPenalty2

GameOver	;(setup94) EncodePW, the Stanley Cup screen (sflags13 bit 2), SeasonGameOver, then ExitToOpening
	jsr	(EncodePW).l
	btst	#2,(sflags13).w
	beq.w	.0
	jsr	(StanleyCupScreen).l
.0
	jsr	(SeasonGameOver).l

ExitToOpening	;(setup94) jmp to the opening
	jmp	Opening2

clockcont	;(hockey94) Clock continue: when the clock is at 0 stop the play (sfx 4) and go to clockcont_0
	btst	#0,(gmode).w
	bne.w	.0
	tst.w	(gameclock).w
	bne.w	.0
	bset	#3,(disflags).w	;dfclock: clock needs update
	jsr	(play_new_song).l
	move.w	#4,-(sp)	;horn
	jsr	(sfx).l
	bsr.w	LockScroll
	jmp	clockcont_0
.0
	rts

SetContTeams	;95 only. The controller setup screen: pick the team of each pad (cont1team ... cont4team) and the Practice Mode
	;players and goalies
	tst.w	(demoflag).w
	bmi.w	.1
.0
	clr.w	(cont1team).w
	clr.w	(cont2team).w
	clr.w	(cont3team).w
	clr.w	(cont4team).w
	rts
.1
	clr.w	(setupvalues).w
	clr.w	(setupvalues+2).w
	move.w	#1,(cont1team).w
	clr.w	(cont2team).w
	clr.w	(cont3team).w
	clr.w	(cont4team).w
	bsr.w	ControllerSetupScreen
	bsr.w	PrintPracticeTitle
	bsr.w	DrawPadSetup
	btst	#7,(sflags9).w
	beq.w	.2
	bsr.w	PrintPracticeGoalies
.2
	move.w	#$18,(palcount).w
	bclr	#2,(disflags).w
	clr.w	(carddelay).w
.3
	move.w	(vcount).w,d0
.4
	cmp.w	(vcount).w,d0
	beq.s	.4
	addq.w	#1,(carddelay).w
	cmpi.w	#$5460,(carddelay).w
	bge.s	.0
	bsr.w	ReadAllPads
	tst.w	(TempLegSpd).w
	beq.w	.5
	clr.w	(carddelay).w
.5
	btst	#7,(TempLegSpd+1).w
	bne.w	.16
	btst	#1,(TempLegSpd+1).w
	beq.w	.6
	tst.w	(setupvalues).w
	bne.w	.6
	btst	#7,(sflags9).w
	beq.w	.6
	eori.w	#1,(setupvalues).w
	bsr.w	PrintPracticeTitle
.6
	btst	#0,(TempLegSpd+1).w
	beq.w	.7
	tst.w	(setupvalues).w
	beq.w	.7
	eori.w	#1,(setupvalues).w
	bsr.w	PrintPracticeTitle
.7
	move.w	#1,d4
	tst.w	(FourWayPlay).w
	beq.w	.8
	btst	#0,(gmode2).w
	bne.w	.8
	move.w	#3,d4
.8
	movea.l	#cont1team,a0
	movea.l	#TempWord1+1,a3
.9
	move.b	(a3),d1
	btst	#2,d1
	beq.w	.12
	tst.w	(setupvalues).w
	bne.w	.10
	move.w	(a0),d0
	cmp.w	#2,d0
	beq.w	.12
	movea.l	#ContTeamOrder1,a4
	move.b	(a4,d0.w),d0
	move.w	d0,(a0)
	bsr.w	DrawPadSetup
	bra.w	.15
.10
	subq.w	#1,(setupvalues+2).w
	bpl.w	.11
	move.w	#7,(setupvalues+2).l
.11
	bsr.w	PrintPracticeGoalies
	bra.w	.15
.12
	btst	#3,d1
	beq.w	.15
	tst.w	(setupvalues).w
	bne.w	.13
	move.w	(a0),d0
	cmp.w	#1,d0
	beq.w	.15
	movea.l	#ContTeamOrder2,a4
	move.b	(a4,d0.w),d0
	move.w	d0,(a0)
	bsr.w	DrawPadSetup
	bra.w	.15
.13
	addq.w	#1,(setupvalues+2).w
	cmpi.w	#7,(setupvalues+2).l
	ble.w	.14
	move.w	#0,(setupvalues+2).w
.14
	bsr.w	PrintPracticeGoalies
	bra.w	*+4
.15
	addq.w	#2,a0
	addq.w	#2,a3
	dbf	d4,.9
	bra.w	.3
.16
	rts

ContTeamOrder1	;95 only. Pad team order tables for SetContTeams
	dc.b	2,0,2,$FF

ContTeamOrder2
	dc.b	1,1,0,$FF

PrintPracticeGoalies	;95 only. Set homegoaliectl / awaygoaliectl from PracticeGoalieTbl and print them
	movem.l	d0-d7/a0-a6,-(sp)
	movea.l	#PracticeGoalieTbl,a0
	move.w	(setupvalues+2).w,d0
	add.w	d0,d0
	clr.w	(homegoaliectl).w
	move.b	(a0,d0.w),(homegoaliectl+1).w
	clr.w	(awaygoaliectl).w
	move.b	1(a0,d0.w),(awaygoaliectl+1).w
	move.w	#$19,(printy).w
	move.w	(homegoaliectl).w,d0
	move.w	#$1F,(printx).w
	bsr.w	PrintGoalieCount
	move.w	(awaygoaliectl).w,d0
	move.w	#8,(printx).w
	bsr.w	PrintGoalieCount
	movem.l	(sp)+,d0-d7/a0-a6
	rts

PrintGoalieCount	;95 only. Print GoalieCountTxt string d0 (PrintSetupStr)
	movea.l	#GoalieCountTxt,a1
	bra.w	.1
.0
	adda.w	(a1),a1
.1
	dbf	d0,.0
	bra.w	PrintSetupStr

GoalieCountTxt	;95 only. "0", "1", "2"
	String	'0'
	String	'1'
	String	'2'

PracticeGoalieTbl	;95 only. Home / away goalie control by Practice Mode setting
	dc.b	1,0,0,1,2,0,0,2,1,2,2,1,1,1,2,2

DrawPadSetup	;95 only. Draw the pads, their icons (DrawPadIcon) and the cursor (DrawPadCursor)
	movem.l	d0-d7/a0-a6,-(sp)
	move.w	#$A,(printy).w
	move.w	#1,d4
	tst.w	(FourWayPlay).w
	beq.w	.0
	btst	#0,(gmode2).w
	bne.w	.0
	move.w	#3,d4
.0
	movea.l	#cont1team,a0
	move.w	#0,d7
.1
	move.w	(printy).w,-(sp)
	subq.w	#1,(printy).w
	movea.l	#BlankLineTxt,a1
	bsr.w	PrintSetupStr
	addq.w	#1,(printy).w
	bsr.w	PrintSetupStr
	addq.w	#1,(printy).w
	bsr.w	PrintSetupStr
	jsr	(printz).l
	String	$FF,0,0,0
	move.w	(sp)+,(printy).w
	move.w	#$F,(printx).w
	tst.w	(a0)
	beq.w	.2
	move.w	#$1B,(printx).w
	cmpi.w	#1,(a0)
	beq.w	.2
	move.w	#3,(printx).w
.2
	bsr.w	DrawPadIcon
	bsr.w	DrawPadCursor
	addq.w	#2,a0
	addq.w	#3,(printy).w
	addq.w	#1,d7
	dbf	d4,.1
	movem.l	(sp)+,d0-d7/a0-a6
	rts

DrawPadIcon	;95 only. Draw pad icon d7 (PadIconMaps at PadIconChars)
	movem.l	d0-d7/a0-a6,-(sp)
	movea.l	#PadIconMaps,a0
	asl.w	#2,d7
	movea.l	(a0,d7.w),a0
	movea.l	#PadIconChars,a1
	movea.l	(a1,d7.w),a1
	move.w	(a1),d4
	movea.l	a0,a1
	movea.l	a0,a2
	adda.l	(a2)+,a0
	adda.l	(a2)+,a1
	clr.w	d0
	clr.w	d1
	moveq	#2,d2
	moveq	#2,d3
	moveq	#4,d5
	jsr	(dobitmap).l
	movem.l	(sp)+,d0-d7/a0-a6
	rts

PadIconMaps	;95 only. Pad icon bitmaps, then (PadIconChars) the RAM words with their chars
	dc.l	PadIconMap1,PadIconMap2,PadIconMap3,PadIconMap4

PadIconChars
	dc.l	padiconchars1,padiconchars2,padiconchars3,padiconchars4

DrawPadCursor	;95 only. Draw the pad cursor (PadCursorMap, padcursorchars) beside printx / printy
	move.w	(printx).w,-(sp)
	move.w	(printy).w,-(sp)
	movem.l	d0-d7/a0-a6,-(sp)
	move.w	(padcursorchars).w,d4
	movea.l	#PadCursorMap,a0
	movea.l	a0,a1
	movea.l	a0,a2
	adda.l	(a2)+,a0
	adda.l	(a2)+,a1
	clr.w	d0
	addq.w	#4,(printx).w
	clr.w	d1
	subq.w	#1,(printy).w
	moveq	#7,d2
	moveq	#3,d3
	moveq	#0,d5
	jsr	(dobitmap).l
	movem.l	(sp)+,d0-d7/a0-a6
	move.w	(sp)+,(printy).w
	move.w	(sp)+,(printx).w
	rts

BlankLineTxt	;95 only. A blank line
	String	$FD,$0,'                                        '

PrintPracticeTitle	;95 only. Practice Mode: print PracticePlayersTxt, highlighted (PrintSetupStrHi) when setupvalues is 0
	btst	#7,(sflags9).w
	beq.w	.1
	movea.l	#PracticePlayersTxt,a1
	tst.w	(setupvalues).w
	beq.w	.0
	bsr.w	PrintSetupStrHi
	bra.w	.1
.0
	bsr.w	PrintSetupStr
.1
	rts

PracticePlayersTxt	;95 only
	String	$FD,$C,$FC,$16,'PRACTICE PLAYERS',$FD,$19,$FC,$17,'No. of Players',$FD,$2,'No. of Players'

ControllerSetupScreen	;95 only. Build the controller setup screen: vram, fonts, the team blocks and pad tiles, the backgrounds and
	;"Controller SetUp" (printbigz); the team blocks of VisTeam / HomeTeam (DrawSetupTeamBlock)
	move.l	#VBlank_SetOptions,(vbint).w
	move	#$2500,sr
	bclr	#0,(disflags).w
	bset	#2,(disflags).w
	bclr	#1,(disflags).w
	move.w	#0,(VSCRLPM).w
	move.w	#$B400,(VSPRITES).w
	move.w	#$B800,(VmMap3).w
	move.w	#5,(Map3col1).w
	move.w	#$C000,(VmMap2).w
	move.w	#6,(Map2col1).w
	move.w	#$E000,(VmMap1).w
	move.w	#6,(Map1col1).w
	move.w	#0,d0
	jsr	(setvram).l
	jsr	(orjoy).l
	move.w	#1,d4
	move.w	d4,(smallfontchars).w
	movea.l	#RosterFont+8,a2
	jsr	(DoDMA_clearCallbackPointer).l
	move.w	d4,(smallfont2chars).w
	movea.l	#RosterFont+8,a2
	jsr	(DecompressGraphicsWithCallback).l
	dc.b	$05,$23,$45,$67,$89,$AB,$CD,$EF;remap table
	move.w	d4,(smallfont3chars).w
	movea.l	#RosterFont+8,a2
	jsr	(DecompressGraphicsWithCallback).l
	dc.b	$0D,$23,$45,$67,$89,$AB,$CD,$EF;remap table
	move.l	#RosterFont,(smallfontptr).l
	move.w	d4,(BigFontChars).w
	movea.l	#BigFontMap2+8,a2
	jsr	(DoDMA_clearCallbackPointer).l
	move.w	d4,(teamblocksmapptr).w
	movea.l	#Teamblocksmap+8,a2
	jsr	(DoDMA_clearCallbackPointer).l
	move.w	d4,(padcursorchars).w
	movea.l	#PadCursorMap+8,a2
	jsr	(DoDMA_clearCallbackPointer).l
	move.w	d4,(padiconchars1).w
	movea.l	#PadIconMap1+8,a2
	jsr	(DoDMA_clearCallbackPointer).l
	move.w	d4,(padiconchars2).w
	movea.l	#PadIconMap2+8,a2
	jsr	(DoDMA_clearCallbackPointer).l
	move.w	d4,(padiconchars3).w
	movea.l	#PadIconMap3+8,a2
	jsr	(DoDMA_clearCallbackPointer).l
	move.w	d4,(padiconchars4).w
	movea.l	#PadIconMap4+8,a2
	jsr	(DoDMA_clearCallbackPointer).l
	move.w	(VisTeam).w,d1
	jsr	(printz).l
	String	$BF,2,6,0
	bsr.w	DrawSetupTeamBlock
	move.w	(HomeTeam).w,d1
	jsr	(printz).l
	String	$BF,$1B,6,0
	bsr.w	DrawSetupTeamBlock
	jsr	(printz).l
	String	$FE,0,0,0
	movea.l	#ControllerBgMap,a0
	movea.l	a0,a1
	movea.l	a0,a2
	adda.l	(a2)+,a0
	adda.l	(a2)+,a1
	clr.w	d0
	clr.w	d1
	moveq	#$28,d2
	moveq	#$1C,d3
	moveq	#3,d5
	jsr	(dobitmap).l
	jsr	(printz).l
	String	$FE,$E,6,0
	movea.l	#ControllerTitleMap,a0
	movea.l	a0,a1
	movea.l	a0,a2
	adda.l	(a2)+,a0
	adda.l	(a2)+,a1
	clr.w	d0
	clr.w	d1
	moveq	#$C,d2
	moveq	#2,d3
	moveq	#0,d5
	jsr	(dobitmap).l
	jsr	(printbigz).l
	String	$BF,5,2,'Controller SetUp'
	rts

DrawSetupTeamBlock	;Wrong code in IDA. 95 only. Draw team block d1 (Teamblocksmap) at printx / printy
	movem.l	d0-d7/a0-a6,-(sp)
	clr.w	d0
	asl.w	#1,d1
	move.w	(teamblocksmapptr).w,d4
	movea.l	#Teamblocksmap,a0
	movea.l	a0,a1
	adda.l	(a0),a0
	adda.l	4(a1),a1
	movea.w	#ZeroLong,a2
	move.w	(a1),d2
	moveq	#2,d3
	moveq	#0,d5
	jsr	(dobitmap).l
	movem.l	(sp)+,d0-d7/a0-a6
	rts

PrintSetupStr	;Wrong code in IDA. 95 only. Print String a1 (printz2 $FE,5,$FF,1,$F9,0, then printsmall)
	movem.l	d0-d7/a0-a6,-(sp)
	move.l	a1,-(sp)
	jsr	(printz2).l
	String	$FE,5,$FF,1,$F9,0
	movea.l	(sp)+,a1
	jsr	(printsmall).l
	movem.l	(sp)+,d0-d7/a0-a6
	rts

PrintSetupStrHi	;Wrong code in IDA. 95 only. The same highlighted ($F9,1)
	movem.l	d0-d7/a0-a6,-(sp)
	move.l	a1,-(sp)
	jsr	(printz2).l
	String	$FE,5,$FF,1,$F9,1
	movea.l	(sp)+,a1
	jsr	(printsmall).l
	movem.l	(sp)+,d0-d7/a0-a6
	rts

ReadAllPads	;Wrong code in IDA. 95 only. Read the 4 pads (nodiag) into TempWord1, TempWord2, TempRawSpd and TempMaxSpd
	;(the same RAM as scratch here), all of them ored in TempLegSpd
	jsr	(ReadJoy1).l
	jsr	(nodiag).l
	move.w	d1,(TempWord1).w
	jsr	(ReadJoy2).l
	jsr	(nodiag).l
	move.w	d1,(TempWord2).w
	jsr	(ReadJoy3).l
	jsr	(nodiag).l
	move.w	d1,(TempRawSpd).w
	jsr	(ReadJoy4).l
	jsr	(nodiag).l
	move.w	d1,(TempMaxSpd).w
	move.w	(TempWord1).w,d1
	or.w	(TempWord2).w,d1
	or.w	(TempRawSpd).w,d1
	or.w	(TempMaxSpd).w,d1
	move.w	d1,(TempLegSpd).w
	rts
