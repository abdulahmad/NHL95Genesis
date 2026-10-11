; $07DFAC  Adapted from fourway94.asm: four-player adaptor
;	The 95 AnyPadAssigned, then Detect4WayPlay and the unused Read4WayPad1-4, which 95 reads through its own
;	Read4WayPort1 / Read4WayPort2 (the 94 Set4WayPlayerStub / Set4WayPlayer are gone). z80old95 (the 94 Z80 program) follows at
;	$7E0E0.
;	written as instructions: Read4WayPad1 ... ReadJoyJmp ($7E02E-$7E0DF).
;	EA's compiler emits cmp #imm,Dn as CMP (Bxxx), SNASM emits CMPI (0Cxx). The source has the real cmp; fixopcodes.js patches the
;	cmp encoding after assembly.

AnyPadAssigned	;Z clear when any pad is on a team (cont1team ... cont4team).
	movem.w	d0,-(sp)
	move.w	(cont1team).w,d0
	or.w	(cont2team).w,d0
	or.w	(cont3team).w,d0
	or.w	(cont4team).w,d0
	movem.w	(sp)+,d0
	rts

Detect4WayPlay	;detect the 4 way play adaptor (EA 4 Way Play) on port 2: FourWayPlay = 1 when found. Called from Begin (main95)
	move.w	#0,(IO_Z80RES).l
	move.b	#$40,(IO_CT1_CTRL+1).l
	move.b	#$43,(IO_CT2_CTRL+1).l
	nop
	move.b	#$7C,(IO_CT2_DATA+1).l
	nop
	move.b	#$7F,(IO_CT2_CTRL+1).l
	nop
	move.b	#$7C,(IO_CT2_DATA+1).l
	nop
	move.b	(IO_CT1_DATA+1).l,d0
	andi.b	#3,d0
	cmp.b	#0,d0
	bne.s	.none
	move.w	#1,(FourWayPlay).w
	bra.s	.x
.none
	move.w	#0,(FourWayPlay).w
	move.b	#$40,(IO_CT2_CTRL+1).l
.x
	move.w	#$100,(IO_Z80RES).l
	rts

Read4WayPad1	;No xref. unused: read 4 way play pad 1 (95: Read4WayPort1 with the pad word swapped in)
	move.b	#0,(IO_CT2_DATA+1).l	;4 way play: select pad
	move.w	(pad4waysave1).w,(pad4wayword).w
	jsr	(Read4WayPort1).l
	move.w	(pad4wayword).w,(pad4waysave1).w
	rts
Read4WayPad2	;No xref. unused: the same for pad 2
	move.b	#$10,(IO_CT2_DATA+1).l	;4 way play: select pad
	move.w	(pad4waysave2).w,(pad4wayword).w
	jsr	(Read4WayPort1).l
	move.w	(pad4wayword).w,(pad4waysave2).w
	rts
Read4WayPad3	;No xref. unused: the same for pad 3
	move.b	#$20,(IO_CT2_DATA+1).l	;4 way play: select pad
	move.w	(pad4waysave3).w,(pad4wayword).w
	jsr	(Read4WayPort1).l
	move.w	(pad4wayword).w,(pad4waysave3).w
	rts
Read4WayPad4	;No xref. unused: the same for pad 4
	move.b	#$30,(IO_CT2_DATA+1).l	;4 way play: select pad
	move.w	(pad4waysave4).w,(pad4wayword).w
	jsr	(Read4WayPort1).l
	move.w	(pad4wayword).w,(pad4waysave4).w
	rts
Read4WayPort1	;ReadJoy1 for the pad on port 1 (a0 = its data port): d1 = new presses against pad4wayword
	move.l	a0,-(sp)
	movea.l	#IO_CT1_DATA+1,a0
	bsr.w	ReadJoyJmp
	movea.l	(sp)+,a0
	move.w	(pad4wayword).w,d2
	move.w	d1,(pad4wayword).w
	move.w	d1,d3
	eor.w	d1,d2
	and.w	d2,d1
	rts
Read4WayPort2	;No xref. The same for port 2, against pad4wayword2
	move.l	a0,-(sp)
	movea.l	#IO_CT2_DATA+1,a0
	bsr.w	ReadJoyJmp
	movea.l	(sp)+,a0
	move.w	(pad4wayword2).w,d2
	move.w	d1,(pad4wayword2).w
	move.w	d1,d3
	eor.w	d1,d2
	and.w	d2,d1
	rts
ReadJoyJmp	;jmp ReadJoy
	jmp	(ReadJoy).l
