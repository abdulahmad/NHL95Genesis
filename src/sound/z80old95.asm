;	The old Z80 sound program, still loaded by p_initialZ80 (which nothing calls).

Z80_Program_Code					;First byte of the Z80 program (movea.l in p_initialZ80). p_initialZ80
									;copies Z80ProgramLen ($295) bytes from here
	;The old (93 / 94) Z80 driver, src/sound/z80_snd_drv93.asm, built by asm80 (tools/buildZ80.js), up to
	;the ld bc of the FM patch bank address
	incbin	..\output\obj\z80_snd_drv93.bin,0,$278
	;Z80 ld bc,$8000+(fm_instrument_patches&$7FFF): bank window address of the FM patches
	dc.b	fm_instrument_patches&$FF,((fm_instrument_patches>>8)&$7F)|$80
	dc.b	$09,$3E,fm_instrument_patches>>15	;Z80 add hl,bc / ld a,bank (32K bank) of the FM patches
	incbin	..\output\obj\z80_snd_drv93.bin,$27D,$E	;rest of the Z80 driver
	dc.b	$FF						;pad: retail leftover byte (94 $FF)
