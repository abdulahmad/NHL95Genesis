;	Injuries and the power play box. This file decides how long an injured player is out and
;	shows the power play timer. New in 95: injuries that last through the season.

setInjuryType						;a2 injured: out for the period ($FFFD) or the game ($FFFC); in a season a
									;random games count (SetInjuryGames)
	bclr	#1,(sflags12).w
	move.w	d0,-(sp)
	bset	#pf2unav,pflags2(a2)
	addi.w	#$12C,(Crowdlevel).w
	addi.w	#$1E,(CwdExciteLvl).w
	move.w	#SFXoooh2,-(sp)			;sound effect
	jsr	(sfx).l
	clr.w	Xvel(a2)
	clr.w	Yvel(a2)
	move.w	(a2),(xc1).w			;move Xpos to scroll center
	move.w	Ypos(a2),(yc1).w
	bset	#sfslock,(sflags).w
	clr.w	d1						;clear d1
	movea.w	#(tmstruct-M68K_RAM),a0	;move Home team Struct to a0
	btst	#pfteam,pflags(a2)
	beq.w	.0						;branch if home
	move.w	#$8000,d1
	adda.w	#tmsize,a0				;add $364 to a0 (Away Team Struct start)
.0
	move.b	$66(a2),d1
	move.w	d1,(TempPlOffset).w
	ext.w	d1						;sign extend - in this case just makes upper bye of word 00
	add.w	d1,d1					;add d1 to itself
	btst	#1,(sflags13).w
	bne.w	.not0
	exg	a2,a3						;swap a2 and a3
	jsr	(getFgtbyte).l				;get the Fgt byte (divided by 4)
	exg	a2,a3						;swap back
	tst.w	d0						;check if d0 is zero
	bne.w	.not0
	bclr	#5,(sflags7).w			;clear injury game bit
	move.w	#$FFFD,tmpdst(a0,d1.w)
	bra.w	.exit
.not0
	cmp.w	#3,d0					;compare d0 to 3 (if H/F was 12, d0 = 3)
	beq.w	.2
	bclr	#5,(sflags7).w
	move.w	#$FFFD,tmpdst(a0,d1.w)
	jsr	(chkFgtBit1).l				;check Fgt bit 1 of player.
	beq.w	.exit
.2
	bset	#5,(sflags7).w			;set injury game bit
	move.w	#$FFFC,tmpdst(a0,d1.w)
	btst	#3,(GameFlags).w
	beq.w	.exit
	btst	#2,(SeasonDay+1).w
	beq.w	.exit
	move.w	#$64,d0
	jsr	(randomd0).l
	cmp.w	#$32,d0
	blt.w	.exit
	movem.w	d1,-(sp)
	clr.w	d0
	move.b	(SeasonLength).w,d0
	clr.w	d1
	move.b	(SeasonDay).w,d1
	sub.w	d1,d0
	movem.w	(sp)+,d1
	cmp.w	#2,d0
	blt.w	.exit
	subq.w	#1,d0
	cmp.w	#5,d0
	ble.w	.3
	move.w	#5,d0
.3
	jsr	(randomd0).l
	addq.w	#1,d0
	movem.l	d1/d7,-(sp)
	move.w	$28(a0),d7
	move.w	(TempPlOffset).w,d1
	andi.w	#$FF,d1
	bset	#1,(sflags13).w
	jsr	(SetInjuryGames).l
	movem.l	(sp)+,d1/d7
.exit
	move.w	(sp)+,d0
	rts

SetSeasonInjuries					;The players of team a2 with injury games left (save RAM SRInjuries) are
									;out ($FFFC)
	movem.l	d0-d3/a0/a2,-(sp)
	movea.l	#SaveRAM+2*SRInjuries,a0
	move.w	Xvel(a2),d0
	mulu.w	#$1C,d0
	adda.l	d0,a0
	adda.w	#$68,a2
	move.w	#$19,d3
.loop
	move.w	(a0),d1
	andi.w	#$F0,d1
	beq.w	.1
	move.w	#$FFFC,(a2)
.1
	addq.w	#2,a2
	subq.w	#1,d3
	bmi.w	.3
	move.w	(a0),d1
	andi.w	#$F,d1
	beq.w	.2
	move.w	#$FFFC,(a2)
.2
	addq.w	#2,a2
	addq.w	#2,a0
	dbf	d3,.loop
.3
	movem.l	(sp)+,d0-d3/a0/a2
	rts

TickTeamInjuries					;A game played: one injury game off for teams d0 and d1 (TickInjuries),
									;save RAM checksum
	movem.l	d2-d4/a0,-(sp)
	bsr.w	TickInjuries
	move.w	d1,d0
	bsr.w	TickInjuries
	jsr	(MakeSRAMChecksum).l
	movem.l	(sp)+,d2-d4/a0
	rts

TickInjuries						;One game off every injury of team d0 (save RAM
									;SRInjuries, a nibble per player)
	movea.l	#SaveRAM+2*SRInjuries,a0
	mulu.w	#$1C,d0
	adda.l	d0,a0
	move.w	#$C,d2
.loop
	move.w	(a0),d3
	andi.w	#$F,d3
	beq.w	.1
	subq.w	#1,d3
	andi.w	#$F0,(a0)
	or.w	d3,(a0)
.1
	move.w	(a0),d3
	andi.w	#$F0,d3
	beq.w	.next
	subi.w	#$10,d3
	andi.w	#$F,(a0)
	or.w	d3,(a0)
.next
	addq.w	#2,a0
	dbf	d2,.loop
	rts

SetInjuryGames						;Injury games d0 for player d1 of team d7 (save RAM SRInjuries); sflags12
									;bit 1 and injurygames
	movem.l	d0-d7/a0-a7,-(sp)
	bset	#1,(sflags12).w
	move.w	d0,(injurygames).w
	mulu.w	#$1C,d7
	movea.l	#SaveRAM+2*SRInjuries,a0
	adda.l	d7,a0
	move.w	d1,d2
	lsr.w	#1,d2
	add.w	d2,d2
	move.w	(a0,d2.w),d3
	btst	#0,d1
	bne.w	.0
	andi.w	#$F,d3
	asl.w	#4,d0
	or.w	d0,d3
	bra.w	.1
.0
	andi.w	#$F0,d3
	or.w	d0,d3
.1
	move.w	d3,(a0,d2.w)
	movem.l	(sp)+,d0-d7/a0-a7
	rts

GetInjuryGames						;d0 = the injury games of player d1 of team d7 (save RAM SRInjuries)
	movem.l	d1-d7/a0,-(sp)
	movea.l	#SaveRAM+2*SRInjuries,a0
	mulu.w	#$1C,d7
	adda.l	d7,a0
	move.w	d1,d2
	lsr.w	#1,d2
	add.w	d2,d2
	move.w	(a0,d2.w),d0
	btst	#0,d1
	bne.w	.0
	lsr.w	#4,d0
.0
	andi.w	#$F,d0
	movem.l	(sp)+,d1-d7/a0
	rts

getFgtbyte							;d0 = $74(a2) / 4
	clr.w	d0						;clear d0
	move.b	fighting(a2),d0			;move H/F bit into d0 (this is always even)
	lsr.w	#2,d0					;shift 2 right (divide by 4)
	rts

chkFgtBit1							;Z from bit 1 of a random 0-99 (94 tested bit 1 of $74(a2))
	movem.w	d0,-(sp)
	move.w	#$64,d0
	jsr	(randomd0).l
	btst	#1,d0
	movem.w	(sp)+,d0
	rts

CheckInjury							;The injury message when its timer runs out: "Injury to:" the player, "Out
									;for period", "game" or n "games"
	subq.w	#1,(InjCntDown).w
	beq.w	.0
	rts
.0
	btst	#1,(sflags12).w
	beq.w	.1
	jsr	(MakeSRAMChecksum).l
.1
	movem.l	d0-d2/a0-a4,-(sp)
	jsr	(printz).l
	String	-(TXPRI+TXMAP1),$B,$3,$0
	moveq	#$12,d0
	moveq	#5,d1
	jsr	(Framer).l
	btst	#1,(sflags12).w
	bne.w	.3
	btst	#5,(sflags7).w
	bne.w	.2
	jsr	(printz).l
	String	-(TXPRI+TXMAP1),$C,$4,'Injury to:',-(TXPRI+TXMAP1),$C,$6,'Out for period',-(TXPRI+TXMAP1),$C,$5,$0
	bra.w	.6
.2
	jsr	(printz).l
	String	-(TXPRI+TXMAP1),$C,$4,'Injury to:',-(TXPRI+TXMAP1),$C,$6,'Out for game',-(TXPRI+TXMAP1),$C,$5,$0
	bra.w	.6
.3
	jsr	(printz).l
	String	-(TXPRI+TXMAP1),$C,$4,'Injury to:',-(TXPRI+TXMAP1),$C,$6,'Out for '
	move.w	(injurygames).w,d0
	move.w	#1,d1
	jsr	(PushNumberWidth).l
.4
	jsr	(print).l
	cmpi.w	#1,(injurygames).w
	bgt.w	.5
	jsr	(printz).l
	String	' game',-(TXPRI+TXMAP1),$C,$5
	bra.w	.6
.5
	jsr	(printz).l
	String	' games',-(TXPRI+TXMAP1),$C,$5,$0
.6
	jsr	(GetPlayerNumInitial).l
	jsr	(print).l
	btst	#0,(puck_pflags2).w
	beq.w	.done
	jsr	(printz).l
	String	-(TXPRI+TXMAP1),$14,$6,'the game',$0
.done
	movem.l	(sp)+,d0-d2/a0-a4
	rts

InsertInjurySlot					;Open an injury slot at player d1 of team d7 (the later nibbles up one); a
									;player traded in
	movem.l	d0-d7/a0-a6,-(sp)
	movea.l	#SaveRAM+2*SRInjuries,a0
	mulu.w	#$1C,d7
	adda.l	d7,a0
	adda.l	#$18,a0
	move.w	#$19,d3
.loop
	move.w	(a0),d0
	subq.w	#2,a0
	cmp.w	d1,d3
	ble.w	.1
	asr.w	#4,d0
	andi.w	#$F,d0
.1
	subq.w	#1,d3
	bmi.w	.3
	cmp.w	d1,d3
	ble.w	.2
	move.w	(a0),d4
	asl.w	#4,d4
	andi.w	#$F0,d4
	andi.w	#$F,d0
	or.w	d4,d0
.2
	andi.w	#$FF,d0
	move.w	d0,2(a0)
	dbf	d3,.loop
.3
	movem.l	(sp)+,d0-d7/a0-a6
	rts

DeleteInjurySlot					;Remove the injury slot of player d1 of team d7 (the later nibbles down
									;one); a player traded out
	movem.l	d0-d7/a0-a6,-(sp)
	movea.l	#SaveRAM+2*SRInjuries,a0
	mulu.w	#$1C,d7
	adda.l	d7,a0
	move.w	#$D,d2
	clr.w	d3
.loop
	move.w	(a0)+,d0
	cmp.w	d1,d3
	blt.w	.1
	asl.w	#4,d0
.1
	subq.w	#1,d2
	bmi.w	.3
	addq.w	#1,d3
	cmp.w	d1,d3
	blt.w	.2
	move.w	(a0),d4
	asr.w	#4,d4
	andi.w	#$F,d4
	andi.w	#$F0,d0
	or.w	d4,d0
.2
	andi.w	#$FF,d0
	move.w	d0,-2(a0)
	addq.w	#1,d3
	dbf	d2,.loop
.3
	movem.l	(sp)+,d0-d7/a0-a6
	rts

updatepwrplay						;The power play box: the team and the time left (GetLowestPen)
	btst	#1,(gmode2).w
	bne.w	rtsPowerPlay
	movea.w	#(tmstruct-M68K_RAM),a2
	lea	tmsize(a2),a3
	move.w	tmap(a2),d0
	sub.w	tmap(a3),d0
	beq.w	ClearPowerPlay
	bpl.w	.0
	btst	#sf2pwrtm,(sflags2).w
	bne.w	.1
	bsr.w	ClearPowerPlay
	bset	#sf2pwrtm,(sflags2).w
	bra.w	.1
.0
	exg	a2,a3
	btst	#sf2pwrtm,(sflags2).w
	beq.w	.1
	bsr.w	ClearPowerPlay
	bclr	#sf2pwrtm,(sflags2).w
.1
	bset	#sf2pwrplay,(sflags2).w
	bne.w	.4
	addq.w	#1,4(a3)
	cmpa.w	#(tmstruct-M68K_RAM),a3
	bne.w	.3
.home
	bra.w	.4
.3
	bra.s	.home
.4
	jsr	(printz).l
	String	-(TXPRI+TXMAP1),$1,$19,'   ',$16,$17,$18,$19,-(TXPRI+TXMAP1),$1,$1A,'  ',$0
	bsr.w	GetLowestPen
	jsr	(PushTime).l
	jsr	(print).l
	movea.l	tmdata(a3),a0
	movea.w	#(mesarea-M68K_RAM),a3
	move.w	#2,(a3)
	jsr	(appendz).l
	String	-(TXPRI+TXMAP1),$1,$19,$0
	adda.w	4(a0),a0				;team name
	adda.w	(a0),a0
	movea.l	a0,a1
	jsr	(appstring).l
	movea.w	a3,a1
	jmp	(print).l

ClearPowerPlay						;Clear the power play box (sflags2 bit 5)
	bclr	#sf2pwrplay,(sflags2).w
	beq.w	rtsPowerPlay
	jsr	(printz).l
	String	-(TXPRI+TXMAP1),$1,$19,' '
	jmp	(EASNLogo).l

rtsPowerPlay						;Shared rts of updatepwrplay / ClearPowerPlay
	rts

GetLowestPen						;a2 = shorthanded team, a3 = team on the power play. d0 = power play time
									;left from the penalty box times
	clr.w	d0
	clr.w	d3
	lea	$9C(a2),a0
.getstatus
	clr.w	d2
	move.b	(a0)+,d2
	bmi.w	.1
	move.w	$68(a2,d2.w),d2
	btst	#$E,d2					;bit 14: coincidental
	bne.s	.getstatus
	sub.w	d3,d2
	add.w	d2,d0
	move.w	d2,d3
	bra.s	.getstatus
.1
	cmpi.w	#6,OldZpos(a3)			;tmap: 6 on ice, done
	beq.w	.3
	sub.w	d3,d0
	lea	$9C(a3),a0
	clr.w	d2
.2
	move.b	(a0)+,d2
	bmi.w	.3
	btst	#6,$68(a3,d2.w)
	bne.s	.2
	cmp.w	$68(a3,d2.w),d0
	blt.w	.3
	add.w	d3,d0
.3
	andi.w	#$FF,d0
	rts
