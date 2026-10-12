;	2 parts in ROM order, each under its banner below.
;	EA's compiler emits cmp #imm,Dn as CMP (Bxxx), SNASM emits CMPI (0Cxx). The source has the real cmp / cmpi; fixopcodes.js patches the
;	cmp encoding after assembly.

;------------------------------------------------------------------------------------------------------------------------
;	HandlePlayoffInput, UpdatePlayoffScroll, PlayoffScreenExit, PlayoffScreen_waitvsync, PrintSeriesScore, DrawTreeArrow,
;	DrawTeamBlocks, VBlank_Playoff and PlayoffScreenText.
;	95 changes: PlayoffScreen returns at once in Shootout (gmode2 bit 0) and also runs for sflags11 bit 2; AddTeamBlock and
;	AddSmallFont are inline, the title uses printbig with the BigFontMap2 tiles, HandlePlayoffInput reads all four pads, the
;	song is 3 (94 $79), the map chars start at $69A (94 $30A).



PlayoffScreen	;Bring up the playoff screen if in playoff mode (not Shootout; OptPlayMode nonzero or sflags11 bit 2).
	;Called from Opening2 and PlayoffTreeScreen. Runs its own vblank and scrolls the tree a page ($70
	;pixels) at a time. Returns when start is pressed (PlayoffScreenExit)
	btst	#0,(gmode2).w
	bne.s	rtsLineData
	btst	#2,(sflags11).w
	bne.w	.0
	tst.w	(OptPlayMode).w
	beq.s	rtsLineData
.0
	move.l	#VBlank_Playoff,(vbint).l
	bclr	#1,(disflags).w
	move.w	#0,(VSCRLPM).w
	move.w	#$BC00,(VSPRITES).w
	move.w	#$B000,(VmMap3).w
	move.w	#6,(Map3col1).w
	move.w	#$C000,(VmMap2).w
	move.w	#7,(Map2col1).w
	move.w	#$E000,(VmMap1).w
	move.w	#7,(Map1col1).w
	move.w	#0,d0
	jsr	(setVram).l
	jsr	(printz).l
	String	-TXMAP1,0,0,0
	move.l	#$80,d0
	moveq	#$1C,d1
	move.w	#$7FF,d2
	jsr	(eraser).l
	jsr	(printz).l
	String	-TXMAP3,0,0,0
	moveq	#$28,d0
	moveq	#2,d1
	move.w	#$7FF,d2
	jsr	(eraser).l
	move.w	#1,d4	;the team block tiles from char 1
	move.w	d4,(teamblocksmapptr).w
	movea.l	#Teamblocksmap+8,a2
	jsr	(DecompressGraphicsPlain).l
	move.l	#SmallFontMap,(smallfontptr).l
	move.w	d4,(smallfontchars).w
	movea.l	(smallfontptr).w,a2
	addq.w	#8,a2
	jsr	(DecompressGraphicsWithCallback).l
	dc.b	$01,$23,$45,$67,$89,$AB,$CD,$EF	;remap table
	move.w	d4,(BigFontChars).w
	movea.l	#BigFontMap2+8,a2
	jsr	(DecompressGraphicsPlain).l
	movea.l	#Arrowsmap+8,a2
	move.w	d4,(ExtraChars).w
	jsr	(DecompressGraphicsPlain).l
	jsr	(printz).l
	String	-(TXPAL3+TXMAP2),0,0,0
	movea.l	#ScoutMap,a0
	movea.l	a0,a1
	movea.l	a0,a2
	adda.l	(a2)+,a0
	adda.l	(a2)+,a1
	clr.w	d0
	clr.w	d1
	move.w	(a1),d2
	move.w	2(a1),d3
	moveq	#3,d5
	jsr	(dobitmap).l
	movea.l	#PlayoffSprite,a1
	lea	8(a1),a2
	adda.l	(a1),a1
	moveq	#7,d0
	movea.w	#(palfadenew+$40-M68K_RAM),a0
.pal
	move.l	-$40(a0),$20(a0)
	move.l	(a1)+,-$40(a0)
	move.l	-$20(a0),(a0)+
	dbf	d0,.pal
	move.w	d4,(energybarchars).w
	jsr	(DecompressGraphicsPlain).l
	clr.w	(pausetimeout).w
	clr.w	(picturebits).w
	move.w	#$104,(clampcounter).w
	move.w	#$A0,(playoffspritey).w
	movea.l	#VDP_CTRL,a0
	move.w	#VDPR_WINY+$02,(a0)
	movea.w	#(potree-M68K_RAM),a1
	movea.l	#PlayoffTreeSetup,a0	;playoff tree layout by gamelevel
	move.w	(gamelevel).w,d0
	asl.w	#1,d0
	adda.w	(a0,d0.w),a0
	clr.w	d4
	move.b	(a0)+,d4
.2
	jsr	(printz).l
	String	-TXMAP1,0,0,0
	move.b	(a0)+,(printx+1).w
	move.b	(a0)+,(printy+1).w
	clr.w	d1
	move.b	(a1)+,d1
	add.w	d1,d1
	jsr	(DrawTeamBlocks).l
	dbf	d4,.2
	clr.w	d4
	move.b	(a0)+,d4
.3
	jsr	(printz).l
	String	-TXMAP1,0,2,0
	move.b	(a0)+,(printx+1).w
	clr.w	d0
	move.b	(a0)+,d0
	jsr	(DrawTreeArrow).l
	dbf	d4,.3
	jsr	(printz).l
	String	-(TXPAL1+TXMAP1),0,0,0
	cmpi.w	#7,(bosgames).w	;best of 7
	beq.w	.5
	clr.w	d4
	move.b	(a0)+,d4
	bmi.w	.5
	movea.w	#(gsstruct-M68K_RAM),a2
.top3
	move.b	(a0)+,(printx+1).w
	move.b	(a0)+,(printy+1).w
	jsr	(printsmallz).l
	String	CC_SetAttribute,3
	jsr	(PrintSeriesScore).l
	adda.w	#$10,a2
	dbf	d4,.top3
.5
	jsr	(printsmallz).l
	String	CC_SetMapAndPosition,0,1,$41,1,0
	lea	PlayoffScreenText(pc),a1
	move.w	(gamelevel).w,d0
	jsr	(AdvanceStringPtr).l
	jsr	(printbig).l
	tst.w	(gamelevel).w
	beq.w	.6
	jsr	(printz).l
	String	-(TXPAL3+TXMAP3),$A,1,'Press [ or ] to page'
.6
	move.w	#$18,(palcount).w
	move.w	#3,-(sp)
	jsr	(song).l
	clr.w	d0
	clr.w	d4
	move.w	#$FFFF,(PlayerScrollCtr).w
	move.w	#1,(DispAttribCtr).w
	jsr	(UpdatePlayoffScroll).l
.wait
	jsr	(PlayoffScreen_waitvsync).l
	movea.l	#rtss2,a0
	jsr	(DrawPlayoffSprite).l
	jsr	(HandlePlayoffInput).l
	bra.s	.wait

HandlePlayoffInput	;Read the four pads: start leaves PlayoffScreen, right / left set the
	;scroll step, then falls into UpdatePlayoffScroll
	jsr	(ReadJoy1).l
	move.w	d3,-(sp)
	jsr	(ReadJoy2).l
	or.w	d3,(sp)
	jsr	(ReadJoy3).l
	or.w	d3,(sp)
	jsr	(ReadJoy4).l
	or.w	(sp)+,d3
	btst	#7,d3
	bne.w	PlayoffScreenExit
	btst	#3,d3
	beq.w	.nr
	move.w	#$FFFE,(PlayerScrollCtr).w
.nr
	btst	#2,d3
	beq.w	UpdatePlayoffScroll
	move.w	#2,(PlayerScrollCtr).w

UpdatePlayoffScroll	;Move the tree one step (PlayerScrollCtr) and stop on a page boundary ($70). The
	;position is DispAttribCtr; playoffspritex is the sprite x offset while it is on screen
	move.w	(PlayerScrollCtr).w,d0
	beq.w	rtsLineData
	add.w	(DispAttribCtr).w,d0
	move.w	(gamelevel).w,d1
	cmp.w	#3,d1
	bls.w	.lim
	moveq	#3,d1
.lim
	mulu.w	#$70,d1
	cmp.w	d1,d0
	bgt.w	rtsLineData
	neg.w	d1
	cmp.w	d1,d0
	blt.w	rtsLineData
	move.w	d0,(DispAttribCtr).w
	clr.w	(playoffspritex).w
	move.w	d0,d1
	addi.w	#$100,d1
	cmp.w	#$40,d1
	blt.w	.nox
	cmp.w	#$200,d1
	bgt.w	.nox
	move.w	d1,(playoffspritex).w
.nox
	ext.l	d0
	divs.w	#$70,d0
	swap	d0
	tst.w	d0
	bne.w	rtsLineData
	clr.w	(PlayerScrollCtr).w
	rts

PlayoffScreenExit	;Drop HandlePlayoffInput's return address and return from PlayoffScreen
	addq.w	#4,sp
	rts

PlayoffScreen_waitvsync	;Each time palcount runs out, eor the color word at palfadenew+$42 with $EE and
	;restart palcount at $18; then wait for the next vblank
	tst.w	(palcount).w
	bpl.w	.wait
	eori.w	#$EE,(palfadenew+$42).w
	move.w	#$18,(palcount).w
.wait
	move.w	(vcount).w,d0
	cmp.w	(oldvcount).w,d0
	beq.s	.wait
	move.w	d0,(oldvcount).w
	rts

PrintSeriesScore	;Print best of 7 wins "t-b" for game struct a2 at printx / printy
	movea.w	#(mesarea-M68K_RAM),a1
	move.w	#6,(a1)+
	move.w	4(a2),d0
	addi.w	#$30,d0
	move.b	d0,(a1)+
	move.b	#$2D,(a1)+
	move.w	6(a2),d0
	addi.w	#$30,d0
	move.b	d0,(a1)+
	clr.b	(a1)+
	movea.w	#(mesarea-M68K_RAM),a1
	jmp	print

DrawTreeArrow	;Draw tree arrow d0 from the arrows map (Arrowsmap) at printx / printy
	movem.l	d0-d7/a0-a3,-(sp)
	movea.l	#Arrowsmap,a0
	movea.l	a0,a1
	adda.l	(a0),a0
	adda.l	4(a1),a1
	movea.w	#ZeroLong,a2	;a zero long: no palettes
	clr.w	d1
	moveq	#2,d2
	moveq	#$17,d3
	move.w	(ExtraChars).w,d4
	moveq	#0,d5
	jsr	(dobitmap).l
	movem.l	(sp)+,d0-d7/a0-a3
	rts

DrawTeamBlocks	;Draw team block d1 (team * 2) from Teamblocksmap at printx / printy; the user's team
	;(potreeteam entry of potree) is highlighted (printa $6000) unless sflags11 bit 2 is set
	movem.l	d0-d7/a0-a3,-(sp)
	movea.w	#(potree-M68K_RAM),a0
	move.w	(potreeteam).w,d0
	move.b	(a0,d0.w),d0
	add.b	d0,d0
	cmp.b	d0,d1
	bne.w	.nohi
	btst	#2,(sflags11).w
	bne.w	.nohi
	move.w	#$6000,(printa).w
.nohi
	movea.l	#Teamblocksmap,a1
	adda.l	4(a1),a1
	movea.w	#ZeroLong,a2	;a zero long: no palettes
	clr.w	d0
	move.w	(a1),d2
	moveq	#2,d3
	move.w	(teamblocksmapptr).w,d4	;the team block chars (set by PlayoffScreen)
	moveq	#0,d5
	jsr	(dobitmap).l
	movem.l	(sp)+,d0-d7/a0-a3
	rts

VBlank_Playoff	;The PlayoffScreen vblank handler (vbint): dma the sprite table, write
	;$FEA0+DispAttribCtr to the hscroll, cramfade. Always vcount+1, p_music_vblank, rte
	movem.l	d0-d7/a0-a6,-(sp)
	btst	#2,(disflags).w
	bne.w	.nograph
	movea.w	#(Satt-M68K_RAM),a0
	move.w	(Sattsize).w,d0
	beq.w	.0
	clr.w	(Sattsize).w
	move.w	(VSPRITES).w,d1
	jsr	(DoDMA).l
	move.w	(VSCRLPM).w,d0
	jsr	(Vmaddr).l
	move.w	#$FEA0,d0
	add.w	(DispAttribCtr).w,d0
	move.w	d0,(a0)
.0
	jsr	(cramfade).l
.nograph
	addq.w	#1,(vcount).w
	jsr	(p_music_vblank).l
	movem.l	(sp)+,d0-d7/a0-a6
	rte

PlayoffScreenText	;Round titles by gamelevel, printbig Strings with their position
	String	$CF,$39,$19,'Playoffs'
	String	$CF,$33,$19,'Quarterfinals'
	String	$CF,$37,$19,'Semifinals'
	String	$CF,$3B,$19,'Finals'
	String	$CF,$37,$19,'Champions'

;------------------------------------------------------------------------------------------------------------------------
;	PlayoffTreeSetup, DrawPlayoffSprite and SetSframe (its only caller is DrawPlayoffSprite).



PlayoffTreeSetup	;Playoff tree layout by gamelevel, the same bytes as 94. Used by PlayoffScreen
	;Per level: teams-1 then x,y per team (DrawTeamBlocks), arrows-1 then x,d0 per arrow (DrawTreeArrow), scores-1
	;then x,y per score (PrintSeriesScore, negative: none)
	dc.w	.l0-PlayoffTreeSetup
	dc.w	.l1-PlayoffTreeSetup
	dc.w	.l2-PlayoffTreeSetup
	dc.w	.l3-PlayoffTreeSetup
	dc.w	.l4-PlayoffTreeSetup
;tree graphics for level 0: teams-1 then x,y per team (DrawTeamBlocks), arrows-1 then x,d0 per arrow
;(DrawTreeArrow), scores-1 then x,y per score (PrintSeriesScore, negative: none)
.l0	dc.b	16-1
	dc.b	46,2,46,5,46,8,46,11,46,14,46,17,46,20,46,23
	dc.b	71,2,71,5,71,8,71,11,71,14,71,17,71,20,71,23
	dc.b	1,57,0,69,10
	dc.b	7,50,4,50,10,50,16,50,22,75,4,75,10,75,16,75,22
;tree graphics for level 1
.l1	dc.b	16+8-1
	dc.b	32,2,32,5,32,8,32,11,32,14,32,17,32,20,32,23
	dc.b	85,2,85,5,85,8,85,11,85,14,85,17,85,20,85,23
	dc.b	46,4,46,10,46,15,46,21
	dc.b	71,4,71,10,71,15,71,21
	dc.b	3,43,0,57,2,69,8,83,10
	dc.b	3,50,8,50,18,75,8,75,18
;tree graphics for level 2
.l2	dc.b	16+8+4-1
	dc.b	18,2,18,5,18,8,18,11,18,14,18,17,18,20,18,23
	dc.b	99,2,99,5,99,8,99,11,99,14,99,17,99,20,99,23
	dc.b	32,4,32,10,32,15,32,21
	dc.b	85,4,85,10,85,15,85,21
	dc.b	46,7,46,18
	dc.b	71,7,71,18
	dc.b	5,29,0,43,2,57,4,69,6,83,8,97,10
	dc.b	1,50,13,75,13
;tree graphics for level 3
.l3	dc.b	16+8+4+2-1
	dc.b	4,2,4,5,4,8,4,11,4,14,4,17,4,20,4,23
	dc.b	113,2,113,5,113,8,113,11,113,14,113,17,113,20,113,23
	dc.b	18,4,18,10,18,15,18,21
	dc.b	99,4,99,10,99,15,99,21
	dc.b	32,7,32,18
	dc.b	85,7,85,18
	dc.b	46,12
	dc.b	71,12
	dc.b	5,15,0,29,2,43,4,83,6,97,8,111,10
	dc.b	0,63,23
;tree graphics for level 4
.l4	dc.b	16+8+4+2+1-1
	dc.b	4,2,4,5,4,8,4,11,4,14,4,17,4,20,4,23
	dc.b	113,2,113,5,113,8,113,11,113,14,113,17,113,20,113,23
	dc.b	18,4,18,10,18,15,18,21
	dc.b	99,4,99,10,99,15,99,21
	dc.b	32,7,32,18
	dc.b	85,7,85,18
	dc.b	46,12
	dc.b	71,12
	dc.b	58,23
	dc.b	5,15,0,29,2,43,4,83,6,97,8,111,10
	dc.b	-1	;no scores
	dc.b	$FF	;pad (93 $47)

DrawPlayoffSprite	;The PlayoffSprite sprite at playoffspritex / playoffspritey in Satt, then end the
	;list and set Sattsize. 95 animates it: frame picturebits 0-4, the next one every $A calls (pausetimeout). Called from PlayoffScreen
	movea.w	#(Satt-M68K_RAM),a6
	moveq	#1,d6
	movea.l	#PlayoffSprite,a0
	move.w	(energybarchars).w,d3
	ori.w	#$8000,d3
	move.w	(playoffspritex).w,d0
	move.w	(playoffspritey).w,d1
	move.w	(picturebits).w,d2
	addq.w	#1,(pausetimeout).w
	cmpi.w	#$A,(pausetimeout).w
	blt.w	.0
	clr.w	(pausetimeout).w
	addq.w	#1,(picturebits).w
	cmpi.w	#5,(picturebits).w
	blt.w	.0
	clr.w	(picturebits).w
.0
	jsr	(SetSframe).l
	cmpa.w	#(Satt-M68K_RAM),a6
	bne.w	.1
	clr.l	(a6)+
	clr.l	(a6)+
.1
	clr.b	-5(a6)
	move.l	a6,d0
	subi.l	#Satt,d0
	lsr.w	#1,d0
	move.w	d0,(Sattsize).w
	rts

SetSframe	;Draw one sprite frame. a0 = framelist, d0/d1 = x/y cords, d2 = frame, d3 = start char
	;a6 = Satt pointer, d6 = link counter. 95 builds the attribute word from the frame entry's flags and char
	cmp.w	#$40,d6	;MaxSprites
	bge.w	.2
	movem.l	d0-d5/a0,-(sp)
	adda.l	4(a0),a0
	add.w	d2,d2
	move.w	2(a0,d2.w),d4
	sub.w	(a0,d2.w),d4
	lsr.w	#3,d4
	subq.w	#1,d4	;number of sprites in frame
	adda.w	(a0,d2.w),a0
.0
	move.w	2(a0),d2
	andi.w	#$F000,d2
	lsr.w	#1,d2
	move.w	d2,-(sp)
	move.w	4(a0),d2
	andi.w	#$7FF,d2
	or.w	(sp)+,d2
	add.w	d3,d2
	move.w	(a0),(a6)
	add.w	d1,(a6)+
	move.b	2(a0),(a6)+
	move.b	d6,(a6)+
	move.w	d2,(a6)+
	move.w	6(a0),(a6)
	add.w	d0,(a6)+
	addq.w	#1,d6
	cmp.w	#$40,d6	;MaxSprites
	beq.w	.ex
	addq.w	#8,a0
	dbf	d4,.0
.ex
	movem.l	(sp)+,d0-d5/a0
.2
	rts
