;	NHL 95 input95_01. Retail $083EB2-$084FE5 (4404 bytes).
;	94 input94 doinput (95: its start is doinput; the mapped start doinput .0 is inside it), doinput_islocked, rtss7, faceoffinput,
;	setpassmode, passmode, dopass, passtoa0, then onetimer94 OneTimerTarget and its tables and OneTimerPass (moved in), input94
;	Findhittype, SetShotMode, ShotMode, prepshot, doshot, shotsets, shotdiradj, shotdirmath, onetimer94 puckvzadj and checks94
;	compshoot (moved in). data95_01 follows at $084FE6.
;	The 94 doinput parts doinput_cbut ... doinput_ispc, getGoalieSCnum are in input95_03; the goalie dive (doinput .33) is
;	doinput_goaliedive (checks95_05); burst, Acheck, changeplayer (95 chgplayer), setc1player ... are in setup95_01; SetLCmode, lineinput
;	in input95_02.
;	IDA code except puckvzadj and compshoot (dc.b, read from the retail bytes) and the dead / data bytes noted below. Local labels are
;	numbered; the IDA local names are not kept.
;	95 changes: four pads (doinput_islocked marks the player of pad c1 ... c4playernum), the 95 asstab numbers and SPA values, the y
;	limits moved 3 out ($108 to $10B ...), the PAL speed $18 (94 $16), the one-timer table offsets, Findhittype's two masks swapped,
;	shotsets $E / $FFF2 (94 $10 / $FFF0), jsr / jmp .l to the routines 95 moved out of range.
;	EA's compiler emits cmp #imm,Dn as CMP (Bxxx), SNASM emits CMPI (0Cxx). The source has the real cmp / cmpi; fixopcodes.js patches the
;	cmp encoding after assembly.


doinput	;Process controller input for player a3: d0 = dpad, d1 = new buttons, d2 = changed buttons, d3 = held buttons,
	;d4 = pad 0 / 2 / 4 / 6. 95: button A clears pflags2 bit 7 first
	btst	#6,d1
	beq.w	.0
	bclr	#7,pflags2(a3)
.0
	btst	#4,d1	;B button
	beq.w	.1	;branch if not pressed
	btst	#5,d1	;C button
	beq.w	.1	;branch if not pressed
	bclr	#4,d1
	bset	#6,$64(a3)
	bra.w	.5
.1
	btst	#4,d1
	beq.w	.2
	bclr	#6,$64(a3)
.2
	btst	#4,d2
	beq.w	.5
	bclr	#6,$64(a3)
	beq.w	.5
	tst.w	d4
	bne.w	.3
	move.b	#$11,(bholdtimer).w
	bra.w	.4
.3
	move.b	#$11,(bholdtimer+1).w
.4
	bclr	#4,d2
.5
	btst	#7,(gmode2).w
	beq.w	.6
	cmp.b	#8,d0
	beq.w	.6
	jsr	(ShortenMsgTimer).l
.6
	move.w	d0,(TempWord1).w
	andi.w	#$F,(TempWord1).w
	jsr	(setpads).l
	btst	#7,d1	;start button
	beq.w	.7
	tst.w	d4
	beq.w	startpause1
	cmp.w	#2,d4
	beq.w	startpause2
	cmp.w	#4,d4
	beq.w	startpause3
	cmp.w	#6,d4
	beq.w	startpause4
.7
	btst	#0,(sflags2).w
	bne.w	faceoffinput
	btst	#3,pflags2(a3)
	bne.w	lineinput
	btst	#3,pflags(a3)
	beq.w	rtss7
	movem.l	d0-d2/a0/a3,-(sp)
	move.w	(lastplayer).w,d0
	cmp.w	SCnum(a3),d0
	bne.w	.8
	tst.w	(passplayer).w
	bmi.w	.8
	tst.w	(onetimerplayer).w
	bpl.w	.8
	btst	#5,d1
	beq.w	.8
	move.w	(passplayer).w,d0
	asl.w	#7,d0
	movea.l	#SortCords,a3
	adda.w	d0,a3
	tst.w	position(a3)
	beq.w	.8
	btst	#3,pflags(a3)
	bne.w	.8
	btst	#3,$64(a3)
	bne.w	.8
	move.w	d4,(inputjoy).w
	move.w	#$18,d0
	jsr	(assreplace).l
	movem.l	(sp)+,d0-d2/a0/a3
	rts
.8
	movem.l	(sp)+,d0-d2/a0/a3
	btst	#3,$64(a3)
	bne.w	.9
	btst	#5,pflags(a3)
	bne.w	doinput_islocked
.9
	move.w	(puckc).w,d5
	cmp.w	SCnum(a3),d5
	beq.w	.41
	tst.w	position(a3)
	beq.w	.11
	btst	#3,$64(a3)
	beq.w	.10
	bra.w	.11
.10
	btst	#6,d1
	beq.w	.11
	jmp	holdplayer
.11
	tst.w	position(a3)
	beq.w	.12
	btst	#2,(BA_PS_flags).w
	bne.w	.37
	bra.w	.16
.12
	btst	#6,(sflags5).w
	bne.w	.16
	tst.w	d4
	beq.w	.13
	tst.w	(goaliemode2).w
	bra.w	.14
.13
	tst.w	(goaliemode1).w
.14
	beq.w	.16
	movem.w	d0,-(sp)
	move.w	SCnum(a3),d0
	cmp.w	(puckc).w,d0
	movem.w	(sp)+,d0
	beq.w	.16
.15
	jmp	chgplayer
.16
	btst	#4,d3
	beq.w	.24
	tst.w	(holdreset).w
	bne.w	.24
	tst.w	d4
	beq.w	.20
	tst.b	(bholdtimer+1).w
	beq.w	.37
	subq.b	#1,(bholdtimer+1).w
	bpl.w	.17
	move.b	#0,(bholdtimer+1).w
.17
	tst.b	(bholdtimer+1).w
	bne.w	.24
	tst.w	d4
	beq.w	.18
	tst.w	(goaliemode2).w
	bra.w	.19
.18
	tst.w	(goaliemode1).w
.19
	bne.w	.24
	bra.w	.32
.20
	tst.b	(bholdtimer).w
	beq.w	.37
	subq.b	#1,(bholdtimer).w
	bpl.w	.21
	move.b	#0,(bholdtimer).w
.21
	tst.w	d4
	beq.w	.22
	tst.w	(goaliemode2).w
	bra.w	.23
.22
	tst.w	(goaliemode1).w
.23
	bne.w	.24
	tst.b	(bholdtimer).w
	beq.w	.32
.24
	btst	#4,d1
	beq.w	.26
	tst.w	d4
	bne.w	.25
	move.b	#$11,(bholdtimer).w
	bra.w	.37
.25
	move.b	#$11,(bholdtimer+1).w
	bra.w	.37
.26
	btst	#4,d2
	beq.w	.37
	btst	#4,d3
	bne.w	.37
	move.w	(bholdtimer).w,d0
	tst.w	d4
	beq.w	.29
	move.b	#$11,(bholdtimer+1).w
	andi.w	#$FF,d0
	bne.w	.15
	tst.w	d4
	beq.w	.27
	tst.w	(goaliemode2).w
	bra.w	.28
.27
	tst.w	(goaliemode1).w
.28
	bne.w	.15
	bra.w	.32
.29
	move.b	#$11,(bholdtimer).w
	andi.w	#$FF00,d0
	bne.w	.15
	tst.w	d4
	beq.w	.30
	tst.w	(goaliemode2).w
	bra.w	.31
.30
	tst.w	(goaliemode1).w
.31
	bne.w	.15
.32
	tst.w	(holdreset).w
	bne.w	.15
	move.w	#5,d0
	cmp.w	#5,d6
	ble.w	.33
	move.w	#$B,d0
.33
	jsr	(getGoalieSCnum).l
	tst.w	d0
	bmi.w	rtss7
	movem.l	d0/a3,-(sp)
	movea.l	#SortCords,a3
	asl.w	#7,d0
	adda.w	d0,a3
	btst	#3,pflags(a3)
	movem.l	(sp)+,d0/a3
	bne.w	rtss7
	tst.w	d4
	bne.w	.34
	jmp	setc1player
.34
	cmp.w	#2,d4
	bne.w	.35
	jmp	setc2player
.35
	cmp.w	#4,d4
	bne.w	.36
	jmp	setc3player
.36
	jmp	setc4player
.37
	tst.w	position(a3)
	bne.w	.38
	jmp	doinput_goaliedive
.38
	move.w	(TempWord1).w,d0
	btst	#3,$64(a3)
	bne.w	rtss7
	btst	#5,d1
	beq.w	doplayeracc
	movem.l	d7-a0,-(sp)
	move.w	(lastplayer).w,d7
	asl.w	#7,d7
	movea.l	#SortCords,a0
	adda.w	d7,a0
	tst.w	position(a0)
	movem.l	(sp)+,d7-a0
	beq.w	.39
	movem.w	d7,-(sp)
	move.w	SCnum(a3),d7
	cmp.w	(passplayer).w,d7
	movem.w	(sp)+,d7
	bne.w	.39
	tst.w	(puckc).w
	bpl.w	.39
	jsr	(PuckOnAttackHalf).l
	beq.w	.39
	move.w	d0,-(sp)
	move.w	d4,(inputjoy).w
	move.w	#$18,d0
	jsr	(assreplace).l
	move.w	(sp)+,d0
	rts
.39
	cmp.w	#7,d0
	bgt.w	.40
	move.w	d0,facedir(a3)
.40
	jmp	burstchk
.41
	bsr.w	checkob
	tst.w	position(a3)
	bne.w	.42
	btst	#1,pflags2(a3)
	bne.w	rtss7
.42
	btst	#2,(sflags).w
	bne.w	passmode
	btst	#3,(sflags).w
	bne.w	ShotMode
	btst	#4,d1
	beq.w	.43
	bra.w	setpassmode
.43
	movem.l	a0,-(sp)
	movea.l	#LineHoldTimer,a0
	btst	#6,d1
	beq.w	.49
	movem.l	d5-d6/a1-a4,-(sp)
	move.w	d3,d5
	andi.w	#$F,d5
	btst	#7,pflags(a3)
	bne.w	.44
	btst	#0,d5
	beq.w	.46
	bra.w	.45
.44
	btst	#1,d5
	beq.w	.46
.45
	move.w	#1,d6
	bra.w	.47
.46
	clr.w	d6
.47
	movem.l	(sp)+,d5-d6/a1-a4
	beq.w	.48
	bset	#1,(GameFlags).w
	movem.l	(sp)+,a0
	bra.w	setpassmode
	dc.b	8,0,4,8,6,7,5,8,2,1,3,8,8,8,8,8	;unused: dpad bits to a direction (8 = none)
.48
	move.w	#$F,(a0,d4.w)
.49
	btst	#6,d3
	beq.w	.51
	subq.w	#1,(a0,d4.w)
	bpl.w	.50
	clr.w	(a0,d4.w)
.50
	tst.w	(a0,d4.w)
	bne.w	.51
	movea.l	#LineHoldFlag,a0
	move.w	#1,(a0,d4.w)
	movem.l	(sp)+,a0
	jmp	SetLCmode
.51
	movem.l	(sp)+,a0
	btst	#6,d3
	bne.w	.56
	btst	#6,d2
	beq.w	.56
	bclr	#7,pflags2(a3)
	bne.w	.56
	btst	#3,pflags2(a3)
	bne.w	.56
	movem.w	d0,-(sp)
	move.w	(pucky).w,d0
	bpl.w	.52
	neg.w	d0
.52
	cmp.w	#$56,d0
	blt.w	.55
	move.w	(pucky).w,d0
	btst	#7,pflags(a3)
	bne.w	.53
	neg.w	d0
.53
	tst.w	d0
	bmi.w	.55
	movem.w	(sp)+,d0
	bset	#0,(GameFlags).w
	bne.w	.54
	jmp	SetShotMode
.54
	rts
.55
	movem.w	(sp)+,d0
	bset	#3,(sflags5).w
	bra.w	setpassmode
.56
	tst.w	position(a3)
	bne.w	.57
	bra.w	doplayeracc
.57
	btst	#5,d1
	beq.w	doplayeracc
	bra.w	SetShotMode

doinput_islocked	;94 global (doinput branches across). B with the player not the carrier: change player (chgplayer) and
	;set $64 bit 6 of the pad's new player (95: pads 1 to 4)
	move.w	(puckc).w,d5
	cmp.w	SCnum(a3),d5
	beq.w	rtss7
	btst	#4,d1
	beq.w	rtss7
	btst	#6,(sflags5).w
	bne.w	rtss7
	jsr	(chgplayer).l
	movem.l	d0/a0,-(sp)
	tst.w	d4
	beq.w	.3
	cmp.w	#2,d4
	beq.w	.2
	cmp.w	#4,d4
	beq.w	.1
	bra.w	.0
.0
	move.w	(c4playernum).w,d0
	bra.w	.4
.1
	move.w	(c3playernum).w,d0
	bra.w	.4
.2
	move.w	(c2playernum).w,d0
	bra.w	.4
.3
	move.w	(c1playernum).w,d0
.4
	tst.w	d0
	bmi.w	.5
	asl.w	#7,d0
	movea.l	#SortCords,a0
	adda.w	d0,a0
	bset	#6,$64(a0)
.5
	movem.l	(sp)+,d0/a0

rtss7	;The doinput_islocked rts
	rts

faceoffinput	;The faceoff player (assignment $11, 94 $17): store the dpad pull (fodir1 / fodir2) and start the faceoff
	;swipe on B (95 SPA $1B36 / $1B60; 94 $FEA / $1014)
	btst	#6,(sflags5).w
	beq.w	.1
.0
	rts
.1
	move.w	assnum(a3),d4
	cmpi.b	#$11,asslist(a3,d4.w)
	bne.s	.0
	movea.w	#(fodir1-M68K_RAM),a0	;faceoff direction of puck control variable
	btst	#7,pflags(a3)
	beq.w	.2	;branch if bottom goal
	movea.w	#(fodir2-M68K_RAM),a0
.2
	move.w	d0,(a0)
	btst	#1,pflags2(a3)
	bne.s	.0
	btst	#4,d1	;test for b button press
	beq.w	.3
	move.w	#$1B36,d1
	bset	#1,pflags2(a3)	;set anim in progress
	jmp	SetSPA
.3
	move.w	#$1B60,d1
	jmp	SetSPA

setpassmode	;Pass direction mode: passdir = facedir, sflags bit 2 (95 drops the 94 penalty shot part)
	move.w	facedir(a3),(passdir).w
	andi.w	#7,(passdir).w	;Passes first 3 bits of passdir
	bset	#2,(sflags).w	;#sfspdir - set pass dir mode

rtss	;The setpassmode rts
	rts

passmode	;Start passing: on a B change (or sflags5 bit 3) dopass, else a new pass direction from the dpad
	btst	#4,d2	;has b button changed?
	bne.w	dopass	;yes
	btst	#3,(sflags5).w	;Not in NHL Hockey Source
	bne.w	dopass
	btst	#3,d0	;look for dpad
	bne.s	rtss
	andi.w	#7,d0	;pass first 3 bits of d0
	move.w	d0,(passdir).w	;new pass dir
	bset	#3,d0

dopass	;Pass the puck from a3 in passdir: pick the receiver (passtoa0), set the puck speed
	movem.l	d0-d5/a0-a1,-(sp)
	bclr	#2,(sflags).w
	st	(puckc).w	;player is not puck handler anymore
	move.b	#$10,nopuck(a3)	;$5E = nopuck
	btst	#1,(GameFlags).w
	beq.w	.0
	move.b	#$18,nopuck(a3)
.0
	move.w	SCnum(a3),(lastplayer).w	;$52 = offset of player on ice
	bclr	#3,(sflags5).w	;Not in NHL Hockey Source
	beq.w	.2
	jsr	(OneTimerTarget).l
	move.w	#9,(onetimerheight).w
	btst	#2,(sflags6).w
	beq.w	.1
	move.w	#$20,(onetimerheight).w
.1
	jsr	(OneTimerPass).l
	bra.w	.8
.2
	moveq	#8,d0	;moves 8 into d0
	tst.w	position(a3)	;checks if goalie
	beq.w	.3
	move.b	passacc(a3),d0
.3
	asl.w	#2,d0	;d0 = passacc for player, 8 for goalie
	asr.w	#1,d0	;change from NHL Hockey Source,
	addi.w	#$A0,d0
	move.w	d0,(passspeed).w	;Passspeed = PassAcc (0 to 30 decimal) * 2 + A0 (160 decimal)
	btst	#0,passacc(a3)
	beq.w	.4
	asr.w	#4,d0	;divide d0 by 16
	add.w	d0,(passspeed).w	;add d0 to passspeed
.4
	moveq	#$FFFFFFFF,d4
	moveq	#5,d3	;Set total number of players (6 total, set to 5)
	movea.w	#(SortCords-M68K_RAM),a1	;start of the home players on ice
	cmpi.w	#6,SCnum(a3)	;compares 6 to offset 52 from a3 (current player with puck) to check if player is away team or home team
	blt.w	.5
	adda.w	#$300,a1
	btst	#2,(BA_PS_flags).w
	bne.w	.7
.5
	cmpa.l	a1,a3	;Check to see if passing to self
	beq.w	.6
	tst.w	position(a1)	;position(a1)
	ble.w	.6
	btst	#2,pflags2(a1)	;check if player is unavailable
	bne.w	.6
	move.w	(a1),d0	;X Position of receiving player
	sub.w	(puckx).w,d0	;sub puckx from d0
	move.w	Ypos(a1),d1	;Y position of receiving player
	sub.w	(pucky).w,d1	;sub pucky from d1
	movem.w	d0-d1,-(sp)	;push to stack
	jsr	(vtoa).l
	movem.w	(sp)+,d1-d2	;pop from stack d1 is dX, d2 is dY
	sub.w	(passdir).w,d0	;sub passdir from d0
	andi.w	#7,d0
	asl.b	#5,d0	;Multiply d0 by 32 (224 decimal is max)
	ext.w	d0	;sign extend d0 byte to d0 word
	asl.w	#3,d0	;mult d0 by 8 (700 decimal max)
	muls.w	d0,d0	;square d0 = max is 490000 decimal
	cmp.l	#$10000,d0
	bhi.w	.6
	muls.w	d1,d1	;square d1 (dX)
	muls.w	d2,d2	;square d2 (dY)
	add.l	d1,d2	;add together
	cmp.l	d4,d2	;compare d4 to d2
	bhi.w	.6
	move.l	d2,d4	;move d2 into d4
	movea.l	a1,a0	;move a1 address into a0 (receiving player)
.6
	adda.w	#SCstruct,a1	;Skip to next player (80 hex is length of player struct)
	dbf	d3,.5
	tst.l	d4	;check if there's a player to pass to
	bmi.w	.7
	bsr.w	passtoa0
	bra.w	.8
.7
	move.w	(passdir).w,d0	;just hit puck in pass dir not to any player
	asl.w	#2,d0
	movea.l	#dirtab,a0
	move.w	2(a0,d0.w),d1	;y inc
	muls.w	(passspeed).w,d1
	moveq	#$A,d2
	asl.l	d2,d1
	divs.w	#$B40,d1
	add.w	Yvel(a3),d1
	move.w	d1,(puckvy).w
	move.w	(a0,d0.w),d1
	muls.w	(passspeed).w,d1
	asl.l	d2,d1
	divs.w	#$B40,d1
	add.w	Xvel(a3),d1
	move.w	d1,(puckvx).w
	move.w	#$1000,d0
	jsr	(randomd0).l
	move.w	d0,(puckvz).w
	btst	#1,(GameFlags).w
	beq.w	.8
	clr.w	(puckvz).w
	move.w	(puckvx).w,d0
	asr.w	#2,d0
	move.w	d0,(puckvx).w
	move.w	(puckvy).w,d0
	asr.w	#2,d0
	move.w	d0,(puckvy).w
.8
	tst.w	position(a3)	;$34 = position
	bne.w	.11
	tst.w	(puckvy).w
	btst	#7,pflags(a3)
	beq.w	.9
	bmi.w	.10
	bra.w	.11
.9
	bmi.w	.11
.10
	neg.w	(puckvy).w	;negative velocity on puck
.11
	move.w	(puckvx).w,d0
	move.w	(puckvy).w,d1
	jsr	(vtoa).l
	move.w	#$1F9A,d1
	tst.w	position(a3)	;$34 = position
	beq.w	.13
	move.w	#$1362,d1
	btst	#1,(GameFlags).w
	beq.w	.12
	move.w	#$13D4,d1
.12
	bsr.w	Findhittype
	beq.w	.13
	move.w	#$1426,d1
	btst	#1,(GameFlags).w
	beq.w	.13
	move.w	#$1498,d1
.13
	jsr	(SetSPA).l
	bset	#5,pflags(a3)
	moveq	#$C,d0	;Rest to rts, not in NHL Hockey Source
	sub.b	(puckvz).w,d0
	lsr.w	#2,d0
	btst	#1,(GameFlags).w
	bne.w	.14
	andi.w	#3,d0
	addi.w	#$10,d0
	move.w	d0,-(sp)	;#SFXpass
	jsr	(sfx).l
.14
	movem.l	(sp)+,d0-d5/a0-a1
	rts

passtoa0	;Pass to player a0
	btst	#3,pflags(a3)
	beq.w	.0
.0
	jsr	(loadTeamStruct).l
	addq.w	#1,$12(a2)	;add 1 to total pass attempts
	move.w	$52(a0),(passplayer).w
	move.w	(passspeed).w,d5	;passspeed = pix/sec
	asr.w	#2,d5	;divides pass speed by 4
	exg	a0,a3	;tell pass recipient to get puck - swaps a3 and a0 for assinsert
	moveq	#$D,d0
	jsr	(assinsert).l
	exg	a0,a3
	move.l	a0,-(sp)	;This routine uses passspeed and player's a0 x/y speed to determine the x/y velocity of the puck so it will meet player a0
	jsr	(GetHot).l
	add.w	(a0),d0	;Xpos
	sub.w	(puckx).w,d0
	add.w	$14(a0),d1
	sub.w	(pucky).w,d1
	movem.w	d0-d1,-(sp)
	movem.w	(sp),d2-d3	;pop d0-d1 off into d2-d3
	asr.w	#2,d2	;d2 divide by 4
	asr.w	#2,d3	;d3 divide by 4
	move.w	$28(a0),d0
	muls.w	#$F0,d0	;#(16 * 60)/4 = $F0 xpix / (1/4) sec
	swap	d0	;swap upper and lower bytes
	move.w	$2A(a0),d1
	muls.w	#$F0,d1
	swap	d1	;swap upper and lower bytes
	movem.w	d0-d1,-(sp)	;push on stack
	muls.w	d2,d0	;d0 = (d2 = Xpos puck / 4) * d0 (x pix per 1/4 sec)
	muls.w	d3,d1	;d1 = (d3 = Ypos puck /4) * d1 (y pix per 1/4 sec)
	add.w	d1,d0	;add d1 to d0
	asl.w	#1,d0	;d0 mult by 2
	move.w	d0,d4	;j = move d0 into d4
	movem.w	(sp),d0-d1	;pop d0 and d1 off stack
	muls.w	d0,d0	;(x pix per 1/4 sec)^2
	muls.w	d1,d1	;(y pix per 1/4 sec)^2
	muls.w	d5,d5	;passspeed^2
	neg.l	d5	;negative d5
	add.l	d0,d5	;add d0 to d5
	add.l	d1,d5	;k = add d1 to d5
	muls.w	d2,d2
	muls.w	d3,d3
	add.l	d2,d3	;a^2 = add d2 to d3
	muls.w	d5,d3	;multiply k * a^2
	asl.l	#2,d3	;divide by 4
	move.w	d4,d0	;d0 = j
	muls.w	d0,d0	;j^2
	sub.l	d3,d0	;j^2 - ((k*a^2)/4)
	jsr	(sroot).l
	moveq	#1,d3	;limit infinite loop
	asr.w	#2,d5	;k divide by 4
	bne.w	.1
	moveq	#1,d5	;no div by zero
.1
	move.w	d0,d2
	neg.w	d0
	sub.w	d4,d2
	ext.l	d2
	divs.w	d5,d2
	dbpl	d3,.1
	bne.w	.2
	addq.w	#1,d2	;can't be zero
.2
	cmp.w	#$18,d2	;limit to 3 sec.
	bls.w	.3
	moveq	#$18,d2	;d2 = time in 1/8 sec to intersection
.3
	btst	#1,(GameFlags).w
	beq.w	.4
	asl.w	#2,d2
.4
	move.b	d2,(puckvz).w
	cmp.w	#$C,d2
	blt.w	.5
	move.b	#$C,(puckvz).w
	btst	#1,(GameFlags).w
	beq.w	.5
	clr.w	(puckvz).w
.5
	move.w	d2,d0
	asl.w	#3,d0
	subi.w	#$A,d0
	move.b	d0,$40(a0)	;$40 = temp1
	subq.w	#6,d0	;sub. #10 in NHL Hockey
	move.b	d0,(puckx+nopuck).w
	movem.w	(sp)+,d0-d1
	muls.w	d2,d0
	asr.l	#1,d0
	add.w	(sp)+,d0	;x distance
	move.w	(puckx).w,$44(a0)
	add.w	d0,$44(a0)
	muls.w	d2,d1
	asr.l	#1,d1
	add.w	(sp)+,d1	;y distance
	move.w	(pucky).w,$46(a0)
	add.w	d1,$46(a0)
	mulu.w	#$78,d2	;'x'   ; $78 = 60*2
	swap	d0
	divs.w	d2,d0
	move.w	d0,(puckvx).w
	swap	d1
	divs.w	d2,d1
	move.w	d1,(puckvy).w
	rts

OneTimerTarget	;onetimer94 OneTimerTarget (moved in). One-timer pass target for receiver a3: an offset by facing from
	;OneTimerNearTbl / OneTimerFarTbl (skater, near or far from the goal) or OneTimerGoalieTbl
	movem.l	d0-d7/a0-a6,-(sp)
	bclr	#2,(sflags6).w
	tst.w	position(a3)
	bne.w	.0
	movea.l	#OneTimerGoalieTbl,a0
	bra.w	.2
.0
	move.w	Ypos(a3),d0
	btst	#7,pflags(a3)
	bne.w	.1
	neg.w	d0
.1
	bset	#2,(sflags6).w
	movea.l	#OneTimerNearTbl,a0
	cmp.w	#$56,d0
	blt.w	.2
	movea.l	#OneTimerFarTbl,a0
	bclr	#2,(sflags6).w
.2
	move.w	facedir(a3),d0
	btst	#7,pflags(a3)
	bne.w	.3
	addq.w	#4,d0
	andi.w	#7,d0
.3
	asl.w	#2,d0
	move.w	(a0,d0.w),d1
	move.w	2(a0,d0.w),d2
	cmpa.l	#OneTimerFarTbl,a0
	bne.w	.6
	move.w	Ypos(a3),d0
	bpl.w	.4
	neg.w	d0
.4
	cmp.w	#$88,d0
	blt.w	.6
	move.w	(a3),d0
	bpl.w	.5
	neg.w	d0
.5
	cmp.w	#$37,d0
	bgt.w	.6
	move.w	#$106,d2
.6
	btst	#7,pflags(a3)
	bne.w	.7
	neg.w	d1
	neg.w	d2
.7
	move.w	#$A,d0
	jsr	(randomd0).l
	add.w	d0,d1
	move.w	#$A,d0
	jsr	(randomd0).l
	add.w	d0,d2
	move.w	d1,(onetimertargetx).w
	tst.w	position(a3)
	beq.w	.9
	sub.w	(a3),d1
	bmi.w	.8
	subi.w	#$3C,d1
	bpl.w	.9
	neg.w	d1
	add.w	d1,(onetimertargetx).w
	bra.w	.9
.8
	addi.w	#$3C,d1
	bmi.w	.9
	sub.w	d1,(onetimertargetx).w
.9
	move.w	d2,(onetimertargety).w
	movem.l	(sp)+,d0-d7/a0-a6
	rts

OneTimerNearTbl	;OneTimerTarget target offsets (x, y) by facing, receiver near the goal
	dc.w	$70,$C5,$70,$C5,$70,$C5,$70,$C5	;94 $74, $C2
	dc.w	$FF90,$C5,$FF90,$C5,$FF90,$C5,$FF90,$C5

OneTimerFarTbl	;OneTimerTarget target offsets (x, y) by facing, receiver far from the goal
	dc.w	$FFFB,$AB,$FFFB,$AB,$FFFB,$AB,$FFFB,$AB
	dc.w	$FFFB,$AB,$FFFB,$AB,$FFFB,$AB,$FFFB,$AB

OneTimerGoalieTbl	;OneTimerTarget target offsets (x, y) by facing, goalie
	dc.w	$FFFB,$FFF4,$32,$FFF4,$32,$FFF4,$32,$FFF4	;94 $FFF7
	dc.w	$FFFB,$FFF4,$FFCE,$FFF4,$FFCE,$FFF4,$FFCE,$FFF4

OneTimerPass	;onetimer94 OneTimerPass (moved in). One-timer pass: puckvz = sqrt(12 * onetimerheight), then puckvx / puckvy
	;toward the target onetimertargetx / onetimertargety in puckvz
	movem.l	d0-d7/a0-a6,-(sp)
	move.w	#$C,d0
	move.w	(onetimerheight).w,d1
	mulu.w	d1,d0
	swap	d0
	andi.l	#$FFFF0000,d0
	jsr	(sroot).l
	move.w	d0,(puckvz).w
	ext.l	d0
	move.w	#3,d4
	divu.w	d4,d0
	clr.l	d1
	move.w	(onetimertargetx).w,d1
	sub.w	(puckx).w,d1
	swap	d1
	tst.w	d0
	bne.w	.0
	move.w	#1,d0
.0
	divs.w	d0,d1
	move.w	d1,(puckvx).w
	clr.l	d1
	move.w	(onetimertargety).w,d1
	sub.w	(pucky).w,d1
	swap	d1
	divs.w	d0,d1
	move.w	d1,(puckvy).w
	movea.l	#puckx,a3
	move.w	(puckvz).w,d0
	jsr	(puckflip).l
	movem.l	(sp)+,d0-d7/a0-a6
	rts

Findhittype	;94 name. Z by direction d0 from facedir and the hand (attribute bit 3): btst Dn,#imm (IDA cannot show it).
	;95 swaps the two masks of 94
	neg.w	d0
	add.w	facedir(a3),d0
	andi.w	#7,d0
	btst	#3,attribute(a3)	;attribute bit 3
	beq.w	.1
	btst	d0,#$1E	;%00011110 (94 %11110000)
	rts
.1
	btst	d0,#$F0	;%11110000 (94 %00011110)
	rts

SetShotMode	;Initiate a shot by player a3
	btst	#2,(BA_PS_flags).w	;check for PS or SO
	beq.w	.0
	btst	#0,(GameFlags).w
	bne.w	.0
	bclr	#2,(gmode2).w
	bset	#5,(BA_PS_flags).w
	bne.w	.5
	bclr	#5,(gmode2).w
	move.w	#$64,(passmodetimer).w
.0
	move.w	#8,(passdir).w	;default shot direction
	bset	#3,(sflags).w
	clr.w	d0	;find dx/dy for shot
	move.w	#$128,d1	;#296 = top Y boards
	btst	#7,pflags(a3)
	bne.w	.1
	neg.w	d1	;flip if bottom goal
.1
	sub.w	(a3),d0	;Sub Xpos of player from d0. d0 starts as 0 (middle of rink in X)
	sub.w	Ypos(a3),d1	;Sub Ypos of player from Y boards
	jsr	(vtoa).l
	move.w	#$F,(passspeed).w
	move.w	#$150A,d1
	btst	#0,(GameFlags).w
	beq.w	.2
	move.w	#$163C,d1
.2
	bsr.w	Findhittype
	beq.w	.4
	move.w	#$176E,d1
	btst	#0,(GameFlags).w
	beq.w	.3
	move.w	#$18A0,d1
.3
	move.w	#$13,(passspeed).w
.4
	jmp	SetSPA
.5
	rts

ShotMode	;The shot wind up: aim with the dpad until released
	cmpi.w	#$1C,SPAnum(a3)
	bge.w	prepshot	;end of animation so shoot
	btst	#3,d0	;checks dpad for direction
	bne.w	.0
	andi.w	#7,d0	;pass the first 3 bits of d0
	move.w	d0,(passdir).w	;set shot direction
.0
	cmpi.w	#$10,SPAnum(a3)
	bge.w	.3
	add.w	d7,(passspeed).w
	cmpi.b	#$14,shotspd(a3)	;6C = shot speed
	bge.w	.1
	cmpi.w	#8,SPAnum(a3)
	bgt.w	.2
.1
	btst	#5,d2	;5 = #cbut
	beq.w	.3
.2
	neg.w	SPAnum(a3)	;end windup and swing through
	addi.w	#$18,SPAnum(a3)
.3
	rts

prepshot	;Prepare the shot (shot direction), then doshot
	bclr	#4,(sflags5).w
	move.w	#$B,d0
	btst	#6,pflags(a3)
	beq.w	.0
	move.w	#5,d0	;opponent is home
.0
	cmpi.w	#1,(passdir).w
	ble.w	.1
	cmpi.w	#7,(passdir).w
	bne.w	.3
.1
	move.w	(pucky).w,d0
	btst	#7,pflags(a3)
	bne.w	.2
	neg.w	d0	;flips d0 for compare calc
.2
	cmp.w	#$D8,d0	;compares location of puck
	blt.w	.3
	bset	#4,(sflags5).w	;set flag for in-close top shelf shooting
.3
	bra.w	doshot

doshot	;Shoot the puck: speed and direction from the shooter's ratings, shotsets, shotdiradj; puckvz. 95: shotpflags,
	;ShotTimer
	movem.l	d0-d7/a0-a3,-(sp)
	bclr	#0,(GameFlags).w
	beq.w	.0
	bclr	#3,(sflags).w
	move.w	#$B8E,d1
	jsr	(SetSPA).l
	jmp	.21
.0
	move.w	#$1E,(ShotTimer).w
	move.b	pflags(a3),(shotpflags).w
	bclr	#4,(gmode2).w
	btst	#1,$64(a3)	;check if player on breakaway
	beq.w	.1
	bset	#4,(gmode2).w	;set if breakaway
.1
	bsr.w	shotdiradj
	move.w	#5,-(sp)	;#SFXshotwiff - sound effect
	move.w	SCnum(a3),(shotplayer).w
	bclr	#3,(sflags).w
	bset	#5,pflags(a3)
	btst	#3,$64(a3)	;check if shooting one timer
	bne.w	.2
	move.w	(puckc).w,d0	;puck carrier SCnum into d0
	cmp.w	SCnum(a3),d0	;is player puck carrier?
	bne.w	.20
.2
	move.w	#$18,(sp)	;#SFXshotfh
	bset	#4,(sflags2).w
	cmpi.w	#$176E,SPA(a3)
	bne.w	.3
	move.w	#$14,(sp)	;#SFXshotbh
	move.w	(passspeed).w,d0
	lsr.w	#2,d0	;sub 25% for backhand shots
	sub.w	d0,(passspeed).w
.3
	btst	#3,$64(a3)	;check if shooting one timer
	beq.w	.4
	movem.l	d0-d1,-(sp)	;push d0-d1 on stack
	move.w	#$1F,d0	;1F into d0 - one timer min speed
	move.w	d0,(passspeed).w	;make passspeed start with a higher value
	movem.l	(sp)+,d0-d1	;Pop off stack d0-d1
.4
	clr.w	d0
	move.b	shotspd(a3),d0
	lsr.b	#1,d0	;divide by 2
	movea.l	a3,a0	;move a3 address into a0
	jsr	(makepde).l	;scale d0 based on energy level
	addi.w	#$14,d0	;add 14 to d0
	mulu.w	(passspeed).w,d0	;shot speed ranged by energy level
	mulu.w	#$5249,d0
	swap	d0	;swaps the upper and lower words of d0
	move.w	d0,(passspeed).w	;move d0 into passspeed
	btst	#0,shotspd(a3)
	beq.w	.5
	asr.w	#4,d0	;divide by 16
	add.w	(passspeed).w,d0	;add passspeed to d0
.5
	lsr.w	#4,d0	;divide by 16 (d0 is passspeed)
	neg.w	d0	;negative
	addq.w	#3,d0	;add 3 to d0
	bpl.w	.6
	clr.w	d0	;clear if negative
.6
	add.w	d0,(sp)	;add to stack current value (Shot SFX)
	st	(puckc).w	;clear puck carrier
	move.b	#$10,nopuck(a3)	;5E = nopuck - no puck collision till 0
	move.w	SCnum(a3),(lastplayer).w
	move.w	#$10B,d1
	btst	#7,pflags(a3)
	bne.w	.7
	neg.w	d1	;flip d1 if shooting down
.7
	move.w	(passdir).w,d2	;passdir into d2
	asl.w	#2,d2	;mult by 4
	lea	shotsets(pc),a0	;table of shot directions
	move.w	(a0,d2.w),d0
	move.w	2(a0,d2.w),d2	;z offset
	sub.w	(puckx).w,d0
	sub.w	(pucky).w,d1
	movem.w	d0-d2,-(sp)	;push d0-d2(dx,dy,z offset) on stack
	muls.w	d0,d0
	muls.w	d1,d1
	add.l	d1,d0
	jsr	(sroot).l
	tst.w	d0	;distance in pix to goal
	bne.w	.8
	addq.w	#1,d0
.8
	move.w	d0,d3	;straight line distance from puck to spot aiming for with passdir
	btst	#4,(gmode).w
	bne.w	.14
	cmp.w	#$C8,d3	;C8 = 200 decimal
	bhi.w	.9
	jsr	(ReadGoaliePulled).l	;checks if shooting team's G pulled
	bmi.w	.14
	btst	#0,(gmode2).w	;check if shootout
	bne.w	.14
	moveq	#$10,d0	;start value for ShA calc
	add.b	shotacc(a3),d0	;shotacc(a3)
	jsr	(randomd0).l
	cmp.w	#$E,d0	;chance of perfect shot
	bgt.w	.14
.9
	clr.w	d0
	move.b	shotacc(a3),d0
	lsr.w	#1,d0	;divide by 2
	move.b	d0,-(sp)	;push on stack
	move.w	(passspeed).w,d0	;move passspeed into d0
	lsr.w	#4,d0	;divide by 16
	sub.b	(sp)+,d0	;shotacc(a3) / 2
	addi.b	#$10,d0	;add $10 to d0
	mulu.w	d3,d0	;mult straight line distance with d0
	lsr.w	#6,d0	;shot accuracy adjust - divide by 64
	cmp.w	#$FA,d3	;250 pixels straight line distance
	bhi.w	.10
	lsr.w	#1,d0	;extra shot accuracy adjust
.10
	cmp.w	#$98,d0
	blt.w	.11
	move.w	#$98,d0
.11
	move.w	d0,-(sp)	;push adjusting value on stack
	jsr	(randomd0s).l
	add.w	d0,2(sp)	;add result to x diff
	move.w	(sp),d0	;move adjusting value into d0
	cmp.w	#$3C,d0	;'<'   ; compare to $3C (max adjustment in Y)
	bls.w	.12
	moveq	#$3C,d0
	move.w	d0,(sp)
.12
	tst.w	4(sp)
	bpl.w	.13
	lsr.w	#1,d0
.13
	jsr	(randomd0s).l
	add.w	d0,4(sp)	;add to y diff
	move.w	(sp)+,d0	;pop adj value
	lsr.w	#1,d0	;divide by 2
	jsr	(randomd0).l
	add.w	d0,4(sp)	;add to Z diff
.14
	move.w	(passspeed).w,d2	;shot speed
	muls.w	#$44,d2	;'D'   ; 1024/15
	muls.w	(sp)+,d2	;mult by x dist
	divs.w	d3,d2	;divide d2 by straight line distance
	move.w	d2,(puckvx).w	;move into puckvx
	move.w	(passspeed).w,d2
	muls.w	#$44,d2	;'D'   ; 1024/15
	muls.w	(sp)+,d2	;mult by y dist
	divs.w	d3,d2	;divide d2 by straight line distance
	move.w	d2,(puckvy).w	;move into puckvy
	move.w	#$8000,d1	;this is the highest negative puckvy possible
	btst	#7,pflags(a3)
	beq.w	.15
	clr.w	d1
.15
	eor.w	d2,d1	;EOR - checking to see if exceeding maximum puckvy
	bpl.w	.16
	move.w	#$3810,(puckvy).w	;move into puckvy
	btst	#7,pflags(a3)
	bne.w	.16
	move.w	#$C7F0,(puckvy).w	;move into puckvy (shooting on bottom net)
.16
	move.w	(sp)+,d1	;pix height in goal
	beq.w	.20
	mulu.w	(passspeed).w,d1
	mulu.w	#$44,d1	;'D'   ; 1024/15
	divu.w	d3,d1	;d3 = distance in pix to goal
	mulu.w	#$B33,d3	;(1024*42)/15
	divu.w	(passspeed).w,d3	;divide by passspeed
	add.w	d1,d3
	cmp.w	#$1800,d3
	bls.w	.17
	move.w	#$1800,d3	;set max puckvz
.17
	cmpi.w	#$10B,(pucky).w
	bgt.w	.18
	cmpi.w	#$FEF5,(pucky).w
	bge.w	.19
.18
	clr.w	(puckvz).w
	bra.w	.20
.19
	move.w	d3,(puckvz).w	;move into puckvz
	bra.w	.20
	bclr	#4,(sflags5).w	;dead (the bra above skips it): the 94 top shelf call
	beq.w	.20
	btst	#3,$64(a3)	;check if one timer
	bne.w	.20
	jsr	(puckvzadj).l	;adjust puckvz for top shelf shot
.20
	jsr	(sfx).l
.21
	movem.l	(sp)+,d0-d7/a0-a3
	rts

shotsets	;Offsets (x, z) for the different shot directions (passdir 0 ... 8)
	dc.w	0,$C	;offsets for different directions on the shot: passdir 0 (x, z)
	dc.w	$E,$C	;passdir 1 (94 $10)
	dc.w	$E,6	;passdir 2
	dc.w	$E,0	;passdir 3
	dc.w	0,0	;passdir 4
	dc.w	$FFF2,0	;passdir 5 (94 $FFF0)
	dc.w	$FFF2,6	;passdir 6
	dc.w	$FFF2,$C	;passdir 7
	dc.w	0,6	;passdir 8

shotdiradj	;a3 = shooter. Where to shoot for a computer player or a one timer
	btst	#3,$64(a3)	;check if shooting one timer
	bne.w	.0	;jump if shooting one timer
	btst	#3,pflags(a3)
	bne.w	.6
.0
	moveq	#8,d0
	moveq	#5,d1
	movea.w	#(SortCords-SCstruct-M68K_RAM),a0	;SC Struct start - 80
	btst	#6,pflags(a3)
	bne.w	.1
	adda.w	#6*SCstruct,a0
.1
	adda.w	#SCstruct,a0
	tst.w	position(a0)
	dbeq	d1,.1
	bne.w	.4
	move.b	Xvel(a0),d0
	ext.w	d0	;sign extend d0
	asr.w	#1,d0	;divide by 2
	add.w	(a0),d0	;Xpos
	sub.w	(puckx).w,d0	;sub puckx from d0
	move.b	Yvel(a0),d1
	ext.w	d1	;sign extend d1
	asr.w	#1,d1	;divide by 2
	add.w	Ypos(a0),d1
	sub.w	(pucky).w,d1	;sub pucky from d1
	movem.w	d0-d1,-(sp)	;push to stack
	muls.w	d0,d0	;square d0
	muls.w	d1,d1	;square d1
	add.l	d1,d0	;add d1 to d0
	addq.l	#1,d0	;add 1 to d0
	jsr	(sroot).l
	move.w	d0,d2	;move result into d2
	movem.w	(sp)+,d0-d1	;pop from stack (distance x and y from G to puck)
	moveq	#$12,d3	;post?
	move.w	#$10B,d4
	btst	#7,pflags(a3)
	bne.w	.2
	neg.w	d4	;negate if bottom goal
.2
	movem.w	d3-d4,-(sp)	;push to stack
	bsr.w	shotdirmath
	move.w	d4,d5
	movem.w	(sp)+,d3-d4	;pop from stack
	neg.w	d3	;negate d3 (other post)
	bsr.w	shotdirmath
	add.w	d5,d4	;add results to d4
	clr.w	d0	;clear d0
	cmp.w	#$2C,d4	;','   ; 2C - right X edge of crease
	bgt.w	.4
	cmp.w	#$FFD4,d4	;-$2C, the left X edge of the crease
	blt.w	.4
	btst	#7,pflags(a3)
	beq.w	.3
	neg.w	d4	;negate d4
.3
	moveq	#2,d0	;move 2 into d0
	tst.w	d4	;check if d4 is 0
	bpl.w	.4
	moveq	#6,d0	;move 6 into d0
.4
	move.w	d0,(passdir).w	;will be 0,2,6, or 8 (no goalie)
	btst	#2,(BA_PS_flags).w
	bne.w	.5
	btst	#0,(gmode2).w	;check if shootout
	beq.w	.6
.5
	jsr	(PSandSOpassdir).l
.6
	rts

shotdirmath	;shotdiradj helper
	sub.w	(puckx).w,d3	;sub puckx from post X
	sub.w	(pucky).w,d4	;sub pucky from goalline
	muls.w	d0,d4	;mult d0 with d4
	muls.w	d1,d3	;mult d1 with d3
	sub.l	d3,d4	;sub d3 from d4
	divs.w	d2,d4	;divide d2 into d4
	rts

puckvzadj	;onetimer94 puckvzadj (moved in; IDA name). Set puckvz for a top shelf shot from the distance to the goal
	;line ($10B; 94 $108) over puckvy, at most $7FFF. Called from doshot
	movem.l	d0-d7/a0-a6,-(sp)
	move.w	(pucky).w,d0	;move pucky into d0
	bpl.w	.dist	;branch if positive
	neg.w	d0	;negate d0
.dist
	subi.w	#$10B,d0	;sub top goal line from d0
	bpl.w	.0	;branch if positive
	neg.w	d0	;negate d0
.0
	swap	d0	;swap d0 words
	andi.l	#$FFFF0000,d0	;pass upper word of d0
	move.w	(puckvy).w,d1	;move puckvy into d1
	beq.w	.x	;branch if zero
	bpl.w	.speed	;branch if positive
	neg.w	d1	;negate d1
.speed
	move.w	#$11,d2	;move 11 into d2
	tst.w	(music_global_tick_counter).w	;PAL
	beq.w	.div	;branch if equal (always is)
	move.w	#$18,d2	;PAL (94 $16)
.div
	divu.w	d1,d0	;divide d1 into d0
	andi.l	#$FFFF,d0	;pass lower word of d0
	divu.w	d2,d0	;divide d2 into d0
	tst.w	d0	;check d0
	bne.w	.calc	;branch if not zero
	move.w	#1,d0	;move 1 into d0
.calc
	move.l	#$A0000,d1
	move.w	d0,d3	;move d0 into d3
	mulu.w	d2,d0	;mult d2 and d0
	divu.w	d0,d1	;divide d0 into d1
	move.w	d2,d4	;move d2 into d4
	add.w	d2,d2	;double d2
	add.w	d4,d2	;add d4 to d2 (now d2 is d2 x 3)
	mulu.w	d3,d2	;multiply d3 and d2
	cmp.l	#$7FFF,d2	;compare to d2
	blt.w	.addvz	;branch if less than
	move.w	#$7FFF,d2	;move 7FFF into d2
.addvz
	add.w	d2,d1	;add d2 to d1
	tst.w	d1	;test d1
	bpl.w	.setvz	;branch if positive
	move.w	#$7FFF,d1	;move 7FFF into d1
.setvz
	move.w	d1,(puckvz).w	;move d1 into puckvz
.x
	movem.l	(sp)+,d0-d7/a0-a6
	rts

compshoot	;checks94 compshoot (moved in). Computer player shoots: drop the caller's return, temp2 from the
	;distance to the goal line, then assshoot. Jumped to from asspuckc, chk4shot (checks95_02) and checks95_05
	addq.w	#4,sp
	move.w	(pucky).w,d0
	btst	#7,pflags(a3)
	bne.w	.ds0
	neg.w	d0
.ds0
	move.w	#$10B,d1	;94 $108
	sub.w	d0,d1
	lsr.w	#3,d1
	cmp.w	#$14,d1
	blt.w	.0
	moveq	#$14,d1
.0
	move.w	d1,temp2(a3)
	moveq	#$1A,d0	;assshoot (94 $12)
	jmp	(assreplace).l
