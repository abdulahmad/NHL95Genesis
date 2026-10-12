;	Pad control and team setup. This file connects each pad to the player it controls, with
;	holding, checking, speed bursts and switching players, and then sets up both teams with their
;	structures and colors before a game.

updatepadinput	;Pad input for a player. Called from updateplayers with a3 = the
	;object, d6 = SCnum. The pad (1-4) controlling a3 reads its buttons and runs doinput, with d4 = 0 / 2 / 4 / 6 (94 swaps the pad 3 /
	;4 variables into pads 1 / 2). Then the assignment, collisions and the impact decay
	cmp.w	(c1playernum).w,d6	;check if cont 1 is puck carrier
	bne.w	.t0
	jsr	(ReadJoy1).l
	clr.w	d4	;pad index for cont 1 player
	move.w	#$FFFF,(joypuckcarrier).w
	jsr	(doinput).l	;B button
	bra.w	.t1
.t0
	cmp.w	(c2playernum).w,d6	;check if cont 2 is puck carrier
	bne.w	.t1
	jsr	(ReadJoy2).l
	move.w	#2,d4	;pad index for cont 2 player
	move.w	#$FFFF,(joypuckcarrier).w
	jsr	(doinput).l
.t1
	cmp.w	(c3playernum).w,d6
	bne.w	.t3
	jsr	(ReadJoy3).l
	move.w	#4,d4
	move.w	#$FFFF,(joypuckcarrier).w
	jsr	(doinput).l
.t3
	cmp.w	(c4playernum).w,d6
	bne.w	.t1cont
	jsr	(ReadJoy4).l
	move.w	#6,d4
	move.w	#$FFFF,(joypuckcarrier).w
	jsr	(doinput).l
.t1cont
	jsr	(doassignment).l	;94 does the asstab call in line
	clr.w	Wallcos(a3)	;clear wallcos
	clr.w	Wallsin(a3)	;clear wallsin
	move.w	(a3),d2	;Xpos
	move.w	Ypos(a3),d3	;Ypos
	cmp.w	OldXpos(a3),d2	;compare to oldXpos
	bne.w	.cc	;branch if not equal
	cmp.w	OldYpos(a3),d3	;compare to oldYpos
	beq.w	.nf	;branch if equal
.cc
	jsr	(checkcoll).l	;check for collisions
.nf
	move.w	d7,d0	;move d7 into d0 (elapsed frames)
	asl.w	#1,d0	;mult by 2
	sub.w	d0,impact(a3)	;reduce impact at a constant rate
	bpl.w	.nf1	;branch if positive
	clr.w	impact(a3)	;clear impact if negative or zero
.nf1
	move.w	impact(a3),limpact(a3)	;move impact into limpact
	rts

; A button press hold
; CPU hold jumps in at Acheck
;
; a3 = holder
; a0 = player being held
holdplayer	;Jumped to from doinput
	bset	#pfalock,pflags(a3)	;lock animation
	move.w	#SPAhook,d1	;move anim into d1 - normal hold check
	tst.w	impact(a3)	;check if impact = 0
	beq.w	.0	;set anim if 0
	movea.w	#(SortCords-M68K_RAM),a0	;move SortCord into a0
	move.w	impactp(a3),d0	;move last impact player into d0
	asl.w	#7,d0	;calc offset
	adda.w	d0,a0	;add offset to a0
	bra.w	Acheck
.0
	jsr	(chkblock).l
	jmp	(SetSPA).l
Acheck	;Hold check for a3 on player a0 (the CPU jumps in here): SPAHold (stick in the air) or SPAhook by Ypos of a3 - a0
	;and the goal a3 shoots at (pfgoal); SPAhook with no impact
	bset	#pfalock,pflags(a3)	;lock animation
	move.w	#SPAhook,d1	;move anim into d1 - normal hold check
	tst.w	impact(a3)	;check if impact = 0
	beq.w	.ex	;branch if 0
	move.w	Ypos(a3),d0	;move Ypos checker into d0
	sub.w	Ypos(a0),d0	;sub Ypos of player
	btst	#pfgoal,pflags(a3)	;check goal checker is shooting at
	beq.w	.air	;jump if bottom
	neg.w	d0	;make d0 negative
.air
	bmi.w	.ex
	move.w	#SPAHold,d1	;set anim - hold check stick in air
.ex
	jmp	(SetSPA).l

; c button press check/speed
burstchk	;No burst while the animation is locked. Jumped to from doinput
	btst	#pfalock,pflags(a3)
	beq.w	burst
	rts
burst	;C button speed burst: take $CC energy unless OptLine is set, add a facedir push to Xvel / Yvel and set SPAburst.
	jsr	(getpde).l	;get players energy
	tst.w	(OptLine).w
	bne.w	.0
	subi.w	#$CC,d0
	jsr	(setpde).l	;decrease players energy
	btst	#4,(sflags7).w
	beq.w	.0
	move.w	#$1000,d0
.0
	lsr.w	#7,d0	;d0 will be $1000 with lines off
	;d0 / 64 will be 20 hex if max energy
	move.w	d0,d1	;energy = speed increase (check violence)
	move.w	facedir(a3),d2	;facedir
	asl.w	#2,d2
	movea.l	#dirtab,a0
	muls.w	(a0,d2.w),d0
	muls.w	2(a0,d2.w),d1
	btst	#pfjoycon,pflags(a3)	;no effect, both ways add
	beq.w	.add
.add
	add.w	d0,Xvel(a3)	;add to X Vel
	add.w	d1,Yvel(a3)	;add to Y Vel
	bra.w	.anim
.anim
	bclr	#pfdoff,pflags(a3)
	cmpi.w	#SPAskatewp,SPA(a3)	;the puck carrier keeps skating
	beq.w	.x
	bset	#pfalock,pflags(a3)	;lock in this animation
	cmpi.w	#SPAskate,SPA(a3)
	beq.w	.skate
	bra.w	.set
.skate
	movem.l	d0,-(sp)
	move.w	SPAnum(a3),d0
	andi.w	#7,d0
	clr.w	d0
	move.w	#SPAburst,d1
	jsr	(SetSPA).l
	move.w	d0,SPAnum(a3)
	movem.l	(sp)+,d0
.x
	rts
.set
	move.w	#SPAburst,d1
	jmp	(SetSPA).l

setpads	;Put SCnum of a3 in the d4 nibble of PadControlBits ; d4 = -2 puck carrier, 0 / 2 / 4 / 6 pads.
	;a long (94: a word)
	movem.l	d0-d1,-(sp)
	moveq	#2,d0
	add.w	d4,d0
	add.w	d0,d0
	moveq	#-$10,d1
	rol.l	d0,d1
	and.l	d1,(PadControlBits).w
	clr.l	d1
	move.w	SCnum(a3),d1
	asl.l	d0,d1
	or.l	d1,(PadControlBits).w
	movem.l	(sp)+,d0-d1
	rts

chgplayer	;The pad d4 takes the nearest free skater to where the puck is going (not a goalie, not locked or
	;unavailable; in a penalty shot / shootout only BA_Sktr_SCnum or BA_Goalie_SCnum), or sweep checks when it is the same one. 95:
	;with no skater found and no player on the pad, a second pass that also takes the goalie. Jumped to from doinput
	btst	#6,(sflags5).w	;Check bit 6
	bne.w	.exit
	movem.l	d0-d6/a0-a1,-(sp)
	move.w	(puckvx).w,d0	;lead puck slightly
	asr.w	#8,d0
	add.w	(puckx).w,d0
	move.w	(puckvy).w,d1
	asr.w	#8,d1
	add.w	(pucky).w,d1
	movem.w	d0-d1,-(sp)
	moveq	#5,d2
	move.w	d4,d3
	eori.w	#2,d3	;other controller
	moveq	#-1,d5	;-1
	movea.w	#(SortCords-M68K_RAM),a0	;start of search
	movea.w	#(cont1team-M68K_RAM),a1
	cmpi.w	#1,(a1,d4.w)
	beq.w	.t1
	adda.w	#$300,a0	;controller is on other team
.t1
	movea.w	#(c1playernum-M68K_RAM),a1
.top
	tst.w	position(a0)	;position
	ble.w	.next	;cant switch to goalie
	btst	#2,pflags2(a0)	;#pf2unav
	bne.w	.next	;this player is unavailable for some reason
	movem.w	d1,-(sp)
	move.w	SCnum(a0),d1	;SCnum
	cmp.w	(a1,d4.w),d1
	movem.w	(sp)+,d1
	beq.w	.0
	btst	#pfjoycon,pflags(a0)	;is player controlled?
	bne.w	.next	;yes branch
.0
	btst	#2,(BA_PS_flags).w
	beq.w	.1
	movem.l	d0,-(sp)
	move.w	(BA_Sktr_SCnum).w,d0
	cmp.w	SCnum(a0),d0
	movem.l	(sp)+,d0
	beq.w	.1
	movem.l	d0,-(sp)
	move.w	(BA_Goalie_SCnum).w,d0
	cmp.w	SCnum(a0),d0
	movem.l	(sp)+,d0
	bne.w	.next
.1
	movem.w	d1,-(sp)	;the pad's own player may be locked
	move.w	SCnum(a0),d1
	cmp.w	(a1,d4.w),d1
	movem.w	(sp)+,d1
	beq.w	.2
	btst	#pfalock,pflags(a0)	;#pfalock
	bne.w	.next	;player is locked
.2
	movem.w	(sp),d0-d1
	sub.w	(a0),d0	;Xpos
	muls.w	d0,d0
	sub.w	Ypos(a0),d1	;Ypos
	muls.w	d1,d1
	add.l	d1,d0
	cmp.l	d5,d0
	bhi.w	.next
	move.w	SCnum(a0),d1	;Scnum
	cmp.w	(a1,d3.w),d1
	beq.w	.next	;this is current player
	move.l	d0,d5
	move.w	d1,d6
.next
	adda.w	#SCstruct,a0	;size of SCstruct
	dbf	d2,.top
	tst.l	d5
	bpl.w	.found
	tst.w	(a1,d4.w)
	bpl.w	.found
	move.w	#5,d2
	bra.w	.pass2
.found
	addq.w	#4,sp
	pea	(.ex).l
	cmp.w	(a1,d4.w),d6
	beq.w	.same	;player is same so sweep check
	move.w	d6,d0	;d0 now is new player
	jmp	(setcplayer).l	;/ setc2player
.ex
	movem.l	(sp)+,d0-d6/a0-a1
.exit
	rts
.pass2	;As.top, but a goalie (position 0) may be taken
	moveq	#-1,d5
	movea.w	#(SortCords-M68K_RAM),a0
	movea.w	#(cont1team-M68K_RAM),a1
	cmpi.w	#1,(a1,d4.w)
	beq.w	.p1
	adda.w	#$300,a0
.p1
	movea.w	#(c1playernum-M68K_RAM),a1
.ptop
	tst.w	position(a0)
	blt.w	.pnext
	btst	#2,pflags2(a0)
	bne.w	.pnext
	movem.w	d1,-(sp)
	move.w	SCnum(a0),d1
	cmp.w	(a1,d4.w),d1
	movem.w	(sp)+,d1
	beq.w	.p0
	btst	#pfjoycon,pflags(a0)
	bne.w	.pnext
.p0
	btst	#2,(BA_PS_flags).w
	beq.w	.p2
	movem.l	d0,-(sp)
	move.w	(BA_Sktr_SCnum).w,d0
	cmp.w	SCnum(a0),d0
	movem.l	(sp)+,d0
	beq.w	.p2
	movem.l	d0,-(sp)
	move.w	(BA_Goalie_SCnum).w,d0
	cmp.w	SCnum(a0),d0
	movem.l	(sp)+,d0
	bne.w	.pnext
.p2
	movem.w	d1,-(sp)
	move.w	SCnum(a0),d1
	cmp.w	(a1,d4.w),d1
	movem.w	(sp)+,d1
	beq.w	.p3
	btst	#pfalock,pflags(a0)
	bne.w	.pnext
.p3
	movem.w	(sp),d0-d1
	sub.w	(a0),d0
	muls.w	d0,d0
	sub.w	Ypos(a0),d1
	muls.w	d1,d1
	add.l	d1,d0
	cmp.l	d5,d0
	bhi.w	.pnext
	move.w	SCnum(a0),d1
	cmp.w	(a1,d3.w),d1
	beq.w	.pnext
	move.l	d0,d5
	move.w	d1,d6
.pnext
	adda.w	#SCstruct,a0
	dbf	d2,.ptop
	bra.w	.found
.same
	btst	#pfalock,pflags(a3)	;no sweep check while locked
	beq.w	.swpchk
	rts
.swpchk	;Sweepcheck
	jmp	(Sweepcheck).l

setcplayer	;Give pad d4 (0 / 2 / 4 / 6) player d0: restorepl the old one, then
	;c1playernum + d4 = d0. Jumped to from chgplayer
	movem.l	d0/a0-a1,-(sp)
	movea.l	#c1playernum,a0
	cmp.w	(a0,d4.w),d0
	beq.w	.x
	move.w	(a0,d4.w),d1
	jsr	(restorepl).l
	move.w	d0,(a0,d4.w)
.x
	movem.l	(sp)+,d0/a0-a1
	rts
setc1player	;Jumped to from doinput
	move.w	d4,-(sp)
	clr.w	d4
	bsr.s	setcplayer
	move.w	(sp)+,d4
	rts
setc2player	;Give pad 2 player d0 (setcplayer, d4 = 2). 94 did it inline
	move.w	d4,-(sp)
	move.w	#2,d4
	bsr.s	setcplayer
	move.w	(sp)+,d4
	rts
setc3player	;Give pad 3 player d0 (setcplayer, d4 = 4)
	move.w	d4,-(sp)
	move.w	#4,d4
	bsr.s	setcplayer
	move.w	(sp)+,d4
	rts
setc4player	;Give pad 4 player d0 (setcplayer, d4 = 6)
	move.w	d4,-(sp)
	move.w	#6,d4
	bsr.s	setcplayer
	move.w	(sp)+,d4
	rts

restorepl	;d1 = old player (back to the computer), d0 = new player (joystick controlled)
	movem.l	a0,-(sp)
	movea.l	#SortCords,a0
	tst.w	d1
	blt.w	.spd
	cmp.w	#$B,d1
	bgt.w	.spd
	asl.w	#7,d1	;multiply d0 by 80 hex (SCsize)
	btst	#3,pflags2(a0,d1.w)	;#pfnp - no joystick pad
	beq.w	.cont
	lsr.w	#7,d1	;divide by 80 hex
	move.w	d1,d0
	bra.w	.ex
.cont
	bclr	#pfjoycon,pflags(a0,d1.w)	;#pfjoycon
	btst	#3,$64(a0,d1.w)	;bit 3, pflags3
	bne.w	.spd
	bset	#pfna,pflags(a0,d1.w)	;#pfna - new assignment
.spd
	tst.w	d0	;checks if d0 0 or higher
	blt.w	.ex
	cmp.w	#$B,d0	;checks if d0 11 or less
	bgt.w	.ex
	move.w	d0,d1	;copies d0 into d1
	asl.w	#7,d1
	btst	#2,(BA_PS_flags).w
	bne.w	.chkgoalie
	btst	#0,(gmode2).w
	beq.w	.3
.chkgoalie
	tst.w	position(a0,d1.w)
	bne.w	.3
	btst	#pfteam,pflags(a0,d1.w)	;check if home or away
	beq.w	.0
	tst.w	(goaliemode2).w
	bra.w	.1
.0
	tst.w	(goaliemode1).w
.1
	beq.w	.3
	bra.w	.ex	;the goalie stays with the computer (94: the first SCnum of the team)
.3
	bset	#pfjoycon,pflags(a0,d1.w)	;set pfjoycon for SCNum
.ex
	movem.l	(sp)+,a0
	rts

clearTeamStats	;Clear both team structs (2 x tmsize) but keep the first $1A0 bytes of each hot / cold table (HmShots+$1A4 /
	;AwShots+$1A4, saved to homehotcoldsave / awayhotcoldsave and back) and HmShots+tmgoalie / AwShots+tmgoalie. Falls into setteams
	move.w	(tmstruct+tmgoalie).w,-(sp)
	move.w	(AwShots+tmgoalie).w,-(sp)
	movem.l	a1-a3,-(sp)
	move.w	#$19F,d0
	movea.l	#AwShots+$1A4,a1	;Hot/Cold table Away Team (94: +$1A2)
	movea.l	#tmstruct+$1A4,a0	;Hot/Cold table Home Team
	movea.l	#homehotcoldsave,a2
	movea.l	#awayhotcoldsave,a3
.loop
	move.b	(a0)+,(a2)+
	move.b	(a1)+,(a3)+
	dbf	d0,.loop
	movem.l	(sp)+,a1-a3
	move.l	#tmsize-1,d0
	movea.w	#(tmstruct-M68K_RAM),a0
.loop2
	clr.b	(a0)+
	dbf	d0,.loop2
	movea.w	#(AwShots-M68K_RAM),a0
	move.w	#tmsize-1,d0
.loop3
	clr.b	(a0)+
	dbf	d0,.loop3
	movem.l	a1-a3,-(sp)
	move.w	#$19F,d0
	movea.l	#AwShots+$1A4,a1
	movea.l	#tmstruct+$1A4,a0
	movea.l	#homehotcoldsave,a2
	movea.l	#awayhotcoldsave,a3
.loop4
	move.b	(a2)+,(a0)+
	move.b	(a3)+,(a1)+
	dbf	d0,.loop4
	movem.l	(sp)+,a1-a3
	move.w	(sp)+,(AwShots+tmgoalie).w
	move.w	(sp)+,(tmstruct+tmgoalie).w
	st	(tmstruct+tmpdst+$34).w
	st	(AwShots+tmpdst+$34).w
setteams	;Use hometeam/visteam to set team structures (InitTeamStructure for each). Falls in from clearTeamStats
	movem.l	d0/a0-a2,-(sp)
	movea.w	#(tmstruct-M68K_RAM),a2
	move.w	(HomeTeam).w,d0
	move.w	#(SortCords-M68K_RAM),tmsort(a2)
	bsr.w	InitTeamStructure
	movea.w	#(AwShots-M68K_RAM),a2
	move.w	(VisTeam).w,d0
	move.w	#(SortCords-M68K_RAM)+(6*SCstruct),tmsort(a2)
	bsr.w	InitTeamStructure
	movem.l	(sp)+,d0/a0-a2
	rts

InitTeamStructure	;Set up team struct a2 for team d0: store the team number at $28 and the team data address
	;at $1E (tmdata), then LoadTeamLines (95; 94 copied the line sets here)
	move.w	d0,Xvel(a2)
	movea.w	#TeamList,a0
	asl.w	#2,d0
	move.l	(a0,d0.w),tmdata(a2)
	jmp	(LoadTeamLines).l

setplayercolors	;Copy in correct color data for each team: .team for the home team, then falls in for
	;the visitors. Called from setupice and others
	clr.w	d1
	movea.w	#(tmstruct-M68K_RAM),a0
	bsr.w	.team
	moveq	#$20,d1
	adda.w	#tmsize,a0
.team	;a0 = team struct, d1 = palette offset ($20 for the visitors)
	movea.l	tmdata(a0),a2
	adda.w	2(a2),a2	;Palettedata
	adda.w	d1,a2
	movea.w	#(palfadenew+$40-M68K_RAM),a1
	adda.w	d1,a1
	moveq	#7,d0
.loop
	move.l	(a2)+,(a1)+
	dbf	d0,.loop
	rts
