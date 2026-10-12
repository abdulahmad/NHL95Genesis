;	Goal, AssignTeam / rtsgoal, PenGoalStuff, box ... PPGoalBigTxt, PrintPlayerAssists ... PrintParenNumber, LockScroll,
;	checkwindow, SetGoaliesCtl ... PracticeGoalies, PeriodOver, clockcont_0, GameOver / ExitToOpening, clockcont, then the
;	controller setup screen (SetContTeams ... ReadAllPads). New in 95: the controller setup screen.
;	EA's compiler emits cmp #imm,Dn as CMP (Bxxx), SNASM emits CMPI (0Cxx). The source has the real cmp / cmpi / exg; fixopcodes.js patches
;	the cmp and exg encodings after assembly.

Goal	;(checkgoal.goal) A goal: the shootout count (shootoutteam, homeshootgoals / awayshootgoals), EndPenaltyShotPlay, the
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
	addq.w	#1,(awayshootgoals).w
	bra.w	.5
.4
	addq.w	#1,(homeshootgoals).w
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
	jsr	(stop_current_song).l
	move.w	d0,-(sp)
	move.w	(vcount).w,d0
.loop
	cmp.w	(vcount).w,d0
	beq.s	.loop
	move.w	(sp)+,d0
	move.w	#SFXsiren,-(sp)
	jsr	(sfx).l
	jsr	(LockScroll).l
	addi.w	#$1F4,(crowdlevel).w
	movea.w	#(tmstruct-M68K_RAM),a2
	lea	tmsize(a2),a1
	tst.w	Ypos(a3)
	bpl.w	.9
	exg	a2,a1
.9
	btst	#1,(gmode).w
	beq.w	.addg
	exg	a2,a1
.addg
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
	beq.w	.14
	btst	#6,(sflags2).w
	bne.w	.13
	cmpa.l	#AwShots,a2
	bne.w	.14
.loop2
	addq.w	#1,$358(a2)
	bra.w	.14
.13
	cmpa.l	#tmstruct,a2
	beq.s	.loop2
.14
	movem.l	d0/a2,-(sp)
	move.w	(gsp).w,d0
	add.w	d0,d0
	adda.w	d0,a2
	addq.w	#1,$344(a2)
	movem.l	(sp)+,d0/a2
	bclr	#7,(sflags8).w
	beq.w	.15
	addq.w	#1,$360(a2)
.15
	cmpa.w	#(tmstruct-M68K_RAM),a2
	bne.w	.16
	move.w	(HomeTeam).w,(HmTeam).w
	move.w	#3,(SongIndex).w
	jsr	(ChooseSong).l
	move.w	#$100,(songdelay).w
	move.w	(SongNum).w,-(sp)
	move.w	(sp)+,(delayedsong).w
.16
	cmpi.w	#$168,(ScoreSumbytes).w
	bne.w	.sum
	subq.w	#6,(ScoreSumbytes).w
.sum
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
	cmpa.w	#(tmstruct-M68K_RAM),a2
	beq.w	.home
	subi.w	#$14,(CwdExciteLvl).w
	bset	#7,-1(a0)
.home
	move.w	$18(a2),d0
	move.b	d0,(a0)+
	move.w	#$FFFF,(a0)
	addi.w	#$B6,d0
	movem.l	d0-d2,-(sp)
	move.w	$18(a2),d1
	jsr	(GetGoalieCount).l
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
	jsr	(printscores1).l
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

AssignTeam	;Give assignment d0 to every player of team a2 on the ice (assinsert)
	move.l	a3,-(sp)
	movea.w	tmsort(a2),a3
	moveq	#5,d3
.loop
	tst.w	position(a3)
	ble.w	.2
	btst	#0,pflags2(a3)
	bne.w	.2
	bclr	#2,pflags(a3)
	bclr	#pf3onetimer,pflags3(a3)
	beq.w	.1
	jsr	(EndOneTimer).l
.1
	jsr	(assinsert).l
.2
	adda.w	#SCstruct,a3
	dbf	d3,.loop
	movea.l	(sp)+,a3

rtsgoal	;The shared rts of Goal and AssignTeam
	rts

PenGoalStuff	;Do this stuff after a goal: a1 = scored on team, a2 = scoring team. Clears PenBuf, lets the
	;first penalized player of the scored on team out (RemovePlayerFromList), erases the message box
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
	ble.w	.ex
	lea	$9C(a1),a0
.2
	clr.w	d2
	move.b	(a0)+,d2
	bmi.w	.ex
	btst	#6,$68(a1,d2.w)
	bne.s	.2
	clr.w	$68(a1,d2.w)
	bsr.w	RemovePlayerFromList
	bset	#0,(sflags9).w
	addq.w	#1,$24(a1)
	addq.w	#1,2(a2)
	bset	#0,(tmstruct+tmflags).w	;home tmflags: tmflcc
	bset	#0,(AwShots+tmflags).w	;visitors tmflags: tmflcc
.ex
	movem.l	(sp)+,d0-d2/a0
	rts

box	;Fill a $13 x 8 rectangle at printz position $FF,$B,2 with char $7FF (eraser)
	jsr	(printz).l
	String	-TXMAP1,$B,2,0
	moveq	#$13,d0
	moveq	#8,d1
	move.l	#$7FF,d2
	jmp	eraser

ShowGoalBox	;Goal box: close both line change boxes (lcfound2), then the scorer and the assists from
	;ScoreSum (PrintPlayerGoals / PrintPlayerAssists), the goalie counts (CountGoalies)
	movem.l	d0-d2/a0-a4,-(sp)
	btst	#2,(BA_PS_flags).w
	beq.w	.0
	bset	#2,(sflags2).w
.0
	movea.w	#(tmstruct-M68K_RAM),a2
	jsr	(lcfound2).l	;close lc box
	adda.w	#tmsize,a2
	jsr	(lcfound2).l
	movea.w	#(ChkCnt-M68K_RAM),a4	;+ ScoreSumbytes = last goal entry
	adda.w	(ScoreSumbytes).w,a4
	jsr	(printz).l
	String	-(TXPRI+TXMAP1),$B,2,0
	moveq	#$13,d0
	move.w	#5,d1	;5 rows: no assist
	tst.b	4(a4)
	bmi.w	.frame
	addq.w	#2,d1	;7: one assist
	tst.b	5(a4)
	bmi.w	.frame
	addq.w	#1,d1	;8: two assists
.frame
	jsr	(Framer).l
	jsr	(CountGoalies).l
	movea.w	#(tmstruct-M68K_RAM),a2
	move.w	(homegoalies).w,(recwins).w
	btst	#7,2(a4)
	beq.w	.1
	adda.w	#tmsize,a2
	move.w	(awaygoalies).w,(recwins).w
.1
	lea	GoalBigTxt(pc),a1
	bclr	#0,(sflags9).w
	beq.w	.2
	lea	PPGoalBigTxt(pc),a1
.2
	clr.w	d0
	move.b	3(a4),d0	;scorer
	addi.w	#$B6,d0
	cmpi.b	#3,(a2,d0.w)
	bne.w	.print
	movem.w	d1,-(sp)
	clr.w	d1
	move.b	3(a4),d1
	cmp.w	(recwins).w,d1
	movem.w	(sp)+,d1
	blt.w	.print
	adda.w	(a1),a1	;HAT TRICK!
	move.w	d0,-(sp)
	move.w	Xvel(a2),d0
	cmp.w	(HomeTeam).w,d0
	bne.w	.3
	move.w	#0,d0
.3
	move.w	(sp)+,d0
.print
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
	blt.w	.5
	jsr	(PrintPlayerGoals).l
.5
	clr.w	d0
	move.b	4(a4),d0	;first assist
	bmi.w	.6
	bclr	#5,(sflags4).w
	bne.w	.6
	jsr	(printz).l
	String	-(TXPRI+TXMAP1),$E,6,'Assist by:',-(TXPRI+TXMAP1),$C,7
	move.w	d0,-(sp)
	jsr	(FormatPlayerName).l
	jsr	(print).l
	move.w	(sp)+,d0
	jsr	(PrintPlayerAssists).l
	clr.w	d0
	move.b	5(a4),d0	;second assist
	bmi.w	.6
	jsr	(printz).l
	String	-(TXPRI+TXMAP1),$C,8,0
	move.w	d0,-(sp)
	jsr	(FormatPlayerName).l
	jsr	(print).l
	move.w	(sp)+,d0
	jsr	(PrintPlayerAssists).l
.6
	bclr	#5,(sflags4).w
	movem.l	(sp)+,d0-d2/a0-a4
	rts

GoalBigTxt	;printbig Strings for ShowGoalBox: GOAL!, then HAT TRICK!
	String	$BF,$F,3,'GOAL!',$BF,$C,5
	String	$BF,$C,3,'HAT TRICK!',$BF,$C,5

PPGoalBigTxt	;The same after a power play: PP GOAL!, then HAT TRICK!
	String	$BF,$D,3,'PP GOAL!',$BF,$C,5
	String	$BF,$C,3,'HAT TRICK!',$BF,$C,5

PrintPlayerAssists	;Print " (" and the assists of player d0 of team a2 (PrintParenNumber)
	movem.l	d0/a2,-(sp)
	jsr	(printz).l
	String	' ('
	adda.w	#$D0,a2
	bra.w	PrintParenNumber

PrintPlayerGoals	;Print " (" and the goals of player d0 of team a2
	movem.l	d0/a2,-(sp)
	jsr	(printz).l
	String	' ('
	adda.w	#$B6,a2

PrintParenNumber	;Print the number at d0 of a2 (1 to 3 digits) and ")"
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

LockScroll	;xc1 / yc1 = Hpos / Vpos, sfslock
	move.w	(Vpos).w,(yc1).w
	move.w	(Hpos).w,(xc1).w
	bset	#6,(sflags).w
	rts

checkwindow	;Scroll the window one step toward xc1 / yc1 (sflags bit 6) or the puck
	movem.l	d0-d3/a3,-(sp)
	move.w	(yc1).w,d2
	move.w	(xc1).w,d3
	btst	#6,(sflags).w
	bne.w	.dd
	movea.l	#puckx,a3
	move.w	(puckc).w,d0
	bmi.w	.ok
	asl.w	#7,d0
	movea.l	#SortCords,a3
	adda.w	d0,a3
	move.w	d7,d0
	add.w	d0,d0
	btst	#7,pflags(a3)
	beq.w	.gd
	add.w	d0,(yleader).w
	cmpi.w	#$32,(yleader).w
	blt.w	.ok
	move.w	#$32,(yleader).w
	bra.w	.ok
.gd
	sub.w	d0,(yleader).w
	cmpi.w	#$FFCE,(yleader).w
	bgt.w	.ok
	move.w	#$FFCE,(yleader).w
.ok
	move.w	Yvel(a3),d2
	asr.w	#7,d2
	add.w	Ypos(a3),d2
	add.w	(yleader).w,d2
	move.w	(a3),d3
.dd
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
	ble.w	.2x
	move.w	d2,d1
	subi.w	#$A,d1
	cmp.w	#$F0,d1
	blt.w	.4
	move.w	#$F0,d1
.4
	sub.w	(Vpos).w,d1
	beq.w	.2x
	asr.w	#4,d1
	bne.w	.5
	addq.w	#1,d1
.5
	move.w	(Vpos).w,d0
	add.w	d1,(Vpos).w
	move.w	(Vpos).w,d1
	eor.w	d1,d0
	bpl.w	.2x
	clr.w	(SortCords+(12*SCstruct)+oldframe).w
	clr.w	(SortCords+(13*SCstruct)+oldframe).w
.2x
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

SetGoaliesCtl	;Practice Mode: pull the goalies the home / away goalie control (homegoaliectl / awaygoaliectl)
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
.loop
	move.w	d1,d2
	asl.w	#7,d2
	move.w	position(a0,d2.w),d3
	bmi.w	.3
	move.b	(a1,d3.w),d3
	andi.w	#$FF,d3
	cmp.w	d0,d3
	bgt.w	.3
.loop2
	dbf	d1,.loop
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
	bra.s	.loop2

GoalieCtlLimits	;Goalie control value needed per position
	dc.b	0,4,5,2,1,3

GetGoalieCtl	;Test the goalie control of team d0 (1 home, else away)
	movem.l	a0,-(sp)
	movea.l	#homegoaliectl,a0
	cmp.w	#1,d0
	beq.w	.0
	movea.l	#awaygoaliectl,a0
.0
	tst.w	(a0)
	movem.l	(sp)+,a0
	rts

PracticeGoalies	;Practice Mode goalie setup (GetGoalieCtl)
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

PeriodOver	;What to do if the period is over: next period, overtime or game over (gsp 4); Practice Mode
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

clockcont_0	;The clock ran out in overtime / the game: game over handling, the Stanley Cup (sflags13 bit 2, cupwinner)
	movea.w	#(puckx-M68K_RAM),a3
	moveq	#1,d0
	jsr	(assinsert).l
	cmpi.w	#2,(gsp).w	;periods 1-2 just end the period
	blt.w	.9
	moveq	#$1C,d0
	movea.w	#(SortCords-M68K_RAM),a3
	cmpi.w	#3,(gamelevel).w	;playoffs?
	bne.w	.t3
	cmpi.w	#7,(bosgames).w
	beq.w	.2
	moveq	#$10,d3	;gssize
	mulu.w	(gamenum).w,d3
	movea.w	#(gsstruct-M68K_RAM),a0	;game structs (games stored for playoffs and box scores)
	adda.w	d3,a0
	clr.w	d3
	btst	#0,$E(a0)	;gsftf, gsflags(a0): teams are flipped
	beq.w	.nf
	eori.w	#2,d3	;gspobwins-gspotwins
.nf
	move.w	(HmGoals).w,d1
	sub.w	(AwGoals).w,d1
	bpl.w	.ns1
	eori.w	#2,d3
.ns1
	cmpi.w	#3,4(a0,d3.w)
	bne.w	.t3
.2
	bset	#2,(sflags13).w
	move.w	(tmstruct+$28).w,(cupwinner).w
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
.t3
	moveq	#5,d2
	move.w	(HmGoals).w,d1
	sub.w	(AwGoals).w,d1
	beq.w	.9
	bpl.w	.t2
	adda.w	#$300,a3
.t2
	tst.w	position(a3)
	ble.w	.n2
	jsr	(assinsert).l	;first skater gets d0, the rest get score
	moveq	#$1C,d0
.n2
	adda.w	#SCstruct,a3
	dbf	d2,.t2
.eog
	jsr	(ClearPenaltyBuffer).l
	addi.w	#$3E8,(crowdlevel).w	;1000
	bset	#0,(gmode).w	;gmclock: stop clock
	bset	#6,(gmode).w	;set at end of game
	jsr	(ClearPenalties).l
	move.w	#4,d0	;PenEOG
	jmp	AddPenalty2
.9
	btst	#7,(sflags9).w
	bne.s	.eog
	cmpi.w	#3,(gsp).w
	bne.w	.eop_ex
	btst	#3,(GameFlags).w
	beq.w	.10
	btst	#5,(SeasonDay+1).w
	bne.w	.eop_ex
.10
	tst.w	(OptPlayMode).w
	beq.s	.eog
.eop_ex
	move.w	#2,d0
	jmp	AddPenalty2

GameOver	;EncodePW, the Stanley Cup screen (sflags13 bit 2), SeasonGameOver, then ExitToOpening
	jsr	(EncodePW).l
	btst	#2,(sflags13).w
	beq.w	.0
	jsr	(StanleyCupScreen).l
.0
	jsr	(SeasonGameOver).l

ExitToOpening	;Jmp to the opening
	jmp	Opening2

clockcont	;Clock continue: when the clock is at 0 stop the play (sfx 4) and go to clockcont_0
	btst	#0,(gmode).w
	bne.w	.0
	tst.w	(gameclock).w
	bne.w	.0
	bset	#3,(disflags).w	;dfclock: clock needs update
	jsr	(stop_current_song).l
	move.w	#SFXhorn,-(sp)	;horn
	jsr	(sfx).l
	bsr.w	LockScroll
	jmp	clockcont_0
.0
	rts

SetContTeams	;The controller setup screen: pick the team of each pad (cont1team ... cont4team) and the Practice Mode
	;players and goalies
	tst.w	(demoflag).w
	bmi.w	.1
.loop
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
.loop2
	move.w	(vcount).w,d0
.loop3
	cmp.w	(vcount).w,d0
	beq.s	.loop3
	addq.w	#1,(carddelay).w
	cmpi.w	#$5460,(carddelay).w
	bge.s	.loop
	bsr.w	ReadAllPads
	tst.w	(TempLegSpd).w
	beq.w	.5
	clr.w	(carddelay).w
.5
	btst	#7,(TempLegSpd+1).w
	bne.w	.exit
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
.loop4
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
	dbf	d4,.loop4
	bra.w	.loop2
.exit
	rts

ContTeamOrder1	;Pad team order tables for SetContTeams
	dc.b	2,0,2,$FF

ContTeamOrder2
	dc.b	1,1,0,$FF

PrintPracticeGoalies	;Set homegoaliectl / awaygoaliectl from PracticeGoalieTbl and print them
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

PrintGoalieCount	;Print GoalieCountTxt string d0 (PrintSetupStr)
	movea.l	#GoalieCountTxt,a1
	bra.w	.1
.loop
	adda.w	(a1),a1
.1
	dbf	d0,.loop
	bra.w	PrintSetupStr

GoalieCountTxt	;"0", "1", "2"
	String	'0'
	String	'1'
	String	'2'

PracticeGoalieTbl	;Home / away goalie control by Practice Mode setting
	dc.b	1,0,0,1,2,0,0,2,1,2,2,1,1,1,2,2

DrawPadSetup	;Draw the pads, their icons (DrawPadIcon) and the cursor (DrawPadCursor)
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
.loop
	move.w	(printy).w,-(sp)
	subq.w	#1,(printy).w
	movea.l	#BlankLineTxt,a1
	bsr.w	PrintSetupStr
	addq.w	#1,(printy).w
	bsr.w	PrintSetupStr
	addq.w	#1,(printy).w
	bsr.w	PrintSetupStr
	jsr	(printz).l
	String	-TXMAP1,0,0,0
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
	dbf	d4,.loop
	movem.l	(sp)+,d0-d7/a0-a6
	rts

DrawPadIcon	;Draw pad icon d7 (PadIconMaps at PadIconChars)
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

PadIconMaps	;Pad icon bitmaps, then (PadIconChars) the RAM words with their chars
	dc.l	PadIconMap1,PadIconMap2,PadIconMap3,PadIconMap4

PadIconChars
	dc.l	padiconchars1,padiconchars2,padiconchars3,padiconchars4

DrawPadCursor	;Draw the pad cursor (PadCursorMap, padcursorchars) beside printx / printy
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

BlankLineTxt	;A blank line
	String	$FD,$0,'                                        '

PrintPracticeTitle	;Practice Mode: print PracticePlayersTxt, highlighted (PrintSetupStrHi) when setupvalues is 0
	btst	#7,(sflags9).w
	beq.w	.exit
	movea.l	#PracticePlayersTxt,a1
	tst.w	(setupvalues).w
	beq.w	.0
	bsr.w	PrintSetupStrHi
	bra.w	.exit
.0
	bsr.w	PrintSetupStr
.exit
	rts

PracticePlayersTxt
	String	$FD,$C,$FC,$16,'PRACTICE PLAYERS',$FD,$19,$FC,$17,'No. of Players',$FD,$2,'No. of Players'

ControllerSetupScreen	;Build the controller setup screen: vram, fonts, the team blocks and pad tiles, the backgrounds and
	;"Controller SetUp" (printbigz); the team blocks of VisTeam / HomeTeam
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
	jsr	(setVram).l
	jsr	(orjoy).l
	move.w	#1,d4
	move.w	d4,(smallfontchars).w
	movea.l	#RosterFont+8,a2
	jsr	(DecompressGraphicsPlain).l
	move.w	d4,(smallfont2chars).w
	movea.l	#RosterFont+8,a2
	jsr	(DecompressGraphicsWithCallback).l
	dc.b	$05,$23,$45,$67,$89,$AB,$CD,$EF	;remap table
	move.w	d4,(smallfont3chars).w
	movea.l	#RosterFont+8,a2
	jsr	(DecompressGraphicsWithCallback).l
	dc.b	$0D,$23,$45,$67,$89,$AB,$CD,$EF	;remap table
	move.l	#RosterFont,(smallfontptr).l
	move.w	d4,(BigFontChars).w
	movea.l	#BigFontMap2+8,a2
	jsr	(DecompressGraphicsPlain).l
	move.w	d4,(teamblocksmapptr).w
	movea.l	#Teamblocksmap+8,a2
	jsr	(DecompressGraphicsPlain).l
	move.w	d4,(padcursorchars).w
	movea.l	#PadCursorMap+8,a2
	jsr	(DecompressGraphicsPlain).l
	move.w	d4,(padiconchars1).w
	movea.l	#PadIconMap1+8,a2
	jsr	(DecompressGraphicsPlain).l
	move.w	d4,(padiconchars2).w
	movea.l	#PadIconMap2+8,a2
	jsr	(DecompressGraphicsPlain).l
	move.w	d4,(padiconchars3).w
	movea.l	#PadIconMap3+8,a2
	jsr	(DecompressGraphicsPlain).l
	move.w	d4,(padiconchars4).w
	movea.l	#PadIconMap4+8,a2
	jsr	(DecompressGraphicsPlain).l
	move.w	(VisTeam).w,d1
	jsr	(printz).l
	String	-(TXPRI+TXMAP1),2,6,0
	bsr.w	DrawSetupTeamBlock
	move.w	(HomeTeam).w,d1
	jsr	(printz).l
	String	-(TXPRI+TXMAP1),$1B,6,0
	bsr.w	DrawSetupTeamBlock
	jsr	(printz).l
	String	-TXMAP2,0,0,0
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
	String	-TXMAP2,$E,6,0
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
	String	-(TXPRI+TXMAP1),5,2,'Controller SetUp'
	rts

DrawSetupTeamBlock	;Draw team block d1 (Teamblocksmap) at printx / printy
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

PrintSetupStr	;Print String a1 (printz2 $FE,5,$FF,1,$F9,0, then printsmall)
	movem.l	d0-d7/a0-a6,-(sp)
	move.l	a1,-(sp)
	jsr	(printsmallz).l
	String	CC_SetAttribute,5,CC_SetMap,1,CC_SetFont,0
	movea.l	(sp)+,a1
	jsr	(printsmall).l
	movem.l	(sp)+,d0-d7/a0-a6
	rts

PrintSetupStrHi	;The same highlighted ($F9,1)
	movem.l	d0-d7/a0-a6,-(sp)
	move.l	a1,-(sp)
	jsr	(printsmallz).l
	String	CC_SetAttribute,5,CC_SetMap,1,CC_SetFont,1
	movea.l	(sp)+,a1
	jsr	(printsmall).l
	movem.l	(sp)+,d0-d7/a0-a6
	rts

ReadAllPads	;Read the 4 pads into TempWord1, TempWord2, TempRawSpd and TempMaxSpd
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
