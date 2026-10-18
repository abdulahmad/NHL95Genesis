;	New in 95: the sound driver. It takes commands from the game, plays up to eight songs and
;	keeps the Z80 fed with notes and samples. The Z80 program, the sound bank and the old unused
;	driver follow it.

	opt	oaq-,osq-,oz-				;the driver writes addi / subi #1-8 and 0(An) (SNASM would make them addq
									;/ subq and (An))

SndDriver							;95 sound driver entry (SoundCmd, below). d0 = command 0-$F, branch to its
									;handler; carry set and d0 = 1 for a bad command. 0 SndLoadZ80, 1
									;SndUpdate, 2 off, 3 on, 4 SndStartSeq, 5 SndStopSeq, 6 SndSetBank, 7
									;SndLoadList, 8 SndFreeBlocks, 9 SndResetBlocks, $A SndSendZ80, $B
									;SndReadBlock, $C SndWriteBlock, $D SndPauseZ80, $E SndResumeZ80, $F
									;SndStopAll
	tst.w	d0
	bne.s	.0
	bra.w	SndLoadZ80
.0
	subi.w	#1,d0
	bne.s	.1
	bra.w	SndUpdate
.1
	subi.w	#1,d0
	bne.s	.2
	move.l	a0,-(sp)
	lea	(SndDrvRAM).l,a0
	clr.w	(a0)
	movea.l	(sp)+,a0
	clr.w	d0
	rts
.2
	subi.w	#1,d0
	bne.s	.3
	move.l	a0,-(sp)
	lea	(SndDrvRAM).l,a0
	move.w	#$1234,(a0)
	movea.l	(sp)+,a0
	clr.w	d0
	rts
.3
	subi.w	#1,d0
	bne.s	.4
	bra.w	SndStartSeq
.4
	subi.w	#1,d0
	bne.s	.5
	bra.w	SndStopSeq
.5
	subi.w	#1,d0
	bne.s	.6
	bra.w	SndSetBank
.6
	subi.w	#1,d0
	bne.s	.7
	bra.w	SndLoadList
.7
	subi.w	#1,d0
	bne.s	.8
	bra.w	SndFreeBlocks
.8
	subi.w	#1,d0
	bne.s	.9
	bra.w	SndResetBlocks
.9
	subi.w	#1,d0
	bne.s	.10
	bra.w	SndSendZ80
.10
	subi.w	#1,d0
	bne.s	.11
	bra.w	SndReadBlock
.11
	subi.w	#1,d0
	bne.s	.12
	bra.w	SndWriteBlock
.12
	subi.w	#1,d0
	bne.s	.13
	bra.w	SndPauseZ80
.13
	subi.w	#1,d0
	bne.s	.14
	bra.w	SndResumeZ80
.14
	subi.w	#1,d0
	bne.s	.15
	bra.w	SndStopAll
.15
	move.w	#1,d0
	ori	#1,ccr
	rts

SndLoadZ80							;Command 0: copy the Z80 program a0 (d1 bytes; it must start with JP
									;$00xx) to Z80 RAM, reset the Z80, wait
									;for it to set Z80_RAM+$4F, clear the song slots and notes, and turn the
									;driver on. Carry set and d0 = 6 for a bad program
	movem.l	d1/a0-a2,-(sp)
	move	sr,-(sp)
	move	#$2700,sr
	move.w	#$100,(IO_Z80BUS).l
	move.w	#$100,(IO_Z80RES).l
	cmpi.b	#$C3,(a0)
	bne.s	.bad
	cmpi.b	#0,1(a0)
	bne.s	.bad
	lea	(Z80_RAM).l,a1
	subi.w	#1,d1
.copy
	move.b	(a0)+,(a1)+
	dbf	d1,.copy
	bra.s	.reset
.bad
	move.w	#6,d0
	bra.w	.err
.reset
	move.w	#0,(IO_Z80RES).l
	move.w	#0,(IO_Z80BUS).l
	move.w	#$1F4,d0
.delay
	dbf	d0,.delay
	move.w	#$100,(IO_Z80RES).l
.waitz80
	bsr.w	Z80BusRequest
	cmpi.b	#$FF,(Z80_RAM+$4F).l
	beq.s	.ready
	bsr.w	Z80BusRelease
	move.w	#$1388,d0
.pause
	dbf	d0,.pause
	bra.s	.waitz80
.ready
	bsr.w	Z80BusRelease
	lea	(SndBanks).l,a0
	move.w	#3,d0
.clrbanks
	move.l	#$FFFFFFFF,(a0)+
	dbf	d0,.clrbanks
	lea	(SndSeqPtr).l,a0
	move.w	#7,d0
.clrptr
	move.l	#$FFFFFFFF,(a0)+
	dbf	d0,.clrptr
	lea	(SndSeqPos).l,a0
	move.w	#7,d0
.clrpos
	move.l	#0,(a0)+
	dbf	d0,.clrpos
	lea	(SndSeqId).l,a0
	move.w	#7,d0
.clrid
	move.w	#$FFFF,(a0)+
	dbf	d0,.clrid
	lea	(SndSeqState).l,a0
	move.w	#7,d0
.clrstate
	move.l	#0,(a0)+
	dbf	d0,.clrstate
	bsr.w	SndClearNotes
	lea	(SndDrvRAM).l,a0
	move.w	#$1234,(a0)
	andi	#$FE,ccr
	clr.w	d0
	bra.s	.done
.err
	ori	#1,ccr
.done
	move	(sp)+,sr
	movem.l	(sp)+,d1/a0-a2
	rts

SndUpdate							;Command 1, once a frame: note timers (SndUpdateNotes), sample streaming
									;(SndStreamZ80), then step the 8 song
									;slots: wait out each slot's delay, then send its events ($9x note on, $Bx
									;controller, $Cx program, $Ex pitch bend) to the Z80 until the next delay.
									;Controller $75 loops the song; status $FF ends it
	movem.l	d0-d7/a0-a6,-(sp)
	lea	(SndDrvRAM).l,a0
	cmpi.w	#$1234,(a0)
	bne.w	.off
	bsr.w	SndUpdateNotes
	bsr.w	SndStreamZ80
	lea	(SndSeqIndex).l,a0
	move.w	#0,(a0)
	lea	(SndSeqPtr).l,a6
	lea	(SndSeqPos).l,a5
	lea	(SndSeqWait).l,a4
	lea	(SndSeqTempo).l,a3
	lea	(SndSeqFrac).l,a2
	lea	(SndSeqState).l,a1
.slot
	move.w	(SndSeqIndex).l,d6
	lsl.w	#1,d6
	move.w	d6,d7
	lsl.w	#1,d7
	cmpi.l	#$FFFFFFFF,(a6,d7.w)
	beq.w	.nextslot
	tst.w	(a4,d6.w)
	beq.s	.events
	move.w	(a3,d6.w),d1
	add.w	(a2,d6.w),d1
	move.w	d1,d2
	andi.w	#$FF,d2
	lsr.w	#8,d1
	add.w	(a1,d7.w),d1
	move.w	#0,(a1,d7.w)
	cmp.w	(a4,d6.w),d1
	bge.s	.due
	move.w	(a4,d6.w),d3
	sub.w	d1,d3
	move.w	d3,(a4,d6.w)
	move.w	d2,(a2,d6.w)
	bra.w	.nextslot
.due
	sub.w	(a4,d6.w),d1
	lsl.w	#8,d1
	or.w	d2,d1
	move.w	d1,(a2,d6.w)
	clr.w	(a4,d6.w)
.events
	movea.l	(a6,d7.w),a0
	move.l	(a5,d7.w),d5
.skipdelay
	tst.b	(a0,d5.l)
	bpl.s	.event
	addi.l	#1,d5
	bra.s	.skipdelay
.event
	addi.l	#1,d5
	tst.b	(a0,d5.l)
	bpl.s	.running
	move.b	(a0,d5.l),2(a1,d7.w)
	addi.l	#1,d5
.running
	move.b	2(a1,d7.w),d0
	andi.b	#$F0,d0
	cmpi.b	#$90,d0
	bne.w	.ctrl
	move.w	(SndSeqIndex).l,d0
	lsl.w	#8,d0
	lsl.w	#4,d0
	move.b	1(a0,d5.l),d0
	swap	d0
	move.b	(a0,d5.l),d0
	lsl.w	#8,d0
	move.b	2(a1,d7.w),d0
	bsr.w	SndPutZ80Cmd
	tst.w	d0
	beq.s	.notelen
	addi.w	#1,(a1,d7.w)
	bra.w	.nextslot
.notelen
	clr.l	d0
	move.b	2(a0,d5.l),d0
	bpl.s	.len
	andi.l	#$7F,d0
	lsl.l	#7,d0
	or.b	3(a0,d5.l),d0
.len
	lsl.l	#8,d0
	move.w	(a3,d6.w),d3
	divu.w	d3,d0
	swap	d0
	move.b	(a0,d5.l),d0
	lsl.w	#8,d0
	move.w	(SndSeqIndex).l,d1
	lsl.w	#4,d1
	move.b	2(a1,d7.w),d0
	andi.b	#$F,d0
	or.b	d1,d0
	bsr.w	SndAddNote
	addi.l	#2,d5
.skiplen
	tst.b	(a0,d5.l)
	bpl.s	.9
	addi.l	#1,d5
	bra.s	.skiplen
.9
	addi.l	#1,d5
	bra.w	.delay
.ctrl
	cmpi.b	#$B0,d0
	bne.w	.prog
	cmpi.b	#$12,(a0,d5.l)
	bne.s	.chkloop
	bra.s	.sendctrl
.chkloop
	cmpi.b	#$75,(a0,d5.l)
	bne.s	.sendctrl
	clr.l	d0
	move.b	1(a0,d5.l),d0
	lsl.l	#1,d0
	addi.l	#2,d0
	movea.l	(a6,d7.w),a0
	clr.l	d1
	move.b	(a0,d0.l),d1
	lsl.l	#8,d1
	move.b	1(a0,d0.l),d1
	clr.l	d0
	move.b	(a0),d0
	lsl.l	#8,d0
	move.b	1(a0),d0
	lsl.l	#1,d0
	addi.l	#2,d0
	add.l	d0,d1
	move.l	d1,d5
	move.l	d5,(a5,d7.w)
	bra.w	.slot
.sendctrl
	move.w	(SndSeqIndex).l,d0
	lsl.w	#8,d0
	lsl.w	#4,d0
	move.b	1(a0,d5.l),d0
	swap	d0
	move.b	(a0,d5.l),d0
	lsl.w	#8,d0
	move.b	2(a1,d7.w),d0
	bsr.w	SndPutZ80Cmd
	tst.w	d0
	beq.s	.13
	addi.w	#1,(a1,d7.w)
	bra.w	.nextslot
.13
	addi.l	#2,d5
	bra.s	.delay
.prog
	cmpi.b	#$C0,d0
	bne.s	.bend
	move.w	(SndSeqIndex).l,d0
	lsl.w	#8,d0
	lsl.w	#4,d0
	swap	d0
	move.b	(a0,d5.l),d0
	lsl.w	#8,d0
	move.b	2(a1,d7.w),d0
	bsr.w	SndPutZ80Cmd
	tst.w	d0
	beq.s	.15
	addi.w	#1,(a1,d7.w)
	bra.s	.nextslot
.15
	addi.l	#1,d5
	bra.s	.delay
.bend
	cmpi.b	#$E0,d0
	bne.s	.chkend
	move.w	(SndSeqIndex).l,d0
	lsl.w	#8,d0
	lsl.w	#4,d0
	swap	d0
	move.b	(a0,d5.l),d0
	lsl.w	#8,d0
	move.b	2(a1,d7.w),d0
	bsr.w	SndPutZ80Cmd
	tst.w	d0
	beq.s	.17
	addi.w	#1,(a1,d7.w)
	bra.s	.nextslot
.17
	addi.l	#1,d5
	bra.s	.delay
.chkend
	cmpi.b	#$FF,2(a1,d7.w)
	bne.s	.delay
	move.l	#$FFFFFFFF,(a6,d7.w)
	bra.s	.nextslot
.delay
	move.l	d5,(a5,d7.w)
	clr.w	d2
	move.b	(a0,d5.l),d2
	bpl.s	.setdelay
	andi.b	#$7F,d2
	lsl.w	#7,d2
	or.b	1(a0,d5.l),d2
.setdelay
	move.w	d2,(a4,d6.w)
	tst.w	d2
	bne.s	.nextslot
	bra.w	.slot
.nextslot
	lea	(SndSeqIndex).l,a0
	addi.w	#1,(a0)
	cmpi.w	#8,(a0)
	blt.w	.slot
.off
	andi	#$FE,ccr
	movem.l	(sp)+,d0-d7/a0-a6
	rts

SndStartSeq							;Command 4: play song d1 (bank item type 3) in the first free slot, with
									;d2-d4 (d4 = tempo). Carry set for no
									;free slot (d0 = 7) or no such song
	movem.l	d1-d4/a0-a1,-(sp)
	lea	(SndDrvRAM).l,a0
	move.w	d1,SndSeqArg1-SndDrvRAM(a0)
	move.w	d2,$134(a0)
	move.w	d3,$136(a0)
	move.w	d4,$138(a0)
	lea	(SndSeqPtr).l,a1
	clr.w	d0
.find
	cmpi.l	#$FFFFFFFF,(a1)+
	beq.s	.free
	addi.w	#1,d0
	cmpi	#8,d0					;retail CMPI (0C40). No .w, so fixopcodes.js leaves it
	bne.s	.find
	move.w	#7,d0
	bra.s	.err
.free
	move.w	d0,$130(a0)
	lsl.w	#8,d0
	lsl.w	#4,d0
	swap	d0
	move.w	#$1FF,d0
	bsr.w	SndPutZ80Cmd
	move.w	#3,d0
	bsr.w	SndFindBankItem
	bcs.s	.err
	clr.l	d1
	move.b	(a0),d1
	lsl.w	#8,d1
	move.b	1(a0),d1
	lsl.w	#1,d1
	addi.w	#2,d1
	lea	(SndDrvRAM).l,a1
	move.w	0(a1),-(sp)
	move.w	#0,0(a1)
	move.w	$130(a1),d0
	lsl.w	#2,d0
	move.l	a0,2(a1,d0.w)
	move.l	d1,$22(a1,d0.w)
	lea	(SndSeqState).l,a0
	move.l	#0,(a0,d0.w)
	move.w	$130(a1),d0
	lsl.w	#1,d0
	move.w	$138(a1),$62(a1,d0.w)
	move.w	#0,$52(a1,d0.w)
	move.w	#0,$72(a1,d0.w)
	move.w	$132(a1),$42(a1,d0.w)
	move.w	(sp)+,0(a1)
	clr.w	d0
	bra.s	.done
.err
	ori	#1,ccr
.done
	movem.l	(sp)+,d1-d4/a0-a1
	rts

SndStopSeq							;Command 5: stop the slot playing song id d1 and release its notes. Carry
									;set and d0 = 3 when none plays it
	movem.l	d1-d2/a0,-(sp)
	lea	(SndSeqId).l,a0
	clr.w	d0
.find
	cmp.w	(a0)+,d1
	beq.s	.found
	addi.w	#1,d0
	cmpi	#8,d0					;retail CMPI (0C40). No .w, so fixopcodes.js leaves it
	bne.s	.find
	move.w	#3,d0
	ori	#1,ccr
	bra.s	.done
.found
	lea	(SndDrvRAM).l,a0
	move.w	d0,SndStopSlot-SndDrvRAM(a0)
	lsl.w	#1,d0
	lea	(SndSeqId).l,a0
	move.w	#$FFFF,(a0,d0.w)
	lsl.w	#1,d0
	lea	(SndSeqPtr).l,a0
	move.l	#$FFFFFFFF,(a0,d0.w)
	lea	(SndDrvRAM).l,a0
	move.w	SndStopSlot-SndDrvRAM(a0),d0
	bsr.w	SndReleaseNotes
	clr.w	d0
.done
	movem.l	(sp)+,d1-d2/a0
	rts

SndPutZ80Cmd						;Queue the 4 byte Z80 command d0 (Z80_RAM+$D + 4 * count, count at +$C,
									;waits while +$B is busy). d0 = -1 when it is full
	movem.l	d1/a0,-(sp)
	lea	(SndDrvRAM).l,a0
	move.w	0(a0),-(sp)
	move.w	#0,0(a0)
.wait
	bsr.w	Z80BusRequest
	lea	(Z80_RAM+$B).l,a0
	tst.b	(a0)
	beq.s	.free
	move.w	#0,(IO_Z80BUS).l
	move.w	#$64,d1
.delay
	subi.w	#1,d1
	bne.s	.delay
	bra.s	.wait
.free
	adda.l	#1,a0
	cmpi.b	#$10,(a0)
	blt.s	.put
	move.w	#$FFFF,d0
	bra.s	.done
.put
	clr.w	d1
	move.b	(a0),d1
	lsl.w	#2,d1
	move.b	d0,1(a0,d1.w)
	lsr.w	#8,d0
	move.b	d0,2(a0,d1.w)
	swap	d0
	move.b	d0,3(a0,d1.w)
	lsr.w	#8,d0
	move.b	d0,4(a0,d1.w)
	move.b	(a0),d1
	addi.b	#1,d1
	move.b	d1,(a0)
	clr.w	d0
.done
	bsr.w	Z80BusRelease
	lea	(SndDrvRAM).l,a0
	move.w	(sp)+,0(a0)
	movem.l	(sp)+,d1/a0
	rts

SndUploadBlock						;Copy d1 bytes from a0 to free Z80 RAM as block d0 (the 42 six byte
									;entries at Z80_RAM+$100). Carry set: no room
									;(d0 = 4), already there (d0 = 3) or no free entry (d0 = 7)
	movem.l	d1-d2/a0-a1,-(sp)
	lea	(SndDrvRAM).l,a1
	move.w	(a1),-(sp)
	move.w	#0,(a1)
	bsr.w	Z80BusRequest
	move.b	(Z80_RAM+5).l,d2
	lsl.w	#8,d2
	move.b	(Z80_RAM+6).l,d2
	add.w	d1,d2
	cmpi.w	#$1F00,d2
	bcs.s	.room
	bsr.w	Z80BusRelease
	lea	(SndDrvRAM).l,a1
	move.w	(sp)+,(a1)
	move.w	#4,d0
	ori	#1,ccr
	bra.w	.done
.room
	lea	(Z80_RAM+$100).l,a1
	move.w	#$29,d2
.chkdup
	cmpi.b	#0,(a1)
	bne.s	.nextdup
	cmp.b	1(a1),d0
	bne.s	.nextdup
	bsr.w	Z80BusRelease
	lea	(SndDrvRAM).l,a1
	move.w	(sp)+,(a1)
	move.w	#3,d0
	ori	#1,ccr
	bra.w	.done
.nextdup
	adda.l	#6,a1
	dbf	d2,.chkdup
	lea	(Z80_RAM+$100).l,a1
	move.w	#$29,d2
.findfree
	cmpi.b	#$FF,(a1)
	beq.s	.free
	adda.l	#6,a1
	dbf	d2,.findfree
	bsr.w	Z80BusRelease
	lea	(SndDrvRAM).l,a1
	move.w	(sp)+,(a1)
	move.w	#7,d0
	ori	#1,ccr
	bra.w	.done
.free
	move.b	#0,(a1)
	move.b	d0,1(a1)
	move.w	d1,d2
	move.b	d2,3(a1)
	lsr.w	#8,d2
	move.b	d2,2(a1)
	move.b	(Z80_RAM+5).l,d2
	move.b	d2,4(a1)
	move.b	(Z80_RAM+6).l,d2
	move.b	d2,5(a1)
	lea	(Z80_RAM).l,a1
	clr.l	d2
	move.b	(Z80_RAM+5).l,d2
	lsl.w	#8,d2
	move.b	(Z80_RAM+6).l,d2
	subi.w	#1,d1
.copy
	move.b	(a0)+,(a1,d2.w)
	addi.w	#1,d2
	dbf	d1,.copy
	move.b	d2,(Z80_RAM+6).l
	lsr.w	#8,d2
	move.b	d2,(Z80_RAM+5).l
	bsr.w	Z80BusRelease
	lea	(SndDrvRAM).l,a1
	move.w	(sp)+,(a1)
	clr.w	d0
.done
	movem.l	(sp)+,d1-d2/a0-a1
	rts

SndReadBlock						;Command $B: copy Z80 block d1 to a0. Carry set and d0 = 3 when there is
									;no such block
	movem.l	d1-d3/a0-a1,-(sp)
	lea	(SndDrvRAM).l,a1
	move.w	(a1),-(sp)
	move.w	#0,(a1)
	bsr.w	Z80BusRequest
	lea	(Z80_RAM+$100).l,a1
	move.w	#$29,d2
.find
	cmpi.b	#0,(a1)
	bne.s	.next
	cmp.b	1(a1),d1
	beq.s	.found
.next
	adda.l	#6,a1
	dbf	d2,.find
	bsr.w	Z80BusRelease
	lea	(SndDrvRAM).l,a1
	move.w	(sp)+,(a1)
	move.w	#3,d0
	ori	#1,ccr
	bra.w	.done
.found
	move.b	3(a1),d2
	lsl.w	#8,d2
	move.b	2(a1),d2
	subi.w	#1,d2
	move.b	4(a1),d3
	lsl.w	#8,d3
	move.b	5(a1),d3
	lea	(Z80_RAM).l,a1
.copy
	move.b	(a1,d3.w),(a0)+
	addi.w	#1,d3
	dbf	d2,.copy
	bsr.w	Z80BusRelease
	lea	(SndDrvRAM).l,a1
	move.w	(sp)+,(a1)
	clr.w	d0
.done
	movem.l	(sp)+,d1-d3/a0-a1
	rts

SndWriteBlock						;Command $C: copy a0 over Z80 block d1. Carry set and d0 = 3 when there is
									;no such block
	movem.l	d1-d3/a0-a1,-(sp)
	lea	(SndDrvRAM).l,a1
	move.w	(a1),-(sp)
	move.w	#0,(a1)
	bsr.w	Z80BusRequest
	lea	(Z80_RAM+$100).l,a1
	move.w	#$29,d2
.find
	cmpi.b	#0,(a1)
	bne.s	.next
	cmp.b	1(a1),d1
	beq.s	.found
.next
	adda.l	#6,a1
	dbf	d2,.find
	bsr.w	Z80BusRelease
	lea	(SndDrvRAM).l,a1
	move.w	(sp)+,(a1)
	move.w	#3,d0
	ori	#1,ccr
	bra.w	.done
.found
	move.b	3(a1),d2
	lsl.w	#8,d2
	move.b	2(a1),d2
	subi.w	#1,d2
	move.b	4(a1),d3
	lsl.w	#8,d3
	move.b	5(a1),d3
	lea	(Z80_RAM).l,a1
.copy
	move.b	(a0)+,(a1,d3.w)
	addi.w	#1,d3
	dbf	d2,.copy
	bsr.w	Z80BusRelease
	lea	(SndDrvRAM).l,a1
	move.w	(sp)+,(a1)
	clr.w	d0
.done
	movem.l	(sp)+,d1-d3/a0-a1
	rts

SndPauseZ80							;Command $D: Z80_RAM+$50 = $FF (pause)
	move.l	a0,-(sp)
	lea	(SndDrvRAM).l,a0
	move.w	(a0),-(sp)
	move.w	#0,(a0)
	btst	#8,(IO_Z80BUS).l
	bne.s	.busreq
	move.b	#$FF,(Z80_RAM+$50).l
	move.w	(sp)+,(a0)
	movea.l	(sp)+,a0
	rts
.busreq
	bsr.w	Z80BusRequest
	move.b	#$FF,(Z80_RAM+$50).l
	bsr.w	Z80BusRelease
	move.w	(sp)+,(a0)
	movea.l	(sp)+,a0
	rts

SndResumeZ80						;Command $E: Z80_RAM+$50 = 0 (resume)
	move.l	a0,-(sp)
	lea	(SndDrvRAM).l,a0
	move.w	(a0),-(sp)
	move.w	#0,(a0)
	btst	#8,(IO_Z80BUS).l
	bne.s	.busreq
	move.b	#0,(Z80_RAM+$50).l
	move.w	(sp)+,(a0)
	movea.l	(sp)+,a0
	rts
.busreq
	bsr.w	Z80BusRequest
	move.b	#0,(Z80_RAM+$50).l
	bsr.w	Z80BusRelease
	move.w	(sp)+,(a0)
	movea.l	(sp)+,a0
	rts

SndStopAll							;Command $F (SoundOff): free every song slot, send Z80 command $FF and
									;clear the notes
	movem.l	d0/a0-a1,-(sp)
	lea	(SndDrvRAM).l,a0
	move.w	(a0),-(sp)
	move.w	#0,(a0)
	lea	(SndSeqPtr).l,a1
	move.w	#7,d0
.clr
	move.l	#$FFFFFFFF,(a1)+
	dbf	d0,.clr
	move.w	#$FF,d0
	bsr.w	SndPutZ80Cmd
	bsr.w	SndClearNotes
	move.w	(sp)+,(a0)
	movem.l	(sp)+,d0/a0-a1
	rts

SndClearNotes						;No notes: SndNoteCount 0, SndNotes all -1
	movem.l	d0-d1/a0-a1,-(sp)
	lea	(SndDrvRAM).l,a0
	move.w	0(a0),-(sp)
	move.w	#0,0(a0)
	move.w	#0,$122(a0)
	lea	(SndNotes).l,a1
	move.w	#$1F,d1
	move.l	#$FFFFFFFF,d0
.clr
	move.l	d0,(a1)+
	dbf	d1,.clr
	move.w	(sp)+,0(a0)
	movem.l	(sp)+,d0-d1/a0-a1
	rts

SndReleaseNotes						;Set the timer of every note of slot d0 to 1 (released next frame)
	movem.l	d0-d2/a0-a1,-(sp)
	lea	(SndDrvRAM).l,a0
	move.w	0(a0),-(sp)
	move.w	#0,0(a0)
	lea	(SndNotes).l,a1
	move.w	$122(a0),d1
	clr.w	d2
.note
	cmpi.w	#0,d1
	beq.s	.done
	move.b	3(a1),d2
	lsr.b	#4,d2
	cmp.w	d0,d2
	bne.s	.next
	move.w	#1,(a1)
.next
	adda.l	#4,a1
	subi.w	#1,d1
	bra.s	.note
.done
	move.w	(sp)+,0(a0)
	movem.l	(sp)+,d0-d2/a0-a1
	rts

SndAddNote							;Add note d0 (timer word, then the note) to SndNotes
	movem.l	d0-d1/a0,-(sp)
	lea	(SndDrvRAM).l,a0
	move.w	SndNoteCount-SndDrvRAM(a0),d1
	lsl.w	#2,d1
	lea	(SndNotes).l,a0
	move.l	d0,(a0,d1.w)
	lea	(SndDrvRAM).l,a0
	addi.w	#1,SndNoteCount-SndDrvRAM(a0)
	movem.l	(sp)+,d0-d1/a0
	rts

SndUpdateNotes						;Count down the note timers; at 0 send the note off ($8x) and remove the
									;note
	movem.l	d0-d1/a0-a2,-(sp)
	lea	(SndDrvRAM).l,a2
	cmpi.w	#0,SndNoteCount-SndDrvRAM(a2)
	beq.s	.done
	lea	(SndNotes).l,a0
.note
	cmpi.w	#$FFFF,(a0)
	beq.s	.done
	subi.w	#1,(a0)
	bne.s	.next
	move.b	3(a0),d0
	andi.b	#$F0,d0
	lsl.w	#8,d0
	swap	d0
	move.w	2(a0),d0
	andi.b	#$F,d0
	ori.b	#$80,d0
	bsr.w	SndPutZ80Cmd
	tst.w	d0
	beq.s	.remove
	addi.w	#1,(a0)
	bra.s	.next
.remove
	lea	(SndNotes).l,a1
	move.w	(SndNoteCount).l,d0
	subi.w	#1,d0
	lsl.w	#2,d0
	move.l	(a1,d0.w),(a0)
	move.l	#$FFFFFFFF,(a1,d0.w)
	subi.w	#1,$122(a2)
	bra.s	.note
.next
	adda.w	#4,a0
	bra.s	.note
.done
	movem.l	(sp)+,d0-d1/a0-a2
	rts

SndStreamZ80						;Answer the Z80's sample request (Z80_RAM+$4D: 1 start sample Z80_RAM+$4E,
									;2 / 3 next 256 bytes) by copying
									;from the sample (bank item type 1) to the Z80 buffer, looping or ending
									;it
	movem.l	d1-d2/a0,-(sp)
	bsr.w	Z80BusRequest
	tst.b	(Z80_RAM+$4D).l
	beq.w	.done
	cmpi.b	#1,(Z80_RAM+$4D).l
	bne.s	.buf1
	clr.w	d1
	move.b	(Z80_RAM+$4E).l,d1
	move.w	#1,d0
	bsr.w	SndFindBankItem
	bcs.w	.done
	cmpa.l	#$FFFFFFFF,a0
	beq.w	.done
	lea	(SndDrvRAM).l,a1
	move.l	a0,SndStreamBase-SndDrvRAM(a1)
.rdhi
	move.b	(a0),d0
	cmp.b	(a0),d0
	bne.s	.rdhi
	lsl.w	#8,d0
	adda.l	#1,a0
.rdlo
	move.b	(a0),d0
	cmp.b	(a0),d0
	bne.s	.rdlo
	move.w	d0,$12E(a1)
	adda.l	#1,a0
	movea.l	$126(a1),a0
	adda.l	#2,a0
	move.l	a0,$12A(a1)
	clr.l	d0
	move.b	(Z80_RAM+7).l,d0
	lsl.w	#8,d0
	move.b	(Z80_RAM+8).l,d0
	addi.l	#Z80_RAM,d0
	movea.l	d0,a1
	bra.w	.copy
.buf1
	cmpi.b	#2,(Z80_RAM+$4D).l
	bne.s	.buf2
	movea.l	(SndStreamPtr).l,a0
	cmpa.l	#0,a0
	beq.w	.done
	clr.l	d0
	move.b	(Z80_RAM+7).l,d0
	lsl.w	#8,d0
	move.b	(Z80_RAM+8).l,d0
	addi.l	#Z80_RAM,d0
	movea.l	d0,a1
	bra.s	.copy
.buf2
	cmpi.b	#3,(Z80_RAM+$4D).l
	bne.w	.done
	movea.l	(SndStreamPtr).l,a0
	cmpa.l	#0,a0
	beq.w	.done
	clr.l	d0
	move.b	(Z80_RAM+9).l,d0
	lsl.w	#8,d0
	move.b	(Z80_RAM+$A).l,d0
	addi.l	#Z80_RAM,d0
	movea.l	d0,a1
.copy
	move.w	#$FF,d1
.copybyte
	move.b	(a0)+,(a1)+
	dbeq	d1,.copybyte
	beq.s	.end
	lea	(SndDrvRAM).l,a1
	addi.l	#$100,SndStreamPtr-SndDrvRAM(a1)
	bra.s	.done
.end
	suba.l	#1,a1
	clr.l	d0
	move.w	(SndStreamLoop).l,d0
	cmpi	#$FFFF,d0				;retail CMPI (0C40). No .w, so fixopcodes.js leaves it
	beq.s	.stop
	move.b	#$FF,(a1)
	lea	(SndDrvRAM).l,a1
	movea.l	SndStreamBase-SndDrvRAM(a1),a0
	adda.l	#2,a0
	adda.l	d0,a0
	move.l	a0,$12A(a1)
	bra.s	.done
.stop
	lea	(SndDrvRAM).l,a1
	move.l	#0,SndStreamPtr-SndDrvRAM(a1)
.done
	move.b	#0,(Z80_RAM+$4D).l
	bsr.w	Z80BusRelease
	movem.l	(sp)+,d1-d2/a0
	rts

SndFindBankItem						;Find bank item type d0, id d1 in the 4 banks (SndBanks): a0 = its data,
									;d0 = its size. Carry set and d0 = 3 when
									;there is none
	movem.l	d1-d4/a1-a2,-(sp)
	lea	(SndBanks).l,a1
	move.w	#3,d2
.bank
	cmpi.l	#$FFFFFFFF,(a1)
	beq.w	.nextbank
	movea.l	(a1),a0
	movea.l	a0,a2
	clr.l	d3
	move.b	(a0)+,d3
	lsl.w	#8,d3
	move.b	(a0)+,d3
	move.l	d3,d4
	lsl.w	#2,d4
	adda.l	d4,a2
	adda.l	#2,a2
.item
	cmp.b	(a0),d0
	bne.s	.nextitem
	cmp.b	1(a0),d1
	bne.s	.nextitem
	move.b	2(a0),d0
	lsl.w	#8,d0
	move.b	3(a0),d0
	movea.l	a2,a0
	andi	#$FE,ccr
	bra.s	.done
.nextitem
	clr.l	d4
	move.b	2(a0),d4
	lsl.w	#8,d4
	move.b	3(a0),d4
	adda.l	d4,a2
	adda.l	#4,a0
	subi.w	#1,d3
	bne.s	.item
.nextbank
	adda.l	#4,a1
	dbf	d2,.bank
	move.w	#3,d0
	ori	#1,ccr
.done
	movem.l	(sp)+,d1-d4/a1-a2
	rts

SndSetBank							;Command 6: bank d1 (0-3) is at a0; tell the Z80 too (Z80_RAM+$51). Carry
									;set and d0 = 3 for d1 above 3
	movem.l	d1/a1-a2,-(sp)
	cmpi.w	#4,d1
	bcs.s	.ok
	move.w	#3,d0
	ori	#1,ccr
	bra.s	.done
.ok
	lsl.w	#2,d1
	lea	(SndBanks).l,a1
	move.l	a0,(a1,d1.w)
	lea	(SndDrvRAM).l,a1
	move.w	(a1),-(sp)
	move.w	#0,(a1)
	bsr.w	Z80BusRequest
	lea	(Z80_RAM+$51).l,a2
	move.l	a0,d0
	move.b	d0,(a2,d1.w)
	lsr.l	#8,d0
	move.b	d0,1(a2,d1.w)
	lsr.l	#8,d0
	move.b	d0,2(a2,d1.w)
	lsr.l	#8,d0
	move.b	d0,3(a2,d1.w)
	bsr.w	Z80BusRelease
	move.w	(sp)+,(a1)
	clr.w	d0
.done
	movem.l	(sp)+,d1/a1-a2
	rts

SndLoadList							;Command 7: upload the patches (types 0 and 4) of load list d1 (bank item
									;type $B, pairs ended by $FF) to the Z80
	movem.l	d1/a0-a1,-(sp)
	move.w	#$B,d0
	bsr.w	SndFindBankItem
	bcs.w	.done
	movea.l	a0,a1
.entry
	cmpi.b	#$FF,(a1)
	bne.s	.find
	clr.w	d0
	bra.s	.done
.find
	clr.w	d0
	move.b	(a1),d0
	clr.w	d1
	move.b	1(a1),d1
	bsr.w	SndFindBankItem
	bcs.s	.done
	cmpi.b	#0,(a1)
	beq.s	.upload
	cmpi.b	#4,(a1)
	bne.s	.next
.upload
	move.w	d0,d1
	clr.w	d0
	move.b	1(a1),d0
	bsr.w	SndUploadBlock
	bcs.s	.done
.next
	adda.l	#2,a1
	bra.s	.entry
.done
	movem.l	(sp)+,d1/a0-a1
	rts

SndFreeBlocks						;Command 8: free the Z80 blocks of list a0 (word pairs ended by -1) and
									;move the blocks after them down
	movem.l	d1-d3/a0-a2,-(sp)
	lea	(SndDrvRAM).l,a1
	move.w	(a1),-(sp)
	move.w	#0,(a1)
	bsr.w	Z80BusRequest
.entry
	cmpi.w	#$FFFF,(a0)
	beq.w	.done
	lea	(Z80_RAM+$100).l,a1
	move.w	(a0),d0
	move.w	2(a0),d1
	move.w	#$29,d2
.find
	cmp.b	(a1),d0
	bne.s	.nextblk
	cmp.b	1(a1),d1
	beq.s	.found
.nextblk
	adda.l	#6,a1
	dbf	d2,.find
	bra.w	.next
.found
	move.b	2(a1),d0
	lsl.w	#8,d0
	move.b	3(a1),d0
	clr.w	d1
	move.b	4(a1),d1
	lsl.w	#8,d1
	move.b	5(a1),d1
	move.w	d1,d2
	add.w	d0,d2
	lea	(Z80_RAM).l,a2
.move
	cmpi.w	#$1F00,d2
	beq.s	.clear
	move.b	(a2,d2.w),(a2,d1.w)
	addi.w	#1,d2
	addi.w	#1,d1
	bra.s	.move
.clear
	clr.w	d1
	move.b	4(a1),d1
	lsl.w	#8,d1
	move.b	5(a1),d1
	move.b	#$FF,(a1)
	move.b	#$FF,1(a1)
	move.b	#$FF,2(a1)
	move.b	#$FF,3(a1)
	move.b	#$FF,4(a1)
	move.b	#$FF,5(a1)
	lea	(Z80_RAM+$100).l,a1
	move.w	#$29,d2
.fix
	cmpi.b	#$FF,(a1)
	beq.s	.nextfix
	clr.w	d3
	move.b	4(a1),d3
	lsl.w	#8,d3
	move.b	5(a1),d3
	cmp.w	d1,d3
	bcs.s	.nextfix
	sub.w	d0,d3
	move.b	d3,5(a1)
	lsr.w	#8,d3
	move.b	d3,4(a1)
.nextfix
	adda.l	#6,a1
	dbf	d2,.fix
	lea	(Z80_RAM+5).l,a1
	clr.w	d1
	move.b	(a1),d1
	lsl.w	#8,d1
	move.b	1(a1),d1
	sub.w	d0,d1
	move.b	d1,1(a1)
	lsr.w	#8,d1
	move.b	d1,(a1)
.next
	adda.l	#4,a0
	bra.w	.entry
.done
	bsr.w	Z80BusRelease
	lea	(SndDrvRAM).l,a1
	move.w	(sp)+,(a1)
	clr.w	d0
	movem.l	(sp)+,d1-d3/a0-a2
	rts

SndResetBlocks						;Command 9: free all Z80 blocks (Z80_RAM+$100 all $FF, free pointer back
									;to the start at Z80_RAM+3)
	movem.l	a0-a1,-(sp)
	lea	(SndDrvRAM).l,a0
	move.w	(a0),-(sp)
	move.w	#0,(a0)
	bsr.w	Z80BusRequest
	lea	(Z80_RAM+$100).l,a0
	move.w	#$FB,d0
.clr
	move.b	#$FF,(a0)+
	dbf	d0,.clr
	lea	(Z80_RAM+3).l,a0
	lea	(Z80_RAM+5).l,a1
	move.b	(a0)+,(a1)+
	move.b	(a0),(a1)
	bsr.w	Z80BusRelease
	lea	(SndDrvRAM).l,a0
	move.w	(sp)+,(a0)
	clr.w	d0
	movem.l	(sp)+,a0-a1
	rts

SndSendZ80							;Command $A: queue Z80 command d1 with interrupts off
	move	sr,-(sp)
	move	#$2700,sr
	move.l	d1,d0
	bsr.w	SndPutZ80Cmd
	move	(sp)+,sr
	rts

Z80BusRequest						;Stop the Z80 and wait for the bus
	move.w	#$100,(IO_Z80BUS).l
.wait
	btst	#8,(IO_Z80BUS).l
	bne.s	.wait
	rts

Z80BusRelease						;Give the bus back to the Z80
	move.w	#0,(IO_Z80BUS).l
	rts
	opt	oaq+,osq+,oz+

Z80Program							;The Z80 sound program. Starts JP $0600
	incbin	..\Extracted\NHL95\Sound\z80_snd_drv95.bin
	nop								;Pad (retail 4E71)

SoundBanks							;Bank 0 (SndSetBank, Begin and Opening2): the item count, then 4 bytes per
									;item (type, id, size), then the items in that order. Type 0 = patch
									;(uploaded to the Z80 by a load list), 1 = sample (streamed), 3 = song, $B
									;= load list (SndLoadList). SndFindBankItem finds an item by type and id
	dc.w	141						;items
	SndItem	SB_PATCH,$00,$5			;patch 0
	SndItem	SB_PATCH,$01,$5			;patch 1
	SndItem	SB_PATCH,$02,$5			;patch 2
	SndItem	SB_PATCH,$03,$5			;patch 3
	SndItem	SB_PATCH,$04,$5			;patch 4
	SndItem	SB_PATCH,$05,$5			;patch 5
	SndItem	SB_PATCH,$06,$5			;patch 6
	SndItem	SB_PATCH,$07,$5			;patch 7
	SndItem	SB_PATCH,$08,$5			;patch 8
	SndItem	SB_PATCH,$09,$5			;patch 9
	SndItem	SB_PATCH,$0A,$5			;patch 10
	SndItem	SB_PATCH,$0B,$27		;patch 11
	SndItem	SB_PATCH,$0C,$5			;patch 12
	SndItem	SB_PATCH,$0D,$27		;patch 13
	SndItem	SB_PATCH,$0E,$27		;patch 14
	SndItem	SB_PATCH,$11,$27		;patch 17
	SndItem	SB_PATCH,$13,$10		;patch 19
	SndItem	SB_PATCH,$14,$10		;patch 20
	SndItem	SB_PATCH,$15,$27		;patch 21
	SndItem	SB_PATCH,$16,$27		;patch 22
	SndItem	SB_PATCH,$18,$27		;patch 24
	SndItem	SB_PATCH,$19,$27		;patch 25
	SndItem	SB_PATCH,$1B,$27		;patch 27
	SndItem	SB_PATCH,$1C,$27		;patch 28
	SndItem	SB_PATCH,$1D,$27		;patch 29
	SndItem	SB_PATCH,$33,$5			;patch 51
	SndItem	SB_PATCH,$36,$5			;patch 54
	SndItem	SB_PATCH,$38,$5			;patch 56
	SndItem	SB_PATCH,$39,$5			;patch 57
	SndItem	SB_PATCH,$3B,$5			;patch 59
	SndItem	SB_PATCH,$3D,$5			;patch 61
	SndItem	SB_PATCH,$3E,$27		;patch 62
	SndItem	SB_PATCH,$3F,$27		;patch 63
	SndItem	SB_PATCH,$40,$27		;patch 64
	SndItem	SB_PATCH,$41,$5			;patch 65
	SndItem	SB_PATCH,$42,$5			;patch 66
	SndItem	SB_PATCH,$43,$5			;patch 67
	SndItem	SB_PATCH,$44,$5			;patch 68
	SndItem	SB_PATCH,$45,$27		;patch 69
	SndItem	SB_PATCH,$46,$5			;patch 70
	SndItem	SB_PATCH,$47,$27		;patch 71
	SndItem	SB_PATCH,$48,$5			;patch 72
	SndItem	SB_PATCH,$49,$27		;patch 73
	SndItem	SB_SAMPLE,$00,$2143		;sample 0
	SndItem	SB_SAMPLE,$01,$227		;sample 1
	SndItem	SB_SAMPLE,$02,$20CB		;sample 2
	SndItem	SB_SAMPLE,$03,$863		;sample 3
	SndItem	SB_SAMPLE,$04,$A03		;sample 4
	SndItem	SB_SAMPLE,$05,$F09		;sample 5
	SndItem	SB_SAMPLE,$06,$F23		;sample 6
	SndItem	SB_SAMPLE,$07,$EC3		;sample 7
	SndItem	SB_SAMPLE,$08,$10D3		;sample 8
	SndItem	SB_SAMPLE,$09,$32F		;sample 9
	SndItem	SB_SAMPLE,$0A,$353		;sample 10
	SndItem	SB_SAMPLE,$0B,$15C2		;sample 11
	SndItem	SB_SAMPLE,$0C,$1045		;sample 12
	SndItem	SB_SAMPLE,$0E,$9BC3		;sample 14
	SndItem	SB_SAMPLE,$10,$EC29		;sample 16
	SndItem	SB_SAMPLE,$11,$2528		;sample 17
	SndItem	SB_SAMPLE,$13,$57CE		;sample 19
	SndItem	SB_SAMPLE,$15,$1EC9		;sample 21
	SndItem	SB_SAMPLE,$16,$D083		;sample 22
	SndItem	SB_SAMPLE,$17,$47D0		;sample 23
	SndItem	SB_SAMPLE,$18,$1503		;sample 24
	SndItem	SB_SAMPLE,$19,$1B43		;sample 25
	SndItem	SB_SAMPLE,$1B,$1822		;sample 27
	SndItem	SB_SAMPLE,$1D,$232		;sample 29
	SndItem	SB_SONG,$00,$46FB		;song 0
	SndItem	SB_SONG,$01,$2B82		;song 1
	SndItem	SB_SONG,$02,$3587		;song 2
	SndItem	SB_SONG,$03,$3F33		;song 3
	SndItem	SB_SONG,$04,$C			;song 4
	SndItem	SB_SONG,$05,$C			;song 5
	SndItem	SB_SONG,$06,$C			;song 6
	SndItem	SB_SONG,$07,$C			;song 7
	SndItem	SB_SONG,$08,$C			;song 8
	SndItem	SB_SONG,$09,$C			;song 9
	SndItem	SB_SONG,$0A,$C			;song 10
	SndItem	SB_SONG,$0B,$C			;song 11
	SndItem	SB_SONG,$0E,$E			;song 14
	SndItem	SB_SONG,$10,$E			;song 16
	SndItem	SB_SONG,$11,$C			;song 17
	SndItem	SB_SONG,$13,$C			;song 19
	SndItem	SB_SONG,$15,$C			;song 21
	SndItem	SB_SONG,$16,$64			;song 22
	SndItem	SB_SONG,$17,$54			;song 23
	SndItem	SB_SONG,$18,$C			;song 24
	SndItem	SB_SONG,$19,$C			;song 25
	SndItem	SB_SONG,$1A,$C			;song 26
	SndItem	SB_SONG,$1B,$C			;song 27
	SndItem	SB_SONG,$1C,$C			;song 28
	SndItem	SB_SONG,$1D,$C			;song 29
	SndItem	SB_SONG,$1E,$E			;song 30
	SndItem	SB_SONG,$20,$C			;song 32
	SndItem	SB_SONG,$21,$C			;song 33
	SndItem	SB_SONG,$22,$C			;song 34
	SndItem	SB_SONG,$23,$C			;song 35
	SndItem	SB_SONG,$24,$C			;song 36
	SndItem	SB_SONG,$25,$C			;song 37
	SndItem	SB_SONG,$26,$31B		;song 38
	SndItem	SB_SONG,$27,$14			;song 39
	SndItem	SB_SONG,$28,$14			;song 40
	SndItem	SB_SONG,$29,$C			;song 41
	SndItem	SB_SONG,$32,$1F2		;song 50
	SndItem	SB_SONG,$33,$4E4		;song 51
	SndItem	SB_SONG,$34,$254		;song 52
	SndItem	SB_SONG,$35,$2AE		;song 53
	SndItem	SB_SONG,$36,$31C		;song 54
	SndItem	SB_SONG,$37,$2A8		;song 55
	SndItem	SB_SONG,$38,$29C		;song 56
	SndItem	SB_SONG,$39,$1AC		;song 57
	SndItem	SB_SONG,$3A,$3E4		;song 58
	SndItem	SB_SONG,$3B,$244		;song 59
	SndItem	SB_SONG,$3C,$30			;song 60
	SndItem	SB_SONG,$3D,$404		;song 61
	SndItem	SB_SONG,$3E,$341		;song 62
	SndItem	SB_SONG,$3F,$208		;song 63
	SndItem	SB_SONG,$40,$27E		;song 64
	SndItem	SB_SONG,$41,$358		;song 65
	SndItem	SB_SONG,$42,$12C		;song 66
	SndItem	SB_SONG,$43,$3C4		;song 67
	SndItem	SB_SONG,$44,$20C		;song 68
	SndItem	SB_SONG,$45,$274		;song 69
	SndItem	SB_SONG,$46,$158		;song 70
	SndItem	SB_SONG,$47,$3BC		;song 71
	SndItem	SB_SONG,$48,$424		;song 72
	SndItem	SB_SONG,$49,$400		;song 73
	SndItem	SB_SONG,$4A,$315		;song 74
	SndItem	SB_SONG,$4B,$365		;song 75
	SndItem	SB_SONG,$4C,$363		;song 76
	SndItem	SB_SONG,$4D,$2C9		;song 77
	SndItem	SB_SONG,$4E,$41C		;song 78
	SndItem	SB_SONG,$4F,$48C		;song 79
	SndItem	SB_SONG,$50,$255		;song 80
	SndItem	SB_SONG,$51,$22A		;song 81
	SndItem	SB_SONG,$52,$F0			;song 82
	SndItem	SB_SONG,$53,$274		;song 83
	SndItem	SB_SONG,$54,$D4			;song 84
	SndItem	SB_SONG,$55,$429		;song 85
	SndItem	SB_LIST,$00,$19			;list 0
	SndItem	SB_LIST,$01,$3F			;list 1
	incbin	..\Extracted\NHL95\Sound\Bank\snd95_patch_00.bin
	incbin	..\Extracted\NHL95\Sound\Bank\snd95_patch_01.bin
	incbin	..\Extracted\NHL95\Sound\Bank\snd95_patch_02.bin
	incbin	..\Extracted\NHL95\Sound\Bank\snd95_patch_03.bin
	incbin	..\Extracted\NHL95\Sound\Bank\snd95_patch_04.bin
	incbin	..\Extracted\NHL95\Sound\Bank\snd95_patch_05.bin
	incbin	..\Extracted\NHL95\Sound\Bank\snd95_patch_06.bin
	incbin	..\Extracted\NHL95\Sound\Bank\snd95_patch_07.bin
	incbin	..\Extracted\NHL95\Sound\Bank\snd95_patch_08.bin
	incbin	..\Extracted\NHL95\Sound\Bank\snd95_patch_09.bin
	incbin	..\Extracted\NHL95\Sound\Bank\snd95_patch_0A.bin
	incbin	..\Extracted\NHL95\Sound\Bank\snd95_patch_0B.bin
	incbin	..\Extracted\NHL95\Sound\Bank\snd95_patch_0C.bin
	incbin	..\Extracted\NHL95\Sound\Bank\snd95_patch_0D.bin
	incbin	..\Extracted\NHL95\Sound\Bank\snd95_patch_0E.bin
	incbin	..\Extracted\NHL95\Sound\Bank\snd95_patch_11.bin
	incbin	..\Extracted\NHL95\Sound\Bank\snd95_patch_13.bin
	incbin	..\Extracted\NHL95\Sound\Bank\snd95_patch_14.bin
	incbin	..\Extracted\NHL95\Sound\Bank\snd95_patch_15.bin
	incbin	..\Extracted\NHL95\Sound\Bank\snd95_patch_16.bin
	incbin	..\Extracted\NHL95\Sound\Bank\snd95_patch_18.bin
	incbin	..\Extracted\NHL95\Sound\Bank\snd95_patch_19.bin
	incbin	..\Extracted\NHL95\Sound\Bank\snd95_patch_1B.bin
	incbin	..\Extracted\NHL95\Sound\Bank\snd95_patch_1C.bin
	incbin	..\Extracted\NHL95\Sound\Bank\snd95_patch_1D.bin
	incbin	..\Extracted\NHL95\Sound\Bank\snd95_patch_33.bin
	incbin	..\Extracted\NHL95\Sound\Bank\snd95_patch_36.bin
	incbin	..\Extracted\NHL95\Sound\Bank\snd95_patch_38.bin
	incbin	..\Extracted\NHL95\Sound\Bank\snd95_patch_39.bin
	incbin	..\Extracted\NHL95\Sound\Bank\snd95_patch_3B.bin
	incbin	..\Extracted\NHL95\Sound\Bank\snd95_patch_3D.bin
	incbin	..\Extracted\NHL95\Sound\Bank\snd95_patch_3E.bin
	incbin	..\Extracted\NHL95\Sound\Bank\snd95_patch_3F.bin
	incbin	..\Extracted\NHL95\Sound\Bank\snd95_patch_40.bin
	incbin	..\Extracted\NHL95\Sound\Bank\snd95_patch_41.bin
	incbin	..\Extracted\NHL95\Sound\Bank\snd95_patch_42.bin
	incbin	..\Extracted\NHL95\Sound\Bank\snd95_patch_43.bin
	incbin	..\Extracted\NHL95\Sound\Bank\snd95_patch_44.bin
	incbin	..\Extracted\NHL95\Sound\Bank\snd95_patch_45.bin
	incbin	..\Extracted\NHL95\Sound\Bank\snd95_patch_46.bin
	incbin	..\Extracted\NHL95\Sound\Bank\snd95_patch_47.bin
	incbin	..\Extracted\NHL95\Sound\Bank\snd95_patch_48.bin
	incbin	..\Extracted\NHL95\Sound\Bank\snd95_patch_49.bin
	incbin	..\Extracted\NHL95\Sound\Bank\snd95_sample_00.bin
	incbin	..\Extracted\NHL95\Sound\Bank\snd95_sample_01.bin
	incbin	..\Extracted\NHL95\Sound\Bank\snd95_sample_02.bin
	incbin	..\Extracted\NHL95\Sound\Bank\snd95_sample_03.bin
	incbin	..\Extracted\NHL95\Sound\Bank\snd95_sample_04.bin
	incbin	..\Extracted\NHL95\Sound\Bank\snd95_sample_05.bin
	incbin	..\Extracted\NHL95\Sound\Bank\snd95_sample_06.bin
	incbin	..\Extracted\NHL95\Sound\Bank\snd95_sample_07.bin
	incbin	..\Extracted\NHL95\Sound\Bank\snd95_sample_08.bin
	incbin	..\Extracted\NHL95\Sound\Bank\snd95_sample_09.bin
	incbin	..\Extracted\NHL95\Sound\Bank\snd95_sample_0A.bin
	incbin	..\Extracted\NHL95\Sound\Bank\snd95_sample_0B.bin
	incbin	..\Extracted\NHL95\Sound\Bank\snd95_sample_0C.bin
	incbin	..\Extracted\NHL95\Sound\Bank\snd95_sample_0E.bin
	incbin	..\Extracted\NHL95\Sound\Bank\snd95_sample_10.bin
	incbin	..\Extracted\NHL95\Sound\Bank\snd95_sample_11.bin
	incbin	..\Extracted\NHL95\Sound\Bank\snd95_sample_13.bin
	incbin	..\Extracted\NHL95\Sound\Bank\snd95_sample_15.bin
	incbin	..\Extracted\NHL95\Sound\Bank\snd95_sample_16.bin
	incbin	..\Extracted\NHL95\Sound\Bank\snd95_sample_17.bin
	incbin	..\Extracted\NHL95\Sound\Bank\snd95_sample_18.bin
	incbin	..\Extracted\NHL95\Sound\Bank\snd95_sample_19.bin
	incbin	..\Extracted\NHL95\Sound\Bank\snd95_sample_1B.bin
	incbin	..\Extracted\NHL95\Sound\Bank\snd95_sample_1D.bin
	incbin	..\Extracted\NHL95\Sound\Bank\snd95_song_00.bin
	incbin	..\Extracted\NHL95\Sound\Bank\snd95_song_01.bin
	incbin	..\Extracted\NHL95\Sound\Bank\snd95_song_02.bin
	incbin	..\Extracted\NHL95\Sound\Bank\snd95_song_03.bin
	incbin	..\Extracted\NHL95\Sound\Bank\snd95_song_04.bin
	incbin	..\Extracted\NHL95\Sound\Bank\snd95_song_05.bin
	incbin	..\Extracted\NHL95\Sound\Bank\snd95_song_06.bin
	incbin	..\Extracted\NHL95\Sound\Bank\snd95_song_07.bin
	incbin	..\Extracted\NHL95\Sound\Bank\snd95_song_08.bin
	incbin	..\Extracted\NHL95\Sound\Bank\snd95_song_09.bin
	incbin	..\Extracted\NHL95\Sound\Bank\snd95_song_0A.bin
	incbin	..\Extracted\NHL95\Sound\Bank\snd95_song_0B.bin
	incbin	..\Extracted\NHL95\Sound\Bank\snd95_song_0E.bin
	incbin	..\Extracted\NHL95\Sound\Bank\snd95_song_10.bin
	incbin	..\Extracted\NHL95\Sound\Bank\snd95_song_11.bin
	incbin	..\Extracted\NHL95\Sound\Bank\snd95_song_13.bin
	incbin	..\Extracted\NHL95\Sound\Bank\snd95_song_15.bin
	incbin	..\Extracted\NHL95\Sound\Bank\snd95_song_16.bin
	incbin	..\Extracted\NHL95\Sound\Bank\snd95_song_17.bin
	incbin	..\Extracted\NHL95\Sound\Bank\snd95_song_18.bin
	incbin	..\Extracted\NHL95\Sound\Bank\snd95_song_19.bin
	incbin	..\Extracted\NHL95\Sound\Bank\snd95_song_1A.bin
	incbin	..\Extracted\NHL95\Sound\Bank\snd95_song_1B.bin
	incbin	..\Extracted\NHL95\Sound\Bank\snd95_song_1C.bin
	incbin	..\Extracted\NHL95\Sound\Bank\snd95_song_1D.bin
	incbin	..\Extracted\NHL95\Sound\Bank\snd95_song_1E.bin
	incbin	..\Extracted\NHL95\Sound\Bank\snd95_song_20.bin
	incbin	..\Extracted\NHL95\Sound\Bank\snd95_song_21.bin
	incbin	..\Extracted\NHL95\Sound\Bank\snd95_song_22.bin
	incbin	..\Extracted\NHL95\Sound\Bank\snd95_song_23.bin
	incbin	..\Extracted\NHL95\Sound\Bank\snd95_song_24.bin
	incbin	..\Extracted\NHL95\Sound\Bank\snd95_song_25.bin
	incbin	..\Extracted\NHL95\Sound\Bank\snd95_song_26.bin
	incbin	..\Extracted\NHL95\Sound\Bank\snd95_song_27.bin
	incbin	..\Extracted\NHL95\Sound\Bank\snd95_song_28.bin
	incbin	..\Extracted\NHL95\Sound\Bank\snd95_song_29.bin
	incbin	..\Extracted\NHL95\Sound\Bank\snd95_song_32.bin
	incbin	..\Extracted\NHL95\Sound\Bank\snd95_song_33.bin
	incbin	..\Extracted\NHL95\Sound\Bank\snd95_song_34.bin
	incbin	..\Extracted\NHL95\Sound\Bank\snd95_song_35.bin
	incbin	..\Extracted\NHL95\Sound\Bank\snd95_song_36.bin
	incbin	..\Extracted\NHL95\Sound\Bank\snd95_song_37.bin
	incbin	..\Extracted\NHL95\Sound\Bank\snd95_song_38.bin
	incbin	..\Extracted\NHL95\Sound\Bank\snd95_song_39.bin
	incbin	..\Extracted\NHL95\Sound\Bank\snd95_song_3A.bin
	incbin	..\Extracted\NHL95\Sound\Bank\snd95_song_3B.bin
	incbin	..\Extracted\NHL95\Sound\Bank\snd95_song_3C.bin
	incbin	..\Extracted\NHL95\Sound\Bank\snd95_song_3D.bin
	incbin	..\Extracted\NHL95\Sound\Bank\snd95_song_3E.bin
	incbin	..\Extracted\NHL95\Sound\Bank\snd95_song_3F.bin
	incbin	..\Extracted\NHL95\Sound\Bank\snd95_song_40.bin
	incbin	..\Extracted\NHL95\Sound\Bank\snd95_song_41.bin
	incbin	..\Extracted\NHL95\Sound\Bank\snd95_song_42.bin
	incbin	..\Extracted\NHL95\Sound\Bank\snd95_song_43.bin
	incbin	..\Extracted\NHL95\Sound\Bank\snd95_song_44.bin
	incbin	..\Extracted\NHL95\Sound\Bank\snd95_song_45.bin
	incbin	..\Extracted\NHL95\Sound\Bank\snd95_song_46.bin
	incbin	..\Extracted\NHL95\Sound\Bank\snd95_song_47.bin
	incbin	..\Extracted\NHL95\Sound\Bank\snd95_song_48.bin
	incbin	..\Extracted\NHL95\Sound\Bank\snd95_song_49.bin
	incbin	..\Extracted\NHL95\Sound\Bank\snd95_song_4A.bin
	incbin	..\Extracted\NHL95\Sound\Bank\snd95_song_4B.bin
	incbin	..\Extracted\NHL95\Sound\Bank\snd95_song_4C.bin
	incbin	..\Extracted\NHL95\Sound\Bank\snd95_song_4D.bin
	incbin	..\Extracted\NHL95\Sound\Bank\snd95_song_4E.bin
	incbin	..\Extracted\NHL95\Sound\Bank\snd95_song_4F.bin
	incbin	..\Extracted\NHL95\Sound\Bank\snd95_song_50.bin
	incbin	..\Extracted\NHL95\Sound\Bank\snd95_song_51.bin
	incbin	..\Extracted\NHL95\Sound\Bank\snd95_song_52.bin
	incbin	..\Extracted\NHL95\Sound\Bank\snd95_song_53.bin
	incbin	..\Extracted\NHL95\Sound\Bank\snd95_song_54.bin
	incbin	..\Extracted\NHL95\Sound\Bank\snd95_song_55.bin
	incbin	..\Extracted\NHL95\Sound\Bank\snd95_list_00.bin
	incbin	..\Extracted\NHL95\Sound\Bank\snd95_list_01.bin

;-------------------------------------------------------------------------------------------------------------
;	The sound calls, then the unused remains of the old sound driver with its PCM samples and FM patches.

SoundCmd							;Send command d0 to the 95 sound driver (SndDriver, above). Called from
									;Begin, Opening2, StartGame ...
	jsr	(SndDriver).l
	bcc.w	.exit
	nop
	nop
.exit
	rts

UpdateCwdExcite						;Called once per second. Track peak and running total of crowd excitement,
									;then decay the level by 1
	move.w	(CwdExciteLvl).w,d0
	cmp.w	(MaxCwdExciteLvl).w,d0
	bls.w	.less
	move.w	d0,(MaxCwdExciteLvl).w	;new peak
.less
	ext.l	d0
	add.l	d0,(SumCwdExciteLvl).w	;running total
	addq.w	#1,(NumCwdExciteLvl).w	;sample count
	subq.w	#1,(CwdExciteLvl).w		;decay
	bpl.w	.ex
	clr.w	(CwdExciteLvl).w
.ex
	rts

updatesound							;Move the crowd noise volume (psg noise channel, asv) toward Crowdlevel.
									;Called from DoGameFrame
	move.w	(Crowdlevel).w,d0
	asl.w	#3,d0
	addi.w	#$400,d0
	cmp.w	#$EFF,d0
	bls.w	.ip
	move.w	#$EFF,d0
.ip
	moveq	#$28,d2
	sub.w	(asv).w,d0
	cmp.w	d2,d0
	bgt.w	.iasv
	neg.w	d2
	cmp.w	d2,d0
	bge.w	.non
.iasv
	add.w	d2,(asv).w
	bpl.w	.non
	clr.w	(asv).w
.non
	move.b	#$C8,(Asound).l
	move.b	#1,(Asound).l
	move.b	(asv).w,d0
	eori.b	#$F,d0
	ori.b	#$F0,d0
	move.b	d0,(Asound).l
	rts

CheckLateGameSong					;Called once per second. 3rd period: choose and play a song once at the
									;random trigger time set by ResetClock
	cmpi.w	#2,(gsp).w
	bne.w	.x
	btst	#gmhl,(gmode).w
	bne.w	.x
	move.w	(gameclock).w,d0
	cmp.w	(periodendtime).w,d0
	bgt.w	.x
	st	(periodendtime).w			;high byte $FF: trigger goes negative, fires once
	move.w	(HomeTeam).w,(HmTeam).w
	move.w	#5,(SongIndex).w
	jsr	(ChooseSong).l
	move.w	(SongNum).w,-(sp)
	jsr	(song).l
.x
	rts

sfx									;Play sound effect number, one word passed on stack. 95: through SfxTable
									;to a sound driver song (command 4)
	movem.l	d0-d7/a0-a6,-(sp)
	clr.l	d0
	move.w	$40(sp),d0				;$40 = 16*4
	bpl.w	sfxplay
	movem.l	(sp)+,d0-d7/a0-a6
	move.l	(sp),2(sp)
	addq.w	#2,sp
	rts

sfxplay								;Play sound d0 ($32-$55 are songs, PlayingSong; below, SfxTable). Sound
									;$2D / $2E: a nop. song branches here
	cmp.w	#$2E,d0
	beq.w	.nop
	cmp.w	#$2D,d0
	bne.w	.chksong
.nop
	nop
.chksong
	cmp.w	#$55,d0
	bgt.w	.done
	cmp.w	#$32,d0
	blt.w	.sfx
	move.w	d0,(PlayingSong).w
	bra.w	.play
.sfx
	movea.l	#SfxTable,a1
	tst.b	(a1,d0.w)
	bmi.w	.done
	cmpi.b	#$26,(a1,d0.w)
	bne.w	.chklast
	movem.l	d0-d4/a0-a1,-(sp)
	movea.l	#SndSeqPtr,a0
	movea.w	#(SndSeqId-M68K_RAM),a1
	move.w	#7,d4
	clr.w	d3
.slot
	cmpi.l	#$FFFFFFFF,(a0)
	beq.w	.nextslot
	cmpi.w	#$31,(a1,d3.w)
	ble.w	.nextslot
	move.w	(a1,d3.w),d1
	move.w	#5,d0
	move.w	#$FFFF,d2
	jsr	(SndDriver).l
	bra.w	.stopped
.nextslot
	addq.w	#4,a0
	addq.w	#2,d3
	dbf	d4,.slot
.stopped
	movem.l	(sp)+,d0-d4/a0-a1
.chklast
	cmp.w	#$B,d0
	beq.w	.lookup
	cmp.w	#$C,d0
	beq.w	.lookup
	move.w	d0,(lastsfx).w
.lookup
	move.b	(a1,d0.w),d0
.play
	ext.w	d0
	move.w	d0,d1
	move.w	#4,d0
	move.w	#$FFFF,d2
	move.w	#$7F,d3
	move.w	#$100,d4
	jsr	(SoundCmd).l
.done
	movem.l	(sp)+,d0-d7/a0-a6
	move.l	(sp),2(sp)
	addq.w	#2,sp
	rts

SfxTable							;Sound driver song for sound effects 0-$31 (sfx), $FF = none. $26 first
									;stops the songs above $31
	dc.b	$26,$1C,$1D,$17,$16,$FF,$09,$25	;sounds $00-$07
	dc.b	$04,$FF,$FF,$10,$1E,$13,$20,$0E	;sounds $08-$0F
	dc.b	$0B,$0B,$0B,$0B,$08,$08,$08,$08	;sounds $10-$17
	dc.b	$08,$08,$08,$08,$21,$23,$23,$22	;sounds $18-$1F
	dc.b	$18,$15,$15,$15,$25,$04,$04,$04	;sounds $20-$27
	dc.b	$18,$18,$18,$18,$11,$1A,$1A,$FF	;sounds $28-$2F
	dc.b	$FF,$FF					;sounds $30-$31

song								;Play song number, one word passed on stack. 95: songs 0-3 through
									;StartSong, the rest through sfxplay
	movem.l	d0-d7/a0-a6,-(sp)
	clr.l	d0
	move.w	$40(sp),d0				;$40 = 16*4
	bmi.w	.none
	cmp.w	#$32,d0
	blt.w	.0
	cmp.w	#$55,d0
	bgt.w	.0
	jsr	(stop_current_song).l
	move.w	d0,(PlayingSong).w
.0
	cmp.w	#3,d0
	ble.w	.1
	bra.w	sfxplay
.1
	jsr	(StartSong).l
.none
	movem.l	(sp)+,d0-d7/a0-a6
	move.l	(sp),2(sp)
	addq.w	#2,sp
	rts

StartSong							;Stop the song, then song d0 (command 4, tempo $100)
	tst.w	d0
	bmi.w	rtsfx
	movem.l	d0-d7/a0-a6,-(sp)
	bsr.w	stop_current_song
	move.w	d0,(PlayingSong).w
	move.w	d0,d1
	move.w	#4,d0
	move.w	#$FFFF,d2
	move.w	#$7F,d3
	move.w	#$100,d4
	jsr	(SoundCmd).l
	movem.l	(sp)+,d0-d7/a0-a6
	rts

stop_current_song					;Stop the song in progress (PlayingSong, sound driver command 5)
	movem.l	d0-d7/a0-a6,-(sp)
	move.w	#5,d0
	move.w	(PlayingSong).w,d1
	bmi.w	.0
	move.w	#$FFFF,d2
	jsr	(SoundCmd).l
	move.w	#$FFFF,(PlayingSong).w
.0
	movem.l	(sp)+,d0-d7/a0-a6
	rts

stop_current_song2					;Unreferenced. A copy of stop_current_song that skips the saving when no
									;song plays
	tst.w	(PlayingSong).w
	bmi.w	.exit					;no song playing
	movem.l	d0-d7/a0-a6,-(sp)
	move.w	#5,d0
	move.w	(PlayingSong).w,d1
	move.w	#$FFFF,d2
	jsr	(SoundCmd).l
	movem.l	(sp)+,d0-d7/a0-a6
	move.w	#$FFFF,(PlayingSong).w
.exit
	rts

KillCrowd							;Silence the crowd noise (psg)
	move.b	#$E7,(Asound).l
	move.b	#$DF,(Asound).l
	move.b	#$C8,(Asound).l
	move.b	#1,(Asound).l
	move.b	#$FF,(Asound).l
	rts

SoundOff							;Sound driver command $F, every song off
	movem.l	d0-d7/a0-a6,-(sp)
	move.w	#$F,d0
	bsr.w	SoundCmd
	movem.l	(sp)+,d0-d7/a0-a6
	rts

ChooseSong							;SongNum = byte SongIndex of the 6 song bytes of team HmTeam, or one of
									;the 8 of RandomSongs at random when 0; $FFFF with gmode bit 4
	movem.l	d0-d1/a0-a1,-(sp)
	btst	#gmhl,(gmode).w
	beq.w	.0
	move.w	#$FFFF,d1
	bra.w	.1
.0
	bclr	#6,(sflags8).w
	movea.l	#TeamSongs,a0
	movea.l	#RandomSongs,a1
	move.w	(HmTeam).w,d0
	mulu.w	#6,d0
	add.w	(SongIndex).w,d0
	clr.w	d1
	move.b	(a0,d0.w),d1
	bne.w	.1
	move.w	#8,d0
	jsr	(randomd0).l
	andi.w	#7,d0
	move.b	(a1,d0.w),d1
.1
	ext.w	d1
	move.w	d1,(SongNum).w
	movem.l	(sp)+,d0-d1/a0-a1
	rts

TeamSongs							;6 song bytes per team (TeamList order), by
									;SongIndex. 0 = a RandomSongs song
	dc.b	$3A,$40,$49,$54,$46,$00	;0 ANH
	dc.b	$51,$42,$40,$00,$46,$51	;1 BOS
	dc.b	$33,$32,$32,$33,$46,$00	;2 BUF
	dc.b	$34,$35,$34,$35,$49,$49	;3 CGY
	dc.b	$36,$39,$37,$36,$46,$4E	;4 CHI
	dc.b	$51,$42,$42,$00,$46,$00	;5 DAL
	dc.b	$38,$3F,$39,$00,$46,$3F	;6 DET
	dc.b	$3B,$51,$51,$00,$46,$00	;7 EDM
	dc.b	$45,$48,$3C,$55,$46,$00	;8 FLA
	dc.b	$3D,$3E,$45,$3E,$46,$3D	;9 HFD
	dc.b	$3F,$3F,$39,$35,$46,$40	;10 LA
	dc.b	$3F,$55,$3F,$44,$46,$43	;11 MTL
	dc.b	$32,$37,$32,$00,$46,$38	;12 NJ
	dc.b	$32,$42,$32,$41,$46,$41	;13 NYI
	dc.b	$51,$42,$32,$00,$46,$00	;14 NYR
	dc.b	$4A,$35,$39,$52,$46,$00	;15 OTW
	dc.b	$45,$37,$45,$33,$00,$33	;16 PHI
	dc.b	$34,$45,$34,$47,$46,$47	;17 PIT
	dc.b	$48,$49,$48,$00,$46,$49	;18 QUE
	dc.b	$4A,$4A,$4B,$4C,$4D,$4E	;19 SJ
	dc.b	$50,$42,$42,$50,$46,$43	;20 STL
	dc.b	$51,$52,$52,$00,$46,$00	;21 TB
	dc.b	$34,$34,$53,$00,$46,$00	;22 TOR
	dc.b	$43,$42,$54,$00,$46,$00	;23 VAN
	dc.b	$3F,$32,$3F,$00,$46,$4A	;24 WSH
	dc.b	$32,$3F,$55,$00,$46,$00	;25 WPG
	dc.b	$51,$42,$32,$00,$46,$00	;26 ASE
	dc.b	$51,$42,$32,$00,$46,$00	;27 ASW
RandomSongs							;8 songs ChooseSong picks from at random
	IF (RandomSongs-TeamSongs)/6<>NumTeams
	inform 3,"TeamSongs does not match the team count"
	ENDIF
	dc.b	$33,$3D,$3E,$41,$33,$47,$4E,$4F

;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
;
;The 94 sound driver as 95 keeps it (nothing calls it). The 94 source with the 95 changes
;
;<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<

z80_bus_release_delay				;Z80 busy: give the bus back, wait, then falls into
									;UploadCommandBufferToZ80 to retry
	clr.w	(IO_Z80BUS).l
	moveq	#$64,d0
.delay
	dbf	d0,.delay
UploadCommandBufferToZ80			;Copy the 33 byte command buffer (Z80_command_buffer) to Z80 RAM $02 once
									;the Z80 is idle (Z80 RAM $97 = 0, $96 = $7D)
	move.w	d0,-(sp)				;pause the 95 sound driver (SndPauseZ80) where 94 took the Z80 bus
	move.w	#$D,d0
	jsr	(SoundCmd).l
	move.w	(sp)+,d0
	movea.l	#Z80_RAM,a0
	cmpi.b	#0,$97(a0)
	bne.s	z80_bus_release_delay
	cmpi.b	#$7D,$96(a0)
	bne.s	z80_bus_release_delay
	move.b	#$D1,$96(a0)
	move.b	#0,$97(a0)
	adda.w	#2,a0
	movea.w	#(Z80_command_buffer-M68K_RAM),a1
	moveq	#$20,d0
.copy
	move.b	(a1)+,(a0)+
	dbf	d0,.copy
	clr.w	(IO_Z80BUS).l
rtscmd10							;The shared rts; handle_command_10 branches to it
	rts
ProcessOneMusicTrack				;Count down track slot a5 (track d7) and run every event that is due
									;through command_jump_table. A 0
									;status ends the stream; a non-negative long at +2 is a loop pointer.
									;Called from p_music_vblank
	subq.w	#1,4(a5)
	bpl.w	rtsfx
.event
	tst.w	(a5)
	bmi.w	rtsfx
	movea.l	(a5),a0
	addq.l	#4,(a5)
	clr.w	4(a5)
	move.b	4(a0),5(a5)
	move.b	1(a0),d0
	bne.w	.cmd
	st	(a5)
	tst.w	2(a0)
	bmi.w	rtsfx
	move.l	2(a0),(a5)
	bra.s	.event
.cmd
	move.b	1(a0),d0
	andi.w	#$70,d0					;status bits 6-4
	lsr.w	#3,d0
	lea	command_jump_table(pc),a2
	adda.w	0(a2,d0.w),a2
	jsr	(a2)
	bra.s	ProcessOneMusicTrack
command_jump_table					;Event handlers by status bits 6-4, as offsets from the table.
									;94 adds handle_command_30
	dc.w	handle_command_00-command_jump_table
	dc.w	handle_command_10-command_jump_table
	dc.w	handle_command_skip-command_jump_table
	dc.w	handle_command_30-command_jump_table
	dc.w	handle_command_40-command_jump_table
	dc.w	handle_command_skip-command_jump_table
	dc.w	handle_command_60-command_jump_table
	dc.w	handle_command_skip-command_jump_table
handle_command_00					;Event $0x: key off note +2 on channel +1 bits 3-0 of track d7. Also
									;entered from handle_command_10 (volume 0). Falls into
									;ReleaseChannelAndNote
	move.b	1(a0),d0
	andi.w	#$F,d0
	asl.w	#3,d0
	or.w	d7,d0
	asl.w	#8,d0
	move.b	2(a0),d0
	movea.w	#(fm_track_slots-M68K_RAM),a2
	moveq	#5,d1
.find
	subq.w	#8,a2
	cmp.w	(a2),d0
	dbeq	d1,.find
	bne.w	rtsfx
	btst	#0,6(a2)
	dbne	d1,.find
	beq.w	rtsfx
ReleaseChannelAndNote				;Key off channel struct a2 if it is on. The PCM patches ($60 up) stop the
									;PCM channel (StopPCMChannel)
	bclr	#0,6(a2)
	beq.w	rtsfx
	cmpi.b	#$60,3(a2)
	bge.w	StopPCMChannel
	move.b	4(a2),d0
	bset	d0,(Z80_command_buffer).w
	st	(music_needs_z80_update).w
	rts
StopPCMChannel						;Clear Z80 RAM $8E (Z80_RAM+$8E, the PCM rate byte written by
									;UpdateChannelFrequencyAndVolume): stops the PCM channel
	move.w	d0,-(sp)				;pause the 95 sound driver (SndPauseZ80) where 94 took the Z80 bus
	move.w	#$D,d0
	jsr	(SoundCmd).l
	move.w	(sp)+,d0
	clr.b	(Z80_RAM+$8E).l
	clr.w	(IO_Z80BUS).l
rtsfx								;The shared rts (94 had it in play_sfx_or_music_track, not in 95).
									;ProcessOneMusicTrack, handle_command_00 and StartSong branch here
	rts
handle_command_10					;Event $1x: key on note +2 at volume +3 on channel +1 bits 3-0 of track d7
									;(volume 0 = key off). An FM patch takes a free channel or the oldest one;
									;a PCM patch ($60 up) sets the sample start / end (pcm_sample_table) in
									;Z80 RAM $23-$28. Then the volume (SetChannelVolume) and the frequency
									;(UpdateChannelFrequencyAndVolume)
	tst.b	3(a0)
	beq.s	handle_command_00		;volume 0: key off
	movea.w	#(fm_channel_struct6-M68K_RAM),a2
	lea	(fm_voice_usage_table).w,a3
	move.b	1(a0),d0
	andi.w	#$F,d0
	asl.w	#3,d0
	or.w	d7,d0
	move.w	d0,d6
	asl.w	#3,d0
	move.b	3(a3,d0.w),d0
	cmp.b	#$60,d0
	bge.w	.pcm					;PCM patch
	subq.w	#8,a2
	moveq	#4,d1
	bra.w	.setold
.old
	cmp.b	5(a2),d2
	bhi.w	.nextold
.setold
	movea.w	a2,a4
	move.b	5(a4),d2
.nextold
	subq.w	#8,a2
	dbf	d1,.old
	moveq	#4,d1
	movea.w	#(fm_channel_struct6-M68K_RAM),a2
.free
	subq.w	#8,a2
	btst	#0,6(a2)
	dbeq	d1,.free
	bne.w	.0
	movea.w	a2,a4
	cmp.b	3(a4),d0
	dbeq	d1,.free
	beq.w	.keyon
	bra.w	.patch
.0
	cmp.b	3(a4),d0
	beq.w	.keyon
.patch
	movea.w	a4,a2
.1
	move.b	d0,3(a2)
	clr.w	d1
	move.b	4(a2),d1
	bset	d1,(Z80_command_buffer+4).w
	movea.w	#(per_channel_patch_table-M68K_RAM),a4
	move.b	d0,0(a4,d1.w)
	st	(music_needs_z80_update).w
.keyon
	clr.b	5(a2)
	bset	#0,6(a2)
	move.b	d6,(a2)
	move.b	2(a0),1(a2)
	move.b	3(a0),2(a2)
	clr.w	d1
	move.b	4(a2),d1
	bset	d1,(Z80_command_buffer).w
	bset	d1,(Z80_command_buffer+1).w
	bsr.w	SetChannelVolume
	bra.w	UpdateChannelFrequencyAndVolume
.pcm
	bset	#0,6(a2)
	beq.w	.pcmon
	cmp.b	3(a2),d0
	ble.w	rtscmd10
.pcmon
	move.b	d0,3(a2)
	clr.b	5(a2)
	move.b	d6,(a2)
	move.b	2(a0),1(a2)
	move.b	3(a0),2(a2)
	ext.w	d0
	subi.w	#$60,d0
	asl.w	#3,d0
	lea	pcm_sample_table(pc),a1		;PCM sample start, end longs by patch - $60
	move.l	4(a1,d0.w),d1
	move.l	0(a1,d0.w),d0
	move.w	d0,-(sp)				;pause the 95 sound driver (SndPauseZ80) where 94 took the Z80 bus
	move.w	#$D,d0
	jsr	(SoundCmd).l
	move.w	(sp)+,d0
	movea.l	#Z80_RAM,a1
	move.b	d0,$25(a1)
	lsr.w	#8,d0
	move.b	d0,$24(a1)
	swap	d0
	move.b	d0,$23(a1)
	move.b	d1,$28(a1)
	lsr.w	#8,d1
	move.b	d1,$27(a1)
	swap	d1
	move.b	d1,$26(a1)
	move.b	#$29,$96(a1)
	move.b	#0,$97(a1)
	clr.w	(IO_Z80BUS).l
	bsr.w	SetChannelVolume
UpdateChannelFrequencyAndVolume		;Set the frequency of channel struct a2 from its note and the pitch bend
									;of its key (a3 = voice table, word +0 = bend). Called from
									;handle_command_60 and handle_command_10
	clr.l	d3
	move.b	1(a2),d3
	divu.w	#$C,d3					;d3 = octave, high word = note in the octave
	move.w	d3,-(sp)
	swap	d3
	add.w	d3,d3
	lea	.fnum(pc),a4
	move.w	0(a4,d3.w),d2
	clr.w	d1
	move.b	(a2),d1
	asl.w	#3,d1
	move.w	0(a3,d1.w),d3
	beq.w	.nobend
	moveq	#$C,d1
	cmpi.b	#$60,3(a2)
	bge.w	.0
	move.b	3(a2),d1
	asl.w	#5,d1
	lea	(fm_instrument_patches).l,a4	;32 bytes per patch
	move.b	$1E(a4,d1.w),d1			;byte $1E = pitch bend scale
	ext.w	d1
.0
	muls.w	d1,d3
	asr.l	#2,d3
	asr.w	#7,d3
	addi.w	#$C0,d3					;centre of .bendtab
	add.w	d3,d3
	lea	.bendtab(pc),a4
	mulu.w	0(a4,d3.w),d2
	asl.l	#1,d2
	swap	d2
.nobend
	move.w	(sp)+,d3
	cmpi.b	#$60,3(a2)
	bge.w	.1
	asl.w	#3,d3
	asl.w	#8,d3
	or.w	d3,d2
	clr.w	d3
	move.b	4(a2),d3
	bset	d3,(Z80_command_buffer+3).w
	add.w	d3,d3
	movea.w	#(per_channel_frequency_table-M68K_RAM),a4
	move.w	d2,0(a4,d3.w)
	st	(music_needs_z80_update).w
	rts
.1
	btst	#0,6(a2)
	beq.w	.x
	move.w	d0,-(sp)				;pause the 95 sound driver (SndPauseZ80) where 94 took the Z80 bus
	move.w	#$D,d0
	jsr	(SoundCmd).l
	move.w	(sp)+,d0
	neg.w	d3
	addq.w	#8,d3
	lsr.w	d3,d2
	move.b	d2,(Z80_RAM+$8E).l
	clr.w	(IO_Z80BUS).l
.x
	rts
.fnum								;Frequency number of each note in the octave
	dc.w	$0146,$0159,$016E,$0184,$019B,$01B3,$01CD,$01E8,$0205,$0224,$0245,$0268
.bendtab							;385 factors, entry $C0 = $8000 (no bend)
	dc.w	$4000,$403B,$4076,$40B2,$40EE,$412A,$4166,$41A3,$41E0,$421D
	dc.w	$425A,$4297,$42D5,$4313,$4351,$438F,$43CE,$440D,$444C,$448B
	dc.w	$44CA,$450A,$454A,$458A,$45CA,$460B,$464C,$468D,$46CE,$4710
	dc.w	$4752,$4794,$47D6,$4818,$485B,$489E,$48E1,$4925,$4969,$49AD
	dc.w	$49F1,$4A35,$4A7A,$4ABF,$4B04,$4B4A,$4B8F,$4BD5,$4C1B,$4C62
	dc.w	$4CA9,$4CF0,$4D37,$4D7E,$4DC6,$4E0E,$4E56,$4E9F,$4EE8,$4F31
	dc.w	$4F7A,$4FC4,$500E,$5058,$50A2,$50ED,$5138,$5183,$51CE,$521A
	dc.w	$5266,$52B2,$52FF,$534C,$5399,$53E6,$5434,$5482,$54D0,$551F
	dc.w	$556E,$55BD,$560C,$565C,$56AC,$56FC,$574C,$579D,$57EE,$5840
	dc.w	$5891,$58E3,$5936,$5988,$59DB,$5A2E,$5A82,$5AD6,$5B2A,$5B7E
	dc.w	$5BD3,$5C28,$5C7D,$5CD3,$5D29,$5D7F,$5DD6,$5E2D,$5E84,$5EDB
	dc.w	$5F33,$5F8B,$5FE4,$603D,$6096,$60EF,$6149,$61A3,$61FD,$6258
	dc.w	$62B3,$630E,$636A,$63C6,$6423,$647F,$64DC,$653A,$6597,$65F6
	dc.w	$6654,$66B3,$6712,$6771,$67D1,$6831,$6892,$68F2,$6954,$69B5
	dc.w	$6A17,$6A79,$6ADC,$6B3F,$6BA2,$6C06,$6C6A,$6CCE,$6D33,$6D98
	dc.w	$6DFD,$6E63,$6EC9,$6F30,$6F97,$6FFE,$7066,$70CE,$7136,$719F
	dc.w	$7208,$7272,$72DC,$7346,$73B1,$741C,$7488,$74F4,$7560,$75CD
	dc.w	$763A,$76A7,$7715,$7783,$77F2,$7861,$78D0,$7940,$79B0,$7A21
	dc.w	$7A92,$7B04,$7B76,$7BE8,$7C5B,$7CCE,$7D41,$7DB5,$7E2A,$7E9F
	dc.w	$7F14,$7F89,$8000,$8076,$80ED,$8164,$81DC,$8254,$82CD,$8346
	dc.w	$83C0,$843A,$84B4,$852F,$85AA,$8626,$86A2,$871F,$879C,$881A
	dc.w	$8898,$8916,$8995,$8A14,$8A94,$8B14,$8B95,$8C16,$8C98,$8D1A
	dc.w	$8D9D,$8E20,$8EA4,$8F28,$8FAC,$9031,$90B7,$913D,$91C3,$924A
	dc.w	$92D2,$935A,$93E2,$946B,$94F4,$957E,$9609,$9694,$971F,$97AB
	dc.w	$9837,$98C4,$9952,$99E0,$9A6E,$9AFD,$9B8D,$9C1D,$9CAD,$9D3E
	dc.w	$9DD0,$9E62,$9EF5,$9F88,$A01C,$A0B0,$A145,$A1DA,$A270,$A306
	dc.w	$A39D,$A435,$A4CD,$A565,$A5FE,$A698,$A732,$A7CD,$A868,$A904
	dc.w	$A9A1,$AA3E,$AADC,$AB7A,$AC18,$ACB8,$AD58,$ADF8,$AE99,$AF3B
	dc.w	$AFDD,$B080,$B123,$B1C7,$B26C,$B311,$B3B7,$B45D,$B504,$B5AC
	dc.w	$B654,$B6FD,$B7A7,$B851,$B8FB,$B9A6,$BA52,$BAFF,$BBAC,$BC5A
	dc.w	$BD08,$BDB7,$BE67,$BF17,$BFC8,$C07A,$C12C,$C1DF,$C292,$C346
	dc.w	$C3FB,$C4B1,$C567,$C61D,$C6D5,$C78D,$C846,$C8FF,$C9B9,$CA74
	dc.w	$CB2F,$CBEC,$CCA8,$CD66,$CE24,$CEE3,$CFA2,$D063,$D124,$D1E5
	dc.w	$D2A8,$D36B,$D42E,$D4F3,$D5B8,$D67E,$D744,$D80C,$D8D4,$D99D
	dc.w	$DA66,$DB30,$DBFB,$DCC7,$DD93,$DE60,$DF2E,$DFFD,$E0CC,$E19D
	dc.w	$E26D,$E33F,$E411,$E4E5,$E5B9,$E68D,$E763,$E839,$E910,$E9E8
	dc.w	$EAC0,$EB9A,$EC74,$ED4F,$EE2A,$EF07,$EFE4,$F0C2,$F1A1,$F281
	dc.w	$F361,$F443,$F525,$F608,$F6EC,$F7D0,$F8B6,$F99C,$FA83,$FB6B
	dc.w	$FC54,$FD3E,$FE28,$FF13,$FF13
SetChannelVolume					;Set the volume of channel struct a2: note volume (+2) * the voice volume
									;(voice table +4) / 128. FM: attenuation from
									;veltab (volume / 8); PCM: Z80 RAM $83 (Z80_RAM+$83, at least 3). Called
									;from handle_command_10 and handle_command_30
	movem.l	d0,-(sp)
	clr.w	d0
	move.b	2(a2),d0
	clr.w	d1
	move.b	(a2),d1
	asl.w	#3,d1
	mulu.w	4(a3,d1.w),d0
	lsr.w	#7,d0
	cmpi.b	#$60,3(a2)
	bge.w	.0
	lea	.veltab(pc),a4
	lsr.w	#3,d0
	move.b	0(a4,d0.w),d0
	clr.w	d3
	move.b	4(a2),d3
	movea.w	#(per_channel_attenuation_table-M68K_RAM),a4
	move.b	d0,0(a4,d3.w)
	bset	d3,(Z80_command_buffer+2).w
	st	(music_needs_z80_update).w
	movem.l	(sp)+,d0
	rts
.veltab								;Attenuation by volume / 8
	dc.b	$1A,$18,$16,$14,$12,$10,$0E,$0C,$0A,$08,$06,$04,$03,$02,$01,$00
.0
	move.w	d0,-(sp)				;pause the 95 sound driver (SndPauseZ80) where 94 took the Z80 bus
	move.w	#$D,d0
	jsr	(SoundCmd).l
	move.w	(sp)+,d0
	lsr.b	#2,d0
	cmp.w	#3,d0
	bgt.w	.1
	moveq	#3,d0
.1
	move.b	d0,(Z80_RAM+$83).l
	clr.w	(IO_Z80BUS).l
	movem.l	(sp)+,d0
	rts
handle_command_40					;Event $4x: set the patch of channel +1 bits 3-0 of track d7 to +2 (voice
									;table +3)
	lea	(fm_voice_usage_table).w,a3
	move.b	1(a0),d0
	andi.w	#$F,d0
	asl.w	#3,d0
	or.w	d7,d0
	asl.w	#3,d0
	move.b	2(a0),3(a3,d0.w)
	rts
handle_command_60					;Event $6x: set the pitch bend of channel +1 bits 3-0 of track d7 to word
									;+2 - $2000, and update the frequency of every channel with that key
	lea	(fm_voice_usage_table).w,a3
	move.b	1(a0),d0
	andi.w	#$F,d0
	asl.w	#3,d0
	or.w	d7,d0
	move.w	d0,d4
	asl.w	#3,d0
	move.w	2(a0),0(a3,d0.w)
	subi.w	#$2000,0(a3,d0.w)
	movea.w	#(fm_channel_structs-M68K_RAM),a2
	moveq	#5,d0
.loop
	cmp.b	(a2),d4
	bne.w	.next
	bsr.w	UpdateChannelFrequencyAndVolume
.next
	addq.w	#8,a2
	dbf	d0,.loop
	rts
handle_command_30					;Event $3x, controller +2 = +3 on channel +1 bits 3-0 of track d7. Only
									;controller 7 (volume) is used: set the voice volume (voice table +5) and
									;update the volume of every channel with that key (SetChannelVolume)
	cmpi.b	#7,2(a0)
	beq.w	.0
	rts
.0
	lea	(fm_voice_usage_table).w,a3
	move.b	1(a0),d0
	andi.w	#$F,d0
	asl.w	#3,d0
	or.w	d7,d0
	move.w	d0,d4
	asl.w	#3,d0
	move.b	3(a0),5(a3,d0.w)
	movea.w	#(fm_channel_structs-M68K_RAM),a2
	moveq	#5,d0
.loop
	cmp.b	(a2),d4
	bne.w	.next
	bsr.w	SetChannelVolume
.next
	addq.w	#8,a2
	dbf	d0,.loop
	rts
handle_command_skip					;Events $2x, $5x and $7x: ignored
	rts
p_initialZ80						;(initialization). Free all slots, load the Z80 program (Z80_Program_Code,
									;$295 bytes) into Z80 RAM, build 29
									;tables of 256 bytes below Z80 RAM $2000 (Z80_RAM+$2000; (x - $80) * 8 / n
									;+ $80 for n = 8-$24), then reset and start the Z80. Called from Begin
	movem.l	d0-d2/a0-a2,-(sp)
	bsr.w	ClearAllTrackAndSFXSlots
	move.w	#$100,(IO_Z80RES).l
	move.w	#$100,(IO_Z80BUS).l		;95 keeps the 94 bus request here
.loop
	btst	#0,(IO_Z80BUS).l
	bne.s	.loop
	movea.l	#Z80_Program_Code,a1
	movea.l	#Z80_RAM,a2
	move.w	#$294,d0				;$295 bytes
.loop2
	move.b	(a1)+,(a2)+
	dbf	d0,.loop2
	movea.l	#Z80_RAM+$2000,a2
	moveq	#8,d2
	move.l	#$1C,d3
.loop3
	move.w	#$FF,d0
.loop4
	move.w	d0,d1
	subi.w	#$80,d1
	asl.w	#3,d1
	ext.l	d1
	divs.w	d2,d1
	addi.w	#$80,d1
	move.b	d1,-(a2)
	dbf	d0,.loop4
	clr.b	(a2)
	addq.w	#1,d2
	dbf	d3,.loop3
	move.w	#0,(IO_Z80RES).l
	move.w	#0,(IO_Z80BUS).l
	move.w	#$1F4,d0
.loop5
	dbf	d0,.loop5
	move.w	#$100,(IO_Z80RES).l
	clr.b	(music_needs_z80_update).w
	movem.l	(sp)+,d0-d2/a0-a2
	rts
ClearAllTrackAndSFXSlots			;95 cuts it down to PlayingSong = -1 (94 freed the 8 track slots and reset
									;the 6 channel structs)
	move.w	#$FFFF,(PlayingSong).w
	rts

newcheck							;Start a new check sound: one of 4 sounds $1C-$1F, never the last one
									;again. Called from checkcx and FallDown
	move.l	d0,-(sp)
	moveq	#3,d0
	jsr	(randomd0).l				;bsr.w
	addq.w	#1,d0					;1-3 sounds on from the last one
	add.w	(ltack).w,d0			;last tackle sound
	andi.w	#3,d0
	move.w	d0,(ltack).w
	addi.w	#$1C,d0					;first check sound (92 used 18)
	move.w	d0,-(sp)
	bsr.w	sfx
	move.l	(sp)+,d0
	rts

;	The PCM samples and FM patches of the old sound driver (unchanged from 94). The old driver above points at
;	them.
pcm_sample_table					;(sample address, 0) for PCM patches $60-$6E (lea in handle_command_10)
	dc.l	sfx_puckget_pcm,0		;patch $60
	dc.l	sfx_pass_pcm,0			;patch $61
	dc.l	sfx_shotbh_pcm,0		;patch $62
	dc.l	sfx_shotfh_pcm,0		;patch $63
	dc.l	sfx_check2_pcm,0		;patch $64
	dc.l	sfx_check_pcm,0			;patch $65
	dc.l	sfx_playerwall_pcm,0	;patch $66
	dc.l	sfx_hithigh_pcm,0		;patch $67
	dc.l	0,0						;patch $68
	dc.l	0,0						;patch $69
	dc.l	sfx_hithigh_pcm,0		;patch $6A
	dc.l	sfx_crowdboo_pcm,0		;patch $6B
	dc.l	sfx_oooh_pcm,0			;patch $6C
	dc.l	sfx_crowdcheer_pcm,0	;patch $6D
	dc.l	sfx_bglass_pcm,0		;patch $6E
sfx_shotbh_pcm
	incbin	..\Extracted\NHL95\Sound\sfx_shotbh_pcm.bin	;sample 2: shotbh
	even
sfx_pass_pcm
	incbin	..\Extracted\NHL95\Sound\sfx_pass_pcm.bin	;sample 1: pass
	dc.b	$FF						;pad: retail leftover byte
sfx_oooh_pcm
	incbin	..\Extracted\NHL95\Sound\sfx_oooh_pcm.bin	;sample 12: oooh, sfx_oooh2, sfx_bglass
	even
sfx_crowdboo_pcm
	incbin	..\Extracted\NHL95\Sound\sfx_crowdboo_pcm.bin	;sample 11: crowdboo
	dc.b	$FF						;pad: retail leftover byte
sfx_check_pcm
	incbin	..\Extracted\NHL95\Sound\sfx_check_pcm.bin	;sample 5: check1, check3
	even
sfx_crowdcheer_pcm
	incbin	..\Extracted\NHL95\Sound\sfx_crowdcheer_pcm.bin	;sample 13: crowdcheer, homewin
	even
sfx_bglass_pcm
	incbin	..\Extracted\NHL95\Sound\sfx_bglass_pcm.bin	;sample 14: sfx_bglass
	dc.b	$FF						;pad: retail leftover byte
sfx_playerwall_pcm
	incbin	..\Extracted\NHL95\Sound\sfx_playerwall_pcm.bin	;sample 6: playerwall, sfx_playerwall2-23
	even
sfx_check2_pcm
	incbin	..\Extracted\NHL95\Sound\sfx_check2_pcm.bin	;sample 4: check2, check4
	dc.b	$FF						;pad: retail leftover byte
sfx_hithigh_pcm
	incbin	..\Extracted\NHL95\Sound\sfx_hithigh_pcm.bin	;samples 7 and 10: hithigh, hitlow, check1-4,
															;songs $32 and $35-$37
	even
sfx_shotfh_pcm
	incbin	..\Extracted\NHL95\Sound\sfx_shotfh_pcm.bin	;sample 3: shotfh
	even
sfx_puckget_pcm
	incbin	..\Extracted\NHL95\Sound\sfx_puckget_pcm.bin	;sample 0: puckget
	even
fm_instrument_patches				;32 FM patches x 32 bytes, byte $1E = pitch bend scale
									;(UpdateChannelFrequencyAndVolume)
	incbin	..\Extracted\NHL95\Sound\fm_instrument_patches.bin	;32 FM patches x 32 bytes (byte $1E = pitch
																;bend scale)
	even
