; $08A056  Adapted from input94.asm and checks94.asm: line changes, computer lines, saved lines, team line screens
;	2 parts in ROM order, each under its banner below.
;	EA's compiler emits cmp #imm,Dn as CMP (Bxxx), SNASM emits CMPI (0Cxx). The source has the real cmp / cmpi / exg; fixopcodes.js patches
;	the cmp and exg encodings after assembly.

;------------------------------------------------------------------------------------------------------------------------
; $08A056  From input94.asm: line changes
;	94 SetLCmode, SetLCmode2, setlccords, getlchoice, getlchoice2, lineinput, lcfound, lcfound2, with linebar
;	getlinee and AvgCline moved in. CompLine follows at $08A3FE.
;except AvgCline (dc.b, read from the retail bytes). a printz String as instructions; it is String here. Local labels
;are numbered; the names are not kept.
;	95 changes: the team struct offsets, the zero long at $69A (94 $30A).



SetLCmode	;Open the line change box for team of player a3 (loadTeamStruct): not with line changes off (OptLine) or
	;sflags7 bit 4, once (tmflags bit 1); sets pflags2 bit 3 (line change mode) and falls into SetLCmode2
	tst.w	(OptLine).w
	bne.w	rtslc
	btst	#4,(sflags7).w
	bne.w	rtslc
	jsr	(loadTeamStruct).l
	bset	#1,tmflags(a2)
	bne.w	rtslc
	btst	#3,(sflags5).w
	bne.w	.0
	bclr	#2,(sflags).w
.0
	bclr	#3,(sflags).w
	bset	#3,pflags2(a3)

SetLCmode2	;93 name. a2 = team struct. Draw the line change box (box, Framer) with the line names (linelist) and their
	;energy bars (linebar)
	movem.l	d0-d7/a0-a6,-(sp)
	bsr.w	setlccords
	cmpi.w	#$F,(printy).w
	blt.w	.0
	bset	#0,(sflags3).w
	bra.w	.1
.0
	jsr	(box).l
	bsr.w	setlccords
.1
	jsr	(Framer).l
	subq.w	#2,(printy).w
	addq.w	#1,(printx).w
	moveq	#2,d4
.2
	move.w	d4,d0
	bsr.w	getlchoice
	tst.w	d0
	bmi.w	.5
	btst	#1,tmflags(a2)
	bne.w	.3
	cmp.w	$2E(a2),d4
	bne.w	.4
	move.w	tmline(a2),d0
.3
	movea.w	#(mesarea-M68K_RAM),a1
	move.l	#$44120,(a1)	;String length 4, 'A ' (94 the same)
	add.b	d4,2(a1)
	jsr	(print).l
	move.w	d0,-(sp)
	movea.l	#linelist,a1
	jsr	(PrintSmallListItem).l
	move.w	(sp)+,d0
	bsr.w	linebar
	subq.w	#5,(printx).w
.4
	subq.w	#1,(printy).w
.5
	dbf	d4,.2
	movea.l	tmdata(a2),a1
	adda.w	4(a1),a1
	adda.w	(a1),a1
	addq.w	#2,(printx).w
	jsr	(print).l
	movem.l	(sp)+,d0-d7/a0-a6
	rts

setlccords	;Set printx / printy for the line change box of team a2
	clr.w	d0
	cmpa.w	#(tmstruct-M68K_RAM),a2
	bne.w	.0
	eori.w	#$16,d0
.0
	btst	#1,(gmode).w
	beq.w	.1
	eori.w	#$16,d0
.1
	jsr	(printz).l
	String	-(TXPRI+TXMAP1),$16,0,0
	add.w	d0,(printy).w
	moveq	#2,d0
	bsr.w	getlchoice
	moveq	#6,d1
	tst.w	d0
	bpl.w	.2
	subq.w	#1,d1
	addq.w	#1,(printy).w
.2
	moveq	#9,d0
	rts

getlchoice	;d0 = the line for button d0 of team a2 (getlchoice2)
	movem.l	d1-d2,-(sp)
	move.w	$38A(a2),d2
	cmpa.w	#(tmstruct-M68K_RAM),a2
	beq.w	getlchoice2
	move.w	-$342(a2),d2

getlchoice2	;The line for choice d0 by the player difference (tmap of the two teams) and the current line (tmline);.tab
	sub.w	tmap(a2),d2
	beq.w	.0
	addi.w	#$15,d0
	tst.w	d2
	bmi.w	.0
	addi.w	#$15,d0
.0
	move.w	tmline(a2),d1
	add.w	d1,d0
	add.w	d1,d0
	add.w	d1,d0
	lea	.1(pc),a0
	move.b	(a0,d0.w),d0
	ext.w	d0
	movem.l	(sp)+,d1-d2
	rts
.1
	dc.b	0,1,2,1,2,0,2,0,1,0,1,2,0,1,2,0
	dc.b	1,2,0,1,2,3,4,$FF,3,4,$FF,3,4,$FF,3,4
	dc.b	$FF,4,3,$FF,3,4,$FF,3,4,$FF,5,6,$FF,5,6,$FF
	dc.b	5,6,$FF,5,6,$FF,5,6,$FF,5,6,$FF,6,5,$FF,$FF

lineinput	;Process input for line changes: d1 = new button presses (passmode first with sflags5 bit 3)
	movem.l	d1-d3/a0,-(sp)
	movea.l	#LineHoldFlag,a0
	btst	#6,d2
	bne.w	.0
	btst	#6,d3
	bne.w	.0
	clr.w	(a0,d4.w)
.0
	movea.w	#(tmstruct-M68K_RAM),a2
	btst	#6,pflags(a3)
	beq.w	.1
	adda.w	#tmsize,a2
.1
	bclr	#0,tmflags(a2)
	beq.w	.2
	bsr.w	lcfound2
	bsr.w	SetLCmode2
.2
	movem.l	(sp)+,d1-d3/a0
	move.w	d2,(rosterteam).w
	clr.w	d2
	movem.l	a0,-(sp)
	movea.l	#LineHoldFlag,a0
	tst.w	(a0,d4.w)
	movem.l	(sp)+,a0
	bne.w	.3
	btst	#6,(rosterteam+1).w
	beq.w	.3
	btst	#6,d3
	bne.w	.3
	bra.w	lcfound
.3
	addq.w	#1,d2
	btst	#4,(rosterteam+1).w
	beq.w	.4
	btst	#4,d3
	bne.w	.4
	bra.w	lcfound
.4
	addq.w	#1,d2
	btst	#5,(rosterteam+1).w
	beq.w	.5
	btst	#5,d3
	bne.w	.5
	bra.w	lcfound
.5
	btst	#3,pflags(a3)
	beq.w	.6
	btst	#5,pflags(a3)
	bne.w	.6
	btst	#0,pflags2(a3)
	beq.w	doplayeracc
.6
	rts

lcfound	;Line d2 was picked: store it ($2E), set tmline (getlchoice) and the players (SetPersonel); falls into lcfound2
	move.w	d2,d0
	move.w	d2,$2E(a2)
	bsr.w	getlchoice	;translate choice 0-2 into line number 0-6
	tst.w	d0
	bmi.w	rtslc
	bclr	#3,pflags2(a3)
	bset	#3,pflags(a3)
	jsr	(loadTeamStruct).l
	bclr	#1,tmflags(a2)
	move.w	d0,tmline(a2)
	jsr	(setpersonel).l

lcfound2	;Erase the line change box (eraser) and redraw the scores (PrintScores1)
	btst	#7,(sflags).w
	bne.w	rtslc
	bsr.w	setlccords
	bsr.w	setlccords
	cmpi.w	#$F,(printy).w
	blt.w	.0
	bclr	#0,(sflags3).w
.0
	addq.w	#1,d1
	move.w	#$7FF,d2
	jsr	(eraser).l
	jmp	printscores1

rtslc	;The shared rts of the line change routines (94 rtss2)
	rts

linebar	;93 name. Draw the energy bar of line d0 for team a2 at printx / printy (EnergyBarMap, 16 steps)
	movem.l	d0-d5/a0-a2,-(sp)
	bsr.w	getlinee
	move.w	(printa).w,-(sp)
	move.w	#$8000,(printa).w
	ext.l	d0
	divu.w	#$100,d0	;4096/16
	cmp.w	#$F,d0
	bls.w	.0
	moveq	#$F,d0
.0
	moveq	#$F,d1	;d1 = bar frame (15 = empty)
	sub.w	d0,d1
	clr.w	d0
	movea.l	#EnergyBarMap,a1
	adda.l	4(a1),a1
	movea.w	#ZeroLong,a2
	move.w	(a1),d2
	moveq	#1,d3
	move.w	(energybarchars).w,d4
	moveq	#0,d5
	jsr	(dobitmap).l
	move.w	(sp)+,(printa).w
	movem.l	(sp)+,d0-d5/a0-a2
	rts

getlinee	;d0 = line number, a2 = team struct. Return d0 = energy level of this line
	movem.l	d1-d5/a0-a3,-(sp)
	lea	$16C(a2),a1
	asl.w	#3,d0
	adda.w	d0,a1
	clr.l	d0
	clr.w	d1
	movea.l	#priolist,a0
	move.w	tmap(a2),d4
	bra.w	.1
.0
	clr.w	d5
	move.b	(a0,d4.w),d5
	beq.w	.1
	clr.w	d3
	move.b	(a1,d5.w),d3
	asl.w	#1,d3
	addq.w	#1,d1
	add.w	$32(a2,d3.w),d0
.1
	dbf	d4,.0
	divu.w	d1,d0
	movem.l	(sp)+,d1-d5/a0-a3
	rts

AvgCline	;93 name. Return d0 = average energy of the current line on team a2
	movem.l	d1-d3/a0,-(sp)
	clr.l	d0
	clr.w	d1
	moveq	#5,d2
	movea.w	tmsort(a2),a0
.0
	tst.w	position(a0)
	ble.w	.1
	clr.w	d3
	move.b	pnum(a0),d3
	add.w	d3,d3
	add.w	tmpde(a2,d3.w),d0
	addq.w	#1,d1
.1
	adda.w	#SCstruct,a0
	dbf	d2,.0
	tst.w	d1
	beq.w	.2
	divu.w	d1,d0
.2
	movem.l	(sp)+,d1-d3/a0
	rts

;------------------------------------------------------------------------------------------------------------------------
; $08A3FE  From checks94.asm: computer line changes, saved lines, team screens
;	CompLine and AutoLineChange, with moved in: SetupTeamForIntermission, chkatop and ChkShotStat
;	EASportsScreen, updatePPTeamTime; andcode: the saved line set routines (DefaultLineData, LoadTeamLines
;	CheckTeamLines ...) and six DrawTeamScreen variants. follows at
;	$08B4E0 (goalieacc).
;CompLine, AutoLineChange, ReadTeamSRAM, FixSavedLines, the LineSlotFixTbl handlers and the DrawTeamScreen variants as dc.b
;or as wrong code; they are read from the retail bytes. printz Strings and DecompressGraphicsWithCallback remap bytes as
;instructions; they are String / dc.b here. Local labels are numbered; the names are not kept.



CompLine	;The computer picks a line for team a2 (a1 = other team): on a power play or penalty kill the better
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
	cmpa.w	#(tmstruct-M68K_RAM),a2
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

chk4lc	;Computer line change on the fly: puck in the player's own end (pucky 0-$56, 94 $58), one frame in 4
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
	movea.w	#(tmstruct-M68K_RAM),a2
	lea	tmsize(a2),a1
	btst	#6,pflags(a3)
	beq.w	.1
	exg	a2,a1
.1
	bsr.w	AvgCline
	cmp.w	#$C00,d0
	bhi.w	rtslc
	bsr.w	CompLine
	jsr	(setpersonel).l
	jsr	(printscores1).l
	jmp	compshoot

SetupTeamForIntermission	;93 name. Reset the bench (ResetBench), then for each team SetupTeamLine.
	bsr.w	ResetBench
	movea.w	#(tmstruct-M68K_RAM),a2
	lea	tmsize(a2),a3
	bsr.w	SetupTeamLine
	exg	a2,a3	;falls in for the other team

SetupTeamLine	;Team a3 (a2 = other team): ResetTeamEnergy, line 0, and with line changes on the power play line 3
	;or penalty kill line 5 when the players on ice (tmap) differ
	jsr	(reenergizeteam).l
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

ReadTeamSRAM	;no xref. Read $39 bytes of team d7 (0-$1B) from save RAM offset d0 to a0
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

DefaultLineData	;Copy the default line sets of the 28 teams (TeamList + 6, 8 x 8 bytes, then $64) to M68K_RAM+SRLines, the RAM copy of the save RAM lines.
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

LoadTeamLines	;The line sets of team struct a2 ($16C): from save RAM (SRLines + team * $41) when there is save RAM and
	;line changes are on, else from the team data. Jumped to from InitTeamSructure
	tst.w	(OptLine).w
	beq.w	.3
	tst.w	(ValidSRAM).w
	bmi.w	.0
	movem.l	d0-d2,-(sp)
	move.l	#SRLines,d0
	move.w	Xvel(a2),d2
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
	move.w	Xvel(a2),d2
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

FixSavedLines	;no xref. Clamp the saved line slots of team d7 in the 4 TeamRecordSRAM records into the goalie /
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

CheckSavedLines	;CheckTeamLines for tradeteam1 and tradeteam2. Called from the trade code
	movem.l	d0-d7/a0-a6,-(sp)
	move.w	(tradeteam1).w,d7
	bsr.w	CheckTeamLines
	move.w	(tradeteam2).w,d7
	bsr.w	CheckTeamLines
	movem.l	(sp)+,d0-d7/a0-a6
	rts

CheckTeamLines	;Check the saved lines of team d7 in the 4 TeamRecordSRAM records ($64 marks a valid one): each slot
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

LineSlotFixTbl	;CheckTeamLines slot handlers by slot & 7: goalie (the best one), defense, defense, forward, forward
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

EASportsScreen	;Called from Begin (main95). Show the EA Sports screen (EASportsMap) until a button, or $50 x 4
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
	String	-TXMAP2,0,0,0
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
	move.w	#$50,(seed).w	;frame count down in the random seed word
.1
	moveq	#4,d0
	jsr	(waitx).l
	tst.w	d1
	bne.w	.2
	subq.w	#1,(seed).w
	bpl.s	.1
.2
	move	#$2700,sr
	jsr	(forceblack).l
	rts

chkatop	;Attack time of possession stat update. Called once a second from updatepentime
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
	movea.w	#(tmstruct-M68K_RAM),a2
	addq.w	#1,tmATOP(a2,d1.w)	;attack time
.2
	rts

updatePPTeamTime	;Power play time of the teams, once a second. Called from updatepentime
	btst	#5,(sflags2).w	;check if PP
	beq.w	.1
	movea.l	#tmstruct,a2	;move home team struct into a2
	btst	#6,(sflags2).w	;check who's on PP
	beq.w	.0	;branch if home (team 1)
	movea.l	#AwShots,a2	;move away team struct into a2
.0
	addq.w	#1,$354(a2)
.1
	rts

ChkShotStat	;Determine if a shot was taken and add it to the stats (crowd, team, shooter and goalie)
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
	movea.l	#tmstruct,a2	;home team
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
	move.w	SCnum(a2),d0	;SCnum
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

DrawTeamScreen2	;A DrawTeamScreen for the season / stats screens: screenarg is the background bitmap; the
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
	move.w	#VDPR_WINX,Vctrl-Vdata(a0)
	move.w	#VDPR_WINY+$1C,Vctrl-Vdata(a0)
	move.w	(VSPRITES).w,d0
	jsr	(Vmaddr).l
	move.l	#0,(a0)
	move.w	#VDPR_MODE4+$81,Vctrl-Vdata(a0)
	move.w	#6,(Map3col1).w
	move.w	#VDPR_HSCROLL,Vctrl-Vdata(a0)
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
	String	-(TXPRI+TXMAP3),0,0,0
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
	String	-TXMAP3,0,0,0
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
	String	-TXMAP2,0,0,0
	moveq	#$40,d0
	moveq	#$20,d1
	move.w	#$7FF,d2
	jsr	(eraser).l
	move.w	#$18,(palcount).w
	movem.l	(sp)+,d0-d1/a2
	rts

DrawTeamScreen3	;The same with SmallFontMap
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
	move.w	#VDPR_WINX,Vctrl-Vdata(a0)
	move.w	#VDPR_WINY+$1C,Vctrl-Vdata(a0)
	move.w	(VSPRITES).w,d0
	jsr	(Vmaddr).l
	move.l	#0,(a0)
	move.w	#VDPR_MODE4+$81,Vctrl-Vdata(a0)
	move.w	#6,(Map3col1).w
	move.w	#VDPR_HSCROLL,Vctrl-Vdata(a0)
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
	String	-(TXPRI+TXMAP3),0,0,0
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
	String	-TXMAP3,0,0,0
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
	String	-TXMAP2,0,0,0
	moveq	#$40,d0
	moveq	#$20,d1
	move.w	#$7FF,d2
	jsr	(eraser).l
	move.w	#$18,(palcount).w
	movem.l	(sp)+,d0-d1/a2
	rts

DrawTeamScreen4NoSetup	;DrawTeamScreen4 without the screen setup (forceblack, scroll, vdp registers)
	movem.l	d0-d1/a2,-(sp)
	bra.w	DrawTeamScreen4Body

DrawTeamScreen4	;The same as DrawTeamScreen3, the team block tiles with dma (Teamblocksmap+8)
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
	move.w	#VDPR_WINX,Vctrl-Vdata(a0)
	move.w	#VDPR_WINY+$1C,Vctrl-Vdata(a0)
	move.w	(VSPRITES).w,d0
	jsr	(Vmaddr).l
	move.l	#0,(a0)
	move.w	#VDPR_MODE4+$81,Vctrl-Vdata(a0)
	move.w	#6,(Map3col1).w
	move.w	#VDPR_HSCROLL,Vctrl-Vdata(a0)
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
	String	-(TXPRI+TXMAP3),0,0,0
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
	String	-TXMAP3,0,0,0
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
	String	-TXMAP2,0,0,0
	moveq	#$40,d0
	moveq	#$20,d1
	move.w	#$7FF,d2
	jsr	(eraser).l
	move.w	#$18,(palcount).w
	movem.l	(sp)+,d0-d1/a2
	rts

DrawTeamScreen5	;DrawTeamScreen4 with three small fonts and palette word $A00
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
	move.w	#VDPR_WINX,Vctrl-Vdata(a0)
	move.w	#VDPR_WINY+$1C,Vctrl-Vdata(a0)
	move.w	(VSPRITES).w,d0
	jsr	(Vmaddr).l
	move.l	#0,(a0)
	move.w	#VDPR_MODE4+$81,Vctrl-Vdata(a0)
	move.w	#6,(Map3col1).w
	move.w	#VDPR_HSCROLL,Vctrl-Vdata(a0)
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
	String	-(TXPRI+TXMAP3),0,0,0
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
	String	-TXMAP3,0,0,0
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
	String	-TXMAP2,0,0,0
	moveq	#$40,d0
	moveq	#$20,d1
	move.w	#$7FF,d2
	jsr	(eraser).l
	move.w	#$A00,(palfadenew).w
	move.w	#$18,(palcount).w
	movem.l	(sp)+,d0-d1/a2
	rts

DrawTeamScreen6	;The team blocks (screen6chars1), the bitmap, Screen6Tiles1 / 2 (screen6chars2 / 3), three small fonts
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
	move.w	#VDPR_WINX,Vctrl-Vdata(a0)
	move.w	#VDPR_WINY+$1C,Vctrl-Vdata(a0)
	move.w	(VSPRITES).w,d0
	jsr	(Vmaddr).l
	move.l	#0,(a0)
	move.w	#VDPR_MODE4+$81,Vctrl-Vdata(a0)
	move.w	#6,(Map3col1).w
	move.w	#VDPR_HSCROLL,Vctrl-Vdata(a0)
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
	String	-(TXPRI+TXMAP3),0,0,0
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
	String	-TXMAP3,0,0,0
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
	String	-TXMAP2,0,0,0
	moveq	#$40,d0
	moveq	#$20,d1
	move.w	#$7FF,d2
	jsr	(eraser).l
	movem.l	(sp)+,d0-d1/a2
	rts
