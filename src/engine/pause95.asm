;	Pause. This file runs the pause mode and its screen with the three tab pause menu, including
;	manual goalie, goalie selection and timeouts, and shows the scores on the pause screen.

;-------------------------------------------------------------------------------------------------------------
;	Entering pause mode and setting up the pause screen.


Pausemode							;(PauseMode). Game is in pause mode now: fade out, stop the sound (unless
									;sflags9 bit 5), run the pause menu
									;(SetPauseMenuItems, Pausemode_top, HandleMenuInput) until it ends or,
									;with no pad on a team, $708 frames pass without a button; then reload the
									;sound driver (SoundCmd 9, 0 Z80Program, 6 SoundBanks, 7) and restore the
									;screen (RestoreGameScreen, setvideo) and fade in. Called from DoGameFrame
	move.w	(smallfontchars).w,-(sp)
	clr.w	(menucursor).w
	clr.l	(menuitemoffset).w
	jsr	(forceblack).l				;fade screen to black
	move.w	d0,-(sp)
	move.w	(Vcount).w,d0
.vb
	cmp.w	(Vcount).w,d0
	beq.s	.vb						;wait for the next vblank
	move.w	(sp)+,d0
	btst	#sfpz,(sflags).w
	beq.w	.1
	btst	#5,(sflags9).w
	bne.w	.1						;eq = leave pause
	jsr	(SoundOff).l
	bra.w	.1						;to the next instruction
.1
	move.w	(sflags).w,-(sp)
	jsr	(seta2).l					;a2 = team of pausing controller
	move.w	#$3C,(menutimer).w
	move.w	#2,(menucursor).w
	bsr.w	SetPauseMenuItems
	movea.l	(menulist).w,a0
	lea	Pausemode_pall(pc),a1		;screen draw routine
	jsr	(Pausemode_top).l
	move.l	#$708,(pausetimeout).w
.loop
	jsr	(vcountwait).l
	jsr	(ReadMenuJoy).l
	tst.w	d1
	beq.w	.3
	move.l	#$708,(pausetimeout).w
.3
	jsr	(AnyPadAssigned).l
	bne.w	.4
	subq.l	#1,(pausetimeout).w
	bmi.w	.5
.4
	jsr	(ProcessInputWithRepeat).l
	jsr	(HandleMenuInput).l
	bne.s	.loop					;eq = leave pause
.5
	jsr	(forceblack).l
	btst	#7,(sflags9).w
	beq.w	.6
	jsr	(PracticeGoalies).l
.6
	btst	#5,(sflags9).w
	bne.w	.7
	jsr	(stop_current_song).l
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
.7
	move.w	(sp)+,(sflags).w
	jsr	(RestoreGameScreen).l
	movea.l	#Vdata,a0
	move.w	#VDPR_WINX,Vctrl-Vdata(a0)
	move.w	#VDPR_WINY,Vctrl-Vdata(a0)
	bclr	#sfpz,(sflags).w
	jsr	(setvideo).l
	move.w	#$18,(palcount).w
	btst	#5,(sflags11).w
	beq.w	.wait
	move.w	#$FFFF,(palcount).w
.wait
	tst.w	(palcount).w
	bpl.s	.wait
	move.w	(Vcount).w,(OldVcount).w
	move.w	(sp)+,(smallfontchars).w
	rts

Pausemode_pall					;Draw routine for the pause menu: PauseScreenDraw, then KillCrowd
	jsr	(PauseScreenDraw).l
	jsr	(KillCrowd).l
	rts

;-------------------------------------------------------------------------------------------------------------
;	The pause menu: its tabs, item lists and drawing, and restoring the game screen afterwards.
seta2								;Set a2 to the team struct of the pause pad (menupadnum: cont1team ...
									;cont4team). Called from Pausemode and
									;HandleMenuInput
	movea.l	#tmstruct,a2
	tst.w	(menupadnum).w
	beq.w	.seta20
	cmpi.w	#1,(menupadnum).w
	beq.w	.1
	cmpi.w	#2,(menupadnum).w
	beq.w	.0
	cmpi.w	#1,(cont4team).w
	bra.w	.seta21
.0
	cmpi.w	#1,(cont3team).w
	bra.w	.seta21
.1
	cmpi.w	#1,(cont2team).w
	bra.w	.seta21
.seta20
	cmpi.w	#1,(cont1team).w
.seta21
	beq.w	.x
	adda.w	#tmsize,a2
.x
	rts

Pausemode_top						;Start a menu: a0 = item list, a1 = screen draw routine; selection and
									;first shown item 0. Falls into
									;DrawMenuScreen. Called from Pausemode
	move.l	a0,(menulist).w			;item list
	move.l	a1,(menudraw).w			;draw routine
	clr.w	(menuitem).w			;selected item
	clr.w	(menuitem+2).w			;first item shown

DrawMenuScreen						;Call the draw routine, clear the menu box, print the items
									;(Pausemode_Pmenu) and fade in
	movea.l	(menudraw).w,a0
	jsr	(a0)
	bsr.w	ClearMenuBox
RedrawMenu							;Print the menu items and fade in. Called from the menu items below
									;(ManualGoalieMenu, Pausemode_go, TimeoutMenu) after they clear the
									;box
	jsr	(printsmallz).l
	String	CC_SetAttribute,4,CC_SetY,$C
	jsr	(SetMenuPrintX).l
	jsr	(Pausemode_Pmenu).l
	move.w	#$18,(palcount).w
	rts

HandleMenuInput						;Pause menu pad d1: right / left move between the three tabs (menucursor:
									;INFO, STATS, PAUSE; SetInfoMenuItems ...)
									;down / up the item, C (bit 5) runs the item routine (seta2 first); ne =
									;stay in the menu (PlayGame sets sflags9 bit 3 to leave). With sflags9 bit
									;5 only ShowPenaltyMessages runs
	btst	#sbut,d1				;sbut
	bne.w	.flip
	btst	#5,(sflags9).w
	beq.w	.0
	bsr.w	ShowPenaltyMessages
	bra.w	.flip
.0
	btst	#3,d1
	beq.w	.2
	addq.w	#1,(menucursor).w
	cmpi.w	#3,(menucursor).w
	blt.w	.1
	clr.w	(menucursor).w
.1
	bra.w	.12
.2
	btst	#2,d1
	beq.w	.4
	subq.w	#1,(menucursor).w
	bpl.w	.3
	move.w	#2,(menucursor).w
.3
	bra.w	.12
.4
	btst	#dbut,d1				;dbut
	beq.w	.up
	addq.w	#1,(menuitem).w			;next lower item
	bra.w	Pausemode_Pmenu
.up
	btst	#ubut,d1				;ubut
	beq.w	.sel
	subq.w	#1,(menuitem).w			;next higher item
	bra.w	Pausemode_Pmenu
.sel
	btst	#cbut,d1				;cbut
	bne.w	.7
	beq.w	.flip
.7
	cmpi.l	#ZeroLong,(menulist).w
	beq.w	.flip
	bsr.w	seta2
	move.w	(menuitem).w,d0			;find the handler of the selected item
	movea.l	(menulist).w,a0
	adda.l	(menuitemoffset).w,a0
	adda.w	(a0),a0
	adda.w	(a0),a0
	cmpi.l	#$4FF00,(a0)			;the $FF String: no items
	beq.w	.10
	bra.w	.9
.next
	addq.w	#4,a0
.9
	adda.w	(a0),a0
	dbf	d0,.next
	movea.l	(a0),a0
	bclr	#3,(sflags9).w
	move.b	(sflags12).w,-(sp)
	bclr	#0,(sflags12).w
	jsr	(a0)						;the handler of the selected item
	move.b	(sp)+,(sflags12).w
	btst	#3,(sflags9).w
	eori	#4,ccr
.10
	rts
.flip
	eori	#4,ccr					;invert Z
	rts
.12
	tst.w	(menucursor).w
	beq.w	.14
	cmpi.w	#1,(menucursor).w
	beq.w	.13
	cmpi.l	#PauseMenus,(menulist).l
	beq.w	.15
	bsr.w	SelectPauseTab
	bsr.w	SetPauseMenuItems
	clr.w	(menuitem).w
	clr.w	(menuitem+2).w
	jsr	(ClearMenuBox).l
	bra.w	Pausemode_Pmenu
.13
	cmpi.l	#StatsMenus,(menulist).l
	beq.w	.15
	bsr.w	SelectStatsTab
	bsr.w	SetStatsMenuItems
	clr.w	(menuitem).w
	clr.w	(menuitem+2).w
	jsr	(ClearMenuBox).l
	bra.w	Pausemode_Pmenu
.14
	cmpi.l	#InfoMenus,(menulist).l
	beq.w	.15
	bsr.w	SelectInfoTab
	bsr.w	SetInfoMenuItems
	clr.w	(menuitem).w
	clr.w	(menuitem+2).w
	jsr	(ClearMenuBox).l
	bra.w	Pausemode_Pmenu
.15
	rts

SetPauseMenuItems					;menulist = PauseMenus, menuitemoffset by mode: tmflags bit 2 (no timeout
									;left) $23A, shootout $2CE
									;Practice Mode $13E ($1D2 when paused), game over with GameFlags bit 3 $AA
	clr.l	(menuitemoffset).w
	move.l	#PauseMenus,(menulist).l
	btst	#2,$30(a2)
	beq.w	.0
	move.l	#$23A,(menuitemoffset).l
.0
	btst	#0,(gmode2).w
	beq.w	.1
	move.l	#$2CE,(menuitemoffset).l
.1
	btst	#7,(sflags9).w
	beq.w	.2
	move.l	#$13E,(menuitemoffset).l
	btst	#sfpz,(sflags).w
	beq.w	.2
	move.l	#$1D2,(menuitemoffset).l
.2
	btst	#3,(GameFlags).w
	beq.w	.exit
	cmpi.w	#4,(gsp).w
	bne.w	.exit
	move.l	#$AA,(menuitemoffset).l
.exit
	rts

SetStatsMenuItems					;menulist = StatsMenus, menuitemoffset by mode: GameFlags bit 3 $F0,
									;sflags10 bit 0 $74, shootout or Practice
									;Mode $66
	clr.l	(menuitemoffset).w
	btst	#3,(GameFlags).w
	beq.w	.0
	move.l	#$F0,(menuitemoffset).l
	bra.w	.set
.0
	btst	#0,(sflags10).w
	beq.w	.1
	move.l	#$74,(menuitemoffset).l
	bra.w	.set
.1
	btst	#0,(gmode2).w
	beq.w	.2
	move.l	#$66,(menuitemoffset).l
	bra.w	.set
.2
	btst	#7,(sflags9).w
	beq.w	.set
	move.l	#$66,(menuitemoffset).l
.set
	move.l	#StatsMenus,(menulist).l
	rts

SetInfoMenuItems					;menulist = InfoMenus, menuitemoffset $7E in a
									;shootout, $D0 in Practice Mode
	clr.l	(menuitemoffset).w
	move.l	#InfoMenus,(menulist).l
	btst	#0,(gmode2).w
	beq.w	.0
	move.l	#$7E,(menuitemoffset).l
	bra.w	.exit
.0
	btst	#7,(sflags9).w
	beq.w	.exit
	move.l	#$D0,(menuitemoffset).l
.exit
	rts

startpause							;Pause on (sfpz)
	bset	#sfpz,(sflags).w		;sfpz
	rts

startpause1							;Pause initiated by cont 1
	clr.w	(menupadnum).w
	bra.s	startpause

startpause2							;Pause initiated by cont 2
	move.w	#1,(menupadnum).w
	bra.s	startpause

startpause3							;Pause initiated by cont 3 (4 way play)
	move.w	#2,(menupadnum).w
	bra.s	startpause

startpause4							;Pause initiated by cont 4 (4 way play)
	move.w	#3,(menupadnum).w
	bra.s	startpause

PauseScreenDraw						;Draw the pause screen (Pausemode_pall): wait out the dma, plane B off,
									;window 3 rows, clear the rink map
									;the pause background (PauseBgBitmap at 0, 0 / 0, 3 / 0, $19), the period
									;number (not in a shootout or overtime), load the pause fonts, clock
									;digits and tab tiles, the team blocks of both teams, the three tabs (the
									;one of menulist selected), showclock, the penalty boxes
									;(ShowPenaltyBoxes) and fade in
	movem.l	d0-d7/a0-a6,-(sp)
.wait
	btst	#dfok,(disflags).w
	bne.s	.wait
	clr.w	(Hscroll).w
	clr.w	(Vscroll).w
	jsr	(SetScroll2).l
	move.w	(disflags).w,-(sp)
	bset	#dfng,(disflags).w
	movea.l	#Vdata,a0
	move.w	#VDPR_WINX,Vctrl-Vdata(a0)	;no window
	move.w	#VDPR_WINY,Vctrl-Vdata(a0)
	move.w	(VSPRITES).w,d0
	jsr	(Vmaddr).l
	move.l	#0,(a0)					;first sprite off
	move.w	#VDPR_MODE4+$81,Vctrl-Vdata(a0)	;40 col mode
	move.w	#6,(Map2col1).w
	move.w	#VDPR_HSCROLL,Vctrl-Vdata(a0)	;hscroll table at 0
	clr.w	d0
	jsr	(Vmaddr).l
	move.l	#0,(a0)
	move.w	(sp)+,(disflags).w
	bclr	#df32c,(disflags).w
	move.w	#$800,d0
	move.w	(VmMAP1).w,d1
	move.w	#$7FF,d2
	jsr	(DoFill).l
	jsr	(printz).l
	String	-(TXPRI+TXMAP2),0,0,0
	movea.l	#PauseBgBitmap,a0
	movea.l	a0,a1
	movea.l	a0,a2
	adda.l	(a2)+,a0
	adda.l	(a2)+,a1
	clr.w	d0
	clr.w	d1
	move.w	(a1),d2
	move.w	#3,d3
	moveq	#1,d4
	moveq	#$F,d5
	jsr	(dobitmap).l
	move.w	d4,-(sp)
	jsr	(printz).l
	String	-(TXPRI+TXMAP2),0,3,0
	movea.l	#PauseBgBitmap,a0
	movea.l	a0,a1
	movea.l	a0,a2
	adda.l	(a2)+,a0
	adda.l	(a2)+,a1
	clr.w	d0
	move.w	#3,d1
	move.w	(a1),d2
	move.w	#$16,d3
	moveq	#1,d4
	moveq	#0,d5
	movea.l	#ZeroLong,a2			;a zero long: no palettes
	jsr	(dobitmap).l
	jsr	(printz).l
	String	-(TXPRI+TXMAP2),0,$19,0
	movea.l	#PauseBgBitmap,a0
	movea.l	a0,a1
	movea.l	a0,a2
	adda.l	(a2)+,a0
	adda.l	(a2)+,a1
	clr.w	d0
	move.w	#$19,d1
	move.w	(a1),d2
	move.w	#3,d3
	moveq	#1,d4
	moveq	#0,d5
	movea.l	#ZeroLong,a2
	jsr	(dobitmap).l
	move.w	(sp)+,d4
	jsr	(printz).l
	String	-(TXPRI+TXPAL2+TXMAP2),$10,7,0
	btst	#0,(gmode2).w			;shootout: no period number
	bne.w	.fonts
	cmpi.w	#3,(gsp).w
	bge.w	.fonts
	move.w	(gsp).w,d0
	mulu.w	#3,d0
	add.w	d0,(printx).w
	move.w	d4,(TempPlOffset).w
	movea.l	#PeriodNumberBitmap+8,a2
	jsr	(DecompressGraphicsWithCallback).l
	dc.b	$02,$23,$45,$15,$4D,$A8,$CD,$E3	;remap table
	move.w	d4,-(sp)
	move.w	(TempPlOffset).w,d4
	movea.l	#PeriodNumberBitmap,a0
	movea.l	a0,a1
	movea.l	a0,a2
	adda.l	(a2)+,a0
	adda.l	(a2)+,a1
	move.w	(printx).w,d0
	subi.w	#$10,d0
	clr.w	d1
	move.w	#2,d2
	move.w	#1,d3
	moveq	#0,d5
	movea.l	#ZeroLong,a2
	jsr	(dobitmap).l
	move.w	(sp)+,d4
.fonts
	move.w	d4,(smallfontchars).w
	move.l	#PauseFontMap,(smallfontptr).l
	movea.l	(smallfontptr).w,a2
	addq.w	#8,a2
	jsr	(DecompressGraphicsWithCallback).l
	dc.b	$01,$23,$45,$67,$89,$AB,$CD,$9F	;remap table
	move.w	d4,(smallfont2chars).w
	movea.l	#PauseFontMap+8,a2
	jsr	(DecompressGraphicsWithCallback).l
	dc.b	$01,$23,$45,$67,$89,$AB,$CB,$EF	;remap table
	move.w	d4,(clockdigitchars).w
	movea.l	#ClockDigitsBitmap+8,a2
	jsr	(DecompressGraphicsPlain).l
	move.w	d4,(pauselogochars).w
	addi.w	#$32,d4
	move.w	d4,(tabchars).w
	movea.l	#TabBitmap+8,a2
	jsr	(DecompressGraphicsPlain).l
	move.l	#PauseTeamBlocksMap,(teamblocksmapptr).l
	jsr	(setupTeamBlocksMap).l
	move.w	#$30,d0
	move.w	#2,(printx).w
	move.w	#4,(printy).w
	jsr	(PutTeamBlock).l
	move.w	#$1A,(printx).w
	clr.w	d0
	jsr	(PutTeamBlock).l
	jsr	(ClearInfoTab).l
	jsr	(ClearStatsTab).l
	jsr	(ClearPauseTab).l
	btst	#5,(sflags9).w
	bne.w	.tabs
	cmpi.l	#InfoMenus,(menulist).l
	bne.w	.0
	bsr.w	SelectInfoTab
	bra.w	.tabs
.0
	cmpi.l	#StatsMenus,(menulist).l
	bne.w	.1
	bsr.w	SelectStatsTab
	bra.w	.tabs
.1
	cmpi.l	#PauseMenus,(menulist).l
	bne.w	.tabs
	bsr.w	SelectPauseTab
.tabs
	jsr	(showclock).l
	jsr	(PauseScores).l
	bsr.w	ShowPenaltyBoxes
	jsr	(printz).l
	String	-TXMAP2,0,0,0
	move.w	#$18,(palcount).w
	movem.l	(sp)+,d0-d7/a0-a6
	rts

ShowPenaltyBoxes					;The pause screen penalty boxes: home at $1F, $E, away at 2, $E
									;(ShowPenaltyBox)
	movem.l	d0-d7/a0-a3,-(sp)
	jsr	(printz).l
	String	-(TXPRI+TXMAP2),$1F,$E,0
	movea.l	#tmstruct,a2
	bsr.w	ShowPenaltyBox
	jsr	(printz).l
	String	-(TXPRI+TXMAP2),2,$E,0
	movea.l	#AwShots,a2
	bsr.w	ShowPenaltyBox
	movem.l	(sp)+,d0-d7/a0-a3
	rts

ShowPenaltyBox						;The players in the penalty box list of team a2 ($9C, -1 ends; with
									;sflags9 bit 5 less the impact count)
									;ShowPenaltyBoxPlayer each
	lea	$9C(a2),a0
	clr.w	d7
.count
	tst.b	(a0)+
	bmi.w	.counted
	addq.w	#1,d7
	bra.s	.count
.counted
	btst	#5,(sflags9).w
	beq.w	.list
	sub.w	impact(a2),d7
.list
	lea	$9C(a2),a0
.next
	clr.w	d0
	subq.w	#1,d7
	bmi.w	rtsmenu
	move.b	(a0)+,d0
	bmi.w	rtsmenu
	bsr.w	ShowPenaltyBoxPlayer
	bra.s	.next

ListPenaltyBox						;Unreferenced. ShowPenaltyBox without the count: every player in the box
									;list of team a2
	lea	$9C(a2),a0
.next
	clr.w	d0
	move.b	(a0)+,d0
	bmi.w	rtsmenu
	bsr.w	ShowPenaltyBoxPlayer
	bra.w	.1
.1
	subq.w	#1,d7
	bmi.w	rtsmenu
	bra.s	.next

ShowPenaltyBoxPlayer				;Print player d0 / 2 + 1 of team a2: jersey number and penalty time left
									;(tmpdst), one line down, up to printy $13
	move.w	d7,-(sp)
	cmpi.w	#$13,(printy).w
	bhi.w	.full
	move.w	$68(a2,d0.w),d2
	andi.w	#$7FF,d2
	lsr.w	#1,d0
	addq.w	#1,d0
	move.l	d7,-(sp)
	move.w	Xvel(a2),d7
	jsr	(GetRosterName).l
	move.w	Xvel(a2),d7
	subq.w	#1,d0
	jsr	(GetJerseyNumber).l
	move.l	(sp)+,d7
	clr.w	d0
	move.b	(jerseynum).w,d0
	move.w	(printx).w,-(sp)
	movea.w	#(TextBuffer-M68K_RAM),a1
	jsr	(ConvertByteToDigits).l
	movea.w	#(mesarea-M68K_RAM),a1
	move.w	#4,(a1)
	jsr	(print).l
	move.w	d2,d0
	jsr	(PushTime).l
	jsr	(print).l
	move.w	(sp)+,(printx).w
	addq.w	#1,(printy).w
.full
	move.w	(sp)+,d7

rtsmenu								;An rts branched to from ShowPenaltyBox and ListPenaltyBox
	rts

RestoreGameScreen					;Rebuild the game screen after the pause screen: the vdp maps, palettes
									;vram, framer, fonts, energy bar, crowd and EASN tiles, the face off
									;screen (disflags bit 4) or the ref tiles, the rink tiles and home team
									;graphics, then printscores1. Called from Pausemode (above)
	movem.l	d0-d7/a0-a6,-(sp)
	clr.w	(printfontset).w
	bclr	#5,(sflags9).w
	clr.w	(tmstruct+$32).w
	clr.w	(AwShots+$32).w
	move.l	#VBlank,(VBint).w
	bset	#df32c,(disflags).w
	move.w	#$C000,(VmMAP2).w
	move.w	#6,(Map2col1).w
	move.w	#$DC00,(VSPRITES).w
	move.w	#$E000,(VmMAP1).w
	move.w	#6,(Map1col1).w
	move.w	#$F000,(VmMAP3).w
	move.w	#5,(Map3col1).w
	move.w	#$FC00,(VSCRLPM).w
	movea.w	#(palfadenew-M68K_RAM),a0
	moveq	#$1F,d1
.clrpal
	clr.l	(a0)+
	dbf	d1,.clrpal
	jsr	(setplayercolors).l
	jsr	(setupIceRinkPal).l
	jsr	(setVram_0).l
	jsr	(ClearOldFrames).l
	move.w	#$800,d0
	move.w	(VmMAP1).w,d1
	move.w	#$7FF,d2
	jsr	(DoFill).l
	move.w	(framerchars).w,d4
	jsr	(AddFramer2).l
	jsr	(AddFonts).l
	move.w	(energybarchars).w,d4
	movea.l	#EnergyBarMap+8,a2
	jsr	(DecompressGraphicsPlain).l
	move.w	(animchars).w,d4
	movea.l	#Crowdframelist+8,a2
	jsr	(DecompressGraphicsPlain).l
	jsr	(setupEASNmap).l
	btst	#4,(disflags).w
	beq.w	.ref
	btst	#sf2replay,(sflags2).w
	bne.w	.ref
	move.w	(ExtraChars).w,d4
	movea.l	#FaceoffTiles+8,a2
	jsr	(DecompressGraphicsPlain).l
	move.w	d4,(faceoffvrcset).w
	movea.l	#FaceoffTiles2+8,a2
	jsr	(DecompressGraphicsPlain).l
	jsr	(DrawFaceoffWindow).l
	bra.w	.rink
.ref
	move.w	(ExtraChars).w,d4
	btst	#sfhor,(sflags).w
	beq.w	.2
	movea.l	#RefTilesHor+8,a2
	bra.w	.load
.2
	movea.l	#RefTiles+8,a2
.load
	jsr	(DecompressGraphicsPlain).l
.rink
	move.w	(disflags).w,-(sp)
	bset	#dfng,(disflags).w
	move.w	#$7D0,(Oldrow).w
	clr.w	d4
	move.w	d4,(rinkvrcset).w
	movea.l	#Rinktilelist+8,a2
	jsr	(DecompressGraphicsPlain).l
	jsr	(LoadHomeTeamGfx).l
	jsr	(setplayercolors).l
	jsr	(setupIceRinkPal).l
	move.w	(sp)+,(disflags).w
	bclr	#dfok,(disflags).w
	bclr	#dfng,(disflags).w
	move	#$2300,sr
	jsr	(SprSort).l
	move.w	(Vcount).w,d0
.wait
	cmp.w	(Vcount).w,d0
	beq.s	.wait
	bset	#dfclock,(disflags).w
	jsr	(printscores1).l
	btst	#sf2replay,(sflags2).w
	bne.w	.6
	move.w	#$64,(palcount).w
.6
	movem.l	(sp)+,d0-d7/a0-a6
	rts

ClearOldFrames						;Oldframe = -1 for the 16 sort objects, the 4 sso and the 6 pads, so
									;addframe2 sends their tiles again
	movem.l	d0-d1/a0-a3,-(sp)
	movea.l	#SortCords,a0
	move.w	#$80,d0
	move.w	#$F,d1
.sort
	st	8(a0)
	adda.w	d0,a0
	dbf	d1,.sort
	movea.l	#sso,a0
	move.w	#$14,d0
	move.w	#3,d1
.sso
	st	8(a0)
	adda.w	d0,a0
	dbf	d1,.sso
	movea.l	#pads,a0
	move.w	#$1C,d0
	move.w	#5,d1
.pads
	st	8(a0)
	adda.w	d0,a0
	dbf	d1,.pads
	movem.l	(sp)+,d0-d1/a0-a3
	rts

SetMenuPrintX						;printx = $A (95; 94 4)
	move.w	#$A,(printx).w
	rts

Pausemode_Pmenu					;Clamp menuitem to the list, scroll menuitem+2 to show it, and print 4
									;items from printy $C (the selected one in the highlight attribute) with
									;the up / down arrows; no menu (menulist $69A): DrawMenuInfo
	btst	#5,(sflags9).w
	bne.w	.x
	cmpi.l	#ZeroLong,(menulist).w
	bne.w	.0
	jmp	(DrawMenuInfo).l
.0
	move.w	(menuitem).w,d0
	bpl.w	.1
	clr.w	(menuitem).w			;no item above the first
	clr.w	d0
.1
	movea.l	(menulist).w,a0
	adda.l	(menuitemoffset).w,a0
	adda.w	(a0),a0
	adda.w	(a0),a0
	bra.w	.3
.next
	adda.w	(a0),a0
	addq.w	#4,a0
	tst.w	2(a0)					;negative: the last item
.3
	dbmi	d0,.next
	addq.w	#1,d0
	sub.w	d0,(menuitem).w			;no item below the last
	move.w	(menuitem).w,d0
	cmp.w	(menuitem+2).w,d0
	bge.w	.4
	move.w	d0,(menuitem+2).w		;scroll up
.4
	subq.w	#3,d0
	cmp.w	(menuitem+2).w,d0
	ble.w	.print
	move.w	d0,(menuitem+2).w		;scroll down
.print
	bsr.s	SetMenuPrintX
	move.w	#$D,(printy).w
	movea.l	(menulist).w,a1
	adda.l	(menuitemoffset).w,a1
	jsr	(printsmall).l				;the menu title
	jsr	(printsmallz).l
	dc.w	$28						;String length (too many arguments for the String macro):
	;menu box top, rows of blanks
	dc.b	$F9,$00,$FB,$01,$20,$FB,$FF,$FA,$01,$20,$FB,$FF,$FA,$01,$20,$FB
	dc.b	$FF,$FA,$01,$20,$FB,$12,$20,$FB,$FF,$FA,$FF,$20,$FB,$FF,$FA,$FF
	dc.b	$20,$FB,$FF,$FA,$FF,$20
	adda.w	(a1),a1
	move.w	(menuitem+2).w,d0		;skip to the first item shown
	bra.w	.7
.skip
	adda.w	(a1),a1
	addq.w	#4,a1
.7
	dbf	d0,.skip
	moveq	#3,d1					;4 rows
	move.w	#$C,(printy).w
	bsr.w	SetMenuPrintX
	move.w	(menuitem+2).w,d0
	beq.w	.row
	jsr	(printsmallz).l				;more items above
	String	CC_SetAttribute,0,CC_SetFont,0,CC_AddX,1,CC_AddY,1,$7B,CC_AddY,$FF,0	;the up arrow
.row
	bsr.w	SetMenuPrintX
	jsr	(printsmallz).l				;start of an item row
	String	CC_SetFont,0,CC_AddX,2,CC_AddY,2
	move.l	a1,-(sp)
	movea.l	(menulist).w,a1
	adda.l	(menuitemoffset).w,a1
	jsr	(printsmall).l
	cmp.w	(menuitem).w,d0
	bne.w	.nosel
	jsr	(printsmall).l				;the selected item marker
.nosel
	movea.l	(sp)+,a1
	bsr.w	PrintMenuItem			;the item text
	addq.w	#1,d0
	addq.w	#4,a1
	tst.w	2(a1)					;negative: the last item
	dbmi	d1,.row
	bpl.w	.10
	bsr.w	SetMenuPrintX
	addq.w	#1,(printy).w
	move	sr,-(sp)
	jsr	(printsmallz).l				;more items below
	String	CC_SetAttribute,0,CC_AddX,1
	movem.l	d0-d7/a0-a6,-(sp)
	move.w	#1,d0
	move.w	#1,d1
	move.w	#$7FF,d2
	jsr	(eraser).l
	movem.l	(sp)+,d0-d7/a0-a6
	move	(sp)+,sr
	subq.w	#1,(printy).w
	rts
.10
	bsr.w	SetMenuPrintX
	addq.w	#1,(printy).w
	jsr	(printsmallz).l
	String	CC_SetFont,0,CC_SetAttribute,0,CC_AddX,1,$7D,0	;the down arrow
	subq.w	#1,(printy).w
.x
	rts

PrintMenuItem						;printsmall item String a1 (advanced past it). y: START GAME, RESUME GAME
									;or EXIT GAME by gsp and sfpz x: MANUAL GOALIE or AUTO GOALIE by the pad
									;team's goaliemode1 / goaliemode2
	cmpi.b	#$79,2(a1)
	beq.w	.0
	cmpi.b	#$78,2(a1)				;first char 'x'
	bne.w	.plain
	move.l	a1,-(sp)
	movea.l	#.11,a1
	bsr.w	SetMenuPadSide
	btst	#1,(sflags).w			;sfpj: the pause pad
	beq.w	.homegoalie
	tst.w	(goaliemode2).w
	bra.w	.chkgoalie
.0
	move.l	a1,-(sp)
	cmpi.w	#4,(gsp).w
	beq.w	.1
	movea.l	#.4,a1
	btst	#sfpz,(sflags).w
	bne.w	.2
	tst.w	(gsp).w
	bne.w	.2
	movea.l	#.3,a1
	bra.w	.2
.1
	movea.l	#.5,a1
.2
	bra.w	.print
.3
	String	'   START GAME   '
.4
	String	'  RESUME GAME   '
.5
	String	'   EXIT GAME    '
.homegoalie
	tst.w	(goaliemode1).w
.chkgoalie
	beq.w	.print
	movea.l	#.12,a1
.print
	jsr	(printsmall).l
	movea.l	(sp)+,a1
	adda.w	(a1),a1					;skip the 'x' item text
	bra.w	.10
.plain
	jsr	(printsmall).l
.10
	rts
.11
	String	' MANUAL GOALIE  '
.12
	String	'  AUTO GOALIE   '

ClearMenuBox						;eraser $12 x $C at $B, $B
	jsr	(printsmallz).l
	String	CC_SetAttribute,4,CC_SetX,$B,CC_SetY,$B
	moveq	#$12,d0
	moveq	#$C,d1
	move.w	#$7FF,d2
	jmp	(eraser).l

DrawMenuInfo						;With no menu list: clear the box and run draw routine menuitem of
									;MenuInfoList (wrapping at 0)
	movem.l	d0-d7/a0-a6,-(sp)
	jsr	(ClearMenuBox).l
	btst	#5,(sflags9).w
	bne.w	.done
.get
	move.w	(menuitem).w,d0
	bpl.w	.1
	clr.w	(menuitem).w
	clr.w	d0
.1
	asl.w	#2,d0
	movea.l	#MenuInfoList,a0
	movea.l	(a0,d0.w),a0
	cmpa.l	#0,a0
	bne.w	.draw
	clr.w	(menuitem).w
	bra.s	.get
.draw
	jsr	(a0)
.done
	movem.l	(sp)+,d0-d7/a0-a6
	andi	#$FB,ccr
	rts

MenuInfoList						;The info page draw routines for DrawMenuInfo (0 ends)
	dc.l	PauseInfo,0
PauseInfo							;The info page: a bitmap at $11, $B (a0 is whatever printz left: the vdp
									;data port) and
									;PauseInfoText
	jsr	(printz).l
	String	-(TXPRI+TXMAP2),$11,$B,0
	movea.l	a0,a1
	movea.l	a0,a2
	adda.l	(a2)+,a0
	adda.l	(a2)+,a1
	clr.w	d0
	clr.w	d1
	move.w	(a1),d2
	move.w	2(a1),d3
	move.w	(pauselogochars).w,d4
	move.w	#0,d5
	jsr	(dobitmap).l
	movea.l	#PauseInfoText,a1
	jsr	(PrintLines).l
	rts
PauseInfoText						;The info page text (a placeholder in retail)
	String	-(TXPRI+TXMAP2),$B,$12,'Lots of good text:'
	String	-(TXPRI+TXMAP2),$B,$14,'stats and other'
	String	-(TXPRI+TXMAP2),$B,$16,'stuff.'
	String	$FF,0
PrintLines							;print the Strings at a1 up to a $FF String
	cmpi.b	#$FF,2(a1)
	beq.w	.x
	jsr	(print).l
	bra.s	PrintLines
.x
	rts

ShowPenaltyMessages					;Every $78 frames show the last queued penalty (penaltymsgs) and remove
									;it: its name (Penaltylist) and the player (FormatPlayerNumInitial)
									;centred at $14, $F / $11, and take him off the penalty box count.
									;d1 = 1 when the queue is empty
	movem.l	d0-d6/a0-a3,-(sp)
	subq.w	#1,(menutimer).w
	bpl.w	.notempty
.next
	movea.l	#penaltymsgs,a0
	tst.w	(a0)
	beq.w	.empty
	move.l	a0,-(sp)
	jsr	(printz).l
	String	-(TXPRI+TXMAP1),$A,$F,'                    '	;clear the two message lines
	jsr	(printz).l
	String	-(TXPRI+TXMAP1),$A,$11,'                    '
	movea.l	(sp)+,a0
.end
	tst.w	(a0)+
	bne.s	.end
	subq.l	#4,a0
	clr.w	d0
	move.b	(a0),d0
	movea.l	#Penaltylist,a1
	adda.w	(a1,d0.w),a1
	clr.w	d2
	move.b	1(a1),d2
	beq.w	.skip
	bmi.w	.skip
	move.w	#$78,(menutimer).w
	clr.w	d0
	move.b	1(a0),d0
	move.w	d0,-(sp)
	addq.l	#2,a1
	jsr	(printz).l
	String	-(TXPRI+TXMAP1),$14,$F,0
	move.w	(a1),d0
	subq.w	#2,d0
	lsr.w	#1,d0
	sub.w	d0,(printx).w
	jsr	(print).l
	move.w	(sp),d0
	movea.l	#tmstruct,a2
	bclr	#7,d0
	beq.w	.2
	adda.l	#tmsize,a2
.2
	move.l	a2,-(sp)
	jsr	(FormatPlayerNumInitial).l
	jsr	(printz).l
	String	-(TXPRI+TXMAP1),$14,$11,0
	move.w	(a1),d0
	subq.w	#2,d0
	lsr.w	#1,d0
	sub.w	d0,(printx).w
	jsr	(print).l
	movea.l	(sp)+,a2
	move.w	(sp)+,d0
	movem.l	d0-d7/a0-a6,-(sp)
	bclr	#7,d0
	add.w	d0,d0
	lea	$9C(a2),a4
.find
	cmp.b	(a4)+,d0
	beq.w	.found
	tst.b	-1(a4)
	bmi.w	.done
	bra.s	.find
.found
	subq.w	#1,impact(a2)
	bsr.w	ShowPenaltyBoxes
.done
	movem.l	(sp)+,d0-d7/a0-a6
	clr.w	(a0)
	bra.w	.notempty
.skip
	clr.w	(a0)
	bra.w	.next
.empty
	move.w	#1,d1
	bra.w	.exit
.notempty
	move.w	#0,d1
.exit
	movem.l	(sp)+,d0-d6/a0-a3
	rts

SelectInfoTab						;Draw the INFO tab selected (x 1), the others plain
	movem.l	d0-d7/a0-a6,-(sp)
	bsr.w	ClearStatsTab
	bsr.w	ClearPauseTab
	jsr	(printz).l
	String	-(TXPRI+TXMAP2),1,1,0
	move.w	#1,d0
	bsr.w	DrawTabSelected
	movem.l	(sp)+,d0-d7/a0-a6
	rts

ClearInfoTab						;Draw the INFO tab plain
	movem.l	d0-d7/a0-a6,-(sp)
	jsr	(printz).l
	String	-(TXPRI+TXMAP2),1,1,0
	move.w	#1,d0
	bsr.w	DrawTab
	movem.l	(sp)+,d0-d7/a0-a6
	rts

SelectStatsTab						;Draw the STATS tab selected (x $E), the others plain
	movem.l	d0-d7/a0-a6,-(sp)
	bsr.s	ClearInfoTab
	bsr.w	ClearPauseTab
	jsr	(printz).l
	String	-(TXPRI+TXMAP2),$E,1,0
	move.w	#$E,d0
	bsr.w	DrawTabSelected
	movem.l	(sp)+,d0-d7/a0-a6
	rts

ClearStatsTab						;Draw the STATS tab plain
	movem.l	d0-d7/a0-a6,-(sp)
	jsr	(printz).l
	String	-(TXPRI+TXMAP2),$E,1,0
	move.w	#$E,d0
	bsr.w	DrawTab
	movem.l	(sp)+,d0-d7/a0-a6
	rts

SelectPauseTab						;Draw the PAUSE tab selected (x $1B), the others plain
	movem.l	d0-d7/a0-a6,-(sp)
	bsr.s	ClearStatsTab
	bsr.s	ClearInfoTab
	jsr	(printz).l
	String	-(TXPRI+TXMAP2),$1B,1,0
	move.w	#$1B,d0
	bsr.w	DrawTabSelected
	movem.l	(sp)+,d0-d7/a0-a6
	rts

ClearPauseTab						;Draw the PAUSE tab plain
	movem.l	d0-d7/a0-a6,-(sp)
	jsr	(printz).l
	String	-(TXPRI+TXMAP2),$1B,1,0
	move.w	#$1B,d0
	bsr.w	DrawTab
	movem.l	(sp)+,d0-d7/a0-a6
	rts

DrawTabSelected						;The selected tab: $D x 2 of PauseBgBitmap from row 1 at printx / printy
	movea.l	#PauseBgBitmap,a0
	movea.l	a0,a1
	movea.l	a0,a2
	adda.l	(a2)+,a0
	adda.l	(a2)+,a1
	move.w	#1,d1
	move.w	#$D,d2
	move.w	#2,d3
	movea.l	#ZeroLong,a2
	move.w	#1,d4
	moveq	#0,d5
	jmp	(dobitmap).l

DrawTab								;The plain tab: $D x 3 of TabBitmap at printx / printy (chars tabchars)
	movea.l	#TabBitmap,a0
	movea.l	a0,a1
	movea.l	a0,a2
	adda.l	(a2)+,a0
	adda.l	(a2)+,a1
	move.w	#1,d1
	move.w	#$D,d2
	move.w	#3,d3
	movea.l	#ZeroLong,a2
	move.w	(tabchars).w,d4
	moveq	#0,d5
	jmp	(dobitmap).l
	rts								;a second rts, unreferenced

InfoMenus							;The pause INFO tab lists (SetInfoMenuItems: menuitemoffset 0, $7E, $D0):
									;a String header, then items of a
									;String and a routine (y = the play / resume item, x = the manual goalie
									;toggle; PrintMenuItem), ended by a $FF String
	String	$FE,0,$F9,0
	String	$FE,0,$F9,1
	String	'y  PLAY GAME    '
	dc.l	PlayGame
	String	'  TEAM ROSTER   '
	dc.l	TeamRosterScreen
	String	'SCORING SUMMARY '
	dc.l	ScoringSummaryScreen
	String	'PENALTY SUMMARY '
	dc.l	PenaltySummaryScreen
	String	' RECORD HOLDERS '
	dc.l	RecordHoldersScreen
	String	$FF,0
	;InfoMenus+$7E
	String	$FE,0,$F9,0
	String	$FE,0,$F9,1
	String	'y  PLAY GAME    '
	dc.l	PlayGame
	String	'  TEAM ROSTER   '
	dc.l	TeamRosterScreen
	String	' RECORD HOLDERS '
	dc.l	RecordHoldersScreen
	String	$FF,0
	;InfoMenus+$D0
	String	$FE,0,$F9,0
	String	$FE,0,$F9,1
	String	'y  PLAY GAME    '
	dc.l	PlayGame
	String	'  TEAM ROSTER   '
	dc.l	TeamRosterScreen
	String	' RECORD HOLDERS '
	dc.l	RecordHoldersScreen
	String	$FF,0
StatsMenus							;The pause STATS tab lists (SetStatsMenuItems:
									;menuitemoffset 0, $66, $74, $F0)
	String	$FE,0
	String	$FE,0,$F9,1
	String	'y  PLAY GAME    '
	dc.l	PlayGame
	String	'   GAME STATS   '
	dc.l	StatsReport
	String	'  PERIOD STATS  '
	dc.l	PeriodStatsScreen
	String	'  PLAYER STATS  '
	dc.l	PlayerStatsScreen
	String	$FF,0
	;StatsMenus+$66
	String	$FE,0
	String	$FE,0,$F9,1
	String	$FF,0
	;StatsMenus+$74
	String	$FE,0
	String	$FE,0,$F9,1
	String	'y  PLAY GAME    '
	dc.l	PlayGame
	String	'   GAME STATS   '
	dc.l	StatsReport
	String	'  PERIOD STATS  '
	dc.l	PeriodStatsScreen
	String	'  PLAYER STATS  '
	dc.l	PlayerStatsScreen
	String	' PLAYOFF STATS  '
	dc.l	PlayoffStatsScreen
	String	$FF,0
	;StatsMenus+$F0
	String	$FE,0
	String	$FE,0,$F9,1
	String	'y  PLAY GAME    '
	dc.l	PlayGame
	String	'   GAME STATS   '
	dc.l	StatsReport
	String	'  PERIOD STATS  '
	dc.l	PeriodStatsScreen
	String	'  PLAYER STATS  '
	dc.l	PlayerStatsScreen
	String	' SEASON PLAYERS '
	dc.l	SeasonPlayersScreen
	String	'  SEASON TEAMS  '
	dc.l	SeasonTeamsScreen
	String	$FF,0
PauseMenus							;The pause PAUSE tab lists (SetPauseMenuItems: menuitemoffset 0, $AA,
									;$13E, $1D2, $23A, $2CE)
	String	$FE,0
	String	$FE,0,$F9,1
	String	'y   PLAY GAME   '
	dc.l	PlayGame
	String	' INSTANT REPLAY '
	dc.l	ReplayMode
	String	'   EDIT LINES   '
	dc.l	LineEditor
	String	' CHANGE GOALIE  '
	dc.l	Pausemode_go
	String	'x MANUAL GOALIE  '
	dc.l	ManualGoalieMenu
	String	'    TIMEOUT     '
	dc.l	TimeoutMenu
	String	'   ABORT GAME   '
	dc.l	AbortGame
	String	$FF,0
	;PauseMenus+$AA
	String	$FE,0
	String	$FE,0,$F9,1
	String	'y   PLAY GAME   '
	dc.l	PlayGame
	String	' INSTANT REPLAY '
	dc.l	ReplayMode
	String	'   EDIT LINES   '
	dc.l	LineEditor
	String	' CHANGE GOALIE  '
	dc.l	Pausemode_go
	String	'x MANUAL GOALIE  '
	dc.l	ManualGoalieMenu
	String	'    TIMEOUT     '
	dc.l	TimeoutMenu
	String	$FF,0
	;PauseMenus+$13E
	String	$FE,0
	String	$FE,0,$F9,1
	String	'y   PLAY GAME   '
	dc.l	PlayGame
	String	' INSTANT REPLAY '
	dc.l	ReplayMode
	String	'   EDIT LINES   '
	dc.l	LineEditor
	String	' CHANGE GOALIE  '
	dc.l	Pausemode_go
	String	'x MANUAL GOALIE  '
	dc.l	ManualGoalieMenu
	String	'   ABORT GAME   '
	dc.l	AbortGame
	String	$FF,0
	;PauseMenus+$1D2
	String	$FE,0
	String	$FE,0,$F9,1
	String	'y   PLAY GAME   '
	dc.l	PlayGame
	String	' INSTANT REPLAY '
	dc.l	ReplayMode
	String	'x MANUAL GOALIE  '
	dc.l	ManualGoalieMenu
	String	'   ABORT GAME   '
	dc.l	AbortGame
	String	$FF,0
	;PauseMenus+$23A
	String	$FE,0
	String	$FE,0,$F9,1
	String	'y   PLAY GAME   '
	dc.l	PlayGame
	String	' INSTANT REPLAY '
	dc.l	ReplayMode
	String	'   EDIT LINES   '
	dc.l	LineEditor
	String	' CHANGE GOALIE  '
	dc.l	Pausemode_go
	String	'x MANUAL GOALIE  '
	dc.l	ManualGoalieMenu
	String	'   ABORT GAME   '
	dc.l	AbortGame
	String	$FF,0
	;PauseMenus+$2CE
	String	$FE,0
	String	$FE,0,$F9,1
	String	'   PLAY GAME    '
	dc.l	PlayGame
	String	' INSTANT REPLAY '
	dc.l	ReplayMode
	String	'x MANUAL GOALIE  '
	dc.l	ManualGoalieMenu
	String	' SHOOTOUT SETUP '
	dc.l	ShootoutShooters
	String	'   ABORT GAME   '
	dc.l	AbortGame
	String	$FF,0

AbortGame							;Pause menu ABORT GAME: stop the replay (recbpr), demoflag on, back to
									;Opening2
	bclr	#sfwrap,(sflags).w
	move.w	#$FFFF,(lastsfx).w
	move.l	#M68K_RAM,(recbpr).w
	st	(demoflag).w
	jmp	(Opening2).l
PlayGame							;Pause menu PLAY GAME: sflags9 bit 3 ends the pause menu (HandleMenuInput)
	bset	#3,(sflags9).w
	rts

;-------------------------------------------------------------------------------------------------------------
;	Goalie and timeout menu items, the pause screen scores and the pad sides.


ManualGoalieMenu					;Pause menu MANUAL GOALIE / AUTO GOALIE: with OptNOP set, toggle
									;goaliemode2 when the team of the menu pad is above 1 (SetMenuPadSide,
									;sflags bit 1), else goaliemode1, and redraw the items (RedrawMenu; 94
									;matched cont1team / cont2team instead). In a penalty shot or shootout
									;(gmode2 bit 0, BA_PS_flags bit 2) the pad then takes player 0 / 6 or 5 /
									;$B by its mode, when BA_Sktr_SCnum is on its side (setc1player /
									;setc2player)
	movem.l	d0-d7/a0-a6,-(sp)
	tst.w	(OptNOP).w
	beq.w	.chkso
	bsr.w	SetMenuPadSide
	btst	#1,(sflags).w
	beq.w	.g1
	eori.w	#1,(goaliemode2).w
	jsr	(RedrawMenu).l
	bra.w	.chkso
.g1
	eori.w	#1,(goaliemode1).w
	bsr.w	RedrawMenu				;the same call as a bsr
.chkso
	btst	#0,(gmode2).w
	bne.w	.so
	btst	#2,(BA_PS_flags).w
	beq.w	.x
.so
	btst	#1,(sflags).w
	bne.w	.p2
	cmpi.w	#2,(OptNOP).w
	bne.w	.4
	cmpi.w	#5,(BA_Sktr_SCnum).w
	bgt.w	.x
	bra.w	.5
.4
	cmpi.w	#5,(BA_Sktr_SCnum).w
	ble.w	.x
.5
	move.w	#0,d0
	cmpi.w	#2,(OptNOP).w
	bne.w	.6
	move.w	#6,d0
.6
	tst.w	(goaliemode1).w
	bne.w	.set1
	move.w	#5,d0
	cmpi.w	#2,(OptNOP).w
	bne.w	.set1
	move.w	#$B,d0
.set1
	jsr	(setc1player).l
	bra.w	.x
.p2
	cmpi.w	#2,(OptNOP).w
	bne.w	.9
	cmpi.w	#5,(BA_Sktr_SCnum).w
	ble.w	.x
	bra.w	.10
.9
	cmpi.w	#5,(BA_Sktr_SCnum).w
	bgt.w	.x
.10
	move.w	#6,d0
	tst.w	(goaliemode2).w
	bne.w	.set2
	move.w	#$B,d0
.set2
	jsr	(setc2player).l
.x
	movem.l	(sp)+,d0-d7/a0-a6
	rts

Pausemode_go					;Pause menu CHANGE GOALIE: pick team a2's goalie (or no goalie) from a
									;list (Pausemode_gnum) with up / down, C or start; sets tmgoalie and
									;SetPersonel. 95 clears the menu box first (ClearMenuBox) and redraws the
									;menu after (RedrawMenu), where 94 drew a frame
	move.w	(menuitem).w,-(sp)
	move.w	(menuitem+2).w,-(sp)
	bsr.w	ClearMenuBox
	jsr	(GetGoalieCount).l
	move.w	d0,(menuitem+2).w
	add.w	(menuitem+2).w,d1		;the 94 height. Nothing reads it in 95
	move.w	tmgoalie(a2),d0
	bpl.w	.0
	moveq	#-1,d0
.0
	addq.w	#1,d0
	move.w	d0,(menuitem).w
.loop
	bsr.w	Pausemode_gnum
.pad
	bsr.w	Pausemode_rjoy
	btst	#7,d1
	bne.w	.done
	btst	#5,d1
	bne.w	.done
	btst	#1,d1
	beq.w	.up
	move.w	(menuitem).w,d0
	addq.w	#1,d0
	cmp.w	(menuitem+2).w,d0
	bgt.s	.loop
	move.w	d0,(menuitem).w
.up
	btst	#0,d1
	beq.s	.loop
	subq.w	#1,(menuitem).w
	bpl.s	.loop
	clr.w	(menuitem).w
	bra.s	.loop
.done
	move.w	(menuitem).w,d0
	subq.w	#1,d0
	bpl.w	.set
	cmpi.w	#$FFFF,tmgoalie(a2)
	blt.w	.x
.set
	move.w	d0,tmgoalie(a2)
	jsr	(setpersonel).l
.x
	move.w	(sp)+,(menuitem+2).w
	move.w	(sp)+,(menuitem).w
	bsr.w	ClearMenuBox
	jsr	(RedrawMenu).l
	rts

Pausemode_gnum				;Draw the goalie list at row $E, x $C, row menuitem in font set 2: "no
									;goalie", then each goalie by name (GetTempPlayerNameAttrib for
									;TempPlOffset, -1 for the away team; 94 printed the roster name and the
									;two digit number)
	move.w	#$E,(printy).w
	move.w	(menuitem+2).w,d1
	moveq	#0,d0
.row
	move.w	#$C,(printx).w
	move.w	#0,(printfontset).w
	cmp.w	(menuitem).w,d0
	bne.w	.1
	move.w	#2,(printfontset).w
.1
	bsr.w	printsmallz
	String	'                 '		;clear the row
	tst.w	d0
	bne.w	.player
	move.w	#$C,(printx).w
	bsr.w	printsmallz
	String	'no goalie'
	bra.w	.next
.player
	move.w	d0,d2
	subq.w	#1,d2
	move.w	d2,(TempPlOffset).w
	cmpa.l	#tmstruct,a2
	beq.w	.2
	st	(TempPlOffset).w
.2
	jsr	(GetPlayerNumInitial).l
	move.w	#$C,(printx).w
	bsr.w	printsmall
.next
	addq.w	#1,(printy).w
	addq.w	#1,d0
	dbf	d1,.row
	rts

TimeoutMenu							;Pause menu TIMEOUT for team a2: drop the item (menuitemoffset $23A: the
									;pause list without TIMEOUT; 94 set menulist to PauseText2), set tmflags
									;bit 2 (timeout used), print TIMEOUT and the team name centred at y $14 in
									;the cleared menu box, rest both teams (RestoreTeamEnergy), wait $78
									;frames (waitx), redraw the menu
	subq.w	#1,(menuitem).w
	subq.w	#1,(menuitem+2).w
	bsr.w	ClearMenuBox
	move.l	#$23A,(menuitemoffset).w
	bset	#tmftimeout,tmflags(a2)
	move.w	#0,(printfontset).w
	bsr.w	printsmallz
	String	CC_SetX,$10,CC_SetY,$E,'Timeout',CC_SetX,$14,CC_SetY,$10	;$FD x, $FC y
	movea.l	tmdata(a2),a1
	adda.w	4(a1),a1				;team name String
	move.w	(a1),d0
	lsr.w	#1,d0
	sub.w	d0,(printx).w
	bsr.w	printsmall
	movea.w	#(tmstruct-M68K_RAM),a2
	jsr	(RestoreTeamEnergy).l
	adda.w	#tmsize,a2
	jsr	(RestoreTeamEnergy).l
	moveq	#$78,d0
	jsr	(waitx).l
	bsr.w	ClearMenuBox
	jmp	(RedrawMenu).l

PauseScores							;The two scores in big digits on the pause screen (PutScoreDigit): home at
									;printz position $1E, 6, away at 6, 6; no tens digit under 10. Called from
									;PauseScreenDraw
	movem.l	d0-d7/a0-a6,-(sp)
	jsr	(printz).l
	String	-(TXPRI+TXMAP2),$1E,6,0
	movea.l	#tmstruct,a2
	move.w	tmscore(a2),d0
	ext.l	d0
	divu.w	#$A,d0
	move.l	d0,-(sp)
	tst.w	d0
	bne.w	.tens
	addq.w	#2,(printx).w
	bra.w	.ones
.tens
	bsr.w	PutScoreDigit
.ones
	move.l	(sp)+,d0
	swap	d0
	bsr.w	PutScoreDigit
	jsr	(printz).l
	String	-(TXPRI+TXMAP2),6,6,0
	movea.l	#AwShots,a2
	move.w	tmscore(a2),d0
	ext.l	d0
	divu.w	#$A,d0
	move.l	d0,-(sp)
	tst.w	d0
	bne.w	.tens2
	addq.w	#2,(printx).w
	bra.w	.ones2
.tens2
	bsr.w	PutScoreDigit
.ones2
	move.l	(sp)+,d0
	swap	d0
	bsr.w	PutScoreDigit
	movem.l	(sp)+,d0-d7/a0-a6
	rts

PutScoreDigit						;The same code as PutClockDigit: big digit d0 at printx / printy from
									;ClockDigitsBitmap (dobitmap, chars clockdigitchars), then printx + 2
	movem.w	d0-d7,-(sp)
	movea.l	#ClockDigitsBitmap,a0
	movea.l	a0,a1
	movea.l	a0,a2
	adda.l	(a2)+,a0
	adda.l	(a2)+,a1
	asl.w	#1,d0
	move.w	#0,d1
	move.w	#2,d2
	move.w	#3,d3
	movea.l	#ZeroLong,a2
	move.w	(clockdigitchars).w,d4
	moveq	#0,d5
	jsr	(dobitmap).l
	addq.w	#2,(printx).w
	movem.w	(sp)+,d0-d7
	rts

SetMenuPadSide						;sflags bit 1 set when the team of pad menupadnum is above 1, else
									;cleared. Called from
									;ManualGoalieMenu and PrintMenuItem
	movem.l	d0/a0-a1,-(sp)
	movea.l	#padteams,a0
	move.w	(menupadnum).w,d0
	asl.w	#2,d0
	movea.l	(a0,d0.w),a0
	cmpi.w	#1,(a0)
	movem.l	(sp)+,d0/a0-a1
	ble.w	.0
	bset	#1,(sflags).w
	bra.w	.exit
.0
	bclr	#1,(sflags).w
.exit
	rts

padteams							;The team word of each pad (SetMenuPadSide)
	dc.l	cont1team,cont2team,cont3team,cont4team
