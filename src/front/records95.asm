;	User records. This file runs the name entry screen and the name log, shows Record Holders and
;	the playoff stats, and updates the saved records after each game.

;-------------------------------------------------------------------------------------------------------------
;	The user name entry screen.



	include	macros\genesis.mac		;String

NameEntryScreen						;Name Entry screen: draw team logo, NAME ENTRY title and Name Log, then
									;edit the name with the pad (NameEntryScreen)
	movem.l	d0-d7/a0-a6,-(sp)
	move.l	a5,-(sp)
	bset	#1,(BA_PS_flags).w
	jsr	(CreateRatingsGfx).l
	move.w	d4,(homepicchars).w
	addi.w	#$24,d4
	move.w	d4,(BigFontchars).w
	movea.l	#BigFontMap2+8,a2
	jsr	(DecompressGraphicsPlain).l
	move.w	d4,(spritechars).w
	movea.l	#NameEntryBgMap+8,a2
	jsr	(DecompressGraphicsPlain).l
	move.w	#$18,(palcount).w
	bclr	#dfng,(disflags).w
	jsr	(printz).l
	String	-(TXPRI+TXPAL3+TXMAP1),$1B,$8,$0
	move.w	(HomeTeam).w,d3
	tst.w	(nameentryvis).w
	beq.w	.0
	move.w	(VisTeam).w,d3
.0
	asl.w	#2,d3
	movea.l	#TeamLogoBitmaps,a0		;team logo maps
	movea.l	(a0,d3.w),a0
	movea.l	a0,a1
	movea.l	a0,a2
	adda.l	(a2)+,a0
	asl.w	#3,d3
	movea.l	#TeamLogoPalettes,a0
	subi.w	#$40,d3
	adda.w	d3,a0
	adda.l	(a2)+,a1
	move.w	#6,d3
	move.w	#6,d2
	clr.w	d0
	clr.w	d1
	move.w	#4,d5
	move.w	(homepicchars).w,d4
	jsr	(dobitmap).l
	jsr	(printz).l
	String	-(TXPRI+TXMAP1),$1E,$6,$0
	move.w	(HomeTeam).w,d0
	tst.w	(nameentryvis).w
	beq.w	.1
	move.w	(VisTeam).w,d0
.1
	movea.l	#TeamList,a1
	asl.w	#2,d0
	movea.l	(a1,d0.w),a1
	adda.w	4(a1),a1
	move.w	(a1),d0
	subq.w	#2,d0
	lsr.w	#1,d0
	sub.w	d0,(printx).w
	jsr	(printsmall).l
	jsr	(printbigz).l
	String	-(TXPRI+TXMAP1),$A,$2,'NAME   ENTRY',$0
	movea.l	(sp)+,a5
	bsr.w	ReadNameLog
	clr.w	(namelogarrows).w
	move.w	#1,(namelogsel).w
	clr.w	d0
	bsr.w	NameInUse
	movea.l	#NameEntryBuf,a1
	bsr.w	GetLogName
	bsr.w	PrintNameLog
	jsr	(printz).l
	String	-(TXPRI+TXMAP1),$C,$6,'Name Log',$0
	clr.w	d4
	bsr.w	SyncLetterCursor
	bsr.w	PrintNameCursor
	bsr.w	LetterGridPos
	move.w	(printx).w,-(sp)
	move.w	(printy).w,-(sp)
	jsr	(NameEntryFramer).l
.2
	move.w	(sp)+,(printy).w
	addq.w	#1,(printy).w
	move.w	(sp)+,(printx).w
	addq.w	#1,(printx).w
	bsr.w	PrintCurLetter
	move.w	#1,(NameEntryMode).w
	bsr.w	NameLetterGrid
	clr.w	d0
	bra.w	.18
.loop
	bsr.w	GetNameLength
	jsr	(printz).l
	String	-(TXPRI+TXMAP1),$A,$7,$0
	move.w	(namelogsel).w,d0
	add.w	d0,(printy).w
	tst.w	(NameEntryMode).w
	beq.w	.4
	movea.l	#NameEntryBuf,a1
	bsr.w	PrintNameField
	bsr.w	PrintNamePrompt
.4
	bsr.w	MoveLogArrows
.loop2
	move.w	(Vcount).w,d0
.loop3
	cmp.w	(Vcount).w,d0
	beq.s	.loop3
	cmpa.l	#pad1user,a5
	beq.w	.input
	cmpa.l	#pad2user,a5
	beq.w	.8
	cmpa.l	#pad3user,a5
	beq.w	.7
	jsr	(ReadJoy4).l
	tst.w	d1
	beq.s	.loop2
	bra.w	.10
.7
	jsr	(ReadJoy3).l
	tst.w	d1
	beq.s	.loop2
	bra.w	.10
.8
	jsr	(ReadJoy2).l
	tst.w	d1
	beq.s	.loop2
	bra.w	.10
.input
	jsr	(ReadJoy1).l
	tst.w	d1
	beq.s	.loop2
.10
	btst	#7,d1
	bne.w	.nameEntryExit
	tst.w	(NameEntryMode).w
	bne.w	.11
	move.w	#1,d0
	btst	#1,d1
	bne.w	.13
	move.w	#$FFFF,d0
	btst	#0,d1
	bne.w	.13
	btst	#4,d1
	beq.w	.loop
	bsr.w	NameLetterGrid
	clr.w	d0
	bra.w	.13
.11
	moveq	#$FFFFFFFF,d0
	btst	#6,d1
	bne.w	.18
	neg.w	d0
	btst	#5,d1
	bne.w	.18
	btst	#3,d1
	bne.w	.19
	neg.w	d0
	btst	#2,d1
	bne.w	.19
	moveq	#6,d0
	btst	#1,d1
	bne.w	.19
	neg.w	d0
	btst	#0,d1
	bne.w	.19
	btst	#4,d1
	beq.w	.loop
	bsr.w	NameLetterGrid
	tst.w	(NameEntryMode).w
	bne.w	.12
	bsr.w	PrintNameLog
.12
	bra.w	.loop
.13
	add.w	d0,(namelogsel).w
.loop4
	cmpi.w	#7,(namelogsel).w
	ble.w	.15
	move.w	#1,(namelogsel).w
.15
	tst.w	(namelogsel).w
	bne.w	.16
	move.w	#7,(namelogsel).w
.16
	bsr.w	NameInUse
	beq.s	.loop4
	movea.l	#NameEntryBuf,a1
	bsr.w	GetLogName
	tst.w	(NameEntryMode).w
	bne.w	.17
	jsr	(NameEntryHelp).l
	bra.w	.loop
.17
	jsr	(printz).l
	String	-(TXPRI+TXMAP1),$4,$13,$0
	add.w	d4,(printx).w
	jsr	(printz).l
	String	'   ',$0
	bsr.w	LetterGridPos
	moveq	#1,d2
	move.w	(printx).w,-(sp)
	move.w	(printy).w,-(sp)
	jsr	(eraser).l
	move.w	(sp)+,(printy).w
	addq.w	#1,(printy).w
	move.w	(sp)+,(printx).w
	addq.w	#1,(printx).w
	bsr.w	PrintCurLetter
	bsr.w	SyncLetterCursor
	move.w	d4,d0
	neg.w	d0
	bra.w	.18
.18
	add.w	d4,d0
	cmp.w	#$B,d0
	bhi.w	.loop
	move.w	d0,d4
	bsr.w	PrintNameCursor
	movea.l	#NameEntryBuf,a0
	clr.w	d0
	cmpi.b	#$2D,(a0,d4.w)
	beq.w	.19
	move.b	(a0,d4.w),d0
	ext.w	d0
	bsr.w	FindLetter
	sub.w	d5,d0
.19
	add.w	d5,d0
	cmp.w	#$1D,d0
	bhi.w	.loop
	move.w	d0,-(sp)
	bsr.w	LetterGridPos
	moveq	#1,d2
	move.w	(printx).w,-(sp)
	move.w	(printy).w,-(sp)
	jsr	(eraser).l
	move.w	(sp)+,(printy).w
	addq.w	#1,(printy).w
	move.w	(sp)+,(printx).w
	addq.w	#1,(printx).w
	bsr.w	PrintCurLetter
	move.w	(sp)+,d5
	bsr.w	LetterGridPos
	move.w	(printx).w,-(sp)
	move.w	(printy).w,-(sp)
	tst.w	(NameEntryMode).w
	beq.w	.20
	jsr	(NameEntryFramer).l
.20
	move.w	(sp)+,(printy).w
	addq.w	#1,(printy).w
	move.w	(sp)+,(printx).w
	addq.w	#1,(printx).w
	bsr.w	PrintCurLetter
	movea.l	#NameEntryBuf,a0
	movea.l	#LetterGrid,a1
	move.b	(a1,d5.w),d0
	move.b	d0,(a0,d4.w)
	bra.w	.loop

.nameEntryExit						;NameEntryScreen exit (restore and return)
	bsr.w	StoreUserName
	movem.l	(sp)+,d0-d7/a0-a6
	rts

NameLetterGrid						;Name entry: letter grid and its key help (NameLetterGrid); on the second
									;call the name log help (NameEntryHelp)
	movem.l	d0-d7/a0-a6,-(sp)
	jsr	(printz).l
	String	-(TXPRI+TXMAP1),$18,$12,$0
	move.w	#$16,d0
	move.w	#7,d1
	move.w	#$7FF,d2
	jsr	(eraser).l
	bchg	#0,(NameEntryMode+1).w
	bne.w	.3
	jsr	(printz).l
	String	-(TXPRI+TXMAP1),$A,$11,$0
	movea.l	#LetterGrid,a0
	moveq	#4,d0
.loop
	moveq	#5,d1
	movea.l	#mesarea,a1
	move.w	#$E,(a1)+
.loop2
	move.b	(a0)+,(a1)+
	move.b	#$20,(a1)+
	dbf	d1,.loop2
	movea.w	#(mesarea-M68K_RAM),a1
	jsr	(printsmall).l
	addq.w	#2,(printy).w
	subi.w	#$C,(printx).w
	dbf	d0,.loop
	jsr	(ClearNameHelp).l
	jsr	(printz).l
	String	-(TXPRI+TXMAP1),$18,$11,$0
	jsr	(printsmallz).l
	dc.w	$44						;String length
	dc.b	'{}[]',$FA,$1,$FD,$18,'=Select letter',$FA,$2
	dc.b	$FD,$18,'C=Enter letter',$FA,$2,$FD,$18,'A=Go back'
	dc.b	$FA,$2,$FD,$18,'B=Cancel',$0
.x
	movem.l	(sp)+,d0-d7/a0-a6
	rts
.3
	movea.l	#NameEntryBuf,a1
	bsr.w	GetLogName
	move.w	#0,(printx).w
	move.w	#$F,(printy).w
	move.w	#$28,d0
	move.w	#$D,d1
	move.w	#$7FF,d2
	jsr	(eraser).l
.4
	jsr	(printz).l
	String	-TXMAP2,$18,$12,$0
	moveq	#$16,d0
	moveq	#7,d1
	bsr.w	NameEntryHelp
	bra.s	.x

NameEntryHelp						;Name entry: name log key help text (NameEntryHelp)
	movem.l	d0-d7/a0-a6,-(sp)
	jsr	(ClearNameHelp).l
	jsr	(printz).l
	String	-(TXPRI+TXMAP1),$18,$11,$0
	jsr	(printsmallz).l
	dc.w	$42						;String length
	dc.b	'{}=Select',$FA,$1,$FD,$1B,'name',$FA,$2
	dc.b	$FD,$19,'B=Enter/edit',$FA,$1,$FD,$1B,'name'
	dc.b	$FA,$2,$FD,$19,'START',$FA,$1,$FD
	dc.b	$1A,'=Use name',$0
	movem.l	(sp)+,d0-d7/a0-a6
	rts

PrintNamePrompt						;Name entry: print "Enter new name." for an empty name log slot
									;namelogsel, else "Select or replace." (PrintNamePrompt)
	movem.l	d0-d7/a0-a6,-(sp)
	move.w	(namelogsel).w,d0
	mulu.w	#$C,d0
	movea.l	#namelog,a0
	movea.l	#EnterNameTxt,a1
	tst.b	(a0,d0.w)
	beq.w	.1
.0
	movea.l	#SelectNameTxt,a1
.1
	jsr	(print).l
	movem.l	(sp)+,d0-d7/a0-a6
	rts

SyncLetterCursor					;Name entry: grid cursor d5 = grid index of the current letter
									;(FindLetter), 0 if not in the grid (SyncLetterCursor)
	movem.l	d0-d4/a0-a6,-(sp)
	move.b	(NameEntryBuf).w,d0
	bsr.w	FindLetter
	cmp.w	#$1E,d0
	blt.w	.1
	clr.w	d5
.0
	bra.w	.x
.1
	move.w	d0,d5
	movea.l	#LetterGrid,a0
	move.b	(a0,d5.w),(NameEntryBuf).w
.x
	movem.l	(sp)+,d0-d4/a0-a6
	rts

FindLetter							;d0 = index of letter d0 in the letter grid, $1E when not found
									;(FindLetter)
	movem.l	d1-d3/a0-a6,-(sp)
	movea.l	#LetterGrid,a0
	move.b	d0,d1
	clr.w	d0
	move.w	#$1E,d3
.0
	cmp.b	(a0,d0.w),d1
	beq.w	.x
	addq.w	#1,d0
	dbf	d3,.0
	move.w	#$1E,d0
.x
	movem.l	(sp)+,d1-d3/a0-a6
	rts

PrintNameCursor						;Name entry: position the name cursor (95 prints no " < ";
									;PrintNameCursor)
	jsr	(printz).l
	String	-(TXPRI+TXMAP1),5,$12,$0
	add.w	d4,(printx).w
	tst.w	(NameEntryMode).w
	beq.w	rtsNameCursor

rtsNameCursor						;Shared rts of PrintNameCursor
	rts

PrintCurLetter						;Name entry: print grid letter d5 when the cursor is on (PrintCurLetter)
	tst.w	(NameEntryMode).w
	beq.s	rtsNameCursor
	movea.l	#ThreeStars,a1
	move.w	#4,(a1)
	move.b	#0,3(a1)
	movea.l	#LetterGrid,a0
	move.b	(a0,d5.w),d0
	move.b	d0,2(a1)
	jmp	(printsmall).l

LetterGridPos						;Name entry: printx/printy of grid letter d5 (6 a row, 2 cells apart),
									;d0/d1 = 3x3 box
	jsr	(printz).l
	String	-(TXPRI+TXMAP1),9,$10,$0
	move.w	d5,d0
	ext.l	d0
	divu.w	#6,d0
	asl.w	#1,d0
	add.w	d0,(printy).w
	swap	d0
	asl.w	#1,d0
	add.w	d0,(printx).w
	moveq	#3,d0
	moveq	#3,d1
	rts

EnterNameTxt						;Name entry prompt for an empty name log slot (EnterNameTxt)
	String	$BF,6,$F,'  Enter new name. ',$0

SelectNameTxt						;Name entry prompt for a used name log slot (SelectNameTxt)
	String	$BF,6,$F,'Select or replace.',$0

PrintNameLog						;Name entry: print the 7-row name log list (PrintNameLog)
	movem.l	d0-d7/a0-a6,-(sp)
	move.w	(NameEntryLen).w,-(sp)
	move.w	(namelogsel).w,-(sp)
	jsr	(printz).l
	String	-(TXPRI+TXMAP1),$A,8,$0
	move.w	#6,d7
	move.w	#1,(namelogsel).w
	movea.l	#linemarkbuf,a1
.loop
	bsr.w	GetLogName
	move.w	(printx).w,-(sp)
	bsr.w	PrintNameField
	move.w	(sp)+,(printx).w
	addq.w	#1,(printy).w
	addq.w	#1,(namelogsel).w
	dbf	d7,.loop
	move.w	(sp)+,(namelogsel).w
	move.w	(sp)+,(NameEntryLen).w
	movem.l	(sp)+,d0-d7/a0-a6
	rts

MoveLogArrows						;Name entry: move the ] [ arrows when the name log selection changed
									;(MoveLogArrows)
	movem.l	d0-d7/a0-a6,-(sp)
	move.w	(namelogsel).w,d0
	cmp.w	(namelogarrows).w,d0
	beq.w	.x
	movea.l	#LogArrowsClrTxt,a1
	bsr.w	PrintLogArrows
	movea.l	#LogArrowsTxt,a1
	bsr.w	PrintLogArrows
.x
	movem.l	(sp)+,d0-d7/a0-a6
	rts

PrintLogArrows						;Name entry: print the two arrow Strings at a1 on name log row
									;namelogarrows, then namelogarrows = selection (PrintLogArrows)
	tst.w	(namelogarrows).w
	beq.w	.0
	jsr	(printz).l
	String	-(TXPRI+TXMAP1),8,8,$0
	move.w	(namelogarrows).w,d0
	subq.w	#1,d0
	add.w	d0,(printy).w
	move.l	a1,-(sp)
	jsr	(printsmall).l
	movea.l	(sp)+,a1
	adda.w	(a1),a1
	move.w	#$17,(printx).w
	jsr	(printsmall).l
.0
	move.w	(namelogsel).w,(namelogarrows).w
	rts

LogArrowsTxt						;Name log arrows "]" and "[" (LogArrowsTxt)
	String	']',$0
	String	'[',$0

LogArrowsClrTxt						;Blanks that erase the name log arrows (LogArrowsClrTxt)
	String	' ',$0
	String	' ',$0

GetNameLength						;Name entry: NameEntryLen = length of the name in the entry buffer
									;(GetNameLength)
	movem.l	d0-d7/a0-a6,-(sp)
	move.w	#$B,d3
	movea.l	#NameEntryBuf,a0
	clr.w	(NameEntryLen).w
.loop
	cmpi.b	#$2D,(a0)
	beq.w	.x
	tst.b	(a0)+
	beq.w	.x
	addq.w	#1,(NameEntryLen).w
	dbf	d3,.loop
.x
	movem.l	(sp)+,d0-d7/a0-a6
	rts

PrintNameField						;Name entry: print the 12-char name field at a1 ("-" pads) and the current
									;letter when the cursor is on (PrintNameField)
	movem.l	d0-d7/a0-a6,-(sp)
	movea.l	#ThreeStars,a0
	move.w	(NameEntryLen).w,d0
	move.w	#0,d3
	move.w	#$E,(a0)+
.0
	move.b	(a1,d3.w),d1
	cmp.w	(NameEntryLen).w,d3
	blt.w	.1
	move.b	#$2D,d1
.1
	move.b	d1,(a0)+
	addq.w	#1,d3
	cmp.w	#$C,d3
	blt.s	.0
	movea.l	#ThreeStars,a1
	move.w	(printx).w,-(sp)
	jsr	(printsmall).l
	move.w	(sp)+,(printx).w
	add.w	d4,(printx).w
	tst.w	(NameEntryMode).w
	beq.w	.3
	movem.l	a0-a1,-(sp)
	movea.l	#NameEntryBuf,a0
	movea.l	#M68K_RAM,a1
	move.w	#4,(a1)
	move.b	(a0,d4.w),2(a1)
	move.b	#0,3(a1)
	jsr	(printsmallz).l
	String	CC_SetFont,1
	cmpi.b	#$20,2(a1)
	bne.w	.2
	jsr	(printsmallz).l
	String	CC_SetFont,3
.2
	jsr	(printsmall).l
	jsr	(printsmallz).l
	String	CC_SetFont,0
	movem.l	(sp)+,a0-a1
.3
	movem.l	(sp)+,d0-d7/a0-a6
	rts

LetterGrid							;Name entry letter grid, 5 rows of 6, $FF end (LetterGrid)
	dc.b	'ABCDEFGHIJKLMNOPQRSTUVWXYZ.12  ',$FF

GetLogName							;Copy name log entry namelogsel to a1 ("-" for blanks), NameEntryLen = its
									;length (GetLogName)
	movem.l	d0-d7/a0-a6,-(sp)
	movea.l	#namelog,a0
	move.w	(namelogsel).w,d2
	mulu.w	#$C,d2
	move.w	#0,(NameEntryLen).w
	move.w	#$B,d3
.0
	move.b	(a0,d2.w),d0
	beq.w	.1
	bra.w	.2
.1
	move.b	#$2D,d0
	subq.w	#1,(NameEntryLen).w
.2
	move.b	d0,(a1)+
	addq.w	#1,(NameEntryLen).w
	addq.w	#1,d2
	dbf	d3,.0
	movem.l	(sp)+,d0-d7/a0-a6
	rts

StoreUserName						;Name entry: store the edited name in the name log slot; if changed, save
									;and clear its old records (StoreUserName)
	movem.l	d0-d7/a0-a6,-(sp)
	move.l	a5,-(sp)
	movea.l	#namelog,a0
	move.w	(namelogsel).w,d0
	mulu.w	#$C,d0
	adda.w	d0,a0
	movea.l	#NameEntryBuf,a1
	move.w	#$B,d4
.loop
	cmpi.b	#$2D,(a1)
	bne.w	.1
	move.b	#0,(a1)
.1
	move.b	(a1)+,d1
	cmp.b	(a0)+,d1
	bne.w	.2
	dbf	d4,.loop
	bra.w	.5
.2
	movea.l	#namelog,a0
	move.w	(namelogsel).w,d0
	mulu.w	#$C,d0
	adda.w	d0,a0
	movea.l	#NameEntryBuf,a1
	move.w	#$B,d4
.loop2
	move.b	(a1)+,d1
	cmp.b	#$2D,d1
	bne.w	.4
	move.b	#0,d1
.4
	move.b	d1,(a0)+
	dbf	d4,.loop2
	bsr.w	WriteNameLog
	jsr	(WriteNameRecord).l
	jsr	(MakeSRAMChecksum).l
.5
	movea.l	(sp)+,a5
	tst.b	(NameEntryBuf).w
	bne.w	.6
	clr.w	(namelogsel).w
.6
	move.w	(namelogsel).w,(a5)
	movem.l	(sp)+,d0-d7/a0-a6
	rts

WriteNameRecord						;Clear name slot namelogsel from every saved record (read ReadSRAM, write
									;WriteSRAM), zero its 16-byte entry at $D22, then MakeSRAMChecksum
	movem.l	d0-d7/a0-a6,-(sp)
	move.w	#$2D7,d7
	moveq	#2,d0
	moveq	#4,d1
	movea.l	#ThreeStars,a0
	move.w	(namelogsel).w,d6
.0
	clr.w	d5
	jsr	(ReadSRAM).l
	cmp.b	1(a0),d6
	bne.w	.1
	clr.b	1(a0)
	st	d5
.1
	cmp.b	3(a0),d6
	bne.w	.2
	clr.b	3(a0)
	st	d5
.2
	tst.w	d5
	beq.w	.3
	jsr	(WriteSRAM).l
.3
	addq.l	#4,d0
	dbf	d7,.0
	move.w	#NumTeams-1,d7
	move.l	#SRCrowdRecords,d0
	moveq	#$10,d1
	movea.l	#ThreeStars,a0
	move.w	(namelogsel).w,d6
.4
	clr.w	d5
	jsr	(ReadSRAM).l
	cmp.b	1(a0),d6
	bne.w	.5
	clr.b	1(a0)
	st	d5
.5
	cmp.b	3(a0),d6
	bne.w	.6
	clr.b	3(a0)
	st	d5
.6
	cmp.b	5(a0),d6
	bne.w	.7
	clr.b	5(a0)
	st	d5
.7
	cmp.b	7(a0),d6
	bne.w	.8
	clr.b	7(a0)
	st	d5
.8
	cmp.b	9(a0),d6
	bne.w	.9
	clr.b	9(a0)
	st	d5
.9
	cmp.b	$B(a0),d6
	bne.w	.10
	clr.b	$B(a0)
	st	d5
.10
	tst.w	d5
	beq.w	.11
	jsr	(WriteSRAM).l
.11
	addi.l	#$10,d0
	dbf	d7,.4
	move.l	#SRTeamRecords,d0
	move.w	(namelogsel).w,d3
	asl.w	#4,d3
	ext.l	d3
	add.l	d3,d0
	moveq	#$10,d1
	movea.l	#ThreeStars,a0
	jsr	(ReadSRAM).l
	move.l	a0,-(sp)
	move.w	#$F,d3
.loop3
	clr.b	(a0)+
	dbf	d3,.loop3
	movea.l	(sp)+,a0
	jsr	(WriteSRAM).l
	jsr	(MakeSRAMChecksum).l
	movem.l	(sp)+,d0-d7/a0-a6
	rts

;-------------------------------------------------------------------------------------------------------------
;	User name entry for each pad, the name log, and the records screens.



UserNameEntry						;With user records on (OptUserRec 0): the name entry (NameEntryScreen) for
									;each pad in use (UserNameEntry)
									;then sflags11 bit 7 when no team has more than one pad
	bclr	#7,(sflags11).w
	tst.w	(OptUserRec).w
	bne.w	.x
	clr.w	(pad1user).w
	clr.w	(pad2user).w
	clr.w	(pad3user).w
	clr.w	(pad4user).w
	tst.w	(cont1team).w
	beq.w	.0
	move.w	(cont1team).w,(nameentryvis).w
	subq.w	#1,(nameentryvis).w
	movea.l	#pad1user,a5
	jsr	(NameEntryScreen).l
.0
	tst.w	(cont2team).w
	beq.w	.1
	move.w	(cont2team).w,(nameentryvis).w
	subq.w	#1,(nameentryvis).w
	movea.l	#pad2user,a5
	jsr	(NameEntryScreen).l
.1
	tst.w	(cont3team).w
	beq.w	.2
	move.w	(cont3team).w,(nameentryvis).w
	subq.w	#1,(nameentryvis).w
	movea.l	#pad3user,a5
	jsr	(NameEntryScreen).l
.2
	tst.w	(cont4team).w
	beq.w	.3
	move.w	(cont4team).w,(nameentryvis).w
	subq.w	#1,(nameentryvis).w
	movea.l	#pad4user,a5
	jsr	(NameEntryScreen).l
.3
	bset	#7,(sflags11).w
	move.w	#1,d0
	bsr.w	CountTeamPads
	cmp.w	#1,d2
	ble.w	.4
	bclr	#7,(sflags11).w
.4
	move.w	#2,d0
	bsr.w	CountTeamPads
	cmp.w	#1,d2
	ble.w	.x
	bclr	#7,(sflags11).w
.x
	rts
CountTeamPads						;d2 = the number of pads (cont1team ... cont4team) on team d0 (1 home, 2
									;away)
	clr.w	d2
	cmp.w	(cont1team).w,d0
	bne.w	.0
	addq.w	#1,d2
.0
	cmp.w	(cont2team).w,d0
	bne.w	.1
	addq.w	#1,d2
.1
	cmp.w	(cont3team).w,d0
	bne.w	.2
	addq.w	#1,d2
.2
	cmp.w	(cont4team).w,d0
	bne.w	.x
	addq.w	#1,d2
.x
	rts
NameInUse							;Step the name log selection (namelogsel) past the names the other pads
									;(pad1user ... pad4user, not a5) picked
									;in direction d0; Z set (d2 0) when it moved
	movem.l	d1-d2/a0,-(sp)
	move.w	#1,d2
	movea.l	#pad1user,a0
	bsr.w	SkipPadName
	movea.l	#pad2user,a0
	bsr.w	SkipPadName
	movea.l	#pad3user,a0
	bsr.w	SkipPadName
	movea.l	#pad4user,a0
	bsr.w	SkipPadName
	tst.w	d2
	movem.l	(sp)+,d1-d2/a0
	rts
SkipPadName							;When pad slot a0 is not a5 and holds the selected name (namelogsel), step
									;past it (SkipOtherUserName)
	cmpa.l	a5,a0
	beq.w	.x
	move.w	(a0),d1
	cmp.w	(namelogsel).w,d1
	bne.w	.x
	bsr.w	SkipOtherUserName
.x
	rts
SkipOtherUserName					;Step the name log selection (namelogsel) by 1 in direction d0, wrapping
									;1-7; d2 = 0
	move.w	#1,d1
	tst.w	d0
	bpl.w	.0
	move.w	#$FFFF,d1
.0
	add.w	d1,(namelogsel).w
	cmpi.w	#7,(namelogsel).w
	ble.w	.1
	move.w	#1,(namelogsel).w
.1
	tst.w	(namelogsel).w
	bne.w	.2
	move.w	#7,(namelogsel).w
.2
	clr.w	d2
	rts
WriteNameLog						;Write the user name log ($80 bytes at namelog) to save RAM SRNameLog
	bset	#6,(sflags6).w
	bra.w	NameLogIO
ReadNameLog							;Read the user name log from save RAM SRNameLog to namelog
	bclr	#6,(sflags6).w
NameLogIO							;Read or write (sflags6 bit 6) the name log
	movem.l	d0-d7/a0-a6,-(sp)
	move.l	#$80,d1
	move.l	#SRNameLog,d0
	movea.l	#namelog,a0
	btst	#6,(sflags6).w
	beq.w	.read
	jsr	(WriteSRAM).l
	bra.w	.x
.read
	jsr	(ReadSRAM).l
.x
	movem.l	(sp)+,d0-d7/a0-a6
	rts
ClearNameHelp						;Name entry: erase the help text area ($16 x 8 at 24,17)
	movem.l	d0-d7/a0-a6,-(sp)
	jsr	(printz).l
	String	-(TXPRI+TXMAP1),$18,$11,$0
	moveq	#$16,d0
	moveq	#8,d1
	move.w	#$7FF,d2
	jsr	(eraser).l
	movem.l	(sp)+,d0-d7/a0-a6
	rts
PlayoffStatsScreen					;Pause menu PLAYOFF STATS: the playoff stats (PlayerStatsList, d7 1) of
									;the team in the playoff tree slot potreeteam (home or away team struct)
	movem.l	a2,-(sp)
	jsr	(ReadTeamStats).l
	movea.l	#potree,a0
	move.w	(potreeteam).w,d0
	move.b	(a0,d0.w),d0
	movea.l	#tmstruct,a2
	cmp.w	Xvel(a2),d0
	beq.w	.0
	adda.w	#tmsize,a2
.0
	moveq	#1,d7
	jsr	(PlayerStatsList).l
	movem.l	(sp)+,a2
	rts
RecordHoldersScreen					;Pause menu RECORD HOLDERS: the save RAM records (PrintRecordTitles ...
									;ReadTeamRecords) page TempWord1 (left / right), A+C on the win page
									;clears the win records (ClearWinRecords)
	bsr.w	ReadNameLog
	clr.w	(TempWord1).w
	bclr	#6,(sflags6).w
	bsr.w	ReadTeamRecords
	bset	#6,(sflags6).w
	bsr.w	ReadTeamRecords
	bsr.w	CalcWinPercents
	move.w	#0,d0
	move.w	#$1A,d1
	jsr	(SetupScreen).l
	jsr	(printz).l
	String	-TXMAP3,$0,$0,$0
	move.w	#$7FF,d2
	move.w	#$28,d0
	move.w	#$1C,d1
	jsr	(eraser).l
	jsr	(printbigz).l
	String	-(TXPRI+TXMAP3),$7,$2,'Record Holders',-(TXPRI+TXMAP3),$1,$9
	jsr	(printsmallz).l
	String	CC_SetMapAndPosition,$4,$3,$5,$8,CC_SetFont,$1,'Name',CC_SetFont,$0,$0
	bsr.w	PrintRecordTitles
	bsr.w	PrintWinRecords
.loop
	jsr	(vcountwait).l
	jsr	(ReadMenuJoy).l
	jsr	(ProcessInputWithRepeat).l
	btst	#7,d3
	beq.w	.0
	jmp	(ExitStatsScreen).l
.0
	tst.w	(TempWord1).w
	bne.w	.right
	btst	#6,d3
	beq.w	.right
	btst	#5,d3
	beq.w	.right
	bsr.w	ClearWinRecords
	bsr.w	CalcWinPercents
	bsr.w	PrintWinRecords
	bra.s	.loop
.right
	btst	#3,d1
	beq.w	.left
	cmpi.w	#2,(TempWord1).w
	beq.s	.loop
	bsr.w	ClearRecordArea
	addq.w	#1,(TempWord1).w
	bsr.w	PrintRecordTitles
	bsr.w	PrintRecordPage
	bra.s	.loop
.left
	btst	#2,d1
	beq.s	.loop
	tst.w	(TempWord1).w
	beq.s	.loop
	bsr.w	ClearRecordArea
	subq.w	#1,(TempWord1).w
	bsr.w	PrintRecordTitles
	bsr.w	PrintRecordPage
	bra.w	.loop
	rts								;never reached
PrintRecordPage						;Record Holders: print page TempWord1 (0:
									;PrintWinRecords, else PrintPlayerRecords)
	tst.w	(TempWord1).w
	beq.w	PrintWinRecords
	bra.w	PrintPlayerRecords
PrintRecordTitles					;Record Holders: the titles of page TempWord1 (WinRecTitles,
									;GoalRecTitles, SaveRecTitles)
	movea.l	#WinRecTitles,a1
	tst.w	(TempWord1).w
	beq.w	.0
	movea.l	#SaveRecTitles,a1
	cmpi.w	#2,(TempWord1).w
	beq.w	.0
	movea.l	#GoalRecTitles,a1
.0
	jsr	(printsmall).l
	rts
WinRecTitles						;PrintRecordTitles String, page 0
	dc.w	$52						;String length
	dc.b	$F8,$4,$3,$10,$8,$F9,$1,'   Win %   Win-Loss-Tie'
	dc.b	$FD,$4,$FC,$19,'Use A+C to clear ALL win records',$FD,$10,$FC
	dc.b	$1A,'  More ]',$F9,$0
GoalRecTitles						;PrintRecordTitles String, page 1
	dc.w	$50						;String length
	dc.b	$F8,$4,$3,$12,$8,$F9,$1,'Goals       Teams    '
	dc.b	$FD,$4,$FC,$19,'    TEAM MUST WIN TO QUALIFY    ',$FD,$10,$FC
	dc.b	$1A,'[ More ]',$F9,$0
SaveRecTitles						;PrintRecordTitles String, page 2
	dc.w	$50						;String length
	dc.b	$F8,$4,$3,$12,$8,$F9,$1,'Saves       Teams    '
	dc.b	$FD,$4,$FC,$19,'    TEAM MUST WIN TO QUALIFY    ',$FD,$10,$FC
	dc.b	$1A,'[ More  ',$F9,$0
PrintWinRecords						;Record Holders page 0: name (PrintRecordName), win %, wins, losses, ties
									;of the 7 rows in winsort order
	movem.l	d0-d7/a0-a6,-(sp)
	jsr	(printsmallz).l
	String	CC_SetMapAndPosition,$4,$3,$2,$A,CC_SetFont,$0,$0
	move.w	#6,d7
	movea.l	#winsort,a0
	movea.l	#winpcts,a2
	movea.l	#ThreeStars,a5
.loop
	move.w	#2,(printx).w
	move.b	(a0)+,d0
	ext.w	d0
	move.b	0(a2,d0.w),d5
	asl.w	#4,d0
	move.b	$A(a5,d0.w),d4
	lsl.w	#8,d4
	move.b	$B(a5,d0.w),d4
	move.w	d4,-(sp)
	move.b	$C(a5,d0.w),d4
	lsl.w	#8,d4
	move.b	$D(a5,d0.w),d4
	move.w	d4,(recties).w
	move.b	8(a5,d0.w),d4
	lsl.w	#8,d4
	move.b	9(a5,d0.w),d4
	move.w	d4,(recwincount).w
	add.w	(recties).w,d4
	sub.w	(sp),d4
	neg.w	d4
	move.w	d4,(reclosses).w
	move.w	(sp)+,d4
	tst.w	d4
	beq.w	.0
	bsr.w	PrintRecordName
	move.w	#$13,(printx).w
	move.w	d0,-(sp)
	move.w	d5,d0
	move.w	#3,d1
	jsr	(PushNumberWidth).l
	jsr	(printsmall).l
	move.w	#$1A,(printx).w
	move.w	(recwincount).w,d0
	move.w	#4,d1
	jsr	(PushNumberWidth).l
	jsr	(printsmall).l
	move.w	#$1F,(printx).w
	move.w	(reclosses).w,d0
	move.w	#4,d1
	jsr	(PushNumberWidth).l
	jsr	(printsmall).l
	move.w	#$24,(printx).w
	move.w	(recties).w,d0
	move.w	#3,d1
	jsr	(PushNumberWidth).l
	move.w	(sp)+,d0
	bra.w	.1
.0
	movea.l	#RecParenTxt,a1
.1
	jsr	(printsmall).l
	addq.w	#2,(printy).w
	dbf	d7,.loop
	movem.l	(sp)+,d0-d7/a0-a6
	rts
ClearRecordArea						;Record Holders: erase the record rows ($28 x $12), keeping printx /
									;printy / printm
	movem.l	d0-d7/a0-a6,-(sp)
	move.w	(printx).w,-(sp)
	move.w	(printy).w,-(sp)
	move.w	(printm).w,-(sp)
	jsr	(printsmallz).l
	String	CC_SetMapAndPosition,$4,$3,$0,$A,$0
	move.w	#$28,d0
	move.w	#$12,d1
	move.w	#$7FF,d2
	jsr	(eraser).l
	move.w	(sp)+,(printm).w
	move.w	(sp)+,(printy).w
	move.w	(sp)+,(printx).w
	movem.l	(sp)+,d0-d7/a0-a6
	rts
PrintPlayerRecords					;Record Holders pages 1 (goals, recsort1) and 2 (saves, recsort2): name,
									;value "by TEAM vs. TEAM" of the 7 rows
	movem.l	d0-d7/a0-a6,-(sp)
	jsr	(printsmallz).l
	String	CC_SetMapAndPosition,$4,$3,$2,$A,CC_SetFont,$0,$0
	move.w	#6,d7
	movea.l	#recsort1,a0
	cmpi.w	#1,(TempWord1).w
	beq.w	.0
	movea.l	#recsort2,a0
.0
	movea.l	#ThreeStars,a2
.loop
	move.w	#2,(printx).w
	move.b	(a0)+,d0
	ext.w	d0
	asl.w	#4,d0
	move.b	0(a2,d0.w),d5
	cmpi.w	#1,(TempWord1).w
	beq.w	.1
	move.b	4(a2,d0.w),d5
.1
	tst.b	d5
	beq.w	.none
	bsr.w	PrintRecordName
	move.w	#$12,(printx).w
	move.w	d0,-(sp)
	cmpi.w	#1,(TempWord1).w
	bne.w	.2
	move.b	0(a2,d0.w),d0
	bra.w	.3
.2
	move.b	4(a2,d0.w),d0
.3
	andi.w	#$FF,d0
	move.w	#3,d1
	jsr	(PushNumberWidth).l
	jsr	(printsmall).l
	move.w	(sp)+,d0
	move.w	#$19,(printx).w
	movea.l	#RecHolderByTxt,a1
	movea.l	#mesarea,a3
	jsr	(CopyString).l
	move.w	d0,-(sp)
	cmpi.w	#1,(TempWord1).w
	bne.w	.4
	move.b	1(a2,d0.w),d0
	bra.w	.5
.4
	move.b	5(a2,d0.w),d0
.5
	andi.w	#$FF,d0
	movea.l	#mesarea,a1
	jsr	(AppendTeamName).l
	movea.l	#RecHolderVsTxt,a1
	movea.l	#mesarea,a3
	jsr	(appstring).l
	movea.l	#mesarea,a1
	move.w	(sp)+,d0
	cmpi.w	#1,(TempWord1).w
	bne.w	.6
	move.b	2(a2,d0.w),d0
	bra.w	.7
.6
	move.b	6(a2,d0.w),d0
.7
	andi.w	#$FF,d0
	jsr	(AppendTeamName).l
	bra.w	.print
.none
	movea.l	#RecParenTxt,a1
.print
	jsr	(printsmall).l
	addq.w	#2,(printy).w
	dbf	d7,.loop
	movem.l	(sp)+,d0-d7/a0-a6
	rts
RecParenTxt							;A blank record row (38 spaces)
	String	'                                      '
RecHolderByTxt						;PrintPlayerRecords "by "
	String	'by ',$0
RecHolderVsTxt						;PrintPlayerRecords " vs. "
	String	' vs. ',$0
PrintRecordName						;Record Holders: print the row number ("1. ") at d7 and the user name
									;(AppendUserName) of the record row before a0
	move.w	d7,-(sp)
	neg.w	d7
	addq.w	#7,d7
	addi.w	#$30,d7
	movea.l	#mesarea,a1
	move.w	#6,(a1)
	move.b	d7,2(a1)
	move.b	#$2E,3(a1)
	move.b	#$20,4(a1)
	move.b	#0,5(a1)
	jsr	(printsmall).l
	move.w	(sp)+,d7
	move.b	-1(a0),d2
	ext.w	d2
	movea.l	#mesarea,a1
	bclr	#7,(sflags6).w
	jsr	(AppendUserName).l
	jmp	(printsmall).l
CalcWinPercents						;For the 8 user record blocks at ThreeStars: the win % (winpcts), games
									;(wingames) and ties (winties), then sort the rows (winsort)
	movem.l	d0-d7/a0-a6,-(sp)
	movea.l	#ThreeStars,a0
	movea.l	#winpcts,a1
	movea.l	#winties,a6
	movea.l	#wingames,a5
	move.w	#7,d7
.loop
	move.b	8(a0),d0
	lsl.w	#8,d0
	move.b	9(a0),d0
	move.b	$A(a0),d1
	lsl.w	#8,d1
	move.b	$B(a0),d1
	move.w	d1,(a5)+
	tst.w	d1
	bne.w	.0
	clr.w	d0
	bra.w	.1
.0
	mulu.w	#$64,d0
	divu.w	d1,d0
.1
	move.b	d0,(a1)+
	move.b	$C(a0),(a6)+
	move.b	$D(a0),(a6)+
	adda.w	#$10,a0
	dbf	d7,.loop
	movea.l	#winsort,a1
	move.l	a1,-(sp)
	move.w	#1,d0
	move.w	#6,d7
.loop2
	move.b	d0,(a1)+
	addq.w	#1,d0
	dbf	d7,.loop2
	movea.l	(sp),a1
	movea.l	#winpcts,a0
	movea.l	#winties,a6
	movea.l	#wingames,a5
.loop3
	movea.l	(sp),a1
	move.w	#5,d7
	clr.w	d6
.loop4
	move.b	(a1)+,d1
	ext.w	d1
	move.b	(a1),d2
	ext.w	d2
	move.b	0(a0,d1.w),d0
	move.b	0(a0,d2.w),d3
	cmp.b	d3,d0
	bgt.w	.next
	blt.w	.swap
	movem.l	d1-d3,-(sp)
	add.w	d1,d1
	add.w	d2,d2
	move.w	0(a6,d1.w),d0
	move.w	0(a6,d2.w),d3
	cmp.w	d3,d0
	movem.l	(sp)+,d1-d3
	bgt.w	.next
	blt.w	.swap
	movem.l	d1-d3,-(sp)
	add.w	d1,d1
	add.w	d2,d2
	move.w	0(a5,d1.w),d0
	move.w	0(a5,d2.w),d3
	cmp.w	d3,d0
	movem.l	(sp)+,d1-d3
	bge.w	.next
.swap
	move.b	(a1),d0
	move.b	-1(a1),d1
	move.b	d0,-1(a1)
	move.b	d1,(a1)
	st	d6
.next
	dbf	d7,.loop4
	tst.w	d6
	bne.s	.loop3
	movea.l	(sp)+,a1
	movem.l	(sp)+,d0-d7/a0-a6
	rts
ReadTeamRecords						;Read the $80 byte records from save RAM SRTeamRecords and sort the rows
									;on record byte 0 (recsort1) or, with sflags6 bit 6, byte 4 (recsort2)
	movem.l	d0-d7/a0-a6,-(sp)
	move.l	#SRTeamRecords,d0
	move.l	#$80,d1
	movea.l	#ThreeStars,a0
	jsr	(ReadSRAM).l
	movea.l	#recsort1,a1
	btst	#6,(sflags6).w
	beq.w	.0
	movea.l	#recsort2,a1
.0
	move.l	a1,-(sp)
	move.w	#1,d0
	move.w	#6,d7
.loop
	move.b	d0,(a1)+
	addq.w	#1,d0
	dbf	d7,.loop
	movea.l	(sp),a1
	movea.l	#ThreeStars,a0
.loop2
	movea.l	(sp),a1
	move.w	#5,d7
	clr.w	d6
.loop3
	move.b	(a1)+,d1
	ext.w	d1
	move.b	(a1),d2
	ext.w	d2
	asl.w	#4,d1
	asl.w	#4,d2
	move.b	0(a0,d1.w),d0
	move.b	0(a0,d2.w),d3
	btst	#6,(sflags6).w
	beq.w	.1
	move.b	4(a0,d1.w),d0
	move.b	4(a0,d2.w),d3
.1
	cmp.b	d3,d0
	bge.w	.next
	move.b	(a1),d0
	move.b	-1(a1),d1
	move.b	d0,-1(a1)
	move.b	d1,(a1)
	st	d6
.next
	dbf	d7,.loop3
	tst.w	d6
	bne.s	.loop2
	movea.l	(sp)+,a1
	movem.l	(sp)+,d0-d7/a0-a6
	rts
ClearWinRecords						;Clear bytes 8-$B (wins, games) of the 8 ThreeStars records and write the
									;$80 bytes to save RAM SRTeamRecords (WriteSRAM, MakeSRAMChecksum)
	movem.l	d0-d7/a0-a6,-(sp)
	movea.l	#ThreeStars,a0
	move.w	#7,d7
.loop
	clr.b	8(a0)
	clr.b	9(a0)
	clr.b	$A(a0)
	clr.b	$B(a0)
	adda.w	#$10,a0
	dbf	d7,.loop
	move.l	#SRTeamRecords,d0
	move.l	#$80,d1
	movea.l	#ThreeStars,a0
	jsr	(WriteSRAM).l
	jsr	(MakeSRAMChecksum).l
	movem.l	(sp)+,d0-d7/a0-a6
	rts

;-------------------------------------------------------------------------------------------------------------
;	Updating the user records after a game and reading and writing them in save RAM.



UpdateRecords						;With save RAM (ValidSRAM) and user records on (OptUserRec 0), update the
									;player records (UpdatePlayerRecords), with sflags11 bit 7 the crowd
									;records of both teams (UpdateCrowdRecord), then the team record of each
									;pad (UpdateUserRecord), then the save RAM checksum
	tst.w	(ValidSRAM).w
	bmi.w	.x
	tst.w	(OptUserRec).w
	bne.w	.x
	movem.l	d0-d7/a0-a6,-(sp)
	bsr.w	CountGoalies
	bsr.w	CountPlayers
	move.w	(HomeTeam).w,d1
	ext.l	d1
	movea.l	#ThreeStars,a0
	movea.l	#tmstruct,a2
	move.w	(homegoalies).w,d5
	move.w	(VisTeam).w,d6
	bsr.w	UpdatePlayerRecords
	move.w	(VisTeam).w,d1
	ext.l	d1
	movea.l	#AwShots,a2
	move.w	(awaygoalies).w,d5
	move.w	(HomeTeam).w,d6
	bsr.w	UpdatePlayerRecords
	btst	#7,(sflags11).w
	beq.w	.0
	clr.w	d7
	movea.l	#tmstruct,a1
	bsr.w	GetTeamUser
	move.w	(recuser1).w,d4
	movea.l	#AwShots,a1
	bsr.w	GetTeamUser
	move.w	(recuser1).w,d5
	movea.l	#tmstruct,a1
	move.w	(HomeTeam).w,d1
	move.w	(VisTeam).w,d2
	move.w	(homegoalies).w,d6
	ext.l	d1
	movea.l	#ThreeStars,a0
	bsr.w	UpdateCrowdRecord
	movea.l	#AwShots,a1
	bsr.w	GetTeamUser
	move.w	(recuser1).w,d4
	movea.l	#tmstruct,a1
	bsr.w	GetTeamUser
	move.w	(recuser1).w,d5
	movea.l	#AwShots,a1
	move.w	(VisTeam).w,d1
	move.w	(HomeTeam).w,d2
	move.w	(awaygoalies).w,d6
	ext.l	d1
	movea.l	#ThreeStars,a0
	bsr.w	UpdateCrowdRecord
.0
	move.w	d0,-(sp)
	movea.l	#ThreeStars,a0
	move.w	(pad1user).w,d1
	ext.l	d1
	move.w	(cont1team).w,d0
	bsr.w	UpdateUserRecord
	movea.l	#ThreeStars,a0
	move.w	(pad2user).w,d1
	ext.l	d1
	move.w	(cont2team).w,d0
	bsr.w	UpdateUserRecord
	movea.l	#ThreeStars,a0
	move.w	(pad3user).w,d1
	ext.l	d1
	move.w	(cont3team).w,d0
	bsr.w	UpdateUserRecord
	movea.l	#ThreeStars,a0
	move.w	(pad4user).w,d1
	ext.l	d1
	move.w	(cont4team).w,d0
	bsr.w	UpdateUserRecord
	move.w	(sp)+,d0
	jsr	(MakeSRAMChecksum).l
	movem.l	(sp)+,d0-d7/a0-a6
.x
	rts
UpdateTeamRecord					;Add the game of team a1 (against a2) to team record block d1 (games,
									;wins, ties) with sflags11 bit 7 keep the biggest win and loss margins
									;with users d3 / d4 and team d2 (WriteTeamRecord)
	movem.l	d0-d7/a0-a6,-(sp)
	bsr.w	ReadTeamRecord
	st	d7
	movem.w	d0,-(sp)
	clr.w	d0
	move.b	$A(a0),d0
	lsl.w	#8,d0
	move.b	$B(a0),d0
	cmp.w	#$2328,d0
	bge.w	.1
	addq.w	#1,d0
	move.b	d0,$B(a0)
	lsr.w	#8,d0
	move.b	d0,$A(a0)
	move.w	$C(a1),d0
	cmp.w	$C(a2),d0
	bgt.w	.0
	blt.w	.1
	clr.w	d0
	move.b	$C(a0),d0
	lsl.w	#8,d0
	move.b	$D(a0),d0
	addq.w	#1,d0
	move.b	d0,$D(a0)
	lsr.w	#8,d0
	move.b	d0,$C(a0)
	bra.w	.1
.0
	clr.w	d0
	move.b	8(a0),d0
	lsl.w	#8,d0
	move.b	9(a0),d0
	addq.w	#1,d0
	move.b	d0,9(a0)
	lsr.w	#8,d0
	move.b	d0,8(a0)
.1
	movem.w	(sp)+,d0
	btst	#7,(sflags11).w
	beq.w	.write
	movem.w	d0,-(sp)
	move.w	$C(a1),d0
	cmp.w	$C(a2),d0
	movem.w	(sp)+,d0
	ble.w	.write
	move.w	$C(a1),d5
	cmp.b	(a0),d5
	ble.w	.2
	st	d7
	move.b	d5,(a0)
	move.b	d3,1(a0)
	move.b	d4,2(a0)
	move.b	d2,3(a0)
.2
	move.w	$C(a2),d5
	move.w	(a2),d6
	sub.w	d5,d6
	cmp.b	4(a0),d6
	ble.w	.write
	st	d7
	move.b	d6,4(a0)
	move.b	d3,5(a0)
	move.b	d4,6(a0)
	move.b	d2,7(a0)
.write
	bsr.w	WriteTeamRecord
	movem.l	(sp)+,d0-d7/a0-a6
	rts
UpdateCrowdRecord					;Crowd record block d1 of team a1: the most goals, the biggest period lead
									;and (home team) the crowd peak (CrowdPeak), with users d4 / d5 and
									;opponent d2 (ReadCrowdRecord, WriteCrowdRecord)
	movem.l	d0-d7/a0-a6,-(sp)
	bsr.w	ReadCrowdRecord
	move.w	$C(a1),d3
	cmp.b	(a0),d3
	ble.w	.0
	move.b	d3,(a0)
	move.b	d4,1(a0)
	move.b	d5,3(a0)
	move.b	d2,2(a0)
	st	d7
.0
	subq.w	#1,d6
	clr.w	d3
.loop
	move.w	d6,d0
	addi.w	#$EA,d0
	move.b	(a1,d0.w),(TempWord1).w
	addi.w	#-$34,d0
	move.b	(a1,d0.w),d0
	sub.b	d0,(TempWord1).w
	cmp.b	(TempWord1).w,d3
	bge.w	.1
	move.b	(TempWord1).w,d3
.1
	dbf	d6,.loop
	cmp.b	4(a0),d3
	ble.w	.2
	st	d7
	move.b	d3,4(a0)
	move.b	d4,5(a0)
	move.b	d5,7(a0)
	move.b	d2,6(a0)
.2
	cmp.w	(HomeTeam).w,d1
	bne.w	.3
	move.b	8(a0),d3
	andi.w	#$FF,d3
	cmp.w	(CrowdPeak).w,d3
	bge.w	.3
	move.w	(CrowdPeak).w,d3
	st	d7
	move.b	d3,8(a0)
	move.b	d4,9(a0)
	move.b	d5,$B(a0)
	move.b	d2,$A(a0)
.3
	tst.w	d7
	beq.w	.x
	bsr.w	WriteCrowdRecord
.x
	movem.l	(sp)+,d0-d7/a0-a6
	rts
UpdatePlayerRecords					;For the 26 players of team a2, keep each new best (goals, or saves for
									;the goalies) in his player record with opponent d6 and, with sflags11 bit
									;7, the users of both teams (GetPadUser)
	clr.l	d0
	move.w	#$19,d2
.loop
	bsr.w	ReadPlayerRecord
	cmp.w	d5,d0
	blt.w	.0
	move.w	d0,-(sp)
	addi.w	#$B6,d0
	move.b	(a2,d0.w),d4
	move.w	(sp)+,d0
	bra.w	.1
.0
	move.w	d0,-(sp)
	addi.w	#$EA,d0
	move.b	(a2,d0.w),d4
	addi.w	#-$34,d0
	sub.b	(a2,d0.w),d4
	move.w	(sp)+,d0
.1
	move.b	(a0),d3
	cmp.b	d3,d4
	ble.w	.5
	move.b	d4,(a0)
	btst	#7,(sflags11).w
	bne.w	.2
	move.b	#0,1(a0)
	move.b	#0,3(a0)
	bra.w	.4
.2
	move.l	a4,-(sp)
	move.w	#1,d0
	cmpa.l	#tmstruct,a2
	bne.w	.3
	move.w	#2,d0
.3
	movea.l	#recuser1,a4
	bsr.w	GetPadUser
	eori.w	#3,d0
	movea.l	#recuser2,a4
	bsr.w	GetPadUser
	move.b	(recuser1+1).w,1(a0)
	move.b	(recuser2+1).w,3(a0)
	movea.l	(sp)+,a4
.4
	move.b	d6,2(a0)
	bsr.w	WritePlayerRecord
.5
	addq.w	#1,d0
	dbf	d2,.loop
	rts
GetPadUser							;(a4) = the name log entry (pad1user ... pad4user) of the first pad on
									;team d0, or 0
	clr.w	(a4)
	cmp.w	(cont1team).w,d0
	bne.w	.0
	move.w	(pad1user).w,(a4)
	rts
.0
	cmp.w	(cont2team).w,d0
	bne.w	.1
	move.w	(pad2user).w,(a4)
	rts
.1
	cmp.w	(cont3team).w,d0
	bne.w	.2
	move.w	(pad3user).w,(a4)
	rts
.2
	cmp.w	(cont4team).w,d0
	bne.w	.x
	move.w	(pad4user).w,(a4)
.x
	rts
UpdateUserRecord					;Team record block d1 (a pad's name log entry) for the pad's team d0
									;(UpdateTeamRecord); for a pad with no team, the team no pad plays (none
									;when both have pads)
	tst.w	d0
	bne.w	.hasteam
	movea.l	#tmstruct,a1
	cmpi.w	#1,(cont1team).w
	beq.w	.chkaway
	cmpi.w	#1,(cont2team).w
	beq.w	.chkaway
	cmpi.w	#1,(cont3team).w
	beq.w	.chkaway
	cmpi.w	#1,(cont4team).w
	beq.w	.chkaway
	bra.w	.1
.chkaway
	movea.l	#AwShots,a1
	cmpi.w	#2,(cont1team).w
	beq.w	.x
	cmpi.w	#2,(cont2team).w
	beq.w	.x
	cmpi.w	#2,(cont3team).w
	beq.w	.x
	cmpi.w	#2,(cont4team).w
	beq.w	.x
.1
	bra.w	.order
.hasteam
	movea.l	#tmstruct,a1
	cmp.w	#2,d0
	bne.w	.order
	movea.l	#AwShots,a1
.order
	cmpa.l	#tmstruct,a1
	bne.w	.awayfirst
	movea.l	#AwShots,a2
	move.w	(HomeTeam).w,d3
	move.w	(VisTeam).w,d4
.user
	exg	a1,a2
	bsr.w	GetTeamUser
	move.w	(recuser1).w,d2
	exg	a1,a2
	bra.w	.6
.awayfirst
	movea.l	#tmstruct,a2
	move.w	(VisTeam).w,d3
	move.w	(HomeTeam).w,d4
	bra.s	.user
.6
	bra.w	UpdateTeamRecord
.x
	rts
ReadTeamRecord						;Read the 16 byte team record block d1 ($D22 + d1 * 16) to a0
									;(TeamRecordIO)
	bclr	#6,(sflags6).w
TeamRecordIO						;The team record block: read or write (sflags6 bit 6)
	movem.l	d0-d1/a0-a1,-(sp)
	move.l	d1,d0
	asl.w	#4,d0
	addi.l	#SRTeamRecords,d0
	moveq	#$10,d1
	btst	#6,(sflags6).w
	beq.w	.read
	jsr	(WriteSRAM).l
	bra.w	.x
.read
	jsr	(ReadSRAM).l
.x
	movem.l	(sp)+,d0-d1/a0-a1
	rts
WriteTeamRecord						;Write the team record block (TeamRecordIO)
	bset	#6,(sflags6).w
	bra.s	TeamRecordIO
ReadCrowdRecord						;Read the 16 byte crowd record block of team d1 ($B62 + d1 * 16) to a0
									;(CrowdRecordIO)
	bclr	#6,(sflags6).w
CrowdRecordIO						;The crowd record block: read or write (sflags6 bit 6)
	movem.l	d0-d1/a0-a1,-(sp)
	move.l	d1,d0
	asl.w	#4,d0
	addi.l	#SRCrowdRecords,d0
	moveq	#$10,d1
	btst	#6,(sflags6).w
	beq.w	.read
	jsr	(WriteSRAM).l
	bra.w	.x
.read
	jsr	(ReadSRAM).l
.x
	movem.l	(sp)+,d0-d1/a0-a1
	rts
WriteCrowdRecord					;Write the crowd record block (CrowdRecordIO)
	bset	#6,(sflags6).w
	bra.s	CrowdRecordIO
ReadPlayerRecord					;Read the 4 byte player record d0 of team d1
									;(PlayerRecordOffsets) from save RAM to a0
	bclr	#6,(sflags6).w
PlayerRecordIO						;The player record: read or write (sflags6 bit 6)
	movem.l	d0-d1/a0-a1,-(sp)
	asl.l	#2,d0
	addq.l	#2,d0
	movea.l	#PlayerRecordOffsets,a1
	add.w	d1,d1
	move.w	(a1,d1.w),d1
	asl.w	#2,d1
	ext.l	d1
	add.l	d1,d0
	moveq	#4,d1
	btst	#6,(sflags6).w
	beq.w	.read
	jsr	(WriteSRAM).l
	bra.w	.x
.read
	jsr	(ReadSRAM).l
.x
	movem.l	(sp)+,d0-d1/a0-a1
	rts
WritePlayerRecord					;Write the 4 byte player record
	bset	#6,(sflags6).w
	bra.s	PlayerRecordIO
PlayerRecordOffsets					;The first player record of each team (26 per team), ReadPlayerRecord
	dc.w	0,$1A,$34,$4E,$68,$82,$9C,$B6,$D0,$EA,$104,$11E,$138,$152
	dc.w	$16C,$186,$1A0,$1BA,$1D4,$1EE,$208,$222,$23C,$256,$270,$28A,$2A4,$2BE
	dc.w	$2D8
CountGoalies						;homegoalies / awaygoalies = goalies of the home / away team
									;(GetGoalieCount)
	movem.l	d0-d7/a0-a6,-(sp)
	movea.l	#tmstruct,a2
	jsr	(GetGoalieCount).l
	move.w	d0,(homegoalies).w
	movea.l	#AwShots,a2
	jsr	(GetGoalieCount).l
	move.w	d0,(awaygoalies).w
	movem.l	(sp)+,d0-d7/a0-a6
	rts
CountPlayers						;homeplayers / awayplayers = players of the home / away team
									;(GetPlayerCount)
	movem.l	d0-d7/a0-a6,-(sp)
	movea.l	#tmstruct,a2
	jsr	(GetPlayerCount).l
	move.w	d0,(homeplayers).w
	movea.l	#AwShots,a2
	jsr	(GetPlayerCount).l
	move.w	d0,(awayplayers).w
	movem.l	(sp)+,d0-d7/a0-a6
	rts
SetupScreen							;Common start of the stats screens: blank, scroll 0, 40 cell mode, the
									;framer, the background bitmap (ControllerBgMap), the small fonts (three
									;remaps) and the big font
	movem.l	d0-d1/a2,-(sp)
	jsr	(forceblack).l
.0
	btst	#dfok,(disflags).w
	bne.s	.0
	clr.w	(Hscroll).w
	clr.w	(Vscroll).w
	jsr	(SetScroll2).l
	move.w	(disflags).w,-(sp)
	bset	#dfng,(disflags).w
	movea.l	#Vdata,a0
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
	bclr	#df32c,(disflags).w
	move.w	#1,d4
	jsr	(printz).l
	String	-TXMAP2,$0,$0,$0
	movem.l	(sp),d0-d1/a2
	movea.l	#ControllerBgMap,a0
	movea.l	a0,a1
	movea.l	a0,a2
	adda.l	(a2)+,a0
	adda.l	(a2)+,a1
	clr.w	d0
	clr.w	d1
	moveq	#$28,d2
	move.w	#$1C,d3
	moveq	#$F,d5
	jsr	(dobitmap).l
	move.w	d4,(smallfontchars).w
	movea.l	#SmallFontMap+8,a2
	jsr	(DecompressGraphicsWithCallback).l
	dc.b	$0B,$83,$44,$67,$89,$AB,$CD,$EF	;remap table
	move.w	d4,(smallfont2chars).w
	movea.l	#SmallFontMap+8,a2
	jsr	(DecompressGraphicsWithCallback).l
	dc.b	$0B,$83,$4C,$67,$89,$AB,$CD,$EF	;remap table
	move.w	d4,(smallfont3chars).w
	movea.l	#SmallFontMap+8,a2
	jsr	(DecompressGraphicsWithCallback).l
	dc.b	$0B,$83,$48,$67,$89,$AB,$CD,$EF	;remap table
	move.l	#SmallFontMap,(smallfontptr).l
	move.w	d4,(BigFontchars).w
	movea.l	#BigFontMap2+8,a2
	jsr	(DecompressGraphicsPlain).l
	jsr	(printz).l
	String	-TXMAP1,$0,$0,$0
	moveq	#$40,d0
	moveq	#$20,d1
	move.w	#$7FF,d2
	jsr	(eraser).l
	move.w	#$18,(palcount).w
	bclr	#dfng,(disflags).w
	movem.l	(sp)+,d0-d1/a2
	rts

GetTeamUser							;(recuser1) = the name log entry of the pad on team a1 (tmstruct 1, else
									;2), 0 without sflags11 bit 7
	movem.l	d0-d2,-(sp)
	btst	#7,(sflags11).w
	bne.w	.on
	clr.w	(recuser1).w
	bra.w	.done
.on
	move.w	#1,d0
	cmpa.l	#tmstruct,a1
	beq.w	.chk
	move.w	#2,d0
.chk
	clr.w	(recuser1).w
	cmp.w	(cont1team).w,d0
	bne.w	.2
	move.w	(pad1user).w,(recuser1).w
	bra.w	.done
.2
	cmp.w	(cont2team).w,d0
	bne.w	.3
	move.w	(pad2user).w,(recuser1).w
	bra.w	.done
.3
	cmp.w	(cont3team).w,d0
	bne.w	.4
	move.w	(pad3user).w,(recuser1).w
	bra.w	.done
.4
	cmp.w	(cont4team).w,d0
	bne.w	.done
	move.w	(pad4user).w,(recuser1).w
.done
	movem.l	(sp)+,d0-d2
	rts
