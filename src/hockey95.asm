;	Game flow. This file runs the game from the title screen to the game loop: the main menu and
;	its exits to the season, trades and Create Player, the start of each game and period, the
;	intermission and every frame of play.

Opening	;Title screen (newTitleScreen), then into Opening2. Jumped to from Begin
	jsr	(KillCrowd).l
	jsr	(newTitleScreen).l
	bset	#7,(sflags12).w	;Opening2 skips the sound restart

Opening2	;Restart the sound (unless coming from Opening), reset the stack and clear the variables, then the main menu
	;(GameSetUp) and the 95 season flow, the main menu screens that are not games, user records and the playoff screen. Jumped to
	;from ExitToOpening and the 95 season, trade and create player screens
	bclr	#7,(sflags12).w
	bne.w	.clear
	jsr	(stop_current_song).l	;stop the song
	move.w	#9,d0	;restart the sound driver as Begin does
	jsr	(SoundCmd).l
	move.w	#0,d0	;command 0: load the Z80 program
	move.w	#$1B63,d1
	movea.l	#Z80Program,a0
	jsr	(SoundCmd).l
	move.w	#6,d0	;command 6: the sound data
	clr.w	d1
	movea.l	#SoundBanks,a0
	jsr	(SoundCmd).l
	move.w	#7,d0
	move.w	#0,d1
	jsr	(SoundCmd).l
	move.w	#0,-(sp)	;song 0
	jsr	(song).l
.clear
	jsr	(KillCrowd).l
	move	#$2700,sr
	movea.w	#(Stack-M68K_RAM),sp
	move.b	(sflags11).w,-(sp)	;keep sflags11 bit 6 (Regular Game) over the clear
	movea.w	#(VSCRLPM-M68K_RAM),a0
.0
	clr.l	(a0)+
	cmpa.w	#(gamevarend-M68K_RAM),a0	;clear from VSCRLPM to gamevarend (94: $FFFFD03E)
	blt.s	.0
	move.b	(sp)+,(sflags11).w
	andi.b	#$40,(sflags11).w
	jsr	(GameSetUp).l	;the main menu
	btst	#7,(sflags9).w	;Practice Mode
	beq.w	.1
	jsr	(PracticeGoalies).l
.1
	move.w	#1,(HmDefMode).w
	move.w	#1,(AwDefMode).w
	jsr	(SeasonMain).l	;95 season mode
	btst	#2,(sflags10).w	;main menu Trade Players
	beq.w	.2
	jmp	(TradePlayers).l
.2
	btst	#4,(sflags10).w	;Create Player
	beq.w	.3
	jmp	(CreatePlayer).l
.3
	btst	#5,(sflags10).w	;Sign Free Agents
	beq.w	.4
	jmp	(SignFreeAgents).l
.4
	btst	#6,(sflags10).w	;Release Players
	beq.w	.5
	jmp	(ReleasePlayers).l
.5
	jsr	(SetContTeams).l
	btst	#7,(sflags9).w	;Practice Mode
	beq.w	.6
	jsr	(PracticeGoalies).l
.6
	jsr	(UserNameEntry).l
	jsr	(PlayoffScreen).l

StartGame	;Reset game state for a new game, then start the first period. 95 has no jump from Opening2 (94 jmp (StartGame).w)
	move.l	#vb2,(vbint).l
	move	#$2500,sr
	jsr	(ReadJoy1).l	;pad 1 = $E0 at game start forces 30 second periods
	cmp.b	#$E0,d3
	bne.w	.chkpen
	move.w	#3,(OptPerlen).w	;period length index 3 = 30 seconds
.chkpen
	clr.b	(gmode).w
	cmpi.w	#1,(OptPen).w
	bne.w	.0
	bset	#gmoffs,(gmode).w	;gmoffs: offsides pen. is active
.0
	cmpi.w	#2,(OptPlayMode).w
	beq.w	.clrshots
	cmpi.w	#3,(OptPlayMode).w	;OptPlayMode 2-3 clear the shot buffer (94: 2 and up)
	bne.w	.1
.clrshots
	jsr	(ClearShotData).l
.1
	jsr	(clearTeamStats).l
	btst	#0,(gmode2).w	;shootout
	bne.w	.hotcold
	btst	#7,(gmode2).w
	beq.w	.2
.hotcold
	move.l	a2,-(sp)
	movea.l	#tmstruct,a2
	jsr	(reenergizeteam).l
	movea.l	#AwShots,a2
	jsr	(reenergizeteam).l
	movea.l	(sp)+,a2
	move.l	a0,-(sp)
	movea.l	#tmstruct,a0
	jsr	(Create_HotCold_Table).l
	movea.l	#AwShots,a0
	jsr	(Create_HotCold_Table).l
	movea.l	(sp)+,a0
.2
	btst	#0,(gmode2).w	;no ScoutingReport in a shootout or in Practice Mode
	bne.w	.noso
	btst	#7,(sflags9).w
	bne.w	.noso
	jsr	(ScoutingReport).l
.noso
	clr.w	(ScoreSumbytes).w
	clr.w	(PenSumLength).w
	clr.w	(gsp).w	;first period
	clr.w	(ChkCnt).w
	jsr	(restoreteams).l
	jsr	(stop_current_song).l	;restart the sound driver, command 7 with d1 = 1
	move.w	#9,d0
	jsr	(SoundCmd).l
	move.w	#0,d0
	move.w	#$1B63,d1
	movea.l	#Z80Program,a0
	jsr	(SoundCmd).l
	move.w	#6,d0
	clr.w	d1
	movea.l	#SoundBanks,a0
	jsr	(SoundCmd).l
	move.w	#7,d0
	move.w	#1,d1
	jsr	(SoundCmd).l
	move.b	#$E7,(VDP_PSG).l	;psg noise: white noise from tone 3, tone 3 at the top
	move.b	#$C8,(VDP_PSG).l
	move.b	#1,(VDP_PSG).l
	jsr	(setupice).l

IntermissionStart	;The PeriodOver tail. PeriodOver jumps here after forceblack: reset the
	;clock, restart the sound driver, UpdateScores, Intermission, then GameOver or StartPer
	jsr	(ResetClock).l
	move.w	d0,-(sp)
	move.w	(vcount).w,d0
.vb
	cmp.w	(vcount).w,d0	;wait for the next vblank
	beq.s	.vb
	jsr	(SoundOff).l
	move.w	d0,-(sp)
	move.w	(vcount).w,d0
.vb2
	cmp.w	(vcount).w,d0	;and the one after
	beq.s	.vb2
	move.w	(sp)+,d0
	jsr	(stop_current_song).l	;restart the sound driver, command 7 with d1 = 0
	move.w	#9,d0
	jsr	(SoundCmd).l
	move.w	#0,d0
	move.w	#$1B63,d1
	movea.l	#Z80Program,a0
	jsr	(SoundCmd).l
	move.w	#6,d0
	clr.w	d1
	movea.l	#SoundBanks,a0
	jsr	(SoundCmd).l
	move.w	#7,d0
	move.w	#0,d1
	jsr	(SoundCmd).l
	move.w	#2,-(sp)	;song 2
	jsr	(song).l
	jsr	(UpdateScores).l
	cmpi.w	#4,(gsp).w
	bne.w	.4
	jsr	(AddPlayoffTeamStats).l
.4
	bset	#5,(sflags11).w
	bsr.w	Intermission
	bclr	#5,(sflags11).w
	cmpi.w	#4,(gsp).w	;game over from the menu
	bne.w	.5
	jmp	(GameOver).l
.5
	cmpi.w	#3,(gsp).w
	bne.w	StartPer
	bset	#1,(sflags7).w	;overtime

StartPer	;Start a period: reset stack, rink and clock, face off, run the game loop
	movea.w	#(Stack-M68K_RAM),sp
	jsr	(SoundOff).l	;sound off
	jsr	(setupice).l
	jsr	(ResetClock).l
	ori.l	#$F00000,(PadControlBits).w	;ori.w #$F000
	st	(c1playernum).w	;no controlled player yet
	st	(c2playernum).w
	st	(c3playernum).w
	st	(c4playernum).w
	movea.w	#(puckx-M68K_RAM),a3	;puck
	clr.w	(fox).w	;face off at center ice
	clr.w	(foy).w
	btst	#0,(gmode2).w
	beq.w	.fo
	move.w	#$1F,d0	;shootout assignment (94: $1E)
	move.w	#8,(BA_Skater_Offset).w
	move.w	#$B,(BA_Goalie_SCnum).w
	bra.w	.ass
.fo
	move.l	#3,d0	;face off assignment (94: $1B)
.ass
	jsr	(assreplace).l	;face off starts period
	bset	#sf2drec,(sflags2).w	;sf2drec: don't record
	bclr	#sfwrap,(sflags).w	;sfwrap: reset replay stuff
	move.w	#$FFFF,(lastsfx).w
	move.l	#replaystart,(recbpr).w	;replaystart
	move.w	(vcount).w,(oldvcount).w
	bsr.w	DoGameFrame	;run two frames before the loop
	move.w	#$FFFF,(palcount).w
	bsr.w	DoGameFrame
	move.w	(gamelevel).w,d0
	asl.w	#4,d0
	move.w	d0,(CwdExciteLvl).w	;starting excitement = gamelevel*16
	clr.w	(CurCrowdMeter).w
	btst	#0,(gmode2).w	;no period tune in a shootout
	bne.w	.reg
	jsr	(stop_current_song).l	;restart the sound driver, command 7 with d1 = 1
	move.w	#9,d0
	jsr	(SoundCmd).l
	move.w	#0,d0
	move.w	#$1B63,d1
	movea.l	#Z80Program,a0
	jsr	(SoundCmd).l
	move.w	#6,d0
	clr.w	d1
	movea.l	#SoundBanks,a0
	jsr	(SoundCmd).l
	move.w	#7,d0
	move.w	#1,d1
	jsr	(SoundCmd).l
	move.w	(HomeTeam).w,(HmTeam).w
	move.w	#0,(SongIndex).w
	jsr	(ChooseSong).l
	move.w	(SongNum).w,-(sp)	;period start tune
	jsr	(song).l
.reg
	cmpi.w	#2,(gsp).w
	bge.w	.loop
	bset	#sf3fosong,(sflags3).w	;set for periods 1 and 2 only
.loop
	bra.w	Gameloop

Gameloop	;Main loop for game
	bsr.w	DoGameFrame
	jsr	(demoread).l	;check if demo mode
	btst	#sfpz,(sflags).w	;sfpz
	beq.s	Gameloop
	jsr	(Pausemode).l
	move.b	#$E7,(VDP_PSG).l	;psg noise back on (as StartGame)
	move.b	#$C8,(VDP_PSG).l
	move.b	#1,(VDP_PSG).l
	bra.s	Gameloop

DoGameFrame	;Wait for at least one vblank, then run one frame of game logic. in 94 this is written in line
	move.w	(vcount).w,d7
	sub.w	(oldvcount).w,d7	;number of frames since last loop
	beq.s	DoGameFrame
	move.w	(vcount).w,(oldvcount).w
	tst.w	(ShotTimer).w
	bmi.w	.periodic
	sub.w	d7,(ShotTimer).w
.periodic
	jsr	(CheckNewCarrier).l
	jsr	(PenaltyManager).l
	jsr	(updatecrowdf).l
	jsr	(updatesound).l
	jsr	(clockcont).l
	sub.w	d7,(lldisp).w	;count down for screen updates
	bpl.w	.frame
	addi.w	#jps,(lldisp).w	;jps: only update once per second
	jsr	(ChkGoalies).l
	jsr	(UpdateCwdExcite).l
	jsr	(CheckLateGameSong).l
	jsr	(RestoreBenchEnergy).l
	jsr	(CheckInjury).l
	jsr	(updatepwrplay).l
.frame
	jsr	(checkwindow).l	;94 calls it after setSlotBit
	jsr	(updateplayers).l	;apply velocity and check collisions
	tst.w	(songdelay).w	;delayed song countdown
	beq.w	.nosong
	bmi.w	.nosong
	subq.w	#1,(songdelay).w
	bne.w	.nosong
	move.w	(delayedsong).w,-(sp)	;94 calls stop_current_song first
	jsr	(song).l
.nosong
	jsr	(setSlotBit).l
	jsr	(SprSort).l
	jsr	(updatereplay).l
	jmp	(setvideo).l
	rts	;Not reached

Intermission	;Before the period: at game over (gsp 4) the records (UpdateRecords); outside a shootout the auto line
	;change and every sort object's Xpos to 0; then the pause menu (Pausemode with sflags12 bit 0). Called from StartGame
	cmpi.w	#4,(gsp).w
	bne.w	.1
	move.w	#0,(gameclock).w
	jsr	(UpdateRecords).l
.1
	btst	#0,(gmode2).w
	bne.w	.menu
	jsr	(SetupTeamForIntermission).l
	moveq	#$F,d0	;Sortobjs-1
	movea.w	#(SortCords-M68K_RAM),a0
.clr
	clr.w	(a0)	;Xpos
	adda.w	#SCstruct,a0
	dbf	d0,.clr
.menu
	bset	#0,(sflags12).w
	jsr	(Pausemode).l
	bclr	#0,(sflags12).w
	rts

updateplayers	;This routine calls all collision/animation/assignment code for all players. d7 = elapsed frames.
	;94 ; 95 has no puckz or crowd record checks here, and moves the velocity update (updatevel) and the pad input
	;(updatepadinput) out
	ori.l	#$F,(PadControlBits).w	;ori.w #$F
	movea.w	#(SortCords-M68K_RAM),a3
.top
	move.w	SCnum(a3),d6
	move.l	(a3),OldXpos(a3)	;Xpos, oldXpos
	move.l	Ypos(a3),OldYpos(a3)	;Ypos, oldYpos
	move.l	Zpos(a3),OldZpos(a3)	;Zpos, oldZpos
	btst	#pf3fall,pflags3(a3)	;falling down?
	beq.w	.top2	;branch if not
	clr.w	Xvel(a3)	;clear Xvel
	clr.w	Yvel(a3)	;clear Yvel
	tst.w	SPAnum(a3)	;check animation index
	bne.w	.0	;branch if index not 0
	jsr	(PlaceBoardFall).l
	bra.w	.top2
.0
	cmpi.w	#SPAbenchcheckl,SPA(a3)
	beq.w	.10
	cmpi.w	#SPAbenchcheckr,SPA(a3)
	beq.w	.8
	cmpi.w	#SPAboardleft,SPA(a3)
	beq.w	.9
	cmpi.w	#SPAboardright,SPA(a3)
	beq.w	.7
	cmpi.w	#SPAboardfront,SPA(a3)
	beq.w	.1
	cmpi.w	#SPAboardback,SPA(a3)
	beq.w	.4
	bra.w	.top2
.1
	move.w	#$124,d0
	cmpi.w	#$56,(FallXPos).w
	bgt.w	.2
	cmpi.w	#$FFAA,(FallXPos).w
	bgt.w	.3
.2
	move.w	#$116,d0
.3
	move.w	d0,Ypos(a3)
	bra.w	.top2
.4
	move.w	#$FEDC,d0
	cmpi.w	#$56,(FallXPos).w
	bgt.w	.5
	cmpi.w	#$FFAA,(FallXPos).w
	bgt.w	.6
.5
	move.w	#$FEEA,d0
.6
	move.w	d0,Ypos(a3)
	bra.w	.top2
.7
	move.w	#$92,(a3)	;$82
	btst	#3,attribute(a3)
	beq.w	.top2
	move.w	#$FF6E,(a3)
	bra.w	.top2
.8
	move.w	#$98,(a3)	;$88
	btst	#3,attribute(a3)
	beq.w	.top2
	move.w	#$FF68,(a3)
	bra.w	.top2
.9
	move.w	#$FF6E,(a3)
	btst	#3,attribute(a3)
	beq.w	.top2
	move.w	#$92,(a3)
	bra.w	.top2
.10
	move.w	#$FF68,(a3)
	btst	#3,attribute(a3)
	beq.w	.top2
	move.w	#$98,(a3)
.top2
	bsr.w	updateanim
	sub.b	d7,nopuck(a3)	;no puck control
	bpl.w	.np
	clr.b	nopuck(a3)	;clear upper byte of nopuck
.np
	sub.b	d7,nopuck+1(a3)	;subtract # of frames from nopuck+1
	bpl.w	.np2
	clr.b	nopuck+1(a3)	;clear lower byte of nopuck
.np2
	btst	#sf3icetime,(sflags3).w	;check if penalty timer is up
	beq.w	.11
	clr.w	d0
	move.b	pnum(a3),d0	;player offset on roster
	bmi.w	.11
	add.w	d0,d0
	addi.w	#$138,d0	;$136
	jsr	(loadTeamStruct).l
	addq.w	#1,(a2,d0.w)	;add 1 to TOI for player
.11
	moveq	#$11,d4
	tst.w	(PalMode).w
	beq.w	.notoside
	moveq	#$18,d4	;PAL (94: $16)
.notoside
	mulu.w	d7,d4	;update velocity
	cmpi.w	#SPAinjuryfall,SPA(a3)
	beq.w	.done
	cmpi.w	#SPAinjury1,SPA(a3)
	beq.w	.done
	cmpi.w	#SPAinjury2,SPA(a3)
	beq.w	.done	;branch if d0 is 0
	jsr	(updatevel).l	;94 does this in line
.done
	move.w	SCnum(a3),d6	;SCnum
	cmp.w	(puckc).w,d6	;check if puck carrier
	bne.w	.tp	;not puck carrier
	moveq	#-2,d4	;-2 - pad index for puck carrier
	bsr.w	setpads
.tp
	btst	#sf2faceoff,(sflags2).w	;sf2faceoff- check for faceoff
	bne.w	.tp2	;branch if faceoff
	tst.w	(holdreset).w
	beq.w	.tp2
	subq.w	#1,(holdreset).w
	beq.w	.12
	bpl.w	.tp2
.12
	clr.w	(holdreset).w
	move.w	#$1111,(bholdtimer).w
	move.w	#$1111,(bholdtimer34).w
.tp2
	jsr	(updatepadinput).l	;94 does the pads in line
	adda.w	#SCstruct,a3	;SCstruct size
	cmpi.w	#$F,SCnum-SCstruct(a3)	;compare Sortobjs-1 to SCnum-SCstruct
	blt.w	.top	;loop for all Sort objects
	rts
