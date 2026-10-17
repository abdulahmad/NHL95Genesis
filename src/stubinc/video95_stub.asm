;	Segment build for video95.asm: sets its origin and the outside routines and data it uses,
;	then includes video95.asm on its own for checking against the ROM.

	include	macros\genesis.mac		;String
; region code
	org	$79902

; includes for stubs to replace removed code
	include	stubinc\ports.inc		;IO_* / VDP_* ports
	include	stubinc\equals.inc		;VDP status bits
	include	ram95.asm				;RAM map

; External addresses outside, read from lst/nhl95.bin.
SoundCmd = $676D8
sfx = $677AC
find3d = $7C5EE
Rinktilelist = $C4A7C				;Rink map
Sprites = $CA56A					;Sprite frames and tiles
Framermap = $14C148
Framermap2 = $14C308				;#. Second framer map, tiles at +8
RevRinkTilelist = $16060E			;Reverse angle rink map

; Main segment code
	include	engine\video95.asm
