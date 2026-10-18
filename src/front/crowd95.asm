;	Crowd animation. This file steps the crowd through its frames and draws the crowd sprites.


	include	macros\genesis.mac		;String

updatecrowdf						;Every game loop, d7 = elapsed frames: the crowd level falls (faster when
									;loud); every $10 frames the next crowd frame of CrowdFrameTbl in
									;Crowdframe.
									;a frame table instead of the 94 random frame / time pairs
	cmpi.w	#$15E,(Crowdlevel).w
	blt.w	.dec
	subq.w	#3,(Crowdlevel).w		;loud crowd calms down faster
.dec
	sub.w	d7,(Crowdlevel).w
	bpl.w	.1
	clr.w	(Crowdlevel).w
.1
	sub.w	d7,(Crowdcnt).w
	bpl.w	.3
	move.w	#$10,(Crowdcnt).w
	movem.w	d0/a0,-(sp)
	movea.l	#CrowdFrameTbl,a0
	move.w	(crowdtblidx).w,d0
	addq.w	#1,d0
	tst.b	(a0,d0.w)
	bpl.w	.2
	clr.w	d0
.2
	move.w	d0,(crowdtblidx).w
	move.b	(a0,d0.w),d0
	ext.w	d0
	subq.w	#1,d0
	move.w	d0,(Crowdframe).w
	movem.w	(sp)+,d0/a0
.3
	rts

CrowdFrameTbl						;updatecrowdf crowd animation frames, -1 wraps
	dc.b	1,2,3,4,5,6,5,6,5,9,$A,4,3,4,3,4
	dc.b	5,4,3,4,5,6,7,8,9,$A,$B,$C,9,$A,8,7
	dc.b	6,5,4,$C,9,$A,5,6,7,8,1,2,3,4,5,6
	dc.b	7,8,9,$A,1,2,3,4,3,4,$B,$C,3,4,5,6
	dc.b	7,8,9,$A,$B,$C,1,2,3,4,5,4,5,9,$A,$B
	dc.b	4,5,4,3,2,3,4,5,4,5,$B,$C,6,7,8,9
	dc.b	$FF,$FF

showcrowd							;Crowd sprites: up to 3 frames per PBnum nibble (ShowCrowdPb), then the
									;Crowdframe frame none in a reverse angle replay (sflags4 bit 4). a6 =
									;sprite table, d6 = link counter
	btst	#4,(sflags4).w			;check if reverse angle replay
	bne.w	rtsShowCrowd
	movea.l	#Crowdframelist,a1
	adda.l	4(a1),a1
	move.w	(Hpos).w,d4
	move.w	(Vpos).w,d5
	clr.w	d0
	move.b	(PBnum).w,d2
	moveq	#$C,d3
	bsr.w	ShowCrowdPb
	move.b	(PBnum).w,d2
	lsr.w	#4,d2
	moveq	#$F,d3
	bsr.w	ShowCrowdPb
	move.b	(Crowdframe+1).w,d0
	bra.w	ShowCrowdFrame

ShowCrowdPb							;Crowd frames for the penalty box: d2 = the count (PBnum nibble, at most
									;3), d3 = the first frame
	andi.w	#$F,d2
	cmp.w	#3,d2
	bls.w	.0
	moveq	#3,d2
.0
	bra.w	.2
.1
	move.w	d3,d0
	add.w	d2,d0
	bsr.w	ShowCrowdFrame
.2
	dbf	d2,.1
	rts

ShowCrowdFrame						;Crowd frame d0 (0 = none): its sprites in view as sprite table entries at
									;a6 (at most $40)
	ext.w	d0
	beq.w	rtsShowCrowd
	cmp.w	#$40,d6
	bge.w	rtsShowCrowd
	movem.l	d0-d5,-(sp)
	add.w	d0,d0
	movea.l	a1,a0
	move.w	2(a0,d0.w),d1
	sub.w	(a0,d0.w),d1
	lsr.w	#3,d1
	subq.w	#1,d1
	move.w	d1,-(sp)
	adda.w	(a0,d0.w),a0
	move.w	d4,d0
	addi.w	#$C0,d0
	move.w	d0,d1
	subi.w	#$90,d0
	addi.w	#$80,d1
	move.w	#$170,d2
	sub.w	d5,d2
	move.w	d2,d3
	subi.w	#$80,d2
	addi.w	#$70,d3
	move.w	(sp)+,d4
.loop2
	cmp.w	(a0),d2
	bgt.w	.next
	cmp.w	(a0),d3
	blt.w	.next
	cmp.w	6(a0),d0
	bgt.w	.next
	cmp.w	6(a0),d1
	blt.w	.next
	move.w	(a0),d5
	addi.w	#$80,d5
	sub.w	d2,d5
	move.w	d5,(a6)+
	move.b	2(a0),(a6)+
	andi.b	#$F,-1(a6)
	move.b	d6,(a6)+
	move.b	4(a0),d5
	andi.w	#$F8,d5
	cmpi.w	#$28A,(a0)
	blt.w	.1
	ori.w	#$80,d5
.1
	lsl.w	#8,d5
	move.w	d5,-(sp)
	move.w	4(a0),d5
	andi.w	#$7FF,d5
	add.w	(animchars).w,d5
	or.w	(sp)+,d5
	move.w	d5,(a6)+
	move.w	6(a0),d5
	addi.w	#$70,d5
	sub.w	d0,d5
	move.w	d5,(a6)+
	addq.w	#1,d6
	cmp.w	#$40,d6
	beq.w	.x
.next
	addq.w	#8,a0
	dbf	d4,.loop2
.x
	movem.l	(sp)+,d0-d5

rtsShowCrowd						;Shared rts of showcrowd
	rts
