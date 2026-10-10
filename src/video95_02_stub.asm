;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
;
;	video95_02 segment stub. Retail $07A02A-$07A761.
;
;<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<

; region code
	org	$7A02A

; includes for stubs to replace removed code
	include	stubinc\ports.inc	;IO_* / VDP_* ports
	include	stubinc\equals.inc	;VDP status bits
	include	ram95.asm		;RAM map

; External addresses outside $07A02A-$07A761, read from lst/nhl95.bin.
SoundCmd = $676D8		;sound95_01
sfx = $677AC			;sound95_01
DoDMA_clearCallbackPointer = $79AC0	;bra.w / (video95_01)
DecompressGraphics = $79AC4	;video95_01
DoDMApro = $79AFE		;video95_01
forcefade = $79B24		;video95_01
cramfade = $79B54		;video95_01
xyVmMap = $79C18		;video95_01
remap = $79C42			;video95_01
DumpSprites = $79C94		;video95_01
DumpSprites2 = $79C98		;video95_01
Framermap = $14C148		;#. Framer map, tiles at +8 (graphics95_01)
Framermap2 = $14C308		;#. Second framer map, tiles at +8 (graphics95_01)

; Main segment code
	include	video95_02.asm
