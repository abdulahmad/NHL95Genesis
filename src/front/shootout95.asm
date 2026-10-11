;	3 parts in ROM order, each under its banner below.
;	EA's compiler emits cmp #imm,Dn as CMP (Bxxx), SNASM emits CMPI (0Cxx). The source has the real cmp / cmpi; fixopcodes.js patches the
;	cmp encoding after assembly.

;------------------------------------------------------------------------------------------------------------------------
;	The shootout setup and skating paths: ClearShootout and InitShooters, then PSandSOpassdir, passdirlist,
;	StartShootoutPath, ShootoutPaths, NextPathPoint, SkatePath and ShootoutShootCheck; then the shootout itself.



	include	macros\genesis.mac	;String

ClearShootout	;Clear the player structs (SortCords) and the shootout state, then the shooter
	;lists of both teams (InitShooters)
	movea.l	#SortCords,a0
	move.w	#$3FF,d0
.loop
	clr.w	(a0)+
	dbf	d0,.loop
	clr.w	(shootoutdelay).w
	move.w	#1,(shootoutround).w
	bclr	#3,(gmode2).w
	clr.w	(sohomegoals).w
	clr.w	(soawaygoals).w
	clr.w	(homeshootnum).w
	clr.w	(shootoutteam).w
	bsr.w	InitShooters
	move.w	#1,(shootoutteam).w
	bsr.w	InitShooters
	clr.w	(shootoutteam).w
	rts
InitShooters	;The 6 starters of the home (shootoutteam 0) or away team (save RAM roster
	;SRLines, $82 bytes a team) as the shooter list below homeshootnum / shootoutteam
	movea.l	#homeshootnum,a0
	move.w	(HomeTeam).w,d0
	tst.w	(shootoutteam).w
	beq.w	.0
	move.w	(VisTeam).w,d0
	movea.l	#shootoutteam,a0
.0
	movea.l	#SaveRAM+2*SRLines,a1
	mulu.w	#$82,d0
	adda.l	d0,a1
	move.w	#5,d0
.loop
	move.w	(a1)+,d1
	andi.w	#$FF,d1
	subq.w	#1,d1
	move.w	d1,-(a0)
	dbf	d0,.loop
	rts
PSandSOpassdir	;Penalty shot / shootout: passdir = sopathdir (the end of the skate path
	;NextPathPoint), turned by passdirlist for the bottom net
	movem.l	d0-d7/a0-a6,-(sp)
	move.w	(sopathdir).w,d0
	btst	#7,pflags(a3)	;check what net shooting at
	bne.w	.0	;branch if top net
	movea.l	#passdirlist,a0
	add.w	d0,d0
	move.w	(a0,d0.w),d0
.0
	move.w	d0,(passdir).w	;move d0 into passdir
	movem.l	(sp)+,d0-d7/a0-a6
	rts
passdirlist	;PSandSOpassdir: passdir for the other net
	dc.w	0,7,6,5,4,3,2,1,8
StartShootoutPath	;Shootout: pick one of the 7 skate paths (ShootoutPaths) at random (sopath) and start
	;it (NextPathPoint)
	movem.l	d0-d7/a0-a6,-(sp)
.loop
	move.w	#7,d0
	jsr	(randomd0).l
	cmp.w	#6,d0
	bgt.s	.loop
	move.w	d0,(sopath).w
	bclr	#3,(sflags7).w
	move.w	#$FFFF,(sopathpoint).w
	clr.w	(sopathx).w
	bsr.w	NextPathPoint
	movem.l	(sp)+,d0-d7/a0-a6
	rts
ShootoutPaths	;The 7 shootout skate paths (NextPathPoint)
	dc.l	ShootoutPath1
	dc.l	ShootoutPath2
	dc.l	ShootoutPath3
	dc.l	ShootoutPath4
	dc.l	ShootoutPath5
	dc.l	ShootoutPath6
	dc.l	ShootoutPath7
ShootoutPath1	;ShootoutPaths path: x, y points; $80 in the high byte ends it (low byte: sopathend, then sopathdir)
	dc.w	$10,$E2,$10,$D0,$8020,5
ShootoutPath2	;ShootoutPaths path: x, y points; $80 in the high byte ends it (low byte: sopathend, then sopathdir)
	dc.w	$FFC9,$A0,$FFFF,$C8,$FFE0,$D0,$8020,5
ShootoutPath3	;ShootoutPaths path: x, y points; $80 in the high byte ends it (low byte: sopathend, then sopathdir)
	dc.w	$FFB0,$40,$1A,$BC,$8020,5
ShootoutPath4	;ShootoutPaths path: x, y points; $80 in the high byte ends it (low byte: sopathend, then sopathdir)
	dc.w	$FFCE,$58,$14,$D0,$802C,5
ShootoutPath5	;ShootoutPaths path: x, y points; $80 in the high byte ends it (low byte: sopathend, then sopathdir)
	dc.w	$FFCE,8,$20,$D0,$8028,6
ShootoutPath6	;ShootoutPaths path: x, y points; $80 in the high byte ends it (low byte: sopathend, then sopathdir)
	dc.w	$1C,$F4,8,$E0,$8020,6
ShootoutPath7	;ShootoutPaths path: x, y points; $80 in the high byte ends it (low byte: sopathend, then sopathdir)
	dc.w	$FFE6,$F8,0,$E0,$8020,2
NextPathPoint	;Next point of shootout path sopath: sopathx / sopathy = x (turned by bit 0
	;of $76(a3)) / y; at the end ($80) sflags7 bit 3, sopathend and sopathdir
	movem.l	d0-d7/a0-a6,-(sp)
	cmpi.b	#$80,(sopathx).w
	beq.w	.x
	addq.w	#1,(sopathpoint).w
	move.w	(sopathpoint).w,d0
	asl.w	#2,d0
	movea.l	#ShootoutPaths,a0
	move.w	(sopath).w,d1
	asl.w	#2,d1
	movea.l	(a0,d1.w),a0
	move.w	(a0,d0.w),(sopathx).w
	btst	#0,handed(a3)
	beq.w	.0
	neg.w	(sopathx).w
.0
	move.w	2(a0,d0.w),(sopathy).w
	cmpi.b	#$80,4(a0,d0.w)
	bne.w	.x
	bset	#3,(sflags7).w
	clr.w	(sopathend).w
	move.b	5(a0,d0.w),(sopathend+1).w
	move.w	6(a0,d0.w),(sopathdir).w
.x
	movem.l	(sp)+,d0-d7/a0-a6
	rts
SkatePath	;Shootout skate path: d0 / d1 = the point (mirrored for the bottom net); within $A of it ($12
	;while $28 / $2A(a3) are 0) take the next one (NextPathPoint)
	movem.l	d2-d7/a0-a6,-(sp)
	cmpi.b	#$80,(sopathx).w
	beq.w	.x
	move.w	(sopathx).w,d0
	move.w	(sopathy).w,d1
	btst	#7,pflags(a3)
	bne.w	.0
	neg.w	d0
	neg.w	d1
.0
	sub.w	(a3),d0
	bpl.w	.1
	neg.w	d0
.1
	tst.w	Xvel(a3)
	bne.w	.2
	tst.w	Yvel(a3)
	bne.w	.2
	cmp.w	#$12,d0
	ble.w	.3
.2
	cmp.w	#$A,d0
	bgt.w	.7
.3
	sub.w	Ypos(a3),d1
	bpl.w	.4
	neg.w	d1
.4
	tst.w	Xvel(a3)
	bne.w	.5
	tst.w	Yvel(a3)
	bne.w	.5
	cmp.w	#$12,d1
	ble.w	.6
.5
	cmp.w	#$A,d1
	bgt.w	.7
.6
	bsr.w	NextPathPoint
.7
	move.w	(sopathx).w,d0
	move.w	(sopathy).w,d1
.x
	movem.l	(sp)+,d2-d7/a0-a6
	rts
ShootoutShootCheck	;Shootout, skater a3 has the puck (gmode2 bit 1): Z set (d0 is restored) = shoot now
	;after 3 (shootoutclock) at the path end, within sopathend of its last point, or with the puck stopped before $F
	movem.l	d0-d7/a0-a6,-(sp)
	btst	#1,(gmode2).w
	beq.w	.5
	move.w	SCnum(a3),d0
	cmp.w	(puckc).w,d0
	bne.w	.5
	cmpi.w	#3,(shootoutclock).w
	ble.w	.4
	cmpi.b	#$80,(sopathx).w
	beq.w	.4
	btst	#3,(sflags7).w
	bne.w	.0
	tst.w	(puckvx).w
	bne.w	.5
	tst.w	(puckvy).w
	bne.w	.5
	cmpi.w	#$F,(shootoutclock).w
	blt.w	.4
	bra.w	.5
.0
	move.w	(sopathx).w,d0
	move.w	(sopathy).w,d1
	btst	#7,pflags(a3)
	bne.w	.1
	neg.w	d0
	neg.w	d1
.1
	sub.w	(a3),d0
	bpl.w	.2
	neg.w	d0
.2
	sub.w	Ypos(a3),d1
	bpl.w	.3
	neg.w	d1
.3
	cmp.w	(sopathend).w,d0
	bgt.w	.5
	cmp.w	(sopathend).w,d1
	bgt.w	.5
.4
	clr.w	d0
	bra.w	.x
.5
	move.w	#1,d0
.x
	movem.l	(sp)+,d0-d7/a0-a6
	rts

;------------------------------------------------------------------------------------------------------------------------
;	NextShooter, CountShootoutGoals, EndShootout, PlayoffRoundScreen and RoundBigTxt, ShootoutWonBy,
;	ShootoutShooters ... PrintShooterNames (the shootout shooters screen).


NextShooter	;Shootout: the next shooter (BA_Team, BA_Goalie_SCnum, StartShootoutPath), or the end
	;(ExitToOpening)
	btst	#3,(gmode2).w
	beq.w	.0
	jmp	(ExitToOpening).l
.0
	movem.l	d0-d7/a0-a6,-(sp)
	bsr.w	StartShootoutPath
	move.w	(shootoutteam).w,(BA_Team).w
	move.w	#$B,(BA_Goalie_SCnum).w
	movea.l	#homeshooters,a0
	tst.w	(shootoutteam).w
	beq.w	.1
	move.w	#5,(BA_Goalie_SCnum).w
	movea.l	#awayshooters,a0
.1
	move.w	(homeshootnum).w,d0
	add.w	d0,d0
	move.w	(a0,d0.w),(BA_Skater_Offset).w
	bclr	#2,(SortCords+(puckscnum*SCstruct)+pflags).w
	movem.l	(sp)+,d0-d7/a0-a6
	rts
CountShootoutGoals	;Shootout: count the goals and end it when one team cannot catch up
	;(EndShootout)
	movem.l	d0-d7/a0-a6,-(sp)
	btst	#0,(shootoutteam+1).w
	beq.w	.0
	cmpi.w	#5,(shootoutround).w
	blt.w	.0
	move.w	(sohomegoals).w,d0
	cmp.w	(soawaygoals).w,d0
	beq.w	.0
	bset	#3,(gmode2).w
	jsr	(EndShootout).l
	bra.w	.x
.0
	eori.w	#1,(shootoutteam).w
	bne.w	.x
	addq.w	#1,(homeshootnum).w
	cmpi.w	#5,(homeshootnum).w
	blt.w	.1
	clr.w	(homeshootnum).w
.1
	addq.w	#1,(shootoutround).w
.x
	movem.l	(sp)+,d0-d7/a0-a6
	rts
EndShootout	;Shootout over: LockScroll, then the 5 skaters of player slots 1-5 (sohomegoals >
	;soawaygoals) or 7-$B are set up (setplayer) above or below the view and get assscore (assinsert 7)
	movem.l	d0-d7/a0-a6,-(sp)
	bset	#2,(sflags2).w
	jsr	(LockScroll).l
	move.w	#$60,(shootoutdelay).w
	movea.l	#SortCords,a3
	move.w	#0,d0
	move.w	(sohomegoals).w,d2
	cmp.w	(soawaygoals).w,d2
	bgt.w	.0
	move.w	#6,d0
.0
	asl.w	#7,d0
	adda.w	d0,a3
	move.w	#4,d2
	move.w	#6,d3
	bra.w	.2
.loop
	movem.w	d2-d3,-(sp)
	jsr	(setplayer).l
	move.w	#2,position(a3)
	move.w	#$F0,d0
	tst.w	(Vpos).w
	bmi.w	.1
	move.w	#$FF10,d0
.1
	add.w	(Vpos).w,d0
	move.w	d0,Ypos(a3)
	move.w	#0,(a3)
	move.w	#$1C,d0	;assscore
	jsr	(assinsert).l
	bclr	#5,pflags(a3)
	bclr	#1,pflags2(a3)
	bclr	#2,pflags(a3)
	movem.w	(sp)+,d2-d3
.2
	adda.l	#SCstruct,a3
	dbf	d2,.loop
	movem.l	(sp)+,d0-d7/a0-a6
	rts
PlayoffRoundScreen	;Shootout round box: "SHOOTOUT MODE" (RoundBigTxt), the shooter " vs." the
	;goalie, the goals of both teams and the round
	movem.l	d0-d7/a0-a6,-(sp)
	move.w	#$FFFF,d0
	jsr	(prefmes).l
	jsr	(printz).l
	String	-(TXPRI+TXMAP1),$3,$2,$0
	moveq	#$1B,d0
	moveq	#$C,d1
	jsr	(Framer).l
	lea	RoundBigTxt(pc),a1
	jsr	(printbig1).l
	move.w	(BA_Skater_Offset).w,d0
	movea.l	#tmstruct,a2
	tst.w	(BA_Team).w
	beq.w	.0
	movea.l	#AwShots,a2
.0
	jsr	(FormatPlayerNumInitial).l
	move.w	(printx).w,-(sp)
	jsr	(print).l
	move.w	(sp)+,(printx).w
	addq.w	#1,(printy).w
	addq.w	#6,(printx).w
	jsr	(printz).l
	String	' vs.',-(TXPRI+TXMAP1),$4,$7,$0
	move.w	(BA_Goalie_SCnum).w,d0
	asl.w	#7,d0
	movea.l	#SortCords,a2
	adda.w	d0,a2
	clr.w	d0
	move.b	$66(a2),d0
	movea.l	#AwShots,a2
	tst.w	(BA_Team).w
	beq.w	.1
	movea.l	#tmstruct,a2
.1
	jsr	(FormatPlayerNumInitial).l
	jsr	(print).l
	jsr	(printz).l
	String	-(TXPRI+TXMAP1),$4,$9,$0
	movea.l	#tmstruct,a1
	movea.l	tmdata(a1),a1
	adda.w	4(a1),a1
	jsr	(print).l
	move.w	#$15,(printx).w
	move.w	(sohomegoals).w,d0
	move.w	#3,d1
	jsr	(PushNumberWidth).l
	jsr	(print).l
	jsr	(printz).l
	String	-(TXPRI+TXMAP1),$4,$A,$0
	movea.l	#AwShots,a1
	movea.l	tmdata(a1),a1
	adda.w	4(a1),a1
	jsr	(print).l
	move.w	#$15,(printx).w
	move.w	(soawaygoals).w,d0
	move.w	#3,d1
	jsr	(PushNumberWidth).l
	jsr	(print).l
	jsr	(printz).l
	String	-(TXPRI+TXMAP1),$4,$C,'Round ',$0
	move.w	(shootoutround).w,d0
	move.w	#2,d1
	jsr	(PushNumberWidth).l
	jsr	(print).l
	movem.l	(sp)+,d0-d7/a0-a6
	rts
RoundBigTxt	;PlayoffRoundScreen big text
	String	$BF,$4,$3,'SHOOTOUT MODE',$BF,$4,$5,$0
ShootoutWonBy	;Shootout: "SHOOTOUT WON BY" and the winning team (printbig1)
	movem.l	d0-d7/a0-a6,-(sp)
	jsr	(printz).l
	String	-(TXPRI+TXMAP1),$1,$D,$0
	move.w	#6,d1
	move.w	#$1E,d0
	jsr	(Framer).l
	jsr	(printbigz1).l
	String	-(TXPRI+TXMAP1),$2,$E,'SHOOTOUT WON BY'
	addq.w	#2,(printy).w
	move.w	(HomeTeam).w,d1
	move.w	(sohomegoals).w,d0
	cmp.w	(soawaygoals).w,d0
	bgt.w	.0
	move.w	(VisTeam).w,d1
.0
	asl.w	#2,d1
	movea.l	#TeamList,a1
	movea.l	(a1,d1.w),a1
	adda.w	4(a1),a1
	move.w	#2,(printx).w
	jsr	(printbig1).l
	movem.l	(sp)+,d0-d7/a0-a6
	rts
ShootoutShooters	;Pause menu SHOOTOUT SETUP: pick the 5 shooters and the goalie of team a2
	btst	#0,(gmode2).w
	beq.w	ShootersExit
	moveq	#0,d0
	moveq	#$1C,d1
	move.l	#PlayerSelectMap1,(screenarg).l
	jsr	(DrawTeamScreen6).l
	clr.w	(DispAttribCtr).w
	clr.w	(PlayerScrollCtr).w
	jsr	(printsmallz).l
	String	CC_SetMap,$2,CC_SetX,$0,CC_SetY,$0
	moveq	#$28,d0
	moveq	#$1C,d1
	move.w	#$7FF,d2
	jsr	(eraser).l
	jsr	(LineEditorBg).l
	bsr.w	PrintShooterSlots
	move.w	#0,(TestList).w
ShootersRedraw	;Shootout shooters: redraw (ShootersBackground, PrintShooterNames, PrintShooterBox)
	bsr.w	ShootersBackground
	bsr.w	PrintShooterNames
	bsr.w	PrintShooterBox
ShootersLoop	;Shootout shooters: the input loop
	jsr	(vcountwait).l
	jsr	(ReadMenuJoy).l
	jsr	(ProcessInputWithRepeat).l
	btst	#7,d1
	bne.w	ShootersExit
	move.w	#1,d0
	btst	#1,d1
	bne.w	ShootersMove
	move.w	#$FFFF,d0
	btst	#0,d1
	bne.w	ShootersMove
	move.w	#0,d0
	btst	#2,d1
	bne.w	ShootersPick
	move.w	#5,d0
	btst	#3,d1
	bne.w	ShootersPick
	btst	#5,d1
	bne.w	ShooterSelectList
	bra.s	ShootersLoop
ShootersExit	;Leave (ExitStatsScreen)
	jmp	(ExitStatsScreen).l
ShooterSelectList	;Shootout shooters: the "{Select Player}" list for slot TestList (skaters, or the
	;goalies for slot 5)
	move.w	#$C000,d7
	movea.l	#homeshooters,a0
	cmpa.l	#tmstruct,a2
	beq.w	.0
	movea.l	#awayshooters,a0
.0
	move.w	(TestList).w,d0
	asl.w	#1,d0
	move.w	(a0,d0.w),d6
	jsr	(GetGoalieCount).l
	move.w	d0,d1
	jsr	(GetPlayerCount).l
	sub.w	d1,d0
	subq.w	#1,d0
	cmpi.w	#5,(TestList).w
	bne.w	.1
	move.w	d1,d0
	subq.w	#1,d0
	clr.w	d1
.1
	move.w	d0,(screentimer).w
	clr.w	(PlayerScrollCtr).w
	clr.w	(VertLineScrolling).w
	movea.w	#(Satt-M68K_RAM),a0
	clr.w	d2
.loop
	move.b	d1,(a0,d2.w)
	cmp.w	d1,d6
	bne.w	.2
	move.w	d2,(VertLineScrolling).w
.2
	addq.w	#1,d1
	addq.w	#1,d2
	dbf	d0,.loop
	jsr	(PlayerSelectBg).l
	jsr	(ClearShooterScreen).l
	jsr	(printsmallz).l
	String	CC_SetMapAndPosition,$0,$3,$1,$0,$0
	moveq	#$12,d0
	moveq	#3,d1
	jsr	(printsmallz).l
	String	CC_SetX,$15,CC_SetY,$0
	moveq	#$12,d0
	moveq	#3,d1
	jsr	(printsmallz).l
	String	CC_SetMapAndPosition,$4,$2,$2,$1,'{Select  Player}',$0
	clr.w	d0
	bra.w	.6
.loop2
	jsr	(vcountwait).l
	jsr	(ReadMenuJoy).l
	jsr	(ProcessInputWithRepeat).l
	btst	#7,d1
	beq.w	.3
	jsr	(LineEditorBg).l
	bra.w	ShootersRedraw
.3
	btst	#5,d1
	bne.w	.10
	moveq	#1,d0
	btst	#1,d1
	bne.w	.6
	btst	#3,d1
	bne.w	.4
	moveq	#-1,d0
	btst	#0,d1
	bne.w	.6
	btst	#2,d1
	bne.w	.4
	bra.s	.loop2
.4
	add.w	(DispAttribCtr).w,d0
	bmi.s	.loop2
	move.w	d0,(DispAttribCtr).w
	bsr.w	PrintShooterList
	bra.s	.loop2
.6
	add.w	(VertLineScrolling).w,d0
	bmi.s	.loop2
	cmp.w	(screentimer).w,d0
	bgt.s	.loop2
	move.w	d0,(VertLineScrolling).w
	cmp.w	(PlayerScrollCtr).w,d0
	bgt.w	.8
	move.w	d0,(PlayerScrollCtr).w
.8
	subq.w	#5,d0
	cmp.w	(PlayerScrollCtr).w,d0
	ble.w	.9
	move.w	d0,(PlayerScrollCtr).w
.9
	bsr.w	PrintShooterList
	bra.w	.loop2
.10
	movea.w	#(Satt-M68K_RAM),a3
	adda.w	(VertLineScrolling).w,a3
	clr.w	d0
	move.b	(a3),d0
	move.w	(TestList).w,d2
	movea.l	#homeshooters,a0
	cmpa.l	#tmstruct,a2
	beq.w	.11
	movea.l	#awayshooters,a0
.11
	asl.w	#1,d2
	move.w	d0,(a0,d2.w)
	jsr	(LineEditorBg).l
	bra.w	ShootersRedraw
PrintShooterList	;Shootout shooters: the player list rows (getNameandAttrib); the selected row in
	;printa d7 ($E000 with BA_PS_flags bit 1)
	jsr	(printz).l
	String	-(TXPRI+TXMAP2),$16,$1,$0
.loop
	movea.l	#PAttribOverall,a1
	cmpi.w	#5,(TestList).w
	bne.w	.0
	movea.l	#GAttribOverall,a1
.0
	move.w	(DispAttribCtr).w,d0
	bra.w	.1
.loop2
	adda.w	(a1),a1
	addq.w	#4,a1
.1
	tst.w	(a1)
	dbmi	d0,.loop2
	bpl.w	.2
	subq.w	#1,(DispAttribCtr).w
	bra.s	.loop
.2
	cmpa.l	#PAttribOverall,a1
	bne.w	.3
	movea.l	#ShooterOverallTxt,a1
.3
	cmpa.l	#GAttribOverall,a1
	bne.w	.4
	movea.l	#ShooterOverallTxt2,a1
.4
	jsr	(print).l
	move.l	(a1),d4
	movea.w	#(Satt-M68K_RAM),a3
	move.w	(PlayerScrollCtr).w,d2
	move.w	(screentimer).w,d1
	sub.w	d2,d1
	cmp.w	#5,d1
	bls.w	.5
	moveq	#5,d1
.5
	move.w	#2,(printy).w
.loop3
	jsr	(printsmallz).l
	String	CC_SetAttribute,$4,CC_SetX,$5,CC_AddY,$1,'                      ',CC_SetX,$5
	cmp.w	(VertLineScrolling).w,d2
	bne.w	.6
	move.w	d7,(printa).w
	cmp.w	#$C000,d7
	bne.w	.6
	btst	#1,(BA_PS_flags).w
	beq.w	.6
	move.w	#$E000,(printa).w
.6
	clr.w	d0
	move.b	(a3,d2.w),d0
	jsr	(GetNameandAttrib).l
	addq.w	#1,d2
	dbf	d1,.loop3
	rts
ShooterOverallTxt	;PrintShooterList heading, then the attribute long (d4)
	String	'    Overall    ]'
	dc.w	$1F3A,$A
ShooterOverallTxt2	;PrintShooterList goalie heading, then the attribute long (d4)
	String	'    Overall    ]'
	dc.w	$1B0F,$A
ShootersPick	;Shootout shooters: C on a slot; the same slot (TestList) goes back to the loop, else
	;select it (ShootersSelect)
	cmp.w	(TestList).w,d0
	beq.w	ShootersLoop
	bra.w	ShootersSelect
ShootersMove	;Shootout shooters: move the slot cursor by d0, wrapping in 0 ... 4 (not on slot 5)
	cmpi.w	#5,(TestList).w
	beq.w	ShootersLoop
	add.w	(TestList).w,d0
	bmi.w	.0
	cmp.w	#5,d0
	blt.w	ShootersSelect
	clr.w	d0
	bra.w	ShootersSelect
.0
	move.w	#4,d0
ShootersSelect	;Shootout shooters: TestList = d0, redraw the names and the player box, back to the loop
	move.w	d0,(TestList).w
	bsr.w	PrintShooterNames
	bsr.w	PrintShooterBox
	bra.w	ShootersLoop
ShootersBackground	;Shootout shooters: "Shootout" title and the team block (PutTeamBlock)
	bsr.w	ClearShooterScreen
	jsr	(printz).l
	String	-(TXPRI+TXMAP2),$7,$1,$0
	moveq	#$1A,d0
	moveq	#6,d1
	jsr	(printbigz).l
	String	-(TXPRI+TXMAP2),$A,$4,'  Shootout  ',-(TXPRI+TXMAP2),$F,$1
	clr.w	d0
	cmpa.w	#tmstruct&$FFFF,a2
	beq.w	.0
	move.w	#$2C,d0
.0
	jmp	(PutTeamBlock).l
ClearShooterScreen	;Shootout shooters: erase the top of the screen
	jsr	(printz).l
	String	-(TXPRI+TXMAP2),$0,$0,$0
	moveq	#$28,d0
	moveq	#$A,d1
	move.w	#$7FF,d2
	jmp	(eraser).l
ResetShooterScroll	;Clear the list scroll words palfadenew+$5A and palfadenew+$7A. Nothing calls it in 95
	clr.w	(palfadenew+$5A).w
	clr.w	(palfadenew+$7A).w
	rts
PrintShooterSlots	;Shootout shooters: "Shooters" 1. ... 5. and "Goalie"
	jsr	(printsmallz).l
	String	CC_SetFont,$0,CC_SetMap,$2,CC_SetX,$0,CC_SetY,$A
	jsr	(printsmallz).l
	String	CC_SetAttribute,$4
	jsr	(printsmallz).l
	String	CC_SetX,$7,CC_SetY,$C,'Shooters'
	jsr	(printsmallz).l
	String	CC_SetX,$3,CC_SetY,$E,'1. ',$0
	jsr	(printsmallz).l
	String	CC_SetX,$3,CC_SetY,$10,'2. ',$0
	jsr	(printsmallz).l
	String	CC_SetX,$3,CC_SetY,$12,'3. ',$0
	jsr	(printsmallz).l
	String	CC_SetX,$3,CC_SetY,$14,'4. ',$0
	jsr	(printsmallz).l
	String	CC_SetX,$3,CC_SetY,$16,'5. ',$0
	jsr	(printsmallz).l
	String	CC_SetX,$1A,CC_SetY,$C,'Goalie'
	rts
PrintShooterBox	;Shootout shooters: the selected player (getname), centred
	jsr	(printsmallz).l
	String	CC_SetMapAndPosition,$4,$2,$8,$7,CC_SetFont,$1,$0
	jsr	(printsmallz).l
	String	CC_SetX,$0,CC_SetY,$7,'                                       ',$0
	jsr	(printsmallz).l
	String	CC_SetX,$15,CC_SetY,$7
	movea.l	#homeshooters,a1
	cmpa.l	#tmstruct,a2
	beq.w	.0
	movea.l	#awayshooters,a1
.0
	move.w	(TestList).w,d0
	asl.w	#1,d0
	move.w	(a1,d0.w),d0
	jsr	(getname).l
	move.w	(a1),d0
	lsr.w	#1,d0
	sub.w	d0,(printx).w
	move.w	d7,(printa).w
	jsr	(printsmall).l
	clr.w	(printfontset).w
	rts
PrintShooterNames	;Shootout shooters: the shooters' names (FormatPlayerNameShort), slot TestList
	;highlighted
	movem.l	d0-d7/a0-a6,-(sp)
	jsr	(printsmallz).l
	String	CC_SetX,$6,CC_SetY,$E,CC_SetAttribute,$6,CC_SetFont,$0
	move.w	#0,d1
	movea.l	#homeshooters,a0
	cmpa.l	#tmstruct,a2
	beq.w	.loop
	movea.l	#awayshooters,a0
.loop
	move.w	d1,d0
	asl.w	#1,d0
	move.w	(a0,d0.w),d0
	jsr	(FormatPlayerNameShort).l
	move.w	(printx).w,-(sp)
	cmp.w	(TestList).w,d1
	bne.w	.1
	move.w	#2,(printfontset).w
.1
	cmp.w	#5,d1
	bne.w	.2
	move.w	#$19,(printx).w
	move.w	#$E,(printy).w
.2
	jsr	(printsmall).l
	clr.w	(printfontset).w
	move.w	(sp)+,(printx).w
	addq.w	#2,(printy).w
	addq.w	#1,d1
	cmp.w	#6,d1
	blt.s	.loop
	movem.l	(sp)+,d0-d7/a0-a6
	rts

;------------------------------------------------------------------------------------------------------------------------
;	puckshootout, SelectPenaltyShotSkater, puckpenshot, UpdatePenaltyShotEnd, EndPenaltyShotPlay, SetupPenaltyShot,
;	PenaltyShotBox / PenShotBigTxt, PenShotChk / getBAplayerInfo, ShortenMsgTimer, setInjuryType, getFgtbyte /
;	chkFgtBit1, updatepwrplay / GetLowestPen; the season injuries (SetSeasonInjuries ... DeleteInjurySlot, save RAM
;	SRInjuries), CheckInjury and ClearPowerPlay.



puckshootout	;Start a penalty shot or shootout attempt: the pads cleared, the shooter (NextShooter) or the path
	;(StartShootoutPath), the song, the goalies back, SelectPenaltyShotSkater; the puck assignment $20 (3 with no skater)
	bclr	#1,pflags(a3)
	beq.w	.7
	bclr	#7,(sflags).w
	bset	#7,(sflags7).w
	clr.l	(padcont).w
	clr.l	(padcont+4).w
	clr.l	(padcont+8).w
	bclr	#7,(gmode2).w
	btst	#0,(gmode2).w
	beq.w	.0
	jsr	(NextShooter).l
	bra.w	.2
.0
	jsr	(StartShootoutPath).l
	move.l	a2,-(sp)
	movea.l	#tmstruct,a2
	tst.w	(BA_Team).w
	beq.w	.1
	movea.l	#AwShots,a2
.1
	addq.w	#1,$362(a2)
	movea.l	(sp)+,a2
.2
	bclr	#2,(BA_PS_flags).w
	bclr	#4,(BA_PS_flags).w
	bclr	#5,(BA_PS_flags).w
	bclr	#6,(BA_PS_flags).w
	bset	#1,(sflags6).w
	btst	#3,(gmode).w
	beq.w	.3
	jmp	(Stop4Pen).l
.3
	bclr	#1,pflags(a3)
	btst	#0,(gmode2).w
	beq.w	.4
	tst.w	(shootoutteam).w
	bne.w	.6
	tst.w	(homeshootnum).w
	bne.w	.6
	move.w	(HomeTeam).w,(HmTeam).w
	move.w	#2,(SongIndex).w
	jsr	(ChooseSong).l
	move.w	(SongNum).w,-(sp)
	bra.w	.5
.4
	move.w	(HomeTeam).w,(HmTeam).w
	move.w	#2,(SongIndex).w
	jsr	(ChooseSong).l
	move.w	(SongNum).w,-(sp)
.5
	jsr	(song).l
.6
	bset	#0,(gmode).w
	bset	#1,(gmode2).w
	clr.w	(puckvx).w
	clr.w	(puckvy).w
	move.w	#$19,(shootoutclock).w
	jsr	(ReturnGoalies).l
	st	temp1(a3)
	st	temp2(a3)
.7
	bset	#2,(BA_PS_flags).w
	movem.w	d1-d2,-(sp)
	jsr	(SelectPenaltyShotSkater).l
	bmi.w	.8
	movem.w	(sp)+,d1-d2
	bra.w	.9
.8
	movem.w	(sp)+,d1-d2
	bclr	#2,(BA_PS_flags).w
	move.w	#3,d0
	jsr	(assreplace).l
	rts
.9
	movem.w	d1-d2,-(sp)
	move.w	(BA_Goalie_SCnum).w,d0
	movea.l	#SortCords,a2
	asl.w	#7,d0
	adda.w	d0,a2
	tst.w	$34(a2)
	bne.w	.10
	btst	#2,pflags2(a2)
	beq.w	.14
.10
	move.w	(BA_Goalie_SCnum).w,d0
	move.w	#6,d2
.11
	subq.w	#1,d2
	bmi.s	.8
	subq.w	#1,d0
	bpl.w	.12
	move.w	#5,d0
	bra.w	.13
.12
	cmp.w	#5,d0
	bne.w	.13
	move.w	#$B,d0
.13
	movea.l	#SortCords,a2
	move.w	d0,d1
	asl.w	#7,d1
	adda.w	d1,a2
	tst.w	$34(a2)
	bne.s	.11
	btst	#2,pflags2(a2)
	bne.s	.11
	move.w	d0,(BA_Goalie_SCnum).w
.14
	movem.w	(sp)+,d1-d2
	movea.w	#(tmstruct-M68K_RAM),a2
	move.w	#$20,d0
	jmp	(assreplace).l

SelectPenaltyShotSkater	;The best rated free skater of the shooting team (9 rating nibbles) in BA_Skater_Offset, a3 his sort object; d0 = 1, or -1 with none
	movem.l	d0-d7/a0-a6,-(sp)
	movea.l	#tmstruct,a0
	tst.w	(BA_Team).w
	beq.w	.0
	movea.l	#AwShots,a0
.0
	move.w	#0,d1
	move.w	#$FFFF,d6
	move.w	#$FFFF,d5
	movea.l	tmdata(a0),a2
	adda.w	(a2),a2
.1
	cmpi.w	#2,(a2)
	beq.w	.5
	adda.w	(a2),a2
	move.w	d1,d7
	asl.w	#1,d7
	move.b	5(a2),d0
	andi.w	#$F,d0
	cmp.b	#1,d0
	ble.w	.4
	btst	#0,(gmode2).w
	bne.w	.6
	cmpi.w	#$FFFE,tmpdst(a0,d7.w)
	beq.w	.2
	cmpi.w	#$FFFF,tmpdst(a0,d7.w)
	bne.w	.4
.2
	clr.w	d3
	clr.w	d0
	move.b	1(a2),d0
	andi.w	#$F,d0
	add.w	d0,d3
	move.b	2(a2),d0
	andi.w	#$F,d0
	add.w	d0,d3
	move.b	2(a2),d0
	andi.w	#$F0,d0
	lsr.w	#4,d0
	add.w	d0,d3
	move.b	3(a2),d0
	andi.w	#$F,d0
	add.w	d0,d3
	move.b	3(a2),d0
	andi.w	#$F0,d0
	lsr.w	#4,d0
	add.w	d0,d3
	move.b	5(a2),d0
	andi.w	#$F,d0
	add.w	d0,d3
	move.b	5(a2),d0
	andi.w	#$F0,d0
	lsr.w	#4,d0
	add.w	d0,d3
	move.b	6(a2),d0
	andi.w	#$F0,d0
	lsr.w	#4,d0
	add.w	d0,d3
	move.b	7(a2),d0
	andi.w	#$F0,d0
	lsr.w	#4,d0
	add.w	d0,d3
	cmp.w	(BA_Skater_Offset).w,d1
	bne.w	.3
	move.w	#$7FFF,d3
.3
	cmp.w	d6,d3
	blt.w	.4
	move.w	d3,d6
	move.w	d1,d5
	bra.w	.4
.4
	addq.l	#8,a2
	addq.w	#1,d1
	cmp.w	#$1A,d1
	blt.w	.1
.5
	tst.w	d5
	bmi.w	.8
	move.w	d5,(BA_Skater_Offset).w
.6
	move.w	#0,(BA_Sktr_SCnum).w
	tst.w	(BA_Team).w
	beq.w	.7
	move.w	#6,(BA_Sktr_SCnum).w
.7
	move.w	(BA_Sktr_SCnum).w,d0
	asl.w	#7,d0
	movea.l	#SortCords,a3
	adda.w	d0,a3
	move.w	(BA_Skater_Offset).w,d3
	bra.w	.9
.8
	move.w	#$FFFF,d0
	bra.w	.10
.9
	move.w	#1,d0
.10
	movem.l	(sp)+,d0-d7/a0-a6
	rts

puckpenshot	;Penalty shot / shootout face-off: rink, puck and nets reset, the shooter at the puck and the goalie in the net, the others off the ice; without $62(a3) bit 1 resume play
	bclr	#1,pflags(a3)
	beq.w	.21
	movem.l	d0-d7/a0-a6,-(sp)
	jsr	(forceblack).l
.0
	btst	#0,(disflags).w
	bne.s	.0
	cmpi.w	#$258,(crowdlevel).w
	bls.w	.1
	move.w	#$258,(crowdlevel).w
	addi.w	#$14,(CwdExciteLvl).w
.1
	move.w	(ExtraChars).w,d4
	movea.l	#RefTiles+8,a2
	jsr	(DoDMA_clearCallbackPointer).l
	bset	#3,(disflags).w
	bclr	#0,(sflags).w
	bclr	#0,(sflags3).w
	clr.w	(glovecords).w
	clr.b	(iflags).w
	st	(RefCnt).w
	bclr	#1,(sflags2).w
	st	(passplayer).w
	jsr	(RestoreGameScreen).l
	clr.w	(Vpos).w
	clr.w	(Hpos).w
	move.w	#0,(puckx).w
	move.w	#0,(pucky).w
	clr.w	(puckz).w
	clr.w	(puckvx).w
	clr.w	(puckvy).w
	clr.w	(puckvz).w
	st	(puckc).w
	movea.w	#(SortCords+(12*SCstruct)-M68K_RAM),a0	;goal net SCstruct
	clr.w	Xvel(a0)
	clr.w	Yvel(a0)
	clr.w	(a0)
	move.w	#$112,Ypos(a0)
	adda.w	#SCstruct,a0
	clr.w	Xvel(a0)
	clr.w	Yvel(a0)
	clr.w	(a0)
	move.w	#$FEEE,Ypos(a0)
	movea.w	#(SortCords+((puckscnum+1)*SCstruct)-M68K_RAM),a0	;puck shadow SCstruct
	move.w	#$1B3,6(a0)
	clr.w	SPA(a0)
	clr.w	4(a0)
	clr.w	(SortCords+(puckscnum*SCstruct)+attribute).w
	bclr	#6,(sflags).w
	moveq	#$64,d4
.2
	jsr	(checkwindow).l
	dbf	d4,.2
	move.w	#$3C,(yleader).w
	jsr	(ResetBench).l
	movea.w	#(tmstruct-M68K_RAM),a2
	jsr	(setpersonel).l
	bsr.w	SetupPenaltyShot
	adda.w	#tmsize,a2
	jsr	(setpersonel).l
	bsr.w	SetupPenaltyShot
	jsr	(resetplstuff).l
	move.l	a3,-(sp)
	movea.l	#SortCords+(11*SCstruct),a3	;away goalie SCstruct
	move.w	#$B,d2	;11 = # of player SCstructs
.3
	cmp.w	(BA_Sktr_SCnum).w,d2
	beq.w	.4
	cmp.w	(BA_Goalie_SCnum).w,d2
	beq.w	.9
	move.w	#$FF10,(a3)
	clr.w	Ypos(a3)
	clr.w	6(a3)
	move.w	#$1D,d0
	jsr	(assinsert).l
	bra.w	.15
.4
	tst.w	position(a3)
	bpl.w	.6
	bclr	#2,pflags2(a3)
	beq.w	.6
	movem.l	d0-d7/a0-a6,-(sp)
	clr.w	d3
	move.b	pnum(a3),d3
	jsr	(setplayer).l
	movem.l	(sp)+,d0-d7/a0-a6
	tst.w	position(a3)
	beq.w	.5
	bpl.w	.6
.5
	nop
.6
	move.w	(puckx).w,d0
	subi.w	#0,d0
	move.w	d0,(a3)
	move.w	(pucky).w,d0
	btst	#7,pflags(a3)
	bne.w	.7
	addi.w	#$10,d0
	move.w	#4,facedir(a3)
	bra.w	.8
.7
	addi.w	#-$10,d0
	move.w	#0,facedir(a3)
.8
	move.w	d0,Ypos(a3)
	clr.w	Xvel(a3)
	clr.w	Yvel(a3)
	clr.w	Zvel(a3)
	move.w	#$E,d0
	jsr	(assinsert).l
	bra.w	.15
.9
	btst	#0,(gmode2).w
	beq.w	.10
	move.b	(shootoutteam-1).w,pnum(a3)
	tst.w	(shootoutteam).w
	beq.w	.11
	move.b	(homeshootnum-1).w,pnum(a3)
	bra.w	.11
.10
	tst.w	position(a3)
	bpl.w	.13
	bclr	#2,pflags2(a3)
	beq.w	.13
.11
	movem.l	d0-d7/a0-a6,-(sp)
	clr.w	d3
	move.b	pnum(a3),d3
	jsr	(setplayer).l
	movem.l	(sp)+,d0-d7/a0-a6
	tst.w	position(a3)
	bne.w	.12
	bpl.w	.13
.12
	nop
.13
	bclr	#2,pflags2(a3)
	move.w	#0,d0
	move.w	#$E5,d1
	btst	#7,pflags(a3)
	bne.w	.14
	move.w	#$FF1B,d1
.14
	move.w	d0,(a3)
	move.w	d1,Ypos(a3)
	clr.w	Xvel(a3)
	clr.w	Yvel(a3)
	clr.w	Zpos(a3)
	sub.w	(puckx).w,d0
	sub.w	(pucky).w,d1
	neg.w	d0
	neg.w	d1
	jsr	(vtoa).l
	move.w	d0,facedir(a3)
	bclr	#2,pflags2(a3)
	bclr	#5,pflags(a3)
	move.w	#$B5C,d1
	jsr	(SetSPA).l
.15
	suba.l	#SCstruct,a3
	dbf	d2,.3
	jsr	(SprSort).l
	movea.l	(sp)+,a3
	jsr	(AssignPads).l
	move.w	(BA_Goalie_SCnum).w,d0
	asl.w	#7,d0
	movea.w	#(SortCords-M68K_RAM),a3
	adda.w	d0,a3
	move.w	#0,(a3)
	move.w	#$FF06,Ypos(a3)
	btst	#7,pflags(a3)
	bne.w	.16
	move.w	#$FA,Ypos(a3)
.16
	move.w	(BA_Goalie_SCnum).w,d0
	move.w	#1,d1
	btst	#6,pflags(a3)
	beq.w	.17
	move.w	#2,d1
.17
	cmp.w	(cont1team).w,d1
	bne.w	.18
	jsr	(setc1player).l
	bra.w	.19
.18
	cmp.w	(cont2team).w,d1
	bne.w	.19
	jsr	(setc2player).l
.19
	move.w	#6,d0
	jsr	(assreplace).l
	bset	#7,(BA_PS_flags).w
	bset	#2,(sflags2).w
	move.w	#$190,(msgtimer).w
	tst.w	(cont1team).w
	bne.w	.20
	tst.w	(cont2team).w
	bne.w	.20
	move.w	#$64,(msgtimer).w
.20
	move.w	#$18,(palcount).w
	movem.l	(sp)+,d0-d7/a0-a6
	rts
.21
	bset	#2,(gmode2).w
	move.w	#1,d0
	jsr	(assreplace).l
	clr.w	Xvel(a3)
	clr.w	Yvel(a3)
	rts

PenShotTable	;Penalty shot data. Unreferenced
	dc.b	0,1,2,3,4,5,6,0,0,1,5,3,4,2,0,0
	dc.b	0,3,5,1,4,0,0,0,0,0
	dc.w	$FF06,$FFDD,$FFCE,$0023,$FFCE,$FFCE,$FFF6,$0000,$FFF1,$0032,$FFF6,$0000,$FFC4

UpdatePenaltyShotEnd	;The shot ends (BA_PS_flags bit 4) when the goalie has the puck, the loose puck timer or the clock runs out; the first time AddPenalty2 $A. Runs on into EndPenaltyShotPlay
	movem.w	d0,-(sp)
	move.w	(puckc).w,d0
	cmp.w	(BA_Goalie_SCnum).w,d0
	movem.w	(sp)+,d0
	beq.w	.2
	btst	#5,(BA_PS_flags).w
	beq.w	.3
	btst	#5,(gmode2).w
	bne.w	.0
	tst.w	(puckc).w
	bpl.w	.1
	bset	#5,(gmode2).w
.0
	tst.w	(puckc).w
	bpl.w	.2
.1
	tst.w	(passmodetimer).w
	bmi.w	.2
	subq.w	#1,(passmodetimer).w
	bra.w	.3
.2
	bset	#4,(BA_PS_flags).w
.3
	tst.w	(shootoutclock).w
	bne.w	.4
	bset	#4,(BA_PS_flags).w
.4
	btst	#4,(BA_PS_flags).w
	bne.w	.5
	rts
.5
	btst	#6,(BA_PS_flags).w
	bne.w	PenaltyShotEndReturn
	bset	#6,(BA_PS_flags).w
	move.w	#$A,d0
	jsr	(AddPenalty2).l

EndPenaltyShotPlay	;LockScroll, end the penalty shot play (the BA flags), the shooter newpnum back, then CountShootoutGoals
	jsr	(LockScroll).l
	btst	#0,(gmode2).w
	bne.w	.0
	move.w	#$A,(replaydelay).w
	bset	#2,(sflags2).w
.0
	bset	#0,(gmode).w
	bclr	#2,(gmode2).w
	bclr	#2,(BA_PS_flags).w
	bclr	#3,(BA_PS_flags).w
	bclr	#5,(BA_PS_flags).w
	bclr	#4,(BA_PS_flags).w
	bclr	#6,(BA_PS_flags).w
	movem.l	d0/a0,-(sp)
	movea.l	#SortCords,a0
	move.w	(BA_Sktr_SCnum).w,d0
	asl.w	#7,d0
	move.b	(savednewpnum).w,newpnum(a0,d0.w)
	movem.l	(sp)+,d0/a0
	jsr	(CountShootoutGoals).l

PenaltyShotEndReturn	;Shared rts
	rts

SetupPenaltyShot	;Penalty shot for team a2: the shooter plays center (BA_Skater_Offset), the goalie stays, the other players unavailable (assreplace $1D)
	movem.l	d0-d5/a0-a3,-(sp)
	movea.w	$22(a2),a3
	moveq	#5,d4
.0
	move.w	SCnum(a3),d0
	cmp.w	(BA_Sktr_SCnum).w,d0
	beq.w	.1
	cmp.w	(BA_Goalie_SCnum).w,d0
	beq.w	.2
	bset	#2,pflags2(a3)
	move.w	#$1D,d0
	jsr	(assreplace).l
	bra.w	.4
.1
	jsr	(Setplass).l
	move.b	newpnum(a3),(savednewpnum).w
	move.b	(BA_Skater_Offset+1).w,newpnum(a3)
	move.w	#4,position(a3)
	bra.w	.3
.2
	jsr	(Setplass).l
	clr.w	position(a3)
.3
	clr.w	d3
	move.b	newpnum(a3),d3
	add.w	d3,d3
	move.w	#$FFFF,$68(a2,d3.w)
	lsr.w	#1,d3
	jsr	(setplayer).l
.4
	st	newpnum(a3)
	st	newpos(a3)
	adda.w	#SCstruct,a3
	dbf	d4,.0
	movem.l	(sp)+,d0-d5/a0-a3
	rts

PenaltyShotBox	;In a shootout PlayoffRoundScreen; else the "PENALTY SHOT!" box: the shooter, the penalty (Penaltylist) and " by" the checker
	bset	#7,(gmode2).w
	btst	#0,(gmode2).w
	beq.w	.0
	jmp	(PlayoffRoundScreen).l
.0
	movem.l	d0-d2/a0-a4,-(sp)
	move.w	#$FFFF,d0
	jsr	(prefmes).l	;d0 = -1
	jsr	(printz).l
	String	-(TXPRI+TXMAP1),$3,$2,$0
	moveq	#$1B,d0
	moveq	#8,d1
	jsr	(Framer).l
	lea	PenShotBigTxt(pc),a1
	jsr	(printbig1).l
	move.w	(BA_Sktr_SCnum).w,d0
	asl.w	#7,d0	;sprite structs are $80 bytes
	movea.l	#SortCords,a2
	adda.w	d0,a2
	clr.w	d0
	move.b	$66(a2),d0	;roster slot
	movea.l	#tmstruct,a2
	tst.w	(BA_Team).w
	beq.w	.1
	movea.l	#AwShots,a2
.1
	jsr	(FormatPlayerNumInitial).l
	jsr	(print).l
	jsr	(printz).l
	String	-(TXPRI+TXMAP1),$4,$7,$0
	movem.l	a1/a3,-(sp)
	move.w	(pspenalty).w,d0
	movea.l	#Penaltylist,a1
	adda.w	(a1,d0.w),a1
	lea	2(a1),a1
	jsr	(print).l
	movem.l	(sp)+,a1/a3
	jsr	(printz).l
	String	' by',-(TXPRI+TXMAP1),$4,$8
	move.w	(BA_Checker_Offset).w,d0
	movea.l	#AwShots,a2
	tst.w	(BA_Team).w
	beq.w	.2
	movea.l	#tmstruct,a2
.2
	jsr	(FormatPlayerNumInitial).l
	jsr	(print).l
	movem.l	(sp)+,d0-d2/a0-a4
	rts

PenShotBigTxt	;PenaltyShotBox big text
	String	$BF,$4,$3,'PENALTY SHOT!',$BF,$4,$5,$0

PenShotChk	;A breakaway shooter hit: a penalty shot when penalty d0 allows one (PenShotPenalties); d0 = the penalty
	movem.l	d1-d3/a0,-(sp)
	btst	#pf3break,pflags3(a2)	;breakaway
	beq.w	.0
	btst	#3,(gmode).w
	bne.w	.0
	movem.w	d2,-(sp)
	move.w	(PBnum).w,d2
	andi.w	#$FF00,d2
	movem.w	(sp)+,d2
	bne.w	.0
	btst	#3,(BA_PS_flags).w
	beq.w	.1
.0
	move.w	#$FFFF,d1
	bra.w	.3
.1
	movea.l	#PenShotPenalties,a0
	move.w	(a0,d0.w),d1
	bmi.w	.3
	move.w	SCnum(a2),d2	;SCnum
	movem.w	d0-d1,-(sp)
	move.w	d2,d0
	jsr	(getBAplayerInfo).l
	movem.w	(sp)+,d0-d1
	bpl.w	.2
	bclr	#3,(BA_PS_flags).w
	bra.s	.0
.2
	move.w	d1,(pspenalty).w
	move.w	d1,d0	;return the penalty shot penalty
.3
	movem.l	(sp)+,d1-d3/a0
	rts

getBAplayerInfo	;Keep the breakaway shooter, team, goalie and checker for the penalty shot; N clear when set
	movem.l	d1-d3/a1,-(sp)
	tst.w	(OptPen).w
	beq.w	.4
	bset	#3,(BA_PS_flags).w
	movem.w	d0,-(sp)
	move.w	#5,d1
	move.w	#0,d2
	cmp.w	#5,d0
	bgt.w	.0
	move.w	#$B,d1
	move.w	#1,d2
.0
	move.w	d1,d0
	jsr	(getGoalieSCnum).l
	tst.w	d0
	bpl.w	.1
	movem.w	(sp)+,d0	;no goalie
	bclr	#3,(BA_PS_flags).w
	bra.w	.3
.1
	move.w	d0,d1	;d1 = goalie's SCnum
	move.w	(sp)+,d0	;d0 now back to player checked on breakaway SCnum
	move.w	d0,(BA_Sktr_SCnum).w
	movea.l	#SortCords,a1
	move.w	d0,d3
	asl.w	#7,d3	;scsize
	move.w	#0,(BA_Team).w
	btst	#6,pflags(a1,d3.w)
	beq.w	.2
	move.w	#1,(BA_Team).w
.2
	move.w	#0,(BA_Skater_Offset).w
	move.b	pnum(a1,d3.w),(BA_Skater_Offset+1).w
	move.w	d1,(BA_Goalie_SCnum).w
	asl.w	#7,d1	;scsize
	move.w	#0,(BA_Goalie_Offset).w
	move.b	pnum(a1,d1.w),(BA_Goalie_Offset+1).w
	move.w	#0,(BA_Checker_Offset).w
	move.b	pnum(a3),(BA_Checker_Offset+1).w
.3
	movem.l	(sp)+,d1-d3/a1
	rts
.4
	move.w	#$FFFF,d1	;N set: no penalty shot
	bra.s	.3

ShortenMsgTimer	;Cap the message timer at 2, unless a second pad is on and a3 is not the puck carrier
	movem.l	d0,-(sp)
	tst.w	(cont2team).w
	beq.w	.0
	move.w	SCnum(a3),d0
	cmp.w	(puckc).w,d0
	bne.w	.1
.0
	cmpi.w	#2,(msgtimer).w
	ble.w	.1
	move.w	#2,(msgtimer).w
.1
	movem.l	(sp)+,d0
	rts
