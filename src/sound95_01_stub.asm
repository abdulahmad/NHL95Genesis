;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
;
;	sound95_01 segment stub. Retail $0676D8-$079901.
;
;<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<

; region code
	org	$676D8

; includes for stubs to replace removed code
	include	stubinc\ports.inc	;IO_* / VDP_* ports
	include	stubinc\equals.inc	;VDP status bits
	include	ram95.asm		;RAM map

; External addresses outside $0676D8-$079901, read from lst/nhl95.bin.
SndDriver = $AF44		;sounddrv95
randomd0 = $7C63A		;video95_02
Z80_Program_Code = $7E0E0	;The 94 Z80 program, still loaded by p_initialZ80 (sound95_02)

; Main segment code
	include	sound95_01.asm
