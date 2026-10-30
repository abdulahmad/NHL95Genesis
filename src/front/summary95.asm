;	The Scoring Summary and Penalty Summary screens, which list each goal and each penalty of the
;	game and scroll through them.

;	EA's compiler emits cmp #imm,Dn as CMP (Bxxx), SNASM emits CMPI (0Cxx). The source has the real cmp /
;	cmpi; fixopcodes.js patches the cmp encoding after assembly.

ScoringSummaryScreen				;"Scoring Summary": one 4 row entry per goal (6 bytes each from ScoreSum),
									;scrolled with up / down, start exits
	moveq	#9,d0
	moveq	#$19,d1
	move.l	#ControllerBgMap,(screenarg).l
	jsr	(DrawTeamScreen2).l
	jsr	(printbigz).l
	String	CC_Font3Pri,6,1,'Scoring',CC_Font3Pri,$14,1,'Summary',CC_Font3Pri,7,4,0
	move.w	#$2C,d0
	jsr	(PutTeamBlock).l
	addq.w	#3,(printx).w
	clr.w	d0
	jsr	(PutTeamBlock).l
	jsr	(printsmallz).l
	String	CC_SetMapAndPosition,4,3,0,7,CC_SetFont,3,'^^Per^^Time^^Tm^^Goal/Assist^^^^^^P/S^^^',CC_SetFont,0
	clr.l	d0
	move.w	(ScoreSumbytes).w,d0
	divu.w	#6,d0
	asl.w	#5,d0
	move.w	d0,(VertLineScrolling).w
	subi.w	#$80,d0
	bpl.w	.0
	clr.w	d0
.0
	move.w	d0,(SelectedPlayerIdx).w
	move.w	(VertLineScrolling).w,d0
.toend
	jsr	(vcountwait).l
	bsr.w	UpdateScoringScroll
	move.w	(VertLineScrolling).w,d0
	subq.w	#2,d0
	cmp.w	(SelectedPlayerIdx).w,d0
	bge.s	.toend
	clr.w	(PlayerScrollCtr).w
.2
	jsr	(vcountwait).l
	jsr	(ReadMenuJoy).l
	btst	#7,d3
	beq.w	.3
	jmp	(ExitStatsScreen).l
.3
	moveq	#-2,d0
	btst	#0,d3
	bne.w	.set
	neg.w	d0
	btst	#1,d3
	beq.w	.scroll
.set
	move.w	d0,(PlayerScrollCtr).w
.scroll
	bsr.w	CheckScoringScroll
	bra.s	.2

CheckScoringScroll					;Add the scroll speed (PlayerScrollCtr) to the scroll position within 0
									;... SelectedPlayerIdx, then UpdateScoringScroll
	move.w	(PlayerScrollCtr).w,d0
	beq.w	rtsScoringScroll
	add.w	(VertLineScrolling).w,d0
	bmi.w	rtsScoringScroll
	cmp.w	(SelectedPlayerIdx).w,d0
	bgt.w	rtsScoringScroll

UpdateScoringScroll					;Scroll to d0: on an entry boundary the arrows (DrawScrollArrowsPenalty)
									;and stop; the entry coming into view; VSRAM = position - $50
	move.w	(VertLineScrolling).w,d1
	move.w	d0,(VertLineScrolling).w
	ext.l	d0
	divs.w	#$20,d0
	swap	d0
	tst.w	d0
	bne.w	.0
	bsr.w	DrawScrollArrowsPenalty
	clr.w	(PlayerScrollCtr).w
.0
	andi.w	#$1F,d1
	bne.w	.2
	move.l	d0,-(sp)
	cmp.w	#$1E,d0
	bne.w	.1
	bsr.w	DrawScoringRowUp
.1
	move.l	(sp)+,d0
	cmp.w	#2,d0
	bne.w	.2
	bsr.w	DrawScoringRowDown
.2
	move.w	(disflags).w,-(sp)
	bset	#dfng,(disflags).w
	movea.l	#Vdata,a0
	move.l	#VSRAM_W+(2<<16),Vctrl-Vdata(a0)
	moveq	#-$50,d0
	add.w	(VertLineScrolling).w,d0
	move.w	d0,(a0)
	move.w	(sp)+,(disflags).w
	rts

DrawScoringRowUp					;The goal entry in the high word of d0 at the top of the window
	move.l	d0,-(sp)
	swap	d0
	moveq	#6,d3
	mulu.w	d0,d3
	jsr	(printz).l
	String	CC_Font2Pri,0,0
	move.w	(VertLineScrolling).w,d0
	lsr.w	#3,d0
	subq.w	#3,d0
	andi.w	#$1F,d0
	move.w	d0,(printy).w
	bsr.w	DrawScoringRow
	move.l	(sp)+,d0
	rts

DrawScoringRowDown					;Goal entry + 4 at the bottom of the window
	move.l	d0,-(sp)
	swap	d0
	addq.w	#4,d0
	moveq	#6,d3
	mulu.w	d0,d3
	jsr	(printz).l
	String	CC_Font2Pri,0,0
	move.w	(VertLineScrolling).w,d0
	lsr.w	#3,d0
	addi.w	#$10,d0
	andi.w	#$1F,d0
	move.w	d0,(printy).w
	bsr.w	DrawScoringRow
	move.l	(sp)+,d0
	rts

DrawScoringRow						;Goal entry d3: the time, the team, the goal type (GoalTypeTbl), the
									;scorer and the assists (PrintScorerName)
	move.w	(printy).w,-(sp)
	moveq	#$28,d0
	moveq	#4,d1
	move.w	#$7FF,d2
	jsr	(eraser).l
	move.w	(sp)+,(printy).w
	movea.w	#(ScoreSum-M68K_RAM),a0
	move.w	0(a0,d3.w),d0
	move.w	#2,(printx).w
	jsr	(FormatAndPrintTime).l
	movea.w	#(tmstruct-M68K_RAM),a2
	btst	#7,2(a0,d3.w)
	beq.w	.0
	adda.w	#tmsize,a2
.0
	movea.l	tmdata(a2),a1
	adda.w	4(a1),a1
	adda.w	(a1),a1
	move.w	#$D,(printx).w
	jsr	(print).l
	move.w	#$23,(printx).w
	lea	GoalTypeTbl(pc),a1
	move.b	2(a0,d3.w),d0
	andi.w	#$7F,d0
	jsr	(PrintSmallListItem).l
	move.w	#$11,(printx).w
	move.b	3(a0,d3.w),d0
	bsr.w	PrintScorerName
	move.w	#4,(printfontset).w
	move.w	#$13,(printx).w
	move.b	4(a0,d3.w),d0
	bsr.w	PrintScorerName
	move.w	#$13,(printx).w
	move.b	5(a0,d3.w),d0
	bsr.w	PrintScorerName
	clr.w	(printfontset).w
	rts

PrintScorerName						;Print player d0 (byte, negative = none) and go down a row
	ext.w	d0
	bmi.w	.0
	jsr	(FormatPlayerNumInitial).l
	jsr	(printsmall).l
.0
	addq.w	#1,(printy).w

rtsScoringScroll					;Shared rts of CheckScoringScroll
	rts

GoalTypeTbl							;ScoreSum byte 2 & $7F: SH2, SH, even, PP, PP2
	String	'SH2'
	String	'SH'
	String	' '
	String	'PP'
	String	'PP2'

DrawScrollArrowsPenalty				;Summary screen up / down arrows (ScrollArrowTbl). Saves d0-d1/a1
	movem.l	d0-d1/a1,-(sp)
	jsr	(printsmallz).l
	String	CC_SetMapAndPosition,$4,$3,$1,$9,CC_SetFont,$1,$0
	clr.w	d0
	move.w	(VertLineScrolling).w,d1
	tst.w	d1
	sgt	d0
	neg.b	d0
	cmp.w	(SelectedPlayerIdx).w,d1
	slt	d1
	neg.b	d1
	add.b	d1,d0
	add.b	d1,d0
	lea	ScrollArrowTbl(pc),a1
	jsr	(PrintSmallListItem).l
	movem.l	(sp)+,d0-d1/a1
	rts

ScrollArrowTbl						;None, up, down, both
	String	' ',CC_AddX,$FF,CC_AddY,$10,' ',CC_SetFont,$0
	String	'{',CC_AddX,$FF,CC_AddY,$10,' ',CC_SetFont,$0
	String	' ',CC_AddX,$FF,CC_AddY,$10,'}',CC_SetFont,$0
	String	'{',CC_AddX,$FF,CC_AddY,$10,'}',CC_SetFont,$0

PenaltySummaryScreen				;"Penalties": one 3 row entry per penalty (4 bytes each from PenSum,
									;PenSumLength), scrolled with up / down, start exits
	moveq	#9,d0
	moveq	#$19,d1
	move.l	#ControllerBgMap,(screenarg).l
	jsr	(DrawTeamScreen2).l
	jsr	(printbigz).l
	String	CC_Font3Pri,$B,$1,'Penalties',CC_Font3Pri,$7,$4,$0
	move.w	#$2C,d0
	jsr	(PutTeamBlock).l
	addq.w	#3,(printx).w
	clr.w	d0
	jsr	(PutTeamBlock).l
	jsr	(printsmallz).l
	String	CC_SetMapAndPosition,$4,$3,$0,$7,CC_SetFont,$3,'^^Per^^Time^^Tm^^Player/Penalty^^^min^^^',CC_SetFont,$0,$0
	clr.l	d0
	move.w	(PenSumLength).w,d0
	lsr.w	#2,d0
	mulu.w	#$18,d0
	move.w	d0,(VertLineScrolling).w
	subi.w	#$78,d0
	bpl.w	.0
	clr.w	d0
.0
	move.w	d0,(SelectedPlayerIdx).w
	move.w	(VertLineScrolling).w,d0
.toend
	jsr	(vcountwait).l
	bsr.w	UpdatePenaltyScroll
	move.w	(VertLineScrolling).w,d0
	subq.w	#2,d0
	cmp.w	(SelectedPlayerIdx).w,d0
	bge.s	.toend
	clr.w	(PlayerScrollCtr).w
.2
	jsr	(vcountwait).l
	jsr	(ReadMenuJoy).l
	btst	#7,d3
	beq.w	.3
	jmp	(ExitStatsScreen).l
.3
	moveq	#-2,d0
	btst	#0,d3
	bne.w	.set
	neg.w	d0
	btst	#1,d3
	beq.w	.scroll
.set
	move.w	d0,(PlayerScrollCtr).w
.scroll
	bsr.w	CheckPenaltyScroll
	bra.s	.2

CheckPenaltyScroll					;As CheckScoringScroll for the penalty summary
	move.w	(PlayerScrollCtr).w,d0
	beq.w	rtsPenaltyScroll
	add.w	(VertLineScrolling).w,d0
	bmi.w	rtsPenaltyScroll
	cmp.w	(SelectedPlayerIdx).w,d0
	bgt.w	rtsPenaltyScroll

UpdatePenaltyScroll					;Penalty summary: set VertLineScrolling = d0, stop on an entry boundary
									;(24 lines), draw the entry coming into view, VSRAM = VertLineScrolling -
									;$50
	move.w	(VertLineScrolling).w,d1
	move.w	d0,(VertLineScrolling).w
	ext.l	d0
	divs.w	#$18,d0
	swap	d0
	tst.w	d0
	bne.w	.0
	bsr.w	DrawScrollArrowsPenalty
	clr.w	(PlayerScrollCtr).w
.0
	ext.l	d1
	divs.w	#$18,d1
	swap	d1
	tst.w	d1
	bne.w	.2
	move.l	d0,-(sp)
	cmp.w	#$16,d0
	bne.w	.1
	bsr.w	DisplayPenaltyLineUp
.1
	move.l	(sp)+,d0
	cmp.w	#2,d0
	bne.w	.2
	bsr.w	DisplayPenaltyLineDown
.2
	move.w	(disflags).w,-(sp)
	bset	#dfng,(disflags).w
	movea.l	#Vdata,a0
	move.l	#VSRAM_W+(2<<16),Vctrl-Vdata(a0)
	move.w	#$FFB0,d0
	add.w	(VertLineScrolling).w,d0
	move.w	d0,(a0)
	move.w	(sp)+,(disflags).w

rtsPenaltyScroll					;Shared rts of CheckPenaltyScroll
	rts

DisplayPenaltyLineUp				;The penalty entry in the high word of d0 at the top of the window
	move.l	d0,-(sp)
	swap	d0
	move.w	d0,d3
	asl.w	#2,d3
	jsr	(printz).l
	String	CC_Font2Pri,$0,$0,$0
	move.w	(VertLineScrolling).w,d0
	lsr.w	#3,d0
	subq.w	#2,d0
	andi.w	#$1F,d0
	move.w	d0,(printy).w
	bsr.w	DisplayPenaltyEntry
	move.l	(sp)+,d0
	rts

DisplayPenaltyLineDown				;Penalty entry + 5 at the bottom of the window
	move.l	d0,-(sp)
	swap	d0
	addq.w	#5,d0
	move.w	d0,d3
	asl.w	#2,d3
	jsr	(printz).l
	String	CC_Font2Pri,$0,$0,$0
	move.w	(VertLineScrolling).w,d0
	lsr.w	#3,d0
	addi.w	#$F,d0
	andi.w	#$1F,d0
	move.w	d0,(printy).w
	bsr.w	DisplayPenaltyEntry
	move.l	(sp)+,d0
	rts

DisplayPenaltyEntry					;PenSum entry d3: time, team (bit 7 of byte 2 = away), minutes and name
									;from Penaltylist, player (byte 3)
	move.w	(printy).w,-(sp)
	moveq	#$28,d0
	moveq	#3,d1
	move.w	#$7FF,d2
	jsr	(eraser).l
	move.w	(sp)+,(printy).w
	movea.w	#(PenSum-M68K_RAM),a0
	move.w	(a0,d3.w),d0
	move.w	#2,(printx).w
	jsr	(FormatAndPrintTime).l
	movea.w	#(tmstruct-M68K_RAM),a2
	btst	#7,2(a0,d3.w)
	beq.w	.0
	adda.w	#tmsize,a2
.0
	movea.l	tmdata(a2),a1
	adda.w	4(a1),a1
	adda.w	(a1),a1
	move.w	#$D,(printx).w
	jsr	(print).l
	move.b	2(a0,d3.w),d0
	andi.w	#$7F,d0
	movea.l	#Penaltylist,a3
	adda.w	(a3,d0.w),a3
	clr.w	d0
	move.b	1(a3),d0
	jsr	(PushNumber).l
	move.w	#$23,(printx).w
	jsr	(print).l
	move.w	#$11,(printx).w
	clr.w	d0
	move.b	3(a0,d3.w),d0
	jsr	(FormatPlayerNumInitial).l
	jsr	(print).l
	addq.w	#1,(printy).w
	move.w	#$14,(printx).w
	move.w	#4,(printfontset).w
	lea	2(a3),a1
	jsr	(printsmall).l
	clr.w	(printfontset).w
	rts
