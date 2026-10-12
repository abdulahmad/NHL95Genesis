;	The old Z80 sound program, still loaded by p_initialZ80 (which nothing calls).

Z80_Program_Code	;First byte of the Z80 program (movea.l in p_initialZ80). p_initialZ80 copies $295
	;bytes from here
	dc.b	$18
	incbin	..\Extracted\NHL95\Sound\z80_snd_drv93.bin	;the Z80 driver after its first byte, up to the ld bc of the FM patch bank address
	dc.b	fm_instrument_patches&$FF,((fm_instrument_patches>>8)&$7F)|$80	;Z80 ld bc,$8000+(fm_instrument_patches&$7FFF): bank window address of the FM patches
	dc.b	$09,$3E,fm_instrument_patches>>15	;Z80 add hl,bc / ld a,bank (32K bank) of the FM patches
	incbin	..\Extracted\NHL95\Sound\z80_snd_drv93_end.bin	;rest of the Z80 driver
	dc.b	$FF			;pad: retail leftover byte (94 $FF)
