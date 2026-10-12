;	Penalty logic: penalties and stoppages, referee messages and the lead song, then
;	checking penalties, the referee sprite, penalty clear, icing, offsides and the blue line
;	warning.

;------------------------------------------------------------------------------------------------------------------------
;	Stop4Pen, AddPenalty ... checkfornewpen, UpdatePA, SetPA, SetPA2, PushRef, prefmes, ClearPenaltyMessage,
;	LeadSong / ClearLeadSong / LeadSongExit.
;	95 changes: the team struct offsets (tmpdst $68, the penalty box list $9C), RefRamMap at $DBBE, the new sounds.



limitfo	;Limit the faceoff spot to 5-20 feet from the walls of the rink, for every player in PenBuf (.1 is 93.lf).
	;the blue line is $56 (94 $58)
	movem.l	d0-d1/a0-a1,-(sp)
	movea.w	#(PenBuf-M68K_RAM),a0
.loop
	bsr.w	.lf
	addq.w	#2,a0
	tst.w	(a0)
	bne.s	.loop
	movem.l	(sp)+,d0-d1/a0-a1
	rts
.lf
	move.b	1(a0),d0
	andi.w	#$7F,d0
	asl.w	#7,d0	;scsize
	movea.w	#(SortCords-M68K_RAM),a1
	move.w	#$56,d1
	btst	#7,pflags(a1,d0.w)
	bne.w	.2
	neg.w	d1
	cmp.w	(foy).w,d1
	blt.w	.5
	move.w	#$FFBF,(foy).w	;-.nuy = -65
	bra.w	.sx
.2
	cmp.w	(foy).w,d1
	bgt.w	.5
	move.w	#$41,(foy).w
.sx
	move.w	#$46,d0
	tst.w	(fox).w
	bpl.w	.4
	neg.w	d0
.4
	move.w	d0,(fox).w
.5
	rts

LeadSong	;Not in a shootout (gmode2 bit 1) and one team has more players on ice (tmap): once (sflags2 bit 5) ChooseSong
	;with SongIndex 1 (home) or 4, and sflags8 bit 6; sflags2 bit 6 keeps which team. sflags2 is put back on exit. Called from puckfaceoff2
	movem.l	d0/a0-a3,-(sp)
	move.w	(sflags2).w,-(sp)
	btst	#1,(gmode2).w
	bne.w	LeadSongExit
	movea.w	#(tmstruct-M68K_RAM),a2
	lea	tmsize(a2),a3
	move.w	tmap(a2),d0
	sub.w	tmap(a3),d0
	beq.w	LeadSongExit
	bpl.w	.0
	btst	#6,(sflags2).w
	bne.w	.1
	bsr.w	ClearLeadSong
	bset	#6,(sflags2).w
	bra.w	.1
.0
	exg	a2,a3
	btst	#6,(sflags2).w
	beq.w	.1
	bsr.w	ClearLeadSong
	bclr	#6,(sflags2).w
.1
	bset	#5,(sflags2).w
	bne.w	LeadSongExit
	cmpa.w	#(tmstruct-M68K_RAM),a3
	bne.w	.3
	move.w	(HomeTeam).w,(HmTeam).w
	move.w	#1,(SongIndex).w
	jsr	(ChooseSong).l
.loop
	bset	#6,(sflags8).w
	bra.w	LeadSongExit
.3
	move.w	(HomeTeam).w,(HmTeam).w
	move.w	#4,(SongIndex).w
	jsr	(ChooseSong).l
	bra.s	.loop

ClearLeadSong	;Clear sflags2 bit 5
	bclr	#5,(sflags2).w
	rts

LeadSongExit	;LeadSong exit
	move.w	(sp)+,(sflags2).w
	movem.l	(sp)+,d0/a0-a3
	rts

Stop4Pen	;a0 = Penaltylist penalty + 2. Stop the clock, set the faceoff spot from the penalty type, blow the whistle
	;and start the ref (SetPA)
	bset	#0,(gmode).w
	bne.w	.5
	clr.w	d0
	clr.w	d1
	cmpi.b	#$E,-2(a0)	;goal (92 used 6): center ice
	beq.w	.0
	move.w	(ltx).w,d0
	move.w	(lty).w,d1
	cmpi.b	#6,-2(a0)	;OOP (92 used $C)
	beq.w	.0
	move.w	(puckx).w,d0
	move.w	(pucky).w,d1
	cmpi.b	#$C,-2(a0)	;icing (92 used 8)
	bne.w	.0
	move.l	a3,-(sp)
	movea.w	#(SortCords-M68K_RAM),a3
	move.b	-1(a0),d1
	ext.w	d1
	asl.w	#7,d1	;scsize
	adda.w	d1,a3
	move.w	#$258,d1	;600
	btst	#7,pflags(a3)
	movea.l	(sp)+,a3
	beq.w	.0
	neg.w	d1
.0
	movem.w	d0-d1,-(sp)
	cmp.w	#$4D,d0
	blt.w	.1
	move.w	#$4D,d0
.1
	cmp.w	#$FFB3,d0
	bgt.w	.2
	move.w	#$FFB3,d0
.2
	cmp.w	#$AF,d1
	blt.w	.3
	move.w	#$D7,d1
	move.w	#$4D,d0
	tst.w	(sp)
	bpl.w	.3
	neg.w	d0
.3
	cmp.w	#$FF51,d1
	bgt.w	.4
	move.w	#$FF29,d1
	move.w	#$4D,d0
	tst.w	(sp)
	bpl.w	.4
	neg.w	d0
.4
	move.w	d0,(fox).w
	move.w	d1,(foy).w
	addq.w	#4,sp
	jsr	(limitfo).l
.5
	clr.w	(Pencntdwn).w
	bset	#2,(gmode).w
	jsr	(stop_current_song).l
	move.w	#SFXwhistle,-(sp)	;whistle (92 used 10)
	jsr	(sfx).l
	movem.l	d1/a0-a3,-(sp)
	movea.l	#PenBuf,a0
	movea.l	#penaltymsgs,a1
	move.w	#$20,d0
	movea.l	#SortCords,a3
.6
	move.w	(a0)+,(a1)+
	beq.w	.7
	clr.w	d1
	move.b	-1(a0),d1
	asl.w	#7,d1
	move.b	pnum(a3,d1.w),-1(a1)
	cmpi.b	#5,-1(a0)
	ble.w	.7
	bset	#7,-1(a1)
.7
	dbf	d0,.6
	movem.l	(sp)+,d1/a0-a3
	move.w	#$A,d0	;whistle (92 used $26)
	bra.w	SetPA

rtspen	;The shared rts of the penalty routines
	rts

AddPenalty	;Add penalty d0 (Penaltylist offset) for player a3. Ignored while the clock is stopped
	btst	#0,(gmode).w
	bne.s	rtspen
	cmp.w	#$C,d0	;icing (92 used 8)
	beq.w	AddPenalty2
	tst.w	(OptPen).w
	beq.s	rtspen
	btst	#2,pflags2(a3)
	bne.s	rtspen
	btst	#5,(gmode).w
	bne.w	AddPenalty2
	cmp.w	#$10,d0	;offsides (92 used $A)
	beq.s	rtspen

AddPenalty2	;Forced penalties like faceoff and game over. d0 = penalty number, a3 = player
	btst	#7,(sflags).w
	bne.s	rtspen
	movem.l	d1/a0-a1,-(sp)
	cmp.w	#$E,d0	;goal (92 used 6) and up
	blt.w	.nonoise
	addi.w	#$C8,(crowdlevel).w	;200
	move.w	#$C,-(sp)	;song $C for the home team
	btst	#6,pflags(a3)
	beq.w	.0
	addi.w	#$14,(CwdExciteLvl).w	;visitors: +20 excitement
	move.w	#$B,(sp)	;song $B
.0
	jsr	(song).l
.nonoise
	movea.w	#(PenBuf-M68K_RAM),a1
	moveq	#$1F,d1	;MaxPen-1
.2
	tst.w	(a1)+
	dbeq	d1,.2
	bne.w	.noplayer
	move.b	$53(a3),-(a1)
	move.b	d0,-(a1)
	movea.l	#Penaltylist,a0
	adda.w	(a0,d0.w),a0
	tst.b	1(a0)	;penalty minutes
	beq.w	.noplayer
	bmi.w	.noplayer
	btst	#6,pflags(a3)
	bne.w	.3
	bset	#1,(sflags9).w
	bra.w	.setpenflag
.3
	bset	#2,(sflags9).w
.setpenflag
	bset	#4,pflags2(a3)	;pflags2 bit 4
	beq.w	.noplayer
	clr.w	(a1)	;player already has a penalty, drop this one
.noplayer
	movem.l	(sp)+,d1/a0-a1
	rts

PenaltyManager	;Called periodically. d7 = elapsed time since last call: checkfornewpen, chkprogress, updatepentime, UpdatePA
	bsr.w	updatepentime
	bsr.w	checkfornewpen
	bsr.w	chkprogress
	bra.w	UpdatePA

chkprogress	;Control the progress of the ref and the game through penalty events. While BA_PS_flags bit 2 is set run
	;PenaltyShotBox (bit 7) or the msgtimer count down and erase the message area
	btst	#2,(BA_PS_flags).w
	beq.w	.3
	btst	#7,(BA_PS_flags).w
	bne.w	.sops
	tst.w	(msgtimer).w
	bmi.w	.3
	subq.w	#1,(msgtimer).w
	bpl.w	.ex
	movem.l	d0-d7/a0-a6,-(sp)
	bclr	#2,(sflags2).w	;sf2drec
	bclr	#7,(gmode2).w
	jsr	(printz).l
	String	-TXMAP1,3,2,0
	moveq	#$1B,d0
	moveq	#8,d1
	btst	#0,(gmode2).w
	beq.w	.0
	move.w	#$C,d1	;12 rows when gmode2 bit 0 is set
.0
	move.l	#$7FF,d2	;blank tile
	jsr	(eraser).l
	movem.l	(sp)+,d0-d7/a0-a6
	bra.w	.ex
.sops
	jsr	(PenaltyShotBox).l
	bclr	#7,(BA_PS_flags).w
.ex
	rts
.3
	btst	#2,(gmode).w	;gmpen: penalty called
	beq.w	rtspen
	tst.w	(Pencntdwn).w
	bmi.w	InProgress
	sub.w	d7,(Pencntdwn).w
	bpl.w	rtspen
	bclr	#3,(gmode).w
	movea.w	#(PenBuf-M68K_RAM),a0
.4
	tst.w	(a0)+	;any penalty with minutes
	beq.w	rtspen
	clr.w	d0
	move.b	-2(a0),d0
	movea.l	#Penaltylist,a1
	adda.w	(a1,d0.w),a1
	tst.b	1(a1)	;penalty minutes
	beq.s	.4
	bmi.s	.4
	bset	#2,(sflags2).w
	bset	#7,(sflags).w
	btst	#6,(sflags).w
	bne.w	.5
	move.w	#$98,(xc1).w
	move.w	#0,(yc1).w
	bset	#6,(sflags).w
.5
	move.w	(ExtraChars).w,d4	;load horizontal ref tiles
	movea.l	#RefTilesHor+8,a2
	jsr	(DecompressGraphicsPlain).l
	st	(puckc).w
	movea.w	#(puckx-M68K_RAM),a3
	moveq	#5,d0
	jsr	(assinsert).l
	move.w	#$1C20,temp1(a3)	;temp1 = 120*60
	st	(RefStep).w
	clr.w	(RefCnt).w
	bsr.w	UpdatePA
	move.w	#$32,(RefCnt).w	;50
	clr.w	d0
	bsr.w	PushRef	;ref frame 0
	move.w	#$18,(palcount).w	;24
	rts

InProgress	;Ref in progress: update the graphics, stats and penalty information
	tst.w	(RefCnt).w
	bpl.w	rtspen
	tst.w	(RefStep).w
	bpl.w	rtspen
	movem.l	d0/a0-a3,-(sp)
.top
	movea.w	#(PenBuf-M68K_RAM),a0
	tst.w	(a0)+
	beq.w	.exit
.1
	tst.w	(a0)+
	bne.s	.1
	subq.w	#4,a0
	bclr	#7,1(a0)	;player who is guilty
	bne.w	.Sa
	movem.l	a3,-(sp)
	clr.w	d1
	move.b	1(a0),d1
	asl.w	#7,d1	;scsize
	movea.w	#(SortCords-M68K_RAM),a3
	adda.w	d1,a3
	tst.w	position(a3)
	movem.l	(sp)+,a3
	bpl.w	.ex
	clr.w	(a0)
	bra.w	.ex
.Sa
	clr.w	d0
	move.b	(a0),d0
	movea.l	#Penaltylist,a1
	adda.w	(a1,d0.w),a1
	bclr	#5,(sflags5).w
	clr.w	d2
	move.b	1(a1),d2	;penalty minutes
	beq.w	.10
	bmi.w	.10
	cmp.b	#5,d2
	bne.w	.3
	bset	#5,(sflags5).w
.3
	movem.l	d0-d1/a1-a4,-(sp)
	jsr	(GetPeriodTimeRemaining).l
	movea.w	#(PenSum-M68K_RAM),a4
	adda.w	(PenSumLength).w,a4
	cmpi.w	#$EC,(PenSumLength).w	;log full: keep overwriting the last entry
	beq.w	.full
	addq.w	#4,(PenSumLength).w
.full
	move.w	d0,(a4)+	;time
	move.b	(a0),(a4)+	;penalty
	clr.w	d1
	move.b	1(a0),d1
	asl.w	#7,d1	;scsize
	movea.w	#(SortCords-M68K_RAM),a3
	adda.w	d1,a3
	clr.w	d0
	movea.w	#(tmstruct-M68K_RAM),a2
	lea	tmsize(a2),a1	;tmsize: visitors
	btst	#6,pflags(a3)
	beq.w	.5
	bset	#7,-1(a4)	;log: visitors
	move.w	#$8000,d0
	exg	a1,a2
.5
	addq.w	#1,6(a2)
	add.w	d2,8(a2)
	move.b	pnum(a3),d0
	move.b	d0,(a4)	;log: player
	move.w	d0,(TempPlOffset).w
	ext.w	d0
	addi.w	#$104,d0
	add.b	d2,(a2,d0.w)
	subi.w	#$104,d0
	asl.w	#1,d0
	ext.w	d2
	mulu.w	#$3C,d2	;60
	bset	#$D,d2	;tmpdst bit 13
	tst.w	tmpdst(a2,d0.w)
	bmi.w	.st
	btst	#4,tmpdst(a2,d0.w)
	beq.w	.st
	bset	#$C,d2	;keep byte bit 4 (word bit 12) of an old penalty time
.st
	move.w	d2,tmpdst(a2,d0.w)
	andi.w	#$EFFF,d2
	moveq	#$34,d1	;(MaxRos-1)*2+2
.ctop
	subq.w	#2,d1	;same time on the other team
	bmi.w	.8
	move.w	$68(a1,d1.w),d3
	andi.w	#$EFFF,d3
	cmp.w	d3,d2
	bne.s	.ctop
	btst	#5,(sflags5).w
	beq.s	.ctop
	bset	#6,$68(a1,d1.w)
	bset	#6,tmpdst(a2,d0.w)
.8
	movem.l	a0,-(sp)
	lea	$9C(a2),a0
	moveq	#$18,d1
.pl
	tst.b	(a0)+
	dbmi	d1,.pl
	move.b	d0,-1(a0)
	st	(a0)
	movem.l	(sp)+,a0
	addq.w	#1,impact(a2)
	bset	#6,(sflags9).w
	move.w	#$15,d0
	jsr	(assreplace).l
	movem.l	(sp)+,d0-d1/a1-a4
	bsr.w	SetPA
	bra.w	.ex
.10
	clr.w	(a0)
	btst	#7,(sflags).w
	bne.w	.top
	bsr.w	SetPA
	bra.w	.ex
.exit
	movea.w	#(tmstruct-M68K_RAM),a2
	bsr.w	coinsearch
	adda.w	#tmsize,a2
	bsr.w	coinsearch
	bclr	#2,(gmode).w
	movea.w	#(puckx-M68K_RAM),a3
	bclr	#6,(BA_PS_flags).w
	bclr	#6,(sflags9).w
	beq.w	.12
	bset	#5,(sflags9).w
.12
	move.w	#3,d0
	btst	#3,(BA_PS_flags).w
	beq.w	.13
	move.w	#$1F,d0
.13
	jsr	(assreplace).l
.ex
	movem.l	(sp)+,d0/a0-a3
	rts

coinsearch	;93 a2 = team. Count the players kept off the ice by penalties (coincidental penalties)
	moveq	#6,d1
	moveq	#$32,d0	;(MaxRos-1)*2
.loop
	tst.w	tmpdst(a2,d0.w)
	ble.w	.nap
	bclr	#5,tmpdst(a2,d0.w)
	btst	#6,tmpdst(a2,d0.w)	;coincidental
	bne.w	.nap
	btst	#4,tmpdst(a2,d0.w)
	bne.w	.nap
	cmp.w	#4,d1	;never below 4 players
	beq.w	.nap
	subq.w	#1,d1
.nap
	subq.w	#2,d0
	bpl.s	.loop
	move.w	d1,tmap(a2)
	rts

updatepentime	;Update the time remaining on all penalized players, once a second (Penaltytimer); sets sflags3 bit 6 on that
	;tick. chkatop, updatePPTeamTime, then ProcessPenaltyList for both teams
	bclr	#6,(sflags3).w
	btst	#0,(gmode).w
	bne.w	rtspen
	sub.w	d7,(Penaltytimer).w
	bpl.w	rtspen
	addi.w	#$18,(Penaltytimer).w	;jps
	bset	#6,(sflags3).w	;one second tick
	jsr	(chkatop).l
	jsr	(updatePPTeamTime).l
	movea.w	#(tmstruct-M68K_RAM),a2
	bsr.w	ProcessPenaltyList
	adda.w	#tmsize,a2

ProcessPenaltyList	;a2 = team. Walk the penalty box list ($9C, 94 $9A): the first two players without a coincidental
	;penalty count down one second and the rest wait. Beeps when the first served time gets to 5 or less and releases the player at 0
	lea	$9C(a2),a0
	movea.w	#(mesarea-M68K_RAM),a1	;serving players
	moveq	#2,d1	;two can serve at once
	moveq	#2,d3
.next
	clr.w	d0
	move.b	(a0)+,d0
	bmi.w	.done
	btst	#6,tmpdst(a2,d0.w)	;coincidental
	bne.w	.coinpen
	subq.w	#1,d1
	bmi.s	.next
	move.w	d0,(a1)+
	subq.w	#1,tmpdst(a2,d0.w)
	bne.w	.cont
	bsr.w	RemovePlayerFromList	;time is up
.cont
	bra.s	.next
.done
	move.w	(mesarea).w,d0	;first serving player
	cmp.w	#1,d1	;one serving
	beq.w	.5
	tst.w	d1
	bne.w	.3
	bsr.w	.5
	bra.w	.two
.3
	cmp.w	#$FFFF,d1
	bne.w	rtspen
.two
	move.w	(TextBuffer).w,d0
.5
	cmpi.w	#5,tmpdst(a2,d0.w)
	bgt.w	rtspen
	move.w	#1,-(sp)	;SFXbeep1
	tst.w	tmpdst(a2,d0.w)
	bne.w	.6
	bsr.w	releasepl
	move.w	#2,(sp)	;SFXbeep2
.6
	jsr	(sfx).l
	rts
.coinpen
	subq.w	#1,tmpdst(a2,d0.w)	;coincidental penalty
	btst	#3,tmpdst(a2,d0.w)
	beq.s	.next
	btst	#4,tmpdst(a2,d0.w)
	bne.w	.clr
	move.w	#$1000,tmpdst(a2,d0.w)
	bra.w	RemovePlayerFromList
.clr
	clr.w	tmpdst(a2,d0.w)	;falls into RemovePlayerFromList

RemovePlayerFromList	;Remove the entry before a0 from a penalty box list by shifting the rest down. Return a0 =
	;removed slot
	moveq	#$FFFFFFFF,d2
.shift
	addq.w	#1,d2
	move.b	(a0,d2.w),-1(a0,d2.w)
	bpl.s	.shift
	subq.w	#1,a0
	rts

releasepl	;The player's penalty time is up, so let him out (if appropriate). a2 = team, d0 = player * 2
	movem.l	d0-d3/a0-a3,-(sp)
	movea.w	tmsort(a2),a3
	suba.w	#SCstruct,a3
.0
	adda.w	#SCstruct,a3	;first sort obj not on the ice
	tst.w	position(a3)
	bpl.s	.0
	move.w	d0,d3
	lsr.w	#1,d3
	move.w	tmap(a2),d1
	addq.w	#1,tmap(a2)
	bset	#0,(tmstruct+tmflags).w	;home tmflags: tmflcc
	bset	#0,(AwShots+tmflags).w	;visitors tmflags: tmflcc
	movea.l	#priolist,a0
	tst.w	tmgoalie(a2)
	bpl.w	.gin
	addq.w	#1,a0
.gin
	clr.w	position(a3)
	move.b	(a0,d1.w),position+1(a3)
	jsr	(Setplass).l
	bsr.w	setplayer
	bset	#2,pflags2(a3)
	movem.l	(sp)+,d0-d3/a0-a3
	rts

checkfornewpen	;Look for a new penalty (entered through AddPenalty / AddPenalty2)
	btst	#7,(sflags).w
	bne.w	rtspen
	movea.w	#(PenBuf-M68K_RAM),a0
.0
	tst.w	(a0)+
	beq.w	rtspen
	btst	#2,(gmode).w
	bne.w	.iscalled
	clr.w	d0
	move.b	-2(a0),d0
	movea.l	#Penaltylist,a1
	adda.w	(a1,d0.w),a1
	tst.b	1(a1)	;time for penalty
	beq.w	.callit
	move.w	(puckc).w,d0
	bmi.w	.3
	subq.w	#6,d0
	move.b	-1(a0),d1	;player penalized
	ext.w	d1
	subq.w	#6,d1
	eor.w	d1,d0
	bmi.w	.3
.callit
	bsr.w	Stop4Pen
.iscalled
	bset	#7,-1(a0)
	bne.s	.0
	clr.w	d0
	move.b	-2(a0),d0	;penalty called
	movea.l	#Penaltylist,a1
	adda.w	(a1,d0.w),a1
	clr.w	d1
	move.b	(a1),d1	;delay for stopping action
	asl.w	#5,d1
	cmp.w	(Pencntdwn).w,d1
	ble.s	.0
	move.w	d1,(Pencntdwn).w
	bra.s	.0
.3
	bset	#3,(gmode).w
	bne.s	.0
	move.w	#$2C,d0	;delayed penalty (92 used $24)
	bsr.w	SetPA
	bra.s	.0

UpdatePA	;Animate the ref in the ref window (RefCnt, SetPA2); game over (RefPen 4): ShowThreeStars; penmsgtimer
	tst.w	(RefCnt).w
	bmi.w	rtspen
	sub.w	d7,(RefCnt).w
	bpl.w	.0
	bsr.w	SetPA2
.0
	cmpi.w	#4,(RefPen).l	;game over (92 used 4)
	bne.w	.1
	jsr	(ShowThreeStars).l
.1
	sub.w	d7,(penmsgtimer).w
	bpl.w	rtspen
	move.w	#$7FFF,(penmsgtimer).w
	rts

SetPA	;Start ref animation d0 (penalty number); from $2E up ignored. prefmes, goal ($E): ShowGoalBox
	;Shootout: ShootoutWonBy. Falls into SetPA2
	move.w	d0,(RefPen).w
	cmp.w	#$2E,d0
	blt.w	.0
	rts
.0
	clr.w	(RefStep).w
	bsr.w	prefmes
	cmp.w	#$E,d0	;goal (92 used 6)
	bne.w	.1
	jsr	(ShowGoalBox).l
.1
	btst	#0,(gmode2).w
	beq.w	.2
	btst	#3,(gmode2).w
	beq.w	.2
	jsr	(ShootoutWonBy).l
.2
	move.w	#$7FFF,(penmsgtimer).w
	btst	#7,(sflags).w
	beq.w	SetPA2
	move.w	#$3C,(penmsgtimer).w	;60

SetPA2	;Update the ref animation: next frame / delay pair from the Penaltylist animation
	movem.l	d0-d2/a0-a1,-(sp)
	moveq	#$40,d0	;clear ref window
	tst.w	(RefStep).w
	bmi.w	.pr
	move.w	(RefStep).w,d0
	addq.w	#2,(RefStep).w
	move.w	(RefPen).w,d1
	movea.l	#Penaltylist,a0
	adda.w	(a0,d1.w),a0
	addq.w	#2,a0
	adda.w	(a0),a0
	move.w	(a0,d0.w),d0
	bpl.w	.0
	neg.w	d0	;negative = last frame
	st	(RefStep).w
.0
	clr.w	d1
	move.b	d0,d1
	asl.w	#3,d1
	move.w	d1,(RefCnt).w
	btst	#0,(gmode2).w
	beq.w	.1
	btst	#3,(gmode2).w
	beq.w	.1
	move.w	d0,-(sp)
	move.w	(RefCnt).w,d0
	add.w	d0,d0
	move.w	d0,(RefCnt).w
	move.w	(sp)+,d0
.1
	lsr.w	#8,d0
.pr
	bsr.w	PushRef
	movem.l	(sp)+,d0-d2/a0-a1
	rts

PushRef	;Tell vblank what to display: ref frame d0 (RefTiles, RefTilesHor in the horizontal rink) into RefRamMap; $40
	;clears the window
	movem.l	d0-d2/a0-a1,-(sp)
	cmp.w	#$40,d0
	beq.w	.clearit
	mulu.w	#$70,d0	;refwidth*refheight*2
	movea.l	#RefTiles,a0
	btst	#7,(sflags).w
	beq.w	.m1
	movea.l	#RefTilesHor,a0
.m1
	adda.l	4(a0),a0
	addq.w	#4,a0
	adda.w	d0,a0
	movea.w	#(RefRamMap-M68K_RAM),a1
	move.w	(ExtraChars).w,d2
	ori.w	#$8000,d2	;priority
	moveq	#$37,d0	;(refheight*refwidth)-1
.1
	move.w	(a0)+,(a1)
	add.w	d2,(a1)+
	dbf	d0,.1
	bset	#1,(sflags2).w
	bra.w	.ex
.clearit
	btst	#7,(sflags).w
	bne.w	.4
	movea.w	#(RefRamMap-M68K_RAM),a1
	moveq	#$37,d0	;(refheight*refwidth)-1
.3
	move.w	#$7FF,(a1)+	;blank tile
	dbf	d0,.3
	bset	#1,(sflags2).w
.4
	moveq	#$FFFFFFFF,d0
	bsr.w	prefmes
.ex
	movem.l	(sp)+,d0-d2/a0-a1
	rts

prefmes	;Print the message for penalty d0 (negative clears it) under the ref
	movem.l	d0-d2/a1,-(sp)
	btst	#7,(sflags).w
	bne.w	.3
	tst.w	d0
	bpl.w	.0
	jsr	(printz).l
	String	-(TXPRI+TXMAP1),0,$A,0
	moveq	#$D,d0
	moveq	#3,d1
	move.w	#$7FF,d2	;blank tile
	jsr	(eraser).l
	bra.w	.ex
.0
	jsr	(printz).l
	String	-(TXPRI+TXMAP1),5,$A,0
	movea.l	#Penaltylist,a1
	adda.w	(a1,d0.w),a1
	addq.w	#2,a1
	move.w	(a1),d0
	subq.w	#2,d0	;empty string
	beq.w	.ex
	lsr.w	#1,d0
	sub.w	d0,(printx).w
	bpl.w	.nb0
	clr.w	(printx).w
.nb0
	move.w	(a1),d0
	tst.b	-1(a1,d0.w)
	bne.w	.2
	subq.w	#1,d0
.2
	moveq	#3,d1
	jsr	(Framer).l
	subq.w	#2,(printy).w
	addq.w	#1,(printx).w
	jsr	(print).l
	bra.w	.ex
.3
	tst.w	d0
	bmi.w	.ex
	jsr	(printz).l
	String	-(TXPRI+TXMAP1),$11,$B,$0
	movea.l	#Penaltylist,a1
	adda.w	(a1,d0.w),a1
	addq.w	#2,a1
	move.w	(a1),d0
	lsr.w	#1,d0
	sub.w	d0,(printx).w
.ex
	movem.l	(sp)+,d0-d2/a1
	rts

ClearPenaltyMessage	;Blank the horizontal mode penalty message line (22 spaces at x 5, y $B). Unreferenced
	jsr	(printz).l
	String	-(TXPRI+TXMAP1),5,$B,'                      '
	rts

;------------------------------------------------------------------------------------------------------------------------
;	checkagr, showref, ClearPenaltyBuffer, ClearPenalties / clrTmPdst, puckIChk, ChkOffsides and checkob.
;	95 changes: the goal line $10B (94 $108), the blue line $52 (94 $54), checkagr's base $32 and the sflags9
;	penalty options.



checkagr	;Aggression check: d0 = randomd0((($32 - Agr) / 2) * 13) (94 $28), doubled for a pad player, halved within
	;$28 of the puck; a2 on a breakaway ($64 bit 1) rolls again (8 / 7 / 4 / 3 by his distance from the goal line). 95: d0 = $7F (no
	;penalty) when sflags9 bit 2 (home checker) / bit 1 (away) is set. The callers call a penalty when d0 is small
	move.w	#$32,d0
	sub.b	aggress(a3),d0	;Agr(a3) - subtract Agr from d0
	lsr.b	#1,d0	;divide result by 2
	mulu.w	#$D,d0	;multiply d0 with 13 decimal
	btst	#3,pflags(a3)
	beq.w	.checkpos
	asl.w	#1,d0	;multiply by 2
.checkpos
	move.w	(a3),d1	;XPos
	sub.w	(puckx).w,d1	;subtract x pos of puck with X pos of player
	cmp.w	#$28,d1	;Checking position with respect to puck
	bgt.w	.1
	cmp.w	#$FFD8,d1	;checking the inverse position (other side of rink)
	blt.w	.1
	move.w	Ypos(a3),d1
	sub.w	(pucky).w,d1
	cmp.w	#$28,d1	;same as above
	bgt.w	.1
	cmp.w	#$FFD8,d1	;checking the inverse position (other side of rink)
	blt.w	.1
	asr.w	#1,d0	;divide by 2
.1
	jsr	(randomd0).l
	btst	#pf3break,pflags3(a2)	;Check for player on breakaway
	beq.w	.teamchk
	move.w	Ypos(a2),d1	;Ypos of player being checked
	bpl.w	.2
	neg.w	d1	;flip result (other side of rink)
.2
	subi.w	#$10B,d1
	neg.w	d1	;flip Y pos
	move.w	#8,d0	;move 8 into d0. Removes any trace of Agr here
	cmp.w	#$78,d1
	bgt.w	.3
	move.w	#7,d0	;move 7 into d0
	cmp.w	#$3C,d1
	bgt.w	.3
	move.w	#4,d0	;moves 4 into d0
	cmp.w	#$2D,d1
	bgt.w	.3
	move.w	#3,d0	;finally, just move 3 in d0
.3
	jsr	(randomd0).l
.teamchk
	btst	#6,pflags(a3)
	bne.w	.5
	btst	#2,(sflags9).w
	bne.w	.nopen
	bra.w	.end
.5
	btst	#1,(sflags9).w
	beq.w	.end
.nopen
	move.w	#$7F,d0
.end
	rts

showref	;Ref window: when sflags2 bit 1 is set add the 8 RefRamMap rows to the dma list at a5 (VmMap1)
	bclr	#1,(sflags2).w
	beq.w	rtspen
	movea.w	#(RefRamMap-M68K_RAM),a0
	movea.w	#(VmMap1-M68K_RAM),a1
	move.w	2(a1),d2
	moveq	#2,d0	;refy: Xpos on ice screen
	btst	#7,(sflags).w
	beq.w	*+4
.0
	asl.w	d2,d0
	moveq	#2,d1
	asl.w	d2,d1
	addq.w	#2,d0
	btst	#7,(sflags).w
	beq.w	*+4
.1
	asl.w	#1,d0
	add.w	(a1),d0
	moveq	#7,d2
.2
	move.l	a0,(a5)+
	move.w	#7,(a5)+
	move.w	d0,(a5)+
	adda.w	#$E,a0
	add.w	d1,d0
	dbf	d2,.2
	rts

ClearPenaltyBuffer	;Clear PenBuf
	moveq	#$1F,d0	;MaxPen-1
	movea.w	#(PenBuf-M68K_RAM),a0
.loop
	clr.w	(a0)+
	dbf	d0,.loop
	rts

ClearPenalties	;Clear the penalties: PBnum, Penaltytimer, Pencntdwn, PenBuf and both teams' penalty slots (clrTmPdst)
	movem.l	d0/a0,-(sp)
	clr.w	(PBnum).w
	clr.w	(Penaltytimer).w
	clr.w	(Pencntdwn).w
	move.w	#$10,d0
	movea.l	#PenBuf,a0
.loop
	clr.l	(a0)+
	dbf	d0,.loop
	movea.l	#tmstruct,a0
	bsr.w	clrTmPdst
	movea.l	#AwShots,a0
	bsr.w	clrTmPdst
	movem.l	(sp)+,d0/a0
	rts

clrTmPdst	;Set the 26 tmpdst words of team a0 to -2 (bench), then -1
	move.w	#$19,d0	;19 = 25 decimal (max roster size)
	adda.w	#$68,a0
.loop
	move.w	#$FFFE,(a0)+	;-2 = bench
	dbf	d0,.loop
	move.w	#$FFFF,(a0)	;-1 = ice
	rts

puckIChk	;Icing check: once the puck is loose (puckc negative) past the goal line ($10B, 94 $108) set iflags bit 0
	;(ifcgl), unless it went in the crease ($2C either side), which clears bit 2 (ifok)
	btst	#2,(iflags).w	;#ifok
	beq.w	.0
	btst	#0,(iflags).w	;#ifcgl - if crossed goal line
	bne.w	.0
	tst.w	(puckc).w
	bpl.w	.0
	move.w	#$10B,d0
	btst	#1,(iflags).w
	bne.w	.1
	neg.w	d0
	cmp.w	(pucky).w,d0	;check other goalline
	bgt.w	.chkx
.0
	rts
.1
	cmp.w	(pucky).w,d0
	bgt.s	.0
.chkx
	cmpi.w	#$2C,(puckx).w	;',' ; 2C - edge of crease
	bgt.w	.set
	cmpi.w	#$FFD4,(puckx).w	;-$2C, the edge of the crease
	blt.w	.set
	bclr	#2,(iflags).w	;#ifok cleared
	rts
.set
	bset	#0,(iflags).w	;#ifcgl
	rts

ChkOffsides	;Offsides: clear the flag of a team that is all back onside (.8), then when
	;puck a3 crosses a blue line ($52, 94 $54) set tmflags bit 4 of the team with a player ahead of it
	btst	#5,(gmode).w
	beq.w	.3
	btst	#2,(BA_PS_flags).w
	bne.w	.3
	movea.w	#(tmstruct-M68K_RAM),a1
	lea	tmsize(a1),a2
	bsr.w	.8
	exg	a1,a2
	bsr.w	.8
	move.w	#$52,d0
	cmp.w	Ypos(a3),d0
	bgt.w	.neg
	cmp.w	OldYpos(a3),d0
	ble.w	.3
	addi.w	#$A,d0
	btst	#1,(gmode).w
	beq.w	.0
	exg	a2,a1
.0
	moveq	#5,d2
	movea.w	tmsort(a2),a0
.1
	tst.w	position(a0)
	bmi.w	.2
	cmp.w	Ypos(a0),d0
	bge.w	.2
	bset	#4,tmflags(a2)
	rts
.2
	adda.w	#SCstruct,a0
	dbf	d2,.1
.3
	rts
.neg
	neg.w	d0
	cmp.w	Ypos(a3),d0
	blt.s	.3
	cmp.w	OldYpos(a3),d0
	bge.s	.3
	subi.w	#$A,d0
	btst	#1,(gmode).w
	bne.w	.5
	exg	a2,a1
.5
	moveq	#5,d2
	movea.w	tmsort(a2),a0
.6
	tst.w	position(a0)
	bmi.w	.7
	cmp.w	Ypos(a0),d0
	ble.w	.7
	bset	#4,tmflags(a2)
	rts
.7
	adda.w	#SCstruct,a0
	dbf	d2,.6
	rts
.8
	btst	#4,tmflags(a2)
	beq.s	.3
	movea.w	tmsort(a2),a0
	moveq	#5,d1
.9
	tst.w	position(a0)
	bmi.w	.10
	move.w	Ypos(a0),d0
	btst	#7,pflags(a0)
	bne.w	.10
	neg.w	d0
.10
	adda.w	#SCstruct,a0
	cmp.w	#$65,d0
	dbgt	d1,.9
	bgt.s	.3
	bclr	#4,tmflags(a2)
	rts

Penaltylist	;Penalty number = word offset into this table; the same entries as 94.
	;Used by AddPenalty, SetPA2, prefmes, PenaltyShotBox
	dc.w	$0000
	dc.w	.eop-Penaltylist	;$2 period over
	dc.w	.eog-Penaltylist	;$4 game over
	dc.w	.ghold-Penaltylist	;$6
	dc.w	.ghold-Penaltylist	;$8
	dc.w	.whistle-Penaltylist	;$A whistle
	dc.w	.ice-Penaltylist	;$C icing
	dc.w	.goal-Penaltylist	;$E goal
	dc.w	.offsides-Penaltylist	;$10 offsides
	dc.w	.rough2-Penaltylist	;$12 roughing, slow down time $A
	dc.w	.p14-Penaltylist	;$14 no text
	dc.w	.charge-Penaltylist	;$16
	dc.w	.slash-Penaltylist	;$18
	dc.w	.rough-Penaltylist	;$1A
	dc.w	.cross-Penaltylist	;$1C
	dc.w	.hook-Penaltylist	;$1E
	dc.w	.trip-Penaltylist	;$20
	dc.w	.int-Penaltylist	;$22
	dc.w	.hold-Penaltylist	;$24
	dc.w	.fight-Penaltylist	;$26
	dc.w	.fight2-Penaltylist	;$28
	dc.w	.inst-Penaltylist	;$2A
	dc.w	.delay-Penaltylist	;$2C delay
	dc.w	.hookps-Penaltylist	;$2E penalty shot
	dc.w	.tripps-Penaltylist	;$30 penalty shot
	dc.w	.ghold2-Penaltylist	;$32 face off, no slow down
	dc.w	.intps-Penaltylist	;$34 penalty shot
	dc.w	.roughps-Penaltylist	;$36 penalty shot
	dc.w	.chargeps-Penaltylist	;$38 penalty shot
	dc.w	.crossps-Penaltylist	;$3A penalty shot
	dc.w	.slashps-Penaltylist	;$3C penalty shot
.eop	dc.w	$0100
	String	'Period Over'
	dc.w	-$0510
.eog	dc.w	$0100
	String	'Game Over'
	dc.w	$0510,-$4060
.goal	dc.w	$0100
	dc.w	2	;String with no text
	dc.w	$050A,-$4018
.p14	dc.w	$0100
	dc.w	2	;String with no text
	dc.w	$0510,-$4018
.ice	dc.w	$0100
	String	'Icing'
	dc.w	$0002,$0101,-$0206
.offsides	dc.w	$0100
	String	'Off-side'
	dc.w	$0002,$0301,-$040F
.ghold	dc.w	$0100
	String	'Face Off'
	dc.w	-$050A
.ghold2	dc.w	$0000
	String	'Face Off'
	dc.w	-$050A
.delay	dc.w	$0000
	String	'Penalty'
	dc.w	$0003,$0301,-$0408
.whistle	dc.w	$0000
	dc.w	2	;String with no text
	dc.w	-$050A
.charge	dc.w	$0402
	String	'Charging'
	dc.w	$0004,$0101,$0A01,$0B01,$0A01,$0B01,$0A01,$0B01,$0A01,$0B01,-$0101
.chargeps	dc.w	$04FF
	String	'Charging'
	dc.w	$0004,$0101,$0A01,$0B01,$0A01,$0B01,$0A01,$0B01,$0A01,$0B01,-$0101
.slash	dc.w	$0402
	String	'Slashing'
	dc.w	$0004,$0101,$0201,$0301,$0201,$0301,$0201,$0301,$0201,$0301,-$0101
.slashps	dc.w	$04FF
	String	'Slashing'
	dc.w	$0004,$0101,$0201,$0301,$0201,$0301,$0201,$0301,$0201,$0301,-$0101
.trip	dc.w	$0402
	String	'Tripping'
	dc.w	$0004,$0401,$0501,$0401,$0501,$0401,$0501,$0401,$0501,-$0101
.tripps	dc.w	$04FF
	String	'Tripping'
	dc.w	$0004,$0401,$0501,$0401,$0501,$0401,$0501,$0401,$0501,-$0101
.rough2	dc.w	$0A02
	String	'Roughing'
	dc.w	$0004,$0D01,$0E01,$0D01,$0E01,$0D01,$0E01,$0D01,$0E01,-$0101
.rough	dc.w	$0402
	String	'Roughing'
	dc.w	$0004,$0D01,$0E01,$0D01,$0E01,$0D01,$0E01,$0D01,$0E01,-$0101
.roughps	dc.w	$04FF
	String	'Roughing'
	dc.w	$0004,$0D01,$0E01,$0D01,$0E01,$0D01,$0E01,$0D01,$0E01,-$0101
.hook	dc.w	$0402
	String	'Hooking'
	dc.w	$0004,$0101,$0901,$0801,$0901,$0801,$0901,$0801,$0901,$0801,-$0101
.hookps	dc.w	$04FF
	String	'Hooking'
	dc.w	$0004,$0101,$0901,$0801,$0901,$0801,$0901,$0801,$0901,$0801,-$0101
.cross	dc.w	$0402
	String	'Cross Check'
	dc.w	$0004,$0601,$0F01,$1001,$0F01,$1001,$0F01,$1001,$0F01,$1001,-$0101
.crossps	dc.w	$04FF
	String	'Cross Check'
	dc.w	$0004,$0601,$0F01,$1001,$0F01,$1001,$0F01,$1001,$0F01,$1001,-$0101
.int	dc.w	$0402
	String	'Interference'
	dc.w	$0004,$0101,$0C06,-$0101
.intps	dc.w	$04FF
	String	'Interference'
	dc.w	$0004,$0101,$0C06,-$0101
.hold	dc.w	$0402
	String	'Holding'
	dc.w	$0004,$0101,$0706,-$0101
.fight	dc.w	$2805
	String	'Fighting'
	dc.w	$0004,$0D01,$0E01,$0D01,$0E01,$0D01,$0E01,$0D01,$0E01,-$0101
.fight2	dc.w	$2805
	String	'Fighting *'
	dc.w	$0004,$0D01,$0E01,$0D01,$0E01,$0D01,$0E01,$0D01,$0E01,-$0101
.inst	dc.w	$2802
	String	'Fight Instigator'
	dc.w	$0004,$0D01,$0E01,$0D01,$0E01,$0D01,$0E01,$0D01,$0E01,-$0101

checkob	;Offside watch (gmode bit 5): with a player of the attacking side past the blue line ($5A) ahead of the puck
	;the ref raises his arm (PushRef 6, sflags2 bit 7), back to $40 when they are onside
	btst	#5,(gmode).w
	beq.w	rtspen
	btst	#2,(BA_PS_flags).w
	bne.w	rtspen
	movem.l	d0-d1/a0,-(sp)
	moveq	#5,d0
	movea.w	#(SortCords-M68K_RAM),a0
	cmpi.w	#6,SCnum(a3)
	blt.w	.0
	adda.w	#$300,a0
.0
	moveq	#$5A,d1
	btst	#7,pflags(a3)
	bne.w	.top
	neg.w	d1
	cmp.w	(pucky).w,d1
	bgt.w	.3
.1
	tst.w	position(a0)
	bmi.w	.2
	cmp.w	Ypos(a0),d1
	bgt.w	.5
.2
	adda.w	#SCstruct,a0
	dbf	d0,.1
.3
	moveq	#$40,d0
	bclr	#7,(sflags2).w
	bne.w	.dref
.ex
	movem.l	(sp)+,d0-d1/a0
	rts
.5
	moveq	#6,d0
	bset	#7,(sflags2).w
	bne.s	.ex
.dref
	tst.w	(RefCnt).w
	bpl.s	.ex
	bsr.w	PushRef
	bra.s	.ex
.top
	cmp.w	(pucky).w,d1
	blt.s	.3
.8
	tst.w	position(a0)
	bmi.w	.9
	cmp.w	Ypos(a0),d1
	blt.s	.5
.9
	adda.w	#SCstruct,a0
	dbf	d0,.8
	bra.s	.3

PenShotPenalties	;The penalty shot penalty number for penalty number d0 (word offset), -1 none. Used by PenShotChk
	dc.w	-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,$38,$3C
	dc.w	$36,$3A,$2E,$30,$34,-1,-1,-1,-1,-1,-1,-1

linelist	;Text list for the line choices. Used by SetLCmode2 and DrawFaceoffWindow
	String	'Sc1'
	String	'Sc2'
	String	'Chk'
	String	'PP1'
	String	'PP2'
	String	'PK1'
	String	'PK2'
