;	2 parts in ROM order, each under its banner below.
;	EA's compiler emits cmp #imm,Dn as CMP (Bxxx), SNASM emits CMPI (0Cxx). The source has the real cmp / cmpi; fixopcodes.js patches the
;	cmp encoding after assembly.

;------------------------------------------------------------------------------------------------------------------------
;	ScoutingReport, PageMatchup ... MatchupLineSlots, BuildHotColdLists and SortHotColdStarters.
;	$20xxxx addresses are save RAM (odd bytes).



	include	macros\genesis.mac	;String

ScoutingReport	;Pregame scouting report: the Ron Barr picture, the text box and the matchups (0 the
	;teams, 1-6 the players by position) with their ratings and the advantage marks; the text player (ScoutTextPlayer) types
	;the paragraph list, with the user names of each team (GetHomeUsers / GetAwayUsers). A / C page the matchups, down types fast, start leaves
	jsr	(ReadNameLog).l
	jsr	(BuildHotColdLists).l	;hot / cold players for the text (not matched yet)
	clr.w	(advframe).w	;advantage mark frame
	jsr	(play_new_song).l
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
	move.w	#3,-(sp)
	jsr	(song).l
	move.l	#vb2,(vbint).w
	jsr	(clearTeamStats).l
	move.l	a0,-(sp)
	movea.l	#tmstruct,a0
	jsr	(Create_HotCold_Table).l	;new random hot / cold tables ($1A2(a0))
	movea.l	#AwShots,a0
	jsr	(Create_HotCold_Table).l
	movea.l	(sp)+,a0
	jsr	(BuildHotColdLists).l	;again with the new tables
	bclr	#1,(disflags).w
	move.w	#6,(Map1col1).w
	move.w	#6,(Map2col1).w
	move.w	#0,d0	;fade to color
	jsr	(setVram).l
	move.w	#2,d4	;vram chars from 2
	move.w	d4,(homepicchars).w	;home picture chars (6 x 6)
	addi.w	#$24,d4
	move.w	d4,(vispicchars).w	;visitors picture chars
	addi.w	#$24,d4
	move.w	d4,(BigFontChars).w
	movea.l	#BigFontMap2+8,a2
	jsr	(DecompressGraphicsWithCallback).l
	dc.b	$01,$23,$45,$67,$89,$AB,$CD,$EF
	move.l	#SmallFontMap,(smallfontptr).l
	move.w	d4,(smallfontchars).w
	movea.l	(smallfontptr).w,a2
	addq.w	#8,a2
	jsr	(DecompressGraphicsWithCallback).l
	dc.b	$0B,$83,$44,$67,$89,$AB,$CD,$EF
	move.w	d4,(smallfont2chars).w
	movea.l	#SmallFontMap+8,a2	;small font tiles (as AddSmallFont), remapped
	jsr	(DecompressGraphicsWithCallback).l
	dc.b	$0B,$83,$4C,$67,$89,$AB,$CD,$EF
	jsr	(printz).l
	String	-TXMAP2,0,0,0
	movea.l	#ScoutReportMap,a0
	movea.l	a0,a1
	movea.l	a0,a2
	adda.l	(a2)+,a0
	adda.l	(a2)+,a1
	clr.w	d0
	clr.w	d1
	moveq	#$28,d2
	moveq	#$1C,d3
	moveq	#1,d5
	jsr	(dobitmap).l
	move.w	#0,(printfontset).w	;char set 0
	jsr	(printz).l
	String	-TXMAP1,$10,$11,'ADVANTAGE:',0
	jsr	(printz).l
	String	-(TXPAL2+TXMAP2),6,3,0
	moveq	#$21,d0	;33 x 9 text box frame
	moveq	#9,d1
	jsr	(printz).l
	String	-(TXPAL2+TXMAP2),3,$10,0
	move.w	#8,d0	;8 x 8 frame: visitors picture
	move.w	#8,d1
	jsr	(printz).l
	String	-(TXPAL2+TXMAP2),$1E,$10,0
	move.w	#8,d0	;8 x 8 frame: home picture
	move.w	#8,d1
	jsr	(printz).l
	String	-TXMAP1,0,0,0
	movea.l	#RonBarrMap,a0
	movea.l	a0,a1
	movea.l	a0,a2
	adda.l	(a2)+,a0
	adda.l	(a2)+,a1
	clr.w	d0
	clr.w	d1
	move.w	(a1),d2
	move.w	2(a1),d3
	moveq	#8,d5
	jsr	(dobitmap).l
	movea.l	#HotIconMap+8,a2
	move.w	d4,(hoticonchars).w	;tiles: 1st vram char
	jsr	(DoDMA_clearCallbackPointer).l
	movea.l	#ColdIconMap+8,a2
	move.w	d4,(coldiconchars).w	;tiles: 1st vram char
	jsr	(DoDMA_clearCallbackPointer).l
	jsr	(printbigz).l
	String	-(TXPRI+TXMAP1),9,2,'Scouting Report'
	clr.w	(matchup).w	;matchup 0: the teams
	clr.w	(scoutunused).w
	move.w	#$10D,(matchuptimer).l	;frames to the next matchup
	bsr.w	GetMatchupPlayers	;the matchup players
	bsr.w	DrawMatchupPictures
.0
	bsr.w	PrintMatchupRatings
	move.w	#$18,(palcount).w	;24
	move.l	#vb2,(vbint).w
	move	#$2500,sr
	jsr	(InitScoutingDisplay).l
	cmpi.w	#$1A,(HomeTeam).w
	beq.w	.1	;same team: one hot / cold paragraph
	cmpi.w	#$1B,(HomeTeam).w
	bne.w	.2
.1
	move.w	#$A,(a0)+
	bra.w	.3
.2
	move.w	#1,(a0)+
.3
	move.w	#2,(a0)+
	bsr.w	GetHomeUsers
	tst.b	(homeusers).w
	beq.w	.5
.4
	move.w	#6,(a0)+
	move.w	#7,(a0)+
	cmpi.b	#2,(homeusers).w
	blt.w	.5
	move.w	#7,(a0)+
	cmpi.b	#3,(homeusers).w
	blt.w	.5
	move.w	#7,(a0)+
	cmpi.b	#4,(homeusers).w
	blt.w	.5
	move.w	#7,(a0)+
.5
	bsr.w	GetAwayUsers
	tst.b	(awayusers).w
	beq.w	.6
	move.w	#8,(a0)+
	move.w	#9,(a0)+
	cmpi.b	#2,(awayusers).w
	blt.w	.6
	move.w	#9,(a0)+
	cmpi.b	#3,(awayusers).w
	blt.w	.6
	move.w	#9,(a0)+
	cmpi.b	#4,(awayusers).w
	blt.w	.6
	move.w	#9,(a0)+
.6
	move.w	#3,(a0)+
	move.w	#2,(a0)+
	move.w	#4,(a0)+
	move.w	#2,(a0)+
	move.w	#5,(a0)+
	move.w	#$FFFF,(a0)	;end of list
	clr.w	(asv).w	;fast text flag
	move.w	#$7F00,(screentimer).w
	move.l	#$E10,(scoutwait).w
.7
	moveq	#0,d0
	jsr	(waitx).l	;d1 = new presses
	subq.w	#1,(matchuptimer).w
	bpl.w	.8
	move.w	#$10E,(matchuptimer).l
.8
	bsr.w	PrintAdvantageMarks	;advantage marks
	btst	#7,d1	;sbut
	bne.w	.14
	cmpi.w	#$10E,(matchuptimer).w
	beq.w	.9
	btst	#5,d1	;cbut
	beq.w	.10
	move.w	#$7F00,(screentimer).w
	move.l	#$E10,(scoutwait).w
.9
	bsr.w	RestartAdvantageMarks
	move.w	#1,d0	;next matchup
	bsr.w	PageMatchup
	bra.w	.12
.10
	btst	#6,d1	;abut
	beq.w	.11
	move.w	#$7F00,(screentimer).w
	move.l	#$E10,(scoutwait).w
	bsr.w	RestartAdvantageMarks
	move.w	#$FFFF,d0	;previous matchup
	bsr.w	PageMatchup
	bra.w	.12
.11
	clr.w	(asv).w
	btst	#1,d1	;dbut
	beq.w	.12
	st	(asv).w	;down: type the rest without delays
.12
	btst	#1,(waitxpad+1).w	;down held (waitx pad bits)
	beq.w	.13
	st	(asv).w
.13
	jsr	(UpdateScoutingDisplay).l
	subq.w	#1,(screentimer).w
	bpl.w	.7
	tst.w	(OptNOP).w
	beq.w	.14
	move.w	#$FFFF,(screentimer).w	;else wait for start, up to scoutwait frames
	jsr	(AnyPadAssigned).l
	bne.w	.7
	subq.l	#1,(scoutwait).w
	bpl.w	.7
.14
	move.w	#0,(printfontset).w	;char set 0
	rts

PageMatchup	;Page the matchup by d0 (+1 / -1, 0-6 wrapping), restart the page timer and redraw
	move.w	#$10E,(matchuptimer).w
	add.w	(matchup).w,d0
	bmi.w	.0
	cmp.w	#7,d0
	blt.w	.1
	clr.w	d0
	bra.w	.1
.0
	move.w	#6,d0
.1
	move.w	d0,(matchup).w
	bsr.w	GetMatchupPlayers
	bsr.w	DrawMatchupPictures
	bsr.w	PrintMatchupRatings
	rts

PrintMatchupRating	;Print the team rating of team a0 (GetTeamRating) as 2 digits; d0 = the rating
	bsr.w	PrintTwoSpaces	;clear the old number
	move.l	a2,-(sp)
	movea.l	a0,a2
	bsr.w	GetTeamRating
	movea.l	(sp)+,a2
	move.l	d0,-(sp)
	move.w	#2,d1	;2 digits
	jsr	(PushNumberWidth).l
	jsr	(printsmall).l
	move.l	(sp)+,d0
	rts

PrintTwoSpaces	;Print 2 spaces at printx / printy and keep printx
	move.l	a1,-(sp)
	move.w	(printx).w,-(sp)
	movea.l	#TwoSpacesTxt,a1
	jsr	(printsmall).l
	move.w	(sp)+,(printx).w
	movea.l	(sp)+,a1
	rts

TwoSpacesTxt	;A two space String
	String	'  '

StatsText	;The rating names; -1 ends the list (PrintMatchupRatings)
	String	'Shooting'
	String	'Skating',0
	String	'Passing',0
	String	'Defense',0
	String	'Checking'
	String	'Fighting'
	String	'Goalkeeping',0
	String	'Power Play Adv.',0
	String	'-    Home Team Adv.    ',0
	String	'    Overall     '
	dc.w	-1

DrawMatchupPictures	;The matchup 6 x 6 pictures, visitors left, home right: matchup 0 the team logos, 1-6 the two players (MatchupLineSlots slot)
	movem.l	d0-d7/a0-a6,-(sp)
	tst.w	(matchup).w
	bne.w	.0
	move.w	(VisTeam).w,d3
	bsr.w	GetMatchupLogo
	move.w	#4,(printx).w
	move.w	#$11,(printy).w
	move.w	(vispicchars).w,d4
	move.w	#4,d5
	move.w	#$6000,(printa).w
	bsr.w	DrawMatchupLogo
	move.w	(HomeTeam).w,d3
	bsr.w	GetMatchupLogo
	move.w	#$1F,(printx).w
	move.w	#$11,(printy).w
	move.w	(homepicchars).w,d4
	move.w	#0,(printa).w
	move.w	#2,d5
	bsr.w	DrawMatchupLogo
	move.w	#$64,(palcount).w	;100
	bra.w	.1
.0
	move.w	(VisTeam).w,d1
	movea.l	#MatchupLineSlots,a0
	move.w	(matchup).w,d0
	move.b	(a0,d0.w),d0
	ext.w	d0
	jsr	(GetPlayerPicture).l
	move.w	#4,(printx).w
	move.w	#$11,(printy).w
	move.w	(vispicchars).w,d4
	move.w	#2,d5
	move.w	#0,(printa).w
	bsr.w	DrawMatchupPicture
	move.w	(HomeTeam).w,d1
	movea.l	#MatchupLineSlots,a0
	move.w	(matchup).w,d0
	move.b	(a0,d0.w),d0
	ext.w	d0
	jsr	(GetPlayerPicture).l
	move.w	#$1F,(printx).w
	move.w	#$11,(printy).w
	move.w	(homepicchars).w,d4
	move.w	#0,d5
	move.w	#0,(printa).w
	bsr.w	DrawMatchupPicture
	move.w	#$64,(palcount).w	;100
.1
	movem.l	(sp)+,d0-d7/a0-a6
	rts

DrawMatchupPicture	;Draw player picture a0 at printx / printy with the PicturePalette palettes; falls into DrawMatchupBitmap
	movea.l	a0,a1
	movea.l	a0,a2
	adda.l	(a2)+,a0
	movea.l	#PicturePalette,a0	;palette from PicturePalette
	adda.l	(a0),a0
	tst.l	(a2)	;no map?
	bne.w	.0
	movea.l	#PicturePalette,a1
	adda.l	4(a1),a1
	tst.l	(a2)+
	bra.w	.1
.0
	adda.l	(a2)+,a1
.1
	jsr	(UnpackPicture).l
	movea.l	#picturebuf,a2	;tiles
	bra.w	DrawMatchupBitmap

DrawMatchupLogo	;Draw team logo a0, palette TeamLogoPalettes + team d3 * 8 - $20 (d5 = 4: - $40); falls into DrawMatchupBitmap
	movea.l	a0,a1
	movea.l	a0,a2
	adda.l	(a2)+,a0
	asl.w	#3,d3
	cmp.w	#4,d5
	beq.w	.0
	subi.w	#$20,d3
	bra.w	.1
.0
	subi.w	#$40,d3
.1
	movea.l	#TeamLogoPalettes,a0
	adda.w	d3,a0
	adda.l	(a2)+,a1

DrawMatchupBitmap	;6 x 6 dobitmap, then erase the name area at y $11 on that side (x 1 or $1C)
	move.w	#6,d3
	move.w	#6,d2
	clr.w	d0
	clr.w	d1
	jsr	(dobitmap).l
	cmpi.w	#$14,(printx).w
	bgt.w	.0
	move.w	#1,(printx).l
	bra.w	.1
.0
	move.w	#$1C,(printx).l
.1
	move.w	#$11,(printy).l
	move.w	#2,d0
	move.w	#6,d1
	move.w	#$7FF,d2	;blank char
	jsr	(eraser).l
	rts

GetMatchupLogo	;a0 = the logo bitmap of team d3 (TeamLogoBitmaps)
	asl.w	#2,d3
	movea.l	#TeamLogoBitmaps,a0
	movea.l	(a0,d3.w),a0
	rts

PrintMatchupRatings	;Matchup 0: the rating names (StatsText) and both team ratings
	;1-6: the position, the two players and their ratings
	tst.w	(matchup).w
	bne.w	.3
	jsr	(printsmallz).l
	String	CC_SetMapAndPosition,$0,$1,$16,$16,CC_SetFont,$1,$0
	lea	StatsText(pc),a1
	move.w	#0,d7
.0
	move.w	(a1),d0
	asr.w	#1,d0
	neg.w	d0
	addi.w	#$16,d0	;center on column 22
	move.w	d0,(printx).w
	cmp.w	#9,d7
	beq.w	.1
	adda.w	(a1),a1
	bra.w	.2
.1
	move.w	#2,(printfontset).w
	move.w	(printy).w,-(sp)
	subq.w	#3,(printy).w	;y $13
	jsr	(printsmall).l
	move.w	(sp)+,(printy).w
.2
	addq.w	#1,d7
	tst.w	(a1)
	bpl.s	.0
	move.w	#2,(printfontset).w
	jsr	(printz).l
	String	-TXMAP1,$0,$19,'                                        ',$0
	jsr	(printz).l
	String	-TXMAP1,'!',$18,$0
	movea.l	#tmstruct,a0
	movea.l	#AwShots,a2
	bsr.w	PrintMatchupRating	;home
	move.w	d0,(homerating).w
	move.w	#2,(printfontset).w
	jsr	(printz).l
	String	-TXMAP1,$6,$18,$0
	exg	a0,a2
	bsr.w	PrintMatchupRating	;visitors
	move.w	d0,(visrating).w
	bra.w	.8
.3
	move.w	(matchup).w,d0
	subq.w	#1,d0
	movea.l	#MatchupPosNames,a1	;position name of matchup - 1
	bra.w	.5
.4
	adda.w	(a1),a1
.5
	dbf	d0,.4
	jsr	(printsmallz).l
	String	CC_SetMapAndPosition,$0,$1,$C,$13,CC_SetFont,$1,$0
	jsr	(printsmall).l
	move.w	#$18,(printy).w
	move.w	#2,(printfontset).w
	movea.l	#tmstruct,a2
	move.l	(PAttribOverallMask).l,d4	;skater rating weights
	tst.w	(matchupslot).w	;line slot 0: goalie
	bne.w	.6
	move.l	(GAttribOverallMask).l,d4	;goalie
.6
	move.w	(matchuphome).w,d0	;home player
	jsr	(printz).l
	String	-TXMAP1,$0,$19,'                                        ',$0
	jsr	(printz).l
	String	-TXMAP1,'"',$19,$0
	bsr.w	PrintPlayerNameRight	;print the name, moved left to fit the line
	jsr	(CalcAttrib).l
	mulu.w	#$64,d0	;* 100
	divu.w	d1,d0
	jsr	(AttribAdjust).l
	move.w	#2,d1
	move.w	d0,(homerating).w
	jsr	(PushNumberWidth).l
	jsr	(printz).l
	String	-TXMAP1,'!',$18,$0
	bsr.w	PrintTwoSpaces
	jsr	(printsmall).l
	movea.l	#AwShots,a2
	move.l	(PAttribOverallMask).l,d4
	tst.w	(matchupslot).w
	bne.w	.7
	move.l	(GAttribOverallMask).l,d4
.7
	move.w	(matchupvis).w,d0	;visitors player
	jsr	(printz).l
	String	-TXMAP1,$2,$19,$0
	bsr.w	PrintPlayerNameRight
	jsr	(CalcAttrib).l
	mulu.w	#$64,d0	;* 100
	divu.w	d1,d0
	jsr	(AttribAdjust).l
	move.w	d0,(visrating).w
	move.w	#2,d1
	jsr	(PushNumberWidth).l
	jsr	(printz).l
	String	-TXMAP1,$6,$18,$0
	bsr.w	PrintTwoSpaces
	jsr	(printsmall).l
.8
	rts

MatchupPosNames	;Position names of matchups 1-6
	String	'     center     '
	String	' left forward   '
	String	' right forward  '
	String	'left defenseman '
	String	'right defenseman'
	String	'     goalie     '

GetMatchupPlayers	;matchuphome / matchupvis = the home / visitors player of the matchup
	movem.l	d0/a0-a1,-(sp)
.0
	movea.l	#tmstruct,a0
	btst	#6,(sflags11).w
	beq.w	.1
	movea.l	tmdata(a0),a0
	adda.w	6(a0),a0
	bra.w	.2
.1
	move.w	$28(a0),d0
	mulu.w	#$82,d0
	movea.l	#SaveRAM+2*SRLines,a0
	adda.l	d0,a0
.2
	bsr.w	GetMatchupPlayer
	move.w	d0,(matchuphome).w
	movea.l	#AwShots,a0
	btst	#6,(sflags11).w
	beq.w	.3
	movea.l	tmdata(a0),a0
	adda.w	6(a0),a0
	bra.w	.4
.3
	move.w	$28(a0),d0
	mulu.w	#$82,d0
	movea.l	#SaveRAM+2*SRLines,a0
	adda.l	d0,a0
.4
	bsr.w	GetMatchupPlayer
	move.w	d0,(matchupvis).w
	movem.l	(sp)+,d0/a0-a1
	rts

GetMatchupPlayer	;d0 = the roster index of the matchup slot (MatchupLineSlots, matchupslot) in the first line set of team a0
	move.w	(matchup).w,d0
	movea.l	#MatchupLineSlots,a1
	move.b	(a1,d0.w),d0
	ext.w	d0
	move.w	d0,(matchupslot).w
	btst	#6,(sflags11).w
	beq.w	.0
	move.b	(a0,d0.w),d0
	ext.w	d0
	bra.w	.1
.0
	add.w	d0,d0
	move.w	(a0,d0.w),d0
	ext.w	d0
.1
	subq.w	#1,d0	;player numbers start at 1
	rts

RestartAdvantageMarks	;Restart the advantage marks (advcount / advframe)
	clr.w	(advcount).w
	clr.w	(advframe).w
	rts

PrintAdvantageMarks	;Every frame: the advantage marks at x $13, y $16 grow toward the better rated side (HomeAdvMarks / VisAdvMarks); even: EvenAdvTxt
	movem.l	d0-d7/a0-a6,-(sp)
	addq.w	#1,(advcount).w
	cmpi.w	#7,(advcount).w
	blt.w	.0
	clr.w	(advcount).w
	addq.w	#1,(advframe).w
	cmpi.w	#6,(advframe).w
	blt.w	.0
	move.w	#5,(advframe).w
.0
	move.w	(advframe).w,d1
	asl.w	#2,d1
	movea.l	#HomeAdvMarks,a1
	move.w	(homerating).w,d0
	cmp.w	(visrating).w,d0	;home - visitors
	bgt.w	.1
	beq.w	.2
	movea.l	#VisAdvMarks,a1
.1
	movea.l	(a1,d1.w),a1
	bra.w	.3
.2
	movea.l	#EvenAdvTxt,a1	;equal
.3
	move.w	#2,(printfontset).w
	jsr	(printz).l
	String	-TXMAP1,$13,$18,$0
	jsr	(printsmall).l
	move.w	#0,(printfontset).w
	movem.l	(sp)+,d0-d7/a0-a6
	rts

HomeAdvMarks	;Home advantage marks by advframe (0-5)
	dc.l	HomeAdv0Txt,HomeAdv1Txt,HomeAdv2Txt,HomeAdv3Txt,HomeAdv3Txt,HomeAdv3Txt

VisAdvMarks	;Visitors advantage marks by advframe
	dc.l	VisAdv0Txt,VisAdv1Txt,VisAdv2Txt,VisAdv3Txt,VisAdv3Txt,VisAdv3Txt

HomeAdv0Txt	;HomeAdv0Txt
	String	'   ',$0

HomeAdv1Txt	;HomeAdv1Txt
	String	']  ',$0

HomeAdv2Txt	;HomeAdv2Txt
	String	']] ',$0

HomeAdv3Txt	;HomeAdv3Txt
	String	']]]',$0

VisAdv0Txt	;VisAdv0Txt
	String	'   ',$0

VisAdv1Txt	;VisAdv1Txt
	String	'  [',$0

VisAdv2Txt	;VisAdv2Txt
	String	' [[',$0

VisAdv3Txt	;VisAdv3Txt
	String	'[[[',$0

EvenAdvTxt	;Even teams
	String	'   ',$0

MatchupLineSlots	;Line slot by matchup 0-6 (0 for the teams, then center, left wing, right wing, left defense, right defense, goalie)
	dc.b	0,4,3,5,1,2,0,$FF

BuildHotColdLists	;The hot / cold player lists of both teams (SortHotColdStarters, CopyHottestPlayer, CopyColdestPlayer)
	clr.w	(awayhotidx).w
	clr.w	(homehotidx).w
	movem.l	d0-d7/a0-a6,-(sp)
	movea.l	#tmstruct,a0
	bsr.w	SortHotColdStarters
	movea.l	#homehotplayer,a0
	bsr.w	CopyHottestPlayer
	movea.l	#homecoldplayer,a0
	bsr.w	CopyColdestPlayer
	movea.l	#AwShots,a0
	bsr.w	SortHotColdStarters
	movea.l	#awayhotplayer,a0
	bsr.w	CopyHottestPlayer
	movea.l	#awaycoldplayer,a0
	bsr.w	CopyColdestPlayer
	movem.l	(sp)+,d0-d7/a0-a6
	rts

SortHotColdStarters	;Sum the hot / cold values of the 6 starters of team a0 (save RAM roster SRLines) into TempBuffer (byte pairs: player, sum), then sort them by sum
	movem.l	d0-d7/a0-a6,-(sp)
	movea.l	a0,a2
	adda.l	#$1A4,a2
	move.w	$28(a0),d0
	mulu.w	#$82,d0
	movea.l	#SaveRAM+2*SRLines,a0
	adda.l	d0,a0
	movea.l	#TempBuffer,a1
	move.w	#5,d0
.0
	move.w	(a0)+,d1
	subq.b	#1,d1
	move.b	d1,(a1)+
	ext.w	d1
	asl.w	#4,d1
	clr.b	(a1)
	addq.w	#3,d1
	move.w	#3,d7
.1
	clr.w	d2
	move.b	(a2,d1.w),d2
	cmp.b	#9,d7
	beq.w	.2
	cmp.b	#$D,d7
	beq.w	.2
	add.b	d2,(a1)
.2
	addq.w	#1,d1
	addq.w	#1,d7
	cmp.b	#$10,d7
	bne.s	.1
	tst.b	(a1)+
	dbf	d0,.0
.3
	movea.l	#TempBuffer,a1
	clr.w	d1
	move.w	#4,d0
.4
	move.b	3(a1),d6
	cmp.b	1(a1),d6
	ble.w	.5
	st	d1
	move.w	2(a1),d2
	move.w	(a1),2(a1)
	move.w	d2,(a1)
.5
	tst.w	(a1)+
	dbf	d0,.4
	tst.w	d1
	bne.s	.3
	movem.l	(sp)+,d0-d7/a0-a6
	rts

;------------------------------------------------------------------------------------------------------------------------
;	StartScoutText, ScoutTextPlayer, ScoutTextNextLine, CompareHotColdTotals, GetHotColdTotal, the hot / cold player
;	lists, PrintPlayerNameRight, GetTeamRating / TeamRatings, HotColdIcon, GetTeamArena / GetTeamNickname,
;	ScoutTextScript, GetPlayerPicture; the users lists of the scouting text (GetHomeUsers ... UserNameString).
;	$20xxxx addresses are save RAM (odd bytes).



InitScoutingDisplay	;Start the text player ScoutTextPlayer: VertLineScrolling = -1, PlayerScrollCtr = -1, clear SelectedPlayerIdx / typedelay; a0 = TestList (the script line list)
	move.w	#$FFFF,(VertLineScrolling).w
	st	(PlayerScrollCtr).w
	clr.w	(SelectedPlayerIdx).w
	clr.w	(typedelay).w
	movea.l	#setupvalues,a0
	rts

UpdateScoutingDisplay	;Text player of ScoutingReport: types the ScoutTextScript lines of TestList word by word with a
	;typing delay (typedelay, longer after , and .); $D ends a line; the special characters insert Strings (team names, arena, hot / cold players,
	;user names); line breaks scroll the text box
	cmpi.w	#$1000,(typedelay).w
	bgt.w	.13
	tst.w	(asv).w
	bmi.w	.0
	subq.w	#1,(typedelay).w
	bpl.w	.13
.0
	movea.l	#ScoutTextScript,a1
	move.w	(PlayerScrollCtr).w,d0
	bpl.w	.4
	clr.w	(DispAttribCtr).w
	move.w	(SelectedPlayerIdx).w,d0
	addq.w	#2,(SelectedPlayerIdx).w
	movea.w	#(setupvalues-M68K_RAM),a0
	move.w	(a0,d0.w),d0
	bpl.w	.1
	move.w	#$7FFF,(typedelay).w
	move.w	#$1E0,(screentimer).w
	rts
.1
	bsr.w	ScrollDisplayUp
	movea.l	a1,a2
	bra.w	.3
.2
	cmpi.b	#$D,(a2)+
	bne.s	.2
.3
	dbf	d0,.2
	suba.l	a1,a2
	move.w	a2,d0
.4
	lea	(a1,d0.w),a2
	move.w	#$A,(typedelay).w
	move.w	(DispAttribCtr).w,d0
	cmpi.b	#$24,(a2)
	beq.w	.24
	cmpi.b	#$7B,(a2)
	beq.w	.34
	cmpi.b	#$7D,(a2)
	beq.w	.33
	cmpi.b	#$5B,(a2)
	beq.w	.27
	cmpi.b	#$5D,(a2)
	beq.w	.26
	cmpi.b	#$3C,(a2)
	beq.w	.20
	cmpi.b	#$3E,(a2)
	beq.w	.21
	cmpi.b	#$7C,(a2)
	beq.w	.22
	cmpi.b	#$5C,(a2)
	beq.w	.23
	cmpi.b	#$23,(a2)
	beq.w	.14
	cmpi.b	#$25,(a2)
	beq.w	.15
	cmpi.b	#$3D,(a2)
	beq.w	.16
	cmpi.b	#$2A,(a2)
	beq.w	.17
	cmpi.b	#$5E,(a2)
	beq.w	.18
	cmpi.b	#$3B,(a2)
	beq.w	.19
	st	(PlayerScrollCtr).w
	movea.w	#(TextBuffer-M68K_RAM),a0
	clr.w	d1
.5
	cmpi.b	#$D,(a2)
	beq.w	.9
	addq.w	#1,d0
.6
	move.b	(a2),(a0)+
	addq.w	#1,d1
	cmpi.b	#$2C,(a2)
	beq.w	.7
	cmpi.b	#$2E,(a2)
	bne.w	.8
.7
	addi.w	#$28,(typedelay).w
.8
	cmpi.b	#$20,(a2)+
	bne.s	.5
	cmpi.b	#$20,(a2)
	beq.s	.6
	subq.w	#1,d0
	suba.w	a1,a2
	move.w	a2,(PlayerScrollCtr).w
.9
	move.w	d1,(mesarea).w
	addq.w	#2,(mesarea).w
	btst	#0,d1
	beq.w	.10
	clr.b	(a0)
	addq.w	#1,(mesarea).w
.10
	movea.w	#(mesarea-M68K_RAM),a1
.11
	cmp.w	#$18,d0
	ble.w	.12
	bsr.w	ScrollDisplayUp
.12
	jsr	(printz).l
	String	-TXMAP1,$B,$6,$0
	move.w	(DispAttribCtr).w,d0
	add.w	d0,(printx).w
	move.w	(VertLineScrolling).w,d0
	add.w	d0,(printy).w
	jsr	(print).l
	add.w	d1,(DispAttribCtr).w
rtsScoutText	equ	*	;Shared rts of ScoutTextPlayer / ScoutTextNextLine
.13
	rts
.14
	bsr.w	NextHomeUser
	bra.w	.36
.15
	bsr.w	NextAwayUser
	bra.w	.36
.16
	move.l	a2,-(sp)
	movea.l	#tmstruct,a2
	jsr	(GetTeamNickname).l
	movea.l	(sp)+,a2
	bra.w	.36
.17
	move.l	a2,-(sp)
	movea.l	#AwShots,a2
	jsr	(GetTeamNickname).l
	movea.l	(sp)+,a2
	bra.w	.36
.18
	move.l	a2,-(sp)
	movea.l	#tmstruct,a2
	jsr	(GetTeamArena).l
	movea.l	(sp)+,a2
	bra.w	.36
.19
	move.l	a2,-(sp)
	movea.l	#AwShots,a2
	jsr	(GetTeamArena).l
	movea.l	(sp)+,a2
	bra.w	.36
.20
	jsr	(NextHomeHotPlayer).l
	bra.w	.29
.21
	jsr	(NextAwayHotPlayer).l
	bra.w	.29
.22
	jsr	(NextHomeColdPlayer).l
	bra.w	.29
.23
	jsr	(NextAwayColdPlayer).l
	bra.w	.29
.24
	movea.l	#tmstruct,a1
	tst.w	(awayhotter).w
	beq.w	.25
	movea.l	#AwShots,a1
.25
	movea.l	tmdata(a1),a1
	adda.w	4(a1),a1
	bra.w	.36
.26
	movea.w	#(AwShots-M68K_RAM),a1
	bra.w	.28
.27
	movea.w	#(tmstruct-M68K_RAM),a1
.28
	move.w	tmgoalie(a1),d1
.29
	movea.l	tmdata(a1),a1
	adda.w	(a1),a1
	bra.w	.31
.30
	adda.w	(a1),a1
	addq.w	#8,a1
.31
	dbf	d1,.30
	bra.w	.36
.32
	movea.l	(AwayTeamRosterPtr).w,a1
	adda.w	4(a1),a1
	bra.w	.36
.33
	movea.l	(AwayTeamRosterPtr).w,a1
	bra.w	.35
.34
	movea.l	(HomeTeamRosterPtr).w,a1
.35
	adda.w	4(a1),a1
.36
	addq.w	#1,(PlayerScrollCtr).w
	add.w	(a1),d0
	subq.w	#1,d0
	move.w	(a1),d1
	subq.w	#2,d1
	tst.b	1(a1,d1.w)
	bne.w	.11
	subq.w	#1,d1
	bra.w	.11

ScrollDisplayUp	;Next text line of ScoutTextPlayer; at 7 lines scroll the 8 rows up
	clr.w	(DispAttribCtr).w
	addq.w	#1,(VertLineScrolling).w
	cmpi.w	#7,(VertLineScrolling).l
	blt.w	rtsScoutText
	subq.w	#1,(VertLineScrolling).w
	movem.l	d0-d3,-(sp)
	move.l	#7,d3
	move.w	(VmMap1).w,d1
	addi.w	#$316,d1
.0
	move.l	#$30,d0
	move.w	d1,d2
	addi.w	#$80,d2
	jsr	(DoDMA_nd2).l
	move.w	d2,d1
	dbf	d3,.0
	movem.l	(sp)+,d0-d3
	rts

CompareHotColdTotals	;Compare the hot / cold totals of the teams (GetHotColdTotal): d0 = $22 / $23 (the better team, awayhotter) when they differ enough, else -1
	movem.l	d1-d7/a0-a6,-(sp)
	movea.l	#tmstruct,a0
	bsr.w	GetHotColdTotal
	move.w	d1,(TempWord1).w
	movea.l	#AwShots,a0
	bsr.w	GetHotColdTotal
	move.w	d1,(TempWord2).w
	move.w	(TempWord1).w,d1
	move.w	(TempWord2).w,d2
	sub.w	d1,d2
	move.w	#0,(awayhotter).w
	tst.w	d2
	bmi.w	.0
	move.w	#1,(awayhotter).w
.0
	tst.w	d2
	bpl.w	.1
	neg.w	d2
.1
	move.w	#$FFFF,d0
	cmp.w	#$5E,d2
	blt.w	.2
	move.w	#$22,d0
	cmp.w	#$BD,d2
	blt.w	.2
	move.w	#$23,d0
.2
	movem.l	(sp)+,d1-d7/a0-a6
	rts

GetHotColdTotal	;d1 = the hot / cold total of the starters of team a0 (SortHotColdStarters, TempBuffer)
	bsr.w	SortHotColdStarters
	move.w	#6,d0
	movea.l	#linemarkbuf,a0
	clr.w	d1
.0
	move.b	1(a0),d2
	ext.w	d2
	add.w	d2,d1
	tst.w	(a0)+
	dbf	d0,.0
	rts

PrintPlayerNameRight	;Print the name of player d0 of team a2 ending before column $29, then HotColdIcon
	movem.l	d0-d7/a0-a6,-(sp)
	move.w	d0,(iconplayer).w
	move.l	a2,-(sp)
	jsr	(FormatPlayerName).l
	movea.l	a1,a0
	move.w	(a0),d0
	move.w	d0,d5
	tst.b	-1(a0,d5.w)
	bne.w	.0
	subq.w	#1,d0
	tst.b	-2(a0,d5.w)
	bne.w	.0
	subq.w	#1,d0
.0
	add.w	(printx).w,d0
	subi.w	#$29,d0
	bmi.w	.1
	neg.w	d0
	add.w	d0,(printx).w
.1
	movea.l	a0,a1
	jsr	(print).l
	movea.l	(sp)+,a2
	jsr	(HotColdIcon).l
	movem.l	(sp)+,d0-d7/a0-a6
	rts

HotColdIcon	;The hot or cold icon by player iconplayer of team a2, or erase it
	movem.l	d0/a0-a1,-(sp)
	movea.l	#awayhotplayer,a0
	move.w	#1,(iconplayer+$2).w
	cmpa.l	#tmstruct,a2
	bne.w	.0
	movea.l	#homehotplayer,a0
	move.w	#$1C,(iconplayer+$2).w
.0
	move.w	#0,d0
.1
	move.w	(a0)+,d1
	cmp.w	(iconplayer).w,d1
	beq.w	.4
	dbf	d0,.1
	movea.l	#awaycoldplayer,a0
	cmpa.l	#tmstruct,a2
	bne.w	.2
	movea.l	#homecoldplayer,a0
.2
	move.w	#0,d0
.3
	move.w	(a0)+,d1
	cmp.w	(iconplayer).w,d1
	beq.w	.5
	dbf	d0,.3
	move.w	(iconplayer+$2).w,(printx).w
	move.w	#$11,(printy).w
	move.w	#2,d0
	move.w	#6,d1
	move.w	#$7FF,d2
	jsr	(eraser).l
	bra.w	.7
.4
	move.w	(hoticonchars).w,d4
	movea.l	#HotIconMap,a0
	bra.w	.6
.5
	move.w	(coldiconchars).w,d4
	movea.l	#ColdIconMap,a0
.6
	move.w	(iconplayer+$2).w,(printx).w
	move.w	#$11,(printy).w
	movea.l	a0,a1
	movea.l	a0,a2
	adda.l	(a2)+,a0
	adda.l	(a2)+,a1
	movea.w	#ZeroLong,a2
	clr.w	d0
	clr.w	d1
	move.w	(a1),d2
	move.w	2(a1),d3
	moveq	#0,d5
	jsr	(dobitmap).l
.7
	movem.l	(sp)+,d0/a0-a1
	rts

NextHomeHotPlayer	;d1 = the next home hot player (homehotidx, homehotplayer)
	movem.l	d0/a0,-(sp)
	movea.l	#homehotplayer,a0
	move.w	(homehotidx).w,d0
	add.w	d0,d0
	move.w	(a0,d0.w),d1
	cmpi.w	#0,(homehotidx).w
	bge.w	.0
	addq.w	#1,(homehotidx).w
.0
	movem.l	(sp)+,d0/a0
	movea.l	#tmstruct,a1
	rts

NextAwayHotPlayer	;The same for the away team (awayhotidx, awayhotplayer)
	movem.l	d0/a0,-(sp)
	movea.l	#awayhotplayer,a0
	move.w	(awayhotidx).w,d0
	add.w	d0,d0
	move.w	(a0,d0.w),d1
	cmpi.w	#0,(awayhotidx).w
	bge.w	.0
	addq.w	#1,(awayhotidx).w
.0
	movem.l	(sp)+,d0/a0
	movea.l	#AwShots,a1
	rts

NextHomeColdPlayer	;d1 = the next home cold player (homecoldidx, homecoldplayer)
	movem.l	d0/a0,-(sp)
	movea.l	#homecoldplayer,a0
	move.w	(homecoldidx).w,d0
	add.w	d0,d0
	move.w	(a0,d0.w),d1
	cmpi.w	#0,(homecoldidx).w
	bge.w	.0
	addq.w	#1,(homecoldidx).w
.0
	movem.l	(sp)+,d0/a0
	movea.l	#tmstruct,a1
	rts

NextAwayColdPlayer	;The same for the away team (awaycoldidx, awaycoldplayer)
	movem.l	d0/a0,-(sp)
	movea.l	#awaycoldplayer,a0
	move.w	(awaycoldidx).w,d0
	add.w	d0,d0
	move.w	(a0,d0.w),d1
	cmpi.w	#0,(awaycoldidx).w
	bge.w	.0
	addq.w	#1,(awaycoldidx).w
.0
	movem.l	(sp)+,d0/a0
	movea.l	#AwShots,a1
	rts

GetTeamArena	;a1 = the arena String of team a2
	movem.l	d0/a0/a2,-(sp)
	movea.l	a2,a1
	movea.l	$1E(a1),a1	;tmdata
	adda.w	4(a1),a1	;city
	adda.w	(a1),a1
	adda.w	(a1),a1
	adda.w	(a1),a1	;arena
	movem.l	(sp)+,d0/a0/a2
	rts

GetTeamNickname	;a1 = the nickname String of team a2, or HomeTxt / VisitorsTxt when it is empty
	movem.l	d0/a0/a2,-(sp)
	movea.l	a2,a1
	movea.l	$1E(a1),a1	;tmdata
	adda.w	4(a1),a1	;city
	adda.w	(a1),a1	;abbreviation
	adda.w	(a1),a1	;nickname
	cmpi.w	#2,(a1)	;empty String?
	bne.w	.0
	movea.l	#HomeTxt,a1
	cmpa.l	#tmstruct,a2
	beq.w	.0
	movea.l	#VisitorsTxt,a1
.0
	movem.l	(sp)+,d0/a0/a2
	rts

HomeTxt	;HomeTxt
	String	'Home'

VisitorsTxt	;VisitorsTxt
	String	'Visitors'

CopyHottestPlayer	;Copy the hottest player of TempBuffer to the list a0
	movem.l	d0-d1/a0-a1,-(sp)
	movea.l	#linemarkbuf,a1
	move.w	#0,d0
.0
	clr.b	(a0)+
	move.b	(a1),d1
	move.b	d1,(a0)+
	tst.w	(a1)+
	dbf	d0,.0
	movem.l	(sp)+,d0-d1/a0-a1
	rts

CopyColdestPlayer	;Copy the coldest player of TempBuffer to the list a0
	movem.l	d0/a0-a1,-(sp)
	movea.l	#TempBuffer+$A,a1
	move.w	#0,d0
.0
	clr.b	(a0)+
	move.b	(a1),(a0)+
	tst.w	-(a1)
	dbf	d0,.0
	movem.l	(sp)+,d0/a0-a1
	rts

GetTeamRating	;d0 = the rating byte of team $28(a2): TeamRatingsLine with OptLine 1, else TeamRatings
	movem.l	d1-d7/a0-a6,-(sp)
	move.w	Xvel(a2),d0
	movea.l	#TeamRatingsLine,a0
	cmpi.w	#1,(OptLine).w
	beq.w	.0
	movea.l	#TeamRatings,a0
.0
	clr.w	d1
	move.b	(a0,d0.w),d1
	move.w	d1,d0
	movem.l	(sp)+,d1-d7/a0-a6
	rts

TeamRatingsLine	;GetTeamRating values with OptLine 1, one byte per team
	dc.b	$3A,$4D,$4E,$4D,$53,$47,$4F,$45,$41,$40,$49,$4C,$49,$42,$4F
	dc.b	$3A,$47,$4E,$45,$46,$4F,$40,$4B,$4B,$46,$46,$58,$58,$63,$63

TeamRatings	;GetTeamRating values, one byte per team (TeamList order)
	dc.b	$32,$45,$4C,$46,$48,$42,$45,$3C,$3B,$3E,$3D,$40,$45,$3B,$4D
	dc.b	$30,$3F,$48,$43,$3F,$41,$37,$45,$45,$42,$40,$4E,$50,$63,$63

ScoutTextScript	;The scouting text lines, each ended by $D, $FF after the last; ScoutTextPlayer skips n $D for line n
	;substitution chars: ^ arena  = home team  * away team  } away (alt intro)  < > | \ hot/cold players  # home user name (NextHomeUser)  % away user name (NextAwayUser)
	incbin	..\Extracted\NHL95\Text\ScoutTextScript.bin

GetHomeUsers	;homeusers = the count, then the name log entries of the pads on the home team (pad1user ... pad4user)
	move.l	a0,-(sp)
	movea.l	#homeusers+1,a0
	clr.b	(ThreeStars).w
	cmpi.w	#1,(cont1team).w
	bne.w	.0
	tst.w	(pad1user).w
	beq.w	.0
	addq.b	#1,(ThreeStars).w
	move.b	(pad1user+1).w,(a0)+
.0
	cmpi.w	#1,(cont2team).w
	bne.w	.1
	tst.w	(pad2user).w
	beq.w	.1
	addq.b	#1,(ThreeStars).w
	move.b	(pad2user+1).w,(a0)+
.1
	cmpi.w	#1,(cont3team).w
	bne.w	.2
	tst.w	(pad3user).w
	beq.w	.2
	addq.b	#1,(ThreeStars).w
	move.b	(pad3user+1).w,(a0)+
.2
	cmpi.w	#1,(cont4team).w
	bne.w	.3
	tst.w	(pad4user).w
	beq.w	.3
	addq.b	#1,(ThreeStars).w
	move.b	(pad4user+1).w,(a0)+
.3
	movea.l	(sp)+,a0
	rts

GetAwayUsers	;awayusers: the same for the away team
	move.l	a0,-(sp)
	movea.l	#awayusers+1,a0
	clr.b	(CalMonths).w
	cmpi.w	#2,(cont1team).w
	bne.w	.0
	tst.w	(pad1user).w
	beq.w	.0
	addq.b	#1,(CalMonths).w
	move.b	(pad1user+1).w,(a0)+
.0
	cmpi.w	#2,(cont2team).w
	bne.w	.1
	tst.w	(pad2user).w
	beq.w	.1
	addq.b	#1,(CalMonths).w
	move.b	(pad2user+1).w,(a0)+
.1
	cmpi.w	#2,(cont3team).w
	bne.w	.2
	tst.w	(pad3user).w
	beq.w	.2
	addq.b	#1,(CalMonths).w
	move.b	(pad3user+1).w,(a0)+
.2
	cmpi.w	#2,(cont4team).w
	bne.w	.3
	tst.w	(pad4user).w
	beq.w	.3
	addq.b	#1,(CalMonths).w
	move.b	(pad4user+1).w,(a0)+
.3
	movea.l	(sp)+,a0
	rts

NextAwayUser	;Scout text %: a1 = the name String of the last away user (UserNameString), the count down one
	movem.l	d0-d1/a0,-(sp)
	movea.l	#CalMonths,a0
	bra.w	PopUserName

NextHomeUser	;Scout text #: the same for the home users
	movem.l	d0-d1/a0,-(sp)
	movea.l	#ThreeStars,a0

PopUserName	;NextHomeUser / NextAwayUser: pop the last entry of the list a0 (count byte first) as a name String (UserNameString)
	move.b	(a0),d0
	ext.w	d0
	subq.b	#1,(a0)
	move.b	(a0,d0.w),d1
	ext.w	d1
	bsr.w	UserNameString
	movem.l	(sp)+,d0-d1/a0
	rts

UserNameString	;a1 = NameEntryBuf: the name of name log entry d1 (GetLogName) as a String
	movea.l	#NameEntryBuf+2,a1
	move.w	d1,(namelogsel).w
	jsr	(GetLogName).l
	adda.w	(NameEntryLen).w,a1
	move.b	#0,(a1)
	addq.w	#1,(NameEntryLen).w
	andi.w	#$FFFE,(NameEntryLen).w
	addq.w	#2,(NameEntryLen).w
	move.w	(NameEntryLen).w,(NameEntryBuf).w
	movea.l	#NameEntryBuf,a1
	rts

NullSaveClear	;Does nothing
	rts

GetPlayerPicture	;Only the picture: a0 = the picture of player d0 of team d1 (the team picture by jersey number, else a generic one)
	movem.l	d0-d7/a1-a6,-(sp)
	btst	#6,(sflags11).w
	beq.w	.0
	movea.l	#TeamList,a0
	move.w	d1,d7
	asl.w	#2,d1
	movea.l	(a0,d1.w),a0
	adda.w	6(a0),a0
	move.b	(a0,d0.w),d0
	ext.w	d0
	subq.w	#1,d0
	bra.w	.1
.0
	movea.l	#SaveRAM+2*SRLines,a0
	move.w	d1,d7
	mulu.w	#$82,d1
	adda.l	d1,a0
	add.w	d0,d0
	move.w	(a0,d0.w),d0
	ext.w	d0
	subq.w	#1,d0
.1
	move.w	d0,-(sp)
	jsr	(ReadAttributeNibbleD7).l
	clr.w	(rosterteam).w
	cmp.w	(sp),d0
	bgt.w	.2
	move.w	#$FFFF,(rosterteam).w
.2
	move.w	(sp)+,d0
	jsr	(GetRosterId).l
	move.w	d0,d1
	lsr.w	#8,d1
	andi.w	#$1F,d1
	cmp.w	#$1E,d1
	beq.w	.5
	move.w	d0,d5
	andi.w	#$FF,d0
	addq.w	#1,d0
	move.w	d1,d2
	movea.l	#TeamList,a0
	asl.w	#2,d2
	movea.l	(a0,d2.w),a0
	adda.w	6(a0),a0
	clr.w	d4
.3
	cmp.b	(a0)+,d0
	beq.w	.4
	addq.w	#1,d4
	cmp.w	#6,d4
	blt.s	.3
	move.w	d5,d0
	bra.w	.5
.4
	movea.l	#FeaturedPicIdx,a0
	mulu.w	#6,d1
	adda.l	d1,a0
	move.b	(a0,d4.w),d4
	andi.w	#$FF,d4
	asl.w	#2,d4
	movea.l	#FeaturedPictures,a0
	movea.l	(a0,d4.w),a0
	bra.w	.7
.5
	jsr	(GetCreatedName).l
	adda.w	(a1),a1
	move.b	4(a1),d3
	btst	#0,d3
	bne.w	.6
	movea.l	#NoPicSkater1,a0
	tst.w	(rosterteam).w
	bne.w	.7
	movea.l	#NoPicGoalie2,a0
	bra.w	.7
.6
	movea.l	#NoPicSkater2,a0
	tst.w	(rosterteam).w
	bne.w	.7
	movea.l	#NoPicGoalie1,a0
.7
	movem.l	(sp)+,d0-d7/a1-a6
	rts
