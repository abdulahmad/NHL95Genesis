;	Stats screens. This file shows the game statistics, the player stats of the pause menu and
;	the season's player stats, team stats and league leaders, and runs the line editor, the
;	three stars and the highlights of the day's games.

;-------------------------------------------------------------------------------------------------------------
;	The game statistics screens.


	include	macros\genesis.mac		;String

StatsReport							;Pause menu GAME STATS: both teams' totals
									;(DisplayStats). There are more rows than the screen: up / down scroll
									;them (matchupvis the most, $70 or $30 without penalties, OptPen), start
									;exits (ExitStatsScreen). 95 draws the screen with DrawTeamScreen2
	moveq	#9,d0
	moveq	#$19,d1
	move.l	#ControllerBgMap,(screenarg).l
	jsr	(DrawTeamScreen2).l
	jsr	(printbigz).l
	String	-(TXPRI+TXMAP3),7,2,'Game',-(TXPRI+TXMAP3),$10,2,'Statistics',-(TXPRI+TXMAP3),7,1,0
	clr.w	(DispAttribCtr).w
	clr.w	(VertLineScrolling).w
	clr.w	(PlayerScrollCtr).w
	move.w	#$70,(matchupvis).w		;the most scroll: 15 rows
	tst.w	(OptPen).w
	bne.w	.0
	move.w	#$30,(matchupvis).w		;11 rows
.0
	bsr.w	DisplayStats
	bsr.w	PrintStatScrollArrows
.loop
	jsr	(vcountwait).l
	jsr	(ReadMenuJoy).l
	btst	#7,d3
	beq.w	.1
	jmp	ExitStatsScreen
.1
	jsr	(nodiag).l
	move.w	#$FFFE,d0
	btst	#0,d3
	bne.w	.2
	neg.w	d0
	btst	#1,d3
	beq.w	.3
.2
	move.w	d0,(PlayerScrollCtr).w
.3
	bsr.w	StatScrollStep
	bsr.w	PrintStatScrollArrows
	bra.s	.loop
StatScrollStep						;One scroll step of PlayerScrollCtr, within 0 ... matchupvis
	move.w	(PlayerScrollCtr).w,d0
	beq.w	rtsStatTables
	add.w	(VertLineScrolling).w,d0
	bmi.w	rtsStatTables
	cmp.w	(matchupvis).w,d0
	bgt.w	rtsStatTables
	move.w	(VertLineScrolling).w,d1
	move.w	d0,(VertLineScrolling).w
	andi.w	#$F,d0
	bne.w	.5
	clr.w	(PlayerScrollCtr).w
.5
	andi.w	#$F,d1
	bne.w	SetStatScroll
	move.w	d0,-(sp)
	cmp.w	#$E,d0
	bne.w	.6
	bsr.w	StatScrollRow
.6
	move.w	(sp)+,d0
	cmp.w	#2,d0
	bne.w	SetStatScroll
	bsr.w	StatScrollRowEnd
SetStatScroll						;Plane A vertical scroll (VSRAM 0) = VertLineScrolling - $50, with
									;disflags bit 2 set while it writes
	move.w	(disflags).w,-(sp)
	bset	#dfng,(disflags).w
	movea.l	#Vdata,a0
	move.l	#VSRAM_W+(2<<16),Vctrl-Vdata(a0)
	move.w	#$FFB0,d0
	add.w	(VertLineScrolling).w,d0
	move.w	d0,(a0)
	move.w	(sp)+,(disflags).w
	rts
StatScrollRow						;d3 = VertLineScrolling / 16
	move.w	(VertLineScrolling).w,d3
	lsr.w	#4,d3
	bra.w	rtsStatScroll
StatScrollRowEnd					;d3 = VertLineScrolling / 16 + 6
	move.w	(VertLineScrolling).w,d3
	lsr.w	#4,d3
	addq.w	#6,d3
	bra.w	rtsStatScroll
rtsStatScroll						;rts of StatScrollRow / StatScrollRowEnd
	rts
PrintStatScrollArrows				;Scroll arrows (printz2): up ($7B) when VertLineScrolling > 0, down ($7D)
									;when it is below matchupvis
	movem.l	d0-d7/a0-a6,-(sp)
	jsr	(printsmallz).l
	String	CC_SetFont,1
	tst.w	(VertLineScrolling).w
	beq.w	.0
	jsr	(printsmallz).l
	String	CC_SetMapAndPosition,4,3,'$',9,CC_SetFont,1,'{'
	bra.w	.1
.0
	jsr	(printsmallz).l
	String	CC_SetMapAndPosition,4,3,'$',9,CC_SetFont,1,' '
.1
	move.w	(matchupvis).w,d0
	cmp.w	(VertLineScrolling).w,d0
	beq.w	.2
	jsr	(printsmallz).l
	String	CC_SetMapAndPosition,4,3,'$',$19,CC_SetFont,1,'}'
	bra.w	.3
.2
	jsr	(printsmallz).l
	String	CC_SetMapAndPosition,4,3,'$',$19,CC_SetFont,1,' '
.3
	jsr	(printsmallz).l
	String	CC_SetFont,0
	movem.l	(sp)+,d0-d7/a0-a6
	rts
DisplayStats						;Team blocks (PutTeamBlock), then each
									;TeamStatTextTbl row (TeamStatTextTblNoPen when penalties are off, OptPen)
									;centred, with the home value at x $22 and the visitors' at x 9
									;(PrintStatValue); SetStatScroll first
	jsr	(printz).l
	String	-(TXPRI+TXMAP3),3,6,0
	move.w	#$2C,d0
	jsr	(PutTeamBlock).l
	jsr	(printz).l
	String	-(TXPRI+TXMAP3),$1A,6,0
	moveq	#0,d0
	jsr	(PutTeamBlock).l
	bsr.w	SetStatScroll
	jsr	(printz).l
	String	-(TXPRI+TXMAP2),0,0,0
	moveq	#$E,d6
	lea	TeamStatTextTbl(pc),a1
	tst.w	(OptPen).w
	bne.w	.row
	move.w	#$A,d6
	lea	TeamStatTextTblNoPen(pc),a1
.row
	move.w	(a1),d0
	lsr.w	#1,d0
	neg.w	d0
	addi.w	#$15,d0
	move.w	d0,(printx).w
	jsr	(print).l
	movea.l	a1,a0
	move.w	#$22,(printx).w
	movea.w	#(tmstruct-M68K_RAM),a2
	bsr.w	PrintStatValue
	move.w	#9,(printx).w
	lea	tmsize(a2),a2
	bsr.w	PrintStatValue
	lea	4(a0),a1
	addq.w	#2,(printy).w
	dbf	d6,.row
	rts
PrintStatValue						;Print TeamStatTextTbl entry a0 for team a2 centred at printx: the value
									;(offsets $A and $354 are times, PushTime), "/second" if any, " (pct%)"
									;for passing; offset $FFFF is the shooting percentage (goals $C * 100 /
									;shots 0), printed with a "%"
	movea.w	#(mesarea-M68K_RAM),a3
	move.w	#2,(a3)
	cmpi.w	#$FFFF,(a0)				;shooting percentage row
	bne.w	.1
	move.w	#$C,d0
	move.w	(a2,d0.w),d0
	mulu.w	#$64,d0
	move.w	#0,d1
	move.w	(a2,d1.w),d1
	beq.w	.0
	divu.w	d1,d0
.0
	jsr	(PushNumber).l
	jsr	(appstring).l
	jsr	(appendz).l
	String	'%'
	bra.w	.x
.1
	move.w	(a0),d0
	move.w	(a2,d0.w),d0
	cmpi.w	#$354,(a0)				;PP Minutes: a time (94 $352)
	bne.w	.2
	bsr.w	.8
	bra.w	.4
.2
	cmpi.w	#$A,(a0)
	beq.w	.3
	bsr.w	.7
.3
	cmpi.w	#$A,(a0)
	bne.w	.4
	bsr.w	.8
.4
	jsr	(appstring).l
	move.w	2(a0),d0
	bmi.w	.x
	jsr	(appendz).l
	String	'/'
	move.w	(a2,d0.w),d0
	jsr	(PushNumber).l
	jsr	(appstring).l
	cmpi.w	#$14,(a0)
	bne.w	.x
	jsr	(appendz).l
	String	' ('
	move.w	(a0),d0
	move.w	(a2,d0.w),d0
	mulu.w	#$64,d0
	move.w	2(a0),d1
	move.w	(a2,d1.w),d1
	beq.w	.5
	divu.w	d1,d0
.5
	jsr	(PushNumber).l
	jsr	(appstring).l
	jsr	(appendz).l
	String	'%)'
.x
	movea.w	a3,a1
	move.w	(a1),d0
	lsr.w	#1,d0
	sub.w	d0,(printx).w
	jmp	print
.7
	jmp	PushNumber
.8
	jmp	PushTime
TeamStatTextTbl						;Label, then the team struct stat offset and the second offset ($FFFF
									;none). 15 rows; the offsets from $354 are 2 more than 94 (95 team struct)
	String	'Score'
	dc.w	$C,$FFFF
	String	'Shots'
	dc.w	0,$FFFF
	String	'Shooting Pct'
	dc.w	$FFFF,$FFFF
	String	'Power Play'
	dc.w	2,4
	String	'PP Minutes'
	dc.w	$354,$FFFF
	String	'PP Shots'
	dc.w	$356,$FFFF
	String	'SH Goals'
	dc.w	$358,$FFFF
	String	'Breakaways'
	dc.w	$35C,$35A
	String	'One-Timers'
	dc.w	$360,$35E
	String	'Penalty Shots'
	dc.w	$364,$362
	String	'Faceoffs Won'
	dc.w	$E,$FFFF
	String	'Body Checks'
	dc.w	$10,$FFFF
	String	'Penalties'
	dc.w	6,8
	String	'Attack Zone'
	dc.w	$A,$FFFF
	String	'Passing'
	dc.w	$14,$12
TeamStatTextTblNoPen				;The rows without the power play ones, used when penalties are off. 11
									;rows
	String	'Score'
	dc.w	$C,$FFFF
	String	'Shots'
	dc.w	0,$FFFF
	String	'Shooting Pct'
	dc.w	$FFFF,$FFFF
	String	'Breakaways'
	dc.w	$35C,$35A
	String	'One-Timers'
	dc.w	$360,$35E
	String	'Penalty Shots'
	dc.w	$364,$362
	String	'Faceoffs Won'
	dc.w	$E,$FFFF
	String	'Body Checks'
	dc.w	$10,$FFFF
	String	'Penalties'
	dc.w	6,8
	String	'Attack Zone'
	dc.w	$A,$FFFF
	String	'Passing'
	dc.w	$14,$12

;-------------------------------------------------------------------------------------------------------------
;	The player stats screen, saving season stats, the season stats and leaders screens, the line editor,
; the three stars and the season highlights. New in 95: the season stats, leaders and highlights screens.



rtsStatTables						;Shared rts
	rts

PlayerStatsScreen					;Pause menu PLAYER STATS: PlayerStatsList with d7 = 0 (this game)
	clr.w	d7

PlayerStatsList						;Stats screen for team a2, d7 = 0 game / 1 playoff
	moveq	#$D,d0
	moveq	#$18,d1
	move.l	#PlayerStatsBgMap,(screenarg).l
	jsr	(DrawTeamScreen3).l
	movem.l	d0-d3/d5-d7/a0-a6,-(sp)
	jsr	(printz).l
	String	-(TXPRI+TXMAP3),0,6,0
	movea.l	#PlayerStatsTitleMap,a0
	movea.l	a0,a1
	movea.l	a0,a2
	adda.l	(a2)+,a0
	adda.l	(a2)+,a1
	clr.w	d0
	clr.w	d1
	move.w	(a1),d2
	move.w	2(a1),d3
	moveq	#4,d5
	jsr	(dobitmap).l
	movem.l	(sp)+,d0-d3/d5-d7/a0-a6
	clr.w	(DispAttribCtr).w
	clr.w	(VertLineScrolling).w
.redraw
	clr.w	(PlayerScrollCtr).w
	jsr	(printz).l
	String	-(TXPRI+TXMAP3),5,1,0
	tst.w	d7
	beq.w	.title
	jsr	(printbigz).l
	String	-(TXPRI+TXMAP3),7,4,'Playoff',-(TXPRI+TXMAP3),$17,4,'Stats',-(TXPRI+TXMAP3),$E,1,0
	bra.w	.team
.title
	jsr	(printsmallz).l
	String	CC_SetMapAndPosition,4,3,$C,$1A,CC_SetFont,3,'A^-^Switch^Teams',CC_SetFont,0,0
	jsr	(printbigz).l
	String	-(TXPRI+TXMAP3),8,4,'Player',-(TXPRI+TXMAP3),$15,4,'Stats',-(TXPRI+TXMAP3),$E,1
.team
	clr.w	d0
	cmpa.w	#(tmstruct-M68K_RAM),a2
	beq.w	.home
	move.w	#$2C,d0
.home
	jsr	(PutTeamBlock).l
	bsr.w	DrawStatsList
	bsr.w	DrawStatsListArrows
.loop
	jsr	(vcountwait).l
	jsr	(ReadMenuJoy).l
	btst	#7,d3
	beq.w	.0
	jmp	(ExitStatsScreen).l
.0
	btst	#6,d1
	bne.w	.switch
	jsr	(nodiag).l
	moveq	#1,d0
	btst	#3,d1
	bne.w	.col
	neg.w	d0
	btst	#2,d1
	bne.w	.col
	moveq	#-2,d0
	btst	#0,d3
	bne.w	.set
	neg.w	d0
	btst	#1,d3
	beq.w	.scroll
.set
	move.w	d0,(PlayerScrollCtr).w
.scroll
	bsr.w	UpdateStatsListScroll
	bra.s	.loop
.col
	add.w	(DispAttribCtr).w,d0
	cmp.w	#$FFFF,d0
	blt.s	.scroll
	cmp.w	#4,d0
	bgt.s	.scroll
	move.w	d0,(DispAttribCtr).w
	bsr.w	DrawStatsList
	bsr.w	DrawStatsListArrows
	bra.s	.scroll
.switch
	tst.w	d7
	bne.s	.scroll
	lea	tmsize(a2),a2
	cmpa.w	#(AwShots-M68K_RAM),a2
	beq.w	.redraw
	movea.w	#(tmstruct-M68K_RAM),a2
	bra.w	.redraw

UpdateStatsListScroll				;Stats screen per frame: scroll 0 ... SelectedPlayerIdx, stop on a 16 line
									;boundary, draw the row coming into view
	move.w	(PlayerScrollCtr).w,d0
	beq.w	rtsStatsList
	add.w	(VertLineScrolling).w,d0
	bmi.w	rtsStatsList
	cmp.w	(SelectedPlayerIdx).w,d0
	bgt.w	rtsStatsList
	move.w	(VertLineScrolling).w,d1
	move.w	d0,(VertLineScrolling).w
	andi.w	#$F,d0
	bne.w	.0
	bsr.w	DrawStatsListArrows
	clr.w	(PlayerScrollCtr).w
.0
	andi.w	#$F,d1
	bne.w	SetStatsListScrollReg
	move.w	d0,-(sp)
	cmp.w	#$E,d0
	bne.w	.1
	bsr.w	DrawStatsRowUp
.1
	move.w	(sp)+,d0
	cmp.w	#2,d0
	bne.w	SetStatsListScrollReg
	bsr.w	DrawStatsRowDown

SetStatsListScrollReg				;VSRAM = VertLineScrolling - $68
	move.w	(disflags).w,-(sp)
	bset	#dfng,(disflags).w
	movea.l	#Vdata,a0
	move.l	#VSRAM_W+(2<<16),Vctrl-Vdata(a0)
	move.w	#$FF98,d0
	add.w	(VertLineScrolling).w,d0
	move.w	d0,(a0)
	move.w	(sp)+,(disflags).w

rtsStatsList						;rts (shared exit of the DisplayAttribute routines)
	rts

DrawStatsRowUp						;Draw the stats row at the top of the view (VertLineScrolling / 16)
	move.w	(VertLineScrolling).w,d3
	lsr.w	#4,d3
	bra.w	DrawStatsRow

DrawStatsRowDown					;Draw the stats row at the bottom of the view (VertLineScrolling / 16 + 6)
	move.w	(VertLineScrolling).w,d3
	lsr.w	#4,d3
	addq.w	#6,d3
	bra.w	DrawStatsRow

DrawStatsList						;Draw the stats screen column headers (the selected column highlighted,
									;DispAttribCtr), the title and the rows
	jsr	(printsmallz).l
	String	CC_SetMapAndPosition,4,3,4,9,CC_SetFont,1,'Player',CC_AddX,7,0
	lea	StatColumnHeaders(pc),a1
	moveq	#5,d3
	tst.w	(DispAttribCtr).w
	bmi.w	.head
	adda.w	(a1),a1
	clr.w	d3
.head
	move.w	#$8000,(printa).w
	cmp.w	(DispAttribCtr).w,d3
	bne.w	.1
	move.w	#$C000,(printa).w
.1
	jsr	(printsmall).l
	addq.w	#1,d3
	cmp.w	#5,d3
	blt.s	.head
	jsr	(printsmallz).l
	String	CC_SetMapAndPosition,4,3,9,7,0
	jsr	(printsmallz).l
	String	CC_SetFont,1
	jsr	(printz).l
	String	-(TXPRI+TXMAP3),$A,7,0
	lea	StatSortTitles(pc),a1
	moveq	#1,d0
	add.w	(DispAttribCtr).w,d0
	jsr	(PrintSmallListItem).l
	clr.w	(printfontset).w
	movea.w	#(Satt-M68K_RAM),a3
	clr.l	d6
	tst.w	(DispAttribCtr).w
	bpl.w	.sort
	jsr	(GetGoalieCount).l
	bset	d0,d6
	subq.w	#1,d6
	not.l	d6
.sort
	moveq	#-1,d4
	st	d5
	jsr	(GetPlayerCount).l
	bra.w	.next
.player
	btst	d0,d6
	bne.w	.next
	clr.w	d2
	bclr	#2,(sflags5).w
	move.w	(DispAttribCtr).w,d1
	bmi.w	.4
	bsr.w	GetStatColumn
.4
	btst	#2,(sflags5).w
	bne.w	.next
	ext.l	d2
	asl.l	#8,d2
	movem.l	d7/a0,-(sp)
	move.w	Xvel(a2),d7
	jsr	(GetRosterName).l
	adda.w	(a1),a1
	movem.l	(sp)+,d7/a0
	move.b	#$FF,d2
	sub.b	(a1),d2
	cmp.l	d4,d2
	ble.w	.next
	move.l	d2,d4
	move.w	d0,d5
.next
	dbf	d0,.player
	bset	d5,d6
	move.b	d5,(a3)+
	bpl.s	.sort
	moveq	#5,d0
.pad
	st	0(a3,d0.w)
	dbf	d0,.pad
	move.w	a3,d0
	subi.w	#(Satt+6-M68K_RAM),d0
	bpl.w	.8
	clr.w	d0
.8
	asl.w	#4,d0
	move.w	d0,(SelectedPlayerIdx).w
	cmp.w	(VertLineScrolling).w,d0
	bcc.w	.9
	move.w	d0,(VertLineScrolling).w
.9
	moveq	#5,d4
.ent
	move.w	(VertLineScrolling).w,d3
	lsr.w	#4,d3
	add.w	d4,d3
	bsr.w	DrawStatsRow
	dbf	d4,.ent
	bra.w	SetStatsListScrollReg

DrawStatsRow						;Stats screen row d3 of Satt: rank, name, then the 5 columns, or for
									;goalies saves, shots and save %
	movea.w	#(Satt-M68K_RAM),a4
	adda.w	d3,a4
	jsr	(printz).l
	String	-(TXPRI+TXMAP2),0,0,0
	add.w	d3,d3
	andi.w	#$1F,d3
	move.w	d3,(printy).w
	moveq	#$28,d0
	moveq	#1,d1
	move.w	#$7FF,d2
	jsr	(eraser).l
	tst.b	(a4)
	bmi.w	rtsStatsList
	subq.w	#1,(printy).w
	move.w	#1,(printx).w
	move.w	a4,d0
	subi.w	#(Satt-1-M68K_RAM),d0
	moveq	#2,d1
	move.w	#$E000,(printa).w
	jsr	(PushNumberWidth).l
	jsr	(print).l
	clr.w	d0
	move.b	(a4),d0
	jsr	(FormatPlayerName).l
	addq.w	#1,(printx).w
	move.w	#$8000,(printa).w
	jsr	(print).l
	move.w	#$11,(printx).w
	tst.w	(DispAttribCtr).w
	bmi.w	.goalie
	clr.w	d5
.col
	clr.w	d0
	move.b	(a4),d0
	move.w	d5,d1
	bsr.w	GetStatColumn
	move.w	d2,d0
	moveq	#4,d1
	jsr	(PushNumberWidth).l
	move.w	#$8000,(printa).w
	cmp.w	(DispAttribCtr).w,d5
	bne.w	.1
	move.w	#$C000,(printa).w
.1
	jsr	(print).l
	addq.w	#1,d5
	cmp.w	#5,d5
	bne.s	.col
	bra.w	.x
.goalie
	clr.w	d0
	move.b	(a4),d0
	moveq	#3,d1
	bsr.w	ReadStatColumn
	clr.w	d0
	move.b	(a4),d0
	moveq	#0,d1
	move.w	d2,-(sp)
	bsr.w	ReadStatColumn
	move.w	(sp)+,d0
	move.w	d0,d3
	sub.w	d2,d0
	bpl.w	.2
	clr.w	d0
.2
	move.w	d0,d2
	moveq	#4,d1
	jsr	(PushNumberWidth).l
	addq.w	#1,(printx).w
	jsr	(print).l
	move.w	d3,d0
	moveq	#4,d1
	jsr	(PushNumberWidth).l
	addq.w	#2,(printx).w
	jsr	(print).l
	tst.w	d3
	beq.w	.3
	mulu.w	#$64,d2
	divu.w	d3,d2
.3
	move.w	d2,d0
	moveq	#4,d1
	jsr	(PushNumberWidth).l
	addq.w	#2,(printx).w
	jsr	(print).l
	jsr	(printz).l
	String	'%',0
.x
	rts

GetStatColumn						;d2 = stat column d1 for player d0. Goalies only have PIM; 95 sets sflags5
									;bit 2 for a goalie column it does not show (DrawStatsList leaves the
									;player out)
	bclr	#2,(sflags5).w
	move.w	d0,-(sp)
	jsr	(GetGoalieCount).l
	move.w	d0,d2
	move.w	(sp)+,d0
	cmp.w	d2,d0
	bge.w	ReadStatColumn
	clr.w	d2
	btst	d1,#6
	beq.w	SkipStatColumn
	moveq	#1,d1

ReadStatColumn						;d2 = stat column d1 for player d0. d7 = 0: the team struct byte arrays
									;(StatColumnOffsets); d7 = 1: the playoff tables (GetStatsValue)
	tst.w	d7
	bne.w	GetPlayoffStat
	lea	StatColumnOffsets(pc),a1
	asl.w	#2,d1
	adda.w	d1,a1
	move.w	(a1),d1
	add.w	d0,d1
	clr.w	d2
	move.b	0(a2,d1.w),d2
	move.w	2(a1),d1
	bmi.w	rtsStatsList
	add.w	d0,d1
	clr.w	d3
	move.b	0(a2,d1.w),d3
	add.w	d3,d2
	rts

SkipStatColumn						;The column is not shown for this goalie (sflags5 bit 2)
	bset	#2,(sflags5).w
	rts

GetPlayoffStat						;d7 = 1: G, A, ... from the playoff stat tables (GetStatsValue)
	asl.w	#2,d1
	add.w	d0,d0
	clr.w	d2
	bsr.w	GetStatsValue
	addq.w	#2,d1
	bsr.w	GetStatsValue
	lsr.w	#1,d0
	rts

GetStatsValue						;d2 += word d0 of the RAM table at StatsOffsetTbl2+d1 (0 = none)
	movea.l	#StatsOffsetTbl2,a1
	tst.w	0(a1,d1.w)
	beq.w	rtsStatsList
	movea.w	0(a1,d1.w),a1
	add.w	0(a1,d0.w),d2
	rts

StatsOffsetTbl2						;Playoff stat RAM tables per column (G, A, G+A, SOG, PIM)
	dc.w	$C954,0,$C988,0,$C954,$C988,$C9BC,0,$C9F0,0

StatColumnOffsets					;Team struct byte arrays per column, same order (94 + 2)
	dc.w	$B6,$FFFF,$D0,$FFFF,$B6,$D0,$EA,$FFFF,$104,$FFFF

StatColumnHeaders					;Column headers (goalie header, then 5 columns)
	String	'Saves Shots Save %  '
	String	'   G'
	String	'   A'
	String	' Pts'
	String	' SOG'
	String	' PIM'

StatSortTitles						;Sort column titles
	String	'    Goalie Saves   ]'
	String	'[      Goals       ]'
	String	'[     Assists      ]'
	String	'[      Points      ]'
	String	'[  Shots On Goal   ]'
	String	'[ Penalty Minutes   '

DrawStatsListArrows					;Up / down arrows (ScrollArrowTbl2). Saves d0-d1/a1
	movem.l	d0-d1/a1,-(sp)
	jsr	(printsmallz).l
	String	CC_SetMapAndPosition,4,3,'$',$C,CC_SetFont,3,0
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
	lea	ScrollArrowTbl2(pc),a1
	jsr	(PrintSmallListItem).l
	movem.l	(sp)+,d0-d1/a1
	rts

ScrollArrowTbl2						;None, up, down, both
	String	' ',$FB,$FF,$FA,$E,' ',$F9,0
	String	'{',$FB,$FF,$FA,$E,' ',$F9,0
	String	' ',$FB,$FF,$FA,$E,'}',$F9,0
	String	'{',$FB,$FF,$FA,$E,'}',$F9,0

InitSeasonStats						;New season: clear the player stat blocks (SRGoals on, $1B6C bytes),
									;SRTeamBlock2, SRTeamStats and SRInjuries in save RAM then
									;MarkSeasonRosters
	movem.l	d0-d7/a0-a6,-(sp)
	lea	(M68K_RAM).l,a0
	move.w	#$6DC,d0
	clr.l	d1
.loop
	move.l	d1,(a0)+
	dbf	d0,.loop
	move.l	#SRGoals,d0
	move.l	#5*NumPlayoffTeams*27*2,d1
	movea.l	#M68K_RAM,a0
	jsr	(WriteSRAM).l
	lea	(LeaderValues).w,a0
	move.w	#$42,d0
	clr.l	d1
.loop2
	move.l	d1,(a0)+
	dbf	d0,.loop2
	move.l	#SRTeamBlock2,d0
	move.l	#NumPlayoffTeams*10,d1
	movea.l	#LeaderValues,a0
	jsr	(WriteSRAM).l
	lea	(M68K_RAM).l,a0
	move.w	#$103,d0
	clr.l	d1
.loop3
	move.b	d1,(a0)+
	dbf	d0,.loop3
	move.l	#SRTeamStats,d0
	move.l	#NumPlayoffTeams*10,d1
	movea.l	#M68K_RAM,a0
	jsr	(WriteSRAM).l
	jsr	(MakeSRAMChecksum).l
	lea	(M68K_RAM).l,a0
	move.w	#NumTeams*27/2-1,d0
	clr.l	d1
.loop4
	move.b	d1,(a0)+
	dbf	d0,.loop4
	move.l	#SRInjuries,d0
	move.l	#NumTeams*27/2,d1
	movea.l	#M68K_RAM,a0
	jsr	(WriteSRAM).l
	jsr	(MakeSRAMChecksum).l
	jsr	(MarkSeasonRosters).l
	movem.l	(sp)+,d0-d7/a0-a6
	rts

SaveSimGame							;Save a finished season game: the cup winner, SimFlags bit 0 when a user
									;team won, player stats, highlights, both team
									;records and the injury ticks
	movem.l	d0-d7/a0-a6,-(sp)
	move.w	(tmstruct+$28).w,(SaveRAM+2*SRCupWinner).l
	move.w	(HmGoals).w,d7
	cmp.w	(AwGoals).w,d7
	bgt.w	.0
	move.w	(AwShots+$28).w,(SaveRAM+2*SRCupWinner).l
.0
	bclr	#0,(SimFlags).w
	move.w	#1,d0
	move.w	(HmGoals).w,d7
	cmp.w	(AwGoals).w,d7
	bgt.w	.1
	beq.w	.3
	move.w	#2,d0
.1
	cmp.w	(cont1team).w,d0
	beq.w	.2
	cmp.w	(cont2team).w,d0
	beq.w	.2
	cmp.w	(cont3team).w,d0
	beq.w	.2
	cmp.w	(cont4team).w,d0
	bne.w	.3
.2
	btst	#1,(SimFlags).w
	beq.w	.3
	bset	#0,(SimFlags).w
.3
	move.w	(HomeTeam).w,d7
	jsr	(GetGoalieCountD7).l
	move.w	d0,d6
	subq.w	#1,d6
	add.w	d6,d6
	move.w	d7,d0
	movea.l	#tmstruct,a1
	bsr.w	AddPlayerSeasonStats
	move.w	(VisTeam).w,d0
	movea.l	#AwShots,a1
	bsr.w	AddPlayerSeasonStats
	bsr.w	SaveGameHighlights
	move.w	(HomeTeam).w,d0
	movea.l	#tmstruct,a1
	movea.l	#AwShots,a2
	bsr.w	AddTeamSeasonStats
	move.w	(VisTeam).w,d0
	movea.l	#AwShots,a1
	movea.l	#tmstruct,a2
	bsr.w	AddTeamSeasonStats
	move.w	(tmstruct+$28).w,d0
	move.w	(AwShots+$28).w,d1
	jsr	(TickTeamInjuries).l
	movem.l	(sp)+,d0-d7/a0-a6
	rts

AddTeamSeasonStats					;Add the game totals of team a1 (a2 = other team) to team d0's record in
									;SRTeamStats (SRPOTeamStats in the playoffs
									;SeasonDay bit 5)
	mulu.w	#$A,d0
	btst	#5,(SeasonDay+1).w
	beq.w	.0
	addi.l	#SRPOTeamStats,d0
	bra.w	.1
.0
	addi.l	#SRTeamStats,d0
.1
	movea.l	#StatBuf,a0
	moveq	#$A,d1
	movem.l	d0-d1/a0,-(sp)
	jsr	(ReadSRAM).l
	movea.l	#StatBuf,a0
	move.w	$C(a1),d5
	add.w	d5,(a0)
	move.w	$C(a2),d5
	add.w	d5,2(a0)
	move.w	8(a1),d5
	add.w	d5,4(a0)
	move.w	(a1),d5
	add.w	d5,6(a0)
	move.w	(a2),d5
	add.w	d5,8(a0)
	movem.l	(sp)+,d0-d1/a0
	jsr	(WriteSRAM).l
	jsr	(MakeSRAMChecksum).l
	rts

AddPlayerSeasonStats				;Add the goals, assists, shots, penalty minutes (goalies: goals against
									;scaled to a full game) and games played of
									;team d0 (game stats a1) to its save RAM stat blocks; bit 15 marks the
									;players dressed (d6 = last one)
	move.l	#SRGoals,d2
	btst	#5,(SeasonDay+1).w
	beq.w	.0
	move.l	#SRPOGoals,d2
.0
	movem.l	d0/a1,-(sp)
	bsr.w	ReadStatBlock
.loop
	clr.w	d2
	move.b	$B6(a1),d2
	andi.w	#$7FFF,(a0,d0.w)
	add.w	d2,(a0,d0.w)
	cmp.w	d6,d0
	bgt.w	.2
	ori.w	#$8000,(a0,d0.w)
.2
	addq.w	#1,a1
	addq.w	#2,d0
	dbf	d7,.loop
	bsr.w	WriteStatBlock
	movem.l	(sp),d0/a1
	move.l	#SRAssists,d2
	btst	#5,(SeasonDay+1).w
	beq.w	.3
	move.l	#SRPOAssists,d2
.3
	bsr.w	ReadStatBlock
.loop2
	clr.w	d2
	move.b	$D0(a1),d2
	add.w	d2,(a0,d0.w)
	addq.w	#1,a1
	addq.w	#2,d0
	dbf	d7,.loop2
	bsr.w	WriteStatBlock
	movem.l	(sp),d0/a1
	move.l	#SRShots,d2
	btst	#5,(SeasonDay+1).w
	beq.w	.5
	move.l	#SRPOShots,d2
.5
	bsr.w	ReadStatBlock
.loop3
	clr.w	d2
	move.b	$EA(a1),d2
	andi.w	#$7FFF,(a0,d0.w)
	add.w	d2,(a0,d0.w)
	cmp.w	d6,d0
	bgt.w	.7
	ori.w	#$8000,(a0,d0.w)
.7
	addq.w	#1,a1
	addq.w	#2,d0
	dbf	d7,.loop3
	bsr.w	WriteStatBlock
	movem.l	(sp),d0/a1
	move.l	a4,-(sp)
	movea.l	a1,a4
	move.l	#SRPenMin,d2
	btst	#5,(SeasonDay+1).w
	beq.w	.8
	move.l	#SRPOPenMin,d2
.8
	bsr.w	ReadStatBlock
.loop4
	clr.w	d2
	cmp.w	d6,d0
	bgt.w	.skater
	move.b	$B6(a1),d2
	movem.l	d4-d5,-(sp)
	move.w	(PerTimeTotal).w,d4
	add.w	(PerTimeTotal).w,d4
	add.w	(PerTimeTotal).w,d4
	move.w	$138(a4),d5
	beq.w	.12
	ext.l	d4
	divu.w	d5,d4
	cmp.w	#1,d4
	bge.w	.10
	move.w	#1,d4
.10
	mulu.w	d4,d2
	cmp.l	#$7FFF,d2
	blt.w	.11
	move.w	#$7FFF,d2
.11
	add.w	d2,(a0,d0.w)
.12
	movem.l	(sp)+,d4-d5
	bra.w	.14
.skater
	move.b	$104(a1),d2
	add.w	d2,(a0,d0.w)
.14
	addq.w	#1,a1
	addq.w	#2,a4
	addq.w	#2,d0
	dbf	d7,.loop4
	bsr.w	WriteStatBlock
	movea.l	(sp)+,a4
	movem.l	(sp),d0/a1
	move.l	#SRGamesPlayed,d2
	btst	#5,(SeasonDay+1).w
	beq.w	.15
	move.l	#SRPOGamesPlayed,d2
.15
	bsr.w	ReadStatBlock
.loop5
	clr.w	d2
	tst.w	$138(a1)
	beq.w	.17
	cmp.w	d6,d0
	bgt.w	.17
	addq.w	#1,(a0,d0.w)
.17
	addq.w	#2,a1
	addq.w	#2,d0
	dbf	d7,.loop5
	bsr.w	WriteStatBlock
	movem.l	(sp)+,d0/a1
	jsr	(MakeSRAMChecksum).l
	rts

ReadStatBlock						;Read the $34 byte stat block of team d0 at save RAM d2 to StatBuf; saves
									;the address for WriteStatBlock. Returns d0 = 0
									;d7 = $19
	mulu.w	#$34,d0
	add.l	d2,d0
	movea.l	#StatBuf,a0
	moveq	#$34,d1
	movea.l	#StatWork+$14,a5
	movem.l	d0-d1/a0,-(a5)
	jsr	(ReadSRAM).l
	movea.l	#StatBuf,a0
	clr.w	d0
	move.w	#$19,d7
	rts

WriteStatBlock						;Write StatBuf back where ReadStatBlock read it
	movem.l	(a5)+,d0-d1/a0
	jmp	WriteSRAM

SaveGameHighlights					;Pick today's highlight of HomeTeam's game (most goals, best goalie, most
									;assists, the type in the top 3 bits) and save it
									;at GetHighlightSlot. Skipped with SeasonDay bit 3
	btst	#3,(SeasonDay+1).w
	bne.w	rtsHighlight
	movem.l	d0-d7/a0-a6,-(sp)
	movea.l	#StatBuf,a0
	clr.w	(a0)
	bclr	#1,(BA_PS_flags).w
	movea.l	#tmstruct,a2
	movea.l	#AwShots,a3
	move.w	(HmGoals).w,d0
	cmp.w	(AwGoals).w,d0
	bgt.w	.1
	blt.w	.0
	bset	#1,(BA_PS_flags).w
	bra.w	.1
.0
	movea.l	#AwShots,a2
	movea.l	#tmstruct,a3
.1
	movem.l	a2-a3,-(sp)
	bsr.w	MostGoals
	cmp.w	#2,d2
	blt.w	.2
	move.w	Xvel(a2),d0
	mulu.w	#$1A,d0
	add.w	d3,d0
	ori.w	#$2000,d0
	bsr.w	AddHighlight
.2
	movem.l	(sp),a2-a3
	movea.l	a3,a2
	bsr.w	MostGoals
	cmp.w	#3,d2
	blt.w	.3
	move.w	Xvel(a2),d0
	mulu.w	#$1A,d0
	add.w	d3,d0
	ori.w	#$2000,d0
	bsr.w	AddHighlight
.3
	movem.l	(sp),a2-a3
	bsr.w	BestGoalieSaves
	tst.w	tmscore(a3)
	bne.w	.saves
.shutout
	move.w	Xvel(a2),d0
	mulu.w	#$1A,d0
	add.w	d3,d0
	ori.w	#$6000,d0
	bsr.w	AddHighlight
	bra.w	.6
.saves
	cmp.w	#$18,d2
	bgt.s	.shutout
.6
	movem.l	(sp),a2-a3
	bsr.w	MostAssists
	move.l	a2,(StatWork).w
	move.w	d2,(SeasonGameCount).w
	move.w	d3,(StatWork+$6).w
	exg	a2,a3
	bsr.w	MostAssists
	cmp.w	(SeasonGameCount).w,d2
	bge.w	.7
	movea.l	(StatWork).w,a2
	move.w	(SeasonGameCount).w,d2
	move.w	(StatWork+$6).w,d3
.7
	cmp.w	#2,d2
	blt.w	.8
	move.w	Xvel(a2),d0
	mulu.w	#$1A,d0
	add.w	d3,d0
	ori.w	#$4000,d0
	bsr.w	AddHighlight
.8
	nop
	move.w	(StatBuf).w,d0
	andi.w	#$E000,d0
	bne.w	.9
	movem.l	(sp),a2-a3
	bsr.w	MostGoals
	move.w	Xvel(a2),d0
	mulu.w	#$1A,d0
	add.w	d3,d0
	ori.w	#$2000,d0
	bsr.w	AddHighlight
.9
	movem.l	(sp)+,a2-a3
	jsr	(GetHighlightSlot).l
	tst.w	d0
	bmi.w	.10
	movea.l	#StatBuf,a0
	moveq	#4,d1
	jsr	(WriteSRAM).l
	jsr	(MakeSRAMChecksum).l
.10
	movem.l	(sp)+,d0-d7/a0-a6
	rts

BestGoalieSaves						;d2 / d3 = the most saves (shots against - goals against) and its roster
									;slot in team a2
	movem.l	d4-d6/a2-a3,-(sp)
	jsr	(GetGoalieCount).l
	clr.w	d2
	clr.w	d3
	subq.w	#1,d0
	move.w	d0,d1
	clr.w	d0
	movea.l	a2,a3
	adda.l	#$B6,a2
	adda.l	#$EA,a3
.loop
	move.b	(a3,d0.w),d4
	sub.b	(a2,d0.w),d4
	bpl.w	.1
	clr.b	d4
.1
	cmp.b	d4,d2
	bge.w	.2
	move.b	d4,d2
	move.w	d0,d3
.2
	addq.w	#1,d0
	dbf	d1,.loop
	movem.l	(sp)+,d4-d6/a2-a3
	rts

MostAssists							;d2 / d3 = the most assists and its roster slot
									;among the skaters of team a2
	jsr	(GetGoalieCount).l
	move.w	#$1A,d1
	sub.w	d0,d1
	subq.w	#1,d1
	clr.w	d2
	clr.w	d3
	move.l	a2,-(sp)
	adda.l	#$D0,a2
.loop
	cmp.b	(a2,d0.w),d2
	bge.w	.1
	move.b	(a2,d0.w),d2
	move.w	d0,d3
.1
	addq.w	#1,d0
	dbf	d1,.loop
	movea.l	(sp)+,a2
	rts

MostGoals							;d2 / d3 = the most goals and its roster slot among the skaters of team a2
	jsr	(GetGoalieCount).l
	move.w	#$1A,d1
	sub.w	d0,d1
	subq.w	#1,d1
	clr.w	d2
	clr.w	d3
	move.l	a2,-(sp)
	adda.l	#$B6,a2
.loop
	cmp.b	(a2,d0.w),d2
	bge.w	.1
	move.b	(a2,d0.w),d2
	move.w	d0,d3
.1
	addq.w	#1,d0
	dbf	d1,.loop
	movea.l	(sp)+,a2
	rts

AddHighlight						;Make highlight d0 (type bits + team*$1A + slot) a roster id and keep it
									;at (a0) / value d2 unless (a0) already holds one
									;(CompareHighlight)
	move.w	d3,-(sp)
	movem.l	d7,-(sp)
	move.w	d0,d7
	andi.w	#$E000,d7
	move.w	d7,-(sp)
	move.w	d0,d7
	andi.w	#$1FFF,d7
	divu.w	#$1A,d7
	move.l	d7,d0
	swap	d0
	jsr	(GetRosterId).l
	or.w	(sp)+,d0
	movem.l	(sp)+,d7
	move.w	(a0),d1
	bsr.w	CompareHighlight
	beq.w	.1
	move.w	(a0),d1
	andi.w	#$E000,d1
	beq.w	.0
	bne.w	.1
.0
	move.w	d0,(a0)
	move.w	d2,2(a0)
.1
	move.w	(sp)+,d3
	rts

CompareHighlight					;Compare highlight d0 with the one in d1; d3 = 1 and Z clear when d1 is
									;empty
	move.w	d1,d3
	andi.w	#$E000,d3
	beq.w	.0
	andi.w	#$1FFF,d1
	move.w	d0,d3
	andi.w	#$1FFF,d3
	cmp.w	d1,d3
	rts
.0
	move.w	#1,d3

rtsHighlight						;rts (SaveGameHighlights in the playoffs)
	rts

ReadTeamPlayerStats					;Read the five stat blocks (goals, assists, shots, games played, penalty
									;minutes) of team d7 to a0, $34 bytes each
									;playoff blocks with SeasonDay bit 5
	movem.l	d0-d7/a0-a6,-(sp)
	move.w	d7,d0
	mulu.w	#$34,d0
	move.l	d0,-(sp)
	btst	#5,(SeasonDay+1).w
	beq.w	.0
	addi.l	#SRPOGoals,d0
	bra.w	.1
.0
	addi.l	#SRGoals,d0
.1
	movea.l	#StatBuf,a0
	moveq	#$34,d1
	jsr	(ReadSRAM).l
	move.l	(sp),d0
	btst	#5,(SeasonDay+1).w
	beq.w	.2
	addi.l	#SRPOAssists,d0
	bra.w	.3
.2
	addi.l	#SRAssists,d0
.3
	adda.w	#$34,a0
	jsr	(ReadSRAM).l
	move.l	(sp),d0
	btst	#5,(SeasonDay+1).w
	beq.w	.4
	addi.l	#SRPOShots,d0
	bra.w	.5
.4
	addi.l	#SRShots,d0
.5
	adda.w	#$34,a0
	jsr	(ReadSRAM).l
	move.l	(sp),d0
	btst	#5,(SeasonDay+1).w
	beq.w	.6
	addi.l	#SRPOGamesPlayed,d0
	bra.w	.7
.6
	addi.l	#SRGamesPlayed,d0
.7
	adda.w	#$34,a0
	jsr	(ReadSRAM).l
	move.l	(sp)+,d0
	btst	#5,(SeasonDay+1).w
	beq.w	.8
	addi.l	#SRPOPenMin,d0
	bra.w	.9
.8
	addi.l	#SRPenMin,d0
.9
	adda.w	#$34,a0
	jsr	(ReadSRAM).l
	movem.l	(sp)+,d0-d7/a0-a6
	rts

WriteTeamPlayerStats				;Write the five stat blocks of team d7 from a0 (as ReadTeamPlayerStats)
	movem.l	d0-d7/a0-a6,-(sp)
	move.w	d7,d0
	mulu.w	#$34,d0
	move.l	d0,-(sp)
	btst	#5,(SeasonDay+1).w
	beq.w	.0
	addi.l	#SRPOGoals,d0
	bra.w	.1
.0
	addi.l	#SRGoals,d0
.1
	movea.l	#StatBuf,a0
	moveq	#$34,d1
	jsr	(WriteSRAM).l
	move.l	(sp),d0
	btst	#5,(SeasonDay+1).w
	beq.w	.2
	addi.l	#SRPOAssists,d0
	bra.w	.3
.2
	addi.l	#SRAssists,d0
.3
	adda.w	#$34,a0
	jsr	(WriteSRAM).l
	move.l	(sp),d0
	btst	#5,(SeasonDay+1).w
	beq.w	.4
	addi.l	#SRPOShots,d0
	bra.w	.5
.4
	addi.l	#SRShots,d0
.5
	adda.w	#$34,a0
	jsr	(WriteSRAM).l
	move.l	(sp),d0
	btst	#5,(SeasonDay+1).w
	beq.w	.6
	addi.l	#SRPOGamesPlayed,d0
	bra.w	.7
.6
	addi.l	#SRGamesPlayed,d0
.7
	adda.w	#$34,a0
	jsr	(WriteSRAM).l
	move.l	(sp)+,d0
	btst	#5,(SeasonDay+1).w
	beq.w	.8
	addi.l	#SRPOPenMin,d0
	bra.w	.9
.8
	addi.l	#SRPenMin,d0
.9
	adda.w	#$34,a0
	jsr	(WriteSRAM).l
	movem.l	(sp)+,d0-d7/a0-a6
	rts

ReadSeasonTeamRecord				;Read the season record of team d7 (save RAM SRTeamStats, or SRPOTeamStats
									;with SeasonDay bit 5) to a0
	movem.l	d0-d7/a0-a6,-(sp)
	move.w	d7,d0
	mulu.w	#$A,d0
	btst	#5,(SeasonDay+1).w
	beq.w	.0
	addi.l	#SRPOTeamStats,d0
	bra.w	.1
.0
	addi.l	#SRTeamStats,d0
.1
	moveq	#$A,d1
	movem.l	d7/a0,-(sp)
	jsr	(ReadSRAM).l
	movem.l	(sp)+,d7/a0
	adda.w	#$A,a0
	move.w	d7,d0
	mulu.w	#3,d0
	btst	#5,(SeasonDay+1).w
	beq.w	.2
	addi.l	#SRPOStandings,d0
	bra.w	.3
.2
	addi.l	#SRStandings,d0
.3
	moveq	#3,d1
	jsr	(ReadSRAM).l
	movem.l	(sp)+,d0-d7/a0-a6
	rts

MarkSeasonRosters					;Set bit 15 of every player's goals and shots words in save RAM, for all
									;$1A teams (all on the roster)
	movem.l	d0-d7/a0-a6,-(sp)
	clr.w	d7
	movea.l	#SaveRAM+2*SRGoals,a0
	movea.l	#SaveRAM+2*SRShots,a1
.loop
	jsr	(GetGoalieCountD7).l
	subq.w	#1,d0
	clr.w	d1
.loop2
	move.w	(a0,d1.w),d2
	ori.w	#$80,d2
	move.w	d2,(a0,d1.w)
	move.w	(a1,d1.w),d2
	ori.w	#$80,d2
	move.w	d2,(a1,d1.w)
	addq.w	#4,d1
	dbf	d0,.loop2
	addq.w	#1,d7
	adda.l	#$68,a0
	adda.l	#$68,a1
	cmp.w	#NumPlayoffTeams,d7
	blt.s	.loop
	jsr	(MakeSRAMChecksum).l
	movem.l	(sp)+,d0-d7/a0-a6
	rts

SeasonPlayerStats					;Season Player Stats screen: set the VRAM layout (VSCRLPM ... Map3col1),
									;clear VRAM (setVram), then run the stats screen and return
	bclr	#df32c,(disflags).w
	move.w	#$C000,(VmMAP2).w
	move.w	#6,(Map2col1).w
	move.w	#$DC00,(VSPRITES).w
	move.w	#$E000,(VmMAP1).w
	move.w	#6,(Map1col1).w
	move.w	#$F000,(VmMAP3).w
	move.w	#5,(Map3col1).w
	move.w	#$FC00,(VSCRLPM).w
	moveq	#0,d0
	jsr	(setVram).l
	bra.w	SeasonStatsList

SeasonPlayersScreen					;Run the season stats screen, then jump to ExitStatsScreen
	bsr.w	SeasonStatsList
	jmp	(ExitStatsScreen).l

.seasonPlayersRedraw				;Wait for vblank, reset scroll, clear the window/scroll VDP areas, draw
									;the team screen (DrawTeamScreen4NoSetup) and enter the stats screen draw
	btst	#dfok,(disflags).w
	bne.s	.seasonPlayersRedraw
	clr.w	(Hscroll).w
	clr.w	(Vscroll).w
	jsr	(SetScroll2).l
	move.w	(disflags).w,-(sp)
	bset	#dfng,(disflags).w
	movea.l	#Vdata,a0
	move.w	#VDPR_WINX,Vctrl-Vdata(a0)
	move.w	#VDPR_WINY,Vctrl-Vdata(a0)
	move.w	(VSPRITES).w,d0
	jsr	(Vmaddr).l
	move.l	#0,(a0)
	move.w	#VDPR_MODE4+$81,Vctrl-Vdata(a0)
	move.w	#6,(Map2col1).w
	move.w	#VDPR_HSCROLL,Vctrl-Vdata(a0)
	clr.w	d0
	jsr	(Vmaddr).l
	move.l	#0,(a0)
	move.w	(sp)+,(disflags).w
	bclr	#df32c,(disflags).w
	move.w	#$800,d0
	move.w	(VmMAP1).w,d1
	move.w	#$7FF,d2
	jsr	(DoFill).l
	clr.w	d7
	moveq	#$D,d0
	moveq	#$18,d1
	move.l	#PlayerStatsBgMap,(screenarg).l
	jsr	(DrawTeamScreen4NoSetup).l
	bra.w	SeasonStatsListDraw

SeasonStatsList						;d7 = team 0-$19 (A/B cycles teams); sflags11 bit 3 = playoff variant
	move.b	(SeasonDay+1).w,-(sp)
	btst	#3,(sflags11).w
	bne.w	.0
	bclr	#5,(SeasonDay+1).w
.0
	clr.w	d7
	moveq	#$D,d0
	moveq	#$18,d1
	move.l	#PlayerStatsBgMap,(screenarg).l
	jsr	(DrawTeamScreen4).l

SeasonStatsListDraw					;Draw the season player stats screen for team d7 (SeasonStatsList
									;continues here)
	jsr	(printz).l
	String	-(TXPRI+TXMAP3),$0,$6,$0
	movea.l	#PlayerStatsTitleMap,a0
	movea.l	a0,a1
	movea.l	a0,a2
	adda.l	(a2)+,a0
	adda.l	(a2)+,a1
	clr.w	d0
	clr.w	d1
	move.w	(a1),d2
	move.w	2(a1),d3
	moveq	#4,d5
	jsr	(dobitmap).l
	clr.w	(DispAttribCtr).w
	clr.w	(VertLineScrolling).w
.team
	jsr	(ReadTeamPlayerStats).l
	clr.w	(PlayerScrollCtr).w
	jsr	(printz).l
	String	-(TXPRI+TXMAP3),$5,$1,$0
	jsr	(printsmallz).l
	String	CC_SetMapAndPosition,$4,$3,$B,$1A,CC_SetFont,$3,'A,B^-^Switch^Teams',CC_SetFont,$0,$0
	btst	#3,(sflags11).w
	bne.w	.1
	jsr	(printbigz).l
	String	$BD,$02,$04,'Season',$BD,$0F,$04,'Player',$BD,$1C,$04,'Stats',$BD,$0E,$01
	bra.w	.2
.1
	jsr	(printbigz).l
	String	-(TXPRI+TXMAP3),$6,$4,'Playoff',-(TXPRI+TXMAP3),$15,$4,'Players',-(TXPRI+TXMAP3),$E,$1,$0
.2
	clr.w	d0
	move.w	d7,d0
	jsr	(DrawSeasonStatsLogo).l
	bsr.w	DrawSeasonStatsList
	bsr.w	SeasonScrollArrows
.wait
	jsr	(vcountwait).l
	jsr	(orjoy4way).l
	btst	#7,d3
	beq.w	.keys
	move.b	(sp)+,(SeasonDay+1).w
	rts
.keys
	btst	#6,d1
	bne.w	.prev
	btst	#4,d1
	bne.w	.next
	jsr	(nodiag).l
	moveq	#1,d0
	btst	#3,d1
	bne.w	.column
	neg.w	d0
	btst	#2,d1
	bne.w	.column
	moveq	#-2,d0
	btst	#0,d3
	bne.w	.5
	neg.w	d0
	btst	#1,d3
	beq.w	.scroll
.5
	move.w	d0,(PlayerScrollCtr).w
.scroll
	bsr.w	SeasonStatsListScroll
	bra.s	.wait
.column
	add.w	(DispAttribCtr).w,d0
	cmp.w	#$FFFF,d0
	blt.s	.scroll
	cmp.w	#2,d0
	bgt.s	.scroll
	move.w	d0,(DispAttribCtr).w
	bsr.w	DrawSeasonStatsList
	bsr.w	SeasonScrollArrows
	bra.s	.scroll
.prev
	subq.w	#1,d7
	bpl.w	.team
	move.w	#NumPlayoffTeams-1,d7
	bra.w	.team
.next
	addq.w	#1,d7
	cmp.w	#NumPlayoffTeams,d7
	bne.w	.team
	clr.w	d7
	bra.w	.team

SeasonStatsListScroll				;Per-frame scroll of the player list
	move.w	(PlayerScrollCtr).w,d0
	beq.w	rtsSeasonStats
	add.w	(VertLineScrolling).w,d0
	bmi.w	rtsSeasonStats
	cmp.w	(SelectedPlayerIdx).w,d0
	bgt.w	rtsSeasonStats
	move.w	(VertLineScrolling).w,d1
	move.w	d0,(VertLineScrolling).w
	andi.w	#$F,d0
	bne.w	.0
	bsr.w	SeasonScrollArrows
	clr.w	(PlayerScrollCtr).w
.0
	andi.w	#$F,d1
	bne.w	SeasonStatsListScrollReg
	move.w	d0,-(sp)
	cmp.w	#$E,d0
	bne.w	.1
	bsr.w	SeasonStatsRowUp
.1
	move.w	(sp)+,d0
	cmp.w	#2,d0
	bne.w	SeasonStatsListScrollReg
	bsr.w	SeasonStatsRowDown

SeasonStatsListScrollReg			;VSRAM = VertLineScrolling - $68
	move.w	(disflags).w,-(sp)
	bset	#dfng,(disflags).w
	movea.l	#Vdata,a0
	move.l	#VSRAM_W+(2<<16),Vctrl-Vdata(a0)
	move.w	#$FF98,d0
	add.w	(VertLineScrolling).w,d0
	move.w	d0,(a0)
	move.w	(sp)+,(disflags).w

rtsSeasonStats						;rts (shared exit of the SeasonAttribute routines)
	rts

SeasonStatsRowUp					;Draw the season stats row at the top of the view
	move.w	(VertLineScrolling).w,d3
	lsr.w	#4,d3
	bra.w	DrawSeasonStatsRow

SeasonStatsRowDown					;Draw the season stats row at the bottom of the view
	move.w	(VertLineScrolling).w,d3
	lsr.w	#4,d3
	addq.w	#6,d3
	bra.w	DrawSeasonStatsRow

DrawSeasonStatsList					;Headers, sort title, sorted player list at Satt, draws 6 rows
	jsr	(printsmallz).l
	String	CC_SetMapAndPosition,$4,$3,$4,$9,CC_SetFont,$1,'Player',CC_AddX,$7,$0
	lea	SeasonStatColumnHeaders(pc),a1
	moveq	#3,d3
	tst.w	(DispAttribCtr).w
	bmi.w	.loop
	adda.w	(a1),a1
	clr.w	d3
.loop
	move.w	#$8000,(printa).w
	cmp.w	(DispAttribCtr).w,d3
	bne.w	.1
	move.w	#$C000,(printa).w
.1
	jsr	(printsmall).l
	addq.w	#1,d3
	cmp.w	#3,d3
	blt.s	.loop
	jsr	(printsmallz).l
	String	CC_SetMapAndPosition,$4,$3,$9,$7,$0
	jsr	(printsmallz).l
	String	CC_SetFont,$1
	jsr	(printz).l
	String	-(TXPRI+TXMAP3),$A,$7,$0
	lea	SeasonStatSortTitles(pc),a1
	moveq	#1,d0
	add.w	(DispAttribCtr).w,d0
	jsr	(PrintSmallListItem).l
	clr.w	(printfontset).w
	movea.w	#(Satt-M68K_RAM),a3
	clr.l	d6
	tst.w	(DispAttribCtr).w
	bpl.w	.pick
	jsr	(GetGoalieCountD7).l
	bset	d0,d6
	subq.w	#1,d6
	not.l	d6
.pick
	moveq	#-1,d4
	st	d5
	jsr	(GetPlayerCountD7).l
	bra.w	.5
.scan
	btst	d0,d6
	bne.w	.5
	clr.w	d2
	bclr	#2,(sflags5).w
	move.w	(DispAttribCtr).w,d1
	bmi.w	.4
	bsr.w	SeasonGetStatColumn
.4
	btst	#2,(sflags5).w
	bne.w	.5
	ext.l	d2
	asl.l	#8,d2
	jsr	(GetRosterName).l
	adda.w	(a1),a1
	move.b	#$FF,d2
	sub.b	(a1),d2
	cmp.l	d4,d2
	ble.w	.5
	move.l	d2,d4
	move.w	d0,d5
.5
	dbf	d0,.scan
	bset	d5,d6
	move.b	d5,(a3)+
	bpl.s	.pick
	moveq	#5,d0
.end
	st	0(a3,d0.w)
	dbf	d0,.end
	move.w	a3,d0
	subi.w	#(Satt+6-M68K_RAM),d0
	bpl.w	.7
	clr.w	d0
.7
	asl.w	#4,d0
	move.w	d0,(SelectedPlayerIdx).w
	cmp.w	(VertLineScrolling).w,d0
	bcc.w	.8
	move.w	d0,(VertLineScrolling).w
.8
	moveq	#5,d4
.rows
	move.w	(VertLineScrolling).w,d3
	lsr.w	#4,d3
	add.w	d4,d3
	bsr.w	DrawSeasonStatsRow
	dbf	d4,.rows
	bra.w	SeasonStatsListScrollReg

DrawSeasonStatsRow					;Draws list row d3 (rank, name, 3 stat columns or goalie saves/shots/save
									;%)
	movea.w	#(Satt-M68K_RAM),a4
	adda.w	d3,a4
	jsr	(printz).l
	String	-(TXPRI+TXMAP2),$0,$0,$0
	add.w	d3,d3
	andi.w	#$1F,d3
	move.w	d3,(printy).w
	moveq	#$28,d0
	moveq	#1,d1
	move.w	#$7FF,d2
	jsr	(eraser).l
	tst.b	(a4)
	bmi.w	rtsSeasonStats
	subq.w	#1,(printy).w
	move.w	#1,(printx).w
	move.w	a4,d0
	subi.w	#(Satt-1-M68K_RAM),d0
	moveq	#2,d1
	move.w	#$E000,(printa).w
	jsr	(PushNumberWidth).l
	jsr	(print).l
	clr.w	d0
	move.b	(a4),d0
	jsr	(FormatPlayerNameD7).l
	addq.w	#1,(printx).w
	move.w	#$8000,(printa).w
	jsr	(print).l
	move.w	#$11,(printx).w
	tst.w	(DispAttribCtr).w
	bmi.w	.goalie
	clr.w	d5
.cols
	clr.w	d0
	move.b	(a4),d0
	move.w	d5,d1
	bsr.w	SeasonGetStatColumn
	move.w	d2,d0
	moveq	#4,d1
	jsr	(PushNumberWidth).l
	move.w	#$8000,(printa).w
	cmp.w	(DispAttribCtr).w,d5
	bne.w	.1
	move.w	#$C000,(printa).w
.1
	jsr	(print).l
	addq.w	#2,(printx).w
	addq.w	#1,d5
	cmp.w	#3,d5
	bne.s	.cols
	bra.w	.exit
.goalie
	clr.w	d0
	move.b	(a4),d0
	moveq	#3,d1
	bsr.w	SeasonReadStatColumn
	clr.w	d0
	move.b	(a4),d0
	moveq	#0,d1
	move.w	d2,-(sp)
	bsr.w	SeasonReadStatColumn
	move.w	(sp)+,d0
	move.w	d0,d3
	sub.w	d2,d0
	bpl.w	.3
	clr.w	d0
.3
	move.w	d0,d2
	moveq	#4,d1
	jsr	(PushNumberWidth).l
	addq.w	#1,(printx).w
	jsr	(print).l
	move.w	d3,d0
	moveq	#4,d1
	jsr	(PushNumberWidth).l
	addq.w	#2,(printx).w
	jsr	(print).l
	tst.w	d3
	beq.w	.4
	mulu.w	#$64,d2
	divu.w	d3,d2
.4
	move.w	d2,d0
	moveq	#4,d1
	jsr	(PushNumberWidth).l
	addq.w	#2,(printx).w
	jsr	(print).l
	jsr	(printz).l
	String	'%',$0
.exit
	rts

SeasonGetStatColumn					;d2 = stat column d1 for player d0; goalies: columns 1-2 read column 1
									;(A), others set sflags5 bit 2 (skip)
	bclr	#2,(sflags5).w
	move.w	d0,-(sp)
	jsr	(GetGoalieCountD7).l
	move.w	d0,d2
	move.w	(sp)+,d0
	cmp.w	d2,d0
	bge.w	SeasonReadStatColumn
	clr.w	d2
	btst	d1,#6
	beq.w	SeasonSkipStatColumn
	moveq	#1,d1

SeasonReadStatColumn				;d2 = sum of the season stat words (low 15 bits) at StatBuf +
									;SeasonStatColumnOffsets column offsets, player d0
	movem.w	d0,-(sp)
	movea.l	#StatBuf,a2
	lea	SeasonStatColumnOffsets(pc),a1
	asl.w	#2,d1
	adda.w	d1,a1
	move.w	(a1),d1
	add.w	d0,d0
	add.w	d0,d1
	move.w	0(a2,d1.w),d2
	andi.w	#$7FFF,d2
	move.w	2(a1),d1
	bmi.w	.0
	add.w	d0,d1
	move.w	0(a2,d1.w),d3
	andi.w	#$7FFF,d2				;(sic: masks d2 again, not d3)
	add.w	d3,d2
.0
	movem.w	(sp)+,d0
	rts

SeasonSkipStatColumn				;Column not shown for this goalie: set sflags5 bit 2
	bset	#2,(sflags5).w
	rts

SeasonStatColumnOffsets				;Word offsets into StatBuf per column (G, A, Pts = G+A, SOG, PIM), -1 =
									;none
	dc.w	$0,$FFFF,$34,$FFFF,$0,$34,$68,$FFFF,$D0,$FFFF

SeasonStatColumnHeaders				;Column headers (goalie header, then G, A, Pts, SOG, PIM)
	String	'Saves Shots Save %  '
	String	'   G'
	String	'     A'
	String	'   Pts    '
	String	' SOG'
	String	' PIM'

SeasonStatSortTitles				;Sort column titles
	String	'    Goalie Saves   ]'
	String	'[      Goals       ]'
	String	'[     Assists      ]'
	String	'[      Points       '
	String	'[  Shots On Goal   ]'
	String	'[ Penalty Minutes   '

SeasonScrollArrows					;Up / down arrows (SeasonScrollArrowTbl). Saves d0-d1/a1
	movem.l	d0-d1/a1,-(sp)
	jsr	(printsmallz).l
	String	CC_SetMapAndPosition,$4,$3,'$',$C,CC_SetFont,$3,$0
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
	lea	SeasonScrollArrowTbl(pc),a1
	jsr	(PrintSmallListItem).l
	movem.l	(sp)+,d0-d1/a1
	rts

SeasonScrollArrowTbl				;None, up, down, both
	String	' ',$FB,$FF,$FA,$E,' ',$F9,$0
	String	'{',$FB,$FF,$FA,$E,' ',$F9,$0
	String	' ',$FB,$FF,$FA,$E,'}',$F9,$0
	String	'{',$FB,$FF,$FA,$E,'}',$F9,$0

DrawSeasonStatsLogo					;Draw bitmap Teamblocksmap via dobitmap with tile base $69A, d1 = 2*d0
									;(team d0). Saves all regs
	movem.l	d0-d7/a0-a6,-(sp)
	move.w	#1,d4
	move.w	d0,d1
	clr.w	d0
	asl.w	#1,d1
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

SeasonTeamStats						;Season TEAM STATS screen (sflags11 bit 3 = playoff "Playoff Teams"): d7 =
									;team 0-$19, left/right (bits 6/4 of d1) change team, start exits
	bclr	#df32c,(disflags).w
	move.w	#$C000,(VmMAP2).w
	move.w	#6,(Map2col1).w
	move.w	#$DC00,(VSPRITES).w
	move.w	#$E000,(VmMAP1).w
	move.w	#6,(Map1col1).w
	move.w	#$F000,(VmMAP3).w
	move.w	#5,(Map3col1).w
	move.w	#$FC00,(VSCRLPM).w
	moveq	#0,d0
	jsr	(setVram).l
	bra.w	SeasonTeamStatsRun

SeasonTeamsScreen					;Pause / season menu Season Team Stats (Playoff Teams):
									;SeasonTeamStatsRun, then ExitStatsScreen
	bsr.w	SeasonTeamStatsRun
	jmp	(ExitStatsScreen).l

SeasonTeamStatsRun					;Season (or playoff, sflags11 bit 3) team stats screen: team records from
									;ReadSeasonTeamRecord, A / B switch teams
	move.b	(SeasonDay+1).w,-(sp)
	btst	#3,(sflags11).w
	bne.w	.0
	bclr	#5,(SeasonDay+1).w
.0
	clr.w	d7
	move.w	#0,d0
	move.w	#$1B,d1
	move.l	#ControllerBgMap,(screenarg).l
	jsr	(DrawTeamScreen5).l
	btst	#3,(sflags11).w
	bne.w	.1
	jsr	(printbigz).l
	String	-(TXPRI+TXMAP2),$4,$2,'Season',-(TXPRI+TXMAP2),$11,$2,'Team',-(TXPRI+TXMAP2),$1A,$2,'Stats'
	bra.w	.team
.1
	jsr	(printbigz).l
	String	-(TXPRI+TXMAP2),$8,$2,'Playoff',-(TXPRI+TXMAP2),$17,$2,'Teams'
.team
	movea.l	#StatBuf,a0
	jsr	(ReadSeasonTeamRecord).l
	jsr	(printsmallz).l
	String	CC_SetMapAndPosition,$4,$2,$B,$1A,CC_SetFont,$1,'A,B^-^Switch^Teams',CC_SetFont,$0,$0
	jsr	(printz).l
	String	-(TXPRI+TXMAP3),$E,$6,$0
	move.w	d7,d0
	jsr	(DrawTeamStatsLogo).l
	bsr.w	PrintSeasonTeamStats
.wait
	jsr	(vcountwait).l
	jsr	(orjoy4way).l
	btst	#7,d3
	beq.w	.keys
	move.b	(sp)+,(SeasonDay+1).w
	rts
.keys
	btst	#6,d1
	bne.w	.prev
	btst	#4,d1
	bne.w	.next
	bra.s	.wait
.next
	addq.w	#1,d7
	cmp.w	#NumPlayoffTeams,d7
	bne.s	.team
	clr.w	d7
	bra.s	.team
.prev
	subq.w	#1,d7
	bpl.w	.team
	move.w	#NumPlayoffTeams-1,d7
	bra.w	.team

PrintSeasonTeamStats				;print the team stat rows from the record at StatBuf (a6): W,L,T,Pts, then
									;per-game / percentage stats
	movem.l	a6,-(sp)
	movea.l	#StatBuf,a6
	jsr	(printsmallz).l
	String	CC_SetFont,$0
	jsr	(printsmallz).l
	String	CC_SetMapAndPosition,$4,$2,$3,$9,'Wins,Losses,Ties,Pts  ',$0
	clr.w	(rosterscroll).w
	clr.w	d0
	move.b	$A(a6),d0
	add.w	d0,(rosterscroll).w
	move.w	d0,-(sp)
	move.w	#2,d1
	jsr	(PushNumberWidth).l
	jsr	(printsmall).l
	jsr	(printsmallz).l
	String	',',$0
	clr.w	d0
	move.b	$C(a6),d0
	add.w	d0,(rosterscroll).w
	move.w	#2,d1
	jsr	(PushNumberWidth).l
	jsr	(printsmall).l
	jsr	(printsmallz).l
	String	',',$0
	clr.w	d0
	move.b	$B(a6),d0
	add.w	d0,(rosterscroll).w
	move.w	d0,-(sp)
	move.w	#2,d1
	jsr	(PushNumberWidth).l
	jsr	(printsmall).l
	jsr	(printsmallz).l
	String	',',$0
	move.w	(sp)+,d0
	add.w	(sp),d0
	add.w	(sp)+,d0
	move.w	#3,d1
	jsr	(PushNumberWidth).l
	jsr	(printsmall).l
	jsr	(printsmallz).l
	String	CC_SetMapAndPosition,$4,$2,$3,$B,'Goals Scored Per Game',CC_SetX,$1E
	move.w	(rosterscroll).w,d1
	clr.l	d0
	tst.w	d1
	beq.w	.0
	move.w	(a6),d0
	mulu.w	#$64,d0
	divu.w	d1,d0
	andi.l	#$FFFF,d0
	divu.w	#$64,d0
.0
	swap	d0
	move.w	d0,-(sp)
	swap	d0
	move.w	#3,d1
	jsr	(PushNumberWidth).l
	jsr	(printsmall).l
	jsr	(printsmallz).l
	String	'.',$0
	move.w	(sp)+,d0
	move.w	#2,d1
	jsr	(PushNumberWidthZero).l
	jsr	(printsmall).l
	jsr	(printsmallz).l
	String	CC_SetMapAndPosition,$4,$2,$3,$D,'Goals Allowed Per Game',CC_SetX,$1E,$0
	move.w	(rosterscroll).w,d1
	clr.w	d0
	tst.w	d1
	beq.w	.1
	move.w	2(a6),d0
	mulu.w	#$64,d0
	divu.w	d1,d0
	andi.l	#$FFFF,d0
	divu.w	#$64,d0
.1
	swap	d0
	move.w	d0,-(sp)
	swap	d0
	move.w	#3,d1
	jsr	(PushNumberWidth).l
	jsr	(printsmall).l
	jsr	(printsmallz).l
	String	'.',$0
	move.w	(sp)+,d0
	move.w	#2,d1
	jsr	(PushNumberWidthZero).l
	jsr	(printsmall).l
	jsr	(printsmallz).l
	String	CC_SetMapAndPosition,$4,$2,$3,$F,'Penalty Minutes Per Game',CC_SetX,$1E,$0
	move.w	(rosterscroll).w,d1
	clr.l	d0
	tst.w	d1
	beq.w	.2
	move.w	4(a6),d0
	mulu.w	#$64,d0
	divu.w	d1,d0
	andi.l	#$FFFF,d0
	divu.w	#$64,d0
.2
	swap	d0
	move.w	d0,-(sp)
	swap	d0
	move.w	#3,d1
	jsr	(PushNumberWidth).l
	jsr	(printsmall).l
	jsr	(printsmallz).l
	String	'.',$0
	move.w	(sp)+,d0
	move.w	#2,d1
	jsr	(PushNumberWidthZero).l
	jsr	(printsmall).l
	jsr	(printsmallz).l
	String	CC_SetMapAndPosition,$4,$2,$3,$11,'Save Percentage',CC_SetX,$1F
	move.w	8(a6),d3
	move.w	d3,d2
	sub.w	2(a6),d2
	bpl.w	.3
	clr.w	d2
.3
	tst.w	d3
	beq.w	.4
	mulu.w	#$64,d2
	divu.w	d3,d2
.4
	move.w	d2,d0
	move.w	#3,d1
	jsr	(PushNumberWidth).l
	jsr	(printsmall).l
	jsr	(printsmallz).l
	String	'%',$0
	jsr	(printsmallz).l
	String	CC_SetMapAndPosition,$4,$2,$3,$13,'Shooting Percentage',CC_SetX,$1F
	move.w	6(a6),d3
	move.w	(a6),d2
	tst.w	d3
	beq.w	.5
	mulu.w	#$64,d2
	divu.w	d3,d2
.5
	move.w	d2,d0
	move.w	#3,d1
	jsr	(PushNumberWidth).l
	jsr	(printsmall).l
	jsr	(printsmallz).l
	String	'%',$0
	jsr	(printsmallz).l
	String	CC_SetMapAndPosition,$4,$2,$3,$15,'Shots Per Game',CC_SetX,$1E,$0
	move.w	(rosterscroll).w,d1
	clr.l	d0
	tst.w	d1
	beq.w	.6
	move.w	6(a6),d0
	mulu.w	#$64,d0
	divu.w	d1,d0
	andi.l	#$FFFF,d0
	divu.w	#$64,d0
.6
	swap	d0
	move.w	d0,-(sp)
	swap	d0
	move.w	#3,d1
	jsr	(PushNumberWidth).l
	jsr	(printsmall).l
	jsr	(printsmallz).l
	String	'.',$0
	move.w	(sp)+,d0
	move.w	#2,d1
	jsr	(PushNumberWidthZero).l
	jsr	(printsmall).l
	jsr	(printsmallz).l
	String	CC_SetMapAndPosition,$4,$2,$3,$17,'Shots Allowed Per Game',CC_SetX,$1E,$0
	move.w	(rosterscroll).w,d1
	clr.l	d0
	tst.w	d1
	beq.w	.7
	move.w	8(a6),d0
	mulu.w	#$64,d0
	divu.w	d1,d0
	andi.l	#$FFFF,d0
	divu.w	#$64,d0
.7
	swap	d0
	move.w	d0,-(sp)
	swap	d0
	move.w	#3,d1
	jsr	(PushNumberWidth).l
	jsr	(printsmall).l
	jsr	(printsmallz).l
	String	'.',$0
	move.w	(sp)+,d0
	move.w	#2,d1
	jsr	(PushNumberWidthZero).l
	jsr	(printsmall).l
	movem.l	(sp)+,a6
	rts

DrawTeamStatsLogo					;Draw team d0's logo: frame d0*2 of the bitmap set at Teamblocksmap, tile
									;$69A, via dobitmap
	movem.l	d0-d7/a0-a6,-(sp)
	move.w	#1,d4
	move.w	d0,d1
	clr.w	d0
	asl.w	#1,d1
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

LeagueLeadersScreen					;League Leaders screen (season menu): team / individual stat leader lists,
									;scroll and category select
	movem.l	d0-d7/a0-a6,-(sp)
	jsr	(MarkSeasonRosters).l
	move.l	#PlayerStatsBgMap,(screenarg).l
	bsr.w	StandingsGfx
	move.w	#$18,(palcount).w
	bclr	#dfng,(disflags).w
	jsr	(printbigz).l
	String	-(TXPRI+TXMAP1),$6,$2,'League Leaders',$0
	clr.w	(StatWork).w
	clr.w	(SeasonGameCount).w
	move.w	#8,(StatWork+$8).w
	move.w	#7,(StatWork+$6).w
	clr.w	(StatWork+2).w
	movea.l	#.lastrow,a0
	move.w	(StatWork).w,d5
	add.w	d5,d5
	move.w	0(a0,d5.w),(StatWork+$A).w
.build
	bsr.w	BuildLeaders
.draw
	bsr.w	PrintLeadersHeader
	bsr.w	PrintTeamCategory
	move.w	#$18,(palcount).w
	bsr.w	DrawLeaderRows
	bsr.w	LeadersScrollArrows
	bsr.w	LeadersHelp
.input
	bsr.w	ReadLeadersPad
	tst.w	d1
	beq.w	.nopad
	btst	#7,d1
	bne.w	.done
	btst	#4,d1
	beq.w	.left
	jsr	(forceblack).l
	eori.w	#1,(StatWork).w
	clr.w	(StatWork+2).w
	clr.w	(SeasonGameCount).w
	move.w	#7,(StatWork+$6).w
	movea.l	#.lastrow,a0
	move.w	(StatWork).w,d5
	add.w	d5,d5
	move.w	0(a0,d5.w),(StatWork+$A).w
	bra.s	.build
.left
	btst	#2,d1
	beq.w	.up
	bsr.w	ClearLeadersArea
	subq.w	#1,(StatWork+2).w
	bpl.w	.category
	movea.l	#.lastcat,a0
	move.w	(StatWork).w,d0
	add.w	d0,d0
	move.w	0(a0,d0.w),d0
	move.w	d0,(StatWork+2).w
.category
	movea.l	#.lastrow,a0
	move.w	(StatWork).w,d5
	add.w	d5,d5
	move.w	0(a0,d5.w),(StatWork+$A).w
	clr.w	(SeasonGameCount).w
	move.w	#7,(StatWork+$6).w
	bra.w	.build
.lastcat
	dc.w	6,3
.up
	btst	#0,d1
	beq.w	.down
	tst.w	(SeasonGameCount).w
	beq.w	.input
	subq.w	#1,(SeasonGameCount).w
	subq.w	#1,(StatWork+$6).w
	bra.w	.draw
.down
	btst	#1,d1
	beq.w	.right
	move.w	(StatWork+$6).w,d0
	cmp.w	(StatWork+$A).w,d0
	bge.w	.input
	addq.w	#1,(SeasonGameCount).w
	addq.w	#1,(StatWork+$6).w
	bra.w	.draw
.lastrow
	dc.w	$19,$13
.right
	btst	#3,d1
	beq.w	.input
	bsr.w	ClearLeadersArea
	addq.w	#1,(StatWork+2).w
	movea.l	#.lastcat,a0
	move.w	(StatWork).w,d0
	add.w	d0,d0
	move.w	0(a0,d0.w),d0
	cmp.w	(StatWork+2).w,d0
	bge.w	.category
	clr.w	(StatWork+2).w
	bra.w	.category
.nopad
	jmp	(Opening2).l
.done
	movem.l	(sp)+,d0-d7/a0-a6
	rts

LeadersScrollArrows					;League Leaders: draw up/down scroll arrows depending on list position
	movem.l	d0-d7/a0-a6,-(sp)
	tst.w	(SeasonGameCount).w
	beq.w	.0
	jsr	(printz).l
	String	-(TXPRI+TXMAP1),$1,$9,'{'
	bra.w	.1
.0
	jsr	(printz).l
	String	-(TXPRI+TXMAP1),$1,$9,' '
.1
	move.w	(StatWork+$6).w,d1
	cmp.w	(StatWork+$A).w,d1
	bge.w	.2
	jsr	(printz).l
	String	-(TXPRI+TXMAP1),$1,$18,'}'
	bra.w	.3
.2
	jsr	(printz).l
	String	-(TXPRI+TXMAP1),$1,$18,' '
.3
	movem.l	(sp)+,d0-d7/a0-a6
	rts

PrintTeamCategory					;League Leaders: print category name, team mode (7 categories); individual
									;mode goes to PrintPlayerCategory
	tst.w	(StatWork).w
	bne.w	PrintPlayerCategory
	movem.l	d0-d7/a0-a6,-(sp)
	jsr	(printz).l
	String	-(TXPRI+TXMAP1),$10,$7,$0
	move.w	(StatWork+2).w,d0
	movea.l	#TeamCategoryText,a1
	jsr	(PrintListItem).l
	movem.l	(sp)+,d0-d7/a0-a6
	rts

TeamCategoryText
	String	'       Points        ',$0
	String	'      Goals Avg.     ',$0
	String	'  Goals Allowed Avg. ',$0
	String	'   Save Percentage   ',$0
	String	' Shooting Percentage ',$0
	String	'      Shots Avg.     ',$0
	String	'  Shots Allowed Avg. ',$0

PrintPlayerCategory					;League Leaders: print category name, individual mode (4 categories)
	movem.l	d0-d7/a0-a6,-(sp)
	jsr	(printz).l
	String	-(TXPRI+TXMAP1),$19,$7,$0
	move.w	(StatWork+2).w,d0
	movea.l	#PlayerCategoryText,a1
	jsr	(PrintListItem).l
	movem.l	(sp)+,d0-d7/a0-a6
	rts

PlayerCategoryText
	String	'   Goals       ',$0
	String	'  Assists      ',$0
	String	'  Points       ',$0
	String	'      GAA      ',$0

PrintLeadersHeader					;League Leaders: print TEAM / INDIVIDUAL column headers
	movem.l	d0-d7/a0-a6,-(sp)
	jsr	(printz).l
	String	-(TXPRI+TXMAP1),$0,$5,$0
	movea.l	#BlankLine40,a1
	jsr	(print).l
	move.w	(StatWork).w,d0
	movea.l	#LeaderModeText,a1
	jsr	(PrintListItem).l
	movem.l	(sp)+,d0-d7/a0-a6
	rts

LeaderModeText
	String	$BF,$11,$5,'TEAM',$BF,$5,$7,'   Team    ',$0
	String	$BF,$F,$5,'INDIVIDUAL',$BF,$6,$7,'No. Player   Team  ',$0

ReadLeadersPad						;League Leaders: wait (frame-synced) until a joypad reports input; d1 =
									;buttons
	move.l	#$5460,d6
.wait
	move.w	#$64,d6
.1
	move.w	(Vcount).w,d1
	sub.w	(OldVcount).w,d1
	beq.s	.wait
	move.w	(Vcount).w,(OldVcount).w
	jsr	(ReadJoy1).l
	jsr	(ProcessInputWithRepeat).l
	tst.w	d1
	beq.w	.2
	bra.w	.exit
.2
	jsr	(ReadJoy2).l
	jsr	(ProcessInputWithRepeat).l
	tst.w	d1
	beq.w	.3
	bra.w	.exit
.3
	jsr	(ReadJoy3).l
	jsr	(ProcessInputWithRepeat).l
	tst.w	d1
	beq.w	.4
	bra.w	.exit
.4
	jsr	(ReadJoy4).l
	jsr	(ProcessInputWithRepeat).l
	tst.w	d1
	beq.w	.5
	bra.w	.exit
.5
	dbf	d6,.wait
.exit
	rts

ClearLeadersArea					;League Leaders: clear a $28x$14 text area with tile $7FF (individual mode
									;only; team mode returns at once)
	tst.w	(StatWork).w
	beq.w	.exit
	movem.l	d0-d7/a0-a6,-(sp)
	move.w	#$28,d0
	move.w	#$14,d1
	move.w	#$7FF,d2
	jsr	(printz).l
	String	-TXMAP1,$0,$7,$0
	jsr	(eraser).l
	movem.l	(sp)+,d0-d7/a0-a6
.exit
	rts

BuildLeaders						;League Leaders: build sorted team leader list for category StatWork+2
									;(TeamLeaderJumps) or individual list
	tst.w	(StatWork).w
	bne.w	BuildPlayerLeaders
	movem.l	d0-d7/a0-a6,-(sp)
	move.w	(StatWork+2).w,d0
	asl.w	#2,d0
	movea.l	#TeamLeaderJumps,a0
	movea.l	0(a0,d0.w),a0
	jmp	(a0)

TeamLeaderJumps
	dc.l	LeadersPoints,LeadersGoalsAvg,LeadersGoalsAllowed,LeadersSavePct,LeadersShootPct,LeadersShotsAvg,LeadersShotsAllowed

LeadersPoints						;Points: 2*wins+ties per team, sort descending
	movea.l	#StatBuf,a0
	jsr	(ReadStandings).l
	move.w	#NumPlayoffTeams-1,d3
	clr.w	d4
	movea.l	#picturebuf,a0
	movea.l	#TeamLeaderValues,a1
	movea.l	#StatBuf,a2
.loop
	move.b	d4,(a0)+
	clr.w	d0
	move.b	(a2),d0
	add.b	d0,d0
	add.b	1(a2),d0
	move.w	d0,(a1)+
	addq.w	#3,a2
	addq.w	#1,d4
	dbf	d3,.loop
	movea.l	#picturebuf,a0
	bsr.w	SortLeadersDown
	bra.w	BuildLeadersDone

LeadersGoalsAvg						;Goals Avg: goals*100/games per team, sort descending
	move.l	#SRTeamStats,d0
	move.l	#NumPlayoffTeams*10,d1
	movea.l	#StatBuf,a0
	jsr	(ReadSRAM).l
	movea.l	#StandingsRecs,a0
	jsr	(ReadStandings).l
	move.w	#NumPlayoffTeams-1,d3
	clr.w	d4
	movea.l	#LeaderTeamTbls+NumPlayoffTeams,a0
	movea.l	#TeamLeaderValues,a1
	movea.l	#StatBuf,a2
	movea.l	#StandingsRecs,a3
.loop
	move.b	d4,(a0)+
	move.w	0(a2),d0
	beq.w	.1
	mulu.w	#$64,d0
	clr.w	d1
	move.b	(a3),d1
	add.b	2(a3),d1
	add.b	1(a3),d1
	divu.w	d1,d0
.1
	move.w	d0,(a1)+
	addq.w	#3,a3
	adda.w	#$A,a2
	addq.w	#1,d4
	dbf	d3,.loop
	movea.l	#LeaderTeamTbls+NumPlayoffTeams,a0
	bsr.w	SortLeadersDown
	bra.w	BuildLeadersDone

LeadersGoalsAllowed					;Goals Allowed Avg: goals against*100/games per team, sort ascending
	move.l	#SRTeamStats,d0
	move.l	#NumPlayoffTeams*10,d1
	movea.l	#StatBuf,a0
	jsr	(ReadSRAM).l
	movea.l	#StandingsRecs,a0
	jsr	(ReadStandings).l
	move.w	#NumPlayoffTeams-1,d3
	clr.w	d4
	movea.l	#LeaderTeamTbls+(NumPlayoffTeams*2),a0
	movea.l	#TeamLeaderValues,a1
	movea.l	#StatBuf,a2
	movea.l	#StandingsRecs,a3
.loop
	move.b	d4,(a0)+
	move.w	2(a2),d0
	beq.w	.1
	mulu.w	#$64,d0
	clr.w	d1
	move.b	(a3),d1
	add.b	2(a3),d1
	add.b	1(a3),d1
	divu.w	d1,d0
.1
	move.w	d0,(a1)+
	addq.w	#3,a3
	adda.w	#$A,a2
	addq.w	#1,d4
	dbf	d3,.loop
	movea.l	#LeaderTeamTbls+(NumPlayoffTeams*2),a0
	bsr.w	SortLeadersUp
	bra.w	BuildLeadersDone

LeadersPenMinAvg					;Unreferenced: penalty minutes*100/games per team, sort descending
	move.l	#SRTeamStats,d0
	move.l	#NumPlayoffTeams*10,d1
	movea.l	#StatBuf,a0
	jsr	(ReadSRAM).l
	movea.l	#StandingsRecs,a0
	jsr	(ReadStandings).l
	move.w	#NumPlayoffTeams-1,d3
	clr.w	d4
	movea.l	#LeaderTeamTbls+(NumPlayoffTeams*3),a0
	movea.l	#TeamLeaderValues,a1
	movea.l	#StatBuf,a2
	movea.l	#StandingsRecs,a3
.loop
	move.b	d4,(a0)+
	move.w	4(a2),d0
	beq.w	.1
	mulu.w	#$64,d0
	clr.w	d1
	move.b	(a3),d1
	add.b	2(a3),d1
	add.b	1(a3),d1
	divu.w	d1,d0
.1
	move.w	d0,(a1)+
	addq.w	#3,a3
	adda.w	#$A,a2
	addq.w	#1,d4
	dbf	d3,.loop
	movea.l	#LeaderTeamTbls+(NumPlayoffTeams*3),a0
	bsr.w	SortLeadersDown
	bra.w	BuildLeadersDone

LeadersSavePct						;Save Percentage: (shots against - goals against)*100/shots against per
									;team, sort descending
	move.l	#SRTeamStats,d0
	move.l	#NumPlayoffTeams*10,d1
	movea.l	#StatBuf,a0
	jsr	(ReadSRAM).l
	move.w	#NumPlayoffTeams-1,d3
	clr.w	d4
	movea.l	#LeaderTeamTbls+(NumPlayoffTeams*4),a0
	movea.l	#TeamLeaderValues,a1
	movea.l	#StatBuf,a2
.loop
	move.b	d4,(a0)+
	move.w	8(a2),d0
	move.w	d0,d1
	beq.w	.2
	sub.w	2(a2),d1
	bpl.w	.1
	clr.w	d1
.1
	mulu.w	#$64,d1
	divu.w	d0,d1
.2
	move.w	d1,(a1)+
	adda.w	#$A,a2
	addq.w	#1,d4
	dbf	d3,.loop
	movea.l	#LeaderTeamTbls+(NumPlayoffTeams*4),a0
	bsr.w	SortLeadersDown
	bra.w	BuildLeadersDone

LeadersShootPct						;Shooting Percentage: goals*100/shots per team, sort descending
	move.l	#SRTeamStats,d0
	move.l	#NumPlayoffTeams*10,d1
	movea.l	#StatBuf,a0
	jsr	(ReadSRAM).l
	move.w	#NumPlayoffTeams-1,d3
	clr.w	d4
	movea.l	#LeaderTeamTbls+(NumPlayoffTeams*5),a0
	movea.l	#TeamLeaderValues,a1
	movea.l	#StatBuf,a2
.loop
	move.b	d4,(a0)+
	clr.w	d1
	move.w	6(a2),d0
	beq.w	.2
	move.w	(a2),d1
	cmp.w	d0,d1
	ble.w	.1
	move.w	d1,d0
.1
	mulu.w	#$64,d1
	divu.w	d0,d1
.2
	move.w	d1,(a1)+
	adda.w	#$A,a2
	addq.w	#1,d4
	dbf	d3,.loop
	movea.l	#LeaderTeamTbls+(NumPlayoffTeams*5),a0
	bsr.w	SortLeadersDown
	bra.w	BuildLeadersDone

LeadersShotsAvg						;Shots Avg: shots*100/games per team, sort descending
	move.l	#SRTeamStats,d0
	move.l	#NumPlayoffTeams*10,d1
	movea.l	#StatBuf,a0
	jsr	(ReadSRAM).l
	movea.l	#StandingsRecs,a0
	jsr	(ReadStandings).l
	move.w	#NumPlayoffTeams-1,d3
	clr.w	d4
	movea.l	#LeaderTeamTbls+(NumPlayoffTeams*6),a0
	movea.l	#TeamLeaderValues,a1
	movea.l	#StatBuf,a2
	movea.l	#StandingsRecs,a3
.loop
	move.b	d4,(a0)+
	move.w	6(a2),d0
	beq.w	.1
	mulu.w	#$64,d0
	clr.w	d1
	move.b	(a3),d1
	add.b	2(a3),d1
	add.b	1(a3),d1
	divu.w	d1,d0
.1
	move.w	d0,(a1)+
	addq.w	#3,a3
	adda.w	#$A,a2
	addq.w	#1,d4
	dbf	d3,.loop
	movea.l	#LeaderTeamTbls+(NumPlayoffTeams*6),a0
	bsr.w	SortLeadersDown
	bra.w	BuildLeadersDone

LeadersShotsAllowed					;Shots Allowed Avg: shots against*100/games per team, sort ascending
	move.l	#SRTeamStats,d0
	move.l	#NumPlayoffTeams*10,d1
	movea.l	#StatBuf,a0
	jsr	(ReadSRAM).l
	movea.l	#StandingsRecs,a0
	jsr	(ReadStandings).l
	move.w	#NumPlayoffTeams-1,d3
	clr.w	d4
	movea.l	#LeaderTeamTbls+(NumPlayoffTeams*7),a0
	movea.l	#TeamLeaderValues,a1
	movea.l	#StatBuf,a2
	movea.l	#StandingsRecs,a3
.loop
	move.b	d4,(a0)+
	move.w	8(a2),d0
	beq.w	.1
	mulu.w	#$64,d0
	clr.w	d1
	move.b	(a3),d1
	add.b	2(a3),d1
	add.b	1(a3),d1
	divu.w	d1,d0
.1
	move.w	d0,(a1)+
	addq.w	#3,a3
	adda.w	#$A,a2
	addq.w	#1,d4
	dbf	d3,.loop
	movea.l	#LeaderTeamTbls+(NumPlayoffTeams*7),a0
	bsr.w	SortLeadersUp
	bra.w	BuildLeadersDone

BuildLeadersDone					;Shared exit of the team leader builders
	movem.l	(sp)+,d0-d7/a0-a6
	rts

SortLeadersDown						;League Leaders: bubble sort word values at TeamLeaderValues (25 pairs)
									;descending, swapping index bytes at a0
	movea.l	#TeamLeaderValues,a1
.pass
	clr.w	d1
	clr.w	d0
	clr.w	(TempWord1).w
	move.w	#$18,d2
.cmp
	move.w	0(a1,d1.w),d5
	move.w	2(a1,d1.w),d6
	cmp.w	d5,d6
	ble.w	.noswap
	st	(TempWord1).w
	move.w	0(a1,d1.w),-(sp)
	move.w	2(a1,d1.w),-(sp)
	move.w	(sp)+,0(a1,d1.w)
	move.w	(sp)+,2(a1,d1.w)
	move.b	0(a0,d0.w),-(sp)
	move.b	1(a0,d0.w),-(sp)
	move.b	(sp)+,0(a0,d0.w)
	move.b	(sp)+,1(a0,d0.w)
.noswap
	addq.w	#1,d0
	addq.w	#2,d1
	dbf	d2,.cmp
	tst.w	(TempWord1).w
	bne.s	.pass
	rts

SortLeadersUp						;League Leaders: same bubble sort, ascending
	movea.l	#TeamLeaderValues,a1
.pass
	clr.w	d1
	clr.w	d0
	clr.w	(TempWord1).w
	move.w	#$18,d2
.cmp
	move.w	0(a1,d1.w),d5
	move.w	2(a1,d1.w),d6
	cmp.w	d5,d6
	bge.w	.noswap
	st	(TempWord1).w
	move.w	0(a1,d1.w),-(sp)
	move.w	2(a1,d1.w),-(sp)
	move.w	(sp)+,0(a1,d1.w)
	move.w	(sp)+,2(a1,d1.w)
	move.b	0(a0,d0.w),-(sp)
	move.b	1(a0,d0.w),-(sp)
	move.b	(sp)+,0(a0,d0.w)
	move.b	(sp)+,1(a0,d0.w)
.noswap
	addq.w	#1,d0
	addq.w	#2,d1
	dbf	d2,.cmp
	tst.w	(TempWord1).w
	bne.s	.pass
	rts

BuildPlayerLeaders					;League Leaders: individual mode, dispatch on category StatWork+2 through
									;PlayerLeaderJumps
	movem.l	d0-d7/a0-a6,-(sp)
	move.w	(StatWork+2).w,d0
	asl.w	#2,d0
	movea.l	#PlayerLeaderJumps,a0
	movea.l	0(a0,d0.w),a0
	jmp	(a0)

BuildPlayerLeadersDone				;Shared exit of the player leader builders
	movem.l	(sp)+,d0-d7/a0-a6
	rts

PlayerLeaderJumps					;League Leaders: per category (StatWork+2) handler that builds and sorts
									;the leader list
	dc.l	PlayerLeadersGoals
	dc.l	PlayerLeadersAssists
	dc.l	PlayerLeadersPoints
	dc.l	PlayerLeadersGAA

PlayerLeadersGoals					;Category 0: gather with BuildLeaderList (d0 = SRGoals, d1 = $548), sort
									;descending
	move.l	#SRGoals,d0
	move.l	#$548,d1
	movea.l	#BuildLeaderList,a5
	bclr	#1,(BA_PS_flags).w
	bsr.w	GatherAndSort
	bra.s	BuildPlayerLeadersDone

PlayerLeadersAssists				;Category 1: gather with BuildLeaderList (d0 = SRAssists, d1 = $548), sort
									;descending
	move.l	#SRAssists,d0
	move.l	#$548,d1
	movea.l	#BuildLeaderList,a5
	bclr	#1,(BA_PS_flags).w
	bsr.w	GatherAndSort
	bra.s	BuildPlayerLeadersDone

PlayerLeadersPoints					;Category 2: gather with BuildLeaderListSum (d0 = SRGoals, d1 = $548),
									;sort descending
	move.l	#SRGoals,d0
	move.l	#$548,d1
	movea.l	#BuildLeaderListSum,a5
	bclr	#1,(BA_PS_flags).w
	bsr.w	GatherAndSort
	bra.s	BuildPlayerLeadersDone

PlayerLeadersGAA					;Category 3: gather with BuildLeaderListPct (d0 = SRGoals, d1 = $548),
									;sort ascending (bit 1 of BA_PS_flags set)
	move.l	#SRGoals,d0
	move.l	#$548,d1
	movea.l	#BuildLeaderListPct,a5
	bset	#1,(BA_PS_flags).w
	bsr.w	GatherAndSort
	bra.w	BuildPlayerLeadersDone

GatherAndSort						;Call a5 to fill values at LeaderValues / players at LeaderPlayers (count
									;StatWork+$C), then bubble sort both lists by value (descending, or
									;ascending when bit 1 of BA_PS_flags)
	movea.l	#LeaderValues,a0
	movea.l	#StatWork+$C,a2
	movea.l	#LeaderPlayers,a3
	jsr	(a5)
	move.w	(StatWork+$C).w,d3
	beq.w	.rtsSortValues
	subq.w	#1,d3
	clr.w	d4
	movea.l	#LeaderValues,a1
	movea.l	#LeaderPlayers,a0
	btst	#1,(BA_PS_flags).w
	bne.w	.sortValuesUp

.sortValuesDown						;Descending pass: swap neighbours where the next value is larger, repeat
									;until no swap
	clr.w	d0
	clr.w	(TempWord1).w
	move.w	(StatWork+$C).w,d2
	beq.w	.rtsSortValues
	subq.w	#2,d2
	beq.w	.rtsSortValues
	bmi.w	.rtsSortValues
.loop
	move.w	0(a1,d0.w),d5
	move.w	2(a1,d0.w),d6
	cmp.w	d5,d6
	ble.w	.1
	st	(TempWord1).w
	move.w	0(a1,d0.w),-(sp)
	move.w	2(a1,d0.w),-(sp)
	move.w	(sp)+,0(a1,d0.w)
	move.w	(sp)+,2(a1,d0.w)
	move.w	0(a0,d0.w),-(sp)
	move.w	2(a0,d0.w),-(sp)
	move.w	(sp)+,0(a0,d0.w)
	move.w	(sp)+,2(a0,d0.w)
.1
	addq.w	#2,d0
	dbf	d2,.loop
	tst.w	(TempWord1).w
	bne.s	.sortValuesDown

.rtsSortValues
	rts

.sortValuesUp						;Ascending pass: swap neighbours where the next value is smaller, repeat
									;until no swap
	clr.w	d0
	clr.w	(TempWord1).w
	move.w	(StatWork+$C).w,d2
	beq.s	.rtsSortValues
	subq.w	#2,d2
	beq.s	.rtsSortValues
	bmi.s	.rtsSortValues
.loop2
	move.w	0(a1,d0.w),d5
	move.w	2(a1,d0.w),d6
	cmp.w	d5,d6
	bge.w	.3
	st	(TempWord1).w
	move.w	0(a1,d0.w),-(sp)
	move.w	2(a1,d0.w),-(sp)
	move.w	(sp)+,0(a1,d0.w)
	move.w	(sp)+,2(a1,d0.w)
	move.w	0(a0,d0.w),-(sp)
	move.w	2(a0,d0.w),-(sp)
	move.w	(sp)+,0(a0,d0.w)
	move.w	(sp)+,2(a0,d0.w)
.3
	addq.w	#2,d0
	dbf	d2,.loop2
	tst.w	(TempWord1).w
	bne.s	.sortValuesUp
	rts

DrawLeaderRows						;Draw the leader rows (StatWork+8 rows from StatWork+4): when StatWork is
									;set use the sorted list (DrawPlayerLeaderRows), else rank, team logo
									;(DrawLeaderLogo), and the category value (LeaderPrintJumps) from the RAM
									;tables in LeaderTables
	tst.w	(StatWork).w
	bne.w	DrawPlayerLeaderRows
	clr.w	d6
	movea.l	#LeaderTables,a5
	move.w	(StatWork+2).w,d0
	asl.w	#2,d0
	movea.l	(a5,d0.w),a5
	movea.l	a5,a0
	move.w	#9,(printy).w
.row
	move.w	#5,(printx).w
	movea.l	#BlankLine40,a1
	jsr	(print).l
	move.w	#5,(printx).w
	addq.w	#1,(printy).w
	movea.l	#BlankLine40,a1
	jsr	(print).l
	move.w	#2,(printx).w
	move.w	d6,d0
	add.w	(SeasonGameCount).w,d0
	addq.w	#1,d0
	move.w	#2,d1
	jsr	(PushNumberWidth).l
	jsr	(print).l
	subq.w	#1,(printy).w
	move.w	d6,d0
	add.w	(SeasonGameCount).w,d0
	clr.w	d1
	move.b	(a5,d0.w),d1
	move.w	#5,(printx).w
	bsr.w	DrawLeaderLogo
	addq.w	#1,(printy).w
	move.w	#$18,(printx).w
	movea.l	#TeamLeaderValues,a0
	adda.w	(SeasonGameCount).w,a0
	adda.w	(SeasonGameCount).w,a0
	move.w	d6,d0
	asl.w	#1,d0
	move.w	(a0,d0.w),d0
	movea.l	#LeaderPrintJumps,a6
	move.w	(StatWork+2).w,d4
	asl.w	#2,d4
	movea.l	(a6,d4.w),a6
	jsr	(a6)
	addq.w	#1,(printy).w
	addq.w	#1,d6
	cmp.w	(StatWork+$8).w,d6
	blt.w	.row
	bra.w	rtsLeaderRows

LeaderPrintJumps					;Value print handlers per category (StatWork+2)
	dc.l	PrintLeaderNum
	dc.l	PrintLeaderAvg
	dc.l	PrintLeaderAvg
	dc.l	PrintLeaderPct
	dc.l	PrintLeaderPct
	dc.l	PrintLeaderAvg
	dc.l	PrintLeaderAvg

PrintLeaderNum						;Print d0 3 wide
	move.w	#3,d1
	jsr	(PushNumberWidth).l
	jmp	(print).l

PrintLeaderAvg						;Print d0 / 100 as nn.nn (3 wide, '.', 2 digits)
	ext.l	d0
	divu.w	#$64,d0
	swap	d0
	move.w	d0,-(sp)
	swap	d0
	move.w	#3,d1
	jsr	(PushNumberWidth).l
	jsr	(print).l
	jsr	(printz).l
	String	'.',$0
	move.w	(sp)+,d0
	move.w	#2,d1
	jsr	(PushNumberWidthZero).l
	jmp	(print).l

PrintLeaderPct						;Print d0 3 wide followed by '%'
	jsr	(PrintLeaderNum).l
	jsr	(printz).l
	String	'%',$0
	rts

DrawPlayerLeaderRows				;Sorted list rows: rank, player name (TeamList, d7 = value / 26 team,
									;remainder player) and value from LeaderValues (category 3 as nn.nn);
									;records the last row in StatWork+$A
	clr.w	d6
	movea.l	#LeaderValues,a5
	move.w	#9,(printy).w
.row
	move.w	#5,(printx).w
	movea.l	#BlankLine40,a1
	jsr	(print).l
	move.w	#5,(printx).w
	addq.w	#1,(printy).w
	movea.l	#BlankLine40,a1
	jsr	(print).l
	move.w	d6,d0
	add.w	(SeasonGameCount).w,d0
	cmp.w	(StatWork+$C).w,d0
	blt.w	.entry
	movea.l	#BlankLine40,a1
	move.w	#1,(printx).w
	jsr	(print).l
	move.w	d6,d0
	add.w	(SeasonGameCount).w,d0
	cmp.w	(StatWork+$A).w,d0
	bge.w	.next
	move.w	d0,(StatWork+$A).w
	bra.w	.next
.entry
	move.w	#2,(printx).w
	move.w	d6,d0
	add.w	(SeasonGameCount).w,d0
	addq.w	#1,d0
	move.w	#2,d1
	jsr	(PushNumberWidth).l
	jsr	(print).l
	move.w	#6,(printx).w
	movea.l	#LeaderPlayers,a0
	move.w	d6,d0
	add.w	(SeasonGameCount).w,d0
	add.w	d0,d0
	move.w	(a0,d0.w),d0
	ext.l	d0
	divu.w	#$1A,d0
	move.w	d0,d7
	swap	d0
	jsr	(FormatPlayerNameD7).l
	jsr	(print).l
	move.w	#$14,(printx).w
	movea.l	#TeamList,a1
	move.w	d7,d0
	asl.w	#2,d0
	movea.l	(a1,d0.w),a1
	adda.w	4(a1),a1
	adda.w	(a1),a1
	jsr	(print).l
	move.w	#$1D,(printx).w
	movea.l	#LeaderValues,a0
	move.w	d6,d0
	add.w	(SeasonGameCount).w,d0
	add.w	d0,d0
	move.w	(a0,d0.w),d0
	cmpi.w	#3,(StatWork+2).w
	bne.w	.2
	ext.l	d0
	divu.w	#$64,d0
	swap	d0
	move.w	d0,-(sp)
	swap	d0
	move.w	#3,d1
	jsr	(PushNumberWidth).l
	jsr	(print).l
	jsr	(printz).l
	String	'.',$0
	move.w	(sp)+,d0
	move.w	#2,d1
	jsr	(PushNumberWidthZero).l
	bra.w	.3
.2
	move.w	#3,d1
	jsr	(PushNumberWidth).l
.3
	jsr	(print).l
.next
	addq.w	#1,(printy).w
	addq.w	#1,d6
	cmp.w	(StatWork+$8).w,d6
	blt.w	.row
	bra.w	rtsLeaderRows

rtsLeaderRows						;rts (DrawLeaderRows)
	rts

LeaderTables						;RAM tables (team order) per category for DrawLeaderRows
	dc.l	LeaderTeamTbls
	dc.l	LeaderTeamTbls+NumPlayoffTeams
	dc.l	LeaderTeamTbls+(NumPlayoffTeams*2)
	dc.l	LeaderTeamTbls+(NumPlayoffTeams*4)
	dc.l	LeaderTeamTbls+(NumPlayoffTeams*5)
	dc.l	LeaderTeamTbls+(NumPlayoffTeams*6)
	dc.l	LeaderTeamTbls+(NumPlayoffTeams*7)

DrawLeaderLogo						;Draw small team logo d1 from Teamblocksmap at printx / printy. Saves all
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

BlankLine40							;String record (40 spaces) used by the League Leaders code
	String	'                                       ',0

LeadersHelp							;League Leaders footer: "[]=Change Stats B=Individual Leaders", or "B=Team
									;Leaders" in individual mode (StatWork set)
	movem.l	d0-d7/a0-a6,-(sp)
	tst.w	(StatWork).w
	beq.w	.0
	jsr	(printz).l
	String	-(TXPRI+TXMAP1),2,$1A,0
	jsr	(printsmallz).l
	String	CC_SetFont,1,'[]=Change Stats       B=Team Leaders ',CC_SetFont,0,0
	bra.w	.1
.0
	jsr	(printz).l
	String	-(TXPRI+TXMAP1),2,$1A,0
	jsr	(printsmallz).l
	String	CC_SetFont,1,'[]=Change Stats  B=Individual Leaders',CC_SetFont,0,0
.1
	movem.l	(sp)+,d0-d7/a0-a6
	rts

PeriodStatsScreen					;Both team logos, goals/shots by period and total; left/right switch,
									;start exits
	movem.l	d0-d7/a0-a6,-(sp)
	clr.w	(matchup).w
	moveq	#0,d0
	moveq	#$1C,d1
	move.l	#ControllerBgMap,(screenarg).l
	jsr	(DrawTeamScreen2).l
	jsr	(printz).l
	String	-TXMAP3,2,6,0
	movea.l	#PeriodStatsMap,a0
	movea.l	a0,a1
	movea.l	a0,a2
	adda.l	(a2)+,a0
	adda.l	(a2)+,a1
	clr.w	d0
	clr.w	d1
	move.w	(a1),d2
	move.w	2(a1),d3
	moveq	#0,d5
	jsr	(dobitmap).l
	jsr	(printz).l
	String	-(TXPRI+TXMAP2),1,8,0
	move.w	#8,d0
	move.w	#8,d1
	jsr	(printz).l
	String	-(TXPRI+TXMAP2),1,$F,0
	move.w	#8,d0
	move.w	#8,d1
	jsr	(printz).l
	String	-(TXPRI+TXPAL2+TXMAP2),2,9,0
	movea.l	#TeamLogoBitmaps,a0
	move.w	(VisTeam).w,d0
	asl.w	#2,d0
	movea.l	0(a0,d0.w),a0
	movea.l	a0,a1
	movea.l	a0,a2
	adda.l	(a2)+,a0
	asl.w	#3,d0
	movea.l	#TeamLogoPalettes,a0
	subi.w	#$40,d0
	adda.w	d0,a0
	adda.l	(a2)+,a1
	clr.w	d1
	clr.w	d0
	moveq	#6,d2
	move.w	#6,d3
	moveq	#4,d5
	jsr	(dobitmap).l
	movea.l	#palfadenew+$40,a0
	movea.l	#palfadenew+$60,a1
	move.w	#7,d0
.loop
	move.l	(a0)+,(a1)+
	dbf	d0,.loop
	jsr	(printz).l
	String	-(TXPRI+TXPAL3+TXMAP2),2,$10,0
	movea.l	#TeamLogoBitmaps,a0
	move.w	(HomeTeam).w,d0
	asl.w	#2,d0
	movea.l	0(a0,d0.w),a0
	movea.l	a0,a1
	movea.l	a0,a2
	adda.l	(a2)+,a0
	asl.w	#3,d0
	subi.w	#$40,d0
	movea.l	#TeamLogoPalettes,a0
	adda.w	d0,a0
	adda.l	(a2)+,a1
	clr.w	d1
	clr.w	d0
	moveq	#6,d2
	move.w	#6,d3
	moveq	#4,d5
	jsr	(dobitmap).l
	jsr	(printz).l
	String	-(TXPRI+TXMAP3),4,1,0
	moveq	#$20,d0
	moveq	#6,d1
	jsr	(printbigz).l
	String	-(TXPRI+TXMAP3),9,2,'Period',-(TXPRI+TXMAP3),$15,2,'Stats',-(TXPRI+TXMAP2),6,1
	btst	#1,(sflags7).w
	beq.w	.0
	jsr	(printz).l
	String	$BE,$0C,$07,'1',$BE,$11,$07,'2',$BE,$16,$07,'3',$BE,$1A,$07,'OT',$BE,' ',$07,'Total'
	bra.w	.1
.0
	jsr	(printz).l
	String	$BE,$0C,$07,'1',$BE,$11,$07,'2',$BE,$16,$07,'3',$BE,' ',$07,'Total'
.1
	bsr.w	PeriodStatsCaption
	bsr.w	PeriodStatsColumns
	move.w	#$18,(palcount).w
.loop2
	jsr	(WaitVSyncAndReadInput).l	;left (bit 2) goals, right (bit 3) shots, start exits
	btst	#7,d1
	bne.w	.exit
	btst	#2,d1
	bne.w	.3
	btst	#3,d1
	bne.w	.2
	bra.s	.loop2
.2
	tst.w	(matchup).w
	bne.s	.loop2
	st	(matchup).w
	bsr.w	PeriodStatsCaption
	bsr.w	PeriodStatsColumns
	bra.s	.loop2
.3
	tst.w	(matchup).w
	beq.s	.loop2
	clr.w	(matchup).w
	bsr.w	PeriodStatsCaption
	bsr.w	PeriodStatsColumns
	bra.s	.loop2
.exit
	movem.l	(sp)+,d0-d7/a0-a6
	jmp	(ExitStatsScreen).l

PeriodStatsCaption					;Caption "Shots" + "[ For Goals" or "Goals" + "For Shots ]" by matchup
	tst.w	(matchup).w
	beq.w	.0
	jsr	(printz).l
	String	-(TXPRI+TXMAP2),$11,5,'Shots',-(TXPRI+TXMAP2),$F,$1A,0
	jsr	(printsmallz).l
	String	CC_SetFont,1,'[ For Goals',CC_SetFont,0,0
	rts
.0
	jsr	(printz).l
	String	-(TXPRI+TXMAP2),$11,5,'Goals',-(TXPRI+TXMAP2),$F,$1A,0
	jsr	(printsmallz).l
	String	CC_SetFont,1,'For Shots ]',CC_SetFont,0,0
	rts

PeriodStatsColumns					;Print both teams' period columns (away row $B,
									;home row $12) and the total
	movem.l	d0-d7/a0-a6,-(sp)
	jsr	(printz).l
	String	-(TXPRI+TXMAP2),$0,$0,$0
	movea.l	#AwShots,a2
	move.w	#$B,(printy).w
	bsr.w	PeriodStatsTeam
	movea.l	#tmstruct,a2
	move.w	#$12,(printy).w
	bsr.w	PeriodStatsTeam
	movem.l	(sp)+,d0-d7/a0-a6
	rts

PeriodStatsTeam						;PeriodStatsScreen per team: goals ($344) or shots ($34C) by period up to
									;the current one (OT if sflags7 bit 1), then the total
	lea	$344(a2),a0
	tst.w	(matchup).w
	beq.w	.0
	lea	$34C(a2),a0
.0
	clr.w	(matchuptimer).w
	move.w	#$B,(printx).w
	bsr.w	PeriodStatsValue
	cmpi.w	#1,(gsp).w
	blt.w	.1
	move.w	#$10,(printx).w
	bsr.w	PeriodStatsValue
	cmpi.w	#2,(gsp).w
	blt.w	.1
	move.w	#$15,(printx).w
	bsr.w	PeriodStatsValue
	cmpi.w	#3,(gsp).w
	blt.w	.1
	btst	#1,(sflags7).w
	beq.w	.1
	move.w	#$1A,(printx).w
	bsr.w	PeriodStatsValue
.1
	move.w	#$21,(printx).w
	jsr	(printz).l
	String	'   ',$0
	subq.w	#3,(printx).w
	move.w	(matchuptimer).w,d0
	move.w	#2,d1
	cmp.w	#$64,d0
	blt.w	.2
	move.w	#3,d1
.2
	jsr	(PushNumberWidth).l
	jsr	(print).l
	rts

PeriodStatsValue					;PeriodStatsScreen: print the next period value
									;(a0)+ and add it to the total
	move.w	(a0)+,d0
	add.w	d0,(matchuptimer).w
	jsr	(printz).l
	String	'   ',$0
	subq.w	#3,(printx).w
	move.w	#2,d1
	cmp.w	#$64,d0
	blt.w	.0
	move.w	#3,d1
.0
	jsr	(PushNumberWidth).l
	jmp	(print).l

LineEditor							;"Line Editor" screen for team a2, slot cursor = 1
	bset	#0,$30(a2)
	moveq	#0,d0
	moveq	#$1C,d1
	move.l	#PlayerSelectMap1,(screenarg).l
	jsr	(DrawTeamScreen6).l
	clr.w	(DispAttribCtr).w
	clr.w	(PlayerScrollCtr).w
	move.w	#1,(setupvalues).w

LineEditorRedraw					;Clear and redraw the whole editor (also the exit menu's return point)
	jsr	(LineEditorBg).l
	jsr	(seta2).l

LineEditorReturn					;Line editor: back from the exit menu (load, copy or save lines): clear
									;the screen and redraw the lines
	jsr	(printsmallz).l
	String	CC_SetMap,$2,CC_SetX,$0,CC_SetY,$0
	moveq	#$28,d0
	moveq	#$1C,d1
	move.w	#$7FF,d2
	jsr	(eraser).l
	st	(redrawicons).w
	jsr	(ClearMenuFlags).l

LineEditorMenu						;Slot cursor loop; start exits, C picks a player, d-pad moves via
									;LineCursorTable
	jsr	(DrawLineEditorScreen).l
	jsr	(DrawLineIcons).l
.0
	jsr	(vcountwait).l
	jsr	(ReadMenuJoy).l
	jsr	(ProcessInputWithRepeat).l
	btst	#7,d1
	bne.w	LineEditorExit
	btst	#5,d1
	bne.w	SelectLinePlayer
	moveq	#1,d0
	btst	#1,d1
	bne.w	.1
	moveq	#-1,d0
	btst	#0,d1
	bne.w	.1
	moveq	#8,d0
	btst	#3,d1
	bne.w	.1
	moveq	#-8,d0
	btst	#2,d1
	beq.s	.0
.1
	add.w	(setupvalues).w,d0
	tst.w	(OptLine).w
	beq.w	.2
	cmp.w	#1,d0
	blt.s	.0
	cmp.w	#5,d0
	bgt.s	.0
.2
	lea	LineCursorTable(pc),a0		;the slot after the move
	move.b	8(a0,d0.w),(setupvalues+1).w
	jsr	(DrawLineIcons).l
	bra.s	.0

SelectLinePlayer					;Build the list of players for the slot and let the user pick one
									;(SetLineSlot)
	jsr	(GetGoalieCount).l
	move.w	d0,d1
	jsr	(GetForwards).l
	move.w	(setupvalues).w,d2
	andi.w	#7,d2
	cmp.w	#2,d2
	bgt.w	.n
	add.w	d0,d1
	jsr	(GetPlayerCount).l
	sub.w	d1,d0
.n
	subq.w	#1,d0
	move.w	d0,(screentimer).w
	clr.w	(PlayerScrollCtr).w
	clr.w	(VertLineScrolling).w
	movea.w	#(Satt-M68K_RAM),a0
	clr.w	d2
.fill
	move.b	d1,0(a0,d2.w)
	cmp.w	d1,d6
	bne.w	.nc
	move.w	d2,(VertLineScrolling).w
.nc
	addq.w	#1,d1
	addq.w	#1,d2
	dbf	d0,.fill
	jsr	(PlayerSelectBg).l
	jsr	(ClearLineEditorTop).l
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
	bra.w	.vert
.3
	jsr	(vcountwait).l
	jsr	(ReadMenuJoy).l
	jsr	(ProcessInputWithRepeat).l
	btst	#7,d1
	beq.w	.4
	jsr	(LineEditorBg).l
	bra.w	LineEditorMenu
.4
	btst	#5,d1
	bne.w	.pick
	moveq	#1,d0
	btst	#1,d1
	bne.w	.vert
	btst	#3,d1
	bne.w	.horz
	moveq	#-1,d0
	btst	#0,d1
	bne.w	.vert
	btst	#2,d1
	bne.w	.horz
	bra.s	.3
.horz
	add.w	(DispAttribCtr).w,d0
	bmi.s	.3
	move.w	d0,(DispAttribCtr).w
	jsr	(PrintAttribHeader).l
	bra.s	.3
.vert
	add.w	(VertLineScrolling).w,d0
	bmi.s	.3
	cmp.w	(screentimer).w,d0
	bgt.s	.3
	move.w	d0,(VertLineScrolling).w
	cmp.w	(PlayerScrollCtr).w,d0
	bgt.w	.top
	move.w	d0,(PlayerScrollCtr).w
.top
	subq.w	#5,d0
	cmp.w	(PlayerScrollCtr).w,d0
	ble.w	.8
	move.w	d0,(PlayerScrollCtr).w
.8
	jsr	(PrintAttribHeader).l
	bra.w	.3
.pick
	movea.w	#(Satt-M68K_RAM),a3
	adda.w	(VertLineScrolling).w,a3
	move.b	(a3),d0
	addq.b	#1,d0
	move.w	(setupvalues).w,d2
	jsr	(SetLineSlot).l
	jsr	(LineEditorBg).l
	bra.w	LineEditorMenu

PrintAttribHeader					;Player list column header (PAttribColumns page DispAttribCtr), then 6
									;rows of names, selected row highlighted
	jsr	(printz).l
	String	-(TXPRI+TXMAP2),$16,$1,$0
.top
	movea.l	#PAttribColumns,a1
	move.w	(DispAttribCtr).w,d0
	bra.w	.2
.next
	adda.w	(a1),a1
	addq.w	#4,a1
.2
	tst.w	(a1)
	dbmi	d0,.next
	bpl.w	.found
	subq.w	#1,(DispAttribCtr).w
	bra.s	.top
.found
	jsr	(print).l
	move.l	(a1),d4
	movea.w	#(Satt-M68K_RAM),a3
	move.w	(PlayerScrollCtr).w,d2
	move.w	(screentimer).w,d1
	sub.w	d2,d1
	cmp.w	#5,d1
	bls.w	.4
	moveq	#5,d1
.4
	move.w	#2,(printy).w
.5
	jsr	(printsmallz).l
	String	CC_SetAttribute,$4,CC_SetX,$3,CC_AddY,$1,'                        ',CC_SetX,$5
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
	move.b	0(a3,d2.w),d0
	jsr	(GetNameandAttrib).l
	addq.w	#1,d2
	dbf	d1,.5
	rts

DrawLineIcons						;Draw the line icons for the cursor's line, then the selected player box
	moveq	#6,d5
	lea	LineIconGroups(pc),a0
	move.w	(setupvalues).w,d0
	lsr.w	#3,d0
	adda.w	d0,a0
	tst.w	(OptLine).w
	beq.w	.0
	subq.w	#1,a0
.0
	move.b	(a0),d0
	cmp.b	(redrawicons).w,d0
	beq.w	.line
	move.b	d0,(redrawicons).w
	jsr	(ClearLineArea).l
.line
	btst	d5,(redrawicons).w
	beq.w	.2
	bsr.w	DrawLineIcon
.2
	dbf	d5,.line
	jsr	(printsmallz).l
	String	CC_SetMapAndPosition,$4,$2,$8,$7,CC_SetFont,$1,$0
	jsr	(printsmallz).l
	String	CC_SetX,$0,CC_SetY,$7,'                                       ',$0
	jsr	(printsmallz).l
	String	CC_SetX,$15,CC_SetY,$7
	move.w	d6,d0
	jsr	(getname).l
	move.w	(a1),d0
	lsr.w	#1,d0
	sub.w	d0,(printx).w
	move.w	d7,(printa).w
	jsr	(printsmall).l
	clr.w	(printfontset).w
	rts
	dc.b	0,1						;the entry before LineIconGroups (read with OptLine set)

LineIconGroups						;Per line, bit mask of the lines drawn together
	dc.b	7,7,7,$18,$18,$60,$60,$FF

DrawLineIcon						;Draw line d5 (name, then its player slots) at LineIconPosTable
	moveq	#6,d0
	mulu.w	d5,d0
	lea	LineIconPosTable(pc),a0
	adda.w	d0,a0
	tst.w	(OptLine).w
	beq.w	.0
	subq.w	#6,a0
.0
	move.w	(a0),(printx).w
	move.w	2(a0),(printy).w
	move.w	d5,d0
	movea.l	#linelist,a1
	move.w	#$8000,(printa).w
	jsr	(PrintSmallListItem).l
	jsr	(printsmallz).l
	String	' Line',$0
	move.w	(a0),(printx).w
	move.w	d5,d4
	asl.w	#3,d4
	addq.w	#1,d4
	move.w	2(a0),(printy).w
	move.w	4(a0),d3
	lea	$16C(a2),a3
.slot
	move.w	(a0),(printx).w
	jsr	(printsmallz).l
	String	CC_AddX,$FF,CC_AddY,$2,CC_SetAttribute,$6
	clr.w	d0
	move.b	0(a3,d4.w),d0
	subq.w	#1,d0
	jsr	(FormatPlayerNameShort).l
	cmp.w	(setupvalues).w,d4
	bne.w	.nocur
	move.w	d0,d6
	move.w	(printa).w,d7
	move.w	#2,(printfontset).w
.nocur
	jsr	(printsmall).l
	clr.w	(printfontset).w
	addq.w	#1,d4
	dbf	d3,.slot
	rts

ClearLineArea						;Erase the line area and print the position header (LD RD LW C RW)
	jsr	(printsmallz).l
	String	CC_SetMap,$2,CC_SetX,$0,CC_SetY,$A
	moveq	#$28,d0
	moveq	#$12,d1
	move.w	#$7FF,d2
	jsr	(eraser).l
	move.w	(LineIconPosTable+2).l,(printy).l
	move.w	(LineIconPosTable).l,(printx).l
	tst.w	(OptLine).w
	beq.w	.0
	move.w	(LineIconPosTable-6).l,(printx).l
.0
	jsr	(printsmallz).l
	String	$FE,$04,$FB,$FD,$FA,$02,'LD',$FB,$FE,$FA,$02,'RD',$FB,$FE,$FA,$02,'LW',$FB,$FE,$FA,$02,'C ',$FB,$FE,$FA,$02,'RW'
	rts

DrawLineEditorScreen				;Clear, print the "Line Editor" title and the team logo
	jsr	(ClearLineEditorTop).l
	jsr	(printz).l
	String	-(TXPRI+TXMAP2),$7,$1,$0
	moveq	#$1A,d0
	moveq	#6,d1
	jsr	(printbigz).l
	String	-(TXPRI+TXMAP2),$A,$4,'Line  Editor',-(TXPRI+TXMAP2),$E,$1
	clr.w	d0
	cmpa.w	#(tmstruct-M68K_RAM),a2
	beq.w	.0
	move.w	#$2C,d0
.0
	jmp	(PutTeamBlock).l

ClearLineEditorTop					;Erase 40 x 10 at the top of map 2
	jsr	(printz).l
	String	-(TXPRI+TXMAP2),$0,$0,$0
	moveq	#$28,d0
	moveq	#$A,d1
	move.w	#$7FF,d2
	jmp	(eraser).l

ClearMenuFlags						;Clear palfadenew+$5A and palfadenew+$7A
	clr.w	(palfadenew+$5A).w
	clr.w	(palfadenew+$7A).w
	rts
	dc.w	$10,$C,4				;LineIconPosTable-6: the entry used with OptLine set

LineIconPosTable					;Line icons x, y, slot count - 1
	dc.w	4,$C,4
	dc.w	$10,$C,4
	dc.w	$1C,$C,4
	dc.w	4,$C,4
	dc.w	$10,$C,4
	dc.w	4,$C,3
	dc.w	$10,$C,3
	dc.w	$FFFF

LineCursorTable						;The slot after a cursor move, indexed by slot + 8
	dc.b	1,1,2,3,4,5,$19,1
	dc.b	1,1,2,3,4,5,$19,1
	dc.b	9,9,$A,$B,$C,$D,$21,1
	dc.b	$11,$11,$12,$13,$14,$15,$21,1
	dc.b	5,$19,$1A,$1B,$1C,$1D,$29,1
	dc.b	$D,$21,$22,$23,$24,$25,$31,1
	dc.b	$1D,$29,$2A,$2B,$2C,$2C,1,1
	dc.b	$25,$31,$32,$33,$34,$34,1,1
	dc.b	$25,$31,$32,$33,$34,$34,1,1

LineEditorExit						;Exit box (rewritten in 95): Start leaves, A original lines, B load / C
									;save team line (save RAM)
	jsr	(ClearMenuFlags).l
	btst	#6,(sflags11).w
	beq.w	.0
	jsr	(printz).l
	String	-(TXPAL3+TXMAP2),$8,$A,$0
	move.w	#$18,d0
	move.w	#9,d1
	jsr	(Framer).l
	jsr	(printsmallz).l
	String	$F8,$04,$02,$09,$0B,$F9,$02,'Start = Exit',$FD,$09,$FC,$0D,'A = Set Original Lines',$F9,$00
	bra.w	.loop
.0
	bsr.w	TeamLinesOffset
	movea.l	#StatBuf,a0
	jsr	(ReadSRAM).l
	move.b	$38(a0),d0
	cmp.b	#$64,d0
	bne.w	.1
	bset	#1,(sflags10).w
	jsr	(printz).l
	String	-(TXPAL3+TXMAP2),$8,$A,$0
	move.w	#$18,d0
	move.w	#9,d1
	jsr	(Framer).l
	jsr	(printsmallz).l
	String	$F8,$04,$02,$09,$0B,$F9,$02,'Start = Exit',$FD,$09,$FC,$0D,'A = Set Original Lines',$FD,$09,$FC,$0F,'B = Load Team Line',$FD,$09,$FC,$11,'C = Save Team Line',$F9,$00
	bra.w	.loop
.1
	bclr	#1,(sflags10).w
	jsr	(printz).l
	String	-(TXPAL3+TXMAP2),$8,$A,$0
	move.w	#$18,d0
	move.w	#7,d1
	jsr	(Framer).l
	jsr	(printsmallz).l
	String	$F8,$04,$02,$09,$0B,$F9,$02,'Start = Exit',$FD,$09,$FC,$0D,'A = Set Original Lines',$FD,$09,$FC,$0F,'C = Save Team Line',$F9,$00
	bra.w	.loop
.loop
	jsr	(vcountwait).l
	jsr	(ReadMenuJoy).l
	tst.w	d1
	beq.s	.loop
	btst	#7,d1
	beq.w	.3
	bra.w	.7
.3
	btst	#6,d1
	beq.w	.4
	jsr	(SetOriginalLines).l
	bra.w	LineEditorReturn
.4
	btst	#6,(sflags11).w
	bne.s	.loop
	btst	#4,d1
	beq.w	.5
	btst	#1,(sflags10).w
	beq.w	.5
	movea.l	#StatBuf,a0
	jsr	(LoadTeamLines).l
	bra.w	LineEditorReturn
.5
	btst	#5,d1
	beq.w	.6
	jsr	(SaveTeamLines).l
	bra.w	LineEditorReturn
.6
	bra.s	.loop
.7
	jmp	(ExitStatsScreen).l

LineEditorBg						;Draw the line editor background bitmap (LineEditorBgMap) on map 2, clear
									;BA_PS_flags bit 1
	movem.l	d0-d7/a0-a6,-(sp)
	bclr	#1,(BA_PS_flags).w
	move.w	(screen6chars2).w,d4
	jsr	(printz).l
	String	-TXMAP3,$0,$0,$0
	movea.l	#LineEditorBgMap,a0
	movea.l	a0,a1
	movea.l	a0,a2
	adda.l	(a2)+,a0
	adda.l	(a2)+,a1
	clr.w	d0
	clr.w	d1
	move.w	(a1),d2
	move.w	2(a1),d3
	movea.l	#ZeroLong,a2
	moveq	#$F,d5
	jsr	(dobitmap).l
	move.w	#$18,(palcount).w
	movem.l	(sp)+,d0-d7/a0-a6
	rts

PlayerSelectBg						;Draw the player select list background bitmaps (PlayerSelectMap1,
									;PlayerSelectMap2) on map 2, set BA_PS_flags bit 1
	movem.l	d0-d7/a0-a6,-(sp)
	bset	#1,(BA_PS_flags).w
	move.w	(screen6chars1).w,d4
	jsr	(printz).l
	String	-TXMAP3,$0,$0,$0
	movea.l	#PlayerSelectMap1,a0
	movea.l	a0,a1
	movea.l	a0,a2
	adda.l	(a2)+,a0
	adda.l	(a2)+,a1
	clr.w	d0
	clr.w	d1
	move.w	(a1),d2
	move.w	#$A,d3
	movea.l	#ZeroLong,a2
	moveq	#0,d5
	jsr	(dobitmap).l
	move.w	(screen6chars3).w,d4
	jsr	(printz).l
	String	-TXMAP3,$0,$0,$0
	movea.l	#PlayerSelectMap2,a0
	movea.l	a0,a1
	movea.l	a0,a2
	adda.l	(a2)+,a0
	adda.l	(a2)+,a1
	clr.w	d0
	clr.w	d1
	move.w	(a1),d2
	move.w	2(a1),d3
	movea.l	#ZeroLong,a2
	moveq	#0,d5
	jsr	(dobitmap).l
	movem.l	(sp)+,d0-d7/a0-a6
	rts

SetLineSlot							;Put player d0 in line slot d2 of team a2 (swap if already in that line)
	movem.l	d0-d2/a0-a1,-(sp)
	lea	$16C(a2),a0
	move.w	d2,d1
	andi.w	#$FFF8,d1
	lea	0(a0,d1.w),a1
	moveq	#5,d1
.find
	cmp.b	1(a1,d1.w),d0
	dbeq	d1,.find
	bne.w	.put
	move.b	0(a0,d2.w),1(a1,d1.w)
.put
	move.b	d0,0(a0,d2.w)
	movem.l	(sp)+,d0-d2/a0-a1
	rts

SaveTeamLines						;C in exit menu: save team a2's lines ($16C) to save RAM at the team's
									;slot and mark the buffer valid ($64)
	movem.l	d0-d7/a0-a6,-(sp)
	bsr.w	TeamLinesOffset
	move.l	d0,-(sp)
	lea	$16C(a2),a0
	jsr	(WriteSRAM).l
	movea.l	#StatBuf,a0
	move.b	#$64,(a0)
	moveq	#1,d1
	move.l	(sp)+,d0
	addi.l	#$38,d0
	jsr	(WriteSRAM).l
	jsr	(MakeSRAMChecksum).l
	movem.l	(sp)+,d0-d7/a0-a6
	rts

LoadTeamLines						;B in exit menu: copy the loaded line data (a0, 56 bytes) into team a2's
									;lines ($16C)
	movem.l	d0-d7/a0-a6,-(sp)
	lea	$16C(a2),a1
	move.w	#$D,d0
.loop
	move.l	(a0)+,(a1)+
	dbf	d0,.loop
	movem.l	(sp)+,d0-d7/a0-a6
	rts

TeamLinesOffset						;d0 = save RAM offset of team a2's saved line ($39 bytes per team; base by
									;GameFlags bit 3 / sflags10 bit 0)
	move.l	#SRSavedLines1,d0
	btst	#3,(GameFlags).w
	bne.w	.1
	btst	#0,(sflags10).w
	bne.w	.0
	bra.w	.2
.0
	move.l	#SRSavedLines3,d0
	bra.w	.2
.1
	move.l	#SRSavedLines2,d0
.2
	moveq	#$39,d1
	move.w	d1,-(sp)
	mulu.w	Xvel(a2),d1
	add.l	d1,d0
	move.w	(sp)+,d1
	rts

ShowThreeStars						;End of game Stars of the Game box. Called from UpdatePA while RefPen is
									;the game over penalty. Waits for RefCnt
									;<= $40 and runs once (gmode bit 7); then disflags bit 3 and a vblank.
									;Frames the box, draws a bitmap, then the three best star scores
									;(TakeTopStarScore). 95: not with sflags9 bit 7
	cmpi.w	#$40,(RefCnt).w
	bgt.w	.4
	bset	#gmstars,(gmode).w
	bne.w	.4
	btst	#7,(sflags9).w
	bne.w	.4
	movem.l	d0/a1,-(sp)
	bset	#dfclock,(disflags).w
	move.w	(Vcount).w,d0
.loop2
	cmp.w	(Vcount).w,d0
	beq.s	.loop2
	movem.l	(sp)+,d0/a1
	movem.l	d0-d5/a0-a4,-(sp)
	jsr	(printz).l
	String	-(TXPRI+TXMAP1),$2,$E,$0
	moveq	#$1C,d0					;framer size
	moveq	#9,d1
	jsr	(Framer).l
	jsr	(printz).l
	String	-(TXPRI+TXMAP1),$9,$10,'Stars of the Game',-(TXPRI+TXMAP1),$3,$F,$0
	bsr.w	CalcStarScores
	move.w	#$12,(printy).w
	moveq	#2,d2					;3 stars
.loop
	bsr.w	TakeTopStarScore		;a2 = team, d0 = player
	move.w	#$1A,(printx).w
.2
	addq.w	#1,(printy).w
	movea.l	$1E(a2),a1
	adda.w	4(a1),a1
	adda.w	(a1),a1
	jsr	(print).l
	jsr	(getname).l
	move.w	#3,(printx).w
	jsr	(print).l
	dbf	d2,.loop
	move.w	(HmGoals).w,d0
	sub.w	(AwGoals).w,d0
	ble.w	.nosong
	move.w	#SFXhomewin,-(sp)		;home team won
	jsr	(song).l
.nosong
	movem.l	(sp)+,d0-d5/a0-a4
.4
	rts

TakeTopStarScore					;Take the highest of the 52 star scores at ThreeStars (26 per team, home
									;first) and clear it. Returns d0 = player
									;slot, a2 = its team struct
	movem.l	d1-d2/a1/a4,-(sp)
.0
	movea.w	#(ThreeStars-M68K_RAM),a4
	clr.l	d0
	moveq	#$33,d2
.find
	cmp.l	(a4)+,d0
	bge.w	.next
	lea	-4(a4),a1
	move.l	(a1),d0
.next
	dbf	d2,.find
	clr.l	(a1)
	move.w	a1,d0
	subi.w	#(ThreeStars-M68K_RAM),d0
	lsr.w	#2,d0					;entry number
	movea.w	#(tmstruct-M68K_RAM),a2
	cmp.w	#$1A,d0
	blt.w	.home
	subi.w	#$1A,d0
	adda.w	#tmsize,a2				;26-51: away team (tmsize)
.home
	movem.l	(sp)+,d1-d2/a1/a4
	rts

CalcStarScores						;Star score for every roster slot of both teams to ThreeStars (26 longs
									;per team, home first). d5 = GetPeriodTime
									;+ d2, the goalie ice time needed. If gsp is 3 and the score is not tied,
									;the scorer of the last goal gets $7FFFFFFF
	movea.w	#(ThreeStars-M68K_RAM),a4
	jsr	(GetPeriodTime).l
	move.w	d0,d5
	add.w	d2,d5
	movea.w	#(tmstruct-M68K_RAM),a2
	lea	tmsize(a2),a3
	bsr.w	CalcTeamStarScores		;home
	movea.w	a3,a2
	lea	-tmsize(a2),a3
	bsr.w	CalcTeamStarScores		;away (d3 = away - home score)
	cmpi.w	#3,(gsp).w
	bne.w	.x
	tst.w	d3
	beq.w	.x
	movea.w	#(ChkCnt-M68K_RAM),a0	;+ ScoreSumbytes = last goal entry
	adda.w	(ScoreSumbytes).w,a0
	clr.w	d0
	btst	#7,2(a0)
	beq.w	.slot
	addi.w	#$1A,d0					;away goal: second 26 entries
.slot
	add.b	3(a0),d0
	asl.w	#2,d0
	movea.w	#(ThreeStars-M68K_RAM),a0
	move.l	#$7FFFFFFF,(a0,d0.w)
.x
	rts

CalcTeamStarScores					;Star scores of team a2 (a3 = other team) to (a4)+, one long per roster
									;slot. Each starts at the goal difference.
									;Skaters: goals*11000 + assists*10100 + shots*10, or in a tied game
									;shots*1000 + frames on ice. Goalies on ice at least d5 with shots
									;against: +32000 if goals against*100/shots <= 4, +75000 more for a
									;shutout.
									;95: the team stat arrays are 2 bytes on
	movea.w	a2,a1
	move.w	$C(a2),d3
	sub.w	$C(a3),d3
	ext.l	d3
	moveq	#$19,d4					;26 slots
	jsr	(GetGoalieCount).l
	neg.w	d0
	add.w	d4,d0
.loop
	move.l	d3,(a4)
	cmp.w	d0,d4
	bhi.w	.2
	clr.w	d1
	move.b	$B6(a2),d1
	mulu.w	#$2AF8,d1				;goals * 11000
	add.l	d1,(a4)
	clr.w	d1
	move.b	$D0(a2),d1
	mulu.w	#$2774,d1				;assists * 10100
	add.l	d1,(a4)
	clr.w	d1
	move.b	$EA(a2),d1
	mulu.w	#$A,d1
	tst.w	d3
	bne.w	.add
	mulu.w	#$64,d1					;tied: shots * 1000
	add.l	d1,(a4)
	clr.l	d1
	add.w	$138(a1),d1
.add
	add.l	d1,(a4)
	bra.w	.next
.2
	cmp.w	$138(a1),d5
	bhi.w	.next
	clr.w	d1
	move.b	$B6(a2),d1
	mulu.w	#$64,d1
	clr.w	d2
	move.b	$EA(a2),d2
	beq.w	.next
	divu.w	d2,d1
	cmp.w	#4,d1
	bhi.w	.next
	addi.l	#$7D00,(a4)				;32000
	tst.w	d1
	bne.w	.next
	addi.l	#$124F8,(a4)			;75000 for a shutout
.next
	addq.w	#2,a1
	addq.w	#1,a2
	addq.w	#4,a4
	dbf	d4,.loop
	rts

HighlightsScreen					;Season NHL HIGHLIGHTS screen: draw bg/title, joypad loop: left/right
									;change day, up/down change game (rosterscroll), Start exits
	movem.l	d0-d7/a0-a6,-(sp)
	jsr	(ReadSeasonHeader).l
	btst	#0,(sflags11).w
	bne.w	.0
	jsr	(SkipToGameDay).l
	btst	#3,(SeasonFlags).w
	bne.w	.done
.0
	jsr	(BuildSeasonTeamList).l
	move.b	(SeasonDay).w,(GamesTodayDay).w
	move.l	#ControllerBgMap,(screenarg).l
	bsr.w	GamesTodayGfx
	jsr	(printz).l
	String	-TXMAP2,$2,$6,$0
	movea.l	#HighlightsBgMap,a0
	movea.l	a0,a1
	movea.l	a0,a2
	adda.l	(a2)+,a0
	adda.l	(a2)+,a1
	clr.w	d0
	clr.w	d1
	move.w	(a1),d2
	move.w	2(a1),d3
	moveq	#0,d5
	jsr	(dobitmap).l
	jsr	(PrintHighlightsTitle).l
	jsr	(HighlightsHelp).l
	clr.w	(rosterscroll).w
	move.w	#$FFFF,(setupdir).w
	move.w	#$18,(palcount).w
	bclr	#dfng,(disflags).w
	bsr.w	DrawHighlightPage
.page
	cmpi.w	#$FFFF,(setupdir).w
	beq.w	.input
	bsr.w	DrawHighlightPage
.input
	bsr.w	ReadHighlightsPad
	move.w	(SelectedPlayerIdx).w,(setupprevline).w
	tst.w	d1
	bne.w	.keys
	move.b	(SeasonDay).w,d0
	cmp.b	(GamesTodayDay).w,d0
	beq.w	.3
	jsr	(ReadSeasonHeader).l
	jsr	(BuildSeasonTeamList).l
.3
	jmp	(Opening2).l
.keys
	move.w	#$FFFF,(setupdir).w
	btst	#7,d1
	bne.w	.start
	btst	#2,d1
	bne.w	.prevday
	btst	#3,d1
	bne.w	.nextday
	btst	#1,d1
	beq.w	.5
	bra.w	.down
.5
	btst	#0,d1
	beq.w	.6
	bra.w	.up
.6
	bra.s	.page
.nextday
	move.w	#$FFFF,(setupdir).w
	movem.w	d0,-(sp)
	move.b	(SeasonDay).w,d0
	cmp.b	(GamesTodayDay).w,d0
	movem.w	(sp)+,d0
	beq.w	.page
	move.w	#3,(setupdir).w
	addq.b	#1,(SeasonDay).w
	jsr	(DayHasGames).l
	beq.s	.nextday
	jsr	(BuildSeasonTeamList).l
	clr.w	(rosterscroll).w
	bra.w	.page
.prevday
	move.w	#$FFFF,(setupdir).w
	tst.b	(SeasonDay).w
	beq.w	.page
	move.w	#2,(setupdir).w
	jsr	(PrevSeasonDay).l
	jsr	(DayHasGames).l
	beq.s	.prevday
	jsr	(BuildSeasonTeamList).l
	clr.w	(rosterscroll).w
	bra.w	.page
.up
	move.w	#0,(setupdir).w
	tst.w	(rosterscroll).w
	bne.w	.10
	move.w	#$FFFF,(setupdir).w
	bra.w	.page
.10
	subq.w	#1,(rosterscroll).w
	bra.w	.page
.down
	move.w	#1,(setupdir).w
	movem.w	d0,-(sp)
	addq.w	#1,(rosterscroll).w
	move.w	(rosterscroll).w,d0
	cmp.b	(SeasonTeams+$1).w,d0
	movem.w	(sp)+,d0
	blt.w	.page
	subq.w	#1,(rosterscroll).w
	move.w	#$FFFF,(setupdir).w
	bra.w	.page
.start
	jsr	(forceblack).l
	move.b	(SeasonDay).w,d0
	cmp.b	(GamesTodayDay).w,d0
	beq.w	.done
	jsr	(ReadSeasonHeader).l
	jsr	(BuildSeasonTeamList).l
.done
	movem.l	(sp)+,d0-d7/a0-a6
	rts

ReadHighlightsPad					;Highlights joypad wait: each frame poll joypads (ReadJoy1-4 +
									;ProcessInputWithRepeat) until d1 != 0
	move.l	#$5460,d6
.wait
	move.w	#$64,d6
	move.w	(Vcount).w,d1
	sub.w	(OldVcount).w,d1
	beq.s	.wait
	move.w	(Vcount).w,(OldVcount).w
	jsr	(ReadJoy1).l
	jsr	(ProcessInputWithRepeat).l
	tst.w	d1
	beq.w	.1
	bra.w	.exit
.1
	jsr	(ReadJoy2).l
	jsr	(ProcessInputWithRepeat).l
	tst.w	d1
	beq.w	.2
	bra.w	.exit
.2
	tst.w	(FourWayPlay).w
	beq.w	.4
	jsr	(ReadJoy3).l
	jsr	(ProcessInputWithRepeat).l
	tst.w	d1
	beq.w	.3
	bra.w	.exit
.3
	jsr	(ReadJoy4).l
	jsr	(ProcessInputWithRepeat).l
	tst.w	d1
	beq.w	.4
	bra.w	.exit
.4
	dbf	d6,.wait
.exit
	rts

PrintHighlightsTitle				;print big title NHL HIGHLIGHTS
	jsr	(printbigz).l
	String	-(TXPRI+TXMAP1),$8,$2,'NHL HIGHLIGHTS',$0
	rts

DrawHighlightPage					;Draw the current highlight page: date, logos and score of game
									;rosterscroll, then its highlight (DrawHighlightEntry)
	movem.l	d0-d7/a0-a6,-(sp)
	move.w	(VisTeam).w,-(sp)
	move.w	(HomeTeam).w,-(sp)
	move.w	#$28,d0
	move.w	#$13,d1
	move.w	#$7FF,d2
	jsr	(printz).l
	String	-TXMAP1,$0,$6,$0
	jsr	(eraser).l
	movea.l	#SeasonTeams,a0
	clr.w	d1
	move.b	1(a0),d3
	beq.w	.0
	jsr	(printz).l
	String	-TXMAP1,$14,$7,$0
	movem.l	d0/a0-a1,-(sp)
	jsr	(MakeDateString).l
	movea.l	#StatWork,a1
	move.w	(a1),d0
	subq.w	#2,d0
	lsr.w	#1,d0
	sub.w	d0,(printx).w
	jsr	(print).l
	movem.l	(sp)+,d0/a0-a1
	move.w	(rosterscroll).w,d0
	mulu.w	#5,d0
	addq.w	#2,d0
	jsr	(printz).l
	String	-TXMAP1,$7,$A,$0
	clr.w	d1
	move.b	0(a0,d0.w),d1
	move.w	d1,(HomeTeam).w
	bsr.w	DrawHighlightLogo
	move.w	#7,(printx).w
	move.w	#$E,(printy).w
	clr.w	d1
	move.b	1(a0,d0.w),d1
	move.w	d1,(VisTeam).w
	bsr.w	DrawHighlightLogo
	bsr.w	PrintGameScore2
	bsr.w	DrawHighlightEntry
.0
	move.w	(sp)+,(HomeTeam).w
	move.w	(sp)+,(VisTeam).w
	movem.l	(sp)+,d0-d7/a0-a6
	rts

DrawHighlightEntry					;Read the highlight record of the game (GetHighlightSlot) to StatBuf and
									;print it (PrintHighlight)
	movem.l	d0-d7/a0-a6,-(sp)
	bsr.w	GetHighlightSlot
	moveq	#4,d1
	movea.l	#StatBuf,a0
	jsr	(ReadSRAM).l
	jsr	(printz).l
	String	-TXMAP1,$14,$13,$0
	bsr.w	PrintHighlight
	movem.l	(sp)+,d0-d7/a0-a6
	rts

PrintRecordHighlight				;Print a type 4 highlight record: team name and its W-L-T record from
									;SRStandings, centered
	move.l	a0,-(sp)
	jsr	(printz).l
	String	-TXMAP1,$14,$13,$0
	move.w	(a0),d0
	andi.w	#$FFF,d0
	move.w	d0,-(sp)
	mulu.w	#3,d0
	addi.l	#SRStandings,d0
	movea.l	#StatWork,a0
	moveq	#3,d1
	jsr	(ReadSRAM).l
	move.w	(sp)+,d0
	asl.w	#2,d0
	movea.l	#TeamList,a0
	movea.l	0(a0,d0.w),a0
	adda.w	4(a0),a0
	move.w	(a0),d0
	movea.l	#mesarea,a1
	bra.w	.1
.loop
	move.b	(a0)+,(a1)+
.1
	dbf	d0,.loop
	movea.l	#mesarea,a3
	jsr	(appendz).l
	String	' ',$0
	clr.w	d0
	move.b	(StatWork).w,d0
	bsr.w	AppendNumber
	jsr	(appendz).l
	String	'-',$0
	clr.w	d0
	move.b	(StatWork+2).w,d0
	bsr.w	AppendNumber
	jsr	(appendz).l
	String	'-',$0
	clr.w	d0
	move.b	(StatWork+$1).w,d0
	bsr.w	AppendNumber
	movea.l	#mesarea,a3
	move.w	(a3),d0
	subq.w	#2,d0
	lsr.w	#1,d0
	sub.w	d0,(printx).w
	movea.l	a3,a1
	jsr	(print).l
	movea.l	(sp)+,a0
	rts

AppendNumber						;Append number d0 (1 or 2 digits) to string at mesarea
	movea.l	#mesarea,a3
	move.w	#2,d1
	cmp.w	#9,d0
	bgt.w	.0
	move.w	#1,d1
.0
	jsr	(PushNumberWidth).l
	jsr	(appstring).l
	movea.l	#mesarea,a3
	rts

PrintHighlight						;Print highlight record a0: type (bits 13-15) 0 none, 4 team record, else
									;player name + count + GOAL(S)/ASSIST(S)/SAVE(S)
	movem.l	d0-d7/a0-a6,-(sp)
	clr.l	d0
	move.w	(a0),d0
	lsr.w	#8,d0
	lsr.w	#5,d0
	tst.w	d0
	beq.w	.2
	cmp.w	#4,d0
	bne.w	.0
	bsr.w	PrintRecordHighlight
	bra.w	.2
.0
	move.w	(a0),d0
	move.l	a0,-(sp)
	andi.w	#$1FFF,d0
	jsr	(FormatLastNameAlt).l
	movea.l	a1,a3
	movea.l	(sp)+,a0
	move.w	2(a0),d0
	move.w	#3,d1
	jsr	(PushNumberWidth).l
	move.l	a3,-(sp)
	jsr	(appstring).l
	movea.l	(sp)+,a3
	move.w	(a0),d0
	lsr.w	#8,d0
	lsr.w	#5,d0
	asl.w	#2,d0
	movea.l	#HighlightPlurals,a6
	cmpi.w	#1,2(a0)
	bne.w	.1
	movea.l	#HighlightSingulars,a6
.1
	movea.l	0(a6,d0.w),a1
	move.l	a3,-(sp)
	jsr	(appstring).l
	movea.l	(sp)+,a3
	move.w	(a3),d0
	subq.w	#2,d0
	lsr.w	#1,d0
	sub.w	d0,(printx).w
	movea.l	a3,a1
	jsr	(print).l
.2
	movem.l	(sp)+,d0-d7/a0-a6
	rts

HighlightPlurals					;Plural suffix pointers by record type
	dc.l	0,GoalsText,AssistsText,SavesText

HighlightSingulars					;Singular suffix pointers by record type
	dc.l	0,GoalText,AssistText,SaveText

AssistsText
	String	' ASSISTS'

AssistText
	String	' ASSIST',$0

SavesText
	String	' SAVES'

SaveText
	String	' SAVE',$0

GoalsText
	String	' GOALS'

GoalText
	String	' GOAL',$0

PrintGameScore2						;print the game's score (bytes 2/3 of game record a0+d0) or ".......LATER"
									;if not yet played
	movem.l	d0-d7/a0-a6,-(sp)
	btst	#1,4(a0,d0.w)
	bne.w	.0
	jsr	(printz).l
	String	-TXMAP1,$13,$E,'.......LATER',$0
	bra.w	.1
.0
	clr.w	d5
	move.b	2(a0,d0.w),d5
	move.w	#$19,(printx).w
	move.w	#$A,(printy).w
	bsr.w	PrintScore2
	move.b	3(a0,d0.w),d5
	move.w	#$19,(printx).w
	move.w	#$E,(printy).w
	bsr.w	PrintScore2
.1
	movem.l	(sp)+,d0-d7/a0-a6
	rts

PrintScore2							;print 2-digit number d5 at current cursor (PushNumberWidth + printbig)
	movem.l	d0-d7/a0-a6,-(sp)
	move.w	d5,d0
	moveq	#2,d1
	jsr	(PushNumberWidth).l
	jsr	(printbig).l
	movem.l	(sp)+,d0-d7/a0-a6
	rts

DrawHighlightLogo					;Draw team logo d1 (from Teamblocksmap graphics, palette teamblocksmapptr)
									;via dobitmap
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

GetHighlightSlot					;d0 = save RAM offset (SRHighlights + 4 a game) of the highlight slot of
									;HomeTeam's game today, -1 none
	movem.l	d1-d7/a0-a6,-(sp)
	clr.w	d1
	move.b	(SeasonDay).w,d1
	clr.w	d2
	move.b	(SeasonStartDay).w,d2
	movea.l	#SeasonSchedule,a6
	clr.w	d5
	move.b	(a6)+,d5
	add.w	d2,d1
	cmp.w	d5,d1
	blt.w	.0
	sub.w	d5,d1
.0
	move.l	#SRHighlights,d0
	bra.w	.next
.day
	clr.l	d3
	move.b	(a6)+,d3
	move.w	d3,d4
	add.w	d4,d4
	adda.w	d4,a6
	asl.w	#2,d3
	add.l	d3,d0
.next
	dbf	d1,.day
	move.b	(a6)+,d3
.game
	move.b	(a6),d4
	cmp.b	(HomeTeam+1).w,d4
	beq.w	.done
	addq.l	#4,d0
	addq.l	#2,a6
	dbf	d3,.game
	move.w	#$FFFF,d0
	bra.w	.done
.done
	movem.l	(sp)+,d1-d7/a0-a6
	rts

HighlightsHelp						;HighlightsScreen help line: {} More games, [] Change day (called from
									;HighlightsScreen)
	movem.l	d0-d7/a0-a6,-(sp)
	move.w	(smallfontchars).w,-(sp)
	move.w	(smallfont2chars).w,(smallfontchars).w
	jsr	(printz).l
	String	-TXMAP1,2,$19,'{} More games',-TXMAP1,$19,$19,'[] Change day'
	move.w	(sp)+,(smallfontchars).w
	movem.l	(sp)+,d0-d7/a0-a6
	rts
