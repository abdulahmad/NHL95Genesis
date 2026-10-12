;	Display setup for game play. This file places the players' sprites on the screen, draws the
;	pad markers and button labels, steps each animation to its next frame and sets up and sorts
;	the default sprites.

;------------------------------------------------------------------------------------------------------------------------
;	Sprite sorting and the pad objects, before the animation update.


setvideo	;This is not vblank code but sets up ram for vblank transfers. Called once per game frame (DoGameFrame, Pausemode, ...).
	;95 has no showzam, AddArenaAnimSprite or Crowd_Noise here, and no clock while paused
	movem.l	d0-d7/a0-a6,-(sp)
.p
	btst	#dfok,(disflags).w	;dfok: wait for vblank to take the last frame
	bne.s	.p
	movea.w	#(DMAList-M68K_RAM),a5	;dma transfer list
	jsr	(updatescroll).l
	movea.w	#(Satt-M68K_RAM),a6	;sprite attribute table area
	moveq	#1,d6	;link counter
	jsr	(checkfo).l
	bsr.w	checksso
	bsr.w	setsortcords
	bsr.w	setffo
	btst	#sfpz,(sflags).w	;no clock while paused
	bne.w	.0
	jsr	(showclock).l
.0
	jsr	(showcrowd).l
	jsr	(showref).l
	cmpa.w	#(Satt-M68K_RAM),a6	;no sprites: one blank sprite
	bne.w	.n
	clr.l	(a6)+
	clr.l	(a6)+
.n
	clr.b	-5(a6)	;end sprite list
	move.l	a6,d0
	subi.l	#Satt,d0
	lsr.w	#1,d0	;words
	move.w	d0,(Sattsize).w
	move.l	a5,(DMAlistend).w
	bset	#dfok,(disflags).w	;dfok
	movem.l	(sp)+,d0-d7/a0-a6
	rts

setsortcords	;Setup sort cord graphics: addframe for the 16 objects in OOlist order. a5 = dmalist, a6 = sprite attribute table,
	;d6 = link counter
	movea.w	#(OOlist-M68K_RAM),a4	;move OOlist into a4
	move.w	#$F,d0	;sortobj-1 (15 dec)
.top
	clr.w	d1
	move.b	(a4)+,d1	;move next sortcord into d1
	asl.w	#6,d1	;mult by 64
	movea.w	#(SortCords-M68K_RAM),a3	;Sort Cord struct start into a3
	adda.w	d1,a3	;add offset to next struct
	jsr	(addframe).l
	dbf	d0,.top	;loop until done
rtssdisp	;Shared rts; checksso branches here
	rts

checksso	;Do graphics for sso structure: arrows for the players when they are off screen. Called from setvideo. a5 = dma list,
	;a6 = sprite table, d6 = link counter. Returns on the horizontal rink. Pads 3 and 4 when cont3team / cont4team. Falls into .ca for the last one
	btst	#sfhor,(sflags).w
	bne.w	.x
	movea.w	#(Joy1Struct-M68K_RAM),a0
	movea.w	#(sso-M68K_RAM),a3
	move.w	#$69,d3	;SPFarrow, the first arrow frame (94: $180)
	bsr.w	.ca
	adda.w	#$1C,a0	;ffosize
	adda.w	#$14,a3	;ssosize
	move.w	#$6C,d3
	bsr.w	.ca
	tst.w	(cont3team).w
	beq.w	.x	;on screen: no arrow
	movea.w	#(Joy3Struct-M68K_RAM),a0
	adda.w	#$14,a3
	move.w	#$73,d3
	bsr.w	.ca
	tst.w	(cont4team).w
	beq.w	.x
	movea.w	#(Joy4Struct-M68K_RAM),a0
	adda.w	#$14,a3
	move.w	#$76,d3
.ca	;(93 .ca). a0 = object, a3 = sso, d3 = first arrow frame. In a shootout, with sflags2 bit 3 or in a penalty shot, no arrow
	;for a player beyond x $B6 (94: $A6). 95 has no horizontal rink case here
	tst.w	Zpos(a0)
	bmi.w	.x	;not on the ice
	st	frame(a3)
	move.w	(a0),d0
	btst	#0,(gmode2).w
	bne.w	.0
	btst	#3,(sflags2).w
	bne.w	.0
	btst	#2,(BA_PS_flags).w
	beq.w	.7
.0
	move.w	d0,-(sp)
	tst.w	d0
	bpl.w	.2
	neg.w	d0
.2
	cmp.w	#$B6,d0
	blt.w	.6
	move.w	(sp)+,d0
.x
	rts
.6
	move.w	(sp)+,d0
.7
	move.w	Ypos(a0),d1
	sub.w	(Hpos).w,d0
	sub.w	(Vpos).w,d1
	clr.w	d2
	cmp.w	#$74,d0	;xoff = 116
	blt.w	.8
	bset	#3,d2
.8
	cmp.w	#$FF8C,d0	;-.xoff
	bgt.w	.1
	bset	#2,d2
.1
	cmp.w	#$64,d1	;yoff = 100
	blt.w	.9
	bset	#0,d2
.9
	cmp.w	#$FF9C,d1	;-.yoff
	bgt.w	.3
	bset	#1,d2
.3
	tst.w	d2
	beq.w	rtssdisp
	movea.l	#jdtab,a1
	move.b	(a1,d2.w),d2
	asl.w	#3,d2
	movea.l	#.tab,a1
	move.w	(a1,d2.w),d4
	beq.w	.4
	move.w	d4,d0
.4
	addi.w	#$100,d0	;128+128
	move.w	d0,(a3)
	move.w	2(a1,d2.w),d4
	beq.w	.5
	move.w	d4,d1
.5
	neg.w	d1
	addi.w	#$F0,d1	;112+128
	move.w	d1,2(a3)
	add.w	4(a1,d2.w),d3
	move.w	d3,frame(a3)
	move.w	6(a1,d2.w),attribute(a3)
	jmp	(addframe2).l	;bra.w
.tab	;93 .tab. x spot, y spot, frame add, attribute per direction
	dc.w	0,$64,0,$0000
	dc.w	$74,$64,1,$0000
	dc.w	$74,0,2,$0000
	dc.w	$74,-$64,1,$1000
	dc.w	0,-$64,0,$1000
	dc.w	-$74,-$64,1,$1800
	dc.w	-$74,0,2,$0800
	dc.w	-$74,$64,1,$0800

setffo	;Draw the 6 objects tied to icerink scrolling (the pads; 94: 7 with the gloves), moving each by its x offset. Called from setvideo
	bsr.w	uppads
	move.w	#5,d0	;ffo obj -1 (94: 6)
	movea.w	#(pads-M68K_RAM),a3	;move start of struct into a3
.top
	movea.w	a6,a0
	jsr	(addframe).l
	cmpa.w	a6,a0
	beq.w	.next
	move.w	2(a3),d1
	add.w	d1,6(a0)
	add.w	d1,$E(a0)
.next
	adda.w	#$1C,a3	;move to next struct
	dbf	d0,.top
	rts

uppads	;Update the 6 pad objects and queue new pad labels (QueuePadLabel). The pad players come from the
	;PadControlBits nibbles ($E = no change, $F = none). 95 has no glove object and takes all 6 nibbles from one long
	move.w	#5,d4
	movea.w	#(pads-M68K_RAM),a0
	movea.w	#(padcont-M68K_RAM),a1
	movea.w	#(SortCords-M68K_RAM),a2
	move.l	(PadControlBits).w,d3
.nibble
	move.w	d3,d0
	andi.w	#$F,d0
	move.w	#$F,d1
	cmp.w	#$E,d0
	beq.w	.chg
	st	Zpos(a0)
	cmp.w	#$F,d0
	beq.w	.next
	asl.w	#7,d0
	move.w	(a2,d0.w),(a0)
	move.w	Ypos(a2,d0.w),Ypos(a0)
	clr.w	Zpos(a0)
	move.b	$35(a2,d0.w),d1	;position+1
	asl.w	#8,d1
	move.b	rostnum(a2,d0.w),d1	;rostnum
.chg
	cmp.w	(a1),d1
	beq.w	.next
	move.w	d1,(a1)
	bsr.w	QueuePadLabel
.next
	lsr.l	#4,d3
	adda.w	#$1C,a0
	addq.w	#2,a1
	dbf	d4,.nibble
	rts

QueuePadLabel	;Queue the 3 character label of a pad object. d1 = label code: bits 7-4 and 3-0 are digits ($F =
	;blank), bits 10-8 index ButtonLabelCharTable (none while sflags7 bit 7 is set). a0 = pad object, a5 = dma list. Falls into
	;RenderSmallFontChar for the last char
	lea	ButtonLabelCharTable(pc),a4
	clr.w	2(a0)	;x offset (setffo adds it to the sprites)
	move.w	d1,d2
	lsr.w	#4,d2
	andi.w	#$F,d2
	bne.w	.hi
	move.w	#$FFF0,d2	;' '-'0': blank leading zero
	subq.w	#4,2(a0)
.hi
	addi.w	#$30,d2
	clr.w	d0
	bsr.w	RenderSmallFontChar
	move.w	d1,d2
	andi.w	#$F,d2
	cmp.w	#$F,d2
	bne.w	.lo
	move.w	#$FFF0,d2	;$F: blank
.lo
	addi.w	#$30,d2
	moveq	#1,d0
	bsr.w	RenderSmallFontChar
	move.w	d1,d2
	btst	#7,(sflags7).w
	beq.w	.0
	clr.w	d2
.0
	lsr.w	#8,d2
	andi.w	#7,d2
	bne.w	.btn
	addq.w	#4,2(a0)
.btn
	move.b	(a4,d2.w),d2
	moveq	#2,d0

RenderSmallFontChar	;Dma one small font tile (SmallFontMap) to the object's chars. d2 = ascii char, d0 = char slot
	;a0 = object (VRchar), a5 = dma list
	movea.l	#SmallFontMap,a3
	adda.l	4(a3),a3
	add.w	d2,d2
	move.w	4(a3,d2.w),d2
	andi.w	#$7FF,d2
	asl.w	#5,d2	;32 bytes per tile
	movea.l	#SmallFontMap,a3
	lea	$A(a3,d2.w),a3
	move.l	a3,(a5)+
	move.w	#$10,(a5)+	;words to transfer
	add.w	VRchar(a0),d0
	asl.w	#5,d0
	move.w	d0,(a5)+
	rts

ButtonLabelCharTable	;Third label character by bits 10-8 of the label code
	dc.b	' DDLCRX',$FF	;pad byte $FF as 94

;------------------------------------------------------------------------------------------------------------------------

updateanim	;Frame switch control on struct a3. Called from updateplayers. 95: no horizontal rink case, and an
	;animation whose flag has bits 0 and 1 set loops back to the pair in the flag's high byte (SPAskate $1003)
	tst.w	SPA(a3)	;test SPA
	bne.w	.ia	;branch if not 0
	bclr	#pfalock,pflags(a3)	;clear anim lock
	bclr	#pf2aip,pflags2(a3)	;clear anim in progress
	rts
.ia
	movea.l	#SPAlist,a0	;animation data tables
	adda.w	SPA(a3),a0	;add SPA to a0 address
	move.w	Ypos(a3),d0	;left over from the 94 horizontal rink check
	move.w	#0,d0
	move.w	$10(a0),d1	;16 dec - attributes for anim
	move.w	facedir(a3),d0	;facedir into d0
	btst	#3,attribute(a3)	;x flip flag
	beq.w	.nox	;branch if no flip
	neg.w	d0	;negate d0
	addq.w	#8,d0	;add 8 to d0 for flipping
	andi.w	#7,d0	;pass first 3 bits
.nox
	asl.w	#1,d0	;mult by 2
	adda.w	(a0,d0.w),a0	;add the direction offset: a0 = this direction's frame,time pairs
	move.w	SPAnum(a3),d0	;SPANum into d0 (index into animation)
	move.w	(a0,d0.w),d2	;the new SPF frame of this animation
	tst.w	SPAcnt(a3)	;check if SPAcnt is 0 (time for a new frame)
	bmi.w	.1	;branch if so (SPAcnt is negative)
	sub.w	d7,SPAcnt(a3)	;sub frames elasped from SPAcnt
	bpl.w	.cframe	;branch if SPAcnt is positive
	addq.w	#4,SPAnum(a3)	;add 4 to SPAnum (set for next index)
	addq.w	#4,d0	;add 4 to d0 (currently holds current index)
	tst.w	-2(a0,d0.w)	;the frame time for the previous frame
	bpl.w	.1	;branch if positive (not the end of the animation)
	btst	#0,d1	;check if anim attribute loops
	beq.w	.end
	btst	#1,d1	;loop to the pair in the flag's high byte
	bne.w	.again
	clr.w	d0	;loop from the start
	clr.w	SPAnum(a3)	;clear SPANum
	bclr	#pfalock,pflags(a3)	;clear animation lock
	bclr	#pf2aip,pflags2(a3)	;clear animation in progress
	bclr	#pf3fall,pflags3(a3)	;clear fall down flag
	bra.w	.1
.again
	lsr.w	#8,d1
	andi.w	#$FF,d1
	asl.w	#2,d1
	move.w	d1,SPAnum(a3)
	cmpi.w	#SPAinjuryfall,SPA(a3)	;the injured player stays locked
	beq.w	.1
	bclr	#pfalock,pflags(a3)
	bclr	#pf2aip,pflags2(a3)
	bclr	#pf3fall,pflags3(a3)
	bra.w	.1
.end	;The animation is over
	clr.w	d0
	clr.w	SPAnum(a3)
	bclr	#pfalock,pflags(a3)
	bclr	#pf2aip,pflags2(a3)
	bclr	#pf3fall,pflags3(a3)
	cmpi.w	#SPAfallback,SPA(a3)	;a fall back ends facing the other way
	bne.w	.clr
	eori.w	#4,facedir(a3)
.clr
	clr.w	SPA(a3)	;clear SPA
.1
	move.w	2(a0,d0.w),d0	;move frame time for animation frame into d0
	bpl.w	.0	;branch if positive
	neg.w	d0	;make d0 positive (this is the case if final frame)
.0
	move.w	d0,SPAcnt(a3)	;move d0 into SPAcnt
.cframe
	sub.b	d7,glitch(a3)	;sub frames elapsed from glitch - limit minimum time between frame switches
	bpl.w	.rtss	;branch if glitch is positive still
	clr.b	glitch(a3)	;clear glitch
	cmp.w	frame(a3),d2	;compare frame to d2
	beq.w	.rtss	;branch if equal
	move.w	d2,frame(a3)	;move d2 into frame
	move.b	#4,glitch(a3)	;move 4 into glitch - /60 sec min frame switch time
.rtss
	rts

;------------------------------------------------------------------------------------------------------------------------
;	The default sprites and the sprite sort.


defaultsprites	;Allocate vram and assign char area for graphic structures. d4 = char area for data. Sets up the sso (4) and
	;ffo (6; 94: 7 with the gloves) objects from .listsso / .listffo, then defaultsprites2. Called from setupice
	movea.l	#.listsso,a2
	movea.w	#(sso-M68K_RAM),a3
	moveq	#3,d0	;#ssonum-1 into d0
.ssotop
	move.w	#$FFFF,oldframe(a3)	;screen objects not locked to scroll of screen
	move.w	(a2)+,(a3)
	move.w	(a2)+,2(a3)
	move.w	(a2)+,frame(a3)
	move.w	(a2)+,attribute(a3)
	move.w	d4,VRchar(a3)
	add.w	(a2)+,d4
	adda.w	#$14,a3	;#ssosize
	dbf	d0,.ssotop
	movea.l	#.listffo,a2
	movea.l	#pads,a3	;ffo
	moveq	#5,d0	;#ffonum-1 (94: 6)
.ffotop
	st	oldframe(a3)	;objects tied to screen scrolling (not players/net/puck)
	move.w	(a2)+,(a3)
	move.w	(a2)+,Ypos(a3)
	move.w	(a2)+,Zpos(a3)
	move.w	(a2)+,frame(a3)
	move.w	(a2)+,attribute(a3)
	move.w	d4,VRchar(a3)
	add.w	(a2)+,d4
	adda.w	#$1C,a3	;#ffosize
	dbf	d0,.ffotop
	bra.w	defaultsprites2
.listsso	;Xcord,ycord,frame,attribute,vram char size
	dc.w	0,0,0,0,9
	dc.w	0,0,0,0,9
	dc.w	0,0,0,0,9
	dc.w	0,0,0,0,9
.listffo	;Xcord,ycord,zpos,frame,attribute,vram char size
	dc.w	0,0,$FFFF,$71,0,7	;SPFpad+2 frame (puck poss. star)
	dc.w	0,0,$FFFF,$6F,0,7	;SPFpad+0 frame (joypad 1 star)
	dc.w	0,0,$FFFF,$70,0,7	;SPFpad+1 frame (joypad 2 star)
	dc.w	0,0,$FFFF,$79,0,7	;SPFpad34+0 frame (joypad 3 star)
	dc.w	0,0,$FFFF,$7A,0,7	;SPFpad34+1 frame (joypad 4 star)
	dc.w	0,0,$FFFF,$72,$8000,7	;SPFreplay frame (replay cursor)

defaultsprites2	;Objects which are tied to screen scrolling and have velocity: the 16 SortCords objects from .list (players,
	;puck, puck shadow, goal nets ...), the OOlist and OOlistpos; then SprSort. 95 clears $78 bytes of each (94: $80) and faces the
	;away team down
	clr.w	d6
	movea.w	#(OOlist-M68K_RAM),a1
	lea	.list(pc),a2
	movea.w	#(SortCords-M68K_RAM),a3
	movea.w	#(OOlistpos-M68K_RAM),a4
.0
	moveq	#$1D,d0	;$1F
	movea.w	a3,a0
.1
	clr.l	(a0)+
	dbf	d0,.1
	move.w	d6,SCnum(a3)
	st	oldframe(a3)
	st	pnum(a3)
	move.w	(a2)+,(a3)
	move.w	(a2)+,Ypos(a3)
	move.w	(a2)+,Zpos(a3)
	move.w	(a2)+,frame(a3)
	move.w	(a2)+,attribute(a3)
	move.w	d4,VRchar(a3)
	add.w	(a2)+,d4
	move.w	(a2)+,radiusx(a3)
	move.w	(a2)+,radiusy(a3)
	addq.w	#1,a2
	move.b	(a2)+,asslist(a3)
	addq.w	#1,a2
	move.b	(a2)+,pflags(a3)
	btst	#pfteam,pflags(a3)	;the away team starts facing down
	beq.w	.2
	move.w	#4,facedir(a3)
.2
	adda.w	#SCstruct,a3
	asl.w	#1,d6
	move.b	d6,(a1)+
	lsr.w	#1,d6
	move.w	d6,(a4)+
	addq.w	#1,d6
	cmp.w	#$10,d6
	bne.s	.0
	bra.w	SprSort
.list	;Xcord,ycord,zcord,frame,att,crsize,radx,rady,asslist,pflags
	dc.w	0,$FFC4,0,$41,0,$14,8,4,0,$80	;SCnum 0 (home skaters)
	dc.w	$32,$FFF6,0,$41,0,$14,8,4,0,$80	;SCnum 1
	dc.w	0,$FFF1,0,$41,0,$14,8,4,0,$80	;SCnum 2
	dc.w	$FFCE,$FFF6,0,$41,0,$14,8,4,0,$80	;SCnum 3
	dc.w	$23,$FFCE,0,$41,0,$14,8,4,0,$80	;SCnum 4
	dc.w	0,$FEF5,0,$25E,0,$14,8,4,0,$80	;SCnum 5 (home goalie)
	dc.w	0,$3C,0,$45,1,$14,8,4,0,$40	;SCnum 6 (away skaters)
	dc.w	$FFCE,$A,0,$45,1,$14,8,4,0,$40	;SCnum 7
	dc.w	0,$F,0,$45,1,$14,8,4,0,$40	;SCnum 8
	dc.w	$32,$A,0,$45,1,$14,8,4,0,$40	;SCnum 9
	dc.w	$FFDD,$32,0,$45,1,$14,8,4,0,$40	;SCnum 10
	dc.w	0,$10B,0,$262,1,$14,8,4,0,$40	;SCnum 11 (away goalie)
	dc.w	0,$112,0,$1BE,0,$11,$14,6,0,0	;SCnum 12 (goal nets), SPFgoal frame
	dc.w	0,$FEEE,0,$1BF,0,$1C,$14,6,0,0	;SCnum 13, SPFgoal+1 frame
	dc.w	0,0,0,$1B4,0,1,5,5,1,1	;SCnum 14 (puck), SPFpuck+1 frame
	dc.w	0,0,0,$1B3,0,$18,3,3,2,4	;SCnum 15 (puck shadow), SPFpuck frame

SprSort	;Sort objects in struct SortObj and set corresponding tables for keeping them sorted later (Ylist, OOlist,
	;OOlistpos). 95 has no horizontal rink case
	movem.l	d0-d4/a0-a2,-(sp)
	movea.l	#OOlistpos,a2
	movea.l	#Ylist,a1
	movea.l	#SortCords,a0
	move.w	#$F,d3	;Sortobjs -1
.loop0
	move.w	Ypos(a0),d4
	move.w	d4,(a1)+
	adda.w	#SCstruct,a0
	dbf	d3,.loop0
	movea.l	#Ylist,a1
.loop
	clr.w	d4
	movea.l	#OOlist,a0
	move.w	#$E,d3
	clr.w	d0
	clr.w	d1
.0
	move.b	(a0)+,d0
	move.b	(a0),d1
	move.w	(a1,d0.w),d2
	cmp.w	(a1,d1.w),d2
	ble.w	.1
	move.b	d0,(a0)
	move.b	d1,-1(a0)
	move.l	a0,d2
	subi.l	#OOlist,d2
	move.w	d2,(a2,d0.w)
	subq.w	#1,d2
	move.w	d2,(a2,d1.w)
	st	d4
.1
	dbf	d3,.0
	tst.w	d4
	bne.s	.loop
	movem.l	(sp)+,d0-d4/a0-a2
	rts
