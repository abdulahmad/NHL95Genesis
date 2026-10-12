;	Video helpers. This file talks to the video chip, moves graphics into video memory, fades
;	palettes, unpacks graphics, draws sprite frames and scrolls the rink. It also runs the
;	vertical blank and reads the pads with key repeat.

;------------------------------------------------------------------------------------------------------------------------
;	VDP helpers: filling and copying VRAM, decompressing graphics, palette fades and the vblank
; transfers.


; fill vram
; d0 = bytes to fill
; d1 = vram address
; d2 = data to fill with
DoFill	;Called,. 95 writes the long straight to the vdp (94 went through dmaram)
	movem.l	d3/a1,-(sp)
	movea.l	#VDP_DATA,a1
	andi.l	#$FFFF,d1
	asl.l	#2,d1
	lsr.w	#2,d1
	ori.w	#$4000,d1
	swap	d1
	move.l	d1,Vctrl-Vdata(a1)
	move.w	d2,d3
	swap	d3
	move.w	d2,d3
	lsr.w	#1,d0
	subq.w	#1,d0
.0
	move.l	d3,(a1)
	dbf	d0,.0
	movem.l	(sp)+,d3/a1
	rts

; d0 = color to fade to
setVram	;Fade every colour to d0, then fall into setVram_0
	movea.w	#(palfadenew-M68K_RAM),a0
	moveq	#$3F,d1
.0
	move.w	d0,(a0)+
	dbf	d1,.0
	move.w	#$18,(palcount).w
	bsr.w	forcefade
setVram_0	;Second half of setVram without the fade: clear vram and set the VDP registers from disflags, Map1col
	;VmMap1-3, VSPRITES and VSCRLPM. Falls in from setVram, called from EASportsScreen
	move.w	(disflags).w,-(sp)
	bset	#dfng,(disflags).w
	move.w	#VDPR_AUTOINC+$02,(VDP_CTRL).l
	clr.w	d0
	bsr.w	Vmaddr
	move.w	#$3FFF,d0
	clr.l	d1
.9
	move.l	d1,(a0)
	dbf	d0,.9
	move.w	#$8C00,d0	;8 for shadow mode
	btst	#df32c,(disflags).w
	bne.w	.i32
	ori.w	#$81,d0
.i32
	move.w	d0,Vctrl-Vdata(a0)	;40 col mode, no interlace, normal brightness
	move.w	#VDPR_MODE1+$04,Vctrl-Vdata(a0)	;512 color palette enable
	move.w	#VDPR_MODE2+$64,Vctrl-Vdata(a0)
	move.w	#$9001,d0	;playfield is 64x32
	cmpi.w	#6,(Map1col1).w
	beq.w	.i64
	move.w	#$9003,d0
.i64
	move.w	d0,Vctrl-Vdata(a0)
	move.w	#$8200,d0
	move.b	(VmMap1).w,d0
	lsr.b	#2,d0
	andi.b	#$38,d0
	move.w	d0,Vctrl-Vdata(a0)
	move.w	#$8400,d0
	move.b	(VmMap2).w,d0
	lsr.b	#5,d0
	move.w	d0,Vctrl-Vdata(a0)
	move.w	#$8300,d0
	move.b	(VmMap3).w,d0
	lsr.b	#2,d0
	andi.b	#$3E,d0
	move.w	d0,Vctrl-Vdata(a0)
	move.w	#$8500,d0
	move.b	(VSPRITES).w,d0
	lsr.b	#1,d0
	move.w	d0,Vctrl-Vdata(a0)
	move.w	#$8D00,d0
	move.b	(VSCRLPM).w,d0
	lsr.b	#2,d0
	move.w	d0,Vctrl-Vdata(a0)
	move.w	#VDPR_WINX,Vctrl-Vdata(a0)	;disable plane 3 graphics
	move.w	#VDPR_WINY,Vctrl-Vdata(a0)	;disable plane 3 graphics
	move.w	#VDPR_BGCOL,Vctrl-Vdata(a0)	;Palette # 0 is border/transparent
	move.w	#VDPR_MODE3,Vctrl-Vdata(a0)	;Scroll mode (entire scroll)
	move.l	#VSRAM_W,Vctrl-Vdata(a0)	;vsram
	move.l	#0,(a0)	;playfield 1/2
	move.w	(sp)+,(disflags).w
	rts

; set video port to address d0
; d0 = vram address
; returns a0 = Vdata!!!
Vmaddr
	movea.l	#VDP_DATA,a0
	asl.l	#2,d0
	lsr.w	#2,d0
	ori.w	#$4000,d0
	swap	d0
	andi.w	#3,d0
	move.l	d0,Vctrl-Vdata(a0)
	rts

dobitmap	;Copy the palettes flagged in d5 to palfadenew, then write the map at a1 to the screen at printx / printy.
	;Called from most screens. 95 steps the palettes with adda.w and always ends in DecompressGraphicsPlain (94 skipped it when sflags6 bit 0)
	move.w	(printy).w,-(sp)
	move.w	(disflags).w,-(sp)
	bset	#dfng,(disflags).w
	movem.l	d0-d3/d5-d6/a0-a3,-(sp)
	move.w	d1,d6
	movea.w	#(palfadenew-M68K_RAM),a3
	bra.w	.00
.01
	move.b	(a0,d0.w),(a3,d0.w)
	dbf	d0,.01
.02
	adda.w	#$20,a0
	adda.w	#$20,a3
.00
	moveq	#$1F,d0
	lsr.w	#1,d5
	bcs.s	.01
	bne.s	.02
	move.w	(printa).w,d5
	andi.w	#$F800,d5
	move.w	$E(sp),d2
	subq.w	#1,d2
.loop2
	bsr.w	xyVmMap
	move.w	d6,d0	;y start
	mulu.w	(a1),d0	;map width
	add.w	2(sp),d0
	asl.w	#1,d0
	move.w	$A(sp),d1
	subq.w	#1,d1
.loop1
	move.w	4(a1,d0.w),d3
	add.w	d4,d3
	eor.w	d5,d3
	move.w	d3,(a0)
	addq.w	#2,d0
	dbf	d1,.loop1
	addq.w	#1,(printy).w
	addq.w	#1,d6
	dbf	d2,.loop2
	bsr.w	DecompressGraphicsPlain
	movem.l	(sp)+,d0-d3/d5-d6/a0-a3
	move.w	(sp)+,(disflags).w
	move.w	(sp)+,(printy).w
	rts

DecompressGraphicsPlain	;Clear callbackPtr, fall into DecompressGraphics
	clr.l	(callbackPtr).w
DecompressGraphics	;a2 = graphics data, d4 = start char. Called from this file. 95 has no decompressor
	;a packed block (size bit 15 set) only moves d4 past its chars
	movem.l	d0-d1/a0-a6,-(sp)
	movea.l	a2,a0
	move.w	d4,d1
	asl.w	#5,d1
	move.w	(a0)+,d0
	beq.w	.done
	bmi.w	.packed
	add.w	d0,d4
	asl.w	#4,d0
	pea	(.done).l
	tst.l	(callbackPtr).w
	beq.w	DoDMApro
	movea.l	(callbackPtr).w,a1
	bra.w	remap
.packed
	andi.w	#$7FFF,d0
	add.w	d0,d4
.done
	movem.l	(sp)+,d0-d1/a0-a6
	rts

DoDMApro	;DoDMA protected from vblank (dfng set)
	move.w	(disflags).w,-(sp)
	bset	#dfng,(disflags).w
	bsr.w	DoDMA
	move.w	(sp)+,(disflags).w
	rts

WaitDMA	;Wait for the vdp dma busy bit to clear
	move.w	(VDP_CTRL).l,-(sp)
	btst	#1,1(sp)
	addq.w	#2,sp
	bne.s	WaitDMA
	rts

forcefade	;Run the palette fade to the end: vbint = vb2 (fades only), interrupts on, wait for palcount to go negative
	move	sr,-(sp)
	move.l	(vbint).w,-(sp)
	move.w	(disflags).w,-(sp)
	bclr	#dfng,(disflags).w
	move.l	#vb2,(vbint).l
	move	#$2500,sr
.1
	tst.w	(palcount).w
	bpl.s	.1
	move.w	(sp)+,(disflags).w
	move.l	(sp)+,(vbint).w
	move	(sp)+,sr
	rts

; fade from current color in color ram to color held in palfadenew
; this should be called during vblank because palette changes punch holes in video
cramfade	;Step the palette fade (palcount) and copy the palette to cram. Called from the vblank handlers
	tst.w	(palcount).w
	bmi.w	rtss2
	cmpi.w	#$64,(palcount).w
	beq.w	CopyPaletteToCRAM
	subq.w	#1,(palcount).w
	bmi.w	rtss2
	clr.l	d0
	move.w	(palcount).w,d0
	cmp.w	#$18,d0
	bgt.w	rtss2
	divu.w	#3,d0
	swap	d0
	asl.w	#2,d0
	moveq	#2,d3
	asl.w	d0,d3
	moveq	#$E,d5
	asl.w	d0,d5
	move.w	d5,d4
	not.w	d4
	movea.l	#palfadenew,a1
	movea.l	#VDP_DATA,a0
	clr.w	d6
.top
	move.w	d3,d2
	move.w	d6,d0
	swap	d0
	move.w	#$20,d0
	move.l	d0,Vctrl-Vdata(a0)
	move.w	(a0),d7
	move.w	d7,d0
	and.w	d5,d0
	move.w	(a1)+,d1
	and.w	d5,d1
	cmp.w	d1,d0
	beq.w	.next
	blt.w	.nn
	neg.w	d2
.nn
	add.w	d2,d0
	and.w	d4,d7
	or.w	d0,d7
	move.l	#$C000,d0
	move.b	d6,d0
	swap	d0
	move.l	d0,Vctrl-Vdata(a0)
	move.w	d7,(a0)
.next
	addq.w	#2,d6
	cmp.w	#$80,d6
	bne.s	.top
	rts

CopyPaletteToCRAM	;Copy all 64 palfadenew colours to colour ram (dfng set), then palcount = -1. Called from
	;cramfade and EASportsScreen. 95 writes cram straight (94 waited for the dma and the Z80 bus)
	movem.l	d0/a0-a1,-(sp)
	move.w	(disflags).w,-(sp)
	bset	#dfng,(disflags).w
	movea.w	#(palfadenew-M68K_RAM),a1
	movea.l	#VDP_DATA,a0
	move.l	#CRAM_W,Vctrl-Vdata(a0)	;cram write, address 0
	moveq	#$1F,d0
.0
	move.l	(a1)+,(a0)
	dbf	d0,.0
	st	(palcount).w
	move.w	(sp)+,(disflags).w
	movem.l	(sp)+,d0/a0-a1
	rts

xyVmMap	;Set the vdp write address to printx, printy in the map at VmMap1 + printm
	movem.l	d0-d2,-(sp)
	move.w	(printx).w,d0
	move.w	(printy).w,d1
	movea.w	#(VmMap1-M68K_RAM),a0
	adda.w	(printm).w,a0
	move.w	2(a0),d2
	asl.w	d2,d1
	add.w	d1,d0
	asl.w	#1,d0
	add.w	(a0),d0
	bsr.w	Vmaddr
	movem.l	(sp)+,d0-d2
	rts

remap	;Write d0 chars at a0 to vram d1, each pixel through the colour map at a1. Reached from DecompressGraphics
	move.w	(disflags).w,-(sp)
	bset	#dfng,(disflags).w
	movem.l	d0-d4/a0-a2,-(sp)
	exg	d1,d0
	movea.l	a0,a2
	bsr.w	Vmaddr
	subq.w	#1,d1
.1
	moveq	#3,d0
	move.w	(a2)+,d2
	clr.w	d3
.11
	move.w	d2,d4
	andi.w	#$F,d4
	lsr.w	#1,d4
	move.b	(a1,d4.w),d4
	btst	#0,d2
	bne.w	.lo
	lsr.w	#4,d4
.lo
	andi.w	#$F,d4
	or.b	d4,d3
	ror.w	#4,d3
	ror.w	#4,d2
	dbf	d0,.11
	move.w	d3,(a0)
	dbf	d1,.1
	movem.l	(sp)+,d0-d4/a0-a2
	move.w	(sp)+,(disflags).w
	rts

DumpSprites	;Transfer (by dma) scroll stuff, sprite table, vram data in dmalist. Called from VBlank.
	;Falls into DumpSprites2
	bsr.w	SetScroll2
DumpSprites2	;Transfer sprite table, then the dma list. Falls into DoDMAlist
	movea.w	#(Satt-M68K_RAM),a0
	move.w	(Sattsize).w,d0	;words
	move.w	(VSPRITES).w,d1
	bsr.w	DoDMA
DoDMAList	;Transfer data from dmalist. Also called
	movea.l	(DMAlistend).w,a6
	cmpa.l	#DMAList,a6
	beq.w	rtss2	;list empty
.0
	move.w	-(a6),d1	;vram address
	move.w	-(a6),d0	;words
	movea.l	-(a6),a0	;source
	bsr.w	DoDMA
	cmpa.l	#DMAList,a6
	bne.s	.0
rtss2	;Shared rts, branched to from cramfade, updatescroll (below)
	;and movea.l #x
	rts

SetScroll2	;Write Hscroll / Vscroll to the vdp. Called from DumpSprites
	move.w	(VSCRLPM).w,d0
	addq.w	#2,d0
	bsr.w	Vmaddr
	move.w	(Hscroll).w,(a0)
	move.l	#VSRAM_W+(2<<16),Vctrl-Vdata(a0)	;vsram write, address 2
	move.w	(Vscroll).w,(a0)
	rts

; initiate dma transfer (dma transfer bug is compensated for)
; d0 = words to transfer
; d1 = destination vram address
; a0 = source address
DoDMA	;95 drops the 94 Z80 bus request, the sr save and the last word fix for a source in RAM
	movem.l	d2/a1,-(sp)
	move.w	d0,d2
	add.w	d2,d2
	add.w	a0,d2
	bcc.w	.nd
	beq.w	.nd
	lsr.w	#1,d2	;do 2 transers if source address crosses 64k boundary
	sub.w	d2,d0
	move.w	d0,-(sp)
	bsr.w	.dd
	move.w	(sp)+,d0
	add.w	d0,d0
	add.w	d0,d1
	adda.w	d0,a0
	move.w	d2,d0
	bra.w	.nd
.dd	;(only DoDMA calls it)
	movem.l	d2/a1,-(sp)
.nd
	lea	(VDP_CTRL).l,a1
	move.w	#VDPR_MODE2+$54,(a1)
	move.w	#VDPR_AUTOINC+$02,(a1)
	move.w	#$9300,d2
	move.b	d0,d2
	move.w	d2,(a1)
	move.w	#$9400,d2
	lsr.w	#8,d0
	move.b	d0,d2
	move.w	d2,(a1)
	move.l	a0,d0
	lsr.l	#1,d0
	move.w	#$9500,d2
	move.b	d0,d2
	move.w	d2,(a1)
	lsr.l	#8,d0
	move.w	#$9600,d2
	move.b	d0,d2
	move.w	d2,(a1)
	lsr.l	#8,d0
	andi.b	#$7F,d0
	move.w	#$9700,d2
	move.b	d0,d2
	move.w	d2,(a1)
	clr.l	d0
	move.w	d1,d0
	asl.l	#2,d0
	lsr.w	#2,d0
	ori.l	#$804000,d0
	move.l	d0,(dmaram).w
	move.w	(dmaram+2).w,(a1)
	move.w	(dmaram).w,(a1)
	bsr.w	WaitDMA
	move.w	#VDPR_MODE2+$64,(a1)
	movem.l	(sp)+,d2/a1
	rts

;------------------------------------------------------------------------------------------------------------------------
;	Adding sprite frames and scrolling the rink.

addframe	;a3 = sort cord object. Project it with find3d, then addframe2. a5 = dma trans, a6 = sprite attribute table.
	;Called from setsortcords
	movem.l	d0-d2,-(sp)
	move.w	(a3),d0	;Xpos into d0
	move.w	Ypos(a3),d1	;Ypos into d1
	move.w	Zpos(a3),d2	;Zpos into d2
	bmi.w	.exit	;exit if Zpos minus
	bsr.w	find3d	;get position on screen
	cmp.w	#$4E20,d1	;#osflag into d1
	beq.w	.exit	;exit if Sort Cord is off screen
	bsr.w	addframe2
.exit
	movem.l	(sp)+,d0-d2
	rts

addframe2	;d0/d1 = x/y coord on screen, a3 = object, a5 = dma trans, a6 = sprite attribute table, d6 = link counter. Queue the sprite tiles of
	;the frame (once per frame change, sharing tiles already sent) and write its sprites. Also jumped to from setffo.
	;95 sprite record: 0 Y global, 2 size byte (low nibble) and tile bits 11-14 (high nibble), 4 tile (11 bits) and flags (top 5), 6 X global
	move.w	attribute(a3),-(sp)	;push attribute to stack
	movem.l	d0-d5/a0-a2,-(sp)	;push to stack
	move.w	frame(a3),d4	;move frame into d4
	bmi.w	.exit	;exit if minus
	beq.w	.exit	;exit if 0
	andi.w	#$F800,d4	;pass highest 5 bits
	eor.w	d4,attribute(a3)	;EOR d4 with attribute
	move.w	frame(a3),d4	;move frame back into d4
	andi.w	#$7FF,d4	;pass first 11 bits
	movea.l	#Sprites,a2	;sprite frame list
	adda.l	4(a2),a2	;add long word at offset 4 to a2 address
	asl.w	#1,d4	;frame * 2
	cmp.w	(a2),d4	;the offset count is at 0 (94: 2)
	bge.w	.exit	;branch if greater than or equal
	move.w	2(a2,d4.w),d5	;next frame's offset
	sub.w	(a2,d4.w),d5	;minus this frame's offset
	lsr.w	#3,d5	;divide d5 by 8
	subq.w	#1,d5	;d5 now total sprites in frame -1(SprStrnum)
	adda.w	(a2,d4.w),a2	;a2 now at SprStrdat - sprite data
	clr.w	d3	;clear d3
	clr.w	d4	;clear d4
.sloop
	move.w	d0,-(sp)	;push d0 on stack
	move.w	frame(a3),d0	;move frame into d0
	andi.w	#$7FF,d0	;pass first 11 bits
	cmp.w	oldframe(a3),d0	;compare old frame to d0 (current frame)
	beq.w	.noref	;branch if equal (no change)
	tst.w	d5	;check if d5 is 0
	bne.w	.nn	;branch if not
	move.w	d0,oldframe(a3)	;move frame into old frame
.nn
	movem.w	d0-d4,-(sp)	;push to stack
	move.w	2(a2),d2	;tile bits 11-14 from the high nibble of word 2
	andi.w	#$F000,d2
	lsr.w	#1,d2
	move.w	d2,-(sp)
	move.w	4(a2),d2	;tile bits 0-10
	andi.w	#$7FF,d2
	or.w	(sp)+,d2	;d2 = 15 bit pointer to sprite tiles
	clr.w	d4	;clear d4
	move.b	2(a2),d4	;size byte
	andi.w	#$F,d4
.chk
	cmp.w	#$F,d4	;never true after the andi
	bgt.s	.chk
	movea.l	#sizetab,a0	;move address into a0
	move.b	(a0,d4.w),d4	;tiles used in sprite
	cmp.w	8(sp),d4	;compare current d4 to previous d4
	bgt.w	.nodup	;branch if d4 greater - more data in prev sprite so no dup
	;d0 = frame
	;d2 = pointer to sprite tiles
	;d4 = # of tiles in sprite
	;d5 = # of sprites in frame-1
	cmp.w	4(sp),d2	;compare current d2 to previous d2
	blt.w	.nodup	;branch if less than
	move.w	4(sp),d0	;move previous d2 into d0
	add.w	8(sp),d0	;add previous d4 to d0 - end of last data
	sub.w	d2,d0	;sub d2 from d0
	sub.w	d4,d0	;sub d4 from d0
	bmi.w	.nodup	;branch if d0 negative
	movem.w	(sp)+,d0-d1	;pop d0 and d1 from stack
	addq.w	#6,sp	;add 6 to stack pointer
	bra.w	.dup	;branch
.nodup
	add.w	8(sp),d3	;add old d4 to d3 - both of these are 0 if first sprite in frame
	movem.w	(sp)+,d0-d1	;pop d0 and d1 from stack (d0=Xpos, d1=Ypos)
	addq.w	#6,sp	;add 6 to stack pointer (moves past old d4 spot on stack)
	movem.w	d0-d4,-(sp)	;push d0-d4 to stack (all new values are on stack)
	add.w	VRchar(a3),d3	;add VRChar of player struct to d3
	ext.l	d2	;extend d2 (clears out upper word)
	asl.l	#5,d2	;mult d2 by 32
	movem.l	d0/a2,-(sp)	;the tiles start at Sprites+$A
	movea.l	#Sprites,a2
	move.l	a2,d0
	addi.l	#$A,d0
	add.l	d0,d2
	movem.l	(sp)+,d0/a2
	asl.w	#4,d4	;mult by 16 (# of sprite tiles by 16)
	asl.w	#5,d3	;mult by 32 (# of prev sprite tiles+VrChar by 32)
	move.l	d2,(a5)+
	move.w	d4,(a5)+	;words to transfer
	move.w	d3,(a5)+	;vram destination
	movem.w	(sp)+,d0-d4	;pop from stack
.dup
	move.b	d3,VRoffs(a3,d5.w)	;move d3 into VRoffs of sprite
	;This and VRChar are for VRAM access
.noref
	move.w	(sp)+,d0	;pop from stack
	movem.w	d0-d2,-(sp)	;push to stack
	move.w	(a2),d2	;Y global
	btst	#4,attribute(a3)	;check for Y flip
	beq.w	.noyflip	;branch if no y flip
	move.b	2(a2),d2	;size byte
	andi.w	#3,d2	;pass bit 1 and 2
	addq.w	#1,d2	;add 1
	asl.w	#3,d2	;mult by 8
	neg.w	d2	;negate d2
	sub.w	(a2),d2	;sub Y global from d2
.noyflip
	add.w	d2,d1	;add d2 to d1 (d1=Ypos of Sort Cord)
	move.w	d1,(a6)	;move sprite's Ypos into a6 data (Satt)
	move.w	6(a2),d2	;X global
	btst	#3,attribute(a3)	;check for x flip
	beq.w	.noxflip	;branch if no x flip
	move.b	2(a2),d2	;size byte
	andi.w	#$C,d2	;pass bit 3 and 4
	addq.w	#4,d2	;add 4
	asl.w	#1,d2	;mult by 2
	neg.w	d2	;negate d2
	sub.w	6(a2),d2	;sub X global from d2
.noxflip
	add.w	d2,d0	;add d2 to d0 (d0 = Xpos of Sort Cord)
	move.w	d0,6(a6)	;move sprite's Xpos into 6+a6 position
	move.b	2(a2),2(a6)	;move size byte into 2+a6
	move.b	d6,3(a6)	;move d6 (link counter) into 3+a6
	move.b	4(a2),d2	;flags (top 5 bits of the tile word) to the high byte
	andi.w	#$F8,d2
	lsl.w	#8,d2
	move.b	2(a2),d2
	move.w	attribute(a3),d0	;move attribute into d0
	eor.w	d0,d2	;EOR d0 with d2
	andi.w	#$F800,d2	;pass top 5 bits
	btst	#0,attribute+1(a3)	;check if bit 0 of attribute+1 is 0
	beq.w	.nospec	;branch if zero
	btst	#$E,d2	;check if bit 14 is 0
	beq.w	.nospec	;branch if zero
	bset	#$D,d2	;set bit 13 - team 2 color
.nospec
	or.b	VRoffs(a3,d5.w),d2	;OR Vroffs of a3+d5 to d2
	add.w	VRchar(a3),d2	;add VRchar to d2
	move.w	d2,4(a6)	;move d2 into 4+a6 (Satt)
	movem.w	(sp)+,d0-d2	;pop from stack
	addq.w	#1,d6	;add 1 to d6
	addq.w	#8,a6	;add 8 to a6
	addq.w	#8,a2	;add 8 to a2
	dbf	d5,.sloop	;loop if still sprites in frame
.exit
	movem.l	(sp)+,d0-d5/a0-a2
	move.w	(sp)+,attribute(a3)
	rts

sizetab	;Sprite size code to tile count. sizetab, used by addframe2 (94 kept it)
	dc.b	1,2,3,4,2,4,6,8,3,6,9,$C,4,8,$C,$10

updatescroll	;Using hpos and vpos set scroll cords; queue rink map rows on the dma list (a5) when vertical
	;scrolling needs new rows. Called from setvideo. Rows from Rinktilelist, or RevRinkTilelist in a reverse angle replay
	;(sflags4 bit 4). 95 has no horizontal rink check
	moveq	#-$40,d0	;-192+128 (#$FFFFFFC0)
	sub.w	(Hpos).w,d0
	move.w	(Vpos).w,d1
	addi.w	#$10,d1	;rink 16 lines lower
	move.w	d0,(Hscroll).w
	move.w	d1,(Vscroll).w
	neg.w	(Vscroll).w
	move.w	(Oldrow).w,d4
	asr.w	#3,d1
	move.w	d1,(Oldrow).w
	moveq	#$1F,d3	;max lines to update
	cmp.w	d4,d1
	beq.w	rtss2	;same row as last frame
	movea.l	#Rinktilelist,a0
	adda.l	4(a0),a0	;a0 = map header: (a0) = chars per row, data at 4(a0) (the movea / adda leave the cmp flags)
	blt.w	.su0	;row went up
	btst	#4,(sflags4).w	;reverse angle replay
	beq.w	.sd
	movea.l	#RevRinkTilelist,a0	;95 does not add the header offset here
.sd
	move.w	d1,d0
	neg.w	d0
	addi.w	#$1E,d0
	andi.w	#$1F,d0
	asl.w	#7,d0
	add.w	(VmMap2).w,d0
	move.w	d0,6(a5)
	move.w	#$1E,d0
	sub.w	d1,d0
	move.w	(a0),4(a5)
	mulu.w	(a0),d0
	add.w	d0,d0
	lea	4(a0,d0.w),a1
	move.l	a1,(a5)
	addq.w	#8,a5
	subq.w	#1,d1
	cmp.w	d4,d1
	dbeq	d3,.sd
	rts
.su0
	btst	#4,(sflags4).w	;reverse angle replay
	beq.w	.su
	movea.l	#RevRinkTilelist,a0
.su
	move.w	d1,d0
	neg.w	d0
	addi.w	#$1D,d0
	andi.w	#$1F,d0
	asl.w	#7,d0
	add.w	(VmMap2).w,d0
	move.w	d0,6(a5)
	move.w	#$3D,d0
	sub.w	d1,d0
	move.w	(a0),4(a5)
	mulu.w	(a0),d0
	add.w	d0,d0
	lea	4(a0,d0.w),a1
	move.l	a1,(a5)
	addq.w	#8,a5
	addq.w	#1,d1
	cmp.w	d4,d1
	dbeq	d3,.su
	rts

;------------------------------------------------------------------------------------------------------------------------
;	The graphics decompressor, the vblank handlers and the pad reads.

; fade all colors to black but don't upset palfadenew
forceblack	;Called from most screens
	movem.l	d0/a0,-(sp)
	movea.w	#(palfadenew-M68K_RAM),a0
	moveq	#$1F,d0
.0
	move.l	(a0),-(sp)
	clr.l	(a0)+
	dbf	d0,.0
	move.w	#$18,(palcount).w
	bsr.w	forcefade
	moveq	#$1F,d0
.1
	move.l	(sp)+,-(a0)
	dbf	d0,.1
	movem.l	(sp)+,d0/a0
	rts

forceblack2	;Unreferenced. Forceblack with palcount $64 (one step, CopyPaletteToCRAM)
	movem.l	d0/a0,-(sp)
	movea.w	#(palfadenew-M68K_RAM),a0
	moveq	#$1F,d0
.loop
	move.l	(a0),-(sp)
	clr.l	(a0)+
	dbf	d0,.loop
	move.w	#$64,(palcount).w
	bsr.w	forcefade
	moveq	#$1F,d0
.loop2
	move.l	(sp)+,-(a0)
	dbf	d0,.loop2
	movem.l	(sp)+,d0/a0
	rts

DecompressBytecode	;No caller in 95 (DecompressGraphics skips packed blocks). Unpack a0 into the 256 byte ring buffer at
	;ThreeStars
	movea.w	#(ThreeStars-M68K_RAM),a1
	movea.w	#(ThreeStars-M68K_RAM),a3
	movea.w	#(callbackPtr-M68K_RAM),a4
	movea.l	#remap,a5
	movea.l	#DoDMApro,a6
	movem.l	d0-d3/a0-a2,-(sp)
	move.w	d1,d3
	clr.w	d1
	clr.w	d2
.loop
	move.b	(a0)+,d0
	andi.w	#$F0,d0
	lsr.w	#3,d0
	lea	jump_table(pc),a2
	move.w	0(a2,d0.w),d0
	jsr	0(a2,d0.w)
	bra.s	.loop
jump_table	;DecompressBytecode handler offsets, one per opcode high nibble
	dc.w	Opcode_CopyLiteral-jump_table	;0
	dc.w	Opcode_CopyLiteral-jump_table	;1
	dc.w	Opcode_ClearBytes-jump_table	;2
	dc.w	Opcode_Fillbytes-jump_table	;3
	dc.w	Opcode_CopyBackwardShort-jump_table	;4
	dc.w	Opcode_CopyBackwardShort-jump_table	;5
	dc.w	Opcode_CopyBackwardShort-jump_table	;6
	dc.w	Opcode_CopyBackwardShort-jump_table	;7
	dc.w	Opcode_CopyBackwardMedium-jump_table	;8
	dc.w	Opcode_CopyBackwardLong-jump_table	;9
	dc.w	Opcode_CopyBackwardExtended1-jump_table	;A
	dc.w	Opcode_CopyBackwardExtended2-jump_table	;B
	dc.w	Opcode_CopyBackwardReverseShort-jump_table	;C
	dc.w	Opcode_CopyBackwardReverseShort-jump_table	;D
	dc.w	Opcode_CopyBackwardReverseMedium-jump_table	;E
	dc.w	Opcode_CopyBackwardReverseLong-jump_table	;F
Opcode_CopyLiteral	;Opcodes 0-1, copy (low 5 bits)+1 bytes from the data
	move.b	-1(a0),d0
	andi.w	#$1F,d0
.loop
	move.b	(a0)+,0(a1,d1.w)
	addq.b	#1,d1
	bne.w	.next
	bsr.w	FlushOutputBuffer
.next
	dbf	d0,.loop
	rts
Opcode_ClearBytes	;Opcode 2, write (low 4 bits)+1 zero bytes
	move.b	-1(a0),d0
	andi.w	#$F,d0
.loop
	clr.b	0(a1,d1.w)
	addq.b	#1,d1
	bne.w	.next
	bsr.w	FlushOutputBuffer
.next
	dbf	d0,.loop
	rts
Opcode_Fillbytes	;Opcode 3, write the next data byte (low 4 bits)+3 times
	move.b	-1(a0),d0
	andi.w	#$F,d0
	addq.w	#2,d0
	move.b	(a0)+,d2
.loop
	move.b	d2,0(a1,d1.w)
	addq.b	#1,d1
	bne.w	.next
	bsr.w	FlushOutputBuffer
.next
	dbf	d0,.loop
	rts
Opcode_CopyBackwardShort	;Opcodes 4-7, copy from back in the output buffer
	move.b	-1(a0),d0
	andi.w	#7,d0
	addq.w	#1,d0
	move.b	-1(a0),d2
	lsr.w	#3,d2
	andi.w	#7,d2
	addq.w	#1,d2
CopyBackwardRun	;Shared copy loop, d0 = count-1, d2 = distance back
	neg.b	d2
	add.b	d1,d2
.loop
	move.b	0(a1,d2.w),0(a1,d1.w)
	addq.b	#1,d2
	addq.b	#1,d1
	bne.w	.next
	bsr.w	FlushOutputBuffer
.next
	dbf	d0,.loop
	rts
Opcode_CopyBackwardMedium	;Opcode 8
	move.b	-1(a0),d0
	andi.w	#$F,d0
	addq.w	#2,d0
	move.b	(a0)+,d2
	bra.s	CopyBackwardRun
Opcode_CopyBackwardLong	;Opcode 9
	move.b	(a0),d0
	asl.b	#1,d0
	move.b	-1(a0),d0
	roxl.b	#1,d0
	andi.w	#$1F,d0
	addq.w	#2,d0
	move.b	(a0)+,d2
	andi.w	#$7F,d2
	addq.w	#1,d2
	bra.s	CopyBackwardRun
Opcode_CopyBackwardExtended1	;Opcode A
	move.b	-1(a0),d0
	asl.w	#8,d0
	move.b	(a0),d0
	lsr.w	#6,d0
	andi.w	#$3F,d0
	addq.w	#2,d0
	move.b	(a0)+,d2
	andi.w	#$3F,d2
	addq.w	#1,d2
	bra.s	CopyBackwardRun
Opcode_CopyBackwardExtended2	;Opcode B
	move.b	-1(a0),d0
	asl.w	#8,d0
	move.b	(a0),d0
	lsr.w	#5,d0
	andi.w	#$7F,d0
	addq.w	#2,d0
	move.b	(a0)+,d2
	andi.w	#$1F,d2
	addq.w	#1,d2
	bra.s	CopyBackwardRun
Opcode_CopyBackwardReverseShort	;Opcodes C-D, copy backwards through the source
	move.b	-1(a0),d0
	andi.w	#3,d0
	addq.w	#1,d0
	move.b	-1(a0),d2
	lsr.w	#2,d2
	andi.w	#7,d2
	addq.w	#1,d2
CopyBackwardReverseRun	;Shared reverse copy loop
	neg.b	d2
	add.b	d1,d2
.loop
	move.b	0(a1,d2.w),0(a1,d1.w)
	subq.b	#1,d2
	addq.b	#1,d1
	bne.w	.next
	bsr.w	FlushOutputBuffer
.next
	dbf	d0,.loop
	rts
Opcode_CopyBackwardReverseMedium	;Opcode E. Distance 0 is the end code
	move.b	-1(a0),d0
	andi.w	#$F,d0
	addq.w	#2,d0
	move.b	(a0)+,d2
	bne.s	CopyBackwardReverseRun
	tst.w	d1
	beq.w	.fin
	bsr.w	FlushOutputBuffer
.fin
	addq.w	#4,sp
	movem.l	(sp)+,d0-d3/a0-a2
	rts
Opcode_CopyBackwardReverseLong	;Opcode F
	move.b	(a0),d0
	asl.b	#1,d0
	move.b	-1(a0),d0
	roxl.b	#1,d0
	andi.w	#$1F,d0
	addq.w	#2,d0
	move.b	(a0)+,d2
	andi.w	#$7F,d2
	addq.w	#1,d2
	bra.s	CopyBackwardReverseRun
FlushOutputBuffer	;Write the full ring buffer to vram
	movem.l	d0-d1/a0-a1,-(sp)
	move.w	d1,d0
	bne.w	.size
	move.w	#$100,d0
.size
	lsr.w	#1,d0
	move.w	d3,d1
	add.w	d0,d3
	add.w	d0,d3
	movea.l	a1,a0
	tst.l	(a4)
	beq.w	.dma
	movea.l	(a4),a1
	jsr	(a5)
	bra.w	.done
.dma
	jsr	(a6)
.done
	movem.l	(sp)+,d0-d1/a0-a1
	rts

AddSmallFont	;Jumped to from ReAddSmallFont. 95 loads the map at the address in smallfontptr
	move.w	d4,(smallfontchars).w
	movea.l	(smallfontptr).w,a2
	addq.w	#8,a2
	bra.w	DecompressGraphicsPlain

DecompressGraphicsWithCallback	;DecompressGraphics, then return 8 bytes past the call (callback data)
	move.l	(sp),(callbackPtr).w
	bsr.w	DecompressGraphics
	addq.l	#8,(sp)
	rts

; use print x/y/m to set vram address
Framer	;Draw a d0 x d1 frame at printx / printy from the framer map. 95 takes the map from framermapptr
	movem.l	d0-d4/a0-a1,-(sp)
	move.w	(disflags).w,-(sp)
	bset	#dfng,(disflags).w
	movem.w	d0-d1,-(sp)
	move.w	(printa).w,d2
	add.w	(framercset).w,d2
	movea.l	(framermapptr).w,a1
	adda.l	4(a1),a1
	addq.w	#4,a1
	clr.w	d4
	bsr.w	.tbline
	subq.w	#3,2(sp)
.mtop
	bsr.w	.tbline
	subq.w	#6,d4
	subq.w	#1,2(sp)
	bpl.s	.mtop
	addq.w	#6,d4
	bsr.w	.tbline
	addq.w	#4,sp
	move.w	(sp)+,(disflags).w
	movem.l	(sp)+,d0-d4/a0-a1
	rts
.tbline
	bsr.w	xyVmMap
	addq.w	#1,(printy).w
	bsr.w	.setter
	addq.w	#2,d4
	move.w	4(sp),d0
	subq.w	#3,d0
.tblp
	bsr.w	.setter
	dbf	d0,.tblp
	addq.w	#2,d4
	bsr.w	.setter
	addq.w	#2,d4
	rts
.setter
	move.w	(a1,d4.w),d3
	add.w	d2,d3
	move.w	d3,(a0)
	rts

AddFramer	;Jumped to from ReAddFramer. Load the framer tiles at char d4 through DecompressGraphicsWithCallback with the remap table
	;after the jsr (colour 7 to 1); 95 also stores the map address in framermapptr
	movea.l	#Framermap+8,a2
	move.w	d4,(framercset).w
	move.l	#Framermap,(framermapptr).l
	jsr	(DecompressGraphicsWithCallback).l
	dc.b	$01,$23,$45,$61,$89,$AB,$CD,$EF	;remap table: colour n to n, except 7 to 1
	rts

AddFramer2	;AddFramer for the second framer map, no remap
	movea.l	#Framermap2+8,a2
	move.l	#Framermap2,(framermapptr).l
	move.w	d4,(framercset).w
	jsr	(DecompressGraphicsPlain).l
	rts

VBjsr	;Vertical blank interrupt (vector $78), jumps through the vbint RAM vector
	move.l	(vbint).w,-(sp)	;push handler address
	rts	;and "return" into it

VBlank	;Main vblank code for game play (vbint target). DumpSprites when dfok is set
	;cramfade, then the game clock. gmode2 bit 2 keeps the clock running after the whistle, and with gmode2 bit 1 (penalty shot /
	;shootout) shootoutclock counts down instead (shootoutjiffy jiffies, not while gmode2 bit 7 is set)
	movem.l	d0-d7/a0-a6,-(sp)
	btst	#dfng,(disflags).w	;dfng: don't touch the vdp
	bne.w	.nograph
	bclr	#dfok,(disflags).w
	beq.w	.01
	bsr.w	DumpSprites
.01
	bsr.w	cramfade
.nograph
	btst	#sfpz,(sflags).w
	bne.w	.c
	btst	#2,(gmode2).w
	bne.w	.0
	btst	#0,(gmode).w	;gmclock: game clock stopped
	bne.w	.c
.0
	btst	#1,(gmode2).w	;penalty shot / shootout clock
	bne.w	.soclock
	tst.w	(gameclock).w
	beq.w	.c
	subi.w	#$AAA,(gameclock+2).w	;jiffy
	bcc.w	.c
	bset	#dfclock,(disflags).w
	subq.w	#1,(gameclock).w
	cmpi.w	#$3D,(gameclock).w	;61
	bgt.w	.c
	cmpi.w	#$3C,(gameclock).w	;60
	blt.w	.c
	move.w	#SFXbeep2,-(sp)	;SFXbeep2, played when gameclock reaches 60
	jsr	(sfx).l	;jsr (94: bsr.w)
.c
	addq.w	#1,(vcount).w
	jsr	(p_music_vblank).l
	movem.l	(sp)+,d0-d7/a0-a6
	rte
.soclock
	tst.w	(shootoutclock).w
	beq.s	.c
	subi.w	#$AAA,(shootoutjiffy).w
	bcc.s	.c
	bset	#dfclock,(disflags).w
	btst	#7,(gmode2).w
	bne.s	.c
	subq.w	#1,(shootoutclock).w
	bra.s	.c

p_music_vblank	;Read the pads, then SoundCmd 1: the 95 sound driver's vblank update. Called from the
	;vblank handlers
	bsr.w	ReadJoyData
	move.w	#1,d0
	jsr	(SoundCmd).l
	rts

vb2	;Vblank used for palfades only, no dmas (vbint target). No rte here: falls into IRQ7
	movem.l	d0-d7/a0-a6,-(sp)
	btst	#dfng,(disflags).w
	bne.w	.nograph
	bsr.w	cramfade
.nograph
	addq.w	#1,(vcount).w
	jsr	(p_music_vblank).l
	movem.l	(sp)+,d0-d7/a0-a6
IRQ7	;Rte only. vb2 falls in; the vector table ($60, $64, ...) points here
	rte

VBlank_SetOptions	;vbint handler stored by the menus: cramfade unless dfng, plus
	;DumpSprites2 when dfok is set
	movem.l	d0-d7/a0-a6,-(sp)
	btst	#dfng,(disflags).w
	bne.w	.nograph
	bclr	#dfok,(disflags).w
	beq.w	.fade
	bsr.w	DumpSprites2
.fade
	bsr.w	cramfade
.nograph
	addq.w	#1,(vcount).w
	jsr	(p_music_vblank).l
	movem.l	(sp)+,d0-d7/a0-a6
	rte

; return d1 = new button presses
orjoy	;Pads 1 and 2 (95: no four way case here, see orjoy4way)
	bsr.w	ReadJoy1
	move.w	d1,-(sp)
	bsr.w	ReadJoy2
	or.w	(sp)+,d1
	rts

orjoy4way	;orjoy for pads 1-4 (3 and 4 with FourWayPlay), d1 new presses and d3 held buttons of all pads.
	;Jumped to from ReadMenuJoy
	bsr.w	ReadJoy1
	move.w	d1,-(sp)
	move.w	d3,-(sp)
	bsr.w	ReadJoy2
	or.w	(sp)+,d3
	or.w	(sp)+,d1
	tst.w	(FourWayPlay).w
	beq.w	.x
	move.w	d1,-(sp)
	move.w	d3,-(sp)
	bsr.w	ReadJoy3
	or.w	(sp)+,d3
	or.w	(sp)+,d1
	move.w	d1,-(sp)
	move.w	d3,-(sp)
	bsr.w	ReadJoy4
	or.w	(sp)+,d3
	or.w	(sp)+,d1
.x
	rts

; eliminate diagonal direction presses on d0
nodiag
	movem.l	d0/d4-d5,-(sp)
	moveq	#3,d4
	move.w	d3,d0
	andi.w	#$F,d0
	beq.w	.ok
.0
	clr.w	d5
	bset	d4,d5
	cmp.w	d5,d0
	dbeq	d4,.0
	beq.w	.ok
	andi.w	#$FFF0,d1
.ok
	movem.l	(sp)+,d0/d4-d5
	rts

; Read controller 1
; return d0 = direction (bit 0-3) and new button (bit 4-7) presses
; d1 = new presses (all 8 bits)
; d2 = changed buttons (all 8)
; d3 = current held buttons (all 8)
ReadJoy1
	move.b	(pad4way1).w,d0
	bsr.w	ReadJoy
	move.w	(lj1).w,d2
	move.w	d1,(lj1).w
	move.w	d1,d3
	eor.w	d1,d2
	and.w	d2,d1
	rts
; Read controller 2
ReadJoy2
	move.b	(pad4way2).w,d0
	bsr.w	ReadJoy
	move.w	(lj2).w,d2
	move.w	d1,(lj2).w
	move.w	d1,d3
	eor.w	d1,d2
	and.w	d2,d1
	rts
ReadJoy3	;Nothing pressed (NoJoy) without FourWayPlay
	tst.w	(FourWayPlay).w
	beq.w	NoJoy
	move.b	(pad4way3).w,d0
	bsr.w	ReadJoy
	move.w	(lj3).w,d2
	move.w	d1,(lj3).w
	move.w	d1,d3
	eor.w	d1,d2
	and.w	d2,d1
	rts
NoJoy	;No buttons, direction 8 (none)
	clr.w	d1
	clr.w	d2
	clr.w	d3
	move.w	#8,d0
	rts
ReadJoy4	;NoJoy without FourWayPlay
	tst.w	(FourWayPlay).w
	beq.s	NoJoy
	move.b	(pad4way4).w,d0
	bsr.w	ReadJoy
	move.w	(lj4).w,d2
	move.w	d1,(lj4).w
	move.w	d1,d3
	eor.w	d1,d2
	and.w	d2,d1
	rts
ReadJoy	;d0 = pad byte: buttons to the high nibble, direction 0-8 (jdtab) in the low nibble, d1 = the buttons
	not.b	d0
	clr.w	d1
	move.b	d0,d1
	move.w	d1,-(sp)
	andi.w	#$F0,d0
	andi.w	#$F,d1
	movea.l	#jdtab,a0
	move.b	(a0,d1.w),d1
	or.w	d1,d0
	move.w	(sp)+,d1
	rts
jdtab	dc.b	8
	;convert button l,r,d,u into directions 0-7,8
	dc.b	0,4,8,6,7,5,8,2,1,3,8,8,8,8,8

ReadJoyData	;Read the pads every vblank. With FourWayPlay, pads 1-4 through the 4 way adaptor
	;(ReadPad4Way1 ... ReadPad4Way4) to pad4way1-pad4way4, else pads 1 and 2 (ReadPad1, ReadPad2)
	movem.l	d1/a0,-(sp)
	tst.w	(FourWayPlay).w
	beq.w	.0
	bsr.s	ReadPad4Way1
	move.b	d0,(pad4way1).w
	bsr.s	ReadPad4Way2
	move.b	d0,(pad4way2).w
	bsr.w	ReadPad4Way3
	move.b	d0,(pad4way3).w
	bsr.w	ReadPad4Way4
	move.b	d0,(pad4way4).w
	bra.w	.x
.0
	bsr.w	ReadPad1
	move.b	d0,(pad4way1).w
	bsr.w	ReadPad2
	move.b	d0,(pad4way2).w
.x
	movem.l	(sp)+,d1/a0
	rts
ReadPad4Way1	;4 way play pad 1: pause the sound driver (SoundCmd $D; 94 took the Z80 bus), select pad 1 on port 2 and read it on port 1
	move.w	d0,-(sp)
	move.w	#$D,d0
	jsr	(SoundCmd).l
	move.w	(sp)+,d0
	move.b	#$C,(IO_CT2_DATA+1).l
	bra.w	ReadPad4WayPort1
ReadPad4Way2	;4 way play pad 2, as ReadPad4Way1
	move.w	d0,-(sp)
	move.w	#$D,d0
	jsr	(SoundCmd).l
	move.w	(sp)+,d0
	move.b	#$1C,(IO_CT2_DATA+1).l
	bra.w	ReadPad4WayPort1
ReadPad4Way3	;4 way play pad 3, as ReadPad4Way1
	move.w	d0,-(sp)
	move.w	#$D,d0
	jsr	(SoundCmd).l
	move.w	(sp)+,d0
	move.b	#$2C,(IO_CT2_DATA+1).l
	bra.w	ReadPad4WayPort1
ReadPad4Way4	;4 way play pad 4, as ReadPad4Way1. Falls into ReadPad4WayPort1
	move.w	d0,-(sp)
	move.w	#$D,d0
	jsr	(SoundCmd).l
	move.w	(sp)+,d0
	move.b	#$3C,(IO_CT2_DATA+1).l
ReadPad4WayPort1	;Read the pad on port 1; branched to from ReadPad4Way1 ... ReadPad4Way4
	movem.l	d1/a0,-(sp)
	lea	(IO_CT1_DATA+1).l,a0
	bra.w	ReadPad3Button
ReadPad2	;Read pad 2 (port 2). Falls into ReadPadA0
	movem.l	d1/a0,-(sp)
	lea	(IO_CT2_DATA+1).l,a0
	bra.s	ReadPadA0
ReadPad1	;Read pad 1 (port 1)
	movem.l	d1/a0,-(sp)
	lea	(IO_CT1_DATA+1).l,a0
ReadPadA0	;Pause the sound driver (SoundCmd $D; 94 took the Z80 bus), then ReadPad3Button
	move.w	d0,-(sp)
	move.w	#$D,d0
	jsr	(SoundCmd).l
	move.w	(sp)+,d0
ReadPad3Button	;Read a 3 button pad at a0 (TH low, then high), resume the sound driver (SoundCmd $E) and return d0 = the buttons, the directions
	;through PadDirTable
	moveq	#0,d0
	move.b	#0,(a0)
	nop
	nop
	move.b	(a0),d0
	move.b	#$40,(a0)
	nop
	nop
	move.b	(a0),d1
	move.w	d0,-(sp)	;resume the sound driver where 94 released the Z80 bus
	move.w	#$E,d0
	jsr	(SoundCmd).l
	move.w	(sp)+,d0
	asl.b	#2,d0
	andi.b	#$C0,d0
	andi.b	#$3F,d1
	or.b	d1,d0
	not.b	d0
	not.b	d1
	andi.w	#$F,d1
	lea	PadDirTable(pc),a0
	andi.b	#$F0,d0
	or.b	0(a0,d1.w),d0
	not.b	d0
	movem.l	(sp)+,d1/a0
	rts
PadDirTable	;Direction nibble table for ReadPad3Button: remaps the nibble when opposite directions are pressed together
	dc.b	0,1,2,1,4,5,6,6,8,9,$A,$A,8,9,$A,0
ResetZ80Bus	;Reset the Z80 and wait for its bus. No caller in 95
	move.w	#$100,(IO_Z80RES).l
	move.w	#$100,(IO_Z80BUS).l
.loop
	btst	#0,(IO_Z80BUS).l
	bne.s	.loop
	rts

ReadMenuJoy	;Read the menu pad: with sflags12 bit 0 clear, pad menupadnum (ReadJoy1-4). Else, with no pad on a team
	;all pads; otherwise the first pad on a team that has buttons down becomes menupadnum
	btst	#0,(sflags12).w
	bne.w	.any
	tst.w	(menupadnum).w
	beq.w	ReadJoy1
	cmpi.w	#1,(menupadnum).w
	beq.w	ReadJoy2
	cmpi.w	#2,(menupadnum).w
	beq.w	ReadJoy3
	bra.w	ReadJoy4
.any
	move.w	(cont1team).w,d0
	or.w	(cont2team).w,d0
	or.w	(cont3team).w,d0
	or.w	(cont4team).w,d0
	beq.w	.all
	clr.w	(menupadnum).w
	tst.w	(cont1team).w
	beq.w	.2
	bsr.w	ReadJoy1
	tst.b	d3
	bne.w	.x
	tst.b	d1
	bne.w	.x
.2
	tst.w	(cont2team).w
	beq.w	.3
	move.w	#1,(menupadnum).w
	bsr.w	ReadJoy2
	tst.b	d3
	bne.w	.x
	tst.b	d1
	bne.w	.x
.3
	tst.w	(FourWayPlay).w
	beq.w	.x
	tst.w	(cont3team).w
	beq.w	.4
	move.w	#2,(menupadnum).w
	bsr.w	ReadJoy3
	tst.b	d3
	bne.w	.x
	tst.b	d1
	bne.w	.x
.4
	tst.w	(cont4team).w
	beq.w	.x
	move.w	#3,(menupadnum).w
	bsr.w	ReadJoy4
.x
	rts
.all
	jmp	(orjoy4way).l

;------------------------------------------------------------------------------------------------------------------------
;	Key repeat on the pad input.

ProcessInputWithRepeat	;nodiag, then key repeat on d1-d3. 95: first repeat after $19 frames, then every 4 (every $14 with sflags12
	;bit 0)
	bsr.w	nodiag
	tst.w	d3
	beq.w	.2
	tst.w	d2
	bne.w	.1
	subq.w	#1,(repeatdelayframes).w
	bpl.w	.2
	move.w	#4,(repeatdelayframes).w
	btst	#0,(sflags12).w
	beq.w	.0
	move.w	#$14,(repeatdelayframes).w
.0
	move.w	d3,d1
	rts
.1
	move.w	#$19,(repeatdelayframes).w
.2
	rts

WaitVSyncAndReadInput	;Wait for the next vblank, read the menu pad (ReadMenuJoy, nodiag) until a new button press
	move.w	(vcount).w,d1
.wait
	cmp.w	(vcount).w,d1
	beq.s	.wait
	bsr.w	ReadMenuJoy
	bsr.w	nodiag
	tst.b	d1
	beq.s	WaitVSyncAndReadInput
	rts
